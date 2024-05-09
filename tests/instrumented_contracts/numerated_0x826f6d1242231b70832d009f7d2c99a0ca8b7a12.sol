1 pragma solidity ^0.4.18; 
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint256 _tokenId) public view returns (address addr);
12   function takeOwnership(uint256 _tokenId) public;
13   function totalSupply() public view returns (uint256 total);
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   function transfer(address _to, uint256 _tokenId) public;
16 
17   event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 
20   // Optional
21   // function name() public view returns (string name);
22   // function symbol() public view returns (string symbol);
23   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
24   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
25 }
26 
27 
28 contract CryptoPoosToken is ERC721 {
29 
30   // Modified CryptoCelebs contract
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new poo comes into existence.
34   event Birth(uint256 tokenId, string name, address owner);
35 
36   /// @dev The TokenSold event is fired whenever a token is sold.
37   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
38 
39   /// @dev Transfer event as defined in current draft of ERC721. 
40   ///  ownership is assigned, including births.
41   event Transfer(address from, address to, uint256 tokenId);
42 
43   // Triggered on toilet flush
44   event ToiletPotChange();
45 
46   /*** CONSTANTS ***/
47 
48   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
49   string public constant NAME = "CryptoPoos"; // solhint-disable-line
50   string public constant SYMBOL = "CryptoPoosToken"; // solhint-disable-line
51 
52   uint256 private startingPrice = 0.005 ether;
53   uint256 private constant PROMO_CREATION_LIMIT = 5000;
54   
55   // Min price to flush the toilet
56   uint256 private minFlushPrice = 0.002 ether;
57 
58 
59   /*** STORAGE ***/
60 
61   /// @dev A mapping from poo IDs to the address that owns them. All poos have
62   ///  some valid owner address.
63   mapping (uint256 => address) public pooIndexToOwner;
64 
65   // @dev A mapping from owner address to count of tokens that address owns.
66   //  Used internally inside balanceOf() to resolve ownership count.
67   mapping (address => uint256) private ownershipTokenCount;
68 
69   /// @dev A mapping from PooIDs to an address that has been approved to call
70   ///  transferFrom(). Each poo can only have one approved address for transfer
71   ///  at any time. A zero value means no approval is outstanding.
72   mapping (uint256 => address) public pooIndexToApproved;
73 
74   // @dev A mapping from PooIDs to the price of the token.
75   mapping (uint256 => uint256) private pooIndexToPrice;
76   
77   // The addresses of the accounts (or contracts) that can execute actions within each roles.
78   address public ceoAddress;
79   address public cooAddress;
80   
81   uint256 roundCounter;
82   address lastFlusher;   // Person that flushed
83   uint256 flushedTokenId;   // Poo that got flushed
84   uint256 lastPotSize; //Stores last pot size obviously
85   uint256 goldenPooId; // Current golden poo id
86   uint public lastPurchaseTime; // Tracks time since last purchase
87 
88   /*** DATATYPES ***/
89   struct Poo {
90     string name;
91   }
92 
93   Poo[] private poos;
94 
95   /*** ACCESS MODIFIERS ***/
96   /// @dev Access modifier for CEO-only functionality
97   modifier onlyCEO() {
98     require(msg.sender == ceoAddress);
99     _;
100   }
101 
102   /// @dev Access modifier for COO-only functionality
103   modifier onlyCOO() {
104     require(msg.sender == cooAddress);
105     _;
106   }
107 
108   /// Access modifier for contract owner only functionality
109   modifier onlyCLevel() {
110     require(
111       msg.sender == ceoAddress ||
112       msg.sender == cooAddress
113     );
114     _;
115   }
116 
117   /*** CONSTRUCTOR ***/
118   function CryptoPoosToken() public {
119     ceoAddress = msg.sender;
120     cooAddress = msg.sender;
121 	
122 	createContractPoo("1");
123 	createContractPoo("2");
124 	createContractPoo("3");
125 	createContractPoo("4");
126 	createContractPoo("5");
127 	createContractPoo("6");
128 	roundCounter = 1;
129   }
130 
131   /*** PUBLIC FUNCTIONS ***/
132   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
133   /// @param _to The address to be granted transfer approval. Pass address(0) to
134   ///  clear all approvals.
135   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
136   /// @dev Required for ERC-721 compliance.
137   function approve(
138     address _to,
139     uint256 _tokenId
140   ) public {
141     // Caller must own token.
142     require(_owns(msg.sender, _tokenId));
143 
144     pooIndexToApproved[_tokenId] = _to;
145 
146     Approval(msg.sender, _to, _tokenId);
147   }
148 
149   /// For querying balance of a particular account
150   /// @param _owner The address for balance query
151   /// @dev Required for ERC-721 compliance.
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return ownershipTokenCount[_owner];
154   }
155 
156   /// @dev Creates a new poo with the given name.
157   function createContractPoo(string _name) public onlyCOO {
158     _createPoo(_name, address(this), startingPrice);
159   }
160 
161   /// @notice Returns all the relevant information about a specific poo.
162   /// @param _tokenId The tokenId of the poo of interest.
163   function getPoo(uint256 _tokenId) public view returns (
164     string pooName,
165     uint256 sellingPrice,
166     address owner
167   ) {
168     Poo storage poo = poos[_tokenId];
169     pooName = poo.name;
170     sellingPrice = pooIndexToPrice[_tokenId];
171     owner = pooIndexToOwner[_tokenId];
172   }
173 
174   function getRoundDetails() public view returns (
175     uint256 currentRound,
176 	uint256 currentBalance,
177 	uint256 currentGoldenPoo,
178 	uint256 lastRoundReward,
179     uint256 lastFlushedTokenId,
180     address lastRoundFlusher,
181 	bool bonusWinChance,
182 	uint256 lowestFlushPrice
183   ) {
184 	currentRound = roundCounter;
185 	currentBalance = this.balance;
186 	currentGoldenPoo = goldenPooId;
187 	lastRoundReward = lastPotSize;
188 	lastFlushedTokenId = flushedTokenId;
189 	lastRoundFlusher = lastFlusher;
190 	bonusWinChance = _increaseWinPotChance();
191 	lowestFlushPrice = minFlushPrice;
192   }
193 
194   function implementsERC721() public pure returns (bool) {
195     return true;
196   }
197 
198   /// @dev Required for ERC-721 compliance.
199   function name() public pure returns (string) {
200     return NAME;
201   }
202 
203   /// For querying owner of token
204   /// @param _tokenId The tokenID for owner inquiry
205   /// @dev Required for ERC-721 compliance.
206   function ownerOf(uint256 _tokenId)
207     public
208     view
209     returns (address owner)
210   {
211     owner = pooIndexToOwner[_tokenId];
212     require(owner != address(0));
213   }
214 
215    function donate() public payable {
216 	require(msg.value >= 0.001 ether);
217    }
218 
219 
220   // Allows someone to send ether and obtain the token
221   function purchase(uint256 _tokenId) public payable {
222     address oldOwner = pooIndexToOwner[_tokenId];
223     address newOwner = msg.sender;
224 
225     uint256 sellingPrice = pooIndexToPrice[_tokenId];
226 
227     // Making sure token owner is not sending to self
228     require(oldOwner != newOwner);
229 
230     // Safety check to prevent against an unexpected 0x0 default.
231     require(_addressNotNull(newOwner));
232 
233     // Making sure sent amount is greater than or equal to the sellingPrice
234     require(msg.value >= sellingPrice);
235 
236     // 62% to previous owner
237     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 62), 100));
238   
239     // 8% to the jew
240     ceoAddress.transfer(uint256(SafeMath.div(SafeMath.mul(sellingPrice, 8), 100)));
241 
242 	// 30% goes to the pot
243 
244     // Next token price is double
245      pooIndexToPrice[_tokenId] = uint256(SafeMath.mul(sellingPrice, 2));
246 
247     _transfer(oldOwner, newOwner, _tokenId);
248 	
249     // Pay previous tokenOwner if owner is not contract
250     if (oldOwner != address(this)) {
251       oldOwner.transfer(payment); 
252     }
253 
254     _checkToiletFlush(false, _tokenId); 
255 	lastPurchaseTime = now;
256 	ToiletPotChange();
257   }
258   
259   // User is trying to flush the toilet. See if they succeed
260   function tryFlush() public payable {
261 
262         // Make sure they are sending min flush price
263         require(msg.value >= minFlushPrice);
264 
265 		// Jew takes 10% of manual flush attempt. Stops dat spam....
266 		ceoAddress.transfer(uint256(SafeMath.div(SafeMath.mul(msg.value, 10), 100)));
267 
268         _checkToiletFlush(true, 0);
269 		lastPurchaseTime = now;
270 		ToiletPotChange();
271   }
272   
273   // If manual flush attempt, the user has a chance to flush their own poo
274  function _checkToiletFlush(bool _manualFlush, uint256 _purchasedTokenId) private {
275      
276     uint256 winningChance = 25;
277 
278 	// We are calling manual flush option, so the chance of winning is less
279 	if(_manualFlush){
280 		winningChance = 50;
281 	}else if(_purchasedTokenId == goldenPooId){
282 		// If buying golden poo, and is not a manual flush, increase chance of winning!
283 		winningChance = uint256(SafeMath.div(SafeMath.mul(winningChance, 90), 100));
284 	}
285 
286 	// Check if we are trippling chance to win on next flush attempt/poop purchase
287 	if(_increaseWinPotChance()){
288 		winningChance = uint256(SafeMath.div(winningChance,3));
289 	}
290      
291     // Check if owner owns a poo. If not, their chance of winning is lower
292     if(ownershipTokenCount[msg.sender] == 0){
293         winningChance = uint256(SafeMath.mul(winningChance,2));
294     }
295      
296     uint256 flushPooIndex = rand(winningChance);
297     
298     if( (flushPooIndex < 6) && (flushPooIndex != goldenPooId) &&  (msg.sender != pooIndexToOwner[flushPooIndex])  ){
299       lastFlusher = msg.sender;
300 	  flushedTokenId = flushPooIndex;
301       
302       _transfer(pooIndexToOwner[flushPooIndex],address(this),flushPooIndex);
303       pooIndexToPrice[flushPooIndex] = startingPrice;
304       
305       // Leave 5% behind for next pot
306 	  uint256 reward = uint256(SafeMath.div(SafeMath.mul(this.balance, 95), 100));
307 	  lastPotSize = reward;
308 
309       msg.sender.transfer(reward); // Send reward to purchaser
310 	  goldenPooId = rand(6);// There is a new golden poo in town.
311 
312 	  roundCounter += 1; // Keeps track of how many flushes
313     }
314   }
315 
316   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
317     return pooIndexToPrice[_tokenId];
318   }
319 
320   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
321   /// @param _newCEO The address of the new CEO
322   function setCEO(address _newCEO) public onlyCEO {
323     require(_newCEO != address(0));
324 
325     ceoAddress = _newCEO;
326   }
327 
328   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
329   /// @param _newCOO The address of the new COO
330   function setCOO(address _newCOO) public onlyCEO {
331     require(_newCOO != address(0));
332 
333     cooAddress = _newCOO;
334   }
335 
336   // If 2 hours elapsed since last purchase, increase chance of winning pot.
337   function _increaseWinPotChance() constant private returns (bool) {
338     if (now >= lastPurchaseTime + 120 minutes) {
339         // 120 minutes has elapsed from last purchased time
340         return true;
341     }
342     return false;
343 }
344 
345   /// @dev Required for ERC-721 compliance.
346   function symbol() public pure returns (string) {
347     return SYMBOL;
348   }
349 
350   /// @notice Allow pre-approved user to take ownership of a token
351   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
352   /// @dev Required for ERC-721 compliance.
353   function takeOwnership(uint256 _tokenId) public {
354     address newOwner = msg.sender;
355     address oldOwner = pooIndexToOwner[_tokenId];
356 
357     // Safety check to prevent against an unexpected 0x0 default.
358     require(_addressNotNull(newOwner));
359 
360     // Making sure transfer is approved
361     require(_approved(newOwner, _tokenId));
362 
363     _transfer(oldOwner, newOwner, _tokenId);
364   }
365 
366   /// @param _owner The owner whose social media tokens we are interested in.
367   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
368   ///  expensive (it walks the entire poos array looking for poos belonging to owner),
369   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
370   ///  not contract-to-contract calls.
371   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
372     uint256 tokenCount = balanceOf(_owner);
373     if (tokenCount == 0) {
374         // Return an empty array
375       return new uint256[](0);
376     } else {
377       uint256[] memory result = new uint256[](tokenCount);
378       uint256 totalPoos = totalSupply();
379       uint256 resultIndex = 0;
380 
381       uint256 pooId;
382       for (pooId = 0; pooId <= totalPoos; pooId++) {
383         if (pooIndexToOwner[pooId] == _owner) {
384           result[resultIndex] = pooId;
385           resultIndex++;
386         }
387       }
388       return result;
389     }
390   }
391 
392   /// For querying totalSupply of token
393   /// @dev Required for ERC-721 compliance.
394   function totalSupply() public view returns (uint256 total) {
395     return poos.length;
396   }
397 
398   /// Owner initates the transfer of the token to another account
399   /// @param _to The address for the token to be transferred to.
400   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
401   /// @dev Required for ERC-721 compliance.
402   function transfer(
403     address _to,
404     uint256 _tokenId
405   ) public {
406     require(_owns(msg.sender, _tokenId));
407     require(_addressNotNull(_to));
408 
409     _transfer(msg.sender, _to, _tokenId);
410   }
411 
412   /// Third-party initiates transfer of token from address _from to address _to
413   /// @param _from The address for the token to be transferred from.
414   /// @param _to The address for the token to be transferred to.
415   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
416   /// @dev Required for ERC-721 compliance.
417   function transferFrom(
418     address _from,
419     address _to,
420     uint256 _tokenId
421   ) public {
422     require(_owns(_from, _tokenId));
423     require(_approved(_to, _tokenId));
424     require(_addressNotNull(_to));
425 
426     _transfer(_from, _to, _tokenId);
427   }
428 
429   /*** PRIVATE FUNCTIONS ***/
430   /// Safety check on _to address to prevent against an unexpected 0x0 default.
431   function _addressNotNull(address _to) private pure returns (bool) {
432     return _to != address(0);
433   }
434 
435   /// For checking approval of transfer for address _to
436   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
437     return pooIndexToApproved[_tokenId] == _to;
438   }
439 
440   /// For creating Poo
441   function _createPoo(string _name, address _owner, uint256 _price) private {
442     Poo memory _poo = Poo({
443       name: _name
444     });
445     uint256 newPooId = poos.push(_poo) - 1;
446 
447     // It's probably never going to happen, 4 billion tokens are A LOT, but
448     // let's just be 100% sure we never let this happen.
449     require(newPooId == uint256(uint32(newPooId)));
450 
451     Birth(newPooId, _name, _owner);
452 
453     pooIndexToPrice[newPooId] = _price;
454 
455     // This will assign ownership, and also emit the Transfer event as
456     // per ERC721 draft
457     _transfer(address(0), _owner, newPooId);
458   }
459 
460   /// Check for token ownership
461   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
462     return claimant == pooIndexToOwner[_tokenId];
463   }
464 
465   /// @dev Assigns ownership of a specific Poo to an address.
466   function _transfer(address _from, address _to, uint256 _tokenId) private {
467     // Since the number of poos is capped to 2^32 we can't overflow this
468     ownershipTokenCount[_to]++;
469     //transfer ownership
470     pooIndexToOwner[_tokenId] = _to;
471 
472     // When creating new poos _from is 0x0, but we can't account that address.
473     if (_from != address(0)) {
474       ownershipTokenCount[_from]--;
475       // clear any previously approved ownership exchange
476       delete pooIndexToApproved[_tokenId];
477     }
478 
479     // Emit the transfer event.
480     Transfer(_from, _to, _tokenId);
481   }
482   
483     //Generate random number between 0 & max
484     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
485     function rand(uint max) constant private returns (uint256 result){
486         uint256 factor = FACTOR * 100 / max;
487         uint256 lastBlockNumber = block.number - 1;
488         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
489     
490         return uint256((uint256(hashVal) / factor)) % max;
491     }
492   
493 }
494 library SafeMath {
495 
496   /**
497   * @dev Multiplies two numbers, throws on overflow.
498   */
499   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
500     if (a == 0) {
501       return 0;
502     }
503     uint256 c = a * b;
504     assert(c / a == b);
505     return c;
506   }
507 
508   /**
509   * @dev Integer division of two numbers, truncating the quotient.
510   */
511   function div(uint256 a, uint256 b) internal pure returns (uint256) {
512     // assert(b > 0); // Solidity automatically throws when dividing by 0
513     uint256 c = a / b;
514     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
515     return c;
516   }
517 
518   /**
519   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
520   */
521   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
522     assert(b <= a);
523     return a - b;
524   }
525 
526   /**
527   * @dev Adds two numbers, throws on overflow.
528   */
529   function add(uint256 a, uint256 b) internal pure returns (uint256) {
530     uint256 c = a + b;
531     assert(c >= a);
532     return c;
533   }
534 }