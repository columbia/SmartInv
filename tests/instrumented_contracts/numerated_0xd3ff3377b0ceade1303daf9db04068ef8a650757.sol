1 pragma solidity 0.5.12;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
7  *
8  * These functions can be used to verify that a message was signed by the holder
9  * of the private keys of a given address.
10  */
11 library ECDSA {
12     /**
13      * @dev Returns the address that signed a hashed message (`hash`) with
14      * `signature`. This address can then be used for verification purposes.
15      *
16      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
17      * this function rejects them by requiring the `s` value to be in the lower
18      * half order, and the `v` value to be either 27 or 28.
19      *
20      * (.note) This call _does not revert_ if the signature is invalid, or
21      * if the signer is otherwise unable to be retrieved. In those scenarios,
22      * the zero address is returned.
23      *
24      * (.warning) `hash` _must_ be the result of a hash operation for the
25      * verification to be secure: it is possible to craft signatures that
26      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
27      * this is by receiving a hash of the original message (which may otherwise)
28      * be too long), and then calling `toEthSignedMessageHash` on it.
29      */
30     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
31         // Check the signature length
32         if (signature.length != 65) {
33             return (address(0));
34         }
35 
36         // Divide the signature in r, s and v variables
37         bytes32 r;
38         bytes32 s;
39         uint8 v;
40 
41         // ecrecover takes the signature parameters, and the only way to get them
42         // currently is to use assembly.
43         // solhint-disable-next-line no-inline-assembly
44         assembly {
45             r := mload(add(signature, 0x20))
46             s := mload(add(signature, 0x40))
47             v := byte(0, mload(add(signature, 0x60)))
48         }
49 
50         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
51         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
52         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
53         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
54         //
55         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
56         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
57         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
58         // these malleable signatures as well.
59         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
60             return address(0);
61         }
62 
63         if (v != 27 && v != 28) {
64             return address(0);
65         }
66 
67         // If the signature is valid (and not malleable), return the signer address
68         return ecrecover(hash, v, r, s);
69     }
70 
71     /**
72      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
73      * replicates the behavior of the
74      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
75      * JSON-RPC method.
76      *
77      * See `recover`.
78      */
79     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
80         // 32 is the length in bytes of hash,
81         // enforced by the type signature above
82         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
83     }
84 }
85 
86 /**
87  * @title Roles
88  * @dev Library for managing addresses assigned to a Role.
89  */
90 library Roles {
91     struct Role {
92         mapping (address => bool) bearer;
93     }
94 
95     /**
96      * @dev Give an account access to this role.
97      */
98     function add(Role storage role, address account) internal {
99         require(!has(role, account), "Roles: account already has role");
100         role.bearer[account] = true;
101     }
102 
103     /**
104      * @dev Remove an account's access to this role.
105      */
106     function remove(Role storage role, address account) internal {
107         require(has(role, account), "Roles: account does not have role");
108         role.bearer[account] = false;
109     }
110 
111     /**
112      * @dev Check if an account has this role.
113      * @return bool
114      */
115     function has(Role storage role, address account) internal view returns (bool) {
116         require(account != address(0), "Roles: account is the zero address");
117         return role.bearer[account];
118     }
119 }
120 
121 /**
122  * @title WhitelistAdminRole
123  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
124  */
125 contract WhitelistAdminRole {
126     using Roles for Roles.Role;
127 
128     event WhitelistAdminAdded(address indexed account);
129     event WhitelistAdminRemoved(address indexed account);
130 
131     Roles.Role private _whitelistAdmins;
132 
133     constructor () internal {
134         _addWhitelistAdmin(msg.sender);
135     }
136 
137     modifier onlyWhitelistAdmin() {
138         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
139         _;
140     }
141 
142     function isWhitelistAdmin(address account) public view returns (bool) {
143         return _whitelistAdmins.has(account);
144     }
145 
146     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
147         _addWhitelistAdmin(account);
148     }
149 
150     function renounceWhitelistAdmin() public {
151         _removeWhitelistAdmin(msg.sender);
152     }
153 
154     function _addWhitelistAdmin(address account) internal {
155         _whitelistAdmins.add(account);
156         emit WhitelistAdminAdded(account);
157     }
158 
159     function _removeWhitelistAdmin(address account) internal {
160         _whitelistAdmins.remove(account);
161         emit WhitelistAdminRemoved(account);
162     }
163 }
164 
165 /**
166  * @title WhitelistedRole
167  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
168  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
169  * it), and not Whitelisteds themselves.
170  */
171 contract WhitelistedRole is WhitelistAdminRole {
172     using Roles for Roles.Role;
173 
174     event WhitelistedAdded(address indexed account);
175     event WhitelistedRemoved(address indexed account);
176 
177     Roles.Role private _whitelisteds;
178 
179     modifier onlyWhitelisted() {
180         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
181         _;
182     }
183 
184     function isWhitelisted(address account) public view returns (bool) {
185         return _whitelisteds.has(account);
186     }
187 
188     function addWhitelisted(address account) public onlyWhitelistAdmin {
189         _addWhitelisted(account);
190     }
191 
192     function removeWhitelisted(address account) public onlyWhitelistAdmin {
193         _removeWhitelisted(account);
194     }
195 
196     function renounceWhitelisted() public {
197         _removeWhitelisted(msg.sender);
198     }
199 
200     function _addWhitelisted(address account) internal {
201         _whitelisteds.add(account);
202         emit WhitelistedAdded(account);
203     }
204 
205     function _removeWhitelisted(address account) internal {
206         _whitelisteds.remove(account);
207         emit WhitelistedRemoved(account);
208     }
209 }
210 
211 /**
212  * @title BulkWhitelistedRole
213  * @dev a Whitelist role defined using the Open Zeppelin Role system with the addition of bulkAddWhitelisted and
214  * bulkRemoveWhitelisted.
215  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
216  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
217  * it), and not Whitelisteds themselves.
218  */
219 contract BulkWhitelistedRole is WhitelistedRole {
220 
221     function bulkAddWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
222         for (uint256 index = 0; index < accounts.length; index++) {
223             _addWhitelisted(accounts[index]);
224         }
225     }
226 
227     function bulkRemoveWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
228         for (uint256 index = 0; index < accounts.length; index++) {
229             _removeWhitelisted(accounts[index]);
230         }
231     }
232 
233 }
234 
235 interface IMintingController {
236 
237     /**
238      * @dev Minter function that mints a Second Level Domain (SLD).
239      * @param to address to mint the new SLD to.
240      * @param label SLD label to mint.
241      */
242     function mintSLD(address to, string calldata label) external;
243 
244     /**
245      * @dev Minter function that safely mints a Second Level Domain (SLD).
246      * Implements a ERC721Reciever check unlike mintSLD.
247      * @param to address to mint the new SLD to.
248      * @param label SLD label to mint.
249      */
250     function safeMintSLD(address to, string calldata label) external;
251 
252     /**
253      * @dev Minter function that safely mints a Second Level Domain (SLD).
254      * Implements a ERC721Reciever check unlike mintSLD.
255      * @param to address to mint the new SLD to.
256      * @param label SLD label to mint.
257      * @param _data bytes data to send along with a safe transfer check
258      */
259     function safeMintSLD(address to, string calldata label, bytes calldata _data) external;
260 
261 }
262 
263 contract MinterRole {
264     using Roles for Roles.Role;
265 
266     event MinterAdded(address indexed account);
267     event MinterRemoved(address indexed account);
268 
269     Roles.Role private _minters;
270 
271     constructor () internal {
272         _addMinter(msg.sender);
273     }
274 
275     modifier onlyMinter() {
276         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
277         _;
278     }
279 
280     function isMinter(address account) public view returns (bool) {
281         return _minters.has(account);
282     }
283 
284     function addMinter(address account) public onlyMinter {
285         _addMinter(account);
286     }
287 
288     function renounceMinter() public {
289         _removeMinter(msg.sender);
290     }
291 
292     function _addMinter(address account) internal {
293         _minters.add(account);
294         emit MinterAdded(account);
295     }
296 
297     function _removeMinter(address account) internal {
298         _minters.remove(account);
299         emit MinterRemoved(account);
300     }
301 }
302 
303 /**
304  * @dev Interface of the ERC165 standard, as defined in the
305  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
306  *
307  * Implementers can declare support of contract interfaces, which can then be
308  * queried by others (`ERC165Checker`).
309  *
310  * For an implementation, see `ERC165`.
311  */
312 interface IERC165 {
313     /**
314      * @dev Returns true if this contract implements the interface defined by
315      * `interfaceId`. See the corresponding
316      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
317      * to learn more about how these ids are created.
318      *
319      * This function call must use less than 30 000 gas.
320      */
321     function supportsInterface(bytes4 interfaceId) external view returns (bool);
322 }
323 
324 /**
325  * @dev Required interface of an ERC721 compliant contract.
326  */
327 contract IERC721 is IERC165 {
328     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
329     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
330     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
331 
332     /**
333      * @dev Returns the number of NFTs in `owner`'s account.
334      */
335     function balanceOf(address owner) public view returns (uint256 balance);
336 
337     /**
338      * @dev Returns the owner of the NFT specified by `tokenId`.
339      */
340     function ownerOf(uint256 tokenId) public view returns (address owner);
341 
342     /**
343      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
344      * another (`to`).
345      *
346      * 
347      *
348      * Requirements:
349      * - `from`, `to` cannot be zero.
350      * - `tokenId` must be owned by `from`.
351      * - If the caller is not `from`, it must be have been allowed to move this
352      * NFT by either `approve` or `setApproveForAll`.
353      */
354     function safeTransferFrom(address from, address to, uint256 tokenId) public;
355     /**
356      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
357      * another (`to`).
358      *
359      * Requirements:
360      * - If the caller is not `from`, it must be approved to move this NFT by
361      * either `approve` or `setApproveForAll`.
362      */
363     function transferFrom(address from, address to, uint256 tokenId) public;
364     function approve(address to, uint256 tokenId) public;
365     function getApproved(uint256 tokenId) public view returns (address operator);
366 
367     function setApprovalForAll(address operator, bool _approved) public;
368     function isApprovedForAll(address owner, address operator) public view returns (bool);
369 
370 
371     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
372 }
373 
374 /**
375  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
376  * @dev See https://eips.ethereum.org/EIPS/eip-721
377  */
378 contract IERC721Metadata is IERC721 {
379     function name() external view returns (string memory);
380     function symbol() external view returns (string memory);
381     function tokenURI(uint256 tokenId) external view returns (string memory);
382 }
383 
384 contract IRegistry is IERC721Metadata {
385 
386     event NewURI(uint256 indexed tokenId, string uri);
387 
388     event NewURIPrefix(string prefix);
389 
390     event Resolve(uint256 indexed tokenId, address indexed to);
391 
392     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
393 
394     /**
395      * @dev Controlled function to set the token URI Prefix for all tokens.
396      * @param prefix string URI to assign
397      */
398     function controlledSetTokenURIPrefix(string calldata prefix) external;
399 
400     /**
401      * @dev Returns whether the given spender can transfer a given token ID.
402      * @param spender address of the spender to query
403      * @param tokenId uint256 ID of the token to be transferred
404      * @return bool whether the msg.sender is approved for the given token ID,
405      * is an operator of the owner, or is the owner of the token
406      */
407     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
408 
409     /**
410      * @dev Mints a new a child token.
411      * Calculates child token ID using a namehash function.
412      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
413      * Requires the token not exist.
414      * @param to address to receive the ownership of the given token ID
415      * @param tokenId uint256 ID of the parent token
416      * @param label subdomain label of the child token ID
417      */
418     function mintChild(address to, uint256 tokenId, string calldata label) external;
419 
420     /**
421      * @dev Controlled function to mint a given token ID.
422      * Requires the msg.sender to be controller.
423      * Requires the token ID to not exist.
424      * @param to address the given token ID will be minted to
425      * @param label string that is a subdomain
426      * @param tokenId uint256 ID of the parent token
427      */
428     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
429 
430     /**
431      * @dev Transfers the ownership of a child token ID to another address.
432      * Calculates child token ID using a namehash function.
433      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
434      * Requires the token already exist.
435      * @param from current owner of the token
436      * @param to address to receive the ownership of the given token ID
437      * @param tokenId uint256 ID of the token to be transferred
438      * @param label subdomain label of the child token ID
439      */
440     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
441 
442     /**
443      * @dev Controlled function to transfers the ownership of a token ID to
444      * another address.
445      * Requires the msg.sender to be controller.
446      * Requires the token already exist.
447      * @param from current owner of the token
448      * @param to address to receive the ownership of the given token ID
449      * @param tokenId uint256 ID of the token to be transferred
450      */
451     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
452 
453     /**
454      * @dev Safely transfers the ownership of a child token ID to another address.
455      * Calculates child token ID using a namehash function.
456      * Implements a ERC721Reciever check unlike transferFromChild.
457      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
458      * Requires the token already exist.
459      * @param from current owner of the token
460      * @param to address to receive the ownership of the given token ID
461      * @param tokenId uint256 parent ID of the token to be transferred
462      * @param label subdomain label of the child token ID
463      * @param _data bytes data to send along with a safe transfer check
464      */
465     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
466 
467     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
468     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
469 
470     /**
471      * @dev Controlled frunction to safely transfers the ownership of a token ID
472      * to another address.
473      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
474      * Requires the msg.sender to be controller.
475      * Requires the token already exist.
476      * @param from current owner of the token
477      * @param to address to receive the ownership of the given token ID
478      * @param tokenId uint256 parent ID of the token to be transferred
479      * @param _data bytes data to send along with a safe transfer check
480      */
481     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
482 
483     /**
484      * @dev Burns a child token ID.
485      * Calculates child token ID using a namehash function.
486      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
487      * Requires the token already exist.
488      * @param tokenId uint256 ID of the token to be transferred
489      * @param label subdomain label of the child token ID
490      */
491     function burnChild(uint256 tokenId, string calldata label) external;
492 
493     /**
494      * @dev Controlled function to burn a given token ID.
495      * Requires the msg.sender to be controller.
496      * Requires the token already exist.
497      * @param tokenId uint256 ID of the token to be burned
498      */
499     function controlledBurn(uint256 tokenId) external;
500 
501     /**
502      * @dev Sets the resolver of a given token ID to another address.
503      * Requires the msg.sender to be the owner, approved, or operator.
504      * @param to address the given token ID will resolve to
505      * @param tokenId uint256 ID of the token to be transferred
506      */
507     function resolveTo(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Gets the resolver of the specified token ID.
511      * @param tokenId uint256 ID of the token to query the resolver of
512      * @return address currently marked as the resolver of the given token ID
513      */
514     function resolverOf(uint256 tokenId) external view returns (address);
515 
516     /**
517      * @dev Controlled function to sets the resolver of a given token ID.
518      * Requires the msg.sender to be controller.
519      * @param to address the given token ID will resolve to
520      * @param tokenId uint256 ID of the token to be transferred
521      */
522     function controlledResolveTo(address to, uint256 tokenId) external;
523 
524     /**
525      * @dev Provides child token (subdomain) of provided tokenId.
526      * @param tokenId uint256 ID of the token
527      * @param label label of subdomain (for `aaa.bbb.crypto` it will be `aaa`)
528      */
529     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256);
530 
531     /**
532      * @dev Transfer domain ownership without resetting domain records.
533      * @param to address of new domain owner
534      * @param tokenId uint256 ID of the token to be transferred
535      */
536     function setOwner(address to, uint256 tokenId) external;
537 }
538 
539 /**
540  * @title ERC721 token receiver interface
541  * @dev Interface for any contract that wants to support safeTransfers
542  * from ERC721 asset contracts.
543  */
544 contract IERC721Receiver {
545     /**
546      * @notice Handle the receipt of an NFT
547      * @dev The ERC721 smart contract calls this function on the recipient
548      * after a `safeTransfer`. This function MUST return the function selector,
549      * otherwise the caller will revert the transaction. The selector to be
550      * returned can be obtained as `this.onERC721Received.selector`. This
551      * function MAY throw to revert and reject the transfer.
552      * Note: the ERC721 contract address is always the message sender.
553      * @param operator The address which called `safeTransferFrom` function
554      * @param from The address which previously owned the token
555      * @param tokenId The NFT identifier which is being transferred
556      * @param data Additional data with no specified format
557      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
558      */
559     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
560     public returns (bytes4);
561 }
562 
563 /**
564  * @dev Wrappers over Solidity's arithmetic operations with added overflow
565  * checks.
566  *
567  * Arithmetic operations in Solidity wrap on overflow. This can easily result
568  * in bugs, because programmers usually assume that an overflow raises an
569  * error, which is the standard behavior in high level programming languages.
570  * `SafeMath` restores this intuition by reverting the transaction when an
571  * operation overflows.
572  *
573  * Using this library instead of the unchecked operations eliminates an entire
574  * class of bugs, so it's recommended to use it always.
575  */
576 library SafeMath {
577     /**
578      * @dev Returns the addition of two unsigned integers, reverting on
579      * overflow.
580      *
581      * Counterpart to Solidity's `+` operator.
582      *
583      * Requirements:
584      * - Addition cannot overflow.
585      */
586     function add(uint256 a, uint256 b) internal pure returns (uint256) {
587         uint256 c = a + b;
588         require(c >= a, "SafeMath: addition overflow");
589 
590         return c;
591     }
592 
593     /**
594      * @dev Returns the subtraction of two unsigned integers, reverting on
595      * overflow (when the result is negative).
596      *
597      * Counterpart to Solidity's `-` operator.
598      *
599      * Requirements:
600      * - Subtraction cannot overflow.
601      */
602     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
603         require(b <= a, "SafeMath: subtraction overflow");
604         uint256 c = a - b;
605 
606         return c;
607     }
608 
609     /**
610      * @dev Returns the multiplication of two unsigned integers, reverting on
611      * overflow.
612      *
613      * Counterpart to Solidity's `*` operator.
614      *
615      * Requirements:
616      * - Multiplication cannot overflow.
617      */
618     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
619         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
620         // benefit is lost if 'b' is also tested.
621         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
622         if (a == 0) {
623             return 0;
624         }
625 
626         uint256 c = a * b;
627         require(c / a == b, "SafeMath: multiplication overflow");
628 
629         return c;
630     }
631 
632     /**
633      * @dev Returns the integer division of two unsigned integers. Reverts on
634      * division by zero. The result is rounded towards zero.
635      *
636      * Counterpart to Solidity's `/` operator. Note: this function uses a
637      * `revert` opcode (which leaves remaining gas untouched) while Solidity
638      * uses an invalid opcode to revert (consuming all remaining gas).
639      *
640      * Requirements:
641      * - The divisor cannot be zero.
642      */
643     function div(uint256 a, uint256 b) internal pure returns (uint256) {
644         // Solidity only automatically asserts when dividing by 0
645         require(b > 0, "SafeMath: division by zero");
646         uint256 c = a / b;
647         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
648 
649         return c;
650     }
651 
652     /**
653      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
654      * Reverts when dividing by zero.
655      *
656      * Counterpart to Solidity's `%` operator. This function uses a `revert`
657      * opcode (which leaves remaining gas untouched) while Solidity uses an
658      * invalid opcode to revert (consuming all remaining gas).
659      *
660      * Requirements:
661      * - The divisor cannot be zero.
662      */
663     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
664         require(b != 0, "SafeMath: modulo by zero");
665         return a % b;
666     }
667 }
668 
669 /**
670  * @dev Collection of functions related to the address type,
671  */
672 library Address {
673     /**
674      * @dev Returns true if `account` is a contract.
675      *
676      * This test is non-exhaustive, and there may be false-negatives: during the
677      * execution of a contract's constructor, its address will be reported as
678      * not containing a contract.
679      *
680      * > It is unsafe to assume that an address for which this function returns
681      * false is an externally-owned account (EOA) and not a contract.
682      */
683     function isContract(address account) internal view returns (bool) {
684         // This method relies in extcodesize, which returns 0 for contracts in
685         // construction, since the code is only stored at the end of the
686         // constructor execution.
687 
688         uint256 size;
689         // solhint-disable-next-line no-inline-assembly
690         assembly { size := extcodesize(account) }
691         return size > 0;
692     }
693 }
694 
695 /**
696  * @title Counters
697  * @author Matt Condon (@shrugs)
698  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
699  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
700  *
701  * Include with `using Counters for Counters.Counter;`
702  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
703  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
704  * directly accessed.
705  */
706 library Counters {
707     using SafeMath for uint256;
708 
709     struct Counter {
710         // This variable should never be directly accessed by users of the library: interactions must be restricted to
711         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
712         // this feature: see https://github.com/ethereum/solidity/issues/4637
713         uint256 _value; // default: 0
714     }
715 
716     function current(Counter storage counter) internal view returns (uint256) {
717         return counter._value;
718     }
719 
720     function increment(Counter storage counter) internal {
721         counter._value += 1;
722     }
723 
724     function decrement(Counter storage counter) internal {
725         counter._value = counter._value.sub(1);
726     }
727 }
728 
729 /**
730  * @dev Implementation of the `IERC165` interface.
731  *
732  * Contracts may inherit from this and call `_registerInterface` to declare
733  * their support of an interface.
734  */
735 contract ERC165 is IERC165 {
736     /*
737      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
738      */
739     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
740 
741     /**
742      * @dev Mapping of interface ids to whether or not it's supported.
743      */
744     mapping(bytes4 => bool) private _supportedInterfaces;
745 
746     constructor () internal {
747         // Derived contracts need only register support for their own interfaces,
748         // we register support for ERC165 itself here
749         _registerInterface(_INTERFACE_ID_ERC165);
750     }
751 
752     /**
753      * @dev See `IERC165.supportsInterface`.
754      *
755      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
756      */
757     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
758         return _supportedInterfaces[interfaceId];
759     }
760 
761     /**
762      * @dev Registers the contract as an implementer of the interface defined by
763      * `interfaceId`. Support of the actual ERC165 interface is automatic and
764      * registering its interface id is not required.
765      *
766      * See `IERC165.supportsInterface`.
767      *
768      * Requirements:
769      *
770      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
771      */
772     function _registerInterface(bytes4 interfaceId) internal {
773         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
774         _supportedInterfaces[interfaceId] = true;
775     }
776 }
777 
778 /**
779  * @title ERC721 Non-Fungible Token Standard basic implementation
780  * @dev see https://eips.ethereum.org/EIPS/eip-721
781  */
782 contract ERC721 is ERC165, IERC721 {
783     using SafeMath for uint256;
784     using Address for address;
785     using Counters for Counters.Counter;
786 
787     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
788     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
789     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
790 
791     // Mapping from token ID to owner
792     mapping (uint256 => address) private _tokenOwner;
793 
794     // Mapping from token ID to approved address
795     mapping (uint256 => address) private _tokenApprovals;
796 
797     // Mapping from owner to number of owned token
798     mapping (address => Counters.Counter) private _ownedTokensCount;
799 
800     // Mapping from owner to operator approvals
801     mapping (address => mapping (address => bool)) private _operatorApprovals;
802 
803     /*
804      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
805      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
806      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
807      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
808      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
809      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
810      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
811      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
812      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
813      *
814      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
815      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
816      */
817     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
818 
819     constructor () public {
820         // register the supported interfaces to conform to ERC721 via ERC165
821         _registerInterface(_INTERFACE_ID_ERC721);
822     }
823 
824     /**
825      * @dev Gets the balance of the specified address.
826      * @param owner address to query the balance of
827      * @return uint256 representing the amount owned by the passed address
828      */
829     function balanceOf(address owner) public view returns (uint256) {
830         require(owner != address(0), "ERC721: balance query for the zero address");
831 
832         return _ownedTokensCount[owner].current();
833     }
834 
835     /**
836      * @dev Gets the owner of the specified token ID.
837      * @param tokenId uint256 ID of the token to query the owner of
838      * @return address currently marked as the owner of the given token ID
839      */
840     function ownerOf(uint256 tokenId) public view returns (address) {
841         address owner = _tokenOwner[tokenId];
842         require(owner != address(0), "ERC721: owner query for nonexistent token");
843 
844         return owner;
845     }
846 
847     /**
848      * @dev Approves another address to transfer the given token ID
849      * The zero address indicates there is no approved address.
850      * There can only be one approved address per token at a given time.
851      * Can only be called by the token owner or an approved operator.
852      * @param to address to be approved for the given token ID
853      * @param tokenId uint256 ID of the token to be approved
854      */
855     function approve(address to, uint256 tokenId) public {
856         address owner = ownerOf(tokenId);
857         require(to != owner, "ERC721: approval to current owner");
858 
859         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
860             "ERC721: approve caller is not owner nor approved for all"
861         );
862 
863         _tokenApprovals[tokenId] = to;
864         emit Approval(owner, to, tokenId);
865     }
866 
867     /**
868      * @dev Gets the approved address for a token ID, or zero if no address set
869      * Reverts if the token ID does not exist.
870      * @param tokenId uint256 ID of the token to query the approval of
871      * @return address currently approved for the given token ID
872      */
873     function getApproved(uint256 tokenId) public view returns (address) {
874         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
875 
876         return _tokenApprovals[tokenId];
877     }
878 
879     /**
880      * @dev Sets or unsets the approval of a given operator
881      * An operator is allowed to transfer all tokens of the sender on their behalf.
882      * @param to operator address to set the approval
883      * @param approved representing the status of the approval to be set
884      */
885     function setApprovalForAll(address to, bool approved) public {
886         require(to != msg.sender, "ERC721: approve to caller");
887 
888         _operatorApprovals[msg.sender][to] = approved;
889         emit ApprovalForAll(msg.sender, to, approved);
890     }
891 
892     /**
893      * @dev Tells whether an operator is approved by a given owner.
894      * @param owner owner address which you want to query the approval of
895      * @param operator operator address which you want to query the approval of
896      * @return bool whether the given operator is approved by the given owner
897      */
898     function isApprovedForAll(address owner, address operator) public view returns (bool) {
899         return _operatorApprovals[owner][operator];
900     }
901 
902     /**
903      * @dev Transfers the ownership of a given token ID to another address.
904      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
905      * Requires the msg.sender to be the owner, approved, or operator.
906      * @param from current owner of the token
907      * @param to address to receive the ownership of the given token ID
908      * @param tokenId uint256 ID of the token to be transferred
909      */
910     function transferFrom(address from, address to, uint256 tokenId) public {
911         //solhint-disable-next-line max-line-length
912         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
913 
914         _transferFrom(from, to, tokenId);
915     }
916 
917     /**
918      * @dev Safely transfers the ownership of a given token ID to another address
919      * If the target address is a contract, it must implement `onERC721Received`,
920      * which is called upon a safe transfer, and return the magic value
921      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
922      * the transfer is reverted.
923      * Requires the msg.sender to be the owner, approved, or operator
924      * @param from current owner of the token
925      * @param to address to receive the ownership of the given token ID
926      * @param tokenId uint256 ID of the token to be transferred
927      */
928     function safeTransferFrom(address from, address to, uint256 tokenId) public {
929         safeTransferFrom(from, to, tokenId, "");
930     }
931 
932     /**
933      * @dev Safely transfers the ownership of a given token ID to another address
934      * If the target address is a contract, it must implement `onERC721Received`,
935      * which is called upon a safe transfer, and return the magic value
936      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
937      * the transfer is reverted.
938      * Requires the msg.sender to be the owner, approved, or operator
939      * @param from current owner of the token
940      * @param to address to receive the ownership of the given token ID
941      * @param tokenId uint256 ID of the token to be transferred
942      * @param _data bytes data to send along with a safe transfer check
943      */
944     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
945         transferFrom(from, to, tokenId);
946         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
947     }
948 
949     /**
950      * @dev Returns whether the specified token exists.
951      * @param tokenId uint256 ID of the token to query the existence of
952      * @return bool whether the token exists
953      */
954     function _exists(uint256 tokenId) internal view returns (bool) {
955         address owner = _tokenOwner[tokenId];
956         return owner != address(0);
957     }
958 
959     /**
960      * @dev Returns whether the given spender can transfer a given token ID.
961      * @param spender address of the spender to query
962      * @param tokenId uint256 ID of the token to be transferred
963      * @return bool whether the msg.sender is approved for the given token ID,
964      * is an operator of the owner, or is the owner of the token
965      */
966     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
967         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
968         address owner = ownerOf(tokenId);
969         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
970     }
971 
972     /**
973      * @dev Internal function to mint a new token.
974      * Reverts if the given token ID already exists.
975      * @param to The address that will own the minted token
976      * @param tokenId uint256 ID of the token to be minted
977      */
978     function _mint(address to, uint256 tokenId) internal {
979         require(to != address(0), "ERC721: mint to the zero address");
980         require(!_exists(tokenId), "ERC721: token already minted");
981 
982         _tokenOwner[tokenId] = to;
983         _ownedTokensCount[to].increment();
984 
985         emit Transfer(address(0), to, tokenId);
986     }
987 
988     /**
989      * @dev Internal function to burn a specific token.
990      * Reverts if the token does not exist.
991      * Deprecated, use _burn(uint256) instead.
992      * @param owner owner of the token to burn
993      * @param tokenId uint256 ID of the token being burned
994      */
995     function _burn(address owner, uint256 tokenId) internal {
996         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
997 
998         _clearApproval(tokenId);
999 
1000         _ownedTokensCount[owner].decrement();
1001         _tokenOwner[tokenId] = address(0);
1002 
1003         emit Transfer(owner, address(0), tokenId);
1004     }
1005 
1006     /**
1007      * @dev Internal function to burn a specific token.
1008      * Reverts if the token does not exist.
1009      * @param tokenId uint256 ID of the token being burned
1010      */
1011     function _burn(uint256 tokenId) internal {
1012         _burn(ownerOf(tokenId), tokenId);
1013     }
1014 
1015     /**
1016      * @dev Internal function to transfer ownership of a given token ID to another address.
1017      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1018      * @param from current owner of the token
1019      * @param to address to receive the ownership of the given token ID
1020      * @param tokenId uint256 ID of the token to be transferred
1021      */
1022     function _transferFrom(address from, address to, uint256 tokenId) internal {
1023         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1024         require(to != address(0), "ERC721: transfer to the zero address");
1025 
1026         _clearApproval(tokenId);
1027 
1028         _ownedTokensCount[from].decrement();
1029         _ownedTokensCount[to].increment();
1030 
1031         _tokenOwner[tokenId] = to;
1032 
1033         emit Transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Internal function to invoke `onERC721Received` on a target address.
1038      * The call is not executed if the target address is not a contract.
1039      *
1040      * This function is deprecated.
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1048         internal returns (bool)
1049     {
1050         if (!to.isContract()) {
1051             return true;
1052         }
1053 
1054         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1055         return (retval == _ERC721_RECEIVED);
1056     }
1057 
1058     /**
1059      * @dev Private function to clear current approval of a given token ID.
1060      * @param tokenId uint256 ID of the token to be transferred
1061      */
1062     function _clearApproval(uint256 tokenId) private {
1063         if (_tokenApprovals[tokenId] != address(0)) {
1064             _tokenApprovals[tokenId] = address(0);
1065         }
1066     }
1067 }
1068 
1069 /**
1070  * @title ERC721 Burnable Token
1071  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1072  */
1073 contract ERC721Burnable is ERC721 {
1074     /**
1075      * @dev Burns a specific ERC721 token.
1076      * @param tokenId uint256 id of the ERC721 token to be burned.
1077      */
1078     function burn(uint256 tokenId) public {
1079         //solhint-disable-next-line max-line-length
1080         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
1081         _burn(tokenId);
1082     }
1083 }
1084 
1085 // solium-disable error-reason
1086 /**
1087  * @title ControllerRole
1088  * @dev An Controller role defined using the Open Zeppelin Role system.
1089  */
1090 contract ControllerRole {
1091 
1092     using Roles for Roles.Role;
1093 
1094     // NOTE: Commented out standard Role events to save gas.
1095     // event ControllerAdded(address indexed account);
1096     // event ControllerRemoved(address indexed account);
1097 
1098     Roles.Role private _controllers;
1099 
1100     constructor () public {
1101         _addController(msg.sender);
1102     }
1103 
1104     modifier onlyController() {
1105         require(isController(msg.sender));
1106         _;
1107     }
1108 
1109     function isController(address account) public view returns (bool) {
1110         return _controllers.has(account);
1111     }
1112 
1113     function addController(address account) public onlyController {
1114         _addController(account);
1115     }
1116 
1117     function renounceController() public {
1118         _removeController(msg.sender);
1119     }
1120 
1121     function _addController(address account) internal {
1122         _controllers.add(account);
1123         // emit ControllerAdded(account);
1124     }
1125 
1126     function _removeController(address account) internal {
1127         _controllers.remove(account);
1128         // emit ControllerRemoved(account);
1129     }
1130 
1131 }
1132 
1133 // solium-disable no-empty-blocks,error-reason
1134 /**
1135  * @title Registry
1136  * @dev An ERC721 Token see https://eips.ethereum.org/EIPS/eip-721. With
1137  * additional functions so other trusted contracts to interact with the tokens.
1138  */
1139 contract Registry is IRegistry, ControllerRole, ERC721Burnable {
1140 
1141     // Optional mapping for token URIs
1142     mapping(uint256 => string) internal _tokenURIs;
1143 
1144     string internal _prefix;
1145 
1146     // Mapping from token ID to resolver address
1147     mapping (uint256 => address) internal _tokenResolvers;
1148 
1149     // uint256(keccak256(abi.encodePacked(uint256(0x0), keccak256(abi.encodePacked("crypto")))))
1150     uint256 private constant _CRYPTO_HASH =
1151         0x0f4a10a4f46c288cea365fcf45cccf0e9d901b945b9829ccdb54c10dc3cb7a6f;
1152 
1153     modifier onlyApprovedOrOwner(uint256 tokenId) {
1154         require(_isApprovedOrOwner(msg.sender, tokenId));
1155         _;
1156     }
1157 
1158     constructor () public {
1159         _mint(address(0xdead), _CRYPTO_HASH);
1160         // register the supported interfaces to conform to ERC721 via ERC165
1161         _registerInterface(0x5b5e139f); // ERC721 Metadata Interface
1162         _tokenURIs[root()] = "crypto";
1163         emit NewURI(root(), "crypto");
1164     }
1165 
1166     /// ERC721 Metadata extension
1167 
1168     function name() external view returns (string memory) {
1169         return ".crypto";
1170     }
1171 
1172     function symbol() external view returns (string memory) {
1173         return "UD";
1174     }
1175 
1176     function tokenURI(uint256 tokenId) external view returns (string memory) {
1177         require(_exists(tokenId));
1178         return string(abi.encodePacked(_prefix, _tokenURIs[tokenId]));
1179     }
1180 
1181     function controlledSetTokenURIPrefix(string calldata prefix) external onlyController {
1182         _prefix = prefix;
1183         emit NewURIPrefix(prefix);
1184     }
1185 
1186     /// Ownership
1187 
1188     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
1189         return _isApprovedOrOwner(spender, tokenId);
1190     }
1191 
1192     /// Registry Constants
1193 
1194     function root() public pure returns (uint256) {
1195         return _CRYPTO_HASH;
1196     }
1197 
1198     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256) {
1199         return _childId(tokenId, label);
1200     }
1201 
1202     /// Minting
1203 
1204     function mintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1205         _mintChild(to, tokenId, label);
1206     }
1207 
1208     function controlledMintChild(address to, uint256 tokenId, string calldata label) external onlyController {
1209         _mintChild(to, tokenId, label);
1210     }
1211 
1212     function safeMintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1213         _safeMintChild(to, tokenId, label, "");
1214     }
1215 
1216     function safeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1217         external
1218         onlyApprovedOrOwner(tokenId)
1219     {
1220         _safeMintChild(to, tokenId, label, _data);
1221     }
1222 
1223     function controlledSafeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1224         external
1225         onlyController
1226     {
1227         _safeMintChild(to, tokenId, label, _data);
1228     }
1229 
1230     /// Transfering
1231 
1232     function setOwner(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId)  {
1233         super._transferFrom(ownerOf(tokenId), to, tokenId);
1234     }
1235 
1236     function transferFromChild(address from, address to, uint256 tokenId, string calldata label)
1237         external
1238         onlyApprovedOrOwner(tokenId)
1239     {
1240         _transferFrom(from, to, _childId(tokenId, label));
1241     }
1242 
1243     function controlledTransferFrom(address from, address to, uint256 tokenId) external onlyController {
1244         _transferFrom(from, to, tokenId);
1245     }
1246 
1247     function safeTransferFromChild(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         string memory label,
1252         bytes memory _data
1253     ) public onlyApprovedOrOwner(tokenId) {
1254         uint256 childId = _childId(tokenId, label);
1255         _transferFrom(from, to, childId);
1256         require(_checkOnERC721Received(from, to, childId, _data));
1257     }
1258 
1259     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external {
1260         safeTransferFromChild(from, to, tokenId, label, "");
1261     }
1262 
1263     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data)
1264         external
1265         onlyController
1266     {
1267         _transferFrom(from, to, tokenId);
1268         require(_checkOnERC721Received(from, to, tokenId, _data));
1269     }
1270 
1271     /// Burning
1272 
1273     function burnChild(uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1274         _burn(_childId(tokenId, label));
1275     }
1276 
1277     function controlledBurn(uint256 tokenId) external onlyController {
1278         _burn(tokenId);
1279     }
1280 
1281     /// Resolution
1282 
1283     function resolverOf(uint256 tokenId) external view returns (address) {
1284         address resolver = _tokenResolvers[tokenId];
1285         require(resolver != address(0));
1286         return resolver;
1287     }
1288 
1289     function resolveTo(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
1290         _resolveTo(to, tokenId);
1291     }
1292 
1293     function controlledResolveTo(address to, uint256 tokenId) external onlyController {
1294         _resolveTo(to, tokenId);
1295     }
1296 
1297     function sync(uint256 tokenId, uint256 updateId) external {
1298         require(_tokenResolvers[tokenId] == msg.sender);
1299         emit Sync(msg.sender, updateId, tokenId);
1300     }
1301 
1302     /// Internal
1303 
1304     function _childId(uint256 tokenId, string memory label) internal pure returns (uint256) {
1305         require(bytes(label).length != 0);
1306         return uint256(keccak256(abi.encodePacked(tokenId, keccak256(abi.encodePacked(label)))));
1307     }
1308 
1309     function _mintChild(address to, uint256 tokenId, string memory label) internal {
1310         uint256 childId = _childId(tokenId, label);
1311         _mint(to, childId);
1312 
1313         require(bytes(label).length != 0);
1314         require(_exists(childId));
1315 
1316         bytes memory domain = abi.encodePacked(label, ".", _tokenURIs[tokenId]);
1317 
1318         _tokenURIs[childId] = string(domain);
1319         emit NewURI(childId, string(domain));
1320     }
1321 
1322     function _safeMintChild(address to, uint256 tokenId, string memory label, bytes memory _data) internal {
1323         _mintChild(to, tokenId, label);
1324         require(_checkOnERC721Received(address(0), to, _childId(tokenId, label), _data));
1325     }
1326 
1327     function _transferFrom(address from, address to, uint256 tokenId) internal {
1328         super._transferFrom(from, to, tokenId);
1329         // Clear resolver (if any)
1330         if (_tokenResolvers[tokenId] != address(0x0)) {
1331             delete _tokenResolvers[tokenId];
1332         }
1333     }
1334 
1335     function _burn(uint256 tokenId) internal {
1336         super._burn(tokenId);
1337         // Clear resolver (if any)
1338         if (_tokenResolvers[tokenId] != address(0x0)) {
1339             delete _tokenResolvers[tokenId];
1340         }
1341         // Clear metadata (if any)
1342         if (bytes(_tokenURIs[tokenId]).length != 0) {
1343             delete _tokenURIs[tokenId];
1344         }
1345     }
1346 
1347     function _resolveTo(address to, uint256 tokenId) internal {
1348         require(_exists(tokenId));
1349         emit Resolve(tokenId, to);
1350         _tokenResolvers[tokenId] = to;
1351     }
1352 
1353 }
1354 
1355 /**
1356  * @title MintingController
1357  * @dev Defines the functions for distribution of Second Level Domains (SLD)s.
1358  */
1359 contract MintingController is IMintingController, MinterRole {
1360 
1361     Registry internal _registry;
1362 
1363     constructor (Registry registry) public {
1364         _registry = registry;
1365     }
1366 
1367     function registry() external view returns (address) {
1368         return address(_registry);
1369     }
1370 
1371     function mintSLD(address to, string memory label) public onlyMinter {
1372         _registry.controlledMintChild(to, _registry.root(), label);
1373     }
1374 
1375     function safeMintSLD(address to, string calldata label) external {
1376         safeMintSLD(to, label, "");
1377     }
1378 
1379     function safeMintSLD(address to, string memory label, bytes memory _data) public onlyMinter {
1380         _registry.controlledSafeMintChild(to, _registry.root(), label, _data);
1381     }
1382 
1383     function mintSLDWithResolver(address to, string memory label, address resolver) public onlyMinter {
1384         _registry.controlledMintChild(to, _registry.root(), label);
1385         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1386     }
1387 
1388     function safeMintSLDWithResolver(address to, string calldata label, address resolver) external {
1389         safeMintSLD(to, label, "");
1390         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1391     }
1392 
1393     function safeMintSLDWithResolver(address to, string calldata label, address resolver, bytes calldata _data) external {
1394         safeMintSLD(to, label, _data);
1395         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1396     }
1397 
1398 }
1399 
1400 // solium-disable error-reason
1401 contract SignatureUtil {
1402     using ECDSA for bytes32;
1403 
1404     // Mapping from owner to a nonce
1405     mapping (uint256 => uint256) internal _nonces;
1406 
1407     Registry internal _registry;
1408 
1409     constructor(Registry registry) public {
1410         _registry = registry;
1411     }
1412 
1413     function registry() external view returns (address) {
1414         return address(_registry);
1415     }
1416 
1417     /**
1418      * @dev Gets the nonce of the specified address.
1419      * @param tokenId token ID for nonce query
1420      * @return nonce of the given address
1421      */
1422     function nonceOf(uint256 tokenId) external view returns (uint256) {
1423         return _nonces[tokenId];
1424     }
1425 
1426     function _validate(bytes32 hash, uint256 tokenId, bytes memory signature) internal {
1427         uint256 nonce = _nonces[tokenId];
1428 
1429         address signer = keccak256(abi.encodePacked(hash, address(this), nonce)).toEthSignedMessageHash().recover(signature);
1430         require(
1431             signer != address(0) &&
1432             _registry.isApprovedOrOwner(
1433                 signer,
1434                 tokenId
1435             ),
1436             "INVALID_SIGNATURE"
1437         );
1438 
1439         _nonces[tokenId] += 1;
1440     }
1441 
1442 }
1443 
1444 contract IResolver {
1445     /**
1446      * @dev Reset all domain records and set new ones
1447      * @param keys New record keys
1448      * @param values New record values
1449      * @param tokenId ERC-721 token id of the domain
1450      */
1451     function reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) public;
1452 
1453     /**
1454      * @dev Set or update domain records
1455      * @param keys New record keys
1456      * @param values New record values
1457      * @param tokenId ERC-721 token id of the domain
1458      */
1459     function setMany(string[] memory keys, string[] memory values, uint256 tokenId) public;
1460 
1461     /**
1462      * @dev Function to set record.
1463      * @param key The key set the value of.
1464      * @param value The value to set key to.
1465      * @param tokenId ERC-721 token id to set.
1466      */
1467     function set(string calldata key, string calldata value, uint256 tokenId) external;
1468 
1469     /**
1470      * @dev Function to reset all existing records on a domain.
1471      * @param tokenId ERC-721 token id to set.
1472      */
1473     function reset(uint256 tokenId) external;
1474 }
1475 
1476 interface IResolverReader {
1477     /**
1478      * @dev Gets the nonce of the specified address.
1479      * @param tokenId token ID for nonce query
1480      * @return nonce of the given address
1481      */
1482     function nonceOf(uint256 tokenId) external view returns (uint256);
1483 
1484     /**
1485      * @return registry address
1486      */
1487     function registry() external view returns (address);
1488 
1489     /**
1490      * @dev Function to get record.
1491      * @param key The key to query the value of.
1492      * @param tokenId The token id to fetch.
1493      * @return The value string.
1494      */
1495     function get(string calldata key, uint256 tokenId)
1496         external
1497         view
1498         returns (string memory);
1499 
1500     /**
1501      * @dev Function to get multiple record.
1502      * @param keys The keys to query the value of.
1503      * @param tokenId The token id to fetch.
1504      * @return The values.
1505      */
1506     function getMany(string[] calldata keys, uint256 tokenId)
1507         external
1508         view
1509         returns (string[] memory);
1510 
1511     /**
1512      * @dev Function get value by provied key hash. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1513      * @param keyHash The key to query the value of.
1514      * @param tokenId The token id to set.
1515      * @return Key and value.
1516      */
1517     function getByHash(uint256 keyHash, uint256 tokenId)
1518         external
1519         view
1520         returns (string memory key, string memory value);
1521 
1522     /**
1523      * @dev Function get values by provied key hashes. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1524      * @param keyHashes The key to query the value of.
1525      * @param tokenId The token id to set.
1526      * @return Keys and values.
1527      */
1528     function getManyByHash(uint256[] calldata keyHashes, uint256 tokenId)
1529         external
1530         view
1531         returns (string[] memory keys, string[] memory values);
1532 }
1533 
1534 // solium-disable error-reason
1535 contract Resolver is IResolverReader, SignatureUtil, IResolver {
1536 
1537     event Set(uint256 indexed tokenId, string indexed keyIndex, string indexed valueIndex, string key, string value);
1538     event NewKey(uint256 indexed tokenId, string indexed keyIndex, string key);
1539     event ResetRecords(uint256 indexed tokenId);
1540 
1541     // Mapping from token ID to preset id to key to value
1542     mapping (uint256 => mapping (uint256 =>  mapping (string => string))) internal _records;
1543 
1544     // Mapping from token ID to current preset id
1545     mapping (uint256 => uint256) _tokenPresets;
1546 
1547     // All keys that were set
1548     mapping (uint256 => string) _hashedKeys;
1549 
1550     MintingController internal _mintingController;
1551 
1552     constructor(Registry registry, MintingController mintingController) public SignatureUtil(registry) {
1553         require(address(registry) == mintingController.registry());
1554         _mintingController = mintingController;
1555     }
1556 
1557     /**
1558      * @dev Throws if called when not the resolver.
1559      */
1560     modifier whenResolver(uint256 tokenId) {
1561         require(address(this) == _registry.resolverOf(tokenId), "RESOLVER_DETACHED_FROM_DOMAIN");
1562         _;
1563     }
1564 
1565     modifier whenApprovedOrOwner(uint256 tokenId) {
1566         require(_registry.isApprovedOrOwner(msg.sender, tokenId), "SENDER_IS_NOT_APPROVED_OR_OWNER");
1567         _;
1568     }
1569 
1570     function reset(uint256 tokenId) external whenApprovedOrOwner(tokenId) {
1571         _setPreset(now, tokenId);
1572     }
1573 
1574     function resetFor(uint256 tokenId, bytes calldata signature) external {
1575         _validate(keccak256(abi.encodeWithSelector(this.reset.selector, tokenId)), tokenId, signature);
1576         _setPreset(now, tokenId);
1577     }
1578 
1579     /**
1580      * @dev Function to get record.
1581      * @param key The key to query the value of.
1582      * @param tokenId The token id to fetch.
1583      * @return The value string.
1584      */
1585     function get(string memory key, uint256 tokenId) public view whenResolver(tokenId) returns (string memory) {
1586         return _records[tokenId][_tokenPresets[tokenId]][key];
1587     }
1588 
1589     /**
1590      * @dev Function to get key by provided hash. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1591      * @param keyHash The key to query the value of.
1592      * @return The key string.
1593      */
1594     function hashToKey(uint256 keyHash) public view returns (string memory) {
1595         return _hashedKeys[keyHash];
1596     }
1597 
1598     /**
1599      * @dev Function to get keys by provided key hashes. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1600      * @param hashes The key to query the value of.
1601      * @return Keys
1602      */
1603     function hashesToKeys(uint256[] memory hashes) public view returns (string[] memory) {
1604         uint256 keyCount = hashes.length;
1605         string[] memory values = new string[](keyCount);
1606         for (uint256 i = 0; i < keyCount; i++) {
1607             values[i] = hashToKey(hashes[i]);
1608         }
1609 
1610         return values;
1611     }
1612 
1613     /**
1614      * @dev Function get value by provied key hash. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1615      * @param keyHash The key to query the value of.
1616      * @param tokenId The token id to set.
1617      * @return Key and value.
1618      */
1619     function getByHash(uint256 keyHash, uint256 tokenId) public view whenResolver(tokenId) returns (string memory key, string memory value) {
1620         key = hashToKey(keyHash);
1621         value = get(key, tokenId);
1622     }
1623 
1624     /**
1625      * @dev Function get values by provied key hashes. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1626      * @param keyHashes The key to query the value of.
1627      * @param tokenId The token id to set.
1628      * @return Keys and values.
1629      */
1630     function getManyByHash(
1631         uint256[] memory keyHashes,
1632         uint256 tokenId
1633     ) public view whenResolver(tokenId) returns (string[] memory keys, string[] memory values) {
1634         uint256 keyCount = keyHashes.length;
1635         keys = new string[](keyCount);
1636         values = new string[](keyCount);
1637         for (uint256 i = 0; i < keyCount; i++) {
1638             (keys[i], values[i]) = getByHash(keyHashes[i], tokenId);
1639         }
1640     }
1641 
1642     function preconfigure(
1643         string[] memory keys,
1644         string[] memory values,
1645         uint256 tokenId
1646     ) public {
1647         require(_mintingController.isMinter(msg.sender), "SENDER_IS_NOT_MINTER");
1648         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1649     }
1650 
1651     /**
1652      * @dev Function to set record.
1653      * @param key The key set the value of.
1654      * @param value The value to set key to.
1655      * @param tokenId The token id to set.
1656      */
1657     function set(string calldata key, string calldata value, uint256 tokenId) external whenApprovedOrOwner(tokenId) {
1658         _set(_tokenPresets[tokenId], key, value, tokenId);
1659     }
1660 
1661     /**
1662      * @dev Function to set record on behalf of an address.
1663      * @param key The key set the value of.
1664      * @param value The value to set key to.
1665      * @param tokenId The token id to set.
1666      * @param signature The signature to verify the transaction with.
1667      */
1668     function setFor(
1669         string calldata key,
1670         string calldata value,
1671         uint256 tokenId,
1672         bytes calldata signature
1673     ) external {
1674         _validate(keccak256(abi.encodeWithSelector(this.set.selector, key, value, tokenId)), tokenId, signature);
1675         _set(_tokenPresets[tokenId], key, value, tokenId);
1676     }
1677 
1678     /**
1679      * @dev Function to get multiple record.
1680      * @param keys The keys to query the value of.
1681      * @param tokenId The token id to fetch.
1682      * @return The values.
1683      */
1684     function getMany(string[] calldata keys, uint256 tokenId) external view whenResolver(tokenId) returns (string[] memory) {
1685         uint256 keyCount = keys.length;
1686         string[] memory values = new string[](keyCount);
1687         uint256 preset = _tokenPresets[tokenId];
1688         for (uint256 i = 0; i < keyCount; i++) {
1689             values[i] = _records[tokenId][preset][keys[i]];
1690         }
1691         return values;
1692     }
1693 
1694     function setMany(
1695         string[] memory keys,
1696         string[] memory values,
1697         uint256 tokenId
1698     ) public whenApprovedOrOwner(tokenId) {
1699         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1700     }
1701 
1702     /**
1703      * @dev Function to set record on behalf of an address.
1704      * @param keys The keys set the values of.
1705      * @param values The values to set keys to.
1706      * @param tokenId The token id to set.
1707      * @param signature The signature to verify the transaction with.
1708      */
1709     function setManyFor(
1710         string[] memory keys,
1711         string[] memory values,
1712         uint256 tokenId,
1713         bytes memory signature
1714     ) public {
1715         _validate(keccak256(abi.encodeWithSelector(this.setMany.selector, keys, values, tokenId)), tokenId, signature);
1716         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1717     }
1718 
1719      /**
1720      * @dev Function to reset all domain records and set new ones.
1721      * @param keys records keys.
1722      * @param values records values.
1723      * @param tokenId domain token id.
1724      */
1725     function reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) public whenApprovedOrOwner(tokenId) {
1726         _reconfigure(keys, values, tokenId);
1727     }
1728 
1729     /**
1730      * @dev Delegated version of reconfigure() function.
1731      * @param keys records keys.
1732      * @param values records values.
1733      * @param tokenId domain token id.
1734      * @param signature user signature.
1735      */
1736     function reconfigureFor(
1737         string[] memory keys,
1738         string[] memory values,
1739         uint256 tokenId,
1740         bytes memory signature
1741     ) public {
1742         _validate(keccak256(abi.encodeWithSelector(this.reconfigure.selector, keys, values, tokenId)), tokenId, signature);
1743         _reconfigure(keys, values, tokenId);
1744     }
1745 
1746     // reset records
1747     function _setPreset(uint256 presetId, uint256 tokenId) internal {
1748         _tokenPresets[tokenId] = presetId;
1749         _registry.sync(tokenId, 0); // notify registry that domain records were reset
1750         emit ResetRecords(tokenId);
1751     }
1752 
1753     /**
1754      * @dev Internal function to to set record. As opposed to set, this imposes no restrictions on msg.sender.
1755      * @param preset preset to set key/values on
1756      * @param key key of record to be set
1757      * @param value value of record to be set
1758      * @param tokenId uint256 ID of the token
1759      */
1760     function _set(uint256 preset, string memory key, string memory value, uint256 tokenId) internal {
1761         uint256 keyHash = uint256(keccak256(bytes(key)));
1762         bool isNewKey = bytes(_records[tokenId][preset][key]).length == 0;
1763         _registry.sync(tokenId, keyHash);
1764         _records[tokenId][preset][key] = value;
1765 
1766         if (bytes(_hashedKeys[keyHash]).length == 0) {
1767             _hashedKeys[keyHash] = key;
1768         }
1769 
1770         if (isNewKey) {
1771             emit NewKey(tokenId, key, key);
1772         }
1773         emit Set(tokenId, key, value, key, value);
1774     }
1775 
1776     /**
1777      * @dev Internal function to to set multiple records. As opposed to setMany, this imposes
1778      * no restrictions on msg.sender.
1779      * @param preset preset to set key/values on
1780      * @param keys keys of record to be set
1781      * @param values values of record to be set
1782      * @param tokenId uint256 ID of the token
1783      */
1784     function _setMany(uint256 preset, string[] memory keys, string[] memory values, uint256 tokenId) internal {
1785         uint256 keyCount = keys.length;
1786         for (uint256 i = 0; i < keyCount; i++) {
1787             _set(preset, keys[i], values[i], tokenId);
1788         }
1789     }
1790 
1791     /**
1792      * @dev Internal function to reset all domain records and set new ones.
1793      * @param keys records keys.
1794      * @param values records values.
1795      * @param tokenId domain token id.
1796      */
1797     function _reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) internal {
1798         _setPreset(now, tokenId);
1799         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1800     }
1801 
1802 }
1803 
1804 /**
1805  * @title WhitelistedMinter
1806  * @dev Defines the functions for distribution of Second Level Domains (SLD)s.
1807  */
1808 contract WhitelistedMinter is IMintingController, BulkWhitelistedRole {
1809     using ECDSA for bytes32;
1810 
1811     event Relayed(address indexed sender, address indexed signer, bytes4 indexed funcSig, bytes32 dataHash);
1812 
1813     string public constant NAME = 'Unstoppable Whitelisted Minter';
1814     string public constant VERSION = '0.3.0';
1815 
1816     MintingController internal _mintingController;
1817     Resolver internal _resolver;
1818     Registry internal _registry;
1819 
1820     /*
1821      * bytes4(keccak256('mintSLD(address,string)')) == 0x4c0b0ed2
1822      */
1823     bytes4 private constant _SIG_MINT = 0x4c0b0ed2;
1824 
1825     /*
1826      * bytes4(keccak256('mintSLDToDefaultResolver(address,string,string[],string[])')) == 0x3d7989fe
1827      */
1828     bytes4 private constant _SIG_MINT_DEF_RESOLVER = 0x3d7989fe;
1829 
1830     /*
1831      * bytes4(keccak256('mintSLDToResolver(address,string,string[],string[],address)')) == 0xaceb4764
1832      */
1833     bytes4 private constant _SIG_MINT_RESOLVER = 0xaceb4764;
1834 
1835     /*
1836      * bytes4(keccak256('safeMintSLD(address,string)')) == 0xb2da2979
1837      */
1838     bytes4 private constant _SIG_SAFE_MINT = 0xb2da2979;
1839 
1840     /*
1841      * bytes4(keccak256('safeMintSLD(address,string,bytes)')) == 0xbe362e2e
1842      */
1843     bytes4 private constant _SIG_SAFE_MINT_DATA = 0xbe362e2e;
1844 
1845     /*
1846      * bytes4(keccak256('safeMintSLDToDefaultResolver(address,string,string[],string[])')) == 0x61050ffd
1847      */
1848     bytes4 private constant _SIG_SAFE_MINT_DEF_RESOLVER = 0x61050ffd;
1849 
1850     /*
1851      * bytes4(keccak256('safeMintSLDToDefaultResolver(address,string,string[],string[],bytes)')) == 0x4b18abea
1852      */
1853     bytes4 private constant _SIG_SAFE_MINT_DEF_RESOLVER_DATA = 0x4b18abea;
1854 
1855     /*
1856      * bytes4(keccak256('safeMintSLDToResolver(address,string,string[],string[],address)')) == 0x4b44c01a
1857      */
1858     bytes4 private constant _SIG_SAFE_MINT_RESOLVER = 0x4b44c01a;
1859 
1860     /*
1861      * bytes4(keccak256('safeMintSLDToResolver(address,string,string[],string[],bytes,address)')) == 0x898851f8
1862      */
1863     bytes4 private constant _SIG_SAFE_MINT_RESOLVER_DATA = 0x898851f8;
1864 
1865     constructor(MintingController mintingController) public {
1866         _mintingController = mintingController;
1867         _registry = Registry(mintingController.registry());
1868         _addWhitelisted(address(this));
1869     }
1870 
1871     function renounceMinter() external onlyWhitelistAdmin {
1872         _mintingController.renounceMinter();
1873     }
1874 
1875     /**
1876      * Renounce whitelisted account with funds' forwarding
1877      */
1878     function closeWhitelisted(address payable receiver)
1879         external
1880         payable
1881         onlyWhitelisted
1882     {
1883         require(receiver != address(0x0), "WhitelistedMinter: RECEIVER_IS_EMPTY");
1884 
1885         renounceWhitelisted();
1886         receiver.transfer(msg.value);
1887     }
1888 
1889     /**
1890      * Replace whitelisted account by new account with funds' forwarding
1891      */
1892     function rotateWhitelisted(address payable receiver)
1893         external
1894         payable
1895         onlyWhitelisted
1896     {
1897         require(receiver != address(0x0), "WhitelistedMinter: RECEIVER_IS_EMPTY");
1898 
1899         _addWhitelisted(receiver);
1900         renounceWhitelisted();
1901         receiver.transfer(msg.value);
1902     }
1903 
1904     function mintSLD(address to, string calldata label)
1905         external
1906         onlyWhitelisted
1907     {
1908         _mintingController.mintSLD(to, label);
1909     }
1910 
1911     function safeMintSLD(address to, string calldata label)
1912         external
1913         onlyWhitelisted
1914     {
1915         _mintingController.safeMintSLD(to, label);
1916     }
1917 
1918     function safeMintSLD(
1919         address to,
1920         string calldata label,
1921         bytes calldata _data
1922     ) external onlyWhitelisted {
1923         _mintingController.safeMintSLD(to, label, _data);
1924     }
1925 
1926     function mintSLDToDefaultResolver(
1927         address to,
1928         string memory label,
1929         string[] memory keys,
1930         string[] memory values
1931     ) public onlyWhitelisted {
1932         mintSLDToResolver(to, label, keys, values, address(_resolver));
1933     }
1934 
1935     function mintSLDToResolver(
1936         address to,
1937         string memory label,
1938         string[] memory keys,
1939         string[] memory values,
1940         address resolver
1941     ) public onlyWhitelisted {
1942         _mintingController.mintSLDWithResolver(to, label, resolver);
1943         preconfigureResolver(label, keys, values, resolver);
1944     }
1945 
1946     function safeMintSLDToDefaultResolver(
1947         address to,
1948         string memory label,
1949         string[] memory keys,
1950         string[] memory values
1951     ) public onlyWhitelisted {
1952         safeMintSLDToResolver(to, label, keys, values, address(_resolver));
1953     }
1954 
1955     function safeMintSLDToResolver(
1956         address to,
1957         string memory label,
1958         string[] memory keys,
1959         string[] memory values,
1960         address resolver
1961     ) public onlyWhitelisted {
1962         _mintingController.safeMintSLDWithResolver(to, label, resolver);
1963         preconfigureResolver(label, keys, values, resolver);
1964     }
1965 
1966     function safeMintSLDToDefaultResolver(
1967         address to,
1968         string memory label,
1969         string[] memory keys,
1970         string[] memory values,
1971         bytes memory _data
1972     ) public onlyWhitelisted {
1973         safeMintSLDToResolver(to, label, keys, values, _data, address(_resolver));
1974     }
1975 
1976     function safeMintSLDToResolver(
1977         address to,
1978         string memory label,
1979         string[] memory keys,
1980         string[] memory values,
1981         bytes memory _data,
1982         address resolver
1983     ) public onlyWhitelisted {
1984         _mintingController.safeMintSLDWithResolver(to, label, resolver, _data);
1985         preconfigureResolver(label, keys, values, resolver);
1986     }
1987 
1988     function setDefaultResolver(address resolver) external onlyWhitelistAdmin {
1989         _resolver = Resolver(resolver);
1990     }
1991 
1992     function getDefaultResolver() external view returns (address) {
1993         return address(_resolver);
1994     }
1995 
1996     /**
1997      * Relay allows execute transaction on behalf of whitelisted minter.
1998      * The function verify signature of call data parameter before execution.
1999      * It allows anybody send transaction on-chain when minter has provided proper parameters.
2000      * The function allows to relaying calls of fixed functions. The restriction defined in function `verifyCall`
2001      */
2002     function relay(bytes calldata data, bytes calldata signature) external returns(bytes memory) {
2003         bytes32 dataHash = keccak256(data);
2004         address signer = verifySigner(dataHash, signature);
2005         bytes memory _data = data;
2006         bytes4 funcSig = verifyCall(_data);
2007 
2008         /* solium-disable-next-line security/no-low-level-calls */
2009         (bool success, bytes memory result) = address(this).call(data);
2010         if (success == false) {
2011             /* solium-disable-next-line security/no-inline-assembly */
2012             assembly {
2013                 let ptr := mload(0x40)
2014                 let size := returndatasize
2015                 returndatacopy(ptr, 0, size)
2016                 revert(ptr, size)
2017             }
2018         }
2019 
2020         emit Relayed(msg.sender, signer, funcSig, dataHash);
2021         return result;
2022     }
2023 
2024     function preconfigureResolver(
2025         string memory label,
2026         string[] memory keys,
2027         string[] memory values,
2028         address resolver
2029     ) private {
2030         if(keys.length == 0) {
2031             return;
2032         }
2033 
2034         Resolver(resolver).preconfigure(keys, values, _registry.childIdOf(_registry.root(), label));
2035     }
2036 
2037     function verifySigner(bytes32 data, bytes memory signature) private view returns(address signer) {
2038         signer = keccak256(abi.encodePacked(data, address(this)))
2039             .toEthSignedMessageHash()
2040             .recover(signature);
2041         require(signer != address(0), 'WhitelistedMinter: SIGNATURE_IS_INVALID');
2042         require(isWhitelisted(signer), 'WhitelistedMinter: SIGNER_IS_NOT_WHITELISTED');
2043     }
2044 
2045     function verifyCall(bytes memory data) private pure returns(bytes4 sig) {
2046         /* solium-disable-next-line security/no-inline-assembly */
2047         assembly {
2048             sig := mload(add(data, add(0x20, 0)))
2049         }
2050 
2051         bool isSupported = sig == _SIG_MINT ||
2052             sig == _SIG_MINT_DEF_RESOLVER ||
2053             sig == _SIG_MINT_RESOLVER ||
2054             sig == _SIG_SAFE_MINT ||
2055             sig == _SIG_SAFE_MINT_DATA ||
2056             sig == _SIG_SAFE_MINT_DEF_RESOLVER ||
2057             sig == _SIG_SAFE_MINT_DEF_RESOLVER_DATA ||
2058             sig == _SIG_SAFE_MINT_RESOLVER ||
2059             sig == _SIG_SAFE_MINT_RESOLVER_DATA;
2060 
2061         require(isSupported, 'WhitelistedMinter: UNSUPPORTED_CALL');
2062     }
2063 }