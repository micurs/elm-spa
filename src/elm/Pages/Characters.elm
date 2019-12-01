module Pages.Characters exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Api exposing (ApiResponse, Character, dataToItems, getCharacters, jsonToCharacters)
import Bootstrap exposing (Items(..), listItem, viewItems, viewTitle)
import Html exposing (Html, div, text)



-- Home Page Model


type alias Characters =
    Items Character


type alias Model =
    { characters : Characters
    , message : String
    }


type Msg
    = Open
    | GetCharacters
    | GotCharacters ApiResponse



---- Update ----


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Open ->
            if model.characters == Empty then
                ( { model | message = "Loading Characters...", characters = Loading }, getCharacters GotCharacters )

            else
                ( model, Cmd.none )

        GetCharacters ->
            ( { model | message = "Loading Characters...", characters = Loading }, getCharacters GotCharacters )

        GotCharacters response ->
            case response of
                Ok data ->
                    ( { model | message = "StarWars Characters", characters = dataToItems (jsonToCharacters data) }, Cmd.none )

                Err _ ->
                    ( { model | message = "Http Error - request failed" }, Cmd.none )



-- Init


init : Model
init =
    { characters = Empty
    , message = "StarWars Characters"
    }



-- Characters Page View


viewCharacter : Character -> Html Msg
viewCharacter character =
    listItem [] [ text character.name ]


view : Model -> Html Msg
view model =
    div []
        [ viewTitle GetCharacters model.message
        , viewItems viewCharacter model.characters
        ]
