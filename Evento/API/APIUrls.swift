import Foundation

public class APIUrls {
    static private var base = "http://127.0.0.1:8000/"
    
    static public var getToken = base + "get-token/"
    static public var registration = base + "users/register/"
    static public var users = base + "users"
    static public var getEvents = base + "events/"
    static public var getPresentations = base + "presentations/"
    static public var getSpeakers = base + "speakers/"
}
