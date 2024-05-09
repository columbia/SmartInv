1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.20;
4 pragma experimental ABIEncoderV2;
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 // pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
31 
32 // pragma solidity ^0.8.0;
33 
34 // import "../utils/Context.sol";
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         _checkOwner();
68         _;
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if the sender is not the owner.
80      */
81     function _checkOwner() internal view virtual {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby disabling any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(
102             newOwner != address(0),
103             "Ownable: new owner is the zero address"
104         );
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
120 
121 // pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126 interface IERC20 {
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(
140         address indexed owner,
141         address indexed spender,
142         uint256 value
143     );
144 
145     /**
146      * @dev Returns the amount of tokens in existence.
147      */
148     function totalSupply() external view returns (uint256);
149 
150     /**
151      * @dev Returns the amount of tokens owned by `account`.
152      */
153     function balanceOf(address account) external view returns (uint256);
154 
155     /**
156      * @dev Moves `amount` tokens from the caller's account to `to`.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transfer(address to, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Returns the remaining number of tokens that `spender` will be
166      * allowed to spend on behalf of `owner` through {transferFrom}. This is
167      * zero by default.
168      *
169      * This value changes when {approve} or {transferFrom} are called.
170      */
171     function allowance(address owner, address spender)
172         external
173         view
174         returns (uint256);
175 
176     /**
177      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * IMPORTANT: Beware that changing an allowance with this method brings the risk
182      * that someone may use both the old and the new allowance by unfortunate
183      * transaction ordering. One possible solution to mitigate this race
184      * condition is to first reduce the spender's allowance to 0 and set the
185      * desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address spender, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Moves `amount` tokens from `from` to `to` using the
194      * allowance mechanism. `amount` is then deducted from the caller's
195      * allowance.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(
202         address from,
203         address to,
204         uint256 amount
205     ) external returns (bool);
206 }
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
209 
210 // pragma solidity ^0.8.0;
211 
212 // import "../IERC20.sol";
213 
214 /**
215  * @dev Interface for the optional metadata functions from the ERC20 standard.
216  *
217  * _Available since v4.1._
218  */
219 interface IERC20Metadata is IERC20 {
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the symbol of the token.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the decimals places of the token.
232      */
233     function decimals() external view returns (uint8);
234 }
235 
236 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
237 
238 // pragma solidity ^0.8.0;
239 
240 // import "./IERC20.sol";
241 // import "./extensions/IERC20Metadata.sol";
242 // import "../../utils/Context.sol";
243 
244 /**
245  * @dev Implementation of the {IERC20} interface.
246  *
247  * This implementation is agnostic to the way tokens are created. This means
248  * that a supply mechanism has to be added in a derived contract using {_mint}.
249  * For a generic mechanism see {ERC20PresetMinterPauser}.
250  *
251  * TIP: For a detailed writeup see our guide
252  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
253  * to implement supply mechanisms].
254  *
255  * The default value of {decimals} is 18. To change this, you should override
256  * this function so it returns a different value.
257  *
258  * We have followed general OpenZeppelin Contracts guidelines: functions revert
259  * instead returning `false` on failure. This behavior is nonetheless
260  * conventional and does not conflict with the expectations of ERC20
261  * applications.
262  *
263  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
264  * This allows applications to reconstruct the allowance for all accounts just
265  * by listening to said events. Other implementations of the EIP may not emit
266  * these events, as it isn't required by the specification.
267  *
268  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
269  * functions have been added to mitigate the well-known issues around setting
270  * allowances. See {IERC20-approve}.
271  */
272 contract ERC20 is Context, IERC20, IERC20Metadata {
273     mapping(address => uint256) private _balances;
274 
275     mapping(address => mapping(address => uint256)) private _allowances;
276 
277     uint256 private _totalSupply;
278 
279     string private _name;
280     string private _symbol;
281 
282     /**
283      * @dev Sets the values for {name} and {symbol}.
284      *
285      * All two of these values are immutable: they can only be set once during
286      * construction.
287      */
288     constructor(string memory name_, string memory symbol_) {
289         _name = name_;
290         _symbol = symbol_;
291     }
292 
293     /**
294      * @dev Returns the name of the token.
295      */
296     function name() public view virtual override returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @dev Returns the symbol of the token, usually a shorter version of the
302      * name.
303      */
304     function symbol() public view virtual override returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @dev Returns the number of decimals used to get its user representation.
310      * For example, if `decimals` equals `2`, a balance of `505` tokens should
311      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
312      *
313      * Tokens usually opt for a value of 18, imitating the relationship between
314      * Ether and Wei. This is the default value returned by this function, unless
315      * it's overridden.
316      *
317      * NOTE: This information is only used for _display_ purposes: it in
318      * no way affects any of the arithmetic of the contract, including
319      * {IERC20-balanceOf} and {IERC20-transfer}.
320      */
321     function decimals() public view virtual override returns (uint8) {
322         return 18;
323     }
324 
325     /**
326      * @dev See {IERC20-totalSupply}.
327      */
328     function totalSupply() public view virtual override returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev See {IERC20-balanceOf}.
334      */
335     function balanceOf(address account)
336         public
337         view
338         virtual
339         override
340         returns (uint256)
341     {
342         return _balances[account];
343     }
344 
345     /**
346      * @dev See {IERC20-transfer}.
347      *
348      * Requirements:
349      *
350      * - `to` cannot be the zero address.
351      * - the caller must have a balance of at least `amount`.
352      */
353     function transfer(address to, uint256 amount)
354         public
355         virtual
356         override
357         returns (bool)
358     {
359         address owner = _msgSender();
360         _transfer(owner, to, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-allowance}.
366      */
367     function allowance(address owner, address spender)
368         public
369         view
370         virtual
371         override
372         returns (uint256)
373     {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
381      * `transferFrom`. This is semantically equivalent to an infinite approval.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function approve(address spender, uint256 amount)
388         public
389         virtual
390         override
391         returns (bool)
392     {
393         address owner = _msgSender();
394         _approve(owner, spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20}.
403      *
404      * NOTE: Does not update the allowance if the current allowance
405      * is the maximum `uint256`.
406      *
407      * Requirements:
408      *
409      * - `from` and `to` cannot be the zero address.
410      * - `from` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``from``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 amount
418     ) public virtual override returns (bool) {
419         address spender = _msgSender();
420         _spendAllowance(from, spender, amount);
421         _transfer(from, to, amount);
422         return true;
423     }
424 
425     /**
426      * @dev Atomically increases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function increaseAllowance(address spender, uint256 addedValue)
438         public
439         virtual
440         returns (bool)
441     {
442         address owner = _msgSender();
443         _approve(owner, spender, allowance(owner, spender) + addedValue);
444         return true;
445     }
446 
447     /**
448      * @dev Atomically decreases the allowance granted to `spender` by the caller.
449      *
450      * This is an alternative to {approve} that can be used as a mitigation for
451      * problems described in {IERC20-approve}.
452      *
453      * Emits an {Approval} event indicating the updated allowance.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      * - `spender` must have allowance for the caller of at least
459      * `subtractedValue`.
460      */
461     function decreaseAllowance(address spender, uint256 subtractedValue)
462         public
463         virtual
464         returns (bool)
465     {
466         address owner = _msgSender();
467         uint256 currentAllowance = allowance(owner, spender);
468         require(
469             currentAllowance >= subtractedValue,
470             "ERC20: decreased allowance below zero"
471         );
472         unchecked {
473             _approve(owner, spender, currentAllowance - subtractedValue);
474         }
475 
476         return true;
477     }
478 
479     /**
480      * @dev Moves `amount` of tokens from `from` to `to`.
481      *
482      * This internal function is equivalent to {transfer}, and can be used to
483      * e.g. implement automatic token fees, slashing mechanisms, etc.
484      *
485      * Emits a {Transfer} event.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `from` must have a balance of at least `amount`.
492      */
493     function _transfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {
498         require(from != address(0), "ERC20: transfer from the zero address");
499         require(to != address(0), "ERC20: transfer to the zero address");
500 
501         _beforeTokenTransfer(from, to, amount);
502 
503         uint256 fromBalance = _balances[from];
504         require(
505             fromBalance >= amount,
506             "ERC20: transfer amount exceeds balance"
507         );
508         unchecked {
509             _balances[from] = fromBalance - amount;
510             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
511             // decrementing then incrementing.
512             _balances[to] += amount;
513         }
514 
515         emit Transfer(from, to, amount);
516 
517         _afterTokenTransfer(from, to, amount);
518     }
519 
520     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
521      * the total supply.
522      *
523      * Emits a {Transfer} event with `from` set to the zero address.
524      *
525      * Requirements:
526      *
527      * - `account` cannot be the zero address.
528      */
529     function _mint(address account, uint256 amount) internal virtual {
530         require(account != address(0), "ERC20: mint to the zero address");
531 
532         _beforeTokenTransfer(address(0), account, amount);
533 
534         _totalSupply += amount;
535         unchecked {
536             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
537             _balances[account] += amount;
538         }
539         emit Transfer(address(0), account, amount);
540 
541         _afterTokenTransfer(address(0), account, amount);
542     }
543 
544     /**
545      * @dev Destroys `amount` tokens from `account`, reducing the
546      * total supply.
547      *
548      * Emits a {Transfer} event with `to` set to the zero address.
549      *
550      * Requirements:
551      *
552      * - `account` cannot be the zero address.
553      * - `account` must have at least `amount` tokens.
554      */
555     function _burn(address account, uint256 amount) internal virtual {
556         require(account != address(0), "ERC20: burn from the zero address");
557 
558         _beforeTokenTransfer(account, address(0), amount);
559 
560         uint256 accountBalance = _balances[account];
561         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
562         unchecked {
563             _balances[account] = accountBalance - amount;
564             // Overflow not possible: amount <= accountBalance <= totalSupply.
565             _totalSupply -= amount;
566         }
567 
568         emit Transfer(account, address(0), amount);
569 
570         _afterTokenTransfer(account, address(0), amount);
571     }
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
575      *
576      * This internal function is equivalent to `approve`, and can be used to
577      * e.g. set automatic allowances for certain subsystems, etc.
578      *
579      * Emits an {Approval} event.
580      *
581      * Requirements:
582      *
583      * - `owner` cannot be the zero address.
584      * - `spender` cannot be the zero address.
585      */
586     function _approve(
587         address owner,
588         address spender,
589         uint256 amount
590     ) internal virtual {
591         require(owner != address(0), "ERC20: approve from the zero address");
592         require(spender != address(0), "ERC20: approve to the zero address");
593 
594         _allowances[owner][spender] = amount;
595         emit Approval(owner, spender, amount);
596     }
597 
598     /**
599      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
600      *
601      * Does not update the allowance amount in case of infinite allowance.
602      * Revert if not enough allowance is available.
603      *
604      * Might emit an {Approval} event.
605      */
606     function _spendAllowance(
607         address owner,
608         address spender,
609         uint256 amount
610     ) internal virtual {
611         uint256 currentAllowance = allowance(owner, spender);
612         if (currentAllowance != type(uint256).max) {
613             require(
614                 currentAllowance >= amount,
615                 "ERC20: insufficient allowance"
616             );
617             unchecked {
618                 _approve(owner, spender, currentAllowance - amount);
619             }
620         }
621     }
622 
623     /**
624      * @dev Hook that is called before any transfer of tokens. This includes
625      * minting and burning.
626      *
627      * Calling conditions:
628      *
629      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
630      * will be transferred to `to`.
631      * - when `from` is zero, `amount` tokens will be minted for `to`.
632      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
633      * - `from` and `to` are never both zero.
634      *
635      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
636      */
637     function _beforeTokenTransfer(
638         address from,
639         address to,
640         uint256 amount
641     ) internal virtual {}
642 
643     /**
644      * @dev Hook that is called after any transfer of tokens. This includes
645      * minting and burning.
646      *
647      * Calling conditions:
648      *
649      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
650      * has been transferred to `to`.
651      * - when `from` is zero, `amount` tokens have been minted for `to`.
652      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
653      * - `from` and `to` are never both zero.
654      *
655      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
656      */
657     function _afterTokenTransfer(
658         address from,
659         address to,
660         uint256 amount
661     ) internal virtual {}
662 }
663 
664 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
665 
666 // pragma solidity ^0.8.0;
667 
668 // CAUTION
669 // This version of SafeMath should only be used with Solidity 0.8 or later,
670 // because it relies on the compiler's built in overflow checks.
671 
672 /**
673  * @dev Wrappers over Solidity's arithmetic operations.
674  *
675  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
676  * now has built in overflow checking.
677  */
678 library SafeMath {
679     /**
680      * @dev Returns the addition of two unsigned integers, with an overflow flag.
681      *
682      * _Available since v3.4._
683      */
684     function tryAdd(uint256 a, uint256 b)
685         internal
686         pure
687         returns (bool, uint256)
688     {
689         unchecked {
690             uint256 c = a + b;
691             if (c < a) return (false, 0);
692             return (true, c);
693         }
694     }
695 
696     /**
697      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
698      *
699      * _Available since v3.4._
700      */
701     function trySub(uint256 a, uint256 b)
702         internal
703         pure
704         returns (bool, uint256)
705     {
706         unchecked {
707             if (b > a) return (false, 0);
708             return (true, a - b);
709         }
710     }
711 
712     /**
713      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
714      *
715      * _Available since v3.4._
716      */
717     function tryMul(uint256 a, uint256 b)
718         internal
719         pure
720         returns (bool, uint256)
721     {
722         unchecked {
723             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
724             // benefit is lost if 'b' is also tested.
725             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
726             if (a == 0) return (true, 0);
727             uint256 c = a * b;
728             if (c / a != b) return (false, 0);
729             return (true, c);
730         }
731     }
732 
733     /**
734      * @dev Returns the division of two unsigned integers, with a division by zero flag.
735      *
736      * _Available since v3.4._
737      */
738     function tryDiv(uint256 a, uint256 b)
739         internal
740         pure
741         returns (bool, uint256)
742     {
743         unchecked {
744             if (b == 0) return (false, 0);
745             return (true, a / b);
746         }
747     }
748 
749     /**
750      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
751      *
752      * _Available since v3.4._
753      */
754     function tryMod(uint256 a, uint256 b)
755         internal
756         pure
757         returns (bool, uint256)
758     {
759         unchecked {
760             if (b == 0) return (false, 0);
761             return (true, a % b);
762         }
763     }
764 
765     /**
766      * @dev Returns the addition of two unsigned integers, reverting on
767      * overflow.
768      *
769      * Counterpart to Solidity's `+` operator.
770      *
771      * Requirements:
772      *
773      * - Addition cannot overflow.
774      */
775     function add(uint256 a, uint256 b) internal pure returns (uint256) {
776         return a + b;
777     }
778 
779     /**
780      * @dev Returns the subtraction of two unsigned integers, reverting on
781      * overflow (when the result is negative).
782      *
783      * Counterpart to Solidity's `-` operator.
784      *
785      * Requirements:
786      *
787      * - Subtraction cannot overflow.
788      */
789     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
790         return a - b;
791     }
792 
793     /**
794      * @dev Returns the multiplication of two unsigned integers, reverting on
795      * overflow.
796      *
797      * Counterpart to Solidity's `*` operator.
798      *
799      * Requirements:
800      *
801      * - Multiplication cannot overflow.
802      */
803     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
804         return a * b;
805     }
806 
807     /**
808      * @dev Returns the integer division of two unsigned integers, reverting on
809      * division by zero. The result is rounded towards zero.
810      *
811      * Counterpart to Solidity's `/` operator.
812      *
813      * Requirements:
814      *
815      * - The divisor cannot be zero.
816      */
817     function div(uint256 a, uint256 b) internal pure returns (uint256) {
818         return a / b;
819     }
820 
821     /**
822      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
823      * reverting when dividing by zero.
824      *
825      * Counterpart to Solidity's `%` operator. This function uses a `revert`
826      * opcode (which leaves remaining gas untouched) while Solidity uses an
827      * invalid opcode to revert (consuming all remaining gas).
828      *
829      * Requirements:
830      *
831      * - The divisor cannot be zero.
832      */
833     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
834         return a % b;
835     }
836 
837     /**
838      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
839      * overflow (when the result is negative).
840      *
841      * CAUTION: This function is deprecated because it requires allocating memory for the error
842      * message unnecessarily. For custom revert reasons use {trySub}.
843      *
844      * Counterpart to Solidity's `-` operator.
845      *
846      * Requirements:
847      *
848      * - Subtraction cannot overflow.
849      */
850     function sub(
851         uint256 a,
852         uint256 b,
853         string memory errorMessage
854     ) internal pure returns (uint256) {
855         unchecked {
856             require(b <= a, errorMessage);
857             return a - b;
858         }
859     }
860 
861     /**
862      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
863      * division by zero. The result is rounded towards zero.
864      *
865      * Counterpart to Solidity's `/` operator. Note: this function uses a
866      * `revert` opcode (which leaves remaining gas untouched) while Solidity
867      * uses an invalid opcode to revert (consuming all remaining gas).
868      *
869      * Requirements:
870      *
871      * - The divisor cannot be zero.
872      */
873     function div(
874         uint256 a,
875         uint256 b,
876         string memory errorMessage
877     ) internal pure returns (uint256) {
878         unchecked {
879             require(b > 0, errorMessage);
880             return a / b;
881         }
882     }
883 
884     /**
885      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
886      * reverting with custom message when dividing by zero.
887      *
888      * CAUTION: This function is deprecated because it requires allocating memory for the error
889      * message unnecessarily. For custom revert reasons use {tryMod}.
890      *
891      * Counterpart to Solidity's `%` operator. This function uses a `revert`
892      * opcode (which leaves remaining gas untouched) while Solidity uses an
893      * invalid opcode to revert (consuming all remaining gas).
894      *
895      * Requirements:
896      *
897      * - The divisor cannot be zero.
898      */
899     function mod(
900         uint256 a,
901         uint256 b,
902         string memory errorMessage
903     ) internal pure returns (uint256) {
904         unchecked {
905             require(b > 0, errorMessage);
906             return a % b;
907         }
908     }
909 }
910 
911 // pragma solidity >=0.5.0;
912 
913 interface IUniswapV2Factory {
914     event PairCreated(
915         address indexed token0,
916         address indexed token1,
917         address pair,
918         uint256
919     );
920 
921     function feeTo() external view returns (address);
922 
923     function feeToSetter() external view returns (address);
924 
925     function getPair(address tokenA, address tokenB)
926         external
927         view
928         returns (address pair);
929 
930     function allPairs(uint256) external view returns (address pair);
931 
932     function allPairsLength() external view returns (uint256);
933 
934     function createPair(address tokenA, address tokenB)
935         external
936         returns (address pair);
937 
938     function setFeeTo(address) external;
939 
940     function setFeeToSetter(address) external;
941 }
942 
943 // pragma solidity >=0.5.0;
944 
945 interface IUniswapV2Pair {
946     event Approval(
947         address indexed owner,
948         address indexed spender,
949         uint256 value
950     );
951     event Transfer(address indexed from, address indexed to, uint256 value);
952 
953     function name() external pure returns (string memory);
954 
955     function symbol() external pure returns (string memory);
956 
957     function decimals() external pure returns (uint8);
958 
959     function totalSupply() external view returns (uint256);
960 
961     function balanceOf(address owner) external view returns (uint256);
962 
963     function allowance(address owner, address spender)
964         external
965         view
966         returns (uint256);
967 
968     function approve(address spender, uint256 value) external returns (bool);
969 
970     function transfer(address to, uint256 value) external returns (bool);
971 
972     function transferFrom(
973         address from,
974         address to,
975         uint256 value
976     ) external returns (bool);
977 
978     function DOMAIN_SEPARATOR() external view returns (bytes32);
979 
980     function PERMIT_TYPEHASH() external pure returns (bytes32);
981 
982     function nonces(address owner) external view returns (uint256);
983 
984     function permit(
985         address owner,
986         address spender,
987         uint256 value,
988         uint256 deadline,
989         uint8 v,
990         bytes32 r,
991         bytes32 s
992     ) external;
993 
994     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
995     event Burn(
996         address indexed sender,
997         uint256 amount0,
998         uint256 amount1,
999         address indexed to
1000     );
1001     event Swap(
1002         address indexed sender,
1003         uint256 amount0In,
1004         uint256 amount1In,
1005         uint256 amount0Out,
1006         uint256 amount1Out,
1007         address indexed to
1008     );
1009     event Sync(uint112 reserve0, uint112 reserve1);
1010 
1011     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1012 
1013     function factory() external view returns (address);
1014 
1015     function token0() external view returns (address);
1016 
1017     function token1() external view returns (address);
1018 
1019     function getReserves()
1020         external
1021         view
1022         returns (
1023             uint112 reserve0,
1024             uint112 reserve1,
1025             uint32 blockTimestampLast
1026         );
1027 
1028     function price0CumulativeLast() external view returns (uint256);
1029 
1030     function price1CumulativeLast() external view returns (uint256);
1031 
1032     function kLast() external view returns (uint256);
1033 
1034     function mint(address to) external returns (uint256 liquidity);
1035 
1036     function burn(address to)
1037         external
1038         returns (uint256 amount0, uint256 amount1);
1039 
1040     function swap(
1041         uint256 amount0Out,
1042         uint256 amount1Out,
1043         address to,
1044         bytes calldata data
1045     ) external;
1046 
1047     function skim(address to) external;
1048 
1049     function sync() external;
1050 
1051     function initialize(address, address) external;
1052 }
1053 
1054 // pragma solidity >=0.6.2;
1055 
1056 interface IUniswapV2Router01 {
1057     function factory() external pure returns (address);
1058 
1059     function WETH() external pure returns (address);
1060 
1061     function addLiquidity(
1062         address tokenA,
1063         address tokenB,
1064         uint256 amountADesired,
1065         uint256 amountBDesired,
1066         uint256 amountAMin,
1067         uint256 amountBMin,
1068         address to,
1069         uint256 deadline
1070     )
1071         external
1072         returns (
1073             uint256 amountA,
1074             uint256 amountB,
1075             uint256 liquidity
1076         );
1077 
1078     function addLiquidityETH(
1079         address token,
1080         uint256 amountTokenDesired,
1081         uint256 amountTokenMin,
1082         uint256 amountETHMin,
1083         address to,
1084         uint256 deadline
1085     )
1086         external
1087         payable
1088         returns (
1089             uint256 amountToken,
1090             uint256 amountETH,
1091             uint256 liquidity
1092         );
1093 
1094     function removeLiquidity(
1095         address tokenA,
1096         address tokenB,
1097         uint256 liquidity,
1098         uint256 amountAMin,
1099         uint256 amountBMin,
1100         address to,
1101         uint256 deadline
1102     ) external returns (uint256 amountA, uint256 amountB);
1103 
1104     function removeLiquidityETH(
1105         address token,
1106         uint256 liquidity,
1107         uint256 amountTokenMin,
1108         uint256 amountETHMin,
1109         address to,
1110         uint256 deadline
1111     ) external returns (uint256 amountToken, uint256 amountETH);
1112 
1113     function removeLiquidityWithPermit(
1114         address tokenA,
1115         address tokenB,
1116         uint256 liquidity,
1117         uint256 amountAMin,
1118         uint256 amountBMin,
1119         address to,
1120         uint256 deadline,
1121         bool approveMax,
1122         uint8 v,
1123         bytes32 r,
1124         bytes32 s
1125     ) external returns (uint256 amountA, uint256 amountB);
1126 
1127     function removeLiquidityETHWithPermit(
1128         address token,
1129         uint256 liquidity,
1130         uint256 amountTokenMin,
1131         uint256 amountETHMin,
1132         address to,
1133         uint256 deadline,
1134         bool approveMax,
1135         uint8 v,
1136         bytes32 r,
1137         bytes32 s
1138     ) external returns (uint256 amountToken, uint256 amountETH);
1139 
1140     function swapExactTokensForTokens(
1141         uint256 amountIn,
1142         uint256 amountOutMin,
1143         address[] calldata path,
1144         address to,
1145         uint256 deadline
1146     ) external returns (uint256[] memory amounts);
1147 
1148     function swapTokensForExactTokens(
1149         uint256 amountOut,
1150         uint256 amountInMax,
1151         address[] calldata path,
1152         address to,
1153         uint256 deadline
1154     ) external returns (uint256[] memory amounts);
1155 
1156     function swapExactETHForTokens(
1157         uint256 amountOutMin,
1158         address[] calldata path,
1159         address to,
1160         uint256 deadline
1161     ) external payable returns (uint256[] memory amounts);
1162 
1163     function swapTokensForExactETH(
1164         uint256 amountOut,
1165         uint256 amountInMax,
1166         address[] calldata path,
1167         address to,
1168         uint256 deadline
1169     ) external returns (uint256[] memory amounts);
1170 
1171     function swapExactTokensForETH(
1172         uint256 amountIn,
1173         uint256 amountOutMin,
1174         address[] calldata path,
1175         address to,
1176         uint256 deadline
1177     ) external returns (uint256[] memory amounts);
1178 
1179     function swapETHForExactTokens(
1180         uint256 amountOut,
1181         address[] calldata path,
1182         address to,
1183         uint256 deadline
1184     ) external payable returns (uint256[] memory amounts);
1185 
1186     function quote(
1187         uint256 amountA,
1188         uint256 reserveA,
1189         uint256 reserveB
1190     ) external pure returns (uint256 amountB);
1191 
1192     function getAmountOut(
1193         uint256 amountIn,
1194         uint256 reserveIn,
1195         uint256 reserveOut
1196     ) external pure returns (uint256 amountOut);
1197 
1198     function getAmountIn(
1199         uint256 amountOut,
1200         uint256 reserveIn,
1201         uint256 reserveOut
1202     ) external pure returns (uint256 amountIn);
1203 
1204     function getAmountsOut(uint256 amountIn, address[] calldata path)
1205         external
1206         view
1207         returns (uint256[] memory amounts);
1208 
1209     function getAmountsIn(uint256 amountOut, address[] calldata path)
1210         external
1211         view
1212         returns (uint256[] memory amounts);
1213 }
1214 
1215 // pragma solidity >=0.6.2;
1216 
1217 // import './IUniswapV2Router01.sol';
1218 
1219 interface IUniswapV2Router02 is IUniswapV2Router01 {
1220     function removeLiquidityETHSupportingFeeOnTransferTokens(
1221         address token,
1222         uint256 liquidity,
1223         uint256 amountTokenMin,
1224         uint256 amountETHMin,
1225         address to,
1226         uint256 deadline
1227     ) external returns (uint256 amountETH);
1228 
1229     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1230         address token,
1231         uint256 liquidity,
1232         uint256 amountTokenMin,
1233         uint256 amountETHMin,
1234         address to,
1235         uint256 deadline,
1236         bool approveMax,
1237         uint8 v,
1238         bytes32 r,
1239         bytes32 s
1240     ) external returns (uint256 amountETH);
1241 
1242     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1243         uint256 amountIn,
1244         uint256 amountOutMin,
1245         address[] calldata path,
1246         address to,
1247         uint256 deadline
1248     ) external;
1249 
1250     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1251         uint256 amountOutMin,
1252         address[] calldata path,
1253         address to,
1254         uint256 deadline
1255     ) external payable;
1256 
1257     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1258         uint256 amountIn,
1259         uint256 amountOutMin,
1260         address[] calldata path,
1261         address to,
1262         uint256 deadline
1263     ) external;
1264 }
1265 
1266 contract SHALOM is ERC20, Ownable {
1267     using SafeMath for uint256;
1268 
1269     IUniswapV2Router02 public immutable uniswapV2Router;
1270     address public immutable uniswapV2Pair;
1271     address public constant deadAddress = address(0xdead);
1272 
1273     bool private swapping;
1274 
1275     address public marketingWallet;
1276 
1277     uint256 public maxTransactionAmount;
1278     uint256 public swapTokensAtAmount;
1279     uint256 public maxWallet;
1280 
1281     bool public tradingActive = false;
1282     bool public swapEnabled = false;
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
1315     constructor() ERC20("SHALOM", "SHLM") {
1316         uniswapV2Router = IUniswapV2Router02(
1317             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1318         );
1319         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1320             address(this),
1321             uniswapV2Router.WETH()
1322         );
1323 
1324         uint256 totalSupply = 1_000_000_000 ether;
1325 
1326         maxTransactionAmount = (totalSupply * 2) / 100;
1327         maxWallet = (totalSupply * 2) / 100;
1328         swapTokensAtAmount = (totalSupply * 1) / 1000;
1329 
1330         buyMarketingFee = 3;
1331         buyLiquidityFee = 0;
1332         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1333 
1334         sellMarketingFee = 3;
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
1358     function enableTrading() external onlyOwner {
1359         tradingActive = true;
1360         swapEnabled = true;
1361     }
1362 
1363     function updateSwapTokensAtAmount(uint256 newAmount)
1364         external
1365         onlyOwner
1366         returns (bool)
1367     {
1368         require(
1369             newAmount >= (totalSupply() * 1) / 100000,
1370             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1371         );
1372         require(
1373             newAmount <= (totalSupply() * 5) / 1000,
1374             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1375         );
1376         swapTokensAtAmount = newAmount;
1377         return true;
1378     }
1379 
1380     function updateMaxWalletAndTxnAmount(
1381         uint256 newTxnNum,
1382         uint256 newMaxWalletNum
1383     ) external onlyOwner {
1384         require(
1385             newTxnNum >= ((totalSupply() * 5) / 1000),
1386             "ERC20: Cannot set maxTxn lower than 0.5%"
1387         );
1388         require(
1389             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1390             "ERC20: Cannot set maxWallet lower than 0.5%"
1391         );
1392         maxWallet = newMaxWalletNum;
1393         maxTransactionAmount = newTxnNum;
1394     }
1395 
1396     function excludeFromMaxTransaction(address updAds, bool isEx)
1397         public
1398         onlyOwner
1399     {
1400         _isExcludedMaxTransactionAmount[updAds] = isEx;
1401     }
1402 
1403     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1404         external
1405         onlyOwner
1406     {
1407         buyMarketingFee = _marketingFee;
1408         buyLiquidityFee = _liquidityFee;
1409         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1410         require(buyTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1411     }
1412 
1413     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1414         external
1415         onlyOwner
1416     {
1417         sellMarketingFee = _marketingFee;
1418         sellLiquidityFee = _liquidityFee;
1419         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1420         previousFee = sellTotalFees;
1421         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1422     }
1423 
1424     function updateMarketingWallet(address _marketingWallet)
1425         external
1426         onlyOwner
1427     {
1428         require(_marketingWallet != address(0), "ERC20: Address 0");
1429         address oldWallet = marketingWallet;
1430         marketingWallet = _marketingWallet;
1431         emit marketingWalletUpdated(marketingWallet, oldWallet);
1432     }
1433 
1434     function excludeFromFees(address account, bool excluded) public onlyOwner {
1435         _isExcludedFromFees[account] = excluded;
1436         emit ExcludeFromFees(account, excluded);
1437     }
1438 
1439     function withdrawStuckETH() public onlyOwner {
1440         bool success;
1441         (success, ) = address(msg.sender).call{value: address(this).balance}(
1442             ""
1443         );
1444     }
1445 
1446     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1447         automatedMarketMakerPairs[pair] = value;
1448 
1449         emit SetAutomatedMarketMakerPair(pair, value);
1450     }
1451 
1452     function isExcludedFromFees(address account) public view returns (bool) {
1453         return _isExcludedFromFees[account];
1454     }
1455 
1456     function _transfer(
1457         address from,
1458         address to,
1459         uint256 amount
1460     ) internal override {
1461         require(from != address(0), "ERC20: transfer from the zero address");
1462         require(to != address(0), "ERC20: transfer to the zero address");
1463 
1464         if (amount == 0) {
1465             super._transfer(from, to, 0);
1466             return;
1467         }
1468 
1469         if (
1470             from != owner() &&
1471             to != owner() &&
1472             to != address(0) &&
1473             to != deadAddress &&
1474             !swapping
1475         ) {
1476             if (!tradingActive) {
1477                 require(
1478                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1479                     "ERC20: Trading is not active."
1480                 );
1481             }
1482 
1483             //when buy
1484             if (
1485                 automatedMarketMakerPairs[from] &&
1486                 !_isExcludedMaxTransactionAmount[to]
1487             ) {
1488                 require(
1489                     amount <= maxTransactionAmount,
1490                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1491                 );
1492                 require(
1493                     amount + balanceOf(to) <= maxWallet,
1494                     "ERC20: Max wallet exceeded"
1495                 );
1496             }
1497             //when sell
1498             else if (
1499                 automatedMarketMakerPairs[to] &&
1500                 !_isExcludedMaxTransactionAmount[from]
1501             ) {
1502                 require(
1503                     amount <= maxTransactionAmount,
1504                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1505                 );
1506             } else if (!_isExcludedMaxTransactionAmount[to]) {
1507                 require(
1508                     amount + balanceOf(to) <= maxWallet,
1509                     "ERC20: Max wallet exceeded"
1510                 );
1511             }
1512         }
1513 
1514         uint256 contractTokenBalance = balanceOf(address(this));
1515 
1516         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1517 
1518         if (
1519             canSwap &&
1520             swapEnabled &&
1521             !swapping &&
1522             !automatedMarketMakerPairs[from] &&
1523             !_isExcludedFromFees[from] &&
1524             !_isExcludedFromFees[to]
1525         ) {
1526             swapping = true;
1527 
1528             swapBack();
1529 
1530             swapping = false;
1531         }
1532 
1533         bool takeFee = !swapping;
1534 
1535         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1536             takeFee = false;
1537         }
1538 
1539         uint256 fees = 0;
1540 
1541         if (takeFee) {
1542             // on sell
1543             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1544                 fees = amount.mul(sellTotalFees).div(100);
1545                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1546                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1547             }
1548             // on buy
1549             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1550                 fees = amount.mul(buyTotalFees).div(100);
1551                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1552                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1553             }
1554 
1555             if (fees > 0) {
1556                 super._transfer(from, address(this), fees);
1557             }
1558 
1559             amount -= fees;
1560         }
1561 
1562         super._transfer(from, to, amount);
1563         sellTotalFees = previousFee;
1564     }
1565 
1566     function swapTokensForEth(uint256 tokenAmount) private {
1567         address[] memory path = new address[](2);
1568         path[0] = address(this);
1569         path[1] = uniswapV2Router.WETH();
1570 
1571         _approve(address(this), address(uniswapV2Router), tokenAmount);
1572 
1573         // make the swap
1574         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1575             tokenAmount,
1576             0,
1577             path,
1578             address(this),
1579             block.timestamp
1580         );
1581     }
1582 
1583     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1584         _approve(address(this), address(uniswapV2Router), tokenAmount);
1585 
1586         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1587             address(this),
1588             tokenAmount,
1589             0,
1590             0,
1591             owner(),
1592             block.timestamp
1593         );
1594     }
1595 
1596     function swapBack() private {
1597         uint256 contractBalance = balanceOf(address(this));
1598         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1599         bool success;
1600 
1601         if (contractBalance == 0 || totalTokensToSwap == 0) {
1602             return;
1603         }
1604 
1605         if (contractBalance > swapTokensAtAmount * 20) {
1606             contractBalance = swapTokensAtAmount * 20;
1607         }
1608 
1609         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1610             totalTokensToSwap /
1611             2;
1612         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1613 
1614         uint256 initialETHBalance = address(this).balance;
1615 
1616         swapTokensForEth(amountToSwapForETH);
1617 
1618         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1619 
1620         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1621             totalTokensToSwap
1622         );
1623 
1624         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1625 
1626         tokensForLiquidity = 0;
1627         tokensForMarketing = 0;
1628 
1629         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1630             addLiquidity(liquidityTokens, ethForLiquidity);
1631             emit SwapAndLiquify(
1632                 amountToSwapForETH,
1633                 ethForLiquidity,
1634                 tokensForLiquidity
1635             );
1636         }
1637 
1638         (success, ) = address(marketingWallet).call{value: address(this).balance}(
1639             ""
1640         );
1641     }
1642 }