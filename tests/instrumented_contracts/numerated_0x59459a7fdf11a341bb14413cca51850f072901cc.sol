1 // File: @openzeppelin/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
88 
89 pragma solidity ^0.5.0;
90 
91 /**
92  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
93  * the optional functions; to access them see `ERC20Detailed`.
94  */
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a `Transfer` event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through `transferFrom`. This is
118      * zero by default.
119      *
120      * This value changes when `approve` or `transferFrom` are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * > Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an `Approval` event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a `Transfer` event.
148      */
149     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to `approve`. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 
167 
168 
169 
170 
171 
172 
173 
174 
175 
176 
177 
178 
179 
180 
181 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
182 
183 pragma solidity ^0.5.0;
184 
185 
186 
187 /**
188  * @dev Implementation of the `IERC20` interface.
189  *
190  * This implementation is agnostic to the way tokens are created. This means
191  * that a supply mechanism has to be added in a derived contract using `_mint`.
192  * For a generic mechanism see `ERC20Mintable`.
193  *
194  * *For a detailed writeup see our guide [How to implement supply
195  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
196  *
197  * We have followed general OpenZeppelin guidelines: functions revert instead
198  * of returning `false` on failure. This behavior is nonetheless conventional
199  * and does not conflict with the expectations of ERC20 applications.
200  *
201  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
202  * This allows applications to reconstruct the allowance for all accounts just
203  * by listening to said events. Other implementations of the EIP may not emit
204  * these events, as it isn't required by the specification.
205  *
206  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
207  * functions have been added to mitigate the well-known issues around setting
208  * allowances. See `IERC20.approve`.
209  */
210 contract ERC20 is IERC20 {
211     using SafeMath for uint256;
212 
213     mapping (address => uint256) private _balances;
214 
215     mapping (address => mapping (address => uint256)) private _allowances;
216 
217     uint256 private _totalSupply;
218 
219     /**
220      * @dev See `IERC20.totalSupply`.
221      */
222     function totalSupply() public view returns (uint256) {
223         return _totalSupply;
224     }
225 
226     /**
227      * @dev See `IERC20.balanceOf`.
228      */
229     function balanceOf(address account) public view returns (uint256) {
230         return _balances[account];
231     }
232 
233     /**
234      * @dev See `IERC20.transfer`.
235      *
236      * Requirements:
237      *
238      * - `recipient` cannot be the zero address.
239      * - the caller must have a balance of at least `amount`.
240      */
241     function transfer(address recipient, uint256 amount) public returns (bool) {
242         _transfer(msg.sender, recipient, amount);
243         return true;
244     }
245 
246     /**
247      * @dev See `IERC20.allowance`.
248      */
249     function allowance(address owner, address spender) public view returns (uint256) {
250         return _allowances[owner][spender];
251     }
252 
253     /**
254      * @dev See `IERC20.approve`.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      */
260     function approve(address spender, uint256 value) public returns (bool) {
261         _approve(msg.sender, spender, value);
262         return true;
263     }
264 
265     /**
266      * @dev See `IERC20.transferFrom`.
267      *
268      * Emits an `Approval` event indicating the updated allowance. This is not
269      * required by the EIP. See the note at the beginning of `ERC20`;
270      *
271      * Requirements:
272      * - `sender` and `recipient` cannot be the zero address.
273      * - `sender` must have a balance of at least `value`.
274      * - the caller must have allowance for `sender`'s tokens of at least
275      * `amount`.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
278         _transfer(sender, recipient, amount);
279         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
280         return true;
281     }
282 
283     /**
284      * @dev Atomically increases the allowance granted to `spender` by the caller.
285      *
286      * This is an alternative to `approve` that can be used as a mitigation for
287      * problems described in `IERC20.approve`.
288      *
289      * Emits an `Approval` event indicating the updated allowance.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      */
295     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
296         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
297         return true;
298     }
299 
300     /**
301      * @dev Atomically decreases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to `approve` that can be used as a mitigation for
304      * problems described in `IERC20.approve`.
305      *
306      * Emits an `Approval` event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      * - `spender` must have allowance for the caller of at least
312      * `subtractedValue`.
313      */
314     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
315         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
316         return true;
317     }
318 
319     /**
320      * @dev Moves tokens `amount` from `sender` to `recipient`.
321      *
322      * This is internal function is equivalent to `transfer`, and can be used to
323      * e.g. implement automatic token fees, slashing mechanisms, etc.
324      *
325      * Emits a `Transfer` event.
326      *
327      * Requirements:
328      *
329      * - `sender` cannot be the zero address.
330      * - `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      */
333     function _transfer(address sender, address recipient, uint256 amount) internal {
334         require(sender != address(0), "ERC20: transfer from the zero address");
335         require(recipient != address(0), "ERC20: transfer to the zero address");
336 
337         _balances[sender] = _balances[sender].sub(amount);
338         _balances[recipient] = _balances[recipient].add(amount);
339         emit Transfer(sender, recipient, amount);
340     }
341 
342     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
343      * the total supply.
344      *
345      * Emits a `Transfer` event with `from` set to the zero address.
346      *
347      * Requirements
348      *
349      * - `to` cannot be the zero address.
350      */
351     function _mint(address account, uint256 amount) internal {
352         require(account != address(0), "ERC20: mint to the zero address");
353 
354         _totalSupply = _totalSupply.add(amount);
355         _balances[account] = _balances[account].add(amount);
356         emit Transfer(address(0), account, amount);
357     }
358 
359      /**
360      * @dev Destoys `amount` tokens from `account`, reducing the
361      * total supply.
362      *
363      * Emits a `Transfer` event with `to` set to the zero address.
364      *
365      * Requirements
366      *
367      * - `account` cannot be the zero address.
368      * - `account` must have at least `amount` tokens.
369      */
370     function _burn(address account, uint256 value) internal {
371         require(account != address(0), "ERC20: burn from the zero address");
372 
373         _totalSupply = _totalSupply.sub(value);
374         _balances[account] = _balances[account].sub(value);
375         emit Transfer(account, address(0), value);
376     }
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
380      *
381      * This is internal function is equivalent to `approve`, and can be used to
382      * e.g. set automatic allowances for certain subsystems, etc.
383      *
384      * Emits an `Approval` event.
385      *
386      * Requirements:
387      *
388      * - `owner` cannot be the zero address.
389      * - `spender` cannot be the zero address.
390      */
391     function _approve(address owner, address spender, uint256 value) internal {
392         require(owner != address(0), "ERC20: approve from the zero address");
393         require(spender != address(0), "ERC20: approve to the zero address");
394 
395         _allowances[owner][spender] = value;
396         emit Approval(owner, spender, value);
397     }
398 
399     /**
400      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
401      * from the caller's allowance.
402      *
403      * See `_burn` and `_approve`.
404      */
405     function _burnFrom(address account, uint256 amount) internal {
406         _burn(account, amount);
407         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
408     }
409 }
410 
411 
412 
413 
414 
415 
416 
417 
418 
419 
420 
421 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
422 
423 pragma solidity ^0.5.0;
424 
425 
426 /**
427  * @dev Extension of `ERC20` that allows token holders to destroy both their own
428  * tokens and those that they have an allowance for, in a way that can be
429  * recognized off-chain (via event analysis).
430  */
431 contract ERC20Burnable is ERC20 {
432     /**
433      * @dev Destoys `amount` tokens from the caller.
434      *
435      * See `ERC20._burn`.
436      */
437     function burn(uint256 amount) public {
438         _burn(msg.sender, amount);
439     }
440 
441     /**
442      * @dev See `ERC20._burnFrom`.
443      */
444     function burnFrom(address account, uint256 amount) public {
445         _burnFrom(account, amount);
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
450 
451 pragma solidity ^0.5.0;
452 
453 
454 /**
455  * @dev Optional functions from the ERC20 standard.
456  */
457 contract ERC20Detailed is IERC20 {
458     string private _name;
459     string private _symbol;
460     uint8 private _decimals;
461 
462     /**
463      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
464      * these values are immutable: they can only be set once during
465      * construction.
466      */
467     constructor (string memory name, string memory symbol, uint8 decimals) public {
468         _name = name;
469         _symbol = symbol;
470         _decimals = decimals;
471     }
472 
473     /**
474      * @dev Returns the name of the token.
475      */
476     function name() public view returns (string memory) {
477         return _name;
478     }
479 
480     /**
481      * @dev Returns the symbol of the token, usually a shorter version of the
482      * name.
483      */
484     function symbol() public view returns (string memory) {
485         return _symbol;
486     }
487 
488     /**
489      * @dev Returns the number of decimals used to get its user representation.
490      * For example, if `decimals` equals `2`, a balance of `505` tokens should
491      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
492      *
493      * Tokens usually opt for a value of 18, imitating the relationship between
494      * Ether and Wei.
495      *
496      * > Note that this information is only used for _display_ purposes: it in
497      * no way affects any of the arithmetic of the contract, including
498      * `IERC20.balanceOf` and `IERC20.transfer`.
499      */
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/math/SafeMath.sol
506 
507 pragma solidity ^0.5.0;
508 
509 /**
510  * @dev Wrappers over Solidity's arithmetic operations with added overflow
511  * checks.
512  *
513  * Arithmetic operations in Solidity wrap on overflow. This can easily result
514  * in bugs, because programmers usually assume that an overflow raises an
515  * error, which is the standard behavior in high level programming languages.
516  * `SafeMath` restores this intuition by reverting the transaction when an
517  * operation overflows.
518  *
519  * Using this library instead of the unchecked operations eliminates an entire
520  * class of bugs, so it's recommended to use it always.
521  */
522 library SafeMath {
523     /**
524      * @dev Returns the addition of two unsigned integers, reverting on
525      * overflow.
526      *
527      * Counterpart to Solidity's `+` operator.
528      *
529      * Requirements:
530      * - Addition cannot overflow.
531      */
532     function add(uint256 a, uint256 b) internal pure returns (uint256) {
533         uint256 c = a + b;
534         require(c >= a, "SafeMath: addition overflow");
535 
536         return c;
537     }
538 
539     /**
540      * @dev Returns the subtraction of two unsigned integers, reverting on
541      * overflow (when the result is negative).
542      *
543      * Counterpart to Solidity's `-` operator.
544      *
545      * Requirements:
546      * - Subtraction cannot overflow.
547      */
548     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
549         require(b <= a, "SafeMath: subtraction overflow");
550         uint256 c = a - b;
551 
552         return c;
553     }
554 
555     /**
556      * @dev Returns the multiplication of two unsigned integers, reverting on
557      * overflow.
558      *
559      * Counterpart to Solidity's `*` operator.
560      *
561      * Requirements:
562      * - Multiplication cannot overflow.
563      */
564     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
565         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
566         // benefit is lost if 'b' is also tested.
567         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
568         if (a == 0) {
569             return 0;
570         }
571 
572         uint256 c = a * b;
573         require(c / a == b, "SafeMath: multiplication overflow");
574 
575         return c;
576     }
577 
578     /**
579      * @dev Returns the integer division of two unsigned integers. Reverts on
580      * division by zero. The result is rounded towards zero.
581      *
582      * Counterpart to Solidity's `/` operator. Note: this function uses a
583      * `revert` opcode (which leaves remaining gas untouched) while Solidity
584      * uses an invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      * - The divisor cannot be zero.
588      */
589     function div(uint256 a, uint256 b) internal pure returns (uint256) {
590         // Solidity only automatically asserts when dividing by 0
591         require(b > 0, "SafeMath: division by zero");
592         uint256 c = a / b;
593         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
594 
595         return c;
596     }
597 
598     /**
599      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
600      * Reverts when dividing by zero.
601      *
602      * Counterpart to Solidity's `%` operator. This function uses a `revert`
603      * opcode (which leaves remaining gas untouched) while Solidity uses an
604      * invalid opcode to revert (consuming all remaining gas).
605      *
606      * Requirements:
607      * - The divisor cannot be zero.
608      */
609     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
610         require(b != 0, "SafeMath: modulo by zero");
611         return a % b;
612     }
613 }
614 
615 
616 // File: localhost/contracts/EtheousToken.sol
617 
618 pragma solidity ^0.5.12;
619 
620 
621 contract EtheousToken is Ownable, ERC20, ERC20Detailed("Etheous, Inc.", "EHS", 18) {
622   uint256 public maxUnlockIterationCount = 100;    //  cycle limit for unlockExpired()
623     
624 
625   mapping (address => uint256) public lockedBalances;   //  (address => amount).
626   mapping (address => uint256[]) public releaseTimestamps; //  release timestamps for locked transfers, (address => timestamp[]).
627   mapping (address => mapping(uint256 => uint256)) public lockedTokensForReleaseTime; //  address => (releaseTimestamp => releaseAmount)
628 
629 
630   constructor() public {
631     uint256 tokensAmount = 630720000 * 10 ** 18;
632     _mint(msg.sender, tokensAmount);
633   }
634   
635   /**
636     @dev Gets release timestamp amount.
637     @param _address Address to get release timestamp amount.
638     @return Release timestamp amount.
639    */
640   function getReleaseTimestamps(address _address) public view returns(uint256[] memory) {
641     return releaseTimestamps[_address];
642   }
643   
644   /**
645     @dev Gets release timestamp amount for sender.
646     @return Release timestamp amount.
647    */
648   function getMyReleaseTimestamps() public view returns(uint256[] memory) {
649     return releaseTimestamps[msg.sender];
650   }
651   
652   /**
653     @dev Updates maximum cycle iterations.
654     @param _amount  Amountof iterations.
655    */
656   function updateMaxUnlockIterationCount(uint256 _amount) public onlyOwner {
657     require(_amount > 0, "Wrong amount");
658     maxUnlockIterationCount = _amount;
659   }
660   
661   /**
662     @dev Returns amount of locked transaction.
663     @param _address Address to return amount of locked transaction.
664     @return Amount of locked transaction.
665    */
666   function lockedTransferAmount(address _address) public view returns(uint256) {
667     return releaseTimestamps[_address].length;
668   }
669   
670   /**
671     @dev Returns amount of locked transaction for sender.
672     @return Amount of locked transaction.
673    */
674   function myLockedTransferAmount() public view returns(uint256) {
675     return releaseTimestamps[msg.sender].length;
676   }
677 
678   /**
679     @dev Unlocks tokens for sender with expired lock period.
680     @param _amount Amount of maximum loop iteractions.
681     @notice Amount of maximum loop iteractions is required in case there will be too many transactions for loop cycle to handle.
682    */
683   function unlockExpired(uint256 _amount) public {
684     require(_amount <= maxUnlockIterationCount, "Wrong amount");
685     
686     uint256 length = releaseTimestamps[msg.sender].length;
687     for(uint256 i = 0; i < length; i ++) {
688       if(i > maxUnlockIterationCount) {
689           return;
690       }
691       if(releaseTimestamps[msg.sender][i] <= now) {
692         uint256 tokens = lockedTokensForReleaseTime[msg.sender][releaseTimestamps[msg.sender][i]];
693         lockedBalances[msg.sender] = lockedBalances[msg.sender].sub(tokens);
694         delete lockedTokensForReleaseTime[msg.sender][releaseTimestamps[msg.sender][i]];
695 
696         length = length.sub(1);
697         if(length > 0) {
698           releaseTimestamps[msg.sender][i] = releaseTimestamps[msg.sender][length];
699           delete releaseTimestamps[msg.sender][length];
700           releaseTimestamps[msg.sender].length = releaseTimestamps[msg.sender].length.sub(1);
701           i --;
702         } else {
703           releaseTimestamps[msg.sender].length = 0;
704         }
705       }
706     }
707   }
708 
709   /**
710     @dev Transfers tokens to recipient address.
711     @param recipient Recipient address.
712     @param amount Token amount.
713     @param lockDuration Token lock duration.
714     @notice unlockExpired() function gets called automatically to release locked tokens.
715    */
716   function transferLocked(address recipient, uint256 amount, uint256 lockDuration) public returns (bool) {
717     unlockExpired(100);
718     lockDuration = lockDuration * 86400;
719     require(balanceOf(msg.sender).sub(lockedBalances[msg.sender]) >= amount, "Not enough tokens.");
720 
721     if(lockDuration > 0) {
722         lockedBalances[recipient] = lockedBalances[recipient].add(amount);
723         releaseTimestamps[recipient].push(now.add(lockDuration));
724         lockedTokensForReleaseTime[recipient][now.add(lockDuration)] = amount;
725     }
726     
727     super.transfer(recipient, amount);    
728   }
729   
730   /**
731     @dev Transfers tokens from sender to recipient address. IMPORTANT: will not unlockExpiredTokens.
732     @param sender Sender address.
733     @param recipient Recipient address.
734     @param amount Token amount.
735     @param lockDuration Token lock duration.
736    */
737   function transferLockedFrom(address sender, address recipient, uint256 amount, uint256 lockDuration) public returns (bool) {
738     unlockExpired(100);
739     lockDuration = lockDuration * 86400;
740     require(balanceOf(sender).sub(lockedBalances[sender]) >= amount, "Not enough tokens.");
741     
742     if(lockDuration > 0) {
743         lockedBalances[recipient] = lockedBalances[recipient].add(amount);
744         releaseTimestamps[recipient].push(now.add(lockDuration));
745         lockedTokensForReleaseTime[recipient][now.add(lockDuration)] = amount;
746     }
747     super.transferFrom(sender, recipient, amount);
748   }
749 
750 
751   /**
752     @dev Disable transfer functional.
753    */
754     function transfer(address recipient, uint256 amount) public returns (bool) {
755     unlockExpired(100);
756     require(balanceOf(msg.sender).sub(lockedBalances[msg.sender]) >= amount, "Not enough tokens.");
757     
758     super.transfer(recipient, amount);
759   }
760 
761   /**
762     @dev Disable transferFrom functional.
763    */
764     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
765     unlockExpired(100);
766     require(balanceOf(sender).sub(lockedBalances[sender]) >= amount, "Not enough tokens.");
767     super.transferFrom(sender, recipient, amount);
768   }
769 }