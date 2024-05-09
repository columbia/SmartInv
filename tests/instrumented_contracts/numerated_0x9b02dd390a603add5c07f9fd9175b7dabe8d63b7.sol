1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.5;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor () {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
96 
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP.
99  */
100 interface IERC20 {
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Returns the remaining number of tokens that `spender` will be
122      * allowed to spend on behalf of `owner` through {transferFrom}. This is
123      * zero by default.
124      *
125      * This value changes when {approve} or {transferFrom} are called.
126      */
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * IMPORTANT: Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Moves `amount` tokens from `sender` to `recipient` using the
147      * allowance mechanism. `amount` is then deducted from the caller's
148      * allowance.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Emitted when `value` tokens are moved from one account (`from`) to
158      * another (`to`).
159      *
160      * Note that `value` may be zero.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     /**
165      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
166      * a call to {approve}. `value` is the new allowance.
167      */
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 // File: @openzeppelin/contracts/math/SafeMath.sol
172 
173 /**
174  * @dev Wrappers over Solidity's arithmetic operations with added overflow
175  * checks.
176  *
177  * Arithmetic operations in Solidity wrap on overflow. This can easily result
178  * in bugs, because programmers usually assume that an overflow raises an
179  * error, which is the standard behavior in high level programming languages.
180  * `SafeMath` restores this intuition by reverting the transaction when an
181  * operation overflows.
182  *
183  * Using this library instead of the unchecked operations eliminates an entire
184  * class of bugs, so it's recommended to use it always.
185  */
186 library SafeMath {
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         require(c >= a, "SafeMath: addition overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         return sub(a, b, "SafeMath: subtraction overflow");
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b <= a, errorMessage);
230         uint256 c = a - b;
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the multiplication of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `*` operator.
240      *
241      * Requirements:
242      *
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         uint256 c = a * b;
254         require(c / a == b, "SafeMath: multiplication overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return div(a, b, "SafeMath: division by zero");
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b > 0, errorMessage);
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
308         return mod(a, b, "SafeMath: modulo by zero");
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * Reverts with custom message when dividing by zero.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b != 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
330 
331 
332 
333 /**
334  * @dev Implementation of the {IERC20} interface.
335  *
336  * This implementation is agnostic to the way tokens are created. This means
337  * that a supply mechanism has to be added in a derived contract using {_mint}.
338  * For a generic mechanism see {ERC20PresetMinterPauser}.
339  *
340  * TIP: For a detailed writeup see our guide
341  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
342  * to implement supply mechanisms].
343  *
344  * We have followed general OpenZeppelin guidelines: functions revert instead
345  * of returning `false` on failure. This behavior is nonetheless conventional
346  * and does not conflict with the expectations of ERC20 applications.
347  *
348  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
349  * This allows applications to reconstruct the allowance for all accounts just
350  * by listening to said events. Other implementations of the EIP may not emit
351  * these events, as it isn't required by the specification.
352  *
353  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
354  * functions have been added to mitigate the well-known issues around setting
355  * allowances. See {IERC20-approve}.
356  */
357 contract ERC20 is Context, IERC20 {
358     using SafeMath for uint256;
359 
360     mapping (address => uint256) private _balances;
361 
362     mapping (address => mapping (address => uint256)) private _allowances;
363 
364     uint256 private _totalSupply;
365 
366     string private _name;
367     string private _symbol;
368     uint8 private _decimals;
369 
370     /**
371      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
372      * a default value of 18.
373      *
374      * To select a different value for {decimals}, use {_setupDecimals}.
375      *
376      * All three of these values are immutable: they can only be set once during
377      * construction.
378      */
379     constructor (string memory name_, string memory symbol_) {
380         _name = name_;
381         _symbol = symbol_;
382         _decimals = 18;
383     }
384 
385     /**
386      * @dev Returns the name of the token.
387      */
388     function name() public view returns (string memory) {
389         return _name;
390     }
391 
392     /**
393      * @dev Returns the symbol of the token, usually a shorter version of the
394      * name.
395      */
396     function symbol() public view returns (string memory) {
397         return _symbol;
398     }
399 
400     /**
401      * @dev Returns the number of decimals used to get its user representation.
402      * For example, if `decimals` equals `2`, a balance of `505` tokens should
403      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
404      *
405      * Tokens usually opt for a value of 18, imitating the relationship between
406      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
407      * called.
408      *
409      * NOTE: This information is only used for _display_ purposes: it in
410      * no way affects any of the arithmetic of the contract, including
411      * {IERC20-balanceOf} and {IERC20-transfer}.
412      */
413     function decimals() public view returns (uint8) {
414         return _decimals;
415     }
416 
417     /**
418      * @dev See {IERC20-totalSupply}.
419      */
420     function totalSupply() public view override returns (uint256) {
421         return _totalSupply;
422     }
423 
424     /**
425      * @dev See {IERC20-balanceOf}.
426      */
427     function balanceOf(address account) public view override returns (uint256) {
428         return _balances[account];
429     }
430 
431     /**
432      * @dev See {IERC20-transfer}.
433      *
434      * Requirements:
435      *
436      * - `recipient` cannot be the zero address.
437      * - the caller must have a balance of at least `amount`.
438      */
439     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
440         _transfer(_msgSender(), recipient, amount);
441         return true;
442     }
443 
444     /**
445      * @dev See {IERC20-allowance}.
446      */
447     function allowance(address owner, address spender) public view virtual override returns (uint256) {
448         return _allowances[owner][spender];
449     }
450 
451     /**
452      * @dev See {IERC20-approve}.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      */
458     function approve(address spender, uint256 amount) public virtual override returns (bool) {
459         _approve(_msgSender(), spender, amount);
460         return true;
461     }
462 
463     /**
464      * @dev See {IERC20-transferFrom}.
465      *
466      * Emits an {Approval} event indicating the updated allowance. This is not
467      * required by the EIP. See the note at the beginning of {ERC20}.
468      *
469      * Requirements:
470      *
471      * - `sender` and `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      * - the caller must have allowance for ``sender``'s tokens of at least
474      * `amount`.
475      */
476     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
477         _transfer(sender, recipient, amount);
478         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
479         return true;
480     }
481 
482     /**
483      * @dev Atomically increases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to {approve} that can be used as a mitigation for
486      * problems described in {IERC20-approve}.
487      *
488      * Emits an {Approval} event indicating the updated allowance.
489      *
490      * Requirements:
491      *
492      * - `spender` cannot be the zero address.
493      */
494     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
496         return true;
497     }
498 
499     /**
500      * @dev Atomically decreases the allowance granted to `spender` by the caller.
501      *
502      * This is an alternative to {approve} that can be used as a mitigation for
503      * problems described in {IERC20-approve}.
504      *
505      * Emits an {Approval} event indicating the updated allowance.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      * - `spender` must have allowance for the caller of at least
511      * `subtractedValue`.
512      */
513     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
514         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
515         return true;
516     }
517 
518     /**
519      * @dev Moves tokens `amount` from `sender` to `recipient`.
520      *
521      * This is internal function is equivalent to {transfer}, and can be used to
522      * e.g. implement automatic token fees, slashing mechanisms, etc.
523      *
524      * Emits a {Transfer} event.
525      *
526      * Requirements:
527      *
528      * - `sender` cannot be the zero address.
529      * - `recipient` cannot be the zero address.
530      * - `sender` must have a balance of at least `amount`.
531      */
532     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
533         require(sender != address(0), "ERC20: transfer from the zero address");
534         require(recipient != address(0), "ERC20: transfer to the zero address");
535 
536         _beforeTokenTransfer(sender, recipient, amount);
537 
538         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
539         _balances[recipient] = _balances[recipient].add(amount);
540         emit Transfer(sender, recipient, amount);
541     }
542 
543     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
544      * the total supply.
545      *
546      * Emits a {Transfer} event with `from` set to the zero address.
547      *
548      * Requirements:
549      *
550      * - `to` cannot be the zero address.
551      */
552     function _mint(address account, uint256 amount) internal virtual {
553         require(account != address(0), "ERC20: mint to the zero address");
554 
555         _beforeTokenTransfer(address(0), account, amount);
556 
557         _totalSupply = _totalSupply.add(amount);
558         _balances[account] = _balances[account].add(amount);
559         emit Transfer(address(0), account, amount);
560     }
561 
562     /**
563      * @dev Destroys `amount` tokens from `account`, reducing the
564      * total supply.
565      *
566      * Emits a {Transfer} event with `to` set to the zero address.
567      *
568      * Requirements:
569      *
570      * - `account` cannot be the zero address.
571      * - `account` must have at least `amount` tokens.
572      */
573     function _burn(address account, uint256 amount) internal virtual {
574         require(account != address(0), "ERC20: burn from the zero address");
575 
576         _beforeTokenTransfer(account, address(0), amount);
577 
578         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
579         _totalSupply = _totalSupply.sub(amount);
580         emit Transfer(account, address(0), amount);
581     }
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
585      *
586      * This internal function is equivalent to `approve`, and can be used to
587      * e.g. set automatic allowances for certain subsystems, etc.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `owner` cannot be the zero address.
594      * - `spender` cannot be the zero address.
595      */
596     function _approve(address owner, address spender, uint256 amount) internal virtual {
597         require(owner != address(0), "ERC20: approve from the zero address");
598         require(spender != address(0), "ERC20: approve to the zero address");
599 
600         _allowances[owner][spender] = amount;
601         emit Approval(owner, spender, amount);
602     }
603 
604     /**
605      * @dev Sets {decimals} to a value other than the default one of 18.
606      *
607      * WARNING: This function should only be called from the constructor. Most
608      * applications that interact with token contracts will not expect
609      * {decimals} to ever change, and may work incorrectly if it does.
610      */
611     function _setupDecimals(uint8 decimals_) internal {
612         _decimals = decimals_;
613     }
614 
615     /**
616      * @dev Hook that is called before any transfer of tokens. This includes
617      * minting and burning.
618      *
619      * Calling conditions:
620      *
621      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
622      * will be to transferred to `to`.
623      * - when `from` is zero, `amount` tokens will be minted for `to`.
624      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
625      * - `from` and `to` are never both zero.
626      *
627      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
628      */
629     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
633 
634 /**
635  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
636  */
637 abstract contract ERC20Capped is ERC20 {
638     using SafeMath for uint256;
639 
640     uint256 private _cap;
641 
642     /**
643      * @dev Sets the value of the `cap`. This value is immutable, it can only be
644      * set once during construction.
645      */
646     constructor (uint256 cap_) {
647         require(cap_ > 0, "ERC20Capped: cap is 0");
648         _cap = cap_;
649     }
650 
651     /**
652      * @dev Returns the cap on the token's total supply.
653      */
654     function cap() public view returns (uint256) {
655         return _cap;
656     }
657 
658     /**
659      * @dev See {ERC20-_beforeTokenTransfer}.
660      *
661      * Requirements:
662      *
663      * - minted tokens must not cause the total supply to go over the cap.
664      */
665     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
666         super._beforeTokenTransfer(from, to, amount);
667 
668         if (from == address(0)) { // When minting tokens
669             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
670         }
671     }
672 }
673 
674 
675 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
676 
677 /**
678  * @title ERC20Mintable
679  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
680  */
681 abstract contract ERC20Mintable is ERC20 {
682 
683     // indicates if minting is finished
684     bool private _mintingFinished = false;
685 
686     /**
687      * @dev Emitted during finish minting
688      */
689     event MintFinished();
690 
691     /**
692      * @dev Tokens can be minted only before minting finished.
693      */
694     modifier canMint() {
695         require(!_mintingFinished, "ERC20Mintable: minting is finished");
696         _;
697     }
698 
699     /**
700      * @return if minting is finished or not.
701      */
702     function mintingFinished() public view returns (bool) {
703         return _mintingFinished;
704     }
705 
706     /**
707      * @dev Function to mint tokens.
708      *
709      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
710      *
711      * @param account The address that will receive the minted tokens
712      * @param amount The amount of tokens to mint
713      */
714     function mint(address account, uint256 amount) public canMint {
715         _mint(account, amount);
716     }
717 
718     /**
719      * @dev Function to stop minting new tokens.
720      *
721      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
722      */
723     function finishMinting() public canMint {
724         _finishMinting();
725     }
726 
727     /**
728      * @dev Function to stop minting new tokens.
729      */
730     function _finishMinting() internal virtual {
731         _mintingFinished = true;
732 
733         emit MintFinished();
734     }
735 }
736 
737 
738 /**
739  * @title ShoppingIO
740  * @dev Implementation of the ShoppingIO
741  */
742 contract ShoppingIO is ERC20Capped, ERC20Mintable, Ownable {
743 
744     constructor (
745         string memory name,
746         string memory symbol,
747         uint8 decimals,
748         uint256 cap,
749         uint256 initialBalance
750     )
751         ERC20(name, symbol)
752         ERC20Capped(cap)
753     {
754         _setupDecimals(decimals);
755         _mint(_msgSender(), initialBalance);
756     }
757 
758     /**
759      * @dev Function to mint tokens.
760      *
761      * NOTE: restricting access to owner only. See {ERC20Mintable-mint}.
762      *
763      * @param account The address that will receive the minted tokens
764      * @param amount The amount of tokens to mint
765      */
766     function _mint(address account, uint256 amount) internal override onlyOwner {
767         super._mint(account, amount);
768     }
769 
770     /**
771      * @dev Function to stop minting new tokens.
772      *
773      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
774      */
775     function _finishMinting() internal override onlyOwner {
776         super._finishMinting();
777     }
778 
779     /**
780      * @dev See {ERC20-_beforeTokenTransfer}. See {ERC20Capped-_beforeTokenTransfer}.
781      */
782     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Capped) {
783         super._beforeTokenTransfer(from, to, amount);
784     }
785 }