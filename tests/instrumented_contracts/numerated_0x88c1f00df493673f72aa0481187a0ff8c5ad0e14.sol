1 pragma solidity ^0.4.23;
2 
3 // File: contracts/convert/ByteConvert.sol
4 
5 library ByteConvert {
6 
7   function bytesToBytes2(bytes b) public pure returns (bytes2) {
8     bytes2 out;
9     for (uint i = 0; i < 2; i++) {
10       out |= bytes2(b[i] & 0xFF) >> (i * 8);
11     }
12     return out;
13   }
14 
15   function bytesToBytes5(bytes b) public pure returns (bytes5) {
16     bytes5 out;
17     for (uint i = 0; i < 5; i++) {
18       out |= bytes5(b[i] & 0xFF) >> (i * 8);
19     }
20     return out;
21   }
22 
23   function bytesToBytes8(bytes b) public pure returns (bytes8) {
24     bytes8 out;
25     for (uint i = 0; i < 8; i++) {
26       out |= bytes8(b[i] & 0xFF) >> (i * 8);
27     }
28     return out;
29   }
30 
31 }
32 
33 // File: contracts/interface/EtherSpaceBattleInterface.sol
34 
35 contract EtherSpaceBattleInterface {
36   function isEtherSpaceBattle() public pure returns (bool);
37   function battle(bytes8 _spaceshipAttributes, bytes5 _spaceshipUpgrades, bytes8 _spaceshipToAttackAttributes, bytes5 _spaceshipToAttackUpgrades) public returns (bool);
38   function calculateStake(bytes8 _spaceshipAttributes, bytes5 _spaceshipUpgrades) public pure returns (uint256);
39   function calculateLevel(bytes8 _spaceshipAttributes, bytes5 _spaceshipUpgrades) public pure returns (uint256);
40 }
41 
42 // File: contracts/interface/EtherSpaceUpgradeInterface.sol
43 
44 contract EtherSpaceUpgradeInterface {
45   function isEtherSpaceUpgrade() public pure returns (bool);
46   function isSpaceshipUpgradeAllowed(bytes5 _upgrades, uint16 _upgradeId, uint8 _position) public view;
47   function buySpaceshipUpgrade(bytes5 _upgrades, uint16 _model, uint8 _position) public returns (bytes5);
48   function getSpaceshipUpgradePriceByModel(uint16 _model, uint8 _position) public view returns (uint256);
49   function getSpaceshipUpgradeTotalSoldByModel(uint16 _model, uint8 _position) public view returns (uint256);
50   function getSpaceshipUpgradeCount() public view returns (uint256);
51   function newSpaceshipUpgrade(bytes1 _identifier, uint8 _position, uint256 _price) public;
52 }
53 
54 // File: contracts/ownership/Ownable.sol
55 
56 // Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64 
65     address public owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71     * account.
72     */
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     /**
78     * @dev Throws if called by any account other than the owner.
79     */
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     /**
86     * @dev Allows the current owner to transfer control of the contract to a newOwner.
87     * @param newOwner The address to transfer ownership to.
88     */
89     function transferOwnership(address newOwner) public onlyOwner {
90         require(newOwner != address(0));
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93     }
94 
95 
96 }
97 
98 // File: contracts/lifecycle/Destructible.sol
99 
100 // Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)
101 
102 /**
103  * @title Destructible
104  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
105  */
106 contract Destructible is Ownable {
107 
108     constructor() public payable { }
109 
110     /**
111     * @dev Transfers the current balance to the owner and terminates the contract.
112     */
113     function destroy() onlyOwner public {
114         selfdestruct(owner);
115     }
116 
117     function destroyAndSend(address _recipient) onlyOwner public {
118         selfdestruct(_recipient);
119     }
120 
121 }
122 
123 // File: contracts/math/SafeMath.sol
124 
125 // Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)
126 
127 /**
128  * @title SafeMath
129  * @dev Math operations with safety checks that throw on error
130  */
131 library SafeMath {
132 
133     /**
134     * @dev Multiplies two numbers, throws on overflow.
135     */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         if (a == 0) {
138             return 0;
139         }
140         uint256 c = a * b;
141         assert(c / a == b);
142         return c;
143     }
144 
145     /**
146     * @dev Integer division of two numbers, truncating the quotient.
147     */
148     function div(uint256 a, uint256 b) internal pure returns (uint256) {
149         // assert(b > 0); // Solidity automatically throws when dividing by 0
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152         return c;
153     }
154 
155     /**
156     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
157     */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         assert(b <= a);
160         return a - b;
161     }
162 
163     /**
164     * @dev Adds two numbers, throws on overflow.
165     */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         assert(c >= a);
169         return c;
170     }
171 
172 }
173 
174 // File: contracts/ownership/Claimable.sol
175 
176 // Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)
177 
178 /**
179  * @title Claimable
180  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
181  * This allows the new owner to accept the transfer.
182  */
183 contract Claimable is Ownable {
184 
185     address public pendingOwner;
186 
187     /**
188     * @dev Modifier throws if called by any account other than the pendingOwner.
189     */
190     modifier onlyPendingOwner() {
191         require(msg.sender == pendingOwner);
192         _;
193     }
194 
195     /**
196     * @dev Allows the current owner to set the pendingOwner address.
197     * @param newOwner The address to transfer ownership to.
198     */
199     function transferOwnership(address newOwner) onlyOwner public {
200         pendingOwner = newOwner;
201     }
202 
203     /**
204     * @dev Allows the pendingOwner address to finalize the transfer.
205     */
206     function claimOwnership() onlyPendingOwner public {
207         emit OwnershipTransferred(owner, pendingOwner);
208         owner = pendingOwner;
209         pendingOwner = address(0);
210     }
211 
212 }
213 
214 // File: contracts/token/ERC721.sol
215 
216 /**
217  * @title ERC721 interface
218  * @dev see https://github.com/ethereum/eips/issues/721
219  */
220 contract ERC721 {
221   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
222   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
223 
224   function balanceOf(address _owner) public view returns (uint256 _balance);
225   function ownerOf(uint256 _tokenId) public view returns (address _owner);
226   function transfer(address _to, uint256 _tokenId) public;
227   function approve(address _to, uint256 _tokenId) public;
228   function takeOwnership(uint256 _tokenId) public;
229 }
230 
231 // File: contracts/token/ERC721Token.sol
232 
233 /**
234  * @title ERC721Token
235  * Generic implementation for the required functionality of the ERC721 standard
236  */
237 contract ERC721Token is ERC721 {
238   using SafeMath for uint256;
239 
240   // Total amount of tokens
241   uint256 private totalTokens;
242 
243   // Mapping from token ID to owner
244   mapping (uint256 => address) private tokenOwner;
245 
246   // Mapping from token ID to approved address
247   mapping (uint256 => address) private tokenApprovals;
248 
249   // Mapping from owner to list of owned token IDs
250   mapping (address => uint256[]) private ownedTokens;
251 
252   // Mapping from token ID to index of the owner tokens list
253   mapping(uint256 => uint256) private ownedTokensIndex;
254 
255   /**
256   * @dev Guarantees msg.sender is owner of the given token
257   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
258   */
259   modifier onlyOwnerOf(uint256 _tokenId) {
260     require(ownerOf(_tokenId) == msg.sender);
261     _;
262   }
263 
264   /**
265   * @dev Gets the total amount of tokens stored by the contract
266   * @return uint256 representing the total amount of tokens
267   */
268   function totalSupply() public view returns (uint256) {
269     return totalTokens;
270   }
271 
272   /**
273   * @dev Gets the balance of the specified address
274   * @param _owner address to query the balance of
275   * @return uint256 representing the amount owned by the passed address
276   */
277   function balanceOf(address _owner) public view returns (uint256) {
278     return ownedTokens[_owner].length;
279   }
280 
281   /**
282   * @dev Gets the list of tokens owned by a given address
283   * @param _owner address to query the tokens of
284   * @return uint256[] representing the list of tokens owned by the passed address
285   */
286   function tokensOf(address _owner) public view returns (uint256[]) {
287     return ownedTokens[_owner];
288   }
289 
290   /**
291   * @dev Gets the owner of the specified token ID
292   * @param _tokenId uint256 ID of the token to query the owner of
293   * @return owner address currently marked as the owner of the given token ID
294   */
295   function ownerOf(uint256 _tokenId) public view returns (address) {
296     address owner = tokenOwner[_tokenId];
297     require(owner != address(0));
298     return owner;
299   }
300 
301   /**
302    * @dev Gets the approved address to take ownership of a given token ID
303    * @param _tokenId uint256 ID of the token to query the approval of
304    * @return address currently approved to take ownership of the given token ID
305    */
306   function approvedFor(uint256 _tokenId) public view returns (address) {
307     return tokenApprovals[_tokenId];
308   }
309 
310   /**
311   * @dev Transfers the ownership of a given token ID to another address
312   * @param _to address to receive the ownership of the given token ID
313   * @param _tokenId uint256 ID of the token to be transferred
314   */
315   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
316     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
317   }
318 
319   /**
320   * @dev Approves another address to claim for the ownership of the given token ID
321   * @param _to address to be approved for the given token ID
322   * @param _tokenId uint256 ID of the token to be approved
323   */
324   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
325     address owner = ownerOf(_tokenId);
326     require(_to != owner);
327     if (approvedFor(_tokenId) != 0 || _to != 0) {
328       tokenApprovals[_tokenId] = _to;
329       emit Approval(owner, _to, _tokenId);
330     }
331   }
332 
333   /**
334   * @dev Claims the ownership of a given token ID
335   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
336   */
337   function takeOwnership(uint256 _tokenId) public {
338     require(isApprovedFor(msg.sender, _tokenId));
339     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
340   }
341 
342   /**
343   * @dev Mint token function
344   * @param _to The address that will own the minted token
345   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
346   */
347   function _mint(address _to, uint256 _tokenId) internal {
348     require(_to != address(0));
349     addToken(_to, _tokenId);
350     emit Transfer(0x0, _to, _tokenId);
351   }
352 
353   /**
354   * @dev Burns a specific token
355   * @param _tokenId uint256 ID of the token being burned by the msg.sender
356   */
357   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
358     if (approvedFor(_tokenId) != 0) {
359       clearApproval(msg.sender, _tokenId);
360     }
361     removeToken(msg.sender, _tokenId);
362     emit Transfer(msg.sender, 0x0, _tokenId);
363   }
364 
365   /**
366    * @dev Tells whether the msg.sender is approved for the given token ID or not
367    * This function is not private so it can be extended in further implementations like the operatable ERC721
368    * @param _owner address of the owner to query the approval of
369    * @param _tokenId uint256 ID of the token to query the approval of
370    * @return bool whether the msg.sender is approved for the given token ID or not
371    */
372   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
373     return approvedFor(_tokenId) == _owner;
374   }
375 
376   /**
377   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
378   * @param _from address which you want to send tokens from
379   * @param _to address which you want to transfer the token to
380   * @param _tokenId uint256 ID of the token to be transferred
381   */
382   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
383     require(_to != address(0));
384     require(_to != ownerOf(_tokenId));
385     require(ownerOf(_tokenId) == _from);
386 
387     clearApproval(_from, _tokenId);
388     removeToken(_from, _tokenId);
389     addToken(_to, _tokenId);
390     emit Transfer(_from, _to, _tokenId);
391   }
392 
393   /**
394   * @dev Internal function to clear current approval of a given token ID
395   * @param _tokenId uint256 ID of the token to be transferred
396   */
397   function clearApproval(address _owner, uint256 _tokenId) private {
398     require(ownerOf(_tokenId) == _owner);
399     tokenApprovals[_tokenId] = 0;
400     emit Approval(_owner, 0, _tokenId);
401   }
402 
403   /**
404   * @dev Internal function to add a token ID to the list of a given address
405   * @param _to address representing the new owner of the given token ID
406   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
407   */
408   function addToken(address _to, uint256 _tokenId) private {
409     require(tokenOwner[_tokenId] == address(0));
410     tokenOwner[_tokenId] = _to;
411     uint256 length = balanceOf(_to);
412     ownedTokens[_to].push(_tokenId);
413     ownedTokensIndex[_tokenId] = length;
414     totalTokens = totalTokens.add(1);
415   }
416 
417   /**
418   * @dev Internal function to remove a token ID from the list of a given address
419   * @param _from address representing the previous owner of the given token ID
420   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
421   */
422   function removeToken(address _from, uint256 _tokenId) private {
423     require(ownerOf(_tokenId) == _from);
424 
425     uint256 tokenIndex = ownedTokensIndex[_tokenId];
426     uint256 lastTokenIndex = balanceOf(_from).sub(1);
427     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
428 
429     tokenOwner[_tokenId] = 0;
430     ownedTokens[_from][tokenIndex] = lastToken;
431     ownedTokens[_from][lastTokenIndex] = 0;
432     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
433     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
434     // the lastToken to the first position, and then dropping the element placed in the last position of the list
435 
436     ownedTokens[_from].length--;
437     ownedTokensIndex[_tokenId] = 0;
438     ownedTokensIndex[lastToken] = tokenIndex;
439     totalTokens = totalTokens.sub(1);
440   }
441 }
442 
443 // File: contracts/EtherSpaceCore.sol
444 
445 contract EtherSpaceCore is ERC721Token, Ownable, Claimable, Destructible {
446 
447   string public url = "https://etherspace.co/";
448 
449   using SafeMath for uint256;
450 
451   struct Spaceship {
452     uint16 model;
453     bool battleMode;
454     uint32 battleWins;
455     uint32 battleLosses;
456     uint256 battleStake;
457     bytes5 upgrades;
458     bool isAuction;
459     uint256 auctionPrice;
460   }
461 
462   mapping (uint256 => Spaceship) private spaceships;
463   uint256[] private spaceshipIds;
464 
465   /* */
466   struct SpaceshipProduct {
467     uint16 class;
468     bytes8 attributes;
469     uint256 price; // initial price
470     uint32 totalSold; // The quantity of spaceships sold for this model
471   }
472 
473   mapping (uint16 => SpaceshipProduct) private spaceshipProducts;
474   uint16 spaceshipProductCount = 0; // The next count for spaceships products created
475 
476   mapping (address => uint256) private balances; // User balances
477 
478   // Battle
479   uint256 public battleFee = 0;
480 
481   // Marketplace
482   uint32 public saleFee = 5; // 5%
483 
484   EtherSpaceUpgradeInterface public upgradeContract;
485   EtherSpaceBattleInterface public battleContract;
486 
487   /* Events */
488   event EventCashOut (
489     address indexed player,
490     uint256 amount
491   );
492   event EventBattleAdd (
493     address indexed player,
494     uint256 tokenId
495   );
496   event EventBattleRemove (
497     address indexed player,
498     uint256 tokenId
499   );
500   event EventBattle (
501     address indexed player,
502     uint256 tokenId,
503     uint256 tokenIdToAttack,
504     uint256 tokenIdWinner
505   );
506   event EventBuySpaceshipUpgrade (
507     address indexed player,
508     uint256 tokenId,
509     uint16 model,
510     uint8 position
511   );
512   event Log (
513     string message
514   );
515 
516   constructor() public {
517     _newSpaceshipProduct(0,   0x001e,   0x0514,   0x0004,   0x0005,   50000000000000000); // price 0.05
518     _newSpaceshipProduct(0,   0x001d,   0x0226,   0x0005,   0x0006,   60000000000000000); // price 0.06
519     _newSpaceshipProduct(0,   0x001f,   0x03e8,   0x0003,   0x0009,   70000000000000000); // price 0.07
520     _newSpaceshipProduct(0,   0x001e,   0x0258,   0x0005,   0x0009,   80000000000000000); // price 0.08
521     _newSpaceshipProduct(0,   0x001a,   0x0064,   0x0006,   0x000a,   90000000000000000); // price 0.09
522     _newSpaceshipProduct(0,   0x0015,   0x0032,   0x0007,   0x000b,  100000000000000000); // price 0.10
523   }
524 
525   function _setUpgradeContract(address _address) private {
526     EtherSpaceUpgradeInterface candidateContract = EtherSpaceUpgradeInterface(_address);
527 
528     require(candidateContract.isEtherSpaceUpgrade());
529 
530     // Set the new contract address
531     upgradeContract = candidateContract;
532   }
533 
534   function _setBattleContract(address _address) private {
535     EtherSpaceBattleInterface candidateContract = EtherSpaceBattleInterface(_address);
536 
537     require(candidateContract.isEtherSpaceBattle());
538 
539     // Set the new contract address
540     battleContract = candidateContract;
541   }
542 
543   /* Constructor rejects payments to avoid mistakes */
544   function() external payable {
545       require(false);
546   }
547 
548   /* ERC721Metadata */
549   function name() external pure returns (string) {
550     return "EtherSpace";
551   }
552 
553   function symbol() external pure returns (string) {
554     return "ESPC";
555   }
556 
557   /* Enable listing of all deeds (alternative to ERC721Enumerable to avoid having to work with arrays). */
558   function ids() external view returns (uint256[]) {
559     return spaceshipIds;
560   }
561 
562   /* Owner functions */
563   function setSpaceshipPrice(uint16 _model, uint256 _price) external onlyOwner {
564     require(_price > 0);
565 
566     spaceshipProducts[_model].price = _price;
567   }
568 
569   function newSpaceshipProduct(uint16 _class, bytes2 _propulsion, bytes2 _weight, bytes2 _attack, bytes2 _armour, uint256 _price) external onlyOwner {
570     _newSpaceshipProduct(_class, _propulsion, _weight, _attack, _armour, _price);
571   }
572 
573   function setBattleFee(uint256 _fee) external onlyOwner {
574     battleFee = _fee;
575   }
576 
577   function setUpgradeContract(address _address) external onlyOwner {
578     _setUpgradeContract(_address);
579   }
580 
581   function setBattleContract(address _address) external onlyOwner {
582     _setBattleContract(_address);
583   }
584 
585   function giftSpaceship(uint16 _model, address _player) external onlyOwner {
586     _generateSpaceship(_model, _player);
587   }
588 
589   function newSpaceshipUpgrade(bytes1 _identifier, uint8 _position, uint256 _price) external onlyOwner {
590     upgradeContract.newSpaceshipUpgrade(_identifier, _position, _price);
591   }
592 
593   /* Spaceship Product functions */
594   function _newSpaceshipProduct(uint16 _class, bytes2 _propulsion, bytes2 _weight, bytes2 _attack, bytes2 _armour, uint256 _price) private {
595     bytes memory attributes = new bytes(8);
596     attributes[0] = _propulsion[0];
597     attributes[1] = _propulsion[1];
598     attributes[2] = _weight[0];
599     attributes[3] = _weight[1];
600     attributes[4] = _attack[0];
601     attributes[5] = _attack[1];
602     attributes[6] = _armour[0];
603     attributes[7] = _armour[1];
604 
605     spaceshipProducts[spaceshipProductCount++] = SpaceshipProduct(_class, ByteConvert.bytesToBytes8(attributes), _price, 0);
606   }
607 
608   /* CashOut */
609   function cashOut() public {
610     require(address(this).balance >= balances[msg.sender]); // Checking if this contract has enought money to pay
611     require(balances[msg.sender] > 0); // Cannot cashOut zero amount
612 
613     uint256 _balance = balances[msg.sender];
614 
615     balances[msg.sender] = 0;
616     msg.sender.transfer(_balance);
617 
618     emit EventCashOut(msg.sender, _balance);
619   }
620 
621   /* Marketplace functions */
622   function buySpaceship(uint16 _model) public payable {
623     require(msg.value > 0);
624     require(msg.value == spaceshipProducts[_model].price);
625     require(spaceshipProducts[_model].price > 0);
626 
627     _generateSpaceship(_model, msg.sender);
628 
629     balances[owner] += spaceshipProducts[_model].price;
630   }
631 
632   function _generateSpaceship(uint16 _model, address _player) private {
633     // Build a new spaceship for player
634     uint256 tokenId = spaceshipIds.length;
635     spaceshipIds.push(tokenId);
636     super._mint(_player, tokenId);
637 
638     spaceships[tokenId] = Spaceship({
639       model: _model,
640       battleMode: false,
641       battleWins: 0,
642       battleLosses: 0,
643       battleStake: 0,
644       upgrades: "\x00\x00\x00\x00\x00", // Prepared to have 5 different types of upgrades
645       isAuction: false,
646       auctionPrice: 0
647     });
648 
649     spaceshipProducts[_model].totalSold++;
650   }
651 
652   function sellSpaceship(uint256 _tokenId, uint256 _price) public onlyOwnerOf(_tokenId) {
653     spaceships[_tokenId].isAuction = true;
654     spaceships[_tokenId].auctionPrice = _price;
655   }
656 
657   function bidSpaceship(uint256 _tokenId) public payable {
658     require(getPlayerSpaceshipAuctionById(_tokenId)); // must be for sale
659     require(getPlayerSpaceshipAuctionPriceById(_tokenId) == msg.value); // value must be exactly
660 
661     // Giving the sold percentage fee to contract owner
662     uint256 ownerPercentage = msg.value.mul(uint256(saleFee)).div(100);
663     balances[owner] += ownerPercentage;
664 
665     // Giving the sold amount minus owner fee to seller
666     balances[getPlayerSpaceshipOwnerById(_tokenId)] += msg.value.sub(ownerPercentage);
667 
668     // Transfering spaceship to buyer
669     super.clearApprovalAndTransfer(getPlayerSpaceshipOwnerById(_tokenId), msg.sender, _tokenId);
670 
671     // Removing from auction
672     spaceships[_tokenId].isAuction = false;
673     spaceships[_tokenId].auctionPrice = 0;
674   }
675 
676   /* Battle functions */
677   function battleAdd(uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {
678     require(msg.value == getPlayerSpaceshipBattleStakeById(_tokenId));
679     require(msg.value > 0);
680     require(spaceships[_tokenId].battleMode == false);
681 
682     spaceships[_tokenId].battleMode = true;
683     spaceships[_tokenId].battleStake = msg.value;
684 
685     emit EventBattleAdd(msg.sender, _tokenId);
686   }
687 
688   function battleRemove(uint256 _tokenId) public onlyOwnerOf(_tokenId) {
689     require(spaceships[_tokenId].battleMode == true);
690 
691     spaceships[_tokenId].battleMode = false;
692 
693     balances[msg.sender] = balances[msg.sender].add(spaceships[_tokenId].battleStake);
694 
695     emit EventBattleRemove(msg.sender, _tokenId);
696   }
697 
698   function battle(uint256 _tokenId, uint256 _tokenIdToAttack) public payable onlyOwnerOf(_tokenId) {
699     require (spaceships[_tokenIdToAttack].battleMode == true); // ship to attack must be in battle mode
700     require (spaceships[_tokenId].battleMode == false); // attacking ship must not be offered for battle
701     require(msg.value == getPlayerSpaceshipBattleStakeById(_tokenId));
702 
703     uint256 battleStakeDefender = spaceships[_tokenIdToAttack].battleStake;
704 
705     bool result = battleContract.battle(spaceshipProducts[spaceships[_tokenId].model].attributes, spaceships[_tokenId].upgrades, spaceshipProducts[spaceships[_tokenIdToAttack].model].attributes, spaceships[_tokenIdToAttack].upgrades);
706 
707     if (result) {
708         spaceships[_tokenId].battleWins++;
709         spaceships[_tokenIdToAttack].battleLosses++;
710 
711         balances[super.ownerOf(_tokenId)] += (battleStakeDefender + msg.value) - battleFee;
712         spaceships[_tokenIdToAttack].battleStake = 0;
713 
714         emit EventBattle(msg.sender, _tokenId, _tokenIdToAttack, _tokenId);
715 
716     } else {
717         spaceships[_tokenId].battleLosses++;
718         spaceships[_tokenIdToAttack].battleWins++;
719 
720         balances[super.ownerOf(_tokenIdToAttack)] += (battleStakeDefender + msg.value) - battleFee;
721         spaceships[_tokenIdToAttack].battleStake = 0;
722 
723         emit EventBattle(msg.sender, _tokenId, _tokenIdToAttack, _tokenIdToAttack);
724     }
725 
726     balances[owner] += battleFee;
727 
728     spaceships[_tokenIdToAttack].battleMode = false;
729   }
730 
731   /* Upgrade functions */
732   function buySpaceshipUpgrade(uint256 _tokenId, uint16 _model, uint8 _position) public payable onlyOwnerOf(_tokenId) {
733     require(msg.value > 0);
734     uint256 upgradePrice = upgradeContract.getSpaceshipUpgradePriceByModel(_model, _position);
735     require(msg.value == upgradePrice);
736     require(getPlayerSpaceshipBattleModeById(_tokenId) == false);
737 
738     bytes5 currentUpgrades = spaceships[_tokenId].upgrades;
739     upgradeContract.isSpaceshipUpgradeAllowed(currentUpgrades, _model, _position);
740 
741     spaceships[_tokenId].upgrades = upgradeContract.buySpaceshipUpgrade(currentUpgrades, _model, _position);
742 
743     balances[owner] += upgradePrice;
744 
745     emit EventBuySpaceshipUpgrade(msg.sender, _tokenId, _model, _position);
746   }
747 
748   /* Getters getPlayer* */
749   function getPlayerSpaceshipCount(address _player) public view returns (uint256) {
750     return super.balanceOf(_player);
751   }
752 
753   function getPlayerSpaceshipModelById(uint256 _tokenId) public view returns (uint16) {
754     return spaceships[_tokenId].model;
755   }
756 
757   function getPlayerSpaceshipOwnerById(uint256 _tokenId) public view returns (address) {
758     return super.ownerOf(_tokenId);
759   }
760 
761   function getPlayerSpaceshipModelByIndex(address _owner, uint256 _index) public view returns (uint16) {
762     return spaceships[super.tokensOf(_owner)[_index]].model;
763   }
764 
765   function getPlayerSpaceshipAuctionById(uint256 _tokenId) public view returns (bool) {
766     return spaceships[_tokenId].isAuction;
767   }
768 
769   function getPlayerSpaceshipAuctionPriceById(uint256 _tokenId) public view returns (uint256) {
770     return spaceships[_tokenId].auctionPrice;
771   }
772 
773   function getPlayerSpaceshipBattleModeById(uint256 _tokenId) public view returns (bool) {
774     return spaceships[_tokenId].battleMode;
775   }
776 
777   function getPlayerSpaceshipBattleStakePaidById(uint256 _tokenId) public view returns (uint256) {
778     return spaceships[_tokenId].battleStake;
779   }
780 
781   function getPlayerSpaceshipBattleStakeById(uint256 _tokenId) public view returns (uint256) {
782     return battleContract.calculateStake(spaceshipProducts[spaceships[_tokenId].model].attributes, spaceships[_tokenId].upgrades);
783   }
784 
785   function getPlayerSpaceshipBattleLevelById(uint256 _tokenId) public view returns (uint256) {
786     return battleContract.calculateLevel(spaceshipProducts[spaceships[_tokenId].model].attributes, spaceships[_tokenId].upgrades);
787   }
788 
789   function getPlayerSpaceshipBattleWinsById(uint256 _tokenId) public view returns (uint32) {
790     return spaceships[_tokenId].battleWins;
791   }
792 
793   function getPlayerSpaceshipBattleLossesById(uint256 _tokenId) public view returns (uint32) {
794     return spaceships[_tokenId].battleLosses;
795   }
796 
797   function getPlayerSpaceships(address _owner) public view returns (uint256[]) {
798     return super.tokensOf(_owner);
799   }
800 
801   function getPlayerBalance(address _owner) public view returns (uint256) {
802     return balances[_owner];
803   }
804 
805   function getPlayerSpaceshipUpgradesById(uint256 _tokenId) public view returns (bytes5) {
806     return spaceships[_tokenId].upgrades;
807   }
808 
809   /* Getters getSpaceshipProduct* */
810   function getSpaceshipProductPriceByModel(uint16 _model) public view returns (uint256) {
811     return spaceshipProducts[_model].price;
812   }
813 
814   function getSpaceshipProductClassByModel(uint16 _model) public view returns (uint16) {
815     return spaceshipProducts[_model].class;
816   }
817 
818   function getSpaceshipProductTotalSoldByModel(uint16 _model) public view returns (uint256) {
819     return spaceshipProducts[_model].totalSold;
820   }
821 
822   function getSpaceshipProductAttributesByModel(uint16 _model) public view returns (bytes8) {
823     return spaceshipProducts[_model].attributes;
824   }
825 
826   function getSpaceshipProductCount() public view returns (uint16) {
827     return spaceshipProductCount;
828   }
829 
830   /* Getters getSpaceship* */
831   function getSpaceshipTotalSold() public view returns (uint256) {
832     return super.totalSupply();
833   }
834 
835   /* Getters Spaceship Upgrades */
836   function getSpaceshipUpgradePriceByModel(uint16 _model, uint8 _position) public view returns (uint256) {
837     return upgradeContract.getSpaceshipUpgradePriceByModel(_model, _position);
838   }
839 
840   function getSpaceshipUpgradeTotalSoldByModel(uint16 _model, uint8 _position) public view returns (uint256) {
841     return upgradeContract.getSpaceshipUpgradeTotalSoldByModel(_model, _position);
842   }
843 
844   function getSpaceshipUpgradeCount() public view returns (uint256) {
845     return upgradeContract.getSpaceshipUpgradeCount();
846   }
847 
848 }