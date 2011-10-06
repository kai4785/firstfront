/* Grammar Definition */
import std.conv;
class Grammar
{
    private:
    public:
    string[] token_search_priority;
    string[string] token_types;
    this()
    {
        token_types["ws"]     = r"\s";
        token_types["not_ws"] = r"\S";
        token_types = [
            "ws":r"\s",
            "not_ws":r"\S",
            ];
    }
    void add_token(string type, string value)
    {
        token_types[type] = value;
    }
}
