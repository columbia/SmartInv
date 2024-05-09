1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         uint256 c = a + b;
26         if (c < a) return (false, 0);
27         return (true, c);
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a / b);
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b == 0) return (false, 0);
72         return (true, a % b);
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a, "SafeMath: subtraction overflow");
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) return 0;
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b > 0, "SafeMath: division by zero");
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {tryDiv}.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * reverting with custom message when dividing by zero.
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {tryMod}.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 
217 
218 /**
219  * @dev Standard math utilities missing in the Solidity language.
220  */
221 library Math {
222     /**
223      * @dev Returns the largest of two numbers.
224      */
225     function max(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a >= b ? a : b;
227     }
228 
229     /**
230      * @dev Returns the smallest of two numbers.
231      */
232     function min(uint256 a, uint256 b) internal pure returns (uint256) {
233         return a < b ? a : b;
234     }
235 
236     /**
237      * @dev Returns the average of two numbers. The result is rounded towards
238      * zero.
239      */
240     function average(uint256 a, uint256 b) internal pure returns (uint256) {
241         // (a + b) / 2 can overflow, so we distribute
242         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
243     }
244 }
245 
246 
247 
248 /**
249  * @dev Interface of the ERC20 standard as defined in the EIP.
250  */
251 interface IERC20 {
252     /**
253      * @dev Returns the amount of tokens in existence.
254      */
255     function totalSupply() external view returns (uint256);
256 
257     /**
258      * @dev Returns the amount of tokens owned by `account`.
259      */
260     function balanceOf(address account) external view returns (uint256);
261 
262     /**
263      * @dev Moves `amount` tokens from the caller's account to `recipient`.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transfer(address recipient, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Returns the remaining number of tokens that `spender` will be
273      * allowed to spend on behalf of `owner` through {transferFrom}. This is
274      * zero by default.
275      *
276      * This value changes when {approve} or {transferFrom} are called.
277      */
278     function allowance(address owner, address spender) external view returns (uint256);
279 
280     /**
281      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * IMPORTANT: Beware that changing an allowance with this method brings the risk
286      * that someone may use both the old and the new allowance by unfortunate
287      * transaction ordering. One possible solution to mitigate this race
288      * condition is to first reduce the spender's allowance to 0 and set the
289      * desired value afterwards:
290      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291      *
292      * Emits an {Approval} event.
293      */
294     function approve(address spender, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Moves `amount` tokens from `sender` to `recipient` using the
298      * allowance mechanism. `amount` is then deducted from the caller's
299      * allowance.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
306 
307     /**
308      * @dev Emitted when `value` tokens are moved from one account (`from`) to
309      * another (`to`).
310      *
311      * Note that `value` may be zero.
312      */
313     event Transfer(address indexed from, address indexed to, uint256 value);
314 
315     /**
316      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
317      * a call to {approve}. `value` is the new allowance.
318      */
319     event Approval(address indexed owner, address indexed spender, uint256 value);
320 }
321 
322 
323 
324 /*
325  * @dev Provides information about the current execution context, including the
326  * sender of the transaction and its data. While these are generally available
327  * via msg.sender and msg.data, they should not be accessed in such a direct
328  * manner, since when dealing with GSN meta-transactions the account sending and
329  * paying for execution may not be the actual sender (as far as an application
330  * is concerned).
331  *
332  * This contract is only required for intermediate, library-like contracts.
333  */
334 abstract contract Context {
335     function _msgSender() internal view virtual returns (address payable) {
336         return msg.sender;
337     }
338 
339     function _msgData() internal view virtual returns (bytes memory) {
340         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
341         return msg.data;
342     }
343 }
344 
345 
346 
347 
348 /**
349  * @dev Contract module which provides a basic access control mechanism, where
350  * there is an account (an owner) that can be granted exclusive access to
351  * specific functions.
352  *
353  * By default, the owner account will be the one that deploys the contract. This
354  * can later be changed with {transferOwnership}.
355  *
356  * This module is used through inheritance. It will make available the modifier
357  * `onlyOwner`, which can be applied to your functions to restrict their use to
358  * the owner.
359  */
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365     /**
366      * @dev Initializes the contract setting the deployer as the initial owner.
367      */
368     constructor () internal {
369         address msgSender = _msgSender();
370         _owner = msgSender;
371         emit OwnershipTransferred(address(0), msgSender);
372     }
373 
374     /**
375      * @dev Returns the address of the current owner.
376      */
377     function owner() public view virtual returns (address) {
378         return _owner;
379     }
380 
381     /**
382      * @dev Throws if called by any account other than the owner.
383      */
384     modifier onlyOwner() {
385         require(owner() == _msgSender(), "Ownable: caller is not the owner");
386         _;
387     }
388 
389     /**
390      * @dev Leaves the contract without owner. It will not be possible to call
391      * `onlyOwner` functions anymore. Can only be called by the current owner.
392      *
393      * NOTE: Renouncing ownership will leave the contract without an owner,
394      * thereby removing any functionality that is only available to the owner.
395      */
396     function renounceOwnership() public virtual onlyOwner {
397         emit OwnershipTransferred(_owner, address(0));
398         _owner = address(0);
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Can only be called by the current owner.
404      */
405     function transferOwnership(address newOwner) public virtual onlyOwner {
406         require(newOwner != address(0), "Ownable: new owner is the zero address");
407         emit OwnershipTransferred(_owner, newOwner);
408         _owner = newOwner;
409     }
410 }
411 
412 
413 
414 pragma experimental ABIEncoderV2;
415 
416 contract Staking is Ownable {
417     using SafeMath for uint256;
418 
419     uint256 public _startTime;
420     uint256 public _endTime;
421     uint256 public _getRewardEndTime;
422     uint256 public _rewardRate;
423     
424     uint256 public _releaseInterval = 1 weeks;
425     uint256 public _getRewardInterval = 35 weeks;
426     
427     uint256 lockTimes = 20;
428 
429     IERC20 public _stakingToken;
430     IERC20 public _rewardToken;
431 
432     uint256 public _rewardPerTokenStored;
433     uint256 public _lastUpdateTime;
434 
435     mapping(address => uint256) public _rewards;
436     mapping(address => uint256) public _userRewardPerTokenPaid;
437     mapping(address => uint256) public _receivedRewards;
438 
439     uint256 public _supply;
440     mapping(address => uint256) public _balance;
441 
442     mapping(address => LockAmount) public _lockAmount;
443 
444     struct LockAmount {
445         uint256[] amount;
446         uint256 releaseTime;
447         uint256 pos;
448     }
449 
450     event Staked(address indexed sender, uint256 indexed amount);
451     event Withdrawn(address indexed sender, uint256 indexed amount);
452     event GotReward(address indexed sender, uint256 indexed amount);
453 
454     constructor(
455         uint256 startTime_,
456         uint256 endTime_,
457         uint256 rewardRate_,
458         address stakingToken_,
459         address rewardToken_
460     ) {
461         _startTime = startTime_;
462         _endTime = endTime_;
463         _getRewardEndTime = startTime_ + _getRewardInterval;
464         _rewardRate = rewardRate_;
465         _stakingToken = IERC20(stakingToken_);
466         _rewardToken = IERC20(rewardToken_);
467     }
468 
469     function balanceOf(address account) public view returns (uint256) {
470         return _balance[account];
471     }
472 
473     modifier updateReward(address account) {
474         _rewardPerTokenStored = rewardPerToken();
475         _lastUpdateTime = lastTimeRewardApplicable();
476         if (account != address(0)) {
477             _rewards[account] = earned(account);
478             _userRewardPerTokenPaid[account] = _rewardPerTokenStored;
479         }
480         _;
481     }
482 
483     function lockedIncomeBalanceOf(address account) public view returns (LockAmount memory) {
484         return _lockAmount[account];
485     }
486 
487     function rewardPart(address account) public view returns (uint256 unlocked, uint256 locked) {
488         uint256 earn = earned(account);
489         unlocked = unlocked.add(earn.div(lockTimes));
490         locked = locked.add(earn.sub(earn.div(lockTimes)));
491 
492         LockAmount memory amount = _lockAmount[account];
493         uint256 lockTime = amount.releaseTime;
494         for (uint256 i = amount.pos; i < amount.amount.length; i++) {
495             if (lockTime < block.timestamp) {
496                 unlocked = unlocked.add(amount.amount[i]);
497             } else {
498                 locked = locked.add(amount.amount[i]);
499             }
500             lockTime = lockTime.add(_releaseInterval);
501         }
502     }
503 
504     function earned(address account) public view returns (uint256) {
505         return
506             balanceOf(account)
507                 .mul(rewardPerToken().sub(_userRewardPerTokenPaid[account]))
508                 .div(1e18)
509                 .add(_rewards[account]);
510     }
511 
512     function stake(uint256 amount) public updateReward(msg.sender) {
513         require(block.timestamp < _endTime, "the end");
514         require(amount > 0, "cannot stake 0");
515 
516         _balance[msg.sender] = _balance[msg.sender].add(amount);
517         _supply = _supply.add(amount);
518 
519         require(
520             _stakingToken.transferFrom(msg.sender, address(this), amount),
521             "transferFrom fail"
522         );
523 
524         emit Staked(msg.sender, amount);
525     }
526 
527     function withdraw(uint256 amount) public updateReward(msg.sender) {
528         require(amount > 0, "cannot withdraw 0");
529         require(balanceOf(msg.sender) >= amount, "Insufficient funds");
530 
531         _balance[msg.sender] = _balance[msg.sender].sub(amount);
532         _supply = _supply.sub(amount);
533 
534         require(_stakingToken.transfer(msg.sender, amount), "withdraw fail");
535 
536         emit Withdrawn(msg.sender, amount);
537     }
538 
539     function exit() public {
540         withdraw(balanceOf(msg.sender));
541         getReward();
542     }
543 
544     function getReward() public updateReward(msg.sender) {
545         require(block.timestamp < _getRewardEndTime, "get reward timeout");
546         LockAmount storage lockAmount = _lockAmount[msg.sender];
547         
548         uint256 releaseAmount = 0;
549 
550         for (uint256 i = lockAmount.pos; i < lockAmount.amount.length; i++) {
551             if (lockAmount.releaseTime > block.timestamp) {
552                 break;
553             }
554             releaseAmount = releaseAmount.add(lockAmount.amount[i]);
555             lockAmount.releaseTime = lockAmount.releaseTime.add(_releaseInterval);
556             lockAmount.pos = lockAmount.pos.add(1);
557         }
558 
559         uint256 reward = _rewards[msg.sender];
560         if (reward > 0) {
561             _rewards[msg.sender] = 0;
562             
563             uint256 part = reward.div(lockTimes);
564             
565             releaseAmount = releaseAmount.add(part);
566 
567             if (lockAmount.amount.length == lockAmount.pos) {
568                 lockAmount.releaseTime = block.timestamp.add(_releaseInterval);
569             }
570 
571             
572             uint256 pos;
573             for (uint256 i = 0; i < lockTimes - 2; i++) {
574                 pos = lockAmount.pos.add(i);
575                 if (pos < lockAmount.amount.length) {
576                     lockAmount.amount[pos] = lockAmount.amount[pos].add(part);
577                 } else {
578                     lockAmount.amount.push(part);
579                 }
580             }
581 
582             pos = pos.add(1);
583             
584             uint256 lastAmount = reward.sub(part.mul(lockTimes - 1));
585             if (pos < lockAmount.amount.length) {
586                 lockAmount.amount[pos] = lockAmount.amount[pos].add(lastAmount);
587             } else {
588                 lockAmount.amount.push(lastAmount);
589             }
590         }
591 
592         if (releaseAmount > 0) {
593             _receivedRewards[msg.sender] = _receivedRewards[msg.sender].add(releaseAmount);
594 
595             require(
596                 _rewardToken.transfer(msg.sender, releaseAmount),
597                 "reward token fail"
598             );
599 
600             emit GotReward(msg.sender, releaseAmount);
601         }
602     }
603 
604     function lastTimeRewardApplicable() public view returns (uint256) {
605         return Math.max(_startTime, Math.min(block.timestamp, _endTime));
606     }
607 
608     function rewardPerToken() public view returns (uint256) {
609         if (_supply == 0) {
610             return _rewardPerTokenStored;
611         }
612         return
613             _rewardPerTokenStored.add(
614                 lastTimeRewardApplicable()
615                     .sub(_lastUpdateTime)
616                     .mul(_rewardRate)
617                     .mul(1e18)
618                     .div(_supply)
619             );
620     }
621 
622 
623     function transferERCToken(address tokenContractAddress, address to, uint256 amount) public onlyOwner {
624         require(IERC20(tokenContractAddress).transfer(to, amount), "transfer other token fail");
625     }
626 }