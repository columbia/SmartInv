1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts\interfaces\ICauldron.sol
4 pragma solidity 0.6.12;
5 
6 interface ICauldron {
7     function userCollateralShare(address account) external view returns (uint);
8 }
9 
10 // File: contracts\interfaces\IBentoBox.sol
11 pragma solidity 0.6.12;
12 
13 interface IBentoBox {
14     function toAmount(address _token, uint256 _share, bool _roundUp) external view returns (uint);
15 }
16 
17 // File: contracts\interfaces\IRewardStaking.sol
18 
19 pragma solidity 0.6.12;
20 
21 interface IRewardStaking {
22     function stakeFor(address, uint256) external;
23     function stake( uint256) external;
24     function withdraw(uint256 amount, bool claim) external;
25     function withdrawAndUnwrap(uint256 amount, bool claim) external;
26     function earned(address account) external view returns (uint256);
27     function getReward() external;
28     function getReward(address _account, bool _claimExtras) external;
29     function extraRewardsLength() external view returns (uint256);
30     function extraRewards(uint256 _pid) external view returns (address);
31     function rewardToken() external view returns (address);
32     function balanceOf(address _account) external view returns (uint256);
33 }
34 
35 // File: contracts\interfaces\IConvexDeposits.sol
36 
37 pragma solidity 0.6.12;
38 
39 interface IConvexDeposits {
40     function deposit(uint256 _pid, uint256 _amount, bool _stake) external returns(bool);
41     function deposit(uint256 _amount, bool _lock, address _stakeAddress) external;
42 }
43 
44 // File: contracts\interfaces\ICvx.sol
45 
46 pragma solidity 0.6.12;
47 
48 interface ICvx {
49     function reductionPerCliff() external view returns(uint256);
50     function totalSupply() external view returns(uint256);
51     function totalCliffs() external view returns(uint256);
52     function maxSupply() external view returns(uint256);
53 }
54 
55 // File: contracts\interfaces\CvxMining.sol
56 
57 pragma solidity 0.6.12;
58 
59 
60 library CvxMining{
61     ICvx public constant cvx = ICvx(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
62 
63     function ConvertCrvToCvx(uint256 _amount) external view returns(uint256){
64         uint256 supply = cvx.totalSupply();
65         uint256 reductionPerCliff = cvx.reductionPerCliff();
66         uint256 totalCliffs = cvx.totalCliffs();
67         uint256 maxSupply = cvx.maxSupply();
68 
69         uint256 cliff = supply / reductionPerCliff;
70         //mint if below total cliffs
71         if(cliff < totalCliffs){
72             //for reduction% take inverse of current cliff
73             uint256 reduction = totalCliffs - cliff;
74             //reduce
75             _amount = _amount * reduction / totalCliffs;
76 
77             //supply cap check
78             uint256 amtTillMax = maxSupply - supply;
79             if(_amount > amtTillMax){
80                 _amount = amtTillMax;
81             }
82 
83             //mint
84             return _amount;
85         }
86         return 0;
87     }
88 }
89 
90 // File: @openzeppelin\contracts\math\SafeMath.sol
91 
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
385 
386 pragma solidity >=0.6.2 <0.8.0;
387 
388 /**
389  * @dev Collection of functions related to the address type
390  */
391 library Address {
392     /**
393      * @dev Returns true if `account` is a contract.
394      *
395      * [IMPORTANT]
396      * ====
397      * It is unsafe to assume that an address for which this function returns
398      * false is an externally-owned account (EOA) and not a contract.
399      *
400      * Among others, `isContract` will return false for the following
401      * types of addresses:
402      *
403      *  - an externally-owned account
404      *  - a contract in construction
405      *  - an address where a contract will be created
406      *  - an address where a contract lived, but was destroyed
407      * ====
408      */
409     function isContract(address account) internal view returns (bool) {
410         // This method relies on extcodesize, which returns 0 for contracts in
411         // construction, since the code is only stored at the end of the
412         // constructor execution.
413 
414         uint256 size;
415         // solhint-disable-next-line no-inline-assembly
416         assembly { size := extcodesize(account) }
417         return size > 0;
418     }
419 
420     /**
421      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
422      * `recipient`, forwarding all available gas and reverting on errors.
423      *
424      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
425      * of certain opcodes, possibly making contracts go over the 2300 gas limit
426      * imposed by `transfer`, making them unable to receive funds via
427      * `transfer`. {sendValue} removes this limitation.
428      *
429      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
430      *
431      * IMPORTANT: because control is transferred to `recipient`, care must be
432      * taken to not create reentrancy vulnerabilities. Consider using
433      * {ReentrancyGuard} or the
434      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
435      */
436     function sendValue(address payable recipient, uint256 amount) internal {
437         require(address(this).balance >= amount, "Address: insufficient balance");
438 
439         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
440         (bool success, ) = recipient.call{ value: amount }("");
441         require(success, "Address: unable to send value, recipient may have reverted");
442     }
443 
444     /**
445      * @dev Performs a Solidity function call using a low level `call`. A
446      * plain`call` is an unsafe replacement for a function call: use this
447      * function instead.
448      *
449      * If `target` reverts with a revert reason, it is bubbled up by this
450      * function (like regular Solidity function calls).
451      *
452      * Returns the raw returned data. To convert to the expected return value,
453      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
454      *
455      * Requirements:
456      *
457      * - `target` must be a contract.
458      * - calling `target` with `data` must not revert.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
463       return functionCall(target, data, "Address: low-level call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
468      * `errorMessage` as a fallback revert reason when `target` reverts.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, 0, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but also transferring `value` wei to `target`.
479      *
480      * Requirements:
481      *
482      * - the calling contract must have an ETH balance of at least `value`.
483      * - the called Solidity function must be `payable`.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
488         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
493      * with `errorMessage` as a fallback revert reason when `target` reverts.
494      *
495      * _Available since v3.1._
496      */
497     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
498         require(address(this).balance >= value, "Address: insufficient balance for call");
499         require(isContract(target), "Address: call to non-contract");
500 
501         // solhint-disable-next-line avoid-low-level-calls
502         (bool success, bytes memory returndata) = target.call{ value: value }(data);
503         return _verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a static call.
509      *
510      * _Available since v3.3._
511      */
512     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
513         return functionStaticCall(target, data, "Address: low-level static call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
518      * but performing a static call.
519      *
520      * _Available since v3.3._
521      */
522     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
523         require(isContract(target), "Address: static call to non-contract");
524 
525         // solhint-disable-next-line avoid-low-level-calls
526         (bool success, bytes memory returndata) = target.staticcall(data);
527         return _verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a delegate call.
533      *
534      * _Available since v3.4._
535      */
536     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
537         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a delegate call.
543      *
544      * _Available since v3.4._
545      */
546     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
547         require(isContract(target), "Address: delegate call to non-contract");
548 
549         // solhint-disable-next-line avoid-low-level-calls
550         (bool success, bytes memory returndata) = target.delegatecall(data);
551         return _verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
555         if (success) {
556             return returndata;
557         } else {
558             // Look for revert reason and bubble it up if present
559             if (returndata.length > 0) {
560                 // The easiest way to bubble the revert reason is using memory via assembly
561 
562                 // solhint-disable-next-line no-inline-assembly
563                 assembly {
564                     let returndata_size := mload(returndata)
565                     revert(add(32, returndata), returndata_size)
566                 }
567             } else {
568                 revert(errorMessage);
569             }
570         }
571     }
572 }
573 
574 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
575 
576 pragma solidity >=0.6.0 <0.8.0;
577 
578 
579 
580 /**
581  * @title SafeERC20
582  * @dev Wrappers around ERC20 operations that throw on failure (when the token
583  * contract returns false). Tokens that return no value (and instead revert or
584  * throw on failure) are also supported, non-reverting calls are assumed to be
585  * successful.
586  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
587  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
588  */
589 library SafeERC20 {
590     using SafeMath for uint256;
591     using Address for address;
592 
593     function safeTransfer(IERC20 token, address to, uint256 value) internal {
594         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
595     }
596 
597     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
598         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
599     }
600 
601     /**
602      * @dev Deprecated. This function has issues similar to the ones found in
603      * {IERC20-approve}, and its usage is discouraged.
604      *
605      * Whenever possible, use {safeIncreaseAllowance} and
606      * {safeDecreaseAllowance} instead.
607      */
608     function safeApprove(IERC20 token, address spender, uint256 value) internal {
609         // safeApprove should only be called when setting an initial allowance,
610         // or when resetting it to zero. To increase and decrease it, use
611         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
612         // solhint-disable-next-line max-line-length
613         require((value == 0) || (token.allowance(address(this), spender) == 0),
614             "SafeERC20: approve from non-zero to non-zero allowance"
615         );
616         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
617     }
618 
619     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
620         uint256 newAllowance = token.allowance(address(this), spender).add(value);
621         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
622     }
623 
624     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
625         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
626         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
627     }
628 
629     /**
630      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
631      * on the return value: the return value is optional (but if data is returned, it must not be false).
632      * @param token The token targeted by the call.
633      * @param data The call data (encoded using abi.encode or one of its variants).
634      */
635     function _callOptionalReturn(IERC20 token, bytes memory data) private {
636         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
637         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
638         // the target address contains contract code and also asserts for success in the low-level call.
639 
640         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
641         if (returndata.length > 0) { // Return data is optional
642             // solhint-disable-next-line max-line-length
643             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
644         }
645     }
646 }
647 
648 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
649 
650 pragma solidity >=0.6.0 <0.8.0;
651 
652 /*
653  * @dev Provides information about the current execution context, including the
654  * sender of the transaction and its data. While these are generally available
655  * via msg.sender and msg.data, they should not be accessed in such a direct
656  * manner, since when dealing with GSN meta-transactions the account sending and
657  * paying for execution may not be the actual sender (as far as an application
658  * is concerned).
659  *
660  * This contract is only required for intermediate, library-like contracts.
661  */
662 abstract contract Context {
663     function _msgSender() internal view virtual returns (address payable) {
664         return msg.sender;
665     }
666 
667     function _msgData() internal view virtual returns (bytes memory) {
668         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
669         return msg.data;
670     }
671 }
672 
673 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
674 
675 pragma solidity >=0.6.0 <0.8.0;
676 
677 
678 /**
679  * @dev Implementation of the {IERC20} interface.
680  *
681  * This implementation is agnostic to the way tokens are created. This means
682  * that a supply mechanism has to be added in a derived contract using {_mint}.
683  * For a generic mechanism see {ERC20PresetMinterPauser}.
684  *
685  * TIP: For a detailed writeup see our guide
686  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
687  * to implement supply mechanisms].
688  *
689  * We have followed general OpenZeppelin guidelines: functions revert instead
690  * of returning `false` on failure. This behavior is nonetheless conventional
691  * and does not conflict with the expectations of ERC20 applications.
692  *
693  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
694  * This allows applications to reconstruct the allowance for all accounts just
695  * by listening to said events. Other implementations of the EIP may not emit
696  * these events, as it isn't required by the specification.
697  *
698  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
699  * functions have been added to mitigate the well-known issues around setting
700  * allowances. See {IERC20-approve}.
701  */
702 contract ERC20 is Context, IERC20 {
703     using SafeMath for uint256;
704 
705     mapping (address => uint256) private _balances;
706 
707     mapping (address => mapping (address => uint256)) private _allowances;
708 
709     uint256 private _totalSupply;
710 
711     string private _name;
712     string private _symbol;
713     uint8 private _decimals;
714 
715     /**
716      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
717      * a default value of 18.
718      *
719      * To select a different value for {decimals}, use {_setupDecimals}.
720      *
721      * All three of these values are immutable: they can only be set once during
722      * construction.
723      */
724     constructor (string memory name_, string memory symbol_) public {
725         _name = name_;
726         _symbol = symbol_;
727         _decimals = 18;
728     }
729 
730     /**
731      * @dev Returns the name of the token.
732      */
733     function name() public view virtual returns (string memory) {
734         return _name;
735     }
736 
737     /**
738      * @dev Returns the symbol of the token, usually a shorter version of the
739      * name.
740      */
741     function symbol() public view virtual returns (string memory) {
742         return _symbol;
743     }
744 
745     /**
746      * @dev Returns the number of decimals used to get its user representation.
747      * For example, if `decimals` equals `2`, a balance of `505` tokens should
748      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
749      *
750      * Tokens usually opt for a value of 18, imitating the relationship between
751      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
752      * called.
753      *
754      * NOTE: This information is only used for _display_ purposes: it in
755      * no way affects any of the arithmetic of the contract, including
756      * {IERC20-balanceOf} and {IERC20-transfer}.
757      */
758     function decimals() public view virtual returns (uint8) {
759         return _decimals;
760     }
761 
762     /**
763      * @dev See {IERC20-totalSupply}.
764      */
765     function totalSupply() public view virtual override returns (uint256) {
766         return _totalSupply;
767     }
768 
769     /**
770      * @dev See {IERC20-balanceOf}.
771      */
772     function balanceOf(address account) public view virtual override returns (uint256) {
773         return _balances[account];
774     }
775 
776     /**
777      * @dev See {IERC20-transfer}.
778      *
779      * Requirements:
780      *
781      * - `recipient` cannot be the zero address.
782      * - the caller must have a balance of at least `amount`.
783      */
784     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
785         _transfer(_msgSender(), recipient, amount);
786         return true;
787     }
788 
789     /**
790      * @dev See {IERC20-allowance}.
791      */
792     function allowance(address owner, address spender) public view virtual override returns (uint256) {
793         return _allowances[owner][spender];
794     }
795 
796     /**
797      * @dev See {IERC20-approve}.
798      *
799      * Requirements:
800      *
801      * - `spender` cannot be the zero address.
802      */
803     function approve(address spender, uint256 amount) public virtual override returns (bool) {
804         _approve(_msgSender(), spender, amount);
805         return true;
806     }
807 
808     /**
809      * @dev See {IERC20-transferFrom}.
810      *
811      * Emits an {Approval} event indicating the updated allowance. This is not
812      * required by the EIP. See the note at the beginning of {ERC20}.
813      *
814      * Requirements:
815      *
816      * - `sender` and `recipient` cannot be the zero address.
817      * - `sender` must have a balance of at least `amount`.
818      * - the caller must have allowance for ``sender``'s tokens of at least
819      * `amount`.
820      */
821     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
822         _transfer(sender, recipient, amount);
823         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
824         return true;
825     }
826 
827     /**
828      * @dev Atomically increases the allowance granted to `spender` by the caller.
829      *
830      * This is an alternative to {approve} that can be used as a mitigation for
831      * problems described in {IERC20-approve}.
832      *
833      * Emits an {Approval} event indicating the updated allowance.
834      *
835      * Requirements:
836      *
837      * - `spender` cannot be the zero address.
838      */
839     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
840         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
841         return true;
842     }
843 
844     /**
845      * @dev Atomically decreases the allowance granted to `spender` by the caller.
846      *
847      * This is an alternative to {approve} that can be used as a mitigation for
848      * problems described in {IERC20-approve}.
849      *
850      * Emits an {Approval} event indicating the updated allowance.
851      *
852      * Requirements:
853      *
854      * - `spender` cannot be the zero address.
855      * - `spender` must have allowance for the caller of at least
856      * `subtractedValue`.
857      */
858     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
859         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
860         return true;
861     }
862 
863     /**
864      * @dev Moves tokens `amount` from `sender` to `recipient`.
865      *
866      * This is internal function is equivalent to {transfer}, and can be used to
867      * e.g. implement automatic token fees, slashing mechanisms, etc.
868      *
869      * Emits a {Transfer} event.
870      *
871      * Requirements:
872      *
873      * - `sender` cannot be the zero address.
874      * - `recipient` cannot be the zero address.
875      * - `sender` must have a balance of at least `amount`.
876      */
877     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
878         require(sender != address(0), "ERC20: transfer from the zero address");
879         require(recipient != address(0), "ERC20: transfer to the zero address");
880 
881         _beforeTokenTransfer(sender, recipient, amount);
882 
883         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
884         _balances[recipient] = _balances[recipient].add(amount);
885         emit Transfer(sender, recipient, amount);
886     }
887 
888     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
889      * the total supply.
890      *
891      * Emits a {Transfer} event with `from` set to the zero address.
892      *
893      * Requirements:
894      *
895      * - `to` cannot be the zero address.
896      */
897     function _mint(address account, uint256 amount) internal virtual {
898         require(account != address(0), "ERC20: mint to the zero address");
899 
900         _beforeTokenTransfer(address(0), account, amount);
901 
902         _totalSupply = _totalSupply.add(amount);
903         _balances[account] = _balances[account].add(amount);
904         emit Transfer(address(0), account, amount);
905     }
906 
907     /**
908      * @dev Destroys `amount` tokens from `account`, reducing the
909      * total supply.
910      *
911      * Emits a {Transfer} event with `to` set to the zero address.
912      *
913      * Requirements:
914      *
915      * - `account` cannot be the zero address.
916      * - `account` must have at least `amount` tokens.
917      */
918     function _burn(address account, uint256 amount) internal virtual {
919         require(account != address(0), "ERC20: burn from the zero address");
920 
921         _beforeTokenTransfer(account, address(0), amount);
922 
923         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
924         _totalSupply = _totalSupply.sub(amount);
925         emit Transfer(account, address(0), amount);
926     }
927 
928     /**
929      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
930      *
931      * This internal function is equivalent to `approve`, and can be used to
932      * e.g. set automatic allowances for certain subsystems, etc.
933      *
934      * Emits an {Approval} event.
935      *
936      * Requirements:
937      *
938      * - `owner` cannot be the zero address.
939      * - `spender` cannot be the zero address.
940      */
941     function _approve(address owner, address spender, uint256 amount) internal virtual {
942         require(owner != address(0), "ERC20: approve from the zero address");
943         require(spender != address(0), "ERC20: approve to the zero address");
944 
945         _allowances[owner][spender] = amount;
946         emit Approval(owner, spender, amount);
947     }
948 
949     /**
950      * @dev Sets {decimals} to a value other than the default one of 18.
951      *
952      * WARNING: This function should only be called from the constructor. Most
953      * applications that interact with token contracts will not expect
954      * {decimals} to ever change, and may work incorrectly if it does.
955      */
956     function _setupDecimals(uint8 decimals_) internal virtual {
957         _decimals = decimals_;
958     }
959 
960     /**
961      * @dev Hook that is called before any transfer of tokens. This includes
962      * minting and burning.
963      *
964      * Calling conditions:
965      *
966      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
967      * will be to transferred to `to`.
968      * - when `from` is zero, `amount` tokens will be minted for `to`.
969      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
970      * - `from` and `to` are never both zero.
971      *
972      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
973      */
974     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
975 }
976 
977 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
978 
979 pragma solidity >=0.6.0 <0.8.0;
980 
981 /**
982  * @dev Contract module that helps prevent reentrant calls to a function.
983  *
984  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
985  * available, which can be applied to functions to make sure there are no nested
986  * (reentrant) calls to them.
987  *
988  * Note that because there is a single `nonReentrant` guard, functions marked as
989  * `nonReentrant` may not call one another. This can be worked around by making
990  * those functions `private`, and then adding `external` `nonReentrant` entry
991  * points to them.
992  *
993  * TIP: If you would like to learn more about reentrancy and alternative ways
994  * to protect against it, check out our blog post
995  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
996  */
997 abstract contract ReentrancyGuard {
998     // Booleans are more expensive than uint256 or any type that takes up a full
999     // word because each write operation emits an extra SLOAD to first read the
1000     // slot's contents, replace the bits taken up by the boolean, and then write
1001     // back. This is the compiler's defense against contract upgrades and
1002     // pointer aliasing, and it cannot be disabled.
1003 
1004     // The values being non-zero value makes deployment a bit more expensive,
1005     // but in exchange the refund on every call to nonReentrant will be lower in
1006     // amount. Since refunds are capped to a percentage of the total
1007     // transaction's gas, it is best to keep them low in cases like this one, to
1008     // increase the likelihood of the full refund coming into effect.
1009     uint256 private constant _NOT_ENTERED = 1;
1010     uint256 private constant _ENTERED = 2;
1011 
1012     uint256 private _status;
1013 
1014     constructor () internal {
1015         _status = _NOT_ENTERED;
1016     }
1017 
1018     /**
1019      * @dev Prevents a contract from calling itself, directly or indirectly.
1020      * Calling a `nonReentrant` function from another `nonReentrant`
1021      * function is not supported. It is possible to prevent this from happening
1022      * by making the `nonReentrant` function external, and make it call a
1023      * `private` function that does the actual work.
1024      */
1025     modifier nonReentrant() {
1026         // On the first call to nonReentrant, _notEntered will be true
1027         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1028 
1029         // Any calls to nonReentrant after this point will fail
1030         _status = _ENTERED;
1031 
1032         _;
1033 
1034         // By storing the original value once again, a refund is triggered (see
1035         // https://eips.ethereum.org/EIPS/eip-2200)
1036         _status = _NOT_ENTERED;
1037     }
1038 }
1039 
1040 // File: contracts\wrappers\ConvexStakingWrapper.sol
1041 
1042 pragma solidity 0.6.12;
1043 pragma experimental ABIEncoderV2;
1044 
1045 
1046 // import "@openzeppelin/contracts/access/Ownable.sol";
1047 
1048 
1049 //Example of a tokenize a convex staked position.
1050 //if used as collateral some modifications will be needed to fit the specific platform
1051 
1052 //Based on Curve.fi's gauge wrapper implementations at https://github.com/curvefi/curve-dao-contracts/tree/master/contracts/gauges/wrappers
1053 contract ConvexStakingWrapper is ERC20, ReentrancyGuard {
1054     using SafeERC20
1055     for IERC20;
1056     using Address
1057     for address;
1058     using SafeMath
1059     for uint256;
1060 
1061     struct EarnedData {
1062         address token;
1063         uint256 amount;
1064     }
1065 
1066     struct RewardType {
1067         address reward_token;
1068         address reward_pool;
1069         uint128 reward_integral;
1070         uint128 reward_remaining;
1071         mapping(address => uint256) reward_integral_for;
1072         mapping(address => uint256) claimable_reward;
1073     }
1074 
1075     uint256 public cvx_reward_integral;
1076     uint256 public cvx_reward_remaining;
1077     mapping(address => uint256) public cvx_reward_integral_for;
1078     mapping(address => uint256) public cvx_claimable_reward;
1079 
1080     //constants/immutables
1081     address public constant convexBooster = address(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
1082     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
1083     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
1084     address public curveToken;
1085     address public convexToken;
1086     address public convexPool;
1087     uint256 public convexPoolId;
1088     address public collateralVault;
1089 
1090     //rewards
1091     RewardType[] public rewards;
1092 
1093     //management
1094     bool public isShutdown;
1095     bool public isInit;
1096     address public owner;
1097 
1098     string internal _tokenname;
1099     string internal _tokensymbol;
1100 
1101     event Deposited(address indexed _user, address indexed _account, uint256 _amount, bool _wrapped);
1102     event Withdrawn(address indexed _user, uint256 _amount, bool _unwrapped);
1103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1104 
1105     constructor() public
1106         ERC20(
1107             "StakedConvexToken",
1108             "stkCvx"
1109         ){
1110     }
1111 
1112     function initialize(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId, address _vault)
1113     virtual external {
1114         require(!isInit,"already init");
1115         owner = address(0xa3C5A1e09150B75ff251c1a7815A07182c3de2FB); //default to convex multisig
1116         emit OwnershipTransferred(address(0), owner);
1117 
1118         _tokenname = string(abi.encodePacked("Staked ", ERC20(_convexToken).name() ));
1119         _tokensymbol = string(abi.encodePacked("stk", ERC20(_convexToken).symbol()));
1120         isShutdown = false;
1121         isInit = true;
1122         curveToken = _curveToken;
1123         convexToken = _convexToken;
1124         convexPool = _convexPool;
1125         convexPoolId = _poolId;
1126         collateralVault = _vault;
1127 
1128         //add rewards
1129         addRewards();
1130         setApprovals();
1131     }
1132 
1133     function name() public view override returns (string memory) {
1134         return _tokenname;
1135     }
1136 
1137     function symbol() public view override returns (string memory) {
1138         return _tokensymbol;
1139     }
1140 
1141     function decimals() public view override returns (uint8) {
1142         return 18;
1143     }
1144 
1145     modifier onlyOwner() {
1146         require(owner == msg.sender, "Ownable: caller is not the owner");
1147         _;
1148     }
1149 
1150     function transferOwnership(address newOwner) public virtual onlyOwner {
1151         require(newOwner != address(0), "Ownable: new owner is the zero address");
1152         emit OwnershipTransferred(owner, newOwner);
1153         owner = newOwner;
1154     }
1155 
1156     function renounceOwnership() public virtual onlyOwner {
1157         emit OwnershipTransferred(owner, address(0));
1158         owner = address(0);
1159     }
1160 
1161     function shutdown() external onlyOwner {
1162         isShutdown = true;
1163     }
1164 
1165     function setApprovals() public {
1166         IERC20(curveToken).safeApprove(convexBooster, 0);
1167         IERC20(curveToken).safeApprove(convexBooster, uint256(-1));
1168         IERC20(convexToken).safeApprove(convexPool, 0);
1169         IERC20(convexToken).safeApprove(convexPool, uint256(-1));
1170     }
1171 
1172     function addRewards() public {
1173         address mainPool = convexPool;
1174 
1175         if (rewards.length == 0) {
1176             rewards.push(
1177                 RewardType({
1178                     reward_token: crv,
1179                     reward_pool: mainPool,
1180                     reward_integral: 0,
1181                     reward_remaining: 0
1182                 })
1183             );
1184         }
1185 
1186         uint256 extraCount = IRewardStaking(mainPool).extraRewardsLength();
1187         uint256 startIndex = rewards.length - 1;
1188         for (uint256 i = startIndex; i < extraCount; i++) {
1189             address extraPool = IRewardStaking(mainPool).extraRewards(i);
1190             rewards.push(
1191                 RewardType({
1192                     reward_token: IRewardStaking(extraPool).rewardToken(),
1193                     reward_pool: extraPool,
1194                     reward_integral: 0,
1195                     reward_remaining: 0
1196                 })
1197             );
1198         }
1199     }
1200 
1201     function rewardLength() external view returns(uint256) {
1202         return rewards.length;
1203     }
1204 
1205     function _getDepositedBalance(address _account) internal virtual view returns(uint256) {
1206         if (_account == address(0) || _account == collateralVault) {
1207             return 0;
1208         }
1209         //get balance from collateralVault
1210 
1211         return balanceOf(_account);
1212     }
1213 
1214     function _getTotalSupply() internal virtual view returns(uint256){
1215 
1216         //override and add any supply needed (interest based growth)
1217 
1218         return totalSupply();
1219     }
1220 
1221 
1222     function _calcCvxIntegral(address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal {
1223 
1224         uint256 bal = IERC20(cvx).balanceOf(address(this));
1225         uint256 d_cvxreward = bal.sub(cvx_reward_remaining);
1226 
1227         if (_supply > 0 && d_cvxreward > 0) {
1228             cvx_reward_integral = cvx_reward_integral + d_cvxreward.mul(1e20).div(_supply);
1229         }
1230 
1231         
1232         //update user integrals for cvx
1233         for (uint256 u = 0; u < _accounts.length; u++) {
1234             //do not give rewards to address 0
1235             if (_accounts[u] == address(0)) continue;
1236             if (_accounts[u] == collateralVault) continue;
1237 
1238             uint userI = cvx_reward_integral_for[_accounts[u]];
1239             if(_isClaim || userI < cvx_reward_integral){
1240                 uint256 receiveable = cvx_claimable_reward[_accounts[u]].add(_balances[u].mul(cvx_reward_integral.sub(userI)).div(1e20));
1241                 if(_isClaim){
1242                     if(receiveable > 0){
1243                         cvx_claimable_reward[_accounts[u]] = 0;
1244                         IERC20(cvx).safeTransfer(_accounts[u], receiveable);
1245                         bal = bal.sub(receiveable);
1246                     }
1247                 }else{
1248                     cvx_claimable_reward[_accounts[u]] = receiveable;
1249                 }
1250                 cvx_reward_integral_for[_accounts[u]] = cvx_reward_integral;
1251            }
1252         }
1253 
1254         //update reward total
1255         if(bal != cvx_reward_remaining){
1256             cvx_reward_remaining = bal;
1257         }
1258     }
1259 
1260     function _calcRewardIntegral(uint256 _index, address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal{
1261          RewardType storage reward = rewards[_index];
1262 
1263         //get difference in balance and remaining rewards
1264         //getReward is unguarded so we use reward_remaining to keep track of how much was actually claimed
1265         uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1266         // uint256 d_reward = bal.sub(reward.reward_remaining);
1267 
1268         if (_supply > 0 && bal.sub(reward.reward_remaining) > 0) {
1269             reward.reward_integral = reward.reward_integral + uint128(bal.sub(reward.reward_remaining).mul(1e20).div(_supply));
1270         }
1271 
1272         //update user integrals
1273         for (uint256 u = 0; u < _accounts.length; u++) {
1274             //do not give rewards to address 0
1275             if (_accounts[u] == address(0)) continue;
1276             if (_accounts[u] == collateralVault) continue;
1277 
1278             uint userI = reward.reward_integral_for[_accounts[u]];
1279             if(_isClaim || userI < reward.reward_integral){
1280                 if(_isClaim){
1281                     uint256 receiveable = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1282                     if(receiveable > 0){
1283                         reward.claimable_reward[_accounts[u]] = 0;
1284                         IERC20(reward.reward_token).safeTransfer(_accounts[u], receiveable);
1285                         bal = bal.sub(receiveable);
1286                     }
1287                 }else{
1288                     reward.claimable_reward[_accounts[u]] = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1289                 }
1290                 reward.reward_integral_for[_accounts[u]] = reward.reward_integral;
1291             }
1292         }
1293 
1294         //update remaining reward here since balance could have changed if claiming
1295         if(bal !=  reward.reward_remaining){
1296             reward.reward_remaining = uint128(bal);
1297         }
1298     }
1299 
1300     function _checkpoint(address[2] memory _accounts) internal {
1301         //if shutdown, no longer checkpoint in case there are problems
1302         if(isShutdown) return;
1303 
1304         uint256 supply = _getTotalSupply();
1305         uint256[2] memory depositedBalance;
1306         depositedBalance[0] = _getDepositedBalance(_accounts[0]);
1307         depositedBalance[1] = _getDepositedBalance(_accounts[1]);
1308         
1309         IRewardStaking(convexPool).getReward(address(this), true);
1310 
1311         uint256 rewardCount = rewards.length;
1312         for (uint256 i = 0; i < rewardCount; i++) {
1313            _calcRewardIntegral(i,_accounts,depositedBalance,supply,false);
1314         }
1315         _calcCvxIntegral(_accounts,depositedBalance,supply,false);
1316     }
1317 
1318     function _checkpointAndClaim(address[2] memory _accounts) internal {
1319 
1320         uint256 supply = _getTotalSupply();
1321         uint256[2] memory depositedBalance;
1322         depositedBalance[0] = _getDepositedBalance(_accounts[0]); //only do first slot
1323         
1324         IRewardStaking(convexPool).getReward(address(this), true);
1325 
1326         uint256 rewardCount = rewards.length;
1327         for (uint256 i = 0; i < rewardCount; i++) {
1328            _calcRewardIntegral(i,_accounts,depositedBalance,supply,true);
1329         }
1330         _calcCvxIntegral(_accounts,depositedBalance,supply,true);
1331     }
1332 
1333     function user_checkpoint(address[2] calldata _accounts) external returns(bool) {
1334         _checkpoint([_accounts[0], _accounts[1]]);
1335         return true;
1336     }
1337 
1338     function totalBalanceOf(address _account) external view returns(uint256){
1339         return _getDepositedBalance(_account);
1340     }
1341 
1342     function earned(address _account) external view returns(EarnedData[] memory claimable) {
1343         uint256 supply = _getTotalSupply();
1344         // uint256 depositedBalance = _getDepositedBalance(_account);
1345         uint256 rewardCount = rewards.length;
1346         claimable = new EarnedData[](rewardCount + 1);
1347 
1348         for (uint256 i = 0; i < rewardCount; i++) {
1349             RewardType storage reward = rewards[i];
1350 
1351             //change in reward is current balance - remaining reward + earned
1352             uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1353             uint256 d_reward = bal.sub(reward.reward_remaining);
1354             d_reward = d_reward.add(IRewardStaking(reward.reward_pool).earned(address(this)));
1355 
1356             uint256 I = reward.reward_integral;
1357             if (supply > 0) {
1358                 I = I + d_reward.mul(1e20).div(supply);
1359             }
1360 
1361             uint256 newlyClaimable = _getDepositedBalance(_account).mul(I.sub(reward.reward_integral_for[_account])).div(1e20);
1362             claimable[i].amount = reward.claimable_reward[_account].add(newlyClaimable);
1363             claimable[i].token = reward.reward_token;
1364 
1365             //calc cvx here
1366             if(reward.reward_token == crv){
1367                 claimable[rewardCount].amount = cvx_claimable_reward[_account].add(CvxMining.ConvertCrvToCvx(newlyClaimable));
1368                 claimable[rewardCount].token = cvx;
1369             }
1370         }
1371         return claimable;
1372     }
1373 
1374     function getReward(address _account) external {
1375         //claim directly in checkpoint logic to save a bit of gas
1376         _checkpointAndClaim([_account, address(0)]);
1377     }
1378 
1379     //deposit a curve token
1380     function deposit(uint256 _amount, address _to) external nonReentrant {
1381         require(!isShutdown, "shutdown");
1382 
1383         //dont need to call checkpoint since _mint() will
1384 
1385         if (_amount > 0) {
1386             _mint(_to, _amount);
1387             IERC20(curveToken).safeTransferFrom(msg.sender, address(this), _amount);
1388             IConvexDeposits(convexBooster).deposit(convexPoolId, _amount, true);
1389         }
1390 
1391         emit Deposited(msg.sender, _to, _amount, true);
1392     }
1393 
1394     //stake a convex token
1395     function stake(uint256 _amount, address _to) external nonReentrant {
1396         require(!isShutdown, "shutdown");
1397 
1398         //dont need to call checkpoint since _mint() will
1399 
1400         if (_amount > 0) {
1401             _mint(_to, _amount);
1402             IERC20(convexToken).safeTransferFrom(msg.sender, address(this), _amount);
1403             IRewardStaking(convexPool).stake(_amount);
1404         }
1405 
1406         emit Deposited(msg.sender, _to, _amount, false);
1407     }
1408 
1409     //withdraw to convex deposit token
1410     function withdraw(uint256 _amount) external nonReentrant {
1411 
1412         //dont need to call checkpoint since _burn() will
1413 
1414         if (_amount > 0) {
1415             _burn(msg.sender, _amount);
1416             IRewardStaking(convexPool).withdraw(_amount, false);
1417             IERC20(convexToken).safeTransfer(msg.sender, _amount);
1418         }
1419 
1420         emit Withdrawn(msg.sender, _amount, false);
1421     }
1422 
1423     //withdraw to underlying curve lp token
1424     function withdrawAndUnwrap(uint256 _amount) external nonReentrant {
1425         
1426         //dont need to call checkpoint since _burn() will
1427 
1428         if (_amount > 0) {
1429             _burn(msg.sender, _amount);
1430             IRewardStaking(convexPool).withdrawAndUnwrap(_amount, false);
1431             IERC20(curveToken).safeTransfer(msg.sender, _amount);
1432         }
1433 
1434         //events
1435         emit Withdrawn(msg.sender, _amount, true);
1436     }
1437 
1438     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override {
1439         _checkpoint([_from, _to]);
1440     }
1441 }
1442 
1443 // File: contracts\wrappers\ConvexStakingWrapperAbra.sol
1444 
1445 pragma solidity 0.6.12;
1446 
1447 
1448 //Staking wrapper for Abracadabra platform
1449 //use convex LP positions as collateral while still receiving rewards
1450 contract ConvexStakingWrapperAbra is ConvexStakingWrapper {
1451     using SafeERC20
1452     for IERC20;
1453     using Address
1454     for address;
1455     using SafeMath
1456     for uint256;
1457 
1458     address[] public cauldrons;
1459 
1460     constructor() public{}
1461 
1462     function initialize(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId, address _vault)
1463     override external {
1464         require(!isInit,"already init");
1465         owner = address(0xa3C5A1e09150B75ff251c1a7815A07182c3de2FB); //default to convex multisig
1466         emit OwnershipTransferred(address(0), owner);
1467         _tokenname = string(abi.encodePacked("Staked ", ERC20(_convexToken).name(), " Abra" ));
1468         _tokensymbol = string(abi.encodePacked("stk", ERC20(_convexToken).symbol(), "-abra"));
1469         isShutdown = false;
1470         isInit = true;
1471         curveToken = _curveToken;
1472         convexToken = _convexToken;
1473         convexPool = _convexPool;
1474         convexPoolId = _poolId;
1475         collateralVault = address(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966);
1476     
1477         if(_vault != address(0)){
1478             cauldrons.push(_vault);
1479         }
1480 
1481         //add rewards
1482         addRewards();
1483         setApprovals();
1484     }
1485 
1486     function cauldronsLength() external view returns (uint256) {
1487         return cauldrons.length;
1488     }
1489 
1490     function setCauldron(address _cauldron) external onlyOwner{
1491         //allow settings and changing cauldrons that receive staking rewards.
1492         require(_cauldron != address(0), "invalid cauldron");
1493 
1494         //do not allow doubles
1495         for(uint256 i = 0; i < cauldrons.length; i++){
1496             require(cauldrons[i] != _cauldron, "already added");
1497         }
1498 
1499         //IMPORTANT: when adding a cauldron,
1500         // it should be added to this list BEFORE anyone starts using it
1501         // or else a user may receive more than what they should
1502         cauldrons.push(_cauldron);
1503     }
1504 
1505     function _getDepositedBalance(address _account) internal override view returns(uint256) {
1506         if (_account == address(0) || _account == collateralVault) {
1507             return 0;
1508         }
1509 
1510         if(cauldrons.length == 0){
1511             return balanceOf(_account);
1512         }
1513         
1514         //add up all shares of all cauldrons
1515         uint256 share;
1516         for(uint256 i = 0; i < cauldrons.length; i++){
1517             try ICauldron(cauldrons[i]).userCollateralShare(_account) returns(uint256 _share){
1518                 share = share.add(_share);
1519             }catch{}
1520         }
1521 
1522         //convert shares to balance amount via bento box
1523         uint256 collateral = IBentoBox(collateralVault).toAmount(address(this), share, false);
1524         
1525         //add to balance of this token
1526         return balanceOf(_account).add(collateral);
1527     }
1528 }