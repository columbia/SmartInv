1 // SPDX-License-Identifier: MIT
2 // File: contracts\interfaces\ICauldron.sol
3 
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
93 pragma solidity >=0.6.0 <0.8.0;
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         uint256 c = a + b;
116         if (c < a) return (false, 0);
117         return (true, c);
118     }
119 
120     /**
121      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         if (b > a) return (false, 0);
127         return (true, a - b);
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
132      *
133      * _Available since v3.4._
134      */
135     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139         if (a == 0) return (true, 0);
140         uint256 c = a * b;
141         if (c / a != b) return (false, 0);
142         return (true, c);
143     }
144 
145     /**
146      * @dev Returns the division of two unsigned integers, with a division by zero flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         if (b == 0) return (false, 0);
152         return (true, a / b);
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         if (b == 0) return (false, 0);
162         return (true, a % b);
163     }
164 
165     /**
166      * @dev Returns the addition of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `+` operator.
170      *
171      * Requirements:
172      *
173      * - Addition cannot overflow.
174      */
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a + b;
177         require(c >= a, "SafeMath: addition overflow");
178         return c;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         require(b <= a, "SafeMath: subtraction overflow");
193         return a - b;
194     }
195 
196     /**
197      * @dev Returns the multiplication of two unsigned integers, reverting on
198      * overflow.
199      *
200      * Counterpart to Solidity's `*` operator.
201      *
202      * Requirements:
203      *
204      * - Multiplication cannot overflow.
205      */
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207         if (a == 0) return 0;
208         uint256 c = a * b;
209         require(c / a == b, "SafeMath: multiplication overflow");
210         return c;
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers, reverting on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b) internal pure returns (uint256) {
226         require(b > 0, "SafeMath: division by zero");
227         return a / b;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * reverting when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         require(b > 0, "SafeMath: modulo by zero");
244         return a % b;
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
249      * overflow (when the result is negative).
250      *
251      * CAUTION: This function is deprecated because it requires allocating memory for the error
252      * message unnecessarily. For custom revert reasons use {trySub}.
253      *
254      * Counterpart to Solidity's `-` operator.
255      *
256      * Requirements:
257      *
258      * - Subtraction cannot overflow.
259      */
260     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b <= a, errorMessage);
262         return a - b;
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
267      * division by zero. The result is rounded towards zero.
268      *
269      * CAUTION: This function is deprecated because it requires allocating memory for the error
270      * message unnecessarily. For custom revert reasons use {tryDiv}.
271      *
272      * Counterpart to Solidity's `/` operator. Note: this function uses a
273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
274      * uses an invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b > 0, errorMessage);
282         return a / b;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * reverting with custom message when dividing by zero.
288      *
289      * CAUTION: This function is deprecated because it requires allocating memory for the error
290      * message unnecessarily. For custom revert reasons use {tryMod}.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b > 0, errorMessage);
302         return a % b;
303     }
304 }
305 
306 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
307 
308 pragma solidity >=0.6.0 <0.8.0;
309 
310 /**
311  * @dev Interface of the ERC20 standard as defined in the EIP.
312  */
313 interface IERC20 {
314     /**
315      * @dev Returns the amount of tokens in existence.
316      */
317     function totalSupply() external view returns (uint256);
318 
319     /**
320      * @dev Returns the amount of tokens owned by `account`.
321      */
322     function balanceOf(address account) external view returns (uint256);
323 
324     /**
325      * @dev Moves `amount` tokens from the caller's account to `recipient`.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transfer(address recipient, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Returns the remaining number of tokens that `spender` will be
335      * allowed to spend on behalf of `owner` through {transferFrom}. This is
336      * zero by default.
337      *
338      * This value changes when {approve} or {transferFrom} are called.
339      */
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * IMPORTANT: Beware that changing an allowance with this method brings the risk
348      * that someone may use both the old and the new allowance by unfortunate
349      * transaction ordering. One possible solution to mitigate this race
350      * condition is to first reduce the spender's allowance to 0 and set the
351      * desired value afterwards:
352      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address spender, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Moves `amount` tokens from `sender` to `recipient` using the
360      * allowance mechanism. `amount` is then deducted from the caller's
361      * allowance.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(address indexed owner, address indexed spender, uint256 value);
382 }
383 
384 // File: @openzeppelin\contracts\utils\Address.sol
385 pragma solidity >=0.6.2 <0.8.0;
386 
387 /**
388  * @dev Collection of functions related to the address type
389  */
390 library Address {
391     /**
392      * @dev Returns true if `account` is a contract.
393      *
394      * [IMPORTANT]
395      * ====
396      * It is unsafe to assume that an address for which this function returns
397      * false is an externally-owned account (EOA) and not a contract.
398      *
399      * Among others, `isContract` will return false for the following
400      * types of addresses:
401      *
402      *  - an externally-owned account
403      *  - a contract in construction
404      *  - an address where a contract will be created
405      *  - an address where a contract lived, but was destroyed
406      * ====
407      */
408     function isContract(address account) internal view returns (bool) {
409         // This method relies on extcodesize, which returns 0 for contracts in
410         // construction, since the code is only stored at the end of the
411         // constructor execution.
412 
413         uint256 size;
414         // solhint-disable-next-line no-inline-assembly
415         assembly { size := extcodesize(account) }
416         return size > 0;
417     }
418 
419     /**
420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
421      * `recipient`, forwarding all available gas and reverting on errors.
422      *
423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
425      * imposed by `transfer`, making them unable to receive funds via
426      * `transfer`. {sendValue} removes this limitation.
427      *
428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
429      *
430      * IMPORTANT: because control is transferred to `recipient`, care must be
431      * taken to not create reentrancy vulnerabilities. Consider using
432      * {ReentrancyGuard} or the
433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
434      */
435     function sendValue(address payable recipient, uint256 amount) internal {
436         require(address(this).balance >= amount, "Address: insufficient balance");
437 
438         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
439         (bool success, ) = recipient.call{ value: amount }("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain`call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462       return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, 0, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but also transferring `value` wei to `target`.
478      *
479      * Requirements:
480      *
481      * - the calling contract must have an ETH balance of at least `value`.
482      * - the called Solidity function must be `payable`.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
492      * with `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
497         require(address(this).balance >= value, "Address: insufficient balance for call");
498         require(isContract(target), "Address: call to non-contract");
499 
500         // solhint-disable-next-line avoid-low-level-calls
501         (bool success, bytes memory returndata) = target.call{ value: value }(data);
502         return _verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but performing a static call.
508      *
509      * _Available since v3.3._
510      */
511     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
512         return functionStaticCall(target, data, "Address: low-level static call failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
522         require(isContract(target), "Address: static call to non-contract");
523 
524         // solhint-disable-next-line avoid-low-level-calls
525         (bool success, bytes memory returndata) = target.staticcall(data);
526         return _verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but performing a delegate call.
532      *
533      * _Available since v3.4._
534      */
535     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
536         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
541      * but performing a delegate call.
542      *
543      * _Available since v3.4._
544      */
545     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
546         require(isContract(target), "Address: delegate call to non-contract");
547 
548         // solhint-disable-next-line avoid-low-level-calls
549         (bool success, bytes memory returndata) = target.delegatecall(data);
550         return _verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
554         if (success) {
555             return returndata;
556         } else {
557             // Look for revert reason and bubble it up if present
558             if (returndata.length > 0) {
559                 // The easiest way to bubble the revert reason is using memory via assembly
560 
561                 // solhint-disable-next-line no-inline-assembly
562                 assembly {
563                     let returndata_size := mload(returndata)
564                     revert(add(32, returndata), returndata_size)
565                 }
566             } else {
567                 revert(errorMessage);
568             }
569         }
570     }
571 }
572 
573 
574 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
575 
576 pragma solidity >=0.6.0 <0.8.0;
577 
578 
579 /**
580  * @title SafeERC20
581  * @dev Wrappers around ERC20 operations that throw on failure (when the token
582  * contract returns false). Tokens that return no value (and instead revert or
583  * throw on failure) are also supported, non-reverting calls are assumed to be
584  * successful.
585  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
586  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
587  */
588 library SafeERC20 {
589     using SafeMath for uint256;
590     using Address for address;
591 
592     function safeTransfer(IERC20 token, address to, uint256 value) internal {
593         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
594     }
595 
596     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
597         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
598     }
599 
600     /**
601      * @dev Deprecated. This function has issues similar to the ones found in
602      * {IERC20-approve}, and its usage is discouraged.
603      *
604      * Whenever possible, use {safeIncreaseAllowance} and
605      * {safeDecreaseAllowance} instead.
606      */
607     function safeApprove(IERC20 token, address spender, uint256 value) internal {
608         // safeApprove should only be called when setting an initial allowance,
609         // or when resetting it to zero. To increase and decrease it, use
610         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
611         // solhint-disable-next-line max-line-length
612         require((value == 0) || (token.allowance(address(this), spender) == 0),
613             "SafeERC20: approve from non-zero to non-zero allowance"
614         );
615         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
616     }
617 
618     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
619         uint256 newAllowance = token.allowance(address(this), spender).add(value);
620         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
621     }
622 
623     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
624         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
625         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
626     }
627 
628     /**
629      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
630      * on the return value: the return value is optional (but if data is returned, it must not be false).
631      * @param token The token targeted by the call.
632      * @param data The call data (encoded using abi.encode or one of its variants).
633      */
634     function _callOptionalReturn(IERC20 token, bytes memory data) private {
635         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
636         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
637         // the target address contains contract code and also asserts for success in the low-level call.
638 
639         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
640         if (returndata.length > 0) { // Return data is optional
641             // solhint-disable-next-line max-line-length
642             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
643         }
644     }
645 }
646 
647 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
648 
649 pragma solidity >=0.6.0 <0.8.0;
650 
651 /*
652  * @dev Provides information about the current execution context, including the
653  * sender of the transaction and its data. While these are generally available
654  * via msg.sender and msg.data, they should not be accessed in such a direct
655  * manner, since when dealing with GSN meta-transactions the account sending and
656  * paying for execution may not be the actual sender (as far as an application
657  * is concerned).
658  *
659  * This contract is only required for intermediate, library-like contracts.
660  */
661 abstract contract Context {
662     function _msgSender() internal view virtual returns (address payable) {
663         return msg.sender;
664     }
665 
666     function _msgData() internal view virtual returns (bytes memory) {
667         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
668         return msg.data;
669     }
670 }
671 
672 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
673 pragma solidity >=0.6.0 <0.8.0;
674 
675 
676 /**
677  * @dev Implementation of the {IERC20} interface.
678  *
679  * This implementation is agnostic to the way tokens are created. This means
680  * that a supply mechanism has to be added in a derived contract using {_mint}.
681  * For a generic mechanism see {ERC20PresetMinterPauser}.
682  *
683  * TIP: For a detailed writeup see our guide
684  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
685  * to implement supply mechanisms].
686  *
687  * We have followed general OpenZeppelin guidelines: functions revert instead
688  * of returning `false` on failure. This behavior is nonetheless conventional
689  * and does not conflict with the expectations of ERC20 applications.
690  *
691  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
692  * This allows applications to reconstruct the allowance for all accounts just
693  * by listening to said events. Other implementations of the EIP may not emit
694  * these events, as it isn't required by the specification.
695  *
696  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
697  * functions have been added to mitigate the well-known issues around setting
698  * allowances. See {IERC20-approve}.
699  */
700 contract ERC20 is Context, IERC20 {
701     using SafeMath for uint256;
702 
703     mapping (address => uint256) private _balances;
704 
705     mapping (address => mapping (address => uint256)) private _allowances;
706 
707     uint256 private _totalSupply;
708 
709     string private _name;
710     string private _symbol;
711     uint8 private _decimals;
712 
713     /**
714      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
715      * a default value of 18.
716      *
717      * To select a different value for {decimals}, use {_setupDecimals}.
718      *
719      * All three of these values are immutable: they can only be set once during
720      * construction.
721      */
722     constructor (string memory name_, string memory symbol_) public {
723         _name = name_;
724         _symbol = symbol_;
725         _decimals = 18;
726     }
727 
728     /**
729      * @dev Returns the name of the token.
730      */
731     function name() public view virtual returns (string memory) {
732         return _name;
733     }
734 
735     /**
736      * @dev Returns the symbol of the token, usually a shorter version of the
737      * name.
738      */
739     function symbol() public view virtual returns (string memory) {
740         return _symbol;
741     }
742 
743     /**
744      * @dev Returns the number of decimals used to get its user representation.
745      * For example, if `decimals` equals `2`, a balance of `505` tokens should
746      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
747      *
748      * Tokens usually opt for a value of 18, imitating the relationship between
749      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
750      * called.
751      *
752      * NOTE: This information is only used for _display_ purposes: it in
753      * no way affects any of the arithmetic of the contract, including
754      * {IERC20-balanceOf} and {IERC20-transfer}.
755      */
756     function decimals() public view virtual returns (uint8) {
757         return _decimals;
758     }
759 
760     /**
761      * @dev See {IERC20-totalSupply}.
762      */
763     function totalSupply() public view virtual override returns (uint256) {
764         return _totalSupply;
765     }
766 
767     /**
768      * @dev See {IERC20-balanceOf}.
769      */
770     function balanceOf(address account) public view virtual override returns (uint256) {
771         return _balances[account];
772     }
773 
774     /**
775      * @dev See {IERC20-transfer}.
776      *
777      * Requirements:
778      *
779      * - `recipient` cannot be the zero address.
780      * - the caller must have a balance of at least `amount`.
781      */
782     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
783         _transfer(_msgSender(), recipient, amount);
784         return true;
785     }
786 
787     /**
788      * @dev See {IERC20-allowance}.
789      */
790     function allowance(address owner, address spender) public view virtual override returns (uint256) {
791         return _allowances[owner][spender];
792     }
793 
794     /**
795      * @dev See {IERC20-approve}.
796      *
797      * Requirements:
798      *
799      * - `spender` cannot be the zero address.
800      */
801     function approve(address spender, uint256 amount) public virtual override returns (bool) {
802         _approve(_msgSender(), spender, amount);
803         return true;
804     }
805 
806     /**
807      * @dev See {IERC20-transferFrom}.
808      *
809      * Emits an {Approval} event indicating the updated allowance. This is not
810      * required by the EIP. See the note at the beginning of {ERC20}.
811      *
812      * Requirements:
813      *
814      * - `sender` and `recipient` cannot be the zero address.
815      * - `sender` must have a balance of at least `amount`.
816      * - the caller must have allowance for ``sender``'s tokens of at least
817      * `amount`.
818      */
819     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
820         _transfer(sender, recipient, amount);
821         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
822         return true;
823     }
824 
825     /**
826      * @dev Atomically increases the allowance granted to `spender` by the caller.
827      *
828      * This is an alternative to {approve} that can be used as a mitigation for
829      * problems described in {IERC20-approve}.
830      *
831      * Emits an {Approval} event indicating the updated allowance.
832      *
833      * Requirements:
834      *
835      * - `spender` cannot be the zero address.
836      */
837     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
838         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
839         return true;
840     }
841 
842     /**
843      * @dev Atomically decreases the allowance granted to `spender` by the caller.
844      *
845      * This is an alternative to {approve} that can be used as a mitigation for
846      * problems described in {IERC20-approve}.
847      *
848      * Emits an {Approval} event indicating the updated allowance.
849      *
850      * Requirements:
851      *
852      * - `spender` cannot be the zero address.
853      * - `spender` must have allowance for the caller of at least
854      * `subtractedValue`.
855      */
856     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
857         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
858         return true;
859     }
860 
861     /**
862      * @dev Moves tokens `amount` from `sender` to `recipient`.
863      *
864      * This is internal function is equivalent to {transfer}, and can be used to
865      * e.g. implement automatic token fees, slashing mechanisms, etc.
866      *
867      * Emits a {Transfer} event.
868      *
869      * Requirements:
870      *
871      * - `sender` cannot be the zero address.
872      * - `recipient` cannot be the zero address.
873      * - `sender` must have a balance of at least `amount`.
874      */
875     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
876         require(sender != address(0), "ERC20: transfer from the zero address");
877         require(recipient != address(0), "ERC20: transfer to the zero address");
878 
879         _beforeTokenTransfer(sender, recipient, amount);
880 
881         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
882         _balances[recipient] = _balances[recipient].add(amount);
883         emit Transfer(sender, recipient, amount);
884     }
885 
886     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
887      * the total supply.
888      *
889      * Emits a {Transfer} event with `from` set to the zero address.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      */
895     function _mint(address account, uint256 amount) internal virtual {
896         require(account != address(0), "ERC20: mint to the zero address");
897 
898         _beforeTokenTransfer(address(0), account, amount);
899 
900         _totalSupply = _totalSupply.add(amount);
901         _balances[account] = _balances[account].add(amount);
902         emit Transfer(address(0), account, amount);
903     }
904 
905     /**
906      * @dev Destroys `amount` tokens from `account`, reducing the
907      * total supply.
908      *
909      * Emits a {Transfer} event with `to` set to the zero address.
910      *
911      * Requirements:
912      *
913      * - `account` cannot be the zero address.
914      * - `account` must have at least `amount` tokens.
915      */
916     function _burn(address account, uint256 amount) internal virtual {
917         require(account != address(0), "ERC20: burn from the zero address");
918 
919         _beforeTokenTransfer(account, address(0), amount);
920 
921         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
922         _totalSupply = _totalSupply.sub(amount);
923         emit Transfer(account, address(0), amount);
924     }
925 
926     /**
927      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
928      *
929      * This internal function is equivalent to `approve`, and can be used to
930      * e.g. set automatic allowances for certain subsystems, etc.
931      *
932      * Emits an {Approval} event.
933      *
934      * Requirements:
935      *
936      * - `owner` cannot be the zero address.
937      * - `spender` cannot be the zero address.
938      */
939     function _approve(address owner, address spender, uint256 amount) internal virtual {
940         require(owner != address(0), "ERC20: approve from the zero address");
941         require(spender != address(0), "ERC20: approve to the zero address");
942 
943         _allowances[owner][spender] = amount;
944         emit Approval(owner, spender, amount);
945     }
946 
947     /**
948      * @dev Sets {decimals} to a value other than the default one of 18.
949      *
950      * WARNING: This function should only be called from the constructor. Most
951      * applications that interact with token contracts will not expect
952      * {decimals} to ever change, and may work incorrectly if it does.
953      */
954     function _setupDecimals(uint8 decimals_) internal virtual {
955         _decimals = decimals_;
956     }
957 
958     /**
959      * @dev Hook that is called before any transfer of tokens. This includes
960      * minting and burning.
961      *
962      * Calling conditions:
963      *
964      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
965      * will be to transferred to `to`.
966      * - when `from` is zero, `amount` tokens will be minted for `to`.
967      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
968      * - `from` and `to` are never both zero.
969      *
970      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
971      */
972     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
973 }
974 
975 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
976 pragma solidity >=0.6.0 <0.8.0;
977 
978 /**
979  * @dev Contract module that helps prevent reentrant calls to a function.
980  *
981  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
982  * available, which can be applied to functions to make sure there are no nested
983  * (reentrant) calls to them.
984  *
985  * Note that because there is a single `nonReentrant` guard, functions marked as
986  * `nonReentrant` may not call one another. This can be worked around by making
987  * those functions `private`, and then adding `external` `nonReentrant` entry
988  * points to them.
989  *
990  * TIP: If you would like to learn more about reentrancy and alternative ways
991  * to protect against it, check out our blog post
992  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
993  */
994 abstract contract ReentrancyGuard {
995     // Booleans are more expensive than uint256 or any type that takes up a full
996     // word because each write operation emits an extra SLOAD to first read the
997     // slot's contents, replace the bits taken up by the boolean, and then write
998     // back. This is the compiler's defense against contract upgrades and
999     // pointer aliasing, and it cannot be disabled.
1000 
1001     // The values being non-zero value makes deployment a bit more expensive,
1002     // but in exchange the refund on every call to nonReentrant will be lower in
1003     // amount. Since refunds are capped to a percentage of the total
1004     // transaction's gas, it is best to keep them low in cases like this one, to
1005     // increase the likelihood of the full refund coming into effect.
1006     uint256 private constant _NOT_ENTERED = 1;
1007     uint256 private constant _ENTERED = 2;
1008 
1009     uint256 private _status;
1010 
1011     constructor () internal {
1012         _status = _NOT_ENTERED;
1013     }
1014 
1015     /**
1016      * @dev Prevents a contract from calling itself, directly or indirectly.
1017      * Calling a `nonReentrant` function from another `nonReentrant`
1018      * function is not supported. It is possible to prevent this from happening
1019      * by making the `nonReentrant` function external, and make it call a
1020      * `private` function that does the actual work.
1021      */
1022     modifier nonReentrant() {
1023         // On the first call to nonReentrant, _notEntered will be true
1024         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1025 
1026         // Any calls to nonReentrant after this point will fail
1027         _status = _ENTERED;
1028 
1029         _;
1030 
1031         // By storing the original value once again, a refund is triggered (see
1032         // https://eips.ethereum.org/EIPS/eip-2200)
1033         _status = _NOT_ENTERED;
1034     }
1035 }
1036 
1037 // File: contracts\wrappers\ConvexStakingWrapper.sol
1038 
1039 pragma solidity 0.6.12;
1040 pragma experimental ABIEncoderV2;
1041 
1042 //Example of a tokenize a convex staked position.
1043 //if used as collateral some modifications will be needed to fit the specific platform
1044 
1045 //Based on Curve.fi's gauge wrapper implementations at https://github.com/curvefi/curve-dao-contracts/tree/master/contracts/gauges/wrappers
1046 contract ConvexStakingWrapper is ERC20, ReentrancyGuard {
1047     using SafeERC20
1048     for IERC20;
1049     using Address
1050     for address;
1051     using SafeMath
1052     for uint256;
1053 
1054     struct EarnedData {
1055         address token;
1056         uint256 amount;
1057     }
1058 
1059     struct RewardType {
1060         address reward_token;
1061         address reward_pool;
1062         uint128 reward_integral;
1063         uint128 reward_remaining;
1064         mapping(address => uint256) reward_integral_for;
1065         mapping(address => uint256) claimable_reward;
1066     }
1067 
1068     uint256 public cvx_reward_integral;
1069     uint256 public cvx_reward_remaining;
1070     mapping(address => uint256) public cvx_reward_integral_for;
1071     mapping(address => uint256) public cvx_claimable_reward;
1072 
1073     //constants/immutables
1074     address public constant convexBooster = address(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
1075     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
1076     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
1077     address public curveToken;
1078     address public convexToken;
1079     address public convexPool;
1080     uint256 public convexPoolId;
1081     address public collateralVault;
1082 
1083     //rewards
1084     RewardType[] public rewards;
1085 
1086     //management
1087     bool public isShutdown;
1088     bool public isInit;
1089     address public owner;
1090 
1091     string internal _tokenname;
1092     string internal _tokensymbol;
1093 
1094     event Deposited(address indexed _user, address indexed _account, uint256 _amount, bool _wrapped);
1095     event Withdrawn(address indexed _user, uint256 _amount, bool _unwrapped);
1096     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1097 
1098     constructor() public
1099         ERC20(
1100             "StakedConvexToken",
1101             "stkCvx"
1102         ){
1103     }
1104 
1105     function initialize(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId, address _vault)
1106     virtual external {
1107         require(!isInit,"already init");
1108         owner = address(0xa3C5A1e09150B75ff251c1a7815A07182c3de2FB); //default to convex multisig
1109         emit OwnershipTransferred(address(0), owner);
1110 
1111         _tokenname = string(abi.encodePacked("Staked ", ERC20(_convexToken).name() ));
1112         _tokensymbol = string(abi.encodePacked("stk", ERC20(_convexToken).symbol()));
1113         isShutdown = false;
1114         isInit = true;
1115         curveToken = _curveToken;
1116         convexToken = _convexToken;
1117         convexPool = _convexPool;
1118         convexPoolId = _poolId;
1119         collateralVault = _vault;
1120 
1121         //add rewards
1122         addRewards();
1123         setApprovals();
1124     }
1125 
1126     function name() public view override returns (string memory) {
1127         return _tokenname;
1128     }
1129 
1130     function symbol() public view override returns (string memory) {
1131         return _tokensymbol;
1132     }
1133 
1134     modifier onlyOwner() {
1135         require(owner == msg.sender, "Ownable: caller is not the owner");
1136         _;
1137     }
1138 
1139     function transferOwnership(address newOwner) public virtual onlyOwner {
1140         require(newOwner != address(0), "Ownable: new owner is the zero address");
1141         emit OwnershipTransferred(owner, newOwner);
1142         owner = newOwner;
1143     }
1144 
1145     function renounceOwnership() public virtual onlyOwner {
1146         emit OwnershipTransferred(owner, address(0));
1147         owner = address(0);
1148     }
1149 
1150     function shutdown() external onlyOwner {
1151         isShutdown = true;
1152     }
1153 
1154     function setApprovals() public {
1155         IERC20(curveToken).safeApprove(convexBooster, 0);
1156         IERC20(curveToken).safeApprove(convexBooster, uint256(-1));
1157         IERC20(convexToken).safeApprove(convexPool, 0);
1158         IERC20(convexToken).safeApprove(convexPool, uint256(-1));
1159     }
1160 
1161     function addRewards() public {
1162         address mainPool = convexPool;
1163 
1164         if (rewards.length == 0) {
1165             rewards.push(
1166                 RewardType({
1167                     reward_token: crv,
1168                     reward_pool: mainPool,
1169                     reward_integral: 0,
1170                     reward_remaining: 0
1171                 })
1172             );
1173         }
1174 
1175         uint256 extraCount = IRewardStaking(mainPool).extraRewardsLength();
1176         uint256 startIndex = rewards.length - 1;
1177         for (uint256 i = startIndex; i < extraCount; i++) {
1178             address extraPool = IRewardStaking(mainPool).extraRewards(i);
1179             rewards.push(
1180                 RewardType({
1181                     reward_token: IRewardStaking(extraPool).rewardToken(),
1182                     reward_pool: extraPool,
1183                     reward_integral: 0,
1184                     reward_remaining: 0
1185                 })
1186             );
1187         }
1188     }
1189 
1190     function rewardLength() external view returns(uint256) {
1191         return rewards.length;
1192     }
1193 
1194     function _getDepositedBalance(address _account) internal virtual view returns(uint256) {
1195         if (_account == address(0) || _account == collateralVault) {
1196             return 0;
1197         }
1198         //get balance from collateralVault
1199 
1200         return balanceOf(_account);
1201     }
1202 
1203     function _getTotalSupply() internal virtual view returns(uint256){
1204 
1205         //override and add any supply needed (interest based growth)
1206 
1207         return totalSupply();
1208     }
1209 
1210 
1211     function _calcCvxIntegral(address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal {
1212 
1213         uint256 bal = IERC20(cvx).balanceOf(address(this));
1214         uint256 d_cvxreward = bal.sub(cvx_reward_remaining);
1215 
1216         if (_supply > 0 && d_cvxreward > 0) {
1217             cvx_reward_integral = cvx_reward_integral + d_cvxreward.mul(1e20).div(_supply);
1218         }
1219 
1220         
1221         //update user integrals for cvx
1222         for (uint256 u = 0; u < _accounts.length; u++) {
1223             //do not give rewards to address 0
1224             if (_accounts[u] == address(0)) continue;
1225             if (_accounts[u] == collateralVault) continue;
1226 
1227             uint userI = cvx_reward_integral_for[_accounts[u]];
1228             if(_isClaim || userI < cvx_reward_integral){
1229                 uint256 receiveable = cvx_claimable_reward[_accounts[u]].add(_balances[u].mul(cvx_reward_integral.sub(userI)).div(1e20));
1230                 if(_isClaim){
1231                     if(receiveable > 0){
1232                         cvx_claimable_reward[_accounts[u]] = 0;
1233                         IERC20(cvx).safeTransfer(_accounts[u], receiveable);
1234                         bal = bal.sub(receiveable);
1235                     }
1236                 }else{
1237                     cvx_claimable_reward[_accounts[u]] = receiveable;
1238                 }
1239                 cvx_reward_integral_for[_accounts[u]] = cvx_reward_integral;
1240            }
1241         }
1242 
1243         //update reward total
1244         if(bal != cvx_reward_remaining){
1245             cvx_reward_remaining = bal;
1246         }
1247     }
1248 
1249     function _calcRewardIntegral(uint256 _index, address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal{
1250          RewardType storage reward = rewards[_index];
1251 
1252         //get difference in balance and remaining rewards
1253         //getReward is unguarded so we use reward_remaining to keep track of how much was actually claimed
1254         uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1255         // uint256 d_reward = bal.sub(reward.reward_remaining);
1256 
1257         if (_supply > 0 && bal.sub(reward.reward_remaining) > 0) {
1258             reward.reward_integral = reward.reward_integral + uint128(bal.sub(reward.reward_remaining).mul(1e20).div(_supply));
1259         }
1260 
1261         //update user integrals
1262         for (uint256 u = 0; u < _accounts.length; u++) {
1263             //do not give rewards to address 0
1264             if (_accounts[u] == address(0)) continue;
1265             if (_accounts[u] == collateralVault) continue;
1266 
1267             uint userI = reward.reward_integral_for[_accounts[u]];
1268             if(_isClaim || userI < reward.reward_integral){
1269                 if(_isClaim){
1270                     uint256 receiveable = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1271                     if(receiveable > 0){
1272                         reward.claimable_reward[_accounts[u]] = 0;
1273                         IERC20(reward.reward_token).safeTransfer(_accounts[u], receiveable);
1274                         bal = bal.sub(receiveable);
1275                     }
1276                 }else{
1277                     reward.claimable_reward[_accounts[u]] = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1278                 }
1279                 reward.reward_integral_for[_accounts[u]] = reward.reward_integral;
1280             }
1281         }
1282 
1283         //update remaining reward here since balance could have changed if claiming
1284         if(bal !=  reward.reward_remaining){
1285             reward.reward_remaining = uint128(bal);
1286         }
1287     }
1288 
1289     function _checkpoint(address[2] memory _accounts) internal {
1290         //if shutdown, no longer checkpoint in case there are problems
1291         if(isShutdown) return;
1292 
1293         uint256 supply = _getTotalSupply();
1294         uint256[2] memory depositedBalance;
1295         depositedBalance[0] = _getDepositedBalance(_accounts[0]);
1296         depositedBalance[1] = _getDepositedBalance(_accounts[1]);
1297         
1298         IRewardStaking(convexPool).getReward(address(this), true);
1299 
1300         uint256 rewardCount = rewards.length;
1301         for (uint256 i = 0; i < rewardCount; i++) {
1302            _calcRewardIntegral(i,_accounts,depositedBalance,supply,false);
1303         }
1304         _calcCvxIntegral(_accounts,depositedBalance,supply,false);
1305     }
1306 
1307     function _checkpointAndClaim(address[2] memory _accounts) internal {
1308 
1309         uint256 supply = _getTotalSupply();
1310         uint256[2] memory depositedBalance;
1311         depositedBalance[0] = _getDepositedBalance(_accounts[0]); //only do first slot
1312         
1313         IRewardStaking(convexPool).getReward(address(this), true);
1314 
1315         uint256 rewardCount = rewards.length;
1316         for (uint256 i = 0; i < rewardCount; i++) {
1317            _calcRewardIntegral(i,_accounts,depositedBalance,supply,true);
1318         }
1319         _calcCvxIntegral(_accounts,depositedBalance,supply,true);
1320     }
1321 
1322     function user_checkpoint(address[2] calldata _accounts) external returns(bool) {
1323         _checkpoint([_accounts[0], _accounts[1]]);
1324         return true;
1325     }
1326 
1327     function totalBalanceOf(address _account) external view returns(uint256){
1328         return _getDepositedBalance(_account);
1329     }
1330 
1331     function earned(address _account) external view returns(EarnedData[] memory claimable) {
1332         uint256 supply = _getTotalSupply();
1333         // uint256 depositedBalance = _getDepositedBalance(_account);
1334         uint256 rewardCount = rewards.length;
1335         claimable = new EarnedData[](rewardCount + 1);
1336 
1337         for (uint256 i = 0; i < rewardCount; i++) {
1338             RewardType storage reward = rewards[i];
1339 
1340             //change in reward is current balance - remaining reward + earned
1341             uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1342             uint256 d_reward = bal.sub(reward.reward_remaining);
1343             d_reward = d_reward.add(IRewardStaking(reward.reward_pool).earned(address(this)));
1344 
1345             uint256 I = reward.reward_integral;
1346             if (supply > 0) {
1347                 I = I + d_reward.mul(1e20).div(supply);
1348             }
1349 
1350             uint256 newlyClaimable = _getDepositedBalance(_account).mul(I.sub(reward.reward_integral_for[_account])).div(1e20);
1351             claimable[i].amount = reward.claimable_reward[_account].add(newlyClaimable);
1352             claimable[i].token = reward.reward_token;
1353 
1354             //calc cvx here
1355             if(reward.reward_token == crv){
1356                 claimable[rewardCount].amount = cvx_claimable_reward[_account].add(CvxMining.ConvertCrvToCvx(newlyClaimable));
1357                 claimable[rewardCount].token = cvx;
1358             }
1359         }
1360         return claimable;
1361     }
1362 
1363     function getReward(address _account) external {
1364         //claim directly in checkpoint logic to save a bit of gas
1365         _checkpointAndClaim([_account, address(0)]);
1366     }
1367 
1368     //deposit a curve token
1369     function deposit(uint256 _amount, address _to) external nonReentrant {
1370         require(!isShutdown, "shutdown");
1371 
1372         //dont need to call checkpoint since _mint() will
1373 
1374         if (_amount > 0) {
1375             _mint(_to, _amount);
1376             IERC20(curveToken).safeTransferFrom(msg.sender, address(this), _amount);
1377             IConvexDeposits(convexBooster).deposit(convexPoolId, _amount, true);
1378         }
1379 
1380         emit Deposited(msg.sender, _to, _amount, true);
1381     }
1382 
1383     //stake a convex token
1384     function stake(uint256 _amount, address _to) external nonReentrant {
1385         require(!isShutdown, "shutdown");
1386 
1387         //dont need to call checkpoint since _mint() will
1388 
1389         if (_amount > 0) {
1390             _mint(_to, _amount);
1391             IERC20(convexToken).safeTransferFrom(msg.sender, address(this), _amount);
1392             IRewardStaking(convexPool).stake(_amount);
1393         }
1394 
1395         emit Deposited(msg.sender, _to, _amount, false);
1396     }
1397 
1398     //withdraw to convex deposit token
1399     function withdraw(uint256 _amount) external nonReentrant {
1400 
1401         //dont need to call checkpoint since _burn() will
1402 
1403         if (_amount > 0) {
1404             _burn(msg.sender, _amount);
1405             IRewardStaking(convexPool).withdraw(_amount, false);
1406             IERC20(convexToken).safeTransfer(msg.sender, _amount);
1407         }
1408 
1409         emit Withdrawn(msg.sender, _amount, false);
1410     }
1411 
1412     //withdraw to underlying curve lp token
1413     function withdrawAndUnwrap(uint256 _amount) external nonReentrant {
1414         
1415         //dont need to call checkpoint since _burn() will
1416 
1417         if (_amount > 0) {
1418             _burn(msg.sender, _amount);
1419             IRewardStaking(convexPool).withdrawAndUnwrap(_amount, false);
1420             IERC20(curveToken).safeTransfer(msg.sender, _amount);
1421         }
1422 
1423         //events
1424         emit Withdrawn(msg.sender, _amount, true);
1425     }
1426 
1427     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override {
1428         _checkpoint([_from, _to]);
1429     }
1430 }
1431 
1432 // File: contracts\wrappers\ConvexStakingWrapperAbra.sol
1433 
1434 pragma solidity 0.6.12;
1435 
1436 
1437 //Staking wrapper for Abracadabra platform
1438 //use convex LP positions as collateral while still receiving rewards
1439 contract ConvexStakingWrapperAbra is ConvexStakingWrapper {
1440     using SafeERC20
1441     for IERC20;
1442     using Address
1443     for address;
1444     using SafeMath
1445     for uint256;
1446 
1447     address public cauldron;
1448 
1449     constructor() public{}
1450 
1451     function initialize(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId, address _vault)
1452     override external {
1453         require(!isInit,"already init");
1454         owner = address(0xa3C5A1e09150B75ff251c1a7815A07182c3de2FB); //default to convex multisig
1455         emit OwnershipTransferred(address(0), owner);
1456         _tokenname = string(abi.encodePacked("Staked ", ERC20(_convexToken).name(), " Abra" ));
1457         _tokensymbol = string(abi.encodePacked("stk", ERC20(_convexToken).symbol(), "-abra"));
1458         isShutdown = false;
1459         isInit = true;
1460         curveToken = _curveToken;
1461         convexToken = _convexToken;
1462         convexPool = _convexPool;
1463         convexPoolId = _poolId;
1464         cauldron = _vault;
1465         collateralVault = address(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966);
1466     
1467         //add rewards
1468         addRewards();
1469         setApprovals();
1470     }
1471 
1472     function setCauldron(address _cauldron) external onlyOwner{
1473         require(cauldron == address(0),"!0"); //immutable once set
1474         cauldron = _cauldron;
1475     }
1476 
1477     function _getDepositedBalance(address _account) internal override view returns(uint256) {
1478         if (_account == address(0) || _account == collateralVault) {
1479             return 0;
1480         }
1481 
1482         if(cauldron == address(0)){
1483             return balanceOf(_account);
1484         }
1485         
1486         //get collateral balance
1487         uint256 collateral = ICauldron(cauldron).userCollateralShare(_account);
1488         collateral = IBentoBox(collateralVault).toAmount(address(this), collateral, false);
1489 
1490         //add to balance of this token
1491         return balanceOf(_account).add(collateral);
1492     }
1493 }