1 contract Mortal {
2         address public owner;
3         function mortal() { owner = msg.sender; }
4         function kill() { if (msg.sender == owner) suicide(owner); }
5 }
6 
7 contract Thing is Mortal {
8         enum Mood { Agree, Disagree, Funny, Sad, Angry, Nothing }
9         // URL of the reaction - optional
10         string public url;
11         // Content of the reaction - optional
12         string public data;
13         // MIME type of the content - optional, default is text/plain
14         string public mimetype;
15         // Mood of the reaction - Mood.Nothing by default
16         Mood public mood;
17         Thing[] public reactions;
18 
19         function thing( string _url
20                           , string _data
21                           , Mood _mood
22                           , string _mimetype) {
23                 url = _url;
24                 data = _data;
25                 mimetype = _mimetype;
26                 mood = _mood;
27         }
28 
29         function react(Thing reaction) {
30                 if (msg.sender != reaction.owner()) throw;
31 
32                 reactions.push(reaction);
33         }
34 
35         function withdraw() {
36                 if (msg.sender != owner) throw;
37 
38                 owner.send(this.balance);
39         }
40 }