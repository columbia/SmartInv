1 // Sources flattened with hardhat v2.6.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize, which returns 0 for contracts in
115         // construction, since the code is only stored at the end of the
116         // constructor execution.
117 
118         uint256 size;
119         assembly {
120             size := extcodesize(account)
121         }
122         return size > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 
306 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.3.2
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @title SafeERC20
313  * @dev Wrappers around ERC20 operations that throw on failure (when the token
314  * contract returns false). Tokens that return no value (and instead revert or
315  * throw on failure) are also supported, non-reverting calls are assumed to be
316  * successful.
317  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
318  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
319  */
320 library SafeERC20 {
321     using Address for address;
322 
323     function safeTransfer(
324         IERC20 token,
325         address to,
326         uint256 value
327     ) internal {
328         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
329     }
330 
331     function safeTransferFrom(
332         IERC20 token,
333         address from,
334         address to,
335         uint256 value
336     ) internal {
337         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     /**
341      * @dev Deprecated. This function has issues similar to the ones found in
342      * {IERC20-approve}, and its usage is discouraged.
343      *
344      * Whenever possible, use {safeIncreaseAllowance} and
345      * {safeDecreaseAllowance} instead.
346      */
347     function safeApprove(
348         IERC20 token,
349         address spender,
350         uint256 value
351     ) internal {
352         // safeApprove should only be called when setting an initial allowance,
353         // or when resetting it to zero. To increase and decrease it, use
354         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
355         require(
356             (value == 0) || (token.allowance(address(this), spender) == 0),
357             "SafeERC20: approve from non-zero to non-zero allowance"
358         );
359         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
360     }
361 
362     function safeIncreaseAllowance(
363         IERC20 token,
364         address spender,
365         uint256 value
366     ) internal {
367         uint256 newAllowance = token.allowance(address(this), spender) + value;
368         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
369     }
370 
371     function safeDecreaseAllowance(
372         IERC20 token,
373         address spender,
374         uint256 value
375     ) internal {
376         unchecked {
377             uint256 oldAllowance = token.allowance(address(this), spender);
378             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
379             uint256 newAllowance = oldAllowance - value;
380             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
381         }
382     }
383 
384     /**
385      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
386      * on the return value: the return value is optional (but if data is returned, it must not be false).
387      * @param token The token targeted by the call.
388      * @param data The call data (encoded using abi.encode or one of its variants).
389      */
390     function _callOptionalReturn(IERC20 token, bytes memory data) private {
391         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
392         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
393         // the target address contains contract code and also asserts for success in the low-level call.
394 
395         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
396         if (returndata.length > 0) {
397             // Return data is optional
398             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
399         }
400     }
401 }
402 
403 
404 // File contracts/interfaces/IBasePool.sol
405 
406 pragma solidity 0.8.7;
407 interface IBasePool {
408     function distributeRewards(uint256 _amount) external;
409 }
410 
411 
412 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.2
413 
414 pragma solidity ^0.8.0;
415 
416 /**
417  * @dev External interface of AccessControl declared to support ERC165 detection.
418  */
419 interface IAccessControl {
420     /**
421      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
422      *
423      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
424      * {RoleAdminChanged} not being emitted signaling this.
425      *
426      * _Available since v3.1._
427      */
428     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
429 
430     /**
431      * @dev Emitted when `account` is granted `role`.
432      *
433      * `sender` is the account that originated the contract call, an admin role
434      * bearer except when using {AccessControl-_setupRole}.
435      */
436     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
437 
438     /**
439      * @dev Emitted when `account` is revoked `role`.
440      *
441      * `sender` is the account that originated the contract call:
442      *   - if using `revokeRole`, it is the admin role bearer
443      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
444      */
445     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
446 
447     /**
448      * @dev Returns `true` if `account` has been granted `role`.
449      */
450     function hasRole(bytes32 role, address account) external view returns (bool);
451 
452     /**
453      * @dev Returns the admin role that controls `role`. See {grantRole} and
454      * {revokeRole}.
455      *
456      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
457      */
458     function getRoleAdmin(bytes32 role) external view returns (bytes32);
459 
460     /**
461      * @dev Grants `role` to `account`.
462      *
463      * If `account` had not been already granted `role`, emits a {RoleGranted}
464      * event.
465      *
466      * Requirements:
467      *
468      * - the caller must have ``role``'s admin role.
469      */
470     function grantRole(bytes32 role, address account) external;
471 
472     /**
473      * @dev Revokes `role` from `account`.
474      *
475      * If `account` had been granted `role`, emits a {RoleRevoked} event.
476      *
477      * Requirements:
478      *
479      * - the caller must have ``role``'s admin role.
480      */
481     function revokeRole(bytes32 role, address account) external;
482 
483     /**
484      * @dev Revokes `role` from the calling account.
485      *
486      * Roles are often managed via {grantRole} and {revokeRole}: this function's
487      * purpose is to provide a mechanism for accounts to lose their privileges
488      * if they are compromised (such as when a trusted device is misplaced).
489      *
490      * If the calling account had been granted `role`, emits a {RoleRevoked}
491      * event.
492      *
493      * Requirements:
494      *
495      * - the caller must be `account`.
496      */
497     function renounceRole(bytes32 role, address account) external;
498 }
499 
500 
501 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.3.2
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
507  */
508 interface IAccessControlEnumerable is IAccessControl {
509     /**
510      * @dev Returns one of the accounts that have `role`. `index` must be a
511      * value between 0 and {getRoleMemberCount}, non-inclusive.
512      *
513      * Role bearers are not sorted in any particular way, and their ordering may
514      * change at any point.
515      *
516      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
517      * you perform all queries on the same block. See the following
518      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
519      * for more information.
520      */
521     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
522 
523     /**
524      * @dev Returns the number of accounts that have `role`. Can be used
525      * together with {getRoleMember} to enumerate all bearers of a role.
526      */
527     function getRoleMemberCount(bytes32 role) external view returns (uint256);
528 }
529 
530 
531 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Provides information about the current execution context, including the
537  * sender of the transaction and its data. While these are generally available
538  * via msg.sender and msg.data, they should not be accessed in such a direct
539  * manner, since when dealing with meta-transactions the account sending and
540  * paying for execution may not be the actual sender (as far as an application
541  * is concerned).
542  *
543  * This contract is only required for intermediate, library-like contracts.
544  */
545 abstract contract Context {
546     function _msgSender() internal view virtual returns (address) {
547         return msg.sender;
548     }
549 
550     function _msgData() internal view virtual returns (bytes calldata) {
551         return msg.data;
552     }
553 }
554 
555 
556 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev String operations.
562  */
563 library Strings {
564     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
568      */
569     function toString(uint256 value) internal pure returns (string memory) {
570         // Inspired by OraclizeAPI's implementation - MIT licence
571         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
572 
573         if (value == 0) {
574             return "0";
575         }
576         uint256 temp = value;
577         uint256 digits;
578         while (temp != 0) {
579             digits++;
580             temp /= 10;
581         }
582         bytes memory buffer = new bytes(digits);
583         while (value != 0) {
584             digits -= 1;
585             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
586             value /= 10;
587         }
588         return string(buffer);
589     }
590 
591     /**
592      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
593      */
594     function toHexString(uint256 value) internal pure returns (string memory) {
595         if (value == 0) {
596             return "0x00";
597         }
598         uint256 temp = value;
599         uint256 length = 0;
600         while (temp != 0) {
601             length++;
602             temp >>= 8;
603         }
604         return toHexString(value, length);
605     }
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
609      */
610     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
611         bytes memory buffer = new bytes(2 * length + 2);
612         buffer[0] = "0";
613         buffer[1] = "x";
614         for (uint256 i = 2 * length + 1; i > 1; --i) {
615             buffer[i] = _HEX_SYMBOLS[value & 0xf];
616             value >>= 4;
617         }
618         require(value == 0, "Strings: hex length insufficient");
619         return string(buffer);
620     }
621 }
622 
623 
624 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev Interface of the ERC165 standard, as defined in the
630  * https://eips.ethereum.org/EIPS/eip-165[EIP].
631  *
632  * Implementers can declare support of contract interfaces, which can then be
633  * queried by others ({ERC165Checker}).
634  *
635  * For an implementation, see {ERC165}.
636  */
637 interface IERC165 {
638     /**
639      * @dev Returns true if this contract implements the interface defined by
640      * `interfaceId`. See the corresponding
641      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
642      * to learn more about how these ids are created.
643      *
644      * This function call must use less than 30 000 gas.
645      */
646     function supportsInterface(bytes4 interfaceId) external view returns (bool);
647 }
648 
649 
650 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Implementation of the {IERC165} interface.
656  *
657  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
658  * for the additional interface id that will be supported. For example:
659  *
660  * ```solidity
661  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
662  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
663  * }
664  * ```
665  *
666  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
667  */
668 abstract contract ERC165 is IERC165 {
669     /**
670      * @dev See {IERC165-supportsInterface}.
671      */
672     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
673         return interfaceId == type(IERC165).interfaceId;
674     }
675 }
676 
677 
678 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.2
679 
680 pragma solidity ^0.8.0;
681 
682 
683 
684 
685 /**
686  * @dev Contract module that allows children to implement role-based access
687  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
688  * members except through off-chain means by accessing the contract event logs. Some
689  * applications may benefit from on-chain enumerability, for those cases see
690  * {AccessControlEnumerable}.
691  *
692  * Roles are referred to by their `bytes32` identifier. These should be exposed
693  * in the external API and be unique. The best way to achieve this is by
694  * using `public constant` hash digests:
695  *
696  * ```
697  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
698  * ```
699  *
700  * Roles can be used to represent a set of permissions. To restrict access to a
701  * function call, use {hasRole}:
702  *
703  * ```
704  * function foo() public {
705  *     require(hasRole(MY_ROLE, msg.sender));
706  *     ...
707  * }
708  * ```
709  *
710  * Roles can be granted and revoked dynamically via the {grantRole} and
711  * {revokeRole} functions. Each role has an associated admin role, and only
712  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
713  *
714  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
715  * that only accounts with this role will be able to grant or revoke other
716  * roles. More complex role relationships can be created by using
717  * {_setRoleAdmin}.
718  *
719  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
720  * grant and revoke this role. Extra precautions should be taken to secure
721  * accounts that have been granted it.
722  */
723 abstract contract AccessControl is Context, IAccessControl, ERC165 {
724     struct RoleData {
725         mapping(address => bool) members;
726         bytes32 adminRole;
727     }
728 
729     mapping(bytes32 => RoleData) private _roles;
730 
731     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
732 
733     /**
734      * @dev Modifier that checks that an account has a specific role. Reverts
735      * with a standardized message including the required role.
736      *
737      * The format of the revert reason is given by the following regular expression:
738      *
739      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
740      *
741      * _Available since v4.1._
742      */
743     modifier onlyRole(bytes32 role) {
744         _checkRole(role, _msgSender());
745         _;
746     }
747 
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
753     }
754 
755     /**
756      * @dev Returns `true` if `account` has been granted `role`.
757      */
758     function hasRole(bytes32 role, address account) public view override returns (bool) {
759         return _roles[role].members[account];
760     }
761 
762     /**
763      * @dev Revert with a standard message if `account` is missing `role`.
764      *
765      * The format of the revert reason is given by the following regular expression:
766      *
767      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
768      */
769     function _checkRole(bytes32 role, address account) internal view {
770         if (!hasRole(role, account)) {
771             revert(
772                 string(
773                     abi.encodePacked(
774                         "AccessControl: account ",
775                         Strings.toHexString(uint160(account), 20),
776                         " is missing role ",
777                         Strings.toHexString(uint256(role), 32)
778                     )
779                 )
780             );
781         }
782     }
783 
784     /**
785      * @dev Returns the admin role that controls `role`. See {grantRole} and
786      * {revokeRole}.
787      *
788      * To change a role's admin, use {_setRoleAdmin}.
789      */
790     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
791         return _roles[role].adminRole;
792     }
793 
794     /**
795      * @dev Grants `role` to `account`.
796      *
797      * If `account` had not been already granted `role`, emits a {RoleGranted}
798      * event.
799      *
800      * Requirements:
801      *
802      * - the caller must have ``role``'s admin role.
803      */
804     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
805         _grantRole(role, account);
806     }
807 
808     /**
809      * @dev Revokes `role` from `account`.
810      *
811      * If `account` had been granted `role`, emits a {RoleRevoked} event.
812      *
813      * Requirements:
814      *
815      * - the caller must have ``role``'s admin role.
816      */
817     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
818         _revokeRole(role, account);
819     }
820 
821     /**
822      * @dev Revokes `role` from the calling account.
823      *
824      * Roles are often managed via {grantRole} and {revokeRole}: this function's
825      * purpose is to provide a mechanism for accounts to lose their privileges
826      * if they are compromised (such as when a trusted device is misplaced).
827      *
828      * If the calling account had been granted `role`, emits a {RoleRevoked}
829      * event.
830      *
831      * Requirements:
832      *
833      * - the caller must be `account`.
834      */
835     function renounceRole(bytes32 role, address account) public virtual override {
836         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
837 
838         _revokeRole(role, account);
839     }
840 
841     /**
842      * @dev Grants `role` to `account`.
843      *
844      * If `account` had not been already granted `role`, emits a {RoleGranted}
845      * event. Note that unlike {grantRole}, this function doesn't perform any
846      * checks on the calling account.
847      *
848      * [WARNING]
849      * ====
850      * This function should only be called from the constructor when setting
851      * up the initial roles for the system.
852      *
853      * Using this function in any other way is effectively circumventing the admin
854      * system imposed by {AccessControl}.
855      * ====
856      */
857     function _setupRole(bytes32 role, address account) internal virtual {
858         _grantRole(role, account);
859     }
860 
861     /**
862      * @dev Sets `adminRole` as ``role``'s admin role.
863      *
864      * Emits a {RoleAdminChanged} event.
865      */
866     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
867         bytes32 previousAdminRole = getRoleAdmin(role);
868         _roles[role].adminRole = adminRole;
869         emit RoleAdminChanged(role, previousAdminRole, adminRole);
870     }
871 
872     function _grantRole(bytes32 role, address account) private {
873         if (!hasRole(role, account)) {
874             _roles[role].members[account] = true;
875             emit RoleGranted(role, account, _msgSender());
876         }
877     }
878 
879     function _revokeRole(bytes32 role, address account) private {
880         if (hasRole(role, account)) {
881             _roles[role].members[account] = false;
882             emit RoleRevoked(role, account, _msgSender());
883         }
884     }
885 }
886 
887 
888 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.3.2
889 
890 
891 pragma solidity ^0.8.0;
892 
893 /**
894  * @dev Library for managing
895  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
896  * types.
897  *
898  * Sets have the following properties:
899  *
900  * - Elements are added, removed, and checked for existence in constant time
901  * (O(1)).
902  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
903  *
904  * ```
905  * contract Example {
906  *     // Add the library methods
907  *     using EnumerableSet for EnumerableSet.AddressSet;
908  *
909  *     // Declare a set state variable
910  *     EnumerableSet.AddressSet private mySet;
911  * }
912  * ```
913  *
914  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
915  * and `uint256` (`UintSet`) are supported.
916  */
917 library EnumerableSet {
918     // To implement this library for multiple types with as little code
919     // repetition as possible, we write it in terms of a generic Set type with
920     // bytes32 values.
921     // The Set implementation uses private functions, and user-facing
922     // implementations (such as AddressSet) are just wrappers around the
923     // underlying Set.
924     // This means that we can only create new EnumerableSets for types that fit
925     // in bytes32.
926 
927     struct Set {
928         // Storage of set values
929         bytes32[] _values;
930         // Position of the value in the `values` array, plus 1 because index 0
931         // means a value is not in the set.
932         mapping(bytes32 => uint256) _indexes;
933     }
934 
935     /**
936      * @dev Add a value to a set. O(1).
937      *
938      * Returns true if the value was added to the set, that is if it was not
939      * already present.
940      */
941     function _add(Set storage set, bytes32 value) private returns (bool) {
942         if (!_contains(set, value)) {
943             set._values.push(value);
944             // The value is stored at length-1, but we add 1 to all indexes
945             // and use 0 as a sentinel value
946             set._indexes[value] = set._values.length;
947             return true;
948         } else {
949             return false;
950         }
951     }
952 
953     /**
954      * @dev Removes a value from a set. O(1).
955      *
956      * Returns true if the value was removed from the set, that is if it was
957      * present.
958      */
959     function _remove(Set storage set, bytes32 value) private returns (bool) {
960         // We read and store the value's index to prevent multiple reads from the same storage slot
961         uint256 valueIndex = set._indexes[value];
962 
963         if (valueIndex != 0) {
964             // Equivalent to contains(set, value)
965             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
966             // the array, and then remove the last element (sometimes called as 'swap and pop').
967             // This modifies the order of the array, as noted in {at}.
968 
969             uint256 toDeleteIndex = valueIndex - 1;
970             uint256 lastIndex = set._values.length - 1;
971 
972             if (lastIndex != toDeleteIndex) {
973                 bytes32 lastvalue = set._values[lastIndex];
974 
975                 // Move the last value to the index where the value to delete is
976                 set._values[toDeleteIndex] = lastvalue;
977                 // Update the index for the moved value
978                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
979             }
980 
981             // Delete the slot where the moved value was stored
982             set._values.pop();
983 
984             // Delete the index for the deleted slot
985             delete set._indexes[value];
986 
987             return true;
988         } else {
989             return false;
990         }
991     }
992 
993     /**
994      * @dev Returns true if the value is in the set. O(1).
995      */
996     function _contains(Set storage set, bytes32 value) private view returns (bool) {
997         return set._indexes[value] != 0;
998     }
999 
1000     /**
1001      * @dev Returns the number of values on the set. O(1).
1002      */
1003     function _length(Set storage set) private view returns (uint256) {
1004         return set._values.length;
1005     }
1006 
1007     /**
1008      * @dev Returns the value stored at position `index` in the set. O(1).
1009      *
1010      * Note that there are no guarantees on the ordering of values inside the
1011      * array, and it may change when more values are added or removed.
1012      *
1013      * Requirements:
1014      *
1015      * - `index` must be strictly less than {length}.
1016      */
1017     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1018         return set._values[index];
1019     }
1020 
1021     /**
1022      * @dev Return the entire set in an array
1023      *
1024      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1025      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1026      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1027      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1028      */
1029     function _values(Set storage set) private view returns (bytes32[] memory) {
1030         return set._values;
1031     }
1032 
1033     // Bytes32Set
1034 
1035     struct Bytes32Set {
1036         Set _inner;
1037     }
1038 
1039     /**
1040      * @dev Add a value to a set. O(1).
1041      *
1042      * Returns true if the value was added to the set, that is if it was not
1043      * already present.
1044      */
1045     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1046         return _add(set._inner, value);
1047     }
1048 
1049     /**
1050      * @dev Removes a value from a set. O(1).
1051      *
1052      * Returns true if the value was removed from the set, that is if it was
1053      * present.
1054      */
1055     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1056         return _remove(set._inner, value);
1057     }
1058 
1059     /**
1060      * @dev Returns true if the value is in the set. O(1).
1061      */
1062     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1063         return _contains(set._inner, value);
1064     }
1065 
1066     /**
1067      * @dev Returns the number of values in the set. O(1).
1068      */
1069     function length(Bytes32Set storage set) internal view returns (uint256) {
1070         return _length(set._inner);
1071     }
1072 
1073     /**
1074      * @dev Returns the value stored at position `index` in the set. O(1).
1075      *
1076      * Note that there are no guarantees on the ordering of values inside the
1077      * array, and it may change when more values are added or removed.
1078      *
1079      * Requirements:
1080      *
1081      * - `index` must be strictly less than {length}.
1082      */
1083     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1084         return _at(set._inner, index);
1085     }
1086 
1087     /**
1088      * @dev Return the entire set in an array
1089      *
1090      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1091      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1092      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1093      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1094      */
1095     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1096         return _values(set._inner);
1097     }
1098 
1099     // AddressSet
1100 
1101     struct AddressSet {
1102         Set _inner;
1103     }
1104 
1105     /**
1106      * @dev Add a value to a set. O(1).
1107      *
1108      * Returns true if the value was added to the set, that is if it was not
1109      * already present.
1110      */
1111     function add(AddressSet storage set, address value) internal returns (bool) {
1112         return _add(set._inner, bytes32(uint256(uint160(value))));
1113     }
1114 
1115     /**
1116      * @dev Removes a value from a set. O(1).
1117      *
1118      * Returns true if the value was removed from the set, that is if it was
1119      * present.
1120      */
1121     function remove(AddressSet storage set, address value) internal returns (bool) {
1122         return _remove(set._inner, bytes32(uint256(uint160(value))));
1123     }
1124 
1125     /**
1126      * @dev Returns true if the value is in the set. O(1).
1127      */
1128     function contains(AddressSet storage set, address value) internal view returns (bool) {
1129         return _contains(set._inner, bytes32(uint256(uint160(value))));
1130     }
1131 
1132     /**
1133      * @dev Returns the number of values in the set. O(1).
1134      */
1135     function length(AddressSet storage set) internal view returns (uint256) {
1136         return _length(set._inner);
1137     }
1138 
1139     /**
1140      * @dev Returns the value stored at position `index` in the set. O(1).
1141      *
1142      * Note that there are no guarantees on the ordering of values inside the
1143      * array, and it may change when more values are added or removed.
1144      *
1145      * Requirements:
1146      *
1147      * - `index` must be strictly less than {length}.
1148      */
1149     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1150         return address(uint160(uint256(_at(set._inner, index))));
1151     }
1152 
1153     /**
1154      * @dev Return the entire set in an array
1155      *
1156      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1157      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1158      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1159      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1160      */
1161     function values(AddressSet storage set) internal view returns (address[] memory) {
1162         bytes32[] memory store = _values(set._inner);
1163         address[] memory result;
1164 
1165         assembly {
1166             result := store
1167         }
1168 
1169         return result;
1170     }
1171 
1172     // UintSet
1173 
1174     struct UintSet {
1175         Set _inner;
1176     }
1177 
1178     /**
1179      * @dev Add a value to a set. O(1).
1180      *
1181      * Returns true if the value was added to the set, that is if it was not
1182      * already present.
1183      */
1184     function add(UintSet storage set, uint256 value) internal returns (bool) {
1185         return _add(set._inner, bytes32(value));
1186     }
1187 
1188     /**
1189      * @dev Removes a value from a set. O(1).
1190      *
1191      * Returns true if the value was removed from the set, that is if it was
1192      * present.
1193      */
1194     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1195         return _remove(set._inner, bytes32(value));
1196     }
1197 
1198     /**
1199      * @dev Returns true if the value is in the set. O(1).
1200      */
1201     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1202         return _contains(set._inner, bytes32(value));
1203     }
1204 
1205     /**
1206      * @dev Returns the number of values on the set. O(1).
1207      */
1208     function length(UintSet storage set) internal view returns (uint256) {
1209         return _length(set._inner);
1210     }
1211 
1212     /**
1213      * @dev Returns the value stored at position `index` in the set. O(1).
1214      *
1215      * Note that there are no guarantees on the ordering of values inside the
1216      * array, and it may change when more values are added or removed.
1217      *
1218      * Requirements:
1219      *
1220      * - `index` must be strictly less than {length}.
1221      */
1222     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1223         return uint256(_at(set._inner, index));
1224     }
1225 
1226     /**
1227      * @dev Return the entire set in an array
1228      *
1229      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1230      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1231      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1232      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1233      */
1234     function values(UintSet storage set) internal view returns (uint256[] memory) {
1235         bytes32[] memory store = _values(set._inner);
1236         uint256[] memory result;
1237 
1238         assembly {
1239             result := store
1240         }
1241 
1242         return result;
1243     }
1244 }
1245 
1246 
1247 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.3.2
1248 
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 
1253 
1254 /**
1255  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1256  */
1257 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1258     using EnumerableSet for EnumerableSet.AddressSet;
1259 
1260     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1261 
1262     /**
1263      * @dev See {IERC165-supportsInterface}.
1264      */
1265     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1266         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1267     }
1268 
1269     /**
1270      * @dev Returns one of the accounts that have `role`. `index` must be a
1271      * value between 0 and {getRoleMemberCount}, non-inclusive.
1272      *
1273      * Role bearers are not sorted in any particular way, and their ordering may
1274      * change at any point.
1275      *
1276      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1277      * you perform all queries on the same block. See the following
1278      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1279      * for more information.
1280      */
1281     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1282         return _roleMembers[role].at(index);
1283     }
1284 
1285     /**
1286      * @dev Returns the number of accounts that have `role`. Can be used
1287      * together with {getRoleMember} to enumerate all bearers of a role.
1288      */
1289     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1290         return _roleMembers[role].length();
1291     }
1292 
1293     /**
1294      * @dev Overload {grantRole} to track enumerable memberships
1295      */
1296     function grantRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1297         super.grantRole(role, account);
1298         _roleMembers[role].add(account);
1299     }
1300 
1301     /**
1302      * @dev Overload {revokeRole} to track enumerable memberships
1303      */
1304     function revokeRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1305         super.revokeRole(role, account);
1306         _roleMembers[role].remove(account);
1307     }
1308 
1309     /**
1310      * @dev Overload {renounceRole} to track enumerable memberships
1311      */
1312     function renounceRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1313         super.renounceRole(role, account);
1314         _roleMembers[role].remove(account);
1315     }
1316 
1317     /**
1318      * @dev Overload {_setupRole} to track enumerable memberships
1319      */
1320     function _setupRole(bytes32 role, address account) internal virtual override {
1321         super._setupRole(role, account);
1322         _roleMembers[role].add(account);
1323     }
1324 }
1325 
1326 
1327 // File contracts/base/TokenSaver.sol
1328 
1329 pragma solidity 0.8.7;
1330 
1331 
1332 
1333 contract TokenSaver is AccessControlEnumerable {
1334     using SafeERC20 for IERC20;
1335 
1336     bytes32 public constant TOKEN_SAVER_ROLE = keccak256("TOKEN_SAVER_ROLE");
1337 
1338     event TokenSaved(address indexed by, address indexed receiver, address indexed token, uint256 amount);
1339 
1340     modifier onlyTokenSaver() {
1341         require(hasRole(TOKEN_SAVER_ROLE, _msgSender()), "TokenSaver.onlyTokenSaver: permission denied");
1342         _;
1343     }
1344 
1345     constructor() {
1346         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1347     }
1348 
1349     function saveToken(address _token, address _receiver, uint256 _amount) external onlyTokenSaver {
1350         IERC20(_token).safeTransfer(_receiver, _amount);
1351         emit TokenSaved(_msgSender(), _receiver, _token, _amount);
1352     }
1353 
1354 }
1355 
1356 
1357 // File contracts/LiquidityMiningManager.sol
1358 
1359 pragma solidity 0.8.7;
1360 
1361 
1362 
1363 
1364 contract LiquidityMiningManager is TokenSaver {
1365     using SafeERC20 for IERC20;
1366 
1367     bytes32 public constant GOV_ROLE = keccak256("GOV_ROLE");
1368     bytes32 public constant REWARD_DISTRIBUTOR_ROLE = keccak256("REWARD_DISTRIBUTOR_ROLE");
1369     uint256 public MAX_POOL_COUNT = 10;
1370 
1371     IERC20 immutable public reward;
1372     address immutable public rewardSource;
1373     uint256 public rewardPerSecond; //total reward amount per second
1374     uint256 public lastDistribution; //when rewards were last pushed
1375     uint256 public totalWeight;
1376 
1377     mapping(address => bool) public poolAdded;
1378     Pool[] public pools;
1379 
1380     struct Pool {
1381         IBasePool poolContract;
1382         uint256 weight;
1383     }
1384 
1385     modifier onlyGov {
1386         require(hasRole(GOV_ROLE, _msgSender()), "LiquidityMiningManager.onlyGov: permission denied");
1387         _;
1388     }
1389 
1390     modifier onlyRewardDistributor {
1391         require(hasRole(REWARD_DISTRIBUTOR_ROLE, _msgSender()), "LiquidityMiningManager.onlyRewardDistributor: permission denied");
1392         _;
1393     }
1394 
1395     event PoolAdded(address indexed pool, uint256 weight);
1396     event PoolRemoved(uint256 indexed poolId, address indexed pool);
1397     event WeightAdjusted(uint256 indexed poolId, address indexed pool, uint256 newWeight);
1398     event RewardsPerSecondSet(uint256 rewardsPerSecond);
1399     event RewardsDistributed(address _from, uint256 indexed _amount);
1400 
1401     constructor(address _reward, address _rewardSource) {
1402         require(_reward != address(0), "LiquidityMiningManager.constructor: reward token must be set");
1403         require(_rewardSource != address(0), "LiquidityMiningManager.constructor: rewardSource token must be set");
1404         reward = IERC20(_reward);
1405         rewardSource = _rewardSource;
1406     }
1407 
1408     function addPool(address _poolContract, uint256 _weight) external onlyGov {
1409         distributeRewards();
1410         require(_poolContract != address(0), "LiquidityMiningManager.addPool: pool contract must be set");
1411         require(!poolAdded[_poolContract], "LiquidityMiningManager.addPool: Pool already added");
1412         require(pools.length < MAX_POOL_COUNT, "LiquidityMiningManager.addPool: Max amount of pools reached");
1413         // add pool
1414         pools.push(Pool({
1415             poolContract: IBasePool(_poolContract),
1416             weight: _weight
1417         }));
1418         poolAdded[_poolContract] = true;
1419         
1420         // increase totalWeight
1421         totalWeight += _weight;
1422 
1423         // Approve max token amount
1424         reward.safeApprove(_poolContract, type(uint256).max);
1425 
1426         emit PoolAdded(_poolContract, _weight);
1427     }
1428 
1429     function removePool(uint256 _poolId) external onlyGov {
1430         require(_poolId < pools.length, "LiquidityMiningManager.removePool: Pool does not exist");
1431         distributeRewards();
1432         address poolAddress = address(pools[_poolId].poolContract);
1433 
1434         // decrease totalWeight
1435         totalWeight -= pools[_poolId].weight;
1436         
1437         // remove pool
1438         pools[_poolId] = pools[pools.length - 1];
1439         pools.pop();
1440         poolAdded[poolAddress] = false;
1441 
1442         emit PoolRemoved(_poolId, poolAddress);
1443     }
1444 
1445     function adjustWeight(uint256 _poolId, uint256 _newWeight) external onlyGov {
1446         require(_poolId < pools.length, "LiquidityMiningManager.adjustWeight: Pool does not exist");
1447         distributeRewards();
1448         Pool storage pool = pools[_poolId];
1449 
1450         totalWeight -= pool.weight;
1451         totalWeight += _newWeight;
1452 
1453         pool.weight = _newWeight;
1454 
1455         emit WeightAdjusted(_poolId, address(pool.poolContract), _newWeight);
1456     }
1457 
1458     function setRewardPerSecond(uint256 _rewardPerSecond) external onlyGov {
1459         distributeRewards();
1460         rewardPerSecond = _rewardPerSecond;
1461 
1462         emit RewardsPerSecondSet(_rewardPerSecond);
1463     }
1464 
1465     function distributeRewards() public onlyRewardDistributor {
1466         uint256 timePassed = block.timestamp - lastDistribution;
1467         uint256 totalRewardAmount = rewardPerSecond * timePassed;
1468         lastDistribution = block.timestamp;
1469 
1470         // return if pool length == 0
1471         if(pools.length == 0) {
1472             return;
1473         }
1474 
1475         // return if accrued rewards == 0
1476         if(totalRewardAmount == 0) {
1477             return;
1478         }
1479 
1480         reward.safeTransferFrom(rewardSource, address(this), totalRewardAmount);
1481 
1482         for(uint256 i = 0; i < pools.length; i ++) {
1483             Pool memory pool = pools[i];
1484             uint256 poolRewardAmount = totalRewardAmount * pool.weight / totalWeight;
1485             // Ignore tx failing to prevent a single pool from halting reward distribution
1486             address(pool.poolContract).call(abi.encodeWithSelector(pool.poolContract.distributeRewards.selector, poolRewardAmount));
1487         }
1488 
1489         uint256 leftOverReward = reward.balanceOf(address(this));
1490 
1491         // send back excess but ignore dust
1492         if(leftOverReward > 1) {
1493             reward.safeTransfer(rewardSource, leftOverReward);
1494         }
1495 
1496         emit RewardsDistributed(_msgSender(), totalRewardAmount);
1497     }
1498 
1499     function getPools() external view returns(Pool[] memory result) {
1500         return pools;
1501     }
1502 }