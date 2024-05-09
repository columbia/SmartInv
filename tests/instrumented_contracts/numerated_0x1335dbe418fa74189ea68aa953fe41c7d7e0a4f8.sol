1 /**
2 
3 Telegram: https://t.me/geminiboterc
4 Twitter: https://twitter.com/GeminiERC
5 Website: https://gemini-bot.app/
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10  
11 pragma solidity =0.8.17;
12 
13 /* pragma solidity ^0.8.0; */
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /* pragma solidity ^0.8.0; */
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor() {
35         _transferOwnership(_msgSender());
36     }
37 
38     /**
39      * @dev Returns the address of the current owner.
40      */
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         require(owner() == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     /**
54      * @dev Leaves the contract without owner. It will not be possible to call
55      * `onlyOwner` functions anymore. Can only be called by the current owner.
56      *
57      * NOTE: Renouncing ownership will leave the contract without an owner,
58      * thereby removing any functionality that is only available to the owner.
59      */
60     function renounceOwnership() public virtual onlyOwner {
61         _transferOwnership(address(0));
62     }
63 
64     /**
65      * @dev Transfers ownership of the contract to a new account (`newOwner`).
66      * Can only be called by the current owner.
67      */
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Internal function without access restriction.
76      */
77     function _transferOwnership(address newOwner) internal virtual {
78         address oldOwner = _owner;
79         _owner = newOwner;
80         emit OwnershipTransferred(oldOwner, newOwner);
81     }
82 }
83 
84 /* pragma solidity ^0.8.0; */
85 
86 /**
87  * @dev Interface of the ERC20 standard as defined in the EIP.
88  */
89 interface IERC20 {
90     /**
91      * @dev Returns the amount of tokens in existence.
92      */
93     function totalSupply() external view returns (uint256);
94 
95     /**
96      * @dev Returns the amount of tokens owned by `account`.
97      */
98     function balanceOf(address account) external view returns (uint256);
99 
100     /**
101      * @dev Moves `amount` tokens from the caller's account to `recipient`.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transfer(address recipient, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Returns the remaining number of tokens that `spender` will be
111      * allowed to spend on behalf of `owner` through {transferFrom}. This is
112      * zero by default.
113      *
114      * This value changes when {approve} or {transferFrom} are called.
115      */
116     function allowance(address owner, address spender) external view returns (uint256);
117 
118     /**
119      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * IMPORTANT: Beware that changing an allowance with this method brings the risk
124      * that someone may use both the old and the new allowance by unfortunate
125      * transaction ordering. One possible solution to mitigate this race
126      * condition is to first reduce the spender's allowance to 0 and set the
127      * desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address spender, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Moves `amount` tokens from `sender` to `recipient` using the
136      * allowance mechanism. `amount` is then deducted from the caller's
137      * allowance.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 /* pragma solidity ^0.8.0; */
165 
166 /* import "../IERC20.sol"; */
167 
168 /**
169  * @dev Interface for the optional metadata functions from the ERC20 standard.
170  *
171  * _Available since v4.1._
172  */
173 interface IERC20Metadata is IERC20 {
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() external view returns (string memory);
178 
179     /**
180      * @dev Returns the symbol of the token.
181      */
182     function symbol() external view returns (string memory);
183 
184     /**
185      * @dev Returns the decimals places of the token.
186      */
187     function decimals() external view returns (uint8);
188 }
189 
190 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
191 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
192 
193 /* pragma solidity ^0.8.0; */
194 
195 /* import "./IERC20.sol"; */
196 /* import "./extensions/IERC20Metadata.sol"; */
197 /* import "../../utils/Context.sol"; */
198 
199 /**
200  * @dev Implementation of the {IERC20} interface.
201  *
202  * This implementation is agnostic to the way tokens are created. This means
203  * that a supply mechanism has to be added in a derived contract using {_mint}.
204  * For a generic mechanism see {ERC20PresetMinterPauser}.
205  *
206  * TIP: For a detailed writeup see our guide
207  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
208  * to implement supply mechanisms].
209  *
210  * We have followed general OpenZeppelin Contracts guidelines: functions revert
211  * instead returning `false` on failure. This behavior is nonetheless
212  * conventional and does not conflict with the expectations of ERC20
213  * applications.
214  *
215  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
216  * This allows applications to reconstruct the allowance for all accounts just
217  * by listening to said events. Other implementations of the EIP may not emit
218  * these events, as it isn't required by the specification.
219  *
220  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
221  * functions have been added to mitigate the well-known issues around setting
222  * allowances. See {IERC20-approve}.
223  */
224 contract ERC20 is Context, IERC20, IERC20Metadata {
225     mapping(address => uint256) private _balances;
226 
227     mapping(address => mapping(address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233 
234     /**
235      * @dev Sets the values for {name} and {symbol}.
236      *
237      * The default value of {decimals} is 18. To select a different value for
238      * {decimals} you should overload it.
239      *
240      * All two of these values are immutable: they can only be set once during
241      * construction.
242      */
243     constructor(string memory name_, string memory symbol_) {
244         _name = name_;
245         _symbol = symbol_;
246     }
247 
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() public view virtual override returns (string memory) {
252         return _name;
253     }
254 
255     /**
256      * @dev Returns the symbol of the token, usually a shorter version of the
257      * name.
258      */
259     function symbol() public view virtual override returns (string memory) {
260         return _symbol;
261     }
262 
263     /**
264      * @dev Returns the number of decimals used to get its user representation.
265      * For example, if `decimals` equals `2`, a balance of `505` tokens should
266      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
267      *
268      * Tokens usually opt for a value of 18, imitating the relationship between
269      * Ether and Wei. This is the value {ERC20} uses, unless this function is
270      * overridden;
271      *
272      * NOTE: This information is only used for _display_ purposes: it in
273      * no way affects any of the arithmetic of the contract, including
274      * {IERC20-balanceOf} and {IERC20-transfer}.
275      */
276     function decimals() public view virtual override returns (uint8) {
277         return 18;
278     }
279 
280     /**
281      * @dev See {IERC20-totalSupply}.
282      */
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See {IERC20-balanceOf}.
289      */
290     function balanceOf(address account) public view virtual override returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See {IERC20-transfer}.
296      *
297      * Requirements:
298      *
299      * - `recipient` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-allowance}.
309      */
310     function allowance(address owner, address spender) public view virtual override returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See {IERC20-approve}.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         _approve(_msgSender(), spender, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-transferFrom}.
328      *
329      * Emits an {Approval} event indicating the updated allowance. This is not
330      * required by the EIP. See the note at the beginning of {ERC20}.
331      *
332      * Requirements:
333      *
334      * - `sender` and `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      * - the caller must have allowance for ``sender``'s tokens of at least
337      * `amount`.
338      */
339     function transferFrom(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) public virtual override returns (bool) {
344         _transfer(sender, recipient, amount);
345 
346         uint256 currentAllowance = _allowances[sender][_msgSender()];
347         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
348         unchecked {
349             _approve(sender, _msgSender(), currentAllowance - amount);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Atomically increases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
369         return true;
370     }
371 
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
387         uint256 currentAllowance = _allowances[_msgSender()][spender];
388         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
389         unchecked {
390             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
391         }
392 
393         return true;
394     }
395 
396     /**
397      * @dev Moves `amount` of tokens from `sender` to `recipient`.
398      *
399      * This internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(
411         address sender,
412         address recipient,
413         uint256 amount
414     ) internal virtual {
415         require(sender != address(0), "ERC20: transfer from the zero address");
416         require(recipient != address(0), "ERC20: transfer to the zero address");
417 
418         _beforeTokenTransfer(sender, recipient, amount);
419 
420         uint256 senderBalance = _balances[sender];
421         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
422         unchecked {
423             _balances[sender] = senderBalance - amount;
424         }
425         _balances[recipient] += amount;
426 
427         emit Transfer(sender, recipient, amount);
428 
429         _afterTokenTransfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `account` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal virtual {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _beforeTokenTransfer(address(0), account, amount);
445 
446         _totalSupply += amount;
447         _balances[account] += amount;
448         emit Transfer(address(0), account, amount);
449 
450         _afterTokenTransfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _beforeTokenTransfer(account, address(0), amount);
468 
469         uint256 accountBalance = _balances[account];
470         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
471         unchecked {
472             _balances[account] = accountBalance - amount;
473         }
474         _totalSupply -= amount;
475 
476         emit Transfer(account, address(0), amount);
477 
478         _afterTokenTransfer(account, address(0), amount);
479     }
480 
481     /**
482      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
483      *
484      * This internal function is equivalent to `approve`, and can be used to
485      * e.g. set automatic allowances for certain subsystems, etc.
486      *
487      * Emits an {Approval} event.
488      *
489      * Requirements:
490      *
491      * - `owner` cannot be the zero address.
492      * - `spender` cannot be the zero address.
493      */
494     function _approve(
495         address owner,
496         address spender,
497         uint256 amount
498     ) internal virtual {
499         require(owner != address(0), "ERC20: approve from the zero address");
500         require(spender != address(0), "ERC20: approve to the zero address");
501 
502         _allowances[owner][spender] = amount;
503         emit Approval(owner, spender, amount);
504     }
505 
506     /**
507      * @dev Hook that is called before any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * will be transferred to `to`.
514      * - when `from` is zero, `amount` tokens will be minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _beforeTokenTransfer(
521         address from,
522         address to,
523         uint256 amount
524     ) internal virtual {}
525 
526     /**
527      * @dev Hook that is called after any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * has been transferred to `to`.
534      * - when `from` is zero, `amount` tokens have been minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _afterTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 }
546 
547 /* pragma solidity ^0.8.0; */
548 
549 // CAUTION
550 // This version of SafeMath should only be used with Solidity 0.8 or later,
551 // because it relies on the compiler's built in overflow checks.
552 
553 /**
554  * @dev Wrappers over Solidity's arithmetic operations.
555  *
556  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
557  * now has built in overflow checking.
558  */
559 library SafeMath {
560     /**
561      * @dev Returns the addition of two unsigned integers, with an overflow flag.
562      *
563      * _Available since v3.4._
564      */
565     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
566         unchecked {
567             uint256 c = a + b;
568             if (c < a) return (false, 0);
569             return (true, c);
570         }
571     }
572 
573     /**
574      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
575      *
576      * _Available since v3.4._
577      */
578     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         unchecked {
580             if (b > a) return (false, 0);
581             return (true, a - b);
582         }
583     }
584 
585     /**
586      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
587      *
588      * _Available since v3.4._
589      */
590     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
593             // benefit is lost if 'b' is also tested.
594             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
595             if (a == 0) return (true, 0);
596             uint256 c = a * b;
597             if (c / a != b) return (false, 0);
598             return (true, c);
599         }
600     }
601 
602     /**
603      * @dev Returns the division of two unsigned integers, with a division by zero flag.
604      *
605      * _Available since v3.4._
606      */
607     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             if (b == 0) return (false, 0);
610             return (true, a / b);
611         }
612     }
613 
614     /**
615      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b == 0) return (false, 0);
622             return (true, a % b);
623         }
624     }
625 
626     /**
627      * @dev Returns the addition of two unsigned integers, reverting on
628      * overflow.
629      *
630      * Counterpart to Solidity's `+` operator.
631      *
632      * Requirements:
633      *
634      * - Addition cannot overflow.
635      */
636     function add(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a + b;
638     }
639 
640     /**
641      * @dev Returns the subtraction of two unsigned integers, reverting on
642      * overflow (when the result is negative).
643      *
644      * Counterpart to Solidity's `-` operator.
645      *
646      * Requirements:
647      *
648      * - Subtraction cannot overflow.
649      */
650     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
651         return a - b;
652     }
653 
654     /**
655      * @dev Returns the multiplication of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `*` operator.
659      *
660      * Requirements:
661      *
662      * - Multiplication cannot overflow.
663      */
664     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a * b;
666     }
667 
668     /**
669      * @dev Returns the integer division of two unsigned integers, reverting on
670      * division by zero. The result is rounded towards zero.
671      *
672      * Counterpart to Solidity's `/` operator.
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function div(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a / b;
680     }
681 
682     /**
683      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
684      * reverting when dividing by zero.
685      *
686      * Counterpart to Solidity's `%` operator. This function uses a `revert`
687      * opcode (which leaves remaining gas untouched) while Solidity uses an
688      * invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a % b;
696     }
697 
698     /**
699      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
700      * overflow (when the result is negative).
701      *
702      * CAUTION: This function is deprecated because it requires allocating memory for the error
703      * message unnecessarily. For custom revert reasons use {trySub}.
704      *
705      * Counterpart to Solidity's `-` operator.
706      *
707      * Requirements:
708      *
709      * - Subtraction cannot overflow.
710      */
711     function sub(
712         uint256 a,
713         uint256 b,
714         string memory errorMessage
715     ) internal pure returns (uint256) {
716         unchecked {
717             require(b <= a, errorMessage);
718             return a - b;
719         }
720     }
721 
722     /**
723      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
724      * division by zero. The result is rounded towards zero.
725      *
726      * Counterpart to Solidity's `/` operator. Note: this function uses a
727      * `revert` opcode (which leaves remaining gas untouched) while Solidity
728      * uses an invalid opcode to revert (consuming all remaining gas).
729      *
730      * Requirements:
731      *
732      * - The divisor cannot be zero.
733      */
734     function div(
735         uint256 a,
736         uint256 b,
737         string memory errorMessage
738     ) internal pure returns (uint256) {
739         unchecked {
740             require(b > 0, errorMessage);
741             return a / b;
742         }
743     }
744 
745     /**
746      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
747      * reverting with custom message when dividing by zero.
748      *
749      * CAUTION: This function is deprecated because it requires allocating memory for the error
750      * message unnecessarily. For custom revert reasons use {tryMod}.
751      *
752      * Counterpart to Solidity's `%` operator. This function uses a `revert`
753      * opcode (which leaves remaining gas untouched) while Solidity uses an
754      * invalid opcode to revert (consuming all remaining gas).
755      *
756      * Requirements:
757      *
758      * - The divisor cannot be zero.
759      */
760     function mod(
761         uint256 a,
762         uint256 b,
763         string memory errorMessage
764     ) internal pure returns (uint256) {
765         unchecked {
766             require(b > 0, errorMessage);
767             return a % b;
768         }
769     }
770 }
771 
772 ////// src/IUniswapV2Factory.sol
773 /* pragma solidity 0.8.10; */
774 /* pragma experimental ABIEncoderV2; */
775 
776 interface IUniswapV2Factory {
777     event PairCreated(
778         address indexed token0,
779         address indexed token1,
780         address pair,
781         uint256
782     );
783 
784     function feeTo() external view returns (address);
785 
786     function feeToSetter() external view returns (address);
787 
788     function getPair(address tokenA, address tokenB)
789         external
790         view
791         returns (address pair);
792 
793     function allPairs(uint256) external view returns (address pair);
794 
795     function allPairsLength() external view returns (uint256);
796 
797     function createPair(address tokenA, address tokenB)
798         external
799         returns (address pair);
800 
801     function setFeeTo(address) external;
802 
803     function setFeeToSetter(address) external;
804 }
805 
806 /* pragma solidity 0.8.10; */
807 /* pragma experimental ABIEncoderV2; */
808 
809 interface IUniswapV2Pair {
810     event Approval(
811         address indexed owner,
812         address indexed spender,
813         uint256 value
814     );
815     event Transfer(address indexed from, address indexed to, uint256 value);
816 
817     function name() external pure returns (string memory);
818 
819     function symbol() external pure returns (string memory);
820 
821     function decimals() external pure returns (uint8);
822 
823     function totalSupply() external view returns (uint256);
824 
825     function balanceOf(address owner) external view returns (uint256);
826 
827     function allowance(address owner, address spender)
828         external
829         view
830         returns (uint256);
831 
832     function approve(address spender, uint256 value) external returns (bool);
833 
834     function transfer(address to, uint256 value) external returns (bool);
835 
836     function transferFrom(
837         address from,
838         address to,
839         uint256 value
840     ) external returns (bool);
841 
842     function DOMAIN_SEPARATOR() external view returns (bytes32);
843 
844     function PERMIT_TYPEHASH() external pure returns (bytes32);
845 
846     function nonces(address owner) external view returns (uint256);
847 
848     function permit(
849         address owner,
850         address spender,
851         uint256 value,
852         uint256 deadline,
853         uint8 v,
854         bytes32 r,
855         bytes32 s
856     ) external;
857 
858     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
859     event Burn(
860         address indexed sender,
861         uint256 amount0,
862         uint256 amount1,
863         address indexed to
864     );
865     event Swap(
866         address indexed sender,
867         uint256 amount0In,
868         uint256 amount1In,
869         uint256 amount0Out,
870         uint256 amount1Out,
871         address indexed to
872     );
873     event Sync(uint112 reserve0, uint112 reserve1);
874 
875     function MINIMUM_LIQUIDITY() external pure returns (uint256);
876 
877     function factory() external view returns (address);
878 
879     function token0() external view returns (address);
880 
881     function token1() external view returns (address);
882 
883     function getReserves()
884         external
885         view
886         returns (
887             uint112 reserve0,
888             uint112 reserve1,
889             uint32 blockTimestampLast
890         );
891 
892     function price0CumulativeLast() external view returns (uint256);
893 
894     function price1CumulativeLast() external view returns (uint256);
895 
896     function kLast() external view returns (uint256);
897 
898     function mint(address to) external returns (uint256 liquidity);
899 
900     function burn(address to)
901         external
902         returns (uint256 amount0, uint256 amount1);
903 
904     function swap(
905         uint256 amount0Out,
906         uint256 amount1Out,
907         address to,
908         bytes calldata data
909     ) external;
910 
911     function skim(address to) external;
912 
913     function sync() external;
914 
915     function initialize(address, address) external;
916 }
917 
918 /* pragma solidity 0.8.10; */
919 /* pragma experimental ABIEncoderV2; */
920 
921 interface IUniswapV2Router02 {
922     function factory() external pure returns (address);
923 
924     function WETH() external pure returns (address);
925 
926     function addLiquidity(
927         address tokenA,
928         address tokenB,
929         uint256 amountADesired,
930         uint256 amountBDesired,
931         uint256 amountAMin,
932         uint256 amountBMin,
933         address to,
934         uint256 deadline
935     )
936         external
937         returns (
938             uint256 amountA,
939             uint256 amountB,
940             uint256 liquidity
941         );
942 
943     function addLiquidityETH(
944         address token,
945         uint256 amountTokenDesired,
946         uint256 amountTokenMin,
947         uint256 amountETHMin,
948         address to,
949         uint256 deadline
950     )
951         external
952         payable
953         returns (
954             uint256 amountToken,
955             uint256 amountETH,
956             uint256 liquidity
957         );
958 
959     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
960         uint256 amountIn,
961         uint256 amountOutMin,
962         address[] calldata path,
963         address to,
964         uint256 deadline
965     ) external;
966 
967     function swapExactETHForTokensSupportingFeeOnTransferTokens(
968         uint256 amountOutMin,
969         address[] calldata path,
970         address to,
971         uint256 deadline
972     ) external payable;
973 
974     function swapExactTokensForETHSupportingFeeOnTransferTokens(
975         uint256 amountIn,
976         uint256 amountOutMin,
977         address[] calldata path,
978         address to,
979         uint256 deadline
980     ) external;
981 }
982 
983 /* pragma solidity >=0.8.10; */
984 
985 contract Gemini is ERC20, Ownable {
986     using SafeMath for uint256;
987 
988     IUniswapV2Router02 public immutable uniswapV2Router;
989     address public immutable uniswapV2Pair;
990 
991     address private constant ROUTER_ADDRESS = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
992     address public constant DEAD_ADDRESS = address(0xdead);
993     address public constant ZERO_ADDRESS = address(0x0);
994 
995     bool private swapping;
996 
997     address public marketingWallet;
998     address public devWallet;
999 
1000     uint256 public maxTransactionAmount;
1001     uint256 public swapTokensAtAmount;
1002     uint256 public maxWallet;
1003 
1004     uint256 public percentForLPBurn = 25; // 25 = .25%
1005     bool public lpBurnEnabled = false;
1006     uint256 public lpBurnFrequency = 3600 seconds;
1007     uint256 public lastLpBurnTime;
1008 
1009     uint256 public manualBurnFrequency = 30 minutes;
1010     uint256 public lastManualLpBurnTime;
1011 
1012     bool public limitsInEffect = true;
1013     bool public tradingActive = false;
1014     bool public swapEnabled = false;
1015     
1016     // Anti-bot and anti-whale mappings and variables
1017     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1018     bool public transferDelayEnabled = true;
1019     uint256 private launchBlock;
1020     uint256 private deadBlocks;
1021     mapping(address => bool) public blocked;
1022 
1023     uint256 public buyTotalFees;
1024     uint256 public buyMarketingFee;
1025     uint256 public buyLiquidityFee;
1026     uint256 public buyDevFee;
1027 
1028     uint256 public sellTotalFees;
1029     uint256 public sellMarketingFee;
1030     uint256 public sellLiquidityFee;
1031     uint256 public sellDevFee;
1032 
1033     uint256 public tokensForMarketing;
1034     uint256 public tokensForLiquidity;
1035     uint256 public tokensForDev;
1036 
1037     /******************/
1038 
1039     // exlcude from fees and max transaction amount
1040     mapping(address => bool) private _isExcludedFromFees;
1041     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1042 
1043     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1044     // could be subject to a maximum transfer amount
1045     mapping(address => bool) public automatedMarketMakerPairs;
1046 
1047     event UpdateUniswapV2Router(
1048         address indexed newAddress,
1049         address indexed oldAddress
1050     );
1051 
1052     event ExcludeFromFees(address indexed account, bool isExcluded);
1053 
1054     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1055 
1056     event marketingWalletUpdated(
1057         address indexed newWallet,
1058         address indexed oldWallet
1059     );
1060 
1061     event devWalletUpdated(
1062         address indexed newWallet,
1063         address indexed oldWallet
1064     );
1065 
1066     event SwapAndLiquify(
1067         uint256 tokensSwapped,
1068         uint256 ethReceived,
1069         uint256 tokensIntoLiquidity
1070     );
1071 
1072     event AutoNukeLP();
1073 
1074     event ManualNukeLP();
1075 
1076     constructor() ERC20("Gemini", "GEMINI") {
1077         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1078             ROUTER_ADDRESS
1079         );
1080 
1081         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1082         uniswapV2Router = _uniswapV2Router;
1083 
1084         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1085             .createPair(address(this), _uniswapV2Router.WETH());
1086         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1087         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1088 
1089         uint256 _buyMarketingFee = 74;
1090         uint256 _buyLiquidityFee = 1;
1091         uint256 _buyDevFee = 0;
1092 
1093         uint256 _sellMarketingFee = 39;
1094         uint256 _sellLiquidityFee = 1;
1095         uint256 _sellDevFee = 0;
1096 
1097         uint256 totalSupply = 1_000_000 * 1e18;
1098 
1099         maxTransactionAmount = 10_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1100         maxWallet = 10_000 * 1e18; // 1% from total supply maxWallet
1101         swapTokensAtAmount = (totalSupply * 1) / 1000; // 0.1% swap wallet
1102 
1103         buyMarketingFee = _buyMarketingFee;
1104         buyLiquidityFee = _buyLiquidityFee;
1105         buyDevFee = _buyDevFee;
1106         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1107 
1108         sellMarketingFee = _sellMarketingFee;
1109         sellLiquidityFee = _sellLiquidityFee;
1110         sellDevFee = _sellDevFee;
1111         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1112 
1113         marketingWallet = address(msg.sender); // set as marketing wallet
1114         devWallet = address(msg.sender); // set as dev wallet
1115 
1116         // exclude from paying fees or having max transaction amount
1117         excludeFromFees(owner(), true);
1118         excludeFromFees(address(this), true);
1119         excludeFromFees(DEAD_ADDRESS, true);
1120 
1121         excludeFromMaxTransaction(owner(), true);
1122         excludeFromMaxTransaction(address(this), true);
1123         excludeFromMaxTransaction(DEAD_ADDRESS, true);
1124 
1125         /*
1126             _mint is an internal function in ERC20.sol that is only called here,
1127             and CANNOT be called ever again
1128         */
1129         _mint(msg.sender, totalSupply);
1130     }
1131 
1132     receive() external payable {}
1133 
1134     // public true burn 
1135     function burn(uint256 amount) public {
1136         _burn(_msgSender(), amount);
1137     }
1138 
1139     // once enabled, can never be turned off
1140     function goLive(uint256 _deadBlocks) external onlyOwner {
1141         require(!tradingActive, "Token launched");
1142         tradingActive = true;
1143         launchBlock = block.number;
1144         swapEnabled = true;
1145         deadBlocks = _deadBlocks;
1146         lastLpBurnTime = block.timestamp;
1147     }
1148 
1149     // remove limits after token is stable
1150     function removeLimits() external onlyOwner returns (bool) {
1151         limitsInEffect = false;
1152         return true;
1153     }
1154 
1155     // disable Transfer delay - cannot be reenabled
1156     function disableTransferDelay() external onlyOwner returns (bool) {
1157         transferDelayEnabled = false;
1158         return true;
1159     }
1160 
1161     // change the minimum amount of tokens to sell from fees
1162     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner
1163         returns (bool)
1164     {
1165         require(
1166             newAmount >= (totalSupply() * 1) / 100000,
1167             "Swap amount cannot be lower than 0.001% total supply."
1168         );
1169         require(
1170             newAmount <= (totalSupply() * 5) / 1000,
1171             "Swap amount cannot be higher than 0.5% total supply."
1172         );
1173         swapTokensAtAmount = newAmount;
1174         return true;
1175     }
1176 
1177     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1178         require(
1179             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1180             "Cannot set maxTransactionAmount lower than 0.5%"
1181         );
1182         maxTransactionAmount = newNum * (10**18);
1183     }
1184 
1185     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1186         require(
1187             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1188             "Cannot set maxWallet lower than 0.5%"
1189         );
1190         maxWallet = newNum * (10**18);
1191     }
1192 
1193     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1194         _isExcludedMaxTransactionAmount[updAds] = isEx;
1195     }
1196 
1197     // only use to disable contract sales if absolutely necessary (emergency use only)
1198     function updateSwapEnabled(bool enabled) external onlyOwner {
1199         swapEnabled = enabled;
1200     }
1201 
1202     function updateBuyFees(
1203         uint256 _marketingFee,
1204         uint256 _liquidityFee,
1205         uint256 _devFee
1206     ) external onlyOwner {
1207         buyMarketingFee = _marketingFee;
1208         buyLiquidityFee = _liquidityFee;
1209         buyDevFee = _devFee;
1210         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1211         require(buyTotalFees <= 5, "Must keep fees at 15% or less");
1212     }
1213 
1214     function updateSellFees(
1215         uint256 _marketingFee,
1216         uint256 _liquidityFee,
1217         uint256 _devFee
1218     ) external onlyOwner {
1219         sellMarketingFee = _marketingFee;
1220         sellLiquidityFee = _liquidityFee;
1221         sellDevFee = _devFee;
1222         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1223         require(sellTotalFees <= 5, "Must keep fees at 15% or less");
1224     }
1225 
1226     function excludeFromFees(address account, bool excluded) public onlyOwner {
1227         _isExcludedFromFees[account] = excluded;
1228         emit ExcludeFromFees(account, excluded);
1229     }
1230 
1231     function setAutomatedMarketMakerPair(address pair, bool value)
1232         public
1233         onlyOwner
1234     {
1235         require(
1236             pair != uniswapV2Pair,
1237             "The pair cannot be removed from automatedMarketMakerPairs"
1238         );
1239 
1240         _setAutomatedMarketMakerPair(pair, value);
1241     }
1242 
1243     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1244         automatedMarketMakerPairs[pair] = value;
1245 
1246         emit SetAutomatedMarketMakerPair(pair, value);
1247     }
1248 
1249     function updateMarketingWallet(address newMarketingWallet)
1250         external
1251         onlyOwner
1252     {
1253         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1254         marketingWallet = newMarketingWallet;
1255     }
1256 
1257     function updateDevWallet(address newWallet) external onlyOwner {
1258         emit devWalletUpdated(newWallet, devWallet);
1259         devWallet = newWallet;
1260     }
1261 
1262     function isExcludedFromFees(address account) public view returns (bool) {
1263         return _isExcludedFromFees[account];
1264     }
1265 
1266     event BoughtEarly(address indexed sniper);
1267 
1268     function _transfer(
1269         address from,
1270         address to,
1271         uint256 amount
1272     ) internal override {
1273         require(to != DEAD_ADDRESS && 
1274                 to != ZERO_ADDRESS, "Use burn function for true burn");
1275         require(!blocked[from], "Sniper blocked");
1276 
1277         if (amount == 0) {
1278             super._transfer(from, to, 0);
1279             return;
1280         }
1281 
1282         if (limitsInEffect) {
1283             if (
1284                 from != owner() &&
1285                 to != owner() &&
1286                 to != ZERO_ADDRESS &&
1287                 to != DEAD_ADDRESS &&
1288                 !swapping
1289             ) {
1290                 if (!tradingActive) {
1291                     require(
1292                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1293                         "Trading is not active."
1294                     );
1295                 }
1296 
1297                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
1298                 to != ROUTER_ADDRESS && to != address(this) && to != address(uniswapV2Pair)){
1299                     blocked[to] = true;
1300                     emit BoughtEarly(to);
1301                 }
1302 
1303                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1304                 if (transferDelayEnabled) {
1305                     if (
1306                         to != owner() &&
1307                         to != ROUTER_ADDRESS &&
1308                         to != address(uniswapV2Pair)
1309                     ) {
1310                         require(
1311                             _holderLastTransferTimestamp[tx.origin] <
1312                                 block.number,
1313                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1314                         );
1315                         _holderLastTransferTimestamp[tx.origin] = block.number;
1316                     }
1317                 }
1318 
1319 
1320                 //when buy
1321                 if (
1322                     automatedMarketMakerPairs[from] &&
1323                     !_isExcludedMaxTransactionAmount[to]
1324                 ) {
1325                     require(
1326                         amount <= maxTransactionAmount,
1327                         "Buy transfer amount exceeds the maxTransactionAmount."
1328                     );
1329                     require(
1330                         amount + balanceOf(to) <= maxWallet,
1331                         "Max wallet exceeded"
1332                     );
1333                 }
1334                 //when sell
1335                 else if (
1336                     automatedMarketMakerPairs[to] &&
1337                     !_isExcludedMaxTransactionAmount[from]
1338                 ) {
1339                     require(
1340                         amount <= maxTransactionAmount,
1341                         "Sell transfer amount exceeds the maxTransactionAmount."
1342                     );
1343                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1344                     require(
1345                         amount + balanceOf(to) <= maxWallet,
1346                         "Max wallet exceeded"
1347                     );
1348                 }
1349             }
1350         }
1351 
1352         uint256 contractTokenBalance = balanceOf(address(this));
1353 
1354         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1355 
1356         if (
1357             canSwap &&
1358             swapEnabled &&
1359             !swapping &&
1360             !automatedMarketMakerPairs[from] &&
1361             !_isExcludedFromFees[from] &&
1362             !_isExcludedFromFees[to]
1363         ) {
1364             swapping = true;
1365 
1366             swapBack();
1367 
1368             swapping = false;
1369         }
1370 
1371         if (
1372             !swapping &&
1373             automatedMarketMakerPairs[to] &&
1374             lpBurnEnabled &&
1375             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1376             !_isExcludedFromFees[from]
1377         ) {
1378             autoBurnLiquidityPairTokens();
1379         }
1380 
1381         bool takeFee = !swapping;
1382 
1383         // if any account belongs to _isExcludedFromFee account then remove the fee
1384         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1385             takeFee = false;
1386         }
1387 
1388         uint256 fees = 0;
1389         // only take fees on buys/sells, do not take on wallet transfers
1390         if (takeFee) {
1391             // on sell
1392             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1393                 fees = amount.mul(sellTotalFees).div(100);
1394                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1395                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1396                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1397             }
1398             // on buy
1399             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1400                 fees = amount.mul(buyTotalFees).div(100);
1401                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1402                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1403                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1404             }
1405 
1406             if (fees > 0) {
1407                 super._transfer(from, address(this), fees);
1408             }
1409 
1410             amount -= fees;
1411         }
1412 
1413         super._transfer(from, to, amount);
1414     }
1415 
1416     function swapTokensForEth(uint256 tokenAmount) private {
1417         // generate the uniswap pair path of token -> weth
1418         address[] memory path = new address[](2);
1419         path[0] = address(this);
1420         path[1] = uniswapV2Router.WETH();
1421 
1422         _approve(address(this), address(uniswapV2Router), tokenAmount);
1423 
1424         // make the swap
1425         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1426             tokenAmount,
1427             0, // accept any amount of ETH
1428             path,
1429             address(this),
1430             block.timestamp
1431         );
1432     }
1433 
1434     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1435         // approve token transfer to cover all possible scenarios
1436         _approve(address(this), address(uniswapV2Router), tokenAmount);
1437 
1438         // add the liquidity
1439         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1440             address(this),
1441             tokenAmount,
1442             0, // slippage is unavoidable
1443             0, // slippage is unavoidable
1444             DEAD_ADDRESS,
1445             block.timestamp
1446         );
1447     }
1448 
1449     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
1450         for(uint256 i = 0;i<blockees.length;i++){
1451             address blockee = blockees[i];
1452             if(blockee != address(this) && 
1453                blockee != ROUTER_ADDRESS && 
1454                blockee != address(uniswapV2Pair))
1455                 blocked[blockee] = shouldBlock;
1456         }
1457     }
1458 
1459     function swapBack() private {
1460         uint256 contractBalance = balanceOf(address(this));
1461         uint256 totalTokensToSwap = tokensForLiquidity +
1462             tokensForMarketing +
1463             tokensForDev;
1464         bool success;
1465 
1466         if (contractBalance == 0 || totalTokensToSwap == 0) {
1467             return;
1468         }
1469 
1470         if (contractBalance > swapTokensAtAmount * 20) {
1471             contractBalance = swapTokensAtAmount * 20;
1472         }
1473 
1474         // Halve the amount of liquidity tokens
1475         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1476             totalTokensToSwap /
1477             2;
1478         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1479 
1480         uint256 initialETHBalance = address(this).balance;
1481 
1482         swapTokensForEth(amountToSwapForETH);
1483 
1484         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1485 
1486         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1487             totalTokensToSwap
1488         );
1489         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1490 
1491         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1492 
1493         tokensForLiquidity = 0;
1494         tokensForMarketing = 0;
1495         tokensForDev = 0;
1496 
1497         (success, ) = address(devWallet).call{value: ethForDev}("");
1498 
1499         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1500             addLiquidity(liquidityTokens, ethForLiquidity);
1501             emit SwapAndLiquify(
1502                 amountToSwapForETH,
1503                 ethForLiquidity,
1504                 tokensForLiquidity
1505             );
1506         }
1507 
1508         (success, ) = address(marketingWallet).call{
1509             value: address(this).balance
1510         }("");
1511     }
1512 
1513     function setAutoLPBurnSettings(
1514         uint256 _frequencyInSeconds,
1515         uint256 _percent,
1516         bool _Enabled
1517     ) external onlyOwner {
1518         require(
1519             _frequencyInSeconds >= 600,
1520             "cannot set buyback more often than every 10 minutes"
1521         );
1522         require(
1523             _percent <= 1000 && _percent >= 0,
1524             "Must set auto LP burn percent between 0% and 10%"
1525         );
1526         lpBurnFrequency = _frequencyInSeconds;
1527         percentForLPBurn = _percent;
1528         lpBurnEnabled = _Enabled;
1529     }
1530 
1531     function autoBurnLiquidityPairTokens() internal returns (bool) {
1532         lastLpBurnTime = block.timestamp;
1533 
1534         // get balance of liquidity pair
1535         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1536 
1537         // calculate amount to burn
1538         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1539             10000
1540         );
1541 
1542         // pull tokens from uniswapPair liquidity and perform true burn
1543         if (amountToBurn > 0) {
1544             _burn(uniswapV2Pair, amountToBurn);
1545         }
1546 
1547         //sync price since this is not in a swap transaction!
1548         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1549         pair.sync();
1550         emit AutoNukeLP();
1551         return true;
1552     }
1553     
1554     function manualBurnLiquidityPairTokens(uint256 percent)
1555         external
1556         onlyOwner
1557         returns (bool)
1558     {
1559         require(
1560             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1561             "Must wait for cooldown to finish"
1562         );
1563         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1564         lastManualLpBurnTime = block.timestamp;
1565 
1566         // get balance of liquidity pair
1567         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1568 
1569         // calculate amount to burn
1570         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1571 
1572         // pull tokens from uniswapPair liquidity and perform true burn
1573         if (amountToBurn > 0) {
1574             _burn(uniswapV2Pair, amountToBurn);
1575         }
1576 
1577         //sync price since this is not in a swap transaction!
1578         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1579         pair.sync();
1580         emit ManualNukeLP();
1581         return true;
1582     }
1583 }