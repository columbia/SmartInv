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
420 // File: openzeppelin-solidity/contracts/access/Roles.sol
421 
422 pragma solidity ^0.5.0;
423 
424 /**
425  * @title Roles
426  * @dev Library for managing addresses assigned to a Role.
427  */
428 library Roles {
429     struct Role {
430         mapping (address => bool) bearer;
431     }
432 
433     /**
434      * @dev Give an account access to this role.
435      */
436     function add(Role storage role, address account) internal {
437         require(!has(role, account), "Roles: account already has role");
438         role.bearer[account] = true;
439     }
440 
441     /**
442      * @dev Remove an account's access to this role.
443      */
444     function remove(Role storage role, address account) internal {
445         require(has(role, account), "Roles: account does not have role");
446         role.bearer[account] = false;
447     }
448 
449     /**
450      * @dev Check if an account has this role.
451      * @return bool
452      */
453     function has(Role storage role, address account) internal view returns (bool) {
454         require(account != address(0), "Roles: account is the zero address");
455         return role.bearer[account];
456     }
457 }
458 
459 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
460 
461 pragma solidity ^0.5.0;
462 
463 
464 contract MinterRole {
465     using Roles for Roles.Role;
466 
467     event MinterAdded(address indexed account);
468     event MinterRemoved(address indexed account);
469 
470     Roles.Role private _minters;
471 
472     constructor () internal {
473         _addMinter(msg.sender);
474     }
475 
476     modifier onlyMinter() {
477         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
478         _;
479     }
480 
481     function isMinter(address account) public view returns (bool) {
482         return _minters.has(account);
483     }
484 
485     function addMinter(address account) public onlyMinter {
486         _addMinter(account);
487     }
488 
489     function renounceMinter() public {
490         _removeMinter(msg.sender);
491     }
492 
493     function _addMinter(address account) internal {
494         _minters.add(account);
495         emit MinterAdded(account);
496     }
497 
498     function _removeMinter(address account) internal {
499         _minters.remove(account);
500         emit MinterRemoved(account);
501     }
502 }
503 
504 // File: contracts/token/ERC20Interface.sol
505 
506 pragma solidity 0.5.9;
507 
508 
509 interface ERC20Interface {
510   // Standard ERC-20 interface.
511   function transfer(address to, uint256 value) external returns (bool);
512   function approve(address spender, uint256 value) external returns (bool);
513   function transferFrom(address from, address to, uint256 value) external returns (bool);
514   function totalSupply() external view returns (uint256);
515   function balanceOf(address who) external view returns (uint256);
516   function allowance(address owner, address spender) external view returns (uint256);
517   // Extension of ERC-20 interface to support supply adjustment.
518   function mint(address to, uint256 value) external returns (bool);
519   function burn(address from, uint256 value) external returns (bool);
520 }
521 
522 // File: contracts/token/ERC20Base.sol
523 
524 pragma solidity 0.5.9;
525 
526 
527 
528 
529 
530 /// "ERC20Base" is the standard ERC-20 implementation that allows its minter to mint tokens. Both BandToken and
531 /// CommunityToken extend from ERC20Base. In addition to the standard functions, the class provides `transferAndCall`
532 /// function, which performs a transfer and invokes the given function using the provided data. If the destination
533 /// contract uses "ERC20Acceptor" interface, it can verify that the caller properly sends appropriate amount of tokens.
534 contract ERC20Base is ERC20Interface, ERC20, MinterRole {
535   string public name;
536   string public symbol;
537   uint8 public decimals = 18;
538 
539   constructor(string memory _name, string memory _symbol) public {
540     name = _name;
541     symbol = _symbol;
542   }
543 
544   function transferAndCall(address to, uint256 value, bytes4 sig, bytes memory data) public returns (bool) {
545     require(to != address(this));
546     _transfer(msg.sender, to, value);
547     (bool success,) = to.call(abi.encodePacked(sig, uint256(msg.sender), value, data));
548     require(success);
549     return true;
550   }
551 
552   function mint(address to, uint256 value) public onlyMinter returns (bool) {
553     _mint(to, value);
554     return true;
555   }
556 
557   function burn(address from, uint256 value) public onlyMinter returns (bool) {
558     _burn(from, value);
559     return true;
560   }
561 }
562 
563 // File: contracts/token/SnapshotToken.sol
564 
565 pragma solidity 0.5.9;
566 
567 
568 
569 
570 contract SnapshotToken is ERC20Base {
571   using SafeMath for uint256;
572 
573   /// IMPORTANT: votingPowers are kept as a linked list of ALL historical changes.
574   /// - This allows the contract to figure out voting power of the address at any nonce `n`, by
575   /// searching for the node that has the biggest nonce that is not greater than `n`.
576   /// - For efficiency, nonce and power are packed into one uint256 integer, with the top 64 bits
577   /// representing nonce, and the bottom 192 bits representing voting power.
578   mapping (address => mapping(uint256 => uint256)) _votingPower;
579   mapping (address => uint256) public votingPowerChangeCount;
580   uint256 public votingPowerChangeNonce = 0;
581 
582   /// Returns user voting power at the given index, that is, as of the user's index^th voting power change
583   function historicalVotingPowerAtIndex(address owner, uint256 index) public view returns (uint256) {
584     require(index <= votingPowerChangeCount[owner]);
585     return _votingPower[owner][index] & ((1 << 192) - 1);  // Lower 192 bits
586   }
587 
588   /// Returns user voting power at the given time. Under the hood, this performs binary search
589   /// to look for the largest index at which the nonce is not greater than 'nonce'.
590   /// The voting power at that index is the returning value.
591   function historicalVotingPowerAtNonce(address owner, uint256 nonce) public view returns (uint256) {
592     require(nonce <= votingPowerChangeNonce && nonce < (1 << 64));
593     uint256 start = 0;
594     uint256 end = votingPowerChangeCount[owner];
595     while (start < end) {
596       uint256 mid = start.add(end).add(1).div(2); /// Use (start+end+1)/2 to prevent infinite loop.
597       if ((_votingPower[owner][mid] >> 192) > nonce) {  /// Upper 64-bit nonce
598         /// If midTime > nonce, this mid can't possibly be the answer.
599         end = mid.sub(1);
600       } else {
601         /// Otherwise, search on the greater side, but still keep mid as a possible option.
602         start = mid;
603       }
604     }
605     return historicalVotingPowerAtIndex(owner, start);
606   }
607 
608   function _transfer(address from, address to, uint256 value) internal {
609     super._transfer(from, to, value);
610     votingPowerChangeNonce = votingPowerChangeNonce.add(1);
611     _changeVotingPower(from);
612     _changeVotingPower(to);
613   }
614 
615   function _mint(address account, uint256 amount) internal {
616     super._mint(account, amount);
617     votingPowerChangeNonce = votingPowerChangeNonce.add(1);
618     _changeVotingPower(account);
619   }
620 
621   function _burn(address account, uint256 amount) internal {
622     super._burn(account, amount);
623     votingPowerChangeNonce = votingPowerChangeNonce.add(1);
624     _changeVotingPower(account);
625   }
626 
627   function _changeVotingPower(address account) internal {
628     uint256 currentIndex = votingPowerChangeCount[account];
629     uint256 newPower = balanceOf(account);
630     require(newPower < (1 << 192));
631     require(votingPowerChangeNonce < (1 << 64));
632     currentIndex = currentIndex.add(1);
633     votingPowerChangeCount[account] = currentIndex;
634     _votingPower[account][currentIndex] = (votingPowerChangeNonce << 192) | newPower;
635   }
636 }
637 
638 // File: openzeppelin-solidity/contracts/math/Math.sol
639 
640 pragma solidity ^0.5.0;
641 
642 /**
643  * @dev Standard math utilities missing in the Solidity language.
644  */
645 library Math {
646     /**
647      * @dev Returns the largest of two numbers.
648      */
649     function max(uint256 a, uint256 b) internal pure returns (uint256) {
650         return a >= b ? a : b;
651     }
652 
653     /**
654      * @dev Returns the smallest of two numbers.
655      */
656     function min(uint256 a, uint256 b) internal pure returns (uint256) {
657         return a < b ? a : b;
658     }
659 
660     /**
661      * @dev Returns the average of two numbers. The result is rounded towards
662      * zero.
663      */
664     function average(uint256 a, uint256 b) internal pure returns (uint256) {
665         // (a + b) / 2 can overflow, so we distribute
666         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
667     }
668 }
669 
670 // File: openzeppelin-solidity/contracts/access/roles/CapperRole.sol
671 
672 pragma solidity ^0.5.0;
673 
674 
675 contract CapperRole {
676     using Roles for Roles.Role;
677 
678     event CapperAdded(address indexed account);
679     event CapperRemoved(address indexed account);
680 
681     Roles.Role private _cappers;
682 
683     constructor () internal {
684         _addCapper(msg.sender);
685     }
686 
687     modifier onlyCapper() {
688         require(isCapper(msg.sender), "CapperRole: caller does not have the Capper role");
689         _;
690     }
691 
692     function isCapper(address account) public view returns (bool) {
693         return _cappers.has(account);
694     }
695 
696     function addCapper(address account) public onlyCapper {
697         _addCapper(account);
698     }
699 
700     function renounceCapper() public {
701         _removeCapper(msg.sender);
702     }
703 
704     function _addCapper(address account) internal {
705         _cappers.add(account);
706         emit CapperAdded(account);
707     }
708 
709     function _removeCapper(address account) internal {
710         _cappers.remove(account);
711         emit CapperRemoved(account);
712     }
713 }
714 
715 // File: contracts/token/LockableToken.sol
716 
717 pragma solidity 0.5.9;
718 
719 
720 
721 
722 
723 
724 /// "LockableToken" adds token locking functionality to ERC-20 smart contract. The authorized addresses (Cappers) are
725 /// allowed to lock tokens from any token holder to prevent token transfers up to that amount. If a token holder is
726 /// locked by multiple cappers, the maximum number is used as the amount of locked tokens.
727 contract LockableToken is ERC20Base, CapperRole {
728   using SafeMath for uint256;
729 
730   event TokenLocked(address indexed locker, address indexed owner, uint256 value);
731   event TokenUnlocked(address indexed locker, address indexed owner, uint256 value);
732 
733   uint256 constant NOT_FOUND = uint256(-1);
734 
735   struct TokenLock {
736     address locker;
737     uint256 value;
738   }
739 
740   mapping (address => TokenLock[]) _locks;
741 
742   function getLockedToken(address owner) public view returns (uint256) {
743     TokenLock[] storage locks = _locks[owner];
744     uint256 maxLock = 0;
745     for (uint256 i = 0; i < locks.length; ++i) {
746       maxLock = Math.max(maxLock, locks[i].value);
747     }
748     return maxLock;
749   }
750 
751   function getLockedTokenAt(address owner, address locker) public view returns (uint256) {
752     uint256 index = _getTokenLockIndex(owner, locker);
753     if (index != NOT_FOUND) return _locks[owner][index].value;
754     else return 0;
755   }
756 
757   function unlockedBalanceOf(address owner) public view returns (uint256) {
758     return balanceOf(owner).sub(getLockedToken(owner));
759   }
760 
761   function lock(address owner, uint256 value) public onlyCapper returns (bool) {
762     uint256 index = _getTokenLockIndex(owner, msg.sender);
763     if (index != NOT_FOUND) {
764       uint256 currentLock = _locks[owner][index].value;
765       require(balanceOf(owner) >= currentLock.add(value));
766       _locks[owner][index].value = currentLock.add(value);
767     } else {
768       require(balanceOf(owner) >= value);
769       _locks[owner].push(TokenLock(msg.sender, value));
770     }
771     emit TokenLocked(msg.sender, owner, value);
772     return true;
773   }
774 
775   function unlock(address owner, uint256 value) public returns (bool) {
776     uint256 index = _getTokenLockIndex(owner, msg.sender);
777     require(index != NOT_FOUND);
778     TokenLock[] storage locks = _locks[owner];
779     require(locks[index].value >= value);
780     locks[index].value = locks[index].value.sub(value);
781     if (locks[index].value == 0) {
782       if (index != locks.length - 1) {
783         locks[index] = locks[locks.length - 1];
784       }
785       locks.pop();
786     }
787     emit TokenUnlocked(msg.sender, owner, value);
788     return true;
789   }
790 
791   function _getTokenLockIndex(address owner, address locker) internal view returns (uint256) {
792     TokenLock[] storage locks = _locks[owner];
793     for (uint256 i = 0; i < locks.length; ++i) {
794       if (locks[i].locker == locker) return i;
795     }
796     return NOT_FOUND;
797   }
798 
799   function _transfer(address from, address to, uint256 value) internal {
800     require(unlockedBalanceOf(from) >= value);
801     super._transfer(from, to, value);
802   }
803 
804   function _burn(address account, uint256 value) internal {
805     require(unlockedBalanceOf(account) >= value);
806     super._burn(account, value);
807   }
808 }
809 
810 // File: contracts/CommunityToken.sol
811 
812 pragma solidity 0.5.9;
813 
814 
815 
816 
817 
818 /// "CommunityToken" is an ERC-20 token specific for each dataset community.
819 contract CommunityToken is SnapshotToken, LockableToken {
820   constructor(string memory name, string memory symbol) public ERC20Base(name, symbol) {}
821 }