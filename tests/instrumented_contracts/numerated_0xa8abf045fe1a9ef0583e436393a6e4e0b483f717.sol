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
31 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
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
56 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
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
111 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
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
139 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
298 // File: openzeppelin-solidity/contracts/utils/Address.sol
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
309      * This test is non-exhaustive, and there may be false-negatives: during the
310      * execution of a contract's constructor, its address will be reported as
311      * not containing a contract.
312      *
313      * IMPORTANT: It is unsafe to assume that an address for which this
314      * function returns false is an externally-owned account (EOA) and not a
315      * contract.
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies in extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
323         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
324         // for accounts without code, i.e. `keccak256('')`
325         bytes32 codehash;
326         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
327         // solhint-disable-next-line no-inline-assembly
328         assembly { codehash := extcodehash(account) }
329         return (codehash != 0x0 && codehash != accountHash);
330     }
331 
332     /**
333      * @dev Converts an `address` into `address payable`. Note that this is
334      * simply a type cast: the actual underlying value is not changed.
335      *
336      * _Available since v2.4.0._
337      */
338     function toPayable(address account) internal pure returns (address payable) {
339         return address(uint160(account));
340     }
341 
342     /**
343      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
344      * `recipient`, forwarding all available gas and reverting on errors.
345      *
346      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
347      * of certain opcodes, possibly making contracts go over the 2300 gas limit
348      * imposed by `transfer`, making them unable to receive funds via
349      * `transfer`. {sendValue} removes this limitation.
350      *
351      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
352      *
353      * IMPORTANT: because control is transferred to `recipient`, care must be
354      * taken to not create reentrancy vulnerabilities. Consider using
355      * {ReentrancyGuard} or the
356      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
357      *
358      * _Available since v2.4.0._
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         // solhint-disable-next-line avoid-call-value
364         (bool success, ) = recipient.call.value(amount)("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 }
368 
369 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
370 
371 pragma solidity ^0.5.0;
372 
373 
374 /**
375  * @title Counters
376  * @author Matt Condon (@shrugs)
377  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
378  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
379  *
380  * Include with `using Counters for Counters.Counter;`
381  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
382  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
383  * directly accessed.
384  */
385 library Counters {
386     using SafeMath for uint256;
387 
388     struct Counter {
389         // This variable should never be directly accessed by users of the library: interactions must be restricted to
390         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
391         // this feature: see https://github.com/ethereum/solidity/issues/4637
392         uint256 _value; // default: 0
393     }
394 
395     function current(Counter storage counter) internal view returns (uint256) {
396         return counter._value;
397     }
398 
399     function increment(Counter storage counter) internal {
400         counter._value += 1;
401     }
402 
403     function decrement(Counter storage counter) internal {
404         counter._value = counter._value.sub(1);
405     }
406 }
407 
408 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
409 
410 pragma solidity ^0.5.0;
411 
412 
413 /**
414  * @dev Implementation of the {IERC165} interface.
415  *
416  * Contracts may inherit from this and call {_registerInterface} to declare
417  * their support of an interface.
418  */
419 contract ERC165 is IERC165 {
420     /*
421      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
422      */
423     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
424 
425     /**
426      * @dev Mapping of interface ids to whether or not it's supported.
427      */
428     mapping(bytes4 => bool) private _supportedInterfaces;
429 
430     constructor () internal {
431         // Derived contracts need only register support for their own interfaces,
432         // we register support for ERC165 itself here
433         _registerInterface(_INTERFACE_ID_ERC165);
434     }
435 
436     /**
437      * @dev See {IERC165-supportsInterface}.
438      *
439      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
442         return _supportedInterfaces[interfaceId];
443     }
444 
445     /**
446      * @dev Registers the contract as an implementer of the interface defined by
447      * `interfaceId`. Support of the actual ERC165 interface is automatic and
448      * registering its interface id is not required.
449      *
450      * See {IERC165-supportsInterface}.
451      *
452      * Requirements:
453      *
454      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
455      */
456     function _registerInterface(bytes4 interfaceId) internal {
457         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
458         _supportedInterfaces[interfaceId] = true;
459     }
460 }
461 
462 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
463 
464 pragma solidity ^0.5.0;
465 
466 
467 
468 
469 
470 
471 
472 
473 /**
474  * @title ERC721 Non-Fungible Token Standard basic implementation
475  * @dev see https://eips.ethereum.org/EIPS/eip-721
476  */
477 contract ERC721 is Context, ERC165, IERC721 {
478     using SafeMath for uint256;
479     using Address for address;
480     using Counters for Counters.Counter;
481 
482     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
483     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
484     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
485 
486     // Mapping from token ID to owner
487     mapping (uint256 => address) private _tokenOwner;
488 
489     // Mapping from token ID to approved address
490     mapping (uint256 => address) private _tokenApprovals;
491 
492     // Mapping from owner to number of owned token
493     mapping (address => Counters.Counter) private _ownedTokensCount;
494 
495     // Mapping from owner to operator approvals
496     mapping (address => mapping (address => bool)) private _operatorApprovals;
497 
498     /*
499      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
500      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
501      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
502      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
503      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
504      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
505      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
506      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
507      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
508      *
509      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
510      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
511      */
512     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
513 
514     constructor () public {
515         // register the supported interfaces to conform to ERC721 via ERC165
516         _registerInterface(_INTERFACE_ID_ERC721);
517     }
518 
519     /**
520      * @dev Gets the balance of the specified address.
521      * @param owner address to query the balance of
522      * @return uint256 representing the amount owned by the passed address
523      */
524     function balanceOf(address owner) public view returns (uint256) {
525         require(owner != address(0), "ERC721: balance query for the zero address");
526 
527         return _ownedTokensCount[owner].current();
528     }
529 
530     /**
531      * @dev Gets the owner of the specified token ID.
532      * @param tokenId uint256 ID of the token to query the owner of
533      * @return address currently marked as the owner of the given token ID
534      */
535     function ownerOf(uint256 tokenId) public view returns (address) {
536         address owner = _tokenOwner[tokenId];
537         require(owner != address(0), "ERC721: owner query for nonexistent token");
538 
539         return owner;
540     }
541 
542     /**
543      * @dev Approves another address to transfer the given token ID
544      * The zero address indicates there is no approved address.
545      * There can only be one approved address per token at a given time.
546      * Can only be called by the token owner or an approved operator.
547      * @param to address to be approved for the given token ID
548      * @param tokenId uint256 ID of the token to be approved
549      */
550     function approve(address to, uint256 tokenId) public {
551         address owner = ownerOf(tokenId);
552         require(to != owner, "ERC721: approval to current owner");
553 
554         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
555             "ERC721: approve caller is not owner nor approved for all"
556         );
557 
558         _tokenApprovals[tokenId] = to;
559         emit Approval(owner, to, tokenId);
560     }
561 
562     /**
563      * @dev Gets the approved address for a token ID, or zero if no address set
564      * Reverts if the token ID does not exist.
565      * @param tokenId uint256 ID of the token to query the approval of
566      * @return address currently approved for the given token ID
567      */
568     function getApproved(uint256 tokenId) public view returns (address) {
569         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
570 
571         return _tokenApprovals[tokenId];
572     }
573 
574     /**
575      * @dev Sets or unsets the approval of a given operator
576      * An operator is allowed to transfer all tokens of the sender on their behalf.
577      * @param to operator address to set the approval
578      * @param approved representing the status of the approval to be set
579      */
580     function setApprovalForAll(address to, bool approved) public {
581         require(to != _msgSender(), "ERC721: approve to caller");
582 
583         _operatorApprovals[_msgSender()][to] = approved;
584         emit ApprovalForAll(_msgSender(), to, approved);
585     }
586 
587     /**
588      * @dev Tells whether an operator is approved by a given owner.
589      * @param owner owner address which you want to query the approval of
590      * @param operator operator address which you want to query the approval of
591      * @return bool whether the given operator is approved by the given owner
592      */
593     function isApprovedForAll(address owner, address operator) public view returns (bool) {
594         return _operatorApprovals[owner][operator];
595     }
596 
597     /**
598      * @dev Transfers the ownership of a given token ID to another address.
599      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      * Requires the msg.sender to be the owner, approved, or operator.
601      * @param from current owner of the token
602      * @param to address to receive the ownership of the given token ID
603      * @param tokenId uint256 ID of the token to be transferred
604      */
605     function transferFrom(address from, address to, uint256 tokenId) public {
606         //solhint-disable-next-line max-line-length
607         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
608 
609         _transferFrom(from, to, tokenId);
610     }
611 
612     /**
613      * @dev Safely transfers the ownership of a given token ID to another address
614      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
615      * which is called upon a safe transfer, and return the magic value
616      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
617      * the transfer is reverted.
618      * Requires the msg.sender to be the owner, approved, or operator
619      * @param from current owner of the token
620      * @param to address to receive the ownership of the given token ID
621      * @param tokenId uint256 ID of the token to be transferred
622      */
623     function safeTransferFrom(address from, address to, uint256 tokenId) public {
624         safeTransferFrom(from, to, tokenId, "");
625     }
626 
627     /**
628      * @dev Safely transfers the ownership of a given token ID to another address
629      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
630      * which is called upon a safe transfer, and return the magic value
631      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
632      * the transfer is reverted.
633      * Requires the _msgSender() to be the owner, approved, or operator
634      * @param from current owner of the token
635      * @param to address to receive the ownership of the given token ID
636      * @param tokenId uint256 ID of the token to be transferred
637      * @param _data bytes data to send along with a safe transfer check
638      */
639     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
640         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
641         _safeTransferFrom(from, to, tokenId, _data);
642     }
643 
644     /**
645      * @dev Safely transfers the ownership of a given token ID to another address
646      * If the target address is a contract, it must implement `onERC721Received`,
647      * which is called upon a safe transfer, and return the magic value
648      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
649      * the transfer is reverted.
650      * Requires the msg.sender to be the owner, approved, or operator
651      * @param from current owner of the token
652      * @param to address to receive the ownership of the given token ID
653      * @param tokenId uint256 ID of the token to be transferred
654      * @param _data bytes data to send along with a safe transfer check
655      */
656     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
657         _transferFrom(from, to, tokenId);
658         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
659     }
660 
661     /**
662      * @dev Returns whether the specified token exists.
663      * @param tokenId uint256 ID of the token to query the existence of
664      * @return bool whether the token exists
665      */
666     function _exists(uint256 tokenId) internal view returns (bool) {
667         address owner = _tokenOwner[tokenId];
668         return owner != address(0);
669     }
670 
671     /**
672      * @dev Returns whether the given spender can transfer a given token ID.
673      * @param spender address of the spender to query
674      * @param tokenId uint256 ID of the token to be transferred
675      * @return bool whether the msg.sender is approved for the given token ID,
676      * is an operator of the owner, or is the owner of the token
677      */
678     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
679         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
680         address owner = ownerOf(tokenId);
681         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
682     }
683 
684     /**
685      * @dev Internal function to safely mint a new token.
686      * Reverts if the given token ID already exists.
687      * If the target address is a contract, it must implement `onERC721Received`,
688      * which is called upon a safe transfer, and return the magic value
689      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
690      * the transfer is reverted.
691      * @param to The address that will own the minted token
692      * @param tokenId uint256 ID of the token to be minted
693      */
694     function _safeMint(address to, uint256 tokenId) internal {
695         _safeMint(to, tokenId, "");
696     }
697 
698     /**
699      * @dev Internal function to safely mint a new token.
700      * Reverts if the given token ID already exists.
701      * If the target address is a contract, it must implement `onERC721Received`,
702      * which is called upon a safe transfer, and return the magic value
703      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
704      * the transfer is reverted.
705      * @param to The address that will own the minted token
706      * @param tokenId uint256 ID of the token to be minted
707      * @param _data bytes data to send along with a safe transfer check
708      */
709     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
710         _mint(to, tokenId);
711         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
712     }
713 
714     /**
715      * @dev Internal function to mint a new token.
716      * Reverts if the given token ID already exists.
717      * @param to The address that will own the minted token
718      * @param tokenId uint256 ID of the token to be minted
719      */
720     function _mint(address to, uint256 tokenId) internal {
721         require(to != address(0), "ERC721: mint to the zero address");
722         require(!_exists(tokenId), "ERC721: token already minted");
723 
724         _tokenOwner[tokenId] = to;
725         _ownedTokensCount[to].increment();
726 
727         emit Transfer(address(0), to, tokenId);
728     }
729 
730     /**
731      * @dev Internal function to burn a specific token.
732      * Reverts if the token does not exist.
733      * Deprecated, use {_burn} instead.
734      * @param owner owner of the token to burn
735      * @param tokenId uint256 ID of the token being burned
736      */
737     function _burn(address owner, uint256 tokenId) internal {
738         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
739 
740         _clearApproval(tokenId);
741 
742         _ownedTokensCount[owner].decrement();
743         _tokenOwner[tokenId] = address(0);
744 
745         emit Transfer(owner, address(0), tokenId);
746     }
747 
748     /**
749      * @dev Internal function to burn a specific token.
750      * Reverts if the token does not exist.
751      * @param tokenId uint256 ID of the token being burned
752      */
753     function _burn(uint256 tokenId) internal {
754         _burn(ownerOf(tokenId), tokenId);
755     }
756 
757     /**
758      * @dev Internal function to transfer ownership of a given token ID to another address.
759      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
760      * @param from current owner of the token
761      * @param to address to receive the ownership of the given token ID
762      * @param tokenId uint256 ID of the token to be transferred
763      */
764     function _transferFrom(address from, address to, uint256 tokenId) internal {
765         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
766         require(to != address(0), "ERC721: transfer to the zero address");
767 
768         _clearApproval(tokenId);
769 
770         _ownedTokensCount[from].decrement();
771         _ownedTokensCount[to].increment();
772 
773         _tokenOwner[tokenId] = to;
774 
775         emit Transfer(from, to, tokenId);
776     }
777 
778     /**
779      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
780      * The call is not executed if the target address is not a contract.
781      *
782      * This function is deprecated.
783      * @param from address representing the previous owner of the given token ID
784      * @param to target address that will receive the tokens
785      * @param tokenId uint256 ID of the token to be transferred
786      * @param _data bytes optional data to send along with the call
787      * @return bool whether the call correctly returned the expected magic value
788      */
789     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
790         internal returns (bool)
791     {
792         if (!to.isContract()) {
793             return true;
794         }
795 
796         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
797         return (retval == _ERC721_RECEIVED);
798     }
799 
800     /**
801      * @dev Private function to clear current approval of a given token ID.
802      * @param tokenId uint256 ID of the token to be transferred
803      */
804     function _clearApproval(uint256 tokenId) private {
805         if (_tokenApprovals[tokenId] != address(0)) {
806             _tokenApprovals[tokenId] = address(0);
807         }
808     }
809 }
810 
811 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
812 
813 pragma solidity ^0.5.0;
814 
815 
816 /**
817  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
818  * @dev See https://eips.ethereum.org/EIPS/eip-721
819  */
820 contract IERC721Enumerable is IERC721 {
821     function totalSupply() public view returns (uint256);
822     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
823 
824     function tokenByIndex(uint256 index) public view returns (uint256);
825 }
826 
827 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
828 
829 pragma solidity ^0.5.0;
830 
831 
832 
833 
834 
835 /**
836  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
837  * @dev See https://eips.ethereum.org/EIPS/eip-721
838  */
839 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
840     // Mapping from owner to list of owned token IDs
841     mapping(address => uint256[]) private _ownedTokens;
842 
843     // Mapping from token ID to index of the owner tokens list
844     mapping(uint256 => uint256) private _ownedTokensIndex;
845 
846     // Array with all token ids, used for enumeration
847     uint256[] private _allTokens;
848 
849     // Mapping from token id to position in the allTokens array
850     mapping(uint256 => uint256) private _allTokensIndex;
851 
852     /*
853      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
854      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
855      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
856      *
857      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
858      */
859     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
860 
861     /**
862      * @dev Constructor function.
863      */
864     constructor () public {
865         // register the supported interface to conform to ERC721Enumerable via ERC165
866         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
867     }
868 
869     /**
870      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
871      * @param owner address owning the tokens list to be accessed
872      * @param index uint256 representing the index to be accessed of the requested tokens list
873      * @return uint256 token ID at the given index of the tokens list owned by the requested address
874      */
875     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
876         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
877         return _ownedTokens[owner][index];
878     }
879 
880     /**
881      * @dev Gets the total amount of tokens stored by the contract.
882      * @return uint256 representing the total amount of tokens
883      */
884     function totalSupply() public view returns (uint256) {
885         return _allTokens.length;
886     }
887 
888     /**
889      * @dev Gets the token ID at a given index of all the tokens in this contract
890      * Reverts if the index is greater or equal to the total number of tokens.
891      * @param index uint256 representing the index to be accessed of the tokens list
892      * @return uint256 token ID at the given index of the tokens list
893      */
894     function tokenByIndex(uint256 index) public view returns (uint256) {
895         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
896         return _allTokens[index];
897     }
898 
899     /**
900      * @dev Internal function to transfer ownership of a given token ID to another address.
901      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
902      * @param from current owner of the token
903      * @param to address to receive the ownership of the given token ID
904      * @param tokenId uint256 ID of the token to be transferred
905      */
906     function _transferFrom(address from, address to, uint256 tokenId) internal {
907         super._transferFrom(from, to, tokenId);
908 
909         _removeTokenFromOwnerEnumeration(from, tokenId);
910 
911         _addTokenToOwnerEnumeration(to, tokenId);
912     }
913 
914     /**
915      * @dev Internal function to mint a new token.
916      * Reverts if the given token ID already exists.
917      * @param to address the beneficiary that will own the minted token
918      * @param tokenId uint256 ID of the token to be minted
919      */
920     function _mint(address to, uint256 tokenId) internal {
921         super._mint(to, tokenId);
922 
923         _addTokenToOwnerEnumeration(to, tokenId);
924 
925         _addTokenToAllTokensEnumeration(tokenId);
926     }
927 
928     /**
929      * @dev Internal function to burn a specific token.
930      * Reverts if the token does not exist.
931      * Deprecated, use {ERC721-_burn} instead.
932      * @param owner owner of the token to burn
933      * @param tokenId uint256 ID of the token being burned
934      */
935     function _burn(address owner, uint256 tokenId) internal {
936         super._burn(owner, tokenId);
937 
938         _removeTokenFromOwnerEnumeration(owner, tokenId);
939         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
940         _ownedTokensIndex[tokenId] = 0;
941 
942         _removeTokenFromAllTokensEnumeration(tokenId);
943     }
944 
945     /**
946      * @dev Gets the list of token IDs of the requested owner.
947      * @param owner address owning the tokens
948      * @return uint256[] List of token IDs owned by the requested address
949      */
950     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
951         return _ownedTokens[owner];
952     }
953 
954     /**
955      * @dev Private function to add a token to this extension's ownership-tracking data structures.
956      * @param to address representing the new owner of the given token ID
957      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
958      */
959     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
960         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
961         _ownedTokens[to].push(tokenId);
962     }
963 
964     /**
965      * @dev Private function to add a token to this extension's token tracking data structures.
966      * @param tokenId uint256 ID of the token to be added to the tokens list
967      */
968     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
969         _allTokensIndex[tokenId] = _allTokens.length;
970         _allTokens.push(tokenId);
971     }
972 
973     /**
974      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
975      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
976      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
977      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
978      * @param from address representing the previous owner of the given token ID
979      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
980      */
981     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
982         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
983         // then delete the last slot (swap and pop).
984 
985         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
986         uint256 tokenIndex = _ownedTokensIndex[tokenId];
987 
988         // When the token to delete is the last token, the swap operation is unnecessary
989         if (tokenIndex != lastTokenIndex) {
990             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
991 
992             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
993             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
994         }
995 
996         // This also deletes the contents at the last position of the array
997         _ownedTokens[from].length--;
998 
999         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1000         // lastTokenId, or just over the end of the array if the token was the last one).
1001     }
1002 
1003     /**
1004      * @dev Private function to remove a token from this extension's token tracking data structures.
1005      * This has O(1) time complexity, but alters the order of the _allTokens array.
1006      * @param tokenId uint256 ID of the token to be removed from the tokens list
1007      */
1008     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1009         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1010         // then delete the last slot (swap and pop).
1011 
1012         uint256 lastTokenIndex = _allTokens.length.sub(1);
1013         uint256 tokenIndex = _allTokensIndex[tokenId];
1014 
1015         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1016         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1017         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1018         uint256 lastTokenId = _allTokens[lastTokenIndex];
1019 
1020         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1021         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1022 
1023         // This also deletes the contents at the last position of the array
1024         _allTokens.length--;
1025         _allTokensIndex[tokenId] = 0;
1026     }
1027 }
1028 
1029 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
1030 
1031 pragma solidity ^0.5.0;
1032 
1033 
1034 /**
1035  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1036  * @dev See https://eips.ethereum.org/EIPS/eip-721
1037  */
1038 contract IERC721Metadata is IERC721 {
1039     function name() external view returns (string memory);
1040     function symbol() external view returns (string memory);
1041     function tokenURI(uint256 tokenId) external view returns (string memory);
1042 }
1043 
1044 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
1045 
1046 pragma solidity ^0.5.0;
1047 
1048 
1049 
1050 
1051 
1052 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1053     // Token name
1054     string private _name;
1055 
1056     // Token symbol
1057     string private _symbol;
1058 
1059     // Optional mapping for token URIs
1060     mapping(uint256 => string) private _tokenURIs;
1061 
1062     /*
1063      *     bytes4(keccak256('name()')) == 0x06fdde03
1064      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1065      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1066      *
1067      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1068      */
1069     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1070 
1071     /**
1072      * @dev Constructor function
1073      */
1074     constructor (string memory name, string memory symbol) public {
1075         _name = name;
1076         _symbol = symbol;
1077 
1078         // register the supported interfaces to conform to ERC721 via ERC165
1079         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1080     }
1081 
1082     /**
1083      * @dev Gets the token name.
1084      * @return string representing the token name
1085      */
1086     function name() external view returns (string memory) {
1087         return _name;
1088     }
1089 
1090     /**
1091      * @dev Gets the token symbol.
1092      * @return string representing the token symbol
1093      */
1094     function symbol() external view returns (string memory) {
1095         return _symbol;
1096     }
1097 
1098     /**
1099      * @dev Returns an URI for a given token ID.
1100      * Throws if the token ID does not exist. May return an empty string.
1101      * @param tokenId uint256 ID of the token to query
1102      */
1103     function tokenURI(uint256 tokenId) external view returns (string memory) {
1104         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1105         return _tokenURIs[tokenId];
1106     }
1107 
1108     /**
1109      * @dev Internal function to set the token URI for a given token.
1110      * Reverts if the token ID does not exist.
1111      * @param tokenId uint256 ID of the token to set its URI
1112      * @param uri string URI to assign
1113      */
1114     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1115         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1116         _tokenURIs[tokenId] = uri;
1117     }
1118 
1119     /**
1120      * @dev Internal function to burn a specific token.
1121      * Reverts if the token does not exist.
1122      * Deprecated, use _burn(uint256) instead.
1123      * @param owner owner of the token to burn
1124      * @param tokenId uint256 ID of the token being burned by the msg.sender
1125      */
1126     function _burn(address owner, uint256 tokenId) internal {
1127         super._burn(owner, tokenId);
1128 
1129         // Clear metadata (if any)
1130         if (bytes(_tokenURIs[tokenId]).length != 0) {
1131             delete _tokenURIs[tokenId];
1132         }
1133     }
1134 }
1135 
1136 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
1137 
1138 pragma solidity ^0.5.0;
1139 
1140 
1141 
1142 
1143 /**
1144  * @title Full ERC721 Token
1145  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1146  * Moreover, it includes approve all functionality using operator terminology.
1147  *
1148  * See https://eips.ethereum.org/EIPS/eip-721
1149  */
1150 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1151     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1152         // solhint-disable-previous-line no-empty-blocks
1153     }
1154 }
1155 
1156 // File: openzeppelin-solidity/contracts/access/Roles.sol
1157 
1158 pragma solidity ^0.5.0;
1159 
1160 /**
1161  * @title Roles
1162  * @dev Library for managing addresses assigned to a Role.
1163  */
1164 library Roles {
1165     struct Role {
1166         mapping (address => bool) bearer;
1167     }
1168 
1169     /**
1170      * @dev Give an account access to this role.
1171      */
1172     function add(Role storage role, address account) internal {
1173         require(!has(role, account), "Roles: account already has role");
1174         role.bearer[account] = true;
1175     }
1176 
1177     /**
1178      * @dev Remove an account's access to this role.
1179      */
1180     function remove(Role storage role, address account) internal {
1181         require(has(role, account), "Roles: account does not have role");
1182         role.bearer[account] = false;
1183     }
1184 
1185     /**
1186      * @dev Check if an account has this role.
1187      * @return bool
1188      */
1189     function has(Role storage role, address account) internal view returns (bool) {
1190         require(account != address(0), "Roles: account is the zero address");
1191         return role.bearer[account];
1192     }
1193 }
1194 
1195 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1196 
1197 pragma solidity ^0.5.0;
1198 
1199 
1200 
1201 contract MinterRole is Context {
1202     using Roles for Roles.Role;
1203 
1204     event MinterAdded(address indexed account);
1205     event MinterRemoved(address indexed account);
1206 
1207     Roles.Role private _minters;
1208 
1209     constructor () internal {
1210         _addMinter(_msgSender());
1211     }
1212 
1213     modifier onlyMinter() {
1214         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1215         _;
1216     }
1217 
1218     function isMinter(address account) public view returns (bool) {
1219         return _minters.has(account);
1220     }
1221 
1222     function addMinter(address account) public onlyMinter {
1223         _addMinter(account);
1224     }
1225 
1226     function renounceMinter() public {
1227         _removeMinter(_msgSender());
1228     }
1229 
1230     function _addMinter(address account) internal {
1231         _minters.add(account);
1232         emit MinterAdded(account);
1233     }
1234 
1235     function _removeMinter(address account) internal {
1236         _minters.remove(account);
1237         emit MinterRemoved(account);
1238     }
1239 }
1240 
1241 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
1242 
1243 pragma solidity ^0.5.0;
1244 
1245 
1246 
1247 /**
1248  * @title ERC721Mintable
1249  * @dev ERC721 minting logic.
1250  */
1251 contract ERC721Mintable is ERC721, MinterRole {
1252     /**
1253      * @dev Function to mint tokens.
1254      * @param to The address that will receive the minted token.
1255      * @param tokenId The token id to mint.
1256      * @return A boolean that indicates if the operation was successful.
1257      */
1258     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1259         _mint(to, tokenId);
1260         return true;
1261     }
1262 
1263     /**
1264      * @dev Function to safely mint tokens.
1265      * @param to The address that will receive the minted token.
1266      * @param tokenId The token id to mint.
1267      * @return A boolean that indicates if the operation was successful.
1268      */
1269     function safeMint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1270         _safeMint(to, tokenId);
1271         return true;
1272     }
1273 
1274     /**
1275      * @dev Function to safely mint tokens.
1276      * @param to The address that will receive the minted token.
1277      * @param tokenId The token id to mint.
1278      * @param _data bytes data to send along with a safe transfer check.
1279      * @return A boolean that indicates if the operation was successful.
1280      */
1281     function safeMint(address to, uint256 tokenId, bytes memory _data) public onlyMinter returns (bool) {
1282         _safeMint(to, tokenId, _data);
1283         return true;
1284     }
1285 }
1286 
1287 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
1288 
1289 pragma solidity ^0.5.0;
1290 
1291 
1292 
1293 contract PauserRole is Context {
1294     using Roles for Roles.Role;
1295 
1296     event PauserAdded(address indexed account);
1297     event PauserRemoved(address indexed account);
1298 
1299     Roles.Role private _pausers;
1300 
1301     constructor () internal {
1302         _addPauser(_msgSender());
1303     }
1304 
1305     modifier onlyPauser() {
1306         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
1307         _;
1308     }
1309 
1310     function isPauser(address account) public view returns (bool) {
1311         return _pausers.has(account);
1312     }
1313 
1314     function addPauser(address account) public onlyPauser {
1315         _addPauser(account);
1316     }
1317 
1318     function renouncePauser() public {
1319         _removePauser(_msgSender());
1320     }
1321 
1322     function _addPauser(address account) internal {
1323         _pausers.add(account);
1324         emit PauserAdded(account);
1325     }
1326 
1327     function _removePauser(address account) internal {
1328         _pausers.remove(account);
1329         emit PauserRemoved(account);
1330     }
1331 }
1332 
1333 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1334 
1335 pragma solidity ^0.5.0;
1336 
1337 
1338 
1339 /**
1340  * @dev Contract module which allows children to implement an emergency stop
1341  * mechanism that can be triggered by an authorized account.
1342  *
1343  * This module is used through inheritance. It will make available the
1344  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1345  * the functions of your contract. Note that they will not be pausable by
1346  * simply including this module, only once the modifiers are put in place.
1347  */
1348 contract Pausable is Context, PauserRole {
1349     /**
1350      * @dev Emitted when the pause is triggered by a pauser (`account`).
1351      */
1352     event Paused(address account);
1353 
1354     /**
1355      * @dev Emitted when the pause is lifted by a pauser (`account`).
1356      */
1357     event Unpaused(address account);
1358 
1359     bool private _paused;
1360 
1361     /**
1362      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1363      * to the deployer.
1364      */
1365     constructor () internal {
1366         _paused = false;
1367     }
1368 
1369     /**
1370      * @dev Returns true if the contract is paused, and false otherwise.
1371      */
1372     function paused() public view returns (bool) {
1373         return _paused;
1374     }
1375 
1376     /**
1377      * @dev Modifier to make a function callable only when the contract is not paused.
1378      */
1379     modifier whenNotPaused() {
1380         require(!_paused, "Pausable: paused");
1381         _;
1382     }
1383 
1384     /**
1385      * @dev Modifier to make a function callable only when the contract is paused.
1386      */
1387     modifier whenPaused() {
1388         require(_paused, "Pausable: not paused");
1389         _;
1390     }
1391 
1392     /**
1393      * @dev Called by a pauser to pause, triggers stopped state.
1394      */
1395     function pause() public onlyPauser whenNotPaused {
1396         _paused = true;
1397         emit Paused(_msgSender());
1398     }
1399 
1400     /**
1401      * @dev Called by a pauser to unpause, returns to normal state.
1402      */
1403     function unpause() public onlyPauser whenPaused {
1404         _paused = false;
1405         emit Unpaused(_msgSender());
1406     }
1407 }
1408 
1409 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Pausable.sol
1410 
1411 pragma solidity ^0.5.0;
1412 
1413 
1414 
1415 /**
1416  * @title ERC721 Non-Fungible Pausable token
1417  * @dev ERC721 modified with pausable transfers.
1418  */
1419 contract ERC721Pausable is ERC721, Pausable {
1420     function approve(address to, uint256 tokenId) public whenNotPaused {
1421         super.approve(to, tokenId);
1422     }
1423 
1424     function setApprovalForAll(address to, bool approved) public whenNotPaused {
1425         super.setApprovalForAll(to, approved);
1426     }
1427 
1428     function _transferFrom(address from, address to, uint256 tokenId) internal whenNotPaused {
1429         super._transferFrom(from, to, tokenId);
1430     }
1431 }
1432 
1433 // File: contracts/GuildAsset.sol
1434 
1435 pragma solidity ^0.5.5;
1436 
1437 
1438 
1439 
1440 contract GuildAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
1441 
1442     uint16 public constant GUILD_TYPE_OFFSET = 10000;
1443     uint16 public constant GUILD_RARITY_OFFSET = 1000;
1444     uint256 public constant SHARE_RATE_DECIMAL = 10**18;
1445 
1446     uint16 public constant LEGENDARY_RARITY = 3;
1447     uint16 public constant GOLD_RARITY = 2;
1448     uint16 public constant SILVER_RARITY = 1;
1449 
1450     uint16 public constant NO_GUILD = 0;
1451 
1452     string public tokenURIPrefix = "https://cryptospells.jp/metadata/guild/";
1453 
1454     mapping(uint16 => uint256) private guildTypeToTotalVolume;
1455     mapping(uint16 => uint256) private guildTypeToStockSupplyLimit;
1456     mapping(uint16 => mapping(uint16 => uint256)) private guildTypeAndRarityToStockSupply;
1457     mapping(uint16 => uint256[]) private guildTypeToGuildStockList;
1458     mapping(uint16 => uint256) private guildTypeToGuildStockIndex;
1459     mapping(uint16 => mapping(uint16 => uint256)) private guildTypeAndRarityToGuildStockCount;
1460     mapping(uint16 => uint256) private rarityToStockVolume;
1461 
1462     // ロックアップ期間用変数
1463     //mapping(uint256 => bool) private allowed;
1464 
1465     constructor() ERC721Full("CryptoSpells:Guild", "CSPL") public {
1466       rarityToStockVolume[LEGENDARY_RARITY] = 100;
1467       rarityToStockVolume[GOLD_RARITY] = 10;
1468       rarityToStockVolume[SILVER_RARITY] = 1;
1469       guildTypeToTotalVolume[NO_GUILD] = 0;
1470     }
1471 
1472     function setSupplyAndStock(
1473       uint16 _guildType, // 3桁。ギルドごと１つ
1474       uint256 _totalVolume,
1475       uint256 _stockSupplyLimit,
1476       uint256 legendarySupply,
1477       uint256 goldSupply,
1478       uint256 silverSupply
1479     ) external onlyMinter {
1480       require(_guildType != 0, "guildType 0 is noguild");
1481       require(_totalVolume != 0, "totalVolume must not be 0");
1482       //require(getMintedStockCount(_guildType) == 0, "This GuildType already exists");
1483       require(
1484         legendarySupply.mul(rarityToStockVolume[LEGENDARY_RARITY])
1485         .add(goldSupply.mul(rarityToStockVolume[GOLD_RARITY]))
1486         .add(silverSupply.mul(rarityToStockVolume[SILVER_RARITY]))
1487         == _totalVolume
1488       );
1489       require(
1490         legendarySupply
1491         .add(goldSupply)
1492         .add(silverSupply)
1493         == _stockSupplyLimit
1494       );
1495       guildTypeToTotalVolume[_guildType] = _totalVolume;
1496       guildTypeToStockSupplyLimit[_guildType] = _stockSupplyLimit;
1497       guildTypeAndRarityToStockSupply[_guildType][LEGENDARY_RARITY] = legendarySupply;
1498       guildTypeAndRarityToStockSupply[_guildType][GOLD_RARITY] = goldSupply;
1499       guildTypeAndRarityToStockSupply[_guildType][SILVER_RARITY] = silverSupply;
1500     }
1501 
1502     //    mapping(uint16 => uint16) private guildTypeToSupplyLimit;
1503 
1504     // ロックアップ期間用
1505     /*
1506     function approve(address _to, uint256 _tokenId) public {
1507       require(allowed[_tokenId]);
1508       super.approve(_to, _tokenId);
1509     }
1510 
1511     function transferFrom(address _from, address _to, uint256 _tokenId) public {
1512       require(allowed[_tokenId]);
1513       super.transferFrom(_from, _to, _tokenId);
1514     }
1515 
1516     function unLockToken(uint256 _tokenId) public onlyMinter {
1517       allowed[_tokenId] = true;
1518     }
1519     function canTransfer(uint256 _tokenId) public view returns (bool) {
1520       return allowed[_tokenId];
1521     }
1522     */
1523 
1524     function isAlreadyMinted(uint256 _tokenId) public view returns (bool) {
1525       return _exists(_tokenId);
1526     }
1527 
1528     function isValidGuildStock(uint256 _guildTokenId) public view {
1529 
1530       uint16 rarity = getRarity(_guildTokenId);
1531       require((rarityToStockVolume[rarity] > 0), "invalid rarityToStockVolume");
1532 
1533       uint16 guildType = getGuildType(_guildTokenId);
1534       require((guildTypeToTotalVolume[guildType] > 0), "invalid guildTypeToTotalVolume");
1535 
1536       uint256 serial = _guildTokenId % GUILD_TYPE_OFFSET;
1537       require(serial != 0, "invalid serial zero");
1538       require(serial <= guildTypeAndRarityToStockSupply[guildType][rarity], "invalid serial guildTypeAndRarityToStockSupply");
1539     }
1540 
1541     function getTotalVolume(uint16 _guildType) public view returns (uint256) {
1542       return guildTypeToTotalVolume[_guildType];
1543     }
1544 
1545     function getStockSupplyLimit(uint16 _guildType) public view returns (uint256) {
1546       return guildTypeToStockSupplyLimit[_guildType];
1547     }
1548 
1549     function getGuildType(uint256 _guildTokenId) public view returns (uint16) {
1550       uint16 _guildType = uint16((_guildTokenId.div(GUILD_TYPE_OFFSET)) % GUILD_RARITY_OFFSET);
1551       return _guildType;
1552     }
1553 
1554     function getRarity(uint256 _guildTokenId) public view returns (uint16) {
1555       return uint16(_guildTokenId.div(GUILD_TYPE_OFFSET).div(GUILD_RARITY_OFFSET) % 10);
1556     }
1557 
1558     function getMintedStockCount(uint16 _guildType) public view returns (uint256) {
1559       return guildTypeToGuildStockIndex[_guildType];
1560     }
1561 
1562     function getMintedStockCountByRarity(uint16 _guildType, uint16 _rarity) public view returns (uint256) {
1563       return guildTypeAndRarityToGuildStockCount[_guildType][_rarity];
1564     }
1565 
1566     function getStockSupplyByRarity(uint16 _guildType, uint16 _rarity) public view returns (uint256) {
1567       return guildTypeAndRarityToStockSupply[_guildType][_rarity];
1568     }
1569 
1570     function getMintedStockList(uint16 _guildType) public view returns (uint256[] memory) {
1571       return guildTypeToGuildStockList[_guildType];
1572     }
1573 
1574     function getStockVolumeByRarity(uint16 _rarity) public view returns (uint256) {
1575       return rarityToStockVolume[_rarity];
1576     }
1577 
1578     function getShareRateWithDecimal(uint256 _guildTokenId) public view returns (uint256, uint256) {
1579       return (
1580         getStockVolumeByRarity(getRarity(_guildTokenId))
1581           .mul(SHARE_RATE_DECIMAL)
1582           .div(getTotalVolume(getGuildType(_guildTokenId))),
1583         SHARE_RATE_DECIMAL
1584       );
1585     }
1586 
1587 
1588 /*
1589     function setSupplyLimit(uint16 _guildType, uint16 _supplyLimit) external onlyMinter {
1590         require(_supplyLimit != 0);
1591         require(guildTypeToSupplyLimit[_guildType] == 0 || _supplyLimit < guildTypeToSupplyLimit[_guildType],
1592             "_supplyLimit is bigger");
1593         guildTypeToSupplyLimit[_guildType] = _supplyLimit;
1594     }
1595 */
1596     function setTokenURIPrefix(string calldata _tokenURIPrefix) external onlyMinter {
1597         tokenURIPrefix = _tokenURIPrefix;
1598     }
1599 /*
1600     function getSupplyLimit(uint16 _guildType) public view returns (uint16) {
1601         return guildTypeToSupplyLimit[_guildType];
1602     }
1603 */
1604     function mintGuildStock(address _owner, uint256 _guildTokenId) public onlyMinter {
1605       // _guildStockがtokenId
1606       require(!isAlreadyMinted(_guildTokenId), "is Already Minted");
1607 
1608       // バリデーションチェック
1609       isValidGuildStock(_guildTokenId);
1610 
1611       //  supplyチェック
1612       uint16 _guildType = getGuildType(_guildTokenId);
1613       require(guildTypeToGuildStockIndex[_guildType] < guildTypeToStockSupplyLimit[_guildType]);
1614       uint16 rarity = getRarity(_guildTokenId);
1615       require(guildTypeAndRarityToGuildStockCount[_guildType][rarity] < guildTypeAndRarityToStockSupply[_guildType][rarity], "supply over");
1616 
1617       _mint(_owner, _guildTokenId);
1618       guildTypeToGuildStockList[_guildType].push(_guildTokenId);
1619       guildTypeToGuildStockIndex[_guildType]++;
1620       guildTypeAndRarityToGuildStockCount[_guildType][rarity]++;
1621     }
1622 /*
1623     function mintGuildAsset(address _owner, uint256 _tokenId) public onlyMinter {
1624       // 200010001
1625         uint16 _guildType = uint16(_tokenId / GUILD_TYPE_OFFSET);
1626         uint16 _guildTypeIndex = uint16(_tokenId % GUILD_TYPE_OFFSET) - 1;
1627         require(_guildTypeIndex < guildTypeToSupplyLimit[_guildType], "supply over");
1628         _mint(_owner, _tokenId);
1629     }
1630 */
1631 
1632     function tokenURI(uint256 tokenId) public view returns (string memory) {
1633         bytes32 tokenIdBytes;
1634         if (tokenId == 0) {
1635             tokenIdBytes = "0";
1636         } else {
1637             uint256 value = tokenId;
1638             while (value > 0) {
1639                 tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1640                 tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1641                 value /= 10;
1642             }
1643         }
1644 
1645         bytes memory prefixBytes = bytes(tokenURIPrefix);
1646         bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1647 
1648         uint8 i;
1649         uint8 index = 0;
1650 
1651         for (i = 0; i < prefixBytes.length; i++) {
1652             tokenURIBytes[index] = prefixBytes[i];
1653             index++;
1654         }
1655 
1656         for (i = 0; i < tokenIdBytes.length; i++) {
1657             tokenURIBytes[index] = tokenIdBytes[i];
1658             index++;
1659         }
1660 
1661         return string(tokenURIBytes);
1662     }
1663 
1664 }