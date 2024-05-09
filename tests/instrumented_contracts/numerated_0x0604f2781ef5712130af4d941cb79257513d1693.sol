1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-26
3 */
4 
5 // File: @openzeppelin/contracts/utils/Address.sol
6 
7 // SPDX-License-Identifier: MIT 
8 
9 pragma solidity >=0.6.2 <0.8.0;
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      */
32     function isContract(address account) internal view returns (bool) {
33         // This method relies on extcodesize, which returns 0 for contracts in
34         // construction, since the code is only stored at the end of the
35         // constructor execution.
36 
37         uint256 size;
38         // solhint-disable-next-line no-inline-assembly
39         assembly { size := extcodesize(account) }
40         return size > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
63         (bool success, ) = recipient.call{ value: amount }("");
64         require(success, "Address: unable to send value, recipient may have reverted");
65     }
66 
67     /**
68      * @dev Performs a Solidity function call using a low level `call`. A
69      * plain`call` is an unsafe replacement for a function call: use this
70      * function instead.
71      *
72      * If `target` reverts with a revert reason, it is bubbled up by this
73      * function (like regular Solidity function calls).
74      *
75      * Returns the raw returned data. To convert to the expected return value,
76      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
77      *
78      * Requirements:
79      *
80      * - `target` must be a contract.
81      * - calling `target` with `data` must not revert.
82      *
83      * _Available since v3.1._
84      */
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86       return functionCall(target, data, "Address: low-level call failed");
87     }
88 
89     /**
90      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
91      * `errorMessage` as a fallback revert reason when `target` reverts.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, 0, errorMessage);
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
101      * but also transferring `value` wei to `target`.
102      *
103      * Requirements:
104      *
105      * - the calling contract must have an ETH balance of at least `value`.
106      * - the called Solidity function must be `payable`.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
116      * with `errorMessage` as a fallback revert reason when `target` reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
121         require(address(this).balance >= value, "Address: insufficient balance for call");
122         require(isContract(target), "Address: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = target.call{ value: value }(data);
126         return _verifyCallResult(success, returndata, errorMessage);
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
131      * but performing a static call.
132      *
133      * _Available since v3.3._
134      */
135     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
136         return functionStaticCall(target, data, "Address: low-level static call failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
146         require(isContract(target), "Address: static call to non-contract");
147 
148         // solhint-disable-next-line avoid-low-level-calls
149         (bool success, bytes memory returndata) = target.staticcall(data);
150         return _verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a delegate call.
156      *
157      * _Available since v3.4._
158      */
159     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a delegate call.
166      *
167      * _Available since v3.4._
168      */
169     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
170         require(isContract(target), "Address: delegate call to non-contract");
171 
172         // solhint-disable-next-line avoid-low-level-calls
173         (bool success, bytes memory returndata) = target.delegatecall(data);
174         return _verifyCallResult(success, returndata, errorMessage);
175     }
176 
177     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
178         if (success) {
179             return returndata;
180         } else {
181             // Look for revert reason and bubble it up if present
182             if (returndata.length > 0) {
183                 // The easiest way to bubble the revert reason is using memory via assembly
184 
185                 // solhint-disable-next-line no-inline-assembly
186                 assembly {
187                     let returndata_size := mload(returndata)
188                     revert(add(32, returndata), returndata_size)
189                 }
190             } else {
191                 revert(errorMessage);
192             }
193         }
194     }
195 }
196 
197 // File: @openzeppelin/contracts/math/SafeMath.sol
198 
199  
200 
201 pragma solidity >=0.6.0 <0.8.0;
202 
203 /**
204  * @dev Wrappers over Solidity's arithmetic operations with added overflow
205  * checks.
206  *
207  * Arithmetic operations in Solidity wrap on overflow. This can easily result
208  * in bugs, because programmers usually assume that an overflow raises an
209  * error, which is the standard behavior in high level programming languages.
210  * `SafeMath` restores this intuition by reverting the transaction when an
211  * operation overflows.
212  *
213  * Using this library instead of the unchecked operations eliminates an entire
214  * class of bugs, so it's recommended to use it always.
215  */
216 library SafeMath {
217     /**
218      * @dev Returns the addition of two unsigned integers, with an overflow flag.
219      *
220      * _Available since v3.4._
221      */
222     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         uint256 c = a + b;
224         if (c < a) return (false, 0);
225         return (true, c);
226     }
227 
228     /**
229      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
230      *
231      * _Available since v3.4._
232      */
233     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
234         if (b > a) return (false, 0);
235         return (true, a - b);
236     }
237 
238     /**
239      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
240      *
241      * _Available since v3.4._
242      */
243     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
244         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
245         // benefit is lost if 'b' is also tested.
246         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
247         if (a == 0) return (true, 0);
248         uint256 c = a * b;
249         if (c / a != b) return (false, 0);
250         return (true, c);
251     }
252 
253     /**
254      * @dev Returns the division of two unsigned integers, with a division by zero flag.
255      *
256      * _Available since v3.4._
257      */
258     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         if (b == 0) return (false, 0);
260         return (true, a / b);
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
265      *
266      * _Available since v3.4._
267      */
268     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         if (b == 0) return (false, 0);
270         return (true, a % b);
271     }
272 
273     /**
274      * @dev Returns the addition of two unsigned integers, reverting on
275      * overflow.
276      *
277      * Counterpart to Solidity's `+` operator.
278      *
279      * Requirements:
280      *
281      * - Addition cannot overflow.
282      */
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         uint256 c = a + b;
285         require(c >= a, "SafeMath: addition overflow");
286         return c;
287     }
288 
289     /**
290      * @dev Returns the subtraction of two unsigned integers, reverting on
291      * overflow (when the result is negative).
292      *
293      * Counterpart to Solidity's `-` operator.
294      *
295      * Requirements:
296      *
297      * - Subtraction cannot overflow.
298      */
299     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
300         require(b <= a, "SafeMath: subtraction overflow");
301         return a - b;
302     }
303 
304     /**
305      * @dev Returns the multiplication of two unsigned integers, reverting on
306      * overflow.
307      *
308      * Counterpart to Solidity's `*` operator.
309      *
310      * Requirements:
311      *
312      * - Multiplication cannot overflow.
313      */
314     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
315         if (a == 0) return 0;
316         uint256 c = a * b;
317         require(c / a == b, "SafeMath: multiplication overflow");
318         return c;
319     }
320 
321     /**
322      * @dev Returns the integer division of two unsigned integers, reverting on
323      * division by zero. The result is rounded towards zero.
324      *
325      * Counterpart to Solidity's `/` operator. Note: this function uses a
326      * `revert` opcode (which leaves remaining gas untouched) while Solidity
327      * uses an invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function div(uint256 a, uint256 b) internal pure returns (uint256) {
334         require(b > 0, "SafeMath: division by zero");
335         return a / b;
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * reverting when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         require(b > 0, "SafeMath: modulo by zero");
352         return a % b;
353     }
354 
355     /**
356      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
357      * overflow (when the result is negative).
358      *
359      * CAUTION: This function is deprecated because it requires allocating memory for the error
360      * message unnecessarily. For custom revert reasons use {trySub}.
361      *
362      * Counterpart to Solidity's `-` operator.
363      *
364      * Requirements:
365      *
366      * - Subtraction cannot overflow.
367      */
368     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         require(b <= a, errorMessage);
370         return a - b;
371     }
372 
373     /**
374      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
375      * division by zero. The result is rounded towards zero.
376      *
377      * CAUTION: This function is deprecated because it requires allocating memory for the error
378      * message unnecessarily. For custom revert reasons use {tryDiv}.
379      *
380      * Counterpart to Solidity's `/` operator. Note: this function uses a
381      * `revert` opcode (which leaves remaining gas untouched) while Solidity
382      * uses an invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      *
386      * - The divisor cannot be zero.
387      */
388     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
389         require(b > 0, errorMessage);
390         return a / b;
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * reverting with custom message when dividing by zero.
396      *
397      * CAUTION: This function is deprecated because it requires allocating memory for the error
398      * message unnecessarily. For custom revert reasons use {tryMod}.
399      *
400      * Counterpart to Solidity's `%` operator. This function uses a `revert`
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402      * invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
409         require(b > 0, errorMessage);
410         return a % b;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
415 
416  
417 
418 pragma solidity >=0.6.0 <0.8.0;
419 
420 /**
421  * @dev Interface of the ERC20 standard as defined in the EIP.
422  */
423 interface IERC20 {
424     /**
425      * @dev Returns the amount of tokens in existence.
426      */
427     function totalSupply() external view returns (uint256);
428 
429     /**
430      * @dev Returns the amount of tokens owned by `account`.
431      */
432     function balanceOf(address account) external view returns (uint256);
433 
434     /**
435      * @dev Moves `amount` tokens from the caller's account to `recipient`.
436      *
437      * Returns a boolean value indicating whether the operation succeeded.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transfer(address recipient, uint256 amount) external returns (bool);
442 
443     /**
444      * @dev Returns the remaining number of tokens that `spender` will be
445      * allowed to spend on behalf of `owner` through {transferFrom}. This is
446      * zero by default.
447      *
448      * This value changes when {approve} or {transferFrom} are called.
449      */
450     function allowance(address owner, address spender) external view returns (uint256);
451 
452     /**
453      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
454      *
455      * Returns a boolean value indicating whether the operation succeeded.
456      *
457      * IMPORTANT: Beware that changing an allowance with this method brings the risk
458      * that someone may use both the old and the new allowance by unfortunate
459      * transaction ordering. One possible solution to mitigate this race
460      * condition is to first reduce the spender's allowance to 0 and set the
461      * desired value afterwards:
462      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address spender, uint256 amount) external returns (bool);
467 
468     /**
469      * @dev Moves `amount` tokens from `sender` to `recipient` using the
470      * allowance mechanism. `amount` is then deducted from the caller's
471      * allowance.
472      *
473      * Returns a boolean value indicating whether the operation succeeded.
474      *
475      * Emits a {Transfer} event.
476      */
477     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
478 
479     /**
480      * @dev Emitted when `value` tokens are moved from one account (`from`) to
481      * another (`to`).
482      *
483      * Note that `value` may be zero.
484      */
485     event Transfer(address indexed from, address indexed to, uint256 value);
486 
487     /**
488      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
489      * a call to {approve}. `value` is the new allowance.
490      */
491     event Approval(address indexed owner, address indexed spender, uint256 value);
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
495 
496  
497 
498 pragma solidity >=0.6.0 <0.8.0;
499 
500 
501 
502 
503 /**
504  * @title SafeERC20
505  * @dev Wrappers around ERC20 operations that throw on failure (when the token
506  * contract returns false). Tokens that return no value (and instead revert or
507  * throw on failure) are also supported, non-reverting calls are assumed to be
508  * successful.
509  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
510  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
511  */
512 library SafeERC20 {
513     using SafeMath for uint256;
514     using Address for address;
515 
516     function safeTransfer(IERC20 token, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
518     }
519 
520     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
521         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
522     }
523 
524     /**
525      * @dev Deprecated. This function has issues similar to the ones found in
526      * {IERC20-approve}, and its usage is discouraged.
527      *
528      * Whenever possible, use {safeIncreaseAllowance} and
529      * {safeDecreaseAllowance} instead.
530      */
531     function safeApprove(IERC20 token, address spender, uint256 value) internal {
532         // safeApprove should only be called when setting an initial allowance,
533         // or when resetting it to zero. To increase and decrease it, use
534         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
535         // solhint-disable-next-line max-line-length
536         require((value == 0) || (token.allowance(address(this), spender) == 0),
537             "SafeERC20: approve from non-zero to non-zero allowance"
538         );
539         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
540     }
541 
542     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
543         uint256 newAllowance = token.allowance(address(this), spender).add(value);
544         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
545     }
546 
547     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
548         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
549         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
550     }
551 
552     /**
553      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
554      * on the return value: the return value is optional (but if data is returned, it must not be false).
555      * @param token The token targeted by the call.
556      * @param data The call data (encoded using abi.encode or one of its variants).
557      */
558     function _callOptionalReturn(IERC20 token, bytes memory data) private {
559         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
560         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
561         // the target address contains contract code and also asserts for success in the low-level call.
562 
563         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
564         if (returndata.length > 0) { // Return data is optional
565             // solhint-disable-next-line max-line-length
566             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
567         }
568     }
569 }
570 
571 // File: localhost/contract/library/ErrorCode.sol
572 
573  
574 
575 pragma solidity 0.7.4;
576 
577 library ErrorCode {
578 
579     string constant FORBIDDEN = 'YouSwap:FORBIDDEN';
580     string constant IDENTICAL_ADDRESSES = 'YouSwap:IDENTICAL_ADDRESSES';
581     string constant ZERO_ADDRESS = 'YouSwap:ZERO_ADDRESS';
582     string constant INVALID_ADDRESSES = 'YouSwap:INVALID_ADDRESSES';
583     string constant BALANCE_INSUFFICIENT = 'YouSwap:BALANCE_INSUFFICIENT';
584     string constant REWARDTOTAL_LESS_THAN_REWARDPROVIDE = 'YouSwap:REWARDTOTAL_LESS_THAN_REWARDPROVIDE';
585     string constant PARAMETER_TOO_LONG = 'YouSwap:PARAMETER_TOO_LONG';
586     string constant REGISTERED = 'YouSwap:REGISTERED';
587     string constant MINING_NOT_STARTED = 'YouSwap:MINING_NOT_STARTED';
588     string constant END_OF_MINING = 'YouSwap:END_OF_MINING';
589     string constant POOL_NOT_EXIST_OR_END_OF_MINING = 'YouSwap:POOL_NOT_EXIST_OR_END_OF_MINING';
590     
591 }
592 // File: localhost/contract/interface/IYouswapInviteV1.sol
593 
594  
595 
596 pragma solidity 0.7.4;
597 
598 interface IYouswapInviteV1 {
599 
600     struct UserInfo {
601         address upper;//上级
602         address[] lowers;//下级
603         uint256 startBlock;//邀请块高
604     }
605 
606     event InviteV1(address indexed owner, address indexed upper, uint256 indexed height);//被邀请人的地址，邀请人的地址，邀请块高
607 
608     function inviteCount() external view returns (uint256);//邀请人数
609 
610     function inviteUpper1(address) external view returns (address);//上级邀请
611 
612     function inviteUpper2(address) external view returns (address, address);//上级邀请
613 
614     function inviteLower1(address) external view returns (address[] memory);//下级邀请
615 
616     function inviteLower2(address) external view returns (address[] memory, address[] memory);//下级邀请
617 
618     function inviteLower2Count(address) external view returns (uint256, uint256);//下级邀请
619     
620     function register() external returns (bool);//注册邀请关系
621 
622     function acceptInvitation(address) external returns (bool);//注册邀请关系
623     
624     function inviteBatch(address[] memory) external returns (uint, uint);//注册邀请关系：输入数量，成功数量
625 
626 }
627 // File: localhost/contract/implement/YouswapInviteV1.sol
628 
629  
630 
631 pragma solidity 0.7.4;
632 
633 
634 
635 contract YouswapInviteV1 is IYouswapInviteV1 {
636 
637     address public constant ZERO = address(0);
638     uint256 public startBlock;
639     address[] public inviteUserInfoV1;
640     mapping(address => UserInfo) public inviteUserInfoV2;
641 
642     constructor () {
643         startBlock = block.number;
644     }
645     
646     function inviteCount() override external view returns (uint256) {
647         return inviteUserInfoV1.length;
648     }
649 
650     function inviteUpper1(address _owner) override external view returns (address) {
651         return inviteUserInfoV2[_owner].upper;
652     }
653 
654     function inviteUpper2(address _owner) override external view returns (address, address) {
655         address upper1 = inviteUserInfoV2[_owner].upper;
656         address upper2 = address(0);
657         if (address(0) != upper1) {
658             upper2 = inviteUserInfoV2[upper1].upper;
659         }
660 
661         return (upper1, upper2);
662     }
663 
664     function inviteLower1(address _owner) override external view returns (address[] memory) {
665         return inviteUserInfoV2[_owner].lowers;
666     }
667 
668     function inviteLower2(address _owner) override external view returns (address[] memory, address[] memory) {
669         address[] memory lowers1 = inviteUserInfoV2[_owner].lowers;
670         uint256 count = 0;
671         uint256 lowers1Len = lowers1.length;
672         for (uint256 i = 0; i < lowers1Len; i++) {
673             count += inviteUserInfoV2[lowers1[i]].lowers.length;
674         }
675         address[] memory lowers;
676         address[] memory lowers2 = new address[](count);
677         count = 0;
678         for (uint256 i = 0; i < lowers1Len; i++) {
679             lowers = inviteUserInfoV2[lowers1[i]].lowers;
680             for (uint256 j = 0; j < lowers.length; j++) {
681                 lowers2[count] = lowers[j];
682                 count++;
683             }
684         }
685         
686         return (lowers1, lowers2);
687     }
688 
689     function inviteLower2Count(address _owner) override external view returns (uint256, uint256) {
690         address[] memory lowers1 = inviteUserInfoV2[_owner].lowers;
691         uint256 lowers2Len = 0;
692         uint256 len = lowers1.length;
693         for (uint256 i = 0; i < len; i++) {
694             lowers2Len += inviteUserInfoV2[lowers1[i]].lowers.length;
695         }
696         
697         return (lowers1.length, lowers2Len);
698     }
699 
700     function register() override external returns (bool) {
701         UserInfo storage user = inviteUserInfoV2[tx.origin];
702         require(0 == user.startBlock, ErrorCode.REGISTERED);
703         user.upper = ZERO;
704         user.startBlock = block.number;
705         inviteUserInfoV1.push(tx.origin);
706         
707         emit InviteV1(tx.origin, user.upper, user.startBlock);
708         
709         return true;
710     }
711 
712     function acceptInvitation(address _inviter) override external returns (bool) {
713         require(msg.sender != _inviter, ErrorCode.FORBIDDEN);
714         UserInfo storage user = inviteUserInfoV2[msg.sender];
715         require(0 == user.startBlock, ErrorCode.REGISTERED);
716         UserInfo storage upper = inviteUserInfoV2[_inviter];
717         if (0 == upper.startBlock) {
718             upper.upper = ZERO;
719             upper.startBlock = block.number;
720             inviteUserInfoV1.push(_inviter);
721             
722             emit InviteV1(_inviter, upper.upper, upper.startBlock);
723         }
724         user.upper = _inviter;
725         upper.lowers.push(msg.sender);
726         user.startBlock = block.number;
727         inviteUserInfoV1.push(msg.sender);
728         
729         emit InviteV1(msg.sender, user.upper, user.startBlock);
730 
731         return true;
732     }
733 
734     function inviteBatch(address[] memory _invitees) override external returns (uint, uint) {
735         uint len = _invitees.length;
736         require(len <= 100, ErrorCode.PARAMETER_TOO_LONG);
737         UserInfo storage user = inviteUserInfoV2[msg.sender];
738         if (0 == user.startBlock) {
739             user.upper = ZERO;
740             user.startBlock = block.number;
741             inviteUserInfoV1.push(msg.sender);
742                         
743             emit InviteV1(msg.sender, user.upper, user.startBlock);
744         }
745         uint count = 0;
746         for (uint i = 0; i < len; i++) {
747             if ((address(0) != _invitees[i]) && (msg.sender != _invitees[i])) {
748                 UserInfo storage lower = inviteUserInfoV2[_invitees[i]];
749                 if (0 == lower.startBlock) {
750                     lower.upper = msg.sender;
751                     lower.startBlock = block.number;
752                     user.lowers.push(_invitees[i]);
753                     inviteUserInfoV1.push(_invitees[i]);
754                     count++;
755 
756                     emit InviteV1(_invitees[i], msg.sender, lower.startBlock);
757                 }
758             }
759         }
760 
761         return (len, count);
762     }
763 
764 }
765 // File: localhost/contract/interface/ITokenYou.sol
766 
767  
768 
769 pragma solidity 0.7.4;
770 
771 interface ITokenYou {
772     
773     function mint(address recipient, uint256 amount) external;
774     
775     function decimals() external view returns (uint8);
776     
777 }
778 
779 // File: localhost/contract/interface/IYouswapFactoryV1.sol
780 
781  
782 
783 pragma solidity 0.7.4;
784 
785 
786 
787 /**
788 挖矿
789  */
790 interface IYouswapFactoryV1 {
791     
792     /**
793     用户挖矿信息
794      */
795     struct RewardInfo {
796         uint256 receiveReward;//总领取奖励
797         uint256 inviteReward;//总邀请奖励
798         uint256 pledgeReward;//总质押奖励
799     }
800 
801     /**
802     质押用户信息
803      */
804     struct UserInfo {
805         uint256 startBlock;//质押开始块高
806         uint256 amount;//质押数量
807         uint256 invitePower;//邀请算力
808         uint256 pledgePower;//质押算力
809         uint256 pendingReward;//待领取奖励
810         uint256 inviteRewardDebt;//邀请负债
811         uint256 pledgeRewardDebt;//质押负债
812     }
813 
814     /**
815     矿池信息（可视化）
816      */
817     struct PoolViewInfo {
818         address lp;//LP地址
819         string name;//名称
820         uint256 multiple;//奖励倍数
821         uint256 priority;//排序
822     }
823 
824     /**
825     矿池信息
826      */
827     struct PoolInfo {
828         uint256 startBlock;//挖矿开始块高
829         uint256 rewardTotal;//矿池总奖励
830         uint256 rewardProvide;//矿池已发放奖励
831         address lp;//lp合约地址
832         uint256 amount;//质押数量
833         uint256 lastRewardBlock;//最后发放奖励块高
834         uint256 rewardPerBlock;//单个区块奖励
835         uint256 totalPower;//总算力
836         uint256 endBlock;//挖矿结束块高
837         uint256 rewardPerShare;//单位算力奖励
838     }
839 
840     ////////////////////////////////////////////////////////////////////////////////////
841     
842     /**
843     自邀请
844     self：Sender地址
845      */
846     event InviteRegister(address indexed self);
847 
848     /**
849     更新矿池信息
850 
851     action：true(新建矿池)，false(更新矿池)
852     pool：矿池序号
853     lp：lp合约地址
854     name：矿池名称
855     startBlock：矿池开始挖矿块高
856     rewardTotal：矿池总奖励
857     rewardPerBlock：区块奖励
858     multiple：矿池奖励倍数
859     priority：矿池排序
860      */
861     event UpdatePool(bool action, uint256 pool, address indexed lp, string name, uint256 startBlock, uint256 rewardTotal, uint256 rewardPerBlock, uint256 multiple, uint256 priority);
862 
863     /**
864     矿池挖矿结束
865     
866     pool：矿池序号
867     lp：lp合约地址
868      */
869     event EndPool(uint256 pool, address indexed lp);
870     
871     /**
872     质押
873 
874     pool：矿池序号
875     lp：lp合约地址
876     from：质押转出地址
877     amount：质押数量
878      */
879     event Stake(uint256 pool, address indexed lp, address indexed from, uint256 amount);
880 
881     /**
882     pool：矿池序号
883     lp：lp合约地址
884     totalPower：矿池总算力
885     owner：用户地址
886     ownerInvitePower：用户邀请算力
887     ownerPledgePower：用户质押算力
888     upper1：上1级地址
889     upper1InvitePower：上1级邀请算力
890     upper2：上2级地址
891     upper2InvitePower：上2级邀请算力
892      */
893     event UpdatePower(uint256 pool, address lp, uint256 totalPower, address indexed owner, uint256 ownerInvitePower, uint256 ownerPledgePower, address indexed upper1, uint256 upper1InvitePower, address indexed upper2, uint256 upper2InvitePower);
894 
895     //算力
896 
897     /**
898     解质押
899     
900     pool：矿池序号
901     lp：lp合约地址
902     to：解质押转入地址
903     amount：解质押数量
904      */
905     event UnStake(uint256 pool, address indexed lp, address indexed to, uint256 amount);
906     
907     /**
908     提取奖励
909 
910     pool：矿池序号
911     lp：lp合约地址
912     to：奖励转入地址
913     amount：奖励数量
914      */
915     event WithdrawReward(uint256 pool, address indexed lp, address indexed to, uint256 amount);
916     
917     /**
918     挖矿
919 
920     pool：矿池序号
921     lp：lp合约地址
922     amount：奖励数量
923      */
924     event Mint(uint256 pool, address indexed lp, uint256 amount);
925     
926     ////////////////////////////////////////////////////////////////////////////////////
927 
928     /**
929     修改OWNER
930      */
931     function transferOwnership(address) external;
932 
933     /**
934     设置YOU
935      */
936     function setYou(ITokenYou) external;
937 
938     /**
939     设置邀请关系
940      */
941     function setInvite(YouswapInviteV1) external;
942     
943     /**
944     质押
945     */
946     function deposit(uint256, uint256) external;
947     
948     /**
949     解质押、提取奖励
950      */
951     function withdraw(uint256, uint256) external;
952 
953     /**
954     矿池质押地址
955      */
956     function poolPledgeAddresss(uint256) external view returns (address[] memory);
957 
958     /**
959     算力占比
960      */
961     function powerScale(uint256, address) external view returns (uint256);
962 
963     /**
964     待领取的奖励
965      */
966     function pendingReward(uint256, address) external view returns (uint256);
967 
968     /**
969     下级收益贡献
970      */
971     function rewardContribute(address, address) external view returns (uint256);
972 
973     /**
974     个人收益加成
975      */
976     function selfReward(address) external view returns (uint256);
977 
978     /**
979     通过lp查询矿池编号
980      */
981     function poolNumbers(address) external view returns (uint256[] memory);
982 
983     /**
984     设置运营权限
985      */
986     function setOperateOwner(address, bool) external;
987 
988     ////////////////////////////////////////////////////////////////////////////////////    
989     
990     /**
991     新建矿池
992      */
993     function addPool(string memory, address, uint256, uint256) external returns (bool);
994         
995     /**
996     修改矿池区块奖励
997      */
998     function setRewardPerBlock(uint256, uint256) external;
999 
1000     /**
1001     修改矿池总奖励
1002      */
1003     function setRewardTotal(uint256, uint256) external;
1004 
1005     /**
1006     修改矿池名称
1007      */
1008     function setName(uint256, string memory) external;
1009     
1010     /**
1011     修改矿池倍数
1012      */
1013     function setMultiple(uint256, uint256) external;
1014     
1015     /**
1016     修改矿池排序
1017      */
1018     function setPriority(uint256, uint256) external;
1019     
1020     ////////////////////////////////////////////////////////////////////////////////////
1021     
1022 }
1023 // File: localhost/contract/implement/YouswapFactoryV1.sol
1024 
1025  
1026 
1027 pragma solidity 0.7.4;
1028 
1029 
1030 
1031 
1032 
1033 contract YouswapFactoryV1 is IYouswapFactoryV1 {
1034 
1035     using SafeMath for uint256;
1036     using SafeERC20 for IERC20;
1037     
1038     uint256 public deployBlock;//合约部署块高
1039     address public owner;//所有权限
1040     mapping(address => bool) public operateOwner;//运营权限
1041     ITokenYou public you;//you contract
1042     YouswapInviteV1 public invite;//invite contract
1043 
1044     uint256 public poolCount = 0;//矿池数量
1045     mapping(address => RewardInfo) public rewardInfos;//用户挖矿信息
1046     mapping(uint256 => PoolInfo) public poolInfos;//矿池信息
1047     mapping(uint256 => PoolViewInfo) public poolViewInfos;//矿池信息
1048     mapping(uint256 => address[]) public pledgeAddresss;//矿池质押地址
1049     mapping(uint256 => mapping(address => UserInfo)) public pledgeUserInfo;//矿池质押用户信息
1050 
1051     uint256 public constant inviteSelfReward = 5;//质押自奖励，5%
1052     uint256 public constant invite1Reward = 15;//1级邀请奖励，15%
1053     uint256 public constant invite2Reward = 10;//2级邀请奖励，10%
1054     uint256 public constant rewardPerBlock = 267094;//区块奖励
1055     uint256 public rewardTotal = 0;//总挖矿奖励
1056 
1057     constructor (ITokenYou _you, YouswapInviteV1 _invite) {
1058         deployBlock = block.number;
1059         owner = msg.sender;
1060         invite = _invite;
1061         _setOperateOwner(owner, true);
1062         _setYou(_you);
1063     }
1064 
1065     ////////////////////////////////////////////////////////////////////////////////////
1066 
1067     function transferOwnership(address _owner) override external {
1068         require(owner == msg.sender, ErrorCode.FORBIDDEN);
1069         require((address(0) != _owner) && (owner != _owner), ErrorCode.INVALID_ADDRESSES);
1070         _setOperateOwner(owner, false);
1071         _setOperateOwner(_owner, true);
1072         owner = _owner;
1073     }
1074 
1075     function setYou(ITokenYou _you) override external {
1076         _setYou(_you);
1077     }
1078     
1079     function _setYou(ITokenYou _you) internal {
1080         require(owner == msg.sender, ErrorCode.FORBIDDEN);
1081         you = _you;
1082     }
1083 
1084     function setInvite(YouswapInviteV1 _invite) override external {
1085         require(owner == msg.sender, ErrorCode.FORBIDDEN);
1086         invite = _invite;
1087     }
1088     
1089     function deposit(uint256 _pool, uint256 _amount) override external {
1090         require(0 < _amount, ErrorCode.FORBIDDEN);
1091         PoolInfo storage poolInfo = poolInfos[_pool];
1092         require((address(0) != poolInfo.lp) && (poolInfo.startBlock <= block.number), ErrorCode.MINING_NOT_STARTED);
1093         //require(0 == poolInfo.endBlock, ErrorCode.END_OF_MINING);
1094         (, uint256 startBlock) = invite.inviteUserInfoV2(msg.sender);
1095         if (0 == startBlock) {
1096             invite.register();
1097             
1098             emit InviteRegister(msg.sender);
1099         }
1100 
1101         IERC20(poolInfo.lp).safeTransferFrom(msg.sender, address(this), _amount);
1102 
1103         (address upper1, address upper2) = invite.inviteUpper2(msg.sender);
1104 
1105         computeReward(_pool);
1106 
1107         provideReward(_pool, poolInfo.rewardPerShare, poolInfo.lp, msg.sender, upper1, upper2);
1108 
1109         addPower(_pool, msg.sender, _amount, upper1, upper2);
1110 
1111         setRewardDebt(_pool, poolInfo.rewardPerShare, msg.sender, upper1, upper2);
1112 
1113         emit Stake(_pool, poolInfo.lp, msg.sender, _amount);
1114     }
1115 
1116     function withdraw(uint256 _pool, uint256 _amount) override external {
1117         PoolInfo storage poolInfo = poolInfos[_pool];
1118         require((address(0) != poolInfo.lp) && (poolInfo.startBlock <= block.number), ErrorCode.MINING_NOT_STARTED);
1119         if (0 < _amount) {
1120             UserInfo storage userInfo = pledgeUserInfo[_pool][msg.sender];
1121             require(_amount <= userInfo.amount, ErrorCode.BALANCE_INSUFFICIENT);
1122             IERC20(poolInfo.lp).safeTransfer(msg.sender, _amount);
1123 
1124             emit UnStake(_pool, poolInfo.lp, msg.sender, _amount);
1125         }
1126 
1127         (address _upper1, address _upper2) = invite.inviteUpper2(msg.sender);
1128 
1129         computeReward(_pool);
1130 
1131         provideReward(_pool, poolInfo.rewardPerShare, poolInfo.lp, msg.sender, _upper1, _upper2);
1132 
1133         if (0 < _amount) {
1134             subPower(_pool, msg.sender, _amount, _upper1, _upper2);
1135         }
1136 
1137         setRewardDebt(_pool, poolInfo.rewardPerShare, msg.sender, _upper1, _upper2);
1138     }
1139 
1140     function poolPledgeAddresss(uint256 _pool) override external view returns (address[] memory) {
1141         return pledgeAddresss[_pool];
1142     }
1143 
1144     function computeReward(uint256 _pool) internal {
1145         PoolInfo storage poolInfo = poolInfos[_pool];
1146         if ((0 < poolInfo.totalPower) && (poolInfo.rewardProvide < poolInfo.rewardTotal)) {
1147             uint256 reward = (block.number - poolInfo.lastRewardBlock).mul(poolInfo.rewardPerBlock);
1148             if (poolInfo.rewardProvide.add(reward) > poolInfo.rewardTotal) {
1149                 reward = poolInfo.rewardTotal.sub(poolInfo.rewardProvide);
1150                 poolInfo.endBlock = block.number;
1151             }
1152 
1153             rewardTotal = rewardTotal.add(reward);
1154             poolInfo.rewardProvide = poolInfo.rewardProvide.add(reward);
1155             poolInfo.rewardPerShare = poolInfo.rewardPerShare.add(reward.mul(1e24).div(poolInfo.totalPower));
1156             poolInfo.lastRewardBlock = block.number;
1157 
1158             emit Mint(_pool, poolInfo.lp, reward);
1159 
1160             if (0 < poolInfo.endBlock) {
1161                 emit EndPool(_pool, poolInfo.lp);
1162             }
1163         }
1164     }
1165 
1166     function addPower(uint256 _pool, address _user, uint256 _amount, address _upper1, address _upper2) internal {
1167         PoolInfo storage poolInfo = poolInfos[_pool];
1168         poolInfo.amount = poolInfo.amount.add(_amount);
1169 
1170         uint256 pledgePower = _amount;
1171         UserInfo storage userInfo = pledgeUserInfo[_pool][_user];            
1172         userInfo.amount = userInfo.amount.add(_amount);
1173         userInfo.pledgePower = userInfo.pledgePower.add(pledgePower);
1174         poolInfo.totalPower = poolInfo.totalPower.add(pledgePower);
1175         if (0 == userInfo.startBlock) {
1176             userInfo.startBlock = block.number;
1177             pledgeAddresss[_pool].push(msg.sender);
1178         }
1179         
1180         uint256 upper1InvitePower = 0;
1181         uint256 upper2InvitePower = 0;
1182 
1183         if (address(0) != _upper1) {
1184             uint256 inviteSelfPower = pledgePower.mul(inviteSelfReward).div(100);
1185             userInfo.invitePower = userInfo.invitePower.add(inviteSelfPower);
1186             poolInfo.totalPower = poolInfo.totalPower.add(inviteSelfPower);
1187 
1188             uint256 invite1Power = pledgePower.mul(invite1Reward).div(100);
1189             UserInfo storage upper1Info = pledgeUserInfo[_pool][_upper1];            
1190             upper1Info.invitePower = upper1Info.invitePower.add(invite1Power);
1191             upper1InvitePower = upper1Info.invitePower;
1192             poolInfo.totalPower = poolInfo.totalPower.add(invite1Power);
1193             if (0 == upper1Info.startBlock) {
1194                 upper1Info.startBlock = block.number;
1195                 pledgeAddresss[_pool].push(_upper1);
1196             }
1197         }
1198 
1199         if (address(0) != _upper2) {
1200             uint256 invite2Power = pledgePower.mul(invite2Reward).div(100);
1201             UserInfo storage upper2Info = pledgeUserInfo[_pool][_upper2];            
1202             upper2Info.invitePower = upper2Info.invitePower.add(invite2Power);
1203             upper2InvitePower = upper2Info.invitePower;
1204             poolInfo.totalPower = poolInfo.totalPower.add(invite2Power);
1205             if (0 == upper2Info.startBlock) {
1206                 upper2Info.startBlock = block.number;
1207                 pledgeAddresss[_pool].push(_upper2);
1208             }
1209         }
1210         
1211         emit UpdatePower(_pool, poolInfo.lp, poolInfo.totalPower, _user, userInfo.invitePower, userInfo.pledgePower, _upper1, upper1InvitePower, _upper2, upper2InvitePower);
1212     }
1213 
1214     function subPower(uint256 _pool, address _user, uint256 _amount, address _upper1, address _upper2) internal {
1215         PoolInfo storage poolInfo = poolInfos[_pool];
1216         UserInfo storage userInfo = pledgeUserInfo[_pool][_user];
1217         poolInfo.amount = poolInfo.amount.sub(_amount);
1218 
1219         uint256 pledgePower = _amount;
1220         userInfo.amount = userInfo.amount.sub(_amount);
1221         userInfo.pledgePower = userInfo.pledgePower.sub(pledgePower);
1222         poolInfo.totalPower = poolInfo.totalPower.sub(pledgePower);
1223 
1224         uint256 upper1InvitePower = 0;
1225         uint256 upper2InvitePower = 0;
1226 
1227         if (address(0) != _upper1) {
1228             uint256 inviteSelfPower = pledgePower.mul(inviteSelfReward).div(100);
1229             userInfo.invitePower = userInfo.invitePower.sub(inviteSelfPower);
1230             poolInfo.totalPower = poolInfo.totalPower.sub(inviteSelfPower);
1231 
1232             UserInfo storage upper1Info = pledgeUserInfo[_pool][_upper1];
1233             if (0 < upper1Info.startBlock) {
1234                 uint256 invite1Power = pledgePower.mul(invite1Reward).div(100);
1235                 upper1Info.invitePower = upper1Info.invitePower.sub(invite1Power);
1236                 upper1InvitePower = upper1Info.invitePower;
1237                 poolInfo.totalPower = poolInfo.totalPower.sub(invite1Power);
1238 
1239                 if (address(0) != _upper2) {
1240                     UserInfo storage upper2Info = pledgeUserInfo[_pool][_upper2];
1241                     if (0 < upper2Info.startBlock) {
1242                         uint256 invite2Power = pledgePower.mul(invite2Reward).div(100);
1243                         upper2Info.invitePower = upper2Info.invitePower.sub(invite2Power);
1244                         upper2InvitePower = upper2Info.invitePower;
1245                         poolInfo.totalPower = poolInfo.totalPower.sub(invite2Power);
1246                     }
1247                 }
1248             }
1249         }
1250 
1251         emit UpdatePower(_pool, poolInfo.lp, poolInfo.totalPower, _user, userInfo.invitePower, userInfo.pledgePower, _upper1, upper1InvitePower, _upper2, upper2InvitePower);
1252     }
1253 
1254     function provideReward(uint256 _pool, uint256 _rewardPerShare, address _lp, address _user, address _upper1, address _upper2) internal {
1255         uint256 inviteReward = 0;
1256         uint256 pledgeReward = 0;
1257         UserInfo storage userInfo = pledgeUserInfo[_pool][_user];
1258         if ((0 < userInfo.invitePower) || (0 < userInfo.pledgePower)) {
1259             inviteReward = userInfo.invitePower.mul(_rewardPerShare).sub(userInfo.inviteRewardDebt).div(1e24);
1260             pledgeReward = userInfo.pledgePower.mul(_rewardPerShare).sub(userInfo.pledgeRewardDebt).div(1e24);
1261 
1262             userInfo.pendingReward = userInfo.pendingReward.add(inviteReward.add(pledgeReward));
1263 
1264             RewardInfo storage userRewardInfo = rewardInfos[_user];
1265             userRewardInfo.inviteReward = userRewardInfo.inviteReward.add(inviteReward);
1266             userRewardInfo.pledgeReward = userRewardInfo.pledgeReward.add(pledgeReward);
1267         }
1268 
1269         if (0 < userInfo.pendingReward) {
1270             you.mint(_user, userInfo.pendingReward);
1271             
1272             RewardInfo storage userRewardInfo = rewardInfos[_user];
1273             userRewardInfo.receiveReward = userRewardInfo.inviteReward;
1274             
1275             emit WithdrawReward(_pool, _lp, _user, userInfo.pendingReward);
1276 
1277             userInfo.pendingReward = 0;
1278         }
1279 
1280         if (address(0) != _upper1) {
1281             UserInfo storage upper1Info = pledgeUserInfo[_pool][_upper1];
1282             if ((0 < upper1Info.invitePower) || (0 < upper1Info.pledgePower)) {
1283                 inviteReward = upper1Info.invitePower.mul(_rewardPerShare).sub(upper1Info.inviteRewardDebt).div(1e24);
1284                 pledgeReward = upper1Info.pledgePower.mul(_rewardPerShare).sub(upper1Info.pledgeRewardDebt).div(1e24);
1285                 
1286                 upper1Info.pendingReward = upper1Info.pendingReward.add(inviteReward.add(pledgeReward));
1287 
1288                 RewardInfo storage upper1RewardInfo = rewardInfos[_upper1];
1289                 upper1RewardInfo.inviteReward = upper1RewardInfo.inviteReward.add(inviteReward);
1290                 upper1RewardInfo.pledgeReward = upper1RewardInfo.pledgeReward.add(pledgeReward);
1291             }
1292 
1293             if (address(0) != _upper2) {
1294                 UserInfo storage upper2Info = pledgeUserInfo[_pool][_upper2];
1295                 if ((0 < upper2Info.invitePower) || (0 < upper2Info.pledgePower)) {
1296                     inviteReward = upper2Info.invitePower.mul(_rewardPerShare).sub(upper2Info.inviteRewardDebt).div(1e24);
1297                     pledgeReward = upper2Info.pledgePower.mul(_rewardPerShare).sub(upper2Info.pledgeRewardDebt).div(1e24);
1298 
1299                     upper2Info.pendingReward = upper2Info.pendingReward.add(inviteReward.add(pledgeReward));
1300 
1301                     RewardInfo storage upper2RewardInfo = rewardInfos[_upper2];
1302                     upper2RewardInfo.inviteReward = upper2RewardInfo.inviteReward.add(inviteReward);
1303                     upper2RewardInfo.pledgeReward = upper2RewardInfo.pledgeReward.add(pledgeReward);
1304                 }
1305             }
1306         }
1307     }
1308 
1309     function setRewardDebt(uint256 _pool, uint256 _rewardPerShare, address _user, address _upper1, address _upper2) internal {
1310         UserInfo storage userInfo = pledgeUserInfo[_pool][_user];
1311         userInfo.inviteRewardDebt = userInfo.invitePower.mul(_rewardPerShare);
1312         userInfo.pledgeRewardDebt = userInfo.pledgePower.mul(_rewardPerShare);
1313 
1314         if (address(0) != _upper1) {
1315             UserInfo storage upper1Info = pledgeUserInfo[_pool][_upper1];
1316             upper1Info.inviteRewardDebt = upper1Info.invitePower.mul(_rewardPerShare);
1317             upper1Info.pledgeRewardDebt = upper1Info.pledgePower.mul(_rewardPerShare);
1318 
1319             if (address(0) != _upper2) {
1320                 UserInfo storage upper2Info = pledgeUserInfo[_pool][_upper2];
1321                 upper2Info.inviteRewardDebt = upper2Info.invitePower.mul(_rewardPerShare);
1322                 upper2Info.pledgeRewardDebt = upper2Info.pledgePower.mul(_rewardPerShare);
1323             }
1324         }
1325     }
1326     
1327     function powerScale(uint256 _pool, address _user) override external view returns (uint256) {
1328         PoolInfo memory poolInfo = poolInfos[_pool];
1329         if (0 == poolInfo.totalPower) {
1330             return 0;
1331         }
1332 
1333         UserInfo memory userInfo = pledgeUserInfo[_pool][_user];
1334         return (userInfo.invitePower.add(userInfo.pledgePower).mul(100)).div(poolInfo.totalPower);
1335     }
1336 
1337     function pendingReward(uint256 _pool, address _user) override external view returns (uint256) {
1338         uint256 totalReward = 0;
1339         PoolInfo memory poolInfo = poolInfos[_pool];
1340         if (address(0) != poolInfo.lp && (poolInfo.startBlock <= block.number)) {
1341             uint256 rewardPerShare = 0;
1342             if (0 < poolInfo.totalPower) {
1343                 uint256 reward = (block.number - poolInfo.lastRewardBlock).mul(poolInfo.rewardPerBlock);
1344                 if (poolInfo.rewardProvide.add(reward) > poolInfo.rewardTotal) {
1345                     reward = poolInfo.rewardTotal.sub(poolInfo.rewardProvide);
1346                 }
1347                 rewardPerShare = reward.mul(1e24).div(poolInfo.totalPower);
1348             }
1349             rewardPerShare = rewardPerShare.add(poolInfo.rewardPerShare);
1350 
1351             UserInfo memory userInfo = pledgeUserInfo[_pool][_user];
1352             totalReward = userInfo.pendingReward;
1353             totalReward = totalReward.add(userInfo.invitePower.mul(rewardPerShare).sub(userInfo.inviteRewardDebt).div(1e24));
1354             totalReward = totalReward.add(userInfo.pledgePower.mul(rewardPerShare).sub(userInfo.pledgeRewardDebt).div(1e24));
1355         }
1356 
1357         return totalReward;
1358     }
1359 
1360     function rewardContribute(address _user, address _lower) override external view returns (uint256) {
1361         if ((address(0) == _user) || (address(0) == _lower)) {
1362             return 0;
1363         }
1364 
1365         uint256 inviteReward = 0;
1366         (address upper1, address upper2) = invite.inviteUpper2(_lower);
1367         if (_user == upper1) {
1368             inviteReward = rewardInfos[_lower].pledgeReward.mul(invite1Reward).div(100);
1369         }else if (_user == upper2) {
1370             inviteReward = rewardInfos[_lower].pledgeReward.mul(invite2Reward).div(100);
1371         }
1372         
1373         return inviteReward;
1374     }
1375 
1376     function selfReward(address _user) override external view returns (uint256) {
1377         address upper1 = invite.inviteUpper1(_user);
1378         if (address(0) == upper1) {
1379             return 0;
1380         }
1381 
1382         RewardInfo memory userRewardInfo = rewardInfos[_user];
1383         return userRewardInfo.pledgeReward.mul(inviteSelfReward).div(100);
1384     }
1385 
1386     function poolNumbers(address _lp) override external view returns (uint256[] memory) {
1387         uint256 count = 0;
1388         for (uint256 i = 0; i < poolCount; i++) {
1389             if (_lp == poolViewInfos[i].lp) {
1390                 count = count.add(1);
1391             }
1392         }
1393         
1394         uint256[] memory numbers = new uint256[](count);
1395         count = 0;
1396         for (uint256 i = 0; i < poolCount; i++) {
1397             if (_lp == poolViewInfos[i].lp) {
1398                 numbers[count] = i;
1399                 count = count.add(1);
1400             }
1401         }
1402 
1403         return numbers;
1404     }
1405 
1406     function setOperateOwner(address _address, bool _bool) override external {
1407         _setOperateOwner(_address, _bool);
1408     }
1409     
1410     function _setOperateOwner(address _address, bool _bool) internal {
1411         require(owner == msg.sender, ErrorCode.FORBIDDEN);
1412         operateOwner[_address] = _bool;
1413     }
1414 
1415     ////////////////////////////////////////////////////////////////////////////////////
1416 
1417     function addPool(string memory _name, address _lp, uint256 _startBlock, uint256 _rewardTotal) override external returns (bool) {
1418         require(operateOwner[msg.sender] && (address(0) != _lp) && (address(this) != _lp), ErrorCode.FORBIDDEN);
1419         _startBlock = _startBlock < block.number ? block.number : _startBlock;
1420         uint256 _pool = poolCount;
1421         poolCount = poolCount.add(1);
1422 
1423         PoolViewInfo storage poolViewInfo = poolViewInfos[_pool];
1424         poolViewInfo.lp = _lp;
1425         poolViewInfo.name = _name;
1426         poolViewInfo.multiple = 1;
1427         poolViewInfo.priority = _pool.mul(100);
1428         
1429         PoolInfo storage poolInfo = poolInfos[_pool];
1430         poolInfo.startBlock = _startBlock;
1431         poolInfo.rewardTotal = _rewardTotal;
1432         poolInfo.rewardProvide = 0;
1433         poolInfo.lp = _lp;
1434         poolInfo.amount = 0;
1435         poolInfo.lastRewardBlock = _startBlock.sub(1);
1436         poolInfo.rewardPerBlock = rewardPerBlock;
1437         poolInfo.totalPower = 0;
1438         poolInfo.endBlock = 0;
1439         poolInfo.rewardPerShare = 0;
1440 
1441         emit UpdatePool(true, _pool, poolInfo.lp, poolViewInfo.name, poolInfo.startBlock, poolInfo.rewardTotal, poolInfo.rewardPerBlock, poolViewInfo.multiple, poolViewInfo.priority);
1442 
1443         return true;
1444     }
1445     
1446     function setRewardPerBlock(uint256 _pool, uint256 _rewardPerBlock) override external {
1447         require(operateOwner[msg.sender], ErrorCode.FORBIDDEN);
1448         PoolInfo storage poolInfo = poolInfos[_pool];
1449         require((address(0) != poolInfo.lp) && (0 == poolInfo.endBlock), ErrorCode.POOL_NOT_EXIST_OR_END_OF_MINING);
1450         poolInfo.rewardPerBlock = _rewardPerBlock;
1451 
1452         PoolViewInfo memory poolViewInfo = poolViewInfos[_pool];
1453 
1454         emit UpdatePool(false, _pool, poolInfo.lp, poolViewInfo.name, poolInfo.startBlock, poolInfo.rewardTotal, poolInfo.rewardPerBlock, poolViewInfo.multiple, poolViewInfo.priority);
1455     }
1456     
1457     function setRewardTotal(uint256 _pool, uint256 _rewardTotal) override external {
1458         require(operateOwner[msg.sender], ErrorCode.FORBIDDEN);
1459         PoolInfo storage poolInfo = poolInfos[_pool];
1460         require((address(0) != poolInfo.lp) && (0 == poolInfo.endBlock), ErrorCode.POOL_NOT_EXIST_OR_END_OF_MINING);
1461         require(poolInfo.rewardProvide < _rewardTotal, ErrorCode.REWARDTOTAL_LESS_THAN_REWARDPROVIDE);
1462         poolInfo.rewardTotal = _rewardTotal;
1463 
1464         PoolViewInfo memory poolViewInfo = poolViewInfos[_pool];
1465 
1466         emit UpdatePool(false, _pool, poolInfo.lp, poolViewInfo.name, poolInfo.startBlock, poolInfo.rewardTotal, poolInfo.rewardPerBlock, poolViewInfo.multiple, poolViewInfo.priority);
1467    }
1468 
1469    function setName(uint256 _pool, string memory _name) override external {
1470         require(operateOwner[msg.sender], ErrorCode.FORBIDDEN);
1471         PoolViewInfo storage poolViewInfo = poolViewInfos[_pool];
1472         require(address(0) != poolViewInfo.lp, ErrorCode.POOL_NOT_EXIST_OR_END_OF_MINING);
1473         poolViewInfo.name = _name;
1474 
1475         PoolInfo memory poolInfo = poolInfos[_pool];
1476 
1477         emit UpdatePool(false, _pool, poolInfo.lp, poolViewInfo.name, poolInfo.startBlock, poolInfo.rewardTotal, poolInfo.rewardPerBlock, poolViewInfo.multiple, poolViewInfo.priority);
1478    }
1479 
1480    function setMultiple(uint256 _pool, uint256 _multiple) override external {
1481         require(operateOwner[msg.sender], ErrorCode.FORBIDDEN);
1482         PoolViewInfo storage poolViewInfo = poolViewInfos[_pool];
1483         require(address(0) != poolViewInfo.lp, ErrorCode.POOL_NOT_EXIST_OR_END_OF_MINING);
1484         poolViewInfo.multiple = _multiple;
1485 
1486         PoolInfo memory poolInfo = poolInfos[_pool];
1487 
1488         emit UpdatePool(false, _pool, poolInfo.lp, poolViewInfo.name, poolInfo.startBlock, poolInfo.rewardTotal, poolInfo.rewardPerBlock, poolViewInfo.multiple, poolViewInfo.priority);
1489     }
1490 
1491     function setPriority(uint256 _pool, uint256 _priority) override external {
1492         require(operateOwner[msg.sender], ErrorCode.FORBIDDEN);
1493         PoolViewInfo storage poolViewInfo = poolViewInfos[_pool];
1494         require(address(0) != poolViewInfo.lp, ErrorCode.POOL_NOT_EXIST_OR_END_OF_MINING);
1495         poolViewInfo.priority = _priority;
1496 
1497         PoolInfo memory poolInfo = poolInfos[_pool];
1498 
1499         emit UpdatePool(false, _pool, poolInfo.lp, poolViewInfo.name, poolInfo.startBlock, poolInfo.rewardTotal, poolInfo.rewardPerBlock, poolViewInfo.multiple, poolViewInfo.priority);
1500     }
1501 
1502     ////////////////////////////////////////////////////////////////////////////////////
1503 
1504 }