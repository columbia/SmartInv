1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
110 
111 pragma solidity >=0.6.0 <0.8.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         uint256 c = a + b;
134         if (c < a) return (false, 0);
135         return (true, c);
136     }
137 
138     /**
139      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
140      *
141      * _Available since v3.4._
142      */
143     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         if (b > a) return (false, 0);
145         return (true, a - b);
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) return (true, 0);
158         uint256 c = a * b;
159         if (c / a != b) return (false, 0);
160         return (true, c);
161     }
162 
163     /**
164      * @dev Returns the division of two unsigned integers, with a division by zero flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         if (b == 0) return (false, 0);
170         return (true, a / b);
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
175      *
176      * _Available since v3.4._
177      */
178     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         if (b == 0) return (false, 0);
180         return (true, a % b);
181     }
182 
183     /**
184      * @dev Returns the addition of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `+` operator.
188      *
189      * Requirements:
190      *
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196         return c;
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         require(b <= a, "SafeMath: subtraction overflow");
211         return a - b;
212     }
213 
214     /**
215      * @dev Returns the multiplication of two unsigned integers, reverting on
216      * overflow.
217      *
218      * Counterpart to Solidity's `*` operator.
219      *
220      * Requirements:
221      *
222      * - Multiplication cannot overflow.
223      */
224     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
225         if (a == 0) return 0;
226         uint256 c = a * b;
227         require(c / a == b, "SafeMath: multiplication overflow");
228         return c;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers, reverting on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         require(b > 0, "SafeMath: division by zero");
245         return a / b;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * reverting when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         require(b > 0, "SafeMath: modulo by zero");
262         return a % b;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * CAUTION: This function is deprecated because it requires allocating memory for the error
270      * message unnecessarily. For custom revert reasons use {trySub}.
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b <= a, errorMessage);
280         return a - b;
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
285      * division by zero. The result is rounded towards zero.
286      *
287      * CAUTION: This function is deprecated because it requires allocating memory for the error
288      * message unnecessarily. For custom revert reasons use {tryDiv}.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b > 0, errorMessage);
300         return a / b;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * reverting with custom message when dividing by zero.
306      *
307      * CAUTION: This function is deprecated because it requires allocating memory for the error
308      * message unnecessarily. For custom revert reasons use {tryMod}.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b > 0, errorMessage);
320         return a % b;
321     }
322 }
323 
324 
325 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
326 
327 pragma solidity >=0.6.0 <0.8.0;
328 
329 
330 
331 /**
332  * @dev Implementation of the {IERC20} interface.
333  *
334  * This implementation is agnostic to the way tokens are created. This means
335  * that a supply mechanism has to be added in a derived contract using {_mint}.
336  * For a generic mechanism see {ERC20PresetMinterPauser}.
337  *
338  * TIP: For a detailed writeup see our guide
339  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
340  * to implement supply mechanisms].
341  *
342  * We have followed general OpenZeppelin guidelines: functions revert instead
343  * of returning `false` on failure. This behavior is nonetheless conventional
344  * and does not conflict with the expectations of ERC20 applications.
345  *
346  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
347  * This allows applications to reconstruct the allowance for all accounts just
348  * by listening to said events. Other implementations of the EIP may not emit
349  * these events, as it isn't required by the specification.
350  *
351  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
352  * functions have been added to mitigate the well-known issues around setting
353  * allowances. See {IERC20-approve}.
354  */
355 contract ERC20 is Context, IERC20 {
356     using SafeMath for uint256;
357 
358     mapping (address => uint256) private _balances;
359 
360     mapping (address => mapping (address => uint256)) private _allowances;
361 
362     uint256 private _totalSupply;
363 
364     string private _name;
365     string private _symbol;
366     uint8 private _decimals;
367 
368     /**
369      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
370      * a default value of 18.
371      *
372      * To select a different value for {decimals}, use {_setupDecimals}.
373      *
374      * All three of these values are immutable: they can only be set once during
375      * construction.
376      */
377     constructor (string memory name_, string memory symbol_) public {
378         _name = name_;
379         _symbol = symbol_;
380         _decimals = 18;
381     }
382 
383     /**
384      * @dev Returns the name of the token.
385      */
386     function name() public view virtual returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @dev Returns the symbol of the token, usually a shorter version of the
392      * name.
393      */
394     function symbol() public view virtual returns (string memory) {
395         return _symbol;
396     }
397 
398     /**
399      * @dev Returns the number of decimals used to get its user representation.
400      * For example, if `decimals` equals `2`, a balance of `505` tokens should
401      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
402      *
403      * Tokens usually opt for a value of 18, imitating the relationship between
404      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
405      * called.
406      *
407      * NOTE: This information is only used for _display_ purposes: it in
408      * no way affects any of the arithmetic of the contract, including
409      * {IERC20-balanceOf} and {IERC20-transfer}.
410      */
411     function decimals() public view virtual returns (uint8) {
412         return _decimals;
413     }
414 
415     /**
416      * @dev See {IERC20-totalSupply}.
417      */
418     function totalSupply() public view virtual override returns (uint256) {
419         return _totalSupply;
420     }
421 
422     /**
423      * @dev See {IERC20-balanceOf}.
424      */
425     function balanceOf(address account) public view virtual override returns (uint256) {
426         return _balances[account];
427     }
428 
429     /**
430      * @dev See {IERC20-transfer}.
431      *
432      * Requirements:
433      *
434      * - `recipient` cannot be the zero address.
435      * - the caller must have a balance of at least `amount`.
436      */
437     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
438         _transfer(_msgSender(), recipient, amount);
439         return true;
440     }
441 
442     /**
443      * @dev See {IERC20-allowance}.
444      */
445     function allowance(address owner, address spender) public view virtual override returns (uint256) {
446         return _allowances[owner][spender];
447     }
448 
449     /**
450      * @dev See {IERC20-approve}.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      */
456     function approve(address spender, uint256 amount) public virtual override returns (bool) {
457         _approve(_msgSender(), spender, amount);
458         return true;
459     }
460 
461     /**
462      * @dev See {IERC20-transferFrom}.
463      *
464      * Emits an {Approval} event indicating the updated allowance. This is not
465      * required by the EIP. See the note at the beginning of {ERC20}.
466      *
467      * Requirements:
468      *
469      * - `sender` and `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      * - the caller must have allowance for ``sender``'s tokens of at least
472      * `amount`.
473      */
474     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
475         _transfer(sender, recipient, amount);
476         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
477         return true;
478     }
479 
480     /**
481      * @dev Atomically increases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496 
497     /**
498      * @dev Atomically decreases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `spender` must have allowance for the caller of at least
509      * `subtractedValue`.
510      */
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
513         return true;
514     }
515 
516     /**
517      * @dev Moves tokens `amount` from `sender` to `recipient`.
518      *
519      * This is internal function is equivalent to {transfer}, and can be used to
520      * e.g. implement automatic token fees, slashing mechanisms, etc.
521      *
522      * Emits a {Transfer} event.
523      *
524      * Requirements:
525      *
526      * - `sender` cannot be the zero address.
527      * - `recipient` cannot be the zero address.
528      * - `sender` must have a balance of at least `amount`.
529      */
530     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
531         require(sender != address(0), "ERC20: transfer from the zero address");
532         require(recipient != address(0), "ERC20: transfer to the zero address");
533 
534         _beforeTokenTransfer(sender, recipient, amount);
535 
536         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
537         _balances[recipient] = _balances[recipient].add(amount);
538         emit Transfer(sender, recipient, amount);
539     }
540 
541     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
542      * the total supply.
543      *
544      * Emits a {Transfer} event with `from` set to the zero address.
545      *
546      * Requirements:
547      *
548      * - `to` cannot be the zero address.
549      */
550     function _mint(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: mint to the zero address");
552 
553         _beforeTokenTransfer(address(0), account, amount);
554 
555         _totalSupply = _totalSupply.add(amount);
556         _balances[account] = _balances[account].add(amount);
557         emit Transfer(address(0), account, amount);
558     }
559 
560     /**
561      * @dev Destroys `amount` tokens from `account`, reducing the
562      * total supply.
563      *
564      * Emits a {Transfer} event with `to` set to the zero address.
565      *
566      * Requirements:
567      *
568      * - `account` cannot be the zero address.
569      * - `account` must have at least `amount` tokens.
570      */
571     function _burn(address account, uint256 amount) internal virtual {
572         require(account != address(0), "ERC20: burn from the zero address");
573 
574         _beforeTokenTransfer(account, address(0), amount);
575 
576         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
577         _totalSupply = _totalSupply.sub(amount);
578         emit Transfer(account, address(0), amount);
579     }
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
583      *
584      * This internal function is equivalent to `approve`, and can be used to
585      * e.g. set automatic allowances for certain subsystems, etc.
586      *
587      * Emits an {Approval} event.
588      *
589      * Requirements:
590      *
591      * - `owner` cannot be the zero address.
592      * - `spender` cannot be the zero address.
593      */
594     function _approve(address owner, address spender, uint256 amount) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     /**
603      * @dev Sets {decimals} to a value other than the default one of 18.
604      *
605      * WARNING: This function should only be called from the constructor. Most
606      * applications that interact with token contracts will not expect
607      * {decimals} to ever change, and may work incorrectly if it does.
608      */
609     function _setupDecimals(uint8 decimals_) internal virtual {
610         _decimals = decimals_;
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
620      * will be to transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
626      */
627     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
628 }
629 
630 
631 // File contracts/Interfaces.sol
632 
633 /**
634  * Hegic
635  * Copyright (C) 2020 Hegic Protocol
636  *
637  * This program is free software: you can redistribute it and/or modify
638  * it under the terms of the GNU General Public License as published by
639  * the Free Software Foundation, either version 3 of the License, or
640  * (at your option) any later version.
641  *
642  * This program is distributed in the hope that it will be useful,
643  * but WITHOUT ANY WARRANTY; without even the implied warranty of
644  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
645  * GNU General Public License for more details.
646  *
647  * You should have received a copy of the GNU General Public License
648  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
649  */
650 
651 pragma solidity 0.6.12;
652 
653 interface IHegicStaking is IERC20 {
654     function classicLockupPeriod() external view returns (uint256);
655     function lastBoughtTimestamp(address) external view returns (uint256);
656 
657     function claimProfits(address account) external returns (uint profit);
658     function buyStakingLot(uint amount) external;
659     function sellStakingLot(uint amount) external;
660     function profitOf(address account) external view returns (uint profit);
661 }
662 
663 interface IHegicStakingETH is IHegicStaking {
664     function sendProfit() external payable;
665 }
666 
667 interface IHegicStakingERC20 is IHegicStaking {
668     function sendProfit(uint amount) external;
669 }
670 
671 interface IOldStakingPool {
672     function ownerPerformanceFee(address account) external view returns (uint);
673     function withdraw(uint256 amount) external;
674 }
675 
676 interface IOldPool {
677     function withdraw(uint256 amount) external returns (uint);
678 }
679 
680 
681 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
682 
683 pragma solidity >=0.6.0 <0.8.0;
684 
685 /**
686  * @dev Contract module which provides a basic access control mechanism, where
687  * there is an account (an owner) that can be granted exclusive access to
688  * specific functions.
689  *
690  * By default, the owner account will be the one that deploys the contract. This
691  * can later be changed with {transferOwnership}.
692  *
693  * This module is used through inheritance. It will make available the modifier
694  * `onlyOwner`, which can be applied to your functions to restrict their use to
695  * the owner.
696  */
697 abstract contract Ownable is Context {
698     address private _owner;
699 
700     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
701 
702     /**
703      * @dev Initializes the contract setting the deployer as the initial owner.
704      */
705     constructor () internal {
706         address msgSender = _msgSender();
707         _owner = msgSender;
708         emit OwnershipTransferred(address(0), msgSender);
709     }
710 
711     /**
712      * @dev Returns the address of the current owner.
713      */
714     function owner() public view virtual returns (address) {
715         return _owner;
716     }
717 
718     /**
719      * @dev Throws if called by any account other than the owner.
720      */
721     modifier onlyOwner() {
722         require(owner() == _msgSender(), "Ownable: caller is not the owner");
723         _;
724     }
725 
726     /**
727      * @dev Leaves the contract without owner. It will not be possible to call
728      * `onlyOwner` functions anymore. Can only be called by the current owner.
729      *
730      * NOTE: Renouncing ownership will leave the contract without an owner,
731      * thereby removing any functionality that is only available to the owner.
732      */
733     function renounceOwnership() public virtual onlyOwner {
734         emit OwnershipTransferred(_owner, address(0));
735         _owner = address(0);
736     }
737 
738     /**
739      * @dev Transfers ownership of the contract to a new account (`newOwner`).
740      * Can only be called by the current owner.
741      */
742     function transferOwnership(address newOwner) public virtual onlyOwner {
743         require(newOwner != address(0), "Ownable: new owner is the zero address");
744         emit OwnershipTransferred(_owner, newOwner);
745         _owner = newOwner;
746     }
747 }
748 
749 
750 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
751 
752 pragma solidity >=0.6.2 <0.8.0;
753 
754 /**
755  * @dev Collection of functions related to the address type
756  */
757 library Address {
758     /**
759      * @dev Returns true if `account` is a contract.
760      *
761      * [IMPORTANT]
762      * ====
763      * It is unsafe to assume that an address for which this function returns
764      * false is an externally-owned account (EOA) and not a contract.
765      *
766      * Among others, `isContract` will return false for the following
767      * types of addresses:
768      *
769      *  - an externally-owned account
770      *  - a contract in construction
771      *  - an address where a contract will be created
772      *  - an address where a contract lived, but was destroyed
773      * ====
774      */
775     function isContract(address account) internal view returns (bool) {
776         // This method relies on extcodesize, which returns 0 for contracts in
777         // construction, since the code is only stored at the end of the
778         // constructor execution.
779 
780         uint256 size;
781         // solhint-disable-next-line no-inline-assembly
782         assembly { size := extcodesize(account) }
783         return size > 0;
784     }
785 
786     /**
787      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
788      * `recipient`, forwarding all available gas and reverting on errors.
789      *
790      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
791      * of certain opcodes, possibly making contracts go over the 2300 gas limit
792      * imposed by `transfer`, making them unable to receive funds via
793      * `transfer`. {sendValue} removes this limitation.
794      *
795      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
796      *
797      * IMPORTANT: because control is transferred to `recipient`, care must be
798      * taken to not create reentrancy vulnerabilities. Consider using
799      * {ReentrancyGuard} or the
800      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
801      */
802     function sendValue(address payable recipient, uint256 amount) internal {
803         require(address(this).balance >= amount, "Address: insufficient balance");
804 
805         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
806         (bool success, ) = recipient.call{ value: amount }("");
807         require(success, "Address: unable to send value, recipient may have reverted");
808     }
809 
810     /**
811      * @dev Performs a Solidity function call using a low level `call`. A
812      * plain`call` is an unsafe replacement for a function call: use this
813      * function instead.
814      *
815      * If `target` reverts with a revert reason, it is bubbled up by this
816      * function (like regular Solidity function calls).
817      *
818      * Returns the raw returned data. To convert to the expected return value,
819      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
820      *
821      * Requirements:
822      *
823      * - `target` must be a contract.
824      * - calling `target` with `data` must not revert.
825      *
826      * _Available since v3.1._
827      */
828     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
829       return functionCall(target, data, "Address: low-level call failed");
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
834      * `errorMessage` as a fallback revert reason when `target` reverts.
835      *
836      * _Available since v3.1._
837      */
838     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
839         return functionCallWithValue(target, data, 0, errorMessage);
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
844      * but also transferring `value` wei to `target`.
845      *
846      * Requirements:
847      *
848      * - the calling contract must have an ETH balance of at least `value`.
849      * - the called Solidity function must be `payable`.
850      *
851      * _Available since v3.1._
852      */
853     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
854         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
855     }
856 
857     /**
858      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
859      * with `errorMessage` as a fallback revert reason when `target` reverts.
860      *
861      * _Available since v3.1._
862      */
863     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
864         require(address(this).balance >= value, "Address: insufficient balance for call");
865         require(isContract(target), "Address: call to non-contract");
866 
867         // solhint-disable-next-line avoid-low-level-calls
868         (bool success, bytes memory returndata) = target.call{ value: value }(data);
869         return _verifyCallResult(success, returndata, errorMessage);
870     }
871 
872     /**
873      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
874      * but performing a static call.
875      *
876      * _Available since v3.3._
877      */
878     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
879         return functionStaticCall(target, data, "Address: low-level static call failed");
880     }
881 
882     /**
883      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
884      * but performing a static call.
885      *
886      * _Available since v3.3._
887      */
888     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
889         require(isContract(target), "Address: static call to non-contract");
890 
891         // solhint-disable-next-line avoid-low-level-calls
892         (bool success, bytes memory returndata) = target.staticcall(data);
893         return _verifyCallResult(success, returndata, errorMessage);
894     }
895 
896     /**
897      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
898      * but performing a delegate call.
899      *
900      * _Available since v3.4._
901      */
902     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
903         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
904     }
905 
906     /**
907      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
908      * but performing a delegate call.
909      *
910      * _Available since v3.4._
911      */
912     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
913         require(isContract(target), "Address: delegate call to non-contract");
914 
915         // solhint-disable-next-line avoid-low-level-calls
916         (bool success, bytes memory returndata) = target.delegatecall(data);
917         return _verifyCallResult(success, returndata, errorMessage);
918     }
919 
920     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
921         if (success) {
922             return returndata;
923         } else {
924             // Look for revert reason and bubble it up if present
925             if (returndata.length > 0) {
926                 // The easiest way to bubble the revert reason is using memory via assembly
927 
928                 // solhint-disable-next-line no-inline-assembly
929                 assembly {
930                     let returndata_size := mload(returndata)
931                     revert(add(32, returndata), returndata_size)
932                 }
933             } else {
934                 revert(errorMessage);
935             }
936         }
937     }
938 }
939 
940 
941 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
942 
943 pragma solidity >=0.6.0 <0.8.0;
944 
945 
946 
947 /**
948  * @title SafeERC20
949  * @dev Wrappers around ERC20 operations that throw on failure (when the token
950  * contract returns false). Tokens that return no value (and instead revert or
951  * throw on failure) are also supported, non-reverting calls are assumed to be
952  * successful.
953  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
954  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
955  */
956 library SafeERC20 {
957     using SafeMath for uint256;
958     using Address for address;
959 
960     function safeTransfer(IERC20 token, address to, uint256 value) internal {
961         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
962     }
963 
964     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
965         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
966     }
967 
968     /**
969      * @dev Deprecated. This function has issues similar to the ones found in
970      * {IERC20-approve}, and its usage is discouraged.
971      *
972      * Whenever possible, use {safeIncreaseAllowance} and
973      * {safeDecreaseAllowance} instead.
974      */
975     function safeApprove(IERC20 token, address spender, uint256 value) internal {
976         // safeApprove should only be called when setting an initial allowance,
977         // or when resetting it to zero. To increase and decrease it, use
978         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
979         // solhint-disable-next-line max-line-length
980         require((value == 0) || (token.allowance(address(this), spender) == 0),
981             "SafeERC20: approve from non-zero to non-zero allowance"
982         );
983         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
984     }
985 
986     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
987         uint256 newAllowance = token.allowance(address(this), spender).add(value);
988         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
989     }
990 
991     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
992         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
993         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
994     }
995 
996     /**
997      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
998      * on the return value: the return value is optional (but if data is returned, it must not be false).
999      * @param token The token targeted by the call.
1000      * @param data The call data (encoded using abi.encode or one of its variants).
1001      */
1002     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1003         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1004         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1005         // the target address contains contract code and also asserts for success in the low-level call.
1006 
1007         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1008         if (returndata.length > 0) { // Return data is optional
1009             // solhint-disable-next-line max-line-length
1010             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1011         }
1012     }
1013 }
1014 
1015 
1016 // File contracts/HegicStakingPool.sol
1017 
1018 // SPDX-License-Identifier: GPL-3.0
1019 pragma solidity 0.6.12;
1020 
1021 
1022 
1023 
1024 contract HegicStakingPool is Ownable, ERC20{
1025     using SafeMath for uint;
1026     using SafeERC20 for IERC20;
1027 
1028     // Tokens
1029     IERC20 public immutable HEGIC;
1030 
1031     mapping(Asset => IHegicStaking) public staking; 
1032 
1033     uint public constant STAKING_LOT_PRICE = 888_000e18;
1034     uint public constant ACCURACY = 1e32;
1035 
1036     address payable public FALLBACK_RECIPIENT;
1037     address payable public FEE_RECIPIENT;
1038 
1039     address public constant OLD_HEGIC_STAKING_POOL = address(0xf4128B00AFdA933428056d0F0D1d7652aF7e2B35);
1040     address public constant Z_HEGIC = address(0x837010619aeb2AE24141605aFC8f66577f6fb2e7);
1041 
1042     uint public performanceFee = 5000;
1043     uint public discountedPerformanceFee = 4000;
1044     bool public depositsAllowed = true;
1045     uint public lockUpPeriod = 15 minutes;
1046     bool private migrating;
1047 
1048     uint public totalBalance;
1049     uint public lockedBalance;
1050     uint public totalNumberOfStakingLots;
1051 
1052     mapping(Asset => uint) public numberOfStakingLots;
1053     mapping(Asset => uint) public totalProfitPerToken;
1054     mapping(Asset => IERC20) public token;
1055     enum Asset {WBTC, ETH, USDC}
1056 
1057     mapping(address => uint) public ownerPerformanceFee;
1058     mapping(address => bool) public isNotFirstTime;
1059     mapping(address => uint) public lastDepositTime;
1060     mapping(address => mapping(Asset => uint)) lastProfit;
1061     mapping(address => mapping(Asset => uint)) savedProfit;
1062 
1063     event Deposit(address account, uint amount);
1064     event Withdraw(address account, uint amount);
1065     event BuyLot(Asset asset, address account);
1066     event SellLot(Asset asset, address account);
1067     event ClaimedProfit(address account, Asset asset, uint netProfit, uint fee);
1068 
1069     constructor(IERC20 _HEGIC, IERC20 _WBTC, IERC20 _WETH, IERC20 _USDC, IHegicStaking _stakingWBTC, IHegicStaking _stakingETH, IHegicStaking _stakingUSDC) public ERC20("Staked HEGIC", "sHEGIC"){
1070         HEGIC = _HEGIC;
1071         staking[Asset.WBTC] = _stakingWBTC;
1072         staking[Asset.ETH] = _stakingETH;
1073         staking[Asset.USDC] = _stakingUSDC;
1074         token[Asset.WBTC] = _WBTC;
1075         token[Asset.ETH] = _WETH;
1076         token[Asset.USDC] = _USDC;
1077         FEE_RECIPIENT = msg.sender;
1078         FALLBACK_RECIPIENT = msg.sender;
1079 
1080         // Approve Staking Lot Contract
1081         _HEGIC.approve(address(staking[Asset.WBTC]), type(uint256).max);
1082         _HEGIC.approve(address(staking[Asset.ETH]), type(uint256).max);
1083         _HEGIC.approve(address(staking[Asset.USDC]), type(uint256).max);
1084     }
1085 
1086     function approveContracts() external {
1087         require(depositsAllowed);
1088         HEGIC.approve(address(staking[Asset.WBTC]), type(uint256).max);
1089         HEGIC.approve(address(staking[Asset.ETH]), type(uint256).max);
1090         HEGIC.approve(address(staking[Asset.USDC]), type(uint256).max);
1091     }
1092 
1093     /**
1094      * @notice Stops the ability to add new deposits
1095      * @param _allow If set to false, new deposits will be rejected
1096      */
1097     function allowDeposits(bool _allow) external onlyOwner {
1098         depositsAllowed = _allow;
1099     }
1100 
1101     /**
1102      * @notice Changes Fee paid to creator (only paid when taking profits)
1103      * @param _fee New fee
1104      */
1105     function changePerformanceFee(uint _fee) external onlyOwner {
1106         require(_fee >= 0, "Fee too low");
1107         require(_fee <= 10000, "Fee too high");
1108         
1109         performanceFee = _fee;
1110     }
1111 
1112     /**
1113      * @notice Changes discounted Fee paid to creator (only paid when taking profits)
1114      * @param _fee New fee
1115      */
1116     function changeDiscountedPerformanceFee(uint _fee) external onlyOwner {
1117         require(_fee >= 0, "Fee too low");
1118         require(_fee <= 10000, "Fee too high");
1119 
1120         discountedPerformanceFee = _fee;
1121     }
1122 
1123     /**
1124      * @notice Changes Fee Recipient address
1125      * @param _recipient New address
1126      */
1127     function changeFeeRecipient(address _recipient) external onlyOwner {
1128         FEE_RECIPIENT = payable(_recipient);
1129     }
1130 
1131     /**
1132      * @notice Changes Fallback Recipient address. This is only used in case of unexpected behavior
1133      * @param _recipient New address
1134      */
1135     function changeFallbackRecipient(address _recipient) external onlyOwner {
1136         FALLBACK_RECIPIENT = payable(_recipient);
1137     }
1138 
1139     /**
1140      * @notice Toggles effect of lockup period by setting lockUpPeriod to 0 (disabled) or to 15 minutes(enabled)
1141      * @param _unlock Boolean: if true, unlocks funds
1142      */
1143     function unlockAllFunds(bool _unlock) external onlyOwner {
1144         if(_unlock) lockUpPeriod = 0;
1145         else lockUpPeriod = 15 minutes;
1146     }
1147 
1148     /**
1149      * @notice Migrates HEGIC from old staking pools (supports HegicStakingPool + ZLOT)
1150      * @param oldStakingPool staking pool from which we are migrating
1151      * @return HEGIC migrated
1152      */
1153     function migrateFromOldStakingPool(IOldStakingPool oldStakingPool) external returns (uint) {
1154         IERC20 sToken;
1155         // to avoid reseting fee during deposit
1156         isNotFirstTime[msg.sender] = true;
1157         if(address(oldStakingPool) == address(OLD_HEGIC_STAKING_POOL)) {
1158             sToken = IERC20(address(oldStakingPool));
1159             // take ownerPerformanceFee from old pool
1160             uint oldPerformanceFee = oldStakingPool.ownerPerformanceFee(msg.sender);
1161             uint dFee = discountedPerformanceFee;
1162             if(oldPerformanceFee > dFee) {
1163                 ownerPerformanceFee[msg.sender] = dFee;
1164             } else {
1165                 ownerPerformanceFee[msg.sender] = oldStakingPool.ownerPerformanceFee(msg.sender);
1166             }
1167         } else {
1168             // migrating from zLOT
1169             sToken = IERC20(Z_HEGIC);
1170             ownerPerformanceFee[msg.sender] = discountedPerformanceFee;
1171         }
1172         require(sToken.balanceOf(msg.sender) > 0, "Not enough balance / not supported");
1173         // requires approval
1174         uint256 oldBalance = sToken.balanceOf(msg.sender);
1175         sToken.safeTransferFrom(msg.sender, address(this), oldBalance);
1176         if(address(oldStakingPool) == address(OLD_HEGIC_STAKING_POOL)) {
1177             // migrating from HegicStakingPool
1178             oldStakingPool.withdraw(oldBalance);
1179         } else {
1180             // migrating from zLOT
1181             oldBalance = IOldPool(address(oldStakingPool)).withdraw(oldBalance);
1182         }
1183         migrating = true;
1184         deposit(oldBalance);
1185         return oldBalance;
1186     }
1187 
1188     /**
1189      * @notice Deposits _amount HEGIC in the contract. 
1190      * 
1191      * @param _amount Number of HEGIC to deposit in the contract // number of sHEGIC that will be minted
1192      */
1193     function deposit(uint _amount) public {
1194         require(_amount > 0, "Amount too low");
1195         require(depositsAllowed, "Deposits are not allowed at the moment");
1196         // set fee for that staking lot owner - this effectively sets the maximum FEE an owner can have
1197         // each time user deposits, this checks if current fee is higher or lower than previous fees
1198         // and updates it if it is lower
1199         if(ownerPerformanceFee[msg.sender] > performanceFee || !isNotFirstTime[msg.sender]) {
1200             ownerPerformanceFee[msg.sender] = performanceFee;
1201             isNotFirstTime[msg.sender] = true;
1202         }
1203         lastDepositTime[msg.sender] = block.timestamp;
1204         // receive deposit
1205         depositHegic(_amount);
1206 
1207         while(totalBalance.sub(lockedBalance) >= STAKING_LOT_PRICE){
1208             buyStakingLot();
1209         }
1210     }
1211 
1212     /**
1213      * @notice Withdraws _amount HEGIC from the contract. 
1214      * 
1215      * @param _amount Number of HEGIC to withdraw from contract // number of sHEGIC that will be burnt
1216      */
1217     function withdraw(uint _amount) public {
1218         require(_amount <= balanceOf(msg.sender), "Not enough balance");
1219         require(canWithdraw(msg.sender), "You deposited less than 15 mins ago. Your funds are locked");
1220 
1221         while(totalBalance.sub(lockedBalance) < _amount){
1222             sellStakingLot();
1223         }
1224 
1225         withdrawHegic(_amount);
1226     }
1227 
1228     /**
1229      * @notice Withdraws _amount HEGIC from the contract and claims all profit pending in contract
1230      * 
1231      */
1232     function claimProfitAndWithdraw() external {
1233         claimAllProfit();
1234         withdraw(balanceOf(msg.sender));
1235     }
1236 
1237     /**
1238      * @notice Claims profit for both assets. Profit will be paid to msg.sender
1239      * This is the most gas-efficient way to claim profits (instead of separately)
1240      * 
1241      */
1242     function claimAllProfit() public {
1243         claimProfit(Asset.WBTC);
1244         claimProfit(Asset.ETH);
1245         claimProfit(Asset.USDC);
1246     }
1247 
1248     /**
1249      * @notice Claims profit for specific _asset. Profit will be paid to msg.sender
1250      * 
1251      * @param _asset Asset (ETH or WBTC)
1252      */
1253     function claimProfit(Asset _asset) public {
1254         uint profit = saveProfit(msg.sender, _asset);
1255         savedProfit[msg.sender][_asset] = 0;
1256         
1257         _transferProfit(profit, _asset, msg.sender, ownerPerformanceFee[msg.sender]);
1258     }
1259 
1260     /**
1261      * @notice Returns profit to be paid when claimed
1262      * 
1263      * @param _account Account to get profit for
1264      * @param _asset Asset (ETH or WBTC)
1265      */
1266     function profitOf(address _account, Asset _asset) public view returns (uint profit) {
1267         return savedProfit[_account][_asset].add(getUnsaved(_account, _asset));
1268     }
1269 
1270     /**
1271      * @notice Returns address of Hegic's ETH Staking Lot contract
1272      */
1273     function getHegicStakingETH() public view returns (IHegicStaking HegicStakingETH){
1274         return staking[Asset.ETH];
1275     }
1276 
1277     /**
1278      * @notice Returns address of Hegic's WBTC Staking Lot contract
1279      */
1280     function getHegicStakingWBTC() public view returns (IHegicStaking HegicStakingWBTC){
1281         return staking[Asset.WBTC];
1282     }
1283 
1284     /**
1285      * @notice Returns address of Hegic's USDC Staking Lot contract
1286      */
1287     function getHegicStakingUSDC() public view returns (IHegicStaking HegicStakingWBTC){
1288         return staking[Asset.USDC];
1289     }
1290 
1291     /**
1292      * @notice Support function. Gets profit that has not been saved (either in Staking Lot contracts)
1293      * or in this contract
1294      * 
1295      * @param _account Account to get unsaved profit for
1296      * @param _asset Asset (ETH or WBTC)
1297      */
1298     function getUnsaved(address _account, Asset _asset) public view returns (uint profit) {
1299         profit = totalProfitPerToken[_asset].sub(lastProfit[_account][_asset]).add(getUnreceivedProfitPerToken(_asset)).mul(balanceOf(_account)).div(ACCURACY);
1300     }
1301 
1302     /**
1303      * @notice Internal function. Update profit per token for _asset
1304      * 
1305      * @param _asset Underlying asset (ETH or WBTC)
1306      */
1307     function updateProfit(Asset _asset) internal {
1308         uint profit = staking[_asset].profitOf(address(this));
1309         if(profit > 0) {
1310             profit = staking[_asset].claimProfits(address(this));
1311         }
1312 
1313         if(totalBalance <= 0) {
1314             IERC20 assetToken = token[_asset];
1315             assetToken.safeTransfer(FALLBACK_RECIPIENT, profit);
1316         } else {
1317             totalProfitPerToken[_asset] = totalProfitPerToken[_asset].add(profit.mul(ACCURACY).div(totalBalance));
1318         }
1319     }
1320 
1321     /**
1322      * @notice Internal function. Transfers net profit to the owner of the sHEGIC. 
1323      * 
1324      * @param _amount Amount of Asset (ETH or WBTC) to be sent
1325      * @param _asset Asset to be sent (ETH or WBTC)
1326      * @param _account Receiver of the net profit
1327      * @param _fee Fee % to be applied to the profit (100% = 100000)
1328      */
1329     function _transferProfit(uint _amount, Asset _asset, address _account, uint _fee) internal {
1330         uint netProfit = _amount.mul(uint(100000).sub(_fee)).div(100000);
1331         uint fee = _amount.sub(netProfit);
1332 
1333         IERC20 assetToken = token[_asset]; 
1334         assetToken.safeTransfer(_account, netProfit);
1335         assetToken.safeTransfer(FEE_RECIPIENT, fee);
1336         emit ClaimedProfit(_account, _asset, netProfit, fee);
1337     }
1338 
1339     /**
1340      * @notice Internal function to transfer deposited HEGIC to the contract and mint sHEGIC (Staked HEGIC)
1341      * @param _amount Amount of HEGIC to deposit // Amount of sHEGIC that will be minted
1342      */
1343     function depositHegic(uint _amount) internal {
1344         totalBalance = totalBalance.add(_amount); 
1345         // if we are during migration, we don't need to take HEGIC from the user
1346         if(!migrating) {
1347             HEGIC.safeTransferFrom(msg.sender, address(this), _amount);
1348         } else {
1349             migrating = false;
1350             require(totalBalance == HEGIC.balanceOf(address(this)).add(lockedBalance), "!");
1351         }
1352 
1353         _mint(msg.sender, _amount);
1354     }
1355 
1356     /**
1357      * @notice Internal function. Moves _amount HEGIC from contract to user
1358      * also burns staked HEGIC (sHEGIC) tokens
1359      * @param _amount Amount of HEGIC to withdraw // Amount of sHEGIC that will be burned
1360      */
1361     function withdrawHegic(uint _amount) internal {
1362         _burn(msg.sender, _amount);
1363         HEGIC.safeTransfer(msg.sender, _amount);
1364         totalBalance = totalBalance.sub(_amount);
1365         emit Withdraw(msg.sender, _amount);
1366     }
1367 
1368     /**
1369      * @notice Internal function. Chooses which lot to buy (ETH or WBTC) and buys it
1370      *
1371      */
1372     function buyStakingLot() internal {
1373         // we buy 1 ETH staking lot, then 1 WBTC staking lot, then 1 USDC staking lot, ...
1374         Asset asset = Asset.USDC;
1375         if(numberOfStakingLots[Asset.USDC] >= numberOfStakingLots[Asset.WBTC]){
1376             if(numberOfStakingLots[Asset.WBTC] >= numberOfStakingLots[Asset.ETH]){
1377                 asset = Asset.ETH;
1378             } else {
1379                 asset = Asset.WBTC;
1380             }
1381         }
1382 
1383         lockedBalance = lockedBalance.add(STAKING_LOT_PRICE);
1384         staking[asset].buyStakingLot(1);
1385         totalNumberOfStakingLots++;
1386         numberOfStakingLots[asset]++;
1387         emit BuyLot(asset, msg.sender);
1388     }
1389 
1390     /**
1391      * @notice Internal function. Chooses which lot to sell (ETH or WBTC or USDC) and sells it
1392      *
1393      */
1394     function sellStakingLot() internal {
1395         Asset asset = Asset.ETH;
1396         if(numberOfStakingLots[Asset.ETH] <= numberOfStakingLots[Asset.WBTC] || 
1397             staking[Asset.ETH].lastBoughtTimestamp(address(this))
1398                     .add(staking[Asset.ETH].classicLockupPeriod()) > block.timestamp || 
1399             staking[Asset.ETH].balanceOf(address(this)) == 0)
1400         {
1401             if(numberOfStakingLots[Asset.WBTC] <= numberOfStakingLots[Asset.USDC] && 
1402                 staking[Asset.USDC].lastBoughtTimestamp(address(this))
1403                     .add(staking[Asset.USDC].classicLockupPeriod()) <= block.timestamp && 
1404                 staking[Asset.USDC].balanceOf(address(this)) > 0){
1405                 asset = Asset.USDC;
1406             } else if (staking[Asset.WBTC].lastBoughtTimestamp(address(this))
1407                     .add(staking[Asset.WBTC].classicLockupPeriod()) <= block.timestamp && 
1408                 staking[Asset.WBTC].balanceOf(address(this)) > 0){
1409                 asset = Asset.WBTC;
1410             } else {
1411                 asset = Asset.ETH;
1412                 // this require only applies here. otherwise conditions have been already checked
1413                 require(
1414                     staking[asset].lastBoughtTimestamp(address(this))
1415                         .add(staking[asset].classicLockupPeriod()) <= block.timestamp &&
1416                         staking[asset].balanceOf(address(this)) > 0,
1417                     "Lot sale is locked by Hegic. Funds should be available in less than 24h"
1418                 );
1419             }
1420         }
1421 
1422         lockedBalance = lockedBalance.sub(STAKING_LOT_PRICE);
1423         staking[asset].sellStakingLot(1);
1424         totalNumberOfStakingLots--;
1425         numberOfStakingLots[asset]--;
1426         emit SellLot(asset, msg.sender);
1427     }
1428 
1429     /**
1430      * @notice Support function. Calculates how much profit would receive each token if the contract claimed
1431      * profit accumulated in Hegic's Staking Lot contracts
1432      * 
1433      * @param _asset Asset (WBTC or ETH)
1434      */
1435     function getUnreceivedProfitPerToken(Asset _asset) public view returns (uint unreceivedProfitPerToken){
1436         uint profit = staking[_asset].profitOf(address(this));
1437         
1438         unreceivedProfitPerToken = profit.mul(ACCURACY).div(totalBalance);
1439     }
1440 
1441     /**
1442      * @notice Saves profit for a certain _account. This profit is absolute in value
1443      * this function is called before every token transfer to keep the state of profits correctly
1444      * 
1445      * @param _account account to save profit to
1446      */
1447     function saveProfit(address _account) internal {
1448         saveProfit(_account, Asset.WBTC);
1449         saveProfit(_account, Asset.ETH);
1450         saveProfit(_account, Asset.USDC);
1451     }
1452 
1453     /**
1454      * @notice Internal function that saves unpaid profit to keep accounting.
1455      * 
1456      * @param _account Account to save profit to
1457      * @param _asset Asset (WBTC or ETH)     
1458      */
1459     function saveProfit(address _account, Asset _asset) internal returns (uint profit) {
1460         updateProfit(_asset);
1461         uint unsaved = getUnsaved(_account, _asset);
1462         lastProfit[_account][_asset] = totalProfitPerToken[_asset];
1463         profit = savedProfit[_account][_asset].add(unsaved);
1464         savedProfit[_account][_asset] = profit;
1465     }
1466 
1467     /**
1468      * @notice Support function. Relevant to the profit system. It will save state of profit before each 
1469      * token transfer (either deposit or withdrawal)
1470      * 
1471      * @param from Account sending tokens 
1472      * @param to Account receiving tokens
1473      */
1474     function _beforeTokenTransfer(address from, address to, uint256) internal override {
1475         require(canWithdraw(from), "!locked funds");
1476         if (from != address(0)) saveProfit(from);
1477         if (to != address(0)) saveProfit(to);
1478     }
1479 
1480     /**
1481      * @notice Returns a boolean indicating if that specific _account can withdraw or not
1482      * (due to lockupperiod reasons)
1483      * @param _account Account to check withdrawal status 
1484      */
1485     function canWithdraw(address _account) public view returns (bool) {
1486         return (lastDepositTime[_account].add(lockUpPeriod) <= block.timestamp);
1487     }
1488 }