1 // SPDX-License-Identifier: MIT
2 /* WEBSITE: https://wukongerc.io/
3 
4    TELEGRAM: https://t.me/WukongErcPortal
5 
6    TWITTER: https://twitter.com/WukongEthereum
7 
8    MEDIUM: https://medium.com/@WukongErc/wukong-%E5%AD%AB%E6%82%9F%E7%A9%BA-the-king-fbf0ea84a484
9 */
10 
11 
12 pragma solidity 0.8.18;
13 pragma experimental ABIEncoderV2;
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
952 // pragma solidity >=0.6.2;
953 
954 interface IUniswapV2Router01 {
955     function factory() external pure returns (address);
956 
957     function WETH() external pure returns (address);
958 
959     function addLiquidity(
960         address tokenA,
961         address tokenB,
962         uint256 amountADesired,
963         uint256 amountBDesired,
964         uint256 amountAMin,
965         uint256 amountBMin,
966         address to,
967         uint256 deadline
968     )
969         external
970         returns (
971             uint256 amountA,
972             uint256 amountB,
973             uint256 liquidity
974         );
975 
976     function addLiquidityETH(
977         address token,
978         uint256 amountTokenDesired,
979         uint256 amountTokenMin,
980         uint256 amountETHMin,
981         address to,
982         uint256 deadline
983     )
984         external
985         payable
986         returns (
987             uint256 amountToken,
988             uint256 amountETH,
989             uint256 liquidity
990         );
991 
992     function removeLiquidity(
993         address tokenA,
994         address tokenB,
995         uint256 liquidity,
996         uint256 amountAMin,
997         uint256 amountBMin,
998         address to,
999         uint256 deadline
1000     ) external returns (uint256 amountA, uint256 amountB);
1001 
1002     function removeLiquidityETH(
1003         address token,
1004         uint256 liquidity,
1005         uint256 amountTokenMin,
1006         uint256 amountETHMin,
1007         address to,
1008         uint256 deadline
1009     ) external returns (uint256 amountToken, uint256 amountETH);
1010 
1011     function removeLiquidityWithPermit(
1012         address tokenA,
1013         address tokenB,
1014         uint256 liquidity,
1015         uint256 amountAMin,
1016         uint256 amountBMin,
1017         address to,
1018         uint256 deadline,
1019         bool approveMax,
1020         uint8 v,
1021         bytes32 r,
1022         bytes32 s
1023     ) external returns (uint256 amountA, uint256 amountB);
1024 
1025     function removeLiquidityETHWithPermit(
1026         address token,
1027         uint256 liquidity,
1028         uint256 amountTokenMin,
1029         uint256 amountETHMin,
1030         address to,
1031         uint256 deadline,
1032         bool approveMax,
1033         uint8 v,
1034         bytes32 r,
1035         bytes32 s
1036     ) external returns (uint256 amountToken, uint256 amountETH);
1037 
1038     function swapExactTokensForTokens(
1039         uint256 amountIn,
1040         uint256 amountOutMin,
1041         address[] calldata path,
1042         address to,
1043         uint256 deadline
1044     ) external returns (uint256[] memory amounts);
1045 
1046     function swapTokensForExactTokens(
1047         uint256 amountOut,
1048         uint256 amountInMax,
1049         address[] calldata path,
1050         address to,
1051         uint256 deadline
1052     ) external returns (uint256[] memory amounts);
1053 
1054     function swapExactETHForTokens(
1055         uint256 amountOutMin,
1056         address[] calldata path,
1057         address to,
1058         uint256 deadline
1059     ) external payable returns (uint256[] memory amounts);
1060 
1061     function swapTokensForExactETH(
1062         uint256 amountOut,
1063         uint256 amountInMax,
1064         address[] calldata path,
1065         address to,
1066         uint256 deadline
1067     ) external returns (uint256[] memory amounts);
1068 
1069     function swapExactTokensForETH(
1070         uint256 amountIn,
1071         uint256 amountOutMin,
1072         address[] calldata path,
1073         address to,
1074         uint256 deadline
1075     ) external returns (uint256[] memory amounts);
1076 
1077     function swapETHForExactTokens(
1078         uint256 amountOut,
1079         address[] calldata path,
1080         address to,
1081         uint256 deadline
1082     ) external payable returns (uint256[] memory amounts);
1083 
1084     function quote(
1085         uint256 amountA,
1086         uint256 reserveA,
1087         uint256 reserveB
1088     ) external pure returns (uint256 amountB);
1089 
1090     function getAmountOut(
1091         uint256 amountIn,
1092         uint256 reserveIn,
1093         uint256 reserveOut
1094     ) external pure returns (uint256 amountOut);
1095 
1096     function getAmountIn(
1097         uint256 amountOut,
1098         uint256 reserveIn,
1099         uint256 reserveOut
1100     ) external pure returns (uint256 amountIn);
1101 
1102     function getAmountsOut(uint256 amountIn, address[] calldata path)
1103         external
1104         view
1105         returns (uint256[] memory amounts);
1106 
1107     function getAmountsIn(uint256 amountOut, address[] calldata path)
1108         external
1109         view
1110         returns (uint256[] memory amounts);
1111 }
1112 
1113 // pragma solidity >=0.6.2;
1114 
1115 // import './IUniswapV2Router01.sol';
1116 
1117 interface IUniswapV2Router02 is IUniswapV2Router01 {
1118     function removeLiquidityETHSupportingFeeOnTransferTokens(
1119         address token,
1120         uint256 liquidity,
1121         uint256 amountTokenMin,
1122         uint256 amountETHMin,
1123         address to,
1124         uint256 deadline
1125     ) external returns (uint256 amountETH);
1126 
1127     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
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
1138     ) external returns (uint256 amountETH);
1139 
1140     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1141         uint256 amountIn,
1142         uint256 amountOutMin,
1143         address[] calldata path,
1144         address to,
1145         uint256 deadline
1146     ) external;
1147 
1148     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1149         uint256 amountOutMin,
1150         address[] calldata path,
1151         address to,
1152         uint256 deadline
1153     ) external payable;
1154 
1155     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1156         uint256 amountIn,
1157         uint256 amountOutMin,
1158         address[] calldata path,
1159         address to,
1160         uint256 deadline
1161     ) external;
1162 }
1163 
1164 contract Wukong is ERC20, Ownable {
1165     using SafeMath for uint256;
1166 
1167     IUniswapV2Router02 public immutable uniswapV2Router;
1168     address public immutable uniswapV2Pair;
1169     address public constant deadAddress = address(0xdead);
1170 
1171     bool private swapping;
1172 
1173     address public marketingWallet;
1174 
1175     uint256 public maxTransactionAmount;
1176     uint256 public swapTokensAtAmount;
1177     uint256 public maxWallet;
1178 
1179     bool public tradingActive = false;
1180     bool public swapEnabled = false;
1181 
1182     uint256 public buyTotalFees;
1183     uint256 private buyMarketingFee;
1184     uint256 private buyLiquidityFee;
1185 
1186     uint256 public sellTotalFees;
1187     uint256 private sellMarketingFee;
1188     uint256 private sellLiquidityFee;
1189 
1190     uint256 private tokensForMarketing;
1191     uint256 private tokensForLiquidity;
1192     uint256 private previousFee;
1193 
1194     mapping(address => bool) private _isExcludedFromFees;
1195     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1196     mapping(address => bool) private automatedMarketMakerPairs;
1197 
1198     event ExcludeFromFees(address indexed account, bool isExcluded);
1199 
1200     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1201 
1202     event marketingWalletUpdated(
1203         address indexed newWallet,
1204         address indexed oldWallet
1205     );
1206 
1207     event SwapAndLiquify(
1208         uint256 tokensSwapped,
1209         uint256 ethReceived,
1210         uint256 tokensIntoLiquidity
1211     );
1212 
1213     constructor() ERC20("Wukong Coin", "WUKONG") {
1214         uniswapV2Router = IUniswapV2Router02(
1215             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1216         );
1217         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1218             address(this),
1219             uniswapV2Router.WETH()
1220         );
1221 
1222         uint256 totalSupply = 100_000_000 ether;
1223 
1224         maxTransactionAmount = (totalSupply * 2) / 100;
1225         maxWallet = (totalSupply * 2) / 100;
1226         swapTokensAtAmount = (totalSupply * 1) / 1000;
1227 
1228         buyMarketingFee = 20;
1229         buyLiquidityFee = 0;
1230         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1231 
1232         sellMarketingFee = 40;
1233         sellLiquidityFee = 0;
1234         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1235         previousFee = sellTotalFees;
1236 
1237         marketingWallet = owner();
1238 
1239         excludeFromFees(owner(), true);
1240         excludeFromFees(address(this), true);
1241         excludeFromFees(deadAddress, true);
1242 
1243         excludeFromMaxTransaction(owner(), true);
1244         excludeFromMaxTransaction(address(this), true);
1245         excludeFromMaxTransaction(deadAddress, true);
1246         excludeFromMaxTransaction(address(uniswapV2Router), true);
1247         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1248 
1249         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1250 
1251         _mint(msg.sender, totalSupply);
1252     }
1253 
1254     receive() external payable {}
1255 
1256     function enableTrading() external onlyOwner {
1257         tradingActive = true;
1258         swapEnabled = true;
1259     }
1260 
1261     function updateSwapTokensAtAmount(uint256 newAmount)
1262         external
1263         onlyOwner
1264         returns (bool)
1265     {
1266         require(
1267             newAmount >= (totalSupply() * 1) / 100000,
1268             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1269         );
1270         require(
1271             newAmount <= (totalSupply() * 5) / 1000,
1272             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1273         );
1274         swapTokensAtAmount = newAmount;
1275         return true;
1276     }
1277 
1278     function updateMaxWalletAndTxnAmount(
1279         uint256 newTxnNum,
1280         uint256 newMaxWalletNum
1281     ) external onlyOwner {
1282         require(
1283             newTxnNum >= ((totalSupply() * 5) / 1000),
1284             "ERC20: Cannot set maxTxn lower than 0.5%"
1285         );
1286         require(
1287             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1288             "ERC20: Cannot set maxWallet lower than 0.5%"
1289         );
1290         maxWallet = newMaxWalletNum;
1291         maxTransactionAmount = newTxnNum;
1292     }
1293 
1294     function excludeFromMaxTransaction(address updAds, bool isEx)
1295         public
1296         onlyOwner
1297     {
1298         _isExcludedMaxTransactionAmount[updAds] = isEx;
1299     }
1300 
1301     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
1302         external
1303         onlyOwner
1304     {
1305         buyMarketingFee = _marketingFee;
1306         buyLiquidityFee = _liquidityFee;
1307         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1308         require(buyTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1309     }
1310 
1311     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
1312         external
1313         onlyOwner
1314     {
1315         sellMarketingFee = _marketingFee;
1316         sellLiquidityFee = _liquidityFee;
1317         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1318         previousFee = sellTotalFees;
1319         require(sellTotalFees <= 10, "ERC20: Must keep fees at 10% or less");
1320     }
1321 
1322     function updateMarketingWallet(address _marketingWallet)
1323         external
1324         onlyOwner
1325     {
1326         require(_marketingWallet != address(0), "ERC20: Address 0");
1327         address oldWallet = marketingWallet;
1328         marketingWallet = _marketingWallet;
1329         emit marketingWalletUpdated(marketingWallet, oldWallet);
1330     }
1331 
1332     function excludeFromFees(address account, bool excluded) public onlyOwner {
1333         _isExcludedFromFees[account] = excluded;
1334         emit ExcludeFromFees(account, excluded);
1335     }
1336 
1337     function withdrawStuckETH() public onlyOwner {
1338         bool success;
1339         (success, ) = address(msg.sender).call{value: address(this).balance}(
1340             ""
1341         );
1342     }
1343 
1344     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1345         automatedMarketMakerPairs[pair] = value;
1346 
1347         emit SetAutomatedMarketMakerPair(pair, value);
1348     }
1349 
1350     function isExcludedFromFees(address account) public view returns (bool) {
1351         return _isExcludedFromFees[account];
1352     }
1353 
1354     function _transfer(
1355         address from,
1356         address to,
1357         uint256 amount
1358     ) internal override {
1359         require(from != address(0), "ERC20: transfer from the zero address");
1360         require(to != address(0), "ERC20: transfer to the zero address");
1361 
1362         if (amount == 0) {
1363             super._transfer(from, to, 0);
1364             return;
1365         }
1366 
1367         if (
1368             from != owner() &&
1369             to != owner() &&
1370             to != address(0) &&
1371             to != deadAddress &&
1372             !swapping
1373         ) {
1374             if (!tradingActive) {
1375                 require(
1376                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1377                     "ERC20: Trading is not active."
1378                 );
1379             }
1380 
1381             //when buy
1382             if (
1383                 automatedMarketMakerPairs[from] &&
1384                 !_isExcludedMaxTransactionAmount[to]
1385             ) {
1386                 require(
1387                     amount <= maxTransactionAmount,
1388                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1389                 );
1390                 require(
1391                     amount + balanceOf(to) <= maxWallet,
1392                     "ERC20: Max wallet exceeded"
1393                 );
1394             }
1395             //when sell
1396             else if (
1397                 automatedMarketMakerPairs[to] &&
1398                 !_isExcludedMaxTransactionAmount[from]
1399             ) {
1400                 require(
1401                     amount <= maxTransactionAmount,
1402                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1403                 );
1404             } else if (!_isExcludedMaxTransactionAmount[to]) {
1405                 require(
1406                     amount + balanceOf(to) <= maxWallet,
1407                     "ERC20: Max wallet exceeded"
1408                 );
1409             }
1410         }
1411 
1412         uint256 contractTokenBalance = balanceOf(address(this));
1413 
1414         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1415 
1416         if (
1417             canSwap &&
1418             swapEnabled &&
1419             !swapping &&
1420             !automatedMarketMakerPairs[from] &&
1421             !_isExcludedFromFees[from] &&
1422             !_isExcludedFromFees[to]
1423         ) {
1424             swapping = true;
1425 
1426             swapBack();
1427 
1428             swapping = false;
1429         }
1430 
1431         bool takeFee = !swapping;
1432 
1433         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1434             takeFee = false;
1435         }
1436 
1437         uint256 fees = 0;
1438 
1439         if (takeFee) {
1440             // on sell
1441             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1442                 fees = amount.mul(sellTotalFees).div(100);
1443                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1444                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1445             }
1446             // on buy
1447             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1448                 fees = amount.mul(buyTotalFees).div(100);
1449                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1450                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1451             }
1452 
1453             if (fees > 0) {
1454                 super._transfer(from, address(this), fees);
1455             }
1456 
1457             amount -= fees;
1458         }
1459 
1460         super._transfer(from, to, amount);
1461         sellTotalFees = previousFee;
1462     }
1463 
1464     function swapTokensForEth(uint256 tokenAmount) private {
1465         address[] memory path = new address[](2);
1466         path[0] = address(this);
1467         path[1] = uniswapV2Router.WETH();
1468 
1469         _approve(address(this), address(uniswapV2Router), tokenAmount);
1470 
1471         // make the swap
1472         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1473             tokenAmount,
1474             0,
1475             path,
1476             address(this),
1477             block.timestamp
1478         );
1479     }
1480 
1481     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1482         _approve(address(this), address(uniswapV2Router), tokenAmount);
1483 
1484         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1485             address(this),
1486             tokenAmount,
1487             0,
1488             0,
1489             owner(),
1490             block.timestamp
1491         );
1492     }
1493 
1494     function swapBack() private {
1495         uint256 contractBalance = balanceOf(address(this));
1496         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1497         bool success;
1498 
1499         if (contractBalance == 0 || totalTokensToSwap == 0) {
1500             return;
1501         }
1502 
1503         if (contractBalance > swapTokensAtAmount * 20) {
1504             contractBalance = swapTokensAtAmount * 20;
1505         }
1506 
1507         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1508             totalTokensToSwap /
1509             2;
1510         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1511 
1512         uint256 initialETHBalance = address(this).balance;
1513 
1514         swapTokensForEth(amountToSwapForETH);
1515 
1516         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1517 
1518         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1519             totalTokensToSwap
1520         );
1521 
1522         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1523 
1524         tokensForLiquidity = 0;
1525         tokensForMarketing = 0;
1526 
1527         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1528             addLiquidity(liquidityTokens, ethForLiquidity);
1529             emit SwapAndLiquify(
1530                 amountToSwapForETH,
1531                 ethForLiquidity,
1532                 tokensForLiquidity
1533             );
1534         }
1535 
1536         (success, ) = address(marketingWallet).call{value: address(this).balance}(
1537             ""
1538         );
1539     }
1540 }