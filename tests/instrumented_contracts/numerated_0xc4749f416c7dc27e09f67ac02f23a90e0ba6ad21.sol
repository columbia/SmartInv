1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Interface of the ERC165 standard, as defined in the
116  * https://eips.ethereum.org/EIPS/eip-165[EIP].
117  *
118  * Implementers can declare support of contract interfaces, which can then be
119  * queried by others ({ERC165Checker}).
120  *
121  * For an implementation, see {ERC165}.
122  */
123 interface IERC165 {
124     /**
125      * @dev Returns true if this contract implements the interface defined by
126      * `interfaceId`. See the corresponding
127      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
128      * to learn more about how these ids are created.
129      *
130      * This function call must use less than 30 000 gas.
131      */
132     function supportsInterface(bytes4 interfaceId) external view returns (bool);
133 }
134 
135 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
136 
137 pragma solidity ^0.5.0;
138 
139 
140 /**
141  * @dev Required interface of an ERC721 compliant contract.
142  */
143 contract IERC721 is IERC165 {
144     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
145     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of NFTs in `owner`'s account.
150      */
151     function balanceOf(address owner) public view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the NFT specified by `tokenId`.
155      */
156     function ownerOf(uint256 tokenId) public view returns (address owner);
157 
158     /**
159      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
160      * another (`to`).
161      *
162      *
163      *
164      * Requirements:
165      * - `from`, `to` cannot be zero.
166      * - `tokenId` must be owned by `from`.
167      * - If the caller is not `from`, it must be have been allowed to move this
168      * NFT by either {approve} or {setApprovalForAll}.
169      */
170     function safeTransferFrom(address from, address to, uint256 tokenId) public;
171     /**
172      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
173      * another (`to`).
174      *
175      * Requirements:
176      * - If the caller is not `from`, it must be approved to move this NFT by
177      * either {approve} or {setApprovalForAll}.
178      */
179     function transferFrom(address from, address to, uint256 tokenId) public;
180     function approve(address to, uint256 tokenId) public;
181     function getApproved(uint256 tokenId) public view returns (address operator);
182 
183     function setApprovalForAll(address operator, bool _approved) public;
184     function isApprovedForAll(address owner, address operator) public view returns (bool);
185 
186 
187     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @title ERC721 token receiver interface
196  * @dev Interface for any contract that wants to support safeTransfers
197  * from ERC721 asset contracts.
198  */
199 contract IERC721Receiver {
200     /**
201      * @notice Handle the receipt of an NFT
202      * @dev The ERC721 smart contract calls this function on the recipient
203      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
204      * otherwise the caller will revert the transaction. The selector to be
205      * returned can be obtained as `this.onERC721Received.selector`. This
206      * function MAY throw to revert and reject the transfer.
207      * Note: the ERC721 contract address is always the message sender.
208      * @param operator The address which called `safeTransferFrom` function
209      * @param from The address which previously owned the token
210      * @param tokenId The NFT identifier which is being transferred
211      * @param data Additional data with no specified format
212      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
213      */
214     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
215     public returns (bytes4);
216 }
217 
218 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
219 
220 pragma solidity ^0.5.0;
221 
222 /**
223  * @dev Wrappers over Solidity's arithmetic operations with added overflow
224  * checks.
225  *
226  * Arithmetic operations in Solidity wrap on overflow. This can easily result
227  * in bugs, because programmers usually assume that an overflow raises an
228  * error, which is the standard behavior in high level programming languages.
229  * `SafeMath` restores this intuition by reverting the transaction when an
230  * operation overflows.
231  *
232  * Using this library instead of the unchecked operations eliminates an entire
233  * class of bugs, so it's recommended to use it always.
234  */
235 library SafeMath {
236     /**
237      * @dev Returns the addition of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `+` operator.
241      *
242      * Requirements:
243      * - Addition cannot overflow.
244      */
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a, "SafeMath: addition overflow");
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting on
254      * overflow (when the result is negative).
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      * - Subtraction cannot overflow.
260      */
261     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
262         return sub(a, b, "SafeMath: subtraction overflow");
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * Counterpart to Solidity's `-` operator.
270      *
271      * Requirements:
272      * - Subtraction cannot overflow.
273      *
274      * _Available since v2.4.0._
275      */
276     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b <= a, errorMessage);
278         uint256 c = a - b;
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the multiplication of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `*` operator.
288      *
289      * Requirements:
290      * - Multiplication cannot overflow.
291      */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294         // benefit is lost if 'b' is also tested.
295         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301         require(c / a == b, "SafeMath: multiplication overflow");
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers. Reverts on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      */
317     function div(uint256 a, uint256 b) internal pure returns (uint256) {
318         return div(a, b, "SafeMath: division by zero");
319     }
320 
321     /**
322      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
323      * division by zero. The result is rounded towards zero.
324      *
325      * Counterpart to Solidity's `/` operator. Note: this function uses a
326      * `revert` opcode (which leaves remaining gas untouched) while Solidity
327      * uses an invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      * - The divisor cannot be zero.
331      *
332      * _Available since v2.4.0._
333      */
334     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         // Solidity only automatically asserts when dividing by 0
336         require(b > 0, errorMessage);
337         uint256 c = a / b;
338         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * Reverts when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      * - The divisor cannot be zero.
353      */
354     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
355         return mod(a, b, "SafeMath: modulo by zero");
356     }
357 
358     /**
359      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
360      * Reverts with custom message when dividing by zero.
361      *
362      * Counterpart to Solidity's `%` operator. This function uses a `revert`
363      * opcode (which leaves remaining gas untouched) while Solidity uses an
364      * invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      * - The divisor cannot be zero.
368      *
369      * _Available since v2.4.0._
370      */
371     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b != 0, errorMessage);
373         return a % b;
374     }
375 }
376 
377 // File: openzeppelin-solidity/contracts/utils/Address.sol
378 
379 pragma solidity ^0.5.5;
380 
381 /**
382  * @dev Collection of functions related to the address type
383  */
384 library Address {
385     /**
386      * @dev Returns true if `account` is a contract.
387      *
388      * [IMPORTANT]
389      * ====
390      * It is unsafe to assume that an address for which this function returns
391      * false is an externally-owned account (EOA) and not a contract.
392      *
393      * Among others, `isContract` will return false for the following
394      * types of addresses:
395      *
396      *  - an externally-owned account
397      *  - a contract in construction
398      *  - an address where a contract will be created
399      *  - an address where a contract lived, but was destroyed
400      * ====
401      */
402     function isContract(address account) internal view returns (bool) {
403         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
404         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
405         // for accounts without code, i.e. `keccak256('')`
406         bytes32 codehash;
407         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
408         // solhint-disable-next-line no-inline-assembly
409         assembly { codehash := extcodehash(account) }
410         return (codehash != accountHash && codehash != 0x0);
411     }
412 
413     /**
414      * @dev Converts an `address` into `address payable`. Note that this is
415      * simply a type cast: the actual underlying value is not changed.
416      *
417      * _Available since v2.4.0._
418      */
419     function toPayable(address account) internal pure returns (address payable) {
420         return address(uint160(account));
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      *
439      * _Available since v2.4.0._
440      */
441     function sendValue(address payable recipient, uint256 amount) internal {
442         require(address(this).balance >= amount, "Address: insufficient balance");
443 
444         // solhint-disable-next-line avoid-call-value
445         (bool success, ) = recipient.call.value(amount)("");
446         require(success, "Address: unable to send value, recipient may have reverted");
447     }
448 }
449 
450 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
451 
452 pragma solidity ^0.5.0;
453 
454 
455 /**
456  * @title Counters
457  * @author Matt Condon (@shrugs)
458  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
459  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
460  *
461  * Include with `using Counters for Counters.Counter;`
462  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
463  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
464  * directly accessed.
465  */
466 library Counters {
467     using SafeMath for uint256;
468 
469     struct Counter {
470         // This variable should never be directly accessed by users of the library: interactions must be restricted to
471         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
472         // this feature: see https://github.com/ethereum/solidity/issues/4637
473         uint256 _value; // default: 0
474     }
475 
476     function current(Counter storage counter) internal view returns (uint256) {
477         return counter._value;
478     }
479 
480     function increment(Counter storage counter) internal {
481         // The {SafeMath} overflow check can be skipped here, see the comment at the top
482         counter._value += 1;
483     }
484 
485     function decrement(Counter storage counter) internal {
486         counter._value = counter._value.sub(1);
487     }
488 }
489 
490 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
491 
492 pragma solidity ^0.5.0;
493 
494 
495 /**
496  * @dev Implementation of the {IERC165} interface.
497  *
498  * Contracts may inherit from this and call {_registerInterface} to declare
499  * their support of an interface.
500  */
501 contract ERC165 is IERC165 {
502     /*
503      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
504      */
505     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
506 
507     /**
508      * @dev Mapping of interface ids to whether or not it's supported.
509      */
510     mapping(bytes4 => bool) private _supportedInterfaces;
511 
512     constructor () internal {
513         // Derived contracts need only register support for their own interfaces,
514         // we register support for ERC165 itself here
515         _registerInterface(_INTERFACE_ID_ERC165);
516     }
517 
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      *
521      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
522      */
523     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
524         return _supportedInterfaces[interfaceId];
525     }
526 
527     /**
528      * @dev Registers the contract as an implementer of the interface defined by
529      * `interfaceId`. Support of the actual ERC165 interface is automatic and
530      * registering its interface id is not required.
531      *
532      * See {IERC165-supportsInterface}.
533      *
534      * Requirements:
535      *
536      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
537      */
538     function _registerInterface(bytes4 interfaceId) internal {
539         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
540         _supportedInterfaces[interfaceId] = true;
541     }
542 }
543 
544 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
545 
546 pragma solidity ^0.5.0;
547 
548 
549 
550 
551 
552 
553 
554 
555 /**
556  * @title ERC721 Non-Fungible Token Standard basic implementation
557  * @dev see https://eips.ethereum.org/EIPS/eip-721
558  */
559 contract ERC721 is Context, ERC165, IERC721 {
560     using SafeMath for uint256;
561     using Address for address;
562     using Counters for Counters.Counter;
563 
564     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
565     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
566     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
567 
568     // Mapping from token ID to owner
569     mapping (uint256 => address) private _tokenOwner;
570 
571     // Mapping from token ID to approved address
572     mapping (uint256 => address) private _tokenApprovals;
573 
574     // Mapping from owner to number of owned token
575     mapping (address => Counters.Counter) private _ownedTokensCount;
576 
577     // Mapping from owner to operator approvals
578     mapping (address => mapping (address => bool)) private _operatorApprovals;
579 
580     /*
581      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
582      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
583      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
584      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
585      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
586      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
587      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
588      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
589      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
590      *
591      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
592      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
593      */
594     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
595 
596     constructor () public {
597         // register the supported interfaces to conform to ERC721 via ERC165
598         _registerInterface(_INTERFACE_ID_ERC721);
599     }
600 
601     /**
602      * @dev Gets the balance of the specified address.
603      * @param owner address to query the balance of
604      * @return uint256 representing the amount owned by the passed address
605      */
606     function balanceOf(address owner) public view returns (uint256) {
607         require(owner != address(0), "ERC721: balance query for the zero address");
608 
609         return _ownedTokensCount[owner].current();
610     }
611 
612     /**
613      * @dev Gets the owner of the specified token ID.
614      * @param tokenId uint256 ID of the token to query the owner of
615      * @return address currently marked as the owner of the given token ID
616      */
617     function ownerOf(uint256 tokenId) public view returns (address) {
618         address owner = _tokenOwner[tokenId];
619         require(owner != address(0), "ERC721: owner query for nonexistent token");
620 
621         return owner;
622     }
623 
624     /**
625      * @dev Approves another address to transfer the given token ID
626      * The zero address indicates there is no approved address.
627      * There can only be one approved address per token at a given time.
628      * Can only be called by the token owner or an approved operator.
629      * @param to address to be approved for the given token ID
630      * @param tokenId uint256 ID of the token to be approved
631      */
632     function approve(address to, uint256 tokenId) public {
633         address owner = ownerOf(tokenId);
634         require(to != owner, "ERC721: approval to current owner");
635 
636         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
637             "ERC721: approve caller is not owner nor approved for all"
638         );
639 
640         _tokenApprovals[tokenId] = to;
641         emit Approval(owner, to, tokenId);
642     }
643 
644     /**
645      * @dev Gets the approved address for a token ID, or zero if no address set
646      * Reverts if the token ID does not exist.
647      * @param tokenId uint256 ID of the token to query the approval of
648      * @return address currently approved for the given token ID
649      */
650     function getApproved(uint256 tokenId) public view returns (address) {
651         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
652 
653         return _tokenApprovals[tokenId];
654     }
655 
656     /**
657      * @dev Sets or unsets the approval of a given operator
658      * An operator is allowed to transfer all tokens of the sender on their behalf.
659      * @param to operator address to set the approval
660      * @param approved representing the status of the approval to be set
661      */
662     function setApprovalForAll(address to, bool approved) public {
663         require(to != _msgSender(), "ERC721: approve to caller");
664 
665         _operatorApprovals[_msgSender()][to] = approved;
666         emit ApprovalForAll(_msgSender(), to, approved);
667     }
668 
669     /**
670      * @dev Tells whether an operator is approved by a given owner.
671      * @param owner owner address which you want to query the approval of
672      * @param operator operator address which you want to query the approval of
673      * @return bool whether the given operator is approved by the given owner
674      */
675     function isApprovedForAll(address owner, address operator) public view returns (bool) {
676         return _operatorApprovals[owner][operator];
677     }
678 
679     /**
680      * @dev Transfers the ownership of a given token ID to another address.
681      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
682      * Requires the msg.sender to be the owner, approved, or operator.
683      * @param from current owner of the token
684      * @param to address to receive the ownership of the given token ID
685      * @param tokenId uint256 ID of the token to be transferred
686      */
687     function transferFrom(address from, address to, uint256 tokenId) public {
688         //solhint-disable-next-line max-line-length
689         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
690 
691         _transferFrom(from, to, tokenId);
692     }
693 
694     /**
695      * @dev Safely transfers the ownership of a given token ID to another address
696      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
697      * which is called upon a safe transfer, and return the magic value
698      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
699      * the transfer is reverted.
700      * Requires the msg.sender to be the owner, approved, or operator
701      * @param from current owner of the token
702      * @param to address to receive the ownership of the given token ID
703      * @param tokenId uint256 ID of the token to be transferred
704      */
705     function safeTransferFrom(address from, address to, uint256 tokenId) public {
706         safeTransferFrom(from, to, tokenId, "");
707     }
708 
709     /**
710      * @dev Safely transfers the ownership of a given token ID to another address
711      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
712      * which is called upon a safe transfer, and return the magic value
713      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
714      * the transfer is reverted.
715      * Requires the _msgSender() to be the owner, approved, or operator
716      * @param from current owner of the token
717      * @param to address to receive the ownership of the given token ID
718      * @param tokenId uint256 ID of the token to be transferred
719      * @param _data bytes data to send along with a safe transfer check
720      */
721     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
722         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
723         _safeTransferFrom(from, to, tokenId, _data);
724     }
725 
726     /**
727      * @dev Safely transfers the ownership of a given token ID to another address
728      * If the target address is a contract, it must implement `onERC721Received`,
729      * which is called upon a safe transfer, and return the magic value
730      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
731      * the transfer is reverted.
732      * Requires the msg.sender to be the owner, approved, or operator
733      * @param from current owner of the token
734      * @param to address to receive the ownership of the given token ID
735      * @param tokenId uint256 ID of the token to be transferred
736      * @param _data bytes data to send along with a safe transfer check
737      */
738     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
739         _transferFrom(from, to, tokenId);
740         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
741     }
742 
743     /**
744      * @dev Returns whether the specified token exists.
745      * @param tokenId uint256 ID of the token to query the existence of
746      * @return bool whether the token exists
747      */
748     function _exists(uint256 tokenId) internal view returns (bool) {
749         address owner = _tokenOwner[tokenId];
750         return owner != address(0);
751     }
752 
753     /**
754      * @dev Returns whether the given spender can transfer a given token ID.
755      * @param spender address of the spender to query
756      * @param tokenId uint256 ID of the token to be transferred
757      * @return bool whether the msg.sender is approved for the given token ID,
758      * is an operator of the owner, or is the owner of the token
759      */
760     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
761         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
762         address owner = ownerOf(tokenId);
763         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
764     }
765 
766     /**
767      * @dev Internal function to safely mint a new token.
768      * Reverts if the given token ID already exists.
769      * If the target address is a contract, it must implement `onERC721Received`,
770      * which is called upon a safe transfer, and return the magic value
771      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
772      * the transfer is reverted.
773      * @param to The address that will own the minted token
774      * @param tokenId uint256 ID of the token to be minted
775      */
776     function _safeMint(address to, uint256 tokenId) internal {
777         _safeMint(to, tokenId, "");
778     }
779 
780     /**
781      * @dev Internal function to safely mint a new token.
782      * Reverts if the given token ID already exists.
783      * If the target address is a contract, it must implement `onERC721Received`,
784      * which is called upon a safe transfer, and return the magic value
785      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
786      * the transfer is reverted.
787      * @param to The address that will own the minted token
788      * @param tokenId uint256 ID of the token to be minted
789      * @param _data bytes data to send along with a safe transfer check
790      */
791     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
792         _mint(to, tokenId);
793         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
794     }
795 
796     /**
797      * @dev Internal function to mint a new token.
798      * Reverts if the given token ID already exists.
799      * @param to The address that will own the minted token
800      * @param tokenId uint256 ID of the token to be minted
801      */
802     function _mint(address to, uint256 tokenId) internal {
803         require(to != address(0), "ERC721: mint to the zero address");
804         require(!_exists(tokenId), "ERC721: token already minted");
805 
806         _tokenOwner[tokenId] = to;
807         _ownedTokensCount[to].increment();
808 
809         emit Transfer(address(0), to, tokenId);
810     }
811 
812     /**
813      * @dev Internal function to burn a specific token.
814      * Reverts if the token does not exist.
815      * Deprecated, use {_burn} instead.
816      * @param owner owner of the token to burn
817      * @param tokenId uint256 ID of the token being burned
818      */
819     function _burn(address owner, uint256 tokenId) internal {
820         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
821 
822         _clearApproval(tokenId);
823 
824         _ownedTokensCount[owner].decrement();
825         _tokenOwner[tokenId] = address(0);
826 
827         emit Transfer(owner, address(0), tokenId);
828     }
829 
830     /**
831      * @dev Internal function to burn a specific token.
832      * Reverts if the token does not exist.
833      * @param tokenId uint256 ID of the token being burned
834      */
835     function _burn(uint256 tokenId) internal {
836         _burn(ownerOf(tokenId), tokenId);
837     }
838 
839     /**
840      * @dev Internal function to transfer ownership of a given token ID to another address.
841      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
842      * @param from current owner of the token
843      * @param to address to receive the ownership of the given token ID
844      * @param tokenId uint256 ID of the token to be transferred
845      */
846     function _transferFrom(address from, address to, uint256 tokenId) internal {
847         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
848         require(to != address(0), "ERC721: transfer to the zero address");
849 
850         _clearApproval(tokenId);
851 
852         _ownedTokensCount[from].decrement();
853         _ownedTokensCount[to].increment();
854 
855         _tokenOwner[tokenId] = to;
856 
857         emit Transfer(from, to, tokenId);
858     }
859 
860     /**
861      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
862      * The call is not executed if the target address is not a contract.
863      *
864      * This is an internal detail of the `ERC721` contract and its use is deprecated.
865      * @param from address representing the previous owner of the given token ID
866      * @param to target address that will receive the tokens
867      * @param tokenId uint256 ID of the token to be transferred
868      * @param _data bytes optional data to send along with the call
869      * @return bool whether the call correctly returned the expected magic value
870      */
871     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
872         internal returns (bool)
873     {
874         if (!to.isContract()) {
875             return true;
876         }
877         // solhint-disable-next-line avoid-low-level-calls
878         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
879             IERC721Receiver(to).onERC721Received.selector,
880             _msgSender(),
881             from,
882             tokenId,
883             _data
884         ));
885         if (!success) {
886             if (returndata.length > 0) {
887                 // solhint-disable-next-line no-inline-assembly
888                 assembly {
889                     let returndata_size := mload(returndata)
890                     revert(add(32, returndata), returndata_size)
891                 }
892             } else {
893                 revert("ERC721: transfer to non ERC721Receiver implementer");
894             }
895         } else {
896             bytes4 retval = abi.decode(returndata, (bytes4));
897             return (retval == _ERC721_RECEIVED);
898         }
899     }
900 
901     /**
902      * @dev Private function to clear current approval of a given token ID.
903      * @param tokenId uint256 ID of the token to be transferred
904      */
905     function _clearApproval(uint256 tokenId) private {
906         if (_tokenApprovals[tokenId] != address(0)) {
907             _tokenApprovals[tokenId] = address(0);
908         }
909     }
910 }
911 
912 // File: contracts/LAND/ILANDRegistry.sol
913 
914 // solium-disable linebreak-style
915 pragma solidity ^0.5.0;
916 
917 interface ILANDRegistry {
918 
919   // LAND can be assigned by the owner
920   function assignNewParcel(int x, int y, address beneficiary) external;
921   function assignMultipleParcels(int[] calldata x, int[] calldata y, address beneficiary) external;
922 
923   // After one year, LAND can be claimed from an inactive public key
924   function ping() external;
925 
926   // LAND-centric getters
927   function encodeTokenId(int x, int y) external pure returns (uint256);
928   function decodeTokenId(uint value) external pure returns (int, int);
929   function exists(int x, int y) external view returns (bool);
930   function ownerOfLand(int x, int y) external view returns (address);
931   function ownerOfLandMany(int[] calldata x, int[] calldata y) external view returns (address[] memory);
932   function landOf(address owner) external view returns (int[] memory, int[] memory);
933   function landData(int x, int y) external view returns (string memory);
934 
935   // Transfer LAND
936   function transferLand(int x, int y, address to) external;
937   function transferManyLand(int[] calldata x, int[] calldata y, address to) external;
938 
939   // Update LAND
940   function updateLandData(int x, int y, string calldata data) external;
941   function updateManyLandData(int[] calldata x, int[] calldata y, string calldata data) external;
942 
943   //operators
944   function setUpdateOperator(uint256 assetId, address operator) external;
945 
946   // Events
947 
948   event Update(
949     uint256 indexed assetId,
950     address indexed holder,
951     address indexed operator,
952     string data
953   );
954 
955   event UpdateOperator(
956     uint256 indexed assetId,
957     address indexed operator
958   );
959 
960   event DeployAuthorized(
961     address indexed _caller,
962     address indexed _deployer
963   );
964 
965   event DeployForbidden(
966     address indexed _caller,
967     address indexed _deployer
968   );
969 }
970 
971 // File: contracts/LAND/IEstateRegistry.sol
972 
973 pragma solidity ^0.5.0;
974 
975 
976 contract IEstateRegistry {
977   function mint(address to, string calldata metadata) external returns (uint256);
978   function ownerOf(uint256 _tokenId) public view returns (address _owner); // from ERC721
979   function setManyLandUpdateOperator(uint256 _estateId, uint256[] memory _landIds, address _operator) public;
980   function setLandUpdateOperator(uint256 _estateId, uint256 _landId, address _operator) public;
981   // Events
982   event CreateEstate(
983     address indexed _owner,
984     uint256 indexed _estateId,
985     string _data
986   );
987 
988   event AddLand(
989     uint256 indexed _estateId,
990     uint256 indexed _landId
991   );
992 
993   event RemoveLand(
994     uint256 indexed _estateId,
995     uint256 indexed _landId,
996     address indexed _destinatary
997   );
998 
999   event Update(
1000     uint256 indexed _assetId,
1001     address indexed _holder,
1002     address indexed _operator,
1003     string _data
1004   );
1005 
1006   event UpdateOperator(
1007     uint256 indexed _estateId,
1008     address indexed _operator
1009   );
1010 
1011   event UpdateManager(
1012     address indexed _owner,
1013     address indexed _operator,
1014     address indexed _caller,
1015     bool _approved
1016   );
1017 
1018   event SetLANDRegistry(
1019     address indexed _registry
1020   );
1021 }
1022 
1023 // File: contracts/AetherianLand.sol
1024 
1025 pragma solidity ^0.5.5;
1026 
1027 
1028 
1029 
1030 
1031 contract AetherianLand is Ownable, ERC721 {
1032     ILANDRegistry private landContract;
1033     IEstateRegistry private estateContract;
1034     mapping(uint256 => bool) private isClaimed;
1035     uint256 private estateId;
1036     address private delegatedSigner;
1037 
1038     mapping(uint => bool) private nonceUsed; //mark used nonce's
1039 
1040     constructor (address landContractAddress, address estateContractAddress, uint256 _estateId) public {
1041         landContract = ILANDRegistry(landContractAddress);
1042         estateContract = IEstateRegistry(estateContractAddress);
1043         estateId = _estateId;
1044         delegatedSigner = owner();
1045     }
1046 
1047     function _isNotClaimed(uint256[] memory plotIds) private view returns (bool) {
1048         for(uint i = 0; i < plotIds.length; i++) {
1049             if(isClaimed[plotIds[i]]) {
1050                 return false;
1051             }
1052         }
1053         return true;
1054     }
1055 
1056     function _setUpdateOperator(address newOperator, uint256 plotId) internal {
1057         estateContract.setLandUpdateOperator(estateId, plotId, newOperator);
1058     }
1059 
1060     function _setManyUpdateOperator(address newOperator, uint256[] memory plotIds) internal {
1061         estateContract.setManyLandUpdateOperator(estateId, plotIds, newOperator);
1062     }
1063 
1064     function setDelegatedSigner(address newDelegate) external onlyOwner {
1065         delegatedSigner = newDelegate;
1066         emit DelegateChanged(delegatedSigner);
1067     }
1068 
1069     function getDelegatedSigner() public view returns (address) {
1070         return delegatedSigner;
1071     }
1072 
1073     function getMessageHash(address userAddress, uint256[] memory plotIds, uint nonce) public pure returns (bytes32)
1074     {
1075         return keccak256(abi.encode(userAddress, plotIds, nonce));
1076     }
1077 
1078     function buildPrefixedHash(bytes32 msgHash) public pure returns (bytes32)
1079     {
1080         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1081         return keccak256(abi.encodePacked(prefix, msgHash));
1082     }
1083 
1084     function verifySender(bytes32 msgHash, uint8 _v, bytes32 _r, bytes32 _s) private view returns (bool)
1085     {
1086         bytes32 prefixedHash = buildPrefixedHash(msgHash);
1087         return ecrecover(prefixedHash, _v, _r, _s) == delegatedSigner;
1088     }
1089 
1090     function setUpdateOperator(address newOperator, uint256 plotId) external {
1091         require(ownerOf(plotId) == msg.sender, "Not land owner");
1092        _setUpdateOperator(newOperator, plotId);
1093     }
1094 
1095     function setManyUpdateOperator(address newOperator, uint256[] calldata plotIds) external {
1096         for (uint i = 0; i < plotIds.length; i++)
1097         {
1098             this.setUpdateOperator(newOperator, plotIds[i]);
1099         }
1100     }
1101 
1102     function claimLandTokens(address userAddress, uint256[] calldata plotIds, uint nonce, uint8 _v, bytes32 _r, bytes32 _s) external {
1103         bytes32 msgHash = getMessageHash(userAddress, plotIds, nonce);
1104         require(verifySender(msgHash, _v, _r, _s), "Invalid Sig");
1105         require(_isNotClaimed(plotIds), "A plot is already claimed");
1106         require(nonceUsed[nonce] == false, "Nonce already been used");
1107 
1108         for (uint i = 0; i<plotIds.length; i++) {
1109             _mint(userAddress, plotIds[i]);
1110             isClaimed[plotIds[i]] = true;
1111         }
1112 
1113         _setManyUpdateOperator(userAddress, plotIds);
1114 
1115         nonceUsed[nonce] = true;
1116     }
1117 
1118     function deleteTokens(uint256[] calldata plotIds) onlyOwner external { //used in the event the delegate is compremised and starts minting spoofed DEEDs
1119         for (uint i = 0; i < plotIds.length; i++) {
1120             _burn(plotIds[i]);
1121             isClaimed[plotIds[i]] = false;
1122         }
1123         _setManyUpdateOperator(address(0x0), plotIds);
1124     }
1125 
1126   function _transferFrom (
1127       address from,
1128       address to,
1129       uint256 tokenId
1130     ) internal {
1131     super._transferFrom (
1132       from,
1133       to,
1134       tokenId
1135     );
1136 
1137     _setUpdateOperator(to, tokenId); //new owner is default operator
1138   }
1139 
1140     event DelegateChanged(
1141         address newDelegatedAddress
1142     );
1143 }