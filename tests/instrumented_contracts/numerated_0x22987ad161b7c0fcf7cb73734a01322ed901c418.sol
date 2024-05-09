1 /*
2 
3   [Website]         https://hpop1i.com/ 
4   [Twitter (x?)]    https://twitter.com/HPOP1I
5   [Telegram]        https://t.me/HPOP1I
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.0;
11 
12 // CAUTION
13 // This version of SafeMath should only be used with Solidity 0.8 or later,
14 // because it relies on the compiler's built in overflow checks.
15 
16 /**
17  * @dev Wrappers over Solidity's arithmetic operations.
18  *
19  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
20  * now has built in overflow checking.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             uint256 c = a + b;
31             if (c < a) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             if (b > a) return (false, 0);
44             return (true, a - b);
45         }
46     }
47 
48     /**
49      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56             // benefit is lost if 'b' is also tested.
57             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
58             if (a == 0) return (true, 0);
59             uint256 c = a * b;
60             if (c / a != b) return (false, 0);
61             return (true, c);
62         }
63     }
64 
65     /**
66      * @dev Returns the division of two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a / b);
74         }
75     }
76 
77     /**
78      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
79      *
80      * _Available since v3.4._
81      */
82     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         unchecked {
84             if (b == 0) return (false, 0);
85             return (true, a % b);
86         }
87     }
88 
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      *
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a + b;
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      *
111      * - Subtraction cannot overflow.
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a - b;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a * b;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers, reverting on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator.
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a / b;
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * reverting when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(
175         uint256 a,
176         uint256 b,
177         string memory errorMessage
178     ) internal pure returns (uint256) {
179         unchecked {
180             require(b <= a, errorMessage);
181             return a - b;
182         }
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(
198         uint256 a,
199         uint256 b,
200         string memory errorMessage
201     ) internal pure returns (uint256) {
202         unchecked {
203             require(b > 0, errorMessage);
204             return a / b;
205         }
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting with custom message when dividing by zero.
211      *
212      * CAUTION: This function is deprecated because it requires allocating memory for the error
213      * message unnecessarily. For custom revert reasons use {tryMod}.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         unchecked {
229             require(b > 0, errorMessage);
230             return a % b;
231         }
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Context.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Provides information about the current execution context, including the
244  * sender of the transaction and its data. While these are generally available
245  * via msg.sender and msg.data, they should not be accessed in such a direct
246  * manner, since when dealing with meta-transactions the account sending and
247  * paying for execution may not be the actual sender (as far as an application
248  * is concerned).
249  *
250  * This contract is only required for intermediate, library-like contracts.
251  */
252 abstract contract Context {
253     function _msgSender() internal view virtual returns (address) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view virtual returns (bytes calldata) {
258         return msg.data;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/access/Ownable.sol
263 
264 
265 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 
270 /**
271  * @dev Contract module which provides a basic access control mechanism, where
272  * there is an account (an owner) that can be granted exclusive access to
273  * specific functions.
274  *
275  * By default, the owner account will be the one that deploys the contract. This
276  * can later be changed with {transferOwnership}.
277  *
278  * This module is used through inheritance. It will make available the modifier
279  * `onlyOwner`, which can be applied to your functions to restrict their use to
280  * the owner.
281  */
282 abstract contract Ownable is Context {
283     address private _owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev Initializes the contract setting the deployer as the initial owner.
289      */
290     constructor() {
291         _transferOwnership(_msgSender());
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         _checkOwner();
299         _;
300     }
301 
302     /**
303      * @dev Returns the address of the current owner.
304      */
305     function owner() public view virtual returns (address) {
306         return _owner;
307     }
308 
309     /**
310      * @dev Throws if the sender is not the owner.
311      */
312     function _checkOwner() internal view virtual {
313         require(owner() == _msgSender(), "Ownable: caller is not the owner");
314     }
315 
316     /**
317      * @dev Leaves the contract without owner. It will not be possible to call
318      * `onlyOwner` functions anymore. Can only be called by the current owner.
319      *
320      * NOTE: Renouncing ownership will leave the contract without an owner,
321      * thereby removing any functionality that is only available to the owner.
322      */
323     function renounceOwnership() public virtual onlyOwner {
324         _transferOwnership(address(0));
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Can only be called by the current owner.
330      */
331     function transferOwnership(address newOwner) public virtual onlyOwner {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         _transferOwnership(newOwner);
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Internal function without access restriction.
339      */
340     function _transferOwnership(address newOwner) internal virtual {
341         address oldOwner = _owner;
342         _owner = newOwner;
343         emit OwnershipTransferred(oldOwner, newOwner);
344     }
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
348 
349 
350 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Interface of the ERC20 standard as defined in the EIP.
356  */
357 interface IERC20 {
358     /**
359      * @dev Emitted when `value` tokens are moved from one account (`from`) to
360      * another (`to`).
361      *
362      * Note that `value` may be zero.
363      */
364     event Transfer(address indexed from, address indexed to, uint256 value);
365 
366     /**
367      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
368      * a call to {approve}. `value` is the new allowance.
369      */
370     event Approval(address indexed owner, address indexed spender, uint256 value);
371 
372     /**
373      * @dev Returns the amount of tokens in existence.
374      */
375     function totalSupply() external view returns (uint256);
376 
377     /**
378      * @dev Returns the amount of tokens owned by `account`.
379      */
380     function balanceOf(address account) external view returns (uint256);
381 
382     /**
383      * @dev Moves `amount` tokens from the caller's account to `to`.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transfer(address to, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Returns the remaining number of tokens that `spender` will be
393      * allowed to spend on behalf of `owner` through {transferFrom}. This is
394      * zero by default.
395      *
396      * This value changes when {approve} or {transferFrom} are called.
397      */
398     function allowance(address owner, address spender) external view returns (uint256);
399 
400     /**
401      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * IMPORTANT: Beware that changing an allowance with this method brings the risk
406      * that someone may use both the old and the new allowance by unfortunate
407      * transaction ordering. One possible solution to mitigate this race
408      * condition is to first reduce the spender's allowance to 0 and set the
409      * desired value afterwards:
410      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
411      *
412      * Emits an {Approval} event.
413      */
414     function approve(address spender, uint256 amount) external returns (bool);
415 
416     /**
417      * @dev Moves `amount` tokens from `from` to `to` using the
418      * allowance mechanism. `amount` is then deducted from the caller's
419      * allowance.
420      *
421      * Returns a boolean value indicating whether the operation succeeded.
422      *
423      * Emits a {Transfer} event.
424      */
425     function transferFrom(
426         address from,
427         address to,
428         uint256 amount
429     ) external returns (bool);
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 
440 /**
441  * @dev Interface for the optional metadata functions from the ERC20 standard.
442  *
443  * _Available since v4.1._
444  */
445 interface IERC20Metadata is IERC20 {
446     /**
447      * @dev Returns the name of the token.
448      */
449     function name() external view returns (string memory);
450 
451     /**
452      * @dev Returns the symbol of the token.
453      */
454     function symbol() external view returns (string memory);
455 
456     /**
457      * @dev Returns the decimals places of the token.
458      */
459     function decimals() external view returns (uint8);
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 
471 
472 /**
473  * @dev Implementation of the {IERC20} interface.
474  *
475  * This implementation is agnostic to the way tokens are created. This means
476  * that a supply mechanism has to be added in a derived contract using {_mint}.
477  * For a generic mechanism see {ERC20PresetMinterPauser}.
478  *
479  * TIP: For a detailed writeup see our guide
480  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
481  * to implement supply mechanisms].
482  *
483  * We have followed general OpenZeppelin Contracts guidelines: functions revert
484  * instead returning `false` on failure. This behavior is nonetheless
485  * conventional and does not conflict with the expectations of ERC20
486  * applications.
487  *
488  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
489  * This allows applications to reconstruct the allowance for all accounts just
490  * by listening to said events. Other implementations of the EIP may not emit
491  * these events, as it isn't required by the specification.
492  *
493  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
494  * functions have been added to mitigate the well-known issues around setting
495  * allowances. See {IERC20-approve}.
496  */
497 contract ERC20 is Context, IERC20, IERC20Metadata {
498     mapping(address => uint256) private _balances;
499 
500     mapping(address => mapping(address => uint256)) private _allowances;
501 
502     uint256 private _totalSupply;
503 
504     string private _name;
505     string private _symbol;
506 
507     /**
508      * @dev Sets the values for {name} and {symbol}.
509      *
510      * The default value of {decimals} is 18. To select a different value for
511      * {decimals} you should overload it.
512      *
513      * All two of these values are immutable: they can only be set once during
514      * construction.
515      */
516     constructor(string memory name_, string memory symbol_) {
517         _name = name_;
518         _symbol = symbol_;
519     }
520 
521     /**
522      * @dev Returns the name of the token.
523      */
524     function name() public view virtual override returns (string memory) {
525         return _name;
526     }
527 
528     /**
529      * @dev Returns the symbol of the token, usually a shorter version of the
530      * name.
531      */
532     function symbol() public view virtual override returns (string memory) {
533         return _symbol;
534     }
535 
536     /**
537      * @dev Returns the number of decimals used to get its user representation.
538      * For example, if `decimals` equals `2`, a balance of `505` tokens should
539      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
540      *
541      * Tokens usually opt for a value of 18, imitating the relationship between
542      * Ether and Wei. This is the value {ERC20} uses, unless this function is
543      * overridden;
544      *
545      * NOTE: This information is only used for _display_ purposes: it in
546      * no way affects any of the arithmetic of the contract, including
547      * {IERC20-balanceOf} and {IERC20-transfer}.
548      */
549     function decimals() public view virtual override returns (uint8) {
550         return 18;
551     }
552 
553     /**
554      * @dev See {IERC20-totalSupply}.
555      */
556     function totalSupply() public view virtual override returns (uint256) {
557         return _totalSupply;
558     }
559 
560     /**
561      * @dev See {IERC20-balanceOf}.
562      */
563     function balanceOf(address account) public view virtual override returns (uint256) {
564         return _balances[account];
565     }
566 
567     /**
568      * @dev See {IERC20-transfer}.
569      *
570      * Requirements:
571      *
572      * - `to` cannot be the zero address.
573      * - the caller must have a balance of at least `amount`.
574      */
575     function transfer(address to, uint256 amount) public virtual override returns (bool) {
576         address owner = _msgSender();
577         _transfer(owner, to, amount);
578         return true;
579     }
580 
581     /**
582      * @dev See {IERC20-allowance}.
583      */
584     function allowance(address owner, address spender) public view virtual override returns (uint256) {
585         return _allowances[owner][spender];
586     }
587 
588     /**
589      * @dev See {IERC20-approve}.
590      *
591      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
592      * `transferFrom`. This is semantically equivalent to an infinite approval.
593      *
594      * Requirements:
595      *
596      * - `spender` cannot be the zero address.
597      */
598     function approve(address spender, uint256 amount) public virtual override returns (bool) {
599         address owner = _msgSender();
600         _approve(owner, spender, amount);
601         return true;
602     }
603 
604     /**
605      * @dev See {IERC20-transferFrom}.
606      *
607      * Emits an {Approval} event indicating the updated allowance. This is not
608      * required by the EIP. See the note at the beginning of {ERC20}.
609      *
610      * NOTE: Does not update the allowance if the current allowance
611      * is the maximum `uint256`.
612      *
613      * Requirements:
614      *
615      * - `from` and `to` cannot be the zero address.
616      * - `from` must have a balance of at least `amount`.
617      * - the caller must have allowance for ``from``'s tokens of at least
618      * `amount`.
619      */
620     function transferFrom(
621         address from,
622         address to,
623         uint256 amount
624     ) public virtual override returns (bool) {
625         address spender = _msgSender();
626         _spendAllowance(from, spender, amount);
627         _transfer(from, to, amount);
628         return true;
629     }
630 
631     /**
632      * @dev Atomically increases the allowance granted to `spender` by the caller.
633      *
634      * This is an alternative to {approve} that can be used as a mitigation for
635      * problems described in {IERC20-approve}.
636      *
637      * Emits an {Approval} event indicating the updated allowance.
638      *
639      * Requirements:
640      *
641      * - `spender` cannot be the zero address.
642      */
643     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
644         address owner = _msgSender();
645         _approve(owner, spender, allowance(owner, spender) + addedValue);
646         return true;
647     }
648 
649     /**
650      * @dev Atomically decreases the allowance granted to `spender` by the caller.
651      *
652      * This is an alternative to {approve} that can be used as a mitigation for
653      * problems described in {IERC20-approve}.
654      *
655      * Emits an {Approval} event indicating the updated allowance.
656      *
657      * Requirements:
658      *
659      * - `spender` cannot be the zero address.
660      * - `spender` must have allowance for the caller of at least
661      * `subtractedValue`.
662      */
663     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
664         address owner = _msgSender();
665         uint256 currentAllowance = allowance(owner, spender);
666         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
667         unchecked {
668             _approve(owner, spender, currentAllowance - subtractedValue);
669         }
670 
671         return true;
672     }
673 
674     /**
675      * @dev Moves `amount` of tokens from `from` to `to`.
676      *
677      * This internal function is equivalent to {transfer}, and can be used to
678      * e.g. implement automatic token fees, slashing mechanisms, etc.
679      *
680      * Emits a {Transfer} event.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `from` must have a balance of at least `amount`.
687      */
688     function _transfer(
689         address from,
690         address to,
691         uint256 amount
692     ) internal virtual {
693         require(from != address(0), "ERC20: transfer from the zero address");
694         require(to != address(0), "ERC20: transfer to the zero address");
695 
696         _beforeTokenTransfer(from, to, amount);
697 
698         uint256 fromBalance = _balances[from];
699         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
700         unchecked {
701             _balances[from] = fromBalance - amount;
702             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
703             // decrementing then incrementing.
704             _balances[to] += amount;
705         }
706 
707         emit Transfer(from, to, amount);
708 
709         _afterTokenTransfer(from, to, amount);
710     }
711 
712     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
713      * the total supply.
714      *
715      * Emits a {Transfer} event with `from` set to the zero address.
716      *
717      * Requirements:
718      *
719      * - `account` cannot be the zero address.
720      */
721     function _mint(address account, uint256 amount) internal virtual {
722         require(account != address(0), "ERC20: mint to the zero address");
723 
724         _beforeTokenTransfer(address(0), account, amount);
725 
726         _totalSupply += amount;
727         unchecked {
728             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
729             _balances[account] += amount;
730         }
731         emit Transfer(address(0), account, amount);
732 
733         _afterTokenTransfer(address(0), account, amount);
734     }
735 
736     /**
737      * @dev Destroys `amount` tokens from `account`, reducing the
738      * total supply.
739      *
740      * Emits a {Transfer} event with `to` set to the zero address.
741      *
742      * Requirements:
743      *
744      * - `account` cannot be the zero address.
745      * - `account` must have at least `amount` tokens.
746      */
747     function _burn(address account, uint256 amount) internal virtual {
748         require(account != address(0), "ERC20: burn from the zero address");
749 
750         _beforeTokenTransfer(account, address(0), amount);
751 
752         uint256 accountBalance = _balances[account];
753         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
754         unchecked {
755             _balances[account] = accountBalance - amount;
756             // Overflow not possible: amount <= accountBalance <= totalSupply.
757             _totalSupply -= amount;
758         }
759 
760         emit Transfer(account, address(0), amount);
761 
762         _afterTokenTransfer(account, address(0), amount);
763     }
764 
765     /**
766      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
767      *
768      * This internal function is equivalent to `approve`, and can be used to
769      * e.g. set automatic allowances for certain subsystems, etc.
770      *
771      * Emits an {Approval} event.
772      *
773      * Requirements:
774      *
775      * - `owner` cannot be the zero address.
776      * - `spender` cannot be the zero address.
777      */
778     function _approve(
779         address owner,
780         address spender,
781         uint256 amount
782     ) internal virtual {
783         require(owner != address(0), "ERC20: approve from the zero address");
784         require(spender != address(0), "ERC20: approve to the zero address");
785 
786         _allowances[owner][spender] = amount;
787         emit Approval(owner, spender, amount);
788     }
789 
790     /**
791      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
792      *
793      * Does not update the allowance amount in case of infinite allowance.
794      * Revert if not enough allowance is available.
795      *
796      * Might emit an {Approval} event.
797      */
798     function _spendAllowance(
799         address owner,
800         address spender,
801         uint256 amount
802     ) internal virtual {
803         uint256 currentAllowance = allowance(owner, spender);
804         if (currentAllowance != type(uint256).max) {
805             require(currentAllowance >= amount, "ERC20: insufficient allowance");
806             unchecked {
807                 _approve(owner, spender, currentAllowance - amount);
808             }
809         }
810     }
811 
812     /**
813      * @dev Hook that is called before any transfer of tokens. This includes
814      * minting and burning.
815      *
816      * Calling conditions:
817      *
818      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
819      * will be transferred to `to`.
820      * - when `from` is zero, `amount` tokens will be minted for `to`.
821      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
822      * - `from` and `to` are never both zero.
823      *
824      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
825      */
826     function _beforeTokenTransfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal virtual {}
831 
832     /**
833      * @dev Hook that is called after any transfer of tokens. This includes
834      * minting and burning.
835      *
836      * Calling conditions:
837      *
838      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
839      * has been transferred to `to`.
840      * - when `from` is zero, `amount` tokens have been minted for `to`.
841      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
842      * - `from` and `to` are never both zero.
843      *
844      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
845      */
846     function _afterTokenTransfer(
847         address from,
848         address to,
849         uint256 amount
850     ) internal virtual {}
851 }
852 
853 pragma solidity 0.8.9;
854 
855 
856 interface IUniswapV2Pair {
857     event Approval(address indexed owner, address indexed spender, uint value);
858     event Transfer(address indexed from, address indexed to, uint value);
859 
860     function name() external pure returns (string memory);
861     function symbol() external pure returns (string memory);
862     function decimals() external pure returns (uint8);
863     function totalSupply() external view returns (uint);
864     function balanceOf(address owner) external view returns (uint);
865     function allowance(address owner, address spender) external view returns (uint);
866 
867     function approve(address spender, uint value) external returns (bool);
868     function transfer(address to, uint value) external returns (bool);
869     function transferFrom(address from, address to, uint value) external returns (bool);
870 
871     function DOMAIN_SEPARATOR() external view returns (bytes32);
872     function PERMIT_TYPEHASH() external pure returns (bytes32);
873     function nonces(address owner) external view returns (uint);
874 
875     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
876 
877     event Mint(address indexed sender, uint amount0, uint amount1);
878     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
879     event Swap(
880         address indexed sender,
881         uint amount0In,
882         uint amount1In,
883         uint amount0Out,
884         uint amount1Out,
885         address indexed to
886     );
887     event Sync(uint112 reserve0, uint112 reserve1);
888 
889     function MINIMUM_LIQUIDITY() external pure returns (uint);
890     function factory() external view returns (address);
891     function token0() external view returns (address);
892     function token1() external view returns (address);
893     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
894     function price0CumulativeLast() external view returns (uint);
895     function price1CumulativeLast() external view returns (uint);
896     function kLast() external view returns (uint);
897 
898     function mint(address to) external returns (uint liquidity);
899     function burn(address to) external returns (uint amount0, uint amount1);
900     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
901     function skim(address to) external;
902     function sync() external;
903 
904     function initialize(address, address) external;
905 }
906 
907 
908 interface IUniswapV2Factory {
909     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
910 
911     function feeTo() external view returns (address);
912     function feeToSetter() external view returns (address);
913 
914     function getPair(address tokenA, address tokenB) external view returns (address pair);
915     function allPairs(uint) external view returns (address pair);
916     function allPairsLength() external view returns (uint);
917 
918     function createPair(address tokenA, address tokenB) external returns (address pair);
919 
920     function setFeeTo(address) external;
921     function setFeeToSetter(address) external;
922 }
923 
924 
925 library SafeMathInt {
926     int256 private constant MIN_INT256 = int256(1) << 255;
927     int256 private constant MAX_INT256 = ~(int256(1) << 255);
928 
929     /**
930      * @dev Multiplies two int256 variables and fails on overflow.
931      */
932     function mul(int256 a, int256 b) internal pure returns (int256) {
933         int256 c = a * b;
934 
935         // Detect overflow when multiplying MIN_INT256 with -1
936         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
937         require((b == 0) || (c / b == a));
938         return c;
939     }
940 
941     /**
942      * @dev Division of two int256 variables and fails on overflow.
943      */
944     function div(int256 a, int256 b) internal pure returns (int256) {
945         // Prevent overflow when dividing MIN_INT256 by -1
946         require(b != -1 || a != MIN_INT256);
947 
948         // Solidity already throws when dividing by 0.
949         return a / b;
950     }
951 
952     /**
953      * @dev Subtracts two int256 variables and fails on overflow.
954      */
955     function sub(int256 a, int256 b) internal pure returns (int256) {
956         int256 c = a - b;
957         require((b >= 0 && c <= a) || (b < 0 && c > a));
958         return c;
959     }
960 
961     /**
962      * @dev Adds two int256 variables and fails on overflow.
963      */
964     function add(int256 a, int256 b) internal pure returns (int256) {
965         int256 c = a + b;
966         require((b >= 0 && c >= a) || (b < 0 && c < a));
967         return c;
968     }
969 
970     /**
971      * @dev Converts to absolute value, and fails on overflow.
972      */
973     function abs(int256 a) internal pure returns (int256) {
974         require(a != MIN_INT256);
975         return a < 0 ? -a : a;
976     }
977 
978 
979     function toUint256Safe(int256 a) internal pure returns (uint256) {
980         require(a >= 0);
981         return uint256(a);
982     }
983 }
984 
985 library SafeMathUint {
986   function toInt256Safe(uint256 a) internal pure returns (int256) {
987     int256 b = int256(a);
988     require(b >= 0);
989     return b;
990   }
991 }
992 
993 
994 interface IUniswapV2Router01 {
995     function factory() external pure returns (address);
996     function WETH() external pure returns (address);
997 
998     function addLiquidity(
999         address tokenA,
1000         address tokenB,
1001         uint amountADesired,
1002         uint amountBDesired,
1003         uint amountAMin,
1004         uint amountBMin,
1005         address to,
1006         uint deadline
1007     ) external returns (uint amountA, uint amountB, uint liquidity);
1008     function addLiquidityETH(
1009         address token,
1010         uint amountTokenDesired,
1011         uint amountTokenMin,
1012         uint amountETHMin,
1013         address to,
1014         uint deadline
1015     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1016     function removeLiquidity(
1017         address tokenA,
1018         address tokenB,
1019         uint liquidity,
1020         uint amountAMin,
1021         uint amountBMin,
1022         address to,
1023         uint deadline
1024     ) external returns (uint amountA, uint amountB);
1025     function removeLiquidityETH(
1026         address token,
1027         uint liquidity,
1028         uint amountTokenMin,
1029         uint amountETHMin,
1030         address to,
1031         uint deadline
1032     ) external returns (uint amountToken, uint amountETH);
1033     function removeLiquidityWithPermit(
1034         address tokenA,
1035         address tokenB,
1036         uint liquidity,
1037         uint amountAMin,
1038         uint amountBMin,
1039         address to,
1040         uint deadline,
1041         bool approveMax, uint8 v, bytes32 r, bytes32 s
1042     ) external returns (uint amountA, uint amountB);
1043     function removeLiquidityETHWithPermit(
1044         address token,
1045         uint liquidity,
1046         uint amountTokenMin,
1047         uint amountETHMin,
1048         address to,
1049         uint deadline,
1050         bool approveMax, uint8 v, bytes32 r, bytes32 s
1051     ) external returns (uint amountToken, uint amountETH);
1052     function swapExactTokensForTokens(
1053         uint amountIn,
1054         uint amountOutMin,
1055         address[] calldata path,
1056         address to,
1057         uint deadline
1058     ) external returns (uint[] memory amounts);
1059     function swapTokensForExactTokens(
1060         uint amountOut,
1061         uint amountInMax,
1062         address[] calldata path,
1063         address to,
1064         uint deadline
1065     ) external returns (uint[] memory amounts);
1066     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1067         external
1068         payable
1069         returns (uint[] memory amounts);
1070     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1071         external
1072         returns (uint[] memory amounts);
1073     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1074         external
1075         returns (uint[] memory amounts);
1076     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1077         external
1078         payable
1079         returns (uint[] memory amounts);
1080 
1081     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1082     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1083     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1084     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1085     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1086 }
1087 
1088 interface IUniswapV2Router02 is IUniswapV2Router01 {
1089     function removeLiquidityETHSupportingFeeOnTransferTokens(
1090         address token,
1091         uint liquidity,
1092         uint amountTokenMin,
1093         uint amountETHMin,
1094         address to,
1095         uint deadline
1096     ) external returns (uint amountETH);
1097     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1098         address token,
1099         uint liquidity,
1100         uint amountTokenMin,
1101         uint amountETHMin,
1102         address to,
1103         uint deadline,
1104         bool approveMax, uint8 v, bytes32 r, bytes32 s
1105     ) external returns (uint amountETH);
1106 
1107     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1108         uint amountIn,
1109         uint amountOutMin,
1110         address[] calldata path,
1111         address to,
1112         uint deadline
1113     ) external;
1114     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1115         uint amountOutMin,
1116         address[] calldata path,
1117         address to,
1118         uint deadline
1119     ) external payable;
1120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1121         uint amountIn,
1122         uint amountOutMin,
1123         address[] calldata path,
1124         address to,
1125         uint deadline
1126     ) external;
1127 }
1128 
1129 
1130 contract HPOP1I is ERC20, Ownable  {
1131     using SafeMath for uint256;
1132 
1133     IUniswapV2Router02 public immutable uniswapV2Router;
1134     address public immutable uniswapV2Pair;
1135     address public constant deadAddress = address(0xdead);
1136 
1137     bool private swapping;
1138 
1139     address public marketingWallet;
1140     address public devWallet;
1141     
1142     uint256 public maxTransactionAmount;
1143     uint256 public swapTokensAtAmount;
1144     uint256 public maxWallet;
1145     
1146     uint256 public percentForLPBurn = 1; // 25 = .25%
1147     bool public lpBurnEnabled = false;
1148     uint256 public lpBurnFrequency = 1360000000000 seconds;
1149     uint256 public lastLpBurnTime;
1150     
1151     uint256 public manualBurnFrequency = 43210 minutes;
1152     uint256 public lastManualLpBurnTime;
1153 
1154     bool public limitsInEffect = true;
1155     bool public tradingActive = true; // go live after adding LP
1156     bool public swapEnabled = true;
1157     
1158      // Anti-bot and anti-whale mappings and variables
1159     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1160     bool public transferDelayEnabled = true;
1161 
1162     uint256 public buyTotalFees;
1163     uint256 public buyMarketingFee;
1164     uint256 public buyLiquidityFee;
1165     uint256 public buyDevFee;
1166     
1167     uint256 public sellTotalFees;
1168     uint256 public sellMarketingFee;
1169     uint256 public sellLiquidityFee;
1170     uint256 public sellDevFee;
1171     
1172     uint256 public tokensForMarketing;
1173     uint256 public tokensForLiquidity;
1174     uint256 public tokensForDev;
1175     
1176     /******************/
1177 
1178     // exlcude from fees and max transaction amount
1179     mapping (address => bool) private _isExcludedFromFees;
1180     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1181 
1182     // blacklist
1183     mapping(address => bool) public blacklists;
1184 
1185     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1186     // could be subject to a maximum transfer amount
1187     mapping (address => bool) public automatedMarketMakerPairs;
1188 
1189     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1190 
1191     event ExcludeFromFees(address indexed account, bool isExcluded);
1192 
1193     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1194 
1195     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1196     
1197     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
1198 
1199     event SwapAndLiquify(
1200         uint256 tokensSwapped,
1201         uint256 ethReceived,
1202         uint256 tokensIntoLiquidity
1203     );
1204     
1205     event AutoNukeLP();
1206     
1207     event ManualNukeLP();
1208 
1209     constructor() ERC20("HarryPotterObamaPepe1Inu", "PEPE") {
1210         
1211         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1212         
1213         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1214         uniswapV2Router = _uniswapV2Router;
1215         
1216         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1217         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1218         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1219         
1220         uint256 _buyMarketingFee = 0;
1221         uint256 _buyLiquidityFee = 0;
1222         uint256 _buyDevFee = 15;
1223 
1224         uint256 _sellMarketingFee = 0;
1225         uint256 _sellLiquidityFee = 0;
1226         uint256 _sellDevFee = 15;
1227         
1228         uint256 totalSupply = 1_000_000_000 * 1e18;
1229         
1230         //  Maximum tx size and wallet size
1231         maxTransactionAmount = totalSupply * 1 / 100;
1232         maxWallet = totalSupply * 1 / 100;
1233 
1234         swapTokensAtAmount = totalSupply * 1 / 10000;
1235 
1236         buyMarketingFee = _buyMarketingFee;
1237         buyLiquidityFee = _buyLiquidityFee;
1238         buyDevFee = _buyDevFee;
1239         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1240         
1241         sellMarketingFee = _sellMarketingFee;
1242         sellLiquidityFee = _sellLiquidityFee;
1243         sellDevFee = _sellDevFee;
1244         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1245         
1246         marketingWallet = address(owner()); // set as marketing wallet
1247         devWallet = address(owner()); // set as dev wallet
1248 
1249         // exclude from paying fees or having max transaction amount
1250         excludeFromFees(owner(), true);
1251         excludeFromFees(address(this), true);
1252         excludeFromFees(address(0xdead), true);
1253         
1254         excludeFromMaxTransaction(owner(), true);
1255         excludeFromMaxTransaction(address(this), true);
1256         excludeFromMaxTransaction(address(0xdead), true);
1257         
1258         /*
1259             _mint is an internal function in ERC20.sol that is only called here,
1260             and CANNOT be called ever again
1261         */
1262         _mint(msg.sender, totalSupply);
1263     }
1264 
1265     receive() external payable {
1266 
1267     }
1268 
1269     function blacklist(address[] calldata _addresses, bool _isBlacklisting) external onlyOwner {
1270         for (uint i=0; i<_addresses.length; i++) {
1271             blacklists[_addresses[i]] = _isBlacklisting;
1272         }
1273     }
1274 
1275     // once enabled, can never be turned off
1276     function enableTrading() external onlyOwner {
1277         tradingActive = true;
1278         swapEnabled = true;
1279         lastLpBurnTime = block.timestamp;
1280     }
1281     
1282     // remove limits after token is stable
1283     function removeLimits() external onlyOwner returns (bool){
1284         limitsInEffect = false;
1285         return true;
1286     }
1287     
1288     // disable Transfer delay - cannot be reenabled
1289     function disableTransferDelay() external onlyOwner returns (bool){
1290         transferDelayEnabled = false;
1291         return true;
1292     }
1293     
1294      // change the minimum amount of tokens to sell from fees
1295     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1296         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1297         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1298         swapTokensAtAmount = newAmount;
1299         return true;
1300     }
1301     
1302     function updateMaxLimits(uint256 maxPerTx, uint256 maxPerWallet) external onlyOwner {
1303         require(maxPerTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1304         maxTransactionAmount = maxPerTx * (10**18);
1305 
1306         require(maxPerWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1307         maxWallet = maxPerWallet * (10**18);
1308     }
1309     
1310     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1311         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1312         maxTransactionAmount = newNum * (10**18);
1313     }
1314 
1315     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1316         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1317         maxWallet = newNum * (10**18);
1318     }
1319     
1320     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1321         _isExcludedMaxTransactionAmount[updAds] = isEx;
1322     }
1323     
1324     // only use to disable contract sales if absolutely necessary (emergency use only)
1325     function updateSwapEnabled(bool enabled) external onlyOwner(){
1326         swapEnabled = enabled;
1327     }
1328     
1329     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1330         buyMarketingFee = _marketingFee;
1331         buyLiquidityFee = _liquidityFee;
1332         buyDevFee = _devFee;
1333         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1334         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1335     }
1336     
1337     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1338         sellMarketingFee = _marketingFee;
1339         sellLiquidityFee = _liquidityFee;
1340         sellDevFee = _devFee;
1341         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1342         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1343     }
1344 
1345     function updateTaxes (uint256 buy, uint256 sell) external onlyOwner {
1346         sellDevFee = sell;
1347         buyDevFee = buy;
1348         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1349         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1350         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1351         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1352     }
1353 
1354     function excludeFromFees(address account, bool excluded) public onlyOwner {
1355         _isExcludedFromFees[account] = excluded;
1356         emit ExcludeFromFees(account, excluded);
1357     }
1358 
1359     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1360         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1361 
1362         _setAutomatedMarketMakerPair(pair, value);
1363     }
1364 
1365     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1366         automatedMarketMakerPairs[pair] = value;
1367 
1368         emit SetAutomatedMarketMakerPair(pair, value);
1369     }
1370 
1371     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1372         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1373         marketingWallet = newMarketingWallet;
1374     }
1375     
1376     function updateDevWallet(address newWallet) external onlyOwner {
1377         emit devWalletUpdated(newWallet, devWallet);
1378         devWallet = newWallet;
1379     }
1380     
1381 
1382     function isExcludedFromFees(address account) public view returns(bool) {
1383         return _isExcludedFromFees[account];
1384     }
1385     
1386     event BoughtEarly(address indexed sniper);
1387 
1388     function _transfer(
1389         address from,
1390         address to,
1391         uint256 amount
1392     ) internal override {
1393         require(from != address(0), "ERC20: transfer from the zero address");
1394         require(to != address(0), "ERC20: transfer to the zero address");
1395         require(!blacklists[to] && !blacklists[from], "Blacklisted");
1396         
1397          if(amount == 0) {
1398             super._transfer(from, to, 0);
1399             return;
1400         }
1401         
1402         if(limitsInEffect){
1403             if (
1404                 from != owner() &&
1405                 to != owner() &&
1406                 to != address(0) &&
1407                 to != address(0xdead) &&
1408                 !swapping
1409             ){
1410                 if(!tradingActive){
1411                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1412                 }
1413 
1414                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1415                 if (transferDelayEnabled){
1416                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1417                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1418                         _holderLastTransferTimestamp[tx.origin] = block.number;
1419                     }
1420                 }
1421                  
1422                 //when buy
1423                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1424                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1425                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1426                 }
1427                 
1428                 //when sell
1429                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1430                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1431                 }
1432                 else if(!_isExcludedMaxTransactionAmount[to]){
1433                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1434                 }
1435             }
1436         }
1437         
1438         
1439         uint256 contractTokenBalance = balanceOf(address(this));
1440         
1441         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1442 
1443         if( 
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
1458         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1459             autoBurnLiquidityPairTokens();
1460         }
1461 
1462         bool takeFee = !swapping;
1463 
1464         // if any account belongs to _isExcludedFromFee account then remove the fee
1465         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1466             takeFee = false;
1467         }
1468         
1469         uint256 fees = 0;
1470         // only take fees on buys/sells, do not take on wallet transfers
1471         if(takeFee){
1472             // on sell
1473             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1474                 fees = amount.mul(sellTotalFees).div(100);
1475                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1476                 tokensForDev += fees * sellDevFee / sellTotalFees;
1477                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1478             }
1479             // on buy
1480             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1481                 fees = amount.mul(buyTotalFees).div(100);
1482                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1483                 tokensForDev += fees * buyDevFee / buyTotalFees;
1484                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1485             }
1486             
1487             if(fees > 0){    
1488                 super._transfer(from, address(this), fees);
1489             }
1490             
1491             amount -= fees;
1492         }
1493 
1494         super._transfer(from, to, amount);
1495     }
1496 
1497     function swapTokensForEth(uint256 tokenAmount) private {
1498 
1499         // generate the uniswap pair path of token -> weth
1500         address[] memory path = new address[](2);
1501         path[0] = address(this);
1502         path[1] = uniswapV2Router.WETH();
1503 
1504         _approve(address(this), address(uniswapV2Router), tokenAmount);
1505 
1506         // make the swap
1507         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1508             tokenAmount,
1509             0, // accept any amount of ETH
1510             path,
1511             address(this),
1512             block.timestamp
1513         );
1514         
1515     }
1516     
1517     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1518         // approve token transfer to cover all possible scenarios
1519         _approve(address(this), address(uniswapV2Router), tokenAmount);
1520 
1521         // add the liquidity
1522         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1523             address(this),
1524             tokenAmount,
1525             0, // slippage is unavoidable
1526             0, // slippage is unavoidable
1527             deadAddress,
1528             block.timestamp
1529         );
1530     }
1531 
1532     function swapBack() private {
1533         uint256 contractBalance = balanceOf(address(this));
1534         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1535         bool success;
1536         
1537         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1538 
1539         if(contractBalance > swapTokensAtAmount * 20){
1540           contractBalance = swapTokensAtAmount * 20;
1541         }
1542         
1543         // Halve the amount of liquidity tokens
1544         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1545         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1546         
1547         uint256 initialETHBalance = address(this).balance;
1548 
1549         swapTokensForEth(amountToSwapForETH); 
1550         
1551         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1552         
1553         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1554         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1555         
1556         
1557         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1558         
1559         
1560         tokensForLiquidity = 0;
1561         tokensForMarketing = 0;
1562         tokensForDev = 0;
1563         
1564         (success,) = address(devWallet).call{value: ethForDev}("");
1565         
1566         if(liquidityTokens > 0 && ethForLiquidity > 0){
1567             addLiquidity(liquidityTokens, ethForLiquidity);
1568             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1569         }
1570         
1571         
1572         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1573     }
1574     
1575     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1576         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1577         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1578         lpBurnFrequency = _frequencyInSeconds;
1579         percentForLPBurn = _percent;
1580         lpBurnEnabled = _Enabled;
1581     }
1582     
1583     function autoBurnLiquidityPairTokens() internal returns (bool){
1584         
1585         lastLpBurnTime = block.timestamp;
1586         
1587         // get balance of liquidity pair
1588         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1589         
1590         // calculate amount to burn
1591         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1592         
1593         // pull tokens from pancakePair liquidity and move to dead address permanently
1594         if (amountToBurn > 0){
1595             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1596         }
1597         
1598         //sync price since this is not in a swap transaction!
1599         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1600         pair.sync();
1601         emit AutoNukeLP();
1602         return true;
1603     }
1604 
1605     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1606         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1607         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1608         lastManualLpBurnTime = block.timestamp;
1609         
1610         // get balance of liquidity pair
1611         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1612         
1613         // calculate amount to burn
1614         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1615         
1616         // pull tokens from pancakePair liquidity and move to dead address permanently
1617         if (amountToBurn > 0){
1618             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1619         }
1620         
1621         //sync price since this is not in a swap transaction!
1622         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1623         pair.sync();
1624         emit ManualNukeLP();
1625         return true;
1626     }
1627 }