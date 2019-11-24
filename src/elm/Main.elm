module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)



-- Model


type Page
    = Page String


type alias Model =
    { page : Page
    }


type Msg
    = NoOp
    | GoToPage String



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div [] [ text "Hello Elm" ]



-- Init


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { page = Page "home" }
    , Cmd.none
    )


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
