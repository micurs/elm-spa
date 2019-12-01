module Pages.Movies exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Api exposing (ApiResponse, Items(..), Movie, dataToItems, getMovies, jsonToMovies)
import Bootstrap exposing (listItem, viewItems, viewTitle)
import Html exposing (Html, div, text)



-- Movies Page Model


type alias Movies =
    Items Movie


type alias Model =
    { movies : Movies
    , message : String
    }


type Msg
    = Open
    | GetMovies
    | GotMovies ApiResponse



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Open ->
            if model.movies == Empty then
                ( { model | message = "Loading Movies...", movies = Loading }, getMovies GotMovies )

            else
                ( model, Cmd.none )

        GetMovies ->
            ( { model | message = "Loading Movies...", movies = Loading }, getMovies GotMovies )

        GotMovies response ->
            case response of
                Ok data ->
                    ( { model | message = "StarWars Movies", movies = dataToItems (jsonToMovies data) }, Cmd.none )

                Err _ ->
                    ( { model | message = "Http Error - request failed" }, Cmd.none )



-- Init


init : Model
init =
    { movies = Empty
    , message = "StarWars movies"
    }



-- Movies Page View


viewMovie : Movie -> Html Msg
viewMovie movie =
    listItem [] [ text movie.title ]


view : Model -> Html Msg
view model =
    div []
        [ viewTitle GetMovies model.message
        , viewItems viewMovie model.movies
        ]
