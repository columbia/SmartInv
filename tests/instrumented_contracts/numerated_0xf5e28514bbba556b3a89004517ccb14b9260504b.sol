1 // SPDX-License-Identifier: MIT
2 /*
3 A simple gauge contract to measure the amount of tokens locked, and reward users in a different token.
4 
5 This Gauge works for a "sharesOf" based rebalance token.
6 */
7 
8 pragma solidity ^0.6.11;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Collection of functions related to the address type
33  */
34 library Address {
35     /**
36      * @dev Returns true if `account` is a contract.
37      *
38      * [IMPORTANT]
39      * ====
40      * It is unsafe to assume that an address for which this function returns
41      * false is an externally-owned account (EOA) and not a contract.
42      *
43      * Among others, `isContract` will return false for the following
44      * types of addresses:
45      *
46      *  - an externally-owned account
47      *  - a contract in construction
48      *  - an address where a contract will be created
49      *  - an address where a contract lived, but was destroyed
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize, which returns 0 for contracts in
54         // construction, since the code is only stored at the end of the
55         // constructor execution.
56 
57         uint256 size;
58         // solhint-disable-next-line no-inline-assembly
59         assembly { size := extcodesize(account) }
60         return size > 0;
61     }
62 
63     /**
64      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
65      * `recipient`, forwarding all available gas and reverting on errors.
66      *
67      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
68      * of certain opcodes, possibly making contracts go over the 2300 gas limit
69      * imposed by `transfer`, making them unable to receive funds via
70      * `transfer`. {sendValue} removes this limitation.
71      *
72      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
73      *
74      * IMPORTANT: because control is transferred to `recipient`, care must be
75      * taken to not create reentrancy vulnerabilities. Consider using
76      * {ReentrancyGuard} or the
77      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
78      */
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     /**
88      * @dev Performs a Solidity function call using a low level `call`. A
89      * plain`call` is an unsafe replacement for a function call: use this
90      * function instead.
91      *
92      * If `target` reverts with a revert reason, it is bubbled up by this
93      * function (like regular Solidity function calls).
94      *
95      * Returns the raw returned data. To convert to the expected return value,
96      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
97      *
98      * Requirements:
99      *
100      * - `target` must be a contract.
101      * - calling `target` with `data` must not revert.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106       return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
111      * `errorMessage` as a fallback revert reason when `target` reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
121      * but also transferring `value` wei to `target`.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least `value`.
126      * - the called Solidity function must be `payable`.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
136      * with `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
141         require(address(this).balance >= value, "Address: insufficient balance for call");
142         require(isContract(target), "Address: call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.call{ value: value }(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
156         return functionStaticCall(target, data, "Address: low-level static call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         // solhint-disable-next-line avoid-low-level-calls
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
190         require(isContract(target), "Address: delegate call to non-contract");
191 
192         // solhint-disable-next-line avoid-low-level-calls
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return _verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
198         if (success) {
199             return returndata;
200         } else {
201             // Look for revert reason and bubble it up if present
202             if (returndata.length > 0) {
203                 // The easiest way to bubble the revert reason is using memory via assembly
204 
205                 // solhint-disable-next-line no-inline-assembly
206                 assembly {
207                     let returndata_size := mload(returndata)
208                     revert(add(32, returndata), returndata_size)
209                 }
210             } else {
211                 revert(errorMessage);
212             }
213         }
214     }
215 }
216 
217 /**
218  * @dev Contract module that helps prevent reentrant calls to a function.
219  *
220  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
221  * available, which can be applied to functions to make sure there are no nested
222  * (reentrant) calls to them.
223  *
224  * Note that because there is a single `nonReentrant` guard, functions marked as
225  * `nonReentrant` may not call one another. This can be worked around by making
226  * those functions `private`, and then adding `external` `nonReentrant` entry
227  * points to them.
228  *
229  * TIP: If you would like to learn more about reentrancy and alternative ways
230  * to protect against it, check out our blog post
231  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
232  */
233 abstract contract ReentrancyGuard {
234     // Booleans are more expensive than uint256 or any type that takes up a full
235     // word because each write operation emits an extra SLOAD to first read the
236     // slot's contents, replace the bits taken up by the boolean, and then write
237     // back. This is the compiler's defense against contract upgrades and
238     // pointer aliasing, and it cannot be disabled.
239 
240     // The values being non-zero value makes deployment a bit more expensive,
241     // but in exchange the refund on every call to nonReentrant will be lower in
242     // amount. Since refunds are capped to a percentage of the total
243     // transaction's gas, it is best to keep them low in cases like this one, to
244     // increase the likelihood of the full refund coming into effect.
245     uint256 private constant _NOT_ENTERED = 1;
246     uint256 private constant _ENTERED = 2;
247 
248     uint256 private _status;
249 
250     constructor () internal {
251         _status = _NOT_ENTERED;
252     }
253 
254     /**
255      * @dev Prevents a contract from calling itself, directly or indirectly.
256      * Calling a `nonReentrant` function from another `nonReentrant`
257      * function is not supported. It is possible to prevent this from happening
258      * by making the `nonReentrant` function external, and make it call a
259      * `private` function that does the actual work.
260      */
261     modifier nonReentrant() {
262         // On the first call to nonReentrant, _notEntered will be true
263         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
264 
265         // Any calls to nonReentrant after this point will fail
266         _status = _ENTERED;
267 
268         _;
269 
270         // By storing the original value once again, a refund is triggered (see
271         // https://eips.ethereum.org/EIPS/eip-2200)
272         _status = _NOT_ENTERED;
273     }
274 }
275 
276 /**
277  * @dev Wrappers over Solidity's arithmetic operations with added overflow
278  * checks.
279  *
280  * Arithmetic operations in Solidity wrap on overflow. This can easily result
281  * in bugs, because programmers usually assume that an overflow raises an
282  * error, which is the standard behavior in high level programming languages.
283  * `SafeMath` restores this intuition by reverting the transaction when an
284  * operation overflows.
285  *
286  * Using this library instead of the unchecked operations eliminates an entire
287  * class of bugs, so it's recommended to use it always.
288  */
289 library SafeMath {
290     /**
291      * @dev Returns the addition of two unsigned integers, with an overflow flag.
292      *
293      * _Available since v3.4._
294      */
295     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         uint256 c = a + b;
297         if (c < a) return (false, 0);
298         return (true, c);
299     }
300 
301     /**
302      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
303      *
304      * _Available since v3.4._
305      */
306     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
307         if (b > a) return (false, 0);
308         return (true, a - b);
309     }
310 
311     /**
312      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
313      *
314      * _Available since v3.4._
315      */
316     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
317         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
318         // benefit is lost if 'b' is also tested.
319         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
320         if (a == 0) return (true, 0);
321         uint256 c = a * b;
322         if (c / a != b) return (false, 0);
323         return (true, c);
324     }
325 
326     /**
327      * @dev Returns the division of two unsigned integers, with a division by zero flag.
328      *
329      * _Available since v3.4._
330      */
331     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
332         if (b == 0) return (false, 0);
333         return (true, a / b);
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
338      *
339      * _Available since v3.4._
340      */
341     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
342         if (b == 0) return (false, 0);
343         return (true, a % b);
344     }
345 
346     /**
347      * @dev Returns the addition of two unsigned integers, reverting on
348      * overflow.
349      *
350      * Counterpart to Solidity's `+` operator.
351      *
352      * Requirements:
353      *
354      * - Addition cannot overflow.
355      */
356     function add(uint256 a, uint256 b) internal pure returns (uint256) {
357         uint256 c = a + b;
358         require(c >= a, "SafeMath: addition overflow");
359         return c;
360     }
361 
362     /**
363      * @dev Returns the subtraction of two unsigned integers, reverting on
364      * overflow (when the result is negative).
365      *
366      * Counterpart to Solidity's `-` operator.
367      *
368      * Requirements:
369      *
370      * - Subtraction cannot overflow.
371      */
372     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
373         require(b <= a, "SafeMath: subtraction overflow");
374         return a - b;
375     }
376 
377     /**
378      * @dev Returns the multiplication of two unsigned integers, reverting on
379      * overflow.
380      *
381      * Counterpart to Solidity's `*` operator.
382      *
383      * Requirements:
384      *
385      * - Multiplication cannot overflow.
386      */
387     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
388         if (a == 0) return 0;
389         uint256 c = a * b;
390         require(c / a == b, "SafeMath: multiplication overflow");
391         return c;
392     }
393 
394     /**
395      * @dev Returns the integer division of two unsigned integers, reverting on
396      * division by zero. The result is rounded towards zero.
397      *
398      * Counterpart to Solidity's `/` operator. Note: this function uses a
399      * `revert` opcode (which leaves remaining gas untouched) while Solidity
400      * uses an invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function div(uint256 a, uint256 b) internal pure returns (uint256) {
407         require(b > 0, "SafeMath: division by zero");
408         return a / b;
409     }
410 
411     /**
412      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
413      * reverting when dividing by zero.
414      *
415      * Counterpart to Solidity's `%` operator. This function uses a `revert`
416      * opcode (which leaves remaining gas untouched) while Solidity uses an
417      * invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      *
421      * - The divisor cannot be zero.
422      */
423     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
424         require(b > 0, "SafeMath: modulo by zero");
425         return a % b;
426     }
427 
428     /**
429      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
430      * overflow (when the result is negative).
431      *
432      * CAUTION: This function is deprecated because it requires allocating memory for the error
433      * message unnecessarily. For custom revert reasons use {trySub}.
434      *
435      * Counterpart to Solidity's `-` operator.
436      *
437      * Requirements:
438      *
439      * - Subtraction cannot overflow.
440      */
441     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
442         require(b <= a, errorMessage);
443         return a - b;
444     }
445 
446     /**
447      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
448      * division by zero. The result is rounded towards zero.
449      *
450      * CAUTION: This function is deprecated because it requires allocating memory for the error
451      * message unnecessarily. For custom revert reasons use {tryDiv}.
452      *
453      * Counterpart to Solidity's `/` operator. Note: this function uses a
454      * `revert` opcode (which leaves remaining gas untouched) while Solidity
455      * uses an invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
462         require(b > 0, errorMessage);
463         return a / b;
464     }
465 
466     /**
467      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
468      * reverting with custom message when dividing by zero.
469      *
470      * CAUTION: This function is deprecated because it requires allocating memory for the error
471      * message unnecessarily. For custom revert reasons use {tryMod}.
472      *
473      * Counterpart to Solidity's `%` operator. This function uses a `revert`
474      * opcode (which leaves remaining gas untouched) while Solidity uses an
475      * invalid opcode to revert (consuming all remaining gas).
476      *
477      * Requirements:
478      *
479      * - The divisor cannot be zero.
480      */
481     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
482         require(b > 0, errorMessage);
483         return a % b;
484     }
485 }
486 
487 /**
488  * @dev Interface of the ERC20 standard as defined in the EIP.
489  */
490 interface IERC20 {
491     /**
492      * @dev Returns the amount of tokens in existence.
493      */
494     function totalSupply() external view returns (uint256);
495 
496     /**
497      * @dev Returns the amount of tokens owned by `account`.
498      */
499     function balanceOf(address account) external view returns (uint256);
500 
501     /**
502      * @dev Moves `amount` tokens from the caller's account to `recipient`.
503      *
504      * Returns a boolean value indicating whether the operation succeeded.
505      *
506      * Emits a {Transfer} event.
507      */
508     function transfer(address recipient, uint256 amount) external returns (bool);
509 
510     /**
511      * @dev Returns the remaining number of tokens that `spender` will be
512      * allowed to spend on behalf of `owner` through {transferFrom}. This is
513      * zero by default.
514      *
515      * This value changes when {approve} or {transferFrom} are called.
516      */
517     function allowance(address owner, address spender) external view returns (uint256);
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
521      *
522      * Returns a boolean value indicating whether the operation succeeded.
523      *
524      * IMPORTANT: Beware that changing an allowance with this method brings the risk
525      * that someone may use both the old and the new allowance by unfortunate
526      * transaction ordering. One possible solution to mitigate this race
527      * condition is to first reduce the spender's allowance to 0 and set the
528      * desired value afterwards:
529      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
530      *
531      * Emits an {Approval} event.
532      */
533     function approve(address spender, uint256 amount) external returns (bool);
534 
535     /**
536      * @dev Moves `amount` tokens from `sender` to `recipient` using the
537      * allowance mechanism. `amount` is then deducted from the caller's
538      * allowance.
539      *
540      * Returns a boolean value indicating whether the operation succeeded.
541      *
542      * Emits a {Transfer} event.
543      */
544     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
545 
546     /**
547      * @dev Emitted when `value` tokens are moved from one account (`from`) to
548      * another (`to`).
549      *
550      * Note that `value` may be zero.
551      */
552     event Transfer(address indexed from, address indexed to, uint256 value);
553 
554     /**
555      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
556      * a call to {approve}. `value` is the new allowance.
557      */
558     event Approval(address indexed owner, address indexed spender, uint256 value);
559 }
560 
561 /**
562  * @title SafeERC20
563  * @dev Wrappers around ERC20 operations that throw on failure (when the token
564  * contract returns false). Tokens that return no value (and instead revert or
565  * throw on failure) are also supported, non-reverting calls are assumed to be
566  * successful.
567  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
568  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
569  */
570 library SafeERC20 {
571     using SafeMath for uint256;
572     using Address for address;
573 
574     function safeTransfer(IERC20 token, address to, uint256 value) internal {
575         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
576     }
577 
578     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
579         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
580     }
581 
582     /**
583      * @dev Deprecated. This function has issues similar to the ones found in
584      * {IERC20-approve}, and its usage is discouraged.
585      *
586      * Whenever possible, use {safeIncreaseAllowance} and
587      * {safeDecreaseAllowance} instead.
588      */
589     function safeApprove(IERC20 token, address spender, uint256 value) internal {
590         // safeApprove should only be called when setting an initial allowance,
591         // or when resetting it to zero. To increase and decrease it, use
592         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
593         // solhint-disable-next-line max-line-length
594         require((value == 0) || (token.allowance(address(this), spender) == 0),
595             "SafeERC20: approve from non-zero to non-zero allowance"
596         );
597         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
598     }
599 
600     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
601         uint256 newAllowance = token.allowance(address(this), spender).add(value);
602         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
603     }
604 
605     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
606         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
607         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
608     }
609 
610     /**
611      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
612      * on the return value: the return value is optional (but if data is returned, it must not be false).
613      * @param token The token targeted by the call.
614      * @param data The call data (encoded using abi.encode or one of its variants).
615      */
616     function _callOptionalReturn(IERC20 token, bytes memory data) private {
617         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
618         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
619         // the target address contains contract code and also asserts for success in the low-level call.
620 
621         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
622         if (returndata.length > 0) { // Return data is optional
623             // solhint-disable-next-line max-line-length
624             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
625         }
626     }
627 }
628 
629 interface IFarmTokenV1 {
630     function name() external view returns (string memory);
631     function symbol() external view returns (string memory);
632     function decimals() external view returns (uint8);
633     function getSharesForUnderlying(uint256 _amountUnderlying) external view returns (uint256);
634     function getUnderlyingForShares(uint256 _amountShares) external view returns (uint256);
635 }
636 
637 contract GaugeD2_USDC is IERC20, ReentrancyGuard {
638     using SafeERC20 for IERC20;
639     using Address for address;
640     using SafeMath for uint256;
641 
642     address payable public governance = 0xdD7A75CC6c04031629f13848Bc0D07e89C3961Be; // STACK DAO Council Multisig
643     address public constant acceptToken = 0x067b9FE006E16f52BBf647aB6799f87566480D2c; // stackToken USDC rebase token
644 
645     address public constant STACK = 0xe0955F26515d22E347B17669993FCeFcc73c3a0a; // STACK DAO Token
646 
647     uint256 public emissionRate = 16806186020950591;
648 
649     uint256 public depositedShares;
650 
651     uint256 public constant startBlock = 12234861;
652     uint256 public endBlock = startBlock + 1190038;
653 
654     uint256 public lastBlock; // last block the distribution has ran
655     uint256 public tokensAccrued; // tokens to distribute per weight scaled by 1e18
656 
657     struct DepositState {
658         uint256 userShares;
659         uint256 tokensAccrued;
660     }
661 
662     mapping(address => DepositState) public shares;
663 
664     event Deposit(address indexed from, uint256 amount);
665     event Withdraw(address indexed to, uint256 amount);
666     event STACKClaimed(address indexed to, uint256 amount);
667     // emit mint/burn on deposit/withdraw
668     event Transfer(address indexed from, address indexed to, uint256 value);
669     // never emitted, only included here to align with ERC20 spec.
670     event Approval(address indexed owner, address indexed spender, uint256 value);
671 
672     constructor() public {
673     }
674 
675     function setGovernance(address payable _new) external {
676         require(msg.sender == governance);
677         governance = _new;
678     }
679 
680     function setEmissionRate(uint256 _new) external {
681         require(msg.sender == governance, "GAUGED2: !governance");
682         _kick(); // catch up the contract to the current block for old rate
683         emissionRate = _new;
684     }
685 
686     function setEndBlock(uint256 _block) external {
687         require(msg.sender == governance, "GAUGED2: !governance");
688         require(block.number <= endBlock, "GAUGED2: distribution already done, must start another");
689         require(block.number <= _block, "GAUGED2: can't set endBlock to past block");
690         
691         endBlock = _block;
692     }
693 
694     /////////// NOTE: Our gauges now implement mock ERC20 functionality in order to interact nicer with block explorers...
695     function name() external view returns (string memory){
696         return string(abi.encodePacked("gauge-", IFarmTokenV1(acceptToken).name()));
697     }
698     
699     function symbol() external view returns (string memory){
700         return string(abi.encodePacked("gauge-", IFarmTokenV1(acceptToken).symbol()));
701     }
702 
703     function decimals() external view returns (uint8){
704         return IFarmTokenV1(acceptToken).decimals();
705     }
706 
707     function totalSupply() external override view returns (uint256){
708         return IFarmTokenV1(acceptToken).getUnderlyingForShares(depositedShares);
709     }
710 
711     function balanceOf(address _account) public override view returns (uint256){
712         return IFarmTokenV1(acceptToken).getUnderlyingForShares(shares[_account].userShares);
713     }
714 
715     // transfer tokens, not shares
716     function transfer(address _recipient, uint256 _amount) external override returns (bool){
717         // to squelch
718         _recipient;
719         _amount;
720         revert("transfer not implemented. please withdraw first.");
721     }
722 
723     function transferFrom(address _sender, address _recipient, uint256 _amount) external override returns (bool){
724         // to squelch
725         _sender;
726         _recipient;
727         _amount;
728         revert("transferFrom not implemented. please withdraw first.");
729     }
730 
731     // allow tokens, not shares
732     function allowance(address _owner, address _spender) external override view returns (uint256){
733         // to squelch
734         _owner;
735         _spender;
736         return 0;
737     }
738 
739     // approve tokens, not shares
740     function approve(address _spender, uint256 _amount) external override returns (bool){
741         // to squelch
742         _spender;
743         _amount;
744         revert("approve not implemented. please withdraw first.");
745     }
746     ////////// END MOCK ERC20 FUNCTIONALITY //////////
747 
748     function deposit(uint256 _amount) nonReentrant external {
749         require(block.number <= endBlock, "GAUGED2: distribution over");
750 
751         _claimSTACK(msg.sender);
752 
753         // trusted contracts
754         IERC20(acceptToken).safeTransferFrom(msg.sender, address(this), _amount);
755         uint256 _sharesFor = IFarmTokenV1(acceptToken).getSharesForUnderlying(_amount);
756 
757         DepositState memory _state = shares[msg.sender];
758 
759         _state.userShares = _state.userShares.add(_sharesFor);
760         depositedShares = depositedShares.add(_sharesFor);
761 
762         emit Deposit(msg.sender, _amount);
763         emit Transfer(address(0), msg.sender, _amount);
764         shares[msg.sender] = _state;
765     }
766 
767     function withdraw(uint256 _amount) nonReentrant external {
768         _claimSTACK(msg.sender);
769 
770         DepositState memory _state = shares[msg.sender];
771         uint256 _sharesFor = IFarmTokenV1(acceptToken).getSharesForUnderlying(_amount);
772 
773         require(_sharesFor <= _state.userShares, "GAUGED2: insufficient balance");
774 
775         _state.userShares = _state.userShares.sub(_sharesFor);
776         depositedShares = depositedShares.sub(_sharesFor);
777 
778         emit Withdraw(msg.sender, _amount);
779         emit Transfer(msg.sender, address(0), _amount);
780         shares[msg.sender] = _state;
781 
782         IERC20(acceptToken).safeTransfer(msg.sender, _amount);
783     }
784 
785     function claimSTACK() nonReentrant external returns (uint256) {
786         return _claimSTACK(msg.sender);
787     }
788 
789     function _claimSTACK(address _user) internal returns (uint256) {
790         _kick();
791 
792         DepositState memory _state = shares[_user];
793         if (_state.tokensAccrued == tokensAccrued){ // user doesn't have any accrued tokens
794             return 0;
795         }
796         else {
797             uint256 _tokensAccruedDiff = tokensAccrued.sub(_state.tokensAccrued);
798             uint256 _tokensGive = _tokensAccruedDiff.mul(_state.userShares).div(1e18);
799 
800             _state.tokensAccrued = tokensAccrued;
801             shares[_user] = _state;
802 
803             // if the guage has enough tokens to grant the user, then send their tokens
804             // otherwise, don't fail, just log STACK claimed, and a reimbursement can be done via chain events
805             if (IERC20(STACK).balanceOf(address(this)) >= _tokensGive){
806                 IERC20(STACK).safeTransfer(_user, _tokensGive);
807             }
808 
809             // log event
810             emit STACKClaimed(_user, _tokensGive);
811 
812             return _tokensGive;
813         }
814     }
815 
816     function _kick() internal {
817         uint256 _totalDeposited = depositedShares;
818         // if there are no tokens committed, then don't kick.
819         if (_totalDeposited == 0){
820             return;
821         }
822         // already done for this block || already did all blocks || not started yet
823         if (lastBlock == block.number || lastBlock >= endBlock || block.number < startBlock){
824             return;
825         }
826 
827         uint256 _deltaBlock;
828         // edge case where kick was not called for entire period of blocks.
829         if (lastBlock <= startBlock && block.number >= endBlock){
830             _deltaBlock = endBlock.sub(startBlock);
831         }
832         // where block.number is past the endBlock
833         else if (block.number >= endBlock){
834             _deltaBlock = endBlock.sub(lastBlock);
835         }
836         // where last block is before start
837         else if (lastBlock <= startBlock){
838             _deltaBlock = block.number.sub(startBlock);
839         }
840         // normal case, where we are in the middle of the distribution
841         else {
842             _deltaBlock = block.number.sub(lastBlock);
843         }
844 
845         uint256 _tokensToAccrue = _deltaBlock.mul(emissionRate);
846         tokensAccrued = tokensAccrued.add(_tokensToAccrue.mul(1e18).div(_totalDeposited));
847 
848         // if not allowed to mint it's just like the emission rate = 0. So just update the lastBlock.
849         // always update last block 
850         lastBlock = block.number;
851     }
852 
853     // decentralized rescue function for any stuck tokens, will return to governance
854     function rescue(address _token, uint256 _amount) nonReentrant external {
855         require(msg.sender == governance, "GAUGED2: !governance");
856 
857         if (_token != address(0)){
858             IERC20(_token).safeTransfer(governance, _amount);
859         }
860         else { // if _tokenContract is 0x0, then escape ETH
861             governance.transfer(_amount);
862         }
863     }
864 }