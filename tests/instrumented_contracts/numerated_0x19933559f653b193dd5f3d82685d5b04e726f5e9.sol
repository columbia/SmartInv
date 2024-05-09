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
31 // File: contracts/Ownable.sol
32 
33 pragma solidity >0.5.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     // Initialzation flag
47     bool private _initialized;
48     
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         _initialized = true;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(isOwner(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Returns true if the caller is the current owner.
80      */
81     function isOwner() public view returns (bool) {
82         return _msgSender() == _owner;
83     }
84     
85     /**
86      * @dev Sets up initial owner for the ownable contract.
87      * Can only be called once.
88      */
89     function setupOwnership() public {
90         require(!_initialized, "Ownable: already initialized");
91         
92         address msgSender = _msgSender();
93         emit OwnershipTransferred(address(0), msgSender);
94         _owner = msgSender;
95         _initialized = true;
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions anymore. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby removing any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Can only be called by the current owner.
113      */
114     function transferOwnership(address newOwner) public onlyOwner {
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      */
121     function _transferOwnership(address newOwner) internal {
122         require(newOwner != address(0), "Ownable: new owner is the zero address");
123         emit OwnershipTransferred(_owner, newOwner);
124         _owner = newOwner;
125     }
126 }
127 
128 // File: @openzeppelin/contracts/introspection/IERC165.sol
129 
130 pragma solidity ^0.5.0;
131 
132 /**
133  * @dev Interface of the ERC165 standard, as defined in the
134  * https://eips.ethereum.org/EIPS/eip-165[EIP].
135  *
136  * Implementers can declare support of contract interfaces, which can then be
137  * queried by others ({ERC165Checker}).
138  *
139  * For an implementation, see {ERC165}.
140  */
141 interface IERC165 {
142     /**
143      * @dev Returns true if this contract implements the interface defined by
144      * `interfaceId`. See the corresponding
145      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
146      * to learn more about how these ids are created.
147      *
148      * This function call must use less than 30 000 gas.
149      */
150     function supportsInterface(bytes4 interfaceId) external view returns (bool);
151 }
152 
153 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
154 
155 pragma solidity ^0.5.0;
156 
157 
158 /**
159  * @dev Required interface of an ERC721 compliant contract.
160  */
161 contract IERC721 is IERC165 {
162     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
163     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
164     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
165 
166     /**
167      * @dev Returns the number of NFTs in `owner`'s account.
168      */
169     function balanceOf(address owner) public view returns (uint256 balance);
170 
171     /**
172      * @dev Returns the owner of the NFT specified by `tokenId`.
173      */
174     function ownerOf(uint256 tokenId) public view returns (address owner);
175 
176     /**
177      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
178      * another (`to`).
179      *
180      *
181      *
182      * Requirements:
183      * - `from`, `to` cannot be zero.
184      * - `tokenId` must be owned by `from`.
185      * - If the caller is not `from`, it must be have been allowed to move this
186      * NFT by either {approve} or {setApprovalForAll}.
187      */
188     function safeTransferFrom(address from, address to, uint256 tokenId) public;
189     /**
190      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
191      * another (`to`).
192      *
193      * Requirements:
194      * - If the caller is not `from`, it must be approved to move this NFT by
195      * either {approve} or {setApprovalForAll}.
196      */
197     function transferFrom(address from, address to, uint256 tokenId) public;
198     function approve(address to, uint256 tokenId) public;
199     function getApproved(uint256 tokenId) public view returns (address operator);
200 
201     function setApprovalForAll(address operator, bool _approved) public;
202     function isApprovedForAll(address owner, address operator) public view returns (bool);
203 
204 
205     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
206 }
207 
208 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
209 
210 pragma solidity ^0.5.0;
211 
212 /**
213  * @title ERC721 token receiver interface
214  * @dev Interface for any contract that wants to support safeTransfers
215  * from ERC721 asset contracts.
216  */
217 contract IERC721Receiver {
218     /**
219      * @notice Handle the receipt of an NFT
220      * @dev The ERC721 smart contract calls this function on the recipient
221      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
222      * otherwise the caller will revert the transaction. The selector to be
223      * returned can be obtained as `this.onERC721Received.selector`. This
224      * function MAY throw to revert and reject the transfer.
225      * Note: the ERC721 contract address is always the message sender.
226      * @param operator The address which called `safeTransferFrom` function
227      * @param from The address which previously owned the token
228      * @param tokenId The NFT identifier which is being transferred
229      * @param data Additional data with no specified format
230      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
231      */
232     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
233     public returns (bytes4);
234 }
235 
236 // File: @openzeppelin/contracts/math/SafeMath.sol
237 
238 pragma solidity ^0.5.0;
239 
240 /**
241  * @dev Wrappers over Solidity's arithmetic operations with added overflow
242  * checks.
243  *
244  * Arithmetic operations in Solidity wrap on overflow. This can easily result
245  * in bugs, because programmers usually assume that an overflow raises an
246  * error, which is the standard behavior in high level programming languages.
247  * `SafeMath` restores this intuition by reverting the transaction when an
248  * operation overflows.
249  *
250  * Using this library instead of the unchecked operations eliminates an entire
251  * class of bugs, so it's recommended to use it always.
252  */
253 library SafeMath {
254     /**
255      * @dev Returns the addition of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `+` operator.
259      *
260      * Requirements:
261      * - Addition cannot overflow.
262      */
263     function add(uint256 a, uint256 b) internal pure returns (uint256) {
264         uint256 c = a + b;
265         require(c >= a, "SafeMath: addition overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting on
272      * overflow (when the result is negative).
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280         return sub(a, b, "SafeMath: subtraction overflow");
281     }
282 
283     /**
284      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
285      * overflow (when the result is negative).
286      *
287      * Counterpart to Solidity's `-` operator.
288      *
289      * Requirements:
290      * - Subtraction cannot overflow.
291      *
292      * _Available since v2.4.0._
293      */
294     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         require(b <= a, errorMessage);
296         uint256 c = a - b;
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the multiplication of two unsigned integers, reverting on
303      * overflow.
304      *
305      * Counterpart to Solidity's `*` operator.
306      *
307      * Requirements:
308      * - Multiplication cannot overflow.
309      */
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
312         // benefit is lost if 'b' is also tested.
313         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
314         if (a == 0) {
315             return 0;
316         }
317 
318         uint256 c = a * b;
319         require(c / a == b, "SafeMath: multiplication overflow");
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the integer division of two unsigned integers. Reverts on
326      * division by zero. The result is rounded towards zero.
327      *
328      * Counterpart to Solidity's `/` operator. Note: this function uses a
329      * `revert` opcode (which leaves remaining gas untouched) while Solidity
330      * uses an invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b) internal pure returns (uint256) {
336         return div(a, b, "SafeMath: division by zero");
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
341      * division by zero. The result is rounded towards zero.
342      *
343      * Counterpart to Solidity's `/` operator. Note: this function uses a
344      * `revert` opcode (which leaves remaining gas untouched) while Solidity
345      * uses an invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      *
350      * _Available since v2.4.0._
351      */
352     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
353         // Solidity only automatically asserts when dividing by 0
354         require(b > 0, errorMessage);
355         uint256 c = a / b;
356         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
357 
358         return c;
359     }
360 
361     /**
362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
363      * Reverts when dividing by zero.
364      *
365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
366      * opcode (which leaves remaining gas untouched) while Solidity uses an
367      * invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      * - The divisor cannot be zero.
371      */
372     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
373         return mod(a, b, "SafeMath: modulo by zero");
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
378      * Reverts with custom message when dividing by zero.
379      *
380      * Counterpart to Solidity's `%` operator. This function uses a `revert`
381      * opcode (which leaves remaining gas untouched) while Solidity uses an
382      * invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      * - The divisor cannot be zero.
386      *
387      * _Available since v2.4.0._
388      */
389     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
390         require(b != 0, errorMessage);
391         return a % b;
392     }
393 }
394 
395 // File: @openzeppelin/contracts/utils/Address.sol
396 
397 pragma solidity ^0.5.5;
398 
399 /**
400  * @dev Collection of functions related to the address type
401  */
402 library Address {
403     /**
404      * @dev Returns true if `account` is a contract.
405      *
406      * This test is non-exhaustive, and there may be false-negatives: during the
407      * execution of a contract's constructor, its address will be reported as
408      * not containing a contract.
409      *
410      * IMPORTANT: It is unsafe to assume that an address for which this
411      * function returns false is an externally-owned account (EOA) and not a
412      * contract.
413      */
414     function isContract(address account) internal view returns (bool) {
415         // This method relies in extcodesize, which returns 0 for contracts in
416         // construction, since the code is only stored at the end of the
417         // constructor execution.
418 
419         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
420         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
421         // for accounts without code, i.e. `keccak256('')`
422         bytes32 codehash;
423         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
424         // solhint-disable-next-line no-inline-assembly
425         assembly { codehash := extcodehash(account) }
426         return (codehash != 0x0 && codehash != accountHash);
427     }
428 
429     /**
430      * @dev Converts an `address` into `address payable`. Note that this is
431      * simply a type cast: the actual underlying value is not changed.
432      *
433      * _Available since v2.4.0._
434      */
435     function toPayable(address account) internal pure returns (address payable) {
436         return address(uint160(account));
437     }
438 
439     /**
440      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
441      * `recipient`, forwarding all available gas and reverting on errors.
442      *
443      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
444      * of certain opcodes, possibly making contracts go over the 2300 gas limit
445      * imposed by `transfer`, making them unable to receive funds via
446      * `transfer`. {sendValue} removes this limitation.
447      *
448      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
449      *
450      * IMPORTANT: because control is transferred to `recipient`, care must be
451      * taken to not create reentrancy vulnerabilities. Consider using
452      * {ReentrancyGuard} or the
453      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
454      *
455      * _Available since v2.4.0._
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(address(this).balance >= amount, "Address: insufficient balance");
459 
460         // solhint-disable-next-line avoid-call-value
461         (bool success, ) = recipient.call.value(amount)("");
462         require(success, "Address: unable to send value, recipient may have reverted");
463     }
464 }
465 
466 // File: @openzeppelin/contracts/drafts/Counters.sol
467 
468 pragma solidity ^0.5.0;
469 
470 
471 /**
472  * @title Counters
473  * @author Matt Condon (@shrugs)
474  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
475  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
476  *
477  * Include with `using Counters for Counters.Counter;`
478  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
479  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
480  * directly accessed.
481  */
482 library Counters {
483     using SafeMath for uint256;
484 
485     struct Counter {
486         // This variable should never be directly accessed by users of the library: interactions must be restricted to
487         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
488         // this feature: see https://github.com/ethereum/solidity/issues/4637
489         uint256 _value; // default: 0
490     }
491 
492     function current(Counter storage counter) internal view returns (uint256) {
493         return counter._value;
494     }
495 
496     function increment(Counter storage counter) internal {
497         counter._value += 1;
498     }
499 
500     function decrement(Counter storage counter) internal {
501         counter._value = counter._value.sub(1);
502     }
503 }
504 
505 // File: @openzeppelin/contracts/introspection/ERC165.sol
506 
507 pragma solidity ^0.5.0;
508 
509 
510 /**
511  * @dev Implementation of the {IERC165} interface.
512  *
513  * Contracts may inherit from this and call {_registerInterface} to declare
514  * their support of an interface.
515  */
516 contract ERC165 is IERC165 {
517     /*
518      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
519      */
520     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
521 
522     /**
523      * @dev Mapping of interface ids to whether or not it's supported.
524      */
525     mapping(bytes4 => bool) private _supportedInterfaces;
526 
527     constructor () internal {
528         // Derived contracts need only register support for their own interfaces,
529         // we register support for ERC165 itself here
530         _registerInterface(_INTERFACE_ID_ERC165);
531     }
532 
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      *
536      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
537      */
538     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
539         return _supportedInterfaces[interfaceId];
540     }
541 
542     /**
543      * @dev Registers the contract as an implementer of the interface defined by
544      * `interfaceId`. Support of the actual ERC165 interface is automatic and
545      * registering its interface id is not required.
546      *
547      * See {IERC165-supportsInterface}.
548      *
549      * Requirements:
550      *
551      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
552      */
553     function _registerInterface(bytes4 interfaceId) internal {
554         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
555         _supportedInterfaces[interfaceId] = true;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
560 
561 pragma solidity ^0.5.0;
562 
563 
564 
565 
566 
567 
568 
569 
570 /**
571  * @title ERC721 Non-Fungible Token Standard basic implementation
572  * @dev see https://eips.ethereum.org/EIPS/eip-721
573  */
574 contract ERC721 is Context, ERC165, IERC721 {
575     using SafeMath for uint256;
576     using Address for address;
577     using Counters for Counters.Counter;
578 
579     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
580     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
581     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
582 
583     // Mapping from token ID to owner
584     mapping (uint256 => address) private _tokenOwner;
585 
586     // Mapping from token ID to approved address
587     mapping (uint256 => address) private _tokenApprovals;
588 
589     // Mapping from owner to number of owned token
590     mapping (address => Counters.Counter) private _ownedTokensCount;
591 
592     // Mapping from owner to operator approvals
593     mapping (address => mapping (address => bool)) private _operatorApprovals;
594 
595     /*
596      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
597      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
598      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
599      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
600      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
601      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
602      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
603      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
604      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
605      *
606      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
607      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
608      */
609     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
610 
611     constructor () public {
612         // register the supported interfaces to conform to ERC721 via ERC165
613         _registerInterface(_INTERFACE_ID_ERC721);
614     }
615 
616     /**
617      * @dev Gets the balance of the specified address.
618      * @param owner address to query the balance of
619      * @return uint256 representing the amount owned by the passed address
620      */
621     function balanceOf(address owner) public view returns (uint256) {
622         require(owner != address(0), "ERC721: balance query for the zero address");
623 
624         return _ownedTokensCount[owner].current();
625     }
626 
627     /**
628      * @dev Gets the owner of the specified token ID.
629      * @param tokenId uint256 ID of the token to query the owner of
630      * @return address currently marked as the owner of the given token ID
631      */
632     function ownerOf(uint256 tokenId) public view returns (address) {
633         address owner = _tokenOwner[tokenId];
634         require(owner != address(0), "ERC721: owner query for nonexistent token");
635 
636         return owner;
637     }
638 
639     /**
640      * @dev Approves another address to transfer the given token ID
641      * The zero address indicates there is no approved address.
642      * There can only be one approved address per token at a given time.
643      * Can only be called by the token owner or an approved operator.
644      * @param to address to be approved for the given token ID
645      * @param tokenId uint256 ID of the token to be approved
646      */
647     function approve(address to, uint256 tokenId) public {
648         address owner = ownerOf(tokenId);
649         require(to != owner, "ERC721: approval to current owner");
650 
651         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
652             "ERC721: approve caller is not owner nor approved for all"
653         );
654 
655         _tokenApprovals[tokenId] = to;
656         emit Approval(owner, to, tokenId);
657     }
658 
659     /**
660      * @dev Gets the approved address for a token ID, or zero if no address set
661      * Reverts if the token ID does not exist.
662      * @param tokenId uint256 ID of the token to query the approval of
663      * @return address currently approved for the given token ID
664      */
665     function getApproved(uint256 tokenId) public view returns (address) {
666         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
667 
668         return _tokenApprovals[tokenId];
669     }
670 
671     /**
672      * @dev Sets or unsets the approval of a given operator
673      * An operator is allowed to transfer all tokens of the sender on their behalf.
674      * @param to operator address to set the approval
675      * @param approved representing the status of the approval to be set
676      */
677     function setApprovalForAll(address to, bool approved) public {
678         require(to != _msgSender(), "ERC721: approve to caller");
679 
680         _operatorApprovals[_msgSender()][to] = approved;
681         emit ApprovalForAll(_msgSender(), to, approved);
682     }
683 
684     /**
685      * @dev Tells whether an operator is approved by a given owner.
686      * @param owner owner address which you want to query the approval of
687      * @param operator operator address which you want to query the approval of
688      * @return bool whether the given operator is approved by the given owner
689      */
690     function isApprovedForAll(address owner, address operator) public view returns (bool) {
691         return _operatorApprovals[owner][operator];
692     }
693 
694     /**
695      * @dev Transfers the ownership of a given token ID to another address.
696      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
697      * Requires the msg.sender to be the owner, approved, or operator.
698      * @param from current owner of the token
699      * @param to address to receive the ownership of the given token ID
700      * @param tokenId uint256 ID of the token to be transferred
701      */
702     function transferFrom(address from, address to, uint256 tokenId) public {
703         //solhint-disable-next-line max-line-length
704         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
705 
706         _transferFrom(from, to, tokenId);
707     }
708 
709     /**
710      * @dev Safely transfers the ownership of a given token ID to another address
711      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
712      * which is called upon a safe transfer, and return the magic value
713      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
714      * the transfer is reverted.
715      * Requires the msg.sender to be the owner, approved, or operator
716      * @param from current owner of the token
717      * @param to address to receive the ownership of the given token ID
718      * @param tokenId uint256 ID of the token to be transferred
719      */
720     function safeTransferFrom(address from, address to, uint256 tokenId) public {
721         safeTransferFrom(from, to, tokenId, "");
722     }
723 
724     /**
725      * @dev Safely transfers the ownership of a given token ID to another address
726      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
727      * which is called upon a safe transfer, and return the magic value
728      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
729      * the transfer is reverted.
730      * Requires the _msgSender() to be the owner, approved, or operator
731      * @param from current owner of the token
732      * @param to address to receive the ownership of the given token ID
733      * @param tokenId uint256 ID of the token to be transferred
734      * @param _data bytes data to send along with a safe transfer check
735      */
736     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738         _safeTransferFrom(from, to, tokenId, _data);
739     }
740 
741     /**
742      * @dev Safely transfers the ownership of a given token ID to another address
743      * If the target address is a contract, it must implement `onERC721Received`,
744      * which is called upon a safe transfer, and return the magic value
745      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
746      * the transfer is reverted.
747      * Requires the msg.sender to be the owner, approved, or operator
748      * @param from current owner of the token
749      * @param to address to receive the ownership of the given token ID
750      * @param tokenId uint256 ID of the token to be transferred
751      * @param _data bytes data to send along with a safe transfer check
752      */
753     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
754         _transferFrom(from, to, tokenId);
755         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
756     }
757 
758     /**
759      * @dev Returns whether the specified token exists.
760      * @param tokenId uint256 ID of the token to query the existence of
761      * @return bool whether the token exists
762      */
763     function _exists(uint256 tokenId) internal view returns (bool) {
764         address owner = _tokenOwner[tokenId];
765         return owner != address(0);
766     }
767 
768     /**
769      * @dev Returns whether the given spender can transfer a given token ID.
770      * @param spender address of the spender to query
771      * @param tokenId uint256 ID of the token to be transferred
772      * @return bool whether the msg.sender is approved for the given token ID,
773      * is an operator of the owner, or is the owner of the token
774      */
775     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
776         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
777         address owner = ownerOf(tokenId);
778         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
779     }
780 
781     /**
782      * @dev Internal function to safely mint a new token.
783      * Reverts if the given token ID already exists.
784      * If the target address is a contract, it must implement `onERC721Received`,
785      * which is called upon a safe transfer, and return the magic value
786      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
787      * the transfer is reverted.
788      * @param to The address that will own the minted token
789      * @param tokenId uint256 ID of the token to be minted
790      */
791     function _safeMint(address to, uint256 tokenId) internal {
792         _safeMint(to, tokenId, "");
793     }
794 
795     /**
796      * @dev Internal function to safely mint a new token.
797      * Reverts if the given token ID already exists.
798      * If the target address is a contract, it must implement `onERC721Received`,
799      * which is called upon a safe transfer, and return the magic value
800      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
801      * the transfer is reverted.
802      * @param to The address that will own the minted token
803      * @param tokenId uint256 ID of the token to be minted
804      * @param _data bytes data to send along with a safe transfer check
805      */
806     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
807         _mint(to, tokenId);
808         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
809     }
810 
811     /**
812      * @dev Internal function to mint a new token.
813      * Reverts if the given token ID already exists.
814      * @param to The address that will own the minted token
815      * @param tokenId uint256 ID of the token to be minted
816      */
817     function _mint(address to, uint256 tokenId) internal {
818         require(to != address(0), "ERC721: mint to the zero address");
819         require(!_exists(tokenId), "ERC721: token already minted");
820 
821         _tokenOwner[tokenId] = to;
822         _ownedTokensCount[to].increment();
823 
824         emit Transfer(address(0), to, tokenId);
825     }
826 
827     /**
828      * @dev Internal function to burn a specific token.
829      * Reverts if the token does not exist.
830      * Deprecated, use {_burn} instead.
831      * @param owner owner of the token to burn
832      * @param tokenId uint256 ID of the token being burned
833      */
834     function _burn(address owner, uint256 tokenId) internal {
835         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
836 
837         _clearApproval(tokenId);
838 
839         _ownedTokensCount[owner].decrement();
840         _tokenOwner[tokenId] = address(0);
841 
842         emit Transfer(owner, address(0), tokenId);
843     }
844 
845     /**
846      * @dev Internal function to burn a specific token.
847      * Reverts if the token does not exist.
848      * @param tokenId uint256 ID of the token being burned
849      */
850     function _burn(uint256 tokenId) internal {
851         _burn(ownerOf(tokenId), tokenId);
852     }
853 
854     /**
855      * @dev Internal function to transfer ownership of a given token ID to another address.
856      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
857      * @param from current owner of the token
858      * @param to address to receive the ownership of the given token ID
859      * @param tokenId uint256 ID of the token to be transferred
860      */
861     function _transferFrom(address from, address to, uint256 tokenId) internal {
862         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
863         require(to != address(0), "ERC721: transfer to the zero address");
864 
865         _clearApproval(tokenId);
866 
867         _ownedTokensCount[from].decrement();
868         _ownedTokensCount[to].increment();
869 
870         _tokenOwner[tokenId] = to;
871 
872         emit Transfer(from, to, tokenId);
873     }
874 
875     /**
876      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
877      * The call is not executed if the target address is not a contract.
878      *
879      * This function is deprecated.
880      * @param from address representing the previous owner of the given token ID
881      * @param to target address that will receive the tokens
882      * @param tokenId uint256 ID of the token to be transferred
883      * @param _data bytes optional data to send along with the call
884      * @return bool whether the call correctly returned the expected magic value
885      */
886     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
887         internal returns (bool)
888     {
889         if (!to.isContract()) {
890             return true;
891         }
892 
893         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
894         return (retval == _ERC721_RECEIVED);
895     }
896 
897     /**
898      * @dev Private function to clear current approval of a given token ID.
899      * @param tokenId uint256 ID of the token to be transferred
900      */
901     function _clearApproval(uint256 tokenId) private {
902         if (_tokenApprovals[tokenId] != address(0)) {
903             _tokenApprovals[tokenId] = address(0);
904         }
905     }
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
909 
910 pragma solidity ^0.5.0;
911 
912 
913 /**
914  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
915  * @dev See https://eips.ethereum.org/EIPS/eip-721
916  */
917 contract IERC721Metadata is IERC721 {
918     function name() external view returns (string memory);
919     function symbol() external view returns (string memory);
920     function tokenURI(uint256 tokenId) external view returns (string memory);
921 }
922 
923 // File: contracts/ERC721WithMessage.sol
924 
925 pragma solidity >0.5.0;
926 
927 
928 
929 
930 
931 
932 contract ERC721WithMessage is Context, ERC165, ERC721, IERC721Metadata, Ownable {
933     struct Message {
934       string content;
935       bool encrypted;
936     }
937 
938     // Token name
939     string private _name;
940 
941     // Token symbol
942     string private _symbol;
943 
944     // Token URI
945     string private _tokenURI;
946 
947     // Optional mapping for token messages
948     mapping(uint256 => Message) private _tokenMessages;
949 
950     /*
951      *     bytes4(keccak256('name()')) == 0x06fdde03
952      *     bytes4(keccak256('symbol()')) == 0x95d89b41
953      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
954      *
955      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
956      */
957     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
958 
959     /**
960      * @dev Initializor function
961      */
962     function initialize(string memory name, string memory symbol, string memory tokenURI) public onlyOwner {
963         _name = name;
964         _symbol = symbol;
965         _tokenURI = tokenURI;
966 
967         // register the supported interfaces to conform to ERC721 via ERC165
968         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
969     }
970 
971     /**
972      * @dev Gets the token name.
973      * @return string representing the token name
974      */
975     function name() external view returns (string memory) {
976         return _name;
977     }
978 
979     /**
980      * @dev Gets the token symbol.
981      * @return string representing the token symbol
982      */
983     function symbol() external view returns (string memory) {
984         return _symbol;
985     }
986 
987     /**
988      * @dev Returns the URI for a given token ID. May return an empty string.
989      * @return token metadata URI
990      */
991     function tokenURI(uint256 tokenId) external view returns (string memory) {
992         return _tokenURI;
993     }
994     
995     /**
996      * @dev Returns the message for a given token ID.
997      * @return token message
998      */
999     function tokenMessage(uint256 tokenId) external view returns (string memory, bool) {
1000         Message storage message = _tokenMessages[tokenId];
1001         return (message.content, message.encrypted);
1002     }
1003     
1004     /**
1005      * @dev Function to mint tokens.
1006      * @param to The address that will receive the minted tokens.
1007      * @param tokenId The token id to mint.
1008      * @param message The private message of the minted token.
1009      * @return A boolean that indicates if the operation was successful.
1010      */
1011     function mintWithMessage(address to, uint256 tokenId, string memory message, bool encrypted) public onlyOwner returns (bool) {
1012         _mint(to, tokenId);
1013         _tokenMessages[tokenId] = Message(message, encrypted);
1014         return true;
1015     }
1016 }
1017 
1018 // File: contracts/Cardma.sol
1019 
1020 pragma solidity >0.5.0;
1021 pragma experimental ABIEncoderV2;
1022 
1023 
1024 
1025 contract Cardma is Ownable {
1026     /*
1027      * ----- Type Definitions -----
1028      */
1029     struct Card {
1030         address cardAddress;
1031         string name;
1032         string author;
1033         string description;
1034         string imageURI;
1035         uint256 price;   // Price for the card
1036         uint256 count;   // Current issued card count
1037         uint256 limit;   // Maximum number of cards to issue, limit = 0 means unlimited.
1038     }
1039     
1040     struct SentCard {
1041         address senderAddress;
1042         address keyAddress;
1043         uint256 cardIndex;
1044         uint256 tokenId;
1045         uint256 giftAmount;
1046         uint256 timestamp;
1047         bool claimed;
1048     }
1049 
1050     struct ReadableCard {
1051         address keyAddress;
1052         string imageURI;
1053         string message;
1054         bool encrypted;
1055         uint256 giftAmount;
1056         uint256 timestamp;
1057         bool claimed;
1058     }
1059 
1060     /*
1061      * ----- Contract Variables -----
1062      */
1063     Card[] private _cards;
1064     mapping(address => SentCard) private _sentCards;
1065     mapping(address => address[]) private _sentCardsFromUser;
1066     mapping(address => address[]) private _receivedCardsForUser;
1067 
1068     address private _cardFactoryAddress;
1069     uint256 private _revenue;
1070     
1071     /*
1072      * ----- Internal Methods -----
1073      */
1074     function createCardContract()
1075         internal
1076         returns (address result)
1077     {
1078         bytes20 factoryAddress = bytes20(_cardFactoryAddress);
1079 
1080         // solhint-disable-next-line security/no-inline-assembly
1081         assembly {
1082             let clone := mload(0x40)
1083             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1084             mstore(add(clone, 0x14), factoryAddress)
1085             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1086             result := create(0, clone, 0x37)
1087         }
1088     }
1089     
1090     function uint2str(uint256 _i)
1091         internal
1092         pure
1093         returns (string memory)
1094     {
1095         if (_i == 0) {
1096             return "0";
1097         }
1098         uint j = _i;
1099         uint len;
1100         while (j != 0) {
1101             len++;
1102             j /= 10;
1103         }
1104         bytes memory bstr = new bytes(len);
1105         uint k = len - 1;
1106         while (_i != 0) {
1107             bstr[k--] = byte(uint8(48 + _i % 10));
1108             _i /= 10;
1109         }
1110         return string(bstr);
1111     }
1112 
1113     // check signature before claiming card
1114     modifier checkSignature(
1115         address keyAddress,
1116         uint8 v,
1117         bytes32 r,
1118         bytes32 s
1119     ) {
1120         require(
1121             _sentCards[keyAddress].senderAddress == _msgSender() ||
1122                 keyAddress == ecrecover(getPersonalChallenge(), v, r, s),
1123             "Cardma: invalid signature"
1124         );
1125         _;
1126     }
1127 
1128     // check that index falls withing todo list range
1129     modifier checkIndex(uint256 cardIndex) {
1130         require(cardIndex < _cards.length, "Cardma: card index out of range");
1131         _;
1132     }
1133     
1134     /*
1135      * ----- Owner Methods -----
1136      */
1137     function setupCardFactory(address cardFactoryAddress)
1138         public
1139         onlyOwner
1140     {
1141         _cardFactoryAddress = cardFactoryAddress;
1142     }
1143      
1144     function addCard(
1145         string memory name,
1146         string memory author,
1147         string memory description,
1148         string memory imageURI,
1149         string memory tokenURI,
1150         uint256 price,
1151         uint256 limit
1152     )
1153         public
1154         onlyOwner
1155     {
1156         require(_cardFactoryAddress != address(0), "Cardma: card factory not set");
1157         
1158         uint256 cardIndex = _cards.length;
1159         address cardAddress = createCardContract();
1160         ERC721WithMessage cardContract = ERC721WithMessage(cardAddress);
1161         cardContract.setupOwnership();
1162         cardContract.initialize(
1163             name,
1164             string((abi.encodePacked("CM-", uint2str(cardIndex)))),
1165             tokenURI
1166         );
1167         _cards.push(Card(
1168             cardAddress,
1169             name,
1170             author,
1171             description,
1172             imageURI,
1173             price,
1174             0,
1175             limit
1176         ));
1177     }
1178     
1179     function updateCardPrice(
1180         uint256 cardIndex,
1181         uint256 price
1182     )
1183         public
1184         onlyOwner
1185         checkIndex(cardIndex)
1186     {
1187         _cards[cardIndex].price = price;
1188     }
1189 
1190     function claimAllRevenue()
1191         public
1192         onlyOwner
1193     {
1194         _msgSender().transfer(_revenue);
1195         _revenue = 0;
1196     }
1197 
1198     function getRevenue()
1199         public
1200         view
1201         returns (uint256 revenue)
1202     {
1203         return _revenue;
1204     }
1205     
1206     /*
1207      * ----- Public Methods -----
1208      */
1209     // Default payable function
1210     function()
1211         external
1212         payable
1213     {
1214     }
1215 
1216     function getPersonalChallenge()
1217         public
1218         view
1219         returns (bytes32 challenge)
1220     {
1221         return keccak256(abi.encodePacked(
1222             "portto - make blockchain simple",
1223             _msgSender()
1224         ));
1225     }
1226 
1227     function getCard(uint256 cardIndex)
1228         public
1229         view
1230         checkIndex(cardIndex)
1231         returns (Card memory card)
1232     {
1233         return _cards[cardIndex];
1234     }
1235     
1236     function getCards()
1237         public
1238         view
1239         returns (Card[] memory cards)
1240     {
1241         return _cards;
1242     }
1243     
1244     function sendCard(
1245         address keyAddress,
1246         uint256 cardIndex,
1247         string memory message,
1248         bool encrypted
1249     )
1250         public
1251         payable
1252         checkIndex(cardIndex)
1253     {
1254         Card storage card = _cards[cardIndex];
1255 
1256         // Check card keyAddress
1257         require(_sentCards[keyAddress].keyAddress == address(0), "Cardma: same keyAddress exists");
1258 
1259         // Check card availability
1260         require(card.limit == 0 || card.count < card.limit, "Cardma: desired card has been sold out");
1261 
1262         // Check and charge card price
1263         require(msg.value >= card.price, "Cardma: cannot afford the card");
1264         _revenue += card.price;
1265 
1266         uint256 tokenId = card.count;
1267         // Mint ERC721 token
1268         ERC721WithMessage(card.cardAddress).mintWithMessage(
1269             address(this), // hold token until claimed
1270             tokenId,
1271             message,
1272             encrypted
1273         );
1274 
1275         // Keep token and ETH
1276         address senderAddress = _msgSender();
1277         SentCard memory sentCard = SentCard(
1278             senderAddress,
1279             keyAddress,
1280             cardIndex,
1281             tokenId,
1282             msg.value - card.price,
1283             block.timestamp,
1284             false
1285         );
1286 
1287         // Update contract storage
1288         _sentCards[keyAddress] = sentCard;
1289         _sentCardsFromUser[senderAddress].push(keyAddress);
1290         card.count += 1;
1291     }
1292 
1293     function readCard(address keyAddress)
1294         public
1295         view
1296         returns (ReadableCard memory card)
1297     {
1298         SentCard storage sentCard = _sentCards[keyAddress];
1299 
1300         // Check card exists
1301         require(sentCard.keyAddress == keyAddress, "Cardma: card does not exist");
1302 
1303         Card storage card = _cards[sentCard.cardIndex];
1304 
1305         (string memory message, bool encrypted) = ERC721WithMessage(card.cardAddress).tokenMessage(sentCard.tokenId);
1306 
1307         return ReadableCard(
1308             keyAddress,
1309             card.imageURI,
1310             message,
1311             encrypted,
1312             sentCard.giftAmount,
1313             sentCard.timestamp,
1314             sentCard.claimed
1315         );
1316     }
1317 
1318     function claimCard(
1319         address keyAddress,
1320         uint8 v,
1321         bytes32 r,
1322         bytes32 s
1323     )
1324         public
1325         checkSignature(keyAddress, v, r, s)
1326     {
1327         address payable msgSender = _msgSender();
1328         SentCard storage sentCard = _sentCards[keyAddress];
1329 
1330         // Check card exists
1331         require(sentCard.keyAddress == keyAddress, "Cardma: card does not exist");
1332 
1333         Card storage card = _cards[sentCard.cardIndex];
1334 
1335         // Check card unclaimed
1336         require(!sentCard.claimed, "Cardma: card already claimed");
1337 
1338         // Transfer ERC721 token
1339         ERC721WithMessage(card.cardAddress)
1340             .safeTransferFrom(
1341                 address(this),
1342                 msgSender,
1343                 sentCard.tokenId
1344             );
1345 
1346         // Transfer ETH
1347         msgSender.transfer(sentCard.giftAmount);
1348         _receivedCardsForUser[msgSender].push(keyAddress);
1349         sentCard.claimed = true;
1350     }
1351 
1352     function getMySentCards()
1353         public
1354         view
1355         returns (ReadableCard[] memory sentCards)
1356     {
1357         address[] storage sentCardsFromUser = _sentCardsFromUser[_msgSender()];
1358         ReadableCard[] memory sentCards = new ReadableCard[](sentCardsFromUser.length);
1359 
1360         for(uint i = 0; i < sentCardsFromUser.length; i++) {
1361             sentCards[i] = readCard(sentCardsFromUser[i]);
1362         }
1363 
1364         return sentCards;
1365     }
1366 
1367     function getMyReceivedCards()
1368         public
1369         view
1370         returns (ReadableCard[] memory receivedCards)
1371     {
1372         address[] storage receivedCardsForUser = _receivedCardsForUser[_msgSender()];
1373         ReadableCard[] memory receivedCards = new ReadableCard[](receivedCardsForUser.length);
1374 
1375         for(uint i = 0; i < receivedCardsForUser.length; i++) {
1376             receivedCards[i] = readCard(receivedCardsForUser[i]);
1377         }
1378 
1379         return receivedCards;
1380     }
1381 }