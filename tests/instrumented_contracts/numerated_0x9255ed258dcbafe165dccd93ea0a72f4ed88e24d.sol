1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-19
3 */
4 
5 pragma solidity ^0.5.12;
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
20     constructor () internal {
21 
22     }
23     // solhint-disable-previous-line no-empty-blocks
24 
25     function _msgSender() internal view returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
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
56 /**
57  * @dev Required interface of an ERC721 compliant contract.
58  */
59 contract IERC721 is IERC165 {
60     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
61     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /**
65      * @dev Returns the number of NFTs in `owner`'s account.
66      */
67     function balanceOf(address owner) public view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the NFT specified by `tokenId`.
71      */
72     function ownerOf(uint256 tokenId) public view returns (address owner);
73 
74     /**
75      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
76      * another (`to`).
77      *
78      *
79      *
80      * Requirements:
81      * - `from`, `to` cannot be zero.
82      * - `tokenId` must be owned by `from`.
83      * - If the caller is not `from`, it must be have been allowed to move this
84      * NFT by either {approve} or {setApprovalForAll}.
85      */
86     function safeTransferFrom(address from, address to, uint256 tokenId) public;
87     /**
88      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
89      * another (`to`).
90      *
91      * Requirements:
92      * - If the caller is not `from`, it must be approved to move this NFT by
93      * either {approve} or {setApprovalForAll}.
94      */
95     function transferFrom(address from, address to, uint256 tokenId) public;
96     function approve(address to, uint256 tokenId) public;
97     function getApproved(uint256 tokenId) public view returns (address operator);
98 
99     function setApprovalForAll(address operator, bool _approved) public;
100     function isApprovedForAll(address owner, address operator) public view returns (bool);
101 
102 
103     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
104 }
105 
106 /**
107  * @title ERC721 token receiver interface
108  * @dev Interface for any contract that wants to support safeTransfers
109  * from ERC721 asset contracts.
110  */
111 contract IERC721Receiver {
112     /**
113      * @notice Handle the receipt of an NFT
114      * @dev The ERC721 smart contract calls this function on the recipient
115      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
116      * otherwise the caller will revert the transaction. The selector to be
117      * returned can be obtained as `this.onERC721Received.selector`. This
118      * function MAY throw to revert and reject the transfer.
119      * Note: the ERC721 contract address is always the message sender.
120      * @param operator The address which called `safeTransferFrom` function
121      * @param from The address which previously owned the token
122      * @param tokenId The NFT identifier which is being transferred
123      * @param data Additional data with no specified format
124      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
125      */
126     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
127     public returns (bytes4);
128 }
129 
130 /**
131  * @dev Wrappers over Solidity's arithmetic operations with added overflow
132  * checks.
133  *
134  * Arithmetic operations in Solidity wrap on overflow. This can easily result
135  * in bugs, because programmers usually assume that an overflow raises an
136  * error, which is the standard behavior in high level programming languages.
137  * `SafeMath` restores this intuition by reverting the transaction when an
138  * operation overflows.
139  *
140  * Using this library instead of the unchecked operations eliminates an entire
141  * class of bugs, so it's recommended to use it always.
142  */
143 library SafeMath {
144     /**
145      * @dev Returns the addition of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `+` operator.
149      *
150      * Requirements:
151      * - Addition cannot overflow.
152      */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "SafeMath: addition overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      * - Subtraction cannot overflow.
181      *
182      * _Available since v2.4.0._
183      */
184     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
202         // benefit is lost if 'b' is also tested.
203         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
204         if (a == 0) {
205             return 0;
206         }
207 
208         uint256 c = a * b;
209         require(c / a == b, "SafeMath: multiplication overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b) internal pure returns (uint256) {
226         return div(a, b, "SafeMath: division by zero");
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      *
240      * _Available since v2.4.0._
241      */
242     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         // Solidity only automatically asserts when dividing by 0
244         require(b > 0, errorMessage);
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         return mod(a, b, "SafeMath: modulo by zero");
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts with custom message when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      * - The divisor cannot be zero.
276      *
277      * _Available since v2.4.0._
278      */
279     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b != 0, errorMessage);
281         return a % b;
282     }
283 }
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * This test is non-exhaustive, and there may be false-negatives: during the
293      * execution of a contract's constructor, its address will be reported as
294      * not containing a contract.
295      *
296      * IMPORTANT: It is unsafe to assume that an address for which this
297      * function returns false is an externally-owned account (EOA) and not a
298      * contract.
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies in extcodesize, which returns 0 for contracts in
302         // construction, since the code is only stored at the end of the
303         // constructor execution.
304 
305         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
306         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
307         // for accounts without code, i.e. `keccak256('')`
308         bytes32 codehash;
309         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
310         // solhint-disable-next-line no-inline-assembly
311         assembly { codehash := extcodehash(account) }
312         return (codehash != 0x0 && codehash != accountHash);
313     }
314 
315     /**
316      * @dev Converts an `address` into `address payable`. Note that this is
317      * simply a type cast: the actual underlying value is not changed.
318      *
319      * _Available since v2.4.0._
320      */
321     function toPayable(address account) internal pure returns (address payable) {
322         return address(uint160(account));
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      *
341      * _Available since v2.4.0._
342      */
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         // solhint-disable-next-line avoid-call-value
347         (bool success, ) = recipient.call.value(amount)("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 }
351 
352 /**
353  * @title Counters
354  * @author Matt Condon (@shrugs)
355  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
356  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
357  *
358  * Include with `using Counters for Counters.Counter;`
359  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
360  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
361  * directly accessed.
362  */
363 library Counters {
364     using SafeMath for uint256;
365 
366     struct Counter {
367         // This variable should never be directly accessed by users of the library: interactions must be restricted to
368         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
369         // this feature: see https://github.com/ethereum/solidity/issues/4637
370         uint256 _value; // default: 0
371     }
372 
373     function current(Counter storage counter) internal view returns (uint256) {
374         return counter._value;
375     }
376 
377     function increment(Counter storage counter) internal {
378         counter._value += 1;
379     }
380 
381     function decrement(Counter storage counter) internal {
382         counter._value = counter._value.sub(1);
383     }
384 }
385 
386 /**
387  * @dev Implementation of the {IERC165} interface.
388  *
389  * Contracts may inherit from this and call {_registerInterface} to declare
390  * their support of an interface.
391  */
392 contract ERC165 is IERC165 {
393     /*
394      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
395      */
396     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
397 
398     /**
399      * @dev Mapping of interface ids to whether or not it's supported.
400      */
401     mapping(bytes4 => bool) private _supportedInterfaces;
402 
403     constructor () internal {
404         // Derived contracts need only register support for their own interfaces,
405         // we register support for ERC165 itself here
406         _registerInterface(_INTERFACE_ID_ERC165);
407     }
408 
409     /**
410      * @dev See {IERC165-supportsInterface}.
411      *
412      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
415         return _supportedInterfaces[interfaceId];
416     }
417 
418     /**
419      * @dev Registers the contract as an implementer of the interface defined by
420      * `interfaceId`. Support of the actual ERC165 interface is automatic and
421      * registering its interface id is not required.
422      *
423      * See {IERC165-supportsInterface}.
424      *
425      * Requirements:
426      *
427      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
428      */
429     function _registerInterface(bytes4 interfaceId) internal {
430         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
431         _supportedInterfaces[interfaceId] = true;
432     }
433 }
434 
435 /**
436  * @title ERC721 Non-Fungible Token Standard basic implementation
437  * @dev see https://eips.ethereum.org/EIPS/eip-721
438  */
439 contract ERC721 is Context, ERC165, IERC721 {
440     using SafeMath for uint256;
441     using Address for address;
442     using Counters for Counters.Counter;
443 
444     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
445     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
446     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
447 
448     // Mapping from token ID to owner
449     mapping (uint256 => address) private _tokenOwner;
450 
451     // Mapping from token ID to approved address
452     mapping (uint256 => address) private _tokenApprovals;
453 
454     // Mapping from owner to number of owned token
455     mapping (address => Counters.Counter) private _ownedTokensCount;
456 
457     // Mapping from owner to operator approvals
458     mapping (address => mapping (address => bool)) private _operatorApprovals;
459 
460     /*
461      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
462      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
463      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
464      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
465      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
466      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
467      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
468      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
469      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
470      *
471      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
472      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
473      */
474     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
475 
476     constructor () public {
477         // register the supported interfaces to conform to ERC721 via ERC165
478         _registerInterface(_INTERFACE_ID_ERC721);
479     }
480 
481     /**
482      * @dev Gets the balance of the specified address.
483      * @param owner address to query the balance of
484      * @return uint256 representing the amount owned by the passed address
485      */
486     function balanceOf(address owner) public view returns (uint256) {
487         require(owner != address(0), "ERC721: balance query for the zero address");
488 
489         return _ownedTokensCount[owner].current();
490     }
491 
492     /**
493      * @dev Gets the owner of the specified token ID.
494      * @param tokenId uint256 ID of the token to query the owner of
495      * @return address currently marked as the owner of the given token ID
496      */
497     function ownerOf(uint256 tokenId) public view returns (address) {
498         address owner = _tokenOwner[tokenId];
499         require(owner != address(0), "ERC721: owner query for nonexistent token");
500 
501         return owner;
502     }
503 
504     /**
505      * @dev Approves another address to transfer the given token ID
506      * The zero address indicates there is no approved address.
507      * There can only be one approved address per token at a given time.
508      * Can only be called by the token owner or an approved operator.
509      * @param to address to be approved for the given token ID
510      * @param tokenId uint256 ID of the token to be approved
511      */
512     function approve(address to, uint256 tokenId) public {
513         address owner = ownerOf(tokenId);
514         require(to != owner, "ERC721: approval to current owner");
515 
516         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
517             "ERC721: approve caller is not owner nor approved for all"
518         );
519 
520         _tokenApprovals[tokenId] = to;
521         emit Approval(owner, to, tokenId);
522     }
523 
524     /**
525      * @dev Gets the approved address for a token ID, or zero if no address set
526      * Reverts if the token ID does not exist.
527      * @param tokenId uint256 ID of the token to query the approval of
528      * @return address currently approved for the given token ID
529      */
530     function getApproved(uint256 tokenId) public view returns (address) {
531         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
532 
533         return _tokenApprovals[tokenId];
534     }
535 
536     /**
537      * @dev Sets or unsets the approval of a given operator
538      * An operator is allowed to transfer all tokens of the sender on their behalf.
539      * @param to operator address to set the approval
540      * @param approved representing the status of the approval to be set
541      */
542     function setApprovalForAll(address to, bool approved) public {
543         require(to != _msgSender(), "ERC721: approve to caller");
544 
545         _operatorApprovals[_msgSender()][to] = approved;
546         emit ApprovalForAll(_msgSender(), to, approved);
547     }
548 
549     /**
550      * @dev Tells whether an operator is approved by a given owner.
551      * @param owner owner address which you want to query the approval of
552      * @param operator operator address which you want to query the approval of
553      * @return bool whether the given operator is approved by the given owner
554      */
555     function isApprovedForAll(address owner, address operator) public view returns (bool) {
556         return _operatorApprovals[owner][operator];
557     }
558 
559     /**
560      * @dev Transfers the ownership of a given token ID to another address.
561      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
562      * Requires the msg.sender to be the owner, approved, or operator.
563      * @param from current owner of the token
564      * @param to address to receive the ownership of the given token ID
565      * @param tokenId uint256 ID of the token to be transferred
566      */
567     function transferFrom(address from, address to, uint256 tokenId) public {
568         //solhint-disable-next-line max-line-length
569         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
570 
571         _transferFrom(from, to, tokenId);
572     }
573 
574     /**
575      * @dev Safely transfers the ownership of a given token ID to another address
576      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
577      * which is called upon a safe transfer, and return the magic value
578      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
579      * the transfer is reverted.
580      * Requires the msg.sender to be the owner, approved, or operator
581      * @param from current owner of the token
582      * @param to address to receive the ownership of the given token ID
583      * @param tokenId uint256 ID of the token to be transferred
584      */
585     function safeTransferFrom(address from, address to, uint256 tokenId) public {
586         safeTransferFrom(from, to, tokenId, "");
587     }
588 
589     /**
590      * @dev Safely transfers the ownership of a given token ID to another address
591      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
592      * which is called upon a safe transfer, and return the magic value
593      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
594      * the transfer is reverted.
595      * Requires the _msgSender() to be the owner, approved, or operator
596      * @param from current owner of the token
597      * @param to address to receive the ownership of the given token ID
598      * @param tokenId uint256 ID of the token to be transferred
599      * @param _data bytes data to send along with a safe transfer check
600      */
601     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
602         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
603         _safeTransferFrom(from, to, tokenId, _data);
604     }
605 
606     /**
607      * @dev Safely transfers the ownership of a given token ID to another address
608      * If the target address is a contract, it must implement `onERC721Received`,
609      * which is called upon a safe transfer, and return the magic value
610      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
611      * the transfer is reverted.
612      * Requires the msg.sender to be the owner, approved, or operator
613      * @param from current owner of the token
614      * @param to address to receive the ownership of the given token ID
615      * @param tokenId uint256 ID of the token to be transferred
616      * @param _data bytes data to send along with a safe transfer check
617      */
618     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
619         _transferFrom(from, to, tokenId);
620         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
621     }
622 
623     /**
624      * @dev Returns whether the specified token exists.
625      * @param tokenId uint256 ID of the token to query the existence of
626      * @return bool whether the token exists
627      */
628     function _exists(uint256 tokenId) internal view returns (bool) {
629         address owner = _tokenOwner[tokenId];
630         return owner != address(0);
631     }
632 
633     /**
634      * @dev Returns whether the given spender can transfer a given token ID.
635      * @param spender address of the spender to query
636      * @param tokenId uint256 ID of the token to be transferred
637      * @return bool whether the msg.sender is approved for the given token ID,
638      * is an operator of the owner, or is the owner of the token
639      */
640     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
641         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
642         address owner = ownerOf(tokenId);
643         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
644     }
645 
646     /**
647      * @dev Internal function to safely mint a new token.
648      * Reverts if the given token ID already exists.
649      * If the target address is a contract, it must implement `onERC721Received`,
650      * which is called upon a safe transfer, and return the magic value
651      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
652      * the transfer is reverted.
653      * @param to The address that will own the minted token
654      * @param tokenId uint256 ID of the token to be minted
655      */
656     function _safeMint(address to, uint256 tokenId) internal {
657         _safeMint(to, tokenId, "");
658     }
659 
660     /**
661      * @dev Internal function to safely mint a new token.
662      * Reverts if the given token ID already exists.
663      * If the target address is a contract, it must implement `onERC721Received`,
664      * which is called upon a safe transfer, and return the magic value
665      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
666      * the transfer is reverted.
667      * @param to The address that will own the minted token
668      * @param tokenId uint256 ID of the token to be minted
669      * @param _data bytes data to send along with a safe transfer check
670      */
671     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
672         _mint(to, tokenId);
673         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
674     }
675 
676     /**
677      * @dev Internal function to mint a new token.
678      * Reverts if the given token ID already exists.
679      * @param to The address that will own the minted token
680      * @param tokenId uint256 ID of the token to be minted
681      */
682     function _mint(address to, uint256 tokenId) internal {
683         require(to != address(0), "ERC721: mint to the zero address");
684         require(!_exists(tokenId), "ERC721: token already minted");
685 
686         _tokenOwner[tokenId] = to;
687         _ownedTokensCount[to].increment();
688 
689         emit Transfer(address(0), to, tokenId);
690     }
691 
692     /**
693      * @dev Internal function to burn a specific token.
694      * Reverts if the token does not exist.
695      * Deprecated, use {_burn} instead.
696      * @param owner owner of the token to burn
697      * @param tokenId uint256 ID of the token being burned
698      */
699     function _burn(address owner, uint256 tokenId) internal {
700         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
701 
702         _clearApproval(tokenId);
703 
704         _ownedTokensCount[owner].decrement();
705         _tokenOwner[tokenId] = address(0);
706 
707         emit Transfer(owner, address(0), tokenId);
708     }
709 
710     /**
711      * @dev Internal function to burn a specific token.
712      * Reverts if the token does not exist.
713      * @param tokenId uint256 ID of the token being burned
714      */
715     function _burn(uint256 tokenId) internal {
716         _burn(ownerOf(tokenId), tokenId);
717     }
718 
719     /**
720      * @dev Internal function to transfer ownership of a given token ID to another address.
721      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
722      * @param from current owner of the token
723      * @param to address to receive the ownership of the given token ID
724      * @param tokenId uint256 ID of the token to be transferred
725      */
726     function _transferFrom(address from, address to, uint256 tokenId) internal {
727         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
728         require(to != address(0), "ERC721: transfer to the zero address");
729 
730         _clearApproval(tokenId);
731 
732         _ownedTokensCount[from].decrement();
733         _ownedTokensCount[to].increment();
734 
735         _tokenOwner[tokenId] = to;
736 
737         emit Transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
742      * The call is not executed if the target address is not a contract.
743      *
744      * This function is deprecated.
745      * @param from address representing the previous owner of the given token ID
746      * @param to target address that will receive the tokens
747      * @param tokenId uint256 ID of the token to be transferred
748      * @param _data bytes optional data to send along with the call
749      * @return bool whether the call correctly returned the expected magic value
750      */
751     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
752         internal returns (bool)
753     {
754         if (!to.isContract()) {
755             return true;
756         }
757 
758         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
759         return (retval == _ERC721_RECEIVED);
760     }
761 
762     /**
763      * @dev Private function to clear current approval of a given token ID.
764      * @param tokenId uint256 ID of the token to be transferred
765      */
766     function _clearApproval(uint256 tokenId) private {
767         if (_tokenApprovals[tokenId] != address(0)) {
768             _tokenApprovals[tokenId] = address(0);
769         }
770     }
771 }
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
775  * @dev See https://eips.ethereum.org/EIPS/eip-721
776  */
777 contract IERC721Enumerable is IERC721 {
778     function totalSupply() public view returns (uint256);
779     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
780 
781     function tokenByIndex(uint256 index) public view returns (uint256);
782 }
783 
784 /**
785  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
786  * @dev See https://eips.ethereum.org/EIPS/eip-721
787  */
788 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
789     // Mapping from owner to list of owned token IDs
790     mapping(address => uint256[]) private _ownedTokens;
791 
792     // Mapping from token ID to index of the owner tokens list
793     mapping(uint256 => uint256) private _ownedTokensIndex;
794 
795     // Array with all token ids, used for enumeration
796     uint256[] private _allTokens;
797 
798     // Mapping from token id to position in the allTokens array
799     mapping(uint256 => uint256) private _allTokensIndex;
800 
801     /*
802      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
803      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
804      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
805      *
806      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
807      */
808     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
809 
810     /**
811      * @dev Constructor function.
812      */
813     constructor () public {
814         // register the supported interface to conform to ERC721Enumerable via ERC165
815         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
816     }
817 
818     /**
819      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
820      * @param owner address owning the tokens list to be accessed
821      * @param index uint256 representing the index to be accessed of the requested tokens list
822      * @return uint256 token ID at the given index of the tokens list owned by the requested address
823      */
824     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
825         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
826         return _ownedTokens[owner][index];
827     }
828 
829     /**
830      * @dev Gets the total amount of tokens stored by the contract.
831      * @return uint256 representing the total amount of tokens
832      */
833     function totalSupply() public view returns (uint256) {
834         return _allTokens.length;
835     }
836 
837     /**
838      * @dev Gets the token ID at a given index of all the tokens in this contract
839      * Reverts if the index is greater or equal to the total number of tokens.
840      * @param index uint256 representing the index to be accessed of the tokens list
841      * @return uint256 token ID at the given index of the tokens list
842      */
843     function tokenByIndex(uint256 index) public view returns (uint256) {
844         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
845         return _allTokens[index];
846     }
847 
848     /**
849      * @dev Internal function to transfer ownership of a given token ID to another address.
850      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
851      * @param from current owner of the token
852      * @param to address to receive the ownership of the given token ID
853      * @param tokenId uint256 ID of the token to be transferred
854      */
855     function _transferFrom(address from, address to, uint256 tokenId) internal {
856         super._transferFrom(from, to, tokenId);
857 
858         _removeTokenFromOwnerEnumeration(from, tokenId);
859 
860         _addTokenToOwnerEnumeration(to, tokenId);
861     }
862 
863     /**
864      * @dev Internal function to mint a new token.
865      * Reverts if the given token ID already exists.
866      * @param to address the beneficiary that will own the minted token
867      * @param tokenId uint256 ID of the token to be minted
868      */
869     function _mint(address to, uint256 tokenId) internal {
870         super._mint(to, tokenId);
871 
872         _addTokenToOwnerEnumeration(to, tokenId);
873 
874         _addTokenToAllTokensEnumeration(tokenId);
875     }
876 
877     /**
878      * @dev Internal function to burn a specific token.
879      * Reverts if the token does not exist.
880      * Deprecated, use {ERC721-_burn} instead.
881      * @param owner owner of the token to burn
882      * @param tokenId uint256 ID of the token being burned
883      */
884     function _burn(address owner, uint256 tokenId) internal {
885         super._burn(owner, tokenId);
886 
887         _removeTokenFromOwnerEnumeration(owner, tokenId);
888         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
889         _ownedTokensIndex[tokenId] = 0;
890 
891         _removeTokenFromAllTokensEnumeration(tokenId);
892     }
893 
894     /**
895      * @dev Gets the list of token IDs of the requested owner.
896      * @param owner address owning the tokens
897      * @return uint256[] List of token IDs owned by the requested address
898      */
899     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
900         return _ownedTokens[owner];
901     }
902 
903     /**
904      * @dev Private function to add a token to this extension's ownership-tracking data structures.
905      * @param to address representing the new owner of the given token ID
906      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
907      */
908     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
909         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
910         _ownedTokens[to].push(tokenId);
911     }
912 
913     /**
914      * @dev Private function to add a token to this extension's token tracking data structures.
915      * @param tokenId uint256 ID of the token to be added to the tokens list
916      */
917     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
918         _allTokensIndex[tokenId] = _allTokens.length;
919         _allTokens.push(tokenId);
920     }
921 
922     /**
923      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
924      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
925      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
926      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
927      * @param from address representing the previous owner of the given token ID
928      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
929      */
930     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
931         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
932         // then delete the last slot (swap and pop).
933 
934         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
935         uint256 tokenIndex = _ownedTokensIndex[tokenId];
936 
937         // When the token to delete is the last token, the swap operation is unnecessary
938         if (tokenIndex != lastTokenIndex) {
939             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
940 
941             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
942             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
943         }
944 
945         // This also deletes the contents at the last position of the array
946         _ownedTokens[from].length--;
947 
948         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
949         // lastTokenId, or just over the end of the array if the token was the last one).
950     }
951 
952     /**
953      * @dev Private function to remove a token from this extension's token tracking data structures.
954      * This has O(1) time complexity, but alters the order of the _allTokens array.
955      * @param tokenId uint256 ID of the token to be removed from the tokens list
956      */
957     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
958         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
959         // then delete the last slot (swap and pop).
960 
961         uint256 lastTokenIndex = _allTokens.length.sub(1);
962         uint256 tokenIndex = _allTokensIndex[tokenId];
963 
964         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
965         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
966         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
967         uint256 lastTokenId = _allTokens[lastTokenIndex];
968 
969         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
970         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
971 
972         // This also deletes the contents at the last position of the array
973         _allTokens.length--;
974         _allTokensIndex[tokenId] = 0;
975     }
976 }
977 
978 /**
979  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
980  * @dev See https://eips.ethereum.org/EIPS/eip-721
981  */
982 contract IERC721Metadata is IERC721 {
983     function name() external view returns (string memory);
984     function symbol() external view returns (string memory);
985     function tokenURI(uint256 tokenId) external view returns (string memory);
986 }
987 
988 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
989     // Token name
990     string private _name;
991 
992     // Token symbol
993     string private _symbol;
994 
995     // Optional mapping for token URIs
996     mapping(uint256 => string) private _tokenURIs;
997     /*
998      *     bytes4(keccak256('name()')) == 0x06fdde03
999      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1000      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1001      *
1002      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1003      */
1004     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1005 
1006     /**
1007      * @dev Constructor function
1008      */
1009     constructor (string memory name, string memory symbol) public {
1010         _name = name;
1011         _symbol = symbol;
1012 
1013         // register the supported interfaces to conform to ERC721 via ERC165
1014         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1015     }
1016 
1017     /**
1018      * @dev Gets the token name.
1019      * @return string representing the token name
1020      */
1021     function name() external view returns (string memory) {
1022         return _name;
1023     }
1024 
1025     /**
1026      * @dev Gets the token symbol.
1027      * @return string representing the token symbol
1028      */
1029     function symbol() external view returns (string memory) {
1030         return _symbol;
1031     }
1032 
1033 
1034     /**
1035      * @dev Returns an URI for a given token ID.
1036      * Throws if the token ID does not exist. May return an empty string.
1037      * @param tokenId uint256 ID of the token to query
1038      */
1039      
1040     /*
1041         function tokenURI(uint256 tokenId) external view returns (string memory) {
1042             require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1043     //        return _tokenURIs[tokenId];
1044 
1045             return string(abi.encodePacked("https://ChainScrape3.damo1884.repl.co/api/mint?id=", id_to_value[tokenId]));
1046         }
1047     */
1048 
1049     /**
1050      * @dev Internal function to set the token URI for a given token.
1051      * Reverts if the token ID does not exist.
1052      * @param tokenId uint256 ID of the token to set its URI
1053      * @param uri string URI to assign
1054      */
1055     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1056         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1057         _tokenURIs[tokenId] = uri;
1058     }
1059 
1060     /**
1061      * @dev Internal function to burn a specific token.
1062      * Reverts if the token does not exist.
1063      * Deprecated, use _burn(uint256) instead.
1064      * @param owner owner of the token to burn
1065      * @param tokenId uint256 ID of the token being burned by the msg.sender
1066      */
1067     function _burn(address owner, uint256 tokenId) internal {
1068         super._burn(owner, tokenId);
1069 
1070         // Clear metadata (if any)
1071         if (bytes(_tokenURIs[tokenId]).length != 0) {
1072             delete _tokenURIs[tokenId];
1073         }
1074     }
1075 }
1076 
1077 /**
1078  * @title Full ERC721 Token
1079  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1080  * Moreover, it includes approve all functionality using operator terminology.
1081  *
1082  * See https://eips.ethereum.org/EIPS/eip-721
1083  */
1084 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1085     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1086         // solhint-disable-previous-line no-empty-blocks
1087     }
1088 }
1089 
1090 library Random
1091 {
1092     /**
1093     * Initialize the pool with the entropy of the blockhashes of the blocks in the closed interval [earliestBlock, latestBlock]
1094     * The argument "seed" is optional and can be left zero in most cases.
1095     * This extra seed allows you to select a different sequence of random numbers for the same block range.
1096     */
1097     function init(uint256 earliestBlock, uint256 latestBlock, uint256 seed) internal view returns (bytes32[] memory) {
1098         require(block.number-1 >= latestBlock && latestBlock >= earliestBlock, "Random.init: invalid block interval");
1099         bytes32[] memory pool = new bytes32[](latestBlock-earliestBlock+2);
1100         bytes32 salt = keccak256(abi.encodePacked(block.number,seed));
1101         for(uint256 i = 0; i <= latestBlock-earliestBlock; i++) {
1102             // Add some salt to each blockhash so that we don't reuse those hash chains
1103             // when this function gets called again in another block.
1104             pool[i+1] = keccak256(abi.encodePacked(blockhash(earliestBlock+i),salt));
1105         }
1106         return pool;
1107     }
1108 
1109     /**
1110     * Initialize the pool from the latest "num" blocks.
1111     */
1112     function initLatest(uint256 num, uint256 seed) internal view returns (bytes32[] memory) {
1113         return init(block.number-num, block.number-1, seed);
1114     }
1115 
1116     /**
1117     * Advances to the next 256-bit random number in the pool of hash chains.
1118     */
1119     function next(bytes32[] memory pool) internal pure returns (uint256) {
1120         require(pool.length > 1, "Random.next: invalid pool");
1121         uint256 roundRobinIdx = uint256(pool[0]) % (pool.length-1) + 1;
1122         bytes32 hash = keccak256(abi.encodePacked(pool[roundRobinIdx]));
1123         pool[0] = bytes32(uint256(pool[0])+1);
1124         pool[roundRobinIdx] = hash;
1125         return uint256(hash);
1126     }
1127 
1128     /**
1129     * Produces random integer values, uniformly distributed on the closed interval [a, b]
1130     */
1131     function uniform(bytes32[] memory pool, int256 a, int256 b) internal pure returns (int256) {
1132         require(a <= b, "Random.uniform: invalid interval");
1133         return int256(next(pool)%uint256(b-a+1))+a;
1134     }
1135 }
1136 
1137 
1138 contract CryptoMorphMint is ERC721Full {
1139     using SafeMath for uint256;
1140 
1141     mapping (uint256 => uint) internal idToSymmetry;
1142     mapping (uint256 => uint) internal idToColors;
1143 
1144     constructor() ERC721Full("CryptoMorphMint", "CMMINT") public {
1145         _registerToken(1, 1);
1146         _registerToken(1, 2);
1147         _registerToken(2, 2);
1148         _registerToken(2, 3);
1149         _registerToken(3, 3);
1150         _registerToken(3, 4);
1151         _registerToken(4, 4);
1152         _registerToken(4, 5);
1153         _registerToken(5, 5);
1154         _registerToken(5, 6);
1155         _registerToken(6, 6);
1156         _registerToken(6, 7);
1157         _registerToken(7, 7);
1158         _registerToken(7, 8);
1159         _registerToken(8, 8);
1160         _registerToken(8, 9);
1161         _registerToken(7, 9);
1162         _registerToken(7, 10);
1163         _registerToken(6, 10);
1164         _registerToken(6, 11);
1165         _registerToken(5, 11);
1166         _registerToken(5, 12);
1167         _registerToken(4, 12);
1168         _registerToken(4, 13);
1169         _registerToken(3, 13);
1170         _registerToken(3, 14);
1171         _registerToken(2, 14);
1172         _registerToken(2, 15);
1173         _registerToken(1, 15);
1174         _registerToken(1, 16);
1175     }
1176 
1177     function getRandomColors(uint256 seed) internal view returns (uint256 colorsID) {
1178 
1179       bytes32[] memory pool = Random.initLatest(4, seed);
1180 
1181       uint256 colorsRNG = uint256(Random.uniform(pool, 1, 10000));
1182       if (colorsRNG <= 100) {
1183         colorsID = 1;
1184       } else if (colorsRNG <= 500) {
1185         colorsID = 2;
1186       } else if (colorsRNG <= 1000) {
1187         colorsID = 3;
1188       } else if (colorsRNG <= 3000) {
1189         colorsID = 4;
1190       } else if (colorsRNG <= 7000) {
1191         colorsID = 5;
1192       } else if (colorsRNG <= 9000) {
1193         colorsID = 6;
1194       } else if (colorsRNG <= 9500) {
1195         colorsID = 7;
1196       } else if (colorsRNG <= 9900) {
1197         colorsID = 8;
1198       } else {
1199         colorsID = 1;
1200       }
1201     }
1202 
1203     function getRandomSymmetry(uint256 seed) internal view returns (uint256 symmetryID) {
1204 
1205       bytes32[] memory pool = Random.initLatest(5, seed);
1206 
1207       uint256 symmetryRNG = uint256(Random.uniform(pool, 1, 10000));
1208 
1209       if (symmetryRNG <= 100) {
1210         symmetryID = 1;
1211       } else if (symmetryRNG <= 500) {
1212         symmetryID = 2;
1213       } else if (symmetryRNG <= 1000) {
1214         symmetryID = 3;
1215       } else if (symmetryRNG <= 1500) {
1216         symmetryID = 4;
1217       } else if (symmetryRNG <= 2000) {
1218         symmetryID = 5;
1219       } else if (symmetryRNG <= 2500) {
1220         symmetryID = 6;
1221       } else if (symmetryRNG <= 3000) {
1222         symmetryID = 7;
1223       } else if (symmetryRNG <= 3500) {
1224         symmetryID = 8;
1225       } else if (symmetryRNG <= 4000) {
1226         symmetryID = 9;
1227       } else if (symmetryRNG <= 5000) {
1228         symmetryID = 10;
1229       } else if (symmetryRNG <= 6000) {
1230         symmetryID = 11;
1231       } else if (symmetryRNG <= 7000) {
1232         symmetryID = 12;
1233       } else if (symmetryRNG <= 8000) {
1234         symmetryID = 13;
1235       } else if (symmetryRNG <= 9000) {
1236         symmetryID = 14;
1237       } else if (symmetryRNG <= 9500) {
1238         symmetryID = 15;
1239       } else if (symmetryRNG <= 9900) {
1240         symmetryID = 16;
1241       } else {
1242         symmetryID = 1;
1243       }
1244     }
1245 
1246     function _registerToken(uint256 colors, uint256 symmetry) private {
1247         uint256 tokenId = totalSupply();
1248         idToSymmetry[tokenId] = symmetry;
1249         idToColors[tokenId] = colors;
1250         _mint(msg.sender, tokenId);
1251     }
1252 
1253     uint public constant tokenLimit = 9999;
1254 
1255     function createCryptoMorph(uint256 seed) public payable {
1256 
1257       if (totalSupply() < 1000) {
1258         require(msg.value == 6 finney);
1259       } else if (totalSupply() < 2000) {
1260         require(msg.value == 8 finney);
1261       } else if (totalSupply() < 3000) {
1262         require(msg.value == 10 finney);
1263       } else if (totalSupply() < 4000) {
1264         require(msg.value == 15 finney);
1265       } else if (totalSupply() < 5000) {
1266         require(msg.value == 20 finney);
1267       } else if (totalSupply() < 6000) {
1268         require(msg.value == 25 finney);
1269       } else if (totalSupply() < 7000) {
1270         require(msg.value == 30 finney);
1271       } else if (totalSupply() < 8000) {
1272         require(msg.value == 35 finney);
1273       } else if (totalSupply() < 9000) {
1274         require(msg.value == 40 finney);
1275       } else {
1276         require(msg.value == 45 finney);
1277       }
1278 
1279       require(totalSupply() <= tokenLimit, "CryptoMorph Mint sale has completed. They are now only available on the secondary market. ");
1280 
1281       address(0xaa02859173c1f351Ffb4f015A98Fa66200d95687).transfer(msg.value);
1282 
1283       uint256 symmetry = getRandomSymmetry(seed);
1284       uint256 colors = getRandomColors(seed);
1285 
1286       _registerToken(colors, symmetry);
1287     }
1288 
1289    function integerToString(uint _i) internal pure
1290       returns (string memory) {
1291 
1292       if (_i == 0) {
1293          return "0";
1294       }
1295       uint j = _i;
1296       uint len;
1297 
1298       while (j != 0) {
1299          len++;
1300          j /= 10;
1301       }
1302       bytes memory bstr = new bytes(len);
1303       uint k = len - 1;
1304 
1305       while (_i != 0) {
1306          bstr[k--] = byte(uint8(48 + _i % 10));
1307          _i /= 10;
1308       }
1309       return string(bstr);
1310    }
1311 
1312 
1313     function tokenURI(uint256 id) external view returns (string memory) {
1314         require(_exists(id), "ERC721Metadata: URI query for nonexistent token");
1315         return string(abi.encodePacked("https://ChainScrape3.damo1884.repl.co/api/mint?id=", integerToString(id)));
1316     }
1317 
1318     function getSymmetry(uint id) public view returns (uint256 symmetry) {
1319         return idToSymmetry[id];
1320     }
1321 
1322     function getColors(uint id) public view returns (uint256 colors) {
1323         return idToColors[id];
1324     }
1325 }