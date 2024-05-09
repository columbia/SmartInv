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
218 // File: @openzeppelin/contracts/utils/Context.sol
219 
220 
221 pragma solidity >=0.6.0 <0.8.0;
222 
223 /*
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with GSN meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address payable) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes memory) {
239         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
240         return msg.data;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
245 
246 
247 pragma solidity >=0.6.0 <0.8.0;
248 
249 /**
250  * @dev Interface of the ERC20 standard as defined in the EIP.
251  */
252 interface IERC20 {
253     /**
254      * @dev Returns the amount of tokens in existence.
255      */
256     function totalSupply() external view returns (uint256);
257 
258     /**
259      * @dev Returns the amount of tokens owned by `account`.
260      */
261     function balanceOf(address account) external view returns (uint256);
262 
263     /**
264      * @dev Moves `amount` tokens from the caller's account to `recipient`.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transfer(address recipient, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Returns the remaining number of tokens that `spender` will be
274      * allowed to spend on behalf of `owner` through {transferFrom}. This is
275      * zero by default.
276      *
277      * This value changes when {approve} or {transferFrom} are called.
278      */
279     function allowance(address owner, address spender) external view returns (uint256);
280 
281     /**
282      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * IMPORTANT: Beware that changing an allowance with this method brings the risk
287      * that someone may use both the old and the new allowance by unfortunate
288      * transaction ordering. One possible solution to mitigate this race
289      * condition is to first reduce the spender's allowance to 0 and set the
290      * desired value afterwards:
291      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292      *
293      * Emits an {Approval} event.
294      */
295     function approve(address spender, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Moves `amount` tokens from `sender` to `recipient` using the
299      * allowance mechanism. `amount` is then deducted from the caller's
300      * allowance.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * Emits a {Transfer} event.
305      */
306     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
307 
308     /**
309      * @dev Emitted when `value` tokens are moved from one account (`from`) to
310      * another (`to`).
311      *
312      * Note that `value` may be zero.
313      */
314     event Transfer(address indexed from, address indexed to, uint256 value);
315 
316     /**
317      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
318      * a call to {approve}. `value` is the new allowance.
319      */
320     event Approval(address indexed owner, address indexed spender, uint256 value);
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
324 
325 
326 pragma solidity >=0.6.0 <0.8.0;
327 
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
630 // File: @openzeppelin/contracts/access/Ownable.sol
631 
632 
633 pragma solidity >=0.6.0 <0.8.0;
634 
635 /**
636  * @dev Contract module which provides a basic access control mechanism, where
637  * there is an account (an owner) that can be granted exclusive access to
638  * specific functions.
639  *
640  * By default, the owner account will be the one that deploys the contract. This
641  * can later be changed with {transferOwnership}.
642  *
643  * This module is used through inheritance. It will make available the modifier
644  * `onlyOwner`, which can be applied to your functions to restrict their use to
645  * the owner.
646  */
647 abstract contract Ownable is Context {
648     address private _owner;
649 
650     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
651 
652     /**
653      * @dev Initializes the contract setting the deployer as the initial owner.
654      */
655     constructor () internal {
656         address msgSender = _msgSender();
657         _owner = msgSender;
658         emit OwnershipTransferred(address(0), msgSender);
659     }
660 
661     /**
662      * @dev Returns the address of the current owner.
663      */
664     function owner() public view virtual returns (address) {
665         return _owner;
666     }
667 
668     /**
669      * @dev Throws if called by any account other than the owner.
670      */
671     modifier onlyOwner() {
672         require(owner() == _msgSender(), "Ownable: caller is not the owner");
673         _;
674     }
675 
676     /**
677      * @dev Leaves the contract without owner. It will not be possible to call
678      * `onlyOwner` functions anymore. Can only be called by the current owner.
679      *
680      * NOTE: Renouncing ownership will leave the contract without an owner,
681      * thereby removing any functionality that is only available to the owner.
682      */
683     function renounceOwnership() public virtual onlyOwner {
684         emit OwnershipTransferred(_owner, address(0));
685         _owner = address(0);
686     }
687 
688     /**
689      * @dev Transfers ownership of the contract to a new account (`newOwner`).
690      * Can only be called by the current owner.
691      */
692     function transferOwnership(address newOwner) public virtual onlyOwner {
693         require(newOwner != address(0), "Ownable: new owner is the zero address");
694         emit OwnershipTransferred(_owner, newOwner);
695         _owner = newOwner;
696     }
697 }
698 
699 // File: contracts/interfaces/Owned.sol
700 
701 pragma solidity 0.7.5;
702 
703 
704 abstract contract Owned is Ownable {
705     constructor(address _owner) {
706         transferOwnership(_owner);
707     }
708 }
709 
710 // File: contracts/interfaces/ISwapReceiver.sol
711 
712 pragma solidity 0.7.5;
713 
714 interface ISwapReceiver {
715     function swapMint(address _holder, uint256 _amount) external;
716 }
717 
718 // File: contracts/interfaces/SwappableToken.sol
719 
720 pragma solidity 0.7.5;
721 
722 // Inheritance
723 
724 
725 
726 
727 
728 
729 /// @title   Umbrella Rewards contract
730 /// @author  umb.network
731 /// @notice  This contract serves Swap functionality for rewards tokens
732 /// @dev     It allows to swap itself for other token (main UMB token).
733 ///          Swap can start 1y from deployment or can be triggered earlier by owner.
734 ///          There is a daily limit for swapping so we can't swap all at once.
735 ///          When swap is executing, this contract do not care about target token,
736 ///          so target token should be responsible for all the check before he mint tokens for swap.
737 abstract contract SwappableToken is Owned, ERC20 {
738     using SafeMath for uint256;
739 
740     uint256 public totalAmountToBeSwapped;
741     uint256 public swappedSoFar;
742     uint256 public swapStartsOn;
743     uint256 public swapDuration;
744 
745     // ========== CONSTRUCTOR ========== //
746 
747     constructor(uint _totalAmountToBeSwapped, uint _swapDuration) {
748         require(_totalAmountToBeSwapped != 0, "_totalAmountToBeSwapped is empty");
749         require(_swapDuration != 0, "swapDuration is empty");
750 
751         totalAmountToBeSwapped = _totalAmountToBeSwapped;
752         swapStartsOn = block.timestamp + 365 days;
753         swapDuration = _swapDuration;
754     }
755 
756     // ========== MODIFIERS ========== //
757 
758     // ========== VIEWS ========== //
759 
760     function isSwapStarted() public view returns (bool) {
761         return block.timestamp >= swapStartsOn;
762     }
763 
764     function canSwapTokens(address _address) public view returns (bool) {
765         return balanceOf(_address) <= totalUnlockedAmountOfToken().sub(swappedSoFar);
766     }
767 
768     function totalUnlockedAmountOfToken() public view returns (uint256) {
769         if (block.timestamp < swapStartsOn)
770             return 0;
771         if (block.timestamp >= swapStartsOn.add(swapDuration)) {
772             return totalSupply().add(swappedSoFar);
773         } else {
774             return totalSupply().add(swappedSoFar).mul(block.timestamp.sub(swapStartsOn)).div(swapDuration);
775         }
776     }
777 
778     // ========== MUTATIVE FUNCTIONS ========== //
779 
780     function swapFor(ISwapReceiver _umb) external {
781         require(block.timestamp >= swapStartsOn, "swapping period has not started yet");
782 
783         uint amountToSwap = balanceOf(_msgSender());
784 
785         require(amountToSwap != 0, "you dont have tokens to swap");
786         require(amountToSwap <= totalUnlockedAmountOfToken().sub(swappedSoFar), "your swap is over the limit");
787 
788         swappedSoFar = swappedSoFar.add(amountToSwap);
789 
790         _burn(_msgSender(), amountToSwap);
791         _umb.swapMint(_msgSender(), amountToSwap);
792 
793         emit LogSwap(_msgSender(), amountToSwap);
794     }
795 
796     // ========== PRIVATE / INTERNAL ========== //
797 
798     // ========== RESTRICTED FUNCTIONS ========== //
799 
800     function startEarlySwap() external onlyOwner {
801         require(block.timestamp < swapStartsOn, "swap is already allowed");
802 
803         swapStartsOn = block.timestamp;
804         emit LogStartEarlySwapNow(block.timestamp);
805     }
806 
807     // ========== EVENTS ========== //
808 
809     event LogStartEarlySwapNow(uint time);
810     event LogSwap(address indexed swappedTo, uint amount);
811 }
812 
813 // File: contracts/interfaces/IBurnableToken.sol
814 
815 pragma solidity 0.7.5;
816 
817 interface IBurnableToken {
818     function burn(uint256 _amount) external;
819 }
820 
821 // File: contracts/interfaces/MintableToken.sol
822 
823 pragma solidity 0.7.5;
824 
825 // Inheritance
826 
827 
828 
829 
830 
831 /// @title   Umbrella Rewards contract
832 /// @author  umb.network
833 /// @notice  This contract allows to mint tokens and burn key (renounceOwnership)
834 /// @dev     Can be use used with MultiSig as owner
835 abstract contract MintableToken is Owned, ERC20, IBurnableToken {
836     using SafeMath for uint256;
837 
838     // ========== STATE VARIABLES ========== //
839 
840     uint256 public maxAllowedTotalSupply;
841 
842     // ========== CONSTRUCTOR ========== //
843 
844     constructor (uint256 _maxAllowedTotalSupply) {
845         require(_maxAllowedTotalSupply != 0, "_maxAllowedTotalSupply is empty");
846         maxAllowedTotalSupply = _maxAllowedTotalSupply;
847     }
848 
849     // ========== MODIFIERS ========== //
850 
851     modifier assertMaxSupply(uint256 _amountToMint) {
852         require(totalSupply().add(_amountToMint) <= maxAllowedTotalSupply, "total supply limit exceeded");
853         _;
854     }
855 
856     // ========== MUTATIVE FUNCTIONS ========== //
857 
858     function burn(uint256 _amount) override external {
859         uint balance = balanceOf(msg.sender);
860         require(_amount <= balance, "not enough tokens to burn");
861 
862         _burn(msg.sender, _amount);
863         maxAllowedTotalSupply = maxAllowedTotalSupply - _amount;
864     }
865 
866     // ========== RESTRICTED FUNCTIONS ========== //
867 
868     function mint(address _holder, uint256 _amount)
869     external
870     onlyOwner()
871     assertMaxSupply(_amount) {
872         require(_amount > 0, "zero amount");
873 
874         _mint(_holder, _amount);
875     }
876 }
877 
878 // File: contracts/interfaces/rUMB.sol
879 
880 pragma solidity 0.7.5;
881 
882 // Inheritance
883 
884 
885 
886 
887 /// @title   Umbrella Rewards contract
888 /// @author  umb.network
889 /// @notice  This is reward UMB token (rUMB)
890 /// @dev     Rewards tokens are used for farming and other rewards distributions.
891 abstract contract rUMB is MintableToken, SwappableToken {
892     // ========== STATE VARIABLES ========== //
893 
894     // ========== CONSTRUCTOR ========== //
895 
896     constructor (
897         address _owner,
898         address _initialHolder,
899         uint256 _initialBalance,
900         uint256 _maxAllowedTotalSupply,
901         uint256 _swapDuration,
902         string memory _name,
903         string memory _symbol
904     )
905     Owned(_owner)
906     ERC20(_name, _symbol)
907     MintableToken(_maxAllowedTotalSupply)
908     SwappableToken(_maxAllowedTotalSupply, _swapDuration) {
909         if (_initialHolder != address(0) && _initialBalance != 0) {
910             _mint(_initialHolder, _initialBalance);
911         }
912     }
913 }
914 
915 // File: contracts/rUMB1.sol
916 
917 pragma solidity 0.7.5;
918 
919 
920 contract rUMB1 is rUMB {
921      constructor (
922         address _owner,
923         address _initialHolder,
924         uint256 _initialBalance,
925         uint256 _maxAllowedTotalSupply,
926         uint256 _swapDuration,
927         string memory _name,
928         string memory _symbol
929     )
930     rUMB(_owner, _initialHolder, _initialBalance, _maxAllowedTotalSupply, _swapDuration, _name, _symbol) {
931     }
932 }