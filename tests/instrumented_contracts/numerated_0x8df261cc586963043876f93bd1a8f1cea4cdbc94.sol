1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See `IERC20.approve`.
218  */
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     /**
229      * @dev See `IERC20.totalSupply`.
230      */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See `IERC20.balanceOf`.
237      */
238     function balanceOf(address account) public view returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See `IERC20.transfer`.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See `IERC20.allowance`.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See `IERC20.approve`.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.transferFrom`.
276      *
277      * Emits an `Approval` event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of `ERC20`;
279      *
280      * Requirements:
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `value`.
283      * - the caller must have allowance for `sender`'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to `transfer`, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a `Transfer` event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _balances[sender] = _balances[sender].sub(amount);
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a `Transfer` event with `from` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _totalSupply = _totalSupply.add(amount);
364         _balances[account] = _balances[account].add(amount);
365         emit Transfer(address(0), account, amount);
366     }
367 
368      /**
369      * @dev Destoys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a `Transfer` event with `to` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
389      *
390      * This is internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an `Approval` event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
410      * from the caller's allowance.
411      *
412      * See `_burn` and `_approve`.
413      */
414     function _burnFrom(address account, uint256 amount) internal {
415         _burn(account, amount);
416         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
417     }
418 }
419 
420 // File: contracts/Festaking.sol
421 
422 pragma solidity ^0.5.8;
423 
424 
425 
426 contract Festaking {
427     using SafeMath for uint256;
428 
429     mapping (address => uint256) private _stakes;
430 
431     string public name;
432     address  public tokenAddress;
433     uint public stakingStarts;
434     uint public stakingEnds;
435     uint public withdrawStarts;
436     uint public withdrawEnds;
437     uint256 public stakedTotal;
438     uint256 public stakingCap;
439     uint256 public totalReward;
440     uint256 public earlyWithdrawReward;
441     uint256 public rewardBalance;
442     uint256 public stakedBalance;
443 
444     ERC20 public ERC20Interface;
445     event Staked(address indexed token, address indexed staker_, uint256 requestedAmount_, uint256 stakedAmount_);
446     event PaidOut(address indexed token, address indexed staker_, uint256 amount_, uint256 reward_);
447     event Refunded(address indexed token, address indexed staker_, uint256 amount_);
448 
449     /**
450      */
451     constructor (string memory name_,
452         address tokenAddress_,
453         uint stakingStarts_,
454         uint stakingEnds_,
455         uint withdrawStarts_,
456         uint withdrawEnds_,
457         uint256 stakingCap_) public {
458         name = name_;
459         require(tokenAddress_ != address(0), "Festaking: 0 address");
460         tokenAddress = tokenAddress_;
461 
462         require(stakingStarts_ > 0, "Festaking: zero staking start time");
463         if (stakingStarts_ < now) {
464             stakingStarts = now;
465         } else {
466             stakingStarts = stakingStarts_;
467         }
468 
469         require(stakingEnds_ > stakingStarts, "Festaking: staking end must be after staking starts");
470         stakingEnds = stakingEnds_;
471 
472         require(withdrawStarts_ >= stakingEnds, "Festaking: withdrawStarts must be after staking ends");
473         withdrawStarts = withdrawStarts_;
474 
475         require(withdrawEnds_ > withdrawStarts, "Festaking: withdrawEnds must be after withdraw starts");
476         withdrawEnds = withdrawEnds_;
477 
478         require(stakingCap_ > 0, "Festaking: stakingCap must be positive");
479         stakingCap = stakingCap_;
480     }
481 
482     function addReward(uint256 rewardAmount, uint256 withdrawableAmount)
483     public
484     _before(withdrawStarts)
485     _hasAllowance(msg.sender, rewardAmount)
486     returns (bool) {
487         require(rewardAmount > 0, "Festaking: reward must be positive");
488         require(withdrawableAmount >= 0, "Festaking: withdrawable amount cannot be negative");
489         require(withdrawableAmount <= rewardAmount, "Festaking: withdrawable amount must be less than or equal to the reward amount");
490         address from = msg.sender;
491         if (!_payMe(from, rewardAmount)) {
492             return false;
493         }
494 
495         totalReward = totalReward.add(rewardAmount);
496         rewardBalance = totalReward;
497         earlyWithdrawReward = earlyWithdrawReward.add(withdrawableAmount);
498         return true;
499     }
500 
501     function stakeOf(address account) public view returns (uint256) {
502         return _stakes[account];
503     }
504 
505     /**
506     * Requirements:
507     * - `amount` Amount to be staked
508     */
509     function stake(uint256 amount)
510     public
511     _positive(amount)
512     _realAddress(msg.sender)
513     returns (bool) {
514         address from = msg.sender;
515         return _stake(from, amount);
516     }
517 
518     function withdraw(uint256 amount)
519     public
520     _after(withdrawStarts)
521     _positive(amount)
522     _realAddress(msg.sender)
523     returns (bool) {
524         address from = msg.sender;
525         require(amount <= _stakes[from], "Festaking: not enough balance");
526         if (now < withdrawEnds) {
527             return _withdrawEarly(from, amount);
528         } else {
529             return _withdrawAfterClose(from, amount);
530         }
531     }
532 
533     function _withdrawEarly(address from, uint256 amount)
534     private
535     _realAddress(from)
536     returns (bool) {
537         // This is the formula to calculate reward:
538         // r = (earlyWithdrawReward / stakedTotal) * (now - stakingEnds) / (withdrawEnds - stakingEnds)
539         // w = (1+r) * a
540         uint256 denom = (withdrawEnds.sub(stakingEnds)).mul(stakedTotal);
541         uint256 reward = (
542         ( (now.sub(stakingEnds)).mul(earlyWithdrawReward) ).mul(amount)
543         ).div(denom);
544         uint256 payOut = amount.add(reward);
545         rewardBalance = rewardBalance.sub(reward);
546         stakedBalance = stakedBalance.sub(amount);
547         _stakes[from] = _stakes[from].sub(amount);
548         if (_payDirect(from, payOut)) {
549             emit PaidOut(tokenAddress, from, amount, reward);
550             return true;
551         }
552         return false;
553     }
554 
555     function _withdrawAfterClose(address from, uint256 amount)
556     private
557     _realAddress(from)
558     returns (bool) {
559         uint256 reward = (rewardBalance.mul(amount)).div(stakedBalance);
560         uint256 payOut = amount.add(reward);
561         _stakes[from] = _stakes[from].sub(amount);
562         if (_payDirect(from, payOut)) {
563             emit PaidOut(tokenAddress, from, amount, reward);
564             return true;
565         }
566         return false;
567     }
568 
569     function _stake(address staker, uint256 amount)
570     private
571     _after(stakingStarts)
572     _before(stakingEnds)
573     _positive(amount)
574     _hasAllowance(staker, amount)
575     returns (bool) {
576         // check the remaining amount to be staked
577         uint256 remaining = amount;
578         if (remaining > (stakingCap.sub(stakedBalance))) {
579             remaining = stakingCap.sub(stakedBalance);
580         }
581         // These requires are not necessary, because it will never happen, but won't hurt to double check
582         // this is because stakedTotal and stakedBalance are only modified in this method during the staking period
583         require(remaining > 0, "Festaking: Staking cap is filled");
584         require((remaining + stakedTotal) <= stakingCap, "Festaking: this will increase staking amount pass the cap");
585         if (!_payMe(staker, remaining)) {
586             return false;
587         }
588         emit Staked(tokenAddress, staker, amount, remaining);
589 
590         if (remaining < amount) {
591             // Return the unstaked amount to sender (from allowance)
592             uint256 refund = amount.sub(remaining);
593             if (_payTo(staker, staker, refund)) {
594                 emit Refunded(tokenAddress, staker, refund);
595             }
596         }
597 
598         // Transfer is completed
599         stakedBalance = stakedBalance.add(remaining);
600         stakedTotal = stakedTotal.add(remaining);
601         _stakes[staker] = _stakes[staker].add(remaining);
602         return true;
603     }
604 
605     function _payMe(address payer, uint256 amount)
606     private
607     returns (bool) {
608         return _payTo(payer, address(this), amount);
609     }
610 
611     function _payTo(address allower, address receiver, uint256 amount)
612     _hasAllowance(allower, amount)
613     private
614     returns (bool) {
615         // Request to transfer amount from the contract to receiver.
616         // contract does not own the funds, so the allower must have added allowance to the contract
617         // Allower is the original owner.
618         ERC20Interface = ERC20(tokenAddress);
619         return ERC20Interface.transferFrom(allower, receiver, amount);
620     }
621 
622     function _payDirect(address to, uint256 amount)
623     private
624     _positive(amount)
625     returns (bool) {
626         ERC20Interface = ERC20(tokenAddress);
627         return ERC20Interface.transfer(to, amount);
628     }
629 
630     modifier _realAddress(address addr) {
631         require(addr != address(0), "Festaking: zero address");
632         _;
633     }
634 
635     modifier _positive(uint256 amount) {
636         require(amount >= 0, "Festaking: negative amount");
637         _;
638     }
639 
640     modifier _after(uint eventTime) {
641         require(now >= eventTime, "Festaking: bad timing for the request");
642         _;
643     }
644 
645     modifier _before(uint eventTime) {
646         require(now < eventTime, "Festaking: bad timing for the request");
647         _;
648     }
649 
650     modifier _hasAllowance(address allower, uint256 amount) {
651         // Make sure the allower has provided the right allowance.
652         ERC20Interface = ERC20(tokenAddress);
653         uint256 ourAllowance = ERC20Interface.allowance(allower, address(this));
654         require(amount <= ourAllowance, "Festaking: Make sure to add enough allowance");
655         _;
656     }
657 }