module Pages.Home exposing
    ( Model
    , Msg
    , init
    , update
    , view
    )

import Html exposing (Html, div, p, text)



-- Home Page Model


type Movies
    = NotLoaded
    | Loaded (List String)
    | Failed String


type alias Model =
    { movies : Movies
    , message : String
    }


type Msg
    = LoadCharacters
    | GotCharacters Movies



-- Update


update : Msg -> Model
update action =
    { movies = NotLoaded
    , message = "click to load"
    }



-- Init


init : Model
init =
    { movies = NotLoaded
    , message = "click to load"
    }



-- Home Page View


view : Model -> Html Msg
view model =
    p [] [ text model.message ]
