1 /*
2 
3 |\   /|
4 | \ / |
5 |  x  |
6 | / \ |
7 |/   \|
8 
9 unicard.cx
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.8.0;
16 
17 // CAUTION
18 // This version of SafeMath should only be used with Solidity 0.8 or later,
19 // because it relies on the compiler's built in overflow checks.
20 
21 /**
22  * @dev Wrappers over Solidity's arithmetic operations.
23  *
24  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
25  * now has built in overflow checking.
26  */
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function tryAdd(
34         uint256 a,
35         uint256 b
36     ) internal pure returns (bool, uint256) {
37         unchecked {
38             uint256 c = a + b;
39             if (c < a) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function trySub(
50         uint256 a,
51         uint256 b
52     ) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b > a) return (false, 0);
55             return (true, a - b);
56         }
57     }
58 
59     /**
60      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryMul(
65         uint256 a,
66         uint256 b
67     ) internal pure returns (bool, uint256) {
68         unchecked {
69             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70             // benefit is lost if 'b' is also tested.
71             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
72             if (a == 0) return (true, 0);
73             uint256 c = a * b;
74             if (c / a != b) return (false, 0);
75             return (true, c);
76         }
77     }
78 
79     /**
80      * @dev Returns the division of two unsigned integers, with a division by zero flag.
81      *
82      * _Available since v3.4._
83      */
84     function tryDiv(
85         uint256 a,
86         uint256 b
87     ) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a / b);
91         }
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
96      *
97      * _Available since v3.4._
98      */
99     function tryMod(
100         uint256 a,
101         uint256 b
102     ) internal pure returns (bool, uint256) {
103         unchecked {
104             if (b == 0) return (false, 0);
105             return (true, a % b);
106         }
107     }
108 
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a + b;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a - b;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a * b;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers, reverting on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator.
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a / b;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * reverting when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a % b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
183      * overflow (when the result is negative).
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {trySub}.
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b <= a, errorMessage);
201             return a - b;
202         }
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a / b;
225         }
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting with custom message when dividing by zero.
231      *
232      * CAUTION: This function is deprecated because it requires allocating memory for the error
233      * message unnecessarily. For custom revert reasons use {tryMod}.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b > 0, errorMessage);
250             return a % b;
251         }
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Context.sol
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev Provides information about the current execution context, including the
263  * sender of the transaction and its data. While these are generally available
264  * via msg.sender and msg.data, they should not be accessed in such a direct
265  * manner, since when dealing with meta-transactions the account sending and
266  * paying for execution may not be the actual sender (as far as an application
267  * is concerned).
268  *
269  * This contract is only required for intermediate, library-like contracts.
270  */
271 abstract contract Context {
272     function _msgSender() internal view virtual returns (address) {
273         return msg.sender;
274     }
275 
276     function _msgData() internal view virtual returns (bytes calldata) {
277         return msg.data;
278     }
279 }
280 
281 // File: @openzeppelin/contracts/access/Ownable.sol
282 
283 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev Contract module which provides a basic access control mechanism, where
289  * there is an account (an owner) that can be granted exclusive access to
290  * specific functions.
291  *
292  * By default, the owner account will be the one that deploys the contract. This
293  * can later be changed with {transferOwnership}.
294  *
295  * This module is used through inheritance. It will make available the modifier
296  * `onlyOwner`, which can be applied to your functions to restrict their use to
297  * the owner.
298  */
299 abstract contract Ownable is Context {
300     address private _owner;
301 
302     event OwnershipTransferred(
303         address indexed previousOwner,
304         address indexed newOwner
305     );
306 
307     /**
308      * @dev Initializes the contract setting the deployer as the initial owner.
309      */
310     constructor() {
311         _transferOwnership(_msgSender());
312     }
313 
314     /**
315      * @dev Throws if called by any account other than the owner.
316      */
317     modifier onlyOwner() {
318         _checkOwner();
319         _;
320     }
321 
322     /**
323      * @dev Returns the address of the current owner.
324      */
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     /**
330      * @dev Throws if the sender is not the owner.
331      */
332     function _checkOwner() internal view virtual {
333         require(owner() == _msgSender(), "Ownable: caller is not the owner");
334     }
335 
336     /**
337      * @dev Leaves the contract without owner. It will not be possible to call
338      * `onlyOwner` functions anymore. Can only be called by the current owner.
339      *
340      * NOTE: Renouncing ownership will leave the contract without an owner,
341      * thereby removing any functionality that is only available to the owner.
342      */
343     function renounceOwnership() public virtual onlyOwner {
344         _transferOwnership(address(0));
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Can only be called by the current owner.
350      */
351     function transferOwnership(address newOwner) public virtual onlyOwner {
352         require(
353             newOwner != address(0),
354             "Ownable: new owner is the zero address"
355         );
356         _transferOwnership(newOwner);
357     }
358 
359     /**
360      * @dev Transfers ownership of the contract to a new account (`newOwner`).
361      * Internal function without access restriction.
362      */
363     function _transferOwnership(address newOwner) internal virtual {
364         address oldOwner = _owner;
365         _owner = newOwner;
366         emit OwnershipTransferred(oldOwner, newOwner);
367     }
368 }
369 
370 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
371 
372 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Interface of the ERC20 standard as defined in the EIP.
378  */
379 interface IERC20 {
380     /**
381      * @dev Emitted when `value` tokens are moved from one account (`from`) to
382      * another (`to`).
383      *
384      * Note that `value` may be zero.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 value);
387 
388     /**
389      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
390      * a call to {approve}. `value` is the new allowance.
391      */
392     event Approval(
393         address indexed owner,
394         address indexed spender,
395         uint256 value
396     );
397 
398     /**
399      * @dev Returns the amount of tokens in existence.
400      */
401     function totalSupply() external view returns (uint256);
402 
403     /**
404      * @dev Returns the amount of tokens owned by `account`.
405      */
406     function balanceOf(address account) external view returns (uint256);
407 
408     /**
409      * @dev Moves `amount` tokens from the caller's account to `to`.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * Emits a {Transfer} event.
414      */
415     function transfer(address to, uint256 amount) external returns (bool);
416 
417     /**
418      * @dev Returns the remaining number of tokens that `spender` will be
419      * allowed to spend on behalf of `owner` through {transferFrom}. This is
420      * zero by default.
421      *
422      * This value changes when {approve} or {transferFrom} are called.
423      */
424     function allowance(
425         address owner,
426         address spender
427     ) external view returns (uint256);
428 
429     /**
430      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
431      *
432      * Returns a boolean value indicating whether the operation succeeded.
433      *
434      * IMPORTANT: Beware that changing an allowance with this method brings the risk
435      * that someone may use both the old and the new allowance by unfortunate
436      * transaction ordering. One possible solution to mitigate this race
437      * condition is to first reduce the spender's allowance to 0 and set the
438      * desired value afterwards:
439      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
440      *
441      * Emits an {Approval} event.
442      */
443     function approve(address spender, uint256 amount) external returns (bool);
444 
445     /**
446      * @dev Moves `amount` tokens from `from` to `to` using the
447      * allowance mechanism. `amount` is then deducted from the caller's
448      * allowance.
449      *
450      * Returns a boolean value indicating whether the operation succeeded.
451      *
452      * Emits a {Transfer} event.
453      */
454     function transferFrom(
455         address from,
456         address to,
457         uint256 amount
458     ) external returns (bool);
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
462 
463 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Interface for the optional metadata functions from the ERC20 standard.
469  *
470  * _Available since v4.1._
471  */
472 interface IERC20Metadata is IERC20 {
473     /**
474      * @dev Returns the name of the token.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the symbol of the token.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the decimals places of the token.
485      */
486     function decimals() external view returns (uint8);
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
490 
491 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Implementation of the {IERC20} interface.
497  *
498  * This implementation is agnostic to the way tokens are created. This means
499  * that a supply mechanism has to be added in a derived contract using {_mint}.
500  * For a generic mechanism see {ERC20PresetMinterPauser}.
501  *
502  * TIP: For a detailed writeup see our guide
503  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
504  * to implement supply mechanisms].
505  *
506  * We have followed general OpenZeppelin Contracts guidelines: functions revert
507  * instead returning `false` on failure. This behavior is nonetheless
508  * conventional and does not conflict with the expectations of ERC20
509  * applications.
510  *
511  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
512  * This allows applications to reconstruct the allowance for all accounts just
513  * by listening to said events. Other implementations of the EIP may not emit
514  * these events, as it isn't required by the specification.
515  *
516  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
517  * functions have been added to mitigate the well-known issues around setting
518  * allowances. See {IERC20-approve}.
519  */
520 contract ERC20 is Context, IERC20, IERC20Metadata {
521     mapping(address => uint256) private _balances;
522 
523     mapping(address => mapping(address => uint256)) private _allowances;
524 
525     uint256 private _totalSupply;
526 
527     string private _name;
528     string private _symbol;
529 
530     /**
531      * @dev Sets the values for {name} and {symbol}.
532      *
533      * The default value of {decimals} is 18. To select a different value for
534      * {decimals} you should overload it.
535      *
536      * All two of these values are immutable: they can only be set once during
537      * construction.
538      */
539     constructor(string memory name_, string memory symbol_) {
540         _name = name_;
541         _symbol = symbol_;
542     }
543 
544     /**
545      * @dev Returns the name of the token.
546      */
547     function name() public view virtual override returns (string memory) {
548         return _name;
549     }
550 
551     /**
552      * @dev Returns the symbol of the token, usually a shorter version of the
553      * name.
554      */
555     function symbol() public view virtual override returns (string memory) {
556         return _symbol;
557     }
558 
559     /**
560      * @dev Returns the number of decimals used to get its user representation.
561      * For example, if `decimals` equals `2`, a balance of `505` tokens should
562      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
563      *
564      * Tokens usually opt for a value of 18, imitating the relationship between
565      * Ether and Wei. This is the value {ERC20} uses, unless this function is
566      * overridden;
567      *
568      * NOTE: This information is only used for _display_ purposes: it in
569      * no way affects any of the arithmetic of the contract, including
570      * {IERC20-balanceOf} and {IERC20-transfer}.
571      */
572     function decimals() public view virtual override returns (uint8) {
573         return 18;
574     }
575 
576     /**
577      * @dev See {IERC20-totalSupply}.
578      */
579     function totalSupply() public view virtual override returns (uint256) {
580         return _totalSupply;
581     }
582 
583     /**
584      * @dev See {IERC20-balanceOf}.
585      */
586     function balanceOf(
587         address account
588     ) public view virtual override returns (uint256) {
589         return _balances[account];
590     }
591 
592     /**
593      * @dev See {IERC20-transfer}.
594      *
595      * Requirements:
596      *
597      * - `to` cannot be the zero address.
598      * - the caller must have a balance of at least `amount`.
599      */
600     function transfer(
601         address to,
602         uint256 amount
603     ) public virtual override returns (bool) {
604         address owner = _msgSender();
605         _transfer(owner, to, amount);
606         return true;
607     }
608 
609     /**
610      * @dev See {IERC20-allowance}.
611      */
612     function allowance(
613         address owner,
614         address spender
615     ) public view virtual override returns (uint256) {
616         return _allowances[owner][spender];
617     }
618 
619     /**
620      * @dev See {IERC20-approve}.
621      *
622      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
623      * `transferFrom`. This is semantically equivalent to an infinite approval.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      */
629     function approve(
630         address spender,
631         uint256 amount
632     ) public virtual override returns (bool) {
633         address owner = _msgSender();
634         _approve(owner, spender, amount);
635         return true;
636     }
637 
638     /**
639      * @dev See {IERC20-transferFrom}.
640      *
641      * Emits an {Approval} event indicating the updated allowance. This is not
642      * required by the EIP. See the note at the beginning of {ERC20}.
643      *
644      * NOTE: Does not update the allowance if the current allowance
645      * is the maximum `uint256`.
646      *
647      * Requirements:
648      *
649      * - `from` and `to` cannot be the zero address.
650      * - `from` must have a balance of at least `amount`.
651      * - the caller must have allowance for ``from``'s tokens of at least
652      * `amount`.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 amount
658     ) public virtual override returns (bool) {
659         address spender = _msgSender();
660         _spendAllowance(from, spender, amount);
661         _transfer(from, to, amount);
662         return true;
663     }
664 
665     /**
666      * @dev Atomically increases the allowance granted to `spender` by the caller.
667      *
668      * This is an alternative to {approve} that can be used as a mitigation for
669      * problems described in {IERC20-approve}.
670      *
671      * Emits an {Approval} event indicating the updated allowance.
672      *
673      * Requirements:
674      *
675      * - `spender` cannot be the zero address.
676      */
677     function increaseAllowance(
678         address spender,
679         uint256 addedValue
680     ) public virtual returns (bool) {
681         address owner = _msgSender();
682         _approve(owner, spender, allowance(owner, spender) + addedValue);
683         return true;
684     }
685 
686     /**
687      * @dev Atomically decreases the allowance granted to `spender` by the caller.
688      *
689      * This is an alternative to {approve} that can be used as a mitigation for
690      * problems described in {IERC20-approve}.
691      *
692      * Emits an {Approval} event indicating the updated allowance.
693      *
694      * Requirements:
695      *
696      * - `spender` cannot be the zero address.
697      * - `spender` must have allowance for the caller of at least
698      * `subtractedValue`.
699      */
700     function decreaseAllowance(
701         address spender,
702         uint256 subtractedValue
703     ) public virtual returns (bool) {
704         address owner = _msgSender();
705         uint256 currentAllowance = allowance(owner, spender);
706         require(
707             currentAllowance >= subtractedValue,
708             "ERC20: decreased allowance below zero"
709         );
710         unchecked {
711             _approve(owner, spender, currentAllowance - subtractedValue);
712         }
713 
714         return true;
715     }
716 
717     /**
718      * @dev Moves `amount` of tokens from `from` to `to`.
719      *
720      * This internal function is equivalent to {transfer}, and can be used to
721      * e.g. implement automatic token fees, slashing mechanisms, etc.
722      *
723      * Emits a {Transfer} event.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `from` must have a balance of at least `amount`.
730      */
731     function _transfer(
732         address from,
733         address to,
734         uint256 amount
735     ) internal virtual {
736         require(from != address(0), "ERC20: transfer from the zero address");
737         require(to != address(0), "ERC20: transfer to the zero address");
738 
739         _beforeTokenTransfer(from, to, amount);
740 
741         uint256 fromBalance = _balances[from];
742         require(
743             fromBalance >= amount,
744             "ERC20: transfer amount exceeds balance"
745         );
746         unchecked {
747             _balances[from] = fromBalance - amount;
748             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
749             // decrementing then incrementing.
750             _balances[to] += amount;
751         }
752 
753         emit Transfer(from, to, amount);
754 
755         _afterTokenTransfer(from, to, amount);
756     }
757 
758     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
759      * the total supply.
760      *
761      * Emits a {Transfer} event with `from` set to the zero address.
762      *
763      * Requirements:
764      *
765      * - `account` cannot be the zero address.
766      */
767     function _mint(address account, uint256 amount) internal virtual {
768         require(account != address(0), "ERC20: mint to the zero address");
769 
770         _beforeTokenTransfer(address(0), account, amount);
771 
772         _totalSupply += amount;
773         unchecked {
774             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
775             _balances[account] += amount;
776         }
777         emit Transfer(address(0), account, amount);
778 
779         _afterTokenTransfer(address(0), account, amount);
780     }
781 
782     /**
783      * @dev Destroys `amount` tokens from `account`, reducing the
784      * total supply.
785      *
786      * Emits a {Transfer} event with `to` set to the zero address.
787      *
788      * Requirements:
789      *
790      * - `account` cannot be the zero address.
791      * - `account` must have at least `amount` tokens.
792      */
793     function _burn(address account, uint256 amount) internal virtual {
794         require(account != address(0), "ERC20: burn from the zero address");
795 
796         _beforeTokenTransfer(account, address(0), amount);
797 
798         uint256 accountBalance = _balances[account];
799         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
800         unchecked {
801             _balances[account] = accountBalance - amount;
802             // Overflow not possible: amount <= accountBalance <= totalSupply.
803             _totalSupply -= amount;
804         }
805 
806         emit Transfer(account, address(0), amount);
807 
808         _afterTokenTransfer(account, address(0), amount);
809     }
810 
811     /**
812      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
813      *
814      * This internal function is equivalent to `approve`, and can be used to
815      * e.g. set automatic allowances for certain subsystems, etc.
816      *
817      * Emits an {Approval} event.
818      *
819      * Requirements:
820      *
821      * - `owner` cannot be the zero address.
822      * - `spender` cannot be the zero address.
823      */
824     function _approve(
825         address owner,
826         address spender,
827         uint256 amount
828     ) internal virtual {
829         require(owner != address(0), "ERC20: approve from the zero address");
830         require(spender != address(0), "ERC20: approve to the zero address");
831 
832         _allowances[owner][spender] = amount;
833         emit Approval(owner, spender, amount);
834     }
835 
836     /**
837      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
838      *
839      * Does not update the allowance amount in case of infinite allowance.
840      * Revert if not enough allowance is available.
841      *
842      * Might emit an {Approval} event.
843      */
844     function _spendAllowance(
845         address owner,
846         address spender,
847         uint256 amount
848     ) internal virtual {
849         uint256 currentAllowance = allowance(owner, spender);
850         if (currentAllowance != type(uint256).max) {
851             require(
852                 currentAllowance >= amount,
853                 "ERC20: insufficient allowance"
854             );
855             unchecked {
856                 _approve(owner, spender, currentAllowance - amount);
857             }
858         }
859     }
860 
861     /**
862      * @dev Hook that is called before any transfer of tokens. This includes
863      * minting and burning.
864      *
865      * Calling conditions:
866      *
867      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
868      * will be transferred to `to`.
869      * - when `from` is zero, `amount` tokens will be minted for `to`.
870      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
871      * - `from` and `to` are never both zero.
872      *
873      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
874      */
875     function _beforeTokenTransfer(
876         address from,
877         address to,
878         uint256 amount
879     ) internal virtual {}
880 
881     /**
882      * @dev Hook that is called after any transfer of tokens. This includes
883      * minting and burning.
884      *
885      * Calling conditions:
886      *
887      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
888      * has been transferred to `to`.
889      * - when `from` is zero, `amount` tokens have been minted for `to`.
890      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
891      * - `from` and `to` are never both zero.
892      *
893      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
894      */
895     function _afterTokenTransfer(
896         address from,
897         address to,
898         uint256 amount
899     ) internal virtual {}
900 }
901 
902 pragma solidity 0.8.9;
903 
904 interface IUniswapV2Pair {
905     event Approval(address indexed owner, address indexed spender, uint value);
906     event Transfer(address indexed from, address indexed to, uint value);
907 
908     function name() external pure returns (string memory);
909 
910     function symbol() external pure returns (string memory);
911 
912     function decimals() external pure returns (uint8);
913 
914     function totalSupply() external view returns (uint);
915 
916     function balanceOf(address owner) external view returns (uint);
917 
918     function allowance(
919         address owner,
920         address spender
921     ) external view returns (uint);
922 
923     function approve(address spender, uint value) external returns (bool);
924 
925     function transfer(address to, uint value) external returns (bool);
926 
927     function transferFrom(
928         address from,
929         address to,
930         uint value
931     ) external returns (bool);
932 
933     function DOMAIN_SEPARATOR() external view returns (bytes32);
934 
935     function PERMIT_TYPEHASH() external pure returns (bytes32);
936 
937     function nonces(address owner) external view returns (uint);
938 
939     function permit(
940         address owner,
941         address spender,
942         uint value,
943         uint deadline,
944         uint8 v,
945         bytes32 r,
946         bytes32 s
947     ) external;
948 
949     event Mint(address indexed sender, uint amount0, uint amount1);
950     event Burn(
951         address indexed sender,
952         uint amount0,
953         uint amount1,
954         address indexed to
955     );
956     event Swap(
957         address indexed sender,
958         uint amount0In,
959         uint amount1In,
960         uint amount0Out,
961         uint amount1Out,
962         address indexed to
963     );
964     event Sync(uint112 reserve0, uint112 reserve1);
965 
966     function MINIMUM_LIQUIDITY() external pure returns (uint);
967 
968     function factory() external view returns (address);
969 
970     function token0() external view returns (address);
971 
972     function token1() external view returns (address);
973 
974     function getReserves()
975         external
976         view
977         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
978 
979     function price0CumulativeLast() external view returns (uint);
980 
981     function price1CumulativeLast() external view returns (uint);
982 
983     function kLast() external view returns (uint);
984 
985     function mint(address to) external returns (uint liquidity);
986 
987     function burn(address to) external returns (uint amount0, uint amount1);
988 
989     function swap(
990         uint amount0Out,
991         uint amount1Out,
992         address to,
993         bytes calldata data
994     ) external;
995 
996     function skim(address to) external;
997 
998     function sync() external;
999 
1000     function initialize(address, address) external;
1001 }
1002 
1003 interface IUniswapV2Factory {
1004     event PairCreated(
1005         address indexed token0,
1006         address indexed token1,
1007         address pair,
1008         uint
1009     );
1010 
1011     function feeTo() external view returns (address);
1012 
1013     function feeToSetter() external view returns (address);
1014 
1015     function getPair(
1016         address tokenA,
1017         address tokenB
1018     ) external view returns (address pair);
1019 
1020     function allPairs(uint) external view returns (address pair);
1021 
1022     function allPairsLength() external view returns (uint);
1023 
1024     function createPair(
1025         address tokenA,
1026         address tokenB
1027     ) external returns (address pair);
1028 
1029     function setFeeTo(address) external;
1030 
1031     function setFeeToSetter(address) external;
1032 }
1033 
1034 library SafeMathInt {
1035     int256 private constant MIN_INT256 = int256(1) << 255;
1036     int256 private constant MAX_INT256 = ~(int256(1) << 255);
1037 
1038     /**
1039      * @dev Multiplies two int256 variables and fails on overflow.
1040      */
1041     function mul(int256 a, int256 b) internal pure returns (int256) {
1042         int256 c = a * b;
1043 
1044         // Detect overflow when multiplying MIN_INT256 with -1
1045         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
1046         require((b == 0) || (c / b == a));
1047         return c;
1048     }
1049 
1050     /**
1051      * @dev Division of two int256 variables and fails on overflow.
1052      */
1053     function div(int256 a, int256 b) internal pure returns (int256) {
1054         // Prevent overflow when dividing MIN_INT256 by -1
1055         require(b != -1 || a != MIN_INT256);
1056 
1057         // Solidity already throws when dividing by 0.
1058         return a / b;
1059     }
1060 
1061     /**
1062      * @dev Subtracts two int256 variables and fails on overflow.
1063      */
1064     function sub(int256 a, int256 b) internal pure returns (int256) {
1065         int256 c = a - b;
1066         require((b >= 0 && c <= a) || (b < 0 && c > a));
1067         return c;
1068     }
1069 
1070     /**
1071      * @dev Adds two int256 variables and fails on overflow.
1072      */
1073     function add(int256 a, int256 b) internal pure returns (int256) {
1074         int256 c = a + b;
1075         require((b >= 0 && c >= a) || (b < 0 && c < a));
1076         return c;
1077     }
1078 
1079     /**
1080      * @dev Converts to absolute value, and fails on overflow.
1081      */
1082     function abs(int256 a) internal pure returns (int256) {
1083         require(a != MIN_INT256);
1084         return a < 0 ? -a : a;
1085     }
1086 
1087     function toUint256Safe(int256 a) internal pure returns (uint256) {
1088         require(a >= 0);
1089         return uint256(a);
1090     }
1091 }
1092 
1093 library SafeMathUint {
1094     function toInt256Safe(uint256 a) internal pure returns (int256) {
1095         int256 b = int256(a);
1096         require(b >= 0);
1097         return b;
1098     }
1099 }
1100 
1101 interface IUniswapV2Router01 {
1102     function factory() external pure returns (address);
1103 
1104     function WETH() external pure returns (address);
1105 
1106     function addLiquidity(
1107         address tokenA,
1108         address tokenB,
1109         uint amountADesired,
1110         uint amountBDesired,
1111         uint amountAMin,
1112         uint amountBMin,
1113         address to,
1114         uint deadline
1115     ) external returns (uint amountA, uint amountB, uint liquidity);
1116 
1117     function addLiquidityETH(
1118         address token,
1119         uint amountTokenDesired,
1120         uint amountTokenMin,
1121         uint amountETHMin,
1122         address to,
1123         uint deadline
1124     )
1125         external
1126         payable
1127         returns (uint amountToken, uint amountETH, uint liquidity);
1128 
1129     function removeLiquidity(
1130         address tokenA,
1131         address tokenB,
1132         uint liquidity,
1133         uint amountAMin,
1134         uint amountBMin,
1135         address to,
1136         uint deadline
1137     ) external returns (uint amountA, uint amountB);
1138 
1139     function removeLiquidityETH(
1140         address token,
1141         uint liquidity,
1142         uint amountTokenMin,
1143         uint amountETHMin,
1144         address to,
1145         uint deadline
1146     ) external returns (uint amountToken, uint amountETH);
1147 
1148     function removeLiquidityWithPermit(
1149         address tokenA,
1150         address tokenB,
1151         uint liquidity,
1152         uint amountAMin,
1153         uint amountBMin,
1154         address to,
1155         uint deadline,
1156         bool approveMax,
1157         uint8 v,
1158         bytes32 r,
1159         bytes32 s
1160     ) external returns (uint amountA, uint amountB);
1161 
1162     function removeLiquidityETHWithPermit(
1163         address token,
1164         uint liquidity,
1165         uint amountTokenMin,
1166         uint amountETHMin,
1167         address to,
1168         uint deadline,
1169         bool approveMax,
1170         uint8 v,
1171         bytes32 r,
1172         bytes32 s
1173     ) external returns (uint amountToken, uint amountETH);
1174 
1175     function swapExactTokensForTokens(
1176         uint amountIn,
1177         uint amountOutMin,
1178         address[] calldata path,
1179         address to,
1180         uint deadline
1181     ) external returns (uint[] memory amounts);
1182 
1183     function swapTokensForExactTokens(
1184         uint amountOut,
1185         uint amountInMax,
1186         address[] calldata path,
1187         address to,
1188         uint deadline
1189     ) external returns (uint[] memory amounts);
1190 
1191     function swapExactETHForTokens(
1192         uint amountOutMin,
1193         address[] calldata path,
1194         address to,
1195         uint deadline
1196     ) external payable returns (uint[] memory amounts);
1197 
1198     function swapTokensForExactETH(
1199         uint amountOut,
1200         uint amountInMax,
1201         address[] calldata path,
1202         address to,
1203         uint deadline
1204     ) external returns (uint[] memory amounts);
1205 
1206     function swapExactTokensForETH(
1207         uint amountIn,
1208         uint amountOutMin,
1209         address[] calldata path,
1210         address to,
1211         uint deadline
1212     ) external returns (uint[] memory amounts);
1213 
1214     function swapETHForExactTokens(
1215         uint amountOut,
1216         address[] calldata path,
1217         address to,
1218         uint deadline
1219     ) external payable returns (uint[] memory amounts);
1220 
1221     function quote(
1222         uint amountA,
1223         uint reserveA,
1224         uint reserveB
1225     ) external pure returns (uint amountB);
1226 
1227     function getAmountOut(
1228         uint amountIn,
1229         uint reserveIn,
1230         uint reserveOut
1231     ) external pure returns (uint amountOut);
1232 
1233     function getAmountIn(
1234         uint amountOut,
1235         uint reserveIn,
1236         uint reserveOut
1237     ) external pure returns (uint amountIn);
1238 
1239     function getAmountsOut(
1240         uint amountIn,
1241         address[] calldata path
1242     ) external view returns (uint[] memory amounts);
1243 
1244     function getAmountsIn(
1245         uint amountOut,
1246         address[] calldata path
1247     ) external view returns (uint[] memory amounts);
1248 }
1249 
1250 interface IUniswapV2Router02 is IUniswapV2Router01 {
1251     function removeLiquidityETHSupportingFeeOnTransferTokens(
1252         address token,
1253         uint liquidity,
1254         uint amountTokenMin,
1255         uint amountETHMin,
1256         address to,
1257         uint deadline
1258     ) external returns (uint amountETH);
1259 
1260     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1261         address token,
1262         uint liquidity,
1263         uint amountTokenMin,
1264         uint amountETHMin,
1265         address to,
1266         uint deadline,
1267         bool approveMax,
1268         uint8 v,
1269         bytes32 r,
1270         bytes32 s
1271     ) external returns (uint amountETH);
1272 
1273     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1274         uint amountIn,
1275         uint amountOutMin,
1276         address[] calldata path,
1277         address to,
1278         uint deadline
1279     ) external;
1280 
1281     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1282         uint amountOutMin,
1283         address[] calldata path,
1284         address to,
1285         uint deadline
1286     ) external payable;
1287 
1288     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1289         uint amountIn,
1290         uint amountOutMin,
1291         address[] calldata path,
1292         address to,
1293         uint deadline
1294     ) external;
1295 }
1296 
1297 contract Unicard is ERC20, Ownable {
1298     using SafeMath for uint256;
1299 
1300     IUniswapV2Router02 public immutable uniswapV2Router;
1301     address public immutable uniswapV2Pair;
1302     address public constant deadAddress = address(0xdead);
1303 
1304     bool private swapping;
1305 
1306     address public marketingWallet;
1307     address public devWallet;
1308 
1309     uint256 public maxTokensPerTransaction;
1310     uint256 public swapTokensAtAmount;
1311     uint256 public maxTokensPerWallet;
1312 
1313     bool public limitsInEffect = true;
1314     bool public tradingActive = true;
1315     bool public swapEnabled = true;
1316 
1317     uint256 public manualBurnFrequency = 43210 minutes;
1318     uint256 public lastManualLpBurnTime;
1319 
1320     mapping(address => uint256) private _holderLastTransferTimestamp;
1321     bool public transferDelayEnabled = true;
1322 
1323     uint256 public percentForLPBurn = 1;
1324     bool public lpBurnEnabled = false;
1325     uint256 public lpBurnFrequency = 1360000000000 seconds;
1326     uint256 public lastLpBurnTime;
1327 
1328     uint256 public buyTotalFees;
1329     uint256 public buyMarketingFee;
1330     uint256 public buyLiquidityFee;
1331     uint256 public buyDevFee;
1332 
1333     uint256 public sellTotalFees;
1334     uint256 public sellMarketingFee;
1335     uint256 public sellLiquidityFee;
1336     uint256 public sellDevFee;
1337 
1338     uint256 public tokensForMarketing;
1339     uint256 public tokensForLiquidity;
1340     uint256 public tokensForDev;
1341 
1342     /******************/
1343 
1344     // exlcude from fees and max transaction amount
1345     mapping(address => bool) private _isExcludedFromFees;
1346     mapping(address => bool) public _isExcludedmaxTokensPerTransaction;
1347 
1348     // blacklist
1349     mapping(address => bool) public blacklists;
1350 
1351     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1352     // could be subject to a maximum transfer amount
1353     mapping(address => bool) public automatedMarketMakerPairs;
1354 
1355     event UpdateUniswapV2Router(
1356         address indexed newAddress,
1357         address indexed oldAddress
1358     );
1359 
1360     event ExcludeFromFees(address indexed account, bool isExcluded);
1361 
1362     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1363 
1364     event marketingWalletUpdated(
1365         address indexed newWallet,
1366         address indexed oldWallet
1367     );
1368 
1369     event devWalletUpdated(
1370         address indexed newWallet,
1371         address indexed oldWallet
1372     );
1373 
1374     event SwapAndLiquify(
1375         uint256 tokensSwapped,
1376         uint256 ethReceived,
1377         uint256 tokensIntoLiquidity
1378     );
1379 
1380     event AutoNukeLP();
1381 
1382     event ManualNukeLP();
1383 
1384     constructor() ERC20("Unicard", "GIFT") {
1385         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1386             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1387         );
1388 
1389         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1390         uniswapV2Router = _uniswapV2Router;
1391 
1392         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1393             .createPair(address(this), _uniswapV2Router.WETH());
1394         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1395         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1396 
1397         uint256 _buyMarketingFee = 0;
1398         uint256 _buyLiquidityFee = 0;
1399         uint256 _buyDevFee = 5;
1400 
1401         uint256 _sellMarketingFee = 0;
1402         uint256 _sellLiquidityFee = 0;
1403         uint256 _sellDevFee = 30;
1404 
1405         uint256 totalSupply = 10_000_000 * 1e18;
1406 
1407         //  Maximum tx size and wallet size
1408         maxTokensPerTransaction = (totalSupply * 7) / 1000;
1409         maxTokensPerWallet = (totalSupply * 7) / 1000;
1410 
1411         swapTokensAtAmount = (totalSupply * 1) / 10000;
1412 
1413         buyMarketingFee = _buyMarketingFee;
1414         buyLiquidityFee = _buyLiquidityFee;
1415         buyDevFee = _buyDevFee;
1416         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1417 
1418         sellMarketingFee = _sellMarketingFee;
1419         sellLiquidityFee = _sellLiquidityFee;
1420         sellDevFee = _sellDevFee;
1421         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1422 
1423         marketingWallet = address(owner()); // set as marketing wallet
1424         devWallet = address(owner()); // set as dev wallet
1425 
1426         // exclude from paying fees or having max transaction amount
1427         excludeFromFees(owner(), true);
1428         excludeFromFees(address(this), true);
1429         excludeFromFees(address(0xdead), true);
1430 
1431         excludeFromMaxTransaction(owner(), true);
1432         excludeFromMaxTransaction(address(this), true);
1433         excludeFromMaxTransaction(address(0xdead), true);
1434 
1435         /*
1436             _mint is an internal function in ERC20.sol that is only called here,
1437             and CANNOT be called ever again
1438         */
1439         _mint(msg.sender, totalSupply);
1440     }
1441 
1442     receive() external payable {}
1443 
1444     function blacklist(
1445         address[] calldata _addresses,
1446         bool _isBlacklisting
1447     ) external onlyOwner {
1448         for (uint i = 0; i < _addresses.length; i++) {
1449             blacklists[_addresses[i]] = _isBlacklisting;
1450         }
1451     }
1452 
1453     // once enabled, can never be turned off
1454     function beginTrading() external onlyOwner {
1455         tradingActive = true;
1456         swapEnabled = true;
1457         lastLpBurnTime = block.timestamp;
1458     }
1459 
1460     // remove limits after token is stable
1461     function removeAllLimits() external onlyOwner returns (bool) {
1462         limitsInEffect = false;
1463         return true;
1464     }
1465 
1466     // disable Transfer delay - cannot be reenabled
1467     function removeTransferDelay() external onlyOwner returns (bool) {
1468         transferDelayEnabled = false;
1469         return true;
1470     }
1471 
1472     // change the minimum amount of tokens to sell from fees
1473     function updateSwapTokensAtAmount(
1474         uint256 newAmount
1475     ) external onlyOwner returns (bool) {
1476         require(
1477             newAmount >= (totalSupply() * 1) / 100000,
1478             "Swap amount cannot be lower than 0.001% total supply."
1479         );
1480         require(
1481             newAmount <= (totalSupply() * 10) / 1000,
1482             "Swap amount cannot be higher than 1% total supply."
1483         );
1484         swapTokensAtAmount = newAmount;
1485         return true;
1486     }
1487 
1488     function updateMaxBuy(
1489         uint256 maxPerTx,
1490         uint256 maxPerWallet
1491     ) external onlyOwner {
1492         require(
1493             maxPerTx >= ((totalSupply() * 1) / 1000) / 1e18,
1494             "Cannot set maxTokensPerTransaction lower than 0.1%"
1495         );
1496         maxTokensPerTransaction = maxPerTx * (10 ** 18);
1497 
1498         require(
1499             maxPerWallet >= ((totalSupply() * 5) / 1000) / 1e18,
1500             "Cannot set maxTokensPerWallet lower than 0.5%"
1501         );
1502         maxTokensPerWallet = maxPerWallet * (10 ** 18);
1503     }
1504 
1505     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1506         require(
1507             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1508             "Cannot set maxTokensPerTransaction lower than 0.1%"
1509         );
1510         maxTokensPerTransaction = newNum * (10 ** 18);
1511     }
1512 
1513     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1514         require(
1515             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1516             "Cannot set maxTokensPerWallet lower than 0.5%"
1517         );
1518         maxTokensPerWallet = newNum * (10 ** 18);
1519     }
1520 
1521     function excludeFromMaxTransaction(
1522         address updAds,
1523         bool isEx
1524     ) public onlyOwner {
1525         _isExcludedmaxTokensPerTransaction[updAds] = isEx;
1526     }
1527 
1528     // only use to disable contract sales if absolutely necessary (emergency use only)
1529     function updateSwapEnabled(bool enabled) external onlyOwner {
1530         swapEnabled = enabled;
1531     }
1532 
1533     function updateBuyFees(
1534         uint256 _marketingFee,
1535         uint256 _liquidityFee,
1536         uint256 _devFee
1537     ) external onlyOwner {
1538         buyMarketingFee = _marketingFee;
1539         buyLiquidityFee = _liquidityFee;
1540         buyDevFee = _devFee;
1541         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1542         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1543     }
1544 
1545     function updateSellFees(
1546         uint256 _marketingFee,
1547         uint256 _liquidityFee,
1548         uint256 _devFee
1549     ) external onlyOwner {
1550         sellMarketingFee = _marketingFee;
1551         sellLiquidityFee = _liquidityFee;
1552         sellDevFee = _devFee;
1553         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1554         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1555     }
1556 
1557     function updateTaxes(uint256 buy, uint256 sell) external onlyOwner {
1558         sellDevFee = sell;
1559         buyDevFee = buy;
1560         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1561         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1562         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1563         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1564     }
1565 
1566     function excludeFromFees(address account, bool excluded) public onlyOwner {
1567         _isExcludedFromFees[account] = excluded;
1568         emit ExcludeFromFees(account, excluded);
1569     }
1570 
1571     function setAutomatedMarketMakerPair(
1572         address pair,
1573         bool value
1574     ) public onlyOwner {
1575         require(
1576             pair != uniswapV2Pair,
1577             "The pair cannot be removed from automatedMarketMakerPairs"
1578         );
1579 
1580         _setAutomatedMarketMakerPair(pair, value);
1581     }
1582 
1583     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1584         automatedMarketMakerPairs[pair] = value;
1585 
1586         emit SetAutomatedMarketMakerPair(pair, value);
1587     }
1588 
1589     function updateMarketingWallet(
1590         address newMarketingWallet
1591     ) external onlyOwner {
1592         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1593         marketingWallet = newMarketingWallet;
1594     }
1595 
1596     function updateDevWallet(address newWallet) external onlyOwner {
1597         emit devWalletUpdated(newWallet, devWallet);
1598         devWallet = newWallet;
1599     }
1600 
1601     function isExcludedFromFees(address account) public view returns (bool) {
1602         return _isExcludedFromFees[account];
1603     }
1604 
1605     event BoughtEarly(address indexed sniper);
1606 
1607     function _transfer(
1608         address from,
1609         address to,
1610         uint256 amount
1611     ) internal override {
1612         require(from != address(0), "ERC20: transfer from the zero address");
1613         require(to != address(0), "ERC20: transfer to the zero address");
1614         require(!blacklists[to] && !blacklists[from], "Blacklisted");
1615 
1616         if (amount == 0) {
1617             super._transfer(from, to, 0);
1618             return;
1619         }
1620 
1621         if (limitsInEffect) {
1622             if (
1623                 from != owner() &&
1624                 to != owner() &&
1625                 to != address(0) &&
1626                 to != address(0xdead) &&
1627                 !swapping
1628             ) {
1629                 if (!tradingActive) {
1630                     require(
1631                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1632                         "Trading is not active."
1633                     );
1634                 }
1635 
1636                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1637                 if (transferDelayEnabled) {
1638                     if (
1639                         to != owner() &&
1640                         to != address(uniswapV2Router) &&
1641                         to != address(uniswapV2Pair)
1642                     ) {
1643                         require(
1644                             _holderLastTransferTimestamp[tx.origin] <
1645                                 block.number,
1646                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1647                         );
1648                         _holderLastTransferTimestamp[tx.origin] = block.number;
1649                     }
1650                 }
1651 
1652                 //when buy
1653                 if (
1654                     automatedMarketMakerPairs[from] &&
1655                     !_isExcludedmaxTokensPerTransaction[to]
1656                 ) {
1657                     require(
1658                         amount <= maxTokensPerTransaction,
1659                         "Buy transfer amount exceeds the maxTokensPerTransaction."
1660                     );
1661                     require(
1662                         amount + balanceOf(to) <= maxTokensPerWallet,
1663                         "Max wallet exceeded"
1664                     );
1665                 }
1666                 //when sell
1667                 else if (
1668                     automatedMarketMakerPairs[to] &&
1669                     !_isExcludedmaxTokensPerTransaction[from]
1670                 ) {
1671                     require(
1672                         amount <= maxTokensPerTransaction,
1673                         "Sell transfer amount exceeds the maxTokensPerTransaction."
1674                     );
1675                 } else if (!_isExcludedmaxTokensPerTransaction[to]) {
1676                     require(
1677                         amount + balanceOf(to) <= maxTokensPerWallet,
1678                         "Max wallet exceeded"
1679                     );
1680                 }
1681             }
1682         }
1683 
1684         uint256 contractTokenBalance = balanceOf(address(this));
1685 
1686         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1687 
1688         if (
1689             canSwap &&
1690             swapEnabled &&
1691             !swapping &&
1692             !automatedMarketMakerPairs[from] &&
1693             !_isExcludedFromFees[from] &&
1694             !_isExcludedFromFees[to]
1695         ) {
1696             swapping = true;
1697 
1698             swapBack();
1699 
1700             swapping = false;
1701         }
1702 
1703         if (
1704             !swapping &&
1705             automatedMarketMakerPairs[to] &&
1706             lpBurnEnabled &&
1707             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1708             !_isExcludedFromFees[from]
1709         ) {
1710             autoBurnLiquidityPairTokens();
1711         }
1712 
1713         bool takeFee = !swapping;
1714 
1715         // if any account belongs to _isExcludedFromFee account then remove the fee
1716         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1717             takeFee = false;
1718         }
1719 
1720         uint256 fees = 0;
1721         // only take fees on buys/sells, do not take on wallet transfers
1722         if (takeFee) {
1723             // on sell
1724             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1725                 fees = amount.mul(sellTotalFees).div(100);
1726                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1727                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1728                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1729             }
1730             // on buy
1731             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1732                 fees = amount.mul(buyTotalFees).div(100);
1733                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1734                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1735                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1736             }
1737 
1738             if (fees > 0) {
1739                 super._transfer(from, address(this), fees);
1740             }
1741 
1742             amount -= fees;
1743         }
1744 
1745         super._transfer(from, to, amount);
1746     }
1747 
1748     function swapTokensForEth(uint256 tokenAmount) private {
1749         // generate the uniswap pair path of token -> weth
1750         address[] memory path = new address[](2);
1751         path[0] = address(this);
1752         path[1] = uniswapV2Router.WETH();
1753 
1754         _approve(address(this), address(uniswapV2Router), tokenAmount);
1755 
1756         // make the swap
1757         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1758             tokenAmount,
1759             0, // accept any amount of ETH
1760             path,
1761             address(this),
1762             block.timestamp
1763         );
1764     }
1765 
1766     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1767         // approve token transfer to cover all possible scenarios
1768         _approve(address(this), address(uniswapV2Router), tokenAmount);
1769 
1770         // add the liquidity
1771         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1772             address(this),
1773             tokenAmount,
1774             0, // slippage is unavoidable
1775             0, // slippage is unavoidable
1776             deadAddress,
1777             block.timestamp
1778         );
1779     }
1780 
1781     function setAutoLPBurnSettings(
1782         uint256 _frequencyInSeconds,
1783         uint256 _percent,
1784         bool _Enabled
1785     ) external onlyOwner {
1786         require(
1787             _frequencyInSeconds >= 600,
1788             "cannot set buyback more often than every 10 minutes"
1789         );
1790         require(
1791             _percent <= 1000 && _percent >= 0,
1792             "Must set auto LP burn percent between 0% and 10%"
1793         );
1794         lpBurnFrequency = _frequencyInSeconds;
1795         percentForLPBurn = _percent;
1796         lpBurnEnabled = _Enabled;
1797     }
1798 
1799     function swapBack() private {
1800         uint256 contractBalance = balanceOf(address(this));
1801         uint256 totalTokensToSwap = tokensForLiquidity +
1802             tokensForMarketing +
1803             tokensForDev;
1804         bool success;
1805 
1806         if (contractBalance == 0 || totalTokensToSwap == 0) {
1807             return;
1808         }
1809 
1810         if (contractBalance > swapTokensAtAmount * 20) {
1811             contractBalance = swapTokensAtAmount * 20;
1812         }
1813 
1814         // Halve the amount of liquidity tokens
1815         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1816             totalTokensToSwap /
1817             2;
1818         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1819 
1820         uint256 initialETHBalance = address(this).balance;
1821 
1822         swapTokensForEth(amountToSwapForETH);
1823 
1824         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1825 
1826         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1827             totalTokensToSwap
1828         );
1829         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1830 
1831         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1832 
1833         tokensForLiquidity = 0;
1834         tokensForMarketing = 0;
1835         tokensForDev = 0;
1836 
1837         (success, ) = address(devWallet).call{value: ethForDev}("");
1838 
1839         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1840             addLiquidity(liquidityTokens, ethForLiquidity);
1841             emit SwapAndLiquify(
1842                 amountToSwapForETH,
1843                 ethForLiquidity,
1844                 tokensForLiquidity
1845             );
1846         }
1847 
1848         (success, ) = address(marketingWallet).call{
1849             value: address(this).balance
1850         }("");
1851     }
1852 
1853     function autoBurnLiquidityPairTokens() internal returns (bool) {
1854         lastLpBurnTime = block.timestamp;
1855 
1856         // get balance of liquidity pair
1857         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1858 
1859         // calculate amount to burn
1860         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1861             10000
1862         );
1863 
1864         // pull tokens from pancakePair liquidity and move to dead address permanently
1865         if (amountToBurn > 0) {
1866             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1867         }
1868 
1869         //sync price since this is not in a swap transaction!
1870         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1871         pair.sync();
1872         emit AutoNukeLP();
1873         return true;
1874     }
1875 
1876     function manualBurnLiquidityPairTokens(
1877         uint256 percent
1878     ) external onlyOwner returns (bool) {
1879         require(
1880             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1881             "Must wait for cooldown to finish"
1882         );
1883         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1884         lastManualLpBurnTime = block.timestamp;
1885 
1886         // get balance of liquidity pair
1887         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1888 
1889         // calculate amount to burn
1890         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1891 
1892         // pull tokens from pancakePair liquidity and move to dead address permanently
1893         if (amountToBurn > 0) {
1894             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1895         }
1896 
1897         //sync price since this is not in a swap transaction!
1898         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1899         pair.sync();
1900         emit ManualNukeLP();
1901         return true;
1902     }
1903 }