1 // Sources flattened with hardhat v2.13.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
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
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.2
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.2
117 
118 
119 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
120 
121 pragma solidity ^0.8.0;
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
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `to`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address to, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `from` to `to` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 amount
198     ) external returns (bool);
199 }
200 
201 
202 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.2
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Interface for the optional metadata functions from the ERC20 standard.
211  *
212  * _Available since v4.1._
213  */
214 interface IERC20Metadata is IERC20 {
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the symbol of the token.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the decimals places of the token.
227      */
228     function decimals() external view returns (uint8);
229 }
230 
231 
232 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.2
233 
234 
235 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20PresetMinterPauser}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin Contracts guidelines: functions revert
253  * instead returning `false` on failure. This behavior is nonetheless
254  * conventional and does not conflict with the expectations of ERC20
255  * applications.
256  *
257  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See {IERC20-approve}.
265  */
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     mapping(address => uint256) private _balances;
268 
269     mapping(address => mapping(address => uint256)) private _allowances;
270 
271     uint256 private _totalSupply;
272 
273     string private _name;
274     string private _symbol;
275 
276     /**
277      * @dev Sets the values for {name} and {symbol}.
278      *
279      * The default value of {decimals} is 18. To select a different value for
280      * {decimals} you should overload it.
281      *
282      * All two of these values are immutable: they can only be set once during
283      * construction.
284      */
285     constructor(string memory name_, string memory symbol_) {
286         _name = name_;
287         _symbol = symbol_;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view virtual override returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view virtual override returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei. This is the value {ERC20} uses, unless this function is
312      * overridden;
313      *
314      * NOTE: This information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * {IERC20-balanceOf} and {IERC20-transfer}.
317      */
318     function decimals() public view virtual override returns (uint8) {
319         return 18;
320     }
321 
322     /**
323      * @dev See {IERC20-totalSupply}.
324      */
325     function totalSupply() public view virtual override returns (uint256) {
326         return _totalSupply;
327     }
328 
329     /**
330      * @dev See {IERC20-balanceOf}.
331      */
332     function balanceOf(address account) public view virtual override returns (uint256) {
333         return _balances[account];
334     }
335 
336     /**
337      * @dev See {IERC20-transfer}.
338      *
339      * Requirements:
340      *
341      * - `to` cannot be the zero address.
342      * - the caller must have a balance of at least `amount`.
343      */
344     function transfer(address to, uint256 amount) public virtual override returns (bool) {
345         address owner = _msgSender();
346         _transfer(owner, to, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender) public view virtual override returns (uint256) {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
361      * `transferFrom`. This is semantically equivalent to an infinite approval.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function approve(address spender, uint256 amount) public virtual override returns (bool) {
368         address owner = _msgSender();
369         _approve(owner, spender, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-transferFrom}.
375      *
376      * Emits an {Approval} event indicating the updated allowance. This is not
377      * required by the EIP. See the note at the beginning of {ERC20}.
378      *
379      * NOTE: Does not update the allowance if the current allowance
380      * is the maximum `uint256`.
381      *
382      * Requirements:
383      *
384      * - `from` and `to` cannot be the zero address.
385      * - `from` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``from``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(
390         address from,
391         address to,
392         uint256 amount
393     ) public virtual override returns (bool) {
394         address spender = _msgSender();
395         _spendAllowance(from, spender, amount);
396         _transfer(from, to, amount);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically increases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      */
412     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
413         address owner = _msgSender();
414         _approve(owner, spender, allowance(owner, spender) + addedValue);
415         return true;
416     }
417 
418     /**
419      * @dev Atomically decreases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      * - `spender` must have allowance for the caller of at least
430      * `subtractedValue`.
431      */
432     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
433         address owner = _msgSender();
434         uint256 currentAllowance = allowance(owner, spender);
435         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
436         unchecked {
437             _approve(owner, spender, currentAllowance - subtractedValue);
438         }
439 
440         return true;
441     }
442 
443     /**
444      * @dev Moves `amount` of tokens from `from` to `to`.
445      *
446      * This internal function is equivalent to {transfer}, and can be used to
447      * e.g. implement automatic token fees, slashing mechanisms, etc.
448      *
449      * Emits a {Transfer} event.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `from` must have a balance of at least `amount`.
456      */
457     function _transfer(
458         address from,
459         address to,
460         uint256 amount
461     ) internal virtual {
462         require(from != address(0), "ERC20: transfer from the zero address");
463         require(to != address(0), "ERC20: transfer to the zero address");
464 
465         _beforeTokenTransfer(from, to, amount);
466 
467         uint256 fromBalance = _balances[from];
468         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
469         unchecked {
470             _balances[from] = fromBalance - amount;
471             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
472             // decrementing then incrementing.
473             _balances[to] += amount;
474         }
475 
476         emit Transfer(from, to, amount);
477 
478         _afterTokenTransfer(from, to, amount);
479     }
480 
481     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
482      * the total supply.
483      *
484      * Emits a {Transfer} event with `from` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `account` cannot be the zero address.
489      */
490     function _mint(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: mint to the zero address");
492 
493         _beforeTokenTransfer(address(0), account, amount);
494 
495         _totalSupply += amount;
496         unchecked {
497             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
498             _balances[account] += amount;
499         }
500         emit Transfer(address(0), account, amount);
501 
502         _afterTokenTransfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _beforeTokenTransfer(account, address(0), amount);
520 
521         uint256 accountBalance = _balances[account];
522         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
523         unchecked {
524             _balances[account] = accountBalance - amount;
525             // Overflow not possible: amount <= accountBalance <= totalSupply.
526             _totalSupply -= amount;
527         }
528 
529         emit Transfer(account, address(0), amount);
530 
531         _afterTokenTransfer(account, address(0), amount);
532     }
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
536      *
537      * This internal function is equivalent to `approve`, and can be used to
538      * e.g. set automatic allowances for certain subsystems, etc.
539      *
540      * Emits an {Approval} event.
541      *
542      * Requirements:
543      *
544      * - `owner` cannot be the zero address.
545      * - `spender` cannot be the zero address.
546      */
547     function _approve(
548         address owner,
549         address spender,
550         uint256 amount
551     ) internal virtual {
552         require(owner != address(0), "ERC20: approve from the zero address");
553         require(spender != address(0), "ERC20: approve to the zero address");
554 
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     /**
560      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
561      *
562      * Does not update the allowance amount in case of infinite allowance.
563      * Revert if not enough allowance is available.
564      *
565      * Might emit an {Approval} event.
566      */
567     function _spendAllowance(
568         address owner,
569         address spender,
570         uint256 amount
571     ) internal virtual {
572         uint256 currentAllowance = allowance(owner, spender);
573         if (currentAllowance != type(uint256).max) {
574             require(currentAllowance >= amount, "ERC20: insufficient allowance");
575             unchecked {
576                 _approve(owner, spender, currentAllowance - amount);
577             }
578         }
579     }
580 
581     /**
582      * @dev Hook that is called before any transfer of tokens. This includes
583      * minting and burning.
584      *
585      * Calling conditions:
586      *
587      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
588      * will be transferred to `to`.
589      * - when `from` is zero, `amount` tokens will be minted for `to`.
590      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
591      * - `from` and `to` are never both zero.
592      *
593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
594      */
595     function _beforeTokenTransfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal virtual {}
600 
601     /**
602      * @dev Hook that is called after any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * has been transferred to `to`.
609      * - when `from` is zero, `amount` tokens have been minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _afterTokenTransfer(
616         address from,
617         address to,
618         uint256 amount
619     ) internal virtual {}
620 }
621 
622 
623 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.8.2
624 
625 
626 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 // CAUTION
631 // This version of SafeMath should only be used with Solidity 0.8 or later,
632 // because it relies on the compiler's built in overflow checks.
633 
634 /**
635  * @dev Wrappers over Solidity's arithmetic operations.
636  *
637  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
638  * now has built in overflow checking.
639  */
640 library SafeMath {
641     /**
642      * @dev Returns the addition of two unsigned integers, with an overflow flag.
643      *
644      * _Available since v3.4._
645      */
646     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
647         unchecked {
648             uint256 c = a + b;
649             if (c < a) return (false, 0);
650             return (true, c);
651         }
652     }
653 
654     /**
655      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
656      *
657      * _Available since v3.4._
658      */
659     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             if (b > a) return (false, 0);
662             return (true, a - b);
663         }
664     }
665 
666     /**
667      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
668      *
669      * _Available since v3.4._
670      */
671     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
672         unchecked {
673             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
674             // benefit is lost if 'b' is also tested.
675             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
676             if (a == 0) return (true, 0);
677             uint256 c = a * b;
678             if (c / a != b) return (false, 0);
679             return (true, c);
680         }
681     }
682 
683     /**
684      * @dev Returns the division of two unsigned integers, with a division by zero flag.
685      *
686      * _Available since v3.4._
687      */
688     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
689         unchecked {
690             if (b == 0) return (false, 0);
691             return (true, a / b);
692         }
693     }
694 
695     /**
696      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
697      *
698      * _Available since v3.4._
699      */
700     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
701         unchecked {
702             if (b == 0) return (false, 0);
703             return (true, a % b);
704         }
705     }
706 
707     /**
708      * @dev Returns the addition of two unsigned integers, reverting on
709      * overflow.
710      *
711      * Counterpart to Solidity's `+` operator.
712      *
713      * Requirements:
714      *
715      * - Addition cannot overflow.
716      */
717     function add(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a + b;
719     }
720 
721     /**
722      * @dev Returns the subtraction of two unsigned integers, reverting on
723      * overflow (when the result is negative).
724      *
725      * Counterpart to Solidity's `-` operator.
726      *
727      * Requirements:
728      *
729      * - Subtraction cannot overflow.
730      */
731     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a - b;
733     }
734 
735     /**
736      * @dev Returns the multiplication of two unsigned integers, reverting on
737      * overflow.
738      *
739      * Counterpart to Solidity's `*` operator.
740      *
741      * Requirements:
742      *
743      * - Multiplication cannot overflow.
744      */
745     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a * b;
747     }
748 
749     /**
750      * @dev Returns the integer division of two unsigned integers, reverting on
751      * division by zero. The result is rounded towards zero.
752      *
753      * Counterpart to Solidity's `/` operator.
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function div(uint256 a, uint256 b) internal pure returns (uint256) {
760         return a / b;
761     }
762 
763     /**
764      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
765      * reverting when dividing by zero.
766      *
767      * Counterpart to Solidity's `%` operator. This function uses a `revert`
768      * opcode (which leaves remaining gas untouched) while Solidity uses an
769      * invalid opcode to revert (consuming all remaining gas).
770      *
771      * Requirements:
772      *
773      * - The divisor cannot be zero.
774      */
775     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
776         return a % b;
777     }
778 
779     /**
780      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
781      * overflow (when the result is negative).
782      *
783      * CAUTION: This function is deprecated because it requires allocating memory for the error
784      * message unnecessarily. For custom revert reasons use {trySub}.
785      *
786      * Counterpart to Solidity's `-` operator.
787      *
788      * Requirements:
789      *
790      * - Subtraction cannot overflow.
791      */
792     function sub(
793         uint256 a,
794         uint256 b,
795         string memory errorMessage
796     ) internal pure returns (uint256) {
797         unchecked {
798             require(b <= a, errorMessage);
799             return a - b;
800         }
801     }
802 
803     /**
804      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
805      * division by zero. The result is rounded towards zero.
806      *
807      * Counterpart to Solidity's `/` operator. Note: this function uses a
808      * `revert` opcode (which leaves remaining gas untouched) while Solidity
809      * uses an invalid opcode to revert (consuming all remaining gas).
810      *
811      * Requirements:
812      *
813      * - The divisor cannot be zero.
814      */
815     function div(
816         uint256 a,
817         uint256 b,
818         string memory errorMessage
819     ) internal pure returns (uint256) {
820         unchecked {
821             require(b > 0, errorMessage);
822             return a / b;
823         }
824     }
825 
826     /**
827      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
828      * reverting with custom message when dividing by zero.
829      *
830      * CAUTION: This function is deprecated because it requires allocating memory for the error
831      * message unnecessarily. For custom revert reasons use {tryMod}.
832      *
833      * Counterpart to Solidity's `%` operator. This function uses a `revert`
834      * opcode (which leaves remaining gas untouched) while Solidity uses an
835      * invalid opcode to revert (consuming all remaining gas).
836      *
837      * Requirements:
838      *
839      * - The divisor cannot be zero.
840      */
841     function mod(
842         uint256 a,
843         uint256 b,
844         string memory errorMessage
845     ) internal pure returns (uint256) {
846         unchecked {
847             require(b > 0, errorMessage);
848             return a % b;
849         }
850     }
851 }
852 
853 
854 // File contracts/dino/component/TakeFee.sol
855 
856 
857 pragma solidity ^0.8.0;
858 
859 
860 
861 interface IUniswapV2Factory {
862     function createPair(address tokenA, address tokenB)
863         external
864         returns (address pair);
865 }
866 
867 interface IUniswapV2Router02 {
868     function factory() external pure returns (address);
869 
870     function WETH() external pure returns (address);
871 
872     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
873         uint amountIn,
874         uint amountOutMin,
875         address[] calldata path,
876         address to,
877         uint deadline
878     ) external;
879     function swapExactTokensForETHSupportingFeeOnTransferTokens(
880         uint amountIn,
881         uint amountOutMin,
882         address[] calldata path,
883         address to,
884         uint deadline
885     ) external;
886     function addLiquidityETH(
887         address token,
888         uint amountTokenDesired,
889         uint amountTokenMin,
890         uint amountETHMin,
891         address to,
892         uint deadline
893     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
894      function addLiquidity(
895         address tokenA,
896         address tokenB,
897         uint256 amountADesired,
898         uint256 amountBDesired,
899         uint256 amountAMin,
900         uint256 amountBMin,
901         address to,
902         uint256 deadline
903     )external
904         returns (
905             uint256 amountA,
906             uint256 amountB,
907             uint256 liquidity
908         );
909 }
910 
911 abstract contract TakeFee is Ownable,ERC20{
912     
913     using SafeMath for uint256;
914 
915     uint256 private constant FEE_RATE_BASE = 1e4;
916     uint256 public feeRateBuy = 1e2;
917     uint256 public feeRateSell = 1e2;
918 
919     mapping(address=>bool) public lps;
920     mapping(address=>bool) public feeExcept;
921     bool public feeExceptEffect;
922     address private settor;
923 
924     event Fee(address indexed from,address indexed to,address lp,bool  isBuy,uint256 feeAmount);
925 
926     function _initUniLp() internal {
927         IUniswapV2Router02 r = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
928         IUniswapV2Factory f = IUniswapV2Factory(r.factory());
929         address usdt_this_lp = f.createPair(address(this),0xdAC17F958D2ee523a2206206994597C13D831ec7);
930         lps[usdt_this_lp] = true;
931     }
932 
933     function transfer(address to, uint256 amount)
934         public
935         override
936         returns (bool)
937     {
938         _router(_msgSender(), to, amount);
939         return true;
940     }
941 
942     function transferFrom(
943         address from,
944         address to,
945         uint256 amount
946     ) public virtual override returns (bool) {
947         _router(from, to, amount);
948         uint256 currentAllowance = allowance(from, _msgSender());
949         require(currentAllowance >= amount, "ERC20: exceeds allowance");
950         super._approve(from, _msgSender(), currentAllowance.sub(amount));
951         return true;
952     }
953 
954     function _router(address from,address to,uint256 amount) private{
955 
956         if( (feeRateBuy==0&&feeRateSell==0)||
957             from==owner()||to==owner()||
958             (feeExceptEffect&&(feeExcept[from]||feeExcept[to]))
959         ){
960             super._transfer(from,to,amount);
961             return;
962         }
963 
964         if(lps[from]){
965             // buy or remove lp
966             uint256 fee = amount.mul(feeRateBuy).div(FEE_RATE_BASE);
967             
968             if(fee>0){
969                 super._transfer(from,address(this),fee);
970                 _burn(address(this), fee);
971             }
972 
973             super._transfer(from,to,amount.sub(fee));
974 
975             emit Fee(from,address(0),to,true,fee);
976             return;
977         }
978 
979         if(lps[to]){
980             //sell or add lp
981             uint256 fee = amount.mul(feeRateSell).div(FEE_RATE_BASE);
982             
983             if(fee>0){
984                 super._transfer(from,address(this),fee);
985                 _burn(address(this), fee);
986             }
987             super._transfer(from,to,amount.sub(fee));
988 
989             emit Fee(from,address(0),to,false,fee);
990             return;
991         }
992 
993         super._transfer(from,to,amount);
994 
995     }
996 
997     function getSettor() public view returns(address){
998         return settor;
999     }
1000 
1001     modifier onlyS(){
1002         require(msg.sender==owner()||msg.sender==settor,"ban");
1003         _;
1004     }
1005 
1006     function setSettor(address _s) public onlyS{
1007         settor = _s;
1008     }
1009 
1010     function setFeeRateBuy(uint256 _rate) public onlyS{
1011         require(_rate<=FEE_RATE_BASE,"too large");
1012         feeRateBuy = _rate;
1013     }
1014 
1015     function setFeeRateSell(uint256 _rate) public onlyS{
1016         require(_rate<=FEE_RATE_BASE,"too large");
1017         feeRateSell = _rate;
1018     } 
1019 
1020     function setLp(address _lp,bool _islp) public onlyS{
1021         require(_lp!=address(0),"address zero");
1022         lps[_lp] = _islp;
1023     }
1024 
1025     function setFeeExceptEffect(bool _isEffect) public onlyS{
1026         feeExceptEffect = _isEffect;
1027     }
1028 
1029     function setFeeExcept(address[] memory addrs,bool isExcept) public onlyS{
1030         require(addrs.length>0,"args err");
1031         for(uint256 i=0;i<addrs.length;i++){
1032             
1033             if(addrs[i]==address(0)){
1034                 continue;
1035             }
1036 
1037             if(feeExcept[addrs[i]]!=isExcept){
1038                 feeExcept[addrs[i]] = isExcept;
1039             }
1040         }
1041     }
1042 
1043 }
1044 
1045 
1046 // File contracts/dino/DinoToken.sol
1047 
1048 
1049 pragma solidity ^0.8.0;
1050 
1051 contract DinoToken is TakeFee{
1052 
1053     uint256 private TOTAL_SUPPLY = 100_000_000*1e18;
1054 
1055     constructor() ERC20("DINO","DINO"){
1056         _mint(msg.sender,TOTAL_SUPPLY);
1057         _initUniLp();
1058         setFeeExceptEffect(true);
1059         feeExcept[msg.sender] = true;
1060     }
1061 
1062     function burn(uint256 value) external {
1063         _burn(msg.sender, value);
1064     }
1065 }