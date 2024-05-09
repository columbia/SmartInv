1 /*
2     Fusing Backyard Combat Culture with Crypto.
3     Elevating the personal brand value of aspiring professional fighters.
4 
5     Website:    https://cryptofightclub.vip/
6 
7     Telegram:   https://t.me/CFCeth
8 
9     Twitter:    https://twitter.com/CFC_erc
10 
11     dApp:       https://cfc-official.web.app/
12 
13     Mobile App: https://play.google.com/store/apps/details?id=com.cfc.crypto.app&pli=1
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity 0.8.20;
19 pragma experimental ABIEncoderV2;
20 
21 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
22 
23 // pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Provides information about the current execution context, including the
27  * sender of the transaction and its data. While these are generally available
28  * via msg.sender and msg.data, they should not be accessed in such a direct
29  * manner, since when dealing with meta-transactions the account sending and
30  * paying for execution may not be the actual sender (as far as an application
31  * is concerned).
32  *
33  * This contract is only required for intermediate, library-like contracts.
34  */
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         return msg.data;
42     }
43 }
44 
45 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
46 
47 // pragma solidity ^0.8.0;
48 
49 // import "../utils/Context.sol";
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(
67         address indexed previousOwner,
68         address indexed newOwner
69     );
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor() {
75         _transferOwnership(_msgSender());
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         _checkOwner();
83         _;
84     }
85 
86     /**
87      * @dev Returns the address of the current owner.
88      */
89     function owner() public view virtual returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if the sender is not the owner.
95      */
96     function _checkOwner() internal view virtual {
97         require(owner() == _msgSender(), "Ownable: caller is not the owner");
98     }
99 
100     /**
101      * @dev Leaves the contract without owner. It will not be possible to call
102      * `onlyOwner` functions. Can only be called by the current owner.
103      *
104      * NOTE: Renouncing ownership will leave the contract without an owner,
105      * thereby disabling any functionality that is only available to the owner.
106      */
107     function renounceOwnership() public virtual onlyOwner {
108         _transferOwnership(address(0));
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Can only be called by the current owner.
114      */
115     function transferOwnership(address newOwner) public virtual onlyOwner {
116         require(
117             newOwner != address(0),
118             "Ownable: new owner is the zero address"
119         );
120         _transferOwnership(newOwner);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Internal function without access restriction.
126      */
127     function _transferOwnership(address newOwner) internal virtual {
128         address oldOwner = _owner;
129         _owner = newOwner;
130         emit OwnershipTransferred(oldOwner, newOwner);
131     }
132 }
133 
134 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
135 
136 // pragma solidity ^0.8.0;
137 
138 /**
139  * @dev Interface of the ERC20 standard as defined in the EIP.
140  */
141 interface IERC20 {
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(
155         address indexed owner,
156         address indexed spender,
157         uint256 value
158     );
159 
160     /**
161      * @dev Returns the amount of tokens in existence.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     /**
166      * @dev Returns the amount of tokens owned by `account`.
167      */
168     function balanceOf(address account) external view returns (uint256);
169 
170     /**
171      * @dev Moves `amount` tokens from the caller's account to `to`.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transfer(address to, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Returns the remaining number of tokens that `spender` will be
181      * allowed to spend on behalf of `owner` through {transferFrom}. This is
182      * zero by default.
183      *
184      * This value changes when {approve} or {transferFrom} are called.
185      */
186     function allowance(address owner, address spender)
187         external
188         view
189         returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `from` to `to` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address from,
218         address to,
219         uint256 amount
220     ) external returns (bool);
221 }
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
224 
225 // pragma solidity ^0.8.0;
226 
227 // import "../IERC20.sol";
228 
229 /**
230  * @dev Interface for the optional metadata functions from the ERC20 standard.
231  *
232  * _Available since v4.1._
233  */
234 interface IERC20Metadata is IERC20 {
235     /**
236      * @dev Returns the name of the token.
237      */
238     function name() external view returns (string memory);
239 
240     /**
241      * @dev Returns the symbol of the token.
242      */
243     function symbol() external view returns (string memory);
244 
245     /**
246      * @dev Returns the decimals places of the token.
247      */
248     function decimals() external view returns (uint8);
249 }
250 
251 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
252 
253 // pragma solidity ^0.8.0;
254 
255 // import "./IERC20.sol";
256 // import "./extensions/IERC20Metadata.sol";
257 // import "../../utils/Context.sol";
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20PresetMinterPauser}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * The default value of {decimals} is 18. To change this, you should override
271  * this function so it returns a different value.
272  *
273  * We have followed general OpenZeppelin Contracts guidelines: functions revert
274  * instead returning `false` on failure. This behavior is nonetheless
275  * conventional and does not conflict with the expectations of ERC20
276  * applications.
277  *
278  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
279  * This allows applications to reconstruct the allowance for all accounts just
280  * by listening to said events. Other implementations of the EIP may not emit
281  * these events, as it isn't required by the specification.
282  *
283  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
284  * functions have been added to mitigate the well-known issues around setting
285  * allowances. See {IERC20-approve}.
286  */
287 contract ERC20 is Context, IERC20, IERC20Metadata {
288     mapping(address => uint256) private _balances;
289 
290     mapping(address => mapping(address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     string private _name;
295     string private _symbol;
296 
297     /**
298      * @dev Sets the values for {name} and {symbol}.
299      *
300      * All two of these values are immutable: they can only be set once during
301      * construction.
302      */
303     constructor(string memory name_, string memory symbol_) {
304         _name = name_;
305         _symbol = symbol_;
306     }
307 
308     /**
309      * @dev Returns the name of the token.
310      */
311     function name() public view virtual override returns (string memory) {
312         return _name;
313     }
314 
315     /**
316      * @dev Returns the symbol of the token, usually a shorter version of the
317      * name.
318      */
319     function symbol() public view virtual override returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @dev Returns the number of decimals used to get its user representation.
325      * For example, if `decimals` equals `2`, a balance of `505` tokens should
326      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
327      *
328      * Tokens usually opt for a value of 18, imitating the relationship between
329      * Ether and Wei. This is the default value returned by this function, unless
330      * it's overridden.
331      *
332      * NOTE: This information is only used for _display_ purposes: it in
333      * no way affects any of the arithmetic of the contract, including
334      * {IERC20-balanceOf} and {IERC20-transfer}.
335      */
336     function decimals() public view virtual override returns (uint8) {
337         return 18;
338     }
339 
340     /**
341      * @dev See {IERC20-totalSupply}.
342      */
343     function totalSupply() public view virtual override returns (uint256) {
344         return _totalSupply;
345     }
346 
347     /**
348      * @dev See {IERC20-balanceOf}.
349      */
350     function balanceOf(address account)
351         public
352         view
353         virtual
354         override
355         returns (uint256)
356     {
357         return _balances[account];
358     }
359 
360     /**
361      * @dev See {IERC20-transfer}.
362      *
363      * Requirements:
364      *
365      * - `to` cannot be the zero address.
366      * - the caller must have a balance of at least `amount`.
367      */
368     function transfer(address to, uint256 amount)
369         public
370         virtual
371         override
372         returns (bool)
373     {
374         address owner = _msgSender();
375         _transfer(owner, to, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-allowance}.
381      */
382     function allowance(address owner, address spender)
383         public
384         view
385         virtual
386         override
387         returns (uint256)
388     {
389         return _allowances[owner][spender];
390     }
391 
392     /**
393      * @dev See {IERC20-approve}.
394      *
395      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
396      * `transferFrom`. This is semantically equivalent to an infinite approval.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function approve(address spender, uint256 amount)
403         public
404         virtual
405         override
406         returns (bool)
407     {
408         address owner = _msgSender();
409         _approve(owner, spender, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-transferFrom}.
415      *
416      * Emits an {Approval} event indicating the updated allowance. This is not
417      * required by the EIP. See the note at the beginning of {ERC20}.
418      *
419      * NOTE: Does not update the allowance if the current allowance
420      * is the maximum `uint256`.
421      *
422      * Requirements:
423      *
424      * - `from` and `to` cannot be the zero address.
425      * - `from` must have a balance of at least `amount`.
426      * - the caller must have allowance for ``from``'s tokens of at least
427      * `amount`.
428      */
429     function transferFrom(
430         address from,
431         address to,
432         uint256 amount
433     ) public virtual override returns (bool) {
434         address spender = _msgSender();
435         _spendAllowance(from, spender, amount);
436         _transfer(from, to, amount);
437         return true;
438     }
439 
440     /**
441      * @dev Atomically increases the allowance granted to `spender` by the caller.
442      *
443      * This is an alternative to {approve} that can be used as a mitigation for
444      * problems described in {IERC20-approve}.
445      *
446      * Emits an {Approval} event indicating the updated allowance.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      */
452     function increaseAllowance(address spender, uint256 addedValue)
453         public
454         virtual
455         returns (bool)
456     {
457         address owner = _msgSender();
458         _approve(owner, spender, allowance(owner, spender) + addedValue);
459         return true;
460     }
461 
462     /**
463      * @dev Atomically decreases the allowance granted to `spender` by the caller.
464      *
465      * This is an alternative to {approve} that can be used as a mitigation for
466      * problems described in {IERC20-approve}.
467      *
468      * Emits an {Approval} event indicating the updated allowance.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      * - `spender` must have allowance for the caller of at least
474      * `subtractedValue`.
475      */
476     function decreaseAllowance(address spender, uint256 subtractedValue)
477         public
478         virtual
479         returns (bool)
480     {
481         address owner = _msgSender();
482         uint256 currentAllowance = allowance(owner, spender);
483         require(
484             currentAllowance >= subtractedValue,
485             "ERC20: decreased allowance below zero"
486         );
487         unchecked {
488             _approve(owner, spender, currentAllowance - subtractedValue);
489         }
490 
491         return true;
492     }
493 
494     /**
495      * @dev Moves `amount` of tokens from `from` to `to`.
496      *
497      * This internal function is equivalent to {transfer}, and can be used to
498      * e.g. implement automatic token fees, slashing mechanisms, etc.
499      *
500      * Emits a {Transfer} event.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `from` must have a balance of at least `amount`.
507      */
508     function _transfer(
509         address from,
510         address to,
511         uint256 amount
512     ) internal virtual {
513         require(from != address(0), "ERC20: transfer from the zero address");
514         require(to != address(0), "ERC20: transfer to the zero address");
515 
516         _beforeTokenTransfer(from, to, amount);
517 
518         uint256 fromBalance = _balances[from];
519         require(
520             fromBalance >= amount,
521             "ERC20: transfer amount exceeds balance"
522         );
523         unchecked {
524             _balances[from] = fromBalance - amount;
525             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
526             // decrementing then incrementing.
527             _balances[to] += amount;
528         }
529 
530         emit Transfer(from, to, amount);
531 
532         _afterTokenTransfer(from, to, amount);
533     }
534 
535     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
536      * the total supply.
537      *
538      * Emits a {Transfer} event with `from` set to the zero address.
539      *
540      * Requirements:
541      *
542      * - `account` cannot be the zero address.
543      */
544     function _mint(address account, uint256 amount) internal virtual {
545         require(account != address(0), "ERC20: mint to the zero address");
546 
547         _beforeTokenTransfer(address(0), account, amount);
548 
549         _totalSupply += amount;
550         unchecked {
551             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
552             _balances[account] += amount;
553         }
554         emit Transfer(address(0), account, amount);
555 
556         _afterTokenTransfer(address(0), account, amount);
557     }
558 
559     /**
560      * @dev Destroys `amount` tokens from `account`, reducing the
561      * total supply.
562      *
563      * Emits a {Transfer} event with `to` set to the zero address.
564      *
565      * Requirements:
566      *
567      * - `account` cannot be the zero address.
568      * - `account` must have at least `amount` tokens.
569      */
570     function _burn(address account, uint256 amount) internal virtual {
571         require(account != address(0), "ERC20: burn from the zero address");
572 
573         _beforeTokenTransfer(account, address(0), amount);
574 
575         uint256 accountBalance = _balances[account];
576         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
577         unchecked {
578             _balances[account] = accountBalance - amount;
579             // Overflow not possible: amount <= accountBalance <= totalSupply.
580             _totalSupply -= amount;
581         }
582 
583         emit Transfer(account, address(0), amount);
584 
585         _afterTokenTransfer(account, address(0), amount);
586     }
587 
588     /**
589      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
590      *
591      * This internal function is equivalent to `approve`, and can be used to
592      * e.g. set automatic allowances for certain subsystems, etc.
593      *
594      * Emits an {Approval} event.
595      *
596      * Requirements:
597      *
598      * - `owner` cannot be the zero address.
599      * - `spender` cannot be the zero address.
600      */
601     function _approve(
602         address owner,
603         address spender,
604         uint256 amount
605     ) internal virtual {
606         require(owner != address(0), "ERC20: approve from the zero address");
607         require(spender != address(0), "ERC20: approve to the zero address");
608 
609         _allowances[owner][spender] = amount;
610         emit Approval(owner, spender, amount);
611     }
612 
613     /**
614      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
615      *
616      * Does not update the allowance amount in case of infinite allowance.
617      * Revert if not enough allowance is available.
618      *
619      * Might emit an {Approval} event.
620      */
621     function _spendAllowance(
622         address owner,
623         address spender,
624         uint256 amount
625     ) internal virtual {
626         uint256 currentAllowance = allowance(owner, spender);
627         if (currentAllowance != type(uint256).max) {
628             require(
629                 currentAllowance >= amount,
630                 "ERC20: insufficient allowance"
631             );
632             unchecked {
633                 _approve(owner, spender, currentAllowance - amount);
634             }
635         }
636     }
637 
638     /**
639      * @dev Hook that is called before any transfer of tokens. This includes
640      * minting and burning.
641      *
642      * Calling conditions:
643      *
644      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
645      * will be transferred to `to`.
646      * - when `from` is zero, `amount` tokens will be minted for `to`.
647      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
648      * - `from` and `to` are never both zero.
649      *
650      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
651      */
652     function _beforeTokenTransfer(
653         address from,
654         address to,
655         uint256 amount
656     ) internal virtual {}
657 
658     /**
659      * @dev Hook that is called after any transfer of tokens. This includes
660      * minting and burning.
661      *
662      * Calling conditions:
663      *
664      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
665      * has been transferred to `to`.
666      * - when `from` is zero, `amount` tokens have been minted for `to`.
667      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
668      * - `from` and `to` are never both zero.
669      *
670      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
671      */
672     function _afterTokenTransfer(
673         address from,
674         address to,
675         uint256 amount
676     ) internal virtual {}
677 }
678 
679 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
680 
681 // pragma solidity ^0.8.0;
682 
683 // CAUTION
684 // This version of SafeMath should only be used with Solidity 0.8 or later,
685 // because it relies on the compiler's built in overflow checks.
686 
687 /**
688  * @dev Wrappers over Solidity's arithmetic operations.
689  *
690  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
691  * now has built in overflow checking.
692  */
693 library SafeMath {
694     /**
695      * @dev Returns the addition of two unsigned integers, with an overflow flag.
696      *
697      * _Available since v3.4._
698      */
699     function tryAdd(uint256 a, uint256 b)
700         internal
701         pure
702         returns (bool, uint256)
703     {
704         unchecked {
705             uint256 c = a + b;
706             if (c < a) return (false, 0);
707             return (true, c);
708         }
709     }
710 
711     /**
712      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
713      *
714      * _Available since v3.4._
715      */
716     function trySub(uint256 a, uint256 b)
717         internal
718         pure
719         returns (bool, uint256)
720     {
721         unchecked {
722             if (b > a) return (false, 0);
723             return (true, a - b);
724         }
725     }
726 
727     /**
728      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
729      *
730      * _Available since v3.4._
731      */
732     function tryMul(uint256 a, uint256 b)
733         internal
734         pure
735         returns (bool, uint256)
736     {
737         unchecked {
738             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
739             // benefit is lost if 'b' is also tested.
740             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
741             if (a == 0) return (true, 0);
742             uint256 c = a * b;
743             if (c / a != b) return (false, 0);
744             return (true, c);
745         }
746     }
747 
748     /**
749      * @dev Returns the division of two unsigned integers, with a division by zero flag.
750      *
751      * _Available since v3.4._
752      */
753     function tryDiv(uint256 a, uint256 b)
754         internal
755         pure
756         returns (bool, uint256)
757     {
758         unchecked {
759             if (b == 0) return (false, 0);
760             return (true, a / b);
761         }
762     }
763 
764     /**
765      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
766      *
767      * _Available since v3.4._
768      */
769     function tryMod(uint256 a, uint256 b)
770         internal
771         pure
772         returns (bool, uint256)
773     {
774         unchecked {
775             if (b == 0) return (false, 0);
776             return (true, a % b);
777         }
778     }
779 
780     /**
781      * @dev Returns the addition of two unsigned integers, reverting on
782      * overflow.
783      *
784      * Counterpart to Solidity's `+` operator.
785      *
786      * Requirements:
787      *
788      * - Addition cannot overflow.
789      */
790     function add(uint256 a, uint256 b) internal pure returns (uint256) {
791         return a + b;
792     }
793 
794     /**
795      * @dev Returns the subtraction of two unsigned integers, reverting on
796      * overflow (when the result is negative).
797      *
798      * Counterpart to Solidity's `-` operator.
799      *
800      * Requirements:
801      *
802      * - Subtraction cannot overflow.
803      */
804     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
805         return a - b;
806     }
807 
808     /**
809      * @dev Returns the multiplication of two unsigned integers, reverting on
810      * overflow.
811      *
812      * Counterpart to Solidity's `*` operator.
813      *
814      * Requirements:
815      *
816      * - Multiplication cannot overflow.
817      */
818     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
819         return a * b;
820     }
821 
822     /**
823      * @dev Returns the integer division of two unsigned integers, reverting on
824      * division by zero. The result is rounded towards zero.
825      *
826      * Counterpart to Solidity's `/` operator.
827      *
828      * Requirements:
829      *
830      * - The divisor cannot be zero.
831      */
832     function div(uint256 a, uint256 b) internal pure returns (uint256) {
833         return a / b;
834     }
835 
836     /**
837      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
838      * reverting when dividing by zero.
839      *
840      * Counterpart to Solidity's `%` operator. This function uses a `revert`
841      * opcode (which leaves remaining gas untouched) while Solidity uses an
842      * invalid opcode to revert (consuming all remaining gas).
843      *
844      * Requirements:
845      *
846      * - The divisor cannot be zero.
847      */
848     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
849         return a % b;
850     }
851 
852     /**
853      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
854      * overflow (when the result is negative).
855      *
856      * CAUTION: This function is deprecated because it requires allocating memory for the error
857      * message unnecessarily. For custom revert reasons use {trySub}.
858      *
859      * Counterpart to Solidity's `-` operator.
860      *
861      * Requirements:
862      *
863      * - Subtraction cannot overflow.
864      */
865     function sub(
866         uint256 a,
867         uint256 b,
868         string memory errorMessage
869     ) internal pure returns (uint256) {
870         unchecked {
871             require(b <= a, errorMessage);
872             return a - b;
873         }
874     }
875 
876     /**
877      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
878      * division by zero. The result is rounded towards zero.
879      *
880      * Counterpart to Solidity's `/` operator. Note: this function uses a
881      * `revert` opcode (which leaves remaining gas untouched) while Solidity
882      * uses an invalid opcode to revert (consuming all remaining gas).
883      *
884      * Requirements:
885      *
886      * - The divisor cannot be zero.
887      */
888     function div(
889         uint256 a,
890         uint256 b,
891         string memory errorMessage
892     ) internal pure returns (uint256) {
893         unchecked {
894             require(b > 0, errorMessage);
895             return a / b;
896         }
897     }
898 
899     /**
900      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
901      * reverting with custom message when dividing by zero.
902      *
903      * CAUTION: This function is deprecated because it requires allocating memory for the error
904      * message unnecessarily. For custom revert reasons use {tryMod}.
905      *
906      * Counterpart to Solidity's `%` operator. This function uses a `revert`
907      * opcode (which leaves remaining gas untouched) while Solidity uses an
908      * invalid opcode to revert (consuming all remaining gas).
909      *
910      * Requirements:
911      *
912      * - The divisor cannot be zero.
913      */
914     function mod(
915         uint256 a,
916         uint256 b,
917         string memory errorMessage
918     ) internal pure returns (uint256) {
919         unchecked {
920             require(b > 0, errorMessage);
921             return a % b;
922         }
923     }
924 }
925 
926 // pragma solidity >=0.5.0;
927 
928 interface IUniswapV2Factory {
929     event PairCreated(
930         address indexed token0,
931         address indexed token1,
932         address pair,
933         uint256
934     );
935 
936     function feeTo() external view returns (address);
937 
938     function feeToSetter() external view returns (address);
939 
940     function getPair(address tokenA, address tokenB)
941         external
942         view
943         returns (address pair);
944 
945     function allPairs(uint256) external view returns (address pair);
946 
947     function allPairsLength() external view returns (uint256);
948 
949     function createPair(address tokenA, address tokenB)
950         external
951         returns (address pair);
952 
953     function setFeeTo(address) external;
954 
955     function setFeeToSetter(address) external;
956 }
957 
958 // pragma solidity >=0.6.2;
959 
960 interface IUniswapV2Router01 {
961     function factory() external pure returns (address);
962 
963     function WETH() external pure returns (address);
964 
965     function addLiquidity(
966         address tokenA,
967         address tokenB,
968         uint256 amountADesired,
969         uint256 amountBDesired,
970         uint256 amountAMin,
971         uint256 amountBMin,
972         address to,
973         uint256 deadline
974     )
975         external
976         returns (
977             uint256 amountA,
978             uint256 amountB,
979             uint256 liquidity
980         );
981 
982     function addLiquidityETH(
983         address token,
984         uint256 amountTokenDesired,
985         uint256 amountTokenMin,
986         uint256 amountETHMin,
987         address to,
988         uint256 deadline
989     )
990         external
991         payable
992         returns (
993             uint256 amountToken,
994             uint256 amountETH,
995             uint256 liquidity
996         );
997 
998     function removeLiquidity(
999         address tokenA,
1000         address tokenB,
1001         uint256 liquidity,
1002         uint256 amountAMin,
1003         uint256 amountBMin,
1004         address to,
1005         uint256 deadline
1006     ) external returns (uint256 amountA, uint256 amountB);
1007 
1008     function removeLiquidityETH(
1009         address token,
1010         uint256 liquidity,
1011         uint256 amountTokenMin,
1012         uint256 amountETHMin,
1013         address to,
1014         uint256 deadline
1015     ) external returns (uint256 amountToken, uint256 amountETH);
1016 
1017     function removeLiquidityWithPermit(
1018         address tokenA,
1019         address tokenB,
1020         uint256 liquidity,
1021         uint256 amountAMin,
1022         uint256 amountBMin,
1023         address to,
1024         uint256 deadline,
1025         bool approveMax,
1026         uint8 v,
1027         bytes32 r,
1028         bytes32 s
1029     ) external returns (uint256 amountA, uint256 amountB);
1030 
1031     function removeLiquidityETHWithPermit(
1032         address token,
1033         uint256 liquidity,
1034         uint256 amountTokenMin,
1035         uint256 amountETHMin,
1036         address to,
1037         uint256 deadline,
1038         bool approveMax,
1039         uint8 v,
1040         bytes32 r,
1041         bytes32 s
1042     ) external returns (uint256 amountToken, uint256 amountETH);
1043 
1044     function swapExactTokensForTokens(
1045         uint256 amountIn,
1046         uint256 amountOutMin,
1047         address[] calldata path,
1048         address to,
1049         uint256 deadline
1050     ) external returns (uint256[] memory amounts);
1051 
1052     function swapTokensForExactTokens(
1053         uint256 amountOut,
1054         uint256 amountInMax,
1055         address[] calldata path,
1056         address to,
1057         uint256 deadline
1058     ) external returns (uint256[] memory amounts);
1059 
1060     function swapExactETHForTokens(
1061         uint256 amountOutMin,
1062         address[] calldata path,
1063         address to,
1064         uint256 deadline
1065     ) external payable returns (uint256[] memory amounts);
1066 
1067     function swapTokensForExactETH(
1068         uint256 amountOut,
1069         uint256 amountInMax,
1070         address[] calldata path,
1071         address to,
1072         uint256 deadline
1073     ) external returns (uint256[] memory amounts);
1074 
1075     function swapExactTokensForETH(
1076         uint256 amountIn,
1077         uint256 amountOutMin,
1078         address[] calldata path,
1079         address to,
1080         uint256 deadline
1081     ) external returns (uint256[] memory amounts);
1082 
1083     function swapETHForExactTokens(
1084         uint256 amountOut,
1085         address[] calldata path,
1086         address to,
1087         uint256 deadline
1088     ) external payable returns (uint256[] memory amounts);
1089 
1090     function quote(
1091         uint256 amountA,
1092         uint256 reserveA,
1093         uint256 reserveB
1094     ) external pure returns (uint256 amountB);
1095 
1096     function getAmountOut(
1097         uint256 amountIn,
1098         uint256 reserveIn,
1099         uint256 reserveOut
1100     ) external pure returns (uint256 amountOut);
1101 
1102     function getAmountIn(
1103         uint256 amountOut,
1104         uint256 reserveIn,
1105         uint256 reserveOut
1106     ) external pure returns (uint256 amountIn);
1107 
1108     function getAmountsOut(uint256 amountIn, address[] calldata path)
1109         external
1110         view
1111         returns (uint256[] memory amounts);
1112 
1113     function getAmountsIn(uint256 amountOut, address[] calldata path)
1114         external
1115         view
1116         returns (uint256[] memory amounts);
1117 }
1118 
1119 // pragma solidity >=0.6.2;
1120 
1121 // import './IUniswapV2Router01.sol';
1122 
1123 interface IUniswapV2Router02 is IUniswapV2Router01 {
1124     function removeLiquidityETHSupportingFeeOnTransferTokens(
1125         address token,
1126         uint256 liquidity,
1127         uint256 amountTokenMin,
1128         uint256 amountETHMin,
1129         address to,
1130         uint256 deadline
1131     ) external returns (uint256 amountETH);
1132 
1133     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1134         address token,
1135         uint256 liquidity,
1136         uint256 amountTokenMin,
1137         uint256 amountETHMin,
1138         address to,
1139         uint256 deadline,
1140         bool approveMax,
1141         uint8 v,
1142         bytes32 r,
1143         bytes32 s
1144     ) external returns (uint256 amountETH);
1145 
1146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1147         uint256 amountIn,
1148         uint256 amountOutMin,
1149         address[] calldata path,
1150         address to,
1151         uint256 deadline
1152     ) external;
1153 
1154     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1155         uint256 amountOutMin,
1156         address[] calldata path,
1157         address to,
1158         uint256 deadline
1159     ) external payable;
1160 
1161     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1162         uint256 amountIn,
1163         uint256 amountOutMin,
1164         address[] calldata path,
1165         address to,
1166         uint256 deadline
1167     ) external;
1168 }
1169 
1170 contract CryptoFightClubToken is ERC20, Ownable {
1171     using SafeMath for uint256;
1172 
1173     IUniswapV2Router02 public immutable uniswapV2Router;
1174     address public uniswapV2Pair;
1175     address public constant deadAddress = address(0xdead);
1176 
1177     bool private swapping;
1178 
1179     address public marketingWallet;
1180 
1181     uint256 public maxTransactionAmount;
1182     uint256 public swapTokensAtAmount;
1183     uint256 public maxWallet;
1184 
1185     bool public tradingActive = false;
1186     bool public swapEnabled = false;
1187 
1188     uint256 public buyTotalFees;
1189     uint256 private buyMarketingFee;
1190     uint256 private buyLiquidityFee;
1191 
1192     uint256 public sellTotalFees;
1193     uint256 private sellMarketingFee;
1194     uint256 private sellLiquidityFee;
1195 
1196     uint256 private tokensForMarketing;
1197     uint256 private tokensForLiquidity;
1198     uint256 private previousFee;
1199 
1200     mapping(address => bool) private _isExcludedFromFees;
1201     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1202     mapping(address => bool) private automatedMarketMakerPairs;
1203 
1204     event ExcludeFromFees(address indexed account, bool isExcluded);
1205 
1206     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1207 
1208     event marketingWalletUpdated(
1209         address indexed newWallet,
1210         address indexed oldWallet
1211     );
1212 
1213     event SwapAndLiquify(
1214         uint256 tokensSwapped,
1215         uint256 ethReceived,
1216         uint256 tokensIntoLiquidity
1217     );
1218 
1219     constructor() ERC20("Crypto Fight Club", "CFC") {
1220         uniswapV2Router = IUniswapV2Router02(
1221             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1222         );
1223         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1224 
1225         uint256 totalSupply = 10_000_000 ether;
1226 
1227         maxTransactionAmount = (totalSupply * 2) / 100;
1228         maxWallet = totalSupply;
1229         swapTokensAtAmount = (totalSupply * 1) / 1000;
1230 
1231         buyMarketingFee = 20;
1232         buyLiquidityFee = 0;
1233         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1234 
1235         sellMarketingFee = 20;
1236         sellLiquidityFee = 0;
1237         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1238         previousFee = sellTotalFees;
1239 
1240         marketingWallet = 0x93b1e07ca231421336125C707D6C278fbd534750;
1241 
1242         excludeFromFees(owner(), true);
1243         excludeFromFees(address(this), true);
1244         excludeFromFees(deadAddress, true);
1245         excludeFromFees(marketingWallet, true);
1246 
1247         excludeFromMaxTransaction(owner(), true);
1248         excludeFromMaxTransaction(address(this), true);
1249         excludeFromMaxTransaction(deadAddress, true);
1250         excludeFromMaxTransaction(address(uniswapV2Router), true);
1251         excludeFromMaxTransaction(marketingWallet, true);
1252 
1253         _mint(msg.sender, totalSupply);
1254     }
1255 
1256     receive() external payable {}
1257 
1258     function burn(uint256 amount) external {
1259         _burn(msg.sender, amount);
1260     }
1261 
1262     function enableTrading() external onlyOwner {
1263         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1264             address(this),
1265             uniswapV2Router.WETH()
1266         );
1267         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1268         IERC20(uniswapV2Pair).approve(
1269             address(uniswapV2Router),
1270             type(uint256).max
1271         );
1272 
1273         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1274         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1275 
1276         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1277             address(this),
1278             balanceOf(address(this)),
1279             0,
1280             0,
1281             owner(),
1282             block.timestamp
1283         );
1284         tradingActive = true;
1285         swapEnabled = true;
1286     }
1287 
1288     function updateSwapTokensAtAmount(uint256 newAmount)
1289         external
1290         onlyOwner
1291         returns (bool)
1292     {
1293         require(
1294             newAmount >= (totalSupply() * 1) / 100000,
1295             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1296         );
1297         require(
1298             newAmount <= (totalSupply() * 5) / 1000,
1299             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1300         );
1301         swapTokensAtAmount = newAmount;
1302         return true;
1303     }
1304 
1305     function updateMaxWalletAndTxnAmount(
1306         uint256 newTxnNum,
1307         uint256 newMaxWalletNum
1308     ) external onlyOwner {
1309         require(
1310             newTxnNum >= ((totalSupply() * 5) / 1000),
1311             "ERC20: Cannot set maxTxn lower than 0.5%"
1312         );
1313         require(
1314             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1315             "ERC20: Cannot set maxWallet lower than 0.5%"
1316         );
1317         maxWallet = newMaxWalletNum;
1318         maxTransactionAmount = newTxnNum;
1319     }
1320 
1321     function excludeFromMaxTransaction(address updAds, bool isEx)
1322         public
1323         onlyOwner
1324     {
1325         _isExcludedMaxTransactionAmount[updAds] = isEx;
1326     }
1327 
1328     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1329         external
1330         onlyOwner
1331     {
1332         buyMarketingFee = _marketingFee;
1333         buyLiquidityFee = _liquidityFee;
1334         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1335         require(buyTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1336     }
1337 
1338     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1339         external
1340         onlyOwner
1341     {
1342         sellMarketingFee = _marketingFee;
1343         sellLiquidityFee = _liquidityFee;
1344         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1345         previousFee = sellTotalFees;
1346         require(sellTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1347     }
1348 
1349     function updateMarketingWallet(address _marketingWallet)
1350         external
1351         onlyOwner
1352     {
1353         require(_marketingWallet != address(0), "ERC20: Address 0");
1354         address oldWallet = marketingWallet;
1355         marketingWallet = _marketingWallet;
1356         emit marketingWalletUpdated(marketingWallet, oldWallet);
1357     }
1358 
1359     function excludeFromFees(address account, bool excluded) public onlyOwner {
1360         _isExcludedFromFees[account] = excluded;
1361         emit ExcludeFromFees(account, excluded);
1362     }
1363 
1364     function withdrawStuckETH() public onlyOwner {
1365         bool success;
1366         (success, ) = address(msg.sender).call{value: address(this).balance}(
1367             ""
1368         );
1369     }
1370 
1371     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1372         automatedMarketMakerPairs[pair] = value;
1373 
1374         emit SetAutomatedMarketMakerPair(pair, value);
1375     }
1376 
1377     function isExcludedFromFees(address account) public view returns (bool) {
1378         return _isExcludedFromFees[account];
1379     }
1380 
1381     function _transfer(
1382         address from,
1383         address to,
1384         uint256 amount
1385     ) internal override {
1386         require(from != address(0), "ERC20: transfer from the zero address");
1387         require(to != address(0), "ERC20: transfer to the zero address");
1388 
1389         if (amount == 0) {
1390             super._transfer(from, to, 0);
1391             return;
1392         }
1393 
1394         if (
1395             from != owner() &&
1396             to != owner() &&
1397             to != address(0) &&
1398             to != deadAddress &&
1399             !swapping
1400         ) {
1401             if (!tradingActive) {
1402                 require(
1403                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1404                     "ERC20: Trading is not active."
1405                 );
1406             }
1407 
1408             //when buy
1409             if (
1410                 automatedMarketMakerPairs[from] &&
1411                 !_isExcludedMaxTransactionAmount[to]
1412             ) {
1413                 require(
1414                     amount <= maxTransactionAmount,
1415                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1416                 );
1417                 require(
1418                     amount + balanceOf(to) <= maxWallet,
1419                     "ERC20: Max wallet exceeded"
1420                 );
1421             }
1422             //when sell
1423             else if (
1424                 automatedMarketMakerPairs[to] &&
1425                 !_isExcludedMaxTransactionAmount[from]
1426             ) {
1427                 require(
1428                     amount <= maxTransactionAmount,
1429                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1430                 );
1431             } else if (!_isExcludedMaxTransactionAmount[to]) {
1432                 require(
1433                     amount + balanceOf(to) <= maxWallet,
1434                     "ERC20: Max wallet exceeded"
1435                 );
1436             }
1437         }
1438 
1439         uint256 contractTokenBalance = balanceOf(address(this));
1440 
1441         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1442 
1443         if (
1444             canSwap &&
1445             swapEnabled &&
1446             !swapping &&
1447             !automatedMarketMakerPairs[from] &&
1448             !_isExcludedFromFees[from] &&
1449             !_isExcludedFromFees[to]
1450         ) {
1451             swapping = true;
1452 
1453             swapBack();
1454 
1455             swapping = false;
1456         }
1457 
1458         bool takeFee = !swapping;
1459 
1460         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1461             takeFee = false;
1462         }
1463 
1464         uint256 fees = 0;
1465 
1466         if (takeFee) {
1467             // on sell
1468             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1469                 fees = amount.mul(sellTotalFees).div(100);
1470                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1471                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1472             }
1473             // on buy
1474             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1475                 fees = amount.mul(buyTotalFees).div(100);
1476                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1477                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1478             }
1479 
1480             if (fees > 0) {
1481                 super._transfer(from, address(this), fees);
1482             }
1483 
1484             amount -= fees;
1485         }
1486 
1487         super._transfer(from, to, amount);
1488         sellTotalFees = previousFee;
1489     }
1490 
1491     function swapTokensForEth(uint256 tokenAmount) private {
1492         address[] memory path = new address[](2);
1493         path[0] = address(this);
1494         path[1] = uniswapV2Router.WETH();
1495 
1496         _approve(address(this), address(uniswapV2Router), tokenAmount);
1497 
1498         // make the swap
1499         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1500             tokenAmount,
1501             0,
1502             path,
1503             address(this),
1504             block.timestamp
1505         );
1506     }
1507 
1508     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1509         _approve(address(this), address(uniswapV2Router), tokenAmount);
1510 
1511         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1512             address(this),
1513             tokenAmount,
1514             0,
1515             0,
1516             owner(),
1517             block.timestamp
1518         );
1519     }
1520 
1521     function swapBack() private {
1522         uint256 contractBalance = balanceOf(address(this));
1523         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1524         bool success;
1525 
1526         if (contractBalance == 0 || totalTokensToSwap == 0) {
1527             return;
1528         }
1529 
1530         if (contractBalance > swapTokensAtAmount * 20) {
1531             contractBalance = swapTokensAtAmount * 20;
1532         }
1533 
1534         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1535             totalTokensToSwap /
1536             2;
1537         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1538 
1539         uint256 initialETHBalance = address(this).balance;
1540 
1541         swapTokensForEth(amountToSwapForETH);
1542 
1543         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1544 
1545         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1546             totalTokensToSwap
1547         );
1548 
1549         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1550 
1551         tokensForLiquidity = 0;
1552         tokensForMarketing = 0;
1553 
1554         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1555             addLiquidity(liquidityTokens, ethForLiquidity);
1556             emit SwapAndLiquify(
1557                 amountToSwapForETH,
1558                 ethForLiquidity,
1559                 tokensForLiquidity
1560             );
1561         }
1562 
1563         (success, ) = address(marketingWallet).call{
1564             value: address(this).balance
1565         }("");
1566     }
1567 }