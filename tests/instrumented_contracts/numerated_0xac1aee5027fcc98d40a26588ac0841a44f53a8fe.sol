1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-31
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 /**
55  * @dev Required interface of an ERC721 compliant contract.
56  */
57 contract IERC721 is IERC165 {
58     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
59     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     /**
63      * @dev Returns the number of NFTs in `owner`'s account.
64      */
65     function balanceOf(address owner) public view returns (uint256 balance);
66 
67     /**
68      * @dev Returns the owner of the NFT specified by `tokenId`.
69      */
70     function ownerOf(uint256 tokenId) public view returns (address owner);
71 
72     /**
73      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
74      * another (`to`).
75      *
76      *
77      *
78      * Requirements:
79      * - `from`, `to` cannot be zero.
80      * - `tokenId` must be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this
82      * NFT by either {approve} or {setApprovalForAll}.
83      */
84     function safeTransferFrom(address from, address to, uint256 tokenId) public;
85     /**
86      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
87      * another (`to`).
88      *
89      * Requirements:
90      * - If the caller is not `from`, it must be approved to move this NFT by
91      * either {approve} or {setApprovalForAll}.
92      */
93     function transferFrom(address from, address to, uint256 tokenId) public;
94     function approve(address to, uint256 tokenId) public;
95     function getApproved(uint256 tokenId) public view returns (address operator);
96 
97     function setApprovalForAll(address operator, bool _approved) public;
98     function isApprovedForAll(address owner, address operator) public view returns (bool);
99 
100 
101     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
102 }
103 
104 /**
105  * @title ERC721 token receiver interface
106  * @dev Interface for any contract that wants to support safeTransfers
107  * from ERC721 asset contracts.
108  */
109 contract IERC721Receiver {
110     /**
111      * @notice Handle the receipt of an NFT
112      * @dev The ERC721 smart contract calls this function on the recipient
113      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
114      * otherwise the caller will revert the transaction. The selector to be
115      * returned can be obtained as `this.onERC721Received.selector`. This
116      * function MAY throw to revert and reject the transfer.
117      * Note: the ERC721 contract address is always the message sender.
118      * @param operator The address which called `safeTransferFrom` function
119      * @param from The address which previously owned the token
120      * @param tokenId The NFT identifier which is being transferred
121      * @param data Additional data with no specified format
122      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
123      */
124     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
125     public returns (bytes4);
126 }
127 
128 /**
129  * @dev Wrappers over Solidity's arithmetic operations with added overflow
130  * checks.
131  *
132  * Arithmetic operations in Solidity wrap on overflow. This can easily result
133  * in bugs, because programmers usually assume that an overflow raises an
134  * error, which is the standard behavior in high level programming languages.
135  * `SafeMath` restores this intuition by reverting the transaction when an
136  * operation overflows.
137  *
138  * Using this library instead of the unchecked operations eliminates an entire
139  * class of bugs, so it's recommended to use it always.
140  */
141 library SafeMath {
142     /**
143      * @dev Returns the addition of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `+` operator.
147      *
148      * Requirements:
149      * - Addition cannot overflow.
150      */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         return sub(a, b, "SafeMath: subtraction overflow");
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      * - Subtraction cannot overflow.
179      *
180      * _Available since v2.4.0._
181      */
182     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b <= a, errorMessage);
184         uint256 c = a - b;
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      * - Multiplication cannot overflow.
197      */
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
200         // benefit is lost if 'b' is also tested.
201         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
202         if (a == 0) {
203             return 0;
204         }
205 
206         uint256 c = a * b;
207         require(c / a == b, "SafeMath: multiplication overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         return div(a, b, "SafeMath: division by zero");
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      *
238      * _Available since v2.4.0._
239      */
240     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         // Solidity only automatically asserts when dividing by 0
242         require(b > 0, errorMessage);
243         uint256 c = a / b;
244         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      * - The divisor cannot be zero.
274      *
275      * _Available since v2.4.0._
276      */
277     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b != 0, errorMessage);
279         return a % b;
280     }
281 }
282 
283 /**
284  * @dev Collection of functions related to the address type
285  */
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * This test is non-exhaustive, and there may be false-negatives: during the
291      * execution of a contract's constructor, its address will be reported as
292      * not containing a contract.
293      *
294      * IMPORTANT: It is unsafe to assume that an address for which this
295      * function returns false is an externally-owned account (EOA) and not a
296      * contract.
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies in extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
304         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
305         // for accounts without code, i.e. `keccak256('')`
306         bytes32 codehash;
307         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
308         // solhint-disable-next-line no-inline-assembly
309         assembly { codehash := extcodehash(account) }
310         return (codehash != 0x0 && codehash != accountHash);
311     }
312 
313     /**
314      * @dev Converts an `address` into `address payable`. Note that this is
315      * simply a type cast: the actual underlying value is not changed.
316      *
317      * _Available since v2.4.0._
318      */
319     function toPayable(address account) internal pure returns (address payable) {
320         return address(uint160(account));
321     }
322 
323     /**
324      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
325      * `recipient`, forwarding all available gas and reverting on errors.
326      *
327      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
328      * of certain opcodes, possibly making contracts go over the 2300 gas limit
329      * imposed by `transfer`, making them unable to receive funds via
330      * `transfer`. {sendValue} removes this limitation.
331      *
332      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
333      *
334      * IMPORTANT: because control is transferred to `recipient`, care must be
335      * taken to not create reentrancy vulnerabilities. Consider using
336      * {ReentrancyGuard} or the
337      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
338      *
339      * _Available since v2.4.0._
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         // solhint-disable-next-line avoid-call-value
345         (bool success, ) = recipient.call.value(amount)("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 }
349 
350 /**
351  * @title Counters
352  * @author Matt Condon (@shrugs)
353  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
354  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
355  *
356  * Include with `using Counters for Counters.Counter;`
357  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
358  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
359  * directly accessed.
360  */
361 library Counters {
362     using SafeMath for uint256;
363 
364     struct Counter {
365         // This variable should never be directly accessed by users of the library: interactions must be restricted to
366         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
367         // this feature: see https://github.com/ethereum/solidity/issues/4637
368         uint256 _value; // default: 0
369     }
370 
371     function current(Counter storage counter) internal view returns (uint256) {
372         return counter._value;
373     }
374 
375     function increment(Counter storage counter) internal {
376         counter._value += 1;
377     }
378 
379     function decrement(Counter storage counter) internal {
380         counter._value = counter._value.sub(1);
381     }
382 }
383 
384 /**
385  * @dev Implementation of the {IERC165} interface.
386  *
387  * Contracts may inherit from this and call {_registerInterface} to declare
388  * their support of an interface.
389  */
390 contract ERC165 is IERC165 {
391     /*
392      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
393      */
394     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
395 
396     /**
397      * @dev Mapping of interface ids to whether or not it's supported.
398      */
399     mapping(bytes4 => bool) private _supportedInterfaces;
400 
401     constructor () internal {
402         // Derived contracts need only register support for their own interfaces,
403         // we register support for ERC165 itself here
404         _registerInterface(_INTERFACE_ID_ERC165);
405     }
406 
407     /**
408      * @dev See {IERC165-supportsInterface}.
409      *
410      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
411      */
412     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
413         return _supportedInterfaces[interfaceId];
414     }
415 
416     /**
417      * @dev Registers the contract as an implementer of the interface defined by
418      * `interfaceId`. Support of the actual ERC165 interface is automatic and
419      * registering its interface id is not required.
420      *
421      * See {IERC165-supportsInterface}.
422      *
423      * Requirements:
424      *
425      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
426      */
427     function _registerInterface(bytes4 interfaceId) internal {
428         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
429         _supportedInterfaces[interfaceId] = true;
430     }
431 }
432 
433 /**
434  * @title ERC721 Non-Fungible Token Standard basic implementation
435  * @dev see https://eips.ethereum.org/EIPS/eip-721
436  */
437 contract ERC721 is Context, ERC165, IERC721 {
438     using SafeMath for uint256;
439     using Address for address;
440     using Counters for Counters.Counter;
441 
442     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
443     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
444     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
445 
446     // Mapping from token ID to owner
447     mapping (uint256 => address) private _tokenOwner;
448 
449     // Mapping from token ID to approved address
450     mapping (uint256 => address) private _tokenApprovals;
451 
452     // Mapping from owner to number of owned token
453     mapping (address => Counters.Counter) private _ownedTokensCount;
454 
455     // Mapping from owner to operator approvals
456     mapping (address => mapping (address => bool)) private _operatorApprovals;
457 
458     /*
459      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
460      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
461      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
462      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
463      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
464      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
465      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
466      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
467      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
468      *
469      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
470      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
471      */
472     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
473 
474     constructor () public {
475         // register the supported interfaces to conform to ERC721 via ERC165
476         _registerInterface(_INTERFACE_ID_ERC721);
477     }
478 
479     /**
480      * @dev Gets the balance of the specified address.
481      * @param owner address to query the balance of
482      * @return uint256 representing the amount owned by the passed address
483      */
484     function balanceOf(address owner) public view returns (uint256) {
485         require(owner != address(0), "ERC721: balance query for the zero address");
486 
487         return _ownedTokensCount[owner].current();
488     }
489 
490     /**
491      * @dev Gets the owner of the specified token ID.
492      * @param tokenId uint256 ID of the token to query the owner of
493      * @return address currently marked as the owner of the given token ID
494      */
495     function ownerOf(uint256 tokenId) public view returns (address) {
496         address owner = _tokenOwner[tokenId];
497         require(owner != address(0), "ERC721: owner query for nonexistent token");
498 
499         return owner;
500     }
501 
502     /**
503      * @dev Approves another address to transfer the given token ID
504      * The zero address indicates there is no approved address.
505      * There can only be one approved address per token at a given time.
506      * Can only be called by the token owner or an approved operator.
507      * @param to address to be approved for the given token ID
508      * @param tokenId uint256 ID of the token to be approved
509      */
510     function approve(address to, uint256 tokenId) public {
511         address owner = ownerOf(tokenId);
512         require(to != owner, "ERC721: approval to current owner");
513 
514         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
515             "ERC721: approve caller is not owner nor approved for all"
516         );
517 
518         _tokenApprovals[tokenId] = to;
519         emit Approval(owner, to, tokenId);
520     }
521 
522     /**
523      * @dev Gets the approved address for a token ID, or zero if no address set
524      * Reverts if the token ID does not exist.
525      * @param tokenId uint256 ID of the token to query the approval of
526      * @return address currently approved for the given token ID
527      */
528     function getApproved(uint256 tokenId) public view returns (address) {
529         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
530 
531         return _tokenApprovals[tokenId];
532     }
533 
534     /**
535      * @dev Sets or unsets the approval of a given operator
536      * An operator is allowed to transfer all tokens of the sender on their behalf.
537      * @param to operator address to set the approval
538      * @param approved representing the status of the approval to be set
539      */
540     function setApprovalForAll(address to, bool approved) public {
541         require(to != _msgSender(), "ERC721: approve to caller");
542 
543         _operatorApprovals[_msgSender()][to] = approved;
544         emit ApprovalForAll(_msgSender(), to, approved);
545     }
546 
547     /**
548      * @dev Tells whether an operator is approved by a given owner.
549      * @param owner owner address which you want to query the approval of
550      * @param operator operator address which you want to query the approval of
551      * @return bool whether the given operator is approved by the given owner
552      */
553     function isApprovedForAll(address owner, address operator) public view returns (bool) {
554         return _operatorApprovals[owner][operator];
555     }
556 
557     /**
558      * @dev Transfers the ownership of a given token ID to another address.
559      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
560      * Requires the msg.sender to be the owner, approved, or operator.
561      * @param from current owner of the token
562      * @param to address to receive the ownership of the given token ID
563      * @param tokenId uint256 ID of the token to be transferred
564      */
565     function transferFrom(address from, address to, uint256 tokenId) public {
566         //solhint-disable-next-line max-line-length
567         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
568 
569         _transferFrom(from, to, tokenId);
570     }
571 
572     /**
573      * @dev Safely transfers the ownership of a given token ID to another address
574      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
575      * which is called upon a safe transfer, and return the magic value
576      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
577      * the transfer is reverted.
578      * Requires the msg.sender to be the owner, approved, or operator
579      * @param from current owner of the token
580      * @param to address to receive the ownership of the given token ID
581      * @param tokenId uint256 ID of the token to be transferred
582      */
583     function safeTransferFrom(address from, address to, uint256 tokenId) public {
584         safeTransferFrom(from, to, tokenId, "");
585     }
586 
587     /**
588      * @dev Safely transfers the ownership of a given token ID to another address
589      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
590      * which is called upon a safe transfer, and return the magic value
591      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
592      * the transfer is reverted.
593      * Requires the _msgSender() to be the owner, approved, or operator
594      * @param from current owner of the token
595      * @param to address to receive the ownership of the given token ID
596      * @param tokenId uint256 ID of the token to be transferred
597      * @param _data bytes data to send along with a safe transfer check
598      */
599     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
600         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
601         _safeTransferFrom(from, to, tokenId, _data);
602     }
603 
604     /**
605      * @dev Safely transfers the ownership of a given token ID to another address
606      * If the target address is a contract, it must implement `onERC721Received`,
607      * which is called upon a safe transfer, and return the magic value
608      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
609      * the transfer is reverted.
610      * Requires the msg.sender to be the owner, approved, or operator
611      * @param from current owner of the token
612      * @param to address to receive the ownership of the given token ID
613      * @param tokenId uint256 ID of the token to be transferred
614      * @param _data bytes data to send along with a safe transfer check
615      */
616     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
617         _transferFrom(from, to, tokenId);
618         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
619     }
620 
621     /**
622      * @dev Returns whether the specified token exists.
623      * @param tokenId uint256 ID of the token to query the existence of
624      * @return bool whether the token exists
625      */
626     function _exists(uint256 tokenId) internal view returns (bool) {
627         address owner = _tokenOwner[tokenId];
628         return owner != address(0);
629     }
630 
631     /**
632      * @dev Returns whether the given spender can transfer a given token ID.
633      * @param spender address of the spender to query
634      * @param tokenId uint256 ID of the token to be transferred
635      * @return bool whether the msg.sender is approved for the given token ID,
636      * is an operator of the owner, or is the owner of the token
637      */
638     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
639         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
640         address owner = ownerOf(tokenId);
641         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
642     }
643 
644     /**
645      * @dev Internal function to safely mint a new token.
646      * Reverts if the given token ID already exists.
647      * If the target address is a contract, it must implement `onERC721Received`,
648      * which is called upon a safe transfer, and return the magic value
649      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
650      * the transfer is reverted.
651      * @param to The address that will own the minted token
652      * @param tokenId uint256 ID of the token to be minted
653      */
654     function _safeMint(address to, uint256 tokenId) internal {
655         _safeMint(to, tokenId, "");
656     }
657 
658     /**
659      * @dev Internal function to safely mint a new token.
660      * Reverts if the given token ID already exists.
661      * If the target address is a contract, it must implement `onERC721Received`,
662      * which is called upon a safe transfer, and return the magic value
663      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
664      * the transfer is reverted.
665      * @param to The address that will own the minted token
666      * @param tokenId uint256 ID of the token to be minted
667      * @param _data bytes data to send along with a safe transfer check
668      */
669     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
670         _mint(to, tokenId);
671         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
672     }
673 
674     /**
675      * @dev Internal function to mint a new token.
676      * Reverts if the given token ID already exists.
677      * @param to The address that will own the minted token
678      * @param tokenId uint256 ID of the token to be minted
679      */
680     function _mint(address to, uint256 tokenId) internal {
681         require(to != address(0), "ERC721: mint to the zero address");
682         require(!_exists(tokenId), "ERC721: token already minted");
683 
684         _tokenOwner[tokenId] = to;
685         _ownedTokensCount[to].increment();
686 
687         emit Transfer(address(0), to, tokenId);
688     }
689 
690     /**
691      * @dev Internal function to burn a specific token.
692      * Reverts if the token does not exist.
693      * Deprecated, use {_burn} instead.
694      * @param owner owner of the token to burn
695      * @param tokenId uint256 ID of the token being burned
696      */
697     function _burn(address owner, uint256 tokenId) internal {
698         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
699 
700         _clearApproval(tokenId);
701 
702         _ownedTokensCount[owner].decrement();
703         _tokenOwner[tokenId] = address(0);
704 
705         emit Transfer(owner, address(0), tokenId);
706     }
707 
708     /**
709      * @dev Internal function to burn a specific token.
710      * Reverts if the token does not exist.
711      * @param tokenId uint256 ID of the token being burned
712      */
713     function _burn(uint256 tokenId) internal {
714         _burn(ownerOf(tokenId), tokenId);
715     }
716 
717     /**
718      * @dev Internal function to transfer ownership of a given token ID to another address.
719      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
720      * @param from current owner of the token
721      * @param to address to receive the ownership of the given token ID
722      * @param tokenId uint256 ID of the token to be transferred
723      */
724     function _transferFrom(address from, address to, uint256 tokenId) internal {
725         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
726         require(to != address(0), "ERC721: transfer to the zero address");
727 
728         _clearApproval(tokenId);
729 
730         _ownedTokensCount[from].decrement();
731         _ownedTokensCount[to].increment();
732 
733         _tokenOwner[tokenId] = to;
734 
735         emit Transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
740      * The call is not executed if the target address is not a contract.
741      *
742      * This function is deprecated.
743      * @param from address representing the previous owner of the given token ID
744      * @param to target address that will receive the tokens
745      * @param tokenId uint256 ID of the token to be transferred
746      * @param _data bytes optional data to send along with the call
747      * @return bool whether the call correctly returned the expected magic value
748      */
749     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
750         internal returns (bool)
751     {
752         if (!to.isContract()) {
753             return true;
754         }
755 
756         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
757         return (retval == _ERC721_RECEIVED);
758     }
759 
760     /**
761      * @dev Private function to clear current approval of a given token ID.
762      * @param tokenId uint256 ID of the token to be transferred
763      */
764     function _clearApproval(uint256 tokenId) private {
765         if (_tokenApprovals[tokenId] != address(0)) {
766             _tokenApprovals[tokenId] = address(0);
767         }
768     }
769 }
770 
771 /**
772  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
773  * @dev See https://eips.ethereum.org/EIPS/eip-721
774  */
775 contract IERC721Enumerable is IERC721 {
776     function totalSupply() public view returns (uint256);
777     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
778 
779     function tokenByIndex(uint256 index) public view returns (uint256);
780 }
781 
782 /**
783  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
784  * @dev See https://eips.ethereum.org/EIPS/eip-721
785  */
786 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
787     // Mapping from owner to list of owned token IDs
788     mapping(address => uint256[]) private _ownedTokens;
789 
790     // Mapping from token ID to index of the owner tokens list
791     mapping(uint256 => uint256) private _ownedTokensIndex;
792 
793     // Array with all token ids, used for enumeration
794     uint256[] private _allTokens;
795 
796     // Mapping from token id to position in the allTokens array
797     mapping(uint256 => uint256) private _allTokensIndex;
798 
799     /*
800      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
801      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
802      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
803      *
804      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
805      */
806     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
807 
808     /**
809      * @dev Constructor function.
810      */
811     constructor () public {
812         // register the supported interface to conform to ERC721Enumerable via ERC165
813         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
814     }
815 
816     /**
817      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
818      * @param owner address owning the tokens list to be accessed
819      * @param index uint256 representing the index to be accessed of the requested tokens list
820      * @return uint256 token ID at the given index of the tokens list owned by the requested address
821      */
822     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
823         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
824         return _ownedTokens[owner][index];
825     }
826 
827     /**
828      * @dev Gets the total amount of tokens stored by the contract.
829      * @return uint256 representing the total amount of tokens
830      */
831     function totalSupply() public view returns (uint256) {
832         return _allTokens.length;
833     }
834 
835     /**
836      * @dev Gets the token ID at a given index of all the tokens in this contract
837      * Reverts if the index is greater or equal to the total number of tokens.
838      * @param index uint256 representing the index to be accessed of the tokens list
839      * @return uint256 token ID at the given index of the tokens list
840      */
841     function tokenByIndex(uint256 index) public view returns (uint256) {
842         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
843         return _allTokens[index];
844     }
845 
846     /**
847      * @dev Internal function to transfer ownership of a given token ID to another address.
848      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
849      * @param from current owner of the token
850      * @param to address to receive the ownership of the given token ID
851      * @param tokenId uint256 ID of the token to be transferred
852      */
853     function _transferFrom(address from, address to, uint256 tokenId) internal {
854         super._transferFrom(from, to, tokenId);
855 
856         _removeTokenFromOwnerEnumeration(from, tokenId);
857 
858         _addTokenToOwnerEnumeration(to, tokenId);
859     }
860 
861     /**
862      * @dev Internal function to mint a new token.
863      * Reverts if the given token ID already exists.
864      * @param to address the beneficiary that will own the minted token
865      * @param tokenId uint256 ID of the token to be minted
866      */
867     function _mint(address to, uint256 tokenId) internal {
868         super._mint(to, tokenId);
869 
870         _addTokenToOwnerEnumeration(to, tokenId);
871 
872         _addTokenToAllTokensEnumeration(tokenId);
873     }
874 
875     /**
876      * @dev Internal function to burn a specific token.
877      * Reverts if the token does not exist.
878      * Deprecated, use {ERC721-_burn} instead.
879      * @param owner owner of the token to burn
880      * @param tokenId uint256 ID of the token being burned
881      */
882     function _burn(address owner, uint256 tokenId) internal {
883         super._burn(owner, tokenId);
884 
885         _removeTokenFromOwnerEnumeration(owner, tokenId);
886         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
887         _ownedTokensIndex[tokenId] = 0;
888 
889         _removeTokenFromAllTokensEnumeration(tokenId);
890     }
891 
892     /**
893      * @dev Gets the list of token IDs of the requested owner.
894      * @param owner address owning the tokens
895      * @return uint256[] List of token IDs owned by the requested address
896      */
897     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
898         return _ownedTokens[owner];
899     }
900 
901     /**
902      * @dev Private function to add a token to this extension's ownership-tracking data structures.
903      * @param to address representing the new owner of the given token ID
904      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
905      */
906     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
907         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
908         _ownedTokens[to].push(tokenId);
909     }
910 
911     /**
912      * @dev Private function to add a token to this extension's token tracking data structures.
913      * @param tokenId uint256 ID of the token to be added to the tokens list
914      */
915     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
916         _allTokensIndex[tokenId] = _allTokens.length;
917         _allTokens.push(tokenId);
918     }
919 
920     /**
921      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
922      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
923      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
924      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
925      * @param from address representing the previous owner of the given token ID
926      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
927      */
928     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
929         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
930         // then delete the last slot (swap and pop).
931 
932         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
933         uint256 tokenIndex = _ownedTokensIndex[tokenId];
934 
935         // When the token to delete is the last token, the swap operation is unnecessary
936         if (tokenIndex != lastTokenIndex) {
937             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
938 
939             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
940             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
941         }
942 
943         // This also deletes the contents at the last position of the array
944         _ownedTokens[from].length--;
945 
946         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
947         // lastTokenId, or just over the end of the array if the token was the last one).
948     }
949 
950     /**
951      * @dev Private function to remove a token from this extension's token tracking data structures.
952      * This has O(1) time complexity, but alters the order of the _allTokens array.
953      * @param tokenId uint256 ID of the token to be removed from the tokens list
954      */
955     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
956         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
957         // then delete the last slot (swap and pop).
958 
959         uint256 lastTokenIndex = _allTokens.length.sub(1);
960         uint256 tokenIndex = _allTokensIndex[tokenId];
961 
962         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
963         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
964         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
965         uint256 lastTokenId = _allTokens[lastTokenIndex];
966 
967         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
968         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
969 
970         // This also deletes the contents at the last position of the array
971         _allTokens.length--;
972         _allTokensIndex[tokenId] = 0;
973     }
974 }
975 
976 /**
977  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
978  * @dev See https://eips.ethereum.org/EIPS/eip-721
979  */
980 contract IERC721Metadata is IERC721 {
981     function name() external view returns (string memory);
982     function symbol() external view returns (string memory);
983     function tokenURI(uint256 tokenId) external view returns (string memory);
984 }
985 
986 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
987     // Token name
988     string private _name;
989 
990     // Token symbol
991     string private _symbol;
992 
993     // Optional mapping for token URIs
994     mapping(uint256 => string) private _tokenURIs;
995 
996     /*
997      *     bytes4(keccak256('name()')) == 0x06fdde03
998      *     bytes4(keccak256('symbol()')) == 0x95d89b41
999      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1000      *
1001      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1002      */
1003     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1004 
1005     /**
1006      * @dev Constructor function
1007      */
1008     constructor (string memory name, string memory symbol) public {
1009         _name = name;
1010         _symbol = symbol;
1011 
1012         // register the supported interfaces to conform to ERC721 via ERC165
1013         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1014     }
1015 
1016     /**
1017      * @dev Gets the token name.
1018      * @return string representing the token name
1019      */
1020     function name() external view returns (string memory) {
1021         return _name;
1022     }
1023 
1024     /**
1025      * @dev Gets the token symbol.
1026      * @return string representing the token symbol
1027      */
1028     function symbol() external view returns (string memory) {
1029         return _symbol;
1030     }
1031 
1032     /**
1033      * @dev Returns an URI for a given token ID.
1034      * Throws if the token ID does not exist. May return an empty string.
1035      * @param tokenId uint256 ID of the token to query
1036      */
1037     function tokenURI(uint256 tokenId) external view returns (string memory) {
1038         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1039         return _tokenURIs[tokenId];
1040     }
1041 
1042     /**
1043      * @dev Internal function to set the token URI for a given token.
1044      * Reverts if the token ID does not exist.
1045      * @param tokenId uint256 ID of the token to set its URI
1046      * @param uri string URI to assign
1047      */
1048     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1049         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1050         _tokenURIs[tokenId] = uri;
1051     }
1052 
1053     /**
1054      * @dev Internal function to burn a specific token.
1055      * Reverts if the token does not exist.
1056      * Deprecated, use _burn(uint256) instead.
1057      * @param owner owner of the token to burn
1058      * @param tokenId uint256 ID of the token being burned by the msg.sender
1059      */
1060     function _burn(address owner, uint256 tokenId) internal {
1061         super._burn(owner, tokenId);
1062 
1063         // Clear metadata (if any)
1064         if (bytes(_tokenURIs[tokenId]).length != 0) {
1065             delete _tokenURIs[tokenId];
1066         }
1067     }
1068 }
1069 
1070 /**
1071  * @title Full ERC721 Token
1072  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1073  * Moreover, it includes approve all functionality using operator terminology.
1074  *
1075  * See https://eips.ethereum.org/EIPS/eip-721
1076  */
1077 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1078     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1079         // solhint-disable-previous-line no-empty-blocks
1080     }
1081 }
1082 
1083 contract WORD is ERC721Full {
1084     using SafeMath for uint256;
1085 
1086     mapping(string  => uint256) value_to_id;
1087     mapping(uint256 => string) id_to_value;
1088 
1089     constructor() ERC721Full("WORD", "WORD") public {
1090         _mint(msg.sender, 0);
1091         
1092         string[27] memory basic_characters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","-"];
1093         
1094         for (uint256 i = 0; i < basic_characters.length; ++i )
1095         {
1096             string memory character = basic_characters[i];
1097             _registerToken(character);
1098         }
1099     }
1100     
1101     function _registerToken(string memory value) private {
1102         uint256 tokenId = totalSupply();
1103         
1104         id_to_value[tokenId] = value;
1105         value_to_id[value] = tokenId;
1106         
1107         _mint(msg.sender, tokenId);
1108     }
1109 
1110     function add(string memory token1, string memory token2) public payable {
1111         require(msg.value == 2 finney);
1112         require(bytes(token1).length > 0);
1113         require(bytes(token2).length > 0);
1114         
1115         string memory token3 = string(abi.encodePacked(token1, token2));
1116         
1117         uint256 tokenId1 = value_to_id[token1];
1118         uint256 tokenId2 = value_to_id[token2];
1119         uint256 tokenId3 = value_to_id[token3];
1120         
1121         require(tokenId1 > 0);
1122         require(tokenId2 > 0);
1123         require(tokenId3 == 0);
1124         
1125         address payable owner1 = address(uint160(ownerOf(tokenId1)));
1126         address payable owner2 = address(uint160(ownerOf(tokenId2)));
1127         
1128         _registerToken(token3);
1129         
1130         owner1.transfer(1 finney);
1131         owner2.transfer(1 finney);
1132     }
1133     
1134     function getWord(uint256 id) public view returns (string memory word) {
1135         return id_to_value[id];
1136     }
1137 }