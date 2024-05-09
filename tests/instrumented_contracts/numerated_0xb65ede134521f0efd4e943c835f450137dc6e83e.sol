1 // File: contracts\interfaces\ICauldron.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.6.12;
5 
6 interface ICauldron {
7     function userCollateralShare(address account) external view returns (uint);
8 }
9 
10 // File: contracts\interfaces\IBentoBox.sol
11 
12 pragma solidity 0.6.12;
13 
14 interface IBentoBox {
15     function toAmount(address _token, uint256 _share, bool _roundUp) external view returns (uint);
16 }
17 
18 // File: contracts\interfaces\IRewardStaking.sol
19 
20 pragma solidity 0.6.12;
21 
22 interface IRewardStaking {
23     function stakeFor(address, uint256) external;
24     function stake( uint256) external;
25     function withdraw(uint256 amount, bool claim) external;
26     function withdrawAndUnwrap(uint256 amount, bool claim) external;
27     function earned(address account) external view returns (uint256);
28     function getReward() external;
29     function getReward(address _account, bool _claimExtras) external;
30     function extraRewardsLength() external view returns (uint256);
31     function extraRewards(uint256 _pid) external view returns (address);
32     function rewardToken() external view returns (address);
33     function balanceOf(address _account) external view returns (uint256);
34 }
35 
36 // File: contracts\interfaces\IConvexDeposits.sol
37 
38 pragma solidity 0.6.12;
39 
40 interface IConvexDeposits {
41     function deposit(uint256 _pid, uint256 _amount, bool _stake) external returns(bool);
42     function deposit(uint256 _amount, bool _lock, address _stakeAddress) external;
43 }
44 
45 // File: contracts\interfaces\ICvx.sol
46 
47 pragma solidity 0.6.12;
48 
49 interface ICvx {
50     function reductionPerCliff() external view returns(uint256);
51     function totalSupply() external view returns(uint256);
52     function totalCliffs() external view returns(uint256);
53     function maxSupply() external view returns(uint256);
54 }
55 
56 // File: contracts\interfaces\CvxMining.sol
57 
58 pragma solidity 0.6.12;
59 
60 
61 library CvxMining{
62     ICvx public constant cvx = ICvx(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
63 
64     function ConvertCrvToCvx(uint256 _amount) external view returns(uint256){
65         uint256 supply = cvx.totalSupply();
66         uint256 reductionPerCliff = cvx.reductionPerCliff();
67         uint256 totalCliffs = cvx.totalCliffs();
68         uint256 maxSupply = cvx.maxSupply();
69 
70         uint256 cliff = supply / reductionPerCliff;
71         //mint if below total cliffs
72         if(cliff < totalCliffs){
73             //for reduction% take inverse of current cliff
74             uint256 reduction = totalCliffs - cliff;
75             //reduce
76             _amount = _amount * reduction / totalCliffs;
77 
78             //supply cap check
79             uint256 amtTillMax = maxSupply - supply;
80             if(_amount > amtTillMax){
81                 _amount = amtTillMax;
82             }
83 
84             //mint
85             return _amount;
86         }
87         return 0;
88     }
89 }
90 
91 // File: @openzeppelin\contracts\math\SafeMath.sol
92 
93 
94 pragma solidity >=0.6.0 <0.8.0;
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations with added overflow
98  * checks.
99  *
100  * Arithmetic operations in Solidity wrap on overflow. This can easily result
101  * in bugs, because programmers usually assume that an overflow raises an
102  * error, which is the standard behavior in high level programming languages.
103  * `SafeMath` restores this intuition by reverting the transaction when an
104  * operation overflows.
105  *
106  * Using this library instead of the unchecked operations eliminates an entire
107  * class of bugs, so it's recommended to use it always.
108  */
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         uint256 c = a + b;
117         if (c < a) return (false, 0);
118         return (true, c);
119     }
120 
121     /**
122      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         if (b > a) return (false, 0);
128         return (true, a - b);
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) return (true, 0);
141         uint256 c = a * b;
142         if (c / a != b) return (false, 0);
143         return (true, c);
144     }
145 
146     /**
147      * @dev Returns the division of two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         if (b == 0) return (false, 0);
153         return (true, a / b);
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         if (b == 0) return (false, 0);
163         return (true, a % b);
164     }
165 
166     /**
167      * @dev Returns the addition of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `+` operator.
171      *
172      * Requirements:
173      *
174      * - Addition cannot overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         uint256 c = a + b;
178         require(c >= a, "SafeMath: addition overflow");
179         return c;
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting on
184      * overflow (when the result is negative).
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193         require(b <= a, "SafeMath: subtraction overflow");
194         return a - b;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      *
205      * - Multiplication cannot overflow.
206      */
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         if (a == 0) return 0;
209         uint256 c = a * b;
210         require(c / a == b, "SafeMath: multiplication overflow");
211         return c;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers, reverting on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         require(b > 0, "SafeMath: division by zero");
228         return a / b;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * reverting when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         require(b > 0, "SafeMath: modulo by zero");
245         return a % b;
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
250      * overflow (when the result is negative).
251      *
252      * CAUTION: This function is deprecated because it requires allocating memory for the error
253      * message unnecessarily. For custom revert reasons use {trySub}.
254      *
255      * Counterpart to Solidity's `-` operator.
256      *
257      * Requirements:
258      *
259      * - Subtraction cannot overflow.
260      */
261     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b <= a, errorMessage);
263         return a - b;
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {tryDiv}.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b > 0, errorMessage);
283         return a / b;
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * reverting with custom message when dividing by zero.
289      *
290      * CAUTION: This function is deprecated because it requires allocating memory for the error
291      * message unnecessarily. For custom revert reasons use {tryMod}.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b > 0, errorMessage);
303         return a % b;
304     }
305 }
306 
307 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
308 
309 pragma solidity >=0.6.0 <0.8.0;
310 
311 /**
312  * @dev Interface of the ERC20 standard as defined in the EIP.
313  */
314 interface IERC20 {
315     /**
316      * @dev Returns the amount of tokens in existence.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     /**
321      * @dev Returns the amount of tokens owned by `account`.
322      */
323     function balanceOf(address account) external view returns (uint256);
324 
325     /**
326      * @dev Moves `amount` tokens from the caller's account to `recipient`.
327      *
328      * Returns a boolean value indicating whether the operation succeeded.
329      *
330      * Emits a {Transfer} event.
331      */
332     function transfer(address recipient, uint256 amount) external returns (bool);
333 
334     /**
335      * @dev Returns the remaining number of tokens that `spender` will be
336      * allowed to spend on behalf of `owner` through {transferFrom}. This is
337      * zero by default.
338      *
339      * This value changes when {approve} or {transferFrom} are called.
340      */
341     function allowance(address owner, address spender) external view returns (uint256);
342 
343     /**
344      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * IMPORTANT: Beware that changing an allowance with this method brings the risk
349      * that someone may use both the old and the new allowance by unfortunate
350      * transaction ordering. One possible solution to mitigate this race
351      * condition is to first reduce the spender's allowance to 0 and set the
352      * desired value afterwards:
353      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
354      *
355      * Emits an {Approval} event.
356      */
357     function approve(address spender, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Moves `amount` tokens from `sender` to `recipient` using the
361      * allowance mechanism. `amount` is then deducted from the caller's
362      * allowance.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
369 
370     /**
371      * @dev Emitted when `value` tokens are moved from one account (`from`) to
372      * another (`to`).
373      *
374      * Note that `value` may be zero.
375      */
376     event Transfer(address indexed from, address indexed to, uint256 value);
377 
378     /**
379      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
380      * a call to {approve}. `value` is the new allowance.
381      */
382     event Approval(address indexed owner, address indexed spender, uint256 value);
383 }
384 
385 // File: @openzeppelin\contracts\utils\Address.sol
386 
387 pragma solidity >=0.6.2 <0.8.0;
388 
389 /**
390  * @dev Collection of functions related to the address type
391  */
392 library Address {
393     /**
394      * @dev Returns true if `account` is a contract.
395      *
396      * [IMPORTANT]
397      * ====
398      * It is unsafe to assume that an address for which this function returns
399      * false is an externally-owned account (EOA) and not a contract.
400      *
401      * Among others, `isContract` will return false for the following
402      * types of addresses:
403      *
404      *  - an externally-owned account
405      *  - a contract in construction
406      *  - an address where a contract will be created
407      *  - an address where a contract lived, but was destroyed
408      * ====
409      */
410     function isContract(address account) internal view returns (bool) {
411         // This method relies on extcodesize, which returns 0 for contracts in
412         // construction, since the code is only stored at the end of the
413         // constructor execution.
414 
415         uint256 size;
416         // solhint-disable-next-line no-inline-assembly
417         assembly { size := extcodesize(account) }
418         return size > 0;
419     }
420 
421     /**
422      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
423      * `recipient`, forwarding all available gas and reverting on errors.
424      *
425      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
426      * of certain opcodes, possibly making contracts go over the 2300 gas limit
427      * imposed by `transfer`, making them unable to receive funds via
428      * `transfer`. {sendValue} removes this limitation.
429      *
430      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
431      *
432      * IMPORTANT: because control is transferred to `recipient`, care must be
433      * taken to not create reentrancy vulnerabilities. Consider using
434      * {ReentrancyGuard} or the
435      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
441         (bool success, ) = recipient.call{ value: amount }("");
442         require(success, "Address: unable to send value, recipient may have reverted");
443     }
444 
445     /**
446      * @dev Performs a Solidity function call using a low level `call`. A
447      * plain`call` is an unsafe replacement for a function call: use this
448      * function instead.
449      *
450      * If `target` reverts with a revert reason, it is bubbled up by this
451      * function (like regular Solidity function calls).
452      *
453      * Returns the raw returned data. To convert to the expected return value,
454      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
455      *
456      * Requirements:
457      *
458      * - `target` must be a contract.
459      * - calling `target` with `data` must not revert.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
464       return functionCall(target, data, "Address: low-level call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
469      * `errorMessage` as a fallback revert reason when `target` reverts.
470      *
471      * _Available since v3.1._
472      */
473     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
474         return functionCallWithValue(target, data, 0, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but also transferring `value` wei to `target`.
480      *
481      * Requirements:
482      *
483      * - the calling contract must have an ETH balance of at least `value`.
484      * - the called Solidity function must be `payable`.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
494      * with `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
499         require(address(this).balance >= value, "Address: insufficient balance for call");
500         require(isContract(target), "Address: call to non-contract");
501 
502         // solhint-disable-next-line avoid-low-level-calls
503         (bool success, bytes memory returndata) = target.call{ value: value }(data);
504         return _verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a static call.
510      *
511      * _Available since v3.3._
512      */
513     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
514         return functionStaticCall(target, data, "Address: low-level static call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
524         require(isContract(target), "Address: static call to non-contract");
525 
526         // solhint-disable-next-line avoid-low-level-calls
527         (bool success, bytes memory returndata) = target.staticcall(data);
528         return _verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a delegate call.
534      *
535      * _Available since v3.4._
536      */
537     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
538         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
548         require(isContract(target), "Address: delegate call to non-contract");
549 
550         // solhint-disable-next-line avoid-low-level-calls
551         (bool success, bytes memory returndata) = target.delegatecall(data);
552         return _verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
556         if (success) {
557             return returndata;
558         } else {
559             // Look for revert reason and bubble it up if present
560             if (returndata.length > 0) {
561                 // The easiest way to bubble the revert reason is using memory via assembly
562 
563                 // solhint-disable-next-line no-inline-assembly
564                 assembly {
565                     let returndata_size := mload(returndata)
566                     revert(add(32, returndata), returndata_size)
567                 }
568             } else {
569                 revert(errorMessage);
570             }
571         }
572     }
573 }
574 
575 
576 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
577 
578 pragma solidity >=0.6.0 <0.8.0;
579 
580 
581 /**
582  * @title SafeERC20
583  * @dev Wrappers around ERC20 operations that throw on failure (when the token
584  * contract returns false). Tokens that return no value (and instead revert or
585  * throw on failure) are also supported, non-reverting calls are assumed to be
586  * successful.
587  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
588  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
589  */
590 library SafeERC20 {
591     using SafeMath for uint256;
592     using Address for address;
593 
594     function safeTransfer(IERC20 token, address to, uint256 value) internal {
595         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
596     }
597 
598     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
599         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
600     }
601 
602     /**
603      * @dev Deprecated. This function has issues similar to the ones found in
604      * {IERC20-approve}, and its usage is discouraged.
605      *
606      * Whenever possible, use {safeIncreaseAllowance} and
607      * {safeDecreaseAllowance} instead.
608      */
609     function safeApprove(IERC20 token, address spender, uint256 value) internal {
610         // safeApprove should only be called when setting an initial allowance,
611         // or when resetting it to zero. To increase and decrease it, use
612         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
613         // solhint-disable-next-line max-line-length
614         require((value == 0) || (token.allowance(address(this), spender) == 0),
615             "SafeERC20: approve from non-zero to non-zero allowance"
616         );
617         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
618     }
619 
620     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
621         uint256 newAllowance = token.allowance(address(this), spender).add(value);
622         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
623     }
624 
625     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
626         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
627         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
628     }
629 
630     /**
631      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
632      * on the return value: the return value is optional (but if data is returned, it must not be false).
633      * @param token The token targeted by the call.
634      * @param data The call data (encoded using abi.encode or one of its variants).
635      */
636     function _callOptionalReturn(IERC20 token, bytes memory data) private {
637         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
638         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
639         // the target address contains contract code and also asserts for success in the low-level call.
640 
641         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
642         if (returndata.length > 0) { // Return data is optional
643             // solhint-disable-next-line max-line-length
644             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
645         }
646     }
647 }
648 
649 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
650 
651 pragma solidity >=0.6.0 <0.8.0;
652 
653 /*
654  * @dev Provides information about the current execution context, including the
655  * sender of the transaction and its data. While these are generally available
656  * via msg.sender and msg.data, they should not be accessed in such a direct
657  * manner, since when dealing with GSN meta-transactions the account sending and
658  * paying for execution may not be the actual sender (as far as an application
659  * is concerned).
660  *
661  * This contract is only required for intermediate, library-like contracts.
662  */
663 abstract contract Context {
664     function _msgSender() internal view virtual returns (address payable) {
665         return msg.sender;
666     }
667 
668     function _msgData() internal view virtual returns (bytes memory) {
669         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
670         return msg.data;
671     }
672 }
673 
674 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
675 
676 pragma solidity >=0.6.0 <0.8.0;
677 
678 
679 /**
680  * @dev Implementation of the {IERC20} interface.
681  *
682  * This implementation is agnostic to the way tokens are created. This means
683  * that a supply mechanism has to be added in a derived contract using {_mint}.
684  * For a generic mechanism see {ERC20PresetMinterPauser}.
685  *
686  * TIP: For a detailed writeup see our guide
687  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
688  * to implement supply mechanisms].
689  *
690  * We have followed general OpenZeppelin guidelines: functions revert instead
691  * of returning `false` on failure. This behavior is nonetheless conventional
692  * and does not conflict with the expectations of ERC20 applications.
693  *
694  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
695  * This allows applications to reconstruct the allowance for all accounts just
696  * by listening to said events. Other implementations of the EIP may not emit
697  * these events, as it isn't required by the specification.
698  *
699  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
700  * functions have been added to mitigate the well-known issues around setting
701  * allowances. See {IERC20-approve}.
702  */
703 contract ERC20 is Context, IERC20 {
704     using SafeMath for uint256;
705 
706     mapping (address => uint256) private _balances;
707 
708     mapping (address => mapping (address => uint256)) private _allowances;
709 
710     uint256 private _totalSupply;
711 
712     string private _name;
713     string private _symbol;
714     uint8 private _decimals;
715 
716     /**
717      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
718      * a default value of 18.
719      *
720      * To select a different value for {decimals}, use {_setupDecimals}.
721      *
722      * All three of these values are immutable: they can only be set once during
723      * construction.
724      */
725     constructor (string memory name_, string memory symbol_) public {
726         _name = name_;
727         _symbol = symbol_;
728         _decimals = 18;
729     }
730 
731     /**
732      * @dev Returns the name of the token.
733      */
734     function name() public view virtual returns (string memory) {
735         return _name;
736     }
737 
738     /**
739      * @dev Returns the symbol of the token, usually a shorter version of the
740      * name.
741      */
742     function symbol() public view virtual returns (string memory) {
743         return _symbol;
744     }
745 
746     /**
747      * @dev Returns the number of decimals used to get its user representation.
748      * For example, if `decimals` equals `2`, a balance of `505` tokens should
749      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
750      *
751      * Tokens usually opt for a value of 18, imitating the relationship between
752      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
753      * called.
754      *
755      * NOTE: This information is only used for _display_ purposes: it in
756      * no way affects any of the arithmetic of the contract, including
757      * {IERC20-balanceOf} and {IERC20-transfer}.
758      */
759     function decimals() public view virtual returns (uint8) {
760         return _decimals;
761     }
762 
763     /**
764      * @dev See {IERC20-totalSupply}.
765      */
766     function totalSupply() public view virtual override returns (uint256) {
767         return _totalSupply;
768     }
769 
770     /**
771      * @dev See {IERC20-balanceOf}.
772      */
773     function balanceOf(address account) public view virtual override returns (uint256) {
774         return _balances[account];
775     }
776 
777     /**
778      * @dev See {IERC20-transfer}.
779      *
780      * Requirements:
781      *
782      * - `recipient` cannot be the zero address.
783      * - the caller must have a balance of at least `amount`.
784      */
785     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
786         _transfer(_msgSender(), recipient, amount);
787         return true;
788     }
789 
790     /**
791      * @dev See {IERC20-allowance}.
792      */
793     function allowance(address owner, address spender) public view virtual override returns (uint256) {
794         return _allowances[owner][spender];
795     }
796 
797     /**
798      * @dev See {IERC20-approve}.
799      *
800      * Requirements:
801      *
802      * - `spender` cannot be the zero address.
803      */
804     function approve(address spender, uint256 amount) public virtual override returns (bool) {
805         _approve(_msgSender(), spender, amount);
806         return true;
807     }
808 
809     /**
810      * @dev See {IERC20-transferFrom}.
811      *
812      * Emits an {Approval} event indicating the updated allowance. This is not
813      * required by the EIP. See the note at the beginning of {ERC20}.
814      *
815      * Requirements:
816      *
817      * - `sender` and `recipient` cannot be the zero address.
818      * - `sender` must have a balance of at least `amount`.
819      * - the caller must have allowance for ``sender``'s tokens of at least
820      * `amount`.
821      */
822     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
823         _transfer(sender, recipient, amount);
824         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
825         return true;
826     }
827 
828     /**
829      * @dev Atomically increases the allowance granted to `spender` by the caller.
830      *
831      * This is an alternative to {approve} that can be used as a mitigation for
832      * problems described in {IERC20-approve}.
833      *
834      * Emits an {Approval} event indicating the updated allowance.
835      *
836      * Requirements:
837      *
838      * - `spender` cannot be the zero address.
839      */
840     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
841         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
842         return true;
843     }
844 
845     /**
846      * @dev Atomically decreases the allowance granted to `spender` by the caller.
847      *
848      * This is an alternative to {approve} that can be used as a mitigation for
849      * problems described in {IERC20-approve}.
850      *
851      * Emits an {Approval} event indicating the updated allowance.
852      *
853      * Requirements:
854      *
855      * - `spender` cannot be the zero address.
856      * - `spender` must have allowance for the caller of at least
857      * `subtractedValue`.
858      */
859     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
860         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
861         return true;
862     }
863 
864     /**
865      * @dev Moves tokens `amount` from `sender` to `recipient`.
866      *
867      * This is internal function is equivalent to {transfer}, and can be used to
868      * e.g. implement automatic token fees, slashing mechanisms, etc.
869      *
870      * Emits a {Transfer} event.
871      *
872      * Requirements:
873      *
874      * - `sender` cannot be the zero address.
875      * - `recipient` cannot be the zero address.
876      * - `sender` must have a balance of at least `amount`.
877      */
878     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
879         require(sender != address(0), "ERC20: transfer from the zero address");
880         require(recipient != address(0), "ERC20: transfer to the zero address");
881 
882         _beforeTokenTransfer(sender, recipient, amount);
883 
884         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
885         _balances[recipient] = _balances[recipient].add(amount);
886         emit Transfer(sender, recipient, amount);
887     }
888 
889     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
890      * the total supply.
891      *
892      * Emits a {Transfer} event with `from` set to the zero address.
893      *
894      * Requirements:
895      *
896      * - `to` cannot be the zero address.
897      */
898     function _mint(address account, uint256 amount) internal virtual {
899         require(account != address(0), "ERC20: mint to the zero address");
900 
901         _beforeTokenTransfer(address(0), account, amount);
902 
903         _totalSupply = _totalSupply.add(amount);
904         _balances[account] = _balances[account].add(amount);
905         emit Transfer(address(0), account, amount);
906     }
907 
908     /**
909      * @dev Destroys `amount` tokens from `account`, reducing the
910      * total supply.
911      *
912      * Emits a {Transfer} event with `to` set to the zero address.
913      *
914      * Requirements:
915      *
916      * - `account` cannot be the zero address.
917      * - `account` must have at least `amount` tokens.
918      */
919     function _burn(address account, uint256 amount) internal virtual {
920         require(account != address(0), "ERC20: burn from the zero address");
921 
922         _beforeTokenTransfer(account, address(0), amount);
923 
924         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
925         _totalSupply = _totalSupply.sub(amount);
926         emit Transfer(account, address(0), amount);
927     }
928 
929     /**
930      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
931      *
932      * This internal function is equivalent to `approve`, and can be used to
933      * e.g. set automatic allowances for certain subsystems, etc.
934      *
935      * Emits an {Approval} event.
936      *
937      * Requirements:
938      *
939      * - `owner` cannot be the zero address.
940      * - `spender` cannot be the zero address.
941      */
942     function _approve(address owner, address spender, uint256 amount) internal virtual {
943         require(owner != address(0), "ERC20: approve from the zero address");
944         require(spender != address(0), "ERC20: approve to the zero address");
945 
946         _allowances[owner][spender] = amount;
947         emit Approval(owner, spender, amount);
948     }
949 
950     /**
951      * @dev Sets {decimals} to a value other than the default one of 18.
952      *
953      * WARNING: This function should only be called from the constructor. Most
954      * applications that interact with token contracts will not expect
955      * {decimals} to ever change, and may work incorrectly if it does.
956      */
957     function _setupDecimals(uint8 decimals_) internal virtual {
958         _decimals = decimals_;
959     }
960 
961     /**
962      * @dev Hook that is called before any transfer of tokens. This includes
963      * minting and burning.
964      *
965      * Calling conditions:
966      *
967      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
968      * will be to transferred to `to`.
969      * - when `from` is zero, `amount` tokens will be minted for `to`.
970      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
971      * - `from` and `to` are never both zero.
972      *
973      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
974      */
975     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
976 }
977 
978 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
979 
980 pragma solidity >=0.6.0 <0.8.0;
981 
982 /**
983  * @dev Contract module that helps prevent reentrant calls to a function.
984  *
985  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
986  * available, which can be applied to functions to make sure there are no nested
987  * (reentrant) calls to them.
988  *
989  * Note that because there is a single `nonReentrant` guard, functions marked as
990  * `nonReentrant` may not call one another. This can be worked around by making
991  * those functions `private`, and then adding `external` `nonReentrant` entry
992  * points to them.
993  *
994  * TIP: If you would like to learn more about reentrancy and alternative ways
995  * to protect against it, check out our blog post
996  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
997  */
998 abstract contract ReentrancyGuard {
999     // Booleans are more expensive than uint256 or any type that takes up a full
1000     // word because each write operation emits an extra SLOAD to first read the
1001     // slot's contents, replace the bits taken up by the boolean, and then write
1002     // back. This is the compiler's defense against contract upgrades and
1003     // pointer aliasing, and it cannot be disabled.
1004 
1005     // The values being non-zero value makes deployment a bit more expensive,
1006     // but in exchange the refund on every call to nonReentrant will be lower in
1007     // amount. Since refunds are capped to a percentage of the total
1008     // transaction's gas, it is best to keep them low in cases like this one, to
1009     // increase the likelihood of the full refund coming into effect.
1010     uint256 private constant _NOT_ENTERED = 1;
1011     uint256 private constant _ENTERED = 2;
1012 
1013     uint256 private _status;
1014 
1015     constructor () internal {
1016         _status = _NOT_ENTERED;
1017     }
1018 
1019     /**
1020      * @dev Prevents a contract from calling itself, directly or indirectly.
1021      * Calling a `nonReentrant` function from another `nonReentrant`
1022      * function is not supported. It is possible to prevent this from happening
1023      * by making the `nonReentrant` function external, and make it call a
1024      * `private` function that does the actual work.
1025      */
1026     modifier nonReentrant() {
1027         // On the first call to nonReentrant, _notEntered will be true
1028         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1029 
1030         // Any calls to nonReentrant after this point will fail
1031         _status = _ENTERED;
1032 
1033         _;
1034 
1035         // By storing the original value once again, a refund is triggered (see
1036         // https://eips.ethereum.org/EIPS/eip-2200)
1037         _status = _NOT_ENTERED;
1038     }
1039 }
1040 
1041 // File: contracts\wrappers\ConvexStakingWrapper.sol
1042 
1043 pragma solidity 0.6.12;
1044 pragma experimental ABIEncoderV2;
1045 
1046 
1047 //Example of a tokenize a convex staked position.
1048 //if used as collateral some modifications will be needed to fit the specific platform
1049 
1050 //Based on Curve.fi's gauge wrapper implementations at https://github.com/curvefi/curve-dao-contracts/tree/master/contracts/gauges/wrappers
1051 contract ConvexStakingWrapper is ERC20, ReentrancyGuard {
1052     using SafeERC20
1053     for IERC20;
1054     using Address
1055     for address;
1056     using SafeMath
1057     for uint256;
1058 
1059     struct EarnedData {
1060         address token;
1061         uint256 amount;
1062     }
1063 
1064     struct RewardType {
1065         address reward_token;
1066         address reward_pool;
1067         uint128 reward_integral;
1068         uint128 reward_remaining;
1069         mapping(address => uint256) reward_integral_for;
1070         mapping(address => uint256) claimable_reward;
1071     }
1072 
1073     uint256 public cvx_reward_integral;
1074     uint256 public cvx_reward_remaining;
1075     mapping(address => uint256) public cvx_reward_integral_for;
1076     mapping(address => uint256) public cvx_claimable_reward;
1077 
1078     //constants/immutables
1079     address public constant convexBooster = address(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
1080     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
1081     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
1082     address public curveToken;
1083     address public convexToken;
1084     address public convexPool;
1085     uint256 public convexPoolId;
1086     address public collateralVault;
1087 
1088     //rewards
1089     RewardType[] public rewards;
1090 
1091     //management
1092     bool public isShutdown;
1093     bool public isInit;
1094     address public owner;
1095 
1096     string internal _tokenname;
1097     string internal _tokensymbol;
1098 
1099     event Deposited(address indexed _user, address indexed _account, uint256 _amount, bool _wrapped);
1100     event Withdrawn(address indexed _user, uint256 _amount, bool _unwrapped);
1101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1102 
1103     constructor() public
1104         ERC20(
1105             "StakedConvexToken",
1106             "stkCvx"
1107         ){
1108     }
1109 
1110     function initialize(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId, address _vault)
1111     virtual external {
1112         require(!isInit,"already init");
1113         owner = address(0xa3C5A1e09150B75ff251c1a7815A07182c3de2FB); //default to convex multisig
1114         emit OwnershipTransferred(address(0), owner);
1115 
1116         _tokenname = string(abi.encodePacked("Staked ", ERC20(_convexToken).name() ));
1117         _tokensymbol = string(abi.encodePacked("stk", ERC20(_convexToken).symbol()));
1118         isShutdown = false;
1119         isInit = true;
1120         curveToken = _curveToken;
1121         convexToken = _convexToken;
1122         convexPool = _convexPool;
1123         convexPoolId = _poolId;
1124         collateralVault = _vault;
1125 
1126         //add rewards
1127         addRewards();
1128         setApprovals();
1129     }
1130 
1131     function name() public view override returns (string memory) {
1132         return _tokenname;
1133     }
1134 
1135     function symbol() public view override returns (string memory) {
1136         return _tokensymbol;
1137     }
1138 
1139     function decimals() public view override returns (uint8) {
1140         return 18;
1141     }
1142 
1143     modifier onlyOwner() {
1144         require(owner == msg.sender, "Ownable: caller is not the owner");
1145         _;
1146     }
1147 
1148     function transferOwnership(address newOwner) public virtual onlyOwner {
1149         require(newOwner != address(0), "Ownable: new owner is the zero address");
1150         emit OwnershipTransferred(owner, newOwner);
1151         owner = newOwner;
1152     }
1153 
1154     function renounceOwnership() public virtual onlyOwner {
1155         emit OwnershipTransferred(owner, address(0));
1156         owner = address(0);
1157     }
1158 
1159     function shutdown() external onlyOwner {
1160         isShutdown = true;
1161     }
1162 
1163     function setApprovals() public {
1164         IERC20(curveToken).safeApprove(convexBooster, 0);
1165         IERC20(curveToken).safeApprove(convexBooster, uint256(-1));
1166         IERC20(convexToken).safeApprove(convexPool, 0);
1167         IERC20(convexToken).safeApprove(convexPool, uint256(-1));
1168     }
1169 
1170     function addRewards() public {
1171         address mainPool = convexPool;
1172 
1173         if (rewards.length == 0) {
1174             rewards.push(
1175                 RewardType({
1176                     reward_token: crv,
1177                     reward_pool: mainPool,
1178                     reward_integral: 0,
1179                     reward_remaining: 0
1180                 })
1181             );
1182         }
1183 
1184         uint256 extraCount = IRewardStaking(mainPool).extraRewardsLength();
1185         uint256 startIndex = rewards.length - 1;
1186         for (uint256 i = startIndex; i < extraCount; i++) {
1187             address extraPool = IRewardStaking(mainPool).extraRewards(i);
1188             rewards.push(
1189                 RewardType({
1190                     reward_token: IRewardStaking(extraPool).rewardToken(),
1191                     reward_pool: extraPool,
1192                     reward_integral: 0,
1193                     reward_remaining: 0
1194                 })
1195             );
1196         }
1197     }
1198 
1199     function rewardLength() external view returns(uint256) {
1200         return rewards.length;
1201     }
1202 
1203     function _getDepositedBalance(address _account) internal virtual view returns(uint256) {
1204         if (_account == address(0) || _account == collateralVault) {
1205             return 0;
1206         }
1207         //get balance from collateralVault
1208 
1209         return balanceOf(_account);
1210     }
1211 
1212     function _getTotalSupply() internal virtual view returns(uint256){
1213 
1214         //override and add any supply needed (interest based growth)
1215 
1216         return totalSupply();
1217     }
1218 
1219 
1220     function _calcCvxIntegral(address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal {
1221 
1222         uint256 bal = IERC20(cvx).balanceOf(address(this));
1223         uint256 d_cvxreward = bal.sub(cvx_reward_remaining);
1224 
1225         if (_supply > 0 && d_cvxreward > 0) {
1226             cvx_reward_integral = cvx_reward_integral + d_cvxreward.mul(1e20).div(_supply);
1227         }
1228 
1229         
1230         //update user integrals for cvx
1231         for (uint256 u = 0; u < _accounts.length; u++) {
1232             //do not give rewards to address 0
1233             if (_accounts[u] == address(0)) continue;
1234             if (_accounts[u] == collateralVault) continue;
1235 
1236             uint userI = cvx_reward_integral_for[_accounts[u]];
1237             if(_isClaim || userI < cvx_reward_integral){
1238                 uint256 receiveable = cvx_claimable_reward[_accounts[u]].add(_balances[u].mul(cvx_reward_integral.sub(userI)).div(1e20));
1239                 if(_isClaim){
1240                     if(receiveable > 0){
1241                         cvx_claimable_reward[_accounts[u]] = 0;
1242                         IERC20(cvx).safeTransfer(_accounts[u], receiveable);
1243                         bal = bal.sub(receiveable);
1244                     }
1245                 }else{
1246                     cvx_claimable_reward[_accounts[u]] = receiveable;
1247                 }
1248                 cvx_reward_integral_for[_accounts[u]] = cvx_reward_integral;
1249            }
1250         }
1251 
1252         //update reward total
1253         if(bal != cvx_reward_remaining){
1254             cvx_reward_remaining = bal;
1255         }
1256     }
1257 
1258     function _calcRewardIntegral(uint256 _index, address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal{
1259          RewardType storage reward = rewards[_index];
1260 
1261         //get difference in balance and remaining rewards
1262         //getReward is unguarded so we use reward_remaining to keep track of how much was actually claimed
1263         uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1264         // uint256 d_reward = bal.sub(reward.reward_remaining);
1265 
1266         if (_supply > 0 && bal.sub(reward.reward_remaining) > 0) {
1267             reward.reward_integral = reward.reward_integral + uint128(bal.sub(reward.reward_remaining).mul(1e20).div(_supply));
1268         }
1269 
1270         //update user integrals
1271         for (uint256 u = 0; u < _accounts.length; u++) {
1272             //do not give rewards to address 0
1273             if (_accounts[u] == address(0)) continue;
1274             if (_accounts[u] == collateralVault) continue;
1275 
1276             uint userI = reward.reward_integral_for[_accounts[u]];
1277             if(_isClaim || userI < reward.reward_integral){
1278                 if(_isClaim){
1279                     uint256 receiveable = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1280                     if(receiveable > 0){
1281                         reward.claimable_reward[_accounts[u]] = 0;
1282                         IERC20(reward.reward_token).safeTransfer(_accounts[u], receiveable);
1283                         bal = bal.sub(receiveable);
1284                     }
1285                 }else{
1286                     reward.claimable_reward[_accounts[u]] = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1287                 }
1288                 reward.reward_integral_for[_accounts[u]] = reward.reward_integral;
1289             }
1290         }
1291 
1292         //update remaining reward here since balance could have changed if claiming
1293         if(bal !=  reward.reward_remaining){
1294             reward.reward_remaining = uint128(bal);
1295         }
1296     }
1297 
1298     function _checkpoint(address[2] memory _accounts) internal {
1299         //if shutdown, no longer checkpoint in case there are problems
1300         if(isShutdown) return;
1301 
1302         uint256 supply = _getTotalSupply();
1303         uint256[2] memory depositedBalance;
1304         depositedBalance[0] = _getDepositedBalance(_accounts[0]);
1305         depositedBalance[1] = _getDepositedBalance(_accounts[1]);
1306         
1307         IRewardStaking(convexPool).getReward(address(this), true);
1308 
1309         uint256 rewardCount = rewards.length;
1310         for (uint256 i = 0; i < rewardCount; i++) {
1311            _calcRewardIntegral(i,_accounts,depositedBalance,supply,false);
1312         }
1313         _calcCvxIntegral(_accounts,depositedBalance,supply,false);
1314     }
1315 
1316     function _checkpointAndClaim(address[2] memory _accounts) internal {
1317 
1318         uint256 supply = _getTotalSupply();
1319         uint256[2] memory depositedBalance;
1320         depositedBalance[0] = _getDepositedBalance(_accounts[0]); //only do first slot
1321         
1322         IRewardStaking(convexPool).getReward(address(this), true);
1323 
1324         uint256 rewardCount = rewards.length;
1325         for (uint256 i = 0; i < rewardCount; i++) {
1326            _calcRewardIntegral(i,_accounts,depositedBalance,supply,true);
1327         }
1328         _calcCvxIntegral(_accounts,depositedBalance,supply,true);
1329     }
1330 
1331     function user_checkpoint(address[2] calldata _accounts) external returns(bool) {
1332         _checkpoint([_accounts[0], _accounts[1]]);
1333         return true;
1334     }
1335 
1336     function totalBalanceOf(address _account) external view returns(uint256){
1337         return _getDepositedBalance(_account);
1338     }
1339 
1340     function earned(address _account) external view returns(EarnedData[] memory claimable) {
1341         uint256 supply = _getTotalSupply();
1342         // uint256 depositedBalance = _getDepositedBalance(_account);
1343         uint256 rewardCount = rewards.length;
1344         claimable = new EarnedData[](rewardCount + 1);
1345 
1346         for (uint256 i = 0; i < rewardCount; i++) {
1347             RewardType storage reward = rewards[i];
1348 
1349             //change in reward is current balance - remaining reward + earned
1350             uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1351             uint256 d_reward = bal.sub(reward.reward_remaining);
1352             d_reward = d_reward.add(IRewardStaking(reward.reward_pool).earned(address(this)));
1353 
1354             uint256 I = reward.reward_integral;
1355             if (supply > 0) {
1356                 I = I + d_reward.mul(1e20).div(supply);
1357             }
1358 
1359             uint256 newlyClaimable = _getDepositedBalance(_account).mul(I.sub(reward.reward_integral_for[_account])).div(1e20);
1360             claimable[i].amount = reward.claimable_reward[_account].add(newlyClaimable);
1361             claimable[i].token = reward.reward_token;
1362 
1363             //calc cvx here
1364             if(reward.reward_token == crv){
1365                 claimable[rewardCount].amount = cvx_claimable_reward[_account].add(CvxMining.ConvertCrvToCvx(newlyClaimable));
1366                 claimable[rewardCount].token = cvx;
1367             }
1368         }
1369         return claimable;
1370     }
1371 
1372     function getReward(address _account) external {
1373         //claim directly in checkpoint logic to save a bit of gas
1374         _checkpointAndClaim([_account, address(0)]);
1375     }
1376 
1377     //deposit a curve token
1378     function deposit(uint256 _amount, address _to) external nonReentrant {
1379         require(!isShutdown, "shutdown");
1380 
1381         //dont need to call checkpoint since _mint() will
1382 
1383         if (_amount > 0) {
1384             _mint(_to, _amount);
1385             IERC20(curveToken).safeTransferFrom(msg.sender, address(this), _amount);
1386             IConvexDeposits(convexBooster).deposit(convexPoolId, _amount, true);
1387         }
1388 
1389         emit Deposited(msg.sender, _to, _amount, true);
1390     }
1391 
1392     //stake a convex token
1393     function stake(uint256 _amount, address _to) external nonReentrant {
1394         require(!isShutdown, "shutdown");
1395 
1396         //dont need to call checkpoint since _mint() will
1397 
1398         if (_amount > 0) {
1399             _mint(_to, _amount);
1400             IERC20(convexToken).safeTransferFrom(msg.sender, address(this), _amount);
1401             IRewardStaking(convexPool).stake(_amount);
1402         }
1403 
1404         emit Deposited(msg.sender, _to, _amount, false);
1405     }
1406 
1407     //withdraw to convex deposit token
1408     function withdraw(uint256 _amount) external nonReentrant {
1409 
1410         //dont need to call checkpoint since _burn() will
1411 
1412         if (_amount > 0) {
1413             _burn(msg.sender, _amount);
1414             IRewardStaking(convexPool).withdraw(_amount, false);
1415             IERC20(convexToken).safeTransfer(msg.sender, _amount);
1416         }
1417 
1418         emit Withdrawn(msg.sender, _amount, false);
1419     }
1420 
1421     //withdraw to underlying curve lp token
1422     function withdrawAndUnwrap(uint256 _amount) external nonReentrant {
1423         
1424         //dont need to call checkpoint since _burn() will
1425 
1426         if (_amount > 0) {
1427             _burn(msg.sender, _amount);
1428             IRewardStaking(convexPool).withdrawAndUnwrap(_amount, false);
1429             IERC20(curveToken).safeTransfer(msg.sender, _amount);
1430         }
1431 
1432         //events
1433         emit Withdrawn(msg.sender, _amount, true);
1434     }
1435 
1436     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override {
1437         _checkpoint([_from, _to]);
1438     }
1439 }
1440 
1441 // File: contracts\wrappers\ConvexStakingWrapperAbra.sol
1442 
1443 pragma solidity 0.6.12;
1444 
1445 
1446 //Staking wrapper for Abracadabra platform
1447 //use convex LP positions as collateral while still receiving rewards
1448 contract ConvexStakingWrapperAbra is ConvexStakingWrapper {
1449     using SafeERC20
1450     for IERC20;
1451     using Address
1452     for address;
1453     using SafeMath
1454     for uint256;
1455 
1456     address public cauldron;
1457 
1458     constructor() public{}
1459 
1460     function initialize(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId, address _vault)
1461     override external {
1462         require(!isInit,"already init");
1463         owner = address(0xa3C5A1e09150B75ff251c1a7815A07182c3de2FB); //default to convex multisig
1464         emit OwnershipTransferred(address(0), owner);
1465         _tokenname = string(abi.encodePacked("Staked ", ERC20(_convexToken).name(), " Abra" ));
1466         _tokensymbol = string(abi.encodePacked("stk", ERC20(_convexToken).symbol(), "-abra"));
1467         isShutdown = false;
1468         isInit = true;
1469         curveToken = _curveToken;
1470         convexToken = _convexToken;
1471         convexPool = _convexPool;
1472         convexPoolId = _poolId;
1473         cauldron = _vault;
1474         collateralVault = address(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966);
1475     
1476         //add rewards
1477         addRewards();
1478         setApprovals();
1479     }
1480 
1481     function setCauldron(address _cauldron) external onlyOwner{
1482         require(cauldron == address(0),"!0"); //immutable once set
1483         cauldron = _cauldron;
1484     }
1485 
1486     function _getDepositedBalance(address _account) internal override view returns(uint256) {
1487         if (_account == address(0) || _account == collateralVault) {
1488             return 0;
1489         }
1490 
1491         if(cauldron == address(0)){
1492             return balanceOf(_account);
1493         }
1494         
1495         //get collateral balance
1496         uint256 collateral = ICauldron(cauldron).userCollateralShare(_account);
1497         collateral = IBentoBox(collateralVault).toAmount(address(this), collateral, false);
1498 
1499         //add to balance of this token
1500         return balanceOf(_account).add(collateral);
1501     }
1502 }