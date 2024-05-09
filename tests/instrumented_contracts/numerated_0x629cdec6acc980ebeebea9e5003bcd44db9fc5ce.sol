1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-29
3 */
4 
5 pragma solidity 0.5.11;
6 
7 /**
8  * @dev Contract module which provides a basic access control mechanism, where
9  * there is an account (an owner) that can be granted exclusive access to
10  * specific functions.
11  *
12  * This module is used through inheritance. It will make available the modifier
13  * `onlyOwner`, which can be aplied to your functions to restrict their use to
14  * the owner.
15  */
16 contract Ownable {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor () internal {
25         _owner = msg.sender;
26         emit OwnershipTransferred(address(0), _owner);
27     }
28 
29     /**
30      * @dev Returns the address of the current owner.
31      */
32     function owner() public view returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(isOwner(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     /**
45      * @dev Returns true if the caller is the current owner.
46      */
47     function isOwner() public view returns (bool) {
48         return msg.sender == _owner;
49     }
50 
51     /**
52      * @dev Leaves the contract without owner. It will not be possible to call
53      * `onlyOwner` functions anymore. Can only be called by the current owner.
54      *
55      * > Note: Renouncing ownership will leave the contract without an owner,
56      * thereby removing any functionality that is only available to the owner.
57      */
58     function renounceOwnership() public onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     /**
64      * @dev Transfers ownership of the contract to a new account (`newOwner`).
65      * Can only be called by the current owner.
66      */
67     function transferOwnership(address newOwner) public onlyOwner {
68         _transferOwnership(newOwner);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      */
74     function _transferOwnership(address newOwner) internal {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         uint256 c = a - b;
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Solidity only automatically asserts when dividing by 0
164         require(b > 0, "SafeMath: division by zero");
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b != 0, "SafeMath: modulo by zero");
184         return a % b;
185     }
186 }
187 
188 
189 contract InscribableToken {
190 
191     mapping(bytes32 => bytes32) public properties;
192 
193     event ClassPropertySet(
194         bytes32 indexed key,
195         bytes32 value
196     );
197 
198     event TokenPropertySet(
199         uint indexed id,
200         bytes32 indexed key,
201         bytes32 value
202     );
203 
204     function _setProperty(
205         uint _id,
206         bytes32 _key,
207         bytes32 _value
208     )
209         internal
210     {
211         properties[getTokenKey(_id, _key)] = _value;
212         emit TokenPropertySet(_id, _key, _value);
213     }
214 
215     function getProperty(
216         uint _id,
217         bytes32 _key
218     )
219         public
220         view
221         returns (bytes32 _value)
222     {
223         return properties[getTokenKey(_id, _key)];
224     }
225 
226     function _setClassProperty(
227         bytes32 _key,
228         bytes32 _value
229     )
230         internal
231     {
232         emit ClassPropertySet(_key, _value);
233         properties[getClassKey(_key)] = _value;
234     }
235 
236     function getTokenKey(
237         uint _tokenId,
238         bytes32 _key
239     )
240         public
241         pure
242         returns (bytes32)
243     {
244         // one prefix to prevent collisions
245         return keccak256(abi.encodePacked(uint(1), _tokenId, _key));
246     }
247 
248     function getClassKey(bytes32 _key)
249         public
250         pure
251         returns (bytes32)
252     {
253         // zero prefix to prevent collisions
254         return keccak256(abi.encodePacked(uint(0), _key));
255     }
256 
257     function getClassProperty(bytes32 _key)
258         public
259         view
260         returns (bytes32)
261     {
262         return properties[getClassKey(_key)];
263     }
264 
265 }
266 
267 // solium-disable security/no-inline-assembly
268 
269 
270 library StorageWrite {
271 
272     using SafeMath for uint256;
273 
274     function _getStorageArraySlot(uint _dest, uint _index) internal view returns (uint result) {
275         uint slot = _getArraySlot(_dest, _index);
276         assembly { result := sload(slot) }
277     }
278 
279     function _getArraySlot(uint _dest, uint _index) internal pure returns (uint slot) {
280         assembly {
281             let free := mload(0x40)
282             mstore(free, _dest)
283             slot := add(keccak256(free, 32), _index)
284         }
285     }
286 
287     function _setArraySlot(uint _dest, uint _index, uint _value) internal {
288         uint slot = _getArraySlot(_dest, _index);
289         assembly { sstore(slot, _value) }
290     }
291 
292     function _loadSlots(uint _slot, uint _offset, uint _perSlot, uint _length) internal view returns (uint[] memory slots) {
293         uint slotCount = _slotCount(_offset, _perSlot, _length);
294         slots = new uint[](slotCount);
295         // top and tail the slots
296         uint firstPos = _pos(_offset, _perSlot); // _offset.div(_perSlot);
297         slots[0] = _getStorageArraySlot(_slot, firstPos);
298         if (slotCount > 1) {
299             uint lastPos = _pos(_offset.add(_length), _perSlot); // .div(_perSlot);
300             slots[slotCount-1] = _getStorageArraySlot(_slot, lastPos);
301         }
302     }
303 
304     function _pos(uint items, uint perPage) internal pure returns (uint) {
305         return items / perPage;
306     }
307 
308     function _slotCount(uint _offset, uint _perSlot, uint _length) internal pure returns (uint) {
309         uint start = _offset / _perSlot;
310         uint end = (_offset + _length) / _perSlot;
311         return (end - start) + 1;
312     }
313 
314     function _saveSlots(uint _slot, uint _offset, uint _size, uint[] memory _slots) internal {
315         uint offset = _offset.div((256/_size));
316         for (uint i = 0; i < _slots.length; i++) {
317             _setArraySlot(_slot, offset + i, _slots[i]);
318         }
319     }
320 
321     function _write(uint[] memory _slots, uint _offset, uint _size, uint _index, uint _value) internal pure {
322         uint perSlot = 256 / _size;
323         uint initialOffset = _offset % perSlot;
324         uint slotPosition = (initialOffset + _index) / perSlot;
325         uint withinSlot = ((_index + _offset) % perSlot) * _size;
326         // evil bit shifting magic
327         for (uint q = 0; q < _size; q += 8) {
328             _slots[slotPosition] |= ((_value >> q) & 0xFF) << (withinSlot + q);
329         }
330     }
331 
332     function repeatUint16(uint _slot, uint _offset, uint _length, uint16 _item) internal {
333         uint[] memory slots = _loadSlots(_slot, _offset, 16, _length);
334         for (uint i = 0; i < _length; i++) {
335             _write(slots, _offset, 16, i, _item);
336         }
337         _saveSlots(_slot, _offset, 16, slots);
338     }
339 
340     function uint16s(uint _slot, uint _offset, uint16[] memory _items) internal {
341         uint[] memory slots = _loadSlots(_slot, _offset, 16, _items.length);
342         for (uint i = 0; i < _items.length; i++) {
343             _write(slots, _offset, 16, i, _items[i]);
344         }
345         _saveSlots(_slot, _offset, 16, slots);
346     }
347 
348     function uint8s(uint _slot, uint _offset, uint8[] memory _items) internal {
349         uint[] memory slots = _loadSlots(_slot, _offset, 32, _items.length);
350         for (uint i = 0; i < _items.length; i++) {
351             _write(slots, _offset, 8, i, _items[i]);
352         }
353         _saveSlots(_slot, _offset, 8, slots);
354     }
355 
356 }
357 
358 library String {
359 
360     /**
361      * @dev Converts a `uint256` to a `string`.
362      * via OraclizeAPI - MIT licence
363      * https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
364      */
365     function fromUint(uint256 value) internal pure returns (string memory) {
366         if (value == 0) {
367             return "0";
368         }
369         uint256 temp = value;
370         uint256 digits;
371         while (temp != 0) {
372             digits++;
373             temp /= 10;
374         }
375         bytes memory buffer = new bytes(digits);
376         uint256 index = digits - 1;
377         temp = value;
378         while (temp != 0) {
379             buffer[index--] = byte(uint8(48 + temp % 10));
380             temp /= 10;
381         }
382         return string(buffer);
383     }
384 
385     bytes constant alphabet = "0123456789abcdef";
386 
387     function fromAddress(address _addr) internal pure returns(string memory) {
388         bytes32 value = bytes32(uint256(_addr));
389         bytes memory str = new bytes(42);
390         str[0] = '0';
391         str[1] = 'x';
392         for (uint i = 0; i < 20; i++) {
393             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
394             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0F))];
395         }
396         return string(str);
397     }
398 
399 }
400 
401 /**
402  * @title ERC721 token receiver interface
403  * @dev Interface for any contract that wants to support safeTransfers
404  * from ERC721 asset contracts.
405  */
406 contract IERC721Receiver {
407     /**
408      * @notice Handle the receipt of an NFT
409      * @dev The ERC721 smart contract calls this function on the recipient
410      * after a `safeTransfer`. This function MUST return the function selector,
411      * otherwise the caller will revert the transaction. The selector to be
412      * returned can be obtained as `this.onERC721Received.selector`. This
413      * function MAY throw to revert and reject the transfer.
414      * Note: the ERC721 contract address is always the message sender.
415      * @param operator The address which called `safeTransferFrom` function
416      * @param from The address which previously owned the token
417      * @param tokenId The NFT identifier which is being transferred
418      * @param data Additional data with no specified format
419      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
420      */
421     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
422     public returns (bytes4);
423 }
424 
425 
426 /**
427  * @dev Collection of functions related to the address type,
428  */
429 library Address {
430     /**
431      * @dev Returns true if `account` is a contract.
432      *
433      * This test is non-exhaustive, and there may be false-negatives: during the
434      * execution of a contract's constructor, its address will be reported as
435      * not containing a contract.
436      *
437      * > It is unsafe to assume that an address for which this function returns
438      * false is an externally-owned account (EOA) and not a contract.
439      */
440     function isContract(address account) internal view returns (bool) {
441         // This method relies in extcodesize, which returns 0 for contracts in
442         // construction, since the code is only stored at the end of the
443         // constructor execution.
444 
445         uint256 size;
446         // solhint-disable-next-line no-inline-assembly
447         assembly { size := extcodesize(account) }
448         return size > 0;
449     }
450 }
451 
452 
453 /**
454  * @title Counters
455  * @author Matt Condon (@shrugs)
456  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
457  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
458  *
459  * Include with `using Counters for Counters.Counter;`
460  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
461  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
462  * directly accessed.
463  */
464 library Counters {
465     using SafeMath for uint256;
466 
467     struct Counter {
468         // This variable should never be directly accessed by users of the library: interactions must be restricted to
469         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
470         // this feature: see https://github.com/ethereum/solidity/issues/4637
471         uint256 _value; // default: 0
472     }
473 
474     function current(Counter storage counter) internal view returns (uint256) {
475         return counter._value;
476     }
477 
478     function increment(Counter storage counter) internal {
479         counter._value += 1;
480     }
481 
482     function decrement(Counter storage counter) internal {
483         counter._value = counter._value.sub(1);
484     }
485 }
486 
487 
488 /**
489  * @dev Interface of the ERC165 standard, as defined in the
490  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
491  *
492  * Implementers can declare support of contract interfaces, which can then be
493  * queried by others (`ERC165Checker`).
494  *
495  * For an implementation, see `ERC165`.
496  */
497 interface IERC165 {
498     /**
499      * @dev Returns true if this contract implements the interface defined by
500      * `interfaceId`. See the corresponding
501      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
502      * to learn more about how these ids are created.
503      *
504      * This function call must use less than 30 000 gas.
505      */
506     function supportsInterface(bytes4 interfaceId) external view returns (bool);
507 }
508 
509 contract ImmutableToken {
510 
511     string public constant baseURI = "https://api.immutable.com/asset/";
512 
513     function tokenURI(uint256 tokenId) external view returns (string memory) {
514         return string(abi.encodePacked(
515             baseURI,
516             String.fromAddress(address(this)),
517             "/",
518             String.fromUint(tokenId)
519         ));
520     }
521 
522 }
523 
524 /**
525  * @dev Required interface of an ERC721 compliant contract.
526  */
527 contract IERC721 is IERC165 {
528     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
529     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
530     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
531 
532     /**
533      * @dev Returns the number of NFTs in `owner`'s account.
534      */
535     function balanceOf(address owner) public view returns (uint256 balance);
536 
537     /**
538      * @dev Returns the owner of the NFT specified by `tokenId`.
539      */
540     function ownerOf(uint256 tokenId) public view returns (address owner);
541 
542     /**
543      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
544      * another (`to`).
545      *
546      * 
547      *
548      * Requirements:
549      * - `from`, `to` cannot be zero.
550      * - `tokenId` must be owned by `from`.
551      * - If the caller is not `from`, it must be have been allowed to move this
552      * NFT by either `approve` or `setApproveForAll`.
553      */
554     function safeTransferFrom(address from, address to, uint256 tokenId) public;
555     /**
556      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
557      * another (`to`).
558      *
559      * Requirements:
560      * - If the caller is not `from`, it must be approved to move this NFT by
561      * either `approve` or `setApproveForAll`.
562      */
563     function transferFrom(address from, address to, uint256 tokenId) public;
564     function approve(address to, uint256 tokenId) public;
565     function getApproved(uint256 tokenId) public view returns (address operator);
566 
567     function setApprovalForAll(address operator, bool _approved) public;
568     function isApprovedForAll(address owner, address operator) public view returns (bool);
569 
570 
571     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
572 }
573 
574 
575 /**
576  * @dev Implementation of the `IERC165` interface.
577  *
578  * Contracts may inherit from this and call `_registerInterface` to declare
579  * their support of an interface.
580  */
581 contract ERC165 is IERC165 {
582     /*
583      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
584      */
585     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
586 
587     /**
588      * @dev Mapping of interface ids to whether or not it's supported.
589      */
590     mapping(bytes4 => bool) private _supportedInterfaces;
591 
592     constructor () internal {
593         // Derived contracts need only register support for their own interfaces,
594         // we register support for ERC165 itself here
595         _registerInterface(_INTERFACE_ID_ERC165);
596     }
597 
598     /**
599      * @dev See `IERC165.supportsInterface`.
600      *
601      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
602      */
603     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
604         return _supportedInterfaces[interfaceId];
605     }
606 
607     /**
608      * @dev Registers the contract as an implementer of the interface defined by
609      * `interfaceId`. Support of the actual ERC165 interface is automatic and
610      * registering its interface id is not required.
611      *
612      * See `IERC165.supportsInterface`.
613      *
614      * Requirements:
615      *
616      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
617      */
618     function _registerInterface(bytes4 interfaceId) internal {
619         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
620         _supportedInterfaces[interfaceId] = true;
621     }
622 }
623 
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 contract IERC721Metadata is IERC721 {
630     function name() external view returns (string memory);
631     function symbol() external view returns (string memory);
632     function tokenURI(uint256 tokenId) external view returns (string memory);
633 }
634 
635 
636 contract ICards is IERC721 {
637 
638     function getDetails(uint tokenId) public view returns (uint16 proto, uint8 quality);
639     function setQuality(uint tokenId, uint8 quality) public;
640     function burn(uint tokenId) public;
641     function batchMintCards(address to, uint16[] memory _protos, uint8[] memory _qualities) public returns (uint);
642     function mintCards(address to, uint16[] memory _protos, uint8[] memory _qualities) public returns (uint);
643     function mintCard(address to, uint16 _proto, uint8 _quality) public returns (uint);
644     function batchSize() public view returns (uint);
645 }
646 
647 
648 
649 
650 
651 
652 /**
653  * @title ERC721 Non-Fungible Token Standard basic implementation
654  * @dev see https://eips.ethereum.org/EIPS/eip-721
655  */
656 contract ERC721 is ERC165, IERC721 {
657     using SafeMath for uint256;
658     using Address for address;
659     using Counters for Counters.Counter;
660 
661     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
662     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
663     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
664 
665     // Mapping from token ID to owner
666     mapping (uint256 => address) private _tokenOwner;
667 
668     // Mapping from token ID to approved address
669     mapping (uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to number of owned token
672     mapping (address => Counters.Counter) private _ownedTokensCount;
673 
674     // Mapping from owner to operator approvals
675     mapping (address => mapping (address => bool)) private _operatorApprovals;
676 
677     /*
678      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
679      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
680      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
681      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
682      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
683      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
684      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
685      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
686      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
687      *
688      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
689      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
690      */
691     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
692 
693     constructor () public {
694         // register the supported interfaces to conform to ERC721 via ERC165
695         _registerInterface(_INTERFACE_ID_ERC721);
696     }
697 
698     /**
699      * @dev Gets the balance of the specified address.
700      * @param owner address to query the balance of
701      * @return uint256 representing the amount owned by the passed address
702      */
703     function balanceOf(address owner) public view returns (uint256) {
704         require(owner != address(0), "ERC721: balance query for the zero address");
705 
706         return _ownedTokensCount[owner].current();
707     }
708 
709     /**
710      * @dev Gets the owner of the specified token ID.
711      * @param tokenId uint256 ID of the token to query the owner of
712      * @return address currently marked as the owner of the given token ID
713      */
714     function ownerOf(uint256 tokenId) public view returns (address) {
715         address owner = _tokenOwner[tokenId];
716         require(owner != address(0), "ERC721: owner query for nonexistent token");
717 
718         return owner;
719     }
720 
721     /**
722      * @dev Approves another address to transfer the given token ID
723      * The zero address indicates there is no approved address.
724      * There can only be one approved address per token at a given time.
725      * Can only be called by the token owner or an approved operator.
726      * @param to address to be approved for the given token ID
727      * @param tokenId uint256 ID of the token to be approved
728      */
729     function approve(address to, uint256 tokenId) public {
730         address owner = ownerOf(tokenId);
731         require(to != owner, "ERC721: approval to current owner");
732 
733         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
734             "ERC721: approve caller is not owner nor approved for all"
735         );
736 
737         _tokenApprovals[tokenId] = to;
738         emit Approval(owner, to, tokenId);
739     }
740 
741     /**
742      * @dev Gets the approved address for a token ID, or zero if no address set
743      * Reverts if the token ID does not exist.
744      * @param tokenId uint256 ID of the token to query the approval of
745      * @return address currently approved for the given token ID
746      */
747     function getApproved(uint256 tokenId) public view returns (address) {
748         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
749 
750         return _tokenApprovals[tokenId];
751     }
752 
753     /**
754      * @dev Sets or unsets the approval of a given operator
755      * An operator is allowed to transfer all tokens of the sender on their behalf.
756      * @param to operator address to set the approval
757      * @param approved representing the status of the approval to be set
758      */
759     function setApprovalForAll(address to, bool approved) public {
760         require(to != msg.sender, "ERC721: approve to caller");
761 
762         _operatorApprovals[msg.sender][to] = approved;
763         emit ApprovalForAll(msg.sender, to, approved);
764     }
765 
766     /**
767      * @dev Tells whether an operator is approved by a given owner.
768      * @param owner owner address which you want to query the approval of
769      * @param operator operator address which you want to query the approval of
770      * @return bool whether the given operator is approved by the given owner
771      */
772     function isApprovedForAll(address owner, address operator) public view returns (bool) {
773         return _operatorApprovals[owner][operator];
774     }
775 
776     /**
777      * @dev Transfers the ownership of a given token ID to another address.
778      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
779      * Requires the msg.sender to be the owner, approved, or operator.
780      * @param from current owner of the token
781      * @param to address to receive the ownership of the given token ID
782      * @param tokenId uint256 ID of the token to be transferred
783      */
784     function transferFrom(address from, address to, uint256 tokenId) public {
785         //solhint-disable-next-line max-line-length
786         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
787 
788         _transferFrom(from, to, tokenId);
789     }
790 
791     /**
792      * @dev Safely transfers the ownership of a given token ID to another address
793      * If the target address is a contract, it must implement `onERC721Received`,
794      * which is called upon a safe transfer, and return the magic value
795      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
796      * the transfer is reverted.
797      * Requires the msg.sender to be the owner, approved, or operator
798      * @param from current owner of the token
799      * @param to address to receive the ownership of the given token ID
800      * @param tokenId uint256 ID of the token to be transferred
801      */
802     function safeTransferFrom(address from, address to, uint256 tokenId) public {
803         safeTransferFrom(from, to, tokenId, "");
804     }
805 
806     /**
807      * @dev Safely transfers the ownership of a given token ID to another address
808      * If the target address is a contract, it must implement `onERC721Received`,
809      * which is called upon a safe transfer, and return the magic value
810      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
811      * the transfer is reverted.
812      * Requires the msg.sender to be the owner, approved, or operator
813      * @param from current owner of the token
814      * @param to address to receive the ownership of the given token ID
815      * @param tokenId uint256 ID of the token to be transferred
816      * @param _data bytes data to send along with a safe transfer check
817      */
818     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
819         transferFrom(from, to, tokenId);
820         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
821     }
822 
823     /**
824      * @dev Returns whether the specified token exists.
825      * @param tokenId uint256 ID of the token to query the existence of
826      * @return bool whether the token exists
827      */
828     function _exists(uint256 tokenId) internal view returns (bool) {
829         address owner = _tokenOwner[tokenId];
830         return owner != address(0);
831     }
832 
833     /**
834      * @dev Returns whether the given spender can transfer a given token ID.
835      * @param spender address of the spender to query
836      * @param tokenId uint256 ID of the token to be transferred
837      * @return bool whether the msg.sender is approved for the given token ID,
838      * is an operator of the owner, or is the owner of the token
839      */
840     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
841         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
842         address owner = ownerOf(tokenId);
843         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
844     }
845 
846     /**
847      * @dev Internal function to mint a new token.
848      * Reverts if the given token ID already exists.
849      * @param to The address that will own the minted token
850      * @param tokenId uint256 ID of the token to be minted
851      */
852     function _mint(address to, uint256 tokenId) internal {
853         require(to != address(0), "ERC721: mint to the zero address");
854         require(!_exists(tokenId), "ERC721: token already minted");
855 
856         _tokenOwner[tokenId] = to;
857         _ownedTokensCount[to].increment();
858 
859         emit Transfer(address(0), to, tokenId);
860     }
861 
862     /**
863      * @dev Internal function to burn a specific token.
864      * Reverts if the token does not exist.
865      * Deprecated, use _burn(uint256) instead.
866      * @param owner owner of the token to burn
867      * @param tokenId uint256 ID of the token being burned
868      */
869     function _burn(address owner, uint256 tokenId) internal {
870         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
871 
872         _clearApproval(tokenId);
873 
874         _ownedTokensCount[owner].decrement();
875         _tokenOwner[tokenId] = address(0);
876 
877         emit Transfer(owner, address(0), tokenId);
878     }
879 
880     /**
881      * @dev Internal function to burn a specific token.
882      * Reverts if the token does not exist.
883      * @param tokenId uint256 ID of the token being burned
884      */
885     function _burn(uint256 tokenId) internal {
886         _burn(ownerOf(tokenId), tokenId);
887     }
888 
889     /**
890      * @dev Internal function to transfer ownership of a given token ID to another address.
891      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
892      * @param from current owner of the token
893      * @param to address to receive the ownership of the given token ID
894      * @param tokenId uint256 ID of the token to be transferred
895      */
896     function _transferFrom(address from, address to, uint256 tokenId) internal {
897         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
898         require(to != address(0), "ERC721: transfer to the zero address");
899 
900         _clearApproval(tokenId);
901 
902         _ownedTokensCount[from].decrement();
903         _ownedTokensCount[to].increment();
904 
905         _tokenOwner[tokenId] = to;
906 
907         emit Transfer(from, to, tokenId);
908     }
909 
910     /**
911      * @dev Internal function to invoke `onERC721Received` on a target address.
912      * The call is not executed if the target address is not a contract.
913      *
914      * This function is deprecated.
915      * @param from address representing the previous owner of the given token ID
916      * @param to target address that will receive the tokens
917      * @param tokenId uint256 ID of the token to be transferred
918      * @param _data bytes optional data to send along with the call
919      * @return bool whether the call correctly returned the expected magic value
920      */
921     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
922         internal returns (bool)
923     {
924         if (!to.isContract()) {
925             return true;
926         }
927 
928         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
929         return (retval == _ERC721_RECEIVED);
930     }
931 
932     /**
933      * @dev Private function to clear current approval of a given token ID.
934      * @param tokenId uint256 ID of the token to be transferred
935      */
936     function _clearApproval(uint256 tokenId) private {
937         if (_tokenApprovals[tokenId] != address(0)) {
938             _tokenApprovals[tokenId] = address(0);
939         }
940     }
941 }
942 
943 
944 
945 
946 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
947     // Token name
948     string private _name;
949 
950     // Token symbol
951     string private _symbol;
952 
953     // Optional mapping for token URIs
954     mapping(uint256 => string) private _tokenURIs;
955 
956     /*
957      *     bytes4(keccak256('name()')) == 0x06fdde03
958      *     bytes4(keccak256('symbol()')) == 0x95d89b41
959      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
960      *
961      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
962      */
963     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
964 
965     /**
966      * @dev Constructor function
967      */
968     constructor (string memory name, string memory symbol) public {
969         _name = name;
970         _symbol = symbol;
971 
972         // register the supported interfaces to conform to ERC721 via ERC165
973         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
974     }
975 
976     /**
977      * @dev Gets the token name.
978      * @return string representing the token name
979      */
980     function name() external view returns (string memory) {
981         return _name;
982     }
983 
984     /**
985      * @dev Gets the token symbol.
986      * @return string representing the token symbol
987      */
988     function symbol() external view returns (string memory) {
989         return _symbol;
990     }
991 
992     /**
993      * @dev Returns an URI for a given token ID.
994      * Throws if the token ID does not exist. May return an empty string.
995      * @param tokenId uint256 ID of the token to query
996      */
997     function tokenURI(uint256 tokenId) external view returns (string memory) {
998         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
999         return _tokenURIs[tokenId];
1000     }
1001 
1002     /**
1003      * @dev Internal function to set the token URI for a given token.
1004      * Reverts if the token ID does not exist.
1005      * @param tokenId uint256 ID of the token to set its URI
1006      * @param uri string URI to assign
1007      */
1008     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1009         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1010         _tokenURIs[tokenId] = uri;
1011     }
1012 
1013     /**
1014      * @dev Internal function to burn a specific token.
1015      * Reverts if the token does not exist.
1016      * Deprecated, use _burn(uint256) instead.
1017      * @param owner owner of the token to burn
1018      * @param tokenId uint256 ID of the token being burned by the msg.sender
1019      */
1020     function _burn(address owner, uint256 tokenId) internal {
1021         super._burn(owner, tokenId);
1022 
1023         // Clear metadata (if any)
1024         if (bytes(_tokenURIs[tokenId]).length != 0) {
1025             delete _tokenURIs[tokenId];
1026         }
1027     }
1028 }
1029 
1030 
1031 contract MultiTransfer is IERC721 {
1032 
1033     function transferBatch(
1034         address from,
1035         address to,
1036         uint256 start,
1037         uint256 end
1038     )
1039         public
1040     {
1041         for (uint i = start; i < end; i++) {
1042             transferFrom(from, to, i);
1043         }
1044     }
1045 
1046     function transferAllFrom(
1047         address from,
1048         address to,
1049         uint256[] memory tokenIDs
1050     )
1051         public
1052     {
1053         for (uint i = 0; i < tokenIDs.length; i++) {
1054             transferFrom(from, to, tokenIDs[i]);
1055         }
1056     }
1057 
1058     function safeTransferBatch(
1059         address from,
1060         address to,
1061         uint256 start,
1062         uint256 end
1063     )
1064         public
1065     {
1066         for (uint i = start; i < end; i++) {
1067             safeTransferFrom(from, to, i);
1068         }
1069     }
1070 
1071     function safeTransferAllFrom(
1072         address from,
1073         address to,
1074         uint256[] memory tokenIDs
1075     )
1076         public
1077     {
1078         for (uint i = 0; i < tokenIDs.length; i++) {
1079             safeTransferFrom(from, to, tokenIDs[i]);
1080         }
1081     }
1082 
1083 }
1084 
1085 
1086 contract BatchToken is ERC721Metadata {
1087 
1088     using SafeMath for uint256;
1089 
1090     struct Batch {
1091         uint48 userID;
1092         uint16 size;
1093     }
1094 
1095     mapping(uint48 => address) public userIDToAddress;
1096     mapping(address => uint48) public addressToUserID;
1097 
1098     uint256 public batchSize;
1099     uint256 public nextBatch;
1100     uint256 public tokenCount;
1101 
1102     uint48[] internal ownerIDs;
1103     uint48[] internal approvedIDs;
1104 
1105     mapping(uint => Batch) public batches;
1106 
1107     uint48 internal userCount = 1;
1108 
1109     mapping(address => uint) internal _balances;
1110 
1111     uint256 internal constant MAX_LENGTH = uint(2**256 - 1);
1112 
1113     constructor(
1114         uint256 _batchSize,
1115         string memory name,
1116         string memory symbol
1117     )
1118         public
1119         ERC721Metadata(name, symbol)
1120     {
1121         batchSize = _batchSize;
1122         ownerIDs.length = MAX_LENGTH;
1123         approvedIDs.length = MAX_LENGTH;
1124     }
1125 
1126     function _getUserID(address to)
1127         internal
1128         returns (uint48)
1129     {
1130         if (to == address(0)) {
1131             return 0;
1132         }
1133         uint48 uID = addressToUserID[to];
1134         if (uID == 0) {
1135             require(
1136                 userCount + 1 > userCount,
1137                 "BT: must not overflow"
1138             );
1139             uID = userCount++;
1140             userIDToAddress[uID] = to;
1141             addressToUserID[to] = uID;
1142         }
1143         return uID;
1144     }
1145 
1146     function _batchMint(
1147         address to,
1148         uint16 size
1149     )
1150         internal
1151         returns (uint)
1152     {
1153         require(
1154             to != address(0),
1155             "BT: must not be null"
1156         );
1157 
1158         require(
1159             size > 0 && size <= batchSize,
1160             "BT: size must be within limits"
1161         );
1162 
1163         uint256 start = nextBatch;
1164         uint48 uID = _getUserID(to);
1165         batches[start] = Batch({
1166             userID: uID,
1167             size: size
1168         });
1169         uint256 end = start.add(size);
1170         for (uint256 i = start; i < end; i++) {
1171             emit Transfer(address(0), to, i);
1172         }
1173         nextBatch = nextBatch.add(batchSize);
1174         _balances[to] = _balances[to].add(size);
1175         tokenCount = tokenCount.add(size);
1176         return start;
1177     }
1178 
1179     function getBatchStart(uint256 tokenId) public view returns (uint) {
1180         return tokenId.div(batchSize).mul(batchSize);
1181     }
1182 
1183     function getBatch(uint256 index) public view returns (uint48 userID, uint16 size) {
1184         return (batches[index].userID, batches[index].size);
1185     }
1186 
1187     // Overridden ERC721 functions
1188     // @OZ: please stop making variables/functions private
1189 
1190     function ownerOf(uint256 tokenId)
1191         public
1192         view
1193         returns (address)
1194     {
1195         uint48 uID = ownerIDs[tokenId];
1196         if (uID == 0) {
1197             uint256 start = getBatchStart(tokenId);
1198             Batch memory b = batches[start];
1199 
1200             require(
1201                 start + b.size > tokenId,
1202                 "BT: token does not exist"
1203             );
1204 
1205             uID = b.userID;
1206             require(
1207                 uID != 0,
1208                 "BT: bad batch owner"
1209             );
1210         }
1211         return userIDToAddress[uID];
1212     }
1213 
1214     function transferFrom(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     )
1219         public
1220     {
1221         require(
1222             ownerOf(tokenId) == from,
1223             "BT: transfer of token that is not own"
1224         );
1225 
1226         require(
1227             to != address(0),
1228             "BT: transfer to the zero address"
1229         );
1230 
1231         require(
1232             _isApprovedOrOwner(msg.sender, tokenId),
1233             "BT: caller is not owner nor approved"
1234         );
1235 
1236         _cancelApproval(tokenId);
1237         _balances[from] = _balances[from].sub(1);
1238         _balances[to] = _balances[to].add(1);
1239         ownerIDs[tokenId] = _getUserID(to);
1240         emit Transfer(from, to, tokenId);
1241     }
1242 
1243     function burn(uint256 tokenId) public {
1244         require(
1245             _isApprovedOrOwner(msg.sender, tokenId),
1246             "BT: caller is not owner nor approved"
1247         );
1248 
1249         _cancelApproval(tokenId);
1250         address owner = ownerOf(tokenId);
1251         _balances[owner] = _balances[owner].sub(1);
1252         ownerIDs[tokenId] = 0;
1253         tokenCount = tokenCount.sub(1);
1254         emit Transfer(owner, address(0), tokenId);
1255     }
1256 
1257     function _cancelApproval(uint256 tokenId) internal {
1258         if (approvedIDs[tokenId] != 0) {
1259             approvedIDs[tokenId] = 0;
1260         }
1261     }
1262 
1263     function approve(address to, uint256 tokenId) public {
1264         address owner = ownerOf(tokenId);
1265 
1266         require(
1267             to != owner,
1268             "BT: approval to current owner"
1269         );
1270 
1271         require(
1272             msg.sender == owner || isApprovedForAll(owner, msg.sender),
1273             "BT: approve caller is not owner nor approved for all"
1274         );
1275 
1276         approvedIDs[tokenId] = _getUserID(to);
1277         emit Approval(owner, to, tokenId);
1278     }
1279 
1280     function _exists(uint256 tokenId)
1281         internal
1282         view
1283         returns (bool)
1284     {
1285         return ownerOf(tokenId) != address(0);
1286     }
1287 
1288     function getApproved(uint256 tokenId)
1289         public
1290         view
1291         returns (address)
1292     {
1293         require(
1294             _exists(tokenId),
1295             "BT: approved query for nonexistent token"
1296         );
1297 
1298         return userIDToAddress[approvedIDs[tokenId]];
1299     }
1300 
1301     function totalSupply()
1302         public
1303         view
1304         returns (uint)
1305     {
1306         return tokenCount;
1307     }
1308 
1309     function balanceOf(address _owner)
1310         public
1311         view
1312         returns (uint256)
1313     {
1314         return _balances[_owner];
1315     }
1316 
1317 }
1318 
1319 // solium-disable security/no-inline-assembly
1320 
1321 
1322 contract Cards is Ownable, MultiTransfer, BatchToken, ImmutableToken, InscribableToken {
1323 
1324     uint16 private constant MAX_UINT16 = 2**16 - 1;
1325 
1326     uint16[] public cardProtos;
1327     uint8[] public cardQualities;
1328 
1329     struct Season {
1330         uint16 high;
1331         uint16 low;
1332     }
1333 
1334     struct Proto {
1335         bool locked;
1336         bool exists;
1337         uint8 god;
1338         uint8 cardType;
1339         uint8 rarity;
1340         uint8 mana;
1341         uint8 attack;
1342         uint8 health;
1343         uint8 tribe;
1344     }
1345 
1346     event ProtoUpdated(
1347         uint16 indexed id
1348     );
1349 
1350     event SeasonStarted(
1351         uint16 indexed id,
1352         string name,
1353         uint16 indexed low,
1354         uint16 indexed high
1355     );
1356 
1357     event QualityChanged(
1358         uint256 indexed tokenId,
1359         uint8 quality,
1360         address factory
1361     );
1362 
1363     event CardsMinted(
1364         uint256 indexed start,
1365         address to,
1366         uint16[] protos,
1367         uint8[] qualities
1368     );
1369 
1370     // Value of index proto = season
1371     uint16[] public protoToSeason;
1372 
1373     address public propertyManager;
1374 
1375     // Array containing all protos
1376     Proto[] public protos;
1377 
1378     // Array containing all seasons
1379     Season[] public seasons;
1380 
1381     // Map whether a season is tradeable or not
1382     mapping(uint256 => bool) public seasonTradable;
1383 
1384     // Map whether a factory has been authorised or not
1385     mapping(address => mapping(uint256 => bool)) public factoryApproved;
1386 
1387     // Whether a factory is approved to create a particular mythic
1388     mapping(uint16 => mapping(address => bool)) public mythicApproved;
1389 
1390     // Whether a mythic is tradable
1391     mapping(uint16 => bool) public mythicTradable;
1392 
1393     // Map whether a mythic exists or not
1394     mapping(uint16 => bool) public mythicCreated;
1395 
1396     uint16 public constant MYTHIC_THRESHOLD = 65000;
1397 
1398     constructor(
1399         uint256 _batchSize,
1400         string memory _name,
1401         string memory _symbol
1402     )
1403         public
1404         BatchToken(_batchSize, _name, _symbol)
1405     {
1406         cardProtos.length = MAX_LENGTH;
1407         cardQualities.length = MAX_LENGTH;
1408         protoToSeason.length = MAX_LENGTH;
1409         protos.length = MAX_LENGTH;
1410         propertyManager = msg.sender;
1411     }
1412 
1413     function getDetails(
1414         uint256 tokenId
1415     )
1416         public
1417         view
1418         returns (uint16 proto, uint8 quality)
1419     {
1420         return (cardProtos[tokenId], cardQualities[tokenId]);
1421     }
1422 
1423     function mintCard(
1424         address to,
1425         uint16 _proto,
1426         uint8 _quality
1427     )
1428         external
1429         returns (uint id)
1430     {
1431         id = _batchMint(to, 1);
1432         _validateProto(_proto);
1433         cardProtos[id] = _proto;
1434         cardQualities[id] = _quality;
1435 
1436         uint16[] memory ps = new uint16[](1);
1437         ps[0] = _proto;
1438 
1439         uint8[] memory qs = new uint8[](1);
1440         qs[0] = _quality;
1441 
1442         emit CardsMinted(id, to, ps, qs);
1443         return id;
1444     }
1445 
1446     function mintCards(
1447         address to,
1448         uint16[] calldata _protos,
1449         uint8[] calldata _qualities
1450     )
1451         external
1452         returns (uint)
1453     {
1454         require(
1455             _protos.length > 0,
1456             "Core: must be some protos"
1457         );
1458 
1459         require(
1460             _protos.length == _qualities.length,
1461             "Core: must be the same number of protos/qualities"
1462         );
1463 
1464         uint256 start = _batchMint(to, uint16(_protos.length));
1465         _validateAndSaveDetails(start, _protos, _qualities);
1466 
1467         emit CardsMinted(start, to, _protos, _qualities);
1468 
1469         return start;
1470     }
1471 
1472     function addFactory(
1473         address _factory,
1474         uint256 _season
1475     )
1476         public
1477         onlyOwner
1478     {
1479         require(
1480             seasons.length >= _season,
1481             "Core: season must exist"
1482         );
1483 
1484         require(
1485             _season > 0,
1486             "Core: season must not be 0"
1487         );
1488 
1489         require(
1490             !factoryApproved[_factory][_season],
1491             "Core: this factory is already approved"
1492         );
1493 
1494         require(
1495             !seasonTradable[_season],
1496             "Core: season must not be tradable"
1497         );
1498 
1499         factoryApproved[_factory][_season] = true;
1500     }
1501 
1502     function approveForMythic(
1503         address _factory,
1504         uint16 _mythic
1505     )
1506         public
1507         onlyOwner
1508     {
1509         require(
1510             _mythic >= MYTHIC_THRESHOLD,
1511             "not a mythic"
1512         );
1513 
1514         require(
1515             !mythicApproved[_mythic][_factory],
1516             "Core: this factory is already approved for this mythic"
1517         );
1518 
1519         mythicApproved[_mythic][_factory] = true;
1520     }
1521 
1522     function makeMythicTradable(
1523         uint16 _mythic
1524     )
1525         public
1526         onlyOwner
1527     {
1528         require(
1529             _mythic >= MYTHIC_THRESHOLD,
1530             "Core: not a mythic"
1531         );
1532 
1533         require(
1534             !mythicTradable[_mythic],
1535             "Core: must not be tradable already"
1536         );
1537 
1538         mythicTradable[_mythic] = true;
1539     }
1540 
1541     function unlockTrading(
1542         uint256 _season
1543     )
1544         public
1545         onlyOwner
1546     {
1547         require(
1548             _season > 0 && _season <= seasons.length,
1549             "Core: must be a current season"
1550         );
1551 
1552         require(
1553             !seasonTradable[_season],
1554             "Core: season must not be tradable"
1555         );
1556 
1557         seasonTradable[_season] = true;
1558     }
1559 
1560     function transferFrom(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     )
1565         public
1566     {
1567         require(
1568             isTradable(tokenId),
1569             "Core: not yet tradable"
1570         );
1571 
1572         super.transferFrom(from, to, tokenId);
1573     }
1574 
1575     function burn(uint256 _tokenId) public {
1576         require(
1577             isTradable(_tokenId),
1578             "Core: not yet tradable"
1579         );
1580 
1581         super.burn(_tokenId);
1582     }
1583 
1584     function burnAll(uint256[] memory tokenIDs) public {
1585         for (uint256 i = 0; i < tokenIDs.length; i++) {
1586             burn(tokenIDs[i]);
1587         }
1588     }
1589 
1590     function isTradable(uint256 _tokenId) public view returns (bool) {
1591         uint16 proto = cardProtos[_tokenId];
1592         if (proto >= MYTHIC_THRESHOLD) {
1593             return mythicTradable[proto];
1594         }
1595         return seasonTradable[protoToSeason[proto]];
1596     }
1597 
1598     function startSeason(
1599         string memory name,
1600         uint16 low,
1601         uint16 high
1602     )
1603         public
1604         onlyOwner
1605         returns (uint)
1606     {
1607         require(
1608             low > 0,
1609             "Core: must not be zero proto"
1610         );
1611 
1612         require(
1613             high > low,
1614             "Core: must be a valid range"
1615         );
1616 
1617         require(
1618             seasons.length == 0 || low > seasons[seasons.length - 1].high,
1619             "Core: seasons cannot overlap"
1620         );
1621 
1622         require(
1623             MYTHIC_THRESHOLD > high,
1624             "Core: cannot go into mythic territory"
1625         );
1626 
1627         // seasons start at 1
1628         uint16 id = uint16(seasons.push(Season({ high: high, low: low })));
1629 
1630         uint256 cp;
1631         assembly { cp := protoToSeason_slot }
1632         StorageWrite.repeatUint16(cp, low, (high - low) + 1, id);
1633 
1634         emit SeasonStarted(id, name, low, high);
1635 
1636         return id;
1637     }
1638 
1639     function updateProtos(
1640         uint16[] memory _ids,
1641         uint8[] memory _gods,
1642         uint8[] memory _cardTypes,
1643         uint8[] memory _rarities,
1644         uint8[] memory _manas,
1645         uint8[] memory _attacks,
1646         uint8[] memory _healths,
1647         uint8[] memory _tribes
1648     ) public onlyOwner {
1649         for (uint256 i = 0; i < _ids.length; i++) {
1650             uint16 id = _ids[i];
1651 
1652             require(
1653                 id > 0,
1654                 "Core: proto must not be zero"
1655             );
1656 
1657             Proto memory proto = protos[id];
1658             require(
1659                 !proto.locked,
1660                 "Core: proto is locked"
1661             );
1662 
1663             protos[id] = Proto({
1664                 locked: false,
1665                 exists: true,
1666                 god: _gods[i],
1667                 cardType: _cardTypes[i],
1668                 rarity: _rarities[i],
1669                 mana: _manas[i],
1670                 attack: _attacks[i],
1671                 health: _healths[i],
1672                 tribe: _tribes[i]
1673             });
1674             emit ProtoUpdated(id);
1675         }
1676     }
1677 
1678     function lockProtos(uint16[] memory _ids) public onlyOwner {
1679         require(
1680             _ids.length > 0,
1681             "must lock some"
1682         );
1683 
1684         for (uint256 i = 0; i < _ids.length; i++) {
1685             uint16 id = _ids[i];
1686             require(
1687                 id > 0,
1688                 "proto must not be zero"
1689             );
1690 
1691             Proto storage proto = protos[id];
1692 
1693             require(
1694                 !proto.locked,
1695                 "proto is locked"
1696             );
1697 
1698             require(
1699                 proto.exists,
1700                 "proto must exist"
1701             );
1702 
1703             proto.locked = true;
1704             emit ProtoUpdated(id);
1705         }
1706     }
1707 
1708     function _validateAndSaveDetails(
1709         uint256 start,
1710         uint16[] memory _protos,
1711         uint8[] memory _qualities
1712     )
1713         internal
1714     {
1715         _validateProtos(_protos);
1716 
1717         uint256 cp;
1718         assembly { cp := cardProtos_slot }
1719         StorageWrite.uint16s(cp, start, _protos);
1720         uint256 cq;
1721         assembly { cq := cardQualities_slot }
1722         StorageWrite.uint8s(cq, start, _qualities);
1723     }
1724 
1725     function _validateProto(uint16 proto) internal {
1726         if (proto >= MYTHIC_THRESHOLD) {
1727             _checkCanCreateMythic(proto);
1728         } else {
1729 
1730             uint256 season = protoToSeason[proto];
1731 
1732             require(
1733                 season != 0,
1734                 "Core: must have season set"
1735             );
1736 
1737             require(
1738                 factoryApproved[msg.sender][season],
1739                 "Core: must be approved factory for this season"
1740             );
1741         }
1742     }
1743 
1744     function _validateProtos(uint16[] memory _protos) internal {
1745         uint16 maxProto = 0;
1746         uint16 minProto = MAX_UINT16;
1747         for (uint256 i = 0; i < _protos.length; i++) {
1748             uint16 proto = _protos[i];
1749             if (proto >= MYTHIC_THRESHOLD) {
1750                 _checkCanCreateMythic(proto);
1751             } else {
1752                 if (proto > maxProto) {
1753                     maxProto = proto;
1754                 }
1755                 if (minProto > proto) {
1756                     minProto = proto;
1757                 }
1758             }
1759         }
1760 
1761         if (maxProto != 0) {
1762             uint256 season = protoToSeason[maxProto];
1763             // cards must be from the same season
1764             require(
1765                 season != 0,
1766                 "Core: must have season set"
1767             );
1768 
1769             require(
1770                 season == protoToSeason[minProto],
1771                 "Core: can only create cards from the same season"
1772             );
1773 
1774             require(
1775                 factoryApproved[msg.sender][season],
1776                 "Core: must be approved factory for this season"
1777             );
1778         }
1779     }
1780 
1781     function _checkCanCreateMythic(uint16 proto) internal {
1782 
1783         require(
1784             mythicApproved[proto][msg.sender],
1785             "Core: not approved to create this mythic"
1786         );
1787 
1788         require(
1789             !mythicCreated[proto],
1790             "Core: mythic has already been created"
1791         );
1792 
1793         mythicCreated[proto] = true;
1794     }
1795 
1796     function setQuality(
1797         uint256 _tokenId,
1798         uint8 _quality
1799     )
1800         public
1801     {
1802         uint16 proto = cardProtos[_tokenId];
1803         // wont' be able to change mythic season
1804         uint256 season = protoToSeason[proto];
1805 
1806         require(
1807             factoryApproved[msg.sender][season],
1808             "Core: factory can't change quality of this season"
1809         );
1810 
1811         cardQualities[_tokenId] = _quality;
1812         emit QualityChanged(_tokenId, _quality, msg.sender);
1813     }
1814 
1815     function setPropertyManager(address _manager) public onlyOwner {
1816         propertyManager = _manager;
1817     }
1818 
1819     function setProperty(uint256 _id, bytes32 _key, bytes32 _value) public {
1820         require(
1821             msg.sender == propertyManager,
1822             "Core: must be property manager"
1823         );
1824 
1825         _setProperty(_id, _key, _value);
1826     }
1827 
1828     function setClassProperty(bytes32 _key, bytes32 _value) public {
1829         require(
1830             msg.sender == propertyManager,
1831             "Core: must be property manager"
1832         );
1833 
1834         _setClassProperty(_key, _value);
1835     }
1836 
1837 }