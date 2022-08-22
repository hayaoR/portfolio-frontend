module Top exposing (..)

import Browser
import Html exposing (Html, div, h1, p, section, text)
import Html.Attributes exposing (class)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    {}


type Msg
    = None


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ _ =
    ( {}, Cmd.none )


view : Model -> Html Msg
view _ =
    section [ class "section is-large" ]
        [ div [ class "container" ]
            [ p [ class "title" ] [ text "Welcome To Hayao's Portfolio" ]
            , p [ class "substitute" ] [ text "I am an IT engineer before running out." ]
            ]
        ]
