module Main exposing (Msg(..), main)

import Browser
import Html exposing (Attribute, Html, a, button, div, li, map, span, text, ul)
import Html.Attributes exposing (class, href, style, type_)
import Html.Attributes.Aria exposing (role)
import Html.Events exposing (onClick)
import Pages.Characters as Characters
import Pages.Home as Home
import Pages.Movies as Movies
import Pages.Worlds as Worlds



-- Model


type Page
    = Home
    | Movies
    | Characters
    | Worlds


type alias PageModels =
    { home : Home.Model
    , movies : Movies.Model
    , characters : Characters.Model
    , worlds : Worlds.Model
    }


type alias Model =
    { page : Page
    , pages : PageModels
    }


type Msg
    = HomeMsg Home.Msg
    | MoviesMsg Movies.Msg
    | WorldsMsg Worlds.Msg
    | CharsMsg Characters.Msg



-- Update


updateCurrPage : Model -> Bool -> Page -> PageModels -> Model
updateCurrPage model isOpen mewPage pageModels =
    if isOpen then
        { model | page = mewPage, pages = pageModels }

    else
        { model | pages = pageModels }


messageTo : (msg -> Msg) -> (msg -> Msg)
messageTo cnstr msg =
    cnstr msg


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    let
        currPages =
            model.pages

        newModel =
            updateCurrPage model
    in
    case action of
        HomeMsg homeAction ->
            let
                ( homemodel, homeCmd ) =
                    Home.update homeAction currPages.home

                newPageModels =
                    { currPages | home = homemodel }
            in
            ( newModel (homeAction == Home.Open) Home newPageModels
            , Cmd.map HomeMsg homeCmd
            )

        MoviesMsg moviesAction ->
            let
                ( moviesModel, moviesCmd ) =
                    Movies.update moviesAction currPages.movies

                newPageModels =
                    { currPages | movies = moviesModel }
            in
            ( newModel (moviesAction == Movies.Open) Movies newPageModels
            , Cmd.map MoviesMsg moviesCmd
            )

        WorldsMsg worldsAction ->
            let
                ( worldsModel, worldsCmd ) =
                    Worlds.update worldsAction currPages.worlds

                newPageModels =
                    { currPages | worlds = worldsModel }
            in
            ( newModel (worldsAction == Worlds.Open) Worlds newPageModels
            , Cmd.map WorldsMsg worldsCmd
            )

        CharsMsg charsAction ->
            let
                ( charsModel, charsCmd ) =
                    Characters.update charsAction currPages.characters

                newPageModels =
                    { currPages | characters = charsModel }
            in
            ( newModel (charsAction == Characters.Open) Characters newPageModels
            , Cmd.map CharsMsg charsCmd
            )


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        Home ->
            -- capture Home.Msg(a) and convert them to HomeMsg Home.Msg
            map (messageTo HomeMsg) (Home.view model.pages.home)

        Movies ->
            map (messageTo MoviesMsg) (Movies.view model.pages.movies)

        Characters ->
            map (messageTo CharsMsg) (Characters.view model.pages.characters)

        Worlds ->
            map (messageTo WorldsMsg) (Worlds.view model.pages.worlds)


getNavClass : Model -> String -> Attribute Msg
getNavClass model name =
    case model.page of
        Home ->
            class
                (if name == "Home" then
                    "nav-item active"

                 else
                    "nav-item"
                )

        Movies ->
            class
                (if name == "Movies" then
                    "nav-item active"

                 else
                    "nav-item"
                )

        Characters ->
            class
                (if name == "Characters" then
                    "nav-item active"

                 else
                    "nav-item"
                )

        Worlds ->
            class
                (if name == "Worlds" then
                    "nav-item active"

                 else
                    "nav-item"
                )


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
    ( { page = Home
      , pages =
            { home = Home.init
            , movies = Movies.init
            , characters = Characters.init
            , worlds = Worlds.init
            }
      }
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
