1 pragma solidity ^0.5.12;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Interface of the ERC165 standard, as defined in the
31  * https://eips.ethereum.org/EIPS/eip-165[EIP].
32  *
33  * Implementers can declare support of contract interfaces, which can then be
34  * queried by others ({ERC165Checker}).
35  *
36  * For an implementation, see {ERC165}.
37  */
38 interface IERC165 {
39     /**
40      * @dev Returns true if this contract implements the interface defined by
41      * `interfaceId`. See the corresponding
42      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
43      * to learn more about how these ids are created.
44      *
45      * This function call must use less than 30 000 gas.
46      */
47     function supportsInterface(bytes4 interfaceId) external view returns (bool);
48 }
49 
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 contract IERC721 is IERC165 {
54     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of NFTs in `owner`'s account.
60      */
61     function balanceOf(address owner) public view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the NFT specified by `tokenId`.
65      */
66     function ownerOf(uint256 tokenId) public view returns (address owner);
67 
68     /**
69      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
70      * another (`to`).
71      *
72      *
73      *
74      * Requirements:
75      * - `from`, `to` cannot be zero.
76      * - `tokenId` must be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this
78      * NFT by either {approve} or {setApprovalForAll}.
79      */
80     function safeTransferFrom(address from, address to, uint256 tokenId) public;
81     /**
82      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
83      * another (`to`).
84      *
85      * Requirements:
86      * - If the caller is not `from`, it must be approved to move this NFT by
87      * either {approve} or {setApprovalForAll}.
88      */
89     function transferFrom(address from, address to, uint256 tokenId) public;
90     function approve(address to, uint256 tokenId) public;
91     function getApproved(uint256 tokenId) public view returns (address operator);
92 
93     function setApprovalForAll(address operator, bool _approved) public;
94     function isApprovedForAll(address owner, address operator) public view returns (bool);
95 
96 
97     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
98 }
99 
100 /**
101  * @title ERC721 token receiver interface
102  * @dev Interface for any contract that wants to support safeTransfers
103  * from ERC721 asset contracts.
104  */
105 contract IERC721Receiver {
106     /**
107      * @notice Handle the receipt of an NFT
108      * @dev The ERC721 smart contract calls this function on the recipient
109      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
110      * otherwise the caller will revert the transaction. The selector to be
111      * returned can be obtained as `this.onERC721Received.selector`. This
112      * function MAY throw to revert and reject the transfer.
113      * Note: the ERC721 contract address is always the message sender.
114      * @param operator The address which called `safeTransferFrom` function
115      * @param from The address which previously owned the token
116      * @param tokenId The NFT identifier which is being transferred
117      * @param data Additional data with no specified format
118      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
119      */
120     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
121     public returns (bytes4);
122 }
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 library SafeMath {
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      * - Subtraction cannot overflow.
175      *
176      * _Available since v2.4.0._
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      * - The divisor cannot be zero.
233      *
234      * _Available since v2.4.0._
235      */
236     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         // Solidity only automatically asserts when dividing by 0
238         require(b > 0, errorMessage);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      * - The divisor cannot be zero.
270      *
271      * _Available since v2.4.0._
272      */
273     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b != 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * This test is non-exhaustive, and there may be false-negatives: during the
287      * execution of a contract's constructor, its address will be reported as
288      * not containing a contract.
289      *
290      * IMPORTANT: It is unsafe to assume that an address for which this
291      * function returns false is an externally-owned account (EOA) and not a
292      * contract.
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies in extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != 0x0 && codehash != accountHash);
307     }
308 
309     /**
310      * @dev Converts an `address` into `address payable`. Note that this is
311      * simply a type cast: the actual underlying value is not changed.
312      *
313      * _Available since v2.4.0._
314      */
315     function toPayable(address account) internal pure returns (address payable) {
316         return address(uint160(account));
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      *
335      * _Available since v2.4.0._
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(address(this).balance >= amount, "Address: insufficient balance");
339 
340         // solhint-disable-next-line avoid-call-value
341         (bool success, ) = recipient.call.value(amount)("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 }
345 
346 /**
347  * @title Counters
348  * @author Matt Condon (@shrugs)
349  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
350  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
351  *
352  * Include with `using Counters for Counters.Counter;`
353  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
354  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
355  * directly accessed.
356  */
357 library Counters {
358     using SafeMath for uint256;
359 
360     struct Counter {
361         // This variable should never be directly accessed by users of the library: interactions must be restricted to
362         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
363         // this feature: see https://github.com/ethereum/solidity/issues/4637
364         uint256 _value; // default: 0
365     }
366 
367     function current(Counter storage counter) internal view returns (uint256) {
368         return counter._value;
369     }
370 
371     function increment(Counter storage counter) internal {
372         counter._value += 1;
373     }
374 
375     function decrement(Counter storage counter) internal {
376         counter._value = counter._value.sub(1);
377     }
378 }
379 
380 /**
381  * @dev Implementation of the {IERC165} interface.
382  *
383  * Contracts may inherit from this and call {_registerInterface} to declare
384  * their support of an interface.
385  */
386 contract ERC165 is IERC165 {
387     /*
388      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
389      */
390     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
391 
392     /**
393      * @dev Mapping of interface ids to whether or not it's supported.
394      */
395     mapping(bytes4 => bool) private _supportedInterfaces;
396 
397     constructor () internal {
398         // Derived contracts need only register support for their own interfaces,
399         // we register support for ERC165 itself here
400         _registerInterface(_INTERFACE_ID_ERC165);
401     }
402 
403     /**
404      * @dev See {IERC165-supportsInterface}.
405      *
406      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
407      */
408     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
409         return _supportedInterfaces[interfaceId];
410     }
411 
412     /**
413      * @dev Registers the contract as an implementer of the interface defined by
414      * `interfaceId`. Support of the actual ERC165 interface is automatic and
415      * registering its interface id is not required.
416      *
417      * See {IERC165-supportsInterface}.
418      *
419      * Requirements:
420      *
421      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
422      */
423     function _registerInterface(bytes4 interfaceId) internal {
424         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
425         _supportedInterfaces[interfaceId] = true;
426     }
427 }
428 
429 /**
430  * @title ERC721 Non-Fungible Token Standard basic implementation
431  * @dev see https://eips.ethereum.org/EIPS/eip-721
432  */
433 contract ERC721 is Context, ERC165, IERC721 {
434     using SafeMath for uint256;
435     using Address for address;
436     using Counters for Counters.Counter;
437 
438     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
439     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
440     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
441 
442     // Mapping from token ID to owner
443     mapping (uint256 => address) private _tokenOwner;
444 
445     // Mapping from token ID to approved address
446     mapping (uint256 => address) private _tokenApprovals;
447 
448     // Mapping from owner to number of owned token
449     mapping (address => Counters.Counter) private _ownedTokensCount;
450 
451     // Mapping from owner to operator approvals
452     mapping (address => mapping (address => bool)) private _operatorApprovals;
453 
454     /*
455      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
456      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
457      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
458      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
459      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
460      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
461      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
462      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
463      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
464      *
465      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
466      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
467      */
468     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
469 
470     constructor () public {
471         // register the supported interfaces to conform to ERC721 via ERC165
472         _registerInterface(_INTERFACE_ID_ERC721);
473     }
474 
475     /**
476      * @dev Gets the balance of the specified address.
477      * @param owner address to query the balance of
478      * @return uint256 representing the amount owned by the passed address
479      */
480     function balanceOf(address owner) public view returns (uint256) {
481         require(owner != address(0), "ERC721: balance query for the zero address");
482 
483         return _ownedTokensCount[owner].current();
484     }
485 
486     /**
487      * @dev Gets the owner of the specified token ID.
488      * @param tokenId uint256 ID of the token to query the owner of
489      * @return address currently marked as the owner of the given token ID
490      */
491     function ownerOf(uint256 tokenId) public view returns (address) {
492         address owner = _tokenOwner[tokenId];
493         require(owner != address(0), "ERC721: owner query for nonexistent token");
494 
495         return owner;
496     }
497 
498     /**
499      * @dev Approves another address to transfer the given token ID
500      * The zero address indicates there is no approved address.
501      * There can only be one approved address per token at a given time.
502      * Can only be called by the token owner or an approved operator.
503      * @param to address to be approved for the given token ID
504      * @param tokenId uint256 ID of the token to be approved
505      */
506     function approve(address to, uint256 tokenId) public {
507         address owner = ownerOf(tokenId);
508         require(to != owner, "ERC721: approval to current owner");
509 
510         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
511             "ERC721: approve caller is not owner nor approved for all"
512         );
513 
514         _tokenApprovals[tokenId] = to;
515         emit Approval(owner, to, tokenId);
516     }
517 
518     /**
519      * @dev Gets the approved address for a token ID, or zero if no address set
520      * Reverts if the token ID does not exist.
521      * @param tokenId uint256 ID of the token to query the approval of
522      * @return address currently approved for the given token ID
523      */
524     function getApproved(uint256 tokenId) public view returns (address) {
525         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
526 
527         return _tokenApprovals[tokenId];
528     }
529 
530     /**
531      * @dev Sets or unsets the approval of a given operator
532      * An operator is allowed to transfer all tokens of the sender on their behalf.
533      * @param to operator address to set the approval
534      * @param approved representing the status of the approval to be set
535      */
536     function setApprovalForAll(address to, bool approved) public {
537         require(to != _msgSender(), "ERC721: approve to caller");
538 
539         _operatorApprovals[_msgSender()][to] = approved;
540         emit ApprovalForAll(_msgSender(), to, approved);
541     }
542 
543     /**
544      * @dev Tells whether an operator is approved by a given owner.
545      * @param owner owner address which you want to query the approval of
546      * @param operator operator address which you want to query the approval of
547      * @return bool whether the given operator is approved by the given owner
548      */
549     function isApprovedForAll(address owner, address operator) public view returns (bool) {
550         return _operatorApprovals[owner][operator];
551     }
552 
553     /**
554      * @dev Transfers the ownership of a given token ID to another address.
555      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
556      * Requires the msg.sender to be the owner, approved, or operator.
557      * @param from current owner of the token
558      * @param to address to receive the ownership of the given token ID
559      * @param tokenId uint256 ID of the token to be transferred
560      */
561     function transferFrom(address from, address to, uint256 tokenId) public {
562         //solhint-disable-next-line max-line-length
563         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
564 
565         _transferFrom(from, to, tokenId);
566     }
567 
568     /**
569      * @dev Safely transfers the ownership of a given token ID to another address
570      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
571      * which is called upon a safe transfer, and return the magic value
572      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
573      * the transfer is reverted.
574      * Requires the msg.sender to be the owner, approved, or operator
575      * @param from current owner of the token
576      * @param to address to receive the ownership of the given token ID
577      * @param tokenId uint256 ID of the token to be transferred
578      */
579     function safeTransferFrom(address from, address to, uint256 tokenId) public {
580         safeTransferFrom(from, to, tokenId, "");
581     }
582 
583     /**
584      * @dev Safely transfers the ownership of a given token ID to another address
585      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
586      * which is called upon a safe transfer, and return the magic value
587      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
588      * the transfer is reverted.
589      * Requires the _msgSender() to be the owner, approved, or operator
590      * @param from current owner of the token
591      * @param to address to receive the ownership of the given token ID
592      * @param tokenId uint256 ID of the token to be transferred
593      * @param _data bytes data to send along with a safe transfer check
594      */
595     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
596         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
597         _safeTransferFrom(from, to, tokenId, _data);
598     }
599 
600     /**
601      * @dev Safely transfers the ownership of a given token ID to another address
602      * If the target address is a contract, it must implement `onERC721Received`,
603      * which is called upon a safe transfer, and return the magic value
604      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
605      * the transfer is reverted.
606      * Requires the msg.sender to be the owner, approved, or operator
607      * @param from current owner of the token
608      * @param to address to receive the ownership of the given token ID
609      * @param tokenId uint256 ID of the token to be transferred
610      * @param _data bytes data to send along with a safe transfer check
611      */
612     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
613         _transferFrom(from, to, tokenId);
614         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
615     }
616 
617     /**
618      * @dev Returns whether the specified token exists.
619      * @param tokenId uint256 ID of the token to query the existence of
620      * @return bool whether the token exists
621      */
622     function _exists(uint256 tokenId) internal view returns (bool) {
623         address owner = _tokenOwner[tokenId];
624         return owner != address(0);
625     }
626 
627     /**
628      * @dev Returns whether the given spender can transfer a given token ID.
629      * @param spender address of the spender to query
630      * @param tokenId uint256 ID of the token to be transferred
631      * @return bool whether the msg.sender is approved for the given token ID,
632      * is an operator of the owner, or is the owner of the token
633      */
634     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
635         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
636         address owner = ownerOf(tokenId);
637         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
638     }
639 
640     /**
641      * @dev Internal function to safely mint a new token.
642      * Reverts if the given token ID already exists.
643      * If the target address is a contract, it must implement `onERC721Received`,
644      * which is called upon a safe transfer, and return the magic value
645      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
646      * the transfer is reverted.
647      * @param to The address that will own the minted token
648      * @param tokenId uint256 ID of the token to be minted
649      */
650     function _safeMint(address to, uint256 tokenId) internal {
651         _safeMint(to, tokenId, "");
652     }
653 
654     /**
655      * @dev Internal function to safely mint a new token.
656      * Reverts if the given token ID already exists.
657      * If the target address is a contract, it must implement `onERC721Received`,
658      * which is called upon a safe transfer, and return the magic value
659      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
660      * the transfer is reverted.
661      * @param to The address that will own the minted token
662      * @param tokenId uint256 ID of the token to be minted
663      * @param _data bytes data to send along with a safe transfer check
664      */
665     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
666         _mint(to, tokenId);
667         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
668     }
669 
670     /**
671      * @dev Internal function to mint a new token.
672      * Reverts if the given token ID already exists.
673      * @param to The address that will own the minted token
674      * @param tokenId uint256 ID of the token to be minted
675      */
676     function _mint(address to, uint256 tokenId) internal {
677         require(to != address(0), "ERC721: mint to the zero address");
678         require(!_exists(tokenId), "ERC721: token already minted");
679 
680         _tokenOwner[tokenId] = to;
681         _ownedTokensCount[to].increment();
682 
683         emit Transfer(address(0), to, tokenId);
684     }
685 
686     /**
687      * @dev Internal function to burn a specific token.
688      * Reverts if the token does not exist.
689      * Deprecated, use {_burn} instead.
690      * @param owner owner of the token to burn
691      * @param tokenId uint256 ID of the token being burned
692      */
693     function _burn(address owner, uint256 tokenId) internal {
694         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
695 
696         _clearApproval(tokenId);
697 
698         _ownedTokensCount[owner].decrement();
699         _tokenOwner[tokenId] = address(0);
700 
701         emit Transfer(owner, address(0), tokenId);
702     }
703 
704     /**
705      * @dev Internal function to burn a specific token.
706      * Reverts if the token does not exist.
707      * @param tokenId uint256 ID of the token being burned
708      */
709     function _burn(uint256 tokenId) internal {
710         _burn(ownerOf(tokenId), tokenId);
711     }
712 
713     /**
714      * @dev Internal function to transfer ownership of a given token ID to another address.
715      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
716      * @param from current owner of the token
717      * @param to address to receive the ownership of the given token ID
718      * @param tokenId uint256 ID of the token to be transferred
719      */
720     function _transferFrom(address from, address to, uint256 tokenId) internal {
721         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
722         require(to != address(0), "ERC721: transfer to the zero address");
723 
724         _clearApproval(tokenId);
725 
726         _ownedTokensCount[from].decrement();
727         _ownedTokensCount[to].increment();
728 
729         _tokenOwner[tokenId] = to;
730 
731         emit Transfer(from, to, tokenId);
732     }
733 
734     /**
735      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
736      * The call is not executed if the target address is not a contract.
737      *
738      * This function is deprecated.
739      * @param from address representing the previous owner of the given token ID
740      * @param to target address that will receive the tokens
741      * @param tokenId uint256 ID of the token to be transferred
742      * @param _data bytes optional data to send along with the call
743      * @return bool whether the call correctly returned the expected magic value
744      */
745     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
746         internal returns (bool)
747     {
748         if (!to.isContract()) {
749             return true;
750         }
751 
752         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
753         return (retval == _ERC721_RECEIVED);
754     }
755 
756     /**
757      * @dev Private function to clear current approval of a given token ID.
758      * @param tokenId uint256 ID of the token to be transferred
759      */
760     function _clearApproval(uint256 tokenId) private {
761         if (_tokenApprovals[tokenId] != address(0)) {
762             _tokenApprovals[tokenId] = address(0);
763         }
764     }
765 }
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 contract IERC721Enumerable is IERC721 {
772     function totalSupply() public view returns (uint256);
773     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
774 
775     function tokenByIndex(uint256 index) public view returns (uint256);
776 }
777 
778 /**
779  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
780  * @dev See https://eips.ethereum.org/EIPS/eip-721
781  */
782 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
783     // Mapping from owner to list of owned token IDs
784     mapping(address => uint256[]) private _ownedTokens;
785 
786     // Mapping from token ID to index of the owner tokens list
787     mapping(uint256 => uint256) private _ownedTokensIndex;
788 
789     // Array with all token ids, used for enumeration
790     uint256[] private _allTokens;
791 
792     // Mapping from token id to position in the allTokens array
793     mapping(uint256 => uint256) private _allTokensIndex;
794 
795     /*
796      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
797      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
798      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
799      *
800      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
801      */
802     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
803 
804     /**
805      * @dev Constructor function.
806      */
807     constructor () public {
808         // register the supported interface to conform to ERC721Enumerable via ERC165
809         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
810     }
811 
812     /**
813      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
814      * @param owner address owning the tokens list to be accessed
815      * @param index uint256 representing the index to be accessed of the requested tokens list
816      * @return uint256 token ID at the given index of the tokens list owned by the requested address
817      */
818     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
819         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
820         return _ownedTokens[owner][index];
821     }
822 
823     /**
824      * @dev Gets the total amount of tokens stored by the contract.
825      * @return uint256 representing the total amount of tokens
826      */
827     function totalSupply() public view returns (uint256) {
828         return _allTokens.length;
829     }
830 
831     /**
832      * @dev Gets the token ID at a given index of all the tokens in this contract
833      * Reverts if the index is greater or equal to the total number of tokens.
834      * @param index uint256 representing the index to be accessed of the tokens list
835      * @return uint256 token ID at the given index of the tokens list
836      */
837     function tokenByIndex(uint256 index) public view returns (uint256) {
838         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
839         return _allTokens[index];
840     }
841 
842     /**
843      * @dev Internal function to transfer ownership of a given token ID to another address.
844      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
845      * @param from current owner of the token
846      * @param to address to receive the ownership of the given token ID
847      * @param tokenId uint256 ID of the token to be transferred
848      */
849     function _transferFrom(address from, address to, uint256 tokenId) internal {
850         super._transferFrom(from, to, tokenId);
851 
852         _removeTokenFromOwnerEnumeration(from, tokenId);
853 
854         _addTokenToOwnerEnumeration(to, tokenId);
855     }
856 
857     /**
858      * @dev Internal function to mint a new token.
859      * Reverts if the given token ID already exists.
860      * @param to address the beneficiary that will own the minted token
861      * @param tokenId uint256 ID of the token to be minted
862      */
863     function _mint(address to, uint256 tokenId) internal {
864         super._mint(to, tokenId);
865 
866         _addTokenToOwnerEnumeration(to, tokenId);
867 
868         _addTokenToAllTokensEnumeration(tokenId);
869     }
870 
871     /**
872      * @dev Internal function to burn a specific token.
873      * Reverts if the token does not exist.
874      * Deprecated, use {ERC721-_burn} instead.
875      * @param owner owner of the token to burn
876      * @param tokenId uint256 ID of the token being burned
877      */
878     function _burn(address owner, uint256 tokenId) internal {
879         super._burn(owner, tokenId);
880 
881         _removeTokenFromOwnerEnumeration(owner, tokenId);
882         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
883         _ownedTokensIndex[tokenId] = 0;
884 
885         _removeTokenFromAllTokensEnumeration(tokenId);
886     }
887 
888     /**
889      * @dev Gets the list of token IDs of the requested owner.
890      * @param owner address owning the tokens
891      * @return uint256[] List of token IDs owned by the requested address
892      */
893     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
894         return _ownedTokens[owner];
895     }
896 
897     /**
898      * @dev Private function to add a token to this extension's ownership-tracking data structures.
899      * @param to address representing the new owner of the given token ID
900      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
901      */
902     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
903         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
904         _ownedTokens[to].push(tokenId);
905     }
906 
907     /**
908      * @dev Private function to add a token to this extension's token tracking data structures.
909      * @param tokenId uint256 ID of the token to be added to the tokens list
910      */
911     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
912         _allTokensIndex[tokenId] = _allTokens.length;
913         _allTokens.push(tokenId);
914     }
915 
916     /**
917      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
918      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
919      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
920      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
921      * @param from address representing the previous owner of the given token ID
922      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
923      */
924     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
925         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
926         // then delete the last slot (swap and pop).
927 
928         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
929         uint256 tokenIndex = _ownedTokensIndex[tokenId];
930 
931         // When the token to delete is the last token, the swap operation is unnecessary
932         if (tokenIndex != lastTokenIndex) {
933             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
934 
935             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
936             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
937         }
938 
939         // This also deletes the contents at the last position of the array
940         _ownedTokens[from].length--;
941 
942         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
943         // lastTokenId, or just over the end of the array if the token was the last one).
944     }
945 
946     /**
947      * @dev Private function to remove a token from this extension's token tracking data structures.
948      * This has O(1) time complexity, but alters the order of the _allTokens array.
949      * @param tokenId uint256 ID of the token to be removed from the tokens list
950      */
951     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
952         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
953         // then delete the last slot (swap and pop).
954 
955         uint256 lastTokenIndex = _allTokens.length.sub(1);
956         uint256 tokenIndex = _allTokensIndex[tokenId];
957 
958         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
959         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
960         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
961         uint256 lastTokenId = _allTokens[lastTokenIndex];
962 
963         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
964         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
965 
966         // This also deletes the contents at the last position of the array
967         _allTokens.length--;
968         _allTokensIndex[tokenId] = 0;
969     }
970 }
971 
972 /**
973  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
974  * @dev See https://eips.ethereum.org/EIPS/eip-721
975  */
976 contract IERC721Metadata is IERC721 {
977     function name() external view returns (string memory);
978     function symbol() external view returns (string memory);
979     function tokenURI(uint256 tokenId) external view returns (string memory);
980 }
981 
982 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
983     // Token name
984     string private _name;
985 
986     // Token symbol
987     string private _symbol;
988 
989     // Optional mapping for token URIs
990     mapping(uint256 => string) private _tokenURIs;
991     /*
992      *     bytes4(keccak256('name()')) == 0x06fdde03
993      *     bytes4(keccak256('symbol()')) == 0x95d89b41
994      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
995      *
996      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
997      */
998     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
999 
1000     /**
1001      * @dev Constructor function
1002      */
1003     constructor (string memory name, string memory symbol) public {
1004         _name = name;
1005         _symbol = symbol;
1006 
1007         // register the supported interfaces to conform to ERC721 via ERC165
1008         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1009     }
1010 
1011     /**
1012      * @dev Gets the token name.
1013      * @return string representing the token name
1014      */
1015     function name() external view returns (string memory) {
1016         return _name;
1017     }
1018 
1019     /**
1020      * @dev Gets the token symbol.
1021      * @return string representing the token symbol
1022      */
1023     function symbol() external view returns (string memory) {
1024         return _symbol;
1025     }
1026 
1027 
1028     /**
1029      * @dev Returns an URI for a given token ID.
1030      * Throws if the token ID does not exist. May return an empty string.
1031      * @param tokenId uint256 ID of the token to query
1032      */
1033      
1034 /*
1035     function tokenURI(uint256 tokenId) external view returns (string memory) {
1036         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1037 //        return _tokenURIs[tokenId];
1038 
1039         return string(abi.encodePacked("https://chainfacesrinkeby.azurewebsites.net/api/HttpTrigger?id=", id_to_value[tokenId]));
1040     }
1041 */
1042 
1043     /**
1044      * @dev Internal function to set the token URI for a given token.
1045      * Reverts if the token ID does not exist.
1046      * @param tokenId uint256 ID of the token to set its URI
1047      * @param uri string URI to assign
1048      */
1049     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1050         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1051         _tokenURIs[tokenId] = uri;
1052     }
1053 
1054     /**
1055      * @dev Internal function to burn a specific token.
1056      * Reverts if the token does not exist.
1057      * Deprecated, use _burn(uint256) instead.
1058      * @param owner owner of the token to burn
1059      * @param tokenId uint256 ID of the token being burned by the msg.sender
1060      */
1061     function _burn(address owner, uint256 tokenId) internal {
1062         super._burn(owner, tokenId);
1063 
1064         // Clear metadata (if any)
1065         if (bytes(_tokenURIs[tokenId]).length != 0) {
1066             delete _tokenURIs[tokenId];
1067         }
1068     }
1069 }
1070 
1071 /**
1072  * @title Full ERC721 Token
1073  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1074  * Moreover, it includes approve all functionality using operator terminology.
1075  *
1076  * See https://eips.ethereum.org/EIPS/eip-721
1077  */
1078 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1079     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1080         // solhint-disable-previous-line no-empty-blocks
1081     }
1082 }
1083 
1084 library Random
1085 {
1086 	/**
1087 	* Initialize the pool with the entropy of the blockhashes of the blocks in the closed interval [earliestBlock, latestBlock]
1088 	* The argument "seed" is optional and can be left zero in most cases.
1089 	* This extra seed allows you to select a different sequence of random numbers for the same block range.
1090 	*/
1091 	function init(uint256 earliestBlock, uint256 latestBlock, uint256 seed) internal view returns (bytes32[] memory) {
1092 		//require(block.number-1 >= latestBlock && latestBlock >= earliestBlock && earliestBlock >= block.number-256, "Random.init: invalid block interval");
1093 		require(block.number-1 >= latestBlock && latestBlock >= earliestBlock, "Random.init: invalid block interval");
1094 		bytes32[] memory pool = new bytes32[](latestBlock-earliestBlock+2);
1095 		bytes32 salt = keccak256(abi.encodePacked(block.number,seed));
1096 		for(uint256 i=0; i<=latestBlock-earliestBlock; i++) {
1097 			// Add some salt to each blockhash so that we don't reuse those hash chains
1098 			// when this function gets called again in another block.
1099 			pool[i+1] = keccak256(abi.encodePacked(blockhash(earliestBlock+i),salt));
1100 		}
1101 		return pool;
1102 	}
1103 	
1104 	/**
1105 	* Initialize the pool from the latest "num" blocks.
1106 	*/
1107 	function initLatest(uint256 num, uint256 seed) internal view returns (bytes32[] memory) {
1108 		return init(block.number-num, block.number-1, seed);
1109 	}
1110 	
1111 	/**
1112 	* Advances to the next 256-bit random number in the pool of hash chains.
1113 	*/
1114 	function next(bytes32[] memory pool) internal pure returns (uint256) {
1115 		require(pool.length > 1, "Random.next: invalid pool");
1116 		uint256 roundRobinIdx = uint256(pool[0]) % (pool.length-1) + 1;
1117 		bytes32 hash = keccak256(abi.encodePacked(pool[roundRobinIdx]));
1118 		pool[0] = bytes32(uint256(pool[0])+1);
1119 		pool[roundRobinIdx] = hash;
1120 		return uint256(hash);
1121 	}
1122 	
1123 	/**
1124 	* Produces random integer values, uniformly distributed on the closed interval [a, b]
1125 	*/
1126 	function uniform(bytes32[] memory pool, int256 a, int256 b) internal pure returns (int256) {
1127 		require(a <= b, "Random.uniform: invalid interval");
1128 		return int256(next(pool)%uint256(b-a+1))+a;
1129 	}
1130 }
1131 
1132 
1133 contract ChainFaces is ERC721Full {
1134     using SafeMath for uint256;
1135 
1136     mapping(string  => uint256) value_to_id;
1137     mapping(uint256 => string) id_to_value;
1138 
1139     mapping (uint256 => uint) internal idToGolfScore;
1140     mapping (uint256 => uint) internal idToPercentBear;
1141     mapping (uint256 => uint) internal idToFaceSymmetry;
1142     mapping (uint256 => uint) internal idToTextColor;
1143     mapping (uint256 => uint) internal idToBackgroundColor;
1144     
1145 
1146     constructor() ERC721Full("ChainFaces", "ʕ◕ᴥ◕ʔ") public {
1147 
1148 
1149         string memory alpha1 = "ʕ◕ᴥ◕ʔ";
1150         string memory alpha2 = "(▀̿Ĺ̯▀̿ ̿)";
1151         string memory alpha3 = "(◣_◢)";
1152         string memory alpha4 = "щ(ಠ益ಠщ)";
1153         string memory alpha5 = "( ͡° ͜ʖ ͡°)"; 
1154         string memory alpha6 = "(;´༎ຶД༎ຶ`)";
1155         string memory alpha7 = "(●´ω｀●)";
1156         string memory alpha8 = "(╯°◡°）╯";        
1157         
1158 
1159         _registerToken(alpha1, 0, 100, 100, 16736095, 0);  //alpha1 face
1160 	    _registerToken(alpha2, 5, 0, 100, 16777215, 0);  //alpha2 face
1161         _registerToken(alpha3, 5, 0, 100, 16777215, 0);  //alpha3 face
1162 	    _registerToken(alpha4, 5, 0, 100, 16777215, 0);  //alpha4 face
1163         _registerToken(alpha5, 5, 0, 100, 16777215, 0);  //alpha5 face
1164         _registerToken(alpha6, 5, 0, 100, 16777215, 0);  //alpha6 face
1165         _registerToken(alpha7, 5, 0, 100, 16777215, 0);  //alpha7 face
1166         _registerToken(alpha8, 5, 0, 100, 16777215, 0);  //alpha8 face
1167     }
1168 
1169     
1170     function getLeftFace(uint256 seed) internal view returns (uint256 leftFacePartID){
1171 
1172     bytes32[] memory pool = Random.initLatest(4, seed);        
1173         
1174 
1175 		uint256 leftFaceRNG = uint256(Random.uniform(pool, 1, 70)); 
1176 
1177         if (leftFaceRNG <= 1) {
1178         leftFacePartID = 0;	
1179 		
1180 		} else if (leftFaceRNG <= 3) {
1181         leftFacePartID = 1;			    	    
1182 	    
1183 		} else if (leftFaceRNG <= 6) {
1184         leftFacePartID = 2;		    
1185 	    
1186 		} else if (leftFaceRNG <= 13) {
1187         leftFacePartID = 3;		    
1188 	    
1189 		} else if (leftFaceRNG <= 25) {
1190         leftFacePartID = 4;		    
1191 	    
1192 		} else if (leftFaceRNG <= 40) {
1193         leftFacePartID = 5;		    
1194 	    
1195 		} else if (leftFaceRNG <= 55) {
1196         leftFacePartID = 6;		    
1197 	    
1198 	    } else {
1199         leftFacePartID = 7;	
1200         
1201 		}
1202 
1203     }
1204     
1205     function getLeftEye(uint256 seed) internal view returns (uint256 leftEyePartID){
1206 
1207     bytes32[] memory pool = Random.initLatest(5, seed);     
1208     
1209 		uint256 leftEyeRNG = uint256(Random.uniform(pool, 1, 143)); 
1210 
1211 
1212         if (leftEyeRNG <= 1) {
1213         leftEyePartID = 0;	
1214 		
1215 		} else if (leftEyeRNG <= 3) {
1216         leftEyePartID = 1;			    	    
1217 	    
1218 		} else if (leftEyeRNG <= 6) {
1219         leftEyePartID = 2;		    
1220 	    
1221 		} else if (leftEyeRNG <= 11) {
1222         leftEyePartID = 3;		    
1223 	    
1224 		} else if (leftEyeRNG <= 18) {
1225         leftEyePartID = 4;		    
1226 	    
1227 		} else if (leftEyeRNG <= 26) {
1228         leftEyePartID = 5;	
1229 	    
1230 		} else if (leftEyeRNG <= 38) {
1231         leftEyePartID = 6;	
1232  	    
1233 		} else if (leftEyeRNG <= 53) {
1234         leftEyePartID = 7;	
1235         	    
1236 		} else if (leftEyeRNG <= 68) {
1237         leftEyePartID = 8;	
1238         	    
1239 		} else if (leftEyeRNG <= 83) {
1240         leftEyePartID = 9;	
1241         	    
1242 		} else if (leftEyeRNG <= 103) {
1243         leftEyePartID = 10;	
1244         	    
1245 		} else if (leftEyeRNG <= 123) {
1246         leftEyePartID = 11;	
1247                                          
1248 	    } else {
1249         leftEyePartID = 12;	
1250         
1251 		}
1252     
1253     }    
1254 
1255     function getMouth(uint256 seed) internal view returns (uint256 mouthPartID){
1256 
1257     bytes32[] memory pool = Random.initLatest(6, seed);        
1258         
1259 		uint256 mouthRNG = uint256(Random.uniform(pool, 1, 121)); 
1260 
1261 
1262         if (mouthRNG <= 1) {
1263         mouthPartID = 0;	
1264 		
1265 		} else if (mouthRNG <= 3) {
1266         mouthPartID = 1;			    	    
1267 	    
1268 		} else if (mouthRNG <= 6) {
1269         mouthPartID = 2;		    
1270 	    
1271 		} else if (mouthRNG <= 11) {
1272         mouthPartID = 3;		    
1273 	    
1274 		} else if (mouthRNG <= 19) {
1275         mouthPartID = 4;		    
1276 	    
1277 		} else if (mouthRNG <= 31) {
1278         mouthPartID = 5;	
1279 	    
1280 		} else if (mouthRNG <= 46) {
1281         mouthPartID = 5;	
1282         	    
1283 		} else if (mouthRNG <= 61) {
1284         mouthPartID = 5;	
1285         	    
1286 		} else if (mouthRNG <= 81) {
1287         mouthPartID = 5;	
1288         	    
1289 		} else if (mouthRNG <= 101) {
1290         mouthPartID = 5;	
1291         
1292 	    } else {
1293         mouthPartID = 6;	
1294         
1295 		}
1296     
1297     }    
1298     
1299     function getRightEye(uint256 seed) internal view returns (uint256 rightEyePartID){
1300 
1301     bytes32[] memory pool = Random.initLatest(7, seed);        
1302         
1303 		uint256 rightEyeRNG = uint256(Random.uniform(pool, 1, 143)); 
1304 
1305 
1306         if (rightEyeRNG <= 1) {
1307         rightEyePartID = 0;	
1308 		
1309 		} else if (rightEyeRNG <= 3) {
1310         rightEyePartID = 1;			    	    
1311 	    
1312 		} else if (rightEyeRNG <= 6) {
1313         rightEyePartID = 2;		    
1314 	    
1315 		} else if (rightEyeRNG <= 11) {
1316         rightEyePartID = 3;		    
1317 	    
1318 		} else if (rightEyeRNG <= 18) {
1319         rightEyePartID = 4;		    
1320 	    
1321 		} else if (rightEyeRNG <= 26) {
1322         rightEyePartID = 5;	
1323 	    
1324 		} else if (rightEyeRNG <= 38) {
1325         rightEyePartID = 6;	
1326  	    
1327 		} else if (rightEyeRNG <= 53) {
1328         rightEyePartID = 7;	
1329         	    
1330 		} else if (rightEyeRNG <= 68) {
1331         rightEyePartID = 8;	
1332         	    
1333 		} else if (rightEyeRNG <= 83) {
1334         rightEyePartID = 9;	
1335         	    
1336 		} else if (rightEyeRNG <= 103) {
1337         rightEyePartID = 10;	
1338         	    
1339 		} else if (rightEyeRNG <= 123) {
1340         rightEyePartID = 11;	
1341                                          
1342 	    } else {
1343         rightEyePartID = 12;	
1344         
1345 		}
1346     
1347     }   
1348 
1349     function getRightFace(uint256 seed) internal view returns (uint256 rightFacePartID){
1350 
1351     bytes32[] memory pool = Random.initLatest(8, seed);        
1352         
1353 		uint256 rightFaceRNG = uint256(Random.uniform(pool, 1, 70)); 
1354 
1355         if (rightFaceRNG <= 1) {
1356         rightFacePartID = 0;	
1357 		
1358 		} else if (rightFaceRNG <= 3) {
1359         rightFacePartID = 1;			    	    
1360 	    
1361 		} else if (rightFaceRNG <= 6) {
1362         rightFacePartID = 2;		    
1363 	    
1364 		} else if (rightFaceRNG <= 13) {
1365         rightFacePartID = 3;		    
1366 	    
1367 		} else if (rightFaceRNG <= 25) {
1368         rightFacePartID = 4;		    
1369 	    
1370 		} else if (rightFaceRNG <= 40) {
1371         rightFacePartID = 4;		    
1372 	    
1373 		} else if (rightFaceRNG <= 55) {
1374         rightFacePartID = 4;		    
1375 	    
1376 	    } else {
1377         rightFacePartID = 5;	
1378         
1379 		}
1380     
1381     }
1382 
1383     function _registerToken(string memory value, uint256 faceGolfScore, uint256 percentBear, uint256 faceSymmetry, uint256 textColor, uint256 backgroundColor) private {
1384         uint256 tokenId = totalSupply();
1385         
1386         id_to_value[tokenId] = value;
1387         value_to_id[value] = tokenId;
1388         idToGolfScore[tokenId] = faceGolfScore;
1389         idToPercentBear[tokenId] = percentBear;
1390         idToFaceSymmetry[tokenId] = faceSymmetry;
1391         idToTextColor[tokenId] = textColor;
1392         idToBackgroundColor[tokenId] = backgroundColor;
1393         
1394         
1395         _mint(msg.sender, tokenId);
1396     }
1397 
1398     
1399     uint public constant tokenLimit = 9999;
1400 
1401     
1402     
1403     function createFace(uint256 seed) public payable {
1404         
1405         
1406         if (totalSupply() < 2000) {
1407         require(msg.value == 6 finney);
1408         }
1409 
1410         else if (totalSupply() < 4000) {
1411         require(msg.value == 8 finney);
1412         }
1413         else if (totalSupply() < 6000) {
1414         require(msg.value == 10 finney);
1415         }
1416         else if (totalSupply() < 8000) {
1417         require(msg.value == 12 finney);
1418         }
1419         else {
1420         require(msg.value == 14 finney);
1421         }
1422 
1423 //       require(block.timestamp < 1574711999, "ChainFaces sale has completed. They are now only available on the secondary market. ");
1424         require(totalSupply() <= tokenLimit, "ChainFaces sale has completed. They are now only available on the secondary market. ");
1425  
1426 
1427         address(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3).transfer(msg.value/5*4);
1428         address(0x027Fb48bC4e3999DCF88690aEbEBCC3D1748A0Eb).transfer(msg.value/5);
1429 
1430         
1431         string[8] memory leftFaceCharacters = [ "ʕ" , "✿" ,"꒰" , ":" , "{" , "|" , "[" , "(" ];
1432         string[13] memory eyeCharacters = ["◕" , "👁" , "ಥ" , "♥" , "ʘ̚", "X", "⊙" , "˘" , "ಠ" , "◉" , "⚆" , "¬" , "^" ];
1433         string[11] memory mouthCharacters = [ "ᴥ" , "益" , "෴" , "ʖ" , "ᆺ" , "." , "o", "◡" , "_" , "╭╮" , "‿" ];
1434         string[8] memory rightFaceCharacters = [ "ʔ" , "✿" ,"꒱" , ":" , "}" , "|" , "]" , ")" ];
1435 		
1436         uint256 leftFacePartID = getLeftFace(seed + totalSupply());
1437         uint256 leftEyePartID = getLeftEye(seed + totalSupply());
1438         uint256 mouthPartID = getMouth(seed + totalSupply());
1439         uint256 rightEyePartID = getRightEye(seed + totalSupply());
1440         uint256 rightFacePartID = getRightFace(seed + totalSupply());
1441         
1442         string memory faceAssembly = string(abi.encodePacked(leftFaceCharacters[leftFacePartID], eyeCharacters[leftEyePartID], mouthCharacters[mouthPartID], eyeCharacters[rightEyePartID], rightFaceCharacters[rightFacePartID]));
1443         uint256 percentBear;
1444         uint256 faceSymmetry;
1445         if (totalSupply() == 77) {
1446             faceAssembly = "ฅ^•ﻌ•^ฅ";
1447         }
1448         if (totalSupply() == 80) {
1449             faceAssembly = "( ● Y ● )";
1450         }
1451        
1452         bytes32[] memory pool = Random.initLatest(3, seed);        
1453 		percentBear = uint256(Random.uniform(pool, 0, 20)); 
1454         
1455         
1456         if (leftFacePartID == 0) {
1457         percentBear = percentBear + 16;	
1458         }
1459         if (leftEyePartID == 0) {
1460         percentBear = percentBear + 16;	
1461         }
1462         if (mouthPartID == 0) {
1463         percentBear = percentBear + 16;	
1464         }
1465         if (rightEyePartID == 0) {
1466         percentBear = percentBear + 16;	
1467         }
1468         if (rightFacePartID == 0) {
1469         percentBear = percentBear + 16;	
1470         }
1471         
1472         
1473         if (leftFacePartID == rightFacePartID) {
1474         faceSymmetry = faceSymmetry + 50;    
1475         }
1476         if (leftEyePartID == rightEyePartID) {
1477         faceSymmetry = faceSymmetry + 50;    
1478         }
1479  
1480         uint256 faceGolfScore = leftFacePartID + leftEyePartID + mouthPartID + rightEyePartID + rightFacePartID;
1481         uint256 textColor = (8*(30-faceGolfScore))+(256*(8*(30-faceGolfScore)));
1482         uint256 backgroundColor = (2*(100-percentBear))+(256*(2*(100-percentBear)+20))+(65536*(2*(100-percentBear)+56));
1483         
1484         if (totalSupply() == 77) {
1485             backgroundColor = 0;
1486         }
1487         if (totalSupply() == 80) {
1488             backgroundColor = 0;
1489         }
1490         
1491         _registerToken(faceAssembly, faceGolfScore, percentBear, faceSymmetry, textColor, backgroundColor);
1492         
1493     }
1494 
1495    function integerToString(uint _i) internal pure 
1496       returns (string memory) {
1497       
1498       if (_i == 0) {
1499          return "0";
1500       }
1501       uint j = _i;
1502       uint len;
1503       
1504       while (j != 0) {
1505          len++;
1506          j /= 10;
1507       }
1508       bytes memory bstr = new bytes(len);
1509       uint k = len - 1;
1510       
1511       while (_i != 0) {
1512          bstr[k--] = byte(uint8(48 + _i % 10));
1513          _i /= 10;
1514       }
1515       return string(bstr);
1516    }
1517 
1518 
1519     function tokenURI(uint256 id) external view returns (string memory) {
1520         require(_exists(id), "ERC721Metadata: URI query for nonexistent token");
1521         return string(abi.encodePacked("https://chainfacesrinkeby.azurewebsites.net/api/HttpTrigger?id=", integerToString(id)));
1522     }
1523     
1524     function getFace(uint256 id) public view returns (string memory face) {
1525         return id_to_value[id];
1526     }
1527 
1528     function getGolfScore(uint id) public view returns (uint256 golfScore) {
1529         return idToGolfScore[id];
1530     }    
1531 
1532     function getPercentBear(uint id) public view returns (uint256 percentBear) {
1533         return idToPercentBear[id];
1534     }   
1535     
1536     function getFaceSymmetry(uint id) public view returns (uint256 faceSymmetry) {
1537         return idToFaceSymmetry[id];
1538     }       
1539 
1540     function getTextColor(uint id) public view returns (uint256 textColor) {
1541         return idToTextColor[id];
1542     }   
1543     
1544     function getBackgroundColor(uint id) public view returns (uint256 backgroundColor) {
1545         return idToBackgroundColor[id];
1546     }         
1547 
1548 
1549 
1550 }