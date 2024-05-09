1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title Claimable
94  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
95  * This allows the new owner to accept the transfer.
96  */
97 contract Claimable is Ownable {
98   address public pendingOwner;
99 
100   /**
101    * @dev Modifier throws if called by any account other than the pendingOwner.
102    */
103   modifier onlyPendingOwner() {
104     require(msg.sender == pendingOwner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to set the pendingOwner address.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) onlyOwner public {
113     pendingOwner = newOwner;
114   }
115 
116   /**
117    * @dev Allows the pendingOwner address to finalize the transfer.
118    */
119   function claimOwnership() onlyPendingOwner public {
120     OwnershipTransferred(owner, pendingOwner);
121     owner = pendingOwner;
122     pendingOwner = address(0);
123   }
124 }
125 
126 
127 /**
128  * @title Pausable
129  * @dev Base contract which allows children to implement an emergency stop mechanism.
130  */
131 contract Pausable is Ownable {
132   event Pause();
133   event Unpause();
134 
135   bool public paused = false;
136 
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is not paused.
140    */
141   modifier whenNotPaused() {
142     require(!paused);
143     _;
144   }
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is paused.
148    */
149   modifier whenPaused() {
150     require(paused);
151     _;
152   }
153 
154   /**
155    * @dev called by the owner to pause, triggers stopped state
156    */
157   function pause() onlyOwner whenNotPaused public {
158     paused = true;
159     Pause();
160   }
161 
162   /**
163    * @dev called by the owner to unpause, returns to normal state
164    */
165   function unpause() onlyOwner whenPaused public {
166     paused = false;
167     Unpause();
168   }
169 }
170 
171 
172 /**
173  * @title ERC20Basic
174  * @dev Simpler version of ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/179
176  */
177 contract ERC20Basic {
178   function totalSupply() public view returns (uint256);
179   function balanceOf(address who) public view returns (uint256);
180   function transfer(address to, uint256 value) public returns (bool);
181   event Transfer(address indexed from, address indexed to, uint256 value);
182 }
183 
184 
185 /**
186  * @title ERC20 interface
187  * @dev see https://github.com/ethereum/EIPs/issues/20
188  */
189 contract ERC20 is ERC20Basic {
190   function allowance(address owner, address spender) public view returns (uint256);
191   function transferFrom(address from, address to, uint256 value) public returns (bool);
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 
197 /**
198  * @title SafeERC20
199  * @dev Wrappers around ERC20 operations that throw on failure.
200  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
201  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
202  */
203 library SafeERC20 {
204   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
205     assert(token.transfer(to, value));
206   }
207 
208   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
209     assert(token.transferFrom(from, to, value));
210   }
211 
212   function safeApprove(ERC20 token, address spender, uint256 value) internal {
213     assert(token.approve(spender, value));
214   }
215 }
216 
217 
218 /**
219  * @title Contracts that should be able to recover tokens
220  * @author SylTi
221  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
222  * This will prevent any accidental loss of tokens.
223  */
224 contract CanReclaimToken is Ownable {
225   using SafeERC20 for ERC20Basic;
226 
227   /**
228    * @dev Reclaim all ERC20Basic compatible tokens
229    * @param token ERC20Basic The address of the token contract
230    */
231   function reclaimToken(ERC20Basic token) external onlyOwner {
232     uint256 balance = token.balanceOf(this);
233     token.safeTransfer(owner, balance);
234   }
235 
236 }
237 
238 
239 /// @dev Implements access control to the DWorld contract.
240 contract BurnupGameAccessControl is Claimable, Pausable, CanReclaimToken {
241     mapping (address => bool) public cfo;
242     
243     function BurnupGameAccessControl() public {
244         // The creator of the contract is a CFO.
245         cfo[msg.sender] = true;
246     }
247     
248     /// @dev Access modifier for CFO-only functionality.
249     modifier onlyCFO() {
250         require(cfo[msg.sender]);
251         _;
252     }
253 
254     /// @dev Assigns or removes an address to act as a CFO. Only available to the current contract owner.
255     /// @param addr The address to set or unset as CFO.
256     /// @param set Whether to set or unset the address as CFO.
257     function setCFO(address addr, bool set) external onlyOwner {
258         require(addr != address(0));
259 
260         if (!set) {
261             delete cfo[addr];
262         } else {
263             cfo[addr] = true;
264         }
265     }
266 }
267 
268 
269 /// @dev Defines base data structures for DWorld.
270 contract BurnupGameBase is BurnupGameAccessControl {
271     using SafeMath for uint256;
272     
273     event ActiveTimes(uint256[] from, uint256[] to);
274     event AllowStart(bool allowStart);
275     event NextGame(
276         uint256 rows,
277         uint256 cols,
278         uint256 initialActivityTimer,
279         uint256 finalActivityTimer,
280         uint256 numberOfFlipsToFinalActivityTimer,
281         uint256 timeoutBonusTime,
282         uint256 unclaimedTilePrice,
283         uint256 buyoutReferralBonusPercentage,
284         uint256 firstBuyoutPrizePoolPercentage,
285         uint256 buyoutPrizePoolPercentage,
286         uint256 buyoutDividendPercentage,
287         uint256 buyoutFeePercentage,
288         uint256 buyoutPriceIncreasePercentage
289     );
290     event Start(
291         uint256 indexed gameIndex,
292         address indexed starter,
293         uint256 timestamp,
294         uint256 prizePool
295     );
296     event End(uint256 indexed gameIndex, address indexed winner, uint256 indexed identifier, uint256 x, uint256 y, uint256 timestamp, uint256 prize);
297     event Buyout(
298         uint256 indexed gameIndex,
299         address indexed player,
300         uint256 indexed identifier,
301         uint256 x,
302         uint256 y,
303         uint256 timestamp,
304         uint256 timeoutTimestamp,
305         uint256 newPrice,
306         uint256 newPrizePool
307     );
308     event LastTile(
309         uint256 indexed gameIndex,
310         uint256 indexed identifier,
311         uint256 x,
312         uint256 y
313     );
314     event PenultimateTileTimeout(
315         uint256 indexed gameIndex,
316         uint256 timeoutTimestamp
317     );
318     event SpiceUpPrizePool(uint256 indexed gameIndex, address indexed spicer, uint256 spiceAdded, string message, uint256 newPrizePool);
319     
320     /// @dev Struct to hold game settings.
321     struct GameSettings {
322         uint256 rows; // 5
323         uint256 cols; // 8
324         
325         /// @dev Initial time after last trade after which tiles become inactive.
326         uint256 initialActivityTimer; // 600
327         
328         /// @dev Final time after last trade after which tiles become inactive.
329         uint256 finalActivityTimer; // 300
330         
331         /// @dev Number of flips for the activity timer to move from the initial
332         /// activity timer to the final activity timer.
333         uint256 numberOfFlipsToFinalActivityTimer; // 80
334         
335         /// @dev The timeout bonus time in seconds per tile owned by the player.
336         uint256 timeoutBonusTime; // 30
337         
338         /// @dev Base price for unclaimed tiles.
339         uint256 unclaimedTilePrice; // 0.01 ether
340         
341         /// @dev Percentage of the buyout price that goes towards the referral
342         /// bonus. In 1/1000th of a percentage.
343         uint256 buyoutReferralBonusPercentage; // 750
344         
345         /// @dev For the initial buyout of a tile: percentage of the buyout price
346         /// that goes towards the prize pool. In 1/1000th of a percentage.
347         uint256 firstBuyoutPrizePoolPercentage; // 40000
348         
349         /// @dev Percentage of the buyout price that goes towards the prize
350         /// pool. In 1/1000th of a percentage.
351         uint256 buyoutPrizePoolPercentage; // 10000
352     
353         /// @dev Percentage of the buyout price that goes towards dividends
354         /// surrounding the tile that is bought out. In in 1/1000th of
355         /// a percentage.
356         uint256 buyoutDividendPercentage; // 5000
357     
358         /// @dev Buyout fee in 1/1000th of a percentage.
359         uint256 buyoutFeePercentage; // 2500
360         
361         /// @dev Buyout price increase in 1/1000th of a percentage. 
362         uint256 buyoutPriceIncreasePercentage;
363     }
364     
365     /// @dev Struct to hold game state.
366     struct GameState {
367         /// @dev Boolean indicating whether the game is live.
368         bool gameStarted;
369     
370         /// @dev Time at which the game started.
371         uint256 gameStartTimestamp;
372     
373         /// @dev Keep track of tile ownership.
374         mapping (uint256 => address) identifierToOwner;
375         
376         /// @dev Keep track of the timestamp at which a tile was flipped last.
377         mapping (uint256 => uint256) identifierToTimeoutTimestamp;
378         
379         /// @dev Current tile price.
380         mapping (uint256 => uint256) identifierToBuyoutPrice;
381         
382         /// @dev The number of tiles owned by an address.
383         mapping (address => uint256) addressToNumberOfTiles;
384         
385         /// @dev The number of tile flips performed.
386         uint256 numberOfTileFlips;
387         
388         /// @dev Keep track of the tile that will become inactive last.
389         uint256 lastTile;
390         
391         /// @dev Keep track of the timeout of the penultimate tile.
392         uint256 penultimateTileTimeout;
393         
394         /// @dev The prize pool.
395         uint256 prizePool;
396     }
397     
398     /// @notice Mapping from game indices to game states.
399     mapping (uint256 => GameState) public gameStates;
400     
401     /// @notice The index of the current game.
402     uint256 public gameIndex = 0;
403     
404     /// @notice Current game settings.
405     GameSettings public gameSettings;
406     
407     /// @dev Settings for the next game
408     GameSettings public nextGameSettings;
409     
410     /// @notice Time windows in seconds from the start of the week
411     /// when new games can be started.
412     uint256[] public activeTimesFrom;
413     uint256[] public activeTimesTo;
414     
415     /// @notice Whether the game can start once outside of active times.
416     bool public allowStart;
417     
418     function BurnupGameBase() public {
419         // Initial settings.
420         setNextGameSettings(
421             4, // rows
422             5, // cols
423             300, // initialActivityTimer // todo set to 600
424             150, // finalActivityTimer // todo set to 150
425             5, // numberOfFlipsToFinalActivityTimer // todo set to 80
426             30, // timeoutBonusTime
427             0.01 ether, // unclaimedTilePrice
428             750, // buyoutReferralBonusPercentage
429             40000, // firstBuyoutPrizePoolPercentage
430             10000, // buyoutPrizePoolPercentage
431             5000, // buyoutDividendPercentage
432             2500, // buyoutFeePercentage
433             150000 // buyoutPriceIncreasePercentage
434         );
435     }
436     
437     /// @dev Test whether the coordinate is valid.
438     /// @param x The x-part of the coordinate to test.
439     /// @param y The y-part of the coordinate to test.
440     function validCoordinate(uint256 x, uint256 y) public view returns(bool) {
441         return x < gameSettings.cols && y < gameSettings.rows;
442     }
443     
444     /// @dev Represent a 2D coordinate as a single uint.
445     /// @param x The x-coordinate.
446     /// @param y The y-coordinate.
447     function coordinateToIdentifier(uint256 x, uint256 y) public view returns(uint256) {
448         require(validCoordinate(x, y));
449         
450         return (y * gameSettings.cols) + x + 1;
451     }
452     
453     /// @dev Turn a single uint representation of a coordinate into its x and y parts.
454     /// @param identifier The uint representation of a coordinate.
455     /// Assumes the identifier is valid.
456     function identifierToCoordinate(uint256 identifier) public view returns(uint256 x, uint256 y) {
457         y = (identifier - 1) / gameSettings.cols;
458         x = (identifier - 1) - (y * gameSettings.cols);
459     }
460     
461     /// @notice Sets the settings for the next game.
462     function setNextGameSettings(
463         uint256 rows,
464         uint256 cols,
465         uint256 initialActivityTimer,
466         uint256 finalActivityTimer,
467         uint256 numberOfFlipsToFinalActivityTimer,
468         uint256 timeoutBonusTime,
469         uint256 unclaimedTilePrice,
470         uint256 buyoutReferralBonusPercentage,
471         uint256 firstBuyoutPrizePoolPercentage,
472         uint256 buyoutPrizePoolPercentage,
473         uint256 buyoutDividendPercentage,
474         uint256 buyoutFeePercentage,
475         uint256 buyoutPriceIncreasePercentage
476     )
477         public
478         onlyCFO
479     {
480         // Buyout dividend must be 2% at the least.
481         // Buyout dividend percentage may be 12.5% at the most.
482         require(2000 <= buyoutDividendPercentage && buyoutDividendPercentage <= 12500);
483         
484         // Buyout fee may be 5% at the most.
485         require(buyoutFeePercentage <= 5000);
486         
487         if (numberOfFlipsToFinalActivityTimer == 0) {
488             require(initialActivityTimer == finalActivityTimer);
489         }
490         
491         nextGameSettings = GameSettings({
492             rows: rows,
493             cols: cols,
494             initialActivityTimer: initialActivityTimer,
495             finalActivityTimer: finalActivityTimer,
496             numberOfFlipsToFinalActivityTimer: numberOfFlipsToFinalActivityTimer,
497             timeoutBonusTime: timeoutBonusTime,
498             unclaimedTilePrice: unclaimedTilePrice,
499             buyoutReferralBonusPercentage: buyoutReferralBonusPercentage,
500             firstBuyoutPrizePoolPercentage: firstBuyoutPrizePoolPercentage,
501             buyoutPrizePoolPercentage: buyoutPrizePoolPercentage,
502             buyoutDividendPercentage: buyoutDividendPercentage,
503             buyoutFeePercentage: buyoutFeePercentage,
504             buyoutPriceIncreasePercentage: buyoutPriceIncreasePercentage
505         });
506         
507         NextGame(
508             rows,
509             cols,
510             initialActivityTimer,
511             finalActivityTimer,
512             numberOfFlipsToFinalActivityTimer,
513             timeoutBonusTime,
514             unclaimedTilePrice,
515             buyoutReferralBonusPercentage, 
516             firstBuyoutPrizePoolPercentage,
517             buyoutPrizePoolPercentage,
518             buyoutDividendPercentage,
519             buyoutFeePercentage,
520             buyoutPriceIncreasePercentage
521         );
522     }
523     
524     /// @notice Set the active times.
525     function setActiveTimes(uint256[] _from, uint256[] _to) external onlyCFO {
526         require(_from.length == _to.length);
527     
528         activeTimesFrom = _from;
529         activeTimesTo = _to;
530         
531         // Emit event.
532         ActiveTimes(_from, _to);
533     }
534     
535     /// @notice Allow the game to start once outside of active times.
536     function setAllowStart(bool _allowStart) external onlyCFO {
537         allowStart = _allowStart;
538         
539         // Emit event.
540         AllowStart(_allowStart);
541     }
542     
543     /// @notice A boolean indicating whether a new game can start,
544     /// based on the active times.
545     function canStart() public view returns (bool) {
546         // Get the time of the week in seconds.
547         // There are 7 * 24 * 60 * 60 = 604800 seconds in a week,
548         // and unix timestamps started counting from a Thursday,
549         // so subtract 4 * 24 * 60 * 60 = 345600 seconds, as
550         // (0 - 345600) % 604800 = 259200, i.e. the number of
551         // seconds in a week until Thursday 00:00:00.
552         uint256 timeOfWeek = (block.timestamp - 345600) % 604800;
553         
554         uint256 windows = activeTimesFrom.length;
555         
556         if (windows == 0) {
557             // No start times configured, any time is allowed.
558             return true;
559         }
560         
561         for (uint256 i = 0; i < windows; i++) {
562             if (timeOfWeek >= activeTimesFrom[i] && timeOfWeek <= activeTimesTo[i]) {
563                 return true;
564             }
565         }
566         
567         return false;
568     }
569     
570     /// @notice Calculate the current game's base timeout.
571     function calculateBaseTimeout() public view returns(uint256) {
572         uint256 _numberOfTileFlips = gameStates[gameIndex].numberOfTileFlips;
573     
574         if (_numberOfTileFlips >= gameSettings.numberOfFlipsToFinalActivityTimer || gameSettings.numberOfFlipsToFinalActivityTimer == 0) {
575             return gameSettings.finalActivityTimer;
576         } else {
577             if (gameSettings.finalActivityTimer <= gameSettings.initialActivityTimer) {
578                 // The activity timer decreases over time.
579             
580                 // This cannot underflow, as initialActivityTimer is guaranteed to be
581                 // greater than or equal to finalActivityTimer.
582                 uint256 difference = gameSettings.initialActivityTimer - gameSettings.finalActivityTimer;
583                 
584                 // Calculate the decrease in activity timer, based on the number of wagers performed.
585                 uint256 decrease = difference.mul(_numberOfTileFlips).div(gameSettings.numberOfFlipsToFinalActivityTimer);
586                 
587                 // This subtraction cannot underflow, as decrease is guaranteed to be less than or equal to initialActivityTimer.            
588                 return (gameSettings.initialActivityTimer - decrease);
589             } else {
590                 // The activity timer increases over time.
591             
592                 // This cannot underflow, as initialActivityTimer is guaranteed to be
593                 // smaller than finalActivityTimer.
594                 difference = gameSettings.finalActivityTimer - gameSettings.initialActivityTimer;
595                 
596                 // Calculate the increase in activity timer, based on the number of wagers performed.
597                 uint256 increase = difference.mul(_numberOfTileFlips).div(gameSettings.numberOfFlipsToFinalActivityTimer);
598                 
599                 // This addition cannot overflow, as initialActivityTimer + increase is guaranteed to be less than or equal to finalActivityTimer.
600                 return (gameSettings.initialActivityTimer + increase);
601             }
602         }
603     }
604     
605     /// @notice Get the new timeout timestamp for a tile.
606     /// @param identifier The identifier of the tile being flipped.
607     /// @param player The address of the player flipping the tile.
608     function tileTimeoutTimestamp(uint256 identifier, address player) public view returns (uint256) {
609         uint256 bonusTime = gameSettings.timeoutBonusTime.mul(gameStates[gameIndex].addressToNumberOfTiles[player]);
610         uint256 timeoutTimestamp = block.timestamp.add(calculateBaseTimeout()).add(bonusTime);
611         
612         uint256 currentTimeoutTimestamp = gameStates[gameIndex].identifierToTimeoutTimestamp[identifier];
613         if (currentTimeoutTimestamp == 0) {
614             // Tile has never been flipped before.
615             currentTimeoutTimestamp = gameStates[gameIndex].gameStartTimestamp.add(gameSettings.initialActivityTimer);
616         }
617         
618         if (timeoutTimestamp >= currentTimeoutTimestamp) {
619             return timeoutTimestamp;
620         } else {
621             return currentTimeoutTimestamp;
622         }
623     }
624     
625     /// @dev Set the current game settings.
626     function _setGameSettings() internal {
627         if (gameSettings.rows != nextGameSettings.rows) {
628             gameSettings.rows = nextGameSettings.rows;
629         }
630         
631         if (gameSettings.cols != nextGameSettings.cols) {
632             gameSettings.cols = nextGameSettings.cols;
633         }
634         
635         if (gameSettings.initialActivityTimer != nextGameSettings.initialActivityTimer) {
636             gameSettings.initialActivityTimer = nextGameSettings.initialActivityTimer;
637         }
638         
639         if (gameSettings.finalActivityTimer != nextGameSettings.finalActivityTimer) {
640             gameSettings.finalActivityTimer = nextGameSettings.finalActivityTimer;
641         }
642         
643         if (gameSettings.numberOfFlipsToFinalActivityTimer != nextGameSettings.numberOfFlipsToFinalActivityTimer) {
644             gameSettings.numberOfFlipsToFinalActivityTimer = nextGameSettings.numberOfFlipsToFinalActivityTimer;
645         }
646         
647         if (gameSettings.timeoutBonusTime != nextGameSettings.timeoutBonusTime) {
648             gameSettings.timeoutBonusTime = nextGameSettings.timeoutBonusTime;
649         }
650         
651         if (gameSettings.unclaimedTilePrice != nextGameSettings.unclaimedTilePrice) {
652             gameSettings.unclaimedTilePrice = nextGameSettings.unclaimedTilePrice;
653         }
654         
655         if (gameSettings.buyoutReferralBonusPercentage != nextGameSettings.buyoutReferralBonusPercentage) {
656             gameSettings.buyoutReferralBonusPercentage = nextGameSettings.buyoutReferralBonusPercentage;
657         }
658         
659         if (gameSettings.firstBuyoutPrizePoolPercentage != nextGameSettings.firstBuyoutPrizePoolPercentage) {
660             gameSettings.firstBuyoutPrizePoolPercentage = nextGameSettings.firstBuyoutPrizePoolPercentage;
661         }
662         
663         if (gameSettings.buyoutPrizePoolPercentage != nextGameSettings.buyoutPrizePoolPercentage) {
664             gameSettings.buyoutPrizePoolPercentage = nextGameSettings.buyoutPrizePoolPercentage;
665         }
666         
667         if (gameSettings.buyoutDividendPercentage != nextGameSettings.buyoutDividendPercentage) {
668             gameSettings.buyoutDividendPercentage = nextGameSettings.buyoutDividendPercentage;
669         }
670         
671         if (gameSettings.buyoutFeePercentage != nextGameSettings.buyoutFeePercentage) {
672             gameSettings.buyoutFeePercentage = nextGameSettings.buyoutFeePercentage;
673         }
674         
675         if (gameSettings.buyoutPriceIncreasePercentage != nextGameSettings.buyoutPriceIncreasePercentage) {
676             gameSettings.buyoutPriceIncreasePercentage = nextGameSettings.buyoutPriceIncreasePercentage;
677         }
678     }
679 }
680 
681 
682 /// @dev Holds ownership functionality such as transferring.
683 contract BurnupGameOwnership is BurnupGameBase {
684     
685     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
686     
687     /// @notice Name of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
688     function name() public pure returns (string _deedName) {
689         _deedName = "Burnup Tiles";
690     }
691     
692     /// @notice Symbol of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
693     function symbol() public pure returns (string _deedSymbol) {
694         _deedSymbol = "BURN";
695     }
696     
697     /// @dev Checks if a given address owns a particular tile.
698     /// @param _owner The address of the owner to check for.
699     /// @param _identifier The tile identifier to check for.
700     function _owns(address _owner, uint256 _identifier) internal view returns (bool) {
701         return gameStates[gameIndex].identifierToOwner[_identifier] == _owner;
702     }
703     
704     /// @dev Assigns ownership of a specific deed to an address.
705     /// @param _from The address to transfer the deed from.
706     /// @param _to The address to transfer the deed to.
707     /// @param _identifier The identifier of the deed to transfer.
708     function _transfer(address _from, address _to, uint256 _identifier) internal {
709         // Transfer ownership.
710         gameStates[gameIndex].identifierToOwner[_identifier] = _to;
711         
712         if (_from != 0x0) {
713             gameStates[gameIndex].addressToNumberOfTiles[_from] = gameStates[gameIndex].addressToNumberOfTiles[_from].sub(1);
714         }
715         
716         gameStates[gameIndex].addressToNumberOfTiles[_to] = gameStates[gameIndex].addressToNumberOfTiles[_to].add(1);
717         
718         // Emit the transfer event.
719         Transfer(_from, _to, _identifier);
720     }
721     
722     /// @notice Returns the address currently assigned ownership of a given deed.
723     /// @dev Required for ERC-721 compliance.
724     function ownerOf(uint256 _identifier) external view returns (address _owner) {
725         _owner = gameStates[gameIndex].identifierToOwner[_identifier];
726 
727         require(_owner != address(0));
728     }
729     
730     /// @notice Transfer a deed to another address. If transferring to a smart
731     /// contract be VERY CAREFUL to ensure that it is aware of ERC-721, or your
732     /// deed may be lost forever.
733     /// @param _to The address of the recipient, can be a user or contract.
734     /// @param _identifier The identifier of the deed to transfer.
735     /// @dev Required for ERC-721 compliance.
736     function transfer(address _to, uint256 _identifier) external whenNotPaused {
737         // One can only transfer their own deeds.
738         require(_owns(msg.sender, _identifier));
739         
740         // Transfer ownership
741         _transfer(msg.sender, _to, _identifier);
742     }
743 }
744 
745 
746 /**
747  * @title PullPayment
748  * @dev Base contract supporting async send for pull payments. Inherit from this
749  * contract and use asyncSend instead of send.
750  */
751 contract PullPayment {
752   using SafeMath for uint256;
753 
754   mapping(address => uint256) public payments;
755   uint256 public totalPayments;
756 
757   /**
758   * @dev withdraw accumulated balance, called by payee.
759   */
760   function withdrawPayments() public {
761     address payee = msg.sender;
762     uint256 payment = payments[payee];
763 
764     require(payment != 0);
765     require(this.balance >= payment);
766 
767     totalPayments = totalPayments.sub(payment);
768     payments[payee] = 0;
769 
770     assert(payee.send(payment));
771   }
772 
773   /**
774   * @dev Called by the payer to store the sent amount as credit to be pulled.
775   * @param dest The destination address of the funds.
776   * @param amount The amount to transfer.
777   */
778   function asyncSend(address dest, uint256 amount) internal {
779     payments[dest] = payments[dest].add(amount);
780     totalPayments = totalPayments.add(amount);
781   }
782 }
783 
784 
785 /// @dev Implements access control to the BurnUp wallet.
786 contract BurnupHoldingAccessControl is Claimable, Pausable, CanReclaimToken {
787     address public cfoAddress;
788     
789     /// Boolean indicating whether an address is a BurnUp Game contract.
790     mapping (address => bool) burnupGame;
791 
792     function BurnupHoldingAccessControl() public {
793         // The creator of the contract is the initial CFO.
794         cfoAddress = msg.sender;
795     }
796     
797     /// @dev Access modifier for CFO-only functionality.
798     modifier onlyCFO() {
799         require(msg.sender == cfoAddress);
800         _;
801     }
802     
803     /// @dev Access modifier for functionality that may only be called by a BurnUp game.
804     modifier onlyBurnupGame() {
805         // The sender must be a recognized BurnUp game address.
806         require(burnupGame[msg.sender]);
807         _;
808     }
809 
810     /// @dev Assigns a new address to act as the CFO. Only available to the current contract owner.
811     /// @param _newCFO The address of the new CFO.
812     function setCFO(address _newCFO) external onlyOwner {
813         require(_newCFO != address(0));
814 
815         cfoAddress = _newCFO;
816     }
817     
818     /// @dev Add a Burnup game contract address.
819     /// @param addr The address of the Burnup game contract.
820     function addBurnupGame(address addr) external onlyOwner {
821         burnupGame[addr] = true;
822     }
823     
824     /// @dev Remove a Burnup game contract address.
825     /// @param addr The address of the Burnup game contract.
826     function removeBurnupGame(address addr) external onlyOwner {
827         delete burnupGame[addr];
828     }
829 }
830 
831 
832 /// @dev Implements the BurnUp wallet.
833 contract BurnupHoldingReferral is BurnupHoldingAccessControl {
834 
835     event SetReferrer(address indexed referral, address indexed referrer);
836 
837     /// Referrer of player.
838     mapping (address => address) addressToReferrerAddress;
839     
840     /// Get the referrer of a player.
841     /// @param player The address of the player to get the referrer of.
842     function referrerOf(address player) public view returns (address) {
843         return addressToReferrerAddress[player];
844     }
845     
846     /// Set the referrer for a player.
847     /// @param playerAddr The address of the player to set the referrer for.
848     /// @param referrerAddr The address of the referrer to set.
849     function _setReferrer(address playerAddr, address referrerAddr) internal {
850         addressToReferrerAddress[playerAddr] = referrerAddr;
851         
852         // Emit event.
853         SetReferrer(playerAddr, referrerAddr);
854     }
855 }
856 
857 
858 /// @dev Implements the BurnUp wallet.
859 contract BurnupHoldingCore is BurnupHoldingReferral, PullPayment {
860     using SafeMath for uint256;
861     
862     address public beneficiary1;
863     address public beneficiary2;
864     
865     function BurnupHoldingCore(address _beneficiary1, address _beneficiary2) public {
866         // The creator of the contract is the initial CFO.
867         cfoAddress = msg.sender;
868         
869         // Set the two beneficiaries.
870         beneficiary1 = _beneficiary1;
871         beneficiary2 = _beneficiary2;
872     }
873     
874     /// Pay the two beneficiaries. Sends both beneficiaries
875     /// a halve of the payment.
876     function payBeneficiaries() external payable {
877         uint256 paymentHalve = msg.value.div(2);
878         
879         // We do not want a single wei to get stuck.
880         uint256 otherPaymentHalve = msg.value.sub(paymentHalve);
881         
882         // Send payment for manual withdrawal.
883         asyncSend(beneficiary1, paymentHalve);
884         asyncSend(beneficiary2, otherPaymentHalve);
885     }
886     
887     /// Sets a new address for Beneficiary one.
888     /// @param addr The new address.
889     function setBeneficiary1(address addr) external onlyCFO {
890         beneficiary1 = addr;
891     }
892     
893     /// Sets a new address for Beneficiary two.
894     /// @param addr The new address.
895     function setBeneficiary2(address addr) external onlyCFO {
896         beneficiary2 = addr;
897     }
898     
899     /// Set a referrer.
900     /// @param playerAddr The address to set the referrer for.
901     /// @param referrerAddr The address of the referrer to set.
902     function setReferrer(address playerAddr, address referrerAddr) external onlyBurnupGame whenNotPaused returns(bool) {
903         if (referrerOf(playerAddr) == address(0x0) && playerAddr != referrerAddr) {
904             // Set the referrer, if no referrer has been set yet, and the player
905             // and referrer are not the same address.
906             _setReferrer(playerAddr, referrerAddr);
907             
908             // Indicate success.
909             return true;
910         }
911         
912         // Indicate failure.
913         return false;
914     }
915 }
916 
917 
918 /// @dev Holds functionality for finance related to tiles.
919 contract BurnupGameFinance is BurnupGameOwnership, PullPayment {
920     /// Address of Burnup wallet
921     BurnupHoldingCore burnupHolding;
922     
923     function BurnupGameFinance(address burnupHoldingAddress) public {
924         burnupHolding = BurnupHoldingCore(burnupHoldingAddress);
925     }
926     
927     /// @dev Find the _claimed_ tiles surrounding a tile.
928     /// @param _deedId The identifier of the tile to get the surrounding tiles for.
929     function _claimedSurroundingTiles(uint256 _deedId) internal view returns (uint256[] memory) {
930         var (x, y) = identifierToCoordinate(_deedId);
931         
932         // Find all claimed surrounding tiles.
933         uint256 claimed = 0;
934         
935         // Create memory buffer capable of holding all tiles.
936         uint256[] memory _tiles = new uint256[](8);
937         
938         // Loop through all neighbors.
939         for (int256 dx = -1; dx <= 1; dx++) {
940             for (int256 dy = -1; dy <= 1; dy++) {
941                 if (dx == 0 && dy == 0) {
942                     // Skip the center (i.e., the tile itself).
943                     continue;
944                 }
945                 
946                 uint256 nx = uint256(int256(x) + dx);
947                 uint256 ny = uint256(int256(y) + dy);
948                 
949                 if (nx >= gameSettings.cols || ny >= gameSettings.rows) {
950                     // This coordinate is outside the game bounds.
951                     continue;
952                 }
953                 
954                 // Get the coordinates of this neighboring identifier.
955                 uint256 neighborIdentifier = coordinateToIdentifier(
956                     nx,
957                     ny
958                 );
959                 
960                 if (gameStates[gameIndex].identifierToOwner[neighborIdentifier] != address(0x0)) {
961                     _tiles[claimed] = neighborIdentifier;
962                     claimed++;
963                 }
964             }
965         }
966         
967         // Memory arrays cannot be resized, so copy all
968         // tiles from the buffer to the tile array.
969         uint256[] memory tiles = new uint256[](claimed);
970         
971         for (uint256 i = 0; i < claimed; i++) {
972             tiles[i] = _tiles[i];
973         }
974         
975         return tiles;
976     }
977     
978     /// @dev Calculate the next buyout price given the current total buyout cost.
979     /// @param price The current buyout price.
980     function nextBuyoutPrice(uint256 price) public view returns (uint256) {
981         if (price < 0.02 ether) {
982             return price.mul(200).div(100); // * 2.0
983         } else {
984             return price.mul(gameSettings.buyoutPriceIncreasePercentage).div(100000);
985         }
986     }
987     
988     /// @dev Assign the proceeds of the buyout.
989     function _assignBuyoutProceeds(
990         address currentOwner,
991         uint256[] memory claimedSurroundingTiles,
992         uint256 fee,
993         uint256 currentOwnerWinnings,
994         uint256 totalDividendPerBeneficiary,
995         uint256 referralBonus,
996         uint256 prizePoolFunds
997     )
998         internal
999     {
1000     
1001         if (currentOwner != 0x0) {
1002             // Send the current owner's winnings.
1003             _sendFunds(currentOwner, currentOwnerWinnings);
1004         } else {
1005             // There is no current owner. Split the winnings to the prize pool and fees.
1006             uint256 prizePoolPart = currentOwnerWinnings.mul(gameSettings.firstBuyoutPrizePoolPercentage).div(100000);
1007             
1008             prizePoolFunds = prizePoolFunds.add(prizePoolPart);
1009             fee = fee.add(currentOwnerWinnings.sub(prizePoolPart));
1010         }
1011         
1012         // Assign dividends to owners of surrounding tiles.
1013         for (uint256 i = 0; i < claimedSurroundingTiles.length; i++) {
1014             address beneficiary = gameStates[gameIndex].identifierToOwner[claimedSurroundingTiles[i]];
1015             _sendFunds(beneficiary, totalDividendPerBeneficiary);
1016         }
1017         
1018         /// Distribute the referral bonuses (if any) for an address.
1019         address referrer1 = burnupHolding.referrerOf(msg.sender);
1020         if (referrer1 != 0x0) {
1021             _sendFunds(referrer1, referralBonus);
1022         
1023             address referrer2 = burnupHolding.referrerOf(referrer1);
1024             if (referrer2 != 0x0) {
1025                 _sendFunds(referrer2, referralBonus);
1026             } else {
1027                 // There is no second-level referrer.
1028                 fee = fee.add(referralBonus);
1029             }
1030         } else {
1031             // There are no first and second-level referrers.
1032             fee = fee.add(referralBonus.mul(2));
1033         }
1034         
1035         // Send the fee to the holding contract.
1036         burnupHolding.payBeneficiaries.value(fee)();
1037         
1038         // Increase the prize pool.
1039         gameStates[gameIndex].prizePool = gameStates[gameIndex].prizePool.add(prizePoolFunds);
1040     }
1041     
1042     /// @notice Get the price for the given tile.
1043     /// @param _deedId The identifier of the tile to get the price for.
1044     function currentPrice(uint256 _deedId) public view returns (uint256 price) {
1045         address currentOwner = gameStates[gameIndex].identifierToOwner[_deedId];
1046     
1047         if (currentOwner == 0x0) {
1048             price = gameSettings.unclaimedTilePrice;
1049         } else {
1050             price = gameStates[gameIndex].identifierToBuyoutPrice[_deedId];
1051         }
1052     }
1053     
1054     /// @dev Calculate and assign the proceeds from the buyout.
1055     /// @param currentOwner The current owner of the tile that is being bought out.
1056     /// @param price The price of the tile that is being bought out.
1057     /// @param claimedSurroundingTiles The surrounding tiles that have been claimed.
1058     function _calculateAndAssignBuyoutProceeds(address currentOwner, uint256 price, uint256[] memory claimedSurroundingTiles)
1059         internal
1060     {
1061         // Calculate the variable dividends based on the buyout price
1062         // (only to be paid if there are surrounding tiles).
1063         uint256 variableDividends = price.mul(gameSettings.buyoutDividendPercentage).div(100000);
1064         
1065         // Calculate fees, referral bonus, and prize pool funds.
1066         uint256 fee            = price.mul(gameSettings.buyoutFeePercentage).div(100000);
1067         uint256 referralBonus  = price.mul(gameSettings.buyoutReferralBonusPercentage).div(100000);
1068         uint256 prizePoolFunds = price.mul(gameSettings.buyoutPrizePoolPercentage).div(100000);
1069         
1070         // Calculate and assign buyout proceeds.
1071         uint256 currentOwnerWinnings = price.sub(fee).sub(referralBonus.mul(2)).sub(prizePoolFunds);
1072         
1073         uint256 totalDividendPerBeneficiary;
1074         if (claimedSurroundingTiles.length > 0) {
1075             // If there are surrounding tiles, variable dividend is to be paid
1076             // based on the buyout price.
1077             // Calculate the dividend per surrounding tile.
1078             totalDividendPerBeneficiary = variableDividends / claimedSurroundingTiles.length;
1079             
1080             // currentOwnerWinnings = currentOwnerWinnings.sub(variableDividends);
1081             currentOwnerWinnings = currentOwnerWinnings.sub(totalDividendPerBeneficiary * claimedSurroundingTiles.length);
1082         }
1083         
1084         _assignBuyoutProceeds(
1085             currentOwner,
1086             claimedSurroundingTiles,
1087             fee,
1088             currentOwnerWinnings,
1089             totalDividendPerBeneficiary,
1090             referralBonus,
1091             prizePoolFunds
1092         );
1093     }
1094     
1095     /// @dev Send funds to a beneficiary. If sending fails, assign
1096     /// funds to the beneficiary's balance for manual withdrawal.
1097     /// @param beneficiary The beneficiary's address to send funds to
1098     /// @param amount The amount to send.
1099     function _sendFunds(address beneficiary, uint256 amount) internal {
1100         if (!beneficiary.send(amount)) {
1101             // Failed to send funds. This can happen due to a failure in
1102             // fallback code of the beneficiary, or because of callstack
1103             // depth.
1104             // Send funds asynchronously for manual withdrawal by the
1105             // beneficiary.
1106             asyncSend(beneficiary, amount);
1107         }
1108     }
1109 }
1110 
1111 /// @dev Holds core game functionality.
1112 contract BurnupGameCore is BurnupGameFinance {
1113     
1114     function BurnupGameCore(address burnupHoldingAddress) public BurnupGameFinance(burnupHoldingAddress) {}
1115     
1116     /// @notice Buy the current owner out of the tile.
1117     /// @param _gameIndex The index of the game to play on.
1118     /// @param startNewGameIfIdle Start a new game if the current game is idle.
1119     /// @param x The x-coordinate of the tile to buy.
1120     /// @param y The y-coordinate of the tile to buy.
1121     function buyout(uint256 _gameIndex, bool startNewGameIfIdle, uint256 x, uint256 y) public payable {
1122         // Check to see if the game should end. Process payment.
1123         _processGameEnd();
1124         
1125         if (!gameStates[gameIndex].gameStarted) {
1126             // If the game is not started, the contract must not be paused.
1127             require(!paused);
1128             
1129             if (allowStart) {
1130                 // We're allowed to start once outside of active times.
1131                 allowStart = false;
1132             } else {
1133                 // This must be an active time.
1134                 require(canStart());
1135             }
1136             
1137             // If the game is not started, the player must be willing to start
1138             // a new game.
1139             require(startNewGameIfIdle);
1140             
1141             _setGameSettings();
1142             
1143             // Start the game.
1144             gameStates[gameIndex].gameStarted = true;
1145             
1146             // Set game started timestamp.
1147             gameStates[gameIndex].gameStartTimestamp = block.timestamp;
1148             
1149             // Set the initial game board timeout.
1150             gameStates[gameIndex].penultimateTileTimeout = block.timestamp + gameSettings.initialActivityTimer;
1151             
1152             Start(
1153                 gameIndex,
1154                 msg.sender,
1155                 block.timestamp,
1156                 gameStates[gameIndex].prizePool
1157             );
1158             
1159             PenultimateTileTimeout(gameIndex, gameStates[gameIndex].penultimateTileTimeout);
1160         }
1161     
1162         // Check the game index.
1163         if (startNewGameIfIdle) {
1164             // The given game index must be the current game index, or the previous
1165             // game index.
1166             require(_gameIndex == gameIndex || _gameIndex.add(1) == gameIndex);
1167         } else {
1168             // Only play on the game indicated by the player.
1169             require(_gameIndex == gameIndex);
1170         }
1171         
1172         uint256 identifier = coordinateToIdentifier(x, y);
1173         
1174         address currentOwner = gameStates[gameIndex].identifierToOwner[identifier];
1175         
1176         // Tile must be unowned, or active.
1177         if (currentOwner == address(0x0)) {
1178             // Tile must still be flippable.
1179             require(gameStates[gameIndex].gameStartTimestamp.add(gameSettings.initialActivityTimer) >= block.timestamp);
1180         } else {
1181             // Tile must be active.
1182             require(gameStates[gameIndex].identifierToTimeoutTimestamp[identifier] >= block.timestamp);
1183         }
1184         
1185         // Enough Ether must be supplied.
1186         uint256 price = currentPrice(identifier);
1187         require(msg.value >= price);
1188         
1189         // Get existing surrounding tiles.
1190         uint256[] memory claimedSurroundingTiles = _claimedSurroundingTiles(identifier);
1191         
1192         // Assign the buyout proceeds and retrieve the total cost.
1193         _calculateAndAssignBuyoutProceeds(currentOwner, price, claimedSurroundingTiles);
1194         
1195         // Set the timeout timestamp.
1196         uint256 timeout = tileTimeoutTimestamp(identifier, msg.sender);
1197         gameStates[gameIndex].identifierToTimeoutTimestamp[identifier] = timeout;
1198         
1199         // Keep track of the last and penultimate tiles.
1200         if (gameStates[gameIndex].lastTile == 0 || timeout >= gameStates[gameIndex].identifierToTimeoutTimestamp[gameStates[gameIndex].lastTile]) {
1201             if (gameStates[gameIndex].lastTile != identifier) {
1202                 if (gameStates[gameIndex].lastTile != 0) {
1203                     // Previous last tile to become inactive is now the penultimate tile.
1204                     gameStates[gameIndex].penultimateTileTimeout = gameStates[gameIndex].identifierToTimeoutTimestamp[gameStates[gameIndex].lastTile];
1205                     PenultimateTileTimeout(gameIndex, gameStates[gameIndex].penultimateTileTimeout);
1206                 }
1207             
1208                 gameStates[gameIndex].lastTile = identifier;
1209                 LastTile(gameIndex, identifier, x, y);
1210             }
1211         } else if (timeout > gameStates[gameIndex].penultimateTileTimeout) {
1212             gameStates[gameIndex].penultimateTileTimeout = timeout;
1213             
1214             PenultimateTileTimeout(gameIndex, timeout);
1215         }
1216         
1217         // Transfer the tile.
1218         _transfer(currentOwner, msg.sender, identifier);
1219         
1220         // Calculate and set the new tile price.
1221         gameStates[gameIndex].identifierToBuyoutPrice[identifier] = nextBuyoutPrice(price);
1222         
1223         // Increment the number of tile flips.
1224         gameStates[gameIndex].numberOfTileFlips++;
1225         
1226         // Emit event
1227         Buyout(gameIndex, msg.sender, identifier, x, y, block.timestamp, timeout, gameStates[gameIndex].identifierToBuyoutPrice[identifier], gameStates[gameIndex].prizePool);
1228         
1229         // Calculate the excess Ether sent.
1230         // msg.value is greater than or equal to price,
1231         // so this cannot underflow.
1232         uint256 excess = msg.value - price;
1233         
1234         if (excess > 0) {
1235             // Refund any excess Ether (not susceptible to re-entry attack, as
1236             // the owner is assigned before the transfer takes place).
1237             msg.sender.transfer(excess);
1238         }
1239     }
1240     
1241     /// @notice Buy the current owner out of the tile. Set the player's referrer.
1242     /// @param _gameIndex The index of the game to play on.
1243     /// @param startNewGameIfIdle Start a new game if the current game is idle.
1244     /// @param x The x-coordinate of the tile to buy.
1245     /// @param y The y-coordinate of the tile to buy.
1246     function buyoutAndSetReferrer(uint256 _gameIndex, bool startNewGameIfIdle, uint256 x, uint256 y, address referrerAddress) external payable {
1247         // Set the referrer.
1248         burnupHolding.setReferrer(msg.sender, referrerAddress);
1249     
1250         // Play.
1251         buyout(_gameIndex, startNewGameIfIdle, x, y);
1252     }
1253     
1254     /// @notice Spice up the prize pool.
1255     /// @param _gameIndex The index of the game to add spice to.
1256     /// @param message An optional message to be sent along with the spice.
1257     function spiceUp(uint256 _gameIndex, string message) external payable {
1258         // Check to see if the game should end. Process payment.
1259         _processGameEnd();
1260         
1261         // Check the game index.
1262         require(_gameIndex == gameIndex);
1263     
1264         // Game must be live or unpaused.
1265         require(gameStates[gameIndex].gameStarted || !paused);
1266         
1267         // Funds must be sent.
1268         require(msg.value > 0);
1269         
1270         // Add funds to the prize pool.
1271         gameStates[gameIndex].prizePool = gameStates[gameIndex].prizePool.add(msg.value);
1272         
1273         // Emit event.
1274         SpiceUpPrizePool(gameIndex, msg.sender, msg.value, message, gameStates[gameIndex].prizePool);
1275     }
1276     
1277     /// @notice End the game. Pay prize.
1278     function endGame() external {
1279         require(_processGameEnd());
1280     }
1281     
1282     /// @dev End the game. Pay prize.
1283     function _processGameEnd() internal returns(bool) {
1284         // The game must be started.
1285         if (!gameStates[gameIndex].gameStarted) {
1286             return false;
1287         }
1288         
1289         address currentOwner = gameStates[gameIndex].identifierToOwner[gameStates[gameIndex].lastTile];
1290     
1291         // The last flipped tile must be owned (i.e. there has been at
1292         // least one flip).
1293         if (currentOwner == address(0x0)) {
1294             return false;
1295         }
1296         
1297         // The penultimate tile must have become inactive.
1298         if (gameStates[gameIndex].penultimateTileTimeout >= block.timestamp) {
1299             return false;
1300         }
1301         
1302         // Assign prize pool to the owner of the last-flipped tile.
1303         if (gameStates[gameIndex].prizePool > 0) {
1304             _sendFunds(currentOwner, gameStates[gameIndex].prizePool);
1305         }
1306         
1307         // Get coordinates of last flipped tile.
1308         var (x, y) = identifierToCoordinate(gameStates[gameIndex].lastTile);
1309         
1310         // Emit event.
1311         End(gameIndex, currentOwner, gameStates[gameIndex].lastTile, x, y, gameStates[gameIndex].identifierToTimeoutTimestamp[gameStates[gameIndex].lastTile], gameStates[gameIndex].prizePool);
1312         
1313         // Increment the game index. This won't overflow before the heat death of the universe.
1314         gameIndex++;
1315         
1316         // Indicate ending the game was successful.
1317         return true;
1318     }
1319 }