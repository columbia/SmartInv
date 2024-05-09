1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5 
6   event NewOwner (address indexed owner);
7 
8   function Ownable () public {
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
25   function withdrawToken (address addressOfToken, uint256 amount) onlyOwner public returns (bool) {
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
65   function Operable (address[] newOperators) public {
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
125 contract EtherShuffle is Operable {
126 
127   uint256 public nextGameId = 1;
128   uint256 public lowestGameWithoutQuorum = 1;
129 
130   uint256[5] public distributions = [300000000000000000, // 30%
131     250000000000000000,
132     225000000000000000,
133     212500000000000000,
134     0];
135     // 12500000000000000 == 1.25%
136 
137   uint8 public constant countOfParticipants = 5;
138   uint256 public gamePrice = 100 finney;
139 
140   mapping (uint256 => Shuffle) public games;
141   mapping (address => uint256[]) public gamesByPlayer;
142   mapping (uint256 => uint256) public gamesWithoutQuorum;
143   mapping (address => uint256) public balances;
144 
145   struct Shuffle {
146     uint256 id;
147     address[] players;
148     bytes32 hash;
149     uint8[5] result;
150     bytes32 secret;
151     uint256 value;
152   }
153 
154   event NewGame (uint256 indexed gameId);
155   event NewHash (uint256 indexed gameId);
156   event NewReveal (uint256 indexed gameId);
157   event NewPrice (uint256 price);
158   event NewDistribution (uint256[5]);
159   event Quorum (uint256 indexed gameId);
160 
161   function EtherShuffle (address[] operators)
162     Operable(operators) public {
163   }
164 
165   modifier onlyExternalAccount () {
166     uint size;
167     address addr = msg.sender;
168     assembly { size := extcodesize(addr) }
169     if (size > 0) revert();
170     _;
171   }
172 
173   // send 0 ETH to withdraw, otherwise send enough to play
174   function () public payable {
175     if (msg.value == 0) {
176       withdrawTo(msg.sender);
177     } else {
178       play();
179     }
180   }
181 
182   function play () public payable whenNotPaused onlyExternalAccount {
183     if (msg.value < gamePrice) revert();
184     joinGames(msg.sender, msg.value);
185   }
186 
187   function playFromBalance () public whenNotPaused onlyExternalAccount {
188     uint256 balanceOf = balances[msg.sender];
189     if (balanceOf < gamePrice) revert();
190 
191     balances[msg.sender] = 0;
192     joinGames(msg.sender, balanceOf);
193   }
194 
195   
196 
197   function joinGames (address player, uint256 value) private {
198 
199     while (value >= gamePrice) {
200       uint256 id = findAvailableGame(player);
201       Shuffle storage game = games[id];
202 
203       value -= gamePrice;
204       joinGame(game, player, gamePrice);
205     }
206     
207     balances[player] += value;
208     if (balances[player] < value) revert();
209   }
210 
211   function joinGame (Shuffle storage game, address player, uint256 value) private {
212     if (game.id == 0) revert();
213 
214     if (value != gamePrice) revert();
215     game.value += gamePrice;
216     if (game.value < gamePrice) revert();
217 
218     game.players.push(player);
219     gamesByPlayer[player].push(game.id);
220 
221     if (game.players.length == countOfParticipants) {
222       delete gamesWithoutQuorum[game.id];
223       lowestGameWithoutQuorum++;
224       emit Quorum(game.id);
225     }
226 
227     if (game.players.length > countOfParticipants) revert();
228   }
229 
230   function findAvailableGame (address player) private returns (uint256) {
231     for (uint256 x = lowestGameWithoutQuorum; x < nextGameId; x++) {
232       Shuffle storage game = games[x];
233 
234       // games which have met quorum are removed from this mapping
235       if (game.id == 0) continue;
236 
237       if (!contains(game, player)) {
238         return game.id;
239       }
240     }
241 
242     // if a sender gets here, they've joined all available games,
243     // create a new one
244     return newGame();
245   }
246 
247   function newGame () private returns (uint256) {
248     uint256 gameId = nextGameId;
249     nextGameId++;
250     Shuffle storage game = games[gameId];
251 
252     // ensure this is a real uninitialized game
253     if (game.id != 0) revert();
254 
255     game.id = gameId;
256     gamesWithoutQuorum[gameId] = gameId;
257     emit NewGame(gameId);
258     return gameId;
259   }
260 
261   function gamesOf (address player) public constant returns (uint256[]) {
262     return gamesByPlayer[player];
263   }
264 
265   function balanceOf (address player) public constant returns (uint256) {
266     return balances[player];
267   }
268 
269   function getPlayers (uint256 gameId) public constant returns (address[]) {
270     Shuffle storage game = games[gameId];
271     return game.players;
272   }
273 
274   function hasHash (uint256 gameId) public constant returns (bool) {
275     Shuffle storage game = games[gameId];
276     return game.hash != bytes32(0);
277   }
278 
279   function getHash (uint256 gameId) public constant returns (bytes32) {
280     Shuffle storage game = games[gameId];
281     return game.hash;
282   }
283 
284   function getResult (uint256 gameId) public constant returns (uint8[5]) {
285     Shuffle storage game = games[gameId];
286     return game.result;
287   }
288 
289   function hasSecret (uint256 gameId) public constant returns (bool) {
290     Shuffle storage game = games[gameId];
291     return game.secret != bytes32(0);
292   }
293 
294   function getSecret (uint256 gameId) public constant returns (bytes32) {
295     Shuffle storage game = games[gameId];
296     return game.secret;
297   }
298     
299   function getValue (uint256 gameId) public constant returns (uint256) {
300     Shuffle storage game = games[gameId];
301     return game.value;
302   }
303 
304   function setHash (uint256 gameId, bytes32 hash) public whenNotPaused restricted {
305     Shuffle storage game = games[gameId];
306     if (game.id == 0) revert();
307     if (game.hash != bytes32(0)) revert();
308 
309     game.hash = hash;
310     emit NewHash(game.id);
311   }
312 
313   function reveal (uint256 gameId, uint8[5] result, bytes32 secret) public whenNotPaused restricted {
314     Shuffle storage game = games[gameId];
315     if (game.id == 0) revert();
316     if (game.players.length < uint256(countOfParticipants)) revert();
317     if (game.hash == bytes32(0)) revert();
318     if (game.secret != bytes32(0)) revert();
319 
320     bytes32 hash = keccak256(result, secret);
321     if (game.hash != hash) revert();
322 
323     game.secret = secret;
324     game.result = result;
325     disburse(game);
326     emit NewReveal(gameId);
327   }
328 
329   function disburse (Shuffle storage game) private restricted {
330     if (game.players.length != countOfParticipants) revert();
331 
332     uint256 totalValue = game.value;
333 
334     for (uint8 x = 0; x < game.result.length; x++) {
335       uint256 indexOfDistribution = game.result[x];
336       address player = game.players[x];
337       uint256 playerDistribution = distributions[indexOfDistribution];
338       uint256 disbursement = totalValue * playerDistribution / (1 ether);
339       uint256 playerBalance = balances[player];
340 
341       game.value -= disbursement;
342       playerBalance += disbursement;
343       if (playerBalance < disbursement) revert();
344       balances[player] = playerBalance;
345     }
346 
347     balances[owner] += game.value;
348     game.value = 0;
349   }
350 
351   function setPrice (uint256 price) public onlyOwner {
352     gamePrice = price;
353     emit NewPrice(price);
354   }
355 
356   function setDistribution (uint256[5] winnings) public onlyOwner {
357     distributions = winnings;
358     emit NewDistribution(winnings);
359   }
360 
361   // anyone can withdraw on behalf of someone (when the player lacks the gas, for instance)
362   function withdrawToMany (address[] players) public {
363     for (uint8 x = 0; x < players.length; x++) {
364       address player = players[x];
365 
366       withdrawTo(player);
367     }
368   }
369 
370   function withdraw () public {
371     withdrawTo(msg.sender);
372   }
373 
374   function withdrawTo (address player) public {
375     uint256 playerBalance = balances[player];
376 
377     if (playerBalance > 0) {
378       balances[player] = 0;
379 
380       player.transfer(playerBalance);
381     }
382   }
383 
384   function contains (uint256 gameId, address candidate) public constant returns (bool) {
385     Shuffle storage game = games[gameId];
386     return contains(game, candidate);
387   }
388 
389   function contains (Shuffle storage game, address candidate) private constant returns (bool) {
390     for (uint256 x = 0; x < game.players.length; x++) {
391       address player = game.players[x];
392       if (candidate == player) {
393         return true;
394       }
395     }
396 
397     return false;
398   }
399 
400   function createHash (uint8[5] result, bytes32 secret) public pure returns (bytes32) {
401     bytes32 hash = keccak256(result, secret);
402     return hash;
403   }
404 
405   function verify (bytes32 hash, uint8[5] result, bytes32 secret) public pure returns (bool) {
406     return hash == createHash(result, secret);
407   }
408 
409   function verifyGame (uint256 gameId) public constant returns (bool) {
410     Shuffle storage game = games[gameId];
411     return verify(game.hash, game.result, game.secret);
412   }
413 
414   function verifySignature (address signer, bytes32 hash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
415     bytes memory prefix = '\x19Ethereum Signed Message:\n32';
416     bytes32 prefixedHash = keccak256(prefix, hash);
417     return ecrecover(prefixedHash, v, r, s) == signer;
418   }
419 
420   function getNextGameId () public constant returns (uint256) {
421     return nextGameId;
422   }
423 
424   function getLowestGameWithoutQuorum () public constant returns (uint256) {
425     return lowestGameWithoutQuorum;
426   }
427 }