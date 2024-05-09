1 // - Website: https://tbpaps10i.com
2 // - Telegram: https://t.me/tbpaps10i_erc20
3 // - Twitter: https://twitter.com/tbpaps10i
4 
5 /* Hello Blue fans:
6 *  Twitter Blue Pepe avatar Pepsi Sonic 10 Inu
7 *  Do you feel blue today?
8 *  kek kek kek kek kek kek... kek.. kek.. kek.. kek...
9 */
10 
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.20;
15 pragma experimental ABIEncoderV2;
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
40 
41 // pragma solidity ^0.8.0;
42 
43 // import "../utils/Context.sol";
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(
61         address indexed previousOwner,
62         address indexed newOwner
63     );
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         _checkOwner();
77         _;
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view virtual returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if the sender is not the owner.
89      */
90     function _checkOwner() internal view virtual {
91         require(owner() == _msgSender(), "Ownable: caller is not the owner");
92     }
93 
94 
95     function renounceOwnership() public virtual onlyOwner {
96         _transferOwnership(address(0));
97     }
98     
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(
105             newOwner != address(0),
106             "Ownable: new owner is the zero address"
107         );
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
123 
124 // pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Emitted when `value` tokens are moved from one account (`from`) to
132      * another (`to`).
133      *
134      * Note that `value` may be zero.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 
138     /**
139      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
140      * a call to {approve}. `value` is the new allowance.
141      */
142     event Approval(
143         address indexed owner,
144         address indexed spender,
145         uint256 value
146     );
147 
148     /**
149      * @dev Returns the amount of tokens in existence.
150      */
151     function totalSupply() external view returns (uint256);
152 
153     /**
154      * @dev Returns the amount of tokens owned by `account`.
155      */
156     function balanceOf(address account) external view returns (uint256);
157 
158     /**
159      * @dev Moves `amount` tokens from the caller's account to `to`.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transfer(address to, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Returns the remaining number of tokens that `spender` will be
169      * allowed to spend on behalf of `owner` through {transferFrom}. This is
170      * zero by default.
171      *
172      * This value changes when {approve} or {transferFrom} are called.
173      */
174     function allowance(address owner, address spender)
175         external
176         view
177         returns (uint256);
178 
179     /**
180      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * IMPORTANT: Beware that changing an allowance with this method brings the risk
185      * that someone may use both the old and the new allowance by unfortunate
186      * transaction ordering. One possible solution to mitigate this race
187      * condition is to first reduce the spender's allowance to 0 and set the
188      * desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      *
191      * Emits an {Approval} event.
192      */
193     function approve(address spender, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Moves `amount` tokens from `from` to `to` using the
197      * allowance mechanism. `amount` is then deducted from the caller's
198      * allowance.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 amount
208     ) external returns (bool);
209 }
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
212 
213 // pragma solidity ^0.8.0;
214 
215 // import "../IERC20.sol";
216 
217 /**
218  * @dev Interface for the optional metadata functions from the ERC20 standard.
219  *
220  * _Available since v4.1._
221  */
222 interface IERC20Metadata is IERC20 {
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() external view returns (string memory);
227 
228     /**
229      * @dev Returns the symbol of the token.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the decimals places of the token.
235      */
236     function decimals() external view returns (uint8);
237 }
238 
239 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
240 
241 // pragma solidity ^0.8.0;
242 
243 // import "./IERC20.sol";
244 // import "./extensions/IERC20Metadata.sol";
245 // import "../../utils/Context.sol";
246 
247 /**
248  * @dev Implementation of the {IERC20} interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using {_mint}.
252  * For a generic mechanism see {ERC20PresetMinterPauser}.
253  *
254  * TIP: For a detailed writeup see our guide
255  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
256  * to implement supply mechanisms].
257  *
258  * The default value of {decimals} is 18. To change this, you should override
259  * this function so it returns a different value.
260  *
261  * We have followed general OpenZeppelin Contracts guidelines: functions revert
262  * instead returning `false` on failure. This behavior is nonetheless
263  * conventional and does not conflict with the expectations of ERC20
264  * applications.
265  *
266  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
267  * This allows applications to reconstruct the allowance for all accounts just
268  * by listening to said events. Other implementations of the EIP may not emit
269  * these events, as it isn't required by the specification.
270  *
271  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
272  * functions have been added to mitigate the well-known issues around setting
273  * allowances. See {IERC20-approve}.
274  */
275 contract ERC20 is Context, IERC20, IERC20Metadata {
276     mapping(address => uint256) private _balances;
277 
278     mapping(address => mapping(address => uint256)) private _allowances;
279 
280     uint256 private _totalSupply;
281 
282     string private _name;
283     string private _symbol;
284 
285     /**
286      * @dev Sets the values for {name} and {symbol}.
287      *
288      * All two of these values are immutable: they can only be set once during
289      * construction.
290      */
291     constructor(string memory name_, string memory symbol_) {
292         _name = name_;
293         _symbol = symbol_;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view virtual override returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view virtual override returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei. This is the default value returned by this function, unless
318      * it's overridden.
319      *
320      * NOTE: This information is only used for _display_ purposes: it in
321      * no way affects any of the arithmetic of the contract, including
322      * {IERC20-balanceOf} and {IERC20-transfer}.
323      */
324     function decimals() public view virtual override returns (uint8) {
325         return 18;
326     }
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view virtual override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account)
339         public
340         view
341         virtual
342         override
343         returns (uint256)
344     {
345         return _balances[account];
346     }
347 
348     /**
349      * @dev See {IERC20-transfer}.
350      *
351      * Requirements:
352      *
353      * - `to` cannot be the zero address.
354      * - the caller must have a balance of at least `amount`.
355      */
356     function transfer(address to, uint256 amount)
357         public
358         virtual
359         override
360         returns (bool)
361     {
362         address owner = _msgSender();
363         _transfer(owner, to, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-allowance}.
369      */
370     function allowance(address owner, address spender)
371         public
372         view
373         virtual
374         override
375         returns (uint256)
376     {
377         return _allowances[owner][spender];
378     }
379 
380     /**
381      * @dev See {IERC20-approve}.
382      *
383      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
384      * `transferFrom`. This is semantically equivalent to an infinite approval.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function approve(address spender, uint256 amount)
391         public
392         virtual
393         override
394         returns (bool)
395     {
396         address owner = _msgSender();
397         _approve(owner, spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20}.
406      *
407      * NOTE: Does not update the allowance if the current allowance
408      * is the maximum `uint256`.
409      *
410      * Requirements:
411      *
412      * - `from` and `to` cannot be the zero address.
413      * - `from` must have a balance of at least `amount`.
414      * - the caller must have allowance for ``from``'s tokens of at least
415      * `amount`.
416      */
417     function transferFrom(
418         address from,
419         address to,
420         uint256 amount
421     ) public virtual override returns (bool) {
422         address spender = _msgSender();
423         _spendAllowance(from, spender, amount);
424         _transfer(from, to, amount);
425         return true;
426     }
427 
428     /**
429      * @dev Atomically increases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function increaseAllowance(address spender, uint256 addedValue)
441         public
442         virtual
443         returns (bool)
444     {
445         address owner = _msgSender();
446         _approve(owner, spender, allowance(owner, spender) + addedValue);
447         return true;
448     }
449 
450     /**
451      * @dev Atomically decreases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      *
456      * Emits an {Approval} event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      * - `spender` must have allowance for the caller of at least
462      * `subtractedValue`.
463      */
464     function decreaseAllowance(address spender, uint256 subtractedValue)
465         public
466         virtual
467         returns (bool)
468     {
469         address owner = _msgSender();
470         uint256 currentAllowance = allowance(owner, spender);
471         require(
472             currentAllowance >= subtractedValue,
473             "ERC20: decreased allowance below zero"
474         );
475         unchecked {
476             _approve(owner, spender, currentAllowance - subtractedValue);
477         }
478 
479         return true;
480     }
481 
482     /**
483      * @dev Moves `amount` of tokens from `from` to `to`.
484      *
485      * This internal function is equivalent to {transfer}, and can be used to
486      * e.g. implement automatic token fees, slashing mechanisms, etc.
487      *
488      * Emits a {Transfer} event.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `from` must have a balance of at least `amount`.
495      */
496     function _transfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {
501         require(from != address(0), "ERC20: transfer from the zero address");
502         require(to != address(0), "ERC20: transfer to the zero address");
503 
504         _beforeTokenTransfer(from, to, amount);
505 
506         uint256 fromBalance = _balances[from];
507         require(
508             fromBalance >= amount,
509             "ERC20: transfer amount exceeds balance"
510         );
511         unchecked {
512             _balances[from] = fromBalance - amount;
513             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
514             // decrementing then incrementing.
515             _balances[to] += amount;
516         }
517 
518         emit Transfer(from, to, amount);
519 
520         _afterTokenTransfer(from, to, amount);
521     }
522 
523     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
524      * the total supply.
525      *
526      * Emits a {Transfer} event with `from` set to the zero address.
527      *
528      * Requirements:
529      *
530      * - `account` cannot be the zero address.
531      */
532     function _mint(address account, uint256 amount) internal virtual {
533         require(account != address(0), "ERC20: mint to the zero address");
534 
535         _beforeTokenTransfer(address(0), account, amount);
536 
537         _totalSupply += amount;
538         unchecked {
539             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
540             _balances[account] += amount;
541         }
542         emit Transfer(address(0), account, amount);
543 
544         _afterTokenTransfer(address(0), account, amount);
545     }
546 
547     /**
548      * @dev Destroys `amount` tokens from `account`, reducing the
549      * total supply.
550      *
551      * Emits a {Transfer} event with `to` set to the zero address.
552      *
553      * Requirements:
554      *
555      * - `account` cannot be the zero address.
556      * - `account` must have at least `amount` tokens.
557      */
558     function _burn(address account, uint256 amount) internal virtual {
559         require(account != address(0), "ERC20: burn from the zero address");
560 
561         _beforeTokenTransfer(account, address(0), amount);
562 
563         uint256 accountBalance = _balances[account];
564         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
565         unchecked {
566             _balances[account] = accountBalance - amount;
567             // Overflow not possible: amount <= accountBalance <= totalSupply.
568             _totalSupply -= amount;
569         }
570 
571         emit Transfer(account, address(0), amount);
572 
573         _afterTokenTransfer(account, address(0), amount);
574     }
575 
576     /**
577      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
578      *
579      * This internal function is equivalent to `approve`, and can be used to
580      * e.g. set automatic allowances for certain subsystems, etc.
581      *
582      * Emits an {Approval} event.
583      *
584      * Requirements:
585      *
586      * - `owner` cannot be the zero address.
587      * - `spender` cannot be the zero address.
588      */
589     function _approve(
590         address owner,
591         address spender,
592         uint256 amount
593     ) internal virtual {
594         require(owner != address(0), "ERC20: approve from the zero address");
595         require(spender != address(0), "ERC20: approve to the zero address");
596 
597         _allowances[owner][spender] = amount;
598         emit Approval(owner, spender, amount);
599     }
600 
601     /**
602      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
603      *
604      * Does not update the allowance amount in case of infinite allowance.
605      * Revert if not enough allowance is available.
606      *
607      * Might emit an {Approval} event.
608      */
609     function _spendAllowance(
610         address owner,
611         address spender,
612         uint256 amount
613     ) internal virtual {
614         uint256 currentAllowance = allowance(owner, spender);
615         if (currentAllowance != type(uint256).max) {
616             require(
617                 currentAllowance >= amount,
618                 "ERC20: insufficient allowance"
619             );
620             unchecked {
621                 _approve(owner, spender, currentAllowance - amount);
622             }
623         }
624     }
625 
626     /**
627      * @dev Hook that is called before any transfer of tokens. This includes
628      * minting and burning.
629      *
630      * Calling conditions:
631      *
632      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
633      * will be transferred to `to`.
634      * - when `from` is zero, `amount` tokens will be minted for `to`.
635      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
636      * - `from` and `to` are never both zero.
637      *
638      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
639      */
640     function _beforeTokenTransfer(
641         address from,
642         address to,
643         uint256 amount
644     ) internal virtual {}
645 
646     /**
647      * @dev Hook that is called after any transfer of tokens. This includes
648      * minting and burning.
649      *
650      * Calling conditions:
651      *
652      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
653      * has been transferred to `to`.
654      * - when `from` is zero, `amount` tokens have been minted for `to`.
655      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
656      * - `from` and `to` are never both zero.
657      *
658      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
659      */
660     function _afterTokenTransfer(
661         address from,
662         address to,
663         uint256 amount
664     ) internal virtual {}
665 }
666 
667 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
668 
669 // pragma solidity ^0.8.0;
670 
671 // CAUTION
672 // This version of SafeMath should only be used with Solidity 0.8 or later,
673 // because it relies on the compiler's built in overflow checks.
674 
675 /**
676  * @dev Wrappers over Solidity's arithmetic operations.
677  *
678  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
679  * now has built in overflow checking.
680  */
681 library SafeMath {
682     /**
683      * @dev Returns the addition of two unsigned integers, with an overflow flag.
684      *
685      * _Available since v3.4._
686      */
687     function tryAdd(uint256 a, uint256 b)
688         internal
689         pure
690         returns (bool, uint256)
691     {
692         unchecked {
693             uint256 c = a + b;
694             if (c < a) return (false, 0);
695             return (true, c);
696         }
697     }
698 
699     /**
700      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
701      *
702      * _Available since v3.4._
703      */
704     function trySub(uint256 a, uint256 b)
705         internal
706         pure
707         returns (bool, uint256)
708     {
709         unchecked {
710             if (b > a) return (false, 0);
711             return (true, a - b);
712         }
713     }
714 
715     /**
716      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
717      *
718      * _Available since v3.4._
719      */
720     function tryMul(uint256 a, uint256 b)
721         internal
722         pure
723         returns (bool, uint256)
724     {
725         unchecked {
726             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
727             // benefit is lost if 'b' is also tested.
728             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
729             if (a == 0) return (true, 0);
730             uint256 c = a * b;
731             if (c / a != b) return (false, 0);
732             return (true, c);
733         }
734     }
735 
736     /**
737      * @dev Returns the division of two unsigned integers, with a division by zero flag.
738      *
739      * _Available since v3.4._
740      */
741     function tryDiv(uint256 a, uint256 b)
742         internal
743         pure
744         returns (bool, uint256)
745     {
746         unchecked {
747             if (b == 0) return (false, 0);
748             return (true, a / b);
749         }
750     }
751 
752     /**
753      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
754      *
755      * _Available since v3.4._
756      */
757     function tryMod(uint256 a, uint256 b)
758         internal
759         pure
760         returns (bool, uint256)
761     {
762         unchecked {
763             if (b == 0) return (false, 0);
764             return (true, a % b);
765         }
766     }
767 
768     /**
769      * @dev Returns the addition of two unsigned integers, reverting on
770      * overflow.
771      *
772      * Counterpart to Solidity's `+` operator.
773      *
774      * Requirements:
775      *
776      * - Addition cannot overflow.
777      */
778     function add(uint256 a, uint256 b) internal pure returns (uint256) {
779         return a + b;
780     }
781 
782     /**
783      * @dev Returns the subtraction of two unsigned integers, reverting on
784      * overflow (when the result is negative).
785      *
786      * Counterpart to Solidity's `-` operator.
787      *
788      * Requirements:
789      *
790      * - Subtraction cannot overflow.
791      */
792     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
793         return a - b;
794     }
795 
796     /**
797      * @dev Returns the multiplication of two unsigned integers, reverting on
798      * overflow.
799      *
800      * Counterpart to Solidity's `*` operator.
801      *
802      * Requirements:
803      *
804      * - Multiplication cannot overflow.
805      */
806     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
807         return a * b;
808     }
809 
810     /**
811      * @dev Returns the integer division of two unsigned integers, reverting on
812      * division by zero. The result is rounded towards zero.
813      *
814      * Counterpart to Solidity's `/` operator.
815      *
816      * Requirements:
817      *
818      * - The divisor cannot be zero.
819      */
820     function div(uint256 a, uint256 b) internal pure returns (uint256) {
821         return a / b;
822     }
823 
824     /**
825      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
826      * reverting when dividing by zero.
827      *
828      * Counterpart to Solidity's `%` operator. This function uses a `revert`
829      * opcode (which leaves remaining gas untouched) while Solidity uses an
830      * invalid opcode to revert (consuming all remaining gas).
831      *
832      * Requirements:
833      *
834      * - The divisor cannot be zero.
835      */
836     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
837         return a % b;
838     }
839 
840     /**
841      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
842      * overflow (when the result is negative).
843      *
844      * CAUTION: This function is deprecated because it requires allocating memory for the error
845      * message unnecessarily. For custom revert reasons use {trySub}.
846      *
847      * Counterpart to Solidity's `-` operator.
848      *
849      * Requirements:
850      *
851      * - Subtraction cannot overflow.
852      */
853     function sub(
854         uint256 a,
855         uint256 b,
856         string memory errorMessage
857     ) internal pure returns (uint256) {
858         unchecked {
859             require(b <= a, errorMessage);
860             return a - b;
861         }
862     }
863 
864     /**
865      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
866      * division by zero. The result is rounded towards zero.
867      *
868      * Counterpart to Solidity's `/` operator. Note: this function uses a
869      * `revert` opcode (which leaves remaining gas untouched) while Solidity
870      * uses an invalid opcode to revert (consuming all remaining gas).
871      *
872      * Requirements:
873      *
874      * - The divisor cannot be zero.
875      */
876     function div(
877         uint256 a,
878         uint256 b,
879         string memory errorMessage
880     ) internal pure returns (uint256) {
881         unchecked {
882             require(b > 0, errorMessage);
883             return a / b;
884         }
885     }
886 
887     /**
888      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
889      * reverting with custom message when dividing by zero.
890      *
891      * CAUTION: This function is deprecated because it requires allocating memory for the error
892      * message unnecessarily. For custom revert reasons use {tryMod}.
893      *
894      * Counterpart to Solidity's `%` operator. This function uses a `revert`
895      * opcode (which leaves remaining gas untouched) while Solidity uses an
896      * invalid opcode to revert (consuming all remaining gas).
897      *
898      * Requirements:
899      *
900      * - The divisor cannot be zero.
901      */
902     function mod(
903         uint256 a,
904         uint256 b,
905         string memory errorMessage
906     ) internal pure returns (uint256) {
907         unchecked {
908             require(b > 0, errorMessage);
909             return a % b;
910         }
911     }
912 }
913 
914 // pragma solidity >=0.5.0;
915 
916 interface IUniswapV2Factory {
917     event PairCreated(
918         address indexed token0,
919         address indexed token1,
920         address pair,
921         uint256
922     );
923 
924     function feeTo() external view returns (address);
925 
926     function feeToSetter() external view returns (address);
927 
928     function getPair(address tokenA, address tokenB)
929         external
930         view
931         returns (address pair);
932 
933     function allPairs(uint256) external view returns (address pair);
934 
935     function allPairsLength() external view returns (uint256);
936 
937     function createPair(address tokenA, address tokenB)
938         external
939         returns (address pair);
940 
941     function setFeeTo(address) external;
942 
943     function setFeeToSetter(address) external;
944 }
945 
946 // pragma solidity >=0.5.0;
947 
948 interface IUniswapV2Pair {
949     event Approval(
950         address indexed owner,
951         address indexed spender,
952         uint256 value
953     );
954     event Transfer(address indexed from, address indexed to, uint256 value);
955 
956     function name() external pure returns (string memory);
957 
958     function symbol() external pure returns (string memory);
959 
960     function decimals() external pure returns (uint8);
961 
962     function totalSupply() external view returns (uint256);
963 
964     function balanceOf(address owner) external view returns (uint256);
965 
966     function allowance(address owner, address spender)
967         external
968         view
969         returns (uint256);
970 
971     function approve(address spender, uint256 value) external returns (bool);
972 
973     function transfer(address to, uint256 value) external returns (bool);
974 
975     function transferFrom(
976         address from,
977         address to,
978         uint256 value
979     ) external returns (bool);
980 
981     function DOMAIN_SEPARATOR() external view returns (bytes32);
982 
983     function PERMIT_TYPEHASH() external pure returns (bytes32);
984 
985     function nonces(address owner) external view returns (uint256);
986 
987     function permit(
988         address owner,
989         address spender,
990         uint256 value,
991         uint256 deadline,
992         uint8 v,
993         bytes32 r,
994         bytes32 s
995     ) external;
996 
997     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
998     event Burn(
999         address indexed sender,
1000         uint256 amount0,
1001         uint256 amount1,
1002         address indexed to
1003     );
1004     event Swap(
1005         address indexed sender,
1006         uint256 amount0In,
1007         uint256 amount1In,
1008         uint256 amount0Out,
1009         uint256 amount1Out,
1010         address indexed to
1011     );
1012     event Sync(uint112 reserve0, uint112 reserve1);
1013 
1014     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1015 
1016     function factory() external view returns (address);
1017 
1018     function token0() external view returns (address);
1019 
1020     function token1() external view returns (address);
1021 
1022     function getReserves()
1023         external
1024         view
1025         returns (
1026             uint112 reserve0,
1027             uint112 reserve1,
1028             uint32 blockTimestampLast
1029         );
1030 
1031     function price0CumulativeLast() external view returns (uint256);
1032 
1033     function price1CumulativeLast() external view returns (uint256);
1034 
1035     function kLast() external view returns (uint256);
1036 
1037     function mint(address to) external returns (uint256 liquidity);
1038 
1039     function burn(address to)
1040         external
1041         returns (uint256 amount0, uint256 amount1);
1042 
1043     function swap(
1044         uint256 amount0Out,
1045         uint256 amount1Out,
1046         address to,
1047         bytes calldata data
1048     ) external;
1049 
1050     function skim(address to) external;
1051 
1052     function sync() external;
1053 
1054     function initialize(address, address) external;
1055 }
1056 
1057 // pragma solidity >=0.6.2;
1058 
1059 interface IUniswapV2Router01 {
1060     function factory() external pure returns (address);
1061 
1062     function WETH() external pure returns (address);
1063 
1064     function addLiquidity(
1065         address tokenA,
1066         address tokenB,
1067         uint256 amountADesired,
1068         uint256 amountBDesired,
1069         uint256 amountAMin,
1070         uint256 amountBMin,
1071         address to,
1072         uint256 deadline
1073     )
1074         external
1075         returns (
1076             uint256 amountA,
1077             uint256 amountB,
1078             uint256 liquidity
1079         );
1080 
1081     function addLiquidityETH(
1082         address token,
1083         uint256 amountTokenDesired,
1084         uint256 amountTokenMin,
1085         uint256 amountETHMin,
1086         address to,
1087         uint256 deadline
1088     )
1089         external
1090         payable
1091         returns (
1092             uint256 amountToken,
1093             uint256 amountETH,
1094             uint256 liquidity
1095         );
1096 
1097     function removeLiquidity(
1098         address tokenA,
1099         address tokenB,
1100         uint256 liquidity,
1101         uint256 amountAMin,
1102         uint256 amountBMin,
1103         address to,
1104         uint256 deadline
1105     ) external returns (uint256 amountA, uint256 amountB);
1106 
1107     function removeLiquidityETH(
1108         address token,
1109         uint256 liquidity,
1110         uint256 amountTokenMin,
1111         uint256 amountETHMin,
1112         address to,
1113         uint256 deadline
1114     ) external returns (uint256 amountToken, uint256 amountETH);
1115 
1116     function removeLiquidityWithPermit(
1117         address tokenA,
1118         address tokenB,
1119         uint256 liquidity,
1120         uint256 amountAMin,
1121         uint256 amountBMin,
1122         address to,
1123         uint256 deadline,
1124         bool approveMax,
1125         uint8 v,
1126         bytes32 r,
1127         bytes32 s
1128     ) external returns (uint256 amountA, uint256 amountB);
1129 
1130     function removeLiquidityETHWithPermit(
1131         address token,
1132         uint256 liquidity,
1133         uint256 amountTokenMin,
1134         uint256 amountETHMin,
1135         address to,
1136         uint256 deadline,
1137         bool approveMax,
1138         uint8 v,
1139         bytes32 r,
1140         bytes32 s
1141     ) external returns (uint256 amountToken, uint256 amountETH);
1142 
1143     function swapExactTokensForTokens(
1144         uint256 amountIn,
1145         uint256 amountOutMin,
1146         address[] calldata path,
1147         address to,
1148         uint256 deadline
1149     ) external returns (uint256[] memory amounts);
1150 
1151     function swapTokensForExactTokens(
1152         uint256 amountOut,
1153         uint256 amountInMax,
1154         address[] calldata path,
1155         address to,
1156         uint256 deadline
1157     ) external returns (uint256[] memory amounts);
1158 
1159     function swapExactETHForTokens(
1160         uint256 amountOutMin,
1161         address[] calldata path,
1162         address to,
1163         uint256 deadline
1164     ) external payable returns (uint256[] memory amounts);
1165 
1166     function swapTokensForExactETH(
1167         uint256 amountOut,
1168         uint256 amountInMax,
1169         address[] calldata path,
1170         address to,
1171         uint256 deadline
1172     ) external returns (uint256[] memory amounts);
1173 
1174     function swapExactTokensForETH(
1175         uint256 amountIn,
1176         uint256 amountOutMin,
1177         address[] calldata path,
1178         address to,
1179         uint256 deadline
1180     ) external returns (uint256[] memory amounts);
1181 
1182     function swapETHForExactTokens(
1183         uint256 amountOut,
1184         address[] calldata path,
1185         address to,
1186         uint256 deadline
1187     ) external payable returns (uint256[] memory amounts);
1188 
1189     function quote(
1190         uint256 amountA,
1191         uint256 reserveA,
1192         uint256 reserveB
1193     ) external pure returns (uint256 amountB);
1194 
1195     function getAmountOut(
1196         uint256 amountIn,
1197         uint256 reserveIn,
1198         uint256 reserveOut
1199     ) external pure returns (uint256 amountOut);
1200 
1201     function getAmountIn(
1202         uint256 amountOut,
1203         uint256 reserveIn,
1204         uint256 reserveOut
1205     ) external pure returns (uint256 amountIn);
1206 
1207     function getAmountsOut(uint256 amountIn, address[] calldata path)
1208         external
1209         view
1210         returns (uint256[] memory amounts);
1211 
1212     function getAmountsIn(uint256 amountOut, address[] calldata path)
1213         external
1214         view
1215         returns (uint256[] memory amounts);
1216 }
1217 
1218 // pragma solidity >=0.6.2;
1219 
1220 // import './IUniswapV2Router01.sol';
1221 
1222 interface IUniswapV2Router02 is IUniswapV2Router01 {
1223     function removeLiquidityETHSupportingFeeOnTransferTokens(
1224         address token,
1225         uint256 liquidity,
1226         uint256 amountTokenMin,
1227         uint256 amountETHMin,
1228         address to,
1229         uint256 deadline
1230     ) external returns (uint256 amountETH);
1231 
1232     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1233         address token,
1234         uint256 liquidity,
1235         uint256 amountTokenMin,
1236         uint256 amountETHMin,
1237         address to,
1238         uint256 deadline,
1239         bool approveMax,
1240         uint8 v,
1241         bytes32 r,
1242         bytes32 s
1243     ) external returns (uint256 amountETH);
1244 
1245     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1246         uint256 amountIn,
1247         uint256 amountOutMin,
1248         address[] calldata path,
1249         address to,
1250         uint256 deadline
1251     ) external;
1252 
1253     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1254         uint256 amountOutMin,
1255         address[] calldata path,
1256         address to,
1257         uint256 deadline
1258     ) external payable;
1259 
1260     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1261         uint256 amountIn,
1262         uint256 amountOutMin,
1263         address[] calldata path,
1264         address to,
1265         uint256 deadline
1266     ) external;
1267 }
1268 
1269 contract Blue is ERC20, Ownable {
1270     using SafeMath for uint256;
1271 
1272     IUniswapV2Router02 public immutable uniswapV2Router;
1273     address public immutable uniswapV2Pair;
1274     address public constant deadAddress = address(0xdead);
1275 
1276     bool private swapping;
1277 
1278     address public marketingWallet;
1279 
1280     uint256 public maxTransactionAmount;
1281     uint256 public swapTokensAtAmount;
1282     uint256 public maxWallet;
1283 
1284     uint256 public buyTotalFees;
1285     uint256 private buyMarketingFee;
1286     uint256 private buyLiquidityFee;
1287 
1288     uint256 public sellTotalFees;
1289     uint256 private sellMarketingFee;
1290     uint256 private sellLiquidityFee;
1291 
1292     uint256 private tokensForMarketing;
1293     uint256 private tokensForLiquidity;
1294     uint256 private previousFee;
1295 
1296     mapping(address => bool) private _isExcludedFromFees;
1297     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1298     mapping(address => bool) private automatedMarketMakerPairs;
1299 
1300     event ExcludeFromFees(address indexed account, bool isExcluded);
1301 
1302     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1303 
1304     event marketingWalletUpdated(
1305         address indexed newWallet,
1306         address indexed oldWallet
1307     );
1308 
1309     event SwapAndLiquify(
1310         uint256 tokensSwapped,
1311         uint256 ethReceived,
1312         uint256 tokensIntoLiquidity
1313     );
1314 
1315     constructor() ERC20("TwBluePepeAvatarPepsiSonic10Inu", "Blue") {
1316         uniswapV2Router = IUniswapV2Router02(
1317             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1318         );
1319         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1320             address(this),
1321             uniswapV2Router.WETH()
1322         );
1323 
1324         uint256 totalSupply = 777_000_777_000 ether;
1325 
1326         maxTransactionAmount = totalSupply;
1327         maxWallet = totalSupply;
1328         swapTokensAtAmount = (totalSupply * 1) / 1000;
1329 
1330         buyMarketingFee = 1;
1331         buyLiquidityFee = 0;
1332         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1333 
1334         sellMarketingFee = 10;    // will change back to 1 along with ownership renounced in 15 mins after the launch
1335         sellLiquidityFee = 0;
1336         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1337         previousFee = sellTotalFees;
1338 
1339         marketingWallet = owner();
1340 
1341         excludeFromFees(owner(), true);
1342         excludeFromFees(address(this), true);
1343         excludeFromFees(deadAddress, true);
1344 
1345         excludeFromMaxTransaction(owner(), true);
1346         excludeFromMaxTransaction(address(this), true);
1347         excludeFromMaxTransaction(deadAddress, true);
1348         excludeFromMaxTransaction(address(uniswapV2Router), true);
1349         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1350 
1351         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1352 
1353         _mint(msg.sender, totalSupply);
1354     }
1355 
1356     receive() external payable {}
1357 
1358     function updateSwapTokensAtAmount(uint256 newAmount)
1359         external
1360         onlyOwner
1361         returns (bool)
1362     {
1363         require(
1364             newAmount >= (totalSupply() * 1) / 100000,
1365             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1366         );
1367         require(
1368             newAmount <= (totalSupply() * 5) / 1000,
1369             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1370         );
1371         swapTokensAtAmount = newAmount;
1372         return true;
1373     }
1374 
1375     function updateMaxWalletAndTxnAmount(
1376         uint256 newTxnNum,
1377         uint256 newMaxWalletNum
1378     ) external onlyOwner {
1379         require(
1380             newTxnNum >= ((totalSupply() * 5) / 1000),
1381             "ERC20: Cannot set maxTxn lower than 0.5%"
1382         );
1383         require(
1384             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1385             "ERC20: Cannot set maxWallet lower than 0.5%"
1386         );
1387         maxWallet = newMaxWalletNum;
1388         maxTransactionAmount = newTxnNum;
1389     }
1390 
1391     function excludeFromMaxTransaction(address updAds, bool isEx)
1392         public
1393         onlyOwner
1394     {
1395         _isExcludedMaxTransactionAmount[updAds] = isEx;
1396     }
1397 
1398     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1399         public
1400         onlyOwner
1401     {
1402         sellMarketingFee = _marketingFee;
1403         sellLiquidityFee = _liquidityFee;
1404         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1405         previousFee = sellTotalFees;
1406         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1407     }
1408 
1409     function excludeFromFees(address account, bool excluded) public onlyOwner {
1410         _isExcludedFromFees[account] = excluded;
1411         emit ExcludeFromFees(account, excluded);
1412     }
1413 
1414     function withdrawStuckETH() public onlyOwner {
1415         bool success;
1416         (success, ) = address(msg.sender).call{value: address(this).balance}(
1417             ""
1418         );
1419     }
1420 
1421     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1422         automatedMarketMakerPairs[pair] = value;
1423 
1424         emit SetAutomatedMarketMakerPair(pair, value);
1425     }
1426 
1427     function isExcludedFromFees(address account) public view returns (bool) {
1428         return _isExcludedFromFees[account];
1429     }
1430 
1431     function _transfer(
1432         address from,
1433         address to,
1434         uint256 amount
1435     ) internal override {
1436         require(from != address(0), "ERC20: transfer from the zero address");
1437         require(to != address(0), "ERC20: transfer to the zero address");
1438 
1439         if (amount == 0) {
1440             super._transfer(from, to, 0);
1441             return;
1442         }
1443 
1444         if (
1445             from != owner() &&
1446             to != owner() &&
1447             to != address(0) &&
1448             to != deadAddress &&
1449             !swapping
1450         ) {
1451             //when buy
1452             if (
1453                 automatedMarketMakerPairs[from] &&
1454                 !_isExcludedMaxTransactionAmount[to]
1455             ) {
1456                 require(
1457                     amount <= maxTransactionAmount,
1458                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1459                 );
1460                 require(
1461                     amount + balanceOf(to) <= maxWallet,
1462                     "ERC20: Max wallet exceeded"
1463                 );
1464             }
1465             //when sell
1466             else if (
1467                 automatedMarketMakerPairs[to] &&
1468                 !_isExcludedMaxTransactionAmount[from]
1469             ) {
1470                 require(
1471                     amount <= maxTransactionAmount,
1472                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1473                 );
1474             } else if (!_isExcludedMaxTransactionAmount[to]) {
1475                 require(
1476                     amount + balanceOf(to) <= maxWallet,
1477                     "ERC20: Max wallet exceeded"
1478                 );
1479             }
1480         }
1481 
1482         uint256 contractTokenBalance = balanceOf(address(this));
1483 
1484         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1485 
1486         if (
1487             canSwap &&
1488             !swapping &&
1489             !automatedMarketMakerPairs[from] &&
1490             !_isExcludedFromFees[from] &&
1491             !_isExcludedFromFees[to]
1492         ) {
1493             swapping = true;
1494 
1495             swapBack();
1496 
1497             swapping = false;
1498         }
1499 
1500         bool takeFee = !swapping;
1501 
1502         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1503             takeFee = false;
1504         }
1505 
1506         uint256 fees = 0;
1507 
1508         if (takeFee) {
1509             // on sell
1510             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1511                 fees = amount.mul(sellTotalFees).div(100);
1512                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1513                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1514             }
1515             // on buy
1516             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1517                 fees = amount.mul(buyTotalFees).div(100);
1518                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1519                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1520             }
1521 
1522             if (fees > 0) {
1523                 super._transfer(from, address(this), fees);
1524             }
1525 
1526             amount -= fees;
1527         }
1528 
1529         super._transfer(from, to, amount);
1530         sellTotalFees = previousFee;
1531     }
1532 
1533     function swapTokensForEth(uint256 tokenAmount) private {
1534         address[] memory path = new address[](2);
1535         path[0] = address(this);
1536         path[1] = uniswapV2Router.WETH();
1537 
1538         _approve(address(this), address(uniswapV2Router), tokenAmount);
1539 
1540         // make the swap
1541         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1542             tokenAmount,
1543             0,
1544             path,
1545             address(this),
1546             block.timestamp
1547         );
1548     }
1549 
1550     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1551         _approve(address(this), address(uniswapV2Router), tokenAmount);
1552 
1553         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1554             address(this),
1555             tokenAmount,
1556             0,
1557             0,
1558             owner(),
1559             block.timestamp
1560         );
1561     }
1562 
1563     function swapBack() private {
1564         uint256 contractBalance = balanceOf(address(this));
1565         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1566         bool success;
1567 
1568         if (contractBalance == 0 || totalTokensToSwap == 0) {
1569             return;
1570         }
1571 
1572         if (contractBalance > swapTokensAtAmount * 20) {
1573             contractBalance = swapTokensAtAmount * 20;
1574         }
1575 
1576         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1577             totalTokensToSwap /
1578             2;
1579         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1580 
1581         uint256 initialETHBalance = address(this).balance;
1582 
1583         swapTokensForEth(amountToSwapForETH);
1584 
1585         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1586 
1587         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1588             totalTokensToSwap
1589         );
1590 
1591         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1592 
1593         tokensForLiquidity = 0;
1594         tokensForMarketing = 0;
1595 
1596         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1597             addLiquidity(liquidityTokens, ethForLiquidity);
1598             emit SwapAndLiquify(
1599                 amountToSwapForETH,
1600                 ethForLiquidity,
1601                 tokensForLiquidity
1602             );
1603         }
1604 
1605         (success, ) = address(marketingWallet).call{value: address(this).balance}(
1606             ""
1607         );
1608     }
1609 }