1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6   event NewOwner (address indexed owner);
7 
8   constructor () public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner () {
13     if (owner != msg.sender) revert();
14     _;
15   }
16 
17   function setOwner (address candidate) public onlyOwner {
18     if (candidate == address(0)) revert();
19     owner = candidate;
20     emit NewOwner(owner);
21   }
22 }
23 
24 contract TokenAware is Ownable {
25   function withdrawToken (address addressOfToken, uint256 amount) public onlyOwner returns (bool) {
26     bytes4 hashOfTransfer = bytes4(keccak256('transfer(address,uint256)'));
27 
28     return addressOfToken.call(hashOfTransfer, owner, amount);
29   }
30 }
31 
32 contract Destructible is TokenAware {
33   function kill () public onlyOwner {
34     selfdestruct(owner);
35   }
36 }
37 
38 contract Pausable is Destructible {
39   bool public paused;
40 
41   event NewStatus (bool isPaused);
42 
43   modifier whenNotPaused () {
44     if (paused) revert();
45     _;
46   }
47 
48   modifier whenPaused () {
49     if (!paused) revert();
50     _;
51   }
52 
53   function setStatus (bool isPaused) public onlyOwner {
54     paused = isPaused;
55     emit NewStatus(isPaused);
56   }
57 }
58 
59 contract Operable is Pausable {
60   address[] public operators;
61 
62   event NewOperator(address indexed operator);
63   event RemoveOperator(address indexed operator);
64 
65   constructor (address[] newOperators) public {
66     operators = newOperators;
67   }
68 
69   modifier restricted () {
70     if (owner != msg.sender &&
71         !containsOperator(msg.sender)) revert();
72     _;
73   }
74 
75   modifier onlyOperator () {
76     if (!containsOperator(msg.sender)) revert();
77     _;
78   }
79 
80   function containsOperator (address candidate) public constant returns (bool) {
81     for (uint256 x = 0; x < operators.length; x++) {
82       address operator = operators[x];
83       if (candidate == operator) {
84         return true;
85       }
86     }
87 
88     return false;
89   }
90 
91   function indexOfOperator (address candidate) public constant returns (int256) {
92     for (uint256 x = 0; x < operators.length; x++) {
93       address operator = operators[x];
94       if (candidate == operator) {
95         return int256(x);
96       }
97     }
98 
99     return -1;
100   }
101 
102   function addOperator (address candidate) public onlyOwner {
103     if (candidate == address(0) || containsOperator(candidate)) revert();
104     operators.push(candidate);
105     emit NewOperator(candidate);
106   }
107 
108   function removeOperator (address operator) public onlyOwner {
109     int256 indexOf = indexOfOperator(operator);
110 
111     if (indexOf < 0) revert();
112 
113     // overwrite operator with last operator in the array
114     if (uint256(indexOf) != operators.length - 1) {
115       address lastOperator = operators[operators.length - 1];
116       operators[uint256(indexOf)] = lastOperator;
117     }
118 
119     // delete the last element
120     delete operators[operators.length - 1];
121     emit RemoveOperator(operator);
122   }
123 }
124 
125 contract EtherShuffleLite is Operable {
126 
127   uint256 public nextGameId = 1;
128   uint256 public lowestGameWithoutQuorum = 1;
129 
130   uint256[5] public distributions = [300000000000000000, // 30%
131     240000000000000000, // 20%
132     220000000000000000, // 10%
133     0, 
134     0];
135 
136   uint8 public constant countOfParticipants = 5;
137   uint256 public gamePrice = 15 finney;
138 
139   mapping (uint256 => Shuffle) public games;
140   mapping (address => uint256[]) public gamesByPlayer;
141   mapping (address => uint256) public balances;
142 
143   struct Shuffle {
144     uint256 id;
145     address[] players;
146     bytes32 hash;
147     uint8[5] result;
148     bytes32 secret;
149     uint256 value;
150     uint256 price;
151   }
152 
153   event NewGame (uint256 indexed gameId);
154   event NewHash (uint256 indexed gameId);
155   event NewReveal (uint256 indexed gameId);
156   event NewPrice (uint256 price);
157   event NewDistribution (uint256[5]);
158   event Quorum (uint256 indexed gameId);
159 
160   constructor (address[] operators)
161     Operable(operators) public {
162   }
163 
164   modifier onlyExternalAccount () {
165     uint size;
166     address addr = msg.sender;
167     assembly { size := extcodesize(addr) }
168     if (size > 0) revert();
169     _;
170   }
171 
172   function newGame () public payable whenNotPaused onlyExternalAccount {
173     if (msg.value != gamePrice) revert();
174 
175     uint256 gameId = nextGameId;
176     nextGameId++;
177     Shuffle storage game = games[gameId];
178 
179     // ensure this is a real uninitialized game
180     if (game.id != 0) revert();
181 
182     game.id = gameId;
183     game.price = gamePrice;
184 
185     emit NewGame(gameId);
186 
187     joinGameInternal(game, msg.sender, msg.value);
188   }
189 
190   function joinGame (uint256 gameId) public payable whenNotPaused onlyExternalAccount {
191     Shuffle storage game = games[gameId];
192     joinGameInternal(game, msg.sender, msg.value);
193   }
194 
195   function joinGameFromBalance (uint256 gameId) public whenNotPaused {
196     uint256 balanceOf = balances[msg.sender];
197     Shuffle storage game = games[gameId];
198 
199     if (balanceOf < game.price) revert();
200 
201     balances[msg.sender] -= game.price;
202     joinGameInternal(game, msg.sender, game.price);
203   }
204 
205   function joinGameInternal (Shuffle storage game, address player, uint256 value) private {
206     if (game.id == 0) revert();
207 
208     if (game.players.length == countOfParticipants) revert();
209 
210     if (value != game.price) revert();
211     game.value += gamePrice;
212     if (game.value < gamePrice) revert();
213 
214     game.players.push(player);
215     gamesByPlayer[player].push(game.id);
216 
217     if (game.players.length == countOfParticipants) {
218       emit Quorum(game.id);
219     }
220   }
221 
222   /* Informational constant functions */
223 
224   function gamesOf (address player) public constant returns (uint256[]) {
225     return gamesByPlayer[player];
226   }
227 
228   function balanceOf (address player) public constant returns (uint256) {
229     return balances[player];
230   }
231 
232   function getPlayers (uint256 gameId) public constant returns (address[]) {
233     Shuffle storage game = games[gameId];
234     return game.players;
235   }
236 
237   function hasHash (uint256 gameId) public constant returns (bool) {
238     Shuffle storage game = games[gameId];
239     return game.hash != bytes32(0);
240   }
241 
242   function getHash (uint256 gameId) public constant returns (bytes32) {
243     Shuffle storage game = games[gameId];
244     return game.hash;
245   }
246 
247   function getResult (uint256 gameId) public constant returns (uint8[5]) {
248     Shuffle storage game = games[gameId];
249     return game.result;
250   }
251 
252   function hasSecret (uint256 gameId) public constant returns (bool) {
253     Shuffle storage game = games[gameId];
254     return game.secret != bytes32(0);
255   }
256 
257   function getSecret (uint256 gameId) public constant returns (bytes32) {
258     Shuffle storage game = games[gameId];
259     return game.secret;
260   }
261     
262   function getValue (uint256 gameId) public constant returns (uint256) {
263     Shuffle storage game = games[gameId];
264     return game.value;
265   }
266 
267   /* For operators */
268 
269   function setHash (uint256 gameId, bytes32 hash) public whenNotPaused restricted {
270     Shuffle storage game = games[gameId];
271 
272     if (game.hash != bytes32(0)) revert();
273 
274     game.hash = hash;
275     emit NewHash(game.id);
276   }
277 
278   function reveal (uint256 gameId, uint8[5] result, bytes32 secret) public whenNotPaused restricted {
279     Shuffle storage game = games[gameId];
280     if (game.players.length < uint256(countOfParticipants)) revert();
281     if (game.secret != bytes32(0)) revert();
282 
283     bytes32 hash = keccak256(result, secret);
284     if (game.hash != hash) revert();
285 
286     game.secret = secret;
287     game.result = result;
288     disburse(game);
289     emit NewReveal(gameId);
290   }
291 
292   function disburse (Shuffle storage game) private restricted {
293 
294     uint256 totalValue = game.value;
295 
296     for (uint8 x = 0; x < game.result.length; x++) {
297       uint256 indexOfDistribution = game.result[x];
298       address player = game.players[x];
299       uint256 playerDistribution = distributions[indexOfDistribution];
300       uint256 disbursement = totalValue * playerDistribution / (1 ether);
301       uint256 playerBalance = balances[player];
302 
303       game.value -= disbursement;
304       playerBalance += disbursement;
305       if (playerBalance < disbursement) revert();
306       balances[player] = playerBalance;
307     }
308 
309     balances[owner] += game.value;
310     game.value = 0;
311   }
312 
313   /* For the owner */
314 
315   function setPrice (uint256 price) public onlyOwner {
316     gamePrice = price;
317     emit NewPrice(price);
318   }
319 
320   function setDistribution (uint256[5] winnings) public onlyOwner {
321     distributions = winnings;
322     emit NewDistribution(winnings);
323   }
324 
325   /* For players */
326 
327   // anyone can withdraw on behalf of someone (when the player lacks the gas, for instance)
328   function withdrawToMany (address[] players) public {
329     for (uint8 x = 0; x < players.length; x++) {
330       address player = players[x];
331 
332       withdrawTo(player);
333     }
334   }
335 
336   function withdraw () public {
337     withdrawTo(msg.sender);
338   }
339 
340   function withdrawTo (address player) public {
341     uint256 playerBalance = balances[player];
342 
343     if (playerBalance > 0) {
344       balances[player] = 0;
345 
346       player.transfer(playerBalance);
347     }
348   }
349 
350   /* Utility */
351 
352   function contains (uint256 gameId, address candidate) public constant returns (bool) {
353     Shuffle storage game = games[gameId];
354     return contains(game, candidate);
355   }
356 
357   function contains (Shuffle storage game, address candidate) private constant returns (bool) {
358     for (uint256 x = 0; x < game.players.length; x++) {
359       address player = game.players[x];
360       if (candidate == player) {
361         return true;
362       }
363     }
364 
365     return false;
366   }
367 
368   function createHash (uint8[5] result, bytes32 secret) public pure returns (bytes32) {
369     bytes32 hash = keccak256(result, secret);
370     return hash;
371   }
372 
373   function verify (bytes32 hash, uint8[5] result, bytes32 secret) public pure returns (bool) {
374     return hash == createHash(result, secret);
375   }
376 
377   function verifyGame (uint256 gameId) public constant returns (bool) {
378     Shuffle storage game = games[gameId];
379     return verify(game.hash, game.result, game.secret);
380   }
381 
382   function getDistributions () public constant returns (uint256[5]) {
383     return distributions;
384   }
385 }