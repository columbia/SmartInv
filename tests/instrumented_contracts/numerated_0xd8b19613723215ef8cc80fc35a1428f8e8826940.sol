1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
28 
29 
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
52 
53 
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
119 
120 
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `recipient`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address recipient, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `sender` to `recipient` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 
201 
202 
203 
204 
205 
206 
207 // OpenZeppelin Contracts v4.4.0 (token/ERC20/utils/SafeERC20.sol)
208 
209 
210 
211 
212 
213 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
214 
215 
216 
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize, which returns 0 for contracts in
240         // construction, since the code is only stored at the end of the
241         // constructor execution.
242 
243         uint256 size;
244         assembly {
245             size := extcodesize(account)
246         }
247         return size > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         (bool success, ) = recipient.call{value: amount}("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain `call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, 0, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but also transferring `value` wei to `target`.
312      *
313      * Requirements:
314      *
315      * - the calling contract must have an ETH balance of at least `value`.
316      * - the called Solidity function must be `payable`.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
330      * with `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(address(this).balance >= value, "Address: insufficient balance for call");
341         require(isContract(target), "Address: call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.call{value: value}(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
354         return functionStaticCall(target, data, "Address: low-level static call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal view returns (bytes memory) {
368         require(isContract(target), "Address: static call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.staticcall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(isContract(target), "Address: delegate call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.delegatecall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
403      * revert reason using the provided one.
404      *
405      * _Available since v4.3._
406      */
407     function verifyCallResult(
408         bool success,
409         bytes memory returndata,
410         string memory errorMessage
411     ) internal pure returns (bytes memory) {
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 
431 /**
432  * @title SafeERC20
433  * @dev Wrappers around ERC20 operations that throw on failure (when the token
434  * contract returns false). Tokens that return no value (and instead revert or
435  * throw on failure) are also supported, non-reverting calls are assumed to be
436  * successful.
437  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
438  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
439  */
440 library SafeERC20 {
441     using Address for address;
442 
443     function safeTransfer(
444         IERC20 token,
445         address to,
446         uint256 value
447     ) internal {
448         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
449     }
450 
451     function safeTransferFrom(
452         IERC20 token,
453         address from,
454         address to,
455         uint256 value
456     ) internal {
457         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
458     }
459 
460     /**
461      * @dev Deprecated. This function has issues similar to the ones found in
462      * {IERC20-approve}, and its usage is discouraged.
463      *
464      * Whenever possible, use {safeIncreaseAllowance} and
465      * {safeDecreaseAllowance} instead.
466      */
467     function safeApprove(
468         IERC20 token,
469         address spender,
470         uint256 value
471     ) internal {
472         // safeApprove should only be called when setting an initial allowance,
473         // or when resetting it to zero. To increase and decrease it, use
474         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
475         require(
476             (value == 0) || (token.allowance(address(this), spender) == 0),
477             "SafeERC20: approve from non-zero to non-zero allowance"
478         );
479         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
480     }
481 
482     function safeIncreaseAllowance(
483         IERC20 token,
484         address spender,
485         uint256 value
486     ) internal {
487         uint256 newAllowance = token.allowance(address(this), spender) + value;
488         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
489     }
490 
491     function safeDecreaseAllowance(
492         IERC20 token,
493         address spender,
494         uint256 value
495     ) internal {
496         unchecked {
497             uint256 oldAllowance = token.allowance(address(this), spender);
498             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
499             uint256 newAllowance = oldAllowance - value;
500             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501         }
502     }
503 
504     /**
505      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
506      * on the return value: the return value is optional (but if data is returned, it must not be false).
507      * @param token The token targeted by the call.
508      * @param data The call data (encoded using abi.encode or one of its variants).
509      */
510     function _callOptionalReturn(IERC20 token, bytes memory data) private {
511         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
512         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
513         // the target address contains contract code and also asserts for success in the low-level call.
514 
515         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
516         if (returndata.length > 0) {
517             // Return data is optional
518             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
519         }
520     }
521 }
522 
523 
524 // OpenZeppelin Contracts v4.4.0 (access/AccessControl.sol)
525 
526 
527 
528 
529 // OpenZeppelin Contracts v4.4.0 (access/IAccessControl.sol)
530 
531 
532 
533 /**
534  * @dev External interface of AccessControl declared to support ERC165 detection.
535  */
536 interface IAccessControl {
537     /**
538      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
539      *
540      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
541      * {RoleAdminChanged} not being emitted signaling this.
542      *
543      * _Available since v3.1._
544      */
545     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
546 
547     /**
548      * @dev Emitted when `account` is granted `role`.
549      *
550      * `sender` is the account that originated the contract call, an admin role
551      * bearer except when using {AccessControl-_setupRole}.
552      */
553     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
554 
555     /**
556      * @dev Emitted when `account` is revoked `role`.
557      *
558      * `sender` is the account that originated the contract call:
559      *   - if using `revokeRole`, it is the admin role bearer
560      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
561      */
562     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
563 
564     /**
565      * @dev Returns `true` if `account` has been granted `role`.
566      */
567     function hasRole(bytes32 role, address account) external view returns (bool);
568 
569     /**
570      * @dev Returns the admin role that controls `role`. See {grantRole} and
571      * {revokeRole}.
572      *
573      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
574      */
575     function getRoleAdmin(bytes32 role) external view returns (bytes32);
576 
577     /**
578      * @dev Grants `role` to `account`.
579      *
580      * If `account` had not been already granted `role`, emits a {RoleGranted}
581      * event.
582      *
583      * Requirements:
584      *
585      * - the caller must have ``role``'s admin role.
586      */
587     function grantRole(bytes32 role, address account) external;
588 
589     /**
590      * @dev Revokes `role` from `account`.
591      *
592      * If `account` had been granted `role`, emits a {RoleRevoked} event.
593      *
594      * Requirements:
595      *
596      * - the caller must have ``role``'s admin role.
597      */
598     function revokeRole(bytes32 role, address account) external;
599 
600     /**
601      * @dev Revokes `role` from the calling account.
602      *
603      * Roles are often managed via {grantRole} and {revokeRole}: this function's
604      * purpose is to provide a mechanism for accounts to lose their privileges
605      * if they are compromised (such as when a trusted device is misplaced).
606      *
607      * If the calling account had been granted `role`, emits a {RoleRevoked}
608      * event.
609      *
610      * Requirements:
611      *
612      * - the caller must be `account`.
613      */
614     function renounceRole(bytes32 role, address account) external;
615 }
616 
617 
618 
619 
620 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
621 
622 
623 
624 
625 
626 /**
627  * @dev Implementation of the {IERC165} interface.
628  *
629  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
630  * for the additional interface id that will be supported. For example:
631  *
632  * ```solidity
633  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
634  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
635  * }
636  * ```
637  *
638  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
639  */
640 abstract contract ERC165 is IERC165 {
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645         return interfaceId == type(IERC165).interfaceId;
646     }
647 }
648 
649 
650 /**
651  * @dev Contract module that allows children to implement role-based access
652  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
653  * members except through off-chain means by accessing the contract event logs. Some
654  * applications may benefit from on-chain enumerability, for those cases see
655  * {AccessControlEnumerable}.
656  *
657  * Roles are referred to by their `bytes32` identifier. These should be exposed
658  * in the external API and be unique. The best way to achieve this is by
659  * using `public constant` hash digests:
660  *
661  * ```
662  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
663  * ```
664  *
665  * Roles can be used to represent a set of permissions. To restrict access to a
666  * function call, use {hasRole}:
667  *
668  * ```
669  * function foo() public {
670  *     require(hasRole(MY_ROLE, msg.sender));
671  *     ...
672  * }
673  * ```
674  *
675  * Roles can be granted and revoked dynamically via the {grantRole} and
676  * {revokeRole} functions. Each role has an associated admin role, and only
677  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
678  *
679  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
680  * that only accounts with this role will be able to grant or revoke other
681  * roles. More complex role relationships can be created by using
682  * {_setRoleAdmin}.
683  *
684  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
685  * grant and revoke this role. Extra precautions should be taken to secure
686  * accounts that have been granted it.
687  */
688 abstract contract AccessControl is Context, IAccessControl, ERC165 {
689     struct RoleData {
690         mapping(address => bool) members;
691         bytes32 adminRole;
692     }
693 
694     mapping(bytes32 => RoleData) private _roles;
695 
696     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
697 
698     /**
699      * @dev Modifier that checks that an account has a specific role. Reverts
700      * with a standardized message including the required role.
701      *
702      * The format of the revert reason is given by the following regular expression:
703      *
704      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
705      *
706      * _Available since v4.1._
707      */
708     modifier onlyRole(bytes32 role) {
709         _checkRole(role, _msgSender());
710         _;
711     }
712 
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
718     }
719 
720     /**
721      * @dev Returns `true` if `account` has been granted `role`.
722      */
723     function hasRole(bytes32 role, address account) public view override returns (bool) {
724         return _roles[role].members[account];
725     }
726 
727     /**
728      * @dev Revert with a standard message if `account` is missing `role`.
729      *
730      * The format of the revert reason is given by the following regular expression:
731      *
732      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
733      */
734     function _checkRole(bytes32 role, address account) internal view {
735         if (!hasRole(role, account)) {
736             revert(
737                 string(
738                     abi.encodePacked(
739                         "AccessControl: account ",
740                         Strings.toHexString(uint160(account), 20),
741                         " is missing role ",
742                         Strings.toHexString(uint256(role), 32)
743                     )
744                 )
745             );
746         }
747     }
748 
749     /**
750      * @dev Returns the admin role that controls `role`. See {grantRole} and
751      * {revokeRole}.
752      *
753      * To change a role's admin, use {_setRoleAdmin}.
754      */
755     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
756         return _roles[role].adminRole;
757     }
758 
759     /**
760      * @dev Grants `role` to `account`.
761      *
762      * If `account` had not been already granted `role`, emits a {RoleGranted}
763      * event.
764      *
765      * Requirements:
766      *
767      * - the caller must have ``role``'s admin role.
768      */
769     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
770         _grantRole(role, account);
771     }
772 
773     /**
774      * @dev Revokes `role` from `account`.
775      *
776      * If `account` had been granted `role`, emits a {RoleRevoked} event.
777      *
778      * Requirements:
779      *
780      * - the caller must have ``role``'s admin role.
781      */
782     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
783         _revokeRole(role, account);
784     }
785 
786     /**
787      * @dev Revokes `role` from the calling account.
788      *
789      * Roles are often managed via {grantRole} and {revokeRole}: this function's
790      * purpose is to provide a mechanism for accounts to lose their privileges
791      * if they are compromised (such as when a trusted device is misplaced).
792      *
793      * If the calling account had been revoked `role`, emits a {RoleRevoked}
794      * event.
795      *
796      * Requirements:
797      *
798      * - the caller must be `account`.
799      */
800     function renounceRole(bytes32 role, address account) public virtual override {
801         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
802 
803         _revokeRole(role, account);
804     }
805 
806     /**
807      * @dev Grants `role` to `account`.
808      *
809      * If `account` had not been already granted `role`, emits a {RoleGranted}
810      * event. Note that unlike {grantRole}, this function doesn't perform any
811      * checks on the calling account.
812      *
813      * [WARNING]
814      * ====
815      * This function should only be called from the constructor when setting
816      * up the initial roles for the system.
817      *
818      * Using this function in any other way is effectively circumventing the admin
819      * system imposed by {AccessControl}.
820      * ====
821      *
822      * NOTE: This function is deprecated in favor of {_grantRole}.
823      */
824     function _setupRole(bytes32 role, address account) internal virtual {
825         _grantRole(role, account);
826     }
827 
828     /**
829      * @dev Sets `adminRole` as ``role``'s admin role.
830      *
831      * Emits a {RoleAdminChanged} event.
832      */
833     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
834         bytes32 previousAdminRole = getRoleAdmin(role);
835         _roles[role].adminRole = adminRole;
836         emit RoleAdminChanged(role, previousAdminRole, adminRole);
837     }
838 
839     /**
840      * @dev Grants `role` to `account`.
841      *
842      * Internal function without access restriction.
843      */
844     function _grantRole(bytes32 role, address account) internal virtual {
845         if (!hasRole(role, account)) {
846             _roles[role].members[account] = true;
847             emit RoleGranted(role, account, _msgSender());
848         }
849     }
850 
851     /**
852      * @dev Revokes `role` from `account`.
853      *
854      * Internal function without access restriction.
855      */
856     function _revokeRole(bytes32 role, address account) internal virtual {
857         if (hasRole(role, account)) {
858             _roles[role].members[account] = false;
859             emit RoleRevoked(role, account, _msgSender());
860         }
861     }
862 }
863 
864 
865 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
866 
867 
868 
869 
870 
871 /**
872  * @dev Contract module which allows children to implement an emergency stop
873  * mechanism that can be triggered by an authorized account.
874  *
875  * This module is used through inheritance. It will make available the
876  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
877  * the functions of your contract. Note that they will not be pausable by
878  * simply including this module, only once the modifiers are put in place.
879  */
880 abstract contract Pausable is Context {
881     /**
882      * @dev Emitted when the pause is triggered by `account`.
883      */
884     event Paused(address account);
885 
886     /**
887      * @dev Emitted when the pause is lifted by `account`.
888      */
889     event Unpaused(address account);
890 
891     bool private _paused;
892 
893     /**
894      * @dev Initializes the contract in unpaused state.
895      */
896     constructor() {
897         _paused = false;
898     }
899 
900     /**
901      * @dev Returns true if the contract is paused, and false otherwise.
902      */
903     function paused() public view virtual returns (bool) {
904         return _paused;
905     }
906 
907     /**
908      * @dev Modifier to make a function callable only when the contract is not paused.
909      *
910      * Requirements:
911      *
912      * - The contract must not be paused.
913      */
914     modifier whenNotPaused() {
915         require(!paused(), "Pausable: paused");
916         _;
917     }
918 
919     /**
920      * @dev Modifier to make a function callable only when the contract is paused.
921      *
922      * Requirements:
923      *
924      * - The contract must be paused.
925      */
926     modifier whenPaused() {
927         require(paused(), "Pausable: not paused");
928         _;
929     }
930 
931     /**
932      * @dev Triggers stopped state.
933      *
934      * Requirements:
935      *
936      * - The contract must not be paused.
937      */
938     function _pause() internal virtual whenNotPaused {
939         _paused = true;
940         emit Paused(_msgSender());
941     }
942 
943     /**
944      * @dev Returns to normal state.
945      *
946      * Requirements:
947      *
948      * - The contract must be paused.
949      */
950     function _unpause() internal virtual whenPaused {
951         _paused = false;
952         emit Unpaused(_msgSender());
953     }
954 }
955 
956 
957 
958 
959 
960 contract ECDSAOffsetRecovery {
961     function getHashPacked(
962         address user,
963         uint256 amountWithFee,
964         bytes32 originalTxHash,
965         uint256 blockchainNum
966     ) public pure returns (bytes32) {
967         return keccak256(abi.encodePacked(user, amountWithFee, originalTxHash, blockchainNum));
968     }
969 
970     function toEthSignedMessageHash(bytes32 hash)
971         public
972         pure
973         returns (bytes32)
974     {
975         // 32 is the length in bytes of hash,
976         // enforced by the type signature above
977         return
978             keccak256(
979                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
980             );
981     }
982 
983     function ecOffsetRecover(
984         bytes32 hash,
985         bytes memory signature,
986         uint256 offset
987     ) public pure returns (address) {
988         bytes32 r;
989         bytes32 s;
990         uint8 v;
991 
992         // Divide the signature in r, s and v variables with inline assembly.
993         assembly {
994             r := mload(add(signature, add(offset, 0x20)))
995             s := mload(add(signature, add(offset, 0x40)))
996             v := byte(0, mload(add(signature, add(offset, 0x60))))
997         }
998 
999         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
1000         if (v < 27) {
1001             v += 27;
1002         }
1003 
1004         // If the version is correct return the signer address
1005         if (v != 27 && v != 28) {
1006             return (address(0));
1007         }
1008 
1009         // bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1010         // hash = keccak256(abi.encodePacked(prefix, hash));
1011         // solium-disable-next-line arg-overflow
1012         return ecrecover(toEthSignedMessageHash(hash), v, r, s);
1013     }
1014 }
1015 
1016 
1017 
1018 
1019 /// @title Contains 512-bit math functions
1020 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1021 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1022 library FullMath {
1023     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1024     /// @param a The multiplicand
1025     /// @param b The multiplier
1026     /// @param denominator The divisor
1027     /// @return result The 256-bit result
1028     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1029     function mulDiv(
1030         uint256 a,
1031         uint256 b,
1032         uint256 denominator
1033     ) internal pure returns (uint256 result) {
1034         // 512-bit multiply [prod1 prod0] = a * b
1035         // Compute the product mod 2**256 and mod 2**256 - 1
1036         // then use the Chinese Remainder Theorem to reconstruct
1037         // the 512 bit result. The result is stored in two 256
1038         // variables such that product = prod1 * 2**256 + prod0
1039         uint256 prod0; // Least significant 256 bits of the product
1040         uint256 prod1; // Most significant 256 bits of the product
1041         assembly {
1042             let mm := mulmod(a, b, not(0))
1043             prod0 := mul(a, b)
1044             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1045         }
1046 
1047         // Handle non-overflow cases, 256 by 256 division
1048         if (prod1 == 0) {
1049             require(denominator > 0);
1050             assembly {
1051                 result := div(prod0, denominator)
1052             }
1053             return result;
1054         }
1055 
1056         // Make sure the result is less than 2**256.
1057         // Also prevents denominator == 0
1058         require(denominator > prod1);
1059 
1060         ///////////////////////////////////////////////
1061         // 512 by 256 division.
1062         ///////////////////////////////////////////////
1063 
1064         // Make division exact by subtracting the remainder from [prod1 prod0]
1065         // Compute remainder using mulmod
1066         uint256 remainder;
1067         assembly {
1068             remainder := mulmod(a, b, denominator)
1069         }
1070         // Subtract 256 bit number from 512 bit number
1071         assembly {
1072             prod1 := sub(prod1, gt(remainder, prod0))
1073             prod0 := sub(prod0, remainder)
1074         }
1075 
1076         // Factor powers of two out of denominator
1077         // Compute largest power of two divisor of denominator.
1078         // Always >= 1.
1079         uint256 twos = (type(uint256).max - denominator + 1) & denominator;
1080         // Divide denominator by power of two
1081         assembly {
1082             denominator := div(denominator, twos)
1083         }
1084 
1085         // Divide [prod1 prod0] by the factors of two
1086         assembly {
1087             prod0 := div(prod0, twos)
1088         }
1089         // Shift in bits from prod1 into prod0. For this we need
1090         // to flip `twos` such that it is 2**256 / twos.
1091         // If twos is zero, then it becomes one
1092         assembly {
1093             twos := add(div(sub(0, twos), twos), 1)
1094         }
1095         prod0 |= prod1 * twos;
1096 
1097         // Invert denominator mod 2**256
1098         // Now that denominator is an odd number, it has an inverse
1099         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
1100         // Compute the inverse by starting with a seed that is correct
1101         // correct for four bits. That is, denominator * inv = 1 mod 2**4
1102         uint256 inv = (3 * denominator) ^ 2;
1103         // Now use Newton-Raphson iteration to improve the precision.
1104         // Thanks to Hensel's lifting lemma, this also works in modular
1105         // arithmetic, doubling the correct bits in each step.
1106         inv *= 2 - denominator * inv; // inverse mod 2**8
1107         inv *= 2 - denominator * inv; // inverse mod 2**16
1108         inv *= 2 - denominator * inv; // inverse mod 2**32
1109         inv *= 2 - denominator * inv; // inverse mod 2**64
1110         inv *= 2 - denominator * inv; // inverse mod 2**128
1111         inv *= 2 - denominator * inv; // inverse mod 2**256
1112 
1113         // Because the division is now exact we can divide by multiplying
1114         // with the modular inverse of denominator. This will give us the
1115         // correct result modulo 2**256. Since the precoditions guarantee
1116         // that the outcome is less than 2**256, this is the final result.
1117         // We don't need to compute the high bits of the result and prod1
1118         // is no longer required.
1119         result = prod0 * inv;
1120         return result;
1121     }
1122 }
1123 
1124 
1125 abstract contract Storage is AccessControl, Pausable, ECDSAOffsetRecovery{
1126     bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
1127     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1128     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
1129     bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
1130 
1131     uint128 public numOfThisBlockchain;
1132     address public blockchainRouter;
1133     mapping(uint256 => bytes32) public RubicAddresses;
1134     mapping(uint256 => bool) public existingOtherBlockchain;
1135     mapping(uint256 => uint256) public feeAmountOfBlockchain;
1136     mapping(uint256 => uint256) public blockchainCryptoFee;
1137 
1138     uint256 public constant SIGNATURE_LENGTH = 65;
1139 
1140     mapping(bytes32 => uint256) public processedTransactions;
1141     uint256 public minConfirmationSignatures = 3;
1142 
1143     uint256 public minTokenAmount;
1144     uint256 public maxTokenAmount;
1145     uint256 public maxGasPrice;
1146     uint256 public minConfirmationBlocks;
1147     uint256 public refundSlippage;
1148 
1149     uint256 public accTokenFee = 1;
1150 }
1151 
1152 abstract contract MainBase is Storage{
1153     using Address for address payable;
1154     using SafeERC20 for IERC20;
1155 
1156     bytes32 internal constant IMPLEMENTATION_MAPPING_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1157 
1158 
1159     struct Implementation{
1160         address router;
1161         address _address;
1162     }
1163 
1164     /**
1165      * @dev throws if transaction sender is not in owner role
1166      */
1167     modifier onlyOwner() {
1168         require(
1169             hasRole(OWNER_ROLE, _msgSender()),
1170             "Caller is not in owner role"
1171         );
1172         _;
1173     }
1174 
1175     /**
1176      * @dev throws if transaction sender is not in owner or manager role
1177      */
1178     modifier onlyOwnerAndManager() {
1179         require(
1180             hasRole(OWNER_ROLE, _msgSender()) ||
1181                 hasRole(MANAGER_ROLE, _msgSender()),
1182             "Caller is not in owner or manager role"
1183         );
1184         _;
1185     }
1186 
1187     /**
1188      * @dev throws if transaction sender is not in relayer role
1189      */
1190     modifier onlyRelayer() {
1191         require(
1192             hasRole(RELAYER_ROLE, _msgSender()),
1193             "swapContract: Caller is not in relayer role"
1194         );
1195         _;
1196     }
1197 
1198     modifier onlyOwnerAndManagerAndRelayer(){
1199         require(
1200             hasRole(OWNER_ROLE, _msgSender()) ||
1201             hasRole(MANAGER_ROLE, _msgSender()) ||
1202             hasRole(RELAYER_ROLE, _msgSender()),
1203             "swapContract: not ownr mngr rlyr"
1204         );
1205         _;
1206     }
1207 
1208     function getOtherBlockchainAvailableByNum(uint256 blockchain)
1209         external
1210         view
1211         returns (bool)
1212     {
1213         return existingOtherBlockchain[blockchain];
1214     }
1215 
1216     /**
1217      * @dev Registers another blockchain for availability to swap
1218      * @param numOfOtherBlockchain number of blockchain
1219      */
1220     function addOtherBlockchain(uint128 numOfOtherBlockchain)
1221         external
1222         onlyOwner
1223     {
1224         require(
1225             numOfOtherBlockchain != numOfThisBlockchain,
1226             "swapContract: Cannot add this blockchain to array of other blockchains"
1227         );
1228         require(
1229             !existingOtherBlockchain[numOfOtherBlockchain],
1230             "swapContract: This blockchain is already added"
1231         );
1232         existingOtherBlockchain[numOfOtherBlockchain] = true;
1233     }
1234 
1235     /**
1236      * @dev Unregisters another blockchain for availability to swap
1237      * @param numOfOtherBlockchain number of blockchain
1238      */
1239     function removeOtherBlockchain(uint128 numOfOtherBlockchain)
1240         external
1241         onlyOwner
1242     {
1243         require(
1244             existingOtherBlockchain[numOfOtherBlockchain],
1245             "swapContract: This blockchain was not added"
1246         );
1247         existingOtherBlockchain[numOfOtherBlockchain] = false;
1248     }
1249 
1250     /**
1251      * @dev Change existing blockchain id
1252      * @param oldNumOfOtherBlockchain number of existing blockchain
1253      * @param newNumOfOtherBlockchain number of new blockchain
1254      */
1255     function changeOtherBlockchain(
1256         uint128 oldNumOfOtherBlockchain,
1257         uint128 newNumOfOtherBlockchain
1258     ) external onlyOwner {
1259         require(
1260             oldNumOfOtherBlockchain != newNumOfOtherBlockchain,
1261             "swapContract: Cannot change blockchains with same number"
1262         );
1263         require(
1264             newNumOfOtherBlockchain != numOfThisBlockchain,
1265             "swapContract: Cannot add this blockchain to array of other blockchains"
1266         );
1267         require(
1268             existingOtherBlockchain[oldNumOfOtherBlockchain],
1269             "swapContract: This blockchain was not added"
1270         );
1271         require(
1272             !existingOtherBlockchain[newNumOfOtherBlockchain],
1273             "swapContract: This blockchain is already added"
1274         );
1275 
1276         existingOtherBlockchain[oldNumOfOtherBlockchain] = false;
1277         existingOtherBlockchain[newNumOfOtherBlockchain] = true;
1278     }
1279 
1280     // FEE MANAGEMENT
1281 
1282     /**
1283      * @dev Sends collected crypto fee to the owner
1284      */
1285     function collectCryptoFee(address toAddress) external onlyOwner {
1286         require(isRelayer(toAddress), 'swapContract: fee can be sent only to a relayer');
1287         payable(toAddress).sendValue(address(this).balance);
1288     }
1289 
1290     /**
1291      * @dev Sends collected token fee to the owner
1292      */
1293     function collectTokenFee() external onlyOwner {
1294         IERC20 _Rubic = IERC20(address(uint160(uint256(RubicAddresses[numOfThisBlockchain]))));
1295         _Rubic.safeTransfer(
1296             msg.sender,
1297             accTokenFee - 1
1298         );
1299         accTokenFee = 1; //GAS savings
1300     }
1301 
1302     /**
1303      * @dev Changes fee values for blockchains in feeAmountOfBlockchain variables
1304      * @notice fee is represented as hundredths of a bip, i.e. 1e-6
1305      * @param _blockchainNum Existing number of blockchain
1306      * @param feeAmount Fee amount to substruct from transfer amount
1307      */
1308     function setFeeAmountOfBlockchain(uint128 _blockchainNum, uint256 feeAmount)
1309         external
1310         onlyOwnerAndManager
1311     {
1312         feeAmountOfBlockchain[_blockchainNum] = feeAmount;
1313     }
1314 
1315     /**
1316      * @dev Changes crypto fee values for blockchains in blockchainCryptoFee variables
1317      * @param _blockchainNum Existing number of blockchain
1318      * @param feeAmount Fee amount that must be sent calling transferToOtherBlockchain
1319      */
1320     function setCryptoFeeOfBlockchain(uint128 _blockchainNum, uint256 feeAmount)
1321         external
1322         onlyOwnerAndManagerAndRelayer
1323     {
1324         blockchainCryptoFee[_blockchainNum] = feeAmount;
1325     }
1326 
1327     /**
1328      * @dev Changes the address of Rubic in the certain blockchain
1329      * @param _blockchainNum Existing number of blockchain
1330      * @param _RubicAddress The Rubic address
1331      */
1332     function setRubicAddressOfBlockchain(
1333         uint128 _blockchainNum,
1334         bytes32 _RubicAddress
1335     ) external onlyOwnerAndManager {
1336         RubicAddresses[_blockchainNum] = _RubicAddress;
1337     }
1338 
1339     /**
1340      * @dev Approves tokens to a swap Router. We can approve the most popular tokens before any swaps
1341      * To spare users from paying for it
1342      * @param _token The token address to approve
1343      */
1344     function approveTokenToRouter(IERC20 _token, address _router) external onlyOwnerAndManager{
1345         _token.approve(_router, type(uint256).max);
1346     }
1347 
1348     /**
1349      * @dev With this function owner, which is a multisig account, can withdraw some RBC from the pool
1350      * @param amount The amount to withdraw
1351      */
1352     function poolBalancing(uint256 amount) external onlyOwner{
1353         IERC20(address(uint160(uint256(RubicAddresses[numOfThisBlockchain])))).transfer(msg.sender, amount);
1354     }
1355 
1356     // VALIDATOR CONFIRMATIONS MANAGEMENT
1357 
1358     /**
1359      * @dev Changes requirement for minimal amount of signatures to validate on transfer
1360      * @param _minConfirmationSignatures Number of signatures to verify
1361      */
1362     function setMinConfirmationSignatures(uint256 _minConfirmationSignatures)
1363         external
1364         onlyOwner
1365     {
1366         require(
1367             _minConfirmationSignatures > 0,
1368             "swapContract: At least 1 confirmation can be set"
1369         );
1370         minConfirmationSignatures = _minConfirmationSignatures;
1371     }
1372 
1373     /**
1374      * @dev Changes requirement for minimal token amount on transfers
1375      * @param _minTokenAmount Amount of tokens
1376      */
1377     function setMinTokenAmount(uint256 _minTokenAmount)
1378         external
1379         onlyOwnerAndManager
1380     {
1381         minTokenAmount = _minTokenAmount;
1382     }
1383 
1384     /**
1385      * @dev Changes requirement for maximum token amount on transfers
1386      * @param _maxTokenAmount Amount of tokens
1387      */
1388     function setMaxTokenAmount(uint256 _maxTokenAmount)
1389         external
1390         onlyOwnerAndManager
1391     {
1392         maxTokenAmount = _maxTokenAmount;
1393     }
1394 
1395     /**
1396      * @dev Changes parameter of maximum gas price on which relayer nodes will operate
1397      * @param _maxGasPrice Price of gas in wei
1398      */
1399     function setMaxGasPrice(uint256 _maxGasPrice) external onlyOwnerAndManager {
1400         require(_maxGasPrice > 0, "swapContract: Gas price cannot be zero");
1401         maxGasPrice = _maxGasPrice;
1402     }
1403 
1404     /**
1405      * @dev Changes requirement for minimal amount of block to consider tx confirmed on validator
1406      * @param _minConfirmationBlocks Amount of blocks
1407      */
1408 
1409     function setMinConfirmationBlocks(uint256 _minConfirmationBlocks)
1410         external
1411         onlyOwnerAndManager
1412     {
1413         minConfirmationBlocks = _minConfirmationBlocks;
1414     }
1415 
1416     function setRefundSlippage(uint256 _refundSlippage)
1417         external
1418         onlyOwnerAndManager
1419     {
1420         refundSlippage = _refundSlippage;
1421     }
1422 
1423     /**
1424      * @dev Transfers permissions of contract ownership.
1425      * Will setup new owner and one manager on contract.
1426      * Main purpose of this function is to transfer ownership from deployer account ot real owner
1427      * @param newOwner Address of new owner
1428      * @param newManager Address of new manager
1429      */
1430     function transferOwnerAndSetManager(address newOwner, address newManager)
1431         external
1432         onlyOwner
1433     {
1434         require(
1435             newOwner != _msgSender(),
1436             "swapContract: New owner must be different than current"
1437         );
1438         require(
1439             newOwner != address(0x0),
1440             "swapContract: Owner cannot be zero address"
1441         );
1442         require(
1443             newManager != address(0x0),
1444             "swapContract: Owner cannot be zero address"
1445         );
1446         _setupRole(DEFAULT_ADMIN_ROLE, newOwner);
1447         _setupRole(OWNER_ROLE, newOwner);
1448         _setupRole(MANAGER_ROLE, newManager);
1449         renounceRole(OWNER_ROLE, _msgSender());
1450         renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
1451     }
1452 
1453     /**
1454      * @dev Pauses transfers of tokens on contract
1455      */
1456     function pauseExecution() external onlyOwner {
1457         _pause();
1458     }
1459 
1460     /**
1461      * @dev Resumes transfers of tokens on contract
1462      */
1463     function continueExecution() external onlyOwner {
1464         _unpause();
1465     }
1466 
1467     /**
1468      * @dev Function to check if address is belongs to owner role
1469      * @param account Address to check
1470      */
1471     function isOwner(address account) public view returns (bool) {
1472         return hasRole(OWNER_ROLE, account);
1473     }
1474 
1475     /**
1476      * @dev Function to check if address is belongs to manager role
1477      * @param account Address to check
1478      */
1479     function isManager(address account) public view returns (bool) {
1480         return hasRole(MANAGER_ROLE, account);
1481     }
1482 
1483     /**
1484      * @dev Function to check if address is belongs to relayer role
1485      * @param account Address to check
1486      */
1487     function isRelayer(address account) public view returns (bool) {
1488         return hasRole(RELAYER_ROLE, account);
1489     }
1490 
1491     /**
1492      * @dev Function to check if address is belongs to validator role
1493      * @param account Address to check
1494      *
1495      */
1496     function isValidator(address account) public view returns (bool) {
1497         return hasRole(VALIDATOR_ROLE, account);
1498     }
1499 
1500     /**
1501      * @dev Function changes values associated with certain originalTxHash
1502      * @param originalTxHash Transaction hash to change
1503      * @param statusCode Associated status: 0-Not processed, 1-Processed, 2-Reverted
1504      */
1505     function changeTxStatus(
1506         bytes32 originalTxHash,
1507         uint256 statusCode
1508     ) external onlyRelayer {
1509         require(
1510             statusCode != 0,
1511             "swapContract: you cannot set the statusCode to 0"
1512         );
1513         require(
1514             processedTransactions[originalTxHash] != 1,
1515             "swapContract: transaction with this originalTxHash has already been set as succeed"
1516         );
1517         processedTransactions[originalTxHash] = statusCode;
1518     }
1519 
1520     /**
1521      * @dev Plain fallback function to receive crypto
1522      */
1523     receive() external payable {}
1524 }
1525 
1526 contract MainContract is MainBase{
1527     constructor(
1528         uint128 _numOfThisBlockchain,
1529         uint128[] memory _numsOfOtherBlockchains,
1530         uint256[] memory tokenLimits,
1531         uint256 _maxGasPrice,
1532         uint256 _minConfirmationBlocks,
1533         uint256 _refundSlippage,
1534         bytes32[] memory _RubicAddresses
1535     ) {
1536         for (uint256 i = 0; i < _numsOfOtherBlockchains.length; i++) {
1537             require(
1538                 _numsOfOtherBlockchains[i] != _numOfThisBlockchain,
1539                 "swapContract: Number of this blockchain is in array of other blockchains"
1540             );
1541             existingOtherBlockchain[_numsOfOtherBlockchains[i]] = true;
1542         }
1543 
1544         for (uint256 i = 0; i < _RubicAddresses.length; i++) {
1545             RubicAddresses[i + 1] = _RubicAddresses[i];
1546         }
1547 
1548         require(_maxGasPrice > 0, "swapContract: Gas price cannot be zero");
1549 
1550         numOfThisBlockchain = _numOfThisBlockchain;
1551         minTokenAmount = tokenLimits[0];
1552         maxTokenAmount = tokenLimits[1];
1553         maxGasPrice = _maxGasPrice;
1554         refundSlippage = _refundSlippage;
1555         minConfirmationBlocks = _minConfirmationBlocks;
1556         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1557         _setupRole(OWNER_ROLE, _msgSender());
1558     }
1559 
1560     function getStorageValue(bytes4 sig, bytes32 slot) internal view returns (Implementation storage impl) {
1561         assembly {
1562             // Store num in memory scratch space (note: lookup "free memory pointer" if you need to allocate space)
1563             mstore(0, sig)
1564             // Store slot number in scratch space after num
1565             mstore(32, slot)
1566             // Create hash from previously stored num and slot
1567             let hash := keccak256(0, 64)
1568             // Load mapping value using the just calculated hash
1569             impl.slot := hash
1570         }
1571     }
1572 
1573     function getInfoAboutSig(bytes4 sig, bytes32 slot) external view returns(
1574         address implementationAddress,
1575         address router
1576     ){
1577         Implementation storage impl;
1578         assembly {
1579             // Store num in memory scratch space (note: lookup "free memory pointer" if you need to allocate space)
1580             mstore(0, sig)
1581             // Store slot number in scratch space after num
1582             mstore(32, slot)
1583             // Create hash from previously stored num and slot
1584             let hash := keccak256(0, 64)
1585             // Load mapping value using the just calculated hash
1586             impl.slot := hash
1587         }
1588         implementationAddress = impl._address;
1589         router = impl.router;
1590     }
1591 
1592     function addInstance(
1593         bytes4 sig,
1594         address _address,
1595         address _router
1596     ) external onlyOwner{
1597         Implementation storage impl = getStorageValue(sig, IMPLEMENTATION_MAPPING_SLOT);
1598         impl._address = _address;
1599         impl.router = _router;
1600         IERC20(address(uint160(uint256(RubicAddresses[numOfThisBlockchain])))).approve(
1601             _router,
1602             type(uint256).max
1603         );
1604     }
1605 
1606     function setRouter(bytes4 sig, address _router) external onlyOwnerAndManager{
1607         require(_router != address(0), 'router cannot be zero');
1608         Implementation storage impl = getStorageValue(sig, IMPLEMENTATION_MAPPING_SLOT);
1609         impl.router = _router;
1610         IERC20(address(uint160(uint256(RubicAddresses[numOfThisBlockchain])))).approve(
1611             _router,
1612             type(uint256).max
1613         );
1614     }
1615 
1616     fallback() external payable{
1617         Implementation storage impl = getStorageValue(msg.sig, IMPLEMENTATION_MAPPING_SLOT);
1618         address implementation = impl._address;
1619         blockchainRouter = impl.router;
1620         require(blockchainRouter != address(0), 'no instanceaAbb');
1621         assembly{
1622             // Copy msg.data. We take full control of memory in this inline assembly
1623             // block because it will not return to Solidity code. We overwrite the
1624             // Solidity scratch pad at memory position 0.
1625             calldatacopy(0, 0, calldatasize())
1626 
1627             // Call the implementation.
1628             // out and outsize are 0 because we don't know the size yet.
1629             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
1630 
1631             // Copy the returned data.
1632             returndatacopy(0, 0, returndatasize())
1633 
1634             switch result
1635             // delegatecall returns 0 on error.
1636             case 0 {
1637                 revert(0, returndatasize())
1638             }
1639             default {
1640                 return(0, returndatasize())
1641             }
1642         }
1643     }
1644 }