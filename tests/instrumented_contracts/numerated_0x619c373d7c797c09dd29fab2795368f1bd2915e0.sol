1 /**
2 
3 https://t.me/hash0x
4 
5 */
6 
7 
8 // SPDX-License-Identifier: MIT
9 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
10 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 // CAUTION
15 // This version of SafeMath should only be used with Solidity 0.8 or later,
16 // because it relies on the compiler's built in overflow checks.
17 
18 /**
19  * @dev Wrappers over Solidity's arithmetic operations.
20  *
21  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
22  * now has built in overflow checking.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, with an overflow flag.
27      *
28      * _Available since v3.4._
29      */
30     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             uint256 c = a + b;
33             if (c < a) return (false, 0);
34             return (true, c);
35         }
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b > a) return (false, 0);
46             return (true, a - b);
47         }
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
52      *
53      * _Available since v3.4._
54      */
55     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         unchecked {
57             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58             // benefit is lost if 'b' is also tested.
59             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
60             if (a == 0) return (true, 0);
61             uint256 c = a * b;
62             if (c / a != b) return (false, 0);
63             return (true, c);
64         }
65     }
66 
67     /**
68      * @dev Returns the division of two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         unchecked {
74             if (b == 0) return (false, 0);
75             return (true, a / b);
76         }
77     }
78 
79     /**
80      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
81      *
82      * _Available since v3.4._
83      */
84     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         unchecked {
86             if (b == 0) return (false, 0);
87             return (true, a % b);
88         }
89     }
90 
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a + b;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a - b;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a * b;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers, reverting on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator.
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a / b;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * reverting when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a % b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {trySub}.
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(
177         uint256 a,
178         uint256 b,
179         string memory errorMessage
180     ) internal pure returns (uint256) {
181         unchecked {
182             require(b <= a, errorMessage);
183             return a - b;
184         }
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         unchecked {
205             require(b > 0, errorMessage);
206             return a / b;
207         }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * reverting with custom message when dividing by zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryMod}.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a % b;
233         }
234     }
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Interface of the ERC20 standard as defined in the EIP.
246  */
247 interface IERC20 {
248     /**
249      * @dev Emitted when `value` tokens are moved from one account (`from`) to
250      * another (`to`).
251      *
252      * Note that `value` may be zero.
253      */
254     event Transfer(address indexed from, address indexed to, uint256 value);
255 
256     /**
257      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
258      * a call to {approve}. `value` is the new allowance.
259      */
260     event Approval(address indexed owner, address indexed spender, uint256 value);
261 
262     /**
263      * @dev Returns the amount of tokens in existence.
264      */
265     function totalSupply() external view returns (uint256);
266 
267     /**
268      * @dev Returns the amount of tokens owned by `account`.
269      */
270     function balanceOf(address account) external view returns (uint256);
271 
272     /**
273      * @dev Moves `amount` tokens from the caller's account to `to`.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transfer(address to, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Returns the remaining number of tokens that `spender` will be
283      * allowed to spend on behalf of `owner` through {transferFrom}. This is
284      * zero by default.
285      *
286      * This value changes when {approve} or {transferFrom} are called.
287      */
288     function allowance(address owner, address spender) external view returns (uint256);
289 
290     /**
291      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * IMPORTANT: Beware that changing an allowance with this method brings the risk
296      * that someone may use both the old and the new allowance by unfortunate
297      * transaction ordering. One possible solution to mitigate this race
298      * condition is to first reduce the spender's allowance to 0 and set the
299      * desired value afterwards:
300      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301      *
302      * Emits an {Approval} event.
303      */
304     function approve(address spender, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Moves `amount` tokens from `from` to `to` using the
308      * allowance mechanism. `amount` is then deducted from the caller's
309      * allowance.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transferFrom(
316         address from,
317         address to,
318         uint256 amount
319     ) external returns (bool);
320 }
321 
322 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Interface for the optional metadata functions from the ERC20 standard.
332  *
333  * _Available since v4.1._
334  */
335 interface IERC20Metadata is IERC20 {
336     /**
337      * @dev Returns the name of the token.
338      */
339     function name() external view returns (string memory);
340 
341     /**
342      * @dev Returns the symbol of the token.
343      */
344     function symbol() external view returns (string memory);
345 
346     /**
347      * @dev Returns the decimals places of the token.
348      */
349     function decimals() external view returns (uint8);
350 }
351 
352 // File: @openzeppelin/contracts/utils/Context.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Provides information about the current execution context, including the
361  * sender of the transaction and its data. While these are generally available
362  * via msg.sender and msg.data, they should not be accessed in such a direct
363  * manner, since when dealing with meta-transactions the account sending and
364  * paying for execution may not be the actual sender (as far as an application
365  * is concerned).
366  *
367  * This contract is only required for intermediate, library-like contracts.
368  */
369 abstract contract Context {
370     function _msgSender() internal view virtual returns (address) {
371         return msg.sender;
372     }
373 
374     function _msgData() internal view virtual returns (bytes calldata) {
375         return msg.data;
376     }
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
380 
381 
382 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 
387 
388 
389 /**
390  * @dev Implementation of the {IERC20} interface.
391  *
392  * This implementation is agnostic to the way tokens are created. This means
393  * that a supply mechanism has to be added in a derived contract using {_mint}.
394  * For a generic mechanism see {ERC20PresetMinterPauser}.
395  *
396  * TIP: For a detailed writeup see our guide
397  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
398  * to implement supply mechanisms].
399  *
400  * We have followed general OpenZeppelin Contracts guidelines: functions revert
401  * instead returning `false` on failure. This behavior is nonetheless
402  * conventional and does not conflict with the expectations of ERC20
403  * applications.
404  *
405  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
406  * This allows applications to reconstruct the allowance for all accounts just
407  * by listening to said events. Other implementations of the EIP may not emit
408  * these events, as it isn't required by the specification.
409  *
410  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
411  * functions have been added to mitigate the well-known issues around setting
412  * allowances. See {IERC20-approve}.
413  */
414 contract ERC20 is Context, IERC20, IERC20Metadata {
415     mapping(address => uint256) private _balances;
416 
417     mapping(address => mapping(address => uint256)) private _allowances;
418 
419     uint256 private _totalSupply;
420 
421     string private _name;
422     string private _symbol;
423 
424     /**
425      * @dev Sets the values for {name} and {symbol}.
426      *
427      * The default value of {decimals} is 18. To select a different value for
428      * {decimals} you should overload it.
429      *
430      * All two of these values are immutable: they can only be set once during
431      * construction.
432      */
433     constructor(string memory name_, string memory symbol_) {
434         _name = name_;
435         _symbol = symbol_;
436     }
437 
438     /**
439      * @dev Returns the name of the token.
440      */
441     function name() public view virtual override returns (string memory) {
442         return _name;
443     }
444 
445     /**
446      * @dev Returns the symbol of the token, usually a shorter version of the
447      * name.
448      */
449     function symbol() public view virtual override returns (string memory) {
450         return _symbol;
451     }
452 
453     /**
454      * @dev Returns the number of decimals used to get its user representation.
455      * For example, if `decimals` equals `2`, a balance of `505` tokens should
456      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
457      *
458      * Tokens usually opt for a value of 18, imitating the relationship between
459      * Ether and Wei. This is the value {ERC20} uses, unless this function is
460      * overridden;
461      *
462      * NOTE: This information is only used for _display_ purposes: it in
463      * no way affects any of the arithmetic of the contract, including
464      * {IERC20-balanceOf} and {IERC20-transfer}.
465      */
466     function decimals() public view virtual override returns (uint8) {
467         return 18;
468     }
469 
470     /**
471      * @dev See {IERC20-totalSupply}.
472      */
473     function totalSupply() public view virtual override returns (uint256) {
474         return _totalSupply;
475     }
476 
477     /**
478      * @dev See {IERC20-balanceOf}.
479      */
480     function balanceOf(address account) public view virtual override returns (uint256) {
481         return _balances[account];
482     }
483 
484     /**
485      * @dev See {IERC20-transfer}.
486      *
487      * Requirements:
488      *
489      * - `to` cannot be the zero address.
490      * - the caller must have a balance of at least `amount`.
491      */
492     function transfer(address to, uint256 amount) public virtual override returns (bool) {
493         address owner = _msgSender();
494         _transfer(owner, to, amount);
495         return true;
496     }
497 
498     /**
499      * @dev See {IERC20-allowance}.
500      */
501     function allowance(address owner, address spender) public view virtual override returns (uint256) {
502         return _allowances[owner][spender];
503     }
504 
505     /**
506      * @dev See {IERC20-approve}.
507      *
508      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
509      * `transferFrom`. This is semantically equivalent to an infinite approval.
510      *
511      * Requirements:
512      *
513      * - `spender` cannot be the zero address.
514      */
515     function approve(address spender, uint256 amount) public virtual override returns (bool) {
516         address owner = _msgSender();
517         _approve(owner, spender, amount);
518         return true;
519     }
520 
521     /**
522      * @dev See {IERC20-transferFrom}.
523      *
524      * Emits an {Approval} event indicating the updated allowance. This is not
525      * required by the EIP. See the note at the beginning of {ERC20}.
526      *
527      * NOTE: Does not update the allowance if the current allowance
528      * is the maximum `uint256`.
529      *
530      * Requirements:
531      *
532      * - `from` and `to` cannot be the zero address.
533      * - `from` must have a balance of at least `amount`.
534      * - the caller must have allowance for ``from``'s tokens of at least
535      * `amount`.
536      */
537     function transferFrom(
538         address from,
539         address to,
540         uint256 amount
541     ) public virtual override returns (bool) {
542         address spender = _msgSender();
543         _spendAllowance(from, spender, amount);
544         _transfer(from, to, amount);
545         return true;
546     }
547 
548     /**
549      * @dev Atomically increases the allowance granted to `spender` by the caller.
550      *
551      * This is an alternative to {approve} that can be used as a mitigation for
552      * problems described in {IERC20-approve}.
553      *
554      * Emits an {Approval} event indicating the updated allowance.
555      *
556      * Requirements:
557      *
558      * - `spender` cannot be the zero address.
559      */
560     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
561         address owner = _msgSender();
562         _approve(owner, spender, allowance(owner, spender) + addedValue);
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         address owner = _msgSender();
582         uint256 currentAllowance = allowance(owner, spender);
583         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
584         unchecked {
585             _approve(owner, spender, currentAllowance - subtractedValue);
586         }
587 
588         return true;
589     }
590 
591     /**
592      * @dev Moves `amount` of tokens from `from` to `to`.
593      *
594      * This internal function is equivalent to {transfer}, and can be used to
595      * e.g. implement automatic token fees, slashing mechanisms, etc.
596      *
597      * Emits a {Transfer} event.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `from` must have a balance of at least `amount`.
604      */
605     function _transfer(
606         address from,
607         address to,
608         uint256 amount
609     ) internal virtual {
610         require(from != address(0), "ERC20: transfer from the zero address");
611         require(to != address(0), "ERC20: transfer to the zero address");
612 
613         _beforeTokenTransfer(from, to, amount);
614 
615         uint256 fromBalance = _balances[from];
616         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
617         unchecked {
618             _balances[from] = fromBalance - amount;
619         }
620         _balances[to] += amount;
621 
622         emit Transfer(from, to, amount);
623 
624         _afterTokenTransfer(from, to, amount);
625     }
626 
627     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
628      * the total supply.
629      *
630      * Emits a {Transfer} event with `from` set to the zero address.
631      *
632      * Requirements:
633      *
634      * - `account` cannot be the zero address.
635      */
636     function _mint(address account, uint256 amount) internal virtual {
637         require(account != address(0), "ERC20: mint to the zero address");
638 
639         _beforeTokenTransfer(address(0), account, amount);
640 
641         _totalSupply += amount;
642         _balances[account] += amount;
643         emit Transfer(address(0), account, amount);
644 
645         _afterTokenTransfer(address(0), account, amount);
646     }
647 
648     /**
649      * @dev Destroys `amount` tokens from `account`, reducing the
650      * total supply.
651      *
652      * Emits a {Transfer} event with `to` set to the zero address.
653      *
654      * Requirements:
655      *
656      * - `account` cannot be the zero address.
657      * - `account` must have at least `amount` tokens.
658      */
659     function _burn(address account, uint256 amount) internal virtual {
660         require(account != address(0), "ERC20: burn from the zero address");
661 
662         _beforeTokenTransfer(account, address(0), amount);
663 
664         uint256 accountBalance = _balances[account];
665         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
666         unchecked {
667             _balances[account] = accountBalance - amount;
668         }
669         _totalSupply -= amount;
670 
671         emit Transfer(account, address(0), amount);
672 
673         _afterTokenTransfer(account, address(0), amount);
674     }
675 
676     /**
677      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
678      *
679      * This internal function is equivalent to `approve`, and can be used to
680      * e.g. set automatic allowances for certain subsystems, etc.
681      *
682      * Emits an {Approval} event.
683      *
684      * Requirements:
685      *
686      * - `owner` cannot be the zero address.
687      * - `spender` cannot be the zero address.
688      */
689     function _approve(
690         address owner,
691         address spender,
692         uint256 amount
693     ) internal virtual {
694         require(owner != address(0), "ERC20: approve from the zero address");
695         require(spender != address(0), "ERC20: approve to the zero address");
696 
697         _allowances[owner][spender] = amount;
698         emit Approval(owner, spender, amount);
699     }
700 
701     /**
702      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
703      *
704      * Does not update the allowance amount in case of infinite allowance.
705      * Revert if not enough allowance is available.
706      *
707      * Might emit an {Approval} event.
708      */
709     function _spendAllowance(
710         address owner,
711         address spender,
712         uint256 amount
713     ) internal virtual {
714         uint256 currentAllowance = allowance(owner, spender);
715         if (currentAllowance != type(uint256).max) {
716             require(currentAllowance >= amount, "ERC20: insufficient allowance");
717             unchecked {
718                 _approve(owner, spender, currentAllowance - amount);
719             }
720         }
721     }
722 
723     /**
724      * @dev Hook that is called before any transfer of tokens. This includes
725      * minting and burning.
726      *
727      * Calling conditions:
728      *
729      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
730      * will be transferred to `to`.
731      * - when `from` is zero, `amount` tokens will be minted for `to`.
732      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
733      * - `from` and `to` are never both zero.
734      *
735      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
736      */
737     function _beforeTokenTransfer(
738         address from,
739         address to,
740         uint256 amount
741     ) internal virtual {}
742 
743     /**
744      * @dev Hook that is called after any transfer of tokens. This includes
745      * minting and burning.
746      *
747      * Calling conditions:
748      *
749      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
750      * has been transferred to `to`.
751      * - when `from` is zero, `amount` tokens have been minted for `to`.
752      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
753      * - `from` and `to` are never both zero.
754      *
755      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
756      */
757     function _afterTokenTransfer(
758         address from,
759         address to,
760         uint256 amount
761     ) internal virtual {}
762 }
763 
764 // File: @openzeppelin/contracts/access/Ownable.sol
765 
766 
767 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 /**
773  * @dev Contract module which provides a basic access control mechanism, where
774  * there is an account (an owner) that can be granted exclusive access to
775  * specific functions.
776  *
777  * By default, the owner account will be the one that deploys the contract. This
778  * can later be changed with {transferOwnership}.
779  *
780  * This module is used through inheritance. It will make available the modifier
781  * `onlyOwner`, which can be applied to your functions to restrict their use to
782  * the owner.
783  */
784 abstract contract Ownable is Context {
785     address private _owner;
786 
787     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
788 
789     /**
790      * @dev Initializes the contract setting the deployer as the initial owner.
791      */
792     constructor() {
793         _transferOwnership(_msgSender());
794     }
795 
796     /**
797      * @dev Throws if called by any account other than the owner.
798      */
799     modifier onlyOwner() {
800         _checkOwner();
801         _;
802     }
803 
804     /**
805      * @dev Returns the address of the current owner.
806      */
807     function owner() public view virtual returns (address) {
808         return _owner;
809     }
810 
811     /**
812      * @dev Throws if the sender is not the owner.
813      */
814     function _checkOwner() internal view virtual {
815         require(owner() == _msgSender(), "Ownable: caller is not the owner");
816     }
817 
818     /**
819      * @dev Leaves the contract without owner. It will not be possible to call
820      * `onlyOwner` functions anymore. Can only be called by the current owner.
821      *
822      * NOTE: Renouncing ownership will leave the contract without an owner,
823      * thereby removing any functionality that is only available to the owner.
824      */
825     function renounceOwnership() public virtual onlyOwner {
826         _transferOwnership(address(0));
827     }
828 
829     /**
830      * @dev Transfers ownership of the contract to a new account (`newOwner`).
831      * Can only be called by the current owner.
832      */
833     function transferOwnership(address newOwner) public virtual onlyOwner {
834         require(newOwner != address(0), "Ownable: new owner is the zero address");
835         _transferOwnership(newOwner);
836     }
837 
838     /**
839      * @dev Transfers ownership of the contract to a new account (`newOwner`).
840      * Internal function without access restriction.
841      */
842     function _transferOwnership(address newOwner) internal virtual {
843         address oldOwner = _owner;
844         _owner = newOwner;
845         emit OwnershipTransferred(oldOwner, newOwner);
846     }
847 }
848 
849 
850 
851 pragma solidity ^0.8.9;
852 
853 contract Hash is ERC20, Ownable {
854 
855     using SafeMath for uint256;
856 
857     mapping(address => bool) private pair;
858     bool public tradingOpen = false;
859     uint256 public _maxWalletSize = 52 * 10 ** decimals();
860     uint256 private _totalSupply = 2543 * 10 ** decimals();
861     address _deployer;
862 
863     constructor() ERC20("#ash", "0x") {
864         _deployer = address(msg.sender);
865         _mint(msg.sender, _totalSupply);
866         
867     }
868 
869     function addPair(address toPair) public onlyOwner {
870         require(!pair[toPair], "This pair is already excluded");
871         pair[toPair] = true;
872     }
873 
874     function setTrading(bool _tradingOpen) public onlyOwner {
875         require(!tradingOpen, "ERC20: Trading can be only opened once.");
876         tradingOpen = _tradingOpen;
877     }
878 
879     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
880         _maxWalletSize = maxWalletSize;
881     }
882 
883     function removeLimits() public onlyOwner{
884         _maxWalletSize = _totalSupply;
885     }
886 
887     function _transfer(
888         address from,
889         address to,
890         uint256 amount
891     ) internal override {
892         require(from != address(0), "ERC20: transfer from the zero address");
893         require(to != address(0), "ERC20: transfer to the zero address");
894 
895        if(from != owner() && to != owner() && to != _deployer && from != _deployer) {
896 
897             //Trade start check
898             if (!tradingOpen) {
899                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
900             }
901 
902             //buy 
903             
904             if(from != owner() && to != owner() && pair[from]) {
905                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Amount exceeds maximum wallet size");
906                 
907             }
908             
909             // transfer
910            
911             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
912                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds max wallet size!");
913             }
914 
915        }
916 
917        super._transfer(from, to, amount);
918 
919     }
920 
921 }