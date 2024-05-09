1 /**
2  *Submitted for verification at EtherScan.com on 2021-06-20
3 */
4 
5 /**
6  *
7  *
8    Contract features:
9    3% buy tax in tokens burned
10    10% sell tax in ETH sent to marketing w/ some sent to founder & lead dev
11  */
12 
13 // SPDX-License-Identifier: MIT
14  
15 pragma solidity 0.8.17;
16 pragma experimental ABIEncoderV2;
17  
18 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
19  
20 // pragma solidity ^0.8.0;
21  
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36  
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41  
42 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
43  
44 // pragma solidity ^0.8.0;
45  
46 // import "../utils/Context.sol";
47  
48 /**
49  * @dev Contract module which provides a basic access control mechanism, where
50  * there is an account (an owner) that can be granted exclusive access to
51  * specific functions.
52  *
53  * By default, the owner account will be the one that deploys the contract. This
54  * can later be changed with {transferOwnership}.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 abstract contract Ownable is Context {
61     address private _owner;
62  
63     event OwnershipTransferred(
64         address indexed previousOwner,
65         address indexed newOwner
66     );
67  
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74  
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         _checkOwner();
80         _;
81     }
82  
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view virtual returns (address) {
87         return _owner;
88     }
89  
90     /**
91      * @dev Throws if the sender is not the owner.
92      */
93     function _checkOwner() internal view virtual {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95     }
96  
97     /**
98      * @dev Leaves the contract without owner. It will not be possible to call
99      * `onlyOwner` functions. Can only be called by the current owner.
100      *
101      * NOTE: Renouncing ownership will leave the contract without an owner,
102      * thereby disabling any functionality that is only available to the owner.
103      */
104     function renounceOwnership() public virtual onlyOwner {
105         _transferOwnership(address(0));
106     }
107  
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Can only be called by the current owner.
111      */
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(
114             newOwner != address(0),
115             "Ownable: new owner is the zero address"
116         );
117         _transferOwnership(newOwner);
118     }
119  
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Internal function without access restriction.
123      */
124     function _transferOwnership(address newOwner) internal virtual {
125         address oldOwner = _owner;
126         _owner = newOwner;
127         emit OwnershipTransferred(oldOwner, newOwner);
128     }
129 }
130  
131 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
132  
133 // pragma solidity ^0.8.0;
134  
135 /**
136  * @dev Interface of the ERC20 standard as defined in the EIP.
137  */
138 interface IERC20 {
139     /**
140      * @dev Emitted when `value` tokens are moved from one account (`from`) to
141      * another (`to`).
142      *
143      * Note that `value` may be zero.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 value);
146  
147     /**
148      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
149      * a call to {approve}. `value` is the new allowance.
150      */
151     event Approval(
152         address indexed owner,
153         address indexed spender,
154         uint256 value
155     );
156  
157     /**
158      * @dev Returns the amount of tokens in existence.
159      */
160     function totalSupply() external view returns (uint256);
161  
162     /**
163      * @dev Returns the amount of tokens owned by `account`.
164      */
165     function balanceOf(address account) external view returns (uint256);
166  
167     /**
168      * @dev Moves `amount` tokens from the caller's account to `to`.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transfer(address to, uint256 amount) external returns (bool);
175  
176     /**
177      * @dev Returns the remaining number of tokens that `spender` will be
178      * allowed to spend on behalf of `owner` through {transferFrom}. This is
179      * zero by default.
180      *
181      * This value changes when {approve} or {transferFrom} are called.
182      */
183     function allowance(address owner, address spender)
184         external
185         view
186         returns (uint256);
187  
188     /**
189      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * IMPORTANT: Beware that changing an allowance with this method brings the risk
194      * that someone may use both the old and the new allowance by unfortunate
195      * transaction ordering. One possible solution to mitigate this race
196      * condition is to first reduce the spender's allowance to 0 and set the
197      * desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      *
200      * Emits an {Approval} event.
201      */
202     function approve(address spender, uint256 amount) external returns (bool);
203  
204     /**
205      * @dev Moves `amount` tokens from `from` to `to` using the
206      * allowance mechanism. `amount` is then deducted from the caller's
207      * allowance.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address from,
215         address to,
216         uint256 amount
217     ) external returns (bool);
218 }
219  
220 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
221  
222 // pragma solidity ^0.8.0;
223  
224 // import "../IERC20.sol";
225  
226 /**
227  * @dev Interface for the optional metadata functions from the ERC20 standard.
228  *
229  * _Available since v4.1._
230  */
231 interface IERC20Metadata is IERC20 {
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() external view returns (string memory);
236  
237     /**
238      * @dev Returns the symbol of the token.
239      */
240     function symbol() external view returns (string memory);
241  
242     /**
243      * @dev Returns the decimals places of the token.
244      */
245     function decimals() external view returns (uint8);
246 }
247  
248 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
249  
250 // pragma solidity ^0.8.0;
251  
252 // import "./IERC20.sol";
253 // import "./extensions/IERC20Metadata.sol";
254 // import "../../utils/Context.sol";
255  
256 /**
257  * @dev Implementation of the {IERC20} interface.
258  *
259  * This implementation is agnostic to the way tokens are created. This means
260  * that a supply mechanism has to be added in a derived contract using {_mint}.
261  * For a generic mechanism see {ERC20PresetMinterPauser}.
262  *
263  * TIP: For a detailed writeup see our guide
264  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
265  * to implement supply mechanisms].
266  *
267  * The default value of {decimals} is 18. To change this, you should override
268  * this function so it returns a different value.
269  *
270  * We have followed general OpenZeppelin Contracts guidelines: functions revert
271  * instead returning `false` on failure. This behavior is nonetheless
272  * conventional and does not conflict with the expectations of ERC20
273  * applications.
274  *
275  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
276  * This allows applications to reconstruct the allowance for all accounts just
277  * by listening to said events. Other implementations of the EIP may not emit
278  * these events, as it isn't required by the specification.
279  *
280  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
281  * functions have been added to mitigate the well-known issues around setting
282  * allowances. See {IERC20-approve}.
283  */
284 contract ERC20 is Context, IERC20, IERC20Metadata {
285     mapping(address => uint256) private _balances;
286  
287     mapping(address => mapping(address => uint256)) private _allowances;
288  
289     uint256 private _totalSupply;
290  
291     string private _name;
292     string private _symbol;
293  
294     /**
295      * @dev Sets the values for {name} and {symbol}.
296      *
297      * All two of these values are immutable: they can only be set once during
298      * construction.
299      */
300     constructor(string memory name_, string memory symbol_) {
301         _name = name_;
302         _symbol = symbol_;
303     }
304  
305     /**
306      * @dev Returns the name of the token.
307      */
308     function name() public view virtual override returns (string memory) {
309         return _name;
310     }
311  
312     /**
313      * @dev Returns the symbol of the token, usually a shorter version of the
314      * name.
315      */
316     function symbol() public view virtual override returns (string memory) {
317         return _symbol;
318     }
319  
320     /**
321      * @dev Returns the number of decimals used to get its user representation.
322      * For example, if `decimals` equals `2`, a balance of `505` tokens should
323      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
324      *
325      * Tokens usually opt for a value of 18, imitating the relationship between
326      * Ether and Wei. This is the default value returned by this function, unless
327      * it's overridden.
328      *
329      * NOTE: This information is only used for _display_ purposes: it in
330      * no way affects any of the arithmetic of the contract, including
331      * {IERC20-balanceOf} and {IERC20-transfer}.
332      */
333     function decimals() public view virtual override returns (uint8) {
334         return 18;
335     }
336  
337     /**
338      * @dev See {IERC20-totalSupply}.
339      */
340     function totalSupply() public view virtual override returns (uint256) {
341         return _totalSupply;
342     }
343  
344     /**
345      * @dev See {IERC20-balanceOf}.
346      */
347     function balanceOf(address account)
348         public
349         view
350         virtual
351         override
352         returns (uint256)
353     {
354         return _balances[account];
355     }
356  
357     /**
358      * @dev See {IERC20-transfer}.
359      *
360      * Requirements:
361      *
362      * - `to` cannot be the zero address.
363      * - the caller must have a balance of at least `amount`.
364      */
365     function transfer(address to, uint256 amount)
366         public
367         virtual
368         override
369         returns (bool)
370     {
371         address owner = _msgSender();
372         _transfer(owner, to, amount);
373         return true;
374     }
375  
376     /**
377      * @dev See {IERC20-allowance}.
378      */
379     function allowance(address owner, address spender)
380         public
381         view
382         virtual
383         override
384         returns (uint256)
385     {
386         return _allowances[owner][spender];
387     }
388  
389     /**
390      * @dev See {IERC20-approve}.
391      *
392      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
393      * `transferFrom`. This is semantically equivalent to an infinite approval.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function approve(address spender, uint256 amount)
400         public
401         virtual
402         override
403         returns (bool)
404     {
405         address owner = _msgSender();
406         _approve(owner, spender, amount);
407         return true;
408     }
409  
410     /**
411      * @dev See {IERC20-transferFrom}.
412      *
413      * Emits an {Approval} event indicating the updated allowance. This is not
414      * required by the EIP. See the note at the beginning of {ERC20}.
415      *
416      * NOTE: Does not update the allowance if the current allowance
417      * is the maximum `uint256`.
418      *
419      * Requirements:
420      *
421      * - `from` and `to` cannot be the zero address.
422      * - `from` must have a balance of at least `amount`.
423      * - the caller must have allowance for ``from``'s tokens of at least
424      * `amount`.
425      */
426     function transferFrom(
427         address from,
428         address to,
429         uint256 amount
430     ) public virtual override returns (bool) {
431         address spender = _msgSender();
432         _spendAllowance(from, spender, amount);
433         _transfer(from, to, amount);
434         return true;
435     }
436  
437     /**
438      * @dev Atomically increases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      */
449     function increaseAllowance(address spender, uint256 addedValue)
450         public
451         virtual
452         returns (bool)
453     {
454         address owner = _msgSender();
455         _approve(owner, spender, allowance(owner, spender) + addedValue);
456         return true;
457     }
458  
459     /**
460      * @dev Atomically decreases the allowance granted to `spender` by the caller.
461      *
462      * This is an alternative to {approve} that can be used as a mitigation for
463      * problems described in {IERC20-approve}.
464      *
465      * Emits an {Approval} event indicating the updated allowance.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      * - `spender` must have allowance for the caller of at least
471      * `subtractedValue`.
472      */
473     function decreaseAllowance(address spender, uint256 subtractedValue)
474         public
475         virtual
476         returns (bool)
477     {
478         address owner = _msgSender();
479         uint256 currentAllowance = allowance(owner, spender);
480         require(
481             currentAllowance >= subtractedValue,
482             "ERC20: decreased allowance below zero"
483         );
484         unchecked {
485             _approve(owner, spender, currentAllowance - subtractedValue);
486         }
487  
488         return true;
489     }
490  
491     /**
492      * @dev Moves `amount` of tokens from `from` to `to`.
493      *
494      * This internal function is equivalent to {transfer}, and can be used to
495      * e.g. implement automatic token fees, slashing mechanisms, etc.
496      *
497      * Emits a {Transfer} event.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `from` must have a balance of at least `amount`.
504      */
505     function _transfer(
506         address from,
507         address to,
508         uint256 amount
509     ) internal virtual {
510         require(from != address(0), "ERC20: transfer from the zero address");
511         require(to != address(0), "ERC20: transfer to the zero address");
512  
513         _beforeTokenTransfer(from, to, amount);
514  
515         uint256 fromBalance = _balances[from];
516         require(
517             fromBalance >= amount,
518             "ERC20: transfer amount exceeds balance"
519         );
520         unchecked {
521             _balances[from] = fromBalance - amount;
522             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
523             // decrementing then incrementing.
524             _balances[to] += amount;
525         }
526  
527         emit Transfer(from, to, amount);
528  
529         _afterTokenTransfer(from, to, amount);
530     }
531  
532     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
533      * the total supply.
534      *
535      * Emits a {Transfer} event with `from` set to the zero address.
536      *
537      * Requirements:
538      *
539      * - `account` cannot be the zero address.
540      */
541     function _mint(address account, uint256 amount) internal virtual {
542         require(account != address(0), "ERC20: mint to the zero address");
543  
544         _beforeTokenTransfer(address(0), account, amount);
545  
546         _totalSupply += amount;
547         unchecked {
548             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
549             _balances[account] += amount;
550         }
551         emit Transfer(address(0), account, amount);
552  
553         _afterTokenTransfer(address(0), account, amount);
554     }
555  
556     /**
557      * @dev Destroys `amount` tokens from `account`, reducing the
558      * total supply.
559      *
560      * Emits a {Transfer} event with `to` set to the zero address.
561      *
562      * Requirements:
563      *
564      * - `account` cannot be the zero address.
565      * - `account` must have at least `amount` tokens.
566      */
567     function _burn(address account, uint256 amount) internal virtual {
568         require(account != address(0), "ERC20: burn from the zero address");
569  
570         _beforeTokenTransfer(account, address(0), amount);
571  
572         uint256 accountBalance = _balances[account];
573         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
574         unchecked {
575             _balances[account] = accountBalance - amount;
576             // Overflow not possible: amount <= accountBalance <= totalSupply.
577             _totalSupply -= amount;
578         }
579  
580         emit Transfer(account, address(0), amount);
581  
582         _afterTokenTransfer(account, address(0), amount);
583     }
584  
585     /**
586      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
587      *
588      * This internal function is equivalent to `approve`, and can be used to
589      * e.g. set automatic allowances for certain subsystems, etc.
590      *
591      * Emits an {Approval} event.
592      *
593      * Requirements:
594      *
595      * - `owner` cannot be the zero address.
596      * - `spender` cannot be the zero address.
597      */
598     function _approve(
599         address owner,
600         address spender,
601         uint256 amount
602     ) internal virtual {
603         require(owner != address(0), "ERC20: approve from the zero address");
604         require(spender != address(0), "ERC20: approve to the zero address");
605  
606         _allowances[owner][spender] = amount;
607         emit Approval(owner, spender, amount);
608     }
609  
610     /**
611      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
612      *
613      * Does not update the allowance amount in case of infinite allowance.
614      * Revert if not enough allowance is available.
615      *
616      * Might emit an {Approval} event.
617      */
618     function _spendAllowance(
619         address owner,
620         address spender,
621         uint256 amount
622     ) internal virtual {
623         uint256 currentAllowance = allowance(owner, spender);
624         if (currentAllowance != type(uint256).max) {
625             require(
626                 currentAllowance >= amount,
627                 "ERC20: insufficient allowance"
628             );
629             unchecked {
630                 _approve(owner, spender, currentAllowance - amount);
631             }
632         }
633     }
634  
635     /**
636      * @dev Hook that is called before any transfer of tokens. This includes
637      * minting and burning.
638      *
639      * Calling conditions:
640      *
641      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
642      * will be transferred to `to`.
643      * - when `from` is zero, `amount` tokens will be minted for `to`.
644      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
645      * - `from` and `to` are never both zero.
646      *
647      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
648      */
649     function _beforeTokenTransfer(
650         address from,
651         address to,
652         uint256 amount
653     ) internal virtual {}
654  
655     /**
656      * @dev Hook that is called after any transfer of tokens. This includes
657      * minting and burning.
658      *
659      * Calling conditions:
660      *
661      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
662      * has been transferred to `to`.
663      * - when `from` is zero, `amount` tokens have been minted for `to`.
664      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
665      * - `from` and `to` are never both zero.
666      *
667      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
668      */
669     function _afterTokenTransfer(
670         address from,
671         address to,
672         uint256 amount
673     ) internal virtual {}
674 }
675  
676 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
677  
678 // pragma solidity ^0.8.0;
679  
680 // CAUTION
681 // This version of SafeMath should only be used with Solidity 0.8 or later,
682 // because it relies on the compiler's built in overflow checks.
683  
684 /**
685  * @dev Wrappers over Solidity's arithmetic operations.
686  *
687  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
688  * now has built in overflow checking.
689  */
690 library SafeMath {
691     /**
692      * @dev Returns the addition of two unsigned integers, with an overflow flag.
693      *
694      * _Available since v3.4._
695      */
696     function tryAdd(uint256 a, uint256 b)
697         internal
698         pure
699         returns (bool, uint256)
700     {
701         unchecked {
702             uint256 c = a + b;
703             if (c < a) return (false, 0);
704             return (true, c);
705         }
706     }
707  
708     /**
709      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
710      *
711      * _Available since v3.4._
712      */
713     function trySub(uint256 a, uint256 b)
714         internal
715         pure
716         returns (bool, uint256)
717     {
718         unchecked {
719             if (b > a) return (false, 0);
720             return (true, a - b);
721         }
722     }
723  
724     /**
725      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
726      *
727      * _Available since v3.4._
728      */
729     function tryMul(uint256 a, uint256 b)
730         internal
731         pure
732         returns (bool, uint256)
733     {
734         unchecked {
735             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
736             // benefit is lost if 'b' is also tested.
737             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
738             if (a == 0) return (true, 0);
739             uint256 c = a * b;
740             if (c / a != b) return (false, 0);
741             return (true, c);
742         }
743     }
744  
745     /**
746      * @dev Returns the division of two unsigned integers, with a division by zero flag.
747      *
748      * _Available since v3.4._
749      */
750     function tryDiv(uint256 a, uint256 b)
751         internal
752         pure
753         returns (bool, uint256)
754     {
755         unchecked {
756             if (b == 0) return (false, 0);
757             return (true, a / b);
758         }
759     }
760  
761     /**
762      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
763      *
764      * _Available since v3.4._
765      */
766     function tryMod(uint256 a, uint256 b)
767         internal
768         pure
769         returns (bool, uint256)
770     {
771         unchecked {
772             if (b == 0) return (false, 0);
773             return (true, a % b);
774         }
775     }
776  
777     /**
778      * @dev Returns the addition of two unsigned integers, reverting on
779      * overflow.
780      *
781      * Counterpart to Solidity's `+` operator.
782      *
783      * Requirements:
784      *
785      * - Addition cannot overflow.
786      */
787     function add(uint256 a, uint256 b) internal pure returns (uint256) {
788         return a + b;
789     }
790  
791     /**
792      * @dev Returns the subtraction of two unsigned integers, reverting on
793      * overflow (when the result is negative).
794      *
795      * Counterpart to Solidity's `-` operator.
796      *
797      * Requirements:
798      *
799      * - Subtraction cannot overflow.
800      */
801     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
802         return a - b;
803     }
804  
805     /**
806      * @dev Returns the multiplication of two unsigned integers, reverting on
807      * overflow.
808      *
809      * Counterpart to Solidity's `*` operator.
810      *
811      * Requirements:
812      *
813      * - Multiplication cannot overflow.
814      */
815     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
816         return a * b;
817     }
818  
819     /**
820      * @dev Returns the integer division of two unsigned integers, reverting on
821      * division by zero. The result is rounded towards zero.
822      *
823      * Counterpart to Solidity's `/` operator.
824      *
825      * Requirements:
826      *
827      * - The divisor cannot be zero.
828      */
829     function div(uint256 a, uint256 b) internal pure returns (uint256) {
830         return a / b;
831     }
832  
833     /**
834      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
835      * reverting when dividing by zero.
836      *
837      * Counterpart to Solidity's `%` operator. This function uses a `revert`
838      * opcode (which leaves remaining gas untouched) while Solidity uses an
839      * invalid opcode to revert (consuming all remaining gas).
840      *
841      * Requirements:
842      *
843      * - The divisor cannot be zero.
844      */
845     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
846         return a % b;
847     }
848  
849     /**
850      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
851      * overflow (when the result is negative).
852      *
853      * CAUTION: This function is deprecated because it requires allocating memory for the error
854      * message unnecessarily. For custom revert reasons use {trySub}.
855      *
856      * Counterpart to Solidity's `-` operator.
857      *
858      * Requirements:
859      *
860      * - Subtraction cannot overflow.
861      */
862     function sub(
863         uint256 a,
864         uint256 b,
865         string memory errorMessage
866     ) internal pure returns (uint256) {
867         unchecked {
868             require(b <= a, errorMessage);
869             return a - b;
870         }
871     }
872  
873     /**
874      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
875      * division by zero. The result is rounded towards zero.
876      *
877      * Counterpart to Solidity's `/` operator. Note: this function uses a
878      * `revert` opcode (which leaves remaining gas untouched) while Solidity
879      * uses an invalid opcode to revert (consuming all remaining gas).
880      *
881      * Requirements:
882      *
883      * - The divisor cannot be zero.
884      */
885     function div(
886         uint256 a,
887         uint256 b,
888         string memory errorMessage
889     ) internal pure returns (uint256) {
890         unchecked {
891             require(b > 0, errorMessage);
892             return a / b;
893         }
894     }
895  
896     /**
897      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
898      * reverting with custom message when dividing by zero.
899      *
900      * CAUTION: This function is deprecated because it requires allocating memory for the error
901      * message unnecessarily. For custom revert reasons use {tryMod}.
902      *
903      * Counterpart to Solidity's `%` operator. This function uses a `revert`
904      * opcode (which leaves remaining gas untouched) while Solidity uses an
905      * invalid opcode to revert (consuming all remaining gas).
906      *
907      * Requirements:
908      *
909      * - The divisor cannot be zero.
910      */
911     function mod(
912         uint256 a,
913         uint256 b,
914         string memory errorMessage
915     ) internal pure returns (uint256) {
916         unchecked {
917             require(b > 0, errorMessage);
918             return a % b;
919         }
920     }
921 }
922  
923 // pragma solidity >=0.5.0;
924  
925 interface IUniswapV2Factory {
926     event PairCreated(
927         address indexed token0,
928         address indexed token1,
929         address pair,
930         uint256
931     );
932  
933     function feeTo() external view returns (address);
934  
935     function feeToSetter() external view returns (address);
936  
937     function getPair(address tokenA, address tokenB)
938         external
939         view
940         returns (address pair);
941  
942     function allPairs(uint256) external view returns (address pair);
943  
944     function allPairsLength() external view returns (uint256);
945  
946     function createPair(address tokenA, address tokenB)
947         external
948         returns (address pair);
949  
950     function setFeeTo(address) external;
951  
952     function setFeeToSetter(address) external;
953 }
954  
955 // pragma solidity >=0.6.2;
956  
957 interface IUniswapV2Router01 {
958     function factory() external pure returns (address);
959  
960     function WETH() external pure returns (address);
961  
962     function addLiquidity(
963         address tokenA,
964         address tokenB,
965         uint256 amountADesired,
966         uint256 amountBDesired,
967         uint256 amountAMin,
968         uint256 amountBMin,
969         address to,
970         uint256 deadline
971     )
972         external
973         returns (
974             uint256 amountA,
975             uint256 amountB,
976             uint256 liquidity
977         );
978  
979     function addLiquidityETH(
980         address token,
981         uint256 amountTokenDesired,
982         uint256 amountTokenMin,
983         uint256 amountETHMin,
984         address to,
985         uint256 deadline
986     )
987         external
988         payable
989         returns (
990             uint256 amountToken,
991             uint256 amountETH,
992             uint256 liquidity
993         );
994  
995     function removeLiquidity(
996         address tokenA,
997         address tokenB,
998         uint256 liquidity,
999         uint256 amountAMin,
1000         uint256 amountBMin,
1001         address to,
1002         uint256 deadline
1003     ) external returns (uint256 amountA, uint256 amountB);
1004  
1005     function removeLiquidityETH(
1006         address token,
1007         uint256 liquidity,
1008         uint256 amountTokenMin,
1009         uint256 amountETHMin,
1010         address to,
1011         uint256 deadline
1012     ) external returns (uint256 amountToken, uint256 amountETH);
1013  
1014     function removeLiquidityWithPermit(
1015         address tokenA,
1016         address tokenB,
1017         uint256 liquidity,
1018         uint256 amountAMin,
1019         uint256 amountBMin,
1020         address to,
1021         uint256 deadline,
1022         bool approveMax,
1023         uint8 v,
1024         bytes32 r,
1025         bytes32 s
1026     ) external returns (uint256 amountA, uint256 amountB);
1027  
1028     function removeLiquidityETHWithPermit(
1029         address token,
1030         uint256 liquidity,
1031         uint256 amountTokenMin,
1032         uint256 amountETHMin,
1033         address to,
1034         uint256 deadline,
1035         bool approveMax,
1036         uint8 v,
1037         bytes32 r,
1038         bytes32 s
1039     ) external returns (uint256 amountToken, uint256 amountETH);
1040  
1041     function swapExactTokensForTokens(
1042         uint256 amountIn,
1043         uint256 amountOutMin,
1044         address[] calldata path,
1045         address to,
1046         uint256 deadline
1047     ) external returns (uint256[] memory amounts);
1048  
1049     function swapTokensForExactTokens(
1050         uint256 amountOut,
1051         uint256 amountInMax,
1052         address[] calldata path,
1053         address to,
1054         uint256 deadline
1055     ) external returns (uint256[] memory amounts);
1056  
1057     function swapExactETHForTokens(
1058         uint256 amountOutMin,
1059         address[] calldata path,
1060         address to,
1061         uint256 deadline
1062     ) external payable returns (uint256[] memory amounts);
1063  
1064     function swapTokensForExactETH(
1065         uint256 amountOut,
1066         uint256 amountInMax,
1067         address[] calldata path,
1068         address to,
1069         uint256 deadline
1070     ) external returns (uint256[] memory amounts);
1071  
1072     function swapExactTokensForETH(
1073         uint256 amountIn,
1074         uint256 amountOutMin,
1075         address[] calldata path,
1076         address to,
1077         uint256 deadline
1078     ) external returns (uint256[] memory amounts);
1079  
1080     function swapETHForExactTokens(
1081         uint256 amountOut,
1082         address[] calldata path,
1083         address to,
1084         uint256 deadline
1085     ) external payable returns (uint256[] memory amounts);
1086  
1087     function quote(
1088         uint256 amountA,
1089         uint256 reserveA,
1090         uint256 reserveB
1091     ) external pure returns (uint256 amountB);
1092  
1093     function getAmountOut(
1094         uint256 amountIn,
1095         uint256 reserveIn,
1096         uint256 reserveOut
1097     ) external pure returns (uint256 amountOut);
1098  
1099     function getAmountIn(
1100         uint256 amountOut,
1101         uint256 reserveIn,
1102         uint256 reserveOut
1103     ) external pure returns (uint256 amountIn);
1104  
1105     function getAmountsOut(uint256 amountIn, address[] calldata path)
1106         external
1107         view
1108         returns (uint256[] memory amounts);
1109  
1110     function getAmountsIn(uint256 amountOut, address[] calldata path)
1111         external
1112         view
1113         returns (uint256[] memory amounts);
1114 }
1115  
1116 // pragma solidity >=0.6.2;
1117  
1118 // import './IUniswapV2Router01.sol';
1119  
1120 interface IUniswapV2Router02 is IUniswapV2Router01 {
1121     function removeLiquidityETHSupportingFeeOnTransferTokens(
1122         address token,
1123         uint256 liquidity,
1124         uint256 amountTokenMin,
1125         uint256 amountETHMin,
1126         address to,
1127         uint256 deadline
1128     ) external returns (uint256 amountETH);
1129  
1130     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
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
1141     ) external returns (uint256 amountETH);
1142  
1143     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1144         uint256 amountIn,
1145         uint256 amountOutMin,
1146         address[] calldata path,
1147         address to,
1148         uint256 deadline
1149     ) external;
1150  
1151     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1152         uint256 amountOutMin,
1153         address[] calldata path,
1154         address to,
1155         uint256 deadline
1156     ) external payable;
1157  
1158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1159         uint256 amountIn,
1160         uint256 amountOutMin,
1161         address[] calldata path,
1162         address to,
1163         uint256 deadline
1164     ) external;
1165 }
1166  
1167 contract army is ERC20, Ownable {
1168     using SafeMath for uint256;
1169  
1170     IUniswapV2Router02 public immutable uniswapV2Router;
1171     address public uniswapV2Pair;
1172     address public constant deadAddress = address(0xdead);
1173  
1174     bool private swapping;
1175  
1176     address public marketingWallet;
1177     address public developmentWallet;
1178     address public communityFundWallet;
1179  
1180     uint256 public maxTransactionAmount;
1181     uint256 public swapTokensAtAmount;
1182     uint256 public maxWallet;
1183  
1184     bool public tradingActive = false;
1185     bool public swapEnabled = false;
1186  
1187     uint256 public buyTotalFees;
1188     uint256 private buyMarketingFee;
1189     uint256 private buyDevelopmentFee;
1190     uint256 private buyCommunityFundFee;
1191  
1192     uint256 public sellTotalFees;
1193     uint256 private sellMarketingFee;
1194     uint256 private sellDevelopmentFee;
1195     uint256 private sellCommunityFundFee;
1196  
1197     uint256 private tokensForMarketing;
1198     uint256 private tokensForDevelopment;
1199     uint256 private tokensForCommunityFund;
1200     uint256 private previousFee;
1201  
1202     mapping(address => bool) private _isExcludedFromFees;
1203     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1204     mapping(address => bool) private automatedMarketMakerPairs;
1205  
1206     event ExcludeFromFees(address indexed account, bool isExcluded);
1207  
1208     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1209  
1210     event marketingWalletUpdated(
1211         address indexed newWallet,
1212         address indexed oldWallet
1213     );
1214  
1215     event developmentWalletUpdated(
1216         address indexed newWallet,
1217         address indexed oldWallet
1218     );
1219  
1220     event communityFundWalletUpdated(
1221         address indexed newWallet,
1222         address indexed oldWallet
1223     );
1224  
1225     constructor() ERC20("Drew Roberts Army", "ARMY") {
1226         uniswapV2Router = IUniswapV2Router02(
1227             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1228         );
1229         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1230  
1231         uint256 totalSupply = 100_000_000_000 ether;
1232  
1233         maxTransactionAmount = (totalSupply) / 200; // 500,000,000 tokens
1234         maxWallet = (totalSupply) / 100;  //1% of total supply (1,000,000,000 tokens)
1235         swapTokensAtAmount = (totalSupply * 5) / 10000;
1236  
1237         buyMarketingFee = 1;
1238         buyDevelopmentFee = 1;
1239         buyCommunityFundFee = 1;
1240         buyTotalFees =
1241             buyMarketingFee +
1242             buyDevelopmentFee +
1243             buyCommunityFundFee;
1244  
1245         sellMarketingFee = 8;
1246         sellDevelopmentFee = 1;
1247         sellCommunityFundFee = 1;
1248         sellTotalFees =
1249             sellMarketingFee +
1250             sellDevelopmentFee +
1251             sellCommunityFundFee;
1252  
1253         previousFee = sellTotalFees;
1254  
1255         marketingWallet = address(0xCcff2853D67C92b6511217b9224558046818D677); // Marketing Funds
1256         developmentWallet = address(0xC6aa2f0FF6b8563EA418ec2558890D6027413699); // DrewRoberts.eth
1257         communityFundWallet = address(0xD65746AdED5Ec72899c67752f079Daf020D9c20C); // Community Funds
1258  
1259         excludeFromFees(owner(), true);
1260         excludeFromFees(address(this), true);
1261         excludeFromFees(deadAddress, true);
1262         excludeFromFees(marketingWallet, true);
1263         excludeFromFees(developmentWallet, true);
1264         excludeFromFees(communityFundWallet, true);
1265  
1266         excludeFromMaxTransaction(owner(), true);
1267         excludeFromMaxTransaction(address(this), true);
1268         excludeFromMaxTransaction(deadAddress, true);
1269         excludeFromMaxTransaction(address(uniswapV2Router), true);
1270         excludeFromMaxTransaction(marketingWallet, true);
1271         excludeFromMaxTransaction(developmentWallet, true);
1272         excludeFromMaxTransaction(communityFundWallet, true);
1273  
1274         _mint(address(this), totalSupply);
1275     }
1276  
1277     receive() external payable {}
1278  
1279     function burn(uint256 amount) external {
1280         _burn(msg.sender, amount);
1281     }
1282  
1283     function enableTrading() external onlyOwner {
1284         require(!tradingActive, "Trading already active.");
1285  
1286         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1287             address(this),
1288             uniswapV2Router.WETH()
1289         );
1290         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1291         IERC20(uniswapV2Pair).approve(
1292             address(uniswapV2Router),
1293             type(uint256).max
1294         );
1295  
1296         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1297         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1298 
1299         uint256 tokensInWallet = balanceOf(address(this));
1300         uint256 tokensToAdd = tokensInWallet * 9 / 10; //90% of tokens in wallet go to LP
1301  
1302         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1303             address(this),
1304             tokensToAdd, 
1305             0,
1306             0,
1307             owner(),
1308             block.timestamp
1309         );
1310  
1311         tradingActive = true;
1312         swapEnabled = true;
1313     }
1314  
1315     function updateSwapTokensAtAmount(uint256 newAmount)
1316         external
1317         onlyOwner
1318         returns (bool)
1319     {
1320         require(
1321             newAmount >= (totalSupply() * 1) / 100000,
1322             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1323         );
1324         require(
1325             newAmount <= (totalSupply() * 5) / 1000,
1326             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1327         );
1328         swapTokensAtAmount = newAmount;
1329         return true;
1330     }
1331  
1332     function updateMaxWalletAndTxnAmount(
1333         uint256 newTxnNum,
1334         uint256 newMaxWalletNum
1335     ) external onlyOwner {
1336         require(
1337             newTxnNum >= ((totalSupply() * 5) / 1000),
1338             "ERC20: Cannot set maxTxn lower than 0.5%"
1339         );
1340         require(
1341             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1342             "ERC20: Cannot set maxWallet lower than 0.5%"
1343         );
1344         maxWallet = newMaxWalletNum;
1345         maxTransactionAmount = newTxnNum;
1346     }
1347  
1348     function excludeFromMaxTransaction(address updAds, bool isEx)
1349         public
1350         onlyOwner
1351     {
1352         _isExcludedMaxTransactionAmount[updAds] = isEx;
1353     }
1354  
1355     function updateBuyFees(
1356         uint256 _marketingFee,
1357         uint256 _developmentFee,
1358         uint256 _communityFundFee
1359     ) external onlyOwner {
1360         buyMarketingFee = _marketingFee;
1361         buyDevelopmentFee = _developmentFee;
1362         buyCommunityFundFee = _communityFundFee;
1363         buyTotalFees =
1364             buyMarketingFee +
1365             buyDevelopmentFee +
1366             buyCommunityFundFee;
1367         require(buyTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1368     }
1369  
1370     function updateSellFees(
1371         uint256 _marketingFee,
1372         uint256 _developmentFee,
1373         uint256 _communityFundFee
1374     ) external onlyOwner {
1375         sellMarketingFee = _marketingFee;
1376         sellDevelopmentFee = _developmentFee;
1377         sellCommunityFundFee = _communityFundFee;
1378         sellTotalFees =
1379             sellMarketingFee +
1380             sellDevelopmentFee +
1381             sellCommunityFundFee;
1382         previousFee = sellTotalFees;
1383         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1384     }
1385  
1386     function updateMarketingWallet(address _marketingWallet)
1387         external
1388         onlyOwner
1389     {
1390         require(_marketingWallet != address(0), "ERC20: Address 0");
1391         address oldWallet = marketingWallet;
1392         marketingWallet = _marketingWallet;
1393         emit marketingWalletUpdated(marketingWallet, oldWallet);
1394     }
1395  
1396     function updateDevelopmentWallet(address _developmentWallet)
1397         external
1398         onlyOwner
1399     {
1400         require(_developmentWallet != address(0), "ERC20: Address 0");
1401         address oldWallet = developmentWallet;
1402         developmentWallet = _developmentWallet;
1403         emit developmentWalletUpdated(developmentWallet, oldWallet);
1404     }
1405  
1406     function updateCommunityFundWallet(address _communityFundWallet)
1407         external
1408         onlyOwner
1409     {
1410         require(_communityFundWallet != address(0), "ERC20: Address 0");
1411         address oldWallet = communityFundWallet;
1412         communityFundWallet = _communityFundWallet;
1413         emit communityFundWalletUpdated(communityFundWallet, oldWallet);
1414     }
1415  
1416     function excludeFromFees(address account, bool excluded) public onlyOwner {
1417         _isExcludedFromFees[account] = excluded;
1418         emit ExcludeFromFees(account, excluded);
1419     }
1420  
1421     function withdrawStuckETH() public onlyOwner {
1422         bool success;
1423         (success, ) = address(msg.sender).call{value: address(this).balance}(
1424             ""
1425         );
1426     }
1427  
1428     function withdrawStuckTokens(address tkn) public onlyOwner {
1429         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1430         uint256 amount = IERC20(tkn).balanceOf(address(this));
1431         IERC20(tkn).transfer(msg.sender, amount);
1432     }
1433  
1434     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1435         automatedMarketMakerPairs[pair] = value;
1436  
1437         emit SetAutomatedMarketMakerPair(pair, value);
1438     }
1439  
1440     function isExcludedFromFees(address account) public view returns (bool) {
1441         return _isExcludedFromFees[account];
1442     }
1443  
1444     function _transfer(
1445         address from,
1446         address to,
1447         uint256 amount
1448     ) internal override {
1449         require(from != address(0), "ERC20: transfer from the zero address");
1450         require(to != address(0), "ERC20: transfer to the zero address");
1451  
1452         if (amount == 0) {
1453             super._transfer(from, to, 0);
1454             return;
1455         }
1456  
1457         if (
1458             from != owner() &&
1459             to != owner() &&
1460             to != address(0) &&
1461             to != deadAddress &&
1462             !swapping
1463         ) {
1464             if (!tradingActive) {
1465                 require(
1466                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1467                     "ERC20: Trading is not active."
1468                 );
1469             }
1470  
1471             //when buy
1472             if (
1473                 automatedMarketMakerPairs[from] &&
1474                 !_isExcludedMaxTransactionAmount[to]
1475             ) {
1476                 require(
1477                     amount <= maxTransactionAmount,
1478                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1479                 );
1480                 require(
1481                     amount + balanceOf(to) <= maxWallet,
1482                     "ERC20: Max wallet exceeded"
1483                 );
1484             }
1485             //when sell
1486             else if (
1487                 automatedMarketMakerPairs[to] &&
1488                 !_isExcludedMaxTransactionAmount[from]
1489             ) {
1490                 require(
1491                     amount <= maxTransactionAmount,
1492                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1493                 );
1494             } else if (!_isExcludedMaxTransactionAmount[to]) {
1495                 require(
1496                     amount + balanceOf(to) <= maxWallet,
1497                     "ERC20: Max wallet exceeded"
1498                 );
1499             }
1500         }
1501  
1502         uint256 contractTokenBalance = balanceOf(address(this));
1503  
1504         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1505  
1506         if (
1507             canSwap &&
1508             swapEnabled &&
1509             !swapping &&
1510             !automatedMarketMakerPairs[from] &&
1511             !_isExcludedFromFees[from] &&
1512             !_isExcludedFromFees[to]
1513         ) {
1514             swapping = true;
1515  
1516             swapBack();
1517  
1518             swapping = false;
1519         }
1520  
1521         bool takeFee = !swapping;
1522  
1523         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1524             takeFee = false;
1525         }
1526  
1527         uint256 fees = 0;
1528  
1529         if (takeFee) {
1530             // on sell
1531             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1532                 fees = amount.mul(sellTotalFees).div(100);
1533                 tokensForCommunityFund +=
1534                     (fees * sellCommunityFundFee) /
1535                     sellTotalFees;
1536                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1537                 tokensForDevelopment +=
1538                     (fees * sellDevelopmentFee) /
1539                     sellTotalFees;
1540             }
1541             // on buy
1542             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1543                 fees = amount.mul(buyTotalFees).div(100);
1544                 tokensForCommunityFund +=
1545                     (fees * buyCommunityFundFee) /
1546                     buyTotalFees;
1547                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1548                 tokensForDevelopment +=
1549                     (fees * buyDevelopmentFee) /
1550                     buyTotalFees;
1551             }
1552  
1553             if (fees > 0) {
1554                 super._transfer(from, address(this), fees);
1555             }
1556  
1557             amount -= fees;
1558         }
1559  
1560         super._transfer(from, to, amount);
1561         sellTotalFees = previousFee;
1562     }
1563  
1564     function swapTokensForEth(uint256 tokenAmount) private {
1565         address[] memory path = new address[](2);
1566         path[0] = address(this);
1567         path[1] = uniswapV2Router.WETH();
1568  
1569         _approve(address(this), address(uniswapV2Router), tokenAmount);
1570  
1571         // make the swap
1572         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1573             tokenAmount,
1574             0,
1575             path,
1576             address(this),
1577             block.timestamp
1578         );
1579     }
1580  
1581     function swapBack() private {
1582         uint256 contractBalance = balanceOf(address(this));
1583         uint256 totalTokensToSwap = tokensForCommunityFund +
1584             tokensForMarketing +
1585             tokensForDevelopment;
1586         bool success;
1587  
1588         if (contractBalance == 0 || totalTokensToSwap == 0) {
1589             return;
1590         }
1591  
1592         if (contractBalance > swapTokensAtAmount * 20) {
1593             contractBalance = swapTokensAtAmount * 20;
1594         }
1595  
1596         swapTokensForEth(contractBalance);
1597  
1598         uint256 ethBalance = address(this).balance;
1599  
1600         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(
1601             totalTokensToSwap
1602         );
1603  
1604         uint256 ethForCommunityFund = ethBalance
1605             .mul(tokensForCommunityFund)
1606             .div(totalTokensToSwap);
1607  
1608         tokensForMarketing = 0;
1609         tokensForDevelopment = 0;
1610         tokensForCommunityFund = 0;
1611  
1612         (success, ) = address(communityFundWallet).call{
1613             value: ethForCommunityFund
1614         }("");
1615  
1616         (success, ) = address(developmentWallet).call{value: ethForDevelopment}(
1617             ""
1618         );
1619  
1620         (success, ) = address(marketingWallet).call{
1621             value: address(this).balance
1622         }("");
1623     }
1624 }