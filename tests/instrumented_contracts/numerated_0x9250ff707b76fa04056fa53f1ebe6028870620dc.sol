1 /*
2     https://sacrifice.heqethereum.com/
3     https://twitter.com/Heqethereum
4     https://t.me/HeqetPortal
5 */
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.19;
9 pragma experimental ABIEncoderV2;
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
12 
13 // pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
36 
37 // pragma solidity ^0.8.0;
38 
39 // import "../utils/Context.sol";
40 
41 /**
42  * @dev Contract module which provides a basic access control mechanism, where
43  * there is an account (an owner) that can be granted exclusive access to
44  * specific functions.
45  *
46  * By default, the owner account will be the one that deploys the contract. This
47  * can later be changed with {transferOwnership}.
48  *
49  * This module is used through inheritance. It will make available the modifier
50  * `onlyOwner`, which can be applied to your functions to restrict their use to
51  * the owner.
52  */
53 abstract contract Ownable is Context {
54     address private _owner;
55 
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         _checkOwner();
73         _;
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if the sender is not the owner.
85      */
86     function _checkOwner() internal view virtual {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby disabling any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(
107             newOwner != address(0),
108             "Ownable: new owner is the zero address"
109         );
110         _transferOwnership(newOwner);
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Internal function without access restriction.
116      */
117     function _transferOwnership(address newOwner) internal virtual {
118         address oldOwner = _owner;
119         _owner = newOwner;
120         emit OwnershipTransferred(oldOwner, newOwner);
121     }
122 }
123 
124 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
125 
126 // pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Interface of the ERC20 standard as defined in the EIP.
130  */
131 interface IERC20 {
132     /**
133      * @dev Emitted when `value` tokens are moved from one account (`from`) to
134      * another (`to`).
135      *
136      * Note that `value` may be zero.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     /**
141      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
142      * a call to {approve}. `value` is the new allowance.
143      */
144     event Approval(
145         address indexed owner,
146         address indexed spender,
147         uint256 value
148     );
149 
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `to`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address to, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
172      * zero by default.
173      *
174      * This value changes when {approve} or {transferFrom} are called.
175      */
176     function allowance(address owner, address spender)
177         external
178         view
179         returns (uint256);
180 
181     /**
182      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * IMPORTANT: Beware that changing an allowance with this method brings the risk
187      * that someone may use both the old and the new allowance by unfortunate
188      * transaction ordering. One possible solution to mitigate this race
189      * condition is to first reduce the spender's allowance to 0 and set the
190      * desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      *
193      * Emits an {Approval} event.
194      */
195     function approve(address spender, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Moves `amount` tokens from `from` to `to` using the
199      * allowance mechanism. `amount` is then deducted from the caller's
200      * allowance.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transferFrom(
207         address from,
208         address to,
209         uint256 amount
210     ) external returns (bool);
211 }
212 
213 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
214 
215 // pragma solidity ^0.8.0;
216 
217 // import "../IERC20.sol";
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
242 
243 // pragma solidity ^0.8.0;
244 
245 // import "./IERC20.sol";
246 // import "./extensions/IERC20Metadata.sol";
247 // import "../../utils/Context.sol";
248 
249 /**
250  * @dev Implementation of the {IERC20} interface.
251  *
252  * This implementation is agnostic to the way tokens are created. This means
253  * that a supply mechanism has to be added in a derived contract using {_mint}.
254  * For a generic mechanism see {ERC20PresetMinterPauser}.
255  *
256  * TIP: For a detailed writeup see our guide
257  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
258  * to implement supply mechanisms].
259  *
260  * The default value of {decimals} is 18. To change this, you should override
261  * this function so it returns a different value.
262  *
263  * We have followed general OpenZeppelin Contracts guidelines: functions revert
264  * instead returning `false` on failure. This behavior is nonetheless
265  * conventional and does not conflict with the expectations of ERC20
266  * applications.
267  *
268  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
269  * This allows applications to reconstruct the allowance for all accounts just
270  * by listening to said events. Other implementations of the EIP may not emit
271  * these events, as it isn't required by the specification.
272  *
273  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
274  * functions have been added to mitigate the well-known issues around setting
275  * allowances. See {IERC20-approve}.
276  */
277 contract ERC20 is Context, IERC20, IERC20Metadata {
278     mapping(address => uint256) private _balances;
279 
280     mapping(address => mapping(address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     string private _name;
285     string private _symbol;
286 
287     /**
288      * @dev Sets the values for {name} and {symbol}.
289      *
290      * All two of these values are immutable: they can only be set once during
291      * construction.
292      */
293     constructor(string memory name_, string memory symbol_) {
294         _name = name_;
295         _symbol = symbol_;
296     }
297 
298     /**
299      * @dev Returns the name of the token.
300      */
301     function name() public view virtual override returns (string memory) {
302         return _name;
303     }
304 
305     /**
306      * @dev Returns the symbol of the token, usually a shorter version of the
307      * name.
308      */
309     function symbol() public view virtual override returns (string memory) {
310         return _symbol;
311     }
312 
313     /**
314      * @dev Returns the number of decimals used to get its user representation.
315      * For example, if `decimals` equals `2`, a balance of `505` tokens should
316      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
317      *
318      * Tokens usually opt for a value of 18, imitating the relationship between
319      * Ether and Wei. This is the default value returned by this function, unless
320      * it's overridden.
321      *
322      * NOTE: This information is only used for _display_ purposes: it in
323      * no way affects any of the arithmetic of the contract, including
324      * {IERC20-balanceOf} and {IERC20-transfer}.
325      */
326     function decimals() public view virtual override returns (uint8) {
327         return 18;
328     }
329 
330     /**
331      * @dev See {IERC20-totalSupply}.
332      */
333     function totalSupply() public view virtual override returns (uint256) {
334         return _totalSupply;
335     }
336 
337     /**
338      * @dev See {IERC20-balanceOf}.
339      */
340     function balanceOf(address account)
341         public
342         view
343         virtual
344         override
345         returns (uint256)
346     {
347         return _balances[account];
348     }
349 
350     /**
351      * @dev See {IERC20-transfer}.
352      *
353      * Requirements:
354      *
355      * - `to` cannot be the zero address.
356      * - the caller must have a balance of at least `amount`.
357      */
358     function transfer(address to, uint256 amount)
359         public
360         virtual
361         override
362         returns (bool)
363     {
364         address owner = _msgSender();
365         _transfer(owner, to, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-allowance}.
371      */
372     function allowance(address owner, address spender)
373         public
374         view
375         virtual
376         override
377         returns (uint256)
378     {
379         return _allowances[owner][spender];
380     }
381 
382     /**
383      * @dev See {IERC20-approve}.
384      *
385      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
386      * `transferFrom`. This is semantically equivalent to an infinite approval.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function approve(address spender, uint256 amount)
393         public
394         virtual
395         override
396         returns (bool)
397     {
398         address owner = _msgSender();
399         _approve(owner, spender, amount);
400         return true;
401     }
402 
403     /**
404      * @dev See {IERC20-transferFrom}.
405      *
406      * Emits an {Approval} event indicating the updated allowance. This is not
407      * required by the EIP. See the note at the beginning of {ERC20}.
408      *
409      * NOTE: Does not update the allowance if the current allowance
410      * is the maximum `uint256`.
411      *
412      * Requirements:
413      *
414      * - `from` and `to` cannot be the zero address.
415      * - `from` must have a balance of at least `amount`.
416      * - the caller must have allowance for ``from``'s tokens of at least
417      * `amount`.
418      */
419     function transferFrom(
420         address from,
421         address to,
422         uint256 amount
423     ) public virtual override returns (bool) {
424         address spender = _msgSender();
425         _spendAllowance(from, spender, amount);
426         _transfer(from, to, amount);
427         return true;
428     }
429 
430     /**
431      * @dev Atomically increases the allowance granted to `spender` by the caller.
432      *
433      * This is an alternative to {approve} that can be used as a mitigation for
434      * problems described in {IERC20-approve}.
435      *
436      * Emits an {Approval} event indicating the updated allowance.
437      *
438      * Requirements:
439      *
440      * - `spender` cannot be the zero address.
441      */
442     function increaseAllowance(address spender, uint256 addedValue)
443         public
444         virtual
445         returns (bool)
446     {
447         address owner = _msgSender();
448         _approve(owner, spender, allowance(owner, spender) + addedValue);
449         return true;
450     }
451 
452     /**
453      * @dev Atomically decreases the allowance granted to `spender` by the caller.
454      *
455      * This is an alternative to {approve} that can be used as a mitigation for
456      * problems described in {IERC20-approve}.
457      *
458      * Emits an {Approval} event indicating the updated allowance.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      * - `spender` must have allowance for the caller of at least
464      * `subtractedValue`.
465      */
466     function decreaseAllowance(address spender, uint256 subtractedValue)
467         public
468         virtual
469         returns (bool)
470     {
471         address owner = _msgSender();
472         uint256 currentAllowance = allowance(owner, spender);
473         require(
474             currentAllowance >= subtractedValue,
475             "ERC20: decreased allowance below zero"
476         );
477         unchecked {
478             _approve(owner, spender, currentAllowance - subtractedValue);
479         }
480 
481         return true;
482     }
483 
484     /**
485      * @dev Moves `amount` of tokens from `from` to `to`.
486      *
487      * This internal function is equivalent to {transfer}, and can be used to
488      * e.g. implement automatic token fees, slashing mechanisms, etc.
489      *
490      * Emits a {Transfer} event.
491      *
492      * Requirements:
493      *
494      * - `from` cannot be the zero address.
495      * - `to` cannot be the zero address.
496      * - `from` must have a balance of at least `amount`.
497      */
498     function _transfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {
503         require(from != address(0), "ERC20: transfer from the zero address");
504         require(to != address(0), "ERC20: transfer to the zero address");
505 
506         _beforeTokenTransfer(from, to, amount);
507 
508         uint256 fromBalance = _balances[from];
509         require(
510             fromBalance >= amount,
511             "ERC20: transfer amount exceeds balance"
512         );
513         unchecked {
514             _balances[from] = fromBalance - amount;
515             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
516             // decrementing then incrementing.
517             _balances[to] += amount;
518         }
519 
520         emit Transfer(from, to, amount);
521 
522         _afterTokenTransfer(from, to, amount);
523     }
524 
525     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
526      * the total supply.
527      *
528      * Emits a {Transfer} event with `from` set to the zero address.
529      *
530      * Requirements:
531      *
532      * - `account` cannot be the zero address.
533      */
534     function _mint(address account, uint256 amount) internal virtual {
535         require(account != address(0), "ERC20: mint to the zero address");
536 
537         _beforeTokenTransfer(address(0), account, amount);
538 
539         _totalSupply += amount;
540         unchecked {
541             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
542             _balances[account] += amount;
543         }
544         emit Transfer(address(0), account, amount);
545 
546         _afterTokenTransfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         uint256 accountBalance = _balances[account];
566         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
567         unchecked {
568             _balances[account] = accountBalance - amount;
569             // Overflow not possible: amount <= accountBalance <= totalSupply.
570             _totalSupply -= amount;
571         }
572 
573         emit Transfer(account, address(0), amount);
574 
575         _afterTokenTransfer(account, address(0), amount);
576     }
577 
578     /**
579      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
580      *
581      * This internal function is equivalent to `approve`, and can be used to
582      * e.g. set automatic allowances for certain subsystems, etc.
583      *
584      * Emits an {Approval} event.
585      *
586      * Requirements:
587      *
588      * - `owner` cannot be the zero address.
589      * - `spender` cannot be the zero address.
590      */
591     function _approve(
592         address owner,
593         address spender,
594         uint256 amount
595     ) internal virtual {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
605      *
606      * Does not update the allowance amount in case of infinite allowance.
607      * Revert if not enough allowance is available.
608      *
609      * Might emit an {Approval} event.
610      */
611     function _spendAllowance(
612         address owner,
613         address spender,
614         uint256 amount
615     ) internal virtual {
616         uint256 currentAllowance = allowance(owner, spender);
617         if (currentAllowance != type(uint256).max) {
618             require(
619                 currentAllowance >= amount,
620                 "ERC20: insufficient allowance"
621             );
622             unchecked {
623                 _approve(owner, spender, currentAllowance - amount);
624             }
625         }
626     }
627 
628     /**
629      * @dev Hook that is called before any transfer of tokens. This includes
630      * minting and burning.
631      *
632      * Calling conditions:
633      *
634      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
635      * will be transferred to `to`.
636      * - when `from` is zero, `amount` tokens will be minted for `to`.
637      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
638      * - `from` and `to` are never both zero.
639      *
640      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
641      */
642     function _beforeTokenTransfer(
643         address from,
644         address to,
645         uint256 amount
646     ) internal virtual {}
647 
648     /**
649      * @dev Hook that is called after any transfer of tokens. This includes
650      * minting and burning.
651      *
652      * Calling conditions:
653      *
654      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
655      * has been transferred to `to`.
656      * - when `from` is zero, `amount` tokens have been minted for `to`.
657      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
658      * - `from` and `to` are never both zero.
659      *
660      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
661      */
662     function _afterTokenTransfer(
663         address from,
664         address to,
665         uint256 amount
666     ) internal virtual {}
667 }
668 
669 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
670 
671 // pragma solidity ^0.8.0;
672 
673 // CAUTION
674 // This version of SafeMath should only be used with Solidity 0.8 or later,
675 // because it relies on the compiler's built in overflow checks.
676 
677 /**
678  * @dev Wrappers over Solidity's arithmetic operations.
679  *
680  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
681  * now has built in overflow checking.
682  */
683 library SafeMath {
684     /**
685      * @dev Returns the addition of two unsigned integers, with an overflow flag.
686      *
687      * _Available since v3.4._
688      */
689     function tryAdd(uint256 a, uint256 b)
690         internal
691         pure
692         returns (bool, uint256)
693     {
694         unchecked {
695             uint256 c = a + b;
696             if (c < a) return (false, 0);
697             return (true, c);
698         }
699     }
700 
701     /**
702      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
703      *
704      * _Available since v3.4._
705      */
706     function trySub(uint256 a, uint256 b)
707         internal
708         pure
709         returns (bool, uint256)
710     {
711         unchecked {
712             if (b > a) return (false, 0);
713             return (true, a - b);
714         }
715     }
716 
717     /**
718      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
719      *
720      * _Available since v3.4._
721      */
722     function tryMul(uint256 a, uint256 b)
723         internal
724         pure
725         returns (bool, uint256)
726     {
727         unchecked {
728             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
729             // benefit is lost if 'b' is also tested.
730             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
731             if (a == 0) return (true, 0);
732             uint256 c = a * b;
733             if (c / a != b) return (false, 0);
734             return (true, c);
735         }
736     }
737 
738     /**
739      * @dev Returns the division of two unsigned integers, with a division by zero flag.
740      *
741      * _Available since v3.4._
742      */
743     function tryDiv(uint256 a, uint256 b)
744         internal
745         pure
746         returns (bool, uint256)
747     {
748         unchecked {
749             if (b == 0) return (false, 0);
750             return (true, a / b);
751         }
752     }
753 
754     /**
755      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
756      *
757      * _Available since v3.4._
758      */
759     function tryMod(uint256 a, uint256 b)
760         internal
761         pure
762         returns (bool, uint256)
763     {
764         unchecked {
765             if (b == 0) return (false, 0);
766             return (true, a % b);
767         }
768     }
769 
770     /**
771      * @dev Returns the addition of two unsigned integers, reverting on
772      * overflow.
773      *
774      * Counterpart to Solidity's `+` operator.
775      *
776      * Requirements:
777      *
778      * - Addition cannot overflow.
779      */
780     function add(uint256 a, uint256 b) internal pure returns (uint256) {
781         return a + b;
782     }
783 
784     /**
785      * @dev Returns the subtraction of two unsigned integers, reverting on
786      * overflow (when the result is negative).
787      *
788      * Counterpart to Solidity's `-` operator.
789      *
790      * Requirements:
791      *
792      * - Subtraction cannot overflow.
793      */
794     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
795         return a - b;
796     }
797 
798     /**
799      * @dev Returns the multiplication of two unsigned integers, reverting on
800      * overflow.
801      *
802      * Counterpart to Solidity's `*` operator.
803      *
804      * Requirements:
805      *
806      * - Multiplication cannot overflow.
807      */
808     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
809         return a * b;
810     }
811 
812     /**
813      * @dev Returns the integer division of two unsigned integers, reverting on
814      * division by zero. The result is rounded towards zero.
815      *
816      * Counterpart to Solidity's `/` operator.
817      *
818      * Requirements:
819      *
820      * - The divisor cannot be zero.
821      */
822     function div(uint256 a, uint256 b) internal pure returns (uint256) {
823         return a / b;
824     }
825 
826     /**
827      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
828      * reverting when dividing by zero.
829      *
830      * Counterpart to Solidity's `%` operator. This function uses a `revert`
831      * opcode (which leaves remaining gas untouched) while Solidity uses an
832      * invalid opcode to revert (consuming all remaining gas).
833      *
834      * Requirements:
835      *
836      * - The divisor cannot be zero.
837      */
838     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
839         return a % b;
840     }
841 
842     /**
843      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
844      * overflow (when the result is negative).
845      *
846      * CAUTION: This function is deprecated because it requires allocating memory for the error
847      * message unnecessarily. For custom revert reasons use {trySub}.
848      *
849      * Counterpart to Solidity's `-` operator.
850      *
851      * Requirements:
852      *
853      * - Subtraction cannot overflow.
854      */
855     function sub(
856         uint256 a,
857         uint256 b,
858         string memory errorMessage
859     ) internal pure returns (uint256) {
860         unchecked {
861             require(b <= a, errorMessage);
862             return a - b;
863         }
864     }
865 
866     /**
867      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
868      * division by zero. The result is rounded towards zero.
869      *
870      * Counterpart to Solidity's `/` operator. Note: this function uses a
871      * `revert` opcode (which leaves remaining gas untouched) while Solidity
872      * uses an invalid opcode to revert (consuming all remaining gas).
873      *
874      * Requirements:
875      *
876      * - The divisor cannot be zero.
877      */
878     function div(
879         uint256 a,
880         uint256 b,
881         string memory errorMessage
882     ) internal pure returns (uint256) {
883         unchecked {
884             require(b > 0, errorMessage);
885             return a / b;
886         }
887     }
888 
889     /**
890      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
891      * reverting with custom message when dividing by zero.
892      *
893      * CAUTION: This function is deprecated because it requires allocating memory for the error
894      * message unnecessarily. For custom revert reasons use {tryMod}.
895      *
896      * Counterpart to Solidity's `%` operator. This function uses a `revert`
897      * opcode (which leaves remaining gas untouched) while Solidity uses an
898      * invalid opcode to revert (consuming all remaining gas).
899      *
900      * Requirements:
901      *
902      * - The divisor cannot be zero.
903      */
904     function mod(
905         uint256 a,
906         uint256 b,
907         string memory errorMessage
908     ) internal pure returns (uint256) {
909         unchecked {
910             require(b > 0, errorMessage);
911             return a % b;
912         }
913     }
914 }
915 
916 // pragma solidity >=0.5.0;
917 
918 interface IUniswapV2Factory {
919     event PairCreated(
920         address indexed token0,
921         address indexed token1,
922         address pair,
923         uint256
924     );
925 
926     function feeTo() external view returns (address);
927 
928     function feeToSetter() external view returns (address);
929 
930     function getPair(address tokenA, address tokenB)
931         external
932         view
933         returns (address pair);
934 
935     function allPairs(uint256) external view returns (address pair);
936 
937     function allPairsLength() external view returns (uint256);
938 
939     function createPair(address tokenA, address tokenB)
940         external
941         returns (address pair);
942 
943     function setFeeTo(address) external;
944 
945     function setFeeToSetter(address) external;
946 }
947 
948 // pragma solidity >=0.5.0;
949 
950 interface IUniswapV2Pair {
951     event Approval(
952         address indexed owner,
953         address indexed spender,
954         uint256 value
955     );
956     event Transfer(address indexed from, address indexed to, uint256 value);
957 
958     function name() external pure returns (string memory);
959 
960     function symbol() external pure returns (string memory);
961 
962     function decimals() external pure returns (uint8);
963 
964     function totalSupply() external view returns (uint256);
965 
966     function balanceOf(address owner) external view returns (uint256);
967 
968     function allowance(address owner, address spender)
969         external
970         view
971         returns (uint256);
972 
973     function approve(address spender, uint256 value) external returns (bool);
974 
975     function transfer(address to, uint256 value) external returns (bool);
976 
977     function transferFrom(
978         address from,
979         address to,
980         uint256 value
981     ) external returns (bool);
982 
983     function DOMAIN_SEPARATOR() external view returns (bytes32);
984 
985     function PERMIT_TYPEHASH() external pure returns (bytes32);
986 
987     function nonces(address owner) external view returns (uint256);
988 
989     function permit(
990         address owner,
991         address spender,
992         uint256 value,
993         uint256 deadline,
994         uint8 v,
995         bytes32 r,
996         bytes32 s
997     ) external;
998 
999     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1000     event Burn(
1001         address indexed sender,
1002         uint256 amount0,
1003         uint256 amount1,
1004         address indexed to
1005     );
1006     event Swap(
1007         address indexed sender,
1008         uint256 amount0In,
1009         uint256 amount1In,
1010         uint256 amount0Out,
1011         uint256 amount1Out,
1012         address indexed to
1013     );
1014     event Sync(uint112 reserve0, uint112 reserve1);
1015 
1016     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1017 
1018     function factory() external view returns (address);
1019 
1020     function token0() external view returns (address);
1021 
1022     function token1() external view returns (address);
1023 
1024     function getReserves()
1025         external
1026         view
1027         returns (
1028             uint112 reserve0,
1029             uint112 reserve1,
1030             uint32 blockTimestampLast
1031         );
1032 
1033     function price0CumulativeLast() external view returns (uint256);
1034 
1035     function price1CumulativeLast() external view returns (uint256);
1036 
1037     function kLast() external view returns (uint256);
1038 
1039     function mint(address to) external returns (uint256 liquidity);
1040 
1041     function burn(address to)
1042         external
1043         returns (uint256 amount0, uint256 amount1);
1044 
1045     function swap(
1046         uint256 amount0Out,
1047         uint256 amount1Out,
1048         address to,
1049         bytes calldata data
1050     ) external;
1051 
1052     function skim(address to) external;
1053 
1054     function sync() external;
1055 
1056     function initialize(address, address) external;
1057 }
1058 
1059 // pragma solidity >=0.6.2;
1060 
1061 interface IUniswapV2Router01 {
1062     function factory() external pure returns (address);
1063 
1064     function WETH() external pure returns (address);
1065 
1066     function addLiquidity(
1067         address tokenA,
1068         address tokenB,
1069         uint256 amountADesired,
1070         uint256 amountBDesired,
1071         uint256 amountAMin,
1072         uint256 amountBMin,
1073         address to,
1074         uint256 deadline
1075     )
1076         external
1077         returns (
1078             uint256 amountA,
1079             uint256 amountB,
1080             uint256 liquidity
1081         );
1082 
1083     function addLiquidityETH(
1084         address token,
1085         uint256 amountTokenDesired,
1086         uint256 amountTokenMin,
1087         uint256 amountETHMin,
1088         address to,
1089         uint256 deadline
1090     )
1091         external
1092         payable
1093         returns (
1094             uint256 amountToken,
1095             uint256 amountETH,
1096             uint256 liquidity
1097         );
1098 
1099     function removeLiquidity(
1100         address tokenA,
1101         address tokenB,
1102         uint256 liquidity,
1103         uint256 amountAMin,
1104         uint256 amountBMin,
1105         address to,
1106         uint256 deadline
1107     ) external returns (uint256 amountA, uint256 amountB);
1108 
1109     function removeLiquidityETH(
1110         address token,
1111         uint256 liquidity,
1112         uint256 amountTokenMin,
1113         uint256 amountETHMin,
1114         address to,
1115         uint256 deadline
1116     ) external returns (uint256 amountToken, uint256 amountETH);
1117 
1118     function removeLiquidityWithPermit(
1119         address tokenA,
1120         address tokenB,
1121         uint256 liquidity,
1122         uint256 amountAMin,
1123         uint256 amountBMin,
1124         address to,
1125         uint256 deadline,
1126         bool approveMax,
1127         uint8 v,
1128         bytes32 r,
1129         bytes32 s
1130     ) external returns (uint256 amountA, uint256 amountB);
1131 
1132     function removeLiquidityETHWithPermit(
1133         address token,
1134         uint256 liquidity,
1135         uint256 amountTokenMin,
1136         uint256 amountETHMin,
1137         address to,
1138         uint256 deadline,
1139         bool approveMax,
1140         uint8 v,
1141         bytes32 r,
1142         bytes32 s
1143     ) external returns (uint256 amountToken, uint256 amountETH);
1144 
1145     function swapExactTokensForTokens(
1146         uint256 amountIn,
1147         uint256 amountOutMin,
1148         address[] calldata path,
1149         address to,
1150         uint256 deadline
1151     ) external returns (uint256[] memory amounts);
1152 
1153     function swapTokensForExactTokens(
1154         uint256 amountOut,
1155         uint256 amountInMax,
1156         address[] calldata path,
1157         address to,
1158         uint256 deadline
1159     ) external returns (uint256[] memory amounts);
1160 
1161     function swapExactETHForTokens(
1162         uint256 amountOutMin,
1163         address[] calldata path,
1164         address to,
1165         uint256 deadline
1166     ) external payable returns (uint256[] memory amounts);
1167 
1168     function swapTokensForExactETH(
1169         uint256 amountOut,
1170         uint256 amountInMax,
1171         address[] calldata path,
1172         address to,
1173         uint256 deadline
1174     ) external returns (uint256[] memory amounts);
1175 
1176     function swapExactTokensForETH(
1177         uint256 amountIn,
1178         uint256 amountOutMin,
1179         address[] calldata path,
1180         address to,
1181         uint256 deadline
1182     ) external returns (uint256[] memory amounts);
1183 
1184     function swapETHForExactTokens(
1185         uint256 amountOut,
1186         address[] calldata path,
1187         address to,
1188         uint256 deadline
1189     ) external payable returns (uint256[] memory amounts);
1190 
1191     function quote(
1192         uint256 amountA,
1193         uint256 reserveA,
1194         uint256 reserveB
1195     ) external pure returns (uint256 amountB);
1196 
1197     function getAmountOut(
1198         uint256 amountIn,
1199         uint256 reserveIn,
1200         uint256 reserveOut
1201     ) external pure returns (uint256 amountOut);
1202 
1203     function getAmountIn(
1204         uint256 amountOut,
1205         uint256 reserveIn,
1206         uint256 reserveOut
1207     ) external pure returns (uint256 amountIn);
1208 
1209     function getAmountsOut(uint256 amountIn, address[] calldata path)
1210         external
1211         view
1212         returns (uint256[] memory amounts);
1213 
1214     function getAmountsIn(uint256 amountOut, address[] calldata path)
1215         external
1216         view
1217         returns (uint256[] memory amounts);
1218 }
1219 
1220 // pragma solidity >=0.6.2;
1221 
1222 // import './IUniswapV2Router01.sol';
1223 
1224 interface IUniswapV2Router02 is IUniswapV2Router01 {
1225     function removeLiquidityETHSupportingFeeOnTransferTokens(
1226         address token,
1227         uint256 liquidity,
1228         uint256 amountTokenMin,
1229         uint256 amountETHMin,
1230         address to,
1231         uint256 deadline
1232     ) external returns (uint256 amountETH);
1233 
1234     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1235         address token,
1236         uint256 liquidity,
1237         uint256 amountTokenMin,
1238         uint256 amountETHMin,
1239         address to,
1240         uint256 deadline,
1241         bool approveMax,
1242         uint8 v,
1243         bytes32 r,
1244         bytes32 s
1245     ) external returns (uint256 amountETH);
1246 
1247     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1248         uint256 amountIn,
1249         uint256 amountOutMin,
1250         address[] calldata path,
1251         address to,
1252         uint256 deadline
1253     ) external;
1254 
1255     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1256         uint256 amountOutMin,
1257         address[] calldata path,
1258         address to,
1259         uint256 deadline
1260     ) external payable;
1261 
1262     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1263         uint256 amountIn,
1264         uint256 amountOutMin,
1265         address[] calldata path,
1266         address to,
1267         uint256 deadline
1268     ) external;
1269 }
1270 
1271 contract HEQET is ERC20, Ownable {
1272     using SafeMath for uint256;
1273 
1274     string internal constant TOKEN_NAME = "Heqet Coin";
1275     string internal constant TOKEN_SYMBOL = "HEQET";
1276 
1277     IUniswapV2Router02 public immutable uniswapV2Router;
1278     address public immutable uniswapV2Pair;
1279     address public constant deadAddress = address(0xdead);
1280 
1281     bool private swapping;
1282 
1283     address public marketingWallet;
1284 
1285     uint256 public maxTransactionAmount;
1286     uint256 public swapTokensAtAmount;
1287     uint256 public maxWallet;
1288 
1289     uint256 public launchedAt;
1290 
1291     bool public limitsInEffect = true;
1292     bool public tradingActive = false;
1293     bool public swapEnabled = true;
1294 
1295     // Anti-bot and anti-whale mappings and variables
1296     mapping(address => bool) public isBot;
1297     uint256 public snipingTime = 25 seconds; //25 seconds snipping time
1298     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1299     bool public transferDelayEnabled = true;
1300 
1301     uint256 public buyTotalFees;
1302     uint256 public buyMarketingFee;
1303     uint256 public buyLiquidityFee;
1304 
1305     uint256 public sellTotalFees;
1306     uint256 public sellMarketingFee;
1307     uint256 public sellLiquidityFee;
1308 
1309     uint256 public tokensForMarketing;
1310     uint256 public tokensForLiquidity;
1311 
1312     /***************************************************************/
1313     bool public sacrificeActive = true;
1314     bool public sacrificedTradingActive = false;
1315     uint256 public sacrificeFee = 0.1 ether;
1316     mapping(address => bool) public sacrificied;
1317 
1318     /***************************************************************/
1319 
1320     // exlcude from fees and max transaction amount
1321     mapping(address => bool) private _isExcludedFromFees;
1322     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1323 
1324     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1325     // could be subject to a maximum transfer amount
1326     mapping(address => bool) private automatedMarketMakerPairs;
1327 
1328     /***************************************************************/
1329 
1330     event UpdateUniswapV2Router(
1331         address indexed newAddress,
1332         address indexed oldAddress
1333     );
1334 
1335     event ExcludeFromFees(address indexed account, bool isExcluded);
1336 
1337     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1338 
1339     event SwapAndLiquify(
1340         uint256 tokensSwapped,
1341         uint256 ethReceived,
1342         uint256 tokensIntoLiquidity
1343     );
1344 
1345     /***************************************************************/
1346 
1347     constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) {
1348         uniswapV2Router = IUniswapV2Router02(
1349             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1350         );
1351         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1352             address(this),
1353             uniswapV2Router.WETH()
1354         );
1355 
1356         uint256 totalSupply = 333_333_333 ether;
1357 
1358         maxTransactionAmount = (totalSupply * 333) / 100000; // 0.333% from total supply maxTransactionAmountTxn
1359         maxWallet = (totalSupply * 333) / 100000; // 0.333% from total supply maxWallet
1360         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap back amount
1361 
1362         buyMarketingFee = 333;
1363         buyLiquidityFee = 0;
1364         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1365 
1366         sellMarketingFee = 333;
1367         sellLiquidityFee = 0;
1368         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1369 
1370         marketingWallet = owner(); // marketing wallet address
1371 
1372         // exclude from paying fees or having max transaction amount
1373         excludeFromFees(owner(), true);
1374         excludeFromFees(address(this), true);
1375         excludeFromFees(deadAddress, true);
1376         excludeFromFees(address(uniswapV2Router), true);
1377 
1378         excludeFromMaxTransaction(owner(), true);
1379         excludeFromMaxTransaction(address(this), true);
1380         excludeFromMaxTransaction(deadAddress, true);
1381         excludeFromMaxTransaction(address(uniswapV2Router), true);
1382         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1383 
1384         _sacrifice(owner(), true);
1385         _sacrifice(address(this), true);
1386         _sacrifice(deadAddress, true);
1387         _sacrifice(address(uniswapV2Router), true);
1388 
1389         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1390 
1391         /*
1392             _mint is an internal function in ERC20.sol that is only called here,
1393             and CANNOT be called ever again
1394         */
1395         _mint(msg.sender, totalSupply);
1396     }
1397 
1398     receive() external payable {}
1399 
1400     // once enabled, can never be turned off
1401     function enableTrading(uint256 x) external onlyOwner {
1402         require(!tradingActive, "HEQET: already enabled");
1403         tradingActive = true;
1404         swapEnabled = true;
1405         launchedAt = block.timestamp;
1406         snipingTime = ((1 seconds * x));
1407     }
1408 
1409     // enable sacrificed trading
1410     function enableSacrificedTrading() external onlyOwner {
1411         sacrificedTradingActive = true;
1412     }
1413 
1414     // disable sacrificed trading
1415     function disableSacrificedTrading() external onlyOwner {
1416         sacrificedTradingActive = false;
1417     }
1418 
1419     // enable sacrifice
1420     function enableSacrifice() external onlyOwner {
1421         sacrificeActive = true;
1422     }
1423 
1424     // disable sacrifice
1425     function disableSacrifice() external onlyOwner {
1426         sacrificeActive = false;
1427     }
1428 
1429     // remove limits after token is stable
1430     function removeLimits() external onlyOwner returns (bool) {
1431         limitsInEffect = false;
1432         return true;
1433     }
1434 
1435     // disable Transfer delay - cannot be reenabled
1436     function disableTransferDelay() external onlyOwner returns (bool) {
1437         transferDelayEnabled = false;
1438         return true;
1439     }
1440 
1441     // change the minimum amount of tokens to sell from fees
1442     function updateSwapTokensAtAmount(uint256 newAmount)
1443         external
1444         onlyOwner
1445         returns (bool)
1446     {
1447         require(
1448             newAmount >= ((totalSupply() * 1) / 100000) / 1e18,
1449             "HEQET: Swap amount cannot be lower than 0.001% total supply."
1450         );
1451         require(
1452             newAmount <= ((totalSupply() * 5) / 1000) / 1e18,
1453             "HEQET: Swap amount cannot be higher than 0.5% total supply."
1454         );
1455         swapTokensAtAmount = newAmount;
1456         return true;
1457     }
1458 
1459     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1460         require(
1461             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1462             "HEQET: Cannot set maxTransactionAmount lower than 0.1%"
1463         );
1464         maxTransactionAmount = newNum;
1465         maxWallet = newNum;
1466     }
1467 
1468     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1469         require(
1470             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1471             "HEQET: Cannot set maxWallet lower than 0.1%"
1472         );
1473         maxWallet = newNum;
1474     }
1475 
1476     function excludeFromMaxTransaction(address updAds, bool isEx)
1477         public
1478         onlyOwner
1479     {
1480         _isExcludedMaxTransactionAmount[updAds] = isEx;
1481     }
1482 
1483     function sacrifice() public payable {
1484         require(sacrificeActive, "HEQET: sacrifice not enabled yet");
1485         _chargeSacrificeFee();
1486         _sacrifice(msg.sender, true);
1487     }
1488 
1489     function _sacrifice(address updAds, bool isEx) internal {
1490         sacrificied[updAds] = isEx;
1491     }
1492 
1493     function _chargeSacrificeFee() internal {
1494         if (sacrificeFee > 0) {
1495             require(msg.value >= sacrificeFee, "HEQET: fee not met");
1496         }
1497     }
1498 
1499     function updateSacrificeFee(uint256 _sacrificeFee) public onlyOwner {
1500         require(_sacrificeFee >= 0, "HEQET: fee should be greater or equal 0");
1501         sacrificeFee = _sacrificeFee;
1502     }
1503 
1504     // only use to disable contract sales if absolutely necessary (emergency use only)
1505     function updateSwapEnabled(bool enabled) external onlyOwner {
1506         swapEnabled = enabled;
1507     }
1508 
1509     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1510         external
1511         onlyOwner
1512     {
1513         require(
1514             (_marketingFee + _liquidityFee) <= 333,
1515             "HEQET: Max Buy Fee 33.3%"
1516         );
1517         buyMarketingFee = _marketingFee;
1518         buyLiquidityFee = _liquidityFee;
1519         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1520     }
1521 
1522     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1523         external
1524         onlyOwner
1525     {
1526         require(
1527             (_marketingFee + _liquidityFee) <= 333,
1528             "HEQET: Max Sell Fee 33.3%"
1529         );
1530         sellMarketingFee = _marketingFee;
1531         sellLiquidityFee = _liquidityFee;
1532         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1533     }
1534 
1535     function excludeFromFees(address account, bool excluded) public onlyOwner {
1536         _isExcludedFromFees[account] = excluded;
1537         emit ExcludeFromFees(account, excluded);
1538     }
1539 
1540     function setAutomatedMarketMakerPair(address pair, bool value)
1541         public
1542         onlyOwner
1543     {
1544         require(
1545             pair != uniswapV2Pair,
1546             "HEQET: The pair cannot be removed from automatedMarketMakerPairs"
1547         );
1548 
1549         _setAutomatedMarketMakerPair(pair, value);
1550     }
1551 
1552     function _setAutomatedMarketMakerPair(address pair, bool value) internal {
1553         automatedMarketMakerPairs[pair] = value;
1554 
1555         emit SetAutomatedMarketMakerPair(pair, value);
1556     }
1557 
1558     function addOrRemoveBots(address[] calldata accounts, bool value)
1559         external
1560         onlyOwner
1561     {
1562         for (uint256 i = 0; i < accounts.length; i++) {
1563             isBot[accounts[i]] = value;
1564         }
1565     }
1566 
1567     function updateMarketingWallet(address _marketingWallet)
1568         external
1569         onlyOwner
1570     {
1571         require(_marketingWallet != address(0), "HEQET: Address 0");
1572         marketingWallet = _marketingWallet;
1573     }
1574 
1575     function withdrawStuckETH() public onlyOwner {
1576         bool success;
1577         (success, ) = address(msg.sender).call{value: address(this).balance}(
1578             ""
1579         );
1580     }
1581 
1582     function isExcludedFromFees(address account) public view returns (bool) {
1583         return _isExcludedFromFees[account];
1584     }
1585 
1586     function _transfer(
1587         address from,
1588         address to,
1589         uint256 amount
1590     ) internal override {
1591         require(from != address(0), "HEQET: transfer from the zero address");
1592         require(to != address(0), "HEQET: transfer to the zero address");
1593 
1594         require(!isBot[from], "HEQET: bot detected");
1595         require(!isBot[msg.sender], "HEQET: bot detected");
1596         require(!isBot[tx.origin], "HEQET: bot detected");
1597 
1598         if (amount == 0) {
1599             super._transfer(from, to, 0);
1600             return;
1601         }
1602 
1603         if (limitsInEffect) {
1604             if (
1605                 from != owner() &&
1606                 to != owner() &&
1607                 to != address(0) &&
1608                 to != deadAddress &&
1609                 !swapping
1610             ) {
1611                 if (!sacrificied[from] && !sacrificied[to]) {
1612                     require(tradingActive, "HEQET: trading not enabled yet");
1613 
1614                     if (
1615                         block.timestamp < launchedAt + snipingTime &&
1616                         from != address(uniswapV2Router)
1617                     ) {
1618                         if (address(uniswapV2Pair) == from) {
1619                             isBot[to] = true;
1620                         } else if (address(uniswapV2Pair) == to) {
1621                             isBot[from] = true;
1622                         }
1623                     }
1624                 }
1625 
1626                 require(
1627                     sacrificedTradingActive,
1628                     "HEQET: sacrificed trading not enabled yet"
1629                 );
1630 
1631                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1632                 if (transferDelayEnabled) {
1633                     if (
1634                         to != owner() &&
1635                         to != address(uniswapV2Router) &&
1636                         to != address(uniswapV2Pair)
1637                     ) {
1638                         require(
1639                             _holderLastTransferTimestamp[tx.origin] <
1640                                 block.number,
1641                             "HEQET: transfer delay enabled, only one purchase per block allowed."
1642                         );
1643                         _holderLastTransferTimestamp[tx.origin] = block.number;
1644                     }
1645                 }
1646 
1647                 //when buy
1648                 if (
1649                     automatedMarketMakerPairs[from] &&
1650                     !_isExcludedMaxTransactionAmount[to]
1651                 ) {
1652                     require(
1653                         amount <= maxTransactionAmount,
1654                         "HEQET: buy transfer amount exceeds the maxTransactionAmount."
1655                     );
1656                     require(
1657                         amount + balanceOf(to) <= maxWallet,
1658                         "HEQET: max wallet exceeded"
1659                     );
1660                 }
1661                 //when sell
1662                 else if (
1663                     automatedMarketMakerPairs[to] &&
1664                     !_isExcludedMaxTransactionAmount[from]
1665                 ) {
1666                     require(
1667                         amount <= maxTransactionAmount,
1668                         "HEQET: sell transfer amount exceeds the maxTransactionAmount."
1669                     );
1670                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1671                     require(
1672                         amount + balanceOf(to) <= maxWallet,
1673                         "HEQET: max wallet exceeded"
1674                     );
1675                 }
1676             }
1677         }
1678 
1679         uint256 contractTokenBalance = balanceOf(address(this));
1680 
1681         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1682 
1683         if (
1684             canSwap &&
1685             swapEnabled &&
1686             !swapping &&
1687             !automatedMarketMakerPairs[from] &&
1688             !_isExcludedFromFees[from] &&
1689             !_isExcludedFromFees[to]
1690         ) {
1691             swapping = true;
1692 
1693             swapBack();
1694 
1695             swapping = false;
1696         }
1697 
1698         bool takeFee = !swapping;
1699 
1700         // if any account belongs to _isExcludedFromFee account then remove the fee
1701         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1702             takeFee = false;
1703         }
1704 
1705         uint256 fees = 0;
1706         // only take fees on buys/sells, do not take on wallet transfers
1707         if (takeFee) {
1708             // on sell
1709             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1710                 fees = amount.mul(sellTotalFees).div(1000);
1711                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1712                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1713             }
1714             // on buy
1715             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1716                 fees = amount.mul(buyTotalFees).div(1000);
1717                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1718                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1719             }
1720 
1721             if (fees > 0) {
1722                 super._transfer(from, address(this), fees);
1723             }
1724 
1725             amount -= fees;
1726         }
1727 
1728         super._transfer(from, to, amount);
1729     }
1730 
1731     function swapTokensForEth(uint256 tokenAmount) internal {
1732         // generate the uniswap pair path of token -> weth
1733         address[] memory path = new address[](2);
1734         path[0] = address(this);
1735         path[1] = uniswapV2Router.WETH();
1736 
1737         _approve(address(this), address(uniswapV2Router), tokenAmount);
1738 
1739         // make the swap
1740         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1741             tokenAmount,
1742             0, // accept any amount of ETH
1743             path,
1744             address(this),
1745             block.timestamp
1746         );
1747     }
1748 
1749     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1750         // approve token transfer to cover all possible scenarios
1751         _approve(address(this), address(uniswapV2Router), tokenAmount);
1752 
1753         // add the liquidity
1754         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1755             address(this),
1756             tokenAmount,
1757             0, // slippage is unavoidable
1758             0, // slippage is unavoidable
1759             marketingWallet,
1760             block.timestamp
1761         );
1762     }
1763 
1764     function swapBack() internal {
1765         uint256 contractBalance = balanceOf(address(this));
1766         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1767         bool success;
1768 
1769         if (contractBalance == 0 || totalTokensToSwap == 0) {
1770             return;
1771         }
1772 
1773         if (contractBalance > swapTokensAtAmount * 20) {
1774             contractBalance = swapTokensAtAmount * 20;
1775         }
1776 
1777         // Halve the amount of liquidity tokens
1778         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1779             totalTokensToSwap /
1780             2;
1781         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1782 
1783         uint256 initialETHBalance = address(this).balance;
1784 
1785         swapTokensForEth(amountToSwapForETH);
1786 
1787         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1788 
1789         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1790             totalTokensToSwap
1791         );
1792 
1793         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1794 
1795         tokensForLiquidity = 0;
1796         tokensForMarketing = 0;
1797 
1798         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1799             addLiquidity(liquidityTokens, ethForLiquidity);
1800             emit SwapAndLiquify(
1801                 amountToSwapForETH,
1802                 ethForLiquidity,
1803                 tokensForLiquidity
1804             );
1805         }
1806 
1807         (success, ) = address(marketingWallet).call{
1808             value: address(this).balance
1809         }("");
1810     }
1811 }