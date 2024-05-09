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
31 // File: @openzeppelin/contracts/access/Roles.sol
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
70 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
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
116 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
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
192 // File: @animocabrands/contracts-inventory/contracts/token/ERC1155/ERC1155PausableCollections.sol
193 
194 pragma solidity =0.5.16;
195 
196 
197 contract ERC1155PausableCollections is Pausable {
198     event CollectionsPaused(uint256[] collectionIds, address pauser);
199     event CollectionsUnpaused(uint256[] collectionIds, address pauser);
200 
201     mapping(uint256 => bool) internal _pausedCollections;
202 
203     /**
204      * @dev Called by an admin to pause a list of collections.
205      */
206     function pauseCollections(uint256[] memory collectionIds) public;
207 
208     /**
209      * @dev Called by an admin to unpause a list of collection.
210      */
211     function unpauseCollections(uint256[] memory collectionIds) public;
212 }
213 
214 // File: @openzeppelin/contracts/math/SafeMath.sol
215 
216 pragma solidity ^0.5.0;
217 
218 /**
219  * @dev Wrappers over Solidity's arithmetic operations with added overflow
220  * checks.
221  *
222  * Arithmetic operations in Solidity wrap on overflow. This can easily result
223  * in bugs, because programmers usually assume that an overflow raises an
224  * error, which is the standard behavior in high level programming languages.
225  * `SafeMath` restores this intuition by reverting the transaction when an
226  * operation overflows.
227  *
228  * Using this library instead of the unchecked operations eliminates an entire
229  * class of bugs, so it's recommended to use it always.
230  */
231 library SafeMath {
232     /**
233      * @dev Returns the addition of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `+` operator.
237      *
238      * Requirements:
239      * - Addition cannot overflow.
240      */
241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
242         uint256 c = a + b;
243         require(c >= a, "SafeMath: addition overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, "SafeMath: subtraction overflow");
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
263      * overflow (when the result is negative).
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      * - Subtraction cannot overflow.
269      *
270      * _Available since v2.4.0._
271      */
272     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b <= a, errorMessage);
274         uint256 c = a - b;
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the multiplication of two unsigned integers, reverting on
281      * overflow.
282      *
283      * Counterpart to Solidity's `*` operator.
284      *
285      * Requirements:
286      * - Multiplication cannot overflow.
287      */
288     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
289         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
290         // benefit is lost if 'b' is also tested.
291         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
292         if (a == 0) {
293             return 0;
294         }
295 
296         uint256 c = a * b;
297         require(c / a == b, "SafeMath: multiplication overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers. Reverts on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      * - The divisor cannot be zero.
312      */
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         return div(a, b, "SafeMath: division by zero");
315     }
316 
317     /**
318      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
319      * division by zero. The result is rounded towards zero.
320      *
321      * Counterpart to Solidity's `/` operator. Note: this function uses a
322      * `revert` opcode (which leaves remaining gas untouched) while Solidity
323      * uses an invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      * - The divisor cannot be zero.
327      *
328      * _Available since v2.4.0._
329      */
330     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         // Solidity only automatically asserts when dividing by 0
332         require(b > 0, errorMessage);
333         uint256 c = a / b;
334         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
335 
336         return c;
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         return mod(a, b, "SafeMath: modulo by zero");
352     }
353 
354     /**
355      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
356      * Reverts with custom message when dividing by zero.
357      *
358      * Counterpart to Solidity's `%` operator. This function uses a `revert`
359      * opcode (which leaves remaining gas untouched) while Solidity uses an
360      * invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      * - The divisor cannot be zero.
364      *
365      * _Available since v2.4.0._
366      */
367     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
368         require(b != 0, errorMessage);
369         return a % b;
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Address.sol
374 
375 pragma solidity ^0.5.5;
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following 
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      */
398     function isContract(address account) internal view returns (bool) {
399         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
400         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
401         // for accounts without code, i.e. `keccak256('')`
402         bytes32 codehash;
403         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
404         // solhint-disable-next-line no-inline-assembly
405         assembly { codehash := extcodehash(account) }
406         return (codehash != accountHash && codehash != 0x0);
407     }
408 
409     /**
410      * @dev Converts an `address` into `address payable`. Note that this is
411      * simply a type cast: the actual underlying value is not changed.
412      *
413      * _Available since v2.4.0._
414      */
415     function toPayable(address account) internal pure returns (address payable) {
416         return address(uint160(account));
417     }
418 
419     /**
420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
421      * `recipient`, forwarding all available gas and reverting on errors.
422      *
423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
425      * imposed by `transfer`, making them unable to receive funds via
426      * `transfer`. {sendValue} removes this limitation.
427      *
428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
429      *
430      * IMPORTANT: because control is transferred to `recipient`, care must be
431      * taken to not create reentrancy vulnerabilities. Consider using
432      * {ReentrancyGuard} or the
433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
434      *
435      * _Available since v2.4.0._
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         // solhint-disable-next-line avoid-call-value
441         (bool success, ) = recipient.call.value(amount)("");
442         require(success, "Address: unable to send value, recipient may have reverted");
443     }
444 }
445 
446 // File: @openzeppelin/contracts/introspection/IERC165.sol
447 
448 pragma solidity ^0.5.0;
449 
450 /**
451  * @dev Interface of the ERC165 standard, as defined in the
452  * https://eips.ethereum.org/EIPS/eip-165[EIP].
453  *
454  * Implementers can declare support of contract interfaces, which can then be
455  * queried by others ({ERC165Checker}).
456  *
457  * For an implementation, see {ERC165}.
458  */
459 interface IERC165 {
460     /**
461      * @dev Returns true if this contract implements the interface defined by
462      * `interfaceId`. See the corresponding
463      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
464      * to learn more about how these ids are created.
465      *
466      * This function call must use less than 30 000 gas.
467      */
468     function supportsInterface(bytes4 interfaceId) external view returns (bool);
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
472 
473 pragma solidity ^0.5.0;
474 
475 /**
476  * @title ERC721 token receiver interface
477  * @dev Interface for any contract that wants to support safeTransfers
478  * from ERC721 asset contracts.
479  */
480 contract IERC721Receiver {
481     /**
482      * @notice Handle the receipt of an NFT
483      * @dev The ERC721 smart contract calls this function on the recipient
484      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
485      * otherwise the caller will revert the transaction. The selector to be
486      * returned can be obtained as `this.onERC721Received.selector`. This
487      * function MAY throw to revert and reject the transfer.
488      * Note: the ERC721 contract address is always the message sender.
489      * @param operator The address which called `safeTransferFrom` function
490      * @param from The address which previously owned the token
491      * @param tokenId The NFT identifier which is being transferred
492      * @param data Additional data with no specified format
493      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
494      */
495     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
496     public returns (bytes4);
497 }
498 
499 // File: @animocabrands/contracts-inventory/contracts/token/ERC721/IERC721.sol
500 
501 pragma solidity = 0.5.16;
502 
503  /**
504     @title ERC721 Non-Fungible Token Standard, basic interface
505     @dev See https://eips.ethereum.org/EIPS/eip-721
506     Note: The ERC-165 identifier for this interface is 0x80ac58cd.
507  */
508 contract IERC721 {
509     event Transfer(
510         address indexed _from,
511         address indexed _to,
512         uint256 indexed _tokenId
513     );
514 
515     event Approval(
516         address indexed _owner,
517         address indexed _approved,
518         uint256 indexed _tokenId
519     );
520 
521     event ApprovalForAll(
522         address indexed _owner,
523         address indexed _operator,
524         bool _approved
525     );
526 
527     /**
528      * @dev Gets the balance of the specified address
529      * @param owner address to query the balance of
530      * @return uint256 representing the amount owned by the passed address
531      */
532     function balanceOf(address owner) external view returns (uint256 balance);
533 
534     /**
535      * @dev Gets the owner of the specified ID
536      * @param tokenId uint256 ID to query the owner of
537      * @return owner address currently marked as the owner of the given ID
538      */
539     function ownerOf(uint256 tokenId) public view returns (address owner);
540 
541     /**
542      * @dev Approves another address to transfer the given token ID
543      * The zero address indicates there is no approved address.
544      * There can only be one approved address per token at a given time.
545      * Can only be called by the token owner or an approved operator.
546      * @param to address to be approved for the given token ID
547      * @param tokenId uint256 ID of the token to be approved
548      */
549     function approve(address to, uint256 tokenId) external;
550 
551     /**
552      * @dev Gets the approved address for a token ID, or zero if no address set
553      * Reverts if the token ID does not exist.
554      * @param tokenId uint256 ID of the token to query the approval of
555      * @return address currently approved for the given token ID
556      */
557     function getApproved(uint256 tokenId) public view returns (address operator);
558 
559     /**
560      * @dev Sets or unsets the approval of a given operator
561      * An operator is allowed to transfer all tokens of the sender on their behalf
562      * @param operator operator address to set the approval
563      * @param approved representing the status of the approval to be set
564      */
565     function setApprovalForAll(address operator, bool approved) external;
566 
567     /**
568      * @dev Tells whether an operator is approved by a given owner
569      * @param owner owner address which you want to query the approval of
570      * @param operator operator address which you want to query the approval of
571      * @return bool whether the given operator is approved by the given owner
572      */
573     function isApprovedForAll(address owner,address operator) external view returns (bool);
574 
575     /**
576      * @dev Transfers the ownership of a given token ID to another address
577      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
578      * Requires the msg sender to be the owner, approved, or operator
579      * @param from current owner of the token
580      * @param to address to receive the ownership of the given token ID
581      * @param tokenId uint256 ID of the token to be transferred
582     */
583     function transferFrom(address from, address to, uint256 tokenId) external;
584 
585     /**
586      * @dev Safely transfers the ownership of a given token ID to another address
587      * If the target address is a contract, it must implement `onERC721Received`,
588      * which is called upon a safe transfer, and return the magic value
589      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
590      * the transfer is reverted.
591      *
592      * Requires the msg sender to be the owner, approved, or operator
593      * @param from current owner of the token
594      * @param to address to receive the ownership of the given token ID
595      * @param tokenId uint256 ID of the token to be transferred
596     */
597     function safeTransferFrom(address from, address to, uint256 tokenId) external;
598 
599     /**
600      * @dev Safely transfers the ownership of a given token ID to another address
601      * If the target address is a contract, it must implement `onERC721Received`,
602      * which is called upon a safe transfer, and return the magic value
603      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
604      * the transfer is reverted.
605      * Requires the msg sender to be the owner, approved, or operator
606      * @param from current owner of the token
607      * @param to address to receive the ownership of the given token ID
608      * @param tokenId uint256 ID of the token to be transferred
609      * @param data bytes data to send along with a safe transfer check
610      */
611     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
612 }
613 
614 // File: @animocabrands/contracts-inventory/contracts/token/ERC721/IERC721Metadata.sol
615 
616 pragma solidity = 0.5.16;
617 
618  /**
619     @title ERC721 Non-Fungible Token Standard, optional metadata extension
620     @dev See https://eips.ethereum.org/EIPS/eip-721
621     Note: The ERC-165 identifier for this interface is 0x5b5e139f.
622  */
623 interface IERC721Metadata {
624 
625     /**
626      * @dev Gets the token name
627      * @return string representing the token name
628      */
629     function name() external view returns (string memory);
630 
631     /**
632      * @dev Gets the token symbol
633      * @return string representing the token symbol
634      */
635     function symbol() external view returns (string memory);
636 
637     /**
638      * @dev Returns an URI for a given token ID
639      * Throws if the token ID does not exist. May return an empty string.
640      * @param tokenId uint256 ID of the token to query
641      * @return string URI of given token ID
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 }
645 
646 // File: @animocabrands/contracts-inventory/contracts/token/ERC1155/IERC1155.sol
647 
648 pragma solidity = 0.5.16;
649 
650 /**
651     @title ERC-1155 Multi Token Standard, basic interface
652     @dev See https://eips.ethereum.org/EIPS/eip-1155
653     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
654  */
655 contract IERC1155 {
656 
657     event TransferSingle(
658         address indexed _operator,
659         address indexed _from,
660         address indexed _to,
661         uint256 _id,
662         uint256 _value
663     );
664 
665     event TransferBatch(
666         address indexed _operator,
667         address indexed _from,
668         address indexed _to,
669         uint256[] _ids,
670         uint256[] _values
671     );
672 
673     event ApprovalForAll(
674         address indexed _owner,
675         address indexed _operator,
676         bool _approved
677     );
678 
679     event URI(
680         string _value,
681         uint256 indexed _id
682     );
683 
684     /**
685         @notice Transfers `value` amount of an `id` from  `from` to `to`  (with safety call).
686         @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
687         MUST revert if `to` is the zero address.
688         MUST revert if balance of holder for token `id` is lower than the `value` sent.
689         MUST revert on any other error.
690         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
691         After the above conditions are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
692         @param from    Source address
693         @param to      Target address
694         @param id      ID of the token type
695         @param value   Transfer amount
696         @param data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`
697     */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 id,
702         uint256 value,
703         bytes memory data
704     ) public;
705 
706     /**
707         @notice Transfers `values` amount(s) of `ids` from the `from` address to the `to` address specified (with safety call).
708         @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
709         MUST revert if `to` is the zero address.
710         MUST revert if length of `ids` is not the same as length of `values`.
711         MUST revert if any of the balance(s) of the holder(s) for token(s) in `ids` is lower than the respective amount(s) in `values` sent to the recipient.
712         MUST revert on any other error.
713         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
714         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
715         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
716         @param from    Source address
717         @param to      Target address
718         @param ids     IDs of each token type (order and length must match _values array)
719         @param values  Transfer amounts per token type (order and length must match _ids array)
720         @param data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `to`
721     */
722     function safeBatchTransferFrom(
723         address from,
724         address to,
725         uint256[] memory ids,
726         uint256[] memory values,
727         bytes memory data
728     ) public;
729 
730     /**
731         @notice Get the balance of an account's tokens.
732         @param owner  The address of the token holder
733         @param id     ID of the token
734         @return        The _owner's balance of the token type requested
735      */
736     function balanceOf(address owner, uint256 id) public view returns (uint256);
737 
738     /**
739         @notice Get the balance of multiple account/token pairs
740         @param owners The addresses of the token holders
741         @param ids    ID of the tokens
742         @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
743      */
744     function balanceOfBatch(
745         address[] memory owners,
746         uint256[] memory ids
747     ) public view returns (uint256[] memory);
748 
749     /**
750         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
751         @dev MUST emit the ApprovalForAll event on success.
752         @param operator  Address to add to the set of authorized operators
753         @param approved  True if the operator is approved, false to revoke approval
754     */
755     function setApprovalForAll(address operator, bool approved) public;
756 
757     /**
758         @notice Queries the approval status of an operator for a given owner.
759         @param owner     The owner of the tokens
760         @param operator  Address of authorized operator
761         @return           True if the operator is approved, false if not
762     */
763     function isApprovedForAll(address owner, address operator) public view returns (bool);
764 }
765 
766 // File: @animocabrands/contracts-inventory/contracts/token/ERC1155/IERC1155MetadataURI.sol
767 
768 pragma solidity = 0.5.16;
769 
770 /**
771     @title ERC-1155 Multi Token Standard, optional metadata URI extension
772     @dev See https://eips.ethereum.org/EIPS/eip-1155
773     Note: The ERC-165 identifier for this interface is 0x0e89341c.
774  */
775 interface IERC1155MetadataURI {
776     /**
777         @notice A distinct Uniform Resource Identifier (URI) for a given token.
778         @dev URIs are defined in RFC 3986.
779         The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema". 
780         The uri function SHOULD be used to retrieve values if no event was emitted.
781         The uri function MUST return the same value as the latest event for an _id if it was emitted.
782         The uri function MUST NOT be used to check for the existence of a token as it is possible for an implementation to return a valid string even if the token does not exist.       
783         @return URI string
784     */
785     function uri(uint256 id) external view returns (string memory);
786 }
787 
788 // File: @animocabrands/contracts-inventory/contracts/token/ERC1155/IERC1155AssetCollections.sol
789 
790 pragma solidity = 0.5.16;
791 
792 
793 
794 /**
795     @title ERC-1155 Multi Token Standard, optional Asset Collections extension
796     @dev See https://eips.ethereum.org/EIPS/eip-xxxx
797     Interface for fungible/non-fungible collections management on a 1155-compliant contract.
798     This proposal attempts to rationalize the co-existence of fungible and non-fungible tokens
799     within the same contract. We consider that there can be up to several:
800     (a) Fungible Collections, each representing a supply of fungible token,
801     (b) Non-Fungible Collections, each representing a set of non-fungible tokens,
802     (c) Non-Fungible Tokens.
803 
804     `balanceOf` and `balanceOfBatch`:
805     - when applied to a Non-Fungible Collection, MAY return the balance of Non-Fungible Tokens for this collection,
806     - when applied to a Non-Fungible Token, SHOULD return 1.
807 
808     Note: The ERC-165 identifier for this interface is 0x09ce5c46.
809  */
810 contract IERC1155AssetCollections {
811 
812     /**
813         @dev Returns the parent collection ID of a Non-Fungible Token ID.
814         This function returns either a Fungible Collection ID or a Non-Fungible Collection ID.
815         This function SHOULD NOT be used to check the existence of a Non-Fungible Token.
816         This function MAY return a value for a non-existing Non-Fungible Token.
817         @param id The ID to query. id must represent an existing/non-existing Non-Fungible Token, else it throws.
818         @return uint256 the parent collection ID.
819      */
820     function collectionOf(uint256 id) public view returns (uint256);
821 
822     /**
823         @dev Returns whether or not an ID represents a Fungible Collection.
824         @param id The ID to query.
825         @return bool true if id represents a Fungible Collection, false otherwise.
826     */
827     function isFungible(uint256 id) public view returns (bool);
828 
829     /**
830        @dev Returns the owner of a Non-Fungible Token.
831        @param tokenId The ID to query. MUST represent an existing Non-Fungible Token, else it throws.
832        @return owner address currently marked as the owner of the Non-Fungible Token.
833      */
834     function ownerOf(uint256 tokenId) public view returns (address owner);
835 }
836 
837 // File: @animocabrands/contracts-inventory/contracts/token/ERC1155/IERC1155TokenReceiver.sol
838 
839 pragma solidity = 0.5.16;
840 
841 /**
842     @title ERC-1155 Multi Token Standard, token receiver
843     @dev See https://eips.ethereum.org/EIPS/eip-1155
844     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
845  */
846 interface IERC1155TokenReceiver {
847     /**
848         @notice Handle the receipt of a single ERC1155 token type.
849         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
850         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
851         This function MUST revert if it rejects the transfer.
852         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
853         @param operator  The address which initiated the transfer (i.e. msg.sender)
854         @param from      The address which previously owned the token
855         @param id        The ID of the token being transferred
856         @param value     The amount of tokens being transferred
857         @param data      Additional data with no specified format
858         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
859     */
860     function onERC1155Received(
861         address operator,
862         address from,
863         uint256 id,
864         uint256 value,
865         bytes calldata data
866     ) external returns (bytes4);
867 
868     /**
869         @notice Handle the receipt of multiple ERC1155 token types.
870         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
871         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
872         This function MUST revert if it rejects the transfer(s).
873         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
874         @param operator  The address which initiated the batch transfer (i.e. msg.sender)
875         @param from      The address which previously owned the token
876         @param ids       An array containing ids of each token being transferred (order and length must match _values array)
877         @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
878         @param data      Additional data with no specified format
879         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
880     */
881     function onERC1155BatchReceived(
882         address operator,
883         address from,
884         uint256[] calldata ids,
885         uint256[] calldata values,
886         bytes calldata data
887     ) external returns (bytes4);
888 }
889 
890 // File: @animocabrands/contracts-inventory/contracts/token/ERC1155721/AssetsInventory.sol
891 
892 pragma solidity = 0.5.16;
893 
894 
895 
896 
897 
898 
899 
900 
901 
902 
903 
904 
905 /**
906     @title AssetsInventory, a contract which manages up to multiple collections of fungible and non-fungible tokens
907     @dev In this implementation, with N representing the non-fungible bitmask length, IDs are composed as follow:
908     (a) Fungible Collection IDs:
909         - most significant bit == 0
910     (b) Non-Fungible Collection IDs:
911         - most significant bit == 1
912         - (256-N) least significant bits == 0
913     (c) Non-Fungible Token IDs:
914         - most significant bit == 1
915         - (256-N) least significant bits != 0
916 
917     If non-fungible bitmask length == 0, all the IDs represent a Fungible Collection.
918     If non-fungible bitmask length == 1, there is one Non-Fungible Collection represented by the most significant bit set to 1 and other bits set to 0.
919     If non-fungible bitmask length > 1, there are multiple Non-Fungible Collections.
920  */
921 contract AssetsInventory is IERC165, IERC721, IERC1155, IERC1155AssetCollections, IERC721Metadata, IERC1155MetadataURI, Context
922 {
923     // id (collection) => owner => balance
924     mapping(uint256 => mapping(address => uint256)) internal _balances;
925 
926     // owner => operator => approved
927     mapping(address => mapping(address => bool)) internal _operatorApprovals;
928 
929     // id (nft) => operator
930     mapping(uint256 => address) internal _tokenApprovals;
931 
932     // id (collection or nft) => owner
933     mapping(uint256 => address) internal _owners;
934 
935     // owner => nb nfts owned
936     mapping(address => uint256) internal _nftBalances;
937 
938     // Mask for the non-fungible flag in ids
939     uint256 internal constant NF_BIT_MASK = 1 << 255;
940 
941     // Mask for non-fungible collection in ids (it includes the nf bit)
942     uint256 internal NF_COLLECTION_MASK;
943 
944     /**
945      * @dev Constructor function
946      * @param nfMaskLength number of bits in the Non-Fungible Collection mask
947      * if nfMaskLength == 0, the contract doesn't support non-fungible tokens
948      * if nfMaskLength == 1, the single non-fungible collection which is represented by only the non-fungible bit set to 1
949      * if nfMaskLength > 1, there are several 
950      */
951     constructor(uint256 nfMaskLength) public {
952         require(nfMaskLength < 256);
953         if (nfMaskLength == 0) {
954             NF_COLLECTION_MASK = 0;
955         } else {
956             uint256 mask = (1 << nfMaskLength) - 1;
957             mask = mask << (256 - nfMaskLength);
958             NF_COLLECTION_MASK = mask;
959         }
960     }
961 
962 /////////////////////////////////////////// ERC165 /////////////////////////////////////////////
963 
964     /**
965      * @dev Check if support an interface id
966      * @param interfaceId interface id to query
967      * @return bool if support the given interface id
968      */
969     function supportsInterface(bytes4 interfaceId) public view returns (bool) {
970         return (
971             // ERC165 interface id
972             interfaceId == 0x01ffc9a7 ||
973             // ERC721 interface id
974             interfaceId == 0x80ac58cd ||
975             // ERC721Metadata interface id
976             interfaceId == 0x5b5e139f ||
977             // ERC721Exists interface id
978             interfaceId == 0x4f558e79 ||
979             // ERC1155 interface id
980             interfaceId == 0xd9b67a26 ||
981             // ERC1155AssetCollections interface id
982             interfaceId == 0x09ce5c46 ||
983             // ERC1155MetadataURI interface id
984             interfaceId == 0x0e89341c
985         );
986     }
987 /////////////////////////////////////////// ERC721 /////////////////////////////////////////////
988 
989     function balanceOf(address tokenOwner) public view returns (uint256) {
990         require(tokenOwner != address(0x0));
991         return _nftBalances[tokenOwner];
992     }
993 
994     function ownerOf(uint256 tokenId) public view returns (address) {
995         require(isNFT(tokenId));
996         address tokenOwner = _owners[tokenId];
997         require(tokenOwner != address(0x0));
998         return tokenOwner;
999     }
1000 
1001     function approve(address to, uint256 tokenId) public {
1002         address tokenOwner = ownerOf(tokenId);
1003         require(to != tokenOwner); // solium-disable-line error-reason
1004 
1005         address sender = _msgSender();
1006         require(sender == tokenOwner || _operatorApprovals[tokenOwner][sender]); // solium-disable-line error-reason
1007 
1008         _tokenApprovals[tokenId] = to;
1009         emit Approval(tokenOwner, to, tokenId);
1010     }
1011 
1012     function getApproved(uint256 tokenId) public view returns (address) {
1013         require(isNFT(tokenId) && exists(tokenId));
1014         return _tokenApprovals[tokenId];
1015     }
1016 
1017     function setApprovalForAll(address to, bool approved) public {
1018         address sender = _msgSender();
1019         require(to != sender);
1020         _setApprovalForAll(sender, to, approved);
1021     }
1022 
1023     function _setApprovalForAll(address sender, address operator, bool approved) internal {
1024         _operatorApprovals[sender][operator] = approved;
1025         emit ApprovalForAll(sender, operator, approved);
1026     }
1027 
1028     function isApprovedForAll(address tokenOwner, address operator) public view returns (bool) {
1029         return _operatorApprovals[tokenOwner][operator];
1030     }
1031 
1032     function transferFrom(address from, address to, uint256 tokenId) public {
1033         _transferFrom(from, to, tokenId, "", false);
1034     }
1035 
1036     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1037         _transferFrom(from, to, tokenId, "", true);
1038     }
1039 
1040     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
1041         _transferFrom(from, to, tokenId, data, true);
1042     }
1043 
1044 
1045 
1046 /////////////////////////////////////////// ERC1155 /////////////////////////////////////////////
1047 
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 id,
1052         uint256 value,
1053         bytes memory data
1054     ) public
1055     {
1056         require(to != address(0x0));
1057 
1058         address sender = _msgSender();
1059         bool operatable = (from == sender || _operatorApprovals[from][sender] == true);
1060 
1061         if (isFungible(id) && value > 0) {
1062             require(operatable);
1063             _transferFungible(from, to, id, value);
1064         } else if (isNFT(id) && value == 1) {
1065             _transferNonFungible(from, to, id, operatable);
1066             emit Transfer(from, to, id);
1067         } else {
1068             revert();
1069         }
1070 
1071         emit TransferSingle(sender, from, to, id, value);
1072         require(_checkERC1155AndCallSafeTransfer(sender, from, to, id, value, data, false, false));
1073     }
1074 
1075     function safeBatchTransferFrom(
1076         address from,
1077         address to,
1078         uint256[] memory ids,
1079         uint256[] memory values,
1080         bytes memory data
1081     ) public
1082     {
1083         require(to != address(0x0));
1084         require(ids.length == values.length);
1085 
1086         // Only supporting a global operator approval allows to do a single check and not to touch storage to handle allowances.
1087         address sender = _msgSender();
1088         require(from == sender || _operatorApprovals[from][sender] == true);
1089 
1090         for (uint256 i = 0; i < ids.length; ++i) {
1091             uint256 id = ids[i];
1092             uint256 value = values[i];
1093 
1094             if (isFungible(id) && value > 0) {
1095                 _transferFungible(from, to, id, value);
1096             } else if (isNFT(id) && value == 1) {
1097                 _transferNonFungible(from, to, id, true);
1098                 emit Transfer(from, to, id);
1099             } else {
1100                 revert();
1101             }
1102         }
1103 
1104         emit TransferBatch(sender, from, to, ids, values);
1105         require(_checkERC1155AndCallSafeBatchTransfer(sender, from, to, ids, values, data));
1106     }
1107 
1108     function balanceOf(address tokenOwner, uint256 id) public view returns (uint256) {
1109         require(tokenOwner != address(0x0));
1110 
1111         if (isNFT(id)) {
1112             return _owners[id] == tokenOwner ? 1 : 0;
1113         }
1114     
1115         return _balances[id][tokenOwner];
1116     }
1117 
1118     function balanceOfBatch(
1119         address[] memory tokenOwners,
1120         uint256[] memory ids
1121     ) public view returns (uint256[] memory)
1122     {
1123         require(tokenOwners.length == ids.length);
1124 
1125         uint256[] memory balances = new uint256[](tokenOwners.length);
1126 
1127         for (uint256 i = 0; i < tokenOwners.length; ++i) {
1128             require(tokenOwners[i] != address(0x0));
1129 
1130             uint256 id = ids[i];
1131 
1132             if (isNFT(id)) {
1133                 balances[i] = _owners[id] == tokenOwners[i] ? 1 : 0;
1134             } else {
1135                 balances[i] = _balances[id][tokenOwners[i]];
1136             }
1137         }
1138 
1139         return balances;
1140     }
1141 
1142 /////////////////////////////////////////// ERC1155AssetCollections /////////////////////////////////////////////
1143 
1144     function collectionOf(uint256 id) public view returns (uint256) {
1145         require(isNFT(id));
1146         return id & NF_COLLECTION_MASK;
1147     }
1148 
1149     /**
1150         @dev Tells whether an id represents a fungible collection
1151         @param id The ID to query
1152         @return bool whether the given id is fungible
1153      */
1154     function isFungible(uint256 id) public view returns (bool) {
1155         return id & (NF_BIT_MASK) == 0;
1156     }
1157 
1158     /**
1159         @dev Tells whether an id represents a non-fungible token
1160         @param id The ID to query
1161         @return bool whether the given id is non-fungible token
1162      */
1163     function isNFT(uint256 id) internal view returns (bool) {
1164         // A base type has the NF bit and an index
1165         return (id & (NF_BIT_MASK) != 0) && (id & (~NF_COLLECTION_MASK) != 0);
1166     }
1167 
1168     /**
1169      * @dev Returns whether the NFT belongs to someone
1170      * @param id uint256 ID of the NFT
1171      * @return whether the NFT belongs to someone
1172      */
1173     function exists(uint256 id) public view returns (bool) {
1174         address tokenOwner = _owners[id];
1175         return tokenOwner != address(0x0);
1176     }
1177 
1178 /////////////////////////////////////////// Transfer Internal Functions ///////////////////////////////////////
1179 
1180     /**
1181      * @dev Internal function to transfer the ownership of a given NFT to another address
1182      * Emits Transfer and TransferSingle events
1183      * Requires the msg sender to be the owner, approved, or operator
1184      * @param from current owner of the token
1185      * @param to address to receive the ownership of the given token ID
1186      * @param tokenId uint256 ID of the token to be transferred
1187      * @param safe bool to indicate whether the transfer is safe
1188     */
1189     function _transferFrom(address from, address to, uint256 tokenId, bytes memory data, bool safe) internal {
1190         require(to != address(0x0));
1191         require(isNFT(tokenId));
1192 
1193         address sender = _msgSender();
1194         bool operatable = (from == sender || _operatorApprovals[from][sender] == true);
1195 
1196         _transferNonFungible(from, to, tokenId, operatable);
1197 
1198         emit Transfer(from, to, tokenId);
1199         emit TransferSingle(sender, from, to, tokenId, 1);
1200 
1201         require(_checkERC1155AndCallSafeTransfer(sender, from, to, tokenId, 1, data, true, safe));
1202     }
1203 
1204     /**
1205      * @dev Internal function to transfer the ownership of a given token ID to another address
1206      * Requires the msg sender to be the owner, approved, or operator
1207      * @param from current owner of the token
1208      * @param to address to receive the ownership of the given token ID
1209      * @param id uint256 ID of the token to be transferred
1210      * @param operatable bool to indicate whether the msg sender is operator
1211     */
1212     function _transferNonFungible(address from, address to, uint256 id, bool operatable) internal {
1213         require(from == _owners[id]);
1214 
1215         address sender = _msgSender();
1216         require(operatable || ownerOf(id) == sender || getApproved(id) == sender);
1217 
1218         // clear approval
1219         if (_tokenApprovals[id] != address(0x0)) {
1220             _tokenApprovals[id] = address(0x0);
1221         }
1222 
1223         uint256 nfCollection = id & NF_COLLECTION_MASK;
1224         _balances[nfCollection][from] = SafeMath.sub(_balances[nfCollection][from], 1);
1225         _balances[nfCollection][to] = SafeMath.add(_balances[nfCollection][to], 1);
1226     
1227         _nftBalances[from] = SafeMath.sub(_nftBalances[from], 1);
1228         _nftBalances[to] = SafeMath.add(_nftBalances[to], 1);
1229     
1230         _owners[id] = to;
1231     }
1232 
1233     /**
1234      * @dev Internal function to move `collectionId` fungible tokens `value` from `from` to `to`.
1235      * @param from current owner of the `collectionId` fungible token
1236      * @param to address to receive the ownership of the given `collectionId` fungible token
1237      * @param collectionId uint256 ID of the fungible token to be transferred
1238      * @param value uint256 transfer amount
1239      */
1240     function _transferFungible(address from, address to, uint256 collectionId, uint256 value) internal {
1241         _balances[collectionId][from] = SafeMath.sub(_balances[collectionId][from], value);
1242         _balances[collectionId][to] = SafeMath.add(_balances[collectionId][to], value);
1243     }
1244 
1245 /////////////////////////////////////////// Receiver Internal Functions ///////////////////////////////////////
1246 
1247     /**
1248      * @dev public function to invoke `onERC721Received` on a target address
1249      * The call is not executed if the target address is not a contract
1250      * @param operator transfer msg sender
1251      * @param from address representing the previous owner of the given token ID
1252      * @param to target address that will receive the token
1253      * @param tokenId uint256 ID of the token to be transferred
1254      * @param data bytes optional data to send along with the call
1255      * @return whether the call correctly returned the expected magic value
1256      */
1257     function _checkERC721AndCallSafeTransfer(
1258         address operator,
1259         address from,
1260         address to,
1261         uint256 tokenId,
1262         bytes memory data
1263     ) internal returns(bool)
1264     {
1265         if (!Address.isContract(to)) {
1266             return true;
1267         }
1268         return (IERC721Receiver(to).onERC721Received(operator, from, tokenId, data) == 0x150b7a02); // 0x150b7a02: ERC721 receive magic value
1269     }
1270 
1271     /**
1272      * @dev public function to invoke `onERC1155Received` on a target address
1273      * The call is not executed if the target address is not a contract
1274      * @param operator transfer msg sender
1275      * @param from address representing the previous owner of the given ID
1276      * @param to target address that will receive the token
1277      * @param id uint256 ID of the `non-fungible token / non-fungible collection / fungible collection` to be transferred
1278      * @param data bytes optional data to send along with the call
1279      * @param erc721 bool whether transfer to ERC721 contract
1280      * @param erc721Safe bool whether transfer to ERC721 contract safely
1281      * @return whether the call correctly returned the expected magic value
1282      */
1283     function _checkERC1155AndCallSafeTransfer(
1284         address operator,
1285         address from,
1286         address to,
1287         uint256 id,
1288         uint256 value,
1289         bytes memory data,
1290         bool erc721,
1291         bool erc721Safe
1292     ) internal returns (bool)
1293     {
1294         if (!Address.isContract(to)) {
1295             return true;
1296         }
1297         if (erc721) {
1298             if (!_checkIsERC1155Receiver(to)) {
1299                 if (erc721Safe) {
1300                     return _checkERC721AndCallSafeTransfer(operator, from, to, id, data);
1301                 } else {
1302                     return true;
1303                 }
1304             }
1305         }
1306         return IERC1155TokenReceiver(to).onERC1155Received(operator, from, id, value, data) == 0xf23a6e61; // 0xf23a6e61: ERC1155 receive magic value
1307     }
1308 
1309     /**
1310      * @dev public function to invoke `onERC1155BatchReceived` on a target address
1311      * The call is not executed if the target address is not a contract
1312      * @param operator transfer msg sender
1313      * @param from address representing the previous owner of the given IDs
1314      * @param to target address that will receive the tokens
1315      * @param ids uint256 ID of the `non-fungible token / non-fungible collection / fungible collection` to be transferred
1316      * @param values uint256 transfer amounts of the `non-fungible token / non-fungible collection / fungible collection`
1317      * @param data bytes optional data to send along with the call
1318      * @return whether the call correctly returned the expected magic value
1319      */
1320     function _checkERC1155AndCallSafeBatchTransfer(
1321         address operator,
1322         address from,
1323         address to,
1324         uint256[] memory ids,
1325         uint256[] memory values,
1326         bytes memory data
1327     ) internal returns (bool)
1328     {
1329         if (!Address.isContract(to)) {
1330             return true;
1331         }
1332         bytes4 retval = IERC1155TokenReceiver(to).onERC1155BatchReceived(operator, from, ids, values, data);
1333         return (retval == 0xbc197c81); // 0xbc197c81: ERC1155 batch receive magic value
1334     }
1335 
1336     /**
1337      * @dev public function to tell wheter a contract is ERC1155 Receiver contract
1338      * @param _contract address query contract addrss
1339      * @return wheter the given contract is ERC1155 Receiver contract
1340      */
1341     function _checkIsERC1155Receiver(address _contract) internal view returns(bool) {
1342         bytes4 erc1155ReceiverID = 0x4e2312e0;
1343         bytes4 INTERFACE_ID_ERC165 = 0x01ffc9a7;
1344         bool success;
1345         uint256 result;
1346         // solium-disable-next-line security/no-inline-assembly
1347         assembly {
1348             let x:= mload(0x40)               // Find empty storage location using "free memory pointer"
1349             mstore(x, INTERFACE_ID_ERC165)                // Place signature at beginning of empty storage
1350             mstore(add(x, 0x04), erc1155ReceiverID) // Place first argument directly next to signature
1351 
1352             success:= staticcall(
1353                 10000,          // 10k gas
1354                 _contract,     // To addr
1355                 x,             // Inputs are stored at location x
1356                 0x24,          // Inputs are 36 bytes long
1357                 x,             // Store output over input (saves space)
1358                 0x20)          // Outputs are 32 bytes long
1359 
1360             result:= mload(x)                 // Load the result
1361         }
1362         // (10000 / 63) "not enough for supportsInterface(...)" // consume all gas, so caller can potentially know that there was not enough gas
1363         assert(gasleft() > 158);
1364         return success && result == 1;
1365     }
1366 }
1367 
1368 // File: @animocabrands/contracts-inventory/contracts/token/ERC1155721/PausableInventory.sol
1369 
1370 pragma solidity = 0.5.16;
1371 
1372 
1373 
1374 /**
1375     @title PausableInventory,an inventory contract with pausable collections
1376     @dev See https://
1377     Note: .
1378  */
1379 contract PausableInventory is AssetsInventory, ERC1155PausableCollections
1380 {
1381 
1382     constructor(uint256 nfMaskLength) public AssetsInventory(nfMaskLength)  {}
1383 
1384 /////////////////////////////////////////// ERC1155PausableCollections /////////////////////////////////////////////
1385 
1386     modifier whenIdPaused(uint256 id) {
1387         require(idPaused(id));
1388         _;
1389     }
1390 
1391     modifier whenIdNotPaused(uint256 id) {
1392         require(!idPaused(id)                                                                                            );
1393         _;
1394     }
1395 
1396     function idPaused(uint256 id) public view returns (bool) {
1397         if (isNFT(id)) {
1398             return _pausedCollections[collectionOf(id)];
1399         } else {
1400             return _pausedCollections[id];
1401         }
1402     }
1403 
1404     function pauseCollections(uint256[] memory collectionIds) public onlyPauser {
1405         for (uint256 i=0; i<collectionIds.length; i++) {
1406             uint256 collectionId = collectionIds[i];
1407             require(!isNFT(collectionId)); // only works on collections
1408             _pausedCollections[collectionId] = true;
1409         }
1410         emit CollectionsPaused(collectionIds, _msgSender());
1411     }
1412 
1413     function unpauseCollections(uint256[] memory collectionIds) public onlyPauser {
1414         for (uint256 i=0; i<collectionIds.length; i++) {
1415             uint256 collectionId = collectionIds[i];
1416             require(!isNFT(collectionId)); // only works on collections
1417             _pausedCollections[collectionId] = false;
1418         }
1419         emit CollectionsUnpaused(collectionIds, _msgSender());
1420     }
1421 
1422 
1423 /////////////////////////////////////////// ERC721 /////////////////////////////////////////////
1424 
1425     function approve(address to, uint256 tokenId
1426     ) public whenNotPaused whenIdNotPaused(tokenId) {
1427         super.approve(to, tokenId);
1428     }
1429 
1430     function setApprovalForAll(address to, bool approved
1431     ) public whenNotPaused {
1432         super.setApprovalForAll(to, approved);
1433     }
1434 
1435     function transferFrom(address from, address to, uint256 tokenId
1436     ) public whenNotPaused whenIdNotPaused(tokenId) {
1437         super.transferFrom(from, to, tokenId);
1438     }
1439 
1440     function safeTransferFrom(address from, address to, uint256 tokenId
1441     ) public whenNotPaused whenIdNotPaused(tokenId) {
1442         super.safeTransferFrom(from, to, tokenId);
1443     }
1444 
1445     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data
1446     ) public whenNotPaused whenIdNotPaused(tokenId) {
1447         super.safeTransferFrom(from, to, tokenId, data);
1448     }
1449 
1450 /////////////////////////////////////////// ERC1155 /////////////////////////////////////////////
1451 
1452     function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data
1453     ) public whenNotPaused whenIdNotPaused(id) {
1454         super.safeTransferFrom(from, to, id, value, data);
1455     }
1456 
1457     function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory values, bytes memory data
1458     ) public whenNotPaused {
1459         for (uint256 i = 0; i < ids.length; ++i) {
1460             require(!idPaused(ids[i]));
1461         }
1462         super.safeBatchTransferFrom(from, to, ids, values, data);
1463     }
1464 }
1465 
1466 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
1467 
1468 pragma solidity ^0.5.0;
1469 
1470 /**
1471  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
1472  *
1473  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
1474  */
1475 interface IRelayRecipient {
1476     /**
1477      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
1478      */
1479     function getHubAddr() external view returns (address);
1480 
1481     /**
1482      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
1483      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
1484      *
1485      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
1486      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
1487      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
1488      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
1489      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
1490      * over all or some of the previous values.
1491      *
1492      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
1493      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
1494      *
1495      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
1496      * rejected. A regular revert will also trigger a rejection.
1497      */
1498     function acceptRelayedCall(
1499         address relay,
1500         address from,
1501         bytes calldata encodedFunction,
1502         uint256 transactionFee,
1503         uint256 gasPrice,
1504         uint256 gasLimit,
1505         uint256 nonce,
1506         bytes calldata approvalData,
1507         uint256 maxPossibleCharge
1508     )
1509         external
1510         view
1511         returns (uint256, bytes memory);
1512 
1513     /**
1514      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
1515      * pre-charge the sender of the transaction.
1516      *
1517      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
1518      *
1519      * Returns a value to be passed to {postRelayedCall}.
1520      *
1521      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
1522      * will not be executed, but the recipient will still be charged for the transaction's cost.
1523      */
1524     function preRelayedCall(bytes calldata context) external returns (bytes32);
1525 
1526     /**
1527      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
1528      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
1529      * contract-specific bookkeeping.
1530      *
1531      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
1532      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
1533      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
1534      *
1535      *
1536      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
1537      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
1538      * transaction's cost.
1539      */
1540     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
1541 }
1542 
1543 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
1544 
1545 pragma solidity ^0.5.0;
1546 
1547 /**
1548  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
1549  * directly.
1550  *
1551  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
1552  * how to deploy an instance of `RelayHub` on your local test network.
1553  */
1554 interface IRelayHub {
1555     // Relay management
1556 
1557     /**
1558      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
1559      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
1560      * cannot be its own owner.
1561      *
1562      * All Ether in this function call will be added to the relay's stake.
1563      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
1564      *
1565      * Emits a {Staked} event.
1566      */
1567     function stake(address relayaddr, uint256 unstakeDelay) external payable;
1568 
1569     /**
1570      * @dev Emitted when a relay's stake or unstakeDelay are increased
1571      */
1572     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
1573 
1574     /**
1575      * @dev Registers the caller as a relay.
1576      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
1577      *
1578      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
1579      * `transactionFee` is not enforced by {relayCall}.
1580      *
1581      * Emits a {RelayAdded} event.
1582      */
1583     function registerRelay(uint256 transactionFee, string calldata url) external;
1584 
1585     /**
1586      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
1587      * {RelayRemoved} events) lets a client discover the list of available relays.
1588      */
1589     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
1590 
1591     /**
1592      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
1593      *
1594      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
1595      * callable.
1596      *
1597      * Emits a {RelayRemoved} event.
1598      */
1599     function removeRelayByOwner(address relay) external;
1600 
1601     /**
1602      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
1603      */
1604     event RelayRemoved(address indexed relay, uint256 unstakeTime);
1605 
1606     /** Deletes the relay from the system, and gives back its stake to the owner.
1607      *
1608      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
1609      *
1610      * Emits an {Unstaked} event.
1611      */
1612     function unstake(address relay) external;
1613 
1614     /**
1615      * @dev Emitted when a relay is unstaked for, including the returned stake.
1616      */
1617     event Unstaked(address indexed relay, uint256 stake);
1618 
1619     // States a relay can be in
1620     enum RelayState {
1621         Unknown, // The relay is unknown to the system: it has never been staked for
1622         Staked, // The relay has been staked for, but it is not yet active
1623         Registered, // The relay has registered itself, and is active (can relay calls)
1624         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
1625     }
1626 
1627     /**
1628      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
1629      * to return an empty entry.
1630      */
1631     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
1632 
1633     // Balance management
1634 
1635     /**
1636      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
1637      *
1638      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
1639      *
1640      * Emits a {Deposited} event.
1641      */
1642     function depositFor(address target) external payable;
1643 
1644     /**
1645      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
1646      */
1647     event Deposited(address indexed recipient, address indexed from, uint256 amount);
1648 
1649     /**
1650      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
1651      */
1652     function balanceOf(address target) external view returns (uint256);
1653 
1654     /**
1655      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
1656      * contracts can use it to reduce their funding.
1657      *
1658      * Emits a {Withdrawn} event.
1659      */
1660     function withdraw(uint256 amount, address payable dest) external;
1661 
1662     /**
1663      * @dev Emitted when an account withdraws funds from `RelayHub`.
1664      */
1665     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
1666 
1667     // Relaying
1668 
1669     /**
1670      * @dev Checks if the `RelayHub` will accept a relayed operation.
1671      * Multiple things must be true for this to happen:
1672      *  - all arguments must be signed for by the sender (`from`)
1673      *  - the sender's nonce must be the current one
1674      *  - the recipient must accept this transaction (via {acceptRelayedCall})
1675      *
1676      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
1677      * code if it returns one in {acceptRelayedCall}.
1678      */
1679     function canRelay(
1680         address relay,
1681         address from,
1682         address to,
1683         bytes calldata encodedFunction,
1684         uint256 transactionFee,
1685         uint256 gasPrice,
1686         uint256 gasLimit,
1687         uint256 nonce,
1688         bytes calldata signature,
1689         bytes calldata approvalData
1690     ) external view returns (uint256 status, bytes memory recipientContext);
1691 
1692     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
1693     enum PreconditionCheck {
1694         OK,                         // All checks passed, the call can be relayed
1695         WrongSignature,             // The transaction to relay is not signed by requested sender
1696         WrongNonce,                 // The provided nonce has already been used by the sender
1697         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
1698         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
1699     }
1700 
1701     /**
1702      * @dev Relays a transaction.
1703      *
1704      * For this to succeed, multiple conditions must be met:
1705      *  - {canRelay} must `return PreconditionCheck.OK`
1706      *  - the sender must be a registered relay
1707      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
1708      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
1709      * recipient) use all gas available to them
1710      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
1711      * spent)
1712      *
1713      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
1714      * function and {postRelayedCall} will be called in that order.
1715      *
1716      * Parameters:
1717      *  - `from`: the client originating the request
1718      *  - `to`: the target {IRelayRecipient} contract
1719      *  - `encodedFunction`: the function call to relay, including data
1720      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
1721      *  - `gasPrice`: gas price the client is willing to pay
1722      *  - `gasLimit`: gas to forward when calling the encoded function
1723      *  - `nonce`: client's nonce
1724      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
1725      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
1726      * `RelayHub`, but it still can be used for e.g. a signature.
1727      *
1728      * Emits a {TransactionRelayed} event.
1729      */
1730     function relayCall(
1731         address from,
1732         address to,
1733         bytes calldata encodedFunction,
1734         uint256 transactionFee,
1735         uint256 gasPrice,
1736         uint256 gasLimit,
1737         uint256 nonce,
1738         bytes calldata signature,
1739         bytes calldata approvalData
1740     ) external;
1741 
1742     /**
1743      * @dev Emitted when an attempt to relay a call failed.
1744      *
1745      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
1746      * actual relayed call was not executed, and the recipient not charged.
1747      *
1748      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
1749      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
1750      */
1751     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
1752 
1753     /**
1754      * @dev Emitted when a transaction is relayed. 
1755      * Useful when monitoring a relay's operation and relayed calls to a contract
1756      *
1757      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
1758      *
1759      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
1760      */
1761     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
1762 
1763     // Reason error codes for the TransactionRelayed event
1764     enum RelayCallStatus {
1765         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
1766         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
1767         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
1768         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
1769         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
1770     }
1771 
1772     /**
1773      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
1774      * spend up to `relayedCallStipend` gas.
1775      */
1776     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
1777 
1778     /**
1779      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
1780      */
1781     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
1782 
1783      // Relay penalization. 
1784      // Any account can penalize relays, removing them from the system immediately, and rewarding the
1785     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
1786     // still loses half of its stake.
1787 
1788     /**
1789      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
1790      * different data (gas price, gas limit, etc. may be different).
1791      *
1792      * The (unsigned) transaction data and signature for both transactions must be provided.
1793      */
1794     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
1795 
1796     /**
1797      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
1798      */
1799     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
1800 
1801     /**
1802      * @dev Emitted when a relay is penalized.
1803      */
1804     event Penalized(address indexed relay, address sender, uint256 amount);
1805 
1806     /**
1807      * @dev Returns an account's nonce in `RelayHub`.
1808      */
1809     function getNonce(address from) external view returns (uint256);
1810 }
1811 
1812 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
1813 
1814 pragma solidity ^0.5.0;
1815 
1816 
1817 
1818 
1819 /**
1820  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
1821  * and enables GSN support on all contracts in the inheritance tree.
1822  *
1823  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
1824  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
1825  * provided by derived contracts. See the
1826  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
1827  * information on how to use the pre-built {GSNRecipientSignature} and
1828  * {GSNRecipientERC20Fee}, or how to write your own.
1829  */
1830 contract GSNRecipient is IRelayRecipient, Context {
1831     // Default RelayHub address, deployed on mainnet and all testnets at the same address
1832     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
1833 
1834     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
1835     uint256 constant private RELAYED_CALL_REJECTED = 11;
1836 
1837     // How much gas is forwarded to postRelayedCall
1838     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
1839 
1840     /**
1841      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
1842      */
1843     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
1844 
1845     /**
1846      * @dev Returns the address of the {IRelayHub} contract for this recipient.
1847      */
1848     function getHubAddr() public view returns (address) {
1849         return _relayHub;
1850     }
1851 
1852     /**
1853      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
1854      * use the default instance.
1855      *
1856      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
1857      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
1858      */
1859     function _upgradeRelayHub(address newRelayHub) internal {
1860         address currentRelayHub = _relayHub;
1861         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
1862         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
1863 
1864         emit RelayHubChanged(currentRelayHub, newRelayHub);
1865 
1866         _relayHub = newRelayHub;
1867     }
1868 
1869     /**
1870      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
1871      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
1872      */
1873     // This function is view for future-proofing, it may require reading from
1874     // storage in the future.
1875     function relayHubVersion() public view returns (string memory) {
1876         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1877         return "1.0.0";
1878     }
1879 
1880     /**
1881      * @dev Withdraws the recipient's deposits in `RelayHub`.
1882      *
1883      * Derived contracts should expose this in an external interface with proper access control.
1884      */
1885     function _withdrawDeposits(uint256 amount, address payable payee) internal {
1886         IRelayHub(_relayHub).withdraw(amount, payee);
1887     }
1888 
1889     // Overrides for Context's functions: when called from RelayHub, sender and
1890     // data require some pre-processing: the actual sender is stored at the end
1891     // of the call data, which in turns means it needs to be removed from it
1892     // when handling said data.
1893 
1894     /**
1895      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1896      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
1897      *
1898      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1899      */
1900     function _msgSender() internal view returns (address payable) {
1901         if (msg.sender != _relayHub) {
1902             return msg.sender;
1903         } else {
1904             return _getRelayedCallSender();
1905         }
1906     }
1907 
1908     /**
1909      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1910      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1911      *
1912      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1913      */
1914     function _msgData() internal view returns (bytes memory) {
1915         if (msg.sender != _relayHub) {
1916             return msg.data;
1917         } else {
1918             return _getRelayedCallData();
1919         }
1920     }
1921 
1922     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1923     // internal hook.
1924 
1925     /**
1926      * @dev See `IRelayRecipient.preRelayedCall`.
1927      *
1928      * This function should not be overriden directly, use `_preRelayedCall` instead.
1929      *
1930      * * Requirements:
1931      *
1932      * - the caller must be the `RelayHub` contract.
1933      */
1934     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1935         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1936         return _preRelayedCall(context);
1937     }
1938 
1939     /**
1940      * @dev See `IRelayRecipient.preRelayedCall`.
1941      *
1942      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1943      * must implement this function with any relayed-call preprocessing they may wish to do.
1944      *
1945      */
1946     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1947 
1948     /**
1949      * @dev See `IRelayRecipient.postRelayedCall`.
1950      *
1951      * This function should not be overriden directly, use `_postRelayedCall` instead.
1952      *
1953      * * Requirements:
1954      *
1955      * - the caller must be the `RelayHub` contract.
1956      */
1957     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1958         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1959         _postRelayedCall(context, success, actualCharge, preRetVal);
1960     }
1961 
1962     /**
1963      * @dev See `IRelayRecipient.postRelayedCall`.
1964      *
1965      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1966      * must implement this function with any relayed-call postprocessing they may wish to do.
1967      *
1968      */
1969     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1970 
1971     /**
1972      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1973      * will be charged a fee by RelayHub
1974      */
1975     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1976         return _approveRelayedCall("");
1977     }
1978 
1979     /**
1980      * @dev See `GSNRecipient._approveRelayedCall`.
1981      *
1982      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1983      */
1984     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1985         return (RELAYED_CALL_ACCEPTED, context);
1986     }
1987 
1988     /**
1989      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1990      */
1991     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1992         return (RELAYED_CALL_REJECTED + errorCode, "");
1993     }
1994 
1995     /*
1996      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1997      * `serviceFee`.
1998      */
1999     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
2000         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
2001         // charged for 1.4 times the spent amount.
2002         return (gas * gasPrice * (100 + serviceFee)) / 100;
2003     }
2004 
2005     function _getRelayedCallSender() private pure returns (address payable result) {
2006         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
2007         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
2008         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
2009         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
2010         // bytes. This can always be done due to the 32-byte prefix.
2011 
2012         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
2013         // easiest/most-efficient way to perform this operation.
2014 
2015         // These fields are not accessible from assembly
2016         bytes memory array = msg.data;
2017         uint256 index = msg.data.length;
2018 
2019         // solhint-disable-next-line no-inline-assembly
2020         assembly {
2021             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
2022             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
2023         }
2024         return result;
2025     }
2026 
2027     function _getRelayedCallData() private pure returns (bytes memory) {
2028         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
2029         // we must strip the last 20 bytes (length of an address type) from it.
2030 
2031         uint256 actualDataLength = msg.data.length - 20;
2032         bytes memory actualData = new bytes(actualDataLength);
2033 
2034         for (uint256 i = 0; i < actualDataLength; ++i) {
2035             actualData[i] = msg.data[i];
2036         }
2037 
2038         return actualData;
2039     }
2040 }
2041 
2042 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2043 
2044 pragma solidity ^0.5.0;
2045 
2046 /**
2047  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
2048  * the optional functions; to access them see {ERC20Detailed}.
2049  */
2050 interface IERC20 {
2051     /**
2052      * @dev Returns the amount of tokens in existence.
2053      */
2054     function totalSupply() external view returns (uint256);
2055 
2056     /**
2057      * @dev Returns the amount of tokens owned by `account`.
2058      */
2059     function balanceOf(address account) external view returns (uint256);
2060 
2061     /**
2062      * @dev Moves `amount` tokens from the caller's account to `recipient`.
2063      *
2064      * Returns a boolean value indicating whether the operation succeeded.
2065      *
2066      * Emits a {Transfer} event.
2067      */
2068     function transfer(address recipient, uint256 amount) external returns (bool);
2069 
2070     /**
2071      * @dev Returns the remaining number of tokens that `spender` will be
2072      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2073      * zero by default.
2074      *
2075      * This value changes when {approve} or {transferFrom} are called.
2076      */
2077     function allowance(address owner, address spender) external view returns (uint256);
2078 
2079     /**
2080      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2081      *
2082      * Returns a boolean value indicating whether the operation succeeded.
2083      *
2084      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2085      * that someone may use both the old and the new allowance by unfortunate
2086      * transaction ordering. One possible solution to mitigate this race
2087      * condition is to first reduce the spender's allowance to 0 and set the
2088      * desired value afterwards:
2089      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2090      *
2091      * Emits an {Approval} event.
2092      */
2093     function approve(address spender, uint256 amount) external returns (bool);
2094 
2095     /**
2096      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2097      * allowance mechanism. `amount` is then deducted from the caller's
2098      * allowance.
2099      *
2100      * Returns a boolean value indicating whether the operation succeeded.
2101      *
2102      * Emits a {Transfer} event.
2103      */
2104     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2105 
2106     /**
2107      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2108      * another (`to`).
2109      *
2110      * Note that `value` may be zero.
2111      */
2112     event Transfer(address indexed from, address indexed to, uint256 value);
2113 
2114     /**
2115      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2116      * a call to {approve}. `value` is the new allowance.
2117      */
2118     event Approval(address indexed owner, address indexed spender, uint256 value);
2119 }
2120 
2121 // File: @openzeppelin/contracts/ownership/Ownable.sol
2122 
2123 pragma solidity ^0.5.0;
2124 
2125 /**
2126  * @dev Contract module which provides a basic access control mechanism, where
2127  * there is an account (an owner) that can be granted exclusive access to
2128  * specific functions.
2129  *
2130  * This module is used through inheritance. It will make available the modifier
2131  * `onlyOwner`, which can be applied to your functions to restrict their use to
2132  * the owner.
2133  */
2134 contract Ownable is Context {
2135     address private _owner;
2136 
2137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2138 
2139     /**
2140      * @dev Initializes the contract setting the deployer as the initial owner.
2141      */
2142     constructor () internal {
2143         address msgSender = _msgSender();
2144         _owner = msgSender;
2145         emit OwnershipTransferred(address(0), msgSender);
2146     }
2147 
2148     /**
2149      * @dev Returns the address of the current owner.
2150      */
2151     function owner() public view returns (address) {
2152         return _owner;
2153     }
2154 
2155     /**
2156      * @dev Throws if called by any account other than the owner.
2157      */
2158     modifier onlyOwner() {
2159         require(isOwner(), "Ownable: caller is not the owner");
2160         _;
2161     }
2162 
2163     /**
2164      * @dev Returns true if the caller is the current owner.
2165      */
2166     function isOwner() public view returns (bool) {
2167         return _msgSender() == _owner;
2168     }
2169 
2170     /**
2171      * @dev Leaves the contract without owner. It will not be possible to call
2172      * `onlyOwner` functions anymore. Can only be called by the current owner.
2173      *
2174      * NOTE: Renouncing ownership will leave the contract without an owner,
2175      * thereby removing any functionality that is only available to the owner.
2176      */
2177     function renounceOwnership() public onlyOwner {
2178         emit OwnershipTransferred(_owner, address(0));
2179         _owner = address(0);
2180     }
2181 
2182     /**
2183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2184      * Can only be called by the current owner.
2185      */
2186     function transferOwnership(address newOwner) public onlyOwner {
2187         _transferOwnership(newOwner);
2188     }
2189 
2190     /**
2191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2192      */
2193     function _transferOwnership(address newOwner) internal {
2194         require(newOwner != address(0), "Ownable: new owner is the zero address");
2195         emit OwnershipTransferred(_owner, newOwner);
2196         _owner = newOwner;
2197     }
2198 }
2199 
2200 // File: @animocabrands/contracts-inventory/contracts/metatx/ERC20Fees.sol
2201 
2202 pragma solidity = 0.5.16;
2203 
2204 
2205 
2206 
2207 
2208 /**
2209     @title ERC20Fees
2210     @dev a GSNRecipient contract with support for ERC-20 fees
2211     Note: .
2212  */
2213 contract ERC20Fees is GSNRecipient, Ownable
2214 {
2215     enum ErrorCodes {
2216         INSUFFICIENT_BALANCE
2217     }
2218 
2219     IERC20 public _gasToken;
2220     address public _payoutWallet;
2221     uint public _gasPriceScaling = GAS_PRICE_SCALING_SCALE;
2222 
2223     uint constant internal GAS_PRICE_SCALING_SCALE = 1000;
2224 
2225     /**
2226      * @dev Constructor function
2227      */
2228     constructor(address gasTokenAddress, address payoutWallet) internal {
2229         setGasToken(gasTokenAddress);
2230         setPayoutWallet(payoutWallet);
2231     }
2232 
2233     function setGasToken(address gasTokenAddress) public onlyOwner {
2234         _gasToken = IERC20(gasTokenAddress);
2235     }
2236 
2237     function setPayoutWallet(address payoutWallet) public onlyOwner {
2238         require(payoutWallet != address(this));
2239         _payoutWallet = payoutWallet;
2240     }
2241 
2242     function setGasPrice(uint gasPriceScaling) public onlyOwner {
2243         _gasPriceScaling = gasPriceScaling;
2244     }
2245 
2246     /**
2247      * @dev Withdraws the recipient's deposits in `RelayHub`.
2248      */
2249     function withdrawDeposits(uint256 amount, address payable payee) external onlyOwner {
2250         _withdrawDeposits(amount, payee);
2251     }
2252 
2253 /////////////////////////////////////////// GSNRecipient ///////////////////////////////////
2254     /**
2255      * @dev Ensures that only users with enough gas payment token balance can have transactions relayed through the GSN.
2256      */
2257     function acceptRelayedCall(
2258         address,
2259         address from,
2260         bytes memory,
2261         uint256 transactionFee,
2262         uint256 gasPrice,
2263         uint256,
2264         uint256,
2265         bytes memory,
2266         uint256 maxPossibleCharge
2267     )
2268         public
2269         view
2270         returns (uint256, bytes memory)
2271     {
2272         if (_gasToken.balanceOf(from) < (maxPossibleCharge * _gasPriceScaling / GAS_PRICE_SCALING_SCALE)) {
2273             return _rejectRelayedCall(uint256(ErrorCodes.INSUFFICIENT_BALANCE));
2274         }
2275 
2276         return _approveRelayedCall(abi.encode(from, maxPossibleCharge, transactionFee, gasPrice));
2277     }
2278 
2279     /**
2280      * @dev Implements the precharge to the user. The maximum possible charge (depending on gas limit, gas price, and
2281      * fee) will be deducted from the user balance of gas payment token. Note that this is an overestimation of the
2282      * actual charge, necessary because we cannot predict how much gas the execution will actually need. The remainder
2283      * is returned to the user in {_postRelayedCall}.
2284      */
2285     function _preRelayedCall(bytes memory context) internal returns (bytes32) {
2286         (address from, uint256 maxPossibleCharge) = abi.decode(context, (address, uint256));
2287 
2288         // The maximum token charge is pre-charged from the user
2289         require(_gasToken.transferFrom(from, _payoutWallet, maxPossibleCharge * _gasPriceScaling / GAS_PRICE_SCALING_SCALE));
2290     }
2291 
2292     /**
2293      * @dev Returns to the user the extra amount that was previously charged, once the actual execution cost is known.
2294      */
2295     function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
2296         (address from, uint256 maxPossibleCharge, uint256 transactionFee, uint256 gasPrice) =
2297             abi.decode(context, (address, uint256, uint256, uint256));
2298 
2299         // actualCharge is an _estimated_ charge, which assumes postRelayedCall will use all available gas.
2300         // This implementation's gas cost can be roughly estimated as 10k gas, for the two SSTORE operations in an
2301         // ERC20 transfer.
2302         uint256 overestimation = _computeCharge(SafeMath.sub(POST_RELAYED_CALL_MAX_GAS, 10000), gasPrice, transactionFee);
2303         actualCharge = SafeMath.sub(actualCharge, overestimation);
2304 
2305         // After the relayed call has been executed and the actual charge estimated, the excess pre-charge is returned
2306         require(_gasToken.transferFrom(_payoutWallet, from, SafeMath.sub(maxPossibleCharge, actualCharge) * _gasPriceScaling / GAS_PRICE_SCALING_SCALE));
2307     }
2308 }
2309 
2310 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
2311 
2312 pragma solidity ^0.5.0;
2313 
2314 
2315 
2316 contract MinterRole is Context {
2317     using Roles for Roles.Role;
2318 
2319     event MinterAdded(address indexed account);
2320     event MinterRemoved(address indexed account);
2321 
2322     Roles.Role private _minters;
2323 
2324     constructor () internal {
2325         _addMinter(_msgSender());
2326     }
2327 
2328     modifier onlyMinter() {
2329         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
2330         _;
2331     }
2332 
2333     function isMinter(address account) public view returns (bool) {
2334         return _minters.has(account);
2335     }
2336 
2337     function addMinter(address account) public onlyMinter {
2338         _addMinter(account);
2339     }
2340 
2341     function renounceMinter() public {
2342         _removeMinter(_msgSender());
2343     }
2344 
2345     function _addMinter(address account) internal {
2346         _minters.add(account);
2347         emit MinterAdded(account);
2348     }
2349 
2350     function _removeMinter(address account) internal {
2351         _minters.remove(account);
2352         emit MinterRemoved(account);
2353     }
2354 }
2355 
2356 // File: contracts/library/Bytes.sol
2357 
2358 pragma solidity = 0.5.16;
2359 
2360 library Bytes {
2361     /**
2362      * @dev public function to convert bytes32 to string
2363      * @param _hash bytes32 hash to convert
2364      * @return string string convert from given bytes32
2365      */
2366     function hash2base32(bytes32 _hash) public pure returns(string memory _uintAsString) {
2367         bytes32 base32Alphabet = 0x6162636465666768696A6B6C6D6E6F707172737475767778797A323334353637;
2368         uint256 _i = uint256(_hash);
2369         uint256 k = 52;
2370         bytes memory bstr = new bytes(k);
2371         bstr[--k] = base32Alphabet[uint8((_i % 8) << 2)]; // uint8 s = uint8((256 - skip) % 5);  // (_i % (2**s)) << (5-s)
2372         _i /= 8;
2373         while (k > 0) {
2374             bstr[--k] = base32Alphabet[_i % 32];
2375             _i /= 32;
2376         }
2377         return string(bstr);
2378     }
2379 
2380     /**
2381      * @dev public function to convert uint256 to string
2382      * @param num uint256 integer to convert
2383      * @return string string convert from given uint256
2384      */
2385     function uint2str(uint256 num) public pure returns(string memory _uintAsString) {
2386         if (num == 0) {
2387             return "0";
2388         }
2389 
2390         uint256 j = num;
2391         uint256 len;
2392         while (j != 0) {
2393             len++;
2394             j /= 10;
2395         }
2396 
2397         bytes memory bstr = new bytes(len);
2398         uint256 k = len - 1;
2399         while (num != 0) {
2400             bstr[k--] = bytes1(uint8(48 + (num % 10)));
2401             num /= 10;
2402         }
2403 
2404         return string(bstr);
2405     }
2406 
2407     function uint2hexstr(uint i) public pure returns(string memory) {
2408         uint length = 64;
2409         uint mask = 15;
2410         bytes memory bstr = new bytes(length);
2411         int k = int(length - 1);
2412         while (i != 0) {
2413             uint curr = (i & mask);
2414             bstr[uint(k--)] = curr > 9 ? byte(uint8(87 + curr)) : byte(uint8(48 + curr)); // 87 = 97 - 10
2415             i = i >> 4;
2416         }
2417         while (k >= 0) {
2418             bstr[uint(k--)] = byte(uint8(48));
2419         }
2420         return string(bstr);
2421     }
2422 }
2423 
2424 // File: contracts/token/ERC1155721/DeltaTimeInventory.sol
2425 
2426 pragma solidity = 0.5.16;
2427 
2428 
2429 
2430 
2431 
2432 
2433 /**
2434  * @title F1 Delta Time Inventory Contract
2435  */
2436 contract DeltaTimeInventory is PausableInventory, ERC20Fees, MinterRole {
2437 
2438     event FungibleCollection(address indexed id);
2439     event NonFungibleCollection(address indexed id);
2440 
2441     bool private _ipfsMigrated;
2442 
2443     string private _uriPrefix = "https://nft.f1deltatime.com/json/";
2444     string private _ipfsUriPrefix = "/ipfs/bafkrei";
2445 
2446     // Mapping Mapping from ID to URI
2447     mapping(uint256 => bytes32) private _uris;
2448 
2449     /**
2450      * @dev Constructor
2451      * @dev 32 DeltaTimeInventory collection type length
2452      */
2453     constructor(address gasTokenAddress, address payoutWallet
2454     ) public PausableInventory(32) ERC20Fees(gasTokenAddress, payoutWallet)  {
2455         _ipfsMigrated = false;
2456     }
2457 
2458     /**
2459      * @dev This function creates the collection id.
2460      * @param collectionId collection without fungible/non-fungible identifier
2461      * @return uint256 collectionId to create
2462      */
2463     function createCollection(uint256 collectionId, bytes32 byteUri) onlyMinter external {
2464         require(_ipfsMigrated? uint256(byteUri) > 0: uint256(byteUri) == 0);
2465         require(!isNFT(collectionId));
2466         _setURI(collectionId, byteUri);
2467     }
2468 
2469 /////////////////////////////////////////// Mint ///////////////////////////////////////
2470     /**
2471      * @dev Public function to mint a batch of new tokens
2472      * Reverts if some the given token IDs already exist
2473      * @param to address[] List of addresses that will own the minted tokens
2474      * @param ids uint256[] List of ids of the tokens to be minted
2475      * @param uris bytes32[] Concatenated metadata URIs of nfts to be minted
2476      * @param values uint256[] List of quantities of ft to be minted
2477      */
2478     function batchMint(address[] memory to, uint256[] memory ids, bytes32[] memory uris, uint256[] memory values, bool safe) public onlyMinter {
2479         require(ids.length == to.length &&
2480             ids.length == uris.length &&
2481             ids.length == values.length);
2482 
2483         for (uint i = 0; i < ids.length; i++) {
2484             if (isNFT(ids[i]) && values[i] == 1) {
2485                 _mintNonFungible(to[i], ids[i], uris[i], safe);
2486             } else if (isFungible(ids[i]) && uint256(uris[i]) == 0) {
2487                 _mintFungible(to[i], ids[i], values[i]);
2488             } else {
2489                 revert();
2490             }
2491         }
2492     }
2493 
2494     /**
2495      * @dev Public function to mint one non fungible token id
2496      * Reverts if the given token ID is not non fungible token id
2497      * @param to address recipient that will own the minted tokens
2498      * @param tokenId uint256 ID of the token to be minted
2499      * @param byteUri bytes32 Concatenated metadata URI of nft to be minted
2500      */
2501     function mintNonFungible(address to, uint256 tokenId, bytes32 byteUri, bool safe) external onlyMinter {
2502         require(isNFT(tokenId)); // solium-disable-line error-reason
2503         _mintNonFungible(to, tokenId, byteUri, safe);
2504     }
2505 
2506     /**
2507      * @dev Internal function to mint one non fungible token
2508      * Reverts if the given token ID already exist
2509      * @param to address recipient that will own the minted tokens
2510      * @param id uint256 ID of the token to be minted
2511      * @param byteUri bytes32 Concatenated metadata URI of nft to be minted
2512      */
2513     function _mintNonFungible(address to, uint256 id, bytes32 byteUri, bool safe) internal {
2514         require(to != address(0x0));
2515         require(!exists(id));
2516 
2517         uint256 collection = id & NF_COLLECTION_MASK;
2518 
2519         _owners[id] = to;
2520         _nftBalances[to] = SafeMath.add(_nftBalances[to], 1);
2521         _balances[collection][to] = SafeMath.add(_balances[collection][to], 1);
2522 
2523         emit Transfer(address(0x0), to, id);
2524         emit TransferSingle(_msgSender(), address(0x0), to, id, 1);
2525 
2526         _setURI(id, byteUri);
2527 
2528         if (safe) {
2529             require( // solium-disable-line error-reason
2530                 _checkERC1155AndCallSafeTransfer(_msgSender(), address(0x0), to, id, 1, "", false, false), "failCheck"
2531             );
2532         }
2533     }
2534 
2535     /**
2536      * @dev Public function to mint fungible token
2537      * Reverts if the given ID is not fungible collection ID
2538      * @param to address recipient that will own the minted tokens
2539      * @param collection uint256 ID of the fungible collection to be minted
2540      * @param value uint256 amount to mint
2541      */
2542     function mintFungible(address to, uint256 collection, uint256 value) external onlyMinter {
2543         require(isFungible(collection));
2544         _mintFungible(to, collection, value);
2545     }
2546 
2547     /**
2548      * @dev Internal function to mint fungible token
2549      * Reverts if the given ID is not exsit
2550      * @param to address recipient that will own the minted tokens
2551      * @param collection uint256 ID of the fungible collection to be minted
2552      * @param value uint256 amount to mint
2553      */
2554     function _mintFungible(address to, uint256 collection, uint256 value) internal {
2555         require(to != address(0x0));
2556         require(value > 0);
2557 
2558         _balances[collection][to] = SafeMath.add(_balances[collection][to], value);
2559 
2560         emit TransferSingle(_msgSender(), address(0x0), to, collection, value);
2561 
2562         require( // solium-disable-line error-reason
2563             _checkERC1155AndCallSafeTransfer(_msgSender(), address(0x0), to, collection, value, "", false, false), "failCheck"
2564         );
2565     }
2566 
2567 /////////////////////////////////////////// TokenURI////////////////////////////////////
2568 
2569     /**
2570      * @dev Public function to update the metadata URI prefix
2571      * @param uriPrefix string the new URI prefix
2572      */
2573     function setUriPrefix(string calldata uriPrefix) external onlyOwner {
2574         _uriPrefix = uriPrefix;
2575     }
2576 
2577     /**
2578      * @dev Public function to update the metadata IPFS URI prefix
2579      * @param ipfsUriPrefix string the new IPFS URI prefix
2580      */
2581     function setIPFSUriPrefix(string calldata ipfsUriPrefix) external onlyOwner {
2582         _ipfsUriPrefix = ipfsUriPrefix;
2583     }
2584 
2585     /**
2586      * @dev Public function to set the URI for a given ID
2587      * Reverts if the ID does not exist or metadata has migrated to IPFS
2588      * @param id uint256 ID to set its URI
2589      * @param byteUri bytes32 URI to assign
2590      */
2591     function setURI(uint256 id, bytes32 byteUri) external onlyMinter {
2592         require(!_ipfsMigrated && uint256(byteUri) > 0);
2593         require(exists(id));
2594 
2595         _setURI(id, byteUri);
2596     }
2597 
2598     /**
2599      * @dev Internal function to set the URI for a given ID
2600      * Reverts if the ID does not exist
2601      * @param id uint256 ID to set its URI
2602      * @param byteUri bytes32 URI to assign
2603      */
2604     function _setURI(uint256 id, bytes32 byteUri) internal {
2605         if (uint256(byteUri) > 0) {
2606             _uris[id] = byteUri;
2607             emit URI(_fullUriFromHash(byteUri), id);
2608         } else {
2609             emit URI(_fullUriFromId(id), id);
2610         }
2611     }
2612 
2613     /**
2614      * @dev Internal function to convert bytes32 hash to full uri string
2615      * @param byteUri bytes32 URI to convert
2616      * @return string URI convert from given hash
2617      */
2618     function _fullUriFromHash(bytes32 byteUri) private view returns(string memory) {
2619         return string(abi.encodePacked(_ipfsUriPrefix, Bytes.hash2base32(byteUri)));
2620     }
2621 
2622     /**
2623      * @dev Internal function to convert id to full uri string
2624      * @param id uint256 ID to convert
2625      * @return string URI convert from given ID
2626      */
2627     function _fullUriFromId(uint256 id) private view returns(string memory) {
2628         return string(abi.encodePacked(abi.encodePacked(_uriPrefix, Bytes.uint2str(id))));
2629     }
2630 
2631 /////////////////////////////////////////// IPFS migration ///////////////////////////////////
2632 
2633     /**
2634      * @dev Sets IPFS migration flag true
2635      */
2636     function migrateToIPFS() public onlyMinter {
2637         _ipfsMigrated = true;
2638     }
2639 
2640 /////////////////////////////////////////// ERC1155MetadataURI ///////////////////////////////////
2641 
2642     /**
2643      * @dev Returns an URI for a given ID
2644      * @param id uint256 ID of the tokenId / collectionId to query
2645      * @return string URI of given ID
2646      */
2647     function uri(uint256 id) public view returns(string memory) {
2648         if (uint256(_uris[id]) == 0) {
2649             return _fullUriFromId(id);
2650         }
2651 
2652         return _fullUriFromHash(_uris[id]);
2653     }
2654 
2655 /////////////////////////////////////////// ERC721Metadata ///////////////////////////////////
2656 
2657     /**
2658      * @dev Gets the token name
2659      * @return string representing the token name
2660      */
2661     function name() external view returns(string memory) {
2662         return "F1® Delta Time Inventory";
2663     }
2664 
2665     /**
2666      * @dev Gets the token symbol
2667      * @return string representing the token symbol
2668      */
2669     function symbol() external view returns(string memory) {
2670         return "F1DTI";
2671     }
2672 
2673     /**
2674      * @dev Returns an URI for a given token ID
2675      * Throws if the token ID does not exist. May return an empty string.
2676      * @param tokenId uint256 ID of the token to query
2677      * @return string URI of given token ID
2678      */
2679     function tokenURI(uint256 tokenId) external view returns (string memory) {
2680         require(exists(tokenId));
2681         return uri(tokenId);
2682     }
2683 }