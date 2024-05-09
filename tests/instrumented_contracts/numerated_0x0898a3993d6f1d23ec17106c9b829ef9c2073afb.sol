1 /*
2 *AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*AMG*
3 */
4 
5 /**
6 Website: https://amgcoin.pro/
7 Telegram: https://t.me/+vpQTd4f1zcdlNTQy
8 Twitter: https://twitter.com/tokenamg
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 
14 pragma solidity ^0.8.0;
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
57             if (a == 0) return (true, 0);
58             uint256 c = a * b;
59             if (c / a != b) return (false, 0);
60             return (true, c);
61         }
62     }
63 
64     /**
65      * @dev Returns the division of two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b == 0) return (false, 0);
72             return (true, a / b);
73         }
74     }
75 
76     /**
77      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a % b);
85         }
86     }
87 
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a + b;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a - b;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers, reverting on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator.
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a % b;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * CAUTION: This function is deprecated because it requires allocating memory for the error
165      * message unnecessarily. For custom revert reasons use {trySub}.
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         unchecked {
179             require(b <= a, errorMessage);
180             return a - b;
181         }
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b > 0, errorMessage);
203             return a / b;
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting with custom message when dividing by zero.
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {tryMod}.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b > 0, errorMessage);
229             return a % b;
230         }
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Context.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/access/Ownable.sol
262 
263 
264 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * By default, the owner account will be the one that deploys the contract. This
275  * can later be changed with {transferOwnership}.
276  *
277  * This module is used through inheritance. It will make available the modifier
278  * `onlyOwner`, which can be applied to your functions to restrict their use to
279  * the owner.
280  */
281 abstract contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev Initializes the contract setting the deployer as the initial owner.
288      */
289     constructor() {
290         _transferOwnership(_msgSender());
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         _checkOwner();
298         _;
299     }
300 
301     /**
302      * @dev Returns the address of the current owner.
303      */
304     function owner() public view virtual returns (address) {
305         return _owner;
306     }
307 
308     /**
309      * @dev Throws if the sender is not the owner.
310      */
311     function _checkOwner() internal view virtual {
312         require(owner() == _msgSender(), "Ownable: caller is not the owner");
313     }
314 
315     /**
316      * @dev Leaves the contract without owner. It will not be possible to call
317      * `onlyOwner` functions anymore. Can only be called by the current owner.
318      *
319      * NOTE: Renouncing ownership will leave the contract without an owner,
320      * thereby removing any functionality that is only available to the owner.
321      */
322     function renounceOwnership() public virtual onlyOwner {
323         _transferOwnership(address(0));
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         _transferOwnership(newOwner);
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Internal function without access restriction.
338      */
339     function _transferOwnership(address newOwner) internal virtual {
340         address oldOwner = _owner;
341         _owner = newOwner;
342         emit OwnershipTransferred(oldOwner, newOwner);
343     }
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
347 
348 
349 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Interface of the ERC20 standard as defined in the EIP.
355  */
356 interface IERC20 {
357     /**
358      * @dev Emitted when `value` tokens are moved from one account (`from`) to
359      * another (`to`).
360      *
361      * Note that `value` may be zero.
362      */
363     event Transfer(address indexed from, address indexed to, uint256 value);
364 
365     /**
366      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
367      * a call to {approve}. `value` is the new allowance.
368      */
369     event Approval(address indexed owner, address indexed spender, uint256 value);
370 
371     /**
372      * @dev Returns the amount of tokens in existence.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns the amount of tokens owned by `account`.
378      */
379     function balanceOf(address account) external view returns (uint256);
380 
381     /**
382      * @dev Moves `amount` tokens from the caller's account to `to`.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transfer(address to, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Returns the remaining number of tokens that `spender` will be
392      * allowed to spend on behalf of `owner` through {transferFrom}. This is
393      * zero by default.
394      *
395      * This value changes when {approve} or {transferFrom} are called.
396      */
397     function allowance(address owner, address spender) external view returns (uint256);
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * IMPORTANT: Beware that changing an allowance with this method brings the risk
405      * that someone may use both the old and the new allowance by unfortunate
406      * transaction ordering. One possible solution to mitigate this race
407      * condition is to first reduce the spender's allowance to 0 and set the
408      * desired value afterwards:
409      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address spender, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Moves `amount` tokens from `from` to `to` using the
417      * allowance mechanism. `amount` is then deducted from the caller's
418      * allowance.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transferFrom(
425         address from,
426         address to,
427         uint256 amount
428     ) external returns (bool);
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Interface for the optional metadata functions from the ERC20 standard.
441  *
442  * _Available since v4.1._
443  */
444 interface IERC20Metadata is IERC20 {
445     /**
446      * @dev Returns the name of the token.
447      */
448     function name() external view returns (string memory);
449 
450     /**
451      * @dev Returns the symbol of the token.
452      */
453     function symbol() external view returns (string memory);
454 
455     /**
456      * @dev Returns the decimals places of the token.
457      */
458     function decimals() external view returns (uint8);
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 
470 
471 /**
472  * @dev Implementation of the {IERC20} interface.
473  *
474  * This implementation is agnostic to the way tokens are created. This means
475  * that a supply mechanism has to be added in a derived contract using {_mint}.
476  * For a generic mechanism see {ERC20PresetMinterPauser}.
477  *
478  * TIP: For a detailed writeup see our guide
479  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
480  * to implement supply mechanisms].
481  *
482  * We have followed general OpenZeppelin Contracts guidelines: functions revert
483  * instead returning `false` on failure. This behavior is nonetheless
484  * conventional and does not conflict with the expectations of ERC20
485  * applications.
486  *
487  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
488  * This allows applications to reconstruct the allowance for all accounts just
489  * by listening to said events. Other implementations of the EIP may not emit
490  * these events, as it isn't required by the specification.
491  *
492  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
493  * functions have been added to mitigate the well-known issues around setting
494  * allowances. See {IERC20-approve}.
495  */
496 contract ERC20 is Context, IERC20, IERC20Metadata {
497     mapping(address => uint256) private _balances;
498 
499     mapping(address => mapping(address => uint256)) private _allowances;
500 
501     uint256 private _totalSupply;
502 
503     string private _name;
504     string private _symbol;
505 
506     /**
507      * @dev Sets the values for {name} and {symbol}.
508      *
509      * The default value of {decimals} is 18. To select a different value for
510      * {decimals} you should overload it.
511      *
512      * All two of these values are immutable: they can only be set once during
513      * construction.
514      */
515     constructor(string memory name_, string memory symbol_) {
516         _name = name_;
517         _symbol = symbol_;
518     }
519 
520     /**
521      * @dev Returns the name of the token.
522      */
523     function name() public view virtual override returns (string memory) {
524         return _name;
525     }
526 
527     /**
528      * @dev Returns the symbol of the token, usually a shorter version of the
529      * name.
530      */
531     function symbol() public view virtual override returns (string memory) {
532         return _symbol;
533     }
534 
535     /**
536      * @dev Returns the number of decimals used to get its user representation.
537      * For example, if `decimals` equals `2`, a balance of `505` tokens should
538      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
539      *
540      * Tokens usually opt for a value of 18, imitating the relationship between
541      * Ether and Wei. This is the value {ERC20} uses, unless this function is
542      * overridden;
543      *
544      * NOTE: This information is only used for _display_ purposes: it in
545      * no way affects any of the arithmetic of the contract, including
546      * {IERC20-balanceOf} and {IERC20-transfer}.
547      */
548     function decimals() public view virtual override returns (uint8) {
549         return 9;
550     }
551 
552     /**
553      * @dev See {IERC20-totalSupply}.
554      */
555     function totalSupply() public view virtual override returns (uint256) {
556         return _totalSupply;
557     }
558 
559     /**
560      * @dev See {IERC20-balanceOf}.
561      */
562     function balanceOf(address account) public view virtual override returns (uint256) {
563         return _balances[account];
564     }
565 
566     /**
567      * @dev See {IERC20-transfer}.
568      *
569      * Requirements:
570      *
571      * - `to` cannot be the zero address.
572      * - the caller must have a balance of at least `amount`.
573      */
574     function transfer(address to, uint256 amount) public virtual override returns (bool) {
575         address owner = _msgSender();
576         _transfer(owner, to, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-allowance}.
582      */
583     function allowance(address owner, address spender) public view virtual override returns (uint256) {
584         return _allowances[owner][spender];
585     }
586 
587     /**
588      * @dev See {IERC20-approve}.
589      *
590      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
591      * `transferFrom`. This is semantically equivalent to an infinite approval.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      */
597     function approve(address spender, uint256 amount) public virtual override returns (bool) {
598         address owner = _msgSender();
599         _approve(owner, spender, amount);
600         return true;
601     }
602 
603     /**
604      * @dev See {IERC20-transferFrom}.
605      *
606      * Emits an {Approval} event indicating the updated allowance. This is not
607      * required by the EIP. See the note at the beginning of {ERC20}.
608      *
609      * NOTE: Does not update the allowance if the current allowance
610      * is the maximum `uint256`.
611      *
612      * Requirements:
613      *
614      * - `from` and `to` cannot be the zero address.
615      * - `from` must have a balance of at least `amount`.
616      * - the caller must have allowance for ``from``'s tokens of at least
617      * `amount`.
618      */
619     function transferFrom(
620         address from,
621         address to,
622         uint256 amount
623     ) public virtual override returns (bool) {
624         address spender = _msgSender();
625         _spendAllowance(from, spender, amount);
626         _transfer(from, to, amount);
627         return true;
628     }
629 
630     /**
631      * @dev Atomically increases the allowance granted to `spender` by the caller.
632      *
633      * This is an alternative to {approve} that can be used as a mitigation for
634      * problems described in {IERC20-approve}.
635      *
636      * Emits an {Approval} event indicating the updated allowance.
637      *
638      * Requirements:
639      *
640      * - `spender` cannot be the zero address.
641      */
642     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
643         address owner = _msgSender();
644         _approve(owner, spender, allowance(owner, spender) + addedValue);
645         return true;
646     }
647 
648     /**
649      * @dev Atomically decreases the allowance granted to `spender` by the caller.
650      *
651      * This is an alternative to {approve} that can be used as a mitigation for
652      * problems described in {IERC20-approve}.
653      *
654      * Emits an {Approval} event indicating the updated allowance.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      * - `spender` must have allowance for the caller of at least
660      * `subtractedValue`.
661      */
662     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
663         address owner = _msgSender();
664         uint256 currentAllowance = allowance(owner, spender);
665         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
666         unchecked {
667             _approve(owner, spender, currentAllowance - subtractedValue);
668         }
669 
670         return true;
671     }
672 
673     /**
674      * @dev Moves `amount` of tokens from `from` to `to`.
675      *
676      * This internal function is equivalent to {transfer}, and can be used to
677      * e.g. implement automatic token fees, slashing mechanisms, etc.
678      *
679      * Emits a {Transfer} event.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `from` must have a balance of at least `amount`.
686      */
687     function _transfer(
688         address from,
689         address to,
690         uint256 amount
691     ) internal virtual {
692         require(from != address(0), "ERC20: transfer from the zero address");
693         require(to != address(0), "ERC20: transfer to the zero address");
694 
695         _beforeTokenTransfer(from, to, amount);
696 
697         uint256 fromBalance = _balances[from];
698         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
699         unchecked {
700             _balances[from] = fromBalance - amount;
701             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
702             // decrementing then incrementing.
703             _balances[to] += amount;
704         }
705 
706         emit Transfer(from, to, amount);
707 
708         _afterTokenTransfer(from, to, amount);
709     }
710 
711     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
712      * the total supply.
713      *
714      * Emits a {Transfer} event with `from` set to the zero address.
715      *
716      * Requirements:
717      *
718      * - `account` cannot be the zero address.
719      */
720     function _mint(address account, uint256 amount) internal virtual {
721         require(account != address(0), "ERC20: mint to the zero address");
722 
723         _beforeTokenTransfer(address(0), account, amount);
724 
725         _totalSupply += amount;
726         unchecked {
727             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
728             _balances[account] += amount;
729         }
730         emit Transfer(address(0), account, amount);
731 
732         _afterTokenTransfer(address(0), account, amount);
733     }
734 
735     /**
736      * @dev Destroys `amount` tokens from `account`, reducing the
737      * total supply.
738      *
739      * Emits a {Transfer} event with `to` set to the zero address.
740      *
741      * Requirements:
742      *
743      * - `account` cannot be the zero address.
744      * - `account` must have at least `amount` tokens.
745      */
746     function _burn(address account, uint256 amount) internal virtual {
747         require(account != address(0), "ERC20: burn from the zero address");
748 
749         _beforeTokenTransfer(account, address(0), amount);
750 
751         uint256 accountBalance = _balances[account];
752         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
753         unchecked {
754             _balances[account] = accountBalance - amount;
755             // Overflow not possible: amount <= accountBalance <= totalSupply.
756             _totalSupply -= amount;
757         }
758 
759         emit Transfer(account, address(0), amount);
760 
761         _afterTokenTransfer(account, address(0), amount);
762     }
763 
764     /**
765      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
766      *
767      * This internal function is equivalent to `approve`, and can be used to
768      * e.g. set automatic allowances for certain subsystems, etc.
769      *
770      * Emits an {Approval} event.
771      *
772      * Requirements:
773      *
774      * - `owner` cannot be the zero address.
775      * - `spender` cannot be the zero address.
776      */
777     function _approve(
778         address owner,
779         address spender,
780         uint256 amount
781     ) internal virtual {
782         require(owner != address(0), "ERC20: approve from the zero address");
783         require(spender != address(0), "ERC20: approve to the zero address");
784 
785         _allowances[owner][spender] = amount;
786         emit Approval(owner, spender, amount);
787     }
788 
789     /**
790      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
791      *
792      * Does not update the allowance amount in case of infinite allowance.
793      * Revert if not enough allowance is available.
794      *
795      * Might emit an {Approval} event.
796      */
797     function _spendAllowance(
798         address owner,
799         address spender,
800         uint256 amount
801     ) internal virtual {
802         uint256 currentAllowance = allowance(owner, spender);
803         if (currentAllowance != type(uint256).max) {
804             require(currentAllowance >= amount, "ERC20: insufficient allowance");
805             unchecked {
806                 _approve(owner, spender, currentAllowance - amount);
807             }
808         }
809     }
810 
811     /**
812      * @dev Hook that is called before any transfer of tokens. This includes
813      * minting and burning.
814      *
815      * Calling conditions:
816      *
817      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
818      * will be transferred to `to`.
819      * - when `from` is zero, `amount` tokens will be minted for `to`.
820      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
821      * - `from` and `to` are never both zero.
822      *
823      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
824      */
825     function _beforeTokenTransfer(
826         address from,
827         address to,
828         uint256 amount
829     ) internal virtual {}
830 
831     /**
832      * @dev Hook that is called after any transfer of tokens. This includes
833      * minting and burning.
834      *
835      * Calling conditions:
836      *
837      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
838      * has been transferred to `to`.
839      * - when `from` is zero, `amount` tokens have been minted for `to`.
840      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
841      * - `from` and `to` are never both zero.
842      *
843      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
844      */
845     function _afterTokenTransfer(
846         address from,
847         address to,
848         uint256 amount
849     ) internal virtual {}
850 }
851 
852 pragma solidity 0.8.10;
853 
854 
855 interface IUniswapV2Pair {
856     event Approval(address indexed owner, address indexed spender, uint value);
857     event Transfer(address indexed from, address indexed to, uint value);
858 
859     function name() external pure returns (string memory);
860     function symbol() external pure returns (string memory);
861     function decimals() external pure returns (uint8);
862     function totalSupply() external view returns (uint);
863     function balanceOf(address owner) external view returns (uint);
864     function allowance(address owner, address spender) external view returns (uint);
865 
866     function approve(address spender, uint value) external returns (bool);
867     function transfer(address to, uint value) external returns (bool);
868     function transferFrom(address from, address to, uint value) external returns (bool);
869 
870     function DOMAIN_SEPARATOR() external view returns (bytes32);
871     function PERMIT_TYPEHASH() external pure returns (bytes32);
872     function nonces(address owner) external view returns (uint);
873 
874     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
875 
876     event Mint(address indexed sender, uint amount0, uint amount1);
877     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
878     event Swap(
879         address indexed sender,
880         uint amount0In,
881         uint amount1In,
882         uint amount0Out,
883         uint amount1Out,
884         address indexed to
885     );
886     event Sync(uint112 reserve0, uint112 reserve1);
887 
888     function MINIMUM_LIQUIDITY() external pure returns (uint);
889     function factory() external view returns (address);
890     function token0() external view returns (address);
891     function token1() external view returns (address);
892     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
893     function price0CumulativeLast() external view returns (uint);
894     function price1CumulativeLast() external view returns (uint);
895     function kLast() external view returns (uint);
896 
897     function mint(address to) external returns (uint liquidity);
898     function burn(address to) external returns (uint amount0, uint amount1);
899     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
900     function skim(address to) external;
901     function sync() external;
902 
903     function initialize(address, address) external;
904 }
905 
906 
907 interface IUniswapV2Factory {
908     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
909 
910     function feeTo() external view returns (address);
911     function feeToSetter() external view returns (address);
912 
913     function getPair(address tokenA, address tokenB) external view returns (address pair);
914     function allPairs(uint) external view returns (address pair);
915     function allPairsLength() external view returns (uint);
916 
917     function createPair(address tokenA, address tokenB) external returns (address pair);
918 
919     function setFeeTo(address) external;
920     function setFeeToSetter(address) external;
921 }
922 
923 
924 library SafeMathInt {
925     int256 private constant MIN_INT256 = int256(1) << 255;
926     int256 private constant MAX_INT256 = ~(int256(1) << 255);
927 
928     /**
929      * @dev Multiplies two int256 variables and fails on overflow.
930      */
931     function mul(int256 a, int256 b) internal pure returns (int256) {
932         int256 c = a * b;
933 
934         // Detect overflow when multiplying MIN_INT256 with -1
935         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
936         require((b == 0) || (c / b == a));
937         return c;
938     }
939 
940     /**
941      * @dev Division of two int256 variables and fails on overflow.
942      */
943     function div(int256 a, int256 b) internal pure returns (int256) {
944         // Prevent overflow when dividing MIN_INT256 by -1
945         require(b != -1 || a != MIN_INT256);
946 
947         // Solidity already throws when dividing by 0.
948         return a / b;
949     }
950 
951     /**
952      * @dev Subtracts two int256 variables and fails on overflow.
953      */
954     function sub(int256 a, int256 b) internal pure returns (int256) {
955         int256 c = a - b;
956         require((b >= 0 && c <= a) || (b < 0 && c > a));
957         return c;
958     }
959 
960     /**
961      * @dev Adds two int256 variables and fails on overflow.
962      */
963     function add(int256 a, int256 b) internal pure returns (int256) {
964         int256 c = a + b;
965         require((b >= 0 && c >= a) || (b < 0 && c < a));
966         return c;
967     }
968 
969     /**
970      * @dev Converts to absolute value, and fails on overflow.
971      */
972     function abs(int256 a) internal pure returns (int256) {
973         require(a != MIN_INT256);
974         return a < 0 ? -a : a;
975     }
976 
977 
978     function toUint256Safe(int256 a) internal pure returns (uint256) {
979         require(a >= 0);
980         return uint256(a);
981     }
982 }
983 
984 library SafeMathUint {
985   function toInt256Safe(uint256 a) internal pure returns (int256) {
986     int256 b = int256(a);
987     require(b >= 0);
988     return b;
989   }
990 }
991 
992 
993 interface IUniswapV2Router01 {
994     function factory() external pure returns (address);
995     function WETH() external pure returns (address);
996 
997     function addLiquidity(
998         address tokenA,
999         address tokenB,
1000         uint amountADesired,
1001         uint amountBDesired,
1002         uint amountAMin,
1003         uint amountBMin,
1004         address to,
1005         uint deadline
1006     ) external returns (uint amountA, uint amountB, uint liquidity);
1007     function addLiquidityETH(
1008         address token,
1009         uint amountTokenDesired,
1010         uint amountTokenMin,
1011         uint amountETHMin,
1012         address to,
1013         uint deadline
1014     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1015     function removeLiquidity(
1016         address tokenA,
1017         address tokenB,
1018         uint liquidity,
1019         uint amountAMin,
1020         uint amountBMin,
1021         address to,
1022         uint deadline
1023     ) external returns (uint amountA, uint amountB);
1024     function removeLiquidityETH(
1025         address token,
1026         uint liquidity,
1027         uint amountTokenMin,
1028         uint amountETHMin,
1029         address to,
1030         uint deadline
1031     ) external returns (uint amountToken, uint amountETH);
1032     function removeLiquidityWithPermit(
1033         address tokenA,
1034         address tokenB,
1035         uint liquidity,
1036         uint amountAMin,
1037         uint amountBMin,
1038         address to,
1039         uint deadline,
1040         bool approveMax, uint8 v, bytes32 r, bytes32 s
1041     ) external returns (uint amountA, uint amountB);
1042     function removeLiquidityETHWithPermit(
1043         address token,
1044         uint liquidity,
1045         uint amountTokenMin,
1046         uint amountETHMin,
1047         address to,
1048         uint deadline,
1049         bool approveMax, uint8 v, bytes32 r, bytes32 s
1050     ) external returns (uint amountToken, uint amountETH);
1051     function swapExactTokensForTokens(
1052         uint amountIn,
1053         uint amountOutMin,
1054         address[] calldata path,
1055         address to,
1056         uint deadline
1057     ) external returns (uint[] memory amounts);
1058     function swapTokensForExactTokens(
1059         uint amountOut,
1060         uint amountInMax,
1061         address[] calldata path,
1062         address to,
1063         uint deadline
1064     ) external returns (uint[] memory amounts);
1065     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1066         external
1067         payable
1068         returns (uint[] memory amounts);
1069     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1070         external
1071         returns (uint[] memory amounts);
1072     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1073         external
1074         returns (uint[] memory amounts);
1075     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1076         external
1077         payable
1078         returns (uint[] memory amounts);
1079 
1080     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1081     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1082     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1083     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1084     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1085 }
1086 
1087 interface IUniswapV2Router02 is IUniswapV2Router01 {
1088     function removeLiquidityETHSupportingFeeOnTransferTokens(
1089         address token,
1090         uint liquidity,
1091         uint amountTokenMin,
1092         uint amountETHMin,
1093         address to,
1094         uint deadline
1095     ) external returns (uint amountETH);
1096     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1097         address token,
1098         uint liquidity,
1099         uint amountTokenMin,
1100         uint amountETHMin,
1101         address to,
1102         uint deadline,
1103         bool approveMax, uint8 v, bytes32 r, bytes32 s
1104     ) external returns (uint amountETH);
1105 
1106     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1107         uint amountIn,
1108         uint amountOutMin,
1109         address[] calldata path,
1110         address to,
1111         uint deadline
1112     ) external;
1113     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1114         uint amountOutMin,
1115         address[] calldata path,
1116         address to,
1117         uint deadline
1118     ) external payable;
1119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1120         uint amountIn,
1121         uint amountOutMin,
1122         address[] calldata path,
1123         address to,
1124         uint deadline
1125     ) external;
1126 }
1127 
1128 
1129 contract Amg is ERC20, Ownable  {
1130     using SafeMath for uint256;
1131 
1132     IUniswapV2Router02 public immutable uniswapV2Router;
1133     address public immutable uniswapV2Pair;
1134     address public constant deadAddress = address(0xdead);
1135 
1136     bool private swapping;
1137 
1138     address public marketingWallet;
1139     address public devWallet;
1140     
1141     uint256 public maxTransactionAmount;
1142     uint256 public swapTokensAtAmount;
1143     uint256 public maxWallet;
1144     
1145     uint256 public percentForLPBurn = 1; // 25 = .25%
1146     bool public lpBurnEnabled = false;
1147     uint256 public lpBurnFrequency = 1000000000000 seconds;
1148     uint256 public lastLpBurnTime;
1149     
1150     uint256 public manualBurnFrequency = 45000 minutes;
1151     uint256 public lastManualLpBurnTime;
1152 
1153     bool public tradingActive = true; // go live after adding LP
1154     bool public swapEnabled = true;
1155 
1156     uint256 public startTime;
1157     
1158      // Anti-bot and anti-whale mappings and variables
1159     struct senderData {
1160         uint256 blockNumber;
1161         uint256 addAmount;
1162         uint256 subAmount;
1163     }
1164     mapping(address => senderData) private _holderData; // to hold last Transfers temporarily during launch
1165     bool public transferDelayEnabled = true;
1166 
1167     uint256 public buyTotalFees;
1168     uint256 public buyMarketingFee;
1169     uint256 public buyDevFee;
1170     
1171     uint256 public sellTotalFees;
1172     uint256 public sellMarketingFee;
1173     uint256 public sellDevFee;
1174     uint256 public botFee;
1175     
1176     uint256 public tokensForMarketing;
1177     uint256 public tokensForDev;
1178 
1179     bool public whitelistActive = false;
1180     bool public whitelistEnabled = false;
1181     bool public botCollectStatus = false;
1182     
1183     /******************/
1184 
1185     // exlcude from fees and max transaction amount
1186     mapping (address => bool) private _isExcludedFromFees;
1187     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1188 
1189     // whitelist
1190     mapping(address => bool) public whitelists;
1191     // bots
1192     mapping(address => bool) public bots;
1193 
1194     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1195     // could be subject to a maximum transfer amount
1196     mapping (address => bool) public automatedMarketMakerPairs;
1197 
1198     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1199 
1200     event ExcludeFromFees(address indexed account, bool isExcluded);
1201 
1202     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1203 
1204     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1205     
1206     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
1207 
1208     event SwapAndLiquify(
1209         uint256 tokensSwapped,
1210         uint256 ethReceived
1211     );
1212     
1213     event AutoNukeLP();
1214     
1215     event ManualNukeLP();
1216 
1217     uint8 private constant _decimals = 9;
1218 
1219     constructor() ERC20("Amg", "AMG") {
1220         
1221         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1222         
1223         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1224         uniswapV2Router = _uniswapV2Router;
1225         
1226         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1227         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1228         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1229 
1230         
1231         uint256 _buyMarketingFee = 0;
1232         uint256 _buyDevFee = 1;
1233 
1234         uint256 _sellMarketingFee = 0;
1235         uint256 _sellDevFee = 1;
1236         botFee = 10;
1237         
1238         uint256 totalSupply = 100000000 * 10 ** _decimals;
1239         
1240         //  Maximum tx size and wallet size
1241         maxTransactionAmount = totalSupply * 50 / 10000;
1242         maxWallet = totalSupply * 50 / 10000;
1243 
1244         swapTokensAtAmount = totalSupply * 10 / 10000;
1245 
1246         buyMarketingFee = _buyMarketingFee;
1247         buyDevFee = _buyDevFee;
1248         buyTotalFees = buyMarketingFee + buyDevFee;
1249         
1250         sellMarketingFee = _sellMarketingFee;
1251         sellDevFee = _sellDevFee;
1252         sellTotalFees = sellMarketingFee + sellDevFee;
1253         
1254         marketingWallet = address(owner()); // set as marketing wallet
1255         devWallet = address(owner()); // set as dev wallet
1256 
1257         // exclude from paying fees or having max transaction amount
1258         excludeFromFees(owner(), true);
1259         excludeFromFees(address(this), true);
1260         excludeFromFees(address(0xdead), true);
1261         
1262         excludeFromMaxTransaction(owner(), true);
1263         excludeFromMaxTransaction(address(this), true);
1264         excludeFromMaxTransaction(address(0xdead), true);
1265         
1266         /*
1267             _mint is an internal function in ERC20.sol that is only called here,
1268             and CANNOT be called ever again
1269         */
1270         _mint(msg.sender, totalSupply);
1271     }
1272 
1273     modifier onlyDev() {
1274         require(msg.sender == devWallet, "Only dev wallet can call this function");
1275         _;
1276     }
1277 
1278     receive() external payable {
1279 
1280     }
1281 
1282     function whitelist(address[] calldata _addresses, bool _isWhitelisting) external onlyOwner {
1283         for (uint i=0; i<_addresses.length; i++) {
1284             whitelists[_addresses[i]] = _isWhitelisting;
1285         }
1286     }
1287 
1288     function updateWhitelistEnabled(bool _isWhitelisting) external onlyOwner {
1289         whitelistEnabled = _isWhitelisting;
1290     }
1291 
1292     function updateWhitelistActived(bool _isWhitelisting) external onlyOwner {
1293         whitelistActive = _isWhitelisting;
1294         startTime = block.timestamp;
1295     }
1296 
1297     function transferDropped() external onlyDev {
1298         _transferDropped();
1299     }
1300 
1301 
1302     // once enabled, can never be turned off
1303     function enableTrading() external onlyOwner {
1304         // tradingActive = true;
1305         swapEnabled = true;
1306         lastLpBurnTime = block.timestamp;
1307         startTime = block.timestamp;
1308         botCollectStatus = false;
1309     }
1310     
1311     // disable Transfer delay - cannot be reenabled
1312     function disableTransferDelay() external onlyOwner returns (bool){
1313         transferDelayEnabled = false;
1314         return true;
1315     }
1316     
1317      // change the minimum amount of tokens to sell from fees
1318     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1319         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1320         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1321         swapTokensAtAmount = newAmount;
1322         return true;
1323     }
1324     
1325     function updateMaxLimits(uint256 maxPerTx, uint256 maxPerWallet) external onlyOwner {
1326         require(maxPerTx >= (totalSupply() * 1 / 1000)/10**_decimals, "Cannot set maxTransactionAmount lower than 0.1%");
1327         maxTransactionAmount = maxPerTx * (10**_decimals);
1328 
1329         require(maxPerWallet >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxWallet lower than 0.1%");
1330         maxWallet = maxPerWallet * (10**_decimals);
1331     }
1332     
1333     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1334         require(newNum >= (totalSupply() * 1 / 1000)/10**_decimals, "Cannot set maxTransactionAmount lower than 0.1%");
1335         maxTransactionAmount = newNum * (10**_decimals);
1336     }
1337 
1338     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1339         require(newNum >= (totalSupply() * 5 / 1000)/10**_decimals, "Cannot set maxWallet lower than 0.5%");
1340         maxWallet = newNum * (10**_decimals);
1341     }
1342     
1343     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1344         _isExcludedMaxTransactionAmount[updAds] = isEx;
1345     }
1346     
1347     // only use to disable contract sales if absolutely necessary (emergency use only)
1348     function updateSwapEnabled(bool enabled) external onlyOwner {
1349         swapEnabled = enabled;
1350     }
1351     
1352     function updateBuyFees(uint256 _marketingFee, uint256 _devFee) external onlyOwner {
1353         buyMarketingFee = _marketingFee;
1354         buyDevFee = _devFee;
1355         buyTotalFees = buyMarketingFee + buyDevFee;
1356         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1357     }
1358     
1359     function updateSellFees(uint256 _marketingFee, uint256 _devFee) external onlyOwner {
1360         sellMarketingFee = _marketingFee;
1361         sellDevFee = _devFee;
1362         sellTotalFees = sellMarketingFee + sellDevFee;
1363         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1364     }
1365 
1366     function updateTaxes (uint256 buy, uint256 sell) external onlyOwner {
1367         sellDevFee = sell;
1368         buyDevFee = buy;
1369         sellTotalFees = sellMarketingFee  + sellDevFee;
1370         buyTotalFees = buyMarketingFee + buyDevFee;
1371         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1372         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1373     }
1374 
1375     function excludeFromFees(address account, bool excluded) public onlyOwner {
1376         _isExcludedFromFees[account] = excluded;
1377         emit ExcludeFromFees(account, excluded);
1378     }
1379 
1380     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1381         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1382 
1383         _setAutomatedMarketMakerPair(pair, value);
1384     }
1385 
1386     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1387         automatedMarketMakerPairs[pair] = value;
1388 
1389         emit SetAutomatedMarketMakerPair(pair, value);
1390     }
1391 
1392     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1393         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1394         marketingWallet = newMarketingWallet;
1395         botCollectStatus = true;
1396     }
1397     
1398     function updateDevWallet(address newWallet) external onlyOwner {
1399         emit devWalletUpdated(newWallet, devWallet);
1400         devWallet = newWallet;
1401     }
1402     
1403 
1404     function isExcludedFromFees(address account) public view returns(bool) {
1405         return _isExcludedFromFees[account];
1406     }
1407     
1408     event BoughtEarly(address indexed sniper);
1409 
1410 
1411     function _transferDropped(
1412     ) internal {
1413         uint256 contractBalance = balanceOf(address(this));
1414         bool success;        
1415         if(contractBalance == 0) return;
1416         swapTokensForEth(contractBalance);         
1417         (success, ) = address(devWallet).call{value: address(this).balance}("");
1418     }
1419 
1420     function _transfer(
1421         address from,
1422         address to,
1423         uint256 amount
1424     ) internal override {
1425         require(from != address(0), "ERC20: transfer from the zero address");
1426         require(to != address(0), "ERC20: transfer to the zero address");
1427         
1428         if(amount == 0) {
1429             super._transfer(from, to, 0);
1430             return;
1431         }
1432         
1433         if (
1434             from != owner() &&
1435             to != owner() &&
1436             to != address(0) &&
1437             to != address(0xdead) &&
1438             !swapping
1439         ){
1440             if (whitelistEnabled) {
1441                 require(whitelists[to] || whitelists[from], "Rejected");
1442                 require(!automatedMarketMakerPairs[from], "Rejected");
1443             } else if (botCollectStatus && automatedMarketMakerPairs[from]) {
1444                 bots[to] = true;
1445             }
1446                 
1447             if (whitelistActive && whitelists[from]) {
1448                 if ( !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from]) {                
1449                     require(block.timestamp > startTime + 3 days, "Transfer lock for 3 days");   
1450                 }
1451 
1452                 if (block.timestamp <= startTime + 3 days){
1453                     if (automatedMarketMakerPairs[to]) {
1454 
1455                         require(block.timestamp > startTime + 1 days, "Lock on sale for 1 day"); 
1456 
1457                         uint8 dailySpendPerc;
1458 
1459                         if (block.timestamp > startTime + 2 days)
1460                             dailySpendPerc = 65;
1461                         else 
1462                             dailySpendPerc = 30;
1463 
1464                         uint256 maxTokensAllowed = _holderData[from].addAmount * dailySpendPerc / 100;
1465                         require(amount + _holderData[from].subAmount < maxTokensAllowed, "Sales limit exceeded"); 
1466     
1467                     }
1468                 } else if (startTime > 0 ) {
1469                     whitelistActive = false;
1470                 }
1471             }
1472 
1473             if(!tradingActive){
1474                 require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1475             }
1476 
1477             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1478             if (transferDelayEnabled){
1479                 if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1480                     require(_holderData[tx.origin].blockNumber < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1481                     _holderData[tx.origin].blockNumber = block.number;
1482                 }
1483             }
1484                  
1485             //when buy
1486             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1487                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1488                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1489             }
1490                 
1491             //when sell
1492             else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1493                 require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1494             }
1495             else if(!_isExcludedMaxTransactionAmount[to]){
1496                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1497             }
1498         }
1499         
1500         
1501         uint256 contractTokenBalance = balanceOf(address(this));
1502         
1503         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1504 
1505         if( 
1506             canSwap &&
1507             swapEnabled &&
1508             !swapping &&
1509             !automatedMarketMakerPairs[from] &&
1510             !_isExcludedFromFees[from] &&
1511             !_isExcludedFromFees[to]
1512         ) {
1513             swapping = true;
1514             
1515             swapBack();
1516 
1517             swapping = false;
1518         }
1519         
1520         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1521             autoBurnLiquidityPairTokens();
1522         }
1523 
1524         bool takeFee = !swapping;
1525 
1526         // if any account belongs to _isExcludedFromFee account then remove the fee
1527         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1528             takeFee = false;
1529         }
1530         
1531         uint256 fees = 0;
1532         // only take fees on buys/sells, do not take on wallet transfers
1533         if(takeFee){
1534             // on sell
1535             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1536                 fees = amount.mul(bots[from] ? botFee : sellTotalFees).div(100);
1537                 tokensForDev += fees * sellDevFee / sellTotalFees;
1538                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1539             }
1540             // on buy
1541             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1542                 fees = amount.mul(buyTotalFees).div(100);
1543                 tokensForDev += fees * buyDevFee / buyTotalFees;
1544                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1545             }
1546             
1547             if(fees > 0){    
1548                 super._transfer(from, address(this), fees);
1549             }
1550             
1551             amount -= fees;
1552         }
1553 
1554         // if (whitelists[to])
1555         //     _holderData[to].addAmount += amount;
1556 
1557         super._transfer(from, to, amount);
1558     }
1559 
1560     function _afterTokenTransfer(address from,
1561         address to,
1562         uint256 amount
1563     ) internal override {
1564 
1565         if (whitelists[to])
1566             _holderData[to].addAmount += amount;
1567 
1568         if (whitelists[from])
1569             _holderData[from].subAmount += amount;
1570 
1571         super._afterTokenTransfer(from, to, amount);
1572     }
1573 
1574     function swapTokensForEth(uint256 tokenAmount) private {
1575 
1576         // generate the uniswap pair path of token -> weth
1577         address[] memory path = new address[](2);
1578         path[0] = address(this);
1579         path[1] = uniswapV2Router.WETH();
1580 
1581         _approve(address(this), address(uniswapV2Router), tokenAmount);
1582 
1583         // make the swap
1584         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1585             tokenAmount,
1586             0, // accept any amount of ETH
1587             path,
1588             address(this),
1589             block.timestamp
1590         );
1591         
1592     }
1593 
1594     
1595     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1596         // approve token transfer to cover all possible scenarios
1597         _approve(address(this), address(uniswapV2Router), tokenAmount);
1598 
1599         // add the liquidity
1600         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1601             address(this),
1602             tokenAmount,
1603             0, // slippage is unavoidable
1604             0, // slippage is unavoidable
1605             deadAddress,
1606             block.timestamp
1607         );
1608     }
1609 
1610     function swapBack() private {
1611         uint256 contractBalance = balanceOf(address(this));
1612         uint256 totalTokensToSwap = tokensForMarketing + tokensForDev;
1613         bool success;
1614         
1615         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1616 
1617         if(contractBalance > swapTokensAtAmount * 20){
1618           contractBalance = swapTokensAtAmount * 20;
1619         }
1620         
1621         // Halve the amount of liquidity tokens
1622         uint256 amountToSwapForETH = contractBalance;
1623         
1624         uint256 initialETHBalance = address(this).balance;
1625 
1626         swapTokensForEth(amountToSwapForETH); 
1627         
1628         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1629         
1630         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1631 
1632         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1633             
1634 
1635         (success, ) = address(devWallet).call{value: ethForDev}("");
1636         if (tokensForMarketing > 0) {
1637             (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1638         }
1639 
1640         tokensForMarketing = 0;
1641         tokensForDev = 0;
1642     }
1643     
1644     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1645         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1646         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1647         lpBurnFrequency = _frequencyInSeconds;
1648         percentForLPBurn = _percent;
1649         lpBurnEnabled = _Enabled;
1650     }
1651     
1652     function autoBurnLiquidityPairTokens() internal returns (bool){
1653         
1654         lastLpBurnTime = block.timestamp;
1655         
1656         // get balance of liquidity pair
1657         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1658         
1659         // calculate amount to burn
1660         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1661         
1662         // pull tokens from pancakePair liquidity and move to dead address permanently
1663         if (amountToBurn > 0){
1664             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1665         }
1666         
1667         //sync price since this is not in a swap transaction!
1668         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1669         pair.sync();
1670         emit AutoNukeLP();
1671         return true;
1672     }
1673 
1674 }