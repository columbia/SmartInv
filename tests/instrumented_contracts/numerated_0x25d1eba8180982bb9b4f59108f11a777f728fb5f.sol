1 pragma solidity 0.8.7;
2 abstract contract Context {
3     function _msgSender() internal view virtual returns (address) {
4         return msg.sender;
5     }
6 
7     function _msgData() internal view virtual returns (bytes calldata) {
8         return msg.data;
9     }
10 }
11 abstract contract Ownable is Context {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev Initializes the contract setting the deployer as the initial owner.
18      */
19     constructor() {
20         _setOwner(_msgSender());
21     }
22 
23     /**
24      * @dev Returns the address of the current owner.
25      */
26     function owner() public view virtual returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35         _;
36     }
37 
38     /**
39      * @dev Leaves the contract without owner. It will not be possible to call
40      * `onlyOwner` functions anymore. Can only be called by the current owner.
41      *
42      * NOTE: Renouncing ownership will leave the contract without an owner,
43      * thereby removing any functionality that is only available to the owner.
44      */
45     function renounceOwnership() public virtual onlyOwner {
46         _setOwner(address(0));
47     }
48 
49     /**
50      * @dev Transfers ownership of the contract to a new account (`newOwner`).
51      * Can only be called by the current owner.
52      */
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         _setOwner(newOwner);
56     }
57 
58     function _setOwner(address newOwner) private {
59         address oldOwner = _owner;
60         _owner = newOwner;
61         emit OwnershipTransferred(oldOwner, newOwner);
62     }
63 }
64 interface IERC165 {
65     /**
66      * @dev Returns true if this contract implements the interface defined by
67      * `interfaceId`. See the corresponding
68      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
69      * to learn more about how these ids are created.
70      *
71      * This function call must use less than 30 000 gas.
72      */
73     function supportsInterface(bytes4 interfaceId) external view returns (bool);
74 }
75 abstract contract ERC165 is IERC165 {
76     /**
77      * @dev See {IERC165-supportsInterface}.
78      */
79     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
80         return interfaceId == type(IERC165).interfaceId;
81     }
82 }
83 interface IAccessControl {
84     /**
85      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
86      *
87      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
88      * {RoleAdminChanged} not being emitted signaling this.
89      *
90      * _Available since v3.1._
91      */
92     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
93 
94     /**
95      * @dev Emitted when `account` is granted `role`.
96      *
97      * `sender` is the account that originated the contract call, an admin role
98      * bearer except when using {AccessControl-_setupRole}.
99      */
100     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
101 
102     /**
103      * @dev Emitted when `account` is revoked `role`.
104      *
105      * `sender` is the account that originated the contract call:
106      *   - if using `revokeRole`, it is the admin role bearer
107      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
108      */
109     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
110 
111     /**
112      * @dev Returns `true` if `account` has been granted `role`.
113      */
114     function hasRole(bytes32 role, address account) external view returns (bool);
115 
116     /**
117      * @dev Returns the admin role that controls `role`. See {grantRole} and
118      * {revokeRole}.
119      *
120      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
121      */
122     function getRoleAdmin(bytes32 role) external view returns (bytes32);
123 
124     /**
125      * @dev Grants `role` to `account`.
126      *
127      * If `account` had not been already granted `role`, emits a {RoleGranted}
128      * event.
129      *
130      * Requirements:
131      *
132      * - the caller must have ``role``'s admin role.
133      */
134     function grantRole(bytes32 role, address account) external;
135 
136     /**
137      * @dev Revokes `role` from `account`.
138      *
139      * If `account` had been granted `role`, emits a {RoleRevoked} event.
140      *
141      * Requirements:
142      *
143      * - the caller must have ``role``'s admin role.
144      */
145     function revokeRole(bytes32 role, address account) external;
146 
147     /**
148      * @dev Revokes `role` from the calling account.
149      *
150      * Roles are often managed via {grantRole} and {revokeRole}: this function's
151      * purpose is to provide a mechanism for accounts to lose their privileges
152      * if they are compromised (such as when a trusted device is misplaced).
153      *
154      * If the calling account had been granted `role`, emits a {RoleRevoked}
155      * event.
156      *
157      * Requirements:
158      *
159      * - the caller must be `account`.
160      */
161     function renounceRole(bytes32 role, address account) external;
162 }
163 library Strings {
164     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
168      */
169     function toString(uint256 value) internal pure returns (string memory) {
170         // Inspired by OraclizeAPI's implementation - MIT licence
171         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
172 
173         if (value == 0) {
174             return "0";
175         }
176         uint256 temp = value;
177         uint256 digits;
178         while (temp != 0) {
179             digits++;
180             temp /= 10;
181         }
182         bytes memory buffer = new bytes(digits);
183         while (value != 0) {
184             digits -= 1;
185             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
186             value /= 10;
187         }
188         return string(buffer);
189     }
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
193      */
194     function toHexString(uint256 value) internal pure returns (string memory) {
195         if (value == 0) {
196             return "0x00";
197         }
198         uint256 temp = value;
199         uint256 length = 0;
200         while (temp != 0) {
201             length++;
202             temp >>= 8;
203         }
204         return toHexString(value, length);
205     }
206 
207     /**
208      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
209      */
210     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
211         bytes memory buffer = new bytes(2 * length + 2);
212         buffer[0] = "0";
213         buffer[1] = "x";
214         for (uint256 i = 2 * length + 1; i > 1; --i) {
215             buffer[i] = _HEX_SYMBOLS[value & 0xf];
216             value >>= 4;
217         }
218         require(value == 0, "Strings: hex length insufficient");
219         return string(buffer);
220     }
221 }
222 abstract contract AccessControl is Context, IAccessControl, ERC165 {
223     struct RoleData {
224         mapping(address => bool) members;
225         bytes32 adminRole;
226     }
227 
228     mapping(bytes32 => RoleData) private _roles;
229 
230     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
231 
232     /**
233      * @dev Modifier that checks that an account has a specific role. Reverts
234      * with a standardized message including the required role.
235      *
236      * The format of the revert reason is given by the following regular expression:
237      *
238      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
239      *
240      * _Available since v4.1._
241      */
242     modifier onlyRole(bytes32 role) {
243         _checkRole(role, _msgSender());
244         _;
245     }
246 
247     /**
248      * @dev See {IERC165-supportsInterface}.
249      */
250     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
251         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
252     }
253 
254     /**
255      * @dev Returns `true` if `account` has been granted `role`.
256      */
257     function hasRole(bytes32 role, address account) public view override returns (bool) {
258         return _roles[role].members[account];
259     }
260 
261     /**
262      * @dev Revert with a standard message if `account` is missing `role`.
263      *
264      * The format of the revert reason is given by the following regular expression:
265      *
266      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
267      */
268     function _checkRole(bytes32 role, address account) internal view {
269         if (!hasRole(role, account)) {
270             revert(
271                 string(
272                     abi.encodePacked(
273                         "AccessControl: account ",
274                         Strings.toHexString(uint160(account), 20),
275                         " is missing role ",
276                         Strings.toHexString(uint256(role), 32)
277                     )
278                 )
279             );
280         }
281     }
282 
283     /**
284      * @dev Returns the admin role that controls `role`. See {grantRole} and
285      * {revokeRole}.
286      *
287      * To change a role's admin, use {_setRoleAdmin}.
288      */
289     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
290         return _roles[role].adminRole;
291     }
292 
293     /**
294      * @dev Grants `role` to `account`.
295      *
296      * If `account` had not been already granted `role`, emits a {RoleGranted}
297      * event.
298      *
299      * Requirements:
300      *
301      * - the caller must have ``role``'s admin role.
302      */
303     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
304         _grantRole(role, account);
305     }
306 
307     /**
308      * @dev Revokes `role` from `account`.
309      *
310      * If `account` had been granted `role`, emits a {RoleRevoked} event.
311      *
312      * Requirements:
313      *
314      * - the caller must have ``role``'s admin role.
315      */
316     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
317         _revokeRole(role, account);
318     }
319 
320     /**
321      * @dev Revokes `role` from the calling account.
322      *
323      * Roles are often managed via {grantRole} and {revokeRole}: this function's
324      * purpose is to provide a mechanism for accounts to lose their privileges
325      * if they are compromised (such as when a trusted device is misplaced).
326      *
327      * If the calling account had been granted `role`, emits a {RoleRevoked}
328      * event.
329      *
330      * Requirements:
331      *
332      * - the caller must be `account`.
333      */
334     function renounceRole(bytes32 role, address account) public virtual override {
335         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
336 
337         _revokeRole(role, account);
338     }
339 
340     /**
341      * @dev Grants `role` to `account`.
342      *
343      * If `account` had not been already granted `role`, emits a {RoleGranted}
344      * event. Note that unlike {grantRole}, this function doesn't perform any
345      * checks on the calling account.
346      *
347      * [WARNING]
348      * ====
349      * This function should only be called from the constructor when setting
350      * up the initial roles for the system.
351      *
352      * Using this function in any other way is effectively circumventing the admin
353      * system imposed by {AccessControl}.
354      * ====
355      */
356     function _setupRole(bytes32 role, address account) internal virtual {
357         _grantRole(role, account);
358     }
359 
360     /**
361      * @dev Sets `adminRole` as ``role``'s admin role.
362      *
363      * Emits a {RoleAdminChanged} event.
364      */
365     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
366         bytes32 previousAdminRole = getRoleAdmin(role);
367         _roles[role].adminRole = adminRole;
368         emit RoleAdminChanged(role, previousAdminRole, adminRole);
369     }
370 
371     function _grantRole(bytes32 role, address account) private {
372         if (!hasRole(role, account)) {
373             _roles[role].members[account] = true;
374             emit RoleGranted(role, account, _msgSender());
375         }
376     }
377 
378     function _revokeRole(bytes32 role, address account) private {
379         if (hasRole(role, account)) {
380             _roles[role].members[account] = false;
381             emit RoleRevoked(role, account, _msgSender());
382         }
383     }
384 }
385 abstract contract ReentrancyGuard {
386     // Booleans are more expensive than uint256 or any type that takes up a full
387     // word because each write operation emits an extra SLOAD to first read the
388     // slot's contents, replace the bits taken up by the boolean, and then write
389     // back. This is the compiler's defense against contract upgrades and
390     // pointer aliasing, and it cannot be disabled.
391 
392     // The values being non-zero value makes deployment a bit more expensive,
393     // but in exchange the refund on every call to nonReentrant will be lower in
394     // amount. Since refunds are capped to a percentage of the total
395     // transaction's gas, it is best to keep them low in cases like this one, to
396     // increase the likelihood of the full refund coming into effect.
397     uint256 private constant _NOT_ENTERED = 1;
398     uint256 private constant _ENTERED = 2;
399 
400     uint256 private _status;
401 
402     constructor() {
403         _status = _NOT_ENTERED;
404     }
405 
406     /**
407      * @dev Prevents a contract from calling itself, directly or indirectly.
408      * Calling a `nonReentrant` function from another `nonReentrant`
409      * function is not supported. It is possible to prevent this from happening
410      * by making the `nonReentrant` function external, and make it call a
411      * `private` function that does the actual work.
412      */
413     modifier nonReentrant() {
414         // On the first call to nonReentrant, _notEntered will be true
415         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
416 
417         // Any calls to nonReentrant after this point will fail
418         _status = _ENTERED;
419 
420         _;
421 
422         // By storing the original value once again, a refund is triggered (see
423         // https://eips.ethereum.org/EIPS/eip-2200)
424         _status = _NOT_ENTERED;
425     }
426 }
427 interface IAuctionHouse {
428     struct Auction {
429         // ID for the ERC721 token
430         uint256 tokenId;
431         // Address for the ERC721 contract
432         address tokenContract;                
433         // The current highest bid amount
434         uint256 amount;
435         // The length of time to run the auction for, after the first bid was made
436         uint256 duration;
437         // The time of the first bid
438         uint256 firstBidTime;
439         // The minimum price of the first bid
440         uint256 reservePrice;
441         // The address that should receive the funds once the NFT is sold.
442         address tokenOwner;
443         // The address of the current highest bid
444         address payable bidder;        
445         // The address of the ERC-20 currency to run the auction with.
446         // If set to 0x0, the auction will be run in ETH
447         address auctionCurrency;
448         // The address of recipient of the sale commission
449     }
450 
451     struct Royalty {
452         //The address of the beneficiary who will be receiving royalties for each sale
453         address payable beneficiary;
454         //The percentage of the sale the commission address receives
455         //If percentage is set to 0, the full amount will be sent
456         uint256 royaltyPercentage;
457     }
458 
459     event AuctionCreated(
460         uint256 indexed auctionId,
461         uint256 indexed tokenId,
462         address indexed tokenContract,
463         uint256 duration,
464         uint256 reservePrice,
465         address tokenOwner,        
466         address auctionCurrency
467     );
468     
469     event AuctionReservePriceUpdated(
470         uint256 indexed auctionId,
471         uint256 indexed tokenId,
472         address indexed tokenContract,
473         uint256 reservePrice
474     );
475 
476     event RoyaltySet(
477         address indexed tokenContract,
478         address indexed newBeneficiary,
479         uint256 indexed royaltyPercentage
480     );
481 
482     event AuctionBid(
483         uint256 indexed auctionId,
484         uint256 indexed tokenId,
485         address indexed tokenContract,
486         address sender,
487         uint256 value,
488         uint256 bidTime,
489         bool firstBid,
490         bool extended
491     );
492 
493     event AuctionDurationExtended(
494         uint256 indexed auctionId,
495         uint256 indexed tokenId,
496         address indexed tokenContract,
497         uint256 duration
498     );
499 
500     event AuctionEnded(
501         uint256 indexed auctionId,
502         uint256 indexed tokenId,
503         address indexed tokenContract,
504         address tokenOwner,        
505         address winner,        
506         uint256 amount,                
507         uint256 endTime,
508         address auctionCurrency
509     );
510 
511     event AuctionWithRoyaltiesEnded(
512         uint256 indexed auctionId,
513         uint256 indexed tokenId,
514         address indexed tokenContract,
515         address tokenOwner,        
516         address winner,
517         uint256 amount,
518         address beneficiaryAddress,
519         uint256 royaltyAmount,  
520         uint256 endTime,      
521         address auctionCurrency
522     );
523 
524     event AuctionCanceled(
525         uint256 indexed auctionId,
526         uint256 indexed tokenId,
527         address indexed tokenContract,
528         address tokenOwner
529     );
530 
531     function createAuction(
532         uint256 tokenId,
533         address tokenContract,
534         uint256 duration,
535         uint256 reservePrice,        
536         address auctionCurrency
537     ) external returns (uint256);
538 
539     function setAuctionReservePrice(uint256 auctionId, uint256 reservePrice) external;
540 
541     function setRoyalty(
542         address tokenContract, 
543         address payable beneficiaryAddress, 
544         uint256 royaltyPercentage
545     ) external;
546 
547     function createBid(uint256 auctionId, uint256 amount) external payable;
548 
549     function endAuction(uint256 auctionId) external;
550 
551     function cancelAuction(uint256 auctionId) external;
552 
553     function setPublicAuctionsEnabled(bool status) external;
554 
555     function whitelistAccount(address sellerOrTokenContract) external;
556 
557     function removeWhitelistedAccount(address sellerOrTokenContract) external;
558 
559     function isWhitelisted(address sellerOrTekenContract) external view returns(bool);
560         
561     function addAuctioneer(address who) external;
562 
563     function removeAuctioneer(address who) external;
564 
565     function isAuctioneer(address who) external view returns(bool);
566 
567 
568 }
569 interface IWETH {
570     function deposit() external payable;
571     function withdraw(uint wad) external;
572     function transfer(address to, uint256 value) external returns (bool);
573 }
574 interface IERC20 {
575     /**
576      * @dev Returns the amount of tokens in existence.
577      */
578     function totalSupply() external view returns (uint256);
579 
580     /**
581      * @dev Returns the amount of tokens owned by `account`.
582      */
583     function balanceOf(address account) external view returns (uint256);
584 
585     /**
586      * @dev Moves `amount` tokens from the caller's account to `recipient`.
587      *
588      * Returns a boolean value indicating whether the operation succeeded.
589      *
590      * Emits a {Transfer} event.
591      */
592     function transfer(address recipient, uint256 amount) external returns (bool);
593 
594     /**
595      * @dev Returns the remaining number of tokens that `spender` will be
596      * allowed to spend on behalf of `owner` through {transferFrom}. This is
597      * zero by default.
598      *
599      * This value changes when {approve} or {transferFrom} are called.
600      */
601     function allowance(address owner, address spender) external view returns (uint256);
602 
603     /**
604      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
605      *
606      * Returns a boolean value indicating whether the operation succeeded.
607      *
608      * IMPORTANT: Beware that changing an allowance with this method brings the risk
609      * that someone may use both the old and the new allowance by unfortunate
610      * transaction ordering. One possible solution to mitigate this race
611      * condition is to first reduce the spender's allowance to 0 and set the
612      * desired value afterwards:
613      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
614      *
615      * Emits an {Approval} event.
616      */
617     function approve(address spender, uint256 amount) external returns (bool);
618 
619     /**
620      * @dev Moves `amount` tokens from `sender` to `recipient` using the
621      * allowance mechanism. `amount` is then deducted from the caller's
622      * allowance.
623      *
624      * Returns a boolean value indicating whether the operation succeeded.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transferFrom(
629         address sender,
630         address recipient,
631         uint256 amount
632     ) external returns (bool);
633 
634     /**
635      * @dev Emitted when `value` tokens are moved from one account (`from`) to
636      * another (`to`).
637      *
638      * Note that `value` may be zero.
639      */
640     event Transfer(address indexed from, address indexed to, uint256 value);
641 
642     /**
643      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
644      * a call to {approve}. `value` is the new allowance.
645      */
646     event Approval(address indexed owner, address indexed spender, uint256 value);
647 }
648 library Address {
649     /**
650      * @dev Returns true if `account` is a contract.
651      *
652      * [IMPORTANT]
653      * ====
654      * It is unsafe to assume that an address for which this function returns
655      * false is an externally-owned account (EOA) and not a contract.
656      *
657      * Among others, `isContract` will return false for the following
658      * types of addresses:
659      *
660      *  - an externally-owned account
661      *  - a contract in construction
662      *  - an address where a contract will be created
663      *  - an address where a contract lived, but was destroyed
664      * ====
665      */
666     function isContract(address account) internal view returns (bool) {
667         // This method relies on extcodesize, which returns 0 for contracts in
668         // construction, since the code is only stored at the end of the
669         // constructor execution.
670 
671         uint256 size;
672         assembly {
673             size := extcodesize(account)
674         }
675         return size > 0;
676     }
677 
678     /**
679      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
680      * `recipient`, forwarding all available gas and reverting on errors.
681      *
682      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
683      * of certain opcodes, possibly making contracts go over the 2300 gas limit
684      * imposed by `transfer`, making them unable to receive funds via
685      * `transfer`. {sendValue} removes this limitation.
686      *
687      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
688      *
689      * IMPORTANT: because control is transferred to `recipient`, care must be
690      * taken to not create reentrancy vulnerabilities. Consider using
691      * {ReentrancyGuard} or the
692      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
693      */
694     function sendValue(address payable recipient, uint256 amount) internal {
695         require(address(this).balance >= amount, "Address: insufficient balance");
696 
697         (bool success, ) = recipient.call{value: amount}("");
698         require(success, "Address: unable to send value, recipient may have reverted");
699     }
700 
701     /**
702      * @dev Performs a Solidity function call using a low level `call`. A
703      * plain `call` is an unsafe replacement for a function call: use this
704      * function instead.
705      *
706      * If `target` reverts with a revert reason, it is bubbled up by this
707      * function (like regular Solidity function calls).
708      *
709      * Returns the raw returned data. To convert to the expected return value,
710      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
711      *
712      * Requirements:
713      *
714      * - `target` must be a contract.
715      * - calling `target` with `data` must not revert.
716      *
717      * _Available since v3.1._
718      */
719     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
720         return functionCall(target, data, "Address: low-level call failed");
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
725      * `errorMessage` as a fallback revert reason when `target` reverts.
726      *
727      * _Available since v3.1._
728      */
729     function functionCall(
730         address target,
731         bytes memory data,
732         string memory errorMessage
733     ) internal returns (bytes memory) {
734         return functionCallWithValue(target, data, 0, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but also transferring `value` wei to `target`.
740      *
741      * Requirements:
742      *
743      * - the calling contract must have an ETH balance of at least `value`.
744      * - the called Solidity function must be `payable`.
745      *
746      * _Available since v3.1._
747      */
748     function functionCallWithValue(
749         address target,
750         bytes memory data,
751         uint256 value
752     ) internal returns (bytes memory) {
753         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
758      * with `errorMessage` as a fallback revert reason when `target` reverts.
759      *
760      * _Available since v3.1._
761      */
762     function functionCallWithValue(
763         address target,
764         bytes memory data,
765         uint256 value,
766         string memory errorMessage
767     ) internal returns (bytes memory) {
768         require(address(this).balance >= value, "Address: insufficient balance for call");
769         require(isContract(target), "Address: call to non-contract");
770 
771         (bool success, bytes memory returndata) = target.call{value: value}(data);
772         return verifyCallResult(success, returndata, errorMessage);
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
777      * but performing a static call.
778      *
779      * _Available since v3.3._
780      */
781     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
782         return functionStaticCall(target, data, "Address: low-level static call failed");
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
787      * but performing a static call.
788      *
789      * _Available since v3.3._
790      */
791     function functionStaticCall(
792         address target,
793         bytes memory data,
794         string memory errorMessage
795     ) internal view returns (bytes memory) {
796         require(isContract(target), "Address: static call to non-contract");
797 
798         (bool success, bytes memory returndata) = target.staticcall(data);
799         return verifyCallResult(success, returndata, errorMessage);
800     }
801 
802     /**
803      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
804      * but performing a delegate call.
805      *
806      * _Available since v3.4._
807      */
808     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
809         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
814      * but performing a delegate call.
815      *
816      * _Available since v3.4._
817      */
818     function functionDelegateCall(
819         address target,
820         bytes memory data,
821         string memory errorMessage
822     ) internal returns (bytes memory) {
823         require(isContract(target), "Address: delegate call to non-contract");
824 
825         (bool success, bytes memory returndata) = target.delegatecall(data);
826         return verifyCallResult(success, returndata, errorMessage);
827     }
828 
829     /**
830      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
831      * revert reason using the provided one.
832      *
833      * _Available since v4.3._
834      */
835     function verifyCallResult(
836         bool success,
837         bytes memory returndata,
838         string memory errorMessage
839     ) internal pure returns (bytes memory) {
840         if (success) {
841             return returndata;
842         } else {
843             // Look for revert reason and bubble it up if present
844             if (returndata.length > 0) {
845                 // The easiest way to bubble the revert reason is using memory via assembly
846 
847                 assembly {
848                     let returndata_size := mload(returndata)
849                     revert(add(32, returndata), returndata_size)
850                 }
851             } else {
852                 revert(errorMessage);
853             }
854         }
855     }
856 }
857 library Counters {
858     struct Counter {
859         // This variable should never be directly accessed by users of the library: interactions must be restricted to
860         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
861         // this feature: see https://github.com/ethereum/solidity/issues/4637
862         uint256 _value; // default: 0
863     }
864 
865     function current(Counter storage counter) internal view returns (uint256) {
866         return counter._value;
867     }
868 
869     function increment(Counter storage counter) internal {
870         unchecked {
871             counter._value += 1;
872         }
873     }
874 
875     function decrement(Counter storage counter) internal {
876         uint256 value = counter._value;
877         require(value > 0, "Counter: decrement overflow");
878         unchecked {
879             counter._value = value - 1;
880         }
881     }
882 
883     function reset(Counter storage counter) internal {
884         counter._value = 0;
885     }
886 }
887 library SafeERC20 {
888     using Address for address;
889 
890     function safeTransfer(
891         IERC20 token,
892         address to,
893         uint256 value
894     ) internal {
895         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
896     }
897 
898     function safeTransferFrom(
899         IERC20 token,
900         address from,
901         address to,
902         uint256 value
903     ) internal {
904         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
905     }
906 
907     /**
908      * @dev Deprecated. This function has issues similar to the ones found in
909      * {IERC20-approve}, and its usage is discouraged.
910      *
911      * Whenever possible, use {safeIncreaseAllowance} and
912      * {safeDecreaseAllowance} instead.
913      */
914     function safeApprove(
915         IERC20 token,
916         address spender,
917         uint256 value
918     ) internal {
919         // safeApprove should only be called when setting an initial allowance,
920         // or when resetting it to zero. To increase and decrease it, use
921         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
922         require(
923             (value == 0) || (token.allowance(address(this), spender) == 0),
924             "SafeERC20: approve from non-zero to non-zero allowance"
925         );
926         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
927     }
928 
929     function safeIncreaseAllowance(
930         IERC20 token,
931         address spender,
932         uint256 value
933     ) internal {
934         uint256 newAllowance = token.allowance(address(this), spender) + value;
935         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
936     }
937 
938     function safeDecreaseAllowance(
939         IERC20 token,
940         address spender,
941         uint256 value
942     ) internal {
943         unchecked {
944             uint256 oldAllowance = token.allowance(address(this), spender);
945             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
946             uint256 newAllowance = oldAllowance - value;
947             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
948         }
949     }
950 
951     /**
952      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
953      * on the return value: the return value is optional (but if data is returned, it must not be false).
954      * @param token The token targeted by the call.
955      * @param data The call data (encoded using abi.encode or one of its variants).
956      */
957     function _callOptionalReturn(IERC20 token, bytes memory data) private {
958         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
959         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
960         // the target address contains contract code and also asserts for success in the low-level call.
961 
962         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
963         if (returndata.length > 0) {
964             // Return data is optional
965             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
966         }
967     }
968 }
969 library SafeMath {
970     /**
971      * @dev Returns the addition of two unsigned integers, with an overflow flag.
972      *
973      * _Available since v3.4._
974      */
975     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
976         unchecked {
977             uint256 c = a + b;
978             if (c < a) return (false, 0);
979             return (true, c);
980         }
981     }
982 
983     /**
984      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
985      *
986      * _Available since v3.4._
987      */
988     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
989         unchecked {
990             if (b > a) return (false, 0);
991             return (true, a - b);
992         }
993     }
994 
995     /**
996      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
997      *
998      * _Available since v3.4._
999      */
1000     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1001         unchecked {
1002             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1003             // benefit is lost if 'b' is also tested.
1004             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1005             if (a == 0) return (true, 0);
1006             uint256 c = a * b;
1007             if (c / a != b) return (false, 0);
1008             return (true, c);
1009         }
1010     }
1011 
1012     /**
1013      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1014      *
1015      * _Available since v3.4._
1016      */
1017     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1018         unchecked {
1019             if (b == 0) return (false, 0);
1020             return (true, a / b);
1021         }
1022     }
1023 
1024     /**
1025      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1026      *
1027      * _Available since v3.4._
1028      */
1029     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1030         unchecked {
1031             if (b == 0) return (false, 0);
1032             return (true, a % b);
1033         }
1034     }
1035 
1036     /**
1037      * @dev Returns the addition of two unsigned integers, reverting on
1038      * overflow.
1039      *
1040      * Counterpart to Solidity's `+` operator.
1041      *
1042      * Requirements:
1043      *
1044      * - Addition cannot overflow.
1045      */
1046     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1047         return a + b;
1048     }
1049 
1050     /**
1051      * @dev Returns the subtraction of two unsigned integers, reverting on
1052      * overflow (when the result is negative).
1053      *
1054      * Counterpart to Solidity's `-` operator.
1055      *
1056      * Requirements:
1057      *
1058      * - Subtraction cannot overflow.
1059      */
1060     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1061         return a - b;
1062     }
1063 
1064     /**
1065      * @dev Returns the multiplication of two unsigned integers, reverting on
1066      * overflow.
1067      *
1068      * Counterpart to Solidity's `*` operator.
1069      *
1070      * Requirements:
1071      *
1072      * - Multiplication cannot overflow.
1073      */
1074     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1075         return a * b;
1076     }
1077 
1078     /**
1079      * @dev Returns the integer division of two unsigned integers, reverting on
1080      * division by zero. The result is rounded towards zero.
1081      *
1082      * Counterpart to Solidity's `/` operator.
1083      *
1084      * Requirements:
1085      *
1086      * - The divisor cannot be zero.
1087      */
1088     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1089         return a / b;
1090     }
1091 
1092     /**
1093      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1094      * reverting when dividing by zero.
1095      *
1096      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1097      * opcode (which leaves remaining gas untouched) while Solidity uses an
1098      * invalid opcode to revert (consuming all remaining gas).
1099      *
1100      * Requirements:
1101      *
1102      * - The divisor cannot be zero.
1103      */
1104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1105         return a % b;
1106     }
1107 
1108     /**
1109      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1110      * overflow (when the result is negative).
1111      *
1112      * CAUTION: This function is deprecated because it requires allocating memory for the error
1113      * message unnecessarily. For custom revert reasons use {trySub}.
1114      *
1115      * Counterpart to Solidity's `-` operator.
1116      *
1117      * Requirements:
1118      *
1119      * - Subtraction cannot overflow.
1120      */
1121     function sub(
1122         uint256 a,
1123         uint256 b,
1124         string memory errorMessage
1125     ) internal pure returns (uint256) {
1126         unchecked {
1127             require(b <= a, errorMessage);
1128             return a - b;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1134      * division by zero. The result is rounded towards zero.
1135      *
1136      * Counterpart to Solidity's `/` operator. Note: this function uses a
1137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1138      * uses an invalid opcode to revert (consuming all remaining gas).
1139      *
1140      * Requirements:
1141      *
1142      * - The divisor cannot be zero.
1143      */
1144     function div(
1145         uint256 a,
1146         uint256 b,
1147         string memory errorMessage
1148     ) internal pure returns (uint256) {
1149         unchecked {
1150             require(b > 0, errorMessage);
1151             return a / b;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1157      * reverting with custom message when dividing by zero.
1158      *
1159      * CAUTION: This function is deprecated because it requires allocating memory for the error
1160      * message unnecessarily. For custom revert reasons use {tryMod}.
1161      *
1162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1163      * opcode (which leaves remaining gas untouched) while Solidity uses an
1164      * invalid opcode to revert (consuming all remaining gas).
1165      *
1166      * Requirements:
1167      *
1168      * - The divisor cannot be zero.
1169      */
1170     function mod(
1171         uint256 a,
1172         uint256 b,
1173         string memory errorMessage
1174     ) internal pure returns (uint256) {
1175         unchecked {
1176             require(b > 0, errorMessage);
1177             return a % b;
1178         }
1179     }
1180 }
1181 interface IERC721 is IERC165 {
1182     /**
1183      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1184      */
1185     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1186 
1187     /**
1188      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1189      */
1190     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1191 
1192     /**
1193      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1194      */
1195     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1196 
1197     /**
1198      * @dev Returns the number of tokens in ``owner``'s account.
1199      */
1200     function balanceOf(address owner) external view returns (uint256 balance);
1201 
1202     /**
1203      * @dev Returns the owner of the `tokenId` token.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      */
1209     function ownerOf(uint256 tokenId) external view returns (address owner);
1210 
1211     /**
1212      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1213      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1214      *
1215      * Requirements:
1216      *
1217      * - `from` cannot be the zero address.
1218      * - `to` cannot be the zero address.
1219      * - `tokenId` token must exist and be owned by `from`.
1220      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) external;
1230 
1231     /**
1232      * @dev Transfers `tokenId` token from `from` to `to`.
1233      *
1234      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must be owned by `from`.
1241      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function transferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) external;
1250 
1251     /**
1252      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1253      * The approval is cleared when the token is transferred.
1254      *
1255      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1256      *
1257      * Requirements:
1258      *
1259      * - The caller must own the token or be an approved operator.
1260      * - `tokenId` must exist.
1261      *
1262      * Emits an {Approval} event.
1263      */
1264     function approve(address to, uint256 tokenId) external;
1265 
1266     /**
1267      * @dev Returns the account approved for `tokenId` token.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      */
1273     function getApproved(uint256 tokenId) external view returns (address operator);
1274 
1275     /**
1276      * @dev Approve or remove `operator` as an operator for the caller.
1277      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1278      *
1279      * Requirements:
1280      *
1281      * - The `operator` cannot be the caller.
1282      *
1283      * Emits an {ApprovalForAll} event.
1284      */
1285     function setApprovalForAll(address operator, bool _approved) external;
1286 
1287     /**
1288      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1289      *
1290      * See {setApprovalForAll}
1291      */
1292     function isApprovedForAll(address owner, address operator) external view returns (bool);
1293 
1294     /**
1295      * @dev Safely transfers `tokenId` token from `from` to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `from` cannot be the zero address.
1300      * - `to` cannot be the zero address.
1301      * - `tokenId` token must exist and be owned by `from`.
1302      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1303      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function safeTransferFrom(
1308         address from,
1309         address to,
1310         uint256 tokenId,
1311         bytes calldata data
1312     ) external;
1313 }
1314 contract AuctionHouse is IAuctionHouse, ReentrancyGuard, AccessControl, Ownable {  
1315     using SafeMath for uint256;
1316     using SafeERC20 for IERC20;
1317     using Counters for Counters.Counter;
1318 
1319     // The minimum amount of time left in an auction after a new bid is created
1320     uint256 public timeBuffer;
1321 
1322     // The minimum percentage difference between the last bid amount and the current bid.
1323     uint8 public minBidIncrementPercentage;
1324 
1325     // The address of the WETH contract, so that any ETH transferred can be handled as an ERC-20
1326     address public wethAddress;
1327 
1328     // A mapping of all of the auctions currently running.
1329     mapping(uint256 => IAuctionHouse.Auction) public auctions;
1330 
1331     // A mapping of token contracts to royalty objects.
1332     mapping(address => IAuctionHouse.Royalty) public royaltyRegistry;
1333 
1334     // A mapping of all token contract addresses that ChainSaw allows on auction-house. These addresses
1335     // could belong to token contracts or individual sellers.
1336     mapping(address => bool) public whitelistedAccounts;
1337 
1338     // 721 interface id
1339     bytes4 constant interfaceId = 0x80ac58cd; 
1340     
1341     // Counter for incrementing auctionId
1342     Counters.Counter private _auctionIdTracker;
1343 
1344     // Tracks whether auction house is allowing non-owners to create auctions,
1345     // e.g. in the case of secondary sales.
1346     bool public publicAuctionsEnabled;
1347     
1348     // The role that has permissions to create and cancel auctions
1349     bytes32 public constant AUCTIONEER = keccak256("AUCTIONEER");
1350 
1351     /**
1352      * @notice Require that caller is authorized auctioneer
1353      */
1354     modifier onlyAdmin() {
1355         require(
1356             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
1357             "Call must be made by administrator"
1358         );
1359         _;
1360     }
1361 
1362     /**
1363      * @notice Require that caller is authorized auctioneer
1364      */
1365     modifier onlyAuctioneer() {
1366         require(
1367             hasRole(AUCTIONEER, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
1368             "Call must be made by authorized auctioneer"
1369         );
1370         _;
1371     }
1372 
1373     /**
1374      * @notice Require that the specified auction exists
1375      */
1376     modifier auctionExists(uint256 auctionId) {
1377         require(_exists(auctionId), "Auction doesn't exist");
1378         _;
1379     }
1380 
1381     /**
1382      * @notice constructor 
1383      */
1384     constructor(address _weth, address[] memory auctioneers) {
1385         wethAddress = _weth;
1386         timeBuffer = 15 * 60; // extend 15 minutes after every bid made in last 15 minutes
1387         minBidIncrementPercentage = 5; // 5%
1388         publicAuctionsEnabled = false;
1389         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1390 
1391         for (uint i = 0; i < auctioneers.length; i++) {
1392             _addAuctioneer(auctioneers[i]);
1393         } 
1394     }
1395 
1396     /**
1397      * @notice Create an auction.
1398      * @dev Store the auction details in the auctions mapping and emit an AuctionCreated event.     
1399      */
1400     function createAuction(
1401         uint256 tokenId,
1402         address tokenContract,
1403         uint256 duration,
1404         uint256 reservePrice,                
1405         address auctionCurrency
1406     ) public override nonReentrant returns (uint256) {        
1407         require(
1408             IERC165(tokenContract).supportsInterface(interfaceId),
1409             "tokenContract does not support ERC721 interface"
1410         );  
1411         
1412         address tokenOwner = IERC721(tokenContract).ownerOf(tokenId);
1413         require(
1414           tokenOwner == msg.sender,
1415           "Must be owner of NFT"
1416         );
1417         require(
1418             _isAuthorizedAction(tokenOwner, tokenContract),
1419             "Call must be made by authorized seller, token contract or auctioneer"
1420         );
1421     
1422         uint256 auctionId = _auctionIdTracker.current();
1423 
1424         auctions[auctionId] = Auction({
1425             tokenId: tokenId,
1426             tokenContract: tokenContract,            
1427             amount: 0,
1428             duration: duration,
1429             firstBidTime: 0,
1430             reservePrice: reservePrice,            
1431             tokenOwner: tokenOwner,
1432             bidder: payable(0),            
1433             auctionCurrency: auctionCurrency
1434         });
1435 
1436         IERC721(tokenContract).transferFrom(tokenOwner, address(this), tokenId);
1437 
1438         _auctionIdTracker.increment();
1439 
1440         emit AuctionCreated(auctionId, tokenId, tokenContract, duration, reservePrice, tokenOwner, auctionCurrency);
1441  
1442         return auctionId;
1443     }
1444 
1445     /**
1446      * @notice sets auction reserve price if auction has not already started     
1447      */
1448     function setAuctionReservePrice(uint256 auctionId, uint256 reservePrice) 
1449         external 
1450         override 
1451         auctionExists(auctionId)            
1452     {       
1453         require(
1454           _isAuctioneer(msg.sender) || auctions[auctionId].tokenOwner == msg.sender,
1455           "Must be auctioneer or owner of NFT"
1456         );
1457         require(
1458             _isAuthorizedAction(
1459                 auctions[auctionId].tokenOwner, 
1460                 auctions[auctionId].tokenContract
1461             ),
1462             "Call must be made by authorized seller, token contract or auctioneer"
1463         );
1464         require(auctions[auctionId].firstBidTime == 0, "Auction has already started");        
1465         
1466         auctions[auctionId].reservePrice = reservePrice;
1467 
1468         emit AuctionReservePriceUpdated(auctionId, auctions[auctionId].tokenId, auctions[auctionId].tokenContract, reservePrice);
1469     }
1470 
1471     /**
1472      * @notice Set royalty information for a given token contract.
1473      * @dev Store the royal details in the royaltyRegistry mapping and emit an royaltySet event. 
1474      * Royalty can only be modified before any auction for tokenContract has started    
1475      */
1476     function setRoyalty(address tokenContract, address payable beneficiary, uint royaltyPercentage) 
1477         external 
1478         override 
1479         onlyAuctioneer                 
1480     {                
1481         royaltyRegistry[tokenContract] = Royalty({
1482             beneficiary: beneficiary,
1483             royaltyPercentage: royaltyPercentage
1484         });
1485         emit RoyaltySet(tokenContract, beneficiary, royaltyPercentage);
1486     }
1487 
1488     /**
1489      * @notice Create a bid on a token, with a given amount.
1490      * @dev If provided a valid bid, transfers the provided amount to this contract.
1491      * If the auction is run in native ETH, the ETH is wrapped so it can be identically to other
1492      * auction currencies in this contract.
1493      */
1494     function createBid(uint256 auctionId, uint256 amount)
1495         external
1496         override
1497         payable
1498         auctionExists(auctionId)
1499         nonReentrant
1500     {
1501         address payable lastBidder = auctions[auctionId].bidder;        
1502         require(
1503             auctions[auctionId].firstBidTime == 0 ||
1504             block.timestamp <
1505             auctions[auctionId].firstBidTime.add(auctions[auctionId].duration),
1506             "Auction expired"
1507         );
1508         require(
1509             amount >= auctions[auctionId].reservePrice,
1510                 "Must send at least reservePrice"
1511         );
1512         require(
1513             amount >= auctions[auctionId].amount.add(
1514                 auctions[auctionId].amount.mul(minBidIncrementPercentage).div(100)
1515             ),
1516             "Must send more than last bid by minBidIncrementPercentage amount"
1517         );
1518 
1519         // If this is the first valid bid, we should set the starting time now.
1520         // If it's not, then we should refund the last bidder
1521         if(auctions[auctionId].firstBidTime == 0) {
1522             auctions[auctionId].firstBidTime = block.timestamp;
1523         } else if(lastBidder != address(0)) {
1524             _handleOutgoingBid(lastBidder, auctions[auctionId].amount, auctions[auctionId].auctionCurrency);
1525         }
1526 
1527         _handleIncomingBid(amount, auctions[auctionId].auctionCurrency);
1528 
1529         auctions[auctionId].amount = amount;
1530         auctions[auctionId].bidder = payable(msg.sender);
1531 
1532 
1533         bool extended = false;
1534         // at this point we know that the timestamp is less than start + duration (since the auction would be over, otherwise)
1535         // we want to know by how much the timestamp is less than start + duration
1536         // if the difference is less than the timeBuffer, increase the duration by the timeBuffer
1537         if (
1538             auctions[auctionId].firstBidTime.add(auctions[auctionId].duration).sub(
1539                 block.timestamp
1540             ) < timeBuffer
1541         ) {
1542             // Playing code golf for gas optimization:
1543             // uint256 expectedEnd = auctions[auctionId].firstBidTime.add(auctions[auctionId].duration);
1544             // uint256 timeRemaining = expectedEnd.sub(block.timestamp);
1545             // uint256 timeToAdd = timeBuffer.sub(timeRemaining);
1546             // uint256 newDuration = auctions[auctionId].duration.add(timeToAdd);
1547             uint256 oldDuration = auctions[auctionId].duration;
1548             auctions[auctionId].duration =
1549                 oldDuration.add(timeBuffer.sub(auctions[auctionId].firstBidTime.add(oldDuration).sub(block.timestamp)));
1550             extended = true;
1551         }
1552 
1553         emit AuctionBid(
1554             auctionId,
1555             auctions[auctionId].tokenId,
1556             auctions[auctionId].tokenContract,
1557             msg.sender,
1558             amount,
1559             block.timestamp,
1560             lastBidder == address(0), // firstBid boolean
1561             extended
1562         );
1563 
1564         if (extended) {
1565             emit AuctionDurationExtended(
1566                 auctionId,
1567                 auctions[auctionId].tokenId,
1568                 auctions[auctionId].tokenContract,
1569                 auctions[auctionId].duration
1570             );
1571         }
1572     }
1573 
1574     /**
1575      * @notice End an auction and pay out the respective parties.
1576      * @dev If for some reason the auction cannot be finalized (invalid token recipient, for example),
1577      * The auction is reset and the NFT is transferred back to the auction creator.
1578      */
1579     function endAuction(uint256 auctionId) external override auctionExists(auctionId) nonReentrant {
1580         require(
1581             uint256(auctions[auctionId].firstBidTime) != 0,
1582             "Auction hasn't begun"
1583         );
1584         require(
1585             block.timestamp >=
1586             auctions[auctionId].firstBidTime.add(auctions[auctionId].duration),
1587             "Auction hasn't completed"
1588         );
1589 
1590         address currency = auctions[auctionId].auctionCurrency == address(0) ? wethAddress : auctions[auctionId].auctionCurrency;
1591 
1592         uint256 tokenOwnerProfit = auctions[auctionId].amount;
1593         address tokenContract = auctions[auctionId].tokenContract;
1594  
1595         // Otherwise, transfer the token to the winner and pay out the participants below
1596         try IERC721(auctions[auctionId].tokenContract).safeTransferFrom(address(this), auctions[auctionId].bidder, auctions[auctionId].tokenId) {} catch {
1597             _handleOutgoingBid(auctions[auctionId].bidder, auctions[auctionId].amount, auctions[auctionId].auctionCurrency);
1598             _cancelAuction(auctionId);
1599             return;
1600         }
1601 
1602         if (
1603             royaltyRegistry[tokenContract].beneficiary != address(0) && 
1604             royaltyRegistry[tokenContract].beneficiary != auctions[auctionId].tokenOwner &&
1605             royaltyRegistry[tokenContract].royaltyPercentage > 0
1606         ){
1607             uint256 royaltyAmount = _generateRoyaltyAmount(auctionId, auctions[auctionId].tokenContract);
1608             uint256 amountRemaining = tokenOwnerProfit.sub(royaltyAmount);
1609             
1610 
1611             _handleOutgoingBid(royaltyRegistry[tokenContract].beneficiary, royaltyAmount, auctions[auctionId].auctionCurrency);
1612             _handleOutgoingBid(auctions[auctionId].tokenOwner, amountRemaining, auctions[auctionId].auctionCurrency);
1613 
1614 
1615             emit AuctionWithRoyaltiesEnded(
1616                 auctionId,
1617                 auctions[auctionId].tokenId,
1618                 auctions[auctionId].tokenContract,
1619                 auctions[auctionId].tokenOwner,            
1620                 auctions[auctionId].bidder,
1621                 amountRemaining,
1622                 royaltyRegistry[tokenContract].beneficiary,
1623                 royaltyAmount,            
1624                 block.timestamp,
1625                 currency
1626             );
1627 
1628 
1629         } else {
1630             _handleOutgoingBid(auctions[auctionId].tokenOwner, tokenOwnerProfit, auctions[auctionId].auctionCurrency);
1631 
1632             emit AuctionEnded(
1633                 auctionId,
1634                 auctions[auctionId].tokenId,
1635                 auctions[auctionId].tokenContract,
1636                 auctions[auctionId].tokenOwner,            
1637                 auctions[auctionId].bidder,                
1638                 tokenOwnerProfit,  
1639                 block.timestamp,                                          
1640                 currency
1641             );
1642         }
1643         
1644         delete auctions[auctionId];
1645     }
1646     
1647     /**
1648      * @notice Cancel an auction.
1649      * @dev Transfers the NFT back to the auction creator and emits an AuctionCanceled event
1650      */
1651     function cancelAuction(uint256 auctionId) 
1652         external 
1653         override 
1654         nonReentrant 
1655         auctionExists(auctionId)        
1656     {        
1657         require(
1658           _isAuctioneer(msg.sender) || auctions[auctionId].tokenOwner == msg.sender,
1659           "Must be auctioneer or owner of NFT"
1660         );
1661         require(
1662             _isAuthorizedAction(
1663                 auctions[auctionId].tokenOwner, 
1664                 auctions[auctionId].tokenContract
1665             ),
1666             "Call must be made by authorized seller, token contract or auctioneer"
1667         );
1668         require(
1669             uint256(auctions[auctionId].firstBidTime) == 0,
1670             "Can't cancel an auction once it's begun"
1671         );
1672         _cancelAuction(auctionId);
1673     }
1674 
1675     /**
1676      * @notice enable or disable auctions to be created on the basis of whitelist
1677      */
1678     function setPublicAuctionsEnabled(bool status) external override onlyAdmin {
1679         publicAuctionsEnabled = status;
1680     }
1681 
1682     /**
1683       * @notice add account representing token owner (seller) or token contract to the whitelist
1684      */
1685     function whitelistAccount(address sellerOrTokenContract) external override onlyAuctioneer {
1686         _whitelistAccount(sellerOrTokenContract);
1687     }
1688 
1689     function removeWhitelistedAccount(address sellerOrTokenContract) external override onlyAuctioneer {
1690         delete whitelistedAccounts[sellerOrTokenContract];
1691     }
1692 
1693     function isWhitelisted(address sellerOrTekenContract) external view override returns(bool){
1694         return _isWhitelisted(sellerOrTekenContract);
1695     }
1696     
1697     function addAuctioneer(address who) external override onlyAdmin {
1698         _addAuctioneer(who);
1699     }
1700 
1701     function removeAuctioneer(address who) external override onlyAdmin {
1702         revokeRole(AUCTIONEER, who);
1703     }
1704 
1705     function isAuctioneer(address who) external view override returns(bool) {
1706         return _isAuctioneer(who);
1707     }
1708     
1709     function _isAuctioneer(address who) internal view returns(bool) {
1710         return hasRole(AUCTIONEER, who) || hasRole(DEFAULT_ADMIN_ROLE, who);
1711     }
1712 
1713     /**
1714      * @dev Given an amount and a currency, transfer the currency to this contract.
1715      * If the currency is ETH (0x0), attempt to wrap the amount as WETH
1716      */
1717     function _handleIncomingBid(uint256 amount, address currency) internal {
1718         // If this is an ETH bid, ensure they sent enough and convert it to WETH under the hood
1719         if(currency == address(0)) {
1720             require(msg.value == amount, "Sent ETH Value does not match specified bid amount");
1721             IWETH(wethAddress).deposit{value: amount}();
1722         } else {
1723             // We must check the balance that was actually transferred to the auction,
1724             // as some tokens impose a transfer fee and would not actually transfer the
1725             // full amount to the market, resulting in potentally locked funds
1726             IERC20 token = IERC20(currency);
1727             uint256 beforeBalance = token.balanceOf(address(this));
1728             token.safeTransferFrom(msg.sender, address(this), amount);
1729             uint256 afterBalance = token.balanceOf(address(this));
1730             require(beforeBalance.add(amount) == afterBalance, "Token transfer call did not transfer expected amount");
1731         }
1732     }
1733 
1734     function _handleOutgoingBid(address to, uint256 amount, address currency) internal {
1735         // If the auction is in ETH, unwrap it from its underlying WETH and try to send it to the recipient.
1736         if(currency == address(0)) {
1737             IWETH(wethAddress).withdraw(amount);
1738 
1739             // If the ETH transfer fails (sigh), rewrap the ETH and try send it as WETH.
1740             if(!_safeTransferETH(to, amount)) {
1741                 IWETH(wethAddress).deposit{value: amount}();
1742                 IERC20(wethAddress).safeTransfer(to, amount);
1743             }
1744         } else {
1745             IERC20(currency).safeTransfer(to, amount);
1746         }
1747     }
1748 
1749     function _generateRoyaltyAmount(uint256 auctionId, address tokenContract) internal view returns (uint256) {
1750         return auctions[auctionId].amount.div(100).mul(royaltyRegistry[tokenContract].royaltyPercentage);
1751     }
1752 
1753     function _safeTransferETH(address to, uint256 value) internal returns (bool) {
1754         (bool success, ) = to.call{value: value}(new bytes(0));
1755         return success;
1756     }
1757 
1758     function _cancelAuction(uint256 auctionId) internal {
1759         address tokenOwner = auctions[auctionId].tokenOwner;
1760         IERC721(auctions[auctionId].tokenContract).safeTransferFrom(address(this), tokenOwner, auctions[auctionId].tokenId);
1761 
1762         emit AuctionCanceled(auctionId, auctions[auctionId].tokenId, auctions[auctionId].tokenContract, tokenOwner);
1763         delete auctions[auctionId];
1764     }
1765 
1766     function _exists(uint256 auctionId) internal view returns(bool) {
1767         return auctions[auctionId].tokenOwner != address(0);
1768     }
1769 
1770     /**
1771      * @dev returns true if 
1772      */
1773     function _isAuthorizedAction(address seller, address tokenContract) internal view returns(bool) {
1774         if (hasRole(DEFAULT_ADMIN_ROLE, seller) || hasRole(AUCTIONEER, seller)) {
1775             return true;
1776         }
1777 
1778         if (publicAuctionsEnabled) {
1779             return _isWhitelisted(seller) || _isWhitelisted(tokenContract);
1780         }
1781 
1782         return false;
1783     }
1784 
1785     function _addAuctioneer(address who) internal {        
1786         _setupRole(AUCTIONEER, who);
1787     }
1788 
1789     function _isWhitelisted(address sellerOrTokenContract) internal view returns(bool) {
1790         return whitelistedAccounts[sellerOrTokenContract];
1791     }
1792 
1793     function _whitelistAccount(address sellerOrTokenContract) internal {        
1794         whitelistedAccounts[sellerOrTokenContract] = true;
1795     }
1796     
1797     receive() external payable {}
1798     fallback() external payable {}
1799 }