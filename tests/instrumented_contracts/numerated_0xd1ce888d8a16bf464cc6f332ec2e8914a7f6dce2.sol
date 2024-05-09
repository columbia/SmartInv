1 pragma solidity ^0.4.24;
2 
3 
4 // * DICE.SX: dice.sx (DSX) - Fair Game, Real Gain.
5 // * Version: 1.00.2
6 // *
7 // * 100% Fair Ethereum Games.
8 // * No cheat. No signup required. No bullshit.
9 // *
10 // * All code and calculations are executed by a smart contract.
11 // * That means 100% transparency, everything is calculated by this contact (including random hash generation).
12 // *
13 // * Contract address: 0xd1ce888d8a16bf464cc6f332ec2e8914a7f6dce2
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
173     uint256 constant public PROBABILITY = 1000; // 1/1000
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
196     function candidateBlockNumberHash() public view returns(uint256) {
197         uint256 blockNumber = block.number.sub(1).div(BLOCK_STEP).mul(BLOCK_STEP);
198         return uint256(blockhash(blockNumber));
199     }
200 
201     function shouldSelectWinner() public view returns(bool) {
202         return (candidateBlockNumberHash() ^ uint256(this)) % PROBABILITY == 0;
203     }
204 
205     function selectWinner() public onlyOwner returns(uint256) {
206         require(winnerOffset == NO_WINNER, "Winner was selected");
207         require(shouldSelectWinner(), "Winner could not be selected now");
208 
209         winnerOffset = (candidateBlockNumberHash() / PROBABILITY) % totalLength;
210         return winnerOffset;
211     }
212 
213     function payJackpot(uint256 begin) public onlyOwner {
214         Range storage range = ranges[begin];
215         require(winnerOffset != NO_WINNER, "Winner was not selected");
216         require(begin <= winnerOffset && winnerOffset < range.end, "Not winning range");
217 
218         selfdestruct(range.player);
219     }
220 }
221 
222 // File: contracts/SX.sol
223 
224 contract SX is Ownable {
225     using SafeMath for uint256;
226 
227     uint256 public adminFeePercent = 1;   // 1%
228     uint256 public jackpotFeePercent = 2; // 2%
229     uint256 public maxRewardPercent = 10; // 10%
230     uint256 public minReward = 0.01 ether;
231     uint256 public maxReward = 3 ether;
232     
233     struct Game {
234         address player;
235         uint256 blockNumber;
236         uint256 value;
237         uint256 combinations;
238         uint256 answer;
239     }
240 
241     Game[] public games;
242     uint256 public gamesFinished;
243     uint256 public totalWeisInGame;
244     
245     Jackpot public nextJackpot;
246     Jackpot[] public prevJackpots;
247 
248     event GameStarted(
249         address indexed player,
250         uint256 indexed blockNumber,
251         uint256 indexed index,
252         uint256 combinations,
253         uint256 answer,
254         uint256 value
255     );
256     event GameFinished(
257         address indexed player,
258         uint256 indexed blockNumber,
259         uint256 value,
260         uint256 combinations,
261         uint256 answer,
262         uint256 result
263     );
264 
265     event JackpotRangeAdded(
266         uint256 indexed jackpotIndex,
267         address indexed player,
268         uint256 indexed begin,
269         uint256 end
270     );
271     event JackpotWinnerSelected(
272         uint256 indexed jackpotIndex,
273         uint256 offset
274     );
275     event JackpotRewardPayed(
276         uint256 indexed jackpotIndex,
277         address indexed player,
278         uint256 begin,
279         uint256 end,
280         uint256 winnerOffset,
281         uint256 value
282     );
283 
284     constructor() public {
285         nextJackpot = new Jackpot();
286     }
287 
288     function () public payable {
289         // Coin flip
290         uint256 prevBlockHash = uint256(blockhash(block.number - 1));
291         play(2, 1 << (prevBlockHash % 2));
292     }
293 
294     function gamesLength() public view returns(uint256) {
295         return games.length;
296     }
297 
298     function prevJackpotsLength() public view returns(uint256) {
299         return prevJackpots.length;
300     }
301 
302     function updateState() public {
303         finishAllGames();
304 
305         if (nextJackpot.shouldSelectWinner()) {
306             nextJackpot.selectWinner();
307             emit JackpotWinnerSelected(prevJackpots.length, nextJackpot.winnerOffset());
308 
309             prevJackpots.push(nextJackpot);
310             nextJackpot = new Jackpot();
311         }
312     }
313 
314     function playAndFinishJackpot(
315         uint256 combinations,
316         uint256 answer,
317         uint256 jackpotIndex,
318         uint256 begin
319     ) 
320         public
321         payable
322     {
323         finishJackpot(jackpotIndex, begin);
324         play(combinations, answer);
325     }
326 
327     function play(uint256 combinations, uint256 answer) public payable {
328         uint256 answerSize = _countBits(answer);
329         uint256 possibleReward = msg.value.mul(combinations).div(answerSize);
330         require(minReward <= possibleReward && possibleReward <= maxReward, "Possible reward value out of range");
331         require(possibleReward <= address(this).balance.mul(maxRewardPercent).div(100), "Possible reward value out of range");
332         require(answer > 0 && answer < (1 << combinations) - 1, "Answer should not contain all bits set");
333         require(2 <= combinations && combinations <= 100, "Combinations value is invalid");
334 
335         // Update
336         updateState();
337 
338         // Play game
339         uint256 blockNumber = block.number + 1;
340         emit GameStarted(
341             msg.sender,
342             blockNumber,
343             games.length,
344             combinations,
345             answer,
346             msg.value
347         );
348         games.push(Game({
349             player: msg.sender,
350             blockNumber: blockNumber,
351             value: msg.value,
352             combinations: combinations,
353             answer: answer
354         }));
355 
356         (uint256 begin, uint256 end) = nextJackpot.addRange(msg.sender, msg.value);
357         emit JackpotRangeAdded(
358             prevJackpots.length,
359             msg.sender,
360             begin,
361             end
362         );
363 
364         totalWeisInGame = totalWeisInGame.add(possibleReward);
365         require(totalWeisInGame <= address(this).balance, "Not enough balance");
366     }
367 
368     function finishAllGames() public returns(uint256 count) {
369         while (finishNextGame()) {
370             count += 1;
371         }
372     }
373 
374     function finishNextGame() public returns(bool) {
375         if (gamesFinished >= games.length) {
376             return false;
377         }
378 
379         Game storage game = games[gamesFinished];
380         if (game.blockNumber >= block.number) {
381             return false;
382         }
383 
384         uint256 hash = uint256(blockhash(game.blockNumber));
385         bool lose = (hash == 0);
386 
387         uint256 answerSize = _countBits(game.answer);
388         uint256 reward = game.value.mul(game.combinations).div(answerSize);
389         
390         uint256 result = 1 << (hash % game.combinations);
391         if (!lose && (result & game.answer) != 0) {
392             uint256 adminFee = reward.mul(adminFeePercent).div(100);
393             uint256 jackpotFee = reward.mul(jackpotFeePercent).div(100);
394 
395             owner().send(adminFee);                                 // solium-disable-line security/no-send
396             address(nextJackpot).send(jackpotFee);                  // solium-disable-line security/no-send
397             game.player.send(reward.sub(adminFee).sub(jackpotFee)); // solium-disable-line security/no-send
398         }
399 
400         emit GameFinished(
401             game.player,
402             game.blockNumber,
403             game.value,
404             game.combinations,
405             game.answer,
406             result
407         );
408         totalWeisInGame = totalWeisInGame.sub(reward);
409         gamesFinished += 1;
410         return true;
411     }
412 
413     function finishJackpot(uint256 jackpotIndex, uint256 begin) public {
414         if (jackpotIndex >= prevJackpots.length) {
415             return;
416         }
417 
418         Jackpot jackpot = prevJackpots[jackpotIndex];
419         if (address(jackpot).balance == 0) {
420             return;
421         }
422 
423         (uint256 end, address player) = jackpot.ranges(begin);
424         uint256 winnerOffset = jackpot.winnerOffset();
425         uint256 value = address(jackpot).balance;
426         jackpot.payJackpot(begin);
427         emit JackpotRewardPayed(
428             jackpotIndex,
429             player,
430             begin,
431             end,
432             winnerOffset,
433             value
434         );
435     }
436 
437     // Admin methods
438 
439     function setAdminFeePercent(uint256 feePercent) public onlyOwner {
440         require(feePercent <= 2, "Should be <= 2%");
441         adminFeePercent = feePercent;
442     }
443 
444     function setJackpotFeePercent(uint256 feePercent) public onlyOwner {
445         require(feePercent <= 3, "Should be <= 3%");
446         jackpotFeePercent = feePercent;
447     }
448 
449     function setMaxRewardPercent(uint256 value) public onlyOwner {
450         require(value <= 100, "Should not exceed 100%");
451         maxRewardPercent = value;
452     }
453 
454     function setMinReward(uint256 value) public onlyOwner {
455         minReward = value;
456     }
457 
458     function setMaxReward(uint256 value) public onlyOwner {
459         maxReward = value;
460     }
461 
462     function putToBank() public payable onlyOwner {
463     }
464 
465     function getFromBank(uint256 value) public onlyOwner {
466         msg.sender.transfer(value);
467         require(totalWeisInGame <= address(this).balance, "Not enough balance");
468     }
469 
470     function _countBits(uint256 arg) internal pure returns(uint256 count) {
471         uint256 value = arg;
472         while (value != 0) {
473             value &= value - 1; // clear the least significant bit set
474             count++;
475         }
476     }
477 }