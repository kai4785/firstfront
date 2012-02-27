/* Tokenizer Class
 * The tokenizer class creates tokens from the text based on a grammar definition.
 */
import std.stdio;
import std.string;
import std.regex;

import Grammar;

//debug = tokenizer;

class Token
{
    private:
        string _lexeme;
        string _type;
        int _line;
        this() {}
    public:
        this(string _lexeme, string _type, int _line)
        {
            this._lexeme = _lexeme;
            this._type = _type;
            this._line = _line;
        }
        override string toString() {
            return format("%d: (%s) `%s`", _line, _type, _lexeme);
        }
        // Read only properties
        @property string type() { return _type; }
        @property string lexeme() { return _lexeme; }
        @property int line() { return _line; }
}

class Tokenizer 
{
    private:
        Grammar grammar;
        uint _line_num;
        string buffer;
        string filename;
        File infile;
        Token[] tokens;
        bool in_comment;
        this() {}
    public:
        this(string filename) 
        {
            in_comment = false;
            grammar = new Grammar();
            this.filename = filename;
            infile.open(filename);
            fill_buffer();
            read_token();
        }

        @property uint line_num() { return _line_num; }
        @property Token ct() { return tokens[0]; }

        void rewind()
        {
            _line_num = 0;
            infile.close();
            buffer.length = 0;
            tokens.clear();

            infile.open(filename);
            read_token();
        }

        void fill_buffer() 
        {
            // If the buffer is empty, we need to fill it up.
            // We want to continue while the buffer is empty, and while we are reading data from the file
            while(!buffer.length && infile.readln(buffer) > 0) 
            {
                _line_num++;
                // Drop newline at the end of the line, because we know it was there from readln
                buffer = chomp(buffer);
                debug(tokenizer)
                    writef("[tokenizer] new_buffer: %s\n", buffer);
                // Strip whitespace from the beginning
                auto m = std.regex.match(buffer, r"^(:?" ~ grammar.token_type_regexps["ws"] ~ r")*");
                if(!m.empty)
                    buffer = m.post();
                debug(tokenizer)
                    writef("[tokenizer]  fill_buffer: Result from read and strip: [%s]\n", buffer);
            }
        }

        void read_token() 
        {
            if(!buffer.length) 
            {
                fill_buffer();
            }
            // If the buffer is empty, we've reached the end of our ability to read the file (ie: all done).
            // So we setup an End of Tokens token
            if(!buffer.length) 
            {
                tokens ~= new Token("EOT", "EOT", _line_num);
                return;
            }
            bool found = false;
            if(!in_comment)
            {
                foreach(type_order; grammar.search_type_group_priority) 
                {
                    foreach(type; grammar.search_type_priority[type_order]) 
                    {
                        string search_value = grammar.token_type_regexps.get(type, "");
                        if(search_value.length)
                        {
                            debug(tokenizer) writef("[tokenizer] Searching for a %s: %s\n", type, search_value);
                            auto m = std.regex.match(buffer, r"^(" ~ search_value ~ r")" ~ grammar.token_type_regexps["ws"] ~ r"*");
                            if(!m.empty)
                            {
                                buffer = m.post();
                                debug(tokenizer) writef("[tokenizer] Picked out the token `%s``%s`\n[tokenizer] buffer left: %s\n", type, m.captures[1], buffer);
                                if(type == "comment_start")
                                    in_comment = true;
                                tokens ~= new Token(m.captures[1], type, _line_num);
                                found = true;
                                break;
                            }
                        }
                    }
                    if(found)
                        break;
                }
            }
            else // in_comment
            {
                //We need to consume as much buffer as it takes to pull out a comment_end
                string search_value = grammar.token_type_regexps.get("comment_end", "");
                while(buffer.length && in_comment)
                {
                    if(search_value.length)
                    {
                        debug(tokenizer) writef("[tokenizer] Searching for a %s: %s\n", "comment_end", search_value);
                        // Unlike above, we want to search for comment_end anywhere in the string, not just the beginning.
                        auto m = std.regex.match(buffer, r"(" ~ search_value ~ r")" ~ grammar.token_type_regexps["ws"] ~ r"*");
                        if(!m.empty)
                        {
                            buffer = m.post;
                            debug(tokenizer) writef("[tokenizer] Picked out the token `%s``%s`\n[tokenizer] buffer left: %s\n", type, m.captures[1], buffer);
                            tokens ~= new Token(m.captures[1], "comment_end", _line_num);
                            in_comment = false;
                        }
                        else
                        {
                            buffer.clear();
                            fill_buffer();
                        }
                    }
                }
            }
        }

        Token peek(uint count) 
        {
            // Add tokens until there is enough to peek at
            foreach(i; tokens.length..count + 1) 
            {
                read_token();
            }
            // If we have the peeked at value, fine
            // If not, you get the last one (which should be EOT);
            if(count >= tokens.length) 
                return tokens[$-1];
            else
                return tokens[count];
        }

        void nextToken() 
        {
            // If we have tokens, consume one
            if(tokens.length)
                tokens = tokens[1..$];
            // If we're out of tokens, get another one
            if(!tokens.length) 
            {
                read_token();
            }
        }
        /*
        void add_current_class()
        {
            //writef("Adding class: %s\n", tokens[0].lexeme);
            grammar.add_class(tokens[0].lexeme);
        }

        bool is_type(string s)
        {
            return grammar.is_type(s);
        }

        bool is_class(string s)
        {
            return grammar.is_class(s);
        }
        */
}


/*
# vim: set syntax=d :
*/
