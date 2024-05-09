1 pragma solidity ^0.4.25;
2 
3 
4 // * DICE.SX: dice.sx (DSX) - Fair Game, Real Gain.
5 // * 
6 // *
7 // * 100% Fair Ethereum Games.
8 // * No cheat. No signup required. No bullshit.
9 // *
10 // * All code and calculations are executed by smart contract.
11 // * That means 100% transparency, everything is calculated by this contact (including random hash generation).
12 // *
13 // * Contract address: 0xd1ce8888b962022365a660b17b4b6dcfa3c7ce7e
14 // *
15 // *
16 // * Website: https://dice.sx
17 //
18 
19 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, reverts on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (a == 0) {
35       return 0;
36     }
37 
38     uint256 c = a * b;
39     require(c / a == b);
40 
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b > 0); // Solidity only automatically asserts when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52     return c;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b <= a);
60     uint256 c = a - b;
61 
62     return c;
63   }
64 
65   /**
66   * @dev Adds two numbers, reverts on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     require(c >= a);
71 
72     return c;
73   }
74 
75   /**
76   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
77   * reverts when dividing by zero.
78   */
79   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80     require(b != 0);
81     return a % b;
82   }
83 }
84 
85 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93   address private _owner;
94 
95   event OwnershipTransferred(
96     address indexed previousOwner,
97     address indexed newOwner
98   );
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   constructor() internal {
105     _owner = msg.sender;
106     emit OwnershipTransferred(address(0), _owner);
107   }
108 
109   /**
110    * @return the address of the owner.
111    */
112   function owner() public view returns(address) {
113     return _owner;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(isOwner());
121     _;
122   }
123 
124   /**
125    * @return true if `msg.sender` is the owner of the contract.
126    */
127   function isOwner() public view returns(bool) {
128     return msg.sender == _owner;
129   }
130 
131   /**
132    * @dev Allows the current owner to relinquish control of the contract.
133    * @notice Renouncing to ownership will leave the contract without an owner.
134    * It will not be possible to call the functions with the `onlyOwner`
135    * modifier anymore.
136    */
137   function renounceOwnership() public onlyOwner {
138     emit OwnershipTransferred(_owner, address(0));
139     _owner = address(0);
140   }
141 
142   /**
143    * @dev Allows the current owner to transfer control of the contract to a newOwner.
144    * @param newOwner The address to transfer ownership to.
145    */
146   function transferOwnership(address newOwner) public onlyOwner {
147     _transferOwnership(newOwner);
148   }
149 
150   /**
151    * @dev Transfers control of the contract to a newOwner.
152    * @param newOwner The address to transfer ownership to.
153    */
154   function _transferOwnership(address newOwner) internal {
155     require(newOwner != address(0));
156     emit OwnershipTransferred(_owner, newOwner);
157     _owner = newOwner;
158   }
159 }
160 
161 // File: contracts/Jackpot.sol
162 
163 contract Jackpot is Ownable {
164     using SafeMath for uint256;
165 
166     struct Range {
167         uint256 end;
168         address player;
169     }
170 
171     uint256 constant public NO_WINNER = uint256(-1);
172     uint256 constant public BLOCK_STEP = 100; // Every 100 blocks
173     uint256 constant public PROBABILITY = 500; // 1/500 prob, each 9 days
174 
175     uint256 public winnerOffset = NO_WINNER;
176     uint256 public totalLength;
177     mapping (uint256 => Range) public ranges;
178     mapping (address => uint256) public playerLengths;
179 
180     function () public payable onlyOwner {
181     }
182 
183     function addRange(address player, uint256 length) public onlyOwner returns(uint256 begin, uint256 end) {
184         begin = totalLength;
185         end = begin.add(length);
186 
187         playerLengths[player] += length;
188         ranges[begin] = Range({
189             end: end,
190             player: player
191         });
192 
193         totalLength = end;
194     }
195 
196     function candidateBlockNumber() public view returns(uint256) {
197         return block.number.sub(1).div(BLOCK_STEP).mul(BLOCK_STEP);
198     }
199 
200     function candidateBlockNumberHash() public view returns(uint256) {
201         return uint256(blockhash(candidateBlockNumber()));
202     }
203 
204     function candidateNextBlockNumberHash() public view returns(uint256) {
205         return uint256(blockhash(candidateBlockNumber() + 1));
206     }
207 
208     function shouldSelectWinner() public view returns(bool) {
209         return totalLength > 0 &&
210             block.number > candidateBlockNumber() + 1 &&
211             (candidateBlockNumberHash() ^ uint256(this)) % PROBABILITY == 0;
212     }
213 
214     function selectWinner() public onlyOwner returns(uint256) {
215         require(winnerOffset == NO_WINNER, "Winner was selected");
216         require(shouldSelectWinner(), "Winner could not be selected now");
217 
218         winnerOffset = (candidateNextBlockNumberHash() / PROBABILITY) % totalLength;
219         return winnerOffset;
220     }
221 
222     function payJackpot(uint256 begin) public onlyOwner {
223         Range storage range = ranges[begin];
224         require(winnerOffset != NO_WINNER, "Winner was not selected");
225         require(begin <= winnerOffset && winnerOffset < range.end, "Not winning range");
226 
227         selfdestruct(range.player);
228     }
229 }
230 
231 // File: contracts/SX.sol
232 
233 contract SX is Ownable {
234     using SafeMath for uint256;
235 
236     string constant public name = "DICE.SX";
237     string constant public symbol = "DSX";
238 
239     uint256 public adminFeePercent = 1;   // 1%
240     uint256 public jackpotFeePercent = 1; // 1%
241     uint256 public maxRewardPercent = 10; // 10%
242     uint256 public minReward = 0.01 ether;
243     uint256 public maxReward = 3 ether;
244     
245     struct Game {
246         address player;
247         uint256 blockNumber;
248         uint256 value;
249         uint256 combinations;
250         uint256 answer;
251         uint256 salt;
252     }
253 
254     Game[] public games;
255     uint256 public gamesFinished;
256     uint256 public totalWeisInGame;
257     
258     Jackpot public nextJackpot;
259     Jackpot[] public prevJackpots;
260 
261     event GameStarted(
262         address indexed player,
263         uint256 indexed blockNumber,
264         uint256 indexed index,
265         uint256 combinations,
266         uint256 answer,
267         uint256 value
268     );
269     event GameFinished(
270         address indexed player,
271         uint256 indexed blockNumber,
272         uint256 value,
273         uint256 combinations,
274         uint256 answer,
275         uint256 result
276     );
277 
278     event JackpotRangeAdded(
279         uint256 indexed jackpotIndex,
280         address indexed player,
281         uint256 indexed begin,
282         uint256 end
283     );
284     event JackpotWinnerSelected(
285         uint256 indexed jackpotIndex,
286         uint256 offset
287     );
288     event JackpotRewardPayed(
289         uint256 indexed jackpotIndex,
290         address indexed player,
291         uint256 begin,
292         uint256 end,
293         uint256 winnerOffset,
294         uint256 value
295     );
296 
297     constructor() public {
298         nextJackpot = new Jackpot();
299     }
300 
301     function () public payable {
302         // Coin flip
303         uint256 prevBlockHash = uint256(blockhash(block.number - 1));
304         play(2, 1 << (prevBlockHash % 2));
305     }
306 
307     function gamesLength() public view returns(uint256) {
308         return games.length;
309     }
310 
311     function prevJackpotsLength() public view returns(uint256) {
312         return prevJackpots.length;
313     }
314 
315     function updateState() public {
316         finishAllGames();
317 
318         if (nextJackpot.shouldSelectWinner()) {
319             nextJackpot.selectWinner();
320             emit JackpotWinnerSelected(prevJackpots.length, nextJackpot.winnerOffset());
321 
322             prevJackpots.push(nextJackpot);
323             nextJackpot = new Jackpot();
324         }
325     }
326 
327     function playAndFinishJackpot(
328         uint256 combinations,
329         uint256 answer,
330         uint256 jackpotIndex,
331         uint256 begin
332     ) 
333         public
334         payable
335     {
336         finishJackpot(jackpotIndex, begin);
337         play(combinations, answer);
338     }
339 
340     function play(uint256 combinations, uint256 answer) public payable {
341         uint256 answerSize = _countBits(answer);
342         uint256 possibleReward = msg.value.mul(combinations).div(answerSize);
343         require(minReward <= possibleReward && possibleReward <= maxReward, "Possible reward value out of range");
344         require(possibleReward <= address(this).balance.mul(maxRewardPercent).div(100), "Possible reward value out of range");
345         require(answer > 0 && answer < (1 << combinations) - 1, "Answer should not contain all bits set");
346         require(2 <= combinations && combinations <= 100, "Combinations value is invalid");
347 
348         // Update
349         updateState();
350 
351         // Play game
352         uint256 blockNumber = block.number + 1;
353         emit GameStarted(
354             msg.sender,
355             blockNumber,
356             games.length,
357             combinations,
358             answer,
359             msg.value
360         );
361         games.push(Game({
362             player: msg.sender,
363             blockNumber: blockNumber,
364             value: msg.value,
365             combinations: combinations,
366             answer: answer,
367             salt: nextJackpot.totalLength()
368         }));
369 
370         (uint256 begin, uint256 end) = nextJackpot.addRange(msg.sender, msg.value);
371         emit JackpotRangeAdded(
372             prevJackpots.length,
373             msg.sender,
374             begin,
375             end
376         );
377 
378         totalWeisInGame = totalWeisInGame.add(possibleReward);
379         require(totalWeisInGame <= address(this).balance, "Not enough balance");
380     }
381 
382     function finishAllGames() public returns(uint256 count) {
383         while (finishNextGame()) {
384             count += 1;
385         }
386     }
387 
388     function finishNextGame() public returns(bool) {
389         if (gamesFinished >= games.length) {
390             return false;
391         }
392 
393         Game storage game = games[gamesFinished];
394         if (game.blockNumber >= block.number) {
395             return false;
396         }
397 
398         uint256 hash = uint256(blockhash(game.blockNumber));
399         bool lose = (hash == 0);
400         hash = uint256(keccak256(abi.encodePacked(hash, game.salt)));
401 
402         uint256 answerSize = _countBits(game.answer);
403         uint256 reward = game.value.mul(game.combinations).div(answerSize);
404         
405         uint256 result = 1 << (hash % game.combinations);
406         if (!lose && (result & game.answer) != 0) {
407             uint256 adminFee = reward.mul(adminFeePercent).div(100);
408             uint256 jackpotFee = reward.mul(jackpotFeePercent).div(100);
409 
410             owner().send(adminFee);                                 // solium-disable-line security/no-send
411             address(nextJackpot).send(jackpotFee);                  // solium-disable-line security/no-send
412             game.player.send(reward.sub(adminFee).sub(jackpotFee)); // solium-disable-line security/no-send
413         }
414 
415         emit GameFinished(
416             game.player,
417             game.blockNumber,
418             game.value,
419             game.combinations,
420             game.answer,
421             result
422         );
423         delete games[gamesFinished];
424         totalWeisInGame = totalWeisInGame.sub(reward);
425         gamesFinished += 1;
426         return true;
427     }
428 
429     function finishJackpot(uint256 jackpotIndex, uint256 begin) public {
430         if (jackpotIndex >= prevJackpots.length) {
431             return;
432         }
433 
434         Jackpot jackpot = prevJackpots[jackpotIndex];
435         if (address(jackpot).balance == 0) {
436             return;
437         }
438 
439         (uint256 end, address player) = jackpot.ranges(begin);
440         uint256 winnerOffset = jackpot.winnerOffset();
441         uint256 value = address(jackpot).balance;
442         jackpot.payJackpot(begin);
443         delete prevJackpots[jackpotIndex];
444         emit JackpotRewardPayed(
445             jackpotIndex,
446             player,
447             begin,
448             end,
449             winnerOffset,
450             value
451         );
452     }
453 
454     // Admin methods
455 
456     function setAdminFeePercent(uint256 feePercent) public onlyOwner {
457         require(feePercent <= 2, "Should be <= 2%");
458         adminFeePercent = feePercent;
459     }
460 
461     function setJackpotFeePercent(uint256 feePercent) public onlyOwner {
462         require(feePercent <= 3, "Should be <= 3%");
463         jackpotFeePercent = feePercent;
464     }
465 
466     function setMaxRewardPercent(uint256 value) public onlyOwner {
467         require(value <= 100, "Should not exceed 100%");
468         maxRewardPercent = value;
469     }
470 
471     function setMinReward(uint256 value) public onlyOwner {
472         minReward = value;
473     }
474 
475     function setMaxReward(uint256 value) public onlyOwner {
476         maxReward = value;
477     }
478 
479     function putToBank() public payable onlyOwner {
480     }
481 
482     function getFromBank(uint256 value) public onlyOwner {
483         msg.sender.transfer(value);
484         require(totalWeisInGame <= address(this).balance, "Not enough balance");
485     }
486 
487     function _countBits(uint256 arg) internal pure returns(uint256 count) {
488         uint256 value = arg;
489         while (value != 0) {
490             value &= value - 1; // clear the least significant bit set
491             count++;
492         }
493     }
494 }