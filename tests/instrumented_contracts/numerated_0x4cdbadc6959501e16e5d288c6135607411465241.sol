1 pragma solidity 0.6.12;
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 
5 /**
6  * @dev Library for managing
7  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
8  * types.
9  *
10  * Sets have the following properties:
11  *
12  * - Elements are added, removed, and checked for existence in constant time
13  * (O(1)).
14  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
15  *
16  * ```
17  * contract Example {
18  *     // Add the library methods
19  *     using EnumerableSet for EnumerableSet.AddressSet;
20  *
21  *     // Declare a set state variable
22  *     EnumerableSet.AddressSet private mySet;
23  * }
24  * ```
25  *
26  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
27  * (`UintSet`) are supported.
28  */
29 library EnumerableSet {
30     // To implement this library for multiple types with as little code
31     // repetition as possible, we write it in terms of a generic Set type with
32     // bytes32 values.
33     // The Set implementation uses private functions, and user-facing
34     // implementations (such as AddressSet) are just wrappers around the
35     // underlying Set.
36     // This means that we can only create new EnumerableSets for types that fit
37     // in bytes32.
38 
39     struct Set {
40         // Storage of set values
41         bytes32[] _values;
42 
43         // Position of the value in the `values` array, plus 1 because index 0
44         // means a value is not in the set.
45         mapping (bytes32 => uint256) _indexes;
46     }
47 
48     /**
49      * @dev Add a value to a set. O(1).
50      *
51      * Returns true if the value was added to the set, that is if it was not
52      * already present.
53      */
54     function _add(Set storage set, bytes32 value) private returns (bool) {
55         if (!_contains(set, value)) {
56             set._values.push(value);
57             // The value is stored at length-1, but we add 1 to all indexes
58             // and use 0 as a sentinel value
59             set._indexes[value] = set._values.length;
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     /**
67      * @dev Removes a value from a set. O(1).
68      *
69      * Returns true if the value was removed from the set, that is if it was
70      * present.
71      */
72     function _remove(Set storage set, bytes32 value) private returns (bool) {
73         // We read and store the value's index to prevent multiple reads from the same storage slot
74         uint256 valueIndex = set._indexes[value];
75 
76         if (valueIndex != 0) { // Equivalent to contains(set, value)
77             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
78             // the array, and then remove the last element (sometimes called as 'swap and pop').
79             // This modifies the order of the array, as noted in {at}.
80 
81             uint256 toDeleteIndex = valueIndex - 1;
82             uint256 lastIndex = set._values.length - 1;
83 
84             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
85             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
86 
87             bytes32 lastvalue = set._values[lastIndex];
88 
89             // Move the last value to the index where the value to delete is
90             set._values[toDeleteIndex] = lastvalue;
91             // Update the index for the moved value
92             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
93 
94             // Delete the slot where the moved value was stored
95             set._values.pop();
96 
97             // Delete the index for the deleted slot
98             delete set._indexes[value];
99 
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106     /**
107      * @dev Returns true if the value is in the set. O(1).
108      */
109     function _contains(Set storage set, bytes32 value) private view returns (bool) {
110         return set._indexes[value] != 0;
111     }
112 
113     /**
114      * @dev Returns the number of values on the set. O(1).
115      */
116     function _length(Set storage set) private view returns (uint256) {
117         return set._values.length;
118     }
119 
120    /**
121     * @dev Returns the value stored at position `index` in the set. O(1).
122     *
123     * Note that there are no guarantees on the ordering of values inside the
124     * array, and it may change when more values are added or removed.
125     *
126     * Requirements:
127     *
128     * - `index` must be strictly less than {length}.
129     */
130     function _at(Set storage set, uint256 index) private view returns (bytes32) {
131         require(set._values.length > index, "EnumerableSet: index out of bounds");
132         return set._values[index];
133     }
134 
135     // AddressSet
136 
137     struct AddressSet {
138         Set _inner;
139     }
140 
141     /**
142      * @dev Add a value to a set. O(1).
143      *
144      * Returns true if the value was added to the set, that is if it was not
145      * already present.
146      */
147     function add(AddressSet storage set, address value) internal returns (bool) {
148         return _add(set._inner, bytes32(uint256(value)));
149     }
150 
151     /**
152      * @dev Removes a value from a set. O(1).
153      *
154      * Returns true if the value was removed from the set, that is if it was
155      * present.
156      */
157     function remove(AddressSet storage set, address value) internal returns (bool) {
158         return _remove(set._inner, bytes32(uint256(value)));
159     }
160 
161     /**
162      * @dev Returns true if the value is in the set. O(1).
163      */
164     function contains(AddressSet storage set, address value) internal view returns (bool) {
165         return _contains(set._inner, bytes32(uint256(value)));
166     }
167 
168     /**
169      * @dev Returns the number of values in the set. O(1).
170      */
171     function length(AddressSet storage set) internal view returns (uint256) {
172         return _length(set._inner);
173     }
174 
175    /**
176     * @dev Returns the value stored at position `index` in the set. O(1).
177     *
178     * Note that there are no guarantees on the ordering of values inside the
179     * array, and it may change when more values are added or removed.
180     *
181     * Requirements:
182     *
183     * - `index` must be strictly less than {length}.
184     */
185     function at(AddressSet storage set, uint256 index) internal view returns (address) {
186         return address(uint256(_at(set._inner, index)));
187     }
188 
189 
190     // UintSet
191 
192     struct UintSet {
193         Set _inner;
194     }
195 
196     /**
197      * @dev Add a value to a set. O(1).
198      *
199      * Returns true if the value was added to the set, that is if it was not
200      * already present.
201      */
202     function add(UintSet storage set, uint256 value) internal returns (bool) {
203         return _add(set._inner, bytes32(value));
204     }
205 
206     /**
207      * @dev Removes a value from a set. O(1).
208      *
209      * Returns true if the value was removed from the set, that is if it was
210      * present.
211      */
212     function remove(UintSet storage set, uint256 value) internal returns (bool) {
213         return _remove(set._inner, bytes32(value));
214     }
215 
216     /**
217      * @dev Returns true if the value is in the set. O(1).
218      */
219     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
220         return _contains(set._inner, bytes32(value));
221     }
222 
223     /**
224      * @dev Returns the number of values on the set. O(1).
225      */
226     function length(UintSet storage set) internal view returns (uint256) {
227         return _length(set._inner);
228     }
229 
230    /**
231     * @dev Returns the value stored at position `index` in the set. O(1).
232     *
233     * Note that there are no guarantees on the ordering of values inside the
234     * array, and it may change when more values are added or removed.
235     *
236     * Requirements:
237     *
238     * - `index` must be strictly less than {length}.
239     */
240     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
241         return uint256(_at(set._inner, index));
242     }
243 }
244 
245 /**
246  * @dev Wrappers over Solidity's arithmetic operations with added overflow
247  * checks.
248  *
249  * Arithmetic operations in Solidity wrap on overflow. This can easily result
250  * in bugs, because programmers usually assume that an overflow raises an
251  * error, which is the standard behavior in high level programming languages.
252  * `SafeMath` restores this intuition by reverting the transaction when an
253  * operation overflows.
254  *
255  * Using this library instead of the unchecked operations eliminates an entire
256  * class of bugs, so it's recommended to use it always.
257  */
258 library SafeMath {
259     /**
260      * @dev Returns the addition of two unsigned integers, reverting on
261      * overflow.
262      *
263      * Counterpart to Solidity's `+` operator.
264      *
265      * Requirements:
266      *
267      * - Addition cannot overflow.
268      */
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         uint256 c = a + b;
271         require(c >= a, "SafeMath: addition overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the subtraction of two unsigned integers, reverting on
278      * overflow (when the result is negative).
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         return sub(a, b, "SafeMath: subtraction overflow");
288     }
289 
290     /**
291      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
292      * overflow (when the result is negative).
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      *
298      * - Subtraction cannot overflow.
299      */
300     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b <= a, errorMessage);
302         uint256 c = a - b;
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the multiplication of two unsigned integers, reverting on
309      * overflow.
310      *
311      * Counterpart to Solidity's `*` operator.
312      *
313      * Requirements:
314      *
315      * - Multiplication cannot overflow.
316      */
317     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
319         // benefit is lost if 'b' is also tested.
320         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
321         if (a == 0) {
322             return 0;
323         }
324 
325         uint256 c = a * b;
326         require(c / a == b, "SafeMath: multiplication overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the integer division of two unsigned integers. Reverts on
333      * division by zero. The result is rounded towards zero.
334      *
335      * Counterpart to Solidity's `/` operator. Note: this function uses a
336      * `revert` opcode (which leaves remaining gas untouched) while Solidity
337      * uses an invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      *
341      * - The divisor cannot be zero.
342      */
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344         return div(a, b, "SafeMath: division by zero");
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator. Note: this function uses a
352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
353      * uses an invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      *
357      * - The divisor cannot be zero.
358      */
359     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
360         require(b > 0, errorMessage);
361         uint256 c = a / b;
362         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * Reverts when dividing by zero.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
380         return mod(a, b, "SafeMath: modulo by zero");
381     }
382 
383     /**
384      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
385      * Reverts with custom message when dividing by zero.
386      *
387      * Counterpart to Solidity's `%` operator. This function uses a `revert`
388      * opcode (which leaves remaining gas untouched) while Solidity uses an
389      * invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
396         require(b != 0, errorMessage);
397         return a % b;
398     }
399 }
400 
401 /**
402  * @title Ownable
403  * @dev The Ownable contract has an owner address, and provides basic authorization control
404  * functions, this simplifies the implementation of "user permissions".
405  */
406 contract Ownable {
407   address public owner;
408 
409 
410   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412 
413   /**
414    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
415    * account.
416    */
417   constructor() public {
418     owner = msg.sender;
419   }
420 
421 
422   /**
423    * @dev Throws if called by any account other than the owner.
424    */
425   modifier onlyOwner() {
426     require(msg.sender == owner);
427     _;
428   }
429 
430 
431   /**
432    * @dev Allows the current owner to transfer control of the contract to a newOwner.
433    * @param newOwner The address to transfer ownership to.
434    */
435   function transferOwnership(address newOwner) onlyOwner public {
436     require(newOwner != address(0));
437     emit OwnershipTransferred(owner, newOwner);
438     owner = newOwner;
439   }
440 }
441 
442 // Modern ERC20 Token interface
443 interface IERC20 {
444     function transfer(address to, uint amount) external returns (bool);
445     function transferFrom(address from, address to, uint amount) external returns (bool);
446 }
447 
448 // Modern ERC721 Token interface
449 interface IERC721 {
450     function transferFrom(address from, address to, uint tokenId) external;
451     function mint(address to) external;
452 }
453 
454 contract NFT_Market is Ownable {
455     using SafeMath for uint;
456     using EnumerableSet for EnumerableSet.UintSet;
457 
458     // =========== Start Smart Contract Setup ==============
459     
460     // MUST BE CONSTANT - THE FEE TOKEN ADDRESS AND NFT ADDRESS
461     // the below addresses are trusted and constant so no issue of re-entrancy happens
462     address public constant trustedFeeTokenAddress = 0x961C8c0B1aaD0c0b10a51FeF6a867E3091BCef17;
463     address public constant trustedNftAddress = 0x582c905df6caD7a1c490eDc215F0Baa0Dc0960Dd;
464     
465     // minting fee in token, 10 tokens (10e18 because token has 18 decimals)
466     uint public mintFee = 10e18;
467     
468     // selling fee rate
469     uint public sellingFeeRateX100 = 30;
470     
471     // ============ End Smart Contract Setup ================
472     
473     // ---------------- owner modifier functions ------------------------
474     function setMintFee(uint _mintFee) public onlyOwner {
475         mintFee = _mintFee;
476     }
477     function setSellingFeeRateX100(uint _sellingFeeRateX100) public onlyOwner {
478         sellingFeeRateX100 = _sellingFeeRateX100;
479     }
480     
481     // --------------- end owner modifier functions ---------------------
482     
483     enum PriceType {
484         ETHER,
485         TOKEN
486     }
487     
488     event List(uint tokenId, uint price, PriceType priceType);
489     event Unlist(uint tokenId);
490     event Buy(uint tokenId);
491     
492      
493     EnumerableSet.UintSet private nftsForSaleIds;
494     
495     // nft id => nft price
496     mapping (uint => uint) private nftsForSalePrices;
497     // nft id => nft owner
498     mapping (uint => address) private nftOwners;
499     // nft id => ETHER | TOKEN
500     mapping (uint => PriceType) private priceTypes;
501     
502     // nft owner => nft id set
503     mapping (address => EnumerableSet.UintSet) private nftsForSaleByAddress;
504     
505     function balanceOf(address owner) public view returns (uint256) {
506         require(owner != address(0), "ERC721: balance query for the zero address");
507         return nftsForSaleByAddress[owner].length();
508     }
509     function totalListed() public view returns (uint256) {
510         return nftsForSaleIds.length();
511     }
512 
513     function getToken(uint tokenId) public view returns (uint _tokenId, uint _price, address _owner, PriceType _priceType) {
514         _tokenId = tokenId;
515         _price = nftsForSalePrices[tokenId];
516         _owner = nftOwners[tokenId];
517         _priceType = priceTypes[tokenId];
518     }
519     
520     function getTokens(uint startIndex, uint endIndex) public view returns 
521         (uint[] memory _tokens, uint[] memory _prices, address[] memory _owners, PriceType[] memory _priceTypes) {
522         require(startIndex < endIndex, "Invalid indexes supplied!");
523         uint len = endIndex.sub(startIndex);
524         require(len <= totalListed(), "Invalid length!");
525         
526         _tokens = new uint[](len);
527         _prices = new uint[](len);
528         _owners = new address[](len);
529         _priceTypes = new PriceType[](len);
530         
531         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
532             uint listIndex = i.sub(startIndex);
533             
534             uint tokenId = nftsForSaleIds.at(i);
535             uint price = nftsForSalePrices[tokenId];
536             address nftOwner = nftOwners[tokenId];
537             PriceType priceType = priceTypes[tokenId];
538             
539             _tokens[listIndex] = tokenId;
540             _prices[listIndex] = price;
541             _owners[listIndex] = nftOwner;
542             _priceTypes[listIndex] = priceType;
543         }
544     }
545     
546     // overloaded getTokens to allow for getting seller tokens
547     // _owners array not needed but returned for interface consistency
548     // view function so no gas is used
549     function getTokens(address seller, uint startIndex, uint endIndex) public view returns
550         (uint[] memory _tokens, uint[] memory _prices, address[] memory _owners, PriceType[] memory _priceTypes) {
551         require(startIndex < endIndex, "Invalid indexes supplied!");
552         uint len = endIndex.sub(startIndex);
553         require(len <= balanceOf(seller), "Invalid length!");
554         
555         _tokens = new uint[](len);
556         _prices = new uint[](len);
557         _owners = new address[](len);
558         _priceTypes = new PriceType[](len);
559         
560         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
561             uint listIndex = i.sub(startIndex);
562             
563             uint tokenId = nftsForSaleByAddress[seller].at(i);
564             uint price = nftsForSalePrices[tokenId];
565             address nftOwner = nftOwners[tokenId];
566             PriceType priceType = priceTypes[tokenId];
567             
568             _tokens[listIndex] = tokenId;
569             _prices[listIndex] = price;
570             _owners[listIndex] = nftOwner;
571             _priceTypes[listIndex] = priceType;
572         }
573     }
574     
575     function mint() public {
576         // owner can mint without fee
577         // other users need to pay a fixed fee in token
578         if (msg.sender != owner) {
579             require(IERC20(trustedFeeTokenAddress).transferFrom(msg.sender, owner, mintFee), "Could not transfer mint fee!");
580         }
581         
582         IERC721(trustedNftAddress).mint(msg.sender);
583     }
584     
585     function list(uint tokenId, uint price, PriceType priceType) public {
586         IERC721(trustedNftAddress).transferFrom(msg.sender, address(this), tokenId);
587         
588         nftsForSaleIds.add(tokenId);
589         nftsForSaleByAddress[msg.sender].add(tokenId);
590         nftOwners[tokenId] = msg.sender;
591         nftsForSalePrices[tokenId] = price;
592         priceTypes[tokenId] = priceType;
593         
594         emit List(tokenId, price, priceType);
595     }
596     
597     function unlist(uint tokenId) public {
598         require(nftsForSaleIds.contains(tokenId), "Trying to unlist an NFT which is not listed yet!");
599         address nftOwner = nftOwners[tokenId];
600         require(nftOwner == msg.sender, "Cannot unlist other's NFT!");
601         
602         nftsForSaleIds.remove(tokenId);
603         nftsForSaleByAddress[msg.sender].remove(tokenId);
604         delete nftOwners[tokenId];
605         delete nftsForSalePrices[tokenId];
606         delete priceTypes[tokenId];
607         
608         IERC721(trustedNftAddress).transferFrom(address(this), msg.sender, tokenId);
609         emit Unlist(tokenId);
610     }
611 
612     function buy(uint tokenId) public payable {
613         require(nftsForSaleIds.contains(tokenId), "Trying to unlist an NFT which is not listed yet!");
614         address payable nftOwner = address(uint160(nftOwners[tokenId]));
615         address payable _owner = address(uint160(owner));
616         
617         uint price = nftsForSalePrices[tokenId];
618         uint fee = price.mul(sellingFeeRateX100).div(1e4);
619         uint amountAfterFee = price.sub(fee);
620         PriceType _priceType = priceTypes[tokenId];
621     
622         nftsForSaleIds.remove(tokenId);
623         nftsForSaleByAddress[nftOwners[tokenId]].remove(tokenId);
624         delete nftOwners[tokenId];
625         delete nftsForSalePrices[tokenId];
626         delete priceTypes[tokenId];
627         
628         if (_priceType == PriceType.ETHER) {
629             require(msg.value >= price, "Insufficient ETH is transferred to purchase!");
630             _owner.transfer(fee);
631             nftOwner.transfer(amountAfterFee);
632             // in case extra ETH is transferred, forward the extra to owner
633             if (msg.value > price) {
634                 _owner.transfer(msg.value.sub(price));                
635             }
636         } else if (_priceType == PriceType.TOKEN) {
637             require(IERC20(trustedFeeTokenAddress).transferFrom(msg.sender, address(this), price), "Could not transfer fee to Marketplace!");
638             require(IERC20(trustedFeeTokenAddress).transfer(_owner, fee), "Could not transfer purchase fee to admin!");
639             require(IERC20(trustedFeeTokenAddress).transfer(nftOwner, amountAfterFee), "Could not transfer sale revenue to NFT seller!");
640         } else {
641             revert("Invalid Price Type!");
642         }
643         IERC721(trustedNftAddress).transferFrom(address(this), msg.sender, tokenId);
644         emit Buy(tokenId);
645     }
646     
647     event ERC721Received(address operator, address from, uint256 tokenId, bytes data);
648     
649     // ERC721 Interface Support Function
650     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns(bytes4) {
651         require(msg.sender == trustedNftAddress);
652         emit ERC721Received(operator, from, tokenId, data);
653         return this.onERC721Received.selector;
654     }
655     
656 }