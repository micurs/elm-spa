module Bootstrap exposing (..)

import Html exposing (Html, div, h2, li, p, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Api exposing (Items(..))

addAttrClass c ma =
    List.append [ class c ] ma


primaryPanel =
    Html.div [ class "alert alert-primary mx-4 my-2" ]


errorPanel moreAttributes =
    Html.div (List.append [ class "alert alert-danger mx-4 my-2" ] moreAttributes)


primaryButton moreAttributes =
    Html.button (addAttrClass "btn btn-primary ml-2 my-2" moreAttributes)


listGroup moreAttributes =
    Html.ul (addAttrClass "list-group" moreAttributes)


listItem moreAttributes =
    Html.li (addAttrClass "list-group-item" moreAttributes)


viewTitle : msg -> String -> Html msg
viewTitle event title =
    div [ class "clearfix" ]
        [ primaryButton [ class "float-right", onClick event ] [ text "Refresh" ]
        , h2 [] [ text title ]
        ]




viewItems : (a -> Html msg) -> Items a -> Html msg
viewItems itemViewer items =
    case items of
        Loaded itemList ->
            listGroup [] (List.map itemViewer itemList)

        Failed why ->
            errorPanel []
                [ p [] [ text ("Format incorrect: " ++ why) ] ]

        _ ->
            p [] [ text "no items in this list" ]
