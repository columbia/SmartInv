1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.21;
4 pragma experimental ABIEncoderV2;
5 
6 /* 
7     https://twitter.com/elonmusk/status/1683877911315599360
8 
9     Stake $XFER to take advantage of Revenue Sharing, and Premium @SpaceBridgeBot services.
10 
11     @SpaceBridgeBot is a Telegram Bot which allows you to trade and bridge transactions across multiple chains anonymously - No Wallet Connection required!
12 
13     TG: https://t.me/SpaceBridgePortal
14     Website: https://www.spacetrader.app
15     Twitter: https://twitter.com/SpaceBridgeBot
16 
17 */
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
20 
21 // pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
44 
45 // pragma solidity ^0.8.0;
46 
47 // import "../utils/Context.sol";
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(
65         address indexed previousOwner,
66         address indexed newOwner
67     );
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         _checkOwner();
81         _;
82     }
83 
84     /**
85      * @dev Returns the address of the current owner.
86      */
87     function owner() public view virtual returns (address) {
88         return _owner;
89     }
90 
91     /**
92      * @dev Throws if the sender is not the owner.
93      */
94     function _checkOwner() internal view virtual {
95         require(owner() == _msgSender(), "Ownable: caller is not the owner");
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby disabling any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public virtual onlyOwner {
106         _transferOwnership(address(0));
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Can only be called by the current owner.
112      */
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(
115             newOwner != address(0),
116             "Ownable: new owner is the zero address"
117         );
118         _transferOwnership(newOwner);
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Internal function without access restriction.
124      */
125     function _transferOwnership(address newOwner) internal virtual {
126         address oldOwner = _owner;
127         _owner = newOwner;
128         emit OwnershipTransferred(oldOwner, newOwner);
129     }
130 }
131 
132 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
133 
134 // pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Interface of the ERC20 standard as defined in the EIP.
138  */
139 interface IERC20 {
140     /**
141      * @dev Emitted when `value` tokens are moved from one account (`from`) to
142      * another (`to`).
143      *
144      * Note that `value` may be zero.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 
148     /**
149      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
150      * a call to {approve}. `value` is the new allowance.
151      */
152     event Approval(
153         address indexed owner,
154         address indexed spender,
155         uint256 value
156     );
157 
158     /**
159      * @dev Returns the amount of tokens in existence.
160      */
161     function totalSupply() external view returns (uint256);
162 
163     /**
164      * @dev Returns the amount of tokens owned by `account`.
165      */
166     function balanceOf(address account) external view returns (uint256);
167 
168     /**
169      * @dev Moves `amount` tokens from the caller's account to `to`.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transfer(address to, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Returns the remaining number of tokens that `spender` will be
179      * allowed to spend on behalf of `owner` through {transferFrom}. This is
180      * zero by default.
181      *
182      * This value changes when {approve} or {transferFrom} are called.
183      */
184     function allowance(address owner, address spender)
185         external
186         view
187         returns (uint256);
188 
189     /**
190      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * IMPORTANT: Beware that changing an allowance with this method brings the risk
195      * that someone may use both the old and the new allowance by unfortunate
196      * transaction ordering. One possible solution to mitigate this race
197      * condition is to first reduce the spender's allowance to 0 and set the
198      * desired value afterwards:
199      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200      *
201      * Emits an {Approval} event.
202      */
203     function approve(address spender, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Moves `amount` tokens from `from` to `to` using the
207      * allowance mechanism. `amount` is then deducted from the caller's
208      * allowance.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(
215         address from,
216         address to,
217         uint256 amount
218     ) external returns (bool);
219 }
220 
221 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
222 
223 // pragma solidity ^0.8.0;
224 
225 // import "../IERC20.sol";
226 
227 /**
228  * @dev Interface for the optional metadata functions from the ERC20 standard.
229  *
230  * _Available since v4.1._
231  */
232 interface IERC20Metadata is IERC20 {
233     /**
234      * @dev Returns the name of the token.
235      */
236     function name() external view returns (string memory);
237 
238     /**
239      * @dev Returns the symbol of the token.
240      */
241     function symbol() external view returns (string memory);
242 
243     /**
244      * @dev Returns the decimals places of the token.
245      */
246     function decimals() external view returns (uint8);
247 }
248 
249 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
250 
251 // pragma solidity ^0.8.0;
252 
253 // import "./IERC20.sol";
254 // import "./extensions/IERC20Metadata.sol";
255 // import "../../utils/Context.sol";
256 
257 /**
258  * @dev Implementation of the {IERC20} interface.
259  *
260  * This implementation is agnostic to the way tokens are created. This means
261  * that a supply mechanism has to be added in a derived contract using {_mint}.
262  * For a generic mechanism see {ERC20PresetMinterPauser}.
263  *
264  * TIP: For a detailed writeup see our guide
265  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
266  * to implement supply mechanisms].
267  *
268  * The default value of {decimals} is 18. To change this, you should override
269  * this function so it returns a different value.
270  *
271  * We have followed general OpenZeppelin Contracts guidelines: functions revert
272  * instead returning `false` on failure. This behavior is nonetheless
273  * conventional and does not conflict with the expectations of ERC20
274  * applications.
275  *
276  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
277  * This allows applications to reconstruct the allowance for all accounts just
278  * by listening to said events. Other implementations of the EIP may not emit
279  * these events, as it isn't required by the specification.
280  *
281  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
282  * functions have been added to mitigate the well-known issues around setting
283  * allowances. See {IERC20-approve}.
284  */
285 contract ERC20 is Context, IERC20, IERC20Metadata {
286     mapping(address => uint256) private _balances;
287 
288     mapping(address => mapping(address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     string private _name;
293     string private _symbol;
294 
295     /**
296      * @dev Sets the values for {name} and {symbol}.
297      *
298      * All two of these values are immutable: they can only be set once during
299      * construction.
300      */
301     constructor(string memory name_, string memory symbol_) {
302         _name = name_;
303         _symbol = symbol_;
304     }
305 
306     /**
307      * @dev Returns the name of the token.
308      */
309     function name() public view virtual override returns (string memory) {
310         return _name;
311     }
312 
313     /**
314      * @dev Returns the symbol of the token, usually a shorter version of the
315      * name.
316      */
317     function symbol() public view virtual override returns (string memory) {
318         return _symbol;
319     }
320 
321     /**
322      * @dev Returns the number of decimals used to get its user representation.
323      * For example, if `decimals` equals `2`, a balance of `505` tokens should
324      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
325      *
326      * Tokens usually opt for a value of 18, imitating the relationship between
327      * Ether and Wei. This is the default value returned by this function, unless
328      * it's overridden.
329      *
330      * NOTE: This information is only used for _display_ purposes: it in
331      * no way affects any of the arithmetic of the contract, including
332      * {IERC20-balanceOf} and {IERC20-transfer}.
333      */
334     function decimals() public view virtual override returns (uint8) {
335         return 18;
336     }
337 
338     /**
339      * @dev See {IERC20-totalSupply}.
340      */
341     function totalSupply() public view virtual override returns (uint256) {
342         return _totalSupply;
343     }
344 
345     /**
346      * @dev See {IERC20-balanceOf}.
347      */
348     function balanceOf(address account)
349         public
350         view
351         virtual
352         override
353         returns (uint256)
354     {
355         return _balances[account];
356     }
357 
358     /**
359      * @dev See {IERC20-transfer}.
360      *
361      * Requirements:
362      *
363      * - `to` cannot be the zero address.
364      * - the caller must have a balance of at least `amount`.
365      */
366     function transfer(address to, uint256 amount)
367         public
368         virtual
369         override
370         returns (bool)
371     {
372         address owner = _msgSender();
373         _transfer(owner, to, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-allowance}.
379      */
380     function allowance(address owner, address spender)
381         public
382         view
383         virtual
384         override
385         returns (uint256)
386     {
387         return _allowances[owner][spender];
388     }
389 
390     /**
391      * @dev See {IERC20-approve}.
392      *
393      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
394      * `transferFrom`. This is semantically equivalent to an infinite approval.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function approve(address spender, uint256 amount)
401         public
402         virtual
403         override
404         returns (bool)
405     {
406         address owner = _msgSender();
407         _approve(owner, spender, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-transferFrom}.
413      *
414      * Emits an {Approval} event indicating the updated allowance. This is not
415      * required by the EIP. See the note at the beginning of {ERC20}.
416      *
417      * NOTE: Does not update the allowance if the current allowance
418      * is the maximum `uint256`.
419      *
420      * Requirements:
421      *
422      * - `from` and `to` cannot be the zero address.
423      * - `from` must have a balance of at least `amount`.
424      * - the caller must have allowance for ``from``'s tokens of at least
425      * `amount`.
426      */
427     function transferFrom(
428         address from,
429         address to,
430         uint256 amount
431     ) public virtual override returns (bool) {
432         address spender = _msgSender();
433         _spendAllowance(from, spender, amount);
434         _transfer(from, to, amount);
435         return true;
436     }
437 
438     /**
439      * @dev Atomically increases the allowance granted to `spender` by the caller.
440      *
441      * This is an alternative to {approve} that can be used as a mitigation for
442      * problems described in {IERC20-approve}.
443      *
444      * Emits an {Approval} event indicating the updated allowance.
445      *
446      * Requirements:
447      *
448      * - `spender` cannot be the zero address.
449      */
450     function increaseAllowance(address spender, uint256 addedValue)
451         public
452         virtual
453         returns (bool)
454     {
455         address owner = _msgSender();
456         _approve(owner, spender, allowance(owner, spender) + addedValue);
457         return true;
458     }
459 
460     /**
461      * @dev Atomically decreases the allowance granted to `spender` by the caller.
462      *
463      * This is an alternative to {approve} that can be used as a mitigation for
464      * problems described in {IERC20-approve}.
465      *
466      * Emits an {Approval} event indicating the updated allowance.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      * - `spender` must have allowance for the caller of at least
472      * `subtractedValue`.
473      */
474     function decreaseAllowance(address spender, uint256 subtractedValue)
475         public
476         virtual
477         returns (bool)
478     {
479         address owner = _msgSender();
480         uint256 currentAllowance = allowance(owner, spender);
481         require(
482             currentAllowance >= subtractedValue,
483             "ERC20: decreased allowance below zero"
484         );
485         unchecked {
486             _approve(owner, spender, currentAllowance - subtractedValue);
487         }
488 
489         return true;
490     }
491 
492     /**
493      * @dev Moves `amount` of tokens from `from` to `to`.
494      *
495      * This internal function is equivalent to {transfer}, and can be used to
496      * e.g. implement automatic token fees, slashing mechanisms, etc.
497      *
498      * Emits a {Transfer} event.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `from` must have a balance of at least `amount`.
505      */
506     function _transfer(
507         address from,
508         address to,
509         uint256 amount
510     ) internal virtual {
511         require(from != address(0), "ERC20: transfer from the zero address");
512         require(to != address(0), "ERC20: transfer to the zero address");
513 
514         _beforeTokenTransfer(from, to, amount);
515 
516         uint256 fromBalance = _balances[from];
517         require(
518             fromBalance >= amount,
519             "ERC20: transfer amount exceeds balance"
520         );
521         unchecked {
522             _balances[from] = fromBalance - amount;
523             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
524             // decrementing then incrementing.
525             _balances[to] += amount;
526         }
527 
528         emit Transfer(from, to, amount);
529 
530         _afterTokenTransfer(from, to, amount);
531     }
532 
533     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
534      * the total supply.
535      *
536      * Emits a {Transfer} event with `from` set to the zero address.
537      *
538      * Requirements:
539      *
540      * - `account` cannot be the zero address.
541      */
542     function _mint(address account, uint256 amount) internal virtual {
543         require(account != address(0), "ERC20: mint to the zero address");
544 
545         _beforeTokenTransfer(address(0), account, amount);
546 
547         _totalSupply += amount;
548         unchecked {
549             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
550             _balances[account] += amount;
551         }
552         emit Transfer(address(0), account, amount);
553 
554         _afterTokenTransfer(address(0), account, amount);
555     }
556 
557     /**
558      * @dev Destroys `amount` tokens from `account`, reducing the
559      * total supply.
560      *
561      * Emits a {Transfer} event with `to` set to the zero address.
562      *
563      * Requirements:
564      *
565      * - `account` cannot be the zero address.
566      * - `account` must have at least `amount` tokens.
567      */
568     function _burn(address account, uint256 amount) internal virtual {
569         require(account != address(0), "ERC20: burn from the zero address");
570 
571         _beforeTokenTransfer(account, address(0), amount);
572 
573         uint256 accountBalance = _balances[account];
574         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
575         unchecked {
576             _balances[account] = accountBalance - amount;
577             // Overflow not possible: amount <= accountBalance <= totalSupply.
578             _totalSupply -= amount;
579         }
580 
581         emit Transfer(account, address(0), amount);
582 
583         _afterTokenTransfer(account, address(0), amount);
584     }
585 
586     /**
587      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
588      *
589      * This internal function is equivalent to `approve`, and can be used to
590      * e.g. set automatic allowances for certain subsystems, etc.
591      *
592      * Emits an {Approval} event.
593      *
594      * Requirements:
595      *
596      * - `owner` cannot be the zero address.
597      * - `spender` cannot be the zero address.
598      */
599     function _approve(
600         address owner,
601         address spender,
602         uint256 amount
603     ) internal virtual {
604         require(owner != address(0), "ERC20: approve from the zero address");
605         require(spender != address(0), "ERC20: approve to the zero address");
606 
607         _allowances[owner][spender] = amount;
608         emit Approval(owner, spender, amount);
609     }
610 
611     /**
612      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
613      *
614      * Does not update the allowance amount in case of infinite allowance.
615      * Revert if not enough allowance is available.
616      *
617      * Might emit an {Approval} event.
618      */
619     function _spendAllowance(
620         address owner,
621         address spender,
622         uint256 amount
623     ) internal virtual {
624         uint256 currentAllowance = allowance(owner, spender);
625         if (currentAllowance != type(uint256).max) {
626             require(
627                 currentAllowance >= amount,
628                 "ERC20: insufficient allowance"
629             );
630             unchecked {
631                 _approve(owner, spender, currentAllowance - amount);
632             }
633         }
634     }
635 
636     /**
637      * @dev Hook that is called before any transfer of tokens. This includes
638      * minting and burning.
639      *
640      * Calling conditions:
641      *
642      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
643      * will be transferred to `to`.
644      * - when `from` is zero, `amount` tokens will be minted for `to`.
645      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
646      * - `from` and `to` are never both zero.
647      *
648      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
649      */
650     function _beforeTokenTransfer(
651         address from,
652         address to,
653         uint256 amount
654     ) internal virtual {}
655 
656     /**
657      * @dev Hook that is called after any transfer of tokens. This includes
658      * minting and burning.
659      *
660      * Calling conditions:
661      *
662      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
663      * has been transferred to `to`.
664      * - when `from` is zero, `amount` tokens have been minted for `to`.
665      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
666      * - `from` and `to` are never both zero.
667      *
668      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
669      */
670     function _afterTokenTransfer(
671         address from,
672         address to,
673         uint256 amount
674     ) internal virtual {}
675 }
676 
677 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
678 
679 // pragma solidity ^0.8.0;
680 
681 // CAUTION
682 // This version of SafeMath should only be used with Solidity 0.8 or later,
683 // because it relies on the compiler's built in overflow checks.
684 
685 /**
686  * @dev Wrappers over Solidity's arithmetic operations.
687  *
688  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
689  * now has built in overflow checking.
690  */
691 library SafeMath {
692     /**
693      * @dev Returns the addition of two unsigned integers, with an overflow flag.
694      *
695      * _Available since v3.4._
696      */
697     function tryAdd(uint256 a, uint256 b)
698         internal
699         pure
700         returns (bool, uint256)
701     {
702         unchecked {
703             uint256 c = a + b;
704             if (c < a) return (false, 0);
705             return (true, c);
706         }
707     }
708 
709     /**
710      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
711      *
712      * _Available since v3.4._
713      */
714     function trySub(uint256 a, uint256 b)
715         internal
716         pure
717         returns (bool, uint256)
718     {
719         unchecked {
720             if (b > a) return (false, 0);
721             return (true, a - b);
722         }
723     }
724 
725     /**
726      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
727      *
728      * _Available since v3.4._
729      */
730     function tryMul(uint256 a, uint256 b)
731         internal
732         pure
733         returns (bool, uint256)
734     {
735         unchecked {
736             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
737             // benefit is lost if 'b' is also tested.
738             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
739             if (a == 0) return (true, 0);
740             uint256 c = a * b;
741             if (c / a != b) return (false, 0);
742             return (true, c);
743         }
744     }
745 
746     /**
747      * @dev Returns the division of two unsigned integers, with a division by zero flag.
748      *
749      * _Available since v3.4._
750      */
751     function tryDiv(uint256 a, uint256 b)
752         internal
753         pure
754         returns (bool, uint256)
755     {
756         unchecked {
757             if (b == 0) return (false, 0);
758             return (true, a / b);
759         }
760     }
761 
762     /**
763      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
764      *
765      * _Available since v3.4._
766      */
767     function tryMod(uint256 a, uint256 b)
768         internal
769         pure
770         returns (bool, uint256)
771     {
772         unchecked {
773             if (b == 0) return (false, 0);
774             return (true, a % b);
775         }
776     }
777 
778     /**
779      * @dev Returns the addition of two unsigned integers, reverting on
780      * overflow.
781      *
782      * Counterpart to Solidity's `+` operator.
783      *
784      * Requirements:
785      *
786      * - Addition cannot overflow.
787      */
788     function add(uint256 a, uint256 b) internal pure returns (uint256) {
789         return a + b;
790     }
791 
792     /**
793      * @dev Returns the subtraction of two unsigned integers, reverting on
794      * overflow (when the result is negative).
795      *
796      * Counterpart to Solidity's `-` operator.
797      *
798      * Requirements:
799      *
800      * - Subtraction cannot overflow.
801      */
802     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
803         return a - b;
804     }
805 
806     /**
807      * @dev Returns the multiplication of two unsigned integers, reverting on
808      * overflow.
809      *
810      * Counterpart to Solidity's `*` operator.
811      *
812      * Requirements:
813      *
814      * - Multiplication cannot overflow.
815      */
816     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
817         return a * b;
818     }
819 
820     /**
821      * @dev Returns the integer division of two unsigned integers, reverting on
822      * division by zero. The result is rounded towards zero.
823      *
824      * Counterpart to Solidity's `/` operator.
825      *
826      * Requirements:
827      *
828      * - The divisor cannot be zero.
829      */
830     function div(uint256 a, uint256 b) internal pure returns (uint256) {
831         return a / b;
832     }
833 
834     /**
835      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
836      * reverting when dividing by zero.
837      *
838      * Counterpart to Solidity's `%` operator. This function uses a `revert`
839      * opcode (which leaves remaining gas untouched) while Solidity uses an
840      * invalid opcode to revert (consuming all remaining gas).
841      *
842      * Requirements:
843      *
844      * - The divisor cannot be zero.
845      */
846     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
847         return a % b;
848     }
849 
850     /**
851      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
852      * overflow (when the result is negative).
853      *
854      * CAUTION: This function is deprecated because it requires allocating memory for the error
855      * message unnecessarily. For custom revert reasons use {trySub}.
856      *
857      * Counterpart to Solidity's `-` operator.
858      *
859      * Requirements:
860      *
861      * - Subtraction cannot overflow.
862      */
863     function sub(
864         uint256 a,
865         uint256 b,
866         string memory errorMessage
867     ) internal pure returns (uint256) {
868         unchecked {
869             require(b <= a, errorMessage);
870             return a - b;
871         }
872     }
873 
874     /**
875      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
876      * division by zero. The result is rounded towards zero.
877      *
878      * Counterpart to Solidity's `/` operator. Note: this function uses a
879      * `revert` opcode (which leaves remaining gas untouched) while Solidity
880      * uses an invalid opcode to revert (consuming all remaining gas).
881      *
882      * Requirements:
883      *
884      * - The divisor cannot be zero.
885      */
886     function div(
887         uint256 a,
888         uint256 b,
889         string memory errorMessage
890     ) internal pure returns (uint256) {
891         unchecked {
892             require(b > 0, errorMessage);
893             return a / b;
894         }
895     }
896 
897     /**
898      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
899      * reverting with custom message when dividing by zero.
900      *
901      * CAUTION: This function is deprecated because it requires allocating memory for the error
902      * message unnecessarily. For custom revert reasons use {tryMod}.
903      *
904      * Counterpart to Solidity's `%` operator. This function uses a `revert`
905      * opcode (which leaves remaining gas untouched) while Solidity uses an
906      * invalid opcode to revert (consuming all remaining gas).
907      *
908      * Requirements:
909      *
910      * - The divisor cannot be zero.
911      */
912     function mod(
913         uint256 a,
914         uint256 b,
915         string memory errorMessage
916     ) internal pure returns (uint256) {
917         unchecked {
918             require(b > 0, errorMessage);
919             return a % b;
920         }
921     }
922 }
923 
924 // pragma solidity >=0.5.0;
925 
926 interface IUniswapV2Factory {
927     event PairCreated(
928         address indexed token0,
929         address indexed token1,
930         address pair,
931         uint256
932     );
933 
934     function feeTo() external view returns (address);
935 
936     function feeToSetter() external view returns (address);
937 
938     function getPair(address tokenA, address tokenB)
939         external
940         view
941         returns (address pair);
942 
943     function allPairs(uint256) external view returns (address pair);
944 
945     function allPairsLength() external view returns (uint256);
946 
947     function createPair(address tokenA, address tokenB)
948         external
949         returns (address pair);
950 
951     function setFeeTo(address) external;
952 
953     function setFeeToSetter(address) external;
954 }
955 
956 // pragma solidity >=0.6.2;
957 
958 interface IUniswapV2Router01 {
959     function factory() external pure returns (address);
960 
961     function WETH() external pure returns (address);
962 
963     function addLiquidity(
964         address tokenA,
965         address tokenB,
966         uint256 amountADesired,
967         uint256 amountBDesired,
968         uint256 amountAMin,
969         uint256 amountBMin,
970         address to,
971         uint256 deadline
972     )
973         external
974         returns (
975             uint256 amountA,
976             uint256 amountB,
977             uint256 liquidity
978         );
979 
980     function addLiquidityETH(
981         address token,
982         uint256 amountTokenDesired,
983         uint256 amountTokenMin,
984         uint256 amountETHMin,
985         address to,
986         uint256 deadline
987     )
988         external
989         payable
990         returns (
991             uint256 amountToken,
992             uint256 amountETH,
993             uint256 liquidity
994         );
995 
996     function removeLiquidity(
997         address tokenA,
998         address tokenB,
999         uint256 liquidity,
1000         uint256 amountAMin,
1001         uint256 amountBMin,
1002         address to,
1003         uint256 deadline
1004     ) external returns (uint256 amountA, uint256 amountB);
1005 
1006     function removeLiquidityETH(
1007         address token,
1008         uint256 liquidity,
1009         uint256 amountTokenMin,
1010         uint256 amountETHMin,
1011         address to,
1012         uint256 deadline
1013     ) external returns (uint256 amountToken, uint256 amountETH);
1014 
1015     function removeLiquidityWithPermit(
1016         address tokenA,
1017         address tokenB,
1018         uint256 liquidity,
1019         uint256 amountAMin,
1020         uint256 amountBMin,
1021         address to,
1022         uint256 deadline,
1023         bool approveMax,
1024         uint8 v,
1025         bytes32 r,
1026         bytes32 s
1027     ) external returns (uint256 amountA, uint256 amountB);
1028 
1029     function removeLiquidityETHWithPermit(
1030         address token,
1031         uint256 liquidity,
1032         uint256 amountTokenMin,
1033         uint256 amountETHMin,
1034         address to,
1035         uint256 deadline,
1036         bool approveMax,
1037         uint8 v,
1038         bytes32 r,
1039         bytes32 s
1040     ) external returns (uint256 amountToken, uint256 amountETH);
1041 
1042     function swapExactTokensForTokens(
1043         uint256 amountIn,
1044         uint256 amountOutMin,
1045         address[] calldata path,
1046         address to,
1047         uint256 deadline
1048     ) external returns (uint256[] memory amounts);
1049 
1050     function swapTokensForExactTokens(
1051         uint256 amountOut,
1052         uint256 amountInMax,
1053         address[] calldata path,
1054         address to,
1055         uint256 deadline
1056     ) external returns (uint256[] memory amounts);
1057 
1058     function swapExactETHForTokens(
1059         uint256 amountOutMin,
1060         address[] calldata path,
1061         address to,
1062         uint256 deadline
1063     ) external payable returns (uint256[] memory amounts);
1064 
1065     function swapTokensForExactETH(
1066         uint256 amountOut,
1067         uint256 amountInMax,
1068         address[] calldata path,
1069         address to,
1070         uint256 deadline
1071     ) external returns (uint256[] memory amounts);
1072 
1073     function swapExactTokensForETH(
1074         uint256 amountIn,
1075         uint256 amountOutMin,
1076         address[] calldata path,
1077         address to,
1078         uint256 deadline
1079     ) external returns (uint256[] memory amounts);
1080 
1081     function swapETHForExactTokens(
1082         uint256 amountOut,
1083         address[] calldata path,
1084         address to,
1085         uint256 deadline
1086     ) external payable returns (uint256[] memory amounts);
1087 
1088     function quote(
1089         uint256 amountA,
1090         uint256 reserveA,
1091         uint256 reserveB
1092     ) external pure returns (uint256 amountB);
1093 
1094     function getAmountOut(
1095         uint256 amountIn,
1096         uint256 reserveIn,
1097         uint256 reserveOut
1098     ) external pure returns (uint256 amountOut);
1099 
1100     function getAmountIn(
1101         uint256 amountOut,
1102         uint256 reserveIn,
1103         uint256 reserveOut
1104     ) external pure returns (uint256 amountIn);
1105 
1106     function getAmountsOut(uint256 amountIn, address[] calldata path)
1107         external
1108         view
1109         returns (uint256[] memory amounts);
1110 
1111     function getAmountsIn(uint256 amountOut, address[] calldata path)
1112         external
1113         view
1114         returns (uint256[] memory amounts);
1115 }
1116 
1117 // pragma solidity >=0.6.2;
1118 
1119 // import './IUniswapV2Router01.sol';
1120 
1121 interface IUniswapV2Router02 is IUniswapV2Router01 {
1122     function removeLiquidityETHSupportingFeeOnTransferTokens(
1123         address token,
1124         uint256 liquidity,
1125         uint256 amountTokenMin,
1126         uint256 amountETHMin,
1127         address to,
1128         uint256 deadline
1129     ) external returns (uint256 amountETH);
1130 
1131     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1132         address token,
1133         uint256 liquidity,
1134         uint256 amountTokenMin,
1135         uint256 amountETHMin,
1136         address to,
1137         uint256 deadline,
1138         bool approveMax,
1139         uint8 v,
1140         bytes32 r,
1141         bytes32 s
1142     ) external returns (uint256 amountETH);
1143 
1144     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1145         uint256 amountIn,
1146         uint256 amountOutMin,
1147         address[] calldata path,
1148         address to,
1149         uint256 deadline
1150     ) external;
1151 
1152     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1153         uint256 amountOutMin,
1154         address[] calldata path,
1155         address to,
1156         uint256 deadline
1157     ) external payable;
1158 
1159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1160         uint256 amountIn,
1161         uint256 amountOutMin,
1162         address[] calldata path,
1163         address to,
1164         uint256 deadline
1165     ) external;
1166 }
1167 
1168 contract XBridgeBot is ERC20, Ownable {
1169     using SafeMath for uint256;
1170 
1171     IUniswapV2Router02 public immutable uniswapV2Router;
1172     address public uniswapV2Pair;
1173     address public constant deadAddress = address(0xdead);
1174 
1175     bool private swapping;
1176 
1177     address public marketingWallet;
1178     address public developmentWallet;
1179     address public liquidityWallet;
1180 
1181     uint256 public maxTransactionAmount;
1182     uint256 public swapTokensAtAmount;
1183     uint256 public maxWallet;
1184 
1185     uint256 private dx;
1186 
1187     uint256 public tradingBlock;
1188 
1189     bool public tradingActive = false;
1190     bool public swapEnabled = false;
1191 
1192     uint256 public buyTotalFees;
1193     uint256 private buyMarketingFee;
1194     uint256 private buyDevelopmentFee;
1195     uint256 private buyLiquidityFee;
1196 
1197     uint256 public sellTotalFees;
1198     uint256 private sellMarketingFee;
1199     uint256 private sellDevelopmentFee;
1200     uint256 private sellLiquidityFee;
1201 
1202     uint256 private tokensForMarketing;
1203     uint256 private tokensForDevelopment;
1204     uint256 private tokensForLiquidity;
1205     uint256 private previousFee;
1206 
1207     mapping(address => bool) private _isExcludedFromFees;
1208     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1209     mapping(address => bool) private automatedMarketMakerPairs;
1210 
1211     event ExcludeFromFees(address indexed account, bool isExcluded);
1212 
1213     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1214 
1215     event marketingWalletUpdated(
1216         address indexed newWallet,
1217         address indexed oldWallet
1218     );
1219 
1220     event developmentWalletUpdated(
1221         address indexed newWallet,
1222         address indexed oldWallet
1223     );
1224 
1225     event liquidityWalletUpdated(
1226         address indexed newWallet,
1227         address indexed oldWallet
1228     );
1229 
1230     event SwapAndLiquify(
1231         uint256 tokensSwapped,
1232         uint256 ethReceived,
1233         uint256 tokensIntoLiquidity
1234     );
1235 
1236     constructor(address _owner) ERC20("X BRIDGE BOT", "XFER") {
1237         uniswapV2Router = IUniswapV2Router02(
1238             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1239         );
1240         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1241 
1242         address spaceMarketing = 0x7B5E8F409878931e080A2ae3c97B6b511Ee27fb2;
1243         uint256 totalSupply = 10_000_000 ether;
1244 
1245         maxTransactionAmount = (totalSupply * 3) / 100;
1246         maxWallet = (totalSupply * 3) / 100;
1247         swapTokensAtAmount = (totalSupply * 5) / 10000;
1248 
1249         buyMarketingFee = 5;
1250         buyDevelopmentFee = 5;
1251         buyLiquidityFee = 0;
1252         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1253 
1254         sellMarketingFee = 5;
1255         sellDevelopmentFee = 5;
1256         sellLiquidityFee = 0;
1257         sellTotalFees =
1258             sellMarketingFee +
1259             sellDevelopmentFee +
1260             sellLiquidityFee;
1261 
1262         previousFee = sellTotalFees;
1263 
1264         marketingWallet = 0x69a4b726862ac748fdAebCCe9888094EdD13F526;
1265         developmentWallet = 0x9e4Dae14eed5194f85281b2dEB1002C572D4F2B2;
1266         liquidityWallet = _owner;
1267 
1268         excludeFromFees(_owner, true);
1269         excludeFromFees(address(this), true);
1270         excludeFromFees(deadAddress, true);
1271         excludeFromFees(marketingWallet, true);
1272         excludeFromFees(developmentWallet, true);
1273         excludeFromFees(liquidityWallet, true);
1274         excludeFromFees(spaceMarketing, true);
1275 
1276         excludeFromMaxTransaction(_owner, true);
1277         excludeFromMaxTransaction(address(this), true);
1278         excludeFromMaxTransaction(deadAddress, true);
1279         excludeFromMaxTransaction(address(uniswapV2Router), true);
1280         excludeFromMaxTransaction(marketingWallet, true);
1281         excludeFromMaxTransaction(developmentWallet, true);
1282         excludeFromMaxTransaction(liquidityWallet, true);
1283         excludeFromMaxTransaction(spaceMarketing, true);
1284 
1285         _mint(spaceMarketing, (totalSupply * 20) / 100);
1286         _mint(address(this), (totalSupply * 80) / 100);
1287 
1288         _transferOwnership(_owner);
1289     }
1290 
1291     receive() external payable {}
1292 
1293     function burn(uint256 amount) external {
1294         _burn(msg.sender, amount);
1295     }
1296 
1297     function XStart(uint256 _dx) external onlyOwner {
1298         require(!tradingActive, "Trading already active.");
1299 
1300         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1301             address(this),
1302             uniswapV2Router.WETH()
1303         );
1304         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1305         IERC20(uniswapV2Pair).approve(
1306             address(uniswapV2Router),
1307             type(uint256).max
1308         );
1309 
1310         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1311         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1312 
1313         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1314             address(this),
1315             balanceOf(address(this)),
1316             0,
1317             0,
1318             owner(),
1319             block.timestamp
1320         );
1321         maxTransactionAmount = (totalSupply() * 2) / 100;
1322         maxWallet = (totalSupply() * 2) / 100;
1323         dx = _dx;
1324         tradingActive = true;
1325         swapEnabled = true;
1326         tradingBlock = block.number;
1327     }
1328 
1329     function XLaunch() external onlyOwner {
1330         maxTransactionAmount = totalSupply();
1331         maxWallet = totalSupply();
1332 
1333         buyMarketingFee = 3;
1334         buyDevelopmentFee = 2;
1335         buyLiquidityFee = 0;
1336         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1337 
1338         sellMarketingFee = 3;
1339         sellDevelopmentFee = 2;
1340         sellLiquidityFee = 0;
1341         sellTotalFees =
1342             sellMarketingFee +
1343             sellDevelopmentFee +
1344             sellLiquidityFee;
1345 
1346         previousFee = sellTotalFees;
1347     }
1348 
1349     function updateSwapTokensAtAmount(uint256 newAmount)
1350         external
1351         onlyOwner
1352         returns (bool)
1353     {
1354         require(
1355             newAmount >= (totalSupply() * 1) / 100000,
1356             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1357         );
1358         require(
1359             newAmount <= (totalSupply() * 5) / 1000,
1360             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1361         );
1362         swapTokensAtAmount = newAmount;
1363         return true;
1364     }
1365 
1366     function updateMaxWalletAndTxnAmount(
1367         uint256 newTxnNum,
1368         uint256 newMaxWalletNum
1369     ) external onlyOwner {
1370         require(
1371             newTxnNum >= ((totalSupply() * 5) / 1000),
1372             "ERC20: Cannot set maxTxn lower than 0.5%"
1373         );
1374         require(
1375             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1376             "ERC20: Cannot set maxWallet lower than 0.5%"
1377         );
1378         maxWallet = newMaxWalletNum;
1379         maxTransactionAmount = newTxnNum;
1380     }
1381 
1382     function excludeFromMaxTransaction(address updAds, bool isEx)
1383         public
1384         onlyOwner
1385     {
1386         _isExcludedMaxTransactionAmount[updAds] = isEx;
1387     }
1388 
1389     function updateBuyFees(
1390         uint256 _marketingFee,
1391         uint256 _developmentFee,
1392         uint256 _liquidityFee
1393     ) external onlyOwner {
1394         buyMarketingFee = _marketingFee;
1395         buyDevelopmentFee = _developmentFee;
1396         buyLiquidityFee = _liquidityFee;
1397         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1398         require(buyTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1399     }
1400 
1401     function updateSellFees(
1402         uint256 _marketingFee,
1403         uint256 _developmentFee,
1404         uint256 _liquidityFee
1405     ) external onlyOwner {
1406         sellMarketingFee = _marketingFee;
1407         sellDevelopmentFee = _developmentFee;
1408         sellLiquidityFee = _liquidityFee;
1409         sellTotalFees =
1410             sellMarketingFee +
1411             sellDevelopmentFee +
1412             sellLiquidityFee;
1413         previousFee = sellTotalFees;
1414         require(sellTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1415     }
1416 
1417     function updateMarketingWallet(address _marketingWallet)
1418         external
1419         onlyOwner
1420     {
1421         require(_marketingWallet != address(0), "ERC20: Address 0");
1422         address oldWallet = marketingWallet;
1423         marketingWallet = _marketingWallet;
1424         emit marketingWalletUpdated(marketingWallet, oldWallet);
1425     }
1426 
1427     function updateDevelopmentWallet(address _developmentWallet)
1428         external
1429         onlyOwner
1430     {
1431         require(_developmentWallet != address(0), "ERC20: Address 0");
1432         address oldWallet = developmentWallet;
1433         developmentWallet = _developmentWallet;
1434         emit developmentWalletUpdated(developmentWallet, oldWallet);
1435     }
1436 
1437     function updateLiquidityWallet(address _liquidityWallet)
1438         external
1439         onlyOwner
1440     {
1441         require(_liquidityWallet != address(0), "ERC20: Address 0");
1442         address oldWallet = liquidityWallet;
1443         liquidityWallet = _liquidityWallet;
1444         emit liquidityWalletUpdated(liquidityWallet, oldWallet);
1445     }
1446 
1447     function excludeFromFees(address account, bool excluded) public onlyOwner {
1448         _isExcludedFromFees[account] = excluded;
1449         emit ExcludeFromFees(account, excluded);
1450     }
1451 
1452     function withdrawStuckETH() public onlyOwner {
1453         bool success;
1454         (success, ) = address(msg.sender).call{value: address(this).balance}(
1455             ""
1456         );
1457     }
1458 
1459     function withdrawStuckTokens(address tk) public onlyOwner {
1460         require(IERC20(tk).balanceOf(address(this)) > 0, "No tokens");
1461         uint256 amount = IERC20(tk).balanceOf(address(this));
1462         IERC20(tk).transfer(msg.sender, amount);
1463     }
1464 
1465     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1466         automatedMarketMakerPairs[pair] = value;
1467 
1468         emit SetAutomatedMarketMakerPair(pair, value);
1469     }
1470 
1471     function isExcludedFromFees(address account) public view returns (bool) {
1472         return _isExcludedFromFees[account];
1473     }
1474 
1475     function _transfer(
1476         address from,
1477         address to,
1478         uint256 amount
1479     ) internal override {
1480         require(from != address(0), "ERC20: transfer from the zero address");
1481         require(to != address(0), "ERC20: transfer to the zero address");
1482 
1483         if (amount == 0) {
1484             super._transfer(from, to, 0);
1485             return;
1486         }
1487 
1488         if (
1489             from != owner() &&
1490             to != owner() &&
1491             to != address(0) &&
1492             to != deadAddress &&
1493             !swapping
1494         ) {
1495             if (!tradingActive) {
1496                 require(
1497                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1498                     "ERC20: Trading is not active."
1499                 );
1500             }
1501 
1502             if (
1503                 block.number <= tradingBlock + 20 && tx.gasprice > block.basefee
1504             ) {
1505                 uint256 _bx = tx.gasprice - block.basefee;
1506                 uint256 _bxd = dx * (10**9);
1507                 require(_bx < _bxd, "Stop");
1508             }
1509 
1510             //when buy
1511             if (
1512                 automatedMarketMakerPairs[from] &&
1513                 !_isExcludedMaxTransactionAmount[to]
1514             ) {
1515                 require(
1516                     amount <= maxTransactionAmount,
1517                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1518                 );
1519                 require(
1520                     amount + balanceOf(to) <= maxWallet,
1521                     "ERC20: Max wallet exceeded"
1522                 );
1523             }
1524             //when sell
1525             else if (
1526                 automatedMarketMakerPairs[to] &&
1527                 !_isExcludedMaxTransactionAmount[from]
1528             ) {
1529                 require(
1530                     amount <= maxTransactionAmount,
1531                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1532                 );
1533             } else if (!_isExcludedMaxTransactionAmount[to]) {
1534                 require(
1535                     amount + balanceOf(to) <= maxWallet,
1536                     "ERC20: Max wallet exceeded"
1537                 );
1538             }
1539         }
1540 
1541         uint256 contractTokenBalance = balanceOf(address(this));
1542 
1543         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1544 
1545         if (
1546             canSwap &&
1547             swapEnabled &&
1548             !swapping &&
1549             !automatedMarketMakerPairs[from] &&
1550             !_isExcludedFromFees[from] &&
1551             !_isExcludedFromFees[to]
1552         ) {
1553             swapping = true;
1554 
1555             swapBack();
1556 
1557             swapping = false;
1558         }
1559 
1560         bool takeFee = !swapping;
1561 
1562         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1563             takeFee = false;
1564         }
1565 
1566         uint256 fees = 0;
1567 
1568         if (takeFee) {
1569             // on sell
1570             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1571                 fees = amount.mul(sellTotalFees).div(100);
1572                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1573                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1574                 tokensForDevelopment +=
1575                     (fees * sellDevelopmentFee) /
1576                     sellTotalFees;
1577             }
1578             // on buy
1579             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1580                 fees = amount.mul(buyTotalFees).div(100);
1581                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1582                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1583                 tokensForDevelopment +=
1584                     (fees * buyDevelopmentFee) /
1585                     buyTotalFees;
1586             }
1587 
1588             if (fees > 0) {
1589                 super._transfer(from, address(this), fees);
1590             }
1591 
1592             amount -= fees;
1593         }
1594 
1595         super._transfer(from, to, amount);
1596         sellTotalFees = previousFee;
1597     }
1598 
1599     function swapTokensForEth(uint256 tokenAmount) private {
1600         address[] memory path = new address[](2);
1601         path[0] = address(this);
1602         path[1] = uniswapV2Router.WETH();
1603 
1604         _approve(address(this), address(uniswapV2Router), tokenAmount);
1605 
1606         // make the swap
1607         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1608             tokenAmount,
1609             0,
1610             path,
1611             address(this),
1612             block.timestamp
1613         );
1614     }
1615 
1616     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1617         _approve(address(this), address(uniswapV2Router), tokenAmount);
1618 
1619         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1620             address(this),
1621             tokenAmount,
1622             0,
1623             0,
1624             liquidityWallet,
1625             block.timestamp
1626         );
1627     }
1628 
1629     function swapBack() private {
1630         uint256 contractBalance = balanceOf(address(this));
1631         uint256 totalTokensToSwap = tokensForLiquidity +
1632             tokensForMarketing +
1633             tokensForDevelopment;
1634         bool success;
1635 
1636         if (contractBalance == 0 || totalTokensToSwap == 0) {
1637             return;
1638         }
1639 
1640         if (contractBalance > swapTokensAtAmount * 20) {
1641             contractBalance = swapTokensAtAmount * 20;
1642         }
1643 
1644         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1645             totalTokensToSwap /
1646             2;
1647         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1648 
1649         uint256 initialETHBalance = address(this).balance;
1650 
1651         swapTokensForEth(amountToSwapForETH);
1652 
1653         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1654 
1655         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1656             totalTokensToSwap
1657         );
1658 
1659         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(
1660             totalTokensToSwap
1661         );
1662 
1663         uint256 ethForLiquidity = ethBalance -
1664             ethForMarketing -
1665             ethForDevelopment;
1666 
1667         tokensForLiquidity = 0;
1668         tokensForMarketing = 0;
1669         tokensForDevelopment = 0;
1670 
1671         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1672             addLiquidity(liquidityTokens, ethForLiquidity);
1673             emit SwapAndLiquify(
1674                 amountToSwapForETH,
1675                 ethForLiquidity,
1676                 tokensForLiquidity
1677             );
1678         }
1679 
1680         (success, ) = address(developmentWallet).call{value: ethForDevelopment}(
1681             ""
1682         );
1683 
1684         (success, ) = address(marketingWallet).call{
1685             value: address(this).balance
1686         }("");
1687     }
1688 }