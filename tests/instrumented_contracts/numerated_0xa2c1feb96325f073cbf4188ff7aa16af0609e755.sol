1 /** 
2     Telegram - https://t.me/wrappedethereumpro
3     Twitter - https://twitter.com/weproerc
4     Website - https://wrappedethereumpro.com
5 **/
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.20;
10 pragma experimental ABIEncoderV2;
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 // pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
37 
38 // pragma solidity ^0.8.0;
39 
40 // import "../utils/Context.sol";
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() {
66         _transferOwnership(_msgSender());
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         _checkOwner();
74         _;
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view virtual returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if the sender is not the owner.
86      */
87     function _checkOwner() internal view virtual {
88         require(owner() == _msgSender(), "Ownable: caller is not the owner");
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby disabling any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(
108             newOwner != address(0),
109             "Ownable: new owner is the zero address"
110         );
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
126 
127 // pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Interface of the ERC20 standard as defined in the EIP.
131  */
132 interface IERC20 {
133     /**
134      * @dev Emitted when `value` tokens are moved from one account (`from`) to
135      * another (`to`).
136      *
137      * Note that `value` may be zero.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     /**
142      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
143      * a call to {approve}. `value` is the new allowance.
144      */
145     event Approval(
146         address indexed owner,
147         address indexed spender,
148         uint256 value
149     );
150 
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `to`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address to, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender)
178         external
179         view
180         returns (uint256);
181 
182     /**
183      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * IMPORTANT: Beware that changing an allowance with this method brings the risk
188      * that someone may use both the old and the new allowance by unfortunate
189      * transaction ordering. One possible solution to mitigate this race
190      * condition is to first reduce the spender's allowance to 0 and set the
191      * desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      *
194      * Emits an {Approval} event.
195      */
196     function approve(address spender, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Moves `amount` tokens from `from` to `to` using the
200      * allowance mechanism. `amount` is then deducted from the caller's
201      * allowance.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 amount
211     ) external returns (bool);
212 }
213 
214 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
215 
216 // pragma solidity ^0.8.0;
217 
218 // import "../IERC20.sol";
219 
220 /**
221  * @dev Interface for the optional metadata functions from the ERC20 standard.
222  *
223  * _Available since v4.1._
224  */
225 interface IERC20Metadata is IERC20 {
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() external view returns (string memory);
230 
231     /**
232      * @dev Returns the symbol of the token.
233      */
234     function symbol() external view returns (string memory);
235 
236     /**
237      * @dev Returns the decimals places of the token.
238      */
239     function decimals() external view returns (uint8);
240 }
241 
242 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
243 
244 // pragma solidity ^0.8.0;
245 
246 // import "./IERC20.sol";
247 // import "./extensions/IERC20Metadata.sol";
248 // import "../../utils/Context.sol";
249 
250 /**
251  * @dev Implementation of the {IERC20} interface.
252  *
253  * This implementation is agnostic to the way tokens are created. This means
254  * that a supply mechanism has to be added in a derived contract using {_mint}.
255  * For a generic mechanism see {ERC20PresetMinterPauser}.
256  *
257  * TIP: For a detailed writeup see our guide
258  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
259  * to implement supply mechanisms].
260  *
261  * The default value of {decimals} is 18. To change this, you should override
262  * this function so it returns a different value.
263  *
264  * We have followed general OpenZeppelin Contracts guidelines: functions revert
265  * instead returning `false` on failure. This behavior is nonetheless
266  * conventional and does not conflict with the expectations of ERC20
267  * applications.
268  *
269  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
270  * This allows applications to reconstruct the allowance for all accounts just
271  * by listening to said events. Other implementations of the EIP may not emit
272  * these events, as it isn't required by the specification.
273  *
274  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
275  * functions have been added to mitigate the well-known issues around setting
276  * allowances. See {IERC20-approve}.
277  */
278 contract ERC20 is Context, IERC20, IERC20Metadata {
279     mapping(address => uint256) private _balances;
280 
281     mapping(address => mapping(address => uint256)) private _allowances;
282 
283     uint256 private _totalSupply;
284 
285     string private _name;
286     string private _symbol;
287 
288     /**
289      * @dev Sets the values for {name} and {symbol}.
290      *
291      * All two of these values are immutable: they can only be set once during
292      * construction.
293      */
294     constructor(string memory name_, string memory symbol_) {
295         _name = name_;
296         _symbol = symbol_;
297     }
298 
299     /**
300      * @dev Returns the name of the token.
301      */
302     function name() public view virtual override returns (string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev Returns the symbol of the token, usually a shorter version of the
308      * name.
309      */
310     function symbol() public view virtual override returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @dev Returns the number of decimals used to get its user representation.
316      * For example, if `decimals` equals `2`, a balance of `505` tokens should
317      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
318      *
319      * Tokens usually opt for a value of 18, imitating the relationship between
320      * Ether and Wei. This is the default value returned by this function, unless
321      * it's overridden.
322      *
323      * NOTE: This information is only used for _display_ purposes: it in
324      * no way affects any of the arithmetic of the contract, including
325      * {IERC20-balanceOf} and {IERC20-transfer}.
326      */
327     function decimals() public view virtual override returns (uint8) {
328         return 18;
329     }
330 
331     /**
332      * @dev See {IERC20-totalSupply}.
333      */
334     function totalSupply() public view virtual override returns (uint256) {
335         return _totalSupply;
336     }
337 
338     /**
339      * @dev See {IERC20-balanceOf}.
340      */
341     function balanceOf(address account)
342         public
343         view
344         virtual
345         override
346         returns (uint256)
347     {
348         return _balances[account];
349     }
350 
351     /**
352      * @dev See {IERC20-transfer}.
353      *
354      * Requirements:
355      *
356      * - `to` cannot be the zero address.
357      * - the caller must have a balance of at least `amount`.
358      */
359     function transfer(address to, uint256 amount)
360         public
361         virtual
362         override
363         returns (bool)
364     {
365         address owner = _msgSender();
366         _transfer(owner, to, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-allowance}.
372      */
373     function allowance(address owner, address spender)
374         public
375         view
376         virtual
377         override
378         returns (uint256)
379     {
380         return _allowances[owner][spender];
381     }
382 
383     /**
384      * @dev See {IERC20-approve}.
385      *
386      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
387      * `transferFrom`. This is semantically equivalent to an infinite approval.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function approve(address spender, uint256 amount)
394         public
395         virtual
396         override
397         returns (bool)
398     {
399         address owner = _msgSender();
400         _approve(owner, spender, amount);
401         return true;
402     }
403 
404     /**
405      * @dev See {IERC20-transferFrom}.
406      *
407      * Emits an {Approval} event indicating the updated allowance. This is not
408      * required by the EIP. See the note at the beginning of {ERC20}.
409      *
410      * NOTE: Does not update the allowance if the current allowance
411      * is the maximum `uint256`.
412      *
413      * Requirements:
414      *
415      * - `from` and `to` cannot be the zero address.
416      * - `from` must have a balance of at least `amount`.
417      * - the caller must have allowance for ``from``'s tokens of at least
418      * `amount`.
419      */
420     function transferFrom(
421         address from,
422         address to,
423         uint256 amount
424     ) public virtual override returns (bool) {
425         address spender = _msgSender();
426         _spendAllowance(from, spender, amount);
427         _transfer(from, to, amount);
428         return true;
429     }
430 
431     /**
432      * @dev Atomically increases the allowance granted to `spender` by the caller.
433      *
434      * This is an alternative to {approve} that can be used as a mitigation for
435      * problems described in {IERC20-approve}.
436      *
437      * Emits an {Approval} event indicating the updated allowance.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      */
443     function increaseAllowance(address spender, uint256 addedValue)
444         public
445         virtual
446         returns (bool)
447     {
448         address owner = _msgSender();
449         _approve(owner, spender, allowance(owner, spender) + addedValue);
450         return true;
451     }
452 
453     /**
454      * @dev Atomically decreases the allowance granted to `spender` by the caller.
455      *
456      * This is an alternative to {approve} that can be used as a mitigation for
457      * problems described in {IERC20-approve}.
458      *
459      * Emits an {Approval} event indicating the updated allowance.
460      *
461      * Requirements:
462      *
463      * - `spender` cannot be the zero address.
464      * - `spender` must have allowance for the caller of at least
465      * `subtractedValue`.
466      */
467     function decreaseAllowance(address spender, uint256 subtractedValue)
468         public
469         virtual
470         returns (bool)
471     {
472         address owner = _msgSender();
473         uint256 currentAllowance = allowance(owner, spender);
474         require(
475             currentAllowance >= subtractedValue,
476             "ERC20: decreased allowance below zero"
477         );
478         unchecked {
479             _approve(owner, spender, currentAllowance - subtractedValue);
480         }
481 
482         return true;
483     }
484 
485     /**
486      * @dev Moves `amount` of tokens from `from` to `to`.
487      *
488      * This internal function is equivalent to {transfer}, and can be used to
489      * e.g. implement automatic token fees, slashing mechanisms, etc.
490      *
491      * Emits a {Transfer} event.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `from` must have a balance of at least `amount`.
498      */
499     function _transfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {
504         require(from != address(0), "ERC20: transfer from the zero address");
505         require(to != address(0), "ERC20: transfer to the zero address");
506 
507         _beforeTokenTransfer(from, to, amount);
508 
509         uint256 fromBalance = _balances[from];
510         require(
511             fromBalance >= amount,
512             "ERC20: transfer amount exceeds balance"
513         );
514         unchecked {
515             _balances[from] = fromBalance - amount;
516             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
517             // decrementing then incrementing.
518             _balances[to] += amount;
519         }
520 
521         emit Transfer(from, to, amount);
522 
523         _afterTokenTransfer(from, to, amount);
524     }
525 
526     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
527      * the total supply.
528      *
529      * Emits a {Transfer} event with `from` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      */
535     function _mint(address account, uint256 amount) internal virtual {
536         require(account != address(0), "ERC20: mint to the zero address");
537 
538         _beforeTokenTransfer(address(0), account, amount);
539 
540         _totalSupply += amount;
541         unchecked {
542             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
543             _balances[account] += amount;
544         }
545         emit Transfer(address(0), account, amount);
546 
547         _afterTokenTransfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         uint256 accountBalance = _balances[account];
567         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
568         unchecked {
569             _balances[account] = accountBalance - amount;
570             // Overflow not possible: amount <= accountBalance <= totalSupply.
571             _totalSupply -= amount;
572         }
573 
574         emit Transfer(account, address(0), amount);
575 
576         _afterTokenTransfer(account, address(0), amount);
577     }
578 
579     /**
580      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
581      *
582      * This internal function is equivalent to `approve`, and can be used to
583      * e.g. set automatic allowances for certain subsystems, etc.
584      *
585      * Emits an {Approval} event.
586      *
587      * Requirements:
588      *
589      * - `owner` cannot be the zero address.
590      * - `spender` cannot be the zero address.
591      */
592     function _approve(
593         address owner,
594         address spender,
595         uint256 amount
596     ) internal virtual {
597         require(owner != address(0), "ERC20: approve from the zero address");
598         require(spender != address(0), "ERC20: approve to the zero address");
599 
600         _allowances[owner][spender] = amount;
601         emit Approval(owner, spender, amount);
602     }
603 
604     /**
605      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
606      *
607      * Does not update the allowance amount in case of infinite allowance.
608      * Revert if not enough allowance is available.
609      *
610      * Might emit an {Approval} event.
611      */
612     function _spendAllowance(
613         address owner,
614         address spender,
615         uint256 amount
616     ) internal virtual {
617         uint256 currentAllowance = allowance(owner, spender);
618         if (currentAllowance != type(uint256).max) {
619             require(
620                 currentAllowance >= amount,
621                 "ERC20: insufficient allowance"
622             );
623             unchecked {
624                 _approve(owner, spender, currentAllowance - amount);
625             }
626         }
627     }
628 
629     /**
630      * @dev Hook that is called before any transfer of tokens. This includes
631      * minting and burning.
632      *
633      * Calling conditions:
634      *
635      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
636      * will be transferred to `to`.
637      * - when `from` is zero, `amount` tokens will be minted for `to`.
638      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
639      * - `from` and `to` are never both zero.
640      *
641      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
642      */
643     function _beforeTokenTransfer(
644         address from,
645         address to,
646         uint256 amount
647     ) internal virtual {}
648 
649     /**
650      * @dev Hook that is called after any transfer of tokens. This includes
651      * minting and burning.
652      *
653      * Calling conditions:
654      *
655      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
656      * has been transferred to `to`.
657      * - when `from` is zero, `amount` tokens have been minted for `to`.
658      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
659      * - `from` and `to` are never both zero.
660      *
661      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
662      */
663     function _afterTokenTransfer(
664         address from,
665         address to,
666         uint256 amount
667     ) internal virtual {}
668 }
669 
670 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
671 
672 // pragma solidity ^0.8.0;
673 
674 // CAUTION
675 // This version of SafeMath should only be used with Solidity 0.8 or later,
676 // because it relies on the compiler's built in overflow checks.
677 
678 /**
679  * @dev Wrappers over Solidity's arithmetic operations.
680  *
681  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
682  * now has built in overflow checking.
683  */
684 library SafeMath {
685     /**
686      * @dev Returns the addition of two unsigned integers, with an overflow flag.
687      *
688      * _Available since v3.4._
689      */
690     function tryAdd(uint256 a, uint256 b)
691         internal
692         pure
693         returns (bool, uint256)
694     {
695         unchecked {
696             uint256 c = a + b;
697             if (c < a) return (false, 0);
698             return (true, c);
699         }
700     }
701 
702     /**
703      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
704      *
705      * _Available since v3.4._
706      */
707     function trySub(uint256 a, uint256 b)
708         internal
709         pure
710         returns (bool, uint256)
711     {
712         unchecked {
713             if (b > a) return (false, 0);
714             return (true, a - b);
715         }
716     }
717 
718     /**
719      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
720      *
721      * _Available since v3.4._
722      */
723     function tryMul(uint256 a, uint256 b)
724         internal
725         pure
726         returns (bool, uint256)
727     {
728         unchecked {
729             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
730             // benefit is lost if 'b' is also tested.
731             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
732             if (a == 0) return (true, 0);
733             uint256 c = a * b;
734             if (c / a != b) return (false, 0);
735             return (true, c);
736         }
737     }
738 
739     /**
740      * @dev Returns the division of two unsigned integers, with a division by zero flag.
741      *
742      * _Available since v3.4._
743      */
744     function tryDiv(uint256 a, uint256 b)
745         internal
746         pure
747         returns (bool, uint256)
748     {
749         unchecked {
750             if (b == 0) return (false, 0);
751             return (true, a / b);
752         }
753     }
754 
755     /**
756      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
757      *
758      * _Available since v3.4._
759      */
760     function tryMod(uint256 a, uint256 b)
761         internal
762         pure
763         returns (bool, uint256)
764     {
765         unchecked {
766             if (b == 0) return (false, 0);
767             return (true, a % b);
768         }
769     }
770 
771     /**
772      * @dev Returns the addition of two unsigned integers, reverting on
773      * overflow.
774      *
775      * Counterpart to Solidity's `+` operator.
776      *
777      * Requirements:
778      *
779      * - Addition cannot overflow.
780      */
781     function add(uint256 a, uint256 b) internal pure returns (uint256) {
782         return a + b;
783     }
784 
785     /**
786      * @dev Returns the subtraction of two unsigned integers, reverting on
787      * overflow (when the result is negative).
788      *
789      * Counterpart to Solidity's `-` operator.
790      *
791      * Requirements:
792      *
793      * - Subtraction cannot overflow.
794      */
795     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
796         return a - b;
797     }
798 
799     /**
800      * @dev Returns the multiplication of two unsigned integers, reverting on
801      * overflow.
802      *
803      * Counterpart to Solidity's `*` operator.
804      *
805      * Requirements:
806      *
807      * - Multiplication cannot overflow.
808      */
809     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
810         return a * b;
811     }
812 
813     /**
814      * @dev Returns the integer division of two unsigned integers, reverting on
815      * division by zero. The result is rounded towards zero.
816      *
817      * Counterpart to Solidity's `/` operator.
818      *
819      * Requirements:
820      *
821      * - The divisor cannot be zero.
822      */
823     function div(uint256 a, uint256 b) internal pure returns (uint256) {
824         return a / b;
825     }
826 
827     /**
828      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
829      * reverting when dividing by zero.
830      *
831      * Counterpart to Solidity's `%` operator. This function uses a `revert`
832      * opcode (which leaves remaining gas untouched) while Solidity uses an
833      * invalid opcode to revert (consuming all remaining gas).
834      *
835      * Requirements:
836      *
837      * - The divisor cannot be zero.
838      */
839     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
840         return a % b;
841     }
842 
843     /**
844      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
845      * overflow (when the result is negative).
846      *
847      * CAUTION: This function is deprecated because it requires allocating memory for the error
848      * message unnecessarily. For custom revert reasons use {trySub}.
849      *
850      * Counterpart to Solidity's `-` operator.
851      *
852      * Requirements:
853      *
854      * - Subtraction cannot overflow.
855      */
856     function sub(
857         uint256 a,
858         uint256 b,
859         string memory errorMessage
860     ) internal pure returns (uint256) {
861         unchecked {
862             require(b <= a, errorMessage);
863             return a - b;
864         }
865     }
866 
867     /**
868      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
869      * division by zero. The result is rounded towards zero.
870      *
871      * Counterpart to Solidity's `/` operator. Note: this function uses a
872      * `revert` opcode (which leaves remaining gas untouched) while Solidity
873      * uses an invalid opcode to revert (consuming all remaining gas).
874      *
875      * Requirements:
876      *
877      * - The divisor cannot be zero.
878      */
879     function div(
880         uint256 a,
881         uint256 b,
882         string memory errorMessage
883     ) internal pure returns (uint256) {
884         unchecked {
885             require(b > 0, errorMessage);
886             return a / b;
887         }
888     }
889 
890     /**
891      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
892      * reverting with custom message when dividing by zero.
893      *
894      * CAUTION: This function is deprecated because it requires allocating memory for the error
895      * message unnecessarily. For custom revert reasons use {tryMod}.
896      *
897      * Counterpart to Solidity's `%` operator. This function uses a `revert`
898      * opcode (which leaves remaining gas untouched) while Solidity uses an
899      * invalid opcode to revert (consuming all remaining gas).
900      *
901      * Requirements:
902      *
903      * - The divisor cannot be zero.
904      */
905     function mod(
906         uint256 a,
907         uint256 b,
908         string memory errorMessage
909     ) internal pure returns (uint256) {
910         unchecked {
911             require(b > 0, errorMessage);
912             return a % b;
913         }
914     }
915 }
916 
917 // pragma solidity >=0.5.0;
918 
919 interface IUniswapV2Factory {
920     event PairCreated(
921         address indexed token0,
922         address indexed token1,
923         address pair,
924         uint256
925     );
926 
927     function feeTo() external view returns (address);
928 
929     function feeToSetter() external view returns (address);
930 
931     function getPair(address tokenA, address tokenB)
932         external
933         view
934         returns (address pair);
935 
936     function allPairs(uint256) external view returns (address pair);
937 
938     function allPairsLength() external view returns (uint256);
939 
940     function createPair(address tokenA, address tokenB)
941         external
942         returns (address pair);
943 
944     function setFeeTo(address) external;
945 
946     function setFeeToSetter(address) external;
947 }
948 
949 // pragma solidity >=0.6.2;
950 
951 interface IUniswapV2Router01 {
952     function factory() external pure returns (address);
953 
954     function WETH() external pure returns (address);
955 
956     function addLiquidity(
957         address tokenA,
958         address tokenB,
959         uint256 amountADesired,
960         uint256 amountBDesired,
961         uint256 amountAMin,
962         uint256 amountBMin,
963         address to,
964         uint256 deadline
965     )
966         external
967         returns (
968             uint256 amountA,
969             uint256 amountB,
970             uint256 liquidity
971         );
972 
973     function addLiquidityETH(
974         address token,
975         uint256 amountTokenDesired,
976         uint256 amountTokenMin,
977         uint256 amountETHMin,
978         address to,
979         uint256 deadline
980     )
981         external
982         payable
983         returns (
984             uint256 amountToken,
985             uint256 amountETH,
986             uint256 liquidity
987         );
988 
989     function removeLiquidity(
990         address tokenA,
991         address tokenB,
992         uint256 liquidity,
993         uint256 amountAMin,
994         uint256 amountBMin,
995         address to,
996         uint256 deadline
997     ) external returns (uint256 amountA, uint256 amountB);
998 
999     function removeLiquidityETH(
1000         address token,
1001         uint256 liquidity,
1002         uint256 amountTokenMin,
1003         uint256 amountETHMin,
1004         address to,
1005         uint256 deadline
1006     ) external returns (uint256 amountToken, uint256 amountETH);
1007 
1008     function removeLiquidityWithPermit(
1009         address tokenA,
1010         address tokenB,
1011         uint256 liquidity,
1012         uint256 amountAMin,
1013         uint256 amountBMin,
1014         address to,
1015         uint256 deadline,
1016         bool approveMax,
1017         uint8 v,
1018         bytes32 r,
1019         bytes32 s
1020     ) external returns (uint256 amountA, uint256 amountB);
1021 
1022     function removeLiquidityETHWithPermit(
1023         address token,
1024         uint256 liquidity,
1025         uint256 amountTokenMin,
1026         uint256 amountETHMin,
1027         address to,
1028         uint256 deadline,
1029         bool approveMax,
1030         uint8 v,
1031         bytes32 r,
1032         bytes32 s
1033     ) external returns (uint256 amountToken, uint256 amountETH);
1034 
1035     function swapExactTokensForTokens(
1036         uint256 amountIn,
1037         uint256 amountOutMin,
1038         address[] calldata path,
1039         address to,
1040         uint256 deadline
1041     ) external returns (uint256[] memory amounts);
1042 
1043     function swapTokensForExactTokens(
1044         uint256 amountOut,
1045         uint256 amountInMax,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline
1049     ) external returns (uint256[] memory amounts);
1050 
1051     function swapExactETHForTokens(
1052         uint256 amountOutMin,
1053         address[] calldata path,
1054         address to,
1055         uint256 deadline
1056     ) external payable returns (uint256[] memory amounts);
1057 
1058     function swapTokensForExactETH(
1059         uint256 amountOut,
1060         uint256 amountInMax,
1061         address[] calldata path,
1062         address to,
1063         uint256 deadline
1064     ) external returns (uint256[] memory amounts);
1065 
1066     function swapExactTokensForETH(
1067         uint256 amountIn,
1068         uint256 amountOutMin,
1069         address[] calldata path,
1070         address to,
1071         uint256 deadline
1072     ) external returns (uint256[] memory amounts);
1073 
1074     function swapETHForExactTokens(
1075         uint256 amountOut,
1076         address[] calldata path,
1077         address to,
1078         uint256 deadline
1079     ) external payable returns (uint256[] memory amounts);
1080 
1081     function quote(
1082         uint256 amountA,
1083         uint256 reserveA,
1084         uint256 reserveB
1085     ) external pure returns (uint256 amountB);
1086 
1087     function getAmountOut(
1088         uint256 amountIn,
1089         uint256 reserveIn,
1090         uint256 reserveOut
1091     ) external pure returns (uint256 amountOut);
1092 
1093     function getAmountIn(
1094         uint256 amountOut,
1095         uint256 reserveIn,
1096         uint256 reserveOut
1097     ) external pure returns (uint256 amountIn);
1098 
1099     function getAmountsOut(uint256 amountIn, address[] calldata path)
1100         external
1101         view
1102         returns (uint256[] memory amounts);
1103 
1104     function getAmountsIn(uint256 amountOut, address[] calldata path)
1105         external
1106         view
1107         returns (uint256[] memory amounts);
1108 }
1109 
1110 // pragma solidity >=0.6.2;
1111 
1112 // import './IUniswapV2Router01.sol';
1113 
1114 interface IUniswapV2Router02 is IUniswapV2Router01 {
1115     function removeLiquidityETHSupportingFeeOnTransferTokens(
1116         address token,
1117         uint256 liquidity,
1118         uint256 amountTokenMin,
1119         uint256 amountETHMin,
1120         address to,
1121         uint256 deadline
1122     ) external returns (uint256 amountETH);
1123 
1124     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1125         address token,
1126         uint256 liquidity,
1127         uint256 amountTokenMin,
1128         uint256 amountETHMin,
1129         address to,
1130         uint256 deadline,
1131         bool approveMax,
1132         uint8 v,
1133         bytes32 r,
1134         bytes32 s
1135     ) external returns (uint256 amountETH);
1136 
1137     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1138         uint256 amountIn,
1139         uint256 amountOutMin,
1140         address[] calldata path,
1141         address to,
1142         uint256 deadline
1143     ) external;
1144 
1145     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1146         uint256 amountOutMin,
1147         address[] calldata path,
1148         address to,
1149         uint256 deadline
1150     ) external payable;
1151 
1152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1153         uint256 amountIn,
1154         uint256 amountOutMin,
1155         address[] calldata path,
1156         address to,
1157         uint256 deadline
1158     ) external;
1159 }
1160 
1161 contract WrappedEthereumPro is ERC20, Ownable {
1162     using SafeMath for uint256;
1163 
1164     IUniswapV2Router02 public immutable uniswapV2Router;
1165     address public immutable uniswapV2Pair;
1166     address public constant deadAddress = address(0xdead);
1167 
1168     bool private swapping;
1169 
1170     address public marketingWallet;
1171     address public developmentWallet;
1172 
1173     uint256 public maxTransactionAmount;
1174     uint256 public swapTokensAtAmount;
1175     uint256 public maxWallet;
1176 
1177     bool public tradingActive = false;
1178     bool public swapEnabled = false;
1179 
1180     uint256 public buyTotalFees;
1181     uint256 private buyMarketingFee;
1182     uint256 private buyDevelopmentFee;
1183     uint256 private buyLiquidityFee;
1184 
1185     uint256 public sellTotalFees;
1186     uint256 private sellMarketingFee;
1187     uint256 private sellDevelopmentFee;
1188     uint256 private sellLiquidityFee;
1189 
1190     uint256 private tokensForMarketing;
1191     uint256 private tokensForDevelopment;
1192     uint256 private tokensForLiquidity;
1193     uint256 private previousFee;
1194 
1195     mapping(address => bool) private _isExcludedFromFees;
1196     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1197     mapping(address => bool) private automatedMarketMakerPairs;
1198 
1199     event ExcludeFromFees(address indexed account, bool isExcluded);
1200 
1201     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1202 
1203     event marketingWalletUpdated(
1204         address indexed newWallet,
1205         address indexed oldWallet
1206     );
1207 
1208     event SwapAndLiquify(
1209         uint256 tokensSwapped,
1210         uint256 ethReceived,
1211         uint256 tokensIntoLiquidity
1212     );
1213 
1214     constructor() ERC20("Wrapped Ethereum Pro", "$WEPRO") {
1215         uniswapV2Router = IUniswapV2Router02(
1216             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1217         );
1218         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1219             address(this),
1220             uniswapV2Router.WETH()
1221         );
1222 
1223         uint256 totalSupply = 420_690_000_000 ether;
1224 
1225         maxTransactionAmount = (totalSupply * 2) / 100;
1226         maxWallet = (totalSupply * 2) / 100;
1227         swapTokensAtAmount = (totalSupply * 1) / 1000;
1228 
1229         buyMarketingFee = 50;
1230         buyDevelopmentFee = 1;
1231         buyLiquidityFee = 0;
1232         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1233 
1234         sellMarketingFee = 50;
1235         sellDevelopmentFee = 1;
1236         sellLiquidityFee = 0;
1237         sellTotalFees = sellMarketingFee + sellDevelopmentFee + sellLiquidityFee;
1238         previousFee = sellTotalFees;
1239 
1240         marketingWallet = 0xCB1bDF830f78CD7b51694e739F57A79E00d0cAf6;
1241         developmentWallet = 0x610D7fe497572CfaeA499d0a5E4eb4d22B90dD46;
1242 
1243         excludeFromFees(owner(), true);
1244         excludeFromFees(address(this), true);
1245         excludeFromFees(deadAddress, true);
1246         excludeFromFees(marketingWallet, true);
1247         excludeFromFees(developmentWallet, true);
1248 
1249         excludeFromMaxTransaction(owner(), true);
1250         excludeFromMaxTransaction(address(this), true);
1251         excludeFromMaxTransaction(deadAddress, true);
1252         excludeFromMaxTransaction(address(uniswapV2Router), true);
1253         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1254         excludeFromMaxTransaction(marketingWallet, true);
1255         excludeFromMaxTransaction(developmentWallet, true);
1256 
1257         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1258 
1259         _mint(msg.sender, totalSupply);
1260     }
1261 
1262     receive() external payable {}
1263 
1264     function enableTrading() external onlyOwner {
1265         tradingActive = true;
1266         swapEnabled = true;
1267     }
1268 
1269     function updateSwapTokensAtAmount(uint256 newAmount)
1270         external
1271         onlyOwner
1272         returns (bool)
1273     {
1274         require(
1275             newAmount >= (totalSupply() * 1) / 100000,
1276             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1277         );
1278         require(
1279             newAmount <= (totalSupply() * 5) / 1000,
1280             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1281         );
1282         swapTokensAtAmount = newAmount;
1283         return true;
1284     }
1285 
1286     function updateMaxWalletAndTxnAmount(
1287         uint256 newTxnNum,
1288         uint256 newMaxWalletNum
1289     ) external onlyOwner {
1290         require(
1291             newTxnNum >= ((totalSupply() * 5) / 1000),
1292             "ERC20: Cannot set maxTxn lower than 0.5%"
1293         );
1294         require(
1295             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1296             "ERC20: Cannot set maxWallet lower than 0.5%"
1297         );
1298         maxWallet = newMaxWalletNum;
1299         maxTransactionAmount = newTxnNum;
1300     }
1301 
1302     function excludeFromMaxTransaction(address updAds, bool isEx)
1303         public
1304         onlyOwner
1305     {
1306         _isExcludedMaxTransactionAmount[updAds] = isEx;
1307     }
1308 
1309     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1310         external
1311         onlyOwner
1312     {
1313         buyMarketingFee = _marketingFee;
1314         buyLiquidityFee = _liquidityFee;
1315         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1316         require(buyTotalFees <= 99, "ERC20: Must keep fees at 99% or less");
1317     }
1318 
1319     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1320         external
1321         onlyOwner
1322     {
1323         sellMarketingFee = _marketingFee;
1324         sellLiquidityFee = _liquidityFee;
1325         sellTotalFees = sellMarketingFee + sellDevelopmentFee + sellLiquidityFee;
1326         previousFee = sellTotalFees;
1327         require(sellTotalFees <= 99, "ERC20: Must keep fees at 99% or less");
1328     }
1329 
1330     function updateMarketingWallet(address _marketingWallet)
1331         external
1332         onlyOwner
1333     {
1334         require(_marketingWallet != address(0), "ERC20: Address 0");
1335         address oldWallet = marketingWallet;
1336         marketingWallet = _marketingWallet;
1337         emit marketingWalletUpdated(marketingWallet, oldWallet);
1338     }
1339 
1340     function excludeFromFees(address account, bool excluded) public onlyOwner {
1341         _isExcludedFromFees[account] = excluded;
1342         emit ExcludeFromFees(account, excluded);
1343     }
1344 
1345     function withdrawStuckETH() public onlyOwner {
1346         bool success;
1347         (success, ) = address(msg.sender).call{value: address(this).balance}(
1348             ""
1349         );
1350     }
1351 
1352     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1353         automatedMarketMakerPairs[pair] = value;
1354 
1355         emit SetAutomatedMarketMakerPair(pair, value);
1356     }
1357 
1358     function isExcludedFromFees(address account) public view returns (bool) {
1359         return _isExcludedFromFees[account];
1360     }
1361 
1362     function _transfer(
1363         address from,
1364         address to,
1365         uint256 amount
1366     ) internal override {
1367         require(from != address(0), "ERC20: transfer from the zero address");
1368         require(to != address(0), "ERC20: transfer to the zero address");
1369 
1370         if (amount == 0) {
1371             super._transfer(from, to, 0);
1372             return;
1373         }
1374 
1375         if (
1376             from != owner() &&
1377             to != owner() &&
1378             to != address(0) &&
1379             to != deadAddress &&
1380             !swapping
1381         ) {
1382             if (!tradingActive) {
1383                 require(
1384                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1385                     "ERC20: Trading is not active."
1386                 );
1387             }
1388 
1389             //when buy
1390             if (
1391                 automatedMarketMakerPairs[from] &&
1392                 !_isExcludedMaxTransactionAmount[to]
1393             ) {
1394                 require(
1395                     amount <= maxTransactionAmount,
1396                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1397                 );
1398                 require(
1399                     amount + balanceOf(to) <= maxWallet,
1400                     "ERC20: Max wallet exceeded"
1401                 );
1402             }
1403             //when sell
1404             else if (
1405                 automatedMarketMakerPairs[to] &&
1406                 !_isExcludedMaxTransactionAmount[from]
1407             ) {
1408                 require(
1409                     amount <= maxTransactionAmount,
1410                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1411                 );
1412             } else if (!_isExcludedMaxTransactionAmount[to]) {
1413                 require(
1414                     amount + balanceOf(to) <= maxWallet,
1415                     "ERC20: Max wallet exceeded"
1416                 );
1417             }
1418         }
1419 
1420         uint256 contractTokenBalance = balanceOf(address(this));
1421 
1422         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1423 
1424         if (
1425             canSwap &&
1426             swapEnabled &&
1427             !swapping &&
1428             !automatedMarketMakerPairs[from] &&
1429             !_isExcludedFromFees[from] &&
1430             !_isExcludedFromFees[to]
1431         ) {
1432             swapping = true;
1433 
1434             swapBack();
1435 
1436             swapping = false;
1437         }
1438 
1439         bool takeFee = !swapping;
1440 
1441         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1442             takeFee = false;
1443         }
1444 
1445         uint256 fees = 0;
1446 
1447         if (takeFee) {
1448             // on sell
1449             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1450                 fees = amount.mul(sellTotalFees + 1).div(100);
1451                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1452                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1453                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
1454             }
1455             // on buy
1456             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1457                 fees = amount.mul(buyTotalFees).div(100);
1458                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1459                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1460                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
1461             }
1462 
1463             if (fees > 0) {
1464                 super._transfer(from, address(this), fees);
1465             }
1466 
1467             amount -= fees;
1468         }
1469 
1470         super._transfer(from, to, amount);
1471         sellTotalFees = previousFee;
1472     }
1473 
1474     function swapTokensForEth(uint256 tokenAmount) private {
1475         address[] memory path = new address[](2);
1476         path[0] = address(this);
1477         path[1] = uniswapV2Router.WETH();
1478 
1479         _approve(address(this), address(uniswapV2Router), tokenAmount);
1480 
1481         // make the swap
1482         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1483             tokenAmount,
1484             0,
1485             path,
1486             address(this),
1487             block.timestamp
1488         );
1489     }
1490 
1491     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1492         _approve(address(this), address(uniswapV2Router), tokenAmount);
1493 
1494         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1495             address(this),
1496             tokenAmount,
1497             0,
1498             0,
1499             owner(),
1500             block.timestamp
1501         );
1502     }
1503 
1504     function swapBack() private {
1505         uint256 contractBalance = balanceOf(address(this));
1506         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
1507         bool success;
1508 
1509         if (contractBalance == 0 || totalTokensToSwap == 0) {
1510             return;
1511         }
1512 
1513         if (contractBalance > swapTokensAtAmount * 20) {
1514             contractBalance = swapTokensAtAmount * 20;
1515         }
1516 
1517         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1518             totalTokensToSwap /
1519             2;
1520         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1521 
1522         uint256 initialETHBalance = address(this).balance;
1523 
1524         swapTokensForEth(amountToSwapForETH);
1525 
1526         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1527 
1528         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1529             totalTokensToSwap
1530         );
1531         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(
1532             totalTokensToSwap
1533         );
1534 
1535         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDevelopment;
1536 
1537         tokensForLiquidity = 0;
1538         tokensForMarketing = 0;
1539         tokensForDevelopment = 0;
1540 
1541         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1542             addLiquidity(liquidityTokens, ethForLiquidity);
1543             emit SwapAndLiquify(
1544                 amountToSwapForETH,
1545                 ethForLiquidity,
1546                 tokensForLiquidity
1547             );
1548         }
1549 
1550         (success, ) = address(marketingWallet).call{
1551             value: ethForMarketing
1552         }("");
1553         (success, ) = address(developmentWallet).call{
1554             value: address(this).balance
1555         }("");
1556     }
1557 }