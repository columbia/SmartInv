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
111 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be aplied to your functions to restrict their use to
122  * the owner.
123  */
124 contract Ownable {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor () internal {
133         _owner = msg.sender;
134         emit OwnershipTransferred(address(0), _owner);
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(isOwner(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Returns true if the caller is the current owner.
154      */
155     function isOwner() public view returns (bool) {
156         return msg.sender == _owner;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * > Note: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public onlyOwner {
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      */
182     function _transferOwnership(address newOwner) internal {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
195  * the optional functions; to access them see `ERC20Detailed`.
196  */
197 interface IERC20 {
198     /**
199      * @dev Returns the amount of tokens in existence.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     /**
204      * @dev Returns the amount of tokens owned by `account`.
205      */
206     function balanceOf(address account) external view returns (uint256);
207 
208     /**
209      * @dev Moves `amount` tokens from the caller's account to `recipient`.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a `Transfer` event.
214      */
215     function transfer(address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Returns the remaining number of tokens that `spender` will be
219      * allowed to spend on behalf of `owner` through `transferFrom`. This is
220      * zero by default.
221      *
222      * This value changes when `approve` or `transferFrom` are called.
223      */
224     function allowance(address owner, address spender) external view returns (uint256);
225 
226     /**
227      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * > Beware that changing an allowance with this method brings the risk
232      * that someone may use both the old and the new allowance by unfortunate
233      * transaction ordering. One possible solution to mitigate this race
234      * condition is to first reduce the spender's allowance to 0 and set the
235      * desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      *
238      * Emits an `Approval` event.
239      */
240     function approve(address spender, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Moves `amount` tokens from `sender` to `recipient` using the
244      * allowance mechanism. `amount` is then deducted from the caller's
245      * allowance.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * Emits a `Transfer` event.
250      */
251     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Emitted when `value` tokens are moved from one account (`from`) to
255      * another (`to`).
256      *
257      * Note that `value` may be zero.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     /**
262      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
263      * a call to `approve`. `value` is the new allowance.
264      */
265     event Approval(address indexed owner, address indexed spender, uint256 value);
266 }
267 
268 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
269 
270 pragma solidity ^0.5.0;
271 
272 
273 
274 /**
275  * @dev Implementation of the `IERC20` interface.
276  *
277  * This implementation is agnostic to the way tokens are created. This means
278  * that a supply mechanism has to be added in a derived contract using `_mint`.
279  * For a generic mechanism see `ERC20Mintable`.
280  *
281  * *For a detailed writeup see our guide [How to implement supply
282  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
283  *
284  * We have followed general OpenZeppelin guidelines: functions revert instead
285  * of returning `false` on failure. This behavior is nonetheless conventional
286  * and does not conflict with the expectations of ERC20 applications.
287  *
288  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
289  * This allows applications to reconstruct the allowance for all accounts just
290  * by listening to said events. Other implementations of the EIP may not emit
291  * these events, as it isn't required by the specification.
292  *
293  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
294  * functions have been added to mitigate the well-known issues around setting
295  * allowances. See `IERC20.approve`.
296  */
297 contract ERC20 is IERC20 {
298     using SafeMath for uint256;
299 
300     mapping (address => uint256) private _balances;
301 
302     mapping (address => mapping (address => uint256)) private _allowances;
303 
304     uint256 private _totalSupply;
305 
306     /**
307      * @dev See `IERC20.totalSupply`.
308      */
309     function totalSupply() public view returns (uint256) {
310         return _totalSupply;
311     }
312 
313     /**
314      * @dev See `IERC20.balanceOf`.
315      */
316     function balanceOf(address account) public view returns (uint256) {
317         return _balances[account];
318     }
319 
320     /**
321      * @dev See `IERC20.transfer`.
322      *
323      * Requirements:
324      *
325      * - `recipient` cannot be the zero address.
326      * - the caller must have a balance of at least `amount`.
327      */
328     function transfer(address recipient, uint256 amount) public returns (bool) {
329         _transfer(msg.sender, recipient, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See `IERC20.allowance`.
335      */
336     function allowance(address owner, address spender) public view returns (uint256) {
337         return _allowances[owner][spender];
338     }
339 
340     /**
341      * @dev See `IERC20.approve`.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function approve(address spender, uint256 value) public returns (bool) {
348         _approve(msg.sender, spender, value);
349         return true;
350     }
351 
352     /**
353      * @dev See `IERC20.transferFrom`.
354      *
355      * Emits an `Approval` event indicating the updated allowance. This is not
356      * required by the EIP. See the note at the beginning of `ERC20`;
357      *
358      * Requirements:
359      * - `sender` and `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `value`.
361      * - the caller must have allowance for `sender`'s tokens of at least
362      * `amount`.
363      */
364     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
365         _transfer(sender, recipient, amount);
366         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
367         return true;
368     }
369 
370     /**
371      * @dev Atomically increases the allowance granted to `spender` by the caller.
372      *
373      * This is an alternative to `approve` that can be used as a mitigation for
374      * problems described in `IERC20.approve`.
375      *
376      * Emits an `Approval` event indicating the updated allowance.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      */
382     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
383         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
384         return true;
385     }
386 
387     /**
388      * @dev Atomically decreases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to `approve` that can be used as a mitigation for
391      * problems described in `IERC20.approve`.
392      *
393      * Emits an `Approval` event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      * - `spender` must have allowance for the caller of at least
399      * `subtractedValue`.
400      */
401     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
402         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
403         return true;
404     }
405 
406     /**
407      * @dev Moves tokens `amount` from `sender` to `recipient`.
408      *
409      * This is internal function is equivalent to `transfer`, and can be used to
410      * e.g. implement automatic token fees, slashing mechanisms, etc.
411      *
412      * Emits a `Transfer` event.
413      *
414      * Requirements:
415      *
416      * - `sender` cannot be the zero address.
417      * - `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      */
420     function _transfer(address sender, address recipient, uint256 amount) internal {
421         require(sender != address(0), "ERC20: transfer from the zero address");
422         require(recipient != address(0), "ERC20: transfer to the zero address");
423 
424         _balances[sender] = _balances[sender].sub(amount);
425         _balances[recipient] = _balances[recipient].add(amount);
426         emit Transfer(sender, recipient, amount);
427     }
428 
429     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
430      * the total supply.
431      *
432      * Emits a `Transfer` event with `from` set to the zero address.
433      *
434      * Requirements
435      *
436      * - `to` cannot be the zero address.
437      */
438     function _mint(address account, uint256 amount) internal {
439         require(account != address(0), "ERC20: mint to the zero address");
440 
441         _totalSupply = _totalSupply.add(amount);
442         _balances[account] = _balances[account].add(amount);
443         emit Transfer(address(0), account, amount);
444     }
445 
446      /**
447      * @dev Destoys `amount` tokens from `account`, reducing the
448      * total supply.
449      *
450      * Emits a `Transfer` event with `to` set to the zero address.
451      *
452      * Requirements
453      *
454      * - `account` cannot be the zero address.
455      * - `account` must have at least `amount` tokens.
456      */
457     function _burn(address account, uint256 value) internal {
458         require(account != address(0), "ERC20: burn from the zero address");
459 
460         _totalSupply = _totalSupply.sub(value);
461         _balances[account] = _balances[account].sub(value);
462         emit Transfer(account, address(0), value);
463     }
464 
465     /**
466      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
467      *
468      * This is internal function is equivalent to `approve`, and can be used to
469      * e.g. set automatic allowances for certain subsystems, etc.
470      *
471      * Emits an `Approval` event.
472      *
473      * Requirements:
474      *
475      * - `owner` cannot be the zero address.
476      * - `spender` cannot be the zero address.
477      */
478     function _approve(address owner, address spender, uint256 value) internal {
479         require(owner != address(0), "ERC20: approve from the zero address");
480         require(spender != address(0), "ERC20: approve to the zero address");
481 
482         _allowances[owner][spender] = value;
483         emit Approval(owner, spender, value);
484     }
485 
486     /**
487      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
488      * from the caller's allowance.
489      *
490      * See `_burn` and `_approve`.
491      */
492     function _burnFrom(address account, uint256 amount) internal {
493         _burn(account, amount);
494         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
495     }
496 }
497 
498 // File: openzeppelin-solidity/contracts/access/Roles.sol
499 
500 pragma solidity ^0.5.0;
501 
502 /**
503  * @title Roles
504  * @dev Library for managing addresses assigned to a Role.
505  */
506 library Roles {
507     struct Role {
508         mapping (address => bool) bearer;
509     }
510 
511     /**
512      * @dev Give an account access to this role.
513      */
514     function add(Role storage role, address account) internal {
515         require(!has(role, account), "Roles: account already has role");
516         role.bearer[account] = true;
517     }
518 
519     /**
520      * @dev Remove an account's access to this role.
521      */
522     function remove(Role storage role, address account) internal {
523         require(has(role, account), "Roles: account does not have role");
524         role.bearer[account] = false;
525     }
526 
527     /**
528      * @dev Check if an account has this role.
529      * @return bool
530      */
531     function has(Role storage role, address account) internal view returns (bool) {
532         require(account != address(0), "Roles: account is the zero address");
533         return role.bearer[account];
534     }
535 }
536 
537 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
538 
539 pragma solidity ^0.5.0;
540 
541 
542 contract MinterRole {
543     using Roles for Roles.Role;
544 
545     event MinterAdded(address indexed account);
546     event MinterRemoved(address indexed account);
547 
548     Roles.Role private _minters;
549 
550     constructor () internal {
551         _addMinter(msg.sender);
552     }
553 
554     modifier onlyMinter() {
555         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
556         _;
557     }
558 
559     function isMinter(address account) public view returns (bool) {
560         return _minters.has(account);
561     }
562 
563     function addMinter(address account) public onlyMinter {
564         _addMinter(account);
565     }
566 
567     function renounceMinter() public {
568         _removeMinter(msg.sender);
569     }
570 
571     function _addMinter(address account) internal {
572         _minters.add(account);
573         emit MinterAdded(account);
574     }
575 
576     function _removeMinter(address account) internal {
577         _minters.remove(account);
578         emit MinterRemoved(account);
579     }
580 }
581 
582 // File: contracts/token/ERC20Interface.sol
583 
584 pragma solidity 0.5.9;
585 
586 
587 interface ERC20Interface {
588   // Standard ERC-20 interface.
589   function transfer(address to, uint256 value) external returns (bool);
590   function approve(address spender, uint256 value) external returns (bool);
591   function transferFrom(address from, address to, uint256 value) external returns (bool);
592   function totalSupply() external view returns (uint256);
593   function balanceOf(address who) external view returns (uint256);
594   function allowance(address owner, address spender) external view returns (uint256);
595   // Extension of ERC-20 interface to support supply adjustment.
596   function mint(address to, uint256 value) external returns (bool);
597   function burn(address from, uint256 value) external returns (bool);
598 }
599 
600 // File: contracts/token/ERC20Base.sol
601 
602 pragma solidity 0.5.9;
603 
604 
605 
606 
607 
608 /// "ERC20Base" is the standard ERC-20 implementation that allows its minter to mint tokens. Both BandToken and
609 /// CommunityToken extend from ERC20Base. In addition to the standard functions, the class provides `transferAndCall`
610 /// function, which performs a transfer and invokes the given function using the provided data. If the destination
611 /// contract uses "ERC20Acceptor" interface, it can verify that the caller properly sends appropriate amount of tokens.
612 contract ERC20Base is ERC20Interface, ERC20, MinterRole {
613   string public name;
614   string public symbol;
615   uint8 public decimals = 18;
616 
617   constructor(string memory _name, string memory _symbol) public {
618     name = _name;
619     symbol = _symbol;
620   }
621 
622   function transferAndCall(address to, uint256 value, bytes4 sig, bytes memory data) public returns (bool) {
623     require(to != address(this));
624     _transfer(msg.sender, to, value);
625     (bool success,) = to.call(abi.encodePacked(sig, uint256(msg.sender), value, data));
626     require(success);
627     return true;
628   }
629 
630   function mint(address to, uint256 value) public onlyMinter returns (bool) {
631     _mint(to, value);
632     return true;
633   }
634 
635   function burn(address from, uint256 value) public onlyMinter returns (bool) {
636     _burn(from, value);
637     return true;
638   }
639 }
640 
641 // File: contracts/token/SnapshotToken.sol
642 
643 pragma solidity 0.5.9;
644 
645 
646 
647 
648 contract SnapshotToken is ERC20Base {
649   using SafeMath for uint256;
650 
651   /// IMPORTANT: votingPowers are kept as a linked list of ALL historical changes.
652   /// - This allows the contract to figure out voting power of the address at any nonce `n`, by
653   /// searching for the node that has the biggest nonce that is not greater than `n`.
654   /// - For efficiency, nonce and power are packed into one uint256 integer, with the top 64 bits
655   /// representing nonce, and the bottom 192 bits representing voting power.
656   mapping (address => mapping(uint256 => uint256)) _votingPower;
657   mapping (address => uint256) public votingPowerChangeCount;
658   uint256 public votingPowerChangeNonce = 0;
659 
660   /// Returns user voting power at the given index, that is, as of the user's index^th voting power change
661   function historicalVotingPowerAtIndex(address owner, uint256 index) public view returns (uint256) {
662     require(index <= votingPowerChangeCount[owner]);
663     return _votingPower[owner][index] & ((1 << 192) - 1);  // Lower 192 bits
664   }
665 
666   /// Returns user voting power at the given time. Under the hood, this performs binary search
667   /// to look for the largest index at which the nonce is not greater than 'nonce'.
668   /// The voting power at that index is the returning value.
669   function historicalVotingPowerAtNonce(address owner, uint256 nonce) public view returns (uint256) {
670     require(nonce <= votingPowerChangeNonce && nonce < (1 << 64));
671     uint256 start = 0;
672     uint256 end = votingPowerChangeCount[owner];
673     while (start < end) {
674       uint256 mid = start.add(end).add(1).div(2); /// Use (start+end+1)/2 to prevent infinite loop.
675       if ((_votingPower[owner][mid] >> 192) > nonce) {  /// Upper 64-bit nonce
676         /// If midTime > nonce, this mid can't possibly be the answer.
677         end = mid.sub(1);
678       } else {
679         /// Otherwise, search on the greater side, but still keep mid as a possible option.
680         start = mid;
681       }
682     }
683     return historicalVotingPowerAtIndex(owner, start);
684   }
685 
686   function _transfer(address from, address to, uint256 value) internal {
687     super._transfer(from, to, value);
688     votingPowerChangeNonce = votingPowerChangeNonce.add(1);
689     _changeVotingPower(from);
690     _changeVotingPower(to);
691   }
692 
693   function _mint(address account, uint256 amount) internal {
694     super._mint(account, amount);
695     votingPowerChangeNonce = votingPowerChangeNonce.add(1);
696     _changeVotingPower(account);
697   }
698 
699   function _burn(address account, uint256 amount) internal {
700     super._burn(account, amount);
701     votingPowerChangeNonce = votingPowerChangeNonce.add(1);
702     _changeVotingPower(account);
703   }
704 
705   function _changeVotingPower(address account) internal {
706     uint256 currentIndex = votingPowerChangeCount[account];
707     uint256 newPower = balanceOf(account);
708     require(newPower < (1 << 192));
709     require(votingPowerChangeNonce < (1 << 64));
710     currentIndex = currentIndex.add(1);
711     votingPowerChangeCount[account] = currentIndex;
712     _votingPower[account][currentIndex] = (votingPowerChangeNonce << 192) | newPower;
713   }
714 }
715 
716 // File: contracts/BandToken.sol
717 
718 pragma solidity 0.5.9;
719 
720 
721 
722 
723 /// "BandToken" is the native ERC-20 token of Band Protocol.
724 contract BandToken is ERC20Base("BandToken", "BAND"), SnapshotToken {}
725 
726 // File: contracts/data/WhiteListInterface.sol
727 
728 pragma solidity 0.5.9;
729 
730 interface WhiteListInterface {
731   function verify(address reader) external view returns (bool);
732 }
733 
734 // File: contracts/exchange/BandExchangeInterface.sol
735 
736 pragma solidity 0.5.9;
737 
738 
739 interface BandExchangeInterface {
740   function convertFromEthToBand() external payable returns (uint256);
741 }
742 
743 // File: contracts/BandRegistry.sol
744 
745 pragma solidity 0.5.9;
746 
747 
748 
749 
750 
751 
752 /// "BandRegistry" keeps the addresses of three main smart contracts inside of Band Protocol ecosystem:
753 ///   1. "band" - Band Protocol's native ERC-20 token.
754 ///   2. "exchange" - Decentralized exchange for converting ETH to Band and vice versa.
755 ///   3. "whiteList" - Smart contract for validating non-malicious data consumers.
756 contract BandRegistry is Ownable {
757   BandToken public band;
758   BandExchangeInterface public exchange;
759   WhiteListInterface public whiteList;
760 
761   constructor(BandToken _band, BandExchangeInterface _exchange) public {
762     band = _band;
763     exchange = _exchange;
764   }
765 
766   function verify(address reader) public view returns (bool) {
767     if (address(whiteList) == address(0)) return true;
768     return whiteList.verify(reader);
769   }
770 
771   function setWhiteList(WhiteListInterface _whiteList) public onlyOwner {
772     whiteList = _whiteList;
773   }
774 
775   function setExchange(BandExchangeInterface _exchange) public onlyOwner {
776     exchange = _exchange;
777   }
778 }
779 
780 // File: contracts/data/QueryInterface.sol
781 
782 pragma solidity 0.5.9;
783 
784 
785 
786 /// "QueryInterface" provides the standard `query` method for querying Band Protocol's curated data. The function
787 /// makes sure that query callers are not blacklisted and pay appropriate fee, as specified by `queryPrice` prior
788 /// to calling the meat `queryImpl` function.
789 contract QueryInterface {
790   enum QueryStatus { INVALID, OK, NOT_AVAILABLE, DISAGREEMENT }
791   event Query(address indexed caller, bytes input, QueryStatus status);
792   BandRegistry public registry;
793 
794   constructor(BandRegistry _registry) public {
795     registry = _registry;
796   }
797 
798   function query(bytes calldata input)
799     external payable returns (bytes32 output, uint256 updatedAt, QueryStatus status)
800   {
801     require(registry.verify(msg.sender));
802     uint256 price = queryPrice();
803     require(msg.value >= price);
804     if (msg.value > price) msg.sender.transfer(msg.value - price);
805     (output, updatedAt, status) = queryImpl(input);
806     emit Query(msg.sender, input, status);
807   }
808 
809   function queryPrice() public view returns (uint256);
810   function queryImpl(bytes memory input)
811     internal returns (bytes32 output, uint256 updatedAt, QueryStatus status);
812 }
813 
814 // File: contracts/utils/Fractional.sol
815 
816 pragma solidity 0.5.9;
817 
818 
819 
820 /// "Fractional" library facilitate fixed point decimal computation. In Band Protocol, fixed point decimal can be
821 /// represented using `uint256` data type. The decimal is fixed at 18 digits and `mulFrac` can be used to multiply
822 /// the fixed point decimal with an ordinary `uint256` value.
823 library Fractional {
824   using SafeMath for uint256;
825   uint256 internal constant DENOMINATOR = 1e18;
826 
827   function getDenominator() internal pure returns (uint256) {
828     return DENOMINATOR;
829   }
830 
831   function mulFrac(uint256 numerator, uint256 value) internal pure returns(uint256) {
832     return numerator.mul(value).div(DENOMINATOR);
833   }
834 }
835 
836 // File: contracts/token/ERC20Acceptor.sol
837 
838 pragma solidity 0.5.9;
839 
840 
841 
842 /// "ERC20Acceptor" is a utility smart contract that provides `requireToken` modifier for any contract that intends
843 /// to have functions that accept ERC-20 token transfer to inherit.
844 contract ERC20Acceptor {
845   /// A modifer to decorate function that requires ERC-20 transfer. If called by ERC-20
846   /// contract, the modifier trusts that the transfer already occurs. Otherwise, the modifier
847   /// invokes 'transferFrom' to ensure that appropriate amount of tokens is paid properly.
848   modifier requireToken(ERC20Interface token, address sender, uint256 amount) {
849     if (msg.sender != address(token)) {
850       require(sender == msg.sender);
851       require(token.transferFrom(sender, address(this), amount));
852     }
853     _;
854   }
855 }
856 
857 // File: contracts/utils/Expression.sol
858 
859 pragma solidity 0.5.9;
860 
861 
862 interface Expression {
863   /// Return the result of evaluating the expression given a variable value
864   function evaluate(uint256 x) external view returns (uint256);
865 }
866 
867 // File: contracts/Parameters.sol
868 
869 pragma solidity 0.5.9;
870 
871 
872 
873 
874 
875 
876 /// "Parameters" contract controls how other smart contracts behave through a key-value mapping, which other contracts
877 /// will query using `get` or `getRaw` functions. Every dataset community has one governance parameters contract.
878 /// Additionally, there is one parameter contract that is controlled by BandToken for protocol-wide parameters.
879 /// Conducting parameter changes can be done through the following process.
880 ///   1. Anyone can propose for a change by sending a `propose` transaction, which will assign an ID to the proposal.
881 ///   2. While the proposal is open, token holders can vote for approval or rejection through `vote` function.
882 ///   3. After the voting period ends, if the proposal receives enough participation and support, it will get accepted.
883 ///      `resolve` function must to be called to trigger the decision process.
884 ///   4. Additionally, to facilitate unanimous parameter changes, a proposal is automatically resolved prior to its
885 ///      expiration if more than the required percentage of ALL tokens approve the proposal.
886 /// Parameters contract uses the following parameters for its internal logic. These parameters can be change via the
887 /// same proposal process.
888 ///   `params:expiration_time`: Number of seconds that a proposal stays open after getting proposed.
889 ///   `params:min_participation_pct`: % of tokens required to participate in order for a proposal to be considered.
890 ///   `params:support_required_pct`: % of participating tokens required to approve a proposal.
891 /// Parameters contract is "Ownable" initially to allow its owner to overrule the parameters during the initial
892 /// deployment as a measure against possible smart contract vulnerabilities. Owner can be set to 0x0 address afterwards.
893 contract Parameters is Ownable {
894   using SafeMath for uint256;
895   using Fractional for uint256;
896 
897   event ProposalProposed(uint256 indexed proposalId, address indexed proposer, bytes32 reasonHash);
898   event ProposalVoted(uint256 indexed proposalId, address indexed voter, bool vote, uint256 votingPower);
899   event ProposalAccepted(uint256 indexed proposalId);
900   event ProposalRejected(uint256 indexed proposalId);
901   event ParameterChanged(bytes32 indexed key, uint256 value);
902   event ParameterProposed(uint256 indexed proposalId, bytes32 indexed key, uint256 value);
903 
904   struct ParameterValue { bool existed; uint256 value; }
905   struct KeyValue { bytes32 key; uint256 value; }
906   enum ProposalState { INVALID, OPEN, ACCEPTED, REJECTED }
907 
908   struct Proposal {
909     uint256 changesCount;                   /// The number of parameter changes
910     mapping (uint256 => KeyValue) changes;  /// The list of parameter changes in proposal
911     uint256 snapshotNonce;                  /// The votingPowerNonce to count voting power
912     uint256 expirationTime;                 /// The time at which this proposal resolves
913     uint256 voteSupportRequiredPct;         /// Threshold % for determining proposal acceptance
914     uint256 voteMinParticipation;           /// The minimum # of votes required
915     uint256 totalVotingPower;               /// The total voting power at this snapshotNonce
916     uint256 yesCount;                       /// The current total number of YES votes
917     uint256 noCount;                        /// The current total number of NO votes
918     mapping (address => bool) isVoted;      /// Mapping for check who already voted
919     ProposalState proposalState;            /// Current state of this proposal.
920   }
921 
922   SnapshotToken public token;
923   Proposal[] public proposals;
924   mapping (bytes32 => ParameterValue) public params;
925 
926   constructor(SnapshotToken _token) public {
927     token = _token;
928   }
929 
930   function get(bytes8 namespace, bytes24 key) public view returns (uint256) {
931     uint8 namespaceSize = 0;
932     while (namespaceSize < 8 && namespace[namespaceSize] != byte(0)) ++namespaceSize;
933     return getRaw(bytes32(namespace) | (bytes32(key) >> (8 * namespaceSize)));
934   }
935 
936   function getRaw(bytes32 rawKey) public view returns (uint256) {
937     ParameterValue storage param = params[rawKey];
938     require(param.existed);
939     return param.value;
940   }
941 
942   function set(bytes8 namespace, bytes24[] memory keys, uint256[] memory values) public onlyOwner {
943     require(keys.length == values.length);
944     bytes32[] memory rawKeys = new bytes32[](keys.length);
945     uint8 namespaceSize = 0;
946     while (namespaceSize < 8 && namespace[namespaceSize] != byte(0)) ++namespaceSize;
947     for (uint256 i = 0; i < keys.length; i++) {
948       rawKeys[i] = bytes32(namespace) | bytes32(keys[i]) >> (8 * namespaceSize);
949     }
950     setRaw(rawKeys, values);
951   }
952 
953   function setRaw(bytes32[] memory rawKeys, uint256[] memory values) public onlyOwner {
954     require(rawKeys.length == values.length);
955     for (uint256 i = 0; i < rawKeys.length; i++) {
956       params[rawKeys[i]].existed = true;
957       params[rawKeys[i]].value = values[i];
958       emit ParameterChanged(rawKeys[i], values[i]);
959     }
960   }
961 
962   function getProposalChange(uint256 proposalId, uint256 changeIndex) public view returns (bytes32, uint256) {
963     KeyValue memory keyValue = proposals[proposalId].changes[changeIndex];
964     return (keyValue.key, keyValue.value);
965   }
966 
967   function propose(bytes32 reasonHash, bytes32[] calldata keys, uint256[] calldata values) external {
968     require(keys.length == values.length);
969     uint256 proposalId = proposals.length;
970     proposals.push(Proposal({
971       changesCount: keys.length,
972       snapshotNonce: token.votingPowerChangeNonce(),
973       expirationTime: now.add(getRaw("params:expiration_time")),
974       voteSupportRequiredPct: getRaw("params:support_required_pct"),
975       voteMinParticipation: getRaw("params:min_participation_pct").mulFrac(token.totalSupply()),
976       totalVotingPower: token.totalSupply(),
977       yesCount: 0,
978       noCount: 0,
979       proposalState: ProposalState.OPEN
980     }));
981     emit ProposalProposed(proposalId, msg.sender, reasonHash);
982     for (uint256 index = 0; index < keys.length; ++index) {
983       bytes32 key = keys[index];
984       uint256 value = values[index];
985       emit ParameterProposed(proposalId, key, value);
986       proposals[proposalId].changes[index] = KeyValue({key: key, value: value});
987     }
988   }
989 
990   function vote(uint256 proposalId, bool accepted) public {
991     Proposal storage proposal = proposals[proposalId];
992     require(proposal.proposalState == ProposalState.OPEN);
993     require(now < proposal.expirationTime);
994     require(!proposal.isVoted[msg.sender]);
995     uint256 votingPower = token.historicalVotingPowerAtNonce(msg.sender, proposal.snapshotNonce);
996     require(votingPower > 0);
997     if (accepted) {
998       proposal.yesCount = proposal.yesCount.add(votingPower);
999     } else {
1000       proposal.noCount = proposal.noCount.add(votingPower);
1001     }
1002     proposal.isVoted[msg.sender] = true;
1003     emit ProposalVoted(proposalId, msg.sender, accepted, votingPower);
1004     uint256 minVoteToAccept = proposal.voteSupportRequiredPct.mulFrac(proposal.totalVotingPower);
1005     uint256 minVoteToReject = proposal.totalVotingPower.sub(minVoteToAccept);
1006     if (proposal.yesCount >= minVoteToAccept) {
1007       _acceptProposal(proposalId);
1008     } else if (proposal.noCount > minVoteToReject) {
1009       _rejectProposal(proposalId);
1010     }
1011   }
1012 
1013   function resolve(uint256 proposalId) public {
1014     Proposal storage proposal = proposals[proposalId];
1015     require(proposal.proposalState == ProposalState.OPEN);
1016     require(now >= proposal.expirationTime);
1017     uint256 yesCount = proposal.yesCount;
1018     uint256 noCount = proposal.noCount;
1019     uint256 totalCount = yesCount.add(noCount);
1020     if (totalCount >= proposal.voteMinParticipation &&
1021         yesCount.mul(Fractional.getDenominator()) >= proposal.voteSupportRequiredPct.mul(totalCount)) {
1022       _acceptProposal(proposalId);
1023     } else {
1024       _rejectProposal(proposalId);
1025     }
1026   }
1027 
1028   function _acceptProposal(uint256 proposalId) internal {
1029     Proposal storage proposal = proposals[proposalId];
1030     proposal.proposalState = ProposalState.ACCEPTED;
1031     for (uint256 index = 0; index < proposal.changesCount; ++index) {
1032       bytes32 key = proposal.changes[index].key;
1033       uint256 value = proposal.changes[index].value;
1034       params[key].existed = true;
1035       params[key].value = value;
1036       emit ParameterChanged(key, value);
1037     }
1038     emit ProposalAccepted(proposalId);
1039   }
1040 
1041   function _rejectProposal(uint256 proposalId) internal {
1042     Proposal storage proposal = proposals[proposalId];
1043     proposal.proposalState = ProposalState.REJECTED;
1044     emit ProposalRejected(proposalId);
1045   }
1046 }
1047 
1048 // File: contracts/exchange/BondingCurve.sol
1049 
1050 pragma solidity 0.5.9;
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 
1059 contract BondingCurve is ERC20Acceptor {
1060   using SafeMath for uint256;
1061   using Fractional for uint256;
1062 
1063   event Buy(address indexed buyer, uint256 bondedTokenAmount, uint256 collateralTokenAmount);
1064   event Sell(address indexed seller, uint256 bondedTokenAmount, uint256 collateralTokenAmount);
1065   event Deflate(address indexed burner, uint256 burnedAmount);
1066   event RevenueCollect(address indexed beneficiary, uint256 bondedTokenAmount);
1067 
1068   ERC20Interface public collateralToken;
1069   ERC20Interface public bondedToken;
1070   Parameters public params;
1071 
1072   uint256 public currentMintedTokens;
1073   uint256 public currentCollateral;
1074   uint256 public lastInflationTime = now;
1075 
1076   constructor(ERC20Interface _collateralToken, ERC20Interface _bondedToken, Parameters _params) public {
1077     collateralToken = _collateralToken;
1078     bondedToken = _bondedToken;
1079     params = _params;
1080   }
1081 
1082   function getRevenueBeneficiary() public view returns (address) {
1083     address beneficiary = address(params.getRaw("bonding:revenue_beneficiary"));
1084     require(beneficiary != address(0));
1085     return beneficiary;
1086   }
1087 
1088   function getInflationRateNumerator() public view returns (uint256) {
1089     return params.getRaw("bonding:inflation_rate");
1090   }
1091 
1092   function getLiquiditySpreadNumerator() public view returns (uint256) {
1093     return params.getRaw("bonding:liquidity_spread");
1094   }
1095 
1096   function getCollateralExpression() public view returns (Expression) {
1097     return Expression(address(params.getRaw("bonding:curve_expression")));
1098   }
1099 
1100   function getCollateralAtSupply(uint256 tokenSupply) public view returns (uint256) {
1101     Expression collateralExpression = getCollateralExpression();
1102     uint256 collateralFromEquationAtCurrent = collateralExpression.evaluate(currentMintedTokens);
1103     uint256 collateralFromEquationAtSupply = collateralExpression.evaluate(tokenSupply);
1104     if (collateralFromEquationAtCurrent == 0) {
1105       return collateralFromEquationAtSupply;
1106     } else {
1107       return collateralFromEquationAtSupply.mul(currentCollateral).div(collateralFromEquationAtCurrent);
1108     }
1109   }
1110 
1111   function curveMultiplier() public view returns (uint256) {
1112     return currentCollateral.mul(Fractional.getDenominator()).div(getCollateralExpression().evaluate(currentMintedTokens));
1113   }
1114 
1115   function getBuyPrice(uint256 tokenValue) public view returns (uint256) {
1116     uint256 nextSupply = currentMintedTokens.add(tokenValue);
1117     return getCollateralAtSupply(nextSupply).sub(currentCollateral);
1118   }
1119 
1120   function getSellPrice(uint256 tokenValue) public view returns (uint256) {
1121     uint256 currentSupply = currentMintedTokens;
1122     require(currentSupply >= tokenValue);
1123     uint256 nextSupply = currentMintedTokens.sub(tokenValue);
1124     return currentCollateral.sub(getCollateralAtSupply(nextSupply));
1125   }
1126 
1127   modifier _adjustAutoInflation() {
1128     uint256 currentSupply = currentMintedTokens;
1129     if (lastInflationTime < now) {
1130       uint256 pastSeconds = now.sub(lastInflationTime);
1131       uint256 inflatingSupply = getInflationRateNumerator().mul(pastSeconds).mulFrac(currentSupply);
1132       if (inflatingSupply != 0) {
1133         currentMintedTokens = currentMintedTokens.add(inflatingSupply);
1134         _rewardBondingCurveOwner(inflatingSupply);
1135       }
1136     }
1137     lastInflationTime = now;
1138     _;
1139   }
1140 
1141   function buy(address buyer, uint256 priceLimit, uint256 buyAmount)
1142     public
1143     requireToken(collateralToken, buyer, priceLimit)
1144     _adjustAutoInflation
1145   {
1146     uint256 liquiditySpread = getLiquiditySpreadNumerator().mulFrac(buyAmount);
1147     uint256 totalMintAmount = buyAmount.add(liquiditySpread);
1148     uint256 buyPrice = getBuyPrice(totalMintAmount);
1149     require(buyPrice > 0 && buyPrice <= priceLimit);
1150     if (priceLimit > buyPrice) {
1151       require(collateralToken.transfer(buyer, priceLimit.sub(buyPrice)));
1152     }
1153     require(bondedToken.mint(buyer, buyAmount));
1154     if (liquiditySpread > 0) {
1155       _rewardBondingCurveOwner(liquiditySpread);
1156     }
1157     currentMintedTokens = currentMintedTokens.add(totalMintAmount);
1158     currentCollateral = currentCollateral.add(buyPrice);
1159     emit Buy(buyer, buyAmount, buyPrice);
1160   }
1161 
1162   function sell(address seller, uint256 sellAmount, uint256 priceLimit)
1163     public
1164     requireToken(bondedToken, seller, sellAmount)
1165     _adjustAutoInflation
1166   {
1167     uint256 sellPrice = getSellPrice(sellAmount);
1168     require(sellPrice > 0 && sellPrice >= priceLimit);
1169     require(bondedToken.burn(address(this), sellAmount));
1170     require(collateralToken.transfer(seller, sellPrice));
1171     currentMintedTokens = currentMintedTokens.sub(sellAmount);
1172     currentCollateral = currentCollateral.sub(sellPrice);
1173     emit Sell(seller, sellAmount, sellPrice);
1174   }
1175 
1176   function deflate(address burner, uint256 burnAmount) public requireToken(bondedToken, burner, burnAmount) {
1177     require(bondedToken.burn(address(this), burnAmount));
1178     currentMintedTokens = currentMintedTokens.sub(burnAmount);
1179     emit Deflate(burner, burnAmount);
1180   }
1181 
1182   function _rewardBondingCurveOwner(uint256 rewardAmount) internal {
1183     address beneficiary = getRevenueBeneficiary();
1184     require(bondedToken.mint(beneficiary, rewardAmount));
1185     emit RevenueCollect(beneficiary, rewardAmount);
1186   }
1187 }
1188 
1189 // File: openzeppelin-solidity/contracts/math/Math.sol
1190 
1191 pragma solidity ^0.5.0;
1192 
1193 /**
1194  * @dev Standard math utilities missing in the Solidity language.
1195  */
1196 library Math {
1197     /**
1198      * @dev Returns the largest of two numbers.
1199      */
1200     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1201         return a >= b ? a : b;
1202     }
1203 
1204     /**
1205      * @dev Returns the smallest of two numbers.
1206      */
1207     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1208         return a < b ? a : b;
1209     }
1210 
1211     /**
1212      * @dev Returns the average of two numbers. The result is rounded towards
1213      * zero.
1214      */
1215     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1216         // (a + b) / 2 can overflow, so we distribute
1217         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1218     }
1219 }
1220 
1221 // File: openzeppelin-solidity/contracts/access/roles/CapperRole.sol
1222 
1223 pragma solidity ^0.5.0;
1224 
1225 
1226 contract CapperRole {
1227     using Roles for Roles.Role;
1228 
1229     event CapperAdded(address indexed account);
1230     event CapperRemoved(address indexed account);
1231 
1232     Roles.Role private _cappers;
1233 
1234     constructor () internal {
1235         _addCapper(msg.sender);
1236     }
1237 
1238     modifier onlyCapper() {
1239         require(isCapper(msg.sender), "CapperRole: caller does not have the Capper role");
1240         _;
1241     }
1242 
1243     function isCapper(address account) public view returns (bool) {
1244         return _cappers.has(account);
1245     }
1246 
1247     function addCapper(address account) public onlyCapper {
1248         _addCapper(account);
1249     }
1250 
1251     function renounceCapper() public {
1252         _removeCapper(msg.sender);
1253     }
1254 
1255     function _addCapper(address account) internal {
1256         _cappers.add(account);
1257         emit CapperAdded(account);
1258     }
1259 
1260     function _removeCapper(address account) internal {
1261         _cappers.remove(account);
1262         emit CapperRemoved(account);
1263     }
1264 }
1265 
1266 // File: contracts/token/LockableToken.sol
1267 
1268 pragma solidity 0.5.9;
1269 
1270 
1271 
1272 
1273 
1274 
1275 /// "LockableToken" adds token locking functionality to ERC-20 smart contract. The authorized addresses (Cappers) are
1276 /// allowed to lock tokens from any token holder to prevent token transfers up to that amount. If a token holder is
1277 /// locked by multiple cappers, the maximum number is used as the amount of locked tokens.
1278 contract LockableToken is ERC20Base, CapperRole {
1279   using SafeMath for uint256;
1280 
1281   event TokenLocked(address indexed locker, address indexed owner, uint256 value);
1282   event TokenUnlocked(address indexed locker, address indexed owner, uint256 value);
1283 
1284   uint256 constant NOT_FOUND = uint256(-1);
1285 
1286   struct TokenLock {
1287     address locker;
1288     uint256 value;
1289   }
1290 
1291   mapping (address => TokenLock[]) _locks;
1292 
1293   function getLockedToken(address owner) public view returns (uint256) {
1294     TokenLock[] storage locks = _locks[owner];
1295     uint256 maxLock = 0;
1296     for (uint256 i = 0; i < locks.length; ++i) {
1297       maxLock = Math.max(maxLock, locks[i].value);
1298     }
1299     return maxLock;
1300   }
1301 
1302   function getLockedTokenAt(address owner, address locker) public view returns (uint256) {
1303     uint256 index = _getTokenLockIndex(owner, locker);
1304     if (index != NOT_FOUND) return _locks[owner][index].value;
1305     else return 0;
1306   }
1307 
1308   function unlockedBalanceOf(address owner) public view returns (uint256) {
1309     return balanceOf(owner).sub(getLockedToken(owner));
1310   }
1311 
1312   function lock(address owner, uint256 value) public onlyCapper returns (bool) {
1313     uint256 index = _getTokenLockIndex(owner, msg.sender);
1314     if (index != NOT_FOUND) {
1315       uint256 currentLock = _locks[owner][index].value;
1316       require(balanceOf(owner) >= currentLock.add(value));
1317       _locks[owner][index].value = currentLock.add(value);
1318     } else {
1319       require(balanceOf(owner) >= value);
1320       _locks[owner].push(TokenLock(msg.sender, value));
1321     }
1322     emit TokenLocked(msg.sender, owner, value);
1323     return true;
1324   }
1325 
1326   function unlock(address owner, uint256 value) public returns (bool) {
1327     uint256 index = _getTokenLockIndex(owner, msg.sender);
1328     require(index != NOT_FOUND);
1329     TokenLock[] storage locks = _locks[owner];
1330     require(locks[index].value >= value);
1331     locks[index].value = locks[index].value.sub(value);
1332     if (locks[index].value == 0) {
1333       if (index != locks.length - 1) {
1334         locks[index] = locks[locks.length - 1];
1335       }
1336       locks.pop();
1337     }
1338     emit TokenUnlocked(msg.sender, owner, value);
1339     return true;
1340   }
1341 
1342   function _getTokenLockIndex(address owner, address locker) internal view returns (uint256) {
1343     TokenLock[] storage locks = _locks[owner];
1344     for (uint256 i = 0; i < locks.length; ++i) {
1345       if (locks[i].locker == locker) return i;
1346     }
1347     return NOT_FOUND;
1348   }
1349 
1350   function _transfer(address from, address to, uint256 value) internal {
1351     require(unlockedBalanceOf(from) >= value);
1352     super._transfer(from, to, value);
1353   }
1354 
1355   function _burn(address account, uint256 value) internal {
1356     require(unlockedBalanceOf(account) >= value);
1357     super._burn(account, value);
1358   }
1359 }
1360 
1361 // File: contracts/data/TCDBase.sol
1362 
1363 pragma solidity 0.5.9;
1364 
1365 
1366 
1367 
1368 
1369 
1370 
1371 
1372 /// "TCDBase" is the base class for Band Protocol's Token-Curated DataSources implementation. The contract essentially
1373 /// keeps track of a sorted list of trusted data sources, based on the total amount of token stake the data sources
1374 /// have. Any one can apply for a new data source using `register` function. Token holders can `stake` or `unstake`
1375 /// for any existing data sources. This class is abstract, so it needs to be extended by a subclass that utilizes
1376 /// the list of active data sources (See AggTCD and MultiSigTCD). Fees are collected in ETH and are converted to
1377 /// dataset tokens during `distributeFee` function call.
1378 contract TCDBase is QueryInterface {
1379   using Fractional for uint256;
1380   using SafeMath for uint256;
1381 
1382   event DataSourceRegistered(address indexed dataSource, address indexed owner, uint256 stake);
1383   event DataSourceStaked(address indexed dataSource, address indexed participant, uint256 stake);
1384   event DataSourceUnstaked(address indexed dataSource, address indexed participant, uint256 unstake);
1385   event FeeDistributed(address indexed dataSource, uint256 totalReward, uint256 ownerReward);
1386   event WithdrawReceiptCreated(uint256 receiptIndex, address indexed owner, uint256 amount, uint64 withdrawTime);
1387   event WithdrawReceiptUnlocked(uint256 receiptIndex, address indexed owner, uint256 amount);
1388 
1389   enum Order {EQ, LT, GT}
1390 
1391   struct DataSourceInfo {
1392     address owner;
1393     uint256 stake;
1394     uint256 totalOwnerships;
1395     mapping (address => uint256) tokenLocks;
1396     mapping (address => uint256) ownerships;
1397   }
1398 
1399   struct WithdrawReceipt {
1400     address owner;
1401     uint256 amount;
1402     uint64 withdrawTime;
1403     bool isWithdrawn;
1404   }
1405 
1406   mapping (address => DataSourceInfo) public infoMap;
1407   mapping (address => address) activeList;
1408   mapping (address => address) reserveList;
1409   uint256 public activeCount;
1410   uint256 public reserveCount;
1411 
1412   address constant internal NOT_FOUND = address(0x00);
1413   address constant internal ACTIVE_GUARD = address(0x01);
1414   address constant internal RESERVE_GUARD = address(0x02);
1415   WithdrawReceipt[] public withdrawReceipts;
1416 
1417   BondingCurve public bondingCurve;
1418   Parameters public params;
1419   LockableToken public token;
1420   uint256 public undistributedReward;
1421   bytes8 public prefix;
1422 
1423   constructor(bytes8 _prefix, BondingCurve _bondingCurve, Parameters _params, BandRegistry _registry) public QueryInterface(_registry) {
1424     bondingCurve = _bondingCurve;
1425     params = _params;
1426     prefix = _prefix;
1427     token = LockableToken(address(_bondingCurve.bondedToken()));
1428     _registry.band().approve(address(_bondingCurve), 2 ** 256 - 1);
1429     activeList[ACTIVE_GUARD] = ACTIVE_GUARD;
1430     reserveList[RESERVE_GUARD] = RESERVE_GUARD;
1431   }
1432 
1433   function getOwnership(address dataSource, address staker) public view returns (uint256) {
1434     return infoMap[dataSource].ownerships[staker];
1435   }
1436 
1437   function getStake(address dataSource, address staker) public view returns (uint256) {
1438     DataSourceInfo storage provider = infoMap[dataSource];
1439     if (provider.totalOwnerships == 0) return 0;
1440     return provider.ownerships[staker].mul(provider.stake).div(provider.totalOwnerships);
1441   }
1442 
1443   function register(address dataSource, address prevDataSource, uint256 initialStake) public {
1444     require(dataSource != NOT_FOUND && dataSource != ACTIVE_GUARD && dataSource != RESERVE_GUARD);
1445     require(infoMap[dataSource].totalOwnerships == 0);
1446     require(initialStake > 0 && initialStake >= params.get(prefix, "min_provider_stake"));
1447     require(token.lock(msg.sender, initialStake));
1448     infoMap[dataSource] = DataSourceInfo({
1449       owner: msg.sender,
1450       stake: initialStake,
1451       totalOwnerships: initialStake
1452     });
1453     infoMap[dataSource].ownerships[msg.sender] = initialStake;
1454     infoMap[dataSource].tokenLocks[msg.sender] = initialStake;
1455     emit DataSourceRegistered(dataSource, msg.sender, initialStake);
1456     _addDataSource(dataSource, prevDataSource);
1457     _rebalanceLists();
1458   }
1459 
1460   function stake(address dataSource, address prevDataSource, address newPrevDataSource, uint256 value) public {
1461     require(token.lock(msg.sender, value));
1462     _removeDataSource(dataSource, prevDataSource);
1463     DataSourceInfo storage provider = infoMap[dataSource];
1464     uint256 newStakerTokenLock = provider.tokenLocks[msg.sender].add(value);
1465     provider.tokenLocks[msg.sender] = newStakerTokenLock;
1466     _stake(msg.sender, value, dataSource);
1467     if (getStake(dataSource, provider.owner) >= params.get(prefix, "min_provider_stake")) {
1468       _addDataSource(dataSource, newPrevDataSource);
1469     }
1470     _rebalanceLists();
1471   }
1472 
1473   function unstake(address dataSource, address prevDataSource, address newPrevDataSource, uint256 withdrawOwnership) public {
1474     DataSourceInfo storage provider = infoMap[dataSource];
1475     require(withdrawOwnership <= provider.ownerships[msg.sender]);
1476     _removeDataSource(dataSource, prevDataSource);
1477     uint256 newOwnership = provider.totalOwnerships.sub(withdrawOwnership);
1478     uint256 currentStakerStake = getStake(dataSource, msg.sender);
1479     if (currentStakerStake > provider.tokenLocks[msg.sender]) {
1480       uint256 unrealizedStake = currentStakerStake.sub(provider.tokenLocks[msg.sender]);
1481       require(token.transfer(msg.sender, unrealizedStake));
1482       require(token.lock(msg.sender, unrealizedStake));
1483     }
1484     uint256 withdrawAmount = provider.stake.mul(withdrawOwnership).div(provider.totalOwnerships);
1485     uint256 newStake = provider.stake.sub(withdrawAmount);
1486     uint256 newStakerTokenLock = currentStakerStake.sub(withdrawAmount);
1487     uint256 newStakerOwnership = provider.ownerships[msg.sender].sub(withdrawOwnership);
1488     provider.stake = newStake;
1489     provider.totalOwnerships = newOwnership;
1490     provider.ownerships[msg.sender] = newStakerOwnership;
1491     provider.tokenLocks[msg.sender] = newStakerTokenLock;
1492     uint256 delay;
1493     if (msg.sender == provider.owner && (delay = params.get(prefix, "withdraw_delay")) > 0) {
1494       uint256 withdrawTime = now.add(delay);
1495       require(withdrawTime < (1 << 64));
1496       withdrawReceipts.push(WithdrawReceipt({
1497         owner: provider.owner,
1498         amount: withdrawAmount,
1499         withdrawTime: uint64(withdrawTime),
1500         isWithdrawn: false
1501       }));
1502       emit WithdrawReceiptCreated(withdrawReceipts.length - 1, provider.owner, withdrawAmount, uint64(withdrawTime));
1503     } else {
1504       require(token.unlock(msg.sender, withdrawAmount));
1505     }
1506     emit DataSourceUnstaked(dataSource, msg.sender, withdrawAmount);
1507     if (getStake(dataSource, provider.owner) >= params.get(prefix, "min_provider_stake")) {
1508       _addDataSource(dataSource, newPrevDataSource);
1509     }
1510     _rebalanceLists();
1511   }
1512 
1513   function addETHFee() public payable {}
1514 
1515   function addTokenFee(uint256 tokenAmount) public {
1516     token.transferFrom(msg.sender, address(this), tokenAmount);
1517     undistributedReward = undistributedReward.add(tokenAmount);
1518   }
1519 
1520   function distributeFee(uint256 tokenAmount) public {
1521     require(address(this).balance > 0);
1522     registry.exchange().convertFromEthToBand.value(address(this).balance)();
1523     bondingCurve.buy(address(this), registry.band().balanceOf(address(this)), tokenAmount);
1524     undistributedReward = undistributedReward.add(tokenAmount);
1525     uint256 providerReward = undistributedReward.div(activeCount);
1526     uint256 ownerPercentage = params.get(prefix, "owner_revenue_pct");
1527     uint256 ownerReward = ownerPercentage.mulFrac(providerReward);
1528     uint256 stakeIncreased = providerReward.sub(ownerReward);
1529     address dataSourceAddress = activeList[ACTIVE_GUARD];
1530     while (dataSourceAddress != ACTIVE_GUARD) {
1531       DataSourceInfo storage provider = infoMap[dataSourceAddress];
1532       provider.stake = provider.stake.add(stakeIncreased);
1533       if (ownerReward > 0) _stake(provider.owner, ownerReward, dataSourceAddress);
1534       undistributedReward = undistributedReward.sub(providerReward);
1535       emit FeeDistributed(dataSourceAddress, providerReward, ownerReward);
1536       dataSourceAddress = activeList[dataSourceAddress];
1537     }
1538   }
1539 
1540   function distributeStakeReward(uint256 tokenAmount) public {
1541     token.transferFrom(msg.sender, address(this), tokenAmount);
1542     uint256 remainingReward = tokenAmount;
1543     uint256 stakeReward = tokenAmount.div(activeCount);
1544     address dataSourceAddress = activeList[ACTIVE_GUARD];
1545     while (dataSourceAddress != ACTIVE_GUARD) {
1546       DataSourceInfo storage provider = infoMap[dataSourceAddress];
1547       provider.stake = provider.stake.add(stakeReward);
1548       remainingReward = remainingReward.sub(stakeReward);
1549       emit FeeDistributed(dataSourceAddress, stakeReward, 0);
1550       dataSourceAddress = activeList[dataSourceAddress];
1551     }
1552     undistributedReward = undistributedReward.add(remainingReward);
1553   }
1554 
1555   function unlockTokenFromReceipt(uint256 receiptId) public {
1556     WithdrawReceipt storage receipt = withdrawReceipts[receiptId];
1557     require(!receipt.isWithdrawn && now >= receipt.withdrawTime);
1558     receipt.isWithdrawn = true;
1559     require(token.unlock(receipt.owner, receipt.amount));
1560     emit WithdrawReceiptUnlocked(receiptId, receipt.owner, receipt.amount);
1561   }
1562 
1563   function _stake(address staker, uint256 value, address dataSource) internal {
1564     DataSourceInfo storage provider = infoMap[dataSource];
1565     require(provider.totalOwnerships > 0);
1566     uint256 newStake = provider.stake.add(value);
1567     uint256 newtotalOwnerships = newStake.mul(provider.totalOwnerships).div(provider.stake);
1568     uint256 newStakerOwnership = provider.ownerships[staker].add(newtotalOwnerships.sub(provider.totalOwnerships));
1569     provider.ownerships[staker] = newStakerOwnership;
1570     provider.stake = newStake;
1571     provider.totalOwnerships = newtotalOwnerships;
1572     emit DataSourceStaked(dataSource, staker, value);
1573   }
1574 
1575   function _compare(address dataSourceLeft, address dataSourceRight) internal view returns (Order) {
1576     if (dataSourceLeft == dataSourceRight) return Order.EQ;
1577     DataSourceInfo storage leftProvider = infoMap[dataSourceLeft];
1578     DataSourceInfo storage rightProvider = infoMap[dataSourceRight];
1579     if (leftProvider.stake != rightProvider.stake) return leftProvider.stake < rightProvider.stake ? Order.LT : Order.GT;
1580     return uint256(dataSourceLeft) < uint256(dataSourceRight) ? Order.LT : Order.GT; /// Arbitrary tie-breaker
1581   }
1582 
1583   function _findPrevDataSource(address dataSource) internal view returns (address) {
1584     if (activeCount != 0 && _compare(dataSource, activeList[ACTIVE_GUARD]) != Order.LT) {
1585       address currentIndex = ACTIVE_GUARD;
1586       while (activeList[currentIndex] != ACTIVE_GUARD) {
1587         address nextIndex = activeList[currentIndex];
1588         if (_compare(dataSource, nextIndex) == Order.GT) currentIndex = nextIndex;
1589         else break;
1590       }
1591       return currentIndex;
1592     } else if (reserveCount != 0) {
1593       address currentIndex = RESERVE_GUARD;
1594       while (reserveList[currentIndex] != RESERVE_GUARD) {
1595         address nextIndex = reserveList[currentIndex];
1596         if (_compare(dataSource, nextIndex) == Order.LT) currentIndex = nextIndex;
1597         else break;
1598       }
1599       return currentIndex;
1600     } else {
1601       return RESERVE_GUARD;
1602     }
1603   }
1604 
1605   function _addDataSource(address dataSource, address _prevDataSource) internal {
1606     address prevDataSource = _prevDataSource == NOT_FOUND ? _findPrevDataSource(dataSource) : _prevDataSource;
1607     if (activeList[prevDataSource] != NOT_FOUND) {
1608       if (prevDataSource == ACTIVE_GUARD) require(reserveCount == 0 || _compare(dataSource, reserveList[RESERVE_GUARD]) == Order.GT);
1609       else require(_compare(dataSource, prevDataSource) == Order.GT);
1610       require(activeList[prevDataSource] == ACTIVE_GUARD || _compare(activeList[prevDataSource], dataSource) == Order.GT);
1611       activeList[dataSource] = activeList[prevDataSource];
1612       activeList[prevDataSource] = dataSource;
1613       activeCount++;
1614     } else if (reserveList[prevDataSource] != NOT_FOUND) {
1615       if (prevDataSource == RESERVE_GUARD) require(activeCount == 0 || _compare(activeList[ACTIVE_GUARD], dataSource) == Order.GT);
1616       else require(_compare(prevDataSource, dataSource) == Order.GT);
1617       require(reserveList[prevDataSource] == RESERVE_GUARD || _compare(dataSource, reserveList[prevDataSource]) == Order.GT);
1618       reserveList[dataSource] = reserveList[prevDataSource];
1619       reserveList[prevDataSource] = dataSource;
1620       reserveCount++;
1621     } else {
1622       revert();
1623     }
1624   }
1625 
1626   function _removeDataSource(address dataSource, address _prevDataSource) internal {
1627     if (activeList[dataSource] == NOT_FOUND && reserveList[dataSource] == NOT_FOUND) return;
1628     address prevDataSource = _prevDataSource == NOT_FOUND ? _findPrevDataSource(dataSource) : _prevDataSource;
1629     if (activeList[prevDataSource] != NOT_FOUND) {
1630       require(dataSource != ACTIVE_GUARD);
1631       require(activeList[prevDataSource] == dataSource);
1632       activeList[prevDataSource] = activeList[dataSource];
1633       activeList[dataSource] = NOT_FOUND;
1634       activeCount--;
1635     } else if (reserveList[prevDataSource] != NOT_FOUND) {
1636       require(dataSource != RESERVE_GUARD);
1637       require(reserveList[prevDataSource] == dataSource);
1638       reserveList[prevDataSource] = reserveList[dataSource];
1639       reserveList[dataSource] = NOT_FOUND;
1640       reserveCount--;
1641     }
1642   }
1643 
1644   function _rebalanceLists() internal {
1645     uint256 maxProviderCount = params.get(prefix, "max_provider_count");
1646     while (activeCount < maxProviderCount && reserveCount > 0) {
1647       address dataSource = reserveList[RESERVE_GUARD];
1648       _removeDataSource(dataSource, RESERVE_GUARD);
1649       _addDataSource(dataSource, ACTIVE_GUARD);
1650     }
1651     while (activeCount > maxProviderCount) {
1652       address dataSource = activeList[ACTIVE_GUARD];
1653       _removeDataSource(dataSource, ACTIVE_GUARD);
1654       _addDataSource(dataSource, RESERVE_GUARD);
1655     }
1656   }
1657 }
1658 
1659 // File: contracts/data/OffchainAggTCD.sol
1660 
1661 pragma solidity 0.5.9;
1662 
1663 
1664 
1665 
1666 /// "OffchainAggTCD" is a TCD that curates a list of trusted addresses. Data points from all reporters are aggregated
1667 /// off-chain and reported using `report` function with ECDSA signatures. Data providers are responsible for combining
1668 /// data points into one aggregated value together with timestamp and status, which will be reported to this contract.
1669 contract OffchainAggTCD is TCDBase {
1670   using SafeMath for uint256;
1671 
1672   event DataUpdated(bytes key, uint256 value, uint64 timestamp, QueryStatus status);
1673 
1674   struct DataPoint {
1675     uint256 value;
1676     uint64 timestamp;
1677     QueryStatus status;
1678   }
1679 
1680   mapping (bytes => DataPoint) private aggData;
1681 
1682   constructor(bytes8 _prefix, BondingCurve _bondingCurve, Parameters _params, BandRegistry _registry)
1683     public TCDBase(_prefix, _bondingCurve, _params, _registry) {}
1684 
1685   function queryPrice() public view returns (uint256) {
1686     return params.get(prefix, "query_price");
1687   }
1688 
1689   function report(
1690     bytes calldata key, uint256 value, uint64 timestamp, QueryStatus status,
1691     uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s
1692   ) external {
1693     require(v.length == r.length && v.length == s.length);
1694     uint256 validSignatures = 0;
1695     bytes32 message = keccak256(abi.encodePacked(
1696       "\x19Ethereum Signed Message:\n32",
1697       keccak256(abi.encodePacked(key, value, timestamp, status, address(this))))
1698     );
1699     address lastSigner = address(0);
1700     for (uint256 i = 0; i < v.length; ++i) {
1701       address recovered = ecrecover(message, v[i], r[i], s[i]);
1702       require(recovered > lastSigner);
1703       lastSigner = recovered;
1704       if (activeList[recovered] != NOT_FOUND) {
1705         validSignatures++;
1706       }
1707     }
1708     require(validSignatures.mul(3) > activeCount.mul(2));
1709     require(timestamp > aggData[key].timestamp && uint256(timestamp) <= now);
1710     aggData[key] = DataPoint({
1711       value: value,
1712       timestamp: timestamp,
1713       status: status
1714     });
1715     emit DataUpdated(key, value, timestamp, status);
1716   }
1717 
1718   function queryImpl(bytes memory input) internal returns (bytes32 output, uint256 updatedAt, QueryStatus status) {
1719     DataPoint storage data = aggData[input];
1720     if (data.timestamp == 0) return ("", 0, QueryStatus.NOT_AVAILABLE);
1721     if (data.status != QueryStatus.OK) return ("", data.timestamp, data.status);
1722     return (bytes32(data.value), data.timestamp, QueryStatus.OK);
1723   }
1724 }