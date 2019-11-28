module Main exposing (main)

import Browser
import Html exposing (Html, Attribute, a, button, div, li, map, span, text, ul)
import Html.Attributes exposing ( class, href, style, type_)
import Html.Attributes.Aria exposing (role)
import Html.Events exposing (onClick)
import Pages.Characters as Characters
import Pages.Home as Home
import Pages.Movies as Movies
import Pages.Worlds as Worlds



-- Model


type Page
    = Page String


type Model
    = Home Home.Model
    | Movies Movies.Model
    | Characters Characters.Model
    | Worlds Worlds.Model


type Msg
    = NoOp
    | HomeMsg Home.Msg
    | MoviesMsg Movies.Msg
    | WorldsMsg Worlds.Msg
    | CharsMsg Characters.Msg



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        HomeMsg msg ->
            ( Home (Home.update msg), Cmd.none )

        MoviesMsg msg ->
            ( Movies (Movies.update msg), Cmd.none )

        WorldsMsg msg ->
            ( Worlds (Worlds.update msg), Cmd.none )

        CharsMsg msg ->
            ( Characters (Characters.update msg), Cmd.none )

        _ ->
            ( model, Cmd.none )



-- View


viewPage : Model -> Html Msg
viewPage model =
    case model of
        Home m ->
            -- capture Home.Msg(a) and convert them to HomeMsg Home.Msg
            map (\msg -> HomeMsg msg) (Home.view m)

        Movies m ->
            map (\msg -> MoviesMsg msg) (Movies.view m)

        Characters m ->
            map (\msg -> CharsMsg msg) (Characters.view m)

        Worlds m ->
            map (\msg -> WorldsMsg msg) (Worlds.view m)

getNavClass: Model -> String -> Attribute Msg
getNavClass model name =
    case model of
        Home _ ->
            class (if name == "Home" then "nav-item active" else "nav-item")

        Movies _ ->
            class (if name == "Movies" then "nav-item active" else "nav-item")

        Characters _ ->
            class (if name == "Characters" then "nav-item active" else "nav-item")

        Worlds _ ->
            class (if name == "Worlds" then "nav-item active" else "nav-item")

view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ ul [ class "nav" ]
            [ li [ getNavClass model "Home" ]
                [ span [ class "nav-link", onClick (HomeMsg Home.Open) ]
                    [ text "Home" ]
                ]
            , li [ getNavClass model "Movies" ]
                [ span [ class "nav-link", onClick (MoviesMsg Movies.Open) ]
                    [ text "Movies" ]
                ]
            , li [ getNavClass model "Worlds" ]
                [ span [ class "nav-link", onClick (WorldsMsg Worlds.Open) ]
                    [ text "Worlds" ]
                ]
            , li [ getNavClass model "Characters" ]
                [ span [ class "nav-link", onClick (CharsMsg Characters.Open) ]
                    [ text "Characters" ]
                ]
            ]
        , div [ class "page" ] [ viewPage model ]
        ]



-- Init


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Home Home.init
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
