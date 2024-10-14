module ffverse
include("helpers.jl")
using .helpers

include("getdata.jl")
using .getdata

include("gameinfo.jl")
using .gameinfo

export load_ff_playerids, load_ff_rankings, load_ff_opportunity

"""
    load_ff_playerids()

Load fantasy football player ID mapping from the ffverse. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_ff_playerids.html).
"""
function load_ff_playerids()
    return from_url("https://github.com/dynastyprocess/data/raw/master/files/db_playerids", file_type = ".csv")
end

"""
    load_ff_rankings(type::AbstractString = "draft")

Load current fantasy football rankings from FantasyPros.com. The argument `type` has three valid parameters:
* `"draft"`: FantasyPros rankings for draft leagues for the current fantasy football season. The default parameter.
* `"week"`: FantasyPros rankings for players for the current week of the fantasy football season.
* `"all"`: Historical FantasyPros rankings for a variety of formats.

For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_ff_rankings.html).
"""
function load_ff_rankings(type::AbstractString = "draft")
    if !(type in ["draft","week","all"])
        throw(DomainError(type,"Please pass in one of \"draft\", \"week\", or \"all\" for the argument `type`!"))
    end
    if type == "draft"
        df = from_url("https://github.com/dynastyprocess/data/raw/master/files/db_fpecr_latest",file_type = ".csv")
    elseif type == "week"
        df = from_url("https://github.com/dynastyprocess/data/raw/master/files/fp_latest_weekly",file_type = ".csv")
    elseif type == "all"
        df = from_url("https://github.com/dynastyprocess/data/raw/master/files/db_fpecr")
    end
    return df
end

"""
    function load_ff_opportunity(seasons::Number = most_recent_season(), stat_type::AbstractString = "weekly", model_version::AbstractString = "latest")

Load the FFOpportunity dataset for a given season. `seasons` indicates the years to pull data from and defaults to the most recently played NFL season. Pass in `seasons = true` for all available seasons.
`stat_type` takes three potential arguments:
* `"weekly"`: Pull full FFOpportunity data, week by week. The default option.
* `"pbp_pass"`: Pull full FFOpportunity passing data, week by week.
* `"pbp_rush"`: Pull full FFOpportunity rushing data, week by week.

`model_version` takes two potential arguments:
* `"latest"`: Pull data produced by the latest FFOpportunity models.
* `"v1.0.0"`: Pull data produced by the original FFOpportunity models.

For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_ff_opportunity.html).
"""
function load_ff_opportunity(seasons = most_recent_season(), 
    stat_type::AbstractString = "weekly", 
    model_version::AbstractString = "latest")
    seasons = check_years(seasons, 2006, "FF opportunity data")
    if !(stat_type in ["weekly","pbp_pass","pbp_rush"])
        throw(DomainError(stat_type,"Please pass in one of \"weekly\",\"pbp_pass\",\"pbp_rush\" for the argument `stat_type`!"))
    end
    if !(model_version in ["latest","v1.0.0"])
        throw(DomainError(stat_type,"Please pass in one of \"latest\" or \"v1.0.0\" for the argument `model_version`!"))
    end
    df = reduce(vcat, from_url.("https://github.com/ffverse/ffopportunity/releases/download/$model_version-data/ep_$stat_type" * "_",seasons))
    return df
end

end