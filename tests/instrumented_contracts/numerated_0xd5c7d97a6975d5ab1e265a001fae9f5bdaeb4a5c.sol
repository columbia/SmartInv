1 /**
2 
3 https://t.me/CyberMeV
4 
5 */
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 
12 pragma solidity >= 0.4.22 <0.9.0;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     /**
30      * @dev Initializes the contract setting the deployer as the initial owner.
31      */
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     /**
52      * @dev Leaves the contract without owner. It will not be possible to call
53      * `onlyOwner` functions anymore. Can only be called by the current owner.
54      *
55      * NOTE: Renouncing ownership will leave the contract without an owner,
56      * thereby removing any functionality that is only available to the owner.
57      */
58     function renounceOwnership() public virtual onlyOwner {
59         _transferOwnership(address(0));
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Can only be called by the current owner.
65      */
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         _transferOwnership(newOwner);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Internal function without access restriction.
74      */
75     function _transferOwnership(address newOwner) internal virtual {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
80 }
81 
82 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
83 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
84 
85 /* pragma solidity ^0.8.0; */
86 
87 /**
88  * @dev Interface of the ERC20 standard as defined in the EIP.
89  */
90 interface IERC20 {
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95 
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100 
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `recipient`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address recipient, uint256 amount) external returns (bool);
109 
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118 
119 
120     function approve(address spender, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Moves `amount` tokens from `sender` to `recipient` using the
124      * allowance mechanism. `amount` is then deducted from the caller's
125      * allowance.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(
132         address sender,
133         address recipient,
134         uint256 amount
135     ) external returns (bool);
136 
137     /**
138      * @dev Emitted when `value` tokens are moved from one account (`from`) to
139      * another (`to`).
140      *
141      * Note that `value` may be zero.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     /**
146      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
147      * a call to {approve}. `value` is the new allowance.
148      */
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
153 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
154 
155 /* pragma solidity ^0.8.0; */
156 
157 /* import "../IERC20.sol"; */
158 
159 /**
160  * @dev Interface for the optional metadata functions from the ERC20 standard.
161  *
162  * _Available since v4.1._
163  */
164 interface IERC20Metadata is IERC20 {
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() external view returns (string memory);
169 
170     /**
171      * @dev Returns the symbol of the token.
172      */
173     function symbol() external view returns (string memory);
174 
175     /**
176      * @dev Returns the decimals places of the token.
177      */
178     function decimals() external view returns (uint8);
179 }
180 
181 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
182 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
183 
184 /* pragma solidity ^0.8.0; */
185 
186 /* import "./IERC20.sol"; */
187 /* import "./extensions/IERC20Metadata.sol"; */
188 /* import "../../utils/Context.sol"; */
189 
190 /**
191  * @dev Implementation of the {IERC20} interface.
192  *
193  * This implementation is agnostic to the way tokens are created. This means
194  * that a supply mechanism has to be added in a derived contract using {_mint}.
195  * For a generic mechanism see {ERC20PresetMinterPauser}.
196  *
197  * TIP: For a detailed writeup see our guide
198  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
199  * to implement supply mechanisms].
200  *
201  * We have followed general OpenZeppelin Contracts guidelines: functions revert
202  * instead returning `false` on failure. This behavior is nonetheless
203  * conventional and does not conflict with the expectations of ERC20
204  * applications.
205  *
206  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
207  * This allows applications to reconstruct the allowance for all accounts just
208  * by listening to said events. Other implementations of the EIP may not emit
209  * these events, as it isn't required by the specification.
210  *
211  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
212  * functions have been added to mitigate the well-known issues around setting
213  * allowances. See {IERC20-approve}.
214  */
215 contract ERC20 is Context, IERC20, IERC20Metadata {
216     mapping(address => uint256) private _balances;
217 
218     mapping(address => mapping(address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     string private _name;
223     string private _symbol;
224 
225     /**
226      * @dev Sets the values for {name} and {symbol}.
227      *
228      * The default value of {decimals} is 18. To select a different value for
229      * {decimals} you should overload it.
230      *
231      * All two of these values are immutable: they can only be set once during
232      * construction.
233      */
234     constructor(string memory name_, string memory symbol_) {
235         _name = name_;
236         _symbol = symbol_;
237     }
238 
239     /**
240      * @dev Returns the name of the token.
241      */
242     function name() public view virtual override returns (string memory) {
243         return _name;
244     }
245 
246     /**
247      * @dev Returns the symbol of the token, usually a shorter version of the
248      * name.
249      */
250     function symbol() public view virtual override returns (string memory) {
251         return _symbol;
252     }
253 
254     /**
255      * @dev Returns the number of decimals used to get its user representation.
256      * For example, if `decimals` equals `2`, a balance of `505` tokens should
257      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
258      *
259      * Tokens usually opt for a value of 18, imitating the relationship between
260      * Ether and Wei. This is the value {ERC20} uses, unless this function is
261      * overridden;
262      *
263      * NOTE: This information is only used for _display_ purposes: it in
264      * no way affects any of the arithmetic of the contract, including
265      * {IERC20-balanceOf} and {IERC20-transfer}.
266      */
267     function decimals() public view virtual override returns (uint8) {
268         return 18;
269     }
270 
271     /**
272      * @dev See {IERC20-totalSupply}.
273      */
274     function totalSupply() public view virtual override returns (uint256) {
275         return _totalSupply;
276     }
277 
278     /**
279      * @dev See {IERC20-balanceOf}.
280      */
281     function balanceOf(address account) public view virtual override returns (uint256) {
282         return _balances[account];
283     }
284 
285     /**
286      * @dev See {IERC20-transfer}.
287      *
288      * Requirements:
289      *
290      * - `recipient` cannot be the zero address.
291      * - the caller must have a balance of at least `amount`.
292      */
293     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
294         _transfer(_msgSender(), recipient, amount);
295         return true;
296     }
297 
298     /**
299      * @dev See {IERC20-allowance}.
300      */
301     function allowance(address owner, address spender) public view virtual override returns (uint256) {
302         return _allowances[owner][spender];
303     }
304 
305     /**
306      * @dev See {IERC20-approve}.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function approve(address spender, uint256 amount) public virtual override returns (bool) {
313         _approve(_msgSender(), spender, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-transferFrom}.
319      *
320      * Emits an {Approval} event indicating the updated allowance. This is not
321      * required by the EIP. See the note at the beginning of {ERC20}.
322      *
323      * Requirements:
324      *
325      * - `sender` and `recipient` cannot be the zero address.
326      * - `sender` must have a balance of at least `amount`.
327      * - the caller must have allowance for ``sender``'s tokens of at least
328      * `amount`.
329      */
330     function transferFrom(
331         address sender,
332         address recipient,
333         uint256 amount
334     ) public virtual override returns (bool) {
335         _transfer(sender, recipient, amount);
336 
337         uint256 currentAllowance = _allowances[sender][_msgSender()];
338         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
339         unchecked {
340             _approve(sender, _msgSender(), currentAllowance - amount);
341         }
342 
343         return true;
344     }
345 
346     /**
347      * @dev Atomically increases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
360         return true;
361     }
362 
363     /**
364      * @dev Atomically decreases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      * - `spender` must have allowance for the caller of at least
375      * `subtractedValue`.
376      */
377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378         uint256 currentAllowance = _allowances[_msgSender()][spender];
379         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
380         unchecked {
381             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Moves `amount` of tokens from `sender` to `recipient`.
389      *
390      * This internal function is equivalent to {transfer}, and can be used to
391      * e.g. implement automatic token fees, slashing mechanisms, etc.
392      *
393      * Emits a {Transfer} event.
394      *
395      * Requirements:
396      *
397      * - `sender` cannot be the zero address.
398      * - `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `amount`.
400      */
401     function _transfer(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) internal virtual {
406         require(sender != address(0), "ERC20: transfer from the zero address");
407         require(recipient != address(0), "ERC20: transfer to the zero address");
408 
409         _beforeTokenTransfer(sender, recipient, amount);
410 
411         uint256 senderBalance = _balances[sender];
412         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
413         unchecked {
414             _balances[sender] = senderBalance - amount;
415         }
416         _balances[recipient] += amount;
417 
418         emit Transfer(sender, recipient, amount);
419 
420         _afterTokenTransfer(sender, recipient, amount);
421     }
422 
423     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
424      * the total supply.
425      *
426      * Emits a {Transfer} event with `from` set to the zero address.
427      *
428      * Requirements:
429      *
430      * - `account` cannot be the zero address.
431      */
432     function _mint(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: mint to the zero address");
434 
435         _beforeTokenTransfer(address(0), account, amount);
436 
437         _totalSupply += amount;
438         _balances[account] += amount;
439         emit Transfer(address(0), account, amount);
440 
441         _afterTokenTransfer(address(0), account, amount);
442     }
443 
444     /**
445      * @dev Destroys `amount` tokens from `account`, reducing the
446      * total supply.
447      *
448      * Emits a {Transfer} event with `to` set to the zero address.
449      *
450      * Requirements:
451      *
452      * - `account` cannot be the zero address.
453      * - `account` must have at least `amount` tokens.
454      */
455     function _burn(address account, uint256 amount) internal virtual {
456         require(account != address(0), "ERC20: burn from the zero address");
457 
458         _beforeTokenTransfer(account, address(0), amount);
459 
460         uint256 accountBalance = _balances[account];
461         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
462         unchecked {
463             _balances[account] = accountBalance - amount;
464         }
465         _totalSupply -= amount;
466 
467         emit Transfer(account, address(0), amount);
468 
469         _afterTokenTransfer(account, address(0), amount);
470     }
471 
472     /**
473      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
474      *
475      * This internal function is equivalent to `approve`, and can be used to
476      * e.g. set automatic allowances for certain subsystems, etc.
477      *
478      * Emits an {Approval} event.
479      *
480      * Requirements:
481      *
482      * - `owner` cannot be the zero address.
483      * - `spender` cannot be the zero address.
484      */
485     function _approve(
486         address owner,
487         address spender,
488         uint256 amount
489     ) internal virtual {
490         require(owner != address(0), "ERC20: approve from the zero address");
491         require(spender != address(0), "ERC20: approve to the zero address");
492 
493         _allowances[owner][spender] = amount;
494         emit Approval(owner, spender, amount);
495     }
496 
497     /**
498      * @dev Hook that is called before any transfer of tokens. This includes
499      * minting and burning.
500      *
501      * Calling conditions:
502      *
503      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
504      * will be transferred to `to`.
505      * - when `from` is zero, `amount` tokens will be minted for `to`.
506      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
507      * - `from` and `to` are never both zero.
508      *
509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
510      */
511     function _beforeTokenTransfer(
512         address from,
513         address to,
514         uint256 amount
515     ) internal virtual {}
516 
517     /**
518      * @dev Hook that is called after any transfer of tokens. This includes
519      * minting and burning.
520      *
521      * Calling conditions:
522      *
523      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
524      * has been transferred to `to`.
525      * - when `from` is zero, `amount` tokens have been minted for `to`.
526      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
527      * - `from` and `to` are never both zero.
528      *
529      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
530      */
531     function _afterTokenTransfer(
532         address from,
533         address to,
534         uint256 amount
535     ) internal virtual {}
536 }
537 
538 
539 library SafeMath {
540     /**
541      * @dev Returns the addition of two unsigned integers, with an overflow flag.
542      *
543      * _Available since v3.4._
544      */
545     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
546         unchecked {
547             uint256 c = a + b;
548             if (c < a) return (false, 0);
549             return (true, c);
550         }
551     }
552 
553     /**
554      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
555      *
556      * _Available since v3.4._
557      */
558     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
559         unchecked {
560             if (b > a) return (false, 0);
561             return (true, a - b);
562         }
563     }
564 
565     /**
566      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
567      *
568      * _Available since v3.4._
569      */
570     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
573             // benefit is lost if 'b' is also tested.
574             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
575             if (a == 0) return (true, 0);
576             uint256 c = a * b;
577             if (c / a != b) return (false, 0);
578             return (true, c);
579         }
580     }
581 
582     /**
583      * @dev Returns the division of two unsigned integers, with a division by zero flag.
584      *
585      * _Available since v3.4._
586      */
587     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
588         unchecked {
589             if (b == 0) return (false, 0);
590             return (true, a / b);
591         }
592     }
593 
594     /**
595      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
596      *
597      * _Available since v3.4._
598      */
599     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             if (b == 0) return (false, 0);
602             return (true, a % b);
603         }
604     }
605 
606     /**
607      * @dev Returns the addition of two unsigned integers, reverting on
608      * overflow.
609      *
610      * Counterpart to Solidity's `+` operator.
611      *
612      * Requirements:
613      *
614      * - Addition cannot overflow.
615      */
616     function add(uint256 a, uint256 b) internal pure returns (uint256) {
617         return a + b;
618     }
619 
620     /**
621      * @dev Returns the subtraction of two unsigned integers, reverting on
622      * overflow (when the result is negative).
623      *
624      * Counterpart to Solidity's `-` operator.
625      *
626      * Requirements:
627      *
628      * - Subtraction cannot overflow.
629      */
630     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
631         return a - b;
632     }
633 
634     /**
635      * @dev Returns the multiplication of two unsigned integers, reverting on
636      * overflow.
637      *
638      * Counterpart to Solidity's `*` operator.
639      *
640      * Requirements:
641      *
642      * - Multiplication cannot overflow.
643      */
644     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a * b;
646     }
647 
648     /**
649      * @dev Returns the integer division of two unsigned integers, reverting on
650      * division by zero. The result is rounded towards zero.
651      *
652      * Counterpart to Solidity's `/` operator.
653      *
654      * Requirements:
655      *
656      * - The divisor cannot be zero.
657      */
658     function div(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a / b;
660     }
661 
662     /**
663      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
664      * reverting when dividing by zero.
665      *
666      * Counterpart to Solidity's `%` operator. This function uses a `revert`
667      * opcode (which leaves remaining gas untouched) while Solidity uses an
668      * invalid opcode to revert (consuming all remaining gas).
669      *
670      * Requirements:
671      *
672      * - The divisor cannot be zero.
673      */
674     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
675         return a % b;
676     }
677 
678     /**
679      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
680      * overflow (when the result is negative).
681      *
682      * CAUTION: This function is deprecated because it requires allocating memory for the error
683      * message unnecessarily. For custom revert reasons use {trySub}.
684      *
685      * Counterpart to Solidity's `-` operator.
686      *
687      * Requirements:
688      *
689      * - Subtraction cannot overflow.
690      */
691     function sub(
692         uint256 a,
693         uint256 b,
694         string memory errorMessage
695     ) internal pure returns (uint256) {
696         unchecked {
697             require(b <= a, errorMessage);
698             return a - b;
699         }
700     }
701 
702     /**
703      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
704      * division by zero. The result is rounded towards zero.
705      *
706      * Counterpart to Solidity's `/` operator. Note: this function uses a
707      * `revert` opcode (which leaves remaining gas untouched) while Solidity
708      * uses an invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function div(
715         uint256 a,
716         uint256 b,
717         string memory errorMessage
718     ) internal pure returns (uint256) {
719         unchecked {
720             require(b > 0, errorMessage);
721             return a / b;
722         }
723     }
724 
725     /**
726      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
727      * reverting with custom message when dividing by zero.
728      *
729      * CAUTION: This function is deprecated because it requires allocating memory for the error
730      * message unnecessarily. For custom revert reasons use {tryMod}.
731      *
732      * Counterpart to Solidity's `%` operator. This function uses a `revert`
733      * opcode (which leaves remaining gas untouched) while Solidity uses an
734      * invalid opcode to revert (consuming all remaining gas).
735      *
736      * Requirements:
737      *
738      * - The divisor cannot be zero.
739      */
740     function mod(
741         uint256 a,
742         uint256 b,
743         string memory errorMessage
744     ) internal pure returns (uint256) {
745         unchecked {
746             require(b > 0, errorMessage);
747             return a % b;
748         }
749     }
750 }
751 
752 /* pragma solidity 0.8.10; */
753 /* pragma experimental ABIEncoderV2; */
754 
755 interface IUniswapV2Factory {
756     event PairCreated(
757         address indexed token0,
758         address indexed token1,
759         address pair,
760         uint256
761     );
762 
763     function feeTo() external view returns (address);
764 
765     function feeToSetter() external view returns (address);
766 
767     function getPair(address tokenA, address tokenB)
768         external
769         view
770         returns (address pair);
771 
772     function allPairs(uint256) external view returns (address pair);
773 
774     function allPairsLength() external view returns (uint256);
775 
776     function createPair(address tokenA, address tokenB)
777         external
778         returns (address pair);
779 
780     function setFeeTo(address) external;
781 
782     function setFeeToSetter(address) external;
783 }
784 
785 /* pragma solidity 0.8.10; */
786 /* pragma experimental ABIEncoderV2; */
787 
788 interface IUniswapV2Pair {
789     event Approval(
790         address indexed owner,
791         address indexed spender,
792         uint256 value
793     );
794     event Transfer(address indexed from, address indexed to, uint256 value);
795 
796     function name() external pure returns (string memory);
797 
798     function symbol() external pure returns (string memory);
799 
800     function decimals() external pure returns (uint8);
801 
802     function totalSupply() external view returns (uint256);
803 
804     function balanceOf(address owner) external view returns (uint256);
805 
806     function allowance(address owner, address spender)
807         external
808         view
809         returns (uint256);
810 
811     function approve(address spender, uint256 value) external returns (bool);
812 
813     function transfer(address to, uint256 value) external returns (bool);
814 
815     function transferFrom(
816         address from,
817         address to,
818         uint256 value
819     ) external returns (bool);
820 
821     function DOMAIN_SEPARATOR() external view returns (bytes32);
822 
823     function PERMIT_TYPEHASH() external pure returns (bytes32);
824 
825     function nonces(address owner) external view returns (uint256);
826 
827     function permit(
828         address owner,
829         address spender,
830         uint256 value,
831         uint256 deadline,
832         uint8 v,
833         bytes32 r,
834         bytes32 s
835     ) external;
836 
837     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
838     event Burn(
839         address indexed sender,
840         uint256 amount0,
841         uint256 amount1,
842         address indexed to
843     );
844     event Swap(
845         address indexed sender,
846         uint256 amount0In,
847         uint256 amount1In,
848         uint256 amount0Out,
849         uint256 amount1Out,
850         address indexed to
851     );
852     event Sync(uint112 reserve0, uint112 reserve1);
853 
854     function MINIMUM_LIQUIDITY() external pure returns (uint256);
855 
856     function factory() external view returns (address);
857 
858     function token0() external view returns (address);
859 
860     function token1() external view returns (address);
861 
862     function getReserves()
863         external
864         view
865         returns (
866             uint112 reserve0,
867             uint112 reserve1,
868             uint32 blockTimestampLast
869         );
870 
871     function price0CumulativeLast() external view returns (uint256);
872 
873     function price1CumulativeLast() external view returns (uint256);
874 
875     function kLast() external view returns (uint256);
876 
877     function mint(address to) external returns (uint256 liquidity);
878 
879     function burn(address to)
880         external
881         returns (uint256 amount0, uint256 amount1);
882 
883     function swap(
884         uint256 amount0Out,
885         uint256 amount1Out,
886         address to,
887         bytes calldata data
888     ) external;
889 
890     function skim(address to) external;
891 
892     function sync() external;
893 
894     function initialize(address, address) external;
895 }
896 
897 /* pragma solidity 0.8.10; */
898 /* pragma experimental ABIEncoderV2; */
899 
900 interface IUniswapV2Router02 {
901     function factory() external pure returns (address);
902 
903     function WETH() external pure returns (address);
904 
905     function addLiquidity(
906         address tokenA,
907         address tokenB,
908         uint256 amountADesired,
909         uint256 amountBDesired,
910         uint256 amountAMin,
911         uint256 amountBMin,
912         address to,
913         uint256 deadline
914     )
915         external
916         returns (
917             uint256 amountA,
918             uint256 amountB,
919             uint256 liquidity
920         );
921 
922     function addLiquidityETH(
923         address token,
924         uint256 amountTokenDesired,
925         uint256 amountTokenMin,
926         uint256 amountETHMin,
927         address to,
928         uint256 deadline
929     )
930         external
931         payable
932         returns (
933             uint256 amountToken,
934             uint256 amountETH,
935             uint256 liquidity
936         );
937 
938     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
939         uint256 amountIn,
940         uint256 amountOutMin,
941         address[] calldata path,
942         address to,
943         uint256 deadline
944     ) external;
945 
946     function swapExactETHForTokensSupportingFeeOnTransferTokens(
947         uint256 amountOutMin,
948         address[] calldata path,
949         address to,
950         uint256 deadline
951     ) external payable;
952 
953     function swapExactTokensForETHSupportingFeeOnTransferTokens(
954         uint256 amountIn,
955         uint256 amountOutMin,
956         address[] calldata path,
957         address to,
958         uint256 deadline
959     ) external;
960 }
961 
962 /* pragma solidity >=0.8.10; */
963 
964 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
965 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
966 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
967 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
968 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
969 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
970 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
971 
972 contract CyberMEV is ERC20, Ownable {
973     using SafeMath for uint256;
974 
975     IUniswapV2Router02 public immutable uniswapV2Router;
976     address public immutable uniswapV2Pair;
977     address public constant deadAddress = address(0xdead);
978 
979     bool private swapping;
980 
981     address public marketingWallet;
982     address public devWallet;
983 
984     uint256 public maxTransactionAmount;
985     uint256 public swapTokensAtAmount;
986     uint256 public maxWallet;
987 
988     bool public limitsInEffect = true;
989     bool public tradingActive = false;
990     bool public swapEnabled = false;
991     bool private burnTax = false;
992 
993     // Anti-bot and anti-whale mappings and variables
994     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
995     mapping (address => uint256) private _firstBuyTimeStamp; // first buy!
996     bool public transferDelayEnabled = true;
997 
998     uint256 public buyTotalFees;
999     uint256 public buyMarketingFee;
1000     uint256 public buyDevFee;
1001 
1002     uint256 public sellTotalFees;
1003     uint256 public sellMarketingFee;
1004     uint256 public sellDevFee;
1005 
1006     uint256 public tokensForMarketing;
1007     uint256 public tokensForDev;
1008 
1009     /******************/
1010 
1011     // exlcude from fees and max transaction amount
1012     mapping(address => bool) private _isExcludedFromFees;
1013     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1014 
1015     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1016     // could be subject to a maximum transfer amount
1017     mapping(address => bool) public automatedMarketMakerPairs;
1018 
1019     event UpdateUniswapV2Router(
1020         address indexed newAddress,
1021         address indexed oldAddress
1022     );
1023 
1024     event ExcludeFromFees(address indexed account, bool isExcluded);
1025 
1026     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1027 
1028     event SwapAndLiquify(
1029         uint256 tokensSwapped,
1030         uint256 ethReceived,
1031         uint256 tokensIntoLiquidity
1032     );
1033 
1034     constructor() ERC20("Cyber MEV", "CYBER") {
1035         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1036             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1037         );
1038 
1039         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1040         uniswapV2Router = _uniswapV2Router;
1041 
1042         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1043             .createPair(address(this), _uniswapV2Router.WETH());
1044         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1045         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1046 
1047         uint256 _buyMarketingFee = 15;
1048         uint256 _buyDevFee = 15;
1049 
1050         uint256 _sellMarketingFee = 20;
1051         uint256 _sellDevFee = 20;
1052 
1053         uint256 totalSupply = 10000000 * 1e18;
1054         maxTransactionAmount = (totalSupply * 2) / 100;
1055         maxWallet = (totalSupply * 2) / 100; // 0.5% max wallet
1056         swapTokensAtAmount = (totalSupply * 4) / 1000; // 0.4% swap wallet
1057 
1058         buyMarketingFee = _buyMarketingFee;
1059         buyDevFee = _buyDevFee;
1060         buyTotalFees =  buyMarketingFee + buyDevFee;
1061 
1062         sellMarketingFee = _sellMarketingFee;
1063         sellDevFee = _sellDevFee;
1064         sellTotalFees = sellMarketingFee  + sellDevFee;
1065 
1066         marketingWallet = address(0xa3513B8C51E164A2532964eB4A4Dc2E42B806712); 
1067         devWallet = address(0x1B4559E5663766faBc00A4B6c78304644a1d8F6D); 
1068 
1069         // exclude from paying fees or having max transaction amount
1070         excludeFromFees(owner(), true);
1071         excludeFromFees(address(this), true);
1072         excludeFromFees(address(0xdead), true);
1073 
1074         excludeFromMaxTransaction(owner(), true);
1075         excludeFromMaxTransaction(address(this), true);
1076         excludeFromMaxTransaction(address(0xdead), true);
1077 
1078         /*
1079             _mint is an internal function in ERC20.sol that is only called here,
1080             and CANNOT be called ever again
1081         */
1082         _mint(msg.sender, totalSupply);
1083     }
1084 
1085     receive() external payable {}
1086 
1087     // once enabled, can never be turned off
1088     function enableTrading() external onlyOwner {
1089         tradingActive = true;
1090         swapEnabled = true;
1091     }
1092 
1093     // remove limits after token is stable
1094     function removeLimits() external onlyOwner returns (bool) {
1095         limitsInEffect = false;
1096         return true;
1097     }
1098 
1099     // disable Transfer delay - cannot be reenabled
1100     function disableTransferDelay() external onlyOwner returns (bool) {
1101         transferDelayEnabled = false;
1102         return true;
1103     }
1104 
1105     // change the minimum amount of tokens to sell from fees
1106     function updateSwapTokensAtAmount(uint256 newAmount)
1107         external
1108         onlyOwner
1109         returns (bool)
1110     {
1111         require(
1112             newAmount >= (totalSupply() * 1) / 100000,
1113             "Swap amount cannot be lower than 0.001% total supply."
1114         );
1115         require(
1116             newAmount <= (totalSupply() * 5) / 1000,
1117             "Swap amount cannot be higher than 0.5% total supply."
1118         );
1119         swapTokensAtAmount = newAmount;
1120         return true;
1121     }
1122 
1123     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1124         require(
1125             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1126             "Cannot set maxTransactionAmount lower than 0.5%"
1127         );
1128         maxTransactionAmount = newNum * (10**18);
1129     }
1130 
1131     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1132         require(
1133             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1134             "Cannot set maxWallet lower than 0.5%"
1135         );
1136         maxWallet = newNum * (10**18);
1137     }
1138 	
1139     function excludeFromMaxTransaction(address updAds, bool isEx)
1140         public
1141         onlyOwner
1142     {
1143         _isExcludedMaxTransactionAmount[updAds] = isEx;
1144     }
1145 
1146     // only use to disable contract sales if absolutely necessary (emergency use only)
1147     function updateSwapEnabled(bool enabled) external onlyOwner {
1148         swapEnabled = enabled;
1149     }
1150 
1151     function updateBuyFees(
1152         uint256 _marketingFee,
1153         uint256 _devFee
1154     ) external onlyOwner {
1155 		require(( _marketingFee + _devFee) <= 10, "Max BuyFee 10%");
1156         buyMarketingFee = _marketingFee;
1157         buyDevFee = _devFee;
1158         buyTotalFees =  buyMarketingFee + buyDevFee;
1159      }
1160 
1161     function updateSellFees(
1162         uint256 _marketingFee,
1163         uint256 _devFee
1164     ) external onlyOwner {
1165 		require((_marketingFee  + _devFee) <= 10, "Cant be more then 10%");
1166         sellMarketingFee = _marketingFee;
1167         sellDevFee = _devFee;
1168         sellTotalFees =  sellMarketingFee  + sellDevFee;
1169     }
1170 
1171 
1172     function excludeFromFees(address account, bool excluded) public onlyOwner {
1173         _isExcludedFromFees[account] = excluded;
1174         emit ExcludeFromFees(account, excluded);
1175     }
1176 
1177     function setAutomatedMarketMakerPair(address pair, bool value)
1178         public
1179         onlyOwner
1180     {
1181         require(
1182             pair != uniswapV2Pair,
1183             "The pair cannot be removed from automatedMarketMakerPairs"
1184         );
1185 
1186         _setAutomatedMarketMakerPair(pair, value);
1187     }
1188 
1189     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1190         automatedMarketMakerPairs[pair] = value;
1191 
1192         emit SetAutomatedMarketMakerPair(pair, value);
1193     }
1194 
1195     function isExcludedFromFees(address account) public view returns (bool) {
1196         return _isExcludedFromFees[account];
1197     }
1198 
1199     function _transfer(
1200         address from,
1201         address to,
1202         uint256 amount
1203     ) internal override {
1204         require(from != address(0), "ERC20: transfer from the zero address");
1205         require(to != address(0), "ERC20: transfer to the zero address");
1206 
1207         if (amount == 0) {
1208             super._transfer(from, to, 0);
1209             return;
1210         }
1211 
1212         if (limitsInEffect) {
1213             if (
1214                 from != owner() &&
1215                 to != owner() &&
1216                 to != address(0) &&
1217                 to != address(0xdead) &&
1218                 !swapping
1219             ) {
1220                 if (!tradingActive) {
1221                     require(
1222                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1223                         "Trading is not active."
1224                     );
1225                 }
1226 
1227                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1228                 if (transferDelayEnabled) {
1229                     if (
1230                         to != owner() &&
1231                         to != address(uniswapV2Router) &&
1232                         to != address(uniswapV2Pair)
1233                     ) {
1234                         require(
1235                             _holderLastTransferTimestamp[tx.origin] <
1236                                 block.number,
1237                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1238                         );
1239                         _holderLastTransferTimestamp[tx.origin] = block.number;
1240                     }
1241                 }
1242 
1243                 //when buy
1244                 if (
1245                     automatedMarketMakerPairs[from] &&
1246                     !_isExcludedMaxTransactionAmount[to]
1247                 ) {
1248                     require(
1249                         amount <= maxTransactionAmount,
1250                         "Buy transfer amount exceeds the maxTransactionAmount."
1251                     );
1252                     require(
1253                         amount + balanceOf(to) <= maxWallet,
1254                         "Max wallet exceeded"
1255                     );
1256                 }
1257                 //when sell
1258                 else if (
1259                     automatedMarketMakerPairs[to] &&
1260                     !_isExcludedMaxTransactionAmount[from]
1261                 ) {
1262                     require(
1263                         amount <= maxTransactionAmount,
1264                         "Sell transfer amount exceeds the maxTransactionAmount."
1265                     );
1266                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1267                     require(
1268                         amount + balanceOf(to) <= maxWallet,
1269                         "Max wallet exceeded"
1270                     );
1271                 }
1272             }
1273         }
1274 
1275         uint256 contractTokenBalance = balanceOf(address(this));
1276 
1277         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1278 
1279         if (
1280             canSwap &&
1281             swapEnabled &&
1282             !swapping &&
1283             !automatedMarketMakerPairs[from] &&
1284             !_isExcludedFromFees[from] &&
1285             !_isExcludedFromFees[to]
1286         ) {
1287             swapping = true;
1288 
1289             swapBack();
1290 
1291             swapping = false;
1292         }
1293 
1294         bool takeFee = !swapping;
1295 
1296         // if any account belongs to _isExcludedFromFee account then remove the fee
1297         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1298             takeFee = false;
1299         }
1300 
1301         uint256 fees = 0;
1302         // only take fees on buys/sells, do not take on wallet transfers
1303         if (takeFee) {
1304             // on sell
1305             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1306                 // if (_firstBuyTimeStamp[tx.origin] > 0 && block.timestamp.sub(_firstBuyTimeStamp[tx.origin]) <= 1 days) {
1307                 //     fees = amount.mul(sellTotalFees).div(100);
1308                 // }else{
1309                 fees = amount.mul(sellTotalFees).div(100);
1310                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1311                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1312             }
1313             // on buy
1314             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1315                 fees = amount.mul(buyTotalFees).div(100);
1316                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1317                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1318             }
1319 
1320             if (fees > 0) {
1321                 super._transfer(from, address(this), fees);
1322             }
1323 
1324             amount -= fees;
1325         }
1326 
1327         super._transfer(from, to, amount);
1328     }
1329 
1330     function swapTokensForEth(uint256 tokenAmount) private {
1331         // generate the uniswap pair path of token -> weth
1332         address[] memory path = new address[](2);
1333         path[0] = address(this);
1334         path[1] = uniswapV2Router.WETH();
1335 
1336         _approve(address(this), address(uniswapV2Router), tokenAmount);
1337 
1338         // make the swap
1339         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1340             tokenAmount,
1341             0, // accept any amount of ETH
1342             path,
1343             address(this),
1344             block.timestamp
1345         );
1346     }
1347 
1348     function recoverETH () external onlyOwner {
1349         payable(marketingWallet).transfer(address(this).balance);
1350     }
1351 
1352     function swapBack() private {
1353         uint256 contractBalance = balanceOf(address(this));
1354         uint256 totalTokensToSwap =   tokensForMarketing + tokensForDev;
1355         bool success;
1356 
1357         if (contractBalance == 0 || totalTokensToSwap == 0) {
1358             return;
1359         }
1360 
1361         if (contractBalance > swapTokensAtAmount * 20) {
1362             contractBalance = swapTokensAtAmount * 20;
1363         }
1364 
1365         // Halve the amount of liquidity tokens
1366         uint256 amountToSwapForETH = contractBalance;
1367 
1368         uint256 initialETHBalance = address(this).balance;
1369 
1370         swapTokensForEth(amountToSwapForETH);
1371         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1372 
1373         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1374         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1375 
1376         tokensForMarketing = 0;
1377         tokensForDev = 0;
1378 
1379         (success, ) = address(devWallet).call{value: ethForDev}("");
1380         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1381     }
1382 
1383 }