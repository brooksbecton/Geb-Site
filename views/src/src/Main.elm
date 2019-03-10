module Main exposing (Model(..), Msg(..), getTags, init, main, subscriptions, tagDecoder, update, view, viewGif)

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


type Model
    = Failure
    | Loading
    | Success (List String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getTags )



-- UPDATE


type Msg
    = GotTags (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTags result ->
            case result of
                Ok tags ->
                    ( Success tags, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "G.E.B Tags" ]
        , viewGif model
        ]


renderTag tag =
    li [] [ text tag ]


viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure ->
            div []
                [ text "I could not load a random cat for some reason. "
                ]

        Loading ->
            text "Loading..."

        Success tags ->
            div []
                [ ul []
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
