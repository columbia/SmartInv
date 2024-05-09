1 pragma solidity ^0.5.12;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 /**
52  * @dev Required interface of an ERC721 compliant contract.
53  */
54 contract IERC721 is IERC165 {
55     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
56     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
57     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
58 
59     /**
60      * @dev Returns the number of NFTs in `owner`'s account.
61      */
62     function balanceOf(address owner) public view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the NFT specified by `tokenId`.
66      */
67     function ownerOf(uint256 tokenId) public view returns (address owner);
68 
69     /**
70      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
71      * another (`to`).
72      *
73      *
74      *
75      * Requirements:
76      * - `from`, `to` cannot be zero.
77      * - `tokenId` must be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this
79      * NFT by either {approve} or {setApprovalForAll}.
80      */
81     function safeTransferFrom(address from, address to, uint256 tokenId) public;
82     /**
83      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
84      * another (`to`).
85      *
86      * Requirements:
87      * - If the caller is not `from`, it must be approved to move this NFT by
88      * either {approve} or {setApprovalForAll}.
89      */
90     function transferFrom(address from, address to, uint256 tokenId) public;
91     function approve(address to, uint256 tokenId) public;
92     function getApproved(uint256 tokenId) public view returns (address operator);
93 
94     function setApprovalForAll(address operator, bool _approved) public;
95     function isApprovedForAll(address owner, address operator) public view returns (bool);
96 
97 
98     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
99 }
100 
101 /**
102  * @title ERC721 token receiver interface
103  * @dev Interface for any contract that wants to support safeTransfers
104  * from ERC721 asset contracts.
105  */
106 contract IERC721Receiver {
107     /**
108      * @notice Handle the receipt of an NFT
109      * @dev The ERC721 smart contract calls this function on the recipient
110      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
111      * otherwise the caller will revert the transaction. The selector to be
112      * returned can be obtained as `this.onERC721Received.selector`. This
113      * function MAY throw to revert and reject the transfer.
114      * Note: the ERC721 contract address is always the message sender.
115      * @param operator The address which called `safeTransferFrom` function
116      * @param from The address which previously owned the token
117      * @param tokenId The NFT identifier which is being transferred
118      * @param data Additional data with no specified format
119      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
120      */
121     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
122     public returns (bytes4);
123 }
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      * - Subtraction cannot overflow.
176      *
177      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
178      * @dev Get it via `npm install @openzeppelin/contracts@next`.
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235 
236      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
237      * @dev Get it via `npm install @openzeppelin/contracts@next`.
238      */
239     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         // Solidity only automatically asserts when dividing by 0
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts with custom message when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      * - The divisor cannot be zero.
273      *
274      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
275      * @dev Get it via `npm install @openzeppelin/contracts@next`.
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
317      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
318      * @dev Get it via `npm install @openzeppelin/contracts@next`.
319      */
320     function toPayable(address account) internal pure returns (address payable) {
321         return address(uint160(account));
322     }
323 }
324 
325 /**
326  * @title Counters
327  * @author Matt Condon (@shrugs)
328  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
329  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
330  *
331  * Include with `using Counters for Counters.Counter;`
332  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
333  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
334  * directly accessed.
335  */
336 library Counters {
337     using SafeMath for uint256;
338 
339     struct Counter {
340         // This variable should never be directly accessed by users of the library: interactions must be restricted to
341         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
342         // this feature: see https://github.com/ethereum/solidity/issues/4637
343         uint256 _value; // default: 0
344     }
345 
346     function current(Counter storage counter) internal view returns (uint256) {
347         return counter._value;
348     }
349 
350     function increment(Counter storage counter) internal {
351         // The {SafeMath} overflow check can be skipped here, see the comment at the top
352         counter._value += 1;
353     }
354 
355     function decrement(Counter storage counter) internal {
356         counter._value = counter._value.sub(1);
357     }
358 }
359 
360 /**
361  * @dev Implementation of the {IERC165} interface.
362  *
363  * Contracts may inherit from this and call {_registerInterface} to declare
364  * their support of an interface.
365  */
366 contract ERC165 is IERC165 {
367     /*
368      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
369      */
370     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
371 
372     /**
373      * @dev Mapping of interface ids to whether or not it's supported.
374      */
375     mapping(bytes4 => bool) private _supportedInterfaces;
376 
377     constructor () internal {
378         // Derived contracts need only register support for their own interfaces,
379         // we register support for ERC165 itself here
380         _registerInterface(_INTERFACE_ID_ERC165);
381     }
382 
383     /**
384      * @dev See {IERC165-supportsInterface}.
385      *
386      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
387      */
388     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
389         return _supportedInterfaces[interfaceId];
390     }
391 
392     /**
393      * @dev Registers the contract as an implementer of the interface defined by
394      * `interfaceId`. Support of the actual ERC165 interface is automatic and
395      * registering its interface id is not required.
396      *
397      * See {IERC165-supportsInterface}.
398      *
399      * Requirements:
400      *
401      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
402      */
403     function _registerInterface(bytes4 interfaceId) internal {
404         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
405         _supportedInterfaces[interfaceId] = true;
406     }
407 }
408 
409 /**
410  * @title ERC721 Non-Fungible Token Standard basic implementation
411  * @dev see https://eips.ethereum.org/EIPS/eip-721
412  */
413 contract ERC721 is Context, ERC165, IERC721 {
414     using SafeMath for uint256;
415     using Address for address;
416     using Counters for Counters.Counter;
417 
418     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
419     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
420     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
421 
422     // Mapping from token ID to owner
423     mapping (uint256 => address) private _tokenOwner;
424 
425     // Mapping from token ID to approved address
426     mapping (uint256 => address) private _tokenApprovals;
427 
428     // Mapping from owner to number of owned token
429     mapping (address => Counters.Counter) private _ownedTokensCount;
430 
431     // Mapping from owner to operator approvals
432     mapping (address => mapping (address => bool)) private _operatorApprovals;
433 
434     /*
435      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
436      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
437      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
438      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
439      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
440      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
441      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
442      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
443      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
444      *
445      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
446      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
447      */
448     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
449 
450     constructor () public {
451         // register the supported interfaces to conform to ERC721 via ERC165
452         _registerInterface(_INTERFACE_ID_ERC721);
453     }
454 
455     /**
456      * @dev Gets the balance of the specified address.
457      * @param owner address to query the balance of
458      * @return uint256 representing the amount owned by the passed address
459      */
460     function balanceOf(address owner) public view returns (uint256) {
461         require(owner != address(0), "ERC721: balance query for the zero address");
462 
463         return _ownedTokensCount[owner].current();
464     }
465 
466     /**
467      * @dev Gets the owner of the specified token ID.
468      * @param tokenId uint256 ID of the token to query the owner of
469      * @return address currently marked as the owner of the given token ID
470      */
471     function ownerOf(uint256 tokenId) public view returns (address) {
472         address owner = _tokenOwner[tokenId];
473         // require(owner != address(0), "ERC721: owner query for nonexistent token");
474 
475         return owner;
476     }
477 
478     /**
479      * @dev Approves another address to transfer the given token ID
480      * The zero address indicates there is no approved address.
481      * There can only be one approved address per token at a given time.
482      * Can only be called by the token owner or an approved operator.
483      * @param to address to be approved for the given token ID
484      * @param tokenId uint256 ID of the token to be approved
485      */
486     function approve(address to, uint256 tokenId) public {
487         address owner = ownerOf(tokenId);
488         require(to != owner, "ERC721: approval to current owner");
489 
490         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
491             "ERC721: approve caller is not owner nor approved for all"
492         );
493 
494         _tokenApprovals[tokenId] = to;
495         emit Approval(owner, to, tokenId);
496     }
497 
498     /**
499      * @dev Gets the approved address for a token ID, or zero if no address set
500      * Reverts if the token ID does not exist.
501      * @param tokenId uint256 ID of the token to query the approval of
502      * @return address currently approved for the given token ID
503      */
504     function getApproved(uint256 tokenId) public view returns (address) {
505         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
506 
507         return _tokenApprovals[tokenId];
508     }
509 
510     /**
511      * @dev Sets or unsets the approval of a given operator
512      * An operator is allowed to transfer all tokens of the sender on their behalf.
513      * @param to operator address to set the approval
514      * @param approved representing the status of the approval to be set
515      */
516     function setApprovalForAll(address to, bool approved) public {
517         require(to != _msgSender(), "ERC721: approve to caller");
518 
519         _operatorApprovals[_msgSender()][to] = approved;
520         emit ApprovalForAll(_msgSender(), to, approved);
521     }
522 
523     /**
524      * @dev Tells whether an operator is approved by a given owner.
525      * @param owner owner address which you want to query the approval of
526      * @param operator operator address which you want to query the approval of
527      * @return bool whether the given operator is approved by the given owner
528      */
529     function isApprovedForAll(address owner, address operator) public view returns (bool) {
530         return _operatorApprovals[owner][operator];
531     }
532 
533     /**
534      * @dev Transfers the ownership of a given token ID to another address.
535      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
536      * Requires the msg.sender to be the owner, approved, or operator.
537      * @param from current owner of the token
538      * @param to address to receive the ownership of the given token ID
539      * @param tokenId uint256 ID of the token to be transferred
540      */
541     function transferFrom(address from, address to, uint256 tokenId) public {
542         //solhint-disable-next-line max-line-length
543         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
544 
545         _transferFrom(from, to, tokenId);
546     }
547 
548     /**
549      * @dev Safely transfers the ownership of a given token ID to another address
550      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
551      * which is called upon a safe transfer, and return the magic value
552      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
553      * the transfer is reverted.
554      * Requires the msg.sender to be the owner, approved, or operator
555      * @param from current owner of the token
556      * @param to address to receive the ownership of the given token ID
557      * @param tokenId uint256 ID of the token to be transferred
558      */
559     function safeTransferFrom(address from, address to, uint256 tokenId) public {
560         safeTransferFrom(from, to, tokenId, "");
561     }
562 
563     /**
564      * @dev Safely transfers the ownership of a given token ID to another address
565      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
566      * which is called upon a safe transfer, and return the magic value
567      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
568      * the transfer is reverted.
569      * Requires the _msgSender() to be the owner, approved, or operator
570      * @param from current owner of the token
571      * @param to address to receive the ownership of the given token ID
572      * @param tokenId uint256 ID of the token to be transferred
573      * @param _data bytes data to send along with a safe transfer check
574      */
575     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
576         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
577         _safeTransferFrom(from, to, tokenId, _data);
578     }
579 
580     /**
581      * @dev Safely transfers the ownership of a given token ID to another address
582      * If the target address is a contract, it must implement `onERC721Received`,
583      * which is called upon a safe transfer, and return the magic value
584      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
585      * the transfer is reverted.
586      * Requires the msg.sender to be the owner, approved, or operator
587      * @param from current owner of the token
588      * @param to address to receive the ownership of the given token ID
589      * @param tokenId uint256 ID of the token to be transferred
590      * @param _data bytes data to send along with a safe transfer check
591      */
592     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
593         _transferFrom(from, to, tokenId);
594         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
595     }
596 
597     /**
598      * @dev Returns whether the specified token exists.
599      * @param tokenId uint256 ID of the token to query the existence of
600      * @return bool whether the token exists
601      */
602     function _exists(uint256 tokenId) internal view returns (bool) {
603         address owner = _tokenOwner[tokenId];
604         return owner != address(0);
605     }
606 
607     /**
608      * @dev Returns whether the given spender can transfer a given token ID.
609      * @param spender address of the spender to query
610      * @param tokenId uint256 ID of the token to be transferred
611      * @return bool whether the msg.sender is approved for the given token ID,
612      * is an operator of the owner, or is the owner of the token
613      */
614     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
615         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
616         address owner = ownerOf(tokenId);
617         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
618     }
619 
620     /**
621      * @dev Internal function to safely mint a new token.
622      * Reverts if the given token ID already exists.
623      * If the target address is a contract, it must implement `onERC721Received`,
624      * which is called upon a safe transfer, and return the magic value
625      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
626      * the transfer is reverted.
627      * @param to The address that will own the minted token
628      * @param tokenId uint256 ID of the token to be minted
629      */
630     function _safeMint(address to, uint256 tokenId) internal {
631         _safeMint(to, tokenId, "");
632     }
633 
634     /**
635      * @dev Internal function to safely mint a new token.
636      * Reverts if the given token ID already exists.
637      * If the target address is a contract, it must implement `onERC721Received`,
638      * which is called upon a safe transfer, and return the magic value
639      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
640      * the transfer is reverted.
641      * @param to The address that will own the minted token
642      * @param tokenId uint256 ID of the token to be minted
643      * @param _data bytes data to send along with a safe transfer check
644      */
645     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
646         _mint(to, tokenId);
647         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
648     }
649 
650     /**
651      * @dev Internal function to mint a new token.
652      * Reverts if the given token ID already exists.
653      * @param to The address that will own the minted token
654      * @param tokenId uint256 ID of the token to be minted
655      */
656     function _mint(address to, uint256 tokenId) internal {
657         require(to != address(0), "ERC721: mint to the zero address");
658         require(!_exists(tokenId), "ERC721: token already minted");
659 
660         _tokenOwner[tokenId] = to;
661         _ownedTokensCount[to].increment();
662 
663         emit Transfer(address(0), to, tokenId);
664     }
665 
666     /**
667      * @dev Internal function to burn a specific token.
668      * Reverts if the token does not exist.
669      * Deprecated, use {_burn} instead.
670      * @param owner owner of the token to burn
671      * @param tokenId uint256 ID of the token being burned
672      */
673     function _burn(address owner, uint256 tokenId) internal {
674         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
675 
676         _clearApproval(tokenId);
677 
678         _ownedTokensCount[owner].decrement();
679         _tokenOwner[tokenId] = address(0);
680 
681         emit Transfer(owner, address(0), tokenId);
682     }
683 
684     /**
685      * @dev Internal function to burn a specific token.
686      * Reverts if the token does not exist.
687      * @param tokenId uint256 ID of the token being burned
688      */
689     function _burn(uint256 tokenId) internal {
690         _burn(ownerOf(tokenId), tokenId);
691     }
692 
693     /**
694      * @dev Internal function to transfer ownership of a given token ID to another address.
695      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
696      * @param from current owner of the token
697      * @param to address to receive the ownership of the given token ID
698      * @param tokenId uint256 ID of the token to be transferred
699      */
700     function _transferFrom(address from, address to, uint256 tokenId) internal {
701         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
702         require(to != address(0), "ERC721: transfer to the zero address");
703 
704         _clearApproval(tokenId);
705 
706         _ownedTokensCount[from].decrement();
707         _ownedTokensCount[to].increment();
708 
709         _tokenOwner[tokenId] = to;
710 
711         emit Transfer(from, to, tokenId);
712     }
713 
714     /**
715      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
716      * The call is not executed if the target address is not a contract.
717      *
718      * This function is deprecated.
719      * @param from address representing the previous owner of the given token ID
720      * @param to target address that will receive the tokens
721      * @param tokenId uint256 ID of the token to be transferred
722      * @param _data bytes optional data to send along with the call
723      * @return bool whether the call correctly returned the expected magic value
724      */
725     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
726         internal returns (bool)
727     {
728         if (!to.isContract()) {
729             return true;
730         }
731 
732         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
733         return (retval == _ERC721_RECEIVED);
734     }
735 
736     /**
737      * @dev Private function to clear current approval of a given token ID.
738      * @param tokenId uint256 ID of the token to be transferred
739      */
740     function _clearApproval(uint256 tokenId) private {
741         if (_tokenApprovals[tokenId] != address(0)) {
742             _tokenApprovals[tokenId] = address(0);
743         }
744     }
745 }
746 
747 /**
748  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
749  * @dev See https://eips.ethereum.org/EIPS/eip-721
750  */
751 contract IERC721Enumerable is IERC721 {
752     function totalSupply() public view returns (uint256);
753     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
754 
755     function tokenByIndex(uint256 index) public view returns (uint256);
756 }
757 
758 /**
759  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
760  * @dev See https://eips.ethereum.org/EIPS/eip-721
761  */
762 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
763     // Mapping from owner to list of owned token IDs
764     mapping(address => uint256[]) internal _ownedTokens;
765 
766     // Mapping from token ID to index of the owner tokens list
767     mapping(uint256 => uint256) internal _ownedTokensIndex;
768 
769     // Array with all token ids, used for enumeration
770     uint256[] internal _allTokens;
771 
772     // Mapping from token id to position in the allTokens array
773     mapping(uint256 => uint256) internal _allTokensIndex;
774 
775     /*
776      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
777      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
778      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
779      *
780      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
781      */
782     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
783 
784     /**
785      * @dev Constructor function.
786      */
787     constructor () public {
788         // register the supported interface to conform to ERC721Enumerable via ERC165
789         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
790     }
791 
792     /**
793      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
794      * @param owner address owning the tokens list to be accessed
795      * @param index uint256 representing the index to be accessed of the requested tokens list
796      * @return uint256 token ID at the given index of the tokens list owned by the requested address
797      */
798     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
799         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
800         return _ownedTokens[owner][index];
801     }
802 
803     /**
804      * @dev Gets the total amount of tokens stored by the contract.
805      * @return uint256 representing the total amount of tokens
806      */
807     function totalSupply() public view returns (uint256) {
808         return _allTokens.length;
809     }
810 
811     /**
812      * @dev Gets the token ID at a given index of all the tokens in this contract
813      * Reverts if the index is greater or equal to the total number of tokens.
814      * @param index uint256 representing the index to be accessed of the tokens list
815      * @return uint256 token ID at the given index of the tokens list
816      */
817     function tokenByIndex(uint256 index) public view returns (uint256) {
818         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
819         return _allTokens[index];
820     }
821 
822     /**
823      * @dev Internal function to transfer ownership of a given token ID to another address.
824      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
825      * @param from current owner of the token
826      * @param to address to receive the ownership of the given token ID
827      * @param tokenId uint256 ID of the token to be transferred
828      */
829     function _transferFrom(address from, address to, uint256 tokenId) internal {
830         super._transferFrom(from, to, tokenId);
831 
832         _removeTokenFromOwnerEnumeration(from, tokenId);
833 
834         _addTokenToOwnerEnumeration(to, tokenId);
835     }
836 
837     /**
838      * @dev Internal function to mint a new token.
839      * Reverts if the given token ID already exists.
840      * @param to address the beneficiary that will own the minted token
841      * @param tokenId uint256 ID of the token to be minted
842      */
843     function _mint(address to, uint256 tokenId) internal {
844         super._mint(to, tokenId);
845 
846         _addTokenToOwnerEnumeration(to, tokenId);
847 
848         _addTokenToAllTokensEnumeration(tokenId);
849     }
850 
851     /**
852      * @dev Internal function to burn a specific token.
853      * Reverts if the token does not exist.
854      * Deprecated, use {ERC721-_burn} instead.
855      * @param owner owner of the token to burn
856      * @param tokenId uint256 ID of the token being burned
857      */
858     function _burn(address owner, uint256 tokenId) internal {
859         super._burn(owner, tokenId);
860 
861         _removeTokenFromOwnerEnumeration(owner, tokenId);
862         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
863         _ownedTokensIndex[tokenId] = 0;
864 
865         _removeTokenFromAllTokensEnumeration(tokenId);
866     }
867 
868     /**
869      * @dev Gets the list of token IDs of the requested owner.
870      * @param owner address owning the tokens
871      * @return uint256[] List of token IDs owned by the requested address
872      */
873     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
874         return _ownedTokens[owner];
875     }
876 
877     /**
878      * @dev Private function to add a token to this extension's ownership-tracking data structures.
879      * @param to address representing the new owner of the given token ID
880      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
881      */
882     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
883         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
884         _ownedTokens[to].push(tokenId);
885     }
886 
887     /**
888      * @dev Private function to add a token to this extension's token tracking data structures.
889      * @param tokenId uint256 ID of the token to be added to the tokens list
890      */
891     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
892         _allTokensIndex[tokenId] = _allTokens.length;
893         _allTokens.push(tokenId);
894     }
895 
896     /**
897      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
898      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
899      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
900      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
901      * @param from address representing the previous owner of the given token ID
902      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
903      */
904     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
905         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
906         // then delete the last slot (swap and pop).
907 
908         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
909         uint256 tokenIndex = _ownedTokensIndex[tokenId];
910 
911         // When the token to delete is the last token, the swap operation is unnecessary
912         if (tokenIndex != lastTokenIndex) {
913             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
914 
915             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
916             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
917         }
918 
919         // This also deletes the contents at the last position of the array
920         _ownedTokens[from].length--;
921 
922         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
923         // lastTokenId, or just over the end of the array if the token was the last one).
924     }
925 
926     /**
927      * @dev Private function to remove a token from this extension's token tracking data structures.
928      * This has O(1) time complexity, but alters the order of the _allTokens array.
929      * @param tokenId uint256 ID of the token to be removed from the tokens list
930      */
931     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
932         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
933         // then delete the last slot (swap and pop).
934 
935         uint256 lastTokenIndex = _allTokens.length.sub(1);
936         uint256 tokenIndex = _allTokensIndex[tokenId];
937 
938         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
939         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
940         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
941         uint256 lastTokenId = _allTokens[lastTokenIndex];
942 
943         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
944         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
945 
946         // This also deletes the contents at the last position of the array
947         _allTokens.length--;
948         _allTokensIndex[tokenId] = 0;
949     }
950 }
951 
952 /**
953  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
954  * @dev See https://eips.ethereum.org/EIPS/eip-721
955  */
956 contract IERC721Metadata is IERC721 {
957     function name() external view returns (string memory);
958     function symbol() external view returns (string memory);
959     function tokenURI(uint256 tokenId) external view returns (string memory);
960 }
961 
962 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
963     // Token name
964     string private _name;
965 
966     // Token symbol
967     string private _symbol;
968 
969     /*
970      *     bytes4(keccak256('name()')) == 0x06fdde03
971      *     bytes4(keccak256('symbol()')) == 0x95d89b41
972      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
973      *
974      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
975      */
976     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
977 
978     /**
979      * @dev Constructor function
980      */
981     constructor (string memory name, string memory symbol) public {
982         _name = name;
983         _symbol = symbol;
984 
985         // register the supported interfaces to conform to ERC721 via ERC165
986         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
987     }
988 
989     /**
990      * @dev Gets the token name.
991      * @return string representing the token name
992      */
993     function name() external view returns (string memory) {
994         return _name;
995     }
996 
997     /**
998      * @dev Gets the token symbol.
999      * @return string representing the token symbol
1000      */
1001     function symbol() external view returns (string memory) {
1002         return _symbol;
1003     }
1004 }
1005 
1006 /**
1007  * @title Full ERC721 Token
1008  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1009  * Moreover, it includes approve all functionality using operator terminology.
1010  *
1011  * See https://eips.ethereum.org/EIPS/eip-721
1012  */
1013 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1014     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1015         // solhint-disable-previous-line no-empty-blocks
1016     }
1017 }
1018 
1019 /**
1020  * @dev Contract module which provides a basic access control mechanism, where
1021  * there is an account (an owner) that can be granted exclusive access to
1022  * specific functions.
1023  *
1024  * This module is used through inheritance. It will make available the modifier
1025  * `onlyOwner`, which can be applied to your functions to restrict their use to
1026  * the owner.
1027  */
1028 contract Ownable is Context {
1029     address private _owner;
1030 
1031     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1032 
1033     /**
1034      * @dev Initializes the contract setting the deployer as the initial owner.
1035      */
1036     constructor () internal {
1037         address msgSender = _msgSender();
1038         _owner = msgSender;
1039         emit OwnershipTransferred(address(0), msgSender);
1040     }
1041 
1042     /**
1043      * @dev Returns the address of the current owner.
1044      */
1045     function owner() public view returns (address) {
1046         return _owner;
1047     }
1048 
1049     /**
1050      * @dev Throws if called by any account other than the owner.
1051      */
1052     modifier onlyOwner() {
1053         require(isOwner(), "Ownable: caller is not the owner");
1054         _;
1055     }
1056 
1057     /**
1058      * @dev Returns true if the caller is the current owner.
1059      */
1060     function isOwner() public view returns (bool) {
1061         return _msgSender() == _owner;
1062     }
1063 
1064     /**
1065      * @dev Leaves the contract without owner. It will not be possible to call
1066      * `onlyOwner` functions anymore. Can only be called by the current owner.
1067      *
1068      * NOTE: Renouncing ownership will leave the contract without an owner,
1069      * thereby removing any functionality that is only available to the owner.
1070      */
1071     function renounceOwnership() public onlyOwner {
1072         emit OwnershipTransferred(_owner, address(0));
1073         _owner = address(0);
1074     }
1075 
1076     /**
1077      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1078      * Can only be called by the current owner.
1079      */
1080     function transferOwnership(address newOwner) public onlyOwner {
1081         _transferOwnership(newOwner);
1082     }
1083 
1084     /**
1085      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1086      */
1087     function _transferOwnership(address newOwner) internal {
1088         require(newOwner != address(0), "Ownable: new owner is the zero address");
1089         emit OwnershipTransferred(_owner, newOwner);
1090         _owner = newOwner;
1091     }
1092 }
1093 
1094 contract Ownership is Ownable {
1095     event OwnershipChanged(address indexed owner, uint256 level);
1096     
1097     mapping(address => uint256) internal ownership;
1098 
1099     constructor () internal {
1100         setOwnership(_msgSender(), 1);
1101     }
1102     
1103     function transferOwnership(address newOwner) public onlyOwner {
1104         _transferOwnership(newOwner);
1105         setOwnership(newOwner, 1);
1106     }
1107 
1108     function setOwnership(address key, uint256 level) public onlyOwner {
1109         ownership[key] = level;
1110         emit OwnershipChanged(key, level);
1111     }
1112 
1113     modifier onlyMinter() {
1114         require(isMinter(), "Ownerhsip : caller is not the minter");
1115         _;
1116     }
1117 
1118     function isMinter() public view returns (bool) {
1119         return ownership[_msgSender()] > 0;
1120     }
1121     
1122 }
1123 
1124 library Strings {
1125   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1126   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
1127       bytes memory _ba = bytes(_a);
1128       bytes memory _bb = bytes(_b);
1129       bytes memory _bc = bytes(_c);
1130       bytes memory _bd = bytes(_d);
1131       bytes memory _be = bytes(_e);
1132       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1133       bytes memory babcde = bytes(abcde);
1134       uint k = 0;
1135       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1136       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1137       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1138       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1139       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1140       return string(babcde);
1141     }
1142 
1143     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
1144         return strConcat(_a, _b, _c, _d, "");
1145     }
1146 
1147     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1148         return strConcat(_a, _b, _c, "", "");
1149     }
1150 
1151     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1152         return strConcat(_a, _b, "", "", "");
1153     }
1154 
1155     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1156         if (_i == 0) {
1157             return "0";
1158         }
1159         uint j = _i;
1160         uint len;
1161         while (j != 0) {
1162             len++;
1163             j /= 10;
1164         }
1165         bytes memory bstr = new bytes(len);
1166         uint k = len - 1;
1167         while (_i != 0) {
1168             bstr[k--] = byte(uint8(48 + _i % 10));
1169             _i /= 10;
1170         }
1171         return string(bstr);
1172     }
1173 }
1174 
1175 contract Metadata {
1176     using Strings for string;
1177 
1178     string public baseUri;
1179 
1180     function tokenURI(uint256 _id) external view returns (string memory) {
1181         return Strings.strConcat(baseUri, Strings.uint2str(_id));
1182     }
1183 
1184     function uri(uint256 _id) external view returns (string memory) {
1185         return Strings.strConcat(baseUri, Strings.uint2str(_id));
1186     }
1187 
1188 }
1189 
1190 contract OwnableDelegateProxy {
1191   
1192 }
1193 
1194 contract ProxyRegistry {
1195     mapping(address => OwnableDelegateProxy) public proxies;
1196 }
1197 
1198 contract KingdomLand is ERC721Full, Ownership, Metadata {
1199   ProxyRegistry public proxyRegistry;
1200 
1201   constructor(ProxyRegistry proxy, string memory uri, string memory name, string memory symbol) public ERC721Full(name, symbol) {
1202     proxyRegistry = proxy;
1203     baseUri = uri;
1204   }
1205 
1206   function setBaseURI(string memory uri) public onlyOwner {
1207     baseUri = uri;
1208   }
1209 
1210   function mint(address to, uint256 tokenId) public onlyMinter {
1211     _mint(to, tokenId);
1212   }
1213 
1214   function isApprovedForAll(address owner, address operator) public view returns (bool){
1215     if (address(proxyRegistry.proxies(owner)) == operator)
1216         return true;
1217     return super.isApprovedForAll(owner, operator);
1218   }
1219 
1220   function allTokens() public view returns (uint256[] memory){
1221     return _allTokens;
1222   }
1223 
1224   function getTokens(uint256 start, uint256 end) public view returns (uint256[] memory) {
1225     if(end <= start || _allTokens.length <= start)
1226       return new uint256[](0);
1227     uint256 length = end-start;
1228     if(end > _allTokens.length)
1229       length = _allTokens.length-start;
1230     uint256[] memory outputs = new uint256[](length);
1231     for (uint256 i = 0; i < length; ++i) {
1232         outputs[i] = _allTokens[start+i];
1233     }
1234     return outputs;
1235   }
1236   
1237   function ownedTokens(address owner) public view returns (uint256[] memory){
1238     return _ownedTokens[owner];
1239   }
1240 }