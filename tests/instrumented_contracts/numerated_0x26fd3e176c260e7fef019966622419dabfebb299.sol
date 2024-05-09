1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
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
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(isOwner(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Returns true if the caller is the current owner.
70      */
71     function isOwner() public view returns (bool) {
72         return _msgSender() == _owner;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public onlyOwner {
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      */
98     function _transferOwnership(address newOwner) internal {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         emit OwnershipTransferred(_owner, newOwner);
101         _owner = newOwner;
102     }
103 }
104 
105 /**
106  * @title Roles
107  * @dev Library for managing addresses assigned to a Role.
108  */
109 library Roles {
110     struct Role {
111         mapping (address => bool) bearer;
112     }
113 
114     /**
115      * @dev Give an account access to this role.
116      */
117     function add(Role storage role, address account) internal {
118         require(!has(role, account), "Roles: account already has role");
119         role.bearer[account] = true;
120     }
121 
122     /**
123      * @dev Remove an account's access to this role.
124      */
125     function remove(Role storage role, address account) internal {
126         require(has(role, account), "Roles: account does not have role");
127         role.bearer[account] = false;
128     }
129 
130     /**
131      * @dev Check if an account has this role.
132      * @return bool
133      */
134     function has(Role storage role, address account) internal view returns (bool) {
135         require(account != address(0), "Roles: account is the zero address");
136         return role.bearer[account];
137     }
138 }
139 
140 contract SignerRole is Context {
141     using Roles for Roles.Role;
142 
143     event SignerAdded(address indexed account);
144     event SignerRemoved(address indexed account);
145 
146     Roles.Role private _signers;
147 
148     constructor () internal {
149         _addSigner(_msgSender());
150     }
151 
152     modifier onlySigner() {
153         require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");
154         _;
155     }
156 
157     function isSigner(address account) public view returns (bool) {
158         return _signers.has(account);
159     }
160 
161     function addSigner(address account) public onlySigner {
162         _addSigner(account);
163     }
164 
165     function renounceSigner() public {
166         _removeSigner(_msgSender());
167     }
168 
169     function _addSigner(address account) internal {
170         _signers.add(account);
171         emit SignerAdded(account);
172     }
173 
174     function _removeSigner(address account) internal {
175         _signers.remove(account);
176         emit SignerRemoved(account);
177     }
178 }
179 
180 /**
181  * @dev Interface of the ERC165 standard, as defined in the
182  * https://eips.ethereum.org/EIPS/eip-165[EIP].
183  *
184  * Implementers can declare support of contract interfaces, which can then be
185  * queried by others ({ERC165Checker}).
186  *
187  * For an implementation, see {ERC165}.
188  */
189 interface IERC165 {
190     /**
191      * @dev Returns true if this contract implements the interface defined by
192      * `interfaceId`. See the corresponding
193      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
194      * to learn more about how these ids are created.
195      *
196      * This function call must use less than 30 000 gas.
197      */
198     function supportsInterface(bytes4 interfaceId) external view returns (bool);
199 }
200 
201 /**
202  * @dev Required interface of an ERC721 compliant contract.
203  */
204 contract IERC721 is IERC165 {
205     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
206     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
207     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
208 
209     /**
210      * @dev Returns the number of NFTs in `owner`'s account.
211      */
212     function balanceOf(address owner) public view returns (uint256 balance);
213 
214     /**
215      * @dev Returns the owner of the NFT specified by `tokenId`.
216      */
217     function ownerOf(uint256 tokenId) public view returns (address owner);
218 
219     /**
220      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
221      * another (`to`).
222      *
223      *
224      *
225      * Requirements:
226      * - `from`, `to` cannot be zero.
227      * - `tokenId` must be owned by `from`.
228      * - If the caller is not `from`, it must be have been allowed to move this
229      * NFT by either {approve} or {setApprovalForAll}.
230      */
231     function safeTransferFrom(address from, address to, uint256 tokenId) public;
232     /**
233      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
234      * another (`to`).
235      *
236      * Requirements:
237      * - If the caller is not `from`, it must be approved to move this NFT by
238      * either {approve} or {setApprovalForAll}.
239      */
240     function transferFrom(address from, address to, uint256 tokenId) public;
241     function approve(address to, uint256 tokenId) public;
242     function getApproved(uint256 tokenId) public view returns (address operator);
243 
244     function setApprovalForAll(address operator, bool _approved) public;
245     function isApprovedForAll(address owner, address operator) public view returns (bool);
246 
247 
248     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
249 }
250 
251 /**
252  * @title ERC721 token receiver interface
253  * @dev Interface for any contract that wants to support safeTransfers
254  * from ERC721 asset contracts.
255  */
256 contract IERC721Receiver {
257     /**
258      * @notice Handle the receipt of an NFT
259      * @dev The ERC721 smart contract calls this function on the recipient
260      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
261      * otherwise the caller will revert the transaction. The selector to be
262      * returned can be obtained as `this.onERC721Received.selector`. This
263      * function MAY throw to revert and reject the transfer.
264      * Note: the ERC721 contract address is always the message sender.
265      * @param operator The address which called `safeTransferFrom` function
266      * @param from The address which previously owned the token
267      * @param tokenId The NFT identifier which is being transferred
268      * @param data Additional data with no specified format
269      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
270      */
271     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
272     public returns (bytes4);
273 }
274 
275 /**
276  * @dev Wrappers over Solidity's arithmetic operations with added overflow
277  * checks.
278  *
279  * Arithmetic operations in Solidity wrap on overflow. This can easily result
280  * in bugs, because programmers usually assume that an overflow raises an
281  * error, which is the standard behavior in high level programming languages.
282  * `SafeMath` restores this intuition by reverting the transaction when an
283  * operation overflows.
284  *
285  * Using this library instead of the unchecked operations eliminates an entire
286  * class of bugs, so it's recommended to use it always.
287  */
288 library SafeMath {
289     /**
290      * @dev Returns the addition of two unsigned integers, reverting on
291      * overflow.
292      *
293      * Counterpart to Solidity's `+` operator.
294      *
295      * Requirements:
296      * - Addition cannot overflow.
297      */
298     function add(uint256 a, uint256 b) internal pure returns (uint256) {
299         uint256 c = a + b;
300         require(c >= a, "SafeMath: addition overflow");
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the subtraction of two unsigned integers, reverting on
307      * overflow (when the result is negative).
308      *
309      * Counterpart to Solidity's `-` operator.
310      *
311      * Requirements:
312      * - Subtraction cannot overflow.
313      */
314     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
315         return sub(a, b, "SafeMath: subtraction overflow");
316     }
317 
318     /**
319      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
320      * overflow (when the result is negative).
321      *
322      * Counterpart to Solidity's `-` operator.
323      *
324      * Requirements:
325      * - Subtraction cannot overflow.
326      *
327      * _Available since v2.4.0._
328      */
329     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
330         require(b <= a, errorMessage);
331         uint256 c = a - b;
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the multiplication of two unsigned integers, reverting on
338      * overflow.
339      *
340      * Counterpart to Solidity's `*` operator.
341      *
342      * Requirements:
343      * - Multiplication cannot overflow.
344      */
345     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
346         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
347         // benefit is lost if 'b' is also tested.
348         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
349         if (a == 0) {
350             return 0;
351         }
352 
353         uint256 c = a * b;
354         require(c / a == b, "SafeMath: multiplication overflow");
355 
356         return c;
357     }
358 
359     /**
360      * @dev Returns the integer division of two unsigned integers. Reverts on
361      * division by zero. The result is rounded towards zero.
362      *
363      * Counterpart to Solidity's `/` operator. Note: this function uses a
364      * `revert` opcode (which leaves remaining gas untouched) while Solidity
365      * uses an invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      * - The divisor cannot be zero.
369      */
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         return div(a, b, "SafeMath: division by zero");
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      * - The divisor cannot be zero.
384      *
385      * _Available since v2.4.0._
386      */
387     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
388         // Solidity only automatically asserts when dividing by 0
389         require(b > 0, errorMessage);
390         uint256 c = a / b;
391         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
392 
393         return c;
394     }
395 
396     /**
397      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
398      * Reverts when dividing by zero.
399      *
400      * Counterpart to Solidity's `%` operator. This function uses a `revert`
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402      * invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      * - The divisor cannot be zero.
406      */
407     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
408         return mod(a, b, "SafeMath: modulo by zero");
409     }
410 
411     /**
412      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
413      * Reverts with custom message when dividing by zero.
414      *
415      * Counterpart to Solidity's `%` operator. This function uses a `revert`
416      * opcode (which leaves remaining gas untouched) while Solidity uses an
417      * invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      * - The divisor cannot be zero.
421      *
422      * _Available since v2.4.0._
423      */
424     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
425         require(b != 0, errorMessage);
426         return a % b;
427     }
428 }
429 
430 /**
431  * @dev Collection of functions related to the address type
432  */
433 library Address {
434     /**
435      * @dev Returns true if `account` is a contract.
436      *
437      * [IMPORTANT]
438      * ====
439      * It is unsafe to assume that an address for which this function returns
440      * false is an externally-owned account (EOA) and not a contract.
441      *
442      * Among others, `isContract` will return false for the following 
443      * types of addresses:
444      *
445      *  - an externally-owned account
446      *  - a contract in construction
447      *  - an address where a contract will be created
448      *  - an address where a contract lived, but was destroyed
449      * ====
450      */
451     function isContract(address account) internal view returns (bool) {
452         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
453         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
454         // for accounts without code, i.e. `keccak256('')`
455         bytes32 codehash;
456         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
457         // solhint-disable-next-line no-inline-assembly
458         assembly { codehash := extcodehash(account) }
459         return (codehash != accountHash && codehash != 0x0);
460     }
461 
462     /**
463      * @dev Converts an `address` into `address payable`. Note that this is
464      * simply a type cast: the actual underlying value is not changed.
465      *
466      * _Available since v2.4.0._
467      */
468     function toPayable(address account) internal pure returns (address payable) {
469         return address(uint160(account));
470     }
471 
472     /**
473      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
474      * `recipient`, forwarding all available gas and reverting on errors.
475      *
476      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
477      * of certain opcodes, possibly making contracts go over the 2300 gas limit
478      * imposed by `transfer`, making them unable to receive funds via
479      * `transfer`. {sendValue} removes this limitation.
480      *
481      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
482      *
483      * IMPORTANT: because control is transferred to `recipient`, care must be
484      * taken to not create reentrancy vulnerabilities. Consider using
485      * {ReentrancyGuard} or the
486      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
487      *
488      * _Available since v2.4.0._
489      */
490     function sendValue(address payable recipient, uint256 amount) internal {
491         require(address(this).balance >= amount, "Address: insufficient balance");
492 
493         // solhint-disable-next-line avoid-call-value
494         (bool success, ) = recipient.call.value(amount)("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 }
498 
499 /**
500  * @title Counters
501  * @author Matt Condon (@shrugs)
502  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
503  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
504  *
505  * Include with `using Counters for Counters.Counter;`
506  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
507  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
508  * directly accessed.
509  */
510 library Counters {
511     using SafeMath for uint256;
512 
513     struct Counter {
514         // This variable should never be directly accessed by users of the library: interactions must be restricted to
515         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
516         // this feature: see https://github.com/ethereum/solidity/issues/4637
517         uint256 _value; // default: 0
518     }
519 
520     function current(Counter storage counter) internal view returns (uint256) {
521         return counter._value;
522     }
523 
524     function increment(Counter storage counter) internal {
525         // The {SafeMath} overflow check can be skipped here, see the comment at the top
526         counter._value += 1;
527     }
528 
529     function decrement(Counter storage counter) internal {
530         counter._value = counter._value.sub(1);
531     }
532 }
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts may inherit from this and call {_registerInterface} to declare
538  * their support of an interface.
539  */
540 contract ERC165 is IERC165 {
541     /*
542      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
543      */
544     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
545 
546     /**
547      * @dev Mapping of interface ids to whether or not it's supported.
548      */
549     mapping(bytes4 => bool) private _supportedInterfaces;
550 
551     constructor () internal {
552         // Derived contracts need only register support for their own interfaces,
553         // we register support for ERC165 itself here
554         _registerInterface(_INTERFACE_ID_ERC165);
555     }
556 
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      *
560      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
561      */
562     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
563         return _supportedInterfaces[interfaceId];
564     }
565 
566     /**
567      * @dev Registers the contract as an implementer of the interface defined by
568      * `interfaceId`. Support of the actual ERC165 interface is automatic and
569      * registering its interface id is not required.
570      *
571      * See {IERC165-supportsInterface}.
572      *
573      * Requirements:
574      *
575      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
576      */
577     function _registerInterface(bytes4 interfaceId) internal {
578         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
579         _supportedInterfaces[interfaceId] = true;
580     }
581 }
582 
583 /**
584  * @title ERC721 Non-Fungible Token Standard basic implementation
585  * @dev see https://eips.ethereum.org/EIPS/eip-721
586  */
587 contract ERC721 is Context, ERC165, IERC721 {
588     using SafeMath for uint256;
589     using Address for address;
590     using Counters for Counters.Counter;
591 
592     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
593     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
594     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
595 
596     // Mapping from token ID to owner
597     mapping (uint256 => address) private _tokenOwner;
598 
599     // Mapping from token ID to approved address
600     mapping (uint256 => address) private _tokenApprovals;
601 
602     // Mapping from owner to number of owned token
603     mapping (address => Counters.Counter) private _ownedTokensCount;
604 
605     // Mapping from owner to operator approvals
606     mapping (address => mapping (address => bool)) private _operatorApprovals;
607 
608     /*
609      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
610      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
611      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
612      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
613      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
614      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
615      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
616      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
617      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
618      *
619      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
620      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
621      */
622     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
623 
624     constructor () public {
625         // register the supported interfaces to conform to ERC721 via ERC165
626         _registerInterface(_INTERFACE_ID_ERC721);
627     }
628 
629     /**
630      * @dev Gets the balance of the specified address.
631      * @param owner address to query the balance of
632      * @return uint256 representing the amount owned by the passed address
633      */
634     function balanceOf(address owner) public view returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636 
637         return _ownedTokensCount[owner].current();
638     }
639 
640     /**
641      * @dev Gets the owner of the specified token ID.
642      * @param tokenId uint256 ID of the token to query the owner of
643      * @return address currently marked as the owner of the given token ID
644      */
645     function ownerOf(uint256 tokenId) public view returns (address) {
646         address owner = _tokenOwner[tokenId];
647         require(owner != address(0), "ERC721: owner query for nonexistent token");
648 
649         return owner;
650     }
651 
652     /**
653      * @dev Approves another address to transfer the given token ID
654      * The zero address indicates there is no approved address.
655      * There can only be one approved address per token at a given time.
656      * Can only be called by the token owner or an approved operator.
657      * @param to address to be approved for the given token ID
658      * @param tokenId uint256 ID of the token to be approved
659      */
660     function approve(address to, uint256 tokenId) public {
661         address owner = ownerOf(tokenId);
662         require(to != owner, "ERC721: approval to current owner");
663 
664         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
665             "ERC721: approve caller is not owner nor approved for all"
666         );
667 
668         _tokenApprovals[tokenId] = to;
669         emit Approval(owner, to, tokenId);
670     }
671 
672     /**
673      * @dev Gets the approved address for a token ID, or zero if no address set
674      * Reverts if the token ID does not exist.
675      * @param tokenId uint256 ID of the token to query the approval of
676      * @return address currently approved for the given token ID
677      */
678     function getApproved(uint256 tokenId) public view returns (address) {
679         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
680 
681         return _tokenApprovals[tokenId];
682     }
683 
684     /**
685      * @dev Sets or unsets the approval of a given operator
686      * An operator is allowed to transfer all tokens of the sender on their behalf.
687      * @param to operator address to set the approval
688      * @param approved representing the status of the approval to be set
689      */
690     function setApprovalForAll(address to, bool approved) public {
691         require(to != _msgSender(), "ERC721: approve to caller");
692 
693         _operatorApprovals[_msgSender()][to] = approved;
694         emit ApprovalForAll(_msgSender(), to, approved);
695     }
696 
697     /**
698      * @dev Tells whether an operator is approved by a given owner.
699      * @param owner owner address which you want to query the approval of
700      * @param operator operator address which you want to query the approval of
701      * @return bool whether the given operator is approved by the given owner
702      */
703     function isApprovedForAll(address owner, address operator) public view returns (bool) {
704         return _operatorApprovals[owner][operator];
705     }
706 
707     /**
708      * @dev Transfers the ownership of a given token ID to another address.
709      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
710      * Requires the msg.sender to be the owner, approved, or operator.
711      * @param from current owner of the token
712      * @param to address to receive the ownership of the given token ID
713      * @param tokenId uint256 ID of the token to be transferred
714      */
715     function transferFrom(address from, address to, uint256 tokenId) public {
716         //solhint-disable-next-line max-line-length
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718 
719         _transferFrom(from, to, tokenId);
720     }
721 
722     /**
723      * @dev Safely transfers the ownership of a given token ID to another address
724      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
725      * which is called upon a safe transfer, and return the magic value
726      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
727      * the transfer is reverted.
728      * Requires the msg.sender to be the owner, approved, or operator
729      * @param from current owner of the token
730      * @param to address to receive the ownership of the given token ID
731      * @param tokenId uint256 ID of the token to be transferred
732      */
733     function safeTransferFrom(address from, address to, uint256 tokenId) public {
734         safeTransferFrom(from, to, tokenId, "");
735     }
736 
737     /**
738      * @dev Safely transfers the ownership of a given token ID to another address
739      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
740      * which is called upon a safe transfer, and return the magic value
741      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
742      * the transfer is reverted.
743      * Requires the _msgSender() to be the owner, approved, or operator
744      * @param from current owner of the token
745      * @param to address to receive the ownership of the given token ID
746      * @param tokenId uint256 ID of the token to be transferred
747      * @param _data bytes data to send along with a safe transfer check
748      */
749     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751         _safeTransferFrom(from, to, tokenId, _data);
752     }
753 
754     /**
755      * @dev Safely transfers the ownership of a given token ID to another address
756      * If the target address is a contract, it must implement `onERC721Received`,
757      * which is called upon a safe transfer, and return the magic value
758      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
759      * the transfer is reverted.
760      * Requires the msg.sender to be the owner, approved, or operator
761      * @param from current owner of the token
762      * @param to address to receive the ownership of the given token ID
763      * @param tokenId uint256 ID of the token to be transferred
764      * @param _data bytes data to send along with a safe transfer check
765      */
766     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
767         _transferFrom(from, to, tokenId);
768         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
769     }
770 
771     /**
772      * @dev Returns whether the specified token exists.
773      * @param tokenId uint256 ID of the token to query the existence of
774      * @return bool whether the token exists
775      */
776     function _exists(uint256 tokenId) internal view returns (bool) {
777         address owner = _tokenOwner[tokenId];
778         return owner != address(0);
779     }
780 
781     /**
782      * @dev Returns whether the given spender can transfer a given token ID.
783      * @param spender address of the spender to query
784      * @param tokenId uint256 ID of the token to be transferred
785      * @return bool whether the msg.sender is approved for the given token ID,
786      * is an operator of the owner, or is the owner of the token
787      */
788     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
789         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
790         address owner = ownerOf(tokenId);
791         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
792     }
793 
794     /**
795      * @dev Internal function to safely mint a new token.
796      * Reverts if the given token ID already exists.
797      * If the target address is a contract, it must implement `onERC721Received`,
798      * which is called upon a safe transfer, and return the magic value
799      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
800      * the transfer is reverted.
801      * @param to The address that will own the minted token
802      * @param tokenId uint256 ID of the token to be minted
803      */
804     function _safeMint(address to, uint256 tokenId) internal {
805         _safeMint(to, tokenId, "");
806     }
807 
808     /**
809      * @dev Internal function to safely mint a new token.
810      * Reverts if the given token ID already exists.
811      * If the target address is a contract, it must implement `onERC721Received`,
812      * which is called upon a safe transfer, and return the magic value
813      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
814      * the transfer is reverted.
815      * @param to The address that will own the minted token
816      * @param tokenId uint256 ID of the token to be minted
817      * @param _data bytes data to send along with a safe transfer check
818      */
819     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
820         _mint(to, tokenId);
821         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
822     }
823 
824     /**
825      * @dev Internal function to mint a new token.
826      * Reverts if the given token ID already exists.
827      * @param to The address that will own the minted token
828      * @param tokenId uint256 ID of the token to be minted
829      */
830     function _mint(address to, uint256 tokenId) internal {
831         require(to != address(0), "ERC721: mint to the zero address");
832         require(!_exists(tokenId), "ERC721: token already minted");
833 
834         _tokenOwner[tokenId] = to;
835         _ownedTokensCount[to].increment();
836 
837         emit Transfer(address(0), to, tokenId);
838     }
839 
840     /**
841      * @dev Internal function to burn a specific token.
842      * Reverts if the token does not exist.
843      * Deprecated, use {_burn} instead.
844      * @param owner owner of the token to burn
845      * @param tokenId uint256 ID of the token being burned
846      */
847     function _burn(address owner, uint256 tokenId) internal {
848         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
849 
850         _clearApproval(tokenId);
851 
852         _ownedTokensCount[owner].decrement();
853         _tokenOwner[tokenId] = address(0);
854 
855         emit Transfer(owner, address(0), tokenId);
856     }
857 
858     /**
859      * @dev Internal function to burn a specific token.
860      * Reverts if the token does not exist.
861      * @param tokenId uint256 ID of the token being burned
862      */
863     function _burn(uint256 tokenId) internal {
864         _burn(ownerOf(tokenId), tokenId);
865     }
866 
867     /**
868      * @dev Internal function to transfer ownership of a given token ID to another address.
869      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
870      * @param from current owner of the token
871      * @param to address to receive the ownership of the given token ID
872      * @param tokenId uint256 ID of the token to be transferred
873      */
874     function _transferFrom(address from, address to, uint256 tokenId) internal {
875         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
876         require(to != address(0), "ERC721: transfer to the zero address");
877 
878         _clearApproval(tokenId);
879 
880         _ownedTokensCount[from].decrement();
881         _ownedTokensCount[to].increment();
882 
883         _tokenOwner[tokenId] = to;
884 
885         emit Transfer(from, to, tokenId);
886     }
887 
888     /**
889      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
890      * The call is not executed if the target address is not a contract.
891      *
892      * This is an internal detail of the `ERC721` contract and its use is deprecated.
893      * @param from address representing the previous owner of the given token ID
894      * @param to target address that will receive the tokens
895      * @param tokenId uint256 ID of the token to be transferred
896      * @param _data bytes optional data to send along with the call
897      * @return bool whether the call correctly returned the expected magic value
898      */
899     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
900         internal returns (bool)
901     {
902         if (!to.isContract()) {
903             return true;
904         }
905         // solhint-disable-next-line avoid-low-level-calls
906         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
907             IERC721Receiver(to).onERC721Received.selector,
908             _msgSender(),
909             from,
910             tokenId,
911             _data
912         ));
913         if (!success) {
914             if (returndata.length > 0) {
915                 // solhint-disable-next-line no-inline-assembly
916                 assembly {
917                     let returndata_size := mload(returndata)
918                     revert(add(32, returndata), returndata_size)
919                 }
920             } else {
921                 revert("ERC721: transfer to non ERC721Receiver implementer");
922             }
923         } else {
924             bytes4 retval = abi.decode(returndata, (bytes4));
925             return (retval == _ERC721_RECEIVED);
926         }
927     }
928 
929     /**
930      * @dev Private function to clear current approval of a given token ID.
931      * @param tokenId uint256 ID of the token to be transferred
932      */
933     function _clearApproval(uint256 tokenId) private {
934         if (_tokenApprovals[tokenId] != address(0)) {
935             _tokenApprovals[tokenId] = address(0);
936         }
937     }
938 }
939 
940 /**
941  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
942  * @dev See https://eips.ethereum.org/EIPS/eip-721
943  */
944 contract IERC721Metadata is IERC721 {
945     function name() external view returns (string memory);
946     function symbol() external view returns (string memory);
947     function tokenURI(uint256 tokenId) external view returns (string memory);
948 }
949 
950 /**
951  * @title ERC721 Burnable Token
952  * @dev ERC721 Token that can be irreversibly burned (destroyed).
953  */
954 contract ERC721Burnable is Context, ERC721 {
955     /**
956      * @dev Burns a specific ERC721 token.
957      * @param tokenId uint256 id of the ERC721 token to be burned.
958      */
959     function burn(uint256 tokenId) public {
960         //solhint-disable-next-line max-line-length
961         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
962         _burn(tokenId);
963     }
964 }
965 
966 /**
967  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
968  * @dev See https://eips.ethereum.org/EIPS/eip-721
969  */
970 contract IERC721Enumerable is IERC721 {
971     function totalSupply() public view returns (uint256);
972     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
973 
974     function tokenByIndex(uint256 index) public view returns (uint256);
975 }
976 
977 /**
978  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
979  * @dev See https://eips.ethereum.org/EIPS/eip-721
980  */
981 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
982     // Mapping from owner to list of owned token IDs
983     mapping(address => uint256[]) private _ownedTokens;
984 
985     // Mapping from token ID to index of the owner tokens list
986     mapping(uint256 => uint256) private _ownedTokensIndex;
987 
988     // Array with all token ids, used for enumeration
989     uint256[] private _allTokens;
990 
991     // Mapping from token id to position in the allTokens array
992     mapping(uint256 => uint256) private _allTokensIndex;
993 
994     /*
995      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
996      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
997      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
998      *
999      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1000      */
1001     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1002 
1003     /**
1004      * @dev Constructor function.
1005      */
1006     constructor () public {
1007         // register the supported interface to conform to ERC721Enumerable via ERC165
1008         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1009     }
1010 
1011     /**
1012      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1013      * @param owner address owning the tokens list to be accessed
1014      * @param index uint256 representing the index to be accessed of the requested tokens list
1015      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1016      */
1017     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1018         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1019         return _ownedTokens[owner][index];
1020     }
1021 
1022     /**
1023      * @dev Gets the total amount of tokens stored by the contract.
1024      * @return uint256 representing the total amount of tokens
1025      */
1026     function totalSupply() public view returns (uint256) {
1027         return _allTokens.length;
1028     }
1029 
1030     /**
1031      * @dev Gets the token ID at a given index of all the tokens in this contract
1032      * Reverts if the index is greater or equal to the total number of tokens.
1033      * @param index uint256 representing the index to be accessed of the tokens list
1034      * @return uint256 token ID at the given index of the tokens list
1035      */
1036     function tokenByIndex(uint256 index) public view returns (uint256) {
1037         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1038         return _allTokens[index];
1039     }
1040 
1041     /**
1042      * @dev Internal function to transfer ownership of a given token ID to another address.
1043      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1044      * @param from current owner of the token
1045      * @param to address to receive the ownership of the given token ID
1046      * @param tokenId uint256 ID of the token to be transferred
1047      */
1048     function _transferFrom(address from, address to, uint256 tokenId) internal {
1049         super._transferFrom(from, to, tokenId);
1050 
1051         _removeTokenFromOwnerEnumeration(from, tokenId);
1052 
1053         _addTokenToOwnerEnumeration(to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Internal function to mint a new token.
1058      * Reverts if the given token ID already exists.
1059      * @param to address the beneficiary that will own the minted token
1060      * @param tokenId uint256 ID of the token to be minted
1061      */
1062     function _mint(address to, uint256 tokenId) internal {
1063         super._mint(to, tokenId);
1064 
1065         _addTokenToOwnerEnumeration(to, tokenId);
1066 
1067         _addTokenToAllTokensEnumeration(tokenId);
1068     }
1069 
1070     /**
1071      * @dev Internal function to burn a specific token.
1072      * Reverts if the token does not exist.
1073      * Deprecated, use {ERC721-_burn} instead.
1074      * @param owner owner of the token to burn
1075      * @param tokenId uint256 ID of the token being burned
1076      */
1077     function _burn(address owner, uint256 tokenId) internal {
1078         super._burn(owner, tokenId);
1079 
1080         _removeTokenFromOwnerEnumeration(owner, tokenId);
1081         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1082         _ownedTokensIndex[tokenId] = 0;
1083 
1084         _removeTokenFromAllTokensEnumeration(tokenId);
1085     }
1086 
1087     /**
1088      * @dev Gets the list of token IDs of the requested owner.
1089      * @param owner address owning the tokens
1090      * @return uint256[] List of token IDs owned by the requested address
1091      */
1092     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1093         return _ownedTokens[owner];
1094     }
1095 
1096     /**
1097      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1098      * @param to address representing the new owner of the given token ID
1099      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1100      */
1101     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1102         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1103         _ownedTokens[to].push(tokenId);
1104     }
1105 
1106     /**
1107      * @dev Private function to add a token to this extension's token tracking data structures.
1108      * @param tokenId uint256 ID of the token to be added to the tokens list
1109      */
1110     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1111         _allTokensIndex[tokenId] = _allTokens.length;
1112         _allTokens.push(tokenId);
1113     }
1114 
1115     /**
1116      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1117      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1118      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1119      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1120      * @param from address representing the previous owner of the given token ID
1121      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1122      */
1123     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1124         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1125         // then delete the last slot (swap and pop).
1126 
1127         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1128         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1129 
1130         // When the token to delete is the last token, the swap operation is unnecessary
1131         if (tokenIndex != lastTokenIndex) {
1132             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1133 
1134             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1135             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1136         }
1137 
1138         // This also deletes the contents at the last position of the array
1139         _ownedTokens[from].length--;
1140 
1141         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1142         // lastTokenId, or just over the end of the array if the token was the last one).
1143     }
1144 
1145     /**
1146      * @dev Private function to remove a token from this extension's token tracking data structures.
1147      * This has O(1) time complexity, but alters the order of the _allTokens array.
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list
1149      */
1150     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1151         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = _allTokens.length.sub(1);
1155         uint256 tokenIndex = _allTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1158         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1159         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1160         uint256 lastTokenId = _allTokens[lastTokenIndex];
1161 
1162         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1163         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1164 
1165         // This also deletes the contents at the last position of the array
1166         _allTokens.length--;
1167         _allTokensIndex[tokenId] = 0;
1168     }
1169 }
1170 
1171 library UintLibrary {
1172     function toString(uint256 _i) internal pure returns (string memory) {
1173         if (_i == 0) {
1174             return "0";
1175         }
1176         uint j = _i;
1177         uint len;
1178         while (j != 0) {
1179             len++;
1180             j /= 10;
1181         }
1182         bytes memory bstr = new bytes(len);
1183         uint k = len - 1;
1184         while (_i != 0) {
1185             bstr[k--] = byte(uint8(48 + _i % 10));
1186             _i /= 10;
1187         }
1188         return string(bstr);
1189     }
1190 }
1191 
1192 library StringLibrary {
1193     using UintLibrary for uint256;
1194 
1195     function append(string memory _a, string memory _b) internal pure returns (string memory) {
1196         bytes memory _ba = bytes(_a);
1197         bytes memory _bb = bytes(_b);
1198         bytes memory bab = new bytes(_ba.length + _bb.length);
1199         uint k = 0;
1200         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1201         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1202         return string(bab);
1203     }
1204 
1205     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1206         bytes memory _ba = bytes(_a);
1207         bytes memory _bb = bytes(_b);
1208         bytes memory _bc = bytes(_c);
1209         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
1210         uint k = 0;
1211         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
1212         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
1213         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
1214         return string(bbb);
1215     }
1216 
1217     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1218         bytes memory msgBytes = bytes(message);
1219         bytes memory fullMessage = concat(
1220             bytes("\x19Ethereum Signed Message:\n"),
1221             bytes(msgBytes.length.toString()),
1222             msgBytes,
1223             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
1224         );
1225         return ecrecover(keccak256(fullMessage), v, r, s);
1226     }
1227 
1228     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
1229         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
1230         uint k = 0;
1231         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
1232         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
1233         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
1234         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
1235         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
1236         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
1237         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
1238         return resultBytes;
1239     }
1240 }
1241 
1242 contract HasContractURI is ERC165 {
1243 
1244     string public contractURI;
1245 
1246     /*
1247      * bytes4(keccak256('contractURI()')) == 0xe8a3d485
1248      */
1249     bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;
1250 
1251     constructor(string memory _contractURI) public {
1252         contractURI = _contractURI;
1253         _registerInterface(_INTERFACE_ID_CONTRACT_URI);
1254     }
1255 
1256     /**
1257      * @dev Internal function to set the contract URI
1258      * @param _contractURI string URI prefix to assign
1259      */
1260     function _setContractURI(string memory _contractURI) internal {
1261         contractURI = _contractURI;
1262     }
1263 }
1264 
1265 contract HasTokenURI {
1266     using StringLibrary for string;
1267 
1268     //Token URI prefix
1269     string public tokenURIPrefix;
1270 
1271     // Optional mapping for token URIs
1272     mapping(uint256 => string) private _tokenURIs;
1273 
1274     constructor(string memory _tokenURIPrefix) public {
1275         tokenURIPrefix = _tokenURIPrefix;
1276     }
1277 
1278     /**
1279      * @dev Returns an URI for a given token ID.
1280      * Throws if the token ID does not exist. May return an empty string.
1281      * @param tokenId uint256 ID of the token to query
1282      */
1283     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
1284         return tokenURIPrefix.append(_tokenURIs[tokenId]);
1285     }
1286 
1287     /**
1288      * @dev Internal function to set the token URI for a given token.
1289      * Reverts if the token ID does not exist.
1290      * @param tokenId uint256 ID of the token to set its URI
1291      * @param uri string URI to assign
1292      */
1293     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1294         _tokenURIs[tokenId] = uri;
1295     }
1296 
1297     /**
1298      * @dev Internal function to set the token URI prefix.
1299      * @param _tokenURIPrefix string URI prefix to assign
1300      */
1301     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
1302         tokenURIPrefix = _tokenURIPrefix;
1303     }
1304 
1305     function _clearTokenURI(uint256 tokenId) internal {
1306         if (bytes(_tokenURIs[tokenId]).length != 0) {
1307             delete _tokenURIs[tokenId];
1308         }
1309     }
1310 }
1311 
1312 contract HasSecondarySaleFees is ERC165 {
1313 
1314     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
1315 
1316     /*
1317      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1318      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1319      *
1320      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
1321      */
1322     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1323 
1324     constructor() public {
1325         _registerInterface(_INTERFACE_ID_FEES);
1326     }
1327 
1328     function getFeeRecipients(uint256 id) public view returns (address payable[] memory);
1329     function getFeeBps(uint256 id) public view returns (uint[] memory);
1330 }
1331 
1332 /**
1333  * @title Full ERC721 Token with support for tokenURIPrefix
1334  * This implementation includes all the required and some optional functionality of the ERC721 standard
1335  * Moreover, it includes approve all functionality using operator terminology
1336  * @dev see https://eips.ethereum.org/EIPS/eip-721
1337  */
1338 contract ERC721Base is HasSecondarySaleFees, ERC721, HasContractURI, HasTokenURI, ERC721Enumerable {
1339     // Token name
1340     string public name;
1341 
1342     // Token symbol
1343     string public symbol;
1344 
1345     struct Fee {
1346         address payable recipient;
1347         uint256 value;
1348     }
1349 
1350     // id => fees
1351     mapping (uint256 => Fee[]) public fees;
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
1365     constructor (string memory _name, string memory _symbol, string memory contractURI, string memory _tokenURIPrefix) HasContractURI(contractURI) HasTokenURI(_tokenURIPrefix) public {
1366         name = _name;
1367         symbol = _symbol;
1368 
1369         // register the supported interfaces to conform to ERC721 via ERC165
1370         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1371     }
1372 
1373     function getFeeRecipients(uint256 id) public view returns (address payable[] memory) {
1374         Fee[] memory _fees = fees[id];
1375         address payable[] memory result = new address payable[](_fees.length);
1376         for (uint i = 0; i < _fees.length; i++) {
1377             result[i] = _fees[i].recipient;
1378         }
1379         return result;
1380     }
1381 
1382     function getFeeBps(uint256 id) public view returns (uint[] memory) {
1383         Fee[] memory _fees = fees[id];
1384         uint[] memory result = new uint[](_fees.length);
1385         for (uint i = 0; i < _fees.length; i++) {
1386             result[i] = _fees[i].value;
1387         }
1388         return result;
1389     }
1390 
1391     function _mint(address to, uint256 tokenId, Fee[] memory _fees) internal {
1392         _mint(to, tokenId);
1393         address[] memory recipients = new address[](_fees.length);
1394         uint[] memory bps = new uint[](_fees.length);
1395         for (uint i = 0; i < _fees.length; i++) {
1396             require(_fees[i].recipient != address(0x0), "Recipient should be present");
1397             require(_fees[i].value != 0, "Fee value should be positive");
1398             fees[tokenId].push(_fees[i]);
1399             recipients[i] = _fees[i].recipient;
1400             bps[i] = _fees[i].value;
1401         }
1402         if (_fees.length > 0) {
1403             emit SecondarySaleFees(tokenId, recipients, bps);
1404         }
1405     }
1406 
1407     /**
1408      * @dev Returns an URI for a given token ID.
1409      * Throws if the token ID does not exist. May return an empty string.
1410      * @param tokenId uint256 ID of the token to query
1411      */
1412     function tokenURI(uint256 tokenId) external view returns (string memory) {
1413         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1414         return super._tokenURI(tokenId);
1415     }
1416 
1417     /**
1418      * @dev Internal function to set the token URI for a given token.
1419      * Reverts if the token ID does not exist.
1420      * @param tokenId uint256 ID of the token to set its URI
1421      * @param uri string URI to assign
1422      */
1423     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1424         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1425         super._setTokenURI(tokenId, uri);
1426     }
1427 
1428     /**
1429      * @dev Internal function to burn a specific token.
1430      * Reverts if the token does not exist.
1431      * Deprecated, use _burn(uint256) instead.
1432      * @param owner owner of the token to burn
1433      * @param tokenId uint256 ID of the token being burned by the msg.sender
1434      */
1435     function _burn(address owner, uint256 tokenId) internal {
1436         super._burn(owner, tokenId);
1437         _clearTokenURI(tokenId);
1438     }
1439 }
1440 
1441 
1442 
1443 
1444 
1445 
1446 
1447 
1448 /**
1449  * @title MintableOwnableToken
1450  * @dev only owner can mint token.
1451  */
1452 contract MintableOwnableToken is Ownable, ERC721, IERC721Metadata, ERC721Burnable, ERC721Base, SignerRole {
1453 
1454     event CreateERC721_v4(address indexed creator, string name, string symbol);
1455 
1456     constructor (string memory name, string memory symbol, string memory contractURI, string memory tokenURIPrefix, address signer) public ERC721Base(name, symbol, contractURI, tokenURIPrefix) {
1457         emit CreateERC721_v4(msg.sender, name, symbol);
1458         _addSigner(signer);
1459         _registerInterface(bytes4(keccak256('MINT_WITH_ADDRESS')));
1460     }
1461 
1462     function mint(uint256 tokenId, uint8 v, bytes32 r, bytes32 s, Fee[] memory _fees, string memory tokenURI) onlyOwner public {
1463         require(isSigner(ecrecover(keccak256(abi.encodePacked(this, tokenId)), v, r, s)), "signer should sign tokenId");
1464         _mint(msg.sender, tokenId, _fees);
1465         _setTokenURI(tokenId, tokenURI);
1466     }
1467 
1468     function addSigner(address account) public onlyOwner {
1469         _addSigner(account);
1470     }
1471 
1472     function removeSigner(address account) public onlyOwner {
1473         _removeSigner(account);
1474     }
1475 
1476     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
1477         _setTokenURIPrefix(tokenURIPrefix);
1478     }
1479 
1480     function setContractURI(string memory contractURI) public onlyOwner {
1481         _setContractURI(contractURI);
1482     }
1483 }