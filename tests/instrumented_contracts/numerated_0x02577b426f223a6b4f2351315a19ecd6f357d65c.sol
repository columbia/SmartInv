1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.9.3 https://hardhat.org
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
1206 // File contracts/Misc_AMOs/Lending_AMOs/aave/IAaveIncentivesControllerPartial.sol
1207 
1208 
1209 
1210 interface IAaveIncentivesControllerPartial {
1211     /**
1212     * @dev Returns the total of rewards of an user, already accrued + not yet accrued
1213     * @param user The address of the user
1214     * @return The rewards
1215     **/
1216     function getRewardsBalance(address[] calldata assets, address user)
1217       external
1218       view
1219       returns (uint256);
1220 
1221     /**
1222     * @dev Claims reward for an user, on all the assets of the lending pool, accumulating the pending rewards
1223     * @param amount Amount of rewards to claim
1224     * @param to Address that will be receiving the rewards
1225     * @return Rewards claimed
1226     **/
1227     function claimRewards(
1228       address[] calldata assets,
1229       uint256 amount,
1230       address to
1231     ) external returns (uint256);
1232 
1233     /**
1234     * @dev Claims reward for an user on behalf, on all the assets of the lending pool, accumulating the pending rewards. The caller must
1235     * be whitelisted via "allowClaimOnBehalf" function by the RewardsAdmin role manager
1236     * @param amount Amount of rewards to claim
1237     * @param user Address to check and claim rewards
1238     * @param to Address that will be receiving the rewards
1239     * @return Rewards claimed
1240     **/
1241     function claimRewardsOnBehalf(
1242       address[] calldata assets,
1243       uint256 amount,
1244       address user,
1245       address to
1246     ) external returns (uint256);
1247 
1248     /**
1249     * @dev returns the unclaimed rewards of the user
1250     * @param user the address of the user
1251     * @return the unclaimed user rewards
1252     */
1253     function getUserUnclaimedRewards(address user) external view returns (uint256);
1254 
1255     /**
1256     * @dev for backward compatibility with previous implementation of the Incentives controller
1257     */
1258     function REWARD_TOKEN() external view returns (address);
1259 }
1260 
1261 
1262 // File contracts/Staking/FraxUnifiedFarmTemplate.sol
1263 
1264 pragma experimental ABIEncoderV2;
1265 
1266 // ====================================================================
1267 // |     ______                   _______                             |
1268 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1269 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1270 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1271 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1272 // |                                                                  |
1273 // ====================================================================
1274 // ====================== FraxUnifiedFarmTemplate =====================
1275 // ====================================================================
1276 // Migratable Farming contract that accounts for veFXS
1277 // Overrideable for UniV3, ERC20s, etc
1278 // New for V2
1279 //      - Multiple reward tokens possible
1280 //      - Can add to existing locked stakes
1281 //      - Contract is aware of proxied veFXS
1282 //      - veFXS multiplier formula changed
1283 // Apes together strong
1284 
1285 // Frax Finance: https://github.com/FraxFinance
1286 
1287 // Primary Author(s)
1288 // Travis Moore: https://github.com/FortisFortuna
1289 
1290 // Reviewer(s) / Contributor(s)
1291 // Jason Huan: https://github.com/jasonhuan
1292 // Sam Kazemian: https://github.com/samkazemian
1293 // Dennis: github.com/denett
1294 // Sam Sun: https://github.com/samczsun
1295 
1296 // Originally inspired by Synthetix.io, but heavily modified by the Frax team
1297 // (Locked, veFXS, and UniV3 portions are new)
1298 // https://raw.githubusercontent.com/Synthetixio/synthetix/develop/contracts/StakingRewards.sol
1299 
1300 
1301 
1302 
1303 
1304 
1305 
1306 
1307 
1308 // Extra rewards
1309 
1310 contract FraxUnifiedFarmTemplate is Owned, ReentrancyGuard {
1311     using SafeERC20 for ERC20;
1312 
1313     /* ========== STATE VARIABLES ========== */
1314 
1315     // Instances
1316     IveFXS private veFXS = IveFXS(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0);
1317     
1318     // Frax related
1319     address internal constant frax_address = 0x853d955aCEf822Db058eb8505911ED77F175b99e;
1320     bool internal frax_is_token0;
1321     uint256 public fraxPerLPStored;
1322 
1323     // Constant for various precisions
1324     uint256 internal constant MULTIPLIER_PRECISION = 1e18;
1325 
1326     // Time tracking
1327     uint256 public periodFinish;
1328     uint256 public lastUpdateTime;
1329 
1330     // Lock time and multiplier settings
1331     uint256 public lock_max_multiplier = uint256(3e18); // E18. 1x = e18
1332     uint256 public lock_time_for_max_multiplier = 3 * 365 * 86400; // 3 years
1333     // uint256 public lock_time_for_max_multiplier = 2 * 86400; // 2 days
1334     uint256 public lock_time_min = 86400; // 1 * 86400  (1 day)
1335 
1336     // veFXS related
1337     uint256 public vefxs_boost_scale_factor = uint256(4e18); // E18. 4x = 4e18; 100 / scale_factor = % vefxs supply needed for max boost
1338     uint256 public vefxs_max_multiplier = uint256(2e18); // E18. 1x = 1e18
1339     uint256 public vefxs_per_frax_for_max_boost = uint256(2e18); // E18. 2e18 means 2 veFXS must be held by the staker per 1 FRAX
1340     mapping(address => uint256) internal _vefxsMultiplierStored;
1341     mapping(address => bool) internal valid_vefxs_proxies;
1342     mapping(address => mapping(address => bool)) internal proxy_allowed_stakers;
1343 
1344     // Reward addresses, gauge addresses, reward rates, and reward managers
1345     mapping(address => address) public rewardManagers; // token addr -> manager addr
1346     address[] internal rewardTokens;
1347     address[] internal gaugeControllers;
1348     address[] internal rewardDistributors;
1349     uint256[] internal rewardRatesManual;
1350     mapping(address => uint256) public rewardTokenAddrToIdx; // token addr -> token index
1351     
1352     // Reward period
1353     uint256 public constant rewardsDuration = 604800; // 7 * 86400  (7 days)
1354 
1355     // Reward tracking
1356     uint256[] private rewardsPerTokenStored;
1357     mapping(address => mapping(uint256 => uint256)) private userRewardsPerTokenPaid; // staker addr -> token id -> paid amount
1358     mapping(address => mapping(uint256 => uint256)) private rewards; // staker addr -> token id -> reward amount
1359     mapping(address => uint256) internal lastRewardClaimTime; // staker addr -> timestamp
1360     
1361     // Gauge tracking
1362     uint256[] private last_gauge_relative_weights;
1363     uint256[] private last_gauge_time_totals;
1364 
1365     // Balance tracking
1366     uint256 internal _total_liquidity_locked;
1367     uint256 internal _total_combined_weight;
1368     mapping(address => uint256) internal _locked_liquidity;
1369     mapping(address => uint256) internal _combined_weights;
1370     mapping(address => uint256) public proxy_lp_balances; // Keeps track of LP balances proxy-wide. Needed to make sure the proxy boost is kept in line
1371 
1372     // List of valid migrators (set by governance)
1373     mapping(address => bool) internal valid_migrators;
1374 
1375     // Stakers set which migrator(s) they want to use
1376     mapping(address => mapping(address => bool)) internal staker_allowed_migrators;
1377     mapping(address => address) public staker_designated_proxies; // Keep public so users can see on the frontend if they have a proxy
1378 
1379     // Admin booleans for emergencies, migrations, and overrides
1380     bool public stakesUnlocked; // Release locked stakes in case of emergency
1381     bool internal migrationsOn; // Used for migrations. Prevents new stakes, but allows LP and reward withdrawals
1382     bool internal withdrawalsPaused; // For emergencies
1383     bool internal rewardsCollectionPaused; // For emergencies
1384     bool internal stakingPaused; // For emergencies
1385 
1386     /* ========== STRUCTS ========== */
1387     // In children...
1388 
1389 
1390     /* ========== MODIFIERS ========== */
1391 
1392     modifier onlyByOwnGov() {
1393         require(msg.sender == owner || msg.sender == 0x8412ebf45bAC1B340BbE8F318b928C466c4E39CA, "Not owner or timelock");
1394         _;
1395     }
1396 
1397     modifier onlyTknMgrs(address reward_token_address) {
1398         require(msg.sender == owner || isTokenManagerFor(msg.sender, reward_token_address), "Not owner or tkn mgr");
1399         _;
1400     }
1401 
1402     modifier isMigrating() {
1403         require(migrationsOn == true, "Not in migration");
1404         _;
1405     }
1406 
1407     modifier updateRewardAndBalance(address account, bool sync_too) {
1408         _updateRewardAndBalance(account, sync_too);
1409         _;
1410     }
1411 
1412     /* ========== CONSTRUCTOR ========== */
1413 
1414     constructor (
1415         address _owner,
1416         address[] memory _rewardTokens,
1417         address[] memory _rewardManagers,
1418         uint256[] memory _rewardRatesManual,
1419         address[] memory _gaugeControllers,
1420         address[] memory _rewardDistributors
1421     ) Owned(_owner) {
1422 
1423         // Address arrays
1424         rewardTokens = _rewardTokens;
1425         gaugeControllers = _gaugeControllers;
1426         rewardDistributors = _rewardDistributors;
1427         rewardRatesManual = _rewardRatesManual;
1428 
1429         for (uint256 i = 0; i < _rewardTokens.length; i++){ 
1430             // For fast token address -> token ID lookups later
1431             rewardTokenAddrToIdx[_rewardTokens[i]] = i;
1432 
1433             // Initialize the stored rewards
1434             rewardsPerTokenStored.push(0);
1435 
1436             // Initialize the reward managers
1437             rewardManagers[_rewardTokens[i]] = _rewardManagers[i];
1438 
1439             // Push in empty relative weights to initialize the array
1440             last_gauge_relative_weights.push(0);
1441 
1442             // Push in empty time totals to initialize the array
1443             last_gauge_time_totals.push(0);
1444         }
1445 
1446         // Other booleans
1447         stakesUnlocked = false;
1448 
1449         // Initialization
1450         lastUpdateTime = block.timestamp;
1451         periodFinish = block.timestamp + rewardsDuration;
1452     }
1453 
1454     /* ============= VIEWS ============= */
1455 
1456     // ------ REWARD RELATED ------
1457 
1458     // See if the caller_addr is a manager for the reward token 
1459     function isTokenManagerFor(address caller_addr, address reward_token_addr) public view returns (bool){
1460         if (caller_addr == owner) return true; // Contract owner
1461         else if (rewardManagers[reward_token_addr] == caller_addr) return true; // Reward manager
1462         return false; 
1463     }
1464 
1465     // All the reward tokens
1466     function getAllRewardTokens() external view returns (address[] memory) {
1467         return rewardTokens;
1468     }
1469 
1470     // Last time the reward was applicable
1471     function lastTimeRewardApplicable() internal view returns (uint256) {
1472         return Math.min(block.timestamp, periodFinish);
1473     }
1474 
1475     function rewardRates(uint256 token_idx) public view returns (uint256 rwd_rate) {
1476         address gauge_controller_address = gaugeControllers[token_idx];
1477         if (gauge_controller_address != address(0)) {
1478             rwd_rate = (IFraxGaugeController(gauge_controller_address).global_emission_rate() * last_gauge_relative_weights[token_idx]) / 1e18;
1479         }
1480         else {
1481             rwd_rate = rewardRatesManual[token_idx];
1482         }
1483     }
1484 
1485     // Amount of reward tokens per LP token / liquidity unit
1486     function rewardsPerToken() public view returns (uint256[] memory newRewardsPerTokenStored) {
1487         if (_total_liquidity_locked == 0 || _total_combined_weight == 0) {
1488             return rewardsPerTokenStored;
1489         }
1490         else {
1491             newRewardsPerTokenStored = new uint256[](rewardTokens.length);
1492             for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
1493                 newRewardsPerTokenStored[i] = rewardsPerTokenStored[i] + (
1494                     ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRates(i) * 1e18) / _total_combined_weight
1495                 );
1496             }
1497             return newRewardsPerTokenStored;
1498         }
1499     }
1500 
1501     // Amount of reward tokens an account has earned / accrued
1502     // Note: In the edge-case of one of the account's stake expiring since the last claim, this will
1503     // return a slightly inflated number
1504     function earned(address account) public view returns (uint256[] memory new_earned) {
1505         uint256[] memory reward_arr = rewardsPerToken();
1506         new_earned = new uint256[](rewardTokens.length);
1507 
1508         if (_combined_weights[account] > 0){
1509             for (uint256 i = 0; i < rewardTokens.length; i++){ 
1510                 new_earned[i] = ((_combined_weights[account] * (reward_arr[i] - userRewardsPerTokenPaid[account][i])) / 1e18)
1511                                 + rewards[account][i];
1512             }
1513         }
1514     }
1515 
1516     // Total reward tokens emitted in the given period
1517     function getRewardForDuration() external view returns (uint256[] memory rewards_per_duration_arr) {
1518         rewards_per_duration_arr = new uint256[](rewardRatesManual.length);
1519 
1520         for (uint256 i = 0; i < rewardRatesManual.length; i++){ 
1521             rewards_per_duration_arr[i] = rewardRates(i) * rewardsDuration;
1522         }
1523     }
1524 
1525 
1526     // ------ LIQUIDITY AND WEIGHTS ------
1527 
1528     // User locked liquidity / LP tokens
1529     function totalLiquidityLocked() external view returns (uint256) {
1530         return _total_liquidity_locked;
1531     }
1532 
1533     // Total locked liquidity / LP tokens
1534     function lockedLiquidityOf(address account) external view returns (uint256) {
1535         return _locked_liquidity[account];
1536     }
1537 
1538     // Total combined weight
1539     function totalCombinedWeight() external view returns (uint256) {
1540         return _total_combined_weight;
1541     }
1542 
1543     // Total 'balance' used for calculating the percent of the pool the account owns
1544     // Takes into account the locked stake time multiplier and veFXS multiplier
1545     function combinedWeightOf(address account) external view returns (uint256) {
1546         return _combined_weights[account];
1547     }
1548 
1549     // Calculated the combined weight for an account
1550     function calcCurCombinedWeight(address account) public virtual view 
1551         returns (
1552             uint256 old_combined_weight,
1553             uint256 new_vefxs_multiplier,
1554             uint256 new_combined_weight
1555         )
1556     {
1557         revert("Need cCCW logic");
1558     }
1559 
1560     // ------ LOCK RELATED ------
1561 
1562     // Multiplier amount, given the length of the lock
1563     function lockMultiplier(uint256 secs) public view returns (uint256) {
1564         return Math.min(
1565             lock_max_multiplier,
1566             uint256(MULTIPLIER_PRECISION) + (
1567                 (secs * (lock_max_multiplier - MULTIPLIER_PRECISION)) / lock_time_for_max_multiplier
1568             )
1569         ) ;
1570     }
1571 
1572     // ------ FRAX RELATED ------
1573 
1574     function userStakedFrax(address account) public view returns (uint256) {
1575         return (fraxPerLPStored * _locked_liquidity[account]) / MULTIPLIER_PRECISION;
1576     }
1577 
1578     function proxyStakedFrax(address proxy_address) public view returns (uint256) {
1579         return (fraxPerLPStored * proxy_lp_balances[proxy_address]) / MULTIPLIER_PRECISION;
1580     }
1581 
1582     // Max LP that can get max veFXS boosted for a given address at its current veFXS balance
1583     function maxLPForMaxBoost(address account) external view returns (uint256) {
1584         return (veFXS.balanceOf(account) * MULTIPLIER_PRECISION * MULTIPLIER_PRECISION) / (vefxs_per_frax_for_max_boost * fraxPerLPStored);
1585     }
1586 
1587     // Meant to be overridden
1588     function fraxPerLPToken() public virtual view returns (uint256) {
1589         revert("Need fPLPT logic");
1590     }
1591 
1592     // ------ veFXS RELATED ------
1593 
1594     function minVeFXSForMaxBoost(address account) public view returns (uint256) {
1595         return (userStakedFrax(account) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
1596     }
1597 
1598     function minVeFXSForMaxBoostProxy(address proxy_address) public view returns (uint256) {
1599         return (proxyStakedFrax(proxy_address) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
1600     }
1601 
1602     function getProxyFor(address addr) public view returns (address){
1603         if (valid_vefxs_proxies[addr]) {
1604             // If addr itself is a proxy, return that.
1605             // If it farms itself directly, it should use the shared LP tally in proxyStakedFrax
1606             return addr;
1607         }
1608         else {
1609             // Otherwise, return the proxy, or address(0)
1610             return staker_designated_proxies[addr];
1611         }
1612     }
1613 
1614     function veFXSMultiplier(address account) public view returns (uint256 vefxs_multiplier) {
1615         // Use either the user's or their proxy's veFXS balance
1616         uint256 vefxs_bal_to_use = 0;
1617         address the_proxy = getProxyFor(account);
1618         vefxs_bal_to_use = (the_proxy == address(0)) ? veFXS.balanceOf(account) : veFXS.balanceOf(the_proxy);
1619 
1620         // First option based on fraction of total veFXS supply, with an added scale factor
1621         uint256 mult_optn_1 = (vefxs_bal_to_use * vefxs_max_multiplier * vefxs_boost_scale_factor) 
1622                             / (veFXS.totalSupply() * MULTIPLIER_PRECISION);
1623         
1624         // Second based on old method, where the amount of FRAX staked comes into play
1625         uint256 mult_optn_2;
1626         {
1627             uint256 veFXS_needed_for_max_boost;
1628 
1629             // Need to use proxy-wide FRAX balance if applicable, to prevent exploiting
1630             veFXS_needed_for_max_boost = (the_proxy == address(0)) ? minVeFXSForMaxBoost(account) : minVeFXSForMaxBoostProxy(the_proxy);
1631 
1632             if (veFXS_needed_for_max_boost > 0){ 
1633                 uint256 user_vefxs_fraction = (vefxs_bal_to_use * MULTIPLIER_PRECISION) / veFXS_needed_for_max_boost;
1634                 
1635                 mult_optn_2 = (user_vefxs_fraction * vefxs_max_multiplier) / MULTIPLIER_PRECISION;
1636             }
1637             else mult_optn_2 = 0; // This will happen with the first stake, when user_staked_frax is 0
1638         }
1639 
1640         // Select the higher of the two
1641         vefxs_multiplier = (mult_optn_1 > mult_optn_2 ? mult_optn_1 : mult_optn_2);
1642 
1643         // Cap the boost to the vefxs_max_multiplier
1644         if (vefxs_multiplier > vefxs_max_multiplier) vefxs_multiplier = vefxs_max_multiplier;
1645     }
1646 
1647     /* =============== MUTATIVE FUNCTIONS =============== */
1648 
1649     // ------ MIGRATIONS ------
1650 
1651     // Staker can allow a migrator 
1652     function stakerToggleMigrator(address migrator_address) external {
1653         require(valid_migrators[migrator_address], "Invalid migrator address");
1654         staker_allowed_migrators[msg.sender][migrator_address] = !staker_allowed_migrators[msg.sender][migrator_address]; 
1655     }
1656 
1657     // Proxy can allow a staker to use their veFXS balance (the staker will have to reciprocally toggle them too)
1658     // Must come before stakerSetVeFXSProxy
1659     function proxyToggleStaker(address staker_address) external {
1660         require(valid_vefxs_proxies[msg.sender], "Invalid proxy");
1661         proxy_allowed_stakers[msg.sender][staker_address] = !proxy_allowed_stakers[msg.sender][staker_address]; 
1662 
1663         // Disable the staker's set proxy if it was the toggler and is currently on
1664         if (staker_designated_proxies[staker_address] == msg.sender){
1665             staker_designated_proxies[staker_address] = address(0); 
1666 
1667             // Remove the LP as well
1668             proxy_lp_balances[msg.sender] -= _locked_liquidity[staker_address];
1669         }
1670     }
1671 
1672     // Staker can allow a veFXS proxy (the proxy will have to toggle them first)
1673     function stakerSetVeFXSProxy(address proxy_address) external {
1674         require(valid_vefxs_proxies[proxy_address], "Invalid proxy");
1675         require(proxy_allowed_stakers[proxy_address][msg.sender], "Proxy has not allowed you yet");
1676         staker_designated_proxies[msg.sender] = proxy_address; 
1677 
1678         // Add the the LP as well
1679         proxy_lp_balances[proxy_address] += _locked_liquidity[msg.sender];
1680     }
1681 
1682     // ------ STAKING ------
1683     // In children...
1684 
1685 
1686     // ------ WITHDRAWING ------
1687     // In children...
1688 
1689 
1690     // ------ REWARDS SYNCING ------
1691 
1692     function _updateRewardAndBalance(address account, bool sync_too) internal {
1693         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
1694         if (sync_too){
1695             sync();
1696         }
1697         
1698         if (account != address(0)) {
1699             // To keep the math correct, the user's combined weight must be recomputed to account for their
1700             // ever-changing veFXS balance.
1701             (   
1702                 uint256 old_combined_weight,
1703                 uint256 new_vefxs_multiplier,
1704                 uint256 new_combined_weight
1705             ) = calcCurCombinedWeight(account);
1706 
1707             // Calculate the earnings first
1708             _syncEarned(account);
1709 
1710             // Update the user's stored veFXS multipliers
1711             _vefxsMultiplierStored[account] = new_vefxs_multiplier;
1712 
1713             // Update the user's and the global combined weights
1714             if (new_combined_weight >= old_combined_weight) {
1715                 uint256 weight_diff = new_combined_weight - old_combined_weight;
1716                 _total_combined_weight = _total_combined_weight + weight_diff;
1717                 _combined_weights[account] = old_combined_weight + weight_diff;
1718             } else {
1719                 uint256 weight_diff = old_combined_weight - new_combined_weight;
1720                 _total_combined_weight = _total_combined_weight - weight_diff;
1721                 _combined_weights[account] = old_combined_weight - weight_diff;
1722             }
1723 
1724         }
1725     }
1726 
1727     function _syncEarned(address account) internal {
1728         if (account != address(0)) {
1729             // Calculate the earnings
1730             uint256[] memory earned_arr = earned(account);
1731 
1732             // Update the rewards array
1733             for (uint256 i = 0; i < earned_arr.length; i++){ 
1734                 rewards[account][i] = earned_arr[i];
1735             }
1736 
1737             // Update the rewards paid array
1738             for (uint256 i = 0; i < earned_arr.length; i++){ 
1739                 userRewardsPerTokenPaid[account][i] = rewardsPerTokenStored[i];
1740             }
1741         }
1742     }
1743 
1744 
1745     // ------ REWARDS CLAIMING ------
1746 
1747     function getRewardExtraLogic(address destination_address) public nonReentrant {
1748         require(rewardsCollectionPaused == false, "Rewards collection paused");
1749         return _getRewardExtraLogic(msg.sender, destination_address);
1750     }
1751 
1752     function _getRewardExtraLogic(address rewardee, address destination_address) internal virtual {
1753         revert("Need gREL logic");
1754     }
1755 
1756     // Two different getReward functions are needed because of delegateCall and msg.sender issues
1757     // For backwards-compatibility
1758     function getReward(address destination_address) external nonReentrant returns (uint256[] memory) {
1759         return _getReward(msg.sender, destination_address, true);
1760     }
1761 
1762     function getReward2(address destination_address, bool claim_extra_too) external nonReentrant returns (uint256[] memory) {
1763         return _getReward(msg.sender, destination_address, claim_extra_too);
1764     }
1765 
1766     // No withdrawer == msg.sender check needed since this is only internally callable
1767     function _getReward(address rewardee, address destination_address, bool do_extra_logic) internal updateRewardAndBalance(rewardee, true) returns (uint256[] memory rewards_before) {
1768         // Make sure rewards collection isn't paused
1769         require(rewardsCollectionPaused == false, "Rewards collection paused");
1770         
1771         // Update the rewards array and distribute rewards
1772         rewards_before = new uint256[](rewardTokens.length);
1773 
1774         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1775             rewards_before[i] = rewards[rewardee][i];
1776             rewards[rewardee][i] = 0;
1777             if (rewards_before[i] > 0) TransferHelper.safeTransfer(rewardTokens[i], destination_address, rewards_before[i]);
1778         }
1779 
1780         // Handle additional reward logic
1781         if (do_extra_logic) {
1782             _getRewardExtraLogic(rewardee, destination_address);
1783         }
1784 
1785         // Update the last reward claim time
1786         lastRewardClaimTime[rewardee] = block.timestamp;
1787     }
1788 
1789 
1790     // ------ FARM SYNCING ------
1791 
1792     // If the period expired, renew it
1793     function retroCatchUp() internal {
1794         // Pull in rewards from the rewards distributor, if applicable
1795         for (uint256 i = 0; i < rewardDistributors.length; i++){ 
1796             address reward_distributor_address = rewardDistributors[i];
1797             if (reward_distributor_address != address(0)) {
1798                 IFraxGaugeFXSRewardsDistributor(reward_distributor_address).distributeReward(address(this));
1799             }
1800         }
1801 
1802         // Ensure the provided reward amount is not more than the balance in the contract.
1803         // This keeps the reward rate in the right range, preventing overflows due to
1804         // very high values of rewardRate in the earned and rewardsPerToken functions;
1805         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1806         uint256 num_periods_elapsed = uint256(block.timestamp - periodFinish) / rewardsDuration; // Floor division to the nearest period
1807         
1808         // Make sure there are enough tokens to renew the reward period
1809         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1810             require((rewardRates(i) * rewardsDuration * (num_periods_elapsed + 1)) <= ERC20(rewardTokens[i]).balanceOf(address(this)), string(abi.encodePacked("Not enough reward tokens available: ", rewardTokens[i])) );
1811         }
1812         
1813         // uint256 old_lastUpdateTime = lastUpdateTime;
1814         // uint256 new_lastUpdateTime = block.timestamp;
1815 
1816         // lastUpdateTime = periodFinish;
1817         periodFinish = periodFinish + ((num_periods_elapsed + 1) * rewardsDuration);
1818 
1819         // Update the rewards and time
1820         _updateStoredRewardsAndTime();
1821 
1822         // Update the fraxPerLPStored
1823         fraxPerLPStored = fraxPerLPToken();
1824 
1825         // Pull in rewards and set the reward rate for one week, based off of that
1826         // If the stkAAVE rewards get messed up for some reason, set this to 0 and it will skip
1827         if (rewardRatesManual[1] != 0) {
1828             // Aave aFRAX
1829             // ====================================
1830             address[] memory the_assets = new address[](1);
1831             the_assets[0] = 0xd4937682df3C8aEF4FE912A96A74121C0829E664; // aFRAX
1832             uint256 stkaave_recd = IAaveIncentivesControllerPartial(0xd784927Ff2f95ba542BfC824c8a8a98F3495f6b5).claimRewards(
1833                 the_assets,
1834                 115792089237316195423570985008687907853269984665640564039457584007913129639935,
1835                 address(this)
1836             );
1837             rewardRatesManual[1] = stkaave_recd / rewardsDuration;
1838         }
1839 
1840 
1841     }
1842 
1843     function _updateStoredRewardsAndTime() internal {
1844         // Get the rewards
1845         uint256[] memory rewards_per_token = rewardsPerToken();
1846 
1847         // Update the rewardsPerTokenStored
1848         for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
1849             rewardsPerTokenStored[i] = rewards_per_token[i];
1850         }
1851 
1852         // Update the last stored time
1853         lastUpdateTime = lastTimeRewardApplicable();
1854     }
1855 
1856     function sync_gauge_weights(bool force_update) public {
1857         // Loop through the gauge controllers
1858         for (uint256 i = 0; i < gaugeControllers.length; i++){ 
1859             address gauge_controller_address = gaugeControllers[i];
1860             if (gauge_controller_address != address(0)) {
1861                 if (force_update || (block.timestamp > last_gauge_time_totals[i])){
1862                     // Update the gauge_relative_weight
1863                     last_gauge_relative_weights[i] = IFraxGaugeController(gauge_controller_address).gauge_relative_weight_write(address(this), block.timestamp);
1864                     last_gauge_time_totals[i] = IFraxGaugeController(gauge_controller_address).time_total();
1865                 }
1866             }
1867         }
1868     }
1869 
1870     function sync() public {
1871         // Sync the gauge weight, if applicable
1872         sync_gauge_weights(false);
1873 
1874         // Update the fraxPerLPStored
1875         fraxPerLPStored = fraxPerLPToken();
1876 
1877         if (block.timestamp >= periodFinish) {
1878             retroCatchUp();
1879         }
1880         else {
1881             _updateStoredRewardsAndTime();
1882         }
1883     }
1884 
1885     /* ========== RESTRICTED FUNCTIONS - Curator / migrator callable ========== */
1886     
1887     // ------ FARM SYNCING ------
1888     // In children...
1889 
1890     // ------ PAUSES ------
1891 
1892     function setPauses(
1893         bool _stakingPaused,
1894         bool _withdrawalsPaused,
1895         bool _rewardsCollectionPaused
1896     ) external onlyByOwnGov {
1897         stakingPaused = _stakingPaused;
1898         withdrawalsPaused = _withdrawalsPaused;
1899         rewardsCollectionPaused = _rewardsCollectionPaused;
1900     }
1901 
1902     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
1903     
1904     function unlockStakes() external onlyByOwnGov {
1905         stakesUnlocked = !stakesUnlocked;
1906     }
1907 
1908     function toggleMigrations() external onlyByOwnGov {
1909         migrationsOn = !migrationsOn;
1910     }
1911 
1912     // Adds supported migrator address
1913     function toggleMigrator(address migrator_address) external onlyByOwnGov {
1914         valid_migrators[migrator_address] = !valid_migrators[migrator_address];
1915     }
1916 
1917     // Adds a valid veFXS proxy address
1918     function toggleValidVeFXSProxy(address _proxy_addr) external onlyByOwnGov {
1919         valid_vefxs_proxies[_proxy_addr] = !valid_vefxs_proxies[_proxy_addr];
1920     }
1921 
1922     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
1923     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyTknMgrs(tokenAddress) {
1924         // Check if the desired token is a reward token
1925         bool isRewardToken = false;
1926         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1927             if (rewardTokens[i] == tokenAddress) {
1928                 isRewardToken = true;
1929                 break;
1930             }
1931         }
1932 
1933         // Only the reward managers can take back their reward tokens
1934         // Also, other tokens, like the staking token, airdrops, or accidental deposits, can be withdrawn by the owner
1935         if (
1936                 (isRewardToken && rewardManagers[tokenAddress] == msg.sender)
1937                 || (!isRewardToken && (msg.sender == owner))
1938             ) {
1939             TransferHelper.safeTransfer(tokenAddress, msg.sender, tokenAmount);
1940             return;
1941         }
1942         // If none of the above conditions are true
1943         else {
1944             revert("No valid tokens to recover");
1945         }
1946     }
1947 
1948     function setMiscVariables(
1949         uint256[6] memory _misc_vars
1950         // [0]: uint256 _lock_max_multiplier, 
1951         // [1] uint256 _vefxs_max_multiplier, 
1952         // [2] uint256 _vefxs_per_frax_for_max_boost,
1953         // [3] uint256 _vefxs_boost_scale_factor,
1954         // [4] uint256 _lock_time_for_max_multiplier,
1955         // [5] uint256 _lock_time_min
1956     ) external onlyByOwnGov {
1957         require(_misc_vars[0] >= MULTIPLIER_PRECISION, "Must be >= MUL PREC");
1958         require((_misc_vars[1] >= 0) && (_misc_vars[2] >= 0) && (_misc_vars[3] >= 0), "Must be >= 0");
1959         require((_misc_vars[4] >= 1) && (_misc_vars[5] >= 1), "Must be >= 1");
1960 
1961         lock_max_multiplier = _misc_vars[0];
1962         vefxs_max_multiplier = _misc_vars[1];
1963         vefxs_per_frax_for_max_boost = _misc_vars[2];
1964         vefxs_boost_scale_factor = _misc_vars[3];
1965         lock_time_for_max_multiplier = _misc_vars[4];
1966         lock_time_min = _misc_vars[5];
1967     }
1968 
1969     // The owner or the reward token managers can set reward rates 
1970     function setRewardVars(address reward_token_address, uint256 _new_rate, address _gauge_controller_address, address _rewards_distributor_address) external onlyTknMgrs(reward_token_address) {
1971         rewardRatesManual[rewardTokenAddrToIdx[reward_token_address]] = _new_rate;
1972         gaugeControllers[rewardTokenAddrToIdx[reward_token_address]] = _gauge_controller_address;
1973         rewardDistributors[rewardTokenAddrToIdx[reward_token_address]] = _rewards_distributor_address;
1974     }
1975 
1976     // The owner or the reward token managers can change managers
1977     function changeTokenManager(address reward_token_address, address new_manager_address) external onlyTknMgrs(reward_token_address) {
1978         rewardManagers[reward_token_address] = new_manager_address;
1979     }
1980 
1981     /* ========== A CHICKEN ========== */
1982     //
1983     //         ,~.
1984     //      ,-'__ `-,
1985     //     {,-'  `. }              ,')
1986     //    ,( a )   `-.__         ,',')~,
1987     //   <=.) (         `-.__,==' ' ' '}
1988     //     (   )                      /)
1989     //      `-'\   ,                    )
1990     //          |  \        `~.        /
1991     //          \   `._        \      /
1992     //           \     `._____,'    ,'
1993     //            `-.             ,'
1994     //               `-._     _,-'
1995     //                   77jj'
1996     //                  //_||
1997     //               __//--'/`
1998     //             ,--'/`  '
1999     //
2000     // [hjw] https://textart.io/art/vw6Sa3iwqIRGkZsN1BC2vweF/chicken
2001 }
2002 
2003 
2004 // File contracts/Misc_AMOs/Lending_AMOs/aave/IScaledBalanceToken.sol
2005 
2006 
2007 interface IScaledBalanceToken {
2008   /**
2009    * @dev Returns the scaled balance of the user. The scaled balance is the sum of all the
2010    * updated stored balance divided by the reserve's liquidity index at the moment of the update
2011    * @param user The user whose balance is calculated
2012    * @return The scaled balance of the user
2013    **/
2014   function scaledBalanceOf(address user) external view returns (uint256);
2015 
2016   /**
2017    * @dev Returns the scaled balance of the user and the scaled total supply.
2018    * @param user The address of the user
2019    * @return The scaled balance of the user
2020    * @return The scaled balance and the scaled total supply
2021    **/
2022   function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);
2023 
2024   /**
2025    * @dev Returns the scaled total supply of the variable debt token. Represents sum(debt/index)
2026    * @return The scaled total supply
2027    **/
2028   function scaledTotalSupply() external view returns (uint256);
2029 }
2030 
2031 
2032 // File contracts/Misc_AMOs/Lending_AMOs/aave/IAToken.sol
2033 
2034 
2035 
2036 interface IAToken is IERC20, IScaledBalanceToken {
2037   function ATOKEN_REVISION() external view returns (uint256);
2038   function DOMAIN_SEPARATOR() external view returns (bytes32);
2039   function EIP712_REVISION() external view returns (bytes memory);
2040   function PERMIT_TYPEHASH() external view returns (bytes32);
2041   function POOL() external view returns (address);
2042   function RESERVE_TREASURY_ADDRESS() external view returns (address);
2043   function UINT_MAX_VALUE() external view returns (uint256);
2044   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
2045 
2046   /**
2047    * @dev Emitted after the mint action
2048    * @param from The address performing the mint
2049    * @param value The amount being
2050    * @param index The new liquidity index of the reserve
2051    **/
2052   event Mint(address indexed from, uint256 value, uint256 index);
2053 
2054   /**
2055    * @dev Mints `amount` aTokens to `user`
2056    * @param user The address receiving the minted tokens
2057    * @param amount The amount of tokens getting minted
2058    * @param index The new liquidity index of the reserve
2059    * @return `true` if the the previous balance of the user was 0
2060    */
2061   function mint(
2062     address user,
2063     uint256 amount,
2064     uint256 index
2065   ) external returns (bool);
2066 
2067   /**
2068    * @dev Emitted after aTokens are burned
2069    * @param from The owner of the aTokens, getting them burned
2070    * @param target The address that will receive the underlying
2071    * @param value The amount being burned
2072    * @param index The new liquidity index of the reserve
2073    **/
2074   event Burn(address indexed from, address indexed target, uint256 value, uint256 index);
2075 
2076   /**
2077    * @dev Emitted during the transfer action
2078    * @param from The user whose tokens are being transferred
2079    * @param to The recipient
2080    * @param value The amount being transferred
2081    * @param index The new liquidity index of the reserve
2082    **/
2083   event BalanceTransfer(address indexed from, address indexed to, uint256 value, uint256 index);
2084 
2085   /**
2086    * @dev Burns aTokens from `user` and sends the equivalent amount of underlying to `receiverOfUnderlying`
2087    * @param user The owner of the aTokens, getting them burned
2088    * @param receiverOfUnderlying The address that will receive the underlying
2089    * @param amount The amount being burned
2090    * @param index The new liquidity index of the reserve
2091    **/
2092   function burn(
2093     address user,
2094     address receiverOfUnderlying,
2095     uint256 amount,
2096     uint256 index
2097   ) external;
2098 
2099   /**
2100    * @dev Mints aTokens to the reserve treasury
2101    * @param amount The amount of tokens getting minted
2102    * @param index The new liquidity index of the reserve
2103    */
2104   function mintToTreasury(uint256 amount, uint256 index) external;
2105 
2106   /**
2107    * @dev Transfers aTokens in the event of a borrow being liquidated, in case the liquidators reclaims the aToken
2108    * @param from The address getting liquidated, current owner of the aTokens
2109    * @param to The recipient
2110    * @param value The amount of tokens getting transferred
2111    **/
2112   function transferOnLiquidation(
2113     address from,
2114     address to,
2115     uint256 value
2116   ) external;
2117 
2118   /**
2119    * @dev Transfers the underlying asset to `target`. Used by the LendingPool to transfer
2120    * assets in borrow(), withdraw() and flashLoan()
2121    * @param user The recipient of the aTokens
2122    * @param amount The amount getting transferred
2123    * @return The amount transferred
2124    **/
2125   function transferUnderlyingTo(address user, uint256 amount) external returns (uint256);
2126 }
2127 
2128 
2129 // File contracts/Misc_AMOs/Lending_AMOs/aave/ILendingPool.sol
2130 
2131 
2132 interface ILendingPool {
2133   function FLASHLOAN_PREMIUM_TOTAL (  ) external view returns ( uint256 );
2134   function LENDINGPOOL_REVISION (  ) external view returns ( uint256 );
2135   function MAX_NUMBER_RESERVES (  ) external view returns ( uint256 );
2136   function MAX_STABLE_RATE_BORROW_SIZE_PERCENT (  ) external view returns ( uint256 );
2137   function borrow ( address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf ) external;
2138   function deposit ( address asset, uint256 amount, address onBehalfOf, uint16 referralCode ) external;
2139   function finalizeTransfer ( address asset, address from, address to, uint256 amount, uint256 balanceFromBefore, uint256 balanceToBefore ) external;
2140   function flashLoan ( address receiverAddress, address[] memory assets, uint256[] memory amounts, uint256[] memory modes, address onBehalfOf, bytes memory params, uint16 referralCode ) external;
2141   function getAddressesProvider (  ) external view returns ( address );
2142   // function getConfiguration ( address asset ) external view returns ( tuple );
2143   // function getReserveData ( address asset ) external view returns ( tuple );
2144   function getReserveNormalizedIncome ( address asset ) external view returns ( uint256 );
2145   function getReserveNormalizedVariableDebt ( address asset ) external view returns ( uint256 );
2146   function getReservesList (  ) external view returns ( address[] memory );
2147   function getUserAccountData ( address user ) external view returns ( uint256 totalCollateralETH, uint256 totalDebtETH, uint256 availableBorrowsETH, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor );
2148   // function getUserConfiguration ( address user ) external view returns ( tuple );
2149   function initReserve ( address asset, address aTokenAddress, address stableDebtAddress, address variableDebtAddress, address interestRateStrategyAddress ) external;
2150   function initialize ( address provider ) external;
2151   function liquidationCall ( address collateralAsset, address debtAsset, address user, uint256 debtToCover, bool receiveAToken ) external;
2152   function paused (  ) external view returns ( bool );
2153   function rebalanceStableBorrowRate ( address asset, address user ) external;
2154   function repay ( address asset, uint256 amount, uint256 rateMode, address onBehalfOf ) external returns ( uint256 );
2155   function setConfiguration ( address asset, uint256 configuration ) external;
2156   function setPause ( bool val ) external;
2157   function setReserveInterestRateStrategyAddress ( address asset, address rateStrategyAddress ) external;
2158   function setUserUseReserveAsCollateral ( address asset, bool useAsCollateral ) external;
2159   function swapBorrowRateMode ( address asset, uint256 rateMode ) external;
2160   function withdraw ( address asset, uint256 amount, address to ) external returns ( uint256 );
2161 }
2162 
2163 
2164 // File contracts/Staking/FraxUnifiedFarm_PosRebase.sol
2165 
2166 
2167 // ====================================================================
2168 // |     ______                   _______                             |
2169 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
2170 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
2171 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
2172 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
2173 // |                                                                  |
2174 // ====================================================================
2175 // ===================== FraxUnifiedFarm_PosRebase ====================
2176 // ====================================================================
2177 // For positive rebase ERC20 Tokens like Aave's aToken and Compound's cToken
2178 // Uses FraxUnifiedFarmTemplate.sol
2179 
2180 // -------------------- VARIES --------------------
2181 
2182 // Aave V2
2183 
2184 
2185 // ------------------------------------------------
2186 
2187 contract FraxUnifiedFarm_PosRebase is FraxUnifiedFarmTemplate {
2188 
2189     /* ========== STATE VARIABLES ========== */
2190 
2191     // -------------------- VARIES --------------------
2192 
2193     // Aave V2
2194     IAToken public stakingToken;
2195 
2196     // Need to store this when the user stakes. If they lockAdditional, the base value needs to accrue and the
2197     // Stored liquidity index needs to be updated
2198     // https://docs.aave.com/developers/v/2.0/the-core-protocol/atokens#scaledbalanceof
2199     mapping(bytes32 => uint256) public storedStkLiqIdx; // kek_id -> liquidity index. 
2200 
2201     // ------------------------------------------------
2202 
2203     // Stake tracking
2204     mapping(address => LockedStake[]) public lockedStakes;
2205 
2206     /* ========== STRUCTS ========== */
2207 
2208     // Struct for the stake
2209     struct LockedStake {
2210         bytes32 kek_id;
2211         uint256 start_timestamp;
2212         uint256 liquidity;
2213         uint256 ending_timestamp;
2214         uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
2215     }
2216     
2217     /* ========== CONSTRUCTOR ========== */
2218 
2219     constructor (
2220         address _owner,
2221         address[] memory _rewardTokens,
2222         address[] memory _rewardManagers,
2223         uint256[] memory _rewardRatesManual,
2224         address[] memory _gaugeControllers,
2225         address[] memory _rewardDistributors,
2226         address _stakingToken
2227     ) 
2228     FraxUnifiedFarmTemplate(_owner, _rewardTokens, _rewardManagers, _rewardRatesManual, _gaugeControllers, _rewardDistributors)
2229     {
2230 
2231         // -------------------- VARIES --------------------
2232   
2233         // Aave V2
2234         stakingToken = IAToken(_stakingToken);
2235     
2236     }
2237 
2238     /* ============= VIEWS ============= */
2239 
2240     // ------ FRAX RELATED ------
2241 
2242     function fraxPerLPToken() public view override returns (uint256) {
2243         // Get the amount of FRAX 'inside' of the lp tokens
2244         uint256 frax_per_lp_token;
2245 
2246 
2247         // Aave V2
2248         // ============================================
2249         {
2250             // Always 1-to-1, for simplicity. Autocompounding is handled by _accrueInterest
2251             // Users can accrue up their principal by calling lockAdditional with 0 amount.
2252             // Also will accrue at withdrawal time
2253             frax_per_lp_token = 1e18;
2254         }
2255 
2256         return frax_per_lp_token;
2257     }
2258 
2259     // ------ LIQUIDITY AND WEIGHTS ------
2260 
2261     // Calculate the combined weight for an account
2262     function calcCurCombinedWeight(address account) public override view
2263         returns (
2264             uint256 old_combined_weight,
2265             uint256 new_vefxs_multiplier,
2266             uint256 new_combined_weight
2267         )
2268     {
2269         // Get the old combined weight
2270         old_combined_weight = _combined_weights[account];
2271 
2272         // Get the veFXS multipliers
2273         // For the calculations, use the midpoint (analogous to midpoint Riemann sum)
2274         new_vefxs_multiplier = veFXSMultiplier(account);
2275 
2276         uint256 midpoint_vefxs_multiplier;
2277         if (_locked_liquidity[account] == 0 && _combined_weights[account] == 0) {
2278             // This is only called for the first stake to make sure the veFXS multiplier is not cut in half
2279             midpoint_vefxs_multiplier = new_vefxs_multiplier;
2280         }
2281         else {
2282             midpoint_vefxs_multiplier = (new_vefxs_multiplier + _vefxsMultiplierStored[account]) / 2;
2283         }
2284 
2285         // Loop through the locked stakes, first by getting the liquidity * lock_multiplier portion
2286         new_combined_weight = 0;
2287         for (uint256 i = 0; i < lockedStakes[account].length; i++) {
2288             LockedStake memory thisStake = lockedStakes[account][i];
2289             uint256 lock_multiplier = thisStake.lock_multiplier;
2290 
2291             // If the lock is expired
2292             if (thisStake.ending_timestamp <= block.timestamp) {
2293                 // If the lock expired in the time since the last claim, the weight needs to be proportionately averaged this time
2294                 if (lastRewardClaimTime[account] < thisStake.ending_timestamp){
2295                     uint256 time_before_expiry = thisStake.ending_timestamp - lastRewardClaimTime[account];
2296                     uint256 time_after_expiry = block.timestamp - thisStake.ending_timestamp;
2297 
2298                     // Get the weighted-average lock_multiplier
2299                     uint256 numerator = (lock_multiplier * time_before_expiry) + (MULTIPLIER_PRECISION * time_after_expiry);
2300                     lock_multiplier = numerator / (time_before_expiry + time_after_expiry);
2301                 }
2302                 // Otherwise, it needs to just be 1x
2303                 else {
2304                     lock_multiplier = MULTIPLIER_PRECISION;
2305                 }
2306             }
2307 
2308             uint256 liquidity = thisStake.liquidity;
2309             uint256 combined_boosted_amount = (liquidity * (lock_multiplier + midpoint_vefxs_multiplier)) / MULTIPLIER_PRECISION;
2310             new_combined_weight = new_combined_weight + combined_boosted_amount;
2311         }
2312     }
2313 
2314     // ------ REBASE RELATED ------
2315 
2316     // Aave V2
2317     // ============================================
2318     // Get currentLiquidityIndex from AAVE
2319     function currLiqIdx() public view returns (uint256) {
2320         return ILendingPool(stakingToken.POOL()).getReserveNormalizedIncome(frax_address);
2321     }
2322 
2323     // ------ LOCK RELATED ------
2324 
2325     // All the locked stakes for a given account
2326     function lockedStakesOf(address account) external view returns (LockedStake[] memory) {
2327         return lockedStakes[account];
2328     }
2329 
2330     // Returns the length of the locked stakes for a given account
2331     function lockedStakesOfLength(address account) external view returns (uint256) {
2332         return lockedStakes[account].length;
2333     }
2334 
2335     // // All the locked stakes for a given account [old-school method]
2336     // function lockedStakesOfMultiArr(address account) external view returns (
2337     //     bytes32[] memory kek_ids,
2338     //     uint256[] memory start_timestamps,
2339     //     uint256[] memory liquidities,
2340     //     uint256[] memory ending_timestamps,
2341     //     uint256[] memory lock_multipliers
2342     // ) {
2343     //     for (uint256 i = 0; i < lockedStakes[account].length; i++){ 
2344     //         LockedStake memory thisStake = lockedStakes[account][i];
2345     //         kek_ids[i] = thisStake.kek_id;
2346     //         start_timestamps[i] = thisStake.start_timestamp;
2347     //         liquidities[i] = thisStake.liquidity;
2348     //         ending_timestamps[i] = thisStake.ending_timestamp;
2349     //         lock_multipliers[i] = thisStake.lock_multiplier;
2350     //     }
2351     // }
2352 
2353     /* =============== MUTATIVE FUNCTIONS =============== */
2354 
2355     // ------ STAKING ------
2356 
2357     function _getStake(address staker_address, bytes32 kek_id) internal view returns (LockedStake memory locked_stake, uint256 arr_idx) {
2358         for (uint256 i = 0; i < lockedStakes[staker_address].length; i++){ 
2359             if (kek_id == lockedStakes[staker_address][i].kek_id){
2360                 locked_stake = lockedStakes[staker_address][i];
2361                 arr_idx = i;
2362                 break;
2363             }
2364         }
2365         require(locked_stake.kek_id == kek_id, "Stake not found");
2366         
2367     }
2368 
2369     // Add additional LPs to an existing locked stake
2370     // REBASE: If you simply want to accrue interest, call this with addl_liq = 0
2371     function lockAdditional(bytes32 kek_id, uint256 addl_liq) updateRewardAndBalance(msg.sender, true) public {
2372         // Get the stake and its index
2373         (LockedStake memory thisStake, uint256 theArrayIndex) = _getStake(msg.sender, kek_id);
2374 
2375         // Accrue the interest and get the updated stake
2376         (thisStake, ) = _accrueInterest(msg.sender, thisStake, theArrayIndex);
2377 
2378         // Return early if only accruing, to save gas
2379         if (addl_liq == 0) return;
2380 
2381         // Calculate the new amount
2382         uint256 new_amt = thisStake.liquidity + addl_liq;
2383 
2384         // Checks
2385         require(addl_liq >= 0, "Must be positive");
2386 
2387         // Pull the tokens from the sender
2388         TransferHelper.safeTransferFrom(address(stakingToken), msg.sender, address(this), addl_liq);
2389 
2390         // Update the stake
2391         lockedStakes[msg.sender][theArrayIndex] = LockedStake(
2392             kek_id,
2393             thisStake.start_timestamp,
2394             new_amt,
2395             thisStake.ending_timestamp,
2396             thisStake.lock_multiplier
2397         );
2398 
2399         // Update liquidities
2400         _total_liquidity_locked += addl_liq;
2401         _locked_liquidity[msg.sender] += addl_liq;
2402         {
2403             address the_proxy = getProxyFor(msg.sender);
2404             if (the_proxy != address(0)) proxy_lp_balances[the_proxy] += addl_liq;
2405         }
2406 
2407         // Need to call to update the combined weights
2408         _updateRewardAndBalance(msg.sender, false);
2409     }
2410 
2411     // Two different stake functions are needed because of delegateCall and msg.sender issues (important for migration)
2412     function stakeLocked(uint256 liquidity, uint256 secs) nonReentrant external returns (bytes32) {
2413         return _stakeLocked(msg.sender, msg.sender, liquidity, secs, block.timestamp);
2414     }
2415 
2416     // If this were not internal, and source_address had an infinite approve, this could be exploitable
2417     // (pull funds from source_address and stake for an arbitrary staker_address)
2418     function _stakeLocked(
2419         address staker_address,
2420         address source_address,
2421         uint256 liquidity,
2422         uint256 secs,
2423         uint256 start_timestamp
2424     ) internal updateRewardAndBalance(staker_address, true) returns (bytes32) {
2425         require(stakingPaused == false || valid_migrators[msg.sender] == true, "Staking paused or in migration");
2426         require(secs >= lock_time_min, "Minimum stake time not met");
2427         require(secs <= lock_time_for_max_multiplier,"Trying to lock for too long");
2428 
2429         // Pull in the required token(s)
2430         // Varies per farm
2431         TransferHelper.safeTransferFrom(address(stakingToken), source_address, address(this), liquidity);
2432 
2433         // Get the lock multiplier and kek_id
2434         uint256 lock_multiplier = lockMultiplier(secs);
2435         bytes32 kek_id = keccak256(abi.encodePacked(staker_address, start_timestamp, liquidity, _locked_liquidity[staker_address]));
2436         
2437         // Create the locked stake
2438         lockedStakes[staker_address].push(LockedStake(
2439             kek_id,
2440             start_timestamp,
2441             liquidity,
2442             start_timestamp + secs,
2443             lock_multiplier
2444         ));
2445 
2446         // Store the liquidity index. Used later to give back principal + accrued interest
2447         storedStkLiqIdx[kek_id] = currLiqIdx();
2448 
2449         // Update liquidities
2450         _total_liquidity_locked += liquidity;
2451         _locked_liquidity[staker_address] += liquidity;
2452         {
2453             address the_proxy = getProxyFor(staker_address);
2454             if (the_proxy != address(0)) proxy_lp_balances[the_proxy] += liquidity;
2455         }
2456         
2457         // Need to call again to make sure everything is correct
2458         _updateRewardAndBalance(staker_address, false);
2459 
2460         emit StakeLocked(staker_address, liquidity, secs, kek_id, source_address);
2461 
2462         return kek_id;
2463     }
2464 
2465     // ------ WITHDRAWING ------
2466 
2467     // Two different withdrawLocked functions are needed because of delegateCall and msg.sender issues (important for migration)
2468     function withdrawLocked(bytes32 kek_id, address destination_address) nonReentrant external returns (uint256) {
2469         require(withdrawalsPaused == false, "Withdrawals paused");
2470         return _withdrawLocked(msg.sender, destination_address, kek_id);
2471     }
2472 
2473     // No withdrawer == msg.sender check needed since this is only internally callable and the checks are done in the wrapper
2474     // functions like migrator_withdraw_locked() and withdrawLocked()
2475     function _withdrawLocked(
2476         address staker_address,
2477         address destination_address,
2478         bytes32 kek_id
2479     ) internal returns (uint256) {
2480         // Collect rewards first and then update the balances
2481         _getReward(staker_address, destination_address, true);
2482 
2483         // Get the stake and its index
2484         (LockedStake memory thisStake, uint256 theArrayIndex) = _getStake(staker_address, kek_id);
2485 
2486         // Accrue the interest and get the updated stake
2487         (thisStake, ) = _accrueInterest(staker_address, thisStake, theArrayIndex);
2488 
2489         // Do safety checks
2490         require(block.timestamp >= thisStake.ending_timestamp || stakesUnlocked == true || valid_migrators[msg.sender] == true, "Stake is still locked!");
2491         uint256 liquidity = thisStake.liquidity;
2492 
2493         if (liquidity > 0) {
2494             // Update liquidities
2495             _total_liquidity_locked -= liquidity;
2496             _locked_liquidity[staker_address] -= liquidity;
2497             {
2498                 address the_proxy = getProxyFor(staker_address);
2499                 if (the_proxy != address(0)) proxy_lp_balances[the_proxy] -= liquidity;
2500             }
2501 
2502             // Remove the stake from the array
2503             delete lockedStakes[staker_address][theArrayIndex];
2504 
2505             // Give the tokens to the destination_address
2506             // Should throw if insufficient balance
2507             stakingToken.transfer(destination_address, liquidity);
2508 
2509             // Need to call again to make sure everything is correct
2510             _updateRewardAndBalance(staker_address, false);
2511 
2512             // REBASE: leave liquidity in the event tracking alone, not giveBackAmt
2513             emit WithdrawLocked(staker_address, liquidity, kek_id, destination_address);
2514 
2515             
2516         }
2517 
2518         return liquidity;
2519     }
2520 
2521     // REBASE SPECIFIC
2522     // Catches-up the user's accrued interest and sets it as the new principal (liquidity)
2523     function _accrueInterest(
2524         address staker_address, 
2525         LockedStake memory thisStake, 
2526         uint256 theArrayIndex
2527     ) internal returns (LockedStake memory, uint256) {
2528         // Calculate the new liquidity as well as the diff
2529         // new pricipal = (old principal ∗ currentLiquidityIndex) / (old liquidity index)
2530         uint256 new_liq = (thisStake.liquidity * currLiqIdx()) / storedStkLiqIdx[thisStake.kek_id];
2531         uint256 liq_diff = new_liq - thisStake.liquidity;
2532 
2533         // Update the new principal
2534         lockedStakes[staker_address][theArrayIndex].liquidity = new_liq;
2535 
2536         // Update the liquidity totals
2537         _total_liquidity_locked += liq_diff;
2538         _locked_liquidity[staker_address] += liq_diff;
2539         {
2540             address the_proxy = getProxyFor(staker_address);
2541             if (the_proxy != address(0)) proxy_lp_balances[the_proxy] += liq_diff;
2542         }
2543 
2544         // Store the new liquidity index. Used later to give back principal + accrued interest
2545         storedStkLiqIdx[thisStake.kek_id] = currLiqIdx();
2546     
2547         return (lockedStakes[staker_address][theArrayIndex], theArrayIndex);
2548     }
2549 
2550     function _getRewardExtraLogic(address rewardee, address destination_address) internal override {
2551         // Do nothing
2552     }
2553 
2554      /* ========== RESTRICTED FUNCTIONS - Curator / migrator callable ========== */
2555 
2556     // Migrator can stake for someone else (they won't be able to withdraw it back though, only staker_address can). 
2557     function migrator_stakeLocked_for(address staker_address, uint256 amount, uint256 secs, uint256 start_timestamp) external isMigrating {
2558         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
2559         _stakeLocked(staker_address, msg.sender, amount, secs, start_timestamp);
2560     }
2561 
2562     // Used for migrations
2563     function migrator_withdraw_locked(address staker_address, bytes32 kek_id) external isMigrating {
2564         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
2565         _withdrawLocked(staker_address, msg.sender, kek_id);
2566     }
2567     
2568     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
2569 
2570     // Inherited...
2571 
2572     /* ========== EVENTS ========== */
2573 
2574     event StakeLocked(address indexed user, uint256 amount, uint256 secs, bytes32 kek_id, address source_address);
2575     event WithdrawLocked(address indexed user, uint256 liquidity, bytes32 kek_id, address destination_address);
2576 }
2577 
2578 
2579 // File contracts/Staking/Variants/FraxUnifiedFarm_PosRebase_aFRAX.sol
2580 
2581 
2582 
2583 contract FraxUnifiedFarm_PosRebase_aFRAX is FraxUnifiedFarm_PosRebase {
2584     constructor (
2585         address _owner,
2586         address[] memory _rewardTokens,
2587         address[] memory _rewardManagers,
2588         uint256[] memory _rewardRates,
2589         address[] memory _gaugeControllers,
2590         address[] memory _rewardDistributors,
2591         address _stakingToken 
2592     ) 
2593     FraxUnifiedFarm_PosRebase(_owner , _rewardTokens, _rewardManagers, _rewardRates, _gaugeControllers, _rewardDistributors, _stakingToken)
2594     {}
2595 }