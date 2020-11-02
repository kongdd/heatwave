# IdCluster: [nlat, nlon, ntime]
# cno: [ntime, ncluster]
function TimeConnect(
    IdClusters::AbstractArray{Int, 3}, 
    cno::AbstractArray{Int, 2}; 
    minOverlapCells::Int = 25, ID_min::Int = 0) 

    nlat, nlon, ntime = size(IdClusters)
    
    # mask to speed up replace_val
    mask = sum(IdClusters .> 0, dims = 3)[:, :, 1] .> 0 # 
    mask_ind = findall(mask)

    # cmax  = size(cno, 1)
    for t = 2:ntime
        cluster_now = @view(IdClusters[:, :, t])
        cluster_pre = @view(IdClusters[:, :, t-1])
        
        # The overlaped grids
        ind_overlap = (cluster_now .> ID_min) .& (cluster_pre .> ID_min) 
        ids_raw = cluster_now[ind_overlap] |> countmap
        ids_long = filter(x -> ( x[2] >= minOverlapCells ), ids_raw)
        ids_now = keys(ids_long)
        # NOs_no = cluster_now[ind_overlap] |> unique |> sort
        println("t = $t, clusters: ", length(ids_now))

        i = 0
        for id_now in ids_now
            i += 1
            if (mod(i, 1000) == 0); println("(t = $t, i = $i)"); end

            ind_now = findall(cluster_now .== id_now) #|> collect
            
            ids_pre = cluster_pre[ind_now]
            ids_pre = unique(ids_pre[ids_pre .> ID_min]) |> sort
            # println(ids_pre)

            for id_pre in ids_pre
                ncInter = 0
                for k in ind_now
                    if (cluster_pre[k] == id_pre); ncInter += 1; end
                end

                if ncInter >= minOverlapCells
                    # println((id_pre, id_now))
                    replace_IdCluster!(IdClusters, mask_ind, t, id_pre, id_now)
                    replace_cno!(cno, t, id_pre, id_now)
                end
            end
        end
    end
end

export TimeConnect