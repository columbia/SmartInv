1 pragma solidity ^0.4.18;
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
241     address public cfoAddress;
242     address public cooAddress;
243     
244     function BurnupGameAccessControl() public {
245         // The creator of the contract is the initial CFO.
246         cfoAddress = msg.sender;
247     
248         // The creator of the contract is the initial COO.
249         cooAddress = msg.sender;
250     }
251     
252     /// @dev Access modifier for CFO-only functionality.
253     modifier onlyCFO() {
254         require(msg.sender == cfoAddress);
255         _;
256     }
257     
258     /// @dev Access modifier for COO-only functionality.
259     modifier onlyCOO() {
260         require(msg.sender == cooAddress);
261         _;
262     }
263 
264     /// @dev Assigns a new address to act as the CFO. Only available to the current contract owner.
265     /// @param _newCFO The address of the new CFO.
266     function setCFO(address _newCFO) external onlyOwner {
267         require(_newCFO != address(0));
268 
269         cfoAddress = _newCFO;
270     }
271     
272     /// @dev Assigns a new address to act as the COO. Only available to the current contract owner.
273     /// @param _newCOO The address of the new COO.
274     function setCOO(address _newCOO) external onlyOwner {
275         require(_newCOO != address(0));
276 
277         cooAddress = _newCOO;
278     }
279 }
280 
281 
282 /// @dev Defines base data structures for DWorld.
283 contract BurnupGameBase is BurnupGameAccessControl {
284     using SafeMath for uint256;
285     
286     event NextGame(uint256 rows, uint256 cols, uint256 activityTimer, uint256 unclaimedTilePrice, uint256 buyoutReferralBonusPercentage, uint256 buyoutPrizePoolPercentage, uint256 buyoutDividendPercentage, uint256 buyoutFeePercentage);
287     event Start(uint256 indexed gameIndex, address indexed starter, uint256 timestamp, uint256 prizePool, uint256 rows, uint256 cols, uint256 activityTimer, uint256 unclaimedTilePrice, uint256 buyoutReferralBonusPercentage, uint256 buyoutPrizePoolPercentage, uint256 buyoutDividendPercentage, uint256 buyoutFeePercentage);
288     event End(uint256 indexed gameIndex, address indexed winner, uint256 indexed identifier, uint256 x, uint256 y, uint256 timestamp, uint256 prize);
289     event Buyout(uint256 indexed gameIndex, address indexed player, uint256 indexed identifier, uint256 x, uint256 y, uint256 timestamp, uint256 timeoutTimestamp, uint256 newPrice, uint256 newPrizePool);
290     event SpiceUpPrizePool(uint256 indexed gameIndex, address indexed spicer, uint256 spiceAdded, string message, uint256 newPrizePool);
291     
292     /// @dev Struct to hold game settings.
293     struct GameSettings {
294         uint256 rows; // 5
295         uint256 cols; // 8
296         
297         /// @dev Time after last trade after which tiles become inactive.
298         uint256 activityTimer; // 3600
299         
300         /// @dev Base price for unclaimed tiles.
301         uint256 unclaimedTilePrice; // 0.01 ether
302         
303         /// @dev Percentage of the buyout price that goes towards the referral
304         /// bonus. In 1/1000th of a percentage.
305         uint256 buyoutReferralBonusPercentage; // 750
306         
307         /// @dev Percentage of the buyout price that goes towards the prize
308         /// pool. In 1/1000th of a percentage.
309         uint256 buyoutPrizePoolPercentage; // 10000
310     
311         /// @dev Percentage of the buyout price that goes towards dividends
312         /// surrounding the tile that is bought out. In in 1/1000th of
313         /// a percentage.
314         uint256 buyoutDividendPercentage; // 5000
315     
316         /// @dev Buyout fee in 1/1000th of a percentage.
317         uint256 buyoutFeePercentage; // 2500
318     }
319     
320     /// @dev Struct to hold game state.
321     struct GameState {
322         /// @dev Boolean indicating whether the game is live.
323         bool gameStarted;
324     
325         /// @dev Time at which the game started.
326         uint256 gameStartTimestamp;
327     
328         /// @dev Keep track of tile ownership.
329         mapping (uint256 => address) identifierToOwner;
330         
331         /// @dev Keep track of the timestamp at which a tile was flipped last.
332         mapping (uint256 => uint256) identifierToBuyoutTimestamp;
333         
334         /// @dev Current tile price.
335         mapping (uint256 => uint256) identifierToBuyoutPrice;
336         
337         /// @dev Keep track of the tile that was flipped last.
338         uint256 lastFlippedTile;
339         
340         /// @dev The prize pool.
341         uint256 prizePool;
342     }
343     
344     /// @notice Mapping from game indices to game settings.
345     mapping (uint256 => GameSettings) public gameSettings;
346     
347     /// @notice Mapping from game indices to game states.
348     mapping (uint256 => GameState) public gameStates;
349     
350     /// @notice The index of the current game.
351     uint256 public gameIndex = 0;
352     
353     /// @dev Settings for the next game
354     GameSettings public nextGameSettings;
355     
356     function BurnupGameBase() public {
357         // Initial settings.
358         setNextGameSettings(
359             4, // rows
360             5, // cols
361             3600, // activityTimer
362             0.01 ether, // unclaimedTilePrice
363             750, // buyoutReferralBonusPercentage
364             10000, // buyoutPrizePoolPercentage
365             5000, // buyoutDividendPercentage
366             2500 // buyoutFeePercentage
367         );
368     }
369     
370     /// @dev Test whether the coordinate is valid.
371     /// @param x The x-part of the coordinate to test.
372     /// @param y The y-part of the coordinate to test.
373     function validCoordinate(uint256 x, uint256 y) public view returns(bool) {
374         return x < gameSettings[gameIndex].cols && y < gameSettings[gameIndex].rows;
375     }
376     
377     /// @dev Represent a 2D coordinate as a single uint.
378     /// @param x The x-coordinate.
379     /// @param y The y-coordinate.
380     function coordinateToIdentifier(uint256 x, uint256 y) public view returns(uint256) {
381         require(validCoordinate(x, y));
382         
383         return (y * gameSettings[gameIndex].cols) + x;
384     }
385     
386     /// @dev Turn a single uint representation of a coordinate into its x and y parts.
387     /// @param identifier The uint representation of a coordinate.
388     /// Assumes the identifier is valid.
389     function identifierToCoordinate(uint256 identifier) public view returns(uint256 x, uint256 y) {
390         y = identifier / gameSettings[gameIndex].cols;
391         x = identifier - (y * gameSettings[gameIndex].cols);
392     }
393     
394     /// @notice Sets the settings for the next game.
395     function setNextGameSettings(
396         uint256 rows,
397         uint256 cols,
398         uint256 activityTimer,
399         uint256 unclaimedTilePrice,
400         uint256 buyoutReferralBonusPercentage,
401         uint256 buyoutPrizePoolPercentage,
402         uint256 buyoutDividendPercentage,
403         uint256 buyoutFeePercentage
404     )
405         public
406         onlyCFO
407     {
408         // Buyout dividend must be 2% at the least.
409         // Buyout dividend percentage may be 12.5% at the most.
410         require(2000 <= buyoutDividendPercentage && buyoutDividendPercentage <= 12500);
411         
412         // Buyout fee may be 5% at the most.
413         require(buyoutFeePercentage <= 5000);
414         
415         nextGameSettings = GameSettings({
416             rows: rows,
417             cols: cols,
418             activityTimer: activityTimer,
419             unclaimedTilePrice: unclaimedTilePrice,
420             buyoutReferralBonusPercentage: buyoutReferralBonusPercentage,
421             buyoutPrizePoolPercentage: buyoutPrizePoolPercentage,
422             buyoutDividendPercentage: buyoutDividendPercentage,
423             buyoutFeePercentage: buyoutFeePercentage
424         });
425         
426         NextGame(rows, cols, activityTimer, unclaimedTilePrice, buyoutReferralBonusPercentage, buyoutPrizePoolPercentage, buyoutDividendPercentage, buyoutFeePercentage);
427     }
428 }
429 
430 
431 /// @dev Holds ownership functionality such as transferring.
432 contract BurnupGameOwnership is BurnupGameBase {
433     
434     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
435     
436     /// @notice Name of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
437     function name() public pure returns (string _deedName) {
438         _deedName = "Burnup Tiles";
439     }
440     
441     /// @notice Symbol of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
442     function symbol() public pure returns (string _deedSymbol) {
443         _deedSymbol = "BURN";
444     }
445     
446     /// @dev Checks if a given address owns a particular tile.
447     /// @param _owner The address of the owner to check for.
448     /// @param _identifier The tile identifier to check for.
449     function _owns(address _owner, uint256 _identifier) internal view returns (bool) {
450         return gameStates[gameIndex].identifierToOwner[_identifier] == _owner;
451     }
452     
453     /// @dev Assigns ownership of a specific deed to an address.
454     /// @param _from The address to transfer the deed from.
455     /// @param _to The address to transfer the deed to.
456     /// @param _identifier The identifier of the deed to transfer.
457     function _transfer(address _from, address _to, uint256 _identifier) internal {
458         // Transfer ownership.
459         gameStates[gameIndex].identifierToOwner[_identifier] = _to;
460         
461         // Emit the transfer event.
462         Transfer(_from, _to, _identifier);
463     }
464     
465     /// @notice Returns the address currently assigned ownership of a given deed.
466     /// @dev Required for ERC-721 compliance.
467     function ownerOf(uint256 _identifier) external view returns (address _owner) {
468         _owner = gameStates[gameIndex].identifierToOwner[_identifier];
469 
470         require(_owner != address(0));
471     }
472     
473     /// @notice Transfer a deed to another address. If transferring to a smart
474     /// contract be VERY CAREFUL to ensure that it is aware of ERC-721, or your
475     /// deed may be lost forever.
476     /// @param _to The address of the recipient, can be a user or contract.
477     /// @param _identifier The identifier of the deed to transfer.
478     /// @dev Required for ERC-721 compliance.
479     function transfer(address _to, uint256 _identifier) external whenNotPaused {
480         // One can only transfer their own deeds.
481         require(_owns(msg.sender, _identifier));
482         
483         // Transfer ownership
484         _transfer(msg.sender, _to, _identifier);
485     }
486 }
487 
488 
489 /**
490  * @title PullPayment
491  * @dev Base contract supporting async send for pull payments. Inherit from this
492  * contract and use asyncSend instead of send.
493  */
494 contract PullPayment {
495   using SafeMath for uint256;
496 
497   mapping(address => uint256) public payments;
498   uint256 public totalPayments;
499 
500   /**
501   * @dev withdraw accumulated balance, called by payee.
502   */
503   function withdrawPayments() public {
504     address payee = msg.sender;
505     uint256 payment = payments[payee];
506 
507     require(payment != 0);
508     require(this.balance >= payment);
509 
510     totalPayments = totalPayments.sub(payment);
511     payments[payee] = 0;
512 
513     assert(payee.send(payment));
514   }
515 
516   /**
517   * @dev Called by the payer to store the sent amount as credit to be pulled.
518   * @param dest The destination address of the funds.
519   * @param amount The amount to transfer.
520   */
521   function asyncSend(address dest, uint256 amount) internal {
522     payments[dest] = payments[dest].add(amount);
523     totalPayments = totalPayments.add(amount);
524   }
525 }
526 
527 
528 /// @dev Implements access control to the BurnUp wallet.
529 contract BurnupHoldingAccessControl is Claimable, Pausable, CanReclaimToken {
530     address public cfoAddress;
531     
532     /// Boolean indicating whether an address is a BurnUp Game contract.
533     mapping (address => bool) burnupGame;
534 
535     function BurnupHoldingAccessControl() public {
536         // The creator of the contract is the initial CFO.
537         cfoAddress = msg.sender;
538     }
539     
540     /// @dev Access modifier for CFO-only functionality.
541     modifier onlyCFO() {
542         require(msg.sender == cfoAddress);
543         _;
544     }
545     
546     /// @dev Access modifier for functionality that may only be called by a BurnUp game.
547     modifier onlyBurnupGame() {
548         // The sender must be a recognized BurnUp game address.
549         require(burnupGame[msg.sender]);
550         _;
551     }
552 
553     /// @dev Assigns a new address to act as the CFO. Only available to the current contract owner.
554     /// @param _newCFO The address of the new CFO.
555     function setCFO(address _newCFO) external onlyOwner {
556         require(_newCFO != address(0));
557 
558         cfoAddress = _newCFO;
559     }
560     
561     /// @dev Add a Burnup game contract address.
562     /// @param addr The address of the Burnup game contract.
563     function addBurnupGame(address addr) external onlyOwner {
564         burnupGame[addr] = true;
565     }
566     
567     /// @dev Remove a Burnup game contract address.
568     /// @param addr The address of the Burnup game contract.
569     function removeBurnupGame(address addr) external onlyOwner {
570         delete burnupGame[addr];
571     }
572 }
573 
574 
575 /// @dev Implements the BurnUp wallet.
576 contract BurnupHoldingReferral is BurnupHoldingAccessControl {
577 
578     event SetReferrer(address indexed referral, address indexed referrer);
579 
580     /// Referrer of player.
581     mapping (address => address) addressToReferrerAddress;
582     
583     /// Get the referrer of a player.
584     /// @param player The address of the player to get the referrer of.
585     function referrerOf(address player) public view returns (address) {
586         return addressToReferrerAddress[player];
587     }
588     
589     /// Set the referrer for a player.
590     /// @param playerAddr The address of the player to set the referrer for.
591     /// @param referrerAddr The address of the referrer to set.
592     function _setReferrer(address playerAddr, address referrerAddr) internal {
593         addressToReferrerAddress[playerAddr] = referrerAddr;
594         
595         // Emit event.
596         SetReferrer(playerAddr, referrerAddr);
597     }
598 }
599 
600 
601 /// @dev Implements the BurnUp wallet.
602 contract BurnupHoldingCore is BurnupHoldingReferral, PullPayment {
603     using SafeMath for uint256;
604     
605     address public beneficiary1;
606     address public beneficiary2;
607     
608     function BurnupHoldingCore(address _beneficiary1, address _beneficiary2) public {
609         // The creator of the contract is the initial CFO.
610         cfoAddress = msg.sender;
611         
612         // Set the two beneficiaries.
613         beneficiary1 = _beneficiary1;
614         beneficiary2 = _beneficiary2;
615     }
616     
617     /// Pay the two beneficiaries. Sends both beneficiaries
618     /// a halve of the payment.
619     function payBeneficiaries() external payable {
620         uint256 paymentHalve = msg.value.div(2);
621         
622         // We do not want a single wei to get stuck.
623         uint256 otherPaymentHalve = msg.value.sub(paymentHalve);
624         
625         // Send payment for manual withdrawal.
626         asyncSend(beneficiary1, paymentHalve);
627         asyncSend(beneficiary2, otherPaymentHalve);
628     }
629     
630     /// Sets a new address for Beneficiary one.
631     /// @param addr The new address.
632     function setBeneficiary1(address addr) external onlyCFO {
633         beneficiary1 = addr;
634     }
635     
636     /// Sets a new address for Beneficiary two.
637     /// @param addr The new address.
638     function setBeneficiary2(address addr) external onlyCFO {
639         beneficiary2 = addr;
640     }
641     
642     /// Set a referrer.
643     /// @param playerAddr The address to set the referrer for.
644     /// @param referrerAddr The address of the referrer to set.
645     function setReferrer(address playerAddr, address referrerAddr) external onlyBurnupGame whenNotPaused returns(bool) {
646         if (referrerOf(playerAddr) == address(0x0) && playerAddr != referrerAddr) {
647             // Set the referrer, if no referrer has been set yet, and the player
648             // and referrer are not the same address.
649             _setReferrer(playerAddr, referrerAddr);
650             
651             // Indicate success.
652             return true;
653         }
654         
655         // Indicate failure.
656         return false;
657     }
658 }
659 
660 
661 /// @dev Holds functionality for finance related to tiles.
662 contract BurnupGameFinance is BurnupGameOwnership, PullPayment {
663     /// Address of Burnup wallet
664     BurnupHoldingCore burnupHolding;
665     
666     function BurnupGameFinance(address burnupHoldingAddress) public {
667         burnupHolding = BurnupHoldingCore(burnupHoldingAddress);
668     }
669     
670     /// @dev Find the _claimed_ tiles surrounding a tile.
671     /// @param _deedId The identifier of the tile to get the surrounding tiles for.
672     function _claimedSurroundingTiles(uint256 _deedId) internal view returns (uint256[] memory) {
673         var (x, y) = identifierToCoordinate(_deedId);
674         
675         // Find all claimed surrounding tiles.
676         uint256 claimed = 0;
677         
678         // Create memory buffer capable of holding all tiles.
679         uint256[] memory _tiles = new uint256[](8);
680         
681         // Loop through all neighbors.
682         for (int256 dx = -1; dx <= 1; dx++) {
683             for (int256 dy = -1; dy <= 1; dy++) {
684                 if (dx == 0 && dy == 0) {
685                     // Skip the center (i.e., the tile itself).
686                     continue;
687                 }
688                 
689                 uint256 nx = uint256(int256(x) + dx);
690                 uint256 ny = uint256(int256(y) + dy);
691                 
692                 if (nx >= gameSettings[gameIndex].cols || ny >= gameSettings[gameIndex].rows) {
693                     // This coordinate is outside the game bounds.
694                     continue;
695                 }
696                 
697                 // Get the coordinates of this neighboring identifier.
698                 uint256 neighborIdentifier = coordinateToIdentifier(
699                     nx,
700                     ny
701                 );
702                 
703                 if (gameStates[gameIndex].identifierToOwner[neighborIdentifier] != address(0x0)) {
704                     _tiles[claimed] = neighborIdentifier;
705                     claimed++;
706                 }
707             }
708         }
709         
710         // Memory arrays cannot be resized, so copy all
711         // tiles from the buffer to the tile array.
712         uint256[] memory tiles = new uint256[](claimed);
713         
714         for (uint256 i = 0; i < claimed; i++) {
715             tiles[i] = _tiles[i];
716         }
717         
718         return tiles;
719     }
720     
721     /// @dev Calculate the next buyout price given the current total buyout cost.
722     /// @param price The current buyout price.
723     function nextBuyoutPrice(uint256 price) public pure returns (uint256) {
724         if (price < 0.02 ether) {
725             return price.mul(200).div(100); // * 2.0
726         } else {
727             return price.mul(150).div(100); // * 1.5
728         }
729     }
730     
731     /// @dev Assign the proceeds of the buyout.
732     function _assignBuyoutProceeds(
733         address currentOwner,
734         uint256[] memory claimedSurroundingTiles,
735         uint256 fee,
736         uint256 currentOwnerWinnings,
737         uint256 totalDividendPerBeneficiary,
738         uint256 referralBonus,
739         uint256 prizePoolFunds
740     )
741         internal
742     {
743     
744         if (currentOwner != 0x0) {
745             // Send the current owner's winnings.
746             _sendFunds(currentOwner, currentOwnerWinnings);
747         } else {
748             // There is no current owner.
749             fee = fee.add(currentOwnerWinnings);
750         }
751         
752         // Assign dividends to owners of surrounding tiles.
753         for (uint256 i = 0; i < claimedSurroundingTiles.length; i++) {
754             address beneficiary = gameStates[gameIndex].identifierToOwner[claimedSurroundingTiles[i]];
755             _sendFunds(beneficiary, totalDividendPerBeneficiary);
756         }
757         
758         /// Distribute the referral bonuses (if any) for an address.
759         address referrer1 = burnupHolding.referrerOf(msg.sender);
760         if (referrer1 != 0x0) {
761             _sendFunds(referrer1, referralBonus);
762         
763             address referrer2 = burnupHolding.referrerOf(referrer1);
764             if (referrer2 != 0x0) {
765                 _sendFunds(referrer2, referralBonus);
766             } else {
767                 // There is no second-level referrer.
768                 fee = fee.add(referralBonus);
769             }
770         } else {
771             // There are no first and second-level referrers.
772             fee = fee.add(referralBonus.mul(2));
773         }
774         
775         // Send the fee to the holding contract.
776         burnupHolding.payBeneficiaries.value(fee)();
777         
778         // Increase the prize pool.
779         gameStates[gameIndex].prizePool = gameStates[gameIndex].prizePool.add(prizePoolFunds);
780     }
781     
782     /// @dev Calculate and assign the proceeds from the buyout.
783     /// @param currentOwner The current owner of the tile that is being bought out.
784     /// @param _deedId The identifier of the tile that is being bought out.
785     /// @param claimedSurroundingTiles The surrounding tiles that have been claimed.
786     function _calculateAndAssignBuyoutProceeds(address currentOwner, uint256 _deedId, uint256[] memory claimedSurroundingTiles)
787         internal 
788         returns (uint256 price)
789     {
790         // The current price.
791         
792         if (currentOwner == 0x0) {
793             price = gameSettings[gameIndex].unclaimedTilePrice;
794         } else {
795             price = gameStates[gameIndex].identifierToBuyoutPrice[_deedId];
796         }
797         
798         // Calculate the variable dividends based on the buyout price
799         // (only to be paid if there are surrounding tiles).
800         uint256 variableDividends = price.mul(gameSettings[gameIndex].buyoutDividendPercentage).div(100000);
801         
802         // Calculate fees, referral bonus, and prize pool funds.
803         uint256 fee            = price.mul(gameSettings[gameIndex].buyoutFeePercentage).div(100000);
804         uint256 referralBonus  = price.mul(gameSettings[gameIndex].buyoutReferralBonusPercentage).div(100000);
805         uint256 prizePoolFunds = price.mul(gameSettings[gameIndex].buyoutPrizePoolPercentage).div(100000);
806         
807         // Calculate and assign buyout proceeds.
808         uint256 currentOwnerWinnings = price.sub(fee).sub(referralBonus.mul(2)).sub(prizePoolFunds);
809         
810         uint256 totalDividendPerBeneficiary;
811         if (claimedSurroundingTiles.length > 0) {
812             // If there are surrounding tiles, variable dividend is to be paid
813             // based on the buyout price.
814             // Calculate the dividend per surrounding tile.
815             totalDividendPerBeneficiary = variableDividends / claimedSurroundingTiles.length;
816             
817             currentOwnerWinnings = currentOwnerWinnings.sub(variableDividends);
818             // currentOwnerWinnings = currentOwnerWinnings.sub(totalDividendPerBeneficiary * claimedSurroundingTiles.length);
819         }
820         
821         _assignBuyoutProceeds(
822             currentOwner,
823             claimedSurroundingTiles,
824             fee,
825             currentOwnerWinnings,
826             totalDividendPerBeneficiary,
827             referralBonus,
828             prizePoolFunds
829         );
830     }
831     
832     /// @dev Send funds to a beneficiary. If sending fails, assign
833     /// funds to the beneficiary's balance for manual withdrawal.
834     /// @param beneficiary The beneficiary's address to send funds to
835     /// @param amount The amount to send.
836     function _sendFunds(address beneficiary, uint256 amount) internal {
837         if (!beneficiary.send(amount)) {
838             // Failed to send funds. This can happen due to a failure in
839             // fallback code of the beneficiary, or because of callstack
840             // depth.
841             // Send funds asynchronously for manual withdrawal by the
842             // beneficiary.
843             asyncSend(beneficiary, amount);
844         }
845     }
846 }
847 
848 
849 /// @dev Holds core game functionality.
850 contract BurnupGameCore is BurnupGameFinance {
851     
852     function BurnupGameCore(address burnupHoldingAddress) public BurnupGameFinance(burnupHoldingAddress) {}
853     
854     /// @notice Buy the current owner out of the tile.
855     /// @param _gameIndex The index of the game to play on.
856     /// @param startNewGameIfIdle Start a new game if the current game is idle.
857     /// @param x The x-coordinate of the tile to buy.
858     /// @param y The y-coordinate of the tile to buy.
859     function buyout(uint256 _gameIndex, bool startNewGameIfIdle, uint256 x, uint256 y) public payable {
860         // Check to see if the game should end. Process payment.
861         _processGameEnd();
862         
863         if (!gameStates[gameIndex].gameStarted) {
864             // If the game is not started, the contract must not be paused.
865             require(!paused);
866             
867             // If the game is not started, the player must be willing to start
868             // a new game.
869             require(startNewGameIfIdle);
870             
871             // Set the price and timeout.
872             gameSettings[gameIndex] = nextGameSettings;
873             
874             // Start the game.
875             gameStates[gameIndex].gameStarted = true;
876             
877             // Set game started timestamp.
878             gameStates[gameIndex].gameStartTimestamp = block.timestamp;
879             
880             // Emit start event.
881             Start(gameIndex, msg.sender, block.timestamp, gameStates[gameIndex].prizePool, gameSettings[gameIndex].rows, gameSettings[gameIndex].cols, gameSettings[gameIndex].activityTimer, gameSettings[gameIndex].unclaimedTilePrice, gameSettings[gameIndex].buyoutReferralBonusPercentage, gameSettings[gameIndex].buyoutPrizePoolPercentage, gameSettings[gameIndex].buyoutDividendPercentage, gameSettings[gameIndex].buyoutFeePercentage);
882         }
883     
884         // Check the game index.
885         if (startNewGameIfIdle) {
886             // The given game index must be the current game index, or the previous
887             // game index.
888             require(_gameIndex == gameIndex || _gameIndex.add(1) == gameIndex);
889         } else {
890             // Only play on the game indicated by the player.
891             require(_gameIndex == gameIndex);
892         }
893         
894         uint256 identifier = coordinateToIdentifier(x, y);
895         
896         address currentOwner = gameStates[gameIndex].identifierToOwner[identifier];
897         
898         // Tile must be unowned, or active.
899         if (currentOwner == address(0x0)) {
900             // Tile must still be flippable.
901             require(gameStates[gameIndex].gameStartTimestamp.add(gameSettings[gameIndex].activityTimer) >= block.timestamp);
902         } else {
903             // Tile must be active.
904             require(gameStates[gameIndex].identifierToBuyoutTimestamp[identifier].add(gameSettings[gameIndex].activityTimer) >= block.timestamp);
905         }
906         
907         // Get existing surrounding tiles.
908         uint256[] memory claimedSurroundingTiles = _claimedSurroundingTiles(identifier);
909         
910         // Assign the buyout proceeds and retrieve the total cost.
911         uint256 price = _calculateAndAssignBuyoutProceeds(currentOwner, identifier, claimedSurroundingTiles);
912         
913         // Enough Ether must be supplied.
914         require(msg.value >= price);
915         
916         // Transfer the tile.
917         _transfer(currentOwner, msg.sender, identifier);
918         
919         // Set this tile to be the most recently bought out.
920         gameStates[gameIndex].lastFlippedTile = identifier;
921         
922         // Calculate and set the new tile price.
923         gameStates[gameIndex].identifierToBuyoutPrice[identifier] = nextBuyoutPrice(price);
924         
925         // Set the buyout timestamp.
926         gameStates[gameIndex].identifierToBuyoutTimestamp[identifier] = block.timestamp;
927         
928         // Emit event
929         Buyout(gameIndex, msg.sender, identifier, x, y, block.timestamp, block.timestamp + gameSettings[gameIndex].activityTimer, gameStates[gameIndex].identifierToBuyoutPrice[identifier], gameStates[gameIndex].prizePool);
930         
931         // Calculate the excess Ether sent.
932         // msg.value is greater than or equal to price,
933         // so this cannot underflow.
934         uint256 excess = msg.value - price;
935         
936         if (excess > 0) {
937             // Refund any excess Ether (not susceptible to re-entry attack, as
938             // the owner is assigned before the transfer takes place).
939             msg.sender.transfer(excess);
940         }
941     }
942     
943     /// @notice Buy the current owner out of the tile. Set the player's referrer.
944     /// @param _gameIndex The index of the game to play on.
945     /// @param startNewGameIfIdle Start a new game if the current game is idle.
946     /// @param x The x-coordinate of the tile to buy.
947     /// @param y The y-coordinate of the tile to buy.
948     function buyoutAndSetReferrer(uint256 _gameIndex, bool startNewGameIfIdle, uint256 x, uint256 y, address referrerAddress) external payable {
949         // Set the referrer.
950         burnupHolding.setReferrer(msg.sender, referrerAddress);
951     
952         // Play.
953         buyout(_gameIndex, startNewGameIfIdle, x, y);
954     }
955     
956     /// @notice Spice up the prize pool.
957     /// @param _gameIndex The index of the game to add spice to.
958     /// @param message An optional message to be sent along with the spice.
959     function spiceUp(uint256 _gameIndex, string message) external payable {
960         // Check to see if the game should end. Process payment.
961         _processGameEnd();
962         
963         // Check the game index.
964         require(_gameIndex == gameIndex);
965     
966         // Game must be live or unpaused.
967         require(gameStates[gameIndex].gameStarted || !paused);
968         
969         // Funds must be sent.
970         require(msg.value > 0);
971         
972         // Add funds to the prize pool.
973         gameStates[gameIndex].prizePool = gameStates[gameIndex].prizePool.add(msg.value);
974         
975         // Emit event.
976         SpiceUpPrizePool(gameIndex, msg.sender, msg.value, message, gameStates[gameIndex].prizePool);
977     }
978     
979     /// @notice End the game. Pay prize.
980     function endGame() external {
981         require(_processGameEnd());
982     }
983     
984     /// @dev End the game. Pay prize.
985     function _processGameEnd() internal returns(bool) {
986         address currentOwner = gameStates[gameIndex].identifierToOwner[gameStates[gameIndex].lastFlippedTile];
987     
988         // The game must be started.
989         if (!gameStates[gameIndex].gameStarted) {
990             return false;
991         }
992     
993         // The last flipped tile must be owned (i.e. there has been at
994         // least one flip).
995         if (currentOwner == address(0x0)) {
996             return false;
997         }
998         
999         // The last flipped tile must have become inactive.
1000         if (gameStates[gameIndex].identifierToBuyoutTimestamp[gameStates[gameIndex].lastFlippedTile].add(gameSettings[gameIndex].activityTimer) >= block.timestamp) {
1001             return false;
1002         }
1003         
1004         // Assign prize pool to the owner of the last-flipped tile.
1005         if (gameStates[gameIndex].prizePool > 0) {
1006             _sendFunds(currentOwner, gameStates[gameIndex].prizePool);
1007         }
1008         
1009         // Get coordinates of last flipped tile.
1010         var (x, y) = identifierToCoordinate(gameStates[gameIndex].lastFlippedTile);
1011         
1012         // Emit event.
1013         End(gameIndex, currentOwner, gameStates[gameIndex].lastFlippedTile, x, y, gameStates[gameIndex].identifierToBuyoutTimestamp[gameStates[gameIndex].lastFlippedTile].add(gameSettings[gameIndex].activityTimer), gameStates[gameIndex].prizePool);
1014         
1015         // Increment the game index. This won't overflow before the heat death of the universe.
1016         gameIndex++;
1017         
1018         // Indicate ending the game was successful.
1019         return true;
1020     }
1021 }