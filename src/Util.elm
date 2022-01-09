module Util exposing (..)

import Html exposing (a, div, h1, header, li, text, ul)
import Html.Attributes exposing (class, href)


viewHeader : Html.Html msg
viewHeader =
    header [ class "cluster", class "header" ]
        [ h1 [] [ text "Hayao's Portfolio" ]
        , ul [ class "cluster", class "header_list" ]
            [ li [] [ a [ href "#" ] [ text "top" ] ]
            , li [] [ a [ href "#" ] [ text "about" ] ]
            , li [] [ a [ href "#" ] [ text "career" ] ]
            , li [] [ a [ href "#" ] [ text "skill" ] ]
            ]
        ]
