1 // File: contracts/lib/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.1;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: contracts/lib/IERC20.sol
164 
165 
166 pragma solidity ^0.7.1;
167 
168 /**
169  * @dev Interface of the ERC20 standard as defined in the EIP.
170  */
171 interface IERC20 {
172     /**
173      * @dev Returns the amount of tokens in existence.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     /**
178      * @dev Returns the amount of tokens owned by `account`.
179      */
180     function balanceOf(address account) external view returns (uint256);
181 
182     /**
183      * @dev Moves `amount` tokens from the caller's account to `recipient`.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transfer(address recipient, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Returns the remaining number of tokens that `spender` will be
193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
194      * zero by default.
195      *
196      * This value changes when {approve} or {transferFrom} are called.
197      */
198     function allowance(address owner, address spender) external view returns (uint256);
199 
200     /**
201      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * IMPORTANT: Beware that changing an allowance with this method brings the risk
206      * that someone may use both the old and the new allowance by unfortunate
207      * transaction ordering. One possible solution to mitigate this race
208      * condition is to first reduce the spender's allowance to 0 and set the
209      * desired value afterwards:
210      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address spender, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Moves `amount` tokens from `sender` to `recipient` using the
218      * allowance mechanism. `amount` is then deducted from the caller's
219      * allowance.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Emitted when `value` tokens are moved from one account (`from`) to
229      * another (`to`).
230      *
231      * Note that `value` may be zero.
232      */
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 
235     /**
236      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
237      * a call to {approve}. `value` is the new allowance.
238      */
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 // File: contracts/lib/Address.sol
243 
244 
245 pragma solidity ^0.7.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { size := extcodesize(account) }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322         return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: value }(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return _verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.3._
394      */
395     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
396         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.3._
404      */
405     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
406         require(isContract(target), "Address: delegate call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
414         if (success) {
415             return returndata;
416         } else {
417             // Look for revert reason and bubble it up if present
418             if (returndata.length > 0) {
419                 // The easiest way to bubble the revert reason is using memory via assembly
420 
421                 // solhint-disable-next-line no-inline-assembly
422                 assembly {
423                     let returndata_size := mload(returndata)
424                     revert(add(32, returndata), returndata_size)
425                 }
426             } else {
427                 revert(errorMessage);
428             }
429         }
430     }
431 }
432 
433 // File: contracts/lib/SafeERC20.sol
434 
435 
436 pragma solidity ^0.7.1;
437 
438 
439 
440 
441 /**
442  * @title SafeERC20
443  * @dev Wrappers around ERC20 operations that throw on failure (when the token
444  * contract returns false). Tokens that return no value (and instead revert or
445  * throw on failure) are also supported, non-reverting calls are assumed to be
446  * successful.
447  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
448  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
449  */
450 library SafeERC20 {
451   using SafeMath for uint256;
452   using Address for address;
453 
454   function safeTransfer(IERC20 token, address to, uint256 value) internal {
455     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
456   }
457 
458   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
459     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
460   }
461 
462   /**
463    * @dev Deprecated. This function has issues similar to the ones found in
464    * {IERC20-approve}, and its usage is discouraged.
465    *
466    * Whenever possible, use {safeIncreaseAllowance} and
467    * {safeDecreaseAllowance} instead.
468    */
469   function safeApprove(IERC20 token, address spender, uint256 value) internal {
470     // safeApprove should only be called when setting an initial allowance,
471     // or when resetting it to zero. To increase and decrease it, use
472     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
473     // solhint-disable-next-line max-line-length
474     require((value == 0) || (token.allowance(address(this), spender) == 0),
475       "SafeERC20: approve from non-zero to non-zero allowance"
476     );
477     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
478   }
479 
480   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
481     uint256 newAllowance = token.allowance(address(this), spender).add(value);
482     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
483   }
484 
485   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
486     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
487     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
488   }
489 
490   /**
491    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
492    * on the return value: the return value is optional (but if data is returned, it must not be false).
493    * @param token The token targeted by the call.
494    * @param data The call data (encoded using abi.encode or one of its variants).
495    */
496   function _callOptionalReturn(IERC20 token, bytes memory data) private {
497     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
498     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
499     // the target address contains contract code and also asserts for success in the low-level call.
500 
501     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
502     if (returndata.length > 0) { // Return data is optional
503       // solhint-disable-next-line max-line-length
504       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
505     }
506   }
507 }
508 
509 // File: contracts/DistributionBase.sol
510 
511 
512 pragma solidity ^0.7.1;
513 
514 
515 
516 
517 contract DistributionBase {
518 
519   using SafeERC20 for IERC20;
520   using SafeMath for uint256;
521 
522   bool public redeem_allowed;
523   bool public deposit_done;
524 
525   address public governance;
526   address public fund_rescue;
527 
528   // Existing on-chain contracts
529   IERC20 public underlying_token;
530   IERC20 public lp_token;
531 
532   uint public total_distribution_amount;
533 
534   constructor(address _underlying_token, address _lp_token, uint _total_distribution_amount) {
535     require(_total_distribution_amount > 0);
536     require(_underlying_token != address(0x0));
537     require(_lp_token != address(0x0));
538 
539     underlying_token = IERC20( _underlying_token );
540     lp_token = IERC20( _lp_token);
541     total_distribution_amount = _total_distribution_amount;
542     
543     governance = msg.sender;
544     redeem_allowed = false;
545     deposit_done = false;
546   }
547 
548   modifier onlyGovernance() {
549     require(msg.sender == governance, "only governance is allowed");
550     _;
551   }
552 
553   event Redeem(address sender, uint balance, address token, uint share);
554   function redeem() public {
555     require(redeem_allowed, "redeem not allowed yet");
556 
557     uint user_balance = lp_token.balanceOf(msg.sender);
558     uint user_share = user_balance.mul(total_distribution_amount).div(lp_token.totalSupply());
559 
560     emit Redeem(msg.sender, user_balance, address(lp_token), user_share);
561     lp_token.safeTransferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, user_balance);
562     underlying_token.safeTransfer(msg.sender, user_share);
563   }
564 
565   function allowRedeem() public onlyGovernance {
566     require(deposit_done, "fund should be deposited first");
567     redeem_allowed = true;
568   }
569 
570   function disallowRedeem() public onlyGovernance {
571     redeem_allowed = false;
572   }
573 
574   modifier onlyFundRescue() {
575     require(msg.sender == fund_rescue, "only fund rescue");
576     _;
577   }
578 
579   function setFundRescue(address _fund_rescue) public onlyGovernance {
580     require(_fund_rescue != address(0x0));
581     fund_rescue = _fund_rescue;
582   }
583 
584   function depositFund() public onlyFundRescue {
585     underlying_token.safeTransferFrom(fund_rescue, address(this), total_distribution_amount);
586     deposit_done = true;
587   }
588 
589   function erc_sweep(address _token, address _to) public onlyGovernance {
590     IERC20 tkn = IERC20(_token);
591     uint tBal = tkn.balanceOf(address(this));
592     tkn.safeTransfer(_to, tBal);
593   }
594 }
595 contract DistributionSPrincipal is DistributionBase {
596   
597   address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
598   address public lp_token_address = 0x9be973b1496E28b3b745742391B0E5977184f1AC;
599   uint256 public S_PRINCIPAL_AMOUNT = 51029966983206580100000000;
600 
601   constructor() DistributionBase(DAI, lp_token_address, S_PRINCIPAL_AMOUNT) {
602 
603   }
604 
605 }