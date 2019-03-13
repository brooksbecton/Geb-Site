module Main exposing (Model, Msg(..), getTags, init, main, renderGifs, subscriptions, tagDecoder, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, list, string)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type TagLoadingStatus
    = Failure
    | Loading
    | Success (List String)


type alias Model =
    { tagLoadingStatus : TagLoadingStatus
    , modalOpen : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tagLoadingStatus = Loading, modalOpen = False }, getTags )



-- UPDATE


type Msg
    = GotTags (Result Http.Error (List String))
    | AddGif
    | EditGif
    | CloseModal


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTags result ->
            case result of
                Ok tags ->
                    ( { model | tagLoadingStatus = Success tags }, Cmd.none )

                Err _ ->
                    ( { model | tagLoadingStatus = Failure }, Cmd.none )

        AddGif ->
            ( { model | modalOpen = True }, Cmd.none )

        EditGif ->
            ( { model | modalOpen = True }, Cmd.none )

        CloseModal ->
            ( { model | modalOpen = False }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "G.E.B Tags" ]
        , renderGifs model
        , renderModal model
        ]


renderModal : Model -> Html Msg
renderModal model =
    if model.modalOpen == True then
        div []
            [ h2 [] [ text "Modal" ]
            , button [ class "btn", onClick CloseModal ] [ text "close" ]
            ]

    else
        div [] []


renderTag : String -> Html Msg
renderTag tag =
    li [ class "tag-card" ]
        [ div [ class "card" ]
            [ div [ class "card-body" ]
                [ p [ class "name" ] [ text tag ]
                , button [ class "btn btn-secondary", onClick EditGif ] [ text "Edit" ]
                , button [ class "btn btn-primary", onClick AddGif ] [ text "Add" ]
                ]
            ]
        ]


renderGifs : Model -> Html Msg
renderGifs model =
    case model.tagLoadingStatus of
        Failure ->
            div []
                [ text "I could not load tags for some reason. "
                ]

        Loading ->
            text "Loading..."

        Success tags ->
            div []
                [ ul [ class "tag-container" ]
                    (List.map renderTag tags)
                ]



-- HTTP


getTags : Cmd Msg
getTags =
    Http.get
        { url = "http://localhost:3001/tags"
        , expect = Http.expectJson GotTags tagDecoder
        }


tagDecoder : Decoder (List String)
tagDecoder =
    list string
