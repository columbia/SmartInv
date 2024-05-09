1 pragma solidity >=0.8.2 < 0.9.0;
2 pragma abicoder v2;
3 pragma experimental ABIEncoderV2;
4 
5 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
6 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
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
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Address.sol
231 
232 
233 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      *
256      * [IMPORTANT]
257      * ====
258      * You shouldn't rely on `isContract` to protect against flash loan attacks!
259      *
260      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
261      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
262      * constructor.
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize/address.code.length, which returns 0
267         // for contracts in construction, since the code is only stored at the end
268         // of the constructor execution.
269 
270         return account.code.length > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
454 
455 
456 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
457 
458 /**
459  * @dev Interface of the ERC20 standard as defined in the EIP.
460  */
461 interface IERC20 {
462     /**
463      * @dev Emitted when `value` tokens are moved from one account (`from`) to
464      * another (`to`).
465      *
466      * Note that `value` may be zero.
467      */
468     event Transfer(address indexed from, address indexed to, uint256 value);
469 
470     /**
471      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
472      * a call to {approve}. `value` is the new allowance.
473      */
474     event Approval(address indexed owner, address indexed spender, uint256 value);
475 
476     /**
477      * @dev Returns the amount of tokens in existence.
478      */
479     function totalSupply() external view returns (uint256);
480 
481     /**
482      * @dev Returns the amount of tokens owned by `account`.
483      */
484     function balanceOf(address account) external view returns (uint256);
485 
486     /**
487      * @dev Moves `amount` tokens from the caller's account to `to`.
488      *
489      * Returns a boolean value indicating whether the operation succeeded.
490      *
491      * Emits a {Transfer} event.
492      */
493     function transfer(address to, uint256 amount) external returns (bool);
494 
495     /**
496      * @dev Returns the remaining number of tokens that `spender` will be
497      * allowed to spend on behalf of `owner` through {transferFrom}. This is
498      * zero by default.
499      *
500      * This value changes when {approve} or {transferFrom} are called.
501      */
502     function allowance(address owner, address spender) external view returns (uint256);
503 
504     /**
505      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
506      *
507      * Returns a boolean value indicating whether the operation succeeded.
508      *
509      * IMPORTANT: Beware that changing an allowance with this method brings the risk
510      * that someone may use both the old and the new allowance by unfortunate
511      * transaction ordering. One possible solution to mitigate this race
512      * condition is to first reduce the spender's allowance to 0 and set the
513      * desired value afterwards:
514      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
515      *
516      * Emits an {Approval} event.
517      */
518     function approve(address spender, uint256 amount) external returns (bool);
519 
520     /**
521      * @dev Moves `amount` tokens from `from` to `to` using the
522      * allowance mechanism. `amount` is then deducted from the caller's
523      * allowance.
524      *
525      * Returns a boolean value indicating whether the operation succeeded.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 amount
533     ) external returns (bool);
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
540 
541 /**
542  * @title SafeERC20
543  * @dev Wrappers around ERC20 operations that throw on failure (when the token
544  * contract returns false). Tokens that return no value (and instead revert or
545  * throw on failure) are also supported, non-reverting calls are assumed to be
546  * successful.
547  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
548  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
549  */
550 library SafeERC20 {
551     using Address for address;
552 
553     function safeTransfer(
554         IERC20 token,
555         address to,
556         uint256 value
557     ) internal {
558         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
559     }
560 
561     function safeTransferFrom(
562         IERC20 token,
563         address from,
564         address to,
565         uint256 value
566     ) internal {
567         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
568     }
569 
570     /**
571      * @dev Deprecated. This function has issues similar to the ones found in
572      * {IERC20-approve}, and its usage is discouraged.
573      *
574      * Whenever possible, use {safeIncreaseAllowance} and
575      * {safeDecreaseAllowance} instead.
576      */
577     function safeApprove(
578         IERC20 token,
579         address spender,
580         uint256 value
581     ) internal {
582         // safeApprove should only be called when setting an initial allowance,
583         // or when resetting it to zero. To increase and decrease it, use
584         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
585         require(
586             (value == 0) || (token.allowance(address(this), spender) == 0),
587             "SafeERC20: approve from non-zero to non-zero allowance"
588         );
589         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
590     }
591 
592     function safeIncreaseAllowance(
593         IERC20 token,
594         address spender,
595         uint256 value
596     ) internal {
597         uint256 newAllowance = token.allowance(address(this), spender) + value;
598         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
599     }
600 
601     function safeDecreaseAllowance(
602         IERC20 token,
603         address spender,
604         uint256 value
605     ) internal {
606         unchecked {
607             uint256 oldAllowance = token.allowance(address(this), spender);
608             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
609             uint256 newAllowance = oldAllowance - value;
610             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
611         }
612     }
613 
614     /**
615      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
616      * on the return value: the return value is optional (but if data is returned, it must not be false).
617      * @param token The token targeted by the call.
618      * @param data The call data (encoded using abi.encode or one of its variants).
619      */
620     function _callOptionalReturn(IERC20 token, bytes memory data) private {
621         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
622         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
623         // the target address contains contract code and also asserts for success in the low-level call.
624 
625         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
626         if (returndata.length > 0) {
627             // Return data is optional
628             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
629         }
630     }
631 }
632 
633 // File: @openzeppelin/contracts/utils/Context.sol
634 
635 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
636 
637 /**
638  * @dev Provides information about the current execution context, including the
639  * sender of the transaction and its data. While these are generally available
640  * via msg.sender and msg.data, they should not be accessed in such a direct
641  * manner, since when dealing with meta-transactions the account sending and
642  * paying for execution may not be the actual sender (as far as an application
643  * is concerned).
644  *
645  * This contract is only required for intermediate, library-like contracts.
646  */
647 abstract contract Context {
648     function _msgSender() internal view virtual returns (address) {
649         return msg.sender;
650     }
651 
652     function _msgData() internal view virtual returns (bytes calldata) {
653         return msg.data;
654     }
655 }
656 
657 // File: @openzeppelin/contracts/access/Ownable.sol
658 
659 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
660 
661 
662 /**
663  * @dev Contract module which provides a basic access control mechanism, where
664  * there is an account (an owner) that can be granted exclusive access to
665  * specific functions.
666  *
667  * By default, the owner account will be the one that deploys the contract. This
668  * can later be changed with {transferOwnership}.
669  *
670  * This module is used through inheritance. It will make available the modifier
671  * `onlyOwner`, which can be applied to your functions to restrict their use to
672  * the owner.
673  */
674 abstract contract Ownable is Context {
675     address private _owner;
676 
677     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
678 
679     /**
680      * @dev Initializes the contract setting the deployer as the initial owner.
681      */
682     constructor() {
683         _transferOwnership(_msgSender());
684     }
685 
686     /**
687      * @dev Returns the address of the current owner.
688      */
689     function owner() public view virtual returns (address) {
690         return _owner;
691     }
692 
693     /**
694      * @dev Throws if called by any account other than the owner.
695      */
696     modifier onlyOwner() {
697         require(owner() == _msgSender(), "Ownable: caller is not the owner");
698         _;
699     }
700 
701     /**
702      * @dev Leaves the contract without owner. It will not be possible to call
703      * `onlyOwner` functions anymore. Can only be called by the current owner.
704      *
705      * NOTE: Renouncing ownership will leave the contract without an owner,
706      * thereby removing any functionality that is only available to the owner.
707      */
708     function renounceOwnership() public virtual onlyOwner {
709         _transferOwnership(address(0));
710     }
711 
712     /**
713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
714      * Can only be called by the current owner.
715      */
716     function transferOwnership(address newOwner) public virtual onlyOwner {
717         require(newOwner != address(0), "Ownable: new owner is the zero address");
718         _transferOwnership(newOwner);
719     }
720 
721     /**
722      * @dev Transfers ownership of the contract to a new account (`newOwner`).
723      * Internal function without access restriction.
724      */
725     function _transferOwnership(address newOwner) internal virtual {
726         address oldOwner = _owner;
727         _owner = newOwner;
728         emit OwnershipTransferred(oldOwner, newOwner);
729     }
730 }
731 
732 // File: GabrielV2.sol
733 
734 /// @title Archangel Reward Staking Pool V2 (GabrielV2)
735 /// @notice Stake tokens to Earn Rewards.
736 contract GabrielV2 is Ownable {
737     using SafeERC20 for IERC20;
738     using SafeMath for uint;
739 
740     /* ========== STATE VARIABLES ========== */
741 
742     address public devaddr;
743     uint public devPercent;
744     
745     address public treasury;
746     uint public tPercent;
747     
748     PoolInfo[] public poolInfo;
749     mapping(uint => mapping(address => UserInfo)) public userInfo;
750 
751     /* ========== STRUCTS ========== */
752     struct ConstructorArgs {
753         uint devPercent;
754         uint tPercent;
755         address devaddr;
756         address treasury;
757     }
758     
759     struct ExtraArgs {
760         IERC20 stakeToken;
761         uint openTime;
762         uint waitPeriod;
763         uint lockDuration;
764     }
765 
766     struct PoolInfo {
767         bool canStake;
768         bool canUnstake;
769         IERC20 stakeToken;
770         uint lockDuration;
771         uint lockTime;
772         uint NORT;
773         uint openTime;
774         uint staked;
775         uint unlockTime;
776         uint unstaked;        
777         uint waitPeriod;
778         address[] harvestList;
779         address[] rewardTokens;
780         address[] stakeList;
781         uint[] rewardsInPool;
782     }
783 
784     struct UserInfo {
785         uint amount;
786         bool harvested;
787     }
788 
789     /* ========== EVENTS ========== */
790     event Harvest(uint pid, address user, uint amount);
791     event PercentsUpdated(uint dev, uint treasury);
792     event ReflectionsClaimed(uint pid, address token, uint amount);
793     event Stake(uint pid, address user, uint amount);
794     event Unstake(uint pid, address user, uint amount);
795 
796     /* ========== CONSTRUCTOR ========== */
797     constructor(
798         ConstructorArgs memory constructorArgs,
799         ExtraArgs memory extraArgs,
800         uint _NORT,
801         address[] memory _rewardTokens,
802         uint[] memory _rewardsInPool
803     ) {
804         devPercent = constructorArgs.devPercent;
805         tPercent = constructorArgs.tPercent;
806         devaddr = constructorArgs.devaddr;
807         treasury = constructorArgs.treasury;
808         createPool(extraArgs, _NORT, _rewardTokens, _rewardsInPool);
809     }
810 
811     /* ========== MUTATIVE FUNCTIONS ========== */
812 
813     function _changeNORT(uint _pid, uint _NORT) internal {
814         PoolInfo storage pool = poolInfo[_pid];
815         address[] memory rewardTokens = new address[](_NORT);
816         uint[] memory rewardsInPool = new uint[](_NORT);
817         pool.NORT = _NORT;
818         pool.rewardTokens = rewardTokens;
819         pool.rewardsInPool = rewardsInPool;
820     }
821 
822     function changeNORT(uint _pid, uint _NORT) external onlyOwner {
823         _changeNORT(_pid, _NORT);
824     }
825 
826     function changePercents(uint _devPercent, uint _tPercent) external onlyOwner {
827         require(_devPercent.add(_tPercent) == 100, "must sum up to 100%");
828         devPercent = _devPercent;
829         tPercent = _tPercent;
830         emit PercentsUpdated(_devPercent, _tPercent);
831     }
832 
833     function changeRewardTokens(uint _pid, address[] memory _rewardTokens) external onlyOwner {
834         PoolInfo storage pool = poolInfo[_pid];
835         uint NORT = pool.NORT;
836         require(_rewardTokens.length == NORT, "CRT: array length mismatch");
837         for (uint i = 0; i < NORT; i++) {
838             pool.rewardTokens[i] = _rewardTokens[i];
839         }
840     }
841 
842     /// @notice function to claim reflections
843     function claimReflection(uint _pid, address token, uint amount) external onlyOwner {
844         uint onePercent = amount.div(100);
845         uint devShare = devPercent.mul(onePercent);
846         uint tShare = amount.sub(devShare);
847         IERC20(token).safeTransfer(devaddr, devShare);
848         IERC20(token).safeTransfer(treasury, tShare);
849         emit ReflectionsClaimed(_pid, token, amount);
850     }
851 
852     /**
853      * @notice create a new pool
854      * @param extraArgs ["stakeToken", openTime, waitPeriod, lockDuration]
855      * @param _NORT specify the number of diffrent tokens the pool will give out as reward
856      * @param _rewardTokens an array containing the addresses of the different reward tokens
857      * @param _rewardsInPool an array of token balances for each unique reward token in the pool.
858      */
859     function createPool(ExtraArgs memory extraArgs, uint _NORT, address[] memory _rewardTokens, uint[] memory _rewardsInPool) public onlyOwner {
860         require(_rewardTokens.length == _NORT && _rewardTokens.length == _rewardsInPool.length, "CP: array length mismatch");
861         address[] memory rewardTokens = new address[](_NORT);
862         uint[] memory rewardsInPool = new uint[](_NORT);
863         address[] memory emptyList;
864         require(
865             extraArgs.openTime > block.timestamp,
866             "open time must be a future time"
867         );
868         uint _lockTime = extraArgs.openTime.add(extraArgs.waitPeriod);
869         uint _unlockTime = _lockTime.add(extraArgs.lockDuration);
870         
871         poolInfo.push(
872             PoolInfo({
873                 stakeToken: extraArgs.stakeToken,
874                 staked: 0,
875                 unstaked: 0,
876                 openTime: extraArgs.openTime,
877                 waitPeriod: extraArgs.waitPeriod,
878                 lockTime: _lockTime,
879                 lockDuration: extraArgs.lockDuration,
880                 unlockTime: _unlockTime,
881                 canStake: false,
882                 canUnstake: false,
883                 NORT: _NORT,
884                 rewardTokens: rewardTokens,
885                 rewardsInPool: rewardsInPool,
886                 stakeList: emptyList,
887                 harvestList: emptyList
888             })
889         );
890         uint _pid = poolInfo.length - 1;
891         PoolInfo storage pool = poolInfo[_pid];
892         for (uint i = 0; i < _NORT; i++) {
893             pool.rewardTokens[i] = _rewardTokens[i];
894             pool.rewardsInPool[i] = _rewardsInPool[i];
895         }
896     }
897 
898     /// @notice Update dev address by the previous dev.
899     function dev(address _devaddr) external {
900         require(msg.sender == devaddr, "dev: caller is not the current dev");
901         devaddr = _devaddr;
902     }
903 
904     /// @notice Harvest your earnings
905     /// @param _pid select the particular pool
906     function harvest(uint _pid) external {
907         PoolInfo storage pool = poolInfo[_pid];
908         UserInfo storage user = userInfo[_pid][msg.sender];
909         if (block.timestamp > pool.unlockTime && pool.canUnstake == false) {
910             pool.canUnstake = true;
911         }
912         require(pool.canUnstake == true, "pool is still locked");
913         require(user.amount > 0 && user.harvested == false, "Harvest: forbid withdraw");
914         pool.harvestList.push(msg.sender);
915         update(_pid);
916         uint NORT = pool.NORT;
917         for (uint i = 0; i < NORT; i++) {
918             uint reward = user.amount * pool.rewardsInPool[i];
919             uint lpSupply = pool.staked;
920             uint pending = reward.div(lpSupply);
921             if (pending > 0) {
922                 IERC20(pool.rewardTokens[i]).safeTransfer(msg.sender, pending);
923                 pool.rewardsInPool[i] = pool.rewardsInPool[i].sub(pending);
924                 emit Harvest(_pid, msg.sender, pending);
925             }
926         }
927         pool.staked = pool.staked.sub(user.amount);
928         user.harvested = true;
929     }
930 
931     function recoverERC20(address token, address recipient, uint amount) external onlyOwner {
932         IERC20(token).safeTransfer(recipient, amount);
933     }
934 
935     /**
936      * @notice sets user.harvested to false for all users
937      * @param _pid select the particular pool
938      * @param harvestList an array containing addresses of users for that particular pool.
939      */
940     function reset(uint _pid, address[] memory harvestList) external onlyOwner {
941         PoolInfo storage pool = poolInfo[_pid];
942         uint len = harvestList.length;
943         uint len2 = pool.harvestList.length;
944         uint staked;
945         for (uint i; i < len; i++) {
946             UserInfo storage user = userInfo[_pid][harvestList[i]];
947             user.harvested = false;
948             staked = staked.add(user.amount);
949         }
950         pool.staked = pool.staked.add(staked);
951 
952         address lastUser = harvestList[len-1];
953         address lastHarvester = pool.harvestList[len2-1];
954         if (lastHarvester == lastUser) {
955             address[] memory emptyList;
956             pool.harvestList = emptyList;
957         }
958     }
959 
960     /**
961      * @notice reset all the values of a particular pool
962      * @param _pid select the particular pool
963      * @param extraArgs ["stakeToken", openTime, waitPeriod, lockDuration]
964      * @param _NORT specify the number of diffrent tokens the pool will give out as reward
965      * @param _rewardTokens an array containing the addresses of the different reward tokens
966      * @param _rewardsInPool an array of token balances for each unique reward token in the pool.
967      */
968     function reuse(uint _pid, ExtraArgs memory extraArgs, uint _NORT, address[] memory _rewardTokens, uint[] memory _rewardsInPool) external onlyOwner {
969         require(
970             _rewardTokens.length == _NORT &&
971             _rewardTokens.length == _rewardsInPool.length,
972             "RP: array length mismatch"
973         );
974         PoolInfo storage pool = poolInfo[_pid];
975         pool.stakeToken = extraArgs.stakeToken;
976         pool.unstaked = 0;
977         _setTimeValues( _pid, extraArgs.openTime, extraArgs.waitPeriod, extraArgs.lockDuration);
978         _changeNORT(_pid, _NORT);
979         for (uint i = 0; i < _NORT; i++) {
980             pool.rewardTokens[i] = _rewardTokens[i];
981             pool.rewardsInPool[i] = _rewardsInPool[i];
982         }
983         pool.stakeList = pool.harvestList;
984     }
985 
986     /**
987      * @notice Set or modify the token balances of a particular pool
988      * @param _pid select the particular pool
989      * @param rewards array of token balances for each reward token in the pool
990      */
991     function setPoolRewards(uint _pid, uint[] memory rewards) external onlyOwner {
992         PoolInfo storage pool = poolInfo[_pid];
993         uint NORT = pool.NORT;
994         require(rewards.length == NORT, "SPR: array length mismatch");
995         for (uint i = 0; i < NORT; i++) {
996             pool.rewardsInPool[i] = rewards[i];
997         }
998     }
999 
1000     function _setTimeValues(
1001         uint _pid,
1002         uint _openTime,
1003         uint _waitPeriod,
1004         uint _lockDuration
1005     ) internal {
1006         PoolInfo storage pool = poolInfo[_pid];
1007         require(
1008             _openTime > block.timestamp,
1009             "open time must be a future time"
1010         );
1011         pool.openTime = _openTime;
1012         pool.waitPeriod = _waitPeriod;
1013         pool.lockTime = _openTime.add(_waitPeriod);
1014         pool.lockDuration = _lockDuration;
1015         pool.unlockTime = pool.lockTime.add(_lockDuration);
1016     }
1017 
1018     function setTimeValues(
1019         uint _pid,
1020         uint _openTime,
1021         uint _waitPeriod,
1022         uint _lockDuration
1023     ) external onlyOwner {
1024         _setTimeValues(_pid, _openTime, _waitPeriod, _lockDuration);
1025     }
1026 
1027     /// @notice Update treasury address.
1028     function setTreasury(address _treasury) external onlyOwner {
1029         treasury = _treasury;
1030     }
1031 
1032     /**
1033      * @notice stake ERC20 tokens to earn rewards
1034      * @param _pid select the particular pool
1035      * @param _amount amount of tokens to be deposited by user
1036      */
1037     function stake(uint _pid, uint _amount) external {
1038         PoolInfo storage pool = poolInfo[_pid];
1039         UserInfo storage user = userInfo[_pid][msg.sender];
1040         if (block.timestamp > pool.lockTime && pool.canStake == true) {
1041             pool.canStake = false;
1042         }
1043         if (
1044             block.timestamp > pool.openTime &&
1045             block.timestamp < pool.lockTime &&
1046             block.timestamp < pool.unlockTime &&
1047             pool.canStake == false
1048         ) {
1049             pool.canStake = true;
1050         }
1051         require(
1052             pool.canStake == true,
1053             "pool is not yet opened or is locked"
1054         );
1055         update(_pid);
1056         if (_amount == 0) {
1057             return;
1058         }
1059         pool.stakeToken.safeTransferFrom(
1060             msg.sender,
1061             address(this),
1062             _amount
1063         );
1064         pool.stakeList.push(msg.sender);
1065         user.amount = user.amount.add(_amount);
1066         pool.staked = pool.staked.add(_amount);
1067         emit Stake(_pid, msg.sender, _amount);
1068     }
1069 
1070     /// @notice Exit without caring about rewards. EMERGENCY ONLY.
1071     /// @param _pid select the particular pool
1072     function unstake(uint _pid) external {
1073         PoolInfo storage pool = poolInfo[_pid];
1074         UserInfo storage user = userInfo[_pid][msg.sender];
1075         require(user.amount > 0, "unstake: withdraw bad");
1076         pool.stakeToken.safeTransfer(msg.sender, user.amount);
1077         pool.unstaked = pool.unstaked.add(user.amount);
1078         if (pool.staked >= user.amount) {
1079             pool.staked = pool.staked.sub(user.amount);
1080         }
1081         emit Unstake(_pid, msg.sender, user.amount);
1082         user.amount = 0;
1083     }
1084 
1085     function update(uint _pid) public {
1086         PoolInfo storage pool = poolInfo[_pid];
1087         if (block.timestamp <= pool.openTime) {
1088             return;
1089         }
1090         if (
1091             block.timestamp > pool.openTime &&
1092             block.timestamp < pool.lockTime &&
1093             block.timestamp < pool.unlockTime
1094         ) {
1095             pool.canStake = true;
1096             pool.canUnstake = false;
1097         }
1098         if (
1099             block.timestamp > pool.lockTime &&
1100             block.timestamp < pool.unlockTime
1101         ) {
1102             pool.canStake = false;
1103             pool.canUnstake = false;
1104         }
1105         if (
1106             block.timestamp > pool.unlockTime &&
1107             pool.unlockTime > 0
1108         ) {
1109             pool.canStake = false;
1110             pool.canUnstake = true;
1111         }
1112     }
1113 
1114     /* ========== READ ONLY ========== */
1115 
1116     function harvesters(uint _pid) external view returns (address[] memory harvestList) {
1117         PoolInfo memory pool = poolInfo[_pid];
1118         harvestList = pool.harvestList;
1119     }
1120 
1121     function harvests(uint _pid) external view returns (uint) {
1122         PoolInfo memory pool = poolInfo[_pid];
1123         return pool.harvestList.length;
1124     }
1125 
1126     function poolLength() external view returns (uint) {
1127         return poolInfo.length;
1128     }
1129 
1130     function rewardInPool(uint _pid) external view returns (uint[] memory rewardsInPool) {
1131         PoolInfo memory pool = poolInfo[_pid];
1132         rewardsInPool = pool.rewardsInPool;
1133     }
1134 
1135     function stakers(uint _pid) external view returns (address[] memory stakeList) {
1136         PoolInfo memory pool = poolInfo[_pid];
1137         stakeList = pool.stakeList;
1138     }
1139 
1140     function stakes(uint _pid) external view returns (uint) {
1141         PoolInfo memory pool = poolInfo[_pid];
1142         return pool.stakeList.length;
1143     }
1144 
1145     function tokensInPool(uint _pid) external view returns (address[] memory rewardTokens) {
1146         PoolInfo memory pool = poolInfo[_pid];
1147         rewardTokens = pool.rewardTokens;
1148     }
1149 
1150     function unclaimedRewards(uint _pid, address _user)
1151         external
1152         view
1153         returns (uint[] memory unclaimedReward)
1154     {
1155         PoolInfo memory pool = poolInfo[_pid];
1156         UserInfo memory user = userInfo[_pid][_user];
1157         uint NORT = pool.NORT;
1158         if (block.timestamp > pool.lockTime && block.timestamp < pool.unlockTime && pool.staked != 0) {
1159             uint[] memory array = new uint[](NORT);
1160             for (uint i = 0; i < NORT; i++) {
1161                 uint blocks = block.timestamp.sub(pool.lockTime);
1162                 uint reward = blocks * user.amount * pool.rewardsInPool[i];
1163                 uint lpSupply = pool.staked * pool.lockDuration;
1164                 uint pending = reward.div(lpSupply);
1165                 array[i] = pending;
1166             }
1167             return array;
1168         } else if (block.timestamp > pool.unlockTime && user.harvested == false && pool.staked != 0) {
1169             uint[] memory array = new uint[](NORT);
1170             for (uint i = 0; i < NORT; i++) {                
1171                 uint reward = user.amount * pool.rewardsInPool[i];
1172                 uint lpSupply = pool.staked;
1173                 uint pending = reward.div(lpSupply);
1174                 array[i] = pending;
1175             }
1176             return array;
1177         } else {
1178             uint[] memory array = new uint[](NORT);
1179             for (uint i = 0; i < NORT; i++) {                
1180                 array[i] = 0;
1181             }
1182             return array;
1183         }        
1184     }
1185 }