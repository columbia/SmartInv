1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.8.3 https://hardhat.org
5 
6 // File contracts/Math/Math.sol
7 
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     /**
14      * @dev Returns the largest of two numbers.
15      */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21      * @dev Returns the smallest of two numbers.
22      */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the average of two numbers. The result is rounded towards
29      * zero.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 
36     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
37     function sqrt(uint y) internal pure returns (uint z) {
38         if (y > 3) {
39             z = y;
40             uint x = y / 2 + 1;
41             while (x < z) {
42                 z = x;
43                 x = (y / x + x) / 2;
44             }
45         } else if (y != 0) {
46             z = 1;
47         }
48     }
49 }
50 
51 
52 // File contracts/Curve/IveFXS.sol
53 
54 pragma abicoder v2;
55 
56 interface IveFXS {
57 
58     struct LockedBalance {
59         int128 amount;
60         uint256 end;
61     }
62 
63     function commit_transfer_ownership(address addr) external;
64     function apply_transfer_ownership() external;
65     function commit_smart_wallet_checker(address addr) external;
66     function apply_smart_wallet_checker() external;
67     function toggleEmergencyUnlock() external;
68     function recoverERC20(address token_addr, uint256 amount) external;
69     function get_last_user_slope(address addr) external view returns (int128);
70     function user_point_history__ts(address _addr, uint256 _idx) external view returns (uint256);
71     function locked__end(address _addr) external view returns (uint256);
72     function checkpoint() external;
73     function deposit_for(address _addr, uint256 _value) external;
74     function create_lock(uint256 _value, uint256 _unlock_time) external;
75     function increase_amount(uint256 _value) external;
76     function increase_unlock_time(uint256 _unlock_time) external;
77     function withdraw() external;
78     function balanceOf(address addr) external view returns (uint256);
79     function balanceOf(address addr, uint256 _t) external view returns (uint256);
80     function balanceOfAt(address addr, uint256 _block) external view returns (uint256);
81     function totalSupply() external view returns (uint256);
82     function totalSupply(uint256 t) external view returns (uint256);
83     function totalSupplyAt(uint256 _block) external view returns (uint256);
84     function totalFXSSupply() external view returns (uint256);
85     function totalFXSSupplyAt(uint256 _block) external view returns (uint256);
86     function changeController(address _newController) external;
87     function token() external view returns (address);
88     function supply() external view returns (uint256);
89     function locked(address addr) external view returns (LockedBalance memory);
90     function epoch() external view returns (uint256);
91     function point_history(uint256 arg0) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
92     function user_point_history(address arg0, uint256 arg1) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
93     function user_point_epoch(address arg0) external view returns (uint256);
94     function slope_changes(uint256 arg0) external view returns (int128);
95     function controller() external view returns (address);
96     function transfersEnabled() external view returns (bool);
97     function emergencyUnlockActive() external view returns (bool);
98     function name() external view returns (string memory);
99     function symbol() external view returns (string memory);
100     function version() external view returns (string memory);
101     function decimals() external view returns (uint256);
102     function future_smart_wallet_checker() external view returns (address);
103     function smart_wallet_checker() external view returns (address);
104     function admin() external view returns (address);
105     function future_admin() external view returns (address);
106 }
107 
108 
109 // File contracts/Curve/IFraxGaugeController.sol
110 
111 
112 // https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol
113 
114 interface IFraxGaugeController {
115     struct Point {
116         uint256 bias;
117         uint256 slope;
118     }
119 
120     struct VotedSlope {
121         uint256 slope;
122         uint256 power;
123         uint256 end;
124     }
125 
126     // Public variables
127     function admin() external view returns (address);
128     function future_admin() external view returns (address);
129     function token() external view returns (address);
130     function voting_escrow() external view returns (address);
131     function n_gauge_types() external view returns (int128);
132     function n_gauges() external view returns (int128);
133     function gauge_type_names(int128) external view returns (string memory);
134     function gauges(uint256) external view returns (address);
135     function vote_user_slopes(address, address)
136         external
137         view
138         returns (VotedSlope memory);
139     function vote_user_power(address) external view returns (uint256);
140     function last_user_vote(address, address) external view returns (uint256);
141     function points_weight(address, uint256)
142         external
143         view
144         returns (Point memory);
145     function time_weight(address) external view returns (uint256);
146     function points_sum(int128, uint256) external view returns (Point memory);
147     function time_sum(uint256) external view returns (uint256);
148     function points_total(uint256) external view returns (uint256);
149     function time_total() external view returns (uint256);
150     function points_type_weight(int128, uint256)
151         external
152         view
153         returns (uint256);
154     function time_type_weight(uint256) external view returns (uint256);
155 
156     // Getter functions
157     function gauge_types(address) external view returns (int128);
158     function gauge_relative_weight(address) external view returns (uint256);
159     function gauge_relative_weight(address, uint256) external view returns (uint256);
160     function get_gauge_weight(address) external view returns (uint256);
161     function get_type_weight(int128) external view returns (uint256);
162     function get_total_weight() external view returns (uint256);
163     function get_weights_sum_per_type(int128) external view returns (uint256);
164 
165     // External functions
166     function commit_transfer_ownership(address) external;
167     function apply_transfer_ownership() external;
168     function add_gauge(
169         address,
170         int128,
171         uint256
172     ) external;
173     function checkpoint() external;
174     function checkpoint_gauge(address) external;
175     function global_emission_rate() external view returns (uint256);
176     function gauge_relative_weight_write(address)
177         external
178         returns (uint256);
179     function gauge_relative_weight_write(address, uint256)
180         external
181         returns (uint256);
182     function add_type(string memory, uint256) external;
183     function change_type_weight(int128, uint256) external;
184     function change_gauge_weight(address, uint256) external;
185     function change_global_emission_rate(uint256) external;
186     function vote_for_gauge_weights(address, uint256) external;
187 }
188 
189 
190 // File contracts/Curve/IFraxGaugeFXSRewardsDistributor.sol
191 
192 
193 interface IFraxGaugeFXSRewardsDistributor {
194   function acceptOwnership() external;
195   function curator_address() external view returns(address);
196   function currentReward(address gauge_address) external view returns(uint256 reward_amount);
197   function distributeReward(address gauge_address) external returns(uint256 weeks_elapsed, uint256 reward_tally);
198   function distributionsOn() external view returns(bool);
199   function gauge_whitelist(address) external view returns(bool);
200   function is_middleman(address) external view returns(bool);
201   function last_time_gauge_paid(address) external view returns(uint256);
202   function nominateNewOwner(address _owner) external;
203   function nominatedOwner() external view returns(address);
204   function owner() external view returns(address);
205   function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
206   function setCurator(address _new_curator_address) external;
207   function setGaugeController(address _gauge_controller_address) external;
208   function setGaugeState(address _gauge_address, bool _is_middleman, bool _is_active) external;
209   function setTimelock(address _new_timelock) external;
210   function timelock_address() external view returns(address);
211   function toggleDistributions() external;
212 }
213 
214 
215 // File contracts/Common/Context.sol
216 
217 
218 /*
219  * @dev Provides information about the current execution context, including the
220  * sender of the transaction and its data. While these are generally available
221  * via msg.sender and msg.data, they should not be accessed in such a direct
222  * manner, since when dealing with GSN meta-transactions the account sending and
223  * paying for execution may not be the actual sender (as far as an application
224  * is concerned).
225  *
226  * This contract is only required for intermediate, library-like contracts.
227  */
228 abstract contract Context {
229     function _msgSender() internal view virtual returns (address payable) {
230         return payable(msg.sender);
231     }
232 
233     function _msgData() internal view virtual returns (bytes memory) {
234         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
235         return msg.data;
236     }
237 }
238 
239 
240 // File contracts/Math/SafeMath.sol
241 
242 
243 /**
244  * @dev Wrappers over Solidity's arithmetic operations with added overflow
245  * checks.
246  *
247  * Arithmetic operations in Solidity wrap on overflow. This can easily result
248  * in bugs, because programmers usually assume that an overflow raises an
249  * error, which is the standard behavior in high level programming languages.
250  * `SafeMath` restores this intuition by reverting the transaction when an
251  * operation overflows.
252  *
253  * Using this library instead of the unchecked operations eliminates an entire
254  * class of bugs, so it's recommended to use it always.
255  */
256 library SafeMath {
257     /**
258      * @dev Returns the addition of two unsigned integers, reverting on
259      * overflow.
260      *
261      * Counterpart to Solidity's `+` operator.
262      *
263      * Requirements:
264      * - Addition cannot overflow.
265      */
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         uint256 c = a + b;
268         require(c >= a, "SafeMath: addition overflow");
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the subtraction of two unsigned integers, reverting on
275      * overflow (when the result is negative).
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283         return sub(a, b, "SafeMath: subtraction overflow");
284     }
285 
286     /**
287      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
288      * overflow (when the result is negative).
289      *
290      * Counterpart to Solidity's `-` operator.
291      *
292      * Requirements:
293      * - Subtraction cannot overflow.
294      *
295      * _Available since v2.4.0._
296      */
297     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b <= a, errorMessage);
299         uint256 c = a - b;
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the multiplication of two unsigned integers, reverting on
306      * overflow.
307      *
308      * Counterpart to Solidity's `*` operator.
309      *
310      * Requirements:
311      * - Multiplication cannot overflow.
312      */
313     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
314         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
315         // benefit is lost if 'b' is also tested.
316         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
317         if (a == 0) {
318             return 0;
319         }
320 
321         uint256 c = a * b;
322         require(c / a == b, "SafeMath: multiplication overflow");
323 
324         return c;
325     }
326 
327     /**
328      * @dev Returns the integer division of two unsigned integers. Reverts on
329      * division by zero. The result is rounded towards zero.
330      *
331      * Counterpart to Solidity's `/` operator. Note: this function uses a
332      * `revert` opcode (which leaves remaining gas untouched) while Solidity
333      * uses an invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      * - The divisor cannot be zero.
337      */
338     function div(uint256 a, uint256 b) internal pure returns (uint256) {
339         return div(a, b, "SafeMath: division by zero");
340     }
341 
342     /**
343      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
344      * division by zero. The result is rounded towards zero.
345      *
346      * Counterpart to Solidity's `/` operator. Note: this function uses a
347      * `revert` opcode (which leaves remaining gas untouched) while Solidity
348      * uses an invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      * - The divisor cannot be zero.
352      *
353      * _Available since v2.4.0._
354      */
355     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         // Solidity only automatically asserts when dividing by 0
357         require(b > 0, errorMessage);
358         uint256 c = a / b;
359         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
360 
361         return c;
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
366      * Reverts when dividing by zero.
367      *
368      * Counterpart to Solidity's `%` operator. This function uses a `revert`
369      * opcode (which leaves remaining gas untouched) while Solidity uses an
370      * invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      * - The divisor cannot be zero.
374      */
375     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
376         return mod(a, b, "SafeMath: modulo by zero");
377     }
378 
379     /**
380      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
381      * Reverts with custom message when dividing by zero.
382      *
383      * Counterpart to Solidity's `%` operator. This function uses a `revert`
384      * opcode (which leaves remaining gas untouched) while Solidity uses an
385      * invalid opcode to revert (consuming all remaining gas).
386      *
387      * Requirements:
388      * - The divisor cannot be zero.
389      *
390      * _Available since v2.4.0._
391      */
392     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
393         require(b != 0, errorMessage);
394         return a % b;
395     }
396 }
397 
398 
399 // File contracts/ERC20/IERC20.sol
400 
401 
402 
403 /**
404  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
405  * the optional functions; to access them see {ERC20Detailed}.
406  */
407 interface IERC20 {
408     /**
409      * @dev Returns the amount of tokens in existence.
410      */
411     function totalSupply() external view returns (uint256);
412 
413     /**
414      * @dev Returns the amount of tokens owned by `account`.
415      */
416     function balanceOf(address account) external view returns (uint256);
417 
418     /**
419      * @dev Moves `amount` tokens from the caller's account to `recipient`.
420      *
421      * Returns a boolean value indicating whether the operation succeeded.
422      *
423      * Emits a {Transfer} event.
424      */
425     function transfer(address recipient, uint256 amount) external returns (bool);
426 
427     /**
428      * @dev Returns the remaining number of tokens that `spender` will be
429      * allowed to spend on behalf of `owner` through {transferFrom}. This is
430      * zero by default.
431      *
432      * This value changes when {approve} or {transferFrom} are called.
433      */
434     function allowance(address owner, address spender) external view returns (uint256);
435 
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
438      *
439      * Returns a boolean value indicating whether the operation succeeded.
440      *
441      * IMPORTANT: Beware that changing an allowance with this method brings the risk
442      * that someone may use both the old and the new allowance by unfortunate
443      * transaction ordering. One possible solution to mitigate this race
444      * condition is to first reduce the spender's allowance to 0 and set the
445      * desired value afterwards:
446      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
447      *
448      * Emits an {Approval} event.
449      */
450     function approve(address spender, uint256 amount) external returns (bool);
451 
452     /**
453      * @dev Moves `amount` tokens from `sender` to `recipient` using the
454      * allowance mechanism. `amount` is then deducted from the caller's
455      * allowance.
456      *
457      * Returns a boolean value indicating whether the operation succeeded.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
462 
463     /**
464      * @dev Emitted when `value` tokens are moved from one account (`from`) to
465      * another (`to`).
466      *
467      * Note that `value` may be zero.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 value);
470 
471     /**
472      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
473      * a call to {approve}. `value` is the new allowance.
474      */
475     event Approval(address indexed owner, address indexed spender, uint256 value);
476 }
477 
478 
479 // File contracts/Utils/Address.sol
480 
481 
482 /**
483  * @dev Collection of functions related to the address type
484  */
485 library Address {
486     /**
487      * @dev Returns true if `account` is a contract.
488      *
489      * [IMPORTANT]
490      * ====
491      * It is unsafe to assume that an address for which this function returns
492      * false is an externally-owned account (EOA) and not a contract.
493      *
494      * Among others, `isContract` will return false for the following
495      * types of addresses:
496      *
497      *  - an externally-owned account
498      *  - a contract in construction
499      *  - an address where a contract will be created
500      *  - an address where a contract lived, but was destroyed
501      * ====
502      */
503     function isContract(address account) internal view returns (bool) {
504         // This method relies on extcodesize, which returns 0 for contracts in
505         // construction, since the code is only stored at the end of the
506         // constructor execution.
507 
508         uint256 size;
509         // solhint-disable-next-line no-inline-assembly
510         assembly { size := extcodesize(account) }
511         return size > 0;
512     }
513 
514     /**
515      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
516      * `recipient`, forwarding all available gas and reverting on errors.
517      *
518      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
519      * of certain opcodes, possibly making contracts go over the 2300 gas limit
520      * imposed by `transfer`, making them unable to receive funds via
521      * `transfer`. {sendValue} removes this limitation.
522      *
523      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
524      *
525      * IMPORTANT: because control is transferred to `recipient`, care must be
526      * taken to not create reentrancy vulnerabilities. Consider using
527      * {ReentrancyGuard} or the
528      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
529      */
530     function sendValue(address payable recipient, uint256 amount) internal {
531         require(address(this).balance >= amount, "Address: insufficient balance");
532 
533         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
534         (bool success, ) = recipient.call{ value: amount }("");
535         require(success, "Address: unable to send value, recipient may have reverted");
536     }
537 
538     /**
539      * @dev Performs a Solidity function call using a low level `call`. A
540      * plain`call` is an unsafe replacement for a function call: use this
541      * function instead.
542      *
543      * If `target` reverts with a revert reason, it is bubbled up by this
544      * function (like regular Solidity function calls).
545      *
546      * Returns the raw returned data. To convert to the expected return value,
547      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
548      *
549      * Requirements:
550      *
551      * - `target` must be a contract.
552      * - calling `target` with `data` must not revert.
553      *
554      * _Available since v3.1._
555      */
556     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
557       return functionCall(target, data, "Address: low-level call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
562      * `errorMessage` as a fallback revert reason when `target` reverts.
563      *
564      * _Available since v3.1._
565      */
566     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, 0, errorMessage);
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
572      * but also transferring `value` wei to `target`.
573      *
574      * Requirements:
575      *
576      * - the calling contract must have an ETH balance of at least `value`.
577      * - the called Solidity function must be `payable`.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
582         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
587      * with `errorMessage` as a fallback revert reason when `target` reverts.
588      *
589      * _Available since v3.1._
590      */
591     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
592         require(address(this).balance >= value, "Address: insufficient balance for call");
593         require(isContract(target), "Address: call to non-contract");
594 
595         // solhint-disable-next-line avoid-low-level-calls
596         (bool success, bytes memory returndata) = target.call{ value: value }(data);
597         return _verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
607         return functionStaticCall(target, data, "Address: low-level static call failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
612      * but performing a static call.
613      *
614      * _Available since v3.3._
615      */
616     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
617         require(isContract(target), "Address: static call to non-contract");
618 
619         // solhint-disable-next-line avoid-low-level-calls
620         (bool success, bytes memory returndata) = target.staticcall(data);
621         return _verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
631         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a delegate call.
637      *
638      * _Available since v3.4._
639      */
640     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
641         require(isContract(target), "Address: delegate call to non-contract");
642 
643         // solhint-disable-next-line avoid-low-level-calls
644         (bool success, bytes memory returndata) = target.delegatecall(data);
645         return _verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
649         if (success) {
650             return returndata;
651         } else {
652             // Look for revert reason and bubble it up if present
653             if (returndata.length > 0) {
654                 // The easiest way to bubble the revert reason is using memory via assembly
655 
656                 // solhint-disable-next-line no-inline-assembly
657                 assembly {
658                     let returndata_size := mload(returndata)
659                     revert(add(32, returndata), returndata_size)
660                 }
661             } else {
662                 revert(errorMessage);
663             }
664         }
665     }
666 }
667 
668 
669 // File contracts/ERC20/ERC20.sol
670 
671 
672 
673 
674 
675 /**
676  * @dev Implementation of the {IERC20} interface.
677  *
678  * This implementation is agnostic to the way tokens are created. This means
679  * that a supply mechanism has to be added in a derived contract using {_mint}.
680  * For a generic mechanism see {ERC20Mintable}.
681  *
682  * TIP: For a detailed writeup see our guide
683  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
684  * to implement supply mechanisms].
685  *
686  * We have followed general OpenZeppelin guidelines: functions revert instead
687  * of returning `false` on failure. This behavior is nonetheless conventional
688  * and does not conflict with the expectations of ERC20 applications.
689  *
690  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
691  * This allows applications to reconstruct the allowance for all accounts just
692  * by listening to said events. Other implementations of the EIP may not emit
693  * these events, as it isn't required by the specification.
694  *
695  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
696  * functions have been added to mitigate the well-known issues around setting
697  * allowances. See {IERC20-approve}.
698  */
699  
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
722     constructor (string memory __name, string memory __symbol) public {
723         _name = __name;
724         _symbol = __symbol;
725         _decimals = 18;
726     }
727 
728     /**
729      * @dev Returns the name of the token.
730      */
731     function name() public view returns (string memory) {
732         return _name;
733     }
734 
735     /**
736      * @dev Returns the symbol of the token, usually a shorter version of the
737      * name.
738      */
739     function symbol() public view returns (string memory) {
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
756     function decimals() public view returns (uint8) {
757         return _decimals;
758     }
759 
760     /**
761      * @dev See {IERC20-totalSupply}.
762      */
763     function totalSupply() public view override returns (uint256) {
764         return _totalSupply;
765     }
766 
767     /**
768      * @dev See {IERC20-balanceOf}.
769      */
770     function balanceOf(address account) public view override returns (uint256) {
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
799      * - `spender` cannot be the zero address.approve(address spender, uint256 amount)
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
810      * required by the EIP. See the note at the beginning of {ERC20};
811      *
812      * Requirements:
813      * - `sender` and `recipient` cannot be the zero address.
814      * - `sender` must have a balance of at least `amount`.
815      * - the caller must have allowance for `sender`'s tokens of at least
816      * `amount`.
817      */
818     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
819         _transfer(sender, recipient, amount);
820         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
821         return true;
822     }
823 
824     /**
825      * @dev Atomically increases the allowance granted to `spender` by the caller.
826      *
827      * This is an alternative to {approve} that can be used as a mitigation for
828      * problems described in {IERC20-approve}.
829      *
830      * Emits an {Approval} event indicating the updated allowance.
831      *
832      * Requirements:
833      *
834      * - `spender` cannot be the zero address.
835      */
836     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
837         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
838         return true;
839     }
840 
841     /**
842      * @dev Atomically decreases the allowance granted to `spender` by the caller.
843      *
844      * This is an alternative to {approve} that can be used as a mitigation for
845      * problems described in {IERC20-approve}.
846      *
847      * Emits an {Approval} event indicating the updated allowance.
848      *
849      * Requirements:
850      *
851      * - `spender` cannot be the zero address.
852      * - `spender` must have allowance for the caller of at least
853      * `subtractedValue`.
854      */
855     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
856         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
857         return true;
858     }
859 
860     /**
861      * @dev Moves tokens `amount` from `sender` to `recipient`.
862      *
863      * This is internal function is equivalent to {transfer}, and can be used to
864      * e.g. implement automatic token fees, slashing mechanisms, etc.
865      *
866      * Emits a {Transfer} event.
867      *
868      * Requirements:
869      *
870      * - `sender` cannot be the zero address.
871      * - `recipient` cannot be the zero address.
872      * - `sender` must have a balance of at least `amount`.
873      */
874     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
875         require(sender != address(0), "ERC20: transfer from the zero address");
876         require(recipient != address(0), "ERC20: transfer to the zero address");
877 
878         _beforeTokenTransfer(sender, recipient, amount);
879 
880         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
881         _balances[recipient] = _balances[recipient].add(amount);
882         emit Transfer(sender, recipient, amount);
883     }
884 
885     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
886      * the total supply.
887      *
888      * Emits a {Transfer} event with `from` set to the zero address.
889      *
890      * Requirements
891      *
892      * - `to` cannot be the zero address.
893      */
894     function _mint(address account, uint256 amount) internal virtual {
895         require(account != address(0), "ERC20: mint to the zero address");
896 
897         _beforeTokenTransfer(address(0), account, amount);
898 
899         _totalSupply = _totalSupply.add(amount);
900         _balances[account] = _balances[account].add(amount);
901         emit Transfer(address(0), account, amount);
902     }
903 
904     /**
905      * @dev Destroys `amount` tokens from the caller.
906      *
907      * See {ERC20-_burn}.
908      */
909     function burn(uint256 amount) public virtual {
910         _burn(_msgSender(), amount);
911     }
912 
913     /**
914      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
915      * allowance.
916      *
917      * See {ERC20-_burn} and {ERC20-allowance}.
918      *
919      * Requirements:
920      *
921      * - the caller must have allowance for `accounts`'s tokens of at least
922      * `amount`.
923      */
924     function burnFrom(address account, uint256 amount) public virtual {
925         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
926 
927         _approve(account, _msgSender(), decreasedAllowance);
928         _burn(account, amount);
929     }
930 
931 
932     /**
933      * @dev Destroys `amount` tokens from `account`, reducing the
934      * total supply.
935      *
936      * Emits a {Transfer} event with `to` set to the zero address.
937      *
938      * Requirements
939      *
940      * - `account` cannot be the zero address.
941      * - `account` must have at least `amount` tokens.
942      */
943     function _burn(address account, uint256 amount) internal virtual {
944         require(account != address(0), "ERC20: burn from the zero address");
945 
946         _beforeTokenTransfer(account, address(0), amount);
947 
948         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
949         _totalSupply = _totalSupply.sub(amount);
950         emit Transfer(account, address(0), amount);
951     }
952 
953     /**
954      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
955      *
956      * This is internal function is equivalent to `approve`, and can be used to
957      * e.g. set automatic allowances for certain subsystems, etc.
958      *
959      * Emits an {Approval} event.
960      *
961      * Requirements:
962      *
963      * - `owner` cannot be the zero address.
964      * - `spender` cannot be the zero address.
965      */
966     function _approve(address owner, address spender, uint256 amount) internal virtual {
967         require(owner != address(0), "ERC20: approve from the zero address");
968         require(spender != address(0), "ERC20: approve to the zero address");
969 
970         _allowances[owner][spender] = amount;
971         emit Approval(owner, spender, amount);
972     }
973 
974     /**
975      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
976      * from the caller's allowance.
977      *
978      * See {_burn} and {_approve}.
979      */
980     function _burnFrom(address account, uint256 amount) internal virtual {
981         _burn(account, amount);
982         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
983     }
984 
985     /**
986      * @dev Hook that is called before any transfer of tokens. This includes
987      * minting and burning.
988      *
989      * Calling conditions:
990      *
991      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
992      * will be to transferred to `to`.
993      * - when `from` is zero, `amount` tokens will be minted for `to`.
994      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
995      * - `from` and `to` are never both zero.
996      *
997      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
998      */
999     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1000 }
1001 
1002 
1003 // File contracts/Uniswap/TransferHelper.sol
1004 
1005 
1006 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
1007 library TransferHelper {
1008     function safeApprove(address token, address to, uint value) internal {
1009         // bytes4(keccak256(bytes('approve(address,uint256)')));
1010         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1011         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1012     }
1013 
1014     function safeTransfer(address token, address to, uint value) internal {
1015         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1016         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
1017         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
1018     }
1019 
1020     function safeTransferFrom(address token, address from, address to, uint value) internal {
1021         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1022         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1023         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1024     }
1025 
1026     function safeTransferETH(address to, uint value) internal {
1027         (bool success,) = to.call{value:value}(new bytes(0));
1028         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1029     }
1030 }
1031 
1032 
1033 // File contracts/ERC20/SafeERC20.sol
1034 
1035 
1036 
1037 
1038 /**
1039  * @title SafeERC20
1040  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1041  * contract returns false). Tokens that return no value (and instead revert or
1042  * throw on failure) are also supported, non-reverting calls are assumed to be
1043  * successful.
1044  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1045  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1046  */
1047 library SafeERC20 {
1048     using SafeMath for uint256;
1049     using Address for address;
1050 
1051     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1052         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1053     }
1054 
1055     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1056         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1057     }
1058 
1059     /**
1060      * @dev Deprecated. This function has issues similar to the ones found in
1061      * {IERC20-approve}, and its usage is discouraged.
1062      *
1063      * Whenever possible, use {safeIncreaseAllowance} and
1064      * {safeDecreaseAllowance} instead.
1065      */
1066     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1067         // safeApprove should only be called when setting an initial allowance,
1068         // or when resetting it to zero. To increase and decrease it, use
1069         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1070         // solhint-disable-next-line max-line-length
1071         require((value == 0) || (token.allowance(address(this), spender) == 0),
1072             "SafeERC20: approve from non-zero to non-zero allowance"
1073         );
1074         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1075     }
1076 
1077     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1078         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1079         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1080     }
1081 
1082     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1083         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1084         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1085     }
1086 
1087     /**
1088      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1089      * on the return value: the return value is optional (but if data is returned, it must not be false).
1090      * @param token The token targeted by the call.
1091      * @param data The call data (encoded using abi.encode or one of its variants).
1092      */
1093     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1094         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1095         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1096         // the target address contains contract code and also asserts for success in the low-level call.
1097 
1098         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1099         if (returndata.length > 0) { // Return data is optional
1100             // solhint-disable-next-line max-line-length
1101             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1102         }
1103     }
1104 }
1105 
1106 
1107 // File contracts/Utils/ReentrancyGuard.sol
1108 
1109 
1110 /**
1111  * @dev Contract module that helps prevent reentrant calls to a function.
1112  *
1113  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1114  * available, which can be applied to functions to make sure there are no nested
1115  * (reentrant) calls to them.
1116  *
1117  * Note that because there is a single `nonReentrant` guard, functions marked as
1118  * `nonReentrant` may not call one another. This can be worked around by making
1119  * those functions `private`, and then adding `external` `nonReentrant` entry
1120  * points to them.
1121  *
1122  * TIP: If you would like to learn more about reentrancy and alternative ways
1123  * to protect against it, check out our blog post
1124  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1125  */
1126 abstract contract ReentrancyGuard {
1127     // Booleans are more expensive than uint256 or any type that takes up a full
1128     // word because each write operation emits an extra SLOAD to first read the
1129     // slot's contents, replace the bits taken up by the boolean, and then write
1130     // back. This is the compiler's defense against contract upgrades and
1131     // pointer aliasing, and it cannot be disabled.
1132 
1133     // The values being non-zero value makes deployment a bit more expensive,
1134     // but in exchange the refund on every call to nonReentrant will be lower in
1135     // amount. Since refunds are capped to a percentage of the total
1136     // transaction's gas, it is best to keep them low in cases like this one, to
1137     // increase the likelihood of the full refund coming into effect.
1138     uint256 private constant _NOT_ENTERED = 1;
1139     uint256 private constant _ENTERED = 2;
1140 
1141     uint256 private _status;
1142 
1143     constructor () internal {
1144         _status = _NOT_ENTERED;
1145     }
1146 
1147     /**
1148      * @dev Prevents a contract from calling itself, directly or indirectly.
1149      * Calling a `nonReentrant` function from another `nonReentrant`
1150      * function is not supported. It is possible to prevent this from happening
1151      * by making the `nonReentrant` function external, and make it call a
1152      * `private` function that does the actual work.
1153      */
1154     modifier nonReentrant() {
1155         // On the first call to nonReentrant, _notEntered will be true
1156         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1157 
1158         // Any calls to nonReentrant after this point will fail
1159         _status = _ENTERED;
1160 
1161         _;
1162 
1163         // By storing the original value once again, a refund is triggered (see
1164         // https://eips.ethereum.org/EIPS/eip-2200)
1165         _status = _NOT_ENTERED;
1166     }
1167 }
1168 
1169 
1170 // File contracts/Staking/Owned.sol
1171 
1172 
1173 // https://docs.synthetix.io/contracts/Owned
1174 contract Owned {
1175     address public owner;
1176     address public nominatedOwner;
1177 
1178     constructor (address _owner) public {
1179         require(_owner != address(0), "Owner address cannot be 0");
1180         owner = _owner;
1181         emit OwnerChanged(address(0), _owner);
1182     }
1183 
1184     function nominateNewOwner(address _owner) external onlyOwner {
1185         nominatedOwner = _owner;
1186         emit OwnerNominated(_owner);
1187     }
1188 
1189     function acceptOwnership() external {
1190         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
1191         emit OwnerChanged(owner, nominatedOwner);
1192         owner = nominatedOwner;
1193         nominatedOwner = address(0);
1194     }
1195 
1196     modifier onlyOwner {
1197         require(msg.sender == owner, "Only the contract owner may perform this action");
1198         _;
1199     }
1200 
1201     event OwnerNominated(address newOwner);
1202     event OwnerChanged(address oldOwner, address newOwner);
1203 }
1204 
1205 
1206 // File contracts/Staking/FraxUnifiedFarmTemplate.sol
1207 
1208 pragma experimental ABIEncoderV2;
1209 
1210 // ====================================================================
1211 // |     ______                   _______                             |
1212 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1213 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1214 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1215 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1216 // |                                                                  |
1217 // ====================================================================
1218 // ====================== FraxUnifiedFarmTemplate =====================
1219 // ====================================================================
1220 // Migratable Farming contract that accounts for veFXS
1221 // Overrideable for UniV3, ERC20s, etc
1222 // New for V2
1223 //      - Multiple reward tokens possible
1224 //      - Can add to existing locked stakes
1225 //      - Contract is aware of proxied veFXS
1226 //      - veFXS multiplier formula changed
1227 // Apes together strong
1228 
1229 // Frax Finance: https://github.com/FraxFinance
1230 
1231 // Primary Author(s)
1232 // Travis Moore: https://github.com/FortisFortuna
1233 
1234 // Reviewer(s) / Contributor(s)
1235 // Jason Huan: https://github.com/jasonhuan
1236 // Sam Kazemian: https://github.com/samkazemian
1237 // Dennis: github.com/denett
1238 // Sam Sun: https://github.com/samczsun
1239 
1240 // Originally inspired by Synthetix.io, but heavily modified by the Frax team
1241 // (Locked, veFXS, and UniV3 portions are new)
1242 // https://raw.githubusercontent.com/Synthetixio/synthetix/develop/contracts/StakingRewards.sol
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 contract FraxUnifiedFarmTemplate is Owned, ReentrancyGuard {
1253     using SafeERC20 for ERC20;
1254 
1255     /* ========== STATE VARIABLES ========== */
1256 
1257     // Instances
1258     IveFXS private veFXS = IveFXS(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0);
1259     
1260     // Frax related
1261     address internal constant frax_address = 0x853d955aCEf822Db058eb8505911ED77F175b99e;
1262     bool internal frax_is_token0;
1263     uint256 private fraxPerLPStored;
1264 
1265     // Constant for various precisions
1266     uint256 internal constant MULTIPLIER_PRECISION = 1e18;
1267 
1268     // Time tracking
1269     uint256 public periodFinish;
1270     uint256 public lastUpdateTime;
1271 
1272     // Lock time and multiplier settings
1273     uint256 public lock_max_multiplier = uint256(3e18); // E18. 1x = e18
1274     uint256 public lock_time_for_max_multiplier = 3 * 365 * 86400; // 3 years
1275     uint256 public lock_time_min = 86400; // 1 * 86400  (1 day)
1276 
1277     // veFXS related
1278     uint256 public vefxs_boost_scale_factor = uint256(4e18); // E18. 4x = 4e18; 100 / scale_factor = % vefxs supply needed for max boost
1279     uint256 public vefxs_max_multiplier = uint256(2e18); // E18. 1x = 1e18
1280     uint256 public vefxs_per_frax_for_max_boost = uint256(2e18); // E18. 2e18 means 2 veFXS must be held by the staker per 1 FRAX
1281     mapping(address => uint256) internal _vefxsMultiplierStored;
1282     mapping(address => bool) internal valid_vefxs_proxies;
1283     mapping(address => mapping(address => bool)) internal proxy_allowed_stakers;
1284 
1285     // Reward addresses, gauge addresses, reward rates, and reward managers
1286     mapping(address => address) public rewardManagers; // token addr -> manager addr
1287     address[] internal rewardTokens;
1288     address[] internal gaugeControllers;
1289     address[] internal rewardDistributors;
1290     uint256[] internal rewardRatesManual;
1291     mapping(address => uint256) public rewardTokenAddrToIdx; // token addr -> token index
1292     
1293     // Reward period
1294     uint256 public constant rewardsDuration = 604800; // 7 * 86400  (7 days)
1295 
1296     // Reward tracking
1297     uint256[] private rewardsPerTokenStored;
1298     mapping(address => mapping(uint256 => uint256)) private userRewardsPerTokenPaid; // staker addr -> token id -> paid amount
1299     mapping(address => mapping(uint256 => uint256)) private rewards; // staker addr -> token id -> reward amount
1300     mapping(address => uint256) internal lastRewardClaimTime; // staker addr -> timestamp
1301     
1302     // Gauge tracking
1303     uint256[] private last_gauge_relative_weights;
1304     uint256[] private last_gauge_time_totals;
1305 
1306     // Balance tracking
1307     uint256 internal _total_liquidity_locked;
1308     uint256 internal _total_combined_weight;
1309     mapping(address => uint256) internal _locked_liquidity;
1310     mapping(address => uint256) internal _combined_weights;
1311     mapping(address => uint256) public proxy_lp_balances; // Keeps track of LP balances proxy-wide. Needed to make sure the proxy boost is kept in line
1312 
1313     // List of valid migrators (set by governance)
1314     mapping(address => bool) internal valid_migrators;
1315 
1316     // Stakers set which migrator(s) they want to use
1317     mapping(address => mapping(address => bool)) internal staker_allowed_migrators;
1318     mapping(address => address) public staker_designated_proxies; // Keep public so users can see on the frontend if they have a proxy
1319 
1320     // Admin booleans for emergencies, migrations, and overrides
1321     bool public stakesUnlocked; // Release locked stakes in case of emergency
1322     bool internal migrationsOn; // Used for migrations. Prevents new stakes, but allows LP and reward withdrawals
1323     bool internal withdrawalsPaused; // For emergencies
1324     bool internal rewardsCollectionPaused; // For emergencies
1325     bool internal stakingPaused; // For emergencies
1326 
1327     /* ========== STRUCTS ========== */
1328     // In children...
1329 
1330 
1331     /* ========== MODIFIERS ========== */
1332 
1333     modifier onlyByOwnGov() {
1334         require(msg.sender == owner || msg.sender == 0x8412ebf45bAC1B340BbE8F318b928C466c4E39CA, "Not owner or timelock");
1335         _;
1336     }
1337 
1338     modifier onlyTknMgrs(address reward_token_address) {
1339         require(msg.sender == owner || isTokenManagerFor(msg.sender, reward_token_address), "Not owner or tkn mgr");
1340         _;
1341     }
1342 
1343     modifier isMigrating() {
1344         require(migrationsOn == true, "Not in migration");
1345         _;
1346     }
1347 
1348     modifier updateRewardAndBalance(address account, bool sync_too) {
1349         _updateRewardAndBalance(account, sync_too);
1350         _;
1351     }
1352 
1353     /* ========== CONSTRUCTOR ========== */
1354 
1355     constructor (
1356         address _owner,
1357         address[] memory _rewardTokens,
1358         address[] memory _rewardManagers,
1359         uint256[] memory _rewardRatesManual,
1360         address[] memory _gaugeControllers,
1361         address[] memory _rewardDistributors
1362     ) Owned(_owner) {
1363 
1364         // Address arrays
1365         rewardTokens = _rewardTokens;
1366         gaugeControllers = _gaugeControllers;
1367         rewardDistributors = _rewardDistributors;
1368         rewardRatesManual = _rewardRatesManual;
1369 
1370         for (uint256 i = 0; i < _rewardTokens.length; i++){ 
1371             // For fast token address -> token ID lookups later
1372             rewardTokenAddrToIdx[_rewardTokens[i]] = i;
1373 
1374             // Initialize the stored rewards
1375             rewardsPerTokenStored.push(0);
1376 
1377             // Initialize the reward managers
1378             rewardManagers[_rewardTokens[i]] = _rewardManagers[i];
1379 
1380             // Push in empty relative weights to initialize the array
1381             last_gauge_relative_weights.push(0);
1382 
1383             // Push in empty time totals to initialize the array
1384             last_gauge_time_totals.push(0);
1385         }
1386 
1387         // Other booleans
1388         stakesUnlocked = false;
1389 
1390         // Initialization
1391         lastUpdateTime = block.timestamp;
1392         periodFinish = block.timestamp + rewardsDuration;
1393     }
1394 
1395     /* ============= VIEWS ============= */
1396 
1397     // ------ REWARD RELATED ------
1398 
1399     // See if the caller_addr is a manager for the reward token 
1400     function isTokenManagerFor(address caller_addr, address reward_token_addr) public view returns (bool){
1401         if (caller_addr == owner) return true; // Contract owner
1402         else if (rewardManagers[reward_token_addr] == caller_addr) return true; // Reward manager
1403         return false; 
1404     }
1405 
1406     // All the reward tokens
1407     function getAllRewardTokens() external view returns (address[] memory) {
1408         return rewardTokens;
1409     }
1410 
1411     // Last time the reward was applicable
1412     function lastTimeRewardApplicable() internal view returns (uint256) {
1413         return Math.min(block.timestamp, periodFinish);
1414     }
1415 
1416     function rewardRates(uint256 token_idx) public view returns (uint256 rwd_rate) {
1417         address gauge_controller_address = gaugeControllers[token_idx];
1418         if (gauge_controller_address != address(0)) {
1419             rwd_rate = (IFraxGaugeController(gauge_controller_address).global_emission_rate() * last_gauge_relative_weights[token_idx]) / 1e18;
1420         }
1421         else {
1422             rwd_rate = rewardRatesManual[token_idx];
1423         }
1424     }
1425 
1426     // Amount of reward tokens per LP token / liquidity unit
1427     function rewardsPerToken() public view returns (uint256[] memory newRewardsPerTokenStored) {
1428         if (_total_liquidity_locked == 0 || _total_combined_weight == 0) {
1429             return rewardsPerTokenStored;
1430         }
1431         else {
1432             newRewardsPerTokenStored = new uint256[](rewardTokens.length);
1433             for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
1434                 newRewardsPerTokenStored[i] = rewardsPerTokenStored[i] + (
1435                     ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRates(i) * 1e18) / _total_combined_weight
1436                 );
1437             }
1438             return newRewardsPerTokenStored;
1439         }
1440     }
1441 
1442     // Amount of reward tokens an account has earned / accrued
1443     // Note: In the edge-case of one of the account's stake expiring since the last claim, this will
1444     // return a slightly inflated number
1445     function earned(address account) public view returns (uint256[] memory new_earned) {
1446         uint256[] memory reward_arr = rewardsPerToken();
1447         new_earned = new uint256[](rewardTokens.length);
1448 
1449         if (_combined_weights[account] > 0){
1450             for (uint256 i = 0; i < rewardTokens.length; i++){ 
1451                 new_earned[i] = ((_combined_weights[account] * (reward_arr[i] - userRewardsPerTokenPaid[account][i])) / 1e18)
1452                                 + rewards[account][i];
1453             }
1454         }
1455     }
1456 
1457     // Total reward tokens emitted in the given period
1458     function getRewardForDuration() external view returns (uint256[] memory rewards_per_duration_arr) {
1459         rewards_per_duration_arr = new uint256[](rewardRatesManual.length);
1460 
1461         for (uint256 i = 0; i < rewardRatesManual.length; i++){ 
1462             rewards_per_duration_arr[i] = rewardRates(i) * rewardsDuration;
1463         }
1464     }
1465 
1466 
1467     // ------ LIQUIDITY AND WEIGHTS ------
1468 
1469     // User locked liquidity / LP tokens
1470     function totalLiquidityLocked() external view returns (uint256) {
1471         return _total_liquidity_locked;
1472     }
1473 
1474     // Total locked liquidity / LP tokens
1475     function lockedLiquidityOf(address account) external view returns (uint256) {
1476         return _locked_liquidity[account];
1477     }
1478 
1479     // Total combined weight
1480     function totalCombinedWeight() external view returns (uint256) {
1481         return _total_combined_weight;
1482     }
1483 
1484     // Total 'balance' used for calculating the percent of the pool the account owns
1485     // Takes into account the locked stake time multiplier and veFXS multiplier
1486     function combinedWeightOf(address account) external view returns (uint256) {
1487         return _combined_weights[account];
1488     }
1489 
1490     // Calculated the combined weight for an account
1491     function calcCurCombinedWeight(address account) public virtual view 
1492         returns (
1493             uint256 old_combined_weight,
1494             uint256 new_vefxs_multiplier,
1495             uint256 new_combined_weight
1496         )
1497     {
1498         revert("Need cCCW logic");
1499     }
1500 
1501     // ------ LOCK RELATED ------
1502 
1503     // Multiplier amount, given the length of the lock
1504     function lockMultiplier(uint256 secs) public view returns (uint256) {
1505         return Math.min(
1506             lock_max_multiplier,
1507             uint256(MULTIPLIER_PRECISION) + (
1508                 (secs * (lock_max_multiplier - MULTIPLIER_PRECISION)) / lock_time_for_max_multiplier
1509             )
1510         ) ;
1511     }
1512 
1513     // ------ FRAX RELATED ------
1514 
1515     function userStakedFrax(address account) public view returns (uint256) {
1516         return (fraxPerLPStored * _locked_liquidity[account]) / MULTIPLIER_PRECISION;
1517     }
1518 
1519     function proxyStakedFrax(address proxy_address) public view returns (uint256) {
1520         return (fraxPerLPStored * proxy_lp_balances[proxy_address]) / MULTIPLIER_PRECISION;
1521     }
1522 
1523     // Max LP that can get max veFXS boosted for a given address at its current veFXS balance
1524     function maxLPForMaxBoost(address account) external view returns (uint256) {
1525         return (veFXS.balanceOf(account) * MULTIPLIER_PRECISION * MULTIPLIER_PRECISION) / (vefxs_per_frax_for_max_boost * fraxPerLPStored);
1526     }
1527 
1528     // Meant to be overridden
1529     function fraxPerLPToken() public virtual view returns (uint256) {
1530         revert("Need fPLPT logic");
1531     }
1532 
1533     // ------ veFXS RELATED ------
1534 
1535     function minVeFXSForMaxBoost(address account) public view returns (uint256) {
1536         return (userStakedFrax(account) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
1537     }
1538 
1539     function minVeFXSForMaxBoostProxy(address proxy_address) public view returns (uint256) {
1540         return (proxyStakedFrax(proxy_address) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
1541     }
1542 
1543     function veFXSMultiplier(address account) public view returns (uint256 vefxs_multiplier) {
1544         // Use either the user's or their proxy's veFXS balance
1545         uint256 vefxs_bal_to_use = 0;
1546         address the_proxy = staker_designated_proxies[account];
1547         vefxs_bal_to_use = (the_proxy == address(0)) ? veFXS.balanceOf(account) : veFXS.balanceOf(the_proxy);
1548 
1549         // First option based on fraction of total veFXS supply, with an added scale factor
1550         uint256 mult_optn_1 = (vefxs_bal_to_use * vefxs_max_multiplier * vefxs_boost_scale_factor) 
1551                             / (veFXS.totalSupply() * MULTIPLIER_PRECISION);
1552         
1553         // Second based on old method, where the amount of FRAX staked comes into play
1554         uint256 mult_optn_2;
1555         {
1556             uint256 veFXS_needed_for_max_boost;
1557 
1558             // Need to use proxy-wide FRAX balance if applicable, to prevent exploiting
1559             veFXS_needed_for_max_boost = (the_proxy == address(0)) ? minVeFXSForMaxBoost(account) : minVeFXSForMaxBoostProxy(the_proxy);
1560 
1561             if (veFXS_needed_for_max_boost > 0){ 
1562                 uint256 user_vefxs_fraction = (vefxs_bal_to_use * MULTIPLIER_PRECISION) / veFXS_needed_for_max_boost;
1563                 
1564                 mult_optn_2 = (user_vefxs_fraction * vefxs_max_multiplier) / MULTIPLIER_PRECISION;
1565             }
1566             else mult_optn_2 = 0; // This will happen with the first stake, when user_staked_frax is 0
1567         }
1568 
1569         // Select the higher of the two
1570         vefxs_multiplier = (mult_optn_1 > mult_optn_2 ? mult_optn_1 : mult_optn_2);
1571 
1572         // Cap the boost to the vefxs_max_multiplier
1573         if (vefxs_multiplier > vefxs_max_multiplier) vefxs_multiplier = vefxs_max_multiplier;
1574     }
1575 
1576     /* =============== MUTATIVE FUNCTIONS =============== */
1577 
1578     // ------ MIGRATIONS ------
1579 
1580     // Staker can allow a migrator 
1581     function stakerToggleMigrator(address migrator_address) external {
1582         require(valid_migrators[migrator_address], "Invalid migrator address");
1583         staker_allowed_migrators[msg.sender][migrator_address] = !staker_allowed_migrators[msg.sender][migrator_address]; 
1584     }
1585 
1586     // Proxy can allow a staker to use their veFXS balance (the staker will have to reciprocally toggle them too)
1587     // Must come before stakerSetVeFXSProxy
1588     function proxyToggleStaker(address staker_address) external {
1589         require(valid_vefxs_proxies[msg.sender], "Invalid proxy");
1590         proxy_allowed_stakers[msg.sender][staker_address] = !proxy_allowed_stakers[msg.sender][staker_address]; 
1591 
1592         // Disable the staker's set proxy if it was the toggler and is currently on
1593         if (staker_designated_proxies[staker_address] == msg.sender){
1594             staker_designated_proxies[staker_address] = address(0); 
1595 
1596             // Remove the LP as well
1597             proxy_lp_balances[msg.sender] -= _locked_liquidity[staker_address];
1598         }
1599     }
1600 
1601     // Staker can allow a veFXS proxy (the proxy will have to toggle them first)
1602     function stakerSetVeFXSProxy(address proxy_address) external {
1603         require(valid_vefxs_proxies[proxy_address], "Invalid proxy");
1604         require(proxy_allowed_stakers[proxy_address][msg.sender], "Proxy has not allowed you yet");
1605         staker_designated_proxies[msg.sender] = proxy_address; 
1606 
1607         // Add the the LP as well
1608         proxy_lp_balances[proxy_address] += _locked_liquidity[msg.sender];
1609     }
1610 
1611     // ------ STAKING ------
1612     // In children...
1613 
1614 
1615     // ------ WITHDRAWING ------
1616     // In children...
1617 
1618 
1619     // ------ REWARDS SYNCING ------
1620 
1621     function _updateRewardAndBalance(address account, bool sync_too) internal {
1622         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
1623         if (sync_too){
1624             sync();
1625         }
1626         
1627         if (account != address(0)) {
1628             // To keep the math correct, the user's combined weight must be recomputed to account for their
1629             // ever-changing veFXS balance.
1630             (   
1631                 uint256 old_combined_weight,
1632                 uint256 new_vefxs_multiplier,
1633                 uint256 new_combined_weight
1634             ) = calcCurCombinedWeight(account);
1635 
1636             // Calculate the earnings first
1637             _syncEarned(account);
1638 
1639             // Update the user's stored veFXS multipliers
1640             _vefxsMultiplierStored[account] = new_vefxs_multiplier;
1641 
1642             // Update the user's and the global combined weights
1643             if (new_combined_weight >= old_combined_weight) {
1644                 uint256 weight_diff = new_combined_weight - old_combined_weight;
1645                 _total_combined_weight = _total_combined_weight + weight_diff;
1646                 _combined_weights[account] = old_combined_weight + weight_diff;
1647             } else {
1648                 uint256 weight_diff = old_combined_weight - new_combined_weight;
1649                 _total_combined_weight = _total_combined_weight - weight_diff;
1650                 _combined_weights[account] = old_combined_weight - weight_diff;
1651             }
1652 
1653         }
1654     }
1655 
1656     function _syncEarned(address account) internal {
1657         if (account != address(0)) {
1658             // Calculate the earnings
1659             uint256[] memory earned_arr = earned(account);
1660 
1661             // Update the rewards array
1662             for (uint256 i = 0; i < earned_arr.length; i++){ 
1663                 rewards[account][i] = earned_arr[i];
1664             }
1665 
1666             // Update the rewards paid array
1667             for (uint256 i = 0; i < earned_arr.length; i++){ 
1668                 userRewardsPerTokenPaid[account][i] = rewardsPerTokenStored[i];
1669             }
1670         }
1671     }
1672 
1673 
1674     // ------ REWARDS CLAIMING ------
1675 
1676     function _getRewardExtraLogic(address rewardee, address destination_address) internal virtual {
1677         revert("Need gREL logic");
1678     }
1679 
1680     // Two different getReward functions are needed because of delegateCall and msg.sender issues
1681     function getReward(address destination_address) external nonReentrant returns (uint256[] memory) {
1682         require(rewardsCollectionPaused == false, "Rewards collection paused");
1683         return _getReward(msg.sender, destination_address);
1684     }
1685 
1686     // No withdrawer == msg.sender check needed since this is only internally callable
1687     function _getReward(address rewardee, address destination_address) internal updateRewardAndBalance(rewardee, true) returns (uint256[] memory rewards_before) {
1688         // Update the rewards array and distribute rewards
1689         rewards_before = new uint256[](rewardTokens.length);
1690 
1691         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1692             rewards_before[i] = rewards[rewardee][i];
1693             rewards[rewardee][i] = 0;
1694             TransferHelper.safeTransfer(rewardTokens[i], destination_address, rewards_before[i]);
1695         }
1696 
1697         // Handle additional reward logic
1698         _getRewardExtraLogic(rewardee, destination_address);
1699 
1700         // Update the last reward claim time
1701         lastRewardClaimTime[rewardee] = block.timestamp;
1702     }
1703 
1704 
1705     // ------ FARM SYNCING ------
1706 
1707     // If the period expired, renew it
1708     function retroCatchUp() internal {
1709         // Pull in rewards from the rewards distributor, if applicable
1710         for (uint256 i = 0; i < rewardDistributors.length; i++){ 
1711             address reward_distributor_address = rewardDistributors[i];
1712             if (reward_distributor_address != address(0)) {
1713                 IFraxGaugeFXSRewardsDistributor(reward_distributor_address).distributeReward(address(this));
1714             }
1715         }
1716 
1717         // Ensure the provided reward amount is not more than the balance in the contract.
1718         // This keeps the reward rate in the right range, preventing overflows due to
1719         // very high values of rewardRate in the earned and rewardsPerToken functions;
1720         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1721         uint256 num_periods_elapsed = uint256(block.timestamp - periodFinish) / rewardsDuration; // Floor division to the nearest period
1722         
1723         // Make sure there are enough tokens to renew the reward period
1724         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1725             require((rewardRates(i) * rewardsDuration * (num_periods_elapsed + 1)) <= ERC20(rewardTokens[i]).balanceOf(address(this)), string(abi.encodePacked("Not enough reward tokens available: ", rewardTokens[i])) );
1726         }
1727         
1728         // uint256 old_lastUpdateTime = lastUpdateTime;
1729         // uint256 new_lastUpdateTime = block.timestamp;
1730 
1731         // lastUpdateTime = periodFinish;
1732         periodFinish = periodFinish + ((num_periods_elapsed + 1) * rewardsDuration);
1733 
1734         // Update the rewards and time
1735         _updateStoredRewardsAndTime();
1736 
1737         // Update the fraxPerLPStored
1738         fraxPerLPStored = fraxPerLPToken();
1739     }
1740 
1741     function _updateStoredRewardsAndTime() internal {
1742         // Get the rewards
1743         uint256[] memory rewards_per_token = rewardsPerToken();
1744 
1745         // Update the rewardsPerTokenStored
1746         for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
1747             rewardsPerTokenStored[i] = rewards_per_token[i];
1748         }
1749 
1750         // Update the last stored time
1751         lastUpdateTime = lastTimeRewardApplicable();
1752     }
1753 
1754     function sync_gauge_weights(bool force_update) public {
1755         // Loop through the gauge controllers
1756         for (uint256 i = 0; i < gaugeControllers.length; i++){ 
1757             address gauge_controller_address = gaugeControllers[i];
1758             if (gauge_controller_address != address(0)) {
1759                 if (force_update || (block.timestamp > last_gauge_time_totals[i])){
1760                     // Update the gauge_relative_weight
1761                     last_gauge_relative_weights[i] = IFraxGaugeController(gauge_controller_address).gauge_relative_weight_write(address(this), block.timestamp);
1762                     last_gauge_time_totals[i] = IFraxGaugeController(gauge_controller_address).time_total();
1763                 }
1764             }
1765         }
1766     }
1767 
1768     function sync() public {
1769         // Sync the gauge weight, if applicable
1770         sync_gauge_weights(false);
1771 
1772         if (block.timestamp >= periodFinish) {
1773             retroCatchUp();
1774         }
1775         else {
1776             _updateStoredRewardsAndTime();
1777         }
1778     }
1779 
1780     /* ========== RESTRICTED FUNCTIONS - Curator / migrator callable ========== */
1781     
1782     // ------ FARM SYNCING ------
1783     // In children...
1784 
1785     // ------ PAUSES ------
1786 
1787     function setPauses(
1788         bool _stakingPaused,
1789         bool _withdrawalsPaused,
1790         bool _rewardsCollectionPaused
1791     ) external onlyByOwnGov {
1792         stakingPaused = _stakingPaused;
1793         withdrawalsPaused = _withdrawalsPaused;
1794         rewardsCollectionPaused = _rewardsCollectionPaused;
1795     }
1796 
1797     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
1798     
1799     function unlockStakes() external onlyByOwnGov {
1800         stakesUnlocked = !stakesUnlocked;
1801     }
1802 
1803     function toggleMigrations() external onlyByOwnGov {
1804         migrationsOn = !migrationsOn;
1805     }
1806 
1807     // Adds supported migrator address
1808     function toggleMigrator(address migrator_address) external onlyByOwnGov {
1809         valid_migrators[migrator_address] = !valid_migrators[migrator_address];
1810     }
1811 
1812     // Adds a valid veFXS proxy address
1813     function toggleValidVeFXSProxy(address _proxy_addr) external onlyByOwnGov {
1814         valid_vefxs_proxies[_proxy_addr] = !valid_vefxs_proxies[_proxy_addr];
1815     }
1816 
1817     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
1818     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyTknMgrs(tokenAddress) {
1819         // Check if the desired token is a reward token
1820         bool isRewardToken = false;
1821         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1822             if (rewardTokens[i] == tokenAddress) {
1823                 isRewardToken = true;
1824                 break;
1825             }
1826         }
1827 
1828         // Only the reward managers can take back their reward tokens
1829         // Also, other tokens, like the staking token, airdrops, or accidental deposits, can be withdrawn by the owner
1830         if (
1831                 (isRewardToken && rewardManagers[tokenAddress] == msg.sender)
1832                 || (!isRewardToken && (msg.sender == owner))
1833             ) {
1834             TransferHelper.safeTransfer(tokenAddress, msg.sender, tokenAmount);
1835             return;
1836         }
1837         // If none of the above conditions are true
1838         else {
1839             revert("No valid tokens to recover");
1840         }
1841     }
1842 
1843     function setMiscVariables(
1844         uint256[6] memory _misc_vars
1845         // [0]: uint256 _lock_max_multiplier, 
1846         // [1] uint256 _vefxs_max_multiplier, 
1847         // [2] uint256 _vefxs_per_frax_for_max_boost,
1848         // [3] uint256 _vefxs_boost_scale_factor,
1849         // [4] uint256 _lock_time_for_max_multiplier,
1850         // [5] uint256 _lock_time_min
1851     ) external onlyByOwnGov {
1852         require(_misc_vars[0] >= MULTIPLIER_PRECISION, "Must be >= MUL PREC");
1853         require((_misc_vars[1] >= 0) && (_misc_vars[2] >= 0) && (_misc_vars[3] >= 0), "Must be >= 0");
1854         require((_misc_vars[4] >= 1) && (_misc_vars[5] >= 1), "Must be >= 1");
1855 
1856         lock_max_multiplier = _misc_vars[0];
1857         vefxs_max_multiplier = _misc_vars[1];
1858         vefxs_per_frax_for_max_boost = _misc_vars[2];
1859         vefxs_boost_scale_factor = _misc_vars[3];
1860         lock_time_for_max_multiplier = _misc_vars[4];
1861         lock_time_min = _misc_vars[5];
1862     }
1863 
1864     // The owner or the reward token managers can set reward rates 
1865     function setRewardVars(address reward_token_address, uint256 _new_rate, address _gauge_controller_address, address _rewards_distributor_address) external onlyTknMgrs(reward_token_address) {
1866         rewardRatesManual[rewardTokenAddrToIdx[reward_token_address]] = _new_rate;
1867         gaugeControllers[rewardTokenAddrToIdx[reward_token_address]] = _gauge_controller_address;
1868         rewardDistributors[rewardTokenAddrToIdx[reward_token_address]] = _rewards_distributor_address;
1869     }
1870 
1871     // The owner or the reward token managers can change managers
1872     function changeTokenManager(address reward_token_address, address new_manager_address) external onlyTknMgrs(reward_token_address) {
1873         rewardManagers[reward_token_address] = new_manager_address;
1874     }
1875 
1876     /* ========== A CHICKEN ========== */
1877     //
1878     //         ,~.
1879     //      ,-'__ `-,
1880     //     {,-'  `. }              ,')
1881     //    ,( a )   `-.__         ,',')~,
1882     //   <=.) (         `-.__,==' ' ' '}
1883     //     (   )                      /)
1884     //      `-'\   ,                    )
1885     //          |  \        `~.        /
1886     //          \   `._        \      /
1887     //           \     `._____,'    ,'
1888     //            `-.             ,'
1889     //               `-._     _,-'
1890     //                   77jj'
1891     //                  //_||
1892     //               __//--'/`
1893     //             ,--'/`  '
1894     //
1895     // [hjw] https://textart.io/art/vw6Sa3iwqIRGkZsN1BC2vweF/chicken
1896 }
1897 
1898 
1899 // File contracts/Misc_AMOs/vesper/IVPool.sol
1900 
1901 
1902 interface IVPool {
1903   function DOMAIN_SEPARATOR() external view returns (bytes32);
1904   function MAX_BPS() external view returns (uint256);
1905   function VERSION() external view returns (string memory);
1906   function acceptGovernorship() external;
1907   function addInList(address _listToUpdate, address _addressToAdd) external;
1908   function allowance(address owner, address spender) external view returns (uint256);
1909   function approve(address spender, uint256 amount) external returns (bool);
1910   function availableCreditLimit(address _strategy) external view returns (uint256);
1911   function balanceOf(address account) external view returns (uint256);
1912   function convertFrom18(uint256 _amount) external view returns (uint256);
1913   function decimalConversionFactor() external view returns (uint256);
1914   function decimals() external view returns (uint8);
1915   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
1916   function deposit(uint256 _amount) external;
1917   function depositWithPermit(uint256 _amount, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external;
1918   function excessDebt(address _strategy) external view returns (uint256);
1919   function feeCollector() external view returns (address);
1920   function feeWhitelist() external view returns (address);
1921   function getStrategies() external view returns (address[] memory);
1922   function getWithdrawQueue() external view returns (address[] memory);
1923   function governor() external view returns (address);
1924   function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
1925   function initialize(string memory _name, string memory _symbol, address _token, address _poolAccountant, address _addressListFactory) external;
1926   function keepers() external view returns (address);
1927   function maintainers() external view returns (address);
1928   function migrateStrategy(address _old, address _new) external;
1929   function multiTransfer(address[] memory _recipients, uint256[] memory _amounts) external returns (bool);
1930   function name() external view returns (string memory);
1931   function nonces(address) external view returns (uint256);
1932   function open() external;
1933   function pause() external;
1934   function paused() external view returns (bool);
1935   function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
1936   function poolAccountant() external view returns (address);
1937   function poolRewards() external view returns (address);
1938   function pricePerShare() external view returns (uint256);
1939   function removeFromList(address _listToUpdate, address _addressToRemove) external;
1940   function reportEarning(uint256 _profit, uint256 _loss, uint256 _payback) external;
1941   function reportLoss(uint256 _loss) external;
1942   function shutdown() external;
1943   function stopEverything() external view returns (bool);
1944   function strategy(address _strategy) external view returns (bool _active, uint256 _interestFee, uint256 _debtRate, uint256 _lastRebalance, uint256 _totalDebt, uint256 _totalLoss, uint256 _totalProfit, uint256 _debtRatio);
1945   function sweepERC20(address _fromToken) external;
1946   function symbol() external view returns (string memory);
1947   function token() external view returns (address);
1948   function tokensHere() external view returns (uint256);
1949   function totalDebt() external view returns (uint256);
1950   function totalDebtOf(address _strategy) external view returns (uint256);
1951   function totalDebtRatio() external view returns (uint256);
1952   function totalSupply() external view returns (uint256);
1953   function totalValue() external view returns (uint256);
1954   function transfer(address recipient, uint256 amount) external returns (bool);
1955   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1956   function transferGovernorship(address _proposedGovernor) external;
1957   function unpause() external;
1958   function updateFeeCollector(address _newFeeCollector) external;
1959   function updatePoolRewards(address _newPoolRewards) external;
1960   function updateWithdrawFee(uint256 _newWithdrawFee) external;
1961   function whitelistedWithdraw(uint256 _shares) external;
1962   function withdraw(uint256 _shares) external;
1963   function withdrawFee() external view returns (uint256);
1964 }
1965 
1966 
1967 // File contracts/Staking/FraxUnifiedFarm_ERC20.sol
1968 
1969 // ====================================================================
1970 // |     ______                   _______                             |
1971 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1972 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1973 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1974 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1975 // |                                                                  |
1976 // ====================================================================
1977 // ======================= FraxUnifiedFarm_ERC20 ======================
1978 // ====================================================================
1979 // For ERC20 Tokens
1980 // Uses FraxUnifiedFarmTemplate.sol
1981 
1982 // -------------------- VARIES --------------------
1983 
1984 // G-UNI
1985 // import "../Misc_AMOs/gelato/IGUniPool.sol";
1986 
1987 // mStable
1988 // import '../Misc_AMOs/mstable/IFeederPool.sol';
1989 
1990 // // StakeDAO sdETH-FraxPut
1991 // import '../Misc_AMOs/stakedao/IOpynPerpVault.sol';
1992 
1993 // StakeDAO Vault
1994 // import '../Misc_AMOs/stakedao/IStakeDaoVault.sol';
1995 
1996 // Uniswap V2
1997 // import '../Uniswap/Interfaces/IUniswapV2Pair.sol';
1998 
1999 // Vesper
2000 
2001 // ------------------------------------------------
2002 
2003 contract FraxUnifiedFarm_ERC20 is FraxUnifiedFarmTemplate {
2004 
2005     /* ========== STATE VARIABLES ========== */
2006 
2007     // -------------------- VARIES --------------------
2008 
2009     // G-UNI
2010     // IGUniPool public stakingToken;
2011     
2012     // mStable
2013     // IFeederPool public stakingToken;
2014 
2015     // sdETH-FraxPut Vault
2016     // IOpynPerpVault public stakingToken;
2017 
2018     // StakeDAO Vault
2019     // IStakeDaoVault public stakingToken;
2020 
2021     // Uniswap V2
2022     // IUniswapV2Pair public stakingToken;
2023 
2024     // Vesper
2025     IVPool public stakingToken;
2026 
2027     // ------------------------------------------------
2028 
2029     // Stake tracking
2030     mapping(address => LockedStake[]) public lockedStakes;
2031 
2032     /* ========== STRUCTS ========== */
2033 
2034     // Struct for the stake
2035     struct LockedStake {
2036         bytes32 kek_id;
2037         uint256 start_timestamp;
2038         uint256 liquidity;
2039         uint256 ending_timestamp;
2040         uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
2041     }
2042     
2043     /* ========== CONSTRUCTOR ========== */
2044 
2045     constructor (
2046         address _owner,
2047         address[] memory _rewardTokens,
2048         address[] memory _rewardManagers,
2049         uint256[] memory _rewardRatesManual,
2050         address[] memory _gaugeControllers,
2051         address[] memory _rewardDistributors,
2052         address _stakingToken
2053     ) 
2054     FraxUnifiedFarmTemplate(_owner, _rewardTokens, _rewardManagers, _rewardRatesManual, _gaugeControllers, _rewardDistributors)
2055     {
2056 
2057         // -------------------- VARIES --------------------
2058         // G-UNI
2059         // stakingToken = IGUniPool(_stakingToken);
2060         // address token0 = address(stakingToken.token0());
2061         // frax_is_token0 = token0 == frax_address;
2062 
2063         // mStable
2064         // stakingToken = IFeederPool(_stakingToken);
2065 
2066         // StakeDAO sdETH-FraxPut Vault
2067         // stakingToken = IOpynPerpVault(_stakingToken);
2068 
2069         // StakeDAO Vault
2070         // stakingToken = IStakeDaoVault(_stakingToken);
2071 
2072         // Uniswap V2
2073         // stakingToken = IUniswapV2Pair(_stakingToken);
2074         // address token0 = stakingToken.token0();
2075         // if (token0 == frax_address) frax_is_token0 = true;
2076         // else frax_is_token0 = false;
2077 
2078         // Vesper
2079         stakingToken = IVPool(_stakingToken);
2080 
2081         // ------------------------------------------------
2082 
2083     }
2084 
2085     /* ============= VIEWS ============= */
2086 
2087     // ------ FRAX RELATED ------
2088 
2089     function fraxPerLPToken() public view override returns (uint256) {
2090         // Get the amount of FRAX 'inside' of the lp tokens
2091         uint256 frax_per_lp_token;
2092 
2093         // G-UNI
2094         // ============================================
2095         // {
2096         //     (uint256 reserve0, uint256 reserve1) = stakingToken.getUnderlyingBalances();
2097         //     uint256 total_frax_reserves = frax_is_token0 ? reserve0 : reserve1;
2098 
2099         //     frax_per_lp_token = (total_frax_reserves * 1e18) / stakingToken.totalSupply();
2100         // }
2101 
2102         // mStable
2103         // ============================================
2104         // {
2105         //     uint256 total_frax_reserves;
2106         //     (, IFeederPool.BassetData memory vaultData) = (stakingToken.getBasset(frax_address));
2107         //     total_frax_reserves = uint256(vaultData.vaultBalance);
2108         //     frax_per_lp_token = (total_frax_reserves * 1e18) / stakingToken.totalSupply();
2109         // }
2110 
2111         // StakeDAO sdETH-FraxPut Vault
2112         // ============================================
2113         // {
2114         //    uint256 frax3crv_held = stakingToken.totalUnderlyingControlled();
2115         
2116         //    // Optimistically assume 50/50 FRAX/3CRV ratio in the metapool to save gas
2117         //    frax_per_lp_token = ((frax3crv_held * 1e18) / stakingToken.totalSupply()) / 2;
2118         // }
2119 
2120         // StakeDAO Vault
2121         // ============================================
2122         // {
2123         //    uint256 frax3crv_held = stakingToken.balance();
2124         
2125         //    // Optimistically assume 50/50 FRAX/3CRV ratio in the metapool to save gas
2126         //    frax_per_lp_token = ((frax3crv_held * 1e18) / stakingToken.totalSupply()) / 2;
2127         // }
2128 
2129         // Uniswap V2
2130         // ============================================
2131         // {
2132         //     uint256 total_frax_reserves;
2133         //     (uint256 reserve0, uint256 reserve1, ) = (stakingToken.getReserves());
2134         //     if (frax_is_token0) total_frax_reserves = reserve0;
2135         //     else total_frax_reserves = reserve1;
2136 
2137         //     frax_per_lp_token = (total_frax_reserves * 1e18) / stakingToken.totalSupply();
2138         // }
2139 
2140         // Vesper
2141         // ============================================
2142         frax_per_lp_token = stakingToken.pricePerShare();
2143 
2144         return frax_per_lp_token;
2145     }
2146 
2147     // ------ LIQUIDITY AND WEIGHTS ------
2148 
2149     // Calculated the combined weight for an account
2150     function calcCurCombinedWeight(address account) public override view
2151         returns (
2152             uint256 old_combined_weight,
2153             uint256 new_vefxs_multiplier,
2154             uint256 new_combined_weight
2155         )
2156     {
2157         // Get the old combined weight
2158         old_combined_weight = _combined_weights[account];
2159 
2160         // Get the veFXS multipliers
2161         // For the calculations, use the midpoint (analogous to midpoint Riemann sum)
2162         new_vefxs_multiplier = veFXSMultiplier(account);
2163 
2164         uint256 midpoint_vefxs_multiplier;
2165         if (_locked_liquidity[account] == 0 && _combined_weights[account] == 0) {
2166             // This is only called for the first stake to make sure the veFXS multiplier is not cut in half
2167             midpoint_vefxs_multiplier = new_vefxs_multiplier;
2168         }
2169         else {
2170             midpoint_vefxs_multiplier = (new_vefxs_multiplier + _vefxsMultiplierStored[account]) / 2;
2171         }
2172 
2173         // Loop through the locked stakes, first by getting the liquidity * lock_multiplier portion
2174         new_combined_weight = 0;
2175         for (uint256 i = 0; i < lockedStakes[account].length; i++) {
2176             LockedStake memory thisStake = lockedStakes[account][i];
2177             uint256 lock_multiplier = thisStake.lock_multiplier;
2178 
2179             // If the lock is expired
2180             if (thisStake.ending_timestamp <= block.timestamp) {
2181                 // If the lock expired in the time since the last claim, the weight needs to be proportionately averaged this time
2182                 if (lastRewardClaimTime[account] < thisStake.ending_timestamp){
2183                     uint256 time_before_expiry = thisStake.ending_timestamp - lastRewardClaimTime[account];
2184                     uint256 time_after_expiry = block.timestamp - thisStake.ending_timestamp;
2185 
2186                     // Get the weighted-average lock_multiplier
2187                     uint256 numerator = (lock_multiplier * time_before_expiry) + (MULTIPLIER_PRECISION * time_after_expiry);
2188                     lock_multiplier = numerator / (time_before_expiry + time_after_expiry);
2189                 }
2190                 // Otherwise, it needs to just be 1x
2191                 else {
2192                     lock_multiplier = MULTIPLIER_PRECISION;
2193                 }
2194             }
2195 
2196             uint256 liquidity = thisStake.liquidity;
2197             uint256 combined_boosted_amount = (liquidity * (lock_multiplier + midpoint_vefxs_multiplier)) / MULTIPLIER_PRECISION;
2198             new_combined_weight = new_combined_weight + combined_boosted_amount;
2199         }
2200     }
2201 
2202     // ------ LOCK RELATED ------
2203 
2204     // All the locked stakes for a given account
2205     function lockedStakesOf(address account) external view returns (LockedStake[] memory) {
2206         return lockedStakes[account];
2207     }
2208 
2209     // Returns the length of the locked stakes for a given account
2210     function lockedStakesOfLength(address account) external view returns (uint256) {
2211         return lockedStakes[account].length;
2212     }
2213 
2214     // // All the locked stakes for a given account [old-school method]
2215     // function lockedStakesOfMultiArr(address account) external view returns (
2216     //     bytes32[] memory kek_ids,
2217     //     uint256[] memory start_timestamps,
2218     //     uint256[] memory liquidities,
2219     //     uint256[] memory ending_timestamps,
2220     //     uint256[] memory lock_multipliers
2221     // ) {
2222     //     for (uint256 i = 0; i < lockedStakes[account].length; i++){ 
2223     //         LockedStake memory thisStake = lockedStakes[account][i];
2224     //         kek_ids[i] = thisStake.kek_id;
2225     //         start_timestamps[i] = thisStake.start_timestamp;
2226     //         liquidities[i] = thisStake.liquidity;
2227     //         ending_timestamps[i] = thisStake.ending_timestamp;
2228     //         lock_multipliers[i] = thisStake.lock_multiplier;
2229     //     }
2230     // }
2231 
2232     /* =============== MUTATIVE FUNCTIONS =============== */
2233 
2234     // ------ STAKING ------
2235 
2236     function _getStake(address staker_address, bytes32 kek_id) internal view returns (LockedStake memory locked_stake, uint256 arr_idx) {
2237         for (uint256 i = 0; i < lockedStakes[staker_address].length; i++){ 
2238             if (kek_id == lockedStakes[staker_address][i].kek_id){
2239                 locked_stake = lockedStakes[staker_address][i];
2240                 arr_idx = i;
2241                 break;
2242             }
2243         }
2244         require(locked_stake.kek_id == kek_id, "Stake not found");
2245         
2246     }
2247 
2248     // Add additional LPs to an existing locked stake
2249     function lockAdditional(bytes32 kek_id, uint256 addl_liq) updateRewardAndBalance(msg.sender, true) public {
2250         // Get the stake and its index
2251         (LockedStake memory thisStake, uint256 theArrayIndex) = _getStake(msg.sender, kek_id);
2252 
2253         // Calculate the new amount
2254         uint256 new_amt = thisStake.liquidity + addl_liq;
2255 
2256         // Checks
2257         require(addl_liq >= 0, "Must be nonzero");
2258 
2259         // Pull the tokens from the sender
2260         TransferHelper.safeTransferFrom(address(stakingToken), msg.sender, address(this), addl_liq);
2261 
2262         // Update the stake
2263         lockedStakes[msg.sender][theArrayIndex] = LockedStake(
2264             kek_id,
2265             thisStake.start_timestamp,
2266             new_amt,
2267             thisStake.ending_timestamp,
2268             thisStake.lock_multiplier
2269         );
2270 
2271         // Update liquidities
2272         _total_liquidity_locked += addl_liq;
2273         _locked_liquidity[msg.sender] += addl_liq;
2274         {
2275             address the_proxy = staker_designated_proxies[msg.sender];
2276             if (the_proxy != address(0)) proxy_lp_balances[the_proxy] += addl_liq;
2277         }
2278 
2279         // Need to call to update the combined weights
2280         _updateRewardAndBalance(msg.sender, false);
2281     }
2282 
2283     // Two different stake functions are needed because of delegateCall and msg.sender issues (important for migration)
2284     function stakeLocked(uint256 liquidity, uint256 secs) nonReentrant external {
2285         _stakeLocked(msg.sender, msg.sender, liquidity, secs, block.timestamp);
2286     }
2287 
2288     function _stakeLockedInternalLogic(
2289         address source_address,
2290         uint256 liquidity
2291     ) internal virtual {
2292         revert("Need _stakeLockedInternalLogic logic");
2293     }
2294 
2295     // If this were not internal, and source_address had an infinite approve, this could be exploitable
2296     // (pull funds from source_address and stake for an arbitrary staker_address)
2297     function _stakeLocked(
2298         address staker_address,
2299         address source_address,
2300         uint256 liquidity,
2301         uint256 secs,
2302         uint256 start_timestamp
2303     ) internal updateRewardAndBalance(staker_address, true) {
2304         require(stakingPaused == false || valid_migrators[msg.sender] == true, "Staking paused or in migration");
2305         require(secs >= lock_time_min, "Minimum stake time not met");
2306         require(secs <= lock_time_for_max_multiplier,"Trying to lock for too long");
2307 
2308         // Pull in the required token(s)
2309         // Varies per farm
2310         TransferHelper.safeTransferFrom(address(stakingToken), source_address, address(this), liquidity);
2311 
2312         // Get the lock multiplier and kek_id
2313         uint256 lock_multiplier = lockMultiplier(secs);
2314         bytes32 kek_id = keccak256(abi.encodePacked(staker_address, start_timestamp, liquidity, _locked_liquidity[staker_address]));
2315         
2316         // Create the locked stake
2317         lockedStakes[staker_address].push(LockedStake(
2318             kek_id,
2319             start_timestamp,
2320             liquidity,
2321             start_timestamp + secs,
2322             lock_multiplier
2323         ));
2324 
2325         // Update liquidities
2326         _total_liquidity_locked += liquidity;
2327         _locked_liquidity[staker_address] += liquidity;
2328         {
2329             address the_proxy = staker_designated_proxies[staker_address];
2330             if (the_proxy != address(0)) proxy_lp_balances[the_proxy] += liquidity;
2331         }
2332         
2333         // Need to call again to make sure everything is correct
2334         _updateRewardAndBalance(staker_address, false);
2335 
2336         emit StakeLocked(staker_address, liquidity, secs, kek_id, source_address);
2337     }
2338 
2339     // ------ WITHDRAWING ------
2340 
2341     // Two different withdrawLocked functions are needed because of delegateCall and msg.sender issues (important for migration)
2342     function withdrawLocked(bytes32 kek_id, address destination_address) nonReentrant external {
2343         require(withdrawalsPaused == false, "Withdrawals paused");
2344         _withdrawLocked(msg.sender, destination_address, kek_id);
2345     }
2346 
2347     // No withdrawer == msg.sender check needed since this is only internally callable and the checks are done in the wrapper
2348     // functions like migrator_withdraw_locked() and withdrawLocked()
2349     function _withdrawLocked(
2350         address staker_address,
2351         address destination_address,
2352         bytes32 kek_id
2353     ) internal {
2354         // Collect rewards first and then update the balances
2355         _getReward(staker_address, destination_address);
2356 
2357         // Get the stake and its index
2358         (LockedStake memory thisStake, uint256 theArrayIndex) = _getStake(staker_address, kek_id);
2359         require(block.timestamp >= thisStake.ending_timestamp || stakesUnlocked == true || valid_migrators[msg.sender] == true, "Stake is still locked!");
2360         uint256 liquidity = thisStake.liquidity;
2361 
2362         if (liquidity > 0) {
2363             // Update liquidities
2364             _total_liquidity_locked = _total_liquidity_locked - liquidity;
2365             _locked_liquidity[staker_address] = _locked_liquidity[staker_address] - liquidity;
2366             {
2367                 address the_proxy = staker_designated_proxies[staker_address];
2368                 if (the_proxy != address(0)) proxy_lp_balances[the_proxy] -= liquidity;
2369             }
2370 
2371             // Remove the stake from the array
2372             delete lockedStakes[staker_address][theArrayIndex];
2373 
2374             // Give the tokens to the destination_address
2375             // Should throw if insufficient balance
2376             stakingToken.transfer(destination_address, liquidity);
2377 
2378             // Need to call again to make sure everything is correct
2379             _updateRewardAndBalance(staker_address, false);
2380 
2381             emit WithdrawLocked(staker_address, liquidity, kek_id, destination_address);
2382         }
2383     }
2384 
2385 
2386     function _getRewardExtraLogic(address rewardee, address destination_address) internal override {
2387         // Do nothing
2388     }
2389 
2390      /* ========== RESTRICTED FUNCTIONS - Curator / migrator callable ========== */
2391 
2392     // Migrator can stake for someone else (they won't be able to withdraw it back though, only staker_address can). 
2393     function migrator_stakeLocked_for(address staker_address, uint256 amount, uint256 secs, uint256 start_timestamp) external isMigrating {
2394         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
2395         _stakeLocked(staker_address, msg.sender, amount, secs, start_timestamp);
2396     }
2397 
2398     // Used for migrations
2399     function migrator_withdraw_locked(address staker_address, bytes32 kek_id) external isMigrating {
2400         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
2401         _withdrawLocked(staker_address, msg.sender, kek_id);
2402     }
2403     
2404     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
2405 
2406     // Inherited...
2407 
2408     /* ========== EVENTS ========== */
2409 
2410     event StakeLocked(address indexed user, uint256 amount, uint256 secs, bytes32 kek_id, address source_address);
2411     event WithdrawLocked(address indexed user, uint256 liquidity, bytes32 kek_id, address destination_address);
2412 }
2413 
2414 
2415 // File contracts/Staking/Variants/FraxUnifiedFarm_ERC20_Vesper_Orbit_FRAX.sol
2416 
2417 contract FraxUnifiedFarm_ERC20_Vesper_Orbit_FRAX is FraxUnifiedFarm_ERC20 {
2418     constructor (
2419         address _owner,
2420         address[] memory _rewardTokens,
2421         address[] memory _rewardManagers,
2422         uint256[] memory _rewardRates,
2423         address[] memory _gaugeControllers,
2424         address[] memory _rewardDistributors,
2425         address _stakingToken 
2426     ) 
2427     FraxUnifiedFarm_ERC20(_owner , _rewardTokens, _rewardManagers, _rewardRates, _gaugeControllers, _rewardDistributors, _stakingToken)
2428     {}
2429 }