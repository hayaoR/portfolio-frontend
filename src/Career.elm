module Career exposing (..)

import Browser
import Html exposing (Html, div, h2, p, text)
import Html.Attributes exposing (class)
import Http exposing (expectJson)
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Tuple exposing (first, second)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Career =
    { id : Int
    , name : String
    , years_from : String
    , years_to : String
    , description : String
    }


type alias Model =
    { careers : List Career }


type Msg
    = GotCareers (Result Http.Error (List Career))


careerDecoder : Decoder Career
careerDecoder =
    succeed Career
        |> required "id" int
        |> required "name" string
        |> required "years_from" string
        |> required "years_to" string
        |> required "description" string


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model []
    , Http.get
        { url = "http://localhost:3000/careers"
        , expect = expectJson GotCareers (list careerDecoder)
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCareers result ->
            case result of
                Ok careers ->
                    ( { model | careers = careers }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    viewStack model.careers


viewStack : List Career -> Html Msg
viewStack careers =
    div [ class "stack" ]
        [ h2 [] [ text "Career" ]
        , div [ class "center" ]
            [ div [ class "box" ]
                [ div [ class "stack" ]
                    (List.map viewBox careers)
                ]
            ]
        ]


viewBox : Career -> Html Msg
viewBox career =
    div [ class "box" ]
        [ div [ class "stack" ]
            [ viewName ( career.years_from, career.years_to ) career.name
            , div [ class "box" ] [ p [] [ text career.description ] ]
            ]
        ]


viewName : ( String, String ) -> String -> Html Msg
viewName years name =
    div [ class "box" ]
        [ div [ class "stack" ]
            [ p [] [ text (first years ++ "~" ++ second years) ]
            , h2 [] [ text name ]
            ]
        ]
