1 // Sources flattened with hardhat v2.4.1 https://hardhat.org
2 
3 // File contracts/interfaces/IERC20.sol
4 // SPDX-License-Identifier: MIT
5 pragma solidity >=0.5.0;
6 
7 interface IERC20 {
8     function name() external view returns (string memory);
9     function symbol() external view returns (string memory);
10     function decimals() external view returns (uint8);
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 }
18 
19 
20 // File contracts/utils/Address.sol
21 
22 pragma solidity >=0.5.0 <0.9.0;
23 
24 /**
25  * @dev Collection of functions related to the address type
26  */
27 library Address {
28     /**
29      * @dev Returns true if `account` is a contract.
30      *
31      * [IMPORTANT]
32      * ====
33      * It is unsafe to assume that an address for which this function returns
34      * false is an externally-owned account (EOA) and not a contract.
35      *
36      * Among others, `isContract` will return false for the following
37      * types of addresses:
38      *
39      *  - an externally-owned account
40      *  - a contract in construction
41      *  - an address where a contract will be created
42      *  - an address where a contract lived, but was destroyed
43      * ====
44      */
45     function isContract(address account) internal view returns (bool) {
46         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
47         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
48         // for accounts without code, i.e. `keccak256('')`
49         bytes32 codehash;
50 
51 
52             bytes32 accountHash
53          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
54         // solhint-disable-next-line no-inline-assembly
55         assembly {
56             codehash := extcodehash(account)
57         }
58         return (codehash != accountHash && codehash != 0x0);
59     }
60 
61 /**
62     
63      * @dev Converts an `address` into `address payable`. Note that this is
64      * simply a type cast: the actual underlying value is not changed.
65      *
66      * _Available since v2.4.0._
67     
68     function toPayable(address account)
69         internal
70         pure
71         returns (address payable)
72     {
73         return address(uint160(account));
74     }
75     
76 */
77 
78 /**
79 
80      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
81      * `recipient`, forwarding all available gas and reverting on errors.
82      *
83      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
84      * of certain opcodes, possibly making contracts go over the 2300 gas limit
85      * imposed by `transfer`, making them unable to receive funds via
86      * `transfer`. {sendValue} removes this limitation.
87      *
88      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
89      *
90      * IMPORTANT: because control is transferred to `recipient`, care must be
91      * taken to not create reentrancy vulnerabilities. Consider using
92      * {ReentrancyGuard} or the
93      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
94      *
95      * _Available since v2.4.0._
96 
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(
99             address(this).balance >= amount,
100             "Address: insufficient balance"
101         );
102 
103         // solhint-disable-next-line avoid-call-value
104         (bool success, ) = recipient.call.value(amount)("");
105         require(
106             success,
107             "Address: unable to send value, recipient may have reverted"
108         );
109     }
110 */
111 }
112 
113 
114 // File contracts/utils/SafeMath.sol
115 
116 pragma solidity >=0.5.0 <0.9.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      * - Subtraction cannot overflow.
169      *
170      * _Available since v2.4.0._
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      * - Multiplication cannot overflow.
191      */
192     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
193         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194         // benefit is lost if 'b' is also tested.
195         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
196         if (a == 0) {
197             return 0;
198         }
199 
200         uint256 c = a * b;
201         require(c / a == b, "SafeMath: multiplication overflow");
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      * - The divisor cannot be zero.
231      *
232      * _Available since v2.4.0._
233      */
234     function div(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         // Solidity only automatically asserts when dividing by 0
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      *
273      * _Available since v2.4.0._
274      */
275     function mod(
276         uint256 a,
277         uint256 b,
278         string memory errorMessage
279     ) internal pure returns (uint256) {
280         require(b != 0, errorMessage);
281         return a % b;
282     }
283 }
284 
285 
286 // File contracts/utils/SafeERC20.sol
287 
288 pragma solidity >=0.5.0 <0.9.0;
289 
290 
291 
292 /**
293  * @title SafeERC20
294  * @dev Wrappers around ERC20 operations that throw on failure (when the token
295  * contract returns false). Tokens that return no value (and instead revert or
296  * throw on failure) are also supported, non-reverting calls are assumed to be
297  * successful.
298  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302     using SafeMath for uint256;
303     using Address for address;
304 
305     function safeTransfer(
306         IERC20 token,
307         address to,
308         uint256 value
309     ) internal {
310         callOptionalReturn(
311             token,
312             abi.encodeWithSelector(token.transfer.selector, to, value)
313         );
314     }
315 
316     function safeTransferFrom(
317         IERC20 token,
318         address from,
319         address to,
320         uint256 value
321     ) internal {
322         callOptionalReturn(
323             token,
324             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
325         );
326     }
327 
328     function safeApprove(
329         IERC20 token,
330         address spender,
331         uint256 value
332     ) internal {
333         // safeApprove should only be called when setting an initial allowance,
334         // or when resetting it to zero. To increase and decrease it, use
335         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
336         // solhint-disable-next-line max-line-length
337         require(
338             (value == 0) || (token.allowance(address(this), spender) == 0),
339             "SafeERC20: approve from non-zero to non-zero allowance"
340         );
341         callOptionalReturn(
342             token,
343             abi.encodeWithSelector(token.approve.selector, spender, value)
344         );
345     }
346 
347     function safeIncreaseAllowance(
348         IERC20 token,
349         address spender,
350         uint256 value
351     ) internal {
352         uint256 newAllowance = token.allowance(address(this), spender).add(
353             value
354         );
355         callOptionalReturn(
356             token,
357             abi.encodeWithSelector(
358                 token.approve.selector,
359                 spender,
360                 newAllowance
361             )
362         );
363     }
364 
365     function safeDecreaseAllowance(
366         IERC20 token,
367         address spender,
368         uint256 value
369     ) internal {
370         uint256 newAllowance = token.allowance(address(this), spender).sub(
371             value,
372             "SafeERC20: decreased allowance below zero"
373         );
374         callOptionalReturn(
375             token,
376             abi.encodeWithSelector(
377                 token.approve.selector,
378                 spender,
379                 newAllowance
380             )
381         );
382     }
383 
384     /**
385      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
386      * on the return value: the return value is optional (but if data is returned, it must not be false).
387      * @param token The token targeted by the call.
388      * @param data The call data (encoded using abi.encode or one of its variants).
389      */
390     function callOptionalReturn(IERC20 token, bytes memory data) private {
391         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
392         // we're implementing it ourselves.
393 
394         // A Solidity high level call has three parts:
395         //  1. The target address is checked to verify it contains contract code
396         //  2. The call itself is made, and success asserted
397         //  3. The return value is decoded, which in turn checks the size of the returned data.
398         // solhint-disable-next-line max-line-length
399         require(address(token).isContract(), "SafeERC20: call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = address(token).call(data);
403         require(success, "SafeERC20: low-level call failed");
404 
405         if (returndata.length > 0) {
406             // Return data is optional
407             // solhint-disable-next-line max-line-length
408             require(
409                 abi.decode(returndata, (bool)),
410                 "SafeERC20: ERC20 operation did not succeed"
411             );
412         }
413     }
414 }
415 
416 
417 // File contracts/utils/ReentrancyGuard.sol
418 
419 pragma solidity >=0.5.0 <0.9.0;
420 
421 /**
422  * @dev Contract module that helps prevent reentrant calls to a function.
423  *
424  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
425  * available, which can be applied to functions to make sure there are no nested
426  * (reentrant) calls to them.
427  *
428  * Note that because there is a single `nonReentrant` guard, functions marked as
429  * `nonReentrant` may not call one another. This can be worked around by making
430  * those functions `private`, and then adding `external` `nonReentrant` entry
431  * points to them.
432  *
433  * TIP: If you would like to learn more about reentrancy and alternative ways
434  * to protect against it, check out our blog post
435  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
436  *
437  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
438  * metering changes introduced in the Istanbul hardfork.
439  */
440 contract ReentrancyGuard {
441     bool private _notEntered;
442 
443     constructor() public {
444         // Storing an initial non-zero value makes deployment a bit more
445         // expensive, but in exchange the refund on every call to nonReentrant
446         // will be lower in amount. Since refunds are capped to a percetange of
447         // the total transaction's gas, it is best to keep them low in cases
448         // like this one, to increase the likelihood of the full refund coming
449         // into effect.
450         _notEntered = true;
451     }
452 
453     /**
454      * @dev Prevents a contract from calling itself, directly or indirectly.
455      * Calling a `nonReentrant` function from another `nonReentrant`
456      * function is not supported. It is possible to prevent this from happening
457      * by making the `nonReentrant` function external, and make it call a
458      * `private` function that does the actual work.
459      */
460     modifier nonReentrant() {
461         // On the first call to nonReentrant, _notEntered will be true
462         require(_notEntered, "ReentrancyGuard: reentrant call");
463 
464         // Any calls to nonReentrant after this point will fail
465         _notEntered = false;
466 
467         _;
468 
469         // By storing the original value once again, a refund is triggered (see
470         // https://eips.ethereum.org/EIPS/eip-2200)
471         _notEntered = true;
472     }
473 }
474 
475 
476 // File contracts/interfaces/IAccessControl.sol
477 
478 // OpenZeppelin Contracts v4.4.0 (access/IAccessControl.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev External interface of AccessControl declared to support ERC165 detection.
484  */
485 interface IAccessControl {
486     /**
487      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
488      *
489      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
490      * {RoleAdminChanged} not being emitted signaling this.
491      *
492      * _Available since v3.1._
493      */
494     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
495 
496     /**
497      * @dev Emitted when `account` is granted `role`.
498      *
499      * `sender` is the account that originated the contract call, an admin role
500      * bearer except when using {AccessControl-_setupRole}.
501      */
502     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
503 
504     /**
505      * @dev Emitted when `account` is revoked `role`.
506      *
507      * `sender` is the account that originated the contract call:
508      *   - if using `revokeRole`, it is the admin role bearer
509      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
510      */
511     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
512 
513     /**
514      * @dev Returns `true` if `account` has been granted `role`.
515      */
516     function hasRole(bytes32 role, address account) external view returns (bool);
517 
518     /**
519      * @dev Returns the admin role that controls `role`. See {grantRole} and
520      * {revokeRole}.
521      *
522      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
523      */
524     function getRoleAdmin(bytes32 role) external view returns (bytes32);
525 
526     /**
527      * @dev Grants `role` to `account`.
528      *
529      * If `account` had not been already granted `role`, emits a {RoleGranted}
530      * event.
531      *
532      * Requirements:
533      *
534      * - the caller must have ``role``'s admin role.
535      */
536     function grantRole(bytes32 role, address account) external;
537 
538     /**
539      * @dev Revokes `role` from `account`.
540      *
541      * If `account` had been granted `role`, emits a {RoleRevoked} event.
542      *
543      * Requirements:
544      *
545      * - the caller must have ``role``'s admin role.
546      */
547     function revokeRole(bytes32 role, address account) external;
548 
549     /**
550      * @dev Revokes `role` from the calling account.
551      *
552      * Roles are often managed via {grantRole} and {revokeRole}: this function's
553      * purpose is to provide a mechanism for accounts to lose their privileges
554      * if they are compromised (such as when a trusted device is misplaced).
555      *
556      * If the calling account had been granted `role`, emits a {RoleRevoked}
557      * event.
558      *
559      * Requirements:
560      *
561      * - the caller must be `account`.
562      */
563     function renounceRole(bytes32 role, address account) external;
564 }
565 
566 
567 // File contracts/utils/Context.sol
568 
569 pragma solidity >=0.5.0 <0.9.0;
570 
571 /*
572  * @dev Provides information about the current execution context, including the
573  * sender of the transaction and its data. While these are generally available
574  * via msg.sender and msg.data, they should not be accessed in such a direct
575  * manner, since when dealing with meta-transactions the account sending and
576  * paying for execution may not be the actual sender (as far as an application
577  * is concerned).
578  *
579  * This contract is only required for intermediate, library-like contracts.
580  */
581 contract Context {
582     function _msgSender() internal view returns (address) {
583         return msg.sender;
584     }
585 
586     function _msgData() internal view returns (bytes memory) {
587         return msg.data;
588     }
589 }
590 
591 
592 // File contracts/utils/Strings.sol
593 
594 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev String operations.
600  */
601 library Strings {
602     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
606      */
607     function toString(uint256 value) internal pure returns (string memory) {
608         // Inspired by OraclizeAPI's implementation - MIT licence
609         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
610 
611         if (value == 0) {
612             return "0";
613         }
614         uint256 temp = value;
615         uint256 digits;
616         while (temp != 0) {
617             digits++;
618             temp /= 10;
619         }
620         bytes memory buffer = new bytes(digits);
621         while (value != 0) {
622             digits -= 1;
623             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
624             value /= 10;
625         }
626         return string(buffer);
627     }
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
631      */
632     function toHexString(uint256 value) internal pure returns (string memory) {
633         if (value == 0) {
634             return "0x00";
635         }
636         uint256 temp = value;
637         uint256 length = 0;
638         while (temp != 0) {
639             length++;
640             temp >>= 8;
641         }
642         return toHexString(value, length);
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
647      */
648     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
649         bytes memory buffer = new bytes(2 * length + 2);
650         buffer[0] = "0";
651         buffer[1] = "x";
652         for (uint256 i = 2 * length + 1; i > 1; --i) {
653             buffer[i] = _HEX_SYMBOLS[value & 0xf];
654             value >>= 4;
655         }
656         require(value == 0, "Strings: hex length insufficient");
657         return string(buffer);
658     }
659 }
660 
661 
662 // File contracts/interfaces/IERC165.sol
663 
664 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @dev Interface of the ERC165 standard, as defined in the
670  * https://eips.ethereum.org/EIPS/eip-165[EIP].
671  *
672  * Implementers can declare support of contract interfaces, which can then be
673  * queried by others ({ERC165Checker}).
674  *
675  * For an implementation, see {ERC165}.
676  */
677 interface IERC165 {
678     /**
679      * @dev Returns true if this contract implements the interface defined by
680      * `interfaceId`. See the corresponding
681      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
682      * to learn more about how these ids are created.
683      *
684      * This function call must use less than 30 000 gas.
685      */
686     function supportsInterface(bytes4 interfaceId) external view returns (bool);
687 }
688 
689 
690 // File contracts/utils/ERC165.sol
691 
692 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 /**
697  * @dev Implementation of the {IERC165} interface.
698  *
699  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
700  * for the additional interface id that will be supported. For example:
701  *
702  * ```solidity
703  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
704  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
705  * }
706  * ```
707  *
708  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
709  */
710 abstract contract ERC165 is IERC165 {
711     /**
712      * @dev See {IERC165-supportsInterface}.
713      */
714     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715         return interfaceId == type(IERC165).interfaceId;
716     }
717 }
718 
719 
720 // File contracts/utils/AccessControl.sol
721 
722 // OpenZeppelin Contracts v4.4.0 (access/AccessControl.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 
728 
729 /**
730  * @dev Contract module that allows children to implement role-based access
731  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
732  * members except through off-chain means by accessing the contract event logs. Some
733  * applications may benefit from on-chain enumerability, for those cases see
734  * {AccessControlEnumerable}.
735  *
736  * Roles are referred to by their `bytes32` identifier. These should be exposed
737  * in the external API and be unique. The best way to achieve this is by
738  * using `public constant` hash digests:
739  *
740  * ```
741  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
742  * ```
743  *
744  * Roles can be used to represent a set of permissions. To restrict access to a
745  * function call, use {hasRole}:
746  *
747  * ```
748  * function foo() public {
749  *     require(hasRole(MY_ROLE, msg.sender));
750  *     ...
751  * }
752  * ```
753  *
754  * Roles can be granted and revoked dynamically via the {grantRole} and
755  * {revokeRole} functions. Each role has an associated admin role, and only
756  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
757  *
758  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
759  * that only accounts with this role will be able to grant or revoke other
760  * roles. More complex role relationships can be created by using
761  * {_setRoleAdmin}.
762  *
763  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
764  * grant and revoke this role. Extra precautions should be taken to secure
765  * accounts that have been granted it.
766  */
767 abstract contract AccessControl is Context, IAccessControl, ERC165 {
768     struct RoleData {
769         mapping(address => bool) members;
770         bytes32 adminRole;
771     }
772 
773     mapping(bytes32 => RoleData) private _roles;
774 
775     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
776 
777     /**
778      * @dev Modifier that checks that an account has a specific role. Reverts
779      * with a standardized message including the required role.
780      *
781      * The format of the revert reason is given by the following regular expression:
782      *
783      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
784      *
785      * _Available since v4.1._
786      */
787     modifier onlyRole(bytes32 role) {
788         _checkRole(role, _msgSender());
789         _;
790     }
791 
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
796         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev Returns `true` if `account` has been granted `role`.
801      */
802     function hasRole(bytes32 role, address account) public view override returns (bool) {
803         return _roles[role].members[account];
804     }
805 
806     /**
807      * @dev Revert with a standard message if `account` is missing `role`.
808      *
809      * The format of the revert reason is given by the following regular expression:
810      *
811      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
812      */
813     function _checkRole(bytes32 role, address account) internal view {
814         if (!hasRole(role, account)) {
815             revert(
816                 string(
817                     abi.encodePacked(
818                         "AccessControl: account ",
819                         Strings.toHexString(uint160(account), 20),
820                         " is missing role ",
821                         Strings.toHexString(uint256(role), 32)
822                     )
823                 )
824             );
825         }
826     }
827 
828     /**
829      * @dev Returns the admin role that controls `role`. See {grantRole} and
830      * {revokeRole}.
831      *
832      * To change a role's admin, use {_setRoleAdmin}.
833      */
834     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
835         return _roles[role].adminRole;
836     }
837 
838     /**
839      * @dev Grants `role` to `account`.
840      *
841      * If `account` had not been already granted `role`, emits a {RoleGranted}
842      * event.
843      *
844      * Requirements:
845      *
846      * - the caller must have ``role``'s admin role.
847      */
848     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
849         _grantRole(role, account);
850     }
851 
852     /**
853      * @dev Revokes `role` from `account`.
854      *
855      * If `account` had been granted `role`, emits a {RoleRevoked} event.
856      *
857      * Requirements:
858      *
859      * - the caller must have ``role``'s admin role.
860      */
861     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
862         _revokeRole(role, account);
863     }
864 
865     /**
866      * @dev Revokes `role` from the calling account.
867      *
868      * Roles are often managed via {grantRole} and {revokeRole}: this function's
869      * purpose is to provide a mechanism for accounts to lose their privileges
870      * if they are compromised (such as when a trusted device is misplaced).
871      *
872      * If the calling account had been revoked `role`, emits a {RoleRevoked}
873      * event.
874      *
875      * Requirements:
876      *
877      * - the caller must be `account`.
878      */
879     function renounceRole(bytes32 role, address account) public virtual override {
880         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
881 
882         _revokeRole(role, account);
883     }
884 
885     /**
886      * @dev Grants `role` to `account`.
887      *
888      * If `account` had not been already granted `role`, emits a {RoleGranted}
889      * event. Note that unlike {grantRole}, this function doesn't perform any
890      * checks on the calling account.
891      *
892      * [WARNING]
893      * ====
894      * This function should only be called from the constructor when setting
895      * up the initial roles for the system.
896      *
897      * Using this function in any other way is effectively circumventing the admin
898      * system imposed by {AccessControl}.
899      * ====
900      *
901      * NOTE: This function is deprecated in favor of {_grantRole}.
902      */
903     function _setupRole(bytes32 role, address account) internal virtual {
904         _grantRole(role, account);
905     }
906 
907     /**
908      * @dev Sets `adminRole` as ``role``'s admin role.
909      *
910      * Emits a {RoleAdminChanged} event.
911      */
912     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
913         bytes32 previousAdminRole = getRoleAdmin(role);
914         _roles[role].adminRole = adminRole;
915         emit RoleAdminChanged(role, previousAdminRole, adminRole);
916     }
917 
918     /**
919      * @dev Grants `role` to `account`.
920      *
921      * Internal function without access restriction.
922      */
923     function _grantRole(bytes32 role, address account) internal virtual {
924         if (!hasRole(role, account)) {
925             _roles[role].members[account] = true;
926             emit RoleGranted(role, account, _msgSender());
927         }
928     }
929 
930     /**
931      * @dev Revokes `role` from `account`.
932      *
933      * Internal function without access restriction.
934      */
935     function _revokeRole(bytes32 role, address account) internal virtual {
936         if (hasRole(role, account)) {
937             _roles[role].members[account] = false;
938             emit RoleRevoked(role, account, _msgSender());
939         }
940     }
941 }
942 
943 
944 // File contracts/QUAICohortFarming.sol
945 
946 pragma solidity =0.8.4;
947 
948 
949 
950 
951 
952 
953     /*
954      * rewardIndex keeps track of the total amount of rewards to be distributed for
955      * each supplied unit of 'stakedToken' tokens. When used together with supplierIndex,
956      * the total amount of rewards to be paid out to individual users can be calculated
957      * when the user claims their rewards.
958      *
959      * Consider the following:
960      *
961      * At contract deployment, the contract has a zero 'stakedToken' balance. Immediately, a new
962      * user, User A, deposits 1000 'stakedToken' tokens, thus increasing the total supply to
963      * 1000 'stakedToken'. After 60 seconds, a second user, User B, deposits an additional 500 'stakedToken',
964      * increasing the total supplied amount to 1500 'stakedToken'.
965      *
966      * Because all balance-changing contract calls, as well as those changing the reward
967      * speeds, must invoke the accrueRewards function, these deposit calls trigger the
968      * function too. The accrueRewards function considers the reward speed (denoted in
969      * reward tokens per second), the reward and supplier reward indexes, and the supply
970      * balance to calculate the accrued rewards.
971      *
972      * When User A deposits their tokens, rewards are yet to be accrued due to previous
973      * inactivity; the elapsed time since the previous, non-existent, reward-accruing
974      * contract call is zero, thus having a reward accrual period of zero. The block
975      * time of the deposit transaction is saved in the contract to indicate last
976      * activity time.
977      *
978      * When User B deposits their tokens, 60 seconds has elapsed since the previous
979      * call to the accrueRewards function, indicated by the difference of the current
980      * block time and the last activity time. In other words, up till the time of
981      * User B's deposit, the contract has had a 60 second accrual period for the total
982      * amount of 1000 'stakedToken' tokens at the set reward speed. Assuming a reward speed of
983      * 5 tokens per second (denoted 5 T/s), the accrueRewards function calculates the
984      * accrued reward per supplied unit of 'stakedToken' tokens for the elapsed time period.
985      * This works out to ((5 T/s) / 1000 'stakedToken') * 60 s = 0.3 T/'stakedToken' during the 60 second
986      * period. At this point, the global reward index variable is updated, increasing
987      * its value by 0.3 T/'stakedToken', and the reward accrual block timestamp,
988      * initialised in the previous step, is updated.
989      *
990      * After 90 seconds of the contract deployment, User A decides to claim their accrued
991      * rewards. Claiming affects token balances, thus requiring an invocation of the
992      * accrueRewards function. This time, the accrual period is 30 seconds (90 s - 60 s),
993      * for which the reward accrued per unit of 'stakedToken' is ((5 T/s) / 1500 'stakedToken') * 30 s = 0.1 T/'stakedToken'.
994      * The reward index is updated to 0.4 T/'stakedToken' (0.3 T/'stakedToken' + 0.1 T/'stakedToken') and the reward
995      * accrual block timestamp is set to the current block time.
996      *
997      * After the reward accrual, User A's rewards are claimed by transferring the correct
998      * amount of T tokens from the contract to User A. Because User A has not claimed any
999      * rewards yet, their supplier index is zero, the initial value determined by the
1000      * global reward index at the time of the user's first deposit. The amount of accrued
1001      * rewards is determined by the difference between the global reward index and the
1002      * user's own supplier index; essentially, this value represents the amount of
1003      * T tokens that have been accrued per supplied 'stakedToken' during the time since the user's
1004      * last claim. User A has a supply balance of 1000 'stakedToken', thus having an unclaimed
1005      * token amount of (0.4 T/'stakedToken' - 0 T/'stakedToken') * 1000 'stakedToken' = 400 T. This amount is
1006      * transferred to User A, and their supplier index is set to the current global reward
1007      * index to indicate that all previous rewards have been accrued.
1008      *
1009      * If User B was to claim their rewards at the same time, the calculation would take
1010      * the form of (0.4 T/'stakedToken' - 0.3 T/'stakedToken') * 500 'stakedToken' = 50 T. As expected, the total amount
1011      * of accrued reward (5 T/s * 90 s = 450 T) equals to the sum of the rewards paid
1012      * out to both User A and User B (400 T + 50 T = 450 T).
1013      *
1014      * This method of reward accrual is used to minimise the contract call complexity.
1015      * If a global mapping of users to their accrued rewards was implemented instead of
1016      * the index calculations, each function call invoking the accrueRewards function
1017      * would become immensely more expensive due to having to update the rewards for each
1018      * user. In contrast, the index approach allows the update of only a single user
1019      * while still keeping track of the other's rewards.
1020      *
1021      * Because rewards can be paid in multiple assets, reward indexes, reward supplier
1022      * indexes, and reward speeds depend on the StakingReward token.
1023      */
1024 
1025 contract EyeCohortFarming is AccessControl, ReentrancyGuard {
1026     using SafeERC20 for IERC20;
1027 
1028     bytes32 public constant SUB_ADMIN_ROLE = keccak256("SUB_ADMIN_ROLE");
1029     //contract address for token that users stake for rewards
1030     address public immutable stakedToken;
1031     //number of rewards tokens distributed to users
1032     uint256 public numberStakingRewards;
1033     // Sum of all supplied 'stakedToken' tokens
1034     uint256 public totalSupplies;
1035     //see explanation of accrualBlockTimestamp, rewardIndex, and supplierRewardIndex above
1036     uint256 public accrualBlockTimestamp;
1037     mapping(uint256 => uint256) public rewardIndex;
1038     mapping(address => mapping(uint256 => uint256)) public supplierRewardIndex; 
1039     // Supplied 'stakedToken' for each user
1040     mapping(address => uint256) public supplyAmount;
1041     // Addresses of the ERC20 reward tokens
1042     mapping(uint256 => address) public rewardTokenAddresses;
1043     // Reward accrual speeds per reward token as tokens per second
1044     mapping(uint256 => uint256) public rewardSpeeds;
1045     // Reward rewardPeriodFinishes per reward token as UTC timestamps
1046     mapping(uint256 => uint256) public rewardPeriodFinishes;
1047     // Total unclaimed amount of each reward token promised/accrued to users
1048     mapping(uint256 => uint256) public unwithdrawnAccruedRewards;    
1049     // Unclaimed staking rewards per user and token
1050     mapping(address => mapping(uint256 => uint256)) public accruedReward;
1051 
1052     //special mechanism for stakedToken to offer specific yearly multiplier. non-compounded value, where 1e18 is a multiplier of 1 (i.e. 100% APR)
1053     uint256 public stakedTokenYearlyReturn;
1054     uint256 public stakedTokenRewardIndex = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
1055 
1056     event RewardAdded(uint256 reward);
1057     event Staked(address indexed user, uint256 amount);
1058     event Withdrawn(address indexed user, uint256 amount);
1059     event RewardPaid(address indexed user, uint256 reward);
1060     event RewardsDurationUpdated(uint256 newDuration);
1061     event Recovered(address token, uint256 amount);
1062 
1063     modifier onlyAdmins() {
1064         require (hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(SUB_ADMIN_ROLE, msg.sender), "only admin");
1065         _;
1066     }
1067 
1068     constructor(
1069         address _stakedToken,
1070         uint256 _numberStakingRewards,
1071         address[] memory _rewardTokens,
1072         uint256[] memory _rewardPeriodFinishes,
1073         address masterAdmin,
1074         address[] memory subAdmins) 
1075         {
1076         require(_stakedToken != address(0));
1077         require(_rewardTokens.length == _numberStakingRewards, "bad _rewardTokens input");
1078         require(_rewardPeriodFinishes.length == _numberStakingRewards, "bad _rewardPeriodFinishes input");
1079         stakedToken = _stakedToken;
1080         numberStakingRewards = _numberStakingRewards;
1081         for (uint256 i = 0; i < _numberStakingRewards; i++) {
1082             require(_rewardTokens[i] != address(0));
1083             require(_rewardPeriodFinishes[i] > block.timestamp, "cannot set rewards to finish in past");
1084             if (_rewardTokens[i] == _stakedToken) {
1085                 stakedTokenRewardIndex = i;
1086             }
1087             rewardTokenAddresses[i] = _rewardTokens[i];
1088             rewardPeriodFinishes[i] = _rewardPeriodFinishes[i];
1089         }
1090         _grantRole(DEFAULT_ADMIN_ROLE, masterAdmin);
1091         for (uint256 i = 0; i < subAdmins.length; i++) {
1092             _grantRole(SUB_ADMIN_ROLE, subAdmins[i]);
1093         }
1094     }
1095 
1096      /*
1097      * Get the current amount of available rewards for claiming.
1098      *
1099      * @param rewardToken Reward token whose claimable balance to query
1100      * @return Balance of claimable reward tokens
1101      */
1102     function getClaimableRewards(uint256 rewardTokenIndex) external view returns(uint256) {
1103         return getUserClaimableRewards(msg.sender, rewardTokenIndex);
1104     }
1105 
1106      /*
1107      * Get the current amount of available rewards for claiming.
1108      *
1109      * @param user Address of user
1110      * @param rewardToken Reward token whose claimable balance to query
1111      * @return Balance of claimable reward tokens
1112      */
1113     function getUserClaimableRewards(address user, uint256 rewardTokenIndex) public view returns(uint256) {
1114         require(rewardTokenIndex <= numberStakingRewards, "Invalid reward token");
1115         uint256 rewardIndexToUse = rewardIndex[rewardTokenIndex];
1116         //imitate accrual logic without state update
1117         if (block.timestamp > accrualBlockTimestamp && totalSupplies != 0) {
1118             uint256 rewardSpeed = rewardSpeeds[rewardTokenIndex];
1119             if (rewardSpeed != 0 && accrualBlockTimestamp < rewardPeriodFinishes[rewardTokenIndex]) {
1120                 uint256 blockTimestampDelta = (min(block.timestamp, rewardPeriodFinishes[rewardTokenIndex]) - accrualBlockTimestamp);
1121                 uint256 accrued = (rewardSpeeds[rewardTokenIndex] * blockTimestampDelta);
1122                 IERC20 token = IERC20(rewardTokenAddresses[rewardTokenIndex]);
1123                 uint256 contractTokenBalance = token.balanceOf(address(this));
1124                 if (rewardTokenIndex == stakedTokenRewardIndex) {
1125                     contractTokenBalance = (contractTokenBalance > totalSupplies) ? (contractTokenBalance - totalSupplies) : 0;
1126                 }
1127                 uint256 remainingToDistribute = (contractTokenBalance > unwithdrawnAccruedRewards[rewardTokenIndex]) ? (contractTokenBalance - unwithdrawnAccruedRewards[rewardTokenIndex]) : 0;
1128                 if (accrued > remainingToDistribute) {
1129                     accrued = remainingToDistribute;
1130                 }
1131                 uint256 accruedPerStakedToken = (accrued * 1e36) / totalSupplies;
1132                 rewardIndexToUse += accruedPerStakedToken;
1133             }
1134         }
1135         uint256 rewardIndexDelta = rewardIndexToUse - (supplierRewardIndex[user][rewardTokenIndex]);
1136         uint256 claimableReward = ((rewardIndexDelta * supplyAmount[user]) / 1e36) + accruedReward[user][rewardTokenIndex];
1137         return claimableReward;
1138     }
1139 
1140     //returns fraction of total deposits that user controls, *multiplied by 1e18*
1141     function getUserDepositedFraction(address user) external view returns(uint256) {
1142         if (totalSupplies == 0) {
1143             return 0;
1144         } else {
1145             return (supplyAmount[user] * 1e18) / totalSupplies; 
1146         }
1147     }
1148 
1149     //returns amount of token left to distribute
1150     function getRemainingTokens(uint256 rewardTokenIndex) external view returns(uint256) {
1151         if (rewardPeriodFinishes[rewardTokenIndex] <= block.timestamp) {
1152             return 0;
1153         } else {
1154             uint256 amount = (rewardPeriodFinishes[rewardTokenIndex] - block.timestamp) * rewardSpeeds[rewardTokenIndex];
1155             uint256 bal = IERC20(rewardTokenAddresses[rewardTokenIndex]).balanceOf(address(this));
1156             uint256 totalOwed = unwithdrawnAccruedRewards[rewardTokenIndex];
1157             uint256 rewardSpeed = rewardSpeeds[rewardTokenIndex];
1158             if (rewardSpeed != 0 && accrualBlockTimestamp < rewardPeriodFinishes[rewardTokenIndex]) {
1159                 uint256 blockTimestampDelta = (min(block.timestamp, rewardPeriodFinishes[rewardTokenIndex]) - accrualBlockTimestamp);
1160                 uint256 accrued = (rewardSpeeds[rewardTokenIndex] * blockTimestampDelta);
1161                 uint256 remainingToDistribute = (bal > totalOwed) ? (bal - totalOwed) : 0;
1162                 if (accrued > remainingToDistribute) {
1163                     accrued = remainingToDistribute;
1164                 }
1165                 totalOwed += accrued;
1166             }
1167             if (rewardTokenIndex == stakedTokenRewardIndex) {
1168                 totalOwed += totalSupplies;
1169                 if (bal > totalOwed) {
1170                     return (bal - totalOwed);
1171                 } else {
1172                     return 0;
1173                 }
1174             }
1175             if (bal > totalOwed) {
1176                 bal -= totalOwed;
1177             } else {
1178                 bal = 0;
1179             }
1180             return min(amount, bal);
1181         }
1182     }
1183 
1184     function lastTimeRewardApplicable(uint256 rewardTokenIndex) public view returns (uint256) {
1185         return min(block.timestamp, rewardPeriodFinishes[rewardTokenIndex]);
1186     }
1187 
1188     function deposit(uint256 amount) external nonReentrant {
1189         IERC20 token = IERC20(stakedToken);
1190         uint256 contractBalance = token.balanceOf(address(this));
1191         token.safeTransferFrom(msg.sender, address(this), amount);
1192         uint256 depositedAmount = token.balanceOf(address(this)) - contractBalance;
1193         distributeReward(msg.sender);
1194         totalSupplies += depositedAmount;
1195         supplyAmount[msg.sender] += depositedAmount;
1196         autoUpdateStakedTokenRewardSpeed();
1197 
1198     }
1199 
1200     function withdraw(uint amount) public nonReentrant {
1201         require(amount <= supplyAmount[msg.sender], "Too large withdrawal");
1202         distributeReward(msg.sender);
1203         supplyAmount[msg.sender] -= amount;
1204         totalSupplies -= amount;
1205         IERC20 token = IERC20(stakedToken);
1206         autoUpdateStakedTokenRewardSpeed();
1207         token.safeTransfer(msg.sender, amount);
1208     }
1209 
1210     function exit() external {
1211         withdraw(supplyAmount[msg.sender]);
1212         claimRewards();
1213     }
1214 
1215     function claimRewards() public nonReentrant {
1216         distributeReward(msg.sender);
1217         for (uint256 i = 0; i < numberStakingRewards; i++) {
1218             uint256 amount = accruedReward[msg.sender][i];
1219             claimErc20(i, msg.sender, amount);
1220         }
1221     }
1222 
1223     function setRewardSpeed(uint256 rewardTokenIndex, uint256 speed) external onlyAdmins {
1224         if (accrualBlockTimestamp != 0) {
1225             accrueReward();
1226         }
1227         rewardSpeeds[rewardTokenIndex] = speed;
1228     }
1229 
1230     function setRewardPeriodFinish(uint256 rewardTokenIndex, uint256 rewardPeriodFinish) external onlyAdmins {
1231         require(rewardPeriodFinish > block.timestamp, "cannot set rewards to finish in past");
1232         rewardPeriodFinishes[rewardTokenIndex] = rewardPeriodFinish;
1233     }
1234 
1235     function setStakedTokenYearlyReturn(uint256 _stakedTokenYearlyReturn) external onlyAdmins {
1236         stakedTokenYearlyReturn = _stakedTokenYearlyReturn;
1237         autoUpdateStakedTokenRewardSpeed();
1238     }
1239 
1240     function setStakedTokenRewardIndex(uint256 _stakedTokenRewardIndex) external onlyAdmins {
1241         require(rewardTokenAddresses[_stakedTokenRewardIndex] == stakedToken, "can only set for stakedToken");
1242         stakedTokenRewardIndex = _stakedTokenRewardIndex;
1243         autoUpdateStakedTokenRewardSpeed();
1244     }
1245 
1246     function addNewRewardToken(address rewardTokenAddress) external onlyAdmins {
1247         require(rewardTokenAddress != address(0), "Cannot set zero address");
1248         numberStakingRewards += 1;
1249         rewardTokenAddresses[numberStakingRewards - 1] = rewardTokenAddress;
1250     }
1251 
1252     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1253     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyRole(DEFAULT_ADMIN_ROLE) nonReentrant {
1254         require(tokenAddress != address(stakedToken), "Cannot withdraw the staked token");
1255         IERC20(tokenAddress).safeTransfer(msg.sender, tokenAmount);
1256         emit Recovered(tokenAddress, tokenAmount);
1257     }
1258 
1259     /**
1260      * Update reward accrual state.
1261      *
1262      * @dev accrueReward() must be called every time the token balances
1263      *      or reward speeds change
1264      */
1265     function accrueReward() internal {
1266         if (block.timestamp == accrualBlockTimestamp) {
1267             return;
1268         } else if (totalSupplies == 0) {
1269             accrualBlockTimestamp = block.timestamp;
1270             return;
1271         }
1272         for (uint256 i = 0; i < numberStakingRewards; i += 1) {
1273             uint256 rewardSpeed = rewardSpeeds[i];
1274             if (rewardSpeed == 0 || accrualBlockTimestamp >= rewardPeriodFinishes[i]) {
1275                 continue;
1276             }
1277             uint256 blockTimestampDelta = (min(block.timestamp, rewardPeriodFinishes[i]) - accrualBlockTimestamp);
1278             uint256 accrued = (rewardSpeeds[i] * blockTimestampDelta);
1279 
1280             IERC20 token = IERC20(rewardTokenAddresses[i]);
1281             uint256 contractTokenBalance = token.balanceOf(address(this));
1282             if (i == stakedTokenRewardIndex) {
1283                 contractTokenBalance = (contractTokenBalance > totalSupplies) ? (contractTokenBalance - totalSupplies) : 0;
1284             }
1285             uint256 remainingToDistribute = (contractTokenBalance > unwithdrawnAccruedRewards[i]) ? (contractTokenBalance - unwithdrawnAccruedRewards[i]) : 0;
1286             if (accrued > remainingToDistribute) {
1287                 accrued = remainingToDistribute;
1288                 rewardSpeeds[i] = 0;
1289             }
1290             unwithdrawnAccruedRewards[i] += accrued;
1291 
1292             uint256 accruedPerStakedToken = (accrued * 1e36) / totalSupplies;
1293             rewardIndex[i] += accruedPerStakedToken;
1294         }
1295         accrualBlockTimestamp = block.timestamp;
1296     }
1297 
1298     /**
1299      * Calculate accrued rewards for a single account based on the reward indexes.
1300      *
1301      * @param recipient Account for which to calculate accrued rewards
1302      */
1303     function distributeReward(address recipient) internal {
1304         accrueReward();
1305         for (uint256 i = 0; i < numberStakingRewards; i += 1) {
1306             uint256 rewardIndexDelta = (rewardIndex[i] - supplierRewardIndex[recipient][i]);
1307             uint256 accruedAmount = (rewardIndexDelta * supplyAmount[recipient]) / 1e36;
1308             accruedReward[recipient][i] += accruedAmount;
1309             supplierRewardIndex[recipient][i] = rewardIndex[i];
1310         }
1311     }
1312 
1313     /**
1314      * Transfer ERC20 rewards from the contract to the reward recipient.
1315      *
1316      * @param rewardTokenIndex ERC20 reward token which is claimed
1317      * @param recipient Address, whose rewards are claimed
1318      * @param amount The amount of claimed reward
1319      */
1320     function claimErc20(uint256 rewardTokenIndex, address recipient, uint256 amount) internal {
1321         require(accruedReward[recipient][rewardTokenIndex] <= amount, "Not enough accrued rewards");
1322         IERC20 token = IERC20(rewardTokenAddresses[rewardTokenIndex]);
1323         accruedReward[recipient][rewardTokenIndex] -= amount;
1324         unwithdrawnAccruedRewards[rewardTokenIndex] -= min(unwithdrawnAccruedRewards[rewardTokenIndex], amount);
1325         token.safeTransfer(recipient, amount);
1326     }
1327 
1328     /**
1329      * @dev Returns the smallest of two numbers.
1330      */
1331     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1332         return a < b ? a : b;
1333     }
1334 
1335     //special mechanism for stakedToken to offer specific yearly multiplier. called within deposits and withdrawals to auto-update its reward speed
1336     function autoUpdateStakedTokenRewardSpeed() internal {
1337         if (rewardPeriodFinishes[stakedTokenRewardIndex] <= block.timestamp) {
1338             rewardSpeeds[stakedTokenRewardIndex] = 0;
1339         } else {
1340             //31536000 is the number of seconds in a year
1341             uint256 newRewardSpeed = totalSupplies * stakedTokenYearlyReturn / (31536000 * 1e18);
1342             rewardSpeeds[stakedTokenRewardIndex] = newRewardSpeed;
1343         }
1344     }
1345 }