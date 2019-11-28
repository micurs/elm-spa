module Pages.Characters exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Html exposing (Html, div, p, text)



-- Home Page Model


type Characters
    = Empty
    | Loading
    | Loaded (List String)
    | Failed String


type alias Model =
    { characters : Characters
    , message : String
    }


type Msg
    = Open
    | GotCharacters Characters



-- Update


update : Msg -> Model
update action =
    { characters = Empty
    , message = "click to load"
    }



-- Init


init : Model
init =
    { characters = Empty
    , message = "click to load"
    }



-- Characters Page View


view : Model -> Html Msg
view model =
    p [] [ text "Characters here" ]
