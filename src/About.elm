module About exposing (..)

import Browser
import Html exposing (Html, div, h2, h3, img, label, p, text)
import Html.Attributes exposing (alt, class, src)
import Http
import Json.Decode exposing (Decoder, string, succeed)
import Json.Decode.Pipeline exposing (required)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = GotAbout (Result Http.Error About)


type alias Model =
    { img : String
    , about : About
    }


type alias About =
    { text : String }


aboutDecoder : Decoder About
aboutDecoder =
    succeed About
        |> required "text" string


init : () -> ( Model, Cmd Msg )
init _ =
    ( { img = "/hayao.jpg", about = About "" }
    , Http.get
        { url = "http://localhost:3000/about"
        , expect = Http.expectJson GotAbout aboutDecoder
        }
    )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotAbout result ->
            case result of
                Ok about ->
                    ( { model | about = about }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


view : Model -> Html msg
view model =
    div [ class "section" ]
        [ div [ class "content" ]
            [ div [ class "center" ] [ img [ src model.img, alt "近影", class "hayao" ] [] ]
            , h3 [] [ text "hayao" ]
            , p [] [ text model.about.text ]
            ]
        ]
