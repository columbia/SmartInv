1 // Sources flattened with hardhat v2.8.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
90 
91 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Collection of functions related to the address type
97  */
98 library Address {
99     /**
100      * @dev Returns true if `account` is a contract.
101      *
102      * [IMPORTANT]
103      * ====
104      * It is unsafe to assume that an address for which this function returns
105      * false is an externally-owned account (EOA) and not a contract.
106      *
107      * Among others, `isContract` will return false for the following
108      * types of addresses:
109      *
110      *  - an externally-owned account
111      *  - a contract in construction
112      *  - an address where a contract will be created
113      *  - an address where a contract lived, but was destroyed
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize, which returns 0 for contracts in
118         // construction, since the code is only stored at the end of the
119         // constructor execution.
120 
121         uint256 size;
122         assembly {
123             size := extcodesize(account)
124         }
125         return size > 0;
126     }
127 
128     /**
129      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
130      * `recipient`, forwarding all available gas and reverting on errors.
131      *
132      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
133      * of certain opcodes, possibly making contracts go over the 2300 gas limit
134      * imposed by `transfer`, making them unable to receive funds via
135      * `transfer`. {sendValue} removes this limitation.
136      *
137      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
138      *
139      * IMPORTANT: because control is transferred to `recipient`, care must be
140      * taken to not create reentrancy vulnerabilities. Consider using
141      * {ReentrancyGuard} or the
142      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
143      */
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(address(this).balance >= amount, "Address: insufficient balance");
146 
147         (bool success, ) = recipient.call{value: amount}("");
148         require(success, "Address: unable to send value, recipient may have reverted");
149     }
150 
151     /**
152      * @dev Performs a Solidity function call using a low level `call`. A
153      * plain `call` is an unsafe replacement for a function call: use this
154      * function instead.
155      *
156      * If `target` reverts with a revert reason, it is bubbled up by this
157      * function (like regular Solidity function calls).
158      *
159      * Returns the raw returned data. To convert to the expected return value,
160      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
161      *
162      * Requirements:
163      *
164      * - `target` must be a contract.
165      * - calling `target` with `data` must not revert.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionCall(target, data, "Address: low-level call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
175      * `errorMessage` as a fallback revert reason when `target` reverts.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, 0, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but also transferring `value` wei to `target`.
190      *
191      * Requirements:
192      *
193      * - the calling contract must have an ETH balance of at least `value`.
194      * - the called Solidity function must be `payable`.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
208      * with `errorMessage` as a fallback revert reason when `target` reverts.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(address(this).balance >= value, "Address: insufficient balance for call");
219         require(isContract(target), "Address: call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.call{value: value}(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
232         return functionStaticCall(target, data, "Address: low-level static call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal view returns (bytes memory) {
246         require(isContract(target), "Address: static call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.staticcall(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(isContract(target), "Address: delegate call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.delegatecall(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
281      * revert reason using the provided one.
282      *
283      * _Available since v4.3._
284      */
285     function verifyCallResult(
286         bool success,
287         bytes memory returndata,
288         string memory errorMessage
289     ) internal pure returns (bytes memory) {
290         if (success) {
291             return returndata;
292         } else {
293             // Look for revert reason and bubble it up if present
294             if (returndata.length > 0) {
295                 // The easiest way to bubble the revert reason is using memory via assembly
296 
297                 assembly {
298                     let returndata_size := mload(returndata)
299                     revert(add(32, returndata), returndata_size)
300                 }
301             } else {
302                 revert(errorMessage);
303             }
304         }
305     }
306 }
307 
308 
309 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.4.2
310 
311 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 
316 /**
317  * @title SafeERC20
318  * @dev Wrappers around ERC20 operations that throw on failure (when the token
319  * contract returns false). Tokens that return no value (and instead revert or
320  * throw on failure) are also supported, non-reverting calls are assumed to be
321  * successful.
322  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
323  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
324  */
325 library SafeERC20 {
326     using Address for address;
327 
328     function safeTransfer(
329         IERC20 token,
330         address to,
331         uint256 value
332     ) internal {
333         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
334     }
335 
336     function safeTransferFrom(
337         IERC20 token,
338         address from,
339         address to,
340         uint256 value
341     ) internal {
342         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
343     }
344 
345     /**
346      * @dev Deprecated. This function has issues similar to the ones found in
347      * {IERC20-approve}, and its usage is discouraged.
348      *
349      * Whenever possible, use {safeIncreaseAllowance} and
350      * {safeDecreaseAllowance} instead.
351      */
352     function safeApprove(
353         IERC20 token,
354         address spender,
355         uint256 value
356     ) internal {
357         // safeApprove should only be called when setting an initial allowance,
358         // or when resetting it to zero. To increase and decrease it, use
359         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
360         require(
361             (value == 0) || (token.allowance(address(this), spender) == 0),
362             "SafeERC20: approve from non-zero to non-zero allowance"
363         );
364         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
365     }
366 
367     function safeIncreaseAllowance(
368         IERC20 token,
369         address spender,
370         uint256 value
371     ) internal {
372         uint256 newAllowance = token.allowance(address(this), spender) + value;
373         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
374     }
375 
376     function safeDecreaseAllowance(
377         IERC20 token,
378         address spender,
379         uint256 value
380     ) internal {
381         unchecked {
382             uint256 oldAllowance = token.allowance(address(this), spender);
383             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
384             uint256 newAllowance = oldAllowance - value;
385             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
386         }
387     }
388 
389     /**
390      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
391      * on the return value: the return value is optional (but if data is returned, it must not be false).
392      * @param token The token targeted by the call.
393      * @param data The call data (encoded using abi.encode or one of its variants).
394      */
395     function _callOptionalReturn(IERC20 token, bytes memory data) private {
396         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
397         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
398         // the target address contains contract code and also asserts for success in the low-level call.
399 
400         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
401         if (returndata.length > 0) {
402             // Return data is optional
403             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
404         }
405     }
406 }
407 
408 
409 // File contracts/interfaces/IBasePool.sol
410 
411 pragma solidity 0.8.7;
412 interface IBasePool {
413     function distributeRewards(uint256 _amount) external;
414 }
415 
416 
417 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.4.2
418 
419 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev External interface of AccessControl declared to support ERC165 detection.
425  */
426 interface IAccessControl {
427     /**
428      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
429      *
430      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
431      * {RoleAdminChanged} not being emitted signaling this.
432      *
433      * _Available since v3.1._
434      */
435     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
436 
437     /**
438      * @dev Emitted when `account` is granted `role`.
439      *
440      * `sender` is the account that originated the contract call, an admin role
441      * bearer except when using {AccessControl-_setupRole}.
442      */
443     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
444 
445     /**
446      * @dev Emitted when `account` is revoked `role`.
447      *
448      * `sender` is the account that originated the contract call:
449      *   - if using `revokeRole`, it is the admin role bearer
450      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
451      */
452     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
453 
454     /**
455      * @dev Returns `true` if `account` has been granted `role`.
456      */
457     function hasRole(bytes32 role, address account) external view returns (bool);
458 
459     /**
460      * @dev Returns the admin role that controls `role`. See {grantRole} and
461      * {revokeRole}.
462      *
463      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
464      */
465     function getRoleAdmin(bytes32 role) external view returns (bytes32);
466 
467     /**
468      * @dev Grants `role` to `account`.
469      *
470      * If `account` had not been already granted `role`, emits a {RoleGranted}
471      * event.
472      *
473      * Requirements:
474      *
475      * - the caller must have ``role``'s admin role.
476      */
477     function grantRole(bytes32 role, address account) external;
478 
479     /**
480      * @dev Revokes `role` from `account`.
481      *
482      * If `account` had been granted `role`, emits a {RoleRevoked} event.
483      *
484      * Requirements:
485      *
486      * - the caller must have ``role``'s admin role.
487      */
488     function revokeRole(bytes32 role, address account) external;
489 
490     /**
491      * @dev Revokes `role` from the calling account.
492      *
493      * Roles are often managed via {grantRole} and {revokeRole}: this function's
494      * purpose is to provide a mechanism for accounts to lose their privileges
495      * if they are compromised (such as when a trusted device is misplaced).
496      *
497      * If the calling account had been granted `role`, emits a {RoleRevoked}
498      * event.
499      *
500      * Requirements:
501      *
502      * - the caller must be `account`.
503      */
504     function renounceRole(bytes32 role, address account) external;
505 }
506 
507 
508 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.4.2
509 
510 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
516  */
517 interface IAccessControlEnumerable is IAccessControl {
518     /**
519      * @dev Returns one of the accounts that have `role`. `index` must be a
520      * value between 0 and {getRoleMemberCount}, non-inclusive.
521      *
522      * Role bearers are not sorted in any particular way, and their ordering may
523      * change at any point.
524      *
525      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
526      * you perform all queries on the same block. See the following
527      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
528      * for more information.
529      */
530     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
531 
532     /**
533      * @dev Returns the number of accounts that have `role`. Can be used
534      * together with {getRoleMember} to enumerate all bearers of a role.
535      */
536     function getRoleMemberCount(bytes32 role) external view returns (uint256);
537 }
538 
539 
540 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
541 
542 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Provides information about the current execution context, including the
548  * sender of the transaction and its data. While these are generally available
549  * via msg.sender and msg.data, they should not be accessed in such a direct
550  * manner, since when dealing with meta-transactions the account sending and
551  * paying for execution may not be the actual sender (as far as an application
552  * is concerned).
553  *
554  * This contract is only required for intermediate, library-like contracts.
555  */
556 abstract contract Context {
557     function _msgSender() internal view virtual returns (address) {
558         return msg.sender;
559     }
560 
561     function _msgData() internal view virtual returns (bytes calldata) {
562         return msg.data;
563     }
564 }
565 
566 
567 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
568 
569 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev String operations.
575  */
576 library Strings {
577     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
578 
579     /**
580      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
581      */
582     function toString(uint256 value) internal pure returns (string memory) {
583         // Inspired by OraclizeAPI's implementation - MIT licence
584         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
585 
586         if (value == 0) {
587             return "0";
588         }
589         uint256 temp = value;
590         uint256 digits;
591         while (temp != 0) {
592             digits++;
593             temp /= 10;
594         }
595         bytes memory buffer = new bytes(digits);
596         while (value != 0) {
597             digits -= 1;
598             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
599             value /= 10;
600         }
601         return string(buffer);
602     }
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
606      */
607     function toHexString(uint256 value) internal pure returns (string memory) {
608         if (value == 0) {
609             return "0x00";
610         }
611         uint256 temp = value;
612         uint256 length = 0;
613         while (temp != 0) {
614             length++;
615             temp >>= 8;
616         }
617         return toHexString(value, length);
618     }
619 
620     /**
621      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
622      */
623     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
624         bytes memory buffer = new bytes(2 * length + 2);
625         buffer[0] = "0";
626         buffer[1] = "x";
627         for (uint256 i = 2 * length + 1; i > 1; --i) {
628             buffer[i] = _HEX_SYMBOLS[value & 0xf];
629             value >>= 4;
630         }
631         require(value == 0, "Strings: hex length insufficient");
632         return string(buffer);
633     }
634 }
635 
636 
637 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
638 
639 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Interface of the ERC165 standard, as defined in the
645  * https://eips.ethereum.org/EIPS/eip-165[EIP].
646  *
647  * Implementers can declare support of contract interfaces, which can then be
648  * queried by others ({ERC165Checker}).
649  *
650  * For an implementation, see {ERC165}.
651  */
652 interface IERC165 {
653     /**
654      * @dev Returns true if this contract implements the interface defined by
655      * `interfaceId`. See the corresponding
656      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
657      * to learn more about how these ids are created.
658      *
659      * This function call must use less than 30 000 gas.
660      */
661     function supportsInterface(bytes4 interfaceId) external view returns (bool);
662 }
663 
664 
665 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Implementation of the {IERC165} interface.
673  *
674  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
675  * for the additional interface id that will be supported. For example:
676  *
677  * ```solidity
678  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
680  * }
681  * ```
682  *
683  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
684  */
685 abstract contract ERC165 is IERC165 {
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690         return interfaceId == type(IERC165).interfaceId;
691     }
692 }
693 
694 
695 // File @openzeppelin/contracts/access/AccessControl.sol@v4.4.2
696 
697 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 
702 
703 
704 /**
705  * @dev Contract module that allows children to implement role-based access
706  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
707  * members except through off-chain means by accessing the contract event logs. Some
708  * applications may benefit from on-chain enumerability, for those cases see
709  * {AccessControlEnumerable}.
710  *
711  * Roles are referred to by their `bytes32` identifier. These should be exposed
712  * in the external API and be unique. The best way to achieve this is by
713  * using `public constant` hash digests:
714  *
715  * ```
716  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
717  * ```
718  *
719  * Roles can be used to represent a set of permissions. To restrict access to a
720  * function call, use {hasRole}:
721  *
722  * ```
723  * function foo() public {
724  *     require(hasRole(MY_ROLE, msg.sender));
725  *     ...
726  * }
727  * ```
728  *
729  * Roles can be granted and revoked dynamically via the {grantRole} and
730  * {revokeRole} functions. Each role has an associated admin role, and only
731  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
732  *
733  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
734  * that only accounts with this role will be able to grant or revoke other
735  * roles. More complex role relationships can be created by using
736  * {_setRoleAdmin}.
737  *
738  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
739  * grant and revoke this role. Extra precautions should be taken to secure
740  * accounts that have been granted it.
741  */
742 abstract contract AccessControl is Context, IAccessControl, ERC165 {
743     struct RoleData {
744         mapping(address => bool) members;
745         bytes32 adminRole;
746     }
747 
748     mapping(bytes32 => RoleData) private _roles;
749 
750     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
751 
752     /**
753      * @dev Modifier that checks that an account has a specific role. Reverts
754      * with a standardized message including the required role.
755      *
756      * The format of the revert reason is given by the following regular expression:
757      *
758      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
759      *
760      * _Available since v4.1._
761      */
762     modifier onlyRole(bytes32 role) {
763         _checkRole(role, _msgSender());
764         _;
765     }
766 
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
772     }
773 
774     /**
775      * @dev Returns `true` if `account` has been granted `role`.
776      */
777     function hasRole(bytes32 role, address account) public view override returns (bool) {
778         return _roles[role].members[account];
779     }
780 
781     /**
782      * @dev Revert with a standard message if `account` is missing `role`.
783      *
784      * The format of the revert reason is given by the following regular expression:
785      *
786      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
787      */
788     function _checkRole(bytes32 role, address account) internal view {
789         if (!hasRole(role, account)) {
790             revert(
791                 string(
792                     abi.encodePacked(
793                         "AccessControl: account ",
794                         Strings.toHexString(uint160(account), 20),
795                         " is missing role ",
796                         Strings.toHexString(uint256(role), 32)
797                     )
798                 )
799             );
800         }
801     }
802 
803     /**
804      * @dev Returns the admin role that controls `role`. See {grantRole} and
805      * {revokeRole}.
806      *
807      * To change a role's admin, use {_setRoleAdmin}.
808      */
809     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
810         return _roles[role].adminRole;
811     }
812 
813     /**
814      * @dev Grants `role` to `account`.
815      *
816      * If `account` had not been already granted `role`, emits a {RoleGranted}
817      * event.
818      *
819      * Requirements:
820      *
821      * - the caller must have ``role``'s admin role.
822      */
823     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
824         _grantRole(role, account);
825     }
826 
827     /**
828      * @dev Revokes `role` from `account`.
829      *
830      * If `account` had been granted `role`, emits a {RoleRevoked} event.
831      *
832      * Requirements:
833      *
834      * - the caller must have ``role``'s admin role.
835      */
836     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
837         _revokeRole(role, account);
838     }
839 
840     /**
841      * @dev Revokes `role` from the calling account.
842      *
843      * Roles are often managed via {grantRole} and {revokeRole}: this function's
844      * purpose is to provide a mechanism for accounts to lose their privileges
845      * if they are compromised (such as when a trusted device is misplaced).
846      *
847      * If the calling account had been revoked `role`, emits a {RoleRevoked}
848      * event.
849      *
850      * Requirements:
851      *
852      * - the caller must be `account`.
853      */
854     function renounceRole(bytes32 role, address account) public virtual override {
855         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
856 
857         _revokeRole(role, account);
858     }
859 
860     /**
861      * @dev Grants `role` to `account`.
862      *
863      * If `account` had not been already granted `role`, emits a {RoleGranted}
864      * event. Note that unlike {grantRole}, this function doesn't perform any
865      * checks on the calling account.
866      *
867      * [WARNING]
868      * ====
869      * This function should only be called from the constructor when setting
870      * up the initial roles for the system.
871      *
872      * Using this function in any other way is effectively circumventing the admin
873      * system imposed by {AccessControl}.
874      * ====
875      *
876      * NOTE: This function is deprecated in favor of {_grantRole}.
877      */
878     function _setupRole(bytes32 role, address account) internal virtual {
879         _grantRole(role, account);
880     }
881 
882     /**
883      * @dev Sets `adminRole` as ``role``'s admin role.
884      *
885      * Emits a {RoleAdminChanged} event.
886      */
887     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
888         bytes32 previousAdminRole = getRoleAdmin(role);
889         _roles[role].adminRole = adminRole;
890         emit RoleAdminChanged(role, previousAdminRole, adminRole);
891     }
892 
893     /**
894      * @dev Grants `role` to `account`.
895      *
896      * Internal function without access restriction.
897      */
898     function _grantRole(bytes32 role, address account) internal virtual {
899         if (!hasRole(role, account)) {
900             _roles[role].members[account] = true;
901             emit RoleGranted(role, account, _msgSender());
902         }
903     }
904 
905     /**
906      * @dev Revokes `role` from `account`.
907      *
908      * Internal function without access restriction.
909      */
910     function _revokeRole(bytes32 role, address account) internal virtual {
911         if (hasRole(role, account)) {
912             _roles[role].members[account] = false;
913             emit RoleRevoked(role, account, _msgSender());
914         }
915     }
916 }
917 
918 
919 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.4.2
920 
921 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 /**
926  * @dev Library for managing
927  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
928  * types.
929  *
930  * Sets have the following properties:
931  *
932  * - Elements are added, removed, and checked for existence in constant time
933  * (O(1)).
934  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
935  *
936  * ```
937  * contract Example {
938  *     // Add the library methods
939  *     using EnumerableSet for EnumerableSet.AddressSet;
940  *
941  *     // Declare a set state variable
942  *     EnumerableSet.AddressSet private mySet;
943  * }
944  * ```
945  *
946  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
947  * and `uint256` (`UintSet`) are supported.
948  */
949 library EnumerableSet {
950     // To implement this library for multiple types with as little code
951     // repetition as possible, we write it in terms of a generic Set type with
952     // bytes32 values.
953     // The Set implementation uses private functions, and user-facing
954     // implementations (such as AddressSet) are just wrappers around the
955     // underlying Set.
956     // This means that we can only create new EnumerableSets for types that fit
957     // in bytes32.
958 
959     struct Set {
960         // Storage of set values
961         bytes32[] _values;
962         // Position of the value in the `values` array, plus 1 because index 0
963         // means a value is not in the set.
964         mapping(bytes32 => uint256) _indexes;
965     }
966 
967     /**
968      * @dev Add a value to a set. O(1).
969      *
970      * Returns true if the value was added to the set, that is if it was not
971      * already present.
972      */
973     function _add(Set storage set, bytes32 value) private returns (bool) {
974         if (!_contains(set, value)) {
975             set._values.push(value);
976             // The value is stored at length-1, but we add 1 to all indexes
977             // and use 0 as a sentinel value
978             set._indexes[value] = set._values.length;
979             return true;
980         } else {
981             return false;
982         }
983     }
984 
985     /**
986      * @dev Removes a value from a set. O(1).
987      *
988      * Returns true if the value was removed from the set, that is if it was
989      * present.
990      */
991     function _remove(Set storage set, bytes32 value) private returns (bool) {
992         // We read and store the value's index to prevent multiple reads from the same storage slot
993         uint256 valueIndex = set._indexes[value];
994 
995         if (valueIndex != 0) {
996             // Equivalent to contains(set, value)
997             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
998             // the array, and then remove the last element (sometimes called as 'swap and pop').
999             // This modifies the order of the array, as noted in {at}.
1000 
1001             uint256 toDeleteIndex = valueIndex - 1;
1002             uint256 lastIndex = set._values.length - 1;
1003 
1004             if (lastIndex != toDeleteIndex) {
1005                 bytes32 lastvalue = set._values[lastIndex];
1006 
1007                 // Move the last value to the index where the value to delete is
1008                 set._values[toDeleteIndex] = lastvalue;
1009                 // Update the index for the moved value
1010                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1011             }
1012 
1013             // Delete the slot where the moved value was stored
1014             set._values.pop();
1015 
1016             // Delete the index for the deleted slot
1017             delete set._indexes[value];
1018 
1019             return true;
1020         } else {
1021             return false;
1022         }
1023     }
1024 
1025     /**
1026      * @dev Returns true if the value is in the set. O(1).
1027      */
1028     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1029         return set._indexes[value] != 0;
1030     }
1031 
1032     /**
1033      * @dev Returns the number of values on the set. O(1).
1034      */
1035     function _length(Set storage set) private view returns (uint256) {
1036         return set._values.length;
1037     }
1038 
1039     /**
1040      * @dev Returns the value stored at position `index` in the set. O(1).
1041      *
1042      * Note that there are no guarantees on the ordering of values inside the
1043      * array, and it may change when more values are added or removed.
1044      *
1045      * Requirements:
1046      *
1047      * - `index` must be strictly less than {length}.
1048      */
1049     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1050         return set._values[index];
1051     }
1052 
1053     /**
1054      * @dev Return the entire set in an array
1055      *
1056      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1057      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1058      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1059      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1060      */
1061     function _values(Set storage set) private view returns (bytes32[] memory) {
1062         return set._values;
1063     }
1064 
1065     // Bytes32Set
1066 
1067     struct Bytes32Set {
1068         Set _inner;
1069     }
1070 
1071     /**
1072      * @dev Add a value to a set. O(1).
1073      *
1074      * Returns true if the value was added to the set, that is if it was not
1075      * already present.
1076      */
1077     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1078         return _add(set._inner, value);
1079     }
1080 
1081     /**
1082      * @dev Removes a value from a set. O(1).
1083      *
1084      * Returns true if the value was removed from the set, that is if it was
1085      * present.
1086      */
1087     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1088         return _remove(set._inner, value);
1089     }
1090 
1091     /**
1092      * @dev Returns true if the value is in the set. O(1).
1093      */
1094     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1095         return _contains(set._inner, value);
1096     }
1097 
1098     /**
1099      * @dev Returns the number of values in the set. O(1).
1100      */
1101     function length(Bytes32Set storage set) internal view returns (uint256) {
1102         return _length(set._inner);
1103     }
1104 
1105     /**
1106      * @dev Returns the value stored at position `index` in the set. O(1).
1107      *
1108      * Note that there are no guarantees on the ordering of values inside the
1109      * array, and it may change when more values are added or removed.
1110      *
1111      * Requirements:
1112      *
1113      * - `index` must be strictly less than {length}.
1114      */
1115     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1116         return _at(set._inner, index);
1117     }
1118 
1119     /**
1120      * @dev Return the entire set in an array
1121      *
1122      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1123      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1124      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1125      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1126      */
1127     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1128         return _values(set._inner);
1129     }
1130 
1131     // AddressSet
1132 
1133     struct AddressSet {
1134         Set _inner;
1135     }
1136 
1137     /**
1138      * @dev Add a value to a set. O(1).
1139      *
1140      * Returns true if the value was added to the set, that is if it was not
1141      * already present.
1142      */
1143     function add(AddressSet storage set, address value) internal returns (bool) {
1144         return _add(set._inner, bytes32(uint256(uint160(value))));
1145     }
1146 
1147     /**
1148      * @dev Removes a value from a set. O(1).
1149      *
1150      * Returns true if the value was removed from the set, that is if it was
1151      * present.
1152      */
1153     function remove(AddressSet storage set, address value) internal returns (bool) {
1154         return _remove(set._inner, bytes32(uint256(uint160(value))));
1155     }
1156 
1157     /**
1158      * @dev Returns true if the value is in the set. O(1).
1159      */
1160     function contains(AddressSet storage set, address value) internal view returns (bool) {
1161         return _contains(set._inner, bytes32(uint256(uint160(value))));
1162     }
1163 
1164     /**
1165      * @dev Returns the number of values in the set. O(1).
1166      */
1167     function length(AddressSet storage set) internal view returns (uint256) {
1168         return _length(set._inner);
1169     }
1170 
1171     /**
1172      * @dev Returns the value stored at position `index` in the set. O(1).
1173      *
1174      * Note that there are no guarantees on the ordering of values inside the
1175      * array, and it may change when more values are added or removed.
1176      *
1177      * Requirements:
1178      *
1179      * - `index` must be strictly less than {length}.
1180      */
1181     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1182         return address(uint160(uint256(_at(set._inner, index))));
1183     }
1184 
1185     /**
1186      * @dev Return the entire set in an array
1187      *
1188      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1189      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1190      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1191      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1192      */
1193     function values(AddressSet storage set) internal view returns (address[] memory) {
1194         bytes32[] memory store = _values(set._inner);
1195         address[] memory result;
1196 
1197         assembly {
1198             result := store
1199         }
1200 
1201         return result;
1202     }
1203 
1204     // UintSet
1205 
1206     struct UintSet {
1207         Set _inner;
1208     }
1209 
1210     /**
1211      * @dev Add a value to a set. O(1).
1212      *
1213      * Returns true if the value was added to the set, that is if it was not
1214      * already present.
1215      */
1216     function add(UintSet storage set, uint256 value) internal returns (bool) {
1217         return _add(set._inner, bytes32(value));
1218     }
1219 
1220     /**
1221      * @dev Removes a value from a set. O(1).
1222      *
1223      * Returns true if the value was removed from the set, that is if it was
1224      * present.
1225      */
1226     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1227         return _remove(set._inner, bytes32(value));
1228     }
1229 
1230     /**
1231      * @dev Returns true if the value is in the set. O(1).
1232      */
1233     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1234         return _contains(set._inner, bytes32(value));
1235     }
1236 
1237     /**
1238      * @dev Returns the number of values on the set. O(1).
1239      */
1240     function length(UintSet storage set) internal view returns (uint256) {
1241         return _length(set._inner);
1242     }
1243 
1244     /**
1245      * @dev Returns the value stored at position `index` in the set. O(1).
1246      *
1247      * Note that there are no guarantees on the ordering of values inside the
1248      * array, and it may change when more values are added or removed.
1249      *
1250      * Requirements:
1251      *
1252      * - `index` must be strictly less than {length}.
1253      */
1254     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1255         return uint256(_at(set._inner, index));
1256     }
1257 
1258     /**
1259      * @dev Return the entire set in an array
1260      *
1261      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1262      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1263      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1264      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1265      */
1266     function values(UintSet storage set) internal view returns (uint256[] memory) {
1267         bytes32[] memory store = _values(set._inner);
1268         uint256[] memory result;
1269 
1270         assembly {
1271             result := store
1272         }
1273 
1274         return result;
1275     }
1276 }
1277 
1278 
1279 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.4.2
1280 
1281 // OpenZeppelin Contracts v4.4.1 (access/AccessControlEnumerable.sol)
1282 
1283 pragma solidity ^0.8.0;
1284 
1285 
1286 
1287 /**
1288  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1289  */
1290 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1291     using EnumerableSet for EnumerableSet.AddressSet;
1292 
1293     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1294 
1295     /**
1296      * @dev See {IERC165-supportsInterface}.
1297      */
1298     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1299         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1300     }
1301 
1302     /**
1303      * @dev Returns one of the accounts that have `role`. `index` must be a
1304      * value between 0 and {getRoleMemberCount}, non-inclusive.
1305      *
1306      * Role bearers are not sorted in any particular way, and their ordering may
1307      * change at any point.
1308      *
1309      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1310      * you perform all queries on the same block. See the following
1311      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1312      * for more information.
1313      */
1314     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1315         return _roleMembers[role].at(index);
1316     }
1317 
1318     /**
1319      * @dev Returns the number of accounts that have `role`. Can be used
1320      * together with {getRoleMember} to enumerate all bearers of a role.
1321      */
1322     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1323         return _roleMembers[role].length();
1324     }
1325 
1326     /**
1327      * @dev Overload {_grantRole} to track enumerable memberships
1328      */
1329     function _grantRole(bytes32 role, address account) internal virtual override {
1330         super._grantRole(role, account);
1331         _roleMembers[role].add(account);
1332     }
1333 
1334     /**
1335      * @dev Overload {_revokeRole} to track enumerable memberships
1336      */
1337     function _revokeRole(bytes32 role, address account) internal virtual override {
1338         super._revokeRole(role, account);
1339         _roleMembers[role].remove(account);
1340     }
1341 }
1342 
1343 
1344 // File contracts/base/TokenSaver.sol
1345 
1346 pragma solidity 0.8.7;
1347 
1348 
1349 
1350 contract TokenSaver is AccessControlEnumerable {
1351     using SafeERC20 for IERC20;
1352 
1353     bytes32 public constant TOKEN_SAVER_ROLE = keccak256("TOKEN_SAVER_ROLE");
1354 
1355     event TokenSaved(address indexed by, address indexed receiver, address indexed token, uint256 amount);
1356 
1357     modifier onlyTokenSaver() {
1358         require(hasRole(TOKEN_SAVER_ROLE, _msgSender()), "TokenSaver.onlyTokenSaver: permission denied");
1359         _;
1360     }
1361 
1362     constructor() {
1363         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1364     }
1365 
1366     function saveToken(address _token, address _receiver, uint256 _amount) external onlyTokenSaver {
1367         IERC20(_token).safeTransfer(_receiver, _amount);
1368         emit TokenSaved(_msgSender(), _receiver, _token, _amount);
1369     }
1370 
1371 }
1372 
1373 
1374 // File contracts/LiquidityMiningManager.sol
1375 
1376 pragma solidity 0.8.7;
1377 
1378 
1379 
1380 
1381 contract LiquidityMiningManager is TokenSaver {
1382     using SafeERC20 for IERC20;
1383 
1384     bytes32 public constant GOV_ROLE = keccak256("GOV_ROLE");
1385     bytes32 public constant REWARD_DISTRIBUTOR_ROLE = keccak256("REWARD_DISTRIBUTOR_ROLE");
1386     uint256 public MAX_POOL_COUNT = 10;
1387 
1388     IERC20 immutable public reward;
1389     address immutable public rewardSource;
1390     uint256 public rewardPerSecond; //total reward amount per second
1391     uint256 public lastDistribution; //when rewards were last pushed
1392     uint256 public totalWeight;
1393 
1394     mapping(address => bool) public poolAdded;
1395     Pool[] public pools;
1396 
1397     struct Pool {
1398         IBasePool poolContract;
1399         uint256 weight;
1400     }
1401 
1402     modifier onlyGov {
1403         require(hasRole(GOV_ROLE, _msgSender()), "LiquidityMiningManager.onlyGov: permission denied");
1404         _;
1405     }
1406 
1407     modifier onlyRewardDistributor {
1408         require(hasRole(REWARD_DISTRIBUTOR_ROLE, _msgSender()), "LiquidityMiningManager.onlyRewardDistributor: permission denied");
1409         _;
1410     }
1411 
1412     event PoolAdded(address indexed pool, uint256 weight);
1413     event PoolRemoved(uint256 indexed poolId, address indexed pool);
1414     event WeightAdjusted(uint256 indexed poolId, address indexed pool, uint256 newWeight);
1415     event RewardsPerSecondSet(uint256 rewardsPerSecond);
1416     event RewardsDistributed(address _from, uint256 indexed _amount);
1417 
1418     constructor(address _reward, address _rewardSource) {
1419         require(_reward != address(0), "LiquidityMiningManager.constructor: reward token must be set");
1420         require(_rewardSource != address(0), "LiquidityMiningManager.constructor: rewardSource token must be set");
1421         reward = IERC20(_reward);
1422         rewardSource = _rewardSource;
1423     }
1424 
1425     function addPool(address _poolContract, uint256 _weight) external onlyGov {
1426         distributeRewards();
1427         require(_poolContract != address(0), "LiquidityMiningManager.addPool: pool contract must be set");
1428         require(!poolAdded[_poolContract], "LiquidityMiningManager.addPool: Pool already added");
1429         require(pools.length < MAX_POOL_COUNT, "LiquidityMiningManager.addPool: Max amount of pools reached");
1430         // add pool
1431         pools.push(Pool({
1432             poolContract: IBasePool(_poolContract),
1433             weight: _weight
1434         }));
1435         poolAdded[_poolContract] = true;
1436         
1437         // increase totalWeight
1438         totalWeight += _weight;
1439 
1440         // Approve max token amount
1441         reward.safeApprove(_poolContract, type(uint256).max);
1442 
1443         emit PoolAdded(_poolContract, _weight);
1444     }
1445 
1446     function removePool(uint256 _poolId) external onlyGov {
1447         require(_poolId < pools.length, "LiquidityMiningManager.removePool: Pool does not exist");
1448         distributeRewards();
1449         address poolAddress = address(pools[_poolId].poolContract);
1450 
1451         // decrease totalWeight
1452         totalWeight -= pools[_poolId].weight;
1453         
1454         // remove pool
1455         pools[_poolId] = pools[pools.length - 1];
1456         pools.pop();
1457         poolAdded[poolAddress] = false;
1458 
1459         // Approve 0 token amount
1460         reward.safeApprove(poolAddress, 0);
1461 
1462         emit PoolRemoved(_poolId, poolAddress);
1463     }
1464 
1465     function adjustWeight(uint256 _poolId, uint256 _newWeight) external onlyGov {
1466         require(_poolId < pools.length, "LiquidityMiningManager.adjustWeight: Pool does not exist");
1467         distributeRewards();
1468         Pool storage pool = pools[_poolId];
1469 
1470         totalWeight -= pool.weight;
1471         totalWeight += _newWeight;
1472 
1473         pool.weight = _newWeight;
1474 
1475         emit WeightAdjusted(_poolId, address(pool.poolContract), _newWeight);
1476     }
1477 
1478     function setRewardPerSecond(uint256 _rewardPerSecond) external onlyGov {
1479         distributeRewards();
1480         rewardPerSecond = _rewardPerSecond;
1481 
1482         emit RewardsPerSecondSet(_rewardPerSecond);
1483     }
1484 
1485     function distributeRewards() public onlyRewardDistributor {
1486         uint256 timePassed = block.timestamp - lastDistribution;
1487         uint256 totalRewardAmount = rewardPerSecond * timePassed;
1488         lastDistribution = block.timestamp;
1489 
1490         // return if pool length == 0
1491         if(pools.length == 0) {
1492             return;
1493         }
1494 
1495         // return if accrued rewards == 0
1496         if(totalRewardAmount == 0) {
1497             return;
1498         }
1499 
1500         reward.safeTransferFrom(rewardSource, address(this), totalRewardAmount);
1501 
1502         for(uint256 i = 0; i < pools.length; i ++) {
1503             Pool memory pool = pools[i];
1504             uint256 poolRewardAmount = totalRewardAmount * pool.weight / totalWeight;
1505             // Ignore tx failing to prevent a single pool from halting reward distribution
1506             address(pool.poolContract).call(abi.encodeWithSelector(pool.poolContract.distributeRewards.selector, poolRewardAmount));
1507         }
1508 
1509         uint256 leftOverReward = reward.balanceOf(address(this));
1510 
1511         // send back excess but ignore dust
1512         if(leftOverReward > 1) {
1513             reward.safeTransfer(rewardSource, leftOverReward);
1514         }
1515 
1516         emit RewardsDistributed(_msgSender(), totalRewardAmount);
1517     }
1518 
1519     function getPools() external view returns(Pool[] memory result) {
1520         return pools;
1521     }
1522 }