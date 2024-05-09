1 /**
2  *Submitted for verification at BscScan.com on 2022-10-21
3 */
4 
5 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 // pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 // Dependency file: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
91 
92 
93 // pragma solidity ^0.8.0;
94 
95 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 
120 // Dependency file: @openzeppelin/contracts/utils/Context.sol
121 
122 
123 // pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 
146 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
147 
148 
149 // pragma solidity ^0.8.0;
150 
151 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
152 // import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
153 // import "@openzeppelin/contracts/utils/Context.sol";
154 
155 /**
156  * @dev Implementation of the {IERC20} interface.
157  *
158  * This implementation is agnostic to the way tokens are created. This means
159  * that a supply mechanism has to be added in a derived contract using {_mint}.
160  * For a generic mechanism see {ERC20PresetMinterPauser}.
161  *
162  * TIP: For a detailed writeup see our guide
163  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
164  * to implement supply mechanisms].
165  *
166  * We have followed general OpenZeppelin Contracts guidelines: functions revert
167  * instead returning `false` on failure. This behavior is nonetheless
168  * conventional and does not conflict with the expectations of ERC20
169  * applications.
170  *
171  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
172  * This allows applications to reconstruct the allowance for all accounts just
173  * by listening to said events. Other implementations of the EIP may not emit
174  * these events, as it isn't required by the specification.
175  *
176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
177  * functions have been added to mitigate the well-known issues around setting
178  * allowances. See {IERC20-approve}.
179  */
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     mapping(address => uint256) private _balances;
182 
183     mapping(address => mapping(address => uint256)) private _allowances;
184 
185     uint256 private _totalSupply;
186 
187     string private _name;
188     string private _symbol;
189 
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * The default value of {decimals} is 18. To select a different value for
194      * {decimals} you should overload it.
195      *
196      * All two of these values are immutable: they can only be set once during
197      * construction.
198      */
199     constructor(string memory name_, string memory symbol_) {
200         _name = name_;
201         _symbol = symbol_;
202     }
203 
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() public view virtual override returns (string memory) {
208         return _name;
209     }
210 
211     /**
212      * @dev Returns the symbol of the token, usually a shorter version of the
213      * name.
214      */
215     function symbol() public view virtual override returns (string memory) {
216         return _symbol;
217     }
218 
219     /**
220      * @dev Returns the number of decimals used to get its user representation.
221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
222      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
223      *
224      * Tokens usually opt for a value of 18, imitating the relationship between
225      * Ether and Wei. This is the value {ERC20} uses, unless this function is
226      * overridden;
227      *
228      * NOTE: This information is only used for _display_ purposes: it in
229      * no way affects any of the arithmetic of the contract, including
230      * {IERC20-balanceOf} and {IERC20-transfer}.
231      */
232     function decimals() public view virtual override returns (uint8) {
233         return 18;
234     }
235 
236     /**
237      * @dev See {IERC20-totalSupply}.
238      */
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev See {IERC20-balanceOf}.
245      */
246     function balanceOf(address account) public view virtual override returns (uint256) {
247         return _balances[account];
248     }
249 
250     /**
251      * @dev See {IERC20-transfer}.
252      *
253      * Requirements:
254      *
255      * - `recipient` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281 
282     /**
283      * @dev See {IERC20-transferFrom}.
284      *
285      * Emits an {Approval} event indicating the updated allowance. This is not
286      * required by the EIP. See the note at the beginning of {ERC20}.
287      *
288      * Requirements:
289      *
290      * - `sender` and `recipient` cannot be the zero address.
291      * - `sender` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``sender``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         _transfer(sender, recipient, amount);
301 
302         uint256 currentAllowance = _allowances[sender][_msgSender()];
303         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
304         unchecked {
305             _approve(sender, _msgSender(), currentAllowance - amount);
306         }
307 
308         return true;
309     }
310 
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         uint256 currentAllowance = _allowances[_msgSender()][spender];
344         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
345         unchecked {
346             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
347         }
348 
349         return true;
350     }
351 
352     /**
353      * @dev Moves `amount` of tokens from `sender` to `recipient`.
354      *
355      * This internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `sender` cannot be the zero address.
363      * - `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      */
366     function _transfer(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373 
374         _beforeTokenTransfer(sender, recipient, amount);
375 
376         uint256 senderBalance = _balances[sender];
377         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
378         unchecked {
379             _balances[sender] = senderBalance - amount;
380         }
381         _balances[recipient] += amount;
382 
383         emit Transfer(sender, recipient, amount);
384 
385         _afterTokenTransfer(sender, recipient, amount);
386     }
387 
388     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
389      * the total supply.
390      *
391      * Emits a {Transfer} event with `from` set to the zero address.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      */
397     function _mint(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: mint to the zero address");
399 
400         _beforeTokenTransfer(address(0), account, amount);
401 
402         _totalSupply += amount;
403         _balances[account] += amount;
404         emit Transfer(address(0), account, amount);
405 
406         _afterTokenTransfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _beforeTokenTransfer(account, address(0), amount);
424 
425         uint256 accountBalance = _balances[account];
426         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
427         unchecked {
428             _balances[account] = accountBalance - amount;
429         }
430         _totalSupply -= amount;
431 
432         emit Transfer(account, address(0), amount);
433 
434         _afterTokenTransfer(account, address(0), amount);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(
451         address owner,
452         address spender,
453         uint256 amount
454     ) internal virtual {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 
462     /**
463      * @dev Hook that is called before any transfer of tokens. This includes
464      * minting and burning.
465      *
466      * Calling conditions:
467      *
468      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
469      * will be transferred to `to`.
470      * - when `from` is zero, `amount` tokens will be minted for `to`.
471      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
472      * - `from` and `to` are never both zero.
473      *
474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
475      */
476     function _beforeTokenTransfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal virtual {}
481 
482     /**
483      * @dev Hook that is called after any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * has been transferred to `to`.
490      * - when `from` is zero, `amount` tokens have been minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _afterTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 }
502 
503 
504 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
505 
506 
507 // pragma solidity ^0.8.0;
508 
509 // import "@openzeppelin/contracts/utils/Context.sol";
510 
511 /**
512  * @dev Contract module which provides a basic access control mechanism, where
513  * there is an account (an owner) that can be granted exclusive access to
514  * specific functions.
515  *
516  * By default, the owner account will be the one that deploys the contract. This
517  * can later be changed with {transferOwnership}.
518  *
519  * This module is used through inheritance. It will make available the modifier
520  * `onlyOwner`, which can be applied to your functions to restrict their use to
521  * the owner.
522  */
523 abstract contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor() {
532         _setOwner(_msgSender());
533     }
534 
535     /**
536      * @dev Returns the address of the current owner.
537      */
538     function owner() public view virtual returns (address) {
539         return _owner;
540     }
541 
542     /**
543      * @dev Throws if called by any account other than the owner.
544      */
545     modifier onlyOwner() {
546         require(owner() == _msgSender(), "Ownable: caller is not the owner");
547         _;
548     }
549 
550     /**
551      * @dev Leaves the contract without owner. It will not be possible to call
552      * `onlyOwner` functions anymore. Can only be called by the current owner.
553      *
554      * NOTE: Renouncing ownership will leave the contract without an owner,
555      * thereby removing any functionality that is only available to the owner.
556      */
557     function renounceOwnership() public virtual onlyOwner {
558         _setOwner(address(0));
559     }
560 
561     /**
562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
563      * Can only be called by the current owner.
564      */
565     function transferOwnership(address newOwner) public virtual onlyOwner {
566         require(newOwner != address(0), "Ownable: new owner is the zero address");
567         _setOwner(newOwner);
568     }
569 
570     function _setOwner(address newOwner) private {
571         address oldOwner = _owner;
572         _owner = newOwner;
573         emit OwnershipTransferred(oldOwner, newOwner);
574     }
575 }
576 
577 
578 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
579 
580 
581 // pragma solidity ^0.8.0;
582 
583 // CAUTION
584 // This version of SafeMath should only be used with Solidity 0.8 or later,
585 // because it relies on the compiler's built in overflow checks.
586 
587 /**
588  * @dev Wrappers over Solidity's arithmetic operations.
589  *
590  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
591  * now has built in overflow checking.
592  */
593 library SafeMath {
594     /**
595      * @dev Returns the addition of two unsigned integers, with an overflow flag.
596      *
597      * _Available since v3.4._
598      */
599     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             uint256 c = a + b;
602             if (c < a) return (false, 0);
603             return (true, c);
604         }
605     }
606 
607     /**
608      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
609      *
610      * _Available since v3.4._
611      */
612     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
613         unchecked {
614             if (b > a) return (false, 0);
615             return (true, a - b);
616         }
617     }
618 
619     /**
620      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
621      *
622      * _Available since v3.4._
623      */
624     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         unchecked {
626             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
627             // benefit is lost if 'b' is also tested.
628             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
629             if (a == 0) return (true, 0);
630             uint256 c = a * b;
631             if (c / a != b) return (false, 0);
632             return (true, c);
633         }
634     }
635 
636     /**
637      * @dev Returns the division of two unsigned integers, with a division by zero flag.
638      *
639      * _Available since v3.4._
640      */
641     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
642         unchecked {
643             if (b == 0) return (false, 0);
644             return (true, a / b);
645         }
646     }
647 
648     /**
649      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
650      *
651      * _Available since v3.4._
652      */
653     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
654         unchecked {
655             if (b == 0) return (false, 0);
656             return (true, a % b);
657         }
658     }
659 
660     /**
661      * @dev Returns the addition of two unsigned integers, reverting on
662      * overflow.
663      *
664      * Counterpart to Solidity's `+` operator.
665      *
666      * Requirements:
667      *
668      * - Addition cannot overflow.
669      */
670     function add(uint256 a, uint256 b) internal pure returns (uint256) {
671         return a + b;
672     }
673 
674     /**
675      * @dev Returns the subtraction of two unsigned integers, reverting on
676      * overflow (when the result is negative).
677      *
678      * Counterpart to Solidity's `-` operator.
679      *
680      * Requirements:
681      *
682      * - Subtraction cannot overflow.
683      */
684     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a - b;
686     }
687 
688     /**
689      * @dev Returns the multiplication of two unsigned integers, reverting on
690      * overflow.
691      *
692      * Counterpart to Solidity's `*` operator.
693      *
694      * Requirements:
695      *
696      * - Multiplication cannot overflow.
697      */
698     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
699         return a * b;
700     }
701 
702     /**
703      * @dev Returns the integer division of two unsigned integers, reverting on
704      * division by zero. The result is rounded towards zero.
705      *
706      * Counterpart to Solidity's `/` operator.
707      *
708      * Requirements:
709      *
710      * - The divisor cannot be zero.
711      */
712     function div(uint256 a, uint256 b) internal pure returns (uint256) {
713         return a / b;
714     }
715 
716     /**
717      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
718      * reverting when dividing by zero.
719      *
720      * Counterpart to Solidity's `%` operator. This function uses a `revert`
721      * opcode (which leaves remaining gas untouched) while Solidity uses an
722      * invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
729         return a % b;
730     }
731 
732     /**
733      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
734      * overflow (when the result is negative).
735      *
736      * CAUTION: This function is deprecated because it requires allocating memory for the error
737      * message unnecessarily. For custom revert reasons use {trySub}.
738      *
739      * Counterpart to Solidity's `-` operator.
740      *
741      * Requirements:
742      *
743      * - Subtraction cannot overflow.
744      */
745     function sub(
746         uint256 a,
747         uint256 b,
748         string memory errorMessage
749     ) internal pure returns (uint256) {
750         unchecked {
751             require(b <= a, errorMessage);
752             return a - b;
753         }
754     }
755 
756     /**
757      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
758      * division by zero. The result is rounded towards zero.
759      *
760      * Counterpart to Solidity's `/` operator. Note: this function uses a
761      * `revert` opcode (which leaves remaining gas untouched) while Solidity
762      * uses an invalid opcode to revert (consuming all remaining gas).
763      *
764      * Requirements:
765      *
766      * - The divisor cannot be zero.
767      */
768     function div(
769         uint256 a,
770         uint256 b,
771         string memory errorMessage
772     ) internal pure returns (uint256) {
773         unchecked {
774             require(b > 0, errorMessage);
775             return a / b;
776         }
777     }
778 
779     /**
780      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
781      * reverting with custom message when dividing by zero.
782      *
783      * CAUTION: This function is deprecated because it requires allocating memory for the error
784      * message unnecessarily. For custom revert reasons use {tryMod}.
785      *
786      * Counterpart to Solidity's `%` operator. This function uses a `revert`
787      * opcode (which leaves remaining gas untouched) while Solidity uses an
788      * invalid opcode to revert (consuming all remaining gas).
789      *
790      * Requirements:
791      *
792      * - The divisor cannot be zero.
793      */
794     function mod(
795         uint256 a,
796         uint256 b,
797         string memory errorMessage
798     ) internal pure returns (uint256) {
799         unchecked {
800             require(b > 0, errorMessage);
801             return a % b;
802         }
803     }
804 }
805 
806 
807 // Dependency file: @openzeppelin/contracts/proxy/Clones.sol
808 
809 
810 // pragma solidity ^0.8.0;
811 
812 /**
813  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
814  * deploying minimal proxy contracts, also known as "clones".
815  *
816  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
817  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
818  *
819  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
820  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
821  * deterministic method.
822  *
823  * _Available since v3.4._
824  */
825 library Clones {
826     /**
827      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
828      *
829      * This function uses the create opcode, which should never revert.
830      */
831     function clone(address implementation) internal returns (address instance) {
832         assembly {
833             let ptr := mload(0x40)
834             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
835             mstore(add(ptr, 0x14), shl(0x60, implementation))
836             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
837             instance := create(0, ptr, 0x37)
838         }
839         require(instance != address(0), "ERC1167: create failed");
840     }
841 
842     /**
843      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
844      *
845      * This function uses the create2 opcode and a `salt` to deterministically deploy
846      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
847      * the clones cannot be deployed twice at the same address.
848      */
849     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
850         assembly {
851             let ptr := mload(0x40)
852             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
853             mstore(add(ptr, 0x14), shl(0x60, implementation))
854             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
855             instance := create2(0, ptr, 0x37, salt)
856         }
857         require(instance != address(0), "ERC1167: create2 failed");
858     }
859 
860     /**
861      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
862      */
863     function predictDeterministicAddress(
864         address implementation,
865         bytes32 salt,
866         address deployer
867     ) internal pure returns (address predicted) {
868         assembly {
869             let ptr := mload(0x40)
870             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
871             mstore(add(ptr, 0x14), shl(0x60, implementation))
872             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
873             mstore(add(ptr, 0x38), shl(0x60, deployer))
874             mstore(add(ptr, 0x4c), salt)
875             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
876             predicted := keccak256(add(ptr, 0x37), 0x55)
877         }
878     }
879 
880     /**
881      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
882      */
883     function predictDeterministicAddress(address implementation, bytes32 salt)
884         internal
885         view
886         returns (address predicted)
887     {
888         return predictDeterministicAddress(implementation, salt, address(this));
889     }
890 }
891 
892 
893 // Dependency file: @openzeppelin/contracts/utils/Address.sol
894 
895 
896 // pragma solidity ^0.8.0;
897 
898 /**
899  * @dev Collection of functions related to the address type
900  */
901 library Address {
902     /**
903      * @dev Returns true if `account` is a contract.
904      *
905      * [IMPORTANT]
906      * ====
907      * It is unsafe to assume that an address for which this function returns
908      * false is an externally-owned account (EOA) and not a contract.
909      *
910      * Among others, `isContract` will return false for the following
911      * types of addresses:
912      *
913      *  - an externally-owned account
914      *  - a contract in construction
915      *  - an address where a contract will be created
916      *  - an address where a contract lived, but was destroyed
917      * ====
918      */
919     function isContract(address account) internal view returns (bool) {
920         // This method relies on extcodesize, which returns 0 for contracts in
921         // construction, since the code is only stored at the end of the
922         // constructor execution.
923 
924         uint256 size;
925         assembly {
926             size := extcodesize(account)
927         }
928         return size > 0;
929     }
930 
931     /**
932      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
933      * `recipient`, forwarding all available gas and reverting on errors.
934      *
935      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
936      * of certain opcodes, possibly making contracts go over the 2300 gas limit
937      * imposed by `transfer`, making them unable to receive funds via
938      * `transfer`. {sendValue} removes this limitation.
939      *
940      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
941      *
942      * IMPORTANT: because control is transferred to `recipient`, care must be
943      * taken to not create reentrancy vulnerabilities. Consider using
944      * {ReentrancyGuard} or the
945      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
946      */
947     function sendValue(address payable recipient, uint256 amount) internal {
948         require(address(this).balance >= amount, "Address: insufficient balance");
949 
950         (bool success, ) = recipient.call{value: amount}("");
951         require(success, "Address: unable to send value, recipient may have reverted");
952     }
953 
954     /**
955      * @dev Performs a Solidity function call using a low level `call`. A
956      * plain `call` is an unsafe replacement for a function call: use this
957      * function instead.
958      *
959      * If `target` reverts with a revert reason, it is bubbled up by this
960      * function (like regular Solidity function calls).
961      *
962      * Returns the raw returned data. To convert to the expected return value,
963      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
964      *
965      * Requirements:
966      *
967      * - `target` must be a contract.
968      * - calling `target` with `data` must not revert.
969      *
970      * _Available since v3.1._
971      */
972     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
973         return functionCall(target, data, "Address: low-level call failed");
974     }
975 
976     /**
977      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
978      * `errorMessage` as a fallback revert reason when `target` reverts.
979      *
980      * _Available since v3.1._
981      */
982     function functionCall(
983         address target,
984         bytes memory data,
985         string memory errorMessage
986     ) internal returns (bytes memory) {
987         return functionCallWithValue(target, data, 0, errorMessage);
988     }
989 
990     /**
991      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
992      * but also transferring `value` wei to `target`.
993      *
994      * Requirements:
995      *
996      * - the calling contract must have an ETH balance of at least `value`.
997      * - the called Solidity function must be `payable`.
998      *
999      * _Available since v3.1._
1000      */
1001     function functionCallWithValue(
1002         address target,
1003         bytes memory data,
1004         uint256 value
1005     ) internal returns (bytes memory) {
1006         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1007     }
1008 
1009     /**
1010      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1011      * with `errorMessage` as a fallback revert reason when `target` reverts.
1012      *
1013      * _Available since v3.1._
1014      */
1015     function functionCallWithValue(
1016         address target,
1017         bytes memory data,
1018         uint256 value,
1019         string memory errorMessage
1020     ) internal returns (bytes memory) {
1021         require(address(this).balance >= value, "Address: insufficient balance for call");
1022         require(isContract(target), "Address: call to non-contract");
1023 
1024         (bool success, bytes memory returndata) = target.call{value: value}(data);
1025         return verifyCallResult(success, returndata, errorMessage);
1026     }
1027 
1028     /**
1029      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1030      * but performing a static call.
1031      *
1032      * _Available since v3.3._
1033      */
1034     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1035         return functionStaticCall(target, data, "Address: low-level static call failed");
1036     }
1037 
1038     /**
1039      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1040      * but performing a static call.
1041      *
1042      * _Available since v3.3._
1043      */
1044     function functionStaticCall(
1045         address target,
1046         bytes memory data,
1047         string memory errorMessage
1048     ) internal view returns (bytes memory) {
1049         require(isContract(target), "Address: static call to non-contract");
1050 
1051         (bool success, bytes memory returndata) = target.staticcall(data);
1052         return verifyCallResult(success, returndata, errorMessage);
1053     }
1054 
1055     /**
1056      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1057      * but performing a delegate call.
1058      *
1059      * _Available since v3.4._
1060      */
1061     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1062         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1063     }
1064 
1065     /**
1066      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1067      * but performing a delegate call.
1068      *
1069      * _Available since v3.4._
1070      */
1071     function functionDelegateCall(
1072         address target,
1073         bytes memory data,
1074         string memory errorMessage
1075     ) internal returns (bytes memory) {
1076         require(isContract(target), "Address: delegate call to non-contract");
1077 
1078         (bool success, bytes memory returndata) = target.delegatecall(data);
1079         return verifyCallResult(success, returndata, errorMessage);
1080     }
1081 
1082     /**
1083      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1084      * revert reason using the provided one.
1085      *
1086      * _Available since v4.3._
1087      */
1088     function verifyCallResult(
1089         bool success,
1090         bytes memory returndata,
1091         string memory errorMessage
1092     ) internal pure returns (bytes memory) {
1093         if (success) {
1094             return returndata;
1095         } else {
1096             // Look for revert reason and bubble it up if present
1097             if (returndata.length > 0) {
1098                 // The easiest way to bubble the revert reason is using memory via assembly
1099 
1100                 assembly {
1101                     let returndata_size := mload(returndata)
1102                     revert(add(32, returndata), returndata_size)
1103                 }
1104             } else {
1105                 revert(errorMessage);
1106             }
1107         }
1108     }
1109 }
1110 
1111 
1112 // Dependency file: contracts/interfaces/IUniswapV2Factory.sol
1113 
1114 // pragma solidity >=0.5.0;
1115 
1116 interface IUniswapV2Factory {
1117     event PairCreated(
1118         address indexed token0,
1119         address indexed token1,
1120         address pair,
1121         uint256
1122     );
1123 
1124     function feeTo() external view returns (address);
1125 
1126     function feeToSetter() external view returns (address);
1127 
1128     function getPair(address tokenA, address tokenB)
1129         external
1130         view
1131         returns (address pair);
1132 
1133     function allPairs(uint256) external view returns (address pair);
1134 
1135     function allPairsLength() external view returns (uint256);
1136 
1137     function createPair(address tokenA, address tokenB)
1138         external
1139         returns (address pair);
1140 
1141     function setFeeTo(address) external;
1142 
1143     function setFeeToSetter(address) external;
1144 }
1145 
1146 
1147 // Dependency file: contracts/interfaces/IUniswapV2Router02.sol
1148 
1149 // pragma solidity >=0.6.2;
1150 
1151 interface IUniswapV2Router01 {
1152     function factory() external pure returns (address);
1153 
1154     function WETH() external pure returns (address);
1155 
1156     function addLiquidity(
1157         address tokenA,
1158         address tokenB,
1159         uint256 amountADesired,
1160         uint256 amountBDesired,
1161         uint256 amountAMin,
1162         uint256 amountBMin,
1163         address to,
1164         uint256 deadline
1165     )
1166         external
1167         returns (
1168             uint256 amountA,
1169             uint256 amountB,
1170             uint256 liquidity
1171         );
1172 
1173     function addLiquidityETH(
1174         address token,
1175         uint256 amountTokenDesired,
1176         uint256 amountTokenMin,
1177         uint256 amountETHMin,
1178         address to,
1179         uint256 deadline
1180     )
1181         external
1182         payable
1183         returns (
1184             uint256 amountToken,
1185             uint256 amountETH,
1186             uint256 liquidity
1187         );
1188 
1189     function removeLiquidity(
1190         address tokenA,
1191         address tokenB,
1192         uint256 liquidity,
1193         uint256 amountAMin,
1194         uint256 amountBMin,
1195         address to,
1196         uint256 deadline
1197     ) external returns (uint256 amountA, uint256 amountB);
1198 
1199     function removeLiquidityETH(
1200         address token,
1201         uint256 liquidity,
1202         uint256 amountTokenMin,
1203         uint256 amountETHMin,
1204         address to,
1205         uint256 deadline
1206     ) external returns (uint256 amountToken, uint256 amountETH);
1207 
1208     function removeLiquidityWithPermit(
1209         address tokenA,
1210         address tokenB,
1211         uint256 liquidity,
1212         uint256 amountAMin,
1213         uint256 amountBMin,
1214         address to,
1215         uint256 deadline,
1216         bool approveMax,
1217         uint8 v,
1218         bytes32 r,
1219         bytes32 s
1220     ) external returns (uint256 amountA, uint256 amountB);
1221 
1222     function removeLiquidityETHWithPermit(
1223         address token,
1224         uint256 liquidity,
1225         uint256 amountTokenMin,
1226         uint256 amountETHMin,
1227         address to,
1228         uint256 deadline,
1229         bool approveMax,
1230         uint8 v,
1231         bytes32 r,
1232         bytes32 s
1233     ) external returns (uint256 amountToken, uint256 amountETH);
1234 
1235     function swapExactTokensForTokens(
1236         uint256 amountIn,
1237         uint256 amountOutMin,
1238         address[] calldata path,
1239         address to,
1240         uint256 deadline
1241     ) external returns (uint256[] memory amounts);
1242 
1243     function swapTokensForExactTokens(
1244         uint256 amountOut,
1245         uint256 amountInMax,
1246         address[] calldata path,
1247         address to,
1248         uint256 deadline
1249     ) external returns (uint256[] memory amounts);
1250 
1251     function swapExactETHForTokens(
1252         uint256 amountOutMin,
1253         address[] calldata path,
1254         address to,
1255         uint256 deadline
1256     ) external payable returns (uint256[] memory amounts);
1257 
1258     function swapTokensForExactETH(
1259         uint256 amountOut,
1260         uint256 amountInMax,
1261         address[] calldata path,
1262         address to,
1263         uint256 deadline
1264     ) external returns (uint256[] memory amounts);
1265 
1266     function swapExactTokensForETH(
1267         uint256 amountIn,
1268         uint256 amountOutMin,
1269         address[] calldata path,
1270         address to,
1271         uint256 deadline
1272     ) external returns (uint256[] memory amounts);
1273 
1274     function swapETHForExactTokens(
1275         uint256 amountOut,
1276         address[] calldata path,
1277         address to,
1278         uint256 deadline
1279     ) external payable returns (uint256[] memory amounts);
1280 
1281     function quote(
1282         uint256 amountA,
1283         uint256 reserveA,
1284         uint256 reserveB
1285     ) external pure returns (uint256 amountB);
1286 
1287     function getAmountOut(
1288         uint256 amountIn,
1289         uint256 reserveIn,
1290         uint256 reserveOut
1291     ) external pure returns (uint256 amountOut);
1292 
1293     function getAmountIn(
1294         uint256 amountOut,
1295         uint256 reserveIn,
1296         uint256 reserveOut
1297     ) external pure returns (uint256 amountIn);
1298 
1299     function getAmountsOut(uint256 amountIn, address[] calldata path)
1300         external
1301         view
1302         returns (uint256[] memory amounts);
1303 
1304     function getAmountsIn(uint256 amountOut, address[] calldata path)
1305         external
1306         view
1307         returns (uint256[] memory amounts);
1308 }
1309 
1310 interface IUniswapV2Router02 is IUniswapV2Router01 {
1311     function removeLiquidityETHSupportingFeeOnTransferTokens(
1312         address token,
1313         uint256 liquidity,
1314         uint256 amountTokenMin,
1315         uint256 amountETHMin,
1316         address to,
1317         uint256 deadline
1318     ) external returns (uint256 amountETH);
1319 
1320     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1321         address token,
1322         uint256 liquidity,
1323         uint256 amountTokenMin,
1324         uint256 amountETHMin,
1325         address to,
1326         uint256 deadline,
1327         bool approveMax,
1328         uint8 v,
1329         bytes32 r,
1330         bytes32 s
1331     ) external returns (uint256 amountETH);
1332 
1333     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1334         uint256 amountIn,
1335         uint256 amountOutMin,
1336         address[] calldata path,
1337         address to,
1338         uint256 deadline
1339     ) external;
1340 
1341     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1342         uint256 amountOutMin,
1343         address[] calldata path,
1344         address to,
1345         uint256 deadline
1346     ) external payable;
1347 
1348     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1349         uint256 amountIn,
1350         uint256 amountOutMin,
1351         address[] calldata path,
1352         address to,
1353         uint256 deadline
1354     ) external;
1355 }
1356 
1357 
1358 // Dependency file: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
1359 
1360 
1361 // pragma solidity ^0.8.0;
1362 
1363 /**
1364  * @dev Interface of the ERC20 standard as defined in the EIP.
1365  */
1366 interface IERC20Upgradeable {
1367     /**
1368      * @dev Returns the amount of tokens in existence.
1369      */
1370     function totalSupply() external view returns (uint256);
1371 
1372     /**
1373      * @dev Returns the amount of tokens owned by `account`.
1374      */
1375     function balanceOf(address account) external view returns (uint256);
1376 
1377     /**
1378      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1379      *
1380      * Returns a boolean value indicating whether the operation succeeded.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function transfer(address recipient, uint256 amount) external returns (bool);
1385 
1386     /**
1387      * @dev Returns the remaining number of tokens that `spender` will be
1388      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1389      * zero by default.
1390      *
1391      * This value changes when {approve} or {transferFrom} are called.
1392      */
1393     function allowance(address owner, address spender) external view returns (uint256);
1394 
1395     /**
1396      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1397      *
1398      * Returns a boolean value indicating whether the operation succeeded.
1399      *
1400      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1401      * that someone may use both the old and the new allowance by unfortunate
1402      * transaction ordering. One possible solution to mitigate this race
1403      * condition is to first reduce the spender's allowance to 0 and set the
1404      * desired value afterwards:
1405      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1406      *
1407      * Emits an {Approval} event.
1408      */
1409     function approve(address spender, uint256 amount) external returns (bool);
1410 
1411     /**
1412      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1413      * allowance mechanism. `amount` is then deducted from the caller's
1414      * allowance.
1415      *
1416      * Returns a boolean value indicating whether the operation succeeded.
1417      *
1418      * Emits a {Transfer} event.
1419      */
1420     function transferFrom(
1421         address sender,
1422         address recipient,
1423         uint256 amount
1424     ) external returns (bool);
1425 
1426     /**
1427      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1428      * another (`to`).
1429      *
1430      * Note that `value` may be zero.
1431      */
1432     event Transfer(address indexed from, address indexed to, uint256 value);
1433 
1434     /**
1435      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1436      * a call to {approve}. `value` is the new allowance.
1437      */
1438     event Approval(address indexed owner, address indexed spender, uint256 value);
1439 }
1440 
1441 
1442 // Dependency file: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol
1443 
1444 
1445 // pragma solidity ^0.8.0;
1446 
1447 // import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
1448 
1449 /**
1450  * @dev Interface for the optional metadata functions from the ERC20 standard.
1451  *
1452  * _Available since v4.1._
1453  */
1454 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
1455     /**
1456      * @dev Returns the name of the token.
1457      */
1458     function name() external view returns (string memory);
1459 
1460     /**
1461      * @dev Returns the symbol of the token.
1462      */
1463     function symbol() external view returns (string memory);
1464 
1465     /**
1466      * @dev Returns the decimals places of the token.
1467      */
1468     function decimals() external view returns (uint8);
1469 }
1470 
1471 
1472 // Dependency file: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
1473 
1474 
1475 // pragma solidity ^0.8.0;
1476 
1477 /**
1478  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1479  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
1480  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1481  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1482  *
1483  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1484  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1485  *
1486  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1487  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1488  */
1489 abstract contract Initializable {
1490     /**
1491      * @dev Indicates that the contract has been initialized.
1492      */
1493     bool private _initialized;
1494 
1495     /**
1496      * @dev Indicates that the contract is in the process of being initialized.
1497      */
1498     bool private _initializing;
1499 
1500     /**
1501      * @dev Modifier to protect an initializer function from being invoked twice.
1502      */
1503     modifier initializer() {
1504         require(_initializing || !_initialized, "Initializable: contract is already initialized");
1505 
1506         bool isTopLevelCall = !_initializing;
1507         if (isTopLevelCall) {
1508             _initializing = true;
1509             _initialized = true;
1510         }
1511 
1512         _;
1513 
1514         if (isTopLevelCall) {
1515             _initializing = false;
1516         }
1517     }
1518 }
1519 
1520 
1521 // Dependency file: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
1522 
1523 
1524 // pragma solidity ^0.8.0;
1525 // import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
1526 
1527 /**
1528  * @dev Provides information about the current execution context, including the
1529  * sender of the transaction and its data. While these are generally available
1530  * via msg.sender and msg.data, they should not be accessed in such a direct
1531  * manner, since when dealing with meta-transactions the account sending and
1532  * paying for execution may not be the actual sender (as far as an application
1533  * is concerned).
1534  *
1535  * This contract is only required for intermediate, library-like contracts.
1536  */
1537 abstract contract ContextUpgradeable is Initializable {
1538     function __Context_init() internal initializer {
1539         __Context_init_unchained();
1540     }
1541 
1542     function __Context_init_unchained() internal initializer {
1543     }
1544     function _msgSender() internal view virtual returns (address) {
1545         return msg.sender;
1546     }
1547 
1548     function _msgData() internal view virtual returns (bytes calldata) {
1549         return msg.data;
1550     }
1551     uint256[50] private __gap;
1552 }
1553 
1554 
1555 // Dependency file: @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
1556 
1557 
1558 // pragma solidity ^0.8.0;
1559 
1560 // import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
1561 // import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
1562 // import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
1563 // import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
1564 
1565 /**
1566  * @dev Implementation of the {IERC20} interface.
1567  *
1568  * This implementation is agnostic to the way tokens are created. This means
1569  * that a supply mechanism has to be added in a derived contract using {_mint}.
1570  * For a generic mechanism see {ERC20PresetMinterPauser}.
1571  *
1572  * TIP: For a detailed writeup see our guide
1573  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1574  * to implement supply mechanisms].
1575  *
1576  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1577  * instead returning `false` on failure. This behavior is nonetheless
1578  * conventional and does not conflict with the expectations of ERC20
1579  * applications.
1580  *
1581  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1582  * This allows applications to reconstruct the allowance for all accounts just
1583  * by listening to said events. Other implementations of the EIP may not emit
1584  * these events, as it isn't required by the specification.
1585  *
1586  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1587  * functions have been added to mitigate the well-known issues around setting
1588  * allowances. See {IERC20-approve}.
1589  */
1590 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
1591     mapping(address => uint256) private _balances;
1592 
1593     mapping(address => mapping(address => uint256)) private _allowances;
1594 
1595     uint256 private _totalSupply;
1596 
1597     string private _name;
1598     string private _symbol;
1599 
1600     /**
1601      * @dev Sets the values for {name} and {symbol}.
1602      *
1603      * The default value of {decimals} is 18. To select a different value for
1604      * {decimals} you should overload it.
1605      *
1606      * All two of these values are immutable: they can only be set once during
1607      * construction.
1608      */
1609     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
1610         __Context_init_unchained();
1611         __ERC20_init_unchained(name_, symbol_);
1612     }
1613 
1614     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
1615         _name = name_;
1616         _symbol = symbol_;
1617     }
1618 
1619     /**
1620      * @dev Returns the name of the token.
1621      */
1622     function name() public view virtual override returns (string memory) {
1623         return _name;
1624     }
1625 
1626     /**
1627      * @dev Returns the symbol of the token, usually a shorter version of the
1628      * name.
1629      */
1630     function symbol() public view virtual override returns (string memory) {
1631         return _symbol;
1632     }
1633 
1634     /**
1635      * @dev Returns the number of decimals used to get its user representation.
1636      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1637      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1638      *
1639      * Tokens usually opt for a value of 18, imitating the relationship between
1640      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1641      * overridden;
1642      *
1643      * NOTE: This information is only used for _display_ purposes: it in
1644      * no way affects any of the arithmetic of the contract, including
1645      * {IERC20-balanceOf} and {IERC20-transfer}.
1646      */
1647     function decimals() public view virtual override returns (uint8) {
1648         return 18;
1649     }
1650 
1651     /**
1652      * @dev See {IERC20-totalSupply}.
1653      */
1654     function totalSupply() public view virtual override returns (uint256) {
1655         return _totalSupply;
1656     }
1657 
1658     /**
1659      * @dev See {IERC20-balanceOf}.
1660      */
1661     function balanceOf(address account) public view virtual override returns (uint256) {
1662         return _balances[account];
1663     }
1664 
1665     /**
1666      * @dev See {IERC20-transfer}.
1667      *
1668      * Requirements:
1669      *
1670      * - `recipient` cannot be the zero address.
1671      * - the caller must have a balance of at least `amount`.
1672      */
1673     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1674         _transfer(_msgSender(), recipient, amount);
1675         return true;
1676     }
1677 
1678     /**
1679      * @dev See {IERC20-allowance}.
1680      */
1681     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1682         return _allowances[owner][spender];
1683     }
1684 
1685     /**
1686      * @dev See {IERC20-approve}.
1687      *
1688      * Requirements:
1689      *
1690      * - `spender` cannot be the zero address.
1691      */
1692     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1693         _approve(_msgSender(), spender, amount);
1694         return true;
1695     }
1696 
1697     /**
1698      * @dev See {IERC20-transferFrom}.
1699      *
1700      * Emits an {Approval} event indicating the updated allowance. This is not
1701      * required by the EIP. See the note at the beginning of {ERC20}.
1702      *
1703      * Requirements:
1704      *
1705      * - `sender` and `recipient` cannot be the zero address.
1706      * - `sender` must have a balance of at least `amount`.
1707      * - the caller must have allowance for ``sender``'s tokens of at least
1708      * `amount`.
1709      */
1710     function transferFrom(
1711         address sender,
1712         address recipient,
1713         uint256 amount
1714     ) public virtual override returns (bool) {
1715         _transfer(sender, recipient, amount);
1716 
1717         uint256 currentAllowance = _allowances[sender][_msgSender()];
1718         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1719         unchecked {
1720             _approve(sender, _msgSender(), currentAllowance - amount);
1721         }
1722 
1723         return true;
1724     }
1725 
1726     /**
1727      * @dev Atomically increases the allowance granted to `spender` by the caller.
1728      *
1729      * This is an alternative to {approve} that can be used as a mitigation for
1730      * problems described in {IERC20-approve}.
1731      *
1732      * Emits an {Approval} event indicating the updated allowance.
1733      *
1734      * Requirements:
1735      *
1736      * - `spender` cannot be the zero address.
1737      */
1738     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1739         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1740         return true;
1741     }
1742 
1743     /**
1744      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1745      *
1746      * This is an alternative to {approve} that can be used as a mitigation for
1747      * problems described in {IERC20-approve}.
1748      *
1749      * Emits an {Approval} event indicating the updated allowance.
1750      *
1751      * Requirements:
1752      *
1753      * - `spender` cannot be the zero address.
1754      * - `spender` must have allowance for the caller of at least
1755      * `subtractedValue`.
1756      */
1757     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1758         uint256 currentAllowance = _allowances[_msgSender()][spender];
1759         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1760         unchecked {
1761             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1762         }
1763 
1764         return true;
1765     }
1766 
1767     /**
1768      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1769      *
1770      * This internal function is equivalent to {transfer}, and can be used to
1771      * e.g. implement automatic token fees, slashing mechanisms, etc.
1772      *
1773      * Emits a {Transfer} event.
1774      *
1775      * Requirements:
1776      *
1777      * - `sender` cannot be the zero address.
1778      * - `recipient` cannot be the zero address.
1779      * - `sender` must have a balance of at least `amount`.
1780      */
1781     function _transfer(
1782         address sender,
1783         address recipient,
1784         uint256 amount
1785     ) internal virtual {
1786         require(sender != address(0), "ERC20: transfer from the zero address");
1787         require(recipient != address(0), "ERC20: transfer to the zero address");
1788 
1789         _beforeTokenTransfer(sender, recipient, amount);
1790 
1791         uint256 senderBalance = _balances[sender];
1792         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1793         unchecked {
1794             _balances[sender] = senderBalance - amount;
1795         }
1796         _balances[recipient] += amount;
1797 
1798         emit Transfer(sender, recipient, amount);
1799 
1800         _afterTokenTransfer(sender, recipient, amount);
1801     }
1802 
1803     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1804      * the total supply.
1805      *
1806      * Emits a {Transfer} event with `from` set to the zero address.
1807      *
1808      * Requirements:
1809      *
1810      * - `account` cannot be the zero address.
1811      */
1812     function _mint(address account, uint256 amount) internal virtual {
1813         require(account != address(0), "ERC20: mint to the zero address");
1814 
1815         _beforeTokenTransfer(address(0), account, amount);
1816 
1817         _totalSupply += amount;
1818         _balances[account] += amount;
1819         emit Transfer(address(0), account, amount);
1820 
1821         _afterTokenTransfer(address(0), account, amount);
1822     }
1823 
1824     /**
1825      * @dev Destroys `amount` tokens from `account`, reducing the
1826      * total supply.
1827      *
1828      * Emits a {Transfer} event with `to` set to the zero address.
1829      *
1830      * Requirements:
1831      *
1832      * - `account` cannot be the zero address.
1833      * - `account` must have at least `amount` tokens.
1834      */
1835     function _burn(address account, uint256 amount) internal virtual {
1836         require(account != address(0), "ERC20: burn from the zero address");
1837 
1838         _beforeTokenTransfer(account, address(0), amount);
1839 
1840         uint256 accountBalance = _balances[account];
1841         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1842         unchecked {
1843             _balances[account] = accountBalance - amount;
1844         }
1845         _totalSupply -= amount;
1846 
1847         emit Transfer(account, address(0), amount);
1848 
1849         _afterTokenTransfer(account, address(0), amount);
1850     }
1851 
1852     /**
1853      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1854      *
1855      * This internal function is equivalent to `approve`, and can be used to
1856      * e.g. set automatic allowances for certain subsystems, etc.
1857      *
1858      * Emits an {Approval} event.
1859      *
1860      * Requirements:
1861      *
1862      * - `owner` cannot be the zero address.
1863      * - `spender` cannot be the zero address.
1864      */
1865     function _approve(
1866         address owner,
1867         address spender,
1868         uint256 amount
1869     ) internal virtual {
1870         require(owner != address(0), "ERC20: approve from the zero address");
1871         require(spender != address(0), "ERC20: approve to the zero address");
1872 
1873         _allowances[owner][spender] = amount;
1874         emit Approval(owner, spender, amount);
1875     }
1876 
1877     /**
1878      * @dev Hook that is called before any transfer of tokens. This includes
1879      * minting and burning.
1880      *
1881      * Calling conditions:
1882      *
1883      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1884      * will be transferred to `to`.
1885      * - when `from` is zero, `amount` tokens will be minted for `to`.
1886      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1887      * - `from` and `to` are never both zero.
1888      *
1889      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1890      */
1891     function _beforeTokenTransfer(
1892         address from,
1893         address to,
1894         uint256 amount
1895     ) internal virtual {}
1896 
1897     /**
1898      * @dev Hook that is called after any transfer of tokens. This includes
1899      * minting and burning.
1900      *
1901      * Calling conditions:
1902      *
1903      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1904      * has been transferred to `to`.
1905      * - when `from` is zero, `amount` tokens have been minted for `to`.
1906      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1907      * - `from` and `to` are never both zero.
1908      *
1909      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1910      */
1911     function _afterTokenTransfer(
1912         address from,
1913         address to,
1914         uint256 amount
1915     ) internal virtual {}
1916     uint256[45] private __gap;
1917 }
1918 
1919 
1920 // Dependency file: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
1921 
1922 
1923 // pragma solidity ^0.8.0;
1924 
1925 // import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
1926 // import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
1927 
1928 /**
1929  * @dev Contract module which provides a basic access control mechanism, where
1930  * there is an account (an owner) that can be granted exclusive access to
1931  * specific functions.
1932  *
1933  * By default, the owner account will be the one that deploys the contract. This
1934  * can later be changed with {transferOwnership}.
1935  *
1936  * This module is used through inheritance. It will make available the modifier
1937  * `onlyOwner`, which can be applied to your functions to restrict their use to
1938  * the owner.
1939  */
1940 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1941     address private _owner;
1942 
1943     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1944 
1945     /**
1946      * @dev Initializes the contract setting the deployer as the initial owner.
1947      */
1948     function __Ownable_init() internal initializer {
1949         __Context_init_unchained();
1950         __Ownable_init_unchained();
1951     }
1952 
1953     function __Ownable_init_unchained() internal initializer {
1954         _setOwner(_msgSender());
1955     }
1956 
1957     /**
1958      * @dev Returns the address of the current owner.
1959      */
1960     function owner() public view virtual returns (address) {
1961         return _owner;
1962     }
1963 
1964     /**
1965      * @dev Throws if called by any account other than the owner.
1966      */
1967     modifier onlyOwner() {
1968         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1969         _;
1970     }
1971 
1972     /**
1973      * @dev Leaves the contract without owner. It will not be possible to call
1974      * `onlyOwner` functions anymore. Can only be called by the current owner.
1975      *
1976      * NOTE: Renouncing ownership will leave the contract without an owner,
1977      * thereby removing any functionality that is only available to the owner.
1978      */
1979     function renounceOwnership() public virtual onlyOwner {
1980         _setOwner(address(0));
1981     }
1982 
1983     /**
1984      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1985      * Can only be called by the current owner.
1986      */
1987     function transferOwnership(address newOwner) public virtual onlyOwner {
1988         require(newOwner != address(0), "Ownable: new owner is the zero address");
1989         _setOwner(newOwner);
1990     }
1991 
1992     function _setOwner(address newOwner) private {
1993         address oldOwner = _owner;
1994         _owner = newOwner;
1995         emit OwnershipTransferred(oldOwner, newOwner);
1996     }
1997     uint256[49] private __gap;
1998 }
1999 
2000 
2001 // Dependency file: contracts/interfaces/IUniswapV2Pair.sol
2002 
2003 // pragma solidity >=0.5.0;
2004 
2005 interface IUniswapV2Pair {
2006     event Approval(address indexed owner, address indexed spender, uint value);
2007     event Transfer(address indexed from, address indexed to, uint value);
2008 
2009     function name() external pure returns (string memory);
2010     function symbol() external pure returns (string memory);
2011     function decimals() external pure returns (uint8);
2012     function totalSupply() external view returns (uint);
2013     function balanceOf(address owner) external view returns (uint);
2014     function allowance(address owner, address spender) external view returns (uint);
2015 
2016     function approve(address spender, uint value) external returns (bool);
2017     function transfer(address to, uint value) external returns (bool);
2018     function transferFrom(address from, address to, uint value) external returns (bool);
2019 
2020     function DOMAIN_SEPARATOR() external view returns (bytes32);
2021     function PERMIT_TYPEHASH() external pure returns (bytes32);
2022     function nonces(address owner) external view returns (uint);
2023 
2024     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2025 
2026     event Mint(address indexed sender, uint amount0, uint amount1);
2027     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
2028     event Swap(
2029         address indexed sender,
2030         uint amount0In,
2031         uint amount1In,
2032         uint amount0Out,
2033         uint amount1Out,
2034         address indexed to
2035     );
2036     event Sync(uint112 reserve0, uint112 reserve1);
2037 
2038     function MINIMUM_LIQUIDITY() external pure returns (uint);
2039     function factory() external view returns (address);
2040     function token0() external view returns (address);
2041     function token1() external view returns (address);
2042     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
2043     function price0CumulativeLast() external view returns (uint);
2044     function price1CumulativeLast() external view returns (uint);
2045     function kLast() external view returns (uint);
2046 
2047     function mint(address to) external returns (uint liquidity);
2048     function burn(address to) external returns (uint amount0, uint amount1);
2049     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
2050     function skim(address to) external;
2051     function sync() external;
2052 
2053     function initialize(address, address) external;
2054 }
2055 
2056 // Dependency file: contracts/libs/SafeMathInt.sol
2057 
2058 // pragma solidity =0.8.4;
2059 
2060 /**
2061  * @title SafeMathInt
2062  * @dev Math operations for int256 with overflow safety checks.
2063  */
2064 library SafeMathInt {
2065     int256 private constant MIN_INT256 = int256(1) << 255;
2066     int256 private constant MAX_INT256 = ~(int256(1) << 255);
2067 
2068     /**
2069      * @dev Multiplies two int256 variables and fails on overflow.
2070      */
2071     function mul(int256 a, int256 b) internal pure returns (int256) {
2072         int256 c = a * b;
2073 
2074         // Detect overflow when multiplying MIN_INT256 with -1
2075         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
2076         require((b == 0) || (c / b == a));
2077         return c;
2078     }
2079 
2080     /**
2081      * @dev Division of two int256 variables and fails on overflow.
2082      */
2083     function div(int256 a, int256 b) internal pure returns (int256) {
2084         // Prevent overflow when dividing MIN_INT256 by -1
2085         require(b != -1 || a != MIN_INT256);
2086 
2087         // Solidity already throws when dividing by 0.
2088         return a / b;
2089     }
2090 
2091     /**
2092      * @dev Subtracts two int256 variables and fails on overflow.
2093      */
2094     function sub(int256 a, int256 b) internal pure returns (int256) {
2095         int256 c = a - b;
2096         require((b >= 0 && c <= a) || (b < 0 && c > a));
2097         return c;
2098     }
2099 
2100     /**
2101      * @dev Adds two int256 variables and fails on overflow.
2102      */
2103     function add(int256 a, int256 b) internal pure returns (int256) {
2104         int256 c = a + b;
2105         require((b >= 0 && c >= a) || (b < 0 && c < a));
2106         return c;
2107     }
2108 
2109     /**
2110      * @dev Converts to absolute value, and fails on overflow.
2111      */
2112     function abs(int256 a) internal pure returns (int256) {
2113         require(a != MIN_INT256);
2114         return a < 0 ? -a : a;
2115     }
2116 
2117     function toUint256Safe(int256 a) internal pure returns (uint256) {
2118         require(a >= 0);
2119         return uint256(a);
2120     }
2121 }
2122 
2123 
2124 // Dependency file: contracts/libs/SafeMathUint.sol
2125 
2126 // pragma solidity =0.8.4;
2127 
2128 /**
2129  * @title SafeMathUint
2130  * @dev Math operations with safety checks that revert on error
2131  */
2132 library SafeMathUint {
2133     function toInt256Safe(uint256 a) internal pure returns (int256) {
2134         int256 b = int256(a);
2135         require(b >= 0);
2136         return b;
2137     }
2138 }
2139 
2140 
2141 // Dependency file: contracts/baby/IterableMapping.sol
2142 
2143 // pragma solidity =0.8.4;
2144 
2145 library IterableMapping {
2146     // Iterable mapping from address to uint;
2147     struct Map {
2148         address[] keys;
2149         mapping(address => uint256) values;
2150         mapping(address => uint256) indexOf;
2151         mapping(address => bool) inserted;
2152     }
2153 
2154     function get(Map storage map, address key) public view returns (uint256) {
2155         return map.values[key];
2156     }
2157 
2158     function getIndexOfKey(Map storage map, address key)
2159         public
2160         view
2161         returns (int256)
2162     {
2163         if (!map.inserted[key]) {
2164             return -1;
2165         }
2166         return int256(map.indexOf[key]);
2167     }
2168 
2169     function getKeyAtIndex(Map storage map, uint256 index)
2170         public
2171         view
2172         returns (address)
2173     {
2174         return map.keys[index];
2175     }
2176 
2177     function size(Map storage map) public view returns (uint256) {
2178         return map.keys.length;
2179     }
2180 
2181     function set(
2182         Map storage map,
2183         address key,
2184         uint256 val
2185     ) public {
2186         if (map.inserted[key]) {
2187             map.values[key] = val;
2188         } else {
2189             map.inserted[key] = true;
2190             map.values[key] = val;
2191             map.indexOf[key] = map.keys.length;
2192             map.keys.push(key);
2193         }
2194     }
2195 
2196     function remove(Map storage map, address key) public {
2197         if (!map.inserted[key]) {
2198             return;
2199         }
2200 
2201         delete map.inserted[key];
2202         delete map.values[key];
2203 
2204         uint256 index = map.indexOf[key];
2205         uint256 lastIndex = map.keys.length - 1;
2206         address lastKey = map.keys[lastIndex];
2207 
2208         map.indexOf[lastKey] = index;
2209         delete map.indexOf[key];
2210 
2211         map.keys[index] = lastKey;
2212         map.keys.pop();
2213     }
2214 }
2215 
2216 
2217 // Dependency file: contracts/baby/BabyTokenDividendTracker.sol
2218 
2219 // pragma solidity =0.8.4;
2220 
2221 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
2222 // import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
2223 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
2224 // import "@openzeppelin/contracts/access/Ownable.sol";
2225 // import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
2226 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
2227 // import "contracts/interfaces/IUniswapV2Factory.sol";
2228 // import "contracts/interfaces/IUniswapV2Router02.sol";
2229 // import "contracts/interfaces/IUniswapV2Pair.sol";
2230 // import "contracts/libs/SafeMathInt.sol";
2231 // import "contracts/libs/SafeMathUint.sol";
2232 // import "contracts/baby/IterableMapping.sol";
2233 
2234 /// @title Dividend-Paying Token Interface
2235 /// @author Roger Wu (https://github.com/roger-wu)
2236 /// @dev An interface for a dividend-paying token contract.
2237 interface DividendPayingTokenInterface {
2238     /// @notice View the amount of dividend in wei that an address can withdraw.
2239     /// @param _owner The address of a token holder.
2240     /// @return The amount of dividend in wei that `_owner` can withdraw.
2241     function dividendOf(address _owner) external view returns (uint256);
2242 
2243     /// @notice Withdraws the ether distributed to the sender.
2244     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
2245     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
2246     function withdrawDividend() external;
2247 
2248     /// @dev This event MUST emit when ether is distributed to token holders.
2249     /// @param from The address which sends ether to this contract.
2250     /// @param weiAmount The amount of distributed ether in wei.
2251     event DividendsDistributed(address indexed from, uint256 weiAmount);
2252 
2253     /// @dev This event MUST emit when an address withdraws their dividend.
2254     /// @param to The address which withdraws ether from this contract.
2255     /// @param weiAmount The amount of withdrawn ether in wei.
2256     event DividendWithdrawn(address indexed to, uint256 weiAmount);
2257 }
2258 
2259 /// @title Dividend-Paying Token Optional Interface
2260 /// @author Roger Wu (https://github.com/roger-wu)
2261 /// @dev OPTIONAL functions for a dividend-paying token contract.
2262 interface DividendPayingTokenOptionalInterface {
2263     /// @notice View the amount of dividend in wei that an address can withdraw.
2264     /// @param _owner The address of a token holder.
2265     /// @return The amount of dividend in wei that `_owner` can withdraw.
2266     function withdrawableDividendOf(address _owner)
2267         external
2268         view
2269         returns (uint256);
2270 
2271     /// @notice View the amount of dividend in wei that an address has withdrawn.
2272     /// @param _owner The address of a token holder.
2273     /// @return The amount of dividend in wei that `_owner` has withdrawn.
2274     function withdrawnDividendOf(address _owner)
2275         external
2276         view
2277         returns (uint256);
2278 
2279     /// @notice View the amount of dividend in wei that an address has earned in total.
2280     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
2281     /// @param _owner The address of a token holder.
2282     /// @return The amount of dividend in wei that `_owner` has earned in total.
2283     function accumulativeDividendOf(address _owner)
2284         external
2285         view
2286         returns (uint256);
2287 }
2288 
2289 /// @title Dividend-Paying Token
2290 /// @author Roger Wu (https://github.com/roger-wu)
2291 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
2292 ///  to token holders as dividends and allows token holders to withdraw their dividends.
2293 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
2294 contract DividendPayingToken is
2295     ERC20Upgradeable,
2296     OwnableUpgradeable,
2297     DividendPayingTokenInterface,
2298     DividendPayingTokenOptionalInterface
2299 {
2300     using SafeMath for uint256;
2301     using SafeMathUint for uint256;
2302     using SafeMathInt for int256;
2303 
2304     address public rewardToken;
2305 
2306     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
2307     // For more discussion about choosing the value of `magnitude`,
2308     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
2309     uint256 internal constant magnitude = 2**128;
2310 
2311     uint256 internal magnifiedDividendPerShare;
2312 
2313     // About dividendCorrection:
2314     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
2315     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
2316     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
2317     //   `dividendOf(_user)` should not be changed,
2318     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
2319     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
2320     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
2321     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
2322     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
2323     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
2324     mapping(address => int256) internal magnifiedDividendCorrections;
2325     mapping(address => uint256) internal withdrawnDividends;
2326 
2327     uint256 public totalDividendsDistributed;
2328 
2329     function __DividendPayingToken_init(
2330         address _rewardToken,
2331         string memory _name,
2332         string memory _symbol
2333     ) internal initializer {
2334         __Ownable_init();
2335         __ERC20_init(_name, _symbol);
2336         rewardToken = _rewardToken;
2337     }
2338 
2339     function distributeCAKEDividends(uint256 amount) public onlyOwner {
2340         require(totalSupply() > 0);
2341 
2342         if (amount > 0) {
2343             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
2344                 (amount).mul(magnitude) / totalSupply()
2345             );
2346             emit DividendsDistributed(msg.sender, amount);
2347 
2348             totalDividendsDistributed = totalDividendsDistributed.add(amount);
2349         }
2350     }
2351 
2352     /// @notice Withdraws the ether distributed to the sender.
2353     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
2354     function withdrawDividend() public virtual override {
2355         _withdrawDividendOfUser(payable(msg.sender));
2356     }
2357 
2358     /// @notice Withdraws the ether distributed to the sender.
2359     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
2360     function _withdrawDividendOfUser(address payable user)
2361         internal
2362         returns (uint256)
2363     {
2364         uint256 _withdrawableDividend = withdrawableDividendOf(user);
2365         if (_withdrawableDividend > 0) {
2366             withdrawnDividends[user] = withdrawnDividends[user].add(
2367                 _withdrawableDividend
2368             );
2369             emit DividendWithdrawn(user, _withdrawableDividend);
2370             bool success = IERC20(rewardToken).transfer(
2371                 user,
2372                 _withdrawableDividend
2373             );
2374 
2375             if (!success) {
2376                 withdrawnDividends[user] = withdrawnDividends[user].sub(
2377                     _withdrawableDividend
2378                 );
2379                 return 0;
2380             }
2381 
2382             return _withdrawableDividend;
2383         }
2384 
2385         return 0;
2386     }
2387 
2388     /// @notice View the amount of dividend in wei that an address can withdraw.
2389     /// @param _owner The address of a token holder.
2390     /// @return The amount of dividend in wei that `_owner` can withdraw.
2391     function dividendOf(address _owner) public view override returns (uint256) {
2392         return withdrawableDividendOf(_owner);
2393     }
2394 
2395     /// @notice View the amount of dividend in wei that an address can withdraw.
2396     /// @param _owner The address of a token holder.
2397     /// @return The amount of dividend in wei that `_owner` can withdraw.
2398     function withdrawableDividendOf(address _owner)
2399         public
2400         view
2401         override
2402         returns (uint256)
2403     {
2404         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
2405     }
2406 
2407     /// @notice View the amount of dividend in wei that an address has withdrawn.
2408     /// @param _owner The address of a token holder.
2409     /// @return The amount of dividend in wei that `_owner` has withdrawn.
2410     function withdrawnDividendOf(address _owner)
2411         public
2412         view
2413         override
2414         returns (uint256)
2415     {
2416         return withdrawnDividends[_owner];
2417     }
2418 
2419     /// @notice View the amount of dividend in wei that an address has earned in total.
2420     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
2421     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
2422     /// @param _owner The address of a token holder.
2423     /// @return The amount of dividend in wei that `_owner` has earned in total.
2424     function accumulativeDividendOf(address _owner)
2425         public
2426         view
2427         override
2428         returns (uint256)
2429     {
2430         return
2431             magnifiedDividendPerShare
2432                 .mul(balanceOf(_owner))
2433                 .toInt256Safe()
2434                 .add(magnifiedDividendCorrections[_owner])
2435                 .toUint256Safe() / magnitude;
2436     }
2437 
2438     /// @dev Internal function that transfer tokens from one address to another.
2439     /// Update magnifiedDividendCorrections to keep dividends unchanged.
2440     /// @param from The address to transfer from.
2441     /// @param to The address to transfer to.
2442     /// @param value The amount to be transferred.
2443     function _transfer(
2444         address from,
2445         address to,
2446         uint256 value
2447     ) internal virtual override {
2448         require(false);
2449 
2450         int256 _magCorrection = magnifiedDividendPerShare
2451             .mul(value)
2452             .toInt256Safe();
2453         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from]
2454             .add(_magCorrection);
2455         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(
2456             _magCorrection
2457         );
2458     }
2459 
2460     /// @dev Internal function that mints tokens to an account.
2461     /// Update magnifiedDividendCorrections to keep dividends unchanged.
2462     /// @param account The account that will receive the created tokens.
2463     /// @param value The amount that will be created.
2464     function _mint(address account, uint256 value) internal override {
2465         super._mint(account, value);
2466 
2467         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
2468             account
2469         ].sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
2470     }
2471 
2472     /// @dev Internal function that burns an amount of the token of a given account.
2473     /// Update magnifiedDividendCorrections to keep dividends unchanged.
2474     /// @param account The account whose tokens will be burnt.
2475     /// @param value The amount that will be burnt.
2476     function _burn(address account, uint256 value) internal override {
2477         super._burn(account, value);
2478 
2479         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
2480             account
2481         ].add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
2482     }
2483 
2484     function _setBalance(address account, uint256 newBalance) internal {
2485         uint256 currentBalance = balanceOf(account);
2486 
2487         if (newBalance > currentBalance) {
2488             uint256 mintAmount = newBalance.sub(currentBalance);
2489             _mint(account, mintAmount);
2490         } else if (newBalance < currentBalance) {
2491             uint256 burnAmount = currentBalance.sub(newBalance);
2492             _burn(account, burnAmount);
2493         }
2494     }
2495 }
2496 
2497 contract BABYTOKENDividendTracker is OwnableUpgradeable, DividendPayingToken {
2498     using SafeMath for uint256;
2499     using SafeMathInt for int256;
2500     using IterableMapping for IterableMapping.Map;
2501 
2502     IterableMapping.Map private tokenHoldersMap;
2503     uint256 public lastProcessedIndex;
2504 
2505     mapping(address => bool) public excludedFromDividends;
2506 
2507     mapping(address => uint256) public lastClaimTimes;
2508 
2509     uint256 public claimWait;
2510     uint256 public minimumTokenBalanceForDividends;
2511 
2512     event ExcludeFromDividends(address indexed account);
2513     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
2514 
2515     event Claim(
2516         address indexed account,
2517         uint256 amount,
2518         bool indexed automatic
2519     );
2520 
2521     function initialize(
2522         address rewardToken_,
2523         uint256 minimumTokenBalanceForDividends_
2524     ) external initializer {
2525         DividendPayingToken.__DividendPayingToken_init(
2526             rewardToken_,
2527             "DIVIDEND_TRACKER",
2528             "DIVIDEND_TRACKER"
2529         );
2530         claimWait = 3600;
2531         minimumTokenBalanceForDividends = minimumTokenBalanceForDividends_;
2532     }
2533 
2534     function _transfer(
2535         address,
2536         address,
2537         uint256
2538     ) internal pure override {
2539         require(false, "Dividend_Tracker: No transfers allowed");
2540     }
2541 
2542     function withdrawDividend() public pure override {
2543         require(
2544             false,
2545             "Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main BABYTOKEN contract."
2546         );
2547     }
2548 
2549     function excludeFromDividends(address account) external onlyOwner {
2550         require(!excludedFromDividends[account]);
2551         excludedFromDividends[account] = true;
2552 
2553         _setBalance(account, 0);
2554         tokenHoldersMap.remove(account);
2555 
2556         emit ExcludeFromDividends(account);
2557     }
2558 
2559     function isExcludedFromDividends(address account)
2560         public
2561         view
2562         returns (bool)
2563     {
2564         return excludedFromDividends[account];
2565     }
2566 
2567     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
2568         require(
2569             newClaimWait >= 3600 && newClaimWait <= 86400,
2570             "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours"
2571         );
2572         require(
2573             newClaimWait != claimWait,
2574             "Dividend_Tracker: Cannot update claimWait to same value"
2575         );
2576         emit ClaimWaitUpdated(newClaimWait, claimWait);
2577         claimWait = newClaimWait;
2578     }
2579 
2580     function updateMinimumTokenBalanceForDividends(uint256 amount)
2581         external
2582         onlyOwner
2583     {
2584         minimumTokenBalanceForDividends = amount;
2585     }
2586 
2587     function getLastProcessedIndex() external view returns (uint256) {
2588         return lastProcessedIndex;
2589     }
2590 
2591     function getNumberOfTokenHolders() external view returns (uint256) {
2592         return tokenHoldersMap.keys.length;
2593     }
2594 
2595     function getAccount(address _account)
2596         public
2597         view
2598         returns (
2599             address account,
2600             int256 index,
2601             int256 iterationsUntilProcessed,
2602             uint256 withdrawableDividends,
2603             uint256 totalDividends,
2604             uint256 lastClaimTime,
2605             uint256 nextClaimTime,
2606             uint256 secondsUntilAutoClaimAvailable
2607         )
2608     {
2609         account = _account;
2610 
2611         index = tokenHoldersMap.getIndexOfKey(account);
2612 
2613         iterationsUntilProcessed = -1;
2614 
2615         if (index >= 0) {
2616             if (uint256(index) > lastProcessedIndex) {
2617                 iterationsUntilProcessed = index.sub(
2618                     int256(lastProcessedIndex)
2619                 );
2620             } else {
2621                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length >
2622                     lastProcessedIndex
2623                     ? tokenHoldersMap.keys.length.sub(lastProcessedIndex)
2624                     : 0;
2625 
2626                 iterationsUntilProcessed = index.add(
2627                     int256(processesUntilEndOfArray)
2628                 );
2629             }
2630         }
2631 
2632         withdrawableDividends = withdrawableDividendOf(account);
2633         totalDividends = accumulativeDividendOf(account);
2634 
2635         lastClaimTime = lastClaimTimes[account];
2636 
2637         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
2638 
2639         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp
2640             ? nextClaimTime.sub(block.timestamp)
2641             : 0;
2642     }
2643 
2644     function getAccountAtIndex(uint256 index)
2645         public
2646         view
2647         returns (
2648             address,
2649             int256,
2650             int256,
2651             uint256,
2652             uint256,
2653             uint256,
2654             uint256,
2655             uint256
2656         )
2657     {
2658         if (index >= tokenHoldersMap.size()) {
2659             return (address(0), -1, -1, 0, 0, 0, 0, 0);
2660         }
2661 
2662         address account = tokenHoldersMap.getKeyAtIndex(index);
2663 
2664         return getAccount(account);
2665     }
2666 
2667     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
2668         if (lastClaimTime > block.timestamp) {
2669             return false;
2670         }
2671 
2672         return block.timestamp.sub(lastClaimTime) >= claimWait;
2673     }
2674 
2675     function setBalance(address payable account, uint256 newBalance)
2676         external
2677         onlyOwner
2678     {
2679         if (excludedFromDividends[account]) {
2680             return;
2681         }
2682         if (newBalance >= minimumTokenBalanceForDividends) {
2683             _setBalance(account, newBalance);
2684             tokenHoldersMap.set(account, newBalance);
2685         } else {
2686             _setBalance(account, 0);
2687             tokenHoldersMap.remove(account);
2688         }
2689         processAccount(account, true);
2690     }
2691 
2692     function process(uint256 gas)
2693         public
2694         returns (
2695             uint256,
2696             uint256,
2697             uint256
2698         )
2699     {
2700         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
2701 
2702         if (numberOfTokenHolders == 0) {
2703             return (0, 0, lastProcessedIndex);
2704         }
2705 
2706         uint256 _lastProcessedIndex = lastProcessedIndex;
2707 
2708         uint256 gasUsed = 0;
2709 
2710         uint256 gasLeft = gasleft();
2711 
2712         uint256 iterations = 0;
2713         uint256 claims = 0;
2714 
2715         while (gasUsed < gas && iterations < numberOfTokenHolders) {
2716             _lastProcessedIndex++;
2717 
2718             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
2719                 _lastProcessedIndex = 0;
2720             }
2721 
2722             address account = tokenHoldersMap.keys[_lastProcessedIndex];
2723 
2724             if (canAutoClaim(lastClaimTimes[account])) {
2725                 if (processAccount(payable(account), true)) {
2726                     claims++;
2727                 }
2728             }
2729 
2730             iterations++;
2731 
2732             uint256 newGasLeft = gasleft();
2733 
2734             if (gasLeft > newGasLeft) {
2735                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
2736             }
2737 
2738             gasLeft = newGasLeft;
2739         }
2740 
2741         lastProcessedIndex = _lastProcessedIndex;
2742 
2743         return (iterations, claims, lastProcessedIndex);
2744     }
2745 
2746     function processAccount(address payable account, bool automatic)
2747         public
2748         onlyOwner
2749         returns (bool)
2750     {
2751         uint256 amount = _withdrawDividendOfUser(account);
2752 
2753         if (amount > 0) {
2754             lastClaimTimes[account] = block.timestamp;
2755             emit Claim(account, amount, automatic);
2756             return true;
2757         }
2758 
2759         return false;
2760     }
2761 }
2762 
2763 
2764 // Dependency file: contracts/BaseToken.sol
2765 
2766 // pragma solidity =0.8.4;
2767 
2768 enum TokenType {
2769     standard,
2770     antiBotStandard,
2771     liquidityGenerator,
2772     antiBotLiquidityGenerator,
2773     baby,
2774     antiBotBaby,
2775     buybackBaby,
2776     antiBotBuybackBaby
2777 }
2778 
2779 abstract contract BaseToken {
2780     event TokenCreated(
2781         address indexed owner,
2782         address indexed token,
2783         TokenType tokenType,
2784         uint256 version
2785     );
2786 }
2787 
2788 
2789 // Root file: contracts/baby/BabyToken.sol
2790 
2791 pragma solidity =0.8.4;
2792 
2793 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
2794 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
2795 // import "@openzeppelin/contracts/access/Ownable.sol";
2796 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
2797 // import "@openzeppelin/contracts/proxy/Clones.sol";
2798 // import "@openzeppelin/contracts/utils/Address.sol";
2799 // import "contracts/interfaces/IUniswapV2Factory.sol";
2800 // import "contracts/interfaces/IUniswapV2Router02.sol";
2801 // import "contracts/baby/BabyTokenDividendTracker.sol";
2802 // import "contracts/BaseToken.sol";
2803 
2804 contract BABYTOKEN is ERC20, Ownable, BaseToken {
2805     using SafeMath for uint256;
2806     using Address for address;
2807     using Address for address payable;
2808 
2809     uint256 public constant VERSION = 3;
2810 
2811     IUniswapV2Router02 public uniswapV2Router;
2812     address public uniswapV2Pair;
2813 
2814     bool private swapping;
2815 
2816     BABYTOKENDividendTracker public dividendTracker;
2817 
2818     address public rewardToken;
2819 
2820     uint256 public swapTokensAtAmount;
2821 
2822     uint256 public tokenRewardsFee;
2823     uint256 public liquidityFee;
2824     uint256 public marketingFee;
2825     uint256 public totalFees;
2826 
2827     address public _marketingWalletAddress;
2828 
2829     uint256 public gasForProcessing;
2830 
2831     // exlcude from fees and max transaction amount
2832     mapping(address => bool) private _isExcludedFromFees;
2833 
2834     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
2835     // could be subject to a maximum transfer amount
2836     mapping(address => bool) public automatedMarketMakerPairs;
2837 
2838     event ExcludeFromFees(address indexed account);
2839     event ExcludeMultipleAccountsFromFees(address[] accounts);
2840 
2841     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
2842 
2843     event GasForProcessingUpdated(
2844         uint256 indexed newValue,
2845         uint256 indexed oldValue
2846     );
2847 
2848     event SwapAndLiquify(
2849         uint256 tokensSwapped,
2850         uint256 ethReceived,
2851         uint256 tokensIntoLiqudity
2852     );
2853 
2854     event SendDividends(uint256 tokensSwapped, uint256 amount);
2855 
2856     event ProcessedDividendTracker(
2857         uint256 iterations,
2858         uint256 claims,
2859         uint256 lastProcessedIndex,
2860         bool indexed automatic,
2861         uint256 gas,
2862         address indexed processor
2863     );
2864 
2865     constructor(
2866         string memory name_,
2867         string memory symbol_,
2868         uint256 totalSupply_,
2869         address[4] memory addrs, // reward, router, marketing wallet, dividendTracker
2870         uint256[3] memory feeSettings, // rewards, liquidity, marketing
2871         uint256 minimumTokenBalanceForDividends_,
2872         address serviceFeeReceiver_,
2873         uint256 serviceFee_
2874     ) payable ERC20(name_, symbol_) {
2875         rewardToken = addrs[0];
2876         _marketingWalletAddress = addrs[2];
2877         require(
2878             msg.sender != _marketingWalletAddress,
2879             "Owner and marketing wallet cannot be the same"
2880         );
2881         require(
2882             !_marketingWalletAddress.isContract(),
2883             "Marketing wallet cannot be a contract"
2884         );
2885 
2886         tokenRewardsFee = feeSettings[0];
2887         liquidityFee = feeSettings[1];
2888         marketingFee = feeSettings[2];
2889         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
2890         require(totalFees <= 25, "Total fee is over 25%");
2891         swapTokensAtAmount = totalSupply_.div(1000); // 0.1%
2892 
2893         // use by default 300,000 gas to process auto-claiming dividends
2894         gasForProcessing = 300000;
2895 
2896         dividendTracker = BABYTOKENDividendTracker(
2897             payable(Clones.clone(addrs[3]))
2898         );
2899         dividendTracker.initialize(
2900             rewardToken,
2901             minimumTokenBalanceForDividends_
2902         );
2903 
2904         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(addrs[1]);
2905         // Create a uniswap pair for this new token
2906         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
2907             .createPair(address(this), _uniswapV2Router.WETH());
2908         uniswapV2Router = _uniswapV2Router;
2909         uniswapV2Pair = _uniswapV2Pair;
2910         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
2911 
2912         // exclude from receiving dividends
2913         dividendTracker.excludeFromDividends(address(dividendTracker));
2914         dividendTracker.excludeFromDividends(address(this));
2915         dividendTracker.excludeFromDividends(owner());
2916         dividendTracker.excludeFromDividends(address(0xdead));
2917         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
2918         // exclude from paying fees or having max transaction amount
2919         _isExcludedFromFees[owner()] = true;
2920         _isExcludedFromFees[_marketingWalletAddress] = true;
2921         _isExcludedFromFees[address(this)] = true;
2922         /*
2923             _mint is an internal function in ERC20.sol that is only called here,
2924             and CANNOT be called ever again
2925         */
2926         _mint(owner(), totalSupply_);
2927 
2928         emit TokenCreated(owner(), address(this), TokenType.baby, VERSION);
2929 
2930         payable(serviceFeeReceiver_).transfer(serviceFee_);
2931     }
2932 
2933     receive() external payable {}
2934 
2935     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
2936         require(
2937             amount > totalSupply() / 10**5,
2938             "BABYTOKEN: Amount must be greater than 0.001% of total supply"
2939         );
2940         swapTokensAtAmount = amount;
2941     }
2942 
2943     function excludeFromFees(address account) external onlyOwner {
2944         require(
2945             !_isExcludedFromFees[account],
2946             "BABYTOKEN: Account is already excluded"
2947         );
2948         _isExcludedFromFees[account] = true;
2949 
2950         emit ExcludeFromFees(account);
2951     }
2952 
2953     function excludeMultipleAccountsFromFees(address[] calldata accounts)
2954         external
2955         onlyOwner
2956     {
2957         for (uint256 i = 0; i < accounts.length; i++) {
2958             _isExcludedFromFees[accounts[i]] = true;
2959         }
2960 
2961         emit ExcludeMultipleAccountsFromFees(accounts);
2962     }
2963 
2964     function setMarketingWallet(address payable wallet) external onlyOwner {
2965         require(
2966             wallet != address(0),
2967             "BABYTOKEN: The marketing wallet cannot be the value of zero"
2968         );
2969         require(!wallet.isContract(), "Marketing wallet cannot be a contract");
2970         _marketingWalletAddress = wallet;
2971     }
2972 
2973     function setTokenRewardsFee(uint256 value) external onlyOwner {
2974         tokenRewardsFee = value;
2975         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
2976         require(totalFees <= 25, "Total fee is over 25%");
2977     }
2978 
2979     function setLiquiditFee(uint256 value) external onlyOwner {
2980         liquidityFee = value;
2981         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
2982         require(totalFees <= 25, "Total fee is over 25%");
2983     }
2984 
2985     function setMarketingFee(uint256 value) external onlyOwner {
2986         marketingFee = value;
2987         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
2988         require(totalFees <= 25, "Total fee is over 25%");
2989     }
2990 
2991     function _setAutomatedMarketMakerPair(address pair, bool value) private {
2992         require(
2993             automatedMarketMakerPairs[pair] != value,
2994             "BABYTOKEN: Automated market maker pair is already set to that value"
2995         );
2996         automatedMarketMakerPairs[pair] = value;
2997 
2998         if (value) {
2999             dividendTracker.excludeFromDividends(pair);
3000         }
3001 
3002         emit SetAutomatedMarketMakerPair(pair, value);
3003     }
3004 
3005     function updateGasForProcessing(uint256 newValue) public onlyOwner {
3006         require(
3007             newValue >= 200000 && newValue <= 500000,
3008             "BABYTOKEN: gasForProcessing must be between 200,000 and 500,000"
3009         );
3010         require(
3011             newValue != gasForProcessing,
3012             "BABYTOKEN: Cannot update gasForProcessing to same value"
3013         );
3014         emit GasForProcessingUpdated(newValue, gasForProcessing);
3015         gasForProcessing = newValue;
3016     }
3017 
3018     function updateClaimWait(uint256 claimWait) external onlyOwner {
3019         dividendTracker.updateClaimWait(claimWait);
3020     }
3021 
3022     function getClaimWait() external view returns (uint256) {
3023         return dividendTracker.claimWait();
3024     }
3025 
3026     function updateMinimumTokenBalanceForDividends(uint256 amount)
3027         external
3028         onlyOwner
3029     {
3030         dividendTracker.updateMinimumTokenBalanceForDividends(amount);
3031     }
3032 
3033     function getMinimumTokenBalanceForDividends()
3034         external
3035         view
3036         returns (uint256)
3037     {
3038         return dividendTracker.minimumTokenBalanceForDividends();
3039     }
3040 
3041     function getTotalDividendsDistributed() external view returns (uint256) {
3042         return dividendTracker.totalDividendsDistributed();
3043     }
3044 
3045     function isExcludedFromFees(address account) public view returns (bool) {
3046         return _isExcludedFromFees[account];
3047     }
3048 
3049     function withdrawableDividendOf(address account)
3050         public
3051         view
3052         returns (uint256)
3053     {
3054         return dividendTracker.withdrawableDividendOf(account);
3055     }
3056 
3057     function dividendTokenBalanceOf(address account)
3058         public
3059         view
3060         returns (uint256)
3061     {
3062         return dividendTracker.balanceOf(account);
3063     }
3064 
3065     function excludeFromDividends(address account) external onlyOwner {
3066         dividendTracker.excludeFromDividends(account);
3067     }
3068 
3069     function isExcludedFromDividends(address account)
3070         public
3071         view
3072         returns (bool)
3073     {
3074         return dividendTracker.isExcludedFromDividends(account);
3075     }
3076 
3077     function getAccountDividendsInfo(address account)
3078         external
3079         view
3080         returns (
3081             address,
3082             int256,
3083             int256,
3084             uint256,
3085             uint256,
3086             uint256,
3087             uint256,
3088             uint256
3089         )
3090     {
3091         return dividendTracker.getAccount(account);
3092     }
3093 
3094     function getAccountDividendsInfoAtIndex(uint256 index)
3095         external
3096         view
3097         returns (
3098             address,
3099             int256,
3100             int256,
3101             uint256,
3102             uint256,
3103             uint256,
3104             uint256,
3105             uint256
3106         )
3107     {
3108         return dividendTracker.getAccountAtIndex(index);
3109     }
3110 
3111     function processDividendTracker(uint256 gas) external {
3112         (
3113             uint256 iterations,
3114             uint256 claims,
3115             uint256 lastProcessedIndex
3116         ) = dividendTracker.process(gas);
3117         emit ProcessedDividendTracker(
3118             iterations,
3119             claims,
3120             lastProcessedIndex,
3121             false,
3122             gas,
3123             tx.origin
3124         );
3125     }
3126 
3127     function claim() external {
3128         dividendTracker.processAccount(payable(msg.sender), false);
3129     }
3130 
3131     function getLastProcessedIndex() external view returns (uint256) {
3132         return dividendTracker.getLastProcessedIndex();
3133     }
3134 
3135     function getNumberOfDividendTokenHolders() external view returns (uint256) {
3136         return dividendTracker.getNumberOfTokenHolders();
3137     }
3138 
3139     function _transfer(
3140         address from,
3141         address to,
3142         uint256 amount
3143     ) internal override {
3144         require(from != address(0), "ERC20: transfer from the zero address");
3145         require(to != address(0), "ERC20: transfer to the zero address");
3146 
3147         if (amount == 0) {
3148             super._transfer(from, to, 0);
3149             return;
3150         }
3151 
3152         uint256 contractTokenBalance = balanceOf(address(this));
3153 
3154         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
3155 
3156         if (
3157             canSwap &&
3158             !swapping &&
3159             !automatedMarketMakerPairs[from] &&
3160             from != owner() &&
3161             to != owner() &&
3162             totalFees > 0
3163         ) {
3164             swapping = true;
3165 
3166             if (marketingFee > 0) {
3167                 uint256 marketingTokens = contractTokenBalance
3168                     .mul(marketingFee)
3169                     .div(totalFees);
3170                 swapAndSendToFee(marketingTokens);
3171             }
3172 
3173             if (liquidityFee > 0) {
3174                 uint256 swapTokens = contractTokenBalance.mul(liquidityFee).div(
3175                     totalFees
3176                 );
3177                 swapAndLiquify(swapTokens);
3178             }
3179 
3180             uint256 sellTokens = balanceOf(address(this));
3181             if (sellTokens > 0) {
3182                 swapAndSendDividends(sellTokens);
3183             }
3184 
3185             swapping = false;
3186         }
3187 
3188         bool takeFee = !swapping;
3189 
3190         // if any account belongs to _isExcludedFromFee account then remove the fee
3191         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
3192             takeFee = false;
3193         }
3194 
3195         if (takeFee && totalFees > 0) {
3196             uint256 fees = amount.mul(totalFees).div(100);
3197             amount = amount.sub(fees);
3198 
3199             super._transfer(from, address(this), fees);
3200         }
3201 
3202         super._transfer(from, to, amount);
3203 
3204         try
3205             dividendTracker.setBalance(payable(from), balanceOf(from))
3206         {} catch {}
3207         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
3208 
3209         if (!swapping) {
3210             uint256 gas = gasForProcessing;
3211 
3212             try dividendTracker.process(gas) returns (
3213                 uint256 iterations,
3214                 uint256 claims,
3215                 uint256 lastProcessedIndex
3216             ) {
3217                 emit ProcessedDividendTracker(
3218                     iterations,
3219                     claims,
3220                     lastProcessedIndex,
3221                     true,
3222                     gas,
3223                     tx.origin
3224                 );
3225             } catch {}
3226         }
3227     }
3228 
3229     function swapAndSendToFee(uint256 tokens) private {
3230         uint256 initialCAKEBalance = IERC20(rewardToken).balanceOf(
3231             address(this)
3232         );
3233 
3234         swapTokensForCake(tokens);
3235         uint256 newBalance = (IERC20(rewardToken).balanceOf(address(this))).sub(
3236             initialCAKEBalance
3237         );
3238         IERC20(rewardToken).transfer(_marketingWalletAddress, newBalance);
3239     }
3240 
3241     function swapAndLiquify(uint256 tokens) private {
3242         // split the contract balance into halves
3243         uint256 half = tokens.div(2);
3244         uint256 otherHalf = tokens.sub(half);
3245 
3246         // capture the contract's current ETH balance.
3247         // this is so that we can capture exactly the amount of ETH that the
3248         // swap creates, and not make the liquidity event include any ETH that
3249         // has been manually sent to the contract
3250         uint256 initialBalance = address(this).balance;
3251 
3252         // swap tokens for ETH
3253         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
3254 
3255         // how much ETH did we just swap into?
3256         uint256 newBalance = address(this).balance.sub(initialBalance);
3257 
3258         // add liquidity to uniswap
3259         addLiquidity(otherHalf, newBalance);
3260 
3261         emit SwapAndLiquify(half, newBalance, otherHalf);
3262     }
3263 
3264     function swapTokensForEth(uint256 tokenAmount) private {
3265         // generate the uniswap pair path of token -> weth
3266         address[] memory path = new address[](2);
3267         path[0] = address(this);
3268         path[1] = uniswapV2Router.WETH();
3269 
3270         _approve(address(this), address(uniswapV2Router), tokenAmount);
3271 
3272         // make the swap
3273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
3274             tokenAmount,
3275             0, // accept any amount of ETH
3276             path,
3277             address(this),
3278             block.timestamp
3279         );
3280     }
3281 
3282     function swapTokensForCake(uint256 tokenAmount) private {
3283         address[] memory path = new address[](3);
3284         path[0] = address(this);
3285         path[1] = uniswapV2Router.WETH();
3286         path[2] = rewardToken;
3287 
3288         _approve(address(this), address(uniswapV2Router), tokenAmount);
3289 
3290         // make the swap
3291         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
3292             tokenAmount,
3293             0,
3294             path,
3295             address(this),
3296             block.timestamp
3297         );
3298     }
3299 
3300     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
3301         // approve token transfer to cover all possible scenarios
3302         _approve(address(this), address(uniswapV2Router), tokenAmount);
3303 
3304         // add the liquidity
3305         uniswapV2Router.addLiquidityETH{value: ethAmount}(
3306             address(this),
3307             tokenAmount,
3308             0, // slippage is unavoidable
3309             0, // slippage is unavoidable
3310             address(0xdead),
3311             block.timestamp
3312         );
3313     }
3314 
3315     function swapAndSendDividends(uint256 tokens) private {
3316         swapTokensForCake(tokens);
3317         uint256 dividends = IERC20(rewardToken).balanceOf(address(this));
3318         bool success = IERC20(rewardToken).transfer(
3319             address(dividendTracker),
3320             dividends
3321         );
3322 
3323         if (success) {
3324             dividendTracker.distributeCAKEDividends(dividends);
3325             emit SendDividends(tokens, dividends);
3326         }
3327     }
3328 }