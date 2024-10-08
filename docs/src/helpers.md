# Helpers

Some helper functions are made available in `NFLData.jl` for use in loading and cleaning data. Not all helper functions that are available in `{nflreadr}` have been translated to `NFLData.jl`, such as `nflreadr::join_coalesce()`--these functions are general enough that they are considered beyond the scope of this package.

```@docs
clean_player_names(player_name::String; lowercase::Bool = false, convert_lastfirst::Bool = true, use_name_database::Bool = true, convert_to_ascii::Bool = true)
```

```@docs
clean_homeaway(dataframe::AbstractDataFrame;invert=missing)
```

```@docs
most_recent_season(roster::Bool = false)
```

```@docs
get_current_week(use_date::Bool = false)
```

```@docs
clean_team_abbrs(team::String; current_location::Bool = true, keep_non_matches::Bool = true)
```

```@docs
nflverse_game_id(season::Number,week::Number,away::String,home::String)
```