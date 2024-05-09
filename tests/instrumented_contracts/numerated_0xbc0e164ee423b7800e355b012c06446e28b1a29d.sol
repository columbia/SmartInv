1 // File: @openzeppelin/contracts/GSN/Context.sol
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
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
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
110 // File: @openzeppelin/contracts/introspection/IERC165.sol
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
135 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
190 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
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
218 // File: @openzeppelin/contracts/math/SafeMath.sol
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
377 // File: @openzeppelin/contracts/utils/Address.sol
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
450 // File: @openzeppelin/contracts/drafts/Counters.sol
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
490 // File: @openzeppelin/contracts/introspection/ERC165.sol
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
544 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
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
912 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
913 
914 pragma solidity ^0.5.0;
915 
916 
917 /**
918  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
919  * @dev See https://eips.ethereum.org/EIPS/eip-721
920  */
921 contract IERC721Enumerable is IERC721 {
922     function totalSupply() public view returns (uint256);
923     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
924 
925     function tokenByIndex(uint256 index) public view returns (uint256);
926 }
927 
928 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
929 
930 pragma solidity ^0.5.0;
931 
932 
933 
934 
935 
936 /**
937  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
938  * @dev See https://eips.ethereum.org/EIPS/eip-721
939  */
940 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
941     // Mapping from owner to list of owned token IDs
942     mapping(address => uint256[]) private _ownedTokens;
943 
944     // Mapping from token ID to index of the owner tokens list
945     mapping(uint256 => uint256) private _ownedTokensIndex;
946 
947     // Array with all token ids, used for enumeration
948     uint256[] private _allTokens;
949 
950     // Mapping from token id to position in the allTokens array
951     mapping(uint256 => uint256) private _allTokensIndex;
952 
953     /*
954      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
955      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
956      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
957      *
958      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
959      */
960     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
961 
962     /**
963      * @dev Constructor function.
964      */
965     constructor () public {
966         // register the supported interface to conform to ERC721Enumerable via ERC165
967         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
968     }
969 
970     /**
971      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
972      * @param owner address owning the tokens list to be accessed
973      * @param index uint256 representing the index to be accessed of the requested tokens list
974      * @return uint256 token ID at the given index of the tokens list owned by the requested address
975      */
976     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
977         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
978         return _ownedTokens[owner][index];
979     }
980 
981     /**
982      * @dev Gets the total amount of tokens stored by the contract.
983      * @return uint256 representing the total amount of tokens
984      */
985     function totalSupply() public view returns (uint256) {
986         return _allTokens.length;
987     }
988 
989     /**
990      * @dev Gets the token ID at a given index of all the tokens in this contract
991      * Reverts if the index is greater or equal to the total number of tokens.
992      * @param index uint256 representing the index to be accessed of the tokens list
993      * @return uint256 token ID at the given index of the tokens list
994      */
995     function tokenByIndex(uint256 index) public view returns (uint256) {
996         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
997         return _allTokens[index];
998     }
999 
1000     /**
1001      * @dev Internal function to transfer ownership of a given token ID to another address.
1002      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1003      * @param from current owner of the token
1004      * @param to address to receive the ownership of the given token ID
1005      * @param tokenId uint256 ID of the token to be transferred
1006      */
1007     function _transferFrom(address from, address to, uint256 tokenId) internal {
1008         super._transferFrom(from, to, tokenId);
1009 
1010         _removeTokenFromOwnerEnumeration(from, tokenId);
1011 
1012         _addTokenToOwnerEnumeration(to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Internal function to mint a new token.
1017      * Reverts if the given token ID already exists.
1018      * @param to address the beneficiary that will own the minted token
1019      * @param tokenId uint256 ID of the token to be minted
1020      */
1021     function _mint(address to, uint256 tokenId) internal {
1022         super._mint(to, tokenId);
1023 
1024         _addTokenToOwnerEnumeration(to, tokenId);
1025 
1026         _addTokenToAllTokensEnumeration(tokenId);
1027     }
1028 
1029     /**
1030      * @dev Internal function to burn a specific token.
1031      * Reverts if the token does not exist.
1032      * Deprecated, use {ERC721-_burn} instead.
1033      * @param owner owner of the token to burn
1034      * @param tokenId uint256 ID of the token being burned
1035      */
1036     function _burn(address owner, uint256 tokenId) internal {
1037         super._burn(owner, tokenId);
1038 
1039         _removeTokenFromOwnerEnumeration(owner, tokenId);
1040         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1041         _ownedTokensIndex[tokenId] = 0;
1042 
1043         _removeTokenFromAllTokensEnumeration(tokenId);
1044     }
1045 
1046     /**
1047      * @dev Gets the list of token IDs of the requested owner.
1048      * @param owner address owning the tokens
1049      * @return uint256[] List of token IDs owned by the requested address
1050      */
1051     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1052         return _ownedTokens[owner];
1053     }
1054 
1055     /**
1056      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1057      * @param to address representing the new owner of the given token ID
1058      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1059      */
1060     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1061         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1062         _ownedTokens[to].push(tokenId);
1063     }
1064 
1065     /**
1066      * @dev Private function to add a token to this extension's token tracking data structures.
1067      * @param tokenId uint256 ID of the token to be added to the tokens list
1068      */
1069     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1070         _allTokensIndex[tokenId] = _allTokens.length;
1071         _allTokens.push(tokenId);
1072     }
1073 
1074     /**
1075      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1076      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1077      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1078      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1079      * @param from address representing the previous owner of the given token ID
1080      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1081      */
1082     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1083         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1084         // then delete the last slot (swap and pop).
1085 
1086         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1087         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1088 
1089         // When the token to delete is the last token, the swap operation is unnecessary
1090         if (tokenIndex != lastTokenIndex) {
1091             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1092 
1093             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1094             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1095         }
1096 
1097         // This also deletes the contents at the last position of the array
1098         _ownedTokens[from].length--;
1099 
1100         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1101         // lastTokenId, or just over the end of the array if the token was the last one).
1102     }
1103 
1104     /**
1105      * @dev Private function to remove a token from this extension's token tracking data structures.
1106      * This has O(1) time complexity, but alters the order of the _allTokens array.
1107      * @param tokenId uint256 ID of the token to be removed from the tokens list
1108      */
1109     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1110         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1111         // then delete the last slot (swap and pop).
1112 
1113         uint256 lastTokenIndex = _allTokens.length.sub(1);
1114         uint256 tokenIndex = _allTokensIndex[tokenId];
1115 
1116         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1117         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1118         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1119         uint256 lastTokenId = _allTokens[lastTokenIndex];
1120 
1121         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123 
1124         // This also deletes the contents at the last position of the array
1125         _allTokens.length--;
1126         _allTokensIndex[tokenId] = 0;
1127     }
1128 }
1129 
1130 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1131 
1132 pragma solidity ^0.5.0;
1133 
1134 
1135 /**
1136  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1137  * @dev See https://eips.ethereum.org/EIPS/eip-721
1138  */
1139 contract IERC721Metadata is IERC721 {
1140     function name() external view returns (string memory);
1141     function symbol() external view returns (string memory);
1142     function tokenURI(uint256 tokenId) external view returns (string memory);
1143 }
1144 
1145 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
1146 
1147 pragma solidity ^0.5.0;
1148 
1149 
1150 
1151 
1152 
1153 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1154     // Token name
1155     string private _name;
1156 
1157     // Token symbol
1158     string private _symbol;
1159 
1160     // Base URI
1161     string private _baseURI;
1162 
1163     // Optional mapping for token URIs
1164     mapping(uint256 => string) private _tokenURIs;
1165 
1166     /*
1167      *     bytes4(keccak256('name()')) == 0x06fdde03
1168      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1169      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1170      *
1171      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1172      */
1173     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1174 
1175     /**
1176      * @dev Constructor function
1177      */
1178     constructor (string memory name, string memory symbol) public {
1179         _name = name;
1180         _symbol = symbol;
1181 
1182         // register the supported interfaces to conform to ERC721 via ERC165
1183         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1184     }
1185 
1186     /**
1187      * @dev Gets the token name.
1188      * @return string representing the token name
1189      */
1190     function name() external view returns (string memory) {
1191         return _name;
1192     }
1193 
1194     /**
1195      * @dev Gets the token symbol.
1196      * @return string representing the token symbol
1197      */
1198     function symbol() external view returns (string memory) {
1199         return _symbol;
1200     }
1201 
1202     /**
1203      * @dev Returns the URI for a given token ID. May return an empty string.
1204      *
1205      * If the token's URI is non-empty and a base URI was set (via
1206      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1207      *
1208      * Reverts if the token ID does not exist.
1209      */
1210     function tokenURI(uint256 tokenId) external view returns (string memory) {
1211         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1212 
1213         string memory _tokenURI = _tokenURIs[tokenId];
1214 
1215         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1216         if (bytes(_tokenURI).length == 0) {
1217             return "";
1218         } else {
1219             // abi.encodePacked is being used to concatenate strings
1220             return string(abi.encodePacked(_baseURI, _tokenURI));
1221         }
1222     }
1223 
1224     /**
1225      * @dev Internal function to set the token URI for a given token.
1226      *
1227      * Reverts if the token ID does not exist.
1228      *
1229      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1230      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1231      * it and save gas.
1232      */
1233     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1234         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1235         _tokenURIs[tokenId] = _tokenURI;
1236     }
1237 
1238     /**
1239      * @dev Internal function to set the base URI for all token IDs. It is
1240      * automatically added as a prefix to the value returned in {tokenURI}.
1241      *
1242      * _Available since v2.5.0._
1243      */
1244     function _setBaseURI(string memory baseURI) internal {
1245         _baseURI = baseURI;
1246     }
1247 
1248     /**
1249     * @dev Returns the base URI set via {_setBaseURI}. This will be
1250     * automatically added as a preffix in {tokenURI} to each token's URI, when
1251     * they are non-empty.
1252     *
1253     * _Available since v2.5.0._
1254     */
1255     function baseURI() external view returns (string memory) {
1256         return _baseURI;
1257     }
1258 
1259     /**
1260      * @dev Internal function to burn a specific token.
1261      * Reverts if the token does not exist.
1262      * Deprecated, use _burn(uint256) instead.
1263      * @param owner owner of the token to burn
1264      * @param tokenId uint256 ID of the token being burned by the msg.sender
1265      */
1266     function _burn(address owner, uint256 tokenId) internal {
1267         super._burn(owner, tokenId);
1268 
1269         // Clear metadata (if any)
1270         if (bytes(_tokenURIs[tokenId]).length != 0) {
1271             delete _tokenURIs[tokenId];
1272         }
1273     }
1274 }
1275 
1276 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1277 
1278 pragma solidity ^0.5.0;
1279 
1280 
1281 
1282 
1283 /**
1284  * @title Full ERC721 Token
1285  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1286  * Moreover, it includes approve all functionality using operator terminology.
1287  *
1288  * See https://eips.ethereum.org/EIPS/eip-721
1289  */
1290 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1291     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1292         // solhint-disable-previous-line no-empty-blocks
1293     }
1294 }
1295 
1296 // File: contracts/Strings.sol
1297 
1298 pragma solidity ^0.5.0;
1299 
1300 library Strings {
1301   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1302   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
1303       bytes memory _ba = bytes(_a);
1304       bytes memory _bb = bytes(_b);
1305       bytes memory _bc = bytes(_c);
1306       bytes memory _bd = bytes(_d);
1307       bytes memory _be = bytes(_e);
1308       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1309       bytes memory babcde = bytes(abcde);
1310       uint k = 0;
1311       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1312       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1313       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1314       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1315       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1316       return string(babcde);
1317     }
1318 
1319     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
1320         return strConcat(_a, _b, _c, _d, "");
1321     }
1322 
1323     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1324         return strConcat(_a, _b, _c, "", "");
1325     }
1326 
1327     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1328         return strConcat(_a, _b, "", "", "");
1329     }
1330 
1331     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1332         if (_i == 0) {
1333             return "0";
1334         }
1335         uint j = _i;
1336         uint len;
1337         while (j != 0) {
1338             len++;
1339             j /= 10;
1340         }
1341         bytes memory bstr = new bytes(len);
1342         uint k = len - 1;
1343         while (_i != 0) {
1344             bstr[k--] = byte(uint8(48 + _i % 10));
1345             _i /= 10;
1346         }
1347         return string(bstr);
1348     }
1349 }
1350 
1351 // File: contracts/PixelChainCore.sol
1352 
1353 pragma solidity ^0.5.0;
1354 
1355 
1356 
1357 
1358 contract PixelChainCore is Ownable, ERC721Full {
1359     event PixelChainCreated(uint id, address author, string name, bytes data, bytes palette);
1360 
1361     string public name = "PixelChain";
1362     string public symbol = "PXC";
1363     string baseTokenUri = "";
1364     uint256 mintPrice = 0;
1365 
1366     struct PixelChain {
1367         string name;
1368         bytes data;
1369         bytes palette;
1370         address author;
1371         uint256 date;
1372     }
1373 
1374     PixelChain[] public pixelChains;
1375 
1376     constructor() ERC721Full(name, symbol) public { }
1377 
1378     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1379         return Strings.strConcat(
1380             baseTokenURI(),
1381             Strings.uint2str(_tokenId)
1382         );
1383     }
1384 
1385     // Management methods
1386     function create(string memory _name, bytes memory _data, bytes memory _palette) public payable returns (uint) {
1387         require(msg.value >= mintPrice, "Not enough ether to mint this token!");
1388         require(_data.length == 1024, "The byte array length should be of 1024.");
1389         require(_palette.length == 48, "The palette array length should be of 48.");
1390 
1391         if (msg.value > mintPrice) {
1392             msg.sender.transfer(msg.value - mintPrice);
1393         }
1394 
1395         uint id = pixelChains.push(PixelChain(_name, _data, _palette, msg.sender, block.timestamp)) - 1;
1396         _mint(msg.sender, id);
1397         emit PixelChainCreated(id, msg.sender, _name, _data, _palette);
1398         return id;
1399     }
1400 
1401     function retrieve(uint256 _id) public view  returns (string memory, bytes memory, bytes memory, address, uint256) {
1402         return (pixelChains[_id].name, pixelChains[_id].data, pixelChains[_id].palette, pixelChains[_id].author, pixelChains[_id].date);
1403     }
1404 
1405     function setBaseTokenURI(string memory _uri) public onlyOwner {
1406         baseTokenUri = _uri;
1407     }
1408 
1409     function withdraw() external onlyOwner {
1410         msg.sender.transfer(address(this).balance);
1411     }
1412 
1413     function setMintPrice(uint256 _price) external onlyOwner {
1414         mintPrice = _price;
1415     }
1416 
1417     function baseTokenURI() public view returns (string memory) {
1418         return baseTokenUri;
1419     }
1420 
1421 }