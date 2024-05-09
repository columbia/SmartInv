1 pragma solidity ^0.4.24;
2 
3 /***
4  * http://apexTWO.online
5  * 100% Stolen and Copied from - https://apexONE.io
6  * If contract is borked, blame them, not me. I'm just a lowly brainless cloner "dev"
7  * Contracts are open sourced though right? So that makes this is fair right?
8  *
9  * apex Amorphous Solids - Amorphous Solids is an eternal smart contract game.
10  * 
11  * The solids are priced by number of faces.
12  * Price increases by 30% every flip.
13  * Over 4 hours price will fall to base.
14  * Holders after 4 hours with no flip can collect the holder fund.
15  * 
16  * 10% of rise buyer gets APX2 tokens in the apexTWO exchange.
17  * 5% of rise goes to holder fund.
18  * 5% of rise goes to team and promoters.
19  * The rest (110%) goes to previous owner.
20  * 
21  */
22 contract ERC721 {
23 
24   function approve(address _to, uint256 _tokenId) public;
25   function balanceOf(address _owner) public view returns (uint256 balance);
26   function implementsERC721() public pure returns (bool);
27   function ownerOf(uint256 _tokenId) public view returns (address addr);
28   function takeOwnership(uint256 _tokenId) public;
29   function totalSupply() public view returns (uint256 total);
30   function transferFrom(address _from, address _to, uint256 _tokenId) public;
31   function transfer(address _to, uint256 _tokenId) public;
32 
33   event Transfer(address indexed from, address indexed to, uint256 tokenId);
34   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
35 
36 }
37 
38 contract apexONEInterface {
39   function isStarted() public view returns (bool);
40   function buyFor(address _referredBy, address _customerAddress) public payable returns (uint256);
41 }
42 
43 contract apexAmorphousSolids is ERC721 {
44 
45   /*=================================
46   =            MODIFIERS            =
47   =================================*/
48 
49   /// @dev Access modifier for owner functions
50   modifier onlyOwner() {
51     require(msg.sender == contractOwner);
52     _;
53   }
54 
55   /// @dev Prevent contract calls.
56   modifier notContract() {
57     require(tx.origin == msg.sender);
58     _;
59   }
60 
61   /// @dev notPaused
62   modifier notPaused() {
63     require(paused == false);
64     _;
65   }
66 
67   /// @dev notGasbag
68   modifier notGasbag() {
69     require(tx.gasprice < 99999999999);
70     _;
71   }
72 
73   /* @dev notMoron (oops I forgot to take this out...)
74     modifier notMoron() {
75       require(msg.sender != 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01);
76       _;
77     }
78   */
79   
80   /*==============================
81   =            EVENTS            =
82   ==============================*/
83 
84   event onTokenSold(
85        uint256 indexed tokenId,
86        uint256 price,
87        address prevOwner,
88        address newOwner,
89        string name
90     );
91 
92 
93   /*==============================
94   =            CONSTANTS         =
95   ==============================*/
96 
97   string public constant NAME = "apex Amorphous Solids";
98   string public constant SYMBOL = "APXA";
99 
100   uint256 private increaseRatePercent =  130;
101   uint256 private devFeePercent =  5;
102   uint256 private bagHolderFundPercent =  5;
103   uint256 private exchangeTokenPercent =  10;
104   uint256 private previousOwnerPercent =  110;
105   uint256 private priceFallDuration =  8 hours;
106 
107   /*==============================
108   =            STORAGE           =
109   ==============================*/
110 
111   /// @dev A mapping from solid IDs to the address that owns them.
112   mapping (uint256 => address) public solidIndexToOwner;
113 
114   // @dev A mapping from owner address to count of tokens that address owns.
115   mapping (address => uint256) private ownershipTokenCount;
116 
117   /// @dev A mapping from SolidID to an address that has been approved to call
118   mapping (uint256 => address) public solidIndexToApproved;
119 
120   // @dev The address of the owner
121   address public contractOwner;
122 
123   // @dev Current dev fee
124   uint256 public currentDevFee = 0;
125 
126   // @dev The address of the exchange contract
127   address public apexONEaddress;
128 
129   // @dev paused
130   bool public paused;
131 
132   /*==============================
133   =            DATATYPES         =
134   ==============================*/
135 
136   struct Solid {
137     string name;
138     uint256 basePrice;
139     uint256 highPrice;
140     uint256 fallDuration;
141     uint256 saleTime; // when was sold last
142     uint256 bagHolderFund;
143   }
144 
145   Solid [6] public solids;
146 
147   constructor () public {
148 
149     contractOwner = msg.sender;
150     paused=true;
151 
152     Solid memory _Tetrahedron = Solid({
153             name: "Tetrahedron",
154             basePrice: 0.014 ether,
155             highPrice: 0.014 ether,
156             fallDuration: priceFallDuration,
157             saleTime: now,
158             bagHolderFund: 0
159             });
160 
161     solids[1] =  _Tetrahedron;
162 
163     Solid memory _Cube = Solid({
164             name: "Cube",
165             basePrice: 0.016 ether,
166             highPrice: 0.016 ether,
167             fallDuration: priceFallDuration,
168             saleTime: now,
169             bagHolderFund: 0
170             });
171 
172     solids[2] =  _Cube;
173 
174     Solid memory _Octahedron = Solid({
175             name: "Octahedron",
176             basePrice: 0.018 ether,
177             highPrice: 0.018 ether,
178             fallDuration: priceFallDuration,
179             saleTime: now,
180             bagHolderFund: 0
181             });
182 
183     solids[3] =  _Octahedron;
184 
185     Solid memory _Dodecahedron = Solid({
186             name: "Dodecahedron",
187             basePrice: 0.02 ether,
188             highPrice: 0.02 ether,
189             fallDuration: priceFallDuration,
190             saleTime: now,
191             bagHolderFund: 0
192             });
193 
194     solids[4] =  _Dodecahedron;
195 
196     Solid memory _Icosahedron = Solid({
197             name: "Icosahedron",
198             basePrice: 0.03 ether,
199             highPrice: 0.03 ether,
200             fallDuration: priceFallDuration,
201             saleTime: now,
202             bagHolderFund: 0
203             });
204 
205     solids[5] =  _Icosahedron;
206 
207     _transfer(0x0, contractOwner, 1);
208     _transfer(0x0, contractOwner, 2);
209     _transfer(0x0, contractOwner, 3);
210     _transfer(0x0, contractOwner, 4);
211     _transfer(0x0, contractOwner, 5);
212 
213   }
214 
215   /*** PUBLIC FUNCTIONS ***/
216   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
217   /// @param _to The address to be granted transfer approval. Pass address(0) to
218   ///  clear all approvals.
219   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
220   /// @dev Required for ERC-721 compliance.
221   function approve(
222     address _to,
223     uint256 _tokenId
224   ) public {
225     // Caller must own token.
226     require(_owns(msg.sender, _tokenId));
227 
228     solidIndexToApproved[_tokenId] = _to;
229 
230     emit Approval(msg.sender, _to, _tokenId);
231   }
232 
233   /// For querying balance of a particular account
234   /// @param _owner The address for balance query
235   /// @dev Required for ERC-721 compliance.
236   function balanceOf(address _owner) public view returns (uint256 balance) {
237     return ownershipTokenCount[_owner];
238   }
239 
240   /// @notice Returns all the relevant information about a specific solid.
241   /// @param _tokenId The tokenId of the solid of interest.
242   function getSolid(uint256 _tokenId) public view returns (
243     string solidName,
244     uint256 price,
245     address currentOwner,
246     uint256 bagHolderFund,
247     bool isBagFundAvailable
248   ) {
249     Solid storage solid = solids[_tokenId];
250     solidName = solid.name;
251     price = priceOf(_tokenId);
252     currentOwner = solidIndexToOwner[_tokenId];
253     bagHolderFund = solid.bagHolderFund;
254     isBagFundAvailable = now > (solid.saleTime + priceFallDuration);
255   }
256 
257   function implementsERC721() public pure returns (bool) {
258     return true;
259   }
260 
261   /// @dev Required for ERC-721 compliance.
262   function name() public pure returns (string) {
263     return NAME;
264   }
265 
266   /// For querying owner of token
267   /// @param _tokenId The tokenID for owner inquiry
268   /// @dev Required for ERC-721 compliance.
269   function ownerOf(uint256 _tokenId)
270     public
271     view
272     returns (address owner)
273   {
274     owner = solidIndexToOwner[_tokenId];
275     require(owner != address(0));
276   }
277 
278   // Allows someone to send ether and obtain the token
279   function purchase(uint256 _tokenId , address _referredBy) public payable notContract notPaused notGasbag /*notMoron*/ {
280 
281     address oldOwner = solidIndexToOwner[_tokenId];
282     address newOwner = msg.sender;
283 
284     uint256 currentPrice = priceOf(_tokenId);
285 
286     // Making sure token owner is not sending to self
287     require(oldOwner != newOwner);
288 
289     // Safety check to prevent against an unexpected 0x0 default.
290     require(_addressNotNull(newOwner));
291 
292     // Making sure sent amount is greater than or equal to the sellingPrice
293     require(msg.value >= currentPrice);
294 
295     uint256 previousOwnerGets = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),previousOwnerPercent);
296     uint256 exchangeTokensAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),exchangeTokenPercent);
297     uint256 devFeeAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),devFeePercent);
298     uint256 bagHolderFundAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),bagHolderFundPercent);
299 
300     currentDevFee = currentDevFee + devFeeAmount;
301 
302     if (exchangeContract.isStarted()) {
303         exchangeContract.buyFor.value(exchangeTokensAmount)(_referredBy, msg.sender);
304     }else{
305         // send excess back because exchange is not ready
306         msg.sender.transfer(exchangeTokensAmount);
307     }
308 
309     // do the sale
310     _transfer(oldOwner, newOwner, _tokenId);
311 
312     // set new price and saleTime
313     solids[_tokenId].highPrice = SafeMath.mul(SafeMath.div(currentPrice,100),increaseRatePercent);
314     solids[_tokenId].saleTime = now;
315     solids[_tokenId].bagHolderFund+=bagHolderFundAmount;
316 
317     // Pay previous tokenOwner if owner is not contract
318     if (oldOwner != address(this)) {
319       if (oldOwner.send(previousOwnerGets)){}
320     }
321 
322     emit onTokenSold(_tokenId, currentPrice, oldOwner, newOwner, solids[_tokenId].name);
323 
324   }
325 
326   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
327 
328     Solid storage solid = solids[_tokenId];
329     uint256 secondsPassed  = now - solid.saleTime;
330 
331     if (secondsPassed >= solid.fallDuration || solid.highPrice==solid.basePrice) {
332             return solid.basePrice;
333     }
334 
335     uint256 totalPriceChange = solid.highPrice - solid.basePrice;
336     uint256 currentPriceChange = totalPriceChange * secondsPassed /solid.fallDuration;
337     uint256 currentPrice = solid.highPrice - currentPriceChange;
338 
339     return currentPrice;
340   }
341 
342   function collectBagHolderFund(uint256 _tokenId) public notPaused {
343       require(msg.sender == solidIndexToOwner[_tokenId]);
344       uint256 bagHolderFund;
345       bool isBagFundAvailable = false;
346        (
347         ,
348         ,
349         ,
350         bagHolderFund,
351         isBagFundAvailable
352         ) = getSolid(_tokenId);
353         require(isBagFundAvailable && bagHolderFund > 0);
354         uint256 amount = bagHolderFund;
355         solids[_tokenId].bagHolderFund = 0;
356         msg.sender.transfer(amount);
357   }
358 
359 
360   /// @dev Required for ERC-721 compliance.
361   function symbol() public pure returns (string) {
362     return SYMBOL;
363   }
364 
365   /// @notice Allow pre-approved user to take ownership of a token
366   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
367   /// @dev Required for ERC-721 compliance.
368   function takeOwnership(uint256 _tokenId) public {
369     address newOwner = msg.sender;
370     address oldOwner = solidIndexToOwner[_tokenId];
371 
372     // Safety check to prevent against an unexpected 0x0 default.
373     require(_addressNotNull(newOwner));
374 
375     // Making sure transfer is approved
376     require(_approved(newOwner, _tokenId));
377 
378     _transfer(oldOwner, newOwner, _tokenId);
379   }
380 
381   /// @param _owner The owner whose tokens we are interested in.
382   /// @dev This method MUST NEVER be called by smart contract code.
383   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
384     uint256 tokenCount = balanceOf(_owner);
385     if (tokenCount == 0) {
386         // Return an empty array
387       return new uint256[](0);
388     } else {
389       uint256[] memory result = new uint256[](tokenCount);
390       uint256 totalTokens = totalSupply();
391       uint256 resultIndex = 0;
392 
393       uint256 tokenId;
394       for (tokenId = 0; tokenId <= totalTokens; tokenId++) {
395         if (solidIndexToOwner[tokenId] == _owner) {
396           result[resultIndex] = tokenId;
397           resultIndex++;
398         }
399       }
400       return result;
401     }
402   }
403 
404   /// For querying totalSupply of token
405   /// @dev Required for ERC-721 compliance.
406   function totalSupply() public view returns (uint256 total) {
407     return 5;
408   }
409 
410   /// Owner initates the transfer of the token to another account
411   /// @param _to The address for the token to be transferred to.
412   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
413   /// @dev Required for ERC-721 compliance.
414   function transfer(
415     address _to,
416     uint256 _tokenId
417   ) public {
418     require(_owns(msg.sender, _tokenId));
419     require(_addressNotNull(_to));
420 
421     _transfer(msg.sender, _to, _tokenId);
422   }
423 
424   /// Third-party initiates transfer of token from address _from to address _to
425   /// @param _from The address for the token to be transferred from.
426   /// @param _to The address for the token to be transferred to.
427   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
428   /// @dev Required for ERC-721 compliance.
429   function transferFrom(
430     address _from,
431     address _to,
432     uint256 _tokenId
433   ) public {
434     require(_owns(_from, _tokenId));
435     require(_approved(_to, _tokenId));
436     require(_addressNotNull(_to));
437 
438     _transfer(_from, _to, _tokenId);
439   }
440 
441   /*** PRIVATE FUNCTIONS ***/
442   /// Safety check on _to address to prevent against an unexpected 0x0 default.
443   function _addressNotNull(address _to) private pure returns (bool) {
444     return _to != address(0);
445   }
446 
447   /// For checking approval of transfer for address _to
448   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
449     return solidIndexToApproved[_tokenId] == _to;
450   }
451 
452   /// Check for token ownership
453   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
454     return claimant == solidIndexToOwner[_tokenId];
455   }
456 
457   /// @dev Assigns ownership of a specific token to an address.
458   function _transfer(address _from, address _to, uint256 _tokenId) private {
459 
460     // no transfer to contract
461     uint length;
462     assembly { length := extcodesize(_to) }
463     require (length == 0);
464 
465     ownershipTokenCount[_to]++;
466     //transfer ownership
467     solidIndexToOwner[_tokenId] = _to;
468 
469     if (_from != address(0)) {
470       ownershipTokenCount[_from]--;
471       // clear any previously approved ownership exchange
472       delete solidIndexToApproved[_tokenId];
473     }
474 
475     // Emit the transfer event.
476     emit Transfer(_from, _to, _tokenId);
477   }
478 
479   /// @dev Not a charity
480   function collectDevFees() public onlyOwner {
481       if (currentDevFee < address(this).balance){
482          uint256 amount = currentDevFee;
483          currentDevFee = 0;
484          contractOwner.transfer(amount);
485       }
486   }
487 
488   /// @dev Interface to exchange
489    apexONEInterface public exchangeContract;
490 
491   function setExchangeAddresss(address _address) public onlyOwner {
492     exchangeContract = apexONEInterface(_address);
493     apexONEaddress = _address;
494    }
495 
496    /// @dev stop and start
497    function setPaused(bool _paused) public onlyOwner {
498      paused = _paused;
499     }
500 
501 }
502 
503 
504 /**
505  * @title SafeMath
506  * @dev Math operations with safety checks that throw on error
507  */
508 library SafeMath {
509 
510     /**
511     * @dev Multiplies two numbers, throws on overflow.
512     */
513     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
514         if (a == 0) {
515             return 0;
516         }
517         uint256 c = a * b;
518         assert(c / a == b);
519         return c;
520     }
521 
522     /**
523     * @dev Integer division of two numbers, truncating the quotient.
524     */
525     function div(uint256 a, uint256 b) internal pure returns (uint256) {
526         // assert(b > 0); // Solidity automatically throws when dividing by 0
527         uint256 c = a / b;
528         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
529         return c;
530     }
531 
532     /**
533     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
534     */
535     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536         assert(b <= a);
537         return a - b;
538     }
539 
540     /**
541     * @dev Adds two numbers, throws on overflow.
542     */
543     function add(uint256 a, uint256 b) internal pure returns (uint256) {
544         uint256 c = a + b;
545         assert(c >= a);
546         return c;
547     }
548 
549 }