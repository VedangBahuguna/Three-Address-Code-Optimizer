%{
    #include<bits/stdc++.h>
    using namespace std;
    void yyerror(string);
    int yylex();
    extern char *yytext;
    extern FILE *yyin;
    vector<pair<string,map<string,bool>>> v;
    vector<pair<int,string>> v2;
    struct helper
    {
        map<string,bool> use;
    };
    map<string,int> labels;
%}

%union
{
    char *STR;
    struct helper *ptr;
};

%token <STR> IF
%token <STR> GOTO
%token <STR> PRINT
%token <STR> READ
%token <STR> COMPARISON
%token <STR> NUMBER
%token <STR> IDENTIFIER
%type <ptr> expression

%%
program:    lines


lines:  line lines

    |


line:   IDENTIFIER '=' expression {v.push_back({(string)($1),$3->use}); v2.push_back({-1,""});}

    |   IDENTIFIER '=' '-' IDENTIFIER {map<string,bool> m; m[(string)($4)] = true; v.push_back({(string)($1),m}); v2.push_back({-1,""});}

    |   IDENTIFIER '=' '!' IDENTIFIER {map<string,bool> m; m[(string)($4)] = true; v.push_back({(string)($1),m}); v2.push_back({-1,""});}

    |   IF IDENTIFIER COMPARISON IDENTIFIER GOTO IDENTIFIER {map<string,bool> m; m[(string)($2)] = true; m[(string)($4)] = true; v.push_back({"-1", m}); v2.push_back({0,(string)($6)});}

    |   GOTO IDENTIFIER {map<string,bool> m; v.push_back({"-1",m}); v2.push_back({1,(string)($2)});}

    |   IDENTIFIER ':' {map<string,bool> m; labels[(string)($1)] = v.size(); v.push_back({"-1",m}); v2.push_back({-1,""});}

    |   PRINT IDENTIFIER {map<string,bool> m; m[(string)($2)] = true; v.push_back({"-1",m}); v2.push_back({-1,""});}

    |   READ IDENTIFIER {map<string,bool> m; m[(string)($2)] = true; v.push_back({"-1",m}); v2.push_back({-1,""});}


expression: IDENTIFIER Operator IDENTIFIER {$$ = new helper(); $$->use[(string)($1)] = true; $$->use[(string)($3)] = true;}

        |   IDENTIFIER Operator NUMBER {$$ = new helper(); $$->use[(string)($1)] = true;}

        |   NUMBER Operator IDENTIFIER {$$ = new helper(); $$->use[(string)($3)] = true;}

        |   NUMBER Operator NUMBER {$$ = new helper();}
        
        |   IDENTIFIER {$$ = new helper(); $$->use[(string)($1)] = true;}
        
        |   NUMBER {$$ = new helper();}


Operator:   '+' | '-' | '/' | '*'
%%

void yyerror(string s)
{
    cout<<"syntax error"<<endl;
    exit(1);
}

