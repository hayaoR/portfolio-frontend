module Skill exposing (..)
import Browser
import Html exposing (div)
import Html.Attributes exposing (class)
import Html exposing (Html, text)
import Html exposing (p)
import Json.Decode exposing (Decoder, succeed, int, string, list)
import Json.Decode.Pipeline exposing (required)
import Http

main : Program () Model Msg
main = Browser.element
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }

type alias Model =
    { skills: List Skill }

type Msg = GotSkills (Result Http.Error (List Skill))

type alias Skill = 
    { id: Int
    , title: String
    , content: String
    }

skillDecoder : Decoder Skill
skillDecoder =
    succeed Skill
        |> required "id" int
        |> required "title" string
        |> required "content" string

init : () -> (Model, Cmd Msg)
init _ =
    ( { skills =  [] }
    , Http.get
        { url = "http://localhost:3000/skills"
        , expect = Http.expectJson GotSkills (list skillDecoder)
        }
    )
update : Msg -> Model -> ( Model, Cmd msg)
update msg model =
    case msg of
       GotSkills result ->
            case result of
                Ok skills ->
                    ( { model | skills = skills }, Cmd.none)
                Err _ ->
                    (model, Cmd.none)

view : Model -> Html Msg
view model =
    viewGrid model.skills

viewGrid : List Skill -> Html Msg 
viewGrid skills =
    div [ class "grid" ]
        (List.map viewBox skills)


viewBox : Skill -> Html Msg 
viewBox skill = 
    div [ class "box"] [ 
        div [ class "stack"]
            [
                p [] [text skill.title]
                , p [] [text skill.content]
            ]
    ]