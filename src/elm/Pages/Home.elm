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
    { message : String
    }


type Msg
    = Open



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        _ ->
            ( model, Cmd.none )



-- Init


init : Model
init =
    { message = "click to load"
    }



-- Home Page View


view : Model -> Html Msg
view m =
    p [] [ text "Start Wars Home page" ]
