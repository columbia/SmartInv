1 /*FIND THE COLLECTIVE, RETURN TO 
2 
3 ▄▄   ▄▄ ▄▄▄▄▄▄▄ ▄▄    ▄ ▄▄▄   ▄ ▄▄▄▄▄▄▄ 
4 █  █▄█  █       █  █  █ █   █ █ █       █
5 █       █   ▄   █   █▄█ █   █▄█ █    ▄▄▄█
6 █       █  █ █  █       █      ▄█   █▄▄▄ 
7 █       █  █▄█  █  ▄    █     █▄█    ▄▄▄█
8 █ ██▄██ █       █ █ █   █    ▄  █   █▄▄▄ 
9 █▄█   █▄█▄▄▄▄▄▄▄█▄█  █▄▄█▄▄▄█ █▄█▄▄▄▄▄▄▄█  */
10 
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.17;
15 pragma experimental ABIEncoderV2;
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         _checkOwner();
72         _;
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if the sender is not the owner.
84      */
85     function _checkOwner() internal view virtual {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby disabling any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(
106             newOwner != address(0),
107             "Ownable: new owner is the zero address"
108         );
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP.
127  */
128 interface IERC20 {
129     /**
130      * @dev Emitted when `value` tokens are moved from one account (`from`) to
131      * another (`to`).
132      *
133      * Note that `value` may be zero.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 
137     /**
138      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
139      * a call to {approve}. `value` is the new allowance.
140      */
141     event Approval(
142         address indexed owner,
143         address indexed spender,
144         uint256 value
145     );
146 
147     /**
148      * @dev Returns the amount of tokens in existence.
149      */
150     function totalSupply() external view returns (uint256);
151 
152     /**
153      * @dev Returns the amount of tokens owned by `account`.
154      */
155     function balanceOf(address account) external view returns (uint256);
156 
157     /**
158      * @dev Moves `amount` tokens from the caller's account to `to`.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transfer(address to, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Returns the remaining number of tokens that `spender` will be
168      * allowed to spend on behalf of `owner` through {transferFrom}. This is
169      * zero by default.
170      *
171      * This value changes when {approve} or {transferFrom} are called.
172      */
173     function allowance(address owner, address spender)
174         external
175         view
176         returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `from` to `to` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 amount
207     ) external returns (bool);
208 }
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
211 
212 /**
213  * @dev Interface for the optional metadata functions from the ERC20 standard.
214  *
215  * _Available since v4.1._
216  */
217 interface IERC20Metadata is IERC20 {
218     /**
219      * @dev Returns the name of the token.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the symbol of the token.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the decimals places of the token.
230      */
231     function decimals() external view returns (uint8);
232 }
233 
234 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
235 
236 /**
237  * @dev Implementation of the {IERC20} interface.
238  *
239  * This implementation is agnostic to the way tokens are created. This means
240  * that a supply mechanism has to be added in a derived contract using {_mint}.
241  * For a generic mechanism see {ERC20PresetMinterPauser}.
242  *
243  * TIP: For a detailed writeup see our guide
244  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
245  * to implement supply mechanisms].
246  *
247  * The default value of {decimals} is 18. To change this, you should override
248  * this function so it returns a different value.
249  *
250  * We have followed general OpenZeppelin Contracts guidelines: functions revert
251  * instead returning `false` on failure. This behavior is nonetheless
252  * conventional and does not conflict with the expectations of ERC20
253  * applications.
254  *
255  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
256  * This allows applications to reconstruct the allowance for all accounts just
257  * by listening to said events. Other implementations of the EIP may not emit
258  * these events, as it isn't required by the specification.
259  *
260  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
261  * functions have been added to mitigate the well-known issues around setting
262  * allowances. See {IERC20-approve}.
263  */
264 contract ERC20 is Context, IERC20, IERC20Metadata {
265     mapping(address => uint256) private _balances;
266 
267     mapping(address => mapping(address => uint256)) private _allowances;
268 
269     uint256 private _totalSupply;
270 
271     string private _name;
272     string private _symbol;
273 
274     /**
275      * @dev Sets the values for {name} and {symbol}.
276      *
277      * All two of these values are immutable: they can only be set once during
278      * construction.
279      */
280     constructor(string memory name_, string memory symbol_) {
281         _name = name_;
282         _symbol = symbol_;
283     }
284 
285     /**
286      * @dev Returns the name of the token.
287      */
288     function name() public view virtual override returns (string memory) {
289         return _name;
290     }
291 
292     /**
293      * @dev Returns the symbol of the token, usually a shorter version of the
294      * name.
295      */
296     function symbol() public view virtual override returns (string memory) {
297         return _symbol;
298     }
299 
300     /**
301      * @dev Returns the number of decimals used to get its user representation.
302      * For example, if `decimals` equals `2`, a balance of `505` tokens should
303      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
304      *
305      * Tokens usually opt for a value of 18, imitating the relationship between
306      * Ether and Wei. This is the default value returned by this function, unless
307      * it's overridden.
308      *
309      * NOTE: This information is only used for _display_ purposes: it in
310      * no way affects any of the arithmetic of the contract, including
311      * {IERC20-balanceOf} and {IERC20-transfer}.
312      */
313     function decimals() public view virtual override returns (uint8) {
314         return 18;
315     }
316 
317     /**
318      * @dev See {IERC20-totalSupply}.
319      */
320     function totalSupply() public view virtual override returns (uint256) {
321         return _totalSupply;
322     }
323 
324     /**
325      * @dev See {IERC20-balanceOf}.
326      */
327     function balanceOf(address account)
328         public
329         view
330         virtual
331         override
332         returns (uint256)
333     {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `to` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address to, uint256 amount)
346         public
347         virtual
348         override
349         returns (bool)
350     {
351         address owner = _msgSender();
352         _transfer(owner, to, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-allowance}.
358      */
359     function allowance(address owner, address spender)
360         public
361         view
362         virtual
363         override
364         returns (uint256)
365     {
366         return _allowances[owner][spender];
367     }
368 
369     /**
370      * @dev See {IERC20-approve}.
371      *
372      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
373      * `transferFrom`. This is semantically equivalent to an infinite approval.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function approve(address spender, uint256 amount)
380         public
381         virtual
382         override
383         returns (bool)
384     {
385         address owner = _msgSender();
386         _approve(owner, spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20}.
395      *
396      * NOTE: Does not update the allowance if the current allowance
397      * is the maximum `uint256`.
398      *
399      * Requirements:
400      *
401      * - `from` and `to` cannot be the zero address.
402      * - `from` must have a balance of at least `amount`.
403      * - the caller must have allowance for ``from``'s tokens of at least
404      * `amount`.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 amount
410     ) public virtual override returns (bool) {
411         address spender = _msgSender();
412         _spendAllowance(from, spender, amount);
413         _transfer(from, to, amount);
414         return true;
415     }
416 
417     /**
418      * @dev Atomically increases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function increaseAllowance(address spender, uint256 addedValue)
430         public
431         virtual
432         returns (bool)
433     {
434         address owner = _msgSender();
435         _approve(owner, spender, allowance(owner, spender) + addedValue);
436         return true;
437     }
438 
439     /**
440      * @dev Atomically decreases the allowance granted to `spender` by the caller.
441      *
442      * This is an alternative to {approve} that can be used as a mitigation for
443      * problems described in {IERC20-approve}.
444      *
445      * Emits an {Approval} event indicating the updated allowance.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      * - `spender` must have allowance for the caller of at least
451      * `subtractedValue`.
452      */
453     function decreaseAllowance(address spender, uint256 subtractedValue)
454         public
455         virtual
456         returns (bool)
457     {
458         address owner = _msgSender();
459         uint256 currentAllowance = allowance(owner, spender);
460         require(
461             currentAllowance >= subtractedValue,
462             "ERC20: decreased allowance below zero"
463         );
464         unchecked {
465             _approve(owner, spender, currentAllowance - subtractedValue);
466         }
467 
468         return true;
469     }
470 
471     /**
472      * @dev Moves `amount` of tokens from `from` to `to`.
473      *
474      * This internal function is equivalent to {transfer}, and can be used to
475      * e.g. implement automatic token fees, slashing mechanisms, etc.
476      *
477      * Emits a {Transfer} event.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `from` must have a balance of at least `amount`.
484      */
485     function _transfer(
486         address from,
487         address to,
488         uint256 amount
489     ) internal virtual {
490         require(from != address(0), "ERC20: transfer from the zero address");
491         require(to != address(0), "ERC20: transfer to the zero address");
492 
493         _beforeTokenTransfer(from, to, amount);
494 
495         uint256 fromBalance = _balances[from];
496         require(
497             fromBalance >= amount,
498             "ERC20: transfer amount exceeds balance"
499         );
500         unchecked {
501             _balances[from] = fromBalance - amount;
502             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
503             // decrementing then incrementing.
504             _balances[to] += amount;
505         }
506 
507         emit Transfer(from, to, amount);
508 
509         _afterTokenTransfer(from, to, amount);
510     }
511 
512     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
513      * the total supply.
514      *
515      * Emits a {Transfer} event with `from` set to the zero address.
516      *
517      * Requirements:
518      *
519      * - `account` cannot be the zero address.
520      */
521     function _mint(address account, uint256 amount) internal virtual {
522         require(account != address(0), "ERC20: mint to the zero address");
523 
524         _beforeTokenTransfer(address(0), account, amount);
525 
526         _totalSupply += amount;
527         unchecked {
528             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
529             _balances[account] += amount;
530         }
531         emit Transfer(address(0), account, amount);
532 
533         _afterTokenTransfer(address(0), account, amount);
534     }
535 
536     /**
537      * @dev Destroys `amount` tokens from `account`, reducing the
538      * total supply.
539      *
540      * Emits a {Transfer} event with `to` set to the zero address.
541      *
542      * Requirements:
543      *
544      * - `account` cannot be the zero address.
545      * - `account` must have at least `amount` tokens.
546      */
547     function _burn(address account, uint256 amount) internal virtual {
548         require(account != address(0), "ERC20: burn from the zero address");
549 
550         _beforeTokenTransfer(account, address(0), amount);
551 
552         uint256 accountBalance = _balances[account];
553         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
554         unchecked {
555             _balances[account] = accountBalance - amount;
556             // Overflow not possible: amount <= accountBalance <= totalSupply.
557             _totalSupply -= amount;
558         }
559 
560         emit Transfer(account, address(0), amount);
561 
562         _afterTokenTransfer(account, address(0), amount);
563     }
564 
565     /**
566      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
567      *
568      * This internal function is equivalent to `approve`, and can be used to
569      * e.g. set automatic allowances for certain subsystems, etc.
570      *
571      * Emits an {Approval} event.
572      *
573      * Requirements:
574      *
575      * - `owner` cannot be the zero address.
576      * - `spender` cannot be the zero address.
577      */
578     function _approve(
579         address owner,
580         address spender,
581         uint256 amount
582     ) internal virtual {
583         require(owner != address(0), "ERC20: approve from the zero address");
584         require(spender != address(0), "ERC20: approve to the zero address");
585 
586         _allowances[owner][spender] = amount;
587         emit Approval(owner, spender, amount);
588     }
589 
590     /**
591      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
592      *
593      * Does not update the allowance amount in case of infinite allowance.
594      * Revert if not enough allowance is available.
595      *
596      * Might emit an {Approval} event.
597      */
598     function _spendAllowance(
599         address owner,
600         address spender,
601         uint256 amount
602     ) internal virtual {
603         uint256 currentAllowance = allowance(owner, spender);
604         if (currentAllowance != type(uint256).max) {
605             require(
606                 currentAllowance >= amount,
607                 "ERC20: insufficient allowance"
608             );
609             unchecked {
610                 _approve(owner, spender, currentAllowance - amount);
611             }
612         }
613     }
614 
615     /**
616      * @dev Hook that is called before any transfer of tokens. This includes
617      * minting and burning.
618      *
619      * Calling conditions:
620      *
621      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
622      * will be transferred to `to`.
623      * - when `from` is zero, `amount` tokens will be minted for `to`.
624      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
625      * - `from` and `to` are never both zero.
626      *
627      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
628      */
629     function _beforeTokenTransfer(
630         address from,
631         address to,
632         uint256 amount
633     ) internal virtual {}
634 
635     /**
636      * @dev Hook that is called after any transfer of tokens. This includes
637      * minting and burning.
638      *
639      * Calling conditions:
640      *
641      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
642      * has been transferred to `to`.
643      * - when `from` is zero, `amount` tokens have been minted for `to`.
644      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
645      * - `from` and `to` are never both zero.
646      *
647      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
648      */
649     function _afterTokenTransfer(
650         address from,
651         address to,
652         uint256 amount
653     ) internal virtual {}
654 }
655 
656 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
657 
658 // CAUTION
659 // This version of SafeMath should only be used with Solidity 0.8 or later,
660 // because it relies on the compiler's built in overflow checks.
661 
662 /**
663  * @dev Wrappers over Solidity's arithmetic operations.
664  *
665  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
666  * now has built in overflow checking.
667  */
668 library SafeMath {
669     /**
670      * @dev Returns the addition of two unsigned integers, with an overflow flag.
671      *
672      * _Available since v3.4._
673      */
674     function tryAdd(uint256 a, uint256 b)
675         internal
676         pure
677         returns (bool, uint256)
678     {
679         unchecked {
680             uint256 c = a + b;
681             if (c < a) return (false, 0);
682             return (true, c);
683         }
684     }
685 
686     /**
687      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
688      *
689      * _Available since v3.4._
690      */
691     function trySub(uint256 a, uint256 b)
692         internal
693         pure
694         returns (bool, uint256)
695     {
696         unchecked {
697             if (b > a) return (false, 0);
698             return (true, a - b);
699         }
700     }
701 
702     /**
703      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
704      *
705      * _Available since v3.4._
706      */
707     function tryMul(uint256 a, uint256 b)
708         internal
709         pure
710         returns (bool, uint256)
711     {
712         unchecked {
713             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
714             // benefit is lost if 'b' is also tested.
715             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
716             if (a == 0) return (true, 0);
717             uint256 c = a * b;
718             if (c / a != b) return (false, 0);
719             return (true, c);
720         }
721     }
722 
723     /**
724      * @dev Returns the division of two unsigned integers, with a division by zero flag.
725      *
726      * _Available since v3.4._
727      */
728     function tryDiv(uint256 a, uint256 b)
729         internal
730         pure
731         returns (bool, uint256)
732     {
733         unchecked {
734             if (b == 0) return (false, 0);
735             return (true, a / b);
736         }
737     }
738 
739     /**
740      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
741      *
742      * _Available since v3.4._
743      */
744     function tryMod(uint256 a, uint256 b)
745         internal
746         pure
747         returns (bool, uint256)
748     {
749         unchecked {
750             if (b == 0) return (false, 0);
751             return (true, a % b);
752         }
753     }
754 
755     /**
756      * @dev Returns the addition of two unsigned integers, reverting on
757      * overflow.
758      *
759      * Counterpart to Solidity's `+` operator.
760      *
761      * Requirements:
762      *
763      * - Addition cannot overflow.
764      */
765     function add(uint256 a, uint256 b) internal pure returns (uint256) {
766         return a + b;
767     }
768 
769     /**
770      * @dev Returns the subtraction of two unsigned integers, reverting on
771      * overflow (when the result is negative).
772      *
773      * Counterpart to Solidity's `-` operator.
774      *
775      * Requirements:
776      *
777      * - Subtraction cannot overflow.
778      */
779     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
780         return a - b;
781     }
782 
783     /**
784      * @dev Returns the multiplication of two unsigned integers, reverting on
785      * overflow.
786      *
787      * Counterpart to Solidity's `*` operator.
788      *
789      * Requirements:
790      *
791      * - Multiplication cannot overflow.
792      */
793     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
794         return a * b;
795     }
796 
797     /**
798      * @dev Returns the integer division of two unsigned integers, reverting on
799      * division by zero. The result is rounded towards zero.
800      *
801      * Counterpart to Solidity's `/` operator.
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function div(uint256 a, uint256 b) internal pure returns (uint256) {
808         return a / b;
809     }
810 
811     /**
812      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
813      * reverting when dividing by zero.
814      *
815      * Counterpart to Solidity's `%` operator. This function uses a `revert`
816      * opcode (which leaves remaining gas untouched) while Solidity uses an
817      * invalid opcode to revert (consuming all remaining gas).
818      *
819      * Requirements:
820      *
821      * - The divisor cannot be zero.
822      */
823     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
824         return a % b;
825     }
826 
827     /**
828      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
829      * overflow (when the result is negative).
830      *
831      * CAUTION: This function is deprecated because it requires allocating memory for the error
832      * message unnecessarily. For custom revert reasons use {trySub}.
833      *
834      * Counterpart to Solidity's `-` operator.
835      *
836      * Requirements:
837      *
838      * - Subtraction cannot overflow.
839      */
840     function sub(
841         uint256 a,
842         uint256 b,
843         string memory errorMessage
844     ) internal pure returns (uint256) {
845         unchecked {
846             require(b <= a, errorMessage);
847             return a - b;
848         }
849     }
850 
851     /**
852      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
853      * division by zero. The result is rounded towards zero.
854      *
855      * Counterpart to Solidity's `/` operator. Note: this function uses a
856      * `revert` opcode (which leaves remaining gas untouched) while Solidity
857      * uses an invalid opcode to revert (consuming all remaining gas).
858      *
859      * Requirements:
860      *
861      * - The divisor cannot be zero.
862      */
863     function div(
864         uint256 a,
865         uint256 b,
866         string memory errorMessage
867     ) internal pure returns (uint256) {
868         unchecked {
869             require(b > 0, errorMessage);
870             return a / b;
871         }
872     }
873 
874     /**
875      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
876      * reverting with custom message when dividing by zero.
877      *
878      * CAUTION: This function is deprecated because it requires allocating memory for the error
879      * message unnecessarily. For custom revert reasons use {tryMod}.
880      *
881      * Counterpart to Solidity's `%` operator. This function uses a `revert`
882      * opcode (which leaves remaining gas untouched) while Solidity uses an
883      * invalid opcode to revert (consuming all remaining gas).
884      *
885      * Requirements:
886      *
887      * - The divisor cannot be zero.
888      */
889     function mod(
890         uint256 a,
891         uint256 b,
892         string memory errorMessage
893     ) internal pure returns (uint256) {
894         unchecked {
895             require(b > 0, errorMessage);
896             return a % b;
897         }
898     }
899 }
900 
901 interface IUniswapV2Factory {
902     event PairCreated(
903         address indexed token0,
904         address indexed token1,
905         address pair,
906         uint256
907     );
908 
909     function feeTo() external view returns (address);
910 
911     function feeToSetter() external view returns (address);
912 
913     function getPair(address tokenA, address tokenB)
914         external
915         view
916         returns (address pair);
917 
918     function allPairs(uint256) external view returns (address pair);
919 
920     function allPairsLength() external view returns (uint256);
921 
922     function createPair(address tokenA, address tokenB)
923         external
924         returns (address pair);
925 
926     function setFeeTo(address) external;
927 
928     function setFeeToSetter(address) external;
929 }
930 
931 interface IUniswapV2Router01 {
932     function factory() external pure returns (address);
933 
934     function WETH() external pure returns (address);
935 
936     function addLiquidity(
937         address tokenA,
938         address tokenB,
939         uint256 amountADesired,
940         uint256 amountBDesired,
941         uint256 amountAMin,
942         uint256 amountBMin,
943         address to,
944         uint256 deadline
945     )
946         external
947         returns (
948             uint256 amountA,
949             uint256 amountB,
950             uint256 liquidity
951         );
952 
953     function addLiquidityETH(
954         address token,
955         uint256 amountTokenDesired,
956         uint256 amountTokenMin,
957         uint256 amountETHMin,
958         address to,
959         uint256 deadline
960     )
961         external
962         payable
963         returns (
964             uint256 amountToken,
965             uint256 amountETH,
966             uint256 liquidity
967         );
968 
969     function removeLiquidity(
970         address tokenA,
971         address tokenB,
972         uint256 liquidity,
973         uint256 amountAMin,
974         uint256 amountBMin,
975         address to,
976         uint256 deadline
977     ) external returns (uint256 amountA, uint256 amountB);
978 
979     function removeLiquidityETH(
980         address token,
981         uint256 liquidity,
982         uint256 amountTokenMin,
983         uint256 amountETHMin,
984         address to,
985         uint256 deadline
986     ) external returns (uint256 amountToken, uint256 amountETH);
987 
988     function removeLiquidityWithPermit(
989         address tokenA,
990         address tokenB,
991         uint256 liquidity,
992         uint256 amountAMin,
993         uint256 amountBMin,
994         address to,
995         uint256 deadline,
996         bool approveMax,
997         uint8 v,
998         bytes32 r,
999         bytes32 s
1000     ) external returns (uint256 amountA, uint256 amountB);
1001 
1002     function removeLiquidityETHWithPermit(
1003         address token,
1004         uint256 liquidity,
1005         uint256 amountTokenMin,
1006         uint256 amountETHMin,
1007         address to,
1008         uint256 deadline,
1009         bool approveMax,
1010         uint8 v,
1011         bytes32 r,
1012         bytes32 s
1013     ) external returns (uint256 amountToken, uint256 amountETH);
1014 
1015     function swapExactTokensForTokens(
1016         uint256 amountIn,
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external returns (uint256[] memory amounts);
1022 
1023     function swapTokensForExactTokens(
1024         uint256 amountOut,
1025         uint256 amountInMax,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external returns (uint256[] memory amounts);
1030 
1031     function swapExactETHForTokens(
1032         uint256 amountOutMin,
1033         address[] calldata path,
1034         address to,
1035         uint256 deadline
1036     ) external payable returns (uint256[] memory amounts);
1037 
1038     function swapTokensForExactETH(
1039         uint256 amountOut,
1040         uint256 amountInMax,
1041         address[] calldata path,
1042         address to,
1043         uint256 deadline
1044     ) external returns (uint256[] memory amounts);
1045 
1046     function swapExactTokensForETH(
1047         uint256 amountIn,
1048         uint256 amountOutMin,
1049         address[] calldata path,
1050         address to,
1051         uint256 deadline
1052     ) external returns (uint256[] memory amounts);
1053 
1054     function swapETHForExactTokens(
1055         uint256 amountOut,
1056         address[] calldata path,
1057         address to,
1058         uint256 deadline
1059     ) external payable returns (uint256[] memory amounts);
1060 
1061     function quote(
1062         uint256 amountA,
1063         uint256 reserveA,
1064         uint256 reserveB
1065     ) external pure returns (uint256 amountB);
1066 
1067     function getAmountOut(
1068         uint256 amountIn,
1069         uint256 reserveIn,
1070         uint256 reserveOut
1071     ) external pure returns (uint256 amountOut);
1072 
1073     function getAmountIn(
1074         uint256 amountOut,
1075         uint256 reserveIn,
1076         uint256 reserveOut
1077     ) external pure returns (uint256 amountIn);
1078 
1079     function getAmountsOut(uint256 amountIn, address[] calldata path)
1080         external
1081         view
1082         returns (uint256[] memory amounts);
1083 
1084     function getAmountsIn(uint256 amountOut, address[] calldata path)
1085         external
1086         view
1087         returns (uint256[] memory amounts);
1088 }
1089 
1090 interface IUniswapV2Router02 is IUniswapV2Router01 {
1091     function removeLiquidityETHSupportingFeeOnTransferTokens(
1092         address token,
1093         uint256 liquidity,
1094         uint256 amountTokenMin,
1095         uint256 amountETHMin,
1096         address to,
1097         uint256 deadline
1098     ) external returns (uint256 amountETH);
1099 
1100     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1101         address token,
1102         uint256 liquidity,
1103         uint256 amountTokenMin,
1104         uint256 amountETHMin,
1105         address to,
1106         uint256 deadline,
1107         bool approveMax,
1108         uint8 v,
1109         bytes32 r,
1110         bytes32 s
1111     ) external returns (uint256 amountETH);
1112 
1113     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1114         uint256 amountIn,
1115         uint256 amountOutMin,
1116         address[] calldata path,
1117         address to,
1118         uint256 deadline
1119     ) external;
1120 
1121     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1122         uint256 amountOutMin,
1123         address[] calldata path,
1124         address to,
1125         uint256 deadline
1126     ) external payable;
1127 
1128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1129         uint256 amountIn,
1130         uint256 amountOutMin,
1131         address[] calldata path,
1132         address to,
1133         uint256 deadline
1134     ) external;
1135 }
1136 
1137 contract RejectHumanityReturntoMonke is ERC20, Ownable {
1138     using SafeMath for uint256;
1139 
1140     IUniswapV2Router02 public immutable uniswapV2Router;
1141     address public uniswapV2Pair;
1142     address public constant deadAddress = address(0xdead);
1143 
1144     bool private swapping;
1145 
1146     address public marketingWallet;
1147     address public liquidityWallet;
1148 
1149     uint256 public maxTransactionAmount;
1150     uint256 public swapTokensAtAmount;
1151     uint256 public maxWallet;
1152 
1153     bool public tradingActive = false;
1154     bool public swapEnabled = false;
1155 
1156     uint256 public buyTotalFees;
1157     uint256 private buyMarketingFee;
1158     uint256 private buyLiquidityFee;
1159 
1160     uint256 public sellTotalFees;
1161     uint256 private sellMarketingFee;
1162     uint256 private sellLiquidityFee;
1163 
1164     uint256 private tokensForMarketing;
1165     uint256 private tokensForLiquidity;
1166     uint256 private previousFee;
1167 
1168     mapping(address => bool) private _isExcludedFromFees;
1169     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1170     mapping(address => bool) private automatedMarketMakerPairs;
1171 
1172     event ExcludeFromFees(address indexed account, bool isExcluded);
1173 
1174     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1175 
1176     event marketingWalletUpdated(
1177         address indexed newWallet,
1178         address indexed oldWallet
1179     );
1180 
1181     event liquidityWalletUpdated(
1182         address indexed newWallet,
1183         address indexed oldWallet
1184     );
1185 
1186     event SwapAndLiquify(
1187         uint256 tokensSwapped,
1188         uint256 ethReceived,
1189         uint256 tokensIntoLiquidity
1190     );
1191 
1192     constructor() ERC20("Monke", "Monke") {
1193         uniswapV2Router = IUniswapV2Router02(
1194             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1195         );
1196         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1197 
1198         uint256 totalSupply = 1_000_000_000 ether;
1199 
1200         maxTransactionAmount = (totalSupply * 1) / 100;
1201         maxWallet = (totalSupply * 2) / 100;
1202         swapTokensAtAmount = (totalSupply * 1) / 1000;
1203 
1204         buyMarketingFee = 100;
1205         buyLiquidityFee = 0;
1206         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1207 
1208         sellMarketingFee = 100;
1209         sellLiquidityFee = 0;
1210         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1211 
1212         previousFee = sellTotalFees;
1213 
1214         marketingWallet = 0x34ada6DC9eF50e9f9C63C5Dc8BA6e3219374B6f7;
1215         liquidityWallet = 0x000000000000000000000000000000000000dEaD;
1216 
1217         excludeFromFees(owner(), true);
1218         excludeFromFees(address(this), true);
1219         excludeFromFees(deadAddress, true);
1220         excludeFromFees(marketingWallet, true);
1221 
1222         excludeFromMaxTransaction(owner(), true);
1223         excludeFromMaxTransaction(address(this), true);
1224         excludeFromMaxTransaction(deadAddress, true);
1225         excludeFromMaxTransaction(address(uniswapV2Router), true);
1226         excludeFromMaxTransaction(marketingWallet, true);
1227 
1228         _mint(address(this), totalSupply);
1229     }
1230 
1231     receive() external payable {}
1232 
1233     function burn(uint256 amount) external {
1234         _burn(msg.sender, amount);
1235     }
1236 
1237     function enableTrading() external onlyOwner {
1238         require(!tradingActive, "Trading already active.");
1239 
1240         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1241             address(this),
1242             uniswapV2Router.WETH()
1243         );
1244         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1245         IERC20(uniswapV2Pair).approve(
1246             address(uniswapV2Router),
1247             type(uint256).max
1248         );
1249 
1250         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1251         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1252 
1253         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1254             address(this),
1255             balanceOf(address(this)),
1256             0,
1257             0,
1258             owner(),
1259             block.timestamp
1260         );
1261         tradingActive = true;
1262         swapEnabled = true;
1263     }
1264 
1265     function updateSwapTokensAtAmount(uint256 newAmount)
1266         external
1267         onlyOwner
1268         returns (bool)
1269     {
1270         require(
1271             newAmount >= (totalSupply() * 1) / 100000,
1272             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1273         );
1274         require(
1275             newAmount <= (totalSupply() * 5) / 1000,
1276             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1277         );
1278         swapTokensAtAmount = newAmount;
1279         return true;
1280     }
1281 
1282     function updateMaxWalletAndTxnAmount(
1283         uint256 newTxnNum,
1284         uint256 newMaxWalletNum
1285     ) external onlyOwner {
1286         require(
1287             newTxnNum >= ((totalSupply() * 5) / 1000),
1288             "ERC20: Cannot set maxTxn lower than 0.5%"
1289         );
1290         require(
1291             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1292             "ERC20: Cannot set maxWallet lower than 0.5%"
1293         );
1294         maxWallet = newMaxWalletNum;
1295         maxTransactionAmount = newTxnNum;
1296     }
1297 
1298     function excludeFromMaxTransaction(address updAds, bool isEx)
1299         public
1300         onlyOwner
1301     {
1302         _isExcludedMaxTransactionAmount[updAds] = isEx;
1303     }
1304 
1305     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1306         external
1307         onlyOwner
1308     {
1309         buyMarketingFee = _marketingFee;
1310         buyLiquidityFee = _liquidityFee;
1311         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1312         require(buyTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1313     }
1314 
1315     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1316         external
1317         onlyOwner
1318     {
1319         sellMarketingFee = _marketingFee;
1320         sellLiquidityFee = _liquidityFee;
1321         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1322         previousFee = sellTotalFees;
1323         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1324     }
1325 
1326     function updateMarketingWallet(address _marketingWallet)
1327         external
1328         onlyOwner
1329     {
1330         require(_marketingWallet != address(0), "ERC20: Address 0");
1331         address oldWallet = marketingWallet;
1332         marketingWallet = _marketingWallet;
1333         emit marketingWalletUpdated(marketingWallet, oldWallet);
1334     }
1335 
1336     function updateLiquidityWallet(address _liquidityWallet)
1337         external
1338         onlyOwner
1339     {
1340         require(_liquidityWallet != address(0), "ERC20: Address 0");
1341         address oldWallet = liquidityWallet;
1342         liquidityWallet = _liquidityWallet;
1343         emit liquidityWalletUpdated(liquidityWallet, oldWallet);
1344     }
1345 
1346     function excludeFromFees(address account, bool excluded) public onlyOwner {
1347         _isExcludedFromFees[account] = excluded;
1348         emit ExcludeFromFees(account, excluded);
1349     }
1350 
1351     function withdrawStuckETH() public onlyOwner {
1352         bool success;
1353         (success, ) = address(msg.sender).call{value: address(this).balance}(
1354             ""
1355         );
1356     }
1357 
1358     function withdrawStuckTokens(address tkn) public onlyOwner {
1359         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1360         uint256 amount = IERC20(tkn).balanceOf(address(this));
1361         IERC20(tkn).transfer(msg.sender, amount);
1362     }
1363 
1364     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1365         automatedMarketMakerPairs[pair] = value;
1366 
1367         emit SetAutomatedMarketMakerPair(pair, value);
1368     }
1369 
1370     function isExcludedFromFees(address account) public view returns (bool) {
1371         return _isExcludedFromFees[account];
1372     }
1373 
1374     function _transfer(
1375         address from,
1376         address to,
1377         uint256 amount
1378     ) internal override {
1379         require(from != address(0), "ERC20: transfer from the zero address");
1380         require(to != address(0), "ERC20: transfer to the zero address");
1381 
1382         if (amount == 0) {
1383             super._transfer(from, to, 0);
1384             return;
1385         }
1386 
1387         if (
1388             from != owner() &&
1389             to != owner() &&
1390             to != address(0) &&
1391             to != deadAddress &&
1392             !swapping
1393         ) {
1394             if (!tradingActive) {
1395                 require(
1396                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1397                     "ERC20: Trading is not active."
1398                 );
1399             }
1400 
1401             //when buy
1402             if (
1403                 automatedMarketMakerPairs[from] &&
1404                 !_isExcludedMaxTransactionAmount[to]
1405             ) {
1406                 require(
1407                     amount <= maxTransactionAmount,
1408                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1409                 );
1410                 require(
1411                     amount + balanceOf(to) <= maxWallet,
1412                     "ERC20: Max wallet exceeded"
1413                 );
1414             }
1415             //when sell
1416             else if (
1417                 automatedMarketMakerPairs[to] &&
1418                 !_isExcludedMaxTransactionAmount[from]
1419             ) {
1420                 require(
1421                     amount <= maxTransactionAmount,
1422                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1423                 );
1424             } else if (!_isExcludedMaxTransactionAmount[to]) {
1425                 require(
1426                     amount + balanceOf(to) <= maxWallet,
1427                     "ERC20: Max wallet exceeded"
1428                 );
1429             }
1430         }
1431 
1432         uint256 contractTokenBalance = balanceOf(address(this));
1433 
1434         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1435 
1436         if (
1437             canSwap &&
1438             swapEnabled &&
1439             !swapping &&
1440             !automatedMarketMakerPairs[from] &&
1441             !_isExcludedFromFees[from] &&
1442             !_isExcludedFromFees[to]
1443         ) {
1444             swapping = true;
1445 
1446             swapBack();
1447 
1448             swapping = false;
1449         }
1450 
1451         bool takeFee = !swapping;
1452 
1453         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1454             takeFee = false;
1455         }
1456 
1457         uint256 fees = 0;
1458 
1459         if (takeFee) {
1460             // on sell
1461             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1462                 fees = amount.mul(sellTotalFees).div(100);
1463                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1464                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1465             }
1466             // on buy
1467             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1468                 fees = amount.mul(buyTotalFees).div(100);
1469                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1470                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1471             }
1472 
1473             if (fees > 0) {
1474                 super._transfer(from, address(this), fees);
1475             }
1476 
1477             amount -= fees;
1478         }
1479 
1480         super._transfer(from, to, amount);
1481         sellTotalFees = previousFee;
1482     }
1483 
1484     function swapTokensForEth(uint256 tokenAmount) private {
1485         address[] memory path = new address[](2);
1486         path[0] = address(this);
1487         path[1] = uniswapV2Router.WETH();
1488 
1489         _approve(address(this), address(uniswapV2Router), tokenAmount);
1490 
1491         // make the swap
1492         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1493             tokenAmount,
1494             0,
1495             path,
1496             address(this),
1497             block.timestamp
1498         );
1499     }
1500 
1501     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1502         _approve(address(this), address(uniswapV2Router), tokenAmount);
1503 
1504         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1505             address(this),
1506             tokenAmount,
1507             0,
1508             0,
1509             liquidityWallet,
1510             block.timestamp
1511         );
1512     }
1513 
1514     function swapBack() private {
1515         uint256 contractBalance = balanceOf(address(this));
1516         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1517         bool success;
1518 
1519         if (contractBalance == 0 || totalTokensToSwap == 0) {
1520             return;
1521         }
1522 
1523         if (contractBalance > swapTokensAtAmount * 20) {
1524             contractBalance = swapTokensAtAmount * 20;
1525         }
1526 
1527         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1528             totalTokensToSwap /
1529             2;
1530         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1531 
1532         uint256 initialETHBalance = address(this).balance;
1533 
1534         swapTokensForEth(amountToSwapForETH);
1535 
1536         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1537 
1538         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1539             totalTokensToSwap
1540         );
1541 
1542         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1543 
1544         tokensForLiquidity = 0;
1545         tokensForMarketing = 0;
1546 
1547         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1548             addLiquidity(liquidityTokens, ethForLiquidity);
1549             emit SwapAndLiquify(
1550                 amountToSwapForETH,
1551                 ethForLiquidity,
1552                 tokensForLiquidity
1553             );
1554         }
1555 
1556         (success, ) = address(marketingWallet).call{
1557             value: address(this).balance
1558         }("");
1559     }
1560 }