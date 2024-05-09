1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant alphabet = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = alphabet[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 
88 }
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize, which returns 0 for contracts in
113         // construction, since the code is only stored at the end of the
114         // constructor execution.
115 
116         uint256 size;
117         // solhint-disable-next-line no-inline-assembly
118         assembly { size := extcodesize(account) }
119         return size > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
142         (bool success, ) = recipient.call{ value: amount }("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain`call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165       return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         require(isContract(target), "Address: call to non-contract");
202 
203         // solhint-disable-next-line avoid-low-level-calls
204         (bool success, bytes memory returndata) = target.call{ value: value }(data);
205         return _verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
225         require(isContract(target), "Address: static call to non-contract");
226 
227         // solhint-disable-next-line avoid-low-level-calls
228         (bool success, bytes memory returndata) = target.staticcall(data);
229         return _verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a delegate call.
235      *
236      * _Available since v3.4._
237      */
238     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
249         require(isContract(target), "Address: delegate call to non-contract");
250 
251         // solhint-disable-next-line avoid-low-level-calls
252         (bool success, bytes memory returndata) = target.delegatecall(data);
253         return _verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
257         if (success) {
258             return returndata;
259         } else {
260             // Look for revert reason and bubble it up if present
261             if (returndata.length > 0) {
262                 // The easiest way to bubble the revert reason is using memory via assembly
263 
264                 // solhint-disable-next-line no-inline-assembly
265                 assembly {
266                     let returndata_size := mload(returndata)
267                     revert(add(32, returndata), returndata_size)
268                 }
269             } else {
270                 revert(errorMessage);
271             }
272         }
273     }
274 }
275 
276 /**
277  * @dev Interface of the ERC165 standard, as defined in the
278  * https://eips.ethereum.org/EIPS/eip-165[EIP].
279  *
280  * Implementers can declare support of contract interfaces, which can then be
281  * queried by others ({ERC165Checker}).
282  *
283  * For an implementation, see {ERC165}.
284  */
285 interface IERC165 {
286     /**
287      * @dev Returns true if this contract implements the interface defined by
288      * `interfaceId`. See the corresponding
289      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
290      * to learn more about how these ids are created.
291      *
292      * This function call must use less than 30 000 gas.
293      */
294     function supportsInterface(bytes4 interfaceId) external view returns (bool);
295 }
296 
297 /**
298  * @dev Implementation of the {IERC165} interface.
299  *
300  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
301  * for the additional interface id that will be supported. For example:
302  *
303  * ```solidity
304  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
305  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
306  * }
307  * ```
308  *
309  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
310  */
311 abstract contract ERC165 is IERC165 {
312     /**
313      * @dev See {IERC165-supportsInterface}.
314      */
315     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
316         return interfaceId == type(IERC165).interfaceId;
317     }
318 }
319 
320 /**
321  * @dev Standard math utilities missing in the Solidity language.
322  */
323 library Math {
324     /**
325      * @dev Returns the largest of two numbers.
326      */
327     function max(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a >= b ? a : b;
329     }
330 
331     /**
332      * @dev Returns the smallest of two numbers.
333      */
334     function min(uint256 a, uint256 b) internal pure returns (uint256) {
335         return a < b ? a : b;
336     }
337 
338     /**
339      * @dev Returns the average of two numbers. The result is rounded towards
340      * zero.
341      */
342     function average(uint256 a, uint256 b) internal pure returns (uint256) {
343         // (a + b) / 2 can overflow, so we distribute
344         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
345     }
346 }
347 
348 /**
349  * @dev External interface of AccessControl declared to support ERC165 detection.
350  */
351 interface IAccessControl {
352     function hasRole(bytes32 role, address account) external view returns (bool);
353     function getRoleAdmin(bytes32 role) external view returns (bytes32);
354     function grantRole(bytes32 role, address account) external;
355     function revokeRole(bytes32 role, address account) external;
356     function renounceRole(bytes32 role, address account) external;
357 }
358 
359 /**
360  * @dev Contract module that allows children to implement role-based access
361  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
362  * members except through off-chain means by accessing the contract event logs. Some
363  * applications may benefit from on-chain enumerability, for those cases see
364  * {AccessControlEnumerable}.
365  *
366  * Roles are referred to by their `bytes32` identifier. These should be exposed
367  * in the external API and be unique. The best way to achieve this is by
368  * using `public constant` hash digests:
369  *
370  * ```
371  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
372  * ```
373  *
374  * Roles can be used to represent a set of permissions. To restrict access to a
375  * function call, use {hasRole}:
376  *
377  * ```
378  * function foo() public {
379  *     require(hasRole(MY_ROLE, msg.sender));
380  *     ...
381  * }
382  * ```
383  *
384  * Roles can be granted and revoked dynamically via the {grantRole} and
385  * {revokeRole} functions. Each role has an associated admin role, and only
386  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
387  *
388  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
389  * that only accounts with this role will be able to grant or revoke other
390  * roles. More complex role relationships can be created by using
391  * {_setRoleAdmin}.
392  *
393  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
394  * grant and revoke this role. Extra precautions should be taken to secure
395  * accounts that have been granted it.
396  */
397 abstract contract AccessControl is Context, IAccessControl, ERC165 {
398     struct RoleData {
399         mapping (address => bool) members;
400         bytes32 adminRole;
401     }
402 
403     mapping (bytes32 => RoleData) private _roles;
404 
405     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
406 
407     /**
408      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
409      *
410      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
411      * {RoleAdminChanged} not being emitted signaling this.
412      *
413      * _Available since v3.1._
414      */
415     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
416 
417     /**
418      * @dev Emitted when `account` is granted `role`.
419      *
420      * `sender` is the account that originated the contract call, an admin role
421      * bearer except when using {_setupRole}.
422      */
423     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
424 
425     /**
426      * @dev Emitted when `account` is revoked `role`.
427      *
428      * `sender` is the account that originated the contract call:
429      *   - if using `revokeRole`, it is the admin role bearer
430      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
431      */
432     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
433 
434     /**
435      * @dev Modifier that checks that an account has a specific role. Reverts
436      * with a standardized message including the required role.
437      *
438      * The format of the revert reason is given by the following regular expression:
439      *
440      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
441      *
442      * _Available since v4.1._
443      */
444     modifier onlyRole(bytes32 role) {
445         _checkRole(role, _msgSender());
446         _;
447     }
448 
449     /**
450      * @dev See {IERC165-supportsInterface}.
451      */
452     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
453         return interfaceId == type(IAccessControl).interfaceId
454             || super.supportsInterface(interfaceId);
455     }
456 
457     /**
458      * @dev Returns `true` if `account` has been granted `role`.
459      */
460     function hasRole(bytes32 role, address account) public view override returns (bool) {
461         return _roles[role].members[account];
462     }
463 
464     /**
465      * @dev Revert with a standard message if `account` is missing `role`.
466      *
467      * The format of the revert reason is given by the following regular expression:
468      *
469      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
470      */
471     function _checkRole(bytes32 role, address account) internal view {
472         if(!hasRole(role, account)) {
473             revert(string(abi.encodePacked(
474                 "AccessControl: account ",
475                 Strings.toHexString(uint160(account), 20),
476                 " is missing role ",
477                 Strings.toHexString(uint256(role), 32)
478             )));
479         }
480     }
481 
482     /**
483      * @dev Returns the admin role that controls `role`. See {grantRole} and
484      * {revokeRole}.
485      *
486      * To change a role's admin, use {_setRoleAdmin}.
487      */
488     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
489         return _roles[role].adminRole;
490     }
491 
492     /**
493      * @dev Grants `role` to `account`.
494      *
495      * If `account` had not been already granted `role`, emits a {RoleGranted}
496      * event.
497      *
498      * Requirements:
499      *
500      * - the caller must have ``role``'s admin role.
501      */
502     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
503         _grantRole(role, account);
504     }
505 
506     /**
507      * @dev Revokes `role` from `account`.
508      *
509      * If `account` had been granted `role`, emits a {RoleRevoked} event.
510      *
511      * Requirements:
512      *
513      * - the caller must have ``role``'s admin role.
514      */
515     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
516         _revokeRole(role, account);
517     }
518 
519     /**
520      * @dev Revokes `role` from the calling account.
521      *
522      * Roles are often managed via {grantRole} and {revokeRole}: this function's
523      * purpose is to provide a mechanism for accounts to lose their privileges
524      * if they are compromised (such as when a trusted device is misplaced).
525      *
526      * If the calling account had been granted `role`, emits a {RoleRevoked}
527      * event.
528      *
529      * Requirements:
530      *
531      * - the caller must be `account`.
532      */
533     function renounceRole(bytes32 role, address account) public virtual override {
534         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
535 
536         _revokeRole(role, account);
537     }
538 
539     /**
540      * @dev Grants `role` to `account`.
541      *
542      * If `account` had not been already granted `role`, emits a {RoleGranted}
543      * event. Note that unlike {grantRole}, this function doesn't perform any
544      * checks on the calling account.
545      *
546      * [WARNING]
547      * ====
548      * This function should only be called from the constructor when setting
549      * up the initial roles for the system.
550      *
551      * Using this function in any other way is effectively circumventing the admin
552      * system imposed by {AccessControl}.
553      * ====
554      */
555     function _setupRole(bytes32 role, address account) internal virtual {
556         _grantRole(role, account);
557     }
558 
559     /**
560      * @dev Sets `adminRole` as ``role``'s admin role.
561      *
562      * Emits a {RoleAdminChanged} event.
563      */
564     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
565         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
566         _roles[role].adminRole = adminRole;
567     }
568 
569     function _grantRole(bytes32 role, address account) private {
570         if (!hasRole(role, account)) {
571             _roles[role].members[account] = true;
572             emit RoleGranted(role, account, _msgSender());
573         }
574     }
575 
576     function _revokeRole(bytes32 role, address account) private {
577         if (hasRole(role, account)) {
578             _roles[role].members[account] = false;
579             emit RoleRevoked(role, account, _msgSender());
580         }
581     }
582 }
583 
584 /**
585  * @dev Contract module that helps prevent reentrant calls to a function.
586  *
587  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
588  * available, which can be applied to functions to make sure there are no nested
589  * (reentrant) calls to them.
590  *
591  * Note that because there is a single `nonReentrant` guard, functions marked as
592  * `nonReentrant` may not call one another. This can be worked around by making
593  * those functions `private`, and then adding `external` `nonReentrant` entry
594  * points to them.
595  *
596  * TIP: If you would like to learn more about reentrancy and alternative ways
597  * to protect against it, check out our blog post
598  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
599  */
600 abstract contract ReentrancyGuard {
601     // Booleans are more expensive than uint256 or any type that takes up a full
602     // word because each write operation emits an extra SLOAD to first read the
603     // slot's contents, replace the bits taken up by the boolean, and then write
604     // back. This is the compiler's defense against contract upgrades and
605     // pointer aliasing, and it cannot be disabled.
606 
607     // The values being non-zero value makes deployment a bit more expensive,
608     // but in exchange the refund on every call to nonReentrant will be lower in
609     // amount. Since refunds are capped to a percentage of the total
610     // transaction's gas, it is best to keep them low in cases like this one, to
611     // increase the likelihood of the full refund coming into effect.
612     uint256 private constant _NOT_ENTERED = 1;
613     uint256 private constant _ENTERED = 2;
614 
615     uint256 private _status;
616 
617     constructor () {
618         _status = _NOT_ENTERED;
619     }
620 
621     /**
622      * @dev Prevents a contract from calling itself, directly or indirectly.
623      * Calling a `nonReentrant` function from another `nonReentrant`
624      * function is not supported. It is possible to prevent this from happening
625      * by making the `nonReentrant` function external, and make it call a
626      * `private` function that does the actual work.
627      */
628     modifier nonReentrant() {
629         // On the first call to nonReentrant, _notEntered will be true
630         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
631 
632         // Any calls to nonReentrant after this point will fail
633         _status = _ENTERED;
634 
635         _;
636 
637         // By storing the original value once again, a refund is triggered (see
638         // https://eips.ethereum.org/EIPS/eip-2200)
639         _status = _NOT_ENTERED;
640     }
641 }
642 
643 /**
644  * @title SafeERC20
645  * @dev Wrappers around ERC20 operations that throw on failure (when the token
646  * contract returns false). Tokens that return no value (and instead revert or
647  * throw on failure) are also supported, non-reverting calls are assumed to be
648  * successful.
649  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
650  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
651  */
652 library SafeERC20 {
653     using Address for address;
654 
655     function safeTransfer(IERC20 token, address to, uint256 value) internal {
656         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
657     }
658 
659     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
660         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
661     }
662 
663     /**
664      * @dev Deprecated. This function has issues similar to the ones found in
665      * {IERC20-approve}, and its usage is discouraged.
666      *
667      * Whenever possible, use {safeIncreaseAllowance} and
668      * {safeDecreaseAllowance} instead.
669      */
670     function safeApprove(IERC20 token, address spender, uint256 value) internal {
671         // safeApprove should only be called when setting an initial allowance,
672         // or when resetting it to zero. To increase and decrease it, use
673         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
674         // solhint-disable-next-line max-line-length
675         require((value == 0) || (token.allowance(address(this), spender) == 0),
676             "SafeERC20: approve from non-zero to non-zero allowance"
677         );
678         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
679     }
680 
681     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
682         uint256 newAllowance = token.allowance(address(this), spender) + value;
683         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
684     }
685 
686     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
687         unchecked {
688             uint256 oldAllowance = token.allowance(address(this), spender);
689             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
690             uint256 newAllowance = oldAllowance - value;
691             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
692         }
693     }
694 
695     /**
696      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
697      * on the return value: the return value is optional (but if data is returned, it must not be false).
698      * @param token The token targeted by the call.
699      * @param data The call data (encoded using abi.encode or one of its variants).
700      */
701     function _callOptionalReturn(IERC20 token, bytes memory data) private {
702         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
703         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
704         // the target address contains contract code and also asserts for success in the low-level call.
705 
706         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
707         if (returndata.length > 0) { // Return data is optional
708             // solhint-disable-next-line max-line-length
709             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
710         }
711     }
712 }
713 
714 
715 /**
716  * @dev Interface of the ERC20 standard as defined in the EIP.
717  */
718 interface IERC20 {
719     /**
720      * @dev Returns the amount of tokens in existence.
721      */
722     function totalSupply() external view returns (uint256);
723 
724     /**
725      * @dev Returns the amount of tokens owned by `account`.
726      */
727     function balanceOf(address account) external view returns (uint256);
728 
729     /**
730      * @dev Moves `amount` tokens from the caller's account to `recipient`.
731      *
732      * Returns a boolean value indicating whether the operation succeeded.
733      *
734      * Emits a {Transfer} event.
735      */
736     function transfer(address recipient, uint256 amount) external returns (bool);
737 
738     /**
739      * @dev Returns the remaining number of tokens that `spender` will be
740      * allowed to spend on behalf of `owner` through {transferFrom}. This is
741      * zero by default.
742      *
743      * This value changes when {approve} or {transferFrom} are called.
744      */
745     function allowance(address owner, address spender) external view returns (uint256);
746 
747     /**
748      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
749      *
750      * Returns a boolean value indicating whether the operation succeeded.
751      *
752      * IMPORTANT: Beware that changing an allowance with this method brings the risk
753      * that someone may use both the old and the new allowance by unfortunate
754      * transaction ordering. One possible solution to mitigate this race
755      * condition is to first reduce the spender's allowance to 0 and set the
756      * desired value afterwards:
757      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
758      *
759      * Emits an {Approval} event.
760      */
761     function approve(address spender, uint256 amount) external returns (bool);
762 
763     /**
764      * @dev Moves `amount` tokens from `sender` to `recipient` using the
765      * allowance mechanism. `amount` is then deducted from the caller's
766      * allowance.
767      *
768      * Returns a boolean value indicating whether the operation succeeded.
769      *
770      * Emits a {Transfer} event.
771      */
772     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
773 
774     /**
775      * @dev Emitted when `value` tokens are moved from one account (`from`) to
776      * another (`to`).
777      *
778      * Note that `value` may be zero.
779      */
780     event Transfer(address indexed from, address indexed to, uint256 value);
781 
782     /**
783      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
784      * a call to {approve}. `value` is the new allowance.
785      */
786     event Approval(address indexed owner, address indexed spender, uint256 value);
787 }
788 
789 /**
790  * @dev Required interface of an ERC721 compliant contract.
791  */
792 interface IERC721 is IERC165 {
793     /**
794      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
795      */
796     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
797 
798     /**
799      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
800      */
801     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
805      */
806     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
807 
808     /**
809      * @dev Returns the number of tokens in ``owner``'s account.
810      */
811     function balanceOf(address owner) external view returns (uint256 balance);
812 
813     /**
814      * @dev Returns the owner of the `tokenId` token.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function ownerOf(uint256 tokenId) external view returns (address owner);
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
824      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must exist and be owned by `from`.
831      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
832      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
833      *
834      * Emits a {Transfer} event.
835      */
836     function safeTransferFrom(address from, address to, uint256 tokenId) external;
837 
838     /**
839      * @dev Transfers `tokenId` token from `from` to `to`.
840      *
841      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
842      *
843      * Requirements:
844      *
845      * - `from` cannot be the zero address.
846      * - `to` cannot be the zero address.
847      * - `tokenId` token must be owned by `from`.
848      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
849      *
850      * Emits a {Transfer} event.
851      */
852     function transferFrom(address from, address to, uint256 tokenId) external;
853 
854     /**
855      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
856      * The approval is cleared when the token is transferred.
857      *
858      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
859      *
860      * Requirements:
861      *
862      * - The caller must own the token or be an approved operator.
863      * - `tokenId` must exist.
864      *
865      * Emits an {Approval} event.
866      */
867     function approve(address to, uint256 tokenId) external;
868 
869     /**
870      * @dev Returns the account approved for `tokenId` token.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      */
876     function getApproved(uint256 tokenId) external view returns (address operator);
877 
878     /**
879      * @dev Approve or remove `operator` as an operator for the caller.
880      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
881      *
882      * Requirements:
883      *
884      * - The `operator` cannot be the caller.
885      *
886      * Emits an {ApprovalForAll} event.
887      */
888     function setApprovalForAll(address operator, bool _approved) external;
889 
890     /**
891      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
892      *
893      * See {setApprovalForAll}
894      */
895     function isApprovedForAll(address owner, address operator) external view returns (bool);
896 
897     /**
898       * @dev Safely transfers `tokenId` token from `from` to `to`.
899       *
900       * Requirements:
901       *
902       * - `from` cannot be the zero address.
903       * - `to` cannot be the zero address.
904       * - `tokenId` token must exist and be owned by `from`.
905       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
906       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907       *
908       * Emits a {Transfer} event.
909       */
910     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
911 }
912 
913 /**
914  * @title ERC721 token receiver interface
915  * @dev Interface for any contract that wants to support safeTransfers
916  * from ERC721 asset contracts.
917  */
918 interface IERC721Receiver {
919     /**
920      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
921      * by `operator` from `from`, this function is called.
922      *
923      * It must return its Solidity selector to confirm the token transfer.
924      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
925      *
926      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
927      */
928     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
929 }
930 
931   /**
932    * @dev Implementation of the {IERC721Receiver} interface.
933    *
934    * Accepts all token transfers.
935    * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
936    */
937 contract ERC721Holder is IERC721Receiver {
938 
939     /**
940      * @dev See {IERC721Receiver-onERC721Received}.
941      *
942      * Always returns `IERC721Receiver.onERC721Received.selector`.
943      */
944     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
945         return this.onERC721Received.selector;
946     }
947 }
948 
949 interface INonfungiblePositionManager is IERC721 {
950   function positions(uint256 tokenId)
951         external
952         view
953         returns (
954             uint96 nonce,
955             address operator,
956             address token0,
957             address token1,
958             uint24 fee,
959             int24 tickLower,
960             int24 tickUpper,
961             uint128 liquidity,
962             uint256 feeGrowthInside0LastX128,
963             uint256 feeGrowthInside1LastX128,
964             uint128 tokensOwed0,
965             uint128 tokensOwed1
966         );
967 }
968 
969 interface RainiLpv2StakingPool {
970   function burn(address _owner, uint256 _amount) external;
971   function balanceOf(address _owner) external view returns(uint256);
972 }
973 
974 contract RainiLpv3StakingPool is AccessControl, ReentrancyGuard, ERC721Holder {
975   bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
976   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
977 
978   using SafeERC20 for IERC20;
979  
980   // Fixed / admin assigned values:
981 
982   uint256 public rewardRate;
983   uint256 public minRewardStake;
984   uint256 constant public REWARD_DECIMALS = 1000000;
985 
986   uint256 public maxBonus;
987   uint256 public bonusDuration;
988   uint256 public bonusRate;
989   uint256 constant public BONUS_DECIMALS = 1000000000;
990 
991   uint256 constant public RAINI_REWARD_DECIMALS = 1000000000000;
992 
993   int24 public minTickUpper;
994   int24 public maxTickLower;
995   uint24 public feeRequired;
996 
997 
998   INonfungiblePositionManager public rainiLpNFT;
999   RainiLpv2StakingPool public rainiLpv2StakingPool;
1000   IERC20 public rainiToken;
1001 
1002   address public exchangeTokenAddress;
1003 
1004   uint256 public unicornToEth;
1005 
1006 
1007   // Universal variables
1008   uint256 public totalSupply;
1009   
1010   struct GeneralRewardVars {
1011     uint32 lastUpdateTime;
1012     uint64 rainiRewardPerTokenStored;
1013     uint32 periodFinish;
1014     uint128 rainiRewardRate;
1015   }
1016 
1017   GeneralRewardVars public generalRewardVars;
1018 
1019   // account specific variables
1020 
1021   struct AccountRewardVars {
1022     uint40 lastBonus;
1023     uint32 lastUpdated;
1024     uint104 rainiRewards;
1025     uint64 rainiRewardPerTokenPaid;
1026   }
1027 
1028   struct AccountVars {
1029     uint128 staked;
1030     uint128 unicornBalance;
1031   }
1032 
1033 
1034   mapping(address => AccountRewardVars) internal accountRewardVars;
1035   mapping(address => AccountVars) internal accountVars;
1036   mapping(address => uint32[]) internal stakedNFTs;
1037 
1038 
1039   // Events
1040   event EthWithdrawn(uint256 amount);
1041 
1042   event RewardSet(uint256 rewardRate, uint256 minRewardStake);
1043   event BonusesSet(uint256 maxBonus, uint256 bonusDuration);
1044   event RainiLpTokenSet(address token);
1045   event UnicornToEthSet(uint256 unicornToEth);
1046   event TickRangeSet(int24 minTickUpper, int24 maxTickLower);
1047   event FeeRequiredSet(uint24 feeRequired);
1048   
1049 
1050   event TokensStaked(address payer, uint256 amount, uint256 timestamp);
1051   event TokensWithdrawn(address owner, uint256 amount, uint256 timestamp);
1052 
1053   event UnicornPointsBurned(address owner, uint256 amount);
1054   event UnicornPointsMinted(address owner, uint256 amount);
1055   event UnicornPointsBought(address owner, uint256 amount);
1056 
1057   event RewardWithdrawn(address owner, uint256 amount, uint256 timestamp);
1058   event RewardPoolAdded(uint256 _amount, uint256 _duration, uint256 timestamp);
1059 
1060   constructor(address _rainiLpNFT, address _rainiToken, address _exchangeToken, address _v2Pool) {
1061     require(_rainiLpNFT != address(0), "RainiLpv3StakingPool: _rainiLpToken is zero address");
1062     _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1063     rainiLpNFT = INonfungiblePositionManager(_rainiLpNFT);
1064     exchangeTokenAddress = _exchangeToken;
1065     rainiToken = IERC20(_rainiToken);
1066     rainiLpv2StakingPool = RainiLpv2StakingPool(_v2Pool);
1067   }
1068 
1069   modifier onlyOwner() {
1070     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "RainiLpv3StakingPool: caller is not an owner");
1071     _;
1072   }
1073 
1074   modifier onlyBurner() {
1075     require(hasRole(BURNER_ROLE, _msgSender()), "RainiLpv3StakingPool: caller is not a burner");
1076     _;
1077   }
1078 
1079   modifier onlyMinter() {
1080     require(hasRole(MINTER_ROLE, _msgSender()), "RainiLpv3StakingPool: caller is not a minter");
1081     _;
1082   }
1083   
1084   modifier balanceUpdate(address _owner) {
1085 
1086     AccountRewardVars memory _accountRewardVars = accountRewardVars[_owner];
1087     AccountVars memory _accountVars = accountVars[_owner];
1088     GeneralRewardVars memory _generalRewardVars = generalRewardVars;
1089 
1090     // Raini rewards
1091     _generalRewardVars.rainiRewardPerTokenStored = uint64(rainiRewardPerToken());
1092     _generalRewardVars.lastUpdateTime = uint32(lastTimeRewardApplicable());
1093 
1094     if (_owner != address(0)) {
1095       uint32 duration = uint32(block.timestamp) - _accountRewardVars.lastUpdated;
1096       uint128 reward = calculateReward(_owner, _accountVars.staked, duration);
1097   
1098       _accountVars.unicornBalance = _accountVars.unicornBalance + reward;
1099       _accountRewardVars.lastUpdated = uint32(block.timestamp);
1100       _accountRewardVars.lastBonus = uint40(Math.min(maxBonus, _accountRewardVars.lastBonus + bonusRate * duration));
1101       
1102       _accountRewardVars.rainiRewards = uint104(rainiEarned(_owner));
1103       _accountRewardVars.rainiRewardPerTokenPaid = _generalRewardVars.rainiRewardPerTokenStored;
1104     }
1105 
1106     accountRewardVars[_owner] = _accountRewardVars;
1107     accountVars[_owner] = _accountVars;
1108     generalRewardVars = _generalRewardVars;
1109 
1110     _;
1111   }
1112 
1113   function getRewardByDuration(address _owner, uint256 _amount, uint256 _duration) 
1114     public view returns(uint256) {
1115       return calculateReward(_owner, _amount, _duration);
1116   }
1117 
1118   function getStaked(address _owner) 
1119     public view returns(uint256) {
1120       return accountVars[_owner].staked;
1121   }
1122 
1123   function getStakedPositions(address _owner) 
1124     public view returns(uint32[] memory) {
1125       return stakedNFTs[_owner];
1126   }
1127   
1128   function balanceOf(address _owner)
1129     public view returns(uint256) {
1130       uint256 reward = calculateReward(_owner, accountVars[_owner].staked, block.timestamp - accountRewardVars[_owner].lastUpdated);
1131       return accountVars[_owner].unicornBalance + reward;
1132   }
1133 
1134   function getCurrentBonus(address _owner) 
1135     public view returns(uint256) {
1136       AccountRewardVars memory _accountRewardVars = accountRewardVars[_owner];
1137 
1138       if(accountVars[_owner].staked == 0) {
1139         return 0;
1140       } 
1141       uint256 duration = block.timestamp - _accountRewardVars.lastUpdated;
1142       return Math.min(maxBonus, _accountRewardVars.lastBonus + bonusRate * duration);
1143   }
1144 
1145   function getCurrentAvgBonus(address _owner, uint256 _duration)
1146     public view returns(uint256) {
1147       AccountRewardVars memory _accountRewardVars = accountRewardVars[_owner];
1148 
1149       if(accountVars[_owner].staked == 0) {
1150         return 0;
1151       } 
1152       uint256 avgBonus;
1153       if(_accountRewardVars.lastBonus < maxBonus) {
1154         uint256 durationTillMax = (maxBonus - _accountRewardVars.lastBonus) / bonusRate;
1155         if(_duration > durationTillMax) {
1156           uint256 avgWeightedBonusTillMax = (_accountRewardVars.lastBonus + maxBonus) * durationTillMax / 2;
1157           uint256 weightedMaxBonus = maxBonus * (_duration - durationTillMax);
1158 
1159           avgBonus = (avgWeightedBonusTillMax + weightedMaxBonus) / _duration;
1160         } else {
1161           avgBonus = (_accountRewardVars.lastBonus + bonusRate * _duration + _accountRewardVars.lastBonus) / 2;
1162         }
1163       } else {
1164         avgBonus = maxBonus;
1165       }
1166       return avgBonus;
1167   }
1168 
1169   function setReward(uint256 _rewardRate, uint256 _minRewardStake)
1170     external onlyOwner {
1171       rewardRate = _rewardRate;
1172       minRewardStake = _minRewardStake;
1173 
1174       emit RewardSet(rewardRate, minRewardStake);
1175   }
1176 
1177   function setUnicornToEth(uint256 _unicornToEth)
1178     external onlyOwner {
1179       unicornToEth = _unicornToEth;
1180       
1181       emit UnicornToEthSet(_unicornToEth);
1182   }
1183 
1184   function setBonus(uint256 _maxBonus, uint256 _bonusDuration)
1185     external onlyOwner {
1186       maxBonus = _maxBonus * BONUS_DECIMALS;
1187       bonusDuration = _bonusDuration;
1188       bonusRate = maxBonus / _bonusDuration;
1189 
1190       emit BonusesSet(_maxBonus, _bonusDuration);
1191   }
1192   function setTickRange(int24 _maxTickLower, int24 _minTickUpper)
1193     external onlyOwner {
1194       minTickUpper = _minTickUpper;
1195       maxTickLower = _maxTickLower;
1196       emit TickRangeSet(_minTickUpper, _maxTickLower);
1197   }
1198 
1199   function setFeeRequired(uint24 _feeRequired)
1200     external onlyOwner {
1201       feeRequired = _feeRequired;  
1202       emit FeeRequiredSet(_feeRequired);
1203   }
1204 
1205   function stake(uint32 _tokenId)
1206     external nonReentrant balanceUpdate(_msgSender()) {
1207       (
1208         ,//uint96 nonce,
1209         ,//address operator,
1210         address token0,
1211         address token1,
1212         uint24 fee,
1213         int24 tickLower,
1214         int24 tickUpper,
1215         uint128 liquidity,
1216         ,//uint256 feeGrowthInside0LastX128,
1217         ,//uint256 feeGrowthInside1LastX128,
1218         ,//uint128 tokensOwed0,
1219         //uint128 tokensOwed1
1220       ) = rainiLpNFT.positions(_tokenId);
1221 
1222       require(tickUpper > minTickUpper, "RainiLpv3StakingPool: tickUpper too low");
1223       require(tickLower < maxTickLower, "RainiLpv3StakingPool: tickLower too high");
1224       require((token0 ==  exchangeTokenAddress && token1 == address(rainiToken)) ||
1225               (token1 ==  exchangeTokenAddress && token0 == address(rainiToken)), "RainiLpv3StakingPool: NFT tokens not correct");
1226       require(fee == feeRequired, "RainiLpv3StakingPool: fee != feeRequired");
1227 
1228       rainiLpNFT.safeTransferFrom(_msgSender(), address(this), _tokenId);
1229 
1230       uint32[] memory nfts = stakedNFTs[_msgSender()];
1231       bool wasAdded = false;
1232       for (uint i = 0; i < nfts.length; i++) {
1233          if (nfts[i] == 0) {
1234            stakedNFTs[_msgSender()][i] = _tokenId;
1235            wasAdded = true;
1236            break;
1237          }
1238       }
1239       if (!wasAdded) {
1240         stakedNFTs[_msgSender()].push(_tokenId);
1241       }      
1242 
1243       totalSupply = totalSupply + liquidity;
1244       uint128 currentStake = accountVars[_msgSender()].staked;
1245       accountVars[_msgSender()].staked = currentStake + liquidity;
1246       accountRewardVars[_msgSender()].lastBonus = uint40(accountRewardVars[_msgSender()].lastBonus * currentStake / (currentStake + liquidity));
1247 
1248       emit TokensStaked(_msgSender(), liquidity, block.timestamp);
1249   }
1250   
1251   function withdraw(uint256 _tokenId)
1252     external nonReentrant balanceUpdate(_msgSender()) {
1253 
1254       bool ownsNFT = false;
1255       uint32[] memory nfts = stakedNFTs[_msgSender()];
1256       for (uint i = 0; i < nfts.length; i++) {
1257         if (nfts[i] == _tokenId) {
1258           ownsNFT = true;
1259           delete stakedNFTs[_msgSender()][i];
1260           break;
1261         }
1262       }
1263       require(ownsNFT == true, "RainiLpv3StakingPool: Not the owner");
1264 
1265       rainiLpNFT.safeTransferFrom(address(this), _msgSender(), _tokenId);
1266 
1267       (
1268         ,//uint96 nonce,
1269         ,//address operator,
1270         ,//address token0,
1271         ,//address token1,
1272         ,//uint24 fee,
1273         ,//int24 tickLower,
1274         ,//int24 tickUpper,
1275         uint128 liquidity,
1276         ,//uint256 feeGrowthInside0LastX128,
1277         ,//uint256 feeGrowthInside1LastX128,
1278         ,//uint128 tokensOwed0,
1279         //uint128 tokensOwed1
1280       ) = rainiLpNFT.positions(_tokenId);
1281 
1282       accountVars[_msgSender()].staked = accountVars[_msgSender()].staked - liquidity;
1283       totalSupply = totalSupply - liquidity;
1284 
1285       emit TokensWithdrawn(_msgSender(), liquidity, block.timestamp);
1286   }
1287 
1288   function withdrawEth(uint256 _amount)
1289     external onlyOwner {
1290       require(_amount <= address(this).balance, "RainiLpv3StakingPool: not enough balance");
1291       (bool success, ) = _msgSender().call{ value: _amount }("");
1292       require(success, "RainiLpv3StakingPool: transfer failed");
1293       emit EthWithdrawn(_amount);
1294   }
1295   
1296   function mint(address[] calldata _addresses, uint256[] calldata _points) 
1297     external onlyMinter {
1298       require(_addresses.length == _points.length, "RainiLpv3StakingPool: Arrays not equal");
1299       
1300       for (uint256 i = 0; i < _addresses.length; i++) {
1301         accountVars[_addresses[i]].unicornBalance = uint128(accountVars[_addresses[i]].unicornBalance + _points[i]);
1302         
1303         emit UnicornPointsMinted(_addresses[i], _points[i]);
1304       }
1305   }
1306   
1307   function buyUnicorn(uint256 _amount) 
1308     external payable {
1309       require(_amount > 0, "RainiLpv3StakingPool: _amount is zero");
1310       require(msg.value * unicornToEth >= _amount, "RainiLpv3StakingPool: not enougth eth");
1311 
1312       accountVars[_msgSender()].unicornBalance = uint128(accountVars[_msgSender()].unicornBalance + _amount);
1313 
1314       uint256 refund = msg.value - (_amount / unicornToEth);
1315       if(refund > 0) {
1316         (bool success, ) = _msgSender().call{ value: refund }("");
1317         require(success, "RainiLpv3StakingPool: transfer failed");
1318       }
1319       
1320       emit UnicornPointsBought(_msgSender(), _amount);
1321   }  
1322   
1323   function burn(address _owner, uint256 _amount) 
1324     external nonReentrant onlyBurner balanceUpdate(_owner) {
1325       accountVars[_owner].unicornBalance = uint128(accountVars[_owner].unicornBalance - _amount);
1326       
1327       emit UnicornPointsBurned(_owner, _amount);
1328   }
1329     
1330   function calculateReward(address _owner, uint256 _amount, uint256 _duration) 
1331     private view returns(uint128) {
1332       uint256 reward = _duration * rewardRate * _amount / (REWARD_DECIMALS * minRewardStake);
1333 
1334       return calculateBonus(_owner, reward, _duration);
1335   }
1336 
1337   function calculateBonus(address _owner, uint256 _amount, uint256 _duration)
1338     private view returns(uint128) {
1339       uint256 avgBonus = getCurrentAvgBonus(_owner, _duration);
1340       return uint128(_amount + _amount * avgBonus  / BONUS_DECIMALS / 100);
1341   }
1342 
1343 
1344 
1345   // RAINI rewards
1346 
1347   function lastTimeRewardApplicable() public view returns (uint256) {
1348       return Math.min(block.timestamp, generalRewardVars.periodFinish);
1349   }
1350 
1351   function rainiRewardPerToken() public view returns (uint256) {
1352     GeneralRewardVars memory _generalRewardVars = generalRewardVars;
1353 
1354     if (totalSupply == 0) {
1355       return _generalRewardVars.rainiRewardPerTokenStored;
1356     }
1357     
1358     return _generalRewardVars.rainiRewardPerTokenStored + (uint256(lastTimeRewardApplicable() - _generalRewardVars.lastUpdateTime) * _generalRewardVars.rainiRewardRate * RAINI_REWARD_DECIMALS) / totalSupply;
1359   }
1360 
1361   function rainiEarned(address account) public view returns (uint256) {
1362     AccountRewardVars memory _accountRewardVars = accountRewardVars[account];
1363     AccountVars memory _accountVars = accountVars[account];
1364     
1365     uint256 calculatedEarned = (uint256(_accountVars.staked) * (rainiRewardPerToken() - _accountRewardVars.rainiRewardPerTokenPaid)) / RAINI_REWARD_DECIMALS + _accountRewardVars.rainiRewards;
1366     uint256 poolBalance = rainiToken.balanceOf(address(this));
1367     // some rare case the reward can be slightly bigger than real number, we need to check against how much we have left in pool
1368     if (calculatedEarned > poolBalance) return poolBalance;
1369     return calculatedEarned;
1370   }
1371 
1372   function addRainiRewardPool(uint256 _amount, uint256 _duration)
1373     external onlyOwner nonReentrant balanceUpdate(address(0)) {
1374 
1375       GeneralRewardVars memory _generalRewardVars = generalRewardVars;
1376 
1377       if (_generalRewardVars.periodFinish > block.timestamp) {
1378         uint256 timeRemaining = _generalRewardVars.periodFinish - block.timestamp;
1379         _amount += timeRemaining * _generalRewardVars.rainiRewardRate;
1380       }
1381 
1382       rainiToken.safeTransferFrom(_msgSender(), address(this), _amount);
1383       _generalRewardVars.rainiRewardRate = uint128(_amount / _duration);
1384       _generalRewardVars.periodFinish = uint32(block.timestamp + _duration);
1385       _generalRewardVars.lastUpdateTime = uint32(block.timestamp);
1386       generalRewardVars = _generalRewardVars;
1387       emit RewardPoolAdded(_amount, _duration, block.timestamp);
1388   }
1389 
1390   function abortRainiRewardPool() external onlyOwner nonReentrant balanceUpdate(address(0)) {
1391 
1392       GeneralRewardVars memory _generalRewardVars = generalRewardVars;
1393 
1394       require (_generalRewardVars.periodFinish > block.timestamp, "Reward pool is not active");
1395       
1396       uint256 timeRemaining = _generalRewardVars.periodFinish - block.timestamp;
1397       uint256 remainingAmount = timeRemaining * _generalRewardVars.rainiRewardRate;
1398       rainiToken.transfer(_msgSender(), remainingAmount);
1399 
1400       _generalRewardVars.rainiRewardRate = 0;
1401       _generalRewardVars.periodFinish = uint32(block.timestamp);
1402       _generalRewardVars.lastUpdateTime = uint32(block.timestamp);
1403       generalRewardVars = _generalRewardVars;
1404   }
1405 
1406   function recoverRaini(uint256 _amount) external onlyOwner nonReentrant {
1407     require(generalRewardVars.periodFinish < block.timestamp, "Raini cannot be recovered while reward pool active.");
1408     rainiToken.transfer(_msgSender(), _amount);
1409   }
1410 
1411   function withdrawReward() external nonReentrant balanceUpdate(_msgSender()) {
1412     uint256 reward = rainiEarned(_msgSender());
1413     require(reward > 1, "no reward to withdraw");
1414     if (reward > 1) {
1415       accountRewardVars[_msgSender()].rainiRewards = 0;
1416       rainiToken.safeTransfer(_msgSender(), reward);
1417     }
1418 
1419     emit RewardWithdrawn(_msgSender(), reward, block.timestamp);
1420   }
1421 
1422 
1423 
1424   // LP v2 migration
1425   function migrateV2Unicorns() external {
1426     uint256 balance = rainiLpv2StakingPool.balanceOf(_msgSender());
1427     rainiLpv2StakingPool.burn(_msgSender(), balance);
1428     accountVars[_msgSender()].unicornBalance = uint128(accountVars[_msgSender()].unicornBalance + balance);
1429     emit UnicornPointsMinted(_msgSender(), balance);
1430   }
1431 }