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
53         _owner = _msgSender();
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return _msgSender() == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/introspection/IERC165.sol
110 
111 pragma solidity ^0.5.0;
112 
113 /**
114  * @dev Interface of the ERC165 standard, as defined in the
115  * https://eips.ethereum.org/EIPS/eip-165[EIP].
116  *
117  * Implementers can declare support of contract interfaces, which can then be
118  * queried by others ({ERC165Checker}).
119  *
120  * For an implementation, see {ERC165}.
121  */
122 interface IERC165 {
123     /**
124      * @dev Returns true if this contract implements the interface defined by
125      * `interfaceId`. See the corresponding
126      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
127      * to learn more about how these ids are created.
128      *
129      * This function call must use less than 30 000 gas.
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool);
132 }
133 
134 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
135 
136 pragma solidity ^0.5.0;
137 
138 
139 /**
140  * @dev Required interface of an ERC721 compliant contract.
141  */
142 contract IERC721 is IERC165 {
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of NFTs in `owner`'s account.
149      */
150     function balanceOf(address owner) public view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the NFT specified by `tokenId`.
154      */
155     function ownerOf(uint256 tokenId) public view returns (address owner);
156 
157     /**
158      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
159      * another (`to`).
160      *
161      *
162      *
163      * Requirements:
164      * - `from`, `to` cannot be zero.
165      * - `tokenId` must be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move this
167      * NFT by either {approve} or {setApprovalForAll}.
168      */
169     function safeTransferFrom(address from, address to, uint256 tokenId) public;
170     /**
171      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
172      * another (`to`).
173      *
174      * Requirements:
175      * - If the caller is not `from`, it must be approved to move this NFT by
176      * either {approve} or {setApprovalForAll}.
177      */
178     function transferFrom(address from, address to, uint256 tokenId) public;
179     function approve(address to, uint256 tokenId) public;
180     function getApproved(uint256 tokenId) public view returns (address operator);
181 
182     function setApprovalForAll(address operator, bool _approved) public;
183     function isApprovedForAll(address owner, address operator) public view returns (bool);
184 
185 
186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @title ERC721 token receiver interface
195  * @dev Interface for any contract that wants to support safeTransfers
196  * from ERC721 asset contracts.
197  */
198 contract IERC721Receiver {
199     /**
200      * @notice Handle the receipt of an NFT
201      * @dev The ERC721 smart contract calls this function on the recipient
202      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
203      * otherwise the caller will revert the transaction. The selector to be
204      * returned can be obtained as `this.onERC721Received.selector`. This
205      * function MAY throw to revert and reject the transfer.
206      * Note: the ERC721 contract address is always the message sender.
207      * @param operator The address which called `safeTransferFrom` function
208      * @param from The address which previously owned the token
209      * @param tokenId The NFT identifier which is being transferred
210      * @param data Additional data with no specified format
211      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
212      */
213     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
214     public returns (bytes4);
215 }
216 
217 // File: @openzeppelin/contracts/math/SafeMath.sol
218 
219 pragma solidity ^0.5.0;
220 
221 /**
222  * @dev Wrappers over Solidity's arithmetic operations with added overflow
223  * checks.
224  *
225  * Arithmetic operations in Solidity wrap on overflow. This can easily result
226  * in bugs, because programmers usually assume that an overflow raises an
227  * error, which is the standard behavior in high level programming languages.
228  * `SafeMath` restores this intuition by reverting the transaction when an
229  * operation overflows.
230  *
231  * Using this library instead of the unchecked operations eliminates an entire
232  * class of bugs, so it's recommended to use it always.
233  */
234 library SafeMath {
235     /**
236      * @dev Returns the addition of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `+` operator.
240      *
241      * Requirements:
242      * - Addition cannot overflow.
243      */
244     function add(uint256 a, uint256 b) internal pure returns (uint256) {
245         uint256 c = a + b;
246         require(c >= a, "SafeMath: addition overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, reverting on
253      * overflow (when the result is negative).
254      *
255      * Counterpart to Solidity's `-` operator.
256      *
257      * Requirements:
258      * - Subtraction cannot overflow.
259      */
260     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261         return sub(a, b, "SafeMath: subtraction overflow");
262     }
263 
264     /**
265      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
266      * overflow (when the result is negative).
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      * - Subtraction cannot overflow.
272      *
273      * _Available since v2.4.0._
274      */
275     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b <= a, errorMessage);
277         uint256 c = a - b;
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `*` operator.
287      *
288      * Requirements:
289      * - Multiplication cannot overflow.
290      */
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
293         // benefit is lost if 'b' is also tested.
294         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
295         if (a == 0) {
296             return 0;
297         }
298 
299         uint256 c = a * b;
300         require(c / a == b, "SafeMath: multiplication overflow");
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the integer division of two unsigned integers. Reverts on
307      * division by zero. The result is rounded towards zero.
308      *
309      * Counterpart to Solidity's `/` operator. Note: this function uses a
310      * `revert` opcode (which leaves remaining gas untouched) while Solidity
311      * uses an invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         return div(a, b, "SafeMath: division by zero");
318     }
319 
320     /**
321      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
322      * division by zero. The result is rounded towards zero.
323      *
324      * Counterpart to Solidity's `/` operator. Note: this function uses a
325      * `revert` opcode (which leaves remaining gas untouched) while Solidity
326      * uses an invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      * - The divisor cannot be zero.
330      *
331      * _Available since v2.4.0._
332      */
333     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         // Solidity only automatically asserts when dividing by 0
335         require(b > 0, errorMessage);
336         uint256 c = a / b;
337         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
338 
339         return c;
340     }
341 
342     /**
343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
344      * Reverts when dividing by zero.
345      *
346      * Counterpart to Solidity's `%` operator. This function uses a `revert`
347      * opcode (which leaves remaining gas untouched) while Solidity uses an
348      * invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      * - The divisor cannot be zero.
352      */
353     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
354         return mod(a, b, "SafeMath: modulo by zero");
355     }
356 
357     /**
358      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
359      * Reverts with custom message when dividing by zero.
360      *
361      * Counterpart to Solidity's `%` operator. This function uses a `revert`
362      * opcode (which leaves remaining gas untouched) while Solidity uses an
363      * invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      * - The divisor cannot be zero.
367      *
368      * _Available since v2.4.0._
369      */
370     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
371         require(b != 0, errorMessage);
372         return a % b;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/utils/Address.sol
377 
378 pragma solidity ^0.5.5;
379 
380 /**
381  * @dev Collection of functions related to the address type
382  */
383 library Address {
384     /**
385      * @dev Returns true if `account` is a contract.
386      *
387      * This test is non-exhaustive, and there may be false-negatives: during the
388      * execution of a contract's constructor, its address will be reported as
389      * not containing a contract.
390      *
391      * IMPORTANT: It is unsafe to assume that an address for which this
392      * function returns false is an externally-owned account (EOA) and not a
393      * contract.
394      */
395     function isContract(address account) internal view returns (bool) {
396         // This method relies in extcodesize, which returns 0 for contracts in
397         // construction, since the code is only stored at the end of the
398         // constructor execution.
399 
400         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
401         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
402         // for accounts without code, i.e. `keccak256('')`
403         bytes32 codehash;
404         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
405         // solhint-disable-next-line no-inline-assembly
406         assembly { codehash := extcodehash(account) }
407         return (codehash != 0x0 && codehash != accountHash);
408     }
409 
410     /**
411      * @dev Converts an `address` into `address payable`. Note that this is
412      * simply a type cast: the actual underlying value is not changed.
413      *
414      * _Available since v2.4.0._
415      */
416     function toPayable(address account) internal pure returns (address payable) {
417         return address(uint160(account));
418     }
419 
420     /**
421      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
422      * `recipient`, forwarding all available gas and reverting on errors.
423      *
424      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
425      * of certain opcodes, possibly making contracts go over the 2300 gas limit
426      * imposed by `transfer`, making them unable to receive funds via
427      * `transfer`. {sendValue} removes this limitation.
428      *
429      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
430      *
431      * IMPORTANT: because control is transferred to `recipient`, care must be
432      * taken to not create reentrancy vulnerabilities. Consider using
433      * {ReentrancyGuard} or the
434      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
435      *
436      * _Available since v2.4.0._
437      */
438     function sendValue(address payable recipient, uint256 amount) internal {
439         require(address(this).balance >= amount, "Address: insufficient balance");
440 
441         // solhint-disable-next-line avoid-call-value
442         (bool success, ) = recipient.call.value(amount)("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 }
446 
447 // File: @openzeppelin/contracts/drafts/Counters.sol
448 
449 pragma solidity ^0.5.0;
450 
451 
452 /**
453  * @title Counters
454  * @author Matt Condon (@shrugs)
455  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
456  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
457  *
458  * Include with `using Counters for Counters.Counter;`
459  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
460  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
461  * directly accessed.
462  */
463 library Counters {
464     using SafeMath for uint256;
465 
466     struct Counter {
467         // This variable should never be directly accessed by users of the library: interactions must be restricted to
468         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
469         // this feature: see https://github.com/ethereum/solidity/issues/4637
470         uint256 _value; // default: 0
471     }
472 
473     function current(Counter storage counter) internal view returns (uint256) {
474         return counter._value;
475     }
476 
477     function increment(Counter storage counter) internal {
478         counter._value += 1;
479     }
480 
481     function decrement(Counter storage counter) internal {
482         counter._value = counter._value.sub(1);
483     }
484 }
485 
486 // File: @openzeppelin/contracts/introspection/ERC165.sol
487 
488 pragma solidity ^0.5.0;
489 
490 
491 /**
492  * @dev Implementation of the {IERC165} interface.
493  *
494  * Contracts may inherit from this and call {_registerInterface} to declare
495  * their support of an interface.
496  */
497 contract ERC165 is IERC165 {
498     /*
499      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
500      */
501     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
502 
503     /**
504      * @dev Mapping of interface ids to whether or not it's supported.
505      */
506     mapping(bytes4 => bool) private _supportedInterfaces;
507 
508     constructor () internal {
509         // Derived contracts need only register support for their own interfaces,
510         // we register support for ERC165 itself here
511         _registerInterface(_INTERFACE_ID_ERC165);
512     }
513 
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      *
517      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
520         return _supportedInterfaces[interfaceId];
521     }
522 
523     /**
524      * @dev Registers the contract as an implementer of the interface defined by
525      * `interfaceId`. Support of the actual ERC165 interface is automatic and
526      * registering its interface id is not required.
527      *
528      * See {IERC165-supportsInterface}.
529      *
530      * Requirements:
531      *
532      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
533      */
534     function _registerInterface(bytes4 interfaceId) internal {
535         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
536         _supportedInterfaces[interfaceId] = true;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
541 
542 pragma solidity ^0.5.0;
543 
544 
545 
546 
547 
548 
549 
550 
551 /**
552  * @title ERC721 Non-Fungible Token Standard basic implementation
553  * @dev see https://eips.ethereum.org/EIPS/eip-721
554  */
555 contract ERC721 is Context, ERC165, IERC721 {
556     using SafeMath for uint256;
557     using Address for address;
558     using Counters for Counters.Counter;
559 
560     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
561     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
562     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
563 
564     // Mapping from token ID to owner
565     mapping (uint256 => address) private _tokenOwner;
566 
567     // Mapping from token ID to approved address
568     mapping (uint256 => address) private _tokenApprovals;
569 
570     // Mapping from owner to number of owned token
571     mapping (address => Counters.Counter) private _ownedTokensCount;
572 
573     // Mapping from owner to operator approvals
574     mapping (address => mapping (address => bool)) private _operatorApprovals;
575 
576     /*
577      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
578      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
579      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
580      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
581      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
582      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
583      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
584      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
585      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
586      *
587      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
588      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
589      */
590     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
591 
592     constructor () public {
593         // register the supported interfaces to conform to ERC721 via ERC165
594         _registerInterface(_INTERFACE_ID_ERC721);
595     }
596 
597     /**
598      * @dev Gets the balance of the specified address.
599      * @param owner address to query the balance of
600      * @return uint256 representing the amount owned by the passed address
601      */
602     function balanceOf(address owner) public view returns (uint256) {
603         require(owner != address(0), "ERC721: balance query for the zero address");
604 
605         return _ownedTokensCount[owner].current();
606     }
607 
608     /**
609      * @dev Gets the owner of the specified token ID.
610      * @param tokenId uint256 ID of the token to query the owner of
611      * @return address currently marked as the owner of the given token ID
612      */
613     function ownerOf(uint256 tokenId) public view returns (address) {
614         address owner = _tokenOwner[tokenId];
615         require(owner != address(0), "ERC721: owner query for nonexistent token");
616 
617         return owner;
618     }
619 
620     /**
621      * @dev Approves another address to transfer the given token ID
622      * The zero address indicates there is no approved address.
623      * There can only be one approved address per token at a given time.
624      * Can only be called by the token owner or an approved operator.
625      * @param to address to be approved for the given token ID
626      * @param tokenId uint256 ID of the token to be approved
627      */
628     function approve(address to, uint256 tokenId) public {
629         address owner = ownerOf(tokenId);
630         require(to != owner, "ERC721: approval to current owner");
631 
632         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
633             "ERC721: approve caller is not owner nor approved for all"
634         );
635 
636         _tokenApprovals[tokenId] = to;
637         emit Approval(owner, to, tokenId);
638     }
639 
640     /**
641      * @dev Gets the approved address for a token ID, or zero if no address set
642      * Reverts if the token ID does not exist.
643      * @param tokenId uint256 ID of the token to query the approval of
644      * @return address currently approved for the given token ID
645      */
646     function getApproved(uint256 tokenId) public view returns (address) {
647         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
648 
649         return _tokenApprovals[tokenId];
650     }
651 
652     /**
653      * @dev Sets or unsets the approval of a given operator
654      * An operator is allowed to transfer all tokens of the sender on their behalf.
655      * @param to operator address to set the approval
656      * @param approved representing the status of the approval to be set
657      */
658     function setApprovalForAll(address to, bool approved) public {
659         require(to != _msgSender(), "ERC721: approve to caller");
660 
661         _operatorApprovals[_msgSender()][to] = approved;
662         emit ApprovalForAll(_msgSender(), to, approved);
663     }
664 
665     /**
666      * @dev Tells whether an operator is approved by a given owner.
667      * @param owner owner address which you want to query the approval of
668      * @param operator operator address which you want to query the approval of
669      * @return bool whether the given operator is approved by the given owner
670      */
671     function isApprovedForAll(address owner, address operator) public view returns (bool) {
672         return _operatorApprovals[owner][operator];
673     }
674 
675     /**
676      * @dev Transfers the ownership of a given token ID to another address.
677      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
678      * Requires the msg.sender to be the owner, approved, or operator.
679      * @param from current owner of the token
680      * @param to address to receive the ownership of the given token ID
681      * @param tokenId uint256 ID of the token to be transferred
682      */
683     function transferFrom(address from, address to, uint256 tokenId) public {
684         //solhint-disable-next-line max-line-length
685         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
686 
687         _transferFrom(from, to, tokenId);
688     }
689 
690     /**
691      * @dev Safely transfers the ownership of a given token ID to another address
692      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
693      * which is called upon a safe transfer, and return the magic value
694      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
695      * the transfer is reverted.
696      * Requires the msg.sender to be the owner, approved, or operator
697      * @param from current owner of the token
698      * @param to address to receive the ownership of the given token ID
699      * @param tokenId uint256 ID of the token to be transferred
700      */
701     function safeTransferFrom(address from, address to, uint256 tokenId) public {
702         safeTransferFrom(from, to, tokenId, "");
703     }
704 
705     /**
706      * @dev Safely transfers the ownership of a given token ID to another address
707      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
708      * which is called upon a safe transfer, and return the magic value
709      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
710      * the transfer is reverted.
711      * Requires the _msgSender() to be the owner, approved, or operator
712      * @param from current owner of the token
713      * @param to address to receive the ownership of the given token ID
714      * @param tokenId uint256 ID of the token to be transferred
715      * @param _data bytes data to send along with a safe transfer check
716      */
717     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
718         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
719         _safeTransferFrom(from, to, tokenId, _data);
720     }
721 
722     /**
723      * @dev Safely transfers the ownership of a given token ID to another address
724      * If the target address is a contract, it must implement `onERC721Received`,
725      * which is called upon a safe transfer, and return the magic value
726      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
727      * the transfer is reverted.
728      * Requires the msg.sender to be the owner, approved, or operator
729      * @param from current owner of the token
730      * @param to address to receive the ownership of the given token ID
731      * @param tokenId uint256 ID of the token to be transferred
732      * @param _data bytes data to send along with a safe transfer check
733      */
734     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
735         _transferFrom(from, to, tokenId);
736         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
737     }
738 
739     /**
740      * @dev Returns whether the specified token exists.
741      * @param tokenId uint256 ID of the token to query the existence of
742      * @return bool whether the token exists
743      */
744     function _exists(uint256 tokenId) internal view returns (bool) {
745         address owner = _tokenOwner[tokenId];
746         return owner != address(0);
747     }
748 
749     /**
750      * @dev Returns whether the given spender can transfer a given token ID.
751      * @param spender address of the spender to query
752      * @param tokenId uint256 ID of the token to be transferred
753      * @return bool whether the msg.sender is approved for the given token ID,
754      * is an operator of the owner, or is the owner of the token
755      */
756     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
757         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
758         address owner = ownerOf(tokenId);
759         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
760     }
761 
762     /**
763      * @dev Internal function to safely mint a new token.
764      * Reverts if the given token ID already exists.
765      * If the target address is a contract, it must implement `onERC721Received`,
766      * which is called upon a safe transfer, and return the magic value
767      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
768      * the transfer is reverted.
769      * @param to The address that will own the minted token
770      * @param tokenId uint256 ID of the token to be minted
771      */
772     function _safeMint(address to, uint256 tokenId) internal {
773         _safeMint(to, tokenId, "");
774     }
775 
776     /**
777      * @dev Internal function to safely mint a new token.
778      * Reverts if the given token ID already exists.
779      * If the target address is a contract, it must implement `onERC721Received`,
780      * which is called upon a safe transfer, and return the magic value
781      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
782      * the transfer is reverted.
783      * @param to The address that will own the minted token
784      * @param tokenId uint256 ID of the token to be minted
785      * @param _data bytes data to send along with a safe transfer check
786      */
787     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
788         _mint(to, tokenId);
789         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
790     }
791 
792     /**
793      * @dev Internal function to mint a new token.
794      * Reverts if the given token ID already exists.
795      * @param to The address that will own the minted token
796      * @param tokenId uint256 ID of the token to be minted
797      */
798     function _mint(address to, uint256 tokenId) internal {
799         require(to != address(0), "ERC721: mint to the zero address");
800         require(!_exists(tokenId), "ERC721: token already minted");
801 
802         _tokenOwner[tokenId] = to;
803         _ownedTokensCount[to].increment();
804 
805         emit Transfer(address(0), to, tokenId);
806     }
807 
808     /**
809      * @dev Internal function to burn a specific token.
810      * Reverts if the token does not exist.
811      * Deprecated, use {_burn} instead.
812      * @param owner owner of the token to burn
813      * @param tokenId uint256 ID of the token being burned
814      */
815     function _burn(address owner, uint256 tokenId) internal {
816         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
817 
818         _clearApproval(tokenId);
819 
820         _ownedTokensCount[owner].decrement();
821         _tokenOwner[tokenId] = address(0);
822 
823         emit Transfer(owner, address(0), tokenId);
824     }
825 
826     /**
827      * @dev Internal function to burn a specific token.
828      * Reverts if the token does not exist.
829      * @param tokenId uint256 ID of the token being burned
830      */
831     function _burn(uint256 tokenId) internal {
832         _burn(ownerOf(tokenId), tokenId);
833     }
834 
835     /**
836      * @dev Internal function to transfer ownership of a given token ID to another address.
837      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
838      * @param from current owner of the token
839      * @param to address to receive the ownership of the given token ID
840      * @param tokenId uint256 ID of the token to be transferred
841      */
842     function _transferFrom(address from, address to, uint256 tokenId) internal {
843         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
844         require(to != address(0), "ERC721: transfer to the zero address");
845 
846         _clearApproval(tokenId);
847 
848         _ownedTokensCount[from].decrement();
849         _ownedTokensCount[to].increment();
850 
851         _tokenOwner[tokenId] = to;
852 
853         emit Transfer(from, to, tokenId);
854     }
855 
856     /**
857      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
858      * The call is not executed if the target address is not a contract.
859      *
860      * This function is deprecated.
861      * @param from address representing the previous owner of the given token ID
862      * @param to target address that will receive the tokens
863      * @param tokenId uint256 ID of the token to be transferred
864      * @param _data bytes optional data to send along with the call
865      * @return bool whether the call correctly returned the expected magic value
866      */
867     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
868         internal returns (bool)
869     {
870         if (!to.isContract()) {
871             return true;
872         }
873 
874         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
875         return (retval == _ERC721_RECEIVED);
876     }
877 
878     /**
879      * @dev Private function to clear current approval of a given token ID.
880      * @param tokenId uint256 ID of the token to be transferred
881      */
882     function _clearApproval(uint256 tokenId) private {
883         if (_tokenApprovals[tokenId] != address(0)) {
884             _tokenApprovals[tokenId] = address(0);
885         }
886     }
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
890 
891 pragma solidity ^0.5.0;
892 
893 
894 /**
895  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
896  * @dev See https://eips.ethereum.org/EIPS/eip-721
897  */
898 contract IERC721Enumerable is IERC721 {
899     function totalSupply() public view returns (uint256);
900     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
901 
902     function tokenByIndex(uint256 index) public view returns (uint256);
903 }
904 
905 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
906 
907 pragma solidity ^0.5.0;
908 
909 
910 
911 
912 
913 /**
914  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
915  * @dev See https://eips.ethereum.org/EIPS/eip-721
916  */
917 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
918     // Mapping from owner to list of owned token IDs
919     mapping(address => uint256[]) private _ownedTokens;
920 
921     // Mapping from token ID to index of the owner tokens list
922     mapping(uint256 => uint256) private _ownedTokensIndex;
923 
924     // Array with all token ids, used for enumeration
925     uint256[] private _allTokens;
926 
927     // Mapping from token id to position in the allTokens array
928     mapping(uint256 => uint256) private _allTokensIndex;
929 
930     /*
931      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
932      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
933      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
934      *
935      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
936      */
937     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
938 
939     /**
940      * @dev Constructor function.
941      */
942     constructor () public {
943         // register the supported interface to conform to ERC721Enumerable via ERC165
944         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
945     }
946 
947     /**
948      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
949      * @param owner address owning the tokens list to be accessed
950      * @param index uint256 representing the index to be accessed of the requested tokens list
951      * @return uint256 token ID at the given index of the tokens list owned by the requested address
952      */
953     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
954         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
955         return _ownedTokens[owner][index];
956     }
957 
958     /**
959      * @dev Gets the total amount of tokens stored by the contract.
960      * @return uint256 representing the total amount of tokens
961      */
962     function totalSupply() public view returns (uint256) {
963         return _allTokens.length;
964     }
965 
966     /**
967      * @dev Gets the token ID at a given index of all the tokens in this contract
968      * Reverts if the index is greater or equal to the total number of tokens.
969      * @param index uint256 representing the index to be accessed of the tokens list
970      * @return uint256 token ID at the given index of the tokens list
971      */
972     function tokenByIndex(uint256 index) public view returns (uint256) {
973         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
974         return _allTokens[index];
975     }
976 
977     /**
978      * @dev Internal function to transfer ownership of a given token ID to another address.
979      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
980      * @param from current owner of the token
981      * @param to address to receive the ownership of the given token ID
982      * @param tokenId uint256 ID of the token to be transferred
983      */
984     function _transferFrom(address from, address to, uint256 tokenId) internal {
985         super._transferFrom(from, to, tokenId);
986 
987         _removeTokenFromOwnerEnumeration(from, tokenId);
988 
989         _addTokenToOwnerEnumeration(to, tokenId);
990     }
991 
992     /**
993      * @dev Internal function to mint a new token.
994      * Reverts if the given token ID already exists.
995      * @param to address the beneficiary that will own the minted token
996      * @param tokenId uint256 ID of the token to be minted
997      */
998     function _mint(address to, uint256 tokenId) internal {
999         super._mint(to, tokenId);
1000 
1001         _addTokenToOwnerEnumeration(to, tokenId);
1002 
1003         _addTokenToAllTokensEnumeration(tokenId);
1004     }
1005 
1006     /**
1007      * @dev Internal function to burn a specific token.
1008      * Reverts if the token does not exist.
1009      * Deprecated, use {ERC721-_burn} instead.
1010      * @param owner owner of the token to burn
1011      * @param tokenId uint256 ID of the token being burned
1012      */
1013     function _burn(address owner, uint256 tokenId) internal {
1014         super._burn(owner, tokenId);
1015 
1016         _removeTokenFromOwnerEnumeration(owner, tokenId);
1017         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1018         _ownedTokensIndex[tokenId] = 0;
1019 
1020         _removeTokenFromAllTokensEnumeration(tokenId);
1021     }
1022 
1023     /**
1024      * @dev Gets the list of token IDs of the requested owner.
1025      * @param owner address owning the tokens
1026      * @return uint256[] List of token IDs owned by the requested address
1027      */
1028     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1029         return _ownedTokens[owner];
1030     }
1031 
1032     /**
1033      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1034      * @param to address representing the new owner of the given token ID
1035      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1036      */
1037     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1038         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1039         _ownedTokens[to].push(tokenId);
1040     }
1041 
1042     /**
1043      * @dev Private function to add a token to this extension's token tracking data structures.
1044      * @param tokenId uint256 ID of the token to be added to the tokens list
1045      */
1046     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1047         _allTokensIndex[tokenId] = _allTokens.length;
1048         _allTokens.push(tokenId);
1049     }
1050 
1051     /**
1052      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1053      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1054      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1055      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1056      * @param from address representing the previous owner of the given token ID
1057      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1058      */
1059     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1060         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1061         // then delete the last slot (swap and pop).
1062 
1063         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1064         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1065 
1066         // When the token to delete is the last token, the swap operation is unnecessary
1067         if (tokenIndex != lastTokenIndex) {
1068             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1069 
1070             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1071             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1072         }
1073 
1074         // This also deletes the contents at the last position of the array
1075         _ownedTokens[from].length--;
1076 
1077         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1078         // lastTokenId, or just over the end of the array if the token was the last one).
1079     }
1080 
1081     /**
1082      * @dev Private function to remove a token from this extension's token tracking data structures.
1083      * This has O(1) time complexity, but alters the order of the _allTokens array.
1084      * @param tokenId uint256 ID of the token to be removed from the tokens list
1085      */
1086     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1087         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1088         // then delete the last slot (swap and pop).
1089 
1090         uint256 lastTokenIndex = _allTokens.length.sub(1);
1091         uint256 tokenIndex = _allTokensIndex[tokenId];
1092 
1093         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1094         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1095         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1096         uint256 lastTokenId = _allTokens[lastTokenIndex];
1097 
1098         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1099         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1100 
1101         // This also deletes the contents at the last position of the array
1102         _allTokens.length--;
1103         _allTokensIndex[tokenId] = 0;
1104     }
1105 }
1106 
1107 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1108 
1109 pragma solidity ^0.5.0;
1110 
1111 
1112 /**
1113  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1114  * @dev See https://eips.ethereum.org/EIPS/eip-721
1115  */
1116 contract IERC721Metadata is IERC721 {
1117     function name() external view returns (string memory);
1118     function symbol() external view returns (string memory);
1119     function tokenURI(uint256 tokenId) external view returns (string memory);
1120 }
1121 
1122 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
1123 
1124 pragma solidity ^0.5.0;
1125 
1126 
1127 
1128 
1129 
1130 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1131     // Token name
1132     string private _name;
1133 
1134     // Token symbol
1135     string private _symbol;
1136 
1137     // Optional mapping for token URIs
1138     mapping(uint256 => string) private _tokenURIs;
1139 
1140     /*
1141      *     bytes4(keccak256('name()')) == 0x06fdde03
1142      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1143      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1144      *
1145      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1146      */
1147     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1148 
1149     /**
1150      * @dev Constructor function
1151      */
1152     constructor (string memory name, string memory symbol) public {
1153         _name = name;
1154         _symbol = symbol;
1155 
1156         // register the supported interfaces to conform to ERC721 via ERC165
1157         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1158     }
1159 
1160     /**
1161      * @dev Gets the token name.
1162      * @return string representing the token name
1163      */
1164     function name() external view returns (string memory) {
1165         return _name;
1166     }
1167 
1168     /**
1169      * @dev Gets the token symbol.
1170      * @return string representing the token symbol
1171      */
1172     function symbol() external view returns (string memory) {
1173         return _symbol;
1174     }
1175 
1176     /**
1177      * @dev Returns an URI for a given token ID.
1178      * Throws if the token ID does not exist. May return an empty string.
1179      * @param tokenId uint256 ID of the token to query
1180      */
1181     function tokenURI(uint256 tokenId) external view returns (string memory) {
1182         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1183         return _tokenURIs[tokenId];
1184     }
1185 
1186     /**
1187      * @dev Internal function to set the token URI for a given token.
1188      * Reverts if the token ID does not exist.
1189      * @param tokenId uint256 ID of the token to set its URI
1190      * @param uri string URI to assign
1191      */
1192     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1193         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1194         _tokenURIs[tokenId] = uri;
1195     }
1196 
1197     /**
1198      * @dev Internal function to burn a specific token.
1199      * Reverts if the token does not exist.
1200      * Deprecated, use _burn(uint256) instead.
1201      * @param owner owner of the token to burn
1202      * @param tokenId uint256 ID of the token being burned by the msg.sender
1203      */
1204     function _burn(address owner, uint256 tokenId) internal {
1205         super._burn(owner, tokenId);
1206 
1207         // Clear metadata (if any)
1208         if (bytes(_tokenURIs[tokenId]).length != 0) {
1209             delete _tokenURIs[tokenId];
1210         }
1211     }
1212 }
1213 
1214 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1215 
1216 pragma solidity ^0.5.0;
1217 
1218 
1219 
1220 
1221 /**
1222  * @title Full ERC721 Token
1223  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1224  * Moreover, it includes approve all functionality using operator terminology.
1225  *
1226  * See https://eips.ethereum.org/EIPS/eip-721
1227  */
1228 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1229     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1230         // solhint-disable-previous-line no-empty-blocks
1231     }
1232 }
1233 
1234 // File: contracts/interfaces/IENSRegistry.sol
1235 
1236 pragma solidity ^0.5.15;
1237 
1238 /**
1239  * @title EnsRegistry
1240  * @dev Extract of the interface for ENS Registry
1241 */
1242 contract IENSRegistry {
1243     function setOwner(bytes32 node, address owner) public;
1244     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
1245     function setResolver(bytes32 node, address resolver) public;
1246     function owner(bytes32 node) public view returns (address);
1247     function resolver(bytes32 node) public view returns (address);
1248 }
1249 
1250 // File: contracts/interfaces/IENSResolver.sol
1251 
1252 pragma solidity ^0.5.15;
1253 
1254 /**
1255  * @title EnsResolver
1256  * @dev Extract of the interface for ENS Resolver
1257  */
1258 contract IENSResolver {
1259      /**
1260      * Sets the address associated with an ENS node.
1261      * May only be called by the owner of that node in the ENS registry.
1262      * @param node - The node to update.
1263      * @param addr - The address to set.
1264      */
1265     function setAddr(bytes32 node, address addr) public;
1266 
1267     /**
1268      * Returns the address associated with an ENS node.
1269      * @param node - The ENS node to query.
1270      * @return The associated address.
1271      */
1272     function addr(bytes32 node) public view returns (address);
1273 }
1274 
1275 // File: contracts/interfaces/IBaseRegistrar.sol
1276 
1277 pragma solidity ^0.5.15;
1278 
1279 contract IBaseRegistrar {
1280     /**
1281      * @dev Register a name.
1282      * @param id - node id to be registered.
1283      * @param owner - owner of the node.
1284      * @param duration - ttl.
1285      */
1286     function register(uint256 id, address owner, uint duration) external returns(uint);
1287 
1288     /**
1289      * @dev Renew a name.
1290      * @param id - node id to be renewed.
1291      * @param duration - ttl
1292      */
1293     function renew(uint256 id, uint duration) external returns(uint);
1294 
1295     /**
1296      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
1297      * @param id - node id.
1298      * @param owner - owner of the node.
1299      */
1300     function reclaim(uint256 id, address owner) external;
1301 
1302     /**
1303      * @dev Transfer a name to a new owner.
1304      * @param from - current owner of the node.
1305      * @param to - new owner of the node.
1306      * @param id - node id.
1307      */
1308     function transferFrom(address from, address to, uint256 id) public;
1309 
1310     /**
1311      * @dev Gets the owner of the specified token ID
1312      * @param tokenId uint256 ID of the token to query the owner of
1313      * @return owner address currently marked as the owner of the given token ID
1314      */
1315     function ownerOf(uint256 tokenId) public view returns (address);
1316 }
1317 
1318 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
1319 
1320 pragma solidity ^0.5.2;
1321 
1322 /**
1323  * @title ERC20 interface
1324  * @dev see https://eips.ethereum.org/EIPS/eip-20
1325  */
1326 interface IERC20 {
1327     function transfer(address to, uint256 value) external returns (bool);
1328 
1329     function approve(address spender, uint256 value) external returns (bool);
1330 
1331     function transferFrom(address from, address to, uint256 value) external returns (bool);
1332 
1333     function totalSupply() external view returns (uint256);
1334 
1335     function balanceOf(address who) external view returns (uint256);
1336 
1337     function allowance(address owner, address spender) external view returns (uint256);
1338 
1339     event Transfer(address indexed from, address indexed to, uint256 value);
1340 
1341     event Approval(address indexed owner, address indexed spender, uint256 value);
1342 }
1343 
1344 // File: contracts/interfaces/IERC20Token.sol
1345 
1346 pragma solidity ^0.5.15;
1347 
1348 
1349 contract IERC20Token is IERC20{
1350     function balanceOf(address from) public view returns (uint256);
1351     function transferFrom(address from, address to, uint tokens) public returns (bool);
1352     function allowance(address owner, address spender) public view returns (uint256);
1353     function burn(uint256 amount) public;
1354 }
1355 
1356 // File: contracts/ens/DCLRegistrar.sol
1357 
1358 pragma solidity ^0.5.15;
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 
1368 contract DCLRegistrar is ERC721Full, Ownable {
1369     using Address for address;
1370     bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
1371 
1372     // The ENS registry
1373     IENSRegistry public registry;
1374     // The ENS base registrar
1375     IBaseRegistrar public base;
1376 
1377     // A map of addresses that are authorised to register and renew names.
1378     mapping(address => bool) public controllers;
1379 
1380     // Empty hash
1381     bytes32 emptyNamehash = 0x00;
1382     // Top domain e.g: eth
1383     string public topdomain;
1384     // Domain e.g: dcl
1385     string public domain;
1386     // Top domain hash
1387     bytes32 public topdomainNameHash;
1388     // Domain hash
1389     bytes32 public domainNameHash;
1390     // Base URI
1391     string public baseURI;
1392 
1393     // Whether the migration of v1 names has finished or not
1394     bool public migrated;
1395 
1396     // A map of subdomain hashes to its string for reverse lookup
1397     mapping (bytes32 => string) public subdomains;
1398 
1399     // Emitted when a new name is registered
1400     event NameRegistered(
1401         address indexed _caller,
1402         address indexed _beneficiary,
1403         bytes32 indexed _labelHash,
1404         string _subdomain,
1405         uint256 _createdDate
1406     );
1407     // Emitted when a user reclaim a subdomain to the ENS Registry
1408     event Reclaimed(address indexed _caller, address indexed _owner, uint256 indexed  _tokenId);
1409     // Emitted when the owner of the contract reclaim the domain to the ENS Registry
1410     event DomainReclaimed(uint256 indexed _tokenId);
1411     // Emitted when the domain was transferred
1412     event DomainTransferred(address indexed _newOwner, uint256 indexed _tokenId);
1413 
1414     // Emitted when the registry was updated
1415     event RegistryUpdated(IENSRegistry indexed _previousRegistry, IENSRegistry indexed _newRegistry);
1416     // Emitted when the base was updated
1417     event BaseUpdated(IBaseRegistrar indexed _previousBase, IBaseRegistrar indexed _newBase);
1418 
1419     // Emitted when a controller was added
1420     event ControllerAdded(address indexed _controller);
1421     // Emitted when a controller was removed
1422     event ControllerRemoved(address indexed _controller);
1423 
1424     // Emitted when the migration was finished
1425     event MigrationFinished();
1426 
1427     // Emitted when base URI is was changed
1428     event BaseURI(string _oldBaseURI, string _newBaseURI);
1429 
1430     // Emit when the resolver is set to the owned domain
1431     event ResolverUpdated(address indexed _oldResolver, address indexed _newResolver);
1432 
1433     // Emit when a call is forwarred to the resolver
1434     event CallForwarwedToResolver(address indexed _resolver, bytes _data, bytes res);
1435 
1436 
1437     /**
1438 	 * @dev Check if the sender is an authorized controller
1439      */
1440     modifier onlyController() {
1441         require(controllers[msg.sender], "Only a controller can call this method");
1442         _;
1443     }
1444 
1445     /**
1446 	 * @dev Check if the migration is pending
1447      */
1448     modifier isNotMigrated() {
1449         require(!migrated, "The migration has finished");
1450         _;
1451     }
1452 
1453     /**
1454 	 * @dev Check if the migration is completed
1455      */
1456     modifier isMigrated() {
1457         require(migrated, "The migration has not finished");
1458         _;
1459     }
1460 
1461      /**
1462 	 * @dev Constructor of the contract
1463 	 * @param _registry - address of the ENS registry contract
1464      * @param _base - address of the ENS base registrar contract
1465      * @param _topdomain - top domain (e.g. "eth")
1466      * @param _domain - domain (e.g. "dcl")
1467      * @param _baseURI - base URI for token URIs
1468 	 */
1469     constructor(
1470         IENSRegistry _registry,
1471         IBaseRegistrar _base,
1472         string memory _topdomain,
1473         string memory _domain,
1474         string memory _baseURI
1475     ) public ERC721Full("DCL Registrar", "DCLENS") {
1476         // ENS registry
1477         updateRegistry(_registry);
1478         // ENS base registrar
1479         updateBase(_base);
1480 
1481         // Top domain string
1482         require(bytes(_topdomain).length > 0, "Top domain can not be empty");
1483         topdomain = _topdomain;
1484 
1485         // Domain string
1486         require(bytes(_domain).length > 0, "Domain can not be empty");
1487         domain = _domain;
1488 
1489         // Generate namehash for the top domain
1490         topdomainNameHash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(topdomain))));
1491         // Generate namehash for the domain
1492         domainNameHash = keccak256(abi.encodePacked(topdomainNameHash, keccak256(abi.encodePacked(domain))));
1493 
1494         // Set base URI
1495         updateBaseURI(_baseURI);
1496     }
1497 
1498     /**
1499 	 * @dev Migrate names from v1
1500 	 * @param _names - array of names
1501      * @param _beneficiaries - array of beneficiaries
1502      * @param _createdDates - array of created dates
1503 	 */
1504     function migrateNames(
1505         bytes32[] calldata _names,
1506         address[] calldata _beneficiaries,
1507         uint256[] calldata _createdDates
1508     ) external onlyOwner isNotMigrated {
1509         for (uint256 i = 0; i < _names.length; i++) {
1510             string memory name = _bytes32ToString(_names[i]);
1511             _register(
1512                 name,
1513                 keccak256(abi.encodePacked(_toLowerCase(name))),
1514                 _beneficiaries[i],
1515                 _createdDates[i]
1516             );
1517         }
1518     }
1519 
1520     /**
1521 	 * @dev Allows to create a subdomain (e.g. "nacho.dcl.eth"), set its resolver, owner and target address
1522 	 * @param _subdomain - subdomain  (e.g. "nacho")
1523 	 * @param _beneficiary - address that will become owner of this new subdomain
1524 	 */
1525     function register(
1526         string calldata _subdomain,
1527         address _beneficiary
1528     ) external onlyController isMigrated {
1529         // Make sure this contract owns the domain
1530         _checkOwnerOfDomain();
1531         // Create labelhash for the subdomain
1532         bytes32 subdomainLabelHash = keccak256(abi.encodePacked(_toLowerCase(_subdomain)));
1533         // Make sure it is free
1534         require(_available(subdomainLabelHash), "Subdomain already owned");
1535         // solium-disable-next-line security/no-block-members
1536         _register(_subdomain, subdomainLabelHash, _beneficiary, now);
1537     }
1538 
1539     /**
1540 	 * @dev Internal function to register a subdomain
1541 	 * @param _subdomain - subdomain  (e.g. "nacho")
1542      * @param subdomainLabelHash - hash of the subdomain
1543 	 * @param _beneficiary - address that will become owner of this new subdomain
1544 	 */
1545     function _register(
1546         string memory _subdomain,
1547         bytes32 subdomainLabelHash,
1548         address _beneficiary,
1549         uint256 _createdDate
1550     ) internal {
1551         // Create new subdomain and assign the _beneficiary as the owner
1552         registry.setSubnodeOwner(domainNameHash, subdomainLabelHash, _beneficiary);
1553         // Mint an ERC721 token with the sud domain label hash as its id
1554         _mint(_beneficiary, uint256(subdomainLabelHash));
1555         // Map the ERC721 token id with the subdomain for reversion.
1556         subdomains[subdomainLabelHash] = _subdomain;
1557         // Emit registered name event
1558         emit NameRegistered(msg.sender, _beneficiary, subdomainLabelHash, _subdomain, _createdDate);
1559     }
1560 
1561     /**
1562 	 * @dev Re-claim the ownership of a subdomain (e.g. "nacho").
1563      * @notice After a subdomain is transferred by this contract, the owner in the ENS registry contract
1564      * is still the old owner. Therefore, the owner should call `reclaim` to update the owner of the subdomain.
1565      * It is also useful to recreate the subdomains in case of an ENS migration.
1566 	 * @param _tokenId - erc721 token id which represents the node (subdomain).
1567      */
1568     function reclaim(uint256 _tokenId) public onlyController {
1569         address owner = ownerOf(_tokenId);
1570 
1571         registry.setSubnodeOwner(domainNameHash, bytes32(_tokenId), ownerOf(_tokenId));
1572 
1573         emit Reclaimed(msg.sender, owner, _tokenId);
1574     }
1575 
1576     /**
1577 	 * @dev Re-claim the ownership of a subdomain (e.g. "nacho").
1578      * @notice After a subdomain is transferred by this contract, the owner in the ENS registry contract
1579      * is still the old owner. Therefore, the owner should call `reclaim` to update the owner of the subdomain.
1580      * It is also useful to recreate the subdomains in case of an ENS migration.
1581 	 * @param _tokenId - erc721 token id which represents the node (subdomain).
1582      * @param _owner - new owner.
1583      */
1584     function reclaim(uint256 _tokenId, address _owner) public {
1585         // Check if the sender is authorized to manage the subdomain
1586         require(
1587             _isApprovedOrOwner(msg.sender, _tokenId),
1588             "Only an authorized account can change the subdomain settings"
1589         );
1590 
1591         registry.setSubnodeOwner(domainNameHash, bytes32(_tokenId), _owner);
1592 
1593         emit Reclaimed(msg.sender, _owner, _tokenId);
1594     }
1595 
1596     /**
1597     * @dev The ERC721 smart contract calls this function on the recipient
1598     * after a `safetransfer`. This function MAY throw to revert and reject the
1599     * transfer. Return of other than the magic value MUST result in the
1600     * transaction being reverted.
1601     * Note: the contract address is always the message sender.
1602     * @notice Handle the receipt of an NFT. Used to re-claim ownership at the ENS registry contract
1603     * @param _tokenId The NFT identifier which is being transferred
1604     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1605     */
1606     function onERC721Received(
1607         address /* _operator */,
1608         address /* _from */,
1609         uint256 _tokenId,
1610         bytes memory /* _data */
1611     )
1612         public
1613         returns (bytes4)
1614     {
1615         require(msg.sender == address(base), "Only base can send NFTs to this contract");
1616 
1617         // Re-claim to update the owner at the ENS Registry
1618         base.reclaim(_tokenId, address(this));
1619         return ERC721_RECEIVED;
1620     }
1621 
1622     /**
1623 	 * @dev Check whether a name is available to be registered or not
1624 	 * @param _subdomain - name to check
1625      * @return whether the name is available or not
1626      */
1627     function available(string memory _subdomain) public view returns (bool) {
1628         // Create labelhash for the subdomain
1629         bytes32 subdomainLabelHash = keccak256(abi.encodePacked(_toLowerCase(_subdomain)));
1630         return _available(subdomainLabelHash);
1631     }
1632 
1633 
1634     /**
1635 	 * @dev Check whether a name is available to be registered or not
1636 	 * @param _subdomainLabelHash - hash of the name to check
1637      * @return whether the name is available or not
1638      */
1639     function _available(bytes32 _subdomainLabelHash) internal view returns (bool) {
1640         // Create namehash for the subdomain (node)
1641         bytes32 subdomainNameHash = keccak256(abi.encodePacked(domainNameHash, _subdomainLabelHash));
1642         // Make sure it is free
1643         return registry.owner(subdomainNameHash) == address(0) && !_exists(uint256(_subdomainLabelHash));
1644     }
1645 
1646     /**
1647      * @dev Get the token id by its subdomain
1648      * @param _subdomain - string of the subdomain
1649      * @return token id mapped to the subdomain
1650      */
1651     function getTokenId(string memory _subdomain) public view returns (uint256) {
1652         string memory subdomain = _toLowerCase(_subdomain);
1653         bytes32 subdomainLabelHash = keccak256(abi.encodePacked(subdomain));
1654         uint256 tokenId = uint256(subdomainLabelHash);
1655 
1656         require(
1657             _exists(tokenId),
1658             "The subdomain is not registered"
1659         );
1660 
1661         return tokenId;
1662     }
1663 
1664      /**
1665      * @dev Get the owner of a subdomain
1666      * @param _subdomain - string of the subdomain
1667      * @return owner of the subdomain
1668      */
1669     function getOwnerOf(string memory _subdomain) public view returns (address) {
1670         return ownerOf(getTokenId(_subdomain));
1671     }
1672 
1673     /**
1674      * @dev Returns an URI for a given token ID.
1675      * @notice that throws if the token ID does not exist. May return an empty string.
1676      * Also, if baseURI is empty, an empty string will be returned.
1677      * @param _tokenId - uint256 ID of the token queried
1678      * @return token URI
1679      */
1680     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1681         if (bytes(baseURI).length == 0) {
1682             return "";
1683         }
1684 
1685         require(_exists(_tokenId), "ERC721Metadata: received a URI query for a nonexistent token");
1686         return string(abi.encodePacked(baseURI, _toLowerCase(subdomains[bytes32(_tokenId)])));
1687     }
1688 
1689     /**
1690 	 * @dev Re-claim the ownership of the domain (e.g. "dcl")
1691      * @notice After a domain is transferred by the ENS base
1692      * registrar to this contract, the owner in the ENS registry contract
1693      * is still the old owner. Therefore, the owner should call `reclaimDomain`
1694      * to update the owner of the domain
1695 	 * @param _tokenId - erc721 token id which represents the node (domain)
1696      */
1697     function reclaimDomain(uint256 _tokenId) public onlyOwner {
1698         base.reclaim(_tokenId, address(this));
1699 
1700         emit DomainReclaimed(_tokenId);
1701     }
1702 
1703     /**
1704 	 * @dev The contract owner can take away the ownership of any domain owned by this contract
1705 	 * @param _owner - new owner for the domain
1706      * @param _tokenId - erc721 token id which represents the node (domain)
1707 	 */
1708     function transferDomainOwnership(address _owner, uint256 _tokenId) public onlyOwner {
1709         base.transferFrom(address(this), _owner, _tokenId);
1710         emit DomainTransferred(_owner, _tokenId);
1711     }
1712 
1713     /**
1714 	 * @dev Update owned domain resolver
1715 	 * @param _resolver - new resolver
1716 	 */
1717     function setResolver(address _resolver) public onlyOwner {
1718         address resolver = registry.resolver(domainNameHash);
1719 
1720         require(_resolver.isContract(), "New resolver should be a contract");
1721         require(_resolver != resolver, "New resolver should be different from old");
1722 
1723         _checkNotAllowedAddresses(_resolver);
1724 
1725         registry.setResolver(domainNameHash, _resolver);
1726 
1727         emit ResolverUpdated(resolver, _resolver);
1728     }
1729 
1730     /**
1731 	 * @dev Forward calls to resolver
1732 	 * @param _data - data to be send in the call
1733 	 */
1734     function forwardToResolver(bytes memory _data) public onlyOwner {
1735         address resolver = registry.resolver(domainNameHash);
1736 
1737         _checkNotAllowedAddresses(resolver);
1738 
1739         (bool success, bytes memory res) = resolver.call(_data);
1740 
1741         require(success, "Call failed");
1742 
1743         // Make sure this contract is still the owner of the domain
1744         _checkOwnerOfDomain();
1745 
1746         emit CallForwarwedToResolver(resolver, _data, res);
1747     }
1748 
1749     /**
1750 	 * @dev Authorises a controller, who can register subdomains
1751 	 * @param controller - address of the controller
1752      */
1753     function addController(address controller) external onlyOwner {
1754         require(!controllers[controller], "The controller was already added");
1755         controllers[controller] = true;
1756         emit ControllerAdded(controller);
1757     }
1758 
1759     /**
1760 	 * @dev Revoke controller permission for an address
1761 	 * @param controller - address of the controller
1762      */
1763     function removeController(address controller) external onlyOwner {
1764         require(controllers[controller], "The controller is already disabled");
1765         controllers[controller] = false;
1766         emit ControllerRemoved(controller);
1767     }
1768 
1769 	/**
1770 	 * @dev Update to new ENS registry
1771 	 * @param _registry The address of new ENS registry to use
1772 	 */
1773     function updateRegistry(IENSRegistry _registry) public onlyOwner {
1774         require(registry != _registry, "New registry should be different from old");
1775         require(address(_registry).isContract(), "New registry should be a contract");
1776 
1777         emit RegistryUpdated(registry, _registry);
1778 
1779         registry = _registry;
1780     }
1781 
1782     /**
1783 	 * @dev Update to new ENS base registrar
1784 	 * @param _base The address of new ENS base registrar to use
1785 	 */
1786     function updateBase(IBaseRegistrar _base) public onlyOwner {
1787         require(base != _base, "New base should be different from old");
1788         require(address(_base).isContract(), "New base should be a contract");
1789 
1790         emit BaseUpdated(base, _base);
1791 
1792         base = _base;
1793     }
1794 
1795     /**
1796      * @dev Set Base URI.
1797      * @param _baseURI - base URI for token URIs
1798      */
1799     function updateBaseURI(string memory _baseURI) public onlyOwner {
1800         require(
1801             keccak256(abi.encodePacked((baseURI))) != keccak256(abi.encodePacked((_baseURI))),
1802             "Base URI should be different from old"
1803         );
1804         emit BaseURI(baseURI, _baseURI);
1805         baseURI = _baseURI;
1806     }
1807 
1808     /**
1809 	 * @dev Set the migration as finished
1810 	 */
1811     function migrationFinished() external onlyOwner isNotMigrated {
1812         migrated = true;
1813         emit MigrationFinished();
1814     }
1815 
1816 
1817     function _checkOwnerOfDomain() internal view  {
1818         require(
1819             registry.owner(domainNameHash) == address(this) &&
1820             base.ownerOf(uint256(keccak256(abi.encodePacked(domain)))) == address(this),
1821             "The contract does not own the domain"
1822         );
1823     }
1824 
1825     function _checkNotAllowedAddresses(address _address) internal view {
1826         require(
1827             _address != address(base) && _address != address(registry) && _address != address(this),
1828             "Invalid address"
1829         );
1830     }
1831 
1832     /**
1833      * @dev Convert bytes32 to string.
1834      * @param _x - to be converted to string.
1835      * @return string
1836      */
1837     function _bytes32ToString(bytes32 _x) internal pure returns (string memory) {
1838         uint256 charCount = 0;
1839         for (uint256 j = 0; j <= 256; j += 8) {
1840             byte char = byte(_x << j);
1841             if (char == 0) {
1842                 break;
1843             }
1844             charCount++;
1845         }
1846 
1847         string memory out = new string(charCount);
1848 
1849         // solium-disable-next-line security/no-inline-assembly
1850         assembly {
1851             mstore(add(0x20, out), _x)
1852         }
1853 
1854         return out;
1855     }
1856 
1857     /**
1858      * @dev Lowercase a string.
1859      * @param _str - to be converted to string.
1860      * @return string
1861      */
1862     function _toLowerCase(string memory _str) internal pure returns (string memory) {
1863         bytes memory bStr = bytes(_str);
1864         bytes memory bLower = new bytes(bStr.length);
1865 
1866         for (uint i = 0; i < bStr.length; i++) {
1867             // Uppercase character...
1868             if ((bStr[i] >= 0x41) && (bStr[i] <= 0x5A)) {
1869                 // So we add 0x20 to make it lowercase
1870                 bLower[i] = bytes1(uint8(bStr[i]) + 0x20);
1871             } else {
1872                 bLower[i] = bStr[i];
1873             }
1874         }
1875         return string(bLower);
1876     }
1877 }