1 /**
2 
3 https://t.me/ongoderc
4 
5 https://www.ong.wtf
6 
7 https://twitter.com/ongoderc
8 
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.20;
15 pragma experimental ABIEncoderV2;
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 // pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
42 
43 // pragma solidity ^0.8.0;
44 
45 // import "../utils/Context.sol";
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(
63         address indexed previousOwner,
64         address indexed newOwner
65     );
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         _checkOwner();
79         _;
80     }
81 
82     /**
83      * @dev Returns the address of the current owner.
84      */
85     function owner() public view virtual returns (address) {
86         return _owner;
87     }
88 
89     /**
90      * @dev Throws if the sender is not the owner.
91      */
92     function _checkOwner() internal view virtual {
93         require(owner() == _msgSender(), "Ownable: caller is not the owner");
94     }
95 
96     /**
97      * @dev Leaves the contract without owner. It will not be possible to call
98      * `onlyOwner` functions. Can only be called by the current owner.
99      *
100      * NOTE: Renouncing ownership will leave the contract without an owner,
101      * thereby disabling any functionality that is only available to the owner.
102      */
103     function renounceOwnership() public virtual onlyOwner {
104         _transferOwnership(address(0));
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Can only be called by the current owner.
110      */
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(
113             newOwner != address(0),
114             "Ownable: new owner is the zero address"
115         );
116         _transferOwnership(newOwner);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Internal function without access restriction.
122      */
123     function _transferOwnership(address newOwner) internal virtual {
124         address oldOwner = _owner;
125         _owner = newOwner;
126         emit OwnershipTransferred(oldOwner, newOwner);
127     }
128 }
129 
130 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
131 
132 // pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP.
136  */
137 interface IERC20 {
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(
151         address indexed owner,
152         address indexed spender,
153         uint256 value
154     );
155 
156     /**
157      * @dev Returns the amount of tokens in existence.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166     /**
167      * @dev Moves `amount` tokens from the caller's account to `to`.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transfer(address to, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Returns the remaining number of tokens that `spender` will be
177      * allowed to spend on behalf of `owner` through {transferFrom}. This is
178      * zero by default.
179      *
180      * This value changes when {approve} or {transferFrom} are called.
181      */
182     function allowance(address owner, address spender)
183         external
184         view
185         returns (uint256);
186 
187     /**
188      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * IMPORTANT: Beware that changing an allowance with this method brings the risk
193      * that someone may use both the old and the new allowance by unfortunate
194      * transaction ordering. One possible solution to mitigate this race
195      * condition is to first reduce the spender's allowance to 0 and set the
196      * desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      *
199      * Emits an {Approval} event.
200      */
201     function approve(address spender, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Moves `amount` tokens from `from` to `to` using the
205      * allowance mechanism. `amount` is then deducted from the caller's
206      * allowance.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transferFrom(
213         address from,
214         address to,
215         uint256 amount
216     ) external returns (bool);
217 }
218 
219 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
220 
221 // pragma solidity ^0.8.0;
222 
223 // import "../IERC20.sol";
224 
225 /**
226  * @dev Interface for the optional metadata functions from the ERC20 standard.
227  *
228  * _Available since v4.1._
229  */
230 interface IERC20Metadata is IERC20 {
231     /**
232      * @dev Returns the name of the token.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the symbol of the token.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the decimals places of the token.
243      */
244     function decimals() external view returns (uint8);
245 }
246 
247 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
248 
249 // pragma solidity ^0.8.0;
250 
251 // import "./IERC20.sol";
252 // import "./extensions/IERC20Metadata.sol";
253 // import "../../utils/Context.sol";
254 
255 /**
256  * @dev Implementation of the {IERC20} interface.
257  *
258  * This implementation is agnostic to the way tokens are created. This means
259  * that a supply mechanism has to be added in a derived contract using {_mint}.
260  * For a generic mechanism see {ERC20PresetMinterPauser}.
261  *
262  * TIP: For a detailed writeup see our guide
263  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
264  * to implement supply mechanisms].
265  *
266  * The default value of {decimals} is 18. To change this, you should override
267  * this function so it returns a different value.
268  *
269  * We have followed general OpenZeppelin Contracts guidelines: functions revert
270  * instead returning `false` on failure. This behavior is nonetheless
271  * conventional and does not conflict with the expectations of ERC20
272  * applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20, IERC20Metadata {
284     mapping(address => uint256) private _balances;
285 
286     mapping(address => mapping(address => uint256)) private _allowances;
287 
288     uint256 private _totalSupply;
289 
290     string private _name;
291     string private _symbol;
292 
293     /**
294      * @dev Sets the values for {name} and {symbol}.
295      *
296      * All two of these values are immutable: they can only be set once during
297      * construction.
298      */
299     constructor(string memory name_, string memory symbol_) {
300         _name = name_;
301         _symbol = symbol_;
302     }
303 
304     /**
305      * @dev Returns the name of the token.
306      */
307     function name() public view virtual override returns (string memory) {
308         return _name;
309     }
310 
311     /**
312      * @dev Returns the symbol of the token, usually a shorter version of the
313      * name.
314      */
315     function symbol() public view virtual override returns (string memory) {
316         return _symbol;
317     }
318 
319     /**
320      * @dev Returns the number of decimals used to get its user representation.
321      * For example, if `decimals` equals `2`, a balance of `505` tokens should
322      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
323      *
324      * Tokens usually opt for a value of 18, imitating the relationship between
325      * Ether and Wei. This is the default value returned by this function, unless
326      * it's overridden.
327      *
328      * NOTE: This information is only used for _display_ purposes: it in
329      * no way affects any of the arithmetic of the contract, including
330      * {IERC20-balanceOf} and {IERC20-transfer}.
331      */
332     function decimals() public view virtual override returns (uint8) {
333         return 18;
334     }
335 
336     /**
337      * @dev See {IERC20-totalSupply}.
338      */
339     function totalSupply() public view virtual override returns (uint256) {
340         return _totalSupply;
341     }
342 
343     /**
344      * @dev See {IERC20-balanceOf}.
345      */
346     function balanceOf(address account)
347         public
348         view
349         virtual
350         override
351         returns (uint256)
352     {
353         return _balances[account];
354     }
355 
356     /**
357      * @dev See {IERC20-transfer}.
358      *
359      * Requirements:
360      *
361      * - `to` cannot be the zero address.
362      * - the caller must have a balance of at least `amount`.
363      */
364     function transfer(address to, uint256 amount)
365         public
366         virtual
367         override
368         returns (bool)
369     {
370         address owner = _msgSender();
371         _transfer(owner, to, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-allowance}.
377      */
378     function allowance(address owner, address spender)
379         public
380         view
381         virtual
382         override
383         returns (uint256)
384     {
385         return _allowances[owner][spender];
386     }
387 
388     /**
389      * @dev See {IERC20-approve}.
390      *
391      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
392      * `transferFrom`. This is semantically equivalent to an infinite approval.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function approve(address spender, uint256 amount)
399         public
400         virtual
401         override
402         returns (bool)
403     {
404         address owner = _msgSender();
405         _approve(owner, spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20}.
414      *
415      * NOTE: Does not update the allowance if the current allowance
416      * is the maximum `uint256`.
417      *
418      * Requirements:
419      *
420      * - `from` and `to` cannot be the zero address.
421      * - `from` must have a balance of at least `amount`.
422      * - the caller must have allowance for ``from``'s tokens of at least
423      * `amount`.
424      */
425     function transferFrom(
426         address from,
427         address to,
428         uint256 amount
429     ) public virtual override returns (bool) {
430         address spender = _msgSender();
431         _spendAllowance(from, spender, amount);
432         _transfer(from, to, amount);
433         return true;
434     }
435 
436     /**
437      * @dev Atomically increases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      */
448     function increaseAllowance(address spender, uint256 addedValue)
449         public
450         virtual
451         returns (bool)
452     {
453         address owner = _msgSender();
454         _approve(owner, spender, allowance(owner, spender) + addedValue);
455         return true;
456     }
457 
458     /**
459      * @dev Atomically decreases the allowance granted to `spender` by the caller.
460      *
461      * This is an alternative to {approve} that can be used as a mitigation for
462      * problems described in {IERC20-approve}.
463      *
464      * Emits an {Approval} event indicating the updated allowance.
465      *
466      * Requirements:
467      *
468      * - `spender` cannot be the zero address.
469      * - `spender` must have allowance for the caller of at least
470      * `subtractedValue`.
471      */
472     function decreaseAllowance(address spender, uint256 subtractedValue)
473         public
474         virtual
475         returns (bool)
476     {
477         address owner = _msgSender();
478         uint256 currentAllowance = allowance(owner, spender);
479         require(
480             currentAllowance >= subtractedValue,
481             "ERC20: decreased allowance below zero"
482         );
483         unchecked {
484             _approve(owner, spender, currentAllowance - subtractedValue);
485         }
486 
487         return true;
488     }
489 
490     /**
491      * @dev Moves `amount` of tokens from `from` to `to`.
492      *
493      * This internal function is equivalent to {transfer}, and can be used to
494      * e.g. implement automatic token fees, slashing mechanisms, etc.
495      *
496      * Emits a {Transfer} event.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `from` must have a balance of at least `amount`.
503      */
504     function _transfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {
509         require(from != address(0), "ERC20: transfer from the zero address");
510         require(to != address(0), "ERC20: transfer to the zero address");
511 
512         _beforeTokenTransfer(from, to, amount);
513 
514         uint256 fromBalance = _balances[from];
515         require(
516             fromBalance >= amount,
517             "ERC20: transfer amount exceeds balance"
518         );
519         unchecked {
520             _balances[from] = fromBalance - amount;
521             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
522             // decrementing then incrementing.
523             _balances[to] += amount;
524         }
525 
526         emit Transfer(from, to, amount);
527 
528         _afterTokenTransfer(from, to, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a {Transfer} event with `from` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `account` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _beforeTokenTransfer(address(0), account, amount);
544 
545         _totalSupply += amount;
546         unchecked {
547             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
548             _balances[account] += amount;
549         }
550         emit Transfer(address(0), account, amount);
551 
552         _afterTokenTransfer(address(0), account, amount);
553     }
554 
555     /**
556      * @dev Destroys `amount` tokens from `account`, reducing the
557      * total supply.
558      *
559      * Emits a {Transfer} event with `to` set to the zero address.
560      *
561      * Requirements:
562      *
563      * - `account` cannot be the zero address.
564      * - `account` must have at least `amount` tokens.
565      */
566     function _burn(address account, uint256 amount) internal virtual {
567         require(account != address(0), "ERC20: burn from the zero address");
568 
569         _beforeTokenTransfer(account, address(0), amount);
570 
571         uint256 accountBalance = _balances[account];
572         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
573         unchecked {
574             _balances[account] = accountBalance - amount;
575             // Overflow not possible: amount <= accountBalance <= totalSupply.
576             _totalSupply -= amount;
577         }
578 
579         emit Transfer(account, address(0), amount);
580 
581         _afterTokenTransfer(account, address(0), amount);
582     }
583 
584     /**
585      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
586      *
587      * This internal function is equivalent to `approve`, and can be used to
588      * e.g. set automatic allowances for certain subsystems, etc.
589      *
590      * Emits an {Approval} event.
591      *
592      * Requirements:
593      *
594      * - `owner` cannot be the zero address.
595      * - `spender` cannot be the zero address.
596      */
597     function _approve(
598         address owner,
599         address spender,
600         uint256 amount
601     ) internal virtual {
602         require(owner != address(0), "ERC20: approve from the zero address");
603         require(spender != address(0), "ERC20: approve to the zero address");
604 
605         _allowances[owner][spender] = amount;
606         emit Approval(owner, spender, amount);
607     }
608 
609     /**
610      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
611      *
612      * Does not update the allowance amount in case of infinite allowance.
613      * Revert if not enough allowance is available.
614      *
615      * Might emit an {Approval} event.
616      */
617     function _spendAllowance(
618         address owner,
619         address spender,
620         uint256 amount
621     ) internal virtual {
622         uint256 currentAllowance = allowance(owner, spender);
623         if (currentAllowance != type(uint256).max) {
624             require(
625                 currentAllowance >= amount,
626                 "ERC20: insufficient allowance"
627             );
628             unchecked {
629                 _approve(owner, spender, currentAllowance - amount);
630             }
631         }
632     }
633 
634     /**
635      * @dev Hook that is called before any transfer of tokens. This includes
636      * minting and burning.
637      *
638      * Calling conditions:
639      *
640      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
641      * will be transferred to `to`.
642      * - when `from` is zero, `amount` tokens will be minted for `to`.
643      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
644      * - `from` and `to` are never both zero.
645      *
646      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
647      */
648     function _beforeTokenTransfer(
649         address from,
650         address to,
651         uint256 amount
652     ) internal virtual {}
653 
654     /**
655      * @dev Hook that is called after any transfer of tokens. This includes
656      * minting and burning.
657      *
658      * Calling conditions:
659      *
660      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
661      * has been transferred to `to`.
662      * - when `from` is zero, `amount` tokens have been minted for `to`.
663      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
664      * - `from` and `to` are never both zero.
665      *
666      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
667      */
668     function _afterTokenTransfer(
669         address from,
670         address to,
671         uint256 amount
672     ) internal virtual {}
673 }
674 
675 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
676 
677 // pragma solidity ^0.8.0;
678 
679 // CAUTION
680 // This version of SafeMath should only be used with Solidity 0.8 or later,
681 // because it relies on the compiler's built in overflow checks.
682 
683 /**
684  * @dev Wrappers over Solidity's arithmetic operations.
685  *
686  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
687  * now has built in overflow checking.
688  */
689 library SafeMath {
690     /**
691      * @dev Returns the addition of two unsigned integers, with an overflow flag.
692      *
693      * _Available since v3.4._
694      */
695     function tryAdd(uint256 a, uint256 b)
696         internal
697         pure
698         returns (bool, uint256)
699     {
700         unchecked {
701             uint256 c = a + b;
702             if (c < a) return (false, 0);
703             return (true, c);
704         }
705     }
706 
707     /**
708      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
709      *
710      * _Available since v3.4._
711      */
712     function trySub(uint256 a, uint256 b)
713         internal
714         pure
715         returns (bool, uint256)
716     {
717         unchecked {
718             if (b > a) return (false, 0);
719             return (true, a - b);
720         }
721     }
722 
723     /**
724      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
725      *
726      * _Available since v3.4._
727      */
728     function tryMul(uint256 a, uint256 b)
729         internal
730         pure
731         returns (bool, uint256)
732     {
733         unchecked {
734             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
735             // benefit is lost if 'b' is also tested.
736             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
737             if (a == 0) return (true, 0);
738             uint256 c = a * b;
739             if (c / a != b) return (false, 0);
740             return (true, c);
741         }
742     }
743 
744     /**
745      * @dev Returns the division of two unsigned integers, with a division by zero flag.
746      *
747      * _Available since v3.4._
748      */
749     function tryDiv(uint256 a, uint256 b)
750         internal
751         pure
752         returns (bool, uint256)
753     {
754         unchecked {
755             if (b == 0) return (false, 0);
756             return (true, a / b);
757         }
758     }
759 
760     /**
761      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
762      *
763      * _Available since v3.4._
764      */
765     function tryMod(uint256 a, uint256 b)
766         internal
767         pure
768         returns (bool, uint256)
769     {
770         unchecked {
771             if (b == 0) return (false, 0);
772             return (true, a % b);
773         }
774     }
775 
776     /**
777      * @dev Returns the addition of two unsigned integers, reverting on
778      * overflow.
779      *
780      * Counterpart to Solidity's `+` operator.
781      *
782      * Requirements:
783      *
784      * - Addition cannot overflow.
785      */
786     function add(uint256 a, uint256 b) internal pure returns (uint256) {
787         return a + b;
788     }
789 
790     /**
791      * @dev Returns the subtraction of two unsigned integers, reverting on
792      * overflow (when the result is negative).
793      *
794      * Counterpart to Solidity's `-` operator.
795      *
796      * Requirements:
797      *
798      * - Subtraction cannot overflow.
799      */
800     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
801         return a - b;
802     }
803 
804     /**
805      * @dev Returns the multiplication of two unsigned integers, reverting on
806      * overflow.
807      *
808      * Counterpart to Solidity's `*` operator.
809      *
810      * Requirements:
811      *
812      * - Multiplication cannot overflow.
813      */
814     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
815         return a * b;
816     }
817 
818     /**
819      * @dev Returns the integer division of two unsigned integers, reverting on
820      * division by zero. The result is rounded towards zero.
821      *
822      * Counterpart to Solidity's `/` operator.
823      *
824      * Requirements:
825      *
826      * - The divisor cannot be zero.
827      */
828     function div(uint256 a, uint256 b) internal pure returns (uint256) {
829         return a / b;
830     }
831 
832     /**
833      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
834      * reverting when dividing by zero.
835      *
836      * Counterpart to Solidity's `%` operator. This function uses a `revert`
837      * opcode (which leaves remaining gas untouched) while Solidity uses an
838      * invalid opcode to revert (consuming all remaining gas).
839      *
840      * Requirements:
841      *
842      * - The divisor cannot be zero.
843      */
844     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
845         return a % b;
846     }
847 
848     /**
849      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
850      * overflow (when the result is negative).
851      *
852      * CAUTION: This function is deprecated because it requires allocating memory for the error
853      * message unnecessarily. For custom revert reasons use {trySub}.
854      *
855      * Counterpart to Solidity's `-` operator.
856      *
857      * Requirements:
858      *
859      * - Subtraction cannot overflow.
860      */
861     function sub(
862         uint256 a,
863         uint256 b,
864         string memory errorMessage
865     ) internal pure returns (uint256) {
866         unchecked {
867             require(b <= a, errorMessage);
868             return a - b;
869         }
870     }
871 
872     /**
873      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
874      * division by zero. The result is rounded towards zero.
875      *
876      * Counterpart to Solidity's `/` operator. Note: this function uses a
877      * `revert` opcode (which leaves remaining gas untouched) while Solidity
878      * uses an invalid opcode to revert (consuming all remaining gas).
879      *
880      * Requirements:
881      *
882      * - The divisor cannot be zero.
883      */
884     function div(
885         uint256 a,
886         uint256 b,
887         string memory errorMessage
888     ) internal pure returns (uint256) {
889         unchecked {
890             require(b > 0, errorMessage);
891             return a / b;
892         }
893     }
894 
895     /**
896      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
897      * reverting with custom message when dividing by zero.
898      *
899      * CAUTION: This function is deprecated because it requires allocating memory for the error
900      * message unnecessarily. For custom revert reasons use {tryMod}.
901      *
902      * Counterpart to Solidity's `%` operator. This function uses a `revert`
903      * opcode (which leaves remaining gas untouched) while Solidity uses an
904      * invalid opcode to revert (consuming all remaining gas).
905      *
906      * Requirements:
907      *
908      * - The divisor cannot be zero.
909      */
910     function mod(
911         uint256 a,
912         uint256 b,
913         string memory errorMessage
914     ) internal pure returns (uint256) {
915         unchecked {
916             require(b > 0, errorMessage);
917             return a % b;
918         }
919     }
920 }
921 
922 // pragma solidity >=0.5.0;
923 
924 interface IUniswapV2Factory {
925     event PairCreated(
926         address indexed token0,
927         address indexed token1,
928         address pair,
929         uint256
930     );
931 
932     function feeTo() external view returns (address);
933 
934     function feeToSetter() external view returns (address);
935 
936     function getPair(address tokenA, address tokenB)
937         external
938         view
939         returns (address pair);
940 
941     function allPairs(uint256) external view returns (address pair);
942 
943     function allPairsLength() external view returns (uint256);
944 
945     function createPair(address tokenA, address tokenB)
946         external
947         returns (address pair);
948 
949     function setFeeTo(address) external;
950 
951     function setFeeToSetter(address) external;
952 }
953 
954 // pragma solidity >=0.5.0;
955 
956 interface IUniswapV2Pair {
957     event Approval(
958         address indexed owner,
959         address indexed spender,
960         uint256 value
961     );
962     event Transfer(address indexed from, address indexed to, uint256 value);
963 
964     function name() external pure returns (string memory);
965 
966     function symbol() external pure returns (string memory);
967 
968     function decimals() external pure returns (uint8);
969 
970     function totalSupply() external view returns (uint256);
971 
972     function balanceOf(address owner) external view returns (uint256);
973 
974     function allowance(address owner, address spender)
975         external
976         view
977         returns (uint256);
978 
979     function approve(address spender, uint256 value) external returns (bool);
980 
981     function transfer(address to, uint256 value) external returns (bool);
982 
983     function transferFrom(
984         address from,
985         address to,
986         uint256 value
987     ) external returns (bool);
988 
989     function DOMAIN_SEPARATOR() external view returns (bytes32);
990 
991     function PERMIT_TYPEHASH() external pure returns (bytes32);
992 
993     function nonces(address owner) external view returns (uint256);
994 
995     function permit(
996         address owner,
997         address spender,
998         uint256 value,
999         uint256 deadline,
1000         uint8 v,
1001         bytes32 r,
1002         bytes32 s
1003     ) external;
1004 
1005     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1006     event Burn(
1007         address indexed sender,
1008         uint256 amount0,
1009         uint256 amount1,
1010         address indexed to
1011     );
1012     event Swap(
1013         address indexed sender,
1014         uint256 amount0In,
1015         uint256 amount1In,
1016         uint256 amount0Out,
1017         uint256 amount1Out,
1018         address indexed to
1019     );
1020     event Sync(uint112 reserve0, uint112 reserve1);
1021 
1022     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1023 
1024     function factory() external view returns (address);
1025 
1026     function token0() external view returns (address);
1027 
1028     function token1() external view returns (address);
1029 
1030     function getReserves()
1031         external
1032         view
1033         returns (
1034             uint112 reserve0,
1035             uint112 reserve1,
1036             uint32 blockTimestampLast
1037         );
1038 
1039     function price0CumulativeLast() external view returns (uint256);
1040 
1041     function price1CumulativeLast() external view returns (uint256);
1042 
1043     function kLast() external view returns (uint256);
1044 
1045     function mint(address to) external returns (uint256 liquidity);
1046 
1047     function burn(address to)
1048         external
1049         returns (uint256 amount0, uint256 amount1);
1050 
1051     function swap(
1052         uint256 amount0Out,
1053         uint256 amount1Out,
1054         address to,
1055         bytes calldata data
1056     ) external;
1057 
1058     function skim(address to) external;
1059 
1060     function sync() external;
1061 
1062     function initialize(address, address) external;
1063 }
1064 
1065 // pragma solidity >=0.6.2;
1066 
1067 interface IUniswapV2Router01 {
1068     function factory() external pure returns (address);
1069 
1070     function WETH() external pure returns (address);
1071 
1072     function addLiquidity(
1073         address tokenA,
1074         address tokenB,
1075         uint256 amountADesired,
1076         uint256 amountBDesired,
1077         uint256 amountAMin,
1078         uint256 amountBMin,
1079         address to,
1080         uint256 deadline
1081     )
1082         external
1083         returns (
1084             uint256 amountA,
1085             uint256 amountB,
1086             uint256 liquidity
1087         );
1088 
1089     function addLiquidityETH(
1090         address token,
1091         uint256 amountTokenDesired,
1092         uint256 amountTokenMin,
1093         uint256 amountETHMin,
1094         address to,
1095         uint256 deadline
1096     )
1097         external
1098         payable
1099         returns (
1100             uint256 amountToken,
1101             uint256 amountETH,
1102             uint256 liquidity
1103         );
1104 
1105     function removeLiquidity(
1106         address tokenA,
1107         address tokenB,
1108         uint256 liquidity,
1109         uint256 amountAMin,
1110         uint256 amountBMin,
1111         address to,
1112         uint256 deadline
1113     ) external returns (uint256 amountA, uint256 amountB);
1114 
1115     function removeLiquidityETH(
1116         address token,
1117         uint256 liquidity,
1118         uint256 amountTokenMin,
1119         uint256 amountETHMin,
1120         address to,
1121         uint256 deadline
1122     ) external returns (uint256 amountToken, uint256 amountETH);
1123 
1124     function removeLiquidityWithPermit(
1125         address tokenA,
1126         address tokenB,
1127         uint256 liquidity,
1128         uint256 amountAMin,
1129         uint256 amountBMin,
1130         address to,
1131         uint256 deadline,
1132         bool approveMax,
1133         uint8 v,
1134         bytes32 r,
1135         bytes32 s
1136     ) external returns (uint256 amountA, uint256 amountB);
1137 
1138     function removeLiquidityETHWithPermit(
1139         address token,
1140         uint256 liquidity,
1141         uint256 amountTokenMin,
1142         uint256 amountETHMin,
1143         address to,
1144         uint256 deadline,
1145         bool approveMax,
1146         uint8 v,
1147         bytes32 r,
1148         bytes32 s
1149     ) external returns (uint256 amountToken, uint256 amountETH);
1150 
1151     function swapExactTokensForTokens(
1152         uint256 amountIn,
1153         uint256 amountOutMin,
1154         address[] calldata path,
1155         address to,
1156         uint256 deadline
1157     ) external returns (uint256[] memory amounts);
1158 
1159     function swapTokensForExactTokens(
1160         uint256 amountOut,
1161         uint256 amountInMax,
1162         address[] calldata path,
1163         address to,
1164         uint256 deadline
1165     ) external returns (uint256[] memory amounts);
1166 
1167     function swapExactETHForTokens(
1168         uint256 amountOutMin,
1169         address[] calldata path,
1170         address to,
1171         uint256 deadline
1172     ) external payable returns (uint256[] memory amounts);
1173 
1174     function swapTokensForExactETH(
1175         uint256 amountOut,
1176         uint256 amountInMax,
1177         address[] calldata path,
1178         address to,
1179         uint256 deadline
1180     ) external returns (uint256[] memory amounts);
1181 
1182     function swapExactTokensForETH(
1183         uint256 amountIn,
1184         uint256 amountOutMin,
1185         address[] calldata path,
1186         address to,
1187         uint256 deadline
1188     ) external returns (uint256[] memory amounts);
1189 
1190     function swapETHForExactTokens(
1191         uint256 amountOut,
1192         address[] calldata path,
1193         address to,
1194         uint256 deadline
1195     ) external payable returns (uint256[] memory amounts);
1196 
1197     function quote(
1198         uint256 amountA,
1199         uint256 reserveA,
1200         uint256 reserveB
1201     ) external pure returns (uint256 amountB);
1202 
1203     function getAmountOut(
1204         uint256 amountIn,
1205         uint256 reserveIn,
1206         uint256 reserveOut
1207     ) external pure returns (uint256 amountOut);
1208 
1209     function getAmountIn(
1210         uint256 amountOut,
1211         uint256 reserveIn,
1212         uint256 reserveOut
1213     ) external pure returns (uint256 amountIn);
1214 
1215     function getAmountsOut(uint256 amountIn, address[] calldata path)
1216         external
1217         view
1218         returns (uint256[] memory amounts);
1219 
1220     function getAmountsIn(uint256 amountOut, address[] calldata path)
1221         external
1222         view
1223         returns (uint256[] memory amounts);
1224 }
1225 
1226 // pragma solidity >=0.6.2;
1227 
1228 // import './IUniswapV2Router01.sol';
1229 
1230 interface IUniswapV2Router02 is IUniswapV2Router01 {
1231     function removeLiquidityETHSupportingFeeOnTransferTokens(
1232         address token,
1233         uint256 liquidity,
1234         uint256 amountTokenMin,
1235         uint256 amountETHMin,
1236         address to,
1237         uint256 deadline
1238     ) external returns (uint256 amountETH);
1239 
1240     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1241         address token,
1242         uint256 liquidity,
1243         uint256 amountTokenMin,
1244         uint256 amountETHMin,
1245         address to,
1246         uint256 deadline,
1247         bool approveMax,
1248         uint8 v,
1249         bytes32 r,
1250         bytes32 s
1251     ) external returns (uint256 amountETH);
1252 
1253     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1254         uint256 amountIn,
1255         uint256 amountOutMin,
1256         address[] calldata path,
1257         address to,
1258         uint256 deadline
1259     ) external;
1260 
1261     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1262         uint256 amountOutMin,
1263         address[] calldata path,
1264         address to,
1265         uint256 deadline
1266     ) external payable;
1267 
1268     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1269         uint256 amountIn,
1270         uint256 amountOutMin,
1271         address[] calldata path,
1272         address to,
1273         uint256 deadline
1274     ) external;
1275 }
1276 
1277 contract ONGOD is ERC20, Ownable {
1278     using SafeMath for uint256;
1279 
1280     IUniswapV2Router02 public immutable uniswapV2Router;
1281     address public immutable uniswapV2Pair;
1282     address public constant deadAddress = address(0xdead);
1283 
1284     bool private swapping;
1285 
1286     address public marketingWallet;
1287 
1288     uint256 public maxTransactionAmount;
1289     uint256 public swapTokensAtAmount;
1290     uint256 public maxWallet;
1291 
1292     bool public tradingActive = false;
1293     bool public swapEnabled = false;
1294 
1295     uint256 public buyTotalFees;
1296     uint256 private buyMarketingFee;
1297     uint256 private buyLiquidityFee;
1298 
1299     uint256 public sellTotalFees;
1300     uint256 private sellMarketingFee;
1301     uint256 private sellLiquidityFee;
1302 
1303     uint256 private tokensForMarketing;
1304     uint256 private tokensForLiquidity;
1305     uint256 private previousFee;
1306 
1307     mapping(address => bool) private _isExcludedFromFees;
1308     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1309     mapping(address => bool) private automatedMarketMakerPairs;
1310 
1311     event ExcludeFromFees(address indexed account, bool isExcluded);
1312 
1313     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1314 
1315     event marketingWalletUpdated(
1316         address indexed newWallet,
1317         address indexed oldWallet
1318     );
1319 
1320     event SwapAndLiquify(
1321         uint256 tokensSwapped,
1322         uint256 ethReceived,
1323         uint256 tokensIntoLiquidity
1324     );
1325 
1326     constructor() ERC20("ON GOD", "ONG") {
1327         uniswapV2Router = IUniswapV2Router02(
1328             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1329         );
1330         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1331             address(this),
1332             uniswapV2Router.WETH()
1333         );
1334 
1335         uint256 totalSupply = 100_000_000 ether;
1336 
1337         maxTransactionAmount = (totalSupply * 2) / 100;
1338         maxWallet = (totalSupply * 2) / 100;
1339         swapTokensAtAmount = (totalSupply * 1) / 1000;
1340 
1341         buyMarketingFee = 69;
1342         buyLiquidityFee = 0;
1343         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1344 
1345         sellMarketingFee = 69;
1346         sellLiquidityFee = 0;
1347         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1348         previousFee = sellTotalFees;
1349 
1350         marketingWallet = address(0xb7270CE3Da31047F88a479695712C69B09646925);
1351 
1352         excludeFromFees(owner(), true);
1353         excludeFromFees(address(this), true);
1354         excludeFromFees(deadAddress, true);
1355 
1356         excludeFromMaxTransaction(owner(), true);
1357         excludeFromMaxTransaction(address(this), true);
1358         excludeFromMaxTransaction(deadAddress, true);
1359         excludeFromMaxTransaction(address(uniswapV2Router), true);
1360         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1361 
1362         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1363 
1364         _mint(msg.sender, totalSupply);
1365     }
1366 
1367     receive() external payable {}
1368 
1369     function enableTrading() external onlyOwner {
1370         tradingActive = true;
1371         swapEnabled = true;
1372     }
1373 
1374     function updateSwapTokensAtAmount(uint256 newAmount)
1375         external
1376         onlyOwner
1377         returns (bool)
1378     {
1379         require(
1380             newAmount >= (totalSupply() * 1) / 100000,
1381             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1382         );
1383         require(
1384             newAmount <= (totalSupply() * 5) / 1000,
1385             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1386         );
1387         swapTokensAtAmount = newAmount;
1388         return true;
1389     }
1390 
1391     function updateMaxWalletAndTxnAmount(
1392         uint256 newTxnNum,
1393         uint256 newMaxWalletNum
1394     ) external onlyOwner {
1395         require(
1396             newTxnNum >= ((totalSupply() * 5) / 1000),
1397             "ERC20: Cannot set maxTxn lower than 0.5%"
1398         );
1399         require(
1400             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1401             "ERC20: Cannot set maxWallet lower than 0.5%"
1402         );
1403         maxWallet = newMaxWalletNum;
1404         maxTransactionAmount = newTxnNum;
1405     }
1406 
1407     function excludeFromMaxTransaction(address updAds, bool isEx)
1408         public
1409         onlyOwner
1410     {
1411         _isExcludedMaxTransactionAmount[updAds] = isEx;
1412     }
1413 
1414     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1415         external
1416         onlyOwner
1417     {
1418         buyMarketingFee = _marketingFee;
1419         buyLiquidityFee = _liquidityFee;
1420         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1421     }
1422 
1423     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1424         external
1425         onlyOwner
1426     {
1427         sellMarketingFee = _marketingFee;
1428         sellLiquidityFee = _liquidityFee;
1429         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1430         previousFee = sellTotalFees;
1431     }
1432 
1433     function updateMarketingWallet(address _marketingWallet)
1434         external
1435         onlyOwner
1436     {
1437         require(_marketingWallet != address(0), "ERC20: Address 0");
1438         address oldWallet = marketingWallet;
1439         marketingWallet = _marketingWallet;
1440         emit marketingWalletUpdated(marketingWallet, oldWallet);
1441     }
1442 
1443     function excludeFromFees(address account, bool excluded) public onlyOwner {
1444         _isExcludedFromFees[account] = excluded;
1445         emit ExcludeFromFees(account, excluded);
1446     }
1447 
1448     function withdrawStuckETH() public onlyOwner {
1449         bool success;
1450         (success, ) = address(msg.sender).call{value: address(this).balance}(
1451             ""
1452         );
1453     }
1454 
1455     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1456         automatedMarketMakerPairs[pair] = value;
1457 
1458         emit SetAutomatedMarketMakerPair(pair, value);
1459     }
1460 
1461     function isExcludedFromFees(address account) public view returns (bool) {
1462         return _isExcludedFromFees[account];
1463     }
1464 
1465     function _transfer(
1466         address from,
1467         address to,
1468         uint256 amount
1469     ) internal override {
1470         require(from != address(0), "ERC20: transfer from the zero address");
1471         require(to != address(0), "ERC20: transfer to the zero address");
1472 
1473         if (amount == 0) {
1474             super._transfer(from, to, 0);
1475             return;
1476         }
1477 
1478         if (
1479             from != owner() &&
1480             to != owner() &&
1481             to != address(0) &&
1482             to != deadAddress &&
1483             !swapping
1484         ) {
1485             if (!tradingActive) {
1486                 require(
1487                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1488                     "ERC20: Trading is not active."
1489                 );
1490             }
1491 
1492             //when buy
1493             if (
1494                 automatedMarketMakerPairs[from] &&
1495                 !_isExcludedMaxTransactionAmount[to]
1496             ) {
1497                 require(
1498                     amount <= maxTransactionAmount,
1499                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1500                 );
1501                 require(
1502                     amount + balanceOf(to) <= maxWallet,
1503                     "ERC20: Max wallet exceeded"
1504                 );
1505             }
1506             //when sell
1507             else if (
1508                 automatedMarketMakerPairs[to] &&
1509                 !_isExcludedMaxTransactionAmount[from]
1510             ) {
1511                 require(
1512                     amount <= maxTransactionAmount,
1513                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1514                 );
1515             } else if (!_isExcludedMaxTransactionAmount[to]) {
1516                 require(
1517                     amount + balanceOf(to) <= maxWallet,
1518                     "ERC20: Max wallet exceeded"
1519                 );
1520             }
1521         }
1522 
1523         uint256 contractTokenBalance = balanceOf(address(this));
1524 
1525         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1526 
1527         if (
1528             canSwap &&
1529             swapEnabled &&
1530             !swapping &&
1531             !automatedMarketMakerPairs[from] &&
1532             !_isExcludedFromFees[from] &&
1533             !_isExcludedFromFees[to]
1534         ) {
1535             swapping = true;
1536 
1537             swapBack();
1538 
1539             swapping = false;
1540         }
1541 
1542         bool takeFee = !swapping;
1543 
1544         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1545             takeFee = false;
1546         }
1547 
1548         uint256 fees = 0;
1549 
1550         if (takeFee) {
1551             // on sell
1552             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1553                 fees = amount.mul(sellTotalFees).div(100);
1554                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1555                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1556             }
1557             // on buy
1558             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1559                 fees = amount.mul(buyTotalFees).div(100);
1560                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1561                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1562             }
1563 
1564             if (fees > 0) {
1565                 super._transfer(from, address(this), fees);
1566             }
1567 
1568             amount -= fees;
1569         }
1570 
1571         super._transfer(from, to, amount);
1572         sellTotalFees = previousFee;
1573     }
1574 
1575     function swapTokensForEth(uint256 tokenAmount) private {
1576         address[] memory path = new address[](2);
1577         path[0] = address(this);
1578         path[1] = uniswapV2Router.WETH();
1579 
1580         _approve(address(this), address(uniswapV2Router), tokenAmount);
1581 
1582         // make the swap
1583         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1584             tokenAmount,
1585             0,
1586             path,
1587             address(this),
1588             block.timestamp
1589         );
1590     }
1591 
1592     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1593         _approve(address(this), address(uniswapV2Router), tokenAmount);
1594 
1595         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1596             address(this),
1597             tokenAmount,
1598             0,
1599             0,
1600             owner(),
1601             block.timestamp
1602         );
1603     }
1604 
1605     function swapBack() private {
1606         uint256 contractBalance = balanceOf(address(this));
1607         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1608         bool success;
1609 
1610         if (contractBalance == 0 || totalTokensToSwap == 0) {
1611             return;
1612         }
1613 
1614         if (contractBalance > swapTokensAtAmount * 20) {
1615             contractBalance = swapTokensAtAmount * 20;
1616         }
1617 
1618         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1619             totalTokensToSwap /
1620             2;
1621         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1622 
1623         uint256 initialETHBalance = address(this).balance;
1624 
1625         swapTokensForEth(amountToSwapForETH);
1626 
1627         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1628 
1629         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1630             totalTokensToSwap
1631         );
1632 
1633         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1634 
1635         tokensForLiquidity = 0;
1636         tokensForMarketing = 0;
1637 
1638         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1639             addLiquidity(liquidityTokens, ethForLiquidity);
1640             emit SwapAndLiquify(
1641                 amountToSwapForETH,
1642                 ethForLiquidity,
1643                 tokensForLiquidity
1644             );
1645         }
1646 
1647         (success, ) = address(marketingWallet).call{value: address(this).balance}(
1648             ""
1649         );
1650     }
1651 }