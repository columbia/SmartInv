1 pragma solidity ^0.6.11;
2 /*
3 A gauge to allow users to commit to Stacker.vc fund 1. This will reward STACK tokens for hard and soft commits, as well as link with a ibETH gateway, to allow users
4 to deposit ETH directly into the fund.
5 
6 ibETH is sent to the STACK DAO governance contract, for future VC fund initialization.
7 */
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
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         uint256 c = a + b;
104         if (c < a) return (false, 0);
105         return (true, c);
106     }
107 
108     /**
109      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         if (b > a) return (false, 0);
115         return (true, a - b);
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127         if (a == 0) return (true, 0);
128         uint256 c = a * b;
129         if (c / a != b) return (false, 0);
130         return (true, c);
131     }
132 
133     /**
134      * @dev Returns the division of two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b == 0) return (false, 0);
140         return (true, a / b);
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b == 0) return (false, 0);
150         return (true, a % b);
151     }
152 
153     /**
154      * @dev Returns the addition of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `+` operator.
158      *
159      * Requirements:
160      *
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166         return c;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b <= a, "SafeMath: subtraction overflow");
181         return a - b;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         if (a == 0) return 0;
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b > 0, "SafeMath: division by zero");
215         return a / b;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b > 0, "SafeMath: modulo by zero");
232         return a % b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {trySub}.
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b <= a, errorMessage);
250         return a - b;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * CAUTION: This function is deprecated because it requires allocating memory for the error
258      * message unnecessarily. For custom revert reasons use {tryDiv}.
259      *
260      * Counterpart to Solidity's `/` operator. Note: this function uses a
261      * `revert` opcode (which leaves remaining gas untouched) while Solidity
262      * uses an invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b > 0, errorMessage);
270         return a / b;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * reverting with custom message when dividing by zero.
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {tryMod}.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b > 0, errorMessage);
290         return a % b;
291     }
292 }
293 
294 /**
295  * @dev Collection of functions related to the address type
296  */
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * [IMPORTANT]
302      * ====
303      * It is unsafe to assume that an address for which this function returns
304      * false is an externally-owned account (EOA) and not a contract.
305      *
306      * Among others, `isContract` will return false for the following
307      * types of addresses:
308      *
309      *  - an externally-owned account
310      *  - a contract in construction
311      *  - an address where a contract will be created
312      *  - an address where a contract lived, but was destroyed
313      * ====
314      */
315     function isContract(address account) internal view returns (bool) {
316         // This method relies on extcodesize, which returns 0 for contracts in
317         // construction, since the code is only stored at the end of the
318         // constructor execution.
319 
320         uint256 size;
321         // solhint-disable-next-line no-inline-assembly
322         assembly { size := extcodesize(account) }
323         return size > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
346         (bool success, ) = recipient.call{ value: amount }("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 
350     /**
351      * @dev Performs a Solidity function call using a low level `call`. A
352      * plain`call` is an unsafe replacement for a function call: use this
353      * function instead.
354      *
355      * If `target` reverts with a revert reason, it is bubbled up by this
356      * function (like regular Solidity function calls).
357      *
358      * Returns the raw returned data. To convert to the expected return value,
359      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
360      *
361      * Requirements:
362      *
363      * - `target` must be a contract.
364      * - calling `target` with `data` must not revert.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
369       return functionCall(target, data, "Address: low-level call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
374      * `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
399      * with `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         // solhint-disable-next-line avoid-low-level-calls
408         (bool success, bytes memory returndata) = target.call{ value: value }(data);
409         return _verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
419         return functionStaticCall(target, data, "Address: low-level static call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
429         require(isContract(target), "Address: static call to non-contract");
430 
431         // solhint-disable-next-line avoid-low-level-calls
432         (bool success, bytes memory returndata) = target.staticcall(data);
433         return _verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
453         require(isContract(target), "Address: delegate call to non-contract");
454 
455         // solhint-disable-next-line avoid-low-level-calls
456         (bool success, bytes memory returndata) = target.delegatecall(data);
457         return _verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 // solhint-disable-next-line no-inline-assembly
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 /**
481  * @title SafeERC20
482  * @dev Wrappers around ERC20 operations that throw on failure (when the token
483  * contract returns false). Tokens that return no value (and instead revert or
484  * throw on failure) are also supported, non-reverting calls are assumed to be
485  * successful.
486  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
487  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
488  */
489 library SafeERC20 {
490     using SafeMath for uint256;
491     using Address for address;
492 
493     function safeTransfer(IERC20 token, address to, uint256 value) internal {
494         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
495     }
496 
497     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
498         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
499     }
500 
501     /**
502      * @dev Deprecated. This function has issues similar to the ones found in
503      * {IERC20-approve}, and its usage is discouraged.
504      *
505      * Whenever possible, use {safeIncreaseAllowance} and
506      * {safeDecreaseAllowance} instead.
507      */
508     function safeApprove(IERC20 token, address spender, uint256 value) internal {
509         // safeApprove should only be called when setting an initial allowance,
510         // or when resetting it to zero. To increase and decrease it, use
511         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
512         // solhint-disable-next-line max-line-length
513         require((value == 0) || (token.allowance(address(this), spender) == 0),
514             "SafeERC20: approve from non-zero to non-zero allowance"
515         );
516         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
517     }
518 
519     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
520         uint256 newAllowance = token.allowance(address(this), spender).add(value);
521         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
522     }
523 
524     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
525         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
526         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
527     }
528 
529     /**
530      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
531      * on the return value: the return value is optional (but if data is returned, it must not be false).
532      * @param token The token targeted by the call.
533      * @param data The call data (encoded using abi.encode or one of its variants).
534      */
535     function _callOptionalReturn(IERC20 token, bytes memory data) private {
536         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
537         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
538         // the target address contains contract code and also asserts for success in the low-level call.
539 
540         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
541         if (returndata.length > 0) { // Return data is optional
542             // solhint-disable-next-line max-line-length
543             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
544         }
545     }
546 }
547 
548 /**
549  * @dev Contract module that helps prevent reentrant calls to a function.
550  *
551  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
552  * available, which can be applied to functions to make sure there are no nested
553  * (reentrant) calls to them.
554  *
555  * Note that because there is a single `nonReentrant` guard, functions marked as
556  * `nonReentrant` may not call one another. This can be worked around by making
557  * those functions `private`, and then adding `external` `nonReentrant` entry
558  * points to them.
559  *
560  * TIP: If you would like to learn more about reentrancy and alternative ways
561  * to protect against it, check out our blog post
562  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
563  */
564 abstract contract ReentrancyGuard {
565     // Booleans are more expensive than uint256 or any type that takes up a full
566     // word because each write operation emits an extra SLOAD to first read the
567     // slot's contents, replace the bits taken up by the boolean, and then write
568     // back. This is the compiler's defense against contract upgrades and
569     // pointer aliasing, and it cannot be disabled.
570 
571     // The values being non-zero value makes deployment a bit more expensive,
572     // but in exchange the refund on every call to nonReentrant will be lower in
573     // amount. Since refunds are capped to a percentage of the total
574     // transaction's gas, it is best to keep them low in cases like this one, to
575     // increase the likelihood of the full refund coming into effect.
576     uint256 private constant _NOT_ENTERED = 1;
577     uint256 private constant _ENTERED = 2;
578 
579     uint256 private _status;
580 
581     constructor () internal {
582         _status = _NOT_ENTERED;
583     }
584 
585     /**
586      * @dev Prevents a contract from calling itself, directly or indirectly.
587      * Calling a `nonReentrant` function from another `nonReentrant`
588      * function is not supported. It is possible to prevent this from happening
589      * by making the `nonReentrant` function external, and make it call a
590      * `private` function that does the actual work.
591      */
592     modifier nonReentrant() {
593         // On the first call to nonReentrant, _notEntered will be true
594         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
595 
596         // Any calls to nonReentrant after this point will fail
597         _status = _ENTERED;
598 
599         _;
600 
601         // By storing the original value once again, a refund is triggered (see
602         // https://eips.ethereum.org/EIPS/eip-2200)
603         _status = _NOT_ENTERED;
604     }
605 }
606 
607 contract GaugeD1 is ReentrancyGuard {
608 	using SafeERC20 for IERC20;
609 	using Address for address;
610     using SafeMath for uint256;
611 
612     address payable public governance = 0xB156d2D9CAdB12a252A9015078fc5cb7E92e656e; // STACK DAO Agent address
613     address public constant acceptToken = 0xeEa3311250FE4c3268F8E684f7C87A82fF183Ec1; // AlphaHomora ibETHv2
614     address public vaultGaugeBridge; // the bridge address to allow people one transaction to do: (token <-> alphaHomora <-> commit)
615 
616     address public constant STACK = 0xe0955F26515d22E347B17669993FCeFcc73c3a0a; // STACK DAO Token
617 
618     uint256 public emissionRate = 127797160347097087; // 50k STACK total, div by delta block
619 
620     uint256 public depositedCommitSoft;
621     uint256 public depositedCommitHard;
622 
623     uint256 public constant commitSoftWeight = 1;
624     uint256 public constant commitHardWeight = 4;
625 
626     struct CommitState {
627     	uint256 balanceCommitSoft;
628     	uint256 balanceCommitHard;
629     	uint256 tokensAccrued;
630     }
631 
632     mapping(address => CommitState) public balances; // balance of acceptToken by user by commit
633 
634     event Deposit(address indexed from, uint256 amountCommitSoft, uint256 amountCommitHard);
635     event Withdraw(address indexed to, uint256 amount);
636     event Upgrade(address indexed user, uint256 amount);
637     event STACKClaimed(address indexed to, uint256 amount);
638 
639     bool public fundOpen = true;
640 
641     uint256 public constant startBlock = 11955015;
642     uint256 public endBlock = startBlock + 391245;
643 
644     uint256 public lastBlock; // last block the distribution has ran
645     uint256 public tokensAccrued; // tokens to distribute per weight scaled by 1e18
646 
647     constructor(address _vaultGaugeBridge) public {
648     	vaultGaugeBridge = _vaultGaugeBridge;
649     }
650 
651     function setGovernance(address payable _new) external {
652     	require(msg.sender == governance, "GAUGE: !governance");
653     	governance = _new;
654     }
655 
656     function setEmissionRate(uint256 _new) external {
657     	require(msg.sender == governance, "GAUGE: !governance");
658     	_kick(); // catch up the contract to the current block for old rate
659     	emissionRate = _new;
660     }
661 
662     function setEndBlock(uint256 _block) external {
663     	require(msg.sender == governance, "GAUGE: !governance");
664     	require(block.number <= endBlock, "GAUGE: distribution already done, must start another");
665         require(block.number <= _block, "GAUGE: can't set endBlock to past block");
666 
667     	endBlock = _block;
668     }
669 
670     function setFundOpen(bool _open) external {
671         require(msg.sender == governance, "GAUGE: !governance");
672         fundOpen = _open;
673     }
674 
675     function deposit(uint256 _amountCommitSoft, uint256 _amountCommitHard, address _creditTo) nonReentrant external {
676     	require(block.number <= endBlock, "GAUGE: distribution 1 over");
677     	require(fundOpen || _amountCommitHard == 0, "GAUGE: !fundOpen, only soft commit allowed"); // when the fund closes, soft commits are still accepted
678     	require(msg.sender == _creditTo || msg.sender == vaultGaugeBridge, "GAUGE: !bridge for creditTo"); // only the bridge contract can use the "creditTo" to credit !msg.sender
679 
680     	_claimSTACK(_creditTo); // new deposit doesn't get tokens right away
681 
682     	// transfer tokens from sender to account
683     	uint256 _acceptTokenAmount = _amountCommitSoft.add(_amountCommitHard);
684     	require(_acceptTokenAmount > 0, "GAUGE: !tokens");
685     	IERC20(acceptToken).safeTransferFrom(msg.sender, address(this), _acceptTokenAmount);
686 
687     	CommitState memory _state = balances[_creditTo];
688     	// no need to update _state.tokensAccrued because that's already done in _claimSTACK
689     	if (_amountCommitSoft > 0){
690     		_state.balanceCommitSoft = _state.balanceCommitSoft.add(_amountCommitSoft);
691 			depositedCommitSoft = depositedCommitSoft.add(_amountCommitSoft);
692     	}
693     	if (_amountCommitHard > 0){
694     		_state.balanceCommitHard = _state.balanceCommitHard.add(_amountCommitHard);
695 			depositedCommitHard = depositedCommitHard.add(_amountCommitHard);
696 
697             IERC20(acceptToken).safeTransfer(governance, _amountCommitHard); // transfer out any hard commits right away
698     	}
699 
700 		emit Deposit(_creditTo, _amountCommitSoft, _amountCommitHard);
701 		balances[_creditTo] = _state;
702     }
703 
704     function upgradeCommit(uint256 _amount) nonReentrant external {
705     	// upgrading from soft -> hard commit
706     	require(block.number <= endBlock, "GAUGE: distribution 1 over");
707     	require(fundOpen, "GAUGE: !fundOpen"); // soft commits cannot be upgraded after the fund closes. they can be deposited though
708 
709     	_claimSTACK(msg.sender);
710 
711     	CommitState memory _state = balances[msg.sender];
712 
713         require(_amount <= _state.balanceCommitSoft, "GAUGE: insufficient balance softCommit");
714         _state.balanceCommitSoft = _state.balanceCommitSoft.sub(_amount);
715         _state.balanceCommitHard = _state.balanceCommitHard.add(_amount);
716         depositedCommitSoft = depositedCommitSoft.sub(_amount);
717         depositedCommitHard = depositedCommitHard.add(_amount);
718 
719         IERC20(acceptToken).safeTransfer(governance, _amount);
720 
721     	emit Upgrade(msg.sender, _amount);
722     	balances[msg.sender] = _state;
723     }
724 
725     // withdraw funds that haven't been committed to VC fund (fund in commitSoft before deadline)
726     function withdraw(uint256 _amount, address _withdrawFor) nonReentrant external {
727         require(block.number <= endBlock, ">endblock");
728         require(msg.sender == _withdrawFor || msg.sender == vaultGaugeBridge, "GAUGE: !bridge for withdrawFor"); // only the bridge contract can use the "withdrawFor" to withdraw for !msg.sender 
729 
730     	_claimSTACK(_withdrawFor); // claim tokens from all blocks including this block on withdraw
731 
732     	CommitState memory _state = balances[_withdrawFor];
733 
734     	require(_amount <= _state.balanceCommitSoft, "GAUGE: insufficient balance softCommit");
735 
736     	// update globals & add amtToWithdraw to final tally.
737     	_state.balanceCommitSoft = _state.balanceCommitSoft.sub(_amount);
738     	depositedCommitSoft = depositedCommitSoft.sub(_amount);
739     	
740     	emit Withdraw(_withdrawFor, _amount);
741     	balances[_withdrawFor] = _state;
742 
743     	// IMPORTANT: send tokens to msg.sender, not _withdrawFor. This will send to msg.sender OR vaultGaugeBridge (see second require() ).
744         // the bridge contract will then forward these tokens to the sender (after withdrawing from yield farm)
745     	IERC20(acceptToken).safeTransfer(msg.sender, _amount);
746     }
747 
748     function claimSTACK() nonReentrant external returns (uint256) {
749     	return _claimSTACK(msg.sender);
750     }
751 
752     function _claimSTACK(address _user) internal returns (uint256){
753     	_kick();
754 
755     	CommitState memory _state = balances[_user];
756     	if (_state.tokensAccrued == tokensAccrued){ // user doesn't have any accrued tokens
757     		return 0;
758     	}
759     	// user has accrued tokens from their commit
760     	else {
761     		uint256 _tokensAccruedDiff = tokensAccrued.sub(_state.tokensAccrued);
762     		uint256 _tokensGive = _tokensAccruedDiff.mul(getUserWeight(_user)).div(1e18);
763 
764     		_state.tokensAccrued = tokensAccrued;
765     		balances[_user] = _state;
766 
767     		// if the guage has enough tokens to grant the user, then send their tokens
768             // otherwise, don't fail, just log STACK claimed, and a reimbursement can be done via chain events
769             if (IERC20(STACK).balanceOf(address(this)) >= _tokensGive){
770                 IERC20(STACK).safeTransfer(_user, _tokensGive);
771             }
772 
773             emit STACKClaimed(_user, _tokensGive);
774 
775             return _tokensGive;
776     	}
777     }
778 
779     function _kick() internal {   	
780     	uint256 _totalWeight = getTotalWeight();
781     	// if there are no tokens committed, then don't kick.
782     	if (_totalWeight == 0){ 
783     		return;
784     	}
785     	// already done for this block || already did all blocks || not started yet
786     	if (lastBlock == block.number || lastBlock >= endBlock || block.number < startBlock){ 
787     		return; 
788     	}
789 
790 		uint256 _deltaBlock;
791 		// edge case where kick was not called for the entire period of blocks.
792 		if (lastBlock <= startBlock && block.number >= endBlock){
793 			_deltaBlock = endBlock.sub(startBlock);
794 		}
795 		// where block.number is past the endBlock
796 		else if (block.number >= endBlock){
797 			_deltaBlock = endBlock.sub(lastBlock);
798 		}
799 		// where last block is before start
800 		else if (lastBlock <= startBlock){
801 			_deltaBlock = block.number.sub(startBlock);
802 		}
803 		// normal case, where we are in the middle of the distribution
804 		else {
805 			_deltaBlock = block.number.sub(lastBlock);
806 		}
807 
808 		// mint tokens & update tokensAccrued global
809 		uint256 _tokensToAccrue = _deltaBlock.mul(emissionRate);
810 		tokensAccrued = tokensAccrued.add(_tokensToAccrue.mul(1e18).div(_totalWeight));
811 
812     	// if not allowed to mint it's just like the emission rate = 0. So just update the lastBlock.
813     	// always update last block 
814     	lastBlock = block.number;
815     }
816 
817     // a one-time use function to sweep any commitSoft to the vc fund rewards pool, after the 3 month window
818     function sweepCommitSoft() nonReentrant public {
819     	require(block.number > endBlock, "GAUGE: <=endBlock");
820 
821         // transfer all remaining ERC20 tokens to the VC address. Fund entry has closed, VC fund will start.
822     	IERC20(acceptToken).safeTransfer(governance, IERC20(acceptToken).balanceOf(address(this)));
823     }
824 
825     function getTotalWeight() public view returns (uint256){
826     	uint256 soft = depositedCommitSoft.mul(commitSoftWeight);
827     	uint256 hard = depositedCommitHard.mul(commitHardWeight);
828 
829     	return soft.add(hard);
830     }
831 
832     function getTotalBalance() public view returns(uint256){
833     	return depositedCommitSoft.add(depositedCommitHard);
834     }
835 
836     function getUserWeight(address _user) public view returns (uint256){
837     	uint256 soft = balances[_user].balanceCommitSoft.mul(commitSoftWeight);
838     	uint256 hard = balances[_user].balanceCommitHard.mul(commitHardWeight);
839 
840     	return soft.add(hard);
841     }
842 
843     function getUserBalance(address _user) public view returns (uint256){
844     	uint256 soft = balances[_user].balanceCommitSoft;
845     	uint256 hard = balances[_user].balanceCommitHard;
846 
847     	return soft.add(hard);
848     }
849 
850     function getCommitted() public view returns (uint256, uint256, uint256){
851         return (depositedCommitSoft, depositedCommitHard, getTotalBalance());
852     }
853 
854     // decentralized rescue function for any stuck tokens, will return to governance
855     function rescue(address _token, uint256 _amount) nonReentrant external {
856         require(msg.sender == governance, "GAUGE: !governance");
857 
858         if (_token != address(0)){
859             IERC20(_token).safeTransfer(governance, _amount);
860         }
861         else { // if _tokenContract is 0x0, then escape ETH
862             governance.transfer(_amount);
863         }
864     }
865 }