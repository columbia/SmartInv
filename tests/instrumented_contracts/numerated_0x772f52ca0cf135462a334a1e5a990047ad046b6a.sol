1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Contract module which provides a basic access control mechanism, where
5  * there is an account (an owner) that can be granted exclusive access to
6  * specific functions.
7  *
8  * This module is used through inheritance. It will make available the modifier
9  * `onlyOwner`, which can be aplied to your functions to restrict their use to
10  * the owner.
11  */
12 contract Ownable {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev Initializes the contract setting the deployer as the initial owner.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @dev Returns the address of the current owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     /**
41      * @dev Returns true if the caller is the current owner.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Leaves the contract without owner. It will not be possible to call
49      * `onlyOwner` functions anymore. Can only be called by the current owner.
50      *
51      * > Note: Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 /**
78  * @title Roles
79  * @dev Library for managing addresses assigned to a Role.
80  */
81 library Roles {
82     struct Role {
83         mapping (address => bool) bearer;
84     }
85 
86     /**
87      * @dev Give an account access to this role.
88      */
89     function add(Role storage role, address account) internal {
90         require(!has(role, account), "Roles: account already has role");
91         role.bearer[account] = true;
92     }
93 
94     /**
95      * @dev Remove an account's access to this role.
96      */
97     function remove(Role storage role, address account) internal {
98         require(has(role, account), "Roles: account does not have role");
99         role.bearer[account] = false;
100     }
101 
102     /**
103      * @dev Check if an account has this role.
104      * @return bool
105      */
106     function has(Role storage role, address account) internal view returns (bool) {
107         require(account != address(0), "Roles: account is the zero address");
108         return role.bearer[account];
109     }
110 }
111 
112 contract SignerRole {
113     using Roles for Roles.Role;
114 
115     event SignerAdded(address indexed account);
116     event SignerRemoved(address indexed account);
117 
118     Roles.Role private _signers;
119 
120     constructor () internal {
121         _addSigner(msg.sender);
122     }
123 
124     modifier onlySigner() {
125         require(isSigner(msg.sender), "SignerRole: caller does not have the Signer role");
126         _;
127     }
128 
129     function isSigner(address account) public view returns (bool) {
130         return _signers.has(account);
131     }
132 
133     function addSigner(address account) public onlySigner {
134         _addSigner(account);
135     }
136 
137     function renounceSigner() public {
138         _removeSigner(msg.sender);
139     }
140 
141     function _addSigner(address account) internal {
142         _signers.add(account);
143         emit SignerAdded(account);
144     }
145 
146     function _removeSigner(address account) internal {
147         _signers.remove(account);
148         emit SignerRemoved(account);
149     }
150 }
151 
152 /**
153  * @dev Interface of the ERC165 standard, as defined in the
154  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
155  *
156  * Implementers can declare support of contract interfaces, which can then be
157  * queried by others (`ERC165Checker`).
158  *
159  * For an implementation, see `ERC165`.
160  */
161 interface IERC165 {
162     /**
163      * @dev Returns true if this contract implements the interface defined by
164      * `interfaceId`. See the corresponding
165      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
166      * to learn more about how these ids are created.
167      *
168      * This function call must use less than 30 000 gas.
169      */
170     function supportsInterface(bytes4 interfaceId) external view returns (bool);
171 }
172 
173 /**
174  * @dev Required interface of an ERC721 compliant contract.
175  */
176 contract IERC721 is IERC165 {
177     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
178     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
179     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
180 
181     /**
182      * @dev Returns the number of NFTs in `owner`'s account.
183      */
184     function balanceOf(address owner) public view returns (uint256 balance);
185 
186     /**
187      * @dev Returns the owner of the NFT specified by `tokenId`.
188      */
189     function ownerOf(uint256 tokenId) public view returns (address owner);
190 
191     /**
192      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
193      * another (`to`).
194      *
195      * 
196      *
197      * Requirements:
198      * - `from`, `to` cannot be zero.
199      * - `tokenId` must be owned by `from`.
200      * - If the caller is not `from`, it must be have been allowed to move this
201      * NFT by either `approve` or `setApproveForAll`.
202      */
203     function safeTransferFrom(address from, address to, uint256 tokenId) public;
204     /**
205      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
206      * another (`to`).
207      *
208      * Requirements:
209      * - If the caller is not `from`, it must be approved to move this NFT by
210      * either `approve` or `setApproveForAll`.
211      */
212     function transferFrom(address from, address to, uint256 tokenId) public;
213     function approve(address to, uint256 tokenId) public;
214     function getApproved(uint256 tokenId) public view returns (address operator);
215 
216     function setApprovalForAll(address operator, bool _approved) public;
217     function isApprovedForAll(address owner, address operator) public view returns (bool);
218 
219 
220     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
221 }
222 
223 /**
224  * @title ERC721 token receiver interface
225  * @dev Interface for any contract that wants to support safeTransfers
226  * from ERC721 asset contracts.
227  */
228 contract IERC721Receiver {
229     /**
230      * @notice Handle the receipt of an NFT
231      * @dev The ERC721 smart contract calls this function on the recipient
232      * after a `safeTransfer`. This function MUST return the function selector,
233      * otherwise the caller will revert the transaction. The selector to be
234      * returned can be obtained as `this.onERC721Received.selector`. This
235      * function MAY throw to revert and reject the transfer.
236      * Note: the ERC721 contract address is always the message sender.
237      * @param operator The address which called `safeTransferFrom` function
238      * @param from The address which previously owned the token
239      * @param tokenId The NFT identifier which is being transferred
240      * @param data Additional data with no specified format
241      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
242      */
243     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
244     public returns (bytes4);
245 }
246 
247 /**
248  * @dev Wrappers over Solidity's arithmetic operations with added overflow
249  * checks.
250  *
251  * Arithmetic operations in Solidity wrap on overflow. This can easily result
252  * in bugs, because programmers usually assume that an overflow raises an
253  * error, which is the standard behavior in high level programming languages.
254  * `SafeMath` restores this intuition by reverting the transaction when an
255  * operation overflows.
256  *
257  * Using this library instead of the unchecked operations eliminates an entire
258  * class of bugs, so it's recommended to use it always.
259  */
260 library SafeMath {
261     /**
262      * @dev Returns the addition of two unsigned integers, reverting on
263      * overflow.
264      *
265      * Counterpart to Solidity's `+` operator.
266      *
267      * Requirements:
268      * - Addition cannot overflow.
269      */
270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
271         uint256 c = a + b;
272         require(c >= a, "SafeMath: addition overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the subtraction of two unsigned integers, reverting on
279      * overflow (when the result is negative).
280      *
281      * Counterpart to Solidity's `-` operator.
282      *
283      * Requirements:
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         require(b <= a, "SafeMath: subtraction overflow");
288         uint256 c = a - b;
289 
290         return c;
291     }
292 
293     /**
294      * @dev Returns the multiplication of two unsigned integers, reverting on
295      * overflow.
296      *
297      * Counterpart to Solidity's `*` operator.
298      *
299      * Requirements:
300      * - Multiplication cannot overflow.
301      */
302     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
303         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
304         // benefit is lost if 'b' is also tested.
305         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
306         if (a == 0) {
307             return 0;
308         }
309 
310         uint256 c = a * b;
311         require(c / a == b, "SafeMath: multiplication overflow");
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the integer division of two unsigned integers. Reverts on
318      * division by zero. The result is rounded towards zero.
319      *
320      * Counterpart to Solidity's `/` operator. Note: this function uses a
321      * `revert` opcode (which leaves remaining gas untouched) while Solidity
322      * uses an invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      */
327     function div(uint256 a, uint256 b) internal pure returns (uint256) {
328         // Solidity only automatically asserts when dividing by 0
329         require(b > 0, "SafeMath: division by zero");
330         uint256 c = a / b;
331         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      * - The divisor cannot be zero.
346      */
347     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
348         require(b != 0, "SafeMath: modulo by zero");
349         return a % b;
350     }
351 }
352 
353 /**
354  * @dev Collection of functions related to the address type,
355  */
356 library Address {
357     /**
358      * @dev Returns true if `account` is a contract.
359      *
360      * This test is non-exhaustive, and there may be false-negatives: during the
361      * execution of a contract's constructor, its address will be reported as
362      * not containing a contract.
363      *
364      * > It is unsafe to assume that an address for which this function returns
365      * false is an externally-owned account (EOA) and not a contract.
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies in extcodesize, which returns 0 for contracts in
369         // construction, since the code is only stored at the end of the
370         // constructor execution.
371 
372         uint256 size;
373         // solhint-disable-next-line no-inline-assembly
374         assembly { size := extcodesize(account) }
375         return size > 0;
376     }
377 }
378 
379 /**
380  * @title Counters
381  * @author Matt Condon (@shrugs)
382  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
383  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
384  *
385  * Include with `using Counters for Counters.Counter;`
386  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
387  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
388  * directly accessed.
389  */
390 library Counters {
391     using SafeMath for uint256;
392 
393     struct Counter {
394         // This variable should never be directly accessed by users of the library: interactions must be restricted to
395         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
396         // this feature: see https://github.com/ethereum/solidity/issues/4637
397         uint256 _value; // default: 0
398     }
399 
400     function current(Counter storage counter) internal view returns (uint256) {
401         return counter._value;
402     }
403 
404     function increment(Counter storage counter) internal {
405         counter._value += 1;
406     }
407 
408     function decrement(Counter storage counter) internal {
409         counter._value = counter._value.sub(1);
410     }
411 }
412 
413 /**
414  * @dev Implementation of the `IERC165` interface.
415  *
416  * Contracts may inherit from this and call `_registerInterface` to declare
417  * their support of an interface.
418  */
419 contract ERC165 is IERC165 {
420     /*
421      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
422      */
423     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
424 
425     /**
426      * @dev Mapping of interface ids to whether or not it's supported.
427      */
428     mapping(bytes4 => bool) private _supportedInterfaces;
429 
430     constructor () internal {
431         // Derived contracts need only register support for their own interfaces,
432         // we register support for ERC165 itself here
433         _registerInterface(_INTERFACE_ID_ERC165);
434     }
435 
436     /**
437      * @dev See `IERC165.supportsInterface`.
438      *
439      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
442         return _supportedInterfaces[interfaceId];
443     }
444 
445     /**
446      * @dev Registers the contract as an implementer of the interface defined by
447      * `interfaceId`. Support of the actual ERC165 interface is automatic and
448      * registering its interface id is not required.
449      *
450      * See `IERC165.supportsInterface`.
451      *
452      * Requirements:
453      *
454      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
455      */
456     function _registerInterface(bytes4 interfaceId) internal {
457         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
458         _supportedInterfaces[interfaceId] = true;
459     }
460 }
461 
462 /**
463  * @title ERC721 Non-Fungible Token Standard basic implementation
464  * @dev see https://eips.ethereum.org/EIPS/eip-721
465  */
466 contract ERC721 is ERC165, IERC721 {
467     using SafeMath for uint256;
468     using Address for address;
469     using Counters for Counters.Counter;
470 
471     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
472     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
473     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
474 
475     // Mapping from token ID to owner
476     mapping (uint256 => address) private _tokenOwner;
477 
478     // Mapping from token ID to approved address
479     mapping (uint256 => address) private _tokenApprovals;
480 
481     // Mapping from owner to number of owned token
482     mapping (address => Counters.Counter) private _ownedTokensCount;
483 
484     // Mapping from owner to operator approvals
485     mapping (address => mapping (address => bool)) private _operatorApprovals;
486 
487     /*
488      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
489      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
490      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
491      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
492      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
493      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
494      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
495      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
496      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
497      *
498      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
499      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
500      */
501     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
502 
503     constructor () public {
504         // register the supported interfaces to conform to ERC721 via ERC165
505         _registerInterface(_INTERFACE_ID_ERC721);
506     }
507 
508     /**
509      * @dev Gets the balance of the specified address.
510      * @param owner address to query the balance of
511      * @return uint256 representing the amount owned by the passed address
512      */
513     function balanceOf(address owner) public view returns (uint256) {
514         require(owner != address(0), "ERC721: balance query for the zero address");
515 
516         return _ownedTokensCount[owner].current();
517     }
518 
519     /**
520      * @dev Gets the owner of the specified token ID.
521      * @param tokenId uint256 ID of the token to query the owner of
522      * @return address currently marked as the owner of the given token ID
523      */
524     function ownerOf(uint256 tokenId) public view returns (address) {
525         address owner = _tokenOwner[tokenId];
526         require(owner != address(0), "ERC721: owner query for nonexistent token");
527 
528         return owner;
529     }
530 
531     /**
532      * @dev Approves another address to transfer the given token ID
533      * The zero address indicates there is no approved address.
534      * There can only be one approved address per token at a given time.
535      * Can only be called by the token owner or an approved operator.
536      * @param to address to be approved for the given token ID
537      * @param tokenId uint256 ID of the token to be approved
538      */
539     function approve(address to, uint256 tokenId) public {
540         address owner = ownerOf(tokenId);
541         require(to != owner, "ERC721: approval to current owner");
542 
543         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
544             "ERC721: approve caller is not owner nor approved for all"
545         );
546 
547         _tokenApprovals[tokenId] = to;
548         emit Approval(owner, to, tokenId);
549     }
550 
551     /**
552      * @dev Gets the approved address for a token ID, or zero if no address set
553      * Reverts if the token ID does not exist.
554      * @param tokenId uint256 ID of the token to query the approval of
555      * @return address currently approved for the given token ID
556      */
557     function getApproved(uint256 tokenId) public view returns (address) {
558         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
559 
560         return _tokenApprovals[tokenId];
561     }
562 
563     /**
564      * @dev Sets or unsets the approval of a given operator
565      * An operator is allowed to transfer all tokens of the sender on their behalf.
566      * @param to operator address to set the approval
567      * @param approved representing the status of the approval to be set
568      */
569     function setApprovalForAll(address to, bool approved) public {
570         require(to != msg.sender, "ERC721: approve to caller");
571 
572         _operatorApprovals[msg.sender][to] = approved;
573         emit ApprovalForAll(msg.sender, to, approved);
574     }
575 
576     /**
577      * @dev Tells whether an operator is approved by a given owner.
578      * @param owner owner address which you want to query the approval of
579      * @param operator operator address which you want to query the approval of
580      * @return bool whether the given operator is approved by the given owner
581      */
582     function isApprovedForAll(address owner, address operator) public view returns (bool) {
583         return _operatorApprovals[owner][operator];
584     }
585 
586     /**
587      * @dev Transfers the ownership of a given token ID to another address.
588      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
589      * Requires the msg.sender to be the owner, approved, or operator.
590      * @param from current owner of the token
591      * @param to address to receive the ownership of the given token ID
592      * @param tokenId uint256 ID of the token to be transferred
593      */
594     function transferFrom(address from, address to, uint256 tokenId) public {
595         //solhint-disable-next-line max-line-length
596         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
597 
598         _transferFrom(from, to, tokenId);
599     }
600 
601     /**
602      * @dev Safely transfers the ownership of a given token ID to another address
603      * If the target address is a contract, it must implement `onERC721Received`,
604      * which is called upon a safe transfer, and return the magic value
605      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
606      * the transfer is reverted.
607      * Requires the msg.sender to be the owner, approved, or operator
608      * @param from current owner of the token
609      * @param to address to receive the ownership of the given token ID
610      * @param tokenId uint256 ID of the token to be transferred
611      */
612     function safeTransferFrom(address from, address to, uint256 tokenId) public {
613         safeTransferFrom(from, to, tokenId, "");
614     }
615 
616     /**
617      * @dev Safely transfers the ownership of a given token ID to another address
618      * If the target address is a contract, it must implement `onERC721Received`,
619      * which is called upon a safe transfer, and return the magic value
620      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
621      * the transfer is reverted.
622      * Requires the msg.sender to be the owner, approved, or operator
623      * @param from current owner of the token
624      * @param to address to receive the ownership of the given token ID
625      * @param tokenId uint256 ID of the token to be transferred
626      * @param _data bytes data to send along with a safe transfer check
627      */
628     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
629         transferFrom(from, to, tokenId);
630         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
631     }
632 
633     /**
634      * @dev Returns whether the specified token exists.
635      * @param tokenId uint256 ID of the token to query the existence of
636      * @return bool whether the token exists
637      */
638     function _exists(uint256 tokenId) internal view returns (bool) {
639         address owner = _tokenOwner[tokenId];
640         return owner != address(0);
641     }
642 
643     /**
644      * @dev Returns whether the given spender can transfer a given token ID.
645      * @param spender address of the spender to query
646      * @param tokenId uint256 ID of the token to be transferred
647      * @return bool whether the msg.sender is approved for the given token ID,
648      * is an operator of the owner, or is the owner of the token
649      */
650     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
651         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
652         address owner = ownerOf(tokenId);
653         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
654     }
655 
656     /**
657      * @dev Internal function to mint a new token.
658      * Reverts if the given token ID already exists.
659      * @param to The address that will own the minted token
660      * @param tokenId uint256 ID of the token to be minted
661      */
662     function _mint(address to, uint256 tokenId) internal {
663         require(to != address(0), "ERC721: mint to the zero address");
664         require(!_exists(tokenId), "ERC721: token already minted");
665 
666         _tokenOwner[tokenId] = to;
667         _ownedTokensCount[to].increment();
668 
669         emit Transfer(address(0), to, tokenId);
670     }
671 
672     /**
673      * @dev Internal function to burn a specific token.
674      * Reverts if the token does not exist.
675      * Deprecated, use _burn(uint256) instead.
676      * @param owner owner of the token to burn
677      * @param tokenId uint256 ID of the token being burned
678      */
679     function _burn(address owner, uint256 tokenId) internal {
680         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
681 
682         _clearApproval(tokenId);
683 
684         _ownedTokensCount[owner].decrement();
685         _tokenOwner[tokenId] = address(0);
686 
687         emit Transfer(owner, address(0), tokenId);
688     }
689 
690     /**
691      * @dev Internal function to burn a specific token.
692      * Reverts if the token does not exist.
693      * @param tokenId uint256 ID of the token being burned
694      */
695     function _burn(uint256 tokenId) internal {
696         _burn(ownerOf(tokenId), tokenId);
697     }
698 
699     /**
700      * @dev Internal function to transfer ownership of a given token ID to another address.
701      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
702      * @param from current owner of the token
703      * @param to address to receive the ownership of the given token ID
704      * @param tokenId uint256 ID of the token to be transferred
705      */
706     function _transferFrom(address from, address to, uint256 tokenId) internal {
707         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
708         require(to != address(0), "ERC721: transfer to the zero address");
709 
710         _clearApproval(tokenId);
711 
712         _ownedTokensCount[from].decrement();
713         _ownedTokensCount[to].increment();
714 
715         _tokenOwner[tokenId] = to;
716 
717         emit Transfer(from, to, tokenId);
718     }
719 
720     /**
721      * @dev Internal function to invoke `onERC721Received` on a target address.
722      * The call is not executed if the target address is not a contract.
723      *
724      * This function is deprecated.
725      * @param from address representing the previous owner of the given token ID
726      * @param to target address that will receive the tokens
727      * @param tokenId uint256 ID of the token to be transferred
728      * @param _data bytes optional data to send along with the call
729      * @return bool whether the call correctly returned the expected magic value
730      */
731     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
732         internal returns (bool)
733     {
734         if (!to.isContract()) {
735             return true;
736         }
737 
738         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
739         return (retval == _ERC721_RECEIVED);
740     }
741 
742     /**
743      * @dev Private function to clear current approval of a given token ID.
744      * @param tokenId uint256 ID of the token to be transferred
745      */
746     function _clearApproval(uint256 tokenId) private {
747         if (_tokenApprovals[tokenId] != address(0)) {
748             _tokenApprovals[tokenId] = address(0);
749         }
750     }
751 }
752 
753 /**
754  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
755  * @dev See https://eips.ethereum.org/EIPS/eip-721
756  */
757 contract IERC721Metadata is IERC721 {
758     function name() external view returns (string memory);
759     function symbol() external view returns (string memory);
760     function tokenURI(uint256 tokenId) external view returns (string memory);
761 }
762 
763 /**
764  * @title ERC721 Burnable Token
765  * @dev ERC721 Token that can be irreversibly burned (destroyed).
766  */
767 contract ERC721Burnable is ERC721 {
768     /**
769      * @dev Burns a specific ERC721 token.
770      * @param tokenId uint256 id of the ERC721 token to be burned.
771      */
772     function burn(uint256 tokenId) public {
773         //solhint-disable-next-line max-line-length
774         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
775         _burn(tokenId);
776     }
777 }
778 
779 /**
780  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
781  * @dev See https://eips.ethereum.org/EIPS/eip-721
782  */
783 contract IERC721Enumerable is IERC721 {
784     function totalSupply() public view returns (uint256);
785     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
786 
787     function tokenByIndex(uint256 index) public view returns (uint256);
788 }
789 
790 /**
791  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
792  * @dev See https://eips.ethereum.org/EIPS/eip-721
793  */
794 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
795     // Mapping from owner to list of owned token IDs
796     mapping(address => uint256[]) private _ownedTokens;
797 
798     // Mapping from token ID to index of the owner tokens list
799     mapping(uint256 => uint256) private _ownedTokensIndex;
800 
801     // Array with all token ids, used for enumeration
802     uint256[] private _allTokens;
803 
804     // Mapping from token id to position in the allTokens array
805     mapping(uint256 => uint256) private _allTokensIndex;
806 
807     /*
808      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
809      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
810      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
811      *
812      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
813      */
814     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
815 
816     /**
817      * @dev Constructor function.
818      */
819     constructor () public {
820         // register the supported interface to conform to ERC721Enumerable via ERC165
821         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
822     }
823 
824     /**
825      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
826      * @param owner address owning the tokens list to be accessed
827      * @param index uint256 representing the index to be accessed of the requested tokens list
828      * @return uint256 token ID at the given index of the tokens list owned by the requested address
829      */
830     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
831         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
832         return _ownedTokens[owner][index];
833     }
834 
835     /**
836      * @dev Gets the total amount of tokens stored by the contract.
837      * @return uint256 representing the total amount of tokens
838      */
839     function totalSupply() public view returns (uint256) {
840         return _allTokens.length;
841     }
842 
843     /**
844      * @dev Gets the token ID at a given index of all the tokens in this contract
845      * Reverts if the index is greater or equal to the total number of tokens.
846      * @param index uint256 representing the index to be accessed of the tokens list
847      * @return uint256 token ID at the given index of the tokens list
848      */
849     function tokenByIndex(uint256 index) public view returns (uint256) {
850         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
851         return _allTokens[index];
852     }
853 
854     /**
855      * @dev Internal function to transfer ownership of a given token ID to another address.
856      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
857      * @param from current owner of the token
858      * @param to address to receive the ownership of the given token ID
859      * @param tokenId uint256 ID of the token to be transferred
860      */
861     function _transferFrom(address from, address to, uint256 tokenId) internal {
862         super._transferFrom(from, to, tokenId);
863 
864         _removeTokenFromOwnerEnumeration(from, tokenId);
865 
866         _addTokenToOwnerEnumeration(to, tokenId);
867     }
868 
869     /**
870      * @dev Internal function to mint a new token.
871      * Reverts if the given token ID already exists.
872      * @param to address the beneficiary that will own the minted token
873      * @param tokenId uint256 ID of the token to be minted
874      */
875     function _mint(address to, uint256 tokenId) internal {
876         super._mint(to, tokenId);
877 
878         _addTokenToOwnerEnumeration(to, tokenId);
879 
880         _addTokenToAllTokensEnumeration(tokenId);
881     }
882 
883     /**
884      * @dev Internal function to burn a specific token.
885      * Reverts if the token does not exist.
886      * Deprecated, use _burn(uint256) instead.
887      * @param owner owner of the token to burn
888      * @param tokenId uint256 ID of the token being burned
889      */
890     function _burn(address owner, uint256 tokenId) internal {
891         super._burn(owner, tokenId);
892 
893         _removeTokenFromOwnerEnumeration(owner, tokenId);
894         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
895         _ownedTokensIndex[tokenId] = 0;
896 
897         _removeTokenFromAllTokensEnumeration(tokenId);
898     }
899 
900     /**
901      * @dev Gets the list of token IDs of the requested owner.
902      * @param owner address owning the tokens
903      * @return uint256[] List of token IDs owned by the requested address
904      */
905     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
906         return _ownedTokens[owner];
907     }
908 
909     /**
910      * @dev Private function to add a token to this extension's ownership-tracking data structures.
911      * @param to address representing the new owner of the given token ID
912      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
913      */
914     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
915         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
916         _ownedTokens[to].push(tokenId);
917     }
918 
919     /**
920      * @dev Private function to add a token to this extension's token tracking data structures.
921      * @param tokenId uint256 ID of the token to be added to the tokens list
922      */
923     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
924         _allTokensIndex[tokenId] = _allTokens.length;
925         _allTokens.push(tokenId);
926     }
927 
928     /**
929      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
930      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
931      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
932      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
933      * @param from address representing the previous owner of the given token ID
934      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
935      */
936     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
937         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
938         // then delete the last slot (swap and pop).
939 
940         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
941         uint256 tokenIndex = _ownedTokensIndex[tokenId];
942 
943         // When the token to delete is the last token, the swap operation is unnecessary
944         if (tokenIndex != lastTokenIndex) {
945             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
946 
947             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
948             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
949         }
950 
951         // This also deletes the contents at the last position of the array
952         _ownedTokens[from].length--;
953 
954         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
955         // lastTokenId, or just over the end of the array if the token was the last one).
956     }
957 
958     /**
959      * @dev Private function to remove a token from this extension's token tracking data structures.
960      * This has O(1) time complexity, but alters the order of the _allTokens array.
961      * @param tokenId uint256 ID of the token to be removed from the tokens list
962      */
963     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
964         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
965         // then delete the last slot (swap and pop).
966 
967         uint256 lastTokenIndex = _allTokens.length.sub(1);
968         uint256 tokenIndex = _allTokensIndex[tokenId];
969 
970         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
971         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
972         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
973         uint256 lastTokenId = _allTokens[lastTokenIndex];
974 
975         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
976         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
977 
978         // This also deletes the contents at the last position of the array
979         _allTokens.length--;
980         _allTokensIndex[tokenId] = 0;
981     }
982 }
983 
984 /**
985  * @title Full ERC721 Token with support for tokenURIPrefix
986  * This implementation includes all the required and some optional functionality of the ERC721 standard
987  * Moreover, it includes approve all functionality using operator terminology
988  * @dev see https://eips.ethereum.org/EIPS/eip-721
989  */
990 contract ERC721Base is ERC721, ERC721Enumerable {
991     // Token name
992     string public name;
993 
994     // Token symbol
995     string public symbol;
996 
997     //Token URI prefix
998     string public tokenURIPrefix;
999 
1000     //Contract URI prefix
1001     string public contractURIPrefix;
1002 
1003     // Optional mapping for token URIs
1004     mapping(uint256 => string) private _tokenURIs;
1005 
1006     /*
1007      * bytes4(keccak256('contractURI()')) == 0xe8a3d485
1008      */
1009     bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;
1010 
1011     /*
1012      *     bytes4(keccak256('name()')) == 0x06fdde03
1013      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1014      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1015      *
1016      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1017      */
1018     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1019 
1020     /**
1021      * @dev Constructor function
1022      */
1023     constructor (string memory _name, string memory _symbol, string memory _contractURIPrefix, string memory _tokenURIPrefix) public {
1024         name = _name;
1025         symbol = _symbol;
1026         tokenURIPrefix = _tokenURIPrefix;
1027         contractURIPrefix = _contractURIPrefix;
1028 
1029         // register the supported interfaces to conform to ERC721 via ERC165
1030         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1031         _registerInterface(_INTERFACE_ID_CONTRACT_URI);
1032     }
1033 
1034     /**
1035      * @dev Internal function to set the token URI prefix.
1036      * @param _tokenURIPrefix string URI prefix to assign
1037      */
1038     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
1039         tokenURIPrefix = _tokenURIPrefix;
1040     }
1041 
1042     /**
1043      * @dev Returns an URI for a given token ID.
1044      * Throws if the token ID does not exist. May return an empty string.
1045      * @param tokenId uint256 ID of the token to query
1046      */
1047     function tokenURI(uint256 tokenId) external view returns (string memory) {
1048         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1049         return strConcat(tokenURIPrefix, _tokenURIs[tokenId]);
1050     }
1051 
1052     /**
1053      * @dev Internal function to set the token URI for a given token.
1054      * Reverts if the token ID does not exist.
1055      * @param tokenId uint256 ID of the token to set its URI
1056      * @param uri string URI to assign
1057      */
1058     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1059         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1060         _tokenURIs[tokenId] = uri;
1061     }
1062 
1063     /**
1064      * @dev Internal function to burn a specific token.
1065      * Reverts if the token does not exist.
1066      * Deprecated, use _burn(uint256) instead.
1067      * @param owner owner of the token to burn
1068      * @param tokenId uint256 ID of the token being burned by the msg.sender
1069      */
1070     function _burn(address owner, uint256 tokenId) internal {
1071         super._burn(owner, tokenId);
1072 
1073         // Clear metadata (if any)
1074         if (bytes(_tokenURIs[tokenId]).length != 0) {
1075             delete _tokenURIs[tokenId];
1076         }
1077     }
1078 
1079     function contractURI() public view returns (string memory) {
1080         return strConcat(contractURIPrefix, toString(address(this)));
1081     }
1082 
1083     /**
1084      * @dev Returns an URI for a contract
1085      */
1086     function toString(address _addr) public pure returns (string memory) {
1087         bytes32 value = bytes32(uint256(_addr));
1088         bytes memory alphabet = "0123456789abcdef";
1089 
1090         bytes memory str = new bytes(42);
1091         str[0] = "0";
1092         str[1] = "x";
1093         for (uint i = 0; i < 20; i++) {
1094             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
1095             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
1096         }
1097         return string(str);
1098     }
1099     /**
1100      * @dev Internal function to set the contract URI prefix.
1101      * @param _contractURIPrefix string URI prefix to assign
1102      */
1103     function _setContractURIPrefix(string memory _contractURIPrefix) internal {
1104         contractURIPrefix = _contractURIPrefix;
1105     }
1106 
1107     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1108         bytes memory _ba = bytes(_a);
1109         bytes memory _bb = bytes(_b);
1110         bytes memory bab = new bytes(_ba.length + _bb.length);
1111         uint k = 0;
1112         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1113         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1114         return string(bab);
1115     }
1116 }
1117 
1118 /**
1119  * @title MintableOwnableToken
1120  * @dev only owner can mint token.
1121  */
1122 contract MintableOwnableToken is Ownable, ERC721, IERC721Metadata, ERC721Burnable, ERC721Base, SignerRole {
1123 
1124     event Create(address indexed creator, string name, string symbol);
1125 
1126     constructor (string memory name, string memory symbol, string memory contractURIPrefix, string memory tokenURIPrefix, address signer) public ERC721Base(name, symbol, contractURIPrefix, tokenURIPrefix) {
1127         emit Create(msg.sender, name, symbol);
1128         _addSigner(signer);
1129     }
1130 
1131     function mint(uint256 tokenId, uint8 v, bytes32 r, bytes32 s, string memory tokenURI) onlyOwner public {
1132         require(isSigner(ecrecover(keccak256(abi.encodePacked(tokenId)), v, r, s)), "signer should sign tokenId");
1133         _mint(msg.sender, tokenId);
1134         _setTokenURI(tokenId, tokenURI);
1135     }
1136 
1137     function addSigner(address account) public onlyOwner {
1138         _addSigner(account);
1139     }
1140 
1141     function removeSigner(address account) public onlyOwner {
1142         _removeSigner(account);
1143     }
1144 
1145     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
1146         _setTokenURIPrefix(tokenURIPrefix);
1147     }
1148 
1149     function setContractURIPrefix(string memory contractURIPrefix) public onlyOwner {
1150         _setContractURIPrefix(contractURIPrefix);
1151     }
1152 }