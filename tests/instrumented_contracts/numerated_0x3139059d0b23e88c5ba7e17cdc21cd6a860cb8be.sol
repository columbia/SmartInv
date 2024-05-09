1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5  *
6  * ELON TWEET COIN (ELONTC)
7  *
8  * Website: https://elontc.com
9  *
10  */ 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Emitted when `value` tokens are moved from one account (`from`) to
121      * another (`to`).
122      *
123      * Note that `value` may be zero.
124      */
125     event Transfer(address indexed from, address indexed to, uint value);
126 
127     /**
128      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
129      * a call to {approve}. `value` is the new allowance.
130      */
131     event Approval(address indexed owner, address indexed spender, uint value);
132 
133     /**
134      * @dev Returns the amount of tokens in existence.
135      */
136     function totalSupply() external view returns (uint);
137 
138     /**
139      * @dev Returns the amount of tokens owned by `account`.
140      */
141     function balanceOf(address account) external view returns (uint);
142 
143     /**
144      * @dev Moves `amount` tokens from the caller's account to `to`.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transfer(address to, uint amount) external returns (bool);
151 
152     /**
153      * @dev Returns the remaining number of tokens that `spender` will be
154      * allowed to spend on behalf of `owner` through {transferFrom}. This is
155      * zero by default.
156      *
157      * This value changes when {approve} or {transferFrom} are called.
158      */
159     function allowance(address owner, address spender) external view returns (uint);
160 
161     /**
162      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * IMPORTANT: Beware that changing an allowance with this method brings the risk
167      * that someone may use both the old and the new allowance by unfortunate
168      * transaction ordering. One possible solution to mitigate this race
169      * condition is to first reduce the spender's allowance to 0 and set the
170      * desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      *
173      * Emits an {Approval} event.
174      */
175     function approve(address spender, uint amount) external returns (bool);
176 
177     /**
178      * @dev Moves `amount` tokens from `from` to `to` using the
179      * allowance mechanism. `amount` is then deducted from the caller's
180      * allowance.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint amount
190     ) external returns (bool);
191 }
192 
193 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
194 
195 /**
196  * @dev Interface for the optional metadata functions from the ERC20 standard.
197  *
198  * _Available since v4.1._
199  */
200 interface IERC20Metadata is IERC20 {
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the symbol of the token.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the decimals places of the token.
213      */
214     function decimals() external view returns (uint8);
215 }
216 
217 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
218 
219 /**
220  * @dev Implementation of the {IERC20} interface.
221  *
222  * This implementation is agnostic to the way tokens are created. This means
223  * that a supply mechanism has to be added in a derived contract using {_mint}.
224  * For a generic mechanism see {ERC20PresetMinterPauser}.
225  *
226  * TIP: For a detailed writeup see our guide
227  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
228  * to implement supply mechanisms].
229  *
230  * We have followed general OpenZeppelin Contracts guidelines: functions revert
231  * instead returning `false` on failure. This behavior is nonetheless
232  * conventional and does not conflict with the expectations of ERC20
233  * applications.
234  *
235  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
236  * This allows applications to reconstruct the allowance for all accounts just
237  * by listening to said events. Other implementations of the EIP may not emit
238  * these events, as it isn't required by the specification.
239  *
240  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
241  * functions have been added to mitigate the well-known issues around setting
242  * allowances. See {IERC20-approve}.
243  */
244 contract ERC20 is Context, IERC20, IERC20Metadata {
245     mapping(address => uint) private _balances;
246 
247     mapping(address => mapping(address => uint)) private _allowances;
248 
249     uint private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253 
254     /**
255      * @dev Sets the values for {name} and {symbol}.
256      *
257      * The default value of {decimals} is 18. To select a different value for
258      * {decimals} you should overload it.
259      *
260      * All two of these values are immutable: they can only be set once during
261      * construction.
262      */
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     /**
269      * @dev Returns the name of the token.
270      */
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @dev Returns the symbol of the token, usually a shorter version of the
277      * name.
278      */
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @dev Returns the number of decimals used to get its user representation.
285      * For example, if `decimals` equals `2`, a balance of `505` tokens should
286      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
287      *
288      * Tokens usually opt for a value of 18, imitating the relationship between
289      * Ether and Wei. This is the value {ERC20} uses, unless this function is
290      * overridden;
291      *
292      * NOTE: This information is only used for _display_ purposes: it in
293      * no way affects any of the arithmetic of the contract, including
294      * {IERC20-balanceOf} and {IERC20-transfer}.
295      */
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     /**
301      * @dev See {IERC20-totalSupply}.
302      */
303     function totalSupply() public view virtual override returns (uint) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev See {IERC20-balanceOf}.
309      */
310     function balanceOf(address account) public view virtual override returns (uint) {
311         return _balances[account];
312     }
313 
314     /**
315      * @dev See {IERC20-transfer}.
316      *
317      * Requirements:
318      *
319      * - `to` cannot be the zero address.
320      * - the caller must have a balance of at least `amount`.
321      */
322     function transfer(address to, uint amount) public virtual override returns (bool) {
323         address owner = _msgSender();
324         _transfer(owner, to, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view virtual override returns (uint) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {IERC20-approve}.
337      *
338      * NOTE: If `amount` is the maximum `uint`, the allowance is not updated on
339      * `transferFrom`. This is semantically equivalent to an infinite approval.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function approve(address spender, uint amount) public virtual override returns (bool) {
346         address owner = _msgSender();
347         _approve(owner, spender, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-transferFrom}.
353      *
354      * Emits an {Approval} event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of {ERC20}.
356      *
357      * NOTE: Does not update the allowance if the current allowance
358      * is the maximum `uint`.
359      *
360      * Requirements:
361      *
362      * - `from` and `to` cannot be the zero address.
363      * - `from` must have a balance of at least `amount`.
364      * - the caller must have allowance for ``from``'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint amount
371     ) public virtual override returns (bool) {
372         address spender = _msgSender();
373         _spendAllowance(from, spender, amount);
374         _transfer(from, to, amount);
375         return true;
376     }
377 
378     /**
379      * @dev Atomically increases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
391         address owner = _msgSender();
392         _approve(owner, spender, allowance(owner, spender) + addedValue);
393         return true;
394     }
395 
396     /**
397      * @dev Atomically decreases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      * - `spender` must have allowance for the caller of at least
408      * `subtractedValue`.
409      */
410     function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
411         address owner = _msgSender();
412         uint currentAllowance = allowance(owner, spender);
413         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
414         unchecked {
415             _approve(owner, spender, currentAllowance - subtractedValue);
416         }
417 
418         return true;
419     }
420 
421     /**
422      * @dev Moves `amount` of tokens from `from` to `to`.
423      *
424      * This internal function is equivalent to {transfer}, and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a {Transfer} event.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `from` must have a balance of at least `amount`.
434      */
435     function _transfer(
436         address from,
437         address to,
438         uint amount
439     ) internal virtual {
440         require(from != address(0), "ERC20: transfer from the zero address");
441         require(to != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(from, to, amount);
444 
445         uint fromBalance = _balances[from];
446         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
447         unchecked {
448             _balances[from] = fromBalance - amount;
449             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
450             // decrementing then incrementing.
451             _balances[to] += amount;
452         }
453 
454         emit Transfer(from, to, amount);
455 
456         _afterTokenTransfer(from, to, amount);
457     }
458 
459     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
460      * the total supply.
461      *
462      * Emits a {Transfer} event with `from` set to the zero address.
463      *
464      * Requirements:
465      *
466      * - `account` cannot be the zero address.
467      */
468     function _mint(address account, uint amount) internal virtual {
469         require(account != address(0), "ERC20: mint to the zero address");
470 
471         _beforeTokenTransfer(address(0), account, amount);
472 
473         _totalSupply += amount;
474         unchecked {
475             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
476             _balances[account] += amount;
477         }
478         emit Transfer(address(0), account, amount);
479 
480         _afterTokenTransfer(address(0), account, amount);
481     }
482 
483     /**
484      * @dev Destroys `amount` tokens from `account`, reducing the
485      * total supply.
486      *
487      * Emits a {Transfer} event with `to` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      * - `account` must have at least `amount` tokens.
493      */
494     function _burn(address account, uint amount) internal virtual {
495         require(account != address(0), "ERC20: burn from the zero address");
496 
497         _beforeTokenTransfer(account, address(0), amount);
498 
499         uint accountBalance = _balances[account];
500         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
501         unchecked {
502             _balances[account] = accountBalance - amount;
503             // Overflow not possible: amount <= accountBalance <= totalSupply.
504             _totalSupply -= amount;
505         }
506 
507         emit Transfer(account, address(0), amount);
508 
509         _afterTokenTransfer(account, address(0), amount);
510     }
511 
512     /**
513      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
514      *
515      * This internal function is equivalent to `approve`, and can be used to
516      * e.g. set automatic allowances for certain subsystems, etc.
517      *
518      * Emits an {Approval} event.
519      *
520      * Requirements:
521      *
522      * - `owner` cannot be the zero address.
523      * - `spender` cannot be the zero address.
524      */
525     function _approve(
526         address owner,
527         address spender,
528         uint amount
529     ) internal virtual {
530         require(owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[owner][spender] = amount;
534         emit Approval(owner, spender, amount);
535     }
536 
537     /**
538      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
539      *
540      * Does not update the allowance amount in case of infinite allowance.
541      * Revert if not enough allowance is available.
542      *
543      * Might emit an {Approval} event.
544      */
545     function _spendAllowance(
546         address owner,
547         address spender,
548         uint amount
549     ) internal virtual {
550         uint currentAllowance = allowance(owner, spender);
551         if (currentAllowance != type(uint).max) {
552             require(currentAllowance >= amount, "ERC20: insufficient allowance");
553             unchecked {
554                 _approve(owner, spender, currentAllowance - amount);
555             }
556         }
557     }
558 
559     /**
560      * @dev Hook that is called before any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * will be transferred to `to`.
567      * - when `from` is zero, `amount` tokens will be minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _beforeTokenTransfer(
574         address from,
575         address to,
576         uint amount
577     ) internal virtual {}
578 
579     /**
580      * @dev Hook that is called after any transfer of tokens. This includes
581      * minting and burning.
582      *
583      * Calling conditions:
584      *
585      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
586      * has been transferred to `to`.
587      * - when `from` is zero, `amount` tokens have been minted for `to`.
588      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
589      * - `from` and `to` are never both zero.
590      *
591      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
592      */
593     function _afterTokenTransfer(
594         address from,
595         address to,
596         uint amount
597     ) internal virtual {}
598 }
599 
600 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
601 
602 // CAUTION
603 // This version of SafeMath should only be used with Solidity 0.8 or later,
604 // because it relies on the compiler's built in overflow checks.
605 
606 /**
607  * @dev Wrappers over Solidity's arithmetic operations.
608  *
609  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
610  * now has built in overflow checking.
611  */
612 library SafeMath {
613     /**
614      * @dev Returns the addition of two unsigned integers, with an overflow flag.
615      *
616      * _Available since v3.4._
617      */
618     function tryAdd(uint a, uint b) internal pure returns (bool, uint) {
619         unchecked {
620             uint c = a + b;
621             if (c < a) return (false, 0);
622             return (true, c);
623         }
624     }
625 
626     /**
627      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
628      *
629      * _Available since v3.4._
630      */
631     function trySub(uint a, uint b) internal pure returns (bool, uint) {
632         unchecked {
633             if (b > a) return (false, 0);
634             return (true, a - b);
635         }
636     }
637 
638     /**
639      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
640      *
641      * _Available since v3.4._
642      */
643     function tryMul(uint a, uint b) internal pure returns (bool, uint) {
644         unchecked {
645             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
646             // benefit is lost if 'b' is also tested.
647             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
648             if (a == 0) return (true, 0);
649             uint c = a * b;
650             if (c / a != b) return (false, 0);
651             return (true, c);
652         }
653     }
654 
655     /**
656      * @dev Returns the division of two unsigned integers, with a division by zero flag.
657      *
658      * _Available since v3.4._
659      */
660     function tryDiv(uint a, uint b) internal pure returns (bool, uint) {
661         unchecked {
662             if (b == 0) return (false, 0);
663             return (true, a / b);
664         }
665     }
666 
667     /**
668      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
669      *
670      * _Available since v3.4._
671      */
672     function tryMod(uint a, uint b) internal pure returns (bool, uint) {
673         unchecked {
674             if (b == 0) return (false, 0);
675             return (true, a % b);
676         }
677     }
678 
679     /**
680      * @dev Returns the addition of two unsigned integers, reverting on
681      * overflow.
682      *
683      * Counterpart to Solidity's `+` operator.
684      *
685      * Requirements:
686      *
687      * - Addition cannot overflow.
688      */
689     function add(uint a, uint b) internal pure returns (uint) {
690         return a + b;
691     }
692 
693     /**
694      * @dev Returns the subtraction of two unsigned integers, reverting on
695      * overflow (when the result is negative).
696      *
697      * Counterpart to Solidity's `-` operator.
698      *
699      * Requirements:
700      *
701      * - Subtraction cannot overflow.
702      */
703     function sub(uint a, uint b) internal pure returns (uint) {
704         return a - b;
705     }
706 
707     /**
708      * @dev Returns the multiplication of two unsigned integers, reverting on
709      * overflow.
710      *
711      * Counterpart to Solidity's `*` operator.
712      *
713      * Requirements:
714      *
715      * - Multiplication cannot overflow.
716      */
717     function mul(uint a, uint b) internal pure returns (uint) {
718         return a * b;
719     }
720 
721     /**
722      * @dev Returns the integer division of two unsigned integers, reverting on
723      * division by zero. The result is rounded towards zero.
724      *
725      * Counterpart to Solidity's `/` operator.
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function div(uint a, uint b) internal pure returns (uint) {
732         return a / b;
733     }
734 
735     /**
736      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
737      * reverting when dividing by zero.
738      *
739      * Counterpart to Solidity's `%` operator. This function uses a `revert`
740      * opcode (which leaves remaining gas untouched) while Solidity uses an
741      * invalid opcode to revert (consuming all remaining gas).
742      *
743      * Requirements:
744      *
745      * - The divisor cannot be zero.
746      */
747     function mod(uint a, uint b) internal pure returns (uint) {
748         return a % b;
749     }
750 
751     /**
752      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
753      * overflow (when the result is negative).
754      *
755      * CAUTION: This function is deprecated because it requires allocating memory for the error
756      * message unnecessarily. For custom revert reasons use {trySub}.
757      *
758      * Counterpart to Solidity's `-` operator.
759      *
760      * Requirements:
761      *
762      * - Subtraction cannot overflow.
763      */
764     function sub(
765         uint a,
766         uint b,
767         string memory errorMessage
768     ) internal pure returns (uint) {
769         unchecked {
770             require(b <= a, errorMessage);
771             return a - b;
772         }
773     }
774 
775     /**
776      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
777      * division by zero. The result is rounded towards zero.
778      *
779      * Counterpart to Solidity's `/` operator. Note: this function uses a
780      * `revert` opcode (which leaves remaining gas untouched) while Solidity
781      * uses an invalid opcode to revert (consuming all remaining gas).
782      *
783      * Requirements:
784      *
785      * - The divisor cannot be zero.
786      */
787     function div(
788         uint a,
789         uint b,
790         string memory errorMessage
791     ) internal pure returns (uint) {
792         unchecked {
793             require(b > 0, errorMessage);
794             return a / b;
795         }
796     }
797 
798     /**
799      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
800      * reverting with custom message when dividing by zero.
801      *
802      * CAUTION: This function is deprecated because it requires allocating memory for the error
803      * message unnecessarily. For custom revert reasons use {tryMod}.
804      *
805      * Counterpart to Solidity's `%` operator. This function uses a `revert`
806      * opcode (which leaves remaining gas untouched) while Solidity uses an
807      * invalid opcode to revert (consuming all remaining gas).
808      *
809      * Requirements:
810      *
811      * - The divisor cannot be zero.
812      */
813     function mod(
814         uint a,
815         uint b,
816         string memory errorMessage
817     ) internal pure returns (uint) {
818         unchecked {
819             require(b > 0, errorMessage);
820             return a % b;
821         }
822     }
823 }
824 
825 interface IUniswapV2Factory {
826     event PairCreated(
827         address indexed token0,
828         address indexed token1,
829         address pair,
830         uint
831     );
832 
833     function feeTo() external view returns (address);
834 
835     function feeToSetter() external view returns (address);
836 
837     function getPair(address tokenA, address tokenB)
838         external
839         view
840         returns (address pair);
841 
842     function allPairs(uint) external view returns (address pair);
843 
844     function allPairsLength() external view returns (uint);
845 
846     function createPair(address tokenA, address tokenB)
847         external
848         returns (address pair);
849 
850     function setFeeTo(address) external;
851 
852     function setFeeToSetter(address) external;
853 }
854 
855 interface IUniswapV2Pair {
856     event Approval(
857         address indexed owner,
858         address indexed spender,
859         uint value
860     );
861     event Transfer(address indexed from, address indexed to, uint value);
862 
863     function name() external pure returns (string memory);
864 
865     function symbol() external pure returns (string memory);
866 
867     function decimals() external pure returns (uint8);
868 
869     function totalSupply() external view returns (uint);
870 
871     function balanceOf(address owner) external view returns (uint);
872 
873     function allowance(address owner, address spender)
874         external
875         view
876         returns (uint);
877 
878     function approve(address spender, uint value) external returns (bool);
879 
880     function transfer(address to, uint value) external returns (bool);
881 
882     function transferFrom(
883         address from,
884         address to,
885         uint value
886     ) external returns (bool);
887 
888     function DOMAIN_SEPARATOR() external view returns (bytes32);
889 
890     function PERMIT_TYPEHASH() external pure returns (bytes32);
891 
892     function nonces(address owner) external view returns (uint);
893 
894     function permit(
895         address owner,
896         address spender,
897         uint value,
898         uint deadline,
899         uint8 v,
900         bytes32 r,
901         bytes32 s
902     ) external;
903 
904     event Mint(address indexed sender, uint amount0, uint amount1);
905     event Burn(
906         address indexed sender,
907         uint amount0,
908         uint amount1,
909         address indexed to
910     );
911     event Swap(
912         address indexed sender,
913         uint amount0In,
914         uint amount1In,
915         uint amount0Out,
916         uint amount1Out,
917         address indexed to
918     );
919     event Sync(uint112 reserve0, uint112 reserve1);
920 
921     function MINIMUM_LIQUIDITY() external pure returns (uint);
922 
923     function factory() external view returns (address);
924 
925     function token0() external view returns (address);
926 
927     function token1() external view returns (address);
928 
929     function getReserves()
930         external
931         view
932         returns (
933             uint112 reserve0,
934             uint112 reserve1,
935             uint32 blockTimestampLast
936         );
937 
938     function price0CumulativeLast() external view returns (uint);
939 
940     function price1CumulativeLast() external view returns (uint);
941 
942     function kLast() external view returns (uint);
943 
944     function mint(address to) external returns (uint liquidity);
945 
946     function burn(address to)
947         external
948         returns (uint amount0, uint amount1);
949 
950     function swap(
951         uint amount0Out,
952         uint amount1Out,
953         address to,
954         bytes calldata data
955     ) external;
956 
957     function skim(address to) external;
958 
959     function sync() external;
960 
961     function initialize(address, address) external;
962 }
963 
964 interface IUniswapV2Router02 {
965     function factory() external pure returns (address);
966 
967     function WETH() external pure returns (address);
968 
969     function addLiquidity(
970         address tokenA,
971         address tokenB,
972         uint amountADesired,
973         uint amountBDesired,
974         uint amountAMin,
975         uint amountBMin,
976         address to,
977         uint deadline
978     )
979         external
980         returns (
981             uint amountA,
982             uint amountB,
983             uint liquidity
984         );
985 
986     function addLiquidityETH(
987         address token,
988         uint amountTokenDesired,
989         uint amountTokenMin,
990         uint amountETHMin,
991         address to,
992         uint deadline
993     )
994         external
995         payable
996         returns (
997             uint amountToken,
998             uint amountETH,
999             uint liquidity
1000         );
1001 
1002     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1003         uint amountIn,
1004         uint amountOutMin,
1005         address[] calldata path,
1006         address to,
1007         uint deadline
1008     ) external;
1009 
1010     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1011         uint amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint deadline
1015     ) external payable;
1016 
1017     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1018         uint amountIn,
1019         uint amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint deadline
1023     ) external;
1024 }
1025 
1026 interface ISwapManager {
1027     function swapToUsdc(uint tokenAmount) external;
1028     function addLiquidity(uint tokenAmount, uint usdcAmount) external;
1029 }
1030 
1031 contract ElonTweetCoin is ERC20, Ownable {
1032     using SafeMath for uint;
1033 
1034     IUniswapV2Router02 public immutable uniswapV2Router;
1035     address public immutable uniswapV2Pair;
1036     address public constant deadAddress = address(0xdead);
1037     address public constant usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1038 
1039     bool private swapping;
1040 
1041     address public marketingWallet;
1042     address public buybackWallet;
1043 
1044     ISwapManager public swapManager;
1045     uint public maxTransactionAmount;
1046     uint public swapTokensAtAmount;
1047     uint public maxWallet;
1048 
1049     bool public limitsInEffect = true;
1050     bool public tradingActive = false;
1051     bool public swapEnabled = false;
1052 
1053     // Anti-bot and anti-whale mappings and variables
1054     mapping(address => uint) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1055     bool public transferDelayEnabled = true;
1056 
1057     uint public buyTotalFees;
1058     uint public buyMarketingFee;
1059     uint public buyLiquidityFee;
1060     uint public buyBuybackFee;
1061 
1062     uint public sellTotalFees;
1063     uint public sellMarketingFee;
1064     uint public sellLiquidityFee;
1065     uint public sellBuybackFee;
1066 
1067     uint public tokensForMarketing;
1068     uint public tokensForLiquidity;
1069     uint public tokensForBuyback;
1070 
1071     // exlcude from fees and max transaction amount
1072     mapping(address => bool) private _isExcludedFromFees;
1073     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1074 
1075     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1076     // could be subject to a maximum transfer amount
1077     mapping(address => bool) public automatedMarketMakerPairs;
1078 
1079     event UpdateUniswapV2Router(
1080         address indexed newAddress,
1081         address indexed oldAddress
1082     );
1083 
1084     event ExcludeFromFees(address indexed account, bool isExcluded);
1085 
1086     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1087 
1088     event SwapManagerUpdated(
1089         address indexed newManager,
1090         address indexed oldManager
1091     );
1092 
1093     event MarketingWalletUpdated(
1094         address indexed newWallet,
1095         address indexed oldWallet
1096     );
1097 
1098     event BuybackWalletUpdated(
1099         address indexed newWallet,
1100         address indexed oldWallet
1101     );
1102 
1103     event SwapAndLiquify(
1104         uint tokensSwapped,
1105         uint usdcReceived,
1106         uint tokensIntoLiquidity
1107     );
1108 
1109     constructor() ERC20("Elon Tweet Coin", "ELONTC") {
1110         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1111 
1112         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1113         uniswapV2Router = _uniswapV2Router;
1114 
1115         address pair = IUniswapV2Factory(_uniswapV2Router.factory())
1116             .createPair(address(this), usdc);
1117             
1118         uniswapV2Pair = pair;
1119         excludeFromMaxTransaction(pair, true);
1120         _setAutomatedMarketMakerPair(pair, true);
1121 
1122         uint totalSupply = 199_000_000_000 * 1e18;
1123 
1124         maxTransactionAmount = totalSupply * 5 / 1000;
1125         maxWallet = totalSupply / 100;
1126         swapTokensAtAmount = totalSupply / 1000;
1127 
1128         buyMarketingFee = 2;
1129         buyLiquidityFee = 1;
1130         buyBuybackFee = 5;
1131         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuybackFee;
1132 
1133         sellMarketingFee = 2;
1134         sellLiquidityFee = 1;
1135         sellBuybackFee = 5;
1136         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuybackFee;
1137 
1138         marketingWallet = address(0x9E491303188109DFB63f7AF532812211032Adeca);
1139         buybackWallet = address(0xaba1168b5aC290B94E852A29176Df9073917fe20);
1140 
1141         // exclude from paying fees or having max transaction amount
1142         excludeFromFees(owner(), true);
1143         excludeFromFees(address(this), true);
1144         excludeFromFees(deadAddress, true);
1145         excludeFromFees(marketingWallet, true);
1146         excludeFromFees(buybackWallet, true);
1147 
1148         excludeFromMaxTransaction(owner(), true);
1149         excludeFromMaxTransaction(address(this), true);
1150         excludeFromMaxTransaction(deadAddress, true);
1151         excludeFromMaxTransaction(marketingWallet, true);
1152         excludeFromMaxTransaction(buybackWallet, true);
1153 
1154         /*
1155             _mint is an internal function in ERC20.sol that is only called here,
1156             and CANNOT be called ever again
1157         */
1158         _mint(msg.sender, totalSupply);
1159     }
1160 
1161     // once enabled, can never be turned off
1162     function enableTrading() external onlyOwner {
1163         require (
1164             address(swapManager) != address(0), 
1165             "Need to set swap manager"
1166         );
1167         tradingActive = true;
1168         swapEnabled = true;
1169     }
1170 
1171     // remove limits after token is stable
1172     function removeLimits() external onlyOwner returns (bool) {
1173         limitsInEffect = false;
1174         return true;
1175     }
1176 
1177     // disable Transfer delay - cannot be reenabled
1178     function disableTransferDelay() external onlyOwner returns (bool) {
1179         transferDelayEnabled = false;
1180         return true;
1181     }
1182 
1183     // change the minimum amount of tokens to sell from fees
1184     function updateSwapTokensAtAmount(uint newAmount)
1185         external
1186         onlyOwner
1187         returns (bool)
1188     {
1189         require(
1190             newAmount >= (totalSupply() * 1) / 100000,
1191             "Swap amount cannot be lower than 0.001% total supply."
1192         );
1193         require(
1194             newAmount <= (totalSupply() * 5) / 1000,
1195             "Swap amount cannot be higher than 0.5% total supply."
1196         );
1197         swapTokensAtAmount = newAmount;
1198         return true;
1199     }
1200 
1201     function updateMaxTxnAmount(uint newNum) external onlyOwner {
1202         require(
1203             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1204             "Cannot set maxTransactionAmount lower than 0.1%"
1205         );
1206         maxTransactionAmount = newNum * (10**18);
1207     }
1208 
1209     function updateMaxWalletAmount(uint newNum) external onlyOwner {
1210         require(
1211             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1212             "Cannot set maxWallet lower than 0.5%"
1213         );
1214         maxWallet = newNum * (10**18);
1215     }
1216 
1217     function excludeFromMaxTransaction(address updAds, bool isEx)
1218         public
1219         onlyOwner
1220     {
1221         _isExcludedMaxTransactionAmount[updAds] = isEx;
1222     }
1223 
1224     function updateSwapManager(address newManager) external onlyOwner {
1225         emit SwapManagerUpdated(newManager, address(swapManager));
1226         swapManager = ISwapManager(newManager);
1227         excludeFromFees(newManager, true);
1228         excludeFromMaxTransaction(newManager, true);
1229     }
1230 
1231     // only use to disable contract sales if absolutely necessary (emergency use only)
1232     function updateSwapEnabled(bool enabled) external onlyOwner {
1233         swapEnabled = enabled;
1234     }
1235 
1236     function excludeFromFees(address account, bool excluded) public onlyOwner {
1237         _isExcludedFromFees[account] = excluded;
1238         emit ExcludeFromFees(account, excluded);
1239     }
1240 
1241     function setAutomatedMarketMakerPair(address pair, bool value)
1242         public
1243         onlyOwner
1244     {
1245         require(
1246             pair != uniswapV2Pair,
1247             "The pair cannot be removed from automatedMarketMakerPairs"
1248         );
1249 
1250         _setAutomatedMarketMakerPair(pair, value);
1251     }
1252 
1253     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1254         automatedMarketMakerPairs[pair] = value;
1255 
1256         emit SetAutomatedMarketMakerPair(pair, value);
1257     }
1258 
1259     function updateMarketingWallet(address newMarketingWallet)
1260         external
1261         onlyOwner
1262     {
1263         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
1264         marketingWallet = newMarketingWallet;
1265     }
1266 
1267     function updateBuybackWallet(address newBuybackWallet) external onlyOwner {
1268         emit BuybackWalletUpdated(newBuybackWallet, buybackWallet);
1269         buybackWallet = newBuybackWallet;
1270     }
1271 
1272     function isExcludedFromFees(address account) public view returns (bool) {
1273         return _isExcludedFromFees[account];
1274     }
1275 
1276     function _transfer(
1277         address from,
1278         address to,
1279         uint amount
1280     ) internal override {
1281         require(from != address(0), "ERC20: transfer from the zero address");
1282         require(to != address(0), "ERC20: transfer to the zero address");
1283 
1284         if (amount == 0) {
1285             super._transfer(from, to, 0);
1286             return;
1287         }
1288 
1289         if (limitsInEffect) {
1290             if (
1291                 from != owner() &&
1292                 to != owner() &&
1293                 to != address(0) &&
1294                 to != address(0xdead) &&
1295                 !swapping
1296             ) {
1297                 if (!tradingActive) {
1298                     require(
1299                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1300                         "Trading is not active."
1301                     );
1302                 }
1303 
1304                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1305                 if (transferDelayEnabled) {
1306                     if (
1307                         to != owner() &&
1308                         to != address(uniswapV2Router) &&
1309                         to != address(uniswapV2Pair) &&
1310                         !_isExcludedFromFees[from]
1311                     ) {
1312                         require(
1313                             _holderLastTransferTimestamp[tx.origin] <
1314                                 block.number,
1315                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1316                         );
1317                         _holderLastTransferTimestamp[tx.origin] = block.number;
1318                     }
1319                 }
1320 
1321                 //when buy
1322                 if (
1323                     automatedMarketMakerPairs[from] &&
1324                     !_isExcludedMaxTransactionAmount[to]
1325                 ) {
1326                     require(
1327                         amount <= maxTransactionAmount,
1328                         "Buy transfer amount exceeds the maxTransactionAmount."
1329                     );
1330                     require(
1331                         amount + balanceOf(to) <= maxWallet,
1332                         "Max wallet exceeded"
1333                     );
1334                 }
1335                 //when sell
1336                 else if (
1337                     automatedMarketMakerPairs[to] &&
1338                     !_isExcludedMaxTransactionAmount[from]
1339                 ) {
1340                     require(
1341                         amount <= maxTransactionAmount,
1342                         "Sell transfer amount exceeds the maxTransactionAmount."
1343                     );
1344                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1345                     require(
1346                         amount + balanceOf(to) <= maxWallet,
1347                         "Max wallet exceeded"
1348                     );
1349                 }
1350             }
1351         }
1352 
1353         uint contractTokenBalance = balanceOf(address(this));
1354 
1355         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1356 
1357         if (
1358             canSwap &&
1359             swapEnabled &&
1360             !swapping &&
1361             !automatedMarketMakerPairs[from] &&
1362             !_isExcludedFromFees[from] &&
1363             !_isExcludedFromFees[to]
1364         ) {
1365             swapping = true;
1366 
1367             swapBack();
1368 
1369             swapping = false;
1370         }
1371 
1372         bool takeFee = !swapping;
1373 
1374         // if any account belongs to _isExcludedFromFee account then remove the fee
1375         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1376             takeFee = false;
1377         }
1378 
1379         uint fees = 0;
1380         // only take fees on buys/sells, do not take on wallet transfers
1381         if (takeFee) {
1382             // on sell
1383             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1384                 fees = amount.mul(sellTotalFees).div(100);
1385                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1386                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1387                 tokensForBuyback += (fees * sellBuybackFee) / sellTotalFees;
1388             }
1389 
1390             // on buy
1391             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1392                 fees = amount.mul(buyTotalFees).div(100);
1393                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1394                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1395                 tokensForBuyback += (fees * buyBuybackFee) / buyTotalFees;
1396             }
1397 
1398             if (fees > 0) {
1399                 super._transfer(from, address(this), fees);
1400             }
1401 
1402             amount -= fees;
1403         }
1404 
1405         super._transfer(from, to, amount);
1406     }
1407 
1408     function swapBack() private {
1409         uint contractBalance = balanceOf(address(this));
1410         uint totalTokensToSwap = tokensForMarketing +
1411             tokensForLiquidity +
1412             tokensForBuyback;
1413 
1414         if (contractBalance == 0 || totalTokensToSwap == 0) {
1415             return;
1416         }
1417 
1418         if (contractBalance > swapTokensAtAmount * 20) {
1419             contractBalance = swapTokensAtAmount * 20;
1420         }
1421 
1422         uint liquidityTokens = (contractBalance * tokensForLiquidity) /
1423             totalTokensToSwap / 2;
1424         uint amountToSwapForUsdc = contractBalance.sub(liquidityTokens);
1425 
1426         uint initialUsdcBalance = IERC20(usdc).balanceOf(address(this));
1427 
1428         _approve(address(this), address(swapManager), amountToSwapForUsdc);
1429         swapManager.swapToUsdc(amountToSwapForUsdc);
1430 
1431         uint usdcBalance = IERC20(usdc).balanceOf(address(this)).sub(initialUsdcBalance);
1432 
1433         uint usdcForMarketing = usdcBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1434         uint usdcForBuyback = usdcBalance.mul(tokensForBuyback).div(totalTokensToSwap);
1435         uint usdcForLiquidity = usdcBalance - usdcForMarketing - usdcForBuyback;
1436 
1437         tokensForMarketing = 0;
1438         tokensForLiquidity = 0;
1439         tokensForBuyback = 0;
1440 
1441         IERC20(usdc).transfer(marketingWallet, usdcForMarketing);
1442 
1443         if (liquidityTokens > 0 && usdcForLiquidity > 0) {
1444             _approve(address(this), address(swapManager), liquidityTokens);
1445             IERC20(usdc).approve(address(swapManager), usdcForLiquidity);
1446 
1447             swapManager.addLiquidity(liquidityTokens, usdcForLiquidity);
1448 
1449             emit SwapAndLiquify(
1450                 amountToSwapForUsdc,
1451                 usdcForLiquidity,
1452                 tokensForLiquidity
1453             );
1454         }
1455 
1456         IERC20(usdc).transfer(buybackWallet, IERC20(usdc).balanceOf(address(this)));
1457     }
1458 }