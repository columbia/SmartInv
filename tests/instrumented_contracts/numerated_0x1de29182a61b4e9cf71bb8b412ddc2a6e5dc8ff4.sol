1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
84 
85 
86 pragma solidity >=0.6.0 <0.8.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         uint256 c = a + b;
109         if (c < a) return (false, 0);
110         return (true, c);
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         if (b > a) return (false, 0);
120         return (true, a - b);
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132         if (a == 0) return (true, 0);
133         uint256 c = a * b;
134         if (c / a != b) return (false, 0);
135         return (true, c);
136     }
137 
138     /**
139      * @dev Returns the division of two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         if (b == 0) return (false, 0);
145         return (true, a / b);
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         if (b == 0) return (false, 0);
155         return (true, a % b);
156     }
157 
158     /**
159      * @dev Returns the addition of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `+` operator.
163      *
164      * Requirements:
165      *
166      * - Addition cannot overflow.
167      */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         require(c >= a, "SafeMath: addition overflow");
171         return c;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b <= a, "SafeMath: subtraction overflow");
186         return a - b;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         if (a == 0) return 0;
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203         return c;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers, reverting on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b > 0, "SafeMath: division by zero");
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b > 0, "SafeMath: modulo by zero");
237         return a % b;
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
242      * overflow (when the result is negative).
243      *
244      * CAUTION: This function is deprecated because it requires allocating memory for the error
245      * message unnecessarily. For custom revert reasons use {trySub}.
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         return a - b;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {tryDiv}.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b > 0, errorMessage);
275         return a / b;
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * reverting with custom message when dividing by zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryMod}.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 
300 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2
301 
302 
303 pragma solidity >=0.6.2 <0.8.0;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         // solhint-disable-next-line no-inline-assembly
333         assembly { size := extcodesize(account) }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
357         (bool success, ) = recipient.call{ value: amount }("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain`call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380       return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
415         require(address(this).balance >= value, "Address: insufficient balance for call");
416         require(isContract(target), "Address: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = target.call{ value: value }(data);
420         return _verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.staticcall(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.delegatecall(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 // solhint-disable-next-line no-inline-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.2
493 
494 
495 pragma solidity >=0.6.0 <0.8.0;
496 
497 
498 
499 /**
500  * @title SafeERC20
501  * @dev Wrappers around ERC20 operations that throw on failure (when the token
502  * contract returns false). Tokens that return no value (and instead revert or
503  * throw on failure) are also supported, non-reverting calls are assumed to be
504  * successful.
505  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
506  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
507  */
508 library SafeERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     function safeTransfer(IERC20 token, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
518     }
519 
520     /**
521      * @dev Deprecated. This function has issues similar to the ones found in
522      * {IERC20-approve}, and its usage is discouraged.
523      *
524      * Whenever possible, use {safeIncreaseAllowance} and
525      * {safeDecreaseAllowance} instead.
526      */
527     function safeApprove(IERC20 token, address spender, uint256 value) internal {
528         // safeApprove should only be called when setting an initial allowance,
529         // or when resetting it to zero. To increase and decrease it, use
530         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
531         // solhint-disable-next-line max-line-length
532         require((value == 0) || (token.allowance(address(this), spender) == 0),
533             "SafeERC20: approve from non-zero to non-zero allowance"
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
536     }
537 
538     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).add(value);
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
544         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     /**
549      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
550      * on the return value: the return value is optional (but if data is returned, it must not be false).
551      * @param token The token targeted by the call.
552      * @param data The call data (encoded using abi.encode or one of its variants).
553      */
554     function _callOptionalReturn(IERC20 token, bytes memory data) private {
555         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
556         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
557         // the target address contains contract code and also asserts for success in the low-level call.
558 
559         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v3.4.1
569 
570 
571 pragma solidity >=0.6.2 <0.8.0;
572 
573 /**
574  * @dev Collection of functions related to the address type
575  */
576 library AddressUpgradeable {
577     /**
578      * @dev Returns true if `account` is a contract.
579      *
580      * [IMPORTANT]
581      * ====
582      * It is unsafe to assume that an address for which this function returns
583      * false is an externally-owned account (EOA) and not a contract.
584      *
585      * Among others, `isContract` will return false for the following
586      * types of addresses:
587      *
588      *  - an externally-owned account
589      *  - a contract in construction
590      *  - an address where a contract will be created
591      *  - an address where a contract lived, but was destroyed
592      * ====
593      */
594     function isContract(address account) internal view returns (bool) {
595         // This method relies on extcodesize, which returns 0 for contracts in
596         // construction, since the code is only stored at the end of the
597         // constructor execution.
598 
599         uint256 size;
600         // solhint-disable-next-line no-inline-assembly
601         assembly { size := extcodesize(account) }
602         return size > 0;
603     }
604 
605     /**
606      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
607      * `recipient`, forwarding all available gas and reverting on errors.
608      *
609      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
610      * of certain opcodes, possibly making contracts go over the 2300 gas limit
611      * imposed by `transfer`, making them unable to receive funds via
612      * `transfer`. {sendValue} removes this limitation.
613      *
614      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
615      *
616      * IMPORTANT: because control is transferred to `recipient`, care must be
617      * taken to not create reentrancy vulnerabilities. Consider using
618      * {ReentrancyGuard} or the
619      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
620      */
621     function sendValue(address payable recipient, uint256 amount) internal {
622         require(address(this).balance >= amount, "Address: insufficient balance");
623 
624         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
625         (bool success, ) = recipient.call{ value: amount }("");
626         require(success, "Address: unable to send value, recipient may have reverted");
627     }
628 
629     /**
630      * @dev Performs a Solidity function call using a low level `call`. A
631      * plain`call` is an unsafe replacement for a function call: use this
632      * function instead.
633      *
634      * If `target` reverts with a revert reason, it is bubbled up by this
635      * function (like regular Solidity function calls).
636      *
637      * Returns the raw returned data. To convert to the expected return value,
638      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
639      *
640      * Requirements:
641      *
642      * - `target` must be a contract.
643      * - calling `target` with `data` must not revert.
644      *
645      * _Available since v3.1._
646      */
647     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
648       return functionCall(target, data, "Address: low-level call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
653      * `errorMessage` as a fallback revert reason when `target` reverts.
654      *
655      * _Available since v3.1._
656      */
657     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
658         return functionCallWithValue(target, data, 0, errorMessage);
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
663      * but also transferring `value` wei to `target`.
664      *
665      * Requirements:
666      *
667      * - the calling contract must have an ETH balance of at least `value`.
668      * - the called Solidity function must be `payable`.
669      *
670      * _Available since v3.1._
671      */
672     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
673         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
678      * with `errorMessage` as a fallback revert reason when `target` reverts.
679      *
680      * _Available since v3.1._
681      */
682     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
683         require(address(this).balance >= value, "Address: insufficient balance for call");
684         require(isContract(target), "Address: call to non-contract");
685 
686         // solhint-disable-next-line avoid-low-level-calls
687         (bool success, bytes memory returndata) = target.call{ value: value }(data);
688         return _verifyCallResult(success, returndata, errorMessage);
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
693      * but performing a static call.
694      *
695      * _Available since v3.3._
696      */
697     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
698         return functionStaticCall(target, data, "Address: low-level static call failed");
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
703      * but performing a static call.
704      *
705      * _Available since v3.3._
706      */
707     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
708         require(isContract(target), "Address: static call to non-contract");
709 
710         // solhint-disable-next-line avoid-low-level-calls
711         (bool success, bytes memory returndata) = target.staticcall(data);
712         return _verifyCallResult(success, returndata, errorMessage);
713     }
714 
715     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
716         if (success) {
717             return returndata;
718         } else {
719             // Look for revert reason and bubble it up if present
720             if (returndata.length > 0) {
721                 // The easiest way to bubble the revert reason is using memory via assembly
722 
723                 // solhint-disable-next-line no-inline-assembly
724                 assembly {
725                     let returndata_size := mload(returndata)
726                     revert(add(32, returndata), returndata_size)
727                 }
728             } else {
729                 revert(errorMessage);
730             }
731         }
732     }
733 }
734 
735 
736 // File @openzeppelin/contracts-upgradeable/proxy/Initializable.sol@v3.4.1
737 
738 
739 // solhint-disable-next-line compiler-version
740 pragma solidity >=0.4.24 <0.8.0;
741 
742 /**
743  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
744  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
745  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
746  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
747  *
748  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
749  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
750  *
751  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
752  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
753  */
754 abstract contract Initializable {
755 
756     /**
757      * @dev Indicates that the contract has been initialized.
758      */
759     bool private _initialized;
760 
761     /**
762      * @dev Indicates that the contract is in the process of being initialized.
763      */
764     bool private _initializing;
765 
766     /**
767      * @dev Modifier to protect an initializer function from being invoked twice.
768      */
769     modifier initializer() {
770         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
771 
772         bool isTopLevelCall = !_initializing;
773         if (isTopLevelCall) {
774             _initializing = true;
775             _initialized = true;
776         }
777 
778         _;
779 
780         if (isTopLevelCall) {
781             _initializing = false;
782         }
783     }
784 
785     /// @dev Returns true if and only if the function is running in the constructor
786     function _isConstructor() private view returns (bool) {
787         return !AddressUpgradeable.isContract(address(this));
788     }
789 }
790 
791 
792 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v3.4.1
793 
794 
795 pragma solidity >=0.6.0 <0.8.0;
796 
797 /*
798  * @dev Provides information about the current execution context, including the
799  * sender of the transaction and its data. While these are generally available
800  * via msg.sender and msg.data, they should not be accessed in such a direct
801  * manner, since when dealing with GSN meta-transactions the account sending and
802  * paying for execution may not be the actual sender (as far as an application
803  * is concerned).
804  *
805  * This contract is only required for intermediate, library-like contracts.
806  */
807 abstract contract ContextUpgradeable is Initializable {
808     function __Context_init() internal initializer {
809         __Context_init_unchained();
810     }
811 
812     function __Context_init_unchained() internal initializer {
813     }
814     function _msgSender() internal view virtual returns (address payable) {
815         return msg.sender;
816     }
817 
818     function _msgData() internal view virtual returns (bytes memory) {
819         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
820         return msg.data;
821     }
822     uint256[50] private __gap;
823 }
824 
825 
826 // File @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol@v3.4.1
827 
828 
829 pragma solidity >=0.6.0 <0.8.0;
830 
831 
832 /**
833  * @dev Contract module which provides a basic access control mechanism, where
834  * there is an account (an owner) that can be granted exclusive access to
835  * specific functions.
836  *
837  * By default, the owner account will be the one that deploys the contract. This
838  * can later be changed with {transferOwnership}.
839  *
840  * This module is used through inheritance. It will make available the modifier
841  * `onlyOwner`, which can be applied to your functions to restrict their use to
842  * the owner.
843  */
844 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
845     address private _owner;
846 
847     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
848 
849     /**
850      * @dev Initializes the contract setting the deployer as the initial owner.
851      */
852     function __Ownable_init() internal initializer {
853         __Context_init_unchained();
854         __Ownable_init_unchained();
855     }
856 
857     function __Ownable_init_unchained() internal initializer {
858         address msgSender = _msgSender();
859         _owner = msgSender;
860         emit OwnershipTransferred(address(0), msgSender);
861     }
862 
863     /**
864      * @dev Returns the address of the current owner.
865      */
866     function owner() public view virtual returns (address) {
867         return _owner;
868     }
869 
870     /**
871      * @dev Throws if called by any account other than the owner.
872      */
873     modifier onlyOwner() {
874         require(owner() == _msgSender(), "Ownable: caller is not the owner");
875         _;
876     }
877 
878     /**
879      * @dev Leaves the contract without owner. It will not be possible to call
880      * `onlyOwner` functions anymore. Can only be called by the current owner.
881      *
882      * NOTE: Renouncing ownership will leave the contract without an owner,
883      * thereby removing any functionality that is only available to the owner.
884      */
885     function renounceOwnership() public virtual onlyOwner {
886         emit OwnershipTransferred(_owner, address(0));
887         _owner = address(0);
888     }
889 
890     /**
891      * @dev Transfers ownership of the contract to a new account (`newOwner`).
892      * Can only be called by the current owner.
893      */
894     function transferOwnership(address newOwner) public virtual onlyOwner {
895         require(newOwner != address(0), "Ownable: new owner is the zero address");
896         emit OwnershipTransferred(_owner, newOwner);
897         _owner = newOwner;
898     }
899     uint256[49] private __gap;
900 }
901 
902 
903 // File @openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol@v3.4.1
904 
905 
906 pragma solidity >=0.6.0 <0.8.0;
907 
908 /**
909  * @dev Contract module that helps prevent reentrant calls to a function.
910  *
911  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
912  * available, which can be applied to functions to make sure there are no nested
913  * (reentrant) calls to them.
914  *
915  * Note that because there is a single `nonReentrant` guard, functions marked as
916  * `nonReentrant` may not call one another. This can be worked around by making
917  * those functions `private`, and then adding `external` `nonReentrant` entry
918  * points to them.
919  *
920  * TIP: If you would like to learn more about reentrancy and alternative ways
921  * to protect against it, check out our blog post
922  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
923  */
924 abstract contract ReentrancyGuardUpgradeable is Initializable {
925     // Booleans are more expensive than uint256 or any type that takes up a full
926     // word because each write operation emits an extra SLOAD to first read the
927     // slot's contents, replace the bits taken up by the boolean, and then write
928     // back. This is the compiler's defense against contract upgrades and
929     // pointer aliasing, and it cannot be disabled.
930 
931     // The values being non-zero value makes deployment a bit more expensive,
932     // but in exchange the refund on every call to nonReentrant will be lower in
933     // amount. Since refunds are capped to a percentage of the total
934     // transaction's gas, it is best to keep them low in cases like this one, to
935     // increase the likelihood of the full refund coming into effect.
936     uint256 private constant _NOT_ENTERED = 1;
937     uint256 private constant _ENTERED = 2;
938 
939     uint256 private _status;
940 
941     function __ReentrancyGuard_init() internal initializer {
942         __ReentrancyGuard_init_unchained();
943     }
944 
945     function __ReentrancyGuard_init_unchained() internal initializer {
946         _status = _NOT_ENTERED;
947     }
948 
949     /**
950      * @dev Prevents a contract from calling itself, directly or indirectly.
951      * Calling a `nonReentrant` function from another `nonReentrant`
952      * function is not supported. It is possible to prevent this from happening
953      * by making the `nonReentrant` function external, and make it call a
954      * `private` function that does the actual work.
955      */
956     modifier nonReentrant() {
957         // On the first call to nonReentrant, _notEntered will be true
958         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
959 
960         // Any calls to nonReentrant after this point will fail
961         _status = _ENTERED;
962 
963         _;
964 
965         // By storing the original value once again, a refund is triggered (see
966         // https://eips.ethereum.org/EIPS/eip-2200)
967         _status = _NOT_ENTERED;
968     }
969     uint256[49] private __gap;
970 }
971 
972 
973 // File contracts/TokensFarm.sol
974 
975 pragma solidity 0.6.12;
976 
977 
978 
979 
980 
981 contract TokensFarm is OwnableUpgradeable, ReentrancyGuardUpgradeable {
982 
983     using SafeMath for uint256;
984     using SafeERC20 for IERC20;
985 
986     // Enums
987     enum EarlyWithdrawPenalty {
988         NO_PENALTY,
989         BURN_REWARDS,
990         REDISTRIBUTE_REWARDS
991     }
992 
993     // Info of each user.
994     struct StakeInfo {
995         // How many tokens the user has provided.
996         uint256 amount;
997         // Reward debt.
998         uint256 rewardDebt;
999         // Time when user deposited.
1000         uint256 depositTime;
1001         // Time when user withdraw
1002         uint256 withdrawTime;
1003         // Address of user
1004         address addressOfUser;
1005     }
1006 
1007     // Address of ERC20 token contract.
1008     IERC20 public tokenStaked;
1009     // Last time number that ERC20s distribution occurs.
1010     uint256 public lastRewardTime;
1011     // Accumulated ERC20s per share, times 1e18.
1012     uint256 public accERC20PerShare;
1013     // Total tokens deposited in the farm.
1014     uint256 public totalDeposits;
1015     // If contractor allows early withdraw on stakes
1016     bool public isEarlyWithdrawAllowed;
1017     // Minimal period of time to stake
1018     uint256 public minTimeToStake;
1019     // Address of the ERC20 Token contract.
1020     IERC20 public erc20;
1021     // The total amount of ERC20 that's paid out as reward.
1022     uint256 public paidOut;
1023     // ERC20 tokens rewarded per second.
1024     uint256 public rewardPerSecond;
1025     // Total rewards added to farm
1026     uint256 public totalFundedRewards;
1027     // Total current rewards
1028     uint256 public totalRewards;
1029     // Info of each user that stakes ERC20 tokens.
1030     mapping(address => StakeInfo[]) public stakeInfo;
1031     // The time when farming starts.
1032     uint256 public startTime;
1033     // The time when farming ends.
1034     uint256 public endTime;
1035     // Early withdraw penalty
1036     EarlyWithdrawPenalty public penalty;
1037     // Stake fee percent
1038     uint256 public stakeFeePercent;
1039     // Reward fee percent
1040     uint256 public rewardFeePercent;
1041     // Fee collector address
1042     address payable public feeCollector;
1043     // Flat fee amount
1044     uint256 public flatFeeAmount;
1045     // Fee option
1046     bool public isFlatFeeAllowed;
1047     // Total tokens burned
1048     uint256 public totalTokensBurned;
1049     // Total fee collected
1050     uint256 public totalFeeCollectedETH;
1051     // Total fee collected in tokens
1052     uint256 public totalFeeCollectedTokens;
1053     // Address of farm instance
1054     address public farmImplementation;
1055     // NumberOfUsers participating in farm
1056     uint256 public noOfUsers;
1057     // Addresses of all users that are currently participating
1058     address[] public participants;
1059     // Mapping of every users spot in array
1060     mapping(address => uint256) public id;
1061 
1062     // Events
1063     event Deposit(
1064         address indexed user,
1065         uint256 indexed stakeId,
1066         uint256 indexed amount
1067     );
1068     event Withdraw(
1069         address indexed user,
1070         uint256 indexed stakeId,
1071         uint256 indexed amount
1072     );
1073     event EmergencyWithdraw(
1074         address indexed user,
1075         uint256 indexed stakeId,
1076         uint256 indexed amount
1077     );
1078     event EarlyWithdrawPenaltySet(EarlyWithdrawPenalty indexed penalty);
1079     event MinTimeToStakeSet(uint256 indexed minTimeToStake);
1080     event IsEarlyWithdrawAllowedSet(bool indexed allowed);
1081     event StakeFeePercentSet(uint256 indexed stakeFeePercent);
1082     event RewardFeePercentSet(uint256 indexed rewardFeePercent);
1083     event FlatFeeAmountSet(uint256 indexed flatFeeAmount);
1084     event IsFlatFeeAllowedSet(bool indexed allowed);
1085     event FeeCollectorSet(address payable indexed feeCollector);
1086 
1087     // Modifiers
1088     modifier validateStakeByStakeId(address _user, uint256 stakeId) {
1089         require(stakeId < stakeInfo[_user].length, "Stake does not exist");
1090         _;
1091     }
1092 
1093     /**
1094      * @notice function sets initial state of contract
1095      *
1096      * @param _erc20 - address of reward token
1097      * @param _rewardPerSecond - number of reward per second
1098      * @param _startTime - beginning of farm
1099      * @param _minTimeToStake - how much time needs to pass before staking
1100      * @param _isEarlyWithdrawAllowed - is early withdraw allowed or not
1101      * @param _penalty - ENUM(what type of penalty)
1102      * @param _tokenStaked - address of token which is staked
1103      * @param _stakeFeePercent - fee percent for staking
1104      * @param _rewardFeePercent - fee percent for reward distribution
1105      * @param _flatFeeAmount - flat fee amount
1106      * @param _isFlatFeeAllowed - is flat fee  allowed or not
1107      */
1108     function initialize(
1109         address _erc20,
1110         uint256 _rewardPerSecond,
1111         uint256 _startTime,
1112         uint256 _minTimeToStake,
1113         bool _isEarlyWithdrawAllowed,
1114         uint256 _penalty,
1115         address _tokenStaked,
1116         uint256 _stakeFeePercent,
1117         uint256 _rewardFeePercent,
1118         uint256 _flatFeeAmount,
1119         address payable _feeCollector,
1120         bool _isFlatFeeAllowed,
1121         address _farmImplementation
1122     )
1123         external
1124         initializer
1125     {
1126         // Upgrading ownership
1127         __Ownable_init();
1128         __ReentrancyGuard_init();
1129 
1130         // Requires for correct initialization
1131         require(_erc20 != address(0x0), "Wrong token address.");
1132         require(_rewardPerSecond > 0, "Rewards per second must be > 0.");
1133         require(
1134             _startTime >= block.timestamp,
1135             "Start time can not be in the past."
1136         );
1137         require(_stakeFeePercent < 100, "Stake fee must be < 100.");
1138         require(_rewardFeePercent < 100, "Reward fee must be < 100.");
1139         require(
1140             _feeCollector != address(0x0),
1141             "Wrong fee collector address."
1142         );
1143 
1144         // Initialization of contract
1145         erc20 = IERC20(_erc20);
1146         rewardPerSecond = _rewardPerSecond;
1147         startTime = _startTime;
1148         endTime = _startTime;
1149         minTimeToStake = _minTimeToStake;
1150         isEarlyWithdrawAllowed = _isEarlyWithdrawAllowed;
1151         stakeFeePercent = _stakeFeePercent;
1152         rewardFeePercent = _rewardFeePercent;
1153         flatFeeAmount = _flatFeeAmount;
1154         feeCollector = _feeCollector;
1155         isFlatFeeAllowed = _isFlatFeeAllowed;
1156         farmImplementation = _farmImplementation;
1157 
1158         _setEarlyWithdrawPenalty(_penalty);
1159         _addPool(IERC20(_tokenStaked));
1160     }
1161 
1162     // All Internal functions
1163 
1164     /**
1165      * @notice function is adding a new ERC20 token to the pool
1166      *
1167      * @param _tokenStaked - address of token staked
1168      */
1169     function _addPool(
1170         IERC20 _tokenStaked
1171     )
1172         internal
1173     {
1174         require(
1175             address(_tokenStaked) != address(0x0),
1176             "Must input valid address."
1177         );
1178         require(
1179             address(tokenStaked) == address(0x0),
1180             "Pool can be set only once."
1181         );
1182 
1183         uint256 _lastRewardTime = block.timestamp > startTime
1184             ? block.timestamp
1185             : startTime;
1186 
1187         tokenStaked = _tokenStaked;
1188         lastRewardTime = _lastRewardTime;
1189         accERC20PerShare = 0;
1190         totalDeposits = 0;
1191     }
1192 
1193     /**
1194      * @notice function is setting early withdrawal penalty, if applicable
1195      *
1196      * @param _penalty - number of penalty
1197      */
1198     function _setEarlyWithdrawPenalty(
1199         uint256 _penalty
1200     )
1201         internal
1202     {
1203         penalty = EarlyWithdrawPenalty(_penalty);
1204         emit EarlyWithdrawPenaltySet(penalty);
1205     }
1206 
1207     /**
1208     * @notice function is adding participant from farm
1209     *
1210     * @param user - address of user
1211     *
1212     * @return boolean - if adding is successful or not
1213     */
1214     function _addParticipant(
1215         address user
1216     )
1217         internal
1218         returns(bool)
1219     {
1220         uint256 totalAmount = 0;
1221         for(uint256 i = 0; i < stakeInfo[user].length; i++){
1222             totalAmount += stakeInfo[user][i].amount;
1223         }
1224 
1225         if(totalAmount > 0){
1226             return false;
1227         }
1228 
1229         id[user] = noOfUsers;
1230         noOfUsers++;
1231         participants.push(user);
1232 
1233         return true;
1234     }
1235 
1236     /**
1237      * @notice function is removing participant from farm
1238      *
1239      * @param user - address of user
1240      * @param amount - how many is user withdrawing
1241      *
1242      * @return boolean - if removal is successful or not
1243      */
1244     function _removeParticipant(
1245         address user,
1246         uint256 amount
1247     )
1248         internal
1249         returns(bool)
1250     {
1251         uint256 totalAmount;
1252 
1253         if(noOfUsers == 1){
1254             totalAmount = 0;
1255             for(uint256 i = 0; i < stakeInfo[user].length; i++){
1256                 totalAmount += stakeInfo[user][i].amount;
1257             }
1258 
1259             if(amount == totalAmount){
1260                 delete id[user];
1261                 participants.pop();
1262                 noOfUsers--;
1263 
1264                 return true;
1265             }
1266         }
1267         else{
1268             totalAmount = 0;
1269             for(uint256 i = 0; i < stakeInfo[user].length; i++){
1270                 totalAmount += stakeInfo[user][i].amount;
1271             }
1272 
1273             if(amount == totalAmount){
1274                 uint256 deletedUserId = id[user];
1275                 address lastUserInParticipantsArray = participants[participants.length - 1];
1276                 participants[deletedUserId] = lastUserInParticipantsArray;
1277                 id[lastUserInParticipantsArray] = deletedUserId;
1278 
1279                 delete id[user];
1280                 participants.pop();
1281                 noOfUsers--;
1282 
1283                 return true;
1284             }
1285         }
1286 
1287         return false;
1288     }
1289 
1290     // All setter's functions
1291 
1292     /**
1293      * @notice function is setting new minimum time to stake value
1294      *
1295      * @param _minTimeToStake - min time to stake
1296      */
1297     function setMinTimeToStake(
1298         uint256 _minTimeToStake
1299     )
1300         external
1301         onlyOwner
1302     {
1303         minTimeToStake = _minTimeToStake;
1304         emit MinTimeToStakeSet(minTimeToStake);
1305     }
1306 
1307     /**
1308      * @notice function is setting new state of early withdraw
1309      *
1310      * @param _isEarlyWithdrawAllowed - is early withdraw allowed or not
1311      */
1312     function setIsEarlyWithdrawAllowed(
1313         bool _isEarlyWithdrawAllowed
1314     )
1315         external
1316         onlyOwner
1317     {
1318         isEarlyWithdrawAllowed = _isEarlyWithdrawAllowed;
1319         emit IsEarlyWithdrawAllowedSet(isEarlyWithdrawAllowed);
1320     }
1321 
1322     /**
1323      * @notice function is setting new stake fee percent value
1324      *
1325      * @param _stakeFeePercent - stake fee percent
1326      */
1327     function setStakeFeePercent(
1328         uint256 _stakeFeePercent
1329     )
1330         external
1331         onlyOwner
1332     {
1333         stakeFeePercent = _stakeFeePercent;
1334         emit StakeFeePercentSet(stakeFeePercent);
1335     }
1336 
1337     /**
1338      * @notice function is setting new reward fee percent value
1339      *
1340      * @param _rewardFeePercent - reward fee percent
1341      */
1342     function setRewardFeePercent(
1343         uint256 _rewardFeePercent
1344     )
1345         external
1346         onlyOwner
1347     {
1348         rewardFeePercent = _rewardFeePercent;
1349         emit RewardFeePercentSet(rewardFeePercent);
1350 
1351     }
1352 
1353     /**
1354      * @notice function is setting new flat fee amount
1355      *
1356      * @param _flatFeeAmount - flat fee amount
1357      */
1358     function setFlatFeeAmount(
1359         uint256 _flatFeeAmount
1360     )
1361         external
1362         onlyOwner
1363     {
1364         flatFeeAmount = _flatFeeAmount;
1365         emit FlatFeeAmountSet(flatFeeAmount);
1366     }
1367 
1368     /**
1369      * @notice function is setting flat fee allowed
1370      *
1371      * @param _isFlatFeeAllowed - is flat fee allowed or not
1372      */
1373     function setIsFlatFeeAllowed(
1374         bool _isFlatFeeAllowed
1375     )
1376         external
1377         onlyOwner
1378     {
1379         isFlatFeeAllowed = _isFlatFeeAllowed;
1380         emit IsFlatFeeAllowedSet(isFlatFeeAllowed);
1381     }
1382 
1383     /**
1384      * @notice function is setting feeCollector on new address
1385      *
1386      * @param _feeCollector - address of newFeeCollector
1387      */
1388     function setFeeCollector(
1389         address payable _feeCollector
1390     )
1391         external
1392         onlyOwner
1393     {
1394         feeCollector = _feeCollector;
1395         emit FeeCollectorSet(feeCollector);
1396     }
1397 
1398     // All view functions
1399 
1400     /**
1401      * @notice function is getting number to see deposited ERC20 token for a user.
1402      *
1403      * @param _user - address of user
1404      * @param stakeId - id of user stake
1405      *
1406      * @return deposited ERC20 token for a user
1407      */
1408     function deposited(
1409         address _user,
1410         uint256 stakeId
1411     )
1412         public
1413         view
1414         validateStakeByStakeId(_user, stakeId)
1415         returns (uint256)
1416     {
1417         StakeInfo memory  stake = stakeInfo[_user][stakeId];
1418         return stake.amount;
1419     }
1420 
1421     /**
1422      * @notice function is getting number to see pending ERC20s for a user.
1423      *
1424      * @dev pending reward =
1425      * (user.amount * pool.accERC20PerShare) - user.rewardDebt
1426      *
1427      * @param _user - address of user
1428      * @param stakeId - id of user stake
1429      *
1430      * @return pending ERC20s for a user.
1431      */
1432     function pending(
1433         address _user,
1434         uint256 stakeId
1435     )
1436         public
1437         view
1438         validateStakeByStakeId(_user, stakeId)
1439         returns (uint256)
1440     {
1441         StakeInfo memory stake = stakeInfo[_user][stakeId];
1442 
1443         if (stake.amount == 0) {
1444             return 0;
1445         }
1446 
1447         uint256 _accERC20PerShare = accERC20PerShare;
1448         uint256 tokenSupply = totalDeposits;
1449 
1450         if (block.timestamp > lastRewardTime && tokenSupply != 0) {
1451             uint256 lastTime = block.timestamp < endTime
1452                 ? block.timestamp
1453                 : endTime;
1454             uint256 timeToCompare = lastRewardTime < endTime
1455                 ? lastRewardTime
1456                 : endTime;
1457             uint256 nrOfSeconds = lastTime.sub(timeToCompare);
1458             uint256 erc20Reward = nrOfSeconds.mul(rewardPerSecond);
1459             _accERC20PerShare = _accERC20PerShare.add(
1460                 erc20Reward.mul(1e18).div(tokenSupply)
1461             );
1462         }
1463 
1464         return
1465             stake.amount.mul(_accERC20PerShare).div(1e18).sub(stake.rewardDebt);
1466     }
1467 
1468     /**
1469      * @notice function is getting number to see deposit timestamp for a user.
1470      *
1471      * @param _user - address of user
1472      * @param stakeId - id of user stake
1473      *
1474      * @return time when user deposited specific stake
1475      */
1476     function depositTimestamp(
1477         address _user,
1478         uint256 stakeId
1479     )
1480         public
1481         view
1482         validateStakeByStakeId(_user, stakeId)
1483         returns (uint256)
1484     {
1485         StakeInfo memory stake = stakeInfo[_user][stakeId];
1486         return stake.depositTime;
1487     }
1488 
1489     /**
1490      * @notice function is getting number to see withdraw timestamp for a user.
1491      *
1492      * @param _user - address of user
1493      * @param stakeId - id of user stake
1494      *
1495      * @return time when user withdraw specific stake
1496      */
1497     function withdrawTimestamp(
1498         address _user,
1499         uint256 stakeId
1500     )
1501         public
1502         view
1503         validateStakeByStakeId(_user, stakeId)
1504         returns (uint256)
1505     {
1506         StakeInfo memory stake = stakeInfo[_user][stakeId];
1507         return stake.withdrawTime;
1508     }
1509 
1510     /**
1511      * @notice function is getting number for total rewards the farm has yet to pay out.
1512      *
1513      * @return how many total reward the farm has yet to pay out.
1514      */
1515     function totalPending()
1516         external
1517         view
1518         returns (uint256)
1519     {
1520         if (block.timestamp <= startTime) {
1521             return 0;
1522         }
1523 
1524         uint256 lastTime = block.timestamp < endTime
1525             ? block.timestamp
1526             : endTime;
1527         return rewardPerSecond.mul(lastTime - startTime).sub(paidOut);
1528     }
1529 
1530     /**
1531      * @notice function is getting number of stakes user has
1532      *
1533      * @param user - address of user
1534      *
1535      * @return how many times has user staked tokens
1536      */
1537     function getNumberOfUserStakes(
1538         address user
1539     )
1540         external
1541         view
1542         returns (uint256)
1543     {
1544         return stakeInfo[user].length;
1545     }
1546 
1547     /**
1548      * @notice function is getting user pending amounts, stakes and deposit time
1549      *
1550      * @param user - address of user
1551      *
1552      * @return array of deposits,pendingAmounts and depositTime
1553      */
1554     function getUserStakesAndPendingAmounts(
1555         address user
1556     )
1557         external
1558         view
1559         returns (
1560             uint256[] memory,
1561             uint256[] memory,
1562             uint256[] memory
1563         )
1564     {
1565         uint256 numberOfStakes = stakeInfo[user].length;
1566 
1567         uint256[] memory deposits = new uint256[](numberOfStakes);
1568         uint256[] memory pendingAmounts = new uint256[](numberOfStakes);
1569         uint256[] memory depositTime = new uint256[](numberOfStakes);
1570 
1571         for(uint256 i = 0; i < numberOfStakes; i++){
1572             deposits[i] = deposited(user, i);
1573             pendingAmounts[i] = pending(user, i);
1574             depositTime[i] = depositTimestamp(user, i);
1575         }
1576 
1577         return (deposits, pendingAmounts, depositTime);
1578     }
1579 
1580     /**
1581      * @notice function is getting total rewards locked/unlocked
1582      *
1583      * @return totalRewardsUnlocked
1584      * @return totalRewardsLocked
1585      */
1586     function getTotalRewardsLockedUnlocked()
1587         external
1588         view
1589         returns (uint256, uint256)
1590     {
1591         uint256 totalRewardsLocked;
1592         uint256 totalRewardsUnlocked;
1593 
1594         if (block.timestamp <= startTime) {
1595             totalRewardsUnlocked = 0;
1596             totalRewardsLocked = totalFundedRewards;
1597         } else {
1598             uint256 lastTime = block.timestamp < endTime
1599                 ? block.timestamp
1600                 : endTime;
1601             totalRewardsUnlocked = rewardPerSecond.mul(lastTime - startTime);
1602             totalRewardsLocked = totalRewards - totalRewardsUnlocked;
1603         }
1604 
1605         return (totalRewardsUnlocked, totalRewardsLocked);
1606     }
1607 
1608     // Money managing functions
1609 
1610     /**
1611      * @notice function is funding the farm, increase the end time
1612      *
1613      * @param _amount - how many tokens is funded
1614      */
1615     function fund(
1616         uint256 _amount
1617     )
1618         external
1619     {
1620         uint256 balanceBefore = erc20.balanceOf(address(this));
1621         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
1622         uint256 balanceAfter = erc20.balanceOf(address(this));
1623 
1624         uint256 fundAmount;
1625         if(balanceAfter.sub(balanceBefore) <= _amount){
1626             fundAmount = balanceAfter.sub(balanceBefore);
1627         }
1628         else{
1629             fundAmount = _amount;
1630         }
1631 
1632         totalFundedRewards = totalFundedRewards.add(fundAmount);
1633         _fundInternal(fundAmount);
1634     }
1635 
1636     /**
1637      * @notice function is internally funding the farm,
1638      * by adding farmed rewards by user to the end
1639      *
1640      * @param _amount - how many tokens is funded
1641      */
1642     function _fundInternal(
1643         uint256 _amount
1644     )
1645         internal
1646     {
1647         require(
1648             block.timestamp < endTime,
1649             "fund: too late, the farm is closed"
1650         );
1651         require(_amount > 0, "Amount must be greater than 0.");
1652         // Compute new end time
1653         endTime += _amount.div(rewardPerSecond);
1654         // Increase farm total rewards
1655         totalRewards = totalRewards.add(_amount);
1656     }
1657 
1658     /**
1659      * @notice function is updating reward,
1660      * variables of the given pool to be up-to-date.
1661      */
1662     function updatePool()
1663         public
1664     {
1665         uint256 lastTime = block.timestamp < endTime
1666             ? block.timestamp
1667             : endTime;
1668 
1669         if (lastTime <= lastRewardTime) {
1670             return;
1671         }
1672 
1673         uint256 tokenSupply = totalDeposits;
1674 
1675         if (tokenSupply == 0) {
1676             lastRewardTime = lastTime;
1677             return;
1678         }
1679 
1680         uint256 nrOfSeconds = lastTime.sub(lastRewardTime);
1681         uint256 erc20Reward = nrOfSeconds.mul(rewardPerSecond);
1682 
1683         accERC20PerShare = accERC20PerShare.add(
1684             erc20Reward.mul(1e18).div(tokenSupply)
1685         );
1686         lastRewardTime = block.timestamp;
1687     }
1688 
1689     /**
1690      * @notice function is depositing ERC20 tokens to Farm for ERC20 allocation.
1691      *
1692      * @param _amount - how many tokens user is depositing
1693      */
1694     function deposit(
1695         uint256 _amount
1696     )
1697         external
1698         nonReentrant
1699         payable
1700     {
1701         require(
1702             block.timestamp < endTime,
1703             "Deposit: too late, the farm is closed"
1704         );
1705 
1706         StakeInfo memory stake;
1707         uint256 stakedAmount;
1708 
1709         // Update pool
1710         updatePool();
1711 
1712         uint256 beforeBalance = tokenStaked.balanceOf(address(this));
1713         tokenStaked.safeTransferFrom(
1714             address(msg.sender),
1715             address(this),
1716             _amount
1717         );
1718         uint256 afterBalance = tokenStaked.balanceOf(address(this));
1719 
1720         if(afterBalance.sub(beforeBalance) <= _amount){
1721             stakedAmount = afterBalance.sub(beforeBalance);
1722         }
1723         else{
1724             stakedAmount = _amount;
1725         }
1726 
1727         if (isFlatFeeAllowed) {
1728             // Collect flat fee
1729             require(
1730                 msg.value >= flatFeeAmount,
1731                 "Payable amount is less than fee amount."
1732             );
1733 
1734             totalFeeCollectedETH = totalFeeCollectedETH.add(msg.value);
1735         } else if (stakeFeePercent > 0) {
1736             // Handle this case only if flat fee is not allowed, and stakeFeePercent > 0
1737             // Compute the fee
1738             uint256 feeAmount = stakedAmount.mul(stakeFeePercent).div(100);
1739             // Compute stake amount
1740             stakedAmount = stakedAmount.sub(feeAmount);
1741             totalFeeCollectedTokens = totalFeeCollectedTokens.add(feeAmount);
1742         }
1743 
1744         // Increase total deposits
1745         totalDeposits = totalDeposits.add(stakedAmount);
1746         // Update user accounting
1747         stake.amount = stakedAmount;
1748         stake.rewardDebt = stake.amount.mul(accERC20PerShare).div(1e18);
1749         stake.depositTime = block.timestamp;
1750         stake.addressOfUser = address(msg.sender);
1751         stake.withdrawTime = 0;
1752 
1753         _addParticipant(address(msg.sender));
1754 
1755         // Compute stake id
1756         uint256 stakeId = stakeInfo[msg.sender].length;
1757         // Push new stake to array of stakes for user
1758         stakeInfo[msg.sender].push(stake);
1759         // Emit deposit event
1760         emit Deposit(msg.sender, stakeId, stakedAmount);
1761     }
1762 
1763     // All withdraw functions
1764 
1765     /**
1766      * @notice function is withdrawing with caring about rewards
1767      *
1768      * @param _amount - how many tokens wants to be withdrawn
1769      * @param stakeId - Id of user stake
1770      */
1771     function withdraw(
1772         uint256 _amount,
1773         uint256 stakeId
1774     )
1775         external
1776         nonReentrant
1777         payable
1778         validateStakeByStakeId(msg.sender, stakeId)
1779     {
1780         bool minimalTimeStakeRespected;
1781         StakeInfo storage stake = stakeInfo[msg.sender][stakeId];
1782 
1783         require(
1784             stake.amount >= _amount,
1785             "withdraw: can't withdraw more than deposit"
1786         );
1787 
1788         updatePool();
1789 
1790         minimalTimeStakeRespected =
1791             stake.depositTime.add(minTimeToStake) <= block.timestamp;
1792 
1793         // if early withdraw is not allowed, user can't withdraw funds before
1794         if (!isEarlyWithdrawAllowed) {
1795             // Check if user has respected minimal time to stake, require it.
1796             require(
1797                 minimalTimeStakeRespected,
1798                 "User can not withdraw funds yet."
1799             );
1800         }
1801 
1802         // Compute pending rewards amount of user rewards
1803         uint256 pendingAmount = stake
1804             .amount
1805             .mul(accERC20PerShare)
1806             .div(1e18)
1807             .sub(stake.rewardDebt);
1808 
1809         // Penalties in case user didn't stake enough time
1810         if (pendingAmount > 0) {
1811             if (
1812                 penalty == EarlyWithdrawPenalty.BURN_REWARDS &&
1813                 !minimalTimeStakeRespected
1814             ) {
1815                 // Burn to address (1)
1816                 totalTokensBurned = totalTokensBurned.add(pendingAmount);
1817                 _erc20Transfer(address(1), pendingAmount);
1818                 // Update totalRewards
1819                 totalRewards = totalRewards.sub(pendingAmount);
1820             } else if (
1821                 penalty == EarlyWithdrawPenalty.REDISTRIBUTE_REWARDS &&
1822                 !minimalTimeStakeRespected
1823             ) {
1824                 if (block.timestamp >= endTime) {
1825                     // Burn rewards because farm can not be funded anymore since it ended
1826                     _erc20Transfer(address(1), pendingAmount);
1827                     totalTokensBurned = totalTokensBurned.add(pendingAmount);
1828                     // Update totalRewards
1829                     totalRewards = totalRewards.sub(pendingAmount);
1830                 } else {
1831                     // Re-fund the farm
1832                     _fundInternal(pendingAmount);
1833                 }
1834             } else {
1835                 // In case either there's no penalty
1836                 _erc20Transfer(msg.sender, pendingAmount);
1837                 // Update totalRewards
1838                 totalRewards = totalRewards.sub(pendingAmount);
1839             }
1840         }
1841 
1842         _removeParticipant(address(msg.sender), _amount);
1843 
1844         stake.withdrawTime = block.timestamp;
1845         stake.amount = stake.amount.sub(_amount);
1846         stake.rewardDebt = stake.amount.mul(accERC20PerShare).div(1e18);
1847 
1848         tokenStaked.safeTransfer(address(msg.sender), _amount);
1849         totalDeposits = totalDeposits.sub(_amount);
1850 
1851         // Emit Withdraw event
1852         emit Withdraw(msg.sender, stakeId, _amount);
1853     }
1854 
1855     /**
1856      * @notice function is withdrawing without caring about rewards. EMERGENCY ONLY.
1857      *
1858      * @param stakeId - Id of user stake
1859      */
1860     function emergencyWithdraw(
1861         uint256 stakeId
1862     )
1863         external
1864         nonReentrant
1865         validateStakeByStakeId(msg.sender, stakeId)
1866     {
1867         StakeInfo storage stake = stakeInfo[msg.sender][stakeId];
1868 
1869         // if early withdraw is not allowed, user can't withdraw funds before
1870         if (!isEarlyWithdrawAllowed) {
1871             bool minimalTimeStakeRespected = stake.depositTime.add(
1872                 minTimeToStake
1873             ) <= block.timestamp;
1874             // Check if user has respected minimal time to stake, require it.
1875             require(
1876                 minimalTimeStakeRespected,
1877                 "User can not withdraw funds yet."
1878             );
1879         }
1880 
1881         tokenStaked.safeTransfer(address(msg.sender), stake.amount);
1882         totalDeposits = totalDeposits.sub(stake.amount);
1883 
1884         _removeParticipant(address(msg.sender), stake.amount);
1885         stake.withdrawTime = block.timestamp;
1886 
1887         emit EmergencyWithdraw(msg.sender, stakeId, stake.amount);
1888 
1889         stake.amount = 0;
1890         stake.rewardDebt = 0;
1891     }
1892 
1893     /**
1894      * @notice function is withdrawing fee collected in ERC value
1895      */
1896     function withdrawCollectedFeesERC()
1897         external
1898         onlyOwner
1899     {
1900         erc20.transfer(feeCollector, totalFeeCollectedTokens);
1901         totalFeeCollectedTokens = 0;
1902     }
1903 
1904     /**
1905      * @notice function is withdrawing fee collected in ETH value
1906      */
1907     function withdrawCollectedFeesETH()
1908         external
1909         onlyOwner
1910     {
1911         (bool sent, ) = payable(feeCollector).call{value: totalFeeCollectedETH}("");
1912         require(sent, "Failed to end flat fee");
1913         totalFeeCollectedETH = 0;
1914     }
1915 
1916     /**
1917      * @notice function is withdrawing tokens if stuck
1918      *
1919      * @param _erc20 - address of token address
1920      * @param _amount - number of how many tokens
1921      * @param _beneficiary - address of user that collects tokens deposited by mistake
1922      */
1923     function withdrawTokensIfStuck(
1924         address _erc20,
1925         uint256 _amount,
1926         address _beneficiary
1927     )
1928         external
1929         onlyOwner
1930     {
1931         IERC20 token = IERC20(_erc20);
1932         require(tokenStaked != token, "User tokens can not be pulled");
1933         require(
1934             _beneficiary != address(0x0),
1935             "_beneficiary can not be 0x0 address"
1936         );
1937 
1938         token.safeTransfer(_beneficiary, _amount);
1939     }
1940 
1941     /**
1942      * @notice function is transferring ERC20,
1943      * and update the required ERC20 to payout all rewards
1944      *
1945      * @param _to - transfer on this address
1946      * @param _amount - number of how many tokens
1947      */
1948     function _erc20Transfer(
1949         address _to,
1950         uint256 _amount
1951     )
1952         internal
1953     {
1954         if (isFlatFeeAllowed) {
1955             // Collect flat fee
1956             require(
1957                 msg.value >= flatFeeAmount,
1958                 "Payable amount is less than fee amount."
1959             );
1960             // Increase amount of fees collected
1961             totalFeeCollectedETH = totalFeeCollectedETH.add(msg.value);
1962             // send reward
1963             erc20.transfer(_to, _amount);
1964             paidOut += _amount;
1965         } else if (stakeFeePercent > 0) {
1966             // Collect reward fee
1967             uint256 feeAmount = _amount.mul(rewardFeePercent).div(100);
1968             uint256 rewardAmount = _amount.sub(feeAmount);
1969 
1970             // Increase amount of fees collected
1971             totalFeeCollectedTokens = totalFeeCollectedTokens.add(feeAmount);
1972 
1973             // send reward
1974             erc20.transfer(_to, rewardAmount);
1975             paidOut += _amount;
1976         } else {
1977             erc20.transfer(_to, _amount);
1978             paidOut += _amount;
1979         }
1980     }
1981 }