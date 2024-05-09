1 pragma solidity ^0.4.19;
2 
3 
4 contract ERC721 {
5     // Required methods
6     function totalSupply() public view returns (uint256 total);
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     function ownerOf(uint256 _tokenId) external view returns (address owner);
9     function approve(address _to, uint256 _tokenId) external;
10     function transfer(address _to, uint256 _tokenId) external;
11     function transferFrom(address _from, address _to, uint256 _tokenId) external;
12     function takeOwnership(uint256 _tokenId) external;
13 
14     // Events
15     event Transfer(address from, address to, uint256 tokenId);
16     event Approval(address owner, address approved, uint256 tokenId);
17 
18     // Optional
19     // function name() public view returns (string name);
20     // function symbol() public view returns (string symbol);
21     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
22     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
23     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
24 }
25 
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33     address public owner;
34 
35     /**
36      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37      * account.
38      */
39     function Ownable() public{
40         owner = msg.sender;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner(){
47         require(msg.sender == owner);
48         _;
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) public onlyOwner{
56         require(newOwner != address(0));
57         owner = newOwner;
58     }
59 }
60 
61 
62 /**
63  * @title Pausable
64  * @dev Base contract which allows children to implement an emergency stop mechanism.
65  */
66 contract Pausable is Ownable {
67     event Pause();
68 
69     event Unpause();
70 
71     bool public paused = false;
72 
73     /**
74      * @dev modifier to allow actions only when the contract IS paused
75      */
76     modifier whenNotPaused(){
77         require(!paused);
78         _;
79     }
80 
81     /**
82      * @dev modifier to allow actions only when the contract IS NOT paused
83      */
84     modifier whenPaused{
85         require(paused);
86         _;
87     }
88 
89     /**
90      * @dev called by the owner to pause, triggers stopped state
91      */
92     function pause() public onlyOwner whenNotPaused {
93         paused = true;
94         Pause();
95     }
96 
97     /**
98      * @dev called by the owner to unpause, returns to normal state
99      */
100     function unpause() public onlyOwner whenPaused {
101         paused = false;
102         Unpause();
103     }
104 }
105 
106 library SafeMath {
107 
108   /**
109   * @dev Multiplies two numbers, throws on overflow.
110   */
111   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112     if (a == 0) {
113       return 0;
114     }
115     uint256 c = a * b;
116     assert(c / a == b);
117     return c;
118   }
119 
120   /**
121   * @dev Integer division of two numbers, truncating the quotient.
122   */
123   function div(uint256 a, uint256 b) internal pure returns (uint256) {
124     // assert(b > 0); // Solidity automatically throws when dividing by 0
125     uint256 c = a / b;
126     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127     return c;
128   }
129 
130   /**
131   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
132   */
133   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138   /**
139   * @dev Adds two numbers, throws on overflow.
140   */
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }
147 
148 
149 contract ChemistryBase is Ownable {
150     
151     struct Element{
152         bytes32 symbol;
153     }
154    
155     /*** EVENTS ***/
156 
157     event Create(address owner, uint256 atomicNumber, bytes32 symbol);
158     
159     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a element
160     ///  ownership is assigned.
161     event Transfer(address from, address to, uint256 tokenId);
162 
163     /*** CONSTANTS ***/
164     
165     // currently known number of elements in periodic table
166     uint256 public tableSize = 173;
167 
168     /*** STORAGE ***/
169 
170     /// @dev An array containing the element struct for all Elements in existence. The ID
171     ///  of each element is actually an index of this array.
172     Element[] public elements;
173 
174     /// @dev A mapping from element IDs to the address that owns them. All elements have
175     ///  some valid owner address, even miner elements are created with a non-zero owner.
176     mapping (uint256 => address) public elementToOwner;
177 
178     // @dev A mapping from owner address to count of tokens that address owns.
179     //  Used internally inside balanceOf() to resolve ownership count.
180     mapping (address => uint256) internal ownersTokenCount;
181 
182     /// @dev A mapping from element IDs to an address that has been approved to call
183     ///  transferFrom(). Each Element can only have one approved address for transfer
184     ///  at any time. A zero value means no approval is outstanding.
185     mapping (uint256 => address) public elementToApproved;
186     
187     mapping (address => bool) public authorized;
188     
189     mapping (uint256 => uint256) public currentPrice;
190     
191 	function addAuthorization (address _authorized) onlyOwner external {
192 		authorized[_authorized] = true;
193 	}
194 
195 	function removeAuthorization (address _authorized) onlyOwner external {
196 		delete authorized[_authorized];
197 	}
198 	
199 	modifier onlyAuthorized() {
200 		require(authorized[msg.sender]);
201 		_;
202 	}
203     
204     /// @dev Assigns ownership of a specific element to an address.
205     function _transfer(address _from, address _to, uint256 _tokenId) internal {
206         // Since the number of elements is capped to 'numberOfElements'(173) we can't overflow this
207         ownersTokenCount[_to]++;
208         // transfer ownership
209         elementToOwner[_tokenId] = _to;
210         // When creating new element _from is 0x0, but we can't account that address.
211         if (_from != address(0)) {
212             ownersTokenCount[_from]--;
213             // clear any previously approved ownership exchange
214             delete elementToApproved[_tokenId];
215         }
216         // Emit the transfer event.
217         Transfer(_from, _to, _tokenId);
218     }
219 
220     /// @dev An internal method that creates a new element and stores it. This
221     ///  method doesn't do any checking and should only be called when the
222     ///  input data is known to be valid. Will generate both a Arise event
223     ///  and a Transfer event.
224     function _createElement(bytes32 _symbol, uint256 _price)
225         internal
226         returns (uint256) {
227         	    
228         address owner = address(this);
229         Element memory _element = Element({
230             symbol : _symbol
231         });
232         uint256 newElementId = elements.push(_element) - 1;
233         
234         currentPrice[newElementId] = _price;
235         
236         // emit the create event
237         Create(owner, newElementId, _symbol);
238         
239         // This will assign ownership, and also emit the Transfer event as
240         // per ERC721 draft
241         _transfer(0, owner, newElementId);
242 
243         return newElementId;
244     }
245     
246     function setTableSize(uint256 _newSize) external onlyOwner {
247         tableSize = _newSize;
248     }
249     
250     function transferOwnership(address newOwner) public onlyOwner{
251         delete authorized[owner];
252         authorized[newOwner] = true;
253         super.transferOwnership(newOwner);
254     }
255 }
256 
257 contract ElementTokenImpl is ChemistryBase, ERC721 {
258 
259     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
260     string public constant name = "CryptoChemistry";
261     string public constant symbol = "CC";
262 
263     bytes4 constant InterfaceSignature_ERC165 =
264         bytes4(keccak256('supportsInterface(bytes4)'));
265 
266     bytes4 constant InterfaceSignature_ERC721 =
267         bytes4(keccak256('name()')) ^
268         bytes4(keccak256('symbol()')) ^
269         bytes4(keccak256('totalSupply()')) ^
270         bytes4(keccak256('balanceOf(address)')) ^
271         bytes4(keccak256('ownerOf(uint256)')) ^
272         bytes4(keccak256('approve(address,uint256)')) ^
273         bytes4(keccak256('transfer(address,uint256)')) ^
274         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
275         bytes4(keccak256('takeOwnership(uint256)')) ^
276         bytes4(keccak256('tokensOfOwner(address)'));
277 
278     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
279     ///  Returns true for any standardized interfaces implemented by this contract. We implement
280     ///  ERC-165 and ERC-721.
281     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
282     {
283         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
284     }
285 
286     /** @dev Checks if a given address is the current owner of the specified Element tokenId.
287      * @param _claimant the address we are validating against.
288      * @param _tokenId element id
289      */
290     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
291         return elementToOwner[_tokenId] == _claimant;    
292     }
293 
294     function _ownerApproved(address _claimant, uint256 _tokenId) internal view returns (bool) {
295         return elementToOwner[_tokenId] == _claimant && elementToApproved[_tokenId] == address(0);    
296     }
297 
298     /// @dev Checks if a given address currently has transferApproval for a particular element.
299     /// @param _claimant the address we are confirming element is approved for.
300     /// @param _tokenId element id
301     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
302         return elementToApproved[_tokenId] == _claimant;
303     }
304 
305     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
306     ///  approval. Setting _approved to address(0) clears all transfer approval.
307     ///  NOTE: _approve() does NOT send the Approval event.
308     function _approve(uint256 _tokenId, address _approved) internal {
309         elementToApproved[_tokenId] = _approved;
310     }
311 
312     /// @notice Returns the number of tokens owned by a specific address.
313     /// @param _owner The owner address to check.
314     /// @dev Required for ERC-721 compliance
315     function balanceOf(address _owner) public view returns (uint256 count) {
316         return ownersTokenCount[_owner];
317     }
318 
319     /// @notice Transfers a element to another address
320     /// @param _to The address of the recipient, can be a user or contract.
321     /// @param _tokenId The ID of the element to transfer.
322     /// @dev Required for ERC-721 compliance.
323     function transfer(address _to, uint256 _tokenId) external {
324         // Safety check to prevent against an unexpected 0x0 default.
325         require(_to != address(0));
326         // Disallow transfers to this contract to prevent accidental misuse.
327         require(_to != address(this));
328 
329         // You can only send your own element.
330         require(_owns(msg.sender, _tokenId));
331 
332         // Reassign ownership, clear pending approvals, emit Transfer event.
333         _transfer(msg.sender, _to, _tokenId);
334     }
335 
336     /// @notice Grant another address the right to transfer a specific element via
337     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
338     /// @param _to The address to be granted transfer approval. Pass address(0) to
339     ///  clear all approvals.
340     /// @param _tokenId The ID of the element that can be transferred if this call succeeds.
341     /// @dev Required for ERC-721 compliance.
342     function approve(address _to, uint256 _tokenId) external {
343         // Only an owner can grant transfer approval.
344         require(_owns(msg.sender, _tokenId));
345 
346         // Register the approval (replacing any previous approval).
347         _approve(_tokenId, _to);
348 
349         // Emit approval event.
350         Approval(msg.sender, _to, _tokenId);
351     }
352 
353     /// @notice Transfer a element owned by another address, for which the calling address
354     ///  has previously been granted transfer approval by the owner.
355     /// @param _from The address that owns the element to be transfered.
356     /// @param _to The address that should take ownership of the element. Can be any address,
357     ///  including the caller.
358     /// @param _tokenId The ID of the element to be transferred.
359     /// @dev Required for ERC-721 compliance.
360     function transferFrom(address _from, address _to, uint256 _tokenId)
361         external
362     {
363         // Safety check to prevent against an unexpected 0x0 default.
364         require(_to != address(0));
365         // Disallow transfers to this contract to prevent accidental misuse.
366         require(_to != address(this));
367         // Check for approval and valid ownership
368         require(_approvedFor(msg.sender, _tokenId));
369         require(_owns(_from, _tokenId));
370 
371         // Reassign ownership (also clears pending approvals and emits Transfer event).
372         _transfer(_from, _to, _tokenId);
373     }
374 
375     /// @notice Returns the total number of tokens currently in existence.
376     /// @dev Required for ERC-721 compliance.
377     function totalSupply() public view returns (uint256) {
378         return elements.length;
379     }
380 
381     /// @notice Returns the address currently assigned ownership of a given element.
382     /// @dev Required for ERC-721 compliance.
383     function ownerOf(uint256 _tokenId)
384         external
385         view
386         returns (address owner)
387     {
388         owner = elementToOwner[_tokenId];
389 
390         require(owner != address(0));
391     }
392     
393     function takeOwnership(uint256 _tokenId) external {
394         address _from = elementToOwner[_tokenId];
395         
396         // Check for approval and valid ownership
397         require(_approvedFor(msg.sender, _tokenId));
398         require(_from != address(0));
399 
400         // Reassign ownership (also clears pending approvals and emits Transfer event).
401         _transfer(_from, msg.sender, _tokenId);
402     }
403 
404     /// @notice Returns a list of all element IDs assigned to an address.
405     /// @param _owner The owner whose tokens we are interested in.
406     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
407         uint256 tokenCount = balanceOf(_owner);
408 
409         if (tokenCount == 0) {
410             // Return an empty array
411             return new uint256[](0);
412         } else {
413             uint256[] memory result = new uint256[](tokenCount);
414             uint256 totalElements = totalSupply();
415             uint256 resultIndex = 0;
416 
417             uint256 elementId;
418 
419             for (elementId = 0; elementId < totalElements; elementId++) {
420                 if (elementToOwner[elementId] == _owner) {
421                     result[resultIndex] = elementId;
422                     resultIndex++;
423                 }
424             }
425 
426             return result;
427         }
428     }
429     
430 }
431 
432 contract ContractOfSale is ElementTokenImpl {
433     using SafeMath for uint256;
434     
435   	event Sold (uint256 elementId, address oldOwner, address newOwner, uint256 price);
436   	
437   	uint256 private constant LIMIT_1 = 20 finney;
438   	uint256 private constant LIMIT_2 = 500 finney;
439   	uint256 private constant LIMIT_3 = 2000 finney;
440   	uint256 private constant LIMIT_4 = 5000 finney;
441   	
442   	/* Buying */
443   	function calculateNextPrice (uint256 _price) public pure returns (uint256 _nextPrice) {
444 	    if (_price < LIMIT_1) {
445 	      return _price.mul(2);//100%
446 	    } else if (_price < LIMIT_2) {
447 	      return _price.mul(13500).div(10000);//35%
448 	    } else if (_price < LIMIT_3) {
449 	      return _price.mul(12500).div(10000);//25%
450 	    } else if (_price < LIMIT_4) {
451 	      return _price.mul(11700).div(10000);//17%
452 	    } else {
453 	      return _price.mul(11500).div(10000);//15%
454 	    }
455   	}
456 
457 	function _calculateOwnerCut (uint256 _price) internal pure returns (uint256 _devCut) {
458 		if (_price < LIMIT_1) {
459 	      return _price.mul(1500).div(10000); // 15%
460 	    } else if (_price < LIMIT_2) {
461 	      return _price.mul(500).div(10000); // 5%
462 	    } else if (_price < LIMIT_3) {
463 	      return _price.mul(400).div(10000); // 4%
464 	    } else if (_price < LIMIT_4) {
465 	      return _price.mul(300).div(10000); // 3%
466 	    } else {
467 	      return _price.mul(200).div(10000); // 2%
468 	    }
469   	}
470 
471 	function buy (uint256 _itemId) external payable{
472         uint256 price = currentPrice[_itemId];
473 	    //
474         require(currentPrice[_itemId] > 0);
475         //
476         require(elementToOwner[_itemId] != address(0));
477         //
478         require(msg.value >= price);
479         //
480         require(elementToOwner[_itemId] != msg.sender);
481         //
482         require(msg.sender != address(0));
483         
484         address oldOwner = elementToOwner[_itemId];
485         //
486         address newOwner = msg.sender;
487         //
488         //
489         uint256 excess = msg.value.sub(price);
490         //
491         _transfer(oldOwner, newOwner, _itemId);
492         //
493         currentPrice[_itemId] = calculateNextPrice(price);
494         
495         Sold(_itemId, oldOwner, newOwner, price);
496 
497         uint256 ownerCut = _calculateOwnerCut(price);
498 
499         oldOwner.transfer(price.sub(ownerCut));
500         if (excess > 0) {
501             newOwner.transfer(excess);
502         }
503     }
504     
505 	function priceOfElement(uint256 _elementId) external view returns (uint256 _price) {
506 		return currentPrice[_elementId];
507 	}
508 
509 	function priceOfElements(uint256[] _elementIds) external view returns (uint256[] _prices) {
510 	    uint256 length = _elementIds.length;
511 	    _prices = new uint256[](length);
512 	    
513 	    for(uint256 i = 0; i < length; i++) {
514 	        _prices[i] = currentPrice[_elementIds[i]];
515 	    }
516 	}
517 
518 	function nextPriceOfElement(uint256 _itemId) public view returns (uint256 _nextPrice) {
519 		return calculateNextPrice(currentPrice[_itemId]);
520 	}
521 
522 }
523 
524 contract ChemistryCore is ContractOfSale {
525     
526     function ChemistryCore() public {
527         owner = msg.sender;
528         authorized[msg.sender] = true;
529         
530         _createElement("0", 2 ** 255);//philosophers stone is priceless
531     }
532     
533     function addElement(bytes32 _symbol) external onlyAuthorized() {
534         uint256 elementId = elements.length + 1;
535         
536         require(currentPrice[elementId] == 0);
537         require(elementToOwner[elementId] == address(0));
538         require(elementId <= tableSize + 1);
539         
540         _createElement(_symbol, 1 finney);
541     }
542     
543     function addElements(bytes32[] _symbols) external onlyAuthorized() {
544         uint256 elementId = elements.length + 1;
545         
546         uint256 length = _symbols.length;
547         uint256 size = tableSize + 1;
548         for(uint256 i = 0; i < length; i ++) {
549             
550             require(currentPrice[elementId] == 0);
551             require(elementToOwner[elementId] == address(0));
552             require(elementId <= size);
553             
554             _createElement(_symbols[i], 1 finney);
555             elementId++;
556         }
557         
558     }
559 
560     function withdrawAll() onlyOwner() external {
561         owner.transfer(this.balance);
562     }
563 
564     function withdrawAmount(uint256 _amount) onlyOwner() external {
565         owner.transfer(_amount);
566     }
567     
568     function() external payable {
569         require(msg.sender == address(this));
570     }
571     
572     function getElementsFromIndex(uint32 indexFrom, uint32 count) external view returns (bytes32[] memory elementsData) {
573         //check length
574         uint256 lenght = (elements.length - indexFrom >= count ? count : elements.length - indexFrom);
575         
576         elementsData = new bytes32[](lenght);
577         for(uint256 i = 0; i < lenght; i ++) {
578             elementsData[i] = elements[indexFrom + i].symbol;
579         }
580     }
581     
582     function getElementOwners(uint256[] _elementIds) external view returns (address[] memory owners) {
583         uint256 lenght = _elementIds.length;
584         owners = new address[](lenght);
585         
586         for(uint256 i = 0; i < lenght; i ++) {
587             owners[i] = elementToOwner[_elementIds[i]];
588         }
589     }
590     
591 	function getElementView(uint256 _id) external view returns (string symbol) {
592 		symbol = _bytes32ToString(elements[_id].symbol);
593     }
594 	
595 	function getElement(uint256 _id) external view returns (bytes32 symbol) {
596 		symbol = elements[_id].symbol;
597     }
598     
599     function getElements(uint256[] _elementIds) external view returns (bytes32[] memory elementsData) {
600         elementsData = new bytes32[](_elementIds.length);
601         for(uint256 i = 0; i < _elementIds.length; i++) {
602             elementsData[i] = elements[_elementIds[i]].symbol;
603         }
604     }
605     
606     function getElementInfoView(uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice, string _symbol) {
607 	    _price = currentPrice[_itemId];
608 		return (elementToOwner[_itemId], _price, calculateNextPrice(_price), _bytes32ToString(elements[_itemId].symbol));
609 	}
610     
611     function getElementInfo(uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice, bytes32 _symbol) {
612 	    _price = currentPrice[_itemId];
613 		return (elementToOwner[_itemId], _price, calculateNextPrice(_price), elements[_itemId].symbol);
614 	}
615     
616     function _bytes32ToString(bytes32 data) internal pure returns (string) {
617         bytes memory bytesString = new bytes(32);
618         uint charCount = 0;
619         for (uint j = 0; j < 32; j++) {
620             byte char = byte(bytes32(uint256(data) * 2 ** (8 * j)));
621             if (char != 0) {
622                 bytesString[charCount] = char;
623                 charCount++;
624             }
625         }
626         bytes memory bytesStringTrimmed = new bytes(charCount);
627         for (j = 0; j < charCount; j++) {
628             bytesStringTrimmed[j] = bytesString[j];
629         }
630         return string(bytesStringTrimmed);
631     }
632 }