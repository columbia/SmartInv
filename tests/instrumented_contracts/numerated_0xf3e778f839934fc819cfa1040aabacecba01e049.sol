1 // File: contracts/AvastarTypes.sol
2 
3 pragma solidity 0.5.14;
4 
5 /**
6  * @title Avastar Data Types
7  * @author Cliff Hall
8  */
9 contract AvastarTypes {
10 
11     enum Generation {
12         ONE,
13         TWO,
14         THREE,
15         FOUR,
16         FIVE
17     }
18 
19     enum Series {
20         PROMO,
21         ONE,
22         TWO,
23         THREE,
24         FOUR,
25         FIVE
26     }
27 
28     enum Wave {
29         PRIME,
30         REPLICANT
31     }
32 
33     enum Gene {
34         SKIN_TONE,
35         HAIR_COLOR,
36         EYE_COLOR,
37         BG_COLOR,
38         BACKDROP,
39         EARS,
40         FACE,
41         NOSE,
42         MOUTH,
43         FACIAL_FEATURE,
44         EYES,
45         HAIR_STYLE
46     }
47 
48     enum Gender {
49         ANY,
50         MALE,
51         FEMALE
52     }
53 
54     enum Rarity {
55         COMMON,
56         UNCOMMON,
57         RARE,
58         EPIC,
59         LEGENDARY
60     }
61 
62     struct Trait {
63         uint256 id;
64         Generation generation;
65         Gender gender;
66         Gene gene;
67         Rarity rarity;
68         uint8 variation;
69         Series[] series;
70         string name;
71         string svg;
72 
73     }
74 
75     struct Prime {
76         uint256 id;
77         uint256 serial;
78         uint256 traits;
79         bool[12] replicated;
80         Generation generation;
81         Series series;
82         Gender gender;
83         uint8 ranking;
84     }
85 
86     struct Replicant {
87         uint256 id;
88         uint256 serial;
89         uint256 traits;
90         Generation generation;
91         Gender gender;
92         uint8 ranking;
93     }
94 
95     struct Avastar {
96         uint256 id;
97         uint256 serial;
98         uint256 traits;
99         Generation generation;
100         Wave wave;
101     }
102 
103     struct Attribution {
104         Generation generation;
105         string artist;
106         string infoURI;
107     }
108 
109 }
110 
111 // File: contracts/AvastarBase.sol
112 
113 pragma solidity 0.5.14;
114 
115 /**
116  * @title Avastar Base
117  * @author Cliff Hall
118  * @notice Utilities used by descendant contracts
119  */
120 contract AvastarBase {
121 
122     /**
123      * @notice Convert a `uint` value to a `string`
124      * via OraclizeAPI - MIT licence
125      * https://github.com/provable-things/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol#L896
126      * @param _i the `uint` value to be converted
127      * @return result the `string` representation of the given `uint` value
128      */
129     function uintToStr(uint _i)
130     internal pure
131     returns (string memory result) {
132         if (_i == 0) {
133             return "0";
134         }
135         uint j = _i;
136         uint len;
137         while (j != 0) {
138             len++;
139             j /= 10;
140         }
141         bytes memory bstr = new bytes(len);
142         uint k = len - 1;
143         while (_i != 0) {
144             bstr[k--] = byte(uint8(48 + _i % 10));
145             _i /= 10;
146         }
147         result = string(bstr);
148     }
149 
150     /**
151      * @notice Concatenate two strings
152      * @param _a the first string
153      * @param _b the second string
154      * @return result the concatenation of `_a` and `_b`
155      */
156     function strConcat(string memory _a, string memory _b)
157     internal pure
158     returns(string memory result) {
159         result = string(abi.encodePacked(bytes(_a), bytes(_b)));
160     }
161 
162 }
163 
164 // File: @openzeppelin/contracts/access/Roles.sol
165 
166 pragma solidity ^0.5.0;
167 
168 /**
169  * @title Roles
170  * @dev Library for managing addresses assigned to a Role.
171  */
172 library Roles {
173     struct Role {
174         mapping (address => bool) bearer;
175     }
176 
177     /**
178      * @dev Give an account access to this role.
179      */
180     function add(Role storage role, address account) internal {
181         require(!has(role, account), "Roles: account already has role");
182         role.bearer[account] = true;
183     }
184 
185     /**
186      * @dev Remove an account's access to this role.
187      */
188     function remove(Role storage role, address account) internal {
189         require(has(role, account), "Roles: account does not have role");
190         role.bearer[account] = false;
191     }
192 
193     /**
194      * @dev Check if an account has this role.
195      * @return bool
196      */
197     function has(Role storage role, address account) internal view returns (bool) {
198         require(account != address(0), "Roles: account is the zero address");
199         return role.bearer[account];
200     }
201 }
202 
203 // File: @openzeppelin/contracts/math/SafeMath.sol
204 
205 pragma solidity ^0.5.0;
206 
207 /**
208  * @dev Wrappers over Solidity's arithmetic operations with added overflow
209  * checks.
210  *
211  * Arithmetic operations in Solidity wrap on overflow. This can easily result
212  * in bugs, because programmers usually assume that an overflow raises an
213  * error, which is the standard behavior in high level programming languages.
214  * `SafeMath` restores this intuition by reverting the transaction when an
215  * operation overflows.
216  *
217  * Using this library instead of the unchecked operations eliminates an entire
218  * class of bugs, so it's recommended to use it always.
219  */
220 library SafeMath {
221     /**
222      * @dev Returns the addition of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `+` operator.
226      *
227      * Requirements:
228      * - Addition cannot overflow.
229      */
230     function add(uint256 a, uint256 b) internal pure returns (uint256) {
231         uint256 c = a + b;
232         require(c >= a, "SafeMath: addition overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting on
239      * overflow (when the result is negative).
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      * - Subtraction cannot overflow.
245      */
246     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247         return sub(a, b, "SafeMath: subtraction overflow");
248     }
249 
250     /**
251      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
252      * overflow (when the result is negative).
253      *
254      * Counterpart to Solidity's `-` operator.
255      *
256      * Requirements:
257      * - Subtraction cannot overflow.
258      *
259      * _Available since v2.4.0._
260      */
261     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b <= a, errorMessage);
263         uint256 c = a - b;
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the multiplication of two unsigned integers, reverting on
270      * overflow.
271      *
272      * Counterpart to Solidity's `*` operator.
273      *
274      * Requirements:
275      * - Multiplication cannot overflow.
276      */
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
279         // benefit is lost if 'b' is also tested.
280         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
281         if (a == 0) {
282             return 0;
283         }
284 
285         uint256 c = a * b;
286         require(c / a == b, "SafeMath: multiplication overflow");
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers. Reverts on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
303         return div(a, b, "SafeMath: division by zero");
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      *
317      * _Available since v2.4.0._
318      */
319     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         // Solidity only automatically asserts when dividing by 0
321         require(b > 0, errorMessage);
322         uint256 c = a / b;
323         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
324 
325         return c;
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * Reverts when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      * - The divisor cannot be zero.
338      */
339     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
340         return mod(a, b, "SafeMath: modulo by zero");
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * Reverts with custom message when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      * - The divisor cannot be zero.
353      *
354      * _Available since v2.4.0._
355      */
356     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
357         require(b != 0, errorMessage);
358         return a % b;
359     }
360 }
361 
362 // File: contracts/AccessControl.sol
363 
364 pragma solidity 0.5.14;
365 
366 
367 
368 /**
369  * @title Access Control
370  * @author Cliff Hall
371  * @notice Role-based access control and contract upgrade functionality.
372  */
373 contract AccessControl {
374 
375     using SafeMath for uint256;
376     using SafeMath for uint16;
377     using Roles for Roles.Role;
378 
379     Roles.Role private admins;
380     Roles.Role private minters;
381     Roles.Role private owners;
382 
383     /**
384      * @notice Sets `msg.sender` as system admin by default.
385      * Starts paused. System admin must unpause, and add other roles after deployment.
386      */
387     constructor() public {
388         admins.add(msg.sender);
389     }
390 
391     /**
392      * @notice Emitted when contract is paused by system administrator.
393      */
394     event ContractPaused();
395 
396     /**
397      * @notice Emitted when contract is unpaused by system administrator.
398      */
399     event ContractUnpaused();
400 
401     /**
402      * @notice Emitted when contract is upgraded by system administrator.
403      * @param newContract address of the new version of the contract.
404      */
405     event ContractUpgrade(address newContract);
406 
407 
408     bool public paused = true;
409     bool public upgraded = false;
410     address public newContractAddress;
411 
412     /**
413      * @notice Modifier to scope access to minters
414      */
415     modifier onlyMinter() {
416         require(minters.has(msg.sender));
417         _;
418     }
419 
420     /**
421      * @notice Modifier to scope access to owners
422      */
423     modifier onlyOwner() {
424         require(owners.has(msg.sender));
425         _;
426     }
427 
428     /**
429      * @notice Modifier to scope access to system administrators
430      */
431     modifier onlySysAdmin() {
432         require(admins.has(msg.sender));
433         _;
434     }
435 
436     /**
437      * @notice Modifier to make a function callable only when the contract is not paused.
438      */
439     modifier whenNotPaused() {
440         require(!paused);
441         _;
442     }
443 
444     /**
445      * @notice Modifier to make a function callable only when the contract is paused.
446      */
447     modifier whenPaused() {
448         require(paused);
449         _;
450     }
451 
452     /**
453      * @notice Modifier to make a function callable only when the contract not upgraded.
454      */
455     modifier whenNotUpgraded() {
456         require(!upgraded);
457         _;
458     }
459 
460     /**
461      * @notice Called by a system administrator to  mark the smart contract as upgraded,
462      * in case there is a serious breaking bug. This method stores the new contract
463      * address and emits an event to that effect. Clients of the contract should
464      * update to the new contract address upon receiving this event. This contract will
465      * remain paused indefinitely after such an upgrade.
466      * @param _newAddress address of new contract
467      */
468     function upgradeContract(address _newAddress) external onlySysAdmin whenPaused whenNotUpgraded {
469         require(_newAddress != address(0));
470         upgraded = true;
471         newContractAddress = _newAddress;
472         emit ContractUpgrade(_newAddress);
473     }
474 
475     /**
476      * @notice Called by a system administrator to add a minter.
477      * Reverts if `_minterAddress` already has minter role
478      * @param _minterAddress approved minter
479      */
480     function addMinter(address _minterAddress) external onlySysAdmin {
481         minters.add(_minterAddress);
482         require(minters.has(_minterAddress));
483     }
484 
485     /**
486      * @notice Called by a system administrator to add an owner.
487      * Reverts if `_ownerAddress` already has owner role
488      * @param _ownerAddress approved owner
489      * @return added boolean indicating whether the role was granted
490      */
491     function addOwner(address _ownerAddress) external onlySysAdmin {
492         owners.add(_ownerAddress);
493         require(owners.has(_ownerAddress));
494     }
495 
496     /**
497      * @notice Called by a system administrator to add another system admin.
498      * Reverts if `_sysAdminAddress` already has sysAdmin role
499      * @param _sysAdminAddress approved owner
500      */
501     function addSysAdmin(address _sysAdminAddress) external onlySysAdmin {
502         admins.add(_sysAdminAddress);
503         require(admins.has(_sysAdminAddress));
504     }
505 
506     /**
507      * @notice Called by an owner to remove all roles from an address.
508      * Reverts if address had no roles to be removed.
509      * @param _address address having its roles stripped
510      */
511     function stripRoles(address _address) external onlyOwner {
512         require(msg.sender != _address);
513         bool stripped = false;
514         if (admins.has(_address)) {
515             admins.remove(_address);
516             stripped = true;
517         }
518         if (minters.has(_address)) {
519             minters.remove(_address);
520             stripped = true;
521         }
522         if (owners.has(_address)) {
523             owners.remove(_address);
524             stripped = true;
525         }
526         require(stripped == true);
527     }
528 
529     /**
530      * @notice Called by a system administrator to pause, triggers stopped state
531      */
532     function pause() external onlySysAdmin whenNotPaused {
533         paused = true;
534         emit ContractPaused();
535     }
536 
537     /**
538      * @notice Called by a system administrator to un-pause, returns to normal state
539      */
540     function unpause() external onlySysAdmin whenPaused whenNotUpgraded {
541         paused = false;
542         emit ContractUnpaused();
543     }
544 
545 }
546 
547 // File: @openzeppelin/contracts/GSN/Context.sol
548 
549 pragma solidity ^0.5.0;
550 
551 /*
552  * @dev Provides information about the current execution context, including the
553  * sender of the transaction and its data. While these are generally available
554  * via msg.sender and msg.data, they should not be accessed in such a direct
555  * manner, since when dealing with GSN meta-transactions the account sending and
556  * paying for execution may not be the actual sender (as far as an application
557  * is concerned).
558  *
559  * This contract is only required for intermediate, library-like contracts.
560  */
561 contract Context {
562     // Empty internal constructor, to prevent people from mistakenly deploying
563     // an instance of this contract, which should be used via inheritance.
564     constructor () internal { }
565     // solhint-disable-previous-line no-empty-blocks
566 
567     function _msgSender() internal view returns (address payable) {
568         return msg.sender;
569     }
570 
571     function _msgData() internal view returns (bytes memory) {
572         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
573         return msg.data;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/introspection/IERC165.sol
578 
579 pragma solidity ^0.5.0;
580 
581 /**
582  * @dev Interface of the ERC165 standard, as defined in the
583  * https://eips.ethereum.org/EIPS/eip-165[EIP].
584  *
585  * Implementers can declare support of contract interfaces, which can then be
586  * queried by others ({ERC165Checker}).
587  *
588  * For an implementation, see {ERC165}.
589  */
590 interface IERC165 {
591     /**
592      * @dev Returns true if this contract implements the interface defined by
593      * `interfaceId`. See the corresponding
594      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
595      * to learn more about how these ids are created.
596      *
597      * This function call must use less than 30 000 gas.
598      */
599     function supportsInterface(bytes4 interfaceId) external view returns (bool);
600 }
601 
602 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
603 
604 pragma solidity ^0.5.0;
605 
606 
607 /**
608  * @dev Required interface of an ERC721 compliant contract.
609  */
610 contract IERC721 is IERC165 {
611     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
612     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
613     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
614 
615     /**
616      * @dev Returns the number of NFTs in `owner`'s account.
617      */
618     function balanceOf(address owner) public view returns (uint256 balance);
619 
620     /**
621      * @dev Returns the owner of the NFT specified by `tokenId`.
622      */
623     function ownerOf(uint256 tokenId) public view returns (address owner);
624 
625     /**
626      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
627      * another (`to`).
628      *
629      *
630      *
631      * Requirements:
632      * - `from`, `to` cannot be zero.
633      * - `tokenId` must be owned by `from`.
634      * - If the caller is not `from`, it must be have been allowed to move this
635      * NFT by either {approve} or {setApprovalForAll}.
636      */
637     function safeTransferFrom(address from, address to, uint256 tokenId) public;
638     /**
639      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
640      * another (`to`).
641      *
642      * Requirements:
643      * - If the caller is not `from`, it must be approved to move this NFT by
644      * either {approve} or {setApprovalForAll}.
645      */
646     function transferFrom(address from, address to, uint256 tokenId) public;
647     function approve(address to, uint256 tokenId) public;
648     function getApproved(uint256 tokenId) public view returns (address operator);
649 
650     function setApprovalForAll(address operator, bool _approved) public;
651     function isApprovedForAll(address owner, address operator) public view returns (bool);
652 
653 
654     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
655 }
656 
657 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
658 
659 pragma solidity ^0.5.0;
660 
661 /**
662  * @title ERC721 token receiver interface
663  * @dev Interface for any contract that wants to support safeTransfers
664  * from ERC721 asset contracts.
665  */
666 contract IERC721Receiver {
667     /**
668      * @notice Handle the receipt of an NFT
669      * @dev The ERC721 smart contract calls this function on the recipient
670      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
671      * otherwise the caller will revert the transaction. The selector to be
672      * returned can be obtained as `this.onERC721Received.selector`. This
673      * function MAY throw to revert and reject the transfer.
674      * Note: the ERC721 contract address is always the message sender.
675      * @param operator The address which called `safeTransferFrom` function
676      * @param from The address which previously owned the token
677      * @param tokenId The NFT identifier which is being transferred
678      * @param data Additional data with no specified format
679      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
680      */
681     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
682     public returns (bytes4);
683 }
684 
685 // File: @openzeppelin/contracts/utils/Address.sol
686 
687 pragma solidity ^0.5.5;
688 
689 /**
690  * @dev Collection of functions related to the address type
691  */
692 library Address {
693     /**
694      * @dev Returns true if `account` is a contract.
695      *
696      * This test is non-exhaustive, and there may be false-negatives: during the
697      * execution of a contract's constructor, its address will be reported as
698      * not containing a contract.
699      *
700      * IMPORTANT: It is unsafe to assume that an address for which this
701      * function returns false is an externally-owned account (EOA) and not a
702      * contract.
703      */
704     function isContract(address account) internal view returns (bool) {
705         // This method relies in extcodesize, which returns 0 for contracts in
706         // construction, since the code is only stored at the end of the
707         // constructor execution.
708 
709         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
710         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
711         // for accounts without code, i.e. `keccak256('')`
712         bytes32 codehash;
713         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
714         // solhint-disable-next-line no-inline-assembly
715         assembly { codehash := extcodehash(account) }
716         return (codehash != 0x0 && codehash != accountHash);
717     }
718 
719     /**
720      * @dev Converts an `address` into `address payable`. Note that this is
721      * simply a type cast: the actual underlying value is not changed.
722      *
723      * _Available since v2.4.0._
724      */
725     function toPayable(address account) internal pure returns (address payable) {
726         return address(uint160(account));
727     }
728 
729     /**
730      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
731      * `recipient`, forwarding all available gas and reverting on errors.
732      *
733      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
734      * of certain opcodes, possibly making contracts go over the 2300 gas limit
735      * imposed by `transfer`, making them unable to receive funds via
736      * `transfer`. {sendValue} removes this limitation.
737      *
738      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
739      *
740      * IMPORTANT: because control is transferred to `recipient`, care must be
741      * taken to not create reentrancy vulnerabilities. Consider using
742      * {ReentrancyGuard} or the
743      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
744      *
745      * _Available since v2.4.0._
746      */
747     function sendValue(address payable recipient, uint256 amount) internal {
748         require(address(this).balance >= amount, "Address: insufficient balance");
749 
750         // solhint-disable-next-line avoid-call-value
751         (bool success, ) = recipient.call.value(amount)("");
752         require(success, "Address: unable to send value, recipient may have reverted");
753     }
754 }
755 
756 // File: @openzeppelin/contracts/drafts/Counters.sol
757 
758 pragma solidity ^0.5.0;
759 
760 
761 /**
762  * @title Counters
763  * @author Matt Condon (@shrugs)
764  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
765  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
766  *
767  * Include with `using Counters for Counters.Counter;`
768  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
769  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
770  * directly accessed.
771  */
772 library Counters {
773     using SafeMath for uint256;
774 
775     struct Counter {
776         // This variable should never be directly accessed by users of the library: interactions must be restricted to
777         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
778         // this feature: see https://github.com/ethereum/solidity/issues/4637
779         uint256 _value; // default: 0
780     }
781 
782     function current(Counter storage counter) internal view returns (uint256) {
783         return counter._value;
784     }
785 
786     function increment(Counter storage counter) internal {
787         counter._value += 1;
788     }
789 
790     function decrement(Counter storage counter) internal {
791         counter._value = counter._value.sub(1);
792     }
793 }
794 
795 // File: @openzeppelin/contracts/introspection/ERC165.sol
796 
797 pragma solidity ^0.5.0;
798 
799 
800 /**
801  * @dev Implementation of the {IERC165} interface.
802  *
803  * Contracts may inherit from this and call {_registerInterface} to declare
804  * their support of an interface.
805  */
806 contract ERC165 is IERC165 {
807     /*
808      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
809      */
810     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
811 
812     /**
813      * @dev Mapping of interface ids to whether or not it's supported.
814      */
815     mapping(bytes4 => bool) private _supportedInterfaces;
816 
817     constructor () internal {
818         // Derived contracts need only register support for their own interfaces,
819         // we register support for ERC165 itself here
820         _registerInterface(_INTERFACE_ID_ERC165);
821     }
822 
823     /**
824      * @dev See {IERC165-supportsInterface}.
825      *
826      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
827      */
828     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
829         return _supportedInterfaces[interfaceId];
830     }
831 
832     /**
833      * @dev Registers the contract as an implementer of the interface defined by
834      * `interfaceId`. Support of the actual ERC165 interface is automatic and
835      * registering its interface id is not required.
836      *
837      * See {IERC165-supportsInterface}.
838      *
839      * Requirements:
840      *
841      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
842      */
843     function _registerInterface(bytes4 interfaceId) internal {
844         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
845         _supportedInterfaces[interfaceId] = true;
846     }
847 }
848 
849 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
850 
851 pragma solidity ^0.5.0;
852 
853 
854 
855 
856 
857 
858 
859 
860 /**
861  * @title ERC721 Non-Fungible Token Standard basic implementation
862  * @dev see https://eips.ethereum.org/EIPS/eip-721
863  */
864 contract ERC721 is Context, ERC165, IERC721 {
865     using SafeMath for uint256;
866     using Address for address;
867     using Counters for Counters.Counter;
868 
869     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
870     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
871     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
872 
873     // Mapping from token ID to owner
874     mapping (uint256 => address) private _tokenOwner;
875 
876     // Mapping from token ID to approved address
877     mapping (uint256 => address) private _tokenApprovals;
878 
879     // Mapping from owner to number of owned token
880     mapping (address => Counters.Counter) private _ownedTokensCount;
881 
882     // Mapping from owner to operator approvals
883     mapping (address => mapping (address => bool)) private _operatorApprovals;
884 
885     /*
886      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
887      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
888      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
889      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
890      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
891      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
892      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
893      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
894      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
895      *
896      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
897      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
898      */
899     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
900 
901     constructor () public {
902         // register the supported interfaces to conform to ERC721 via ERC165
903         _registerInterface(_INTERFACE_ID_ERC721);
904     }
905 
906     /**
907      * @dev Gets the balance of the specified address.
908      * @param owner address to query the balance of
909      * @return uint256 representing the amount owned by the passed address
910      */
911     function balanceOf(address owner) public view returns (uint256) {
912         require(owner != address(0), "ERC721: balance query for the zero address");
913 
914         return _ownedTokensCount[owner].current();
915     }
916 
917     /**
918      * @dev Gets the owner of the specified token ID.
919      * @param tokenId uint256 ID of the token to query the owner of
920      * @return address currently marked as the owner of the given token ID
921      */
922     function ownerOf(uint256 tokenId) public view returns (address) {
923         address owner = _tokenOwner[tokenId];
924         require(owner != address(0), "ERC721: owner query for nonexistent token");
925 
926         return owner;
927     }
928 
929     /**
930      * @dev Approves another address to transfer the given token ID
931      * The zero address indicates there is no approved address.
932      * There can only be one approved address per token at a given time.
933      * Can only be called by the token owner or an approved operator.
934      * @param to address to be approved for the given token ID
935      * @param tokenId uint256 ID of the token to be approved
936      */
937     function approve(address to, uint256 tokenId) public {
938         address owner = ownerOf(tokenId);
939         require(to != owner, "ERC721: approval to current owner");
940 
941         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
942             "ERC721: approve caller is not owner nor approved for all"
943         );
944 
945         _tokenApprovals[tokenId] = to;
946         emit Approval(owner, to, tokenId);
947     }
948 
949     /**
950      * @dev Gets the approved address for a token ID, or zero if no address set
951      * Reverts if the token ID does not exist.
952      * @param tokenId uint256 ID of the token to query the approval of
953      * @return address currently approved for the given token ID
954      */
955     function getApproved(uint256 tokenId) public view returns (address) {
956         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
957 
958         return _tokenApprovals[tokenId];
959     }
960 
961     /**
962      * @dev Sets or unsets the approval of a given operator
963      * An operator is allowed to transfer all tokens of the sender on their behalf.
964      * @param to operator address to set the approval
965      * @param approved representing the status of the approval to be set
966      */
967     function setApprovalForAll(address to, bool approved) public {
968         require(to != _msgSender(), "ERC721: approve to caller");
969 
970         _operatorApprovals[_msgSender()][to] = approved;
971         emit ApprovalForAll(_msgSender(), to, approved);
972     }
973 
974     /**
975      * @dev Tells whether an operator is approved by a given owner.
976      * @param owner owner address which you want to query the approval of
977      * @param operator operator address which you want to query the approval of
978      * @return bool whether the given operator is approved by the given owner
979      */
980     function isApprovedForAll(address owner, address operator) public view returns (bool) {
981         return _operatorApprovals[owner][operator];
982     }
983 
984     /**
985      * @dev Transfers the ownership of a given token ID to another address.
986      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
987      * Requires the msg.sender to be the owner, approved, or operator.
988      * @param from current owner of the token
989      * @param to address to receive the ownership of the given token ID
990      * @param tokenId uint256 ID of the token to be transferred
991      */
992     function transferFrom(address from, address to, uint256 tokenId) public {
993         //solhint-disable-next-line max-line-length
994         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
995 
996         _transferFrom(from, to, tokenId);
997     }
998 
999     /**
1000      * @dev Safely transfers the ownership of a given token ID to another address
1001      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1002      * which is called upon a safe transfer, and return the magic value
1003      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1004      * the transfer is reverted.
1005      * Requires the msg.sender to be the owner, approved, or operator
1006      * @param from current owner of the token
1007      * @param to address to receive the ownership of the given token ID
1008      * @param tokenId uint256 ID of the token to be transferred
1009      */
1010     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1011         safeTransferFrom(from, to, tokenId, "");
1012     }
1013 
1014     /**
1015      * @dev Safely transfers the ownership of a given token ID to another address
1016      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1017      * which is called upon a safe transfer, and return the magic value
1018      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1019      * the transfer is reverted.
1020      * Requires the _msgSender() to be the owner, approved, or operator
1021      * @param from current owner of the token
1022      * @param to address to receive the ownership of the given token ID
1023      * @param tokenId uint256 ID of the token to be transferred
1024      * @param _data bytes data to send along with a safe transfer check
1025      */
1026     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1027         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1028         _safeTransferFrom(from, to, tokenId, _data);
1029     }
1030 
1031     /**
1032      * @dev Safely transfers the ownership of a given token ID to another address
1033      * If the target address is a contract, it must implement `onERC721Received`,
1034      * which is called upon a safe transfer, and return the magic value
1035      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1036      * the transfer is reverted.
1037      * Requires the msg.sender to be the owner, approved, or operator
1038      * @param from current owner of the token
1039      * @param to address to receive the ownership of the given token ID
1040      * @param tokenId uint256 ID of the token to be transferred
1041      * @param _data bytes data to send along with a safe transfer check
1042      */
1043     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
1044         _transferFrom(from, to, tokenId);
1045         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1046     }
1047 
1048     /**
1049      * @dev Returns whether the specified token exists.
1050      * @param tokenId uint256 ID of the token to query the existence of
1051      * @return bool whether the token exists
1052      */
1053     function _exists(uint256 tokenId) internal view returns (bool) {
1054         address owner = _tokenOwner[tokenId];
1055         return owner != address(0);
1056     }
1057 
1058     /**
1059      * @dev Returns whether the given spender can transfer a given token ID.
1060      * @param spender address of the spender to query
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @return bool whether the msg.sender is approved for the given token ID,
1063      * is an operator of the owner, or is the owner of the token
1064      */
1065     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1066         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1067         address owner = ownerOf(tokenId);
1068         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1069     }
1070 
1071     /**
1072      * @dev Internal function to safely mint a new token.
1073      * Reverts if the given token ID already exists.
1074      * If the target address is a contract, it must implement `onERC721Received`,
1075      * which is called upon a safe transfer, and return the magic value
1076      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1077      * the transfer is reverted.
1078      * @param to The address that will own the minted token
1079      * @param tokenId uint256 ID of the token to be minted
1080      */
1081     function _safeMint(address to, uint256 tokenId) internal {
1082         _safeMint(to, tokenId, "");
1083     }
1084 
1085     /**
1086      * @dev Internal function to safely mint a new token.
1087      * Reverts if the given token ID already exists.
1088      * If the target address is a contract, it must implement `onERC721Received`,
1089      * which is called upon a safe transfer, and return the magic value
1090      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1091      * the transfer is reverted.
1092      * @param to The address that will own the minted token
1093      * @param tokenId uint256 ID of the token to be minted
1094      * @param _data bytes data to send along with a safe transfer check
1095      */
1096     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
1097         _mint(to, tokenId);
1098         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1099     }
1100 
1101     /**
1102      * @dev Internal function to mint a new token.
1103      * Reverts if the given token ID already exists.
1104      * @param to The address that will own the minted token
1105      * @param tokenId uint256 ID of the token to be minted
1106      */
1107     function _mint(address to, uint256 tokenId) internal {
1108         require(to != address(0), "ERC721: mint to the zero address");
1109         require(!_exists(tokenId), "ERC721: token already minted");
1110 
1111         _tokenOwner[tokenId] = to;
1112         _ownedTokensCount[to].increment();
1113 
1114         emit Transfer(address(0), to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev Internal function to burn a specific token.
1119      * Reverts if the token does not exist.
1120      * Deprecated, use {_burn} instead.
1121      * @param owner owner of the token to burn
1122      * @param tokenId uint256 ID of the token being burned
1123      */
1124     function _burn(address owner, uint256 tokenId) internal {
1125         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
1126 
1127         _clearApproval(tokenId);
1128 
1129         _ownedTokensCount[owner].decrement();
1130         _tokenOwner[tokenId] = address(0);
1131 
1132         emit Transfer(owner, address(0), tokenId);
1133     }
1134 
1135     /**
1136      * @dev Internal function to burn a specific token.
1137      * Reverts if the token does not exist.
1138      * @param tokenId uint256 ID of the token being burned
1139      */
1140     function _burn(uint256 tokenId) internal {
1141         _burn(ownerOf(tokenId), tokenId);
1142     }
1143 
1144     /**
1145      * @dev Internal function to transfer ownership of a given token ID to another address.
1146      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1147      * @param from current owner of the token
1148      * @param to address to receive the ownership of the given token ID
1149      * @param tokenId uint256 ID of the token to be transferred
1150      */
1151     function _transferFrom(address from, address to, uint256 tokenId) internal {
1152         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1153         require(to != address(0), "ERC721: transfer to the zero address");
1154 
1155         _clearApproval(tokenId);
1156 
1157         _ownedTokensCount[from].decrement();
1158         _ownedTokensCount[to].increment();
1159 
1160         _tokenOwner[tokenId] = to;
1161 
1162         emit Transfer(from, to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1167      * The call is not executed if the target address is not a contract.
1168      *
1169      * This function is deprecated.
1170      * @param from address representing the previous owner of the given token ID
1171      * @param to target address that will receive the tokens
1172      * @param tokenId uint256 ID of the token to be transferred
1173      * @param _data bytes optional data to send along with the call
1174      * @return bool whether the call correctly returned the expected magic value
1175      */
1176     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1177         internal returns (bool)
1178     {
1179         if (!to.isContract()) {
1180             return true;
1181         }
1182 
1183         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
1184         return (retval == _ERC721_RECEIVED);
1185     }
1186 
1187     /**
1188      * @dev Private function to clear current approval of a given token ID.
1189      * @param tokenId uint256 ID of the token to be transferred
1190      */
1191     function _clearApproval(uint256 tokenId) private {
1192         if (_tokenApprovals[tokenId] != address(0)) {
1193             _tokenApprovals[tokenId] = address(0);
1194         }
1195     }
1196 }
1197 
1198 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
1199 
1200 pragma solidity ^0.5.0;
1201 
1202 
1203 /**
1204  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1205  * @dev See https://eips.ethereum.org/EIPS/eip-721
1206  */
1207 contract IERC721Enumerable is IERC721 {
1208     function totalSupply() public view returns (uint256);
1209     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
1210 
1211     function tokenByIndex(uint256 index) public view returns (uint256);
1212 }
1213 
1214 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
1215 
1216 pragma solidity ^0.5.0;
1217 
1218 
1219 
1220 
1221 
1222 /**
1223  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
1224  * @dev See https://eips.ethereum.org/EIPS/eip-721
1225  */
1226 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
1227     // Mapping from owner to list of owned token IDs
1228     mapping(address => uint256[]) private _ownedTokens;
1229 
1230     // Mapping from token ID to index of the owner tokens list
1231     mapping(uint256 => uint256) private _ownedTokensIndex;
1232 
1233     // Array with all token ids, used for enumeration
1234     uint256[] private _allTokens;
1235 
1236     // Mapping from token id to position in the allTokens array
1237     mapping(uint256 => uint256) private _allTokensIndex;
1238 
1239     /*
1240      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1241      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1242      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1243      *
1244      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1245      */
1246     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1247 
1248     /**
1249      * @dev Constructor function.
1250      */
1251     constructor () public {
1252         // register the supported interface to conform to ERC721Enumerable via ERC165
1253         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1254     }
1255 
1256     /**
1257      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1258      * @param owner address owning the tokens list to be accessed
1259      * @param index uint256 representing the index to be accessed of the requested tokens list
1260      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1261      */
1262     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1263         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1264         return _ownedTokens[owner][index];
1265     }
1266 
1267     /**
1268      * @dev Gets the total amount of tokens stored by the contract.
1269      * @return uint256 representing the total amount of tokens
1270      */
1271     function totalSupply() public view returns (uint256) {
1272         return _allTokens.length;
1273     }
1274 
1275     /**
1276      * @dev Gets the token ID at a given index of all the tokens in this contract
1277      * Reverts if the index is greater or equal to the total number of tokens.
1278      * @param index uint256 representing the index to be accessed of the tokens list
1279      * @return uint256 token ID at the given index of the tokens list
1280      */
1281     function tokenByIndex(uint256 index) public view returns (uint256) {
1282         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1283         return _allTokens[index];
1284     }
1285 
1286     /**
1287      * @dev Internal function to transfer ownership of a given token ID to another address.
1288      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1289      * @param from current owner of the token
1290      * @param to address to receive the ownership of the given token ID
1291      * @param tokenId uint256 ID of the token to be transferred
1292      */
1293     function _transferFrom(address from, address to, uint256 tokenId) internal {
1294         super._transferFrom(from, to, tokenId);
1295 
1296         _removeTokenFromOwnerEnumeration(from, tokenId);
1297 
1298         _addTokenToOwnerEnumeration(to, tokenId);
1299     }
1300 
1301     /**
1302      * @dev Internal function to mint a new token.
1303      * Reverts if the given token ID already exists.
1304      * @param to address the beneficiary that will own the minted token
1305      * @param tokenId uint256 ID of the token to be minted
1306      */
1307     function _mint(address to, uint256 tokenId) internal {
1308         super._mint(to, tokenId);
1309 
1310         _addTokenToOwnerEnumeration(to, tokenId);
1311 
1312         _addTokenToAllTokensEnumeration(tokenId);
1313     }
1314 
1315     /**
1316      * @dev Internal function to burn a specific token.
1317      * Reverts if the token does not exist.
1318      * Deprecated, use {ERC721-_burn} instead.
1319      * @param owner owner of the token to burn
1320      * @param tokenId uint256 ID of the token being burned
1321      */
1322     function _burn(address owner, uint256 tokenId) internal {
1323         super._burn(owner, tokenId);
1324 
1325         _removeTokenFromOwnerEnumeration(owner, tokenId);
1326         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1327         _ownedTokensIndex[tokenId] = 0;
1328 
1329         _removeTokenFromAllTokensEnumeration(tokenId);
1330     }
1331 
1332     /**
1333      * @dev Gets the list of token IDs of the requested owner.
1334      * @param owner address owning the tokens
1335      * @return uint256[] List of token IDs owned by the requested address
1336      */
1337     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1338         return _ownedTokens[owner];
1339     }
1340 
1341     /**
1342      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1343      * @param to address representing the new owner of the given token ID
1344      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1345      */
1346     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1347         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1348         _ownedTokens[to].push(tokenId);
1349     }
1350 
1351     /**
1352      * @dev Private function to add a token to this extension's token tracking data structures.
1353      * @param tokenId uint256 ID of the token to be added to the tokens list
1354      */
1355     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1356         _allTokensIndex[tokenId] = _allTokens.length;
1357         _allTokens.push(tokenId);
1358     }
1359 
1360     /**
1361      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1362      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1363      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1364      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1365      * @param from address representing the previous owner of the given token ID
1366      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1367      */
1368     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1369         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1370         // then delete the last slot (swap and pop).
1371 
1372         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1373         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1374 
1375         // When the token to delete is the last token, the swap operation is unnecessary
1376         if (tokenIndex != lastTokenIndex) {
1377             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1378 
1379             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1380             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1381         }
1382 
1383         // This also deletes the contents at the last position of the array
1384         _ownedTokens[from].length--;
1385 
1386         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1387         // lastTokenId, or just over the end of the array if the token was the last one).
1388     }
1389 
1390     /**
1391      * @dev Private function to remove a token from this extension's token tracking data structures.
1392      * This has O(1) time complexity, but alters the order of the _allTokens array.
1393      * @param tokenId uint256 ID of the token to be removed from the tokens list
1394      */
1395     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1396         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1397         // then delete the last slot (swap and pop).
1398 
1399         uint256 lastTokenIndex = _allTokens.length.sub(1);
1400         uint256 tokenIndex = _allTokensIndex[tokenId];
1401 
1402         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1403         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1404         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1405         uint256 lastTokenId = _allTokens[lastTokenIndex];
1406 
1407         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1408         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1409 
1410         // This also deletes the contents at the last position of the array
1411         _allTokens.length--;
1412         _allTokensIndex[tokenId] = 0;
1413     }
1414 }
1415 
1416 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1417 
1418 pragma solidity ^0.5.0;
1419 
1420 
1421 /**
1422  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1423  * @dev See https://eips.ethereum.org/EIPS/eip-721
1424  */
1425 contract IERC721Metadata is IERC721 {
1426     function name() external view returns (string memory);
1427     function symbol() external view returns (string memory);
1428     function tokenURI(uint256 tokenId) external view returns (string memory);
1429 }
1430 
1431 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
1432 
1433 pragma solidity ^0.5.0;
1434 
1435 
1436 
1437 
1438 
1439 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1440     // Token name
1441     string private _name;
1442 
1443     // Token symbol
1444     string private _symbol;
1445 
1446     // Optional mapping for token URIs
1447     mapping(uint256 => string) private _tokenURIs;
1448 
1449     /*
1450      *     bytes4(keccak256('name()')) == 0x06fdde03
1451      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1452      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1453      *
1454      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1455      */
1456     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1457 
1458     /**
1459      * @dev Constructor function
1460      */
1461     constructor (string memory name, string memory symbol) public {
1462         _name = name;
1463         _symbol = symbol;
1464 
1465         // register the supported interfaces to conform to ERC721 via ERC165
1466         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1467     }
1468 
1469     /**
1470      * @dev Gets the token name.
1471      * @return string representing the token name
1472      */
1473     function name() external view returns (string memory) {
1474         return _name;
1475     }
1476 
1477     /**
1478      * @dev Gets the token symbol.
1479      * @return string representing the token symbol
1480      */
1481     function symbol() external view returns (string memory) {
1482         return _symbol;
1483     }
1484 
1485     /**
1486      * @dev Returns an URI for a given token ID.
1487      * Throws if the token ID does not exist. May return an empty string.
1488      * @param tokenId uint256 ID of the token to query
1489      */
1490     function tokenURI(uint256 tokenId) external view returns (string memory) {
1491         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1492         return _tokenURIs[tokenId];
1493     }
1494 
1495     /**
1496      * @dev Internal function to set the token URI for a given token.
1497      * Reverts if the token ID does not exist.
1498      * @param tokenId uint256 ID of the token to set its URI
1499      * @param uri string URI to assign
1500      */
1501     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1502         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1503         _tokenURIs[tokenId] = uri;
1504     }
1505 
1506     /**
1507      * @dev Internal function to burn a specific token.
1508      * Reverts if the token does not exist.
1509      * Deprecated, use _burn(uint256) instead.
1510      * @param owner owner of the token to burn
1511      * @param tokenId uint256 ID of the token being burned by the msg.sender
1512      */
1513     function _burn(address owner, uint256 tokenId) internal {
1514         super._burn(owner, tokenId);
1515 
1516         // Clear metadata (if any)
1517         if (bytes(_tokenURIs[tokenId]).length != 0) {
1518             delete _tokenURIs[tokenId];
1519         }
1520     }
1521 }
1522 
1523 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1524 
1525 pragma solidity ^0.5.0;
1526 
1527 
1528 
1529 
1530 /**
1531  * @title Full ERC721 Token
1532  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1533  * Moreover, it includes approve all functionality using operator terminology.
1534  *
1535  * See https://eips.ethereum.org/EIPS/eip-721
1536  */
1537 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1538     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1539         // solhint-disable-previous-line no-empty-blocks
1540     }
1541 }
1542 
1543 // File: contracts/AvastarState.sol
1544 
1545 pragma solidity 0.5.14;
1546 
1547 
1548 
1549 
1550 
1551 /**
1552  * @title Avastar State
1553  * @author Cliff Hall
1554  * @notice This contract maintains the state variables for the Avastar Teleporter.
1555  */
1556 contract AvastarState is AvastarBase, AvastarTypes, AccessControl, ERC721Full {
1557 
1558     /**
1559      * @notice Calls ERC721Full constructor with token name and symbol.
1560      */
1561     constructor() public ERC721Full(TOKEN_NAME, TOKEN_SYMBOL) {}
1562 
1563     string public constant TOKEN_NAME = "Avastar";
1564     string public constant TOKEN_SYMBOL = "AVASTAR";
1565 
1566     /**
1567      * @notice All Avastars across all Waves and Generations
1568      */
1569     Avastar[] internal avastars;
1570 
1571     /**
1572      * @notice List of all Traits across all Generations
1573      */
1574     Trait[] internal traits;
1575 
1576     /**
1577      * @notice  Retrieve Primes by Generation
1578      * Prime[] primes = primesByGeneration[uint8(_generation)]
1579      */
1580     mapping(uint8 => Prime[]) internal primesByGeneration;
1581 
1582     /**
1583      * @notice Retrieve Replicants by Generation
1584      * Replicant[] replicants = replicantsByGeneration[uint8(_generation)]
1585      */
1586     mapping(uint8 => Replicant[]) internal replicantsByGeneration;
1587 
1588     /**
1589      * @notice Retrieve Artist Attribution by Generation
1590      * Attribution attribution = attributionByGeneration[Generation(_generation)]
1591      */
1592     mapping(uint8 => Attribution) public attributionByGeneration;
1593 
1594     /**
1595      * @notice Retrieve the approved Trait handler for a given Avastar Prime by Token ID
1596      */
1597     mapping(uint256 => address) internal traitHandlerByPrimeTokenId;
1598 
1599     /**
1600      * @notice Is a given Trait Hash used within a given Generation
1601      * bool used = isHashUsedByGeneration[uint8(_generation)][uint256(_traits)]
1602      * This mapping ensures that within a Generation, a given Trait Hash is unique and can only be used once
1603      */
1604     mapping(uint8 => mapping(uint256 => bool)) public isHashUsedByGeneration;
1605 
1606     /**
1607      * @notice Retrieve Token ID for a given Trait Hash within a given Generation
1608      * uint256 tokenId = tokenIdByGenerationAndHash[uint8(_generation)][uint256(_traits)]
1609      * Since Token IDs start at 0 and empty mappings for uint256 return 0, check isHashUsedByGeneration first
1610      */
1611     mapping(uint8 => mapping(uint256 => uint256)) public tokenIdByGenerationAndHash;
1612 
1613     /**
1614      * @notice Retrieve count of Primes and Promos by Generation and Series
1615      * uint16 count = primeCountByGenAndSeries[uint8(_generation)][uint8(_series)]
1616      */
1617     mapping(uint8 =>  mapping(uint8 => uint16)) public primeCountByGenAndSeries;
1618 
1619     /**
1620      * @notice Retrieve count of Replicants by Generation
1621      * uint16 count = replicantCountByGeneration[uint8(_generation)]
1622      */
1623     mapping(uint8 => uint16) public replicantCountByGeneration;
1624 
1625     /**
1626      * @notice Retrieve the Token ID for an Avastar by a given Generation, Wave, and Serial
1627      * uint256 tokenId = tokenIdByGenerationWaveAndSerial[uint8(_generation)][uint256(_wave)][uint256(_serial)]
1628      */
1629     mapping(uint8 => mapping(uint8 => mapping(uint256 => uint256))) public tokenIdByGenerationWaveAndSerial;
1630 
1631     /**
1632      * @notice Retrieve the Trait ID for a Trait from a given Generation by Gene and Variation
1633      * uint256 traitId = traitIdByGenerationGeneAndVariation[uint8(_generation)][uint8(_gene)][uint8(_variation)]
1634      */
1635     mapping(uint8 => mapping(uint8 => mapping(uint8 => uint256))) public traitIdByGenerationGeneAndVariation;
1636 
1637 }
1638 
1639 // File: contracts/TraitFactory.sol
1640 
1641 pragma solidity 0.5.14;
1642 
1643 
1644 /**
1645  * @title Avastar Trait Factory
1646  * @author Cliff Hall
1647  */
1648 contract TraitFactory is AvastarState {
1649 
1650     /**
1651      * @notice Event emitted when a new Trait is created.
1652      * @param id the Trait ID
1653      * @param generation the generation of the trait
1654      * @param gene the gene that the trait is a variation of
1655      * @param rarity the rarity level of this trait
1656      * @param variation variation of the gene the trait represents
1657      * @param name the name of the trait
1658      */
1659     event NewTrait(uint256 id, Generation generation, Gene gene, Rarity rarity, uint8 variation, string name);
1660 
1661     /**
1662      * @notice Event emitted when artist attribution is set for a generation.
1663      * @param generation the generation that attribution was set for
1664      * @param artist the artist who created the artwork for the generation
1665      * @param infoURI the artist's website / portfolio URI
1666      */
1667     event AttributionSet(Generation generation, string artist, string infoURI);
1668 
1669     /**
1670      * @notice Event emitted when a Trait's art is created.
1671      * @param id the Trait ID
1672      */
1673     event TraitArtExtended(uint256 id);
1674 
1675     /**
1676      * @notice Modifier to ensure no trait modification after a generation's
1677      * Avastar production has begun.
1678      * @param _generation the generation to check production status of
1679      */
1680     modifier onlyBeforeProd(Generation _generation) {
1681         require(primesByGeneration[uint8(_generation)].length == 0 && replicantsByGeneration[uint8(_generation)].length == 0);
1682         _;
1683     }
1684 
1685     /**
1686      * @notice Get Trait ID by Generation, Gene, and Variation.
1687      * @param _generation the generation the trait belongs to
1688      * @param _gene gene the trait belongs to
1689      * @param _variation the variation of the gene
1690      * @return traitId the ID of the specified trait
1691      */
1692     function getTraitIdByGenerationGeneAndVariation(
1693         Generation _generation,
1694         Gene _gene,
1695         uint8 _variation
1696     )
1697     external view
1698     returns (uint256 traitId)
1699     {
1700         return traitIdByGenerationGeneAndVariation[uint8(_generation)][uint8(_gene)][_variation];
1701     }
1702 
1703     /**
1704      * @notice Retrieve a Trait's info by ID.
1705      * @param _traitId the ID of the Trait to retrieve
1706      * @return id the ID of the trait
1707      * @return generation generation of the trait
1708      * @return series list of series the trait may appear in
1709      * @return gender gender(s) the trait is valid for
1710      * @return gene gene the trait belongs to
1711      * @return variation variation of the gene the trait represents
1712      * @return rarity the rarity level of this trait
1713      * @return name name of the trait
1714      */
1715     function getTraitInfoById(uint256 _traitId)
1716     external view
1717     returns (
1718         uint256 id,
1719         Generation generation,
1720         Series[] memory series,
1721         Gender gender,
1722         Gene gene,
1723         Rarity rarity,
1724         uint8 variation,
1725         string memory name
1726     ) {
1727         require(_traitId < traits.length);
1728         Trait memory trait = traits[_traitId];
1729         return (
1730             trait.id,
1731             trait.generation,
1732             trait.series,
1733             trait.gender,
1734             trait.gene,
1735             trait.rarity,
1736             trait.variation,
1737             trait.name
1738         );
1739     }
1740 
1741     /**
1742      * @notice Retrieve a Trait's name by ID.
1743      * @param _traitId the ID of the Trait to retrieve
1744      * @return name name of the trait
1745      */
1746     function getTraitNameById(uint256 _traitId)
1747     external view
1748     returns (string memory name) {
1749         require(_traitId < traits.length);
1750         name = traits[_traitId].name;
1751     }
1752 
1753     /**
1754      * @notice Retrieve a Trait's art by ID.
1755      * Only invokable by a system administrator.
1756      * @param _traitId the ID of the Trait to retrieve
1757      * @return art the svg layer representation of the trait
1758      */
1759     function getTraitArtById(uint256 _traitId)
1760     external view onlySysAdmin
1761     returns (string memory art) {
1762         require(_traitId < traits.length);
1763         Trait memory trait = traits[_traitId];
1764         art = trait.svg;
1765     }
1766 
1767     /**
1768      * @notice Get the artist Attribution info for a given Generation, combined into a single string.
1769      * @param _generation the generation to retrieve artist attribution for
1770      * @return attrib a single string with the artist and artist info URI
1771      */
1772     function getAttributionByGeneration(Generation _generation)
1773     external view
1774     returns (
1775         string memory attribution
1776     ){
1777         Attribution memory attrib = attributionByGeneration[uint8(_generation)];
1778         require(bytes(attrib.artist).length > 0);
1779         attribution = strConcat(attribution, attrib.artist);
1780         attribution = strConcat(attribution, ' (');
1781         attribution = strConcat(attribution, attrib.infoURI);
1782         attribution = strConcat(attribution, ')');
1783     }
1784 
1785     /**
1786      * @notice Set the artist Attribution for a given Generation
1787      * @param _generation the generation to set artist attribution for
1788      * @param _artist the artist who created the art for the generation
1789      * @param _infoURI the URI for the artist's website / portfolio
1790      */
1791     function setAttribution(
1792         Generation _generation,
1793         string calldata _artist,
1794         string calldata _infoURI
1795     )
1796     external onlySysAdmin onlyBeforeProd(_generation)
1797     {
1798         require(bytes(_artist).length > 0 && bytes(_infoURI).length > 0);
1799         attributionByGeneration[uint8(_generation)] = Attribution(_generation, _artist, _infoURI);
1800         emit AttributionSet(_generation, _artist, _infoURI);
1801     }
1802 
1803     /**
1804      * @notice Create a Trait
1805      * @param _generation the generation the trait belongs to
1806      * @param _series list of series the trait may appear in
1807      * @param _gender gender the trait is valid for
1808      * @param _gene gene the trait belongs to
1809      * @param _rarity the rarity level of this trait
1810      * @param _variation the variation of the gene the trait belongs to
1811      * @param _name the name of the trait
1812      * @param _svg svg layer representation of the trait
1813      * @return traitId the token ID of the newly created trait
1814      */
1815     function createTrait(
1816         Generation _generation,
1817         Series[] calldata _series,
1818         Gender _gender,
1819         Gene _gene,
1820         Rarity _rarity,
1821         uint8 _variation,
1822         string calldata _name,
1823         string calldata _svg
1824     )
1825     external onlySysAdmin whenNotPaused onlyBeforeProd(_generation)
1826     returns (uint256 traitId)
1827     {
1828         require(_series.length > 0);
1829         require(bytes(_name).length > 0);
1830         require(bytes(_svg).length > 0);
1831 
1832         // Get Trait ID
1833         traitId = traits.length;
1834 
1835         // Create and store trait
1836         traits.push(
1837             Trait(traitId, _generation, _gender, _gene, _rarity, _variation,  _series, _name, _svg)
1838         );
1839 
1840         // Create generation/gene/variation to traitId mapping required by assembleArtwork
1841         traitIdByGenerationGeneAndVariation[uint8(_generation)][uint8(_gene)][uint8(_variation)] = traitId;
1842 
1843         // Send the NewTrait event
1844         emit NewTrait(traitId, _generation, _gene, _rarity, _variation, _name);
1845 
1846         // Return the new Trait ID
1847         return traitId;
1848     }
1849 
1850     /**
1851      * @notice Extend a Trait's art.
1852      * Only invokable by a system administrator.
1853      * If successful, emits a `TraitArtExtended` event with the resultant artwork.
1854      * @param _traitId the ID of the Trait to retrieve
1855      * @param _svg the svg content to be concatenated to the existing svg property
1856      */
1857     function extendTraitArt(uint256 _traitId, string calldata _svg)
1858     external onlySysAdmin whenNotPaused onlyBeforeProd(traits[_traitId].generation)
1859     {
1860         require(_traitId < traits.length);
1861         string memory art = strConcat(traits[_traitId].svg, _svg);
1862         traits[_traitId].svg = art;
1863         emit TraitArtExtended(_traitId);
1864     }
1865 
1866     /**
1867      * @notice Assemble the artwork for a given Trait hash with art from the given Generation
1868      * @param _generation the generation the Avastar belongs to
1869      * @param _traitHash the Avastar's trait hash
1870      * @return svg the fully rendered SVG for the Avastar
1871      */
1872     function assembleArtwork(Generation _generation, uint256 _traitHash)
1873     internal view
1874     returns (string memory svg)
1875     {
1876         require(_traitHash > 0);
1877         string memory accumulator = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" height="1000px" width="1000px" viewBox="0 0 1000 1000">';
1878         uint256 slotConst = 256;
1879         uint256 slotMask = 255;
1880         uint256 bitMask;
1881         uint256 slottedValue;
1882         uint256 slotMultiplier;
1883         uint256 variation;
1884         uint256 traitId;
1885         Trait memory trait;
1886 
1887         // Iterate trait hash by Gene and assemble SVG sandwich
1888         for (uint8 slot = 0; slot <= uint8(Gene.HAIR_STYLE); slot++){
1889             slotMultiplier = uint256(slotConst**slot);  // Create slot multiplier
1890             bitMask = slotMask * slotMultiplier;        // Create bit mask for slot
1891             slottedValue = _traitHash & bitMask;        // Extract slotted value from hash
1892             if (slottedValue > 0) {
1893                 variation = (slot > 0)                  // Extract variation from slotted value
1894                     ? slottedValue / slotMultiplier
1895                     : slottedValue;
1896                 if (variation > 0) {
1897                     traitId = traitIdByGenerationGeneAndVariation[uint8(_generation)][slot][uint8(variation)];
1898                     trait = traits[traitId];
1899                     accumulator = strConcat(accumulator, trait.svg);
1900                 }
1901             }
1902         }
1903 
1904         return strConcat(accumulator, '</svg>');
1905     }
1906 
1907 }
1908 
1909 // File: contracts/AvastarFactory.sol
1910 
1911 pragma solidity 0.5.14;
1912 
1913 
1914 /**
1915  * @title Avastar Token Factory
1916  * @author Cliff Hall
1917  */
1918 contract AvastarFactory is TraitFactory {
1919 
1920     /**
1921      * @notice Mint an Avastar.
1922      * Only invokable by descendant contracts when contract is not paused.
1923      * Adds new `Avastar` to `avastars` array.
1924      * Doesn't emit an event, the calling method does (`NewPrime` or `NewReplicant`).
1925      * Sets `isHashUsedByGeneration` mapping to true for `avastar.generation` and `avastar.traits`.
1926      * Sets `tokenIdByGenerationAndHash` mapping to `avastar.id` for `avastar.generation` and `avastar.traits`.
1927      * Sets `tokenIdByGenerationWaveAndSerial` mapping to `avastar.id` for `avastar.generation`, `avastar.wave`, and `avastar.serial`.
1928      * @param _owner the address of the new Avastar's owner
1929      * @param _serial the new Avastar's Prime or Replicant serial number
1930      * @param _traits the new Avastar's trait hash
1931      * @param _generation the new Avastar's generation
1932      * @param _wave the new Avastar's wave (Prime/Replicant)
1933      * @return tokenId the newly minted Prime's token ID
1934      */
1935     function mintAvastar(
1936         address _owner,
1937         uint256 _serial,
1938         uint256 _traits,
1939         Generation _generation,
1940         Wave _wave
1941     )
1942     internal whenNotPaused
1943     returns (uint256 tokenId)
1944     {
1945         // Mapped Token Id for given generation and serial should always be 0 (uninitialized)
1946         require(tokenIdByGenerationWaveAndSerial[uint8(_generation)][uint8(_wave)][_serial] == 0);
1947 
1948         // Serial should always be the current length of the primes or replicants array for the given generation
1949         if (_wave == Wave.PRIME){
1950             require(_serial == primesByGeneration[uint8(_generation)].length);
1951         } else {
1952             require(_serial == replicantsByGeneration[uint8(_generation)].length);
1953         }
1954 
1955         // Get Token ID
1956         tokenId = avastars.length;
1957 
1958         // Create and store Avastar token
1959         Avastar memory avastar = Avastar(tokenId, _serial, _traits, _generation, _wave);
1960 
1961         // Store the avastar
1962         avastars.push(avastar);
1963 
1964         // Indicate use of Trait Hash within given generation
1965         isHashUsedByGeneration[uint8(avastar.generation)][avastar.traits] = true;
1966 
1967         // Store token ID by Generation and Trait Hash
1968         tokenIdByGenerationAndHash[uint8(avastar.generation)][avastar.traits] = avastar.id;
1969 
1970         // Create generation/wave/serial to tokenId mapping
1971         tokenIdByGenerationWaveAndSerial[uint8(avastar.generation)][uint8(avastar.wave)][avastar.serial] = avastar.id;
1972 
1973         // Mint the token
1974         super._mint(_owner, tokenId);
1975     }
1976 
1977     /**
1978      * @notice Get an Avastar's Wave by token ID.
1979      * @param _tokenId the token id of the given Avastar
1980      * @return wave the Avastar's wave (Prime/Replicant)
1981      */
1982     function getAvastarWaveByTokenId(uint256 _tokenId)
1983     external view
1984     returns (Wave wave)
1985     {
1986         require(_tokenId < avastars.length);
1987         wave = avastars[_tokenId].wave;
1988     }
1989 
1990     /**
1991      * @notice Render the Avastar Prime or Replicant from the original on-chain art.
1992      * @param _tokenId the token ID of the Prime or Replicant
1993      * @return svg the fully rendered SVG representation of the Avastar
1994      */
1995     function renderAvastar(uint256 _tokenId)
1996     external view
1997     returns (string memory svg)
1998     {
1999         require(_tokenId < avastars.length);
2000         Avastar memory avastar = avastars[_tokenId];
2001         uint256 traits = (avastar.wave == Wave.PRIME)
2002         ? primesByGeneration[uint8(avastar.generation)][avastar.serial].traits
2003         : replicantsByGeneration[uint8(avastar.generation)][avastar.serial].traits;
2004         svg = assembleArtwork(avastar.generation, traits);
2005     }
2006 }
2007 
2008 // File: contracts/PrimeFactory.sol
2009 
2010 pragma solidity 0.5.14;
2011 
2012 
2013 /**
2014  * @title Avastar Prime Factory
2015  * @author Cliff Hall
2016  */
2017 contract PrimeFactory is AvastarFactory {
2018 
2019     /**
2020      * @notice Maximum number of primes that can be minted in
2021      * any given series for any generation.
2022      */
2023     uint16 public constant MAX_PRIMES_PER_SERIES = 5000;
2024     uint16 public constant MAX_PROMO_PRIMES_PER_GENERATION = 200;
2025 
2026     /**
2027      * @notice Event emitted upon the creation of an Avastar Prime
2028      * @param id the token ID of the newly minted Prime
2029      * @param serial the serial of the Prime
2030      * @param generation the generation of the Prime
2031      * @param series the series of the Prime
2032      * @param gender the gender of the Prime
2033      * @param traits the trait hash of the Prime
2034      */
2035     event NewPrime(uint256 id, uint256 serial, Generation generation, Series series, Gender gender, uint256 traits);
2036 
2037     /**
2038      * @notice Get the Avastar Prime metadata associated with a given Generation and Serial.
2039      * Does not include the trait replication flags.
2040      * @param _generation the Generation of the Prime
2041      * @param _serial the Serial of the Prime
2042      * @return tokenId the Prime's token ID
2043      * @return serial the Prime's serial
2044      * @return traits the Prime's trait hash
2045      * @return replicated the Prime's trait replication indicators
2046      * @return generation the Prime's generation
2047      * @return series the Prime's series
2048      * @return gender the Prime's gender
2049      * @return ranking the Prime's ranking
2050      */
2051     function getPrimeByGenerationAndSerial(Generation _generation, uint256 _serial)
2052     external view
2053     returns (
2054         uint256 tokenId,
2055         uint256 serial,
2056         uint256 traits,
2057         Generation generation,
2058         Series series,
2059         Gender gender,
2060         uint8 ranking
2061     ) {
2062         require(_serial < primesByGeneration[uint8(_generation)].length);
2063         Prime memory prime = primesByGeneration[uint8(_generation)][_serial];
2064         return (
2065             prime.id,
2066             prime.serial,
2067             prime.traits,
2068             prime.generation,
2069             prime.series,
2070             prime.gender,
2071             prime.ranking
2072         );
2073     }
2074 
2075     /**
2076      * @notice Get the Avastar Prime associated with a given Token ID.
2077      * Does not include the trait replication flags.
2078      * @param _tokenId the Token ID of the specified Prime
2079      * @return tokenId the Prime's token ID
2080      * @return serial the Prime's serial
2081      * @return traits the Prime's trait hash
2082      * @return generation the Prime's generation
2083      * @return series the Prime's series
2084      * @return gender the Prime's gender
2085      * @return ranking the Prime's ranking
2086      */
2087     function getPrimeByTokenId(uint256 _tokenId)
2088     external view
2089     returns (
2090         uint256 tokenId,
2091         uint256 serial,
2092         uint256 traits,
2093         Generation generation,
2094         Series series,
2095         Gender gender,
2096         uint8 ranking
2097     ) {
2098         require(_tokenId < avastars.length);
2099         Avastar memory avastar = avastars[_tokenId];
2100         require(avastar.wave ==  Wave.PRIME);
2101         Prime memory prime = primesByGeneration[uint8(avastar.generation)][avastar.serial];
2102         return (
2103             prime.id,
2104             prime.serial,
2105             prime.traits,
2106             prime.generation,
2107             prime.series,
2108             prime.gender,
2109             prime.ranking
2110         );
2111     }
2112 
2113     /**
2114      * @notice Get an Avastar Prime's replication flags by token ID.
2115      * @param _tokenId the token ID of the specified Prime
2116      * @return tokenId the Prime's token ID
2117      * @return replicated the Prime's trait replication flags
2118      */
2119     function getPrimeReplicationByTokenId(uint256 _tokenId)
2120     external view
2121     returns (
2122         uint256 tokenId,
2123         bool[12] memory replicated
2124     ) {
2125         require(_tokenId < avastars.length);
2126         Avastar memory avastar = avastars[_tokenId];
2127         require(avastar.wave ==  Wave.PRIME);
2128         Prime memory prime = primesByGeneration[uint8(avastar.generation)][avastar.serial];
2129         return (
2130             prime.id,
2131             prime.replicated
2132         );
2133     }
2134 
2135     /**
2136      * @notice Mint an Avastar Prime
2137      * Only invokable by minter role, when contract is not paused.
2138      * If successful, emits a `NewPrime` event.
2139      * @param _owner the address of the new Avastar's owner
2140      * @param _traits the new Prime's trait hash
2141      * @param _generation the new Prime's generation
2142      * @return _series the new Prime's series
2143      * @param _gender the new Prime's gender
2144      * @param _ranking the new Prime's rarity ranking
2145      * @return tokenId the newly minted Prime's token ID
2146      * @return serial the newly minted Prime's serial
2147      */
2148     function mintPrime(
2149         address _owner,
2150         uint256 _traits,
2151         Generation _generation,
2152         Series _series,
2153         Gender _gender,
2154         uint8 _ranking
2155     )
2156     external onlyMinter whenNotPaused
2157     returns (uint256 tokenId, uint256 serial)
2158     {
2159         require(_owner != address(0));
2160         require(_traits != 0);
2161         require(isHashUsedByGeneration[uint8(_generation)][_traits] == false);
2162         require(_ranking > 0 && _ranking <= 100);
2163         uint16 count = primeCountByGenAndSeries[uint8(_generation)][uint8(_series)];
2164         if (_series != Series.PROMO) {
2165             require(count < MAX_PRIMES_PER_SERIES);
2166         } else {
2167             require(count < MAX_PROMO_PRIMES_PER_GENERATION);
2168         }
2169 
2170         // Get Prime Serial and mint Avastar, getting tokenId
2171         serial = primesByGeneration[uint8(_generation)].length;
2172         tokenId = mintAvastar(_owner, serial, _traits, _generation, Wave.PRIME);
2173 
2174         // Create and store Prime struct
2175         bool[12] memory replicated;
2176         primesByGeneration[uint8(_generation)].push(
2177             Prime(tokenId, serial, _traits, replicated, _generation, _series, _gender, _ranking)
2178         );
2179 
2180         // Increment count for given Generation/Series
2181         primeCountByGenAndSeries[uint8(_generation)][uint8(_series)]++;
2182 
2183         // Send the NewPrime event
2184         emit NewPrime(tokenId, serial, _generation, _series, _gender, _traits);
2185 
2186         // Return the tokenId, serial
2187         return (tokenId, serial);
2188     }
2189 
2190 }
2191 
2192 // File: contracts/ReplicantFactory.sol
2193 
2194 pragma solidity 0.5.14;
2195 
2196 
2197 /**
2198  * @title Avastar Replicant Factory
2199  * @author Cliff Hall
2200  */
2201 contract ReplicantFactory is PrimeFactory {
2202 
2203     /**
2204      * @notice Maximum number of Replicants that can be minted
2205      * in any given generation.
2206      */
2207     uint16 public constant MAX_REPLICANTS_PER_GENERATION = 25200;
2208 
2209     /**
2210      * @notice Event emitted upon the creation of an Avastar Replicant
2211      * @param id the token ID of the newly minted Replicant
2212      * @param serial the serial of the Replicant
2213      * @param generation the generation of the Replicant
2214      * @param gender the gender of the Replicant
2215      * @param traits the trait hash of the Replicant
2216      */
2217     event NewReplicant(uint256 id, uint256 serial, Generation generation, Gender gender, uint256 traits);
2218 
2219     /**
2220      * @notice Get the Avastar Replicant metadata associated with a given Generation and Serial
2221      * @param _generation the generation of the specified Replicant
2222      * @param _serial the serial of the specified Replicant
2223      * @return tokenId the Replicant's token ID
2224      * @return serial the Replicant's serial
2225      * @return traits the Replicant's trait hash
2226      * @return generation the Replicant's generation
2227      * @return gender the Replicant's gender
2228      * @return ranking the Replicant's ranking
2229      */
2230     function getReplicantByGenerationAndSerial(Generation _generation, uint256 _serial)
2231     external view
2232     returns (
2233         uint256 tokenId,
2234         uint256 serial,
2235         uint256 traits,
2236         Generation generation,
2237         Gender gender,
2238         uint8 ranking
2239     ) {
2240         require(_serial < replicantsByGeneration[uint8(_generation)].length);
2241         Replicant memory replicant = replicantsByGeneration[uint8(_generation)][_serial];
2242         return (
2243             replicant.id,
2244             replicant.serial,
2245             replicant.traits,
2246             replicant.generation,
2247             replicant.gender,
2248             replicant.ranking
2249         );
2250     }
2251 
2252     /**
2253      * @notice Get the Avastar Replicant associated with a given Token ID
2254      * @param _tokenId the token ID of the specified Replicant
2255      * @return tokenId the Replicant's token ID
2256      * @return serial the Replicant's serial
2257      * @return traits the Replicant's trait hash
2258      * @return generation the Replicant's generation
2259      * @return gender the Replicant's gender
2260      * @return ranking the Replicant's ranking
2261      */
2262     function getReplicantByTokenId(uint256 _tokenId)
2263     external view
2264     returns (
2265         uint256 tokenId,
2266         uint256 serial,
2267         uint256 traits,
2268         Generation generation,
2269         Gender gender,
2270         uint8 ranking
2271     ) {
2272         require(_tokenId < avastars.length);
2273         Avastar memory avastar = avastars[_tokenId];
2274         require(avastar.wave ==  Wave.REPLICANT);
2275         Replicant memory replicant = replicantsByGeneration[uint8(avastar.generation)][avastar.serial];
2276         return (
2277             replicant.id,
2278             replicant.serial,
2279             replicant.traits,
2280             replicant.generation,
2281             replicant.gender,
2282             replicant.ranking
2283         );
2284     }
2285 
2286     /**
2287      * @notice Mint an Avastar Replicant.
2288      * Only invokable by minter role, when contract is not paused.
2289      * If successful, emits a `NewReplicant` event.
2290      * @param _owner the address of the new Avastar's owner
2291      * @param _traits the new Replicant's trait hash
2292      * @param _generation the new Replicant's generation
2293      * @param _gender the new Replicant's gender
2294      * @param _ranking the new Replicant's rarity ranking
2295      * @return tokenId the newly minted Replicant's token ID
2296      * @return serial the newly minted Replicant's serial
2297      */
2298     function mintReplicant(
2299         address _owner,
2300         uint256 _traits,
2301         Generation _generation,
2302         Gender _gender,
2303         uint8 _ranking
2304     )
2305     external onlyMinter whenNotPaused
2306     returns (uint256 tokenId, uint256 serial)
2307     {
2308         require(_traits != 0);
2309         require(isHashUsedByGeneration[uint8(_generation)][_traits] == false);
2310         require(_ranking > 0 && _ranking <= 100);
2311         require(replicantCountByGeneration[uint8(_generation)] < MAX_REPLICANTS_PER_GENERATION);
2312 
2313         // Get Replicant Serial and mint Avastar, getting tokenId
2314         serial = replicantsByGeneration[uint8(_generation)].length;
2315         tokenId = mintAvastar(_owner, serial, _traits, _generation, Wave.REPLICANT);
2316 
2317         // Create and store Replicant struct
2318         replicantsByGeneration[uint8(_generation)].push(
2319             Replicant(tokenId, serial, _traits, _generation, _gender, _ranking)
2320         );
2321 
2322         // Increment count for given Generation
2323         replicantCountByGeneration[uint8(_generation)]++;
2324 
2325         // Send the NewReplicant event
2326         emit NewReplicant(tokenId, serial, _generation, _gender, _traits);
2327 
2328         // Return the tokenId, serial
2329         return (tokenId, serial);
2330     }
2331 
2332 }
2333 
2334 // File: contracts/IAvastarMetadata.sol
2335 
2336 pragma solidity 0.5.14;
2337 
2338 /**
2339  * @title Identification interface for Avastar Metadata generator contract
2340  * @author Cliff Hall
2341  * @notice Used by `AvastarTeleporter` contract to validate the address of the contract.
2342  */
2343 interface IAvastarMetadata {
2344 
2345     /**
2346      * @notice Acknowledge contract is `AvastarMetadata`
2347      * @return always true
2348      */
2349     function isAvastarMetadata() external pure returns (bool);
2350 
2351     /**
2352      * @notice Get token URI for a given Avastar Token ID.
2353      * @param _tokenId the Token ID of a previously minted Avastar Prime or Replicant
2354      * @return uri the Avastar's off-chain JSON metadata URI
2355      */
2356     function tokenURI(uint _tokenId)
2357     external view
2358     returns (string memory uri);
2359 }
2360 
2361 // File: contracts/AvastarTeleporter.sol
2362 
2363 pragma solidity 0.5.14;
2364 
2365 
2366 
2367 /**
2368  * @title AvastarTeleporter
2369  * @author Cliff Hall
2370  * @notice Management of Avastar Primes, Replicants, and Traits
2371  */
2372 contract AvastarTeleporter is ReplicantFactory {
2373 
2374     /**
2375      * @notice Event emitted when a handler is approved to manage Trait replication.
2376      * @param handler the address being approved to Trait replication
2377      * @param primeIds the array of Avastar Prime tokenIds the handler can use
2378      */
2379     event TraitAccessApproved(address indexed handler, uint256[] primeIds);
2380 
2381     /**
2382      * @notice Event emitted when a handler replicates Traits.
2383      * @param handler the address marking the Traits as used
2384      * @param primeId the token id of the Prime supplying the Traits
2385      * @param used the array of flags representing the Primes resulting Trait usage
2386      */
2387     event TraitsUsed(address indexed handler, uint256 primeId, bool[12] used);
2388 
2389     /**
2390      * @notice Event emitted when AvastarMetadata contract address is set
2391      * @param contractAddress the address of the new AvastarMetadata contract
2392      */
2393     event MetadataContractAddressSet(address contractAddress);
2394 
2395     /**
2396      * @notice Address of the AvastarMetadata contract
2397      */
2398     address private metadataContractAddress;
2399 
2400     /**
2401      * @notice Acknowledge contract is `AvastarTeleporter`
2402      * @return always true
2403      */
2404     function isAvastarTeleporter() external pure returns (bool) {return true;}
2405 
2406     /**
2407      * @notice Set the address of the `AvastarMetadata` contract.
2408      * Only invokable by system admin role, when contract is paused and not upgraded.
2409      * If successful, emits an `MetadataContractAddressSet` event.
2410      * @param _address address of AvastarTeleporter contract
2411      */
2412     function setMetadataContractAddress(address _address)
2413     external onlySysAdmin whenPaused whenNotUpgraded
2414     {
2415         // Cast the candidate contract to the IAvastarMetadata interface
2416         IAvastarMetadata candidateContract = IAvastarMetadata(_address);
2417 
2418         // Verify that we have the appropriate address
2419         require(candidateContract.isAvastarMetadata());
2420 
2421         // Set the contract address
2422         metadataContractAddress = _address;
2423 
2424         // Emit the event
2425         emit MetadataContractAddressSet(_address);
2426     }
2427 
2428     /**
2429      * @notice Get the current address of the `AvastarMetadata` contract.
2430      * return contractAddress the address of the `AvastarMetadata` contract
2431      */
2432     function getMetadataContractAddress()
2433     external view
2434     returns (address contractAddress) {
2435         return metadataContractAddress;
2436     }
2437 
2438     /**
2439      * @notice Get token URI for a given Avastar Token ID.
2440      * Reverts if given token id is not a valid Avastar Token ID.
2441      * @param _tokenId the Token ID of a previously minted Avastar Prime or Replicant
2442      * @return uri the Avastar's off-chain JSON metadata URI
2443      */
2444     function tokenURI(uint _tokenId)
2445     external view
2446     returns (string memory uri)
2447     {
2448         require(_tokenId < avastars.length);
2449         return IAvastarMetadata(metadataContractAddress).tokenURI(_tokenId);
2450     }
2451 
2452     /**
2453      * @notice Approve a handler to manage Trait replication for a set of Avastar Primes.
2454      * Accepts up to 256 primes for approval per call.
2455      * Reverts if caller is not owner of all Primes specified.
2456      * Reverts if no Primes are specified.
2457      * Reverts if given handler already has approval for all Primes specified.
2458      * If successful, emits a `TraitAccessApproved` event.
2459      * @param _handler the address approved for Trait access
2460      * @param _primeIds the token ids for which to approve the handler
2461      */
2462     function approveTraitAccess(address _handler, uint256[] calldata _primeIds)
2463     external
2464     {
2465         require(_primeIds.length > 0 && _primeIds.length <= 256);
2466         uint256 primeId;
2467         bool approvedAtLeast1 = false;
2468         for (uint8 i = 0; i < _primeIds.length; i++) {
2469             primeId = _primeIds[i];
2470             require(primeId < avastars.length);
2471             require(msg.sender == super.ownerOf(primeId), "Must be token owner");
2472             if (traitHandlerByPrimeTokenId[primeId] != _handler) {
2473                 traitHandlerByPrimeTokenId[primeId] = _handler;
2474                 approvedAtLeast1 = true;
2475             }
2476         }
2477         require(approvedAtLeast1, "No unhandled primes specified");
2478 
2479         // Emit the event
2480         emit TraitAccessApproved(_handler, _primeIds);
2481     }
2482 
2483     /**
2484      * @notice Mark some or all of an Avastar Prime's traits used.
2485      * Caller must be the token owner OR the approved handler.
2486      * Caller must send all 12 flags with those to be used set to true, the rest to false.
2487      * The position of each flag in the `_traitFlags` array corresponds to a Gene, of which Traits are variations.
2488      * The flag order is: [ SKIN_TONE, HAIR_COLOR, EYE_COLOR, BG_COLOR, BACKDROP, EARS, FACE, NOSE, MOUTH, FACIAL_FEATURE, EYES, HAIR_STYLE ].
2489      * Reverts if no usable traits are indicated.
2490      * If successful, emits a `TraitsUsed` event.
2491      * @param _primeId the token id for the Prime whose Traits are to be used
2492      * @param _traitFlags an array of no more than 12 booleans representing the Traits to be used
2493      */
2494     function useTraits(uint256 _primeId, bool[12] calldata _traitFlags)
2495     external
2496     {
2497         // Make certain token id is valid
2498         require(_primeId < avastars.length);
2499 
2500         // Make certain caller is token owner OR approved handler
2501         require(msg.sender == super.ownerOf(_primeId) || msg.sender == traitHandlerByPrimeTokenId[_primeId],
2502         "Must be token owner or approved handler" );
2503 
2504         // Get the Avastar and make sure it's a Prime
2505         Avastar memory avastar = avastars[_primeId];
2506         require(avastar.wave == Wave.PRIME);
2507 
2508         // Get the Prime
2509         Prime storage prime = primesByGeneration[uint8(avastar.generation)][avastar.serial];
2510 
2511         // Set the flags.
2512         bool usedAtLeast1;
2513         for (uint8 i = 0; i < 12; i++) {
2514             if (_traitFlags.length > i ) {
2515                 if ( !prime.replicated[i] && _traitFlags[i] ) {
2516                     prime.replicated[i] = true;
2517                     usedAtLeast1 = true;
2518                 }
2519             } else {
2520                 break;
2521             }
2522         }
2523 
2524         // Revert if no flags changed
2525         require(usedAtLeast1, "No reusable traits specified");
2526 
2527         // Clear trait handler
2528         traitHandlerByPrimeTokenId[_primeId] = address(0);
2529 
2530         // Emit the TraitsUsed event
2531         emit TraitsUsed(msg.sender, _primeId, prime.replicated);
2532     }
2533 
2534 }