1 // File: contracts\gsn\Context.sol
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
16 
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 
31 }
32 
33 // File: contracts\access\Ownable.sol
34 
35 pragma solidity ^0.5.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 contract Ownable is Context {
51 
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor () internal {
60         address msgSender = _msgSender();
61 
62         _owner = msgSender;
63 
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91 
92         _owner = address(0);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101 
102         emit OwnershipTransferred(_owner, newOwner);
103 
104         _owner = newOwner;
105     }
106 
107 }
108 
109 // File: contracts\utils\Pausable.sol
110 
111 pragma solidity ^0.5.0;
112 
113 
114 /**
115  * @dev Contract module which allows children to implement an emergency stop
116  * mechanism that can be triggered by an authorized account.
117  *
118  * This module is used through inheritance. It will make available the
119  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
120  * the functions of your contract. Note that they will not be pausable by
121  * simply including this module, only once the modifiers are put in place.
122  */
123 contract Pausable is Context {
124 
125     /**
126      * @dev Emitted when the pause is triggered by `account`.
127      */
128     event Paused(address account);
129 
130     /**
131      * @dev Emitted when the pause is lifted by `account`.
132      */
133     event Unpaused(address account);
134 
135     bool private _paused;
136 
137     /**
138      * @dev Initializes the contract in unpaused state.
139      */
140     constructor () internal {
141         _paused = false;
142     }
143 
144     /**
145      * @dev Returns true if the contract is paused, and false otherwise.
146      */
147     function paused() public view returns (bool) {
148         return _paused;
149     }
150 
151     /**
152      * @dev Modifier to make a function callable only when the contract is not paused.
153      *
154      * Requirements:
155      *
156      * - The contract must not be paused.
157      */
158     modifier whenNotPaused() {
159         require(!_paused, "Pausable: paused");
160         _;
161     }
162 
163     /**
164      * @dev Modifier to make a function callable only when the contract is paused.
165      *
166      * Requirements:
167      *
168      * - The contract must be paused.
169      */
170     modifier whenPaused() {
171         require(_paused, "Pausable: not paused");
172         _;
173     }
174 
175     /**
176      * @dev Triggers stopped state.
177      *
178      * Requirements:
179      *
180      * - The contract must not be paused.
181      */
182     function _pause() internal whenNotPaused {
183         _paused = true;
184 
185         emit Paused(_msgSender());
186     }
187 
188     /**
189      * @dev Returns to normal state.
190      *
191      * Requirements:
192      *
193      * - The contract must be paused.
194      */
195     function _unpause() internal whenPaused {
196         _paused = false;
197 
198         emit Unpaused(_msgSender());
199     }
200 
201 }
202 
203 // File: contracts\token\erc721\IERC721Enumerable.sol
204 
205 pragma solidity ^0.5.0;
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Enumerable {
212 
213     /**
214      * @dev Returns the total amount of tokens stored by the contract.
215      */
216     function totalSupply() external view returns (uint256);
217 
218     /**
219      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
220      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
221      */
222     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
223 
224     /**
225      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
226      * Use along with {totalSupply} to enumerate all tokens.
227      */
228     function tokenByIndex(uint256 index) external view returns (uint256);
229 
230 }
231 
232 // File: contracts\libs\SafeMath.sol
233 
234 pragma solidity ^0.5.0;
235 
236 /**
237  * @dev Wrappers over Solidity's arithmetic operations with added overflow
238  * checks.
239  *
240  * Arithmetic operations in Solidity wrap on overflow. This can easily result
241  * in bugs, because programmers usually assume that an overflow raises an
242  * error, which is the standard behavior in high level programming languages.
243  * `SafeMath` restores this intuition by reverting the transaction when an
244  * operation overflows.
245  *
246  * Using this library instead of the unchecked operations eliminates an entire
247  * class of bugs, so it's recommended to use it always.
248  */
249 library SafeMath {
250 
251     /**
252      * @dev Returns the addition of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `+` operator.
256      *
257      * Requirements:
258      * - Addition cannot overflow.
259      */
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         uint256 c = a + b;
262 
263         require(c >= a, "SafeMath: addition overflow");
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the subtraction of two unsigned integers, reverting on
270      * overflow (when the result is negative).
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278         require(b <= a, "SafeMath: subtraction overflow");
279 
280         return a - b;
281     }
282 
283     /**
284      * @dev Returns the multiplication of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `*` operator.
288      *
289      * Requirements:
290      * - Multiplication cannot overflow.
291      */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294         // benefit is lost if 'b' is also tested.
295         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301 
302         require(c / a == b, "SafeMath: multiplication overflow");
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the integer division of two unsigned integers. Reverts on
309      * division by zero. The result is rounded towards zero.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      * - The divisor cannot be zero.
317      */
318     function div(uint256 a, uint256 b) internal pure returns (uint256) {
319         require(b > 0, "SafeMath: division by zero");
320 
321         return a / b;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         require(b > 0, "SafeMath: modulo by zero");
337 
338         return a % b;
339     }
340 
341 }
342 
343 // File: contracts\libs\Counters.sol
344 
345 pragma solidity ^0.5.0;
346 
347 
348 /**
349  * @title Counters
350  * @author Matt Condon (@shrugs)
351  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
352  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
353  *
354  * Include with `using Counters for Counters.Counter;`
355  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
356  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
357  * directly accessed.
358  */
359 library Counters {
360 
361     using SafeMath for uint256;
362 
363     struct Counter {
364         // This variable should never be directly accessed by users of the library: interactions must be restricted to
365         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
366         // this feature: see https://github.com/ethereum/solidity/issues/4637
367         uint256 _value; // default: 0
368     }
369 
370     function current(Counter storage counter) internal view returns (uint256) {
371         return counter._value;
372     }
373 
374     function increment(Counter storage counter) internal {
375         // The {SafeMath} overflow check can be skipped here, see the comment at the top
376         counter._value += 1;
377     }
378 
379     function decrement(Counter storage counter) internal {
380         counter._value = counter._value.sub(1);
381     }
382 
383 }
384 
385 // File: contracts\libs\Address.sol
386 
387 pragma solidity ^0.5.0;
388 
389 /**
390  * @dev Collection of functions related to the address type
391  */
392 library Address {
393 
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
413         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
414         // for accounts without code, i.e. `keccak256('')`
415         bytes32 codehash;
416         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
417 
418         // solhint-disable-next-line no-inline-assembly
419         assembly { codehash := extcodehash(account) }
420 
421         return (codehash != accountHash && codehash != 0x0);
422     }
423 
424     /**
425      * @dev Converts an `address` into `address payable`. Note that this is
426      * simply a type cast: the actual underlying value is not changed.
427      *
428      * _Available since v2.4.0._
429      */
430     function toPayable(address account) internal pure returns (address payable) {
431         return address(uint160(account));
432     }
433 
434 }
435 
436 // File: contracts\token\erc721\IERC721.sol
437 
438 pragma solidity ^0.5.0;
439 
440 /**
441  * @dev Required interface of an ERC721 compliant contract.
442  */
443 interface IERC721 {
444 
445     /**
446      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
447      */
448     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
449 
450     /**
451      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
452      */
453     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
454 
455     /**
456      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
457      */
458     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
459 
460     /**
461      * @dev Returns the number of tokens in ``owner``'s account.
462      */
463     function balanceOf(address owner) external view returns (uint256 balance);
464 
465     /**
466      * @dev Returns the owner of the `tokenId` token.
467      *
468      * Requirements:
469      *
470      * - `tokenId` must exist.
471      */
472     function ownerOf(uint256 tokenId) external view returns (address owner);
473 
474     /**
475      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
476      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
477      *
478      * Requirements:
479      *
480      * - `from`, `to` cannot be zero.
481      * - `tokenId` token must exist and be owned by `from`.
482      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(address from, address to, uint256 tokenId) external;
488 
489     /**
490      * @dev Transfers `tokenId` token from `from` to `to`.
491      *
492      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
493      *
494      * Requirements:
495      *
496      * - `from`, `to` cannot be zero.
497      * - `tokenId` token must be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transferFrom(address from, address to, uint256 tokenId) external;
503 
504     /**
505      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
506      * The approval is cleared when the token is transferred.
507      *
508      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
509      *
510      * Requirements:
511      *
512      * - The caller must own the token or be an approved operator.
513      * - `tokenId` must exist.
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address to, uint256 tokenId) external;
518 
519     /**
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId) external view returns (address operator);
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
542      *
543      * See {setApprovalForAll}
544      */
545     function isApprovedForAll(address owner, address operator) external view returns (bool);
546 
547     /**
548       * @dev Safely transfers `tokenId` token from `from` to `to`.
549       *
550       * Requirements:
551       *
552       * - `from`, `to` cannot be zero.
553       * - `tokenId` token must exist and be owned by `from`.
554       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556       *
557       * Emits a {Transfer} event.
558       */
559     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
560 
561 }
562 
563 // File: contracts\token\erc721\IERC721Receiver.sol
564 
565 pragma solidity ^0.5.0;
566 
567 /**
568  * @title ERC721 token receiver interface
569  * @dev Interface for any contract that wants to support safeTransfers
570  * from ERC721 asset contracts.
571  */
572 interface IERC721Receiver {
573 
574     /**
575      * @notice Handle the receipt of an NFT
576      * @dev The ERC721 smart contract calls this function on the recipient
577      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
578      * otherwise the caller will revert the transaction. The selector to be
579      * returned can be obtained as `this.onERC721Received.selector`. This
580      * function MAY throw to revert and reject the transfer.
581      * Note: the ERC721 contract address is always the message sender.
582      * @param operator The address which called `safeTransferFrom` function
583      * @param from The address which previously owned the token
584      * @param tokenId The NFT identifier which is being transferred
585      * @param data Additional data with no specified format
586      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
587      */
588     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
589 
590 }
591 
592 // File: contracts\token\erc721\IERC165.sol
593 
594 pragma solidity ^0.5.0;
595 
596 /**
597  * @dev Interface of the ERC165 standard, as defined in the
598  * https://eips.ethereum.org/EIPS/eip-165[EIP].
599  *
600  * Implementers can declare support of contract interfaces, which can then be
601  * queried by others ({ERC165Checker}).
602  *
603  * For an implementation, see {ERC165}.
604  */
605 interface IERC165 {
606 
607     /**
608      * @dev Returns true if this contract implements the interface defined by
609      * `interfaceId`. See the corresponding
610      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
611      * to learn more about how these ids are created.
612      *
613      * This function call must use less than 30 000 gas.
614      */
615     function supportsInterface(bytes4 interfaceId) external view returns (bool);
616 
617 }
618 
619 // File: contracts\token\erc721\ERC165.sol
620 
621 pragma solidity ^0.5.0;
622 
623 
624 /**
625  * @dev Implementation of the {IERC165} interface.
626  *
627  * Contracts may inherit from this and call {_registerInterface} to declare
628  * their support of an interface.
629  */
630 contract ERC165 is IERC165 {
631 
632     /*
633      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
634      */
635     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
636 
637     /**
638      * @dev Mapping of interface ids to whether or not it's supported.
639      */
640     mapping(bytes4 => bool) private _supportedInterfaces;
641 
642     constructor () internal {
643         // Derived contracts need only register support for their own interfaces,
644         // we register support for ERC165 itself here
645         _registerInterface(_INTERFACE_ID_ERC165);
646     }
647 
648     /**
649      * @dev See {IERC165-supportsInterface}.
650      *
651      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
652      */
653     function supportsInterface(bytes4 interfaceId) public view returns (bool) {
654         return _supportedInterfaces[interfaceId];
655     }
656 
657     /**
658      * @dev Registers the contract as an implementer of the interface defined by
659      * `interfaceId`. Support of the actual ERC165 interface is automatic and
660      * registering its interface id is not required.
661      *
662      * See {IERC165-supportsInterface}.
663      *
664      * Requirements:
665      *
666      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
667      */
668     function _registerInterface(bytes4 interfaceId) internal {
669         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
670 
671         _supportedInterfaces[interfaceId] = true;
672     }
673 
674 }
675 
676 // File: contracts\token\erc721\ERC721.sol
677 
678 pragma solidity ^0.5.0;
679 
680 
681 
682 
683 
684 
685 
686 
687 /**
688  * @title ERC721 Non-Fungible Token Standard basic implementation
689  * @dev see https://eips.ethereum.org/EIPS/eip-721
690  */
691 contract ERC721 is Context, ERC165, IERC721 {
692 
693     using SafeMath for uint256;
694     using Address for address;
695     using Counters for Counters.Counter;
696 
697     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
698     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
699     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
700 
701     // Mapping from token ID to owner
702     mapping (uint256 => address) private _tokenOwner;
703 
704     // Mapping from token ID to approved address
705     mapping (uint256 => address) private _tokenApprovals;
706 
707     // Mapping from owner to number of owned token
708     mapping (address => Counters.Counter) private _ownedTokensCount;
709 
710     // Mapping from owner to operator approvals
711     mapping (address => mapping (address => bool)) private _operatorApprovals;
712 
713     /*
714      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
715      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
716      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
717      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
718      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
719      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
720      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
721      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
722      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
723      *
724      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
725      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
726      */
727     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
728 
729     constructor () public {
730         // Register the supported interfaces to conform to ERC721 via ERC165
731         _registerInterface(_INTERFACE_ID_ERC721);
732     }
733 
734     /**
735      * @dev Gets the balance of the specified address.
736      * @param owner address to query the balance of
737      * @return uint256 representing the amount owned by the passed address
738      */
739     function balanceOf(address owner) public view returns (uint256) {
740         require(owner != address(0), "ERC721: balance query for the zero address");
741 
742         return _ownedTokensCount[owner].current();
743     }
744 
745     /**
746      * @dev Gets the owner of the specified token ID.
747      * @param tokenId uint256 ID of the token to query the owner of
748      * @return address currently marked as the owner of the given token ID
749      */
750     function ownerOf(uint256 tokenId) public view returns (address) {
751         address owner = _tokenOwner[tokenId];
752 
753         require(owner != address(0), "ERC721: owner query for nonexistent token");
754 
755         return owner;
756     }
757 
758     /**
759      * @dev Approves another address to transfer the given token ID
760      * The zero address indicates there is no approved address.
761      * There can only be one approved address per token at a given time.
762      * Can only be called by the token owner or an approved operator.
763      * @param to address to be approved for the given token ID
764      * @param tokenId uint256 ID of the token to be approved
765      */
766     function approve(address to, uint256 tokenId) public {
767         address owner = ownerOf(tokenId);
768 
769         require(to != owner, "ERC721: approval to current owner");
770 
771         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
772             "ERC721: approve caller is not owner nor approved for all"
773         );
774 
775         _tokenApprovals[tokenId] = to;
776 
777         emit Approval(owner, to, tokenId);
778     }
779 
780     /**
781      * @dev Gets the approved address for a token ID, or zero if no address set
782      * Reverts if the token ID does not exist.
783      * @param tokenId uint256 ID of the token to query the approval of
784      * @return address currently approved for the given token ID
785      */
786     function getApproved(uint256 tokenId) public view returns (address) {
787         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     /**
793      * @dev Sets or unsets the approval of a given operator
794      * An operator is allowed to transfer all tokens of the sender on their behalf.
795      * @param to operator address to set the approval
796      * @param approved representing the status of the approval to be set
797      */
798     function setApprovalForAll(address to, bool approved) public {
799         address msgSender = _msgSender();
800 
801         require(to != msgSender, "ERC721: approve to caller");
802 
803         _operatorApprovals[msgSender][to] = approved;
804 
805         emit ApprovalForAll(msgSender, to, approved);
806     }
807 
808     /**
809      * @dev Tells whether an operator is approved by a given owner.
810      * @param owner owner address which you want to query the approval of
811      * @param operator operator address which you want to query the approval of
812      * @return bool whether the given operator is approved by the given owner
813      */
814     function isApprovedForAll(address owner, address operator) public view returns (bool) {
815         return _operatorApprovals[owner][operator];
816     }
817 
818     /**
819      * @dev Transfers the ownership of a given token ID to another address.
820      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
821      * Requires the msg.sender to be the owner, approved, or operator.
822      * @param from current owner of the token
823      * @param to address to receive the ownership of the given token ID
824      * @param tokenId uint256 ID of the token to be transferred
825      */
826     function transferFrom(address from, address to, uint256 tokenId) public {
827         // solhint-disable-next-line max-line-length
828         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
829 
830         _transferFrom(from, to, tokenId);
831     }
832 
833     /**
834      * @dev Safely transfers the ownership of a given token ID to another address
835      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
836      * which is called upon a safe transfer, and return the magic value
837      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
838      * the transfer is reverted.
839      * Requires the msg.sender to be the owner, approved, or operator
840      * @param from current owner of the token
841      * @param to address to receive the ownership of the given token ID
842      * @param tokenId uint256 ID of the token to be transferred
843      */
844     function safeTransferFrom(address from, address to, uint256 tokenId) public {
845         safeTransferFrom(from, to, tokenId, "");
846     }
847 
848     /**
849      * @dev Safely transfers the ownership of a given token ID to another address
850      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
851      * which is called upon a safe transfer, and return the magic value
852      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
853      * the transfer is reverted.
854      * Requires the _msgSender() to be the owner, approved, or operator
855      * @param from current owner of the token
856      * @param to address to receive the ownership of the given token ID
857      * @param tokenId uint256 ID of the token to be transferred
858      * @param _data bytes data to send along with a safe transfer check
859      */
860     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
862 
863         _safeTransferFrom(from, to, tokenId, _data);
864     }
865 
866     /**
867      * @dev Safely transfers the ownership of a given token ID to another address
868      * If the target address is a contract, it must implement `onERC721Received`,
869      * which is called upon a safe transfer, and return the magic value
870      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
871      * the transfer is reverted.
872      * Requires the msg.sender to be the owner, approved, or operator
873      * @param from current owner of the token
874      * @param to address to receive the ownership of the given token ID
875      * @param tokenId uint256 ID of the token to be transferred
876      * @param _data bytes data to send along with a safe transfer check
877      */
878     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
879         _transferFrom(from, to, tokenId);
880 
881         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
882     }
883 
884     /**
885      * @dev Returns whether the specified token exists.
886      * @param tokenId uint256 ID of the token to query the existence of
887      * @return bool whether the token exists
888      */
889     function _exists(uint256 tokenId) internal view returns (bool) {
890         return _tokenOwner[tokenId] != address(0);
891     }
892 
893     /**
894      * @dev Returns whether the given spender can transfer a given token ID.
895      * @param spender address of the spender to query
896      * @param tokenId uint256 ID of the token to be transferred
897      * @return bool whether the msg.sender is approved for the given token ID,
898      * is an operator of the owner, or is the owner of the token
899      */
900     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
901         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
902 
903         address owner = ownerOf(tokenId);
904 
905         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
906     }
907 
908     /**
909      * @dev Internal function to safely mint a new token.
910      * Reverts if the given token ID already exists.
911      * If the target address is a contract, it must implement `onERC721Received`,
912      * which is called upon a safe transfer, and return the magic value
913      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
914      * the transfer is reverted.
915      * @param to The address that will own the minted token
916      * @param tokenId uint256 ID of the token to be minted
917      */
918     function _safeMint(address to, uint256 tokenId) internal {
919         _safeMint(to, tokenId, "");
920     }
921 
922     /**
923      * @dev Internal function to safely mint a new token.
924      * Reverts if the given token ID already exists.
925      * If the target address is a contract, it must implement `onERC721Received`,
926      * which is called upon a safe transfer, and return the magic value
927      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
928      * the transfer is reverted.
929      * @param to The address that will own the minted token
930      * @param tokenId uint256 ID of the token to be minted
931      * @param _data bytes data to send along with a safe transfer check
932      */
933     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
934         _mint(to, tokenId);
935 
936         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
937     }
938 
939     /**
940      * @dev Internal function to mint a new token.
941      * Reverts if the given token ID already exists.
942      * @param to The address that will own the minted token
943      * @param tokenId uint256 ID of the token to be minted
944      */
945     function _mint(address to, uint256 tokenId) internal {
946         require(to != address(0), "ERC721: mint to the zero address");
947         require(!_exists(tokenId), "ERC721: token already minted");
948 
949         _tokenOwner[tokenId] = to;
950         _ownedTokensCount[to].increment();
951 
952         emit Transfer(address(0), to, tokenId);
953     }
954 
955     /**
956      * @dev Internal function to burn a specific token.
957      * Reverts if the token does not exist.
958      * Deprecated, use {_burn} instead.
959      * @param owner owner of the token to burn
960      * @param tokenId uint256 ID of the token being burned
961      */
962     function _burn(address owner, uint256 tokenId) internal {
963         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
964 
965         _clearApproval(tokenId);
966 
967         _ownedTokensCount[owner].decrement();
968         _tokenOwner[tokenId] = address(0);
969 
970         emit Transfer(owner, address(0), tokenId);
971     }
972 
973     /**
974      * @dev Internal function to burn a specific token.
975      * Reverts if the token does not exist.
976      * @param tokenId uint256 ID of the token being burned
977      */
978     function _burn(uint256 tokenId) internal {
979         _burn(ownerOf(tokenId), tokenId);
980     }
981 
982     /**
983      * @dev Internal function to transfer ownership of a given token ID to another address.
984      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
985      * @param from current owner of the token
986      * @param to address to receive the ownership of the given token ID
987      * @param tokenId uint256 ID of the token to be transferred
988      */
989     function _transferFrom(address from, address to, uint256 tokenId) internal {
990         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
991         require(to != address(0), "ERC721: transfer to the zero address");
992 
993         _clearApproval(tokenId);
994 
995         _ownedTokensCount[from].decrement();
996         _ownedTokensCount[to].increment();
997 
998         _tokenOwner[tokenId] = to;
999 
1000         emit Transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1005      * The call is not executed if the target address is not a contract.
1006      *
1007      * This is an internal detail of the `ERC721` contract and its use is deprecated.
1008      * @param from address representing the previous owner of the given token ID
1009      * @param to target address that will receive the tokens
1010      * @param tokenId uint256 ID of the token to be transferred
1011      * @param _data bytes optional data to send along with the call
1012      * @return bool whether the call correctly returned the expected magic value
1013      */
1014     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool) {
1015         if (!to.isContract()) {
1016             return true;
1017         }
1018 
1019         // solhint-disable-next-line avoid-low-level-calls
1020         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1021             IERC721Receiver(to).onERC721Received.selector,
1022             _msgSender(),
1023             from,
1024             tokenId,
1025             _data
1026         ));
1027 
1028         if (!success) {
1029             if (returndata.length > 0) {
1030                 // solhint-disable-next-line no-inline-assembly
1031                 assembly {
1032                     let returndata_size := mload(returndata)
1033                     revert(add(32, returndata), returndata_size)
1034                 }
1035 
1036             } else {
1037                 revert("ERC721: transfer to non ERC721Receiver implementer");
1038             }
1039 
1040         } else {
1041             bytes4 retval = abi.decode(returndata, (bytes4));
1042             return (retval == _ERC721_RECEIVED);
1043         }
1044     }
1045 
1046     /**
1047      * @dev Private function to clear current approval of a given token ID.
1048      * @param tokenId uint256 ID of the token to be transferred
1049      */
1050     function _clearApproval(uint256 tokenId) private {
1051         if (_tokenApprovals[tokenId] != address(0)) {
1052             _tokenApprovals[tokenId] = address(0);
1053         }
1054     }
1055 
1056 }
1057 
1058 // File: contracts\token\erc721\ERC721Enumerable.sol
1059 
1060 pragma solidity ^0.5.0;
1061 
1062 
1063 
1064 /**
1065  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
1066  * @dev See https://eips.ethereum.org/EIPS/eip-721
1067  */
1068 contract ERC721Enumerable is ERC721, IERC721Enumerable {
1069 
1070     // Mapping from owner to list of owned token IDs
1071     mapping(address => uint256[]) private _ownedTokens;
1072 
1073     // Mapping from token ID to index of the owner tokens list
1074     mapping(uint256 => uint256) private _ownedTokensIndex;
1075 
1076     // Array with all token ids, used for enumeration
1077     uint256[] private _allTokens;
1078 
1079     // Mapping from token id to position in the allTokens array
1080     mapping(uint256 => uint256) private _allTokensIndex;
1081 
1082     /*
1083      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1084      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1085      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1086      *
1087      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1088      */
1089     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1090 
1091     constructor () public {
1092         // Register the supported interface to conform to ERC721Enumerable via ERC165
1093         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1094     }
1095 
1096     /**
1097      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1098      * @param owner address owning the tokens list to be accessed
1099      * @param index uint256 representing the index to be accessed of the requested tokens list
1100      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1101      */
1102     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1103         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1104 
1105         return _ownedTokens[owner][index];
1106     }
1107 
1108     /**
1109      * @dev Gets the total amount of tokens stored by the contract.
1110      * @return uint256 representing the total amount of tokens
1111      */
1112     function totalSupply() public view returns (uint256) {
1113         return _allTokens.length;
1114     }
1115 
1116     /**
1117      * @dev Gets the token ID at a given index of all the tokens in this contract
1118      * Reverts if the index is greater or equal to the total number of tokens.
1119      * @param index uint256 representing the index to be accessed of the tokens list
1120      * @return uint256 token ID at the given index of the tokens list
1121      */
1122     function tokenByIndex(uint256 index) public view returns (uint256) {
1123         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1124 
1125         return _allTokens[index];
1126     }
1127 
1128     /**
1129      * @dev Internal function to transfer ownership of a given token ID to another address.
1130      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1131      * @param from current owner of the token
1132      * @param to address to receive the ownership of the given token ID
1133      * @param tokenId uint256 ID of the token to be transferred
1134      */
1135     function _transferFrom(address from, address to, uint256 tokenId) internal {
1136         super._transferFrom(from, to, tokenId);
1137 
1138         _removeTokenFromOwnerEnumeration(from, tokenId);
1139 
1140         _addTokenToOwnerEnumeration(to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Internal function to mint a new token.
1145      * Reverts if the given token ID already exists.
1146      * @param to address the beneficiary that will own the minted token
1147      * @param tokenId uint256 ID of the token to be minted
1148      */
1149     function _mint(address to, uint256 tokenId) internal {
1150         super._mint(to, tokenId);
1151 
1152         _addTokenToOwnerEnumeration(to, tokenId);
1153 
1154         _addTokenToAllTokensEnumeration(tokenId);
1155     }
1156 
1157     /**
1158      * @dev Internal function to burn a specific token.
1159      * Reverts if the token does not exist.
1160      * Deprecated, use {ERC721-_burn} instead.
1161      * @param owner owner of the token to burn
1162      * @param tokenId uint256 ID of the token being burned
1163      */
1164     function _burn(address owner, uint256 tokenId) internal {
1165         super._burn(owner, tokenId);
1166 
1167         _removeTokenFromOwnerEnumeration(owner, tokenId);
1168 
1169         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1170         _ownedTokensIndex[tokenId] = 0;
1171 
1172         _removeTokenFromAllTokensEnumeration(tokenId);
1173     }
1174 
1175     /**
1176      * @dev Gets the list of token IDs of the requested owner.
1177      * @param owner address owning the tokens
1178      * @return uint256[] List of token IDs owned by the requested address
1179      */
1180     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1181         return _ownedTokens[owner];
1182     }
1183 
1184     /**
1185      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1186      * @param to address representing the new owner of the given token ID
1187      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1188      */
1189     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1190         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1191         _ownedTokens[to].push(tokenId);
1192     }
1193 
1194     /**
1195      * @dev Private function to add a token to this extension's token tracking data structures.
1196      * @param tokenId uint256 ID of the token to be added to the tokens list
1197      */
1198     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1199         _allTokensIndex[tokenId] = _allTokens.length;
1200         _allTokens.push(tokenId);
1201     }
1202 
1203     /**
1204      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1205      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1206      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1207      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1208      * @param from address representing the previous owner of the given token ID
1209      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1210      */
1211     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1212         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1213         // then delete the last slot (swap and pop).
1214 
1215         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1216         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1217 
1218         // When the token to delete is the last token, the swap operation is unnecessary
1219         if (tokenIndex != lastTokenIndex) {
1220             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1221 
1222             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1223             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1224         }
1225 
1226         // This also deletes the contents at the last position of the array
1227         _ownedTokens[from].length--;
1228 
1229         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1230         // lastTokenId, or just over the end of the array if the token was the last one).
1231     }
1232 
1233     /**
1234      * @dev Private function to remove a token from this extension's token tracking data structures.
1235      * This has O(1) time complexity, but alters the order of the _allTokens array.
1236      * @param tokenId uint256 ID of the token to be removed from the tokens list
1237      */
1238     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1239         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1240         // then delete the last slot (swap and pop).
1241 
1242         uint256 lastTokenIndex = _allTokens.length.sub(1);
1243         uint256 tokenIndex = _allTokensIndex[tokenId];
1244 
1245         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1246         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1247         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1248         uint256 lastTokenId = _allTokens[lastTokenIndex];
1249 
1250         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1251         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1252 
1253         // This also deletes the contents at the last position of the array
1254         _allTokens.length--;
1255         _allTokensIndex[tokenId] = 0;
1256     }
1257 
1258 }
1259 
1260 // File: contracts\libs\Strings.sol
1261 
1262 pragma solidity ^0.5.0;
1263 
1264 /**
1265  * @title Strings
1266  * @dev String operations.
1267  */
1268 library Strings {
1269 
1270     /**
1271      * @dev Converts a `uint256` to a `string`.
1272      * via OraclizeAPI - MIT licence
1273      * https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1274      */
1275     function fromUint256(uint256 value) internal pure returns (string memory) {
1276         if (value == 0) {
1277             return "0";
1278         }
1279 
1280         uint256 temp = value;
1281         uint256 digits;
1282 
1283         while (temp != 0) {
1284             digits++;
1285             temp /= 10;
1286         }
1287 
1288         bytes memory buffer = new bytes(digits);
1289         uint256 index = digits - 1;
1290 
1291         temp = value;
1292 
1293         while (temp != 0) {
1294             buffer[index--] = byte(uint8(48 + temp % 10));
1295             temp /= 10;
1296         }
1297 
1298         return string(buffer);
1299     }
1300 
1301 }
1302 
1303 // File: contracts\token\erc721\IERC721Metadata.sol
1304 
1305 pragma solidity ^0.5.0;
1306 
1307 /**
1308  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1309  * @dev See https://eips.ethereum.org/EIPS/eip-721
1310  */
1311 interface IERC721Metadata {
1312 
1313     /**
1314      * @dev Returns the token collection name.
1315      */
1316     function name() external view returns (string memory);
1317 
1318     /**
1319      * @dev Returns the token collection symbol.
1320      */
1321     function symbol() external view returns (string memory);
1322 
1323     /**
1324      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1325      */
1326     function tokenURI(uint256 tokenId) external view returns (string memory);
1327 
1328 }
1329 
1330 // File: contracts\token\erc721\ERC721Metadata.sol
1331 
1332 pragma solidity ^0.5.0;
1333 
1334 
1335 
1336 
1337 contract ERC721Metadata is ERC721, IERC721Metadata {
1338 
1339     using Strings for uint256;
1340 
1341     // Token name
1342     string private _name;
1343 
1344     // Token symbol
1345     string private _symbol;
1346 
1347     // Base URI
1348     string private _baseURI;
1349 
1350     // Optional mapping for token URIs
1351     mapping(uint256 => string) private _tokenURIs;
1352 
1353     /*
1354      *     bytes4(keccak256('name()')) == 0x06fdde03
1355      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1356      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1357      *
1358      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1359      */
1360     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1361 
1362     /**
1363      * @dev Constructor function
1364      */
1365     constructor (string memory name, string memory symbol) public {
1366         _name = name;
1367         _symbol = symbol;
1368 
1369         // Register the supported interfaces to conform to ERC721 via ERC165
1370         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1371     }
1372 
1373     /**
1374      * @dev Gets the token name.
1375      * @return string representing the token name
1376      */
1377     function name() public view returns (string memory) {
1378         return _name;
1379     }
1380 
1381     /**
1382      * @dev Gets the token symbol.
1383      * @return string representing the token symbol
1384      */
1385     function symbol() public view returns (string memory) {
1386         return _symbol;
1387     }
1388 
1389     /**
1390      * @dev Returns the URI for a given token ID. May return an empty string.
1391      *
1392      * If a base URI is set (via {_setBaseURI}), it is added as a prefix to the
1393      * token's own URI (via {_setTokenURI}).
1394      *
1395      * If there is a base URI but no token URI, the token's ID will be used as
1396      * its URI when appending it to the base URI. This pattern for autogenerated
1397      * token URIs can lead to large gas savings.
1398      *
1399      * .Examples
1400      * |===
1401      * |`_setBaseURI()` |`_setTokenURI()` |`tokenURI()`
1402      * | ""
1403      * | ""
1404      * | ""
1405      * | ""
1406      * | "token.uri/123"
1407      * | "token.uri/123"
1408      * | "token.uri/"
1409      * | "123"
1410      * | "token.uri/123"
1411      * | "token.uri/"
1412      * | ""
1413      * | "token.uri/<tokenId>"
1414      * |===
1415      *
1416      * Requirements:
1417      *
1418      * - `tokenId` must exist.
1419      */
1420     function tokenURI(uint256 tokenId) public view returns (string memory) {
1421         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1422 
1423         string memory _tokenURI = _tokenURIs[tokenId];
1424 
1425         // If there is no base URI, return the token URI.
1426         if (bytes(_baseURI).length == 0) {
1427             return _tokenURI;
1428         }
1429 
1430         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1431         if (bytes(_tokenURI).length > 0) {
1432             return string(abi.encodePacked(_baseURI, _tokenURI));
1433         }
1434 
1435         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1436         return string(abi.encodePacked(_baseURI, tokenId.fromUint256()));
1437     }
1438 
1439     /**
1440      * @dev Internal function to set the token URI for a given token.
1441      *
1442      * Reverts if the token ID does not exist.
1443      *
1444      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1445      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1446      * it and save gas.
1447      */
1448     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1449         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1450 
1451         _tokenURIs[tokenId] = _tokenURI;
1452     }
1453 
1454     /**
1455      * @dev Internal function to set the base URI for all token IDs. It is
1456      * automatically added as a prefix to the value returned in {tokenURI}.
1457      *
1458      * _Available since v2.5.0._
1459      */
1460     function _setBaseURI(string memory baseURI) internal {
1461         _baseURI = baseURI;
1462     }
1463 
1464     /**
1465      * @dev Returns the base URI set via {_setBaseURI}. This will be
1466      * automatically added as a preffix in {tokenURI} to each token's URI, when
1467      * they are non-empty.
1468      *
1469      * _Available since v2.5.0._
1470      */
1471     function baseURI() public view returns (string memory) {
1472         return _baseURI;
1473     }
1474 
1475     /**
1476      * @dev Internal function to burn a specific token.
1477      * Reverts if the token does not exist.
1478      * Deprecated, use _burn(uint256) instead.
1479      * @param owner owner of the token to burn
1480      * @param tokenId uint256 ID of the token being burned by the msg.sender
1481      */
1482     function _burn(address owner, uint256 tokenId) internal {
1483         super._burn(owner, tokenId);
1484 
1485         // Clears metadata (if any)
1486         if (bytes(_tokenURIs[tokenId]).length != 0) {
1487             delete _tokenURIs[tokenId];
1488         }
1489     }
1490 
1491 }
1492 
1493 // File: contracts\token\erc721\ERC721Full.sol
1494 
1495 pragma solidity ^0.5.0;
1496 
1497 
1498 
1499 /**
1500  * @title Full ERC721 Token
1501  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1502  * Moreover, it includes approve all functionality using operator terminology.
1503  *
1504  * See https://eips.ethereum.org/EIPS/eip-721
1505  */
1506 contract ERC721Full is ERC721Enumerable, ERC721Metadata {
1507 
1508     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1509         // solhint-disable-previous-line no-empty-blocks
1510     }
1511 
1512 }
1513 
1514 // File: contracts\cryptopunk\ICryptoPunk.sol
1515 
1516 pragma solidity ^0.5.0;
1517 
1518 interface ICryptoPunk {
1519 
1520     function punkIndexToAddress(uint256 punkIndex) external returns (address);
1521     function punksOfferedForSale(uint256 punkIndex) external returns (bool, uint256, address, uint256, address);
1522     function buyPunk(uint punkIndex) external payable;
1523     function transferPunk(address to, uint punkIndex) external;
1524 
1525 }
1526 
1527 // File: contracts\cryptopunk\wrapped-punk\UserProxy.sol
1528 
1529 pragma solidity ^0.5.0;
1530 
1531 contract UserProxy {
1532 
1533     address private _owner;
1534 
1535     /**
1536      * @dev Initializes the contract settings
1537      */
1538     constructor()
1539         public
1540     {
1541         _owner = msg.sender;
1542     }
1543 
1544     /**
1545      * @dev Transfers punk to the smart contract owner
1546      */
1547     function transfer(address punkContract, uint256 punkIndex)
1548         external
1549         returns (bool)
1550     {
1551         if (_owner != msg.sender) {
1552             return false;
1553         }
1554 
1555         (bool result,) = punkContract.call(abi.encodeWithSignature("transferPunk(address,uint256)", _owner, punkIndex));
1556 
1557         return result;
1558     }
1559 
1560 }
1561 
1562 // File: contracts\cryptopunk\wrapped-punk\WrappedPunk.sol
1563 
1564 pragma solidity ^0.5.0;
1565 
1566 
1567 
1568 
1569 
1570 
1571 contract WrappedPunk is Ownable, ERC721Full, Pausable {
1572 
1573     event ProxyRegistered(address user, address proxy);
1574 
1575     // Instance of cryptopunk smart contract
1576     ICryptoPunk private _punkContract;
1577 
1578     // Mapping from user address to proxy address
1579     mapping(address => address) private _proxies;
1580 
1581     /**
1582      * @dev Initializes the contract settings
1583      */
1584     constructor(address punkContract)
1585         public
1586         ERC721Full("Wrapped Cryptopunks", "WPUNKS")
1587     {
1588         _punkContract = ICryptoPunk(punkContract);
1589     }
1590 
1591     /**
1592      * @dev Gets address of cryptopunk smart contract
1593      */
1594     function punkContract()
1595         public
1596         view
1597         returns (address)
1598     {
1599         return address(_punkContract);
1600     }
1601 
1602     /**
1603      * @dev Sets the base URI for all token
1604      */
1605     function setBaseURI(string memory baseUri)
1606         public
1607         onlyOwner
1608     {
1609         _setBaseURI(baseUri);
1610     }
1611 
1612     /**
1613      * @dev Triggers smart contract to stopped state
1614      */
1615     function pause()
1616         public
1617         onlyOwner
1618     {
1619         _pause();
1620     }
1621 
1622     /**
1623      * @dev Returns smart contract to normal state
1624      */
1625     function unpause()
1626         public
1627         onlyOwner
1628     {
1629         _unpause();
1630     }
1631 
1632     /**
1633      * @dev Registers proxy
1634      */
1635     function registerProxy()
1636         public
1637     {
1638         address sender = _msgSender();
1639 
1640         require(_proxies[sender] == address(0), "PunkWrapper: caller has registered the proxy");
1641 
1642         address proxy = address(new UserProxy());
1643 
1644         _proxies[sender] = proxy;
1645 
1646         emit ProxyRegistered(sender, proxy);
1647     }
1648 
1649     /**
1650      * @dev Gets proxy address
1651      */
1652     function proxyInfo(address user)
1653         public
1654         view
1655         returns (address)
1656     {
1657         return _proxies[user];
1658     }
1659 
1660     /**
1661      * @dev Mints a wrapped punk
1662      */
1663     function mint(uint256 punkIndex)
1664         public
1665         whenNotPaused
1666     {
1667         address sender = _msgSender();
1668 
1669         UserProxy proxy = UserProxy(_proxies[sender]);
1670 
1671         require(proxy.transfer(address(_punkContract), punkIndex), "PunkWrapper: transfer fail");
1672 
1673         _mint(sender, punkIndex);
1674     }
1675 
1676     /**
1677      * @dev Burns a specific wrapped punk
1678      */
1679     function burn(uint256 punkIndex)
1680         public
1681         whenNotPaused
1682     {
1683         address sender = _msgSender();
1684 
1685         require(_isApprovedOrOwner(sender, punkIndex), "PunkWrapper: caller is not owner nor approved");
1686 
1687         _burn(punkIndex);
1688 
1689         // Transfers ownership of punk on original cryptopunk smart contract to caller
1690         _punkContract.transferPunk(sender, punkIndex);
1691     }
1692 
1693     /**
1694      * @dev Internal function to transfer ownership of a given punk index to another address
1695      */
1696     function _transferFrom(address from, address to, uint256 punkIndex)
1697         internal
1698         whenNotPaused
1699     {
1700         super._transferFrom(from, to, punkIndex);
1701     }
1702 
1703 }