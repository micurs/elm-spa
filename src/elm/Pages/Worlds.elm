module Pages.Worlds exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Html exposing (Html, div, p, text)



-- Home Page Model


type Worlds
    = Empty
    | Loading
    | Loaded (List String)
    | Failed String


type alias Model =
    { worlds : Worlds, message : String }


type Msg
    = Open
    | GotWorlds Worlds



-- Update


update : Msg -> Model
update action =
    { worlds = Empty
    , message = "click to load"
    }



-- Init


init : Model
init =
    { worlds = Empty
    , message = "click to load"
    }



-- Worlds Page View


view : Model -> Html Msg
view model =
    p [] [ text "Worlds here" ]
