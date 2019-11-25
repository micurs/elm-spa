module Pages.Movies exposing
    ( Model
    , Msg
    , update
    , view
    )

import Html exposing (Html, div, p, text)



-- Movies Page Model


type Movies
    = NotLoaded
    | Loaded (List String)
    | Failed String


type alias Model =
    { movies : Movies
    , message : String
    }


type Msg
    = LoadMovies
    | GotMovies Movies



-- Update


update : Msg -> Model
update action =
    { movies = NotLoaded
    , message = "click to load"
    }



-- Movies Page View


view : Model -> Html Msg
view model =
    p [] [ text model.message ]
