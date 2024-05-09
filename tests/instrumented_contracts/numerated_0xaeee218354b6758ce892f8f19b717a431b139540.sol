1 // File: seraph.sol
2 
3 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * NOTE: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public virtual onlyOwner {
50         _transferOwnership(address(0));
51     }
52 
53     /**
54      * @dev Transfers ownership of the contract to a new account (`newOwner`).
55      * Can only be called by the current owner.
56      */
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _transferOwnership(newOwner);
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Internal function without access restriction.
65      */
66     function _transferOwnership(address newOwner) internal virtual {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
74 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
75 
76 /* pragma solidity ^0.8.0; */
77 
78 /**
79  * @dev Interface of the ERC20 standard as defined in the EIP.
80  */
81 interface IERC20 {
82     /**
83      * @dev Returns the amount of tokens in existence.
84      */
85     function totalSupply() external view returns (uint256);
86 
87     /**
88      * @dev Returns the amount of tokens owned by `account`.
89      */
90     function balanceOf(address account) external view returns (uint256);
91 
92     /**
93      * @dev Moves `amount` tokens from the caller's account to `recipient`.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transfer(address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Returns the remaining number of tokens that `spender` will be
103      * allowed to spend on behalf of `owner` through {transferFrom}. This is
104      * zero by default.
105      *
106      * This value changes when {approve} or {transferFrom} are called.
107      */
108     function allowance(address owner, address spender) external view returns (uint256);
109 
110     /**
111      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * IMPORTANT: Beware that changing an allowance with this method brings the risk
116      * that someone may use both the old and the new allowance by unfortunate
117      * transaction ordering. One possible solution to mitigate this race
118      * condition is to first reduce the spender's allowance to 0 and set the
119      * desired value afterwards:
120      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address spender, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Moves `amount` tokens from `sender` to `recipient` using the
128      * allowance mechanism. `amount` is then deducted from the caller's
129      * allowance.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address sender,
137         address recipient,
138         uint256 amount
139     ) external returns (bool);
140 
141     /**
142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
143      * another (`to`).
144      *
145      * Note that `value` may be zero.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     /**
150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
151      * a call to {approve}. `value` is the new allowance.
152      */
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
157 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
158 
159 /* pragma solidity ^0.8.0; */
160 
161 /* import "../IERC20.sol"; */
162 
163 /**
164  * @dev Interface for the optional metadata functions from the ERC20 standard.
165  *
166  * _Available since v4.1._
167  */
168 interface IERC20Metadata is IERC20 {
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() external view returns (string memory);
173 
174     /**
175      * @dev Returns the symbol of the token.
176      */
177     function symbol() external view returns (string memory);
178 
179     /**
180      * @dev Returns the decimals places of the token.
181      */
182     function decimals() external view returns (uint8);
183 }
184 
185 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
186 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
187 
188 /* pragma solidity ^0.8.0; */
189 
190 /* import "./IERC20.sol"; */
191 /* import "./extensions/IERC20Metadata.sol"; */
192 /* import "../../utils/Context.sol"; */
193 
194 /**
195  * @dev Implementation of the {IERC20} interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using {_mint}.
199  * For a generic mechanism see {ERC20PresetMinterPauser}.
200  *
201  * TIP: For a detailed writeup see our guide
202  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
203  * to implement supply mechanisms].
204  *
205  * We have followed general OpenZeppelin Contracts guidelines: functions revert
206  * instead returning `false` on failure. This behavior is nonetheless
207  * conventional and does not conflict with the expectations of ERC20
208  * applications.
209  *
210  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See {IERC20-approve}.
218  */
219 contract ERC20 is Context, IERC20, IERC20Metadata {
220     mapping(address => uint256) private _balances;
221 
222     mapping(address => mapping(address => uint256)) private _allowances;
223 
224     uint256 private _totalSupply;
225 
226     string private _name;
227     string private _symbol;
228 
229     /**
230      * @dev Sets the values for {name} and {symbol}.
231      *
232      * The default value of {decimals} is 18. To select a different value for
233      * {decimals} you should overload it.
234      *
235      * All two of these values are immutable: they can only be set once during
236      * construction.
237      */
238     constructor(string memory name_, string memory symbol_) {
239         _name = name_;
240         _symbol = symbol_;
241     }
242 
243     /**
244      * @dev Returns the name of the token.
245      */
246     function name() public view virtual override returns (string memory) {
247         return _name;
248     }
249 
250     /**
251      * @dev Returns the symbol of the token, usually a shorter version of the
252      * name.
253      */
254     function symbol() public view virtual override returns (string memory) {
255         return _symbol;
256     }
257 
258     /**
259      * @dev Returns the number of decimals used to get its user representation.
260      * For example, if `decimals` equals `2`, a balance of `505` tokens should
261      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
262      *
263      * Tokens usually opt for a value of 18, imitating the relationship between
264      * Ether and Wei. This is the value {ERC20} uses, unless this function is
265      * overridden;
266      *
267      * NOTE: This information is only used for _display_ purposes: it in
268      * no way affects any of the arithmetic of the contract, including
269      * {IERC20-balanceOf} and {IERC20-transfer}.
270      */
271     function decimals() public view virtual override returns (uint8) {
272         return 18;
273     }
274 
275     /**
276      * @dev See {IERC20-totalSupply}.
277      */
278     function totalSupply() public view virtual override returns (uint256) {
279         return _totalSupply;
280     }
281 
282     /**
283      * @dev See {IERC20-balanceOf}.
284      */
285     function balanceOf(address account) public view virtual override returns (uint256) {
286         return _balances[account];
287     }
288 
289     /**
290      * @dev See {IERC20-transfer}.
291      *
292      * Requirements:
293      *
294      * - `recipient` cannot be the zero address.
295      * - the caller must have a balance of at least `amount`.
296      */
297     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
298         _transfer(_msgSender(), recipient, amount);
299         return true;
300     }
301 
302     /**
303      * @dev See {IERC20-allowance}.
304      */
305     function allowance(address owner, address spender) public view virtual override returns (uint256) {
306         return _allowances[owner][spender];
307     }
308 
309     /**
310      * @dev See {IERC20-approve}.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function approve(address spender, uint256 amount) public virtual override returns (bool) {
317         _approve(_msgSender(), spender, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-transferFrom}.
323      *
324      * Emits an {Approval} event indicating the updated allowance. This is not
325      * required by the EIP. See the note at the beginning of {ERC20}.
326      *
327      * Requirements:
328      *
329      * - `sender` and `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      * - the caller must have allowance for ``sender``'s tokens of at least
332      * `amount`.
333      */
334     function transferFrom(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) public virtual override returns (bool) {
339         _transfer(sender, recipient, amount);
340 
341         uint256 currentAllowance = _allowances[sender][_msgSender()];
342         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
343         unchecked {
344             _approve(sender, _msgSender(), currentAllowance - amount);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Atomically increases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
364         return true;
365     }
366 
367     /**
368      * @dev Atomically decreases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      * - `spender` must have allowance for the caller of at least
379      * `subtractedValue`.
380      */
381     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
382         uint256 currentAllowance = _allowances[_msgSender()][spender];
383         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
384         unchecked {
385             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
386         }
387 
388         return true;
389     }
390 
391     /**
392      * @dev Moves `amount` of tokens from `sender` to `recipient`.
393      *
394      * This internal function is equivalent to {transfer}, and can be used to
395      * e.g. implement automatic token fees, slashing mechanisms, etc.
396      *
397      * Emits a {Transfer} event.
398      *
399      * Requirements:
400      *
401      * - `sender` cannot be the zero address.
402      * - `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      */
405     function _transfer(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) internal virtual {
410         require(sender != address(0), "ERC20: transfer from the zero address");
411         require(recipient != address(0), "ERC20: transfer to the zero address");
412 
413         _beforeTokenTransfer(sender, recipient, amount);
414 
415         uint256 senderBalance = _balances[sender];
416         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
417         unchecked {
418             _balances[sender] = senderBalance - amount;
419         }
420         _balances[recipient] += amount;
421 
422         emit Transfer(sender, recipient, amount);
423 
424         _afterTokenTransfer(sender, recipient, amount);
425     }
426 
427     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
428      * the total supply.
429      *
430      * Emits a {Transfer} event with `from` set to the zero address.
431      *
432      * Requirements:
433      *
434      * - `account` cannot be the zero address.
435      */
436     function _mint(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: mint to the zero address");
438 
439         _beforeTokenTransfer(address(0), account, amount);
440 
441         _totalSupply += amount;
442         _balances[account] += amount;
443         emit Transfer(address(0), account, amount);
444 
445         _afterTokenTransfer(address(0), account, amount);
446     }
447 
448     /**
449      * @dev Destroys `amount` tokens from `account`, reducing the
450      * total supply.
451      *
452      * Emits a {Transfer} event with `to` set to the zero address.
453      *
454      * Requirements:
455      *
456      * - `account` cannot be the zero address.
457      * - `account` must have at least `amount` tokens.
458      */
459     function _burn(address account, uint256 amount) internal virtual {
460         require(account != address(0), "ERC20: burn from the zero address");
461 
462         _beforeTokenTransfer(account, address(0), amount);
463 
464         uint256 accountBalance = _balances[account];
465         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
466         unchecked {
467             _balances[account] = accountBalance - amount;
468         }
469         _totalSupply -= amount;
470 
471         emit Transfer(account, address(0), amount);
472 
473         _afterTokenTransfer(account, address(0), amount);
474     }
475 
476     /**
477      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
478      *
479      * This internal function is equivalent to `approve`, and can be used to
480      * e.g. set automatic allowances for certain subsystems, etc.
481      *
482      * Emits an {Approval} event.
483      *
484      * Requirements:
485      *
486      * - `owner` cannot be the zero address.
487      * - `spender` cannot be the zero address.
488      */
489     function _approve(
490         address owner,
491         address spender,
492         uint256 amount
493     ) internal virtual {
494         require(owner != address(0), "ERC20: approve from the zero address");
495         require(spender != address(0), "ERC20: approve to the zero address");
496 
497         _allowances[owner][spender] = amount;
498         emit Approval(owner, spender, amount);
499     }
500 
501     /**
502      * @dev Hook that is called before any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * will be transferred to `to`.
509      * - when `from` is zero, `amount` tokens will be minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _beforeTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 
521     /**
522      * @dev Hook that is called after any transfer of tokens. This includes
523      * minting and burning.
524      *
525      * Calling conditions:
526      *
527      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
528      * has been transferred to `to`.
529      * - when `from` is zero, `amount` tokens have been minted for `to`.
530      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
531      * - `from` and `to` are never both zero.
532      *
533      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
534      */
535     function _afterTokenTransfer(
536         address from,
537         address to,
538         uint256 amount
539     ) internal virtual {}
540 }
541 
542 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
543 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
544 
545 /* pragma solidity ^0.8.0; */
546 
547 // CAUTION
548 // This version of SafeMath should only be used with Solidity 0.8 or later,
549 // because it relies on the compiler's built in overflow checks.
550 
551 /**
552  * @dev Wrappers over Solidity's arithmetic operations.
553  *
554  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
555  * now has built in overflow checking.
556  */
557 library SafeMath {
558     /**
559      * @dev Returns the addition of two unsigned integers, with an overflow flag.
560      *
561      * _Available since v3.4._
562      */
563     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
564         unchecked {
565             uint256 c = a + b;
566             if (c < a) return (false, 0);
567             return (true, c);
568         }
569     }
570 
571     /**
572      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
573      *
574      * _Available since v3.4._
575      */
576     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
577         unchecked {
578             if (b > a) return (false, 0);
579             return (true, a - b);
580         }
581     }
582 
583     /**
584      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
585      *
586      * _Available since v3.4._
587      */
588     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
589         unchecked {
590             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
591             // benefit is lost if 'b' is also tested.
592             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
593             if (a == 0) return (true, 0);
594             uint256 c = a * b;
595             if (c / a != b) return (false, 0);
596             return (true, c);
597         }
598     }
599 
600     /**
601      * @dev Returns the division of two unsigned integers, with a division by zero flag.
602      *
603      * _Available since v3.4._
604      */
605     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
606         unchecked {
607             if (b == 0) return (false, 0);
608             return (true, a / b);
609         }
610     }
611 
612     /**
613      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
614      *
615      * _Available since v3.4._
616      */
617     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
618         unchecked {
619             if (b == 0) return (false, 0);
620             return (true, a % b);
621         }
622     }
623 
624     /**
625      * @dev Returns the addition of two unsigned integers, reverting on
626      * overflow.
627      *
628      * Counterpart to Solidity's `+` operator.
629      *
630      * Requirements:
631      *
632      * - Addition cannot overflow.
633      */
634     function add(uint256 a, uint256 b) internal pure returns (uint256) {
635         return a + b;
636     }
637 
638     /**
639      * @dev Returns the subtraction of two unsigned integers, reverting on
640      * overflow (when the result is negative).
641      *
642      * Counterpart to Solidity's `-` operator.
643      *
644      * Requirements:
645      *
646      * - Subtraction cannot overflow.
647      */
648     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a - b;
650     }
651 
652     /**
653      * @dev Returns the multiplication of two unsigned integers, reverting on
654      * overflow.
655      *
656      * Counterpart to Solidity's `*` operator.
657      *
658      * Requirements:
659      *
660      * - Multiplication cannot overflow.
661      */
662     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a * b;
664     }
665 
666     /**
667      * @dev Returns the integer division of two unsigned integers, reverting on
668      * division by zero. The result is rounded towards zero.
669      *
670      * Counterpart to Solidity's `/` operator.
671      *
672      * Requirements:
673      *
674      * - The divisor cannot be zero.
675      */
676     function div(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a / b;
678     }
679 
680     /**
681      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
682      * reverting when dividing by zero.
683      *
684      * Counterpart to Solidity's `%` operator. This function uses a `revert`
685      * opcode (which leaves remaining gas untouched) while Solidity uses an
686      * invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      *
690      * - The divisor cannot be zero.
691      */
692     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a % b;
694     }
695 
696     /**
697      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
698      * overflow (when the result is negative).
699      *
700      * CAUTION: This function is deprecated because it requires allocating memory for the error
701      * message unnecessarily. For custom revert reasons use {trySub}.
702      *
703      * Counterpart to Solidity's `-` operator.
704      *
705      * Requirements:
706      *
707      * - Subtraction cannot overflow.
708      */
709     function sub(
710         uint256 a,
711         uint256 b,
712         string memory errorMessage
713     ) internal pure returns (uint256) {
714         unchecked {
715             require(b <= a, errorMessage);
716             return a - b;
717         }
718     }
719 
720     /**
721      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
722      * division by zero. The result is rounded towards zero.
723      *
724      * Counterpart to Solidity's `/` operator. Note: this function uses a
725      * `revert` opcode (which leaves remaining gas untouched) while Solidity
726      * uses an invalid opcode to revert (consuming all remaining gas).
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function div(
733         uint256 a,
734         uint256 b,
735         string memory errorMessage
736     ) internal pure returns (uint256) {
737         unchecked {
738             require(b > 0, errorMessage);
739             return a / b;
740         }
741     }
742 
743     /**
744      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
745      * reverting with custom message when dividing by zero.
746      *
747      * CAUTION: This function is deprecated because it requires allocating memory for the error
748      * message unnecessarily. For custom revert reasons use {tryMod}.
749      *
750      * Counterpart to Solidity's `%` operator. This function uses a `revert`
751      * opcode (which leaves remaining gas untouched) while Solidity uses an
752      * invalid opcode to revert (consuming all remaining gas).
753      *
754      * Requirements:
755      *
756      * - The divisor cannot be zero.
757      */
758     function mod(
759         uint256 a,
760         uint256 b,
761         string memory errorMessage
762     ) internal pure returns (uint256) {
763         unchecked {
764             require(b > 0, errorMessage);
765             return a % b;
766         }
767     }
768 }
769 
770 ////// src/IUniswapV2Factory.sol
771 /* pragma solidity 0.8.10; */
772 /* pragma experimental ABIEncoderV2; */
773 
774 interface IUniswapV2Factory {
775     event PairCreated(
776         address indexed token0,
777         address indexed token1,
778         address pair,
779         uint256
780     );
781 
782     function feeTo() external view returns (address);
783 
784     function feeToSetter() external view returns (address);
785 
786     function getPair(address tokenA, address tokenB)
787         external
788         view
789         returns (address pair);
790 
791     function allPairs(uint256) external view returns (address pair);
792 
793     function allPairsLength() external view returns (uint256);
794 
795     function createPair(address tokenA, address tokenB)
796         external
797         returns (address pair);
798 
799     function setFeeTo(address) external;
800 
801     function setFeeToSetter(address) external;
802 }
803 
804 ////// src/IUniswapV2Pair.sol
805 /* pragma solidity 0.8.10; */
806 /* pragma experimental ABIEncoderV2; */
807 
808 interface IUniswapV2Pair {
809     event Approval(
810         address indexed owner,
811         address indexed spender,
812         uint256 value
813     );
814     event Transfer(address indexed from, address indexed to, uint256 value);
815 
816     function name() external pure returns (string memory);
817 
818     function symbol() external pure returns (string memory);
819 
820     function decimals() external pure returns (uint8);
821 
822     function totalSupply() external view returns (uint256);
823 
824     function balanceOf(address owner) external view returns (uint256);
825 
826     function allowance(address owner, address spender)
827         external
828         view
829         returns (uint256);
830 
831     function approve(address spender, uint256 value) external returns (bool);
832 
833     function transfer(address to, uint256 value) external returns (bool);
834 
835     function transferFrom(
836         address from,
837         address to,
838         uint256 value
839     ) external returns (bool);
840 
841     function DOMAIN_SEPARATOR() external view returns (bytes32);
842 
843     function PERMIT_TYPEHASH() external pure returns (bytes32);
844 
845     function nonces(address owner) external view returns (uint256);
846 
847     function permit(
848         address owner,
849         address spender,
850         uint256 value,
851         uint256 deadline,
852         uint8 v,
853         bytes32 r,
854         bytes32 s
855     ) external;
856 
857     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
858     event Burn(
859         address indexed sender,
860         uint256 amount0,
861         uint256 amount1,
862         address indexed to
863     );
864     event Swap(
865         address indexed sender,
866         uint256 amount0In,
867         uint256 amount1In,
868         uint256 amount0Out,
869         uint256 amount1Out,
870         address indexed to
871     );
872     event Sync(uint112 reserve0, uint112 reserve1);
873 
874     function MINIMUM_LIQUIDITY() external pure returns (uint256);
875 
876     function factory() external view returns (address);
877 
878     function token0() external view returns (address);
879 
880     function token1() external view returns (address);
881 
882     function getReserves()
883         external
884         view
885         returns (
886             uint112 reserve0,
887             uint112 reserve1,
888             uint32 blockTimestampLast
889         );
890 
891     function price0CumulativeLast() external view returns (uint256);
892 
893     function price1CumulativeLast() external view returns (uint256);
894 
895     function kLast() external view returns (uint256);
896 
897     function mint(address to) external returns (uint256 liquidity);
898 
899     function burn(address to)
900         external
901         returns (uint256 amount0, uint256 amount1);
902 
903     function swap(
904         uint256 amount0Out,
905         uint256 amount1Out,
906         address to,
907         bytes calldata data
908     ) external;
909 
910     function skim(address to) external;
911 
912     function sync() external;
913 
914     function initialize(address, address) external;
915 }
916 
917 ////// src/IUniswapV2Router02.sol
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
985 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
986 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
987 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
988 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
989 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
990 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
991 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
992 
993 contract Seraph is ERC20, Ownable {
994     using SafeMath for uint256;
995 
996     IUniswapV2Router02 public immutable uniswapV2Router;
997     address public immutable uniswapV2Pair;
998     address public constant deadAddress = address(0x71A23cb55c0DbD3eda65cfE690642423C06a98c9);
999 
1000     bool private swapping;
1001 
1002     address public marketingWallet;
1003     address public devWallet;
1004 
1005     uint256 public maxTransactionAmount;
1006     uint256 public swapTokensAtAmount;
1007     uint256 public maxWallet;
1008 
1009     uint256 public percentForLPBurn = 10;
1010     bool public lpBurnEnabled = true;
1011     uint256 public lpBurnFrequency = 7200 seconds;
1012     uint256 public lastLpBurnTime;
1013 
1014     uint256 public manualBurnFrequency = 30 minutes;
1015     uint256 public lastManualLpBurnTime;
1016 
1017     bool public limitsInEffect = true;
1018     bool public tradingActive = false;
1019     bool public swapEnabled = false;
1020 
1021     // Anti-bot and anti-whale mappings and variables
1022     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1023     bool public transferDelayEnabled = true;
1024 
1025     uint256 public buyTotalFees;
1026     uint256 public buyMarketingFee;
1027     uint256 public buyLiquidityFee;
1028     uint256 public buyDevFee;
1029 
1030     uint256 public sellTotalFees;
1031     uint256 public sellMarketingFee;
1032     uint256 public sellLiquidityFee;
1033     uint256 public sellDevFee;
1034 
1035     uint256 public tokensForMarketing;
1036     uint256 public tokensForLiquidity;
1037     uint256 public tokensForDev;
1038 
1039     /******************/
1040 
1041     // exlcude from fees and max transaction amount
1042     mapping(address => bool) private _isExcludedFromFees;
1043     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1044 
1045     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1046     // could be subject to a maximum transfer amount
1047     mapping(address => bool) public automatedMarketMakerPairs;
1048 
1049     event UpdateUniswapV2Router(
1050         address indexed newAddress,
1051         address indexed oldAddress
1052     );
1053 
1054     event ExcludeFromFees(address indexed account, bool isExcluded);
1055 
1056     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1057 
1058     event marketingWalletUpdated(
1059         address indexed newWallet,
1060         address indexed oldWallet
1061     );
1062 
1063     event devWalletUpdated(
1064         address indexed newWallet,
1065         address indexed oldWallet
1066     );
1067 
1068     event SwapAndLiquify(
1069         uint256 tokensSwapped,
1070         uint256 ethReceived,
1071         uint256 tokensIntoLiquidity
1072     );
1073 
1074     event AutoNukeLP();
1075 
1076     event ManualNukeLP();
1077 
1078     constructor() ERC20("Seraph", "SERA") {
1079         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1080             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1081         );
1082 
1083         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1084         uniswapV2Router = _uniswapV2Router;
1085 
1086         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1087             .createPair(address(this), _uniswapV2Router.WETH());
1088         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1089         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1090 
1091         uint256 _buyMarketingFee = 2;
1092         uint256 _buyLiquidityFee = 2;
1093         uint256 _buyDevFee = 2;
1094 
1095         uint256 _sellMarketingFee = 2;
1096         uint256 _sellLiquidityFee = 2;
1097         uint256 _sellDevFee = 2;
1098 
1099         uint256 totalSupply = 1_000_000_000 * 1e18;
1100 
1101         maxTransactionAmount = 5_000_000 * 1e18;
1102         maxWallet = 10_000_000 * 1e18;
1103         swapTokensAtAmount = (totalSupply * 5) / 10000;
1104 
1105         buyMarketingFee = _buyMarketingFee;
1106         buyLiquidityFee = _buyLiquidityFee;
1107         buyDevFee = _buyDevFee;
1108         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1109 
1110         sellMarketingFee = _sellMarketingFee;
1111         sellLiquidityFee = _sellLiquidityFee;
1112         sellDevFee = _sellDevFee;
1113         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1114 
1115         marketingWallet = address(0x71A23cb55c0DbD3eda65cfE690642423C06a98c9); // set as marketing wallet
1116         devWallet = address(0x71A23cb55c0DbD3eda65cfE690642423C06a98c9); // set as dev wallet
1117 
1118         // exclude from paying fees or having max transaction amount
1119         excludeFromFees(owner(), true);
1120         excludeFromFees(address(this), true);
1121         excludeFromFees(address(0xdead), true);
1122 
1123         excludeFromMaxTransaction(owner(), true);
1124         excludeFromMaxTransaction(address(this), true);
1125         excludeFromMaxTransaction(address(0xdead), true);
1126 
1127         /*
1128             _mint is an internal function in ERC20.sol that is only called here,
1129             and CANNOT be called ever again
1130         */
1131         _mint(msg.sender, totalSupply);
1132     }
1133 
1134     receive() external payable {}
1135 
1136     // once enabled, can never be turned off
1137     function enableTrading() external onlyOwner {
1138         tradingActive = true;
1139         swapEnabled = true;
1140         lastLpBurnTime = block.timestamp;
1141     }
1142 
1143     // remove limits after token is stable
1144     function removeLimits() external onlyOwner returns (bool) {
1145         limitsInEffect = false;
1146         return true;
1147     }
1148 
1149     // disable Transfer delay - cannot be reenabled
1150     function disableTransferDelay() external onlyOwner returns (bool) {
1151         transferDelayEnabled = false;
1152         return true;
1153     }
1154 
1155     // change the minimum amount of tokens to sell from fees
1156     function updateSwapTokensAtAmount(uint256 newAmount)
1157         external
1158         onlyOwner
1159         returns (bool)
1160     {
1161         require(
1162             newAmount >= (totalSupply() * 1) / 100000,
1163             "Swap amount cannot be lower than 0.001% total supply."
1164         );
1165         require(
1166             newAmount <= (totalSupply() * 5) / 1000,
1167             "Swap amount cannot be higher than 0.5% total supply."
1168         );
1169         swapTokensAtAmount = newAmount;
1170         return true;
1171     }
1172 
1173     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1174         require(
1175             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1176             "Cannot set maxTransactionAmount lower than 0.1%"
1177         );
1178         maxTransactionAmount = newNum * (10**18);
1179     }
1180 
1181     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1182         require(
1183             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1184             "Cannot set maxWallet lower than 0.5%"
1185         );
1186         maxWallet = newNum * (10**18);
1187     }
1188 
1189     function excludeFromMaxTransaction(address updAds, bool isEx)
1190         public
1191         onlyOwner
1192     {
1193         _isExcludedMaxTransactionAmount[updAds] = isEx;
1194     }
1195 
1196     // only use to disable contract sales if absolutely necessary (emergency use only)
1197     function updateSwapEnabled(bool enabled) external onlyOwner {
1198         swapEnabled = enabled;
1199     }
1200 
1201     function updateBuyFees(
1202         uint256 _marketingFee,
1203         uint256 _liquidityFee,
1204         uint256 _devFee
1205     ) external onlyOwner {
1206         buyMarketingFee = _marketingFee;
1207         buyLiquidityFee = _liquidityFee;
1208         buyDevFee = _devFee;
1209         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1210         require(buyTotalFees <= 9, "Must keep fees at 9% or less");
1211     }
1212 
1213     function updateSellFees(
1214         uint256 _marketingFee,
1215         uint256 _liquidityFee,
1216         uint256 _devFee
1217     ) external onlyOwner {
1218         sellMarketingFee = _marketingFee;
1219         sellLiquidityFee = _liquidityFee;
1220         sellDevFee = _devFee;
1221         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1222         require(sellTotalFees <= 9, "Must keep fees at 9% or less");
1223     }
1224 
1225     function excludeFromFees(address account, bool excluded) public onlyOwner {
1226         _isExcludedFromFees[account] = excluded;
1227         emit ExcludeFromFees(account, excluded);
1228     }
1229 
1230     function setAutomatedMarketMakerPair(address pair, bool value)
1231         public
1232         onlyOwner
1233     {
1234         require(
1235             pair != uniswapV2Pair,
1236             "The pair cannot be removed from automatedMarketMakerPairs"
1237         );
1238 
1239         _setAutomatedMarketMakerPair(pair, value);
1240     }
1241 
1242     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1243         automatedMarketMakerPairs[pair] = value;
1244 
1245         emit SetAutomatedMarketMakerPair(pair, value);
1246     }
1247 
1248     function updateMarketingWallet(address newMarketingWallet)
1249         external
1250         onlyOwner
1251     {
1252         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1253         marketingWallet = newMarketingWallet;
1254     }
1255 
1256     function updateDevWallet(address newWallet) external onlyOwner {
1257         emit devWalletUpdated(newWallet, devWallet);
1258         devWallet = newWallet;
1259     }
1260 
1261     function isExcludedFromFees(address account) public view returns (bool) {
1262         return _isExcludedFromFees[account];
1263     }
1264 
1265     event BoughtEarly(address indexed sniper);
1266 
1267     function _transfer(
1268         address from,
1269         address to,
1270         uint256 amount
1271     ) internal override {
1272         require(from != address(0), "ERC20: transfer from the zero address");
1273         require(to != address(0), "ERC20: transfer to the zero address");
1274 
1275         if (amount == 0) {
1276             super._transfer(from, to, 0);
1277             return;
1278         }
1279 
1280         if (limitsInEffect) {
1281             if (
1282                 from != owner() &&
1283                 to != owner() &&
1284                 to != address(0) &&
1285                 to != address(0xdead) &&
1286                 !swapping
1287             ) {
1288                 if (!tradingActive) {
1289                     require(
1290                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1291                         "Trading is not active."
1292                     );
1293                 }
1294 
1295                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1296                 if (transferDelayEnabled) {
1297                     if (
1298                         to != owner() &&
1299                         to != address(uniswapV2Router) &&
1300                         to != address(uniswapV2Pair)
1301                     ) {
1302                         require(
1303                             _holderLastTransferTimestamp[tx.origin] <
1304                                 block.number,
1305                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1306                         );
1307                         _holderLastTransferTimestamp[tx.origin] = block.number;
1308                     }
1309                 }
1310 
1311                 //when buy
1312                 if (
1313                     automatedMarketMakerPairs[from] &&
1314                     !_isExcludedMaxTransactionAmount[to]
1315                 ) {
1316                     require(
1317                         amount <= maxTransactionAmount,
1318                         "Buy transfer amount exceeds the maxTransactionAmount."
1319                     );
1320                     require(
1321                         amount + balanceOf(to) <= maxWallet,
1322                         "Max wallet exceeded"
1323                     );
1324                 }
1325                 //when sell
1326                 else if (
1327                     automatedMarketMakerPairs[to] &&
1328                     !_isExcludedMaxTransactionAmount[from]
1329                 ) {
1330                     require(
1331                         amount <= maxTransactionAmount,
1332                         "Sell transfer amount exceeds the maxTransactionAmount."
1333                     );
1334                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1335                     require(
1336                         amount + balanceOf(to) <= maxWallet,
1337                         "Max wallet exceeded"
1338                     );
1339                 }
1340             }
1341         }
1342 
1343         uint256 contractTokenBalance = balanceOf(address(this));
1344 
1345         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1346 
1347         if (
1348             canSwap &&
1349             swapEnabled &&
1350             !swapping &&
1351             !automatedMarketMakerPairs[from] &&
1352             !_isExcludedFromFees[from] &&
1353             !_isExcludedFromFees[to]
1354         ) {
1355             swapping = true;
1356 
1357             swapBack();
1358 
1359             swapping = false;
1360         }
1361 
1362         if (
1363             !swapping &&
1364             automatedMarketMakerPairs[to] &&
1365             lpBurnEnabled &&
1366             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1367             !_isExcludedFromFees[from]
1368         ) {
1369             autoBurnLiquidityPairTokens();
1370         }
1371 
1372         bool takeFee = !swapping;
1373 
1374         // if any account belongs to _isExcludedFromFee account then remove the fee
1375         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1376             takeFee = false;
1377         }
1378 
1379         uint256 fees = 0;
1380         // only take fees on buys/sells, do not take on wallet transfers
1381         if (takeFee) {
1382             // on sell
1383             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1384                 fees = amount.mul(sellTotalFees).div(100);
1385                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1386                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1387                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1388             }
1389             // on buy
1390             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1391                 fees = amount.mul(buyTotalFees).div(100);
1392                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1393                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1394                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1395             }
1396 
1397             if (fees > 0) {
1398                 super._transfer(from, address(this), fees);
1399             }
1400 
1401             amount -= fees;
1402         }
1403 
1404         super._transfer(from, to, amount);
1405     }
1406 
1407     function swapTokensForEth(uint256 tokenAmount) private {
1408         // generate the uniswap pair path of token -> weth
1409         address[] memory path = new address[](2);
1410         path[0] = address(this);
1411         path[1] = uniswapV2Router.WETH();
1412 
1413         _approve(address(this), address(uniswapV2Router), tokenAmount);
1414 
1415         // make the swap
1416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1417             tokenAmount,
1418             0, // accept any amount of ETH
1419             path,
1420             address(this),
1421             block.timestamp
1422         );
1423     }
1424 
1425     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1426         // approve token transfer to cover all possible scenarios
1427         _approve(address(this), address(uniswapV2Router), tokenAmount);
1428 
1429         // add the liquidity
1430         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1431             address(this),
1432             tokenAmount,
1433             0, // slippage is unavoidable
1434             0, // slippage is unavoidable
1435             deadAddress,
1436             block.timestamp
1437         );
1438     }
1439 
1440     function swapBack() private {
1441         uint256 contractBalance = balanceOf(address(this));
1442         uint256 totalTokensToSwap = tokensForLiquidity +
1443             tokensForMarketing +
1444             tokensForDev;
1445         bool success;
1446 
1447         if (contractBalance == 0 || totalTokensToSwap == 0) {
1448             return;
1449         }
1450 
1451         if (contractBalance > swapTokensAtAmount * 20) {
1452             contractBalance = swapTokensAtAmount * 20;
1453         }
1454 
1455         // Halve the amount of liquidity tokens
1456         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1457             totalTokensToSwap /
1458             2;
1459         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1460 
1461         uint256 initialETHBalance = address(this).balance;
1462 
1463         swapTokensForEth(amountToSwapForETH);
1464 
1465         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1466 
1467         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1468             totalTokensToSwap
1469         );
1470         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1471 
1472         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1473 
1474         tokensForLiquidity = 0;
1475         tokensForMarketing = 0;
1476         tokensForDev = 0;
1477 
1478         (success, ) = address(devWallet).call{value: ethForDev}("");
1479 
1480         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1481             addLiquidity(liquidityTokens, ethForLiquidity);
1482             emit SwapAndLiquify(
1483                 amountToSwapForETH,
1484                 ethForLiquidity,
1485                 tokensForLiquidity
1486             );
1487         }
1488 
1489         (success, ) = address(marketingWallet).call{
1490             value: address(this).balance
1491         }("");
1492     }
1493 
1494     function setAutoLPBurnSettings(
1495         uint256 _frequencyInSeconds,
1496         uint256 _percent,
1497         bool _Enabled
1498     ) external onlyOwner {
1499         require(
1500             _frequencyInSeconds >= 600,
1501             "cannot set buyback more often than every 10 minutes"
1502         );
1503         require(
1504             _percent <= 1000 && _percent >= 0,
1505             "Must set auto LP burn percent between 0% and 10%"
1506         );
1507         lpBurnFrequency = _frequencyInSeconds;
1508         percentForLPBurn = _percent;
1509         lpBurnEnabled = _Enabled;
1510     }
1511 
1512     function autoBurnLiquidityPairTokens() internal returns (bool) {
1513         lastLpBurnTime = block.timestamp;
1514 
1515         // get balance of liquidity pair
1516         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1517 
1518         // calculate amount to burn
1519         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1520             10000
1521         );
1522 
1523         // pull tokens from pancakePair liquidity and move to dead address permanently
1524         if (amountToBurn > 0) {
1525             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1526         }
1527 
1528         //sync price since this is not in a swap transaction!
1529         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1530         pair.sync();
1531         emit AutoNukeLP();
1532         return true;
1533     }
1534 
1535     function manualBurnLiquidityPairTokens(uint256 percent)
1536         external
1537         onlyOwner
1538         returns (bool)
1539     {
1540         require(
1541             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1542             "Must wait for cooldown to finish"
1543         );
1544         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1545         lastManualLpBurnTime = block.timestamp;
1546 
1547         // get balance of liquidity pair
1548         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1549 
1550         // calculate amount to burn
1551         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1552 
1553         // pull tokens from pancakePair liquidity and move to dead address permanently
1554         if (amountToBurn > 0) {
1555             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1556         }
1557 
1558         //sync price since this is not in a swap transaction!
1559         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1560         pair.sync();
1561         emit ManualNukeLP();
1562         return true;
1563     }
1564 }