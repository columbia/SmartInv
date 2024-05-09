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
31 // File: @openzeppelin/contracts/introspection/IERC165.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
57 
58 pragma solidity ^0.5.0;
59 
60 
61 /**
62  * @dev Required interface of an ERC721 compliant contract.
63  */
64 contract IERC721 is IERC165 {
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of NFTs in `owner`'s account.
71      */
72     function balanceOf(address owner) public view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the NFT specified by `tokenId`.
76      */
77     function ownerOf(uint256 tokenId) public view returns (address owner);
78 
79     /**
80      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
81      * another (`to`).
82      *
83      *
84      *
85      * Requirements:
86      * - `from`, `to` cannot be zero.
87      * - `tokenId` must be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this
89      * NFT by either {approve} or {setApprovalForAll}.
90      */
91     function safeTransferFrom(address from, address to, uint256 tokenId) public;
92     /**
93      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
94      * another (`to`).
95      *
96      * Requirements:
97      * - If the caller is not `from`, it must be approved to move this NFT by
98      * either {approve} or {setApprovalForAll}.
99      */
100     function transferFrom(address from, address to, uint256 tokenId) public;
101     function approve(address to, uint256 tokenId) public;
102     function getApproved(uint256 tokenId) public view returns (address operator);
103 
104     function setApprovalForAll(address operator, bool _approved) public;
105     function isApprovedForAll(address owner, address operator) public view returns (bool);
106 
107 
108     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
109 }
110 
111 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @title ERC721 token receiver interface
117  * @dev Interface for any contract that wants to support safeTransfers
118  * from ERC721 asset contracts.
119  */
120 contract IERC721Receiver {
121     /**
122      * @notice Handle the receipt of an NFT
123      * @dev The ERC721 smart contract calls this function on the recipient
124      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
125      * otherwise the caller will revert the transaction. The selector to be
126      * returned can be obtained as `this.onERC721Received.selector`. This
127      * function MAY throw to revert and reject the transfer.
128      * Note: the ERC721 contract address is always the message sender.
129      * @param operator The address which called `safeTransferFrom` function
130      * @param from The address which previously owned the token
131      * @param tokenId The NFT identifier which is being transferred
132      * @param data Additional data with no specified format
133      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
134      */
135     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
136     public returns (bytes4);
137 }
138 
139 // File: @openzeppelin/contracts/math/SafeMath.sol
140 
141 pragma solidity ^0.5.0;
142 
143 /**
144  * @dev Wrappers over Solidity's arithmetic operations with added overflow
145  * checks.
146  *
147  * Arithmetic operations in Solidity wrap on overflow. This can easily result
148  * in bugs, because programmers usually assume that an overflow raises an
149  * error, which is the standard behavior in high level programming languages.
150  * `SafeMath` restores this intuition by reverting the transaction when an
151  * operation overflows.
152  *
153  * Using this library instead of the unchecked operations eliminates an entire
154  * class of bugs, so it's recommended to use it always.
155  */
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return sub(a, b, "SafeMath: subtraction overflow");
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      * - Subtraction cannot overflow.
194      *
195      * _Available since v2.4.0._
196      */
197     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b <= a, errorMessage);
199         uint256 c = a - b;
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `*` operator.
209      *
210      * Requirements:
211      * - Multiplication cannot overflow.
212      */
213     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
215         // benefit is lost if 'b' is also tested.
216         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
217         if (a == 0) {
218             return 0;
219         }
220 
221         uint256 c = a * b;
222         require(c / a == b, "SafeMath: multiplication overflow");
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         return div(a, b, "SafeMath: division by zero");
240     }
241 
242     /**
243      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
244      * division by zero. The result is rounded towards zero.
245      *
246      * Counterpart to Solidity's `/` operator. Note: this function uses a
247      * `revert` opcode (which leaves remaining gas untouched) while Solidity
248      * uses an invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      *
253      * _Available since v2.4.0._
254      */
255     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         // Solidity only automatically asserts when dividing by 0
257         require(b > 0, errorMessage);
258         uint256 c = a / b;
259         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276         return mod(a, b, "SafeMath: modulo by zero");
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * Reverts with custom message when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      * - The divisor cannot be zero.
289      *
290      * _Available since v2.4.0._
291      */
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b != 0, errorMessage);
294         return a % b;
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 pragma solidity ^0.5.5;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following 
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
325         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
326         // for accounts without code, i.e. `keccak256('')`
327         bytes32 codehash;
328         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
329         // solhint-disable-next-line no-inline-assembly
330         assembly { codehash := extcodehash(account) }
331         return (codehash != accountHash && codehash != 0x0);
332     }
333 
334     /**
335      * @dev Converts an `address` into `address payable`. Note that this is
336      * simply a type cast: the actual underlying value is not changed.
337      *
338      * _Available since v2.4.0._
339      */
340     function toPayable(address account) internal pure returns (address payable) {
341         return address(uint160(account));
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      *
360      * _Available since v2.4.0._
361      */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         // solhint-disable-next-line avoid-call-value
366         (bool success, ) = recipient.call.value(amount)("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 }
370 
371 // File: @openzeppelin/contracts/drafts/Counters.sol
372 
373 pragma solidity ^0.5.0;
374 
375 
376 /**
377  * @title Counters
378  * @author Matt Condon (@shrugs)
379  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
380  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
381  *
382  * Include with `using Counters for Counters.Counter;`
383  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
384  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
385  * directly accessed.
386  */
387 library Counters {
388     using SafeMath for uint256;
389 
390     struct Counter {
391         // This variable should never be directly accessed by users of the library: interactions must be restricted to
392         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
393         // this feature: see https://github.com/ethereum/solidity/issues/4637
394         uint256 _value; // default: 0
395     }
396 
397     function current(Counter storage counter) internal view returns (uint256) {
398         return counter._value;
399     }
400 
401     function increment(Counter storage counter) internal {
402         // The {SafeMath} overflow check can be skipped here, see the comment at the top
403         counter._value += 1;
404     }
405 
406     function decrement(Counter storage counter) internal {
407         counter._value = counter._value.sub(1);
408     }
409 }
410 
411 // File: @openzeppelin/contracts/introspection/ERC165.sol
412 
413 pragma solidity ^0.5.0;
414 
415 
416 /**
417  * @dev Implementation of the {IERC165} interface.
418  *
419  * Contracts may inherit from this and call {_registerInterface} to declare
420  * their support of an interface.
421  */
422 contract ERC165 is IERC165 {
423     /*
424      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
425      */
426     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
427 
428     /**
429      * @dev Mapping of interface ids to whether or not it's supported.
430      */
431     mapping(bytes4 => bool) private _supportedInterfaces;
432 
433     constructor () internal {
434         // Derived contracts need only register support for their own interfaces,
435         // we register support for ERC165 itself here
436         _registerInterface(_INTERFACE_ID_ERC165);
437     }
438 
439     /**
440      * @dev See {IERC165-supportsInterface}.
441      *
442      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
443      */
444     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
445         return _supportedInterfaces[interfaceId];
446     }
447 
448     /**
449      * @dev Registers the contract as an implementer of the interface defined by
450      * `interfaceId`. Support of the actual ERC165 interface is automatic and
451      * registering its interface id is not required.
452      *
453      * See {IERC165-supportsInterface}.
454      *
455      * Requirements:
456      *
457      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
458      */
459     function _registerInterface(bytes4 interfaceId) internal {
460         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
461         _supportedInterfaces[interfaceId] = true;
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
466 
467 pragma solidity ^0.5.0;
468 
469 
470 
471 
472 
473 
474 
475 
476 /**
477  * @title ERC721 Non-Fungible Token Standard basic implementation
478  * @dev see https://eips.ethereum.org/EIPS/eip-721
479  */
480 contract ERC721 is Context, ERC165, IERC721 {
481     using SafeMath for uint256;
482     using Address for address;
483     using Counters for Counters.Counter;
484 
485     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
486     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
487     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
488 
489     // Mapping from token ID to owner
490     mapping (uint256 => address) private _tokenOwner;
491 
492     // Mapping from token ID to approved address
493     mapping (uint256 => address) private _tokenApprovals;
494 
495     // Mapping from owner to number of owned token
496     mapping (address => Counters.Counter) private _ownedTokensCount;
497 
498     // Mapping from owner to operator approvals
499     mapping (address => mapping (address => bool)) private _operatorApprovals;
500 
501     /*
502      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
503      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
504      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
505      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
506      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
507      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
508      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
509      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
510      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
511      *
512      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
513      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
514      */
515     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
516 
517     constructor () public {
518         // register the supported interfaces to conform to ERC721 via ERC165
519         _registerInterface(_INTERFACE_ID_ERC721);
520     }
521 
522     /**
523      * @dev Gets the balance of the specified address.
524      * @param owner address to query the balance of
525      * @return uint256 representing the amount owned by the passed address
526      */
527     function balanceOf(address owner) public view returns (uint256) {
528         require(owner != address(0), "ERC721: balance query for the zero address");
529 
530         return _ownedTokensCount[owner].current();
531     }
532 
533     /**
534      * @dev Gets the owner of the specified token ID.
535      * @param tokenId uint256 ID of the token to query the owner of
536      * @return address currently marked as the owner of the given token ID
537      */
538     function ownerOf(uint256 tokenId) public view returns (address) {
539         address owner = _tokenOwner[tokenId];
540         require(owner != address(0), "ERC721: owner query for nonexistent token");
541 
542         return owner;
543     }
544 
545     /**
546      * @dev Approves another address to transfer the given token ID
547      * The zero address indicates there is no approved address.
548      * There can only be one approved address per token at a given time.
549      * Can only be called by the token owner or an approved operator.
550      * @param to address to be approved for the given token ID
551      * @param tokenId uint256 ID of the token to be approved
552      */
553     function approve(address to, uint256 tokenId) public {
554         address owner = ownerOf(tokenId);
555         require(to != owner, "ERC721: approval to current owner");
556 
557         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
558             "ERC721: approve caller is not owner nor approved for all"
559         );
560 
561         _tokenApprovals[tokenId] = to;
562         emit Approval(owner, to, tokenId);
563     }
564 
565     /**
566      * @dev Gets the approved address for a token ID, or zero if no address set
567      * Reverts if the token ID does not exist.
568      * @param tokenId uint256 ID of the token to query the approval of
569      * @return address currently approved for the given token ID
570      */
571     function getApproved(uint256 tokenId) public view returns (address) {
572         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
573 
574         return _tokenApprovals[tokenId];
575     }
576 
577     /**
578      * @dev Sets or unsets the approval of a given operator
579      * An operator is allowed to transfer all tokens of the sender on their behalf.
580      * @param to operator address to set the approval
581      * @param approved representing the status of the approval to be set
582      */
583     function setApprovalForAll(address to, bool approved) public {
584         require(to != _msgSender(), "ERC721: approve to caller");
585 
586         _operatorApprovals[_msgSender()][to] = approved;
587         emit ApprovalForAll(_msgSender(), to, approved);
588     }
589 
590     /**
591      * @dev Tells whether an operator is approved by a given owner.
592      * @param owner owner address which you want to query the approval of
593      * @param operator operator address which you want to query the approval of
594      * @return bool whether the given operator is approved by the given owner
595      */
596     function isApprovedForAll(address owner, address operator) public view returns (bool) {
597         return _operatorApprovals[owner][operator];
598     }
599 
600     /**
601      * @dev Transfers the ownership of a given token ID to another address.
602      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
603      * Requires the msg.sender to be the owner, approved, or operator.
604      * @param from current owner of the token
605      * @param to address to receive the ownership of the given token ID
606      * @param tokenId uint256 ID of the token to be transferred
607      */
608     function transferFrom(address from, address to, uint256 tokenId) public {
609         //solhint-disable-next-line max-line-length
610         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
611 
612         _transferFrom(from, to, tokenId);
613     }
614 
615     /**
616      * @dev Safely transfers the ownership of a given token ID to another address
617      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
618      * which is called upon a safe transfer, and return the magic value
619      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
620      * the transfer is reverted.
621      * Requires the msg.sender to be the owner, approved, or operator
622      * @param from current owner of the token
623      * @param to address to receive the ownership of the given token ID
624      * @param tokenId uint256 ID of the token to be transferred
625      */
626     function safeTransferFrom(address from, address to, uint256 tokenId) public {
627         safeTransferFrom(from, to, tokenId, "");
628     }
629 
630     /**
631      * @dev Safely transfers the ownership of a given token ID to another address
632      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
633      * which is called upon a safe transfer, and return the magic value
634      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
635      * the transfer is reverted.
636      * Requires the _msgSender() to be the owner, approved, or operator
637      * @param from current owner of the token
638      * @param to address to receive the ownership of the given token ID
639      * @param tokenId uint256 ID of the token to be transferred
640      * @param _data bytes data to send along with a safe transfer check
641      */
642     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
643         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
644         _safeTransferFrom(from, to, tokenId, _data);
645     }
646 
647     /**
648      * @dev Safely transfers the ownership of a given token ID to another address
649      * If the target address is a contract, it must implement `onERC721Received`,
650      * which is called upon a safe transfer, and return the magic value
651      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
652      * the transfer is reverted.
653      * Requires the msg.sender to be the owner, approved, or operator
654      * @param from current owner of the token
655      * @param to address to receive the ownership of the given token ID
656      * @param tokenId uint256 ID of the token to be transferred
657      * @param _data bytes data to send along with a safe transfer check
658      */
659     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
660         _transferFrom(from, to, tokenId);
661         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
662     }
663 
664     /**
665      * @dev Returns whether the specified token exists.
666      * @param tokenId uint256 ID of the token to query the existence of
667      * @return bool whether the token exists
668      */
669     function _exists(uint256 tokenId) internal view returns (bool) {
670         address owner = _tokenOwner[tokenId];
671         return owner != address(0);
672     }
673 
674     /**
675      * @dev Returns whether the given spender can transfer a given token ID.
676      * @param spender address of the spender to query
677      * @param tokenId uint256 ID of the token to be transferred
678      * @return bool whether the msg.sender is approved for the given token ID,
679      * is an operator of the owner, or is the owner of the token
680      */
681     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
682         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
683         address owner = ownerOf(tokenId);
684         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
685     }
686 
687     /**
688      * @dev Internal function to safely mint a new token.
689      * Reverts if the given token ID already exists.
690      * If the target address is a contract, it must implement `onERC721Received`,
691      * which is called upon a safe transfer, and return the magic value
692      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
693      * the transfer is reverted.
694      * @param to The address that will own the minted token
695      * @param tokenId uint256 ID of the token to be minted
696      */
697     function _safeMint(address to, uint256 tokenId) internal {
698         _safeMint(to, tokenId, "");
699     }
700 
701     /**
702      * @dev Internal function to safely mint a new token.
703      * Reverts if the given token ID already exists.
704      * If the target address is a contract, it must implement `onERC721Received`,
705      * which is called upon a safe transfer, and return the magic value
706      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
707      * the transfer is reverted.
708      * @param to The address that will own the minted token
709      * @param tokenId uint256 ID of the token to be minted
710      * @param _data bytes data to send along with a safe transfer check
711      */
712     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
713         _mint(to, tokenId);
714         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
715     }
716 
717     /**
718      * @dev Internal function to mint a new token.
719      * Reverts if the given token ID already exists.
720      * @param to The address that will own the minted token
721      * @param tokenId uint256 ID of the token to be minted
722      */
723     function _mint(address to, uint256 tokenId) internal {
724         require(to != address(0), "ERC721: mint to the zero address");
725         require(!_exists(tokenId), "ERC721: token already minted");
726 
727         _tokenOwner[tokenId] = to;
728         _ownedTokensCount[to].increment();
729 
730         emit Transfer(address(0), to, tokenId);
731     }
732 
733     /**
734      * @dev Internal function to burn a specific token.
735      * Reverts if the token does not exist.
736      * Deprecated, use {_burn} instead.
737      * @param owner owner of the token to burn
738      * @param tokenId uint256 ID of the token being burned
739      */
740     function _burn(address owner, uint256 tokenId) internal {
741         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
742 
743         _clearApproval(tokenId);
744 
745         _ownedTokensCount[owner].decrement();
746         _tokenOwner[tokenId] = address(0);
747 
748         emit Transfer(owner, address(0), tokenId);
749     }
750 
751     /**
752      * @dev Internal function to burn a specific token.
753      * Reverts if the token does not exist.
754      * @param tokenId uint256 ID of the token being burned
755      */
756     function _burn(uint256 tokenId) internal {
757         _burn(ownerOf(tokenId), tokenId);
758     }
759 
760     /**
761      * @dev Internal function to transfer ownership of a given token ID to another address.
762      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
763      * @param from current owner of the token
764      * @param to address to receive the ownership of the given token ID
765      * @param tokenId uint256 ID of the token to be transferred
766      */
767     function _transferFrom(address from, address to, uint256 tokenId) internal {
768         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
769         require(to != address(0), "ERC721: transfer to the zero address");
770 
771         _clearApproval(tokenId);
772 
773         _ownedTokensCount[from].decrement();
774         _ownedTokensCount[to].increment();
775 
776         _tokenOwner[tokenId] = to;
777 
778         emit Transfer(from, to, tokenId);
779     }
780 
781     /**
782      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
783      * The call is not executed if the target address is not a contract.
784      *
785      * This is an internal detail of the `ERC721` contract and its use is deprecated.
786      * @param from address representing the previous owner of the given token ID
787      * @param to target address that will receive the tokens
788      * @param tokenId uint256 ID of the token to be transferred
789      * @param _data bytes optional data to send along with the call
790      * @return bool whether the call correctly returned the expected magic value
791      */
792     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
793         internal returns (bool)
794     {
795         if (!to.isContract()) {
796             return true;
797         }
798         // solhint-disable-next-line avoid-low-level-calls
799         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
800             IERC721Receiver(to).onERC721Received.selector,
801             _msgSender(),
802             from,
803             tokenId,
804             _data
805         ));
806         if (!success) {
807             if (returndata.length > 0) {
808                 // solhint-disable-next-line no-inline-assembly
809                 assembly {
810                     let returndata_size := mload(returndata)
811                     revert(add(32, returndata), returndata_size)
812                 }
813             } else {
814                 revert("ERC721: transfer to non ERC721Receiver implementer");
815             }
816         } else {
817             bytes4 retval = abi.decode(returndata, (bytes4));
818             return (retval == _ERC721_RECEIVED);
819         }
820     }
821 
822     /**
823      * @dev Private function to clear current approval of a given token ID.
824      * @param tokenId uint256 ID of the token to be transferred
825      */
826     function _clearApproval(uint256 tokenId) private {
827         if (_tokenApprovals[tokenId] != address(0)) {
828             _tokenApprovals[tokenId] = address(0);
829         }
830     }
831 }
832 
833 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
834 
835 pragma solidity ^0.5.0;
836 
837 
838 /**
839  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
840  * @dev See https://eips.ethereum.org/EIPS/eip-721
841  */
842 contract IERC721Enumerable is IERC721 {
843     function totalSupply() public view returns (uint256);
844     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
845 
846     function tokenByIndex(uint256 index) public view returns (uint256);
847 }
848 
849 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
850 
851 pragma solidity ^0.5.0;
852 
853 
854 
855 
856 
857 /**
858  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
859  * @dev See https://eips.ethereum.org/EIPS/eip-721
860  */
861 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
862     // Mapping from owner to list of owned token IDs
863     mapping(address => uint256[]) private _ownedTokens;
864 
865     // Mapping from token ID to index of the owner tokens list
866     mapping(uint256 => uint256) private _ownedTokensIndex;
867 
868     // Array with all token ids, used for enumeration
869     uint256[] private _allTokens;
870 
871     // Mapping from token id to position in the allTokens array
872     mapping(uint256 => uint256) private _allTokensIndex;
873 
874     /*
875      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
876      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
877      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
878      *
879      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
880      */
881     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
882 
883     /**
884      * @dev Constructor function.
885      */
886     constructor () public {
887         // register the supported interface to conform to ERC721Enumerable via ERC165
888         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
889     }
890 
891     /**
892      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
893      * @param owner address owning the tokens list to be accessed
894      * @param index uint256 representing the index to be accessed of the requested tokens list
895      * @return uint256 token ID at the given index of the tokens list owned by the requested address
896      */
897     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
898         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
899         return _ownedTokens[owner][index];
900     }
901 
902     /**
903      * @dev Gets the total amount of tokens stored by the contract.
904      * @return uint256 representing the total amount of tokens
905      */
906     function totalSupply() public view returns (uint256) {
907         return _allTokens.length;
908     }
909 
910     /**
911      * @dev Gets the token ID at a given index of all the tokens in this contract
912      * Reverts if the index is greater or equal to the total number of tokens.
913      * @param index uint256 representing the index to be accessed of the tokens list
914      * @return uint256 token ID at the given index of the tokens list
915      */
916     function tokenByIndex(uint256 index) public view returns (uint256) {
917         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
918         return _allTokens[index];
919     }
920 
921     /**
922      * @dev Internal function to transfer ownership of a given token ID to another address.
923      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
924      * @param from current owner of the token
925      * @param to address to receive the ownership of the given token ID
926      * @param tokenId uint256 ID of the token to be transferred
927      */
928     function _transferFrom(address from, address to, uint256 tokenId) internal {
929         super._transferFrom(from, to, tokenId);
930 
931         _removeTokenFromOwnerEnumeration(from, tokenId);
932 
933         _addTokenToOwnerEnumeration(to, tokenId);
934     }
935 
936     /**
937      * @dev Internal function to mint a new token.
938      * Reverts if the given token ID already exists.
939      * @param to address the beneficiary that will own the minted token
940      * @param tokenId uint256 ID of the token to be minted
941      */
942     function _mint(address to, uint256 tokenId) internal {
943         super._mint(to, tokenId);
944 
945         _addTokenToOwnerEnumeration(to, tokenId);
946 
947         _addTokenToAllTokensEnumeration(tokenId);
948     }
949 
950     /**
951      * @dev Internal function to burn a specific token.
952      * Reverts if the token does not exist.
953      * Deprecated, use {ERC721-_burn} instead.
954      * @param owner owner of the token to burn
955      * @param tokenId uint256 ID of the token being burned
956      */
957     function _burn(address owner, uint256 tokenId) internal {
958         super._burn(owner, tokenId);
959 
960         _removeTokenFromOwnerEnumeration(owner, tokenId);
961         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
962         _ownedTokensIndex[tokenId] = 0;
963 
964         _removeTokenFromAllTokensEnumeration(tokenId);
965     }
966 
967     /**
968      * @dev Gets the list of token IDs of the requested owner.
969      * @param owner address owning the tokens
970      * @return uint256[] List of token IDs owned by the requested address
971      */
972     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
973         return _ownedTokens[owner];
974     }
975 
976     /**
977      * @dev Private function to add a token to this extension's ownership-tracking data structures.
978      * @param to address representing the new owner of the given token ID
979      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
980      */
981     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
982         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
983         _ownedTokens[to].push(tokenId);
984     }
985 
986     /**
987      * @dev Private function to add a token to this extension's token tracking data structures.
988      * @param tokenId uint256 ID of the token to be added to the tokens list
989      */
990     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
991         _allTokensIndex[tokenId] = _allTokens.length;
992         _allTokens.push(tokenId);
993     }
994 
995     /**
996      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
997      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
998      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
999      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1000      * @param from address representing the previous owner of the given token ID
1001      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1002      */
1003     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1004         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1005         // then delete the last slot (swap and pop).
1006 
1007         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1008         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1009 
1010         // When the token to delete is the last token, the swap operation is unnecessary
1011         if (tokenIndex != lastTokenIndex) {
1012             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1013 
1014             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1015             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1016         }
1017 
1018         // This also deletes the contents at the last position of the array
1019         _ownedTokens[from].length--;
1020 
1021         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1022         // lastTokenId, or just over the end of the array if the token was the last one).
1023     }
1024 
1025     /**
1026      * @dev Private function to remove a token from this extension's token tracking data structures.
1027      * This has O(1) time complexity, but alters the order of the _allTokens array.
1028      * @param tokenId uint256 ID of the token to be removed from the tokens list
1029      */
1030     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1031         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1032         // then delete the last slot (swap and pop).
1033 
1034         uint256 lastTokenIndex = _allTokens.length.sub(1);
1035         uint256 tokenIndex = _allTokensIndex[tokenId];
1036 
1037         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1038         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1039         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1040         uint256 lastTokenId = _allTokens[lastTokenIndex];
1041 
1042         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1043         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1044 
1045         // This also deletes the contents at the last position of the array
1046         _allTokens.length--;
1047         _allTokensIndex[tokenId] = 0;
1048     }
1049 }
1050 
1051 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1052 
1053 pragma solidity ^0.5.0;
1054 
1055 
1056 /**
1057  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1058  * @dev See https://eips.ethereum.org/EIPS/eip-721
1059  */
1060 contract IERC721Metadata is IERC721 {
1061     function name() external view returns (string memory);
1062     function symbol() external view returns (string memory);
1063     function tokenURI(uint256 tokenId) external view returns (string memory);
1064 }
1065 
1066 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
1067 
1068 pragma solidity ^0.5.0;
1069 
1070 
1071 
1072 
1073 
1074 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1075     // Token name
1076     string private _name;
1077 
1078     // Token symbol
1079     string private _symbol;
1080 
1081     // Base URI
1082     string private _baseURI;
1083 
1084     // Optional mapping for token URIs
1085     mapping(uint256 => string) private _tokenURIs;
1086 
1087     /*
1088      *     bytes4(keccak256('name()')) == 0x06fdde03
1089      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1090      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1091      *
1092      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1093      */
1094     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1095 
1096     /**
1097      * @dev Constructor function
1098      */
1099     constructor (string memory name, string memory symbol) public {
1100         _name = name;
1101         _symbol = symbol;
1102 
1103         // register the supported interfaces to conform to ERC721 via ERC165
1104         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1105     }
1106 
1107     /**
1108      * @dev Gets the token name.
1109      * @return string representing the token name
1110      */
1111     function name() external view returns (string memory) {
1112         return _name;
1113     }
1114 
1115     /**
1116      * @dev Gets the token symbol.
1117      * @return string representing the token symbol
1118      */
1119     function symbol() external view returns (string memory) {
1120         return _symbol;
1121     }
1122 
1123     /**
1124      * @dev Returns the URI for a given token ID. May return an empty string.
1125      *
1126      * If the token's URI is non-empty and a base URI was set (via
1127      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1128      *
1129      * Reverts if the token ID does not exist.
1130      */
1131     function tokenURI(uint256 tokenId) external view returns (string memory) {
1132         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1133 
1134         string memory _tokenURI = _tokenURIs[tokenId];
1135 
1136         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1137         if (bytes(_tokenURI).length == 0) {
1138             return "";
1139         } else {
1140             // abi.encodePacked is being used to concatenate strings
1141             return string(abi.encodePacked(_baseURI, _tokenURI));
1142         }
1143     }
1144 
1145     /**
1146      * @dev Internal function to set the token URI for a given token.
1147      *
1148      * Reverts if the token ID does not exist.
1149      *
1150      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1151      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1152      * it and save gas.
1153      */
1154     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1155         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1156         _tokenURIs[tokenId] = _tokenURI;
1157     }
1158 
1159     /**
1160      * @dev Internal function to set the base URI for all token IDs. It is
1161      * automatically added as a prefix to the value returned in {tokenURI}.
1162      *
1163      * _Available since v2.5.0._
1164      */
1165     function _setBaseURI(string memory baseURI) internal {
1166         _baseURI = baseURI;
1167     }
1168 
1169     /**
1170     * @dev Returns the base URI set via {_setBaseURI}. This will be
1171     * automatically added as a preffix in {tokenURI} to each token's URI, when
1172     * they are non-empty.
1173     *
1174     * _Available since v2.5.0._
1175     */
1176     function baseURI() external view returns (string memory) {
1177         return _baseURI;
1178     }
1179 
1180     /**
1181      * @dev Internal function to burn a specific token.
1182      * Reverts if the token does not exist.
1183      * Deprecated, use _burn(uint256) instead.
1184      * @param owner owner of the token to burn
1185      * @param tokenId uint256 ID of the token being burned by the msg.sender
1186      */
1187     function _burn(address owner, uint256 tokenId) internal {
1188         super._burn(owner, tokenId);
1189 
1190         // Clear metadata (if any)
1191         if (bytes(_tokenURIs[tokenId]).length != 0) {
1192             delete _tokenURIs[tokenId];
1193         }
1194     }
1195 }
1196 
1197 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1198 
1199 pragma solidity ^0.5.0;
1200 
1201 
1202 
1203 
1204 /**
1205  * @title Full ERC721 Token
1206  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1207  * Moreover, it includes approve all functionality using operator terminology.
1208  *
1209  * See https://eips.ethereum.org/EIPS/eip-721
1210  */
1211 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1212     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1213         // solhint-disable-previous-line no-empty-blocks
1214     }
1215 }
1216 
1217 // File: @openzeppelin/contracts/access/Roles.sol
1218 
1219 pragma solidity ^0.5.0;
1220 
1221 /**
1222  * @title Roles
1223  * @dev Library for managing addresses assigned to a Role.
1224  */
1225 library Roles {
1226     struct Role {
1227         mapping (address => bool) bearer;
1228     }
1229 
1230     /**
1231      * @dev Give an account access to this role.
1232      */
1233     function add(Role storage role, address account) internal {
1234         require(!has(role, account), "Roles: account already has role");
1235         role.bearer[account] = true;
1236     }
1237 
1238     /**
1239      * @dev Remove an account's access to this role.
1240      */
1241     function remove(Role storage role, address account) internal {
1242         require(has(role, account), "Roles: account does not have role");
1243         role.bearer[account] = false;
1244     }
1245 
1246     /**
1247      * @dev Check if an account has this role.
1248      * @return bool
1249      */
1250     function has(Role storage role, address account) internal view returns (bool) {
1251         require(account != address(0), "Roles: account is the zero address");
1252         return role.bearer[account];
1253     }
1254 }
1255 
1256 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
1257 
1258 pragma solidity ^0.5.0;
1259 
1260 
1261 
1262 contract MinterRole is Context {
1263     using Roles for Roles.Role;
1264 
1265     event MinterAdded(address indexed account);
1266     event MinterRemoved(address indexed account);
1267 
1268     Roles.Role private _minters;
1269 
1270     constructor () internal {
1271         _addMinter(_msgSender());
1272     }
1273 
1274     modifier onlyMinter() {
1275         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1276         _;
1277     }
1278 
1279     function isMinter(address account) public view returns (bool) {
1280         return _minters.has(account);
1281     }
1282 
1283     function addMinter(address account) public onlyMinter {
1284         _addMinter(account);
1285     }
1286 
1287     function renounceMinter() public {
1288         _removeMinter(_msgSender());
1289     }
1290 
1291     function _addMinter(address account) internal {
1292         _minters.add(account);
1293         emit MinterAdded(account);
1294     }
1295 
1296     function _removeMinter(address account) internal {
1297         _minters.remove(account);
1298         emit MinterRemoved(account);
1299     }
1300 }
1301 
1302 // File: @openzeppelin/contracts/token/ERC721/ERC721Mintable.sol
1303 
1304 pragma solidity ^0.5.0;
1305 
1306 
1307 
1308 /**
1309  * @title ERC721Mintable
1310  * @dev ERC721 minting logic.
1311  */
1312 contract ERC721Mintable is ERC721, MinterRole {
1313     /**
1314      * @dev Function to mint tokens.
1315      * @param to The address that will receive the minted token.
1316      * @param tokenId The token id to mint.
1317      * @return A boolean that indicates if the operation was successful.
1318      */
1319     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1320         _mint(to, tokenId);
1321         return true;
1322     }
1323 
1324     /**
1325      * @dev Function to safely mint tokens.
1326      * @param to The address that will receive the minted token.
1327      * @param tokenId The token id to mint.
1328      * @return A boolean that indicates if the operation was successful.
1329      */
1330     function safeMint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1331         _safeMint(to, tokenId);
1332         return true;
1333     }
1334 
1335     /**
1336      * @dev Function to safely mint tokens.
1337      * @param to The address that will receive the minted token.
1338      * @param tokenId The token id to mint.
1339      * @param _data bytes data to send along with a safe transfer check.
1340      * @return A boolean that indicates if the operation was successful.
1341      */
1342     function safeMint(address to, uint256 tokenId, bytes memory _data) public onlyMinter returns (bool) {
1343         _safeMint(to, tokenId, _data);
1344         return true;
1345     }
1346 }
1347 
1348 // File: @openzeppelin/contracts/token/ERC721/ERC721MetadataMintable.sol
1349 
1350 pragma solidity ^0.5.0;
1351 
1352 
1353 
1354 
1355 /**
1356  * @title ERC721MetadataMintable
1357  * @dev ERC721 minting logic with metadata.
1358  */
1359 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
1360     /**
1361      * @dev Function to mint tokens.
1362      * @param to The address that will receive the minted tokens.
1363      * @param tokenId The token id to mint.
1364      * @param tokenURI The token URI of the minted token.
1365      * @return A boolean that indicates if the operation was successful.
1366      */
1367     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
1368         _mint(to, tokenId);
1369         _setTokenURI(tokenId, tokenURI);
1370         return true;
1371     }
1372 }
1373 
1374 // File: @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol
1375 
1376 pragma solidity ^0.5.0;
1377 
1378 
1379 
1380 /**
1381  * @title ERC721 Burnable Token
1382  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1383  */
1384 contract ERC721Burnable is Context, ERC721 {
1385     /**
1386      * @dev Burns a specific ERC721 token.
1387      * @param tokenId uint256 id of the ERC721 token to be burned.
1388      */
1389     function burn(uint256 tokenId) public {
1390         //solhint-disable-next-line max-line-length
1391         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1392         _burn(tokenId);
1393     }
1394 }
1395 
1396 // File: @openzeppelin/contracts/ownership/Ownable.sol
1397 
1398 pragma solidity ^0.5.0;
1399 
1400 /**
1401  * @dev Contract module which provides a basic access control mechanism, where
1402  * there is an account (an owner) that can be granted exclusive access to
1403  * specific functions.
1404  *
1405  * This module is used through inheritance. It will make available the modifier
1406  * `onlyOwner`, which can be applied to your functions to restrict their use to
1407  * the owner.
1408  */
1409 contract Ownable is Context {
1410     address private _owner;
1411 
1412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1413 
1414     /**
1415      * @dev Initializes the contract setting the deployer as the initial owner.
1416      */
1417     constructor () internal {
1418         address msgSender = _msgSender();
1419         _owner = msgSender;
1420         emit OwnershipTransferred(address(0), msgSender);
1421     }
1422 
1423     /**
1424      * @dev Returns the address of the current owner.
1425      */
1426     function owner() public view returns (address) {
1427         return _owner;
1428     }
1429 
1430     /**
1431      * @dev Throws if called by any account other than the owner.
1432      */
1433     modifier onlyOwner() {
1434         require(isOwner(), "Ownable: caller is not the owner");
1435         _;
1436     }
1437 
1438     /**
1439      * @dev Returns true if the caller is the current owner.
1440      */
1441     function isOwner() public view returns (bool) {
1442         return _msgSender() == _owner;
1443     }
1444 
1445     /**
1446      * @dev Leaves the contract without owner. It will not be possible to call
1447      * `onlyOwner` functions anymore. Can only be called by the current owner.
1448      *
1449      * NOTE: Renouncing ownership will leave the contract without an owner,
1450      * thereby removing any functionality that is only available to the owner.
1451      */
1452     function renounceOwnership() public onlyOwner {
1453         emit OwnershipTransferred(_owner, address(0));
1454         _owner = address(0);
1455     }
1456 
1457     /**
1458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1459      * Can only be called by the current owner.
1460      */
1461     function transferOwnership(address newOwner) public onlyOwner {
1462         _transferOwnership(newOwner);
1463     }
1464 
1465     /**
1466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1467      */
1468     function _transferOwnership(address newOwner) internal {
1469         require(newOwner != address(0), "Ownable: new owner is the zero address");
1470         emit OwnershipTransferred(_owner, newOwner);
1471         _owner = newOwner;
1472     }
1473 }
1474 
1475 // File: contracts/dozerDoll/DozerDollV3.sol
1476 
1477 pragma solidity >=0.5.0 <0.6.0;
1478 
1479 
1480 
1481 
1482 
1483 
1484 
1485 
1486 contract DozerDollV3 is ERC721Full, ERC721Mintable, ERC721MetadataMintable, ERC721Burnable, Ownable {
1487   using SafeMath for uint256;
1488   uint256 internal tokenId = 1;
1489 
1490   event DollBurn(address _to, uint256 tokenId);
1491 
1492   constructor (
1493     string memory _name,
1494     string memory _symbol,
1495     string memory _baseURI
1496   )
1497     ERC721Mintable()
1498     ERC721Full(_name, _symbol) public {
1499     _setBaseURI(_baseURI);
1500   }
1501 
1502 
1503   function dollMint (
1504     address _to
1505   ) public {
1506       _mint(_to, tokenId);
1507       _setTokenURI(tokenId, uint2str(tokenId));
1508 
1509       tokenId = tokenId.add(1);
1510   }
1511 
1512 
1513   function dollMintMultiple (
1514     address[] memory _to
1515   ) public {
1516     for (uint256 i = 0 ; i < _to.length; i++) {
1517       dollMint(_to[i]);
1518     }
1519   }
1520 
1521 
1522   function dollBurn (
1523     uint256 _tokenId
1524   ) public {
1525     burn(_tokenId);
1526 
1527     emit DollBurn(msg.sender, _tokenId);
1528   }
1529 
1530 
1531   function dollBurnMultiple (
1532     uint256[] memory _tokenId
1533   ) public {
1534     for (uint256 i = 0 ; i < _tokenId.length; i++) {
1535       dollBurn(_tokenId[i]);
1536     }
1537   }
1538 
1539 
1540   function transfer (
1541     address _to,
1542     uint256 _tokenId
1543   ) public {
1544     safeTransferFrom(msg.sender, _to, _tokenId);
1545   }
1546 
1547 
1548   function transferMultiple (
1549     address _to,
1550     uint256[] memory _tokenId
1551   ) public {
1552     for (uint i = 0; i < _tokenId.length; i++) {
1553       safeTransferFrom(msg.sender, _to, _tokenId[i]);
1554     }
1555   }
1556 
1557 
1558   function setBaseURI (
1559     string memory _baseURI
1560   ) public onlyOwner {
1561     _setBaseURI(_baseURI);
1562   }
1563 
1564   function uint2str (
1565     uint _i
1566   ) internal pure returns (string memory _uintAsString) {
1567     if (_i == 0) {
1568         return "0";
1569     }
1570     uint j = _i;
1571     uint len;
1572     while (j != 0) {
1573         len++;
1574         j /= 10;
1575     }
1576     bytes memory bstr = new bytes(len);
1577     uint k = len - 1;
1578     while (_i != 0) {
1579         bstr[k--] = byte(uint8(48 + _i % 10));
1580         _i /= 10;
1581     }
1582     return string(bstr);
1583   }
1584 }