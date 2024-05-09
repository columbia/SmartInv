1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
219 
220 
221 pragma solidity >=0.6.0 <0.8.0;
222 
223 /**
224  * @dev Interface of the ERC20 standard as defined in the EIP.
225  */
226 interface IERC20 {
227     /**
228      * @dev Returns the amount of tokens in existence.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns the amount of tokens owned by `account`.
234      */
235     function balanceOf(address account) external view returns (uint256);
236 
237     /**
238      * @dev Moves `amount` tokens from the caller's account to `recipient`.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transfer(address recipient, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Returns the remaining number of tokens that `spender` will be
248      * allowed to spend on behalf of `owner` through {transferFrom}. This is
249      * zero by default.
250      *
251      * This value changes when {approve} or {transferFrom} are called.
252      */
253     function allowance(address owner, address spender) external view returns (uint256);
254 
255     /**
256      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * IMPORTANT: Beware that changing an allowance with this method brings the risk
261      * that someone may use both the old and the new allowance by unfortunate
262      * transaction ordering. One possible solution to mitigate this race
263      * condition is to first reduce the spender's allowance to 0 and set the
264      * desired value afterwards:
265      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266      *
267      * Emits an {Approval} event.
268      */
269     function approve(address spender, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Moves `amount` tokens from `sender` to `recipient` using the
273      * allowance mechanism. `amount` is then deducted from the caller's
274      * allowance.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Emitted when `value` tokens are moved from one account (`from`) to
284      * another (`to`).
285      *
286      * Note that `value` may be zero.
287      */
288     event Transfer(address indexed from, address indexed to, uint256 value);
289 
290     /**
291      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
292      * a call to {approve}. `value` is the new allowance.
293      */
294     event Approval(address indexed owner, address indexed spender, uint256 value);
295 }
296 
297 // File: @openzeppelin/contracts/utils/Context.sol
298 
299 
300 pragma solidity >=0.6.0 <0.8.0;
301 
302 /*
303  * @dev Provides information about the current execution context, including the
304  * sender of the transaction and its data. While these are generally available
305  * via msg.sender and msg.data, they should not be accessed in such a direct
306  * manner, since when dealing with GSN meta-transactions the account sending and
307  * paying for execution may not be the actual sender (as far as an application
308  * is concerned).
309  *
310  * This contract is only required for intermediate, library-like contracts.
311  */
312 abstract contract Context {
313     function _msgSender() internal view virtual returns (address payable) {
314         return msg.sender;
315     }
316 
317     function _msgData() internal view virtual returns (bytes memory) {
318         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
319         return msg.data;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/access/Ownable.sol
324 
325 
326 pragma solidity >=0.6.0 <0.8.0;
327 
328 /**
329  * @dev Contract module which provides a basic access control mechanism, where
330  * there is an account (an owner) that can be granted exclusive access to
331  * specific functions.
332  *
333  * By default, the owner account will be the one that deploys the contract. This
334  * can later be changed with {transferOwnership}.
335  *
336  * This module is used through inheritance. It will make available the modifier
337  * `onlyOwner`, which can be applied to your functions to restrict their use to
338  * the owner.
339  */
340 abstract contract Ownable is Context {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     /**
346      * @dev Initializes the contract setting the deployer as the initial owner.
347      */
348     constructor () internal {
349         address msgSender = _msgSender();
350         _owner = msgSender;
351         emit OwnershipTransferred(address(0), msgSender);
352     }
353 
354     /**
355      * @dev Returns the address of the current owner.
356      */
357     function owner() public view virtual returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     /**
370      * @dev Leaves the contract without owner. It will not be possible to call
371      * `onlyOwner` functions anymore. Can only be called by the current owner.
372      *
373      * NOTE: Renouncing ownership will leave the contract without an owner,
374      * thereby removing any functionality that is only available to the owner.
375      */
376     function renounceOwnership() public virtual onlyOwner {
377         emit OwnershipTransferred(_owner, address(0));
378         _owner = address(0);
379     }
380 
381     /**
382      * @dev Transfers ownership of the contract to a new account (`newOwner`).
383      * Can only be called by the current owner.
384      */
385     function transferOwnership(address newOwner) public virtual onlyOwner {
386         require(newOwner != address(0), "Ownable: new owner is the zero address");
387         emit OwnershipTransferred(_owner, newOwner);
388         _owner = newOwner;
389     }
390 }
391 
392 // File: contracts/interfaces/Owned.sol
393 
394 pragma solidity 0.7.5;
395 
396 
397 abstract contract Owned is Ownable {
398     constructor(address _owner) {
399         transferOwnership(_owner);
400     }
401 }
402 
403 // File: contracts/LinearVesting.sol
404 
405 pragma solidity 0.7.5;
406 
407 
408 // Inheritance
409 
410 
411 
412 
413 /// @title   Umbrella Rewards contract
414 /// @author  umb.network
415 /// @notice  This contract serves TOKEN DISTRIBUTION AT LAUNCH for:
416 ///           - node, founders, early contributors etc...
417 ///          It can be used for future distributions for next milestones also
418 ///          as its functionality stays the same.
419 ///          It supports linear vesting
420 /// @dev     Deploy contract. Mint tokens reward for this contract.
421 ///          Then as owner call .setupDistribution() and then start()
422 contract LinearVesting is Owned {
423     using SafeMath for uint256;
424 
425     uint8 public constant VERSION = 2;
426 
427     IERC20 public umbToken;
428     uint256 public totalVestingAmount;
429 
430     mapping(address => Reward) public rewards;
431 
432     struct Reward {
433         uint256 total;
434         uint256 duration;
435         uint256 paid;
436         uint256 startTime;
437     }
438 
439     // ========== CONSTRUCTOR ========== //
440 
441     constructor(address _owner, address _token) Owned(_owner) {
442         require(_token != address(0x0), "empty _token");
443 
444         umbToken = IERC20(_token);
445     }
446 
447     // ========== VIEWS ========== //
448 
449     function balanceOf(address _address) public view returns (uint256) {
450         Reward memory reward = rewards[_address];
451 
452         if (block.timestamp <= reward.startTime) {
453             return 0;
454         }
455 
456         if (block.timestamp >= reward.startTime.add(reward.duration)) {
457             return reward.total - reward.paid;
458         }
459 
460         return reward.total.mul(block.timestamp - reward.startTime).div(reward.duration) - reward.paid;
461     }
462 
463     // ========== MUTATIVE FUNCTIONS ========== //
464 
465     function claim() external {
466         _claim(msg.sender);
467     }
468 
469     function claimFor(address[] calldata _participants) external {
470         for (uint i = 0; i < _participants.length; i++) {
471             _claim(_participants[i]);
472         }
473     }
474 
475     // ========== RESTRICTED FUNCTIONS ========== //
476 
477     function _claim(address _participant) internal {
478         uint256 balance = balanceOf(_participant);
479         require(balance != 0, "you have no tokens to claim");
480 
481         // no need for safe math because sum was calculated using safeMath
482         rewards[_participant].paid += balance;
483 
484         // this is our token, we can save gas and simple use transfer instead safeTransfer
485         require(umbToken.transfer(_participant, balance), "umb.transfer failed");
486 
487         emit LogClaimed(_participant, balance);
488     }
489 
490     function addRewards(
491         address[] calldata _participants,
492         uint256[] calldata _rewards,
493         uint256[] calldata _durations,
494         uint256[] calldata _startTimes
495     )
496     external onlyOwner {
497         require(_participants.length != 0, "there is no _participants");
498         require(_participants.length == _rewards.length, "_participants count must match _rewards count");
499         require(_participants.length == _durations.length, "_participants count must match _durations count");
500         require(_participants.length == _startTimes.length, "_participants count must match _startTimes count");
501 
502         uint256 sum = totalVestingAmount;
503 
504         for (uint256 i = 0; i < _participants.length; i++) {
505             require(_participants[i] != address(0x0), "empty participant");
506             require(_durations[i] != 0, "empty duration");
507             require(_durations[i] < 5 * 365 days, "duration too long");
508             require(_rewards[i] != 0, "empty reward");
509             require(_startTimes[i] != 0, "empty startTime");
510 
511             uint256 total = rewards[_participants[i]].total;
512 
513             if (total < _rewards[i]) {
514                 // we increased existing reward, so sum will be higher
515                 sum = sum.add(_rewards[i] - total);
516             } else {
517                 // we decreased existing reward, so sum will be lower
518                 sum = sum.sub(total - _rewards[i]);
519             }
520 
521             if (total != 0) {
522                 // updating existing
523                 require(rewards[_participants[i]].startTime == _startTimes[i], "can't change start time");
524                 require(
525                     _rewards[i] >= balanceOf(_participants[i]) + rewards[_participants[i]].paid,
526                         "can't take what's already done"
527                 );
528 
529                 rewards[_participants[i]].total = _rewards[i];
530                 rewards[_participants[i]].duration = _durations[i];
531             } else {
532                 // new participant
533                 rewards[_participants[i]] = Reward(_rewards[i], _durations[i], 0, _startTimes[i]);
534             }
535         }
536 
537         emit LogSetup(totalVestingAmount, sum);
538         totalVestingAmount = sum;
539     }
540 
541     // ========== EVENTS ========== //
542 
543     event LogSetup(uint256 prevSum, uint256 newSum);
544     event LogClaimed(address indexed recipient, uint256 amount);
545 }
