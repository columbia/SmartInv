1 /*
2 Telegram: https://t.me/LinqBotETH
3 
4 Website:  https://linqbot.org
5 
6 Twitter:  https://twitter.com/LinqBot
7 
8 Bot:      https://t.me/Linq_App_Bot
9 */ 
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.6;
13 
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, reverting on
17      * overflow.
18      *
19      * Counterpart to Solidity's `+` operator.
20      *
21      * Requirements:
22      *
23      * - Addition cannot overflow.
24      */
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, reverting on
34      * overflow (when the result is negative).
35      *
36      * Counterpart to Solidity's `-` operator.
37      *
38      * Requirements:
39      *
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      *
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the multiplication of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `*` operator.
68      *
69      * Requirements:
70      *
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      *
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      *
113      * - The divisor cannot be zero.
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
125      * Reverts when dividing by zero.
126      *
127      * Counterpart to Solidity's `%` operator. This function uses a `revert`
128      * opcode (which leaves remaining gas untouched) while Solidity uses an
129      * invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b != 0, errorMessage);
153         return a % b;
154     }
155 }
156 
157 /**
158  * @title SafeMathInt
159  * @dev Math operations for int256 with overflow safety checks.
160  */
161 library SafeMathInt {
162     int256 private constant MIN_INT256 = int256(1) << 255;
163     int256 private constant MAX_INT256 = ~(int256(1) << 255);
164 
165     /**
166      * @dev Multiplies two int256 variables and fails on overflow.
167      */
168     function mul(int256 a, int256 b) internal pure returns (int256) {
169         int256 c = a * b;
170 
171         // Detect overflow when multiplying MIN_INT256 with -1
172         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
173         require((b == 0) || (c / b == a));
174         return c;
175     }
176 
177     /**
178      * @dev Division of two int256 variables and fails on overflow.
179      */
180     function div(int256 a, int256 b) internal pure returns (int256) {
181         // Prevent overflow when dividing MIN_INT256 by -1
182         require(b != -1 || a != MIN_INT256);
183 
184         // Solidity already throws when dividing by 0.
185         return a / b;
186     }
187 
188     /**
189      * @dev Subtracts two int256 variables and fails on overflow.
190      */
191     function sub(int256 a, int256 b) internal pure returns (int256) {
192         int256 c = a - b;
193         require((b >= 0 && c <= a) || (b < 0 && c > a));
194         return c;
195     }
196 
197     /**
198      * @dev Adds two int256 variables and fails on overflow.
199      */
200     function add(int256 a, int256 b) internal pure returns (int256) {
201         int256 c = a + b;
202         require((b >= 0 && c >= a) || (b < 0 && c < a));
203         return c;
204     }
205 
206     /**
207      * @dev Converts to absolute value, and fails on overflow.
208      */
209     function abs(int256 a) internal pure returns (int256) {
210         require(a != MIN_INT256);
211         return a < 0 ? -a : a;
212     }
213 
214 
215     function toUint256Safe(int256 a) internal pure returns (uint256) {
216         require(a >= 0);
217         return uint256(a);
218     }
219 }
220 
221 /**
222  * @title SafeMathUint
223  * @dev Math operations with safety checks that revert on error
224  */
225 library SafeMathUint {
226   function toInt256Safe(uint256 a) internal pure returns (int256) {
227     int256 b = int256(a);
228     require(b >= 0);
229     return b;
230   }
231 }
232 
233 /**
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 abstract contract Context {
244     function _msgSender() internal view virtual returns (address) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view virtual returns (bytes calldata) {
249         return msg.data;
250     }
251 }
252 
253 /**
254  * @dev Interface of the ERC20 standard as defined in the EIP.
255  */
256 interface IERC20 {
257     /**
258      * @dev Emitted when `value` tokens are moved from one account (`from`) to
259      * another (`to`).
260      *
261      * Note that `value` may be zero.
262      */
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 
265     /**
266      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
267      * a call to {approve}. `value` is the new allowance.
268      */
269     event Approval(address indexed owner, address indexed spender, uint256 value);
270 
271     /**
272      * @dev Returns the amount of tokens in existence.
273      */
274     function totalSupply() external view returns (uint256);
275 
276     /**
277      * @dev Returns the amount of tokens owned by `account`.
278      */
279     function balanceOf(address account) external view returns (uint256);
280 
281     /**
282      * @dev Moves `amount` tokens from the caller's account to `to`.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * Emits a {Transfer} event.
287      */
288     function transfer(address to, uint256 amount) external returns (bool);
289 
290     /**
291      * @dev Returns the remaining number of tokens that `spender` will be
292      * allowed to spend on behalf of `owner` through {transferFrom}. This is
293      * zero by default.
294      *
295      * This value changes when {approve} or {transferFrom} are called.
296      */
297     function allowance(address owner, address spender) external view returns (uint256);
298 
299     /**
300      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * IMPORTANT: Beware that changing an allowance with this method brings the risk
305      * that someone may use both the old and the new allowance by unfortunate
306      * transaction ordering. One possible solution to mitigate this race
307      * condition is to first reduce the spender's allowance to 0 and set the
308      * desired value afterwards:
309      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310      *
311      * Emits an {Approval} event.
312      */
313     function approve(address spender, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Moves `amount` tokens from `from` to `to` using the
317      * allowance mechanism. `amount` is then deducted from the caller's
318      * allowance.
319      *
320      * Returns a boolean value indicating whether the operation succeeded.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transferFrom(address from, address to, uint256 amount) external returns (bool);
325 }
326 
327 /**
328  * @dev Contract module which provides a basic access control mechanism, where
329  * there is an account (an owner) that can be granted exclusive access to
330  * specific functions.
331  *
332  * By default, the owner account will be the one that deploys the contract. This
333  * can later be changed with {transferOwnership}.
334  *
335  * This module is used through inheritance. It will make available the modifier
336  * `onlyOwner`, which can be applied to your functions to restrict their use to
337  * the owner.
338  */
339 abstract contract Ownable is Context {
340     address private _owner;
341 
342     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
343 
344     /**
345      * @dev Initializes the contract setting the deployer as the initial owner.
346      */
347     constructor() {
348         _transferOwnership(_msgSender());
349     }
350 
351     /**
352      * @dev Throws if called by any account other than the owner.
353      */
354     modifier onlyOwner() {
355         _checkOwner();
356         _;
357     }
358 
359     /**
360      * @dev Returns the address of the current owner.
361      */
362     function owner() public view virtual returns (address) {
363         return _owner;
364     }
365 
366     /**
367      * @dev Throws if the sender is not the owner.
368      */
369     function _checkOwner() internal view virtual {
370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
371     }
372 
373     /**
374      * @dev Leaves the contract without owner. It will not be possible to call
375      * `onlyOwner` functions. Can only be called by the current owner.
376      *
377      * NOTE: Renouncing ownership will leave the contract without an owner,
378      * thereby disabling any functionality that is only available to the owner.
379      */
380     function renounceOwnership() public virtual onlyOwner {
381         _transferOwnership(address(0));
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Can only be called by the current owner.
387      */
388     function transferOwnership(address newOwner) public virtual onlyOwner {
389         require(newOwner != address(0), "Ownable: new owner is the zero address");
390         _transferOwnership(newOwner);
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Internal function without access restriction.
396      */
397     function _transferOwnership(address newOwner) internal virtual {
398         address oldOwner = _owner;
399         _owner = newOwner;
400         emit OwnershipTransferred(oldOwner, newOwner);
401     }
402 }
403 
404 /**
405  * @dev Interface for the optional metadata functions from the ERC20 standard.
406  *
407  * _Available since v4.1._
408  */
409 interface IERC20Metadata is IERC20 {
410     /**
411      * @dev Returns the name of the token.
412      */
413     function name() external view returns (string memory);
414 
415     /**
416      * @dev Returns the symbol of the token.
417      */
418     function symbol() external view returns (string memory);
419 
420     /**
421      * @dev Returns the decimals places of the token.
422      */
423     function decimals() external view returns (uint8);
424 }
425 
426 /**
427  * @dev Implementation of the {IERC20} interface.
428  *
429  * This implementation is agnostic to the way tokens are created. This means
430  * that a supply mechanism has to be added in a derived contract using {_mint}.
431  * For a generic mechanism see {ERC20PresetMinterPauser}.
432  *
433  * TIP: For a detailed writeup see our guide
434  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
435  * to implement supply mechanisms].
436  *
437  * The default value of {decimals} is 18. To change this, you should override
438  * this function so it returns a different value.
439  *
440  * We have followed general OpenZeppelin Contracts guidelines: functions revert
441  * instead returning `false` on failure. This behavior is nonetheless
442  * conventional and does not conflict with the expectations of ERC20
443  * applications.
444  *
445  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
446  * This allows applications to reconstruct the allowance for all accounts just
447  * by listening to said events. Other implementations of the EIP may not emit
448  * these events, as it isn't required by the specification.
449  *
450  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
451  * functions have been added to mitigate the well-known issues around setting
452  * allowances. See {IERC20-approve}.
453  */
454 contract ERC20 is Context, IERC20, IERC20Metadata {
455     mapping(address => uint256) private _balances;
456 
457     mapping(address => mapping(address => uint256)) private _allowances;
458 
459     uint256 private _totalSupply;
460 
461     string private _name;
462     string private _symbol;
463 
464     /**
465      * @dev Sets the values for {name} and {symbol}.
466      *
467      * All two of these values are immutable: they can only be set once during
468      * construction.
469      */
470     constructor(string memory name_, string memory symbol_) {
471         _name = name_;
472         _symbol = symbol_;
473     }
474 
475     /**
476      * @dev Returns the name of the token.
477      */
478     function name() public view virtual override returns (string memory) {
479         return _name;
480     }
481 
482     /**
483      * @dev Returns the symbol of the token, usually a shorter version of the
484      * name.
485      */
486     function symbol() public view virtual override returns (string memory) {
487         return _symbol;
488     }
489 
490     /**
491      * @dev Returns the number of decimals used to get its user representation.
492      * For example, if `decimals` equals `2`, a balance of `505` tokens should
493      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
494      *
495      * Tokens usually opt for a value of 18, imitating the relationship between
496      * Ether and Wei. This is the default value returned by this function, unless
497      * it's overridden.
498      *
499      * NOTE: This information is only used for _display_ purposes: it in
500      * no way affects any of the arithmetic of the contract, including
501      * {IERC20-balanceOf} and {IERC20-transfer}.
502      */
503     function decimals() public view virtual override returns (uint8) {
504         return 18;
505     }
506 
507     /**
508      * @dev See {IERC20-totalSupply}.
509      */
510     function totalSupply() public view virtual override returns (uint256) {
511         return _totalSupply;
512     }
513 
514     /**
515      * @dev See {IERC20-balanceOf}.
516      */
517     function balanceOf(address account) public view virtual override returns (uint256) {
518         return _balances[account];
519     }
520 
521     /**
522      * @dev See {IERC20-transfer}.
523      *
524      * Requirements:
525      *
526      * - `to` cannot be the zero address.
527      * - the caller must have a balance of at least `amount`.
528      */
529     function transfer(address to, uint256 amount) public virtual override returns (bool) {
530         address owner = _msgSender();
531         _transfer(owner, to, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-allowance}.
537      */
538     function allowance(address owner, address spender) public view virtual override returns (uint256) {
539         return _allowances[owner][spender];
540     }
541 
542     /**
543      * @dev See {IERC20-approve}.
544      *
545      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
546      * `transferFrom`. This is semantically equivalent to an infinite approval.
547      *
548      * Requirements:
549      *
550      * - `spender` cannot be the zero address.
551      */
552     function approve(address spender, uint256 amount) public virtual override returns (bool) {
553         address owner = _msgSender();
554         _approve(owner, spender, amount);
555         return true;
556     }
557 
558     /**
559      * @dev See {IERC20-transferFrom}.
560      *
561      * Emits an {Approval} event indicating the updated allowance. This is not
562      * required by the EIP. See the note at the beginning of {ERC20}.
563      *
564      * NOTE: Does not update the allowance if the current allowance
565      * is the maximum `uint256`.
566      *
567      * Requirements:
568      *
569      * - `from` and `to` cannot be the zero address.
570      * - `from` must have a balance of at least `amount`.
571      * - the caller must have allowance for ``from``'s tokens of at least
572      * `amount`.
573      */
574     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
575         address spender = _msgSender();
576         _spendAllowance(from, spender, amount);
577         _transfer(from, to, amount);
578         return true;
579     }
580 
581     /**
582      * @dev Atomically increases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to {approve} that can be used as a mitigation for
585      * problems described in {IERC20-approve}.
586      *
587      * Emits an {Approval} event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      */
593     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
594         address owner = _msgSender();
595         _approve(owner, spender, allowance(owner, spender) + addedValue);
596         return true;
597     }
598 
599     /**
600      * @dev Atomically decreases the allowance granted to `spender` by the caller.
601      *
602      * This is an alternative to {approve} that can be used as a mitigation for
603      * problems described in {IERC20-approve}.
604      *
605      * Emits an {Approval} event indicating the updated allowance.
606      *
607      * Requirements:
608      *
609      * - `spender` cannot be the zero address.
610      * - `spender` must have allowance for the caller of at least
611      * `subtractedValue`.
612      */
613     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
614         address owner = _msgSender();
615         uint256 currentAllowance = allowance(owner, spender);
616         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
617         unchecked {
618             _approve(owner, spender, currentAllowance - subtractedValue);
619         }
620 
621         return true;
622     }
623 
624     /**
625      * @dev Moves `amount` of tokens from `from` to `to`.
626      *
627      * This internal function is equivalent to {transfer}, and can be used to
628      * e.g. implement automatic token fees, slashing mechanisms, etc.
629      *
630      * Emits a {Transfer} event.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `from` must have a balance of at least `amount`.
637      */
638     function _transfer(address from, address to, uint256 amount) internal virtual {
639         require(from != address(0), "ERC20: transfer from the zero address");
640         require(to != address(0), "ERC20: transfer to the zero address");
641 
642         _beforeTokenTransfer(from, to, amount);
643 
644         uint256 fromBalance = _balances[from];
645         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
646         unchecked {
647             _balances[from] = fromBalance - amount;
648             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
649             // decrementing then incrementing.
650             _balances[to] += amount;
651         }
652 
653         emit Transfer(from, to, amount);
654 
655         _afterTokenTransfer(from, to, amount);
656     }
657 
658     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
659      * the total supply.
660      *
661      * Emits a {Transfer} event with `from` set to the zero address.
662      *
663      * Requirements:
664      *
665      * - `account` cannot be the zero address.
666      */
667     function _mint(address account, uint256 amount) internal virtual {
668         require(account != address(0), "ERC20: mint to the zero address");
669 
670         _beforeTokenTransfer(address(0), account, amount);
671 
672         _totalSupply += amount;
673         unchecked {
674             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
675             _balances[account] += amount;
676         }
677         emit Transfer(address(0), account, amount);
678 
679         _afterTokenTransfer(address(0), account, amount);
680     }
681 
682     /**
683      * @dev Destroys `amount` tokens from `account`, reducing the
684      * total supply.
685      *
686      * Emits a {Transfer} event with `to` set to the zero address.
687      *
688      * Requirements:
689      *
690      * - `account` cannot be the zero address.
691      * - `account` must have at least `amount` tokens.
692      */
693     function _burn(address account, uint256 amount) internal virtual {
694         require(account != address(0), "ERC20: burn from the zero address");
695 
696         _beforeTokenTransfer(account, address(0), amount);
697 
698         uint256 accountBalance = _balances[account];
699         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
700         unchecked {
701             _balances[account] = accountBalance - amount;
702             // Overflow not possible: amount <= accountBalance <= totalSupply.
703             _totalSupply -= amount;
704         }
705 
706         emit Transfer(account, address(0), amount);
707 
708         _afterTokenTransfer(account, address(0), amount);
709     }
710 
711     /**
712      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
713      *
714      * This internal function is equivalent to `approve`, and can be used to
715      * e.g. set automatic allowances for certain subsystems, etc.
716      *
717      * Emits an {Approval} event.
718      *
719      * Requirements:
720      *
721      * - `owner` cannot be the zero address.
722      * - `spender` cannot be the zero address.
723      */
724     function _approve(address owner, address spender, uint256 amount) internal virtual {
725         require(owner != address(0), "ERC20: approve from the zero address");
726         require(spender != address(0), "ERC20: approve to the zero address");
727 
728         _allowances[owner][spender] = amount;
729         emit Approval(owner, spender, amount);
730     }
731 
732     /**
733      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
734      *
735      * Does not update the allowance amount in case of infinite allowance.
736      * Revert if not enough allowance is available.
737      *
738      * Might emit an {Approval} event.
739      */
740     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
741         uint256 currentAllowance = allowance(owner, spender);
742         if (currentAllowance != type(uint256).max) {
743             require(currentAllowance >= amount, "ERC20: insufficient allowance");
744             unchecked {
745                 _approve(owner, spender, currentAllowance - amount);
746             }
747         }
748     }
749 
750     /**
751      * @dev Hook that is called before any transfer of tokens. This includes
752      * minting and burning.
753      *
754      * Calling conditions:
755      *
756      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
757      * will be transferred to `to`.
758      * - when `from` is zero, `amount` tokens will be minted for `to`.
759      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
760      * - `from` and `to` are never both zero.
761      *
762      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
763      */
764     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
765 
766     /**
767      * @dev Hook that is called after any transfer of tokens. This includes
768      * minting and burning.
769      *
770      * Calling conditions:
771      *
772      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
773      * has been transferred to `to`.
774      * - when `from` is zero, `amount` tokens have been minted for `to`.
775      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
776      * - `from` and `to` are never both zero.
777      *
778      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
779      */
780     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
781 }
782 
783 interface DividendPayingTokenInterface {
784   /// @notice View the amount of dividend in wei that an address can withdraw.
785   /// @param _owner The address of a token holder.
786   /// @return The amount of dividend in wei that `_owner` can withdraw.
787   function dividendOf(address _owner) external view returns(uint256);
788 
789   /// @notice Withdraws the ether distributed to the sender.
790   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
791   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
792   function withdrawDividend() external;
793   
794   /// @notice View the amount of dividend in wei that an address can withdraw.
795   /// @param _owner The address of a token holder.
796   /// @return The amount of dividend in wei that `_owner` can withdraw.
797   function withdrawableDividendOf(address _owner) external view returns(uint256);
798 
799   /// @notice View the amount of dividend in wei that an address has withdrawn.
800   /// @param _owner The address of a token holder.
801   /// @return The amount of dividend in wei that `_owner` has withdrawn.
802   function withdrawnDividendOf(address _owner) external view returns(uint256);
803 
804   /// @notice View the amount of dividend in wei that an address has earned in total.
805   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
806   /// @param _owner The address of a token holder.
807   /// @return The amount of dividend in wei that `_owner` has earned in total.
808   function accumulativeDividendOf(address _owner) external view returns(uint256);
809 
810 
811   /// @dev This event MUST emit when ether is distributed to token holders.
812   /// @param from The address which sends ether to this contract.
813   /// @param weiAmount The amount of distributed ether in wei.
814   event DividendsDistributed(
815     address indexed from,
816     uint256 weiAmount
817   );
818 
819   /// @dev This event MUST emit when an address withdraws their dividend.
820   /// @param to The address which withdraws ether from this contract.
821   /// @param weiAmount The amount of withdrawn ether in wei.
822   event DividendWithdrawn(
823     address indexed to,
824     uint256 weiAmount
825   );
826   
827 }
828 
829 interface IPair {
830     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
831     function token0() external view returns (address);
832 
833 }
834 
835 interface IFactory{
836         function createPair(address tokenA, address tokenB) external returns (address pair);
837         function getPair(address tokenA, address tokenB) external view returns (address pair);
838 }
839 
840 interface IUniswapRouter {
841     function factory() external pure returns (address);
842     function WETH() external pure returns (address);
843     function addLiquidityETH(
844         address token,
845         uint amountTokenDesired,
846         uint amountTokenMin,
847         uint amountETHMin,
848         address to,
849         uint deadline
850     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
851     
852     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
853         uint amountIn,
854         uint amountOutMin,
855         address[] calldata path,
856         address to,
857         uint deadline
858     ) external;
859     
860     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
861         external
862         payable
863         returns (uint[] memory amounts);
864     
865     function swapExactTokensForETHSupportingFeeOnTransferTokens(
866         uint amountIn,
867         uint amountOutMin,
868         address[] calldata path,
869         address to,
870         uint deadline) external;
871 }
872 
873 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, Ownable {
874 
875   using SafeMath for uint256;
876   using SafeMathUint for uint256;
877   using SafeMathInt for int256;
878 
879   address public LP_Token;
880 
881 
882   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
883   // For more discussion about choosing the value of `magnitude`,
884   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
885   uint256 constant internal magnitude = 2**128;
886 
887   uint256 internal magnifiedDividendPerShare;
888 
889   // About dividendCorrection:
890   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
891   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
892   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
893   //   `dividendOf(_user)` should not be changed,
894   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
895   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
896   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
897   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
898   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
899   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
900   mapping(address => int256) internal magnifiedDividendCorrections;
901   mapping(address => uint256) internal withdrawnDividends;
902 
903   uint256 public totalDividendsDistributed;
904   uint256 public totalDividendsWithdrawn;
905 
906   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
907 
908   function distributeLPDividends(uint256 amount) public onlyOwner{
909     require(totalSupply() > 0);
910 
911     if (amount > 0) {
912       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
913         (amount).mul(magnitude) / totalSupply()
914       );
915       emit DividendsDistributed(msg.sender, amount);
916 
917       totalDividendsDistributed = totalDividendsDistributed.add(amount);
918     }
919   }
920 
921   /// @notice Withdraws the ether distributed to the sender.
922   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
923   function withdrawDividend() public virtual override {
924     _withdrawDividendOfUser(payable(msg.sender));
925   }
926 
927   /// @notice Withdraws the ether distributed to the sender.
928   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
929  function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
930     uint256 _withdrawableDividend = withdrawableDividendOf(user);
931     if (_withdrawableDividend > 0) {
932       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
933       totalDividendsWithdrawn += _withdrawableDividend;
934       emit DividendWithdrawn(user, _withdrawableDividend);
935       bool success = IERC20(LP_Token).transfer(user, _withdrawableDividend);
936 
937       if(!success) {
938         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
939         totalDividendsWithdrawn -= _withdrawableDividend;
940         return 0;
941       }
942 
943       return _withdrawableDividend;
944     }
945 
946     return 0;
947   }
948 
949   /// @notice View the amount of dividend in wei that an address can withdraw.
950   /// @param _owner The address of a token holder.
951   /// @return The amount of dividend in wei that `_owner` can withdraw.
952   function dividendOf(address _owner) public view override returns(uint256) {
953     return withdrawableDividendOf(_owner);
954   }
955 
956   /// @notice View the amount of dividend in wei that an address can withdraw.
957   /// @param _owner The address of a token holder.
958   /// @return The amount of dividend in wei that `_owner` can withdraw.
959   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
960     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
961   }
962 
963   /// @notice View the amount of dividend in wei that an address has withdrawn.
964   /// @param _owner The address of a token holder.
965   /// @return The amount of dividend in wei that `_owner` has withdrawn.
966   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
967     return withdrawnDividends[_owner];
968   }
969 
970 
971   /// @notice View the amount of dividend in wei that an address has earned in total.
972   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
973   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
974   /// @param _owner The address of a token holder.
975   /// @return The amount of dividend in wei that `_owner` has earned in total.
976   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
977     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
978       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
979   }
980 
981   /// @dev Internal function that transfer tokens from one address to another.
982   /// Update magnifiedDividendCorrections to keep dividends unchanged.
983   /// @param from The address to transfer from.
984   /// @param to The address to transfer to.
985   /// @param value The amount to be transferred.
986   function _transfer(address from, address to, uint256 value) internal virtual override {
987     require(false);
988 
989     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
990     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
991     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
992   }
993 
994   /// @dev Internal function that mints tokens to an account.
995   /// Update magnifiedDividendCorrections to keep dividends unchanged.
996   /// @param account The account that will receive the created tokens.
997   /// @param value The amount that will be created.
998   function _mint(address account, uint256 value) internal override {
999     super._mint(account, value);
1000 
1001     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1002       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1003   }
1004 
1005   /// @dev Internal function that burns an amount of the token of a given account.
1006   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1007   /// @param account The account whose tokens will be burnt.
1008   /// @param value The amount that will be burnt.
1009   function _burn(address account, uint256 value) internal override {
1010     super._burn(account, value);
1011 
1012     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1013       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1014   }
1015 
1016   function _setBalance(address account, uint256 newBalance) internal {
1017     uint256 currentBalance = balanceOf(account);
1018 
1019     if(newBalance > currentBalance) {
1020       uint256 mintAmount = newBalance.sub(currentBalance);
1021       _mint(account, mintAmount);
1022     } else if(newBalance < currentBalance) {
1023       uint256 burnAmount = currentBalance.sub(newBalance);
1024       _burn(account, burnAmount);
1025     }
1026   }
1027 }
1028 
1029 contract LinqBot is ERC20, Ownable {
1030     IUniswapRouter public router;
1031     address public pair;
1032 
1033     bool private swapping;
1034     bool public swapEnabled = true;
1035     bool public claimEnabled;
1036     bool public tradingEnabled;
1037 
1038     LinqBotDividendTracker public dividendTracker;
1039 
1040     address public devWallet;
1041 
1042     uint256 public swapTokensAtAmount;
1043     uint256 public maxBuyAmount;
1044     uint256 public maxSellAmount;
1045     uint256 public maxWallet;
1046 
1047     struct Taxes {
1048         uint256 liquidity;
1049         uint256 dev;
1050     }
1051 
1052     Taxes public buyTaxes = Taxes(10, 10);
1053     Taxes public sellTaxes = Taxes(10, 10);
1054 
1055     uint256 public totalBuyTax = 20;
1056     uint256 public totalSellTax = 20;
1057 
1058     mapping(address => bool) public _isBot;
1059 
1060     mapping(address => bool) private _isExcludedFromFees;
1061     mapping(address => bool) public automatedMarketMakerPairs;
1062     mapping(address => bool) private _isExcludedFromMaxWallet;
1063 
1064     ///////////////
1065     //   Events  //
1066     ///////////////
1067 
1068     event ExcludeFromFees(address indexed account, bool isExcluded);
1069     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1070     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1071     event GasForProcessingUpdated(
1072         uint256 indexed newValue,
1073         uint256 indexed oldValue
1074     );
1075     event SendDividends(uint256 tokensSwapped, uint256 amount);
1076     event ProcessedDividendTracker(
1077         uint256 iterations,
1078         uint256 claims,
1079         uint256 lastProcessedIndex,
1080         bool indexed automatic,
1081         uint256 gas,
1082         address indexed processor
1083     );
1084 
1085     constructor(address _developerwallet) ERC20("LinqBot", "LinqB") {
1086         dividendTracker = new LinqBotDividendTracker();
1087         setDevWallet(_developerwallet);
1088 
1089         IUniswapRouter _router = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1090         address _pair = IFactory(_router.factory()).createPair(
1091             address(this),
1092             _router.WETH()
1093         );
1094 
1095         router = _router;
1096         pair = _pair;
1097         setSwapTokensAtAmount(200000); 
1098         updateMaxWalletAmount(1000000);
1099         setMaxBuyAndSell(500000, 500000);
1100 
1101         _setAutomatedMarketMakerPair(_pair, true);
1102 
1103         dividendTracker.updateLP_Token(pair);
1104 
1105         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1106         dividendTracker.excludeFromDividends(address(this), true);
1107         dividendTracker.excludeFromDividends(owner(), true);
1108         dividendTracker.excludeFromDividends(address(0xdead), true);
1109         dividendTracker.excludeFromDividends(address(_router), true);
1110 
1111         excludeFromMaxWallet(address(_pair), true);
1112         excludeFromMaxWallet(address(this), true);
1113         excludeFromMaxWallet(address(_router), true);
1114 
1115         excludeFromFees(owner(), true);
1116         excludeFromFees(address(this), true);
1117 
1118         _mint(owner(), 100000000 * (10**18));
1119     }
1120 
1121     receive() external payable {}
1122 
1123     function updateDividendTracker(address newAddress) public onlyOwner {
1124         LinqBotDividendTracker newDividendTracker = LinqBotDividendTracker(
1125             payable(newAddress)
1126         );
1127         newDividendTracker.excludeFromDividends(
1128             address(newDividendTracker),
1129             true
1130         );
1131         newDividendTracker.excludeFromDividends(address(this), true);
1132         newDividendTracker.excludeFromDividends(owner(), true);
1133         newDividendTracker.excludeFromDividends(address(router), true);
1134         dividendTracker = newDividendTracker;
1135     }
1136 
1137     /// @notice Manual claim the dividends
1138     function claim() external {
1139         require(claimEnabled, "Claim not enabled");
1140         dividendTracker.processAccount(payable(msg.sender));
1141     }
1142 
1143     function updateMaxWalletAmount(uint256 newNum) public onlyOwner {
1144         require(newNum >= 1000000, "Cannot set maxWallet lower than 1%");
1145         maxWallet = newNum * 10**18;
1146     }
1147 
1148     function setMaxBuyAndSell(uint256 maxBuy, uint256 maxSell)
1149         public
1150         onlyOwner
1151     {
1152         require(maxBuy >= 500000, "Cannot set maxbuy lower than 0.5% ");
1153         require(maxSell >= 500000, "Cannot set maxsell lower than 0.5% ");
1154         maxBuyAmount = maxBuy * 10**18;
1155         maxSellAmount = maxSell * 10**18;
1156     }
1157 
1158     function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
1159         swapTokensAtAmount = amount * 10**18;
1160     }
1161 
1162     function excludeFromMaxWallet(address account, bool excluded)
1163         public
1164         onlyOwner
1165     {
1166         _isExcludedFromMaxWallet[account] = excluded;
1167     }
1168 
1169     /// @notice Withdraw tokens sent by mistake.
1170     /// @param tokenAddress The address of the token to withdraw
1171     function rescueETH20Tokens(address tokenAddress) external onlyOwner {
1172         IERC20(tokenAddress).transfer(
1173             owner(),
1174             IERC20(tokenAddress).balanceOf(address(this))
1175         );
1176     }
1177 
1178     /// @notice Send remaining ETH to dev
1179     /// @dev It will send all ETH to dev
1180     function forceSend() external onlyOwner {
1181         uint256 ETHbalance = address(this).balance;
1182         (bool success, ) = payable(devWallet).call{value: ETHbalance}("");
1183         require(success);
1184     }
1185 
1186     function trackerRescueETH20Tokens(address tokenAddress) external onlyOwner {
1187         dividendTracker.trackerRescueETH20Tokens(msg.sender, tokenAddress);
1188     }
1189 
1190     function updateRouter(address newRouter) external onlyOwner {
1191         router = IUniswapRouter(newRouter);
1192     }
1193 
1194     /////////////////////////////////
1195     // Exclude / Include functions //
1196     /////////////////////////////////
1197 
1198     function excludeFromFees(address account, bool excluded) public onlyOwner {
1199         require(
1200             _isExcludedFromFees[account] != excluded,
1201             "Account is already the value of 'excluded'"
1202         );
1203         _isExcludedFromFees[account] = excluded;
1204 
1205         emit ExcludeFromFees(account, excluded);
1206     }
1207 
1208     /// @dev "true" to exlcude, "false" to include
1209     function excludeFromDividends(address account, bool value)
1210         public
1211         onlyOwner
1212     {
1213         dividendTracker.excludeFromDividends(account, value);
1214     }
1215 
1216     function setDevWallet(address newWallet) public onlyOwner {
1217         devWallet = newWallet;
1218     }
1219 
1220     function setBuyTaxes(uint256 _liquidity, uint256 _dev) external onlyOwner {
1221         require(_liquidity + _dev <= 20, "Fee must be <= 20%");
1222         buyTaxes = Taxes(_liquidity, _dev);
1223         totalBuyTax = _liquidity + _dev;
1224     }
1225 
1226     function setSellTaxes(uint256 _liquidity, uint256 _dev) external onlyOwner {
1227         require(_liquidity + _dev <= 20, "Fee must be <= 20%");
1228         sellTaxes = Taxes(_liquidity, _dev);
1229         totalSellTax = _liquidity + _dev;
1230     }
1231 
1232     /// @notice Enable or disable internal swaps
1233     /// @dev Set "true" to enable internal swaps for liquidity, treasury and dividends
1234     function setSwapEnabled(bool _enabled) external onlyOwner {
1235         swapEnabled = _enabled;
1236     }
1237 
1238     function activateTrading() external onlyOwner {
1239         require(!tradingEnabled, "Trading already enabled");
1240         tradingEnabled = true;
1241     }
1242 
1243     function setClaimEnabled(bool state) external onlyOwner {
1244         claimEnabled = state;
1245     }
1246 
1247     /// @param bot The bot address
1248     /// @param value "true" to blacklist, "false" to unblacklist
1249     function setBot(address bot, bool value) external onlyOwner {
1250         require(_isBot[bot] != value);
1251         _isBot[bot] = value;
1252     }
1253 
1254     function setLP_Token(address _lpToken) external onlyOwner {
1255         dividendTracker.updateLP_Token(_lpToken);
1256     }
1257 
1258     /// @dev Set new pairs created due to listing in new DEX
1259     function setAutomatedMarketMakerPair(address newPair, bool value)
1260         external
1261         onlyOwner
1262     {
1263         _setAutomatedMarketMakerPair(newPair, value);
1264     }
1265 
1266     function _setAutomatedMarketMakerPair(address newPair, bool value) private {
1267         require(
1268             automatedMarketMakerPairs[newPair] != value,
1269             "Automated market maker pair is already set to that value"
1270         );
1271         automatedMarketMakerPairs[newPair] = value;
1272 
1273         if (value) {
1274             dividendTracker.excludeFromDividends(newPair, true);
1275         }
1276 
1277         emit SetAutomatedMarketMakerPair(newPair, value);
1278     }
1279 
1280     //////////////////////
1281     // Getter Functions //
1282     //////////////////////
1283 
1284     function getTotalDividendsDistributed() external view returns (uint256) {
1285         return dividendTracker.totalDividendsDistributed();
1286     }
1287 
1288     function isExcludedFromFees(address account) public view returns (bool) {
1289         return _isExcludedFromFees[account];
1290     }
1291 
1292     function withdrawableDividendOf(address account)
1293         public
1294         view
1295         returns (uint256)
1296     {
1297         return dividendTracker.withdrawableDividendOf(account);
1298     }
1299 
1300     function dividendTokenBalanceOf(address account)
1301         public
1302         view
1303         returns (uint256)
1304     {
1305         return dividendTracker.balanceOf(account);
1306     }
1307 
1308     function getAccountInfo(address account)
1309         external
1310         view
1311         returns (
1312             address,
1313             uint256,
1314             uint256,
1315             uint256,
1316             uint256
1317         )
1318     {
1319         return dividendTracker.getAccount(account);
1320     }
1321 
1322     ////////////////////////
1323     // Transfer Functions //
1324     ////////////////////////
1325 
1326     function _transfer(
1327         address from,
1328         address to,
1329         uint256 amount
1330     ) internal override {
1331         require(from != address(0), "ERC20: transfer from the zero address");
1332         require(to != address(0), "ERC20: transfer to the zero address");
1333 
1334         if (
1335             !_isExcludedFromFees[from] && !_isExcludedFromFees[to] && !swapping
1336         ) {
1337             require(tradingEnabled, "Trading not active");
1338             if (automatedMarketMakerPairs[to]) {
1339                 require(
1340                     amount <= maxSellAmount,
1341                     "You are exceeding maxSellAmount"
1342                 );
1343             } else if (automatedMarketMakerPairs[from])
1344                 require(
1345                     amount <= maxBuyAmount,
1346                     "You are exceeding maxBuyAmount"
1347                 );
1348             if (!_isExcludedFromMaxWallet[to]) {
1349                 require(
1350                     amount + balanceOf(to) <= maxWallet,
1351                     "Unable to exceed Max Wallet"
1352                 );
1353             }
1354         }
1355 
1356         if (amount == 0) {
1357             super._transfer(from, to, 0);
1358             return;
1359         }
1360 
1361         uint256 contractTokenBalance = balanceOf(address(this));
1362         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1363 
1364         if (
1365             canSwap &&
1366             !swapping &&
1367             swapEnabled &&
1368             automatedMarketMakerPairs[to] &&
1369             !_isExcludedFromFees[from] &&
1370             !_isExcludedFromFees[to]
1371         ) {
1372             swapping = true;
1373 
1374             if (totalSellTax > 0) {
1375                 swapAndLiquify(swapTokensAtAmount);
1376             }
1377 
1378             swapping = false;
1379         }
1380 
1381         bool takeFee = !swapping;
1382 
1383         // if any account belongs to _isExcludedFromFee account then remove the fee
1384         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1385             takeFee = false;
1386         }
1387 
1388         if (!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from])
1389             takeFee = false;
1390 
1391         if (takeFee) {
1392             uint256 feeAmt;
1393             if (automatedMarketMakerPairs[to])
1394                 feeAmt = (amount * totalSellTax) / 100;
1395             else if (automatedMarketMakerPairs[from])
1396                 feeAmt = (amount * totalBuyTax) / 100;
1397 
1398             amount = amount - feeAmt;
1399             super._transfer(from, address(this), feeAmt);
1400         }
1401         super._transfer(from, to, amount);
1402 
1403         try dividendTracker.setBalance(from, balanceOf(from)) {} catch {}
1404         try dividendTracker.setBalance(to, balanceOf(to)) {} catch {}
1405     }
1406 
1407     function swapAndLiquify(uint256 tokens) private {
1408         uint256 toSwapForLiq = ((tokens * sellTaxes.liquidity) / totalSellTax) / 2;
1409         uint256 tokensToAddLiquidityWith = ((tokens * sellTaxes.liquidity) / totalSellTax) / 2;
1410         uint256 toSwapForDev = (tokens * sellTaxes.dev) / totalSellTax;
1411 
1412         swapTokensForETH(toSwapForLiq);
1413 
1414         uint256 currentbalance = address(this).balance;
1415 
1416         if (currentbalance > 0) {
1417             // Add liquidity to uni
1418             addLiquidity(tokensToAddLiquidityWith, currentbalance);
1419         }
1420 
1421         swapTokensForETH(toSwapForDev);
1422 
1423         uint256 EthTaxBalance = address(this).balance;
1424 
1425         // Send ETH to dev
1426         uint256 devAmt = EthTaxBalance;
1427 
1428         if (devAmt > 0) {
1429             (bool success, ) = payable(devWallet).call{value: devAmt}("");
1430             require(success, "Failed to send ETH to dev wallet");
1431         }
1432 
1433         uint256 lpBalance = IERC20(pair).balanceOf(address(this));
1434 
1435         //Send LP to dividends
1436         uint256 dividends = lpBalance;
1437 
1438         if (dividends > 0) {
1439             bool success = IERC20(pair).transfer(
1440                 address(dividendTracker),
1441                 dividends
1442             );
1443             if (success) {
1444                 dividendTracker.distributeLPDividends(dividends);
1445                 emit SendDividends(tokens, dividends);
1446             }
1447         }
1448     }
1449 
1450     // transfers LP from the owners wallet to holders // must approve this contract, on pair contract before calling
1451     function ManualLiquidityDistribution(uint256 amount) public onlyOwner {
1452         bool success = IERC20(pair).transferFrom(
1453             msg.sender,
1454             address(dividendTracker),
1455             amount
1456         );
1457         if (success) {
1458             dividendTracker.distributeLPDividends(amount);
1459         }
1460     }
1461 
1462     function swapTokensForETH(uint256 tokenAmount) private {
1463         address[] memory path = new address[](2);
1464         path[0] = address(this);
1465         path[1] = router.WETH();
1466 
1467         _approve(address(this), address(router), tokenAmount);
1468 
1469         // make the swap
1470         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1471             tokenAmount,
1472             0, // accept any amount of ETH
1473             path,
1474             address(this),
1475             block.timestamp
1476         );
1477     }
1478 
1479     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1480         // approve token transfer to cover all possible scenarios
1481         _approve(address(this), address(router), tokenAmount);
1482 
1483         // add the liquidity
1484         router.addLiquidityETH{value: ethAmount}(
1485             address(this),
1486             tokenAmount,
1487             0, // slippage is unavoidable
1488             0, // slippage is unavoidable
1489             address(this),
1490             block.timestamp
1491         );
1492     }
1493 }
1494 
1495 contract LinqBotDividendTracker is Ownable, DividendPayingToken {
1496     struct AccountInfo {
1497         address account;
1498         uint256 withdrawableDividends;
1499         uint256 totalDividends;
1500         uint256 lastClaimTime;
1501     }
1502 
1503     mapping(address => bool) public excludedFromDividends;
1504 
1505     mapping(address => uint256) public lastClaimTimes;
1506 
1507     event ExcludeFromDividends(address indexed account, bool value);
1508     event Claim(address indexed account, uint256 amount);
1509 
1510     constructor()
1511         DividendPayingToken("LinqBot_Dividend_Tracker", "LinqBot_Dividend_Tracker")
1512     {}
1513 
1514     function trackerRescueETH20Tokens(address recipient, address tokenAddress)
1515         external
1516         onlyOwner
1517     {
1518         IERC20(tokenAddress).transfer(
1519             recipient,
1520             IERC20(tokenAddress).balanceOf(address(this))
1521         );
1522     }
1523 
1524     function updateLP_Token(address _lpToken) external onlyOwner {
1525         LP_Token = _lpToken;
1526     }
1527 
1528     function _transfer(
1529         address,
1530         address,
1531         uint256
1532     ) internal pure override {
1533         require(false, "LinqBot_Dividend_Tracker: No transfers allowed");
1534     }
1535 
1536     function excludeFromDividends(address account, bool value)
1537         external
1538         onlyOwner
1539     {
1540         require(excludedFromDividends[account] != value);
1541         excludedFromDividends[account] = value;
1542         if (value == true) {
1543             _setBalance(account, 0);
1544         } else {
1545             _setBalance(account, balanceOf(account));
1546         }
1547         emit ExcludeFromDividends(account, value);
1548     }
1549 
1550     function getAccount(address account)
1551         public
1552         view
1553         returns (
1554             address,
1555             uint256,
1556             uint256,
1557             uint256,
1558             uint256
1559         )
1560     {
1561         AccountInfo memory info;
1562         info.account = account;
1563         info.withdrawableDividends = withdrawableDividendOf(account);
1564         info.totalDividends = accumulativeDividendOf(account);
1565         info.lastClaimTime = lastClaimTimes[account];
1566         return (
1567             info.account,
1568             info.withdrawableDividends,
1569             info.totalDividends,
1570             info.lastClaimTime,
1571             totalDividendsWithdrawn
1572         );
1573     }
1574 
1575     function setBalance(address account, uint256 newBalance)
1576         external
1577         onlyOwner
1578     {
1579         if (excludedFromDividends[account]) {
1580             return;
1581         }
1582         _setBalance(account, newBalance);
1583     }
1584 
1585     function processAccount(address payable account)
1586         external
1587         onlyOwner
1588         returns (bool)
1589     {
1590         uint256 amount = _withdrawDividendOfUser(account);
1591 
1592         if (amount > 0) {
1593             lastClaimTimes[account] = block.timestamp;
1594             emit Claim(account, amount);
1595             return true;
1596         }
1597         return false;
1598     }
1599 }