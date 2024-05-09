1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         //unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         //}
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         //unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         //}
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         //unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         //}
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         //unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         //}
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         //unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         //}
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         //unchecked {
171             require(b <= a, errorMessage);
172             return a - b;
173         //}
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         //unchecked {
194             require(b > 0, errorMessage);
195             return a / b;
196         //}
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         //unchecked {
216             require(b > 0, errorMessage);
217             return a % b;
218         //}
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Context.sol
223 
224 pragma solidity ^0.8.0;
225 
226 /*
227  * @dev Provides information about the current execution context, including the
228  * sender of the transaction and its data. While these are generally available
229  * via msg.sender and msg.data, they should not be accessed in such a direct
230  * manner, since when dealing with meta-transactions the account sending and
231  * paying for execution may not be the actual sender (as far as an application
232  * is concerned).
233  *
234  * This contract is only required for intermediate, library-like contracts.
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Interface of the ERC165 standard, as defined in the
253  * https://eips.ethereum.org/EIPS/eip-165[EIP].
254  *
255  * Implementers can declare support of contract interfaces, which can then be
256  * queried by others ({ERC165Checker}).
257  *
258  * For an implementation, see {ERC165}.
259  */
260 interface IERC165 {
261     /**
262      * @dev Returns true if this contract implements the interface defined by
263      * `interfaceId`. See the corresponding
264      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
265      * to learn more about how these ids are created.
266      *
267      * This function call must use less than 30 000 gas.
268      */
269     function supportsInterface(bytes4 interfaceId) external view returns (bool);
270 }
271 
272 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
273 
274 pragma solidity ^0.8.0;
275 
276 
277 /**
278  * @dev Implementation of the {IERC165} interface.
279  *
280  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
281  * for the additional interface id that will be supported. For example:
282  *
283  * ```solidity
284  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
285  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
286  * }
287  * ```
288  *
289  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
290  */
291 abstract contract ERC165 is IERC165 {
292     /**
293      * @dev See {IERC165-supportsInterface}.
294      */
295     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
296         return interfaceId == type(IERC165).interfaceId;
297     }
298 }
299 
300 // File: @openzeppelin/contracts/access/AccessControl.sol
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev External interface of AccessControl declared to support ERC165 detection.
306  */
307 interface IAccessControl {
308     function hasRole(bytes32 role, address account) external view returns (bool);
309     function getRoleAdmin(bytes32 role) external view returns (bytes32);
310     function grantRole(bytes32 role, address account) external;
311     function revokeRole(bytes32 role, address account) external;
312     function renounceRole(bytes32 role, address account) external;
313 }
314 
315 /**
316  * @dev Contract module that allows children to implement role-based access
317  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
318  * members except through off-chain means by accessing the contract event logs. Some
319  * applications may benefit from on-chain enumerability, for those cases see
320  * {AccessControlEnumerable}.
321  *
322  * Roles are referred to by their `bytes32` identifier. These should be exposed
323  * in the external API and be unique. The best way to achieve this is by
324  * using `public constant` hash digests:
325  *
326  * ```
327  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
328  * ```
329  *
330  * Roles can be used to represent a set of permissions. To restrict access to a
331  * function call, use {hasRole}:
332  *
333  * ```
334  * function foo() public {
335  *     require(hasRole(MY_ROLE, msg.sender));
336  *     ...
337  * }
338  * ```
339  *
340  * Roles can be granted and revoked dynamically via the {grantRole} and
341  * {revokeRole} functions. Each role has an associated admin role, and only
342  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
343  *
344  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
345  * that only accounts with this role will be able to grant or revoke other
346  * roles. More complex role relationships can be created by using
347  * {_setRoleAdmin}.
348  *
349  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
350  * grant and revoke this role. Extra precautions should be taken to secure
351  * accounts that have been granted it.
352  */
353 abstract contract AccessControl is Context, IAccessControl, ERC165 {
354     struct RoleData {
355         mapping (address => bool) members;
356         bytes32 adminRole;
357     }
358 
359     mapping (bytes32 => RoleData) private _roles;
360 
361     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
362 
363     /**
364      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
365      *
366      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
367      * {RoleAdminChanged} not being emitted signaling this.
368      *
369      * _Available since v3.1._
370      */
371     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
372 
373     /**
374      * @dev Emitted when `account` is granted `role`.
375      *
376      * `sender` is the account that originated the contract call, an admin role
377      * bearer except when using {_setupRole}.
378      */
379     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
380 
381     /**
382      * @dev Emitted when `account` is revoked `role`.
383      *
384      * `sender` is the account that originated the contract call:
385      *   - if using `revokeRole`, it is the admin role bearer
386      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
387      */
388     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
389 
390     /**
391      * @dev See {IERC165-supportsInterface}.
392      */
393     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394         return interfaceId == type(IAccessControl).interfaceId
395             || super.supportsInterface(interfaceId);
396     }
397 
398     /**
399      * @dev Returns `true` if `account` has been granted `role`.
400      */
401     function hasRole(bytes32 role, address account) public view override returns (bool) {
402         return _roles[role].members[account];
403     }
404 
405     /**
406      * @dev Returns the admin role that controls `role`. See {grantRole} and
407      * {revokeRole}.
408      *
409      * To change a role's admin, use {_setRoleAdmin}.
410      */
411     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
412         return _roles[role].adminRole;
413     }
414 
415     /**
416      * @dev Grants `role` to `account`.
417      *
418      * If `account` had not been already granted `role`, emits a {RoleGranted}
419      * event.
420      *
421      * Requirements:
422      *
423      * - the caller must have ``role``'s admin role.
424      */
425     function grantRole(bytes32 role, address account) public virtual override {
426         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
427 
428         _grantRole(role, account);
429     }
430 
431     /**
432      * @dev Revokes `role` from `account`.
433      *
434      * If `account` had been granted `role`, emits a {RoleRevoked} event.
435      *
436      * Requirements:
437      *
438      * - the caller must have ``role``'s admin role.
439      */
440     function revokeRole(bytes32 role, address account) public virtual override {
441         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
442 
443         _revokeRole(role, account);
444     }
445 
446     /**
447      * @dev Revokes `role` from the calling account.
448      *
449      * Roles are often managed via {grantRole} and {revokeRole}: this function's
450      * purpose is to provide a mechanism for accounts to lose their privileges
451      * if they are compromised (such as when a trusted device is misplaced).
452      *
453      * If the calling account had been granted `role`, emits a {RoleRevoked}
454      * event.
455      *
456      * Requirements:
457      *
458      * - the caller must be `account`.
459      */
460     function renounceRole(bytes32 role, address account) public virtual override {
461         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
462 
463         _revokeRole(role, account);
464     }
465 
466     /**
467      * @dev Grants `role` to `account`.
468      *
469      * If `account` had not been already granted `role`, emits a {RoleGranted}
470      * event. Note that unlike {grantRole}, this function doesn't perform any
471      * checks on the calling account.
472      *
473      * [WARNING]
474      * ====
475      * This function should only be called from the constructor when setting
476      * up the initial roles for the system.
477      *
478      * Using this function in any other way is effectively circumventing the admin
479      * system imposed by {AccessControl}.
480      * ====
481      */
482     function _setupRole(bytes32 role, address account) internal virtual {
483         _grantRole(role, account);
484     }
485 
486     /**
487      * @dev Sets `adminRole` as ``role``'s admin role.
488      *
489      * Emits a {RoleAdminChanged} event.
490      */
491     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
492         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
493         _roles[role].adminRole = adminRole;
494     }
495 
496     function _grantRole(bytes32 role, address account) private {
497         if (!hasRole(role, account)) {
498             _roles[role].members[account] = true;
499             emit RoleGranted(role, account, _msgSender());
500         }
501     }
502 
503     function _revokeRole(bytes32 role, address account) private {
504         if (hasRole(role, account)) {
505             _roles[role].members[account] = false;
506             emit RoleRevoked(role, account, _msgSender());
507         }
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Interface of the ERC20 standard as defined in the EIP.
517  */
518 interface IERC20 {
519     /**
520      * @dev Returns the amount of tokens in existence.
521      */
522     function totalSupply() external view returns (uint256);
523 
524     /**
525      * @dev Returns the amount of tokens owned by `account`.
526      */
527     function balanceOf(address account) external view returns (uint256);
528 
529     /**
530      * @dev Moves `amount` tokens from the caller's account to `recipient`.
531      *
532      * Returns a boolean value indicating whether the operation succeeded.
533      *
534      * Emits a {Transfer} event.
535      */
536     function transfer(address recipient, uint256 amount) external returns (bool);
537 
538     /**
539      * @dev Returns the remaining number of tokens that `spender` will be
540      * allowed to spend on behalf of `owner` through {transferFrom}. This is
541      * zero by default.
542      *
543      * This value changes when {approve} or {transferFrom} are called.
544      */
545     function allowance(address owner, address spender) external view returns (uint256);
546 
547     /**
548      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
549      *
550      * Returns a boolean value indicating whether the operation succeeded.
551      *
552      * IMPORTANT: Beware that changing an allowance with this method brings the risk
553      * that someone may use both the old and the new allowance by unfortunate
554      * transaction ordering. One possible solution to mitigate this race
555      * condition is to first reduce the spender's allowance to 0 and set the
556      * desired value afterwards:
557      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
558      *
559      * Emits an {Approval} event.
560      */
561     function approve(address spender, uint256 amount) external returns (bool);
562 
563     /**
564      * @dev Moves `amount` tokens from `sender` to `recipient` using the
565      * allowance mechanism. `amount` is then deducted from the caller's
566      * allowance.
567      *
568      * Returns a boolean value indicating whether the operation succeeded.
569      *
570      * Emits a {Transfer} event.
571      */
572     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
573 
574     /**
575      * @dev Emitted when `value` tokens are moved from one account (`from`) to
576      * another (`to`).
577      *
578      * Note that `value` may be zero.
579      */
580     event Transfer(address indexed from, address indexed to, uint256 value);
581 
582     /**
583      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
584      * a call to {approve}. `value` is the new allowance.
585      */
586     event Approval(address indexed owner, address indexed spender, uint256 value);
587 }
588 
589 // File: @openzeppelin/contracts/utils/Address.sol
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Collection of functions related to the address type
595  */
596 library Address {
597     /**
598      * @dev Returns true if `account` is a contract.
599      *
600      * [IMPORTANT]
601      * ====
602      * It is unsafe to assume that an address for which this function returns
603      * false is an externally-owned account (EOA) and not a contract.
604      *
605      * Among others, `isContract` will return false for the following
606      * types of addresses:
607      *
608      *  - an externally-owned account
609      *  - a contract in construction
610      *  - an address where a contract will be created
611      *  - an address where a contract lived, but was destroyed
612      * ====
613      */
614     function isContract(address account) internal view returns (bool) {
615         // This method relies on extcodesize, which returns 0 for contracts in
616         // construction, since the code is only stored at the end of the
617         // constructor execution.
618 
619         uint256 size;
620         // solhint-disable-next-line no-inline-assembly
621         assembly { size := extcodesize(account) }
622         return size > 0;
623     }
624 
625     /**
626      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
627      * `recipient`, forwarding all available gas and reverting on errors.
628      *
629      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
630      * of certain opcodes, possibly making contracts go over the 2300 gas limit
631      * imposed by `transfer`, making them unable to receive funds via
632      * `transfer`. {sendValue} removes this limitation.
633      *
634      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
635      *
636      * IMPORTANT: because control is transferred to `recipient`, care must be
637      * taken to not create reentrancy vulnerabilities. Consider using
638      * {ReentrancyGuard} or the
639      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
640      */
641     function sendValue(address payable recipient, uint256 amount) internal {
642         require(address(this).balance >= amount, "Address: insufficient balance");
643 
644         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
645         (bool success, ) = recipient.call{ value: amount }("");
646         require(success, "Address: unable to send value, recipient may have reverted");
647     }
648 
649     /**
650      * @dev Performs a Solidity function call using a low level `call`. A
651      * plain`call` is an unsafe replacement for a function call: use this
652      * function instead.
653      *
654      * If `target` reverts with a revert reason, it is bubbled up by this
655      * function (like regular Solidity function calls).
656      *
657      * Returns the raw returned data. To convert to the expected return value,
658      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
659      *
660      * Requirements:
661      *
662      * - `target` must be a contract.
663      * - calling `target` with `data` must not revert.
664      *
665      * _Available since v3.1._
666      */
667     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
668       return functionCall(target, data, "Address: low-level call failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
673      * `errorMessage` as a fallback revert reason when `target` reverts.
674      *
675      * _Available since v3.1._
676      */
677     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
678         return functionCallWithValue(target, data, 0, errorMessage);
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
683      * but also transferring `value` wei to `target`.
684      *
685      * Requirements:
686      *
687      * - the calling contract must have an ETH balance of at least `value`.
688      * - the called Solidity function must be `payable`.
689      *
690      * _Available since v3.1._
691      */
692     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
698      * with `errorMessage` as a fallback revert reason when `target` reverts.
699      *
700      * _Available since v3.1._
701      */
702     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
703         require(address(this).balance >= value, "Address: insufficient balance for call");
704         require(isContract(target), "Address: call to non-contract");
705 
706         // solhint-disable-next-line avoid-low-level-calls
707         (bool success, bytes memory returndata) = target.call{ value: value }(data);
708         return _verifyCallResult(success, returndata, errorMessage);
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
713      * but performing a static call.
714      *
715      * _Available since v3.3._
716      */
717     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
718         return functionStaticCall(target, data, "Address: low-level static call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
723      * but performing a static call.
724      *
725      * _Available since v3.3._
726      */
727     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
728         require(isContract(target), "Address: static call to non-contract");
729 
730         // solhint-disable-next-line avoid-low-level-calls
731         (bool success, bytes memory returndata) = target.staticcall(data);
732         return _verifyCallResult(success, returndata, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but performing a delegate call.
738      *
739      * _Available since v3.4._
740      */
741     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
742         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
747      * but performing a delegate call.
748      *
749      * _Available since v3.4._
750      */
751     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
752         require(isContract(target), "Address: delegate call to non-contract");
753 
754         // solhint-disable-next-line avoid-low-level-calls
755         (bool success, bytes memory returndata) = target.delegatecall(data);
756         return _verifyCallResult(success, returndata, errorMessage);
757     }
758 
759     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
760         if (success) {
761             return returndata;
762         } else {
763             // Look for revert reason and bubble it up if present
764             if (returndata.length > 0) {
765                 // The easiest way to bubble the revert reason is using memory via assembly
766 
767                 // solhint-disable-next-line no-inline-assembly
768                 assembly {
769                     let returndata_size := mload(returndata)
770                     revert(add(32, returndata), returndata_size)
771                 }
772             } else {
773                 revert(errorMessage);
774             }
775         }
776     }
777 }
778 
779 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
780 
781 pragma solidity ^0.8.0;
782 
783 /**
784  * @title SafeERC20
785  * @dev Wrappers around ERC20 operations that throw on failure (when the token
786  * contract returns false). Tokens that return no value (and instead revert or
787  * throw on failure) are also supported, non-reverting calls are assumed to be
788  * successful.
789  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
790  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
791  */
792 library SafeERC20 {
793     using Address for address;
794 
795     function safeTransfer(IERC20 token, address to, uint256 value) internal {
796         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
797     }
798 
799     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
800         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
801     }
802 
803     /**
804      * @dev Deprecated. This function has issues similar to the ones found in
805      * {IERC20-approve}, and its usage is discouraged.
806      *
807      * Whenever possible, use {safeIncreaseAllowance} and
808      * {safeDecreaseAllowance} instead.
809      */
810     function safeApprove(IERC20 token, address spender, uint256 value) internal {
811         // safeApprove should only be called when setting an initial allowance,
812         // or when resetting it to zero. To increase and decrease it, use
813         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
814         // solhint-disable-next-line max-line-length
815         require((value == 0) || (token.allowance(address(this), spender) == 0),
816             "SafeERC20: approve from non-zero to non-zero allowance"
817         );
818         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
819     }
820 
821     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
822         uint256 newAllowance = token.allowance(address(this), spender) + value;
823         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
824     }
825 
826     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
827         //unchecked {
828             uint256 oldAllowance = token.allowance(address(this), spender);
829             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
830             uint256 newAllowance = oldAllowance - value;
831             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
832         //}
833     }
834 
835     /**
836      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
837      * on the return value: the return value is optional (but if data is returned, it must not be false).
838      * @param token The token targeted by the call.
839      * @param data The call data (encoded using abi.encode or one of its variants).
840      */
841     function _callOptionalReturn(IERC20 token, bytes memory data) private {
842         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
843         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
844         // the target address contains contract code and also asserts for success in the low-level call.
845 
846         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
847         if (returndata.length > 0) { // Return data is optional
848             // solhint-disable-next-line max-line-length
849             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
850         }
851     }
852 }
853 
854 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
855 
856 pragma solidity ^0.8.0;
857 
858 /**
859  * @dev Contract module that helps prevent reentrant calls to a function.
860  *
861  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
862  * available, which can be applied to functions to make sure there are no nested
863  * (reentrant) calls to them.
864  *
865  * Note that because there is a single `nonReentrant` guard, functions marked as
866  * `nonReentrant` may not call one another. This can be worked around by making
867  * those functions `private`, and then adding `external` `nonReentrant` entry
868  * points to them.
869  *
870  * TIP: If you would like to learn more about reentrancy and alternative ways
871  * to protect against it, check out our blog post
872  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
873  */
874 abstract contract ReentrancyGuard {
875     // Booleans are more expensive than uint256 or any type that takes up a full
876     // word because each write operation emits an extra SLOAD to first read the
877     // slot's contents, replace the bits taken up by the boolean, and then write
878     // back. This is the compiler's defense against contract upgrades and
879     // pointer aliasing, and it cannot be disabled.
880 
881     // The values being non-zero value makes deployment a bit more expensive,
882     // but in exchange the refund on every call to nonReentrant will be lower in
883     // amount. Since refunds are capped to a percentage of the total
884     // transaction's gas, it is best to keep them low in cases like this one, to
885     // increase the likelihood of the full refund coming into effect.
886     uint256 private constant _NOT_ENTERED = 1;
887     uint256 private constant _ENTERED = 2;
888 
889     uint256 private _status;
890 
891     constructor () {
892         _status = _NOT_ENTERED;
893     }
894 
895     /**
896      * @dev Prevents a contract from calling itself, directly or indirectly.
897      * Calling a `nonReentrant` function from another `nonReentrant`
898      * function is not supported. It is possible to prevent this from happening
899      * by making the `nonReentrant` function external, and make it call a
900      * `private` function that does the actual work.
901      */
902     modifier nonReentrant() {
903         // On the first call to nonReentrant, _notEntered will be true
904         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
905 
906         // Any calls to nonReentrant after this point will fail
907         _status = _ENTERED;
908 
909         _;
910 
911         // By storing the original value once again, a refund is triggered (see
912         // https://eips.ethereum.org/EIPS/eip-2200)
913         _status = _NOT_ENTERED;
914     }
915 }
916 
917 // File: contracts/bridge/mainnet/Uniswap.sol
918 
919 pragma solidity ^0.8.3;
920 
921 interface Uniswap {
922   function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
923     external returns (uint256[] memory amounts);
924   function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
925     external payable returns (uint256[] memory amounts);
926   function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline)
927     external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
928   function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline)
929     external returns (uint amountA, uint amountB);
930   function getPair(address tokenA, address tokenB)
931     external view returns (address pair);
932   function WETH() external pure returns (address);
933   function getAmountsOut(uint amountIn, address[] memory path)
934     external view returns (uint[] memory amounts);
935   function getAmountsIn(uint amountOut, address[] memory path)
936     external view returns (uint[] memory amounts);
937   function getReserves() 
938     external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
939   function token0() external view returns (address);
940   function token1() external view returns (address);
941 }
942 
943 // File: contracts/bridge/mainnet/MainnetBridgePool.sol
944 
945 pragma solidity ^0.8.3;
946 
947 contract MainnetBridgePool is AccessControl, ReentrancyGuard {
948   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
949 
950   using SafeMath for uint256;
951   using SafeERC20 for IERC20;
952 
953   IERC20 public raini;
954 
955   event Deposited(address indexed spender, address recipient, uint256 amount, uint256 requestId);
956   event Withdrawn(address indexed owner, uint256 amount, uint256 requestId);
957   event EthWithdrawn(uint256 amount);
958   event FeeSet(uint256 fee, uint256 percentFee, uint256 percentFeeDecimals);
959   event AutoWithdrawFeeSet(bool autoWithdraw);
960   event TreasuryAddressSet(address treasuryAddress);
961 
962   uint256 public  requestId;
963   uint256 public  fee;
964   uint256 public  percentFee;
965   uint    public  percentFeeDecimals;
966   bool    public  autoWithdrawFee;
967   address public  treasuryAddress;
968 
969   address private constant  UNIROUTER     = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
970   address private constant  FACTORY       = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
971   address private           WETHAddress   = Uniswap(UNIROUTER).WETH();
972 
973   constructor(address _raini) {
974     require(_raini != address(0), "MainnetBridgePool: _raini is zero address");
975 
976     _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
977     treasuryAddress = _msgSender();
978     raini = IERC20(_raini);
979   }
980 
981   modifier onlyMinter() {
982     require(hasRole(MINTER_ROLE, _msgSender()), "MainnetBridgePool: caller is not a minter");
983     _;
984   }
985 
986   modifier onlyOwner() {
987     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "MainnetBridgePool: caller is not an owner");
988     _;
989   }
990 
991   function getFee(uint _amount) public view returns (uint256) {
992     address lp = Uniswap(FACTORY).getPair(address(raini), WETHAddress);
993     (uint reserve0, uint reserve1, ) = Uniswap(lp).getReserves();
994     uint256 eth;
995     if(Uniswap(lp).token0() == address(raini)) {
996       eth = reserve1.mul(_amount).div(reserve0);
997     } else {
998       eth = reserve0.mul(_amount).div(reserve1);
999     }
1000     return fee + eth.mul(percentFee).div(10 ** percentFeeDecimals);
1001   }
1002 
1003   function setFee(uint256 _fee, uint256 _percentFee, uint256 _percentFeeDecimals)
1004     external onlyOwner {
1005       fee = _fee;
1006       percentFee = _percentFee;
1007       percentFeeDecimals = _percentFeeDecimals;
1008       emit FeeSet(_fee, _percentFee, _percentFeeDecimals);
1009   }
1010 
1011   function setAutoWithdrawFee(bool _autoWithdrawFee)
1012     external onlyOwner {
1013       autoWithdrawFee = _autoWithdrawFee;
1014       emit AutoWithdrawFeeSet(autoWithdrawFee);
1015   }
1016 
1017   function setTreasuryAddress(address _treasuryAddress)
1018     external onlyOwner {
1019       treasuryAddress = _treasuryAddress;
1020       emit TreasuryAddressSet(_treasuryAddress);
1021   }  
1022 
1023   function deposit(address _recipient, uint256 _amount) 
1024     external payable nonReentrant {
1025       uint256 depositFee = getFee(_amount);
1026       require(msg.value >= depositFee, "MainnetBridgePool: not enough eth");
1027 
1028       raini.safeTransferFrom(_msgSender(), address(this), _amount);
1029 
1030       uint256 refund = msg.value - depositFee;
1031       if(refund > 0) {
1032         (bool refundSuccess, ) = _msgSender().call{ value: refund }("");
1033         require(refundSuccess, "MainnetBridgePool: refund transfer failed");
1034       }
1035 
1036       if (autoWithdrawFee) {
1037         (bool withdrawSuccess, ) = treasuryAddress.call{ value: depositFee }("");
1038         require(withdrawSuccess, "MainnetBridgePool: withdraw transfer failed");
1039       }
1040 
1041       requestId++;
1042       emit Deposited(_msgSender(), _recipient, _amount, requestId);
1043   }
1044 
1045   function withdraw(address[] memory _owners, uint256[] memory _amounts, uint256[] memory _requestsIds) 
1046     external onlyMinter {
1047       require(_owners.length == _amounts.length && _owners.length == _requestsIds.length, "MainnetBridgePool: Arrays length not equal");
1048 
1049       for (uint256 i; i < _owners.length; i++) {
1050         raini.safeTransfer(_owners[i], _amounts[i]);
1051         emit Withdrawn(_owners[i], _amounts[i], _requestsIds[i]);
1052       }
1053   }
1054 
1055   function withdrawEth(uint256 _amount)
1056     external onlyOwner {
1057       require(_amount <= address(this).balance, "MainnetBridgePool: not enough balance");
1058       (bool success, ) = _msgSender().call{ value: _amount }("");
1059       require(success, "MainnetBridgePool: transfer failed");
1060       emit EthWithdrawn(_amount);
1061   }
1062 }