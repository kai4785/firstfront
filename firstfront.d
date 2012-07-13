import std.stdio;
import std.string;
import std.array;

import Grammar;
import Tokenizer;

Tokenizer tokenizer;
Grammar new_grammar;
string last_type;
string last_group = "default";
string[] _scope = [];
int errors = 0;

int main(string[] args)
{
    if(args.length < 2)
    {
        stderr.writef("Please provide at least 1 .def file as arg1. Only supplied %d args.\n", args.length - 1);
        return 1;
    }
    tokenizer = new Tokenizer(args[1]);
    generate_grammar();
    writef("Grammar: %s\n", new_grammar);
    return 0;
}

void generate_grammar()
{
    new_grammar = new Grammar(false);
    new_grammar.search_type_priority[last_group] = [];
    while(!check_token("EOT"))
    {
        writef("%s\n", tokenizer.ct);
        // Expect open_bracket or name
        if(check_token("open_bracket"))
        {
            do_open_bracket();
        }
        else if(check_token("name"))
        {
            do_name();
        }
        else
        {
            gen_error("generate_grammar");
            tokenizer.nextToken();
        }
        /*
        */
    }
    new_grammar.search_type_group_priority ~= last_group;
    //return new_grammar;
}

void do_open_bracket()
{
    string func = "do_open_bracket";
    tokenizer.nextToken();
    writef("%s\n", tokenizer.ct);
    if(check_token("header_name"))
    {
        last_type = tokenizer.ct.lexeme;
        new_grammar.search_type_priority[last_group] ~= tokenizer.ct.lexeme;
        tokenizer.nextToken();
    }
    else
    {
        gen_error(func);
        tokenizer.nextToken();
    }
    writef("%s\n", tokenizer.ct);
    if(check_token("close_bracket"))
    {
        tokenizer.nextToken();
    }
    else
    {
        gen_error(func);
    }
}

void do_name()
{
    string func = "do_name";
    last_type = tokenizer.ct.lexeme;
    tokenizer.nextToken();
    writef("%s\n", tokenizer.ct);
    if(check_token("defined_as"))
    {
        tokenizer.nextToken();
    }
    else
    {
        gen_error(func);
        return;
    }
    writef("%s\n", tokenizer.ct);
    while(!check_token("eor"))
    {
        if(check_token("value"))
        {
            new_grammar.token_type_regexps[last_type] ~= tokenizer.ct.lexeme;
        }
        else if(check_token("name"))
        {
            new_grammar.token_type_regexps[last_type] ~= tokenizer.ct.lexeme;
        }
        else
        {
            gen_error(func, format("Expected value or name, but got %s", tokenizer.ct));
        }
        tokenizer.nextToken();
        writef("%s\n", tokenizer.ct);
        if(check_token("or"))
        {
            new_grammar.token_type_regexps[last_type] ~= "|";
            tokenizer.nextToken();
            writef("%s\n", tokenizer.ct);
        }
        else if(!check_token("eor"))
        {
            gen_error(func, format("Expected | or eor, but got %s", tokenizer.ct));
            return;
        }
    }
    tokenizer.nextToken();
    writef("%s\n", tokenizer.ct);
}

void gen_error(string func, string msg = "", string file = __FILE__, int line = __LINE__)
{
    if(msg == "")
        stderr.writef("gen_error: (in %s on line %d) [%d][%s] Encountered an error in function (%s) on token (%s).\n", file, line, tokenizer.ct.line, _scope.join("."), func, tokenizer.ct);
    else
        stderr.writef("gen_error: (in %s on line %d) [%d][%s] Encountered an error in function (%s): %s.\n", file, line, tokenizer.ct.line, _scope.join("."), func, msg);
    errors++;
    if(errors >= 5)
    {
        throw(new Exception(format("Too many errors encountered: [%d]", errors)));
    }
    while(!(check_token("symbol","}") || check_token("eor",";") || check_token("EOT")))
    {
        debug(log1) log("gen_error", format("consuming token (%s)", tokenizer.ct.toString));
        tokenizer.nextToken();
    }
    if(check_token("EOT"))
    {
        throw(new Exception(format("Encountered an EOT during gen_error(): %s", tokenizer.ct)));
    }
}

bool check_token(string type)
{
    return (tokenizer.ct.type == type);
}

bool check_token(string[] type)
{
    bool retval = false;
    foreach(t; type)
    {
        retval = (retval || check_token(t));
    }
    return retval;
}

bool check_token(string type, string lexeme)
{
    return (tokenizer.ct.type == type && tokenizer.ct.lexeme == lexeme);
}

bool check_token(string type, string[] lexeme)
{
    bool retval = false;
    foreach(l; lexeme)
    {
        retval = (retval || check_token(type, l));
    }
    return retval;
}

/*
# vim: set syntax=d :
 */
