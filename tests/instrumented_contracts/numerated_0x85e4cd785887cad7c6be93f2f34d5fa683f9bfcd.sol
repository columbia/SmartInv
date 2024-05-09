1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://apexONE.io
5  *
6  * apex Solids - Solids is an eternal smart contract game.
7  * 
8  * The solids are priced by number of faces.
9  * Price increases by 30% every flip.
10  * Over 4 hours price will fall to base.
11  * Holders after 4 hours with no flip can collect the holder fund.
12  * 
13  * 10% of rise buyer gets APX1 tokens in the apexONE exchange.
14  * 5% of rise goes to holder fund.
15  * 5% of rise goes to team and promoters.
16  * The rest (110%) goes to previous owner.
17  * 
18  */
19 contract ERC721 {
20 
21   function approve(address _to, uint256 _tokenId) public;
22   function balanceOf(address _owner) public view returns (uint256 balance);
23   function implementsERC721() public pure returns (bool);
24   function ownerOf(uint256 _tokenId) public view returns (address addr);
25   function takeOwnership(uint256 _tokenId) public;
26   function totalSupply() public view returns (uint256 total);
27   function transferFrom(address _from, address _to, uint256 _tokenId) public;
28   function transfer(address _to, uint256 _tokenId) public;
29 
30   event Transfer(address indexed from, address indexed to, uint256 tokenId);
31   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
32 
33 }
34 
35 contract apexONEInterface {
36   function isStarted() public view returns (bool);
37   function buyFor(address _referredBy, address _customerAddress) public payable returns (uint256);
38 }
39 
40 contract apexSolids is ERC721 {
41 
42   /*=================================
43   =            MODIFIERS            =
44   =================================*/
45 
46   /// @dev Access modifier for owner functions
47   modifier onlyOwner() {
48     require(msg.sender == contractOwner);
49     _;
50   }
51 
52   /// @dev Prevent contract calls.
53   modifier notContract() {
54     require(tx.origin == msg.sender);
55     _;
56   }
57 
58   /// @dev notPaused
59   modifier notPaused() {
60     require(paused == false);
61     _;
62   }
63 
64   /// @dev notGasbag
65   modifier notGasbag() {
66     require(tx.gasprice < 99999999999);
67     _;
68   }
69 
70   /* @dev notMoron (childish but fun)
71     modifier notMoron() {
72       require(msg.sender != 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01);
73       _;
74     }
75   */
76   
77   /*==============================
78   =            EVENTS            =
79   ==============================*/
80 
81   event onTokenSold(
82        uint256 indexed tokenId,
83        uint256 price,
84        address prevOwner,
85        address newOwner,
86        string name
87     );
88 
89 
90   /*==============================
91   =            CONSTANTS         =
92   ==============================*/
93 
94   string public constant NAME = "apex Solids";
95   string public constant SYMBOL = "APXS";
96 
97   uint256 private increaseRatePercent =  130;
98   uint256 private devFeePercent =  5;
99   uint256 private bagHolderFundPercent =  5;
100   uint256 private exchangeTokenPercent =  10;
101   uint256 private previousOwnerPercent =  110;
102   uint256 private priceFallDuration =  4 hours;
103 
104   /*==============================
105   =            STORAGE           =
106   ==============================*/
107 
108   /// @dev A mapping from solid IDs to the address that owns them.
109   mapping (uint256 => address) public solidIndexToOwner;
110 
111   // @dev A mapping from owner address to count of tokens that address owns.
112   mapping (address => uint256) private ownershipTokenCount;
113 
114   /// @dev A mapping from SolidID to an address that has been approved to call
115   mapping (uint256 => address) public solidIndexToApproved;
116 
117   // @dev The address of the owner
118   address public contractOwner;
119 
120   // @dev Current dev fee
121   uint256 public currentDevFee = 0;
122 
123   // @dev The address of the exchange contract
124   address public apexONEaddress;
125 
126   // @dev paused
127   bool public paused;
128 
129   /*==============================
130   =            DATATYPES         =
131   ==============================*/
132 
133   struct Solid {
134     string name;
135     uint256 basePrice;
136     uint256 highPrice;
137     uint256 fallDuration;
138     uint256 saleTime; // when was sold last
139     uint256 bagHolderFund;
140   }
141 
142   Solid [6] public solids;
143 
144   constructor () public {
145 
146     contractOwner = msg.sender;
147     paused=true;
148 
149     Solid memory _Tetrahedron = Solid({
150             name: "Tetrahedron",
151             basePrice: 0.014 ether,
152             highPrice: 0.014 ether,
153             fallDuration: priceFallDuration,
154             saleTime: now,
155             bagHolderFund: 0
156             });
157 
158     solids[1] =  _Tetrahedron;
159 
160     Solid memory _Cube = Solid({
161             name: "Cube",
162             basePrice: 0.016 ether,
163             highPrice: 0.016 ether,
164             fallDuration: priceFallDuration,
165             saleTime: now,
166             bagHolderFund: 0
167             });
168 
169     solids[2] =  _Cube;
170 
171     Solid memory _Octahedron = Solid({
172             name: "Octahedron",
173             basePrice: 0.018 ether,
174             highPrice: 0.018 ether,
175             fallDuration: priceFallDuration,
176             saleTime: now,
177             bagHolderFund: 0
178             });
179 
180     solids[3] =  _Octahedron;
181 
182     Solid memory _Dodecahedron = Solid({
183             name: "Dodecahedron",
184             basePrice: 0.02 ether,
185             highPrice: 0.02 ether,
186             fallDuration: priceFallDuration,
187             saleTime: now,
188             bagHolderFund: 0
189             });
190 
191     solids[4] =  _Dodecahedron;
192 
193     Solid memory _Icosahedron = Solid({
194             name: "Icosahedron",
195             basePrice: 0.03 ether,
196             highPrice: 0.03 ether,
197             fallDuration: priceFallDuration,
198             saleTime: now,
199             bagHolderFund: 0
200             });
201 
202     solids[5] =  _Icosahedron;
203 
204     _transfer(0x0, contractOwner, 1);
205     _transfer(0x0, contractOwner, 2);
206     _transfer(0x0, contractOwner, 3);
207     _transfer(0x0, contractOwner, 4);
208     _transfer(0x0, contractOwner, 5);
209 
210   }
211 
212   /*** PUBLIC FUNCTIONS ***/
213   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
214   /// @param _to The address to be granted transfer approval. Pass address(0) to
215   ///  clear all approvals.
216   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
217   /// @dev Required for ERC-721 compliance.
218   function approve(
219     address _to,
220     uint256 _tokenId
221   ) public {
222     // Caller must own token.
223     require(_owns(msg.sender, _tokenId));
224 
225     solidIndexToApproved[_tokenId] = _to;
226 
227     emit Approval(msg.sender, _to, _tokenId);
228   }
229 
230   /// For querying balance of a particular account
231   /// @param _owner The address for balance query
232   /// @dev Required for ERC-721 compliance.
233   function balanceOf(address _owner) public view returns (uint256 balance) {
234     return ownershipTokenCount[_owner];
235   }
236 
237   /// @notice Returns all the relevant information about a specific solid.
238   /// @param _tokenId The tokenId of the solid of interest.
239   function getSolid(uint256 _tokenId) public view returns (
240     string solidName,
241     uint256 price,
242     address currentOwner,
243     uint256 bagHolderFund,
244     bool isBagFundAvailable
245   ) {
246     Solid storage solid = solids[_tokenId];
247     solidName = solid.name;
248     price = priceOf(_tokenId);
249     currentOwner = solidIndexToOwner[_tokenId];
250     bagHolderFund = solid.bagHolderFund;
251     isBagFundAvailable = now > (solid.saleTime + priceFallDuration);
252   }
253 
254   function implementsERC721() public pure returns (bool) {
255     return true;
256   }
257 
258   /// @dev Required for ERC-721 compliance.
259   function name() public pure returns (string) {
260     return NAME;
261   }
262 
263   /// For querying owner of token
264   /// @param _tokenId The tokenID for owner inquiry
265   /// @dev Required for ERC-721 compliance.
266   function ownerOf(uint256 _tokenId)
267     public
268     view
269     returns (address owner)
270   {
271     owner = solidIndexToOwner[_tokenId];
272     require(owner != address(0));
273   }
274 
275   // Allows someone to send ether and obtain the token
276   function purchase(uint256 _tokenId , address _referredBy) public payable notContract notPaused notGasbag /*notMoron*/ {
277 
278     address oldOwner = solidIndexToOwner[_tokenId];
279     address newOwner = msg.sender;
280 
281     uint256 currentPrice = priceOf(_tokenId);
282 
283     // Making sure token owner is not sending to self
284     require(oldOwner != newOwner);
285 
286     // Safety check to prevent against an unexpected 0x0 default.
287     require(_addressNotNull(newOwner));
288 
289     // Making sure sent amount is greater than or equal to the sellingPrice
290     require(msg.value >= currentPrice);
291 
292     uint256 previousOwnerGets = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),previousOwnerPercent);
293     uint256 exchangeTokensAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),exchangeTokenPercent);
294     uint256 devFeeAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),devFeePercent);
295     uint256 bagHolderFundAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),bagHolderFundPercent);
296 
297     currentDevFee = currentDevFee + devFeeAmount;
298 
299     if (exchangeContract.isStarted()) {
300         exchangeContract.buyFor.value(exchangeTokensAmount)(_referredBy, msg.sender);
301     }else{
302         // send excess back because exchange is not ready
303         msg.sender.transfer(exchangeTokensAmount);
304     }
305 
306     // do the sale
307     _transfer(oldOwner, newOwner, _tokenId);
308 
309     // set new price and saleTime
310     solids[_tokenId].highPrice = SafeMath.mul(SafeMath.div(currentPrice,100),increaseRatePercent);
311     solids[_tokenId].saleTime = now;
312     solids[_tokenId].bagHolderFund+=bagHolderFundAmount;
313 
314     // Pay previous tokenOwner if owner is not contract
315     if (oldOwner != address(this)) {
316       if (oldOwner.send(previousOwnerGets)){}
317     }
318 
319     emit onTokenSold(_tokenId, currentPrice, oldOwner, newOwner, solids[_tokenId].name);
320 
321   }
322 
323   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
324 
325     Solid storage solid = solids[_tokenId];
326     uint256 secondsPassed  = now - solid.saleTime;
327 
328     if (secondsPassed >= solid.fallDuration || solid.highPrice==solid.basePrice) {
329             return solid.basePrice;
330     }
331 
332     uint256 totalPriceChange = solid.highPrice - solid.basePrice;
333     uint256 currentPriceChange = totalPriceChange * secondsPassed /solid.fallDuration;
334     uint256 currentPrice = solid.highPrice - currentPriceChange;
335 
336     return currentPrice;
337   }
338 
339   function collectBagHolderFund(uint256 _tokenId) public notPaused {
340       require(msg.sender == solidIndexToOwner[_tokenId]);
341       uint256 bagHolderFund;
342       bool isBagFundAvailable = false;
343        (
344         ,
345         ,
346         ,
347         bagHolderFund,
348         isBagFundAvailable
349         ) = getSolid(_tokenId);
350         require(isBagFundAvailable && bagHolderFund > 0);
351         uint256 amount = bagHolderFund;
352         solids[_tokenId].bagHolderFund = 0;
353         msg.sender.transfer(amount);
354   }
355 
356 
357   /// @dev Required for ERC-721 compliance.
358   function symbol() public pure returns (string) {
359     return SYMBOL;
360   }
361 
362   /// @notice Allow pre-approved user to take ownership of a token
363   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
364   /// @dev Required for ERC-721 compliance.
365   function takeOwnership(uint256 _tokenId) public {
366     address newOwner = msg.sender;
367     address oldOwner = solidIndexToOwner[_tokenId];
368 
369     // Safety check to prevent against an unexpected 0x0 default.
370     require(_addressNotNull(newOwner));
371 
372     // Making sure transfer is approved
373     require(_approved(newOwner, _tokenId));
374 
375     _transfer(oldOwner, newOwner, _tokenId);
376   }
377 
378   /// @param _owner The owner whose tokens we are interested in.
379   /// @dev This method MUST NEVER be called by smart contract code.
380   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
381     uint256 tokenCount = balanceOf(_owner);
382     if (tokenCount == 0) {
383         // Return an empty array
384       return new uint256[](0);
385     } else {
386       uint256[] memory result = new uint256[](tokenCount);
387       uint256 totalTokens = totalSupply();
388       uint256 resultIndex = 0;
389 
390       uint256 tokenId;
391       for (tokenId = 0; tokenId <= totalTokens; tokenId++) {
392         if (solidIndexToOwner[tokenId] == _owner) {
393           result[resultIndex] = tokenId;
394           resultIndex++;
395         }
396       }
397       return result;
398     }
399   }
400 
401   /// For querying totalSupply of token
402   /// @dev Required for ERC-721 compliance.
403   function totalSupply() public view returns (uint256 total) {
404     return 5;
405   }
406 
407   /// Owner initates the transfer of the token to another account
408   /// @param _to The address for the token to be transferred to.
409   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
410   /// @dev Required for ERC-721 compliance.
411   function transfer(
412     address _to,
413     uint256 _tokenId
414   ) public {
415     require(_owns(msg.sender, _tokenId));
416     require(_addressNotNull(_to));
417 
418     _transfer(msg.sender, _to, _tokenId);
419   }
420 
421   /// Third-party initiates transfer of token from address _from to address _to
422   /// @param _from The address for the token to be transferred from.
423   /// @param _to The address for the token to be transferred to.
424   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
425   /// @dev Required for ERC-721 compliance.
426   function transferFrom(
427     address _from,
428     address _to,
429     uint256 _tokenId
430   ) public {
431     require(_owns(_from, _tokenId));
432     require(_approved(_to, _tokenId));
433     require(_addressNotNull(_to));
434 
435     _transfer(_from, _to, _tokenId);
436   }
437 
438   /*** PRIVATE FUNCTIONS ***/
439   /// Safety check on _to address to prevent against an unexpected 0x0 default.
440   function _addressNotNull(address _to) private pure returns (bool) {
441     return _to != address(0);
442   }
443 
444   /// For checking approval of transfer for address _to
445   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
446     return solidIndexToApproved[_tokenId] == _to;
447   }
448 
449   /// Check for token ownership
450   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
451     return claimant == solidIndexToOwner[_tokenId];
452   }
453 
454   /// @dev Assigns ownership of a specific token to an address.
455   function _transfer(address _from, address _to, uint256 _tokenId) private {
456 
457     // no transfer to contract
458     uint length;
459     assembly { length := extcodesize(_to) }
460     require (length == 0);
461 
462     ownershipTokenCount[_to]++;
463     //transfer ownership
464     solidIndexToOwner[_tokenId] = _to;
465 
466     if (_from != address(0)) {
467       ownershipTokenCount[_from]--;
468       // clear any previously approved ownership exchange
469       delete solidIndexToApproved[_tokenId];
470     }
471 
472     // Emit the transfer event.
473     emit Transfer(_from, _to, _tokenId);
474   }
475 
476   /// @dev Not a charity
477   function collectDevFees() public onlyOwner {
478       if (currentDevFee < address(this).balance){
479          uint256 amount = currentDevFee;
480          currentDevFee = 0;
481          contractOwner.transfer(amount);
482       }
483   }
484 
485   /// @dev Interface to exchange
486    apexONEInterface public exchangeContract;
487 
488   function setExchangeAddresss(address _address) public onlyOwner {
489     exchangeContract = apexONEInterface(_address);
490     apexONEaddress = _address;
491    }
492 
493    /// @dev stop and start
494    function setPaused(bool _paused) public onlyOwner {
495      paused = _paused;
496     }
497 
498 }
499 
500 
501 /**
502  * @title SafeMath
503  * @dev Math operations with safety checks that throw on error
504  */
505 library SafeMath {
506 
507     /**
508     * @dev Multiplies two numbers, throws on overflow.
509     */
510     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
511         if (a == 0) {
512             return 0;
513         }
514         uint256 c = a * b;
515         assert(c / a == b);
516         return c;
517     }
518 
519     /**
520     * @dev Integer division of two numbers, truncating the quotient.
521     */
522     function div(uint256 a, uint256 b) internal pure returns (uint256) {
523         // assert(b > 0); // Solidity automatically throws when dividing by 0
524         uint256 c = a / b;
525         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
526         return c;
527     }
528 
529     /**
530     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
531     */
532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
533         assert(b <= a);
534         return a - b;
535     }
536 
537     /**
538     * @dev Adds two numbers, throws on overflow.
539     */
540     function add(uint256 a, uint256 b) internal pure returns (uint256) {
541         uint256 c = a + b;
542         assert(c >= a);
543         return c;
544     }
545 
546 }