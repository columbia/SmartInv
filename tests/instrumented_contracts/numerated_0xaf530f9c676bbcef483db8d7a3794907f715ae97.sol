1 // https://t.me/memeszoo_erc20
2 // https://twitter.com/memeszoo_erc20
3 
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.20;
8 pragma experimental ABIEncoderV2;
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 // pragma solidity ^0.8.0;
35 
36 // import "../utils/Context.sol";
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() {
62         _transferOwnership(_msgSender());
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         _checkOwner();
70         _;
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if the sender is not the owner.
82      */
83     function _checkOwner() internal view virtual {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85     }
86 
87 
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91     
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(
98             newOwner != address(0),
99             "Ownable: new owner is the zero address"
100         );
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
116 
117 // pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Emitted when `value` tokens are moved from one account (`from`) to
125      * another (`to`).
126      *
127      * Note that `value` may be zero.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to {approve}. `value` is the new allowance.
134      */
135     event Approval(
136         address indexed owner,
137         address indexed spender,
138         uint256 value
139     );
140 
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `to`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address to, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender)
168         external
169         view
170         returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * IMPORTANT: Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `from` to `to` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address from,
199         address to,
200         uint256 amount
201     ) external returns (bool);
202 }
203 
204 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
205 
206 // pragma solidity ^0.8.0;
207 
208 // import "../IERC20.sol";
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 }
231 
232 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
233 
234 // pragma solidity ^0.8.0;
235 
236 // import "./IERC20.sol";
237 // import "./extensions/IERC20Metadata.sol";
238 // import "../../utils/Context.sol";
239 
240 /**
241  * @dev Implementation of the {IERC20} interface.
242  *
243  * This implementation is agnostic to the way tokens are created. This means
244  * that a supply mechanism has to be added in a derived contract using {_mint}.
245  * For a generic mechanism see {ERC20PresetMinterPauser}.
246  *
247  * TIP: For a detailed writeup see our guide
248  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
249  * to implement supply mechanisms].
250  *
251  * The default value of {decimals} is 18. To change this, you should override
252  * this function so it returns a different value.
253  *
254  * We have followed general OpenZeppelin Contracts guidelines: functions revert
255  * instead returning `false` on failure. This behavior is nonetheless
256  * conventional and does not conflict with the expectations of ERC20
257  * applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20, IERC20Metadata {
269     mapping(address => uint256) private _balances;
270 
271     mapping(address => mapping(address => uint256)) private _allowances;
272 
273     uint256 private _totalSupply;
274 
275     string private _name;
276     string private _symbol;
277 
278     /**
279      * @dev Sets the values for {name} and {symbol}.
280      *
281      * All two of these values are immutable: they can only be set once during
282      * construction.
283      */
284     constructor(string memory name_, string memory symbol_) {
285         _name = name_;
286         _symbol = symbol_;
287     }
288 
289     /**
290      * @dev Returns the name of the token.
291      */
292     function name() public view virtual override returns (string memory) {
293         return _name;
294     }
295 
296     /**
297      * @dev Returns the symbol of the token, usually a shorter version of the
298      * name.
299      */
300     function symbol() public view virtual override returns (string memory) {
301         return _symbol;
302     }
303 
304     /**
305      * @dev Returns the number of decimals used to get its user representation.
306      * For example, if `decimals` equals `2`, a balance of `505` tokens should
307      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
308      *
309      * Tokens usually opt for a value of 18, imitating the relationship between
310      * Ether and Wei. This is the default value returned by this function, unless
311      * it's overridden.
312      *
313      * NOTE: This information is only used for _display_ purposes: it in
314      * no way affects any of the arithmetic of the contract, including
315      * {IERC20-balanceOf} and {IERC20-transfer}.
316      */
317     function decimals() public view virtual override returns (uint8) {
318         return 18;
319     }
320 
321     /**
322      * @dev See {IERC20-totalSupply}.
323      */
324     function totalSupply() public view virtual override returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev See {IERC20-balanceOf}.
330      */
331     function balanceOf(address account)
332         public
333         view
334         virtual
335         override
336         returns (uint256)
337     {
338         return _balances[account];
339     }
340 
341     /**
342      * @dev See {IERC20-transfer}.
343      *
344      * Requirements:
345      *
346      * - `to` cannot be the zero address.
347      * - the caller must have a balance of at least `amount`.
348      */
349     function transfer(address to, uint256 amount)
350         public
351         virtual
352         override
353         returns (bool)
354     {
355         address owner = _msgSender();
356         _transfer(owner, to, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-allowance}.
362      */
363     function allowance(address owner, address spender)
364         public
365         view
366         virtual
367         override
368         returns (uint256)
369     {
370         return _allowances[owner][spender];
371     }
372 
373     /**
374      * @dev See {IERC20-approve}.
375      *
376      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
377      * `transferFrom`. This is semantically equivalent to an infinite approval.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function approve(address spender, uint256 amount)
384         public
385         virtual
386         override
387         returns (bool)
388     {
389         address owner = _msgSender();
390         _approve(owner, spender, amount);
391         return true;
392     }
393 
394     /**
395      * @dev See {IERC20-transferFrom}.
396      *
397      * Emits an {Approval} event indicating the updated allowance. This is not
398      * required by the EIP. See the note at the beginning of {ERC20}.
399      *
400      * NOTE: Does not update the allowance if the current allowance
401      * is the maximum `uint256`.
402      *
403      * Requirements:
404      *
405      * - `from` and `to` cannot be the zero address.
406      * - `from` must have a balance of at least `amount`.
407      * - the caller must have allowance for ``from``'s tokens of at least
408      * `amount`.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 amount
414     ) public virtual override returns (bool) {
415         address spender = _msgSender();
416         _spendAllowance(from, spender, amount);
417         _transfer(from, to, amount);
418         return true;
419     }
420 
421     /**
422      * @dev Atomically increases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      */
433     function increaseAllowance(address spender, uint256 addedValue)
434         public
435         virtual
436         returns (bool)
437     {
438         address owner = _msgSender();
439         _approve(owner, spender, allowance(owner, spender) + addedValue);
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue)
458         public
459         virtual
460         returns (bool)
461     {
462         address owner = _msgSender();
463         uint256 currentAllowance = allowance(owner, spender);
464         require(
465             currentAllowance >= subtractedValue,
466             "ERC20: decreased allowance below zero"
467         );
468         unchecked {
469             _approve(owner, spender, currentAllowance - subtractedValue);
470         }
471 
472         return true;
473     }
474 
475     /**
476      * @dev Moves `amount` of tokens from `from` to `to`.
477      *
478      * This internal function is equivalent to {transfer}, and can be used to
479      * e.g. implement automatic token fees, slashing mechanisms, etc.
480      *
481      * Emits a {Transfer} event.
482      *
483      * Requirements:
484      *
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      * - `from` must have a balance of at least `amount`.
488      */
489     function _transfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {
494         require(from != address(0), "ERC20: transfer from the zero address");
495         require(to != address(0), "ERC20: transfer to the zero address");
496 
497         _beforeTokenTransfer(from, to, amount);
498 
499         uint256 fromBalance = _balances[from];
500         require(
501             fromBalance >= amount,
502             "ERC20: transfer amount exceeds balance"
503         );
504         unchecked {
505             _balances[from] = fromBalance - amount;
506             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
507             // decrementing then incrementing.
508             _balances[to] += amount;
509         }
510 
511         emit Transfer(from, to, amount);
512 
513         _afterTokenTransfer(from, to, amount);
514     }
515 
516     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
517      * the total supply.
518      *
519      * Emits a {Transfer} event with `from` set to the zero address.
520      *
521      * Requirements:
522      *
523      * - `account` cannot be the zero address.
524      */
525     function _mint(address account, uint256 amount) internal virtual {
526         require(account != address(0), "ERC20: mint to the zero address");
527 
528         _beforeTokenTransfer(address(0), account, amount);
529 
530         _totalSupply += amount;
531         unchecked {
532             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
533             _balances[account] += amount;
534         }
535         emit Transfer(address(0), account, amount);
536 
537         _afterTokenTransfer(address(0), account, amount);
538     }
539 
540     /**
541      * @dev Destroys `amount` tokens from `account`, reducing the
542      * total supply.
543      *
544      * Emits a {Transfer} event with `to` set to the zero address.
545      *
546      * Requirements:
547      *
548      * - `account` cannot be the zero address.
549      * - `account` must have at least `amount` tokens.
550      */
551     function _burn(address account, uint256 amount) internal virtual {
552         require(account != address(0), "ERC20: burn from the zero address");
553 
554         _beforeTokenTransfer(account, address(0), amount);
555 
556         uint256 accountBalance = _balances[account];
557         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
558         unchecked {
559             _balances[account] = accountBalance - amount;
560             // Overflow not possible: amount <= accountBalance <= totalSupply.
561             _totalSupply -= amount;
562         }
563 
564         emit Transfer(account, address(0), amount);
565 
566         _afterTokenTransfer(account, address(0), amount);
567     }
568 
569     /**
570      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
571      *
572      * This internal function is equivalent to `approve`, and can be used to
573      * e.g. set automatic allowances for certain subsystems, etc.
574      *
575      * Emits an {Approval} event.
576      *
577      * Requirements:
578      *
579      * - `owner` cannot be the zero address.
580      * - `spender` cannot be the zero address.
581      */
582     function _approve(
583         address owner,
584         address spender,
585         uint256 amount
586     ) internal virtual {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589 
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593 
594     /**
595      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
596      *
597      * Does not update the allowance amount in case of infinite allowance.
598      * Revert if not enough allowance is available.
599      *
600      * Might emit an {Approval} event.
601      */
602     function _spendAllowance(
603         address owner,
604         address spender,
605         uint256 amount
606     ) internal virtual {
607         uint256 currentAllowance = allowance(owner, spender);
608         if (currentAllowance != type(uint256).max) {
609             require(
610                 currentAllowance >= amount,
611                 "ERC20: insufficient allowance"
612             );
613             unchecked {
614                 _approve(owner, spender, currentAllowance - amount);
615             }
616         }
617     }
618 
619     /**
620      * @dev Hook that is called before any transfer of tokens. This includes
621      * minting and burning.
622      *
623      * Calling conditions:
624      *
625      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
626      * will be transferred to `to`.
627      * - when `from` is zero, `amount` tokens will be minted for `to`.
628      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
629      * - `from` and `to` are never both zero.
630      *
631      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
632      */
633     function _beforeTokenTransfer(
634         address from,
635         address to,
636         uint256 amount
637     ) internal virtual {}
638 
639     /**
640      * @dev Hook that is called after any transfer of tokens. This includes
641      * minting and burning.
642      *
643      * Calling conditions:
644      *
645      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
646      * has been transferred to `to`.
647      * - when `from` is zero, `amount` tokens have been minted for `to`.
648      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
649      * - `from` and `to` are never both zero.
650      *
651      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
652      */
653     function _afterTokenTransfer(
654         address from,
655         address to,
656         uint256 amount
657     ) internal virtual {}
658 }
659 
660 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
661 
662 // pragma solidity ^0.8.0;
663 
664 // CAUTION
665 // This version of SafeMath should only be used with Solidity 0.8 or later,
666 // because it relies on the compiler's built in overflow checks.
667 
668 /**
669  * @dev Wrappers over Solidity's arithmetic operations.
670  *
671  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
672  * now has built in overflow checking.
673  */
674 library SafeMath {
675     /**
676      * @dev Returns the addition of two unsigned integers, with an overflow flag.
677      *
678      * _Available since v3.4._
679      */
680     function tryAdd(uint256 a, uint256 b)
681         internal
682         pure
683         returns (bool, uint256)
684     {
685         unchecked {
686             uint256 c = a + b;
687             if (c < a) return (false, 0);
688             return (true, c);
689         }
690     }
691 
692     /**
693      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
694      *
695      * _Available since v3.4._
696      */
697     function trySub(uint256 a, uint256 b)
698         internal
699         pure
700         returns (bool, uint256)
701     {
702         unchecked {
703             if (b > a) return (false, 0);
704             return (true, a - b);
705         }
706     }
707 
708     /**
709      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
710      *
711      * _Available since v3.4._
712      */
713     function tryMul(uint256 a, uint256 b)
714         internal
715         pure
716         returns (bool, uint256)
717     {
718         unchecked {
719             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
720             // benefit is lost if 'b' is also tested.
721             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
722             if (a == 0) return (true, 0);
723             uint256 c = a * b;
724             if (c / a != b) return (false, 0);
725             return (true, c);
726         }
727     }
728 
729     /**
730      * @dev Returns the division of two unsigned integers, with a division by zero flag.
731      *
732      * _Available since v3.4._
733      */
734     function tryDiv(uint256 a, uint256 b)
735         internal
736         pure
737         returns (bool, uint256)
738     {
739         unchecked {
740             if (b == 0) return (false, 0);
741             return (true, a / b);
742         }
743     }
744 
745     /**
746      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
747      *
748      * _Available since v3.4._
749      */
750     function tryMod(uint256 a, uint256 b)
751         internal
752         pure
753         returns (bool, uint256)
754     {
755         unchecked {
756             if (b == 0) return (false, 0);
757             return (true, a % b);
758         }
759     }
760 
761     /**
762      * @dev Returns the addition of two unsigned integers, reverting on
763      * overflow.
764      *
765      * Counterpart to Solidity's `+` operator.
766      *
767      * Requirements:
768      *
769      * - Addition cannot overflow.
770      */
771     function add(uint256 a, uint256 b) internal pure returns (uint256) {
772         return a + b;
773     }
774 
775     /**
776      * @dev Returns the subtraction of two unsigned integers, reverting on
777      * overflow (when the result is negative).
778      *
779      * Counterpart to Solidity's `-` operator.
780      *
781      * Requirements:
782      *
783      * - Subtraction cannot overflow.
784      */
785     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
786         return a - b;
787     }
788 
789     /**
790      * @dev Returns the multiplication of two unsigned integers, reverting on
791      * overflow.
792      *
793      * Counterpart to Solidity's `*` operator.
794      *
795      * Requirements:
796      *
797      * - Multiplication cannot overflow.
798      */
799     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
800         return a * b;
801     }
802 
803     /**
804      * @dev Returns the integer division of two unsigned integers, reverting on
805      * division by zero. The result is rounded towards zero.
806      *
807      * Counterpart to Solidity's `/` operator.
808      *
809      * Requirements:
810      *
811      * - The divisor cannot be zero.
812      */
813     function div(uint256 a, uint256 b) internal pure returns (uint256) {
814         return a / b;
815     }
816 
817     /**
818      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
819      * reverting when dividing by zero.
820      *
821      * Counterpart to Solidity's `%` operator. This function uses a `revert`
822      * opcode (which leaves remaining gas untouched) while Solidity uses an
823      * invalid opcode to revert (consuming all remaining gas).
824      *
825      * Requirements:
826      *
827      * - The divisor cannot be zero.
828      */
829     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
830         return a % b;
831     }
832 
833     /**
834      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
835      * overflow (when the result is negative).
836      *
837      * CAUTION: This function is deprecated because it requires allocating memory for the error
838      * message unnecessarily. For custom revert reasons use {trySub}.
839      *
840      * Counterpart to Solidity's `-` operator.
841      *
842      * Requirements:
843      *
844      * - Subtraction cannot overflow.
845      */
846     function sub(
847         uint256 a,
848         uint256 b,
849         string memory errorMessage
850     ) internal pure returns (uint256) {
851         unchecked {
852             require(b <= a, errorMessage);
853             return a - b;
854         }
855     }
856 
857     /**
858      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
859      * division by zero. The result is rounded towards zero.
860      *
861      * Counterpart to Solidity's `/` operator. Note: this function uses a
862      * `revert` opcode (which leaves remaining gas untouched) while Solidity
863      * uses an invalid opcode to revert (consuming all remaining gas).
864      *
865      * Requirements:
866      *
867      * - The divisor cannot be zero.
868      */
869     function div(
870         uint256 a,
871         uint256 b,
872         string memory errorMessage
873     ) internal pure returns (uint256) {
874         unchecked {
875             require(b > 0, errorMessage);
876             return a / b;
877         }
878     }
879 
880     /**
881      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
882      * reverting with custom message when dividing by zero.
883      *
884      * CAUTION: This function is deprecated because it requires allocating memory for the error
885      * message unnecessarily. For custom revert reasons use {tryMod}.
886      *
887      * Counterpart to Solidity's `%` operator. This function uses a `revert`
888      * opcode (which leaves remaining gas untouched) while Solidity uses an
889      * invalid opcode to revert (consuming all remaining gas).
890      *
891      * Requirements:
892      *
893      * - The divisor cannot be zero.
894      */
895     function mod(
896         uint256 a,
897         uint256 b,
898         string memory errorMessage
899     ) internal pure returns (uint256) {
900         unchecked {
901             require(b > 0, errorMessage);
902             return a % b;
903         }
904     }
905 }
906 
907 // pragma solidity >=0.5.0;
908 
909 interface IUniswapV2Factory {
910     event PairCreated(
911         address indexed token0,
912         address indexed token1,
913         address pair,
914         uint256
915     );
916 
917     function feeTo() external view returns (address);
918 
919     function feeToSetter() external view returns (address);
920 
921     function getPair(address tokenA, address tokenB)
922         external
923         view
924         returns (address pair);
925 
926     function allPairs(uint256) external view returns (address pair);
927 
928     function allPairsLength() external view returns (uint256);
929 
930     function createPair(address tokenA, address tokenB)
931         external
932         returns (address pair);
933 
934     function setFeeTo(address) external;
935 
936     function setFeeToSetter(address) external;
937 }
938 
939 // pragma solidity >=0.5.0;
940 
941 interface IUniswapV2Pair {
942     event Approval(
943         address indexed owner,
944         address indexed spender,
945         uint256 value
946     );
947     event Transfer(address indexed from, address indexed to, uint256 value);
948 
949     function name() external pure returns (string memory);
950 
951     function symbol() external pure returns (string memory);
952 
953     function decimals() external pure returns (uint8);
954 
955     function totalSupply() external view returns (uint256);
956 
957     function balanceOf(address owner) external view returns (uint256);
958 
959     function allowance(address owner, address spender)
960         external
961         view
962         returns (uint256);
963 
964     function approve(address spender, uint256 value) external returns (bool);
965 
966     function transfer(address to, uint256 value) external returns (bool);
967 
968     function transferFrom(
969         address from,
970         address to,
971         uint256 value
972     ) external returns (bool);
973 
974     function DOMAIN_SEPARATOR() external view returns (bytes32);
975 
976     function PERMIT_TYPEHASH() external pure returns (bytes32);
977 
978     function nonces(address owner) external view returns (uint256);
979 
980     function permit(
981         address owner,
982         address spender,
983         uint256 value,
984         uint256 deadline,
985         uint8 v,
986         bytes32 r,
987         bytes32 s
988     ) external;
989 
990     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
991     event Burn(
992         address indexed sender,
993         uint256 amount0,
994         uint256 amount1,
995         address indexed to
996     );
997     event Swap(
998         address indexed sender,
999         uint256 amount0In,
1000         uint256 amount1In,
1001         uint256 amount0Out,
1002         uint256 amount1Out,
1003         address indexed to
1004     );
1005     event Sync(uint112 reserve0, uint112 reserve1);
1006 
1007     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1008 
1009     function factory() external view returns (address);
1010 
1011     function token0() external view returns (address);
1012 
1013     function token1() external view returns (address);
1014 
1015     function getReserves()
1016         external
1017         view
1018         returns (
1019             uint112 reserve0,
1020             uint112 reserve1,
1021             uint32 blockTimestampLast
1022         );
1023 
1024     function price0CumulativeLast() external view returns (uint256);
1025 
1026     function price1CumulativeLast() external view returns (uint256);
1027 
1028     function kLast() external view returns (uint256);
1029 
1030     function mint(address to) external returns (uint256 liquidity);
1031 
1032     function burn(address to)
1033         external
1034         returns (uint256 amount0, uint256 amount1);
1035 
1036     function swap(
1037         uint256 amount0Out,
1038         uint256 amount1Out,
1039         address to,
1040         bytes calldata data
1041     ) external;
1042 
1043     function skim(address to) external;
1044 
1045     function sync() external;
1046 
1047     function initialize(address, address) external;
1048 }
1049 
1050 // pragma solidity >=0.6.2;
1051 
1052 interface IUniswapV2Router01 {
1053     function factory() external pure returns (address);
1054 
1055     function WETH() external pure returns (address);
1056 
1057     function addLiquidity(
1058         address tokenA,
1059         address tokenB,
1060         uint256 amountADesired,
1061         uint256 amountBDesired,
1062         uint256 amountAMin,
1063         uint256 amountBMin,
1064         address to,
1065         uint256 deadline
1066     )
1067         external
1068         returns (
1069             uint256 amountA,
1070             uint256 amountB,
1071             uint256 liquidity
1072         );
1073 
1074     function addLiquidityETH(
1075         address token,
1076         uint256 amountTokenDesired,
1077         uint256 amountTokenMin,
1078         uint256 amountETHMin,
1079         address to,
1080         uint256 deadline
1081     )
1082         external
1083         payable
1084         returns (
1085             uint256 amountToken,
1086             uint256 amountETH,
1087             uint256 liquidity
1088         );
1089 
1090     function removeLiquidity(
1091         address tokenA,
1092         address tokenB,
1093         uint256 liquidity,
1094         uint256 amountAMin,
1095         uint256 amountBMin,
1096         address to,
1097         uint256 deadline
1098     ) external returns (uint256 amountA, uint256 amountB);
1099 
1100     function removeLiquidityETH(
1101         address token,
1102         uint256 liquidity,
1103         uint256 amountTokenMin,
1104         uint256 amountETHMin,
1105         address to,
1106         uint256 deadline
1107     ) external returns (uint256 amountToken, uint256 amountETH);
1108 
1109     function removeLiquidityWithPermit(
1110         address tokenA,
1111         address tokenB,
1112         uint256 liquidity,
1113         uint256 amountAMin,
1114         uint256 amountBMin,
1115         address to,
1116         uint256 deadline,
1117         bool approveMax,
1118         uint8 v,
1119         bytes32 r,
1120         bytes32 s
1121     ) external returns (uint256 amountA, uint256 amountB);
1122 
1123     function removeLiquidityETHWithPermit(
1124         address token,
1125         uint256 liquidity,
1126         uint256 amountTokenMin,
1127         uint256 amountETHMin,
1128         address to,
1129         uint256 deadline,
1130         bool approveMax,
1131         uint8 v,
1132         bytes32 r,
1133         bytes32 s
1134     ) external returns (uint256 amountToken, uint256 amountETH);
1135 
1136     function swapExactTokensForTokens(
1137         uint256 amountIn,
1138         uint256 amountOutMin,
1139         address[] calldata path,
1140         address to,
1141         uint256 deadline
1142     ) external returns (uint256[] memory amounts);
1143 
1144     function swapTokensForExactTokens(
1145         uint256 amountOut,
1146         uint256 amountInMax,
1147         address[] calldata path,
1148         address to,
1149         uint256 deadline
1150     ) external returns (uint256[] memory amounts);
1151 
1152     function swapExactETHForTokens(
1153         uint256 amountOutMin,
1154         address[] calldata path,
1155         address to,
1156         uint256 deadline
1157     ) external payable returns (uint256[] memory amounts);
1158 
1159     function swapTokensForExactETH(
1160         uint256 amountOut,
1161         uint256 amountInMax,
1162         address[] calldata path,
1163         address to,
1164         uint256 deadline
1165     ) external returns (uint256[] memory amounts);
1166 
1167     function swapExactTokensForETH(
1168         uint256 amountIn,
1169         uint256 amountOutMin,
1170         address[] calldata path,
1171         address to,
1172         uint256 deadline
1173     ) external returns (uint256[] memory amounts);
1174 
1175     function swapETHForExactTokens(
1176         uint256 amountOut,
1177         address[] calldata path,
1178         address to,
1179         uint256 deadline
1180     ) external payable returns (uint256[] memory amounts);
1181 
1182     function quote(
1183         uint256 amountA,
1184         uint256 reserveA,
1185         uint256 reserveB
1186     ) external pure returns (uint256 amountB);
1187 
1188     function getAmountOut(
1189         uint256 amountIn,
1190         uint256 reserveIn,
1191         uint256 reserveOut
1192     ) external pure returns (uint256 amountOut);
1193 
1194     function getAmountIn(
1195         uint256 amountOut,
1196         uint256 reserveIn,
1197         uint256 reserveOut
1198     ) external pure returns (uint256 amountIn);
1199 
1200     function getAmountsOut(uint256 amountIn, address[] calldata path)
1201         external
1202         view
1203         returns (uint256[] memory amounts);
1204 
1205     function getAmountsIn(uint256 amountOut, address[] calldata path)
1206         external
1207         view
1208         returns (uint256[] memory amounts);
1209 }
1210 
1211 // pragma solidity >=0.6.2;
1212 
1213 // import './IUniswapV2Router01.sol';
1214 
1215 interface IUniswapV2Router02 is IUniswapV2Router01 {
1216     function removeLiquidityETHSupportingFeeOnTransferTokens(
1217         address token,
1218         uint256 liquidity,
1219         uint256 amountTokenMin,
1220         uint256 amountETHMin,
1221         address to,
1222         uint256 deadline
1223     ) external returns (uint256 amountETH);
1224 
1225     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1226         address token,
1227         uint256 liquidity,
1228         uint256 amountTokenMin,
1229         uint256 amountETHMin,
1230         address to,
1231         uint256 deadline,
1232         bool approveMax,
1233         uint8 v,
1234         bytes32 r,
1235         bytes32 s
1236     ) external returns (uint256 amountETH);
1237 
1238     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1239         uint256 amountIn,
1240         uint256 amountOutMin,
1241         address[] calldata path,
1242         address to,
1243         uint256 deadline
1244     ) external;
1245 
1246     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1247         uint256 amountOutMin,
1248         address[] calldata path,
1249         address to,
1250         uint256 deadline
1251     ) external payable;
1252 
1253     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1254         uint256 amountIn,
1255         uint256 amountOutMin,
1256         address[] calldata path,
1257         address to,
1258         uint256 deadline
1259     ) external;
1260 }
1261 
1262 contract MemesZoo is ERC20, Ownable {
1263     using SafeMath for uint256;
1264 
1265     IUniswapV2Router02 public immutable uniswapV2Router;
1266     address public immutable uniswapV2Pair;
1267     address public constant deadAddress = address(0xdead);
1268 
1269     bool private swapping;
1270 
1271     address public marketingWallet;
1272 
1273     uint256 public maxTransactionAmount;
1274     uint256 public swapTokensAtAmount;
1275     uint256 public maxWallet;
1276 
1277     uint256 public buyTotalFees;
1278     uint256 private buyMarketingFee;
1279     uint256 private buyLiquidityFee;
1280 
1281     uint256 public sellTotalFees;
1282     uint256 private sellMarketingFee;
1283     uint256 private sellLiquidityFee;
1284 
1285     uint256 private tokensForMarketing;
1286     uint256 private tokensForLiquidity;
1287     uint256 private previousFee;
1288 
1289     mapping(address => bool) private _isExcludedFromFees;
1290     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1291     mapping(address => bool) private automatedMarketMakerPairs;
1292 
1293     event ExcludeFromFees(address indexed account, bool isExcluded);
1294 
1295     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1296 
1297     event marketingWalletUpdated(
1298         address indexed newWallet,
1299         address indexed oldWallet
1300     );
1301 
1302     event SwapAndLiquify(
1303         uint256 tokensSwapped,
1304         uint256 ethReceived,
1305         uint256 tokensIntoLiquidity
1306     );
1307 
1308     constructor() ERC20(unicode"🐸🐵🐶🐱🐰🦊🐔🐧🐦🐤🦅🦉🦇🐺🐗🐴🦄🐝🐻🐼🐨🐯🦁🐮🐷🐽🐛🪱🦋🐌🐞🐜🪰🪲🕷🦂🐢🐍🦎🦣🐘🦛🦏🦮🐕‍🦺🐈🐈‍⬛🐓🦤🦚🦜🦢🦩🕊🐇🦝🦨🦡🦫🦦🦥�", "Memes") {
1309         uniswapV2Router = IUniswapV2Router02(
1310             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1311         );
1312         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1313             address(this),
1314             uniswapV2Router.WETH()
1315         );
1316 
1317         uint256 totalSupply = 777_000_777_000 ether;
1318 
1319         maxTransactionAmount = totalSupply;
1320         maxWallet = totalSupply;
1321         swapTokensAtAmount = (totalSupply * 1) / 1000;
1322 
1323         buyMarketingFee = 1;
1324         buyLiquidityFee = 0;
1325         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1326 
1327         sellMarketingFee = 15;    // will change back to 1 along with ownership renounced
1328         sellLiquidityFee = 0;
1329         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1330         previousFee = sellTotalFees;
1331 
1332         marketingWallet = owner();
1333 
1334         excludeFromFees(owner(), true);
1335         excludeFromFees(address(this), true);
1336         excludeFromFees(deadAddress, true);
1337 
1338         excludeFromMaxTransaction(owner(), true);
1339         excludeFromMaxTransaction(address(this), true);
1340         excludeFromMaxTransaction(deadAddress, true);
1341         excludeFromMaxTransaction(address(uniswapV2Router), true);
1342         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1343 
1344         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1345 
1346         _mint(msg.sender, totalSupply);
1347     }
1348 
1349     receive() external payable {}
1350 
1351     function updateSwapTokensAtAmount(uint256 newAmount)
1352         external
1353         onlyOwner
1354         returns (bool)
1355     {
1356         require(
1357             newAmount >= (totalSupply() * 1) / 100000,
1358             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1359         );
1360         require(
1361             newAmount <= (totalSupply() * 5) / 1000,
1362             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1363         );
1364         swapTokensAtAmount = newAmount;
1365         return true;
1366     }
1367 
1368     function updateMaxWalletAndTxnAmount(
1369         uint256 newTxnNum,
1370         uint256 newMaxWalletNum
1371     ) external onlyOwner {
1372         require(
1373             newTxnNum >= ((totalSupply() * 5) / 1000),
1374             "ERC20: Cannot set maxTxn lower than 0.5%"
1375         );
1376         require(
1377             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1378             "ERC20: Cannot set maxWallet lower than 0.5%"
1379         );
1380         maxWallet = newMaxWalletNum;
1381         maxTransactionAmount = newTxnNum;
1382     }
1383 
1384     function excludeFromMaxTransaction(address updAds, bool isEx)
1385         public
1386         onlyOwner
1387     {
1388         _isExcludedMaxTransactionAmount[updAds] = isEx;
1389     }
1390 
1391     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1392         public
1393         onlyOwner
1394     {
1395         sellMarketingFee = _marketingFee;
1396         sellLiquidityFee = _liquidityFee;
1397         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1398         previousFee = sellTotalFees;
1399         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1400     }
1401 
1402     function excludeFromFees(address account, bool excluded) public onlyOwner {
1403         _isExcludedFromFees[account] = excluded;
1404         emit ExcludeFromFees(account, excluded);
1405     }
1406 
1407     function withdrawStuckETH() public onlyOwner {
1408         bool success;
1409         (success, ) = address(msg.sender).call{value: address(this).balance}(
1410             ""
1411         );
1412     }
1413 
1414     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1415         automatedMarketMakerPairs[pair] = value;
1416 
1417         emit SetAutomatedMarketMakerPair(pair, value);
1418     }
1419 
1420     function isExcludedFromFees(address account) public view returns (bool) {
1421         return _isExcludedFromFees[account];
1422     }
1423 
1424     function _transfer(
1425         address from,
1426         address to,
1427         uint256 amount
1428     ) internal override {
1429         require(from != address(0), "ERC20: transfer from the zero address");
1430         require(to != address(0), "ERC20: transfer to the zero address");
1431 
1432         if (amount == 0) {
1433             super._transfer(from, to, 0);
1434             return;
1435         }
1436 
1437         if (
1438             from != owner() &&
1439             to != owner() &&
1440             to != address(0) &&
1441             to != deadAddress &&
1442             !swapping
1443         ) {
1444             //when buy
1445             if (
1446                 automatedMarketMakerPairs[from] &&
1447                 !_isExcludedMaxTransactionAmount[to]
1448             ) {
1449                 require(
1450                     amount <= maxTransactionAmount,
1451                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1452                 );
1453                 require(
1454                     amount + balanceOf(to) <= maxWallet,
1455                     "ERC20: Max wallet exceeded"
1456                 );
1457             }
1458             //when sell
1459             else if (
1460                 automatedMarketMakerPairs[to] &&
1461                 !_isExcludedMaxTransactionAmount[from]
1462             ) {
1463                 require(
1464                     amount <= maxTransactionAmount,
1465                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1466                 );
1467             } else if (!_isExcludedMaxTransactionAmount[to]) {
1468                 require(
1469                     amount + balanceOf(to) <= maxWallet,
1470                     "ERC20: Max wallet exceeded"
1471                 );
1472             }
1473         }
1474 
1475         uint256 contractTokenBalance = balanceOf(address(this));
1476 
1477         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1478 
1479         if (
1480             canSwap &&
1481             !swapping &&
1482             !automatedMarketMakerPairs[from] &&
1483             !_isExcludedFromFees[from] &&
1484             !_isExcludedFromFees[to]
1485         ) {
1486             swapping = true;
1487 
1488             swapBack();
1489 
1490             swapping = false;
1491         }
1492 
1493         bool takeFee = !swapping;
1494 
1495         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1496             takeFee = false;
1497         }
1498 
1499         uint256 fees = 0;
1500 
1501         if (takeFee) {
1502             // on sell
1503             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1504                 fees = amount.mul(sellTotalFees).div(100);
1505                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1506                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1507             }
1508             // on buy
1509             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1510                 fees = amount.mul(buyTotalFees).div(100);
1511                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1512                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1513             }
1514 
1515             if (fees > 0) {
1516                 super._transfer(from, address(this), fees);
1517             }
1518 
1519             amount -= fees;
1520         }
1521 
1522         super._transfer(from, to, amount);
1523         sellTotalFees = previousFee;
1524     }
1525 
1526     function swapTokensForEth(uint256 tokenAmount) private {
1527         address[] memory path = new address[](2);
1528         path[0] = address(this);
1529         path[1] = uniswapV2Router.WETH();
1530 
1531         _approve(address(this), address(uniswapV2Router), tokenAmount);
1532 
1533         // make the swap
1534         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1535             tokenAmount,
1536             0,
1537             path,
1538             address(this),
1539             block.timestamp
1540         );
1541     }
1542 
1543     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1544         _approve(address(this), address(uniswapV2Router), tokenAmount);
1545 
1546         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1547             address(this),
1548             tokenAmount,
1549             0,
1550             0,
1551             owner(),
1552             block.timestamp
1553         );
1554     }
1555 
1556     function swapBack() private {
1557         uint256 contractBalance = balanceOf(address(this));
1558         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1559         bool success;
1560 
1561         if (contractBalance == 0 || totalTokensToSwap == 0) {
1562             return;
1563         }
1564 
1565         if (contractBalance > swapTokensAtAmount * 20) {
1566             contractBalance = swapTokensAtAmount * 20;
1567         }
1568 
1569         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1570             totalTokensToSwap /
1571             2;
1572         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1573 
1574         uint256 initialETHBalance = address(this).balance;
1575 
1576         swapTokensForEth(amountToSwapForETH);
1577 
1578         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1579 
1580         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1581             totalTokensToSwap
1582         );
1583 
1584         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1585 
1586         tokensForLiquidity = 0;
1587         tokensForMarketing = 0;
1588 
1589         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1590             addLiquidity(liquidityTokens, ethForLiquidity);
1591             emit SwapAndLiquify(
1592                 amountToSwapForETH,
1593                 ethForLiquidity,
1594                 tokensForLiquidity
1595             );
1596         }
1597 
1598         (success, ) = address(marketingWallet).call{value: address(this).balance}(
1599             ""
1600         );
1601     }
1602 }