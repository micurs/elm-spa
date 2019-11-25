module Main exposing (main)

import Browser
import Html exposing (Html, button, div, map, text)
import Html.Attributes exposing (class, style, type_)
import Html.Attributes.Aria exposing (role)
import Pages.Home as Home
import Pages.Movies as Movies



-- Model


type Page
    = Page String


type Model
    = Home Home.Model
    | Movies Movies.Model


type Msg
    = NoOp
    | HomeMsg Home.Msg
    | MoviesMsg Movies.Msg



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        HomeMsg msg ->
            ( Home (Home.update msg), Cmd.none )

        MoviesMsg msg ->
            ( Movies (Movies.update msg), Cmd.none )

        _ ->
            ( model, Cmd.none )



-- View


viewPage : Model -> Html Msg
viewPage model =
    case model of
        Home m ->
            -- capture Home.Msg(a) and convert them to HomeMsg Home.Msg
            map (\homeMsg -> HomeMsg homeMsg) (Home.view m)

        Movies m ->
            map (\moviesMsg -> MoviesMsg moviesMsg) (Movies.view m)


view : Model -> Html Msg
view model =
    div []
        [ div [ class "btn-group", role "group" ]
            [ button [ type_ "button", class "btn btn-secondary" ] [ text "Home" ]
            , button [ type_ "button", class "btn btn-secondary" ] [ text "Movies" ]
            , button [ type_ "button", class "btn btn-secondary" ] [ text "Characters" ]
            ]
        , div [] [ viewPage model ]
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
