1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 
87 /**
88  * @title Claimable
89  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
90  * This allows the new owner to accept the transfer.
91  */
92 contract Claimable is Ownable {
93   address public pendingOwner;
94 
95   /**
96    * @dev Modifier throws if called by any account other than the pendingOwner.
97    */
98   modifier onlyPendingOwner() {
99     require(msg.sender == pendingOwner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to set the pendingOwner address.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address newOwner) onlyOwner public {
108     pendingOwner = newOwner;
109   }
110 
111   /**
112    * @dev Allows the pendingOwner address to finalize the transfer.
113    */
114   function claimOwnership() onlyPendingOwner public {
115     OwnershipTransferred(owner, pendingOwner);
116     owner = pendingOwner;
117     pendingOwner = address(0);
118   }
119 }
120 
121 /**
122  * @title SafeMath
123  * @dev Math operations with safety checks that throw on error
124  */
125 library SafeMath {
126 
127   /**
128   * @dev Multiplies two numbers, throws on overflow.
129   */
130   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131     if (a == 0) {
132       return 0;
133     }
134     uint256 c = a * b;
135     assert(c / a == b);
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers, truncating the quotient.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     // assert(b > 0); // Solidity automatically throws when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146     return c;
147   }
148 
149   /**
150   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
151   */
152   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153     assert(b <= a);
154     return a - b;
155   }
156 
157   /**
158   * @dev Adds two numbers, throws on overflow.
159   */
160   function add(uint256 a, uint256 b) internal pure returns (uint256) {
161     uint256 c = a + b;
162     assert(c >= a);
163     return c;
164   }
165 }
166 
167 /**
168  * @title ERC721 interface
169  * @dev see https://github.com/ethereum/eips/issues/721
170  */
171 contract ERC721 {
172   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
173   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
174 
175   function balanceOf(address _owner) public view returns (uint256 _balance);
176   function ownerOf(uint256 _tokenId) public view returns (address _owner);
177   function transfer(address _to, uint256 _tokenId) public;
178   function approve(address _to, uint256 _tokenId) public;
179   function takeOwnership(uint256 _tokenId) public;
180 }
181 
182 /**
183  * @title ERC721Token
184  * Generic implementation for the required functionality of the ERC721 standard
185  */
186 contract ERC721Token is ERC721 {
187   using SafeMath for uint256;
188 
189   // Total amount of tokens
190   uint256 private totalTokens;
191 
192   // Mapping from token ID to owner
193   mapping (uint256 => address) private tokenOwner;
194 
195   // Mapping from token ID to approved address
196   mapping (uint256 => address) private tokenApprovals;
197 
198   // Mapping from owner to list of owned token IDs
199   mapping (address => uint256[]) private ownedTokens;
200 
201   // Mapping from token ID to index of the owner tokens list
202   mapping(uint256 => uint256) private ownedTokensIndex;
203 
204   /**
205   * @dev Guarantees msg.sender is owner of the given token
206   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
207   */
208   modifier onlyOwnerOf(uint256 _tokenId) {
209     require(ownerOf(_tokenId) == msg.sender);
210     _;
211   }
212 
213   /**
214   * @dev Gets the total amount of tokens stored by the contract
215   * @return uint256 representing the total amount of tokens
216   */
217   function totalSupply() public view returns (uint256) {
218     return totalTokens;
219   }
220 
221   /**
222   * @dev Gets the balance of the specified address
223   * @param _owner address to query the balance of
224   * @return uint256 representing the amount owned by the passed address
225   */
226   function balanceOf(address _owner) public view returns (uint256) {
227     return ownedTokens[_owner].length;
228   }
229 
230   /**
231   * @dev Gets the list of tokens owned by a given address
232   * @param _owner address to query the tokens of
233   * @return uint256[] representing the list of tokens owned by the passed address
234   */
235   function tokensOf(address _owner) public view returns (uint256[]) {
236     return ownedTokens[_owner];
237   }
238 
239   /**
240   * @dev Gets the owner of the specified token ID
241   * @param _tokenId uint256 ID of the token to query the owner of
242   * @return owner address currently marked as the owner of the given token ID
243   */
244   function ownerOf(uint256 _tokenId) public view returns (address) {
245     address owner = tokenOwner[_tokenId];
246     require(owner != address(0));
247     return owner;
248   }
249 
250   /**
251    * @dev Gets the approved address to take ownership of a given token ID
252    * @param _tokenId uint256 ID of the token to query the approval of
253    * @return address currently approved to take ownership of the given token ID
254    */
255   function approvedFor(uint256 _tokenId) public view returns (address) {
256     return tokenApprovals[_tokenId];
257   }
258 
259   /**
260   * @dev Transfers the ownership of a given token ID to another address
261   * @param _to address to receive the ownership of the given token ID
262   * @param _tokenId uint256 ID of the token to be transferred
263   */
264   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
265     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
266   }
267 
268   /**
269   * @dev Approves another address to claim for the ownership of the given token ID
270   * @param _to address to be approved for the given token ID
271   * @param _tokenId uint256 ID of the token to be approved
272   */
273   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
274     address owner = ownerOf(_tokenId);
275     require(_to != owner);
276     if (approvedFor(_tokenId) != 0 || _to != 0) {
277       tokenApprovals[_tokenId] = _to;
278       Approval(owner, _to, _tokenId);
279     }
280   }
281 
282   /**
283   * @dev Claims the ownership of a given token ID
284   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
285   */
286   function takeOwnership(uint256 _tokenId) public {
287     require(isApprovedFor(msg.sender, _tokenId));
288     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
289   }
290 
291   /**
292   * @dev Mint token function
293   * @param _to The address that will own the minted token
294   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
295   */
296   function _mint(address _to, uint256 _tokenId) internal {
297     require(_to != address(0));
298     addToken(_to, _tokenId);
299     Transfer(0x0, _to, _tokenId);
300   }
301 
302   /**
303   * @dev Burns a specific token
304   * @param _tokenId uint256 ID of the token being burned by the msg.sender
305   */
306   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
307     if (approvedFor(_tokenId) != 0) {
308       clearApproval(msg.sender, _tokenId);
309     }
310     removeToken(msg.sender, _tokenId);
311     Transfer(msg.sender, 0x0, _tokenId);
312   }
313 
314   /**
315    * @dev Tells whether the msg.sender is approved for the given token ID or not
316    * This function is not private so it can be extended in further implementations like the operatable ERC721
317    * @param _owner address of the owner to query the approval of
318    * @param _tokenId uint256 ID of the token to query the approval of
319    * @return bool whether the msg.sender is approved for the given token ID or not
320    */
321   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
322     return approvedFor(_tokenId) == _owner;
323   }
324 
325   /**
326   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
327   * @param _from address which you want to send tokens from
328   * @param _to address which you want to transfer the token to
329   * @param _tokenId uint256 ID of the token to be transferred
330   */
331   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
332     require(_to != address(0));
333     require(_to != ownerOf(_tokenId));
334     require(ownerOf(_tokenId) == _from);
335 
336     clearApproval(_from, _tokenId);
337     removeToken(_from, _tokenId);
338     addToken(_to, _tokenId);
339     Transfer(_from, _to, _tokenId);
340   }
341 
342   /**
343   * @dev Internal function to clear current approval of a given token ID
344   * @param _tokenId uint256 ID of the token to be transferred
345   */
346   function clearApproval(address _owner, uint256 _tokenId) private {
347     require(ownerOf(_tokenId) == _owner);
348     tokenApprovals[_tokenId] = 0;
349     Approval(_owner, 0, _tokenId);
350   }
351 
352   /**
353   * @dev Internal function to add a token ID to the list of a given address
354   * @param _to address representing the new owner of the given token ID
355   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
356   */
357   function addToken(address _to, uint256 _tokenId) private {
358     require(tokenOwner[_tokenId] == address(0));
359     tokenOwner[_tokenId] = _to;
360     uint256 length = balanceOf(_to);
361     ownedTokens[_to].push(_tokenId);
362     ownedTokensIndex[_tokenId] = length;
363     totalTokens = totalTokens.add(1);
364   }
365 
366   /**
367   * @dev Internal function to remove a token ID from the list of a given address
368   * @param _from address representing the previous owner of the given token ID
369   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
370   */
371   function removeToken(address _from, uint256 _tokenId) private {
372     require(ownerOf(_tokenId) == _from);
373 
374     uint256 tokenIndex = ownedTokensIndex[_tokenId];
375     uint256 lastTokenIndex = balanceOf(_from).sub(1);
376     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
377 
378     tokenOwner[_tokenId] = 0;
379     ownedTokens[_from][tokenIndex] = lastToken;
380     ownedTokens[_from][lastTokenIndex] = 0;
381     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
382     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
383     // the lastToken to the first position, and then dropping the element placed in the last position of the list
384 
385     ownedTokens[_from].length--;
386     ownedTokensIndex[_tokenId] = 0;
387     ownedTokensIndex[lastToken] = tokenIndex;
388     totalTokens = totalTokens.sub(1);
389   }
390 }
391 
392 /**
393  * @title AccessMint
394  * @dev Adds grant/revoke functions to the contract.
395  */
396 contract AccessMint is Claimable {
397 
398   // Access for minting new tokens.
399   mapping(address => bool) private mintAccess;
400 
401   // Event that is fired when minted.
402   event Mint(
403     address indexed _to,
404     uint256 indexed _tokenId
405   );
406 
407   // Modifier for accessibility to define new hero types.
408   modifier onlyAccessMint {
409     require(msg.sender == owner || mintAccess[msg.sender] == true);
410     _;
411   }
412 
413   // @dev Grant acess to mint heroes.
414   function grantAccessMint(address _address)
415     onlyOwner
416     public
417   {
418     mintAccess[_address] = true;
419   }
420 
421   // @dev Revoke acess to mint heroes.
422   function revokeAccessMint(address _address)
423     onlyOwner
424     public
425   {
426     mintAccess[_address] = false;
427   }
428 
429 }
430 
431 /**
432  * @title The swap contract (Card => reward)
433  * @dev With this contract, a CryptoSagaCard holder can swap his/her CryptoSagaCard for reward.
434  *  This contract is intended to be inherited by CryptoSagaCore later.
435  */
436 contract CryptoSagaCardSwap is Ownable {
437 
438   // Card contract.
439   address internal cardAddess;
440 
441   // Modifier for accessibility to define new hero types.
442   modifier onlyCard {
443     require(msg.sender == cardAddess);
444     _;
445   }
446   
447   // @dev Set the address of the contract that represents ERC721 Card.
448   function setCardContract(address _contractAddress)
449     public
450     onlyOwner
451   {
452     cardAddess = _contractAddress;
453   }
454 
455   // @dev Convert card into reward.
456   //  This should be implemented by CryptoSagaCore later.
457   function swapCardForReward(address _by, uint8 _rank)
458     onlyCard
459     public 
460     returns (uint256)
461   {
462     return 0;
463   }
464 
465 }
466 
467 /**
468  * @title CryptoSaga Card
469  * @dev ERC721 Token that repesents CryptoSaga's cards.
470  *  Buy consuming a card, players of CryptoSaga can get a heroe.
471  */
472 contract CryptoSagaCard is ERC721Token, Claimable, AccessMint {
473 
474   string public constant name = "CryptoSaga Card";
475   string public constant symbol = "CARD";
476 
477   // Rank of the token.
478   mapping(uint256 => uint8) public tokenIdToRank;
479 
480   // The number of tokens ever minted.
481   uint256 public numberOfTokenId;
482 
483   // The converter contract.
484   CryptoSagaCardSwap private swapContract;
485 
486   // Event that should be fired when card is converted.
487   event CardSwap(address indexed _by, uint256 _tokenId, uint256 _rewardId);
488 
489   // @dev Set the address of the contract that represents CryptoSaga Cards.
490   function setCryptoSagaCardSwapContract(address _contractAddress)
491     public
492     onlyOwner
493   {
494     swapContract = CryptoSagaCardSwap(_contractAddress);
495   }
496 
497   function rankOf(uint256 _tokenId) 
498     public view
499     returns (uint8)
500   {
501     return tokenIdToRank[_tokenId];
502   }
503 
504   // @dev Mint a new card.
505   function mint(address _beneficiary, uint256 _amount, uint8 _rank)
506     onlyAccessMint
507     public
508   {
509     for (uint256 i = 0; i < _amount; i++) {
510       _mint(_beneficiary, numberOfTokenId);
511       tokenIdToRank[numberOfTokenId] = _rank;
512       numberOfTokenId ++;
513     }
514   }
515 
516   // @dev Swap this card for reward.
517   //  The card will be burnt.
518   function swap(uint256 _tokenId)
519     onlyOwnerOf(_tokenId)
520     public
521     returns (uint256)
522   {
523     require(address(swapContract) != address(0));
524 
525     var _rank = tokenIdToRank[_tokenId];
526     var _rewardId = swapContract.swapCardForReward(this, _rank);
527     CardSwap(ownerOf(_tokenId), _tokenId, _rewardId);
528     _burn(_tokenId);
529     return _rewardId;
530   }
531 
532 }
533 
534 /**
535  * @title The smart contract for the pre-sale.
536  * @dev Origin Card is an ERC20 token.
537  */
538 contract Presale is Pausable {
539   using SafeMath for uint256;
540 
541   // Eth will be sent to this wallet.
542   address public wallet;
543 
544   // The token contract.
545   CryptoSagaCard public cardContract;
546 
547   // Start and end timestamps where investments are allowed (both inclusive).
548   uint256 public startTime;
549   uint256 public endTime;
550 
551   // Price for a card in wei.
552   uint256 public price;
553 
554   // Amount of card sold.
555   uint256 public soldCards;
556 
557   // Increase of price per transaction.
558   uint256 public priceIncrease;
559 
560   // Amount of card redeemed.
561   uint256 public redeemedCards;
562 
563   // Event that is fired when purchase transaction is made.
564   event TokenPurchase(
565     address indexed purchaser, 
566     address indexed beneficiary, 
567     uint256 value,
568     uint256 amount
569   );
570 
571   // Event that is fired when redeem tokens.
572   event TokenRedeem(
573     address indexed beneficiary,
574     uint256 amount
575   );
576 
577   // Event that is fired when refunding excessive money from ther user.
578   event RefundEth(
579     address indexed beneficiary,
580     uint256 amount
581   );
582 
583   // @dev Contructor.
584   function Presale(address _wallet, address _cardAddress, uint256 _startTime, uint256 _endTime, uint256 _price, uint256 _priceIncrease)
585     public
586   {
587     require(_endTime >= _startTime);
588     require(_price >= 0);
589     require(_priceIncrease >= 0);
590     require(_wallet != address(0));
591     
592     wallet = _wallet;
593     cardContract = CryptoSagaCard(_cardAddress);
594     startTime = _startTime;
595     endTime = _endTime;
596     price = _price;
597     priceIncrease = _priceIncrease;
598   }
599 
600   // @return true if the transaction can buy tokens
601   function validPurchase()
602     internal view 
603     returns (bool)
604   {
605     bool withinPeriod = now >= startTime && now <= endTime;
606     bool nonZeroPurchase = msg.value != 0;
607     return withinPeriod && nonZeroPurchase;
608   }
609 
610   // @Notify Redeem limit is 500 cards.
611   // @return true if the transaction can redeem tokens
612   function validRedeem()
613     internal view
614     returns (bool)
615   {
616     bool withinPeriod = now >= startTime && now <= endTime;
617     bool notExceedRedeemLimit = redeemedCards < 500;
618     return withinPeriod && notExceedRedeemLimit;
619   }
620 
621   // @return true if crowdsale event has ended
622   function hasEnded()
623     public view 
624     returns (bool) 
625   {
626     return now > endTime;
627   }
628 
629 
630   // @dev Low level token purchase function.
631   function buyTokens(address _beneficiary, uint256 _amount)
632     whenNotPaused
633     public
634     payable
635   {
636     require(_beneficiary != address(0));
637     require(validPurchase());
638     require(_amount >= 1 && _amount <= 5);
639 
640     var _priceOfBundle = price.mul(_amount);
641 
642     require(msg.value >= _priceOfBundle);
643 
644     // Increase the price.
645     // The price increases only when a transaction is made.
646     // Amount of tokens purchase at a transaction won't affect the price.
647     price = price.add(priceIncrease);
648 
649     // Mint tokens.
650     // Rank 0 means Origin Card.
651     cardContract.mint(_beneficiary, _amount, 0);
652 
653     // Add count of tokens sold.
654     soldCards += _amount;
655 
656     // Send the raised eth to the wallet.
657     wallet.transfer(_priceOfBundle);
658 
659     // Send the exta eth paid by the sender.
660     var _extraEthInWei = msg.value.sub(_priceOfBundle);
661     if (_extraEthInWei >= 0) {
662       msg.sender.transfer(_extraEthInWei);
663     }
664 
665     // Fire event.
666     TokenPurchase(msg.sender, _beneficiary, msg.value, _amount);
667   }
668 
669   // @dev Low level token redeem function.
670   function redeemTokens(address _beneficiary)
671     onlyOwner
672     public
673   {
674     require(_beneficiary != address(0));
675     require(validRedeem());
676 
677     // Mint token.
678     // Rank 0 means Origin Card.
679     cardContract.mint(_beneficiary, 1, 0);
680 
681     // Add count of tokens redeemed.
682     redeemedCards ++;
683 
684     // Fire event.
685     TokenRedeem(_beneficiary, 1);
686   }
687 
688   // @dev Set price increase of token per transaction.
689   //  Note that this will never become below 0, 
690   //  which means early buyers will always buy tokens at lower price than later buyers.
691   function setPriceIncrease(uint256 _priceIncrease)
692     onlyOwner
693     public
694   {
695     require(priceIncrease >= 0);
696     
697     // Set price increase per transaction.
698     priceIncrease = _priceIncrease;
699   }
700 
701   // @dev Withdraw ether collected.
702   function withdrawal()
703     onlyOwner
704     public
705   {
706     wallet.transfer(this.balance);
707   }
708 
709 }