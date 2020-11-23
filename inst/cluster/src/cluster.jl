module cluster


include("connect_spatial_tree.jl")
include("connect_spatial_recursive.jl")
include("connect_spatial_low.jl")
include("connect_spatial.jl")

include("connect_temporal.jl")
include("cluster_SpatioTemporal.jl")

# include("cluster_refactor.jl")
# include("cluster_EliminateSmall.jl")

include("replace_clusterId.jl")
include("countmap.jl")

end