module Util exposing (..)
import Html exposing (div)
import Html.Attributes exposing (class)
import Html exposing (text)
import Html exposing (ul)
import Html exposing (li)
import Html exposing (a)
import Html.Attributes exposing (href)
import Html exposing (h1)
import Html exposing (header)

viewHeader : Html.Html msg
viewHeader =
    header [class "cluster", class "header"] [
        h1 [] [ text "Hayao's Portfolio"],
        ul [ class "cluster", class "header_list"]
            [ li [] [ a [ href "#"] [  text "top" ] ]
            , li [] [ a [ href "#"] [ text "about" ]]  
            , li [] [ a [ href "#"] [ text "career"]]  
            , li [] [ a [ href "#"] [ text "skill" ]]  
            ]
    ]