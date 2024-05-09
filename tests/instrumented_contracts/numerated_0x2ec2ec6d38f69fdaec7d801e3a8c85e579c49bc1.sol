1 // SPDX-License-Identifier: MIT
2 /*
3 A simple gauge contract to measure the amount of tokens locked, and reward users in a different token.
4 
5 Using this for STACK/ETH Uni LP currently.
6 */
7 
8 pragma solidity ^0.6.11;
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
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, with an overflow flag.
100      *
101      * _Available since v3.4._
102      */
103     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         uint256 c = a + b;
105         if (c < a) return (false, 0);
106         return (true, c);
107     }
108 
109     /**
110      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         if (b > a) return (false, 0);
116         return (true, a - b);
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
121      *
122      * _Available since v3.4._
123      */
124     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
126         // benefit is lost if 'b' is also tested.
127         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
128         if (a == 0) return (true, 0);
129         uint256 c = a * b;
130         if (c / a != b) return (false, 0);
131         return (true, c);
132     }
133 
134     /**
135      * @dev Returns the division of two unsigned integers, with a division by zero flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         if (b == 0) return (false, 0);
141         return (true, a / b);
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
146      *
147      * _Available since v3.4._
148      */
149     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         if (b == 0) return (false, 0);
151         return (true, a % b);
152     }
153 
154     /**
155      * @dev Returns the addition of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `+` operator.
159      *
160      * Requirements:
161      *
162      * - Addition cannot overflow.
163      */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a, "SafeMath: addition overflow");
167         return c;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b <= a, "SafeMath: subtraction overflow");
182         return a - b;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      *
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         if (a == 0) return 0;
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers, reverting on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b > 0, "SafeMath: division by zero");
216         return a / b;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * reverting when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         require(b > 0, "SafeMath: modulo by zero");
233         return a % b;
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * CAUTION: This function is deprecated because it requires allocating memory for the error
241      * message unnecessarily. For custom revert reasons use {trySub}.
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      *
247      * - Subtraction cannot overflow.
248      */
249     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b <= a, errorMessage);
251         return a - b;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
256      * division by zero. The result is rounded towards zero.
257      *
258      * CAUTION: This function is deprecated because it requires allocating memory for the error
259      * message unnecessarily. For custom revert reasons use {tryDiv}.
260      *
261      * Counterpart to Solidity's `/` operator. Note: this function uses a
262      * `revert` opcode (which leaves remaining gas untouched) while Solidity
263      * uses an invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b > 0, errorMessage);
271         return a / b;
272     }
273 
274     /**
275      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
276      * reverting with custom message when dividing by zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryMod}.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b > 0, errorMessage);
291         return a % b;
292     }
293 }
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize, which returns 0 for contracts in
318         // construction, since the code is only stored at the end of the
319         // constructor execution.
320 
321         uint256 size;
322         // solhint-disable-next-line no-inline-assembly
323         assembly { size := extcodesize(account) }
324         return size > 0;
325     }
326 
327     /**
328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
329      * `recipient`, forwarding all available gas and reverting on errors.
330      *
331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
333      * imposed by `transfer`, making them unable to receive funds via
334      * `transfer`. {sendValue} removes this limitation.
335      *
336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
337      *
338      * IMPORTANT: because control is transferred to `recipient`, care must be
339      * taken to not create reentrancy vulnerabilities. Consider using
340      * {ReentrancyGuard} or the
341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
342      */
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
347         (bool success, ) = recipient.call{ value: amount }("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain`call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370       return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400      * with `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = target.call{ value: value }(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
420         return functionStaticCall(target, data, "Address: low-level static call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
430         require(isContract(target), "Address: static call to non-contract");
431 
432         // solhint-disable-next-line avoid-low-level-calls
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return _verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 // solhint-disable-next-line no-inline-assembly
470                 assembly {
471                     let returndata_size := mload(returndata)
472                     revert(add(32, returndata), returndata_size)
473                 }
474             } else {
475                 revert(errorMessage);
476             }
477         }
478     }
479 }
480 
481 /**
482  * @title SafeERC20
483  * @dev Wrappers around ERC20 operations that throw on failure (when the token
484  * contract returns false). Tokens that return no value (and instead revert or
485  * throw on failure) are also supported, non-reverting calls are assumed to be
486  * successful.
487  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
488  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
489  */
490 library SafeERC20 {
491     using SafeMath for uint256;
492     using Address for address;
493 
494     function safeTransfer(IERC20 token, address to, uint256 value) internal {
495         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
496     }
497 
498     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
499         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
500     }
501 
502     /**
503      * @dev Deprecated. This function has issues similar to the ones found in
504      * {IERC20-approve}, and its usage is discouraged.
505      *
506      * Whenever possible, use {safeIncreaseAllowance} and
507      * {safeDecreaseAllowance} instead.
508      */
509     function safeApprove(IERC20 token, address spender, uint256 value) internal {
510         // safeApprove should only be called when setting an initial allowance,
511         // or when resetting it to zero. To increase and decrease it, use
512         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
513         // solhint-disable-next-line max-line-length
514         require((value == 0) || (token.allowance(address(this), spender) == 0),
515             "SafeERC20: approve from non-zero to non-zero allowance"
516         );
517         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
518     }
519 
520     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
521         uint256 newAllowance = token.allowance(address(this), spender).add(value);
522         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
523     }
524 
525     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
526         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
527         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
528     }
529 
530     /**
531      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
532      * on the return value: the return value is optional (but if data is returned, it must not be false).
533      * @param token The token targeted by the call.
534      * @param data The call data (encoded using abi.encode or one of its variants).
535      */
536     function _callOptionalReturn(IERC20 token, bytes memory data) private {
537         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
538         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
539         // the target address contains contract code and also asserts for success in the low-level call.
540 
541         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
542         if (returndata.length > 0) { // Return data is optional
543             // solhint-disable-next-line max-line-length
544             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
545         }
546     }
547 }
548 
549 /**
550  * @dev Contract module that helps prevent reentrant calls to a function.
551  *
552  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
553  * available, which can be applied to functions to make sure there are no nested
554  * (reentrant) calls to them.
555  *
556  * Note that because there is a single `nonReentrant` guard, functions marked as
557  * `nonReentrant` may not call one another. This can be worked around by making
558  * those functions `private`, and then adding `external` `nonReentrant` entry
559  * points to them.
560  *
561  * TIP: If you would like to learn more about reentrancy and alternative ways
562  * to protect against it, check out our blog post
563  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
564  */
565 abstract contract ReentrancyGuard {
566     // Booleans are more expensive than uint256 or any type that takes up a full
567     // word because each write operation emits an extra SLOAD to first read the
568     // slot's contents, replace the bits taken up by the boolean, and then write
569     // back. This is the compiler's defense against contract upgrades and
570     // pointer aliasing, and it cannot be disabled.
571 
572     // The values being non-zero value makes deployment a bit more expensive,
573     // but in exchange the refund on every call to nonReentrant will be lower in
574     // amount. Since refunds are capped to a percentage of the total
575     // transaction's gas, it is best to keep them low in cases like this one, to
576     // increase the likelihood of the full refund coming into effect.
577     uint256 private constant _NOT_ENTERED = 1;
578     uint256 private constant _ENTERED = 2;
579 
580     uint256 private _status;
581 
582     constructor () internal {
583         _status = _NOT_ENTERED;
584     }
585 
586     /**
587      * @dev Prevents a contract from calling itself, directly or indirectly.
588      * Calling a `nonReentrant` function from another `nonReentrant`
589      * function is not supported. It is possible to prevent this from happening
590      * by making the `nonReentrant` function external, and make it call a
591      * `private` function that does the actual work.
592      */
593     modifier nonReentrant() {
594         // On the first call to nonReentrant, _notEntered will be true
595         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
596 
597         // Any calls to nonReentrant after this point will fail
598         _status = _ENTERED;
599 
600         _;
601 
602         // By storing the original value once again, a refund is triggered (see
603         // https://eips.ethereum.org/EIPS/eip-2200)
604         _status = _NOT_ENTERED;
605     }
606 }
607 
608 contract LPGauge is ReentrancyGuard {
609 	using SafeERC20 for IERC20;
610 	using Address for address;
611     using SafeMath for uint256;
612 
613     address payable public governance = 0xB156d2D9CAdB12a252A9015078fc5cb7E92e656e; // STACK DAO Agent address
614     address public constant acceptToken = 0xd78E04a200048a438D9D03C9A3d7E5154dE643b1; // STACK/ETH Uniswap LP Token
615 
616     // TODO: get STACK token address
617     address public constant STACK = 0xe0955F26515d22E347B17669993FCeFcc73c3a0a; // STACK DAO Token
618 
619     uint256 public emissionRate = 25209289623226158; // 60k STACK / delta blocks
620 
621     uint256 public deposited;
622 
623     uint256 public constant startBlock = 11955015;
624     uint256 public endBlock = startBlock + 2380075;
625 
626     // uint256 public constant startBlock = 11226037 + 100;
627     // uint256 public endBlock = startBlock + 2425846;
628     uint256 public lastBlock; // last block the distribution has ran
629     uint256 public tokensAccrued; // tokens to distribute per weight scaled by 1e18
630 
631     struct DepositState {
632     	uint256 balance;
633     	uint256 tokensAccrued;
634     }
635 
636     mapping(address => DepositState) public balances;
637 
638     event Deposit(address indexed from, uint256 amount);
639     event Withdraw(address indexed to, uint256 amount);
640     event STACKClaimed(address indexed to, uint256 amount);
641 
642     constructor() public {
643     }
644 
645     function setGovernance(address payable _new) external {
646     	require(msg.sender == governance);
647     	governance = _new;
648     }
649 
650     function setEmissionRate(uint256 _new) external {
651     	require(msg.sender == governance, "LPGAUGE: !governance");
652     	_kick(); // catch up the contract to the current block for old rate
653     	emissionRate = _new;
654     }
655 
656     function setEndBlock(uint256 _block) external {
657     	require(msg.sender == governance, "LPGAUGE: !governance");
658     	require(block.number <= endBlock, "LPGAUGE: distribution already done, must start another");
659         require(block.number <= _block, "LPGAUGE: can't set endBlock to past block");
660     	
661     	endBlock = _block;
662     }
663 
664     function deposit(uint256 _amount) nonReentrant external {
665     	require(block.number <= endBlock, "LPGAUGE: distribution over");
666 
667     	_claimSTACK(msg.sender);
668 
669     	IERC20(acceptToken).safeTransferFrom(msg.sender, address(this), _amount);
670 
671     	DepositState memory _state = balances[msg.sender];
672     	_state.balance = _state.balance.add(_amount);
673     	deposited = deposited.add(_amount);
674 
675     	emit Deposit(msg.sender, _amount);
676     	balances[msg.sender] = _state;
677     }
678 
679     function withdraw(uint256 _amount) nonReentrant external {
680     	_claimSTACK(msg.sender);
681 
682     	DepositState memory _state = balances[msg.sender];
683 
684     	require(_amount <= _state.balance, "LPGAUGE: insufficient balance");
685 
686     	_state.balance = _state.balance.sub(_amount);
687     	deposited = deposited.sub(_amount);
688 
689     	emit Withdraw(msg.sender, _amount);
690     	balances[msg.sender] = _state;
691 
692     	IERC20(acceptToken).safeTransfer(msg.sender, _amount);
693     }
694 
695     function claimSTACK() nonReentrant external returns (uint256) {
696     	return _claimSTACK(msg.sender);
697     }
698 
699     function _claimSTACK(address _user) internal returns (uint256) {
700     	_kick();
701 
702     	DepositState memory _state = balances[_user];
703     	if (_state.tokensAccrued == tokensAccrued){ // user doesn't have any accrued tokens
704     		return 0;
705     	}
706     	else {
707     		uint256 _tokensAccruedDiff = tokensAccrued.sub(_state.tokensAccrued);
708     		uint256 _tokensGive = _tokensAccruedDiff.mul(_state.balance).div(1e18);
709 
710     		_state.tokensAccrued = tokensAccrued;
711     		balances[_user] = _state;
712 
713             // if the guage has enough tokens to grant the user, then send their tokens
714             // otherwise, don't fail, just log STACK claimed, and a reimbursement can be done via chain events
715             if (IERC20(STACK).balanceOf(address(this)) >= _tokensGive){
716                 IERC20(STACK).safeTransfer(_user, _tokensGive);
717             }
718 
719             // log event
720             emit STACKClaimed(_user, _tokensGive);
721 
722             return _tokensGive;
723     	}
724     }
725 
726     function _kick() internal {
727     	uint256 _totalDeposited = deposited;
728     	// if there are no tokens committed, then don't kick.
729     	if (_totalDeposited == 0){
730     		return;
731     	}
732     	// already done for this block || already did all blocks || not started yet
733     	if (lastBlock == block.number || lastBlock >= endBlock || block.number < startBlock){
734     		return;
735     	}
736 
737 		uint256 _deltaBlock;
738 		// edge case where kick was not called for entire period of blocks.
739 		if (lastBlock <= startBlock && block.number >= endBlock){
740 			_deltaBlock = endBlock.sub(startBlock);
741 		}
742 		// where block.number is past the endBlock
743 		else if (block.number >= endBlock){
744 			_deltaBlock = endBlock.sub(lastBlock);
745 		}
746 		// where last block is before start
747 		else if (lastBlock <= startBlock){
748 			_deltaBlock = block.number.sub(startBlock);
749 		}
750 		// normal case, where we are in the middle of the distribution
751 		else {
752 			_deltaBlock = block.number.sub(lastBlock);
753 		}
754 
755 		uint256 _tokensToAccrue = _deltaBlock.mul(emissionRate);
756 		tokensAccrued = tokensAccrued.add(_tokensToAccrue.mul(1e18).div(_totalDeposited));
757 
758     	// if not allowed to mint it's just like the emission rate = 0. So just update the lastBlock.
759     	// always update last block 
760     	lastBlock = block.number;
761     }
762 
763     // decentralized rescue function for any stuck tokens, will return to governance
764     function rescue(address _token, uint256 _amount) nonReentrant external {
765         require(msg.sender == governance, "LPGAUGE: !governance");
766 
767         if (_token != address(0)){
768             IERC20(_token).safeTransfer(governance, _amount);
769         }
770         else { // if _tokenContract is 0x0, then escape ETH
771             governance.transfer(_amount);
772         }
773     }
774 }