module Main exposing (main)

import Array
import Browser exposing (sandbox)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)


type Player
    = O
    | X


type alias Board =
    List (Maybe Player)


type GameState
    = Won Player
    | Tie
    | Active


type alias Model =
    { board : Board
    , player : Player
    , state : GameState
    }


type Msg
    = Play Int


view : Model -> Html Msg
view model =
    let
        showPlayer : Maybe Player -> Html msg
        showPlayer player =
            case player of
                Nothing ->
                    text ""

                Just X ->
                    div
                        [ class "X" ]
                        []

                Just O ->
                    div
                        [ class "O" ]
                        []

        showBoard : (Int -> Attribute msg) -> Html msg
        showBoard attr =
            List.indexedMap
                (\index player ->
                    div
                        [ class "cell"
                        , attr index
                        ]
                        [ showPlayer player ]
                )
                model.board
                |> div [ class "board" ]
    in
    case model.state of
        Active ->
            div []
                [ showBoard (\index -> onClick (Play index))
                , showPlayer (Just model.player)
                , text " to play."
                ]

        Tie ->
            div []
                [ showBoard (always (style "background-color" "grey"))
                , text "It's a tie!"
                ]

        Won winner ->
            div []
                [ showBoard (always (style "background-color" "green"))
                , showPlayer (Just winner)
                , text " won!"
                ]


extractFromBoard : Board -> List Int -> Board
extractFromBoard b idxs =
    let
        board =
            Array.fromList b
    in
    List.map (\i -> Array.get i board) idxs
        |> List.filterMap identity


rows : Board -> List Board
rows board =
    let
        extract =
            extractFromBoard board

        top =
            extract [ 0, 1, 2 ]

        middle =
            extract [ 3, 4, 5 ]

        bottom =
            extract [ 6, 7, 8 ]
    in
    [ top, middle, bottom ]


cols : Board -> List Board
cols board =
    let
        extract =
            extractFromBoard board

        left =
            extract [ 0, 3, 6 ]

        middle =
            extract [ 1, 4, 7 ]

        right =
            extract [ 2, 5, 8 ]
    in
    [ left, middle, right ]


diagonals : Board -> List Board
diagonals board =
    let
        extract =
            extractFromBoard board

        criss =
            extract [ 0, 4, 8 ]

        cross =
            extract [ 2, 4, 6 ]
    in
    [ criss, cross ]


updateState : Board -> Player -> GameState
updateState b player =
    let
        wincheck : Board -> Bool
        wincheck board =
            let
                checkcell : Maybe Player
                checkcell =
                    Maybe.andThen identity (List.head board)
            in
            List.all
                (\cell ->
                    (cell /= Nothing)
                        && (cell == checkcell)
                )
                board

        won =
            List.concat [ rows b, cols b, diagonals b ]
                |> List.any wincheck

        tied =
            List.all ((/=) Nothing) b
    in
    if won then
        Won player

    else if tied then
        Tie

    else
        Active


update : Msg -> Model -> Model
update (Play at) model =
    let
        playCell : Maybe Player
        playCell =
            (Maybe.andThen identity << List.head << List.drop at) model.board

        updateBoard : Player -> Board -> Board
        updateBoard player board =
            List.indexedMap
                (\index cell ->
                    if index == at then
                        Just player

                    else
                        cell
                )
                board

        switchPlayer : Player -> Player
        switchPlayer player =
            case player of
                X ->
                    O

                O ->
                    X

        nextBoard : Board
        nextBoard =
            updateBoard model.player model.board
    in
    if playCell == Nothing then
        { model
            | board = nextBoard
            , player = switchPlayer model.player
            , state = updateState nextBoard model.player
        }

    else
        model


init : Model
init =
    { board = List.repeat 9 Nothing
    , player = X
    , state = Active
    }


main =
    sandbox
        { init = init
        , view = view
        , update = update
        }
