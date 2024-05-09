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
1241 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721MetadataMintable.sol
1242 
1243 pragma solidity ^0.5.0;
1244 
1245 
1246 
1247 
1248 /**
1249  * @title ERC721MetadataMintable
1250  * @dev ERC721 minting logic with metadata.
1251  */
1252 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
1253     /**
1254      * @dev Function to mint tokens.
1255      * @param to The address that will receive the minted tokens.
1256      * @param tokenId The token id to mint.
1257      * @param tokenURI The token URI of the minted token.
1258      * @return A boolean that indicates if the operation was successful.
1259      */
1260     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
1261         _mint(to, tokenId);
1262         _setTokenURI(tokenId, tokenURI);
1263         return true;
1264     }
1265 }
1266 
1267 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol
1268 
1269 pragma solidity ^0.5.0;
1270 
1271 
1272 
1273 /**
1274  * @title ERC721 Burnable Token
1275  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1276  */
1277 contract ERC721Burnable is Context, ERC721 {
1278     /**
1279      * @dev Burns a specific ERC721 token.
1280      * @param tokenId uint256 id of the ERC721 token to be burned.
1281      */
1282     function burn(uint256 tokenId) public {
1283         //solhint-disable-next-line max-line-length
1284         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1285         _burn(tokenId);
1286     }
1287 }
1288 
1289 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1290 
1291 pragma solidity ^0.5.0;
1292 
1293 /**
1294  * @dev Contract module which provides a basic access control mechanism, where
1295  * there is an account (an owner) that can be granted exclusive access to
1296  * specific functions.
1297  *
1298  * This module is used through inheritance. It will make available the modifier
1299  * `onlyOwner`, which can be applied to your functions to restrict their use to
1300  * the owner.
1301  */
1302 contract Ownable is Context {
1303     address private _owner;
1304 
1305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1306 
1307     /**
1308      * @dev Initializes the contract setting the deployer as the initial owner.
1309      */
1310     constructor () internal {
1311         _owner = _msgSender();
1312         emit OwnershipTransferred(address(0), _owner);
1313     }
1314 
1315     /**
1316      * @dev Returns the address of the current owner.
1317      */
1318     function owner() public view returns (address) {
1319         return _owner;
1320     }
1321 
1322     /**
1323      * @dev Throws if called by any account other than the owner.
1324      */
1325     modifier onlyOwner() {
1326         require(isOwner(), "Ownable: caller is not the owner");
1327         _;
1328     }
1329 
1330     /**
1331      * @dev Returns true if the caller is the current owner.
1332      */
1333     function isOwner() public view returns (bool) {
1334         return _msgSender() == _owner;
1335     }
1336 
1337     /**
1338      * @dev Leaves the contract without owner. It will not be possible to call
1339      * `onlyOwner` functions anymore. Can only be called by the current owner.
1340      *
1341      * NOTE: Renouncing ownership will leave the contract without an owner,
1342      * thereby removing any functionality that is only available to the owner.
1343      */
1344     function renounceOwnership() public onlyOwner {
1345         emit OwnershipTransferred(_owner, address(0));
1346         _owner = address(0);
1347     }
1348 
1349     /**
1350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1351      * Can only be called by the current owner.
1352      */
1353     function transferOwnership(address newOwner) public onlyOwner {
1354         _transferOwnership(newOwner);
1355     }
1356 
1357     /**
1358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1359      */
1360     function _transferOwnership(address newOwner) internal {
1361         require(newOwner != address(0), "Ownable: new owner is the zero address");
1362         emit OwnershipTransferred(_owner, newOwner);
1363         _owner = newOwner;
1364     }
1365 }
1366 
1367 // File: contracts/Strings.sol
1368 
1369 pragma solidity ^0.5.7;
1370 
1371 library Strings {
1372   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1373   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
1374       bytes memory _ba = bytes(_a);
1375       bytes memory _bb = bytes(_b);
1376       bytes memory _bc = bytes(_c);
1377       bytes memory _bd = bytes(_d);
1378       bytes memory _be = bytes(_e);
1379       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1380       bytes memory babcde = bytes(abcde);
1381       uint k = 0;
1382       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1383       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1384       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1385       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1386       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1387       return string(babcde);
1388     }
1389 
1390     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
1391         return strConcat(_a, _b, _c, _d, "");
1392     }
1393 
1394     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1395         return strConcat(_a, _b, _c, "", "");
1396     }
1397 
1398     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1399         return strConcat(_a, _b, "", "", "");
1400     }
1401 
1402     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1403         if (_i == 0) {
1404             return "0";
1405         }
1406         uint j = _i;
1407         uint len;
1408         while (j != 0) {
1409             len++;
1410             j /= 10;
1411         }
1412         bytes memory bstr = new bytes(len);
1413         uint k = len - 1;
1414         while (_i != 0) {
1415             bstr[k--] = byte(uint8(48 + _i % 10));
1416             _i /= 10;
1417         }
1418         return string(bstr);
1419     }
1420 }
1421 
1422 // File: contracts/Thing.sol
1423 
1424 pragma solidity ^0.5.7;
1425 
1426 
1427 
1428 
1429 
1430 
1431 
1432 
1433 
1434 contract Thing is ERC721Full, ERC721MetadataMintable, ERC721Burnable, Ownable {
1435   using SafeMath for uint256;
1436   using Strings for string;
1437   
1438   enum TokenState { Pending, ForSale, Sold, Transferred }
1439 
1440   struct Price {
1441     uint256 tokenId;
1442     uint256 price;
1443     string metaId;
1444     TokenState state;
1445   }
1446 
1447   mapping(uint256 => Price) public items;
1448 
1449   uint256 public id;
1450   string public baseUri;
1451   address payable public maker;
1452   address payable feeAddress;
1453 
1454   constructor(
1455     string memory name,
1456     string memory symbol,
1457     string memory uri,
1458     address payable fee,
1459     address payable creator
1460   ) ERC721Full(name, symbol) public {
1461     maker = creator;
1462     feeAddress = fee;
1463     baseUri = uri;
1464     id = 0;
1465     transferOwnership(creator);
1466     _addMinter(creator);
1467 
1468   }
1469 
1470   event ErrorOut(string error, uint256 tokenId);
1471   event BatchTransfered(string metaId, address[] recipients, uint256[] ids);
1472   event Minted(uint256 id, string metaId);
1473   event BatchBurned(string metaId, uint256[] ids);
1474   event BatchForSale(uint256[] ids, string metaId);
1475   event Bought(uint256 tokenId, string metaId, uint256 value);
1476   event Destroy();
1477 
1478   function tokenURI(uint256 _tokenId) public view returns (string memory) {
1479     return Strings.strConcat(
1480         baseUri,
1481         items[_tokenId].metaId
1482     );
1483   }
1484 
1485   function setTokenState(uint256[] memory ids, bool isEnabled) public onlyMinter {
1486     for (uint256 i = 0; i < ids.length; i++) {
1487       if(isEnabled == true){
1488         items[ids[i]].state = TokenState.ForSale;
1489       } else {
1490         items[ids[i]].state = TokenState.Pending;
1491       }
1492     }
1493      emit BatchForSale(ids, items[ids[0]].metaId);
1494   }
1495 
1496   function setTokenPrice(uint256[] memory ids, uint256 setPrice) public onlyMinter {
1497     for (uint256 i = 0; i < ids.length; i++) {
1498       items[ids[i]].price = setPrice;
1499     }
1500   }
1501 
1502   function mintbaseFee(uint256 amount) internal pure returns (uint256) {
1503     uint256 toOwner = SafeMath.mul(amount, 2);
1504 
1505     return SafeMath.div(toOwner, 100);
1506   }
1507 
1508   function buyThing(uint256 _tokenId) public payable returns (bool) {
1509 
1510     require(msg.value >= items[_tokenId].price, "Price issue");
1511     require(TokenState.ForSale == items[_tokenId].state, "No Sale");
1512 
1513     if(items[_tokenId].price >= 0) {
1514       uint256 fee = mintbaseFee(msg.value);
1515       uint256 withFee = SafeMath.sub(msg.value, fee);
1516 
1517       maker.transfer(withFee);
1518       feeAddress.transfer(fee);
1519     }
1520 
1521     _transferFrom(maker, msg.sender, _tokenId);
1522     items[_tokenId].state = TokenState.Sold;
1523 
1524     emit Bought(_tokenId, items[_tokenId].metaId, msg.value);
1525   }
1526 
1527   function destroyAndSend() public onlyOwner {
1528     emit Destroy();
1529     selfdestruct(maker);
1530   }
1531 
1532   function batchTransfer(address giver, address[] memory recipients, uint256[] memory values) public {
1533 
1534     for (uint256 i = 0; i < values.length; i++) {
1535       transferFrom(giver, recipients[i], values[i]);
1536      items[values[i]].state = TokenState.Transferred;
1537     }
1538     emit BatchTransfered(items[values[0]].metaId, recipients, values);
1539   }
1540 
1541   function batchMint(address to, uint256 amountToMint, string memory metaId, uint256 setPrice, bool isForSale) public onlyMinter {
1542 
1543     require(amountToMint <= 40, "Over 40");
1544 
1545     for (uint256 i = 0; i < amountToMint; i++) {
1546       id = id.add(1);
1547       items[id].price = setPrice;
1548       items[id].metaId = metaId;
1549       if(isForSale == true){
1550         items[id].state = TokenState.ForSale;
1551         
1552       } else {
1553         items[id].state = TokenState.Pending;
1554       }
1555       _mint(to, id);
1556       emit Minted(id, metaId);
1557     }
1558    
1559   }
1560 
1561   function batchBurn(uint256[] memory tokenIds) public onlyMinter {
1562     for (uint256 i = 0; i < tokenIds.length; i++) {
1563       _burn(tokenIds[i]);
1564     }
1565     emit BatchBurned(items[tokenIds[0]].metaId, tokenIds);
1566   }
1567 
1568   function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1569     return _tokensOfOwner(owner);
1570   }
1571 }