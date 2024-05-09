1 // SPDX-License-Identifier: MIT
2  
3 pragma solidity 0.8.21;
4 pragma experimental ABIEncoderV2;
5  
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7  
8 // pragma solidity ^0.8.21;
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
32 // pragma solidity ^0.8.21;
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
121 // pragma solidity ^0.8.21;
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
210 // pragma solidity ^0.8.21;
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
238 // pragma solidity ^0.8.21;
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
666 // pragma solidity ^0.8.21;
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
943 // pragma solidity >=0.6.2;
944  
945 interface IUniswapV2Router01 {
946     function factory() external pure returns (address);
947  
948     function WETH() external pure returns (address);
949  
950     function addLiquidity(
951         address tokenA,
952         address tokenB,
953         uint256 amountADesired,
954         uint256 amountBDesired,
955         uint256 amountAMin,
956         uint256 amountBMin,
957         address to,
958         uint256 deadline
959     )
960         external
961         returns (
962             uint256 amountA,
963             uint256 amountB,
964             uint256 liquidity
965         );
966  
967     function addLiquidityETH(
968         address token,
969         uint256 amountTokenDesired,
970         uint256 amountTokenMin,
971         uint256 amountETHMin,
972         address to,
973         uint256 deadline
974     )
975         external
976         payable
977         returns (
978             uint256 amountToken,
979             uint256 amountETH,
980             uint256 liquidity
981         );
982  
983     function removeLiquidity(
984         address tokenA,
985         address tokenB,
986         uint256 liquidity,
987         uint256 amountAMin,
988         uint256 amountBMin,
989         address to,
990         uint256 deadline
991     ) external returns (uint256 amountA, uint256 amountB);
992  
993     function removeLiquidityETH(
994         address token,
995         uint256 liquidity,
996         uint256 amountTokenMin,
997         uint256 amountETHMin,
998         address to,
999         uint256 deadline
1000     ) external returns (uint256 amountToken, uint256 amountETH);
1001  
1002     function removeLiquidityWithPermit(
1003         address tokenA,
1004         address tokenB,
1005         uint256 liquidity,
1006         uint256 amountAMin,
1007         uint256 amountBMin,
1008         address to,
1009         uint256 deadline,
1010         bool approveMax,
1011         uint8 v,
1012         bytes32 r,
1013         bytes32 s
1014     ) external returns (uint256 amountA, uint256 amountB);
1015  
1016     function removeLiquidityETHWithPermit(
1017         address token,
1018         uint256 liquidity,
1019         uint256 amountTokenMin,
1020         uint256 amountETHMin,
1021         address to,
1022         uint256 deadline,
1023         bool approveMax,
1024         uint8 v,
1025         bytes32 r,
1026         bytes32 s
1027     ) external returns (uint256 amountToken, uint256 amountETH);
1028  
1029     function swapExactTokensForTokens(
1030         uint256 amountIn,
1031         uint256 amountOutMin,
1032         address[] calldata path,
1033         address to,
1034         uint256 deadline
1035     ) external returns (uint256[] memory amounts);
1036  
1037     function swapTokensForExactTokens(
1038         uint256 amountOut,
1039         uint256 amountInMax,
1040         address[] calldata path,
1041         address to,
1042         uint256 deadline
1043     ) external returns (uint256[] memory amounts);
1044  
1045     function swapExactETHForTokens(
1046         uint256 amountOutMin,
1047         address[] calldata path,
1048         address to,
1049         uint256 deadline
1050     ) external payable returns (uint256[] memory amounts);
1051  
1052     function swapTokensForExactETH(
1053         uint256 amountOut,
1054         uint256 amountInMax,
1055         address[] calldata path,
1056         address to,
1057         uint256 deadline
1058     ) external returns (uint256[] memory amounts);
1059  
1060     function swapExactTokensForETH(
1061         uint256 amountIn,
1062         uint256 amountOutMin,
1063         address[] calldata path,
1064         address to,
1065         uint256 deadline
1066     ) external returns (uint256[] memory amounts);
1067  
1068     function swapETHForExactTokens(
1069         uint256 amountOut,
1070         address[] calldata path,
1071         address to,
1072         uint256 deadline
1073     ) external payable returns (uint256[] memory amounts);
1074  
1075     function quote(
1076         uint256 amountA,
1077         uint256 reserveA,
1078         uint256 reserveB
1079     ) external pure returns (uint256 amountB);
1080  
1081     function getAmountOut(
1082         uint256 amountIn,
1083         uint256 reserveIn,
1084         uint256 reserveOut
1085     ) external pure returns (uint256 amountOut);
1086  
1087     function getAmountIn(
1088         uint256 amountOut,
1089         uint256 reserveIn,
1090         uint256 reserveOut
1091     ) external pure returns (uint256 amountIn);
1092  
1093     function getAmountsOut(uint256 amountIn, address[] calldata path)
1094         external
1095         view
1096         returns (uint256[] memory amounts);
1097  
1098     function getAmountsIn(uint256 amountOut, address[] calldata path)
1099         external
1100         view
1101         returns (uint256[] memory amounts);
1102 }
1103  
1104 // pragma solidity >=0.6.2;
1105  
1106 // import './IUniswapV2Router01.sol';
1107  
1108 interface IUniswapV2Router02 is IUniswapV2Router01 {
1109     function removeLiquidityETHSupportingFeeOnTransferTokens(
1110         address token,
1111         uint256 liquidity,
1112         uint256 amountTokenMin,
1113         uint256 amountETHMin,
1114         address to,
1115         uint256 deadline
1116     ) external returns (uint256 amountETH);
1117  
1118     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1119         address token,
1120         uint256 liquidity,
1121         uint256 amountTokenMin,
1122         uint256 amountETHMin,
1123         address to,
1124         uint256 deadline,
1125         bool approveMax,
1126         uint8 v,
1127         bytes32 r,
1128         bytes32 s
1129     ) external returns (uint256 amountETH);
1130  
1131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1132         uint256 amountIn,
1133         uint256 amountOutMin,
1134         address[] calldata path,
1135         address to,
1136         uint256 deadline
1137     ) external;
1138  
1139     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1140         uint256 amountOutMin,
1141         address[] calldata path,
1142         address to,
1143         uint256 deadline
1144     ) external payable;
1145  
1146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1147         uint256 amountIn,
1148         uint256 amountOutMin,
1149         address[] calldata path,
1150         address to,
1151         uint256 deadline
1152     ) external;
1153 }
1154  
1155 contract MEMECOIN is ERC20, Ownable {
1156     using SafeMath for uint256;
1157  
1158     IUniswapV2Router02 public immutable uniswapV2Router;
1159     address public uniswapV2Pair;
1160     address public constant deadAddress = address(0xdead);
1161  
1162     bool private swapping;
1163  
1164     address public marketingWallet;
1165     address public developmentWallet;
1166     address public communityWallet;
1167  
1168     uint256 public maxTransactionAmount;
1169     uint256 public swapTokensAtAmount;
1170     uint256 public maxWallet;
1171  
1172     bool public tradingActive = false;
1173     bool public swapEnabled = false;
1174  
1175     uint256 public buyTotalFees;
1176     uint256 private buyMarketingFee;
1177     uint256 private buyDevelopmentFee;
1178     uint256 private buyCommunityFee;
1179  
1180     uint256 public sellTotalFees;
1181     uint256 private sellMarketingFee;
1182     uint256 private sellDevelopmentFee;
1183     uint256 private sellCommunityFee;
1184  
1185     uint256 private tokensForMarketing;
1186     uint256 private tokensForDevelopment;
1187     uint256 private tokensForCommunity;
1188     uint256 private previousFee;
1189  
1190     mapping(address => bool) private _isExcludedFromFees;
1191     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1192     mapping(address => bool) private automatedMarketMakerPairs;
1193  
1194     event ExcludeFromFees(address indexed account, bool isExcluded);
1195  
1196     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1197  
1198     event marketingWalletUpdated(
1199         address indexed newWallet,
1200         address indexed oldWallet
1201     );
1202  
1203     event developmentWalletUpdated(
1204         address indexed newWallet,
1205         address indexed oldWallet
1206     );
1207  
1208     event communityWalletUpdated(
1209         address indexed newWallet,
1210         address indexed oldWallet
1211     );
1212  
1213     constructor() ERC20("Meme Capital", "MC") {
1214         uniswapV2Router = IUniswapV2Router02(
1215             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1216         );
1217         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1218  
1219         uint256 totalSupply = 5_000_000_000 ether;
1220  
1221         maxTransactionAmount = (totalSupply * 2) / 100;
1222         maxWallet = (totalSupply * 2) / 100;
1223         swapTokensAtAmount = (totalSupply * 5) / 10000;
1224 
1225         buyMarketingFee = 1;  // Marketing tax
1226         buyDevelopmentFee = 1;  // Development tax
1227         buyCommunityFee = 1;  // Community tax
1228         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyCommunityFee;
1229  
1230         sellMarketingFee = 1;  // Marketing tax
1231         sellDevelopmentFee = 1;  // Development tax
1232         sellCommunityFee = 1;  // Community tax
1233         sellTotalFees =
1234             sellMarketingFee +
1235             sellDevelopmentFee +
1236             sellCommunityFee;
1237  
1238         previousFee = sellTotalFees;
1239  
1240         marketingWallet = 0x45703BF4BAD2Fd6a3dc6C636088510f12709B06D;
1241         developmentWallet = 0x85FB2B2d91D1A28b4b02E6dFC263e311c9C6fEDe;
1242         communityWallet = 0xd2a90001941A5fd5255A9836ec2f10Ab576f5255;
1243  
1244         excludeFromFees(owner(), true);
1245         excludeFromFees(address(this), true);
1246         excludeFromFees(deadAddress, true);
1247         excludeFromFees(marketingWallet, true);
1248         excludeFromFees(developmentWallet, true);
1249         excludeFromFees(communityWallet, true);
1250  
1251         excludeFromMaxTransaction(owner(), true);
1252         excludeFromMaxTransaction(address(this), true);
1253         excludeFromMaxTransaction(deadAddress, true);
1254         excludeFromMaxTransaction(address(uniswapV2Router), true);
1255         excludeFromMaxTransaction(marketingWallet, true);
1256         excludeFromMaxTransaction(developmentWallet, true);
1257         excludeFromMaxTransaction(communityWallet, true);
1258  
1259         _mint(owner(), totalSupply);
1260     }
1261  
1262     receive() external payable {}
1263  
1264     function burn(uint256 amount) external {
1265         _burn(msg.sender, amount);
1266     }
1267  
1268     function enableTrading() external onlyOwner {
1269         require(!tradingActive, "Trading already active.");
1270  
1271         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1272             address(this),
1273             uniswapV2Router.WETH()
1274         );
1275         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1276         IERC20(uniswapV2Pair).approve(
1277             address(uniswapV2Router),
1278             type(uint256).max
1279         );
1280  
1281         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1282         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1283  
1284         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1285             address(this),
1286             balanceOf(address(this)),
1287             0,
1288             0,
1289             owner(),
1290             block.timestamp
1291         );
1292  
1293         tradingActive = true;
1294         swapEnabled = true;
1295     }
1296  
1297     function updateSwapTokensAtAmount(uint256 newAmount)
1298         external
1299         onlyOwner
1300         returns (bool)
1301     {
1302         require(
1303             newAmount >= (totalSupply() * 1) / 100000,
1304             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1305         );
1306         require(
1307             newAmount <= (totalSupply() * 5) / 1000,
1308             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1309         );
1310         swapTokensAtAmount = newAmount;
1311         return true;
1312     }
1313  
1314     function updateMaxWalletAndTxnAmount(
1315         uint256 newTxnNum,
1316         uint256 newMaxWalletNum
1317     ) external onlyOwner {
1318         require(
1319             newTxnNum >= ((totalSupply() * 5) / 1000),
1320             "ERC20: Cannot set maxTxn lower than 0.5%"
1321         );
1322         require(
1323             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1324             "ERC20: Cannot set maxWallet lower than 0.5%"
1325         );
1326         maxWallet = newMaxWalletNum;
1327         maxTransactionAmount = newTxnNum;
1328     }
1329  
1330     function excludeFromMaxTransaction(address updAds, bool isEx)
1331         public
1332         onlyOwner
1333     {
1334         _isExcludedMaxTransactionAmount[updAds] = isEx;
1335     }
1336  
1337     function updateBuyFees(
1338         uint256 _marketingFee,
1339         uint256 _developmentFee,
1340         uint256 _communityFee
1341     ) external onlyOwner {
1342         buyMarketingFee = _marketingFee;
1343         buyDevelopmentFee = _developmentFee;
1344         buyCommunityFee = _communityFee;
1345         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyCommunityFee;
1346         require(buyTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1347     }
1348  
1349     function updateSellFees(
1350         uint256 _marketingFee,
1351         uint256 _developmentFee,
1352         uint256 _communityFee
1353     ) external onlyOwner {
1354         sellMarketingFee = _marketingFee;
1355         sellDevelopmentFee = _developmentFee;
1356         sellCommunityFee = _communityFee;
1357         sellTotalFees =
1358             sellMarketingFee +
1359             sellDevelopmentFee +
1360             sellCommunityFee;
1361         previousFee = sellTotalFees;
1362         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1363     }
1364  
1365     function updateMarketingWallet(address _marketingWallet)
1366         external
1367         onlyOwner
1368     {
1369         require(_marketingWallet != address(0), "ERC20: Address 0");
1370         address oldWallet = marketingWallet;
1371         marketingWallet = _marketingWallet;
1372         emit marketingWalletUpdated(marketingWallet, oldWallet);
1373     }
1374  
1375     function updateDevelopmentWallet(address _developmentWallet)
1376         external
1377         onlyOwner
1378     {
1379         require(_developmentWallet != address(0), "ERC20: Address 0");
1380         address oldWallet = developmentWallet;
1381         developmentWallet = _developmentWallet;
1382         emit developmentWalletUpdated(developmentWallet, oldWallet);
1383     }
1384  
1385     function updateCommunityWallet(address _communityWallet)
1386         external
1387         onlyOwner
1388     {
1389         require(_communityWallet != address(0), "ERC20: Address 0");
1390         address oldWallet = communityWallet;
1391         communityWallet = _communityWallet;
1392         emit communityWalletUpdated(communityWallet, oldWallet);
1393     }
1394  
1395     function excludeFromFees(address account, bool excluded) public onlyOwner {
1396         _isExcludedFromFees[account] = excluded;
1397         emit ExcludeFromFees(account, excluded);
1398     }
1399  
1400     function withdrawStuckETH() public onlyOwner {
1401         bool success;
1402         (success, ) = address(msg.sender).call{value: address(this).balance}(
1403             ""
1404         );
1405     }
1406  
1407     function withdrawStuckTokens(address tkn) public onlyOwner {
1408         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1409         uint256 amount = IERC20(tkn).balanceOf(address(this));
1410         IERC20(tkn).transfer(msg.sender, amount);
1411     }
1412  
1413     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1414         automatedMarketMakerPairs[pair] = value;
1415  
1416         emit SetAutomatedMarketMakerPair(pair, value);
1417     }
1418  
1419     function isExcludedFromFees(address account) public view returns (bool) {
1420         return _isExcludedFromFees[account];
1421     }
1422  
1423     function _transfer(
1424         address from,
1425         address to,
1426         uint256 amount
1427     ) internal override {
1428         require(from != address(0), "ERC20: transfer from the zero address");
1429         require(to != address(0), "ERC20: transfer to the zero address");
1430  
1431         if (amount == 0) {
1432             super._transfer(from, to, 0);
1433             return;
1434         }
1435  
1436         if (
1437             from != owner() &&
1438             to != owner() &&
1439             to != address(0) &&
1440             to != deadAddress &&
1441             !swapping
1442         ) {
1443             if (!tradingActive) {
1444                 require(
1445                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1446                     "ERC20: Trading is not active."
1447                 );
1448             }
1449  
1450             //when buy
1451             if (
1452                 automatedMarketMakerPairs[from] &&
1453                 !_isExcludedMaxTransactionAmount[to]
1454             ) {
1455                 require(
1456                     amount <= maxTransactionAmount,
1457                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1458                 );
1459                 require(
1460                     amount + balanceOf(to) <= maxWallet,
1461                     "ERC20: Max wallet exceeded"
1462                 );
1463             }
1464             //when sell
1465             else if (
1466                 automatedMarketMakerPairs[to] &&
1467                 !_isExcludedMaxTransactionAmount[from]
1468             ) {
1469                 require(
1470                     amount <= maxTransactionAmount,
1471                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1472                 );
1473             } else if (!_isExcludedMaxTransactionAmount[to]) {
1474                 require(
1475                     amount + balanceOf(to) <= maxWallet,
1476                     "ERC20: Max wallet exceeded"
1477                 );
1478             }
1479         }
1480  
1481         uint256 contractTokenBalance = balanceOf(address(this));
1482  
1483         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1484  
1485         if (
1486             canSwap &&
1487             swapEnabled &&
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
1512                 tokensForCommunity += (fees * sellCommunityFee) / sellTotalFees;
1513                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1514                 tokensForDevelopment +=
1515                     (fees * sellDevelopmentFee) /
1516                     sellTotalFees;
1517             }
1518             // on buy
1519             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1520                 fees = amount.mul(buyTotalFees).div(100);
1521                 tokensForCommunity += (fees * buyCommunityFee) / buyTotalFees;
1522                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1523                 tokensForDevelopment +=
1524                     (fees * buyDevelopmentFee) /
1525                     buyTotalFees;
1526             }
1527  
1528             if (fees > 0) {
1529                 super._transfer(from, address(this), fees);
1530             }
1531  
1532             amount -= fees;
1533         }
1534  
1535         super._transfer(from, to, amount);
1536         sellTotalFees = previousFee;
1537     }
1538  
1539     function swapTokensForEth(uint256 tokenAmount) private {
1540         address[] memory path = new address[](2);
1541         path[0] = address(this);
1542         path[1] = uniswapV2Router.WETH();
1543  
1544         _approve(address(this), address(uniswapV2Router), tokenAmount);
1545  
1546         // make the swap
1547         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1548             tokenAmount,
1549             0,
1550             path,
1551             address(this),
1552             block.timestamp
1553         );
1554     }
1555  
1556     function swapBack() private {
1557         uint256 contractBalance = balanceOf(address(this));
1558         uint256 totalTokensToSwap = tokensForCommunity +
1559             tokensForMarketing +
1560             tokensForDevelopment;
1561         bool success;
1562  
1563         if (contractBalance == 0 || totalTokensToSwap == 0) {
1564             return;
1565         }
1566  
1567         if (contractBalance > swapTokensAtAmount * 20) {
1568             contractBalance = swapTokensAtAmount * 20;
1569         }
1570  
1571         swapTokensForEth(contractBalance);
1572  
1573         uint256 ethBalance = address(this).balance;
1574  
1575         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(
1576             totalTokensToSwap
1577         );
1578  
1579         uint256 ethForCommunity = ethBalance.mul(tokensForCommunity).div(
1580             totalTokensToSwap
1581         );
1582  
1583         tokensForMarketing = 0;
1584         tokensForDevelopment = 0;
1585         tokensForCommunity = 0;
1586  
1587         (success, ) = address(communityWallet).call{value: ethForCommunity}("");
1588  
1589         (success, ) = address(developmentWallet).call{value: ethForDevelopment}(
1590             ""
1591         );
1592  
1593         (success, ) = address(marketingWallet).call{
1594             value: address(this).balance
1595         }("");
1596     }
1597 }