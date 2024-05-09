1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.5.17;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: Address
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following 
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
33         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
34         // for accounts without code, i.e. `keccak256('')`
35         bytes32 codehash;
36         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
37         // solhint-disable-next-line no-inline-assembly
38         assembly { codehash := extcodehash(account) }
39         return (codehash != accountHash && codehash != 0x0);
40     }
41 
42     /**
43      * @dev Converts an `address` into `address payable`. Note that this is
44      * simply a type cast: the actual underlying value is not changed.
45      *
46      * _Available since v2.4.0._
47      */
48     function toPayable(address account) internal pure returns (address payable) {
49         return address(uint160(account));
50     }
51 
52     /**
53      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
54      * `recipient`, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by `transfer`, making them unable to receive funds via
59      * `transfer`. {sendValue} removes this limitation.
60      *
61      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to `recipient`, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      *
68      * _Available since v2.4.0._
69      */
70     function sendValue(address payable recipient, uint256 amount) internal {
71         require(address(this).balance >= amount, "Address: insufficient balance");
72 
73         // solhint-disable-next-line avoid-call-value
74         (bool success, ) = recipient.call.value(amount)("");
75         require(success, "Address: unable to send value, recipient may have reverted");
76     }
77 }
78 
79 // Part: Context
80 
81 /*
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with GSN meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 contract Context {
92     // Empty internal constructor, to prevent people from mistakenly deploying
93     // an instance of this contract, which should be used via inheritance.
94     constructor () internal { }
95     // solhint-disable-previous-line no-empty-blocks
96 
97     function _msgSender() internal view returns (address payable) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view returns (bytes memory) {
102         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
103         return msg.data;
104     }
105 }
106 
107 // Part: IERC165
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 
119 interface IERC165 {
120     /**
121      * @dev Returns true if this contract implements the interface defined by
122      * `interfaceId`. See the corresponding
123      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
124      * to learn more about how these ids are created.
125      *
126      * This function call must use less than 30 000 gas.
127      */
128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
129 }
130 
131 // Part: IERC721Receiver
132 
133 /**
134  * @title ERC721 token receiver interface
135  * @dev Interface for any contract that wants to support safeTransfers
136  * from ERC721 asset contracts.
137  */
138 contract IERC721Receiver {
139     /**
140      * @notice Handle the receipt of an NFT
141      * @dev The ERC721 smart contract calls this function on the recipient
142      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
143      * otherwise the caller will revert the transaction. The selector to be
144      * returned can be obtained as `this.onERC721Received.selector`. This
145      * function MAY throw to revert and reject the transfer.
146      * Note: the ERC721 contract address is always the message sender.
147      * @param operator The address which called `safeTransferFrom` function
148      * @param from The address which previously owned the token
149      * @param tokenId The NFT identifier which is being transferred
150      * @param data Additional data with no specified format
151      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
152      */
153     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
154     public returns (bytes4);
155 }
156 
157 // Part: Roles
158 
159 /**
160  * @title Roles
161  * @dev Library for managing addresses assigned to a Role.
162  */
163 library Roles {
164     struct Role {
165         mapping (address => bool) bearer;
166     }
167 
168     /**
169      * @dev Give an account access to this role.
170      */
171     function add(Role storage role, address account) internal {
172         require(!has(role, account), "Roles: account already has role");
173         role.bearer[account] = true;
174     }
175 
176     /**
177      * @dev Remove an account's access to this role.
178      */
179     function remove(Role storage role, address account) internal {
180         require(has(role, account), "Roles: account does not have role");
181         role.bearer[account] = false;
182     }
183 
184     /**
185      * @dev Check if an account has this role.
186      * @return bool
187      */
188     function has(Role storage role, address account) internal view returns (bool) {
189         require(account != address(0), "Roles: account is the zero address");
190         return role.bearer[account];
191     }
192 }
193 
194 // Part: SafeMath
195 
196 /**
197  * @title SafeMath
198  * @dev Math operations with safety checks that throw on error
199  */
200 library SafeMath {
201 
202     /**
203     * @dev Multiplies two numbers, throws on overflow.
204     */
205     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
206         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
207         // benefit is lost if 'b' is also tested.
208         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
209         if (a == 0) {
210             return 0;
211         }
212 
213         c = a * b;
214         assert(c / a == b);
215         return c;
216     }
217 
218     /**
219     * @dev Integer division of two numbers, truncating the quotient.
220     */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         // assert(b > 0); // Solidity automatically throws when dividing by 0
223         // uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225         return a / b;
226     }
227 
228     /**
229     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
230     */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         assert(b <= a);
233         return a - b;
234     }
235 
236     /**
237     * @dev Adds two numbers, throws on overflow.
238     */
239     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
240         c = a + b;
241         assert(c >= a);
242         return c;
243     }
244 }
245 
246 // Part: Counters
247 
248 /**
249  * @title Counters
250  * @author Matt Condon (@shrugs)
251  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
252  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
253  *
254  * Include with `using Counters for Counters.Counter;`
255  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
256  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
257  * directly accessed.
258  */
259 library Counters {
260     using SafeMath for uint256;
261 
262     struct Counter {
263         // This variable should never be directly accessed by users of the library: interactions must be restricted to
264         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
265         // this feature: see https://github.com/ethereum/solidity/issues/4637
266         uint256 _value; // default: 0
267     }
268 
269     function current(Counter storage counter) internal view returns (uint256) {
270         return counter._value;
271     }
272 
273     function increment(Counter storage counter) internal {
274         // The {SafeMath} overflow check can be skipped here, see the comment at the top
275         counter._value += 1;
276     }
277 
278     function decrement(Counter storage counter) internal {
279         counter._value = counter._value.sub(1);
280     }
281 }
282 
283 // Part: ERC165
284 
285 /**
286  * @dev Implementation of the {IERC165} interface.
287  *
288  * Contracts may inherit from this and call {_registerInterface} to declare
289  * their support of an interface.
290  */
291 contract ERC165 is IERC165 {
292     /*
293      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
294      */
295     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
296 
297     /**
298      * @dev Mapping of interface ids to whether or not it's supported.
299      */
300     mapping(bytes4 => bool) private _supportedInterfaces;
301 
302     constructor () internal {
303         // Derived contracts need only register support for their own interfaces,
304         // we register support for ERC165 itself here
305         _registerInterface(_INTERFACE_ID_ERC165);
306     }
307 
308     /**
309      * @dev See {IERC165-supportsInterface}.
310      *
311      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
312      */
313     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
314         return _supportedInterfaces[interfaceId];
315     }
316 
317     /**
318      * @dev Registers the contract as an implementer of the interface defined by
319      * `interfaceId`. Support of the actual ERC165 interface is automatic and
320      * registering its interface id is not required.
321      *
322      * See {IERC165-supportsInterface}.
323      *
324      * Requirements:
325      *
326      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
327      */
328     function _registerInterface(bytes4 interfaceId) internal {
329         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
330         _supportedInterfaces[interfaceId] = true;
331     }
332 }
333 
334 // Part: IERC721
335 
336 /**
337  * @dev Required interface of an ERC721 compliant contract.
338  */
339 contract IERC721 is IERC165 {
340     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
341     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of NFTs in `owner`'s account.
346      */
347     function balanceOf(address owner) public view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the NFT specified by `tokenId`.
351      */
352     function ownerOf(uint256 tokenId) public view returns (address owner);
353 
354     /**
355      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
356      * another (`to`).
357      *
358      *
359      *
360      * Requirements:
361      * - `from`, `to` cannot be zero.
362      * - `tokenId` must be owned by `from`.
363      * - If the caller is not `from`, it must be have been allowed to move this
364      * NFT by either {approve} or {setApprovalForAll}.
365      */
366     function safeTransferFrom(address from, address to, uint256 tokenId) public;
367     /**
368      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
369      * another (`to`).
370      *
371      * Requirements:
372      * - If the caller is not `from`, it must be approved to move this NFT by
373      * either {approve} or {setApprovalForAll}.
374      */
375     function transferFrom(address from, address to, uint256 tokenId) public;
376     function approve(address to, uint256 tokenId) public;
377     function getApproved(uint256 tokenId) public view returns (address operator);
378 
379     function setApprovalForAll(address operator, bool _approved) public;
380     function isApprovedForAll(address owner, address operator) public view returns (bool);
381 
382 
383     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
384 }
385 
386 // Part: Ownable
387 
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 contract Ownable is Context {
398     address private _owner;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor () internal {
406         address msgSender = _msgSender();
407         _owner = msgSender;
408         emit OwnershipTransferred(address(0), msgSender);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(isOwner(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426     /**
427      * @dev Returns true if the caller is the current owner.
428      */
429     function isOwner() public view returns (bool) {
430         return _msgSender() == _owner;
431     }
432 
433     /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * NOTE: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public onlyOwner {
450         _transferOwnership(newOwner);
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      */
456     function _transferOwnership(address newOwner) internal {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 // Part: SignerRole
464 
465 /**
466  * @title SignerRole
467  * @dev A signer role contract.
468  */
469 contract SignerRole is Context {
470     using Roles for Roles.Role;
471 
472     event SignerAdded(address indexed account);
473     event SignerRemoved(address indexed account);
474 
475     Roles.Role private _signers;
476 
477     constructor () internal {
478         _addSigner(_msgSender());
479     }
480 
481     /**
482      * @dev Makes function callable only if sender is a signer.
483      */
484     modifier onlySigner() {
485         require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");
486         _;
487     }
488 
489     /**
490      * @dev Checks if the address is a signer.
491      */
492     function isSigner(address account) public view returns (bool) {
493         return _signers.has(account);
494     }
495 
496     /**
497      * @dev Makes the address a signer. Only other signers can add new signers.
498      */
499     function addSigner(address account) public onlySigner {
500         _addSigner(account);
501     }
502 
503     /**
504      * @dev Removes the address from signers. Signer can be renounced only by himself.
505      */
506     function renounceSigner() public {
507         _removeSigner(_msgSender());
508     }
509 
510     function _addSigner(address account) internal {
511         _signers.add(account);
512         emit SignerAdded(account);
513     }
514 
515     function _removeSigner(address account) internal {
516         _signers.remove(account);
517         emit SignerRemoved(account);
518     }
519 }
520 
521 // Part: UintLibrary
522 
523 library UintLibrary {
524     using SafeMath for uint;
525 
526 
527     function toString(uint256 _i) internal pure returns (string memory) {
528         if (_i == 0) {
529             return "0";
530         }
531         uint j = _i;
532         uint len;
533         while (j != 0) {
534             len++;
535             j /= 10;
536         }
537         bytes memory bstr = new bytes(len);
538         uint k = len - 1;
539         while (_i != 0) {
540             bstr[k--] = byte(uint8(48 + _i % 10));
541             _i /= 10;
542         }
543         return string(bstr);
544     }
545 
546     function bp(uint value, uint bpValue) internal pure returns (uint) {
547         return value.mul(bpValue).div(10000);
548     }
549 }
550 
551 // Part: ERC721
552 
553 /**
554  * @title ERC721 Non-Fungible Token Standard basic implementation
555  * @dev see https://eips.ethereum.org/EIPS/eip-721
556  */
557 contract ERC721 is Context, ERC165, IERC721 {
558     using SafeMath for uint256;
559     using Address for address;
560     using Counters for Counters.Counter;
561 
562     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
563     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
564     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
565 
566     // Mapping from token ID to owner
567     mapping (uint256 => address) private _tokenOwner;
568 
569     // Mapping from token ID to approved address
570     mapping (uint256 => address) private _tokenApprovals;
571 
572     // Mapping from owner to number of owned token
573     mapping (address => Counters.Counter) private _ownedTokensCount;
574 
575     // Mapping from owner to operator approvals
576     mapping (address => mapping (address => bool)) private _operatorApprovals;
577 
578     /*
579      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
580      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
581      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
582      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
583      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
584      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
585      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
586      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
587      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
588      *
589      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
590      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
591      */
592     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
593 
594     constructor () public {
595         // register the supported interfaces to conform to ERC721 via ERC165
596         _registerInterface(_INTERFACE_ID_ERC721);
597     }
598 
599     /**
600      * @dev Gets the balance of the specified address.
601      * @param owner address to query the balance of
602      * @return uint256 representing the amount owned by the passed address
603      */
604     function balanceOf(address owner) public view returns (uint256) {
605         require(owner != address(0), "ERC721: balance query for the zero address");
606 
607         return _ownedTokensCount[owner].current();
608     }
609 
610     /**
611      * @dev Gets the owner of the specified token ID.
612      * @param tokenId uint256 ID of the token to query the owner of
613      * @return address currently marked as the owner of the given token ID
614      */
615     function ownerOf(uint256 tokenId) public view returns (address) {
616         address owner = _tokenOwner[tokenId];
617         require(owner != address(0), "ERC721: owner query for nonexistent token");
618 
619         return owner;
620     }
621 
622     /**
623      * @dev Approves another address to transfer the given token ID
624      * The zero address indicates there is no approved address.
625      * There can only be one approved address per token at a given time.
626      * Can only be called by the token owner or an approved operator.
627      * @param to address to be approved for the given token ID
628      * @param tokenId uint256 ID of the token to be approved
629      */
630     function approve(address to, uint256 tokenId) public {
631         address owner = ownerOf(tokenId);
632         require(to != owner, "ERC721: approval to current owner");
633 
634         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
635             "ERC721: approve caller is not owner nor approved for all"
636         );
637 
638         _tokenApprovals[tokenId] = to;
639         emit Approval(owner, to, tokenId);
640     }
641 
642     /**
643      * @dev Gets the approved address for a token ID, or zero if no address set
644      * Reverts if the token ID does not exist.
645      * @param tokenId uint256 ID of the token to query the approval of
646      * @return address currently approved for the given token ID
647      */
648     function getApproved(uint256 tokenId) public view returns (address) {
649         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
650 
651         return _tokenApprovals[tokenId];
652     }
653 
654     /**
655      * @dev Sets or unsets the approval of a given operator
656      * An operator is allowed to transfer all tokens of the sender on their behalf.
657      * @param to operator address to set the approval
658      * @param approved representing the status of the approval to be set
659      */
660     function setApprovalForAll(address to, bool approved) public {
661         require(to != _msgSender(), "ERC721: approve to caller");
662 
663         _operatorApprovals[_msgSender()][to] = approved;
664         emit ApprovalForAll(_msgSender(), to, approved);
665     }
666 
667     /**
668      * @dev Tells whether an operator is approved by a given owner.
669      * @param owner owner address which you want to query the approval of
670      * @param operator operator address which you want to query the approval of
671      * @return bool whether the given operator is approved by the given owner
672      */
673     function isApprovedForAll(address owner, address operator) public view returns (bool) {
674         return _operatorApprovals[owner][operator];
675     }
676 
677     /**
678      * @dev Transfers the ownership of a given token ID to another address.
679      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
680      * Requires the msg.sender to be the owner, approved, or operator.
681      * @param from current owner of the token
682      * @param to address to receive the ownership of the given token ID
683      * @param tokenId uint256 ID of the token to be transferred
684      */
685     function transferFrom(address from, address to, uint256 tokenId) public {
686         //solhint-disable-next-line max-line-length
687         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
688 
689         _transferFrom(from, to, tokenId);
690     }
691 
692     /**
693      * @dev Safely transfers the ownership of a given token ID to another address
694      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
695      * which is called upon a safe transfer, and return the magic value
696      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
697      * the transfer is reverted.
698      * Requires the msg.sender to be the owner, approved, or operator
699      * @param from current owner of the token
700      * @param to address to receive the ownership of the given token ID
701      * @param tokenId uint256 ID of the token to be transferred
702      */
703     function safeTransferFrom(address from, address to, uint256 tokenId) public {
704         safeTransferFrom(from, to, tokenId, "");
705     }
706 
707     /**
708      * @dev Safely transfers the ownership of a given token ID to another address
709      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
710      * which is called upon a safe transfer, and return the magic value
711      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
712      * the transfer is reverted.
713      * Requires the _msgSender() to be the owner, approved, or operator
714      * @param from current owner of the token
715      * @param to address to receive the ownership of the given token ID
716      * @param tokenId uint256 ID of the token to be transferred
717      * @param _data bytes data to send along with a safe transfer check
718      */
719     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
720         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
721         _safeTransferFrom(from, to, tokenId, _data);
722     }
723 
724     /**
725      * @dev Safely transfers the ownership of a given token ID to another address
726      * If the target address is a contract, it must implement `onERC721Received`,
727      * which is called upon a safe transfer, and return the magic value
728      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
729      * the transfer is reverted.
730      * Requires the msg.sender to be the owner, approved, or operator
731      * @param from current owner of the token
732      * @param to address to receive the ownership of the given token ID
733      * @param tokenId uint256 ID of the token to be transferred
734      * @param _data bytes data to send along with a safe transfer check
735      */
736     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
737         _transferFrom(from, to, tokenId);
738         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
739     }
740 
741     /**
742      * @dev Returns whether the specified token exists.
743      * @param tokenId uint256 ID of the token to query the existence of
744      * @return bool whether the token exists
745      */
746     function _exists(uint256 tokenId) internal view returns (bool) {
747         address owner = _tokenOwner[tokenId];
748         return owner != address(0);
749     }
750 
751     /**
752      * @dev Returns whether the given spender can transfer a given token ID.
753      * @param spender address of the spender to query
754      * @param tokenId uint256 ID of the token to be transferred
755      * @return bool whether the msg.sender is approved for the given token ID,
756      * is an operator of the owner, or is the owner of the token
757      */
758     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
759         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
760         address owner = ownerOf(tokenId);
761         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
762     }
763 
764     /**
765      * @dev Internal function to safely mint a new token.
766      * Reverts if the given token ID already exists.
767      * If the target address is a contract, it must implement `onERC721Received`,
768      * which is called upon a safe transfer, and return the magic value
769      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
770      * the transfer is reverted.
771      * @param to The address that will own the minted token
772      * @param tokenId uint256 ID of the token to be minted
773      */
774     function _safeMint(address to, uint256 tokenId) internal {
775         _safeMint(to, tokenId, "");
776     }
777 
778     /**
779      * @dev Internal function to safely mint a new token.
780      * Reverts if the given token ID already exists.
781      * If the target address is a contract, it must implement `onERC721Received`,
782      * which is called upon a safe transfer, and return the magic value
783      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
784      * the transfer is reverted.
785      * @param to The address that will own the minted token
786      * @param tokenId uint256 ID of the token to be minted
787      * @param _data bytes data to send along with a safe transfer check
788      */
789     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
790         _mint(to, tokenId);
791         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
792     }
793 
794     /**
795      * @dev Internal function to mint a new token.
796      * Reverts if the given token ID already exists.
797      * @param to The address that will own the minted token
798      * @param tokenId uint256 ID of the token to be minted
799      */
800     function _mint(address to, uint256 tokenId) internal {
801         require(to != address(0), "ERC721: mint to the zero address");
802         require(!_exists(tokenId), "ERC721: token already minted");
803 
804         _tokenOwner[tokenId] = to;
805         _ownedTokensCount[to].increment();
806 
807         emit Transfer(address(0), to, tokenId);
808     }
809 
810     /**
811      * @dev Internal function to burn a specific token.
812      * Reverts if the token does not exist.
813      * Deprecated, use {_burn} instead.
814      * @param owner owner of the token to burn
815      * @param tokenId uint256 ID of the token being burned
816      */
817     function _burn(address owner, uint256 tokenId) internal {
818         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
819 
820         _clearApproval(tokenId);
821 
822         _ownedTokensCount[owner].decrement();
823         _tokenOwner[tokenId] = address(0);
824 
825         emit Transfer(owner, address(0), tokenId);
826     }
827 
828     /**
829      * @dev Internal function to burn a specific token.
830      * Reverts if the token does not exist.
831      * @param tokenId uint256 ID of the token being burned
832      */
833     function _burn(uint256 tokenId) internal {
834         _burn(ownerOf(tokenId), tokenId);
835     }
836 
837     /**
838      * @dev Internal function to transfer ownership of a given token ID to another address.
839      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
840      * @param from current owner of the token
841      * @param to address to receive the ownership of the given token ID
842      * @param tokenId uint256 ID of the token to be transferred
843      */
844     function _transferFrom(address from, address to, uint256 tokenId) internal {
845         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
846         require(to != address(0), "ERC721: transfer to the zero address");
847 
848         _clearApproval(tokenId);
849 
850         _ownedTokensCount[from].decrement();
851         _ownedTokensCount[to].increment();
852 
853         _tokenOwner[tokenId] = to;
854 
855         emit Transfer(from, to, tokenId);
856     }
857 
858     /**
859      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
860      * The call is not executed if the target address is not a contract.
861      *
862      * This is an internal detail of the `ERC721` contract and its use is deprecated.
863      * @param from address representing the previous owner of the given token ID
864      * @param to target address that will receive the tokens
865      * @param tokenId uint256 ID of the token to be transferred
866      * @param _data bytes optional data to send along with the call
867      * @return bool whether the call correctly returned the expected magic value
868      */
869     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
870     internal returns (bool)
871     {
872         if (!to.isContract()) {
873             return true;
874         }
875         // solhint-disable-next-line avoid-low-level-calls
876         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
877                 IERC721Receiver(to).onERC721Received.selector,
878                 _msgSender(),
879                 from,
880                 tokenId,
881                 _data
882             ));
883         if (!success) {
884             if (returndata.length > 0) {
885                 // solhint-disable-next-line no-inline-assembly
886                 assembly {
887                     let returndata_size := mload(returndata)
888                     revert(add(32, returndata), returndata_size)
889                 }
890             } else {
891                 revert("ERC721: transfer to non ERC721Receiver implementer");
892             }
893         } else {
894             bytes4 retval = abi.decode(returndata, (bytes4));
895             return (retval == _ERC721_RECEIVED);
896         }
897     }
898 
899     /**
900      * @dev Private function to clear current approval of a given token ID.
901      * @param tokenId uint256 ID of the token to be transferred
902      */
903     function _clearApproval(uint256 tokenId) private {
904         if (_tokenApprovals[tokenId] != address(0)) {
905             _tokenApprovals[tokenId] = address(0);
906         }
907     }
908 }
909 
910 // Part: HasContractURI
911 
912 contract HasContractURI is ERC165 {
913 
914     string public contractURI;
915 
916     /*
917      * bytes4(keccak256('contractURI()')) == 0xe8a3d485
918      */
919     bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;
920 
921     constructor(string memory _contractURI) public {
922         contractURI = _contractURI;
923         _registerInterface(_INTERFACE_ID_CONTRACT_URI);
924     }
925 
926     /**
927      * @dev Internal function to set the contract URI
928      * @param _contractURI string URI prefix to assign
929      */
930     function _setContractURI(string memory _contractURI) internal {
931         contractURI = _contractURI;
932     }
933 }
934 
935 // Part: HasSecondarySaleFees
936 
937 contract HasSecondarySaleFees is ERC165 {
938 
939     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
940 
941     /*
942      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
943      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
944      *
945      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
946      */
947     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
948 
949     constructor() public {
950         _registerInterface(_INTERFACE_ID_FEES);
951     }
952 
953     function getFeeRecipients(uint256 id) public view returns (address payable[] memory);
954     function getFeeBps(uint256 id) public view returns (uint[] memory);
955 }
956 
957 // Part: IERC721Enumerable
958 
959 /**
960  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
961  * @dev See https://eips.ethereum.org/EIPS/eip-721
962  */
963 contract IERC721Enumerable is IERC721 {
964     function totalSupply() public view returns (uint256);
965     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
966 
967     function tokenByIndex(uint256 index) public view returns (uint256);
968 }
969 
970 // Part: IERC721Metadata
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
982 // Part: StringLibrary
983 
984 library StringLibrary {
985     using UintLibrary for uint256;
986 
987     function append(string memory _a, string memory _b) internal pure returns (string memory) {
988         bytes memory _ba = bytes(_a);
989         bytes memory _bb = bytes(_b);
990         bytes memory bab = new bytes(_ba.length + _bb.length);
991         uint k = 0;
992         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
993         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
994         return string(bab);
995     }
996 
997     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
998         bytes memory _ba = bytes(_a);
999         bytes memory _bb = bytes(_b);
1000         bytes memory _bc = bytes(_c);
1001         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
1002         uint k = 0;
1003         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
1004         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
1005         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
1006         return string(bbb);
1007     }
1008 
1009     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1010         bytes memory msgBytes = bytes(message);
1011         bytes memory fullMessage = concat(
1012             bytes("\x19Ethereum Signed Message:\n"),
1013             bytes(msgBytes.length.toString()),
1014             msgBytes,
1015             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
1016         );
1017         return ecrecover(keccak256(fullMessage), v, r, s);
1018     }
1019 
1020     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
1021         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
1022         uint k = 0;
1023         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
1024         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
1025         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
1026         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
1027         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
1028         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
1029         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
1030         return resultBytes;
1031     }
1032 }
1033 
1034 // Part: ERC721Burnable
1035 
1036 /**
1037  * @title ERC721 Burnable Token
1038  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1039  */
1040 contract ERC721Burnable is Context, ERC721 {
1041     /**
1042      * @dev Burns a specific ERC721 token.
1043      * @param tokenId uint256 id of the ERC721 token to be burned.
1044      */
1045     function burn(uint256 tokenId) public {
1046         //solhint-disable-next-line max-line-length
1047         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1048         _burn(tokenId);
1049     }
1050 }
1051 
1052 // Part: ERC721Enumerable
1053 
1054 /**
1055  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
1056  * @dev See https://eips.ethereum.org/EIPS/eip-721
1057  */
1058 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
1059     // Mapping from owner to list of owned token IDs
1060     mapping(address => uint256[]) private _ownedTokens;
1061 
1062     // Mapping from token ID to index of the owner tokens list
1063     mapping(uint256 => uint256) private _ownedTokensIndex;
1064 
1065     // Array with all token ids, used for enumeration
1066     uint256[] private _allTokens;
1067 
1068     // Mapping from token id to position in the allTokens array
1069     mapping(uint256 => uint256) private _allTokensIndex;
1070 
1071     /*
1072      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1073      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1074      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1075      *
1076      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1077      */
1078     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1079 
1080     /**
1081      * @dev Constructor function.
1082      */
1083     constructor () public {
1084         // register the supported interface to conform to ERC721Enumerable via ERC165
1085         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1086     }
1087 
1088     /**
1089      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1090      * @param owner address owning the tokens list to be accessed
1091      * @param index uint256 representing the index to be accessed of the requested tokens list
1092      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1093      */
1094     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1095         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1096         return _ownedTokens[owner][index];
1097     }
1098 
1099     /**
1100      * @dev Gets the total amount of tokens stored by the contract.
1101      * @return uint256 representing the total amount of tokens
1102      */
1103     function totalSupply() public view returns (uint256) {
1104         return _allTokens.length;
1105     }
1106 
1107     /**
1108      * @dev Gets the token ID at a given index of all the tokens in this contract
1109      * Reverts if the index is greater or equal to the total number of tokens.
1110      * @param index uint256 representing the index to be accessed of the tokens list
1111      * @return uint256 token ID at the given index of the tokens list
1112      */
1113     function tokenByIndex(uint256 index) public view returns (uint256) {
1114         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1115         return _allTokens[index];
1116     }
1117 
1118     /**
1119      * @dev Internal function to transfer ownership of a given token ID to another address.
1120      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1121      * @param from current owner of the token
1122      * @param to address to receive the ownership of the given token ID
1123      * @param tokenId uint256 ID of the token to be transferred
1124      */
1125     function _transferFrom(address from, address to, uint256 tokenId) internal {
1126         super._transferFrom(from, to, tokenId);
1127 
1128         _removeTokenFromOwnerEnumeration(from, tokenId);
1129 
1130         _addTokenToOwnerEnumeration(to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Internal function to mint a new token.
1135      * Reverts if the given token ID already exists.
1136      * @param to address the beneficiary that will own the minted token
1137      * @param tokenId uint256 ID of the token to be minted
1138      */
1139     function _mint(address to, uint256 tokenId) internal {
1140         super._mint(to, tokenId);
1141 
1142         _addTokenToOwnerEnumeration(to, tokenId);
1143 
1144         _addTokenToAllTokensEnumeration(tokenId);
1145     }
1146 
1147     /**
1148      * @dev Internal function to burn a specific token.
1149      * Reverts if the token does not exist.
1150      * Deprecated, use {ERC721-_burn} instead.
1151      * @param owner owner of the token to burn
1152      * @param tokenId uint256 ID of the token being burned
1153      */
1154     function _burn(address owner, uint256 tokenId) internal {
1155         super._burn(owner, tokenId);
1156 
1157         _removeTokenFromOwnerEnumeration(owner, tokenId);
1158         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1159         _ownedTokensIndex[tokenId] = 0;
1160 
1161         _removeTokenFromAllTokensEnumeration(tokenId);
1162     }
1163 
1164     /**
1165      * @dev Gets the list of token IDs of the requested owner.
1166      * @param owner address owning the tokens
1167      * @return uint256[] List of token IDs owned by the requested address
1168      */
1169     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1170         return _ownedTokens[owner];
1171     }
1172 
1173     /**
1174      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1175      * @param to address representing the new owner of the given token ID
1176      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1177      */
1178     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1179         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1180         _ownedTokens[to].push(tokenId);
1181     }
1182 
1183     /**
1184      * @dev Private function to add a token to this extension's token tracking data structures.
1185      * @param tokenId uint256 ID of the token to be added to the tokens list
1186      */
1187     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1188         _allTokensIndex[tokenId] = _allTokens.length;
1189         _allTokens.push(tokenId);
1190     }
1191 
1192     /**
1193      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1194      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1195      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1196      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1197      * @param from address representing the previous owner of the given token ID
1198      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1199      */
1200     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1201         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1202         // then delete the last slot (swap and pop).
1203 
1204         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1205         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1206 
1207         // When the token to delete is the last token, the swap operation is unnecessary
1208         if (tokenIndex != lastTokenIndex) {
1209             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1210 
1211             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1212             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1213         }
1214 
1215         // This also deletes the contents at the last position of the array
1216         _ownedTokens[from].length--;
1217 
1218         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1219         // lastTokenId, or just over the end of the array if the token was the last one).
1220     }
1221 
1222     /**
1223      * @dev Private function to remove a token from this extension's token tracking data structures.
1224      * This has O(1) time complexity, but alters the order of the _allTokens array.
1225      * @param tokenId uint256 ID of the token to be removed from the tokens list
1226      */
1227     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1228         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1229         // then delete the last slot (swap and pop).
1230 
1231         uint256 lastTokenIndex = _allTokens.length.sub(1);
1232         uint256 tokenIndex = _allTokensIndex[tokenId];
1233 
1234         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1235         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1236         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1237         uint256 lastTokenId = _allTokens[lastTokenIndex];
1238 
1239         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1240         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1241 
1242         // This also deletes the contents at the last position of the array
1243         _allTokens.length--;
1244         _allTokensIndex[tokenId] = 0;
1245     }
1246 }
1247 
1248 // Part: HasTokenURI
1249 
1250 contract HasTokenURI {
1251     using StringLibrary for string;
1252 
1253     //Token URI prefix
1254     string public tokenURIPrefix;
1255 
1256     // Optional mapping for token URIs
1257     mapping(uint256 => string) private _tokenURIs;
1258 
1259     constructor(string memory _tokenURIPrefix) public {
1260         tokenURIPrefix = _tokenURIPrefix;
1261     }
1262 
1263     /**
1264      * @dev Returns an URI for a given token ID.
1265      * Throws if the token ID does not exist. May return an empty string.
1266      * @param tokenId uint256 ID of the token to query
1267      */
1268     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
1269         return tokenURIPrefix.append(_tokenURIs[tokenId]);
1270     }
1271 
1272     /**
1273      * @dev Internal function to set the token URI for a given token.
1274      * Reverts if the token ID does not exist.
1275      * @param tokenId uint256 ID of the token to set its URI
1276      * @param uri string URI to assign
1277      */
1278     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1279         _tokenURIs[tokenId] = uri;
1280     }
1281 
1282     /**
1283      * @dev Internal function to set the token URI prefix.
1284      * @param _tokenURIPrefix string URI prefix to assign
1285      */
1286     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
1287         tokenURIPrefix = _tokenURIPrefix;
1288     }
1289 
1290     function _clearTokenURI(uint256 tokenId) internal {
1291         if (bytes(_tokenURIs[tokenId]).length != 0) {
1292             delete _tokenURIs[tokenId];
1293         }
1294     }
1295 }
1296 
1297 // Part: ERC721Base
1298 
1299 /**
1300  * @title Full ERC721 Token with support for tokenURIPrefix
1301  * This implementation includes all the required and some optional functionality of the ERC721 standard
1302  * Moreover, it includes approve all functionality using operator terminology
1303  * @dev see https://eips.ethereum.org/EIPS/eip-721
1304  */
1305 contract ERC721Base is HasSecondarySaleFees, ERC721, HasContractURI, HasTokenURI, ERC721Enumerable {
1306     // Token name
1307     string public name;
1308 
1309     // Token symbol
1310     string public symbol;
1311 
1312     /**
1313         @notice Describes a fee.
1314         @param recipient - Fee recipient address.
1315         @param value - Fee amount in percents * 100.
1316     */
1317     struct Fee {
1318         address payable recipient;
1319         uint256 value;
1320     }
1321 
1322     // id => fees
1323     mapping (uint256 => Fee[]) public fees;
1324 
1325     /*
1326      *     bytes4(keccak256('name()')) == 0x06fdde03
1327      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1328      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1329      *
1330      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1331      */
1332     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1333 
1334     /**
1335      * @dev Constructor function
1336      */
1337     constructor (string memory _name, string memory _symbol, string memory contractURI, string memory _tokenURIPrefix) HasContractURI(contractURI) HasTokenURI(_tokenURIPrefix) public {
1338         name = _name;
1339         symbol = _symbol;
1340 
1341         // register the supported interfaces to conform to ERC721 via ERC165
1342         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1343     }
1344 
1345     /**
1346         @notice     Get the secondary fee recipients of the token.
1347         @param id - The id of the token.
1348         @return     An array of fee recipient addresses.
1349     */
1350     function getFeeRecipients(uint256 id) public view returns (address payable[] memory) {
1351         Fee[] memory _fees = fees[id];
1352         address payable[] memory result = new address payable[](_fees.length);
1353         for (uint i = 0; i < _fees.length; i++) {
1354             result[i] = _fees[i].recipient;
1355         }
1356         return result;
1357     }
1358 
1359     /**
1360         @notice     Get the secondary fee amounts of the token.
1361         @param id - The id of the token.
1362         @return     An array of fee amount values.
1363     */
1364     function getFeeBps(uint256 id) public view returns (uint[] memory) {
1365         Fee[] memory _fees = fees[id];
1366         uint[] memory result = new uint[](_fees.length);
1367         for (uint i = 0; i < _fees.length; i++) {
1368             result[i] = _fees[i].value;
1369         }
1370         return result;
1371     }
1372 
1373     function _mint(address to, uint256 tokenId, Fee[] memory _fees) internal {
1374         _mint(to, tokenId);
1375         address[] memory recipients = new address[](_fees.length);
1376         uint[] memory bps = new uint[](_fees.length);
1377         for (uint i = 0; i < _fees.length; i++) {
1378             require(_fees[i].recipient != address(0x0), "Recipient should be present");
1379             require(_fees[i].value != 0, "Fee value should be positive");
1380             fees[tokenId].push(_fees[i]);
1381             recipients[i] = _fees[i].recipient;
1382             bps[i] = _fees[i].value;
1383         }
1384         if (_fees.length > 0) {
1385             emit SecondarySaleFees(tokenId, recipients, bps);
1386         }
1387     }
1388 
1389     /**
1390      * @dev Returns an URI for a given token ID.
1391      * Throws if the token ID does not exist. May return an empty string.
1392      * @param tokenId uint256 ID of the token to query
1393      */
1394     function tokenURI(uint256 tokenId) external view returns (string memory) {
1395         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1396         return super._tokenURI(tokenId);
1397     }
1398 
1399     /**
1400      * @dev Internal function to set the token URI for a given token.
1401      * Reverts if the token ID does not exist.
1402      * @param tokenId uint256 ID of the token to set its URI
1403      * @param uri string URI to assign
1404      */
1405     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1406         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1407         super._setTokenURI(tokenId, uri);
1408     }
1409 
1410     /**
1411      * @dev Internal function to burn a specific token.
1412      * Reverts if the token does not exist.
1413      * Deprecated, use _burn(uint256) instead.
1414      * @param owner owner of the token to burn
1415      * @param tokenId uint256 ID of the token being burned by the msg.sender
1416      */
1417     function _burn(address owner, uint256 tokenId) internal {
1418         super._burn(owner, tokenId);
1419         _clearTokenURI(tokenId);
1420     }
1421 }
1422 
1423 // Part: MintableOwnableToken
1424 
1425 /**
1426  * @title MintableOwnableToken
1427  * @dev anyone can mint token.
1428  */
1429 contract MintableOwnableToken is Ownable, ERC721, IERC721Metadata, ERC721Burnable, ERC721Base, SignerRole {
1430 
1431     /// @notice Token minting event.
1432     event CreateERC721_v4(address indexed creator, string name, string symbol);
1433 
1434     /// @notice The contract constructor.
1435     /// @param name - The value for the `name`.
1436     /// @param symbol - The value for the `symbol`.
1437     /// @param contractURI - The URI with contract metadata.
1438     ///        The metadata should be a JSON object with fields: `id, name, description, image, external_link`.
1439     ///        If the URI containts `{address}` template in its body, then the template must be substituted with the contract address.
1440     /// @param tokenURIPrefix - The URI prefix for all the tokens. Usually set to ipfs gateway.
1441     /// @param signer - The address of the initial signer.
1442     constructor (string memory name, string memory symbol, string memory contractURI, string memory tokenURIPrefix, address signer) public ERC721Base(name, symbol, contractURI, tokenURIPrefix) {
1443         emit CreateERC721_v4(msg.sender, name, symbol);
1444         _addSigner(signer);
1445         _registerInterface(bytes4(keccak256('MINT_WITH_ADDRESS')));
1446     }
1447 
1448     /// @notice The function for token minting. It creates a new token.
1449     ///         Must contain the signature of the format: `sha3(tokenContract.address.toLowerCase() + tokenId)`.
1450     ///         Where `tokenContract.address` is the address of the contract and tokenId is the id in uint256 hex format.
1451     ///         0 as uint256 must look like this: `0000000000000000000000000000000000000000000000000000000000000000`.
1452     ///         The message **must not contain** the standard prefix.
1453     /// @param tokenId - The id of a new token.
1454     /// @param v - v parameter of the ECDSA signature.
1455     /// @param r - r parameter of the ECDSA signature.
1456     /// @param s - s parameter of the ECDSA signature.
1457     /// @param _fees - An array of the secondary fees for this token.
1458     /// @param tokenURI - The suffix with `tokenURIPrefix` usually complements ipfs link to metadata object.
1459     ///        The URI must link to JSON object with various fields: `name, description, image, external_url, attributes`.
1460     ///        Can also contain another various fields.
1461     function mint(uint256 tokenId, uint8 v, bytes32 r, bytes32 s, Fee[] memory _fees, string memory tokenURI) public {
1462         require(isSigner(ecrecover(keccak256(abi.encodePacked(this, tokenId)), v, r, s)), "signer should sign tokenId");
1463         _mint(msg.sender, tokenId, _fees);
1464         _setTokenURI(tokenId, tokenURI);
1465     }
1466 
1467     /// @notice This function can be called by the contract owner and it adds an address as a new signer.
1468     ///         The signer will authorize token minting by signing token ids.
1469     /// @param account - The address of a new signer.
1470     function addSigner(address account) public onlyOwner {
1471         _addSigner(account);
1472     }
1473 
1474     /// @notice This function can be called by the contract owner and it removes an address from signers pool.
1475     /// @param account - The address of a signer to remove.
1476     function removeSigner(address account) public onlyOwner {
1477         _removeSigner(account);
1478     }
1479 
1480 
1481     /// @notice Sets the URI prefix for all tokens.
1482     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
1483         _setTokenURIPrefix(tokenURIPrefix);
1484     }
1485 
1486 
1487     /// @notice Sets the URI for the contract metadata.
1488     function setContractURI(string memory contractURI) public onlyOwner {
1489         _setContractURI(contractURI);
1490     }
1491 }
1492 
1493 // File: MintableUserToken.sol
1494 
1495 /**
1496  * @title MintableUserToken
1497  * @dev Only owner can mint tokens.
1498  */
1499 contract MintableUserToken is MintableOwnableToken {
1500     /// @notice The contract constructor.
1501     /// @param name - The value for the `name`.
1502     /// @param symbol - The value for the `symbol`.
1503     /// @param contractURI - The URI with contract metadata.
1504     ///        The metadata should be a JSON object with fields: `id, name, description, image, external_link`.
1505     ///        If the URI containts `{address}` template in its body, then the template must be substituted with the contract address.
1506     /// @param tokenURIPrefix - The URI prefix for all the tokens. Usually set to ipfs gateway.
1507     /// @param signer - The address of the initial signer.
1508     constructor(string memory name, string memory symbol, string memory contractURI, string memory tokenURIPrefix, address signer) MintableOwnableToken(name, symbol, contractURI, tokenURIPrefix, signer) public {}
1509 
1510     /// @notice The function for token minting. It creates a new token. Can be called only by the contract owner.
1511     ///         Must contain the signature of the format: `sha3(tokenContract.address.toLowerCase() + tokenId)`.
1512     ///         Where `tokenContract.address` is the address of the contract and tokenId is the id in uint256 hex format.
1513     ///         0 as uint256 must look like this: `0000000000000000000000000000000000000000000000000000000000000000`.
1514     ///         The message **must not contain** the standard prefix.
1515     /// @param tokenId - The id of a new token.
1516     /// @param v - v parameter of the ECDSA signature.
1517     /// @param r - r parameter of the ECDSA signature.
1518     /// @param s - s parameter of the ECDSA signature.
1519     /// @param _fees - An array of the secondary fees for this token.
1520     /// @param tokenURI - The suffix with `tokenURIPrefix` usually complements ipfs link to metadata object.
1521     ///        The URI must link to JSON object with various fields: `name, description, image, external_url, attributes`.
1522     ///        Can also contain another various fields.
1523     function mint(uint256 tokenId, uint8 v, bytes32 r, bytes32 s, Fee[] memory _fees, string memory tokenURI)  public {
1524         super.mint(tokenId, v, r, s, _fees, tokenURI);
1525     }
1526 }
