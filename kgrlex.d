import std.stdio;
import std.string;
import std.conv;
import std.regex;
import std.array;

import Grammar;

int main(string[] args)
{
    if(args.length < 2)
    {
        stderr.writef("Please provide at least 1 .ini file as arg2 %d\n", args.length);
        return 1;
    }
    auto infile = File(args[1], "r");
    auto grammar = new Grammar();
    while(!infile.eof())
    {
        string input = stripRight(to!(string)(infile.readln()));
        auto split = array(splitter(input, regex(r"\s*=\s*")));
        if(split.length == 2)
            grammar.add_token(split[0], split[1]);
    }
    stderr.writef("%s\n", grammar.token_types);
    return 0;
}
