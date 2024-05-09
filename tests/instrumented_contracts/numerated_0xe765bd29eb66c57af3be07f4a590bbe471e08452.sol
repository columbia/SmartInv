1 // File: contracts/interfaces/IUVReserveFactory.sol
2 
3 
4 pragma solidity ^0.8.12;
5 
6 interface IUVReserveFactory {
7     function createReserve(
8         address _fundWallet,
9         address _pool,
10         address _manager
11     ) external;
12 
13     function addPoolRole(uint8 _orderNumber, address _manager) external;
14 
15     function removePoolRole(uint8 _orderNumber, address _manager) external;
16 
17     function addRole(address _addr) external;
18 
19     function removeRole(address _addr) external;
20 
21     function getPoolsLength() external view returns (uint256);
22 
23     function getPoolInfo(uint8 _orderNumber)
24         external
25         view
26         returns (
27             address _poolReserve,
28             address _poolTP,
29             address _manager,
30             address _fundWallet
31         );
32 }
33 
34 // File: contracts/interfaces/IUVPool.sol
35 
36 
37 pragma solidity ^0.8.12;
38 
39 interface IUVPool {
40     function deposit(uint256 amount) external;
41 
42     function initialize(
43         uint8 _orderNumber,
44         uint256 _amountLimited,
45         uint256 _minimumDeposit,
46         address _fundWallet,
47         address _factoryReserve,
48         uint64 _poolOpenTime
49     ) external;
50 
51     function transferForInvestment(
52         address _tokenAddress,
53         uint256 _amount,
54         address _receiver
55     ) external;
56 
57     function getReserve() external returns (address);
58 
59     function buyToken(
60         uint256 _amountIn,
61         uint256 _amountOutMin,
62         address _tokenIn,
63         bytes calldata _path,
64         uint256 _deadline
65     ) external;
66 
67     function setFundWallet(address _fundWallet) external;
68 
69     function setMinimumDeposit(uint256 _minimumDeposit) external;
70 
71     function openPool() external;
72 
73     function closePool() external;
74 
75     function setFeeCreator(uint256 _feeCreator) external;
76 
77     function addManager(address _manager) external;
78 
79     function removeManager(address _manager) external;
80 
81     function addInvestmentAddress(address _investmentAddress) external;
82 
83     function removeInvestmentAddress(address _investmentAddress) external;
84 
85     function createVote(
86         uint8 _orderNumber,
87         uint64 _startTimestamp,
88         uint64 _endTimestamp
89     ) external payable;
90 
91     function closeVote(uint8 _orderNumber) external;
92 
93     function voting(uint8 _orderNumber, uint8 _optionId) external;
94 
95     event Deposit(address indexed sender, uint256 amount);
96     event BuyToken(address indexed tokenAddress, uint256 amount);
97     event BuyBNB(uint256 amount);
98 
99     event CreateVote(uint8 voteId, uint64 startTimestamp, uint64 endTimestamp);
100     event Voting(
101         address indexed voter,
102         uint256 amount,
103         uint64 timestamp,
104         uint8 optionId,
105         uint64 voteCount
106     );
107     event CloseVote(uint8 voteId);
108 }
109 
110 // File: @uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol
111 
112 
113 pragma solidity >=0.5.0;
114 
115 /// @title Callback for IUniswapV3PoolActions#swap
116 /// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
117 interface IUniswapV3SwapCallback {
118     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
119     /// @dev In the implementation you must pay the pool tokens owed for the swap.
120     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
121     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
122     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
123     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
124     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
125     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
126     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
127     function uniswapV3SwapCallback(
128         int256 amount0Delta,
129         int256 amount1Delta,
130         bytes calldata data
131     ) external;
132 }
133 
134 // File: @uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol
135 
136 
137 pragma solidity >=0.7.5;
138 pragma abicoder v2;
139 
140 
141 /// @title Router token swapping functionality
142 /// @notice Functions for swapping tokens via Uniswap V3
143 interface ISwapRouter is IUniswapV3SwapCallback {
144     struct ExactInputSingleParams {
145         address tokenIn;
146         address tokenOut;
147         uint24 fee;
148         address recipient;
149         uint256 deadline;
150         uint256 amountIn;
151         uint256 amountOutMinimum;
152         uint160 sqrtPriceLimitX96;
153     }
154 
155     /// @notice Swaps `amountIn` of one token for as much as possible of another token
156     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
157     /// @return amountOut The amount of the received token
158     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
159 
160     struct ExactInputParams {
161         bytes path;
162         address recipient;
163         uint256 deadline;
164         uint256 amountIn;
165         uint256 amountOutMinimum;
166     }
167 
168     /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
169     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
170     /// @return amountOut The amount of the received token
171     function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);
172 
173     struct ExactOutputSingleParams {
174         address tokenIn;
175         address tokenOut;
176         uint24 fee;
177         address recipient;
178         uint256 deadline;
179         uint256 amountOut;
180         uint256 amountInMaximum;
181         uint160 sqrtPriceLimitX96;
182     }
183 
184     /// @notice Swaps as little as possible of one token for `amountOut` of another token
185     /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
186     /// @return amountIn The amount of the input token
187     function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);
188 
189     struct ExactOutputParams {
190         bytes path;
191         address recipient;
192         uint256 deadline;
193         uint256 amountOut;
194         uint256 amountInMaximum;
195     }
196 
197     /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
198     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
199     /// @return amountIn The amount of the input token
200     function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
201 }
202 
203 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
204 
205 
206 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 // CAUTION
211 // This version of SafeMath should only be used with Solidity 0.8 or later,
212 // because it relies on the compiler's built in overflow checks.
213 
214 /**
215  * @dev Wrappers over Solidity's arithmetic operations.
216  *
217  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
218  * now has built in overflow checking.
219  */
220 library SafeMath {
221     /**
222      * @dev Returns the addition of two unsigned integers, with an overflow flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             uint256 c = a + b;
229             if (c < a) return (false, 0);
230             return (true, c);
231         }
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
236      *
237      * _Available since v3.4._
238      */
239     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             if (b > a) return (false, 0);
242             return (true, a - b);
243         }
244     }
245 
246     /**
247      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
248      *
249      * _Available since v3.4._
250      */
251     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
254             // benefit is lost if 'b' is also tested.
255             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
256             if (a == 0) return (true, 0);
257             uint256 c = a * b;
258             if (c / a != b) return (false, 0);
259             return (true, c);
260         }
261     }
262 
263     /**
264      * @dev Returns the division of two unsigned integers, with a division by zero flag.
265      *
266      * _Available since v3.4._
267      */
268     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (b == 0) return (false, 0);
271             return (true, a / b);
272         }
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
277      *
278      * _Available since v3.4._
279      */
280     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             if (b == 0) return (false, 0);
283             return (true, a % b);
284         }
285     }
286 
287     /**
288      * @dev Returns the addition of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `+` operator.
292      *
293      * Requirements:
294      *
295      * - Addition cannot overflow.
296      */
297     function add(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a + b;
299     }
300 
301     /**
302      * @dev Returns the subtraction of two unsigned integers, reverting on
303      * overflow (when the result is negative).
304      *
305      * Counterpart to Solidity's `-` operator.
306      *
307      * Requirements:
308      *
309      * - Subtraction cannot overflow.
310      */
311     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a - b;
313     }
314 
315     /**
316      * @dev Returns the multiplication of two unsigned integers, reverting on
317      * overflow.
318      *
319      * Counterpart to Solidity's `*` operator.
320      *
321      * Requirements:
322      *
323      * - Multiplication cannot overflow.
324      */
325     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a * b;
327     }
328 
329     /**
330      * @dev Returns the integer division of two unsigned integers, reverting on
331      * division by zero. The result is rounded towards zero.
332      *
333      * Counterpart to Solidity's `/` operator.
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function div(uint256 a, uint256 b) internal pure returns (uint256) {
340         return a / b;
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * reverting when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
356         return a % b;
357     }
358 
359     /**
360      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
361      * overflow (when the result is negative).
362      *
363      * CAUTION: This function is deprecated because it requires allocating memory for the error
364      * message unnecessarily. For custom revert reasons use {trySub}.
365      *
366      * Counterpart to Solidity's `-` operator.
367      *
368      * Requirements:
369      *
370      * - Subtraction cannot overflow.
371      */
372     function sub(
373         uint256 a,
374         uint256 b,
375         string memory errorMessage
376     ) internal pure returns (uint256) {
377         unchecked {
378             require(b <= a, errorMessage);
379             return a - b;
380         }
381     }
382 
383     /**
384      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
385      * division by zero. The result is rounded towards zero.
386      *
387      * Counterpart to Solidity's `/` operator. Note: this function uses a
388      * `revert` opcode (which leaves remaining gas untouched) while Solidity
389      * uses an invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function div(
396         uint256 a,
397         uint256 b,
398         string memory errorMessage
399     ) internal pure returns (uint256) {
400         unchecked {
401             require(b > 0, errorMessage);
402             return a / b;
403         }
404     }
405 
406     /**
407      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
408      * reverting with custom message when dividing by zero.
409      *
410      * CAUTION: This function is deprecated because it requires allocating memory for the error
411      * message unnecessarily. For custom revert reasons use {tryMod}.
412      *
413      * Counterpart to Solidity's `%` operator. This function uses a `revert`
414      * opcode (which leaves remaining gas untouched) while Solidity uses an
415      * invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      *
419      * - The divisor cannot be zero.
420      */
421     function mod(
422         uint256 a,
423         uint256 b,
424         string memory errorMessage
425     ) internal pure returns (uint256) {
426         unchecked {
427             require(b > 0, errorMessage);
428             return a % b;
429         }
430     }
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     /**
451      * @dev Returns true if this contract implements the interface defined by
452      * `interfaceId`. See the corresponding
453      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
454      * to learn more about how these ids are created.
455      *
456      * This function call must use less than 30 000 gas.
457      */
458     function supportsInterface(bytes4 interfaceId) external view returns (bool);
459 }
460 
461 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Implementation of the {IERC165} interface.
471  *
472  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
473  * for the additional interface id that will be supported. For example:
474  *
475  * ```solidity
476  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
478  * }
479  * ```
480  *
481  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
482  */
483 abstract contract ERC165 is IERC165 {
484     /**
485      * @dev See {IERC165-supportsInterface}.
486      */
487     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488         return interfaceId == type(IERC165).interfaceId;
489     }
490 }
491 
492 // File: @openzeppelin/contracts/utils/Strings.sol
493 
494 
495 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev String operations.
501  */
502 library Strings {
503     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
504     uint8 private constant _ADDRESS_LENGTH = 20;
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
508      */
509     function toString(uint256 value) internal pure returns (string memory) {
510         // Inspired by OraclizeAPI's implementation - MIT licence
511         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
512 
513         if (value == 0) {
514             return "0";
515         }
516         uint256 temp = value;
517         uint256 digits;
518         while (temp != 0) {
519             digits++;
520             temp /= 10;
521         }
522         bytes memory buffer = new bytes(digits);
523         while (value != 0) {
524             digits -= 1;
525             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
526             value /= 10;
527         }
528         return string(buffer);
529     }
530 
531     /**
532      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
533      */
534     function toHexString(uint256 value) internal pure returns (string memory) {
535         if (value == 0) {
536             return "0x00";
537         }
538         uint256 temp = value;
539         uint256 length = 0;
540         while (temp != 0) {
541             length++;
542             temp >>= 8;
543         }
544         return toHexString(value, length);
545     }
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
549      */
550     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
551         bytes memory buffer = new bytes(2 * length + 2);
552         buffer[0] = "0";
553         buffer[1] = "x";
554         for (uint256 i = 2 * length + 1; i > 1; --i) {
555             buffer[i] = _HEX_SYMBOLS[value & 0xf];
556             value >>= 4;
557         }
558         require(value == 0, "Strings: hex length insufficient");
559         return string(buffer);
560     }
561 
562     /**
563      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
564      */
565     function toHexString(address addr) internal pure returns (string memory) {
566         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
567     }
568 }
569 
570 // File: @openzeppelin/contracts/access/IAccessControl.sol
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev External interface of AccessControl declared to support ERC165 detection.
579  */
580 interface IAccessControl {
581     /**
582      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
583      *
584      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
585      * {RoleAdminChanged} not being emitted signaling this.
586      *
587      * _Available since v3.1._
588      */
589     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
590 
591     /**
592      * @dev Emitted when `account` is granted `role`.
593      *
594      * `sender` is the account that originated the contract call, an admin role
595      * bearer except when using {AccessControl-_setupRole}.
596      */
597     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
598 
599     /**
600      * @dev Emitted when `account` is revoked `role`.
601      *
602      * `sender` is the account that originated the contract call:
603      *   - if using `revokeRole`, it is the admin role bearer
604      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
605      */
606     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
607 
608     /**
609      * @dev Returns `true` if `account` has been granted `role`.
610      */
611     function hasRole(bytes32 role, address account) external view returns (bool);
612 
613     /**
614      * @dev Returns the admin role that controls `role`. See {grantRole} and
615      * {revokeRole}.
616      *
617      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
618      */
619     function getRoleAdmin(bytes32 role) external view returns (bytes32);
620 
621     /**
622      * @dev Grants `role` to `account`.
623      *
624      * If `account` had not been already granted `role`, emits a {RoleGranted}
625      * event.
626      *
627      * Requirements:
628      *
629      * - the caller must have ``role``'s admin role.
630      */
631     function grantRole(bytes32 role, address account) external;
632 
633     /**
634      * @dev Revokes `role` from `account`.
635      *
636      * If `account` had been granted `role`, emits a {RoleRevoked} event.
637      *
638      * Requirements:
639      *
640      * - the caller must have ``role``'s admin role.
641      */
642     function revokeRole(bytes32 role, address account) external;
643 
644     /**
645      * @dev Revokes `role` from the calling account.
646      *
647      * Roles are often managed via {grantRole} and {revokeRole}: this function's
648      * purpose is to provide a mechanism for accounts to lose their privileges
649      * if they are compromised (such as when a trusted device is misplaced).
650      *
651      * If the calling account had been granted `role`, emits a {RoleRevoked}
652      * event.
653      *
654      * Requirements:
655      *
656      * - the caller must be `account`.
657      */
658     function renounceRole(bytes32 role, address account) external;
659 }
660 
661 // File: @openzeppelin/contracts/utils/Context.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @dev Provides information about the current execution context, including the
670  * sender of the transaction and its data. While these are generally available
671  * via msg.sender and msg.data, they should not be accessed in such a direct
672  * manner, since when dealing with meta-transactions the account sending and
673  * paying for execution may not be the actual sender (as far as an application
674  * is concerned).
675  *
676  * This contract is only required for intermediate, library-like contracts.
677  */
678 abstract contract Context {
679     function _msgSender() internal view virtual returns (address) {
680         return msg.sender;
681     }
682 
683     function _msgData() internal view virtual returns (bytes calldata) {
684         return msg.data;
685     }
686 }
687 
688 // File: @openzeppelin/contracts/access/AccessControl.sol
689 
690 
691 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 
696 
697 
698 
699 /**
700  * @dev Contract module that allows children to implement role-based access
701  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
702  * members except through off-chain means by accessing the contract event logs. Some
703  * applications may benefit from on-chain enumerability, for those cases see
704  * {AccessControlEnumerable}.
705  *
706  * Roles are referred to by their `bytes32` identifier. These should be exposed
707  * in the external API and be unique. The best way to achieve this is by
708  * using `public constant` hash digests:
709  *
710  * ```
711  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
712  * ```
713  *
714  * Roles can be used to represent a set of permissions. To restrict access to a
715  * function call, use {hasRole}:
716  *
717  * ```
718  * function foo() public {
719  *     require(hasRole(MY_ROLE, msg.sender));
720  *     ...
721  * }
722  * ```
723  *
724  * Roles can be granted and revoked dynamically via the {grantRole} and
725  * {revokeRole} functions. Each role has an associated admin role, and only
726  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
727  *
728  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
729  * that only accounts with this role will be able to grant or revoke other
730  * roles. More complex role relationships can be created by using
731  * {_setRoleAdmin}.
732  *
733  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
734  * grant and revoke this role. Extra precautions should be taken to secure
735  * accounts that have been granted it.
736  */
737 abstract contract AccessControl is Context, IAccessControl, ERC165 {
738     struct RoleData {
739         mapping(address => bool) members;
740         bytes32 adminRole;
741     }
742 
743     mapping(bytes32 => RoleData) private _roles;
744 
745     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
746 
747     /**
748      * @dev Modifier that checks that an account has a specific role. Reverts
749      * with a standardized message including the required role.
750      *
751      * The format of the revert reason is given by the following regular expression:
752      *
753      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
754      *
755      * _Available since v4.1._
756      */
757     modifier onlyRole(bytes32 role) {
758         _checkRole(role);
759         _;
760     }
761 
762     /**
763      * @dev See {IERC165-supportsInterface}.
764      */
765     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
766         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev Returns `true` if `account` has been granted `role`.
771      */
772     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
773         return _roles[role].members[account];
774     }
775 
776     /**
777      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
778      * Overriding this function changes the behavior of the {onlyRole} modifier.
779      *
780      * Format of the revert message is described in {_checkRole}.
781      *
782      * _Available since v4.6._
783      */
784     function _checkRole(bytes32 role) internal view virtual {
785         _checkRole(role, _msgSender());
786     }
787 
788     /**
789      * @dev Revert with a standard message if `account` is missing `role`.
790      *
791      * The format of the revert reason is given by the following regular expression:
792      *
793      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
794      */
795     function _checkRole(bytes32 role, address account) internal view virtual {
796         if (!hasRole(role, account)) {
797             revert(
798                 string(
799                     abi.encodePacked(
800                         "AccessControl: account ",
801                         Strings.toHexString(uint160(account), 20),
802                         " is missing role ",
803                         Strings.toHexString(uint256(role), 32)
804                     )
805                 )
806             );
807         }
808     }
809 
810     /**
811      * @dev Returns the admin role that controls `role`. See {grantRole} and
812      * {revokeRole}.
813      *
814      * To change a role's admin, use {_setRoleAdmin}.
815      */
816     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
817         return _roles[role].adminRole;
818     }
819 
820     /**
821      * @dev Grants `role` to `account`.
822      *
823      * If `account` had not been already granted `role`, emits a {RoleGranted}
824      * event.
825      *
826      * Requirements:
827      *
828      * - the caller must have ``role``'s admin role.
829      *
830      * May emit a {RoleGranted} event.
831      */
832     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
833         _grantRole(role, account);
834     }
835 
836     /**
837      * @dev Revokes `role` from `account`.
838      *
839      * If `account` had been granted `role`, emits a {RoleRevoked} event.
840      *
841      * Requirements:
842      *
843      * - the caller must have ``role``'s admin role.
844      *
845      * May emit a {RoleRevoked} event.
846      */
847     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
848         _revokeRole(role, account);
849     }
850 
851     /**
852      * @dev Revokes `role` from the calling account.
853      *
854      * Roles are often managed via {grantRole} and {revokeRole}: this function's
855      * purpose is to provide a mechanism for accounts to lose their privileges
856      * if they are compromised (such as when a trusted device is misplaced).
857      *
858      * If the calling account had been revoked `role`, emits a {RoleRevoked}
859      * event.
860      *
861      * Requirements:
862      *
863      * - the caller must be `account`.
864      *
865      * May emit a {RoleRevoked} event.
866      */
867     function renounceRole(bytes32 role, address account) public virtual override {
868         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
869 
870         _revokeRole(role, account);
871     }
872 
873     /**
874      * @dev Grants `role` to `account`.
875      *
876      * If `account` had not been already granted `role`, emits a {RoleGranted}
877      * event. Note that unlike {grantRole}, this function doesn't perform any
878      * checks on the calling account.
879      *
880      * May emit a {RoleGranted} event.
881      *
882      * [WARNING]
883      * ====
884      * This function should only be called from the constructor when setting
885      * up the initial roles for the system.
886      *
887      * Using this function in any other way is effectively circumventing the admin
888      * system imposed by {AccessControl}.
889      * ====
890      *
891      * NOTE: This function is deprecated in favor of {_grantRole}.
892      */
893     function _setupRole(bytes32 role, address account) internal virtual {
894         _grantRole(role, account);
895     }
896 
897     /**
898      * @dev Sets `adminRole` as ``role``'s admin role.
899      *
900      * Emits a {RoleAdminChanged} event.
901      */
902     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
903         bytes32 previousAdminRole = getRoleAdmin(role);
904         _roles[role].adminRole = adminRole;
905         emit RoleAdminChanged(role, previousAdminRole, adminRole);
906     }
907 
908     /**
909      * @dev Grants `role` to `account`.
910      *
911      * Internal function without access restriction.
912      *
913      * May emit a {RoleGranted} event.
914      */
915     function _grantRole(bytes32 role, address account) internal virtual {
916         if (!hasRole(role, account)) {
917             _roles[role].members[account] = true;
918             emit RoleGranted(role, account, _msgSender());
919         }
920     }
921 
922     /**
923      * @dev Revokes `role` from `account`.
924      *
925      * Internal function without access restriction.
926      *
927      * May emit a {RoleRevoked} event.
928      */
929     function _revokeRole(bytes32 role, address account) internal virtual {
930         if (hasRole(role, account)) {
931             _roles[role].members[account] = false;
932             emit RoleRevoked(role, account, _msgSender());
933         }
934     }
935 }
936 
937 // File: @openzeppelin/contracts/access/Ownable.sol
938 
939 
940 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
941 
942 pragma solidity ^0.8.0;
943 
944 
945 /**
946  * @dev Contract module which provides a basic access control mechanism, where
947  * there is an account (an owner) that can be granted exclusive access to
948  * specific functions.
949  *
950  * By default, the owner account will be the one that deploys the contract. This
951  * can later be changed with {transferOwnership}.
952  *
953  * This module is used through inheritance. It will make available the modifier
954  * `onlyOwner`, which can be applied to your functions to restrict their use to
955  * the owner.
956  */
957 abstract contract Ownable is Context {
958     address private _owner;
959 
960     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
961 
962     /**
963      * @dev Initializes the contract setting the deployer as the initial owner.
964      */
965     constructor() {
966         _transferOwnership(_msgSender());
967     }
968 
969     /**
970      * @dev Throws if called by any account other than the owner.
971      */
972     modifier onlyOwner() {
973         _checkOwner();
974         _;
975     }
976 
977     /**
978      * @dev Returns the address of the current owner.
979      */
980     function owner() public view virtual returns (address) {
981         return _owner;
982     }
983 
984     /**
985      * @dev Throws if the sender is not the owner.
986      */
987     function _checkOwner() internal view virtual {
988         require(owner() == _msgSender(), "Ownable: caller is not the owner");
989     }
990 
991     /**
992      * @dev Leaves the contract without owner. It will not be possible to call
993      * `onlyOwner` functions anymore. Can only be called by the current owner.
994      *
995      * NOTE: Renouncing ownership will leave the contract without an owner,
996      * thereby removing any functionality that is only available to the owner.
997      */
998     function renounceOwnership() public virtual onlyOwner {
999         _transferOwnership(address(0));
1000     }
1001 
1002     /**
1003      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1004      * Can only be called by the current owner.
1005      */
1006     function transferOwnership(address newOwner) public virtual onlyOwner {
1007         require(newOwner != address(0), "Ownable: new owner is the zero address");
1008         _transferOwnership(newOwner);
1009     }
1010 
1011     /**
1012      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1013      * Internal function without access restriction.
1014      */
1015     function _transferOwnership(address newOwner) internal virtual {
1016         address oldOwner = _owner;
1017         _owner = newOwner;
1018         emit OwnershipTransferred(oldOwner, newOwner);
1019     }
1020 }
1021 
1022 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1023 
1024 
1025 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1026 
1027 pragma solidity ^0.8.0;
1028 
1029 /**
1030  * @dev Interface of the ERC20 standard as defined in the EIP.
1031  */
1032 interface IERC20 {
1033     /**
1034      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1035      * another (`to`).
1036      *
1037      * Note that `value` may be zero.
1038      */
1039     event Transfer(address indexed from, address indexed to, uint256 value);
1040 
1041     /**
1042      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1043      * a call to {approve}. `value` is the new allowance.
1044      */
1045     event Approval(address indexed owner, address indexed spender, uint256 value);
1046 
1047     /**
1048      * @dev Returns the amount of tokens in existence.
1049      */
1050     function totalSupply() external view returns (uint256);
1051 
1052     /**
1053      * @dev Returns the amount of tokens owned by `account`.
1054      */
1055     function balanceOf(address account) external view returns (uint256);
1056 
1057     /**
1058      * @dev Moves `amount` tokens from the caller's account to `to`.
1059      *
1060      * Returns a boolean value indicating whether the operation succeeded.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function transfer(address to, uint256 amount) external returns (bool);
1065 
1066     /**
1067      * @dev Returns the remaining number of tokens that `spender` will be
1068      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1069      * zero by default.
1070      *
1071      * This value changes when {approve} or {transferFrom} are called.
1072      */
1073     function allowance(address owner, address spender) external view returns (uint256);
1074 
1075     /**
1076      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1077      *
1078      * Returns a boolean value indicating whether the operation succeeded.
1079      *
1080      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1081      * that someone may use both the old and the new allowance by unfortunate
1082      * transaction ordering. One possible solution to mitigate this race
1083      * condition is to first reduce the spender's allowance to 0 and set the
1084      * desired value afterwards:
1085      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1086      *
1087      * Emits an {Approval} event.
1088      */
1089     function approve(address spender, uint256 amount) external returns (bool);
1090 
1091     /**
1092      * @dev Moves `amount` tokens from `from` to `to` using the
1093      * allowance mechanism. `amount` is then deducted from the caller's
1094      * allowance.
1095      *
1096      * Returns a boolean value indicating whether the operation succeeded.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function transferFrom(
1101         address from,
1102         address to,
1103         uint256 amount
1104     ) external returns (bool);
1105 }
1106 
1107 // File: @uniswap/v3-periphery/contracts/libraries/TransferHelper.sol
1108 
1109 
1110 pragma solidity >=0.6.0;
1111 
1112 
1113 library TransferHelper {
1114     /// @notice Transfers tokens from the targeted address to the given destination
1115     /// @notice Errors with 'STF' if transfer fails
1116     /// @param token The contract address of the token to be transferred
1117     /// @param from The originating address from which the tokens will be transferred
1118     /// @param to The destination address of the transfer
1119     /// @param value The amount to be transferred
1120     function safeTransferFrom(
1121         address token,
1122         address from,
1123         address to,
1124         uint256 value
1125     ) internal {
1126         (bool success, bytes memory data) =
1127             token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
1128         require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
1129     }
1130 
1131     /// @notice Transfers tokens from msg.sender to a recipient
1132     /// @dev Errors with ST if transfer fails
1133     /// @param token The contract address of the token which will be transferred
1134     /// @param to The recipient of the transfer
1135     /// @param value The value of the transfer
1136     function safeTransfer(
1137         address token,
1138         address to,
1139         uint256 value
1140     ) internal {
1141         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
1142         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
1143     }
1144 
1145     /// @notice Approves the stipulated contract to spend the given allowance in the given token
1146     /// @dev Errors with 'SA' if transfer fails
1147     /// @param token The contract address of the token to be approved
1148     /// @param to The target of the approval
1149     /// @param value The amount of the given token the target will be allowed to spend
1150     function safeApprove(
1151         address token,
1152         address to,
1153         uint256 value
1154     ) internal {
1155         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.approve.selector, to, value));
1156         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');
1157     }
1158 
1159     /// @notice Transfers ETH to the recipient address
1160     /// @dev Fails with `STE`
1161     /// @param to The destination of the transfer
1162     /// @param value The value to be transferred
1163     function safeTransferETH(address to, uint256 value) internal {
1164         (bool success, ) = to.call{value: value}(new bytes(0));
1165         require(success, 'STE');
1166     }
1167 }
1168 
1169 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1170 
1171 
1172 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 
1177 /**
1178  * @dev Interface for the optional metadata functions from the ERC20 standard.
1179  *
1180  * _Available since v4.1._
1181  */
1182 interface IERC20Metadata is IERC20 {
1183     /**
1184      * @dev Returns the name of the token.
1185      */
1186     function name() external view returns (string memory);
1187 
1188     /**
1189      * @dev Returns the symbol of the token.
1190      */
1191     function symbol() external view returns (string memory);
1192 
1193     /**
1194      * @dev Returns the decimals places of the token.
1195      */
1196     function decimals() external view returns (uint8);
1197 }
1198 
1199 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1200 
1201 
1202 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 
1208 
1209 /**
1210  * @dev Implementation of the {IERC20} interface.
1211  *
1212  * This implementation is agnostic to the way tokens are created. This means
1213  * that a supply mechanism has to be added in a derived contract using {_mint}.
1214  * For a generic mechanism see {ERC20PresetMinterPauser}.
1215  *
1216  * TIP: For a detailed writeup see our guide
1217  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1218  * to implement supply mechanisms].
1219  *
1220  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1221  * instead returning `false` on failure. This behavior is nonetheless
1222  * conventional and does not conflict with the expectations of ERC20
1223  * applications.
1224  *
1225  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1226  * This allows applications to reconstruct the allowance for all accounts just
1227  * by listening to said events. Other implementations of the EIP may not emit
1228  * these events, as it isn't required by the specification.
1229  *
1230  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1231  * functions have been added to mitigate the well-known issues around setting
1232  * allowances. See {IERC20-approve}.
1233  */
1234 contract ERC20 is Context, IERC20, IERC20Metadata {
1235     mapping(address => uint256) private _balances;
1236 
1237     mapping(address => mapping(address => uint256)) private _allowances;
1238 
1239     uint256 private _totalSupply;
1240 
1241     string private _name;
1242     string private _symbol;
1243 
1244     /**
1245      * @dev Sets the values for {name} and {symbol}.
1246      *
1247      * The default value of {decimals} is 18. To select a different value for
1248      * {decimals} you should overload it.
1249      *
1250      * All two of these values are immutable: they can only be set once during
1251      * construction.
1252      */
1253     constructor(string memory name_, string memory symbol_) {
1254         _name = name_;
1255         _symbol = symbol_;
1256     }
1257 
1258     /**
1259      * @dev Returns the name of the token.
1260      */
1261     function name() public view virtual override returns (string memory) {
1262         return _name;
1263     }
1264 
1265     /**
1266      * @dev Returns the symbol of the token, usually a shorter version of the
1267      * name.
1268      */
1269     function symbol() public view virtual override returns (string memory) {
1270         return _symbol;
1271     }
1272 
1273     /**
1274      * @dev Returns the number of decimals used to get its user representation.
1275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1276      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1277      *
1278      * Tokens usually opt for a value of 18, imitating the relationship between
1279      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1280      * overridden;
1281      *
1282      * NOTE: This information is only used for _display_ purposes: it in
1283      * no way affects any of the arithmetic of the contract, including
1284      * {IERC20-balanceOf} and {IERC20-transfer}.
1285      */
1286     function decimals() public view virtual override returns (uint8) {
1287         return 18;
1288     }
1289 
1290     /**
1291      * @dev See {IERC20-totalSupply}.
1292      */
1293     function totalSupply() public view virtual override returns (uint256) {
1294         return _totalSupply;
1295     }
1296 
1297     /**
1298      * @dev See {IERC20-balanceOf}.
1299      */
1300     function balanceOf(address account) public view virtual override returns (uint256) {
1301         return _balances[account];
1302     }
1303 
1304     /**
1305      * @dev See {IERC20-transfer}.
1306      *
1307      * Requirements:
1308      *
1309      * - `to` cannot be the zero address.
1310      * - the caller must have a balance of at least `amount`.
1311      */
1312     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1313         address owner = _msgSender();
1314         _transfer(owner, to, amount);
1315         return true;
1316     }
1317 
1318     /**
1319      * @dev See {IERC20-allowance}.
1320      */
1321     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1322         return _allowances[owner][spender];
1323     }
1324 
1325     /**
1326      * @dev See {IERC20-approve}.
1327      *
1328      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1329      * `transferFrom`. This is semantically equivalent to an infinite approval.
1330      *
1331      * Requirements:
1332      *
1333      * - `spender` cannot be the zero address.
1334      */
1335     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1336         address owner = _msgSender();
1337         _approve(owner, spender, amount);
1338         return true;
1339     }
1340 
1341     /**
1342      * @dev See {IERC20-transferFrom}.
1343      *
1344      * Emits an {Approval} event indicating the updated allowance. This is not
1345      * required by the EIP. See the note at the beginning of {ERC20}.
1346      *
1347      * NOTE: Does not update the allowance if the current allowance
1348      * is the maximum `uint256`.
1349      *
1350      * Requirements:
1351      *
1352      * - `from` and `to` cannot be the zero address.
1353      * - `from` must have a balance of at least `amount`.
1354      * - the caller must have allowance for ``from``'s tokens of at least
1355      * `amount`.
1356      */
1357     function transferFrom(
1358         address from,
1359         address to,
1360         uint256 amount
1361     ) public virtual override returns (bool) {
1362         address spender = _msgSender();
1363         _spendAllowance(from, spender, amount);
1364         _transfer(from, to, amount);
1365         return true;
1366     }
1367 
1368     /**
1369      * @dev Atomically increases the allowance granted to `spender` by the caller.
1370      *
1371      * This is an alternative to {approve} that can be used as a mitigation for
1372      * problems described in {IERC20-approve}.
1373      *
1374      * Emits an {Approval} event indicating the updated allowance.
1375      *
1376      * Requirements:
1377      *
1378      * - `spender` cannot be the zero address.
1379      */
1380     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1381         address owner = _msgSender();
1382         _approve(owner, spender, allowance(owner, spender) + addedValue);
1383         return true;
1384     }
1385 
1386     /**
1387      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1388      *
1389      * This is an alternative to {approve} that can be used as a mitigation for
1390      * problems described in {IERC20-approve}.
1391      *
1392      * Emits an {Approval} event indicating the updated allowance.
1393      *
1394      * Requirements:
1395      *
1396      * - `spender` cannot be the zero address.
1397      * - `spender` must have allowance for the caller of at least
1398      * `subtractedValue`.
1399      */
1400     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1401         address owner = _msgSender();
1402         uint256 currentAllowance = allowance(owner, spender);
1403         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1404         unchecked {
1405             _approve(owner, spender, currentAllowance - subtractedValue);
1406         }
1407 
1408         return true;
1409     }
1410 
1411     /**
1412      * @dev Moves `amount` of tokens from `from` to `to`.
1413      *
1414      * This internal function is equivalent to {transfer}, and can be used to
1415      * e.g. implement automatic token fees, slashing mechanisms, etc.
1416      *
1417      * Emits a {Transfer} event.
1418      *
1419      * Requirements:
1420      *
1421      * - `from` cannot be the zero address.
1422      * - `to` cannot be the zero address.
1423      * - `from` must have a balance of at least `amount`.
1424      */
1425     function _transfer(
1426         address from,
1427         address to,
1428         uint256 amount
1429     ) internal virtual {
1430         require(from != address(0), "ERC20: transfer from the zero address");
1431         require(to != address(0), "ERC20: transfer to the zero address");
1432 
1433         _beforeTokenTransfer(from, to, amount);
1434 
1435         uint256 fromBalance = _balances[from];
1436         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1437         unchecked {
1438             _balances[from] = fromBalance - amount;
1439         }
1440         _balances[to] += amount;
1441 
1442         emit Transfer(from, to, amount);
1443 
1444         _afterTokenTransfer(from, to, amount);
1445     }
1446 
1447     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1448      * the total supply.
1449      *
1450      * Emits a {Transfer} event with `from` set to the zero address.
1451      *
1452      * Requirements:
1453      *
1454      * - `account` cannot be the zero address.
1455      */
1456     function _mint(address account, uint256 amount) internal virtual {
1457         require(account != address(0), "ERC20: mint to the zero address");
1458 
1459         _beforeTokenTransfer(address(0), account, amount);
1460 
1461         _totalSupply += amount;
1462         _balances[account] += amount;
1463         emit Transfer(address(0), account, amount);
1464 
1465         _afterTokenTransfer(address(0), account, amount);
1466     }
1467 
1468     /**
1469      * @dev Destroys `amount` tokens from `account`, reducing the
1470      * total supply.
1471      *
1472      * Emits a {Transfer} event with `to` set to the zero address.
1473      *
1474      * Requirements:
1475      *
1476      * - `account` cannot be the zero address.
1477      * - `account` must have at least `amount` tokens.
1478      */
1479     function _burn(address account, uint256 amount) internal virtual {
1480         require(account != address(0), "ERC20: burn from the zero address");
1481 
1482         _beforeTokenTransfer(account, address(0), amount);
1483 
1484         uint256 accountBalance = _balances[account];
1485         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1486         unchecked {
1487             _balances[account] = accountBalance - amount;
1488         }
1489         _totalSupply -= amount;
1490 
1491         emit Transfer(account, address(0), amount);
1492 
1493         _afterTokenTransfer(account, address(0), amount);
1494     }
1495 
1496     /**
1497      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1498      *
1499      * This internal function is equivalent to `approve`, and can be used to
1500      * e.g. set automatic allowances for certain subsystems, etc.
1501      *
1502      * Emits an {Approval} event.
1503      *
1504      * Requirements:
1505      *
1506      * - `owner` cannot be the zero address.
1507      * - `spender` cannot be the zero address.
1508      */
1509     function _approve(
1510         address owner,
1511         address spender,
1512         uint256 amount
1513     ) internal virtual {
1514         require(owner != address(0), "ERC20: approve from the zero address");
1515         require(spender != address(0), "ERC20: approve to the zero address");
1516 
1517         _allowances[owner][spender] = amount;
1518         emit Approval(owner, spender, amount);
1519     }
1520 
1521     /**
1522      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1523      *
1524      * Does not update the allowance amount in case of infinite allowance.
1525      * Revert if not enough allowance is available.
1526      *
1527      * Might emit an {Approval} event.
1528      */
1529     function _spendAllowance(
1530         address owner,
1531         address spender,
1532         uint256 amount
1533     ) internal virtual {
1534         uint256 currentAllowance = allowance(owner, spender);
1535         if (currentAllowance != type(uint256).max) {
1536             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1537             unchecked {
1538                 _approve(owner, spender, currentAllowance - amount);
1539             }
1540         }
1541     }
1542 
1543     /**
1544      * @dev Hook that is called before any transfer of tokens. This includes
1545      * minting and burning.
1546      *
1547      * Calling conditions:
1548      *
1549      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1550      * will be transferred to `to`.
1551      * - when `from` is zero, `amount` tokens will be minted for `to`.
1552      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1553      * - `from` and `to` are never both zero.
1554      *
1555      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1556      */
1557     function _beforeTokenTransfer(
1558         address from,
1559         address to,
1560         uint256 amount
1561     ) internal virtual {}
1562 
1563     /**
1564      * @dev Hook that is called after any transfer of tokens. This includes
1565      * minting and burning.
1566      *
1567      * Calling conditions:
1568      *
1569      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1570      * has been transferred to `to`.
1571      * - when `from` is zero, `amount` tokens have been minted for `to`.
1572      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1573      * - `from` and `to` are never both zero.
1574      *
1575      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1576      */
1577     function _afterTokenTransfer(
1578         address from,
1579         address to,
1580         uint256 amount
1581     ) internal virtual {}
1582 }
1583 
1584 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1585 
1586 
1587 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1588 
1589 pragma solidity ^0.8.0;
1590 
1591 
1592 
1593 /**
1594  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1595  * tokens and those that they have an allowance for, in a way that can be
1596  * recognized off-chain (via event analysis).
1597  */
1598 abstract contract ERC20Burnable is Context, ERC20 {
1599     /**
1600      * @dev Destroys `amount` tokens from the caller.
1601      *
1602      * See {ERC20-_burn}.
1603      */
1604     function burn(uint256 amount) public virtual {
1605         _burn(_msgSender(), amount);
1606     }
1607 
1608     /**
1609      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1610      * allowance.
1611      *
1612      * See {ERC20-_burn} and {ERC20-allowance}.
1613      *
1614      * Requirements:
1615      *
1616      * - the caller must have allowance for ``accounts``'s tokens of at least
1617      * `amount`.
1618      */
1619     function burnFrom(address account, uint256 amount) public virtual {
1620         _spendAllowance(account, _msgSender(), amount);
1621         _burn(account, amount);
1622     }
1623 }
1624 
1625 // File: contracts/UVPool.sol
1626 
1627 
1628 pragma solidity ^0.8.12;
1629 
1630 
1631 
1632 
1633 
1634 
1635 
1636 
1637 
1638 
1639 
1640 contract UVPool is ERC20, ERC20Burnable, Ownable, AccessControl, IUVPool {
1641     using SafeMath for uint256;
1642 
1643     struct WhiteList {
1644         uint256 limitDeposit; 
1645         uint64 startTimeDeposit; 
1646         uint64 closeTimeDeposit;
1647     }
1648 
1649     struct Vote {
1650         string name;
1651         uint64 startTimestamp;
1652         uint64 endTimestamp;
1653         bool isActive;
1654         uint64 voteCount;
1655     }
1656 
1657     struct VoteInfo {
1658         uint64 timestamp;
1659         uint256 amount;
1660         uint8 optionId;
1661         address voter;
1662     }
1663     uint256 public feeCreator = 1 ether;
1664     mapping(uint8 => Vote) public allVotes;
1665     mapping(uint8 => mapping(address => VoteInfo)) public allVoters;
1666     mapping(uint8 => mapping(uint64 => VoteInfo)) public allVotersIndex;
1667 
1668     uint8 private constant PERCENT_FEE = 250;
1669 
1670     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1671     
1672     address public constant SWAP_ROUTER_ADDRESS =
1673         0xE592427A0AEce92De3Edee1F18E0157C05861564;
1674     address public constant stableCoin =
1675         0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
1676 
1677     uint64 public poolOpenTime;
1678     mapping(address => WhiteList) public whiteList;
1679 
1680     mapping(address => uint256) private _balances;
1681     mapping(address => bool) public investmentAddreses;
1682     ISwapRouter public swapRouter;
1683     address public factory;
1684     address public factoryReserve;
1685     address public fundWallet;
1686     uint256 public currentSizePool = 0;
1687     uint256 public maxSizePool;
1688     uint8 public orderNumber;
1689     uint256 public minimumDeposit;
1690     bool public isClose = false;
1691     bool public pausedTransfer = false;
1692     bool public voteCreateable = true;
1693 
1694     constructor(uint8 _orderNumber)
1695         ERC20(
1696             string.concat("EUV - ", Strings.toString(_orderNumber)),
1697             string.concat("EUV-", Strings.toString(_orderNumber))
1698         )
1699     {
1700         factory = msg.sender;
1701         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1702         _setupRole(MANAGER_ROLE, msg.sender);
1703     }
1704 
1705     // called once by the factory at time of deployment
1706     function initialize(
1707         uint8 _orderNumber,
1708         uint256 _amountLimited,
1709         uint256 _minimumDeposit,
1710         address _fundWallet,
1711         address _factoryReserve,
1712         uint64 _poolOpenTime
1713     ) external {
1714         require(msg.sender == factory, "FORBIDDEN"); // sufficient check
1715         minimumDeposit = _minimumDeposit;
1716         maxSizePool = _amountLimited;
1717         orderNumber = _orderNumber;
1718         swapRouter = ISwapRouter(SWAP_ROUTER_ADDRESS);
1719         poolOpenTime = _poolOpenTime;
1720         fundWallet = _fundWallet;
1721         factoryReserve = _factoryReserve;
1722     }
1723 
1724     receive() external payable {}
1725 
1726     fallback() external payable {}
1727 
1728     // Transfer tokens to fund wallet process projects vesting
1729     function transferForInvestment(
1730         address _tokenAddress,
1731         uint256 _amount,
1732         address _receiver
1733     ) external onlyRole(MANAGER_ROLE) {
1734         require(_receiver != address(0), "receiver address is zero");
1735         require(
1736             investmentAddreses[_receiver],
1737             "receiver is not investment address"
1738         );
1739         if (_tokenAddress == address(0)) {
1740             TransferHelper.safeTransferETH(_receiver, _amount);
1741         } else {
1742             TransferHelper.safeTransfer(_tokenAddress, _receiver, _amount);
1743         }
1744     }
1745 
1746     // Add white list for user
1747     function addsWhiteList(
1748         address[] memory _users,
1749         uint256 _limitDeposit,
1750         uint64 _startTimeDeposit,
1751         uint64 _closeTimeDeposit
1752     ) external onlyRole(MANAGER_ROLE) {
1753         require(_users.length > 0, "users is empty");
1754         require(_limitDeposit > 0, "limit deposit is zero");
1755         require(_startTimeDeposit > 0, "start time deposit is zero");
1756         require(_closeTimeDeposit > 0, "close time deposit is zero");
1757         require(
1758             _closeTimeDeposit > _startTimeDeposit,
1759             "close time deposit must be greater than start time deposit"
1760         );
1761         for (uint256 index = 0; index < _users.length; index++) {
1762             whiteList[_users[index]] = WhiteList({
1763                 limitDeposit: _limitDeposit,
1764                 startTimeDeposit: _startTimeDeposit,
1765                 closeTimeDeposit: _closeTimeDeposit
1766             });
1767         }
1768     }
1769 
1770     // user in white list can deposit before pool open
1771     function wlDeposit(uint256 _amount) external {
1772         require(!isClose, "Pool is closed");
1773         require(_amount > 0, "Amount must be greater than zero");
1774         require(
1775             block.timestamp <= whiteList[msg.sender].closeTimeDeposit,
1776             "Deposit time is over"
1777         );
1778         require(
1779             block.timestamp >= whiteList[msg.sender].startTimeDeposit,
1780             "Deposit time is not start"
1781         );
1782         require(
1783             whiteList[msg.sender].limitDeposit >= _amount,
1784             "Deposit amount is over limit"
1785         );
1786         require(
1787             currentSizePool.add(_amount) <= maxSizePool,
1788             "Deposit amount is over limit"
1789         );
1790         require(_amount >= minimumDeposit, "Not enough");
1791         
1792         uint256 amount6Decimals = _amount.div(10**12);
1793         IERC20(stableCoin).transferFrom(msg.sender, address(this), amount6Decimals);
1794         _mint(msg.sender, _amount);
1795         _balances[msg.sender] = _balances[msg.sender].add(_amount);
1796         _mint(fundWallet, _amount.mul(PERCENT_FEE).div(1000));
1797         _balances[fundWallet] = _balances[fundWallet].add(
1798             _amount.mul(PERCENT_FEE).div(1000)
1799         );
1800         currentSizePool = currentSizePool.add(_amount);
1801         whiteList[msg.sender].limitDeposit = whiteList[msg.sender]
1802             .limitDeposit
1803             .sub(_amount);
1804 
1805         emit Deposit(msg.sender, _amount);
1806     }
1807 
1808     // Deposit stable coin to the pool
1809     function deposit(uint256 _amount) public {
1810         require(!isClose, "Pool is closed");
1811         require(maxSizePool >= currentSizePool.add(_amount), "Pool is full");
1812         require(_amount >= minimumDeposit, "Not enough");
1813         require(
1814             block.timestamp >= poolOpenTime,
1815             "Pool is not open yet, please wait"
1816         );
1817 
1818         uint256 amount6Decimals = _amount.div(10**12);
1819         IERC20(stableCoin).transferFrom(msg.sender, address(this), amount6Decimals);
1820         _mint(msg.sender, _amount);
1821         _balances[msg.sender] = _balances[msg.sender].add(_amount);
1822         _mint(fundWallet, _amount.mul(PERCENT_FEE).div(1000));
1823         _balances[fundWallet] = _balances[fundWallet].add(
1824             _amount.mul(PERCENT_FEE).div(1000)
1825         );
1826 
1827         currentSizePool += _amount;
1828 
1829         emit Deposit(msg.sender, _amount);
1830     }
1831 
1832     // Get pool reserved
1833     function getReserve() public view returns (address) {
1834         (address _poolReserved, , , ) = IUVReserveFactory(factoryReserve)
1835             .getPoolInfo(orderNumber);
1836         return _poolReserved;
1837     }
1838 
1839     // swap any token on uniswap
1840     function buyToken(
1841         uint256 _amountIn,
1842         uint256 _amountOutMin,
1843         address _tokenIn,
1844         bytes calldata _path,
1845         uint256 _deadline
1846     ) public onlyRole(MANAGER_ROLE) {
1847         require(isClose, "Pool is not closed");
1848         address _poolReserved = getReserve();
1849 
1850         TransferHelper.safeApprove(_tokenIn, address(swapRouter), _amountIn);
1851 
1852         ISwapRouter.ExactInputParams memory params = ISwapRouter
1853             .ExactInputParams({
1854                 path: _path,
1855                 recipient: _poolReserved,
1856                 deadline: _deadline,
1857                 amountIn: _amountIn,
1858                 amountOutMinimum: _amountOutMin
1859             });
1860 
1861         // Executes the swap.
1862         uint256 realAmount = swapRouter.exactInput(params);
1863 
1864         emit BuyToken(_tokenIn, realAmount);
1865     }
1866 
1867     // toggles the paused state of the transfer function
1868     function togglePausedTransfer() public onlyRole(MANAGER_ROLE) {
1869         pausedTransfer = !pausedTransfer;
1870     }
1871 
1872     function transfer(address recipient, uint256 amount)
1873         public
1874         override
1875         returns (bool)
1876     {
1877         _transfer(_msgSender(), recipient, amount);
1878         return true;
1879     }
1880 
1881     function transferFrom(
1882         address sender,
1883         address recipient,
1884         uint256 amount
1885     ) public virtual override returns (bool) {
1886         _transfer(sender, recipient, amount);
1887 
1888         return true;
1889     }
1890 
1891     function _transfer(
1892         address sender,
1893         address recipient,
1894         uint256 amount
1895     ) internal virtual override {
1896         require(sender != address(0), "ERC20: transfer from the zero address");
1897         require(recipient != address(0), "ERC20: transfer to the zero address");
1898         require(pausedTransfer == false, "ERC20: transfer is paused");
1899         require(amount > 0, "Transfer amount must be greater than zero");
1900         require(
1901             amount <= _balances[sender],
1902             "ERC20: amount must be less or equal to balance"
1903         );
1904 
1905         _balances[sender] = _balances[sender].sub(amount);
1906         _balances[recipient] = _balances[recipient].add(amount);
1907         emit Transfer(sender, recipient, amount);
1908     }
1909 
1910     function balanceOf(address owner) public view override returns (uint256) {
1911         return _balances[owner];
1912     }
1913 
1914     // Add investment address
1915     function addInvestmentAddress(address _investmentAddress) public onlyOwner {
1916         investmentAddreses[_investmentAddress] = true;
1917     }
1918 
1919     // Remove investment address
1920     function removeInvestmentAddress(address _investmentAddress)
1921         public
1922         onlyOwner
1923     {
1924         investmentAddreses[_investmentAddress] = false;
1925     }
1926 
1927     // Set the fund wallet
1928     function setFundWallet(address _fundWallet) public onlyOwner {
1929         fundWallet = _fundWallet;
1930     }
1931 
1932     // Set the factory Reserve
1933     function setFactoryReserve(address _factoryReserve)
1934         public
1935         onlyRole(MANAGER_ROLE)
1936     {
1937         factoryReserve = _factoryReserve;
1938     }
1939 
1940     // Set minimum deposit amount
1941     function setMinimumDeposit(uint256 _minimumDeposit)
1942         public
1943         onlyRole(MANAGER_ROLE)
1944     {
1945         minimumDeposit = _minimumDeposit;
1946     }
1947 
1948     // open the pool
1949     function openPool() public onlyRole(MANAGER_ROLE) {
1950         isClose = false;
1951     }
1952 
1953     // close the pool
1954     function closePool() public onlyRole(MANAGER_ROLE) {
1955         isClose = true;
1956     }
1957 
1958     // get detail Vote
1959     function getVote(uint8 _orderNumber) public view returns (Vote memory) {
1960         return allVotes[_orderNumber];
1961     }
1962 
1963     // Set fee creator
1964     function setFeeCreator(uint256 _feeCreator) public onlyRole(MANAGER_ROLE) {
1965         feeCreator = _feeCreator;
1966     }
1967 
1968     // Add wallet to manager role
1969     function addManager(address _manager) public onlyOwner {
1970         _setupRole(MANAGER_ROLE, _manager);
1971     }
1972 
1973     // Remove wallet from manager role
1974     function removeManager(address _manager) public onlyOwner {
1975         revokeRole(MANAGER_ROLE, _manager);
1976     }
1977 
1978     // get detail VoteInfo by orderNumber
1979     function getVoteInfo(uint8 _orderNumber, address _user)
1980         public
1981         view
1982         returns (VoteInfo memory)
1983     {
1984         return allVoters[_orderNumber][_user];
1985     }
1986 
1987     // create a new vote
1988     function createVote(
1989         uint8 _orderNumber,
1990         uint64 _startTimestamp,
1991         uint64 _endTimestamp
1992     ) public payable {
1993         require(voteCreateable, "Vote is not createable");
1994         require(isClose, "Pool is not closed");
1995         if (hasRole(MANAGER_ROLE, msg.sender)) {} else {
1996             require(
1997                 msg.value >= feeCreator,
1998                 "You need to pay fee to create vote"
1999             );
2000             uint256 balance = balanceOf(msg.sender);
2001             require(
2002                 balance >= totalSupply().div(10) ||
2003                     hasRole(MANAGER_ROLE, msg.sender),
2004                 "You need to have 10% of total supply"
2005             );
2006         }
2007 
2008         allVotes[_orderNumber].startTimestamp = _startTimestamp;
2009         allVotes[_orderNumber].endTimestamp = _endTimestamp;
2010         allVotes[_orderNumber].isActive = true;
2011         voteCreateable = false;
2012 
2013         emit CreateVote(_orderNumber, _startTimestamp, _endTimestamp);
2014     }
2015 
2016     // close a vote
2017     function closeVote(uint8 _orderNumber) public onlyRole(MANAGER_ROLE) {
2018         allVotes[_orderNumber].isActive = false;
2019         voteCreateable = true;
2020         emit CloseVote(_orderNumber);
2021     }
2022 
2023     // voting for a option
2024     function voting(uint8 _orderNumber, uint8 _optionId) public {
2025         require(isClose, "This Pool is closed");
2026         require(allVotes[_orderNumber].isActive, "This Vote is closed");
2027         require(
2028             allVoters[_orderNumber][msg.sender].timestamp == 0,
2029             "You have voted"
2030         );
2031         require(
2032             allVoters[_orderNumber][msg.sender].amount == 0,
2033             "You have voted"
2034         );
2035         uint256 _amountBalance = balanceOf(msg.sender);
2036 
2037         transferFrom(msg.sender, address(this), _amountBalance);
2038         allVotes[_orderNumber].voteCount += 1;
2039 
2040         allVoters[_orderNumber][msg.sender] = VoteInfo({
2041             amount: _amountBalance,
2042             timestamp: uint64(block.timestamp),
2043             optionId: _optionId,
2044             voter: msg.sender
2045         });
2046         allVotersIndex[_orderNumber][
2047             allVotes[_orderNumber].voteCount
2048         ] = VoteInfo({
2049             amount: _amountBalance,
2050             timestamp: uint64(block.timestamp),
2051             optionId: _optionId,
2052             voter: msg.sender
2053         });
2054 
2055         emit Voting(
2056             msg.sender,
2057             _amountBalance,
2058             uint64(block.timestamp),
2059             _optionId,
2060             allVotes[_orderNumber].voteCount
2061         );
2062     }
2063 
2064     // internal release token after vote closed
2065     function releaseTokenAfterVote(
2066         uint8 _orderNumber,
2067         uint64 _from,
2068         uint64 _to
2069     ) external onlyRole(MANAGER_ROLE) {
2070         require(!allVotes[_orderNumber].isActive, "This Vote is still active");
2071         for (uint64 i = _from; i < _to; i++) {
2072             _transfer(
2073                 address(this),
2074                 allVotersIndex[_orderNumber][i].voter,
2075                 allVotersIndex[_orderNumber][i].amount
2076             );
2077         }
2078     }
2079 }