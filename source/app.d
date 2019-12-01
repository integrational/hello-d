import vibe.d;
import std.conv : to;
import std.process : environment;
import std.typecons : Nullable;

shared static this()
{
    logInfo("Environment dump");
    auto env = environment.toAA;
    foreach(k, v; env)
        logInfo("%s = %s", k, v);

    auto host = environment.get("APP_HOST", "0.0.0.0");
    auto port = to!ushort(environment.get("APP_PORT", "8080"));

    auto router = new URLRouter;
    router.registerRestInterface(new HelloImpl());

    auto settings = new HTTPServerSettings;
    settings.port = port;
    settings.bindAddresses = [host];

    listenHTTP(settings, router);

    logInfo("API listening on http://%s:%d/hello", host, port);
}

interface Hello
{
    @method(HTTPMethod.GET)
    @path("hello")
    @queryParam("name", "name")
    Msg hello(Nullable!string name);

    @method(HTTPMethod.GET)
    @path("alive")
    string alive();
}

class HelloImpl : Hello
{
    Msg hello(Nullable!string name) @safe
    {
        logInfo("hello called");
        return Msg(format("Hello %s", name.isNull ? "World!" : name));
    }

    string alive() @safe
    {
        logInfo("alive called");
        return "OK";
    }
}

struct Msg
{
    string msg;
}
