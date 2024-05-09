1 //                              ███████╗██╗░░░██╗███╗░░██╗██████╗░███████╗██████╗░
2 //                              ██╔════╝██║░░░██║████╗░██║██╔══██╗██╔════╝██╔══██╗
3 //                              █████╗░░██║░░░██║██╔██╗██║██║░░██║█████╗░░██║░░██║
4 //                              ██╔══╝░░██║░░░██║██║╚████║██║░░██║██╔══╝░░██║░░██║
5 //                              ██║░░░░░╚██████╔╝██║░╚███║██████╔╝███████╗██████╔╝
6 //                              ╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═════╝░╚══════╝╚═════╝░
7 //           The worlds first Low Cap Prop Trading Firm. We give on-chain traders more to trade with.
8 //
9 //                                           https://fundedeth.com
10 //                                         https://t.me/fundedportal
11 //                                       https://discord.gg/fundedeth
12 //                                     https://twitter.com/fundedcoineth
13 //
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.17;
18 pragma experimental ABIEncoderV2;
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
21 
22 // pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
45 
46 // pragma solidity ^0.8.0;
47 
48 // import "../utils/Context.sol";
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor() {
74         _transferOwnership(_msgSender());
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         _checkOwner();
82         _;
83     }
84 
85     /**
86      * @dev Returns the address of the current owner.
87      */
88     function owner() public view virtual returns (address) {
89         return _owner;
90     }
91 
92     /**
93      * @dev Throws if the sender is not the owner.
94      */
95     function _checkOwner() internal view virtual {
96         require(owner() == _msgSender(), "Ownable: caller is not the owner");
97     }
98 
99     /**
100      * @dev Leaves the contract without owner. It will not be possible to call
101      * `onlyOwner` functions. Can only be called by the current owner.
102      *
103      * NOTE: Renouncing ownership will leave the contract without an owner,
104      * thereby disabling any functionality that is only available to the owner.
105      */
106     function renounceOwnership() public virtual onlyOwner {
107         _transferOwnership(address(0));
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Can only be called by the current owner.
113      */
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(
116             newOwner != address(0),
117             "Ownable: new owner is the zero address"
118         );
119         _transferOwnership(newOwner);
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Internal function without access restriction.
125      */
126     function _transferOwnership(address newOwner) internal virtual {
127         address oldOwner = _owner;
128         _owner = newOwner;
129         emit OwnershipTransferred(oldOwner, newOwner);
130     }
131 }
132 
133 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
134 
135 // pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Interface of the ERC20 standard as defined in the EIP.
139  */
140 interface IERC20 {
141     /**
142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
143      * another (`to`).
144      *
145      * Note that `value` may be zero.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     /**
150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
151      * a call to {approve}. `value` is the new allowance.
152      */
153     event Approval(
154         address indexed owner,
155         address indexed spender,
156         uint256 value
157     );
158 
159     /**
160      * @dev Returns the amount of tokens in existence.
161      */
162     function totalSupply() external view returns (uint256);
163 
164     /**
165      * @dev Returns the amount of tokens owned by `account`.
166      */
167     function balanceOf(address account) external view returns (uint256);
168 
169     /**
170      * @dev Moves `amount` tokens from the caller's account to `to`.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transfer(address to, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Returns the remaining number of tokens that `spender` will be
180      * allowed to spend on behalf of `owner` through {transferFrom}. This is
181      * zero by default.
182      *
183      * This value changes when {approve} or {transferFrom} are called.
184      */
185     function allowance(address owner, address spender)
186         external
187         view
188         returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `from` to `to` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 amount
219     ) external returns (bool);
220 }
221 
222 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
223 
224 // pragma solidity ^0.8.0;
225 
226 // import "../IERC20.sol";
227 
228 /**
229  * @dev Interface for the optional metadata functions from the ERC20 standard.
230  *
231  * _Available since v4.1._
232  */
233 interface IERC20Metadata is IERC20 {
234     /**
235      * @dev Returns the name of the token.
236      */
237     function name() external view returns (string memory);
238 
239     /**
240      * @dev Returns the symbol of the token.
241      */
242     function symbol() external view returns (string memory);
243 
244     /**
245      * @dev Returns the decimals places of the token.
246      */
247     function decimals() external view returns (uint8);
248 }
249 
250 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
251 
252 // pragma solidity ^0.8.0;
253 
254 // import "./IERC20.sol";
255 // import "./extensions/IERC20Metadata.sol";
256 // import "../../utils/Context.sol";
257 
258 /**
259  * @dev Implementation of the {IERC20} interface.
260  *
261  * This implementation is agnostic to the way tokens are created. This means
262  * that a supply mechanism has to be added in a derived contract using {_mint}.
263  * For a generic mechanism see {ERC20PresetMinterPauser}.
264  *
265  * TIP: For a detailed writeup see our guide
266  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
267  * to implement supply mechanisms].
268  *
269  * The default value of {decimals} is 18. To change this, you should override
270  * this function so it returns a different value.
271  *
272  * We have followed general OpenZeppelin Contracts guidelines: functions revert
273  * instead returning `false` on failure. This behavior is nonetheless
274  * conventional and does not conflict with the expectations of ERC20
275  * applications.
276  *
277  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
278  * This allows applications to reconstruct the allowance for all accounts just
279  * by listening to said events. Other implementations of the EIP may not emit
280  * these events, as it isn't required by the specification.
281  *
282  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
283  * functions have been added to mitigate the well-known issues around setting
284  * allowances. See {IERC20-approve}.
285  */
286 contract ERC20 is Context, IERC20, IERC20Metadata {
287     mapping(address => uint256) private _balances;
288 
289     mapping(address => mapping(address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     string private _name;
294     string private _symbol;
295 
296     /**
297      * @dev Sets the values for {name} and {symbol}.
298      *
299      * All two of these values are immutable: they can only be set once during
300      * construction.
301      */
302     constructor(string memory name_, string memory symbol_) {
303         _name = name_;
304         _symbol = symbol_;
305     }
306 
307     /**
308      * @dev Returns the name of the token.
309      */
310     function name() public view virtual override returns (string memory) {
311         return _name;
312     }
313 
314     /**
315      * @dev Returns the symbol of the token, usually a shorter version of the
316      * name.
317      */
318     function symbol() public view virtual override returns (string memory) {
319         return _symbol;
320     }
321 
322     /**
323      * @dev Returns the number of decimals used to get its user representation.
324      * For example, if `decimals` equals `2`, a balance of `505` tokens should
325      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
326      *
327      * Tokens usually opt for a value of 18, imitating the relationship between
328      * Ether and Wei. This is the default value returned by this function, unless
329      * it's overridden.
330      *
331      * NOTE: This information is only used for _display_ purposes: it in
332      * no way affects any of the arithmetic of the contract, including
333      * {IERC20-balanceOf} and {IERC20-transfer}.
334      */
335     function decimals() public view virtual override returns (uint8) {
336         return 18;
337     }
338 
339     /**
340      * @dev See {IERC20-totalSupply}.
341      */
342     function totalSupply() public view virtual override returns (uint256) {
343         return _totalSupply;
344     }
345 
346     /**
347      * @dev See {IERC20-balanceOf}.
348      */
349     function balanceOf(address account)
350         public
351         view
352         virtual
353         override
354         returns (uint256)
355     {
356         return _balances[account];
357     }
358 
359     /**
360      * @dev See {IERC20-transfer}.
361      *
362      * Requirements:
363      *
364      * - `to` cannot be the zero address.
365      * - the caller must have a balance of at least `amount`.
366      */
367     function transfer(address to, uint256 amount)
368         public
369         virtual
370         override
371         returns (bool)
372     {
373         address owner = _msgSender();
374         _transfer(owner, to, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-allowance}.
380      */
381     function allowance(address owner, address spender)
382         public
383         view
384         virtual
385         override
386         returns (uint256)
387     {
388         return _allowances[owner][spender];
389     }
390 
391     /**
392      * @dev See {IERC20-approve}.
393      *
394      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
395      * `transferFrom`. This is semantically equivalent to an infinite approval.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function approve(address spender, uint256 amount)
402         public
403         virtual
404         override
405         returns (bool)
406     {
407         address owner = _msgSender();
408         _approve(owner, spender, amount);
409         return true;
410     }
411 
412     /**
413      * @dev See {IERC20-transferFrom}.
414      *
415      * Emits an {Approval} event indicating the updated allowance. This is not
416      * required by the EIP. See the note at the beginning of {ERC20}.
417      *
418      * NOTE: Does not update the allowance if the current allowance
419      * is the maximum `uint256`.
420      *
421      * Requirements:
422      *
423      * - `from` and `to` cannot be the zero address.
424      * - `from` must have a balance of at least `amount`.
425      * - the caller must have allowance for ``from``'s tokens of at least
426      * `amount`.
427      */
428     function transferFrom(
429         address from,
430         address to,
431         uint256 amount
432     ) public virtual override returns (bool) {
433         address spender = _msgSender();
434         _spendAllowance(from, spender, amount);
435         _transfer(from, to, amount);
436         return true;
437     }
438 
439     /**
440      * @dev Atomically increases the allowance granted to `spender` by the caller.
441      *
442      * This is an alternative to {approve} that can be used as a mitigation for
443      * problems described in {IERC20-approve}.
444      *
445      * Emits an {Approval} event indicating the updated allowance.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      */
451     function increaseAllowance(address spender, uint256 addedValue)
452         public
453         virtual
454         returns (bool)
455     {
456         address owner = _msgSender();
457         _approve(owner, spender, allowance(owner, spender) + addedValue);
458         return true;
459     }
460 
461     /**
462      * @dev Atomically decreases the allowance granted to `spender` by the caller.
463      *
464      * This is an alternative to {approve} that can be used as a mitigation for
465      * problems described in {IERC20-approve}.
466      *
467      * Emits an {Approval} event indicating the updated allowance.
468      *
469      * Requirements:
470      *
471      * - `spender` cannot be the zero address.
472      * - `spender` must have allowance for the caller of at least
473      * `subtractedValue`.
474      */
475     function decreaseAllowance(address spender, uint256 subtractedValue)
476         public
477         virtual
478         returns (bool)
479     {
480         address owner = _msgSender();
481         uint256 currentAllowance = allowance(owner, spender);
482         require(
483             currentAllowance >= subtractedValue,
484             "ERC20: decreased allowance below zero"
485         );
486         unchecked {
487             _approve(owner, spender, currentAllowance - subtractedValue);
488         }
489 
490         return true;
491     }
492 
493     /**
494      * @dev Moves `amount` of tokens from `from` to `to`.
495      *
496      * This internal function is equivalent to {transfer}, and can be used to
497      * e.g. implement automatic token fees, slashing mechanisms, etc.
498      *
499      * Emits a {Transfer} event.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `from` must have a balance of at least `amount`.
506      */
507     function _transfer(
508         address from,
509         address to,
510         uint256 amount
511     ) internal virtual {
512         require(from != address(0), "ERC20: transfer from the zero address");
513         require(to != address(0), "ERC20: transfer to the zero address");
514 
515         _beforeTokenTransfer(from, to, amount);
516 
517         uint256 fromBalance = _balances[from];
518         require(
519             fromBalance >= amount,
520             "ERC20: transfer amount exceeds balance"
521         );
522         unchecked {
523             _balances[from] = fromBalance - amount;
524             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
525             // decrementing then incrementing.
526             _balances[to] += amount;
527         }
528 
529         emit Transfer(from, to, amount);
530 
531         _afterTokenTransfer(from, to, amount);
532     }
533 
534     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
535      * the total supply.
536      *
537      * Emits a {Transfer} event with `from` set to the zero address.
538      *
539      * Requirements:
540      *
541      * - `account` cannot be the zero address.
542      */
543     function _mint(address account, uint256 amount) internal virtual {
544         require(account != address(0), "ERC20: mint to the zero address");
545 
546         _beforeTokenTransfer(address(0), account, amount);
547 
548         _totalSupply += amount;
549         unchecked {
550             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
551             _balances[account] += amount;
552         }
553         emit Transfer(address(0), account, amount);
554 
555         _afterTokenTransfer(address(0), account, amount);
556     }
557 
558     /**
559      * @dev Destroys `amount` tokens from `account`, reducing the
560      * total supply.
561      *
562      * Emits a {Transfer} event with `to` set to the zero address.
563      *
564      * Requirements:
565      *
566      * - `account` cannot be the zero address.
567      * - `account` must have at least `amount` tokens.
568      */
569     function _burn(address account, uint256 amount) internal virtual {
570         require(account != address(0), "ERC20: burn from the zero address");
571 
572         _beforeTokenTransfer(account, address(0), amount);
573 
574         uint256 accountBalance = _balances[account];
575         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
576         unchecked {
577             _balances[account] = accountBalance - amount;
578             // Overflow not possible: amount <= accountBalance <= totalSupply.
579             _totalSupply -= amount;
580         }
581 
582         emit Transfer(account, address(0), amount);
583 
584         _afterTokenTransfer(account, address(0), amount);
585     }
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
589      *
590      * This internal function is equivalent to `approve`, and can be used to
591      * e.g. set automatic allowances for certain subsystems, etc.
592      *
593      * Emits an {Approval} event.
594      *
595      * Requirements:
596      *
597      * - `owner` cannot be the zero address.
598      * - `spender` cannot be the zero address.
599      */
600     function _approve(
601         address owner,
602         address spender,
603         uint256 amount
604     ) internal virtual {
605         require(owner != address(0), "ERC20: approve from the zero address");
606         require(spender != address(0), "ERC20: approve to the zero address");
607 
608         _allowances[owner][spender] = amount;
609         emit Approval(owner, spender, amount);
610     }
611 
612     /**
613      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
614      *
615      * Does not update the allowance amount in case of infinite allowance.
616      * Revert if not enough allowance is available.
617      *
618      * Might emit an {Approval} event.
619      */
620     function _spendAllowance(
621         address owner,
622         address spender,
623         uint256 amount
624     ) internal virtual {
625         uint256 currentAllowance = allowance(owner, spender);
626         if (currentAllowance != type(uint256).max) {
627             require(
628                 currentAllowance >= amount,
629                 "ERC20: insufficient allowance"
630             );
631             unchecked {
632                 _approve(owner, spender, currentAllowance - amount);
633             }
634         }
635     }
636 
637     /**
638      * @dev Hook that is called before any transfer of tokens. This includes
639      * minting and burning.
640      *
641      * Calling conditions:
642      *
643      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
644      * will be transferred to `to`.
645      * - when `from` is zero, `amount` tokens will be minted for `to`.
646      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
647      * - `from` and `to` are never both zero.
648      *
649      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
650      */
651     function _beforeTokenTransfer(
652         address from,
653         address to,
654         uint256 amount
655     ) internal virtual {}
656 
657     /**
658      * @dev Hook that is called after any transfer of tokens. This includes
659      * minting and burning.
660      *
661      * Calling conditions:
662      *
663      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
664      * has been transferred to `to`.
665      * - when `from` is zero, `amount` tokens have been minted for `to`.
666      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
667      * - `from` and `to` are never both zero.
668      *
669      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
670      */
671     function _afterTokenTransfer(
672         address from,
673         address to,
674         uint256 amount
675     ) internal virtual {}
676 }
677 
678 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
679 
680 // pragma solidity ^0.8.0;
681 
682 // CAUTION
683 // This version of SafeMath should only be used with Solidity 0.8 or later,
684 // because it relies on the compiler's built in overflow checks.
685 
686 /**
687  * @dev Wrappers over Solidity's arithmetic operations.
688  *
689  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
690  * now has built in overflow checking.
691  */
692 library SafeMath {
693     /**
694      * @dev Returns the addition of two unsigned integers, with an overflow flag.
695      *
696      * _Available since v3.4._
697      */
698     function tryAdd(uint256 a, uint256 b)
699         internal
700         pure
701         returns (bool, uint256)
702     {
703         unchecked {
704             uint256 c = a + b;
705             if (c < a) return (false, 0);
706             return (true, c);
707         }
708     }
709 
710     /**
711      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
712      *
713      * _Available since v3.4._
714      */
715     function trySub(uint256 a, uint256 b)
716         internal
717         pure
718         returns (bool, uint256)
719     {
720         unchecked {
721             if (b > a) return (false, 0);
722             return (true, a - b);
723         }
724     }
725 
726     /**
727      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
728      *
729      * _Available since v3.4._
730      */
731     function tryMul(uint256 a, uint256 b)
732         internal
733         pure
734         returns (bool, uint256)
735     {
736         unchecked {
737             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
738             // benefit is lost if 'b' is also tested.
739             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
740             if (a == 0) return (true, 0);
741             uint256 c = a * b;
742             if (c / a != b) return (false, 0);
743             return (true, c);
744         }
745     }
746 
747     /**
748      * @dev Returns the division of two unsigned integers, with a division by zero flag.
749      *
750      * _Available since v3.4._
751      */
752     function tryDiv(uint256 a, uint256 b)
753         internal
754         pure
755         returns (bool, uint256)
756     {
757         unchecked {
758             if (b == 0) return (false, 0);
759             return (true, a / b);
760         }
761     }
762 
763     /**
764      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
765      *
766      * _Available since v3.4._
767      */
768     function tryMod(uint256 a, uint256 b)
769         internal
770         pure
771         returns (bool, uint256)
772     {
773         unchecked {
774             if (b == 0) return (false, 0);
775             return (true, a % b);
776         }
777     }
778 
779     /**
780      * @dev Returns the addition of two unsigned integers, reverting on
781      * overflow.
782      *
783      * Counterpart to Solidity's `+` operator.
784      *
785      * Requirements:
786      *
787      * - Addition cannot overflow.
788      */
789     function add(uint256 a, uint256 b) internal pure returns (uint256) {
790         return a + b;
791     }
792 
793     /**
794      * @dev Returns the subtraction of two unsigned integers, reverting on
795      * overflow (when the result is negative).
796      *
797      * Counterpart to Solidity's `-` operator.
798      *
799      * Requirements:
800      *
801      * - Subtraction cannot overflow.
802      */
803     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
804         return a - b;
805     }
806 
807     /**
808      * @dev Returns the multiplication of two unsigned integers, reverting on
809      * overflow.
810      *
811      * Counterpart to Solidity's `*` operator.
812      *
813      * Requirements:
814      *
815      * - Multiplication cannot overflow.
816      */
817     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
818         return a * b;
819     }
820 
821     /**
822      * @dev Returns the integer division of two unsigned integers, reverting on
823      * division by zero. The result is rounded towards zero.
824      *
825      * Counterpart to Solidity's `/` operator.
826      *
827      * Requirements:
828      *
829      * - The divisor cannot be zero.
830      */
831     function div(uint256 a, uint256 b) internal pure returns (uint256) {
832         return a / b;
833     }
834 
835     /**
836      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
837      * reverting when dividing by zero.
838      *
839      * Counterpart to Solidity's `%` operator. This function uses a `revert`
840      * opcode (which leaves remaining gas untouched) while Solidity uses an
841      * invalid opcode to revert (consuming all remaining gas).
842      *
843      * Requirements:
844      *
845      * - The divisor cannot be zero.
846      */
847     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
848         return a % b;
849     }
850 
851     /**
852      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
853      * overflow (when the result is negative).
854      *
855      * CAUTION: This function is deprecated because it requires allocating memory for the error
856      * message unnecessarily. For custom revert reasons use {trySub}.
857      *
858      * Counterpart to Solidity's `-` operator.
859      *
860      * Requirements:
861      *
862      * - Subtraction cannot overflow.
863      */
864     function sub(
865         uint256 a,
866         uint256 b,
867         string memory errorMessage
868     ) internal pure returns (uint256) {
869         unchecked {
870             require(b <= a, errorMessage);
871             return a - b;
872         }
873     }
874 
875     /**
876      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
877      * division by zero. The result is rounded towards zero.
878      *
879      * Counterpart to Solidity's `/` operator. Note: this function uses a
880      * `revert` opcode (which leaves remaining gas untouched) while Solidity
881      * uses an invalid opcode to revert (consuming all remaining gas).
882      *
883      * Requirements:
884      *
885      * - The divisor cannot be zero.
886      */
887     function div(
888         uint256 a,
889         uint256 b,
890         string memory errorMessage
891     ) internal pure returns (uint256) {
892         unchecked {
893             require(b > 0, errorMessage);
894             return a / b;
895         }
896     }
897 
898     /**
899      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
900      * reverting with custom message when dividing by zero.
901      *
902      * CAUTION: This function is deprecated because it requires allocating memory for the error
903      * message unnecessarily. For custom revert reasons use {tryMod}.
904      *
905      * Counterpart to Solidity's `%` operator. This function uses a `revert`
906      * opcode (which leaves remaining gas untouched) while Solidity uses an
907      * invalid opcode to revert (consuming all remaining gas).
908      *
909      * Requirements:
910      *
911      * - The divisor cannot be zero.
912      */
913     function mod(
914         uint256 a,
915         uint256 b,
916         string memory errorMessage
917     ) internal pure returns (uint256) {
918         unchecked {
919             require(b > 0, errorMessage);
920             return a % b;
921         }
922     }
923 }
924 
925 // pragma solidity >=0.5.0;
926 
927 interface IUniswapV2Factory {
928     event PairCreated(
929         address indexed token0,
930         address indexed token1,
931         address pair,
932         uint256
933     );
934 
935     function feeTo() external view returns (address);
936 
937     function feeToSetter() external view returns (address);
938 
939     function getPair(address tokenA, address tokenB)
940         external
941         view
942         returns (address pair);
943 
944     function allPairs(uint256) external view returns (address pair);
945 
946     function allPairsLength() external view returns (uint256);
947 
948     function createPair(address tokenA, address tokenB)
949         external
950         returns (address pair);
951 
952     function setFeeTo(address) external;
953 
954     function setFeeToSetter(address) external;
955 }
956 
957 // pragma solidity >=0.6.2;
958 
959 interface IUniswapV2Router01 {
960     function factory() external pure returns (address);
961 
962     function WETH() external pure returns (address);
963 
964     function addLiquidity(
965         address tokenA,
966         address tokenB,
967         uint256 amountADesired,
968         uint256 amountBDesired,
969         uint256 amountAMin,
970         uint256 amountBMin,
971         address to,
972         uint256 deadline
973     )
974         external
975         returns (
976             uint256 amountA,
977             uint256 amountB,
978             uint256 liquidity
979         );
980 
981     function addLiquidityETH(
982         address token,
983         uint256 amountTokenDesired,
984         uint256 amountTokenMin,
985         uint256 amountETHMin,
986         address to,
987         uint256 deadline
988     )
989         external
990         payable
991         returns (
992             uint256 amountToken,
993             uint256 amountETH,
994             uint256 liquidity
995         );
996 
997     function removeLiquidity(
998         address tokenA,
999         address tokenB,
1000         uint256 liquidity,
1001         uint256 amountAMin,
1002         uint256 amountBMin,
1003         address to,
1004         uint256 deadline
1005     ) external returns (uint256 amountA, uint256 amountB);
1006 
1007     function removeLiquidityETH(
1008         address token,
1009         uint256 liquidity,
1010         uint256 amountTokenMin,
1011         uint256 amountETHMin,
1012         address to,
1013         uint256 deadline
1014     ) external returns (uint256 amountToken, uint256 amountETH);
1015 
1016     function removeLiquidityWithPermit(
1017         address tokenA,
1018         address tokenB,
1019         uint256 liquidity,
1020         uint256 amountAMin,
1021         uint256 amountBMin,
1022         address to,
1023         uint256 deadline,
1024         bool approveMax,
1025         uint8 v,
1026         bytes32 r,
1027         bytes32 s
1028     ) external returns (uint256 amountA, uint256 amountB);
1029 
1030     function removeLiquidityETHWithPermit(
1031         address token,
1032         uint256 liquidity,
1033         uint256 amountTokenMin,
1034         uint256 amountETHMin,
1035         address to,
1036         uint256 deadline,
1037         bool approveMax,
1038         uint8 v,
1039         bytes32 r,
1040         bytes32 s
1041     ) external returns (uint256 amountToken, uint256 amountETH);
1042 
1043     function swapExactTokensForTokens(
1044         uint256 amountIn,
1045         uint256 amountOutMin,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline
1049     ) external returns (uint256[] memory amounts);
1050 
1051     function swapTokensForExactTokens(
1052         uint256 amountOut,
1053         uint256 amountInMax,
1054         address[] calldata path,
1055         address to,
1056         uint256 deadline
1057     ) external returns (uint256[] memory amounts);
1058 
1059     function swapExactETHForTokens(
1060         uint256 amountOutMin,
1061         address[] calldata path,
1062         address to,
1063         uint256 deadline
1064     ) external payable returns (uint256[] memory amounts);
1065 
1066     function swapTokensForExactETH(
1067         uint256 amountOut,
1068         uint256 amountInMax,
1069         address[] calldata path,
1070         address to,
1071         uint256 deadline
1072     ) external returns (uint256[] memory amounts);
1073 
1074     function swapExactTokensForETH(
1075         uint256 amountIn,
1076         uint256 amountOutMin,
1077         address[] calldata path,
1078         address to,
1079         uint256 deadline
1080     ) external returns (uint256[] memory amounts);
1081 
1082     function swapETHForExactTokens(
1083         uint256 amountOut,
1084         address[] calldata path,
1085         address to,
1086         uint256 deadline
1087     ) external payable returns (uint256[] memory amounts);
1088 
1089     function quote(
1090         uint256 amountA,
1091         uint256 reserveA,
1092         uint256 reserveB
1093     ) external pure returns (uint256 amountB);
1094 
1095     function getAmountOut(
1096         uint256 amountIn,
1097         uint256 reserveIn,
1098         uint256 reserveOut
1099     ) external pure returns (uint256 amountOut);
1100 
1101     function getAmountIn(
1102         uint256 amountOut,
1103         uint256 reserveIn,
1104         uint256 reserveOut
1105     ) external pure returns (uint256 amountIn);
1106 
1107     function getAmountsOut(uint256 amountIn, address[] calldata path)
1108         external
1109         view
1110         returns (uint256[] memory amounts);
1111 
1112     function getAmountsIn(uint256 amountOut, address[] calldata path)
1113         external
1114         view
1115         returns (uint256[] memory amounts);
1116 }
1117 
1118 // pragma solidity >=0.6.2;
1119 
1120 // import './IUniswapV2Router01.sol';
1121 
1122 interface IUniswapV2Router02 is IUniswapV2Router01 {
1123     function removeLiquidityETHSupportingFeeOnTransferTokens(
1124         address token,
1125         uint256 liquidity,
1126         uint256 amountTokenMin,
1127         uint256 amountETHMin,
1128         address to,
1129         uint256 deadline
1130     ) external returns (uint256 amountETH);
1131 
1132     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
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
1143     ) external returns (uint256 amountETH);
1144 
1145     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1146         uint256 amountIn,
1147         uint256 amountOutMin,
1148         address[] calldata path,
1149         address to,
1150         uint256 deadline
1151     ) external;
1152 
1153     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1154         uint256 amountOutMin,
1155         address[] calldata path,
1156         address to,
1157         uint256 deadline
1158     ) external payable;
1159 
1160     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1161         uint256 amountIn,
1162         uint256 amountOutMin,
1163         address[] calldata path,
1164         address to,
1165         uint256 deadline
1166     ) external;
1167 }
1168 
1169 contract Funded is ERC20, Ownable {
1170     using SafeMath for uint256;
1171 
1172     IUniswapV2Router02 public immutable uniswapV2Router;
1173     address public uniswapV2Pair;
1174     address public constant deadAddress = address(0xdead);
1175 
1176     bool private swapping;
1177 
1178     address public marketingWallet;
1179     address public revShareWallet;
1180     address public fundedAccountWallet;
1181 
1182     uint256 public maxTransactionAmount;
1183     uint256 public swapTokensAtAmount;
1184     uint256 public maxWallet;
1185 
1186     bool public tradingActive = false;
1187     bool public swapEnabled = false;
1188 
1189     // Anti-bot and anti-whale mappings and variables
1190     mapping(address => bool) blacklisted;
1191 
1192     uint256 public buyTotalFees;
1193     uint256 private buyMarketingFee;
1194     uint256 private buyRevShareFee;
1195     uint256 private buyFundedAccountFee;
1196 
1197     uint256 public sellTotalFees;
1198     uint256 private sellMarketingFee;
1199     uint256 private sellRevShareFee;
1200     uint256 private sellFundedAccountFee;
1201 
1202     uint256 private tokensForMarketing;
1203     uint256 private tokensForRevShare;
1204     uint256 private tokensForFundedAccount;
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
1220     event revShareWalletUpdated(
1221         address indexed newWallet,
1222         address indexed oldWallet
1223     );
1224 
1225     event fundedAccountWalletUpdated(
1226         address indexed newWallet,
1227         address indexed oldWallet
1228     );
1229 
1230     constructor() ERC20("Funded", "FUNDED") {
1231         uint256 totalSupply = 1_000_000 ether;
1232         address disperse = 0xD152f549545093347A162Dce210e7293f1452150;
1233 
1234         uniswapV2Router = IUniswapV2Router02(
1235             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1236         );
1237         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1238 
1239         maxTransactionAmount = totalSupply;
1240         maxWallet = totalSupply;
1241         swapTokensAtAmount = (totalSupply * 5) / 10000;
1242 
1243         marketingWallet = address(0xE4862d399294709dd075586206213250b6e3Ea74);
1244         revShareWallet = address(0x804b9d0037d25F72b19950Ea2141A3Fd5e979fAD);
1245         fundedAccountWallet = address(
1246             0x013003f9BCb20aC57d04DBb56AFCE34F7d70571b
1247         );
1248 
1249         buyMarketingFee = 4;
1250         buyRevShareFee = 4;
1251         buyFundedAccountFee = 4;
1252         buyTotalFees = buyMarketingFee + buyRevShareFee + buyFundedAccountFee;
1253 
1254         sellMarketingFee = 4;
1255         sellRevShareFee = 4;
1256         sellFundedAccountFee = 4;
1257         sellTotalFees =
1258             sellMarketingFee +
1259             sellRevShareFee +
1260             sellFundedAccountFee;
1261 
1262         previousFee = sellTotalFees;
1263 
1264         excludeFromFees(owner(), true);
1265         excludeFromFees(address(this), true);
1266         excludeFromFees(deadAddress, true);
1267         excludeFromFees(marketingWallet, true);
1268         excludeFromFees(revShareWallet, true);
1269         excludeFromFees(fundedAccountWallet, true);
1270         excludeFromFees(disperse, true);
1271 
1272         excludeFromMaxTransaction(owner(), true);
1273         excludeFromMaxTransaction(address(this), true);
1274         excludeFromMaxTransaction(deadAddress, true);
1275         excludeFromMaxTransaction(address(uniswapV2Router), true);
1276         excludeFromMaxTransaction(marketingWallet, true);
1277         excludeFromMaxTransaction(revShareWallet, true);
1278         excludeFromMaxTransaction(fundedAccountWallet, true);
1279         excludeFromMaxTransaction(disperse, true);
1280 
1281         _mint(address(this), 155_375 ether);
1282         _mint(owner(), 844_625 ether);
1283     }
1284 
1285     receive() external payable {}
1286 
1287     function burn(uint256 amount) external {
1288         _burn(msg.sender, amount);
1289     }
1290 
1291     function enableTrading() external onlyOwner {
1292         require(!tradingActive, "Trading already active.");
1293 
1294         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1295             address(this),
1296             uniswapV2Router.WETH()
1297         );
1298         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1299         IERC20(uniswapV2Pair).approve(
1300             address(uniswapV2Router),
1301             type(uint256).max
1302         );
1303 
1304         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1305         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1306 
1307         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1308             address(this),
1309             106_376 ether,
1310             0,
1311             0,
1312             owner(),
1313             block.timestamp
1314         );
1315 
1316         maxTransactionAmount = (totalSupply() * 25) / 10000;
1317         maxWallet = (totalSupply() * 25) / 10000;
1318 
1319         tokensForMarketing = 16_332 ether;
1320         tokensForRevShare = 16_332 ether;
1321         tokensForFundedAccount = 16_332 ether;
1322 
1323         tradingActive = true;
1324         swapEnabled = true;
1325     }
1326 
1327     function updateSwapTokensAtAmount(uint256 newAmount)
1328         external
1329         onlyOwner
1330         returns (bool)
1331     {
1332         require(
1333             newAmount >= (totalSupply() * 1) / 100000,
1334             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1335         );
1336         require(
1337             newAmount <= (totalSupply() * 5) / 1000,
1338             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1339         );
1340         swapTokensAtAmount = newAmount;
1341         return true;
1342     }
1343 
1344     function updateMaxWalletAndTxnAmount(
1345         uint256 newTxnNum,
1346         uint256 newMaxWalletNum
1347     ) external onlyOwner {
1348         require(
1349             newTxnNum >= ((totalSupply() * 5) / 1000),
1350             "ERC20: Cannot set maxTxn lower than 0.5%"
1351         );
1352         require(
1353             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1354             "ERC20: Cannot set maxWallet lower than 0.5%"
1355         );
1356         maxWallet = newMaxWalletNum;
1357         maxTransactionAmount = newTxnNum;
1358     }
1359 
1360     function excludeFromMaxTransaction(address updAds, bool isEx)
1361         public
1362         onlyOwner
1363     {
1364         _isExcludedMaxTransactionAmount[updAds] = isEx;
1365     }
1366 
1367     function updateBuyFees(
1368         uint256 _marketingFee,
1369         uint256 _revShareFee,
1370         uint256 _fundedAccountFee
1371     ) external onlyOwner {
1372         buyMarketingFee = _marketingFee;
1373         buyRevShareFee = _revShareFee;
1374         buyFundedAccountFee = _fundedAccountFee;
1375         buyTotalFees = buyMarketingFee + buyRevShareFee + buyFundedAccountFee;
1376         require(buyTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1377     }
1378 
1379     function updateSellFees(
1380         uint256 _marketingFee,
1381         uint256 _revShareFee,
1382         uint256 _fundedAccountFee
1383     ) external onlyOwner {
1384         sellMarketingFee = _marketingFee;
1385         sellRevShareFee = _revShareFee;
1386         sellFundedAccountFee = _fundedAccountFee;
1387         sellTotalFees =
1388             sellMarketingFee +
1389             sellRevShareFee +
1390             sellFundedAccountFee;
1391         previousFee = sellTotalFees;
1392         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1393     }
1394 
1395     function updateMarketingWallet(address _marketingWallet)
1396         external
1397         onlyOwner
1398     {
1399         require(_marketingWallet != address(0), "ERC20: Address 0");
1400         address oldWallet = marketingWallet;
1401         marketingWallet = _marketingWallet;
1402         emit marketingWalletUpdated(marketingWallet, oldWallet);
1403     }
1404 
1405     function updateRevShareWallet(address _revShareWallet) external onlyOwner {
1406         require(_revShareWallet != address(0), "ERC20: Address 0");
1407         address oldWallet = revShareWallet;
1408         revShareWallet = _revShareWallet;
1409         emit revShareWalletUpdated(revShareWallet, oldWallet);
1410     }
1411 
1412     function updateFundedAccountWallet(address _fundedAccountWallet)
1413         external
1414         onlyOwner
1415     {
1416         require(_fundedAccountWallet != address(0), "ERC20: Address 0");
1417         address oldWallet = fundedAccountWallet;
1418         fundedAccountWallet = _fundedAccountWallet;
1419         emit fundedAccountWalletUpdated(fundedAccountWallet, oldWallet);
1420     }
1421 
1422     function excludeFromFees(address account, bool excluded) public onlyOwner {
1423         _isExcludedFromFees[account] = excluded;
1424         emit ExcludeFromFees(account, excluded);
1425     }
1426 
1427     function blacklist(address[] calldata accounts, bool value)
1428         public
1429         onlyOwner
1430     {
1431         for (uint256 i = 0; i < accounts.length; i++) {
1432             if (
1433                 (accounts[i] != uniswapV2Pair) &&
1434                 (accounts[i] != address(uniswapV2Router)) &&
1435                 (accounts[i] != address(this))
1436             ) blacklisted[accounts[i]] = value;
1437         }
1438     }
1439 
1440     function withdrawStuckETH() public onlyOwner {
1441         bool success;
1442         (success, ) = address(msg.sender).call{value: address(this).balance}(
1443             ""
1444         );
1445     }
1446 
1447     function withdrawStuckTokens(address tkn) public onlyOwner {
1448         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1449         uint256 amount = IERC20(tkn).balanceOf(address(this));
1450         IERC20(tkn).transfer(msg.sender, amount);
1451     }
1452 
1453     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1454         automatedMarketMakerPairs[pair] = value;
1455 
1456         emit SetAutomatedMarketMakerPair(pair, value);
1457     }
1458 
1459     function isExcludedFromFees(address account) public view returns (bool) {
1460         return _isExcludedFromFees[account];
1461     }
1462 
1463     function isBlacklisted(address account) public view returns (bool) {
1464         return blacklisted[account];
1465     }
1466 
1467     function _transfer(
1468         address from,
1469         address to,
1470         uint256 amount
1471     ) internal override {
1472         require(from != address(0), "ERC20: transfer from the zero address");
1473         require(to != address(0), "ERC20: transfer to the zero address");
1474         require(!blacklisted[from], "ERC20: bot detected");
1475         require(!blacklisted[msg.sender], "ERC20: bot detected");
1476         require(!blacklisted[tx.origin], "ERC20: bot detected");
1477 
1478         if (amount == 0) {
1479             super._transfer(from, to, 0);
1480             return;
1481         }
1482 
1483         if (
1484             from != owner() &&
1485             to != owner() &&
1486             to != address(0) &&
1487             to != deadAddress &&
1488             !swapping
1489         ) {
1490             if (!tradingActive) {
1491                 require(
1492                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1493                     "ERC20: Trading is not active."
1494                 );
1495             }
1496 
1497             //when buy
1498             if (
1499                 automatedMarketMakerPairs[from] &&
1500                 !_isExcludedMaxTransactionAmount[to]
1501             ) {
1502                 require(
1503                     amount <= maxTransactionAmount,
1504                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1505                 );
1506                 require(
1507                     amount + balanceOf(to) <= maxWallet,
1508                     "ERC20: Max wallet exceeded"
1509                 );
1510             }
1511             //when sell
1512             else if (
1513                 automatedMarketMakerPairs[to] &&
1514                 !_isExcludedMaxTransactionAmount[from]
1515             ) {
1516                 require(
1517                     amount <= maxTransactionAmount,
1518                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1519                 );
1520             } else if (!_isExcludedMaxTransactionAmount[to]) {
1521                 require(
1522                     amount + balanceOf(to) <= maxWallet,
1523                     "ERC20: Max wallet exceeded"
1524                 );
1525             }
1526         }
1527 
1528         uint256 contractTokenBalance = balanceOf(address(this));
1529 
1530         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1531 
1532         if (
1533             canSwap &&
1534             swapEnabled &&
1535             !swapping &&
1536             !automatedMarketMakerPairs[from] &&
1537             !_isExcludedFromFees[from] &&
1538             !_isExcludedFromFees[to]
1539         ) {
1540             swapping = true;
1541 
1542             swapBack();
1543 
1544             swapping = false;
1545         }
1546 
1547         bool takeFee = !swapping;
1548 
1549         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1550             takeFee = false;
1551         }
1552 
1553         uint256 fees = 0;
1554 
1555         if (takeFee) {
1556             // on sell
1557             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1558                 fees = amount.mul(sellTotalFees).div(100);
1559                 tokensForFundedAccount +=
1560                     (fees * sellFundedAccountFee) /
1561                     sellTotalFees;
1562                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1563                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1564             }
1565             // on buy
1566             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1567                 fees = amount.mul(buyTotalFees).div(100);
1568                 tokensForFundedAccount +=
1569                     (fees * buyFundedAccountFee) /
1570                     buyTotalFees;
1571                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1572                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1573             }
1574 
1575             if (fees > 0) {
1576                 super._transfer(from, address(this), fees);
1577             }
1578 
1579             amount -= fees;
1580         }
1581 
1582         super._transfer(from, to, amount);
1583         sellTotalFees = previousFee;
1584     }
1585 
1586     function swapTokensForEth(uint256 tokenAmount) private {
1587         address[] memory path = new address[](2);
1588         path[0] = address(this);
1589         path[1] = uniswapV2Router.WETH();
1590 
1591         _approve(address(this), address(uniswapV2Router), tokenAmount);
1592 
1593         // make the swap
1594         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1595             tokenAmount,
1596             0,
1597             path,
1598             address(this),
1599             block.timestamp
1600         );
1601     }
1602 
1603     function swapBack() private {
1604         uint256 contractBalance = balanceOf(address(this));
1605         uint256 totalTokensToSwap = tokensForFundedAccount +
1606             tokensForMarketing +
1607             tokensForRevShare;
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
1618         swapTokensForEth(contractBalance);
1619 
1620         uint256 ethBalance = address(this).balance;
1621 
1622         uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(
1623             totalTokensToSwap
1624         );
1625 
1626         uint256 ethForFundedAccount = ethBalance
1627             .mul(tokensForFundedAccount)
1628             .div(totalTokensToSwap);
1629 
1630         tokensForMarketing = 0;
1631         tokensForRevShare = 0;
1632         tokensForFundedAccount = 0;
1633 
1634         (success, ) = address(fundedAccountWallet).call{
1635             value: ethForFundedAccount
1636         }("");
1637 
1638         (success, ) = address(revShareWallet).call{value: ethForRevShare}("");
1639 
1640         (success, ) = address(marketingWallet).call{
1641             value: address(this).balance
1642         }("");
1643     }
1644 }