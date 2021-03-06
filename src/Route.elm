module Route exposing (..)

import Url exposing (Url)
import Browser.Navigation as Nav
import Url.Parser exposing (s, Parser, map, string, int, top, (</>), oneOf,
                            parse)

type Route
  = Register
  | Feed
  | Login
  | Review String Int
  | Root
  | User String
  | Settings
  | Notifications

goTo : Nav.Key -> Route -> Cmd msg
goTo key route = Nav.pushUrl key (routeToString route)

routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ map Register <| s "register"
    , map Feed     <| s "feed"
    , map Login    <| s "login"
    , map Review   <| s "users" </> string </> s "reviews" </> int
    , map Root     <| top
    , map User     <| s "users" </> string
    , map Settings <| s "settings"
    , map Notifications <| s "notifications"
    ]

fromUrl : Url -> Maybe Route
fromUrl = parse routeParser

routeToString : Route -> String
routeToString route = "/" ++ (String.join "/" (routeToPieces route))

routeToPieces : Route -> List String
routeToPieces route =
  case route of
    Register -> [ "register" ]
    Feed -> [ "feed" ]
    User username -> [ "users", username ]
    Review username id -> [ "users", username, "reviews", String.fromInt id ]
    Login -> [ "login" ]
    Root -> [ "" ]
    Settings -> [ "settings" ]
    Notifications -> [ "notifications" ]
