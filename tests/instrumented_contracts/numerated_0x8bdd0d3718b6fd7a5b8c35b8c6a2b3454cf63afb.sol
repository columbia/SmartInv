1 // File: WhitelistAdminRole.sol
2 
3 pragma solidity ^0.5.0;
4 
5 
6 /**
7  * @title WhitelistAdminRole
8  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
9  */
10 contract WhitelistAdminRole {
11     using Roles for Roles.Role;
12 
13     event WhitelistAdminAdded(address indexed account);
14     event WhitelistAdminRemoved(address indexed account);
15 
16     Roles.Role private _whitelistAdmins;
17 
18     constructor () internal {
19         _addWhitelistAdmin(msg.sender);
20     }
21 
22     modifier onlyWhitelistAdmin() {
23         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
24         _;
25     }
26 
27     function isWhitelistAdmin(address account) public view returns (bool) {
28         return _whitelistAdmins.has(account);
29     }
30 
31     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
32         _addWhitelistAdmin(account);
33     }
34 
35     function renounceWhitelistAdmin() public {
36         _removeWhitelistAdmin(msg.sender);
37     }
38 
39     function _addWhitelistAdmin(address account) internal {
40         _whitelistAdmins.add(account);
41         emit WhitelistAdminAdded(account);
42     }
43 
44     function _removeWhitelistAdmin(address account) internal {
45         _whitelistAdmins.remove(account);
46         emit WhitelistAdminRemoved(account);
47     }
48 }
49 
50 // File: WhitelistedRole.sol
51 
52 pragma solidity ^0.5.0;
53 
54 
55 
56 /**
57  * @title WhitelistedRole
58  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
59  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
60  * it), and not Whitelisteds themselves.
61  */
62 contract WhitelistedRole is WhitelistAdminRole {
63     using Roles for Roles.Role;
64 
65     event WhitelistedAdded(address indexed account);
66     event WhitelistedRemoved(address indexed account);
67 
68     Roles.Role private _whitelisteds;
69 
70     modifier onlyWhitelisted() {
71         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
72         _;
73     }
74 
75     function isWhitelisted(address account) public view returns (bool) {
76         return _whitelisteds.has(account);
77     }
78 
79     function addWhitelisted(address account) public onlyWhitelistAdmin {
80         _addWhitelisted(account);
81     }
82 
83     function removeWhitelisted(address account) public onlyWhitelistAdmin {
84         _removeWhitelisted(account);
85     }
86 
87     function renounceWhitelisted() public {
88         _removeWhitelisted(msg.sender);
89     }
90 
91     function _addWhitelisted(address account) internal {
92         _whitelisteds.add(account);
93         emit WhitelistedAdded(account);
94     }
95 
96     function _removeWhitelisted(address account) internal {
97         _whitelisteds.remove(account);
98         emit WhitelistedRemoved(account);
99     }
100 }
101 
102 // File: Roles.sol
103 
104 pragma solidity ^0.5.0;
105 
106 /**
107  * @title Roles
108  * @dev Library for managing addresses assigned to a Role.
109  */
110 library Roles {
111     struct Role {
112         mapping (address => bool) bearer;
113     }
114 
115     /**
116      * @dev Give an account access to this role.
117      */
118     function add(Role storage role, address account) internal {
119         require(!has(role, account), "Roles: account already has role");
120         role.bearer[account] = true;
121     }
122 
123     /**
124      * @dev Remove an account's access to this role.
125      */
126     function remove(Role storage role, address account) internal {
127         require(has(role, account), "Roles: account does not have role");
128         role.bearer[account] = false;
129     }
130 
131     /**
132      * @dev Check if an account has this role.
133      * @return bool
134      */
135     function has(Role storage role, address account) internal view returns (bool) {
136         require(account != address(0), "Roles: account is the zero address");
137         return role.bearer[account];
138     }
139 }
140 
141 // File: ControllerRole.sol
142 
143 pragma solidity 0.5.12;
144 
145 
146 // solium-disable error-reason
147 
148 /**
149  * @title ControllerRole
150  * @dev An Controller role defined using the Open Zeppelin Role system.
151  */
152 contract ControllerRole {
153 
154     using Roles for Roles.Role;
155 
156     // NOTE: Commented out standard Role events to save gas.
157     // event ControllerAdded(address indexed account);
158     // event ControllerRemoved(address indexed account);
159 
160     Roles.Role private _controllers;
161 
162     constructor () public {
163         _addController(msg.sender);
164     }
165 
166     modifier onlyController() {
167         require(isController(msg.sender));
168         _;
169     }
170 
171     function isController(address account) public view returns (bool) {
172         return _controllers.has(account);
173     }
174 
175     function addController(address account) public onlyController {
176         _addController(account);
177     }
178 
179     function renounceController() public {
180         _removeController(msg.sender);
181     }
182 
183     function _addController(address account) internal {
184         _controllers.add(account);
185         // emit ControllerAdded(account);
186     }
187 
188     function _removeController(address account) internal {
189         _controllers.remove(account);
190         // emit ControllerRemoved(account);
191     }
192 
193 }
194 
195 
196 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/drafts/Counters.sol
197 
198 pragma solidity ^0.5.0;
199 
200 
201 /**
202  * @title Counters
203  * @author Matt Condon (@shrugs)
204  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
205  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
206  *
207  * Include with `using Counters for Counters.Counter;`
208  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
209  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
210  * directly accessed.
211  */
212 library Counters {
213     using SafeMath for uint256;
214 
215     struct Counter {
216         // This variable should never be directly accessed by users of the library: interactions must be restricted to
217         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
218         // this feature: see https://github.com/ethereum/solidity/issues/4637
219         uint256 _value; // default: 0
220     }
221 
222     function current(Counter storage counter) internal view returns (uint256) {
223         return counter._value;
224     }
225 
226     function increment(Counter storage counter) internal {
227         counter._value += 1;
228     }
229 
230     function decrement(Counter storage counter) internal {
231         counter._value = counter._value.sub(1);
232     }
233 }
234 
235 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/utils/Address.sol
236 
237 pragma solidity ^0.5.5;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * This test is non-exhaustive, and there may be false-negatives: during the
247      * execution of a contract's constructor, its address will be reported as
248      * not containing a contract.
249      *
250      * IMPORTANT: It is unsafe to assume that an address for which this
251      * function returns false is an externally-owned account (EOA) and not a
252      * contract.
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies in extcodesize, which returns 0 for contracts in
256         // construction, since the code is only stored at the end of the
257         // constructor execution.
258 
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != 0x0 && codehash != accountHash);
267     }
268 
269     /**
270      * @dev Converts an `address` into `address payable`. Note that this is
271      * simply a type cast: the actual underlying value is not changed.
272      *
273      * _Available since v2.4.0._
274      */
275     function toPayable(address account) internal pure returns (address payable) {
276         return address(uint160(account));
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      *
295      * _Available since v2.4.0._
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-call-value
301         (bool success, ) = recipient.call.value(amount)("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 }
305 
306 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/math/SafeMath.sol
307 
308 pragma solidity ^0.5.0;
309 
310 /**
311  * @dev Wrappers over Solidity's arithmetic operations with added overflow
312  * checks.
313  *
314  * Arithmetic operations in Solidity wrap on overflow. This can easily result
315  * in bugs, because programmers usually assume that an overflow raises an
316  * error, which is the standard behavior in high level programming languages.
317  * `SafeMath` restores this intuition by reverting the transaction when an
318  * operation overflows.
319  *
320  * Using this library instead of the unchecked operations eliminates an entire
321  * class of bugs, so it's recommended to use it always.
322  */
323 library SafeMath {
324     /**
325      * @dev Returns the addition of two unsigned integers, reverting on
326      * overflow.
327      *
328      * Counterpart to Solidity's `+` operator.
329      *
330      * Requirements:
331      * - Addition cannot overflow.
332      */
333     function add(uint256 a, uint256 b) internal pure returns (uint256) {
334         uint256 c = a + b;
335         require(c >= a, "SafeMath: addition overflow");
336 
337         return c;
338     }
339 
340     /**
341      * @dev Returns the subtraction of two unsigned integers, reverting on
342      * overflow (when the result is negative).
343      *
344      * Counterpart to Solidity's `-` operator.
345      *
346      * Requirements:
347      * - Subtraction cannot overflow.
348      */
349     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
350         return sub(a, b, "SafeMath: subtraction overflow");
351     }
352 
353     /**
354      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
355      * overflow (when the result is negative).
356      *
357      * Counterpart to Solidity's `-` operator.
358      *
359      * Requirements:
360      * - Subtraction cannot overflow.
361      *
362      * _Available since v2.4.0._
363      */
364     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
365         require(b <= a, errorMessage);
366         uint256 c = a - b;
367 
368         return c;
369     }
370 
371     /**
372      * @dev Returns the multiplication of two unsigned integers, reverting on
373      * overflow.
374      *
375      * Counterpart to Solidity's `*` operator.
376      *
377      * Requirements:
378      * - Multiplication cannot overflow.
379      */
380     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
382         // benefit is lost if 'b' is also tested.
383         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
384         if (a == 0) {
385             return 0;
386         }
387 
388         uint256 c = a * b;
389         require(c / a == b, "SafeMath: multiplication overflow");
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the integer division of two unsigned integers. Reverts on
396      * division by zero. The result is rounded towards zero.
397      *
398      * Counterpart to Solidity's `/` operator. Note: this function uses a
399      * `revert` opcode (which leaves remaining gas untouched) while Solidity
400      * uses an invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      * - The divisor cannot be zero.
404      */
405     function div(uint256 a, uint256 b) internal pure returns (uint256) {
406         return div(a, b, "SafeMath: division by zero");
407     }
408 
409     /**
410      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
411      * division by zero. The result is rounded towards zero.
412      *
413      * Counterpart to Solidity's `/` operator. Note: this function uses a
414      * `revert` opcode (which leaves remaining gas untouched) while Solidity
415      * uses an invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      * - The divisor cannot be zero.
419      *
420      * _Available since v2.4.0._
421      */
422     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         // Solidity only automatically asserts when dividing by 0
424         require(b > 0, errorMessage);
425         uint256 c = a / b;
426         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
427 
428         return c;
429     }
430 
431     /**
432      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
433      * Reverts when dividing by zero.
434      *
435      * Counterpart to Solidity's `%` operator. This function uses a `revert`
436      * opcode (which leaves remaining gas untouched) while Solidity uses an
437      * invalid opcode to revert (consuming all remaining gas).
438      *
439      * Requirements:
440      * - The divisor cannot be zero.
441      */
442     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
443         return mod(a, b, "SafeMath: modulo by zero");
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * Reverts with custom message when dividing by zero.
449      *
450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
451      * opcode (which leaves remaining gas untouched) while Solidity uses an
452      * invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      * - The divisor cannot be zero.
456      *
457      * _Available since v2.4.0._
458      */
459     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
460         require(b != 0, errorMessage);
461         return a % b;
462     }
463 }
464 
465 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC721/IERC721Receiver.sol
466 
467 pragma solidity ^0.5.0;
468 
469 /**
470  * @title ERC721 token receiver interface
471  * @dev Interface for any contract that wants to support safeTransfers
472  * from ERC721 asset contracts.
473  */
474 contract IERC721Receiver {
475     /**
476      * @notice Handle the receipt of an NFT
477      * @dev The ERC721 smart contract calls this function on the recipient
478      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
479      * otherwise the caller will revert the transaction. The selector to be
480      * returned can be obtained as `this.onERC721Received.selector`. This
481      * function MAY throw to revert and reject the transfer.
482      * Note: the ERC721 contract address is always the message sender.
483      * @param operator The address which called `safeTransferFrom` function
484      * @param from The address which previously owned the token
485      * @param tokenId The NFT identifier which is being transferred
486      * @param data Additional data with no specified format
487      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
488      */
489     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
490     public returns (bytes4);
491 }
492 
493 
494 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/GSN/Context.sol
495 
496 pragma solidity ^0.5.0;
497 
498 /*
499  * @dev Provides information about the current execution context, including the
500  * sender of the transaction and its data. While these are generally available
501  * via msg.sender and msg.data, they should not be accessed in such a direct
502  * manner, since when dealing with GSN meta-transactions the account sending and
503  * paying for execution may not be the actual sender (as far as an application
504  * is concerned).
505  *
506  * This contract is only required for intermediate, library-like contracts.
507  */
508 contract Context {
509     // Empty internal constructor, to prevent people from mistakenly deploying
510     // an instance of this contract, which should be used via inheritance.
511     constructor () internal { }
512     // solhint-disable-previous-line no-empty-blocks
513 
514     function _msgSender() internal view returns (address payable) {
515         return msg.sender;
516     }
517 
518     function _msgData() internal view returns (bytes memory) {
519         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
520         return msg.data;
521     }
522 }
523 
524 
525 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/introspection/IERC165.sol
526 
527 pragma solidity ^0.5.0;
528 
529 /**
530  * @dev Interface of the ERC165 standard, as defined in the
531  * https://eips.ethereum.org/EIPS/eip-165[EIP].
532  *
533  * Implementers can declare support of contract interfaces, which can then be
534  * queried by others ({ERC165Checker}).
535  *
536  * For an implementation, see {ERC165}.
537  */
538 interface IERC165 {
539     /**
540      * @dev Returns true if this contract implements the interface defined by
541      * `interfaceId`. See the corresponding
542      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
543      * to learn more about how these ids are created.
544      *
545      * This function call must use less than 30 000 gas.
546      */
547     function supportsInterface(bytes4 interfaceId) external view returns (bool);
548 }
549 
550 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/introspection/ERC165.sol
551 
552 pragma solidity ^0.5.0;
553 
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts may inherit from this and call {_registerInterface} to declare
559  * their support of an interface.
560  */
561 contract ERC165 is IERC165 {
562     /*
563      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
564      */
565     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
566 
567     /**
568      * @dev Mapping of interface ids to whether or not it's supported.
569      */
570     mapping(bytes4 => bool) private _supportedInterfaces;
571 
572     constructor () internal {
573         // Derived contracts need only register support for their own interfaces,
574         // we register support for ERC165 itself here
575         _registerInterface(_INTERFACE_ID_ERC165);
576     }
577 
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      *
581      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
584         return _supportedInterfaces[interfaceId];
585     }
586 
587     /**
588      * @dev Registers the contract as an implementer of the interface defined by
589      * `interfaceId`. Support of the actual ERC165 interface is automatic and
590      * registering its interface id is not required.
591      *
592      * See {IERC165-supportsInterface}.
593      *
594      * Requirements:
595      *
596      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
597      */
598     function _registerInterface(bytes4 interfaceId) internal {
599         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
600         _supportedInterfaces[interfaceId] = true;
601     }
602 }
603 
604 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC721/IERC721.sol
605 
606 pragma solidity ^0.5.0;
607 
608 
609 /**
610  * @dev Required interface of an ERC721 compliant contract.
611  */
612 contract IERC721 is IERC165 {
613     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
614     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
615     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
616 
617     /**
618      * @dev Returns the number of NFTs in `owner`'s account.
619      */
620     function balanceOf(address owner) public view returns (uint256 balance);
621 
622     /**
623      * @dev Returns the owner of the NFT specified by `tokenId`.
624      */
625     function ownerOf(uint256 tokenId) public view returns (address owner);
626 
627     /**
628      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
629      * another (`to`).
630      *
631      *
632      *
633      * Requirements:
634      * - `from`, `to` cannot be zero.
635      * - `tokenId` must be owned by `from`.
636      * - If the caller is not `from`, it must be have been allowed to move this
637      * NFT by either {approve} or {setApprovalForAll}.
638      */
639     function safeTransferFrom(address from, address to, uint256 tokenId) public;
640     /**
641      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
642      * another (`to`).
643      *
644      * Requirements:
645      * - If the caller is not `from`, it must be approved to move this NFT by
646      * either {approve} or {setApprovalForAll}.
647      */
648     function transferFrom(address from, address to, uint256 tokenId) public;
649     function approve(address to, uint256 tokenId) public;
650     function getApproved(uint256 tokenId) public view returns (address operator);
651 
652     function setApprovalForAll(address operator, bool _approved) public;
653     function isApprovedForAll(address owner, address operator) public view returns (bool);
654 
655 
656     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
657 }
658 
659 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC721/IERC721Metadata.sol
660 
661 pragma solidity ^0.5.0;
662 
663 
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
666  * @dev See https://eips.ethereum.org/EIPS/eip-721
667  */
668 contract IERC721Metadata is IERC721 {
669     function name() external view returns (string memory);
670     function symbol() external view returns (string memory);
671     function tokenURI(uint256 tokenId) external view returns (string memory);
672 }
673 
674 // File: IRegistry.sol
675 
676 pragma solidity 0.5.12;
677 
678 
679 contract IRegistry is IERC721Metadata {
680 
681     event NewURI(uint256 indexed tokenId, string uri);
682 
683     event NewURIPrefix(string prefix);
684 
685     event Resolve(uint256 indexed tokenId, address indexed to);
686 
687     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
688 
689     /**
690      * @dev Controlled function to set the token URI Prefix for all tokens.
691      * @param prefix string URI to assign
692      */
693     function controlledSetTokenURIPrefix(string calldata prefix) external;
694 
695     /**
696      * @dev Returns whether the given spender can transfer a given token ID.
697      * @param spender address of the spender to query
698      * @param tokenId uint256 ID of the token to be transferred
699      * @return bool whether the msg.sender is approved for the given token ID,
700      * is an operator of the owner, or is the owner of the token
701      */
702     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
703 
704     /**
705      * @dev Mints a new a child token.
706      * Calculates child token ID using a namehash function.
707      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
708      * Requires the token not exist.
709      * @param to address to receive the ownership of the given token ID
710      * @param tokenId uint256 ID of the parent token
711      * @param label subdomain label of the child token ID
712      */
713     function mintChild(address to, uint256 tokenId, string calldata label) external;
714 
715     /**
716      * @dev Controlled function to mint a given token ID.
717      * Requires the msg.sender to be controller.
718      * Requires the token ID to not exist.
719      * @param to address the given token ID will be minted to
720      * @param label string that is a subdomain
721      * @param tokenId uint256 ID of the parent token
722      */
723     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
724 
725     /**
726      * @dev Transfers the ownership of a child token ID to another address.
727      * Calculates child token ID using a namehash function.
728      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
729      * Requires the token already exist.
730      * @param from current owner of the token
731      * @param to address to receive the ownership of the given token ID
732      * @param tokenId uint256 ID of the token to be transferred
733      * @param label subdomain label of the child token ID
734      */
735     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
736 
737     /**
738      * @dev Controlled function to transfers the ownership of a token ID to
739      * another address.
740      * Requires the msg.sender to be controller.
741      * Requires the token already exist.
742      * @param from current owner of the token
743      * @param to address to receive the ownership of the given token ID
744      * @param tokenId uint256 ID of the token to be transferred
745      */
746     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
747 
748     /**
749      * @dev Safely transfers the ownership of a child token ID to another address.
750      * Calculates child token ID using a namehash function.
751      * Implements a ERC721Reciever check unlike transferFromChild.
752      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
753      * Requires the token already exist.
754      * @param from current owner of the token
755      * @param to address to receive the ownership of the given token ID
756      * @param tokenId uint256 parent ID of the token to be transferred
757      * @param label subdomain label of the child token ID
758      * @param _data bytes data to send along with a safe transfer check
759      */
760     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
761 
762     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
763     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
764 
765     /**
766      * @dev Controlled frunction to safely transfers the ownership of a token ID
767      * to another address.
768      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
769      * Requires the msg.sender to be controller.
770      * Requires the token already exist.
771      * @param from current owner of the token
772      * @param to address to receive the ownership of the given token ID
773      * @param tokenId uint256 parent ID of the token to be transferred
774      * @param _data bytes data to send along with a safe transfer check
775      */
776     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
777 
778     /**
779      * @dev Burns a child token ID.
780      * Calculates child token ID using a namehash function.
781      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
782      * Requires the token already exist.
783      * @param tokenId uint256 ID of the token to be transferred
784      * @param label subdomain label of the child token ID
785      */
786     function burnChild(uint256 tokenId, string calldata label) external;
787 
788     /**
789      * @dev Controlled function to burn a given token ID.
790      * Requires the msg.sender to be controller.
791      * Requires the token already exist.
792      * @param tokenId uint256 ID of the token to be burned
793      */
794     function controlledBurn(uint256 tokenId) external;
795 
796     /**
797      * @dev Sets the resolver of a given token ID to another address.
798      * Requires the msg.sender to be the owner, approved, or operator.
799      * @param to address the given token ID will resolve to
800      * @param tokenId uint256 ID of the token to be transferred
801      */
802     function resolveTo(address to, uint256 tokenId) external;
803 
804     /**
805      * @dev Gets the resolver of the specified token ID.
806      * @param tokenId uint256 ID of the token to query the resolver of
807      * @return address currently marked as the resolver of the given token ID
808      */
809     function resolverOf(uint256 tokenId) external view returns (address);
810 
811     /**
812      * @dev Controlled function to sets the resolver of a given token ID.
813      * Requires the msg.sender to be controller.
814      * @param to address the given token ID will resolve to
815      * @param tokenId uint256 ID of the token to be transferred
816      */
817     function controlledResolveTo(address to, uint256 tokenId) external;
818 
819     /**
820      * @dev Provides child token (subdomain) of provided tokenId.
821      * @param tokenId uint256 ID of the token
822      * @param label label of subdomain (for `aaa.bbb.crypto` it will be `aaa`)
823      */
824     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256);
825 
826     /**
827      * @dev Transfer domain ownership without resetting domain records.
828      * @param to address of new domain owner
829      * @param tokenId uint256 ID of the token to be transferred
830      */
831     function setOwner(address to, uint256 tokenId) external;
832 }
833 
834 // File: browser/SubDomainBurner.sol
835 
836 pragma solidity 0.5.12;
837 
838 
839 
840 /**
841  * @title SubDomainBurner
842  * @dev Defines the functions for burning of Third Level Domains.
843  */
844 contract SubDomainBurner is WhitelistedRole {
845 
846     Registry internal _registry;
847 
848     constructor (Registry registry) public {
849         _registry = registry;
850         _addWhitelisted(msg.sender);
851     }
852 
853     function registry() external view returns (address) {
854         return address(_registry);
855     }
856 
857     function burnSubDomain(uint256 tokenId, string memory label) public onlyWhitelisted {
858         _registry.burnChild(tokenId, label);
859     }
860 }
861 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC721/ERC721.sol
862 
863 pragma solidity ^0.5.0;
864 
865 
866 /**
867  * @title ERC721 Non-Fungible Token Standard basic implementation
868  * @dev see https://eips.ethereum.org/EIPS/eip-721
869  */
870 contract ERC721 is Context, ERC165, IERC721 {
871     using SafeMath for uint256;
872     using Address for address;
873     using Counters for Counters.Counter;
874 
875     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
876     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
877     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
878 
879     // Mapping from token ID to owner
880     mapping (uint256 => address) private _tokenOwner;
881 
882     // Mapping from token ID to approved address
883     mapping (uint256 => address) private _tokenApprovals;
884 
885     // Mapping from owner to number of owned token
886     mapping (address => Counters.Counter) private _ownedTokensCount;
887 
888     // Mapping from owner to operator approvals
889     mapping (address => mapping (address => bool)) private _operatorApprovals;
890 
891     /*
892      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
893      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
894      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
895      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
896      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
897      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
898      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
899      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
900      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
901      *
902      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
903      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
904      */
905     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
906 
907     constructor () public {
908         // register the supported interfaces to conform to ERC721 via ERC165
909         _registerInterface(_INTERFACE_ID_ERC721);
910     }
911 
912     /**
913      * @dev Gets the balance of the specified address.
914      * @param owner address to query the balance of
915      * @return uint256 representing the amount owned by the passed address
916      */
917     function balanceOf(address owner) public view returns (uint256) {
918         require(owner != address(0), "ERC721: balance query for the zero address");
919 
920         return _ownedTokensCount[owner].current();
921     }
922 
923     /**
924      * @dev Gets the owner of the specified token ID.
925      * @param tokenId uint256 ID of the token to query the owner of
926      * @return address currently marked as the owner of the given token ID
927      */
928     function ownerOf(uint256 tokenId) public view returns (address) {
929         address owner = _tokenOwner[tokenId];
930         require(owner != address(0), "ERC721: owner query for nonexistent token");
931 
932         return owner;
933     }
934 
935     /**
936      * @dev Approves another address to transfer the given token ID
937      * The zero address indicates there is no approved address.
938      * There can only be one approved address per token at a given time.
939      * Can only be called by the token owner or an approved operator.
940      * @param to address to be approved for the given token ID
941      * @param tokenId uint256 ID of the token to be approved
942      */
943     function approve(address to, uint256 tokenId) public {
944         address owner = ownerOf(tokenId);
945         require(to != owner, "ERC721: approval to current owner");
946 
947         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
948             "ERC721: approve caller is not owner nor approved for all"
949         );
950 
951         _tokenApprovals[tokenId] = to;
952         emit Approval(owner, to, tokenId);
953     }
954 
955     /**
956      * @dev Gets the approved address for a token ID, or zero if no address set
957      * Reverts if the token ID does not exist.
958      * @param tokenId uint256 ID of the token to query the approval of
959      * @return address currently approved for the given token ID
960      */
961     function getApproved(uint256 tokenId) public view returns (address) {
962         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
963 
964         return _tokenApprovals[tokenId];
965     }
966 
967     /**
968      * @dev Sets or unsets the approval of a given operator
969      * An operator is allowed to transfer all tokens of the sender on their behalf.
970      * @param to operator address to set the approval
971      * @param approved representing the status of the approval to be set
972      */
973     function setApprovalForAll(address to, bool approved) public {
974         require(to != _msgSender(), "ERC721: approve to caller");
975 
976         _operatorApprovals[_msgSender()][to] = approved;
977         emit ApprovalForAll(_msgSender(), to, approved);
978     }
979 
980     /**
981      * @dev Tells whether an operator is approved by a given owner.
982      * @param owner owner address which you want to query the approval of
983      * @param operator operator address which you want to query the approval of
984      * @return bool whether the given operator is approved by the given owner
985      */
986     function isApprovedForAll(address owner, address operator) public view returns (bool) {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev Transfers the ownership of a given token ID to another address.
992      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
993      * Requires the msg.sender to be the owner, approved, or operator.
994      * @param from current owner of the token
995      * @param to address to receive the ownership of the given token ID
996      * @param tokenId uint256 ID of the token to be transferred
997      */
998     function transferFrom(address from, address to, uint256 tokenId) public {
999         //solhint-disable-next-line max-line-length
1000         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1001 
1002         _transferFrom(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev Safely transfers the ownership of a given token ID to another address
1007      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1008      * which is called upon a safe transfer, and return the magic value
1009      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1010      * the transfer is reverted.
1011      * Requires the msg.sender to be the owner, approved, or operator
1012      * @param from current owner of the token
1013      * @param to address to receive the ownership of the given token ID
1014      * @param tokenId uint256 ID of the token to be transferred
1015      */
1016     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1017         safeTransferFrom(from, to, tokenId, "");
1018     }
1019 
1020     /**
1021      * @dev Safely transfers the ownership of a given token ID to another address
1022      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1023      * which is called upon a safe transfer, and return the magic value
1024      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1025      * the transfer is reverted.
1026      * Requires the _msgSender() to be the owner, approved, or operator
1027      * @param from current owner of the token
1028      * @param to address to receive the ownership of the given token ID
1029      * @param tokenId uint256 ID of the token to be transferred
1030      * @param _data bytes data to send along with a safe transfer check
1031      */
1032     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1033         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1034         _safeTransferFrom(from, to, tokenId, _data);
1035     }
1036 
1037     /**
1038      * @dev Safely transfers the ownership of a given token ID to another address
1039      * If the target address is a contract, it must implement `onERC721Received`,
1040      * which is called upon a safe transfer, and return the magic value
1041      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1042      * the transfer is reverted.
1043      * Requires the msg.sender to be the owner, approved, or operator
1044      * @param from current owner of the token
1045      * @param to address to receive the ownership of the given token ID
1046      * @param tokenId uint256 ID of the token to be transferred
1047      * @param _data bytes data to send along with a safe transfer check
1048      */
1049     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
1050         _transferFrom(from, to, tokenId);
1051         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1052     }
1053 
1054     /**
1055      * @dev Returns whether the specified token exists.
1056      * @param tokenId uint256 ID of the token to query the existence of
1057      * @return bool whether the token exists
1058      */
1059     function _exists(uint256 tokenId) internal view returns (bool) {
1060         address owner = _tokenOwner[tokenId];
1061         return owner != address(0);
1062     }
1063 
1064     /**
1065      * @dev Returns whether the given spender can transfer a given token ID.
1066      * @param spender address of the spender to query
1067      * @param tokenId uint256 ID of the token to be transferred
1068      * @return bool whether the msg.sender is approved for the given token ID,
1069      * is an operator of the owner, or is the owner of the token
1070      */
1071     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1072         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1073         address owner = ownerOf(tokenId);
1074         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1075     }
1076 
1077     /**
1078      * @dev Internal function to safely mint a new token.
1079      * Reverts if the given token ID already exists.
1080      * If the target address is a contract, it must implement `onERC721Received`,
1081      * which is called upon a safe transfer, and return the magic value
1082      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1083      * the transfer is reverted.
1084      * @param to The address that will own the minted token
1085      * @param tokenId uint256 ID of the token to be minted
1086      */
1087     function _safeMint(address to, uint256 tokenId) internal {
1088         _safeMint(to, tokenId, "");
1089     }
1090 
1091     /**
1092      * @dev Internal function to safely mint a new token.
1093      * Reverts if the given token ID already exists.
1094      * If the target address is a contract, it must implement `onERC721Received`,
1095      * which is called upon a safe transfer, and return the magic value
1096      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1097      * the transfer is reverted.
1098      * @param to The address that will own the minted token
1099      * @param tokenId uint256 ID of the token to be minted
1100      * @param _data bytes data to send along with a safe transfer check
1101      */
1102     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
1103         _mint(to, tokenId);
1104         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1105     }
1106 
1107     /**
1108      * @dev Internal function to mint a new token.
1109      * Reverts if the given token ID already exists.
1110      * @param to The address that will own the minted token
1111      * @param tokenId uint256 ID of the token to be minted
1112      */
1113     function _mint(address to, uint256 tokenId) internal {
1114         require(to != address(0), "ERC721: mint to the zero address");
1115         require(!_exists(tokenId), "ERC721: token already minted");
1116 
1117         _tokenOwner[tokenId] = to;
1118         _ownedTokensCount[to].increment();
1119 
1120         emit Transfer(address(0), to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev Internal function to burn a specific token.
1125      * Reverts if the token does not exist.
1126      * Deprecated, use {_burn} instead.
1127      * @param owner owner of the token to burn
1128      * @param tokenId uint256 ID of the token being burned
1129      */
1130     function _burn(address owner, uint256 tokenId) internal {
1131         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
1132 
1133         _clearApproval(tokenId);
1134 
1135         _ownedTokensCount[owner].decrement();
1136         _tokenOwner[tokenId] = address(0);
1137 
1138         emit Transfer(owner, address(0), tokenId);
1139     }
1140 
1141     /**
1142      * @dev Internal function to burn a specific token.
1143      * Reverts if the token does not exist.
1144      * @param tokenId uint256 ID of the token being burned
1145      */
1146     function _burn(uint256 tokenId) internal {
1147         _burn(ownerOf(tokenId), tokenId);
1148     }
1149 
1150     /**
1151      * @dev Internal function to transfer ownership of a given token ID to another address.
1152      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1153      * @param from current owner of the token
1154      * @param to address to receive the ownership of the given token ID
1155      * @param tokenId uint256 ID of the token to be transferred
1156      */
1157     function _transferFrom(address from, address to, uint256 tokenId) internal {
1158         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1159         require(to != address(0), "ERC721: transfer to the zero address");
1160 
1161         _clearApproval(tokenId);
1162 
1163         _ownedTokensCount[from].decrement();
1164         _ownedTokensCount[to].increment();
1165 
1166         _tokenOwner[tokenId] = to;
1167 
1168         emit Transfer(from, to, tokenId);
1169     }
1170 
1171     /**
1172      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1173      * The call is not executed if the target address is not a contract.
1174      *
1175      * This function is deprecated.
1176      * @param from address representing the previous owner of the given token ID
1177      * @param to target address that will receive the tokens
1178      * @param tokenId uint256 ID of the token to be transferred
1179      * @param _data bytes optional data to send along with the call
1180      * @return bool whether the call correctly returned the expected magic value
1181      */
1182     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1183         internal returns (bool)
1184     {
1185         if (!to.isContract()) {
1186             return true;
1187         }
1188 
1189         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
1190         return (retval == _ERC721_RECEIVED);
1191     }
1192 
1193     /**
1194      * @dev Private function to clear current approval of a given token ID.
1195      * @param tokenId uint256 ID of the token to be transferred
1196      */
1197     function _clearApproval(uint256 tokenId) private {
1198         if (_tokenApprovals[tokenId] != address(0)) {
1199             _tokenApprovals[tokenId] = address(0);
1200         }
1201     }
1202 }
1203 
1204 
1205 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC721/ERC721Burnable.sol
1206 
1207 pragma solidity ^0.5.0;
1208 
1209 
1210 
1211 /**
1212  * @title ERC721 Burnable Token
1213  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1214  */
1215 contract ERC721Burnable is Context, ERC721 {
1216     /**
1217      * @dev Burns a specific ERC721 token.
1218      * @param tokenId uint256 id of the ERC721 token to be burned.
1219      */
1220     function burn(uint256 tokenId) public {
1221         //solhint-disable-next-line max-line-length
1222         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1223         _burn(tokenId);
1224     }
1225 }
1226 
1227 // File: Registry.sol
1228 
1229 pragma solidity 0.5.12;
1230 
1231 
1232 // solium-disable no-empty-blocks,error-reason
1233 
1234 /**
1235  * @title Registry
1236  * @dev An ERC721 Token see https://eips.ethereum.org/EIPS/eip-721. With
1237  * additional functions so other trusted contracts to interact with the tokens.
1238  */
1239 contract Registry is IRegistry, ControllerRole, ERC721Burnable {
1240 
1241     // Optional mapping for token URIs
1242     mapping(uint256 => string) internal _tokenURIs;
1243 
1244     string internal _prefix;
1245 
1246     // Mapping from token ID to resolver address
1247     mapping (uint256 => address) internal _tokenResolvers;
1248 
1249     // uint256(keccak256(abi.encodePacked(uint256(0x0), keccak256(abi.encodePacked("crypto")))))
1250     uint256 private constant _CRYPTO_HASH =
1251         0x0f4a10a4f46c288cea365fcf45cccf0e9d901b945b9829ccdb54c10dc3cb7a6f;
1252 
1253     modifier onlyApprovedOrOwner(uint256 tokenId) {
1254         require(_isApprovedOrOwner(msg.sender, tokenId));
1255         _;
1256     }
1257 
1258     constructor () public {
1259         _mint(address(0xdead), _CRYPTO_HASH);
1260         // register the supported interfaces to conform to ERC721 via ERC165
1261         _registerInterface(0x5b5e139f); // ERC721 Metadata Interface
1262         _tokenURIs[root()] = "crypto";
1263         emit NewURI(root(), "crypto");
1264     }
1265 
1266     /// ERC721 Metadata extension
1267 
1268     function name() external view returns (string memory) {
1269         return ".crypto";
1270     }
1271 
1272     function symbol() external view returns (string memory) {
1273         return "UD";
1274     }
1275 
1276     function tokenURI(uint256 tokenId) external view returns (string memory) {
1277         require(_exists(tokenId));
1278         return string(abi.encodePacked(_prefix, _tokenURIs[tokenId]));
1279     }
1280 
1281     function controlledSetTokenURIPrefix(string calldata prefix) external onlyController {
1282         _prefix = prefix;
1283         emit NewURIPrefix(prefix);
1284     }
1285 
1286     /// Ownership
1287 
1288     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
1289         return _isApprovedOrOwner(spender, tokenId);
1290     }
1291 
1292     /// Registry Constants
1293 
1294     function root() public pure returns (uint256) {
1295         return _CRYPTO_HASH;
1296     }
1297 
1298     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256) {
1299         return _childId(tokenId, label);
1300     }
1301 
1302     /// Minting
1303 
1304     function mintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1305         _mintChild(to, tokenId, label);
1306     }
1307 
1308     function controlledMintChild(address to, uint256 tokenId, string calldata label) external onlyController {
1309         _mintChild(to, tokenId, label);
1310     }
1311 
1312     function safeMintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1313         _safeMintChild(to, tokenId, label, "");
1314     }
1315 
1316     function safeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1317         external
1318         onlyApprovedOrOwner(tokenId)
1319     {
1320         _safeMintChild(to, tokenId, label, _data);
1321     }
1322 
1323     function controlledSafeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1324         external
1325         onlyController
1326     {
1327         _safeMintChild(to, tokenId, label, _data);
1328     }
1329 
1330     /// Transfering
1331 
1332     function setOwner(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId)  {
1333         super._transferFrom(ownerOf(tokenId), to, tokenId);
1334     }
1335 
1336     function transferFromChild(address from, address to, uint256 tokenId, string calldata label)
1337         external
1338         onlyApprovedOrOwner(tokenId)
1339     {
1340         _transferFrom(from, to, _childId(tokenId, label));
1341     }
1342 
1343     function controlledTransferFrom(address from, address to, uint256 tokenId) external onlyController {
1344         _transferFrom(from, to, tokenId);
1345     }
1346 
1347     function safeTransferFromChild(
1348         address from,
1349         address to,
1350         uint256 tokenId,
1351         string memory label,
1352         bytes memory _data
1353     ) public onlyApprovedOrOwner(tokenId) {
1354         uint256 childId = _childId(tokenId, label);
1355         _transferFrom(from, to, childId);
1356         require(_checkOnERC721Received(from, to, childId, _data));
1357     }
1358 
1359     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external {
1360         safeTransferFromChild(from, to, tokenId, label, "");
1361     }
1362 
1363     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data)
1364         external
1365         onlyController
1366     {
1367         _transferFrom(from, to, tokenId);
1368         require(_checkOnERC721Received(from, to, tokenId, _data));
1369     }
1370 
1371     /// Burning
1372 
1373     function burnChild(uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1374         _burn(_childId(tokenId, label));
1375     }
1376 
1377     function controlledBurn(uint256 tokenId) external onlyController {
1378         _burn(tokenId);
1379     }
1380 
1381     /// Resolution
1382 
1383     function resolverOf(uint256 tokenId) external view returns (address) {
1384         address resolver = _tokenResolvers[tokenId];
1385         require(resolver != address(0));
1386         return resolver;
1387     }
1388 
1389     function resolveTo(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
1390         _resolveTo(to, tokenId);
1391     }
1392 
1393     function controlledResolveTo(address to, uint256 tokenId) external onlyController {
1394         _resolveTo(to, tokenId);
1395     }
1396 
1397     function sync(uint256 tokenId, uint256 updateId) external {
1398         require(_tokenResolvers[tokenId] == msg.sender);
1399         emit Sync(msg.sender, updateId, tokenId);
1400     }
1401 
1402     /// Internal
1403 
1404     function _childId(uint256 tokenId, string memory label) internal pure returns (uint256) {
1405         require(bytes(label).length != 0);
1406         return uint256(keccak256(abi.encodePacked(tokenId, keccak256(abi.encodePacked(label)))));
1407     }
1408 
1409     function _mintChild(address to, uint256 tokenId, string memory label) internal {
1410         uint256 childId = _childId(tokenId, label);
1411         _mint(to, childId);
1412 
1413         require(bytes(label).length != 0);
1414         require(_exists(childId));
1415 
1416         bytes memory domain = abi.encodePacked(label, ".", _tokenURIs[tokenId]);
1417 
1418         _tokenURIs[childId] = string(domain);
1419         emit NewURI(childId, string(domain));
1420     }
1421 
1422     function _safeMintChild(address to, uint256 tokenId, string memory label, bytes memory _data) internal {
1423         _mintChild(to, tokenId, label);
1424         require(_checkOnERC721Received(address(0), to, _childId(tokenId, label), _data));
1425     }
1426 
1427     function _transferFrom(address from, address to, uint256 tokenId) internal {
1428         super._transferFrom(from, to, tokenId);
1429         // Clear resolver (if any)
1430         if (_tokenResolvers[tokenId] != address(0x0)) {
1431             delete _tokenResolvers[tokenId];
1432         }
1433     }
1434 
1435     function _burn(uint256 tokenId) internal {
1436         super._burn(tokenId);
1437         // Clear resolver (if any)
1438         if (_tokenResolvers[tokenId] != address(0x0)) {
1439             delete _tokenResolvers[tokenId];
1440         }
1441         // Clear metadata (if any)
1442         if (bytes(_tokenURIs[tokenId]).length != 0) {
1443             delete _tokenURIs[tokenId];
1444         }
1445     }
1446 
1447     function _resolveTo(address to, uint256 tokenId) internal {
1448         require(_exists(tokenId));
1449         emit Resolve(tokenId, to);
1450         _tokenResolvers[tokenId] = to;
1451     }
1452 
1453 }