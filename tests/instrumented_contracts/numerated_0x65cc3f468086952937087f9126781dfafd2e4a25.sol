1 pragma solidity ^0.4.24;
2 
3 // File: ..\openzeppelin-solidity\contracts\math\SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: ..\openzeppelin-solidity\contracts\ownership\Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95   /**
96    * @dev Allows the current owner to relinquish control of the contract.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 }
103 
104 // File: ..\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
105 
106 /**
107  * @title Pausable
108  * @dev Base contract which allows children to implement an emergency stop mechanism.
109  */
110 contract Pausable is Ownable {
111   event Pause();
112   event Unpause();
113 
114   bool public paused = false;
115 
116 
117   /**
118    * @dev Modifier to make a function callable only when the contract is not paused.
119    */
120   modifier whenNotPaused() {
121     require(!paused);
122     _;
123   }
124 
125   /**
126    * @dev Modifier to make a function callable only when the contract is paused.
127    */
128   modifier whenPaused() {
129     require(paused);
130     _;
131   }
132 
133   /**
134    * @dev called by the owner to pause, triggers stopped state
135    */
136   function pause() onlyOwner whenNotPaused public {
137     paused = true;
138     emit Pause();
139   }
140 
141   /**
142    * @dev called by the owner to unpause, returns to normal state
143    */
144   function unpause() onlyOwner whenPaused public {
145     paused = false;
146     emit Unpause();
147   }
148 }
149 
150 // File: contracts\HorseyExchange.sol
151 
152 /**
153  * @title ERC721 Non-Fungible Token Standard basic interface
154  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
155  */
156 contract ERC721Basic {
157     function balanceOf(address _owner) public view returns (uint256 _balance);
158     function ownerOf(uint256 _tokenId) public view returns (address _owner);
159     function exists(uint256 _tokenId) public view returns (bool _exists);
160 
161     function approve(address _to, uint256 _tokenId) public;
162     function getApproved(uint256 _tokenId) public view returns (address _operator);
163 
164     function transferFrom(address _from, address _to, uint256 _tokenId) public;
165 }
166 
167 /**
168     @dev HorseyExchange contract - handles horsey market exchange which
169     includes the following set of functions:
170     1. Deposit to Exchange
171     2. Cancel sale
172     3. Purchase token
173 **/
174 contract HorseyExchange is Pausable { //also Ownable
175 
176     using SafeMath for uint256;
177 
178     event HorseyDeposit(uint256 tokenId, uint256 price);
179     event SaleCanceled(uint256 tokenId);
180     event HorseyPurchased(uint256 tokenId, address newOwner, uint256 totalToPay);
181 
182     /// @dev Fee applied to market maker - measured as percentage
183     uint256 public marketMakerFee = 3;
184 
185     /// @dev Amount collected in fees
186     uint256 collectedFees = 0;
187 
188     /// @dev  RoyalStables TOKEN
189     ERC721Basic public token;
190 
191     /**
192         @dev used to store the price and the owner address of a token on sale
193     */
194     struct SaleData {
195         uint256 price;
196         address owner;
197     }
198 
199     /// @dev Market spec to lookup price and original owner based on token id
200     mapping (uint256 => SaleData) market;
201 
202     /// @dev mapping of current tokens on market by owner
203     mapping (address => uint256[]) userBarn;
204 
205     /// @dev initialize
206     constructor() Pausable() public {
207     }
208 
209     /**
210         @dev Since the exchange requires the horsey contract and horsey contract
211             requires exchange address, we cant initialize both of them in constructors
212         @param _token Address of the stables contract
213     */
214     function setStables(address _token) external
215     onlyOwner()
216     {
217         require(address(_token) != 0,"Address of token is zero");
218         token = ERC721Basic(_token);
219     }
220 
221     /**
222         @dev Allows the owner to change market fees
223         @param fees The new fees to apply (can be zero)
224     */
225     function setMarketFees(uint256 fees) external
226     onlyOwner()
227     {
228         marketMakerFee = fees;
229     }
230 
231     /// @return the tokens on sale based on the user address
232     function getTokensOnSale(address user) external view returns(uint256[]) {
233         return userBarn[user];
234     }
235 
236     /// @return the token price with the fees
237     function getTokenPrice(uint256 tokenId) public view
238     isOnMarket(tokenId) returns (uint256) {
239         return market[tokenId].price + (market[tokenId].price.div(100).mul(marketMakerFee));
240     }
241 
242     /**
243         @dev User sends token to sell to exchange - at this point the exchange contract takes
244             ownership, but will map token ownership back to owner for auotmated withdraw on
245             cancel - requires that user is the rightful owner and is not
246             asking for a null price
247     */
248     function depositToExchange(uint256 tokenId, uint256 price) external
249     whenNotPaused()
250     isTokenOwner(tokenId)
251     nonZeroPrice(price)
252     tokenAvailable() {
253         require(token.getApproved(tokenId) == address(this),"Exchange is not allowed to transfer");
254         //Transfers token from depositee to exchange (contract address)
255         token.transferFrom(msg.sender, address(this), tokenId);
256         
257         //add the token to the market
258         market[tokenId] = SaleData(price,msg.sender);
259 
260         //Add token to exchange map - tracking by owner of all tokens
261         userBarn[msg.sender].push(tokenId);
262 
263         emit HorseyDeposit(tokenId, price);
264     }
265 
266     /**
267         @dev Allows true owner of token to cancel sale at anytime
268         @param tokenId ID of the token to remove from the market
269         @return true if user still has tokens for sale
270     */
271     function cancelSale(uint256 tokenId) external 
272     whenNotPaused()
273     originalOwnerOf(tokenId) 
274     tokenAvailable() returns (bool) {
275         //throws on fail - transfers token from exchange back to original owner
276         token.transferFrom(address(this),msg.sender,tokenId);
277         
278         //Reset token on market - remove
279         delete market[tokenId];
280 
281         //Reset barn tracker for user
282         _removeTokenFromBarn(tokenId, msg.sender);
283 
284         emit SaleCanceled(tokenId);
285 
286         //Return true if this user is still 'active' within the exchange
287         //This will help with client side actions
288         return userBarn[msg.sender].length > 0;
289     }
290 
291     /**
292         @dev Performs the purchase of a token that is present on the market - this includes checking that the
293             proper amount is sent + appliced fee, updating seller's balance, updated collected fees and
294             transfering token to buyer
295             Only market tokens can be purchased
296         @param tokenId ID of the token we wish to purchase
297     */
298     function purchaseToken(uint256 tokenId) external payable 
299     whenNotPaused()
300     isOnMarket(tokenId) 
301     tokenAvailable()
302     notOriginalOwnerOf(tokenId)
303     {
304         //Did the sender accidently pay over? - if so track the amount over
305         uint256 totalToPay = getTokenPrice(tokenId);
306         require(msg.value >= totalToPay, "Not paying enough");
307 
308         //fetch this tokens sale data
309         SaleData memory sale = market[tokenId];
310 
311         //Add to collected fee amount payable to DEVS
312         collectedFees += totalToPay - sale.price;
313 
314         //pay the seller
315         sale.owner.transfer(sale.price);
316 
317         //Reset barn tracker for user
318         _removeTokenFromBarn(tokenId,  sale.owner);
319 
320         //Reset token on market - remove
321         delete market[tokenId];
322 
323         //Transfer the ERC721 to the buyer - we leave the sale amount
324         //to be withdrawn by the user (transferred from exchange)
325         token.transferFrom(address(this), msg.sender, tokenId);
326 
327         //Return over paid amount to sender if necessary
328         if(msg.value > totalToPay) //overpaid
329         {
330             msg.sender.transfer(msg.value.sub(totalToPay));
331         }
332 
333         emit HorseyPurchased(tokenId, msg.sender, totalToPay);
334     }
335 
336     /// @dev Transfers the collected fees to the owner
337     function withdraw() external
338     onlyOwner()
339     {
340         assert(collectedFees <= address(this).balance);
341         owner.transfer(collectedFees);
342         collectedFees = 0;
343     }
344 
345     /**
346         @dev Internal function to remove a token from the users barn array
347         @param tokenId ID of the token to remove
348         @param barnAddress Address of the user selling tokens
349     */
350     function _removeTokenFromBarn(uint tokenId, address barnAddress)  internal {
351         uint256[] storage barnArray = userBarn[barnAddress];
352         require(barnArray.length > 0,"No tokens to remove");
353         int index = _indexOf(tokenId, barnArray);
354         require(index >= 0, "Token not found in barn");
355 
356         // Shift entire array :(
357         for (uint256 i = uint256(index); i<barnArray.length-1; i++){
358             barnArray[i] = barnArray[i+1];
359         }
360 
361         // Remove element, update length, return array
362         // this should be enough since https://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array
363         barnArray.length--;
364     }
365 
366     /**
367         @dev Helper function which stores in memory an array which is passed in, and
368         @param item element we are looking for
369         @param array the array to look into
370         @return the index of the item of interest
371     */
372     function _indexOf(uint item, uint256[] memory array) internal pure returns (int256){
373 
374         //Iterate over array to find indexOf(token)
375         for(uint256 i = 0; i < array.length; i++){
376             if(array[i] == item){
377                 return int256(i);
378             }
379         }
380 
381         //Item not found
382         return -1;
383     }
384 
385     /// @dev requires token to be on the market = current owner is exchange
386     modifier isOnMarket(uint256 tokenId) {
387         require(token.ownerOf(tokenId) == address(this),"Token not on market");
388         _;
389     }
390     
391     /// @dev Is the user the owner of this token?
392     modifier isTokenOwner(uint256 tokenId) {
393         require(token.ownerOf(tokenId) == msg.sender,"Not tokens owner");
394         _;
395     }
396 
397     /// @dev Is this the original owner of the token - at exchange level
398     modifier originalOwnerOf(uint256 tokenId) {
399         require(market[tokenId].owner == msg.sender,"Not the original owner of");
400         _;
401     }
402 
403     /// @dev Is this the original owner of the token - at exchange level
404     modifier notOriginalOwnerOf(uint256 tokenId) {
405         require(market[tokenId].owner != msg.sender,"Is the original owner");
406         _;
407     }
408 
409     /// @dev Is a nonzero price being sent?
410     modifier nonZeroPrice(uint256 price){
411         require(price > 0,"Price is zero");
412         _;
413     }
414 
415     /// @dev Do we have a token address
416     modifier tokenAvailable(){
417         require(address(token) != 0,"Token address not set");
418         _;
419     }
420 }
421 
422 // File: contracts\EthorseHelpers.sol
423 
424 contract BettingControllerInterface {
425     address public owner;
426 }
427 /**
428     @title Race contract - used for linking ethorse Race struct 
429     @dev This interface is losely based on ethorse race contract
430 */
431 contract EthorseRace {
432 
433     //Encapsulation of racing information 
434     struct chronus_info {
435         bool  betting_open; // boolean: check if betting is open
436         bool  race_start; //boolean: check if race has started
437         bool  race_end; //boolean: check if race has ended
438         bool  voided_bet; //boolean: check if race has been voided
439         uint32  starting_time; // timestamp of when the race starts
440         uint32  betting_duration;
441         uint32  race_duration; // duration of the race
442         uint32 voided_timestamp;
443     }
444 
445     address public owner;
446     
447     //Point to racing information
448     chronus_info public chronus;
449 
450     //Coin index mapping to flag - true if index is winner
451     mapping (bytes32 => bool) public winner_horse;
452     /*
453             // exposing the coin pool details for DApp
454     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
455         return (coinIndex[index].total, coinIndex[index].pre, coinIndex[index].post, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
456     }
457     */
458     // exposing the coin pool details for DApp
459     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint);
460 }
461 
462 /**
463     @title API contract - used to connect with Race contract and 
464         encapsulate race information for token inidices and winner
465         checking.
466 */
467 contract EthorseHelpers {
468 
469     /// @dev Convert all symbols to bytes array
470     bytes32[] public all_horses = [bytes32("BTC"),bytes32("ETH"),bytes32("LTC")];
471     mapping(address => bool) private _legitOwners;
472 
473     /// @dev Used to add new symbol to the bytes array 
474     function _addHorse(bytes32 newHorse) internal {
475         all_horses.push(newHorse);
476     }
477 
478     function _addLegitOwner(address newOwner) internal
479     {
480         _legitOwners[newOwner] = true;
481     }
482 
483     function getall_horsesCount() public view returns(uint) {
484         return all_horses.length;
485     }
486 
487     /**
488         @param raceAddress - address of this race
489         @param eth_address - user's ethereum wallet address
490         @return true if user is winner + name of the winning horse (LTC,BTC,ETH,...)
491     */
492     function _isWinnerOf(address raceAddress, address eth_address) internal view returns (bool,bytes32)
493     {
494         //acquire race, fails if doesnt exist
495         EthorseRace race = EthorseRace(raceAddress);
496         //acquire races betting controller
497         BettingControllerInterface bc = BettingControllerInterface(race.owner());
498         //make sure the betting controllers owner is in the legit list given by devs
499         require(_legitOwners[bc.owner()]);
500         //acquire chronus
501         bool  voided_bet; //boolean: check if race has been voided
502         bool  race_end; //boolean: check if race has ended
503         (,,race_end,voided_bet,,,,) = race.chronus();
504 
505         //cant be winner if race was refunded or didnt end yet
506         if(voided_bet || !race_end)
507             return (false,bytes32(0));
508 
509         //aquire winner race index
510         bytes32 horse;
511         bool found = false;
512         uint256 arrayLength = all_horses.length;
513 
514         //Iterate over coin symbols to find winner - tie could be possible?
515         for(uint256 i = 0; i < arrayLength; i++)
516         {
517             if(race.winner_horse(all_horses[i])) {
518                 horse = all_horses[i];
519                 found = true;
520                 break;
521             }
522         }
523         //no winner horse? shouldnt happen unless this horse isnt registered
524         if(!found)
525             return (false,bytes32(0));
526 
527         //check the bet amount of the eth_address on the winner horse
528         uint256 bet_amount = 0;
529         if(eth_address != address(0)) {
530             (,,,, bet_amount) = race.getCoinIndex(horse, eth_address);
531         }
532         
533         //winner if the eth_address had a bet > 0 on the winner horse
534         return (bet_amount > 0, horse);
535     }
536 }
537 
538 // File: contracts\HorseyToken.sol
539 
540 contract RoyalStablesInterface {
541     
542     struct Horsey {
543         address race;
544         bytes32 dna;
545         uint8 feedingCounter;
546         uint8 tier;
547     }
548 
549     mapping(uint256 => Horsey) public horseys;
550     mapping(address => uint32) public carrot_credits;
551     mapping(uint256 => string) public names;
552     address public master;
553 
554     function getOwnedTokens(address eth_address) public view returns (uint256[]);
555     function storeName(uint256 tokenId, string newName) public;
556     function storeCarrotsCredit(address client, uint32 amount) public;
557     function storeHorsey(address client, uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public;
558     function modifyHorsey(uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public;
559     function modifyHorseyDna(uint256 tokenId, bytes32 dna) public;
560     function modifyHorseyFeedingCounter(uint256 tokenId, uint8 feedingCounter) public;
561     function modifyHorseyTier(uint256 tokenId, uint8 tier) public;
562     function unstoreHorsey(uint256 tokenId) public;
563     function ownerOf(uint256 tokenId) public returns (address);
564 }
565 
566 /**
567     @title HorseyToken ERC721 Token
568     @dev Horse contract - horse derives fro AccessManager built on top of ERC721 token and uses 
569     @dev EthorseHelpers and AccessManager
570 */
571 contract HorseyToken is EthorseHelpers,Pausable {
572     using SafeMath for uint256;
573 
574     /// @dev called when someone claims a token
575     event Claimed(address raceAddress, address eth_address, uint256 tokenId);
576     
577     /// @dev called when someone starts a feeding process
578     event Feeding(uint256 tokenId);
579 
580     /// @dev called when someone ends a feeding process
581     event ReceivedCarrot(uint256 tokenId, bytes32 newDna);
582 
583     /// @dev called when someone fails to end a feeding on the 255 blocks timer
584     event FeedingFailed(uint256 tokenId);
585 
586     /// @dev called when a horsey is renamed
587     event HorseyRenamed(uint256 tokenId, string newName);
588 
589     /// @dev called when a horsey is freed for carrots
590     event HorseyFreed(uint256 tokenId);
591 
592     /// @dev address of the RoyalStables
593     RoyalStablesInterface public stables;
594 
595     ///@dev multiplier applied to carrots received from burning a horsey
596     uint8 public carrotsMultiplier = 1;
597 
598     ///@dev multiplier applied to rarity bounds when feeding horsey
599     uint8 public rarityMultiplier = 1;
600 
601     ///@dev fee to pay when claiming a token
602     uint256 public claimingFee = 0.008 ether;
603 
604     /**
605         @dev Holds the necessary data to feed a horsey
606             The user has to create begin feeding and wait for the block
607             with the feeding transaction to be hashed
608             Only then he can stop the feeding
609     */
610     struct FeedingData {
611         uint256 blockNumber;    ///@dev Holds the block number where the feeding began
612         uint256 horsey;         ///@dev Holds the horsey id
613     }
614 
615     /// @dev Maps a user to his pending feeding
616     mapping(address => FeedingData) public pendingFeedings;
617 
618     /// @dev Stores the renaming fees per character a user has to pay upon renaming a horsey
619     uint256 public renamingCostsPerChar = 0.001 ether;
620 
621     /**
622         @dev Contracts constructor
623             Initializes token data
624             is pausable,ownable
625         @param stablesAddress Address of the official RoyalStables contract
626     */
627     constructor(address stablesAddress) 
628     EthorseHelpers() 
629     Pausable() public {
630         stables = RoyalStablesInterface(stablesAddress);
631     }
632 
633     /**
634         @dev Changes multiplier for rarity on feed
635         @param newRarityMultiplier The cost to charge in wei for each character of the name
636     */
637     function setRarityMultiplier(uint8 newRarityMultiplier) external 
638     onlyOwner()  {
639         rarityMultiplier = newRarityMultiplier;
640     }
641 
642     /**
643         @dev Sets a new muliplier for freeing a horse
644         @param newCarrotsMultiplier the new multiplier for feeding
645     */
646     function setCarrotsMultiplier(uint8 newCarrotsMultiplier) external 
647     onlyOwner()  {
648         carrotsMultiplier = newCarrotsMultiplier;
649     }
650 
651     /**
652         @dev Sets a new renaming per character cost in wei
653             Any CLevel can call this function
654         @param newRenamingCost The cost to charge in wei for each character of the name
655     */
656     function setRenamingCosts(uint256 newRenamingCost) external 
657     onlyOwner()  {
658         renamingCostsPerChar = newRenamingCost;
659     }
660 
661     /**
662         @dev Sets a new claiming fee in wei
663             Any CLevel can call this function
664         @param newClaimingFee The cost to charge in wei for each claimed HRSY
665     */
666     function setClaimingCosts(uint256 newClaimingFee) external
667     onlyOwner()  {
668         claimingFee = newClaimingFee;
669     }
670 
671     /**
672         @dev Allows to add a legit owner address for races validation
673         @param newAddress the dev address deploying BettingController to add
674     */
675     function addLegitDevAddress(address newAddress) external
676     onlyOwner() {
677         _addLegitOwner(newAddress);
678     }
679 
680     /**
681         @dev Owner can withdraw the current balance
682     */
683     function withdraw() external 
684     onlyOwner()  {
685         owner.transfer(address(this).balance); //throws on fail
686     }
687 
688     //allows owner to add a horse name to the possible horses list (BTC,ETH,LTC,...)
689     /**
690         @dev Adds a new horse index to the possible horses list (BTC,ETH,LTC,...)
691             This is in case ethorse adds a new coin
692             Any CLevel can call this function
693         @param newHorse Index of the horse to add (same data type as the original ethorse erc20 contract code)
694     */
695     function addHorseIndex(bytes32 newHorse) external
696     onlyOwner() {
697         _addHorse(newHorse);
698     }
699 
700     /**
701         @dev Gets the complete list of token ids which belongs to an address
702         @param eth_address The address you want to lookup owned tokens from
703         @return List of all owned by eth_address tokenIds
704     */
705     function getOwnedTokens(address eth_address) public view returns (uint256[]) {
706         return stables.getOwnedTokens(eth_address);
707     }
708     
709     /**
710         @dev Allows to check if an eth_address can claim a horsey from this contract
711             should we also check if already claimed here?
712         @param raceAddress The ethorse race you want to claim from
713         @param eth_address The users address you want to claim the token for
714         @return True only if eth_address is a winner of the race contract at raceAddress
715     */
716     function can_claim(address raceAddress, address eth_address) public view returns (bool) {
717         bool res;
718         (res,) = _isWinnerOf(raceAddress, eth_address);
719         return res;
720     }
721 
722     /**
723         @dev Allows a user to claim a special horsey with the same dna as the race one
724             Cant be used on paused
725             The sender has to be a winner of the race and must never have claimed a special horsey from this race
726         @param raceAddress The race's address
727     */
728     function claim(address raceAddress) external payable
729     costs(claimingFee)
730     whenNotPaused()
731     {
732         //call _isWinnerOf with a 0 address to simply get the winner horse
733         bytes32 winner;
734         (,winner) = _isWinnerOf(raceAddress, address(0));
735         require(winner != bytes32(0),"Winner is zero");
736         require(can_claim(raceAddress, msg.sender),"can_claim return false");
737         //require(!exists(id)); should already be checked by mining function
738         uint256 id = _generate_special_horsey(raceAddress, msg.sender, winner);
739         emit Claimed(raceAddress, msg.sender, id);
740     }
741 
742     /**
743         @dev Allows a user to give a horsey a name or rename it
744             This function is payable and its cost is renamingCostsPerChar * length(newname)
745             Cant be called while paused
746             If called with too low balance, the modifier will throw
747             If called with too much balance, we try to return the remaining funds back
748             Upon completion we update all ceos balances, maybe not very efficient?
749         @param tokenId ID of the horsey to rename
750         @param newName The name to give to the horsey
751     */
752     function renameHorsey(uint256 tokenId, string newName) external 
753     whenNotPaused()
754     onlyOwnerOf(tokenId) 
755     costs(renamingCostsPerChar * bytes(newName).length)
756     payable {
757         uint256 renamingFee = renamingCostsPerChar * bytes(newName).length;
758         //Return over paid amount to sender if necessary
759         if(msg.value > renamingFee) //overpaid
760         {
761             msg.sender.transfer(msg.value.sub(renamingFee));
762         }
763         //store the new name
764         stables.storeName(tokenId,newName);
765         emit HorseyRenamed(tokenId,newName);
766     }
767 
768     /**
769         @dev Allows a user to burn a token he owns to get carrots
770             The mount of carrots given is equal to the horsey's feedingCounter upon burning
771             Cant be called on a horsey with a pending feeding
772             Cant be called while paused
773         @param tokenId ID of the token to burn
774     */
775     function freeForCarrots(uint256 tokenId) external 
776     whenNotPaused()
777     onlyOwnerOf(tokenId) {
778         require(pendingFeedings[msg.sender].horsey != tokenId,"");
779         //credit carrots
780         uint8 feedingCounter;
781         (,,feedingCounter,) = stables.horseys(tokenId);
782         stables.storeCarrotsCredit(msg.sender,stables.carrot_credits(msg.sender) + uint32(feedingCounter * carrotsMultiplier));
783         stables.unstoreHorsey(tokenId);
784         emit HorseyFreed(tokenId);
785     }
786 
787     /**
788         @dev Returns the amount of carrots the user owns
789             We have a getter to hide the carrots amount from public view
790         @return The current amount of carrot credits the sender owns 
791     */
792     function getCarrotCredits() external view returns (uint32) {
793         return stables.carrot_credits(msg.sender);
794     }
795 
796     /**
797         @dev Returns horsey data of a given token
798         @param tokenId ID of the horsey to fetch
799         @return (race address, dna, feedingCounter, name)
800     */
801     function getHorsey(uint256 tokenId) public view returns (address, bytes32, uint8, string) {
802         RoyalStablesInterface.Horsey memory temp;
803         (temp.race,temp.dna,temp.feedingCounter,temp.tier) = stables.horseys(tokenId);
804         return (temp.race,temp.dna,temp.feedingCounter,stables.names(tokenId));
805     }
806 
807     /**
808         @dev Allows to feed a horsey to increase its feedingCounter value
809             Gives a chance to get a rare trait
810             The amount of carrots required is the value of current feedingCounter
811             The carrots the user owns will be reduced accordingly upon success
812             Cant be called while paused
813         @param tokenId ID of the horsey to feed
814     */
815     function feed(uint256 tokenId) external 
816     whenNotPaused()
817     onlyOwnerOf(tokenId) 
818     carrotsMeetLevel(tokenId)
819     noFeedingInProgress()
820     {
821         pendingFeedings[msg.sender] = FeedingData(block.number,tokenId);
822         uint8 feedingCounter;
823         (,,feedingCounter,) = stables.horseys(tokenId);
824         stables.storeCarrotsCredit(msg.sender,stables.carrot_credits(msg.sender) - uint32(feedingCounter));
825         emit Feeding(tokenId);
826     }
827 
828     /**
829         @dev Allows user to stop feeding a horsey
830             This will trigger a random rarity chance
831     */
832     function stopFeeding() external
833     feedingInProgress() returns (bool) {
834         uint256 blockNumber = pendingFeedings[msg.sender].blockNumber;
835         uint256 tokenId = pendingFeedings[msg.sender].horsey;
836         //you cant feed and stop feeding from the same block!
837         require(block.number - blockNumber >= 1,"feeding and stop feeding are in same block");
838 
839         delete pendingFeedings[msg.sender];
840 
841         //solidity only gives you access to the previous 256 blocks
842         //deny and remove this obsolete feeding if we cant fetch its blocks hash
843         if(block.number - blockNumber > 255) {
844             //the feeding is outdated = failed
845             //the user can feed again but he lost his carrots
846             emit FeedingFailed(tokenId);
847             return false; 
848         }
849 
850         //token could have been transfered in the meantime to someone else
851         if(stables.ownerOf(tokenId) != msg.sender) {
852             //the feeding is failed because the token no longer belongs to this user = failed
853             //the user has lost his carrots
854             emit FeedingFailed(tokenId);
855             return false; 
856         }
857         
858         //call horsey generation with the claim block hash
859         _feed(tokenId, blockhash(blockNumber));
860         bytes32 dna;
861         (,dna,,) = stables.horseys(tokenId);
862         emit ReceivedCarrot(tokenId, dna);
863         return true;
864     }
865 
866     /// @dev Only ether sent explicitly through the donation() function is accepted
867     function() external payable {
868         revert("Not accepting donations");
869     }
870 
871     /**
872         @dev Internal function to increase a horsey's rarity
873             Uses a random value to assess if the feeding process increases rarity
874             The chances of having a rarity increase are based on the current feedingCounter
875         @param tokenId ID of the token to "feed"
876         @param blockHash Hash of the block where the feeding began
877     */
878     function _feed(uint256 tokenId, bytes32 blockHash) internal {
879         //Grab the upperbound for probability 100,100
880         uint8 tier;
881         uint8 feedingCounter;
882         (,,feedingCounter,tier) = stables.horseys(tokenId);
883         uint256 probabilityByRarity = 10 ** (uint256(tier).add(1));
884         uint256 randNum = uint256(keccak256(abi.encodePacked(tokenId, blockHash))) % probabilityByRarity;
885 
886         //Scale probability based on horsey's level
887         if(randNum <= (feedingCounter * rarityMultiplier)){
888             _increaseRarity(tokenId, blockHash);
889         }
890 
891         //Increment feedingCounter
892         //Maximum allowed is 255, which requires 32385 carrots, so we should never reach that
893         if(feedingCounter < 255) {
894             stables.modifyHorseyFeedingCounter(tokenId,feedingCounter+1);
895         }
896     }
897 
898     /// @dev creates a special token id based on the race and the coin index
899     function _makeSpecialId(address race, address sender, bytes32 coinIndex) internal pure returns (uint256) {
900         return uint256(keccak256(abi.encodePacked(race, sender, coinIndex)));
901     }
902 
903     /**
904         @dev Internal function to generate a SPECIAL horsey token
905             we then use the ERC721 inherited minting process
906             the dna is a bytes32 target for a keccak256. Not using blockhash
907             finaly, a bitmask zeros the first 2 bytes for rarity traits
908         @param race Address of the associated race
909         @param eth_address Address of the user to receive the token
910         @param coinIndex The index of the winning coin
911         @return ID of the token
912     */
913     function _generate_special_horsey(address race, address eth_address, bytes32 coinIndex) internal returns (uint256) {
914         uint256 id = _makeSpecialId(race, eth_address, coinIndex);
915         //generate dna
916         bytes32 dna = _shiftRight(keccak256(abi.encodePacked(race, coinIndex)),16);
917          //storeHorsey checks if the token exists before minting already, so we dont have to here
918         stables.storeHorsey(eth_address,id,race,dna,1,0);
919         return id;
920     }
921     
922     /**
923         @dev Internal function called to increase a horsey rarity
924             We generate a random zeros mask with a single 1 in the leading 16 bits
925         @param tokenId Id of the token to increase rarity of
926         @param blockHash hash of the block where the feeding began
927     */
928     function _increaseRarity(uint256 tokenId, bytes32 blockHash) private {
929         uint8 tier;
930         bytes32 dna;
931         (,dna,,tier) = stables.horseys(tokenId);
932         if(tier < 255)
933             stables.modifyHorseyTier(tokenId,tier+1);
934         uint256 random = uint256(keccak256(abi.encodePacked(tokenId, blockHash)));
935         //this creates a mask of 256 bits such as one of the first 16 bits will be 1
936         bytes32 rarityMask = _shiftLeft(bytes32(1), (random % 16 + 240));
937         bytes32 newdna = dna | rarityMask; //apply mask to add the random flag
938         stables.modifyHorseyDna(tokenId,newdna);
939     }
940 
941     /// @dev shifts a bytes32 left by n positions
942     function _shiftLeft(bytes32 data, uint n) internal pure returns (bytes32) {
943         return bytes32(uint256(data)*(2 ** n));
944     }
945 
946     /// @dev shifts a bytes32 right by n positions
947     function _shiftRight(bytes32 data, uint n) internal pure returns (bytes32) {
948         return bytes32(uint256(data)/(2 ** n));
949     }
950 
951     /// @dev Modifier to ensure user can afford a rehorse
952     modifier carrotsMeetLevel(uint256 tokenId){
953         uint256 feedingCounter;
954         (,,feedingCounter,) = stables.horseys(tokenId);
955         require(feedingCounter <= stables.carrot_credits(msg.sender),"Not enough carrots");
956         _;
957     }
958 
959     /// @dev insures the caller payed the required amount
960     modifier costs(uint256 amount) {
961         require(msg.value >= amount,"Not enough funds");
962         _;
963     }
964 
965     /// @dev requires the address to be non null
966     modifier validAddress(address addr) {
967         require(addr != address(0),"Address is zero");
968         _;
969     }
970 
971     /// @dev requires that the user isnt feeding a horsey already
972     modifier noFeedingInProgress() {
973         //if the key does not exit, then the default struct data is used where blockNumber is 0
974         require(pendingFeedings[msg.sender].blockNumber == 0,"Already feeding");
975         _;
976     }
977 
978     /// @dev requires that the user isnt feeding a horsey already
979     modifier feedingInProgress() {
980         //if the key does not exit, then the default struct data is used where blockNumber is 0
981         require(pendingFeedings[msg.sender].blockNumber != 0,"No pending feeding");
982         _;
983     }
984 
985     /// @dev requires that the user isnt feeding a horsey already
986     modifier onlyOwnerOf(uint256 tokenId) {
987         require(stables.ownerOf(tokenId) == msg.sender, "Caller is not owner of this token");
988         _;
989     }
990 }
991 
992 // File: contracts\HorseyPilot.sol
993 
994 /**
995     @title Adds rank management utilities and voting behavior
996     @dev Handles equities distribution and levels of access
997 
998     EXCHANGE FUNCTIONS IT CAN CALL
999 
1000     setClaimingFee OK 5
1001     setMarketFees OK 1
1002     withdraw
1003 
1004     TOKEN FUNCTIONS IT CAN CALL
1005 
1006     setRenamingCosts OK 0
1007     addHorseIndex OK 3
1008     setCarrotsMultiplier 8
1009     setRarityMultiplier 9
1010     addLegitDevAddress 2
1011     withdraw
1012 
1013     PAUSING OK 4
1014 */
1015 
1016 contract HorseyPilot {
1017     
1018     using SafeMath for uint256;
1019 
1020     /// @dev event that is fired when a new proposal is made
1021     event NewProposal(uint8 methodId, uint parameter, address proposer);
1022 
1023     /// @dev event that is fired when a proposal is accepted
1024     event ProposalPassed(uint8 methodId, uint parameter, address proposer);
1025 
1026     /// @dev minimum threshold that must be met in order to confirm
1027     /// a contract update
1028     uint8 constant votingThreshold = 2;
1029 
1030     /// @dev minimum amount of time a proposal can live
1031     /// after this time it can be forcefully invoked or killed by anyone
1032     uint256 constant proposalLife = 7 days;
1033 
1034     /// @dev amount of time until another proposal can be made
1035     /// we use this to eliminate proposal spamming
1036     uint256 constant proposalCooldown = 1 days;
1037 
1038     /// @dev used to reference the exact time the last proposal vetoed
1039     uint256 cooldownStart;
1040 
1041     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles.
1042     address public jokerAddress;
1043     address public knightAddress;
1044     address public paladinAddress;
1045 
1046     /// @dev List of all addresses allowed to vote
1047     address[3] public voters;
1048 
1049     /// @dev joker is the pool and gets the rest
1050     uint8 constant public knightEquity = 40;
1051     uint8 constant public paladinEquity = 10;
1052 
1053     /// @dev deployed exchange and token addresses
1054     address public exchangeAddress;
1055     address public tokenAddress;
1056 
1057     /// @dev Mapping to keep track of pending balance of contract owners
1058     mapping(address => uint) internal _cBalance;
1059 
1060     /// @dev Encapsulates information about a proposed update
1061     struct Proposal{
1062         address proposer;           /// @dev address of the CEO at the origin of this proposal
1063         uint256 timestamp;          /// @dev the time at which this propsal was made
1064         uint256 parameter;          /// @dev parameters associated with proposed method invocation
1065         uint8   methodId;           /// @dev id maps to function 0:rename horse, 1:change fees, 2:?    
1066         address[] yay;              /// @dev list of all addresses who voted     
1067         address[] nay;              /// @dev list of all addresses who voted against     
1068     }
1069 
1070     /// @dev the pending proposal
1071     Proposal public currentProposal;
1072 
1073     /// @dev true if the proposal is waiting for votes
1074     bool public proposalInProgress = false;
1075 
1076     /// @dev Value to keep track of avaible balance
1077     uint256 public toBeDistributed;
1078 
1079     /// @dev used to deploy contracts only once
1080     bool deployed = false;
1081 
1082     /**
1083         @param _jokerAddress joker
1084         @param _knightAddress knight
1085         @param _paladinAddress paladin
1086         @param _voters list of all allowed voting addresses
1087     */
1088     constructor(
1089     address _jokerAddress,
1090     address _knightAddress,
1091     address _paladinAddress,
1092     address[3] _voters
1093     ) public {
1094         jokerAddress = _jokerAddress;
1095         knightAddress = _knightAddress;
1096         paladinAddress = _paladinAddress;
1097 
1098         for(uint i = 0; i < 3; i++) {
1099             voters[i] = _voters[i];
1100         }
1101 
1102         //Set cooldown start to 1 day ago so that cooldown is irrelevant
1103         cooldownStart = block.timestamp - proposalCooldown;
1104     }
1105 
1106     /**
1107         @dev Used to deploy children contracts as a one shot call
1108     */
1109     function deployChildren(address stablesAddress) external {
1110         require(!deployed,"already deployed");
1111         // deploy token and exchange contracts
1112         exchangeAddress = new HorseyExchange();
1113         tokenAddress = new HorseyToken(stablesAddress);
1114 
1115         // the exchange requires horsey token address
1116         HorseyExchange(exchangeAddress).setStables(stablesAddress);
1117 
1118         deployed = true;
1119     }
1120 
1121     /**
1122         @dev Transfers joker ownership to a new address
1123         @param newJoker the new address
1124     */
1125     function transferJokerOwnership(address newJoker) external 
1126     validAddress(newJoker) {
1127         require(jokerAddress == msg.sender,"Not right role");
1128         _moveBalance(newJoker);
1129         jokerAddress = newJoker;
1130     }
1131 
1132     /**
1133         @dev Transfers knight ownership to a new address
1134         @param newKnight the new address
1135     */
1136     function transferKnightOwnership(address newKnight) external 
1137     validAddress(newKnight) {
1138         require(knightAddress == msg.sender,"Not right role");
1139         _moveBalance(newKnight);
1140         knightAddress = newKnight;
1141     }
1142 
1143     /**
1144         @dev Transfers paladin ownership to a new address
1145         @param newPaladin the new address
1146     */
1147     function transferPaladinOwnership(address newPaladin) external 
1148     validAddress(newPaladin) {
1149         require(paladinAddress == msg.sender,"Not right role");
1150         _moveBalance(newPaladin);
1151         paladinAddress = newPaladin;
1152     }
1153 
1154     /**
1155         @dev Allow CEO to withdraw from pending value always checks to update redist
1156             We ONLY redist when a user tries to withdraw so we are not redistributing
1157             on every payment
1158         @param destination The address to send the ether to
1159     */
1160     function withdrawCeo(address destination) external 
1161     onlyCLevelAccess()
1162     validAddress(destination) {
1163         //Check that pending balance can be redistributed - if so perform
1164         //this procedure
1165         if(toBeDistributed > 0){
1166             _updateDistribution();
1167         }
1168         
1169         //Grab the balance of this CEO 
1170         uint256 balance = _cBalance[msg.sender];
1171         
1172         //If we have non-zero balance, CEO may withdraw from pending amount
1173         if(balance > 0 && (address(this).balance >= balance)) {
1174             destination.transfer(balance); //throws on fail
1175             _cBalance[msg.sender] = 0;
1176         }
1177     }
1178 
1179     /// @dev acquire funds from owned contracts
1180     function syncFunds() external {
1181         uint256 prevBalance = address(this).balance;
1182         HorseyToken(tokenAddress).withdraw();
1183         HorseyExchange(exchangeAddress).withdraw();
1184         uint256 newBalance = address(this).balance;
1185         //add to
1186         toBeDistributed = toBeDistributed.add(newBalance - prevBalance);
1187     }
1188 
1189     /// @dev allows a noble to access his holdings
1190     function getNobleBalance() external view
1191     onlyCLevelAccess() returns (uint256) {
1192         return _cBalance[msg.sender];
1193     }
1194 
1195     /**
1196         @dev Make a proposal and add to pending proposals
1197         @param methodId a string representing the function ie. 'renameHorsey()'
1198         @param parameter parameter to be used if invocation is approved
1199     */
1200     function makeProposal( uint8 methodId, uint256 parameter ) external
1201     onlyCLevelAccess()
1202     proposalAvailable()
1203     cooledDown()
1204     {
1205         currentProposal.timestamp = block.timestamp;
1206         currentProposal.parameter = parameter;
1207         currentProposal.methodId = methodId;
1208         currentProposal.proposer = msg.sender;
1209         delete currentProposal.yay;
1210         delete currentProposal.nay;
1211         proposalInProgress = true;
1212         
1213         emit NewProposal(methodId,parameter,msg.sender);
1214     }
1215 
1216     /**
1217         @dev Call to vote on a pending proposal
1218     */
1219     function voteOnProposal(bool voteFor) external 
1220     proposalPending()
1221     onlyVoters()
1222     notVoted() {
1223         //cant vote on expired!
1224         require((block.timestamp - currentProposal.timestamp) <= proposalLife);
1225         if(voteFor)
1226         {
1227             currentProposal.yay.push(msg.sender);
1228             //Proposal went through? invoke it
1229             if( currentProposal.yay.length >= votingThreshold )
1230             {
1231                 _doProposal();
1232                 proposalInProgress = false;
1233                 //no need to reset cooldown on successful proposal
1234                 return;
1235             }
1236 
1237         } else {
1238             currentProposal.nay.push(msg.sender);
1239             //Proposal failed?
1240             if( currentProposal.nay.length >= votingThreshold )
1241             {
1242                 proposalInProgress = false;
1243                 cooldownStart = block.timestamp;
1244                 return;
1245             }
1246         }
1247     }
1248 
1249     /**
1250         @dev Helps moving pending balance from one role to another
1251         @param newAddress the address to transfer the pending balance from the msg.sender account
1252     */
1253     function _moveBalance(address newAddress) internal
1254     validAddress(newAddress) {
1255         require(newAddress != msg.sender); /// @dev IMPORTANT or else the account balance gets reset here!
1256         _cBalance[newAddress] = _cBalance[msg.sender];
1257         _cBalance[msg.sender] = 0;
1258     }
1259 
1260     /**
1261         @dev Called at the start of withdraw to distribute any pending balances that live in the contract
1262             will only ever be called if balance is non-zero (funds should be distributed)
1263     */
1264     function _updateDistribution() internal {
1265         require(toBeDistributed != 0,"nothing to distribute");
1266         uint256 knightPayday = toBeDistributed.div(100).mul(knightEquity);
1267         uint256 paladinPayday = toBeDistributed.div(100).mul(paladinEquity);
1268 
1269         /// @dev due to the equities distribution, queen gets the remaining value
1270         uint256 jokerPayday = toBeDistributed.sub(knightPayday).sub(paladinPayday);
1271 
1272         _cBalance[jokerAddress] = _cBalance[jokerAddress].add(jokerPayday);
1273         _cBalance[knightAddress] = _cBalance[knightAddress].add(knightPayday);
1274         _cBalance[paladinAddress] = _cBalance[paladinAddress].add(paladinPayday);
1275         //Reset balance to 0
1276         toBeDistributed = 0;
1277     }
1278 
1279     /**
1280         @dev Execute the proposal
1281     */
1282     function _doProposal() internal {
1283         /// UPDATE the renaming cost
1284         if( currentProposal.methodId == 0 ) HorseyToken(tokenAddress).setRenamingCosts(currentProposal.parameter);
1285         
1286         /// UPDATE the market fees
1287         if( currentProposal.methodId == 1 ) HorseyExchange(exchangeAddress).setMarketFees(currentProposal.parameter);
1288 
1289         /// UPDATE the legit dev addresses list
1290         if( currentProposal.methodId == 2 ) HorseyToken(tokenAddress).addLegitDevAddress(address(currentProposal.parameter));
1291 
1292         /// ADD a horse index to exchange
1293         if( currentProposal.methodId == 3 ) HorseyToken(tokenAddress).addHorseIndex(bytes32(currentProposal.parameter));
1294 
1295         /// PAUSE/UNPAUSE the dApp
1296         if( currentProposal.methodId == 4 ) {
1297             if(currentProposal.parameter == 0) {
1298                 HorseyExchange(exchangeAddress).unpause();
1299                 HorseyToken(tokenAddress).unpause();
1300             } else {
1301                 HorseyExchange(exchangeAddress).pause();
1302                 HorseyToken(tokenAddress).pause();
1303             }
1304         }
1305 
1306         /// UPDATE the claiming fees
1307         if( currentProposal.methodId == 5 ) HorseyToken(tokenAddress).setClaimingCosts(currentProposal.parameter);
1308 
1309         /// UPDATE carrots multiplier
1310         if( currentProposal.methodId == 8 ){
1311             HorseyToken(tokenAddress).setCarrotsMultiplier(uint8(currentProposal.parameter));
1312         }
1313 
1314         /// UPDATE rarity multiplier
1315         if( currentProposal.methodId == 9 ){
1316             HorseyToken(tokenAddress).setRarityMultiplier(uint8(currentProposal.parameter));
1317         }
1318 
1319         emit ProposalPassed(currentProposal.methodId,currentProposal.parameter,currentProposal.proposer);
1320     }
1321 
1322     /// @dev requires the address to be non null
1323     modifier validAddress(address addr) {
1324         require(addr != address(0),"Address is zero");
1325         _;
1326     }
1327 
1328     /// @dev requires the sender to be on the contract owners list
1329     modifier onlyCLevelAccess() {
1330         require((jokerAddress == msg.sender) || (knightAddress == msg.sender) || (paladinAddress == msg.sender),"not c level");
1331         _;
1332     }
1333 
1334     /// @dev requires that a proposal is not in process or has exceeded its lifetime, and has cooled down
1335     /// after being vetoed
1336     modifier proposalAvailable(){
1337         require(((!proposalInProgress) || ((block.timestamp - currentProposal.timestamp) > proposalLife)),"proposal already pending");
1338         _;
1339     }
1340 
1341     // @dev requries that if this proposer was the last proposer, that he or she has reached the 
1342     // cooldown limit
1343     modifier cooledDown( ){
1344         if(msg.sender == currentProposal.proposer && (block.timestamp - cooldownStart < 1 days)){
1345             revert("Cool down period not passed yet");
1346         }
1347         _;
1348     }
1349 
1350     /// @dev requires a proposal to be active
1351     modifier proposalPending() {
1352         require(proposalInProgress,"no proposal pending");
1353         _;
1354     }
1355 
1356     /// @dev requires the voter to not have voted already
1357     modifier notVoted() {
1358         uint256 length = currentProposal.yay.length;
1359         for(uint i = 0; i < length; i++) {
1360             if(currentProposal.yay[i] == msg.sender) {
1361                 revert("Already voted");
1362             }
1363         }
1364 
1365         length = currentProposal.nay.length;
1366         for(i = 0; i < length; i++) {
1367             if(currentProposal.nay[i] == msg.sender) {
1368                 revert("Already voted");
1369             }
1370         }
1371         _;
1372     }
1373 
1374     /// @dev requires the voter to not have voted already
1375     modifier onlyVoters() {
1376         bool found = false;
1377         uint256 length = voters.length;
1378         for(uint i = 0; i < length; i++) {
1379             if(voters[i] == msg.sender) {
1380                 found = true;
1381                 break;
1382             }
1383         }
1384         if(!found) {
1385             revert("not a voter");
1386         }
1387         _;
1388     }
1389 }