1 // SPDX-License-Identifier: AGPL-3.0
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: Governable
8 
9 contract Governable {
10     address public governance;
11     address public pendingGovernance;
12 
13     constructor(address _governance) public {
14         require(
15             _governance != address(0),
16             "governable::should-not-be-zero-address"
17         );
18         governance = _governance;
19     }
20 
21     function setPendingGovernance(address _pendingGovernance)
22         external
23         onlyGovernance
24     {
25         pendingGovernance = _pendingGovernance;
26     }
27 
28     function acceptGovernance() external onlyPendingGovernance {
29         governance = msg.sender;
30         pendingGovernance = address(0);
31     }
32 
33     modifier onlyGovernance {
34         require(msg.sender == governance, "governable::only-governance");
35         _;
36     }
37 
38     modifier onlyPendingGovernance {
39         require(
40             msg.sender == pendingGovernance,
41             "governable::only-pending-governance"
42         );
43         _;
44     }
45 }
46 
47 // Part: IRegistry
48 
49 interface IRegistry {
50     function latestVault(address token) external view returns (address);
51 
52     function endorseVault(address vault) external;
53 }
54 
55 // Part: IVaultMigrator
56 
57 interface IVaultMigrator {
58     function migrateAll(address vaultFrom, address vaultTo) external;
59 
60     function migrateShares(
61         address vaultFrom,
62         address vaultTo,
63         uint256 shares
64     ) external;
65 
66     function migrateAllWithPermit(
67         address vaultFrom,
68         address vaultTo,
69         uint256 deadline,
70         bytes calldata signature
71     ) external;
72 
73     function migrateSharesWithPermit(
74         address vaultFrom,
75         address vaultTo,
76         uint256 shares,
77         uint256 deadline,
78         bytes calldata signature
79     ) external;
80 }
81 
82 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Address
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
107         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
108         // for accounts without code, i.e. `keccak256('')`
109         bytes32 codehash;
110         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
111         // solhint-disable-next-line no-inline-assembly
112         assembly { codehash := extcodehash(account) }
113         return (codehash != accountHash && codehash != 0x0);
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
136         (bool success, ) = recipient.call{ value: amount }("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain`call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159       return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
169         return _functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
194         require(address(this).balance >= value, "Address: insufficient balance for call");
195         return _functionCallWithValue(target, data, value, errorMessage);
196     }
197 
198     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
199         require(isContract(target), "Address: call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 // solhint-disable-next-line no-inline-assembly
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/IERC20
223 
224 /**
225  * @dev Interface of the ERC20 standard as defined in the EIP.
226  */
227 interface IERC20 {
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `recipient`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(address owner, address spender) external view returns (uint256);
255 
256     /**
257      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * IMPORTANT: Beware that changing an allowance with this method brings the risk
262      * that someone may use both the old and the new allowance by unfortunate
263      * transaction ordering. One possible solution to mitigate this race
264      * condition is to first reduce the spender's allowance to 0 and set the
265      * desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address spender, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Moves `amount` tokens from `sender` to `recipient` using the
274      * allowance mechanism. `amount` is then deducted from the caller's
275      * allowance.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Emitted when `value` tokens are moved from one account (`from`) to
285      * another (`to`).
286      *
287      * Note that `value` may be zero.
288      */
289     event Transfer(address indexed from, address indexed to, uint256 value);
290 
291     /**
292      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
293      * a call to {approve}. `value` is the new allowance.
294      */
295     event Approval(address indexed owner, address indexed spender, uint256 value);
296 }
297 
298 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeMath
299 
300 /**
301  * @dev Wrappers over Solidity's arithmetic operations with added overflow
302  * checks.
303  *
304  * Arithmetic operations in Solidity wrap on overflow. This can easily result
305  * in bugs, because programmers usually assume that an overflow raises an
306  * error, which is the standard behavior in high level programming languages.
307  * `SafeMath` restores this intuition by reverting the transaction when an
308  * operation overflows.
309  *
310  * Using this library instead of the unchecked operations eliminates an entire
311  * class of bugs, so it's recommended to use it always.
312  */
313 library SafeMath {
314     /**
315      * @dev Returns the addition of two unsigned integers, reverting on
316      * overflow.
317      *
318      * Counterpart to Solidity's `+` operator.
319      *
320      * Requirements:
321      *
322      * - Addition cannot overflow.
323      */
324     function add(uint256 a, uint256 b) internal pure returns (uint256) {
325         uint256 c = a + b;
326         require(c >= a, "SafeMath: addition overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the subtraction of two unsigned integers, reverting on
333      * overflow (when the result is negative).
334      *
335      * Counterpart to Solidity's `-` operator.
336      *
337      * Requirements:
338      *
339      * - Subtraction cannot overflow.
340      */
341     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
342         return sub(a, b, "SafeMath: subtraction overflow");
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
347      * overflow (when the result is negative).
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      *
353      * - Subtraction cannot overflow.
354      */
355     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         require(b <= a, errorMessage);
357         uint256 c = a - b;
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the multiplication of two unsigned integers, reverting on
364      * overflow.
365      *
366      * Counterpart to Solidity's `*` operator.
367      *
368      * Requirements:
369      *
370      * - Multiplication cannot overflow.
371      */
372     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
373         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
374         // benefit is lost if 'b' is also tested.
375         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
376         if (a == 0) {
377             return 0;
378         }
379 
380         uint256 c = a * b;
381         require(c / a == b, "SafeMath: multiplication overflow");
382 
383         return c;
384     }
385 
386     /**
387      * @dev Returns the integer division of two unsigned integers. Reverts on
388      * division by zero. The result is rounded towards zero.
389      *
390      * Counterpart to Solidity's `/` operator. Note: this function uses a
391      * `revert` opcode (which leaves remaining gas untouched) while Solidity
392      * uses an invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function div(uint256 a, uint256 b) internal pure returns (uint256) {
399         return div(a, b, "SafeMath: division by zero");
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator. Note: this function uses a
407      * `revert` opcode (which leaves remaining gas untouched) while Solidity
408      * uses an invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
415         require(b > 0, errorMessage);
416         uint256 c = a / b;
417         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
418 
419         return c;
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * Reverts when dividing by zero.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
435         return mod(a, b, "SafeMath: modulo by zero");
436     }
437 
438     /**
439      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
440      * Reverts with custom message when dividing by zero.
441      *
442      * Counterpart to Solidity's `%` operator. This function uses a `revert`
443      * opcode (which leaves remaining gas untouched) while Solidity uses an
444      * invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
451         require(b != 0, errorMessage);
452         return a % b;
453     }
454 }
455 
456 // Part: IChiToken
457 
458 interface IChiToken is IERC20 {
459     function mint(uint256 value) external;
460 
461     function computeAddress2(uint256 salt) external view returns (address);
462 
463     function free(uint256 value) external returns (uint256);
464 
465     function freeUpTo(uint256 value) external returns (uint256);
466 
467     function freeFrom(address from, uint256 value) external returns (uint256);
468 
469     function freeFromUpTo(address from, uint256 value)
470         external
471         returns (uint256);
472 }
473 
474 // Part: ITrustedVaultMigrator
475 
476 /**
477 
478 Based on https://github.com/emilianobonassi/yearn-vaults-swap
479 
480  */
481 
482 interface ITrustedVaultMigrator is IVaultMigrator {
483     function registry() external returns (address);
484 
485     function sweep(address _token) external;
486 
487     function setRegistry(address _registry) external;
488 }
489 
490 // Part: IVaultAPI
491 
492 interface IVaultAPI is IERC20 {
493     function deposit(uint256 _amount, address recipient)
494         external
495         returns (uint256 shares);
496 
497     function withdraw(uint256 _shares) external;
498 
499     function token() external view returns (address);
500 
501     function permit(
502         address owner,
503         address spender,
504         uint256 value,
505         uint256 deadline,
506         bytes calldata signature
507     ) external returns (bool);
508 }
509 
510 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeERC20
511 
512 /**
513  * @title SafeERC20
514  * @dev Wrappers around ERC20 operations that throw on failure (when the token
515  * contract returns false). Tokens that return no value (and instead revert or
516  * throw on failure) are also supported, non-reverting calls are assumed to be
517  * successful.
518  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
519  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
520  */
521 library SafeERC20 {
522     using SafeMath for uint256;
523     using Address for address;
524 
525     function safeTransfer(IERC20 token, address to, uint256 value) internal {
526         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
527     }
528 
529     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
530         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
531     }
532 
533     /**
534      * @dev Deprecated. This function has issues similar to the ones found in
535      * {IERC20-approve}, and its usage is discouraged.
536      *
537      * Whenever possible, use {safeIncreaseAllowance} and
538      * {safeDecreaseAllowance} instead.
539      */
540     function safeApprove(IERC20 token, address spender, uint256 value) internal {
541         // safeApprove should only be called when setting an initial allowance,
542         // or when resetting it to zero. To increase and decrease it, use
543         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
544         // solhint-disable-next-line max-line-length
545         require((value == 0) || (token.allowance(address(this), spender) == 0),
546             "SafeERC20: approve from non-zero to non-zero allowance"
547         );
548         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
549     }
550 
551     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
552         uint256 newAllowance = token.allowance(address(this), spender).add(value);
553         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
554     }
555 
556     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
557         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
558         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
559     }
560 
561     /**
562      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
563      * on the return value: the return value is optional (but if data is returned, it must not be false).
564      * @param token The token targeted by the call.
565      * @param data The call data (encoded using abi.encode or one of its variants).
566      */
567     function _callOptionalReturn(IERC20 token, bytes memory data) private {
568         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
569         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
570         // the target address contains contract code and also asserts for success in the low-level call.
571 
572         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
573         if (returndata.length > 0) { // Return data is optional
574             // solhint-disable-next-line max-line-length
575             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
576         }
577     }
578 }
579 
580 // Part: IGasBenefactor
581 
582 interface IGasBenefactor {
583     event ChiTokenSet(IChiToken _chiToken);
584     event Subsidized(uint256 _amount, address _subsidizor);
585 
586     function chiToken() external view returns (IChiToken);
587 
588     function setChiToken(IChiToken _chiToken) external;
589 
590     function subsidize(uint256 _amount) external;
591 }
592 
593 // Part: VaultMigrator
594 
595 contract VaultMigrator is IVaultMigrator {
596     using SafeMath for uint256;
597     using SafeERC20 for IERC20;
598     using SafeERC20 for IVaultAPI;
599 
600     modifier onlyCompatibleVaults(address vaultA, address vaultB) {
601         require(
602             IVaultAPI(vaultA).token() == IVaultAPI(vaultB).token(),
603             "Vaults must have the same token"
604         );
605         _;
606     }
607 
608     function migrateAll(address vaultFrom, address vaultTo) external override {
609         _migrate(
610             vaultFrom,
611             vaultTo,
612             IVaultAPI(vaultFrom).balanceOf(msg.sender)
613         );
614     }
615 
616     function migrateAllWithPermit(
617         address vaultFrom,
618         address vaultTo,
619         uint256 deadline,
620         bytes calldata signature
621     ) external override {
622         uint256 shares = IVaultAPI(vaultFrom).balanceOf(msg.sender);
623 
624         _permit(vaultFrom, shares, deadline, signature);
625         _migrate(vaultFrom, vaultTo, shares);
626     }
627 
628     function migrateShares(
629         address vaultFrom,
630         address vaultTo,
631         uint256 shares
632     ) external override {
633         _migrate(vaultFrom, vaultTo, shares);
634     }
635 
636     function migrateSharesWithPermit(
637         address vaultFrom,
638         address vaultTo,
639         uint256 shares,
640         uint256 deadline,
641         bytes calldata signature
642     ) external override {
643         _permit(vaultFrom, shares, deadline, signature);
644         _migrate(vaultFrom, vaultTo, shares);
645     }
646 
647     function _permit(
648         address vault,
649         uint256 value,
650         uint256 deadline,
651         bytes calldata signature
652     ) internal {
653         require(
654             IVaultAPI(vault).permit(
655                 msg.sender,
656                 address(this),
657                 value,
658                 deadline,
659                 signature
660             ),
661             "Unable to permit on vault"
662         );
663     }
664 
665     function _migrate(
666         address vaultFrom,
667         address vaultTo,
668         uint256 shares
669     ) internal virtual onlyCompatibleVaults(vaultFrom, vaultTo) {
670         // Transfer in vaultFrom shares
671         IVaultAPI vf = IVaultAPI(vaultFrom);
672 
673         uint256 preBalanceVaultFrom = vf.balanceOf(address(this));
674 
675         vf.safeTransferFrom(msg.sender, address(this), shares);
676 
677         uint256 balanceVaultFrom =
678             vf.balanceOf(address(this)).sub(preBalanceVaultFrom);
679 
680         // Withdraw token from vaultFrom
681         IERC20 token = IERC20(vf.token());
682 
683         uint256 preBalanceToken = token.balanceOf(address(this));
684 
685         vf.withdraw(balanceVaultFrom);
686 
687         uint256 balanceToken =
688             token.balanceOf(address(this)).sub(preBalanceToken);
689 
690         // Deposit new vault
691         token.safeIncreaseAllowance(vaultTo, balanceToken);
692 
693         IVaultAPI(vaultTo).deposit(balanceToken, msg.sender);
694     }
695 }
696 
697 // Part: GasBenefactor
698 
699 abstract contract GasBenefactor is IGasBenefactor {
700     using SafeERC20 for IChiToken;
701 
702     IChiToken public override chiToken;
703 
704     constructor(IChiToken _chiToken) public {
705         _setChiToken(_chiToken);
706     }
707 
708     modifier subsidizeUserTx {
709         uint256 _gasStart = gasleft();
710         _;
711         // NOTE: Per EIP-2028, gas cost is 16 per (non-empty) byte in calldata
712         uint256 _gasSpent =
713             21000 + _gasStart - gasleft() + 16 * msg.data.length;
714         // NOTE: 41947 is the estimated amount of gas refund realized per CHI redeemed
715         // NOTE: 14154 is the estimated cost of the call to `freeFromUpTo`
716         chiToken.freeUpTo((_gasSpent + 14154) / 41947);
717     }
718 
719     modifier discountUserTx {
720         uint256 _gasStart = gasleft();
721         _;
722         // NOTE: Per EIP-2028, gas cost is 16 per (non-empty) byte in calldata
723         uint256 _gasSpent =
724             21000 + _gasStart - gasleft() + 16 * msg.data.length;
725         // NOTE: 41947 is the estimated amount of gas refund realized per CHI redeemed
726         // NOTE: 14154 is the estimated cost of the call to `freeFromUpTo`
727         chiToken.freeFromUpTo(msg.sender, (_gasSpent + 14154) / 41947);
728     }
729 
730     function _subsidize(uint256 _amount) internal {
731         require(_amount > 0, "GasBenefactor::_subsidize::zero-amount");
732         chiToken.safeTransferFrom(msg.sender, address(this), _amount);
733         emit Subsidized(_amount, msg.sender);
734     }
735 
736     function _setChiToken(IChiToken _chiToken) internal {
737         require(
738             address(_chiToken) != address(0),
739             "GasBenefactor::_setChiToken::zero-address"
740         );
741         chiToken = _chiToken;
742         emit ChiTokenSet(_chiToken);
743     }
744 }
745 
746 // File: TrustedVaultMigrator.sol
747 
748 contract TrustedVaultMigrator is
749     VaultMigrator,
750     Governable,
751     GasBenefactor,
752     ITrustedVaultMigrator
753 {
754     address public override registry;
755 
756     modifier onlyLatestVault(address vault) {
757         require(
758             IRegistry(registry).latestVault(IVaultAPI(vault).token()) == vault,
759             "Target vault should be the latest for token"
760         );
761         _;
762     }
763 
764     constructor(address _registry, IChiToken _chiToken)
765         public
766         VaultMigrator()
767         Governable(address(0xFEB4acf3df3cDEA7399794D0869ef76A6EfAff52))
768         GasBenefactor(_chiToken)
769     {
770         require(_registry != address(0), "Registry cannot be 0");
771 
772         registry = _registry;
773     }
774 
775     function _migrate(
776         address vaultFrom,
777         address vaultTo,
778         uint256 shares
779     ) internal override onlyLatestVault(vaultTo) {
780         super._migrate(vaultFrom, vaultTo, shares);
781     }
782 
783     function sweep(address _token) external override onlyGovernance {
784         IERC20(_token).safeTransfer(
785             governance,
786             IERC20(_token).balanceOf(address(this))
787         );
788     }
789 
790     function subsidize(uint256 _amount) external override {
791         _subsidize(_amount);
792     }
793 
794     // setters
795     function setRegistry(address _registry) external override onlyGovernance {
796         require(_registry != address(0), "Registry cannot be 0");
797         registry = _registry;
798     }
799 
800     function setChiToken(IChiToken _chiToken) external override onlyGovernance {
801         _setChiToken(_chiToken);
802     }
803 }
