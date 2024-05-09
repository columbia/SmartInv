1 pragma solidity ^0.4.2;
2 
3 // @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 // @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6   	// Required methods
7   	function approve(address _to, uint256 _tokenId) public;
8   	function balanceOf(address _owner) public view returns (uint256 balance);
9   	function implementsERC721() public pure returns (bool);
10   	function ownerOf(uint256 _tokenId) public view returns (address addr);
11   	function takeOwnership(uint256 _tokenId) public;
12   	function totalSupply() public view returns (uint256 total);
13   	function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   	function transfer(address _to, uint256 _tokenId) public;
15 	
16   	event Transfer(address indexed from, address indexed to, uint256 tokenId);
17   	event Approval(address indexed owner, address indexed approved, uint256 tokenId);
18 }
19 
20 contract Elements is ERC721 {
21 
22   	/*** EVENTS ***/
23   	// @dev The Birth event is fired whenever a new element comes into existence.
24   	event Birth(uint256 tokenId, string name, address owner);
25 
26   	// @dev The TokenSold event is fired whenever a token is sold.
27   	event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
28 
29   	// @dev Transfer event as defined in current draft of ERC721. Ownership is assigned, including births.
30   	event Transfer(address from, address to, uint256 tokenId);
31 
32   	/*** CONSTANTS, VARIABLES ***/
33 
34 	// @notice Name and symbol of the non fungible token, as defined in ERC721.
35 	string public constant NAME = "CryptoElements"; // solhint-disable-line
36 	string public constant SYMBOL = "CREL"; // solhint-disable-line
37 
38   	uint256 private periodicStartingPrice = 5 ether;
39   	uint256 private elementStartingPrice = 0.005 ether;
40   	uint256 private scientistStartingPrice = 0.1 ether;
41   	uint256 private specialStartingPrice = 0.05 ether;
42 
43   	uint256 private firstStepLimit =  0.05 ether;
44   	uint256 private secondStepLimit = 0.75 ether;
45   	uint256 private thirdStepLimit = 3 ether;
46 
47   	bool private periodicTableExists = false;
48 
49   	uint256 private elementCTR = 0;
50   	uint256 private scientistCTR = 0;
51   	uint256 private specialCTR = 0;
52 
53   	uint256 private constant elementSTART = 1;
54   	uint256 private constant scientistSTART = 1000;
55   	uint256 private constant specialSTART = 10000;
56 
57   	uint256 private constant specialLIMIT = 5000;
58 
59   	/*** STORAGE ***/
60 
61   	// @dev A mapping from element IDs to the address that owns them. All elements have
62   	//  some valid owner address.
63   	mapping (uint256 => address) public elementIndexToOwner;
64 
65   	// @dev A mapping from owner address to count of tokens that address owns.
66   	//  Used internally inside balanceOf() to resolve ownership count.
67   	mapping (address => uint256) private ownershipTokenCount;
68 
69   	// @dev A mapping from ElementIDs to an address that has been approved to call
70   	//  transferFrom(). Each Element can only have one approved address for transfer
71   	//  at any time. A zero value means no approval is outstanding.
72   	mapping (uint256 => address) public elementIndexToApproved;
73 
74   	// @dev A mapping from ElementIDs to the price of the token.
75   	mapping (uint256 => uint256) private elementIndexToPrice;
76 
77   	// The addresses of the accounts (or contracts) that can execute actions within each roles.
78   	address public ceoAddress;
79   	address public cooAddress;
80 
81   	/*** DATATYPES ***/
82   	struct Element {
83   		uint256 tokenId;
84     	string name;
85     	uint256 scientistId;
86   	}
87 
88   	mapping(uint256 => Element) elements;
89 
90   	uint256[] tokens;
91 
92   	/*** ACCESS MODIFIERS ***/
93   	// @dev Access modifier for CEO-only functionality
94   	modifier onlyCEO() {
95     	require(msg.sender == ceoAddress);
96     	_;
97   	}
98 
99   	// @dev Access modifier for COO-only functionality
100   	modifier onlyCOO() {
101   	  require(msg.sender == cooAddress);
102   	  _;
103   	}
104 
105   	// Access modifier for contract owner only functionality
106   	modifier onlyCLevel() {
107   	  	require(
108   	    	msg.sender == ceoAddress ||
109   	    	msg.sender == cooAddress
110   	  	);
111   	  	_;
112   	}
113 
114   	/*** CONSTRUCTOR ***/
115   	function Elements() public {
116   	  	ceoAddress = msg.sender;
117   	  	cooAddress = msg.sender;
118 
119   	  	createContractPeriodicTable("Periodic");
120   	}
121 
122   	/*** PUBLIC FUNCTIONS ***/
123   	// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
124   	// @param _to The address to be granted transfer approval. Pass address(0) to
125   	//  clear all approvals.
126   	// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
127   	// @dev Required for ERC-721 compliance.
128   	function approve(address _to, uint256 _tokenId) public {
129   	  	// Caller must own token.
130   	  	require(_owns(msg.sender, _tokenId));
131 	
132 	  	elementIndexToApproved[_tokenId] = _to;
133 	
134 	  	Approval(msg.sender, _to, _tokenId);
135   	}
136 
137   	// For querying balance of a particular account
138   	// @param _owner The address for balance query
139   	// @dev Required for ERC-721 compliance.
140   	function balanceOf(address _owner) public view returns (uint256 balance) {
141     	return ownershipTokenCount[_owner];
142   	}
143 
144   	// @notice Returns all the relevant information about a specific element.
145   	// @param _tokenId The tokenId of the element of interest.
146   	function getElement(uint256 _tokenId) public view returns (
147   		uint256 tokenId,
148     	string elementName,
149     	uint256 sellingPrice,
150     	address owner,
151     	uint256 scientistId
152   	) {
153     	Element storage element = elements[_tokenId];
154     	tokenId = element.tokenId;
155     	elementName = element.name;
156     	sellingPrice = elementIndexToPrice[_tokenId];
157     	owner = elementIndexToOwner[_tokenId];
158     	scientistId = element.scientistId;
159   	}
160 
161   	function implementsERC721() public pure returns (bool) {
162     	return true;
163   	}
164 
165   	// For querying owner of token
166   	// @param _tokenId The tokenID for owner inquiry
167   	// @dev Required for ERC-721 compliance.
168   	function ownerOf(uint256 _tokenId) public view returns (address owner) {
169     	owner = elementIndexToOwner[_tokenId];
170     	require(owner != address(0));
171   	}
172 
173   	function payout(address _to) public onlyCLevel {
174     	_payout(_to);
175   	}
176 
177   	// Allows someone to send ether and obtain the token
178   	function purchase(uint256 _tokenId) public payable {
179     	address oldOwner = elementIndexToOwner[_tokenId];
180     	address newOwner = msg.sender;
181 
182     	uint256 sellingPrice = elementIndexToPrice[_tokenId];
183     	// Making sure token owner is not sending to self
184     	require(oldOwner != newOwner);
185     	require(sellingPrice > 0);
186 
187     	// Safety check to prevent against an unexpected 0x0 default.
188     	require(_addressNotNull(newOwner));
189 
190     	// Making sure sent amount is greater than or equal to the sellingPrice
191     	require(msg.value >= sellingPrice);
192 
193     	uint256 ownerPayout = SafeMath.mul(SafeMath.div(sellingPrice, 100), 96);
194     	uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
195     	uint256	feeOnce = SafeMath.div(SafeMath.sub(sellingPrice, ownerPayout), 4);
196     	uint256 fee_for_dev = SafeMath.mul(feeOnce, 2);
197 
198     	// Pay previous tokenOwner if owner is not contract
199     	// and if previous price is not 0
200     	if (oldOwner != address(this)) {
201       		// old owner gets entire initial payment back
202       		oldOwner.transfer(ownerPayout);
203     	} else {
204       		fee_for_dev = SafeMath.add(fee_for_dev, ownerPayout);
205     	}
206 
207     	// Taxes for Periodic Table owner
208 	    if (elementIndexToOwner[0] != address(this)) {
209 	    	elementIndexToOwner[0].transfer(feeOnce);
210 	    } else {
211 	    	fee_for_dev = SafeMath.add(fee_for_dev, feeOnce);
212 	    }
213 
214 	    // Taxes for Scientist Owner for given Element
215 	    uint256 scientistId = elements[_tokenId].scientistId;
216 
217 	    if ( scientistId != scientistSTART ) {
218 	    	if (elementIndexToOwner[scientistId] != address(this)) {
219 		    	elementIndexToOwner[scientistId].transfer(feeOnce);
220 		    } else {
221 		    	fee_for_dev = SafeMath.add(fee_for_dev, feeOnce);
222 		    }
223 	    } else {
224 	    	fee_for_dev = SafeMath.add(fee_for_dev, feeOnce);
225 	    }
226 	        
227     	if (purchaseExcess > 0) {
228     		msg.sender.transfer(purchaseExcess);
229     	}
230 
231     	ceoAddress.transfer(fee_for_dev);
232 
233     	_transfer(oldOwner, newOwner, _tokenId);
234 
235     	//TokenSold(_tokenId, sellingPrice, elementIndexToPrice[_tokenId], oldOwner, newOwner, elements[_tokenId].name);
236     	// Update prices
237     	if (sellingPrice < firstStepLimit) {
238       		// first stage
239       		elementIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
240     	} else if (sellingPrice < secondStepLimit) {
241       		// second stage
242       		elementIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
243     	} else if (sellingPrice < thirdStepLimit) {
244     	  	// third stage
245       		elementIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 130), 100);
246     	} else {
247       		// fourth stage
248       		elementIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 100);
249     	}
250   	}
251 
252   	function priceOf(uint256 _tokenId) public view returns (uint256 price) {
253 	    return elementIndexToPrice[_tokenId];
254   	}
255 
256   	// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
257   	// @param _newCEO The address of the new CEO
258   	function setCEO(address _newCEO) public onlyCEO {
259 	    require(_newCEO != address(0));
260 
261     	ceoAddress = _newCEO;
262   	}
263 
264   	// @dev Assigns a new address to act as the COO. Only available to the current COO.
265   	// @param _newCOO The address of the new COO
266   	function setCOO(address _newCOO) public onlyCEO {
267     	require(_newCOO != address(0));
268     	cooAddress = _newCOO;
269   	}
270 
271   	// @notice Allow pre-approved user to take ownership of a token
272   	// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
273   	// @dev Required for ERC-721 compliance.
274   	function takeOwnership(uint256 _tokenId) public {
275     	address newOwner = msg.sender;
276     	address oldOwner = elementIndexToOwner[_tokenId];
277 
278     	// Safety check to prevent against an unexpected 0x0 default.
279     	require(_addressNotNull(newOwner));
280 
281     	// Making sure transfer is approved
282     	require(_approved(newOwner, _tokenId));
283 
284     	_transfer(oldOwner, newOwner, _tokenId);
285   	}
286 
287   	// @param _owner The owner whose element tokens we are interested in.
288   	// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
289   	//  expensive (it walks the entire Elements array looking for elements belonging to owner),
290   	//  but it also returns a dynamic array, which is only supported for web3 calls, and
291   	//  not contract-to-contract calls.
292   	function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
293     	uint256 tokenCount = balanceOf(_owner);
294     	if (tokenCount == 0) {
295         	// Return an empty array
296       		return new uint256[](0);
297     	} else {
298       		uint256[] memory result = new uint256[](tokenCount);
299       		uint256 totalElements = totalSupply();
300       		uint256 resultIndex = 0;
301       		uint256 elementId;
302       		for (elementId = 0; elementId < totalElements; elementId++) {
303       			uint256 tokenId = tokens[elementId];
304 
305 		        if (elementIndexToOwner[tokenId] == _owner) {
306 		          result[resultIndex] = tokenId;
307 		          resultIndex++;
308 		        }
309       		}
310       		return result;
311     	}
312   	}
313 
314   	// For querying totalSupply of token
315   	// @dev Required for ERC-721 compliance.
316   	function totalSupply() public view returns (uint256 total) {
317     	return tokens.length;
318   	}
319 
320   	// Owner initates the transfer of the token to another account
321   	// @param _to The address for the token to be transferred to.
322   	// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
323   	// @dev Required for ERC-721 compliance.
324   	function transfer( address _to, uint256 _tokenId ) public {
325    		require(_owns(msg.sender, _tokenId));
326     	require(_addressNotNull(_to));
327     	_transfer(msg.sender, _to, _tokenId);
328   	}
329 
330   	// Third-party initiates transfer of token from address _from to address _to
331   	// @param _from The address for the token to be transferred from.
332   	// @param _to The address for the token to be transferred to.
333   	// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
334   	// @dev Required for ERC-721 compliance.
335   	function transferFrom( address _from, address _to, uint256 _tokenId) public {
336     	require(_owns(_from, _tokenId));
337     	require(_approved(_to, _tokenId));
338     	require(_addressNotNull(_to));
339     	_transfer(_from, _to, _tokenId);
340   	}
341 
342   	/*** PRIVATE FUNCTIONS ***/
343   	// Safety check on _to address to prevent against an unexpected 0x0 default.
344   	function _addressNotNull(address _to) private pure returns (bool) {
345     	return _to != address(0);
346   	}
347 
348   	// For checking approval of transfer for address _to
349 	function _approved(address _to, uint256 _tokenId) private view returns (bool) {
350 		return elementIndexToApproved[_tokenId] == _to;
351 	}
352 
353   	// Private method for creating Element
354   	function _createElement(uint256 _id, string _name, address _owner, uint256 _price, uint256 _scientistId) private returns (string) {
355 
356     	uint256 newElementId = _id;
357     	// It's probably never going to happen, 4 billion tokens are A LOT, but
358     	// let's just be 100% sure we never let this happen.
359     	require(newElementId == uint256(uint32(newElementId)));
360 
361     	elements[_id] = Element(_id, _name, _scientistId);
362 
363     	Birth(newElementId, _name, _owner);
364 
365     	elementIndexToPrice[newElementId] = _price;
366 
367     	// This will assign ownership, and also emit the Transfer event as
368     	// per ERC721 draft
369     	_transfer(address(0), _owner, newElementId);
370 
371     	tokens.push(_id);
372 
373     	return _name;
374   	}
375 
376 
377   	// @dev Creates Periodic Table as first element
378   	function createContractPeriodicTable(string _name) public onlyCEO {
379   		require(periodicTableExists == false);
380 
381   		_createElement(0, _name, address(this), periodicStartingPrice, scientistSTART);
382   		periodicTableExists = true;
383   	}
384 
385   	// @dev Creates a new Element with the given name and Id
386   	function createContractElement(string _name, uint256 _scientistId) public onlyCEO {
387   		require(periodicTableExists == true);
388 
389     	uint256 _id = SafeMath.add(elementCTR, elementSTART);
390     	uint256 _scientistIdProcessed = SafeMath.add(_scientistId, scientistSTART);
391 
392     	_createElement(_id, _name, address(this), elementStartingPrice, _scientistIdProcessed);
393     	elementCTR = SafeMath.add(elementCTR, 1);
394   	}
395 
396   	// @dev Creates a new Scientist with the given name Id
397   	function createContractScientist(string _name) public onlyCEO {
398   		require(periodicTableExists == true);
399 
400   		// to start from 1001
401   		scientistCTR = SafeMath.add(scientistCTR, 1);
402     	uint256 _id = SafeMath.add(scientistCTR, scientistSTART);
403     	
404     	_createElement(_id, _name, address(this), scientistStartingPrice, scientistSTART);	
405   	}
406 
407   	// @dev Creates a new Special Card with the given name Id
408   	function createContractSpecial(string _name) public onlyCEO {
409   		require(periodicTableExists == true);
410   		require(specialCTR <= specialLIMIT);
411 
412   		// to start from 10001
413   		specialCTR = SafeMath.add(specialCTR, 1);
414     	uint256 _id = SafeMath.add(specialCTR, specialSTART);
415 
416     	_createElement(_id, _name, address(this), specialStartingPrice, scientistSTART);
417     	
418   	}
419 
420   	// Check for token ownership
421   	function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
422     	return claimant == elementIndexToOwner[_tokenId];
423   	}
424 
425 
426   	//**** HELPERS for checking elements, scientists and special cards
427   	function checkPeriodic() public view returns (bool) {
428   		return periodicTableExists;
429   	}
430 
431   	function getTotalElements() public view returns (uint256) {
432   		return elementCTR;
433   	}
434 
435   	function getTotalScientists() public view returns (uint256) {
436   		return scientistCTR;
437   	}
438 
439   	function getTotalSpecials() public view returns (uint256) {
440   		return specialCTR;
441   	}
442 
443   	//**** HELPERS for changing prices limits and steps if it would be bad, community would like different
444   	function changeStartingPricesLimits(uint256 _elementStartPrice, uint256 _scientistStartPrice, uint256 _specialStartPrice) public onlyCEO {
445   		elementStartingPrice = _elementStartPrice;
446   		scientistStartingPrice = _scientistStartPrice;
447   		specialStartingPrice = _specialStartPrice;
448 	}
449 
450 	function changeStepPricesLimits(uint256 _first, uint256 _second, uint256 _third) public onlyCEO {
451 		firstStepLimit = _first;
452 		secondStepLimit = _second;
453 		thirdStepLimit = _third;
454 	}
455 
456 	// in case of error when assigning scientist to given element
457 	function changeScientistForElement(uint256 _tokenId, uint256 _scientistId) public onlyCEO {
458     	Element storage element = elements[_tokenId];
459     	element.scientistId = SafeMath.add(_scientistId, scientistSTART);
460   	}
461 
462   	function changeElementName(uint256 _tokenId, string _name) public onlyCEO {
463     	Element storage element = elements[_tokenId];
464     	element.name = _name;
465   	}
466 
467   	// This function can be used by the owner of a token to modify the current price
468 	function modifyTokenPrice(uint256 _tokenId, uint256 _newPrice) public payable {
469 	    require(_newPrice > elementStartingPrice);
470 	    require(elementIndexToOwner[_tokenId] == msg.sender);
471 	    require(_newPrice < elementIndexToPrice[_tokenId]);
472 
473 	    if ( _tokenId == 0) {
474 	    	require(_newPrice > periodicStartingPrice);
475 	    } else if ( _tokenId < 1000) {
476 	    	require(_newPrice > elementStartingPrice);
477 	    } else if ( _tokenId < 10000 ) {
478 	    	require(_newPrice > scientistStartingPrice);
479 	    } else {
480 	    	require(_newPrice > specialStartingPrice);
481 	    }
482 
483 	    elementIndexToPrice[_tokenId] = _newPrice;
484 	}
485 
486   	// For paying out balance on contract
487   	function _payout(address _to) private {
488     	if (_to == address(0)) {
489       		ceoAddress.transfer(this.balance);
490     	} else {
491       		_to.transfer(this.balance);
492     	}
493   	}
494 
495   	// @dev Assigns ownership of a specific Element to an address.
496   	function _transfer(address _from, address _to, uint256 _tokenId) private {
497   	  	// Since the number of elements is capped to 2^32 we can't overflow this
498   	  	ownershipTokenCount[_to]++;
499   	  	//transfer ownership
500   	  	elementIndexToOwner[_tokenId] = _to;
501   	  	// When creating new elements _from is 0x0, but we can't account that address.
502   	  	if (_from != address(0)) {
503   	    	ownershipTokenCount[_from]--;
504   	    	// clear any previously approved ownership exchange
505   	    	delete elementIndexToApproved[_tokenId];
506   	  	}
507   	  	// Emit the transfer event.
508   	  	Transfer(_from, _to, _tokenId);
509   	}
510 }
511 
512 library SafeMath {
513 
514   	/**
515   	* @dev Multiplies two numbers, throws on overflow.
516   	*/
517 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
518 		if (a == 0) {
519 		  return 0;
520 		}
521 		uint256 c = a * b;
522 		assert(c / a == b);
523 		return c;
524 	}
525 
526   	/**
527   	* @dev Integer division of two numbers, truncating the quotient.
528   	*/
529   	function div(uint256 a, uint256 b) internal pure returns (uint256) {
530     	// assert(b > 0); // Solidity automatically throws when dividing by 0
531     	uint256 c = a / b;
532     	// assert(a == b * c + a % b); // There is no case in which this doesn't hold
533     	return c;
534   	}
535 
536   	/**
537   	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
538   	*/
539   	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
540     	assert(b <= a);
541     	return a - b;
542   	}
543 
544   	/**
545   	* @dev Adds two numbers, throws on overflow.
546   	*/
547   	function add(uint256 a, uint256 b) internal pure returns (uint256) {
548     	uint256 c = a + b;
549     	assert(c >= a);
550     	return c;
551   	}
552 }