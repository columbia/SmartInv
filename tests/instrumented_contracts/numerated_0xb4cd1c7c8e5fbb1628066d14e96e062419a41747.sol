1 // File: @uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol
2 
3 
4 pragma solidity >=0.5.0;
5 
6 /// @title Callback for IUniswapV3PoolActions#swap
7 /// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
8 interface IUniswapV3SwapCallback {
9     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
10     /// @dev In the implementation you must pay the pool tokens owed for the swap.
11     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
12     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
13     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
14     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
15     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
16     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
17     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
18     function uniswapV3SwapCallback(
19         int256 amount0Delta,
20         int256 amount1Delta,
21         bytes calldata data
22     ) external;
23 }
24 
25 // File: @uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol
26 
27 
28 pragma solidity >=0.7.5;
29 pragma abicoder v2;
30 
31 
32 /// @title Router token swapping functionality
33 /// @notice Functions for swapping tokens via Uniswap V3
34 interface ISwapRouter is IUniswapV3SwapCallback {
35     struct ExactInputSingleParams {
36         address tokenIn;
37         address tokenOut;
38         uint24 fee;
39         address recipient;
40         uint256 deadline;
41         uint256 amountIn;
42         uint256 amountOutMinimum;
43         uint160 sqrtPriceLimitX96;
44     }
45 
46     /// @notice Swaps `amountIn` of one token for as much as possible of another token
47     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
48     /// @return amountOut The amount of the received token
49     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
50 
51     struct ExactInputParams {
52         bytes path;
53         address recipient;
54         uint256 deadline;
55         uint256 amountIn;
56         uint256 amountOutMinimum;
57     }
58 
59     /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
60     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
61     /// @return amountOut The amount of the received token
62     function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);
63 
64     struct ExactOutputSingleParams {
65         address tokenIn;
66         address tokenOut;
67         uint24 fee;
68         address recipient;
69         uint256 deadline;
70         uint256 amountOut;
71         uint256 amountInMaximum;
72         uint160 sqrtPriceLimitX96;
73     }
74 
75     /// @notice Swaps as little as possible of one token for `amountOut` of another token
76     /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
77     /// @return amountIn The amount of the input token
78     function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);
79 
80     struct ExactOutputParams {
81         bytes path;
82         address recipient;
83         uint256 deadline;
84         uint256 amountOut;
85         uint256 amountInMaximum;
86     }
87 
88     /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
89     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
90     /// @return amountIn The amount of the input token
91     function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
92 }
93 
94 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 // CAUTION
102 // This version of SafeMath should only be used with Solidity 0.8 or later,
103 // because it relies on the compiler's built in overflow checks.
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations.
107  *
108  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
109  * now has built in overflow checking.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, with an overflow flag.
114      *
115      * _Available since v3.4._
116      */
117     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         unchecked {
119             uint256 c = a + b;
120             if (c < a) return (false, 0);
121             return (true, c);
122         }
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             if (b > a) return (false, 0);
133             return (true, a - b);
134         }
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
139      *
140      * _Available since v3.4._
141      */
142     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         unchecked {
144             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145             // benefit is lost if 'b' is also tested.
146             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
147             if (a == 0) return (true, 0);
148             uint256 c = a * b;
149             if (c / a != b) return (false, 0);
150             return (true, c);
151         }
152     }
153 
154     /**
155      * @dev Returns the division of two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             if (b == 0) return (false, 0);
162             return (true, a / b);
163         }
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         unchecked {
173             if (b == 0) return (false, 0);
174             return (true, a % b);
175         }
176     }
177 
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      *
186      * - Addition cannot overflow.
187      */
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         return a + b;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a - b;
204     }
205 
206     /**
207      * @dev Returns the multiplication of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `*` operator.
211      *
212      * Requirements:
213      *
214      * - Multiplication cannot overflow.
215      */
216     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a * b;
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers, reverting on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator.
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a / b;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * reverting when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return a % b;
248     }
249 
250     /**
251      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
252      * overflow (when the result is negative).
253      *
254      * CAUTION: This function is deprecated because it requires allocating memory for the error
255      * message unnecessarily. For custom revert reasons use {trySub}.
256      *
257      * Counterpart to Solidity's `-` operator.
258      *
259      * Requirements:
260      *
261      * - Subtraction cannot overflow.
262      */
263     function sub(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         unchecked {
269             require(b <= a, errorMessage);
270             return a - b;
271         }
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * Counterpart to Solidity's `/` operator. Note: this function uses a
279      * `revert` opcode (which leaves remaining gas untouched) while Solidity
280      * uses an invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function div(
287         uint256 a,
288         uint256 b,
289         string memory errorMessage
290     ) internal pure returns (uint256) {
291         unchecked {
292             require(b > 0, errorMessage);
293             return a / b;
294         }
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * reverting with custom message when dividing by zero.
300      *
301      * CAUTION: This function is deprecated because it requires allocating memory for the error
302      * message unnecessarily. For custom revert reasons use {tryMod}.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function mod(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         unchecked {
318             require(b > 0, errorMessage);
319             return a % b;
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Interface of the ERC165 standard, as defined in the
333  * https://eips.ethereum.org/EIPS/eip-165[EIP].
334  *
335  * Implementers can declare support of contract interfaces, which can then be
336  * queried by others ({ERC165Checker}).
337  *
338  * For an implementation, see {ERC165}.
339  */
340 interface IERC165 {
341     /**
342      * @dev Returns true if this contract implements the interface defined by
343      * `interfaceId`. See the corresponding
344      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
345      * to learn more about how these ids are created.
346      *
347      * This function call must use less than 30 000 gas.
348      */
349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
350 }
351 
352 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev Implementation of the {IERC165} interface.
362  *
363  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
364  * for the additional interface id that will be supported. For example:
365  *
366  * ```solidity
367  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
369  * }
370  * ```
371  *
372  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
373  */
374 abstract contract ERC165 is IERC165 {
375     /**
376      * @dev See {IERC165-supportsInterface}.
377      */
378     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379         return interfaceId == type(IERC165).interfaceId;
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/Strings.sol
384 
385 
386 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @dev String operations.
392  */
393 library Strings {
394     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
395     uint8 private constant _ADDRESS_LENGTH = 20;
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
399      */
400     function toString(uint256 value) internal pure returns (string memory) {
401         // Inspired by OraclizeAPI's implementation - MIT licence
402         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
403 
404         if (value == 0) {
405             return "0";
406         }
407         uint256 temp = value;
408         uint256 digits;
409         while (temp != 0) {
410             digits++;
411             temp /= 10;
412         }
413         bytes memory buffer = new bytes(digits);
414         while (value != 0) {
415             digits -= 1;
416             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
417             value /= 10;
418         }
419         return string(buffer);
420     }
421 
422     /**
423      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
424      */
425     function toHexString(uint256 value) internal pure returns (string memory) {
426         if (value == 0) {
427             return "0x00";
428         }
429         uint256 temp = value;
430         uint256 length = 0;
431         while (temp != 0) {
432             length++;
433             temp >>= 8;
434         }
435         return toHexString(value, length);
436     }
437 
438     /**
439      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
440      */
441     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
442         bytes memory buffer = new bytes(2 * length + 2);
443         buffer[0] = "0";
444         buffer[1] = "x";
445         for (uint256 i = 2 * length + 1; i > 1; --i) {
446             buffer[i] = _HEX_SYMBOLS[value & 0xf];
447             value >>= 4;
448         }
449         require(value == 0, "Strings: hex length insufficient");
450         return string(buffer);
451     }
452 
453     /**
454      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
455      */
456     function toHexString(address addr) internal pure returns (string memory) {
457         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
458     }
459 }
460 
461 // File: @openzeppelin/contracts/access/IAccessControl.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev External interface of AccessControl declared to support ERC165 detection.
470  */
471 interface IAccessControl {
472     /**
473      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
474      *
475      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
476      * {RoleAdminChanged} not being emitted signaling this.
477      *
478      * _Available since v3.1._
479      */
480     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
481 
482     /**
483      * @dev Emitted when `account` is granted `role`.
484      *
485      * `sender` is the account that originated the contract call, an admin role
486      * bearer except when using {AccessControl-_setupRole}.
487      */
488     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
489 
490     /**
491      * @dev Emitted when `account` is revoked `role`.
492      *
493      * `sender` is the account that originated the contract call:
494      *   - if using `revokeRole`, it is the admin role bearer
495      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
496      */
497     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
498 
499     /**
500      * @dev Returns `true` if `account` has been granted `role`.
501      */
502     function hasRole(bytes32 role, address account) external view returns (bool);
503 
504     /**
505      * @dev Returns the admin role that controls `role`. See {grantRole} and
506      * {revokeRole}.
507      *
508      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
509      */
510     function getRoleAdmin(bytes32 role) external view returns (bytes32);
511 
512     /**
513      * @dev Grants `role` to `account`.
514      *
515      * If `account` had not been already granted `role`, emits a {RoleGranted}
516      * event.
517      *
518      * Requirements:
519      *
520      * - the caller must have ``role``'s admin role.
521      */
522     function grantRole(bytes32 role, address account) external;
523 
524     /**
525      * @dev Revokes `role` from `account`.
526      *
527      * If `account` had been granted `role`, emits a {RoleRevoked} event.
528      *
529      * Requirements:
530      *
531      * - the caller must have ``role``'s admin role.
532      */
533     function revokeRole(bytes32 role, address account) external;
534 
535     /**
536      * @dev Revokes `role` from the calling account.
537      *
538      * Roles are often managed via {grantRole} and {revokeRole}: this function's
539      * purpose is to provide a mechanism for accounts to lose their privileges
540      * if they are compromised (such as when a trusted device is misplaced).
541      *
542      * If the calling account had been granted `role`, emits a {RoleRevoked}
543      * event.
544      *
545      * Requirements:
546      *
547      * - the caller must be `account`.
548      */
549     function renounceRole(bytes32 role, address account) external;
550 }
551 
552 // File: @openzeppelin/contracts/utils/Context.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev Provides information about the current execution context, including the
561  * sender of the transaction and its data. While these are generally available
562  * via msg.sender and msg.data, they should not be accessed in such a direct
563  * manner, since when dealing with meta-transactions the account sending and
564  * paying for execution may not be the actual sender (as far as an application
565  * is concerned).
566  *
567  * This contract is only required for intermediate, library-like contracts.
568  */
569 abstract contract Context {
570     function _msgSender() internal view virtual returns (address) {
571         return msg.sender;
572     }
573 
574     function _msgData() internal view virtual returns (bytes calldata) {
575         return msg.data;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/access/AccessControl.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 
588 
589 
590 /**
591  * @dev Contract module that allows children to implement role-based access
592  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
593  * members except through off-chain means by accessing the contract event logs. Some
594  * applications may benefit from on-chain enumerability, for those cases see
595  * {AccessControlEnumerable}.
596  *
597  * Roles are referred to by their `bytes32` identifier. These should be exposed
598  * in the external API and be unique. The best way to achieve this is by
599  * using `public constant` hash digests:
600  *
601  * ```
602  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
603  * ```
604  *
605  * Roles can be used to represent a set of permissions. To restrict access to a
606  * function call, use {hasRole}:
607  *
608  * ```
609  * function foo() public {
610  *     require(hasRole(MY_ROLE, msg.sender));
611  *     ...
612  * }
613  * ```
614  *
615  * Roles can be granted and revoked dynamically via the {grantRole} and
616  * {revokeRole} functions. Each role has an associated admin role, and only
617  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
618  *
619  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
620  * that only accounts with this role will be able to grant or revoke other
621  * roles. More complex role relationships can be created by using
622  * {_setRoleAdmin}.
623  *
624  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
625  * grant and revoke this role. Extra precautions should be taken to secure
626  * accounts that have been granted it.
627  */
628 abstract contract AccessControl is Context, IAccessControl, ERC165 {
629     struct RoleData {
630         mapping(address => bool) members;
631         bytes32 adminRole;
632     }
633 
634     mapping(bytes32 => RoleData) private _roles;
635 
636     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
637 
638     /**
639      * @dev Modifier that checks that an account has a specific role. Reverts
640      * with a standardized message including the required role.
641      *
642      * The format of the revert reason is given by the following regular expression:
643      *
644      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
645      *
646      * _Available since v4.1._
647      */
648     modifier onlyRole(bytes32 role) {
649         _checkRole(role);
650         _;
651     }
652 
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
657         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
658     }
659 
660     /**
661      * @dev Returns `true` if `account` has been granted `role`.
662      */
663     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
664         return _roles[role].members[account];
665     }
666 
667     /**
668      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
669      * Overriding this function changes the behavior of the {onlyRole} modifier.
670      *
671      * Format of the revert message is described in {_checkRole}.
672      *
673      * _Available since v4.6._
674      */
675     function _checkRole(bytes32 role) internal view virtual {
676         _checkRole(role, _msgSender());
677     }
678 
679     /**
680      * @dev Revert with a standard message if `account` is missing `role`.
681      *
682      * The format of the revert reason is given by the following regular expression:
683      *
684      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
685      */
686     function _checkRole(bytes32 role, address account) internal view virtual {
687         if (!hasRole(role, account)) {
688             revert(
689                 string(
690                     abi.encodePacked(
691                         "AccessControl: account ",
692                         Strings.toHexString(uint160(account), 20),
693                         " is missing role ",
694                         Strings.toHexString(uint256(role), 32)
695                     )
696                 )
697             );
698         }
699     }
700 
701     /**
702      * @dev Returns the admin role that controls `role`. See {grantRole} and
703      * {revokeRole}.
704      *
705      * To change a role's admin, use {_setRoleAdmin}.
706      */
707     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
708         return _roles[role].adminRole;
709     }
710 
711     /**
712      * @dev Grants `role` to `account`.
713      *
714      * If `account` had not been already granted `role`, emits a {RoleGranted}
715      * event.
716      *
717      * Requirements:
718      *
719      * - the caller must have ``role``'s admin role.
720      *
721      * May emit a {RoleGranted} event.
722      */
723     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
724         _grantRole(role, account);
725     }
726 
727     /**
728      * @dev Revokes `role` from `account`.
729      *
730      * If `account` had been granted `role`, emits a {RoleRevoked} event.
731      *
732      * Requirements:
733      *
734      * - the caller must have ``role``'s admin role.
735      *
736      * May emit a {RoleRevoked} event.
737      */
738     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
739         _revokeRole(role, account);
740     }
741 
742     /**
743      * @dev Revokes `role` from the calling account.
744      *
745      * Roles are often managed via {grantRole} and {revokeRole}: this function's
746      * purpose is to provide a mechanism for accounts to lose their privileges
747      * if they are compromised (such as when a trusted device is misplaced).
748      *
749      * If the calling account had been revoked `role`, emits a {RoleRevoked}
750      * event.
751      *
752      * Requirements:
753      *
754      * - the caller must be `account`.
755      *
756      * May emit a {RoleRevoked} event.
757      */
758     function renounceRole(bytes32 role, address account) public virtual override {
759         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
760 
761         _revokeRole(role, account);
762     }
763 
764     /**
765      * @dev Grants `role` to `account`.
766      *
767      * If `account` had not been already granted `role`, emits a {RoleGranted}
768      * event. Note that unlike {grantRole}, this function doesn't perform any
769      * checks on the calling account.
770      *
771      * May emit a {RoleGranted} event.
772      *
773      * [WARNING]
774      * ====
775      * This function should only be called from the constructor when setting
776      * up the initial roles for the system.
777      *
778      * Using this function in any other way is effectively circumventing the admin
779      * system imposed by {AccessControl}.
780      * ====
781      *
782      * NOTE: This function is deprecated in favor of {_grantRole}.
783      */
784     function _setupRole(bytes32 role, address account) internal virtual {
785         _grantRole(role, account);
786     }
787 
788     /**
789      * @dev Sets `adminRole` as ``role``'s admin role.
790      *
791      * Emits a {RoleAdminChanged} event.
792      */
793     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
794         bytes32 previousAdminRole = getRoleAdmin(role);
795         _roles[role].adminRole = adminRole;
796         emit RoleAdminChanged(role, previousAdminRole, adminRole);
797     }
798 
799     /**
800      * @dev Grants `role` to `account`.
801      *
802      * Internal function without access restriction.
803      *
804      * May emit a {RoleGranted} event.
805      */
806     function _grantRole(bytes32 role, address account) internal virtual {
807         if (!hasRole(role, account)) {
808             _roles[role].members[account] = true;
809             emit RoleGranted(role, account, _msgSender());
810         }
811     }
812 
813     /**
814      * @dev Revokes `role` from `account`.
815      *
816      * Internal function without access restriction.
817      *
818      * May emit a {RoleRevoked} event.
819      */
820     function _revokeRole(bytes32 role, address account) internal virtual {
821         if (hasRole(role, account)) {
822             _roles[role].members[account] = false;
823             emit RoleRevoked(role, account, _msgSender());
824         }
825     }
826 }
827 
828 // File: @openzeppelin/contracts/access/Ownable.sol
829 
830 
831 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 
836 /**
837  * @dev Contract module which provides a basic access control mechanism, where
838  * there is an account (an owner) that can be granted exclusive access to
839  * specific functions.
840  *
841  * By default, the owner account will be the one that deploys the contract. This
842  * can later be changed with {transferOwnership}.
843  *
844  * This module is used through inheritance. It will make available the modifier
845  * `onlyOwner`, which can be applied to your functions to restrict their use to
846  * the owner.
847  */
848 abstract contract Ownable is Context {
849     address private _owner;
850 
851     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
852 
853     /**
854      * @dev Initializes the contract setting the deployer as the initial owner.
855      */
856     constructor() {
857         _transferOwnership(_msgSender());
858     }
859 
860     /**
861      * @dev Throws if called by any account other than the owner.
862      */
863     modifier onlyOwner() {
864         _checkOwner();
865         _;
866     }
867 
868     /**
869      * @dev Returns the address of the current owner.
870      */
871     function owner() public view virtual returns (address) {
872         return _owner;
873     }
874 
875     /**
876      * @dev Throws if the sender is not the owner.
877      */
878     function _checkOwner() internal view virtual {
879         require(owner() == _msgSender(), "Ownable: caller is not the owner");
880     }
881 
882     /**
883      * @dev Leaves the contract without owner. It will not be possible to call
884      * `onlyOwner` functions anymore. Can only be called by the current owner.
885      *
886      * NOTE: Renouncing ownership will leave the contract without an owner,
887      * thereby removing any functionality that is only available to the owner.
888      */
889     function renounceOwnership() public virtual onlyOwner {
890         _transferOwnership(address(0));
891     }
892 
893     /**
894      * @dev Transfers ownership of the contract to a new account (`newOwner`).
895      * Can only be called by the current owner.
896      */
897     function transferOwnership(address newOwner) public virtual onlyOwner {
898         require(newOwner != address(0), "Ownable: new owner is the zero address");
899         _transferOwnership(newOwner);
900     }
901 
902     /**
903      * @dev Transfers ownership of the contract to a new account (`newOwner`).
904      * Internal function without access restriction.
905      */
906     function _transferOwnership(address newOwner) internal virtual {
907         address oldOwner = _owner;
908         _owner = newOwner;
909         emit OwnershipTransferred(oldOwner, newOwner);
910     }
911 }
912 
913 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
914 
915 
916 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
917 
918 pragma solidity ^0.8.0;
919 
920 /**
921  * @dev Interface of the ERC20 standard as defined in the EIP.
922  */
923 interface IERC20 {
924     /**
925      * @dev Emitted when `value` tokens are moved from one account (`from`) to
926      * another (`to`).
927      *
928      * Note that `value` may be zero.
929      */
930     event Transfer(address indexed from, address indexed to, uint256 value);
931 
932     /**
933      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
934      * a call to {approve}. `value` is the new allowance.
935      */
936     event Approval(address indexed owner, address indexed spender, uint256 value);
937 
938     /**
939      * @dev Returns the amount of tokens in existence.
940      */
941     function totalSupply() external view returns (uint256);
942 
943     /**
944      * @dev Returns the amount of tokens owned by `account`.
945      */
946     function balanceOf(address account) external view returns (uint256);
947 
948     /**
949      * @dev Moves `amount` tokens from the caller's account to `to`.
950      *
951      * Returns a boolean value indicating whether the operation succeeded.
952      *
953      * Emits a {Transfer} event.
954      */
955     function transfer(address to, uint256 amount) external returns (bool);
956 
957     /**
958      * @dev Returns the remaining number of tokens that `spender` will be
959      * allowed to spend on behalf of `owner` through {transferFrom}. This is
960      * zero by default.
961      *
962      * This value changes when {approve} or {transferFrom} are called.
963      */
964     function allowance(address owner, address spender) external view returns (uint256);
965 
966     /**
967      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
968      *
969      * Returns a boolean value indicating whether the operation succeeded.
970      *
971      * IMPORTANT: Beware that changing an allowance with this method brings the risk
972      * that someone may use both the old and the new allowance by unfortunate
973      * transaction ordering. One possible solution to mitigate this race
974      * condition is to first reduce the spender's allowance to 0 and set the
975      * desired value afterwards:
976      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
977      *
978      * Emits an {Approval} event.
979      */
980     function approve(address spender, uint256 amount) external returns (bool);
981 
982     /**
983      * @dev Moves `amount` tokens from `from` to `to` using the
984      * allowance mechanism. `amount` is then deducted from the caller's
985      * allowance.
986      *
987      * Returns a boolean value indicating whether the operation succeeded.
988      *
989      * Emits a {Transfer} event.
990      */
991     function transferFrom(
992         address from,
993         address to,
994         uint256 amount
995     ) external returns (bool);
996 }
997 
998 // File: @uniswap/v3-periphery/contracts/libraries/TransferHelper.sol
999 
1000 
1001 pragma solidity >=0.6.0;
1002 
1003 
1004 library TransferHelper {
1005     /// @notice Transfers tokens from the targeted address to the given destination
1006     /// @notice Errors with 'STF' if transfer fails
1007     /// @param token The contract address of the token to be transferred
1008     /// @param from The originating address from which the tokens will be transferred
1009     /// @param to The destination address of the transfer
1010     /// @param value The amount to be transferred
1011     function safeTransferFrom(
1012         address token,
1013         address from,
1014         address to,
1015         uint256 value
1016     ) internal {
1017         (bool success, bytes memory data) =
1018             token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
1019         require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
1020     }
1021 
1022     /// @notice Transfers tokens from msg.sender to a recipient
1023     /// @dev Errors with ST if transfer fails
1024     /// @param token The contract address of the token which will be transferred
1025     /// @param to The recipient of the transfer
1026     /// @param value The value of the transfer
1027     function safeTransfer(
1028         address token,
1029         address to,
1030         uint256 value
1031     ) internal {
1032         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
1033         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
1034     }
1035 
1036     /// @notice Approves the stipulated contract to spend the given allowance in the given token
1037     /// @dev Errors with 'SA' if transfer fails
1038     /// @param token The contract address of the token to be approved
1039     /// @param to The target of the approval
1040     /// @param value The amount of the given token the target will be allowed to spend
1041     function safeApprove(
1042         address token,
1043         address to,
1044         uint256 value
1045     ) internal {
1046         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.approve.selector, to, value));
1047         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');
1048     }
1049 
1050     /// @notice Transfers ETH to the recipient address
1051     /// @dev Fails with `STE`
1052     /// @param to The destination of the transfer
1053     /// @param value The value to be transferred
1054     function safeTransferETH(address to, uint256 value) internal {
1055         (bool success, ) = to.call{value: value}(new bytes(0));
1056         require(success, 'STE');
1057     }
1058 }
1059 
1060 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1061 
1062 
1063 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 
1068 /**
1069  * @dev Interface for the optional metadata functions from the ERC20 standard.
1070  *
1071  * _Available since v4.1._
1072  */
1073 interface IERC20Metadata is IERC20 {
1074     /**
1075      * @dev Returns the name of the token.
1076      */
1077     function name() external view returns (string memory);
1078 
1079     /**
1080      * @dev Returns the symbol of the token.
1081      */
1082     function symbol() external view returns (string memory);
1083 
1084     /**
1085      * @dev Returns the decimals places of the token.
1086      */
1087     function decimals() external view returns (uint8);
1088 }
1089 
1090 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1091 
1092 
1093 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
1094 
1095 pragma solidity ^0.8.0;
1096 
1097 
1098 
1099 
1100 /**
1101  * @dev Implementation of the {IERC20} interface.
1102  *
1103  * This implementation is agnostic to the way tokens are created. This means
1104  * that a supply mechanism has to be added in a derived contract using {_mint}.
1105  * For a generic mechanism see {ERC20PresetMinterPauser}.
1106  *
1107  * TIP: For a detailed writeup see our guide
1108  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1109  * to implement supply mechanisms].
1110  *
1111  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1112  * instead returning `false` on failure. This behavior is nonetheless
1113  * conventional and does not conflict with the expectations of ERC20
1114  * applications.
1115  *
1116  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1117  * This allows applications to reconstruct the allowance for all accounts just
1118  * by listening to said events. Other implementations of the EIP may not emit
1119  * these events, as it isn't required by the specification.
1120  *
1121  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1122  * functions have been added to mitigate the well-known issues around setting
1123  * allowances. See {IERC20-approve}.
1124  */
1125 contract ERC20 is Context, IERC20, IERC20Metadata {
1126     mapping(address => uint256) private _balances;
1127 
1128     mapping(address => mapping(address => uint256)) private _allowances;
1129 
1130     uint256 private _totalSupply;
1131 
1132     string private _name;
1133     string private _symbol;
1134 
1135     /**
1136      * @dev Sets the values for {name} and {symbol}.
1137      *
1138      * The default value of {decimals} is 18. To select a different value for
1139      * {decimals} you should overload it.
1140      *
1141      * All two of these values are immutable: they can only be set once during
1142      * construction.
1143      */
1144     constructor(string memory name_, string memory symbol_) {
1145         _name = name_;
1146         _symbol = symbol_;
1147     }
1148 
1149     /**
1150      * @dev Returns the name of the token.
1151      */
1152     function name() public view virtual override returns (string memory) {
1153         return _name;
1154     }
1155 
1156     /**
1157      * @dev Returns the symbol of the token, usually a shorter version of the
1158      * name.
1159      */
1160     function symbol() public view virtual override returns (string memory) {
1161         return _symbol;
1162     }
1163 
1164     /**
1165      * @dev Returns the number of decimals used to get its user representation.
1166      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1167      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1168      *
1169      * Tokens usually opt for a value of 18, imitating the relationship between
1170      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1171      * overridden;
1172      *
1173      * NOTE: This information is only used for _display_ purposes: it in
1174      * no way affects any of the arithmetic of the contract, including
1175      * {IERC20-balanceOf} and {IERC20-transfer}.
1176      */
1177     function decimals() public view virtual override returns (uint8) {
1178         return 18;
1179     }
1180 
1181     /**
1182      * @dev See {IERC20-totalSupply}.
1183      */
1184     function totalSupply() public view virtual override returns (uint256) {
1185         return _totalSupply;
1186     }
1187 
1188     /**
1189      * @dev See {IERC20-balanceOf}.
1190      */
1191     function balanceOf(address account) public view virtual override returns (uint256) {
1192         return _balances[account];
1193     }
1194 
1195     /**
1196      * @dev See {IERC20-transfer}.
1197      *
1198      * Requirements:
1199      *
1200      * - `to` cannot be the zero address.
1201      * - the caller must have a balance of at least `amount`.
1202      */
1203     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1204         address owner = _msgSender();
1205         _transfer(owner, to, amount);
1206         return true;
1207     }
1208 
1209     /**
1210      * @dev See {IERC20-allowance}.
1211      */
1212     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1213         return _allowances[owner][spender];
1214     }
1215 
1216     /**
1217      * @dev See {IERC20-approve}.
1218      *
1219      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1220      * `transferFrom`. This is semantically equivalent to an infinite approval.
1221      *
1222      * Requirements:
1223      *
1224      * - `spender` cannot be the zero address.
1225      */
1226     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1227         address owner = _msgSender();
1228         _approve(owner, spender, amount);
1229         return true;
1230     }
1231 
1232     /**
1233      * @dev See {IERC20-transferFrom}.
1234      *
1235      * Emits an {Approval} event indicating the updated allowance. This is not
1236      * required by the EIP. See the note at the beginning of {ERC20}.
1237      *
1238      * NOTE: Does not update the allowance if the current allowance
1239      * is the maximum `uint256`.
1240      *
1241      * Requirements:
1242      *
1243      * - `from` and `to` cannot be the zero address.
1244      * - `from` must have a balance of at least `amount`.
1245      * - the caller must have allowance for ``from``'s tokens of at least
1246      * `amount`.
1247      */
1248     function transferFrom(
1249         address from,
1250         address to,
1251         uint256 amount
1252     ) public virtual override returns (bool) {
1253         address spender = _msgSender();
1254         _spendAllowance(from, spender, amount);
1255         _transfer(from, to, amount);
1256         return true;
1257     }
1258 
1259     /**
1260      * @dev Atomically increases the allowance granted to `spender` by the caller.
1261      *
1262      * This is an alternative to {approve} that can be used as a mitigation for
1263      * problems described in {IERC20-approve}.
1264      *
1265      * Emits an {Approval} event indicating the updated allowance.
1266      *
1267      * Requirements:
1268      *
1269      * - `spender` cannot be the zero address.
1270      */
1271     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1272         address owner = _msgSender();
1273         _approve(owner, spender, allowance(owner, spender) + addedValue);
1274         return true;
1275     }
1276 
1277     /**
1278      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1279      *
1280      * This is an alternative to {approve} that can be used as a mitigation for
1281      * problems described in {IERC20-approve}.
1282      *
1283      * Emits an {Approval} event indicating the updated allowance.
1284      *
1285      * Requirements:
1286      *
1287      * - `spender` cannot be the zero address.
1288      * - `spender` must have allowance for the caller of at least
1289      * `subtractedValue`.
1290      */
1291     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1292         address owner = _msgSender();
1293         uint256 currentAllowance = allowance(owner, spender);
1294         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1295         unchecked {
1296             _approve(owner, spender, currentAllowance - subtractedValue);
1297         }
1298 
1299         return true;
1300     }
1301 
1302     /**
1303      * @dev Moves `amount` of tokens from `from` to `to`.
1304      *
1305      * This internal function is equivalent to {transfer}, and can be used to
1306      * e.g. implement automatic token fees, slashing mechanisms, etc.
1307      *
1308      * Emits a {Transfer} event.
1309      *
1310      * Requirements:
1311      *
1312      * - `from` cannot be the zero address.
1313      * - `to` cannot be the zero address.
1314      * - `from` must have a balance of at least `amount`.
1315      */
1316     function _transfer(
1317         address from,
1318         address to,
1319         uint256 amount
1320     ) internal virtual {
1321         require(from != address(0), "ERC20: transfer from the zero address");
1322         require(to != address(0), "ERC20: transfer to the zero address");
1323 
1324         _beforeTokenTransfer(from, to, amount);
1325 
1326         uint256 fromBalance = _balances[from];
1327         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1328         unchecked {
1329             _balances[from] = fromBalance - amount;
1330             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1331             // decrementing then incrementing.
1332             _balances[to] += amount;
1333         }
1334 
1335         emit Transfer(from, to, amount);
1336 
1337         _afterTokenTransfer(from, to, amount);
1338     }
1339 
1340     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1341      * the total supply.
1342      *
1343      * Emits a {Transfer} event with `from` set to the zero address.
1344      *
1345      * Requirements:
1346      *
1347      * - `account` cannot be the zero address.
1348      */
1349     function _mint(address account, uint256 amount) internal virtual {
1350         require(account != address(0), "ERC20: mint to the zero address");
1351 
1352         _beforeTokenTransfer(address(0), account, amount);
1353 
1354         _totalSupply += amount;
1355         unchecked {
1356             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1357             _balances[account] += amount;
1358         }
1359         emit Transfer(address(0), account, amount);
1360 
1361         _afterTokenTransfer(address(0), account, amount);
1362     }
1363 
1364     /**
1365      * @dev Destroys `amount` tokens from `account`, reducing the
1366      * total supply.
1367      *
1368      * Emits a {Transfer} event with `to` set to the zero address.
1369      *
1370      * Requirements:
1371      *
1372      * - `account` cannot be the zero address.
1373      * - `account` must have at least `amount` tokens.
1374      */
1375     function _burn(address account, uint256 amount) internal virtual {
1376         require(account != address(0), "ERC20: burn from the zero address");
1377 
1378         _beforeTokenTransfer(account, address(0), amount);
1379 
1380         uint256 accountBalance = _balances[account];
1381         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1382         unchecked {
1383             _balances[account] = accountBalance - amount;
1384             // Overflow not possible: amount <= accountBalance <= totalSupply.
1385             _totalSupply -= amount;
1386         }
1387 
1388         emit Transfer(account, address(0), amount);
1389 
1390         _afterTokenTransfer(account, address(0), amount);
1391     }
1392 
1393     /**
1394      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1395      *
1396      * This internal function is equivalent to `approve`, and can be used to
1397      * e.g. set automatic allowances for certain subsystems, etc.
1398      *
1399      * Emits an {Approval} event.
1400      *
1401      * Requirements:
1402      *
1403      * - `owner` cannot be the zero address.
1404      * - `spender` cannot be the zero address.
1405      */
1406     function _approve(
1407         address owner,
1408         address spender,
1409         uint256 amount
1410     ) internal virtual {
1411         require(owner != address(0), "ERC20: approve from the zero address");
1412         require(spender != address(0), "ERC20: approve to the zero address");
1413 
1414         _allowances[owner][spender] = amount;
1415         emit Approval(owner, spender, amount);
1416     }
1417 
1418     /**
1419      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1420      *
1421      * Does not update the allowance amount in case of infinite allowance.
1422      * Revert if not enough allowance is available.
1423      *
1424      * Might emit an {Approval} event.
1425      */
1426     function _spendAllowance(
1427         address owner,
1428         address spender,
1429         uint256 amount
1430     ) internal virtual {
1431         uint256 currentAllowance = allowance(owner, spender);
1432         if (currentAllowance != type(uint256).max) {
1433             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1434             unchecked {
1435                 _approve(owner, spender, currentAllowance - amount);
1436             }
1437         }
1438     }
1439 
1440     /**
1441      * @dev Hook that is called before any transfer of tokens. This includes
1442      * minting and burning.
1443      *
1444      * Calling conditions:
1445      *
1446      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1447      * will be transferred to `to`.
1448      * - when `from` is zero, `amount` tokens will be minted for `to`.
1449      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1450      * - `from` and `to` are never both zero.
1451      *
1452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1453      */
1454     function _beforeTokenTransfer(
1455         address from,
1456         address to,
1457         uint256 amount
1458     ) internal virtual {}
1459 
1460     /**
1461      * @dev Hook that is called after any transfer of tokens. This includes
1462      * minting and burning.
1463      *
1464      * Calling conditions:
1465      *
1466      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1467      * has been transferred to `to`.
1468      * - when `from` is zero, `amount` tokens have been minted for `to`.
1469      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1470      * - `from` and `to` are never both zero.
1471      *
1472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1473      */
1474     function _afterTokenTransfer(
1475         address from,
1476         address to,
1477         uint256 amount
1478     ) internal virtual {}
1479 }
1480 
1481 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1482 
1483 
1484 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1485 
1486 pragma solidity ^0.8.0;
1487 
1488 
1489 
1490 /**
1491  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1492  * tokens and those that they have an allowance for, in a way that can be
1493  * recognized off-chain (via event analysis).
1494  */
1495 abstract contract ERC20Burnable is Context, ERC20 {
1496     /**
1497      * @dev Destroys `amount` tokens from the caller.
1498      *
1499      * See {ERC20-_burn}.
1500      */
1501     function burn(uint256 amount) public virtual {
1502         _burn(_msgSender(), amount);
1503     }
1504 
1505     /**
1506      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1507      * allowance.
1508      *
1509      * See {ERC20-_burn} and {ERC20-allowance}.
1510      *
1511      * Requirements:
1512      *
1513      * - the caller must have allowance for ``accounts``'s tokens of at least
1514      * `amount`.
1515      */
1516     function burnFrom(address account, uint256 amount) public virtual {
1517         _spendAllowance(account, _msgSender(), amount);
1518         _burn(account, amount);
1519     }
1520 }
1521 
1522 // File: contracts/StandardPool_ETH/UVPool.sol
1523 
1524 
1525 pragma solidity ^0.8.12;
1526 
1527 
1528 
1529 
1530 
1531 
1532 
1533 
1534 
1535 contract UVStandardPool is ERC20, ERC20Burnable, Ownable, AccessControl {
1536     using SafeMath for uint256;
1537 
1538     struct WhiteList {
1539         uint256 limitDeposit;
1540         uint64 startTimeDeposit;
1541         uint64 closeTimeDeposit;
1542     }
1543 
1544     struct Vote {
1545         string name;
1546         uint64 startTimestamp;
1547         uint64 endTimestamp;
1548         bool isActive;
1549         uint64 voteCount;
1550     }
1551 
1552     struct VoteInfo {
1553         uint64 timestamp;
1554         uint256 amount;
1555         uint8 optionId;
1556         address voter;
1557     }
1558     uint256 public feeCreator = 1 ether;
1559     mapping(uint8 => Vote) public allVotes;
1560     mapping(uint8 => mapping(address => VoteInfo)) public allVoters;
1561     mapping(uint8 => mapping(uint64 => VoteInfo)) public allVotersIndex;
1562 
1563     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1564 
1565     address public SWAP_ROUTER_ADDRESS =
1566         0xE592427A0AEce92De3Edee1F18E0157C05861564; // check
1567     address public stableCoin = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // check
1568 
1569     address public poolReserved;
1570 
1571     uint256 public poolOpenTime = 1687698000; // check
1572     mapping(address => WhiteList) public whiteList;
1573     mapping(address => uint256) public renewedList;
1574 
1575     mapping(address => uint256) private _balances;
1576     mapping(address => bool) public investmentAddreses;
1577     ISwapRouter public swapRouter;
1578     address public fundWallet = 0xE46d994aC4eee7775Bdc5F425FB4dDc2E1d6Db54; // check
1579     uint256 public currentSizePool = 0; // check
1580     uint256 public maxSizePool = 285715000000000000000000; // check
1581     uint8 public orderNumber = 2; // check
1582     uint256 public minimumDeposit = 500 ether; // check
1583     bool public isClose = false; // check
1584     uint8 percentFee = 250;
1585     bool public pausedTransfer = false;
1586     bool public voteCreateable = true;
1587 
1588     event Deposit(address indexed sender, uint256 amount);
1589     event BuyToken(address indexed tokenAddress, uint256 amount);
1590     event BuyBNB(uint256 amount);
1591 
1592     event CreateVote(uint8 voteId, uint64 startTimestamp, uint64 endTimestamp);
1593     event Voting(
1594         address indexed voter,
1595         uint256 amount,
1596         uint64 timestamp,
1597         uint8 optionId,
1598         uint64 voteCount
1599     );
1600     event CloseVote(uint8 voteId);
1601 
1602     constructor()
1603         ERC20(
1604             string.concat("E - ", Strings.toString(orderNumber)),
1605             string.concat("E-", Strings.toString(orderNumber))
1606         )
1607     {
1608         swapRouter = ISwapRouter(SWAP_ROUTER_ADDRESS);
1609         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1610         _setupRole(MANAGER_ROLE, msg.sender);
1611     }
1612 
1613     // called once by the factory at time of deployment
1614     function initialize(
1615         uint256 _amountLimited,
1616         uint256 _minimumDeposit,
1617         address _fundWallet,
1618         uint64 _poolOpenTime,
1619         address _stableCoin,
1620         address _swapRouterAddress
1621     ) external onlyOwner {
1622         minimumDeposit = _minimumDeposit;
1623         maxSizePool = _amountLimited;
1624         SWAP_ROUTER_ADDRESS = _swapRouterAddress;
1625         swapRouter = ISwapRouter(SWAP_ROUTER_ADDRESS);
1626         fundWallet = _fundWallet;
1627         stableCoin = _stableCoin;
1628         poolOpenTime = _poolOpenTime;
1629     }
1630 
1631     receive() external payable {}
1632 
1633     fallback() external payable {}
1634 
1635     // Transfer tokens to fund wallet process projects vesting
1636     function transferForInvestment(
1637         address _tokenAddress,
1638         uint256 _amount,
1639         address _receiver
1640     ) external onlyRole(MANAGER_ROLE) {
1641         require(_receiver != address(0), "receiver address is zero");
1642         require(
1643             investmentAddreses[_receiver],
1644             "receiver is not investment address"
1645         );
1646         IERC20 _instance = IERC20(_tokenAddress);
1647         uint256 _balance = _instance.balanceOf(address(this));
1648         require(_balance >= _amount, "Not enough");
1649 
1650         _instance.approve(address(this), _amount);
1651         _instance.transfer(_receiver, _amount);
1652     }
1653 
1654     // Add white list for user
1655     function addsWhiteList(
1656         address[] memory _users,
1657         uint256[] memory _limitsDeposit,
1658         uint64 _startTimeDeposit,
1659         uint64 _closeTimeDeposit
1660     ) external onlyRole(MANAGER_ROLE) {
1661         require(_users.length > 0, "users is empty");
1662         require(_limitsDeposit.length > 0, "limit deposit is zero");
1663         require(_startTimeDeposit > 0, "start time deposit is zero");
1664         require(_closeTimeDeposit > 0, "close time deposit is zero");
1665         require(
1666             _closeTimeDeposit > _startTimeDeposit,
1667             "close time deposit must be greater than start time deposit"
1668         );
1669         for (uint256 index = 0; index < _users.length; index++) {
1670             whiteList[_users[index]] = WhiteList({
1671                 limitDeposit: _limitsDeposit[index],
1672                 startTimeDeposit: _startTimeDeposit,
1673                 closeTimeDeposit: _closeTimeDeposit
1674             });
1675         }
1676     }
1677 
1678     // Deposit stable coin to the pool
1679     function wlDeposit(uint256 amount) public {
1680         require(!isClose, "Pool is closed");
1681         require(
1682             block.timestamp <= whiteList[msg.sender].closeTimeDeposit,
1683             "Deposit time is over"
1684         );
1685         require(
1686             block.timestamp >= whiteList[msg.sender].startTimeDeposit,
1687             "Deposit time is not start"
1688         );
1689         require(
1690             whiteList[msg.sender].limitDeposit >= amount,
1691             "Deposit amount is over limit"
1692         );
1693         require(maxSizePool >= currentSizePool.add(amount), "Pool is full");
1694         require(amount >= minimumDeposit, "Not enough");
1695 
1696         uint256 amount6Decimals = amount.div(10 ** 12);
1697         TransferHelper.safeTransferFrom(
1698             stableCoin,
1699             msg.sender,
1700             address(this),
1701             amount6Decimals
1702         );
1703         _mint(msg.sender, amount);
1704         _balances[msg.sender] = _balances[msg.sender].add(amount);
1705         _mint(fundWallet, amount.mul(percentFee).div(1000));
1706         _balances[fundWallet] = _balances[fundWallet].add(
1707             amount.mul(percentFee).div(1000)
1708         );
1709 
1710         currentSizePool += amount;
1711 
1712         emit Deposit(msg.sender, amount);
1713     }
1714 
1715     // Deposit stable coin to the pool
1716     function deposit(uint256 amount) public {
1717         require(!isClose, "Pool is closed");
1718         require(maxSizePool >= currentSizePool.add(amount), "Pool is full");
1719         require(amount >= minimumDeposit, "Amount is not enough");
1720         require(
1721             block.timestamp >= poolOpenTime,
1722             "Pool is not open yet, please wait"
1723         );
1724 
1725         uint256 amount6Decimals = amount.div(10 ** 12);
1726         TransferHelper.safeTransferFrom(
1727             stableCoin,
1728             msg.sender,
1729             address(this),
1730             amount6Decimals
1731         );
1732         _mint(msg.sender, amount);
1733         _balances[msg.sender] = _balances[msg.sender].add(amount);
1734         _mint(fundWallet, amount.mul(percentFee).div(1000));
1735         _balances[fundWallet] = _balances[fundWallet].add(
1736             amount.mul(percentFee).div(1000)
1737         );
1738 
1739         currentSizePool += amount;
1740 
1741         emit Deposit(msg.sender, amount);
1742     }
1743 
1744     // Set percent fee for the pool
1745     function setPercentFee(uint8 _percentFee) public onlyRole(MANAGER_ROLE) {
1746         require(
1747             _percentFee > 10 && _percentFee < 400,
1748             "Percent fee is invalid"
1749         );
1750         percentFee = _percentFee;
1751     }
1752 
1753     // swap any token on uniswap
1754     function buyToken(
1755         uint256 _amountIn,
1756         uint256 _amountOutMin,
1757         address _tokenIn,
1758         bytes calldata _path,
1759         uint256 _deadline
1760     ) public onlyRole(MANAGER_ROLE) {
1761         require(isClose, "Pool is not closed");
1762         address _poolReserved = poolReserved;
1763 
1764         TransferHelper.safeApprove(_tokenIn, address(swapRouter), _amountIn);
1765 
1766         ISwapRouter.ExactInputParams memory params = ISwapRouter
1767             .ExactInputParams({
1768                 path: _path,
1769                 recipient: _poolReserved,
1770                 deadline: _deadline,
1771                 amountIn: _amountIn,
1772                 amountOutMinimum: _amountOutMin
1773             });
1774 
1775         // Executes the swap.
1776         uint256 realAmount = swapRouter.exactInput(params);
1777 
1778         emit BuyToken(_tokenIn, realAmount);
1779     }
1780 
1781     // toggles the paused state of the transfer function
1782     function togglePausedTransfer() public onlyRole(MANAGER_ROLE) {
1783         pausedTransfer = !pausedTransfer;
1784     }
1785 
1786     function transfer(
1787         address recipient,
1788         uint256 amount
1789     ) public override returns (bool) {
1790         _transfer(_msgSender(), recipient, amount);
1791         return true;
1792     }
1793 
1794     function transferFrom(
1795         address from,
1796         address to,
1797         uint256 amount
1798     ) public virtual override returns (bool) {
1799         address spender = _msgSender();
1800         _spendAllowance(from, spender, amount);
1801         _transfer(from, to, amount);
1802         return true;
1803     }
1804 
1805     function _transfer(
1806         address sender,
1807         address recipient,
1808         uint256 amount
1809     ) internal virtual override {
1810         require(sender != address(0), "ERC20: transfer from the zero address");
1811         require(recipient != address(0), "ERC20: transfer to the zero address");
1812         require(pausedTransfer == false, "ERC20: transfer is paused");
1813         require(amount > 0, "Transfer amount must be greater than zero");
1814         require(
1815             amount <= _balances[sender],
1816             "ERC20: amount must be less or equal to balance"
1817         );
1818 
1819         _balances[sender] = _balances[sender].sub(amount);
1820         _balances[recipient] = _balances[recipient].add(amount);
1821         emit Transfer(sender, recipient, amount);
1822     }
1823 
1824     function balanceOf(address owner) public view override returns (uint256) {
1825         return _balances[owner];
1826     }
1827 
1828     // Add investment address
1829     function addInvestmentAddress(address _investmentAddress) public onlyOwner {
1830         investmentAddreses[_investmentAddress] = true;
1831     }
1832 
1833     // Remove investment address
1834     function removeInvestmentAddress(
1835         address _investmentAddress
1836     ) public onlyOwner {
1837         investmentAddreses[_investmentAddress] = false;
1838     }
1839 
1840     // Set the fund wallet
1841     function setFundWallet(address _fundWallet) public onlyOwner {
1842         fundWallet = _fundWallet;
1843     }
1844 
1845     // Set minimum deposit amount
1846     function setMinimumDeposit(
1847         uint256 _minimumDeposit
1848     ) public onlyRole(MANAGER_ROLE) {
1849         minimumDeposit = _minimumDeposit;
1850     }
1851 
1852     // Set Max size pool
1853     function setMaxSizePool(
1854         uint256 _maxSizePool
1855     ) public onlyRole(MANAGER_ROLE) {
1856         maxSizePool = _maxSizePool;
1857     }
1858 
1859     // set pool open time
1860     function setPoolOpenTime(
1861         uint256 _poolOpenTime
1862     ) public onlyRole(MANAGER_ROLE) {
1863         poolOpenTime = _poolOpenTime;
1864     }
1865 
1866     // open the pool
1867     function openPool() public onlyRole(MANAGER_ROLE) {
1868         isClose = false;
1869     }
1870 
1871     // close the pool
1872     function closePool() public onlyRole(MANAGER_ROLE) {
1873         isClose = true;
1874     }
1875 
1876     // get detail Vote
1877     function getVote(uint8 _orderNumber) public view returns (Vote memory) {
1878         return allVotes[_orderNumber];
1879     }
1880 
1881     // Set fee creator
1882     function setFeeCreator(uint256 _feeCreator) public onlyRole(MANAGER_ROLE) {
1883         feeCreator = _feeCreator;
1884     }
1885 
1886     // Add wallet to manager role
1887     function addManager(address _manager) public onlyOwner {
1888         _setupRole(MANAGER_ROLE, _manager);
1889     }
1890 
1891     // Remove wallet from manager role
1892     function removeManager(address _manager) public onlyOwner {
1893         revokeRole(MANAGER_ROLE, _manager);
1894     }
1895 
1896     // get detail VoteInfo by orderNumber
1897     function getVoteInfo(
1898         uint8 _orderNumber,
1899         address _user
1900     ) public view returns (VoteInfo memory) {
1901         return allVoters[_orderNumber][_user];
1902     }
1903 
1904     // create a new vote
1905     function createVote(
1906         uint8 _orderNumber,
1907         uint64 _startTimestamp,
1908         uint64 _endTimestamp
1909     ) public payable {
1910         require(voteCreateable, "Vote is not createable");
1911         require(isClose, "Pool is not closed");
1912         if (hasRole(MANAGER_ROLE, msg.sender)) {} else {
1913             require(
1914                 msg.value >= feeCreator,
1915                 "You need to pay fee to create vote"
1916             );
1917             uint256 balance = balanceOf(msg.sender);
1918             require(
1919                 balance >= totalSupply().div(10) ||
1920                     hasRole(MANAGER_ROLE, msg.sender),
1921                 "You need to have 10% of total supply"
1922             );
1923         }
1924 
1925         allVotes[_orderNumber].startTimestamp = _startTimestamp;
1926         allVotes[_orderNumber].endTimestamp = _endTimestamp;
1927         allVotes[_orderNumber].isActive = true;
1928         voteCreateable = false;
1929 
1930         emit CreateVote(_orderNumber, _startTimestamp, _endTimestamp);
1931     }
1932 
1933     // close a vote
1934     function closeVote(uint8 _orderNumber) public onlyRole(MANAGER_ROLE) {
1935         allVotes[_orderNumber].isActive = false;
1936         voteCreateable = true;
1937         emit CloseVote(_orderNumber);
1938     }
1939 
1940     // voting for a option
1941     function voting(uint8 _orderNumber, uint8 _optionId) public {
1942         require(isClose, "This Pool is closed");
1943         require(allVotes[_orderNumber].isActive, "This Vote is closed");
1944         require(
1945             allVoters[_orderNumber][msg.sender].timestamp == 0,
1946             "You have voted"
1947         );
1948         require(
1949             allVoters[_orderNumber][msg.sender].amount == 0,
1950             "You have voted"
1951         );
1952         uint256 _amountBalance = balanceOf(msg.sender);
1953 
1954         transferFrom(msg.sender, address(this), _amountBalance);
1955         allVotes[_orderNumber].voteCount += 1;
1956 
1957         allVoters[_orderNumber][msg.sender] = VoteInfo({
1958             amount: _amountBalance,
1959             timestamp: uint64(block.timestamp),
1960             optionId: _optionId,
1961             voter: msg.sender
1962         });
1963         allVotersIndex[_orderNumber][
1964             allVotes[_orderNumber].voteCount
1965         ] = VoteInfo({
1966             amount: _amountBalance,
1967             timestamp: uint64(block.timestamp),
1968             optionId: _optionId,
1969             voter: msg.sender
1970         });
1971 
1972         emit Voting(
1973             msg.sender,
1974             _amountBalance,
1975             uint64(block.timestamp),
1976             _optionId,
1977             allVotes[_orderNumber].voteCount
1978         );
1979     }
1980 
1981     // internal release token after vote closed
1982     function releaseTokenAfterVote(
1983         uint8 _orderNumber,
1984         uint64 _from,
1985         uint64 _to
1986     ) external onlyRole(MANAGER_ROLE) {
1987         require(!allVotes[_orderNumber].isActive, "This Vote is still active");
1988         for (uint64 i = _from; i < _to; i++) {
1989             _transfer(
1990                 address(this),
1991                 allVotersIndex[_orderNumber][i].voter,
1992                 allVotersIndex[_orderNumber][i].amount
1993             );
1994         }
1995     }
1996 
1997     // Set swap router
1998     function setSwapRouter(
1999         address _swapRouterAddress
2000     ) public onlyRole(MANAGER_ROLE) {
2001         SWAP_ROUTER_ADDRESS = _swapRouterAddress;
2002         swapRouter = ISwapRouter(_swapRouterAddress);
2003     }
2004 
2005     // Set Reserves address
2006     function setReserves(address _poolReserved) public onlyRole(MANAGER_ROLE) {
2007         poolReserved = _poolReserved;
2008     }
2009 }