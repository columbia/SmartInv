1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File openzeppelin-solidity/contracts/GSN/Context.sol@v2.5.1
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
33 
34 // File openzeppelin-solidity/contracts/introspection/IERC165.sol@v2.5.1
35 
36 pragma solidity ^0.5.0;
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 
60 // File openzeppelin-solidity/contracts/token/ERC721/IERC721.sol@v2.5.1
61 
62 pragma solidity ^0.5.0;
63 
64 /**
65  * @dev Required interface of an ERC721 compliant contract.
66  */
67 contract IERC721 is IERC165 {
68     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
69     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
70     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
71 
72     /**
73      * @dev Returns the number of NFTs in `owner`'s account.
74      */
75     function balanceOf(address owner) public view returns (uint256 balance);
76 
77     /**
78      * @dev Returns the owner of the NFT specified by `tokenId`.
79      */
80     function ownerOf(uint256 tokenId) public view returns (address owner);
81 
82     /**
83      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
84      * another (`to`).
85      *
86      *
87      *
88      * Requirements:
89      * - `from`, `to` cannot be zero.
90      * - `tokenId` must be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this
92      * NFT by either {approve} or {setApprovalForAll}.
93      */
94     function safeTransferFrom(address from, address to, uint256 tokenId) public;
95     /**
96      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
97      * another (`to`).
98      *
99      * Requirements:
100      * - If the caller is not `from`, it must be approved to move this NFT by
101      * either {approve} or {setApprovalForAll}.
102      */
103     function transferFrom(address from, address to, uint256 tokenId) public;
104     function approve(address to, uint256 tokenId) public;
105     function getApproved(uint256 tokenId) public view returns (address operator);
106 
107     function setApprovalForAll(address operator, bool _approved) public;
108     function isApprovedForAll(address owner, address operator) public view returns (bool);
109 
110 
111     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
112 }
113 
114 
115 // File openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol@v2.5.1
116 
117 pragma solidity ^0.5.0;
118 
119 /**
120  * @title ERC721 token receiver interface
121  * @dev Interface for any contract that wants to support safeTransfers
122  * from ERC721 asset contracts.
123  */
124 contract IERC721Receiver {
125     /**
126      * @notice Handle the receipt of an NFT
127      * @dev The ERC721 smart contract calls this function on the recipient
128      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
129      * otherwise the caller will revert the transaction. The selector to be
130      * returned can be obtained as `this.onERC721Received.selector`. This
131      * function MAY throw to revert and reject the transfer.
132      * Note: the ERC721 contract address is always the message sender.
133      * @param operator The address which called `safeTransferFrom` function
134      * @param from The address which previously owned the token
135      * @param tokenId The NFT identifier which is being transferred
136      * @param data Additional data with no specified format
137      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
138      */
139     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
140     public returns (bytes4);
141 }
142 
143 
144 // File openzeppelin-solidity/contracts/math/SafeMath.sol@v2.5.1
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      * - Addition cannot overflow.
170      */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a + b;
173         require(c >= a, "SafeMath: addition overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return sub(a, b, "SafeMath: subtraction overflow");
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      * - Subtraction cannot overflow.
199      *
200      * _Available since v2.4.0._
201      */
202     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b <= a, errorMessage);
204         uint256 c = a - b;
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      * - Multiplication cannot overflow.
217      */
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
220         // benefit is lost if 'b' is also tested.
221         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
222         if (a == 0) {
223             return 0;
224         }
225 
226         uint256 c = a * b;
227         require(c / a == b, "SafeMath: multiplication overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return div(a, b, "SafeMath: division by zero");
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      *
258      * _Available since v2.4.0._
259      */
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         // Solidity only automatically asserts when dividing by 0
262         require(b > 0, errorMessage);
263         uint256 c = a / b;
264         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return mod(a, b, "SafeMath: modulo by zero");
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts with custom message when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      * - The divisor cannot be zero.
294      *
295      * _Available since v2.4.0._
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b != 0, errorMessage);
299         return a % b;
300     }
301 }
302 
303 
304 // File openzeppelin-solidity/contracts/utils/Address.sol@v2.5.1
305 
306 pragma solidity ^0.5.5;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following 
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      */
329     function isContract(address account) internal view returns (bool) {
330         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
331         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
332         // for accounts without code, i.e. `keccak256('')`
333         bytes32 codehash;
334         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
335         // solhint-disable-next-line no-inline-assembly
336         assembly { codehash := extcodehash(account) }
337         return (codehash != accountHash && codehash != 0x0);
338     }
339 
340     /**
341      * @dev Converts an `address` into `address payable`. Note that this is
342      * simply a type cast: the actual underlying value is not changed.
343      *
344      * _Available since v2.4.0._
345      */
346     function toPayable(address account) internal pure returns (address payable) {
347         return address(uint160(account));
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      *
366      * _Available since v2.4.0._
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         // solhint-disable-next-line avoid-call-value
372         (bool success, ) = recipient.call.value(amount)("");
373         require(success, "Address: unable to send value, recipient may have reverted");
374     }
375 }
376 
377 
378 // File openzeppelin-solidity/contracts/drafts/Counters.sol@v2.5.1
379 
380 pragma solidity ^0.5.0;
381 
382 /**
383  * @title Counters
384  * @author Matt Condon (@shrugs)
385  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
386  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
387  *
388  * Include with `using Counters for Counters.Counter;`
389  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
390  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
391  * directly accessed.
392  */
393 library Counters {
394     using SafeMath for uint256;
395 
396     struct Counter {
397         // This variable should never be directly accessed by users of the library: interactions must be restricted to
398         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
399         // this feature: see https://github.com/ethereum/solidity/issues/4637
400         uint256 _value; // default: 0
401     }
402 
403     function current(Counter storage counter) internal view returns (uint256) {
404         return counter._value;
405     }
406 
407     function increment(Counter storage counter) internal {
408         // The {SafeMath} overflow check can be skipped here, see the comment at the top
409         counter._value += 1;
410     }
411 
412     function decrement(Counter storage counter) internal {
413         counter._value = counter._value.sub(1);
414     }
415 }
416 
417 
418 // File openzeppelin-solidity/contracts/introspection/ERC165.sol@v2.5.1
419 
420 pragma solidity ^0.5.0;
421 
422 /**
423  * @dev Implementation of the {IERC165} interface.
424  *
425  * Contracts may inherit from this and call {_registerInterface} to declare
426  * their support of an interface.
427  */
428 contract ERC165 is IERC165 {
429     /*
430      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
431      */
432     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
433 
434     /**
435      * @dev Mapping of interface ids to whether or not it's supported.
436      */
437     mapping(bytes4 => bool) private _supportedInterfaces;
438 
439     constructor () internal {
440         // Derived contracts need only register support for their own interfaces,
441         // we register support for ERC165 itself here
442         _registerInterface(_INTERFACE_ID_ERC165);
443     }
444 
445     /**
446      * @dev See {IERC165-supportsInterface}.
447      *
448      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
449      */
450     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
451         return _supportedInterfaces[interfaceId];
452     }
453 
454     /**
455      * @dev Registers the contract as an implementer of the interface defined by
456      * `interfaceId`. Support of the actual ERC165 interface is automatic and
457      * registering its interface id is not required.
458      *
459      * See {IERC165-supportsInterface}.
460      *
461      * Requirements:
462      *
463      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
464      */
465     function _registerInterface(bytes4 interfaceId) internal {
466         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
467         _supportedInterfaces[interfaceId] = true;
468     }
469 }
470 
471 
472 // File openzeppelin-solidity/contracts/token/ERC721/ERC721.sol@v2.5.1
473 
474 pragma solidity ^0.5.0;
475 
476 
477 
478 
479 
480 
481 
482 /**
483  * @title ERC721 Non-Fungible Token Standard basic implementation
484  * @dev see https://eips.ethereum.org/EIPS/eip-721
485  */
486 contract ERC721 is Context, ERC165, IERC721 {
487     using SafeMath for uint256;
488     using Address for address;
489     using Counters for Counters.Counter;
490 
491     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
492     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
493     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
494 
495     // Mapping from token ID to owner
496     mapping (uint256 => address) private _tokenOwner;
497 
498     // Mapping from token ID to approved address
499     mapping (uint256 => address) private _tokenApprovals;
500 
501     // Mapping from owner to number of owned token
502     mapping (address => Counters.Counter) private _ownedTokensCount;
503 
504     // Mapping from owner to operator approvals
505     mapping (address => mapping (address => bool)) private _operatorApprovals;
506 
507     /*
508      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
509      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
510      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
511      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
512      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
513      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
514      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
515      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
516      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
517      *
518      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
519      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
520      */
521     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
522 
523     constructor () public {
524         // register the supported interfaces to conform to ERC721 via ERC165
525         _registerInterface(_INTERFACE_ID_ERC721);
526     }
527 
528     /**
529      * @dev Gets the balance of the specified address.
530      * @param owner address to query the balance of
531      * @return uint256 representing the amount owned by the passed address
532      */
533     function balanceOf(address owner) public view returns (uint256) {
534         require(owner != address(0), "ERC721: balance query for the zero address");
535 
536         return _ownedTokensCount[owner].current();
537     }
538 
539     /**
540      * @dev Gets the owner of the specified token ID.
541      * @param tokenId uint256 ID of the token to query the owner of
542      * @return address currently marked as the owner of the given token ID
543      */
544     function ownerOf(uint256 tokenId) public view returns (address) {
545         address owner = _tokenOwner[tokenId];
546         require(owner != address(0), "ERC721: owner query for nonexistent token");
547 
548         return owner;
549     }
550 
551     /**
552      * @dev Approves another address to transfer the given token ID
553      * The zero address indicates there is no approved address.
554      * There can only be one approved address per token at a given time.
555      * Can only be called by the token owner or an approved operator.
556      * @param to address to be approved for the given token ID
557      * @param tokenId uint256 ID of the token to be approved
558      */
559     function approve(address to, uint256 tokenId) public {
560         address owner = ownerOf(tokenId);
561         require(to != owner, "ERC721: approval to current owner");
562 
563         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
564             "ERC721: approve caller is not owner nor approved for all"
565         );
566 
567         _tokenApprovals[tokenId] = to;
568         emit Approval(owner, to, tokenId);
569     }
570 
571     /**
572      * @dev Gets the approved address for a token ID, or zero if no address set
573      * Reverts if the token ID does not exist.
574      * @param tokenId uint256 ID of the token to query the approval of
575      * @return address currently approved for the given token ID
576      */
577     function getApproved(uint256 tokenId) public view returns (address) {
578         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
579 
580         return _tokenApprovals[tokenId];
581     }
582 
583     /**
584      * @dev Sets or unsets the approval of a given operator
585      * An operator is allowed to transfer all tokens of the sender on their behalf.
586      * @param to operator address to set the approval
587      * @param approved representing the status of the approval to be set
588      */
589     function setApprovalForAll(address to, bool approved) public {
590         require(to != _msgSender(), "ERC721: approve to caller");
591 
592         _operatorApprovals[_msgSender()][to] = approved;
593         emit ApprovalForAll(_msgSender(), to, approved);
594     }
595 
596     /**
597      * @dev Tells whether an operator is approved by a given owner.
598      * @param owner owner address which you want to query the approval of
599      * @param operator operator address which you want to query the approval of
600      * @return bool whether the given operator is approved by the given owner
601      */
602     function isApprovedForAll(address owner, address operator) public view returns (bool) {
603         return _operatorApprovals[owner][operator];
604     }
605 
606     /**
607      * @dev Transfers the ownership of a given token ID to another address.
608      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
609      * Requires the msg.sender to be the owner, approved, or operator.
610      * @param from current owner of the token
611      * @param to address to receive the ownership of the given token ID
612      * @param tokenId uint256 ID of the token to be transferred
613      */
614     function transferFrom(address from, address to, uint256 tokenId) public {
615         //solhint-disable-next-line max-line-length
616         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
617 
618         _transferFrom(from, to, tokenId);
619     }
620 
621     /**
622      * @dev Safely transfers the ownership of a given token ID to another address
623      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
624      * which is called upon a safe transfer, and return the magic value
625      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
626      * the transfer is reverted.
627      * Requires the msg.sender to be the owner, approved, or operator
628      * @param from current owner of the token
629      * @param to address to receive the ownership of the given token ID
630      * @param tokenId uint256 ID of the token to be transferred
631      */
632     function safeTransferFrom(address from, address to, uint256 tokenId) public {
633         safeTransferFrom(from, to, tokenId, "");
634     }
635 
636     /**
637      * @dev Safely transfers the ownership of a given token ID to another address
638      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
639      * which is called upon a safe transfer, and return the magic value
640      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
641      * the transfer is reverted.
642      * Requires the _msgSender() to be the owner, approved, or operator
643      * @param from current owner of the token
644      * @param to address to receive the ownership of the given token ID
645      * @param tokenId uint256 ID of the token to be transferred
646      * @param _data bytes data to send along with a safe transfer check
647      */
648     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
649         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
650         _safeTransferFrom(from, to, tokenId, _data);
651     }
652 
653     /**
654      * @dev Safely transfers the ownership of a given token ID to another address
655      * If the target address is a contract, it must implement `onERC721Received`,
656      * which is called upon a safe transfer, and return the magic value
657      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
658      * the transfer is reverted.
659      * Requires the msg.sender to be the owner, approved, or operator
660      * @param from current owner of the token
661      * @param to address to receive the ownership of the given token ID
662      * @param tokenId uint256 ID of the token to be transferred
663      * @param _data bytes data to send along with a safe transfer check
664      */
665     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
666         _transferFrom(from, to, tokenId);
667         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
668     }
669 
670     /**
671      * @dev Returns whether the specified token exists.
672      * @param tokenId uint256 ID of the token to query the existence of
673      * @return bool whether the token exists
674      */
675     function _exists(uint256 tokenId) internal view returns (bool) {
676         address owner = _tokenOwner[tokenId];
677         return owner != address(0);
678     }
679 
680     /**
681      * @dev Returns whether the given spender can transfer a given token ID.
682      * @param spender address of the spender to query
683      * @param tokenId uint256 ID of the token to be transferred
684      * @return bool whether the msg.sender is approved for the given token ID,
685      * is an operator of the owner, or is the owner of the token
686      */
687     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
688         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
689         address owner = ownerOf(tokenId);
690         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
691     }
692 
693     /**
694      * @dev Internal function to safely mint a new token.
695      * Reverts if the given token ID already exists.
696      * If the target address is a contract, it must implement `onERC721Received`,
697      * which is called upon a safe transfer, and return the magic value
698      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
699      * the transfer is reverted.
700      * @param to The address that will own the minted token
701      * @param tokenId uint256 ID of the token to be minted
702      */
703     function _safeMint(address to, uint256 tokenId) internal {
704         _safeMint(to, tokenId, "");
705     }
706 
707     /**
708      * @dev Internal function to safely mint a new token.
709      * Reverts if the given token ID already exists.
710      * If the target address is a contract, it must implement `onERC721Received`,
711      * which is called upon a safe transfer, and return the magic value
712      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
713      * the transfer is reverted.
714      * @param to The address that will own the minted token
715      * @param tokenId uint256 ID of the token to be minted
716      * @param _data bytes data to send along with a safe transfer check
717      */
718     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
719         _mint(to, tokenId);
720         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
721     }
722 
723     /**
724      * @dev Internal function to mint a new token.
725      * Reverts if the given token ID already exists.
726      * @param to The address that will own the minted token
727      * @param tokenId uint256 ID of the token to be minted
728      */
729     function _mint(address to, uint256 tokenId) internal {
730         require(to != address(0), "ERC721: mint to the zero address");
731         require(!_exists(tokenId), "ERC721: token already minted");
732 
733         _tokenOwner[tokenId] = to;
734         _ownedTokensCount[to].increment();
735 
736         emit Transfer(address(0), to, tokenId);
737     }
738 
739     /**
740      * @dev Internal function to burn a specific token.
741      * Reverts if the token does not exist.
742      * Deprecated, use {_burn} instead.
743      * @param owner owner of the token to burn
744      * @param tokenId uint256 ID of the token being burned
745      */
746     function _burn(address owner, uint256 tokenId) internal {
747         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
748 
749         _clearApproval(tokenId);
750 
751         _ownedTokensCount[owner].decrement();
752         _tokenOwner[tokenId] = address(0);
753 
754         emit Transfer(owner, address(0), tokenId);
755     }
756 
757     /**
758      * @dev Internal function to burn a specific token.
759      * Reverts if the token does not exist.
760      * @param tokenId uint256 ID of the token being burned
761      */
762     function _burn(uint256 tokenId) internal {
763         _burn(ownerOf(tokenId), tokenId);
764     }
765 
766     /**
767      * @dev Internal function to transfer ownership of a given token ID to another address.
768      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
769      * @param from current owner of the token
770      * @param to address to receive the ownership of the given token ID
771      * @param tokenId uint256 ID of the token to be transferred
772      */
773     function _transferFrom(address from, address to, uint256 tokenId) internal {
774         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
775         require(to != address(0), "ERC721: transfer to the zero address");
776 
777         _clearApproval(tokenId);
778 
779         _ownedTokensCount[from].decrement();
780         _ownedTokensCount[to].increment();
781 
782         _tokenOwner[tokenId] = to;
783 
784         emit Transfer(from, to, tokenId);
785     }
786 
787     /**
788      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
789      * The call is not executed if the target address is not a contract.
790      *
791      * This is an internal detail of the `ERC721` contract and its use is deprecated.
792      * @param from address representing the previous owner of the given token ID
793      * @param to target address that will receive the tokens
794      * @param tokenId uint256 ID of the token to be transferred
795      * @param _data bytes optional data to send along with the call
796      * @return bool whether the call correctly returned the expected magic value
797      */
798     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
799         internal returns (bool)
800     {
801         if (!to.isContract()) {
802             return true;
803         }
804         // solhint-disable-next-line avoid-low-level-calls
805         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
806             IERC721Receiver(to).onERC721Received.selector,
807             _msgSender(),
808             from,
809             tokenId,
810             _data
811         ));
812         if (!success) {
813             if (returndata.length > 0) {
814                 // solhint-disable-next-line no-inline-assembly
815                 assembly {
816                     let returndata_size := mload(returndata)
817                     revert(add(32, returndata), returndata_size)
818                 }
819             } else {
820                 revert("ERC721: transfer to non ERC721Receiver implementer");
821             }
822         } else {
823             bytes4 retval = abi.decode(returndata, (bytes4));
824             return (retval == _ERC721_RECEIVED);
825         }
826     }
827 
828     /**
829      * @dev Private function to clear current approval of a given token ID.
830      * @param tokenId uint256 ID of the token to be transferred
831      */
832     function _clearApproval(uint256 tokenId) private {
833         if (_tokenApprovals[tokenId] != address(0)) {
834             _tokenApprovals[tokenId] = address(0);
835         }
836     }
837 }
838 
839 
840 // File openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol@v2.5.1
841 
842 pragma solidity ^0.5.0;
843 
844 /**
845  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
846  * @dev See https://eips.ethereum.org/EIPS/eip-721
847  */
848 contract IERC721Enumerable is IERC721 {
849     function totalSupply() public view returns (uint256);
850     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
851 
852     function tokenByIndex(uint256 index) public view returns (uint256);
853 }
854 
855 
856 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol@v2.5.1
857 
858 pragma solidity ^0.5.0;
859 
860 
861 
862 
863 /**
864  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
865  * @dev See https://eips.ethereum.org/EIPS/eip-721
866  */
867 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
868     // Mapping from owner to list of owned token IDs
869     mapping(address => uint256[]) private _ownedTokens;
870 
871     // Mapping from token ID to index of the owner tokens list
872     mapping(uint256 => uint256) private _ownedTokensIndex;
873 
874     // Array with all token ids, used for enumeration
875     uint256[] private _allTokens;
876 
877     // Mapping from token id to position in the allTokens array
878     mapping(uint256 => uint256) private _allTokensIndex;
879 
880     /*
881      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
882      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
883      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
884      *
885      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
886      */
887     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
888 
889     /**
890      * @dev Constructor function.
891      */
892     constructor () public {
893         // register the supported interface to conform to ERC721Enumerable via ERC165
894         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
895     }
896 
897     /**
898      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
899      * @param owner address owning the tokens list to be accessed
900      * @param index uint256 representing the index to be accessed of the requested tokens list
901      * @return uint256 token ID at the given index of the tokens list owned by the requested address
902      */
903     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
904         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
905         return _ownedTokens[owner][index];
906     }
907 
908     /**
909      * @dev Gets the total amount of tokens stored by the contract.
910      * @return uint256 representing the total amount of tokens
911      */
912     function totalSupply() public view returns (uint256) {
913         return _allTokens.length;
914     }
915 
916     /**
917      * @dev Gets the token ID at a given index of all the tokens in this contract
918      * Reverts if the index is greater or equal to the total number of tokens.
919      * @param index uint256 representing the index to be accessed of the tokens list
920      * @return uint256 token ID at the given index of the tokens list
921      */
922     function tokenByIndex(uint256 index) public view returns (uint256) {
923         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
924         return _allTokens[index];
925     }
926 
927     /**
928      * @dev Internal function to transfer ownership of a given token ID to another address.
929      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
930      * @param from current owner of the token
931      * @param to address to receive the ownership of the given token ID
932      * @param tokenId uint256 ID of the token to be transferred
933      */
934     function _transferFrom(address from, address to, uint256 tokenId) internal {
935         super._transferFrom(from, to, tokenId);
936 
937         _removeTokenFromOwnerEnumeration(from, tokenId);
938 
939         _addTokenToOwnerEnumeration(to, tokenId);
940     }
941 
942     /**
943      * @dev Internal function to mint a new token.
944      * Reverts if the given token ID already exists.
945      * @param to address the beneficiary that will own the minted token
946      * @param tokenId uint256 ID of the token to be minted
947      */
948     function _mint(address to, uint256 tokenId) internal {
949         super._mint(to, tokenId);
950 
951         _addTokenToOwnerEnumeration(to, tokenId);
952 
953         _addTokenToAllTokensEnumeration(tokenId);
954     }
955 
956     /**
957      * @dev Internal function to burn a specific token.
958      * Reverts if the token does not exist.
959      * Deprecated, use {ERC721-_burn} instead.
960      * @param owner owner of the token to burn
961      * @param tokenId uint256 ID of the token being burned
962      */
963     function _burn(address owner, uint256 tokenId) internal {
964         super._burn(owner, tokenId);
965 
966         _removeTokenFromOwnerEnumeration(owner, tokenId);
967         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
968         _ownedTokensIndex[tokenId] = 0;
969 
970         _removeTokenFromAllTokensEnumeration(tokenId);
971     }
972 
973     /**
974      * @dev Gets the list of token IDs of the requested owner.
975      * @param owner address owning the tokens
976      * @return uint256[] List of token IDs owned by the requested address
977      */
978     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
979         return _ownedTokens[owner];
980     }
981 
982     /**
983      * @dev Private function to add a token to this extension's ownership-tracking data structures.
984      * @param to address representing the new owner of the given token ID
985      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
986      */
987     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
988         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
989         _ownedTokens[to].push(tokenId);
990     }
991 
992     /**
993      * @dev Private function to add a token to this extension's token tracking data structures.
994      * @param tokenId uint256 ID of the token to be added to the tokens list
995      */
996     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
997         _allTokensIndex[tokenId] = _allTokens.length;
998         _allTokens.push(tokenId);
999     }
1000 
1001     /**
1002      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1003      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1004      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1005      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1006      * @param from address representing the previous owner of the given token ID
1007      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1008      */
1009     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1010         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1011         // then delete the last slot (swap and pop).
1012 
1013         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1014         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1015 
1016         // When the token to delete is the last token, the swap operation is unnecessary
1017         if (tokenIndex != lastTokenIndex) {
1018             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1019 
1020             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1021             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1022         }
1023 
1024         // This also deletes the contents at the last position of the array
1025         _ownedTokens[from].length--;
1026 
1027         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1028         // lastTokenId, or just over the end of the array if the token was the last one).
1029     }
1030 
1031     /**
1032      * @dev Private function to remove a token from this extension's token tracking data structures.
1033      * This has O(1) time complexity, but alters the order of the _allTokens array.
1034      * @param tokenId uint256 ID of the token to be removed from the tokens list
1035      */
1036     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1037         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1038         // then delete the last slot (swap and pop).
1039 
1040         uint256 lastTokenIndex = _allTokens.length.sub(1);
1041         uint256 tokenIndex = _allTokensIndex[tokenId];
1042 
1043         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1044         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1045         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1046         uint256 lastTokenId = _allTokens[lastTokenIndex];
1047 
1048         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1049         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1050 
1051         // This also deletes the contents at the last position of the array
1052         _allTokens.length--;
1053         _allTokensIndex[tokenId] = 0;
1054     }
1055 }
1056 
1057 
1058 // File openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol@v2.5.1
1059 
1060 pragma solidity ^0.5.0;
1061 
1062 /**
1063  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1064  * @dev See https://eips.ethereum.org/EIPS/eip-721
1065  */
1066 contract IERC721Metadata is IERC721 {
1067     function name() external view returns (string memory);
1068     function symbol() external view returns (string memory);
1069     function tokenURI(uint256 tokenId) external view returns (string memory);
1070 }
1071 
1072 
1073 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol@v2.5.1
1074 
1075 pragma solidity ^0.5.0;
1076 
1077 
1078 
1079 
1080 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1081     // Token name
1082     string private _name;
1083 
1084     // Token symbol
1085     string private _symbol;
1086 
1087     // Base URI
1088     string private _baseURI;
1089 
1090     // Optional mapping for token URIs
1091     mapping(uint256 => string) private _tokenURIs;
1092 
1093     /*
1094      *     bytes4(keccak256('name()')) == 0x06fdde03
1095      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1096      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1097      *
1098      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1099      */
1100     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1101 
1102     /**
1103      * @dev Constructor function
1104      */
1105     constructor (string memory name, string memory symbol) public {
1106         _name = name;
1107         _symbol = symbol;
1108 
1109         // register the supported interfaces to conform to ERC721 via ERC165
1110         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1111     }
1112 
1113     /**
1114      * @dev Gets the token name.
1115      * @return string representing the token name
1116      */
1117     function name() external view returns (string memory) {
1118         return _name;
1119     }
1120 
1121     /**
1122      * @dev Gets the token symbol.
1123      * @return string representing the token symbol
1124      */
1125     function symbol() external view returns (string memory) {
1126         return _symbol;
1127     }
1128 
1129     /**
1130      * @dev Returns the URI for a given token ID. May return an empty string.
1131      *
1132      * If the token's URI is non-empty and a base URI was set (via
1133      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1134      *
1135      * Reverts if the token ID does not exist.
1136      */
1137     function tokenURI(uint256 tokenId) external view returns (string memory) {
1138         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1139 
1140         string memory _tokenURI = _tokenURIs[tokenId];
1141 
1142         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1143         if (bytes(_tokenURI).length == 0) {
1144             return "";
1145         } else {
1146             // abi.encodePacked is being used to concatenate strings
1147             return string(abi.encodePacked(_baseURI, _tokenURI));
1148         }
1149     }
1150 
1151     /**
1152      * @dev Internal function to set the token URI for a given token.
1153      *
1154      * Reverts if the token ID does not exist.
1155      *
1156      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1157      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1158      * it and save gas.
1159      */
1160     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1161         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1162         _tokenURIs[tokenId] = _tokenURI;
1163     }
1164 
1165     /**
1166      * @dev Internal function to set the base URI for all token IDs. It is
1167      * automatically added as a prefix to the value returned in {tokenURI}.
1168      *
1169      * _Available since v2.5.0._
1170      */
1171     function _setBaseURI(string memory baseURI) internal {
1172         _baseURI = baseURI;
1173     }
1174 
1175     /**
1176     * @dev Returns the base URI set via {_setBaseURI}. This will be
1177     * automatically added as a preffix in {tokenURI} to each token's URI, when
1178     * they are non-empty.
1179     *
1180     * _Available since v2.5.0._
1181     */
1182     function baseURI() external view returns (string memory) {
1183         return _baseURI;
1184     }
1185 
1186     /**
1187      * @dev Internal function to burn a specific token.
1188      * Reverts if the token does not exist.
1189      * Deprecated, use _burn(uint256) instead.
1190      * @param owner owner of the token to burn
1191      * @param tokenId uint256 ID of the token being burned by the msg.sender
1192      */
1193     function _burn(address owner, uint256 tokenId) internal {
1194         super._burn(owner, tokenId);
1195 
1196         // Clear metadata (if any)
1197         if (bytes(_tokenURIs[tokenId]).length != 0) {
1198             delete _tokenURIs[tokenId];
1199         }
1200     }
1201 }
1202 
1203 
1204 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol@v2.5.1
1205 
1206 pragma solidity ^0.5.0;
1207 
1208 
1209 
1210 /**
1211  * @title Full ERC721 Token
1212  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1213  * Moreover, it includes approve all functionality using operator terminology.
1214  *
1215  * See https://eips.ethereum.org/EIPS/eip-721
1216  */
1217 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1218     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1219         // solhint-disable-previous-line no-empty-blocks
1220     }
1221 }
1222 
1223 
1224 // File openzeppelin-solidity/contracts/token/ERC20/IERC20.sol@v2.5.1
1225 
1226 pragma solidity ^0.5.0;
1227 
1228 /**
1229  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1230  * the optional functions; to access them see {ERC20Detailed}.
1231  */
1232 interface IERC20 {
1233     /**
1234      * @dev Returns the amount of tokens in existence.
1235      */
1236     function totalSupply() external view returns (uint256);
1237 
1238     /**
1239      * @dev Returns the amount of tokens owned by `account`.
1240      */
1241     function balanceOf(address account) external view returns (uint256);
1242 
1243     /**
1244      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1245      *
1246      * Returns a boolean value indicating whether the operation succeeded.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function transfer(address recipient, uint256 amount) external returns (bool);
1251 
1252     /**
1253      * @dev Returns the remaining number of tokens that `spender` will be
1254      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1255      * zero by default.
1256      *
1257      * This value changes when {approve} or {transferFrom} are called.
1258      */
1259     function allowance(address owner, address spender) external view returns (uint256);
1260 
1261     /**
1262      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1263      *
1264      * Returns a boolean value indicating whether the operation succeeded.
1265      *
1266      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1267      * that someone may use both the old and the new allowance by unfortunate
1268      * transaction ordering. One possible solution to mitigate this race
1269      * condition is to first reduce the spender's allowance to 0 and set the
1270      * desired value afterwards:
1271      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1272      *
1273      * Emits an {Approval} event.
1274      */
1275     function approve(address spender, uint256 amount) external returns (bool);
1276 
1277     /**
1278      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1279      * allowance mechanism. `amount` is then deducted from the caller's
1280      * allowance.
1281      *
1282      * Returns a boolean value indicating whether the operation succeeded.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1287 
1288     /**
1289      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1290      * another (`to`).
1291      *
1292      * Note that `value` may be zero.
1293      */
1294     event Transfer(address indexed from, address indexed to, uint256 value);
1295 
1296     /**
1297      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1298      * a call to {approve}. `value` is the new allowance.
1299      */
1300     event Approval(address indexed owner, address indexed spender, uint256 value);
1301 }
1302 
1303 
1304 // File openzeppelin-solidity/contracts/ownership/Ownable.sol@v2.5.1
1305 
1306 pragma solidity ^0.5.0;
1307 
1308 /**
1309  * @dev Contract module which provides a basic access control mechanism, where
1310  * there is an account (an owner) that can be granted exclusive access to
1311  * specific functions.
1312  *
1313  * This module is used through inheritance. It will make available the modifier
1314  * `onlyOwner`, which can be applied to your functions to restrict their use to
1315  * the owner.
1316  */
1317 contract Ownable is Context {
1318     address private _owner;
1319 
1320     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1321 
1322     /**
1323      * @dev Initializes the contract setting the deployer as the initial owner.
1324      */
1325     constructor () internal {
1326         address msgSender = _msgSender();
1327         _owner = msgSender;
1328         emit OwnershipTransferred(address(0), msgSender);
1329     }
1330 
1331     /**
1332      * @dev Returns the address of the current owner.
1333      */
1334     function owner() public view returns (address) {
1335         return _owner;
1336     }
1337 
1338     /**
1339      * @dev Throws if called by any account other than the owner.
1340      */
1341     modifier onlyOwner() {
1342         require(isOwner(), "Ownable: caller is not the owner");
1343         _;
1344     }
1345 
1346     /**
1347      * @dev Returns true if the caller is the current owner.
1348      */
1349     function isOwner() public view returns (bool) {
1350         return _msgSender() == _owner;
1351     }
1352 
1353     /**
1354      * @dev Leaves the contract without owner. It will not be possible to call
1355      * `onlyOwner` functions anymore. Can only be called by the current owner.
1356      *
1357      * NOTE: Renouncing ownership will leave the contract without an owner,
1358      * thereby removing any functionality that is only available to the owner.
1359      */
1360     function renounceOwnership() public onlyOwner {
1361         emit OwnershipTransferred(_owner, address(0));
1362         _owner = address(0);
1363     }
1364 
1365     /**
1366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1367      * Can only be called by the current owner.
1368      */
1369     function transferOwnership(address newOwner) public onlyOwner {
1370         _transferOwnership(newOwner);
1371     }
1372 
1373     /**
1374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1375      */
1376     function _transferOwnership(address newOwner) internal {
1377         require(newOwner != address(0), "Ownable: new owner is the zero address");
1378         emit OwnershipTransferred(_owner, newOwner);
1379         _owner = newOwner;
1380     }
1381 }
1382 
1383 
1384 // File openzeppelin-solidity/contracts/access/Roles.sol@v2.5.1
1385 
1386 pragma solidity ^0.5.0;
1387 
1388 /**
1389  * @title Roles
1390  * @dev Library for managing addresses assigned to a Role.
1391  */
1392 library Roles {
1393     struct Role {
1394         mapping (address => bool) bearer;
1395     }
1396 
1397     /**
1398      * @dev Give an account access to this role.
1399      */
1400     function add(Role storage role, address account) internal {
1401         require(!has(role, account), "Roles: account already has role");
1402         role.bearer[account] = true;
1403     }
1404 
1405     /**
1406      * @dev Remove an account's access to this role.
1407      */
1408     function remove(Role storage role, address account) internal {
1409         require(has(role, account), "Roles: account does not have role");
1410         role.bearer[account] = false;
1411     }
1412 
1413     /**
1414      * @dev Check if an account has this role.
1415      * @return bool
1416      */
1417     function has(Role storage role, address account) internal view returns (bool) {
1418         require(account != address(0), "Roles: account is the zero address");
1419         return role.bearer[account];
1420     }
1421 }
1422 
1423 
1424 // File contracts/helpers/strings.sol
1425 
1426 /*
1427  * @title String & slice utility library for Solidity contracts.
1428  * @author Nick Johnson <arachnid@notdot.net>
1429  */
1430 
1431 pragma solidity ^0.5.0;
1432 
1433 library strings {
1434     struct slice {
1435         uint _len;
1436         uint _ptr;
1437     }
1438 
1439     function memcpy(uint dest, uint src, uint len) private pure {
1440         // Copy word-length chunks while possible
1441         for (; len >= 32; len -= 32) {
1442             assembly {
1443                 mstore(dest, mload(src))
1444             }
1445             dest += 32;
1446             src += 32;
1447         }
1448 
1449         // Copy remaining bytes
1450         uint mask = 256 ** (32 - len) - 1;
1451         assembly {
1452             let srcpart := and(mload(src), not(mask))
1453             let destpart := and(mload(dest), mask)
1454             mstore(dest, or(destpart, srcpart))
1455         }
1456     }
1457 
1458     /*
1459      * @dev Returns a slice containing the entire string.
1460      * @param self The string to make a slice from.
1461      * @return A newly allocated slice containing the entire string.
1462      */
1463     function toSlice(string memory self) internal pure returns (slice memory) {
1464         uint ptr;
1465         assembly {
1466             ptr := add(self, 0x20)
1467         }
1468         return slice(bytes(self).length, ptr);
1469     }
1470 
1471     /*
1472      * @dev Returns a newly allocated string containing the concatenation of
1473      *      `self` and `other`.
1474      * @param self The first slice to concatenate.
1475      * @param other The second slice to concatenate.
1476      * @return The concatenation of the two strings.
1477      */
1478     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1479         string memory ret = new string(self._len + other._len);
1480         uint retptr;
1481         assembly {
1482             retptr := add(ret, 32)
1483         }
1484         memcpy(retptr, self._ptr, self._len);
1485         memcpy(retptr + self._len, other._ptr, other._len);
1486         return ret;
1487     }
1488 }
1489 
1490 
1491 // File contracts/Metadata.sol
1492 
1493 /**
1494  * Forked from folia-app/folia-contracts: https://github.com/folia-app/folia-contracts
1495  * Many thanks to Billy Rennekamp <https://github.com/okwme> and Folia <https://www.folia.app/> 💚
1496  */
1497 
1498 pragma solidity ^0.5.0;
1499 
1500 /**
1501  * Metadata contract is upgradeable and returns metadata about Token
1502  */
1503 
1504 contract Metadata {
1505     using strings for *;
1506 
1507     function tokenURI(uint256 _tokenId)
1508         public
1509         pure
1510         returns (string memory _infoUrl)
1511     {
1512         string memory base = "https://seeder.mutant.garden/v1/tokens/";
1513         string memory id = uint2str(_tokenId);
1514         return base.toSlice().concat(id.toSlice());
1515     }
1516 
1517     function uint2str(uint256 i) internal pure returns (string memory) {
1518         if (i == 0) return "0";
1519         uint256 j = i;
1520         uint256 length;
1521         while (j != 0) {
1522             length++;
1523             j /= 10;
1524         }
1525         bytes memory bstr = new bytes(length);
1526         uint256 k = length - 1;
1527         while (i != 0) {
1528             uint256 _uint = 48 + (i % 10);
1529             bstr[k--] = toBytes(_uint)[31];
1530             i /= 10;
1531         }
1532         return string(bstr);
1533     }
1534 
1535     function toBytes(uint256 x) public pure returns (bytes memory b) {
1536         b = new bytes(32);
1537         assembly {
1538             mstore(add(b, 32), x)
1539         }
1540     }
1541 }
1542 
1543 
1544 // File contracts/Seeder.sol
1545 
1546 /**
1547  * Forked from folia-app/folia-contracts: https://github.com/folia-app/folia-contracts
1548  * Many thanks to Billy Rennekamp <https://github.com/okwme> and Folia <https://www.folia.app/> 💚
1549  */
1550 
1551 pragma solidity ^0.5.0;
1552 
1553 
1554 
1555 
1556 
1557 contract Seeder is ERC721Full, Ownable {
1558     using Roles for Roles.Role;
1559     Roles.Role private _admins;
1560     uint8 admins;
1561     
1562     address public metadata;
1563     address public controller;
1564 
1565     modifier onlyAdminOrController() {
1566         require(
1567             (_admins.has(msg.sender) || msg.sender == controller),
1568             "You are not an admin or controller"
1569         );
1570         _;
1571     }
1572 
1573     constructor(
1574         string memory name,
1575         string memory symbol,
1576         address _metadata
1577     ) public ERC721Full(name, symbol) {
1578         metadata = _metadata;
1579         _admins.add(msg.sender);
1580         admins += 1;
1581     }
1582 
1583     function mint(address recipient, uint256 tokenId)
1584         public
1585         onlyAdminOrController
1586         returns (uint256)
1587     {
1588         _mint(recipient, tokenId);
1589     }
1590 
1591     function burn(uint256 tokenId) public onlyAdminOrController {
1592         _burn(ownerOf(tokenId), tokenId);
1593     }
1594 
1595     function updateMetadata(address _metadata) public onlyAdminOrController {
1596         metadata = _metadata;
1597     }
1598 
1599     function updateController(address _controller)
1600         public
1601         onlyAdminOrController
1602     {
1603         controller = _controller;
1604     }
1605 
1606     function addAdmin(address _admin) public onlyOwner {
1607         _admins.add(_admin);
1608         admins += 1;
1609     }
1610 
1611     function removeAdmin(address _admin) public onlyOwner {
1612         require(admins > 1, "Cannot remove the last admin");
1613         _admins.remove(_admin);
1614         admins -= 1;
1615     }
1616 
1617     function tokenURI(uint256 _tokenId)
1618         external
1619         view
1620         returns (string memory _infoUrl)
1621     {
1622         return Metadata(metadata).tokenURI(_tokenId);
1623     }
1624     
1625     /**
1626      * @dev Moves Token to a certain address.
1627      * @param _to The address to receive the Token.
1628      * @param _amount The amount of Token to be transferred.
1629      * @param _token The address of the Token to be transferred.
1630      */
1631     function moveToken(
1632         address _to,
1633         uint256 _amount,
1634         address _token
1635     ) public onlyAdminOrController returns (bool) {
1636         require(_amount <= IERC20(_token).balanceOf(address(this)));
1637         return IERC20(_token).transfer(_to, _amount);
1638     }
1639 }
1640 
1641 
1642 // File openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol@v2.5.1
1643 
1644 pragma solidity ^0.5.0;
1645 
1646 /**
1647  * @dev Contract module that helps prevent reentrant calls to a function.
1648  *
1649  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1650  * available, which can be applied to functions to make sure there are no nested
1651  * (reentrant) calls to them.
1652  *
1653  * Note that because there is a single `nonReentrant` guard, functions marked as
1654  * `nonReentrant` may not call one another. This can be worked around by making
1655  * those functions `private`, and then adding `external` `nonReentrant` entry
1656  * points to them.
1657  *
1658  * TIP: If you would like to learn more about reentrancy and alternative ways
1659  * to protect against it, check out our blog post
1660  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1661  *
1662  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
1663  * metering changes introduced in the Istanbul hardfork.
1664  */
1665 contract ReentrancyGuard {
1666     bool private _notEntered;
1667 
1668     constructor () internal {
1669         // Storing an initial non-zero value makes deployment a bit more
1670         // expensive, but in exchange the refund on every call to nonReentrant
1671         // will be lower in amount. Since refunds are capped to a percetange of
1672         // the total transaction's gas, it is best to keep them low in cases
1673         // like this one, to increase the likelihood of the full refund coming
1674         // into effect.
1675         _notEntered = true;
1676     }
1677 
1678     /**
1679      * @dev Prevents a contract from calling itself, directly or indirectly.
1680      * Calling a `nonReentrant` function from another `nonReentrant`
1681      * function is not supported. It is possible to prevent this from happening
1682      * by making the `nonReentrant` function external, and make it call a
1683      * `private` function that does the actual work.
1684      */
1685     modifier nonReentrant() {
1686         // On the first call to nonReentrant, _notEntered will be true
1687         require(_notEntered, "ReentrancyGuard: reentrant call");
1688 
1689         // Any calls to nonReentrant after this point will fail
1690         _notEntered = false;
1691 
1692         _;
1693 
1694         // By storing the original value once again, a refund is triggered (see
1695         // https://eips.ethereum.org/EIPS/eip-2200)
1696         _notEntered = true;
1697     }
1698 }
1699 
1700 
1701 // File contracts/SeederController.sol
1702 
1703 /**
1704  * Forked from folia-app/folia-contracts: https://github.com/folia-app/folia-contracts
1705  * Many thanks to Billy Rennekamp <https://github.com/okwme> and Folia <https://www.folia.app/> 💚
1706  */
1707 
1708 pragma solidity ^0.5.0;
1709 
1710 
1711 
1712 
1713 contract SeederController is Ownable, ReentrancyGuard {
1714     address payable public artist;
1715     uint256 public price = 0.33 ether;
1716     uint256 public adminSplit = 15;
1717     uint256 public minBlockAge = 10;
1718     uint256 public maxBlockAge = 64;
1719     bool public paused = false;
1720     uint256 constant MAX_TOKENS = 512;
1721     // mapping (uint256 => uint256) public birthBlocks;
1722     // mapping (uint256 => bool) public exists;
1723 
1724     event updated(
1725         address payable artist,
1726         uint256 price,
1727         uint256 adminSplit,
1728         bool paused
1729     );
1730 
1731     event editionBought(
1732         uint256 tokenId,
1733         address recipient,
1734         uint256 paid,
1735         uint256 artistReceived,
1736         uint256 adminReceived
1737     );
1738 
1739     using SafeMath for uint256;
1740 
1741     address payable public adminWallet;
1742     Seeder public seeder;
1743 
1744     modifier notPaused() {
1745         require(!paused, "Controller is paused");
1746         _;
1747     }
1748 
1749     constructor(Seeder _seeder, address payable _adminWallet) public {
1750         seeder = _seeder;
1751         adminWallet = _adminWallet;
1752     }
1753 
1754     function updatePaused(bool _paused)
1755         public
1756         onlyOwner
1757     {
1758         paused = _paused;
1759         emit updated(
1760             artist,
1761             price,
1762             adminSplit,
1763             paused
1764         );
1765     }
1766 
1767     function updatePrice(uint256 _price)
1768         public
1769         onlyOwner
1770     {
1771         price = _price;
1772         emit updated(
1773             artist,
1774             price,
1775             adminSplit,
1776             paused
1777         );
1778     }
1779 
1780     function buy(address recipient, uint256 tokenId)
1781         public
1782         payable
1783         notPaused
1784         nonReentrant
1785     {
1786         require(msg.value >= price, "You did not send enough ether");
1787         // require(tokenId >= doNotMintBeforeBlock, "That's too far back in history");
1788         require(block.number >= tokenId + minBlockAge, "Cannot mint a mutant in the future");
1789         require(block.number < tokenId + maxBlockAge, "Cannot mint a mutant to far in the past");
1790         uint256 totalSupply = seeder.totalSupply();
1791         require(totalSupply <= MAX_TOKENS, "No more available mutants to mint");
1792 
1793         seeder.mint(recipient, tokenId);
1794 
1795         uint256 adminReceives = msg.value.mul(adminSplit).div(100);
1796         uint256 artistReceives = msg.value.sub(adminReceives);
1797         
1798         bool success;
1799         (success, ) = adminWallet.call.value(adminReceives)("");
1800         require(success, "Admin failed to receive");
1801         (success, ) = artist.call.value(artistReceives)("");
1802         require(success, "Artist failed to receive");
1803 
1804         emit editionBought(
1805             tokenId,
1806             recipient,
1807             msg.value,
1808             artistReceives,
1809             adminReceives
1810         );
1811     }
1812 
1813     function updateAdminSplit(uint256 _adminSplit) public onlyOwner {
1814         require(adminSplit <= 100, "The admin split must be less or equal to 100");
1815         adminSplit = _adminSplit;
1816         emit updated(
1817             artist,
1818             price,
1819             adminSplit,
1820             paused
1821         );
1822     }
1823 
1824     function updateAdminWallet(address payable _adminWallet) public onlyOwner {
1825         adminWallet = _adminWallet;
1826     }
1827 
1828     function updateArtist(address payable _artist) public onlyOwner {
1829         artist = _artist;
1830     }
1831 
1832     function updateMinBlockAge(uint256  _minBlockAge) public onlyOwner {
1833         minBlockAge = _minBlockAge;
1834     }
1835 
1836     function updateMaxBlockAge(uint256  _maxBlockAge) public onlyOwner {
1837         maxBlockAge = _maxBlockAge;
1838     }
1839 }