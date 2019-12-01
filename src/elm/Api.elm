module Api exposing
    ( ApiResponse
    , Character
    , Movie
    , World
    , dataToItems
    , getCharacters
    , getMovies
    , getWorlds
    , jsonToCharacters
    , jsonToMovies
    , jsonToWorlds
    )

import Bootstrap exposing (Items(..))
import Http exposing (Error)
import Json.Decode as Decode
    exposing
        ( Decoder
        , field
        , int
        , list
        , map
        , map2
        , map5
        , map7
        , maybe
        , string
        )


type alias VehicleConnection =
    { id : String
    , name : String
    }


type alias FilmConnections =
    List FilmConnection


type alias FilmConnection =
    { id : String
    , title : String
    }


type alias StarshipConnections =
    List VehicleConnection


type alias WorldConnection =
    { id : String
    , name : String
    }


type alias Specie =
    { name : String }


type alias Movie =
    { id : String
    , title : String
    , openingCrawl : String
    , director : String
    , producers : List String
    , releaseDate : String
    , episodeID : Int
    }


type alias Character =
    { name : String
    , homeworld : WorldConnection
    , species : Maybe (List Specie)
    , birthYear : String
    , gender : String
    , starshipConnection : StarshipConnections
    , filmConnection : FilmConnections
    }


type alias World =
    { id : String
    , name : String
    , population : Maybe Int
    , climates : List String
    , filmConnection : FilmConnections
    }


type alias Vehicle =
    { id : String
    , name : String
    , model : String
    , vehicleClass : String
    , crew : String
    , filmConnection : FilmConnections
    }



--- JSON Decoders ----


vehicleConnections : Decoder StarshipConnections
vehicleConnections =
    Decode.at [ "starships" ]
        (list
            (map2 VehicleConnection
                (field "id" string)
                (field "name" string)
            )
        )


worldConnection : Decoder WorldConnection
worldConnection =
    map2 WorldConnection
        (field "id" string)
        (field "name" string)


filmConnections : Decoder (List FilmConnection)
filmConnections =
    Decode.at [ "films" ]
        (list
            (map2 FilmConnection
                (field "id" string)
                (field "title" string)
            )
        )


speciesDecoder : Decoder (List Specie)
speciesDecoder =
    list
        (map Specie
            (field "name" string)
        )


worldDecoder : Decoder World
worldDecoder =
    map5 World
        (field "id" string)
        (field "name" string)
        (field "population" (maybe int))
        (field "climates" (list string))
        (field "filmConnection" filmConnections)


movieDecoder : Decoder Movie
movieDecoder =
    map7 Movie
        (field "id" string)
        (field "title" string)
        (field "openingCrawl" string)
        (field "director" string)
        (field "producers" (list string))
        (field "releaseDate" string)
        (field "episodeID" int)


characterDecoder : Decoder Character
characterDecoder =
    map7 Character
        (field "name" string)
        (field "homeworld" worldConnection)
        (field "species" (maybe speciesDecoder))
        (field "birthYear" string)
        (field "gender" string)
        (field "starshipConnection" vehicleConnections)
        (field "filmConnection" filmConnections)


worldsDecoder : Decoder (List World)
worldsDecoder =
    Decode.at [ "data", "allPlanets", "planets" ] (list worldDecoder)


moviesDecoder : Decoder (List Movie)
moviesDecoder =
    Decode.at [ "data", "allFilms", "films" ] (list movieDecoder)


charactersDecoder : Decoder (List Character)
charactersDecoder =
    Decode.at [ "data", "allPeople", "people" ] (list characterDecoder)


jsonTo : Decoder a -> String -> Result Decode.Error a
jsonTo decoder data =
    Decode.decodeString decoder data


jsonToWorlds : String -> Result Decode.Error (List World)
jsonToWorlds =
    jsonTo worldsDecoder


jsonToMovies : String -> Result Decode.Error (List Movie)
jsonToMovies =
    jsonTo moviesDecoder


jsonToCharacters : String -> Result Decode.Error (List Character)
jsonToCharacters =
    jsonTo charactersDecoder


dataToItems : Result Decode.Error (List a) -> Items a
dataToItems decodeRes =
    case decodeRes of
        Ok list ->
            Loaded list

        Err err ->
            Failed (Decode.errorToString err)



---- GraphQL queries


swMovies : String
swMovies =
    """
{
  allFilms{
    films {
        id,
        title,
        openingCrawl,
        director,
        producers,
        releaseDate,
        episodeID,
        characterConnection { characters { id, name }}
    }
  }
}
"""


swWorlds =
    """
{
  allPlanets {
    planets {
      id,
      name,
      population,
      climates,
      filmConnection { films { id, title}}
    }
  }
}
"""


swCharacters =
    """
{
  allPeople {
    people {
      name,
      homeworld { id,  name},
      species { name },
      birthYear,
      gender,
      starshipConnection { starships { id, name }}
      filmConnection { films { id, title}}
    }
  }
}
"""


swVehicles =
    """
{
  allVehicles {
    vehicles {
      id,
      name,
      model,
      vehicleClass,
      crew,
      filmConnection { films { id, title }}
    }
  }
}
"""



---- GraphQL Requests ---


type alias ApiResponse =
    Result Error String


type alias ResponseHandler msg =
    ApiResponse -> msg


sendQuery : String -> ResponseHandler msg -> Cmd msg
sendQuery query handler =
    Http.request
        { method = "POST"
        , body = Http.stringBody "application/graphql" query
        , expect = Http.expectString handler
        , url = "https://swapi.apis.guru"
        , headers =
            [ Http.header "Accept" "application/json"
            ]
        , timeout = Just 5000
        , tracker = Just "Nothing"
        }


getMovies : ResponseHandler msg -> Cmd msg
getMovies handler =
    sendQuery swMovies handler


getWorlds : ResponseHandler msg -> Cmd msg
getWorlds handler =
    sendQuery swWorlds handler


getCharacters : ResponseHandler msg -> Cmd msg
getCharacters handler =
    sendQuery swCharacters handler
