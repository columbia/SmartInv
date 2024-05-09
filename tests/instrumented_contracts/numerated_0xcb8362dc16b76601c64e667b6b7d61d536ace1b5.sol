1 pragma solidity ^0.4.24;
2 
3 // File: ..\openzeppelin-solidity\contracts\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 // File: ..\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
57 
58 /**
59  * @title Pausable
60  * @dev Base contract which allows children to implement an emergency stop mechanism.
61  */
62 contract Pausable is Ownable {
63   event Pause();
64   event Unpause();
65 
66   bool public paused = false;
67 
68 
69   /**
70    * @dev Modifier to make a function callable only when the contract is not paused.
71    */
72   modifier whenNotPaused() {
73     require(!paused);
74     _;
75   }
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is paused.
79    */
80   modifier whenPaused() {
81     require(paused);
82     _;
83   }
84 
85   /**
86    * @dev called by the owner to pause, triggers stopped state
87    */
88   function pause() onlyOwner whenNotPaused public {
89     paused = true;
90     emit Pause();
91   }
92 
93   /**
94    * @dev called by the owner to unpause, returns to normal state
95    */
96   function unpause() onlyOwner whenPaused public {
97     paused = false;
98     emit Unpause();
99   }
100 }
101 
102 // File: ..\openzeppelin-solidity\contracts\math\SafeMath.sol
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109 
110   /**
111   * @dev Multiplies two numbers, throws on overflow.
112   */
113   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
114     if (a == 0) {
115       return 0;
116     }
117     c = a * b;
118     assert(c / a == b);
119     return c;
120   }
121 
122   /**
123   * @dev Integer division of two numbers, truncating the quotient.
124   */
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     // uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return a / b;
130   }
131 
132   /**
133   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134   */
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   /**
141   * @dev Adds two numbers, throws on overflow.
142   */
143   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
144     c = a + b;
145     assert(c >= a);
146     return c;
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
239         return market[tokenId].price + (market[tokenId].price / 100 * marketMakerFee);
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
424 /**
425     @title Race contract - used for linking ethorse Race struct 
426     @dev This interface is losely based on ethorse race contract
427 */
428 contract EthorseRace {
429 
430     //Encapsulation of racing information 
431     struct chronus_info {
432         bool  betting_open; // boolean: check if betting is open
433         bool  race_start; //boolean: check if race has started
434         bool  race_end; //boolean: check if race has ended
435         bool  voided_bet; //boolean: check if race has been voided
436         uint32  starting_time; // timestamp of when the race starts
437         uint32  betting_duration;
438         uint32  race_duration; // duration of the race
439         uint32 voided_timestamp;
440     }
441 
442     address public owner;
443     
444     //Point to racing information
445     chronus_info public chronus;
446 
447     //Coin index mapping to flag - true if index is winner
448     mapping (bytes32 => bool) public winner_horse;
449     /*
450             // exposing the coin pool details for DApp
451     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
452         return (coinIndex[index].total, coinIndex[index].pre, coinIndex[index].post, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
453     }
454     */
455     // exposing the coin pool details for DApp
456     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint);
457 }
458 
459 /**
460     @title API contract - used to connect with Race contract and 
461         encapsulate race information for token inidices and winner
462         checking.
463 */
464 contract EthorseHelpers {
465 
466     /// @dev Convert all symbols to bytes array
467     bytes32[] public all_horses = [bytes32("BTC"),bytes32("ETH"),bytes32("LTC")];
468     mapping(address => bool) public legitRaces;
469     bool onlyLegit = false;
470 
471     /// @dev Used to add new symbol to the bytes array 
472     function _addHorse(bytes32 newHorse) internal {
473         all_horses.push(newHorse);
474     }
475 
476     function _addLegitRace(address newRace) internal
477     {
478         legitRaces[newRace] = true;
479         if(!onlyLegit)
480             onlyLegit = true;
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
496        
497         //make sure the race is legit (only if legit races list is filled)
498         if(onlyLegit)
499             require(legitRaces[raceAddress],"not legit race");
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
602     uint256 public claimingFee = 0.000 ether;
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
672         @dev Allows to add a race address for races validation
673         @param newAddress the race address
674     */
675     function addLegitRaceAddress(address newAddress) external
676     onlyOwner() {
677         _addLegitRace(newAddress);
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
734         bool res;
735         (res,winner) = _isWinnerOf(raceAddress, address(0));
736         require(winner != bytes32(0),"Winner is zero");
737         require(res,"can_claim return false");
738         //require(!exists(id)); should already be checked by mining function
739         uint256 id = _generate_special_horsey(raceAddress, msg.sender, winner);
740         emit Claimed(raceAddress, msg.sender, id);
741     }
742 
743     /**
744         @dev Allows a user to give a horsey a name or rename it
745             This function is payable and its cost is renamingCostsPerChar * length(newname)
746             Cant be called while paused
747             If called with too low balance, the modifier will throw
748             If called with too much balance, we try to return the remaining funds back
749             Upon completion we update all ceos balances, maybe not very efficient?
750         @param tokenId ID of the horsey to rename
751         @param newName The name to give to the horsey
752     */
753     function renameHorsey(uint256 tokenId, string newName) external 
754     whenNotPaused()
755     onlyOwnerOf(tokenId) 
756     costs(renamingCostsPerChar * bytes(newName).length)
757     payable {
758         uint256 renamingFee = renamingCostsPerChar * bytes(newName).length;
759         //Return over paid amount to sender if necessary
760         if(msg.value > renamingFee) //overpaid
761         {
762             msg.sender.transfer(msg.value.sub(renamingFee));
763         }
764         //store the new name
765         stables.storeName(tokenId,newName);
766         emit HorseyRenamed(tokenId,newName);
767     }
768 
769     /**
770         @dev Allows a user to burn a token he owns to get carrots
771             The mount of carrots given is equal to the horsey's feedingCounter upon burning
772             Cant be called on a horsey with a pending feeding
773             Cant be called while paused
774         @param tokenId ID of the token to burn
775     */
776     function freeForCarrots(uint256 tokenId) external 
777     whenNotPaused()
778     onlyOwnerOf(tokenId) {
779         require(pendingFeedings[msg.sender].horsey != tokenId,"");
780         //credit carrots
781         uint8 feedingCounter;
782         (,,feedingCounter,) = stables.horseys(tokenId);
783         stables.storeCarrotsCredit(msg.sender,stables.carrot_credits(msg.sender) + uint32(feedingCounter * carrotsMultiplier));
784         stables.unstoreHorsey(tokenId);
785         emit HorseyFreed(tokenId);
786     }
787 
788     /**
789         @dev Returns the amount of carrots the user owns
790             We have a getter to hide the carrots amount from public view
791         @return The current amount of carrot credits the sender owns 
792     */
793     function getCarrotCredits() external view returns (uint32) {
794         return stables.carrot_credits(msg.sender);
795     }
796 
797     /**
798         @dev Returns horsey data of a given token
799         @param tokenId ID of the horsey to fetch
800         @return (race address, dna, feedingCounter, name)
801     */
802     function getHorsey(uint256 tokenId) public view returns (address, bytes32, uint8, string) {
803         RoyalStablesInterface.Horsey memory temp;
804         (temp.race,temp.dna,temp.feedingCounter,temp.tier) = stables.horseys(tokenId);
805         return (temp.race,temp.dna,temp.feedingCounter,stables.names(tokenId));
806     }
807 
808     /**
809         @dev Allows to feed a horsey to increase its feedingCounter value
810             Gives a chance to get a rare trait
811             The amount of carrots required is the value of current feedingCounter
812             The carrots the user owns will be reduced accordingly upon success
813             Cant be called while paused
814         @param tokenId ID of the horsey to feed
815     */
816     function feed(uint256 tokenId) external 
817     whenNotPaused()
818     onlyOwnerOf(tokenId) 
819     carrotsMeetLevel(tokenId)
820     noFeedingInProgress()
821     {
822         pendingFeedings[msg.sender] = FeedingData(block.number,tokenId);
823         uint8 feedingCounter;
824         (,,feedingCounter,) = stables.horseys(tokenId);
825         stables.storeCarrotsCredit(msg.sender,stables.carrot_credits(msg.sender) - uint32(feedingCounter));
826         emit Feeding(tokenId);
827     }
828 
829     /**
830         @dev Allows user to stop feeding a horsey
831             This will trigger a random rarity chance
832     */
833     function stopFeeding() external
834     feedingInProgress() returns (bool) {
835         uint256 blockNumber = pendingFeedings[msg.sender].blockNumber;
836         uint256 tokenId = pendingFeedings[msg.sender].horsey;
837         //you cant feed and stop feeding from the same block!
838         require(block.number - blockNumber >= 1,"feeding and stop feeding are in same block");
839 
840         delete pendingFeedings[msg.sender];
841 
842         //solidity only gives you access to the previous 256 blocks
843         //deny and remove this obsolete feeding if we cant fetch its blocks hash
844         if(block.number - blockNumber > 255) {
845             //the feeding is outdated = failed
846             //the user can feed again but he lost his carrots
847             emit FeedingFailed(tokenId);
848             return false; 
849         }
850 
851         //token could have been transfered in the meantime to someone else
852         if(stables.ownerOf(tokenId) != msg.sender) {
853             //the feeding is failed because the token no longer belongs to this user = failed
854             //the user has lost his carrots
855             emit FeedingFailed(tokenId);
856             return false; 
857         }
858         
859         //call horsey generation with the claim block hash
860         _feed(tokenId, blockhash(blockNumber));
861         bytes32 dna;
862         (,dna,,) = stables.horseys(tokenId);
863         emit ReceivedCarrot(tokenId, dna);
864         return true;
865     }
866 
867     /// @dev Only ether sent explicitly through the donation() function is accepted
868     function() external payable {
869         revert("Not accepting donations");
870     }
871 
872     /**
873         @dev Internal function to increase a horsey's rarity
874             Uses a random value to assess if the feeding process increases rarity
875             The chances of having a rarity increase are based on the current feedingCounter
876         @param tokenId ID of the token to "feed"
877         @param blockHash Hash of the block where the feeding began
878     */
879     function _feed(uint256 tokenId, bytes32 blockHash) internal {
880         //Grab the upperbound for probability 100,100
881         uint8 tier;
882         uint8 feedingCounter;
883         (,,feedingCounter,tier) = stables.horseys(tokenId);
884         uint256 probabilityByRarity = 10 ** (uint256(tier).add(1));
885         uint256 randNum = uint256(keccak256(abi.encodePacked(tokenId, blockHash))) % probabilityByRarity;
886 
887         //Scale probability based on horsey's level
888         if(randNum <= (feedingCounter * rarityMultiplier)){
889             _increaseRarity(tokenId, blockHash);
890         }
891 
892         //Increment feedingCounter
893         //Maximum allowed is 255, which requires 32385 carrots, so we should never reach that
894         if(feedingCounter < 255) {
895             stables.modifyHorseyFeedingCounter(tokenId,feedingCounter+1);
896         }
897     }
898 
899     /// @dev creates a special token id based on the race and the coin index
900     function _makeSpecialId(address race, address sender, bytes32 coinIndex) internal pure returns (uint256) {
901         return uint256(keccak256(abi.encodePacked(race, sender, coinIndex)));
902     }
903 
904     /**
905         @dev Internal function to generate a SPECIAL horsey token
906             we then use the ERC721 inherited minting process
907             the dna is a bytes32 target for a keccak256. Not using blockhash
908             finaly, a bitmask zeros the first 2 bytes for rarity traits
909         @param race Address of the associated race
910         @param eth_address Address of the user to receive the token
911         @param coinIndex The index of the winning coin
912         @return ID of the token
913     */
914     function _generate_special_horsey(address race, address eth_address, bytes32 coinIndex) internal returns (uint256) {
915         uint256 id = _makeSpecialId(race, eth_address, coinIndex);
916         //generate dna
917         bytes32 dna = _shiftRight(keccak256(abi.encodePacked(race, coinIndex)),16);
918          //storeHorsey checks if the token exists before minting already, so we dont have to here
919         stables.storeHorsey(eth_address,id,race,dna,1,0);
920         return id;
921     }
922     
923     /**
924         @dev Internal function called to increase a horsey rarity
925             We generate a random zeros mask with a single 1 in the leading 16 bits
926         @param tokenId Id of the token to increase rarity of
927         @param blockHash hash of the block where the feeding began
928     */
929     function _increaseRarity(uint256 tokenId, bytes32 blockHash) private {
930         uint8 tier;
931         bytes32 dna;
932         (,dna,,tier) = stables.horseys(tokenId);
933         if(tier < 255)
934             stables.modifyHorseyTier(tokenId,tier+1);
935         uint256 random = uint256(keccak256(abi.encodePacked(tokenId, blockHash)));
936         //this creates a mask of 256 bits such as one of the first 16 bits will be 1
937         bytes32 rarityMask = _shiftLeft(bytes32(1), (random % 16 + 240));
938         bytes32 newdna = dna | rarityMask; //apply mask to add the random flag
939         stables.modifyHorseyDna(tokenId,newdna);
940     }
941 
942     /// @dev shifts a bytes32 left by n positions
943     function _shiftLeft(bytes32 data, uint n) internal pure returns (bytes32) {
944         return bytes32(uint256(data)*(2 ** n));
945     }
946 
947     /// @dev shifts a bytes32 right by n positions
948     function _shiftRight(bytes32 data, uint n) internal pure returns (bytes32) {
949         return bytes32(uint256(data)/(2 ** n));
950     }
951 
952     /// @dev Modifier to ensure user can afford a rehorse
953     modifier carrotsMeetLevel(uint256 tokenId){
954         uint256 feedingCounter;
955         (,,feedingCounter,) = stables.horseys(tokenId);
956         require(feedingCounter <= stables.carrot_credits(msg.sender),"Not enough carrots");
957         _;
958     }
959 
960     /// @dev insures the caller payed the required amount
961     modifier costs(uint256 amount) {
962         require(msg.value >= amount,"Not enough funds");
963         _;
964     }
965 
966     /// @dev requires the address to be non null
967     modifier validAddress(address addr) {
968         require(addr != address(0),"Address is zero");
969         _;
970     }
971 
972     /// @dev requires that the user isnt feeding a horsey already
973     modifier noFeedingInProgress() {
974         //if the key does not exit, then the default struct data is used where blockNumber is 0
975         require(pendingFeedings[msg.sender].blockNumber == 0,"Already feeding");
976         _;
977     }
978 
979     /// @dev requires that the user isnt feeding a horsey already
980     modifier feedingInProgress() {
981         //if the key does not exit, then the default struct data is used where blockNumber is 0
982         require(pendingFeedings[msg.sender].blockNumber != 0,"No pending feeding");
983         _;
984     }
985 
986     /// @dev requires that the user isnt feeding a horsey already
987     modifier onlyOwnerOf(uint256 tokenId) {
988         require(stables.ownerOf(tokenId) == msg.sender, "Caller is not owner of this token");
989         _;
990     }
991 }
992 
993 // File: contracts\HorseyPilot.sol
994 
995 /**
996     @title Adds rank management utilities and voting behavior
997     @dev Handles equities distribution and levels of access
998 
999     EXCHANGE FUNCTIONS IT CAN CALL
1000 
1001     setClaimingFee OK 5
1002     setMarketFees OK 1
1003     withdraw
1004 
1005     TOKEN FUNCTIONS IT CAN CALL
1006 
1007     setRenamingCosts OK 0
1008     addHorseIndex OK 3
1009     setCarrotsMultiplier 8
1010     setRarityMultiplier 9
1011     addLegitDevAddress 2
1012     withdraw
1013 
1014     PAUSING OK 4
1015 */
1016 
1017 contract HorseyPilot {
1018 
1019     /// @dev event that is fired when a new proposal is made
1020     event NewProposal(uint8 methodId, uint parameter, address proposer);
1021 
1022     /// @dev event that is fired when a proposal is accepted
1023     event ProposalPassed(uint8 methodId, uint parameter, address proposer);
1024 
1025     /// @dev minimum threshold that must be met in order to confirm
1026     /// a contract update
1027     uint8 constant votingThreshold = 2;
1028 
1029     /// @dev minimum amount of time a proposal can live
1030     /// after this time it can be forcefully invoked or killed by anyone
1031     uint256 constant proposalLife = 7 days;
1032 
1033     /// @dev amount of time until another proposal can be made
1034     /// we use this to eliminate proposal spamming
1035     uint256 constant proposalCooldown = 1 days;
1036 
1037     /// @dev used to reference the exact time the last proposal vetoed
1038     uint256 cooldownStart;
1039 
1040     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles.
1041     address public jokerAddress;
1042     address public knightAddress;
1043     address public paladinAddress;
1044 
1045     /// @dev List of all addresses allowed to vote
1046     address[3] public voters;
1047 
1048     /// @dev joker is the pool and gets the rest
1049     uint8 constant public knightEquity = 40;
1050     uint8 constant public paladinEquity = 10;
1051 
1052     /// @dev deployed exchange and token addresses
1053     address public exchangeAddress;
1054     address public tokenAddress;
1055 
1056     /// @dev Mapping to keep track of pending balance of contract owners
1057     mapping(address => uint) internal _cBalance;
1058 
1059     /// @dev Encapsulates information about a proposed update
1060     struct Proposal{
1061         address proposer;           /// @dev address of the CEO at the origin of this proposal
1062         uint256 timestamp;          /// @dev the time at which this propsal was made
1063         uint256 parameter;          /// @dev parameters associated with proposed method invocation
1064         uint8   methodId;           /// @dev id maps to function 0:rename horse, 1:change fees, 2:?    
1065         address[] yay;              /// @dev list of all addresses who voted     
1066         address[] nay;              /// @dev list of all addresses who voted against     
1067     }
1068 
1069     /// @dev the pending proposal
1070     Proposal public currentProposal;
1071 
1072     /// @dev true if the proposal is waiting for votes
1073     bool public proposalInProgress = false;
1074 
1075     /// @dev Value to keep track of avaible balance
1076     uint256 public toBeDistributed;
1077 
1078     /// @dev used to deploy contracts only once
1079     bool deployed = false;
1080 
1081     /**
1082         @param _jokerAddress joker
1083         @param _knightAddress knight
1084         @param _paladinAddress paladin
1085         @param _voters list of all allowed voting addresses
1086     */
1087     constructor(
1088     address _jokerAddress,
1089     address _knightAddress,
1090     address _paladinAddress,
1091     address[3] _voters
1092     ) public {
1093         jokerAddress = _jokerAddress;
1094         knightAddress = _knightAddress;
1095         paladinAddress = _paladinAddress;
1096 
1097         for(uint i = 0; i < 3; i++) {
1098             voters[i] = _voters[i];
1099         }
1100 
1101         //Set cooldown start to 1 day ago so that cooldown is irrelevant
1102         cooldownStart = block.timestamp - proposalCooldown;
1103     }
1104 
1105     /**
1106         @dev Used to deploy children contracts as a one shot call
1107     */
1108     function deployChildren(address stablesAddress) external {
1109         require(!deployed,"already deployed");
1110         // deploy token and exchange contracts
1111         exchangeAddress = new HorseyExchange();
1112         tokenAddress = new HorseyToken(stablesAddress);
1113 
1114         // the exchange requires horsey token address
1115         HorseyExchange(exchangeAddress).setStables(stablesAddress);
1116 
1117         deployed = true;
1118     }
1119 
1120     /**
1121         @dev Transfers joker ownership to a new address
1122         @param newJoker the new address
1123     */
1124     function transferJokerOwnership(address newJoker) external 
1125     validAddress(newJoker) {
1126         require(jokerAddress == msg.sender,"Not right role");
1127         _moveBalance(newJoker);
1128         jokerAddress = newJoker;
1129     }
1130 
1131     /**
1132         @dev Transfers knight ownership to a new address
1133         @param newKnight the new address
1134     */
1135     function transferKnightOwnership(address newKnight) external 
1136     validAddress(newKnight) {
1137         require(knightAddress == msg.sender,"Not right role");
1138         _moveBalance(newKnight);
1139         knightAddress = newKnight;
1140     }
1141 
1142     /**
1143         @dev Transfers paladin ownership to a new address
1144         @param newPaladin the new address
1145     */
1146     function transferPaladinOwnership(address newPaladin) external 
1147     validAddress(newPaladin) {
1148         require(paladinAddress == msg.sender,"Not right role");
1149         _moveBalance(newPaladin);
1150         paladinAddress = newPaladin;
1151     }
1152 
1153     /**
1154         @dev Allow CEO to withdraw from pending value always checks to update redist
1155             We ONLY redist when a user tries to withdraw so we are not redistributing
1156             on every payment
1157         @param destination The address to send the ether to
1158     */
1159     function withdrawCeo(address destination) external 
1160     onlyCLevelAccess()
1161     validAddress(destination) {
1162         //Check that pending balance can be redistributed - if so perform
1163         //this procedure
1164         if(toBeDistributed > 0){
1165             _updateDistribution();
1166         }
1167         
1168         //Grab the balance of this CEO 
1169         uint256 balance = _cBalance[msg.sender];
1170         
1171         //If we have non-zero balance, CEO may withdraw from pending amount
1172         if(balance > 0 && (address(this).balance >= balance)) {
1173             destination.transfer(balance); //throws on fail
1174             _cBalance[msg.sender] = 0;
1175         }
1176     }
1177 
1178     /// @dev acquire funds from owned contracts
1179     function syncFunds() external {
1180         uint256 prevBalance = address(this).balance;
1181         HorseyToken(tokenAddress).withdraw();
1182         HorseyExchange(exchangeAddress).withdraw();
1183         uint256 newBalance = address(this).balance;
1184         //add to
1185         toBeDistributed = toBeDistributed + (newBalance - prevBalance);
1186     }
1187 
1188     /// @dev allows a noble to access his holdings
1189     function getNobleBalance() external view
1190     onlyCLevelAccess() returns (uint256) {
1191         return _cBalance[msg.sender];
1192     }
1193 
1194     /**
1195         @dev Make a proposal and add to pending proposals
1196         @param methodId a string representing the function ie. 'renameHorsey()'
1197         @param parameter parameter to be used if invocation is approved
1198     */
1199     function makeProposal( uint8 methodId, uint256 parameter ) external
1200     onlyCLevelAccess()
1201     proposalAvailable()
1202     cooledDown()
1203     {
1204         currentProposal.timestamp = block.timestamp;
1205         currentProposal.parameter = parameter;
1206         currentProposal.methodId = methodId;
1207         currentProposal.proposer = msg.sender;
1208         delete currentProposal.yay;
1209         delete currentProposal.nay;
1210         proposalInProgress = true;
1211         
1212         emit NewProposal(methodId,parameter,msg.sender);
1213     }
1214 
1215     /**
1216         @dev Call to vote on a pending proposal
1217     */
1218     function voteOnProposal(bool voteFor) external 
1219     proposalPending()
1220     onlyVoters()
1221     notVoted() {
1222         //cant vote on expired!
1223         require((block.timestamp - currentProposal.timestamp) <= proposalLife);
1224         if(voteFor)
1225         {
1226             currentProposal.yay.push(msg.sender);
1227             //Proposal went through? invoke it
1228             if( currentProposal.yay.length >= votingThreshold )
1229             {
1230                 _doProposal();
1231                 proposalInProgress = false;
1232                 //no need to reset cooldown on successful proposal
1233                 return;
1234             }
1235 
1236         } else {
1237             currentProposal.nay.push(msg.sender);
1238             //Proposal failed?
1239             if( currentProposal.nay.length >= votingThreshold )
1240             {
1241                 proposalInProgress = false;
1242                 cooldownStart = block.timestamp;
1243                 return;
1244             }
1245         }
1246     }
1247 
1248     /**
1249         @dev Helps moving pending balance from one role to another
1250         @param newAddress the address to transfer the pending balance from the msg.sender account
1251     */
1252     function _moveBalance(address newAddress) internal
1253     validAddress(newAddress) {
1254         require(newAddress != msg.sender); /// @dev IMPORTANT or else the account balance gets reset here!
1255         _cBalance[newAddress] = _cBalance[msg.sender];
1256         _cBalance[msg.sender] = 0;
1257     }
1258 
1259     /**
1260         @dev Called at the start of withdraw to distribute any pending balances that live in the contract
1261             will only ever be called if balance is non-zero (funds should be distributed)
1262     */
1263     function _updateDistribution() internal {
1264         require(toBeDistributed != 0,"nothing to distribute");
1265         uint256 knightPayday = toBeDistributed / 100 * knightEquity;
1266         uint256 paladinPayday = toBeDistributed / 100 * paladinEquity;
1267 
1268         /// @dev due to the equities distribution, queen gets the remaining value
1269         uint256 jokerPayday = toBeDistributed - knightPayday - paladinPayday;
1270 
1271         _cBalance[jokerAddress] = _cBalance[jokerAddress] + jokerPayday;
1272         _cBalance[knightAddress] = _cBalance[knightAddress] + knightPayday;
1273         _cBalance[paladinAddress] = _cBalance[paladinAddress] + paladinPayday;
1274         //Reset balance to 0
1275         toBeDistributed = 0;
1276     }
1277 
1278     /**
1279         @dev Execute the proposal
1280     */
1281     function _doProposal() internal {
1282         /// UPDATE the renaming cost
1283         if( currentProposal.methodId == 0 ) HorseyToken(tokenAddress).setRenamingCosts(currentProposal.parameter);
1284         
1285         /// UPDATE the market fees
1286         if( currentProposal.methodId == 1 ) HorseyExchange(exchangeAddress).setMarketFees(currentProposal.parameter);
1287 
1288         /// UPDATE the legit dev addresses list
1289         if( currentProposal.methodId == 2 ) HorseyToken(tokenAddress).addLegitRaceAddress(address(currentProposal.parameter));
1290 
1291         /// ADD a horse index to exchange
1292         if( currentProposal.methodId == 3 ) HorseyToken(tokenAddress).addHorseIndex(bytes32(currentProposal.parameter));
1293 
1294         /// PAUSE/UNPAUSE the dApp
1295         if( currentProposal.methodId == 4 ) {
1296             if(currentProposal.parameter == 0) {
1297                 HorseyExchange(exchangeAddress).unpause();
1298                 HorseyToken(tokenAddress).unpause();
1299             } else {
1300                 HorseyExchange(exchangeAddress).pause();
1301                 HorseyToken(tokenAddress).pause();
1302             }
1303         }
1304 
1305         /// UPDATE the claiming fees
1306         if( currentProposal.methodId == 5 ) HorseyToken(tokenAddress).setClaimingCosts(currentProposal.parameter);
1307 
1308         /// UPDATE carrots multiplier
1309         if( currentProposal.methodId == 8 ){
1310             HorseyToken(tokenAddress).setCarrotsMultiplier(uint8(currentProposal.parameter));
1311         }
1312 
1313         /// UPDATE rarity multiplier
1314         if( currentProposal.methodId == 9 ){
1315             HorseyToken(tokenAddress).setRarityMultiplier(uint8(currentProposal.parameter));
1316         }
1317 
1318         emit ProposalPassed(currentProposal.methodId,currentProposal.parameter,currentProposal.proposer);
1319     }
1320 
1321     /// @dev requires the address to be non null
1322     modifier validAddress(address addr) {
1323         require(addr != address(0),"Address is zero");
1324         _;
1325     }
1326 
1327     /// @dev requires the sender to be on the contract owners list
1328     modifier onlyCLevelAccess() {
1329         require((jokerAddress == msg.sender) || (knightAddress == msg.sender) || (paladinAddress == msg.sender),"not c level");
1330         _;
1331     }
1332 
1333     /// @dev requires that a proposal is not in process or has exceeded its lifetime, and has cooled down
1334     /// after being vetoed
1335     modifier proposalAvailable(){
1336         require(((!proposalInProgress) || ((block.timestamp - currentProposal.timestamp) > proposalLife)),"proposal already pending");
1337         _;
1338     }
1339 
1340     // @dev requries that if this proposer was the last proposer, that he or she has reached the 
1341     // cooldown limit
1342     modifier cooledDown( ){
1343         if(msg.sender == currentProposal.proposer && (block.timestamp - cooldownStart < 1 days)){
1344             revert("Cool down period not passed yet");
1345         }
1346         _;
1347     }
1348 
1349     /// @dev requires a proposal to be active
1350     modifier proposalPending() {
1351         require(proposalInProgress,"no proposal pending");
1352         _;
1353     }
1354 
1355     /// @dev requires the voter to not have voted already
1356     modifier notVoted() {
1357         uint256 length = currentProposal.yay.length;
1358         for(uint i = 0; i < length; i++) {
1359             if(currentProposal.yay[i] == msg.sender) {
1360                 revert("Already voted");
1361             }
1362         }
1363 
1364         length = currentProposal.nay.length;
1365         for(i = 0; i < length; i++) {
1366             if(currentProposal.nay[i] == msg.sender) {
1367                 revert("Already voted");
1368             }
1369         }
1370         _;
1371     }
1372 
1373     /// @dev requires the voter to not have voted already
1374     modifier onlyVoters() {
1375         bool found = false;
1376         uint256 length = voters.length;
1377         for(uint i = 0; i < length; i++) {
1378             if(voters[i] == msg.sender) {
1379                 found = true;
1380                 break;
1381             }
1382         }
1383         if(!found) {
1384             revert("not a voter");
1385         }
1386         _;
1387     }
1388 }