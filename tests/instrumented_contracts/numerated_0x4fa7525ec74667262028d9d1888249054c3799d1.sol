1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/math/SafeMath.sol
99 
100 
101 
102 pragma solidity >=0.6.0 <0.8.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         uint256 c = a + b;
125         if (c < a) return (false, 0);
126         return (true, c);
127     }
128 
129     /**
130      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         if (b > a) return (false, 0);
136         return (true, a - b);
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) return (true, 0);
149         uint256 c = a * b;
150         if (c / a != b) return (false, 0);
151         return (true, c);
152     }
153 
154     /**
155      * @dev Returns the division of two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         if (b == 0) return (false, 0);
161         return (true, a / b);
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a % b);
172     }
173 
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      *
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187         return c;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b <= a, "SafeMath: subtraction overflow");
202         return a - b;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         if (a == 0) return 0;
217         uint256 c = a * b;
218         require(c / a == b, "SafeMath: multiplication overflow");
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers, reverting on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b > 0, "SafeMath: division by zero");
236         return a / b;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * reverting when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b > 0, "SafeMath: modulo by zero");
253         return a % b;
254     }
255 
256     /**
257      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
258      * overflow (when the result is negative).
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {trySub}.
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b <= a, errorMessage);
271         return a - b;
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryDiv}.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b > 0, errorMessage);
291         return a / b;
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * reverting with custom message when dividing by zero.
297      *
298      * CAUTION: This function is deprecated because it requires allocating memory for the error
299      * message unnecessarily. For custom revert reasons use {tryMod}.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         require(b > 0, errorMessage);
311         return a % b;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
316 
317 
318 
319 pragma solidity >=0.6.0 <0.8.0;
320 
321 /**
322  * @dev Interface of the ERC20 standard as defined in the EIP.
323  */
324 interface IERC20 {
325     /**
326      * @dev Returns the amount of tokens in existence.
327      */
328     function totalSupply() external view returns (uint256);
329 
330     /**
331      * @dev Returns the amount of tokens owned by `account`.
332      */
333     function balanceOf(address account) external view returns (uint256);
334 
335     /**
336      * @dev Moves `amount` tokens from the caller's account to `recipient`.
337      *
338      * Returns a boolean value indicating whether the operation succeeded.
339      *
340      * Emits a {Transfer} event.
341      */
342     function transfer(address recipient, uint256 amount) external returns (bool);
343 
344     /**
345      * @dev Returns the remaining number of tokens that `spender` will be
346      * allowed to spend on behalf of `owner` through {transferFrom}. This is
347      * zero by default.
348      *
349      * This value changes when {approve} or {transferFrom} are called.
350      */
351     function allowance(address owner, address spender) external view returns (uint256);
352 
353     /**
354      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
355      *
356      * Returns a boolean value indicating whether the operation succeeded.
357      *
358      * IMPORTANT: Beware that changing an allowance with this method brings the risk
359      * that someone may use both the old and the new allowance by unfortunate
360      * transaction ordering. One possible solution to mitigate this race
361      * condition is to first reduce the spender's allowance to 0 and set the
362      * desired value afterwards:
363      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
364      *
365      * Emits an {Approval} event.
366      */
367     function approve(address spender, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Moves `amount` tokens from `sender` to `recipient` using the
371      * allowance mechanism. `amount` is then deducted from the caller's
372      * allowance.
373      *
374      * Returns a boolean value indicating whether the operation succeeded.
375      *
376      * Emits a {Transfer} event.
377      */
378     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Emitted when `value` tokens are moved from one account (`from`) to
382      * another (`to`).
383      *
384      * Note that `value` may be zero.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 value);
387 
388     /**
389      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
390      * a call to {approve}. `value` is the new allowance.
391      */
392     event Approval(address indexed owner, address indexed spender, uint256 value);
393 }
394 
395 // File: @openzeppelin/contracts/utils/Address.sol
396 
397 
398 
399 pragma solidity >=0.6.2 <0.8.0;
400 
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * [IMPORTANT]
409      * ====
410      * It is unsafe to assume that an address for which this function returns
411      * false is an externally-owned account (EOA) and not a contract.
412      *
413      * Among others, `isContract` will return false for the following
414      * types of addresses:
415      *
416      *  - an externally-owned account
417      *  - a contract in construction
418      *  - an address where a contract will be created
419      *  - an address where a contract lived, but was destroyed
420      * ====
421      */
422     function isContract(address account) internal view returns (bool) {
423         // This method relies on extcodesize, which returns 0 for contracts in
424         // construction, since the code is only stored at the end of the
425         // constructor execution.
426 
427         uint256 size;
428         // solhint-disable-next-line no-inline-assembly
429         assembly { size := extcodesize(account) }
430         return size > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
453         (bool success, ) = recipient.call{ value: amount }("");
454         require(success, "Address: unable to send value, recipient may have reverted");
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain`call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
476       return functionCall(target, data, "Address: low-level call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
481      * `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, 0, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but also transferring `value` wei to `target`.
492      *
493      * Requirements:
494      *
495      * - the calling contract must have an ETH balance of at least `value`.
496      * - the called Solidity function must be `payable`.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
501         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
506      * with `errorMessage` as a fallback revert reason when `target` reverts.
507      *
508      * _Available since v3.1._
509      */
510     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
511         require(address(this).balance >= value, "Address: insufficient balance for call");
512         require(isContract(target), "Address: call to non-contract");
513 
514         // solhint-disable-next-line avoid-low-level-calls
515         (bool success, bytes memory returndata) = target.call{ value: value }(data);
516         return _verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
526         return functionStaticCall(target, data, "Address: low-level static call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
531      * but performing a static call.
532      *
533      * _Available since v3.3._
534      */
535     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
536         require(isContract(target), "Address: static call to non-contract");
537 
538         // solhint-disable-next-line avoid-low-level-calls
539         (bool success, bytes memory returndata) = target.staticcall(data);
540         return _verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but performing a delegate call.
546      *
547      * _Available since v3.4._
548      */
549     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
550         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
555      * but performing a delegate call.
556      *
557      * _Available since v3.4._
558      */
559     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
560         require(isContract(target), "Address: delegate call to non-contract");
561 
562         // solhint-disable-next-line avoid-low-level-calls
563         (bool success, bytes memory returndata) = target.delegatecall(data);
564         return _verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
568         if (success) {
569             return returndata;
570         } else {
571             // Look for revert reason and bubble it up if present
572             if (returndata.length > 0) {
573                 // The easiest way to bubble the revert reason is using memory via assembly
574 
575                 // solhint-disable-next-line no-inline-assembly
576                 assembly {
577                     let returndata_size := mload(returndata)
578                     revert(add(32, returndata), returndata_size)
579                 }
580             } else {
581                 revert(errorMessage);
582             }
583         }
584     }
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
588 
589 
590 
591 pragma solidity >=0.6.0 <0.8.0;
592 
593 
594 
595 
596 /**
597  * @title SafeERC20
598  * @dev Wrappers around ERC20 operations that throw on failure (when the token
599  * contract returns false). Tokens that return no value (and instead revert or
600  * throw on failure) are also supported, non-reverting calls are assumed to be
601  * successful.
602  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
603  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
604  */
605 library SafeERC20 {
606     using SafeMath for uint256;
607     using Address for address;
608 
609     function safeTransfer(IERC20 token, address to, uint256 value) internal {
610         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
611     }
612 
613     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
614         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
615     }
616 
617     /**
618      * @dev Deprecated. This function has issues similar to the ones found in
619      * {IERC20-approve}, and its usage is discouraged.
620      *
621      * Whenever possible, use {safeIncreaseAllowance} and
622      * {safeDecreaseAllowance} instead.
623      */
624     function safeApprove(IERC20 token, address spender, uint256 value) internal {
625         // safeApprove should only be called when setting an initial allowance,
626         // or when resetting it to zero. To increase and decrease it, use
627         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
628         // solhint-disable-next-line max-line-length
629         require((value == 0) || (token.allowance(address(this), spender) == 0),
630             "SafeERC20: approve from non-zero to non-zero allowance"
631         );
632         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
633     }
634 
635     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
636         uint256 newAllowance = token.allowance(address(this), spender).add(value);
637         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
638     }
639 
640     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
641         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
642         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
643     }
644 
645     /**
646      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
647      * on the return value: the return value is optional (but if data is returned, it must not be false).
648      * @param token The token targeted by the call.
649      * @param data The call data (encoded using abi.encode or one of its variants).
650      */
651     function _callOptionalReturn(IERC20 token, bytes memory data) private {
652         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
653         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
654         // the target address contains contract code and also asserts for success in the low-level call.
655 
656         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
657         if (returndata.length > 0) { // Return data is optional
658             // solhint-disable-next-line max-line-length
659             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
660         }
661     }
662 }
663 
664 // File: contracts/Ignition.sol
665 
666 
667 pragma solidity 0.6.11;
668 pragma experimental ABIEncoderV2;
669 
670 
671 
672 
673 
674 struct Whitelist {
675     address wallet;
676     uint256 amount;
677     uint256 rewardedAmount;
678     uint256 tier;
679     bool whitelist;
680     bool redeemed;
681 }
682 
683 struct Tier {
684     uint256 paidAmount;
685     uint256 maxPayableAmount;
686 }
687 
688 contract Ignition is Ownable {
689     using SafeMath for uint256;
690     using SafeERC20 for IERC20;
691 
692     mapping(address => Whitelist) public whitelist;
693     mapping(uint256 => Tier) public tiers;
694     IERC20 private _token;
695     IERC20 private _paidToken;
696     bool public isFinalized;
697     uint256 public soldAmount;
698     uint256 public totalRaise;
699 
700     constructor() public {
701         // Tiers
702         tiers[1] = Tier(0, 122357685775674000);
703         tiers[2] = Tier(0, 244715371551349000);
704         tiers[3] = Tier(0, 367073057327023000);
705         tiers[4] = Tier(0, 489430743102697000);
706         tiers[5] = Tier(0, 611788428878372000);
707         tiers[6] = Tier(0, 734146114654046000);
708         tiers[7] = Tier(0, 856503800429720000);
709         tiers[8] = Tier(0, 978861486205394000);
710         tiers[9] = Tier(0, 1101219171981070000);
711         tiers[10] = Tier(0, 1223576857756740000);
712         tiers[11] = Tier(0, 1345934543532420000);
713         tiers[12] = Tier(0, 1468292229308090000);
714         tiers[13] = Tier(0, 1590649915083770000);
715         tiers[14] = Tier(0, 1713007600859440000);
716         tiers[15] = Tier(0, 1835365286635110000);
717         tiers[16] = Tier(0, 1957722972410790000);
718         tiers[17] = Tier(0, 2080080658186460000);
719         tiers[18] = Tier(0, 2202438343962140000);
720         tiers[19] = Tier(0, 2324796029737810000);
721         tiers[20] = Tier(0, 2447153715513490000);
722         tiers[21] = Tier(0, 2569511401289160000);
723         tiers[22] = Tier(0, 2691869087064840000);
724         tiers[23] = Tier(0, 2814226772840510000);
725         tiers[73] = Tier(0, 8932111061624230000);
726     }
727 
728     /**
729      * Crowdsale Token
730      */
731     function setTokenAddress(IERC20 token) external onlyOwner returns (bool) {
732         _token = token;
733         return true;
734     }
735 
736     /**
737      * Crowdsale Token
738      */
739     function setPAIDTokenAddress(IERC20 token)
740         external
741         onlyOwner
742         returns (bool)
743     {
744         _paidToken = token;
745         return true;
746     }
747 
748     /**
749      * Add Whitelist
750      *
751      * @param {address[]}
752      * @return {bool}
753      */
754     function addWhitelist(address[] memory addresses, uint256 tier)
755         external
756         onlyOwner
757         returns (bool)
758     {
759         uint256 addressesLength = addresses.length;
760 
761         for (uint256 i = 0; i < addressesLength; i++) {
762             address address_ = addresses[i];
763             Whitelist memory whitelist_ =
764                 Whitelist(address_, 0, 0, tier, true, false);
765             whitelist[address_] = whitelist_;
766         }
767 
768         return true;
769     }
770 
771     /**
772      * Get Contract Address
773      *
774      * Crowdsale token
775      * @return {address} address
776      */
777     function getContractAddress() public view returns (address) {
778         return address(this);
779     }
780 
781     /**
782      * Get Total Token
783      *
784      * @return {uint256} totalToken
785      */
786     function getTotalToken() public view returns (uint256) {
787         return _token.balanceOf(getContractAddress());
788     }
789 
790     /**
791      * Get Start Time
792      *
793      * @return {uint256} timestamp
794      */
795     function getStartTime() public pure returns (uint256) {
796         return 1617627540; // DEEPER TIMESTAMP GALAXY
797     }
798 
799     /**
800      * Is Sale Start
801      */
802     function isStart() public view returns (bool) {
803         uint256 startTime = getStartTime();
804         uint256 timestamp = block.timestamp;
805 
806         return timestamp > startTime;
807     }
808 
809     function muldiv(uint256 x, uint256 yPercentage)
810         internal
811         pure
812         returns (uint256 c)
813     {
814         return x.mul(yPercentage).div(10e10);
815     }
816 
817     /**
818      * Get Rate
819      *
820      * 1 Ether = ? Token
821      * Example: 1 Ether = 30 Token
822      * @return {uint256} rate
823      */
824     function getRate() public view returns (uint256) {
825         return 170265833300000000000000;
826     }
827 
828     /**
829      * Calculate Token
830      */
831     function calculateAmount(uint256 amount) public view returns (uint256) {
832         uint256 rate = getRate();
833         uint256 oneEther = 1 ether;
834         uint256 rate_30perct = rate * 3 / 10;
835 
836         uint256 etherMul = muldiv(amount, rate_30perct).div(10e6);
837 
838         return etherMul;
839     }
840 
841     /**
842      * Finalize to sale
843      *
844      * @return {uint256} timestamp
845      */
846     function finalize() external onlyOwner returns (bool) {
847         isFinalized = true;
848         return isFinalized;
849     }
850 
851     /**
852      * Redeem Rewarded Tokens
853      */
854     function redeemTokens() external returns (bool) {
855         require(whitelist[_msgSender()].whitelist, "Sender isn't in whitelist");
856 
857         Whitelist memory whitelistWallet = whitelist[_msgSender()];
858 
859         require(isFinalized, "Sale isn't finalized yet");
860         require(!whitelistWallet.redeemed, "Redeemed before");
861         require(whitelistWallet.rewardedAmount > 0, "No token");
862 
863         whitelist[_msgSender()].redeemed = true;
864         _token.safeTransfer(
865             whitelistWallet.wallet,
866             whitelistWallet.rewardedAmount
867         );
868     }
869 
870     /**
871      * Get whitelist wallet
872      */
873     function getWhitelist(address _address)
874         public
875         view
876         returns (
877             address,
878             uint256,
879             uint256,
880             bool,
881             bool,
882             uint256
883         )
884     {
885         if (whitelist[_address].whitelist) {
886             Whitelist memory whitelistWallet = whitelist[_address];
887             return (
888                 whitelistWallet.wallet,
889                 whitelistWallet.amount,
890                 whitelistWallet.rewardedAmount,
891                 whitelistWallet.redeemed,
892                 true,
893                 whitelistWallet.tier
894             );
895         }
896 
897         return (address(0), 0, 0, false, false, 0);
898     }
899 
900     /**
901      * PAID Token Control
902      */
903     function controlPAIDTokens() public view returns (bool) {
904         address sender = _msgSender();
905         uint256 tier = whitelist[sender].tier;
906 
907         return _paidToken.balanceOf(sender) >= tiers[tier].paidAmount;
908     }
909 
910     /**
911      * Revert receive ether without buyTokens
912      */
913     fallback() external {
914         revert();
915     }
916 
917     function withdraw() external onlyOwner {
918         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
919         (bool success, ) = _msgSender().call{value: address(this).balance}("");
920         require(
921             success,
922             "Address: unable to send value, recipient may have reverted"
923         );
924     }
925 
926     /**
927      * buyTokens
928      */
929     function buyTokens() external payable {
930         address sender = _msgSender();
931         uint256 value = msg.value;
932 
933         require(isStart(), "Sale isn't started yet");
934         require(!isFinalized, "Sale is finished");
935         require(whitelist[sender].whitelist, "You're not in whitelist");
936 
937         uint256 tier = whitelist[sender].tier;
938 
939         require(
940             value <= tiers[tier].maxPayableAmount,
941             "You can't send ether more than max payable amount"
942         );
943         // Require removed because is not being use on DEEPER pools
944         //require(controlPAIDTokens(), "You dont have enough paid token");
945 
946         uint256 totalToken = getTotalToken();
947         uint256 rewardedAmount = calculateAmount(value);
948 
949         require(
950             soldAmount.add(rewardedAmount) <= totalToken,
951             "Insufficient token"
952         );
953 
954         whitelist[sender].amount = value;
955         whitelist[sender].rewardedAmount = rewardedAmount;
956         soldAmount = soldAmount.add(rewardedAmount);
957         totalRaise = totalRaise.add(value);
958     }
959 }