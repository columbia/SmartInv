1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.6.7 https://hardhat.org
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
52 // File contracts/Math/SafeMath.sol
53 
54 
55 /**
56  * @dev Wrappers over Solidity's arithmetic operations with added overflow
57  * checks.
58  *
59  * Arithmetic operations in Solidity wrap on overflow. This can easily result
60  * in bugs, because programmers usually assume that an overflow raises an
61  * error, which is the standard behavior in high level programming languages.
62  * `SafeMath` restores this intuition by reverting the transaction when an
63  * operation overflows.
64  *
65  * Using this library instead of the unchecked operations eliminates an entire
66  * class of bugs, so it's recommended to use it always.
67  */
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `+` operator.
74      *
75      * Requirements:
76      * - Addition cannot overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      * - Subtraction cannot overflow.
93      */
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         return sub(a, b, "SafeMath: subtraction overflow");
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      * - Subtraction cannot overflow.
106      *
107      * _Available since v2.4.0._
108      */
109     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b <= a, errorMessage);
111         uint256 c = a - b;
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127         // benefit is lost if 'b' is also tested.
128         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
129         if (a == 0) {
130             return 0;
131         }
132 
133         uint256 c = a * b;
134         require(c / a == b, "SafeMath: multiplication overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers. Reverts on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         return div(a, b, "SafeMath: division by zero");
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      *
165      * _Available since v2.4.0._
166      */
167     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         // Solidity only automatically asserts when dividing by 0
169         require(b > 0, errorMessage);
170         uint256 c = a / b;
171         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         return mod(a, b, "SafeMath: modulo by zero");
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * Reverts with custom message when dividing by zero.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      *
202      * _Available since v2.4.0._
203      */
204     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b != 0, errorMessage);
206         return a % b;
207     }
208 }
209 
210 
211 // File contracts/Curve/IveFXS.sol
212 
213 pragma abicoder v2;
214 
215 interface IveFXS {
216 
217     struct LockedBalance {
218         int128 amount;
219         uint256 end;
220     }
221 
222     function commit_transfer_ownership(address addr) external;
223     function apply_transfer_ownership() external;
224     function commit_smart_wallet_checker(address addr) external;
225     function apply_smart_wallet_checker() external;
226     function toggleEmergencyUnlock() external;
227     function recoverERC20(address token_addr, uint256 amount) external;
228     function get_last_user_slope(address addr) external view returns (int128);
229     function user_point_history__ts(address _addr, uint256 _idx) external view returns (uint256);
230     function locked__end(address _addr) external view returns (uint256);
231     function checkpoint() external;
232     function deposit_for(address _addr, uint256 _value) external;
233     function create_lock(uint256 _value, uint256 _unlock_time) external;
234     function increase_amount(uint256 _value) external;
235     function increase_unlock_time(uint256 _unlock_time) external;
236     function withdraw() external;
237     function balanceOf(address addr) external view returns (uint256);
238     function balanceOf(address addr, uint256 _t) external view returns (uint256);
239     function balanceOfAt(address addr, uint256 _block) external view returns (uint256);
240     function totalSupply() external view returns (uint256);
241     function totalSupply(uint256 t) external view returns (uint256);
242     function totalSupplyAt(uint256 _block) external view returns (uint256);
243     function totalFXSSupply() external view returns (uint256);
244     function totalFXSSupplyAt(uint256 _block) external view returns (uint256);
245     function changeController(address _newController) external;
246     function token() external view returns (address);
247     function supply() external view returns (uint256);
248     function locked(address addr) external view returns (LockedBalance memory);
249     function epoch() external view returns (uint256);
250     function point_history(uint256 arg0) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
251     function user_point_history(address arg0, uint256 arg1) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
252     function user_point_epoch(address arg0) external view returns (uint256);
253     function slope_changes(uint256 arg0) external view returns (int128);
254     function controller() external view returns (address);
255     function transfersEnabled() external view returns (bool);
256     function emergencyUnlockActive() external view returns (bool);
257     function name() external view returns (string memory);
258     function symbol() external view returns (string memory);
259     function version() external view returns (string memory);
260     function decimals() external view returns (uint256);
261     function future_smart_wallet_checker() external view returns (address);
262     function smart_wallet_checker() external view returns (address);
263     function admin() external view returns (address);
264     function future_admin() external view returns (address);
265 }
266 
267 
268 // File contracts/Curve/IFraxGaugeController.sol
269 
270 
271 // https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol
272 
273 interface IFraxGaugeController {
274     struct Point {
275         uint256 bias;
276         uint256 slope;
277     }
278 
279     struct VotedSlope {
280         uint256 slope;
281         uint256 power;
282         uint256 end;
283     }
284 
285     // Public variables
286     function admin() external view returns (address);
287     function future_admin() external view returns (address);
288     function token() external view returns (address);
289     function voting_escrow() external view returns (address);
290     function n_gauge_types() external view returns (int128);
291     function n_gauges() external view returns (int128);
292     function gauge_type_names(int128) external view returns (string memory);
293     function gauges(uint256) external view returns (address);
294     function vote_user_slopes(address, address)
295         external
296         view
297         returns (VotedSlope memory);
298     function vote_user_power(address) external view returns (uint256);
299     function last_user_vote(address, address) external view returns (uint256);
300     function points_weight(address, uint256)
301         external
302         view
303         returns (Point memory);
304     function time_weight(address) external view returns (uint256);
305     function points_sum(int128, uint256) external view returns (Point memory);
306     function time_sum(uint256) external view returns (uint256);
307     function points_total(uint256) external view returns (uint256);
308     function time_total() external view returns (uint256);
309     function points_type_weight(int128, uint256)
310         external
311         view
312         returns (uint256);
313     function time_type_weight(uint256) external view returns (uint256);
314 
315     // Getter functions
316     function gauge_types(address) external view returns (int128);
317     function gauge_relative_weight(address) external view returns (uint256);
318     function gauge_relative_weight(address, uint256) external view returns (uint256);
319     function get_gauge_weight(address) external view returns (uint256);
320     function get_type_weight(int128) external view returns (uint256);
321     function get_total_weight() external view returns (uint256);
322     function get_weights_sum_per_type(int128) external view returns (uint256);
323 
324     // External functions
325     function commit_transfer_ownership(address) external;
326     function apply_transfer_ownership() external;
327     function add_gauge(
328         address,
329         int128,
330         uint256
331     ) external;
332     function checkpoint() external;
333     function checkpoint_gauge(address) external;
334     function global_emission_rate() external view returns (uint256);
335     function gauge_relative_weight_write(address)
336         external
337         returns (uint256);
338     function gauge_relative_weight_write(address, uint256)
339         external
340         returns (uint256);
341     function add_type(string memory, uint256) external;
342     function change_type_weight(int128, uint256) external;
343     function change_gauge_weight(address, uint256) external;
344     function change_global_emission_rate(uint256) external;
345     function vote_for_gauge_weights(address, uint256) external;
346 }
347 
348 
349 // File contracts/Curve/IFraxGaugeFXSRewardsDistributor.sol
350 
351 
352 interface IFraxGaugeFXSRewardsDistributor {
353   function acceptOwnership() external;
354   function curator_address() external view returns(address);
355   function currentReward(address gauge_address) external view returns(uint256 reward_amount);
356   function distributeReward(address gauge_address) external returns(uint256 weeks_elapsed, uint256 reward_tally);
357   function distributionsOn() external view returns(bool);
358   function gauge_whitelist(address) external view returns(bool);
359   function is_middleman(address) external view returns(bool);
360   function last_time_gauge_paid(address) external view returns(uint256);
361   function nominateNewOwner(address _owner) external;
362   function nominatedOwner() external view returns(address);
363   function owner() external view returns(address);
364   function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
365   function setCurator(address _new_curator_address) external;
366   function setGaugeController(address _gauge_controller_address) external;
367   function setGaugeState(address _gauge_address, bool _is_middleman, bool _is_active) external;
368   function setTimelock(address _new_timelock) external;
369   function timelock_address() external view returns(address);
370   function toggleDistributions() external;
371 }
372 
373 
374 // File contracts/Common/Context.sol
375 
376 
377 /*
378  * @dev Provides information about the current execution context, including the
379  * sender of the transaction and its data. While these are generally available
380  * via msg.sender and msg.data, they should not be accessed in such a direct
381  * manner, since when dealing with GSN meta-transactions the account sending and
382  * paying for execution may not be the actual sender (as far as an application
383  * is concerned).
384  *
385  * This contract is only required for intermediate, library-like contracts.
386  */
387 abstract contract Context {
388     function _msgSender() internal view virtual returns (address payable) {
389         return payable(msg.sender);
390     }
391 
392     function _msgData() internal view virtual returns (bytes memory) {
393         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
394         return msg.data;
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
1107 // File contracts/Uniswap_V3/libraries/TickMath.sol
1108 
1109 
1110 /// @title Math library for computing sqrt prices from ticks and vice versa
1111 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
1112 /// prices between 2**-128 and 2**128
1113 library TickMath {
1114     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
1115     int24 internal constant MIN_TICK = -887272;
1116     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
1117     int24 internal constant MAX_TICK = -MIN_TICK;
1118 
1119     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
1120     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
1121     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
1122     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
1123 
1124     /// @notice Calculates sqrt(1.0001^tick) * 2^96
1125     /// @dev Throws if |tick| > max tick
1126     /// @param tick The input tick for the above formula
1127     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
1128     /// at the given tick
1129     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
1130         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
1131         require(int256(absTick) <= int256(MAX_TICK), 'T');
1132 
1133         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
1134         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
1135         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
1136         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
1137         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
1138         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
1139         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
1140         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
1141         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
1142         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
1143         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
1144         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
1145         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
1146         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
1147         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
1148         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
1149         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
1150         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
1151         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
1152         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
1153 
1154         if (tick > 0) ratio = type(uint256).max / ratio;
1155 
1156         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
1157         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
1158         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
1159         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
1160     }
1161 
1162     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
1163     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
1164     /// ever return.
1165     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
1166     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
1167     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
1168         // second inequality must be < because the price can never reach the price at the max tick
1169         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
1170         uint256 ratio = uint256(sqrtPriceX96) << 32;
1171 
1172         uint256 r = ratio;
1173         uint256 msb = 0;
1174 
1175         assembly {
1176             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
1177             msb := or(msb, f)
1178             r := shr(f, r)
1179         }
1180         assembly {
1181             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
1182             msb := or(msb, f)
1183             r := shr(f, r)
1184         }
1185         assembly {
1186             let f := shl(5, gt(r, 0xFFFFFFFF))
1187             msb := or(msb, f)
1188             r := shr(f, r)
1189         }
1190         assembly {
1191             let f := shl(4, gt(r, 0xFFFF))
1192             msb := or(msb, f)
1193             r := shr(f, r)
1194         }
1195         assembly {
1196             let f := shl(3, gt(r, 0xFF))
1197             msb := or(msb, f)
1198             r := shr(f, r)
1199         }
1200         assembly {
1201             let f := shl(2, gt(r, 0xF))
1202             msb := or(msb, f)
1203             r := shr(f, r)
1204         }
1205         assembly {
1206             let f := shl(1, gt(r, 0x3))
1207             msb := or(msb, f)
1208             r := shr(f, r)
1209         }
1210         assembly {
1211             let f := gt(r, 0x1)
1212             msb := or(msb, f)
1213         }
1214 
1215         if (msb >= 128) r = ratio >> (msb - 127);
1216         else r = ratio << (127 - msb);
1217 
1218         int256 log_2 = (int256(msb) - 128) << 64;
1219 
1220         assembly {
1221             r := shr(127, mul(r, r))
1222             let f := shr(128, r)
1223             log_2 := or(log_2, shl(63, f))
1224             r := shr(f, r)
1225         }
1226         assembly {
1227             r := shr(127, mul(r, r))
1228             let f := shr(128, r)
1229             log_2 := or(log_2, shl(62, f))
1230             r := shr(f, r)
1231         }
1232         assembly {
1233             r := shr(127, mul(r, r))
1234             let f := shr(128, r)
1235             log_2 := or(log_2, shl(61, f))
1236             r := shr(f, r)
1237         }
1238         assembly {
1239             r := shr(127, mul(r, r))
1240             let f := shr(128, r)
1241             log_2 := or(log_2, shl(60, f))
1242             r := shr(f, r)
1243         }
1244         assembly {
1245             r := shr(127, mul(r, r))
1246             let f := shr(128, r)
1247             log_2 := or(log_2, shl(59, f))
1248             r := shr(f, r)
1249         }
1250         assembly {
1251             r := shr(127, mul(r, r))
1252             let f := shr(128, r)
1253             log_2 := or(log_2, shl(58, f))
1254             r := shr(f, r)
1255         }
1256         assembly {
1257             r := shr(127, mul(r, r))
1258             let f := shr(128, r)
1259             log_2 := or(log_2, shl(57, f))
1260             r := shr(f, r)
1261         }
1262         assembly {
1263             r := shr(127, mul(r, r))
1264             let f := shr(128, r)
1265             log_2 := or(log_2, shl(56, f))
1266             r := shr(f, r)
1267         }
1268         assembly {
1269             r := shr(127, mul(r, r))
1270             let f := shr(128, r)
1271             log_2 := or(log_2, shl(55, f))
1272             r := shr(f, r)
1273         }
1274         assembly {
1275             r := shr(127, mul(r, r))
1276             let f := shr(128, r)
1277             log_2 := or(log_2, shl(54, f))
1278             r := shr(f, r)
1279         }
1280         assembly {
1281             r := shr(127, mul(r, r))
1282             let f := shr(128, r)
1283             log_2 := or(log_2, shl(53, f))
1284             r := shr(f, r)
1285         }
1286         assembly {
1287             r := shr(127, mul(r, r))
1288             let f := shr(128, r)
1289             log_2 := or(log_2, shl(52, f))
1290             r := shr(f, r)
1291         }
1292         assembly {
1293             r := shr(127, mul(r, r))
1294             let f := shr(128, r)
1295             log_2 := or(log_2, shl(51, f))
1296             r := shr(f, r)
1297         }
1298         assembly {
1299             r := shr(127, mul(r, r))
1300             let f := shr(128, r)
1301             log_2 := or(log_2, shl(50, f))
1302         }
1303 
1304         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
1305 
1306         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
1307         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
1308 
1309         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
1310     }
1311 }
1312 
1313 
1314 // File contracts/Uniswap_V3/libraries/FullMath.sol
1315 
1316 
1317 /// @title Contains 512-bit math functions
1318 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1319 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1320 library FullMath {
1321     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1322     /// @param a The multiplicand
1323     /// @param b The multiplier
1324     /// @param denominator The divisor
1325     /// @return result The 256-bit result
1326     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1327     function mulDiv(
1328         uint256 a,
1329         uint256 b,
1330         uint256 denominator
1331     ) internal pure returns (uint256 result) {
1332         // 512-bit multiply [prod1 prod0] = a * b
1333         // Compute the product mod 2**256 and mod 2**256 - 1
1334         // then use the Chinese Remainder Theorem to reconstruct
1335         // the 512 bit result. The result is stored in two 256
1336         // variables such that product = prod1 * 2**256 + prod0
1337         uint256 prod0; // Least significant 256 bits of the product
1338         uint256 prod1; // Most significant 256 bits of the product
1339         assembly {
1340             let mm := mulmod(a, b, not(0))
1341             prod0 := mul(a, b)
1342             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1343         }
1344 
1345         // Handle non-overflow cases, 256 by 256 division
1346         if (prod1 == 0) {
1347             require(denominator > 0);
1348             assembly {
1349                 result := div(prod0, denominator)
1350             }
1351             return result;
1352         }
1353 
1354         // Make sure the result is less than 2**256.
1355         // Also prevents denominator == 0
1356         require(denominator > prod1);
1357 
1358         ///////////////////////////////////////////////
1359         // 512 by 256 division.
1360         ///////////////////////////////////////////////
1361 
1362         // Make division exact by subtracting the remainder from [prod1 prod0]
1363         // Compute remainder using mulmod
1364         uint256 remainder;
1365         assembly {
1366             remainder := mulmod(a, b, denominator)
1367         }
1368         // Subtract 256 bit number from 512 bit number
1369         assembly {
1370             prod1 := sub(prod1, gt(remainder, prod0))
1371             prod0 := sub(prod0, remainder)
1372         }
1373 
1374         // Factor powers of two out of denominator
1375         // Compute largest power of two divisor of denominator.
1376         // Always >= 1.
1377         uint256 twos = (type(uint256).max - denominator + 1) & denominator;
1378         // Divide denominator by power of two
1379         assembly {
1380             denominator := div(denominator, twos)
1381         }
1382 
1383         // Divide [prod1 prod0] by the factors of two
1384         assembly {
1385             prod0 := div(prod0, twos)
1386         }
1387         // Shift in bits from prod1 into prod0. For this we need
1388         // to flip `twos` such that it is 2**256 / twos.
1389         // If twos is zero, then it becomes one
1390         assembly {
1391             twos := add(div(sub(0, twos), twos), 1)
1392         }
1393         prod0 |= prod1 * twos;
1394 
1395         // Invert denominator mod 2**256
1396         // Now that denominator is an odd number, it has an inverse
1397         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
1398         // Compute the inverse by starting with a seed that is correct
1399         // correct for four bits. That is, denominator * inv = 1 mod 2**4
1400         uint256 inv = (3 * denominator) ^ 2;
1401         // Now use Newton-Raphson iteration to improve the precision.
1402         // Thanks to Hensel's lifting lemma, this also works in modular
1403         // arithmetic, doubling the correct bits in each step.
1404         inv *= 2 - denominator * inv; // inverse mod 2**8
1405         inv *= 2 - denominator * inv; // inverse mod 2**16
1406         inv *= 2 - denominator * inv; // inverse mod 2**32
1407         inv *= 2 - denominator * inv; // inverse mod 2**64
1408         inv *= 2 - denominator * inv; // inverse mod 2**128
1409         inv *= 2 - denominator * inv; // inverse mod 2**256
1410 
1411         // Because the division is now exact we can divide by multiplying
1412         // with the modular inverse of denominator. This will give us the
1413         // correct result modulo 2**256. Since the precoditions guarantee
1414         // that the outcome is less than 2**256, this is the final result.
1415         // We don't need to compute the high bits of the result and prod1
1416         // is no longer required.
1417         result = prod0 * inv;
1418         return result;
1419     }
1420 
1421     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1422     /// @param a The multiplicand
1423     /// @param b The multiplier
1424     /// @param denominator The divisor
1425     /// @return result The 256-bit result
1426     function mulDivRoundingUp(
1427         uint256 a,
1428         uint256 b,
1429         uint256 denominator
1430     ) internal pure returns (uint256 result) {
1431         result = mulDiv(a, b, denominator);
1432         if (mulmod(a, b, denominator) > 0) {
1433             require(result < type(uint256).max);
1434             result++;
1435         }
1436     }
1437 }
1438 
1439 
1440 // File contracts/Uniswap_V3/libraries/FixedPoint96.sol
1441 
1442 
1443 /// @title FixedPoint96
1444 /// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
1445 /// @dev Used in SqrtPriceMath.sol
1446 library FixedPoint96 {
1447     uint8 internal constant RESOLUTION = 96;
1448     uint256 internal constant Q96 = 0x1000000000000000000000000;
1449 }
1450 
1451 
1452 // File contracts/Uniswap_V3/libraries/LiquidityAmounts.sol
1453 
1454 
1455 
1456 /// @title Liquidity amount functions
1457 /// @notice Provides functions for computing liquidity amounts from token amounts and prices
1458 library LiquidityAmounts {
1459     /// @notice Downcasts uint256 to uint128
1460     /// @param x The uint258 to be downcasted
1461     /// @return y The passed value, downcasted to uint128
1462     function toUint128(uint256 x) private pure returns (uint128 y) {
1463         require((y = uint128(x)) == x);
1464     }
1465 
1466     /// @notice Computes the amount of liquidity received for a given amount of token0 and price range
1467     /// @dev Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))
1468     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1469     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1470     /// @param amount0 The amount0 being sent in
1471     /// @return liquidity The amount of returned liquidity
1472     function getLiquidityForAmount0(
1473         uint160 sqrtRatioAX96,
1474         uint160 sqrtRatioBX96,
1475         uint256 amount0
1476     ) internal pure returns (uint128 liquidity) {
1477         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1478         uint256 intermediate = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96);
1479         return toUint128(FullMath.mulDiv(amount0, intermediate, sqrtRatioBX96 - sqrtRatioAX96));
1480     }
1481 
1482     /// @notice Computes the amount of liquidity received for a given amount of token1 and price range
1483     /// @dev Calculates amount1 / (sqrt(upper) - sqrt(lower)).
1484     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1485     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1486     /// @param amount1 The amount1 being sent in
1487     /// @return liquidity The amount of returned liquidity
1488     function getLiquidityForAmount1(
1489         uint160 sqrtRatioAX96,
1490         uint160 sqrtRatioBX96,
1491         uint256 amount1
1492     ) internal pure returns (uint128 liquidity) {
1493         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1494         return toUint128(FullMath.mulDiv(amount1, FixedPoint96.Q96, sqrtRatioBX96 - sqrtRatioAX96));
1495     }
1496 
1497     /// @notice Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
1498     /// pool prices and the prices at the tick boundaries
1499     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
1500     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1501     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1502     /// @param amount0 The amount of token0 being sent in
1503     /// @param amount1 The amount of token1 being sent in
1504     /// @return liquidity The maximum amount of liquidity received
1505     function getLiquidityForAmounts(
1506         uint160 sqrtRatioX96,
1507         uint160 sqrtRatioAX96,
1508         uint160 sqrtRatioBX96,
1509         uint256 amount0,
1510         uint256 amount1
1511     ) internal pure returns (uint128 liquidity) {
1512         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1513 
1514         if (sqrtRatioX96 <= sqrtRatioAX96) {
1515             liquidity = getLiquidityForAmount0(sqrtRatioAX96, sqrtRatioBX96, amount0);
1516         } else if (sqrtRatioX96 < sqrtRatioBX96) {
1517             uint128 liquidity0 = getLiquidityForAmount0(sqrtRatioX96, sqrtRatioBX96, amount0);
1518             uint128 liquidity1 = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioX96, amount1);
1519 
1520             liquidity = liquidity0 < liquidity1 ? liquidity0 : liquidity1;
1521         } else {
1522             liquidity = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioBX96, amount1);
1523         }
1524     }
1525 
1526     /// @notice Computes the amount of token0 for a given amount of liquidity and a price range
1527     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1528     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1529     /// @param liquidity The liquidity being valued
1530     /// @return amount0 The amount of token0
1531     function getAmount0ForLiquidity(
1532         uint160 sqrtRatioAX96,
1533         uint160 sqrtRatioBX96,
1534         uint128 liquidity
1535     ) internal pure returns (uint256 amount0) {
1536         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1537 
1538         return
1539             FullMath.mulDiv(
1540                 uint256(liquidity) << FixedPoint96.RESOLUTION,
1541                 sqrtRatioBX96 - sqrtRatioAX96,
1542                 sqrtRatioBX96
1543             ) / sqrtRatioAX96;
1544     }
1545 
1546     /// @notice Computes the amount of token1 for a given amount of liquidity and a price range
1547     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1548     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1549     /// @param liquidity The liquidity being valued
1550     /// @return amount1 The amount of token1
1551     function getAmount1ForLiquidity(
1552         uint160 sqrtRatioAX96,
1553         uint160 sqrtRatioBX96,
1554         uint128 liquidity
1555     ) internal pure returns (uint256 amount1) {
1556         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1557 
1558         return FullMath.mulDiv(liquidity, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
1559     }
1560 
1561     /// @notice Computes the token0 and token1 value for a given amount of liquidity, the current
1562     /// pool prices and the prices at the tick boundaries
1563     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
1564     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1565     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1566     /// @param liquidity The liquidity being valued
1567     /// @return amount0 The amount of token0
1568     /// @return amount1 The amount of token1
1569     function getAmountsForLiquidity(
1570         uint160 sqrtRatioX96,
1571         uint160 sqrtRatioAX96,
1572         uint160 sqrtRatioBX96,
1573         uint128 liquidity
1574     ) internal pure returns (uint256 amount0, uint256 amount1) {
1575         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1576 
1577         if (sqrtRatioX96 <= sqrtRatioAX96) {
1578             amount0 = getAmount0ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
1579         } else if (sqrtRatioX96 < sqrtRatioBX96) {
1580             amount0 = getAmount0ForLiquidity(sqrtRatioX96, sqrtRatioBX96, liquidity);
1581             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioX96, liquidity);
1582         } else {
1583             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
1584         }
1585     }
1586 }
1587 
1588 
1589 // File contracts/ERC165/IERC165.sol
1590 
1591 
1592 
1593 /**
1594  * @dev Interface of the ERC165 standard, as defined in the
1595  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1596  *
1597  * Implementers can declare support of contract interfaces, which can then be
1598  * queried by others ({ERC165Checker}).
1599  *
1600  * For an implementation, see {ERC165}.
1601  */
1602 interface IERC165 {
1603     /**
1604      * @dev Returns true if this contract implements the interface defined by
1605      * `interfaceId`. See the corresponding
1606      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1607      * to learn more about how these ids are created.
1608      *
1609      * This function call must use less than 30 000 gas.
1610      */
1611     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1612 }
1613 
1614 
1615 // File contracts/ERC721/IERC721.sol
1616 
1617 
1618 
1619 /**
1620  * @dev Required interface of an ERC721 compliant contract.
1621  */
1622 interface IERC721 is IERC165 {
1623     /**
1624      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1625      */
1626     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1627 
1628     /**
1629      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1630      */
1631     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1632 
1633     /**
1634      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1635      */
1636     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1637 
1638     /**
1639      * @dev Returns the number of tokens in ``owner``'s account.
1640      */
1641     function balanceOf(address owner) external view returns (uint256 balance);
1642 
1643     /**
1644      * @dev Returns the owner of the `tokenId` token.
1645      *
1646      * Requirements:
1647      *
1648      * - `tokenId` must exist.
1649      */
1650     function ownerOf(uint256 tokenId) external view returns (address owner);
1651 
1652     /**
1653      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1654      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1655      *
1656      * Requirements:
1657      *
1658      * - `from` cannot be the zero address.
1659      * - `to` cannot be the zero address.
1660      * - `tokenId` token must exist and be owned by `from`.
1661      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1663      *
1664      * Emits a {Transfer} event.
1665      */
1666     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1667 
1668     /**
1669      * @dev Transfers `tokenId` token from `from` to `to`.
1670      *
1671      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1672      *
1673      * Requirements:
1674      *
1675      * - `from` cannot be the zero address.
1676      * - `to` cannot be the zero address.
1677      * - `tokenId` token must be owned by `from`.
1678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1679      *
1680      * Emits a {Transfer} event.
1681      */
1682     function transferFrom(address from, address to, uint256 tokenId) external;
1683 
1684     /**
1685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1686      * The approval is cleared when the token is transferred.
1687      *
1688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1689      *
1690      * Requirements:
1691      *
1692      * - The caller must own the token or be an approved operator.
1693      * - `tokenId` must exist.
1694      *
1695      * Emits an {Approval} event.
1696      */
1697     function approve(address to, uint256 tokenId) external;
1698 
1699     /**
1700      * @dev Returns the account approved for `tokenId` token.
1701      *
1702      * Requirements:
1703      *
1704      * - `tokenId` must exist.
1705      */
1706     function getApproved(uint256 tokenId) external view returns (address operator);
1707 
1708     /**
1709      * @dev Approve or remove `operator` as an operator for the caller.
1710      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1711      *
1712      * Requirements:
1713      *
1714      * - The `operator` cannot be the caller.
1715      *
1716      * Emits an {ApprovalForAll} event.
1717      */
1718     function setApprovalForAll(address operator, bool _approved) external;
1719 
1720     /**
1721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1722      *
1723      * See {setApprovalForAll}
1724      */
1725     function isApprovedForAll(address owner, address operator) external view returns (bool);
1726 
1727     /**
1728       * @dev Safely transfers `tokenId` token from `from` to `to`.
1729       *
1730       * Requirements:
1731       *
1732       * - `from` cannot be the zero address.
1733       * - `to` cannot be the zero address.
1734       * - `tokenId` token must exist and be owned by `from`.
1735       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1736       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1737       *
1738       * Emits a {Transfer} event.
1739       */
1740     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1741 }
1742 
1743 
1744 // File contracts/Uniswap_V3/IUniswapV3PositionsNFT.sol
1745 
1746 
1747 
1748 // Originally INonfungiblePositionManager
1749 interface IUniswapV3PositionsNFT is IERC721 {
1750     
1751     struct CollectParams {
1752         uint256 tokenId;
1753         address recipient;
1754         uint128 amount0Max;
1755         uint128 amount1Max;
1756     }
1757 
1758     /// @notice Returns the position information associated with a given token ID.
1759     /// @dev Throws if the token ID is not valid.
1760     /// @param tokenId The ID of the token that represents the position
1761     /// @return nonce The nonce for permits
1762     /// @return operator The address that is approved for spending
1763     /// @return token0 The address of the token0 for a specific pool
1764     /// @return token1 The address of the token1 for a specific pool
1765     /// @return fee The fee associated with the pool
1766     /// @return tickLower The lower end of the tick range for the position
1767     /// @return tickUpper The higher end of the tick range for the position
1768     /// @return liquidity The liquidity of the position
1769     /// @return feeGrowthInside0LastX128 The fee growth of token0 as of the last action on the individual position
1770     /// @return feeGrowthInside1LastX128 The fee growth of token1 as of the last action on the individual position
1771     /// @return tokensOwed0 The uncollected amount of token0 owed to the position as of the last computation
1772     /// @return tokensOwed1 The uncollected amount of token1 owed to the position as of the last computation
1773     function positions(uint256 tokenId)
1774         external
1775         view
1776         returns (
1777             uint96 nonce, // [0]
1778             address operator, // [1]
1779             address token0, // [2]
1780             address token1, // [3]
1781             uint24 fee, // [4]
1782             int24 tickLower, // [5]
1783             int24 tickUpper, // [6]
1784             uint128 liquidity, // [7]
1785             uint256 feeGrowthInside0LastX128, // [8]
1786             uint256 feeGrowthInside1LastX128, // [9]
1787             uint128 tokensOwed0, // [10]
1788             uint128 tokensOwed1 // [11]
1789         );
1790 
1791     /// @notice Collects up to a maximum amount of fees owed to a specific position to the recipient
1792     /// @param params tokenId The ID of the NFT for which tokens are being collected,
1793     /// recipient The account that should receive the tokens,
1794     /// amount0Max The maximum amount of token0 to collect,
1795     /// amount1Max The maximum amount of token1 to collect
1796     /// @return amount0 The amount of fees collected in token0
1797     /// @return amount1 The amount of fees collected in token1
1798     function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);
1799 }
1800 
1801 
1802 // File contracts/Uniswap_V3/pool/IUniswapV3PoolImmutables.sol
1803 
1804 
1805 /// @title Pool state that never changes
1806 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
1807 interface IUniswapV3PoolImmutables {
1808     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
1809     /// @return The contract address
1810     function factory() external view returns (address);
1811 
1812     /// @notice The first of the two tokens of the pool, sorted by address
1813     /// @return The token contract address
1814     function token0() external view returns (address);
1815 
1816     /// @notice The second of the two tokens of the pool, sorted by address
1817     /// @return The token contract address
1818     function token1() external view returns (address);
1819 
1820     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
1821     /// @return The fee
1822     function fee() external view returns (uint24);
1823 
1824     /// @notice The pool tick spacing
1825     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
1826     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
1827     /// This value is an int24 to avoid casting even though it is always positive.
1828     /// @return The tick spacing
1829     function tickSpacing() external view returns (int24);
1830 
1831     /// @notice The maximum amount of position liquidity that can use any tick in the range
1832     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
1833     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
1834     /// @return The max amount of liquidity per tick
1835     function maxLiquidityPerTick() external view returns (uint128);
1836 }
1837 
1838 
1839 // File contracts/Uniswap_V3/pool/IUniswapV3PoolState.sol
1840 
1841 
1842 /// @title Pool state that can change
1843 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
1844 /// per transaction
1845 interface IUniswapV3PoolState {
1846     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
1847     /// when accessed externally.
1848     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
1849     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
1850     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
1851     /// boundary.
1852     /// observationIndex The index of the last oracle observation that was written,
1853     /// observationCardinality The current maximum number of observations stored in the pool,
1854     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
1855     /// feeProtocol The protocol fee for both tokens of the pool.
1856     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
1857     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
1858     /// unlocked Whether the pool is currently locked to reentrancy
1859     function slot0()
1860         external
1861         view
1862         returns (
1863             uint160 sqrtPriceX96,
1864             int24 tick,
1865             uint16 observationIndex,
1866             uint16 observationCardinality,
1867             uint16 observationCardinalityNext,
1868             uint8 feeProtocol,
1869             bool unlocked
1870         );
1871 
1872     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
1873     /// @dev This value can overflow the uint256
1874     function feeGrowthGlobal0X128() external view returns (uint256);
1875 
1876     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
1877     /// @dev This value can overflow the uint256
1878     function feeGrowthGlobal1X128() external view returns (uint256);
1879 
1880     /// @notice The amounts of token0 and token1 that are owed to the protocol
1881     /// @dev Protocol fees will never exceed uint128 max in either token
1882     function protocolFees() external view returns (uint128 token0, uint128 token1);
1883 
1884     /// @notice The currently in range liquidity available to the pool
1885     /// @dev This value has no relationship to the total liquidity across all ticks
1886     function liquidity() external view returns (uint128);
1887 
1888     /// @notice Look up information about a specific tick in the pool
1889     /// @param tick The tick to look up
1890     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
1891     /// tick upper,
1892     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
1893     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
1894     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
1895     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
1896     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
1897     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
1898     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
1899     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
1900     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
1901     /// a specific position.
1902     function ticks(int24 tick)
1903         external
1904         view
1905         returns (
1906             uint128 liquidityGross,
1907             int128 liquidityNet,
1908             uint256 feeGrowthOutside0X128,
1909             uint256 feeGrowthOutside1X128,
1910             int56 tickCumulativeOutside,
1911             uint160 secondsPerLiquidityOutsideX128,
1912             uint32 secondsOutside,
1913             bool initialized
1914         );
1915 
1916     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
1917     function tickBitmap(int16 wordPosition) external view returns (uint256);
1918 
1919     /// @notice Returns the information about a position by the position's key
1920     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
1921     /// @return _liquidity The amount of liquidity in the position,
1922     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
1923     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
1924     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
1925     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
1926     function positions(bytes32 key)
1927         external
1928         view
1929         returns (
1930             uint128 _liquidity,
1931             uint256 feeGrowthInside0LastX128,
1932             uint256 feeGrowthInside1LastX128,
1933             uint128 tokensOwed0,
1934             uint128 tokensOwed1
1935         );
1936 
1937     /// @notice Returns data about a specific observation index
1938     /// @param index The element of the observations array to fetch
1939     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
1940     /// ago, rather than at a specific index in the array.
1941     /// @return blockTimestamp The timestamp of the observation,
1942     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
1943     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
1944     /// Returns initialized whether the observation has been initialized and the values are safe to use
1945     function observations(uint256 index)
1946         external
1947         view
1948         returns (
1949             uint32 blockTimestamp,
1950             int56 tickCumulative,
1951             uint160 secondsPerLiquidityCumulativeX128,
1952             bool initialized
1953         );
1954 }
1955 
1956 
1957 // File contracts/Uniswap_V3/pool/IUniswapV3PoolDerivedState.sol
1958 
1959 
1960 /// @title Pool state that is not stored
1961 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
1962 /// blockchain. The functions here may have variable gas costs.
1963 interface IUniswapV3PoolDerivedState {
1964     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
1965     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
1966     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
1967     /// you must call it with secondsAgos = [3600, 0].
1968     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
1969     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
1970     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
1971     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
1972     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
1973     /// timestamp
1974     function observe(uint32[] calldata secondsAgos)
1975         external
1976         view
1977         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
1978 
1979     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
1980     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
1981     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
1982     /// snapshot is taken and the second snapshot is taken.
1983     /// @param tickLower The lower tick of the range
1984     /// @param tickUpper The upper tick of the range
1985     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
1986     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
1987     /// @return secondsInside The snapshot of seconds per liquidity for the range
1988     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
1989         external
1990         view
1991         returns (
1992             int56 tickCumulativeInside,
1993             uint160 secondsPerLiquidityInsideX128,
1994             uint32 secondsInside
1995         );
1996 }
1997 
1998 
1999 // File contracts/Uniswap_V3/pool/IUniswapV3PoolActions.sol
2000 
2001 
2002 /// @title Permissionless pool actions
2003 /// @notice Contains pool methods that can be called by anyone
2004 interface IUniswapV3PoolActions {
2005     /// @notice Sets the initial price for the pool
2006     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
2007     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
2008     function initialize(uint160 sqrtPriceX96) external;
2009 
2010     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
2011     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
2012     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
2013     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
2014     /// @param recipient The address for which the liquidity will be created
2015     /// @param tickLower The lower tick of the position in which to add liquidity
2016     /// @param tickUpper The upper tick of the position in which to add liquidity
2017     /// @param amount The amount of liquidity to mint
2018     /// @param data Any data that should be passed through to the callback
2019     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
2020     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
2021     function mint(
2022         address recipient,
2023         int24 tickLower,
2024         int24 tickUpper,
2025         uint128 amount,
2026         bytes calldata data
2027     ) external returns (uint256 amount0, uint256 amount1);
2028 
2029     /// @notice Collects tokens owed to a position
2030     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
2031     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
2032     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
2033     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
2034     /// @param recipient The address which should receive the fees collected
2035     /// @param tickLower The lower tick of the position for which to collect fees
2036     /// @param tickUpper The upper tick of the position for which to collect fees
2037     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
2038     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
2039     /// @return amount0 The amount of fees collected in token0
2040     /// @return amount1 The amount of fees collected in token1
2041     function collect(
2042         address recipient,
2043         int24 tickLower,
2044         int24 tickUpper,
2045         uint128 amount0Requested,
2046         uint128 amount1Requested
2047     ) external returns (uint128 amount0, uint128 amount1);
2048 
2049     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
2050     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
2051     /// @dev Fees must be collected separately via a call to #collect
2052     /// @param tickLower The lower tick of the position for which to burn liquidity
2053     /// @param tickUpper The upper tick of the position for which to burn liquidity
2054     /// @param amount How much liquidity to burn
2055     /// @return amount0 The amount of token0 sent to the recipient
2056     /// @return amount1 The amount of token1 sent to the recipient
2057     function burn(
2058         int24 tickLower,
2059         int24 tickUpper,
2060         uint128 amount
2061     ) external returns (uint256 amount0, uint256 amount1);
2062 
2063     /// @notice Swap token0 for token1, or token1 for token0
2064     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
2065     /// @param recipient The address to receive the output of the swap
2066     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
2067     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
2068     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
2069     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
2070     /// @param data Any data to be passed through to the callback
2071     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
2072     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
2073     function swap(
2074         address recipient,
2075         bool zeroForOne,
2076         int256 amountSpecified,
2077         uint160 sqrtPriceLimitX96,
2078         bytes calldata data
2079     ) external returns (int256 amount0, int256 amount1);
2080 
2081     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
2082     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
2083     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
2084     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
2085     /// @param recipient The address which will receive the token0 and token1 amounts
2086     /// @param amount0 The amount of token0 to send
2087     /// @param amount1 The amount of token1 to send
2088     /// @param data Any data to be passed through to the callback
2089     function flash(
2090         address recipient,
2091         uint256 amount0,
2092         uint256 amount1,
2093         bytes calldata data
2094     ) external;
2095 
2096     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
2097     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
2098     /// the input observationCardinalityNext.
2099     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
2100     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
2101 }
2102 
2103 
2104 // File contracts/Uniswap_V3/pool/IUniswapV3PoolOwnerActions.sol
2105 
2106 
2107 /// @title Permissioned pool actions
2108 /// @notice Contains pool methods that may only be called by the factory owner
2109 interface IUniswapV3PoolOwnerActions {
2110     /// @notice Set the denominator of the protocol's % share of the fees
2111     /// @param feeProtocol0 new protocol fee for token0 of the pool
2112     /// @param feeProtocol1 new protocol fee for token1 of the pool
2113     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
2114 
2115     /// @notice Collect the protocol fee accrued to the pool
2116     /// @param recipient The address to which collected protocol fees should be sent
2117     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
2118     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
2119     /// @return amount0 The protocol fee collected in token0
2120     /// @return amount1 The protocol fee collected in token1
2121     function collectProtocol(
2122         address recipient,
2123         uint128 amount0Requested,
2124         uint128 amount1Requested
2125     ) external returns (uint128 amount0, uint128 amount1);
2126 }
2127 
2128 
2129 // File contracts/Uniswap_V3/pool/IUniswapV3PoolEvents.sol
2130 
2131 
2132 /// @title Events emitted by a pool
2133 /// @notice Contains all events emitted by the pool
2134 interface IUniswapV3PoolEvents {
2135     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
2136     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
2137     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
2138     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
2139     event Initialize(uint160 sqrtPriceX96, int24 tick);
2140 
2141     /// @notice Emitted when liquidity is minted for a given position
2142     /// @param sender The address that minted the liquidity
2143     /// @param owner The owner of the position and recipient of any minted liquidity
2144     /// @param tickLower The lower tick of the position
2145     /// @param tickUpper The upper tick of the position
2146     /// @param amount The amount of liquidity minted to the position range
2147     /// @param amount0 How much token0 was required for the minted liquidity
2148     /// @param amount1 How much token1 was required for the minted liquidity
2149     event Mint(
2150         address sender,
2151         address indexed owner,
2152         int24 indexed tickLower,
2153         int24 indexed tickUpper,
2154         uint128 amount,
2155         uint256 amount0,
2156         uint256 amount1
2157     );
2158 
2159     /// @notice Emitted when fees are collected by the owner of a position
2160     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
2161     /// @param owner The owner of the position for which fees are collected
2162     /// @param tickLower The lower tick of the position
2163     /// @param tickUpper The upper tick of the position
2164     /// @param amount0 The amount of token0 fees collected
2165     /// @param amount1 The amount of token1 fees collected
2166     event Collect(
2167         address indexed owner,
2168         address recipient,
2169         int24 indexed tickLower,
2170         int24 indexed tickUpper,
2171         uint128 amount0,
2172         uint128 amount1
2173     );
2174 
2175     /// @notice Emitted when a position's liquidity is removed
2176     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
2177     /// @param owner The owner of the position for which liquidity is removed
2178     /// @param tickLower The lower tick of the position
2179     /// @param tickUpper The upper tick of the position
2180     /// @param amount The amount of liquidity to remove
2181     /// @param amount0 The amount of token0 withdrawn
2182     /// @param amount1 The amount of token1 withdrawn
2183     event Burn(
2184         address indexed owner,
2185         int24 indexed tickLower,
2186         int24 indexed tickUpper,
2187         uint128 amount,
2188         uint256 amount0,
2189         uint256 amount1
2190     );
2191 
2192     /// @notice Emitted by the pool for any swaps between token0 and token1
2193     /// @param sender The address that initiated the swap call, and that received the callback
2194     /// @param recipient The address that received the output of the swap
2195     /// @param amount0 The delta of the token0 balance of the pool
2196     /// @param amount1 The delta of the token1 balance of the pool
2197     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
2198     /// @param liquidity The liquidity of the pool after the swap
2199     /// @param tick The log base 1.0001 of price of the pool after the swap
2200     event Swap(
2201         address indexed sender,
2202         address indexed recipient,
2203         int256 amount0,
2204         int256 amount1,
2205         uint160 sqrtPriceX96,
2206         uint128 liquidity,
2207         int24 tick
2208     );
2209 
2210     /// @notice Emitted by the pool for any flashes of token0/token1
2211     /// @param sender The address that initiated the swap call, and that received the callback
2212     /// @param recipient The address that received the tokens from flash
2213     /// @param amount0 The amount of token0 that was flashed
2214     /// @param amount1 The amount of token1 that was flashed
2215     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
2216     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
2217     event Flash(
2218         address indexed sender,
2219         address indexed recipient,
2220         uint256 amount0,
2221         uint256 amount1,
2222         uint256 paid0,
2223         uint256 paid1
2224     );
2225 
2226     /// @notice Emitted by the pool for increases to the number of observations that can be stored
2227     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
2228     /// just before a mint/swap/burn.
2229     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
2230     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
2231     event IncreaseObservationCardinalityNext(
2232         uint16 observationCardinalityNextOld,
2233         uint16 observationCardinalityNextNew
2234     );
2235 
2236     /// @notice Emitted when the protocol fee is changed by the pool
2237     /// @param feeProtocol0Old The previous value of the token0 protocol fee
2238     /// @param feeProtocol1Old The previous value of the token1 protocol fee
2239     /// @param feeProtocol0New The updated value of the token0 protocol fee
2240     /// @param feeProtocol1New The updated value of the token1 protocol fee
2241     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
2242 
2243     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
2244     /// @param sender The address that collects the protocol fees
2245     /// @param recipient The address that receives the collected protocol fees
2246     /// @param amount0 The amount of token0 protocol fees that is withdrawn
2247     /// @param amount0 The amount of token1 protocol fees that is withdrawn
2248     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
2249 }
2250 
2251 
2252 // File contracts/Uniswap_V3/IUniswapV3Pool.sol
2253 
2254 
2255 
2256 
2257 
2258 
2259 
2260 /// @title The interface for a Uniswap V3 Pool
2261 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
2262 /// to the ERC20 specification
2263 /// @dev The pool interface is broken up into many smaller pieces
2264 interface IUniswapV3Pool is
2265     IUniswapV3PoolImmutables,
2266     IUniswapV3PoolState,
2267     IUniswapV3PoolDerivedState,
2268     IUniswapV3PoolActions,
2269     IUniswapV3PoolOwnerActions,
2270     IUniswapV3PoolEvents
2271 {
2272 
2273 }
2274 
2275 
2276 // File contracts/Utils/ReentrancyGuard.sol
2277 
2278 
2279 /**
2280  * @dev Contract module that helps prevent reentrant calls to a function.
2281  *
2282  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2283  * available, which can be applied to functions to make sure there are no nested
2284  * (reentrant) calls to them.
2285  *
2286  * Note that because there is a single `nonReentrant` guard, functions marked as
2287  * `nonReentrant` may not call one another. This can be worked around by making
2288  * those functions `private`, and then adding `external` `nonReentrant` entry
2289  * points to them.
2290  *
2291  * TIP: If you would like to learn more about reentrancy and alternative ways
2292  * to protect against it, check out our blog post
2293  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2294  */
2295 abstract contract ReentrancyGuard {
2296     // Booleans are more expensive than uint256 or any type that takes up a full
2297     // word because each write operation emits an extra SLOAD to first read the
2298     // slot's contents, replace the bits taken up by the boolean, and then write
2299     // back. This is the compiler's defense against contract upgrades and
2300     // pointer aliasing, and it cannot be disabled.
2301 
2302     // The values being non-zero value makes deployment a bit more expensive,
2303     // but in exchange the refund on every call to nonReentrant will be lower in
2304     // amount. Since refunds are capped to a percentage of the total
2305     // transaction's gas, it is best to keep them low in cases like this one, to
2306     // increase the likelihood of the full refund coming into effect.
2307     uint256 private constant _NOT_ENTERED = 1;
2308     uint256 private constant _ENTERED = 2;
2309 
2310     uint256 private _status;
2311 
2312     constructor () internal {
2313         _status = _NOT_ENTERED;
2314     }
2315 
2316     /**
2317      * @dev Prevents a contract from calling itself, directly or indirectly.
2318      * Calling a `nonReentrant` function from another `nonReentrant`
2319      * function is not supported. It is possible to prevent this from happening
2320      * by making the `nonReentrant` function external, and make it call a
2321      * `private` function that does the actual work.
2322      */
2323     modifier nonReentrant() {
2324         // On the first call to nonReentrant, _notEntered will be true
2325         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2326 
2327         // Any calls to nonReentrant after this point will fail
2328         _status = _ENTERED;
2329 
2330         _;
2331 
2332         // By storing the original value once again, a refund is triggered (see
2333         // https://eips.ethereum.org/EIPS/eip-2200)
2334         _status = _NOT_ENTERED;
2335     }
2336 }
2337 
2338 
2339 // File contracts/Staking/Owned.sol
2340 
2341 
2342 // https://docs.synthetix.io/contracts/Owned
2343 contract Owned {
2344     address public owner;
2345     address public nominatedOwner;
2346 
2347     constructor (address _owner) public {
2348         require(_owner != address(0), "Owner address cannot be 0");
2349         owner = _owner;
2350         emit OwnerChanged(address(0), _owner);
2351     }
2352 
2353     function nominateNewOwner(address _owner) external onlyOwner {
2354         nominatedOwner = _owner;
2355         emit OwnerNominated(_owner);
2356     }
2357 
2358     function acceptOwnership() external {
2359         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
2360         emit OwnerChanged(owner, nominatedOwner);
2361         owner = nominatedOwner;
2362         nominatedOwner = address(0);
2363     }
2364 
2365     modifier onlyOwner {
2366         require(msg.sender == owner, "Only the contract owner may perform this action");
2367         _;
2368     }
2369 
2370     event OwnerNominated(address newOwner);
2371     event OwnerChanged(address oldOwner, address newOwner);
2372 }
2373 
2374 
2375 // File contracts/Staking/FraxUniV3Farm_Stable.sol
2376 
2377 pragma experimental ABIEncoderV2;
2378 
2379 // ====================================================================
2380 // |     ______                   _______                             |
2381 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
2382 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
2383 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
2384 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
2385 // |                                                                  |
2386 // ====================================================================
2387 // =========================== FraxUniV3Farm_Stable ==========================
2388 // ====================================================================
2389 // Migratable Farming contract that accounts for veFXS and UniswapV3 NFTs
2390 // Only one possible reward token here (usually FXS), to cut gas costs
2391 // Also, because of the nonfungible nature, and to reduce gas, unlocked staking was removed
2392 // You can lock for as short as 1 day now, which is de-facto an unlocked stake
2393 
2394 // Frax Finance: https://github.com/FraxFinance
2395 
2396 // Primary Author(s)
2397 // Travis Moore: https://github.com/FortisFortuna
2398 
2399 // Reviewer(s) / Contributor(s)
2400 // Jason Huan: https://github.com/jasonhuan
2401 // Sam Kazemian: https://github.com/samkazemian
2402 // Dennis: github.com/denett
2403 // Sam Sun: https://github.com/samczsun
2404 
2405 // Originally inspired by Synthetix.io, but heavily modified by the Frax team
2406 // (Locked, veFXS, and UniV3 portions are new)
2407 // https://raw.githubusercontent.com/Synthetixio/synthetix/develop/contracts/StakingRewards.sol
2408 
2409 
2410 
2411 
2412 
2413 
2414 
2415 
2416 
2417 
2418 
2419 
2420 
2421 
2422 contract FraxUniV3Farm_Stable is Owned, ReentrancyGuard {
2423     using SafeMath for uint256;
2424     using SafeERC20 for ERC20;
2425 
2426     /* ========== STATE VARIABLES ========== */
2427 
2428     // Instances
2429     IveFXS private veFXS = IveFXS(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0);
2430     ERC20 private rewardsToken0 = ERC20(0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0);
2431     IFraxGaugeController public gauge_controller;
2432     IFraxGaugeFXSRewardsDistributor public rewards_distributor;
2433     IUniswapV3PositionsNFT private stakingTokenNFT = IUniswapV3PositionsNFT(0xC36442b4a4522E871399CD717aBDD847Ab11FE88); // UniV3 uses an NFT
2434     IUniswapV3Pool private lp_pool;
2435 
2436     // Admin addresses
2437     address public timelock_address;
2438     address public curator_address;
2439 
2440     // Constant for various precisions
2441     uint256 private constant MULTIPLIER_PRECISION = 1e18;
2442     int256 private constant EMISSION_FACTOR_PRECISION = 1e18;
2443 
2444     // Reward and period related
2445     uint256 private periodFinish;
2446     uint256 private lastUpdateTime;
2447     uint256 private reward_rate_manual;
2448     uint256 public rewardsDuration = 604800; // 7 * 86400  (7 days)
2449 
2450     // Lock time and multiplier settings
2451     uint256 public lock_max_multiplier = uint256(3e18); // E18. 1x = 1e18
2452     uint256 public lock_time_for_max_multiplier = 3 * 365 * 86400; // 3 years
2453     uint256 public lock_time_min = 86400; // 1 * 86400  (1 day)
2454 
2455     // veFXS related
2456     uint256 public vefxs_per_frax_for_max_boost = uint256(4e18); // E18. 4e18 means 4 veFXS must be held by the staker per 1 FRAX
2457     uint256 public vefxs_max_multiplier = uint256(2e18); // E18. 1x = 1e18
2458     mapping(address => uint256) private _vefxsMultiplierStored;
2459 
2460     // Uniswap V3 related
2461     int24 public uni_tick_lower;
2462     int24 public uni_tick_upper;
2463     int24 public ideal_tick;
2464     uint24 public uni_required_fee;
2465     address public uni_token0;
2466     address public uni_token1;
2467     uint32 public twap_duration = 300; // 5 minutes
2468     bool public frax_is_token0 = false;
2469 
2470     // Rewards tracking
2471     uint256 private rewardPerTokenStored0;
2472     mapping(address => uint256) private userRewardPerTokenPaid0;
2473     mapping(address => uint256) private rewards0;
2474     uint256 private last_gauge_relative_weight;
2475     uint256 private last_gauge_time_total;
2476 
2477     // Balance, stake, and weight tracking
2478     uint256 private _total_liquidity_locked;
2479     uint256 private _total_combined_weight;
2480     mapping(address => uint256) private _locked_liquidity;
2481     mapping(address => uint256) private _combined_weights;
2482     mapping(address => LockedNFT[]) private lockedNFTs;
2483 
2484     // List of valid migrators (set by governance)
2485     mapping(address => bool) private valid_migrators;
2486     address[] private valid_migrators_array;
2487 
2488     // Stakers set which migrator(s) they want to use
2489     mapping(address => mapping(address => bool)) private staker_allowed_migrators;
2490 
2491     // Greylists
2492     mapping(address => bool) private greylist;
2493 
2494     // Admin booleans for emergencies, migrations, and overrides
2495     bool public bypassEmissionFactor;
2496     bool public migrationsOn; // Used for migrations. Prevents new stakes, but allows LP and reward withdrawals
2497     bool public stakesUnlocked; // Release locked stakes in case of system migration or emergency
2498     bool public stakingPaused;
2499     bool public withdrawalsPaused;
2500     bool public rewardsCollectionPaused;
2501 
2502     // Struct for the stake
2503     struct LockedNFT {
2504         uint256 token_id; // for Uniswap V3 LPs
2505         uint256 liquidity;
2506         uint256 start_timestamp;
2507         uint256 ending_timestamp;
2508         uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
2509         int24 tick_lower;
2510         int24 tick_upper;
2511     }
2512 
2513     /* ========== MODIFIERS ========== */
2514 
2515     modifier onlyByOwnGov() {
2516         require(msg.sender == owner || msg.sender == timelock_address, "Not owner or timelock");
2517         _;
2518     }
2519 
2520     modifier onlyByOwnerOrCuratorOrGovernance() {
2521         require(msg.sender == owner || msg.sender == curator_address || msg.sender == timelock_address, "Not owner, curator, or timelock");
2522         _;
2523     }
2524 
2525     modifier isMigrating() {
2526         require(migrationsOn == true, "Not in migration");
2527         _;
2528     }
2529 
2530     modifier updateRewardAndBalance(address account, bool sync_too) {
2531         _updateRewardAndBalance(account, sync_too);
2532         _;
2533     }
2534 
2535     /* ========== CONSTRUCTOR ========== */
2536 
2537     constructor (
2538         address _owner,
2539         address _lp_pool_address,
2540         address _timelock_address,
2541         address _rewards_distributor_address,
2542         int24 _uni_tick_lower,
2543         int24 _uni_tick_upper,
2544         int24 _uni_ideal_tick
2545     ) Owned(_owner) {
2546         rewards_distributor = IFraxGaugeFXSRewardsDistributor(_rewards_distributor_address);
2547         lp_pool = IUniswapV3Pool(_lp_pool_address); // call getPool(token0, token1, fee) on the Uniswap V3 Factory (0x1F98431c8aD98523631AE4a59f267346ea31F984) to get this otherwise
2548         timelock_address = _timelock_address;
2549 
2550         // Set the UniV3 addresses
2551         uni_token0 = lp_pool.token0();
2552         uni_token1 = lp_pool.token1();
2553 
2554         // Check where FRAX is
2555         if (uni_token0 == 0x853d955aCEf822Db058eb8505911ED77F175b99e) frax_is_token0 = true;
2556 
2557         // Fee, Tick, and Liquidity related
2558         uni_required_fee = lp_pool.fee();
2559         uni_tick_lower = _uni_tick_lower;
2560         uni_tick_upper = _uni_tick_upper;
2561         
2562         // Closest tick to 1
2563         ideal_tick = _uni_ideal_tick;
2564 
2565         // Manual reward rate
2566         reward_rate_manual = 0; // (uint256(365e17)).div(365 * 86400); // 0.1 FXS per day
2567 
2568         // Initialize
2569         lastUpdateTime = block.timestamp;
2570         periodFinish = block.timestamp.add(rewardsDuration);
2571     }
2572 
2573     /* ========== VIEWS ========== */
2574 
2575     // User locked liquidity tokens
2576     function totalLiquidityLocked() external view returns (uint256) {
2577         return _total_liquidity_locked;
2578     }
2579 
2580     // Total locked liquidity tokens
2581     function lockedLiquidityOf(address account) external view returns (uint256) {
2582         return _locked_liquidity[account];
2583     }
2584 
2585     // Total 'balance' used for calculating the percent of the pool the account owns
2586     // Takes into account the locked stake time multiplier and veFXS multiplier
2587     function combinedWeightOf(address account) external view returns (uint256) {
2588         return _combined_weights[account];
2589     }
2590 
2591     // Total combined weight
2592     function totalCombinedWeight() external view returns (uint256) {
2593         return _total_combined_weight;
2594     }
2595 
2596     function lockMultiplier(uint256 secs) public view returns (uint256) {
2597         uint256 lock_multiplier =
2598             uint256(MULTIPLIER_PRECISION).add(
2599                 secs.mul(lock_max_multiplier.sub(MULTIPLIER_PRECISION)).div(
2600                     lock_time_for_max_multiplier
2601                 )
2602             );
2603         if (lock_multiplier > lock_max_multiplier) lock_multiplier = lock_max_multiplier;
2604         return lock_multiplier;
2605     }
2606 
2607     function userStakedFrax(address account) public view returns (uint256) {
2608         uint256 frax_tally = 0;
2609         LockedNFT memory thisNFT;
2610         for (uint256 i = 0; i < lockedNFTs[account].length; i++) {
2611             thisNFT = lockedNFTs[account][i];
2612             uint256 this_liq = thisNFT.liquidity;
2613             if (this_liq > 0){
2614                 uint160 sqrtRatioAX96 = TickMath.getSqrtRatioAtTick(thisNFT.tick_lower);
2615                 uint160 sqrtRatioBX96 = TickMath.getSqrtRatioAtTick(thisNFT.tick_upper);
2616                 if (frax_is_token0){
2617                     frax_tally = frax_tally.add(LiquidityAmounts.getAmount0ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, uint128(thisNFT.liquidity)));
2618                 }
2619                 else {
2620                     frax_tally = frax_tally.add(LiquidityAmounts.getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, uint128(thisNFT.liquidity)));
2621                 }
2622             }
2623         }
2624 
2625         // In order to avoid excessive gas calculations and the input tokens ratios. 50% FRAX is assumed
2626         // If this were Uni V2, it would be akin to reserve0 & reserve1 math
2627         // There may be a more accurate way to calculate the above...
2628         return frax_tally.div(2); 
2629     }
2630 
2631     // Will return MULTIPLIER_PRECISION if the pool is balanced, a smaller fraction if between the ticks,
2632     // and zero outside of the ticks
2633     function emissionFactor() public view returns (uint256 emission_factor){
2634         // If the bypass is turned on, return 1x
2635         if (bypassEmissionFactor) return MULTIPLIER_PRECISION;
2636 
2637         // From https://github.com/charmfinance/alpha-vaults-contracts/blob/main/contracts/AlphaStrategy.sol
2638         uint32[] memory secondsAgo = new uint32[](2);
2639         secondsAgo[0] = uint32(twap_duration);
2640         secondsAgo[1] = 0;
2641 
2642         // Make sure observationCardinalityNext has enough points on the lp_pool first
2643         // Otherwise, any observation greater then 0 will return 0 values
2644         (int56[] memory tickCumulatives, ) = lp_pool.observe(secondsAgo);
2645         int24 avg_tick = int24((tickCumulatives[1] - tickCumulatives[0]) / int32(twap_duration));
2646 
2647         // Return 0 if out of bounds (de-pegged)
2648         if (avg_tick <= uni_tick_lower) return 0;
2649         if (avg_tick >= uni_tick_upper) return 0;
2650 
2651         // Price = (1e18 / 1e6) * 1.0001^(tick)
2652         // Tick = Math.Floor(Log[base 1.0001] of (price / (10 ** decimal difference)))
2653         // Unsafe math, but there is a safety check later
2654         int256 em_factor_int256;
2655         if (avg_tick <= ideal_tick){
2656             em_factor_int256 = (EMISSION_FACTOR_PRECISION * (avg_tick - uni_tick_lower)) / (ideal_tick - uni_tick_lower);
2657         }
2658         else {
2659             em_factor_int256 = (EMISSION_FACTOR_PRECISION * (uni_tick_upper - avg_tick)) / (uni_tick_upper - ideal_tick);
2660         }
2661 
2662         // Check for negatives
2663         if (em_factor_int256 < 0) emission_factor = uint256(-1 * em_factor_int256);
2664         else emission_factor = uint256(em_factor_int256);
2665 
2666         // Sanity checks
2667         require(emission_factor <= MULTIPLIER_PRECISION, "Emission factor too high");
2668         require(emission_factor >= 0, "Emission factor too low");
2669     }
2670 
2671     function minVeFXSForMaxBoost(address account) public view returns (uint256) {
2672         return (userStakedFrax(account)).mul(vefxs_per_frax_for_max_boost).div(MULTIPLIER_PRECISION);
2673     }
2674 
2675     function veFXSMultiplier(address account) public view returns (uint256) {
2676         // The claimer gets a boost depending on amount of veFXS they have relative to the amount of FRAX 'inside'
2677         // of their locked LP tokens
2678         uint256 veFXS_needed_for_max_boost = minVeFXSForMaxBoost(account);
2679         if (veFXS_needed_for_max_boost > 0){ 
2680             uint256 user_vefxs_fraction = (veFXS.balanceOf(account)).mul(MULTIPLIER_PRECISION).div(veFXS_needed_for_max_boost);
2681             
2682             uint256 vefxs_multiplier = ((user_vefxs_fraction).mul(vefxs_max_multiplier)).div(MULTIPLIER_PRECISION);
2683 
2684             // Cap the boost to the vefxs_max_multiplier
2685             if (vefxs_multiplier > vefxs_max_multiplier) vefxs_multiplier = vefxs_max_multiplier;
2686 
2687             return vefxs_multiplier;        
2688         }
2689         else return 0; // This will happen with the first stake, when user_staked_frax is 0
2690     }
2691 
2692     function checkUniV3NFT(uint256 token_id, bool fail_if_false) internal view returns (bool is_valid, uint256 liquidity, int24 tick_lower, int24 tick_upper) {
2693         (
2694             ,
2695             ,
2696             address token0,
2697             address token1,
2698             uint24 fee,
2699             int24 tickLower,
2700             int24 tickUpper,
2701             uint256 _liquidity,
2702             ,
2703             ,
2704             ,
2705 
2706         ) = stakingTokenNFT.positions(token_id);
2707 
2708         // Set initially
2709         is_valid = false;
2710         liquidity = _liquidity;
2711 
2712         // Do the checks
2713         if (
2714             (token0 == uni_token0) && 
2715             (token1 == uni_token1) && 
2716             (fee == uni_required_fee) && 
2717             (tickLower == uni_tick_lower) && 
2718             (tickUpper == uni_tick_upper)
2719         ) {
2720             is_valid = true;
2721         }
2722         else {
2723             // More detailed messages removed here to save space
2724             if (fail_if_false) {
2725                 revert("Wrong token characteristics");
2726             }
2727         }
2728         return (is_valid, liquidity, tickLower, tickUpper);
2729     }
2730 
2731     // Return all of the locked NFT positions
2732     function lockedNFTsOf(address account) external view returns (LockedNFT[] memory) {
2733         return lockedNFTs[account];
2734     }
2735 
2736     function calcCurCombinedWeight(address account) public view
2737         returns (
2738             uint256 old_combined_weight,
2739             uint256 new_vefxs_multiplier,
2740             uint256 new_combined_weight
2741         )
2742     {
2743         // Get the old combined weight
2744         old_combined_weight = _combined_weights[account];
2745 
2746         // Get the veFXS multipliers
2747         // For the calculations, use the midpoint (analogous to midpoint Riemann sum)
2748         new_vefxs_multiplier = veFXSMultiplier(account);
2749         
2750         uint256 midpoint_vefxs_multiplier;
2751         if (_locked_liquidity[account] == 0 && _combined_weights[account] == 0) {
2752             // This is only called for the first stake to make sure the veFXS multiplier is not cut in half
2753             midpoint_vefxs_multiplier = new_vefxs_multiplier;
2754         }
2755         else {
2756             midpoint_vefxs_multiplier = ((new_vefxs_multiplier).add(_vefxsMultiplierStored[account])).div(2);
2757         }
2758 
2759         // Loop through the locked stakes, first by getting the liquidity * lock_multiplier portion
2760         new_combined_weight = 0;
2761         for (uint256 i = 0; i < lockedNFTs[account].length; i++) {
2762             LockedNFT memory thisNFT = lockedNFTs[account][i];
2763             uint256 lock_multiplier = thisNFT.lock_multiplier;
2764 
2765             // If the lock period is over, drop the lock multiplier down to 1x for the weight calculations
2766             if (thisNFT.ending_timestamp <= block.timestamp){
2767                 lock_multiplier = MULTIPLIER_PRECISION;
2768             }
2769 
2770             uint256 liquidity = thisNFT.liquidity;
2771             uint256 combined_boosted_amount = liquidity.mul(lock_multiplier.add(midpoint_vefxs_multiplier)).div(MULTIPLIER_PRECISION);
2772             new_combined_weight = new_combined_weight.add(combined_boosted_amount);
2773         }
2774     }
2775 
2776     function lastTimeRewardApplicable() internal view returns (uint256) {
2777         return Math.min(block.timestamp, periodFinish);
2778     }
2779 
2780     function rewardPerToken() internal view returns (uint256) {
2781         if (_total_liquidity_locked == 0 || _total_combined_weight == 0) {
2782             return rewardPerTokenStored0;
2783         } else {
2784             return (
2785                 rewardPerTokenStored0.add(
2786                     lastTimeRewardApplicable()
2787                         .sub(lastUpdateTime)
2788                         .mul(rewardRate0())
2789                         .mul(emissionFactor()) // has 1e18 already
2790                         .div(_total_combined_weight)
2791                 )
2792             );
2793         }
2794     }
2795 
2796     function earned(address account) public view returns (uint256) {
2797         uint256 earned_reward_0 = rewardPerToken();
2798         return (
2799             _combined_weights[account]
2800                 .mul(earned_reward_0.sub(userRewardPerTokenPaid0[account]))
2801                 .div(1e18)
2802                 .add(rewards0[account])
2803         );
2804     }
2805 
2806     function rewardRate0() public view returns (uint256 rwd_rate) {
2807         if (address(gauge_controller) != address(0)) {
2808             rwd_rate = (gauge_controller.global_emission_rate()).mul(last_gauge_relative_weight).div(1e18);
2809         }
2810         else {
2811             rwd_rate = reward_rate_manual;
2812         }
2813     }
2814 
2815     function getRewardForDuration() external view returns (uint256) {
2816         return rewardRate0().mul(rewardsDuration);
2817     }
2818 
2819     // Needed to indicate that this contract is ERC721 compatible
2820     function onERC721Received(
2821         address,
2822         address,
2823         uint256,
2824         bytes memory
2825     ) public pure returns (bytes4) {
2826         return this.onERC721Received.selector;
2827     }
2828 
2829     /* ========== MUTATIVE FUNCTIONS ========== */
2830 
2831     function _updateRewardAndBalance(address account, bool sync_too) internal {
2832         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
2833         if (sync_too){
2834             sync();
2835         }
2836         
2837         if (account != address(0)) {
2838             // To keep the math correct, the user's combined weight must be recomputed to account for their
2839             // ever-changing veFXS balance.
2840             (   
2841                 uint256 old_combined_weight,
2842                 uint256 new_vefxs_multiplier,
2843                 uint256 new_combined_weight
2844             ) = calcCurCombinedWeight(account);
2845 
2846             // Calculate the earnings first
2847             _syncEarned(account);
2848 
2849             // Update the user's stored veFXS multipliers
2850             _vefxsMultiplierStored[account] = new_vefxs_multiplier;
2851 
2852             // Update the user's and the global combined weights
2853             if (new_combined_weight >= old_combined_weight) {
2854                 uint256 weight_diff = new_combined_weight.sub(old_combined_weight);
2855                 _total_combined_weight = _total_combined_weight.add(weight_diff);
2856                 _combined_weights[account] = old_combined_weight.add(weight_diff);
2857             } else {
2858                 uint256 weight_diff = old_combined_weight.sub(new_combined_weight);
2859                 _total_combined_weight = _total_combined_weight.sub(weight_diff);
2860                 _combined_weights[account] = old_combined_weight.sub(weight_diff);
2861             }
2862 
2863         }
2864     }
2865 
2866     function _syncEarned(address account) internal {
2867         if (account != address(0)) {
2868             // Calculate the earnings
2869             uint256 earned0 = earned(account);
2870             rewards0[account] = earned0;
2871             userRewardPerTokenPaid0[account] = rewardPerTokenStored0;
2872         }
2873     }
2874 
2875     // Staker can allow a migrator
2876     function stakerAllowMigrator(address migrator_address) external {
2877         require(valid_migrators[migrator_address], "Invalid migrator address");
2878         staker_allowed_migrators[msg.sender][migrator_address] = true;
2879     }
2880 
2881     // Staker can disallow a previously-allowed migrator
2882     function stakerDisallowMigrator(address migrator_address) external {
2883         // Delete from the mapping
2884         delete staker_allowed_migrators[msg.sender][migrator_address];
2885     }
2886 
2887     // Two different stake functions are needed because of delegateCall and msg.sender issues (important for migration)
2888     function stakeLocked(uint256 token_id, uint256 secs) nonReentrant external {
2889         _stakeLocked(msg.sender, msg.sender, token_id, secs, block.timestamp);
2890     }
2891 
2892     // If this were not internal, and source_address had an infinite approve, this could be exploitable
2893     // (pull funds from source_address and stake for an arbitrary staker_address)
2894     function _stakeLocked(
2895         address staker_address,
2896         address source_address,
2897         uint256 token_id,
2898         uint256 secs,
2899         uint256 start_timestamp
2900     ) internal updateRewardAndBalance(staker_address, true) {
2901         require(stakingPaused == false || valid_migrators[msg.sender] == true, "Staking paused or in migration");
2902         require(greylist[staker_address] == false, "Address has been greylisted");
2903         require(secs >= lock_time_min, "Minimum stake time not met");
2904         require(secs <= lock_time_for_max_multiplier,"Trying to lock for too long");
2905         (, uint256 liquidity, int24 tick_lower, int24 tick_upper) = checkUniV3NFT(token_id, true); // Should throw if false
2906 
2907         {
2908             uint256 lock_multiplier = lockMultiplier(secs);
2909             lockedNFTs[staker_address].push(
2910                 LockedNFT(
2911                     token_id,
2912                     liquidity,
2913                     start_timestamp,
2914                     start_timestamp.add(secs),
2915                     lock_multiplier,
2916                     tick_lower,
2917                     tick_upper
2918                 )
2919             );
2920         }
2921 
2922         // Pull the tokens from the source_address
2923         stakingTokenNFT.safeTransferFrom(source_address, address(this), token_id);
2924 
2925         // Update liquidities
2926         _total_liquidity_locked = _total_liquidity_locked.add(liquidity);
2927         _locked_liquidity[staker_address] = _locked_liquidity[staker_address].add(liquidity);
2928 
2929         // Need to call again to make sure everything is correct
2930         _updateRewardAndBalance(staker_address, false);
2931 
2932         emit LockNFT(staker_address, liquidity, token_id, secs, source_address);
2933     }
2934 
2935     // Two different withdrawLocked functions are needed because of delegateCall and msg.sender issues (important for migration)
2936     function withdrawLocked(uint256 token_id) nonReentrant external {
2937         require(withdrawalsPaused == false, "Withdrawals paused");
2938         _withdrawLocked(msg.sender, msg.sender, token_id);
2939     }
2940 
2941     // No withdrawer == msg.sender check needed since this is only internally callable and the checks are done in the wrapper
2942     // functions like migrator_withdraw_locked() and withdrawLocked()
2943     function _withdrawLocked(
2944         address staker_address,
2945         address destination_address,
2946         uint256 token_id
2947     ) internal {
2948         // Collect rewards first and then update the balances
2949         _getReward(staker_address, destination_address);
2950 
2951         LockedNFT memory thisNFT;
2952         thisNFT.liquidity = 0;
2953         uint256 theArrayIndex;
2954         for (uint256 i = 0; i < lockedNFTs[staker_address].length; i++) {
2955             if (token_id == lockedNFTs[staker_address][i].token_id) {
2956                 thisNFT = lockedNFTs[staker_address][i];
2957                 theArrayIndex = i;
2958                 break;
2959             }
2960         }
2961         require(thisNFT.token_id == token_id, "Token ID not found");
2962         require(block.timestamp >= thisNFT.ending_timestamp || stakesUnlocked == true || valid_migrators[msg.sender] == true, "Stake is still locked!");
2963 
2964         uint256 theLiquidity = thisNFT.liquidity;
2965 
2966         if (theLiquidity > 0) {
2967             // Update liquidities
2968             _total_liquidity_locked = _total_liquidity_locked.sub(theLiquidity);
2969             _locked_liquidity[staker_address] = _locked_liquidity[staker_address].sub(theLiquidity);
2970 
2971             // Remove the stake from the array
2972             delete lockedNFTs[staker_address][theArrayIndex];
2973 
2974             // Need to call again to make sure everything is correct
2975             _updateRewardAndBalance(staker_address, false);
2976 
2977             // Give the tokens to the destination_address
2978             stakingTokenNFT.safeTransferFrom(address(this), destination_address, token_id);
2979 
2980             emit WithdrawLocked(staker_address, theLiquidity, token_id, destination_address);
2981         }
2982     }
2983 
2984     // Two different getReward functions are needed because of delegateCall and msg.sender issues (important for migration)
2985     function getReward() external nonReentrant returns (uint256) {
2986         require(rewardsCollectionPaused == false,"Rewards collection paused");
2987         return _getReward(msg.sender, msg.sender);
2988     }
2989 
2990     // No withdrawer == msg.sender check needed since this is only internally callable
2991     // This distinction is important for the migrator
2992     // Also collects the LP fees
2993     function _getReward(address rewardee, address destination_address) internal updateRewardAndBalance(rewardee, true) returns (uint256 reward_0) {
2994         reward_0 = rewards0[rewardee];
2995         if (reward_0 > 0) {
2996             rewards0[rewardee] = 0;
2997             TransferHelper.safeTransfer(address(rewardsToken0), destination_address, reward_0);
2998 
2999             // Collect liquidity fees too
3000             uint256 accumulated_token0 = 0;
3001             uint256 accumulated_token1 = 0;
3002             LockedNFT memory thisNFT;
3003             for (uint256 i = 0; i < lockedNFTs[rewardee].length; i++) {
3004                 thisNFT = lockedNFTs[rewardee][i];
3005                 
3006                 // Check for null entries
3007                 if (thisNFT.token_id != 0){
3008                     IUniswapV3PositionsNFT.CollectParams memory collect_params = IUniswapV3PositionsNFT.CollectParams(
3009                         thisNFT.token_id,
3010                         destination_address,
3011                         type(uint128).max,
3012                         type(uint128).max
3013                     );
3014                     (uint256 tok0_amt, uint256 tok1_amt) = stakingTokenNFT.collect(collect_params);
3015                     accumulated_token0 = accumulated_token0.add(tok0_amt);
3016                     accumulated_token1 = accumulated_token1.add(tok1_amt);
3017                 }
3018             }
3019 
3020             emit RewardPaid(rewardee, reward_0, accumulated_token0, accumulated_token1, address(rewardsToken0), destination_address);
3021         }
3022 
3023     }
3024 
3025     // If the period expired, renew it
3026     function retroCatchUp() internal {
3027         // Failsafe check
3028         require(block.timestamp > periodFinish, "Period has not expired yet!");
3029 
3030         // Pull in rewards from the rewards distributor
3031         rewards_distributor.distributeReward(address(this));
3032 
3033         // Ensure the provided reward amount is not more than the balance in the contract.
3034         // This keeps the reward rate in the right range, preventing overflows due to
3035         // very high values of rewardRate in the earned and rewardsPerToken functions;
3036         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
3037         uint256 num_periods_elapsed = uint256(block.timestamp.sub(periodFinish)) / rewardsDuration; // Floor division to the nearest period
3038         uint256 balance0 = rewardsToken0.balanceOf(address(this));
3039         require(rewardRate0().mul(rewardsDuration).mul(num_periods_elapsed + 1) <= balance0, "Not enough FXS available");
3040 
3041         periodFinish = periodFinish.add((num_periods_elapsed.add(1)).mul(rewardsDuration));
3042 
3043         uint256 reward_per_token_0 = rewardPerToken();
3044         rewardPerTokenStored0 = reward_per_token_0;
3045         lastUpdateTime = lastTimeRewardApplicable();
3046 
3047         emit RewardsPeriodRenewed(address(stakingTokenNFT));
3048     }
3049 
3050     function sync_gauge_weight(bool force_update) public {
3051         if (address(gauge_controller) != address(0) && (force_update || (block.timestamp > last_gauge_time_total))){
3052             // Update the gauge_relative_weight
3053             last_gauge_relative_weight = gauge_controller.gauge_relative_weight_write(address(this), block.timestamp);
3054             last_gauge_time_total = gauge_controller.time_total();
3055         }
3056     }
3057 
3058     function sync() public {
3059         // Sync the gauge weight, if applicable
3060         sync_gauge_weight(false);
3061 
3062         if (block.timestamp > periodFinish) {
3063             retroCatchUp();
3064         } else {
3065             uint256 reward_per_token_0 = rewardPerToken();
3066             rewardPerTokenStored0 = reward_per_token_0;
3067             lastUpdateTime = lastTimeRewardApplicable();
3068         }
3069     }
3070 
3071     /* ========== RESTRICTED FUNCTIONS - Curator / migrator callable ========== */
3072     
3073     // Migrator can stake for someone else (they won't be able to withdraw it back though, only staker_address can).
3074     function migrator_stakeLocked_for(address staker_address, uint256 token_id, uint256 secs, uint256 start_timestamp) external isMigrating {
3075         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
3076         _stakeLocked(staker_address, msg.sender, token_id, secs, start_timestamp);
3077     }
3078 
3079     // Used for migrations
3080     function migrator_withdraw_locked(address staker_address, uint256 token_id) external isMigrating {
3081         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
3082         _withdrawLocked(staker_address, msg.sender, token_id);
3083     }
3084 
3085     function setPauses(
3086         bool _stakingPaused,
3087         bool _withdrawalsPaused,
3088         bool _rewardsCollectionPaused
3089     ) external onlyByOwnerOrCuratorOrGovernance {
3090         stakingPaused = _stakingPaused;
3091         withdrawalsPaused = _withdrawalsPaused;
3092         rewardsCollectionPaused = _rewardsCollectionPaused;
3093     }
3094 
3095     function greylistAddress(address _address) external onlyByOwnerOrCuratorOrGovernance {
3096         greylist[_address] = !(greylist[_address]);
3097     }
3098 
3099     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
3100     
3101     // Adds supported migrator address
3102     function addMigrator(address migrator_address) external onlyByOwnGov {
3103         valid_migrators[migrator_address] = true;
3104     }
3105 
3106     // Remove a migrator address
3107     function removeMigrator(address migrator_address) external onlyByOwnGov {
3108         // Delete from the mapping
3109         delete valid_migrators[migrator_address];
3110     }
3111 
3112     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
3113     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyByOwnGov {
3114         // Only the owner address can ever receive the recovery withdrawal
3115         TransferHelper.safeTransfer(tokenAddress, owner, tokenAmount);
3116         emit RecoveredERC20(tokenAddress, tokenAmount);
3117     }
3118 
3119     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
3120     function recoverERC721(address tokenAddress, uint256 token_id) external onlyByOwnGov {
3121         // Admin cannot withdraw the staking token from the contract unless currently migrating
3122         if (!migrationsOn) {
3123             require(tokenAddress != address(stakingTokenNFT), "Not in migration"); // Only Governance / Timelock can trigger a migration
3124         }
3125         
3126         // Only the owner address can ever receive the recovery withdrawal
3127         // IUniswapV3PositionsNFT inherits IERC721 so the latter does not need to be imported
3128         IUniswapV3PositionsNFT(tokenAddress).safeTransferFrom( address(this), owner, token_id);
3129         emit RecoveredERC721(tokenAddress, token_id);
3130     }
3131 
3132     function setMultipliers(uint256 _lock_max_multiplier, uint256 _vefxs_max_multiplier, uint256 _vefxs_per_frax_for_max_boost) external onlyByOwnGov {
3133         require(_lock_max_multiplier >= MULTIPLIER_PRECISION, "Mult must be >= MULTIPLIER_PRECISION");
3134         require(_vefxs_max_multiplier >= 0, "veFXS mul must be >= 0");
3135         require(_vefxs_per_frax_for_max_boost > 0, "veFXS pct max must be >= 0");
3136 
3137         lock_max_multiplier = _lock_max_multiplier;
3138         vefxs_max_multiplier = _vefxs_max_multiplier;
3139         vefxs_per_frax_for_max_boost = _vefxs_per_frax_for_max_boost;
3140 
3141         emit MaxVeFXSMultiplier(vefxs_max_multiplier);
3142         emit LockedNFTMaxMultiplierUpdated(lock_max_multiplier);
3143         emit veFXSPctForMaxBoostUpdated(vefxs_per_frax_for_max_boost);
3144     }
3145 
3146     function setLockedNFTTimeForMinAndMaxMultiplier(uint256 _lock_time_for_max_multiplier, uint256 _lock_time_min) external onlyByOwnGov {
3147         require(_lock_time_for_max_multiplier >= 1, "Mul max time must be >= 1");
3148         require(_lock_time_min >= 1, "Mul min time must be >= 1");
3149 
3150         lock_time_for_max_multiplier = _lock_time_for_max_multiplier;
3151         lock_time_min = _lock_time_min;
3152 
3153         emit LockedNFTTimeForMaxMultiplier(lock_time_for_max_multiplier);
3154         emit LockedNFTMinTime(_lock_time_min);
3155     }
3156 
3157     function unlockStakes() external onlyByOwnGov {
3158         stakesUnlocked = !stakesUnlocked;
3159     }
3160 
3161     function toggleMigrations() external onlyByOwnGov {
3162         migrationsOn = !migrationsOn;
3163     }
3164 
3165     function setManualRewardRate(uint256 _reward_rate_manual, bool sync_too) external onlyByOwnGov {
3166         reward_rate_manual = _reward_rate_manual;
3167 
3168         if (sync_too) {
3169             sync();
3170         }
3171     }
3172 
3173     function setTWAP(uint32 _new_twap_duration) external onlyByOwnGov {
3174         require(_new_twap_duration <= 3600, "TWAP too long"); // One hour for now. Depends on how many increaseObservationCardinalityNext / observation slots you have
3175         twap_duration = _new_twap_duration;
3176     }
3177 
3178     function toggleEmissionFactorBypass() external onlyByOwnGov {
3179         bypassEmissionFactor = !bypassEmissionFactor;
3180     }
3181 
3182     function setTimelock(address _new_timelock) external onlyByOwnGov {
3183         timelock_address = _new_timelock;
3184     }
3185 
3186     function setCurator(address _new_curator) external onlyByOwnGov {
3187         curator_address = _new_curator;
3188     }
3189 
3190     // Set gauge_controller to address(0) to fall back to the reward_rate_manual
3191     function setGaugeRelatedAddrs(address _gauge_controller_address, address _rewards_distributor_address) external onlyByOwnGov {
3192         gauge_controller = IFraxGaugeController(_gauge_controller_address);
3193         rewards_distributor = IFraxGaugeFXSRewardsDistributor(_rewards_distributor_address);
3194     }
3195 
3196     /* ========== EVENTS ========== */
3197 
3198     event LockNFT(address indexed user, uint256 liquidity, uint256 token_id, uint256 secs, address source_address);
3199     event WithdrawLocked(address indexed user, uint256 liquidity, uint256 token_id, address destination_address);
3200     event RewardPaid(address indexed user, uint256 farm_reward, uint256 liq_tok0_reward, uint256 liq_tok1_reward, address token_address, address destination_address);
3201     event RecoveredERC20(address token, uint256 amount);
3202     event RecoveredERC721(address token, uint256 token_id);
3203     event RewardsPeriodRenewed(address token);
3204     event LockedNFTMaxMultiplierUpdated(uint256 multiplier);
3205     event LockedNFTTimeForMaxMultiplier(uint256 secs);
3206     event LockedNFTMinTime(uint256 secs);
3207     event MaxVeFXSMultiplier(uint256 multiplier);
3208     event veFXSPctForMaxBoostUpdated(uint256 scale_factor);
3209 
3210     /* ========== A CHICKEN ========== */
3211     //
3212     //         ,~.
3213     //      ,-'__ `-,
3214     //     {,-'  `. }              ,')
3215     //    ,( a )   `-.__         ,',')~,
3216     //   <=.) (         `-.__,==' ' ' '}
3217     //     (   )                      /)
3218     //      `-'\   ,                    )
3219     //          |  \        `~.        /
3220     //          \   `._        \      /
3221     //           \     `._____,'    ,'
3222     //            `-.             ,'
3223     //               `-._     _,-'
3224     //                   77jj'
3225     //                  //_||
3226     //               __//--'/`
3227     //             ,--'/`  '
3228     //
3229     // [hjw] https://textart.io/art/vw6Sa3iwqIRGkZsN1BC2vweF/chicken
3230 }
3231 
3232 
3233 // File contracts/Staking/Variants/FraxUniV3Farm_Stable_FRAX_agEUR.sol
3234 
3235 
3236 
3237 contract FraxUniV3Farm_Stable_FRAX_agEUR is FraxUniV3Farm_Stable {
3238     constructor (
3239         address _owner,
3240         address _lp_pool_address,
3241         address _timelock_address,
3242         address _rewards_distributor_address,
3243         int24 _uni_tick_lower,
3244         int24 _uni_tick_upper,
3245         int24 _uni_ideal_tick
3246     ) 
3247     FraxUniV3Farm_Stable(_owner, _lp_pool_address, _timelock_address, _rewards_distributor_address, _uni_tick_lower, _uni_tick_upper, _uni_ideal_tick)
3248     {}
3249 }