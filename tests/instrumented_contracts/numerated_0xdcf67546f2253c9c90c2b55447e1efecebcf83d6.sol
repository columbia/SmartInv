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
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: ..\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Receiver.sol
114 
115 /**
116  * @title ERC721 token receiver interface
117  * @dev Interface for any contract that wants to support safeTransfers
118  * from ERC721 asset contracts.
119  */
120 contract ERC721Receiver {
121   /**
122    * @dev Magic value to be returned upon successful reception of an NFT
123    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
124    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
125    */
126   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
127 
128   /**
129    * @notice Handle the receipt of an NFT
130    * @dev The ERC721 smart contract calls this function on the recipient
131    * after a `safetransfer`. This function MAY throw to revert and reject the
132    * transfer. Return of other than the magic value MUST result in the
133    * transaction being reverted.
134    * Note: the contract address is always the message sender.
135    * @param _operator The address which called `safeTransferFrom` function
136    * @param _from The address which previously owned the token
137    * @param _tokenId The NFT identifier which is being transferred
138    * @param _data Additional data with no specified format
139    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
140    */
141   function onERC721Received(
142     address _operator,
143     address _from,
144     uint256 _tokenId,
145     bytes _data
146   )
147     public
148     returns(bytes4);
149 }
150 
151 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Holder.sol
152 
153 contract ERC721Holder is ERC721Receiver {
154   function onERC721Received(
155     address,
156     address,
157     uint256,
158     bytes
159   )
160     public
161     returns(bytes4)
162   {
163     return ERC721_RECEIVED;
164   }
165 }
166 
167 // File: contracts\HorseyExchange.sol
168 
169 /**
170  * @title ERC721 Non-Fungible Token Standard basic interface
171  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
172  */
173 contract ERC721Basic {
174     function balanceOf(address _owner) public view returns (uint256 _balance);
175     function ownerOf(uint256 _tokenId) public view returns (address _owner);
176     function exists(uint256 _tokenId) public view returns (bool _exists);
177 
178     function approve(address _to, uint256 _tokenId) public;
179     function getApproved(uint256 _tokenId) public view returns (address _operator);
180 
181     function transferFrom(address _from, address _to, uint256 _tokenId) public;
182 }
183 
184 /**
185     @dev HorseyExchange contract - handles horsey market exchange which
186     includes the following set of functions:
187     1. Deposit to Exchange
188     2. Cancel sale
189     3. Purchase token
190 **/
191 contract HorseyExchange is Pausable, ERC721Holder { //also Ownable
192 
193     event HorseyDeposit(uint256 tokenId, uint256 price);
194     event SaleCanceled(uint256 tokenId);
195     event HorseyPurchased(uint256 tokenId, address newOwner, uint256 totalToPay);
196 
197     /// @dev Fee applied to market maker - measured as percentage
198     uint256 public marketMakerFee = 3;
199 
200     /// @dev Amount collected in fees
201     uint256 collectedFees = 0;
202 
203     /// @dev  RoyalStables TOKEN
204     ERC721Basic public token;
205 
206     /**
207         @dev used to store the price and the owner address of a token on sale
208     */
209     struct SaleData {
210         uint256 price;
211         address owner;
212     }
213 
214     /// @dev Market spec to lookup price and original owner based on token id
215     mapping (uint256 => SaleData) market;
216 
217     /// @dev mapping of current tokens on market by owner
218     mapping (address => uint256[]) userBarn;
219 
220     /// @dev initialize
221     constructor() Pausable() ERC721Holder() public {
222     }
223 
224     /**
225         @dev Since the exchange requires the horsey contract and horsey contract
226             requires exchange address, we cant initialize both of them in constructors
227         @param _token Address of the stables contract
228     */
229     function setStables(address _token) external
230     onlyOwner()
231     {
232         require(address(_token) != 0,"Address of token is zero");
233         token = ERC721Basic(_token);
234     }
235 
236     /**
237         @dev Allows the owner to change market fees
238         @param fees The new fees to apply (can be zero)
239     */
240     function setMarketFees(uint256 fees) external
241     onlyOwner()
242     {
243         marketMakerFee = fees;
244     }
245 
246     /// @return the tokens on sale based on the user address
247     function getTokensOnSale(address user) external view returns(uint256[]) {
248         return userBarn[user];
249     }
250 
251     /// @return the token price with the fees
252     function getTokenPrice(uint256 tokenId) public view
253     isOnMarket(tokenId) returns (uint256) {
254         return market[tokenId].price + (market[tokenId].price / 100 * marketMakerFee);
255     }
256 
257     /**
258         @dev User sends token to sell to exchange - at this point the exchange contract takes
259             ownership, but will map token ownership back to owner for auotmated withdraw on
260             cancel - requires that user is the rightful owner and is not
261             asking for a null price
262     */
263     function depositToExchange(uint256 tokenId, uint256 price) external
264     whenNotPaused()
265     isTokenOwner(tokenId)
266     nonZeroPrice(price)
267     tokenAvailable() {
268         require(token.getApproved(tokenId) == address(this),"Exchange is not allowed to transfer");
269         //Transfers token from depositee to exchange (contract address)
270         token.transferFrom(msg.sender, address(this), tokenId);
271         
272         //add the token to the market
273         market[tokenId] = SaleData(price,msg.sender);
274 
275         //Add token to exchange map - tracking by owner of all tokens
276         userBarn[msg.sender].push(tokenId);
277 
278         emit HorseyDeposit(tokenId, price);
279     }
280 
281     /**
282         @dev Allows true owner of token to cancel sale at anytime
283         @param tokenId ID of the token to remove from the market
284         @return true if user still has tokens for sale
285     */
286     function cancelSale(uint256 tokenId) external 
287     whenNotPaused()
288     originalOwnerOf(tokenId) 
289     tokenAvailable() returns (bool) {
290         //throws on fail - transfers token from exchange back to original owner
291         token.transferFrom(address(this),msg.sender,tokenId);
292         
293         //Reset token on market - remove
294         delete market[tokenId];
295 
296         //Reset barn tracker for user
297         _removeTokenFromBarn(tokenId, msg.sender);
298 
299         emit SaleCanceled(tokenId);
300 
301         //Return true if this user is still 'active' within the exchange
302         //This will help with client side actions
303         return userBarn[msg.sender].length > 0;
304     }
305 
306     /**
307         @dev Performs the purchase of a token that is present on the market - this includes checking that the
308             proper amount is sent + appliced fee, updating seller's balance, updated collected fees and
309             transfering token to buyer
310             Only market tokens can be purchased
311         @param tokenId ID of the token we wish to purchase
312     */
313     function purchaseToken(uint256 tokenId) external payable 
314     whenNotPaused()
315     isOnMarket(tokenId) 
316     tokenAvailable()
317     notOriginalOwnerOf(tokenId)
318     {
319         //Did the sender accidently pay over? - if so track the amount over
320         uint256 totalToPay = getTokenPrice(tokenId);
321         require(msg.value >= totalToPay, "Not paying enough");
322 
323         //fetch this tokens sale data
324         SaleData memory sale = market[tokenId];
325 
326         //Add to collected fee amount payable to DEVS
327         collectedFees += totalToPay - sale.price;
328 
329         //pay the seller
330         sale.owner.transfer(sale.price);
331 
332         //Reset barn tracker for user
333         _removeTokenFromBarn(tokenId,  sale.owner);
334 
335         //Reset token on market - remove
336         delete market[tokenId];
337 
338         //Transfer the ERC721 to the buyer - we leave the sale amount
339         //to be withdrawn by the user (transferred from exchange)
340         token.transferFrom(address(this), msg.sender, tokenId);
341 
342         //Return over paid amount to sender if necessary
343         if(msg.value > totalToPay) //overpaid
344         {
345             msg.sender.transfer(msg.value - totalToPay);
346         }
347 
348         emit HorseyPurchased(tokenId, msg.sender, totalToPay);
349     }
350 
351     /// @dev Transfers the collected fees to the owner
352     function withdraw() external
353     onlyOwner()
354     {
355         assert(collectedFees <= address(this).balance);
356         owner.transfer(collectedFees);
357         collectedFees = 0;
358     }
359 
360     /**
361         @dev Internal function to remove a token from the users barn array
362         @param tokenId ID of the token to remove
363         @param barnAddress Address of the user selling tokens
364     */
365     function _removeTokenFromBarn(uint tokenId, address barnAddress)  internal {
366         uint256[] storage barnArray = userBarn[barnAddress];
367         require(barnArray.length > 0,"No tokens to remove");
368         int index = _indexOf(tokenId, barnArray);
369         require(index >= 0, "Token not found in barn");
370 
371         // Shift entire array :(
372         for (uint256 i = uint256(index); i<barnArray.length-1; i++){
373             barnArray[i] = barnArray[i+1];
374         }
375 
376         // Remove element, update length, return array
377         // this should be enough since https://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array
378         barnArray.length--;
379     }
380 
381     /**
382         @dev Helper function which stores in memory an array which is passed in, and
383         @param item element we are looking for
384         @param array the array to look into
385         @return the index of the item of interest
386     */
387     function _indexOf(uint item, uint256[] memory array) internal pure returns (int256){
388 
389         //Iterate over array to find indexOf(token)
390         for(uint256 i = 0; i < array.length; i++){
391             if(array[i] == item){
392                 return int256(i);
393             }
394         }
395 
396         //Item not found
397         return -1;
398     }
399 
400     /// @dev requires token to be on the market = current owner is exchange
401     modifier isOnMarket(uint256 tokenId) {
402         require(token.ownerOf(tokenId) == address(this),"Token not on market");
403         _;
404     }
405     
406     /// @dev Is the user the owner of this token?
407     modifier isTokenOwner(uint256 tokenId) {
408         require(token.ownerOf(tokenId) == msg.sender,"Not tokens owner");
409         _;
410     }
411 
412     /// @dev Is this the original owner of the token - at exchange level
413     modifier originalOwnerOf(uint256 tokenId) {
414         require(market[tokenId].owner == msg.sender,"Not the original owner of");
415         _;
416     }
417 
418     /// @dev Is this the original owner of the token - at exchange level
419     modifier notOriginalOwnerOf(uint256 tokenId) {
420         require(market[tokenId].owner != msg.sender,"Is the original owner");
421         _;
422     }
423 
424     /// @dev Is a nonzero price being sent?
425     modifier nonZeroPrice(uint256 price){
426         require(price > 0,"Price is zero");
427         _;
428     }
429 
430     /// @dev Do we have a token address
431     modifier tokenAvailable(){
432         require(address(token) != 0,"Token address not set");
433         _;
434     }
435 }
436 
437 // File: contracts\EthorseHelpers.sol
438 
439 /**
440     @title Race contract - used for linking ethorse Race struct 
441     @dev This interface is losely based on ethorse race contract
442 */
443 contract EthorseRace {
444 
445     //Encapsulation of racing information 
446     struct chronus_info {
447         bool  betting_open; // boolean: check if betting is open
448         bool  race_start; //boolean: check if race has started
449         bool  race_end; //boolean: check if race has ended
450         bool  voided_bet; //boolean: check if race has been voided
451         uint32  starting_time; // timestamp of when the race starts
452         uint32  betting_duration;
453         uint32  race_duration; // duration of the race
454         uint32 voided_timestamp;
455     }
456 
457     address public owner;
458     
459     //Point to racing information
460     chronus_info public chronus;
461 
462     //Coin index mapping to flag - true if index is winner
463     mapping (bytes32 => bool) public winner_horse;
464     /*
465             // exposing the coin pool details for DApp
466     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
467         return (coinIndex[index].total, coinIndex[index].pre, coinIndex[index].post, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
468     }
469     */
470     // exposing the coin pool details for DApp
471     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint);
472 }
473 
474 /**
475     @title API contract - used to connect with Race contract and 
476         encapsulate race information for token inidices and winner
477         checking.
478 */
479 contract EthorseHelpers {
480 
481     /// @dev Convert all symbols to bytes array
482     bytes32[] public all_horses = [bytes32("BTC"),bytes32("ETH"),bytes32("LTC")];
483     mapping(address => bool) public legitRaces;
484     bool onlyLegit = false;
485 
486     /// @dev Used to add new symbol to the bytes array 
487     function _addHorse(bytes32 newHorse) internal {
488         all_horses.push(newHorse);
489     }
490 
491     function _addLegitRace(address newRace) internal
492     {
493         legitRaces[newRace] = true;
494         if(!onlyLegit)
495             onlyLegit = true;
496     }
497 
498     function getall_horsesCount() public view returns(uint) {
499         return all_horses.length;
500     }
501 
502     /**
503         @param raceAddress - address of this race
504         @param eth_address - user's ethereum wallet address
505         @return true if user is winner + name of the winning horse (LTC,BTC,ETH,...)
506     */
507     function _isWinnerOf(address raceAddress, address eth_address) internal view returns (bool,bytes32)
508     {
509         //acquire race, fails if doesnt exist
510         EthorseRace race = EthorseRace(raceAddress);
511        
512         //make sure the race is legit (only if legit races list is filled)
513         if(onlyLegit)
514             require(legitRaces[raceAddress],"not legit race");
515         //acquire chronus
516         bool  voided_bet; //boolean: check if race has been voided
517         bool  race_end; //boolean: check if race has ended
518         (,,race_end,voided_bet,,,,) = race.chronus();
519 
520         //cant be winner if race was refunded or didnt end yet
521         if(voided_bet || !race_end)
522             return (false,bytes32(0));
523 
524         //aquire winner race index
525         bytes32 horse;
526         bool found = false;
527         uint256 arrayLength = all_horses.length;
528 
529         //Iterate over coin symbols to find winner - tie could be possible?
530         for(uint256 i = 0; i < arrayLength; i++)
531         {
532             if(race.winner_horse(all_horses[i])) {
533                 horse = all_horses[i];
534                 found = true;
535                 break;
536             }
537         }
538         //no winner horse? shouldnt happen unless this horse isnt registered
539         if(!found)
540             return (false,bytes32(0));
541 
542         //check the bet amount of the eth_address on the winner horse
543         uint256 bet_amount = 0;
544         (,,,, bet_amount) = race.getCoinIndex(horse, eth_address);
545         
546         //winner if the eth_address had a bet > 0 on the winner horse
547         return (bet_amount > 0, horse);
548     }
549 }
550 
551 // File: contracts\HorseyToken.sol
552 
553 contract RoyalStablesInterface {
554     
555     struct Horsey {
556         address race;
557         bytes32 dna;
558         uint8 feedingCounter;
559         uint8 tier;
560     }
561 
562     mapping(uint256 => Horsey) public horseys;
563     mapping(address => uint32) public carrot_credits;
564     mapping(uint256 => string) public names;
565     address public master;
566 
567     function getOwnedTokens(address eth_address) public view returns (uint256[]);
568     function storeName(uint256 tokenId, string newName) public;
569     function storeCarrotsCredit(address client, uint32 amount) public;
570     function storeHorsey(address client, uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public;
571     function modifyHorsey(uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public;
572     function modifyHorseyDna(uint256 tokenId, bytes32 dna) public;
573     function modifyHorseyFeedingCounter(uint256 tokenId, uint8 feedingCounter) public;
574     function modifyHorseyTier(uint256 tokenId, uint8 tier) public;
575     function unstoreHorsey(uint256 tokenId) public;
576     function ownerOf(uint256 tokenId) public returns (address);
577 }
578 
579 /**
580     @title HorseyToken ERC721 Token
581     @dev Horse contract - horse derives fro AccessManager built on top of ERC721 token and uses 
582     @dev EthorseHelpers and AccessManager
583 */
584 contract HorseyToken is EthorseHelpers,Pausable {
585 
586     /// @dev called when someone claims a token
587     event Claimed(address raceAddress, address eth_address, uint256 tokenId);
588     
589     /// @dev called when someone starts a feeding process
590     event Feeding(uint256 tokenId);
591 
592     /// @dev called when someone ends a feeding process
593     event ReceivedCarrot(uint256 tokenId, bytes32 newDna);
594 
595     /// @dev called when someone fails to end a feeding on the 255 blocks timer
596     event FeedingFailed(uint256 tokenId);
597 
598     /// @dev called when a horsey is renamed
599     event HorseyRenamed(uint256 tokenId, string newName);
600 
601     /// @dev called when a horsey is freed for carrots
602     event HorseyFreed(uint256 tokenId);
603 
604     /// @dev address of the RoyalStables
605     RoyalStablesInterface public stables;
606 
607     ///@dev multiplier applied to carrots received from burning a horsey
608     uint8 public carrotsMultiplier = 1;
609 
610     ///@dev multiplier applied to rarity bounds when feeding horsey
611     uint8 public rarityMultiplier = 1;
612 
613     ///@dev fee to pay when claiming a token
614     uint256 public claimingFee = 0.000 ether;
615 
616     /**
617         @dev Holds the necessary data to feed a horsey
618             The user has to create begin feeding and wait for the block
619             with the feeding transaction to be hashed
620             Only then he can stop the feeding
621     */
622     struct FeedingData {
623         uint256 blockNumber;    ///@dev Holds the block number where the feeding began
624         uint256 horsey;         ///@dev Holds the horsey id
625     }
626 
627     /// @dev Maps a user to his pending feeding
628     mapping(address => FeedingData) public pendingFeedings;
629 
630     /// @dev Stores the renaming fees per character a user has to pay upon renaming a horsey
631     uint256 public renamingCostsPerChar = 0.001 ether;
632 
633     /**
634         @dev Contracts constructor
635             Initializes token data
636             is pausable,ownable
637         @param stablesAddress Address of the official RoyalStables contract
638     */
639     constructor(address stablesAddress) 
640     EthorseHelpers() 
641     Pausable() public {
642         stables = RoyalStablesInterface(stablesAddress);
643     }
644 
645     /**
646         @dev Changes multiplier for rarity on feed
647         @param newRarityMultiplier The cost to charge in wei for each character of the name
648     */
649     function setRarityMultiplier(uint8 newRarityMultiplier) external 
650     onlyOwner()  {
651         rarityMultiplier = newRarityMultiplier;
652     }
653 
654     /**
655         @dev Sets a new muliplier for freeing a horse
656         @param newCarrotsMultiplier the new multiplier for feeding
657     */
658     function setCarrotsMultiplier(uint8 newCarrotsMultiplier) external 
659     onlyOwner()  {
660         carrotsMultiplier = newCarrotsMultiplier;
661     }
662 
663     /**
664         @dev Sets a new renaming per character cost in wei
665             Any CLevel can call this function
666         @param newRenamingCost The cost to charge in wei for each character of the name
667     */
668     function setRenamingCosts(uint256 newRenamingCost) external 
669     onlyOwner()  {
670         renamingCostsPerChar = newRenamingCost;
671     }
672 
673     /**
674         @dev Sets a new claiming fee in wei
675             Any CLevel can call this function
676         @param newClaimingFee The cost to charge in wei for each claimed HRSY
677     */
678     function setClaimingCosts(uint256 newClaimingFee) external
679     onlyOwner()  {
680         claimingFee = newClaimingFee;
681     }
682 
683     /**
684         @dev Allows to add a race address for races validation
685         @param newAddress the race address
686     */
687     function addLegitRaceAddress(address newAddress) external
688     onlyOwner() {
689         _addLegitRace(newAddress);
690     }
691 
692     /**
693         @dev Owner can withdraw the current balance
694     */
695     function withdraw() external 
696     onlyOwner()  {
697         owner.transfer(address(this).balance); //throws on fail
698     }
699 
700     //allows owner to add a horse name to the possible horses list (BTC,ETH,LTC,...)
701     /**
702         @dev Adds a new horse index to the possible horses list (BTC,ETH,LTC,...)
703             This is in case ethorse adds a new coin
704             Any CLevel can call this function
705         @param newHorse Index of the horse to add (same data type as the original ethorse erc20 contract code)
706     */
707     function addHorseIndex(bytes32 newHorse) external
708     onlyOwner() {
709         _addHorse(newHorse);
710     }
711 
712     /**
713         @dev Gets the complete list of token ids which belongs to an address
714         @param eth_address The address you want to lookup owned tokens from
715         @return List of all owned by eth_address tokenIds
716     */
717     function getOwnedTokens(address eth_address) public view returns (uint256[]) {
718         return stables.getOwnedTokens(eth_address);
719     }
720     
721     /**
722         @dev Allows to check if an eth_address can claim a horsey from this contract
723             should we also check if already claimed here?
724         @param raceAddress The ethorse race you want to claim from
725         @param eth_address The users address you want to claim the token for
726         @return True only if eth_address is a winner of the race contract at raceAddress
727     */
728     function can_claim(address raceAddress, address eth_address) public view returns (bool) {
729         bool res;
730         (res,) = _isWinnerOf(raceAddress, eth_address);
731         return res;
732     }
733 
734     /**
735         @dev Allows a user to claim a special horsey with the same dna as the race one
736             Cant be used on paused
737             The sender has to be a winner of the race and must never have claimed a special horsey from this race
738         @param raceAddress The race's address
739     */
740     function claim(address raceAddress) external payable
741     costs(claimingFee)
742     whenNotPaused()
743     {
744         //call _isWinnerOf with a 0 address to simply get the winner horse
745         bytes32 winner;
746         bool res;
747         (res,winner) = _isWinnerOf(raceAddress, msg.sender);
748         require(winner != bytes32(0),"Winner is zero");
749         require(res,"can_claim return false");
750         //require(!exists(id)); should already be checked by mining function
751         uint256 id = _generate_special_horsey(raceAddress, msg.sender, winner);
752         emit Claimed(raceAddress, msg.sender, id);
753     }
754 
755     /**
756         @dev Allows a user to give a horsey a name or rename it
757             This function is payable and its cost is renamingCostsPerChar * length(newname)
758             Cant be called while paused
759             If called with too low balance, the modifier will throw
760             If called with too much balance, we try to return the remaining funds back
761             Upon completion we update all ceos balances, maybe not very efficient?
762         @param tokenId ID of the horsey to rename
763         @param newName The name to give to the horsey
764     */
765     function renameHorsey(uint256 tokenId, string newName) external 
766     whenNotPaused()
767     onlyOwnerOf(tokenId) 
768     costs(renamingCostsPerChar * bytes(newName).length)
769     payable {
770         uint256 renamingFee = renamingCostsPerChar * bytes(newName).length;
771         //Return over paid amount to sender if necessary
772         if(msg.value > renamingFee) //overpaid
773         {
774             msg.sender.transfer(msg.value - renamingFee);
775         }
776         //store the new name
777         stables.storeName(tokenId,newName);
778         emit HorseyRenamed(tokenId,newName);
779     }
780 
781     /**
782         @dev Allows a user to burn a token he owns to get carrots
783             The mount of carrots given is equal to the horsey's feedingCounter upon burning
784             Cant be called on a horsey with a pending feeding
785             Cant be called while paused
786         @param tokenId ID of the token to burn
787     */
788     function freeForCarrots(uint256 tokenId) external 
789     whenNotPaused()
790     onlyOwnerOf(tokenId) {
791         require(pendingFeedings[msg.sender].horsey != tokenId,"");
792         //credit carrots
793         uint8 feedingCounter;
794         (,,feedingCounter,) = stables.horseys(tokenId);
795         stables.storeCarrotsCredit(msg.sender,stables.carrot_credits(msg.sender) + uint32(feedingCounter * carrotsMultiplier));
796         stables.unstoreHorsey(tokenId);
797         emit HorseyFreed(tokenId);
798     }
799 
800     /**
801         @dev Returns the amount of carrots the user owns
802             We have a getter to hide the carrots amount from public view
803         @return The current amount of carrot credits the sender owns 
804     */
805     function getCarrotCredits() external view returns (uint32) {
806         return stables.carrot_credits(msg.sender);
807     }
808 
809     /**
810         @dev Returns horsey data of a given token
811         @param tokenId ID of the horsey to fetch
812         @return (race address, dna, feedingCounter, name)
813     */
814     function getHorsey(uint256 tokenId) public view returns (address, bytes32, uint8, string) {
815         RoyalStablesInterface.Horsey memory temp;
816         (temp.race,temp.dna,temp.feedingCounter,temp.tier) = stables.horseys(tokenId);
817         return (temp.race,temp.dna,temp.feedingCounter,stables.names(tokenId));
818     }
819 
820     /**
821         @dev Allows to feed a horsey to increase its feedingCounter value
822             Gives a chance to get a rare trait
823             The amount of carrots required is the value of current feedingCounter
824             The carrots the user owns will be reduced accordingly upon success
825             Cant be called while paused
826         @param tokenId ID of the horsey to feed
827     */
828     function feed(uint256 tokenId) external 
829     whenNotPaused()
830     onlyOwnerOf(tokenId) 
831     carrotsMeetLevel(tokenId)
832     noFeedingInProgress()
833     {
834         pendingFeedings[msg.sender] = FeedingData(block.number,tokenId);
835         uint8 feedingCounter;
836         (,,feedingCounter,) = stables.horseys(tokenId);
837         stables.storeCarrotsCredit(msg.sender,stables.carrot_credits(msg.sender) - uint32(feedingCounter));
838         emit Feeding(tokenId);
839     }
840 
841     /**
842         @dev Allows user to stop feeding a horsey
843             This will trigger a random rarity chance
844     */
845     function stopFeeding() external
846     feedingInProgress() returns (bool) {
847         uint256 blockNumber = pendingFeedings[msg.sender].blockNumber;
848         uint256 tokenId = pendingFeedings[msg.sender].horsey;
849         //you cant feed and stop feeding from the same block!
850         require(block.number - blockNumber >= 1,"feeding and stop feeding are in same block");
851 
852         delete pendingFeedings[msg.sender];
853 
854         //solidity only gives you access to the previous 256 blocks
855         //deny and remove this obsolete feeding if we cant fetch its blocks hash
856         if(block.number - blockNumber > 255) {
857             //the feeding is outdated = failed
858             //the user can feed again but he lost his carrots
859             emit FeedingFailed(tokenId);
860             return false; 
861         }
862 
863         //token could have been transfered in the meantime to someone else
864         if(stables.ownerOf(tokenId) != msg.sender) {
865             //the feeding is failed because the token no longer belongs to this user = failed
866             //the user has lost his carrots
867             emit FeedingFailed(tokenId);
868             return false; 
869         }
870         
871         //call horsey generation with the claim block hash
872         _feed(tokenId, blockhash(blockNumber));
873         bytes32 dna;
874         (,dna,,) = stables.horseys(tokenId);
875         emit ReceivedCarrot(tokenId, dna);
876         return true;
877     }
878 
879     /// @dev Only ether sent explicitly through the donation() function is accepted
880     function() external payable {
881         revert("Not accepting donations");
882     }
883 
884     /**
885         @dev Internal function to increase a horsey's rarity
886             Uses a random value to assess if the feeding process increases rarity
887             The chances of having a rarity increase are based on the current feedingCounter
888         @param tokenId ID of the token to "feed"
889         @param blockHash Hash of the block where the feeding began
890     */
891     function _feed(uint256 tokenId, bytes32 blockHash) internal {
892         //Grab the upperbound for probability 100,100
893         uint8 tier;
894         uint8 feedingCounter;
895         (,,feedingCounter,tier) = stables.horseys(tokenId);
896         uint256 probabilityByRarity = 10 ** uint256(tier + 1);
897         uint256 randNum = uint256(keccak256(abi.encodePacked(tokenId, blockHash))) % probabilityByRarity;
898 
899         //Scale probability based on horsey's level
900         if(randNum <= (feedingCounter * rarityMultiplier)){
901             _increaseRarity(tokenId, blockHash);
902         }
903 
904         //Increment feedingCounter
905         //Maximum allowed is 255, which requires 32385 carrots, so we should never reach that
906         if(feedingCounter < 255) {
907             stables.modifyHorseyFeedingCounter(tokenId,feedingCounter+1);
908         }
909     }
910 
911     /// @dev creates a special token id based on the race and the coin index
912     function _makeSpecialId(address race, address sender, bytes32 coinIndex) internal pure returns (uint256) {
913         return uint256(keccak256(abi.encodePacked(race, sender, coinIndex)));
914     }
915 
916     /**
917         @dev Internal function to generate a SPECIAL horsey token
918             we then use the ERC721 inherited minting process
919             the dna is a bytes32 target for a keccak256. Not using blockhash
920             finaly, a bitmask zeros the first 2 bytes for rarity traits
921         @param race Address of the associated race
922         @param eth_address Address of the user to receive the token
923         @param coinIndex The index of the winning coin
924         @return ID of the token
925     */
926     function _generate_special_horsey(address race, address eth_address, bytes32 coinIndex) internal returns (uint256) {
927         uint256 id = _makeSpecialId(race, eth_address, coinIndex);
928         //generate dna
929         bytes32 dna = _shiftRight(keccak256(abi.encodePacked(race, coinIndex)),16);
930          //storeHorsey checks if the token exists before minting already, so we dont have to here
931         stables.storeHorsey(eth_address,id,race,dna,1,0);
932         return id;
933     }
934     
935     /**
936         @dev Internal function called to increase a horsey rarity
937             We generate a random zeros mask with a single 1 in the leading 16 bits
938         @param tokenId Id of the token to increase rarity of
939         @param blockHash hash of the block where the feeding began
940     */
941     function _increaseRarity(uint256 tokenId, bytes32 blockHash) private {
942         uint8 tier;
943         bytes32 dna;
944         (,dna,,tier) = stables.horseys(tokenId);
945         if(tier < 254)
946             stables.modifyHorseyTier(tokenId,tier+1);
947         uint256 random = uint256(keccak256(abi.encodePacked(tokenId, blockHash)));
948         //this creates a mask of 256 bits such as one of the first 16 bits will be 1
949         bytes32 rarityMask = _shiftLeft(bytes32(1), (random % 16 + 240));
950         bytes32 newdna = dna | rarityMask; //apply mask to add the random flag
951         stables.modifyHorseyDna(tokenId,newdna);
952     }
953 
954     /// @dev shifts a bytes32 left by n positions
955     function _shiftLeft(bytes32 data, uint n) internal pure returns (bytes32) {
956         return bytes32(uint256(data)*(2 ** n));
957     }
958 
959     /// @dev shifts a bytes32 right by n positions
960     function _shiftRight(bytes32 data, uint n) internal pure returns (bytes32) {
961         return bytes32(uint256(data)/(2 ** n));
962     }
963 
964     /// @dev Modifier to ensure user can afford a rehorse
965     modifier carrotsMeetLevel(uint256 tokenId){
966         uint256 feedingCounter;
967         (,,feedingCounter,) = stables.horseys(tokenId);
968         require(feedingCounter <= stables.carrot_credits(msg.sender),"Not enough carrots");
969         _;
970     }
971 
972     /// @dev insures the caller payed the required amount
973     modifier costs(uint256 amount) {
974         require(msg.value >= amount,"Not enough funds");
975         _;
976     }
977 
978     /// @dev requires the address to be non null
979     modifier validAddress(address addr) {
980         require(addr != address(0),"Address is zero");
981         _;
982     }
983 
984     /// @dev requires that the user isnt feeding a horsey already
985     modifier noFeedingInProgress() {
986         //if the key does not exit, then the default struct data is used where blockNumber is 0
987         require(pendingFeedings[msg.sender].blockNumber == 0,"Already feeding");
988         _;
989     }
990 
991     /// @dev requires that the user isnt feeding a horsey already
992     modifier feedingInProgress() {
993         //if the key does not exit, then the default struct data is used where blockNumber is 0
994         require(pendingFeedings[msg.sender].blockNumber != 0,"No pending feeding");
995         _;
996     }
997 
998     /// @dev requires that the user isnt feeding a horsey already
999     modifier onlyOwnerOf(uint256 tokenId) {
1000         require(stables.ownerOf(tokenId) == msg.sender, "Caller is not owner of this token");
1001         _;
1002     }
1003 }
1004 
1005 // File: contracts\HorseyPilot.sol
1006 
1007 /**
1008     @title Adds rank management utilities and voting behavior
1009     @dev Handles equities distribution and levels of access
1010 
1011     EXCHANGE FUNCTIONS IT CAN CALL
1012 
1013     setClaimingFee OK 5
1014     setMarketFees OK 1
1015     withdraw
1016 
1017     TOKEN FUNCTIONS IT CAN CALL
1018 
1019     setRenamingCosts OK 0
1020     addHorseIndex OK 3
1021     setCarrotsMultiplier 8
1022     setRarityMultiplier 9
1023     addLegitDevAddress 2
1024     withdraw
1025 
1026     PAUSING OK 4
1027 */
1028 
1029 contract HorseyPilot {
1030 
1031     /// @dev event that is fired when a new proposal is made
1032     event NewProposal(uint8 methodId, uint parameter, address proposer);
1033 
1034     /// @dev event that is fired when a proposal is accepted
1035     event ProposalPassed(uint8 methodId, uint parameter, address proposer);
1036 
1037     /// @dev minimum threshold that must be met in order to confirm
1038     /// a contract update
1039     uint8 constant votingThreshold = 2;
1040 
1041     /// @dev minimum amount of time a proposal can live
1042     /// after this time it can be forcefully invoked or killed by anyone
1043     uint256 constant proposalLife = 7 days;
1044 
1045     /// @dev amount of time until another proposal can be made
1046     /// we use this to eliminate proposal spamming
1047     uint256 constant proposalCooldown = 1 days;
1048 
1049     /// @dev used to reference the exact time the last proposal vetoed
1050     uint256 cooldownStart;
1051 
1052     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles.
1053     address public jokerAddress;
1054     address public knightAddress;
1055     address public paladinAddress;
1056 
1057     /// @dev List of all addresses allowed to vote
1058     address[3] public voters;
1059 
1060     /// @dev joker is the pool and gets the rest
1061     uint8 constant public knightEquity = 40;
1062     uint8 constant public paladinEquity = 10;
1063 
1064     /// @dev deployed exchange and token addresses
1065     address public exchangeAddress;
1066     address public tokenAddress;
1067 
1068     /// @dev Mapping to keep track of pending balance of contract owners
1069     mapping(address => uint) internal _cBalance;
1070 
1071     /// @dev Encapsulates information about a proposed update
1072     struct Proposal{
1073         address proposer;           /// @dev address of the CEO at the origin of this proposal
1074         uint256 timestamp;          /// @dev the time at which this propsal was made
1075         uint256 parameter;          /// @dev parameters associated with proposed method invocation
1076         uint8   methodId;           /// @dev id maps to function 0:rename horse, 1:change fees, 2:?    
1077         address[] yay;              /// @dev list of all addresses who voted     
1078         address[] nay;              /// @dev list of all addresses who voted against     
1079     }
1080 
1081     /// @dev the pending proposal
1082     Proposal public currentProposal;
1083 
1084     /// @dev true if the proposal is waiting for votes
1085     bool public proposalInProgress = false;
1086 
1087     /// @dev Value to keep track of avaible balance
1088     uint256 public toBeDistributed;
1089 
1090     /// @dev used to deploy contracts only once
1091     bool deployed = false;
1092 
1093     /**
1094         @param _jokerAddress joker
1095         @param _knightAddress knight
1096         @param _paladinAddress paladin
1097         @param _voters list of all allowed voting addresses
1098     */
1099     constructor(
1100     address _jokerAddress,
1101     address _knightAddress,
1102     address _paladinAddress,
1103     address[3] _voters
1104     ) public {
1105         jokerAddress = _jokerAddress;
1106         knightAddress = _knightAddress;
1107         paladinAddress = _paladinAddress;
1108 
1109         for(uint i = 0; i < 3; i++) {
1110             voters[i] = _voters[i];
1111         }
1112 
1113         //Set cooldown start to 1 day ago so that cooldown is irrelevant
1114         cooldownStart = block.timestamp - proposalCooldown;
1115     }
1116 
1117     /**
1118         @dev Used to deploy children contracts as a one shot call
1119     */
1120     function deployChildren(address stablesAddress) external {
1121         require(!deployed,"already deployed");
1122         // deploy token and exchange contracts
1123         exchangeAddress = new HorseyExchange();
1124         tokenAddress = new HorseyToken(stablesAddress);
1125 
1126         // the exchange requires horsey token address
1127         HorseyExchange(exchangeAddress).setStables(stablesAddress);
1128 
1129         deployed = true;
1130     }
1131 
1132     /**
1133         @dev Transfers joker ownership to a new address
1134         @param newJoker the new address
1135     */
1136     function transferJokerOwnership(address newJoker) external 
1137     validAddress(newJoker) {
1138         require(jokerAddress == msg.sender,"Not right role");
1139         _moveBalance(newJoker);
1140         jokerAddress = newJoker;
1141     }
1142 
1143     /**
1144         @dev Transfers knight ownership to a new address
1145         @param newKnight the new address
1146     */
1147     function transferKnightOwnership(address newKnight) external 
1148     validAddress(newKnight) {
1149         require(knightAddress == msg.sender,"Not right role");
1150         _moveBalance(newKnight);
1151         knightAddress = newKnight;
1152     }
1153 
1154     /**
1155         @dev Transfers paladin ownership to a new address
1156         @param newPaladin the new address
1157     */
1158     function transferPaladinOwnership(address newPaladin) external 
1159     validAddress(newPaladin) {
1160         require(paladinAddress == msg.sender,"Not right role");
1161         _moveBalance(newPaladin);
1162         paladinAddress = newPaladin;
1163     }
1164 
1165     /**
1166         @dev Allow CEO to withdraw from pending value always checks to update redist
1167             We ONLY redist when a user tries to withdraw so we are not redistributing
1168             on every payment
1169         @param destination The address to send the ether to
1170     */
1171     function withdrawCeo(address destination) external 
1172     onlyCLevelAccess()
1173     validAddress(destination) {
1174         //Check that pending balance can be redistributed - if so perform
1175         //this procedure
1176         if(toBeDistributed > 0){
1177             _updateDistribution();
1178         }
1179         
1180         //Grab the balance of this CEO 
1181         uint256 balance = _cBalance[msg.sender];
1182         
1183         //If we have non-zero balance, CEO may withdraw from pending amount
1184         if(balance > 0 && (address(this).balance >= balance)) {
1185             destination.transfer(balance); //throws on fail
1186             _cBalance[msg.sender] = 0;
1187         }
1188     }
1189 
1190     /// @dev acquire funds from owned contracts
1191     function syncFunds() external {
1192         uint256 prevBalance = address(this).balance;
1193         HorseyToken(tokenAddress).withdraw();
1194         HorseyExchange(exchangeAddress).withdraw();
1195         uint256 newBalance = address(this).balance;
1196         //add to
1197         toBeDistributed = toBeDistributed + (newBalance - prevBalance);
1198     }
1199 
1200     /// @dev allows a noble to access his holdings
1201     function getNobleBalance() external view
1202     onlyCLevelAccess() returns (uint256) {
1203         return _cBalance[msg.sender];
1204     }
1205 
1206     /**
1207         @dev Make a proposal and add to pending proposals
1208         @param methodId a string representing the function ie. 'renameHorsey()'
1209         @param parameter parameter to be used if invocation is approved
1210     */
1211     function makeProposal( uint8 methodId, uint256 parameter ) external
1212     onlyCLevelAccess()
1213     proposalAvailable()
1214     cooledDown()
1215     {
1216         currentProposal.timestamp = block.timestamp;
1217         currentProposal.parameter = parameter;
1218         currentProposal.methodId = methodId;
1219         currentProposal.proposer = msg.sender;
1220         delete currentProposal.yay;
1221         delete currentProposal.nay;
1222         proposalInProgress = true;
1223         
1224         emit NewProposal(methodId,parameter,msg.sender);
1225     }
1226 
1227     /**
1228         @dev Call to vote on a pending proposal
1229     */
1230     function voteOnProposal(bool voteFor) external 
1231     proposalPending()
1232     onlyVoters()
1233     notVoted() {
1234         //cant vote on expired!
1235         require((block.timestamp - currentProposal.timestamp) <= proposalLife);
1236         if(voteFor)
1237         {
1238             currentProposal.yay.push(msg.sender);
1239             //Proposal went through? invoke it
1240             if( currentProposal.yay.length >= votingThreshold )
1241             {
1242                 _doProposal();
1243                 proposalInProgress = false;
1244                 //no need to reset cooldown on successful proposal
1245                 return;
1246             }
1247 
1248         } else {
1249             currentProposal.nay.push(msg.sender);
1250             //Proposal failed?
1251             if( currentProposal.nay.length >= votingThreshold )
1252             {
1253                 proposalInProgress = false;
1254                 cooldownStart = block.timestamp;
1255                 return;
1256             }
1257         }
1258     }
1259 
1260     /**
1261         @dev Helps moving pending balance from one role to another
1262         @param newAddress the address to transfer the pending balance from the msg.sender account
1263     */
1264     function _moveBalance(address newAddress) internal
1265     validAddress(newAddress) {
1266         require(newAddress != msg.sender); /// @dev IMPORTANT or else the account balance gets reset here!
1267         _cBalance[newAddress] = _cBalance[msg.sender];
1268         _cBalance[msg.sender] = 0;
1269     }
1270 
1271     /**
1272         @dev Called at the start of withdraw to distribute any pending balances that live in the contract
1273             will only ever be called if balance is non-zero (funds should be distributed)
1274     */
1275     function _updateDistribution() internal {
1276         require(toBeDistributed != 0,"nothing to distribute");
1277         uint256 knightPayday = toBeDistributed / 100 * knightEquity;
1278         uint256 paladinPayday = toBeDistributed / 100 * paladinEquity;
1279 
1280         /// @dev due to the equities distribution, queen gets the remaining value
1281         uint256 jokerPayday = toBeDistributed - knightPayday - paladinPayday;
1282 
1283         _cBalance[jokerAddress] = _cBalance[jokerAddress] + jokerPayday;
1284         _cBalance[knightAddress] = _cBalance[knightAddress] + knightPayday;
1285         _cBalance[paladinAddress] = _cBalance[paladinAddress] + paladinPayday;
1286         //Reset balance to 0
1287         toBeDistributed = 0;
1288     }
1289 
1290     /**
1291         @dev Execute the proposal
1292     */
1293     function _doProposal() internal {
1294         /// UPDATE the renaming cost
1295         if( currentProposal.methodId == 0 ) HorseyToken(tokenAddress).setRenamingCosts(currentProposal.parameter);
1296         
1297         /// UPDATE the market fees
1298         if( currentProposal.methodId == 1 ) HorseyExchange(exchangeAddress).setMarketFees(currentProposal.parameter);
1299 
1300         /// UPDATE the legit dev addresses list
1301         if( currentProposal.methodId == 2 ) HorseyToken(tokenAddress).addLegitRaceAddress(address(currentProposal.parameter));
1302 
1303         /// ADD a horse index to exchange
1304         if( currentProposal.methodId == 3 ) HorseyToken(tokenAddress).addHorseIndex(bytes32(currentProposal.parameter));
1305 
1306         /// PAUSE/UNPAUSE the dApp
1307         if( currentProposal.methodId == 4 ) {
1308             if(currentProposal.parameter == 0) {
1309                 HorseyExchange(exchangeAddress).unpause();
1310                 HorseyToken(tokenAddress).unpause();
1311             } else {
1312                 HorseyExchange(exchangeAddress).pause();
1313                 HorseyToken(tokenAddress).pause();
1314             }
1315         }
1316 
1317         /// UPDATE the claiming fees
1318         if( currentProposal.methodId == 5 ) HorseyToken(tokenAddress).setClaimingCosts(currentProposal.parameter);
1319 
1320         /// UPDATE carrots multiplier
1321         if( currentProposal.methodId == 8 ){
1322             HorseyToken(tokenAddress).setCarrotsMultiplier(uint8(currentProposal.parameter));
1323         }
1324 
1325         /// UPDATE rarity multiplier
1326         if( currentProposal.methodId == 9 ){
1327             HorseyToken(tokenAddress).setRarityMultiplier(uint8(currentProposal.parameter));
1328         }
1329 
1330         emit ProposalPassed(currentProposal.methodId,currentProposal.parameter,currentProposal.proposer);
1331     }
1332 
1333     /// @dev requires the address to be non null
1334     modifier validAddress(address addr) {
1335         require(addr != address(0),"Address is zero");
1336         _;
1337     }
1338 
1339     /// @dev requires the sender to be on the contract owners list
1340     modifier onlyCLevelAccess() {
1341         require((jokerAddress == msg.sender) || (knightAddress == msg.sender) || (paladinAddress == msg.sender),"not c level");
1342         _;
1343     }
1344 
1345     /// @dev requires that a proposal is not in process or has exceeded its lifetime, and has cooled down
1346     /// after being vetoed
1347     modifier proposalAvailable(){
1348         require(((!proposalInProgress) || ((block.timestamp - currentProposal.timestamp) > proposalLife)),"proposal already pending");
1349         _;
1350     }
1351 
1352     // @dev requries that if this proposer was the last proposer, that he or she has reached the 
1353     // cooldown limit
1354     modifier cooledDown( ){
1355         if(msg.sender == currentProposal.proposer && (block.timestamp - cooldownStart < 1 days)){
1356             revert("Cool down period not passed yet");
1357         }
1358         _;
1359     }
1360 
1361     /// @dev requires a proposal to be active
1362     modifier proposalPending() {
1363         require(proposalInProgress,"no proposal pending");
1364         _;
1365     }
1366 
1367     /// @dev requires the voter to not have voted already
1368     modifier notVoted() {
1369         uint256 length = currentProposal.yay.length;
1370         for(uint i = 0; i < length; i++) {
1371             if(currentProposal.yay[i] == msg.sender) {
1372                 revert("Already voted");
1373             }
1374         }
1375 
1376         length = currentProposal.nay.length;
1377         for(i = 0; i < length; i++) {
1378             if(currentProposal.nay[i] == msg.sender) {
1379                 revert("Already voted");
1380             }
1381         }
1382         _;
1383     }
1384 
1385     /// @dev requires the voter to not have voted already
1386     modifier onlyVoters() {
1387         bool found = false;
1388         uint256 length = voters.length;
1389         for(uint i = 0; i < length; i++) {
1390             if(voters[i] == msg.sender) {
1391                 found = true;
1392                 break;
1393             }
1394         }
1395         if(!found) {
1396             revert("not a voter");
1397         }
1398         _;
1399     }
1400 }