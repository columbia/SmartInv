1 pragma solidity ^0.4.11;
2 
3 contract RPS {
4     enum State { Unrealized, Created, Joined, Ended }
5     enum Result { Unfinished, Draw, Win, Loss, Forfeit } // From the perspective of player 1
6     struct Game {
7         address player1;
8         address player2;
9         uint value;
10         bytes32 hiddenMove1;
11         uint8 move1; // 0 = not set, 1 = Rock, 2 = Paper, 3 = Scissors
12         uint8 move2;
13         uint gameStart;
14         State state;
15         Result result;
16     }
17     
18     address public owner1;
19     address public owner2;
20     uint8 constant feeDivisor = 100;
21     uint constant revealTime = 7 days; // TODO: dynamic reveal times?
22     bool paused;
23     bool expired;
24     uint gameIdCounter;
25     
26     uint constant minimumNameLength = 1;
27     uint constant maximumNameLength = 25;
28     
29     event NewName(address indexed player, string name);
30     event Donate(address indexed player, uint amount);
31     event Deposit(address indexed player, uint amount);
32     event Withdraw(address indexed player, uint amount);
33     event GameCreated(address indexed player1, address indexed player2, uint indexed gameId, uint value, bytes32 hiddenMove1);
34     event GameJoined(address indexed player1, address indexed player2, uint indexed gameId, uint value, uint8 move2, uint gameStart);
35     event GameEnded(address indexed player1, address indexed player2, uint indexed gameId, uint value, Result result);
36     
37     mapping(address => uint) public balances;
38     mapping(address => uint) public totalWon;
39     mapping(address => uint) public totalLost;
40     
41     Game [] public games;
42     mapping(address => string) public playerNames;
43     mapping(uint => bool) public nameTaken;
44     mapping(bytes32 => bool) public secretTaken;
45     
46     modifier onlyOwner { require(msg.sender == owner1 || msg.sender == owner2); _; }
47     modifier notPaused { require(!paused); _; }
48     modifier notExpired { require(!expired); _; }
49     
50 
51     function RPS(address otherOwner) {
52         owner1 = msg.sender;
53         owner2 = otherOwner;
54         paused = true;
55     }
56     
57     // UTILIY FUNCTIONS
58     //
59     // FOR DOING BORING REPETITIVE TASKS
60     
61     function getGames() constant internal returns (Game []) {
62         return games;
63     }
64     
65     function totalProfit(address player) constant returns (int) {
66         if (totalLost[player] > totalWon[player]) {
67             return -int(totalLost[player] - totalWon[player]);
68         }
69         else {
70             return int(totalWon[player] - totalLost[player]);
71         }
72     }
73     // Fuzzy hash and name validation taken from King of the Ether Throne
74     // https://github.com/kieranelby/KingOfTheEtherThrone/blob/v1.0/contracts/KingOfTheEtherThrone.sol
75     
76     function computeNameFuzzyHash(string _name) constant internal
77     returns (uint fuzzyHash) {
78         bytes memory nameBytes = bytes(_name);
79         uint h = 0;
80         uint len = nameBytes.length;
81         if (len > maximumNameLength) {
82             len = maximumNameLength;
83         }
84         for (uint i = 0; i < len; i++) {
85             uint mul = 128;
86             byte b = nameBytes[i];
87             uint ub = uint(b);
88             if (b >= 48 && b <= 57) {
89                 // 0-9
90                 h = h * mul + ub;
91             } else if (b >= 65 && b <= 90) {
92                 // A-Z
93                 h = h * mul + ub;
94             } else if (b >= 97 && b <= 122) {
95                 // fold a-z to A-Z
96                 uint upper = ub - 32;
97                 h = h * mul + upper;
98             } else {
99                 // ignore others
100             }
101         }
102         return h;
103     }
104     /// @return True if-and-only-if `_name_` meets the criteria
105     /// below, or false otherwise:
106     ///   - no fewer than 1 character
107     ///   - no more than 25 characters
108     ///   - no characters other than:
109     ///     - "roman" alphabet letters (A-Z and a-z)
110     ///     - western digits (0-9)
111     ///     - "safe" punctuation: ! ( ) - . _ SPACE
112     ///   - at least one non-punctuation character
113     /// Note that we deliberately exclude characters which may cause
114     /// security problems for websites and databases if escaping is
115     /// not performed correctly, such as < > " and '.
116     /// Apologies for the lack of non-English language support.
117     function validateNameInternal(string _name) constant internal
118     returns (bool allowed) {
119         bytes memory nameBytes = bytes(_name);
120         uint lengthBytes = nameBytes.length;
121         if (lengthBytes < minimumNameLength ||
122             lengthBytes > maximumNameLength) {
123             return false;
124         }
125         bool foundNonPunctuation = false;
126         for (uint i = 0; i < lengthBytes; i++) {
127             byte b = nameBytes[i];
128             if (
129                 (b >= 48 && b <= 57) || // 0 - 9
130                 (b >= 65 && b <= 90) || // A - Z
131                 (b >= 97 && b <= 122)   // a - z
132             ) {
133                 foundNonPunctuation = true;
134                 continue;
135             }
136             if (
137                 b == 32 || // space
138                 b == 33 || // !
139                 b == 40 || // (
140                 b == 41 || // )
141                 b == 45 || // -
142                 b == 46 || // .
143                 b == 95    // _
144             ) {
145                 continue;
146             }
147             return false;
148         }
149         return foundNonPunctuation;
150     }
151     
152     
153     /// if you want to donate, please use the donate function
154     function() { require(false); }
155     
156     // PLAYER FUNCTIONS
157     //
158     // FOR PLAYERS
159     
160     /// Name must only include upper and lowercase English letters,
161     /// numbers, and certain characters: ! ( ) - . _ SPACE
162     /// Function will return false if the name is not valid
163     /// or if it's too similar to a name that's already taken.
164     function setName(string name) returns (bool success) {
165         require (validateNameInternal(name));
166         uint fuzzyHash = computeNameFuzzyHash(name);
167         uint oldFuzzyHash;
168         string storage oldName = playerNames[msg.sender];
169         bool oldNameEmpty = bytes(oldName).length == 0;
170         if (nameTaken[fuzzyHash]) {
171             require(!oldNameEmpty);
172             oldFuzzyHash = computeNameFuzzyHash(oldName);
173             require(fuzzyHash == oldFuzzyHash);
174         }
175         else {
176             if (!oldNameEmpty) {
177                 oldFuzzyHash = computeNameFuzzyHash(oldName);
178                 nameTaken[oldFuzzyHash] = false;
179             }
180             nameTaken[fuzzyHash] = true;
181         }
182         playerNames[msg.sender] = name;
183 
184         NewName(msg.sender, name);
185         return true;
186     }
187     
188     //{
189     /// Create a game that may be joined only by the address provided.
190     /// If no address is provided, the game is open to anyone.
191     /// Your bet is equal to the value sent together
192     /// with this transaction. If the game is a draw,
193     /// your bet will be available for withdrawal.
194     /// If you win, both bets minus the fee will be send to you.
195     /// The first argument should be the number
196     /// of your move (rock: 1, paper: 2, scissors: 3)
197     /// encrypted with keccak256(uint move, string secret) and
198     /// save the secret so you can reveal your move
199     /// after your game is joined.
200     /// It's very easy to mess up the padding and stuff,
201     /// so you should just use the website.
202     //}
203     function createGame(bytes32 move, uint val, address player2)
204     payable notPaused notExpired returns (uint gameId) {
205         deposit();
206         require(balances[msg.sender] >= val);
207         require(!secretTaken[move]);
208         secretTaken[move] = true;
209         balances[msg.sender] -= val;
210         gameId = gameIdCounter;
211         games.push(Game(msg.sender, player2, val, move, 0, 0, 0, State.Created, Result(0)));
212 
213         GameCreated(msg.sender, player2, gameId, val, move);
214         gameIdCounter++;
215     }
216     
217     function abortGame(uint gameId) notPaused returns (bool success) {
218         Game storage thisGame = games[gameId];
219         require(thisGame.player1 == msg.sender);
220         require(thisGame.state == State.Created);
221         thisGame.state = State.Ended;
222 
223         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, Result(0));
224 
225         msg.sender.transfer(thisGame.value);
226         return true;
227     }
228     
229     function joinGame(uint gameId, uint8 move) payable notPaused returns (bool success) {
230         Game storage thisGame = games[gameId];
231         require(thisGame.state == State.Created);
232         require(move > 0 && move <= 3);
233         if (thisGame.player2 == 0x0) {
234             thisGame.player2 = msg.sender;
235         }
236         else {
237             require(thisGame.player2 == msg.sender);
238         }
239         require(thisGame.value == msg.value);
240         thisGame.gameStart = now;
241         thisGame.state = State.Joined;
242         thisGame.move2 = move;
243 
244         GameJoined(thisGame.player1, thisGame.player2, gameId, thisGame.value, thisGame.move2, thisGame.gameStart);
245         return true;
246     }
247     
248     function revealMove(uint gameId, uint8 move, string secret) notPaused returns (Result result) {
249         Game storage thisGame = games[gameId];
250         require(thisGame.state == State.Joined);
251         require(thisGame.player1 == msg.sender);
252         require(thisGame.gameStart + revealTime >= now); // It's not too late to reveal
253         require(thisGame.hiddenMove1 == keccak256(uint(move), secret));
254         thisGame.move1 = move;
255         if (move > 0 && move <= 3) {
256             result = Result(((3 + move - thisGame.move2) % 3) + 1); // It works trust me (it's 'cause of math)
257         }
258         else { // Player 1 submitted invalid move
259             result = Result.Loss;
260         }
261         thisGame.state = State.Ended;
262         address winner;
263         if (result == Result.Draw) {
264             balances[thisGame.player1] += thisGame.value;
265             balances[thisGame.player2] += thisGame.value;
266         }
267         else {
268             if (result == Result.Win) {
269                 winner = thisGame.player1;
270                 totalLost[thisGame.player2] += thisGame.value;
271             }
272             else {
273                 winner = thisGame.player2;
274                 totalLost[thisGame.player1] += thisGame.value;
275             }
276             uint fee = (thisGame.value) / feeDivisor; // 0.5% fee taken once for each owner
277             balances[owner1] += fee;
278             balances[owner2] += fee;
279             totalWon[winner] += thisGame.value - fee*2;
280             // No re-entrancy attack is possible because
281             // the state has already been set to State.Ended
282             winner.transfer((thisGame.value*2) - fee*2);
283         }
284         thisGame.result = result;
285 
286         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, result);
287     }
288     
289     /// Use this when you know you've lost as player 1 and
290     /// you don't want to bother with revealing your move.
291     function forfeitGame(uint gameId) notPaused returns (bool success) {
292         Game storage thisGame = games[gameId];
293         require(thisGame.state == State.Joined);
294         require(thisGame.player1 == msg.sender);
295         
296         uint fee = (thisGame.value) / feeDivisor; // 0.5% fee taken once for each owner
297         balances[owner1] += fee;
298         balances[owner2] += fee;
299         totalLost[thisGame.player1] += thisGame.value;
300         totalWon[thisGame.player2] += thisGame.value - fee*2;
301         thisGame.state = State.Ended;
302         thisGame.result = Result.Forfeit; // Loss for player 1
303 
304         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, thisGame.result);
305         
306         thisGame.player2.transfer((thisGame.value*2) - fee*2);
307         return true;
308     }
309     
310     function claimGame(uint gameId) notPaused returns (bool success) {
311         Game storage thisGame = games[gameId];
312         require(thisGame.state == State.Joined);
313         require(thisGame.player2 == msg.sender);
314         require(thisGame.gameStart + revealTime < now); // Player 1 has failed to reveal in time
315         
316         uint fee = (thisGame.value) / feeDivisor; // 0.5% fee taken once for each owner
317         balances[owner1] += fee;
318         balances[owner2] += fee;
319         totalLost[thisGame.player1] += thisGame.value;
320         totalWon[thisGame.player2] += thisGame.value - fee*2;
321         thisGame.state = State.Ended;
322         thisGame.result = Result.Forfeit; // Loss for player 1
323         
324         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, thisGame.result);
325 
326         thisGame.player2.transfer((thisGame.value*2) - fee*2);
327         return true;
328     }
329     
330     // FUNDING FUNCTIONS
331     //
332     // FOR FUNDING
333     function donate() payable returns (bool success) {
334         require(msg.value != 0);
335         balances[owner1] += msg.value/2;
336         balances[owner2] += msg.value - msg.value/2;
337 
338         Donate(msg.sender, msg.value);
339         return true;
340     }
341     function deposit() payable returns (bool success) {
342         require(msg.value != 0);
343         balances[msg.sender] += msg.value;
344 
345         Deposit(msg.sender, msg.value);
346         return true;
347     }
348     function withdraw() returns (bool success) {
349         uint amount = balances[msg.sender];
350         if (amount == 0) return false;
351         balances[msg.sender] = 0;
352         msg.sender.transfer(amount);
353 
354         Withdraw(msg.sender, amount);
355         return true;
356     }
357     
358     // ADMIN FUNCTIONS
359     //
360     // FOR ADMINISTRATING
361     
362     // Pause all gameplay
363     function pause(bool pause) onlyOwner {
364         paused = pause;
365     }
366     
367     // Prevent new games from being created
368     // To be used when switching to a new contract
369     function expire(bool expire) onlyOwner {
370         expired = expire;
371     }
372     
373     function setOwner1(address newOwner) {
374         require(msg.sender == owner1);
375         owner1 = newOwner;
376     }
377     
378     function setOwner2(address newOwner) {
379         require(msg.sender == owner2);
380         owner2 = newOwner;
381     }
382     
383 }