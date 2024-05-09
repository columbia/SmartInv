1 pragma solidity 0.5.11;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 
159 contract InscribableToken {
160 
161     mapping(bytes32 => bytes32) public properties;
162 
163     event ClassPropertySet(
164         bytes32 indexed key,
165         bytes32 value
166     );
167 
168     event TokenPropertySet(
169         uint indexed id,
170         bytes32 indexed key,
171         bytes32 value
172     );
173 
174     function _setProperty(
175         uint _id,
176         bytes32 _key,
177         bytes32 _value
178     )
179         internal
180     {
181         properties[getTokenKey(_id, _key)] = _value;
182         emit TokenPropertySet(_id, _key, _value);
183     }
184 
185     function getProperty(
186         uint _id,
187         bytes32 _key
188     )
189         public
190         view
191         returns (bytes32 _value)
192     {
193         return properties[getTokenKey(_id, _key)];
194     }
195 
196     function _setClassProperty(
197         bytes32 _key,
198         bytes32 _value
199     )
200         internal
201     {
202         emit ClassPropertySet(_key, _value);
203         properties[getClassKey(_key)] = _value;
204     }
205 
206     function getTokenKey(
207         uint _tokenId,
208         bytes32 _key
209     )
210         public
211         pure
212         returns (bytes32)
213     {
214         // one prefix to prevent collisions
215         return keccak256(abi.encodePacked(uint(1), _tokenId, _key));
216     }
217 
218     function getClassKey(bytes32 _key)
219         public
220         pure
221         returns (bytes32)
222     {
223         // zero prefix to prevent collisions
224         return keccak256(abi.encodePacked(uint(0), _key));
225     }
226 
227     function getClassProperty(bytes32 _key)
228         public
229         view
230         returns (bytes32)
231     {
232         return properties[getClassKey(_key)];
233     }
234 
235 }
236 
237 
238 
239 library String {
240 
241     /**
242      * @dev Converts a `uint256` to a `string`.
243      * via OraclizeAPI - MIT licence
244      * https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
245      */
246     function fromUint(uint256 value) internal pure returns (string memory) {
247         if (value == 0) {
248             return "0";
249         }
250         uint256 temp = value;
251         uint256 digits;
252         while (temp != 0) {
253             digits++;
254             temp /= 10;
255         }
256         bytes memory buffer = new bytes(digits);
257         uint256 index = digits - 1;
258         temp = value;
259         while (temp != 0) {
260             buffer[index--] = byte(uint8(48 + temp % 10));
261             temp /= 10;
262         }
263         return string(buffer);
264     }
265 
266     bytes constant alphabet = "0123456789abcdef";
267 
268     function fromAddress(address _addr) internal pure returns(string memory) {
269         bytes32 value = bytes32(uint256(_addr));
270         bytes memory str = new bytes(42);
271         str[0] = '0';
272         str[1] = 'x';
273         for (uint i = 0; i < 20; i++) {
274             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
275             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0F))];
276         }
277         return string(str);
278     }
279 
280 }
281 
282 // solium-disable security/no-inline-assembly
283 
284 
285 library StorageWrite {
286 
287     using SafeMath for uint256;
288 
289     function _getStorageArraySlot(uint _dest, uint _index) internal view returns (uint result) {
290         uint slot = _getArraySlot(_dest, _index);
291         assembly { result := sload(slot) }
292     }
293 
294     function _getArraySlot(uint _dest, uint _index) internal pure returns (uint slot) {
295         assembly {
296             let free := mload(0x40)
297             mstore(free, _dest)
298             slot := add(keccak256(free, 32), _index)
299         }
300     }
301 
302     function _setArraySlot(uint _dest, uint _index, uint _value) internal {
303         uint slot = _getArraySlot(_dest, _index);
304         assembly { sstore(slot, _value) }
305     }
306 
307     function _loadSlots(
308         uint _slot,
309         uint _offset,
310         uint _perSlot,
311         uint _length
312     )
313         internal
314         view
315         returns (uint[] memory slots)
316     {
317         uint slotCount = _slotCount(_offset, _perSlot, _length);
318         slots = new uint[](slotCount);
319         // top and tail the slots
320         uint firstPos = _pos(_offset, _perSlot); // _offset.div(_perSlot);
321         slots[0] = _getStorageArraySlot(_slot, firstPos);
322         if (slotCount > 1) {
323             uint lastPos = _pos(_offset.add(_length), _perSlot); // .div(_perSlot);
324             slots[slotCount-1] = _getStorageArraySlot(_slot, lastPos);
325         }
326     }
327 
328     function _pos(uint items, uint perPage) internal pure returns (uint) {
329         return items / perPage;
330     }
331 
332     function _slotCount(uint _offset, uint _perSlot, uint _length) internal pure returns (uint) {
333         uint start = _offset / _perSlot;
334         uint end = (_offset + _length) / _perSlot;
335         return (end - start) + 1;
336     }
337 
338     function _saveSlots(uint _slot, uint _offset, uint _size, uint[] memory _slots) internal {
339         uint offset = _offset.div((256/_size));
340         for (uint i = 0; i < _slots.length; i++) {
341             _setArraySlot(_slot, offset + i, _slots[i]);
342         }
343     }
344 
345     function _write(uint[] memory _slots, uint _offset, uint _size, uint _index, uint _value) internal pure {
346         uint perSlot = 256 / _size;
347         uint initialOffset = _offset % perSlot;
348         uint slotPosition = (initialOffset + _index) / perSlot;
349         uint withinSlot = ((_index + _offset) % perSlot) * _size;
350         // evil bit shifting magic
351         for (uint q = 0; q < _size; q += 8) {
352             _slots[slotPosition] |= ((_value >> q) & 0xFF) << (withinSlot + q);
353         }
354     }
355 
356     function repeatUint16(uint _slot, uint _offset, uint _length, uint16 _item) internal {
357         uint[] memory slots = _loadSlots(_slot, _offset, 16, _length);
358         for (uint i = 0; i < _length; i++) {
359             _write(slots, _offset, 16, i, _item);
360         }
361         _saveSlots(_slot, _offset, 16, slots);
362     }
363 
364     function uint16s(uint _slot, uint _offset, uint16[] memory _items) internal {
365         uint[] memory slots = _loadSlots(_slot, _offset, 16, _items.length);
366         for (uint i = 0; i < _items.length; i++) {
367             _write(slots, _offset, 16, i, _items[i]);
368         }
369         _saveSlots(_slot, _offset, 16, slots);
370     }
371 
372     function uint8s(uint _slot, uint _offset, uint8[] memory _items) internal {
373         uint[] memory slots = _loadSlots(_slot, _offset, 32, _items.length);
374         for (uint i = 0; i < _items.length; i++) {
375             _write(slots, _offset, 8, i, _items[i]);
376         }
377         _saveSlots(_slot, _offset, 8, slots);
378     }
379 
380 }
381 
382 contract ImmutableToken {
383 
384     string public constant baseURI = "https://api.immutable.com/asset/";
385 
386     function tokenURI(uint256 tokenId) external view returns (string memory) {
387         return string(abi.encodePacked(
388             baseURI,
389             String.fromAddress(address(this)),
390             "/",
391             String.fromUint(tokenId)
392         ));
393     }
394 
395 }
396 
397 /*
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with GSN meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 contract Context {
408     // Empty internal constructor, to prevent people from mistakenly deploying
409     // an instance of this contract, which should be used via inheritance.
410     constructor () internal { }
411     // solhint-disable-previous-line no-empty-blocks
412 
413     function _msgSender() internal view returns (address payable) {
414         return msg.sender;
415     }
416 
417     function _msgData() internal view returns (bytes memory) {
418         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
419         return msg.data;
420     }
421 }
422 
423 
424 /**
425  * @dev Interface of the ERC165 standard, as defined in the
426  * https://eips.ethereum.org/EIPS/eip-165[EIP].
427  *
428  * Implementers can declare support of contract interfaces, which can then be
429  * queried by others ({ERC165Checker}).
430  *
431  * For an implementation, see {ERC165}.
432  */
433 interface IERC165 {
434     /**
435      * @dev Returns true if this contract implements the interface defined by
436      * `interfaceId`. See the corresponding
437      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
438      * to learn more about how these ids are created.
439      *
440      * This function call must use less than 30 000 gas.
441      */
442     function supportsInterface(bytes4 interfaceId) external view returns (bool);
443 }
444 
445 
446 /**
447  * @dev Implementation of the {IERC165} interface.
448  *
449  * Contracts may inherit from this and call {_registerInterface} to declare
450  * their support of an interface.
451  */
452 contract ERC165 is IERC165 {
453     /*
454      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
455      */
456     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
457 
458     /**
459      * @dev Mapping of interface ids to whether or not it's supported.
460      */
461     mapping(bytes4 => bool) private _supportedInterfaces;
462 
463     constructor () internal {
464         // Derived contracts need only register support for their own interfaces,
465         // we register support for ERC165 itself here
466         _registerInterface(_INTERFACE_ID_ERC165);
467     }
468 
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      *
472      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
473      */
474     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
475         return _supportedInterfaces[interfaceId];
476     }
477 
478     /**
479      * @dev Registers the contract as an implementer of the interface defined by
480      * `interfaceId`. Support of the actual ERC165 interface is automatic and
481      * registering its interface id is not required.
482      *
483      * See {IERC165-supportsInterface}.
484      *
485      * Requirements:
486      *
487      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
488      */
489     function _registerInterface(bytes4 interfaceId) internal {
490         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
491         _supportedInterfaces[interfaceId] = true;
492     }
493 }
494 
495 
496 /**
497  * @title ERC721 token receiver interface
498  * @dev Interface for any contract that wants to support safeTransfers
499  * from ERC721 asset contracts.
500  */
501 contract IERC721Receiver {
502     /**
503      * @notice Handle the receipt of an NFT
504      * @dev The ERC721 smart contract calls this function on the recipient
505      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
506      * otherwise the caller will revert the transaction. The selector to be
507      * returned can be obtained as `this.onERC721Received.selector`. This
508      * function MAY throw to revert and reject the transfer.
509      * Note: the ERC721 contract address is always the message sender.
510      * @param operator The address which called `safeTransferFrom` function
511      * @param from The address which previously owned the token
512      * @param tokenId The NFT identifier which is being transferred
513      * @param data Additional data with no specified format
514      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
515      */
516     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
517     public returns (bytes4);
518 }
519 
520 
521 /**
522  * @dev Collection of functions related to the address type
523  */
524 library Address {
525     /**
526      * @dev Returns true if `account` is a contract.
527      *
528      * This test is non-exhaustive, and there may be false-negatives: during the
529      * execution of a contract's constructor, its address will be reported as
530      * not containing a contract.
531      *
532      * IMPORTANT: It is unsafe to assume that an address for which this
533      * function returns false is an externally-owned account (EOA) and not a
534      * contract.
535      */
536     function isContract(address account) internal view returns (bool) {
537         // This method relies in extcodesize, which returns 0 for contracts in
538         // construction, since the code is only stored at the end of the
539         // constructor execution.
540 
541         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
542         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
543         // for accounts without code, i.e. `keccak256('')`
544         bytes32 codehash;
545         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
546         // solhint-disable-next-line no-inline-assembly
547         assembly { codehash := extcodehash(account) }
548         return (codehash != 0x0 && codehash != accountHash);
549     }
550 
551     /**
552      * @dev Converts an `address` into `address payable`. Note that this is
553      * simply a type cast: the actual underlying value is not changed.
554      *
555      * _Available since v2.4.0._
556      */
557     function toPayable(address account) internal pure returns (address payable) {
558         return address(uint160(account));
559     }
560 
561     /**
562      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
563      * `recipient`, forwarding all available gas and reverting on errors.
564      *
565      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
566      * of certain opcodes, possibly making contracts go over the 2300 gas limit
567      * imposed by `transfer`, making them unable to receive funds via
568      * `transfer`. {sendValue} removes this limitation.
569      *
570      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
571      *
572      * IMPORTANT: because control is transferred to `recipient`, care must be
573      * taken to not create reentrancy vulnerabilities. Consider using
574      * {ReentrancyGuard} or the
575      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
576      *
577      * _Available since v2.4.0._
578      */
579     function sendValue(address payable recipient, uint256 amount) internal {
580         require(address(this).balance >= amount, "Address: insufficient balance");
581 
582         // solhint-disable-next-line avoid-call-value
583         (bool success, ) = recipient.call.value(amount)("");
584         require(success, "Address: unable to send value, recipient may have reverted");
585     }
586 }
587 
588 
589 /**
590  * @title Counters
591  * @author Matt Condon (@shrugs)
592  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
593  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
594  *
595  * Include with `using Counters for Counters.Counter;`
596  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
597  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
598  * directly accessed.
599  */
600 library Counters {
601     using SafeMath for uint256;
602 
603     struct Counter {
604         // This variable should never be directly accessed by users of the library: interactions must be restricted to
605         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
606         // this feature: see https://github.com/ethereum/solidity/issues/4637
607         uint256 _value; // default: 0
608     }
609 
610     function current(Counter storage counter) internal view returns (uint256) {
611         return counter._value;
612     }
613 
614     function increment(Counter storage counter) internal {
615         counter._value += 1;
616     }
617 
618     function decrement(Counter storage counter) internal {
619         counter._value = counter._value.sub(1);
620     }
621 }
622 
623 /**
624  * @dev Contract module which provides a basic access control mechanism, where
625  * there is an account (an owner) that can be granted exclusive access to
626  * specific functions.
627  *
628  * This module is used through inheritance. It will make available the modifier
629  * `onlyOwner`, which can be applied to your functions to restrict their use to
630  * the owner.
631  */
632 contract Ownable is Context {
633     address private _owner;
634 
635     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
636 
637     /**
638      * @dev Initializes the contract setting the deployer as the initial owner.
639      */
640     constructor () internal {
641         _owner = _msgSender();
642         emit OwnershipTransferred(address(0), _owner);
643     }
644 
645     /**
646      * @dev Returns the address of the current owner.
647      */
648     function owner() public view returns (address) {
649         return _owner;
650     }
651 
652     /**
653      * @dev Throws if called by any account other than the owner.
654      */
655     modifier onlyOwner() {
656         require(isOwner(), "Ownable: caller is not the owner");
657         _;
658     }
659 
660     /**
661      * @dev Returns true if the caller is the current owner.
662      */
663     function isOwner() public view returns (bool) {
664         return _msgSender() == _owner;
665     }
666 
667     /**
668      * @dev Leaves the contract without owner. It will not be possible to call
669      * `onlyOwner` functions anymore. Can only be called by the current owner.
670      *
671      * NOTE: Renouncing ownership will leave the contract without an owner,
672      * thereby removing any functionality that is only available to the owner.
673      */
674     function renounceOwnership() public onlyOwner {
675         emit OwnershipTransferred(_owner, address(0));
676         _owner = address(0);
677     }
678 
679     /**
680      * @dev Transfers ownership of the contract to a new account (`newOwner`).
681      * Can only be called by the current owner.
682      */
683     function transferOwnership(address newOwner) public onlyOwner {
684         _transferOwnership(newOwner);
685     }
686 
687     /**
688      * @dev Transfers ownership of the contract to a new account (`newOwner`).
689      */
690     function _transferOwnership(address newOwner) internal {
691         require(newOwner != address(0), "Ownable: new owner is the zero address");
692         emit OwnershipTransferred(_owner, newOwner);
693         _owner = newOwner;
694     }
695 }
696 
697 
698 /**
699  * @dev Required interface of an ERC721 compliant contract.
700  */
701 contract IERC721 is IERC165 {
702     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
703     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
704     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
705 
706     /**
707      * @dev Returns the number of NFTs in `owner`'s account.
708      */
709     function balanceOf(address owner) public view returns (uint256 balance);
710 
711     /**
712      * @dev Returns the owner of the NFT specified by `tokenId`.
713      */
714     function ownerOf(uint256 tokenId) public view returns (address owner);
715 
716     /**
717      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
718      * another (`to`).
719      *
720      *
721      *
722      * Requirements:
723      * - `from`, `to` cannot be zero.
724      * - `tokenId` must be owned by `from`.
725      * - If the caller is not `from`, it must be have been allowed to move this
726      * NFT by either {approve} or {setApprovalForAll}.
727      */
728     function safeTransferFrom(address from, address to, uint256 tokenId) public;
729     /**
730      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
731      * another (`to`).
732      *
733      * Requirements:
734      * - If the caller is not `from`, it must be approved to move this NFT by
735      * either {approve} or {setApprovalForAll}.
736      */
737     function transferFrom(address from, address to, uint256 tokenId) public;
738     function approve(address to, uint256 tokenId) public;
739     function getApproved(uint256 tokenId) public view returns (address operator);
740 
741     function setApprovalForAll(address operator, bool _approved) public;
742     function isApprovedForAll(address owner, address operator) public view returns (bool);
743 
744 
745     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
746 }
747 
748 
749 
750 
751 
752 
753 
754 
755 /**
756  * @title ERC721 Non-Fungible Token Standard basic implementation
757  * @dev see https://eips.ethereum.org/EIPS/eip-721
758  */
759 contract ERC721 is Context, ERC165, IERC721 {
760     using SafeMath for uint256;
761     using Address for address;
762     using Counters for Counters.Counter;
763 
764     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
765     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
766     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
767 
768     // Mapping from token ID to owner
769     mapping (uint256 => address) private _tokenOwner;
770 
771     // Mapping from token ID to approved address
772     mapping (uint256 => address) private _tokenApprovals;
773 
774     // Mapping from owner to number of owned token
775     mapping (address => Counters.Counter) private _ownedTokensCount;
776 
777     // Mapping from owner to operator approvals
778     mapping (address => mapping (address => bool)) private _operatorApprovals;
779 
780     /*
781      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
782      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
783      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
784      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
785      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
786      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
787      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
788      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
789      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
790      *
791      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
792      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
793      */
794     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
795 
796     constructor () public {
797         // register the supported interfaces to conform to ERC721 via ERC165
798         _registerInterface(_INTERFACE_ID_ERC721);
799     }
800 
801     /**
802      * @dev Gets the balance of the specified address.
803      * @param owner address to query the balance of
804      * @return uint256 representing the amount owned by the passed address
805      */
806     function balanceOf(address owner) public view returns (uint256) {
807         require(owner != address(0), "ERC721: balance query for the zero address");
808 
809         return _ownedTokensCount[owner].current();
810     }
811 
812     /**
813      * @dev Gets the owner of the specified token ID.
814      * @param tokenId uint256 ID of the token to query the owner of
815      * @return address currently marked as the owner of the given token ID
816      */
817     function ownerOf(uint256 tokenId) public view returns (address) {
818         address owner = _tokenOwner[tokenId];
819         require(owner != address(0), "ERC721: owner query for nonexistent token");
820 
821         return owner;
822     }
823 
824     /**
825      * @dev Approves another address to transfer the given token ID
826      * The zero address indicates there is no approved address.
827      * There can only be one approved address per token at a given time.
828      * Can only be called by the token owner or an approved operator.
829      * @param to address to be approved for the given token ID
830      * @param tokenId uint256 ID of the token to be approved
831      */
832     function approve(address to, uint256 tokenId) public {
833         address owner = ownerOf(tokenId);
834         require(to != owner, "ERC721: approval to current owner");
835 
836         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
837             "ERC721: approve caller is not owner nor approved for all"
838         );
839 
840         _tokenApprovals[tokenId] = to;
841         emit Approval(owner, to, tokenId);
842     }
843 
844     /**
845      * @dev Gets the approved address for a token ID, or zero if no address set
846      * Reverts if the token ID does not exist.
847      * @param tokenId uint256 ID of the token to query the approval of
848      * @return address currently approved for the given token ID
849      */
850     function getApproved(uint256 tokenId) public view returns (address) {
851         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
852 
853         return _tokenApprovals[tokenId];
854     }
855 
856     /**
857      * @dev Sets or unsets the approval of a given operator
858      * An operator is allowed to transfer all tokens of the sender on their behalf.
859      * @param to operator address to set the approval
860      * @param approved representing the status of the approval to be set
861      */
862     function setApprovalForAll(address to, bool approved) public {
863         require(to != _msgSender(), "ERC721: approve to caller");
864 
865         _operatorApprovals[_msgSender()][to] = approved;
866         emit ApprovalForAll(_msgSender(), to, approved);
867     }
868 
869     /**
870      * @dev Tells whether an operator is approved by a given owner.
871      * @param owner owner address which you want to query the approval of
872      * @param operator operator address which you want to query the approval of
873      * @return bool whether the given operator is approved by the given owner
874      */
875     function isApprovedForAll(address owner, address operator) public view returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev Transfers the ownership of a given token ID to another address.
881      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
882      * Requires the msg.sender to be the owner, approved, or operator.
883      * @param from current owner of the token
884      * @param to address to receive the ownership of the given token ID
885      * @param tokenId uint256 ID of the token to be transferred
886      */
887     function transferFrom(address from, address to, uint256 tokenId) public {
888         //solhint-disable-next-line max-line-length
889         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
890 
891         _transferFrom(from, to, tokenId);
892     }
893 
894     /**
895      * @dev Safely transfers the ownership of a given token ID to another address
896      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
897      * which is called upon a safe transfer, and return the magic value
898      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
899      * the transfer is reverted.
900      * Requires the msg.sender to be the owner, approved, or operator
901      * @param from current owner of the token
902      * @param to address to receive the ownership of the given token ID
903      * @param tokenId uint256 ID of the token to be transferred
904      */
905     function safeTransferFrom(address from, address to, uint256 tokenId) public {
906         safeTransferFrom(from, to, tokenId, "");
907     }
908 
909     /**
910      * @dev Safely transfers the ownership of a given token ID to another address
911      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
912      * which is called upon a safe transfer, and return the magic value
913      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
914      * the transfer is reverted.
915      * Requires the _msgSender() to be the owner, approved, or operator
916      * @param from current owner of the token
917      * @param to address to receive the ownership of the given token ID
918      * @param tokenId uint256 ID of the token to be transferred
919      * @param _data bytes data to send along with a safe transfer check
920      */
921     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
922         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
923         _safeTransferFrom(from, to, tokenId, _data);
924     }
925 
926     /**
927      * @dev Safely transfers the ownership of a given token ID to another address
928      * If the target address is a contract, it must implement `onERC721Received`,
929      * which is called upon a safe transfer, and return the magic value
930      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
931      * the transfer is reverted.
932      * Requires the msg.sender to be the owner, approved, or operator
933      * @param from current owner of the token
934      * @param to address to receive the ownership of the given token ID
935      * @param tokenId uint256 ID of the token to be transferred
936      * @param _data bytes data to send along with a safe transfer check
937      */
938     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
939         _transferFrom(from, to, tokenId);
940         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
941     }
942 
943     /**
944      * @dev Returns whether the specified token exists.
945      * @param tokenId uint256 ID of the token to query the existence of
946      * @return bool whether the token exists
947      */
948     function _exists(uint256 tokenId) internal view returns (bool) {
949         address owner = _tokenOwner[tokenId];
950         return owner != address(0);
951     }
952 
953     /**
954      * @dev Returns whether the given spender can transfer a given token ID.
955      * @param spender address of the spender to query
956      * @param tokenId uint256 ID of the token to be transferred
957      * @return bool whether the msg.sender is approved for the given token ID,
958      * is an operator of the owner, or is the owner of the token
959      */
960     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
961         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
962         address owner = ownerOf(tokenId);
963         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
964     }
965 
966     /**
967      * @dev Internal function to safely mint a new token.
968      * Reverts if the given token ID already exists.
969      * If the target address is a contract, it must implement `onERC721Received`,
970      * which is called upon a safe transfer, and return the magic value
971      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
972      * the transfer is reverted.
973      * @param to The address that will own the minted token
974      * @param tokenId uint256 ID of the token to be minted
975      */
976     function _safeMint(address to, uint256 tokenId) internal {
977         _safeMint(to, tokenId, "");
978     }
979 
980     /**
981      * @dev Internal function to safely mint a new token.
982      * Reverts if the given token ID already exists.
983      * If the target address is a contract, it must implement `onERC721Received`,
984      * which is called upon a safe transfer, and return the magic value
985      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
986      * the transfer is reverted.
987      * @param to The address that will own the minted token
988      * @param tokenId uint256 ID of the token to be minted
989      * @param _data bytes data to send along with a safe transfer check
990      */
991     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
992         _mint(to, tokenId);
993         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
994     }
995 
996     /**
997      * @dev Internal function to mint a new token.
998      * Reverts if the given token ID already exists.
999      * @param to The address that will own the minted token
1000      * @param tokenId uint256 ID of the token to be minted
1001      */
1002     function _mint(address to, uint256 tokenId) internal {
1003         require(to != address(0), "ERC721: mint to the zero address");
1004         require(!_exists(tokenId), "ERC721: token already minted");
1005 
1006         _tokenOwner[tokenId] = to;
1007         _ownedTokensCount[to].increment();
1008 
1009         emit Transfer(address(0), to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Internal function to burn a specific token.
1014      * Reverts if the token does not exist.
1015      * Deprecated, use {_burn} instead.
1016      * @param owner owner of the token to burn
1017      * @param tokenId uint256 ID of the token being burned
1018      */
1019     function _burn(address owner, uint256 tokenId) internal {
1020         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
1021 
1022         _clearApproval(tokenId);
1023 
1024         _ownedTokensCount[owner].decrement();
1025         _tokenOwner[tokenId] = address(0);
1026 
1027         emit Transfer(owner, address(0), tokenId);
1028     }
1029 
1030     /**
1031      * @dev Internal function to burn a specific token.
1032      * Reverts if the token does not exist.
1033      * @param tokenId uint256 ID of the token being burned
1034      */
1035     function _burn(uint256 tokenId) internal {
1036         _burn(ownerOf(tokenId), tokenId);
1037     }
1038 
1039     /**
1040      * @dev Internal function to transfer ownership of a given token ID to another address.
1041      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1042      * @param from current owner of the token
1043      * @param to address to receive the ownership of the given token ID
1044      * @param tokenId uint256 ID of the token to be transferred
1045      */
1046     function _transferFrom(address from, address to, uint256 tokenId) internal {
1047         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _clearApproval(tokenId);
1051 
1052         _ownedTokensCount[from].decrement();
1053         _ownedTokensCount[to].increment();
1054 
1055         _tokenOwner[tokenId] = to;
1056 
1057         emit Transfer(from, to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1062      * The call is not executed if the target address is not a contract.
1063      *
1064      * This function is deprecated.
1065      * @param from address representing the previous owner of the given token ID
1066      * @param to target address that will receive the tokens
1067      * @param tokenId uint256 ID of the token to be transferred
1068      * @param _data bytes optional data to send along with the call
1069      * @return bool whether the call correctly returned the expected magic value
1070      */
1071     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1072         internal returns (bool)
1073     {
1074         if (!to.isContract()) {
1075             return true;
1076         }
1077 
1078         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
1079         return (retval == _ERC721_RECEIVED);
1080     }
1081 
1082     /**
1083      * @dev Private function to clear current approval of a given token ID.
1084      * @param tokenId uint256 ID of the token to be transferred
1085      */
1086     function _clearApproval(uint256 tokenId) private {
1087         if (_tokenApprovals[tokenId] != address(0)) {
1088             _tokenApprovals[tokenId] = address(0);
1089         }
1090     }
1091 }
1092 
1093 
1094 /**
1095  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1096  * @dev See https://eips.ethereum.org/EIPS/eip-721
1097  */
1098 contract IERC721Metadata is IERC721 {
1099     function name() external view returns (string memory);
1100     function symbol() external view returns (string memory);
1101     function tokenURI(uint256 tokenId) external view returns (string memory);
1102 }
1103 
1104 
1105 contract MultiTransfer is IERC721 {
1106 
1107     function transferBatch(
1108         address from,
1109         address to,
1110         uint256 start,
1111         uint256 end
1112     )
1113         public
1114     {
1115         for (uint i = start; i < end; i++) {
1116             transferFrom(from, to, i);
1117         }
1118     }
1119 
1120     function transferAllFrom(
1121         address from,
1122         address to,
1123         uint256[] memory tokenIDs
1124     )
1125         public
1126     {
1127         for (uint i = 0; i < tokenIDs.length; i++) {
1128             transferFrom(from, to, tokenIDs[i]);
1129         }
1130     }
1131 
1132     function safeTransferBatch(
1133         address from,
1134         address to,
1135         uint256 start,
1136         uint256 end
1137     )
1138         public
1139     {
1140         for (uint i = start; i < end; i++) {
1141             safeTransferFrom(from, to, i);
1142         }
1143     }
1144 
1145     function safeTransferAllFrom(
1146         address from,
1147         address to,
1148         uint256[] memory tokenIDs
1149     )
1150         public
1151     {
1152         for (uint i = 0; i < tokenIDs.length; i++) {
1153             safeTransferFrom(from, to, tokenIDs[i]);
1154         }
1155     }
1156 
1157 }
1158 
1159 contract ICards is IERC721 {
1160 
1161     struct Batch {
1162         uint48 userID;
1163         uint16 size;
1164     }
1165 
1166     function batches(uint index) public view returns (uint48 userID, uint16 size);
1167 
1168     function userIDToAddress(uint48 id) public view returns (address);
1169 
1170     function getDetails(
1171         uint tokenId
1172     )
1173         public
1174         view
1175         returns (
1176         uint16 proto,
1177         uint8 quality
1178     );
1179 
1180     function setQuality(
1181         uint tokenId,
1182         uint8 quality
1183     ) public;
1184 
1185     function mintCards(
1186         address to,
1187         uint16[] memory _protos,
1188         uint8[] memory _qualities
1189     )
1190         public
1191         returns (uint);
1192 
1193     function mintCard(
1194         address to,
1195         uint16 _proto,
1196         uint8 _quality
1197     )
1198         public
1199         returns (uint);
1200 
1201     function burn(uint tokenId) public;
1202 
1203     function batchSize()
1204         public
1205         view
1206         returns (uint);
1207 }
1208 
1209 
1210 
1211 
1212 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1213     // Token name
1214     string private _name;
1215 
1216     // Token symbol
1217     string private _symbol;
1218 
1219     // Optional mapping for token URIs
1220     mapping(uint256 => string) private _tokenURIs;
1221 
1222     /*
1223      *     bytes4(keccak256('name()')) == 0x06fdde03
1224      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1225      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1226      *
1227      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1228      */
1229     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1230 
1231     /**
1232      * @dev Constructor function
1233      */
1234     constructor (string memory name, string memory symbol) public {
1235         _name = name;
1236         _symbol = symbol;
1237 
1238         // register the supported interfaces to conform to ERC721 via ERC165
1239         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1240     }
1241 
1242     /**
1243      * @dev Gets the token name.
1244      * @return string representing the token name
1245      */
1246     function name() external view returns (string memory) {
1247         return _name;
1248     }
1249 
1250     /**
1251      * @dev Gets the token symbol.
1252      * @return string representing the token symbol
1253      */
1254     function symbol() external view returns (string memory) {
1255         return _symbol;
1256     }
1257 
1258     /**
1259      * @dev Returns an URI for a given token ID.
1260      * Throws if the token ID does not exist. May return an empty string.
1261      * @param tokenId uint256 ID of the token to query
1262      */
1263     function tokenURI(uint256 tokenId) external view returns (string memory) {
1264         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1265         return _tokenURIs[tokenId];
1266     }
1267 
1268     /**
1269      * @dev Internal function to set the token URI for a given token.
1270      * Reverts if the token ID does not exist.
1271      * @param tokenId uint256 ID of the token to set its URI
1272      * @param uri string URI to assign
1273      */
1274     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1275         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1276         _tokenURIs[tokenId] = uri;
1277     }
1278 
1279     /**
1280      * @dev Internal function to burn a specific token.
1281      * Reverts if the token does not exist.
1282      * Deprecated, use _burn(uint256) instead.
1283      * @param owner owner of the token to burn
1284      * @param tokenId uint256 ID of the token being burned by the msg.sender
1285      */
1286     function _burn(address owner, uint256 tokenId) internal {
1287         super._burn(owner, tokenId);
1288 
1289         // Clear metadata (if any)
1290         if (bytes(_tokenURIs[tokenId]).length != 0) {
1291             delete _tokenURIs[tokenId];
1292         }
1293     }
1294 }
1295 
1296 
1297 
1298 contract BatchToken is ERC721Metadata {
1299 
1300     using SafeMath for uint256;
1301 
1302     struct Batch {
1303         uint48 userID;
1304         uint16 size;
1305     }
1306 
1307     mapping(uint48 => address) public userIDToAddress;
1308     mapping(address => uint48) public addressToUserID;
1309 
1310     uint256 public batchSize;
1311     uint256 public nextBatch;
1312     uint256 public tokenCount;
1313 
1314     uint48[] internal ownerIDs;
1315     uint48[] internal approvedIDs;
1316 
1317     mapping(uint => Batch) public batches;
1318 
1319     uint48 internal userCount = 1;
1320 
1321     mapping(address => uint) internal _balances;
1322 
1323     uint256 internal constant MAX_LENGTH = uint(2**256 - 1);
1324 
1325     constructor(
1326         uint256 _batchSize,
1327         string memory name,
1328         string memory symbol
1329     )
1330         public
1331         ERC721Metadata(name, symbol)
1332     {
1333         batchSize = _batchSize;
1334         ownerIDs.length = MAX_LENGTH;
1335         approvedIDs.length = MAX_LENGTH;
1336     }
1337 
1338     function _getUserID(address to)
1339         internal
1340         returns (uint48)
1341     {
1342         if (to == address(0)) {
1343             return 0;
1344         }
1345         uint48 uID = addressToUserID[to];
1346         if (uID == 0) {
1347             require(
1348                 userCount + 1 > userCount,
1349                 "BT: must not overflow"
1350             );
1351             uID = userCount++;
1352             userIDToAddress[uID] = to;
1353             addressToUserID[to] = uID;
1354         }
1355         return uID;
1356     }
1357 
1358     function _batchMint(
1359         address to,
1360         uint16 size
1361     )
1362         internal
1363         returns (uint)
1364     {
1365         require(
1366             to != address(0),
1367             "BT: must not be null"
1368         );
1369 
1370         require(
1371             size > 0 && size <= batchSize,
1372             "BT: size must be within limits"
1373         );
1374 
1375         uint256 start = nextBatch;
1376         uint48 uID = _getUserID(to);
1377         batches[start] = Batch({
1378             userID: uID,
1379             size: size
1380         });
1381         uint256 end = start.add(size);
1382         for (uint256 i = start; i < end; i++) {
1383             emit Transfer(address(0), to, i);
1384         }
1385         nextBatch = nextBatch.add(batchSize);
1386         _balances[to] = _balances[to].add(size);
1387         tokenCount = tokenCount.add(size);
1388         return start;
1389     }
1390 
1391     function getBatchStart(uint256 tokenId) public view returns (uint) {
1392         return tokenId.div(batchSize).mul(batchSize);
1393     }
1394 
1395     function getBatch(uint256 index) public view returns (uint48 userID, uint16 size) {
1396         return (batches[index].userID, batches[index].size);
1397     }
1398 
1399     // Overridden ERC721 functions
1400     // @OZ: please stop making variables/functions private
1401 
1402     function ownerOf(uint256 tokenId)
1403         public
1404         view
1405         returns (address)
1406     {
1407         uint48 uID = ownerIDs[tokenId];
1408         if (uID == 0) {
1409             uint256 start = getBatchStart(tokenId);
1410             Batch memory b = batches[start];
1411 
1412             require(
1413                 start + b.size > tokenId,
1414                 "BT: token does not exist"
1415             );
1416 
1417             uID = b.userID;
1418             require(
1419                 uID != 0,
1420                 "BT: bad batch owner"
1421             );
1422         }
1423         return userIDToAddress[uID];
1424     }
1425 
1426     function _transferFrom(
1427         address from,
1428         address to,
1429         uint256 tokenId
1430     )
1431         internal
1432     {
1433         require(
1434             ownerOf(tokenId) == from,
1435             "BT: transfer of token that is not own"
1436         );
1437 
1438         require(
1439             to != address(0),
1440             "BT: transfer to the zero address"
1441         );
1442 
1443         require(
1444             _isApprovedOrOwner(msg.sender, tokenId),
1445             "BT: caller is not owner nor approved"
1446         );
1447 
1448         _cancelApproval(tokenId);
1449         _balances[from] = _balances[from].sub(1);
1450         _balances[to] = _balances[to].add(1);
1451         ownerIDs[tokenId] = _getUserID(to);
1452         emit Transfer(from, to, tokenId);
1453     }
1454 
1455     function _burn(uint256 tokenId) internal {
1456 
1457         require(
1458             _isApprovedOrOwner(msg.sender, tokenId),
1459             "BT: caller is not owner nor approved"
1460         );
1461 
1462         _cancelApproval(tokenId);
1463         address owner = ownerOf(tokenId);
1464         _balances[owner] = _balances[owner].sub(1);
1465         ownerIDs[tokenId] = 0;
1466         tokenCount = tokenCount.sub(1);
1467         emit Transfer(owner, address(0), tokenId);
1468     }
1469 
1470     function _cancelApproval(uint256 tokenId) internal {
1471         if (approvedIDs[tokenId] != 0) {
1472             approvedIDs[tokenId] = 0;
1473         }
1474     }
1475 
1476     function approve(address to, uint256 tokenId) public {
1477         address owner = ownerOf(tokenId);
1478 
1479         require(
1480             to != owner,
1481             "BT: approval to current owner"
1482         );
1483 
1484         require(
1485             msg.sender == owner || isApprovedForAll(owner, msg.sender),
1486             "BT: approve caller is not owner nor approved for all"
1487         );
1488 
1489         approvedIDs[tokenId] = _getUserID(to);
1490         emit Approval(owner, to, tokenId);
1491     }
1492 
1493     function _exists(uint256 tokenId)
1494         internal
1495         view
1496         returns (bool)
1497     {
1498         return ownerOf(tokenId) != address(0);
1499     }
1500 
1501     function getApproved(uint256 tokenId)
1502         public
1503         view
1504         returns (address)
1505     {
1506         require(
1507             _exists(tokenId),
1508             "BT: approved query for nonexistent token"
1509         );
1510 
1511         return userIDToAddress[approvedIDs[tokenId]];
1512     }
1513 
1514     function totalSupply()
1515         public
1516         view
1517         returns (uint)
1518     {
1519         return tokenCount;
1520     }
1521 
1522     function balanceOf(address _owner)
1523         public
1524         view
1525         returns (uint256)
1526     {
1527         return _balances[_owner];
1528     }
1529 
1530 }
1531 
1532 // solium-disable security/no-inline-assembly
1533 
1534 
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 contract NewCards is Ownable, MultiTransfer, BatchToken, InscribableToken {
1543 
1544     uint16 private constant MAX_UINT16 = 2**16 - 1;
1545 
1546     uint16[] internal cardProtos;
1547     uint8[] internal cardQualities;
1548 
1549     struct Season {
1550         uint16 high;
1551         uint16 low;
1552     }
1553 
1554     struct Proto {
1555         bool locked;
1556         bool exists;
1557         uint8 god;
1558         uint8 cardType;
1559         uint8 rarity;
1560         uint8 mana;
1561         uint8 attack;
1562         uint8 health;
1563         uint8 tribe;
1564     }
1565 
1566     event ProtoUpdated(
1567         uint16 indexed id
1568     );
1569 
1570     event SeasonStarted(
1571         uint16 indexed id,
1572         string name,
1573         uint16 indexed low,
1574         uint16 indexed high
1575     );
1576 
1577     event QualityChanged(
1578         uint256 indexed tokenId,
1579         uint8 quality,
1580         address factory
1581     );
1582 
1583     event CardsMinted(
1584         uint256 indexed start,
1585         address to,
1586         uint16[] protos,
1587         uint8[] qualities
1588     );
1589 
1590     // Value of index proto = season
1591     uint16[] public protoToSeason;
1592 
1593     address public propertyManager;
1594 
1595     // Array containing all protos
1596     Proto[] public protos;
1597 
1598     // Array containing all seasons
1599     Season[] public seasons;
1600 
1601     // Map whether a season is tradeable or not
1602     mapping(uint256 => bool) public seasonTradable;
1603 
1604     // Map whether a factory has been authorised or not
1605     mapping(address => mapping(uint256 => bool)) public factoryApproved;
1606 
1607     // Whether a factory is approved to create a particular mythic
1608     mapping(uint16 => mapping(address => bool)) public mythicApproved;
1609 
1610     // Whether a mythic is tradable
1611     mapping(uint16 => bool) public mythicTradable;
1612 
1613     // Map whether a mythic exists or not
1614     mapping(uint16 => bool) public mythicCreated;
1615 
1616     uint16 public constant MYTHIC_THRESHOLD = 65000;
1617 
1618     constructor(
1619         uint256 _batchSize,
1620         string memory _name,
1621         string memory _symbol
1622     )
1623         public
1624         BatchToken(_batchSize, _name, _symbol)
1625     {
1626         cardProtos.length = MAX_LENGTH;
1627         cardQualities.length = MAX_LENGTH;
1628         protoToSeason.length = MAX_LENGTH;
1629         protos.length = MAX_LENGTH;
1630         propertyManager = msg.sender;
1631     }
1632 
1633     function getDetails(
1634         uint256 tokenId
1635     )
1636         public
1637         view
1638         returns (uint16 proto, uint8 quality)
1639     {
1640         return (cardProtos[tokenId], cardQualities[tokenId]);
1641     }
1642 
1643     function mintCard(
1644         address to,
1645         uint16 _proto,
1646         uint8 _quality
1647     )
1648         public
1649         returns (uint id)
1650     {
1651         id = _batchMint(to, 1);
1652         _validateProto(_proto);
1653         cardProtos[id] = _proto;
1654         cardQualities[id] = _quality;
1655 
1656         uint16[] memory ps = new uint16[](1);
1657         ps[0] = _proto;
1658 
1659         uint8[] memory qs = new uint8[](1);
1660         qs[0] = _quality;
1661 
1662         emit CardsMinted(id, to, ps, qs);
1663         return id;
1664     }
1665 
1666     function mintCards(
1667         address to,
1668         uint16[] memory _protos,
1669         uint8[] memory _qualities
1670     )
1671         public
1672         returns (uint)
1673     {
1674         require(
1675             _protos.length > 0,
1676             "Core: must be some protos"
1677         );
1678 
1679         require(
1680             _protos.length == _qualities.length,
1681             "Core: must be the same number of protos/qualities"
1682         );
1683 
1684         uint256 start = _batchMint(to, uint16(_protos.length));
1685         _validateAndSaveDetails(start, _protos, _qualities);
1686 
1687         emit CardsMinted(start, to, _protos, _qualities);
1688 
1689         return start;
1690     }
1691 
1692     function addFactory(
1693         address _factory,
1694         uint256 _season
1695     )
1696         public
1697         onlyOwner
1698     {
1699         require(
1700             seasons.length >= _season,
1701             "Core: season must exist"
1702         );
1703 
1704         require(
1705             _season > 0,
1706             "Core: season must not be 0"
1707         );
1708 
1709         require(
1710             !factoryApproved[_factory][_season],
1711             "Core: this factory is already approved"
1712         );
1713 
1714         require(
1715             !seasonTradable[_season],
1716             "Core: season must not be tradable"
1717         );
1718 
1719         factoryApproved[_factory][_season] = true;
1720     }
1721 
1722     function approveForMythic(
1723         address _factory,
1724         uint16 _mythic
1725     )
1726         public
1727         onlyOwner
1728     {
1729         require(
1730             _mythic >= MYTHIC_THRESHOLD,
1731             "not a mythic"
1732         );
1733 
1734         require(
1735             !mythicApproved[_mythic][_factory],
1736             "Core: this factory is already approved for this mythic"
1737         );
1738 
1739         mythicApproved[_mythic][_factory] = true;
1740     }
1741 
1742     function makeMythicTradable(
1743         uint16 _mythic
1744     )
1745         public
1746         onlyOwner
1747     {
1748         require(
1749             _mythic >= MYTHIC_THRESHOLD,
1750             "Core: not a mythic"
1751         );
1752 
1753         require(
1754             !mythicTradable[_mythic],
1755             "Core: must not be tradable already"
1756         );
1757 
1758         mythicTradable[_mythic] = true;
1759     }
1760 
1761     function unlockTrading(
1762         uint256 _season
1763     )
1764         public
1765         onlyOwner
1766     {
1767         require(
1768             _season > 0 && _season <= seasons.length,
1769             "Core: must be a current season"
1770         );
1771 
1772         require(
1773             !seasonTradable[_season],
1774             "Core: season must not be tradable"
1775         );
1776 
1777         seasonTradable[_season] = true;
1778     }
1779 
1780     function _transferFrom(
1781         address from,
1782         address to,
1783         uint256 tokenId
1784     )
1785         internal
1786     {
1787         require(
1788             isTradable(tokenId),
1789             "Core: not yet tradable"
1790         );
1791 
1792         super._transferFrom(from, to, tokenId);
1793     }
1794 
1795     function burn(uint256 _tokenId) public {
1796         require(
1797             isTradable(_tokenId),
1798             "Core: not yet tradable"
1799         );
1800 
1801         super._burn(_tokenId);
1802     }
1803 
1804     function burnAll(uint256[] memory tokenIDs) public {
1805         for (uint256 i = 0; i < tokenIDs.length; i++) {
1806             burn(tokenIDs[i]);
1807         }
1808     }
1809 
1810     function isTradable(uint256 _tokenId) public view returns (bool) {
1811         uint16 proto = cardProtos[_tokenId];
1812         if (proto >= MYTHIC_THRESHOLD) {
1813             return mythicTradable[proto];
1814         }
1815         return seasonTradable[protoToSeason[proto]];
1816     }
1817 
1818     function startSeason(
1819         string memory name,
1820         uint16 low,
1821         uint16 high
1822     )
1823         public
1824         onlyOwner
1825         returns (uint)
1826     {
1827         require(
1828             low > 0,
1829             "Core: must not be zero proto"
1830         );
1831 
1832         require(
1833             high > low,
1834             "Core: must be a valid range"
1835         );
1836 
1837         require(
1838             seasons.length == 0 || low > seasons[seasons.length - 1].high,
1839             "Core: seasons cannot overlap"
1840         );
1841 
1842         require(
1843             MYTHIC_THRESHOLD > high,
1844             "Core: cannot go into mythic territory"
1845         );
1846 
1847         // seasons start at 1
1848         uint16 id = uint16(seasons.push(Season({ high: high, low: low })));
1849 
1850         uint256 cp;
1851         assembly { cp := protoToSeason_slot }
1852         StorageWrite.repeatUint16(cp, low, (high - low) + 1, id);
1853 
1854         emit SeasonStarted(id, name, low, high);
1855 
1856         return id;
1857     }
1858 
1859     function updateProtos(
1860         uint16[] memory _ids,
1861         uint8[] memory _gods,
1862         uint8[] memory _cardTypes,
1863         uint8[] memory _rarities,
1864         uint8[] memory _manas,
1865         uint8[] memory _attacks,
1866         uint8[] memory _healths,
1867         uint8[] memory _tribes
1868     ) public onlyOwner {
1869         for (uint256 i = 0; i < _ids.length; i++) {
1870             uint16 id = _ids[i];
1871 
1872             require(
1873                 id > 0,
1874                 "Core: proto must not be zero"
1875             );
1876 
1877             Proto memory proto = protos[id];
1878             require(
1879                 !proto.locked,
1880                 "Core: proto is locked"
1881             );
1882 
1883             protos[id] = Proto({
1884                 locked: false,
1885                 exists: true,
1886                 god: _gods[i],
1887                 cardType: _cardTypes[i],
1888                 rarity: _rarities[i],
1889                 mana: _manas[i],
1890                 attack: _attacks[i],
1891                 health: _healths[i],
1892                 tribe: _tribes[i]
1893             });
1894             emit ProtoUpdated(id);
1895         }
1896     }
1897 
1898     function lockProtos(uint16[] memory _ids) public onlyOwner {
1899         require(
1900             _ids.length > 0,
1901             "must lock some"
1902         );
1903 
1904         for (uint256 i = 0; i < _ids.length; i++) {
1905             uint16 id = _ids[i];
1906             require(
1907                 id > 0,
1908                 "proto must not be zero"
1909             );
1910 
1911             Proto storage proto = protos[id];
1912 
1913             require(
1914                 !proto.locked,
1915                 "proto is locked"
1916             );
1917 
1918             require(
1919                 proto.exists,
1920                 "proto must exist"
1921             );
1922 
1923             proto.locked = true;
1924             emit ProtoUpdated(id);
1925         }
1926     }
1927 
1928     function _validateAndSaveDetails(
1929         uint256 start,
1930         uint16[] memory _protos,
1931         uint8[] memory _qualities
1932     )
1933         internal
1934     {
1935         _validateProtos(_protos);
1936 
1937         uint256 cp;
1938         assembly { cp := cardProtos_slot }
1939         StorageWrite.uint16s(cp, start, _protos);
1940         uint256 cq;
1941         assembly { cq := cardQualities_slot }
1942         StorageWrite.uint8s(cq, start, _qualities);
1943     }
1944 
1945     function _validateProto(uint16 proto) internal {
1946         if (proto >= MYTHIC_THRESHOLD) {
1947             _checkCanCreateMythic(proto);
1948         } else {
1949 
1950             uint256 season = protoToSeason[proto];
1951 
1952             require(
1953                 season != 0,
1954                 "Core: must have season set"
1955             );
1956 
1957             require(
1958                 factoryApproved[msg.sender][season],
1959                 "Core: must be approved factory for this season"
1960             );
1961         }
1962     }
1963 
1964     function _validateProtos(uint16[] memory _protos) internal {
1965         uint16 maxProto = 0;
1966         uint16 minProto = MAX_UINT16;
1967         for (uint256 i = 0; i < _protos.length; i++) {
1968             uint16 proto = _protos[i];
1969             if (proto >= MYTHIC_THRESHOLD) {
1970                 _checkCanCreateMythic(proto);
1971             } else {
1972                 if (proto > maxProto) {
1973                     maxProto = proto;
1974                 }
1975                 if (minProto > proto) {
1976                     minProto = proto;
1977                 }
1978             }
1979         }
1980 
1981         if (maxProto != 0) {
1982             uint256 season = protoToSeason[maxProto];
1983             // cards must be from the same season
1984             require(
1985                 season != 0,
1986                 "Core: must have season set"
1987             );
1988 
1989             require(
1990                 season == protoToSeason[minProto],
1991                 "Core: can only create cards from the same season"
1992             );
1993 
1994             require(
1995                 factoryApproved[msg.sender][season],
1996                 "Core: must be approved factory for this season"
1997             );
1998         }
1999     }
2000 
2001     function _checkCanCreateMythic(uint16 proto) internal {
2002 
2003         require(
2004             mythicApproved[proto][msg.sender],
2005             "Core: not approved to create this mythic"
2006         );
2007 
2008         require(
2009             !mythicCreated[proto],
2010             "Core: mythic has already been created"
2011         );
2012 
2013         mythicCreated[proto] = true;
2014     }
2015 
2016     function setQuality(
2017         uint256 _tokenId,
2018         uint8 _quality
2019     )
2020         public
2021     {
2022         uint16 proto = cardProtos[_tokenId];
2023         // wont' be able to change mythic season
2024         uint256 season = protoToSeason[proto];
2025 
2026         require(
2027             factoryApproved[msg.sender][season],
2028             "Core: factory can't change quality of this season"
2029         );
2030 
2031         cardQualities[_tokenId] = _quality;
2032         emit QualityChanged(_tokenId, _quality, msg.sender);
2033     }
2034 
2035     function setPropertyManager(address _manager) public onlyOwner {
2036         propertyManager = _manager;
2037     }
2038 
2039     function setProperty(uint256 _id, bytes32 _key, bytes32 _value) public {
2040         require(
2041             msg.sender == propertyManager,
2042             "Core: must be property manager"
2043         );
2044 
2045         _setProperty(_id, _key, _value);
2046     }
2047 
2048     function setClassProperty(bytes32 _key, bytes32 _value) public {
2049         require(
2050             msg.sender == propertyManager,
2051             "Core: must be property manager"
2052         );
2053 
2054         _setClassProperty(_key, _value);
2055     }
2056 
2057     string public baseURI = "https://api.immutable.com/asset/";
2058 
2059     function setBaseURI(string memory uri) public onlyOwner {
2060         baseURI = uri;
2061     }
2062 
2063     function tokenURI(uint256 tokenId) external view returns (string memory) {
2064         return string(abi.encodePacked(
2065             baseURI,
2066             String.fromAddress(address(this)),
2067             "/",
2068             String.fromUint(tokenId)
2069         ));
2070     }
2071 
2072 }
2073 
2074 
2075 // solium-disable security/no-inline-assembly
2076 
2077 
2078 
2079 
2080 
2081 
2082 
2083 
2084 
2085 contract Cards is Ownable, MultiTransfer, BatchToken, ImmutableToken, InscribableToken {
2086 
2087     uint16 private constant MAX_UINT16 = 2**16 - 1;
2088 
2089     uint16[] public cardProtos;
2090     uint8[] public cardQualities;
2091 
2092     struct Season {
2093         uint16 high;
2094         uint16 low;
2095     }
2096 
2097     struct Proto {
2098         bool locked;
2099         bool exists;
2100         uint8 god;
2101         uint8 cardType;
2102         uint8 rarity;
2103         uint8 mana;
2104         uint8 attack;
2105         uint8 health;
2106         uint8 tribe;
2107     }
2108 
2109     event ProtoUpdated(
2110         uint16 indexed id
2111     );
2112 
2113     event SeasonStarted(
2114         uint16 indexed id,
2115         string name,
2116         uint16 indexed low,
2117         uint16 indexed high
2118     );
2119 
2120     event QualityChanged(
2121         uint256 indexed tokenId,
2122         uint8 quality,
2123         address factory
2124     );
2125 
2126     event CardsMinted(
2127         uint256 indexed start,
2128         address to,
2129         uint16[] protos,
2130         uint8[] qualities
2131     );
2132 
2133     // Value of index proto = season
2134     uint16[] public protoToSeason;
2135 
2136     address public propertyManager;
2137 
2138     // Array containing all protos
2139     Proto[] public protos;
2140 
2141     // Array containing all seasons
2142     Season[] public seasons;
2143 
2144     // Map whether a season is tradeable or not
2145     mapping(uint256 => bool) public seasonTradable;
2146 
2147     // Map whether a factory has been authorised or not
2148     mapping(address => mapping(uint256 => bool)) public factoryApproved;
2149 
2150     // Whether a factory is approved to create a particular mythic
2151     mapping(uint16 => mapping(address => bool)) public mythicApproved;
2152 
2153     // Whether a mythic is tradable
2154     mapping(uint16 => bool) public mythicTradable;
2155 
2156     // Map whether a mythic exists or not
2157     mapping(uint16 => bool) public mythicCreated;
2158 
2159     uint16 public constant MYTHIC_THRESHOLD = 65000;
2160 
2161     constructor(
2162         uint256 _batchSize,
2163         string memory _name,
2164         string memory _symbol
2165     )
2166         public
2167         BatchToken(_batchSize, _name, _symbol)
2168     {
2169         cardProtos.length = MAX_LENGTH;
2170         cardQualities.length = MAX_LENGTH;
2171         protoToSeason.length = MAX_LENGTH;
2172         protos.length = MAX_LENGTH;
2173         propertyManager = msg.sender;
2174     }
2175 
2176     function getDetails(
2177         uint256 tokenId
2178     )
2179         public
2180         view
2181         returns (uint16 proto, uint8 quality)
2182     {
2183         return (cardProtos[tokenId], cardQualities[tokenId]);
2184     }
2185 
2186     function mintCard(
2187         address to,
2188         uint16 _proto,
2189         uint8 _quality
2190     )
2191         external
2192         returns (uint id)
2193     {
2194         id = _batchMint(to, 1);
2195         _validateProto(_proto);
2196         cardProtos[id] = _proto;
2197         cardQualities[id] = _quality;
2198 
2199         uint16[] memory ps = new uint16[](1);
2200         ps[0] = _proto;
2201 
2202         uint8[] memory qs = new uint8[](1);
2203         qs[0] = _quality;
2204 
2205         emit CardsMinted(id, to, ps, qs);
2206         return id;
2207     }
2208 
2209     function mintCards(
2210         address to,
2211         uint16[] calldata _protos,
2212         uint8[] calldata _qualities
2213     )
2214         external
2215         returns (uint)
2216     {
2217         require(
2218             _protos.length > 0,
2219             "Core: must be some protos"
2220         );
2221 
2222         require(
2223             _protos.length == _qualities.length,
2224             "Core: must be the same number of protos/qualities"
2225         );
2226 
2227         uint256 start = _batchMint(to, uint16(_protos.length));
2228         _validateAndSaveDetails(start, _protos, _qualities);
2229 
2230         emit CardsMinted(start, to, _protos, _qualities);
2231 
2232         return start;
2233     }
2234 
2235     function addFactory(
2236         address _factory,
2237         uint256 _season
2238     )
2239         public
2240         onlyOwner
2241     {
2242         require(
2243             seasons.length >= _season,
2244             "Core: season must exist"
2245         );
2246 
2247         require(
2248             _season > 0,
2249             "Core: season must not be 0"
2250         );
2251 
2252         require(
2253             !factoryApproved[_factory][_season],
2254             "Core: this factory is already approved"
2255         );
2256 
2257         require(
2258             !seasonTradable[_season],
2259             "Core: season must not be tradable"
2260         );
2261 
2262         factoryApproved[_factory][_season] = true;
2263     }
2264 
2265     function approveForMythic(
2266         address _factory,
2267         uint16 _mythic
2268     )
2269         public
2270         onlyOwner
2271     {
2272         require(
2273             _mythic >= MYTHIC_THRESHOLD,
2274             "not a mythic"
2275         );
2276 
2277         require(
2278             !mythicApproved[_mythic][_factory],
2279             "Core: this factory is already approved for this mythic"
2280         );
2281 
2282         mythicApproved[_mythic][_factory] = true;
2283     }
2284 
2285     function makeMythicTradable(
2286         uint16 _mythic
2287     )
2288         public
2289         onlyOwner
2290     {
2291         require(
2292             _mythic >= MYTHIC_THRESHOLD,
2293             "Core: not a mythic"
2294         );
2295 
2296         require(
2297             !mythicTradable[_mythic],
2298             "Core: must not be tradable already"
2299         );
2300 
2301         mythicTradable[_mythic] = true;
2302     }
2303 
2304     function unlockTrading(
2305         uint256 _season
2306     )
2307         public
2308         onlyOwner
2309     {
2310         require(
2311             _season > 0 && _season <= seasons.length,
2312             "Core: must be a current season"
2313         );
2314 
2315         require(
2316             !seasonTradable[_season],
2317             "Core: season must not be tradable"
2318         );
2319 
2320         seasonTradable[_season] = true;
2321     }
2322 
2323     function transferFrom(
2324         address from,
2325         address to,
2326         uint256 tokenId
2327     )
2328         public
2329     {
2330         require(
2331             isTradable(tokenId),
2332             "Core: not yet tradable"
2333         );
2334 
2335         super.transferFrom(from, to, tokenId);
2336     }
2337 
2338     function burn(uint256 _tokenId) public {
2339         require(
2340             isTradable(_tokenId),
2341             "Core: not yet tradable"
2342         );
2343 
2344         super._burn(_tokenId);
2345     }
2346 
2347     function burnAll(uint256[] memory tokenIDs) public {
2348         for (uint256 i = 0; i < tokenIDs.length; i++) {
2349             burn(tokenIDs[i]);
2350         }
2351     }
2352 
2353     function isTradable(uint256 _tokenId) public view returns (bool) {
2354         uint16 proto = cardProtos[_tokenId];
2355         if (proto >= MYTHIC_THRESHOLD) {
2356             return mythicTradable[proto];
2357         }
2358         return seasonTradable[protoToSeason[proto]];
2359     }
2360 
2361     function startSeason(
2362         string memory name,
2363         uint16 low,
2364         uint16 high
2365     )
2366         public
2367         onlyOwner
2368         returns (uint)
2369     {
2370         require(
2371             low > 0,
2372             "Core: must not be zero proto"
2373         );
2374 
2375         require(
2376             high > low,
2377             "Core: must be a valid range"
2378         );
2379 
2380         require(
2381             seasons.length == 0 || low > seasons[seasons.length - 1].high,
2382             "Core: seasons cannot overlap"
2383         );
2384 
2385         require(
2386             MYTHIC_THRESHOLD > high,
2387             "Core: cannot go into mythic territory"
2388         );
2389 
2390         // seasons start at 1
2391         uint16 id = uint16(seasons.push(Season({ high: high, low: low })));
2392 
2393         uint256 cp;
2394         assembly { cp := protoToSeason_slot }
2395         StorageWrite.repeatUint16(cp, low, (high - low) + 1, id);
2396 
2397         emit SeasonStarted(id, name, low, high);
2398 
2399         return id;
2400     }
2401 
2402     function updateProtos(
2403         uint16[] memory _ids,
2404         uint8[] memory _gods,
2405         uint8[] memory _cardTypes,
2406         uint8[] memory _rarities,
2407         uint8[] memory _manas,
2408         uint8[] memory _attacks,
2409         uint8[] memory _healths,
2410         uint8[] memory _tribes
2411     ) public onlyOwner {
2412         for (uint256 i = 0; i < _ids.length; i++) {
2413             uint16 id = _ids[i];
2414 
2415             require(
2416                 id > 0,
2417                 "Core: proto must not be zero"
2418             );
2419 
2420             Proto memory proto = protos[id];
2421             require(
2422                 !proto.locked,
2423                 "Core: proto is locked"
2424             );
2425 
2426             protos[id] = Proto({
2427                 locked: false,
2428                 exists: true,
2429                 god: _gods[i],
2430                 cardType: _cardTypes[i],
2431                 rarity: _rarities[i],
2432                 mana: _manas[i],
2433                 attack: _attacks[i],
2434                 health: _healths[i],
2435                 tribe: _tribes[i]
2436             });
2437             emit ProtoUpdated(id);
2438         }
2439     }
2440 
2441     function lockProtos(uint16[] memory _ids) public onlyOwner {
2442         require(
2443             _ids.length > 0,
2444             "must lock some"
2445         );
2446 
2447         for (uint256 i = 0; i < _ids.length; i++) {
2448             uint16 id = _ids[i];
2449             require(
2450                 id > 0,
2451                 "proto must not be zero"
2452             );
2453 
2454             Proto storage proto = protos[id];
2455 
2456             require(
2457                 !proto.locked,
2458                 "proto is locked"
2459             );
2460 
2461             require(
2462                 proto.exists,
2463                 "proto must exist"
2464             );
2465 
2466             proto.locked = true;
2467             emit ProtoUpdated(id);
2468         }
2469     }
2470 
2471     function _validateAndSaveDetails(
2472         uint256 start,
2473         uint16[] memory _protos,
2474         uint8[] memory _qualities
2475     )
2476         internal
2477     {
2478         _validateProtos(_protos);
2479 
2480         uint256 cp;
2481         assembly { cp := cardProtos_slot }
2482         StorageWrite.uint16s(cp, start, _protos);
2483         uint256 cq;
2484         assembly { cq := cardQualities_slot }
2485         StorageWrite.uint8s(cq, start, _qualities);
2486     }
2487 
2488     function _validateProto(uint16 proto) internal {
2489         if (proto >= MYTHIC_THRESHOLD) {
2490             _checkCanCreateMythic(proto);
2491         } else {
2492 
2493             uint256 season = protoToSeason[proto];
2494 
2495             require(
2496                 season != 0,
2497                 "Core: must have season set"
2498             );
2499 
2500             require(
2501                 factoryApproved[msg.sender][season],
2502                 "Core: must be approved factory for this season"
2503             );
2504         }
2505     }
2506 
2507     function _validateProtos(uint16[] memory _protos) internal {
2508         uint16 maxProto = 0;
2509         uint16 minProto = MAX_UINT16;
2510         for (uint256 i = 0; i < _protos.length; i++) {
2511             uint16 proto = _protos[i];
2512             if (proto >= MYTHIC_THRESHOLD) {
2513                 _checkCanCreateMythic(proto);
2514             } else {
2515                 if (proto > maxProto) {
2516                     maxProto = proto;
2517                 }
2518                 if (minProto > proto) {
2519                     minProto = proto;
2520                 }
2521             }
2522         }
2523 
2524         if (maxProto != 0) {
2525             uint256 season = protoToSeason[maxProto];
2526             // cards must be from the same season
2527             require(
2528                 season != 0,
2529                 "Core: must have season set"
2530             );
2531 
2532             require(
2533                 season == protoToSeason[minProto],
2534                 "Core: can only create cards from the same season"
2535             );
2536 
2537             require(
2538                 factoryApproved[msg.sender][season],
2539                 "Core: must be approved factory for this season"
2540             );
2541         }
2542     }
2543 
2544     function _checkCanCreateMythic(uint16 proto) internal {
2545 
2546         require(
2547             mythicApproved[proto][msg.sender],
2548             "Core: not approved to create this mythic"
2549         );
2550 
2551         require(
2552             !mythicCreated[proto],
2553             "Core: mythic has already been created"
2554         );
2555 
2556         mythicCreated[proto] = true;
2557     }
2558 
2559     function setQuality(
2560         uint256 _tokenId,
2561         uint8 _quality
2562     )
2563         public
2564     {
2565         uint16 proto = cardProtos[_tokenId];
2566         // wont' be able to change mythic season
2567         uint256 season = protoToSeason[proto];
2568 
2569         require(
2570             factoryApproved[msg.sender][season],
2571             "Core: factory can't change quality of this season"
2572         );
2573 
2574         cardQualities[_tokenId] = _quality;
2575         emit QualityChanged(_tokenId, _quality, msg.sender);
2576     }
2577 
2578     function setPropertyManager(address _manager) public onlyOwner {
2579         propertyManager = _manager;
2580     }
2581 
2582     function setProperty(uint256 _id, bytes32 _key, bytes32 _value) public {
2583         require(
2584             msg.sender == propertyManager,
2585             "Core: must be property manager"
2586         );
2587 
2588         _setProperty(_id, _key, _value);
2589     }
2590 
2591     function setClassProperty(bytes32 _key, bytes32 _value) public {
2592         require(
2593             msg.sender == propertyManager,
2594             "Core: must be property manager"
2595         );
2596 
2597         _setClassProperty(_key, _value);
2598     }
2599 
2600 }
2601 
2602 
2603 
2604 contract BatchWrapper is NewCards {
2605 
2606     uint16 private constant MAX_UINT16 = 2**16 - 1;
2607     Cards public old;
2608     bool public migrating;
2609 
2610     constructor(
2611         Cards _old,
2612         uint256 _batchSize,
2613         string memory _name,
2614         string memory _symbol
2615     ) public NewCards(_batchSize, _name, _symbol) {
2616         old = _old;
2617     }
2618 
2619     function setMigrating(bool _migrating) public onlyOwner {
2620         migrating = _migrating;
2621     }
2622 
2623     function copyUntil(uint gasThreshold) public {
2624         while (gasleft() > gasThreshold) {
2625             copyNextBatch();
2626         }
2627     }
2628 
2629     function mintCards(address _to, uint16[] memory _protos, uint8[] memory _qualities) public returns (uint id) {
2630         require(!migrating, "must not be migrating");
2631         super.mintCards(_to, _protos, _qualities);
2632     }
2633 
2634     function mintCard(address _to, uint16 _proto, uint8 _quality) public returns (uint id) {
2635         require(!migrating, "must not be migrating");
2636         super.mintCard(_to, _proto, _quality);
2637     }
2638 
2639     // copy all batches from the old contracts
2640     // leave ids intact
2641     function copyNextBatch() public {
2642         require(migrating, "must be migrating");
2643         uint256 start = nextBatch;
2644         (uint48 userID, uint16 size) = old.batches(start);
2645         require(size > 0 && userID > 0, "incorrect batch or limit reached");
2646         if (old.cardProtos(start) != 0) {
2647             address to = old.userIDToAddress(userID);
2648             uint48 uID = _getUserID(to);
2649             batches[start] = Batch({
2650                 userID: uID,
2651                 size: size
2652             });
2653             uint256 end = start.add(size);
2654             for (uint256 i = start; i < end; i++) {
2655                 emit Transfer(address(0), to, i);
2656             }
2657             _balances[to] = _balances[to].add(size);
2658             tokenCount = tokenCount.add(size);
2659         }
2660         nextBatch = nextBatch.add(batchSize);
2661     }
2662 
2663     function isOld(uint _tokenId) public view returns (bool) {
2664         require(_exists(_tokenId), "card does not exist");
2665         return cardProtos[_tokenId] == 0;
2666     }
2667 
2668     function getProto(uint _tokenId) public view returns (uint16) {
2669         return isOld(_tokenId) ? old.cardProtos(_tokenId) : cardProtos[_tokenId];
2670     }
2671 
2672     function getQuality(uint _tokenId) public view returns (uint8) {
2673         return isOld(_tokenId) ? old.cardQualities(_tokenId) : cardQualities[_tokenId];
2674     }
2675 
2676     function getDetails(uint256 tokenId) public view returns (uint16 proto, uint8 quality) {
2677         return isOld(tokenId) ? old.getDetails(tokenId) : (cardProtos[tokenId], cardQualities[tokenId]);
2678     }
2679 
2680     function isTradable(uint256 _tokenId) public view returns (bool) {
2681         uint16 proto = getProto(_tokenId);
2682         if (proto >= MYTHIC_THRESHOLD) {
2683             return mythicTradable[proto];
2684         }
2685         return seasonTradable[protoToSeason[proto]];
2686     }
2687 
2688     function _transferFrom(address from, address to, uint tokenId) internal {
2689         require(
2690             isTradable(tokenId),
2691             "BW: not yet tradable"
2692         );
2693         super._transferFrom(from, to, tokenId);
2694     }
2695 
2696     // update validate protos to check if a proto is 0
2697     // prevent untradable cards
2698     function _validateProtos(uint16[] memory _protos) internal {
2699 
2700         uint16 maxProto = 0;
2701         uint16 minProto = MAX_UINT16;
2702         for (uint256 i = 0; i < _protos.length; i++) {
2703             uint16 proto = _protos[i];
2704             if (proto >= MYTHIC_THRESHOLD) {
2705                 _checkCanCreateMythic(proto);
2706             } else {
2707                 require(proto != 0, "proto is zero");
2708                 if (proto > maxProto) {
2709                     maxProto = proto;
2710                 }
2711                 if (minProto > proto) {
2712                     minProto = proto;
2713                 }
2714             }
2715         }
2716 
2717         if (maxProto != 0) {
2718             uint256 season = protoToSeason[maxProto];
2719             // cards must be from the same season
2720             require(
2721                 season != 0,
2722                 "Core: must have season set"
2723             );
2724 
2725             require(
2726                 season == protoToSeason[minProto],
2727                 "Core: can only create cards from the same season"
2728             );
2729 
2730             require(
2731                 factoryApproved[msg.sender][season],
2732                 "Core: must be approved factory for this season"
2733             );
2734         }
2735     }
2736 
2737 }