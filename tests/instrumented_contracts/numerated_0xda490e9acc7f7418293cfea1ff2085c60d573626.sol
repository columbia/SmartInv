1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
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
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/math/Math.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Standard math utilities missing in the Solidity language.
117  */
118 library Math {
119     /**
120      * @dev Returns the largest of two numbers.
121      */
122     function max(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a >= b ? a : b;
124     }
125 
126     /**
127      * @dev Returns the smallest of two numbers.
128      */
129     function min(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a < b ? a : b;
131     }
132 
133     /**
134      * @dev Returns the average of two numbers. The result is rounded towards
135      * zero.
136      */
137     function average(uint256 a, uint256 b) internal pure returns (uint256) {
138         // (a + b) / 2 can overflow, so we distribute
139         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
140     }
141 }
142 
143 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
144 
145 pragma solidity ^0.5.0;
146 
147 /**
148  * @dev Contract module which provides a basic access control mechanism, where
149  * there is an account (an owner) that can be granted exclusive access to
150  * specific functions.
151  *
152  * This module is used through inheritance. It will make available the modifier
153  * `onlyOwner`, which can be aplied to your functions to restrict their use to
154  * the owner.
155  */
156 contract Ownable {
157     address private _owner;
158 
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     /**
162      * @dev Initializes the contract setting the deployer as the initial owner.
163      */
164     constructor () internal {
165         _owner = msg.sender;
166         emit OwnershipTransferred(address(0), _owner);
167     }
168 
169     /**
170      * @dev Returns the address of the current owner.
171      */
172     function owner() public view returns (address) {
173         return _owner;
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         require(isOwner(), "Ownable: caller is not the owner");
181         _;
182     }
183 
184     /**
185      * @dev Returns true if the caller is the current owner.
186      */
187     function isOwner() public view returns (bool) {
188         return msg.sender == _owner;
189     }
190 
191     /**
192      * @dev Leaves the contract without owner. It will not be possible to call
193      * `onlyOwner` functions anymore. Can only be called by the current owner.
194      *
195      * > Note: Renouncing ownership will leave the contract without an owner,
196      * thereby removing any functionality that is only available to the owner.
197      */
198     function renounceOwnership() public onlyOwner {
199         emit OwnershipTransferred(_owner, address(0));
200         _owner = address(0);
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public onlyOwner {
208         _transferOwnership(newOwner);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      */
214     function _transferOwnership(address newOwner) internal {
215         require(newOwner != address(0), "Ownable: new owner is the zero address");
216         emit OwnershipTransferred(_owner, newOwner);
217         _owner = newOwner;
218     }
219 }
220 
221 // File: @daostack/infra/contracts/Reputation.sol
222 
223 pragma solidity ^0.5.11;
224 
225 
226 
227 /**
228  * @title Reputation system
229  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
230  * A reputation is use to assign influence measure to a DAO'S peers.
231  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
232  * The Reputation contract maintain a map of address to reputation value.
233  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
234  */
235 
236 contract Reputation is Ownable {
237 
238     uint8 public decimals = 18;             //Number of decimals of the smallest unit
239     // Event indicating minting of reputation to an address.
240     event Mint(address indexed _to, uint256 _amount);
241     // Event indicating burning of reputation for an address.
242     event Burn(address indexed _from, uint256 _amount);
243 
244       /// @dev `Checkpoint` is the structure that attaches a block number to a
245       ///  given value, the block number attached is the one that last changed the
246       ///  value
247     struct Checkpoint {
248 
249     // `fromBlock` is the block number that the value was generated from
250         uint128 fromBlock;
251 
252           // `value` is the amount of reputation at a specific block number
253         uint128 value;
254     }
255 
256       // `balances` is the map that tracks the balance of each address, in this
257       //  contract when the balance changes the block number that the change
258       //  occurred is also included in the map
259     mapping (address => Checkpoint[]) balances;
260 
261       // Tracks the history of the `totalSupply` of the reputation
262     Checkpoint[] totalSupplyHistory;
263 
264     /// @notice Constructor to create a Reputation
265     constructor(
266     ) public
267     {
268     }
269 
270     /// @dev This function makes it easy to get the total number of reputation
271     /// @return The total number of reputation
272     function totalSupply() public view returns (uint256) {
273         return totalSupplyAt(block.number);
274     }
275 
276   ////////////////
277   // Query balance and totalSupply in History
278   ////////////////
279     /**
280     * @dev return the reputation amount of a given owner
281     * @param _owner an address of the owner which we want to get his reputation
282     */
283     function balanceOf(address _owner) public view returns (uint256 balance) {
284         return balanceOfAt(_owner, block.number);
285     }
286 
287       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
288       /// @param _owner The address from which the balance will be retrieved
289       /// @param _blockNumber The block number when the balance is queried
290       /// @return The balance at `_blockNumber`
291     function balanceOfAt(address _owner, uint256 _blockNumber)
292     public view returns (uint256)
293     {
294         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
295             return 0;
296           // This will return the expected balance during normal situations
297         } else {
298             return getValueAt(balances[_owner], _blockNumber);
299         }
300     }
301 
302       /// @notice Total amount of reputation at a specific `_blockNumber`.
303       /// @param _blockNumber The block number when the totalSupply is queried
304       /// @return The total amount of reputation at `_blockNumber`
305     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
306         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
307             return 0;
308           // This will return the expected totalSupply during normal situations
309         } else {
310             return getValueAt(totalSupplyHistory, _blockNumber);
311         }
312     }
313 
314       /// @notice Generates `_amount` reputation that are assigned to `_owner`
315       /// @param _user The address that will be assigned the new reputation
316       /// @param _amount The quantity of reputation generated
317       /// @return True if the reputation are generated correctly
318     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
319         uint256 curTotalSupply = totalSupply();
320         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
321         uint256 previousBalanceTo = balanceOf(_user);
322         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
323         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
324         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
325         emit Mint(_user, _amount);
326         return true;
327     }
328 
329       /// @notice Burns `_amount` reputation from `_owner`
330       /// @param _user The address that will lose the reputation
331       /// @param _amount The quantity of reputation to burn
332       /// @return True if the reputation are burned correctly
333     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
334         uint256 curTotalSupply = totalSupply();
335         uint256 amountBurned = _amount;
336         uint256 previousBalanceFrom = balanceOf(_user);
337         if (previousBalanceFrom < amountBurned) {
338             amountBurned = previousBalanceFrom;
339         }
340         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
341         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
342         emit Burn(_user, amountBurned);
343         return true;
344     }
345 
346   ////////////////
347   // Internal helper functions to query and set a value in a snapshot array
348   ////////////////
349 
350       /// @dev `getValueAt` retrieves the number of reputation at a given block number
351       /// @param checkpoints The history of values being queried
352       /// @param _block The block number to retrieve the value at
353       /// @return The number of reputation being queried
354     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
355         if (checkpoints.length == 0) {
356             return 0;
357         }
358 
359           // Shortcut for the actual value
360         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
361             return checkpoints[checkpoints.length-1].value;
362         }
363         if (_block < checkpoints[0].fromBlock) {
364             return 0;
365         }
366 
367           // Binary search of the value in the array
368         uint256 min = 0;
369         uint256 max = checkpoints.length-1;
370         while (max > min) {
371             uint256 mid = (max + min + 1) / 2;
372             if (checkpoints[mid].fromBlock<=_block) {
373                 min = mid;
374             } else {
375                 max = mid-1;
376             }
377         }
378         return checkpoints[min].value;
379     }
380 
381       /// @dev `updateValueAtNow` used to update the `balances` map and the
382       ///  `totalSupplyHistory`
383       /// @param checkpoints The history of data being updated
384       /// @param _value The new number of reputation
385     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
386         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
387         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
388             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
389             newCheckPoint.fromBlock = uint128(block.number);
390             newCheckPoint.value = uint128(_value);
391         } else {
392             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
393             oldCheckPoint.value = uint128(_value);
394         }
395     }
396 }
397 
398 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
399 
400 pragma solidity ^0.5.0;
401 
402 /**
403  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
404  * the optional functions; to access them see `ERC20Detailed`.
405  */
406 interface IERC20 {
407     /**
408      * @dev Returns the amount of tokens in existence.
409      */
410     function totalSupply() external view returns (uint256);
411 
412     /**
413      * @dev Returns the amount of tokens owned by `account`.
414      */
415     function balanceOf(address account) external view returns (uint256);
416 
417     /**
418      * @dev Moves `amount` tokens from the caller's account to `recipient`.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * Emits a `Transfer` event.
423      */
424     function transfer(address recipient, uint256 amount) external returns (bool);
425 
426     /**
427      * @dev Returns the remaining number of tokens that `spender` will be
428      * allowed to spend on behalf of `owner` through `transferFrom`. This is
429      * zero by default.
430      *
431      * This value changes when `approve` or `transferFrom` are called.
432      */
433     function allowance(address owner, address spender) external view returns (uint256);
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * > Beware that changing an allowance with this method brings the risk
441      * that someone may use both the old and the new allowance by unfortunate
442      * transaction ordering. One possible solution to mitigate this race
443      * condition is to first reduce the spender's allowance to 0 and set the
444      * desired value afterwards:
445      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
446      *
447      * Emits an `Approval` event.
448      */
449     function approve(address spender, uint256 amount) external returns (bool);
450 
451     /**
452      * @dev Moves `amount` tokens from `sender` to `recipient` using the
453      * allowance mechanism. `amount` is then deducted from the caller's
454      * allowance.
455      *
456      * Returns a boolean value indicating whether the operation succeeded.
457      *
458      * Emits a `Transfer` event.
459      */
460     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
461 
462     /**
463      * @dev Emitted when `value` tokens are moved from one account (`from`) to
464      * another (`to`).
465      *
466      * Note that `value` may be zero.
467      */
468     event Transfer(address indexed from, address indexed to, uint256 value);
469 
470     /**
471      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
472      * a call to `approve`. `value` is the new allowance.
473      */
474     event Approval(address indexed owner, address indexed spender, uint256 value);
475 }
476 
477 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
478 
479 pragma solidity ^0.5.0;
480 
481 
482 
483 /**
484  * @dev Implementation of the `IERC20` interface.
485  *
486  * This implementation is agnostic to the way tokens are created. This means
487  * that a supply mechanism has to be added in a derived contract using `_mint`.
488  * For a generic mechanism see `ERC20Mintable`.
489  *
490  * *For a detailed writeup see our guide [How to implement supply
491  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
492  *
493  * We have followed general OpenZeppelin guidelines: functions revert instead
494  * of returning `false` on failure. This behavior is nonetheless conventional
495  * and does not conflict with the expectations of ERC20 applications.
496  *
497  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
498  * This allows applications to reconstruct the allowance for all accounts just
499  * by listening to said events. Other implementations of the EIP may not emit
500  * these events, as it isn't required by the specification.
501  *
502  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
503  * functions have been added to mitigate the well-known issues around setting
504  * allowances. See `IERC20.approve`.
505  */
506 contract ERC20 is IERC20 {
507     using SafeMath for uint256;
508 
509     mapping (address => uint256) private _balances;
510 
511     mapping (address => mapping (address => uint256)) private _allowances;
512 
513     uint256 private _totalSupply;
514 
515     /**
516      * @dev See `IERC20.totalSupply`.
517      */
518     function totalSupply() public view returns (uint256) {
519         return _totalSupply;
520     }
521 
522     /**
523      * @dev See `IERC20.balanceOf`.
524      */
525     function balanceOf(address account) public view returns (uint256) {
526         return _balances[account];
527     }
528 
529     /**
530      * @dev See `IERC20.transfer`.
531      *
532      * Requirements:
533      *
534      * - `recipient` cannot be the zero address.
535      * - the caller must have a balance of at least `amount`.
536      */
537     function transfer(address recipient, uint256 amount) public returns (bool) {
538         _transfer(msg.sender, recipient, amount);
539         return true;
540     }
541 
542     /**
543      * @dev See `IERC20.allowance`.
544      */
545     function allowance(address owner, address spender) public view returns (uint256) {
546         return _allowances[owner][spender];
547     }
548 
549     /**
550      * @dev See `IERC20.approve`.
551      *
552      * Requirements:
553      *
554      * - `spender` cannot be the zero address.
555      */
556     function approve(address spender, uint256 value) public returns (bool) {
557         _approve(msg.sender, spender, value);
558         return true;
559     }
560 
561     /**
562      * @dev See `IERC20.transferFrom`.
563      *
564      * Emits an `Approval` event indicating the updated allowance. This is not
565      * required by the EIP. See the note at the beginning of `ERC20`;
566      *
567      * Requirements:
568      * - `sender` and `recipient` cannot be the zero address.
569      * - `sender` must have a balance of at least `value`.
570      * - the caller must have allowance for `sender`'s tokens of at least
571      * `amount`.
572      */
573     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
574         _transfer(sender, recipient, amount);
575         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
576         return true;
577     }
578 
579     /**
580      * @dev Atomically increases the allowance granted to `spender` by the caller.
581      *
582      * This is an alternative to `approve` that can be used as a mitigation for
583      * problems described in `IERC20.approve`.
584      *
585      * Emits an `Approval` event indicating the updated allowance.
586      *
587      * Requirements:
588      *
589      * - `spender` cannot be the zero address.
590      */
591     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
592         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
593         return true;
594     }
595 
596     /**
597      * @dev Atomically decreases the allowance granted to `spender` by the caller.
598      *
599      * This is an alternative to `approve` that can be used as a mitigation for
600      * problems described in `IERC20.approve`.
601      *
602      * Emits an `Approval` event indicating the updated allowance.
603      *
604      * Requirements:
605      *
606      * - `spender` cannot be the zero address.
607      * - `spender` must have allowance for the caller of at least
608      * `subtractedValue`.
609      */
610     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
611         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
612         return true;
613     }
614 
615     /**
616      * @dev Moves tokens `amount` from `sender` to `recipient`.
617      *
618      * This is internal function is equivalent to `transfer`, and can be used to
619      * e.g. implement automatic token fees, slashing mechanisms, etc.
620      *
621      * Emits a `Transfer` event.
622      *
623      * Requirements:
624      *
625      * - `sender` cannot be the zero address.
626      * - `recipient` cannot be the zero address.
627      * - `sender` must have a balance of at least `amount`.
628      */
629     function _transfer(address sender, address recipient, uint256 amount) internal {
630         require(sender != address(0), "ERC20: transfer from the zero address");
631         require(recipient != address(0), "ERC20: transfer to the zero address");
632 
633         _balances[sender] = _balances[sender].sub(amount);
634         _balances[recipient] = _balances[recipient].add(amount);
635         emit Transfer(sender, recipient, amount);
636     }
637 
638     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
639      * the total supply.
640      *
641      * Emits a `Transfer` event with `from` set to the zero address.
642      *
643      * Requirements
644      *
645      * - `to` cannot be the zero address.
646      */
647     function _mint(address account, uint256 amount) internal {
648         require(account != address(0), "ERC20: mint to the zero address");
649 
650         _totalSupply = _totalSupply.add(amount);
651         _balances[account] = _balances[account].add(amount);
652         emit Transfer(address(0), account, amount);
653     }
654 
655      /**
656      * @dev Destoys `amount` tokens from `account`, reducing the
657      * total supply.
658      *
659      * Emits a `Transfer` event with `to` set to the zero address.
660      *
661      * Requirements
662      *
663      * - `account` cannot be the zero address.
664      * - `account` must have at least `amount` tokens.
665      */
666     function _burn(address account, uint256 value) internal {
667         require(account != address(0), "ERC20: burn from the zero address");
668 
669         _totalSupply = _totalSupply.sub(value);
670         _balances[account] = _balances[account].sub(value);
671         emit Transfer(account, address(0), value);
672     }
673 
674     /**
675      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
676      *
677      * This is internal function is equivalent to `approve`, and can be used to
678      * e.g. set automatic allowances for certain subsystems, etc.
679      *
680      * Emits an `Approval` event.
681      *
682      * Requirements:
683      *
684      * - `owner` cannot be the zero address.
685      * - `spender` cannot be the zero address.
686      */
687     function _approve(address owner, address spender, uint256 value) internal {
688         require(owner != address(0), "ERC20: approve from the zero address");
689         require(spender != address(0), "ERC20: approve to the zero address");
690 
691         _allowances[owner][spender] = value;
692         emit Approval(owner, spender, value);
693     }
694 
695     /**
696      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
697      * from the caller's allowance.
698      *
699      * See `_burn` and `_approve`.
700      */
701     function _burnFrom(address account, uint256 amount) internal {
702         _burn(account, amount);
703         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
704     }
705 }
706 
707 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
708 
709 pragma solidity ^0.5.0;
710 
711 
712 /**
713  * @dev Extension of `ERC20` that allows token holders to destroy both their own
714  * tokens and those that they have an allowance for, in a way that can be
715  * recognized off-chain (via event analysis).
716  */
717 contract ERC20Burnable is ERC20 {
718     /**
719      * @dev Destoys `amount` tokens from the caller.
720      *
721      * See `ERC20._burn`.
722      */
723     function burn(uint256 amount) public {
724         _burn(msg.sender, amount);
725     }
726 
727     /**
728      * @dev See `ERC20._burnFrom`.
729      */
730     function burnFrom(address account, uint256 amount) public {
731         _burnFrom(account, amount);
732     }
733 }
734 
735 // File: contracts/controller/DAOToken.sol
736 
737 pragma solidity 0.5.13;
738 
739 
740 
741 
742 
743 /**
744  * @title DAOToken, base on zeppelin contract.
745  * @dev ERC20 compatible token. It is a mintable, burnable token.
746  */
747 
748 contract DAOToken is ERC20, ERC20Burnable, Ownable {
749 
750     string public name;
751     string public symbol;
752     // solhint-disable-next-line const-name-snakecase
753     uint8 public constant decimals = 18;
754     uint256 public cap;
755 
756     /**
757     * @dev Constructor
758     * @param _name - token name
759     * @param _symbol - token symbol
760     * @param _cap - token cap - 0 value means no cap
761     */
762     constructor(string memory _name, string memory _symbol, uint256 _cap)
763     public {
764         name = _name;
765         symbol = _symbol;
766         cap = _cap;
767     }
768 
769     /**
770      * @dev Function to mint tokens
771      * @param _to The address that will receive the minted tokens.
772      * @param _amount The amount of tokens to mint.
773      */
774     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
775         if (cap > 0)
776             require(totalSupply().add(_amount) <= cap);
777         _mint(_to, _amount);
778         return true;
779     }
780 }
781 
782 // File: openzeppelin-solidity/contracts/utils/Address.sol
783 
784 pragma solidity ^0.5.0;
785 
786 /**
787  * @dev Collection of functions related to the address type,
788  */
789 library Address {
790     /**
791      * @dev Returns true if `account` is a contract.
792      *
793      * This test is non-exhaustive, and there may be false-negatives: during the
794      * execution of a contract's constructor, its address will be reported as
795      * not containing a contract.
796      *
797      * > It is unsafe to assume that an address for which this function returns
798      * false is an externally-owned account (EOA) and not a contract.
799      */
800     function isContract(address account) internal view returns (bool) {
801         // This method relies in extcodesize, which returns 0 for contracts in
802         // construction, since the code is only stored at the end of the
803         // constructor execution.
804 
805         uint256 size;
806         // solhint-disable-next-line no-inline-assembly
807         assembly { size := extcodesize(account) }
808         return size > 0;
809     }
810 }
811 
812 // File: contracts/libs/SafeERC20.sol
813 
814 /*
815 
816 SafeERC20 by daostack.
817 The code is based on a fix by SECBIT Team.
818 
819 USE WITH CAUTION & NO WARRANTY
820 
821 REFERENCE & RELATED READING
822 - https://github.com/ethereum/solidity/issues/4116
823 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
824 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
825 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
826 
827 */
828 pragma solidity 0.5.13;
829 
830 
831 
832 library SafeERC20 {
833     using Address for address;
834 
835     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
836     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
837     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
838 
839     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
840 
841         // Must be a contract addr first!
842         require(_erc20Addr.isContract());
843 
844         (bool success, bytes memory returnValue) =
845         // solhint-disable-next-line avoid-low-level-calls
846         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
847         // call return false when something wrong
848         require(success);
849         //check return value
850         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
851     }
852 
853     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
854 
855         // Must be a contract addr first!
856         require(_erc20Addr.isContract());
857 
858         (bool success, bytes memory returnValue) =
859         // solhint-disable-next-line avoid-low-level-calls
860         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
861         // call return false when something wrong
862         require(success);
863         //check return value
864         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
865     }
866 
867     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
868 
869         // Must be a contract addr first!
870         require(_erc20Addr.isContract());
871 
872         // safeApprove should only be called when setting an initial allowance,
873         // or when resetting it to zero.
874         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0));
875 
876         (bool success, bytes memory returnValue) =
877         // solhint-disable-next-line avoid-low-level-calls
878         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
879         // call return false when something wrong
880         require(success);
881         //check return value
882         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
883     }
884 }
885 
886 // File: contracts/controller/Avatar.sol
887 
888 pragma solidity 0.5.13;
889 
890 
891 
892 
893 
894 
895 
896 /**
897  * @title An Avatar holds tokens, reputation and ether for a controller
898  */
899 contract Avatar is Ownable {
900     using SafeERC20 for address;
901 
902     string public orgName;
903     DAOToken public nativeToken;
904     Reputation public nativeReputation;
905 
906     event GenericCall(address indexed _contract, bytes _data, uint _value, bool _success);
907     event SendEther(uint256 _amountInWei, address indexed _to);
908     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
909     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
910     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
911     event ReceiveEther(address indexed _sender, uint256 _value);
912     event MetaData(string _metaData);
913 
914     /**
915     * @dev the constructor takes organization name, native token and reputation system
916     and creates an avatar for a controller
917     */
918     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
919         orgName = _orgName;
920         nativeToken = _nativeToken;
921         nativeReputation = _nativeReputation;
922     }
923 
924     /**
925     * @dev enables an avatar to receive ethers
926     */
927     function() external payable {
928         emit ReceiveEther(msg.sender, msg.value);
929     }
930 
931     /**
932     * @dev perform a generic call to an arbitrary contract
933     * @param _contract  the contract's address to call
934     * @param _data ABI-encoded contract call to call `_contract` address.
935     * @param _value value (ETH) to transfer with the transaction
936     * @return bool    success or fail
937     *         bytes - the return bytes of the called contract's function.
938     */
939     function genericCall(address _contract, bytes memory _data, uint256 _value)
940     public
941     onlyOwner
942     returns(bool success, bytes memory returnValue) {
943       // solhint-disable-next-line avoid-call-value
944         (success, returnValue) = _contract.call.value(_value)(_data);
945         emit GenericCall(_contract, _data, _value, success);
946     }
947 
948     /**
949     * @dev send ethers from the avatar's wallet
950     * @param _amountInWei amount to send in Wei units
951     * @param _to send the ethers to this address
952     * @return bool which represents success
953     */
954     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
955         _to.transfer(_amountInWei);
956         emit SendEther(_amountInWei, _to);
957         return true;
958     }
959 
960     /**
961     * @dev external token transfer
962     * @param _externalToken the token contract
963     * @param _to the destination address
964     * @param _value the amount of tokens to transfer
965     * @return bool which represents success
966     */
967     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
968     public onlyOwner returns(bool)
969     {
970         address(_externalToken).safeTransfer(_to, _value);
971         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
972         return true;
973     }
974 
975     /**
976     * @dev external token transfer from a specific account
977     * @param _externalToken the token contract
978     * @param _from the account to spend token from
979     * @param _to the destination address
980     * @param _value the amount of tokens to transfer
981     * @return bool which represents success
982     */
983     function externalTokenTransferFrom(
984         IERC20 _externalToken,
985         address _from,
986         address _to,
987         uint256 _value
988     )
989     public onlyOwner returns(bool)
990     {
991         address(_externalToken).safeTransferFrom(_from, _to, _value);
992         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
993         return true;
994     }
995 
996     /**
997     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
998     *      on behalf of msg.sender.
999     * @param _externalToken the address of the Token Contract
1000     * @param _spender address
1001     * @param _value the amount of ether (in Wei) which the approval is referring to.
1002     * @return bool which represents a success
1003     */
1004     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
1005     public onlyOwner returns(bool)
1006     {
1007         address(_externalToken).safeApprove(_spender, _value);
1008         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
1009         return true;
1010     }
1011 
1012     /**
1013     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1014     * @param _metaData a string representing a hash of the meta data
1015     * @return bool which represents a success
1016     */
1017     function metaData(string memory _metaData) public onlyOwner returns(bool) {
1018         emit MetaData(_metaData);
1019         return true;
1020     }
1021 
1022 
1023 }
1024 
1025 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
1026 
1027 pragma solidity 0.5.13;
1028 
1029 
1030 contract GlobalConstraintInterface {
1031 
1032     enum CallPhase { Pre, Post, PreAndPost }
1033 
1034     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
1035     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
1036     /**
1037      * @dev when return if this globalConstraints is pre, post or both.
1038      * @return CallPhase enum indication  Pre, Post or PreAndPost.
1039      */
1040     function when() public returns(CallPhase);
1041 }
1042 
1043 // File: contracts/controller/Controller.sol
1044 
1045 pragma solidity 0.5.13;
1046 
1047 
1048 
1049 /**
1050  * @title Controller contract
1051  * @dev A controller controls the organizations tokens, reputation and avatar.
1052  * It is subject to a set of schemes and constraints that determine its behavior.
1053  * Each scheme has it own parameters and operation permissions.
1054  */
1055 contract Controller {
1056 
1057     struct Scheme {
1058         bytes32 paramsHash;  // a hash "configuration" of the scheme
1059         bytes4  permissions; // A bitwise flags of permissions,
1060                              // All 0: Not registered,
1061                              // 1st bit: Flag if the scheme is registered,
1062                              // 2nd bit: Scheme can register other schemes
1063                              // 3rd bit: Scheme can add/remove global constraints
1064                              // 4th bit: Scheme can upgrade the controller
1065                              // 5th bit: Scheme can call genericCall on behalf of
1066                              //          the organization avatar
1067     }
1068 
1069     struct GlobalConstraint {
1070         address gcAddress;
1071         bytes32 params;
1072     }
1073 
1074     struct GlobalConstraintRegister {
1075         bool isRegistered; //is registered
1076         uint256 index;    //index at globalConstraints
1077     }
1078 
1079     mapping(address=>Scheme) public schemes;
1080 
1081     Avatar public avatar;
1082     DAOToken public nativeToken;
1083     Reputation public nativeReputation;
1084   // newController will point to the new controller after the present controller is upgraded
1085     address public newController;
1086   // globalConstraintsPre that determine pre conditions for all actions on the controller
1087 
1088     GlobalConstraint[] public globalConstraintsPre;
1089   // globalConstraintsPost that determine post conditions for all actions on the controller
1090     GlobalConstraint[] public globalConstraintsPost;
1091   // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a pre global constraint
1092     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPre;
1093   // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a post global constraint
1094     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPost;
1095 
1096     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount);
1097     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount);
1098     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
1099     event RegisterScheme (address indexed _sender, address indexed _scheme);
1100     event UnregisterScheme (address indexed _sender, address indexed _scheme);
1101     event UpgradeController(address indexed _oldController, address _newController);
1102 
1103     event AddGlobalConstraint(
1104         address indexed _globalConstraint,
1105         bytes32 _params,
1106         GlobalConstraintInterface.CallPhase _when);
1107 
1108     event RemoveGlobalConstraint(address indexed _globalConstraint, uint256 _index, bool _isPre);
1109 
1110     constructor( Avatar _avatar) public {
1111         avatar = _avatar;
1112         nativeToken = avatar.nativeToken();
1113         nativeReputation = avatar.nativeReputation();
1114         schemes[msg.sender] = Scheme({paramsHash: bytes32(0), permissions: bytes4(0x0000001F)});
1115         emit RegisterScheme (msg.sender, msg.sender);
1116     }
1117 
1118   // Do not allow mistaken calls:
1119    // solhint-disable-next-line payable-fallback
1120     function() external {
1121         revert();
1122     }
1123 
1124   // Modifiers:
1125     modifier onlyRegisteredScheme() {
1126         require(schemes[msg.sender].permissions&bytes4(0x00000001) == bytes4(0x00000001));
1127         _;
1128     }
1129 
1130     modifier onlyRegisteringSchemes() {
1131         require(schemes[msg.sender].permissions&bytes4(0x00000002) == bytes4(0x00000002));
1132         _;
1133     }
1134 
1135     modifier onlyGlobalConstraintsScheme() {
1136         require(schemes[msg.sender].permissions&bytes4(0x00000004) == bytes4(0x00000004));
1137         _;
1138     }
1139 
1140     modifier onlyUpgradingScheme() {
1141         require(schemes[msg.sender].permissions&bytes4(0x00000008) == bytes4(0x00000008));
1142         _;
1143     }
1144 
1145     modifier onlyGenericCallScheme() {
1146         require(schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1147         _;
1148     }
1149 
1150     modifier onlyMetaDataScheme() {
1151         require(schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1152         _;
1153     }
1154 
1155     modifier onlySubjectToConstraint(bytes32 func) {
1156         uint256 idx;
1157         for (idx = 0; idx < globalConstraintsPre.length; idx++) {
1158             require(
1159             (GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress))
1160             .pre(msg.sender, globalConstraintsPre[idx].params, func));
1161         }
1162         _;
1163         for (idx = 0; idx < globalConstraintsPost.length; idx++) {
1164             require(
1165             (GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress))
1166             .post(msg.sender, globalConstraintsPost[idx].params, func));
1167         }
1168     }
1169 
1170     modifier isAvatarValid(address _avatar) {
1171         require(_avatar == address(avatar));
1172         _;
1173     }
1174 
1175     /**
1176      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1177      * @param  _amount amount of reputation to mint
1178      * @param _to beneficiary address
1179      * @return bool which represents a success
1180      */
1181     function mintReputation(uint256 _amount, address _to, address _avatar)
1182     external
1183     onlyRegisteredScheme
1184     onlySubjectToConstraint("mintReputation")
1185     isAvatarValid(_avatar)
1186     returns(bool)
1187     {
1188         emit MintReputation(msg.sender, _to, _amount);
1189         return nativeReputation.mint(_to, _amount);
1190     }
1191 
1192     /**
1193      * @dev Burns `_amount` of reputation from `_from`
1194      * @param _amount amount of reputation to burn
1195      * @param _from The address that will lose the reputation
1196      * @return bool which represents a success
1197      */
1198     function burnReputation(uint256 _amount, address _from, address _avatar)
1199     external
1200     onlyRegisteredScheme
1201     onlySubjectToConstraint("burnReputation")
1202     isAvatarValid(_avatar)
1203     returns(bool)
1204     {
1205         emit BurnReputation(msg.sender, _from, _amount);
1206         return nativeReputation.burn(_from, _amount);
1207     }
1208 
1209     /**
1210      * @dev mint tokens .
1211      * @param  _amount amount of token to mint
1212      * @param _beneficiary beneficiary address
1213      * @return bool which represents a success
1214      */
1215     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
1216     external
1217     onlyRegisteredScheme
1218     onlySubjectToConstraint("mintTokens")
1219     isAvatarValid(_avatar)
1220     returns(bool)
1221     {
1222         emit MintTokens(msg.sender, _beneficiary, _amount);
1223         return nativeToken.mint(_beneficiary, _amount);
1224     }
1225 
1226   /**
1227    * @dev register a scheme
1228    * @param _scheme the address of the scheme
1229    * @param _paramsHash a hashed configuration of the usage of the scheme
1230    * @param _permissions the permissions the new scheme will have
1231    * @return bool which represents a success
1232    */
1233     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
1234     external
1235     onlyRegisteringSchemes
1236     onlySubjectToConstraint("registerScheme")
1237     isAvatarValid(_avatar)
1238     returns(bool)
1239     {
1240 
1241         Scheme memory scheme = schemes[_scheme];
1242 
1243     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1244     // Implementation is a bit messy. One must recall logic-circuits ^^
1245 
1246     // produces non-zero if sender does not have all of the perms that are changing between old and new
1247         require(bytes4(0x0000001f)&(_permissions^scheme.permissions)&(~schemes[msg.sender].permissions) == bytes4(0));
1248 
1249     // produces non-zero if sender does not have all of the perms in the old scheme
1250         require(bytes4(0x0000001f)&(scheme.permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1251 
1252     // Add or change the scheme:
1253         schemes[_scheme].paramsHash = _paramsHash;
1254         schemes[_scheme].permissions = _permissions|bytes4(0x00000001);
1255         emit RegisterScheme(msg.sender, _scheme);
1256         return true;
1257     }
1258 
1259     /**
1260      * @dev unregister a scheme
1261      * @param _scheme the address of the scheme
1262      * @return bool which represents a success
1263      */
1264     function unregisterScheme( address _scheme, address _avatar)
1265     external
1266     onlyRegisteringSchemes
1267     onlySubjectToConstraint("unregisterScheme")
1268     isAvatarValid(_avatar)
1269     returns(bool)
1270     {
1271     //check if the scheme is registered
1272         if (_isSchemeRegistered(_scheme) == false) {
1273             return false;
1274         }
1275     // Check the unregistering scheme has enough permissions:
1276         require(bytes4(0x0000001f)&(schemes[_scheme].permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1277 
1278     // Unregister:
1279         emit UnregisterScheme(msg.sender, _scheme);
1280         delete schemes[_scheme];
1281         return true;
1282     }
1283 
1284     /**
1285      * @dev unregister the caller's scheme
1286      * @return bool which represents a success
1287      */
1288     function unregisterSelf(address _avatar) external isAvatarValid(_avatar) returns(bool) {
1289         if (_isSchemeRegistered(msg.sender) == false) {
1290             return false;
1291         }
1292         delete schemes[msg.sender];
1293         emit UnregisterScheme(msg.sender, msg.sender);
1294         return true;
1295     }
1296 
1297     /**
1298      * @dev add or update Global Constraint
1299      * @param _globalConstraint the address of the global constraint to be added.
1300      * @param _params the constraint parameters hash.
1301      * @return bool which represents a success
1302      */
1303     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
1304     external
1305     onlyGlobalConstraintsScheme
1306     isAvatarValid(_avatar)
1307     returns(bool)
1308     {
1309         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1310         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1311             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1312             if (!globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1313                 globalConstraintsPre.push(GlobalConstraint(_globalConstraint, _params));
1314                 globalConstraintsRegisterPre[_globalConstraint] =
1315                 GlobalConstraintRegister(true, globalConstraintsPre.length-1);
1316             }else {
1317                 globalConstraintsPre[globalConstraintsRegisterPre[_globalConstraint].index].params = _params;
1318             }
1319         }
1320         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1321             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1322             if (!globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1323                 globalConstraintsPost.push(GlobalConstraint(_globalConstraint, _params));
1324                 globalConstraintsRegisterPost[_globalConstraint] =
1325                 GlobalConstraintRegister(true, globalConstraintsPost.length-1);
1326             }else {
1327                 globalConstraintsPost[globalConstraintsRegisterPost[_globalConstraint].index].params = _params;
1328             }
1329         }
1330         emit AddGlobalConstraint(_globalConstraint, _params, when);
1331         return true;
1332     }
1333 
1334     /**
1335      * @dev remove Global Constraint
1336      * @param _globalConstraint the address of the global constraint to be remove.
1337      * @return bool which represents a success
1338      */
1339      // solhint-disable-next-line code-complexity
1340     function removeGlobalConstraint (address _globalConstraint, address _avatar)
1341     external
1342     onlyGlobalConstraintsScheme
1343     isAvatarValid(_avatar)
1344     returns(bool)
1345     {
1346         GlobalConstraintRegister memory globalConstraintRegister;
1347         GlobalConstraint memory globalConstraint;
1348         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1349         bool retVal = false;
1350 
1351         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1352             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1353             globalConstraintRegister = globalConstraintsRegisterPre[_globalConstraint];
1354             if (globalConstraintRegister.isRegistered) {
1355                 if (globalConstraintRegister.index < globalConstraintsPre.length-1) {
1356                     globalConstraint = globalConstraintsPre[globalConstraintsPre.length-1];
1357                     globalConstraintsPre[globalConstraintRegister.index] = globalConstraint;
1358                     globalConstraintsRegisterPre[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1359                 }
1360                 globalConstraintsPre.length--;
1361                 delete globalConstraintsRegisterPre[_globalConstraint];
1362                 retVal = true;
1363             }
1364         }
1365         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1366             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1367             globalConstraintRegister = globalConstraintsRegisterPost[_globalConstraint];
1368             if (globalConstraintRegister.isRegistered) {
1369                 if (globalConstraintRegister.index < globalConstraintsPost.length-1) {
1370                     globalConstraint = globalConstraintsPost[globalConstraintsPost.length-1];
1371                     globalConstraintsPost[globalConstraintRegister.index] = globalConstraint;
1372                     globalConstraintsRegisterPost[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1373                 }
1374                 globalConstraintsPost.length--;
1375                 delete globalConstraintsRegisterPost[_globalConstraint];
1376                 retVal = true;
1377             }
1378         }
1379         if (retVal) {
1380             emit RemoveGlobalConstraint(
1381             _globalConstraint,
1382             globalConstraintRegister.index,
1383             when == GlobalConstraintInterface.CallPhase.Pre
1384             );
1385         }
1386         return retVal;
1387     }
1388 
1389   /**
1390     * @dev upgrade the Controller
1391     *      The function will trigger an event 'UpgradeController'.
1392     * @param  _newController the address of the new controller.
1393     * @return bool which represents a success
1394     */
1395     function upgradeController(address _newController, Avatar _avatar)
1396     external
1397     onlyUpgradingScheme
1398     isAvatarValid(address(_avatar))
1399     returns(bool)
1400     {
1401         require(newController == address(0));   // so the upgrade could be done once for a contract.
1402         require(_newController != address(0));
1403         newController = _newController;
1404         avatar.transferOwnership(_newController);
1405         require(avatar.owner() == _newController);
1406         if (nativeToken.owner() == address(this)) {
1407             nativeToken.transferOwnership(_newController);
1408             require(nativeToken.owner() == _newController);
1409         }
1410         if (nativeReputation.owner() == address(this)) {
1411             nativeReputation.transferOwnership(_newController);
1412             require(nativeReputation.owner() == _newController);
1413         }
1414         emit UpgradeController(address(this), newController);
1415         return true;
1416     }
1417 
1418     /**
1419     * @dev perform a generic call to an arbitrary contract
1420     * @param _contract  the contract's address to call
1421     * @param _data ABI-encoded contract call to call `_contract` address.
1422     * @param _avatar the controller's avatar address
1423     * @param _value value (ETH) to transfer with the transaction
1424     * @return bool -success
1425     *         bytes  - the return value of the called _contract's function.
1426     */
1427     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
1428     external
1429     onlyGenericCallScheme
1430     onlySubjectToConstraint("genericCall")
1431     isAvatarValid(address(_avatar))
1432     returns (bool, bytes memory)
1433     {
1434         return avatar.genericCall(_contract, _data, _value);
1435     }
1436 
1437   /**
1438    * @dev send some ether
1439    * @param _amountInWei the amount of ether (in Wei) to send
1440    * @param _to address of the beneficiary
1441    * @return bool which represents a success
1442    */
1443     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1444     external
1445     onlyRegisteredScheme
1446     onlySubjectToConstraint("sendEther")
1447     isAvatarValid(address(_avatar))
1448     returns(bool)
1449     {
1450         return avatar.sendEther(_amountInWei, _to);
1451     }
1452 
1453     /**
1454     * @dev send some amount of arbitrary ERC20 Tokens
1455     * @param _externalToken the address of the Token Contract
1456     * @param _to address of the beneficiary
1457     * @param _value the amount of ether (in Wei) to send
1458     * @return bool which represents a success
1459     */
1460     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1461     external
1462     onlyRegisteredScheme
1463     onlySubjectToConstraint("externalTokenTransfer")
1464     isAvatarValid(address(_avatar))
1465     returns(bool)
1466     {
1467         return avatar.externalTokenTransfer(_externalToken, _to, _value);
1468     }
1469 
1470     /**
1471     * @dev transfer token "from" address "to" address
1472     *      One must to approve the amount of tokens which can be spend from the
1473     *      "from" account.This can be done using externalTokenApprove.
1474     * @param _externalToken the address of the Token Contract
1475     * @param _from address of the account to send from
1476     * @param _to address of the beneficiary
1477     * @param _value the amount of ether (in Wei) to send
1478     * @return bool which represents a success
1479     */
1480     function externalTokenTransferFrom(
1481     IERC20 _externalToken,
1482     address _from,
1483     address _to,
1484     uint256 _value,
1485     Avatar _avatar)
1486     external
1487     onlyRegisteredScheme
1488     onlySubjectToConstraint("externalTokenTransferFrom")
1489     isAvatarValid(address(_avatar))
1490     returns(bool)
1491     {
1492         return avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1493     }
1494 
1495     /**
1496     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1497     *      on behalf of msg.sender.
1498     * @param _externalToken the address of the Token Contract
1499     * @param _spender address
1500     * @param _value the amount of ether (in Wei) which the approval is referring to.
1501     * @return bool which represents a success
1502     */
1503     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1504     external
1505     onlyRegisteredScheme
1506     onlySubjectToConstraint("externalTokenIncreaseApproval")
1507     isAvatarValid(address(_avatar))
1508     returns(bool)
1509     {
1510         return avatar.externalTokenApproval(_externalToken, _spender, _value);
1511     }
1512 
1513     /**
1514     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1515     * @param _metaData a string representing a hash of the meta data
1516     * @param _avatar Avatar
1517     * @return bool which represents a success
1518     */
1519     function metaData(string calldata _metaData, Avatar _avatar)
1520         external
1521         onlyMetaDataScheme
1522         isAvatarValid(address(_avatar))
1523         returns(bool)
1524         {
1525         return avatar.metaData(_metaData);
1526     }
1527 
1528     /**
1529      * @dev getNativeReputation
1530      * @param _avatar the organization avatar.
1531      * @return organization native reputation
1532      */
1533     function getNativeReputation(address _avatar) external isAvatarValid(_avatar) view returns(address) {
1534         return address(nativeReputation);
1535     }
1536 
1537     function isSchemeRegistered(address _scheme, address _avatar) external isAvatarValid(_avatar) view returns(bool) {
1538         return _isSchemeRegistered(_scheme);
1539     }
1540 
1541     function getSchemeParameters(address _scheme, address _avatar)
1542     external
1543     isAvatarValid(_avatar)
1544     view
1545     returns(bytes32)
1546     {
1547         return schemes[_scheme].paramsHash;
1548     }
1549 
1550     function getSchemePermissions(address _scheme, address _avatar)
1551     external
1552     isAvatarValid(_avatar)
1553     view
1554     returns(bytes4)
1555     {
1556         return schemes[_scheme].permissions;
1557     }
1558 
1559     function getGlobalConstraintParameters(address _globalConstraint, address) external view returns(bytes32) {
1560 
1561         GlobalConstraintRegister memory register = globalConstraintsRegisterPre[_globalConstraint];
1562 
1563         if (register.isRegistered) {
1564             return globalConstraintsPre[register.index].params;
1565         }
1566 
1567         register = globalConstraintsRegisterPost[_globalConstraint];
1568 
1569         if (register.isRegistered) {
1570             return globalConstraintsPost[register.index].params;
1571         }
1572     }
1573 
1574    /**
1575     * @dev globalConstraintsCount return the global constraint pre and post count
1576     * @return uint256 globalConstraintsPre count.
1577     * @return uint256 globalConstraintsPost count.
1578     */
1579     function globalConstraintsCount(address _avatar)
1580         external
1581         isAvatarValid(_avatar)
1582         view
1583         returns(uint, uint)
1584         {
1585         return (globalConstraintsPre.length, globalConstraintsPost.length);
1586     }
1587 
1588     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar)
1589         external
1590         isAvatarValid(_avatar)
1591         view
1592         returns(bool)
1593         {
1594         return (globalConstraintsRegisterPre[_globalConstraint].isRegistered ||
1595                 globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1596     }
1597 
1598     function _isSchemeRegistered(address _scheme) private view returns(bool) {
1599         return (schemes[_scheme].permissions&bytes4(0x00000001) != bytes4(0));
1600     }
1601 }
1602 
1603 // File: contracts/schemes/Agreement.sol
1604 
1605 pragma solidity 0.5.13;
1606 
1607 /**
1608  * @title A scheme for conduct ERC20 Tokens auction for reputation
1609  */
1610 
1611 
1612 contract Agreement {
1613 
1614     bytes32 private agreementHash;
1615 
1616     modifier onlyAgree(bytes32 _agreementHash) {
1617         require(_agreementHash == agreementHash, "Sender must send the right agreementHash");
1618         _;
1619     }
1620 
1621     /**
1622      * @dev getAgreementHash
1623      * @return bytes32 agreementHash
1624      */
1625     function getAgreementHash() external  view returns(bytes32)
1626     {
1627         return agreementHash;
1628     }
1629 
1630     /**
1631      * @dev setAgreementHash
1632      * @param _agreementHash is a hash of agreement required to be added to the TX by participants
1633      */
1634     function setAgreementHash(bytes32 _agreementHash) internal
1635     {
1636         require(agreementHash == bytes32(0), "Can not set agreement twice");
1637         agreementHash = _agreementHash;
1638     }
1639 
1640 
1641 }
1642 
1643 // File: @daostack/infra/contracts/libs/RealMath.sol
1644 
1645 pragma solidity ^0.5.11;
1646 
1647 /**
1648  * RealMath: fixed-point math library, based on fractional and integer parts.
1649  * Using uint256 as real216x40, which isn't in Solidity yet.
1650  * Internally uses the wider uint256 for some math.
1651  *
1652  * Note that for addition, subtraction, and mod (%), you should just use the
1653  * built-in Solidity operators. Functions for these operations are not provided.
1654  *
1655  */
1656 
1657 
1658 library RealMath {
1659 
1660     /**
1661      * How many total bits are there?
1662      */
1663     uint256 constant private REAL_BITS = 256;
1664 
1665     /**
1666      * How many fractional bits are there?
1667      */
1668     uint256 constant private REAL_FBITS = 40;
1669 
1670     /**
1671      * What's the first non-fractional bit
1672      */
1673     uint256 constant private REAL_ONE = uint256(1) << REAL_FBITS;
1674 
1675     /**
1676      * Raise a real number to any positive integer power
1677      */
1678     function pow(uint256 realBase, uint256 exponent) internal pure returns (uint256) {
1679 
1680         uint256 tempRealBase = realBase;
1681         uint256 tempExponent = exponent;
1682 
1683         // Start with the 0th power
1684         uint256 realResult = REAL_ONE;
1685         while (tempExponent != 0) {
1686             // While there are still bits set
1687             if ((tempExponent & 0x1) == 0x1) {
1688                 // If the low bit is set, multiply in the (many-times-squared) base
1689                 realResult = mul(realResult, tempRealBase);
1690             }
1691                 // Shift off the low bit
1692             tempExponent = tempExponent >> 1;
1693             if (tempExponent != 0) {
1694                 // Do the squaring
1695                 tempRealBase = mul(tempRealBase, tempRealBase);
1696             }
1697         }
1698 
1699         // Return the final result.
1700         return realResult;
1701     }
1702 
1703     /**
1704      * Create a real from a rational fraction.
1705      */
1706     function fraction(uint216 numerator, uint216 denominator) internal pure returns (uint256) {
1707         return div(uint256(numerator) * REAL_ONE, uint256(denominator) * REAL_ONE);
1708     }
1709 
1710     /**
1711      * Multiply one real by another. Truncates overflows.
1712      */
1713     function mul(uint256 realA, uint256 realB) private pure returns (uint256) {
1714         // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
1715         // So we just have to clip off the extra REAL_FBITS fractional bits.
1716         uint256 res = realA * realB;
1717         require(res/realA == realB, "RealMath mul overflow");
1718         return (res >> REAL_FBITS);
1719     }
1720 
1721     /**
1722      * Divide one real by another real. Truncates overflows.
1723      */
1724     function div(uint256 realNumerator, uint256 realDenominator) private pure returns (uint256) {
1725         // We use the reverse of the multiplication trick: convert numerator from
1726         // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
1727         return uint256((uint256(realNumerator) * REAL_ONE) / uint256(realDenominator));
1728     }
1729 
1730 }
1731 
1732 // File: contracts/schemes/ContinuousLocking4Reputation.sol
1733 
1734 pragma solidity 0.5.13;
1735 
1736 
1737 
1738 
1739 
1740 
1741 
1742 /**
1743  * @title A scheme for continuous locking ERC20 Token for reputation
1744  */
1745 
1746 contract ContinuousLocking4Reputation is Agreement {
1747     using SafeMath for uint256;
1748     using SafeERC20 for address;
1749     using RealMath for uint216;
1750     using RealMath for uint256;
1751     using Math for uint256;
1752 
1753     event Redeem(uint256 indexed _lockingId, address indexed _beneficiary, uint256 _amount, uint256 _batchIndex);
1754     event Release(uint256 indexed _lockingId, address indexed _beneficiary, uint256 _amount);
1755     event LockToken(address indexed _locker, uint256 indexed _lockingId, uint256 _amount, uint256 _period);
1756     event ExtendLocking(address indexed _locker, uint256 indexed _lockingId, uint256 _extendPeriod);
1757 
1758     struct Batch {
1759         uint256 totalScore;
1760         // A mapping from lockingId to its score
1761         mapping(uint256=>uint) scores;
1762     }
1763 
1764     struct Lock {
1765         uint256 amount;
1766         uint256 lockingTime;
1767         uint256 period;
1768     }
1769 
1770     // A mapping from lockers addresses to their locks
1771     mapping(address => mapping(uint256=>Lock)) public lockers;
1772     // A mapping from batch index to batch
1773     mapping(uint256 => Batch) public batches;
1774 
1775     Avatar public avatar;
1776     uint256 public reputationRewardLeft; // the amount of reputation that is still left to distribute
1777     uint256 public startTime; // the time (in secs since epoch) that locking can start (is enable)
1778     uint256 public redeemEnableTime;
1779     uint256 public maxLockingBatches;
1780     uint256 public batchTime; // the length of a batch, in seconds
1781     IERC20 public token; // the token to be locked
1782     uint256 public lockCounter; // Total number of locks
1783     uint256 public totalLockedLeft; // the amount of reputation  that is still left to distribute
1784     uint256 public repRewardConstA;
1785     uint256 public repRewardConstB;
1786     uint256 public batchesIndexCap;
1787 
1788     uint256 constant private REAL_FBITS = 40;
1789     /**
1790      * What's the first non-fractional bit
1791      */
1792 
1793     uint256 constant private REAL_ONE = uint256(1) << REAL_FBITS;
1794     uint256 constant private BATCHES_INDEX_HARDCAP = 100;
1795     uint256 constant public MAX_LOCKING_BATCHES_HARDCAP = 24;
1796 
1797     /**
1798      * @dev initialize
1799      * @param _avatar the avatar to mint reputation from
1800      * @param _reputationReward the total amount of reputation that can be minted by this contract
1801      * @param _startTime locking period start time, in seconds since epoch
1802      * @param _redeemEnableTime redeem enable time
1803      * @param _batchTime batch time (in seconds)
1804      * @param _redeemEnableTime redeem enable time, in seconds since epoch
1805      *        redeem reputation can be done after this time.
1806      * @param _maxLockingBatches - maximum number of locking batches that a user can lock (or extend) her tokens for
1807      * @param _repRewardConstA - the total amount of reputation allocation per batch is calculated by :
1808      *   _repRewardConstA * ((_repRewardConstB/1000) ** batchIndex)
1809      * @param _repRewardConstB - the total amount of reputation allocation per batch is calculated by :
1810      *   _repRewardConstA * ((_repRewardConstB/1000) ** batchIndex). _repRewardConstB must be < 1000
1811      * @param _batchesIndexCap the length of the locking period (in batches).
1812      *        This value capped by BATCHES_HARDCAP .
1813      * @param _token the locking token
1814      * @param _agreementHash is a hash of agreement required to be added to the TX by participants
1815      */
1816     function initialize(
1817         Avatar _avatar,
1818         uint256 _reputationReward,
1819         uint256 _startTime,
1820         uint256 _batchTime,
1821         uint256 _redeemEnableTime,
1822         uint256 _maxLockingBatches,
1823         uint256 _repRewardConstA,
1824         uint256 _repRewardConstB,
1825         uint256 _batchesIndexCap,
1826         IERC20 _token,
1827         bytes32 _agreementHash )
1828     external
1829     {
1830         require(avatar == Avatar(0), "can be called only one time");
1831         require(_avatar != Avatar(0), "avatar cannot be zero");
1832         // _batchTime should be greater than block interval
1833         require(_batchTime > 15, "batchTime should be > 15");
1834         require(_maxLockingBatches <= MAX_LOCKING_BATCHES_HARDCAP,
1835         "maxLockingBatches should be <= MAX_LOCKING_BATCHES_HARDCAP");
1836         require(_redeemEnableTime >= _startTime.add(_batchTime),
1837         "_redeemEnableTime >= _startTime+_batchTime");
1838         require(_batchesIndexCap <= BATCHES_INDEX_HARDCAP, "_batchesIndexCap > BATCHES_INDEX_HARDCAP");
1839         token = _token;
1840         avatar = _avatar;
1841         startTime = _startTime;
1842         reputationRewardLeft = _reputationReward;
1843         redeemEnableTime = _redeemEnableTime;
1844         maxLockingBatches = _maxLockingBatches;
1845         batchTime = _batchTime;
1846         require(_repRewardConstB < 1000, "_repRewardConstB should be < 1000");
1847         require(_repRewardConstA < _reputationReward, "repRewardConstA should be < _reputationReward");
1848         repRewardConstA = toReal(uint216(_repRewardConstA));
1849         repRewardConstB = uint216(_repRewardConstB).fraction(uint216(1000));
1850         batchesIndexCap = _batchesIndexCap;
1851         super.setAgreementHash(_agreementHash);
1852     }
1853 
1854     /**
1855      * @dev redeem reputation function
1856      * @param _beneficiary the beneficiary to redeem.
1857      * @param _lockingId the lockingId to redeem from.
1858      * @return uint256 reputation rewarded
1859      */
1860     function redeem(address _beneficiary, uint256 _lockingId) public returns(uint256 reputation) {
1861         // solhint-disable-next-line not-rely-on-time
1862         require(now > redeemEnableTime, "now > redeemEnableTime");
1863         Lock storage locker = lockers[_beneficiary][_lockingId];
1864         require(locker.lockingTime != 0, "_lockingId does not exist");
1865         uint256 batchIndexToRedeemFrom = (locker.lockingTime - startTime) / batchTime;
1866         // solhint-disable-next-line not-rely-on-time
1867         uint256 currentBatch = (now - startTime) / batchTime;
1868         uint256 lastBatchIndexToRedeem =  currentBatch.min(batchIndexToRedeemFrom.add(locker.period));
1869         for (batchIndexToRedeemFrom; batchIndexToRedeemFrom < lastBatchIndexToRedeem; batchIndexToRedeemFrom++) {
1870             Batch storage locking = batches[batchIndexToRedeemFrom];
1871             uint256 score = locking.scores[_lockingId];
1872             if (score > 0) {
1873                 locking.scores[_lockingId] = 0;
1874                 uint256 batchReputationReward = getRepRewardPerBatch(batchIndexToRedeemFrom);
1875                 uint256 repRelation = mul(toReal(uint216(score)), batchReputationReward);
1876                 uint256 redeemForBatch = div(repRelation, toReal(uint216(locking.totalScore)));
1877                 reputation = reputation.add(redeemForBatch);
1878                 emit Redeem(_lockingId, _beneficiary, uint256(fromReal(redeemForBatch)), batchIndexToRedeemFrom);
1879             }
1880         }
1881         reputation = uint256(fromReal(reputation));
1882         require(reputation > 0, "reputation to redeem is 0");
1883         // check that the reputation is sum zero
1884         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1885         require(
1886         Controller(avatar.owner())
1887         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1888     }
1889 
1890     /**
1891      * @dev lock function
1892      * @param _amount the amount of token to lock
1893      * @param _period the number of batches that the tokens will be locked for
1894      * @param _batchIndexToLockIn the batch index in which the locking period starts.
1895      * Must be the currently active batch.
1896      * @return lockingId
1897      */
1898     function lock(uint256 _amount, uint256 _period, uint256 _batchIndexToLockIn, bytes32 _agreementHash)
1899     public
1900     onlyAgree(_agreementHash)
1901     returns(uint256 lockingId)
1902     {
1903         require(_amount > 0, "_amount should be > 0");
1904         // solhint-disable-next-line not-rely-on-time
1905         require(now >= startTime, "locking is not enabled yet (it starts at startTime)");
1906         require(_period <= maxLockingBatches, "_period exceed the maximum allowed");
1907         require(_period > 0, "_period must be > 0");
1908         require((_batchIndexToLockIn.add(_period)) <= batchesIndexCap,
1909         "_batchIndexToLockIn + _period exceed max allowed batches");
1910         lockCounter = lockCounter.add(1);
1911         lockingId = lockCounter;
1912 
1913         Lock storage locker = lockers[msg.sender][lockingId];
1914         locker.amount = _amount;
1915         locker.period = _period;
1916         // solhint-disable-next-line not-rely-on-time
1917         locker.lockingTime = now;
1918 
1919         address(token).safeTransferFrom(msg.sender, address(this), _amount);
1920         // solhint-disable-next-line not-rely-on-time
1921         uint256 batchIndexToLockIn = (now - startTime) / batchTime;
1922         require(batchIndexToLockIn == _batchIndexToLockIn,
1923         "_batchIndexToLockIn must be the one corresponding to the current one");
1924         //fill in the next batches scores.
1925         for (uint256 p = 0; p < _period; p++) {
1926             Batch storage batch = batches[batchIndexToLockIn + p];
1927             uint256 score = (_period - p).mul(_amount);
1928             batch.totalScore = batch.totalScore.add(score);
1929             batch.scores[lockingId] = score;
1930         }
1931 
1932         totalLockedLeft = totalLockedLeft.add(_amount);
1933         emit LockToken(msg.sender, lockingId, _amount, _period);
1934     }
1935 
1936     /**
1937      * @dev extendLocking function
1938      * @param _extendPeriod the period to extend the locking. in batchTime.
1939      * @param _batchIndexToLockIn index of the batch in which to start locking.
1940      * @param _lockingId the locking id to extend
1941      */
1942     function extendLocking(
1943         uint256 _extendPeriod,
1944         uint256 _batchIndexToLockIn,
1945         uint256 _lockingId,
1946         bytes32 _agreementHash)
1947     public
1948     onlyAgree(_agreementHash)
1949     {
1950         Lock storage locker = lockers[msg.sender][_lockingId];
1951         require(locker.lockingTime != 0, "_lockingId does not exist");
1952         // remainBatchs is the number of future batches that are part of the currently active lock
1953         uint256 remainBatches =
1954         ((locker.lockingTime.add(locker.period*batchTime).sub(startTime))/batchTime).sub(_batchIndexToLockIn);
1955         uint256 batchesCountFromCurrent = remainBatches.add(_extendPeriod);
1956         require(batchesCountFromCurrent <= maxLockingBatches, "locking period exceeds the maximum allowed");
1957         require(_extendPeriod > 0, "_extendPeriod must be > 0");
1958         require((_batchIndexToLockIn.add(batchesCountFromCurrent)) <= batchesIndexCap,
1959         "_extendPeriod exceed max allowed batches");
1960         // solhint-disable-next-line not-rely-on-time
1961         uint256 batchIndexToLockIn = (now - startTime) / batchTime;
1962         require(batchIndexToLockIn == _batchIndexToLockIn, "locking is not active");
1963         //fill in the next batch scores.
1964         for (uint256 p = 0; p < batchesCountFromCurrent; p++) {
1965             Batch storage batch = batches[batchIndexToLockIn + p];
1966             uint256 score = (batchesCountFromCurrent - p).mul(locker.amount);
1967             batch.totalScore = batch.totalScore.add(score).sub(batch.scores[_lockingId]);
1968             batch.scores[_lockingId] = score;
1969         }
1970         locker.period = locker.period.add(_extendPeriod);
1971         emit ExtendLocking(msg.sender, _lockingId, _extendPeriod);
1972     }
1973 
1974     /**
1975      * @dev release function
1976      * @param _beneficiary the beneficiary for the release
1977      * @param _lockingId the locking id to release
1978      * @return bool
1979      */
1980     function release(address _beneficiary, uint256 _lockingId) public returns(uint256 amount) {
1981         Lock storage locker = lockers[_beneficiary][_lockingId];
1982         require(locker.amount > 0, "no amount left to unlock");
1983         amount = locker.amount;
1984         locker.amount = 0;
1985         // solhint-disable-next-line not-rely-on-time
1986         require(block.timestamp > locker.lockingTime.add(locker.period*batchTime),
1987         "locking period is still active");
1988         totalLockedLeft = totalLockedLeft.sub(amount);
1989         address(token).safeTransfer(_beneficiary, amount);
1990         emit Release(_lockingId, _beneficiary, amount);
1991     }
1992 
1993     /**
1994      * @dev getRepRewardPerBatch function
1995      * the calculation is done the following formula:
1996      * RepReward =  repRewardConstA * (repRewardConstB**_batchIndex)
1997      * @param _batchIndex the index of the batch to calc rep reward of
1998      * @return repReward
1999      */
2000     function getRepRewardPerBatch(uint256  _batchIndex) public view returns(uint256 repReward) {
2001         if (_batchIndex <= batchesIndexCap) {
2002             repReward = mul(repRewardConstA, repRewardConstB.pow(_batchIndex));
2003         }
2004     }
2005 
2006     /**
2007      * @dev getLockingIdScore function
2008      * return score of lockingId at specific bach index
2009      * @param _batchIndex batch index
2010      * @param _lockingId lockingId
2011      * @return score
2012      */
2013     function getLockingIdScore(uint256  _batchIndex, uint256 _lockingId) public view returns(uint256) {
2014         return batches[_batchIndex].scores[_lockingId];
2015     }
2016 
2017     /**
2018      * Multiply one real by another. Truncates overflows.
2019      */
2020     function mul(uint256 realA, uint256 realB) private pure returns (uint256) {
2021         // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
2022         // So we just have to clip off the extra REAL_FBITS fractional bits.
2023         uint256 res = realA * realB;
2024         require(res/realA == realB, "RealMath mul overflow");
2025         return (res >> REAL_FBITS);
2026     }
2027 
2028     /**
2029      * Convert an integer to a real. Preserves sign.
2030      */
2031     function toReal(uint216 ipart) private pure returns (uint256) {
2032         return uint256(ipart) * REAL_ONE;
2033     }
2034 
2035     /**
2036      * Convert a real to an integer. Preserves sign.
2037      */
2038     function fromReal(uint256 _realValue) private pure returns (uint216) {
2039         return uint216(_realValue / REAL_ONE);
2040     }
2041 
2042     /**
2043      * Divide one real by another real. Truncates overflows.
2044      */
2045     function div(uint256 realNumerator, uint256 realDenominator) private pure returns (uint256) {
2046         // We use the reverse of the multiplication trick: convert numerator from
2047         // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
2048         return uint256((uint256(realNumerator) * REAL_ONE) / uint256(realDenominator));
2049     }
2050 
2051 }