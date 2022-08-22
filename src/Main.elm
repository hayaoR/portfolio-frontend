module Main exposing (main)

import About exposing (About)
import Browser
import Browser.Navigation as Nav
import Career
import Html exposing (Html, a, div, footer, h1, header, li, section, text, ul)
import Html.Attributes exposing (class, classList, href)
import Skill
import Top
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, s)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = ChangedUrl
        , onUrlRequest = UrlRequest
        }


type Page
    = TopPage Top.Model
    | AboutPage About.Model
    | CareerPage Career.Model
    | SkillPage Skill.Model
    | NotFound


type Route
    = Top
    | About
    | Career
    | Skill


type alias Model =
    { page : Page
    , key : Nav.Key
    }


type Msg
    = UrlRequest Browser.UrlRequest
    | ChangedUrl Url
    | GotTopMsg Top.Msg
    | GotAboutMsg About.Msg
    | GotCareerMsg Career.Msg
    | GotSkillMsg Skill.Msg


view model =
    let
        content =
            case model.page of
                TopPage top ->
                    Top.view top
                        |> Html.map GotTopMsg

                AboutPage about ->
                    About.view about
                        |> Html.map GotAboutMsg

                CareerPage career ->
                    Career.view career
                        |> Html.map GotCareerMsg

                SkillPage skill ->
                    Skill.view skill
                        |> Html.map GotSkillMsg

                NotFound ->
                    text "Not Found"
    in
    { title = "Hayao's portfolio"
    , body =
        [ section [ class "section" ]
            [ div [ class "container" ]
                [ viewHeader model.page
                , content
                , viewFooter
                ]
            ]
        ]
    }


viewHeader : Page -> Html Msg
viewHeader page =
    let
        links =
            ul []
                [ link Top { url = "/", caption = "Top" }
                , link About { url = "/about", caption = "About" }
                , link Career { url = "/career", caption = "Career" }
                , link Skill { url = "/skill", caption = "Skill" }
                ]

        link route { url, caption } =
            li [ classList [ ( "is-active", isActive { link = route, page = page } ) ] ]
                [ a [ href url ] [ text caption ] ]
    in
    header [ class "header" ]
        [ h1 [ class "title" ] [ text "Hayao's Portfolio" ]
        , div [ class "tabs" ] [ links ]
        ]


isActive : { link : Route, page : Page } -> Bool
isActive { link, page } =
    case ( link, page ) of
        ( Top, TopPage _ ) ->
            True

        ( About, AboutPage _ ) ->
            True

        ( Career, CareerPage _ ) ->
            True

        ( Skill, SkillPage _ ) ->
            True

        _ ->
            False


viewFooter : Html.Html msg
viewFooter =
    footer [ class "footer" ]
        [ div [ class "content has-text-centered" ] [ text "hayao 2022" ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequest urlRequest ->
            case urlRequest of
                Browser.External href ->
                    ( model, Nav.load href )

                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

        ChangedUrl url ->
            updateUrl url model

        GotTopMsg topMsg ->
            case model.page of
                TopPage top ->
                    toTop model (Top.update topMsg top)

                _ ->
                    ( model, Cmd.none )

        GotAboutMsg aboutMsg ->
            case model.page of
                AboutPage about ->
                    toAbout model (About.update aboutMsg about)

                _ ->
                    ( model, Cmd.none )

        GotCareerMsg careerMsg ->
            case model.page of
                CareerPage career ->
                    toCareer model (Career.update careerMsg career)

                _ ->
                    ( model, Cmd.none )

        GotSkillMsg skillMsg ->
            case model.page of
                SkillPage skill ->
                    toSkill model (Skill.update skillMsg skill)

                _ ->
                    ( model, Cmd.none )


updateUrl : Url -> Model -> ( Model, Cmd Msg )
updateUrl url model =
    case Parser.parse parser url of
        Just Top ->
            Top.init ()
                |> toTop model

        Just About ->
            About.init ()
                |> toAbout model

        Just Career ->
            Career.init ()
                |> toCareer model

        Just Skill ->
            Skill.init ()
                |> toSkill model

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


toTop : Model -> ( Top.Model, Cmd Top.Msg ) -> ( Model, Cmd Msg )
toTop model ( top, cmd ) =
    ( { model | page = TopPage top }
    , Cmd.map GotTopMsg cmd
    )


toAbout : Model -> ( About.Model, Cmd About.Msg ) -> ( Model, Cmd Msg )
toAbout model ( about, cmd ) =
    ( { model | page = AboutPage about }
    , Cmd.map GotAboutMsg cmd
    )


toCareer : Model -> ( Career.Model, Cmd Career.Msg ) -> ( Model, Cmd Msg )
toCareer model ( career, cmd ) =
    ( { model | page = CareerPage career }
    , Cmd.map GotCareerMsg cmd
    )


toSkill : Model -> ( Skill.Model, Cmd Skill.Msg ) -> ( Model, Cmd Msg )
toSkill model ( skill, cmd ) =
    ( { model | page = SkillPage skill }
    , Cmd.map GotSkillMsg cmd
    )


parser : Parser (Route -> c) c
parser =
    Parser.oneOf
        [ Parser.map Top Parser.top
        , Parser.map About (s "about")
        , Parser.map Career (s "career")
        , Parser.map Skill (s "skill")
        ]


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init () url key =
    updateUrl url { page = NotFound, key = key }
