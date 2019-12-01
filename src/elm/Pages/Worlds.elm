module Pages.Worlds exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Api exposing (ApiResponse, World, dataToItems, getWorlds, jsonToWorlds)
import Bootstrap exposing (Items(..), listItem, viewItems, viewTitle)
import Html exposing (Html, div, text)



-- Home Page Model


type alias Worlds =
    Items World


type alias Model =
    { worlds : Worlds
    , message : String
    }


type Msg
    = Open
    | GetWorlds
    | GotWorlds ApiResponse



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Open ->
            if model.worlds == Empty then
                ( { model | message = "Loading Worlds...", worlds = Loading }, getWorlds GotWorlds )

            else
                ( model, Cmd.none )

        GetWorlds ->
            ( { model | message = "Loading Worlds...", worlds = Loading }, getWorlds GotWorlds )

        GotWorlds response ->
            case response of
                Ok data ->
                    ( { model | message = "StarWars Worlds", worlds = dataToItems (jsonToWorlds data) }, Cmd.none )

                Err _ ->
                    ( { model | message = "Http Error - request failed" }, Cmd.none )



-- Init


init : Model
init =
    { worlds = Empty
    , message = "StarWars Worlds"
    }



-- Worlds Page View


viewWorld : World -> Html Msg
viewWorld world =
    listItem [] [ text world.name ]


view : Model -> Html Msg
view model =
    div []
        [ viewTitle GetWorlds model.message
        , viewItems viewWorld model.worlds
        ]
