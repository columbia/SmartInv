1 // File: @openzeppelin/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev Give an account access to this role.
16      */
17     function add(Role storage role, address account) internal {
18         require(!has(role, account), "Roles: account already has role");
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev Remove an account's access to this role.
24      */
25     function remove(Role storage role, address account) internal {
26         require(has(role, account), "Roles: account does not have role");
27         role.bearer[account] = false;
28     }
29 
30     /**
31      * @dev Check if an account has this role.
32      * @return bool
33      */
34     function has(Role storage role, address account) internal view returns (bool) {
35         require(account != address(0), "Roles: account is the zero address");
36         return role.bearer[account];
37     }
38 }
39 
40 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
41 
42 pragma solidity ^0.5.0;
43 
44 
45 /**
46  * @title WhitelistAdminRole
47  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
48  */
49 contract WhitelistAdminRole {
50     using Roles for Roles.Role;
51 
52     event WhitelistAdminAdded(address indexed account);
53     event WhitelistAdminRemoved(address indexed account);
54 
55     Roles.Role private _whitelistAdmins;
56 
57     constructor () internal {
58         _addWhitelistAdmin(msg.sender);
59     }
60 
61     modifier onlyWhitelistAdmin() {
62         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
63         _;
64     }
65 
66     function isWhitelistAdmin(address account) public view returns (bool) {
67         return _whitelistAdmins.has(account);
68     }
69 
70     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
71         _addWhitelistAdmin(account);
72     }
73 
74     function renounceWhitelistAdmin() public {
75         _removeWhitelistAdmin(msg.sender);
76     }
77 
78     function _addWhitelistAdmin(address account) internal {
79         _whitelistAdmins.add(account);
80         emit WhitelistAdminAdded(account);
81     }
82 
83     function _removeWhitelistAdmin(address account) internal {
84         _whitelistAdmins.remove(account);
85         emit WhitelistAdminRemoved(account);
86     }
87 }
88 
89 // File: @openzeppelin/contracts/access/roles/WhitelistedRole.sol
90 
91 pragma solidity ^0.5.0;
92 
93 
94 
95 /**
96  * @title WhitelistedRole
97  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
98  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
99  * it), and not Whitelisteds themselves.
100  */
101 contract WhitelistedRole is WhitelistAdminRole {
102     using Roles for Roles.Role;
103 
104     event WhitelistedAdded(address indexed account);
105     event WhitelistedRemoved(address indexed account);
106 
107     Roles.Role private _whitelisteds;
108 
109     modifier onlyWhitelisted() {
110         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
111         _;
112     }
113 
114     function isWhitelisted(address account) public view returns (bool) {
115         return _whitelisteds.has(account);
116     }
117 
118     function addWhitelisted(address account) public onlyWhitelistAdmin {
119         _addWhitelisted(account);
120     }
121 
122     function removeWhitelisted(address account) public onlyWhitelistAdmin {
123         _removeWhitelisted(account);
124     }
125 
126     function renounceWhitelisted() public {
127         _removeWhitelisted(msg.sender);
128     }
129 
130     function _addWhitelisted(address account) internal {
131         _whitelisteds.add(account);
132         emit WhitelistedAdded(account);
133     }
134 
135     function _removeWhitelisted(address account) internal {
136         _whitelisteds.remove(account);
137         emit WhitelistedRemoved(account);
138     }
139 }
140 
141 // File: contracts/util/BulkWhitelistedRole.sol
142 
143 pragma solidity 0.5.12;
144 
145 
146 
147 /**
148  * @title BulkWhitelistedRole
149  * @dev a Whitelist role defined using the Open Zeppelin Role system with the addition of bulkAddWhitelisted and
150  * bulkRemoveWhitelisted.
151  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
152  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
153  * it), and not Whitelisteds themselves.
154  */
155 contract BulkWhitelistedRole is WhitelistedRole {
156 
157     function bulkAddWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
158         for (uint256 index = 0; index < accounts.length; index++) {
159             _addWhitelisted(accounts[index]);
160         }
161     }
162 
163     function bulkRemoveWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
164         for (uint256 index = 0; index < accounts.length; index++) {
165             _removeWhitelisted(accounts[index]);
166         }
167     }
168 
169 }
170 
171 // File: contracts/controllers/IMintingController.sol
172 
173 pragma solidity 0.5.12;
174 
175 interface IMintingController {
176 
177     /**
178      * @dev Minter function that mints a Second Level Domain (SLD).
179      * @param to address to mint the new SLD to.
180      * @param label SLD label to mint.
181      */
182     function mintSLD(address to, string calldata label) external;
183 
184     /**
185      * @dev Minter function that safely mints a Second Level Domain (SLD).
186      * Implements a ERC721Reciever check unlike mintSLD.
187      * @param to address to mint the new SLD to.
188      * @param label SLD label to mint.
189      */
190     function safeMintSLD(address to, string calldata label) external;
191 
192     /**
193      * @dev Minter function that safely mints a Second Level Domain (SLD).
194      * Implements a ERC721Reciever check unlike mintSLD.
195      * @param to address to mint the new SLD to.
196      * @param label SLD label to mint.
197      * @param _data bytes data to send along with a safe transfer check
198      */
199     function safeMintSLD(address to, string calldata label, bytes calldata _data) external;
200 
201 }
202 
203 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
204 
205 pragma solidity ^0.5.0;
206 
207 
208 contract MinterRole {
209     using Roles for Roles.Role;
210 
211     event MinterAdded(address indexed account);
212     event MinterRemoved(address indexed account);
213 
214     Roles.Role private _minters;
215 
216     constructor () internal {
217         _addMinter(msg.sender);
218     }
219 
220     modifier onlyMinter() {
221         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
222         _;
223     }
224 
225     function isMinter(address account) public view returns (bool) {
226         return _minters.has(account);
227     }
228 
229     function addMinter(address account) public onlyMinter {
230         _addMinter(account);
231     }
232 
233     function renounceMinter() public {
234         _removeMinter(msg.sender);
235     }
236 
237     function _addMinter(address account) internal {
238         _minters.add(account);
239         emit MinterAdded(account);
240     }
241 
242     function _removeMinter(address account) internal {
243         _minters.remove(account);
244         emit MinterRemoved(account);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/introspection/IERC165.sol
249 
250 pragma solidity ^0.5.0;
251 
252 /**
253  * @dev Interface of the ERC165 standard, as defined in the
254  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
255  *
256  * Implementers can declare support of contract interfaces, which can then be
257  * queried by others (`ERC165Checker`).
258  *
259  * For an implementation, see `ERC165`.
260  */
261 interface IERC165 {
262     /**
263      * @dev Returns true if this contract implements the interface defined by
264      * `interfaceId`. See the corresponding
265      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
266      * to learn more about how these ids are created.
267      *
268      * This function call must use less than 30 000 gas.
269      */
270     function supportsInterface(bytes4 interfaceId) external view returns (bool);
271 }
272 
273 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
274 
275 pragma solidity ^0.5.0;
276 
277 
278 /**
279  * @dev Required interface of an ERC721 compliant contract.
280  */
281 contract IERC721 is IERC165 {
282     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
283     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
284     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
285 
286     /**
287      * @dev Returns the number of NFTs in `owner`'s account.
288      */
289     function balanceOf(address owner) public view returns (uint256 balance);
290 
291     /**
292      * @dev Returns the owner of the NFT specified by `tokenId`.
293      */
294     function ownerOf(uint256 tokenId) public view returns (address owner);
295 
296     /**
297      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
298      * another (`to`).
299      *
300      * 
301      *
302      * Requirements:
303      * - `from`, `to` cannot be zero.
304      * - `tokenId` must be owned by `from`.
305      * - If the caller is not `from`, it must be have been allowed to move this
306      * NFT by either `approve` or `setApproveForAll`.
307      */
308     function safeTransferFrom(address from, address to, uint256 tokenId) public;
309     /**
310      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
311      * another (`to`).
312      *
313      * Requirements:
314      * - If the caller is not `from`, it must be approved to move this NFT by
315      * either `approve` or `setApproveForAll`.
316      */
317     function transferFrom(address from, address to, uint256 tokenId) public;
318     function approve(address to, uint256 tokenId) public;
319     function getApproved(uint256 tokenId) public view returns (address operator);
320 
321     function setApprovalForAll(address operator, bool _approved) public;
322     function isApprovedForAll(address owner, address operator) public view returns (bool);
323 
324 
325     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
329 
330 pragma solidity ^0.5.0;
331 
332 
333 /**
334  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
335  * @dev See https://eips.ethereum.org/EIPS/eip-721
336  */
337 contract IERC721Metadata is IERC721 {
338     function name() external view returns (string memory);
339     function symbol() external view returns (string memory);
340     function tokenURI(uint256 tokenId) external view returns (string memory);
341 }
342 
343 // File: contracts/IRegistry.sol
344 
345 pragma solidity 0.5.12;
346 
347 
348 contract IRegistry is IERC721Metadata {
349 
350     event NewURI(uint256 indexed tokenId, string uri);
351 
352     event NewURIPrefix(string prefix);
353 
354     event Resolve(uint256 indexed tokenId, address indexed to);
355 
356     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
357 
358     /**
359      * @dev Controlled function to set the token URI Prefix for all tokens.
360      * @param prefix string URI to assign
361      */
362     function controlledSetTokenURIPrefix(string calldata prefix) external;
363 
364     /**
365      * @dev Returns whether the given spender can transfer a given token ID.
366      * @param spender address of the spender to query
367      * @param tokenId uint256 ID of the token to be transferred
368      * @return bool whether the msg.sender is approved for the given token ID,
369      * is an operator of the owner, or is the owner of the token
370      */
371     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
372 
373     /**
374      * @dev Mints a new a child token.
375      * Calculates child token ID using a namehash function.
376      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
377      * Requires the token not exist.
378      * @param to address to receive the ownership of the given token ID
379      * @param tokenId uint256 ID of the parent token
380      * @param label subdomain label of the child token ID
381      */
382     function mintChild(address to, uint256 tokenId, string calldata label) external;
383 
384     /**
385      * @dev Controlled function to mint a given token ID.
386      * Requires the msg.sender to be controller.
387      * Requires the token ID to not exist.
388      * @param to address the given token ID will be minted to
389      * @param label string that is a subdomain
390      * @param tokenId uint256 ID of the parent token
391      */
392     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
393 
394     /**
395      * @dev Transfers the ownership of a child token ID to another address.
396      * Calculates child token ID using a namehash function.
397      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
398      * Requires the token already exist.
399      * @param from current owner of the token
400      * @param to address to receive the ownership of the given token ID
401      * @param tokenId uint256 ID of the token to be transferred
402      * @param label subdomain label of the child token ID
403      */
404     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
405 
406     /**
407      * @dev Controlled function to transfers the ownership of a token ID to
408      * another address.
409      * Requires the msg.sender to be controller.
410      * Requires the token already exist.
411      * @param from current owner of the token
412      * @param to address to receive the ownership of the given token ID
413      * @param tokenId uint256 ID of the token to be transferred
414      */
415     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
416 
417     /**
418      * @dev Safely transfers the ownership of a child token ID to another address.
419      * Calculates child token ID using a namehash function.
420      * Implements a ERC721Reciever check unlike transferFromChild.
421      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
422      * Requires the token already exist.
423      * @param from current owner of the token
424      * @param to address to receive the ownership of the given token ID
425      * @param tokenId uint256 parent ID of the token to be transferred
426      * @param label subdomain label of the child token ID
427      * @param _data bytes data to send along with a safe transfer check
428      */
429     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
430 
431     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
432     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
433 
434     /**
435      * @dev Controlled frunction to safely transfers the ownership of a token ID
436      * to another address.
437      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
438      * Requires the msg.sender to be controller.
439      * Requires the token already exist.
440      * @param from current owner of the token
441      * @param to address to receive the ownership of the given token ID
442      * @param tokenId uint256 parent ID of the token to be transferred
443      * @param _data bytes data to send along with a safe transfer check
444      */
445     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
446 
447     /**
448      * @dev Burns a child token ID.
449      * Calculates child token ID using a namehash function.
450      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
451      * Requires the token already exist.
452      * @param tokenId uint256 ID of the token to be transferred
453      * @param label subdomain label of the child token ID
454      */
455     function burnChild(uint256 tokenId, string calldata label) external;
456 
457     /**
458      * @dev Controlled function to burn a given token ID.
459      * Requires the msg.sender to be controller.
460      * Requires the token already exist.
461      * @param tokenId uint256 ID of the token to be burned
462      */
463     function controlledBurn(uint256 tokenId) external;
464 
465     /**
466      * @dev Sets the resolver of a given token ID to another address.
467      * Requires the msg.sender to be the owner, approved, or operator.
468      * @param to address the given token ID will resolve to
469      * @param tokenId uint256 ID of the token to be transferred
470      */
471     function resolveTo(address to, uint256 tokenId) external;
472 
473     /**
474      * @dev Gets the resolver of the specified token ID.
475      * @param tokenId uint256 ID of the token to query the resolver of
476      * @return address currently marked as the resolver of the given token ID
477      */
478     function resolverOf(uint256 tokenId) external view returns (address);
479 
480     /**
481      * @dev Controlled function to sets the resolver of a given token ID.
482      * Requires the msg.sender to be controller.
483      * @param to address the given token ID will resolve to
484      * @param tokenId uint256 ID of the token to be transferred
485      */
486     function controlledResolveTo(address to, uint256 tokenId) external;
487 
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
491 
492 pragma solidity ^0.5.0;
493 
494 /**
495  * @title ERC721 token receiver interface
496  * @dev Interface for any contract that wants to support safeTransfers
497  * from ERC721 asset contracts.
498  */
499 contract IERC721Receiver {
500     /**
501      * @notice Handle the receipt of an NFT
502      * @dev The ERC721 smart contract calls this function on the recipient
503      * after a `safeTransfer`. This function MUST return the function selector,
504      * otherwise the caller will revert the transaction. The selector to be
505      * returned can be obtained as `this.onERC721Received.selector`. This
506      * function MAY throw to revert and reject the transfer.
507      * Note: the ERC721 contract address is always the message sender.
508      * @param operator The address which called `safeTransferFrom` function
509      * @param from The address which previously owned the token
510      * @param tokenId The NFT identifier which is being transferred
511      * @param data Additional data with no specified format
512      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
513      */
514     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
515     public returns (bytes4);
516 }
517 
518 // File: @openzeppelin/contracts/math/SafeMath.sol
519 
520 pragma solidity ^0.5.0;
521 
522 /**
523  * @dev Wrappers over Solidity's arithmetic operations with added overflow
524  * checks.
525  *
526  * Arithmetic operations in Solidity wrap on overflow. This can easily result
527  * in bugs, because programmers usually assume that an overflow raises an
528  * error, which is the standard behavior in high level programming languages.
529  * `SafeMath` restores this intuition by reverting the transaction when an
530  * operation overflows.
531  *
532  * Using this library instead of the unchecked operations eliminates an entire
533  * class of bugs, so it's recommended to use it always.
534  */
535 library SafeMath {
536     /**
537      * @dev Returns the addition of two unsigned integers, reverting on
538      * overflow.
539      *
540      * Counterpart to Solidity's `+` operator.
541      *
542      * Requirements:
543      * - Addition cannot overflow.
544      */
545     function add(uint256 a, uint256 b) internal pure returns (uint256) {
546         uint256 c = a + b;
547         require(c >= a, "SafeMath: addition overflow");
548 
549         return c;
550     }
551 
552     /**
553      * @dev Returns the subtraction of two unsigned integers, reverting on
554      * overflow (when the result is negative).
555      *
556      * Counterpart to Solidity's `-` operator.
557      *
558      * Requirements:
559      * - Subtraction cannot overflow.
560      */
561     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
562         require(b <= a, "SafeMath: subtraction overflow");
563         uint256 c = a - b;
564 
565         return c;
566     }
567 
568     /**
569      * @dev Returns the multiplication of two unsigned integers, reverting on
570      * overflow.
571      *
572      * Counterpart to Solidity's `*` operator.
573      *
574      * Requirements:
575      * - Multiplication cannot overflow.
576      */
577     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
578         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
579         // benefit is lost if 'b' is also tested.
580         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
581         if (a == 0) {
582             return 0;
583         }
584 
585         uint256 c = a * b;
586         require(c / a == b, "SafeMath: multiplication overflow");
587 
588         return c;
589     }
590 
591     /**
592      * @dev Returns the integer division of two unsigned integers. Reverts on
593      * division by zero. The result is rounded towards zero.
594      *
595      * Counterpart to Solidity's `/` operator. Note: this function uses a
596      * `revert` opcode (which leaves remaining gas untouched) while Solidity
597      * uses an invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      * - The divisor cannot be zero.
601      */
602     function div(uint256 a, uint256 b) internal pure returns (uint256) {
603         // Solidity only automatically asserts when dividing by 0
604         require(b > 0, "SafeMath: division by zero");
605         uint256 c = a / b;
606         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
607 
608         return c;
609     }
610 
611     /**
612      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
613      * Reverts when dividing by zero.
614      *
615      * Counterpart to Solidity's `%` operator. This function uses a `revert`
616      * opcode (which leaves remaining gas untouched) while Solidity uses an
617      * invalid opcode to revert (consuming all remaining gas).
618      *
619      * Requirements:
620      * - The divisor cannot be zero.
621      */
622     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
623         require(b != 0, "SafeMath: modulo by zero");
624         return a % b;
625     }
626 }
627 
628 // File: @openzeppelin/contracts/utils/Address.sol
629 
630 pragma solidity ^0.5.0;
631 
632 /**
633  * @dev Collection of functions related to the address type,
634  */
635 library Address {
636     /**
637      * @dev Returns true if `account` is a contract.
638      *
639      * This test is non-exhaustive, and there may be false-negatives: during the
640      * execution of a contract's constructor, its address will be reported as
641      * not containing a contract.
642      *
643      * > It is unsafe to assume that an address for which this function returns
644      * false is an externally-owned account (EOA) and not a contract.
645      */
646     function isContract(address account) internal view returns (bool) {
647         // This method relies in extcodesize, which returns 0 for contracts in
648         // construction, since the code is only stored at the end of the
649         // constructor execution.
650 
651         uint256 size;
652         // solhint-disable-next-line no-inline-assembly
653         assembly { size := extcodesize(account) }
654         return size > 0;
655     }
656 }
657 
658 // File: @openzeppelin/contracts/drafts/Counters.sol
659 
660 pragma solidity ^0.5.0;
661 
662 
663 /**
664  * @title Counters
665  * @author Matt Condon (@shrugs)
666  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
667  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
668  *
669  * Include with `using Counters for Counters.Counter;`
670  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
671  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
672  * directly accessed.
673  */
674 library Counters {
675     using SafeMath for uint256;
676 
677     struct Counter {
678         // This variable should never be directly accessed by users of the library: interactions must be restricted to
679         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
680         // this feature: see https://github.com/ethereum/solidity/issues/4637
681         uint256 _value; // default: 0
682     }
683 
684     function current(Counter storage counter) internal view returns (uint256) {
685         return counter._value;
686     }
687 
688     function increment(Counter storage counter) internal {
689         counter._value += 1;
690     }
691 
692     function decrement(Counter storage counter) internal {
693         counter._value = counter._value.sub(1);
694     }
695 }
696 
697 // File: @openzeppelin/contracts/introspection/ERC165.sol
698 
699 pragma solidity ^0.5.0;
700 
701 
702 /**
703  * @dev Implementation of the `IERC165` interface.
704  *
705  * Contracts may inherit from this and call `_registerInterface` to declare
706  * their support of an interface.
707  */
708 contract ERC165 is IERC165 {
709     /*
710      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
711      */
712     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
713 
714     /**
715      * @dev Mapping of interface ids to whether or not it's supported.
716      */
717     mapping(bytes4 => bool) private _supportedInterfaces;
718 
719     constructor () internal {
720         // Derived contracts need only register support for their own interfaces,
721         // we register support for ERC165 itself here
722         _registerInterface(_INTERFACE_ID_ERC165);
723     }
724 
725     /**
726      * @dev See `IERC165.supportsInterface`.
727      *
728      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
729      */
730     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
731         return _supportedInterfaces[interfaceId];
732     }
733 
734     /**
735      * @dev Registers the contract as an implementer of the interface defined by
736      * `interfaceId`. Support of the actual ERC165 interface is automatic and
737      * registering its interface id is not required.
738      *
739      * See `IERC165.supportsInterface`.
740      *
741      * Requirements:
742      *
743      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
744      */
745     function _registerInterface(bytes4 interfaceId) internal {
746         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
747         _supportedInterfaces[interfaceId] = true;
748     }
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
752 
753 pragma solidity ^0.5.0;
754 
755 
756 
757 
758 
759 
760 
761 /**
762  * @title ERC721 Non-Fungible Token Standard basic implementation
763  * @dev see https://eips.ethereum.org/EIPS/eip-721
764  */
765 contract ERC721 is ERC165, IERC721 {
766     using SafeMath for uint256;
767     using Address for address;
768     using Counters for Counters.Counter;
769 
770     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
771     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
772     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
773 
774     // Mapping from token ID to owner
775     mapping (uint256 => address) private _tokenOwner;
776 
777     // Mapping from token ID to approved address
778     mapping (uint256 => address) private _tokenApprovals;
779 
780     // Mapping from owner to number of owned token
781     mapping (address => Counters.Counter) private _ownedTokensCount;
782 
783     // Mapping from owner to operator approvals
784     mapping (address => mapping (address => bool)) private _operatorApprovals;
785 
786     /*
787      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
788      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
789      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
790      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
791      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
792      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
793      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
794      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
795      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
796      *
797      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
798      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
799      */
800     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
801 
802     constructor () public {
803         // register the supported interfaces to conform to ERC721 via ERC165
804         _registerInterface(_INTERFACE_ID_ERC721);
805     }
806 
807     /**
808      * @dev Gets the balance of the specified address.
809      * @param owner address to query the balance of
810      * @return uint256 representing the amount owned by the passed address
811      */
812     function balanceOf(address owner) public view returns (uint256) {
813         require(owner != address(0), "ERC721: balance query for the zero address");
814 
815         return _ownedTokensCount[owner].current();
816     }
817 
818     /**
819      * @dev Gets the owner of the specified token ID.
820      * @param tokenId uint256 ID of the token to query the owner of
821      * @return address currently marked as the owner of the given token ID
822      */
823     function ownerOf(uint256 tokenId) public view returns (address) {
824         address owner = _tokenOwner[tokenId];
825         require(owner != address(0), "ERC721: owner query for nonexistent token");
826 
827         return owner;
828     }
829 
830     /**
831      * @dev Approves another address to transfer the given token ID
832      * The zero address indicates there is no approved address.
833      * There can only be one approved address per token at a given time.
834      * Can only be called by the token owner or an approved operator.
835      * @param to address to be approved for the given token ID
836      * @param tokenId uint256 ID of the token to be approved
837      */
838     function approve(address to, uint256 tokenId) public {
839         address owner = ownerOf(tokenId);
840         require(to != owner, "ERC721: approval to current owner");
841 
842         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
843             "ERC721: approve caller is not owner nor approved for all"
844         );
845 
846         _tokenApprovals[tokenId] = to;
847         emit Approval(owner, to, tokenId);
848     }
849 
850     /**
851      * @dev Gets the approved address for a token ID, or zero if no address set
852      * Reverts if the token ID does not exist.
853      * @param tokenId uint256 ID of the token to query the approval of
854      * @return address currently approved for the given token ID
855      */
856     function getApproved(uint256 tokenId) public view returns (address) {
857         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev Sets or unsets the approval of a given operator
864      * An operator is allowed to transfer all tokens of the sender on their behalf.
865      * @param to operator address to set the approval
866      * @param approved representing the status of the approval to be set
867      */
868     function setApprovalForAll(address to, bool approved) public {
869         require(to != msg.sender, "ERC721: approve to caller");
870 
871         _operatorApprovals[msg.sender][to] = approved;
872         emit ApprovalForAll(msg.sender, to, approved);
873     }
874 
875     /**
876      * @dev Tells whether an operator is approved by a given owner.
877      * @param owner owner address which you want to query the approval of
878      * @param operator operator address which you want to query the approval of
879      * @return bool whether the given operator is approved by the given owner
880      */
881     function isApprovedForAll(address owner, address operator) public view returns (bool) {
882         return _operatorApprovals[owner][operator];
883     }
884 
885     /**
886      * @dev Transfers the ownership of a given token ID to another address.
887      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
888      * Requires the msg.sender to be the owner, approved, or operator.
889      * @param from current owner of the token
890      * @param to address to receive the ownership of the given token ID
891      * @param tokenId uint256 ID of the token to be transferred
892      */
893     function transferFrom(address from, address to, uint256 tokenId) public {
894         //solhint-disable-next-line max-line-length
895         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
896 
897         _transferFrom(from, to, tokenId);
898     }
899 
900     /**
901      * @dev Safely transfers the ownership of a given token ID to another address
902      * If the target address is a contract, it must implement `onERC721Received`,
903      * which is called upon a safe transfer, and return the magic value
904      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
905      * the transfer is reverted.
906      * Requires the msg.sender to be the owner, approved, or operator
907      * @param from current owner of the token
908      * @param to address to receive the ownership of the given token ID
909      * @param tokenId uint256 ID of the token to be transferred
910      */
911     function safeTransferFrom(address from, address to, uint256 tokenId) public {
912         safeTransferFrom(from, to, tokenId, "");
913     }
914 
915     /**
916      * @dev Safely transfers the ownership of a given token ID to another address
917      * If the target address is a contract, it must implement `onERC721Received`,
918      * which is called upon a safe transfer, and return the magic value
919      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
920      * the transfer is reverted.
921      * Requires the msg.sender to be the owner, approved, or operator
922      * @param from current owner of the token
923      * @param to address to receive the ownership of the given token ID
924      * @param tokenId uint256 ID of the token to be transferred
925      * @param _data bytes data to send along with a safe transfer check
926      */
927     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
928         transferFrom(from, to, tokenId);
929         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
930     }
931 
932     /**
933      * @dev Returns whether the specified token exists.
934      * @param tokenId uint256 ID of the token to query the existence of
935      * @return bool whether the token exists
936      */
937     function _exists(uint256 tokenId) internal view returns (bool) {
938         address owner = _tokenOwner[tokenId];
939         return owner != address(0);
940     }
941 
942     /**
943      * @dev Returns whether the given spender can transfer a given token ID.
944      * @param spender address of the spender to query
945      * @param tokenId uint256 ID of the token to be transferred
946      * @return bool whether the msg.sender is approved for the given token ID,
947      * is an operator of the owner, or is the owner of the token
948      */
949     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
950         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
951         address owner = ownerOf(tokenId);
952         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
953     }
954 
955     /**
956      * @dev Internal function to mint a new token.
957      * Reverts if the given token ID already exists.
958      * @param to The address that will own the minted token
959      * @param tokenId uint256 ID of the token to be minted
960      */
961     function _mint(address to, uint256 tokenId) internal {
962         require(to != address(0), "ERC721: mint to the zero address");
963         require(!_exists(tokenId), "ERC721: token already minted");
964 
965         _tokenOwner[tokenId] = to;
966         _ownedTokensCount[to].increment();
967 
968         emit Transfer(address(0), to, tokenId);
969     }
970 
971     /**
972      * @dev Internal function to burn a specific token.
973      * Reverts if the token does not exist.
974      * Deprecated, use _burn(uint256) instead.
975      * @param owner owner of the token to burn
976      * @param tokenId uint256 ID of the token being burned
977      */
978     function _burn(address owner, uint256 tokenId) internal {
979         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
980 
981         _clearApproval(tokenId);
982 
983         _ownedTokensCount[owner].decrement();
984         _tokenOwner[tokenId] = address(0);
985 
986         emit Transfer(owner, address(0), tokenId);
987     }
988 
989     /**
990      * @dev Internal function to burn a specific token.
991      * Reverts if the token does not exist.
992      * @param tokenId uint256 ID of the token being burned
993      */
994     function _burn(uint256 tokenId) internal {
995         _burn(ownerOf(tokenId), tokenId);
996     }
997 
998     /**
999      * @dev Internal function to transfer ownership of a given token ID to another address.
1000      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1001      * @param from current owner of the token
1002      * @param to address to receive the ownership of the given token ID
1003      * @param tokenId uint256 ID of the token to be transferred
1004      */
1005     function _transferFrom(address from, address to, uint256 tokenId) internal {
1006         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1007         require(to != address(0), "ERC721: transfer to the zero address");
1008 
1009         _clearApproval(tokenId);
1010 
1011         _ownedTokensCount[from].decrement();
1012         _ownedTokensCount[to].increment();
1013 
1014         _tokenOwner[tokenId] = to;
1015 
1016         emit Transfer(from, to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev Internal function to invoke `onERC721Received` on a target address.
1021      * The call is not executed if the target address is not a contract.
1022      *
1023      * This function is deprecated.
1024      * @param from address representing the previous owner of the given token ID
1025      * @param to target address that will receive the tokens
1026      * @param tokenId uint256 ID of the token to be transferred
1027      * @param _data bytes optional data to send along with the call
1028      * @return bool whether the call correctly returned the expected magic value
1029      */
1030     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1031         internal returns (bool)
1032     {
1033         if (!to.isContract()) {
1034             return true;
1035         }
1036 
1037         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1038         return (retval == _ERC721_RECEIVED);
1039     }
1040 
1041     /**
1042      * @dev Private function to clear current approval of a given token ID.
1043      * @param tokenId uint256 ID of the token to be transferred
1044      */
1045     function _clearApproval(uint256 tokenId) private {
1046         if (_tokenApprovals[tokenId] != address(0)) {
1047             _tokenApprovals[tokenId] = address(0);
1048         }
1049     }
1050 }
1051 
1052 // File: @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol
1053 
1054 pragma solidity ^0.5.0;
1055 
1056 
1057 /**
1058  * @title ERC721 Burnable Token
1059  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1060  */
1061 contract ERC721Burnable is ERC721 {
1062     /**
1063      * @dev Burns a specific ERC721 token.
1064      * @param tokenId uint256 id of the ERC721 token to be burned.
1065      */
1066     function burn(uint256 tokenId) public {
1067         //solhint-disable-next-line max-line-length
1068         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
1069         _burn(tokenId);
1070     }
1071 }
1072 
1073 // File: contracts/util/ControllerRole.sol
1074 
1075 pragma solidity 0.5.12;
1076 
1077 
1078 // solium-disable error-reason
1079 
1080 /**
1081  * @title ControllerRole
1082  * @dev An Controller role defined using the Open Zeppelin Role system.
1083  */
1084 contract ControllerRole {
1085 
1086     using Roles for Roles.Role;
1087 
1088     // NOTE: Commented out standard Role events to save gas.
1089     // event ControllerAdded(address indexed account);
1090     // event ControllerRemoved(address indexed account);
1091 
1092     Roles.Role private _controllers;
1093 
1094     constructor () public {
1095         _addController(msg.sender);
1096     }
1097 
1098     modifier onlyController() {
1099         require(isController(msg.sender));
1100         _;
1101     }
1102 
1103     function isController(address account) public view returns (bool) {
1104         return _controllers.has(account);
1105     }
1106 
1107     function addController(address account) public onlyController {
1108         _addController(account);
1109     }
1110 
1111     function renounceController() public {
1112         _removeController(msg.sender);
1113     }
1114 
1115     function _addController(address account) internal {
1116         _controllers.add(account);
1117         // emit ControllerAdded(account);
1118     }
1119 
1120     function _removeController(address account) internal {
1121         _controllers.remove(account);
1122         // emit ControllerRemoved(account);
1123     }
1124 
1125 }
1126 
1127 // File: contracts/Registry.sol
1128 
1129 pragma solidity 0.5.12;
1130 
1131 
1132 
1133 
1134 // solium-disable no-empty-blocks,error-reason
1135 
1136 /**
1137  * @title Registry
1138  * @dev An ERC721 Token see https://eips.ethereum.org/EIPS/eip-721. With
1139  * additional functions so other trusted contracts to interact with the tokens.
1140  */
1141 contract Registry is IRegistry, ControllerRole, ERC721Burnable {
1142 
1143     // Optional mapping for token URIs
1144     mapping(uint256 => string) internal _tokenURIs;
1145 
1146     string internal _prefix;
1147 
1148     // Mapping from token ID to resolver address
1149     mapping (uint256 => address) internal _tokenResolvers;
1150 
1151     // uint256(keccak256(abi.encodePacked(uint256(0x0), keccak256(abi.encodePacked("crypto")))))
1152     uint256 private constant _CRYPTO_HASH =
1153         0x0f4a10a4f46c288cea365fcf45cccf0e9d901b945b9829ccdb54c10dc3cb7a6f;
1154 
1155     modifier onlyApprovedOrOwner(uint256 tokenId) {
1156         require(_isApprovedOrOwner(msg.sender, tokenId));
1157         _;
1158     }
1159 
1160     constructor () public {
1161         _mint(address(0xdead), _CRYPTO_HASH);
1162         // register the supported interfaces to conform to ERC721 via ERC165
1163         _registerInterface(0x5b5e139f); // ERC721 Metadata Interface
1164         _tokenURIs[root()] = "crypto";
1165         emit NewURI(root(), "crypto");
1166     }
1167 
1168     /// ERC721 Metadata extension
1169 
1170     function name() external view returns (string memory) {
1171         return ".crypto";
1172     }
1173 
1174     function symbol() external view returns (string memory) {
1175         return "UD";
1176     }
1177 
1178     function tokenURI(uint256 tokenId) external view returns (string memory) {
1179         require(_exists(tokenId));
1180         return string(abi.encodePacked(_prefix, _tokenURIs[tokenId]));
1181     }
1182 
1183     function controlledSetTokenURIPrefix(string calldata prefix) external onlyController {
1184         _prefix = prefix;
1185         emit NewURIPrefix(prefix);
1186     }
1187 
1188     /// Ownership
1189 
1190     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
1191         return _isApprovedOrOwner(spender, tokenId);
1192     }
1193 
1194     /// Registry Constants
1195 
1196     function root() public pure returns (uint256) {
1197         return _CRYPTO_HASH;
1198     }
1199 
1200     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256) {
1201         return _childId(tokenId, label);
1202     }
1203 
1204     /// Minting
1205 
1206     function mintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1207         _mintChild(to, tokenId, label);
1208     }
1209 
1210     function controlledMintChild(address to, uint256 tokenId, string calldata label) external onlyController {
1211         _mintChild(to, tokenId, label);
1212     }
1213 
1214     function safeMintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1215         _safeMintChild(to, tokenId, label, "");
1216     }
1217 
1218     function safeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1219         external
1220         onlyApprovedOrOwner(tokenId)
1221     {
1222         _safeMintChild(to, tokenId, label, _data);
1223     }
1224 
1225     function controlledSafeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1226         external
1227         onlyController
1228     {
1229         _safeMintChild(to, tokenId, label, _data);
1230     }
1231 
1232     /// Transfering
1233 
1234     function setOwner(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId)  {
1235         super._transferFrom(ownerOf(tokenId), to, tokenId);
1236     }
1237 
1238     function transferFromChild(address from, address to, uint256 tokenId, string calldata label)
1239         external
1240         onlyApprovedOrOwner(tokenId)
1241     {
1242         _transferFrom(from, to, _childId(tokenId, label));
1243     }
1244 
1245     function controlledTransferFrom(address from, address to, uint256 tokenId) external onlyController {
1246         _transferFrom(from, to, tokenId);
1247     }
1248 
1249     function safeTransferFromChild(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         string memory label,
1254         bytes memory _data
1255     ) public onlyApprovedOrOwner(tokenId) {
1256         uint256 childId = _childId(tokenId, label);
1257         _transferFrom(from, to, childId);
1258         require(_checkOnERC721Received(from, to, childId, _data));
1259     }
1260 
1261     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external {
1262         safeTransferFromChild(from, to, tokenId, label, "");
1263     }
1264 
1265     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data)
1266         external
1267         onlyController
1268     {
1269         _transferFrom(from, to, tokenId);
1270         require(_checkOnERC721Received(from, to, tokenId, _data));
1271     }
1272 
1273     /// Burning
1274 
1275     function burnChild(uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1276         _burn(_childId(tokenId, label));
1277     }
1278 
1279     function controlledBurn(uint256 tokenId) external onlyController {
1280         _burn(tokenId);
1281     }
1282 
1283     /// Resolution
1284 
1285     function resolverOf(uint256 tokenId) external view returns (address) {
1286         address resolver = _tokenResolvers[tokenId];
1287         require(resolver != address(0));
1288         return resolver;
1289     }
1290 
1291     function resolveTo(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
1292         _resolveTo(to, tokenId);
1293     }
1294 
1295     function controlledResolveTo(address to, uint256 tokenId) external onlyController {
1296         _resolveTo(to, tokenId);
1297     }
1298 
1299     function sync(uint256 tokenId, uint256 updateId) external {
1300         require(_tokenResolvers[tokenId] == msg.sender);
1301         emit Sync(msg.sender, updateId, tokenId);
1302     }
1303 
1304     /// Internal
1305 
1306     function _childId(uint256 tokenId, string memory label) internal pure returns (uint256) {
1307         require(bytes(label).length != 0);
1308         return uint256(keccak256(abi.encodePacked(tokenId, keccak256(abi.encodePacked(label)))));
1309     }
1310 
1311     function _mintChild(address to, uint256 tokenId, string memory label) internal {
1312         uint256 childId = _childId(tokenId, label);
1313         _mint(to, childId);
1314 
1315         require(bytes(label).length != 0);
1316         require(_exists(childId));
1317 
1318         bytes memory domain = abi.encodePacked(label, ".", _tokenURIs[tokenId]);
1319 
1320         _tokenURIs[childId] = string(domain);
1321         emit NewURI(childId, string(domain));
1322     }
1323 
1324     function _safeMintChild(address to, uint256 tokenId, string memory label, bytes memory _data) internal {
1325         _mintChild(to, tokenId, label);
1326         require(_checkOnERC721Received(address(0), to, _childId(tokenId, label), _data));
1327     }
1328 
1329     function _transferFrom(address from, address to, uint256 tokenId) internal {
1330         super._transferFrom(from, to, tokenId);
1331         // Clear resolver (if any)
1332         if (_tokenResolvers[tokenId] != address(0x0)) {
1333             delete _tokenResolvers[tokenId];
1334         }
1335     }
1336 
1337     function _burn(uint256 tokenId) internal {
1338         super._burn(tokenId);
1339         // Clear resolver (if any)
1340         if (_tokenResolvers[tokenId] != address(0x0)) {
1341             delete _tokenResolvers[tokenId];
1342         }
1343         // Clear metadata (if any)
1344         if (bytes(_tokenURIs[tokenId]).length != 0) {
1345             delete _tokenURIs[tokenId];
1346         }
1347     }
1348 
1349     function _resolveTo(address to, uint256 tokenId) internal {
1350         require(_exists(tokenId));
1351         emit Resolve(tokenId, to);
1352         _tokenResolvers[tokenId] = to;
1353     }
1354 
1355 }
1356 
1357 // File: contracts/controllers/MintingController.sol
1358 
1359 pragma solidity 0.5.12;
1360 
1361 
1362 
1363 
1364 /**
1365  * @title MintingController
1366  * @dev Defines the functions for distribution of Second Level Domains (SLD)s.
1367  */
1368 contract MintingController is IMintingController, MinterRole {
1369 
1370     Registry internal _registry;
1371 
1372     constructor (Registry registry) public {
1373         _registry = registry;
1374     }
1375 
1376     function registry() external view returns (address) {
1377         return address(_registry);
1378     }
1379 
1380     function mintSLD(address to, string memory label) public onlyMinter {
1381         _registry.controlledMintChild(to, _registry.root(), label);
1382     }
1383 
1384     function safeMintSLD(address to, string calldata label) external {
1385         safeMintSLD(to, label, "");
1386     }
1387 
1388     function safeMintSLD(address to, string memory label, bytes memory _data) public onlyMinter {
1389         _registry.controlledSafeMintChild(to, _registry.root(), label, _data);
1390     }
1391 
1392     function mintSLDWithResolver(address to, string memory label, address resolver) public onlyMinter {
1393         _registry.controlledMintChild(to, _registry.root(), label);
1394         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1395     }
1396 
1397     function safeMintSLDWithResolver(address to, string calldata label, address resolver) external {
1398         safeMintSLD(to, label, "");
1399         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1400     }
1401 
1402     function safeMintSLDWithResolver(address to, string calldata label, address resolver, bytes calldata _data) external {
1403         safeMintSLD(to, label, _data);
1404         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1405     }
1406 
1407 }
1408 
1409 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
1410 
1411 pragma solidity ^0.5.0;
1412 
1413 /**
1414  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1415  *
1416  * These functions can be used to verify that a message was signed by the holder
1417  * of the private keys of a given address.
1418  */
1419 library ECDSA {
1420     /**
1421      * @dev Returns the address that signed a hashed message (`hash`) with
1422      * `signature`. This address can then be used for verification purposes.
1423      *
1424      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1425      * this function rejects them by requiring the `s` value to be in the lower
1426      * half order, and the `v` value to be either 27 or 28.
1427      *
1428      * (.note) This call _does not revert_ if the signature is invalid, or
1429      * if the signer is otherwise unable to be retrieved. In those scenarios,
1430      * the zero address is returned.
1431      *
1432      * (.warning) `hash` _must_ be the result of a hash operation for the
1433      * verification to be secure: it is possible to craft signatures that
1434      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1435      * this is by receiving a hash of the original message (which may otherwise)
1436      * be too long), and then calling `toEthSignedMessageHash` on it.
1437      */
1438     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1439         // Check the signature length
1440         if (signature.length != 65) {
1441             return (address(0));
1442         }
1443 
1444         // Divide the signature in r, s and v variables
1445         bytes32 r;
1446         bytes32 s;
1447         uint8 v;
1448 
1449         // ecrecover takes the signature parameters, and the only way to get them
1450         // currently is to use assembly.
1451         // solhint-disable-next-line no-inline-assembly
1452         assembly {
1453             r := mload(add(signature, 0x20))
1454             s := mload(add(signature, 0x40))
1455             v := byte(0, mload(add(signature, 0x60)))
1456         }
1457 
1458         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1459         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1460         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1461         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1462         //
1463         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1464         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1465         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1466         // these malleable signatures as well.
1467         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1468             return address(0);
1469         }
1470 
1471         if (v != 27 && v != 28) {
1472             return address(0);
1473         }
1474 
1475         // If the signature is valid (and not malleable), return the signer address
1476         return ecrecover(hash, v, r, s);
1477     }
1478 
1479     /**
1480      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1481      * replicates the behavior of the
1482      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
1483      * JSON-RPC method.
1484      *
1485      * See `recover`.
1486      */
1487     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1488         // 32 is the length in bytes of hash,
1489         // enforced by the type signature above
1490         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1491     }
1492 }
1493 
1494 // File: contracts/util/SignatureUtil.sol
1495 
1496 pragma solidity 0.5.12;
1497 
1498 
1499 
1500 // solium-disable error-reason
1501 
1502 contract SignatureUtil {
1503     using ECDSA for bytes32;
1504 
1505     // Mapping from owner to a nonce
1506     mapping (uint256 => uint256) internal _nonces;
1507 
1508     Registry internal _registry;
1509 
1510     constructor(Registry registry) public {
1511         _registry = registry;
1512     }
1513 
1514     function registry() external view returns (address) {
1515         return address(_registry);
1516     }
1517 
1518     /**
1519      * @dev Gets the nonce of the specified address.
1520      * @param tokenId token ID for nonce query
1521      * @return nonce of the given address
1522      */
1523     function nonceOf(uint256 tokenId) external view returns (uint256) {
1524         return _nonces[tokenId];
1525     }
1526 
1527     function _validate(bytes32 hash, uint256 tokenId, bytes memory signature) internal {
1528         uint256 nonce = _nonces[tokenId];
1529 
1530         address signer = keccak256(abi.encodePacked(hash, address(this), nonce)).toEthSignedMessageHash().recover(signature);
1531         require(
1532             signer != address(0) &&
1533             _registry.isApprovedOrOwner(
1534                 signer,
1535                 tokenId
1536             )
1537         );
1538 
1539         _nonces[tokenId] += 1;
1540     }
1541 
1542 }
1543 
1544 // File: contracts/Resolver.sol
1545 
1546 pragma solidity 0.5.12;
1547 
1548 
1549 
1550 // solium-disable error-reason
1551 
1552 contract Resolver is SignatureUtil {
1553 
1554     event Set(uint256 indexed preset, string indexed key, string value, uint256 indexed tokenId);
1555     event SetPreset(uint256 indexed preset, uint256 indexed tokenId);
1556 
1557     // Mapping from token ID to preset id to key to value
1558     mapping (uint256 => mapping (uint256 =>  mapping (string => string))) internal _records;
1559 
1560     // Mapping from token ID to current preset id
1561     mapping (uint256 => uint256) _tokenPresets;
1562 
1563     MintingController internal _mintingController;
1564 
1565     constructor(Registry registry, MintingController mintingController) public SignatureUtil(registry) {
1566         require(address(registry) == mintingController.registry());
1567         _mintingController = mintingController;
1568     }
1569 
1570     /**
1571      * @dev Throws if called when not the resolver.
1572      */
1573     modifier whenResolver(uint256 tokenId) {
1574         require(address(this) == _registry.resolverOf(tokenId), "SimpleResolver: is not the resolver");
1575         _;
1576     }
1577 
1578     function presetOf(uint256 tokenId) external view returns (uint256) {
1579         return _tokenPresets[tokenId];
1580     }
1581 
1582     function setPreset(uint256 presetId, uint256 tokenId) external {
1583         require(_registry.isApprovedOrOwner(msg.sender, tokenId));
1584         _setPreset(presetId, tokenId);
1585     }
1586 
1587     function setPresetFor(uint256 presetId, uint256 tokenId, bytes calldata signature) external {
1588         _validate(keccak256(abi.encodeWithSelector(this.setPreset.selector, presetId, tokenId)), tokenId, signature);
1589         _setPreset(presetId, tokenId);
1590     }
1591 
1592     function reset(uint256 tokenId) external {
1593         require(_registry.isApprovedOrOwner(msg.sender, tokenId));
1594         _setPreset(now, tokenId);
1595     }
1596 
1597     function resetFor(uint256 tokenId, bytes calldata signature) external {
1598         _validate(keccak256(abi.encodeWithSelector(this.reset.selector, tokenId)), tokenId, signature);
1599         _setPreset(now, tokenId);
1600     }
1601 
1602     /**
1603      * @dev Function to get record.
1604      * @param key The key to query the value of.
1605      * @param tokenId The token id to fetch.
1606      * @return The value string.
1607      */
1608     function get(string memory key, uint256 tokenId) public view whenResolver(tokenId) returns (string memory) {
1609         return _records[tokenId][_tokenPresets[tokenId]][key];
1610     }
1611 
1612     function preconfigure(
1613         string[] memory keys,
1614         string[] memory values,
1615         uint256 tokenId
1616     ) public {
1617         require(msg.sender == address(_mintingController));
1618         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1619     }
1620 
1621     /**
1622      * @dev Function to set record.
1623      * @param key The key set the value of.
1624      * @param value The value to set key to.
1625      * @param tokenId The token id to set.
1626      */
1627     function set(string calldata key, string calldata value, uint256 tokenId) external {
1628         require(_registry.isApprovedOrOwner(msg.sender, tokenId));
1629         _set(_tokenPresets[tokenId], key, value, tokenId);
1630     }
1631 
1632     /**
1633      * @dev Function to set record on behalf of an address.
1634      * @param key The key set the value of.
1635      * @param value The value to set key to.
1636      * @param tokenId The token id to set.
1637      * @param signature The signature to verify the transaction with.
1638      */
1639     function setFor(
1640         string calldata key,
1641         string calldata value,
1642         uint256 tokenId,
1643         bytes calldata signature
1644     ) external {
1645         _validate(keccak256(abi.encodeWithSelector(this.set.selector, key, value, tokenId)), tokenId, signature);
1646         _set(_tokenPresets[tokenId], key, value, tokenId);
1647     }
1648 
1649     /**
1650      * @dev Function to get multiple record.
1651      * @param keys The keys to query the value of.
1652      * @param tokenId The token id to fetch.
1653      * @return The values.
1654      */
1655     function getMany(string[] calldata keys, uint256 tokenId) external view whenResolver(tokenId) returns (string[] memory) {
1656         uint256 keyCount = keys.length;
1657         string[] memory values = new string[](keyCount);
1658         uint256 preset = _tokenPresets[tokenId];
1659         for (uint256 i = 0; i < keyCount; i++) {
1660             values[i] = _records[tokenId][preset][keys[i]];
1661         }
1662         return values;
1663     }
1664 
1665     function setMany(
1666         string[] memory keys,
1667         string[] memory values,
1668         uint256 tokenId
1669     ) public {
1670         require(_registry.isApprovedOrOwner(msg.sender, tokenId));
1671         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1672     }
1673 
1674     /**
1675      * @dev Function to set record on behalf of an address.
1676      * @param keys The keys set the values of.
1677      * @param values The values to set keys to.
1678      * @param tokenId The token id to set.
1679      * @param signature The signature to verify the transaction with.
1680      */
1681     function setManyFor(
1682         string[] memory keys,
1683         string[] memory values,
1684         uint256 tokenId,
1685         bytes memory signature
1686     ) public {
1687         _validate(keccak256(abi.encodeWithSelector(this.setMany.selector, keys, values, tokenId)), tokenId, signature);
1688         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1689     }
1690 
1691     function _setPreset(uint256 presetId, uint256 tokenId) internal {
1692         _tokenPresets[tokenId] = presetId;
1693         emit SetPreset(presetId, tokenId);
1694     }
1695 
1696     /**
1697      * @dev Internal function to to set record. As opposed to set, this imposes
1698      * no restrictions on msg.sender.
1699      * @param preset preset to set key/values on
1700      * @param key key of record to be set
1701      * @param value value of record to be set
1702      * @param tokenId uint256 ID of the token
1703      */
1704     function _set(uint256 preset, string memory key, string memory value, uint256 tokenId) internal {
1705         _registry.sync(tokenId, uint256(keccak256(bytes(key))));
1706         _records[tokenId][preset][key] = value;
1707         emit Set(preset, key, value, tokenId);
1708     }
1709 
1710     /**
1711      * @dev Internal function to to set multiple records. As opposed to setMany, this imposes
1712      * no restrictions on msg.sender.
1713      * @param preset preset to set key/values on
1714      * @param keys keys of record to be set
1715      * @param values values of record to be set
1716      * @param tokenId uint256 ID of the token
1717      */
1718     function _setMany(uint256 preset, string[] memory keys, string[] memory values, uint256 tokenId) internal {
1719         uint256 keyCount = keys.length;
1720         for (uint256 i = 0; i < keyCount; i++) {
1721             _set(preset, keys[i], values[i], tokenId);
1722         }
1723     }
1724 
1725 }
1726 
1727 // File: contracts/util/WhitelistedMinter.sol
1728 
1729 pragma solidity 0.5.12;
1730 pragma experimental ABIEncoderV2;
1731 
1732 
1733 
1734 
1735 
1736 
1737 /**
1738  * @title WhitelistedMinter
1739  * @dev Defines the functions for distribution of Second Level Domains (SLD)s.
1740  */
1741 contract WhitelistedMinter is IMintingController, BulkWhitelistedRole {
1742 
1743     MintingController internal _mintingController;
1744     Resolver internal _resolver;
1745     Registry internal _registry;
1746 
1747     constructor (MintingController mintingController) public {
1748         _mintingController = mintingController;
1749         _registry = Registry(mintingController.registry());
1750     }
1751 
1752     function renounceMinter() external {
1753         _mintingController.renounceMinter();
1754     }
1755 
1756     function mintSLD(address to, string calldata label) external onlyWhitelisted {
1757         _mintingController.mintSLD(to, label);
1758     }
1759 
1760     function safeMintSLD(address to, string calldata label) external onlyWhitelisted {
1761         _mintingController.safeMintSLD(to, label);
1762     }
1763 
1764     function safeMintSLD(address to, string calldata label, bytes calldata _data) external onlyWhitelisted {
1765         _mintingController.safeMintSLD(to, label, _data);
1766     }
1767 
1768     function mintSLDToDefaultResolver(address to, string memory label, string[] memory keys, string[] memory values) public onlyWhitelisted {
1769         _mintingController.mintSLDWithResolver(to, label, address(_resolver));
1770         _resolver.preconfigure(keys, values, _registry.childIdOf(_registry.root(), label));
1771     }
1772 
1773     function safeMintSLDToDefaultResolver(address to, string memory label, string[] memory keys, string[] memory values) public onlyWhitelisted {
1774         _mintingController.safeMintSLDWithResolver(to, label, address(_resolver));
1775         _resolver.preconfigure(keys, values, _registry.childIdOf(_registry.root(), label));
1776     }
1777 
1778     function safeMintSLDToDefaultResolver(address to, string memory label, string[] memory keys, string[] memory values, bytes memory _data) public onlyWhitelisted {
1779         _mintingController.safeMintSLDWithResolver(to, label, address(_resolver), _data);
1780         _resolver.preconfigure(keys, values, _registry.childIdOf(_registry.root(), label));
1781     }
1782 
1783     function setDefaultResolver(address resolver) external onlyWhitelistAdmin {
1784         _resolver = Resolver(resolver);
1785     }
1786 
1787 }