module Pages.Home exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Html exposing (Html, div, p, text)



-- Home Page Model


type Movies
    = Empty
    | Loading
    | Loaded (List String)
    | Failed String


type alias Model =
    { movies : Movies
    , message : String
    }


type Msg
    = Open



-- Update


update : Msg -> Model
update action =
    { movies = Empty
    , message = "click to load"
    }



-- Init


init : Model
init =
    { movies = Empty
    , message = "click to load"
    }



-- Home Page View


view : Model -> Html Msg
view m =
    p [] [ text "Start Wars Home page" ]
