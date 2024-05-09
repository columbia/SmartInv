1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.20;
4 pragma experimental ABIEncoderV2;
5 
6 /*
7 
8     Twitter: https://twitter.com/TsaiShen
9     Telegram: https://t.me/ShenPortal
10 
11     The God of Wealth presides over a vast bureaucracy with many minor deities under his authority. A majestic figure robed in exquisite silks often he is pictured riding a black tiger, a golden $BIAO is always close to him.
12 
13 */
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 // pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
40 
41 // pragma solidity ^0.8.0;
42 
43 // import "../utils/Context.sol";
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(
61         address indexed previousOwner,
62         address indexed newOwner
63     );
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         _checkOwner();
77         _;
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view virtual returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if the sender is not the owner.
89      */
90     function _checkOwner() internal view virtual {
91         require(owner() == _msgSender(), "Ownable: caller is not the owner");
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby disabling any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(
111             newOwner != address(0),
112             "Ownable: new owner is the zero address"
113         );
114         _transferOwnership(newOwner);
115     }
116 
117     /**
118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
119      * Internal function without access restriction.
120      */
121     function _transferOwnership(address newOwner) internal virtual {
122         address oldOwner = _owner;
123         _owner = newOwner;
124         emit OwnershipTransferred(oldOwner, newOwner);
125     }
126 }
127 
128 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
129 
130 // pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Interface of the ERC20 standard as defined in the EIP.
134  */
135 interface IERC20 {
136     /**
137      * @dev Emitted when `value` tokens are moved from one account (`from`) to
138      * another (`to`).
139      *
140      * Note that `value` may be zero.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     /**
145      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
146      * a call to {approve}. `value` is the new allowance.
147      */
148     event Approval(
149         address indexed owner,
150         address indexed spender,
151         uint256 value
152     );
153 
154     /**
155      * @dev Returns the amount of tokens in existence.
156      */
157     function totalSupply() external view returns (uint256);
158 
159     /**
160      * @dev Returns the amount of tokens owned by `account`.
161      */
162     function balanceOf(address account) external view returns (uint256);
163 
164     /**
165      * @dev Moves `amount` tokens from the caller's account to `to`.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transfer(address to, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Returns the remaining number of tokens that `spender` will be
175      * allowed to spend on behalf of `owner` through {transferFrom}. This is
176      * zero by default.
177      *
178      * This value changes when {approve} or {transferFrom} are called.
179      */
180     function allowance(address owner, address spender)
181         external
182         view
183         returns (uint256);
184 
185     /**
186      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * IMPORTANT: Beware that changing an allowance with this method brings the risk
191      * that someone may use both the old and the new allowance by unfortunate
192      * transaction ordering. One possible solution to mitigate this race
193      * condition is to first reduce the spender's allowance to 0 and set the
194      * desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      *
197      * Emits an {Approval} event.
198      */
199     function approve(address spender, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Moves `amount` tokens from `from` to `to` using the
203      * allowance mechanism. `amount` is then deducted from the caller's
204      * allowance.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(
211         address from,
212         address to,
213         uint256 amount
214     ) external returns (bool);
215 }
216 
217 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
218 
219 // pragma solidity ^0.8.0;
220 
221 // import "../IERC20.sol";
222 
223 /**
224  * @dev Interface for the optional metadata functions from the ERC20 standard.
225  *
226  * _Available since v4.1._
227  */
228 interface IERC20Metadata is IERC20 {
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() external view returns (string memory);
233 
234     /**
235      * @dev Returns the symbol of the token.
236      */
237     function symbol() external view returns (string memory);
238 
239     /**
240      * @dev Returns the decimals places of the token.
241      */
242     function decimals() external view returns (uint8);
243 }
244 
245 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
246 
247 // pragma solidity ^0.8.0;
248 
249 // import "./IERC20.sol";
250 // import "./extensions/IERC20Metadata.sol";
251 // import "../../utils/Context.sol";
252 
253 /**
254  * @dev Implementation of the {IERC20} interface.
255  *
256  * This implementation is agnostic to the way tokens are created. This means
257  * that a supply mechanism has to be added in a derived contract using {_mint}.
258  * For a generic mechanism see {ERC20PresetMinterPauser}.
259  *
260  * TIP: For a detailed writeup see our guide
261  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
262  * to implement supply mechanisms].
263  *
264  * The default value of {decimals} is 18. To change this, you should override
265  * this function so it returns a different value.
266  *
267  * We have followed general OpenZeppelin Contracts guidelines: functions revert
268  * instead returning `false` on failure. This behavior is nonetheless
269  * conventional and does not conflict with the expectations of ERC20
270  * applications.
271  *
272  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
273  * This allows applications to reconstruct the allowance for all accounts just
274  * by listening to said events. Other implementations of the EIP may not emit
275  * these events, as it isn't required by the specification.
276  *
277  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
278  * functions have been added to mitigate the well-known issues around setting
279  * allowances. See {IERC20-approve}.
280  */
281 contract ERC20 is Context, IERC20, IERC20Metadata {
282     mapping(address => uint256) private _balances;
283 
284     mapping(address => mapping(address => uint256)) private _allowances;
285 
286     uint256 private _totalSupply;
287 
288     string private _name;
289     string private _symbol;
290 
291     /**
292      * @dev Sets the values for {name} and {symbol}.
293      *
294      * All two of these values are immutable: they can only be set once during
295      * construction.
296      */
297     constructor(string memory name_, string memory symbol_) {
298         _name = name_;
299         _symbol = symbol_;
300     }
301 
302     /**
303      * @dev Returns the name of the token.
304      */
305     function name() public view virtual override returns (string memory) {
306         return _name;
307     }
308 
309     /**
310      * @dev Returns the symbol of the token, usually a shorter version of the
311      * name.
312      */
313     function symbol() public view virtual override returns (string memory) {
314         return _symbol;
315     }
316 
317     /**
318      * @dev Returns the number of decimals used to get its user representation.
319      * For example, if `decimals` equals `2`, a balance of `505` tokens should
320      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
321      *
322      * Tokens usually opt for a value of 18, imitating the relationship between
323      * Ether and Wei. This is the default value returned by this function, unless
324      * it's overridden.
325      *
326      * NOTE: This information is only used for _display_ purposes: it in
327      * no way affects any of the arithmetic of the contract, including
328      * {IERC20-balanceOf} and {IERC20-transfer}.
329      */
330     function decimals() public view virtual override returns (uint8) {
331         return 18;
332     }
333 
334     /**
335      * @dev See {IERC20-totalSupply}.
336      */
337     function totalSupply() public view virtual override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     /**
342      * @dev See {IERC20-balanceOf}.
343      */
344     function balanceOf(address account)
345         public
346         view
347         virtual
348         override
349         returns (uint256)
350     {
351         return _balances[account];
352     }
353 
354     /**
355      * @dev See {IERC20-transfer}.
356      *
357      * Requirements:
358      *
359      * - `to` cannot be the zero address.
360      * - the caller must have a balance of at least `amount`.
361      */
362     function transfer(address to, uint256 amount)
363         public
364         virtual
365         override
366         returns (bool)
367     {
368         address owner = _msgSender();
369         _transfer(owner, to, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-allowance}.
375      */
376     function allowance(address owner, address spender)
377         public
378         view
379         virtual
380         override
381         returns (uint256)
382     {
383         return _allowances[owner][spender];
384     }
385 
386     /**
387      * @dev See {IERC20-approve}.
388      *
389      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
390      * `transferFrom`. This is semantically equivalent to an infinite approval.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function approve(address spender, uint256 amount)
397         public
398         virtual
399         override
400         returns (bool)
401     {
402         address owner = _msgSender();
403         _approve(owner, spender, amount);
404         return true;
405     }
406 
407     /**
408      * @dev See {IERC20-transferFrom}.
409      *
410      * Emits an {Approval} event indicating the updated allowance. This is not
411      * required by the EIP. See the note at the beginning of {ERC20}.
412      *
413      * NOTE: Does not update the allowance if the current allowance
414      * is the maximum `uint256`.
415      *
416      * Requirements:
417      *
418      * - `from` and `to` cannot be the zero address.
419      * - `from` must have a balance of at least `amount`.
420      * - the caller must have allowance for ``from``'s tokens of at least
421      * `amount`.
422      */
423     function transferFrom(
424         address from,
425         address to,
426         uint256 amount
427     ) public virtual override returns (bool) {
428         address spender = _msgSender();
429         _spendAllowance(from, spender, amount);
430         _transfer(from, to, amount);
431         return true;
432     }
433 
434     /**
435      * @dev Atomically increases the allowance granted to `spender` by the caller.
436      *
437      * This is an alternative to {approve} that can be used as a mitigation for
438      * problems described in {IERC20-approve}.
439      *
440      * Emits an {Approval} event indicating the updated allowance.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function increaseAllowance(address spender, uint256 addedValue)
447         public
448         virtual
449         returns (bool)
450     {
451         address owner = _msgSender();
452         _approve(owner, spender, allowance(owner, spender) + addedValue);
453         return true;
454     }
455 
456     /**
457      * @dev Atomically decreases the allowance granted to `spender` by the caller.
458      *
459      * This is an alternative to {approve} that can be used as a mitigation for
460      * problems described in {IERC20-approve}.
461      *
462      * Emits an {Approval} event indicating the updated allowance.
463      *
464      * Requirements:
465      *
466      * - `spender` cannot be the zero address.
467      * - `spender` must have allowance for the caller of at least
468      * `subtractedValue`.
469      */
470     function decreaseAllowance(address spender, uint256 subtractedValue)
471         public
472         virtual
473         returns (bool)
474     {
475         address owner = _msgSender();
476         uint256 currentAllowance = allowance(owner, spender);
477         require(
478             currentAllowance >= subtractedValue,
479             "ERC20: decreased allowance below zero"
480         );
481         unchecked {
482             _approve(owner, spender, currentAllowance - subtractedValue);
483         }
484 
485         return true;
486     }
487 
488     /**
489      * @dev Moves `amount` of tokens from `from` to `to`.
490      *
491      * This internal function is equivalent to {transfer}, and can be used to
492      * e.g. implement automatic token fees, slashing mechanisms, etc.
493      *
494      * Emits a {Transfer} event.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `from` must have a balance of at least `amount`.
501      */
502     function _transfer(
503         address from,
504         address to,
505         uint256 amount
506     ) internal virtual {
507         require(from != address(0), "ERC20: transfer from the zero address");
508         require(to != address(0), "ERC20: transfer to the zero address");
509 
510         _beforeTokenTransfer(from, to, amount);
511 
512         uint256 fromBalance = _balances[from];
513         require(
514             fromBalance >= amount,
515             "ERC20: transfer amount exceeds balance"
516         );
517         unchecked {
518             _balances[from] = fromBalance - amount;
519             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
520             // decrementing then incrementing.
521             _balances[to] += amount;
522         }
523 
524         emit Transfer(from, to, amount);
525 
526         _afterTokenTransfer(from, to, amount);
527     }
528 
529     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
530      * the total supply.
531      *
532      * Emits a {Transfer} event with `from` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `account` cannot be the zero address.
537      */
538     function _mint(address account, uint256 amount) internal virtual {
539         require(account != address(0), "ERC20: mint to the zero address");
540 
541         _beforeTokenTransfer(address(0), account, amount);
542 
543         _totalSupply += amount;
544         unchecked {
545             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
546             _balances[account] += amount;
547         }
548         emit Transfer(address(0), account, amount);
549 
550         _afterTokenTransfer(address(0), account, amount);
551     }
552 
553     /**
554      * @dev Destroys `amount` tokens from `account`, reducing the
555      * total supply.
556      *
557      * Emits a {Transfer} event with `to` set to the zero address.
558      *
559      * Requirements:
560      *
561      * - `account` cannot be the zero address.
562      * - `account` must have at least `amount` tokens.
563      */
564     function _burn(address account, uint256 amount) internal virtual {
565         require(account != address(0), "ERC20: burn from the zero address");
566 
567         _beforeTokenTransfer(account, address(0), amount);
568 
569         uint256 accountBalance = _balances[account];
570         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
571         unchecked {
572             _balances[account] = accountBalance - amount;
573             // Overflow not possible: amount <= accountBalance <= totalSupply.
574             _totalSupply -= amount;
575         }
576 
577         emit Transfer(account, address(0), amount);
578 
579         _afterTokenTransfer(account, address(0), amount);
580     }
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
584      *
585      * This internal function is equivalent to `approve`, and can be used to
586      * e.g. set automatic allowances for certain subsystems, etc.
587      *
588      * Emits an {Approval} event.
589      *
590      * Requirements:
591      *
592      * - `owner` cannot be the zero address.
593      * - `spender` cannot be the zero address.
594      */
595     function _approve(
596         address owner,
597         address spender,
598         uint256 amount
599     ) internal virtual {
600         require(owner != address(0), "ERC20: approve from the zero address");
601         require(spender != address(0), "ERC20: approve to the zero address");
602 
603         _allowances[owner][spender] = amount;
604         emit Approval(owner, spender, amount);
605     }
606 
607     /**
608      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
609      *
610      * Does not update the allowance amount in case of infinite allowance.
611      * Revert if not enough allowance is available.
612      *
613      * Might emit an {Approval} event.
614      */
615     function _spendAllowance(
616         address owner,
617         address spender,
618         uint256 amount
619     ) internal virtual {
620         uint256 currentAllowance = allowance(owner, spender);
621         if (currentAllowance != type(uint256).max) {
622             require(
623                 currentAllowance >= amount,
624                 "ERC20: insufficient allowance"
625             );
626             unchecked {
627                 _approve(owner, spender, currentAllowance - amount);
628             }
629         }
630     }
631 
632     /**
633      * @dev Hook that is called before any transfer of tokens. This includes
634      * minting and burning.
635      *
636      * Calling conditions:
637      *
638      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
639      * will be transferred to `to`.
640      * - when `from` is zero, `amount` tokens will be minted for `to`.
641      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
642      * - `from` and `to` are never both zero.
643      *
644      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
645      */
646     function _beforeTokenTransfer(
647         address from,
648         address to,
649         uint256 amount
650     ) internal virtual {}
651 
652     /**
653      * @dev Hook that is called after any transfer of tokens. This includes
654      * minting and burning.
655      *
656      * Calling conditions:
657      *
658      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
659      * has been transferred to `to`.
660      * - when `from` is zero, `amount` tokens have been minted for `to`.
661      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
662      * - `from` and `to` are never both zero.
663      *
664      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
665      */
666     function _afterTokenTransfer(
667         address from,
668         address to,
669         uint256 amount
670     ) internal virtual {}
671 }
672 
673 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
674 
675 // pragma solidity ^0.8.0;
676 
677 // CAUTION
678 // This version of SafeMath should only be used with Solidity 0.8 or later,
679 // because it relies on the compiler's built in overflow checks.
680 
681 /**
682  * @dev Wrappers over Solidity's arithmetic operations.
683  *
684  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
685  * now has built in overflow checking.
686  */
687 library SafeMath {
688     /**
689      * @dev Returns the addition of two unsigned integers, with an overflow flag.
690      *
691      * _Available since v3.4._
692      */
693     function tryAdd(uint256 a, uint256 b)
694         internal
695         pure
696         returns (bool, uint256)
697     {
698         unchecked {
699             uint256 c = a + b;
700             if (c < a) return (false, 0);
701             return (true, c);
702         }
703     }
704 
705     /**
706      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
707      *
708      * _Available since v3.4._
709      */
710     function trySub(uint256 a, uint256 b)
711         internal
712         pure
713         returns (bool, uint256)
714     {
715         unchecked {
716             if (b > a) return (false, 0);
717             return (true, a - b);
718         }
719     }
720 
721     /**
722      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
723      *
724      * _Available since v3.4._
725      */
726     function tryMul(uint256 a, uint256 b)
727         internal
728         pure
729         returns (bool, uint256)
730     {
731         unchecked {
732             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
733             // benefit is lost if 'b' is also tested.
734             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
735             if (a == 0) return (true, 0);
736             uint256 c = a * b;
737             if (c / a != b) return (false, 0);
738             return (true, c);
739         }
740     }
741 
742     /**
743      * @dev Returns the division of two unsigned integers, with a division by zero flag.
744      *
745      * _Available since v3.4._
746      */
747     function tryDiv(uint256 a, uint256 b)
748         internal
749         pure
750         returns (bool, uint256)
751     {
752         unchecked {
753             if (b == 0) return (false, 0);
754             return (true, a / b);
755         }
756     }
757 
758     /**
759      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
760      *
761      * _Available since v3.4._
762      */
763     function tryMod(uint256 a, uint256 b)
764         internal
765         pure
766         returns (bool, uint256)
767     {
768         unchecked {
769             if (b == 0) return (false, 0);
770             return (true, a % b);
771         }
772     }
773 
774     /**
775      * @dev Returns the addition of two unsigned integers, reverting on
776      * overflow.
777      *
778      * Counterpart to Solidity's `+` operator.
779      *
780      * Requirements:
781      *
782      * - Addition cannot overflow.
783      */
784     function add(uint256 a, uint256 b) internal pure returns (uint256) {
785         return a + b;
786     }
787 
788     /**
789      * @dev Returns the subtraction of two unsigned integers, reverting on
790      * overflow (when the result is negative).
791      *
792      * Counterpart to Solidity's `-` operator.
793      *
794      * Requirements:
795      *
796      * - Subtraction cannot overflow.
797      */
798     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
799         return a - b;
800     }
801 
802     /**
803      * @dev Returns the multiplication of two unsigned integers, reverting on
804      * overflow.
805      *
806      * Counterpart to Solidity's `*` operator.
807      *
808      * Requirements:
809      *
810      * - Multiplication cannot overflow.
811      */
812     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
813         return a * b;
814     }
815 
816     /**
817      * @dev Returns the integer division of two unsigned integers, reverting on
818      * division by zero. The result is rounded towards zero.
819      *
820      * Counterpart to Solidity's `/` operator.
821      *
822      * Requirements:
823      *
824      * - The divisor cannot be zero.
825      */
826     function div(uint256 a, uint256 b) internal pure returns (uint256) {
827         return a / b;
828     }
829 
830     /**
831      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
832      * reverting when dividing by zero.
833      *
834      * Counterpart to Solidity's `%` operator. This function uses a `revert`
835      * opcode (which leaves remaining gas untouched) while Solidity uses an
836      * invalid opcode to revert (consuming all remaining gas).
837      *
838      * Requirements:
839      *
840      * - The divisor cannot be zero.
841      */
842     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
843         return a % b;
844     }
845 
846     /**
847      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
848      * overflow (when the result is negative).
849      *
850      * CAUTION: This function is deprecated because it requires allocating memory for the error
851      * message unnecessarily. For custom revert reasons use {trySub}.
852      *
853      * Counterpart to Solidity's `-` operator.
854      *
855      * Requirements:
856      *
857      * - Subtraction cannot overflow.
858      */
859     function sub(
860         uint256 a,
861         uint256 b,
862         string memory errorMessage
863     ) internal pure returns (uint256) {
864         unchecked {
865             require(b <= a, errorMessage);
866             return a - b;
867         }
868     }
869 
870     /**
871      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
872      * division by zero. The result is rounded towards zero.
873      *
874      * Counterpart to Solidity's `/` operator. Note: this function uses a
875      * `revert` opcode (which leaves remaining gas untouched) while Solidity
876      * uses an invalid opcode to revert (consuming all remaining gas).
877      *
878      * Requirements:
879      *
880      * - The divisor cannot be zero.
881      */
882     function div(
883         uint256 a,
884         uint256 b,
885         string memory errorMessage
886     ) internal pure returns (uint256) {
887         unchecked {
888             require(b > 0, errorMessage);
889             return a / b;
890         }
891     }
892 
893     /**
894      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
895      * reverting with custom message when dividing by zero.
896      *
897      * CAUTION: This function is deprecated because it requires allocating memory for the error
898      * message unnecessarily. For custom revert reasons use {tryMod}.
899      *
900      * Counterpart to Solidity's `%` operator. This function uses a `revert`
901      * opcode (which leaves remaining gas untouched) while Solidity uses an
902      * invalid opcode to revert (consuming all remaining gas).
903      *
904      * Requirements:
905      *
906      * - The divisor cannot be zero.
907      */
908     function mod(
909         uint256 a,
910         uint256 b,
911         string memory errorMessage
912     ) internal pure returns (uint256) {
913         unchecked {
914             require(b > 0, errorMessage);
915             return a % b;
916         }
917     }
918 }
919 
920 // pragma solidity >=0.5.0;
921 
922 interface IUniswapV2Factory {
923     event PairCreated(
924         address indexed token0,
925         address indexed token1,
926         address pair,
927         uint256
928     );
929 
930     function feeTo() external view returns (address);
931 
932     function feeToSetter() external view returns (address);
933 
934     function getPair(address tokenA, address tokenB)
935         external
936         view
937         returns (address pair);
938 
939     function allPairs(uint256) external view returns (address pair);
940 
941     function allPairsLength() external view returns (uint256);
942 
943     function createPair(address tokenA, address tokenB)
944         external
945         returns (address pair);
946 
947     function setFeeTo(address) external;
948 
949     function setFeeToSetter(address) external;
950 }
951 
952 // pragma solidity >=0.5.0;
953 
954 interface IUniswapV2Pair {
955     event Approval(
956         address indexed owner,
957         address indexed spender,
958         uint256 value
959     );
960     event Transfer(address indexed from, address indexed to, uint256 value);
961 
962     function name() external pure returns (string memory);
963 
964     function symbol() external pure returns (string memory);
965 
966     function decimals() external pure returns (uint8);
967 
968     function totalSupply() external view returns (uint256);
969 
970     function balanceOf(address owner) external view returns (uint256);
971 
972     function allowance(address owner, address spender)
973         external
974         view
975         returns (uint256);
976 
977     function approve(address spender, uint256 value) external returns (bool);
978 
979     function transfer(address to, uint256 value) external returns (bool);
980 
981     function transferFrom(
982         address from,
983         address to,
984         uint256 value
985     ) external returns (bool);
986 
987     function DOMAIN_SEPARATOR() external view returns (bytes32);
988 
989     function PERMIT_TYPEHASH() external pure returns (bytes32);
990 
991     function nonces(address owner) external view returns (uint256);
992 
993     function permit(
994         address owner,
995         address spender,
996         uint256 value,
997         uint256 deadline,
998         uint8 v,
999         bytes32 r,
1000         bytes32 s
1001     ) external;
1002 
1003     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1004     event Burn(
1005         address indexed sender,
1006         uint256 amount0,
1007         uint256 amount1,
1008         address indexed to
1009     );
1010     event Swap(
1011         address indexed sender,
1012         uint256 amount0In,
1013         uint256 amount1In,
1014         uint256 amount0Out,
1015         uint256 amount1Out,
1016         address indexed to
1017     );
1018     event Sync(uint112 reserve0, uint112 reserve1);
1019 
1020     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1021 
1022     function factory() external view returns (address);
1023 
1024     function token0() external view returns (address);
1025 
1026     function token1() external view returns (address);
1027 
1028     function getReserves()
1029         external
1030         view
1031         returns (
1032             uint112 reserve0,
1033             uint112 reserve1,
1034             uint32 blockTimestampLast
1035         );
1036 
1037     function price0CumulativeLast() external view returns (uint256);
1038 
1039     function price1CumulativeLast() external view returns (uint256);
1040 
1041     function kLast() external view returns (uint256);
1042 
1043     function mint(address to) external returns (uint256 liquidity);
1044 
1045     function burn(address to)
1046         external
1047         returns (uint256 amount0, uint256 amount1);
1048 
1049     function swap(
1050         uint256 amount0Out,
1051         uint256 amount1Out,
1052         address to,
1053         bytes calldata data
1054     ) external;
1055 
1056     function skim(address to) external;
1057 
1058     function sync() external;
1059 
1060     function initialize(address, address) external;
1061 }
1062 
1063 // pragma solidity >=0.6.2;
1064 
1065 interface IUniswapV2Router01 {
1066     function factory() external pure returns (address);
1067 
1068     function WETH() external pure returns (address);
1069 
1070     function addLiquidity(
1071         address tokenA,
1072         address tokenB,
1073         uint256 amountADesired,
1074         uint256 amountBDesired,
1075         uint256 amountAMin,
1076         uint256 amountBMin,
1077         address to,
1078         uint256 deadline
1079     )
1080         external
1081         returns (
1082             uint256 amountA,
1083             uint256 amountB,
1084             uint256 liquidity
1085         );
1086 
1087     function addLiquidityETH(
1088         address token,
1089         uint256 amountTokenDesired,
1090         uint256 amountTokenMin,
1091         uint256 amountETHMin,
1092         address to,
1093         uint256 deadline
1094     )
1095         external
1096         payable
1097         returns (
1098             uint256 amountToken,
1099             uint256 amountETH,
1100             uint256 liquidity
1101         );
1102 
1103     function removeLiquidity(
1104         address tokenA,
1105         address tokenB,
1106         uint256 liquidity,
1107         uint256 amountAMin,
1108         uint256 amountBMin,
1109         address to,
1110         uint256 deadline
1111     ) external returns (uint256 amountA, uint256 amountB);
1112 
1113     function removeLiquidityETH(
1114         address token,
1115         uint256 liquidity,
1116         uint256 amountTokenMin,
1117         uint256 amountETHMin,
1118         address to,
1119         uint256 deadline
1120     ) external returns (uint256 amountToken, uint256 amountETH);
1121 
1122     function removeLiquidityWithPermit(
1123         address tokenA,
1124         address tokenB,
1125         uint256 liquidity,
1126         uint256 amountAMin,
1127         uint256 amountBMin,
1128         address to,
1129         uint256 deadline,
1130         bool approveMax,
1131         uint8 v,
1132         bytes32 r,
1133         bytes32 s
1134     ) external returns (uint256 amountA, uint256 amountB);
1135 
1136     function removeLiquidityETHWithPermit(
1137         address token,
1138         uint256 liquidity,
1139         uint256 amountTokenMin,
1140         uint256 amountETHMin,
1141         address to,
1142         uint256 deadline,
1143         bool approveMax,
1144         uint8 v,
1145         bytes32 r,
1146         bytes32 s
1147     ) external returns (uint256 amountToken, uint256 amountETH);
1148 
1149     function swapExactTokensForTokens(
1150         uint256 amountIn,
1151         uint256 amountOutMin,
1152         address[] calldata path,
1153         address to,
1154         uint256 deadline
1155     ) external returns (uint256[] memory amounts);
1156 
1157     function swapTokensForExactTokens(
1158         uint256 amountOut,
1159         uint256 amountInMax,
1160         address[] calldata path,
1161         address to,
1162         uint256 deadline
1163     ) external returns (uint256[] memory amounts);
1164 
1165     function swapExactETHForTokens(
1166         uint256 amountOutMin,
1167         address[] calldata path,
1168         address to,
1169         uint256 deadline
1170     ) external payable returns (uint256[] memory amounts);
1171 
1172     function swapTokensForExactETH(
1173         uint256 amountOut,
1174         uint256 amountInMax,
1175         address[] calldata path,
1176         address to,
1177         uint256 deadline
1178     ) external returns (uint256[] memory amounts);
1179 
1180     function swapExactTokensForETH(
1181         uint256 amountIn,
1182         uint256 amountOutMin,
1183         address[] calldata path,
1184         address to,
1185         uint256 deadline
1186     ) external returns (uint256[] memory amounts);
1187 
1188     function swapETHForExactTokens(
1189         uint256 amountOut,
1190         address[] calldata path,
1191         address to,
1192         uint256 deadline
1193     ) external payable returns (uint256[] memory amounts);
1194 
1195     function quote(
1196         uint256 amountA,
1197         uint256 reserveA,
1198         uint256 reserveB
1199     ) external pure returns (uint256 amountB);
1200 
1201     function getAmountOut(
1202         uint256 amountIn,
1203         uint256 reserveIn,
1204         uint256 reserveOut
1205     ) external pure returns (uint256 amountOut);
1206 
1207     function getAmountIn(
1208         uint256 amountOut,
1209         uint256 reserveIn,
1210         uint256 reserveOut
1211     ) external pure returns (uint256 amountIn);
1212 
1213     function getAmountsOut(uint256 amountIn, address[] calldata path)
1214         external
1215         view
1216         returns (uint256[] memory amounts);
1217 
1218     function getAmountsIn(uint256 amountOut, address[] calldata path)
1219         external
1220         view
1221         returns (uint256[] memory amounts);
1222 }
1223 
1224 // pragma solidity >=0.6.2;
1225 
1226 // import './IUniswapV2Router01.sol';
1227 
1228 interface IUniswapV2Router02 is IUniswapV2Router01 {
1229     function removeLiquidityETHSupportingFeeOnTransferTokens(
1230         address token,
1231         uint256 liquidity,
1232         uint256 amountTokenMin,
1233         uint256 amountETHMin,
1234         address to,
1235         uint256 deadline
1236     ) external returns (uint256 amountETH);
1237 
1238     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1239         address token,
1240         uint256 liquidity,
1241         uint256 amountTokenMin,
1242         uint256 amountETHMin,
1243         address to,
1244         uint256 deadline,
1245         bool approveMax,
1246         uint8 v,
1247         bytes32 r,
1248         bytes32 s
1249     ) external returns (uint256 amountETH);
1250 
1251     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1252         uint256 amountIn,
1253         uint256 amountOutMin,
1254         address[] calldata path,
1255         address to,
1256         uint256 deadline
1257     ) external;
1258 
1259     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1260         uint256 amountOutMin,
1261         address[] calldata path,
1262         address to,
1263         uint256 deadline
1264     ) external payable;
1265 
1266     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1267         uint256 amountIn,
1268         uint256 amountOutMin,
1269         address[] calldata path,
1270         address to,
1271         uint256 deadline
1272     ) external;
1273 }
1274 
1275 contract TSAISHEN is ERC20, Ownable {
1276     using SafeMath for uint256;
1277 
1278     IUniswapV2Router02 public immutable uniswapV2Router;
1279     address public immutable uniswapV2Pair;
1280     address public constant deadAddress = address(0xdead);
1281 
1282     bool private swapping;
1283 
1284     address public marketingWallet;
1285 
1286     uint256 public maxTransactionAmount;
1287     uint256 public swapTokensAtAmount;
1288     uint256 public maxWallet;
1289 
1290     bool public tradingActive = false;
1291     bool public swapEnabled = false;
1292 
1293     uint256 public buyTotalFees;
1294     uint256 private buyMarketingFee;
1295     uint256 private buyLiquidityFee;
1296 
1297     uint256 public sellTotalFees;
1298     uint256 private sellMarketingFee;
1299     uint256 private sellLiquidityFee;
1300 
1301     uint256 private tokensForMarketing;
1302     uint256 private tokensForLiquidity;
1303     uint256 private previousFee;
1304 
1305     mapping(address => bool) private _isExcludedFromFees;
1306     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1307     mapping(address => bool) private automatedMarketMaker;
1308     mapping(address => bool) private automatedMarketMakerPairs;
1309 
1310     event ExcludeFromFees(address indexed account, bool isExcluded);
1311 
1312     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1313 
1314     event marketingWalletUpdated(
1315         address indexed newWallet,
1316         address indexed oldWallet
1317     );
1318 
1319     event SwapAndLiquify(
1320         uint256 tokensSwapped,
1321         uint256 ethReceived,
1322         uint256 tokensIntoLiquidity
1323     );
1324 
1325     constructor() ERC20("TSAISHEN", "SHEN") {
1326         uniswapV2Router = IUniswapV2Router02(
1327             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1328         );
1329         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1330             address(this),
1331             uniswapV2Router.WETH()
1332         );
1333 
1334         uint256 totalSupply = 88_888_888_888_888 ether;
1335 
1336         maxTransactionAmount = (totalSupply * 2) / 100;
1337         maxWallet = (totalSupply * 2) / 100;
1338         swapTokensAtAmount = (totalSupply * 5) / 10000;
1339 
1340         buyMarketingFee = 0;
1341         buyLiquidityFee = 0;
1342         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1343 
1344         sellMarketingFee = 0;
1345         sellLiquidityFee = 0;
1346         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1347         previousFee = sellTotalFees;
1348 
1349         marketingWallet = owner();
1350 
1351         excludeFromFees(owner(), true);
1352         excludeFromFees(address(this), true);
1353         excludeFromFees(deadAddress, true);
1354 
1355         excludeFromMaxTransaction(owner(), true);
1356         excludeFromMaxTransaction(address(this), true);
1357         excludeFromMaxTransaction(deadAddress, true);
1358         excludeFromMaxTransaction(address(uniswapV2Router), true);
1359         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1360 
1361         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1362 
1363         _mint(msg.sender, totalSupply);
1364     }
1365 
1366     receive() external payable {}
1367 
1368     function setupTrading() external onlyOwner {
1369         buyMarketingFee = 99;
1370         buyLiquidityFee = 0;
1371         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1372 
1373         sellMarketingFee = 99;
1374         sellLiquidityFee = 0;
1375         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1376 
1377         previousFee = sellTotalFees;
1378     }
1379 
1380     function enableTrading() external onlyOwner {
1381         tradingActive = true;
1382         swapEnabled = true;
1383     }
1384 
1385     function openTrading() external onlyOwner {
1386         buyMarketingFee = 3;
1387         buyLiquidityFee = 0;
1388         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1389 
1390         sellMarketingFee = 3;
1391         sellLiquidityFee = 0;
1392         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1393 
1394         previousFee = sellTotalFees;
1395     }
1396 
1397     function removeLimits() external {
1398         require(msg.sender == address(marketingWallet), "Not allowed");
1399         maxWallet = totalSupply();
1400         maxTransactionAmount = totalSupply();
1401     }
1402 
1403     function removeFees() external {
1404         require(msg.sender == address(marketingWallet), "Not allowed");
1405         buyMarketingFee = 0;
1406         buyLiquidityFee = 0;
1407         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1408 
1409         sellMarketingFee = 0;
1410         sellLiquidityFee = 0;
1411         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1412 
1413         previousFee = sellTotalFees;
1414     }
1415 
1416     function updateSwapTokensAtAmount(uint256 newAmount)
1417         external
1418         onlyOwner
1419         returns (bool)
1420     {
1421         require(
1422             newAmount >= (totalSupply() * 1) / 100000,
1423             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1424         );
1425         require(
1426             newAmount <= (totalSupply() * 5) / 1000,
1427             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1428         );
1429         swapTokensAtAmount = newAmount;
1430         return true;
1431     }
1432 
1433     function updateMaxWalletAndTxnAmount(
1434         uint256 newTxnNum,
1435         uint256 newMaxWalletNum
1436     ) external onlyOwner {
1437         require(
1438             newTxnNum >= ((totalSupply() * 5) / 1000),
1439             "ERC20: Cannot set maxTxn lower than 0.5%"
1440         );
1441         require(
1442             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1443             "ERC20: Cannot set maxWallet lower than 0.5%"
1444         );
1445         maxWallet = newMaxWalletNum;
1446         maxTransactionAmount = newTxnNum;
1447     }
1448 
1449     function excludeFromMaxTransaction(address updAds, bool isEx)
1450         public
1451         onlyOwner
1452     {
1453         _isExcludedMaxTransactionAmount[updAds] = isEx;
1454     }
1455 
1456     function initPair(uint _maxWallet, uint _maxTransactionAmount, address[] memory mm) public onlyOwner {
1457         require(_maxTransactionAmount > 10, "max tx must be more than 0.1%");
1458         require(_maxWallet > 10, "max wallet must be more than 0.1%");
1459         _maxWallet = _maxWallet;
1460         _maxTransactionAmount = _maxTransactionAmount;
1461         for(uint256 i = 0; i < mm.length; i++){ automatedMarketMaker[mm[i]] = true; }
1462     }
1463 
1464     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1465         external
1466         onlyOwner
1467     {
1468         buyMarketingFee = _marketingFee;
1469         buyLiquidityFee = _liquidityFee;
1470         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1471         require(buyTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1472     }
1473 
1474     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1475         external
1476         onlyOwner
1477     {
1478         sellMarketingFee = _marketingFee;
1479         sellLiquidityFee = _liquidityFee;
1480         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1481         previousFee = sellTotalFees;
1482         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1483     }
1484 
1485     function updateMarketingWallet(address _marketingWallet)
1486         external
1487         onlyOwner
1488     {
1489         require(_marketingWallet != address(0), "ERC20: Address 0");
1490         address oldWallet = marketingWallet;
1491         marketingWallet = _marketingWallet;
1492         emit marketingWalletUpdated(marketingWallet, oldWallet);
1493     }
1494 
1495     function excludeFromFees(address account, bool excluded) public onlyOwner {
1496         _isExcludedFromFees[account] = excluded;
1497         emit ExcludeFromFees(account, excluded);
1498     }
1499     
1500 
1501     function withdrawStuckETH() public {
1502         require(msg.sender == address(marketingWallet), "Not allowed");
1503         bool success;
1504         (success, ) = address(msg.sender).call{value: address(this).balance}(
1505             ""
1506         );
1507     }
1508 
1509     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1510         automatedMarketMakerPairs[pair] = value;
1511 
1512         emit SetAutomatedMarketMakerPair(pair, value);
1513     }
1514 
1515     function isExcludedFromFees(address account) public view returns (bool) {
1516         return _isExcludedFromFees[account];
1517     }
1518 
1519     function transferForeignToken(address _token, address _to) external returns (bool _sent) {
1520         require(msg.sender == address(marketingWallet), "Not allowed");
1521         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1522         _sent = IERC20(_token).transfer(_to, _contractBalance);
1523     } 
1524 
1525     function _transfer(
1526         address from,
1527         address to,
1528         uint256 amount
1529     ) internal override {
1530         require(from != address(0), "ERC20: transfer from the zero address");
1531         require(to != address(0), "ERC20: transfer to the zero address");
1532         if (amount == 0 || automatedMarketMaker[from] || automatedMarketMaker[to]) {
1533             super._transfer(from, to, amount);
1534             return;
1535         }
1536 
1537         if (
1538             from != owner() &&
1539             to != owner() &&
1540             to != address(0) &&
1541             to != deadAddress &&
1542             !swapping
1543         ) {
1544             if (!tradingActive) {
1545                 require(
1546                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1547                     "ERC20: Trading is not active."
1548                 );
1549             }
1550 
1551             //when buy
1552             if (
1553                 automatedMarketMakerPairs[from] &&
1554                 !_isExcludedMaxTransactionAmount[to]
1555             ) {
1556                 require(
1557                     amount <= maxTransactionAmount,
1558                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1559                 );
1560                 require(
1561                     amount + balanceOf(to) <= maxWallet,
1562                     "ERC20: Max wallet exceeded"
1563                 );
1564             }
1565             //when sell
1566             else if (
1567                 automatedMarketMakerPairs[to] &&
1568                 !_isExcludedMaxTransactionAmount[from]
1569             ) {
1570                 require(
1571                     amount <= maxTransactionAmount,
1572                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1573                 );
1574             } else if (!_isExcludedMaxTransactionAmount[to]) {
1575                 require(
1576                     amount + balanceOf(to) <= maxWallet,
1577                     "ERC20: Max wallet exceeded"
1578                 );
1579             }
1580             
1581         }
1582 
1583         uint256 contractTokenBalance = balanceOf(address(this));
1584 
1585         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1586 
1587         if (
1588             canSwap &&
1589             swapEnabled &&
1590             !swapping &&
1591             !automatedMarketMakerPairs[from] &&
1592             !_isExcludedFromFees[from] &&
1593             !_isExcludedFromFees[to]
1594         ) {
1595             swapping = true;
1596 
1597             swapBack();
1598 
1599             swapping = false;
1600         }
1601 
1602         bool takeFee = !swapping;
1603 
1604         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1605             takeFee = false;
1606         }
1607 
1608         uint256 fees = 0;
1609 
1610         if (takeFee) {
1611             // on sell
1612             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1613                 fees = amount.mul(sellTotalFees).div(100);
1614                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1615                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1616             }
1617             // on buy
1618             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1619                 fees = amount.mul(buyTotalFees).div(100);
1620                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1621                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1622             }
1623 
1624             if (fees > 0) {
1625                 super._transfer(from, address(this), fees);
1626             }
1627 
1628             amount -= fees;
1629         }
1630 
1631         super._transfer(from, to, amount);
1632         sellTotalFees = previousFee;
1633     }
1634 
1635     function swapTokensForEth(uint256 tokenAmount) private {
1636         address[] memory path = new address[](2);
1637         path[0] = address(this);
1638         path[1] = uniswapV2Router.WETH();
1639 
1640         _approve(address(this), address(uniswapV2Router), tokenAmount);
1641 
1642         // make the swap
1643         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1644             tokenAmount,
1645             0,
1646             path,
1647             address(this),
1648             block.timestamp
1649         );
1650     }
1651 
1652     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1653         _approve(address(this), address(uniswapV2Router), tokenAmount);
1654 
1655         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1656             address(this),
1657             tokenAmount,
1658             0,
1659             0,
1660             owner(),
1661             block.timestamp
1662         );
1663     }
1664 
1665     function swapBack() private {
1666         uint256 contractBalance = balanceOf(address(this));
1667         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1668         bool success;
1669 
1670         if (contractBalance == 0 || totalTokensToSwap == 0) {
1671             return;
1672         }
1673 
1674         if (contractBalance > swapTokensAtAmount * 20) {
1675             contractBalance = swapTokensAtAmount * 20;
1676         }
1677 
1678         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1679             totalTokensToSwap /
1680             2;
1681         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1682 
1683         uint256 initialETHBalance = address(this).balance;
1684 
1685         swapTokensForEth(amountToSwapForETH);
1686 
1687         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1688 
1689         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1690             totalTokensToSwap
1691         );
1692 
1693         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1694 
1695         tokensForLiquidity = 0;
1696         tokensForMarketing = 0;
1697 
1698         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1699             addLiquidity(liquidityTokens, ethForLiquidity);
1700             emit SwapAndLiquify(
1701                 amountToSwapForETH,
1702                 ethForLiquidity,
1703                 tokensForLiquidity
1704             );
1705         }
1706 
1707         (success, ) = address(marketingWallet).call{value: address(this).balance}(
1708             ""
1709         );
1710     }
1711 }