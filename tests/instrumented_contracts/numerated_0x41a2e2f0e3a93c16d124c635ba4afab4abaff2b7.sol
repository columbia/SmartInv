1 pragma solidity ^0.6.2;
2 
3 /**
4  * @dev Collection of functions related to the address type
5  */
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * [IMPORTANT]
11      * ====
12      * It is unsafe to assume that an address for which this function returns
13      * false is an externally-owned account (EOA) and not a contract.
14      *
15      * Among others, `isContract` will return false for the following
16      * types of addresses:
17      *
18      *  - an externally-owned account
19      *  - a contract in construction
20      *  - an address where a contract will be created
21      *  - an address where a contract lived, but was destroyed
22      * ====
23      */
24     function isContract(address account) internal view returns (bool) {
25         // This method relies on extcodesize, which returns 0 for contracts in
26         // construction, since the code is only stored at the end of the
27         // constructor execution.
28 
29         uint256 size;
30         // solhint-disable-next-line no-inline-assembly
31         assembly { size := extcodesize(account) }
32         return size > 0;
33     }
34 
35     /**
36      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
37      * `recipient`, forwarding all available gas and reverting on errors.
38      *
39      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
40      * of certain opcodes, possibly making contracts go over the 2300 gas limit
41      * imposed by `transfer`, making them unable to receive funds via
42      * `transfer`. {sendValue} removes this limitation.
43      *
44      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
45      *
46      * IMPORTANT: because control is transferred to `recipient`, care must be
47      * taken to not create reentrancy vulnerabilities. Consider using
48      * {ReentrancyGuard} or the
49      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
50      */
51     function sendValue(address payable recipient, uint256 amount) internal {
52         require(address(this).balance >= amount, "Address: insufficient balance");
53 
54         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
55         (bool success, ) = recipient.call{ value: amount }("");
56         require(success, "Address: unable to send value, recipient may have reverted");
57     }
58 
59     /**
60      * @dev Performs a Solidity function call using a low level `call`. A
61      * plain`call` is an unsafe replacement for a function call: use this
62      * function instead.
63      *
64      * If `target` reverts with a revert reason, it is bubbled up by this
65      * function (like regular Solidity function calls).
66      *
67      * Returns the raw returned data. To convert to the expected return value,
68      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
69      *
70      * Requirements:
71      *
72      * - `target` must be a contract.
73      * - calling `target` with `data` must not revert.
74      *
75      * _Available since v3.1._
76      */
77     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
78       return functionCall(target, data, "Address: low-level call failed");
79     }
80 
81     /**
82      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
83      * `errorMessage` as a fallback revert reason when `target` reverts.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, 0, errorMessage);
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
93      * but also transferring `value` wei to `target`.
94      *
95      * Requirements:
96      *
97      * - the calling contract must have an ETH balance of at least `value`.
98      * - the called Solidity function must be `payable`.
99      *
100      * _Available since v3.1._
101      */
102     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
108      * with `errorMessage` as a fallback revert reason when `target` reverts.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
113         require(address(this).balance >= value, "Address: insufficient balance for call");
114         require(isContract(target), "Address: call to non-contract");
115 
116         // solhint-disable-next-line avoid-low-level-calls
117         (bool success, bytes memory returndata) = target.call{ value: value }(data);
118         return _verifyCallResult(success, returndata, errorMessage);
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
123      * but performing a static call.
124      *
125      * _Available since v3.3._
126      */
127     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
128         return functionStaticCall(target, data, "Address: low-level static call failed");
129     }
130 
131     /**
132      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
133      * but performing a static call.
134      *
135      * _Available since v3.3._
136      */
137     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
138         require(isContract(target), "Address: static call to non-contract");
139 
140         // solhint-disable-next-line avoid-low-level-calls
141         (bool success, bytes memory returndata) = target.staticcall(data);
142         return _verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a delegate call.
148      *
149      * _Available since v3.3._
150      */
151     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
152         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a delegate call.
158      *
159      * _Available since v3.3._
160      */
161     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
162         require(isContract(target), "Address: delegate call to non-contract");
163 
164         // solhint-disable-next-line avoid-low-level-calls
165         (bool success, bytes memory returndata) = target.delegatecall(data);
166         return _verifyCallResult(success, returndata, errorMessage);
167     }
168 
169     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
170         if (success) {
171             return returndata;
172         } else {
173             // Look for revert reason and bubble it up if present
174             if (returndata.length > 0) {
175                 // The easiest way to bubble the revert reason is using memory via assembly
176 
177                 // solhint-disable-next-line no-inline-assembly
178                 assembly {
179                     let returndata_size := mload(returndata)
180                     revert(add(32, returndata), returndata_size)
181                 }
182             } else {
183                 revert(errorMessage);
184             }
185         }
186     }
187 }
188 
189 
190 pragma solidity ^0.6.0;
191 
192 /**
193  * @dev Wrappers over Solidity's arithmetic operations with added overflow
194  * checks.
195  *
196  * Arithmetic operations in Solidity wrap on overflow. This can easily result
197  * in bugs, because programmers usually assume that an overflow raises an
198  * error, which is the standard behavior in high level programming languages.
199  * `SafeMath` restores this intuition by reverting the transaction when an
200  * operation overflows.
201  *
202  * Using this library instead of the unchecked operations eliminates an entire
203  * class of bugs, so it's recommended to use it always.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      *
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      *
231      * - Subtraction cannot overflow.
232      */
233     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234         return sub(a, b, "SafeMath: subtraction overflow");
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
239      * overflow (when the result is negative).
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         uint256 c = a - b;
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      *
262      * - Multiplication cannot overflow.
263      */
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
266         // benefit is lost if 'b' is also tested.
267         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
268         if (a == 0) {
269             return 0;
270         }
271 
272         uint256 c = a * b;
273         require(c / a == b, "SafeMath: multiplication overflow");
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers. Reverts on
280      * division by zero. The result is rounded towards zero.
281      *
282      * Counterpart to Solidity's `/` operator. Note: this function uses a
283      * `revert` opcode (which leaves remaining gas untouched) while Solidity
284      * uses an invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function div(uint256 a, uint256 b) internal pure returns (uint256) {
291         return div(a, b, "SafeMath: division by zero");
292     }
293 
294     /**
295      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
296      * division by zero. The result is rounded towards zero.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
307         require(b > 0, errorMessage);
308         uint256 c = a / b;
309         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
327         return mod(a, b, "SafeMath: modulo by zero");
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * Reverts with custom message when dividing by zero.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b != 0, errorMessage);
344         return a % b;
345     }
346 }
347 
348 
349 
350 /**
351  * @dev Interface of the ERC20 standard as defined in the EIP.
352  */
353 interface IERC20 {
354     /**
355      * @dev Returns the amount of tokens in existence.
356      */
357     function totalSupply() external view returns (uint256);
358 
359     /**
360      * @dev Returns the amount of tokens owned by `account`.
361      */
362     function balanceOf(address account) external view returns (uint256);
363 
364     /**
365      * @dev Moves `amount` tokens from the caller's account to `recipient`.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transfer(address recipient, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Returns the remaining number of tokens that `spender` will be
375      * allowed to spend on behalf of `owner` through {transferFrom}. This is
376      * zero by default.
377      *
378      * This value changes when {approve} or {transferFrom} are called.
379      */
380     function allowance(address owner, address spender) external view returns (uint256);
381 
382     /**
383      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * IMPORTANT: Beware that changing an allowance with this method brings the risk
388      * that someone may use both the old and the new allowance by unfortunate
389      * transaction ordering. One possible solution to mitigate this race
390      * condition is to first reduce the spender's allowance to 0 and set the
391      * desired value afterwards:
392      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
393      *
394      * Emits an {Approval} event.
395      */
396     function approve(address spender, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Moves `amount` tokens from `sender` to `recipient` using the
400      * allowance mechanism. `amount` is then deducted from the caller's
401      * allowance.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * Emits a {Transfer} event.
406      */
407     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
408 
409     /**
410      * @dev Emitted when `value` tokens are moved from one account (`from`) to
411      * another (`to`).
412      *
413      * Note that `value` may be zero.
414      */
415     event Transfer(address indexed from, address indexed to, uint256 value);
416 
417     /**
418      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
419      * a call to {approve}. `value` is the new allowance.
420      */
421     event Approval(address indexed owner, address indexed spender, uint256 value);
422 }
423 
424 
425 /**
426  * @title SafeERC20
427  * @dev Wrappers around ERC20 operations that throw on failure (when the token
428  * contract returns false). Tokens that return no value (and instead revert or
429  * throw on failure) are also supported, non-reverting calls are assumed to be
430  * successful.
431  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
432  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
433  */
434 library SafeERC20 {
435     using SafeMath for uint256;
436     using Address for address;
437 
438     function safeTransfer(IERC20 token, address to, uint256 value) internal {
439         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
440     }
441 
442     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
443         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
444     }
445 
446     /**
447      * @dev Deprecated. This function has issues similar to the ones found in
448      * {IERC20-approve}, and its usage is discouraged.
449      *
450      * Whenever possible, use {safeIncreaseAllowance} and
451      * {safeDecreaseAllowance} instead.
452      */
453     function safeApprove(IERC20 token, address spender, uint256 value) internal {
454         // safeApprove should only be called when setting an initial allowance,
455         // or when resetting it to zero. To increase and decrease it, use
456         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
457         // solhint-disable-next-line max-line-length
458         require((value == 0) || (token.allowance(address(this), spender) == 0),
459             "SafeERC20: approve from non-zero to non-zero allowance"
460         );
461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
462     }
463 
464     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
465         uint256 newAllowance = token.allowance(address(this), spender).add(value);
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
467     }
468 
469     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
470         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
471         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
472     }
473 
474     /**
475      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
476      * on the return value: the return value is optional (but if data is returned, it must not be false).
477      * @param token The token targeted by the call.
478      * @param data The call data (encoded using abi.encode or one of its variants).
479      */
480     function _callOptionalReturn(IERC20 token, bytes memory data) private {
481         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
482         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
483         // the target address contains contract code and also asserts for success in the low-level call.
484 
485         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
486         if (returndata.length > 0) { // Return data is optional
487             // solhint-disable-next-line max-line-length
488             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
489         }
490     }
491 }
492 
493 /*
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with GSN meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address payable) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes memory) {
509         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
510         return msg.data;
511     }
512 }
513 
514 
515 /**
516  * @dev Contract module which provides a basic access control mechanism, where
517  * there is an account (an owner) that can be granted exclusive access to
518  * specific functions.
519  *
520  * By default, the owner account will be the one that deploys the contract. This
521  * can later be changed with {transferOwnership}.
522  *
523  * This module is used through inheritance. It will make available the modifier
524  * `onlyOwner`, which can be applied to your functions to restrict their use to
525  * the owner.
526  */
527 contract Ownable is Context {
528     address private _owner;
529 
530     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
531 
532     /**
533      * @dev Initializes the contract setting the deployer as the initial owner.
534      */
535     constructor () internal {
536         address msgSender = _msgSender();
537         _owner = msgSender;
538         emit OwnershipTransferred(address(0), msgSender);
539     }
540 
541     /**
542      * @dev Returns the address of the current owner.
543      */
544     function owner() public view returns (address) {
545         return _owner;
546     }
547 
548     /**
549      * @dev Throws if called by any account other than the owner.
550      */
551     modifier onlyOwner() {
552         require(_owner == _msgSender(), "Ownable: caller is not the owner");
553         _;
554     }
555 
556     /**
557      * @dev Leaves the contract without owner. It will not be possible to call
558      * `onlyOwner` functions anymore. Can only be called by the current owner.
559      *
560      * NOTE: Renouncing ownership will leave the contract without an owner,
561      * thereby removing any functionality that is only available to the owner.
562      */
563     function renounceOwnership() public virtual onlyOwner {
564         emit OwnershipTransferred(_owner, address(0));
565         _owner = address(0);
566     }
567 
568     /**
569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
570      * Can only be called by the current owner.
571      */
572     function transferOwnership(address newOwner) public virtual onlyOwner {
573         require(newOwner != address(0), "Ownable: new owner is the zero address");
574         emit OwnershipTransferred(_owner, newOwner);
575         _owner = newOwner;
576     }
577 }
578 
579 
580 contract QubNQub is Ownable {
581     using SafeMath for uint256;
582     using SafeERC20 for IERC20;
583 
584     uint256 MAX_QUB_AMOUNT = 50000*10**18;
585     uint256 MIN_STAKING_DAYS = 30 days;
586 
587     IERC20 public nqubWrapper = IERC20(0x892A74a8727Daf514cD3EFaBAaC03f415f3D20Af);
588     IERC20 public qub = IERC20(0xB2D74b7a454EDa300c6E633f5b593d128C0C0Dcf);
589     mapping(address => uint256) public balances;
590     mapping(address => uint256) public stakeDates;
591     mapping(address => uint256) public withdrawDates;
592     mapping(address => uint256) public stakeDays;
593     mapping(address => uint256) public stakeRequests;
594     mapping(address => bool) public withdrawLocks;
595 
596     modifier checkBalance(uint256 amount) {
597         require(balances[msg.sender].add(amount) <= MAX_QUB_AMOUNT);
598         _;
599     }
600 
601     modifier checkWithdrawDate {
602         require(withdrawDates[msg.sender] > 0 && now >= withdrawDates[msg.sender]);
603         require(now.sub(stakeRequests[msg.sender]) >= 24 hours);
604         _;
605     }
606 
607     modifier checkWithdrawLock {
608         require(now.sub(stakeRequests[msg.sender]) >= 30 days || !withdrawLocks[msg.sender]);
609         _;
610     }
611 
612     function calculateWithdrawDate() internal {
613         stakeDays[msg.sender] = MIN_STAKING_DAYS.mul(MAX_QUB_AMOUNT.div(balances[msg.sender]));
614         uint256 newWithdrawDate = now.add(stakeDays[msg.sender]);
615         if (stakeDates[msg.sender] > 0) {
616             uint256 stakeDuration = withdrawDates[msg.sender].sub(stakeDates[msg.sender]);
617             uint256 stakeDurationPercent = now.sub(stakeDates[msg.sender]).mul(100).div(stakeDuration);
618             newWithdrawDate = newWithdrawDate.sub(stakeDays[msg.sender].mul(stakeDurationPercent).div(100));
619         }
620         withdrawDates[msg.sender] = newWithdrawDate;
621         stakeDates[msg.sender] = now;
622     }
623 
624     function stake(uint256 amount) public checkBalance(amount) {
625         balances[msg.sender] = balances[msg.sender].add(amount);
626         calculateWithdrawDate();
627         stakeRequests[msg.sender] = now;
628         withdrawLocks[msg.sender] = true;
629         qub.safeTransferFrom(msg.sender, address(this), amount);
630     }
631 
632     function getReward() public checkWithdrawDate {
633         uint256 withdrawAmount = 1;
634         uint256 overStakeDuration = now.sub(withdrawDates[msg.sender]);
635         uint256 additionalAmount = overStakeDuration.div(stakeDays[msg.sender]);
636         stakeDates[msg.sender] = 0;
637         calculateWithdrawDate();
638         withdrawDates[msg.sender] = withdrawDates[msg.sender].sub(overStakeDuration.mod(stakeDays[msg.sender]));
639         withdrawAmount = withdrawAmount.add(additionalAmount);
640         withdrawLocks[msg.sender] = false;
641         nqubWrapper.safeTransfer(msg.sender, withdrawAmount);
642     }
643 
644     function withdraw(uint256 amount) public checkWithdrawLock {
645         balances[msg.sender] = balances[msg.sender].sub(amount);
646         if (balances[msg.sender] > 0) {
647             calculateWithdrawDate();
648         } else {
649             stakeDates[msg.sender] = 0;
650             withdrawDates[msg.sender] = 0;
651         }
652         qub.safeTransfer(msg.sender, amount);
653     }
654 
655     function getEtherFund(uint256 amount) public onlyOwner {
656         msg.sender.transfer(amount);
657     }
658 
659     function getTokenFund(address tokenAddress, uint256 amount) public onlyOwner {
660         IERC20 ierc20Token = IERC20(tokenAddress);
661         ierc20Token.safeTransfer(msg.sender, amount);
662     }
663 }