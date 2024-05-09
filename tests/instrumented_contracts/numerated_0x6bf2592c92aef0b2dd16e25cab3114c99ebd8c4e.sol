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
31 // File: openzeppelin-solidity/contracts/access/Roles.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @title Roles
37  * @dev Library for managing addresses assigned to a Role.
38  */
39 library Roles {
40     struct Role {
41         mapping (address => bool) bearer;
42     }
43 
44     /**
45      * @dev Give an account access to this role.
46      */
47     function add(Role storage role, address account) internal {
48         require(!has(role, account), "Roles: account already has role");
49         role.bearer[account] = true;
50     }
51 
52     /**
53      * @dev Remove an account's access to this role.
54      */
55     function remove(Role storage role, address account) internal {
56         require(has(role, account), "Roles: account does not have role");
57         role.bearer[account] = false;
58     }
59 
60     /**
61      * @dev Check if an account has this role.
62      * @return bool
63      */
64     function has(Role storage role, address account) internal view returns (bool) {
65         require(account != address(0), "Roles: account is the zero address");
66         return role.bearer[account];
67     }
68 }
69 
70 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
71 
72 pragma solidity ^0.5.0;
73 
74 
75 
76 contract PauserRole is Context {
77     using Roles for Roles.Role;
78 
79     event PauserAdded(address indexed account);
80     event PauserRemoved(address indexed account);
81 
82     Roles.Role private _pausers;
83 
84     constructor () internal {
85         _addPauser(_msgSender());
86     }
87 
88     modifier onlyPauser() {
89         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
90         _;
91     }
92 
93     function isPauser(address account) public view returns (bool) {
94         return _pausers.has(account);
95     }
96 
97     function addPauser(address account) public onlyPauser {
98         _addPauser(account);
99     }
100 
101     function renouncePauser() public {
102         _removePauser(_msgSender());
103     }
104 
105     function _addPauser(address account) internal {
106         _pausers.add(account);
107         emit PauserAdded(account);
108     }
109 
110     function _removePauser(address account) internal {
111         _pausers.remove(account);
112         emit PauserRemoved(account);
113     }
114 }
115 
116 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
117 
118 pragma solidity ^0.5.0;
119 
120 
121 
122 /**
123  * @dev Contract module which allows children to implement an emergency stop
124  * mechanism that can be triggered by an authorized account.
125  *
126  * This module is used through inheritance. It will make available the
127  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
128  * the functions of your contract. Note that they will not be pausable by
129  * simply including this module, only once the modifiers are put in place.
130  */
131 contract Pausable is Context, PauserRole {
132     /**
133      * @dev Emitted when the pause is triggered by a pauser (`account`).
134      */
135     event Paused(address account);
136 
137     /**
138      * @dev Emitted when the pause is lifted by a pauser (`account`).
139      */
140     event Unpaused(address account);
141 
142     bool private _paused;
143 
144     /**
145      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
146      * to the deployer.
147      */
148     constructor () internal {
149         _paused = false;
150     }
151 
152     /**
153      * @dev Returns true if the contract is paused, and false otherwise.
154      */
155     function paused() public view returns (bool) {
156         return _paused;
157     }
158 
159     /**
160      * @dev Modifier to make a function callable only when the contract is not paused.
161      */
162     modifier whenNotPaused() {
163         require(!_paused, "Pausable: paused");
164         _;
165     }
166 
167     /**
168      * @dev Modifier to make a function callable only when the contract is paused.
169      */
170     modifier whenPaused() {
171         require(_paused, "Pausable: not paused");
172         _;
173     }
174 
175     /**
176      * @dev Called by a pauser to pause, triggers stopped state.
177      */
178     function pause() public onlyPauser whenNotPaused {
179         _paused = true;
180         emit Paused(_msgSender());
181     }
182 
183     /**
184      * @dev Called by a pauser to unpause, returns to normal state.
185      */
186     function unpause() public onlyPauser whenPaused {
187         _paused = false;
188         emit Unpaused(_msgSender());
189     }
190 }
191 
192 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * This module is used through inheritance. It will make available the modifier
202  * `onlyOwner`, which can be applied to your functions to restrict their use to
203  * the owner.
204  */
205 contract Ownable is Context {
206     address private _owner;
207 
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210     /**
211      * @dev Initializes the contract setting the deployer as the initial owner.
212      */
213     constructor () internal {
214         _owner = _msgSender();
215         emit OwnershipTransferred(address(0), _owner);
216     }
217 
218     /**
219      * @dev Returns the address of the current owner.
220      */
221     function owner() public view returns (address) {
222         return _owner;
223     }
224 
225     /**
226      * @dev Throws if called by any account other than the owner.
227      */
228     modifier onlyOwner() {
229         require(isOwner(), "Ownable: caller is not the owner");
230         _;
231     }
232 
233     /**
234      * @dev Returns true if the caller is the current owner.
235      */
236     function isOwner() public view returns (bool) {
237         return _msgSender() == _owner;
238     }
239 
240     /**
241      * @dev Leaves the contract without owner. It will not be possible to call
242      * `onlyOwner` functions anymore. Can only be called by the current owner.
243      *
244      * NOTE: Renouncing ownership will leave the contract without an owner,
245      * thereby removing any functionality that is only available to the owner.
246      */
247     function renounceOwnership() public onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Can only be called by the current owner.
255      */
256     function transferOwnership(address newOwner) public onlyOwner {
257         _transferOwnership(newOwner);
258     }
259 
260     /**
261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
262      */
263     function _transferOwnership(address newOwner) internal {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         emit OwnershipTransferred(_owner, newOwner);
266         _owner = newOwner;
267     }
268 }
269 
270 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
271 
272 pragma solidity ^0.5.0;
273 
274 /**
275  * @dev Interface of the ERC165 standard, as defined in the
276  * https://eips.ethereum.org/EIPS/eip-165[EIP].
277  *
278  * Implementers can declare support of contract interfaces, which can then be
279  * queried by others ({ERC165Checker}).
280  *
281  * For an implementation, see {ERC165}.
282  */
283 interface IERC165 {
284     /**
285      * @dev Returns true if this contract implements the interface defined by
286      * `interfaceId`. See the corresponding
287      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
288      * to learn more about how these ids are created.
289      *
290      * This function call must use less than 30 000 gas.
291      */
292     function supportsInterface(bytes4 interfaceId) external view returns (bool);
293 }
294 
295 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
296 
297 pragma solidity ^0.5.0;
298 
299 
300 /**
301  * @dev Required interface of an ERC721 compliant contract.
302  */
303 contract IERC721 is IERC165 {
304     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
305     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
306     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
307 
308     /**
309      * @dev Returns the number of NFTs in `owner`'s account.
310      */
311     function balanceOf(address owner) public view returns (uint256 balance);
312 
313     /**
314      * @dev Returns the owner of the NFT specified by `tokenId`.
315      */
316     function ownerOf(uint256 tokenId) public view returns (address owner);
317 
318     /**
319      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
320      * another (`to`).
321      *
322      *
323      *
324      * Requirements:
325      * - `from`, `to` cannot be zero.
326      * - `tokenId` must be owned by `from`.
327      * - If the caller is not `from`, it must be have been allowed to move this
328      * NFT by either {approve} or {setApprovalForAll}.
329      */
330     function safeTransferFrom(address from, address to, uint256 tokenId) public;
331     /**
332      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
333      * another (`to`).
334      *
335      * Requirements:
336      * - If the caller is not `from`, it must be approved to move this NFT by
337      * either {approve} or {setApprovalForAll}.
338      */
339     function transferFrom(address from, address to, uint256 tokenId) public;
340     function approve(address to, uint256 tokenId) public;
341     function getApproved(uint256 tokenId) public view returns (address operator);
342 
343     function setApprovalForAll(address operator, bool _approved) public;
344     function isApprovedForAll(address owner, address operator) public view returns (bool);
345 
346 
347     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
348 }
349 
350 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
351 
352 pragma solidity ^0.5.0;
353 
354 /**
355  * @title ERC721 token receiver interface
356  * @dev Interface for any contract that wants to support safeTransfers
357  * from ERC721 asset contracts.
358  */
359 contract IERC721Receiver {
360     /**
361      * @notice Handle the receipt of an NFT
362      * @dev The ERC721 smart contract calls this function on the recipient
363      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
364      * otherwise the caller will revert the transaction. The selector to be
365      * returned can be obtained as `this.onERC721Received.selector`. This
366      * function MAY throw to revert and reject the transfer.
367      * Note: the ERC721 contract address is always the message sender.
368      * @param operator The address which called `safeTransferFrom` function
369      * @param from The address which previously owned the token
370      * @param tokenId The NFT identifier which is being transferred
371      * @param data Additional data with no specified format
372      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
373      */
374     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
375     public returns (bytes4);
376 }
377 
378 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
379 
380 pragma solidity ^0.5.0;
381 
382 /**
383  * @dev Wrappers over Solidity's arithmetic operations with added overflow
384  * checks.
385  *
386  * Arithmetic operations in Solidity wrap on overflow. This can easily result
387  * in bugs, because programmers usually assume that an overflow raises an
388  * error, which is the standard behavior in high level programming languages.
389  * `SafeMath` restores this intuition by reverting the transaction when an
390  * operation overflows.
391  *
392  * Using this library instead of the unchecked operations eliminates an entire
393  * class of bugs, so it's recommended to use it always.
394  */
395 library SafeMath {
396     /**
397      * @dev Returns the addition of two unsigned integers, reverting on
398      * overflow.
399      *
400      * Counterpart to Solidity's `+` operator.
401      *
402      * Requirements:
403      * - Addition cannot overflow.
404      */
405     function add(uint256 a, uint256 b) internal pure returns (uint256) {
406         uint256 c = a + b;
407         require(c >= a, "SafeMath: addition overflow");
408 
409         return c;
410     }
411 
412     /**
413      * @dev Returns the subtraction of two unsigned integers, reverting on
414      * overflow (when the result is negative).
415      *
416      * Counterpart to Solidity's `-` operator.
417      *
418      * Requirements:
419      * - Subtraction cannot overflow.
420      */
421     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422         return sub(a, b, "SafeMath: subtraction overflow");
423     }
424 
425     /**
426      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
427      * overflow (when the result is negative).
428      *
429      * Counterpart to Solidity's `-` operator.
430      *
431      * Requirements:
432      * - Subtraction cannot overflow.
433      *
434      * _Available since v2.4.0._
435      */
436     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
437         require(b <= a, errorMessage);
438         uint256 c = a - b;
439 
440         return c;
441     }
442 
443     /**
444      * @dev Returns the multiplication of two unsigned integers, reverting on
445      * overflow.
446      *
447      * Counterpart to Solidity's `*` operator.
448      *
449      * Requirements:
450      * - Multiplication cannot overflow.
451      */
452     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
453         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
454         // benefit is lost if 'b' is also tested.
455         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
456         if (a == 0) {
457             return 0;
458         }
459 
460         uint256 c = a * b;
461         require(c / a == b, "SafeMath: multiplication overflow");
462 
463         return c;
464     }
465 
466     /**
467      * @dev Returns the integer division of two unsigned integers. Reverts on
468      * division by zero. The result is rounded towards zero.
469      *
470      * Counterpart to Solidity's `/` operator. Note: this function uses a
471      * `revert` opcode (which leaves remaining gas untouched) while Solidity
472      * uses an invalid opcode to revert (consuming all remaining gas).
473      *
474      * Requirements:
475      * - The divisor cannot be zero.
476      */
477     function div(uint256 a, uint256 b) internal pure returns (uint256) {
478         return div(a, b, "SafeMath: division by zero");
479     }
480 
481     /**
482      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
483      * division by zero. The result is rounded towards zero.
484      *
485      * Counterpart to Solidity's `/` operator. Note: this function uses a
486      * `revert` opcode (which leaves remaining gas untouched) while Solidity
487      * uses an invalid opcode to revert (consuming all remaining gas).
488      *
489      * Requirements:
490      * - The divisor cannot be zero.
491      *
492      * _Available since v2.4.0._
493      */
494     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
495         // Solidity only automatically asserts when dividing by 0
496         require(b > 0, errorMessage);
497         uint256 c = a / b;
498         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
499 
500         return c;
501     }
502 
503     /**
504      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
505      * Reverts when dividing by zero.
506      *
507      * Counterpart to Solidity's `%` operator. This function uses a `revert`
508      * opcode (which leaves remaining gas untouched) while Solidity uses an
509      * invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      * - The divisor cannot be zero.
513      */
514     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
515         return mod(a, b, "SafeMath: modulo by zero");
516     }
517 
518     /**
519      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
520      * Reverts with custom message when dividing by zero.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      * - The divisor cannot be zero.
528      *
529      * _Available since v2.4.0._
530      */
531     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
532         require(b != 0, errorMessage);
533         return a % b;
534     }
535 }
536 
537 // File: openzeppelin-solidity/contracts/utils/Address.sol
538 
539 pragma solidity ^0.5.5;
540 
541 /**
542  * @dev Collection of functions related to the address type
543  */
544 library Address {
545     /**
546      * @dev Returns true if `account` is a contract.
547      *
548      * This test is non-exhaustive, and there may be false-negatives: during the
549      * execution of a contract's constructor, its address will be reported as
550      * not containing a contract.
551      *
552      * IMPORTANT: It is unsafe to assume that an address for which this
553      * function returns false is an externally-owned account (EOA) and not a
554      * contract.
555      */
556     function isContract(address account) internal view returns (bool) {
557         // This method relies in extcodesize, which returns 0 for contracts in
558         // construction, since the code is only stored at the end of the
559         // constructor execution.
560 
561         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
562         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
563         // for accounts without code, i.e. `keccak256('')`
564         bytes32 codehash;
565         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
566         // solhint-disable-next-line no-inline-assembly
567         assembly { codehash := extcodehash(account) }
568         return (codehash != 0x0 && codehash != accountHash);
569     }
570 
571     /**
572      * @dev Converts an `address` into `address payable`. Note that this is
573      * simply a type cast: the actual underlying value is not changed.
574      *
575      * _Available since v2.4.0._
576      */
577     function toPayable(address account) internal pure returns (address payable) {
578         return address(uint160(account));
579     }
580 
581     /**
582      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
583      * `recipient`, forwarding all available gas and reverting on errors.
584      *
585      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
586      * of certain opcodes, possibly making contracts go over the 2300 gas limit
587      * imposed by `transfer`, making them unable to receive funds via
588      * `transfer`. {sendValue} removes this limitation.
589      *
590      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
591      *
592      * IMPORTANT: because control is transferred to `recipient`, care must be
593      * taken to not create reentrancy vulnerabilities. Consider using
594      * {ReentrancyGuard} or the
595      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
596      *
597      * _Available since v2.4.0._
598      */
599     function sendValue(address payable recipient, uint256 amount) internal {
600         require(address(this).balance >= amount, "Address: insufficient balance");
601 
602         // solhint-disable-next-line avoid-call-value
603         (bool success, ) = recipient.call.value(amount)("");
604         require(success, "Address: unable to send value, recipient may have reverted");
605     }
606 }
607 
608 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
609 
610 pragma solidity ^0.5.0;
611 
612 
613 /**
614  * @title Counters
615  * @author Matt Condon (@shrugs)
616  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
617  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
618  *
619  * Include with `using Counters for Counters.Counter;`
620  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
621  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
622  * directly accessed.
623  */
624 library Counters {
625     using SafeMath for uint256;
626 
627     struct Counter {
628         // This variable should never be directly accessed by users of the library: interactions must be restricted to
629         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
630         // this feature: see https://github.com/ethereum/solidity/issues/4637
631         uint256 _value; // default: 0
632     }
633 
634     function current(Counter storage counter) internal view returns (uint256) {
635         return counter._value;
636     }
637 
638     function increment(Counter storage counter) internal {
639         counter._value += 1;
640     }
641 
642     function decrement(Counter storage counter) internal {
643         counter._value = counter._value.sub(1);
644     }
645 }
646 
647 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
648 
649 pragma solidity ^0.5.0;
650 
651 
652 /**
653  * @dev Implementation of the {IERC165} interface.
654  *
655  * Contracts may inherit from this and call {_registerInterface} to declare
656  * their support of an interface.
657  */
658 contract ERC165 is IERC165 {
659     /*
660      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
661      */
662     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
663 
664     /**
665      * @dev Mapping of interface ids to whether or not it's supported.
666      */
667     mapping(bytes4 => bool) private _supportedInterfaces;
668 
669     constructor () internal {
670         // Derived contracts need only register support for their own interfaces,
671         // we register support for ERC165 itself here
672         _registerInterface(_INTERFACE_ID_ERC165);
673     }
674 
675     /**
676      * @dev See {IERC165-supportsInterface}.
677      *
678      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
679      */
680     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
681         return _supportedInterfaces[interfaceId];
682     }
683 
684     /**
685      * @dev Registers the contract as an implementer of the interface defined by
686      * `interfaceId`. Support of the actual ERC165 interface is automatic and
687      * registering its interface id is not required.
688      *
689      * See {IERC165-supportsInterface}.
690      *
691      * Requirements:
692      *
693      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
694      */
695     function _registerInterface(bytes4 interfaceId) internal {
696         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
697         _supportedInterfaces[interfaceId] = true;
698     }
699 }
700 
701 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
702 
703 pragma solidity ^0.5.0;
704 
705 
706 
707 
708 
709 
710 
711 
712 /**
713  * @title ERC721 Non-Fungible Token Standard basic implementation
714  * @dev see https://eips.ethereum.org/EIPS/eip-721
715  */
716 contract ERC721 is Context, ERC165, IERC721 {
717     using SafeMath for uint256;
718     using Address for address;
719     using Counters for Counters.Counter;
720 
721     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
722     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
723     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
724 
725     // Mapping from token ID to owner
726     mapping (uint256 => address) private _tokenOwner;
727 
728     // Mapping from token ID to approved address
729     mapping (uint256 => address) private _tokenApprovals;
730 
731     // Mapping from owner to number of owned token
732     mapping (address => Counters.Counter) private _ownedTokensCount;
733 
734     // Mapping from owner to operator approvals
735     mapping (address => mapping (address => bool)) private _operatorApprovals;
736 
737     /*
738      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
739      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
740      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
741      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
742      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
743      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
744      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
745      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
746      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
747      *
748      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
749      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
750      */
751     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
752 
753     constructor () public {
754         // register the supported interfaces to conform to ERC721 via ERC165
755         _registerInterface(_INTERFACE_ID_ERC721);
756     }
757 
758     /**
759      * @dev Gets the balance of the specified address.
760      * @param owner address to query the balance of
761      * @return uint256 representing the amount owned by the passed address
762      */
763     function balanceOf(address owner) public view returns (uint256) {
764         require(owner != address(0), "ERC721: balance query for the zero address");
765 
766         return _ownedTokensCount[owner].current();
767     }
768 
769     /**
770      * @dev Gets the owner of the specified token ID.
771      * @param tokenId uint256 ID of the token to query the owner of
772      * @return address currently marked as the owner of the given token ID
773      */
774     function ownerOf(uint256 tokenId) public view returns (address) {
775         address owner = _tokenOwner[tokenId];
776         require(owner != address(0), "ERC721: owner query for nonexistent token");
777 
778         return owner;
779     }
780 
781     /**
782      * @dev Approves another address to transfer the given token ID
783      * The zero address indicates there is no approved address.
784      * There can only be one approved address per token at a given time.
785      * Can only be called by the token owner or an approved operator.
786      * @param to address to be approved for the given token ID
787      * @param tokenId uint256 ID of the token to be approved
788      */
789     function approve(address to, uint256 tokenId) public {
790         address owner = ownerOf(tokenId);
791         require(to != owner, "ERC721: approval to current owner");
792 
793         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
794             "ERC721: approve caller is not owner nor approved for all"
795         );
796 
797         _tokenApprovals[tokenId] = to;
798         emit Approval(owner, to, tokenId);
799     }
800 
801     /**
802      * @dev Gets the approved address for a token ID, or zero if no address set
803      * Reverts if the token ID does not exist.
804      * @param tokenId uint256 ID of the token to query the approval of
805      * @return address currently approved for the given token ID
806      */
807     function getApproved(uint256 tokenId) public view returns (address) {
808         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
809 
810         return _tokenApprovals[tokenId];
811     }
812 
813     /**
814      * @dev Sets or unsets the approval of a given operator
815      * An operator is allowed to transfer all tokens of the sender on their behalf.
816      * @param to operator address to set the approval
817      * @param approved representing the status of the approval to be set
818      */
819     function setApprovalForAll(address to, bool approved) public {
820         require(to != _msgSender(), "ERC721: approve to caller");
821 
822         _operatorApprovals[_msgSender()][to] = approved;
823         emit ApprovalForAll(_msgSender(), to, approved);
824     }
825 
826     /**
827      * @dev Tells whether an operator is approved by a given owner.
828      * @param owner owner address which you want to query the approval of
829      * @param operator operator address which you want to query the approval of
830      * @return bool whether the given operator is approved by the given owner
831      */
832     function isApprovedForAll(address owner, address operator) public view returns (bool) {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev Transfers the ownership of a given token ID to another address.
838      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
839      * Requires the msg.sender to be the owner, approved, or operator.
840      * @param from current owner of the token
841      * @param to address to receive the ownership of the given token ID
842      * @param tokenId uint256 ID of the token to be transferred
843      */
844     function transferFrom(address from, address to, uint256 tokenId) public {
845         //solhint-disable-next-line max-line-length
846         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
847 
848         _transferFrom(from, to, tokenId);
849     }
850 
851     /**
852      * @dev Safely transfers the ownership of a given token ID to another address
853      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
854      * which is called upon a safe transfer, and return the magic value
855      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
856      * the transfer is reverted.
857      * Requires the msg.sender to be the owner, approved, or operator
858      * @param from current owner of the token
859      * @param to address to receive the ownership of the given token ID
860      * @param tokenId uint256 ID of the token to be transferred
861      */
862     function safeTransferFrom(address from, address to, uint256 tokenId) public {
863         safeTransferFrom(from, to, tokenId, "");
864     }
865 
866     /**
867      * @dev Safely transfers the ownership of a given token ID to another address
868      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
869      * which is called upon a safe transfer, and return the magic value
870      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
871      * the transfer is reverted.
872      * Requires the _msgSender() to be the owner, approved, or operator
873      * @param from current owner of the token
874      * @param to address to receive the ownership of the given token ID
875      * @param tokenId uint256 ID of the token to be transferred
876      * @param _data bytes data to send along with a safe transfer check
877      */
878     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
879         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
880         _safeTransferFrom(from, to, tokenId, _data);
881     }
882 
883     /**
884      * @dev Safely transfers the ownership of a given token ID to another address
885      * If the target address is a contract, it must implement `onERC721Received`,
886      * which is called upon a safe transfer, and return the magic value
887      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
888      * the transfer is reverted.
889      * Requires the msg.sender to be the owner, approved, or operator
890      * @param from current owner of the token
891      * @param to address to receive the ownership of the given token ID
892      * @param tokenId uint256 ID of the token to be transferred
893      * @param _data bytes data to send along with a safe transfer check
894      */
895     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
896         _transferFrom(from, to, tokenId);
897         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
898     }
899 
900     /**
901      * @dev Returns whether the specified token exists.
902      * @param tokenId uint256 ID of the token to query the existence of
903      * @return bool whether the token exists
904      */
905     function _exists(uint256 tokenId) internal view returns (bool) {
906         address owner = _tokenOwner[tokenId];
907         return owner != address(0);
908     }
909 
910     /**
911      * @dev Returns whether the given spender can transfer a given token ID.
912      * @param spender address of the spender to query
913      * @param tokenId uint256 ID of the token to be transferred
914      * @return bool whether the msg.sender is approved for the given token ID,
915      * is an operator of the owner, or is the owner of the token
916      */
917     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
918         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
919         address owner = ownerOf(tokenId);
920         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
921     }
922 
923     /**
924      * @dev Internal function to safely mint a new token.
925      * Reverts if the given token ID already exists.
926      * If the target address is a contract, it must implement `onERC721Received`,
927      * which is called upon a safe transfer, and return the magic value
928      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
929      * the transfer is reverted.
930      * @param to The address that will own the minted token
931      * @param tokenId uint256 ID of the token to be minted
932      */
933     function _safeMint(address to, uint256 tokenId) internal {
934         _safeMint(to, tokenId, "");
935     }
936 
937     /**
938      * @dev Internal function to safely mint a new token.
939      * Reverts if the given token ID already exists.
940      * If the target address is a contract, it must implement `onERC721Received`,
941      * which is called upon a safe transfer, and return the magic value
942      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
943      * the transfer is reverted.
944      * @param to The address that will own the minted token
945      * @param tokenId uint256 ID of the token to be minted
946      * @param _data bytes data to send along with a safe transfer check
947      */
948     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
949         _mint(to, tokenId);
950         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
951     }
952 
953     /**
954      * @dev Internal function to mint a new token.
955      * Reverts if the given token ID already exists.
956      * @param to The address that will own the minted token
957      * @param tokenId uint256 ID of the token to be minted
958      */
959     function _mint(address to, uint256 tokenId) internal {
960         require(to != address(0), "ERC721: mint to the zero address");
961         require(!_exists(tokenId), "ERC721: token already minted");
962 
963         _tokenOwner[tokenId] = to;
964         _ownedTokensCount[to].increment();
965 
966         emit Transfer(address(0), to, tokenId);
967     }
968 
969     /**
970      * @dev Internal function to burn a specific token.
971      * Reverts if the token does not exist.
972      * Deprecated, use {_burn} instead.
973      * @param owner owner of the token to burn
974      * @param tokenId uint256 ID of the token being burned
975      */
976     function _burn(address owner, uint256 tokenId) internal {
977         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
978 
979         _clearApproval(tokenId);
980 
981         _ownedTokensCount[owner].decrement();
982         _tokenOwner[tokenId] = address(0);
983 
984         emit Transfer(owner, address(0), tokenId);
985     }
986 
987     /**
988      * @dev Internal function to burn a specific token.
989      * Reverts if the token does not exist.
990      * @param tokenId uint256 ID of the token being burned
991      */
992     function _burn(uint256 tokenId) internal {
993         _burn(ownerOf(tokenId), tokenId);
994     }
995 
996     /**
997      * @dev Internal function to transfer ownership of a given token ID to another address.
998      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
999      * @param from current owner of the token
1000      * @param to address to receive the ownership of the given token ID
1001      * @param tokenId uint256 ID of the token to be transferred
1002      */
1003     function _transferFrom(address from, address to, uint256 tokenId) internal {
1004         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1005         require(to != address(0), "ERC721: transfer to the zero address");
1006 
1007         _clearApproval(tokenId);
1008 
1009         _ownedTokensCount[from].decrement();
1010         _ownedTokensCount[to].increment();
1011 
1012         _tokenOwner[tokenId] = to;
1013 
1014         emit Transfer(from, to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1019      * The call is not executed if the target address is not a contract.
1020      *
1021      * This function is deprecated.
1022      * @param from address representing the previous owner of the given token ID
1023      * @param to target address that will receive the tokens
1024      * @param tokenId uint256 ID of the token to be transferred
1025      * @param _data bytes optional data to send along with the call
1026      * @return bool whether the call correctly returned the expected magic value
1027      */
1028     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1029         internal returns (bool)
1030     {
1031         if (!to.isContract()) {
1032             return true;
1033         }
1034 
1035         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
1036         return (retval == _ERC721_RECEIVED);
1037     }
1038 
1039     /**
1040      * @dev Private function to clear current approval of a given token ID.
1041      * @param tokenId uint256 ID of the token to be transferred
1042      */
1043     function _clearApproval(uint256 tokenId) private {
1044         if (_tokenApprovals[tokenId] != address(0)) {
1045             _tokenApprovals[tokenId] = address(0);
1046         }
1047     }
1048 }
1049 
1050 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
1051 
1052 pragma solidity ^0.5.0;
1053 
1054 
1055 /**
1056  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1057  * @dev See https://eips.ethereum.org/EIPS/eip-721
1058  */
1059 contract IERC721Enumerable is IERC721 {
1060     function totalSupply() public view returns (uint256);
1061     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
1062 
1063     function tokenByIndex(uint256 index) public view returns (uint256);
1064 }
1065 
1066 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
1067 
1068 pragma solidity ^0.5.0;
1069 
1070 
1071 
1072 
1073 
1074 /**
1075  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
1076  * @dev See https://eips.ethereum.org/EIPS/eip-721
1077  */
1078 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
1079     // Mapping from owner to list of owned token IDs
1080     mapping(address => uint256[]) private _ownedTokens;
1081 
1082     // Mapping from token ID to index of the owner tokens list
1083     mapping(uint256 => uint256) private _ownedTokensIndex;
1084 
1085     // Array with all token ids, used for enumeration
1086     uint256[] private _allTokens;
1087 
1088     // Mapping from token id to position in the allTokens array
1089     mapping(uint256 => uint256) private _allTokensIndex;
1090 
1091     /*
1092      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1093      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1094      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1095      *
1096      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1097      */
1098     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1099 
1100     /**
1101      * @dev Constructor function.
1102      */
1103     constructor () public {
1104         // register the supported interface to conform to ERC721Enumerable via ERC165
1105         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1106     }
1107 
1108     /**
1109      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1110      * @param owner address owning the tokens list to be accessed
1111      * @param index uint256 representing the index to be accessed of the requested tokens list
1112      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1113      */
1114     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1115         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1116         return _ownedTokens[owner][index];
1117     }
1118 
1119     /**
1120      * @dev Gets the total amount of tokens stored by the contract.
1121      * @return uint256 representing the total amount of tokens
1122      */
1123     function totalSupply() public view returns (uint256) {
1124         return _allTokens.length;
1125     }
1126 
1127     /**
1128      * @dev Gets the token ID at a given index of all the tokens in this contract
1129      * Reverts if the index is greater or equal to the total number of tokens.
1130      * @param index uint256 representing the index to be accessed of the tokens list
1131      * @return uint256 token ID at the given index of the tokens list
1132      */
1133     function tokenByIndex(uint256 index) public view returns (uint256) {
1134         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1135         return _allTokens[index];
1136     }
1137 
1138     /**
1139      * @dev Internal function to transfer ownership of a given token ID to another address.
1140      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1141      * @param from current owner of the token
1142      * @param to address to receive the ownership of the given token ID
1143      * @param tokenId uint256 ID of the token to be transferred
1144      */
1145     function _transferFrom(address from, address to, uint256 tokenId) internal {
1146         super._transferFrom(from, to, tokenId);
1147 
1148         _removeTokenFromOwnerEnumeration(from, tokenId);
1149 
1150         _addTokenToOwnerEnumeration(to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Internal function to mint a new token.
1155      * Reverts if the given token ID already exists.
1156      * @param to address the beneficiary that will own the minted token
1157      * @param tokenId uint256 ID of the token to be minted
1158      */
1159     function _mint(address to, uint256 tokenId) internal {
1160         super._mint(to, tokenId);
1161 
1162         _addTokenToOwnerEnumeration(to, tokenId);
1163 
1164         _addTokenToAllTokensEnumeration(tokenId);
1165     }
1166 
1167     /**
1168      * @dev Internal function to burn a specific token.
1169      * Reverts if the token does not exist.
1170      * Deprecated, use {ERC721-_burn} instead.
1171      * @param owner owner of the token to burn
1172      * @param tokenId uint256 ID of the token being burned
1173      */
1174     function _burn(address owner, uint256 tokenId) internal {
1175         super._burn(owner, tokenId);
1176 
1177         _removeTokenFromOwnerEnumeration(owner, tokenId);
1178         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1179         _ownedTokensIndex[tokenId] = 0;
1180 
1181         _removeTokenFromAllTokensEnumeration(tokenId);
1182     }
1183 
1184     /**
1185      * @dev Gets the list of token IDs of the requested owner.
1186      * @param owner address owning the tokens
1187      * @return uint256[] List of token IDs owned by the requested address
1188      */
1189     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1190         return _ownedTokens[owner];
1191     }
1192 
1193     /**
1194      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1195      * @param to address representing the new owner of the given token ID
1196      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1197      */
1198     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1199         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1200         _ownedTokens[to].push(tokenId);
1201     }
1202 
1203     /**
1204      * @dev Private function to add a token to this extension's token tracking data structures.
1205      * @param tokenId uint256 ID of the token to be added to the tokens list
1206      */
1207     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1208         _allTokensIndex[tokenId] = _allTokens.length;
1209         _allTokens.push(tokenId);
1210     }
1211 
1212     /**
1213      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1214      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1215      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1216      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1217      * @param from address representing the previous owner of the given token ID
1218      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1219      */
1220     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1221         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1222         // then delete the last slot (swap and pop).
1223 
1224         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1225         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1226 
1227         // When the token to delete is the last token, the swap operation is unnecessary
1228         if (tokenIndex != lastTokenIndex) {
1229             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1230 
1231             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1232             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1233         }
1234 
1235         // This also deletes the contents at the last position of the array
1236         _ownedTokens[from].length--;
1237 
1238         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1239         // lastTokenId, or just over the end of the array if the token was the last one).
1240     }
1241 
1242     /**
1243      * @dev Private function to remove a token from this extension's token tracking data structures.
1244      * This has O(1) time complexity, but alters the order of the _allTokens array.
1245      * @param tokenId uint256 ID of the token to be removed from the tokens list
1246      */
1247     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1248         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1249         // then delete the last slot (swap and pop).
1250 
1251         uint256 lastTokenIndex = _allTokens.length.sub(1);
1252         uint256 tokenIndex = _allTokensIndex[tokenId];
1253 
1254         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1255         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1256         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1257         uint256 lastTokenId = _allTokens[lastTokenIndex];
1258 
1259         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1260         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1261 
1262         // This also deletes the contents at the last position of the array
1263         _allTokens.length--;
1264         _allTokensIndex[tokenId] = 0;
1265     }
1266 }
1267 
1268 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
1269 
1270 pragma solidity ^0.5.0;
1271 
1272 
1273 /**
1274  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1275  * @dev See https://eips.ethereum.org/EIPS/eip-721
1276  */
1277 contract IERC721Metadata is IERC721 {
1278     function name() external view returns (string memory);
1279     function symbol() external view returns (string memory);
1280     function tokenURI(uint256 tokenId) external view returns (string memory);
1281 }
1282 
1283 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
1284 
1285 pragma solidity ^0.5.0;
1286 
1287 
1288 
1289 
1290 
1291 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1292     // Token name
1293     string private _name;
1294 
1295     // Token symbol
1296     string private _symbol;
1297 
1298     // Optional mapping for token URIs
1299     mapping(uint256 => string) private _tokenURIs;
1300 
1301     /*
1302      *     bytes4(keccak256('name()')) == 0x06fdde03
1303      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1304      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1305      *
1306      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1307      */
1308     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1309 
1310     /**
1311      * @dev Constructor function
1312      */
1313     constructor (string memory name, string memory symbol) public {
1314         _name = name;
1315         _symbol = symbol;
1316 
1317         // register the supported interfaces to conform to ERC721 via ERC165
1318         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1319     }
1320 
1321     /**
1322      * @dev Gets the token name.
1323      * @return string representing the token name
1324      */
1325     function name() external view returns (string memory) {
1326         return _name;
1327     }
1328 
1329     /**
1330      * @dev Gets the token symbol.
1331      * @return string representing the token symbol
1332      */
1333     function symbol() external view returns (string memory) {
1334         return _symbol;
1335     }
1336 
1337     /**
1338      * @dev Returns an URI for a given token ID.
1339      * Throws if the token ID does not exist. May return an empty string.
1340      * @param tokenId uint256 ID of the token to query
1341      */
1342     function tokenURI(uint256 tokenId) external view returns (string memory) {
1343         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1344         return _tokenURIs[tokenId];
1345     }
1346 
1347     /**
1348      * @dev Internal function to set the token URI for a given token.
1349      * Reverts if the token ID does not exist.
1350      * @param tokenId uint256 ID of the token to set its URI
1351      * @param uri string URI to assign
1352      */
1353     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1354         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1355         _tokenURIs[tokenId] = uri;
1356     }
1357 
1358     /**
1359      * @dev Internal function to burn a specific token.
1360      * Reverts if the token does not exist.
1361      * Deprecated, use _burn(uint256) instead.
1362      * @param owner owner of the token to burn
1363      * @param tokenId uint256 ID of the token being burned by the msg.sender
1364      */
1365     function _burn(address owner, uint256 tokenId) internal {
1366         super._burn(owner, tokenId);
1367 
1368         // Clear metadata (if any)
1369         if (bytes(_tokenURIs[tokenId]).length != 0) {
1370             delete _tokenURIs[tokenId];
1371         }
1372     }
1373 }
1374 
1375 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
1376 
1377 pragma solidity ^0.5.0;
1378 
1379 
1380 
1381 
1382 /**
1383  * @title Full ERC721 Token
1384  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1385  * Moreover, it includes approve all functionality using operator terminology.
1386  *
1387  * See https://eips.ethereum.org/EIPS/eip-721
1388  */
1389 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1390     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1391         // solhint-disable-previous-line no-empty-blocks
1392     }
1393 }
1394 
1395 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1396 
1397 pragma solidity ^0.5.0;
1398 
1399 
1400 
1401 contract MinterRole is Context {
1402     using Roles for Roles.Role;
1403 
1404     event MinterAdded(address indexed account);
1405     event MinterRemoved(address indexed account);
1406 
1407     Roles.Role private _minters;
1408 
1409     constructor () internal {
1410         _addMinter(_msgSender());
1411     }
1412 
1413     modifier onlyMinter() {
1414         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1415         _;
1416     }
1417 
1418     function isMinter(address account) public view returns (bool) {
1419         return _minters.has(account);
1420     }
1421 
1422     function addMinter(address account) public onlyMinter {
1423         _addMinter(account);
1424     }
1425 
1426     function renounceMinter() public {
1427         _removeMinter(_msgSender());
1428     }
1429 
1430     function _addMinter(address account) internal {
1431         _minters.add(account);
1432         emit MinterAdded(account);
1433     }
1434 
1435     function _removeMinter(address account) internal {
1436         _minters.remove(account);
1437         emit MinterRemoved(account);
1438     }
1439 }
1440 
1441 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
1442 
1443 pragma solidity ^0.5.0;
1444 
1445 
1446 
1447 /**
1448  * @title ERC721Mintable
1449  * @dev ERC721 minting logic.
1450  */
1451 contract ERC721Mintable is ERC721, MinterRole {
1452     /**
1453      * @dev Function to mint tokens.
1454      * @param to The address that will receive the minted token.
1455      * @param tokenId The token id to mint.
1456      * @return A boolean that indicates if the operation was successful.
1457      */
1458     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1459         _mint(to, tokenId);
1460         return true;
1461     }
1462 
1463     /**
1464      * @dev Function to safely mint tokens.
1465      * @param to The address that will receive the minted token.
1466      * @param tokenId The token id to mint.
1467      * @return A boolean that indicates if the operation was successful.
1468      */
1469     function safeMint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1470         _safeMint(to, tokenId);
1471         return true;
1472     }
1473 
1474     /**
1475      * @dev Function to safely mint tokens.
1476      * @param to The address that will receive the minted token.
1477      * @param tokenId The token id to mint.
1478      * @param _data bytes data to send along with a safe transfer check.
1479      * @return A boolean that indicates if the operation was successful.
1480      */
1481     function safeMint(address to, uint256 tokenId, bytes memory _data) public onlyMinter returns (bool) {
1482         _safeMint(to, tokenId, _data);
1483         return true;
1484     }
1485 }
1486 
1487 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Pausable.sol
1488 
1489 pragma solidity ^0.5.0;
1490 
1491 
1492 
1493 /**
1494  * @title ERC721 Non-Fungible Pausable token
1495  * @dev ERC721 modified with pausable transfers.
1496  */
1497 contract ERC721Pausable is ERC721, Pausable {
1498     function approve(address to, uint256 tokenId) public whenNotPaused {
1499         super.approve(to, tokenId);
1500     }
1501 
1502     function setApprovalForAll(address to, bool approved) public whenNotPaused {
1503         super.setApprovalForAll(to, approved);
1504     }
1505 
1506     function _transferFrom(address from, address to, uint256 tokenId) internal whenNotPaused {
1507         super._transferFrom(from, to, tokenId);
1508     }
1509 }
1510 
1511 // File: contracts/GuildAsset.sol
1512 
1513 pragma solidity ^0.5.5;
1514 
1515 
1516 
1517 
1518 contract GuildAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
1519 
1520     uint16 public constant GUILD_TYPE_OFFSET = 10000;
1521     uint16 public constant GUILD_RARITY_OFFSET = 1000;
1522     uint256 public constant SHARE_RATE_DECIMAL = 10**18;
1523 
1524     uint16 public constant LEGENDARY_RARITY = 3;
1525     uint16 public constant GOLD_RARITY = 2;
1526     uint16 public constant SILVER_RARITY = 1;
1527 
1528     uint16 public constant NO_GUILD = 0;
1529 
1530     string public tokenURIPrefix = "https://cryptospells.jp/metadata/guild/";
1531 
1532     mapping(uint16 => uint256) private guildTypeToTotalVolume;
1533     mapping(uint16 => uint256) private guildTypeToStockSupplyLimit;
1534     mapping(uint16 => mapping(uint16 => uint256)) private guildTypeAndRarityToStockSupply;
1535     mapping(uint16 => uint256[]) private guildTypeToGuildStockList;
1536     mapping(uint16 => uint256) private guildTypeToGuildStockIndex;
1537     mapping(uint16 => mapping(uint16 => uint256)) private guildTypeAndRarityToGuildStockCount;
1538     mapping(uint16 => uint256) private rarityToStockVolume;
1539 
1540     // ロックアップ期間用変数
1541     //mapping(uint256 => bool) private allowed;
1542 
1543     constructor() ERC721Full("CryptoSpells:Guild", "CSPL") public {
1544       rarityToStockVolume[LEGENDARY_RARITY] = 100;
1545       rarityToStockVolume[GOLD_RARITY] = 10;
1546       rarityToStockVolume[SILVER_RARITY] = 1;
1547       guildTypeToTotalVolume[NO_GUILD] = 0;
1548     }
1549 
1550     function setSupplyAndStock(
1551       uint16 _guildType, // 3桁。ギルドごと１つ
1552       uint256 _totalVolume,
1553       uint256 _stockSupplyLimit,
1554       uint256 legendarySupply,
1555       uint256 goldSupply,
1556       uint256 silverSupply
1557     ) external onlyMinter {
1558       require(_guildType != 0, "guildType 0 is noguild");
1559       require(_totalVolume != 0, "totalVolume must not be 0");
1560       //require(getMintedStockCount(_guildType) == 0, "This GuildType already exists");
1561       require(
1562         legendarySupply.mul(rarityToStockVolume[LEGENDARY_RARITY])
1563         .add(goldSupply.mul(rarityToStockVolume[GOLD_RARITY]))
1564         .add(silverSupply.mul(rarityToStockVolume[SILVER_RARITY]))
1565         == _totalVolume
1566       );
1567       require(
1568         legendarySupply
1569         .add(goldSupply)
1570         .add(silverSupply)
1571         == _stockSupplyLimit
1572       );
1573       guildTypeToTotalVolume[_guildType] = _totalVolume;
1574       guildTypeToStockSupplyLimit[_guildType] = _stockSupplyLimit;
1575       guildTypeAndRarityToStockSupply[_guildType][LEGENDARY_RARITY] = legendarySupply;
1576       guildTypeAndRarityToStockSupply[_guildType][GOLD_RARITY] = goldSupply;
1577       guildTypeAndRarityToStockSupply[_guildType][SILVER_RARITY] = silverSupply;
1578     }
1579 
1580     //    mapping(uint16 => uint16) private guildTypeToSupplyLimit;
1581 
1582     // ロックアップ期間用
1583     /*
1584     function approve(address _to, uint256 _tokenId) public {
1585       require(allowed[_tokenId]);
1586       super.approve(_to, _tokenId);
1587     }
1588 
1589     function transferFrom(address _from, address _to, uint256 _tokenId) public {
1590       require(allowed[_tokenId]);
1591       super.transferFrom(_from, _to, _tokenId);
1592     }
1593 
1594     function unLockToken(uint256 _tokenId) public onlyMinter {
1595       allowed[_tokenId] = true;
1596     }
1597     function canTransfer(uint256 _tokenId) public view returns (bool) {
1598       return allowed[_tokenId];
1599     }
1600     */
1601 
1602     function isAlreadyMinted(uint256 _tokenId) public view returns (bool) {
1603       return _exists(_tokenId);
1604     }
1605 
1606     function isValidGuildStock(uint256 _guildTokenId) public view {
1607 
1608       uint16 rarity = getRarity(_guildTokenId);
1609       require((rarityToStockVolume[rarity] > 0), "invalid rarityToStockVolume");
1610 
1611       uint16 guildType = getGuildType(_guildTokenId);
1612       require((guildTypeToTotalVolume[guildType] > 0), "invalid guildTypeToTotalVolume");
1613 
1614       uint256 serial = _guildTokenId % GUILD_TYPE_OFFSET;
1615       require(serial != 0, "invalid serial zero");
1616       require(serial <= guildTypeAndRarityToStockSupply[guildType][rarity], "invalid serial guildTypeAndRarityToStockSupply");
1617     }
1618 
1619     function getTotalVolume(uint16 _guildType) public view returns (uint256) {
1620       return guildTypeToTotalVolume[_guildType];
1621     }
1622 
1623     function getStockSupplyLimit(uint16 _guildType) public view returns (uint256) {
1624       return guildTypeToStockSupplyLimit[_guildType];
1625     }
1626 
1627     function getGuildType(uint256 _guildTokenId) public view returns (uint16) {
1628       uint16 _guildType = uint16((_guildTokenId.div(GUILD_TYPE_OFFSET)) % GUILD_RARITY_OFFSET);
1629       return _guildType;
1630     }
1631 
1632     function getRarity(uint256 _guildTokenId) public view returns (uint16) {
1633       return uint16(_guildTokenId.div(GUILD_TYPE_OFFSET).div(GUILD_RARITY_OFFSET) % 10);
1634     }
1635 
1636     function getMintedStockCount(uint16 _guildType) public view returns (uint256) {
1637       return guildTypeToGuildStockIndex[_guildType];
1638     }
1639 
1640     function getMintedStockCountByRarity(uint16 _guildType, uint16 _rarity) public view returns (uint256) {
1641       return guildTypeAndRarityToGuildStockCount[_guildType][_rarity];
1642     }
1643 
1644     function getStockSupplyByRarity(uint16 _guildType, uint16 _rarity) public view returns (uint256) {
1645       return guildTypeAndRarityToStockSupply[_guildType][_rarity];
1646     }
1647 
1648     function getMintedStockList(uint16 _guildType) public view returns (uint256[] memory) {
1649       return guildTypeToGuildStockList[_guildType];
1650     }
1651 
1652     function getStockVolumeByRarity(uint16 _rarity) public view returns (uint256) {
1653       return rarityToStockVolume[_rarity];
1654     }
1655 
1656     function getShareRateWithDecimal(uint256 _guildTokenId) public view returns (uint256, uint256) {
1657       return (
1658         getStockVolumeByRarity(getRarity(_guildTokenId))
1659           .mul(SHARE_RATE_DECIMAL)
1660           .div(getTotalVolume(getGuildType(_guildTokenId))),
1661         SHARE_RATE_DECIMAL
1662       );
1663     }
1664 
1665 
1666 /*
1667     function setSupplyLimit(uint16 _guildType, uint16 _supplyLimit) external onlyMinter {
1668         require(_supplyLimit != 0);
1669         require(guildTypeToSupplyLimit[_guildType] == 0 || _supplyLimit < guildTypeToSupplyLimit[_guildType],
1670             "_supplyLimit is bigger");
1671         guildTypeToSupplyLimit[_guildType] = _supplyLimit;
1672     }
1673 */
1674     function setTokenURIPrefix(string calldata _tokenURIPrefix) external onlyMinter {
1675         tokenURIPrefix = _tokenURIPrefix;
1676     }
1677 /*
1678     function getSupplyLimit(uint16 _guildType) public view returns (uint16) {
1679         return guildTypeToSupplyLimit[_guildType];
1680     }
1681 */
1682     function mintGuildStock(address _owner, uint256 _guildTokenId) public onlyMinter {
1683       // _guildStockがtokenId
1684       require(!isAlreadyMinted(_guildTokenId), "is Already Minted");
1685 
1686       // バリデーションチェック
1687       isValidGuildStock(_guildTokenId);
1688 
1689       //  supplyチェック
1690       uint16 _guildType = getGuildType(_guildTokenId);
1691       require(guildTypeToGuildStockIndex[_guildType] < guildTypeToStockSupplyLimit[_guildType]);
1692       uint16 rarity = getRarity(_guildTokenId);
1693       require(guildTypeAndRarityToGuildStockCount[_guildType][rarity] < guildTypeAndRarityToStockSupply[_guildType][rarity], "supply over");
1694 
1695       _mint(_owner, _guildTokenId);
1696       guildTypeToGuildStockList[_guildType].push(_guildTokenId);
1697       guildTypeToGuildStockIndex[_guildType]++;
1698       guildTypeAndRarityToGuildStockCount[_guildType][rarity]++;
1699     }
1700 /*
1701     function mintGuildAsset(address _owner, uint256 _tokenId) public onlyMinter {
1702       // 200010001
1703         uint16 _guildType = uint16(_tokenId / GUILD_TYPE_OFFSET);
1704         uint16 _guildTypeIndex = uint16(_tokenId % GUILD_TYPE_OFFSET) - 1;
1705         require(_guildTypeIndex < guildTypeToSupplyLimit[_guildType], "supply over");
1706         _mint(_owner, _tokenId);
1707     }
1708 */
1709 
1710     function tokenURI(uint256 tokenId) public view returns (string memory) {
1711         bytes32 tokenIdBytes;
1712         if (tokenId == 0) {
1713             tokenIdBytes = "0";
1714         } else {
1715             uint256 value = tokenId;
1716             while (value > 0) {
1717                 tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1718                 tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1719                 value /= 10;
1720             }
1721         }
1722 
1723         bytes memory prefixBytes = bytes(tokenURIPrefix);
1724         bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1725 
1726         uint8 i;
1727         uint8 index = 0;
1728 
1729         for (i = 0; i < prefixBytes.length; i++) {
1730             tokenURIBytes[index] = prefixBytes[i];
1731             index++;
1732         }
1733 
1734         for (i = 0; i < tokenIdBytes.length; i++) {
1735             tokenURIBytes[index] = tokenIdBytes[i];
1736             index++;
1737         }
1738 
1739         return string(tokenURIBytes);
1740     }
1741 
1742 }
1743 
1744 // File: contracts/CSPLGuildPool.sol
1745 
1746 pragma solidity ^0.5.5;
1747 
1748 
1749 
1750 
1751 contract ReentrancyGuard {
1752     /// @dev counter to allow mutex lock with only one SSTORE operation
1753     uint256 private _guardCounter;
1754 
1755     constructor () internal {
1756         // The counter starts at one to prevent changing it from zero to a non-zero
1757         // value, which is a more expensive operation.
1758         _guardCounter = 1;
1759     }
1760 
1761     /**
1762      * @dev Prevents a contract from calling itself, directly or indirectly.
1763      * Calling a `nonReentrant` function from another `nonReentrant`
1764      * function is not supported. It is possible to prevent this from happening
1765      * by making the `nonReentrant` function external, and make it call a
1766      * `private` function that does the actual work.
1767      */
1768     modifier nonReentrant() {
1769         _guardCounter += 1;
1770         uint256 localCounter = _guardCounter;
1771         _;
1772         require(localCounter == _guardCounter);
1773     }
1774 }
1775 
1776 contract CSPLGuildPool is Ownable, Pausable, ReentrancyGuard {
1777 
1778   GuildAsset public guildAsset;
1779 
1780   // ギルドタイプごとの総量
1781   mapping(uint16 => uint256) private guildTypeToTotalAmount;
1782   // ギルドトークン単位のこれまで引き出した量
1783   mapping(uint256 => uint256) private guildStockToWithdrawnAmount;
1784   // 引き出し可能なアドレスリスト
1785   mapping(address => bool) private allowedAddresses;
1786 
1787   event EthAddedToPool(
1788     uint16 indexed guildType,
1789     address txSender,
1790     address indexed purchaseBy,
1791     uint256 value,
1792     uint256 at
1793   );
1794 
1795   event WithdrawEther(
1796     uint256 indexed guildTokenId,
1797     address indexed owner,
1798     uint256 value,
1799     uint256 at
1800   );
1801 
1802   event AllowedAddressSet(
1803     address allowedAddress,
1804     bool allowedStatus
1805   );
1806 
1807   constructor(address _guildAssetAddress) public {
1808     guildAsset = GuildAsset(_guildAssetAddress);
1809   }
1810 
1811   // GuildAseetコントラクトのコントラクトアドレス変更
1812   function setGuildAssetAddress(address _guildAssetAddress) external onlyOwner() {
1813     guildAsset = GuildAsset(_guildAssetAddress);
1814   }
1815 
1816   // getter setter
1817   function getAllowedAddress(address _address) public view returns (bool) {
1818     return allowedAddresses[_address];
1819   }
1820 
1821   function setAllowedAddress(address _address, bool desired) external onlyOwner() {
1822     allowedAddresses[_address] = desired;
1823   }
1824 
1825   function getGuildStockWithdrawnAmount(uint256 _guildTokenId) public view returns (uint256) {
1826     return guildStockToWithdrawnAmount[_guildTokenId];
1827   }
1828 
1829   function getGuildTypeToTotalAmount(uint16 _guildType) public view returns (uint256) {
1830     return guildTypeToTotalAmount[_guildType];
1831   }
1832 
1833   // poolに追加（buySPLから呼ばれる）
1834   // TODO
1835   function addEthToGuildPool(uint16 _guildType, address _purchaseBy) external payable whenNotPaused() nonReentrant() {
1836   //function addEthToGuildPool(uint16 _guildType, address _purchaseBy, uint256 value) external {
1837     require(guildAsset.getTotalVolume(_guildType) > 0);
1838     require(allowedAddresses[msg.sender]);
1839     guildTypeToTotalAmount[_guildType] += msg.value;
1840 
1841     emit EthAddedToPool(
1842       _guildType,
1843       msg.sender,
1844       _purchaseBy,
1845       msg.value,
1846       block.timestamp
1847     );
1848   }
1849 
1850   function withdrawMyAllRewards() external whenNotPaused() nonReentrant() {
1851     require(getWithdrawableBalance(msg.sender) > 0);
1852 
1853     uint256 withdrawValue;
1854     uint256 balance = guildAsset.balanceOf(msg.sender);
1855 
1856     for (uint256 i=balance; i > 0; i--) {
1857       uint256 guildStock = guildAsset.tokenOfOwnerByIndex(msg.sender, i-1);
1858       uint256 tmpAmount = getGuildStockWithdrawableBalance(guildStock);
1859       withdrawValue += tmpAmount;
1860       guildStockToWithdrawnAmount[guildStock] += tmpAmount;
1861 
1862       emit WithdrawEther(
1863         guildStock,
1864         msg.sender,
1865         tmpAmount,
1866         block.timestamp
1867       );
1868     }
1869     msg.sender.transfer(withdrawValue);
1870   }
1871 
1872   // 引き出し
1873   function withdrawMyReward(uint256 _guildTokenId) external whenNotPaused() nonReentrant() {
1874     require(guildAsset.ownerOf(_guildTokenId) == msg.sender);
1875     uint256 withdrawableAmount = getGuildStockWithdrawableBalance(_guildTokenId);
1876     require(withdrawableAmount > 0);
1877 
1878     guildStockToWithdrawnAmount[_guildTokenId] += withdrawableAmount;
1879     msg.sender.transfer(withdrawableAmount);
1880 
1881     emit WithdrawEther(
1882       _guildTokenId,
1883       msg.sender,
1884       withdrawableAmount,
1885       block.timestamp
1886     );
1887   }
1888 
1889   // ギルドトークンごとの引き出し可能な量
1890   // 全体の総和×割合-これまで引き出した量
1891   function getGuildStockWithdrawableBalance(uint256 _guildTokenId) public view returns (uint256) {
1892     guildAsset.isValidGuildStock(_guildTokenId);
1893 
1894     uint16 _guildType = guildAsset.getGuildType(_guildTokenId);
1895     (uint256 shareRate, uint256 decimal) = guildAsset.getShareRateWithDecimal(_guildTokenId);
1896     uint256 maxAmount = guildTypeToTotalAmount[_guildType] * shareRate / decimal;
1897     return maxAmount - guildStockToWithdrawnAmount[_guildTokenId];
1898   }
1899 
1900   // そのオーナーの引き出し可能な総量
1901   function getWithdrawableBalance(address _ownerAddress) public view returns (uint256) {
1902     uint256 balance = guildAsset.balanceOf(_ownerAddress);
1903     uint256 withdrawableAmount;
1904 
1905     for (uint256 i=balance; i > 0; i--) {
1906       uint256 guildTokenId = guildAsset.tokenOfOwnerByIndex(_ownerAddress, i-1);
1907       withdrawableAmount += getGuildStockWithdrawableBalance(guildTokenId);
1908     }
1909 
1910     return withdrawableAmount;
1911   }
1912 
1913 }
1914 /* solhint-enable indent*/