int main(int argc, char **argv)
{
    FILE *file1 = fopen(argv[1], "r");
    yyin = file1;
    yyparse();
    fclose(file1);
    /* map<int,map<int,bool>> adjlist;

    for(int i=0;i<v.size();i++)
    {
        if(v2.at(i).first == -1)
        {
            if(i!=v.size()-1)
            {
                adjlist[i][i+1] = true;
            }
        }
        else if(v2.at(i).first == 0)
        {
            if(i!=v.size()-1)
            {
                adjlist[i][i+1] = true;
            }
            adjlist[i][labels[v2.at(i).second]] = true;
        }
        else if(v2.at(i).first == 1)
        {
            adjlist[i][labels[v2.at(i).second]] = true;
        }
    } */

    vector<bool> visited(v.size(),false);

    /* queue<int> q;

    q.push(0);

    visited[0] = true;

    while(!q.empty())
    {
        int a = q.front();
        q.pop();
        for(auto it = adjlist[a].begin(); it!=adjlist[a].end(); it++)
        {
            if(!visited[it->first])
            {
                q.push(it->first);
                visited[it->first] = true;
            }
        }
    }

    for(int i=0;i<v.size();i++)
    {
        if(!visited[i])
        {
            if(v.at(i).first != "-1")
            {
                removedlines[i] = true;
                if(i!=v.size()-1)
                {
                    adjlist.erase(i);
                    vector<int> str;
                    for(auto it = adjlist.begin(); it!=adjlist.end(); it++)
                    {
                        if(it->second.find(i)!=it->second.end())
                        {
                            str.push_back(it->first);
                        }
                    }
                    for(int j=0;j<str.size();j++)
                    {
                        adjlist[str.at(j)].erase(i);
                        for(int z=i+1;z<v.size();z++)
                        {
                            if(removedlines.find(z) == removedlines.end())
                            {
                                adjlist[str.at(j)][z] = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
    } */


    /* for(int i=0;i<v.size();i++)
    {
        if(removedlines.find(i)!=removedlines.end())
        {
            continue;
        }

        if(v.at(i).first == "-1")
        {
            continue;
        }

        queue<int> q2;
        visited.clear();
        visited.resize(v.size(),false);
        q2.push(i);
        bool flag = false;
        visited[i] = true;
        while(!q2.empty())
        {
            int a = q2.front();
            q2.pop();
            for(auto it = adjlist[a].begin(); it!=adjlist[a].end(); it++)
            {
                if(!visited[it->first])
                {
                    q2.push(it->first);
                    visited[it->first] = true;
                    if(v.at(it->first).second.find(v.at(i).first) != v.at(it->first).second.end())
                    {
                        flag = true;
                        break;
                    }
                }
            }
            if(flag)
            {
                break;
            }
        }

        if(!flag)
        {
            removedlines[i] = true;
            if(i!=v.size()-1)
            {
                adjlist.erase(i);
                vector<int> str;
                for(auto it = adjlist.begin(); it!=adjlist.end(); it++)
                {
                    if(it->second.find(i)!=it->second.end())
                    {
                        str.push_back(it->first);
                    }
                }
                for(int j=0;j<str.size();j++)
                {
                    adjlist[str.at(j)].erase(i);
                    for(int z=i+1;z<v.size();z++)
                    {
                        if(removedlines.find(z) == removedlines.end())
                        {
                            adjlist[str.at(j)][z] = true;
                            break;
                        }
                    }
                }
            }
            i = -1;
        }
    } */

    /* for(int i=0;i<v.size();i++)
    {
        bool flag = false;

        if(removedlines.find(i)!=removedlines.end())
        {
            continue;
        }
        else if(v.at(i).first == "-1")
        {
            continue;
        }

        for(int j=i+1; j<v.size();j++)
        {
            if(removedlines.find(j) != removedlines.end())
            {
                continue;
            }

            if(v.at(j).first == v.at(i).first)
            {
                break;
            }

            if(v.at(j).second.find(v.at(i).first) != v.at(j).second.end())
            {
                flag = true;
                break;
            }
        }

        if(!flag)
        {
            removedlines[i] = true;
            cout<<i<<"-----------------------------------------------------------------------"<<endl;
            i = -1;
        }
    } */

    vector<pair<map<string,bool>, map<string,bool>>> instructions;

    for(int i=0;i<v.size();i++)
    {
        map<string,bool> m1,m2;
        instructions.push_back({m1,m2});
    }
    int x = instructions.size()-1;
    
    for(auto it = v.at(x).second.begin(); it!= v.at(x).second.end(); it++)
    {
        instructions.at(x).second[it->first] = true;
    }

    while(1)
    {
        bool flag = false;

        for(int i=x-1;i>=0;i--)
        {
            if(v2.at(i).first == -1)
            {
                for(auto it = instructions.at(i+1).second.begin(); it!=instructions.at(i+1).second.end(); it++)
                {
                    if(instructions.at(i).first.find(it->first) == instructions.at(i).first.end())
                    {
                        flag = true;
                        instructions.at(i).first[it->first] = true;
                    }
                }
            }
            else if(v2.at(i).first == 0)
            {
                for(auto it = instructions.at(i+1).second.begin(); it!=instructions.at(i+1).second.end(); it++)
                {
                    if(instructions.at(i).first.find(it->first) == instructions.at(i).first.end())
                    {
                        flag = true;
                        instructions.at(i).first[it->first] = true;
                    }
                }

                int y = labels[v2.at(i).second];

                for(auto it = instructions.at(y).second.begin(); it!=instructions.at(y).second.end(); it++)
                {
                    if(instructions.at(i).first.find(it->first) == instructions.at(i).first.end())
                    {
                        flag = true;
                        instructions.at(i).first[it->first] = true;
                    }
                }
            }
            else if(v2.at(i).first == 1)
            {
                int y = labels[v2.at(i).second];

                for(auto it = instructions.at(y).second.begin(); it!=instructions.at(y).second.end(); it++)
                {
                    if(instructions.at(i).first.find(it->first) == instructions.at(i).first.end())
                    {
                        flag = true;
                        instructions.at(i).first[it->first] = true;
                    }
                }
            }

            for(auto it = v.at(i).second.begin(); it!=v.at(i).second.end(); it++)
            {
                if(instructions.at(i).second.find(it->first) == instructions.at(i).second.end())
                {
                    flag = true;
                    instructions.at(i).second[it->first] = true;
                }
            }

            for(auto it = instructions.at(i).first.begin(); it!=instructions.at(i).first.end(); it++)
            {
                if(it->first != v.at(i).first)
                {
                    if(instructions.at(i).second.find(it->first) == instructions.at(i).second.end())
                    {
                        flag = true;
                        instructions.at(i).second[it->first] = true;
                    }
                }
            }
        }

        if(!flag)
        {
            break;
        }
    }

    /* cout<<"Removed lines are :"<<endl;

    for(auto it = removedlines.begin(); it!=removedlines.end(); it++)
    {
        cout<<it->first+1<<" ";
    }
    cout<<endl;

    for(int i=0;i<instructions.size();i++)
    {
        cout<<"Line "<<newtooldindex[i]+1<<":"<<endl;
        cout<<"Outset: ";
        for(auto it = instructions.at(i).first.begin(); it!=instructions.at(i).first.end(); it++)
        {
            cout<<it->first<<" ";
        }
        cout<<endl;
        cout<<"Inset: ";
        for(auto it = instructions.at(i).second.begin(); it!=instructions.at(i).second.end(); it++)
        {
            cout<<it->first<<" ";
        }
        cout<<endl;
    } */
    ifstream ifile;
    ifile.open(argv[2], ios::in);
    ofstream ofile;
    string output_file_name = (string)(argv[1]);
    int pos = 0;
    if(output_file_name.rfind('/') < output_file_name.size())
    {
        pos = output_file_name.rfind('/');
        pos++;
    }
    output_file_name = output_file_name.substr(pos);
    ofile.open(output_file_name, ios::out);
    int qq;
    while(ifile >> qq)
    {
        qq--;
        if(instructions.at(qq).first.size() == 0)
        {
            ofile << " ";
        }
        else
        {
            for(auto it = instructions.at(qq).first.begin(); it!=instructions.at(qq).first.end(); it++)
            {
                ofile << it->first << " ";
            }
        }
        ofile << endl;
    }

    ifile.close();
    ofile.close();  

    return 0;
}