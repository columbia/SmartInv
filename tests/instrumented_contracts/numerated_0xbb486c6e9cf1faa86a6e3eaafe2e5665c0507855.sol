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
141 // File: @openzeppelin/contracts/access/roles/CapperRole.sol
142 
143 pragma solidity ^0.5.0;
144 
145 
146 contract CapperRole {
147     using Roles for Roles.Role;
148 
149     event CapperAdded(address indexed account);
150     event CapperRemoved(address indexed account);
151 
152     Roles.Role private _cappers;
153 
154     constructor () internal {
155         _addCapper(msg.sender);
156     }
157 
158     modifier onlyCapper() {
159         require(isCapper(msg.sender), "CapperRole: caller does not have the Capper role");
160         _;
161     }
162 
163     function isCapper(address account) public view returns (bool) {
164         return _cappers.has(account);
165     }
166 
167     function addCapper(address account) public onlyCapper {
168         _addCapper(account);
169     }
170 
171     function renounceCapper() public {
172         _removeCapper(msg.sender);
173     }
174 
175     function _addCapper(address account) internal {
176         _cappers.add(account);
177         emit CapperAdded(account);
178     }
179 
180     function _removeCapper(address account) internal {
181         _cappers.remove(account);
182         emit CapperRemoved(account);
183     }
184 }
185 
186 // File: @openzeppelin/contracts/math/SafeMath.sol
187 
188 pragma solidity ^0.5.0;
189 
190 /**
191  * @dev Wrappers over Solidity's arithmetic operations with added overflow
192  * checks.
193  *
194  * Arithmetic operations in Solidity wrap on overflow. This can easily result
195  * in bugs, because programmers usually assume that an overflow raises an
196  * error, which is the standard behavior in high level programming languages.
197  * `SafeMath` restores this intuition by reverting the transaction when an
198  * operation overflows.
199  *
200  * Using this library instead of the unchecked operations eliminates an entire
201  * class of bugs, so it's recommended to use it always.
202  */
203 library SafeMath {
204     /**
205      * @dev Returns the addition of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `+` operator.
209      *
210      * Requirements:
211      * - Addition cannot overflow.
212      */
213     function add(uint256 a, uint256 b) internal pure returns (uint256) {
214         uint256 c = a + b;
215         require(c >= a, "SafeMath: addition overflow");
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      * - Subtraction cannot overflow.
228      */
229     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b <= a, "SafeMath: subtraction overflow");
231         uint256 c = a - b;
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `*` operator.
241      *
242      * Requirements:
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         uint256 c = a * b;
254         require(c / a == b, "SafeMath: multiplication overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      * - The divisor cannot be zero.
269      */
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Solidity only automatically asserts when dividing by 0
272         require(b > 0, "SafeMath: division by zero");
273         uint256 c = a / b;
274         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * Reverts when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      * - The divisor cannot be zero.
289      */
290     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
291         require(b != 0, "SafeMath: modulo by zero");
292         return a % b;
293     }
294 }
295 
296 // File: @chainlink/contracts/src/v0.5/interfaces/LinkTokenInterface.sol
297 
298 pragma solidity ^0.5.0;
299 
300 interface LinkTokenInterface {
301   function allowance(address owner, address spender) external view returns (uint256 remaining);
302   function approve(address spender, uint256 value) external returns (bool success);
303   function balanceOf(address owner) external view returns (uint256 balance);
304   function decimals() external view returns (uint8 decimalPlaces);
305   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
306   function increaseApproval(address spender, uint256 subtractedValue) external;
307   function name() external view returns (string memory tokenName);
308   function symbol() external view returns (string memory tokenSymbol);
309   function totalSupply() external view returns (uint256 totalTokensIssued);
310   function transfer(address to, uint256 value) external returns (bool success);
311   function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
312   function transferFrom(address from, address to, uint256 value) external returns (bool success);
313 }
314 
315 // File: contracts/util/ERC677Receiver.sol
316 
317 pragma solidity 0.5.12;
318 
319 contract ERC677Receiver {
320     /**
321     * @dev Method invoked when tokens transferred via transferAndCall method
322     * @param _sender Original token sender
323     * @param _value Tokens amount
324     * @param _data Additional data passed to contract
325     */
326     function onTokenTransfer(address _sender, uint256 _value, bytes calldata _data) external;
327 }
328 
329 // File: @openzeppelin/contracts/introspection/IERC165.sol
330 
331 pragma solidity ^0.5.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others (`ERC165Checker`).
339  *
340  * For an implementation, see `ERC165`.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
355 
356 pragma solidity ^0.5.0;
357 
358 
359 /**
360  * @dev Required interface of an ERC721 compliant contract.
361  */
362 contract IERC721 is IERC165 {
363     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
364     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
365     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
366 
367     /**
368      * @dev Returns the number of NFTs in `owner`'s account.
369      */
370     function balanceOf(address owner) public view returns (uint256 balance);
371 
372     /**
373      * @dev Returns the owner of the NFT specified by `tokenId`.
374      */
375     function ownerOf(uint256 tokenId) public view returns (address owner);
376 
377     /**
378      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
379      * another (`to`).
380      *
381      * 
382      *
383      * Requirements:
384      * - `from`, `to` cannot be zero.
385      * - `tokenId` must be owned by `from`.
386      * - If the caller is not `from`, it must be have been allowed to move this
387      * NFT by either `approve` or `setApproveForAll`.
388      */
389     function safeTransferFrom(address from, address to, uint256 tokenId) public;
390     /**
391      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
392      * another (`to`).
393      *
394      * Requirements:
395      * - If the caller is not `from`, it must be approved to move this NFT by
396      * either `approve` or `setApproveForAll`.
397      */
398     function transferFrom(address from, address to, uint256 tokenId) public;
399     function approve(address to, uint256 tokenId) public;
400     function getApproved(uint256 tokenId) public view returns (address operator);
401 
402     function setApprovalForAll(address operator, bool _approved) public;
403     function isApprovedForAll(address owner, address operator) public view returns (bool);
404 
405 
406     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
410 
411 pragma solidity ^0.5.0;
412 
413 
414 /**
415  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
416  * @dev See https://eips.ethereum.org/EIPS/eip-721
417  */
418 contract IERC721Metadata is IERC721 {
419     function name() external view returns (string memory);
420     function symbol() external view returns (string memory);
421     function tokenURI(uint256 tokenId) external view returns (string memory);
422 }
423 
424 // File: contracts/IRegistry.sol
425 
426 pragma solidity 0.5.12;
427 
428 
429 contract IRegistry is IERC721Metadata {
430 
431     event NewURI(uint256 indexed tokenId, string uri);
432 
433     event NewURIPrefix(string prefix);
434 
435     event Resolve(uint256 indexed tokenId, address indexed to);
436 
437     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
438 
439     /**
440      * @dev Controlled function to set the token URI Prefix for all tokens.
441      * @param prefix string URI to assign
442      */
443     function controlledSetTokenURIPrefix(string calldata prefix) external;
444 
445     /**
446      * @dev Returns whether the given spender can transfer a given token ID.
447      * @param spender address of the spender to query
448      * @param tokenId uint256 ID of the token to be transferred
449      * @return bool whether the msg.sender is approved for the given token ID,
450      * is an operator of the owner, or is the owner of the token
451      */
452     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
453 
454     /**
455      * @dev Mints a new a child token.
456      * Calculates child token ID using a namehash function.
457      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
458      * Requires the token not exist.
459      * @param to address to receive the ownership of the given token ID
460      * @param tokenId uint256 ID of the parent token
461      * @param label subdomain label of the child token ID
462      */
463     function mintChild(address to, uint256 tokenId, string calldata label) external;
464 
465     /**
466      * @dev Controlled function to mint a given token ID.
467      * Requires the msg.sender to be controller.
468      * Requires the token ID to not exist.
469      * @param to address the given token ID will be minted to
470      * @param label string that is a subdomain
471      * @param tokenId uint256 ID of the parent token
472      */
473     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
474 
475     /**
476      * @dev Transfers the ownership of a child token ID to another address.
477      * Calculates child token ID using a namehash function.
478      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
479      * Requires the token already exist.
480      * @param from current owner of the token
481      * @param to address to receive the ownership of the given token ID
482      * @param tokenId uint256 ID of the token to be transferred
483      * @param label subdomain label of the child token ID
484      */
485     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
486 
487     /**
488      * @dev Controlled function to transfers the ownership of a token ID to
489      * another address.
490      * Requires the msg.sender to be controller.
491      * Requires the token already exist.
492      * @param from current owner of the token
493      * @param to address to receive the ownership of the given token ID
494      * @param tokenId uint256 ID of the token to be transferred
495      */
496     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
497 
498     /**
499      * @dev Safely transfers the ownership of a child token ID to another address.
500      * Calculates child token ID using a namehash function.
501      * Implements a ERC721Reciever check unlike transferFromChild.
502      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
503      * Requires the token already exist.
504      * @param from current owner of the token
505      * @param to address to receive the ownership of the given token ID
506      * @param tokenId uint256 parent ID of the token to be transferred
507      * @param label subdomain label of the child token ID
508      * @param _data bytes data to send along with a safe transfer check
509      */
510     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
511 
512     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
513     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
514 
515     /**
516      * @dev Controlled frunction to safely transfers the ownership of a token ID
517      * to another address.
518      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
519      * Requires the msg.sender to be controller.
520      * Requires the token already exist.
521      * @param from current owner of the token
522      * @param to address to receive the ownership of the given token ID
523      * @param tokenId uint256 parent ID of the token to be transferred
524      * @param _data bytes data to send along with a safe transfer check
525      */
526     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
527 
528     /**
529      * @dev Burns a child token ID.
530      * Calculates child token ID using a namehash function.
531      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
532      * Requires the token already exist.
533      * @param tokenId uint256 ID of the token to be transferred
534      * @param label subdomain label of the child token ID
535      */
536     function burnChild(uint256 tokenId, string calldata label) external;
537 
538     /**
539      * @dev Controlled function to burn a given token ID.
540      * Requires the msg.sender to be controller.
541      * Requires the token already exist.
542      * @param tokenId uint256 ID of the token to be burned
543      */
544     function controlledBurn(uint256 tokenId) external;
545 
546     /**
547      * @dev Sets the resolver of a given token ID to another address.
548      * Requires the msg.sender to be the owner, approved, or operator.
549      * @param to address the given token ID will resolve to
550      * @param tokenId uint256 ID of the token to be transferred
551      */
552     function resolveTo(address to, uint256 tokenId) external;
553 
554     /**
555      * @dev Gets the resolver of the specified token ID.
556      * @param tokenId uint256 ID of the token to query the resolver of
557      * @return address currently marked as the resolver of the given token ID
558      */
559     function resolverOf(uint256 tokenId) external view returns (address);
560 
561     /**
562      * @dev Controlled function to sets the resolver of a given token ID.
563      * Requires the msg.sender to be controller.
564      * @param to address the given token ID will resolve to
565      * @param tokenId uint256 ID of the token to be transferred
566      */
567     function controlledResolveTo(address to, uint256 tokenId) external;
568 
569     /**
570      * @dev Provides child token (subdomain) of provided tokenId.
571      * @param tokenId uint256 ID of the token
572      * @param label label of subdomain (for `aaa.bbb.crypto` it will be `aaa`)
573      */
574     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256);
575 
576     /**
577      * @dev Transfer domain ownership without resetting domain records.
578      * @param to address of new domain owner
579      * @param tokenId uint256 ID of the token to be transferred
580      */
581     function setOwner(address to, uint256 tokenId) external;
582 }
583 
584 // File: contracts/IResolver.sol
585 
586 pragma solidity 0.5.12;
587 pragma experimental ABIEncoderV2;
588 
589 contract IResolver {
590     /**
591      * @dev Reset all domain records and set new ones
592      * @param keys New record keys
593      * @param values New record values
594      * @param tokenId ERC-721 token id of the domain
595      */
596     function reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) public;
597 
598     /**
599      * @dev Set or update domain records
600      * @param keys New record keys
601      * @param values New record values
602      * @param tokenId ERC-721 token id of the domain
603      */
604     function setMany(string[] memory keys, string[] memory values, uint256 tokenId) public;
605 
606     /**
607      * @dev Function to set record.
608      * @param key The key set the value of.
609      * @param value The value to set key to.
610      * @param tokenId ERC-721 token id to set.
611      */
612     function set(string calldata key, string calldata value, uint256 tokenId) external;
613 
614     /**
615      * @dev Function to reset all existing records on a domain.
616      * @param tokenId ERC-721 token id to set.
617      */
618     function reset(uint256 tokenId) external;
619 }
620 
621 // File: contracts/operators/TwitterValidationOperator.sol
622 
623 pragma solidity 0.5.12;
624 // pragma experimental ABIEncoderV2;
625 
626 
627 
628 
629 
630 
631 
632 
633 contract TwitterValidationOperator is WhitelistedRole, CapperRole, ERC677Receiver {
634     string public constant NAME = 'Chainlink Twitter Validation Operator';
635     string public constant VERSION = '0.2.0';
636 
637     using SafeMath for uint256;
638 
639     event Validation(uint256 indexed tokenId, uint256 requestId, uint256 paymentAmount);
640     event ValidationRequest(uint256 indexed tokenId, address indexed owner, uint256 requestId, string code);
641     event PaymentSet(uint256 operatorPaymentPerValidation, uint256 userPaymentPerValidation);
642 
643     uint256 public operatorPaymentPerValidation;
644     uint256 public userPaymentPerValidation;
645     uint256 public withdrawableTokens;
646 
647     uint256 private frozenTokens;
648     uint256 private lastRequestId = 1;
649     mapping(uint256 => uint256) private userRequests;
650     IRegistry private registry;
651     LinkTokenInterface private linkToken;
652 
653     /**
654     * @notice Deploy with the address of the LINK token, domains registry and payment amount in LINK for one valiation
655     * @dev Sets the LinkToken address, Registry address and payment in LINK tokens for one validation
656     * @param _registry The address of the .crypto Registry
657     * @param _linkToken The address of the LINK token
658     * @param _paymentCappers Addresses allowed to update payment amount per validation
659     */
660     constructor (IRegistry _registry, LinkTokenInterface _linkToken, address[] memory _paymentCappers) public {
661         require(address(_registry) != address(0), "TwitterValidationOperator: INVALID_REGISTRY_ADDRESS");
662         require(address(_linkToken) != address(0), "TwitterValidationOperator: INVALID_LINK_TOKEN_ADDRESS");
663         require(_paymentCappers.length > 0, "TwitterValidationOperator: NO_CAPPERS_PROVIDED");
664         registry = _registry;
665         linkToken = _linkToken;
666         uint256 cappersCount = _paymentCappers.length;
667         for (uint256 i = 0; i < cappersCount; i++) {
668             addCapper(_paymentCappers[i]);
669         }
670         renounceCapper();
671     }
672 
673     /**
674     * @dev Reverts if amount requested is greater than withdrawable balance
675     * @param _amount The given amount to compare to `withdrawableTokens`
676     */
677     modifier hasAvailableFunds(uint256 _amount) {
678         require(withdrawableTokens >= _amount, "TwitterValidationOperator: TOO_MANY_TOKENS_REQUESTED");
679         _;
680     }
681 
682     /**
683      * @dev Reverts if contract doesn not have enough LINK tokens to fulfil validation
684      */
685     modifier hasAvailableBalance() {
686         require(
687             availableBalance() >= withdrawableTokens.add(operatorPaymentPerValidation),
688             "TwitterValidationOperator: NOT_ENOUGH_TOKENS_ON_CONTRACT_BALANCE"
689         );
690         _;
691     }
692 
693     /**
694      * @dev Reverts if method called not from LINK token contract
695      */
696     modifier linkTokenOnly() {
697         require(msg.sender == address(linkToken), "TwitterValidationOperator: CAN_CALL_FROM_LINK_TOKEN_ONLY");
698         _;
699     }
700 
701     /**
702      * @dev Reverts if user sent incorrect amount of LINK tokens
703      */
704     modifier correctTokensAmount(uint256 _value) {
705         require(_value == userPaymentPerValidation, "TwitterValidationOperator: INCORRECT_TOKENS_AMOUNT");
706         _;
707     }
708 
709     /**
710      * @notice Method will be called by Chainlink node in the end of the job. Provides user twitter name and validation signature
711      * @dev Sets twitter username and signature to .crypto domain records
712      * @param _username Twitter username
713      * @param _signature Signed twitter username. Ensures the validity of twitter username
714      * @param _tokenId Domain token ID
715      * @param _requestId Request id for validations were requested from Smart Contract. If validation was requested from operator `_requestId` should be equals to zero.
716      */
717     function setValidation(string calldata _username, string calldata _signature, uint256 _tokenId, uint256 _requestId)
718     external
719     onlyWhitelisted
720     hasAvailableBalance {
721         uint256 _payment = calculatePaymentForValidation(_requestId);
722         withdrawableTokens = withdrawableTokens.add(_payment);
723         IResolver Resolver = IResolver(registry.resolverOf(_tokenId));
724         Resolver.set("social.twitter.username", _username, _tokenId);
725         Resolver.set("validation.social.twitter.username", _signature, _tokenId);
726         emit Validation(_tokenId, _requestId, _payment);
727     }
728 
729     /**
730     * @notice Method returns true if Node Operator able to set validation
731     * @dev Returns true or error
732     */
733     function canSetValidation() external view onlyWhitelisted hasAvailableBalance returns (bool) {
734         return true;
735     }
736 
737     /**
738      * @notice Method allows to update payments per one validation in LINK tokens
739      * @dev Sets operatorPaymentPerValidation and userPaymentPerValidation variables
740      * @param _operatorPaymentPerValidation Payment amount in LINK tokens when verification initiated via Operator
741      * @param _userPaymentPerValidation Payment amount in LINK tokens when verification initiated directly by user via Smart Contract call
742      */
743     function setPaymentPerValidation(uint256 _operatorPaymentPerValidation, uint256 _userPaymentPerValidation) external onlyCapper {
744         operatorPaymentPerValidation = _operatorPaymentPerValidation;
745         userPaymentPerValidation = _userPaymentPerValidation;
746         emit PaymentSet(operatorPaymentPerValidation, userPaymentPerValidation);
747     }
748 
749     /**
750     * @notice Allows the node operator to withdraw earned LINK to a given address
751     * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
752     * @param _recipient The address to send the LINK token to
753     * @param _amount The amount to send (specified in wei)
754     */
755     function withdraw(address _recipient, uint256 _amount) external onlyWhitelistAdmin hasAvailableFunds(_amount) {
756         withdrawableTokens = withdrawableTokens.sub(_amount);
757         assert(linkToken.transfer(_recipient, _amount));
758     }
759 
760     /**
761     * @notice Initiate Twitter validation
762     * @dev Method invoked when LINK tokens transferred via transferAndCall method. Requires additional encoded data
763     * @param _sender Original token sender
764     * @param _value Tokens amount
765     * @param _data Encoded additional data needed to initiate domain verification: `abi.encode(uint256 tokenId, string code)`
766     */
767     function onTokenTransfer(address _sender, uint256 _value, bytes calldata _data) external linkTokenOnly correctTokensAmount(_value) {
768         (uint256 _tokenId, string memory _code) = abi.decode(_data, (uint256, string));
769         require(registry.isApprovedOrOwner(_sender, _tokenId), "TwitterValidationOperator: SENDER_DOES_NOT_HAVE_ACCESS_TO_DOMAIN");
770         require(bytes(_code).length > 0, "TwitterValidationOperator: CODE_IS_EMPTY");
771         require(registry.isApprovedOrOwner(address(this), _tokenId), "TwitterValidationOperator: OPERATOR_SHOULD_BE_APPROVED");
772         frozenTokens = frozenTokens.add(_value);
773         userRequests[lastRequestId] = _value;
774 
775         emit ValidationRequest(_tokenId, registry.ownerOf(_tokenId), lastRequestId, _code);
776         lastRequestId = lastRequestId.add(1);
777     }
778 
779     /**
780     * @notice Method returns available LINK tokens balance minus held tokens
781     * @dev Returns tokens amount
782     */
783     function availableBalance() public view returns (uint256) {
784         return linkToken.balanceOf(address(this)).sub(frozenTokens);
785     }
786 
787     function calculatePaymentForValidation(uint256 _requestId) private returns (uint256 _paymentPerValidation) {
788         if (_requestId > 0) {// Validation was requested from Smart Contract. We need to search for price in mapping
789             _paymentPerValidation = userRequests[_requestId];
790             frozenTokens = frozenTokens.sub(_paymentPerValidation);
791             delete userRequests[_requestId];
792         } else {
793             _paymentPerValidation = operatorPaymentPerValidation;
794         }
795     }
796 }