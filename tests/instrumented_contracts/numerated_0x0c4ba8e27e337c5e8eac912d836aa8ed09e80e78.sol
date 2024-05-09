1 // Sources flattened with hardhat v2.9.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 
234 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Provides information about the current execution context, including the
242  * sender of the transaction and its data. While these are generally available
243  * via msg.sender and msg.data, they should not be accessed in such a direct
244  * manner, since when dealing with meta-transactions the account sending and
245  * paying for execution may not be the actual sender (as far as an application
246  * is concerned).
247  *
248  * This contract is only required for intermediate, library-like contracts.
249  */
250 abstract contract Context {
251     function _msgSender() internal view virtual returns (address) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes calldata) {
256         return msg.data;
257     }
258 }
259 
260 
261 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
262 
263 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Contract module which provides a basic access control mechanism, where
269  * there is an account (an owner) that can be granted exclusive access to
270  * specific functions.
271  *
272  * By default, the owner account will be the one that deploys the contract. This
273  * can later be changed with {transferOwnership}.
274  *
275  * This module is used through inheritance. It will make available the modifier
276  * `onlyOwner`, which can be applied to your functions to restrict their use to
277  * the owner.
278  */
279 abstract contract Ownable is Context {
280     address private _owner;
281 
282     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284     /**
285      * @dev Initializes the contract setting the deployer as the initial owner.
286      */
287     constructor() {
288         _transferOwnership(_msgSender());
289     }
290 
291     /**
292      * @dev Returns the address of the current owner.
293      */
294     function owner() public view virtual returns (address) {
295         return _owner;
296     }
297 
298     /**
299      * @dev Throws if called by any account other than the owner.
300      */
301     modifier onlyOwner() {
302         require(owner() == _msgSender(), "Ownable: caller is not the owner");
303         _;
304     }
305 
306     /**
307      * @dev Leaves the contract without owner. It will not be possible to call
308      * `onlyOwner` functions anymore. Can only be called by the current owner.
309      *
310      * NOTE: Renouncing ownership will leave the contract without an owner,
311      * thereby removing any functionality that is only available to the owner.
312      */
313     function renounceOwnership() public virtual onlyOwner {
314         _transferOwnership(address(0));
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Can only be called by the current owner.
320      */
321     function transferOwnership(address newOwner) public virtual onlyOwner {
322         require(newOwner != address(0), "Ownable: new owner is the zero address");
323         _transferOwnership(newOwner);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Internal function without access restriction.
329      */
330     function _transferOwnership(address newOwner) internal virtual {
331         address oldOwner = _owner;
332         _owner = newOwner;
333         emit OwnershipTransferred(oldOwner, newOwner);
334     }
335 }
336 
337 
338 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
339 
340 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Interface of the ERC20 standard as defined in the EIP.
346  */
347 interface IERC20 {
348     /**
349      * @dev Returns the amount of tokens in existence.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     /**
354      * @dev Returns the amount of tokens owned by `account`.
355      */
356     function balanceOf(address account) external view returns (uint256);
357 
358     /**
359      * @dev Moves `amount` tokens from the caller's account to `to`.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a {Transfer} event.
364      */
365     function transfer(address to, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Returns the remaining number of tokens that `spender` will be
369      * allowed to spend on behalf of `owner` through {transferFrom}. This is
370      * zero by default.
371      *
372      * This value changes when {approve} or {transferFrom} are called.
373      */
374     function allowance(address owner, address spender) external view returns (uint256);
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * IMPORTANT: Beware that changing an allowance with this method brings the risk
382      * that someone may use both the old and the new allowance by unfortunate
383      * transaction ordering. One possible solution to mitigate this race
384      * condition is to first reduce the spender's allowance to 0 and set the
385      * desired value afterwards:
386      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387      *
388      * Emits an {Approval} event.
389      */
390     function approve(address spender, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Moves `amount` tokens from `from` to `to` using the
394      * allowance mechanism. `amount` is then deducted from the caller's
395      * allowance.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transferFrom(
402         address from,
403         address to,
404         uint256 amount
405     ) external returns (bool);
406 
407     /**
408      * @dev Emitted when `value` tokens are moved from one account (`from`) to
409      * another (`to`).
410      *
411      * Note that `value` may be zero.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 value);
414 
415     /**
416      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
417      * a call to {approve}. `value` is the new allowance.
418      */
419     event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 
423 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
424 
425 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Interface for the optional metadata functions from the ERC20 standard.
431  *
432  * _Available since v4.1._
433  */
434 interface IERC20Metadata is IERC20 {
435     /**
436      * @dev Returns the name of the token.
437      */
438     function name() external view returns (string memory);
439 
440     /**
441      * @dev Returns the symbol of the token.
442      */
443     function symbol() external view returns (string memory);
444 
445     /**
446      * @dev Returns the decimals places of the token.
447      */
448     function decimals() external view returns (uint8);
449 }
450 
451 
452 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.5.0
453 
454 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 
460 /**
461  * @dev Implementation of the {IERC20} interface.
462  *
463  * This implementation is agnostic to the way tokens are created. This means
464  * that a supply mechanism has to be added in a derived contract using {_mint}.
465  * For a generic mechanism see {ERC20PresetMinterPauser}.
466  *
467  * TIP: For a detailed writeup see our guide
468  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
469  * to implement supply mechanisms].
470  *
471  * We have followed general OpenZeppelin Contracts guidelines: functions revert
472  * instead returning `false` on failure. This behavior is nonetheless
473  * conventional and does not conflict with the expectations of ERC20
474  * applications.
475  *
476  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
477  * This allows applications to reconstruct the allowance for all accounts just
478  * by listening to said events. Other implementations of the EIP may not emit
479  * these events, as it isn't required by the specification.
480  *
481  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
482  * functions have been added to mitigate the well-known issues around setting
483  * allowances. See {IERC20-approve}.
484  */
485 contract ERC20 is Context, IERC20, IERC20Metadata {
486     mapping(address => uint256) private _balances;
487 
488     mapping(address => mapping(address => uint256)) private _allowances;
489 
490     uint256 private _totalSupply;
491 
492     string private _name;
493     string private _symbol;
494 
495     /**
496      * @dev Sets the values for {name} and {symbol}.
497      *
498      * The default value of {decimals} is 18. To select a different value for
499      * {decimals} you should overload it.
500      *
501      * All two of these values are immutable: they can only be set once during
502      * construction.
503      */
504     constructor(string memory name_, string memory symbol_) {
505         _name = name_;
506         _symbol = symbol_;
507     }
508 
509     /**
510      * @dev Returns the name of the token.
511      */
512     function name() public view virtual override returns (string memory) {
513         return _name;
514     }
515 
516     /**
517      * @dev Returns the symbol of the token, usually a shorter version of the
518      * name.
519      */
520     function symbol() public view virtual override returns (string memory) {
521         return _symbol;
522     }
523 
524     /**
525      * @dev Returns the number of decimals used to get its user representation.
526      * For example, if `decimals` equals `2`, a balance of `505` tokens should
527      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
528      *
529      * Tokens usually opt for a value of 18, imitating the relationship between
530      * Ether and Wei. This is the value {ERC20} uses, unless this function is
531      * overridden;
532      *
533      * NOTE: This information is only used for _display_ purposes: it in
534      * no way affects any of the arithmetic of the contract, including
535      * {IERC20-balanceOf} and {IERC20-transfer}.
536      */
537     function decimals() public view virtual override returns (uint8) {
538         return 18;
539     }
540 
541     /**
542      * @dev See {IERC20-totalSupply}.
543      */
544     function totalSupply() public view virtual override returns (uint256) {
545         return _totalSupply;
546     }
547 
548     /**
549      * @dev See {IERC20-balanceOf}.
550      */
551     function balanceOf(address account) public view virtual override returns (uint256) {
552         return _balances[account];
553     }
554 
555     /**
556      * @dev See {IERC20-transfer}.
557      *
558      * Requirements:
559      *
560      * - `to` cannot be the zero address.
561      * - the caller must have a balance of at least `amount`.
562      */
563     function transfer(address to, uint256 amount) public virtual override returns (bool) {
564         address owner = _msgSender();
565         _transfer(owner, to, amount);
566         return true;
567     }
568 
569     /**
570      * @dev See {IERC20-allowance}.
571      */
572     function allowance(address owner, address spender) public view virtual override returns (uint256) {
573         return _allowances[owner][spender];
574     }
575 
576     /**
577      * @dev See {IERC20-approve}.
578      *
579      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
580      * `transferFrom`. This is semantically equivalent to an infinite approval.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      */
586     function approve(address spender, uint256 amount) public virtual override returns (bool) {
587         address owner = _msgSender();
588         _approve(owner, spender, amount);
589         return true;
590     }
591 
592     /**
593      * @dev See {IERC20-transferFrom}.
594      *
595      * Emits an {Approval} event indicating the updated allowance. This is not
596      * required by the EIP. See the note at the beginning of {ERC20}.
597      *
598      * NOTE: Does not update the allowance if the current allowance
599      * is the maximum `uint256`.
600      *
601      * Requirements:
602      *
603      * - `from` and `to` cannot be the zero address.
604      * - `from` must have a balance of at least `amount`.
605      * - the caller must have allowance for ``from``'s tokens of at least
606      * `amount`.
607      */
608     function transferFrom(
609         address from,
610         address to,
611         uint256 amount
612     ) public virtual override returns (bool) {
613         address spender = _msgSender();
614         _spendAllowance(from, spender, amount);
615         _transfer(from, to, amount);
616         return true;
617     }
618 
619     /**
620      * @dev Atomically increases the allowance granted to `spender` by the caller.
621      *
622      * This is an alternative to {approve} that can be used as a mitigation for
623      * problems described in {IERC20-approve}.
624      *
625      * Emits an {Approval} event indicating the updated allowance.
626      *
627      * Requirements:
628      *
629      * - `spender` cannot be the zero address.
630      */
631     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
632         address owner = _msgSender();
633         _approve(owner, spender, _allowances[owner][spender] + addedValue);
634         return true;
635     }
636 
637     /**
638      * @dev Atomically decreases the allowance granted to `spender` by the caller.
639      *
640      * This is an alternative to {approve} that can be used as a mitigation for
641      * problems described in {IERC20-approve}.
642      *
643      * Emits an {Approval} event indicating the updated allowance.
644      *
645      * Requirements:
646      *
647      * - `spender` cannot be the zero address.
648      * - `spender` must have allowance for the caller of at least
649      * `subtractedValue`.
650      */
651     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
652         address owner = _msgSender();
653         uint256 currentAllowance = _allowances[owner][spender];
654         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
655         unchecked {
656             _approve(owner, spender, currentAllowance - subtractedValue);
657         }
658 
659         return true;
660     }
661 
662     /**
663      * @dev Moves `amount` of tokens from `sender` to `recipient`.
664      *
665      * This internal function is equivalent to {transfer}, and can be used to
666      * e.g. implement automatic token fees, slashing mechanisms, etc.
667      *
668      * Emits a {Transfer} event.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `from` must have a balance of at least `amount`.
675      */
676     function _transfer(
677         address from,
678         address to,
679         uint256 amount
680     ) internal virtual {
681         require(from != address(0), "ERC20: transfer from the zero address");
682         require(to != address(0), "ERC20: transfer to the zero address");
683 
684         _beforeTokenTransfer(from, to, amount);
685 
686         uint256 fromBalance = _balances[from];
687         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
688         unchecked {
689             _balances[from] = fromBalance - amount;
690         }
691         _balances[to] += amount;
692 
693         emit Transfer(from, to, amount);
694 
695         _afterTokenTransfer(from, to, amount);
696     }
697 
698     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
699      * the total supply.
700      *
701      * Emits a {Transfer} event with `from` set to the zero address.
702      *
703      * Requirements:
704      *
705      * - `account` cannot be the zero address.
706      */
707     function _mint(address account, uint256 amount) internal virtual {
708         require(account != address(0), "ERC20: mint to the zero address");
709 
710         _beforeTokenTransfer(address(0), account, amount);
711 
712         _totalSupply += amount;
713         _balances[account] += amount;
714         emit Transfer(address(0), account, amount);
715 
716         _afterTokenTransfer(address(0), account, amount);
717     }
718 
719     /**
720      * @dev Destroys `amount` tokens from `account`, reducing the
721      * total supply.
722      *
723      * Emits a {Transfer} event with `to` set to the zero address.
724      *
725      * Requirements:
726      *
727      * - `account` cannot be the zero address.
728      * - `account` must have at least `amount` tokens.
729      */
730     function _burn(address account, uint256 amount) internal virtual {
731         require(account != address(0), "ERC20: burn from the zero address");
732 
733         _beforeTokenTransfer(account, address(0), amount);
734 
735         uint256 accountBalance = _balances[account];
736         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
737         unchecked {
738             _balances[account] = accountBalance - amount;
739         }
740         _totalSupply -= amount;
741 
742         emit Transfer(account, address(0), amount);
743 
744         _afterTokenTransfer(account, address(0), amount);
745     }
746 
747     /**
748      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
749      *
750      * This internal function is equivalent to `approve`, and can be used to
751      * e.g. set automatic allowances for certain subsystems, etc.
752      *
753      * Emits an {Approval} event.
754      *
755      * Requirements:
756      *
757      * - `owner` cannot be the zero address.
758      * - `spender` cannot be the zero address.
759      */
760     function _approve(
761         address owner,
762         address spender,
763         uint256 amount
764     ) internal virtual {
765         require(owner != address(0), "ERC20: approve from the zero address");
766         require(spender != address(0), "ERC20: approve to the zero address");
767 
768         _allowances[owner][spender] = amount;
769         emit Approval(owner, spender, amount);
770     }
771 
772     /**
773      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
774      *
775      * Does not update the allowance amount in case of infinite allowance.
776      * Revert if not enough allowance is available.
777      *
778      * Might emit an {Approval} event.
779      */
780     function _spendAllowance(
781         address owner,
782         address spender,
783         uint256 amount
784     ) internal virtual {
785         uint256 currentAllowance = allowance(owner, spender);
786         if (currentAllowance != type(uint256).max) {
787             require(currentAllowance >= amount, "ERC20: insufficient allowance");
788             unchecked {
789                 _approve(owner, spender, currentAllowance - amount);
790             }
791         }
792     }
793 
794     /**
795      * @dev Hook that is called before any transfer of tokens. This includes
796      * minting and burning.
797      *
798      * Calling conditions:
799      *
800      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
801      * will be transferred to `to`.
802      * - when `from` is zero, `amount` tokens will be minted for `to`.
803      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
804      * - `from` and `to` are never both zero.
805      *
806      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
807      */
808     function _beforeTokenTransfer(
809         address from,
810         address to,
811         uint256 amount
812     ) internal virtual {}
813 
814     /**
815      * @dev Hook that is called after any transfer of tokens. This includes
816      * minting and burning.
817      *
818      * Calling conditions:
819      *
820      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
821      * has been transferred to `to`.
822      * - when `from` is zero, `amount` tokens have been minted for `to`.
823      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
824      * - `from` and `to` are never both zero.
825      *
826      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
827      */
828     function _afterTokenTransfer(
829         address from,
830         address to,
831         uint256 amount
832     ) internal virtual {}
833 }
834 
835 
836 // File contracts/interfaces/IUniswapV2Pair.sol
837 
838 interface IUniswapV2Pair {
839     event Approval(address indexed owner, address indexed spender, uint value);
840     event Transfer(address indexed from, address indexed to, uint value);
841 
842     function name() external pure returns (string memory);
843     function symbol() external pure returns (string memory);
844     function decimals() external pure returns (uint8);
845     function totalSupply() external view returns (uint);
846     function balanceOf(address owner) external view returns (uint);
847     function allowance(address owner, address spender) external view returns (uint);
848 
849     function approve(address spender, uint value) external returns (bool);
850     function transfer(address to, uint value) external returns (bool);
851     function transferFrom(address from, address to, uint value) external returns (bool);
852 
853     function DOMAIN_SEPARATOR() external view returns (bytes32);
854     function PERMIT_TYPEHASH() external pure returns (bytes32);
855     function nonces(address owner) external view returns (uint);
856 
857     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
858 
859     event Mint(address indexed sender, uint amount0, uint amount1);
860     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
861     event Swap(
862         address indexed sender,
863         uint amount0In,
864         uint amount1In,
865         uint amount0Out,
866         uint amount1Out,
867         address indexed to
868     );
869     event Sync(uint112 reserve0, uint112 reserve1);
870 
871     function MINIMUM_LIQUIDITY() external pure returns (uint);
872     function factory() external view returns (address);
873     function token0() external view returns (address);
874     function token1() external view returns (address);
875     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
876     function price0CumulativeLast() external view returns (uint);
877     function price1CumulativeLast() external view returns (uint);
878     function kLast() external view returns (uint);
879 
880     function mint(address to) external returns (uint liquidity);
881     function burn(address to) external returns (uint amount0, uint amount1);
882     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
883     function skim(address to) external;
884     function sync() external;
885 
886     function initialize(address, address) external;
887 }
888 
889 
890 // File contracts/interfaces/IUniswapV2Factory.sol
891 
892 interface IUniswapV2Factory {
893     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
894 
895     function feeTo() external view returns (address);
896     function feeToSetter() external view returns (address);
897 
898     function getPair(address tokenA, address tokenB) external view returns (address pair);
899     function allPairs(uint) external view returns (address pair);
900     function allPairsLength() external view returns (uint);
901 
902     function createPair(address tokenA, address tokenB) external returns (address pair);
903 
904     function setFeeTo(address) external;
905     function setFeeToSetter(address) external;
906 }
907 
908 
909 // File contracts/interfaces/IUniswapV2Router02.sol
910 
911 
912 interface IUniswapV2Router01 {
913     function factory() external pure returns (address);
914     function WETH() external pure returns (address);
915 
916     function addLiquidity(
917         address tokenA,
918         address tokenB,
919         uint amountADesired,
920         uint amountBDesired,
921         uint amountAMin,
922         uint amountBMin,
923         address to,
924         uint deadline
925     ) external returns (uint amountA, uint amountB, uint liquidity);
926     function addLiquidityETH(
927         address token,
928         uint amountTokenDesired,
929         uint amountTokenMin,
930         uint amountETHMin,
931         address to,
932         uint deadline
933     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
934     function removeLiquidity(
935         address tokenA,
936         address tokenB,
937         uint liquidity,
938         uint amountAMin,
939         uint amountBMin,
940         address to,
941         uint deadline
942     ) external returns (uint amountA, uint amountB);
943     function removeLiquidityETH(
944         address token,
945         uint liquidity,
946         uint amountTokenMin,
947         uint amountETHMin,
948         address to,
949         uint deadline
950     ) external returns (uint amountToken, uint amountETH);
951     function removeLiquidityWithPermit(
952         address tokenA,
953         address tokenB,
954         uint liquidity,
955         uint amountAMin,
956         uint amountBMin,
957         address to,
958         uint deadline,
959         bool approveMax, uint8 v, bytes32 r, bytes32 s
960     ) external returns (uint amountA, uint amountB);
961     function removeLiquidityETHWithPermit(
962         address token,
963         uint liquidity,
964         uint amountTokenMin,
965         uint amountETHMin,
966         address to,
967         uint deadline,
968         bool approveMax, uint8 v, bytes32 r, bytes32 s
969     ) external returns (uint amountToken, uint amountETH);
970     function swapExactTokensForTokens(
971         uint amountIn,
972         uint amountOutMin,
973         address[] calldata path,
974         address to,
975         uint deadline
976     ) external returns (uint[] memory amounts);
977     function swapTokensForExactTokens(
978         uint amountOut,
979         uint amountInMax,
980         address[] calldata path,
981         address to,
982         uint deadline
983     ) external returns (uint[] memory amounts);
984     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
985         external
986         payable
987         returns (uint[] memory amounts);
988     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
989         external
990         returns (uint[] memory amounts);
991     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
992         external
993         returns (uint[] memory amounts);
994     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
995         external
996         payable
997         returns (uint[] memory amounts);
998 
999     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1000     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1001     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1002     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1003     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1004 }
1005 
1006 interface IUniswapV2Router02 is IUniswapV2Router01 {
1007     function removeLiquidityETHSupportingFeeOnTransferTokens(
1008         address token,
1009         uint liquidity,
1010         uint amountTokenMin,
1011         uint amountETHMin,
1012         address to,
1013         uint deadline
1014     ) external returns (uint amountETH);
1015     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1016         address token,
1017         uint liquidity,
1018         uint amountTokenMin,
1019         uint amountETHMin,
1020         address to,
1021         uint deadline,
1022         bool approveMax, uint8 v, bytes32 r, bytes32 s
1023     ) external returns (uint amountETH);
1024 
1025     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1026         uint amountIn,
1027         uint amountOutMin,
1028         address[] calldata path,
1029         address to,
1030         uint deadline
1031     ) external;
1032     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1033         uint amountOutMin,
1034         address[] calldata path,
1035         address to,
1036         uint deadline
1037     ) external payable;
1038     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1039         uint amountIn,
1040         uint amountOutMin,
1041         address[] calldata path,
1042         address to,
1043         uint deadline
1044     ) external;
1045 }
1046 
1047 
1048 // File contracts/HRI.sol
1049 
1050 contract HeroInfinityToken is ERC20, Ownable {
1051   using SafeMath for uint256;
1052 
1053   IUniswapV2Router02 public uniswapV2Router;
1054   address public uniswapV2Pair;
1055 
1056   bool private swapping;
1057 
1058   uint256 public launchTime;
1059 
1060   address public marketingWallet;
1061   address public devWallet;
1062   address public liquidityWallet;
1063 
1064   uint256 public maxTransactionAmount;
1065   uint256 public swapTokensAtAmount;
1066   uint256 public maxWallet;
1067 
1068   bool public limitsInEffect = true;
1069   bool public tradingActive = false;
1070   bool public swapEnabled = false;
1071 
1072   bool private gasLimitActive = true;
1073   uint256 private gasPriceLimit = 561 * 1 gwei; // do not allow over x gwei for launch
1074 
1075   // Anti-bot and anti-whale mappings and variables
1076   mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1077 
1078   mapping(address => uint256) presaleAmount; // Presale vesting
1079   uint256 airdropThreshold;
1080 
1081   bool public transferDelayEnabled = true;
1082 
1083   uint256 public buyTotalFees;
1084   uint256 public buyMarketingFee;
1085   uint256 public buyLiquidityFee;
1086   uint256 public buyDevFee;
1087 
1088   uint256 public sellTotalFees;
1089   uint256 public sellMarketingFee;
1090   uint256 public sellLiquidityFee;
1091   uint256 public sellDevFee;
1092 
1093   uint256 public tokensForMarketing;
1094   uint256 public tokensForLiquidity;
1095   uint256 public tokensForDev;
1096 
1097   /******************/
1098 
1099   // exlcude from fees and max transaction amount
1100   mapping(address => bool) private _isExcludedFromFees;
1101   mapping(address => bool) public _isExcludedMaxTransactionAmount;
1102 
1103   // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1104   // could be subject to a maximum transfer amount
1105   mapping(address => bool) public automatedMarketMakerPairs;
1106 
1107   event UpdateUniswapV2Router(
1108     address indexed newAddress,
1109     address indexed oldAddress
1110   );
1111 
1112   event ExcludeFromFees(address indexed account, bool isExcluded);
1113 
1114   event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1115 
1116   event MarketingWalletUpdated(
1117     address indexed newWallet,
1118     address indexed oldWallet
1119   );
1120 
1121   event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1122 
1123   event LiquidityWalletUpdated(
1124     address indexed newWallet,
1125     address indexed oldWallet
1126   );
1127 
1128   event SwapAndLiquify(
1129     uint256 tokensSwapped,
1130     uint256 ethReceived,
1131     uint256 tokensIntoLiquidity
1132   );
1133 
1134   event OwnerForcedSwapBack(uint256 timestamp);
1135 
1136   constructor() ERC20("HeroInfinity Token", "HRI") {}
1137 
1138   function airdropAndLaunch(
1139     address newOwner,
1140     address router,
1141     uint256 liquidityAmount,
1142     uint256 airdropAmount,
1143     uint256 dailyThreshold,
1144     address[] memory airdropUsers,
1145     uint256[] memory airdropAmounts
1146   ) external payable onlyOwner {
1147     require(!tradingActive, "Trading is already enabled");
1148     require(airdropUsers.length == airdropAmounts.length, "Invalid arguments");
1149 
1150     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
1151 
1152     excludeFromMaxTransaction(address(_uniswapV2Router), true);
1153     uniswapV2Router = _uniswapV2Router;
1154 
1155     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
1156       address(this),
1157       _uniswapV2Router.WETH()
1158     );
1159     excludeFromMaxTransaction(address(uniswapV2Pair), true);
1160     _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1161 
1162     uint256 _buyMarketingFee = 6;
1163     uint256 _buyLiquidityFee = 4;
1164     uint256 _buyDevFee = 2;
1165 
1166     uint256 _sellMarketingFee = 8;
1167     uint256 _sellLiquidityFee = 14;
1168     uint256 _sellDevFee = 3;
1169 
1170     uint256 _totalSupply = 1 * 1e9 * 1e18;
1171 
1172     require(dailyThreshold * 1e18 > (_totalSupply * 5) / 10000); // at least 0.05% release to presalers per day
1173     airdropThreshold = dailyThreshold;
1174 
1175     maxTransactionAmount = (_totalSupply * 30) / 10000; // 0.3% maxTransactionAmountTxn
1176     maxWallet = (_totalSupply * 100) / 10000; // 1% maxWallet
1177     swapTokensAtAmount = (_totalSupply * 5) / 10000; // 0.05% swap wallet
1178 
1179     buyMarketingFee = _buyMarketingFee;
1180     buyLiquidityFee = _buyLiquidityFee;
1181     buyDevFee = _buyDevFee;
1182     buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1183 
1184     sellMarketingFee = _sellMarketingFee;
1185     sellLiquidityFee = _sellLiquidityFee;
1186     sellDevFee = _sellDevFee;
1187     sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1188 
1189     marketingWallet = newOwner;
1190     devWallet = newOwner;
1191     liquidityWallet = newOwner;
1192 
1193     // exclude from paying fees or having max transaction amount
1194     excludeFromFees(owner(), true);
1195     excludeFromFees(newOwner, true);
1196     excludeFromFees(address(this), true);
1197     excludeFromFees(address(0xdead), true);
1198 
1199     excludeFromMaxTransaction(owner(), true);
1200     excludeFromMaxTransaction(newOwner, true);
1201     excludeFromMaxTransaction(address(this), true);
1202     excludeFromMaxTransaction(address(0xdead), true);
1203 
1204     _mint(address(this), liquidityAmount * 1e18);
1205     _mint(newOwner, _totalSupply - liquidityAmount * 1e18);
1206 
1207     // Add liquidity
1208     addLiquidity(liquidityAmount * 1e18, msg.value);
1209 
1210     uint256 totalAirdrops;
1211 
1212     //For airdrop, exclude temporary
1213     excludeFromFees(address(uniswapV2Pair), true);
1214     limitsInEffect = false;
1215 
1216     for (uint256 i; i < airdropUsers.length; ++i) {
1217       uint256 amount = airdropAmounts[i] * 1e18;
1218       address to = airdropUsers[i];
1219       require(presaleAmount[to] == 0, "airdrop duplicated");
1220 
1221       totalAirdrops += amount;
1222       _transfer(uniswapV2Pair, to, amount);
1223       presaleAmount[to] = amount;
1224     }
1225 
1226     excludeFromFees(address(uniswapV2Pair), false);
1227     limitsInEffect = true;
1228 
1229     require(totalAirdrops == airdropAmount * 1e18, "Wrong airdrop amount");
1230 
1231     IUniswapV2Pair pairInstance = IUniswapV2Pair(uniswapV2Pair);
1232     pairInstance.sync();
1233 
1234     enableTrading();
1235   }
1236 
1237   function name() public view virtual override returns (string memory) {
1238     require(tradingActive);
1239     return super.name();
1240   }
1241 
1242   function symbol() public view virtual override returns (string memory) {
1243     require(tradingActive);
1244     return super.symbol();
1245   }
1246 
1247   function decimals() public view virtual override returns (uint8) {
1248     return super.decimals();
1249   }
1250 
1251   function totalSupply() public view virtual override returns (uint256) {
1252     return super.totalSupply();
1253   }
1254 
1255   receive() external payable {}
1256 
1257   // once enabled, can never be turned off
1258   function enableTrading() private {
1259     require(!tradingActive, "Trading is already enabled");
1260     tradingActive = true;
1261     swapEnabled = true;
1262     launchTime = block.timestamp;
1263   }
1264 
1265   // remove limits after token is stable
1266   function removeLimits() external onlyOwner returns (bool) {
1267     limitsInEffect = false;
1268     gasLimitActive = false;
1269     transferDelayEnabled = false;
1270     return true;
1271   }
1272 
1273   // disable Transfer delay - cannot be reenabled
1274   function disableTransferDelay() external onlyOwner returns (bool) {
1275     transferDelayEnabled = false;
1276     return true;
1277   }
1278 
1279   // change the minimum amount of tokens to sell from fees
1280   function updateSwapTokensAtAmount(uint256 newAmount)
1281     external
1282     onlyOwner
1283     returns (bool)
1284   {
1285     require(
1286       newAmount >= (totalSupply() * 1) / 100000,
1287       "Swap amount cannot be lower than 0.001% total supply."
1288     );
1289     require(
1290       newAmount <= (totalSupply() * 5) / 1000,
1291       "Swap amount cannot be higher than 0.5% total supply."
1292     );
1293     swapTokensAtAmount = newAmount;
1294     return true;
1295   }
1296 
1297   function updateMaxAmount(uint256 newNum) external onlyOwner {
1298     require(
1299       newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1300       "Cannot set maxTransactionAmount lower than 0.5%"
1301     );
1302     maxTransactionAmount = newNum * (10**18);
1303   }
1304 
1305   function excludeFromMaxTransaction(address updAds, bool isEx)
1306     public
1307     onlyOwner
1308   {
1309     _isExcludedMaxTransactionAmount[updAds] = isEx;
1310   }
1311 
1312   // only use to disable contract sales if absolutely necessary (emergency use only)
1313   function updateSwapEnabled(bool enabled) external onlyOwner {
1314     swapEnabled = enabled;
1315   }
1316 
1317   function updateBuyFees(
1318     uint256 _marketingFee,
1319     uint256 _liquidityFee,
1320     uint256 _devFee
1321   ) external onlyOwner {
1322     buyMarketingFee = _marketingFee;
1323     buyLiquidityFee = _liquidityFee;
1324     buyDevFee = _devFee;
1325     buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1326 
1327     require(buyTotalFees <= 25, "Cannot set buy fee more than 25%");
1328   }
1329 
1330   function updateSellFees(
1331     uint256 _marketingFee,
1332     uint256 _liquidityFee,
1333     uint256 _devFee
1334   ) external onlyOwner {
1335     sellMarketingFee = _marketingFee;
1336     sellLiquidityFee = _liquidityFee;
1337     sellDevFee = _devFee;
1338     sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1339 
1340     require(sellTotalFees <= 25, "Cannot set sell fee more than 25%");
1341   }
1342 
1343   function excludeFromFees(address account, bool excluded) public onlyOwner {
1344     _isExcludedFromFees[account] = excluded;
1345     emit ExcludeFromFees(account, excluded);
1346   }
1347 
1348   function setAutomatedMarketMakerPair(address pair, bool value)
1349     public
1350     onlyOwner
1351   {
1352     require(
1353       pair != uniswapV2Pair,
1354       "The pair cannot be removed from automatedMarketMakerPairs"
1355     );
1356 
1357     _setAutomatedMarketMakerPair(pair, value);
1358   }
1359 
1360   function _setAutomatedMarketMakerPair(address pair, bool value) private {
1361     automatedMarketMakerPairs[pair] = value;
1362 
1363     emit SetAutomatedMarketMakerPair(pair, value);
1364   }
1365 
1366   function updateMarketingWallet(address newMarketingWallet)
1367     external
1368     onlyOwner
1369   {
1370     emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
1371     marketingWallet = newMarketingWallet;
1372   }
1373 
1374   function updateDevWallet(address newDevWallet) external onlyOwner {
1375     emit DevWalletUpdated(newDevWallet, devWallet);
1376     devWallet = newDevWallet;
1377   }
1378 
1379   function updateliquidityWallet(address newWallet) external onlyOwner {
1380     emit LiquidityWalletUpdated(newWallet, liquidityWallet);
1381     liquidityWallet = newWallet;
1382   }
1383 
1384   function isExcludedFromFees(address account) public view returns (bool) {
1385     return _isExcludedFromFees[account];
1386   }
1387 
1388   function checkVesting(address from) private {
1389     if (presaleAmount[from] == 0) {
1390       return;
1391     }
1392     uint256 daysPassed = (block.timestamp - launchTime) / 1 days;
1393     uint256 unlockedAmount = daysPassed * airdropThreshold * 1e18;
1394     if (unlockedAmount > presaleAmount[from]) {
1395       presaleAmount[from] = 0;
1396       return;
1397     }
1398     require(
1399       balanceOf(from) >= presaleAmount[from] - unlockedAmount,
1400       "Vesting period is not ended yet"
1401     );
1402   }
1403 
1404   function _transfer(
1405     address from,
1406     address to,
1407     uint256 amount
1408   ) internal override {
1409     require(from != address(0), "ERC20: transfer from the zero address");
1410     require(to != address(0), "ERC20: transfer to the zero address");
1411 
1412     if (amount == 0) {
1413       super._transfer(from, to, 0);
1414       return;
1415     }
1416 
1417     if (limitsInEffect) {
1418       if (
1419         from != owner() &&
1420         to != owner() &&
1421         to != address(0) &&
1422         to != address(0xdead) &&
1423         !swapping
1424       ) {
1425         if (!tradingActive) {
1426           require(
1427             _isExcludedFromFees[from] || _isExcludedFromFees[to],
1428             "Trading is not active."
1429           );
1430         }
1431 
1432         // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1433         if (transferDelayEnabled) {
1434           if (
1435             to != owner() &&
1436             to != address(uniswapV2Router) &&
1437             to != address(uniswapV2Pair)
1438           ) {
1439             require(
1440               _holderLastTransferTimestamp[tx.origin] < block.number,
1441               "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1442             );
1443             _holderLastTransferTimestamp[tx.origin] = block.number;
1444           }
1445         }
1446 
1447         //when buy
1448         if (
1449           automatedMarketMakerPairs[from] &&
1450           !_isExcludedMaxTransactionAmount[to]
1451         ) {
1452           require(
1453             amount <= maxTransactionAmount,
1454             "Buy transfer amount exceeds the maxTransactionAmount."
1455           );
1456           require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1457         }
1458         //when sell
1459         else if (
1460           automatedMarketMakerPairs[to] &&
1461           !_isExcludedMaxTransactionAmount[from]
1462         ) {
1463           require(
1464             amount <= maxTransactionAmount,
1465             "Sell transfer amount exceeds the maxTransactionAmount."
1466           );
1467         } else if (!_isExcludedMaxTransactionAmount[to]) {
1468           require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1469         }
1470       }
1471     }
1472 
1473     uint256 contractTokenBalance = balanceOf(address(this));
1474 
1475     bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1476 
1477     if (
1478       canSwap &&
1479       swapEnabled &&
1480       !swapping &&
1481       !automatedMarketMakerPairs[from] &&
1482       !_isExcludedFromFees[from] &&
1483       !_isExcludedFromFees[to]
1484     ) {
1485       swapping = true;
1486 
1487       swapBack();
1488 
1489       swapping = false;
1490     }
1491 
1492     bool takeFee = !swapping;
1493 
1494     // if any account belongs to _isExcludedFromFee account then remove the fee
1495     if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1496       takeFee = false;
1497     }
1498 
1499     uint256 fees = 0;
1500     // only take fees on buys/sells, do not take on wallet transfers
1501     if (takeFee) {
1502       // on sell
1503       if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1504         fees = amount.mul(sellTotalFees).div(100);
1505         tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1506         tokensForDev += (fees * sellDevFee) / sellTotalFees;
1507         tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1508       }
1509       // on buy
1510       else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1511         fees = amount.mul(buyTotalFees).div(100);
1512         tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1513         tokensForDev += (fees * buyDevFee) / buyTotalFees;
1514         tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1515       }
1516 
1517       if (fees > 0) {
1518         super._transfer(from, address(this), fees);
1519       }
1520 
1521       amount -= fees;
1522     }
1523     super._transfer(from, to, amount);
1524 
1525     checkVesting(from);
1526   }
1527 
1528   function swapTokensForEth(uint256 tokenAmount) private {
1529     // generate the uniswap pair path of token -> weth
1530     address[] memory path = new address[](2);
1531     path[0] = address(this);
1532     path[1] = uniswapV2Router.WETH();
1533 
1534     _approve(address(this), address(uniswapV2Router), tokenAmount);
1535 
1536     // make the swap
1537     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1538       tokenAmount,
1539       0, // accept any amount of ETH
1540       path,
1541       address(this),
1542       block.timestamp
1543     );
1544   }
1545 
1546   function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1547     // approve token transfer to cover all possible scenarios
1548     _approve(address(this), address(uniswapV2Router), tokenAmount);
1549     // add the liquidity
1550     uniswapV2Router.addLiquidityETH{ value: ethAmount }(
1551       address(this),
1552       tokenAmount,
1553       0, // slippage is unavoidable
1554       0, // slippage is unavoidable
1555       liquidityWallet,
1556       block.timestamp
1557     );
1558   }
1559 
1560   function swapBack() private {
1561     uint256 contractBalance = balanceOf(address(this));
1562     uint256 totalTokensToSwap = tokensForLiquidity +
1563       tokensForMarketing +
1564       tokensForDev;
1565 
1566     if (contractBalance == 0 || totalTokensToSwap == 0) {
1567       return;
1568     }
1569 
1570     // Halve the amount of liquidity tokens
1571     uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1572       totalTokensToSwap /
1573       2;
1574     uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1575 
1576     uint256 initialETHBalance = address(this).balance;
1577 
1578     swapTokensForEth(amountToSwapForETH);
1579 
1580     uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1581 
1582     uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1583       totalTokensToSwap
1584     );
1585     uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1586 
1587     uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1588 
1589     tokensForLiquidity = 0;
1590     tokensForMarketing = 0;
1591     tokensForDev = 0;
1592 
1593     (bool success, ) = address(marketingWallet).call{ value: ethForMarketing }(
1594       ""
1595     );
1596     (success, ) = address(devWallet).call{ value: ethForDev }("");
1597 
1598     if (liquidityTokens > 0 && ethForLiquidity > 0) {
1599       addLiquidity(liquidityTokens, ethForLiquidity);
1600       emit SwapAndLiquify(
1601         amountToSwapForETH,
1602         ethForLiquidity,
1603         tokensForLiquidity
1604       );
1605     }
1606 
1607     if (address(this).balance >= 1 ether) {
1608       (success, ) = address(marketingWallet).call{
1609         value: address(this).balance
1610       }("");
1611     }
1612   }
1613 
1614   // force Swap back if slippage above 49% for launch. fix router clog
1615   function forceSwapBack() external onlyOwner {
1616     uint256 contractBalance = balanceOf(address(this));
1617     require(
1618       contractBalance >= totalSupply() / 100,
1619       "Can only swap back if more than 1% of tokens stuck on contract"
1620     );
1621     swapBack();
1622     emit OwnerForcedSwapBack(block.timestamp);
1623   }
1624 
1625   function withdrawDustToken(address _token, address _to)
1626     external
1627     onlyOwner
1628     returns (bool _sent)
1629   {
1630     uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1631     _sent = IERC20(_token).transfer(_to, _contractBalance);
1632   }
1633 
1634   function withdrawDustETH(address _recipient) external onlyOwner {
1635     uint256 contractETHBalance = address(this).balance;
1636     (bool success, ) = _recipient.call{ value: contractETHBalance }("");
1637     require(
1638       success,
1639       "Address: unable to send value, recipient may have reverted"
1640     );
1641   }
1642 }