1 // SPDX-License-Identifier: MIT
2 // File: contracts\interfaces\ICauldron.sol
3 pragma solidity 0.6.12;
4 
5 interface ICauldron {
6     function userCollateralShare(address account) external view returns (uint);
7 }
8 
9 // File: contracts\interfaces\IBentoBox.sol
10 
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
387 
388 pragma solidity >=0.6.2 <0.8.0;
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // This method relies on extcodesize, which returns 0 for contracts in
413         // construction, since the code is only stored at the end of the
414         // constructor execution.
415 
416         uint256 size;
417         // solhint-disable-next-line no-inline-assembly
418         assembly { size := extcodesize(account) }
419         return size > 0;
420     }
421 
422     /**
423      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
424      * `recipient`, forwarding all available gas and reverting on errors.
425      *
426      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
427      * of certain opcodes, possibly making contracts go over the 2300 gas limit
428      * imposed by `transfer`, making them unable to receive funds via
429      * `transfer`. {sendValue} removes this limitation.
430      *
431      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
432      *
433      * IMPORTANT: because control is transferred to `recipient`, care must be
434      * taken to not create reentrancy vulnerabilities. Consider using
435      * {ReentrancyGuard} or the
436      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
437      */
438     function sendValue(address payable recipient, uint256 amount) internal {
439         require(address(this).balance >= amount, "Address: insufficient balance");
440 
441         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
442         (bool success, ) = recipient.call{ value: amount }("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 
446     /**
447      * @dev Performs a Solidity function call using a low level `call`. A
448      * plain`call` is an unsafe replacement for a function call: use this
449      * function instead.
450      *
451      * If `target` reverts with a revert reason, it is bubbled up by this
452      * function (like regular Solidity function calls).
453      *
454      * Returns the raw returned data. To convert to the expected return value,
455      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
456      *
457      * Requirements:
458      *
459      * - `target` must be a contract.
460      * - calling `target` with `data` must not revert.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
465       return functionCall(target, data, "Address: low-level call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
470      * `errorMessage` as a fallback revert reason when `target` reverts.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, 0, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but also transferring `value` wei to `target`.
481      *
482      * Requirements:
483      *
484      * - the calling contract must have an ETH balance of at least `value`.
485      * - the called Solidity function must be `payable`.
486      *
487      * _Available since v3.1._
488      */
489     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
495      * with `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
500         require(address(this).balance >= value, "Address: insufficient balance for call");
501         require(isContract(target), "Address: call to non-contract");
502 
503         // solhint-disable-next-line avoid-low-level-calls
504         (bool success, bytes memory returndata) = target.call{ value: value }(data);
505         return _verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
515         return functionStaticCall(target, data, "Address: low-level static call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
525         require(isContract(target), "Address: static call to non-contract");
526 
527         // solhint-disable-next-line avoid-low-level-calls
528         (bool success, bytes memory returndata) = target.staticcall(data);
529         return _verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.4._
537      */
538     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a delegate call.
545      *
546      * _Available since v3.4._
547      */
548     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
549         require(isContract(target), "Address: delegate call to non-contract");
550 
551         // solhint-disable-next-line avoid-low-level-calls
552         (bool success, bytes memory returndata) = target.delegatecall(data);
553         return _verifyCallResult(success, returndata, errorMessage);
554     }
555 
556     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
557         if (success) {
558             return returndata;
559         } else {
560             // Look for revert reason and bubble it up if present
561             if (returndata.length > 0) {
562                 // The easiest way to bubble the revert reason is using memory via assembly
563 
564                 // solhint-disable-next-line no-inline-assembly
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 
577 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
578 
579 
580 pragma solidity >=0.6.0 <0.8.0;
581 
582 /**
583  * @title SafeERC20
584  * @dev Wrappers around ERC20 operations that throw on failure (when the token
585  * contract returns false). Tokens that return no value (and instead revert or
586  * throw on failure) are also supported, non-reverting calls are assumed to be
587  * successful.
588  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
589  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
590  */
591 library SafeERC20 {
592     using SafeMath for uint256;
593     using Address for address;
594 
595     function safeTransfer(IERC20 token, address to, uint256 value) internal {
596         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
597     }
598 
599     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
600         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
601     }
602 
603     /**
604      * @dev Deprecated. This function has issues similar to the ones found in
605      * {IERC20-approve}, and its usage is discouraged.
606      *
607      * Whenever possible, use {safeIncreaseAllowance} and
608      * {safeDecreaseAllowance} instead.
609      */
610     function safeApprove(IERC20 token, address spender, uint256 value) internal {
611         // safeApprove should only be called when setting an initial allowance,
612         // or when resetting it to zero. To increase and decrease it, use
613         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
614         // solhint-disable-next-line max-line-length
615         require((value == 0) || (token.allowance(address(this), spender) == 0),
616             "SafeERC20: approve from non-zero to non-zero allowance"
617         );
618         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
619     }
620 
621     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
622         uint256 newAllowance = token.allowance(address(this), spender).add(value);
623         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
624     }
625 
626     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
627         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
628         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
629     }
630 
631     /**
632      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
633      * on the return value: the return value is optional (but if data is returned, it must not be false).
634      * @param token The token targeted by the call.
635      * @param data The call data (encoded using abi.encode or one of its variants).
636      */
637     function _callOptionalReturn(IERC20 token, bytes memory data) private {
638         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
639         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
640         // the target address contains contract code and also asserts for success in the low-level call.
641 
642         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
643         if (returndata.length > 0) { // Return data is optional
644             // solhint-disable-next-line max-line-length
645             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
646         }
647     }
648 }
649 
650 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
651 
652 pragma solidity >=0.6.0 <0.8.0;
653 
654 /*
655  * @dev Provides information about the current execution context, including the
656  * sender of the transaction and its data. While these are generally available
657  * via msg.sender and msg.data, they should not be accessed in such a direct
658  * manner, since when dealing with GSN meta-transactions the account sending and
659  * paying for execution may not be the actual sender (as far as an application
660  * is concerned).
661  *
662  * This contract is only required for intermediate, library-like contracts.
663  */
664 abstract contract Context {
665     function _msgSender() internal view virtual returns (address payable) {
666         return msg.sender;
667     }
668 
669     function _msgData() internal view virtual returns (bytes memory) {
670         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
671         return msg.data;
672     }
673 }
674 
675 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
676 
677 
678 pragma solidity >=0.6.0 <0.8.0;
679 
680 
681 /**
682  * @dev Implementation of the {IERC20} interface.
683  *
684  * This implementation is agnostic to the way tokens are created. This means
685  * that a supply mechanism has to be added in a derived contract using {_mint}.
686  * For a generic mechanism see {ERC20PresetMinterPauser}.
687  *
688  * TIP: For a detailed writeup see our guide
689  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
690  * to implement supply mechanisms].
691  *
692  * We have followed general OpenZeppelin guidelines: functions revert instead
693  * of returning `false` on failure. This behavior is nonetheless conventional
694  * and does not conflict with the expectations of ERC20 applications.
695  *
696  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
697  * This allows applications to reconstruct the allowance for all accounts just
698  * by listening to said events. Other implementations of the EIP may not emit
699  * these events, as it isn't required by the specification.
700  *
701  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
702  * functions have been added to mitigate the well-known issues around setting
703  * allowances. See {IERC20-approve}.
704  */
705 contract ERC20 is Context, IERC20 {
706     using SafeMath for uint256;
707 
708     mapping (address => uint256) private _balances;
709 
710     mapping (address => mapping (address => uint256)) private _allowances;
711 
712     uint256 private _totalSupply;
713 
714     string private _name;
715     string private _symbol;
716     uint8 private _decimals;
717 
718     /**
719      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
720      * a default value of 18.
721      *
722      * To select a different value for {decimals}, use {_setupDecimals}.
723      *
724      * All three of these values are immutable: they can only be set once during
725      * construction.
726      */
727     constructor (string memory name_, string memory symbol_) public {
728         _name = name_;
729         _symbol = symbol_;
730         _decimals = 18;
731     }
732 
733     /**
734      * @dev Returns the name of the token.
735      */
736     function name() public view virtual returns (string memory) {
737         return _name;
738     }
739 
740     /**
741      * @dev Returns the symbol of the token, usually a shorter version of the
742      * name.
743      */
744     function symbol() public view virtual returns (string memory) {
745         return _symbol;
746     }
747 
748     /**
749      * @dev Returns the number of decimals used to get its user representation.
750      * For example, if `decimals` equals `2`, a balance of `505` tokens should
751      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
752      *
753      * Tokens usually opt for a value of 18, imitating the relationship between
754      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
755      * called.
756      *
757      * NOTE: This information is only used for _display_ purposes: it in
758      * no way affects any of the arithmetic of the contract, including
759      * {IERC20-balanceOf} and {IERC20-transfer}.
760      */
761     function decimals() public view virtual returns (uint8) {
762         return _decimals;
763     }
764 
765     /**
766      * @dev See {IERC20-totalSupply}.
767      */
768     function totalSupply() public view virtual override returns (uint256) {
769         return _totalSupply;
770     }
771 
772     /**
773      * @dev See {IERC20-balanceOf}.
774      */
775     function balanceOf(address account) public view virtual override returns (uint256) {
776         return _balances[account];
777     }
778 
779     /**
780      * @dev See {IERC20-transfer}.
781      *
782      * Requirements:
783      *
784      * - `recipient` cannot be the zero address.
785      * - the caller must have a balance of at least `amount`.
786      */
787     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
788         _transfer(_msgSender(), recipient, amount);
789         return true;
790     }
791 
792     /**
793      * @dev See {IERC20-allowance}.
794      */
795     function allowance(address owner, address spender) public view virtual override returns (uint256) {
796         return _allowances[owner][spender];
797     }
798 
799     /**
800      * @dev See {IERC20-approve}.
801      *
802      * Requirements:
803      *
804      * - `spender` cannot be the zero address.
805      */
806     function approve(address spender, uint256 amount) public virtual override returns (bool) {
807         _approve(_msgSender(), spender, amount);
808         return true;
809     }
810 
811     /**
812      * @dev See {IERC20-transferFrom}.
813      *
814      * Emits an {Approval} event indicating the updated allowance. This is not
815      * required by the EIP. See the note at the beginning of {ERC20}.
816      *
817      * Requirements:
818      *
819      * - `sender` and `recipient` cannot be the zero address.
820      * - `sender` must have a balance of at least `amount`.
821      * - the caller must have allowance for ``sender``'s tokens of at least
822      * `amount`.
823      */
824     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
825         _transfer(sender, recipient, amount);
826         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
827         return true;
828     }
829 
830     /**
831      * @dev Atomically increases the allowance granted to `spender` by the caller.
832      *
833      * This is an alternative to {approve} that can be used as a mitigation for
834      * problems described in {IERC20-approve}.
835      *
836      * Emits an {Approval} event indicating the updated allowance.
837      *
838      * Requirements:
839      *
840      * - `spender` cannot be the zero address.
841      */
842     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
843         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
844         return true;
845     }
846 
847     /**
848      * @dev Atomically decreases the allowance granted to `spender` by the caller.
849      *
850      * This is an alternative to {approve} that can be used as a mitigation for
851      * problems described in {IERC20-approve}.
852      *
853      * Emits an {Approval} event indicating the updated allowance.
854      *
855      * Requirements:
856      *
857      * - `spender` cannot be the zero address.
858      * - `spender` must have allowance for the caller of at least
859      * `subtractedValue`.
860      */
861     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
862         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
863         return true;
864     }
865 
866     /**
867      * @dev Moves tokens `amount` from `sender` to `recipient`.
868      *
869      * This is internal function is equivalent to {transfer}, and can be used to
870      * e.g. implement automatic token fees, slashing mechanisms, etc.
871      *
872      * Emits a {Transfer} event.
873      *
874      * Requirements:
875      *
876      * - `sender` cannot be the zero address.
877      * - `recipient` cannot be the zero address.
878      * - `sender` must have a balance of at least `amount`.
879      */
880     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
881         require(sender != address(0), "ERC20: transfer from the zero address");
882         require(recipient != address(0), "ERC20: transfer to the zero address");
883 
884         _beforeTokenTransfer(sender, recipient, amount);
885 
886         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
887         _balances[recipient] = _balances[recipient].add(amount);
888         emit Transfer(sender, recipient, amount);
889     }
890 
891     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
892      * the total supply.
893      *
894      * Emits a {Transfer} event with `from` set to the zero address.
895      *
896      * Requirements:
897      *
898      * - `to` cannot be the zero address.
899      */
900     function _mint(address account, uint256 amount) internal virtual {
901         require(account != address(0), "ERC20: mint to the zero address");
902 
903         _beforeTokenTransfer(address(0), account, amount);
904 
905         _totalSupply = _totalSupply.add(amount);
906         _balances[account] = _balances[account].add(amount);
907         emit Transfer(address(0), account, amount);
908     }
909 
910     /**
911      * @dev Destroys `amount` tokens from `account`, reducing the
912      * total supply.
913      *
914      * Emits a {Transfer} event with `to` set to the zero address.
915      *
916      * Requirements:
917      *
918      * - `account` cannot be the zero address.
919      * - `account` must have at least `amount` tokens.
920      */
921     function _burn(address account, uint256 amount) internal virtual {
922         require(account != address(0), "ERC20: burn from the zero address");
923 
924         _beforeTokenTransfer(account, address(0), amount);
925 
926         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
927         _totalSupply = _totalSupply.sub(amount);
928         emit Transfer(account, address(0), amount);
929     }
930 
931     /**
932      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
933      *
934      * This internal function is equivalent to `approve`, and can be used to
935      * e.g. set automatic allowances for certain subsystems, etc.
936      *
937      * Emits an {Approval} event.
938      *
939      * Requirements:
940      *
941      * - `owner` cannot be the zero address.
942      * - `spender` cannot be the zero address.
943      */
944     function _approve(address owner, address spender, uint256 amount) internal virtual {
945         require(owner != address(0), "ERC20: approve from the zero address");
946         require(spender != address(0), "ERC20: approve to the zero address");
947 
948         _allowances[owner][spender] = amount;
949         emit Approval(owner, spender, amount);
950     }
951 
952     /**
953      * @dev Sets {decimals} to a value other than the default one of 18.
954      *
955      * WARNING: This function should only be called from the constructor. Most
956      * applications that interact with token contracts will not expect
957      * {decimals} to ever change, and may work incorrectly if it does.
958      */
959     function _setupDecimals(uint8 decimals_) internal virtual {
960         _decimals = decimals_;
961     }
962 
963     /**
964      * @dev Hook that is called before any transfer of tokens. This includes
965      * minting and burning.
966      *
967      * Calling conditions:
968      *
969      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
970      * will be to transferred to `to`.
971      * - when `from` is zero, `amount` tokens will be minted for `to`.
972      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
973      * - `from` and `to` are never both zero.
974      *
975      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
976      */
977     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
978 }
979 
980 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
981 
982 
983 pragma solidity >=0.6.0 <0.8.0;
984 
985 /**
986  * @dev Contract module that helps prevent reentrant calls to a function.
987  *
988  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
989  * available, which can be applied to functions to make sure there are no nested
990  * (reentrant) calls to them.
991  *
992  * Note that because there is a single `nonReentrant` guard, functions marked as
993  * `nonReentrant` may not call one another. This can be worked around by making
994  * those functions `private`, and then adding `external` `nonReentrant` entry
995  * points to them.
996  *
997  * TIP: If you would like to learn more about reentrancy and alternative ways
998  * to protect against it, check out our blog post
999  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1000  */
1001 abstract contract ReentrancyGuard {
1002     // Booleans are more expensive than uint256 or any type that takes up a full
1003     // word because each write operation emits an extra SLOAD to first read the
1004     // slot's contents, replace the bits taken up by the boolean, and then write
1005     // back. This is the compiler's defense against contract upgrades and
1006     // pointer aliasing, and it cannot be disabled.
1007 
1008     // The values being non-zero value makes deployment a bit more expensive,
1009     // but in exchange the refund on every call to nonReentrant will be lower in
1010     // amount. Since refunds are capped to a percentage of the total
1011     // transaction's gas, it is best to keep them low in cases like this one, to
1012     // increase the likelihood of the full refund coming into effect.
1013     uint256 private constant _NOT_ENTERED = 1;
1014     uint256 private constant _ENTERED = 2;
1015 
1016     uint256 private _status;
1017 
1018     constructor () internal {
1019         _status = _NOT_ENTERED;
1020     }
1021 
1022     /**
1023      * @dev Prevents a contract from calling itself, directly or indirectly.
1024      * Calling a `nonReentrant` function from another `nonReentrant`
1025      * function is not supported. It is possible to prevent this from happening
1026      * by making the `nonReentrant` function external, and make it call a
1027      * `private` function that does the actual work.
1028      */
1029     modifier nonReentrant() {
1030         // On the first call to nonReentrant, _notEntered will be true
1031         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1032 
1033         // Any calls to nonReentrant after this point will fail
1034         _status = _ENTERED;
1035 
1036         _;
1037 
1038         // By storing the original value once again, a refund is triggered (see
1039         // https://eips.ethereum.org/EIPS/eip-2200)
1040         _status = _NOT_ENTERED;
1041     }
1042 }
1043 
1044 // File: @openzeppelin\contracts\access\Ownable.sol
1045 
1046 
1047 pragma solidity >=0.6.0 <0.8.0;
1048 
1049 /**
1050  * @dev Contract module which provides a basic access control mechanism, where
1051  * there is an account (an owner) that can be granted exclusive access to
1052  * specific functions.
1053  *
1054  * By default, the owner account will be the one that deploys the contract. This
1055  * can later be changed with {transferOwnership}.
1056  *
1057  * This module is used through inheritance. It will make available the modifier
1058  * `onlyOwner`, which can be applied to your functions to restrict their use to
1059  * the owner.
1060  */
1061 abstract contract Ownable is Context {
1062     address private _owner;
1063 
1064     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1065 
1066     /**
1067      * @dev Initializes the contract setting the deployer as the initial owner.
1068      */
1069     constructor () internal {
1070         address msgSender = _msgSender();
1071         _owner = msgSender;
1072         emit OwnershipTransferred(address(0), msgSender);
1073     }
1074 
1075     /**
1076      * @dev Returns the address of the current owner.
1077      */
1078     function owner() public view virtual returns (address) {
1079         return _owner;
1080     }
1081 
1082     /**
1083      * @dev Throws if called by any account other than the owner.
1084      */
1085     modifier onlyOwner() {
1086         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1087         _;
1088     }
1089 
1090     /**
1091      * @dev Leaves the contract without owner. It will not be possible to call
1092      * `onlyOwner` functions anymore. Can only be called by the current owner.
1093      *
1094      * NOTE: Renouncing ownership will leave the contract without an owner,
1095      * thereby removing any functionality that is only available to the owner.
1096      */
1097     function renounceOwnership() public virtual onlyOwner {
1098         emit OwnershipTransferred(_owner, address(0));
1099         _owner = address(0);
1100     }
1101 
1102     /**
1103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1104      * Can only be called by the current owner.
1105      */
1106     function transferOwnership(address newOwner) public virtual onlyOwner {
1107         require(newOwner != address(0), "Ownable: new owner is the zero address");
1108         emit OwnershipTransferred(_owner, newOwner);
1109         _owner = newOwner;
1110     }
1111 }
1112 
1113 // File: contracts\wrappers\ConvexStakingWrapper.sol
1114 
1115 
1116 pragma solidity 0.6.12;
1117 pragma experimental ABIEncoderV2;
1118 
1119 
1120 //Example of a tokenize a convex staked position.
1121 //if used as collateral some modifications will be needed to fit the specific platform
1122 
1123 //Based on Curve.fi's gauge wrapper implementations at https://github.com/curvefi/curve-dao-contracts/tree/master/contracts/gauges/wrappers
1124 contract ConvexStakingWrapper is ERC20, ReentrancyGuard, Ownable {
1125     using SafeERC20
1126     for IERC20;
1127     using Address
1128     for address;
1129     using SafeMath
1130     for uint256;
1131 
1132     struct EarnedData {
1133         address token;
1134         uint256 amount;
1135     }
1136 
1137     struct RewardType {
1138         address reward_token;
1139         address reward_pool;
1140         uint128 reward_integral;
1141         uint128 reward_remaining;
1142         mapping(address => uint256) reward_integral_for;
1143         mapping(address => uint256) claimable_reward;
1144     }
1145 
1146     uint256 public cvx_reward_integral;
1147     uint256 public cvx_reward_remaining;
1148     mapping(address => uint256) public cvx_reward_integral_for;
1149     mapping(address => uint256) public cvx_claimable_reward;
1150 
1151     //constants/immutables
1152     address public constant convexBooster = address(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
1153     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
1154     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
1155     address public immutable curveToken;
1156     address public immutable convexToken;
1157     address public immutable convexPool;
1158     uint256 public immutable convexPoolId;
1159     address public immutable collateralVault;
1160 
1161     //rewards
1162     RewardType[] public rewards;
1163 
1164     //management
1165     bool public isShutdown = false;
1166 
1167     event Deposited(address indexed _user, address indexed _account, uint256 _amount, bool _wrapped);
1168     event Withdrawn(address indexed _user, uint256 _amount, bool _unwrapped);
1169 
1170     constructor(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId, address _vault, string memory _nameTag, string memory _symbolTag)
1171     public
1172     ERC20(
1173         string(
1174             abi.encodePacked("Staked ", ERC20(_convexToken).name(), _nameTag )
1175         ),
1176         string(abi.encodePacked("stk", ERC20(_convexToken).symbol(), _symbolTag))
1177     ) Ownable() {
1178         curveToken = _curveToken;
1179         convexToken = _convexToken;
1180         convexPool = _convexPool;
1181         convexPoolId = _poolId;
1182         collateralVault = _vault;
1183     }
1184 
1185     function shutdown() external onlyOwner {
1186         isShutdown = true;
1187     }
1188 
1189     function setApprovals() external {
1190         IERC20(curveToken).safeApprove(convexBooster, 0);
1191         IERC20(curveToken).safeApprove(convexBooster, uint256(-1));
1192         IERC20(convexToken).safeApprove(convexPool, 0);
1193         IERC20(convexToken).safeApprove(convexPool, uint256(-1));
1194     }
1195 
1196     function addRewards() external {
1197         address mainPool = convexPool;
1198 
1199         if (rewards.length == 0) {
1200             rewards.push(
1201                 RewardType({
1202                     reward_token: crv,
1203                     reward_pool: mainPool,
1204                     reward_integral: 0,
1205                     reward_remaining: 0
1206                 })
1207             );
1208         }
1209 
1210         uint256 extraCount = IRewardStaking(mainPool).extraRewardsLength();
1211         uint256 startIndex = rewards.length - 1;
1212         for (uint256 i = startIndex; i < extraCount; i++) {
1213             address extraPool = IRewardStaking(mainPool).extraRewards(i);
1214             rewards.push(
1215                 RewardType({
1216                     reward_token: IRewardStaking(extraPool).rewardToken(),
1217                     reward_pool: extraPool,
1218                     reward_integral: 0,
1219                     reward_remaining: 0
1220                 })
1221             );
1222         }
1223     }
1224 
1225     function rewardLength() external view returns(uint256) {
1226         return rewards.length;
1227     }
1228 
1229     function _getDepositedBalance(address _account) internal virtual view returns(uint256) {
1230         if (_account == address(0) || _account == collateralVault) {
1231             return 0;
1232         }
1233         //get balance from collateralVault
1234 
1235         return balanceOf(_account);
1236     }
1237 
1238     function _getTotalSupply() internal virtual view returns(uint256){
1239 
1240         //override and add any supply needed (interest based growth)
1241 
1242         return totalSupply();
1243     }
1244 
1245 
1246     function _calcCvxIntegral(address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal {
1247 
1248         uint256 bal = IERC20(cvx).balanceOf(address(this));
1249         uint256 d_cvxreward = bal.sub(cvx_reward_remaining);
1250 
1251         if (_supply > 0 && d_cvxreward > 0) {
1252             cvx_reward_integral = cvx_reward_integral + d_cvxreward.mul(1e20).div(_supply);
1253         }
1254 
1255         
1256         //update user integrals for cvx
1257         for (uint256 u = 0; u < _accounts.length; u++) {
1258             //do not give rewards to address 0
1259             if (_accounts[u] == address(0)) continue;
1260             if (_accounts[u] == collateralVault) continue;
1261 
1262             uint userI = cvx_reward_integral_for[_accounts[u]];
1263             if(_isClaim || userI < cvx_reward_integral){
1264                 uint256 receiveable = cvx_claimable_reward[_accounts[u]].add(_balances[u].mul(cvx_reward_integral.sub(userI)).div(1e20));
1265                 if(_isClaim){
1266                     if(receiveable > 0){
1267                         cvx_claimable_reward[_accounts[u]] = 0;
1268                         IERC20(cvx).safeTransfer(_accounts[u], receiveable);
1269                         bal = bal.sub(receiveable);
1270                     }
1271                 }else{
1272                     cvx_claimable_reward[_accounts[u]] = receiveable;
1273                 }
1274                 cvx_reward_integral_for[_accounts[u]] = cvx_reward_integral;
1275            }
1276         }
1277 
1278         //update reward total
1279         if(bal != cvx_reward_remaining){
1280             cvx_reward_remaining = bal;
1281         }
1282     }
1283 
1284     function _calcRewardIntegral(uint256 _index, address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal{
1285          RewardType storage reward = rewards[_index];
1286 
1287         //get difference in balance and remaining rewards
1288         //getReward is unguarded so we use reward_remaining to keep track of how much was actually claimed
1289         uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1290         // uint256 d_reward = bal.sub(reward.reward_remaining);
1291 
1292         if (_supply > 0 && bal.sub(reward.reward_remaining) > 0) {
1293             reward.reward_integral = reward.reward_integral + uint128(bal.sub(reward.reward_remaining).mul(1e20).div(_supply));
1294         }
1295 
1296         //update user integrals
1297         for (uint256 u = 0; u < _accounts.length; u++) {
1298             //do not give rewards to address 0
1299             if (_accounts[u] == address(0)) continue;
1300             if (_accounts[u] == collateralVault) continue;
1301 
1302             uint userI = reward.reward_integral_for[_accounts[u]];
1303             if(_isClaim || userI < reward.reward_integral){
1304                 if(_isClaim){
1305                     uint256 receiveable = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1306                     if(receiveable > 0){
1307                         reward.claimable_reward[_accounts[u]] = 0;
1308                         IERC20(reward.reward_token).safeTransfer(_accounts[u], receiveable);
1309                         bal = bal.sub(receiveable);
1310                     }
1311                 }else{
1312                     reward.claimable_reward[_accounts[u]] = reward.claimable_reward[_accounts[u]].add(_balances[u].mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1313                 }
1314                 reward.reward_integral_for[_accounts[u]] = reward.reward_integral;
1315             }
1316         }
1317 
1318         //update remaining reward here since balance could have changed if claiming
1319         if(bal !=  reward.reward_remaining){
1320             reward.reward_remaining = uint128(bal);
1321         }
1322     }
1323 
1324     function _checkpoint(address[2] memory _accounts) internal {
1325         //if shutdown, no longer checkpoint in case there are problems
1326         if(isShutdown) return;
1327 
1328         uint256 supply = _getTotalSupply();
1329         uint256[2] memory depositedBalance;
1330         depositedBalance[0] = _getDepositedBalance(_accounts[0]);
1331         depositedBalance[1] = _getDepositedBalance(_accounts[1]);
1332         
1333         IRewardStaking(convexPool).getReward(address(this), true);
1334 
1335         uint256 rewardCount = rewards.length;
1336         for (uint256 i = 0; i < rewardCount; i++) {
1337            _calcRewardIntegral(i,_accounts,depositedBalance,supply,false);
1338         }
1339         _calcCvxIntegral(_accounts,depositedBalance,supply,false);
1340     }
1341 
1342     function _checkpointAndClaim(address[2] memory _accounts) internal {
1343 
1344         uint256 supply = _getTotalSupply();
1345         uint256[2] memory depositedBalance;
1346         depositedBalance[0] = _getDepositedBalance(_accounts[0]); //only do first slot
1347         
1348         IRewardStaking(convexPool).getReward(address(this), true);
1349 
1350         uint256 rewardCount = rewards.length;
1351         for (uint256 i = 0; i < rewardCount; i++) {
1352            _calcRewardIntegral(i,_accounts,depositedBalance,supply,true);
1353         }
1354         _calcCvxIntegral(_accounts,depositedBalance,supply,true);
1355     }
1356 
1357     function user_checkpoint(address[2] calldata _accounts) external returns(bool) {
1358         _checkpoint([_accounts[0], _accounts[1]]);
1359         return true;
1360     }
1361 
1362     function totalBalanceOf(address _account) external view returns(uint256){
1363         return _getDepositedBalance(_account);
1364     }
1365 
1366     function earned(address _account) external view returns(EarnedData[] memory claimable) {
1367         uint256 supply = _getTotalSupply();
1368         // uint256 depositedBalance = _getDepositedBalance(_account);
1369         uint256 rewardCount = rewards.length;
1370         claimable = new EarnedData[](rewardCount + 1);
1371 
1372         for (uint256 i = 0; i < rewardCount; i++) {
1373             RewardType storage reward = rewards[i];
1374 
1375             //change in reward is current balance - remaining reward + earned
1376             uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1377             uint256 d_reward = bal.sub(reward.reward_remaining);
1378             d_reward = d_reward.add(IRewardStaking(reward.reward_pool).earned(address(this)));
1379 
1380             uint256 I = reward.reward_integral;
1381             if (supply > 0) {
1382                 I = I + d_reward.mul(1e20).div(supply);
1383             }
1384 
1385             uint256 newlyClaimable = _getDepositedBalance(_account).mul(I.sub(reward.reward_integral_for[_account])).div(1e20);
1386             claimable[i].amount = reward.claimable_reward[_account].add(newlyClaimable);
1387             claimable[i].token = reward.reward_token;
1388 
1389             //calc cvx here
1390             if(reward.reward_token == crv){
1391                 claimable[rewardCount].amount = cvx_claimable_reward[_account].add(CvxMining.ConvertCrvToCvx(newlyClaimable));
1392                 claimable[i].token = cvx;
1393             }
1394         }
1395         return claimable;
1396     }
1397 
1398     function getReward(address _account) external {
1399         //claim directly in checkpoint logic to save a bit of gas
1400         _checkpointAndClaim([_account, address(0)]);
1401     }
1402 
1403     //deposit a curve token
1404     function deposit(uint256 _amount, address _to) external nonReentrant {
1405         require(!isShutdown, "shutdown");
1406 
1407         //dont need to call checkpoint since _mint() will
1408 
1409         if (_amount > 0) {
1410             _mint(_to, _amount);
1411             IERC20(curveToken).safeTransferFrom(msg.sender, address(this), _amount);
1412             IConvexDeposits(convexBooster).deposit(convexPoolId, _amount, true);
1413         }
1414 
1415         emit Deposited(msg.sender, _to, _amount, true);
1416     }
1417 
1418     //stake a convex token
1419     function stake(uint256 _amount, address _to) external nonReentrant {
1420         require(!isShutdown, "shutdown");
1421 
1422         //dont need to call checkpoint since _mint() will
1423 
1424         if (_amount > 0) {
1425             _mint(_to, _amount);
1426             IERC20(convexToken).safeTransferFrom(msg.sender, address(this), _amount);
1427             IRewardStaking(convexPool).stake(_amount);
1428         }
1429 
1430         emit Deposited(msg.sender, _to, _amount, false);
1431     }
1432 
1433     //withdraw to convex deposit token
1434     function withdraw(uint256 _amount) external nonReentrant {
1435 
1436         //dont need to call checkpoint since _burn() will
1437 
1438         if (_amount > 0) {
1439             _burn(msg.sender, _amount);
1440             IRewardStaking(convexPool).withdraw(_amount, false);
1441             IERC20(convexToken).safeTransfer(msg.sender, _amount);
1442         }
1443 
1444         emit Withdrawn(msg.sender, _amount, false);
1445     }
1446 
1447     //withdraw to underlying curve lp token
1448     function withdrawAndUnwrap(uint256 _amount) external nonReentrant {
1449         
1450         //dont need to call checkpoint since _burn() will
1451 
1452         if (_amount > 0) {
1453             _burn(msg.sender, _amount);
1454             IRewardStaking(convexPool).withdrawAndUnwrap(_amount, false);
1455             IERC20(curveToken).safeTransfer(msg.sender, _amount);
1456         }
1457 
1458         //events
1459         emit Withdrawn(msg.sender, _amount, true);
1460     }
1461 
1462     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override {
1463         _checkpoint([_from, _to]);
1464     }
1465 }
1466 
1467 // File: contracts\wrappers\ConvexStakingWrapperAbra.sol
1468 
1469 
1470 pragma solidity 0.6.12;
1471 
1472 
1473 //Staking wrapper for Abracadabra platform
1474 //use convex LP positions as collateral while still receiving rewards
1475 contract ConvexStakingWrapperAbra is ConvexStakingWrapper {
1476     using SafeERC20
1477     for IERC20;
1478     using Address
1479     for address;
1480     using SafeMath
1481     for uint256;
1482 
1483     address public cauldron;
1484 
1485     constructor(address _curveToken, address _convexToken, address _convexPool, uint256 _poolId)
1486     public ConvexStakingWrapper(_curveToken, _convexToken, _convexPool, _poolId, address(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966)," Abra", "-abra"){
1487     }
1488 
1489     function setCauldron(address _cauldron) external onlyOwner{
1490         require(cauldron == address(0),"!0");
1491         cauldron = _cauldron;
1492     }
1493 
1494     function _getDepositedBalance(address _account) internal override view returns(uint256) {
1495         if (_account == address(0) || _account == collateralVault) {
1496             return 0;
1497         }
1498         
1499         //get collateral balance
1500         uint256 collateral = ICauldron(cauldron).userCollateralShare(_account);
1501         collateral = IBentoBox(collateralVault).toAmount(address(this), collateral, false);
1502 
1503         //add to balance of this token
1504         return balanceOf(_account).add(collateral);
1505     }
1506 }