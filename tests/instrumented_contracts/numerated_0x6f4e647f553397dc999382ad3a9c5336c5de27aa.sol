1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Owned {
47   // The addresses of the accounts (or contracts) that can execute actions within each roles.
48   address public ceoAddress;
49   address public cooAddress;
50   address private newCeoAddress;
51   address private newCooAddress;
52 
53   function Owned() public {
54       ceoAddress = msg.sender;
55       cooAddress = msg.sender;
56   }
57 
58   /*** ACCESS MODIFIERS ***/
59   /// @dev Access modifier for CEO-only functionality
60   modifier onlyCEO() {
61     require(msg.sender == ceoAddress);
62     _;
63   }
64 
65   /// @dev Access modifier for COO-only functionality
66   modifier onlyCOO() {
67     require(msg.sender == cooAddress);
68     _;
69   }
70 
71   /// Access modifier for contract owner only functionality
72   modifier onlyCLevel() {
73     require(
74       msg.sender == ceoAddress ||
75       msg.sender == cooAddress
76     );
77     _;
78   }
79 
80   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
81   /// @param _newCEO The address of the new CEO
82   function setCEO(address _newCEO) public onlyCEO {
83     require(_newCEO != address(0));
84     newCeoAddress = _newCEO;
85   }
86 
87   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
88   /// @param _newCOO The address of the new COO
89   function setCOO(address _newCOO) public onlyCEO {
90     require(_newCOO != address(0));
91     newCooAddress = _newCOO;
92   }
93 
94   function acceptCeoOwnership() public {
95       require(msg.sender == newCeoAddress);
96       require(address(0) != newCeoAddress);
97       ceoAddress = newCeoAddress;
98       newCeoAddress = address(0);
99   }
100 
101   function acceptCooOwnership() public {
102       require(msg.sender == newCooAddress);
103       require(address(0) != newCooAddress);
104       cooAddress = newCooAddress;
105       newCooAddress = address(0);
106   }
107 
108 }
109 
110 // ----------------------------------------------------------------------------
111 // ERC Token Standard #20 Interface
112 // https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol
113 // ----------------------------------------------------------------------------
114 contract YouCollectBase is Owned {
115   using SafeMath for uint256;
116 
117   /*** CONSTANTS ***/
118   string public constant NAME = "Crypto - YouCollect";
119   string public constant SYMBOL = "CYC";
120   uint8 public constant DECIMALS = 18;  
121 
122   uint256 public totalSupply;
123   uint256 constant private MAX_UINT256 = 2**256 - 1;
124   mapping (address => uint256) public balances;
125   mapping (address => mapping (address => uint256)) public allowed;
126 
127   event Transfer(address indexed _from, address indexed _to, uint256 _value); 
128   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129 
130   /// @dev Required for ERC-20 compliance.
131   function name() public pure returns (string) {
132     return NAME;
133   }
134 
135   /// @dev Required for ERC-20 compliance.
136   function symbol() public pure returns (string) {
137     return SYMBOL;
138   }
139   /// @dev Required for ERC-20 compliance.
140   function decimals() public pure returns (uint8) {
141     return DECIMALS;
142   }
143 
144   function transfer(address _to, uint256 _value) public returns (bool success) {
145       require(balances[msg.sender] >= _value);
146       balances[msg.sender] -= _value;
147       balances[_to] += _value;
148       Transfer(msg.sender, _to, _value);
149       return true;
150   }
151 
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
153       uint256 allowance = allowed[_from][msg.sender];
154       require(balances[_from] >= _value && allowance >= _value);
155       balances[_to] += _value;
156       balances[_from] -= _value;
157       if (allowance < MAX_UINT256) {
158           allowed[_from][msg.sender] -= _value;
159       }
160       Transfer(_from, _to, _value);
161       return true;
162   }
163 
164   function balanceOf(address _owner) public view returns (uint256 balance) {
165       return balances[_owner];
166   }
167 
168   function approve(address _spender, uint256 _value) public returns (bool success) {
169       allowed[msg.sender][_spender] = _value;
170       Approval(msg.sender, _spender, _value);
171       return true;
172   }
173 
174   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
175       allowed[msg.sender][_spender] = _value;
176       Approval(msg.sender, _spender, _value);
177 
178       require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
179       return true;
180   }
181 
182   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
183       return allowed[_owner][_spender];
184   }   
185 
186 
187   // Payout
188   function payout(address _to) public onlyCLevel {
189     _payout(_to, this.balance);
190   }
191   function payout(address _to, uint amount) public onlyCLevel {
192     if (amount>this.balance)
193       amount = this.balance;
194     _payout(_to, amount);
195   }
196   function _payout(address _to, uint amount) private {
197     if (_to == address(0)) {
198       ceoAddress.transfer(amount);
199     } else {
200       _to.transfer(amount);
201     }
202   }
203 }
204 
205 contract ERC721YC is YouCollectBase {
206   /*** STORAGE ***/
207   uint256[] public tokens;
208   mapping (uint => bool) public unlocked;
209 
210   /// @dev A mapping from collectible IDs to the address that owns them. All collectibles have
211   ///  some valid owner address.
212   mapping (uint256 => address) public tokenIndexToOwner;
213 
214   /// @dev A mapping from CollectibleIDs to an address that has been approved to call
215   ///  transferFrom(). Each Collectible can only have one approved address for transfer
216   ///  at any time. A zero value means no approval is outstanding.
217   mapping (uint256 => address) public tokenIndexToApproved;
218 
219   // @dev A mapping from CollectibleIDs to the price of the token.
220   mapping (uint256 => uint256) public tokenIndexToPrice;
221 
222   /*** EVENTS ***/
223   /// @dev The Birth event is fired whenever a new collectible comes into existence.
224   event Birth(uint256 tokenId, uint256 startPrice);
225   /// @dev The TokenSold event is fired whenever a token is sold.
226   event TokenSold(uint256 indexed tokenId, uint256 price, address prevOwner, address winner);
227   // ERC721 Transfer
228   event TransferToken(address indexed from, address indexed to, uint256 tokenId);
229   // ERC721 Approval
230   event ApprovalToken(address indexed owner, address indexed approved, uint256 tokenId);
231 
232   /*** PUBLIC FUNCTIONS ***/
233   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
234   /// @param _to The address to be granted transfer approval. Pass address(0) to
235   ///  clear all approvals.
236   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
237   /// @dev Required for ERC-721 compliance.
238   function approveToken(
239     address _to,
240     uint256 _tokenId
241   ) public {
242     // Caller must own token.
243     require(_ownsToken(msg.sender, _tokenId));
244 
245     tokenIndexToApproved[_tokenId] = _to;
246 
247     ApprovalToken(msg.sender, _to, _tokenId);
248   }
249 
250 
251   function getTotalTokenSupply() public view returns (uint) {
252     return tokens.length;
253   }
254 
255   function implementsERC721YC() public pure returns (bool) {
256     return true;
257   }
258 
259 
260   /// For querying owner of token
261   /// @param _tokenId The tokenID for owner inquiry
262   /// @dev Required for ERC-721 compliance.
263   function ownerOf(uint256 _tokenId)
264     public
265     view
266     returns (address owner)
267   {
268     owner = tokenIndexToOwner[_tokenId];
269   }
270 
271 
272   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
273     price = tokenIndexToPrice[_tokenId];
274     if (price == 0)
275       price = getInitialPriceOfToken(_tokenId);
276   }
277 
278 
279   /// @notice Allow pre-approved user to take ownership of a token
280   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
281   /// @dev Required for ERC-721 compliance.
282   function takeOwnership(uint256 _tokenId) public {
283     address newOwner = msg.sender;
284     address oldOwner = tokenIndexToOwner[_tokenId];
285 
286     // Safety check to prevent against an unexpected 0x0 default.
287     require(_addressNotNull(newOwner));
288 
289     // Making sure transfer is approved
290     require(_approved(newOwner, _tokenId));
291 
292     _transferToken(oldOwner, newOwner, _tokenId);
293   }
294 
295   /// Owner initates the transfer of the token to another account
296   /// @param _to The address for the token to be transferred to.
297   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
298   /// @dev Required for ERC-721 compliance.
299   function transferToken(
300     address _to,
301     uint256 _tokenId
302   ) public {
303     require(_ownsToken(msg.sender, _tokenId));
304     require(_addressNotNull(_to));
305 
306     _transferToken(msg.sender, _to, _tokenId);
307   }
308 
309   /// Third-party initiates transfer of token from address _from to address _to
310   /// @param _from The address for the token to be transferred from.
311   /// @param _to The address for the token to be transferred to.
312   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
313   /// @dev Required for ERC-721 compliance.
314   function transferTokenFrom(
315     address _from,
316     address _to,
317     uint256 _tokenId
318   ) public {
319     require(_ownsToken(_from, _tokenId));
320     require(_approved(_to, _tokenId));
321     require(_addressNotNull(_to));
322 
323     _transferToken(_from, _to, _tokenId);
324   }
325 
326   /*** PRIVATE FUNCTIONS ***/
327   /// Safety check on _to address to prevent against an unexpected 0x0 default.
328   function _addressNotNull(address _to) private pure returns (bool) {
329     return _to != address(0);
330   }
331 
332   /// For checking approval of transfer for address _to
333   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
334     return tokenIndexToApproved[_tokenId] == _to;
335   }
336 
337   /// For creating Collectible
338   function _createCollectible(uint256 tokenId, uint256 _price) internal {
339     tokenIndexToPrice[tokenId] = _price;
340     Birth(tokenId, _price);
341     tokens.push(tokenId);
342     unlocked[tokenId] = true;
343   }
344 
345   /// Check for token ownership
346   function _ownsToken(address claimant, uint256 _tokenId) public view returns (bool) {
347     return claimant == tokenIndexToOwner[_tokenId];
348   }
349 
350 
351   // allows owners of tokens to decrease the price of them or if there is no owner the coo can do it
352   bool isTokenChangePriceLocked = true;
353   function changeTokenPrice(uint256 newPrice, uint256 _tokenId) public {
354     require((_ownsToken(msg.sender, _tokenId) && !isTokenChangePriceLocked) || (_ownsToken(address(0), _tokenId) && msg.sender == cooAddress));
355     require(newPrice<tokenIndexToPrice[_tokenId]);
356     tokenIndexToPrice[_tokenId] = newPrice;
357   }
358   function unlockToken(uint tokenId) public onlyCOO {
359     unlocked[tokenId] = true;
360   }
361   function unlockTokenPriceChange() public onlyCOO {
362     isTokenChangePriceLocked = false;
363   }
364   function isChangePriceLocked() public view returns (bool) {
365     return isTokenChangePriceLocked;
366   }
367 
368 
369   /// create Tokens for Token Owners in alpha Game
370   function createPromoCollectible(uint256 tokenId, address _owner, uint256 _price) public onlyCOO {
371     require(tokenIndexToOwner[tokenId]==address(0));
372 
373     address collectibleOwner = _owner;
374     if (collectibleOwner == address(0)) {
375       collectibleOwner = cooAddress;
376     }
377 
378     if (_price <= 0) {
379       _price = getInitialPriceOfToken(tokenId);
380     }
381 
382     _createCollectible(tokenId, _price);
383     // This will assign ownership, and also emit the Transfer event as
384     // per ERC721 draft
385     _transferToken(address(0), collectibleOwner, tokenId);
386 
387   }
388 
389 
390   /// For querying balance of a particular account
391   /// @param _owner The address for balance query
392   /// @dev Required for ERC-721 compliance.
393   function tokenBalanceOf(address _owner) public view returns (uint256 result) {
394       uint256 totalTokens = tokens.length;
395       uint256 tokenIndex;
396       uint256 tokenId;
397       result = 0;
398       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
399         tokenId = tokens[tokenIndex];
400         if (tokenIndexToOwner[tokenId] == _owner) {
401           result = result.add(1);
402         }
403       }
404       return result;
405   }
406 
407   /// @dev Assigns ownership of a specific Collectible to an address.
408   function _transferToken(address _from, address _to, uint256 _tokenId) internal {
409     //transfer ownership
410     tokenIndexToOwner[_tokenId] = _to;
411 
412     // When creating new collectibles _from is 0x0, but we can't account that address.
413     if (_from != address(0)) {
414       // clear any previously approved ownership exchange
415       delete tokenIndexToApproved[_tokenId];
416     }
417 
418     // Emit the transfer event.
419     TransferToken(_from, _to, _tokenId);
420   }
421 
422 
423    /// @param _owner The owner whose celebrity tokens we are interested in.
424   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
425   ///  expensive (it walks the entire tokens array looking for tokens belonging to owner),
426   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
427   ///  not contract-to-contract calls.
428   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
429     uint256 tokenCount = balanceOf(_owner);
430     if (tokenCount == 0) {
431         // Return an empty array
432       return new uint256[](0);
433     } else {
434       uint256[] memory result = new uint256[](tokenCount);
435       uint256 totalTokens = getTotalTokenSupply();
436       uint256 resultIndex = 0;
437 
438       uint256 tokenIndex;
439       uint256 tokenId;
440       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
441         tokenId = tokens[tokenIndex];
442         if (tokenIndexToOwner[tokenId] == _owner) {
443           result[resultIndex] = tokenId;
444           resultIndex = resultIndex.add(1);
445         }
446       }
447       return result;
448     }
449   }
450 
451   /// @dev returns an array with all token ids
452   function getTokenIds() public view returns(uint256[]) {
453     return tokens;
454   }
455 
456   function getInitialPriceOfToken(uint tokenId) public pure returns (uint);
457 }
458 
459 contract CollectibleToken is ERC721YC {
460 
461   uint256 private constant STARTING_PRICE = 0.001 ether;
462 
463   uint256 private constant FIRST_STEP_LIMIT =  0.053613 ether;
464   uint256 private constant SECOND_STEP_LIMIT = 0.564957 ether;
465 
466   uint private constant MASTER_TOKEN_ID = 0;
467 
468   function CollectibleToken() public {
469     balances[msg.sender] = 10000000000000000000;
470     totalSupply = 10000000000000000000;
471 
472   }
473 
474   function getInitialPriceOfToken(uint _tokenId) public pure returns (uint) {
475     if (_tokenId > 0)
476       return STARTING_PRICE;
477     return 10 ether;
478   }
479 
480 
481   function getNextPrice(uint sellingPrice) public pure returns (uint) {
482     if (sellingPrice < FIRST_STEP_LIMIT) {
483       return sellingPrice.mul(200).div(93);
484     } else if (sellingPrice < SECOND_STEP_LIMIT) {
485       return sellingPrice.mul(120).div(93);
486     } else {
487       return sellingPrice.mul(115).div(93);
488     }
489   }
490 
491   /// @notice Returns all the relevant information about a specific collectible.
492   /// @param _tokenId The tokenId of the collectible of interest.
493   function getCollectible(uint256 _tokenId) public view returns (uint256 tokenId,
494     uint256 sellingPrice,
495     address owner,
496     uint256 nextSellingPrice
497   ) {
498     tokenId = _tokenId;
499     sellingPrice = tokenIndexToPrice[_tokenId];
500     owner = tokenIndexToOwner[_tokenId];
501 
502     if (sellingPrice == 0)
503       sellingPrice = getInitialPriceOfToken(_tokenId);
504 
505     nextSellingPrice = getNextPrice(sellingPrice);
506   }
507 
508   // Allows someone to send ether and obtain the token
509   function purchase(uint256 _tokenId) public payable {
510     address oldOwner = tokenIndexToOwner[_tokenId];
511     uint256 sellingPrice = tokenIndexToPrice[_tokenId];
512     require(oldOwner!=msg.sender || sellingPrice > 1 ether);
513 
514     if (sellingPrice == 0) {
515       sellingPrice = getInitialPriceOfToken(_tokenId);
516     }
517 
518     // Safety check to prevent against an unexpected 0x0 default.
519     require(msg.sender != address(0));
520 
521     require(msg.value >= sellingPrice);
522     uint256 purchaseExcess = msg.value.sub(sellingPrice);
523 
524     uint256 payment = sellingPrice.mul(93).div(100);
525     uint256 feeOnce = sellingPrice.sub(payment).div(7);
526 
527     tokenIndexToPrice[_tokenId] = getNextPrice(sellingPrice);
528 
529     // Transfers the Token
530     tokenIndexToOwner[_tokenId] = msg.sender;
531     TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
532     TransferToken(oldOwner, msg.sender, _tokenId);
533 
534     if (oldOwner != address(0)) {
535       // clear any previously approved ownership exchange
536       delete tokenIndexToApproved[_tokenId];
537       // Payment for old owner and new owner
538       _payoutMining(_tokenId, oldOwner, msg.sender);
539       if (sellingPrice > 3 ether)
540         levelUpMining(_tokenId);
541       oldOwner.transfer(payment);
542     } else {
543       require(unlocked[_tokenId]);
544       Birth(_tokenId, sellingPrice);
545       tokens.push(_tokenId);
546       createMineForToken(_tokenId);
547     }
548 
549     if (_tokenId > 0 && tokenIndexToOwner[MASTER_TOKEN_ID]!=address(0)) {
550       // Taxes for YouCollect-Token owner
551       tokenIndexToOwner[MASTER_TOKEN_ID].transfer(feeOnce);
552     }
553     // refund when paid too much
554     if (purchaseExcess>0)
555       msg.sender.transfer(purchaseExcess);
556   }
557   
558   
559   //
560   //  Mining
561   //
562     event MiningUpgrade(address indexed sender, uint indexed token, uint amount);
563     event MiningLevelup(address indexed sender, uint indexed token, uint power);
564     event MiningPayout(address indexed sender, uint indexed token, uint amount);
565     event MiningStolenPayout(address indexed sender, address indexed oldOwner, uint indexed token, uint amount);
566 
567     mapping (uint => uint) miningPower;
568     mapping (uint => uint) miningPushed;
569     mapping (uint => uint) miningNextLevelBreak;
570     mapping (uint => uint) miningLastPayoutBlock;
571 
572     uint earningsEachBlock = 173611111111111;
573     uint FIRST_MINING_LEVEL_COST = 1333333333333333333;
574 
575     function changeEarnings(uint amount) public onlyCOO {
576       earningsEachBlock = amount;
577       require(earningsEachBlock>0);
578     }
579 
580     function createMineForToken(uint tokenId) private {
581       miningPower[tokenId] = 1;
582       miningNextLevelBreak[tokenId] = FIRST_MINING_LEVEL_COST;
583       miningLastPayoutBlock[tokenId] = block.number;
584     }
585     function createMineForToken(uint tokenId, uint power, uint xp, uint nextLevelBreak) public onlyCOO {
586       miningPower[tokenId] = power;
587       miningPushed[tokenId] = xp;
588       miningNextLevelBreak[tokenId] = nextLevelBreak;
589       miningLastPayoutBlock[tokenId] = block.number;
590     }
591 
592     function upgradeMining(uint tokenId, uint coins) public {
593       require(balanceOf(msg.sender)>=coins);
594       uint nextLevelBreak = miningNextLevelBreak[tokenId];
595       balances[msg.sender] -= coins;
596       uint xp = miningPushed[tokenId]+coins;
597       if (xp>nextLevelBreak) {
598         uint power = miningPower[tokenId];
599         if (miningLastPayoutBlock[tokenId] < block.number) {
600           _payoutMining(tokenId, ownerOf(tokenId));
601         }
602         while (xp>nextLevelBreak) {
603           nextLevelBreak = nextLevelBreak.mul(13).div(4);
604           power = power.mul(2);
605           MiningLevelup(msg.sender, tokenId, power);
606         }
607         miningNextLevelBreak[tokenId] = nextLevelBreak;
608         miningPower[tokenId] = power;
609       }
610       miningPushed[tokenId] = xp;
611       Transfer(msg.sender, this, coins);
612       MiningUpgrade(msg.sender, tokenId, coins);
613     }
614 
615     function levelUpMining(uint tokenId) private {
616       uint diffToNextLevel = getCostToNextLevel(tokenId);
617       miningNextLevelBreak[tokenId] = miningNextLevelBreak[tokenId].mul(13).div(4);
618       miningPushed[tokenId] = miningNextLevelBreak[tokenId].sub(diffToNextLevel);
619       miningPower[tokenId] = miningPower[tokenId].mul(2);
620       MiningLevelup(msg.sender, tokenId, miningPower[tokenId]);
621     }
622 
623     function payoutMining(uint tokenId) public {
624       require(_ownsToken(msg.sender, tokenId));
625       require(miningLastPayoutBlock[tokenId] < block.number);
626       _payoutMining(tokenId, msg.sender);
627     }
628 
629     function _payoutMining(uint tokenId, address owner) private {
630       uint coinsMined = block.number.sub(miningLastPayoutBlock[tokenId]).mul(earningsEachBlock).mul(miningPower[tokenId]);
631       miningLastPayoutBlock[tokenId] = block.number;
632       balances[owner] = balances[owner].add(coinsMined);
633       totalSupply = totalSupply.add(coinsMined);
634       MiningPayout(owner, tokenId, coinsMined);
635     }
636     function _payoutMining(uint tokenId, address owner, address newOwner) private {
637       uint coinsMinedHalf = block.number.sub(miningLastPayoutBlock[tokenId]).mul(earningsEachBlock).mul(miningPower[tokenId]).div(2);
638       miningLastPayoutBlock[tokenId] = block.number;
639       balances[owner] = balances[owner].add(coinsMinedHalf);
640       balances[newOwner] = balances[newOwner].add(coinsMinedHalf);
641       totalSupply = totalSupply.add(coinsMinedHalf.mul(2));
642       MiningStolenPayout(newOwner, owner, tokenId, coinsMinedHalf);
643     }
644 
645     function getCostToNextLevel(uint tokenId) public view returns (uint) {
646       return miningNextLevelBreak[tokenId]-miningPushed[tokenId];
647     }
648 
649     function getMiningMeta(uint tokenId) public view returns (uint earnEachBlock, uint mined, uint xp, uint nextLevelUp, uint lastPayoutBlock, uint power) {
650       earnEachBlock = miningPower[tokenId].mul(earningsEachBlock);
651       mined = block.number.sub(miningLastPayoutBlock[tokenId]).mul(earningsEachBlock).mul(miningPower[tokenId]);
652       xp = miningPushed[tokenId];
653       nextLevelUp = miningNextLevelBreak[tokenId];
654       lastPayoutBlock = miningLastPayoutBlock[tokenId];
655       power = miningPower[tokenId];
656     }
657 
658     function getCollectibleWithMeta(uint256 tokenId) public view returns (uint256 _tokenId, uint256 sellingPrice, address owner, uint256 nextSellingPrice, uint earnEachBlock, uint mined, uint xp, uint nextLevelUp, uint lastPayoutBlock, uint power) {
659       _tokenId = tokenId;
660       sellingPrice = tokenIndexToPrice[tokenId];
661       owner = tokenIndexToOwner[tokenId];
662       if (sellingPrice == 0)
663         sellingPrice = getInitialPriceOfToken(tokenId);
664 
665       nextSellingPrice = getNextPrice(sellingPrice);
666       earnEachBlock = miningPower[tokenId].mul(earningsEachBlock);
667       uint lastMinedBlock = miningLastPayoutBlock[tokenId];
668       mined = block.number.sub(lastMinedBlock).mul(earningsEachBlock).mul(miningPower[tokenId]);
669       xp = miningPushed[tokenId];
670       nextLevelUp = miningNextLevelBreak[tokenId];
671       lastPayoutBlock = miningLastPayoutBlock[tokenId];
672       power = miningPower[tokenId];
673     }
674     function getEarnEachBlock() public view returns (uint) {
675       return earningsEachBlock;
676     }
677 
678     /// create Tokens for Token Owners in alpha Game
679     function createPromoCollectibleWithMining(uint256 tokenId, address _owner, uint256 _price, uint256 power, uint256 xp, uint256 nextLevelBreak) public onlyCOO {
680       require(tokenIndexToOwner[tokenId]==address(0));
681 
682       address collectibleOwner = _owner;
683       if (collectibleOwner == address(0)) {
684         collectibleOwner = cooAddress;
685       }
686 
687       if (_price <= 0) {
688         _price = getInitialPriceOfToken(tokenId);
689       }
690 
691       _createCollectible(tokenId, _price);
692       createMineForToken(tokenId, power, xp, nextLevelBreak);
693       // This will assign ownership, and also emit the Transfer event as
694       // per ERC721 draft
695       _transferToken(address(0), collectibleOwner, tokenId);
696 
697     }
698 
699     /// create Tokens for Token Owners in alpha Game
700     function createPromoCollectiblesWithMining(uint256[] tokenId, address[] _owner, uint256[] _price, uint256[] power, uint256[] xp, uint256[] nextLevelBreak) public onlyCOO {
701       address collectibleOwner;
702       for (uint i = 0; i < tokenId.length; i++) {
703         require(tokenIndexToOwner[tokenId[i]]==address(0));
704 
705         collectibleOwner = _owner[i];
706         if (collectibleOwner == address(0)) {
707           collectibleOwner = cooAddress;
708         }
709 
710         if (_price[i] <= 0) {
711           _createCollectible(tokenId[i], getInitialPriceOfToken(tokenId[i]));
712         } else {
713           _createCollectible(tokenId[i], _price[i]);
714         }
715 
716         createMineForToken(tokenId[i], power[i], xp[i], nextLevelBreak[i]);
717         // This will assign ownership, and also emit the Transfer event as
718         // per ERC721 draft
719         _transferToken(address(0), collectibleOwner, tokenId[i]);
720       }
721 
722     }
723   //
724   //  Mining end
725   //
726 }