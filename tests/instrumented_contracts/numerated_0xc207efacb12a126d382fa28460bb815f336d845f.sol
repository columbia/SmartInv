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
811 // File: contracts/Scribe.sol
812 
813 pragma solidity ^0.5.12;
814 
815 
816 /** 
817  * Utilities library
818  */
819 library Utilities {
820 	// concat two bytes objects
821     function concat(bytes memory a, bytes memory b)
822             internal pure returns (bytes memory) {
823         return abi.encodePacked(a, b);
824     }
825 
826     // convert address to bytes
827     function toBytes(address x) internal pure returns (bytes memory b) { 
828 		b = new bytes(20); 
829 	
830 		for (uint i = 0; i < 20; i++) 
831 			b[i] = byte(uint8(uint(x) / (2**(8*(19 - i))))); 
832 	}
833 
834 	// convert uint256 to bytes
835 	function toBytes(uint256 x) internal pure returns (bytes memory b) {
836     	b = new bytes(32);
837     	assembly { mstore(add(b, 32), x) }
838 	}
839 }
840 
841 /*
842  * @title Contract that allows an NFT owner to dictate a message attached to the token.
843  * There's no limit on the number of messages they can dictate or the length for a single message
844  * @dev Conlan Rios
845  */
846 contract Scribe {
847 	// A record event that emits each time an owner dictates a message
848 	event Record (
849 		// the address of who dicated this document
850 		address dictator,
851 		// The NFT address
852         address tokenAddress,
853         // The NFT tokenId
854         uint tokenId,
855         // The text of the dictation
856         string text
857     );
858 
859 	// A recorded document which tracks the dictator, the text, and the timestamp of when it was created
860 	struct Document {
861 		// the address of who dicated this document
862 		address dictator;
863 		// the text of the dictation
864 		string text;
865 		// the block time of the dictation
866 		uint creationTime;
867 	}
868 
869 	// Mapping of document keys to documents (keys are concated token address + tokenId)
870 	mapping (bytes => Document[]) public documents;
871 	
872 	// Mapping of document keys to the count of dictated documents
873 	mapping (bytes => uint) public documentsCount;
874 
875 	// Function for dictating an owner message
876 	function dictate(address _tokenAddress, uint256 _tokenId, string memory _text) public {
877 		// check that the message sender owns the token at _tokenAddress
878 		require(ERC721(_tokenAddress).ownerOf(_tokenId) == msg.sender, "Sender not authorized to dictate.");
879 		// get the document key for this address and token id
880 		bytes memory documentKey = getDocumentKey(_tokenAddress, _tokenId);
881 		// push a new document with the dictator address, message, and timestamp
882 		documents[documentKey].push(Document(msg.sender, _text, block.timestamp));
883 		// increase the documents counter for this key
884 		documentsCount[documentKey]++;
885 		// emit an event for this newly created record
886 		emit Record(msg.sender, _tokenAddress, _tokenId, _text);
887 	}
888 
889 	// Function for getting the document key for a given NFT address + tokenId
890 	function getDocumentKey(address _tokenAddress, uint256 _tokenId) public pure returns (bytes memory) {
891 		return Utilities.concat(Utilities.toBytes(_tokenAddress), Utilities.toBytes(_tokenId));
892 	}
893 }