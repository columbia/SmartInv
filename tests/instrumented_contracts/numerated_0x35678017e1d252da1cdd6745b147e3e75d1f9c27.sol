1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.9.9 https://hardhat.org
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
479 // File contracts/Uniswap/TransferHelper.sol
480 
481 
482 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
483 library TransferHelper {
484     function safeApprove(address token, address to, uint value) internal {
485         // bytes4(keccak256(bytes('approve(address,uint256)')));
486         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
487         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
488     }
489 
490     function safeTransfer(address token, address to, uint value) internal {
491         // bytes4(keccak256(bytes('transfer(address,uint256)')));
492         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
493         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
494     }
495 
496     function safeTransferFrom(address token, address from, address to, uint value) internal {
497         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
498         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
499         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
500     }
501 
502     function safeTransferETH(address to, uint value) internal {
503         (bool success,) = to.call{value:value}(new bytes(0));
504         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
505     }
506 }
507 
508 
509 // File contracts/Utils/ReentrancyGuard.sol
510 
511 
512 /**
513  * @dev Contract module that helps prevent reentrant calls to a function.
514  *
515  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
516  * available, which can be applied to functions to make sure there are no nested
517  * (reentrant) calls to them.
518  *
519  * Note that because there is a single `nonReentrant` guard, functions marked as
520  * `nonReentrant` may not call one another. This can be worked around by making
521  * those functions `private`, and then adding `external` `nonReentrant` entry
522  * points to them.
523  *
524  * TIP: If you would like to learn more about reentrancy and alternative ways
525  * to protect against it, check out our blog post
526  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
527  */
528 abstract contract ReentrancyGuard {
529     // Booleans are more expensive than uint256 or any type that takes up a full
530     // word because each write operation emits an extra SLOAD to first read the
531     // slot's contents, replace the bits taken up by the boolean, and then write
532     // back. This is the compiler's defense against contract upgrades and
533     // pointer aliasing, and it cannot be disabled.
534 
535     // The values being non-zero value makes deployment a bit more expensive,
536     // but in exchange the refund on every call to nonReentrant will be lower in
537     // amount. Since refunds are capped to a percentage of the total
538     // transaction's gas, it is best to keep them low in cases like this one, to
539     // increase the likelihood of the full refund coming into effect.
540     uint256 private constant _NOT_ENTERED = 1;
541     uint256 private constant _ENTERED = 2;
542 
543     uint256 private _status;
544 
545     constructor () internal {
546         _status = _NOT_ENTERED;
547     }
548 
549     /**
550      * @dev Prevents a contract from calling itself, directly or indirectly.
551      * Calling a `nonReentrant` function from another `nonReentrant`
552      * function is not supported. It is possible to prevent this from happening
553      * by making the `nonReentrant` function external, and make it call a
554      * `private` function that does the actual work.
555      */
556     modifier nonReentrant() {
557         // On the first call to nonReentrant, _notEntered will be true
558         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
559 
560         // Any calls to nonReentrant after this point will fail
561         _status = _ENTERED;
562 
563         _;
564 
565         // By storing the original value once again, a refund is triggered (see
566         // https://eips.ethereum.org/EIPS/eip-2200)
567         _status = _NOT_ENTERED;
568     }
569 }
570 
571 
572 // File contracts/Staking/Owned.sol
573 
574 
575 // https://docs.synthetix.io/contracts/Owned
576 contract Owned {
577     address public owner;
578     address public nominatedOwner;
579 
580     constructor (address _owner) public {
581         require(_owner != address(0), "Owner address cannot be 0");
582         owner = _owner;
583         emit OwnerChanged(address(0), _owner);
584     }
585 
586     function nominateNewOwner(address _owner) external onlyOwner {
587         nominatedOwner = _owner;
588         emit OwnerNominated(_owner);
589     }
590 
591     function acceptOwnership() external {
592         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
593         emit OwnerChanged(owner, nominatedOwner);
594         owner = nominatedOwner;
595         nominatedOwner = address(0);
596     }
597 
598     modifier onlyOwner {
599         require(msg.sender == owner, "Only the contract owner may perform this action");
600         _;
601     }
602 
603     event OwnerNominated(address newOwner);
604     event OwnerChanged(address oldOwner, address newOwner);
605 }
606 
607 
608 // File contracts/Misc_AMOs/convex/IConvexBaseRewardPool.sol
609 
610 
611 interface IConvexBaseRewardPool {
612   function addExtraReward(address _reward) external returns (bool);
613   function balanceOf(address account) external view returns (uint256);
614   function clearExtraRewards() external;
615   function currentRewards() external view returns (uint256);
616   function donate(uint256 _amount) external returns (bool);
617   function duration() external view returns (uint256);
618   function earned(address account) external view returns (uint256);
619   function extraRewards(uint256) external view returns (address);
620   function extraRewardsLength() external view returns (uint256);
621   function getReward() external returns (bool);
622   function getReward(address _account, bool _claimExtras) external returns (bool);
623   function historicalRewards() external view returns (uint256);
624   function lastTimeRewardApplicable() external view returns (uint256);
625   function lastUpdateTime() external view returns (uint256);
626   function newRewardRatio() external view returns (uint256);
627   function operator() external view returns (address);
628   function periodFinish() external view returns (uint256);
629   function pid() external view returns (uint256);
630   function queueNewRewards(uint256 _rewards) external returns (bool);
631   function queuedRewards() external view returns (uint256);
632   function rewardManager() external view returns (address);
633   function rewardPerToken() external view returns (uint256);
634   function rewardPerTokenStored() external view returns (uint256);
635   function rewardRate() external view returns (uint256);
636   function rewardToken() external view returns (address);
637   function rewards(address) external view returns (uint256);
638   function stake(uint256 _amount) external returns (bool);
639   function stakeAll() external returns (bool);
640   function stakeFor(address _for, uint256 _amount) external returns (bool);
641   function stakingToken() external view returns (address);
642   function totalSupply() external view returns (uint256);
643   function userRewardPerTokenPaid(address) external view returns (uint256);
644   function withdraw(uint256 amount, bool claim) external returns (bool);
645   function withdrawAll(bool claim) external;
646   function withdrawAllAndUnwrap(bool claim) external;
647   function withdrawAndUnwrap(uint256 amount, bool claim) external returns (bool);
648 }
649 
650 
651 // File contracts/Staking/FraxUnifiedFarmTemplate.sol
652 
653 
654 // ====================================================================
655 // |     ______                   _______                             |
656 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
657 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
658 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
659 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
660 // |                                                                  |
661 // ====================================================================
662 // ====================== FraxUnifiedFarmTemplate =====================
663 // ====================================================================
664 // Farming contract that accounts for veFXS
665 // Overrideable for UniV3, ERC20s, etc
666 // New for V2
667 //      - Multiple reward tokens possible
668 //      - Can add to existing locked stakes
669 //      - Contract is aware of proxied veFXS
670 //      - veFXS multiplier formula changed
671 // Apes together strong
672 
673 // Frax Finance: https://github.com/FraxFinance
674 
675 // Primary Author(s)
676 // Travis Moore: https://github.com/FortisFortuna
677 
678 // Reviewer(s) / Contributor(s)
679 // Jason Huan: https://github.com/jasonhuan
680 // Sam Kazemian: https://github.com/samkazemian
681 // Dennis: github.com/denett
682 
683 // Originally inspired by Synthetix.io, but heavily modified by the Frax team
684 // (Locked, veFXS, and UniV3 portions are new)
685 // https://raw.githubusercontent.com/Synthetixio/synthetix/develop/contracts/StakingRewards.sol
686 
687 
688 
689 
690 
691 
692 
693 
694 // Extra rewards
695 
696 contract FraxUnifiedFarmTemplate is Owned, ReentrancyGuard {
697 
698     /* ========== STATE VARIABLES ========== */
699 
700     // Instances
701     IveFXS private immutable veFXS = IveFXS(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0);
702     
703     // Frax related
704     address internal immutable frax_address = 0x853d955aCEf822Db058eb8505911ED77F175b99e;
705     uint256 public fraxPerLPStored;
706 
707     // Constant for various precisions
708     uint256 internal constant MULTIPLIER_PRECISION = 1e18;
709 
710     // Time tracking
711     uint256 public periodFinish;
712     uint256 public lastUpdateTime;
713 
714     // Lock time and multiplier settings
715     uint256 public lock_max_multiplier = uint256(2e18); // E18. 1x = e18
716     uint256 public lock_time_for_max_multiplier = 1 * 365 * 86400; // 1 year
717     // uint256 public lock_time_for_max_multiplier = 2 * 86400; // 2 days
718     uint256 public lock_time_min = 594000; // 6.875 * 86400 (~7 day)
719 
720     // veFXS related
721     uint256 public vefxs_boost_scale_factor = uint256(4e18); // E18. 4x = 4e18; 100 / scale_factor = % vefxs supply needed for max boost
722     uint256 public vefxs_max_multiplier = uint256(2e18); // E18. 1x = 1e18
723     uint256 public vefxs_per_frax_for_max_boost = uint256(4e18); // E18. 2e18 means 2 veFXS must be held by the staker per 1 FRAX
724     mapping(address => uint256) internal _vefxsMultiplierStored;
725     mapping(address => bool) internal valid_vefxs_proxies;
726     mapping(address => mapping(address => bool)) internal proxy_allowed_stakers;
727 
728     // Reward addresses, gauge addresses, reward rates, and reward managers
729     mapping(address => address) public rewardManagers; // token addr -> manager addr
730     address[] internal rewardTokens;
731     address[] internal gaugeControllers;
732     address[] internal rewardDistributors;
733     uint256[] internal rewardRatesManual;
734     mapping(address => uint256) public rewardTokenAddrToIdx; // token addr -> token index
735     
736     // Reward period
737     uint256 public constant rewardsDuration = 604800; // 7 * 86400  (7 days)
738 
739     // Reward tracking
740     uint256[] private rewardsPerTokenStored;
741     mapping(address => mapping(uint256 => uint256)) private userRewardsPerTokenPaid; // staker addr -> token id -> paid amount
742     mapping(address => mapping(uint256 => uint256)) private rewards; // staker addr -> token id -> reward amount
743     mapping(address => uint256) public lastRewardClaimTime; // staker addr -> timestamp
744     
745     // Gauge tracking
746     uint256[] private last_gauge_relative_weights;
747     uint256[] private last_gauge_time_totals;
748 
749     // Balance tracking
750     uint256 internal _total_liquidity_locked;
751     uint256 internal _total_combined_weight;
752     mapping(address => uint256) internal _locked_liquidity;
753     mapping(address => uint256) internal _combined_weights;
754     mapping(address => uint256) public proxy_lp_balances; // Keeps track of LP balances proxy-wide. Needed to make sure the proxy boost is kept in line
755 
756 
757     // Stakers set which proxy(s) they want to use
758     mapping(address => address) public staker_designated_proxies; // Keep public so users can see on the frontend if they have a proxy
759 
760     // Admin booleans for emergencies and overrides
761     bool public stakesUnlocked; // Release locked stakes in case of emergency
762     bool internal withdrawalsPaused; // For emergencies
763     bool internal rewardsCollectionPaused; // For emergencies
764     bool internal stakingPaused; // For emergencies
765 
766     /* ========== STRUCTS ========== */
767     // In children...
768 
769 
770     /* ========== MODIFIERS ========== */
771 
772     modifier onlyByOwnGov() {
773         require(msg.sender == owner || msg.sender == 0x8412ebf45bAC1B340BbE8F318b928C466c4E39CA, "Not owner or timelock");
774         _;
775     }
776 
777     modifier onlyTknMgrs(address reward_token_address) {
778         require(msg.sender == owner || isTokenManagerFor(msg.sender, reward_token_address), "Not owner or tkn mgr");
779         _;
780     }
781 
782     modifier updateRewardAndBalanceMdf(address account, bool sync_too) {
783         updateRewardAndBalance(account, sync_too);
784         _;
785     }
786 
787     /* ========== CONSTRUCTOR ========== */
788 
789     constructor (
790         address _owner,
791         address[] memory _rewardTokens,
792         address[] memory _rewardManagers,
793         uint256[] memory _rewardRatesManual,
794         address[] memory _gaugeControllers,
795         address[] memory _rewardDistributors
796     ) Owned(_owner) {
797 
798         // Address arrays
799         rewardTokens = _rewardTokens;
800         gaugeControllers = _gaugeControllers;
801         rewardDistributors = _rewardDistributors;
802         rewardRatesManual = _rewardRatesManual;
803 
804         for (uint256 i = 0; i < _rewardTokens.length; i++){ 
805             // For fast token address -> token ID lookups later
806             rewardTokenAddrToIdx[_rewardTokens[i]] = i;
807 
808             // Initialize the stored rewards
809             rewardsPerTokenStored.push(0);
810 
811             // Initialize the reward managers
812             rewardManagers[_rewardTokens[i]] = _rewardManagers[i];
813 
814             // Push in empty relative weights to initialize the array
815             last_gauge_relative_weights.push(0);
816 
817             // Push in empty time totals to initialize the array
818             last_gauge_time_totals.push(0);
819         }
820 
821         // Other booleans
822         stakesUnlocked = false;
823 
824         // Initialization
825         lastUpdateTime = block.timestamp;
826         periodFinish = block.timestamp + rewardsDuration;
827     }
828 
829     /* ============= VIEWS ============= */
830 
831     // ------ REWARD RELATED ------
832 
833     // See if the caller_addr is a manager for the reward token 
834     function isTokenManagerFor(address caller_addr, address reward_token_addr) public view returns (bool){
835         if (caller_addr == owner) return true; // Contract owner
836         else if (rewardManagers[reward_token_addr] == caller_addr) return true; // Reward manager
837         return false; 
838     }
839 
840     // All the reward tokens
841     function getAllRewardTokens() external view returns (address[] memory) {
842         return rewardTokens;
843     }
844 
845     // Last time the reward was applicable
846     function lastTimeRewardApplicable() internal view returns (uint256) {
847         return Math.min(block.timestamp, periodFinish);
848     }
849 
850     function rewardRates(uint256 token_idx) public view returns (uint256 rwd_rate) {
851         address gauge_controller_address = gaugeControllers[token_idx];
852         if (gauge_controller_address != address(0)) {
853             rwd_rate = (IFraxGaugeController(gauge_controller_address).global_emission_rate() * last_gauge_relative_weights[token_idx]) / 1e18;
854         }
855         else {
856             rwd_rate = rewardRatesManual[token_idx];
857         }
858     }
859 
860     // Amount of reward tokens per LP token / liquidity unit
861     function rewardsPerToken() public view returns (uint256[] memory newRewardsPerTokenStored) {
862         if (_total_liquidity_locked == 0 || _total_combined_weight == 0) {
863             return rewardsPerTokenStored;
864         }
865         else {
866             newRewardsPerTokenStored = new uint256[](rewardTokens.length);
867             for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
868                 newRewardsPerTokenStored[i] = rewardsPerTokenStored[i] + (
869                     ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRates(i) * 1e18) / _total_combined_weight
870                 );
871             }
872             return newRewardsPerTokenStored;
873         }
874     }
875 
876     // Amount of reward tokens an account has earned / accrued
877     // Note: In the edge-case of one of the account's stake expiring since the last claim, this will
878     // return a slightly inflated number
879     function earned(address account) public view returns (uint256[] memory new_earned) {
880         uint256[] memory reward_arr = rewardsPerToken();
881         new_earned = new uint256[](rewardTokens.length);
882 
883         if (_combined_weights[account] > 0){
884             for (uint256 i = 0; i < rewardTokens.length; i++){ 
885                 new_earned[i] = ((_combined_weights[account] * (reward_arr[i] - userRewardsPerTokenPaid[account][i])) / 1e18)
886                                 + rewards[account][i];
887             }
888         }
889     }
890 
891     // Total reward tokens emitted in the given period
892     function getRewardForDuration() external view returns (uint256[] memory rewards_per_duration_arr) {
893         rewards_per_duration_arr = new uint256[](rewardRatesManual.length);
894 
895         for (uint256 i = 0; i < rewardRatesManual.length; i++){ 
896             rewards_per_duration_arr[i] = rewardRates(i) * rewardsDuration;
897         }
898     }
899 
900 
901     // ------ LIQUIDITY AND WEIGHTS ------
902 
903     // User locked liquidity / LP tokens
904     function totalLiquidityLocked() external view returns (uint256) {
905         return _total_liquidity_locked;
906     }
907 
908     // Total locked liquidity / LP tokens
909     function lockedLiquidityOf(address account) external view returns (uint256) {
910         return _locked_liquidity[account];
911     }
912 
913     // Total combined weight
914     function totalCombinedWeight() external view returns (uint256) {
915         return _total_combined_weight;
916     }
917 
918     // Total 'balance' used for calculating the percent of the pool the account owns
919     // Takes into account the locked stake time multiplier and veFXS multiplier
920     function combinedWeightOf(address account) external view returns (uint256) {
921         return _combined_weights[account];
922     }
923 
924     // Calculated the combined weight for an account
925     function calcCurCombinedWeight(address account) public virtual view 
926         returns (
927             uint256 old_combined_weight,
928             uint256 new_vefxs_multiplier,
929             uint256 new_combined_weight
930         )
931     {
932         revert("Need cCCW logic");
933     }
934 
935     // ------ LOCK RELATED ------
936 
937     // Multiplier amount, given the length of the lock
938     function lockMultiplier(uint256 secs) public view returns (uint256) {
939         // return Math.min(
940         //     lock_max_multiplier,
941         //     uint256(MULTIPLIER_PRECISION) + (
942         //         (secs * (lock_max_multiplier - MULTIPLIER_PRECISION)) / lock_time_for_max_multiplier
943         //     )
944         // ) ;
945         return Math.min(
946             lock_max_multiplier,
947             (secs * lock_max_multiplier) / lock_time_for_max_multiplier
948         ) ;
949     }
950 
951     // ------ FRAX RELATED ------
952 
953     function userStakedFrax(address account) public view returns (uint256) {
954         return (fraxPerLPStored * _locked_liquidity[account]) / MULTIPLIER_PRECISION;
955     }
956 
957     function proxyStakedFrax(address proxy_address) public view returns (uint256) {
958         return (fraxPerLPStored * proxy_lp_balances[proxy_address]) / MULTIPLIER_PRECISION;
959     }
960 
961     // Max LP that can get max veFXS boosted for a given address at its current veFXS balance
962     function maxLPForMaxBoost(address account) external view returns (uint256) {
963         return (veFXS.balanceOf(account) * MULTIPLIER_PRECISION * MULTIPLIER_PRECISION) / (vefxs_per_frax_for_max_boost * fraxPerLPStored);
964     }
965 
966     // Meant to be overridden
967     function fraxPerLPToken() public virtual view returns (uint256) {
968         revert("Need fPLPT logic");
969     }
970 
971     // ------ veFXS RELATED ------
972 
973     function minVeFXSForMaxBoost(address account) public view returns (uint256) {
974         return (userStakedFrax(account) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
975     }
976 
977     function minVeFXSForMaxBoostProxy(address proxy_address) public view returns (uint256) {
978         return (proxyStakedFrax(proxy_address) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
979     }
980 
981     function getProxyFor(address addr) public view returns (address){
982         if (valid_vefxs_proxies[addr]) {
983             // If addr itself is a proxy, return that.
984             // If it farms itself directly, it should use the shared LP tally in proxyStakedFrax
985             return addr;
986         }
987         else {
988             // Otherwise, return the proxy, or address(0)
989             return staker_designated_proxies[addr];
990         }
991     }
992 
993     function veFXSMultiplier(address account) public view returns (uint256 vefxs_multiplier) {
994         // Use either the user's or their proxy's veFXS balance
995         uint256 vefxs_bal_to_use = 0;
996         address the_proxy = getProxyFor(account);
997         vefxs_bal_to_use = (the_proxy == address(0)) ? veFXS.balanceOf(account) : veFXS.balanceOf(the_proxy);
998 
999         // First option based on fraction of total veFXS supply, with an added scale factor
1000         uint256 mult_optn_1 = (vefxs_bal_to_use * vefxs_max_multiplier * vefxs_boost_scale_factor) 
1001                             / (veFXS.totalSupply() * MULTIPLIER_PRECISION);
1002         
1003         // Second based on old method, where the amount of FRAX staked comes into play
1004         uint256 mult_optn_2;
1005         {
1006             uint256 veFXS_needed_for_max_boost;
1007 
1008             // Need to use proxy-wide FRAX balance if applicable, to prevent exploiting
1009             veFXS_needed_for_max_boost = (the_proxy == address(0)) ? minVeFXSForMaxBoost(account) : minVeFXSForMaxBoostProxy(the_proxy);
1010 
1011             if (veFXS_needed_for_max_boost > 0){ 
1012                 uint256 user_vefxs_fraction = (vefxs_bal_to_use * MULTIPLIER_PRECISION) / veFXS_needed_for_max_boost;
1013                 
1014                 mult_optn_2 = (user_vefxs_fraction * vefxs_max_multiplier) / MULTIPLIER_PRECISION;
1015             }
1016             else mult_optn_2 = 0; // This will happen with the first stake, when user_staked_frax is 0
1017         }
1018 
1019         // Select the higher of the two
1020         vefxs_multiplier = (mult_optn_1 > mult_optn_2 ? mult_optn_1 : mult_optn_2);
1021 
1022         // Cap the boost to the vefxs_max_multiplier
1023         if (vefxs_multiplier > vefxs_max_multiplier) vefxs_multiplier = vefxs_max_multiplier;
1024     }
1025 
1026     /* =============== MUTATIVE FUNCTIONS =============== */
1027 
1028 
1029     // Proxy can allow a staker to use their veFXS balance (the staker will have to reciprocally toggle them too)
1030     // Must come before stakerSetVeFXSProxy
1031     // CALLED BY PROXY
1032     function proxyToggleStaker(address staker_address) external {
1033         require(valid_vefxs_proxies[msg.sender], "Invalid proxy");
1034         proxy_allowed_stakers[msg.sender][staker_address] = !proxy_allowed_stakers[msg.sender][staker_address]; 
1035 
1036         // Disable the staker's set proxy if it was the toggler and is currently on
1037         if (staker_designated_proxies[staker_address] == msg.sender){
1038             staker_designated_proxies[staker_address] = address(0); 
1039 
1040             // Remove the LP as well
1041             proxy_lp_balances[msg.sender] -= _locked_liquidity[staker_address];
1042         }
1043     }
1044 
1045     // Staker can allow a veFXS proxy (the proxy will have to toggle them first)
1046     // CALLED BY STAKER
1047     function stakerSetVeFXSProxy(address proxy_address) external {
1048         require(valid_vefxs_proxies[proxy_address], "Invalid proxy");
1049         require(proxy_allowed_stakers[proxy_address][msg.sender], "Proxy has not allowed you yet");
1050         
1051         // Corner case sanity check to make sure LP isn't double counted
1052         address old_proxy_addr = staker_designated_proxies[msg.sender];
1053         if (old_proxy_addr != address(0)) {
1054             // Remove the LP count from the old proxy
1055             proxy_lp_balances[old_proxy_addr] -= _locked_liquidity[msg.sender];
1056         }
1057 
1058         // Set the new proxy
1059         staker_designated_proxies[msg.sender] = proxy_address; 
1060 
1061         // Add the the LP as well
1062         proxy_lp_balances[proxy_address] += _locked_liquidity[msg.sender];
1063     }
1064 
1065     // ------ STAKING ------
1066     // In children...
1067 
1068 
1069     // ------ WITHDRAWING ------
1070     // In children...
1071 
1072 
1073     // ------ REWARDS SYNCING ------
1074 
1075     function updateRewardAndBalance(address account, bool sync_too) public {
1076         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
1077         if (sync_too){
1078             sync();
1079         }
1080         
1081         if (account != address(0)) {
1082             // To keep the math correct, the user's combined weight must be recomputed to account for their
1083             // ever-changing veFXS balance.
1084             (   
1085                 uint256 old_combined_weight,
1086                 uint256 new_vefxs_multiplier,
1087                 uint256 new_combined_weight
1088             ) = calcCurCombinedWeight(account);
1089 
1090             // Calculate the earnings first
1091             _syncEarned(account);
1092 
1093             // Update the user's stored veFXS multipliers
1094             _vefxsMultiplierStored[account] = new_vefxs_multiplier;
1095 
1096             // Update the user's and the global combined weights
1097             if (new_combined_weight >= old_combined_weight) {
1098                 uint256 weight_diff = new_combined_weight - old_combined_weight;
1099                 _total_combined_weight = _total_combined_weight + weight_diff;
1100                 _combined_weights[account] = old_combined_weight + weight_diff;
1101             } else {
1102                 uint256 weight_diff = old_combined_weight - new_combined_weight;
1103                 _total_combined_weight = _total_combined_weight - weight_diff;
1104                 _combined_weights[account] = old_combined_weight - weight_diff;
1105             }
1106 
1107         }
1108     }
1109 
1110     function _syncEarned(address account) internal {
1111         if (account != address(0)) {
1112             // Calculate the earnings
1113             uint256[] memory earned_arr = earned(account);
1114 
1115             // Update the rewards array
1116             for (uint256 i = 0; i < earned_arr.length; i++){ 
1117                 rewards[account][i] = earned_arr[i];
1118             }
1119 
1120             // Update the rewards paid array
1121             for (uint256 i = 0; i < earned_arr.length; i++){ 
1122                 userRewardsPerTokenPaid[account][i] = rewardsPerTokenStored[i];
1123             }
1124         }
1125     }
1126 
1127 
1128     // ------ REWARDS CLAIMING ------
1129 
1130     function getRewardExtraLogic(address destination_address) public nonReentrant {
1131         require(rewardsCollectionPaused == false, "Rewards collection paused");
1132         return _getRewardExtraLogic(msg.sender, destination_address);
1133     }
1134 
1135     function _getRewardExtraLogic(address rewardee, address destination_address) internal virtual {
1136         revert("Need gREL logic");
1137     }
1138 
1139     // Two different getReward functions are needed because of delegateCall and msg.sender issues
1140     // For backwards-compatibility
1141     function getReward(address destination_address) external nonReentrant returns (uint256[] memory) {
1142         return _getReward(msg.sender, destination_address, true);
1143     }
1144 
1145     function getReward2(address destination_address, bool claim_extra_too) external nonReentrant returns (uint256[] memory) {
1146         return _getReward(msg.sender, destination_address, claim_extra_too);
1147     }
1148 
1149     // No withdrawer == msg.sender check needed since this is only internally callable
1150     function _getReward(address rewardee, address destination_address, bool do_extra_logic) internal updateRewardAndBalanceMdf(rewardee, true) returns (uint256[] memory rewards_before) {
1151         // Update the last reward claim time first, as an extra reentrancy safeguard
1152         lastRewardClaimTime[rewardee] = block.timestamp;
1153         
1154         // Make sure rewards collection isn't paused
1155         require(rewardsCollectionPaused == false, "Rewards collection paused");
1156         
1157         // Update the rewards array and distribute rewards
1158         rewards_before = new uint256[](rewardTokens.length);
1159 
1160         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1161             rewards_before[i] = rewards[rewardee][i];
1162             rewards[rewardee][i] = 0;
1163             if (rewards_before[i] > 0) {
1164                 TransferHelper.safeTransfer(rewardTokens[i], destination_address, rewards_before[i]);
1165 
1166                 emit RewardPaid(rewardee, rewards_before[i], rewardTokens[i], destination_address);
1167             }
1168         }
1169 
1170         // Handle additional reward logic
1171         if (do_extra_logic) {
1172             _getRewardExtraLogic(rewardee, destination_address);
1173         }
1174     }
1175 
1176 
1177     // ------ FARM SYNCING ------
1178 
1179     // If the period expired, renew it
1180     function retroCatchUp() internal {
1181         // Pull in rewards from the rewards distributor, if applicable
1182         for (uint256 i = 0; i < rewardDistributors.length; i++){ 
1183             address reward_distributor_address = rewardDistributors[i];
1184             if (reward_distributor_address != address(0)) {
1185                 IFraxGaugeFXSRewardsDistributor(reward_distributor_address).distributeReward(address(this));
1186             }
1187         }
1188 
1189         // Ensure the provided reward amount is not more than the balance in the contract.
1190         // This keeps the reward rate in the right range, preventing overflows due to
1191         // very high values of rewardRate in the earned and rewardsPerToken functions;
1192         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1193         uint256 num_periods_elapsed = uint256(block.timestamp - periodFinish) / rewardsDuration; // Floor division to the nearest period
1194         
1195         // Make sure there are enough tokens to renew the reward period
1196         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1197             require((rewardRates(i) * rewardsDuration * (num_periods_elapsed + 1)) <= IERC20(rewardTokens[i]).balanceOf(address(this)), string(abi.encodePacked("Not enough reward tokens available: ", rewardTokens[i])) );
1198         }
1199         
1200         // uint256 old_lastUpdateTime = lastUpdateTime;
1201         // uint256 new_lastUpdateTime = block.timestamp;
1202 
1203         // lastUpdateTime = periodFinish;
1204         periodFinish = periodFinish + ((num_periods_elapsed + 1) * rewardsDuration);
1205 
1206         // Update the rewards and time
1207         _updateStoredRewardsAndTime();
1208 
1209         // Update the fraxPerLPStored
1210         fraxPerLPStored = fraxPerLPToken();
1211 
1212         // Pull in rewards and set the reward rate for one week, based off of that
1213         // If the rewards get messed up for some reason, set this to 0 and it will skip
1214         // if (rewardRatesManual[1] != 0 && rewardRatesManual[2] != 0) {
1215         //     // CRV & CVX
1216         //     // ====================================
1217         //     uint256 crv_before = ERC20(rewardTokens[1]).balanceOf(address(this));
1218         //     uint256 cvx_before = ERC20(rewardTokens[2]).balanceOf(address(this));
1219         //     IConvexBaseRewardPool(0x329cb014b562d5d42927cfF0dEdF4c13ab0442EF).getReward(
1220         //         address(this),
1221         //         true
1222         //     );
1223         //     uint256 crv_after = ERC20(rewardTokens[1]).balanceOf(address(this));
1224         //     uint256 cvx_after = ERC20(rewardTokens[2]).balanceOf(address(this));
1225 
1226         //     // Set the new reward rate
1227         //     rewardRatesManual[1] = (crv_after - crv_before) / rewardsDuration;
1228         //     rewardRatesManual[2] = (cvx_after - cvx_before) / rewardsDuration;
1229         // }
1230 
1231     }
1232 
1233     function _updateStoredRewardsAndTime() internal {
1234         // Get the rewards
1235         uint256[] memory rewards_per_token = rewardsPerToken();
1236 
1237         // Update the rewardsPerTokenStored
1238         for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
1239             rewardsPerTokenStored[i] = rewards_per_token[i];
1240         }
1241 
1242         // Update the last stored time
1243         lastUpdateTime = lastTimeRewardApplicable();
1244     }
1245 
1246     function sync_gauge_weights(bool force_update) public {
1247         // Loop through the gauge controllers
1248         for (uint256 i = 0; i < gaugeControllers.length; i++){ 
1249             address gauge_controller_address = gaugeControllers[i];
1250             if (gauge_controller_address != address(0)) {
1251                 if (force_update || (block.timestamp > last_gauge_time_totals[i])){
1252                     // Update the gauge_relative_weight
1253                     last_gauge_relative_weights[i] = IFraxGaugeController(gauge_controller_address).gauge_relative_weight_write(address(this), block.timestamp);
1254                     last_gauge_time_totals[i] = IFraxGaugeController(gauge_controller_address).time_total();
1255                 }
1256             }
1257         }
1258     }
1259 
1260     function sync() public {
1261         // Sync the gauge weight, if applicable
1262         sync_gauge_weights(false);
1263 
1264         // Update the fraxPerLPStored
1265         fraxPerLPStored = fraxPerLPToken();
1266 
1267         if (block.timestamp >= periodFinish) {
1268             retroCatchUp();
1269         }
1270         else {
1271             _updateStoredRewardsAndTime();
1272         }
1273     }
1274 
1275     /* ========== RESTRICTED FUNCTIONS - Curator callable ========== */
1276     
1277     // ------ FARM SYNCING ------
1278     // In children...
1279 
1280     // ------ PAUSES ------
1281 
1282     function setPauses(
1283         bool _stakingPaused,
1284         bool _withdrawalsPaused,
1285         bool _rewardsCollectionPaused
1286     ) external onlyByOwnGov {
1287         stakingPaused = _stakingPaused;
1288         withdrawalsPaused = _withdrawalsPaused;
1289         rewardsCollectionPaused = _rewardsCollectionPaused;
1290     }
1291 
1292     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
1293     
1294     function unlockStakes() external onlyByOwnGov {
1295         stakesUnlocked = !stakesUnlocked;
1296     }
1297 
1298     // Adds a valid veFXS proxy address
1299     function toggleValidVeFXSProxy(address _proxy_addr) external onlyByOwnGov {
1300         valid_vefxs_proxies[_proxy_addr] = !valid_vefxs_proxies[_proxy_addr];
1301     }
1302 
1303     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
1304     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyTknMgrs(tokenAddress) {
1305         // Check if the desired token is a reward token
1306         bool isRewardToken = false;
1307         for (uint256 i = 0; i < rewardTokens.length; i++){ 
1308             if (rewardTokens[i] == tokenAddress) {
1309                 isRewardToken = true;
1310                 break;
1311             }
1312         }
1313 
1314         // Only the reward managers can take back their reward tokens
1315         // Also, other tokens, like the staking token, airdrops, or accidental deposits, can be withdrawn by the owner
1316         if (
1317                 (isRewardToken && rewardManagers[tokenAddress] == msg.sender)
1318                 || (!isRewardToken && (msg.sender == owner))
1319             ) {
1320             TransferHelper.safeTransfer(tokenAddress, msg.sender, tokenAmount);
1321             return;
1322         }
1323         // If none of the above conditions are true
1324         else {
1325             revert("No valid tokens to recover");
1326         }
1327     }
1328 
1329     function setMiscVariables(
1330         uint256[6] memory _misc_vars
1331         // [0]: uint256 _lock_max_multiplier, 
1332         // [1] uint256 _vefxs_max_multiplier, 
1333         // [2] uint256 _vefxs_per_frax_for_max_boost,
1334         // [3] uint256 _vefxs_boost_scale_factor,
1335         // [4] uint256 _lock_time_for_max_multiplier,
1336         // [5] uint256 _lock_time_min
1337     ) external onlyByOwnGov {
1338         require(_misc_vars[0] >= MULTIPLIER_PRECISION, "Must be >= MUL PREC");
1339         require((_misc_vars[1] >= 0) && (_misc_vars[2] >= 0) && (_misc_vars[3] >= 0), "Must be >= 0");
1340         require((_misc_vars[4] >= 1) && (_misc_vars[5] >= 1), "Must be >= 1");
1341 
1342         lock_max_multiplier = _misc_vars[0];
1343         vefxs_max_multiplier = _misc_vars[1];
1344         vefxs_per_frax_for_max_boost = _misc_vars[2];
1345         vefxs_boost_scale_factor = _misc_vars[3];
1346         lock_time_for_max_multiplier = _misc_vars[4];
1347         lock_time_min = _misc_vars[5];
1348     }
1349 
1350     // The owner or the reward token managers can set reward rates 
1351     function setRewardVars(address reward_token_address, uint256 _new_rate, address _gauge_controller_address, address _rewards_distributor_address) external onlyTknMgrs(reward_token_address) {
1352         rewardRatesManual[rewardTokenAddrToIdx[reward_token_address]] = _new_rate;
1353         gaugeControllers[rewardTokenAddrToIdx[reward_token_address]] = _gauge_controller_address;
1354         rewardDistributors[rewardTokenAddrToIdx[reward_token_address]] = _rewards_distributor_address;
1355     }
1356 
1357     // The owner or the reward token managers can change managers
1358     function changeTokenManager(address reward_token_address, address new_manager_address) external onlyTknMgrs(reward_token_address) {
1359         rewardManagers[reward_token_address] = new_manager_address;
1360     }
1361 
1362     /* ========== EVENTS ========== */
1363     event RewardPaid(address indexed user, uint256 amount, address token_address, address destination_address);
1364 
1365     /* ========== A CHICKEN ========== */
1366     //
1367     //         ,~.
1368     //      ,-'__ `-,
1369     //     {,-'  `. }              ,')
1370     //    ,( a )   `-.__         ,',')~,
1371     //   <=.) (         `-.__,==' ' ' '}
1372     //     (   )                      /)
1373     //      `-'\   ,                    )
1374     //          |  \        `~.        /
1375     //          \   `._        \      /
1376     //           \     `._____,'    ,'
1377     //            `-.             ,'
1378     //               `-._     _,-'
1379     //                   77jj'
1380     //                  //_||
1381     //               __//--'/`
1382     //             ,--'/`  '
1383     //
1384     // [hjw] https://textart.io/art/vw6Sa3iwqIRGkZsN1BC2vweF/chicken
1385 }
1386 
1387 
1388 // File contracts/Fraxswap/core/interfaces/IUniswapV2PairV5.sol
1389 
1390 
1391 interface IUniswapV2PairV5 {
1392     event Approval(address indexed owner, address indexed spender, uint value);
1393     event Transfer(address indexed from, address indexed to, uint value);
1394 
1395     function name() external pure returns (string memory);
1396     function symbol() external pure returns (string memory);
1397     function decimals() external pure returns (uint8);
1398     function totalSupply() external view returns (uint);
1399     function balanceOf(address owner) external view returns (uint);
1400     function allowance(address owner, address spender) external view returns (uint);
1401 
1402     function approve(address spender, uint value) external returns (bool);
1403     function transfer(address to, uint value) external returns (bool);
1404     function transferFrom(address from, address to, uint value) external returns (bool);
1405 
1406     function DOMAIN_SEPARATOR() external view returns (bytes32);
1407     function PERMIT_TYPEHASH() external pure returns (bytes32);
1408     function nonces(address owner) external view returns (uint);
1409 
1410     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1411 
1412     event Mint(address indexed sender, uint amount0, uint amount1);
1413     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1414     event Swap(
1415         address indexed sender,
1416         uint amount0In,
1417         uint amount1In,
1418         uint amount0Out,
1419         uint amount1Out,
1420         address indexed to
1421     );
1422     event Sync(uint112 reserve0, uint112 reserve1);
1423 
1424     function MINIMUM_LIQUIDITY() external pure returns (uint);
1425     function factory() external view returns (address);
1426     function token0() external view returns (address);
1427     function token1() external view returns (address);
1428     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1429     function price0CumulativeLast() external view returns (uint);
1430     function price1CumulativeLast() external view returns (uint);
1431     function kLast() external view returns (uint);
1432 
1433     function mint(address to) external returns (uint liquidity);
1434     function burn(address to) external returns (uint amount0, uint amount1);
1435     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1436     function skim(address to) external;
1437     function sync() external;
1438     function initialize(address, address) external;
1439 }
1440 
1441 
1442 // File contracts/Fraxswap/core/interfaces/IFraxswapPair.sol
1443 
1444 
1445 // ====================================================================
1446 // |     ______                   _______                             |
1447 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1448 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1449 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1450 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1451 // |                                                                  |
1452 // ====================================================================
1453 // ========================= IFraxswapPair ==========================
1454 // ====================================================================
1455 // Fraxswap LP Pair Interface
1456 // Inspired by https://www.paradigm.xyz/2021/07/twamm
1457 // https://github.com/para-dave/twamm
1458 
1459 // Frax Finance: https://github.com/FraxFinance
1460 
1461 // Primary Author(s)
1462 // Rich Gee: https://github.com/zer0blockchain
1463 // Dennis: https://github.com/denett
1464 
1465 // Reviewer(s) / Contributor(s)
1466 // Travis Moore: https://github.com/FortisFortuna
1467 // Sam Kazemian: https://github.com/samkazemian
1468 
1469 interface IFraxswapPair is IUniswapV2PairV5 {
1470     // TWAMM
1471 
1472     event LongTermSwap0To1(address indexed addr, uint256 orderId, uint256 amount0In, uint256 numberOfTimeIntervals);
1473     event LongTermSwap1To0(address indexed addr, uint256 orderId, uint256 amount1In, uint256 numberOfTimeIntervals);
1474     event CancelLongTermOrder(address indexed addr, uint256 orderId, address sellToken, uint256 unsoldAmount, address buyToken, uint256 purchasedAmount);
1475     event WithdrawProceedsFromLongTermOrder(address indexed addr, uint256 orderId, address indexed proceedToken, uint256 proceeds, bool orderExpired);
1476 
1477     function longTermSwapFrom0To1(uint256 amount0In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
1478     function longTermSwapFrom1To0(uint256 amount1In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
1479     function cancelLongTermSwap(uint256 orderId) external;
1480     function withdrawProceedsFromLongTermSwap(uint256 orderId) external returns (bool is_expired, address rewardTkn, uint256 totalReward);
1481     function executeVirtualOrders(uint256 blockTimestamp) external;
1482 
1483     function orderTimeInterval() external returns (uint256);
1484     function getTWAPHistoryLength() external view returns (uint);
1485     function getTwammReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast, uint112 _twammReserve0, uint112 _twammReserve1);
1486     function getReserveAfterTwamm(uint256 blockTimestamp) external view returns (uint112 _reserve0, uint112 _reserve1, uint256 lastVirtualOrderTimestamp, uint112 _twammReserve0, uint112 _twammReserve1);
1487     function getNextOrderID() external view returns (uint256);
1488     function getOrderIDsForUser(address user) external view returns (uint256[] memory);
1489     function getOrderIDsForUserLength(address user) external view returns (uint256);
1490 //    function getDetailedOrdersForUser(address user, uint256 offset, uint256 limit) external view returns (LongTermOrdersLib.Order[] memory detailed_orders);
1491     function twammUpToDate() external view returns (bool);
1492     function getTwammState() external view returns (uint256 token0Rate, uint256 token1Rate, uint256 lastVirtualOrderTimestamp, uint256 orderTimeInterval_rtn, uint256 rewardFactorPool0, uint256 rewardFactorPool1);
1493     function getTwammSalesRateEnding(uint256 _blockTimestamp) external view returns (uint256 orderPool0SalesRateEnding, uint256 orderPool1SalesRateEnding);
1494     function getTwammRewardFactor(uint256 _blockTimestamp) external view returns (uint256 rewardFactorPool0AtTimestamp, uint256 rewardFactorPool1AtTimestamp);
1495     function getTwammOrder(uint256 orderId) external view returns (uint256 id, uint256 expirationTimestamp, uint256 saleRate, address owner, address sellTokenAddr, address buyTokenAddr);
1496     function getTwammOrderProceedsView(uint256 orderId, uint256 blockTimestamp) external view returns (bool orderExpired, uint256 totalReward);
1497     function getTwammOrderProceeds(uint256 orderId) external returns (bool orderExpired, uint256 totalReward);
1498 
1499 
1500     function togglePauseNewSwaps() external;
1501 }
1502 
1503 
1504 // File contracts/Staking/FraxUnifiedFarm_ERC20.sol
1505 
1506 
1507 // ====================================================================
1508 // |     ______                   _______                             |
1509 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1510 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1511 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1512 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1513 // |                                                                  |
1514 // ====================================================================
1515 // ======================= FraxUnifiedFarm_ERC20 ======================
1516 // ====================================================================
1517 // For ERC20 Tokens
1518 // Uses FraxUnifiedFarmTemplate.sol
1519 
1520 // -------------------- VARIES --------------------
1521 
1522 // Convex wrappers
1523 // import "../Misc_AMOs/convex/IConvexStakingWrapperFrax.sol";
1524 // import "../Misc_AMOs/convex/IDepositToken.sol";
1525 // import "../Misc_AMOs/curve/I2pool.sol";
1526 
1527 // Fraxswap
1528 
1529 // G-UNI
1530 // import "../Misc_AMOs/gelato/IGUniPool.sol";
1531 
1532 // mStable
1533 // import '../Misc_AMOs/mstable/IFeederPool.sol';
1534 
1535 // StakeDAO sdETH-FraxPut
1536 // import '../Misc_AMOs/stakedao/IOpynPerpVault.sol';
1537 
1538 // StakeDAO Vault
1539 // import '../Misc_AMOs/stakedao/IStakeDaoVault.sol';
1540 
1541 // Uniswap V2
1542 // import '../Uniswap/Interfaces/IUniswapV2Pair.sol';
1543 
1544 // Vesper
1545 // import '../Misc_AMOs/vesper/IVPool.sol';
1546 
1547 // ------------------------------------------------
1548 
1549 contract FraxUnifiedFarm_ERC20 is FraxUnifiedFarmTemplate {
1550 
1551     /* ========== STATE VARIABLES ========== */
1552 
1553     // -------------------- COMMON -------------------- 
1554     bool internal immutable frax_is_token0;
1555 
1556     // -------------------- VARIES --------------------
1557 
1558     // Convex stkcvxFPIFRAX
1559     // IConvexStakingWrapperFrax public immutable stakingToken;
1560     // I2pool public curvePool;
1561 
1562     // Fraxswap
1563     IFraxswapPair public immutable stakingToken;
1564 
1565     // G-UNI
1566     // IGUniPool public immutable stakingToken;
1567     
1568     // mStable
1569     // IFeederPool public immutable stakingToken;
1570 
1571     // sdETH-FraxPut Vault
1572     // IOpynPerpVault public immutable stakingToken;
1573 
1574     // StakeDAO Vault
1575     // IStakeDaoVault public immutable stakingToken;
1576 
1577     // Uniswap V2
1578     // IUniswapV2Pair public immutable stakingToken;
1579 
1580     // Vesper
1581     // IVPool public immutable stakingToken;
1582 
1583     // ------------------------------------------------
1584 
1585     // Stake tracking
1586     mapping(address => LockedStake[]) public lockedStakes;
1587 
1588     /* ========== STRUCTS ========== */
1589 
1590     // Struct for the stake
1591     struct LockedStake {
1592         bytes32 kek_id;
1593         uint256 start_timestamp;
1594         uint256 liquidity;
1595         uint256 ending_timestamp;
1596         uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
1597     }
1598     
1599     /* ========== CONSTRUCTOR ========== */
1600 
1601     constructor (
1602         address _owner,
1603         address[] memory _rewardTokens,
1604         address[] memory _rewardManagers,
1605         uint256[] memory _rewardRatesManual,
1606         address[] memory _gaugeControllers,
1607         address[] memory _rewardDistributors,
1608         address _stakingToken
1609     ) 
1610     FraxUnifiedFarmTemplate(_owner, _rewardTokens, _rewardManagers, _rewardRatesManual, _gaugeControllers, _rewardDistributors)
1611     {
1612 
1613         // -------------------- VARIES --------------------
1614         // Convex stkcvxFPIFRAX
1615         // stakingToken = IConvexStakingWrapperFrax(_stakingToken);
1616         // curvePool = I2pool(0xf861483fa7E511fbc37487D91B6FAa803aF5d37c);
1617 
1618         // Fraxswap
1619         stakingToken = IFraxswapPair(_stakingToken);
1620         address token0 = stakingToken.token0();
1621         frax_is_token0 = (token0 == frax_address);
1622 
1623         // G-UNI
1624         // stakingToken = IGUniPool(_stakingToken);
1625         // address token0 = address(stakingToken.token0());
1626         // frax_is_token0 = token0 == frax_address;
1627 
1628         // mStable
1629         // stakingToken = IFeederPool(_stakingToken);
1630 
1631         // StakeDAO sdETH-FraxPut Vault
1632         // stakingToken = IOpynPerpVault(_stakingToken);
1633 
1634         // StakeDAO Vault
1635         // stakingToken = IStakeDaoVault(_stakingToken);
1636 
1637         // Uniswap V2
1638         // stakingToken = IUniswapV2Pair(_stakingToken);
1639         // address token0 = stakingToken.token0();
1640         // if (token0 == frax_address) frax_is_token0 = true;
1641         // else frax_is_token0 = false;
1642 
1643         // Vesper
1644         // stakingToken = IVPool(_stakingToken);
1645     }
1646 
1647     /* ============= VIEWS ============= */
1648 
1649     // ------ FRAX RELATED ------
1650 
1651     function fraxPerLPToken() public view override returns (uint256) {
1652         // Get the amount of FRAX 'inside' of the lp tokens
1653         uint256 frax_per_lp_token;
1654 
1655         // Convex stkcvxFPIFRAX
1656         // ============================================
1657         {
1658             // frax_per_lp_token = curvePool.get_virtual_price() / 2; 
1659             // Count full value here since FRAX and FPI are both part of FRAX ecosystem
1660             // frax_per_lp_token = curvePool.get_virtual_price(); // BAD
1661             // frax_per_lp_token = curvePool.lp_price() / 2;
1662         }
1663 
1664         // Fraxswap
1665         // ============================================
1666         {
1667             uint256 total_frax_reserves;
1668             (uint256 _reserve0, uint256 _reserve1, , ,) = (stakingToken.getReserveAfterTwamm(block.timestamp));
1669             if (frax_is_token0) total_frax_reserves = _reserve0;
1670             else total_frax_reserves = _reserve1;
1671 
1672             frax_per_lp_token = (total_frax_reserves * 1e18) / stakingToken.totalSupply();
1673         }
1674 
1675         // G-UNI
1676         // ============================================
1677         // {
1678         //     (uint256 reserve0, uint256 reserve1) = stakingToken.getUnderlyingBalances();
1679         //     uint256 total_frax_reserves = frax_is_token0 ? reserve0 : reserve1;
1680 
1681         //     frax_per_lp_token = (total_frax_reserves * 1e18) / stakingToken.totalSupply();
1682         // }
1683 
1684         // mStable
1685         // ============================================
1686         // {
1687         //     uint256 total_frax_reserves;
1688         //     (, IFeederPool.BassetData memory vaultData) = (stakingToken.getBasset(frax_address));
1689         //     total_frax_reserves = uint256(vaultData.vaultBalance);
1690         //     frax_per_lp_token = (total_frax_reserves * 1e18) / stakingToken.totalSupply();
1691         // }
1692 
1693         // StakeDAO sdETH-FraxPut Vault
1694         // ============================================
1695         // {
1696         //    uint256 frax3crv_held = stakingToken.totalUnderlyingControlled();
1697         
1698         //    // Optimistically assume 50/50 FRAX/3CRV ratio in the metapool to save gas
1699         //    frax_per_lp_token = ((frax3crv_held * 1e18) / stakingToken.totalSupply()) / 2;
1700         // }
1701 
1702         // StakeDAO Vault
1703         // ============================================
1704         // {
1705         //    uint256 frax3crv_held = stakingToken.balance();
1706         
1707         //    // Optimistically assume 50/50 FRAX/3CRV ratio in the metapool to save gas
1708         //    frax_per_lp_token = ((frax3crv_held * 1e18) / stakingToken.totalSupply()) / 2;
1709         // }
1710 
1711         // Uniswap V2
1712         // ============================================
1713         // {
1714         //     uint256 total_frax_reserves;
1715         //     (uint256 reserve0, uint256 reserve1, ) = (stakingToken.getReserves());
1716         //     if (frax_is_token0) total_frax_reserves = reserve0;
1717         //     else total_frax_reserves = reserve1;
1718 
1719         //     frax_per_lp_token = (total_frax_reserves * 1e18) / stakingToken.totalSupply();
1720         // }
1721 
1722         // Vesper
1723         // ============================================
1724         // frax_per_lp_token = stakingToken.pricePerShare();
1725 
1726         return frax_per_lp_token;
1727     }
1728 
1729     // ------ LIQUIDITY AND WEIGHTS ------
1730 
1731     function calcCurrLockMultiplier(address account, uint256 stake_idx) public view returns (uint256 midpoint_lock_multiplier) {
1732         // Get the stake
1733         LockedStake memory thisStake = lockedStakes[account][stake_idx];
1734 
1735         // Handles corner case where user never claims for a new stake
1736         // Don't want the multiplier going above the max
1737         uint256 accrue_start_time;
1738         if (lastRewardClaimTime[account] < thisStake.start_timestamp) {
1739             accrue_start_time = thisStake.start_timestamp;
1740         }
1741         else {
1742             accrue_start_time = lastRewardClaimTime[account];
1743         }
1744         
1745         // If the lock is expired
1746         if (thisStake.ending_timestamp <= block.timestamp) {
1747             // If the lock expired in the time since the last claim, the weight needs to be proportionately averaged this time
1748             if (lastRewardClaimTime[account] < thisStake.ending_timestamp){
1749                 uint256 time_before_expiry = thisStake.ending_timestamp - accrue_start_time;
1750                 uint256 time_after_expiry = block.timestamp - thisStake.ending_timestamp;
1751 
1752                 // Average the pre-expiry lock multiplier
1753                 uint256 pre_expiry_avg_multiplier = lockMultiplier(time_before_expiry / 2);
1754 
1755                 // Get the weighted-average lock_multiplier
1756                 // uint256 numerator = (pre_expiry_avg_multiplier * time_before_expiry) + (MULTIPLIER_PRECISION * time_after_expiry);
1757                 uint256 numerator = (pre_expiry_avg_multiplier * time_before_expiry) + (0 * time_after_expiry);
1758                 midpoint_lock_multiplier = numerator / (time_before_expiry + time_after_expiry);
1759             }
1760             else {
1761                 // Otherwise, it needs to just be 1x
1762                 // midpoint_lock_multiplier = MULTIPLIER_PRECISION;
1763 
1764                 // Otherwise, it needs to just be 0x
1765                 midpoint_lock_multiplier = 0;
1766             }
1767         }
1768         // If the lock is not expired
1769         else {
1770             // Decay the lock multiplier based on the time left
1771             uint256 avg_time_left;
1772             {
1773                 uint256 time_left_p1 = thisStake.ending_timestamp - accrue_start_time;
1774                 uint256 time_left_p2 = thisStake.ending_timestamp - block.timestamp;
1775                 avg_time_left = (time_left_p1 + time_left_p2) / 2;
1776             }
1777             midpoint_lock_multiplier = lockMultiplier(avg_time_left);
1778         }
1779 
1780         // Sanity check: make sure it never goes above the initial multiplier
1781         if (midpoint_lock_multiplier > thisStake.lock_multiplier) midpoint_lock_multiplier = thisStake.lock_multiplier;
1782     }
1783 
1784     // Calculate the combined weight for an account
1785     function calcCurCombinedWeight(address account) public override view
1786         returns (
1787             uint256 old_combined_weight,
1788             uint256 new_vefxs_multiplier,
1789             uint256 new_combined_weight
1790         )
1791     {
1792         // Get the old combined weight
1793         old_combined_weight = _combined_weights[account];
1794 
1795         // Get the veFXS multipliers
1796         // For the calculations, use the midpoint (analogous to midpoint Riemann sum)
1797         new_vefxs_multiplier = veFXSMultiplier(account);
1798 
1799         uint256 midpoint_vefxs_multiplier;
1800         if (
1801             (_locked_liquidity[account] == 0 && _combined_weights[account] == 0) || 
1802             (new_vefxs_multiplier > _vefxsMultiplierStored[account])
1803         ) {
1804             // This is only called for the first stake to make sure the veFXS multiplier is not cut in half
1805             // Also used if the user increased their position
1806             midpoint_vefxs_multiplier = new_vefxs_multiplier;
1807         }
1808         else {
1809             // Handles natural decay with a non-increased veFXS position
1810             midpoint_vefxs_multiplier = (new_vefxs_multiplier + _vefxsMultiplierStored[account]) / 2;
1811         }
1812 
1813         // Loop through the locked stakes, first by getting the liquidity * lock_multiplier portion
1814         new_combined_weight = 0;
1815         for (uint256 i = 0; i < lockedStakes[account].length; i++) {
1816             LockedStake memory thisStake = lockedStakes[account][i];
1817 
1818             // Calculate the midpoint lock multiplier
1819             uint256 midpoint_lock_multiplier = calcCurrLockMultiplier(account, i);
1820 
1821             // Calculate the combined boost
1822             uint256 liquidity = thisStake.liquidity;
1823             uint256 combined_boosted_amount = liquidity + ((liquidity * (midpoint_lock_multiplier + midpoint_vefxs_multiplier)) / MULTIPLIER_PRECISION);
1824             new_combined_weight += combined_boosted_amount;
1825         }
1826     }
1827 
1828     // ------ LOCK RELATED ------
1829 
1830     // All the locked stakes for a given account
1831     function lockedStakesOf(address account) external view returns (LockedStake[] memory) {
1832         return lockedStakes[account];
1833     }
1834 
1835     // Returns the length of the locked stakes for a given account
1836     function lockedStakesOfLength(address account) external view returns (uint256) {
1837         return lockedStakes[account].length;
1838     }
1839 
1840     // // All the locked stakes for a given account [old-school method]
1841     // function lockedStakesOfMultiArr(address account) external view returns (
1842     //     bytes32[] memory kek_ids,
1843     //     uint256[] memory start_timestamps,
1844     //     uint256[] memory liquidities,
1845     //     uint256[] memory ending_timestamps,
1846     //     uint256[] memory lock_multipliers
1847     // ) {
1848     //     for (uint256 i = 0; i < lockedStakes[account].length; i++){ 
1849     //         LockedStake memory thisStake = lockedStakes[account][i];
1850     //         kek_ids[i] = thisStake.kek_id;
1851     //         start_timestamps[i] = thisStake.start_timestamp;
1852     //         liquidities[i] = thisStake.liquidity;
1853     //         ending_timestamps[i] = thisStake.ending_timestamp;
1854     //         lock_multipliers[i] = thisStake.lock_multiplier;
1855     //     }
1856     // }
1857 
1858     /* =============== MUTATIVE FUNCTIONS =============== */
1859 
1860     // ------ STAKING ------
1861 
1862     function _getStake(address staker_address, bytes32 kek_id) internal view returns (LockedStake memory locked_stake, uint256 arr_idx) {
1863         for (uint256 i = 0; i < lockedStakes[staker_address].length; i++){ 
1864             if (kek_id == lockedStakes[staker_address][i].kek_id){
1865                 locked_stake = lockedStakes[staker_address][i];
1866                 arr_idx = i;
1867                 break;
1868             }
1869         }
1870         require(locked_stake.kek_id == kek_id, "Stake not found");
1871         
1872     }
1873 
1874     // Add additional LPs to an existing locked stake
1875     function lockAdditional(bytes32 kek_id, uint256 addl_liq) nonReentrant updateRewardAndBalanceMdf(msg.sender, true) public {
1876         // Get the stake and its index
1877         (LockedStake memory thisStake, uint256 theArrayIndex) = _getStake(msg.sender, kek_id);
1878 
1879         // Calculate the new amount
1880         uint256 new_amt = thisStake.liquidity + addl_liq;
1881 
1882         // Checks
1883         require(addl_liq >= 0, "Must be positive");
1884 
1885         // Pull the tokens from the sender
1886         TransferHelper.safeTransferFrom(address(stakingToken), msg.sender, address(this), addl_liq);
1887 
1888         // Update the stake
1889         lockedStakes[msg.sender][theArrayIndex] = LockedStake(
1890             kek_id,
1891             thisStake.start_timestamp,
1892             new_amt,
1893             thisStake.ending_timestamp,
1894             thisStake.lock_multiplier
1895         );
1896 
1897         // Update liquidities
1898         _total_liquidity_locked += addl_liq;
1899         _locked_liquidity[msg.sender] += addl_liq;
1900         {
1901             address the_proxy = getProxyFor(msg.sender);
1902             if (the_proxy != address(0)) proxy_lp_balances[the_proxy] += addl_liq;
1903         }
1904 
1905         // Need to call to update the combined weights
1906         updateRewardAndBalance(msg.sender, false);
1907 
1908         emit LockedAdditional(msg.sender, kek_id, addl_liq);
1909     }
1910 
1911     // Extends the lock of an existing stake
1912     function lockLonger(bytes32 kek_id, uint256 new_ending_ts) nonReentrant updateRewardAndBalanceMdf(msg.sender, true) public {
1913         // Get the stake and its index
1914         (LockedStake memory thisStake, uint256 theArrayIndex) = _getStake(msg.sender, kek_id);
1915 
1916         // Check
1917         require(new_ending_ts > block.timestamp, "Must be in the future");
1918 
1919         // Calculate some times
1920         uint256 time_left = (thisStake.ending_timestamp > block.timestamp) ? thisStake.ending_timestamp - block.timestamp : 0;
1921         uint256 new_secs = new_ending_ts - block.timestamp;
1922 
1923         // Checks
1924         // require(time_left > 0, "Already expired");
1925         require(new_secs > time_left, "Cannot shorten lock time");
1926         require(new_secs >= lock_time_min, "Minimum stake time not met");
1927         require(new_secs <= lock_time_for_max_multiplier, "Trying to lock for too long");
1928 
1929         // Update the stake
1930         lockedStakes[msg.sender][theArrayIndex] = LockedStake(
1931             kek_id,
1932             block.timestamp,
1933             thisStake.liquidity,
1934             new_ending_ts,
1935             lockMultiplier(new_secs)
1936         );
1937 
1938         // Need to call to update the combined weights
1939         updateRewardAndBalance(msg.sender, false);
1940 
1941         emit LockedLonger(msg.sender, kek_id, new_secs, block.timestamp, new_ending_ts);
1942     }
1943 
1944     
1945 
1946     // Two different stake functions are needed because of delegateCall and msg.sender issues (important for proxies)
1947     function stakeLocked(uint256 liquidity, uint256 secs) nonReentrant external returns (bytes32) {
1948         return _stakeLocked(msg.sender, msg.sender, liquidity, secs, block.timestamp);
1949     }
1950 
1951     // If this were not internal, and source_address had an infinite approve, this could be exploitable
1952     // (pull funds from source_address and stake for an arbitrary staker_address)
1953     function _stakeLocked(
1954         address staker_address,
1955         address source_address,
1956         uint256 liquidity,
1957         uint256 secs,
1958         uint256 start_timestamp
1959     ) internal updateRewardAndBalanceMdf(staker_address, true) returns (bytes32) {
1960         require(stakingPaused == false, "Staking paused");
1961         require(secs >= lock_time_min, "Minimum stake time not met");
1962         require(secs <= lock_time_for_max_multiplier,"Trying to lock for too long");
1963 
1964         // Pull in the required token(s)
1965         // Varies per farm
1966         TransferHelper.safeTransferFrom(address(stakingToken), source_address, address(this), liquidity);
1967 
1968         // Get the lock multiplier and kek_id
1969         uint256 lock_multiplier = lockMultiplier(secs);
1970         bytes32 kek_id = keccak256(abi.encodePacked(staker_address, start_timestamp, liquidity, _locked_liquidity[staker_address]));
1971         
1972         // Create the locked stake
1973         lockedStakes[staker_address].push(LockedStake(
1974             kek_id,
1975             start_timestamp,
1976             liquidity,
1977             start_timestamp + secs,
1978             lock_multiplier
1979         ));
1980 
1981         // Update liquidities
1982         _total_liquidity_locked += liquidity;
1983         _locked_liquidity[staker_address] += liquidity;
1984         {
1985             address the_proxy = getProxyFor(staker_address);
1986             if (the_proxy != address(0)) proxy_lp_balances[the_proxy] += liquidity;
1987         }
1988         
1989         // Need to call again to make sure everything is correct
1990         updateRewardAndBalance(staker_address, false);
1991 
1992         emit StakeLocked(staker_address, liquidity, secs, kek_id, source_address);
1993 
1994         return kek_id;
1995     }
1996 
1997     // ------ WITHDRAWING ------
1998 
1999     // Two different withdrawLocked functions are needed because of delegateCall and msg.sender issues (important for proxies)
2000     function withdrawLocked(bytes32 kek_id, address destination_address) nonReentrant external returns (uint256) {
2001         require(withdrawalsPaused == false, "Withdrawals paused");
2002         return _withdrawLocked(msg.sender, destination_address, kek_id);
2003     }
2004 
2005     // No withdrawer == msg.sender check needed since this is only internally callable and the checks are done in the wrapper
2006     function _withdrawLocked(
2007         address staker_address,
2008         address destination_address,
2009         bytes32 kek_id
2010     ) internal returns (uint256) {
2011         // Collect rewards first and then update the balances
2012         _getReward(staker_address, destination_address, true);
2013 
2014         // Get the stake and its index
2015         (LockedStake memory thisStake, uint256 theArrayIndex) = _getStake(staker_address, kek_id);
2016         require(block.timestamp >= thisStake.ending_timestamp || stakesUnlocked == true, "Stake is still locked!");
2017         uint256 liquidity = thisStake.liquidity;
2018 
2019         if (liquidity > 0) {
2020 
2021             // Give the tokens to the destination_address
2022             // Should throw if insufficient balance
2023             TransferHelper.safeTransfer(address(stakingToken), destination_address, liquidity);
2024 
2025             // Update liquidities
2026             _total_liquidity_locked -= liquidity;
2027             _locked_liquidity[staker_address] -= liquidity;
2028             {
2029                 address the_proxy = getProxyFor(staker_address);
2030                 if (the_proxy != address(0)) proxy_lp_balances[the_proxy] -= liquidity;
2031             }
2032 
2033             // Remove the stake from the array
2034             delete lockedStakes[staker_address][theArrayIndex];
2035 
2036             // Need to call again to make sure everything is correct
2037             updateRewardAndBalance(staker_address, false);
2038 
2039             emit WithdrawLocked(staker_address, liquidity, kek_id, destination_address);
2040         }
2041 
2042         return liquidity;
2043     }
2044 
2045 
2046     function _getRewardExtraLogic(address rewardee, address destination_address) internal override {
2047         // Do nothing
2048     }
2049 
2050     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
2051 
2052     // Inherited...
2053 
2054     /* ========== EVENTS ========== */
2055     event LockedAdditional(address indexed user, bytes32 kek_id, uint256 amount);
2056     event LockedLonger(address indexed user, bytes32 kek_id, uint256 new_secs, uint256 new_start_ts, uint256 new_end_ts);
2057     event StakeLocked(address indexed user, uint256 amount, uint256 secs, bytes32 kek_id, address source_address);
2058     event WithdrawLocked(address indexed user, uint256 liquidity, bytes32 kek_id, address destination_address);
2059 }
2060 
2061 
2062 // File contracts/Staking/Variants/FraxUnifiedFarm_ERC20_Fraxswap_FRAX_IQ.sol
2063 
2064 
2065 contract FraxUnifiedFarm_ERC20_Fraxswap_FRAX_IQ is FraxUnifiedFarm_ERC20 {
2066     constructor (
2067         address _owner,
2068         address[] memory _rewardTokens,
2069         address[] memory _rewardManagers,
2070         uint256[] memory _rewardRates,
2071         address[] memory _gaugeControllers,
2072         address[] memory _rewardDistributors,
2073         address _stakingToken 
2074     ) 
2075     FraxUnifiedFarm_ERC20(_owner , _rewardTokens, _rewardManagers, _rewardRates, _gaugeControllers, _rewardDistributors, _stakingToken)
2076     {}
2077 }