import vibe.d;
import std.conv : to;
import std.process : environment;
import std.typecons : Nullable;

shared static this()
{
    auto host = environment.get( "HOST", "0.0.0.0");
    auto port = to!ushort( environment.get( "PORT", "8080"));

    auto settings = new HTTPServerSettings;
    settings.port = port;
    settings.bindAddresses = [ host];

    auto router = new URLRouter;
    router.registerRestInterface( new GreetingResourceImpl());

    listenHTTP( settings, router);
}

interface GreetingResource
{
    @method( HTTPMethod.GET)
    @path( "hello")
    @queryParam( "name", "name")
    Greeting hello(Nullable!string name);

    @method( HTTPMethod.GET)
    @path( "alive")
    string alive();
}

class GreetingResourceImpl : GreetingResource
{
    Greeting hello(Nullable!string name) @safe
    {
        logInfo( "hello called");
        return Greeting( format( "Hello %s", name.isNull ? "World!" : name));
    }

    string alive() @safe
    {
        logInfo( "alive called");
        return "OK";
    }
}

struct Greeting
{
    string msg;
}
