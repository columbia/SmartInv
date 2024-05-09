1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5 
6 /* pragma solidity ^0.8.0; */
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 /* pragma solidity ^0.8.0; */
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev Initializes the contract setting the deployer as the initial owner.
26      */
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Leaves the contract without owner. It will not be possible to call
48      * `onlyOwner` functions anymore. Can only be called by the current owner.
49      *
50      * NOTE: Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Internal function without access restriction.
69      */
70     function _transferOwnership(address newOwner) internal virtual {
71         address oldOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(oldOwner, newOwner);
74     }
75 }
76 
77 /* pragma solidity ^0.8.0; */
78 
79 /**
80  * @dev Interface of the ERC20 standard as defined in the EIP.
81  */
82 interface IERC20 {
83     /**
84      * @dev Returns the amount of tokens in existence.
85      */
86     function totalSupply() external view returns (uint256);
87 
88     /**
89      * @dev Returns the amount of tokens owned by `account`.
90      */
91     function balanceOf(address account) external view returns (uint256);
92 
93     /**
94      * @dev Moves `amount` tokens from the caller's account to `recipient`.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transfer(address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Returns the remaining number of tokens that `spender` will be
104      * allowed to spend on behalf of `owner` through {transferFrom}. This is
105      * zero by default.
106      *
107      * This value changes when {approve} or {transferFrom} are called.
108      */
109     function allowance(address owner, address spender) external view returns (uint256);
110 
111     /**
112      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * IMPORTANT: Beware that changing an allowance with this method brings the risk
117      * that someone may use both the old and the new allowance by unfortunate
118      * transaction ordering. One possible solution to mitigate this race
119      * condition is to first reduce the spender's allowance to 0 and set the
120      * desired value afterwards:
121      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address spender, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Moves `amount` tokens from `sender` to `recipient` using the
129      * allowance mechanism. `amount` is then deducted from the caller's
130      * allowance.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) external returns (bool);
141 
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /* pragma solidity ^0.8.0; */
158 
159 /* import "../IERC20.sol"; */
160 
161 /**
162  * @dev Interface for the optional metadata functions from the ERC20 standard.
163  *
164  * _Available since v4.1._
165  */
166 interface IERC20Metadata is IERC20 {
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() external view returns (string memory);
171 
172     /**
173      * @dev Returns the symbol of the token.
174      */
175     function symbol() external view returns (string memory);
176 
177     /**
178      * @dev Returns the decimals places of the token.
179      */
180     function decimals() external view returns (uint8);
181 }
182 
183 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
184 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
185 
186 /* pragma solidity ^0.8.0; */
187 
188 /* import "./IERC20.sol"; */
189 /* import "./extensions/IERC20Metadata.sol"; */
190 /* import "../../utils/Context.sol"; */
191 
192 /**
193  * @dev Implementation of the {IERC20} interface.
194  *
195  * This implementation is agnostic to the way tokens are created. This means
196  * that a supply mechanism has to be added in a derived contract using {_mint}.
197  * For a generic mechanism see {ERC20PresetMinterPauser}.
198  *
199  * TIP: For a detailed writeup see our guide
200  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
201  * to implement supply mechanisms].
202  *
203  * We have followed general OpenZeppelin Contracts guidelines: functions revert
204  * instead returning `false` on failure. This behavior is nonetheless
205  * conventional and does not conflict with the expectations of ERC20
206  * applications.
207  *
208  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
209  * This allows applications to reconstruct the allowance for all accounts just
210  * by listening to said events. Other implementations of the EIP may not emit
211  * these events, as it isn't required by the specification.
212  *
213  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
214  * functions have been added to mitigate the well-known issues around setting
215  * allowances. See {IERC20-approve}.
216  */
217 contract ERC20 is Context, IERC20, IERC20Metadata {
218     mapping(address => uint256) private _balances;
219 
220     mapping(address => mapping(address => uint256)) private _allowances;
221 
222     uint256 private _totalSupply;
223 
224     string private _name;
225     string private _symbol;
226 
227     /**
228      * @dev Sets the values for {name} and {symbol}.
229      *
230      * The default value of {decimals} is 18. To select a different value for
231      * {decimals} you should overload it.
232      *
233      * All two of these values are immutable: they can only be set once during
234      * construction.
235      */
236     constructor(string memory name_, string memory symbol_) {
237         _name = name_;
238         _symbol = symbol_;
239     }
240 
241     /**
242      * @dev Returns the name of the token.
243      */
244     function name() public view virtual override returns (string memory) {
245         return _name;
246     }
247 
248     /**
249      * @dev Returns the symbol of the token, usually a shorter version of the
250      * name.
251      */
252     function symbol() public view virtual override returns (string memory) {
253         return _symbol;
254     }
255 
256     /**
257      * @dev Returns the number of decimals used to get its user representation.
258      * For example, if `decimals` equals `2`, a balance of `505` tokens should
259      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
260      *
261      * Tokens usually opt for a value of 18, imitating the relationship between
262      * Ether and Wei. This is the value {ERC20} uses, unless this function is
263      * overridden;
264      *
265      * NOTE: This information is only used for _display_ purposes: it in
266      * no way affects any of the arithmetic of the contract, including
267      * {IERC20-balanceOf} and {IERC20-transfer}.
268      */
269     function decimals() public view virtual override returns (uint8) {
270         return 18;
271     }
272 
273     /**
274      * @dev See {IERC20-totalSupply}.
275      */
276     function totalSupply() public view virtual override returns (uint256) {
277         return _totalSupply;
278     }
279 
280     /**
281      * @dev See {IERC20-balanceOf}.
282      */
283     function balanceOf(address account) public view virtual override returns (uint256) {
284         return _balances[account];
285     }
286 
287     /**
288      * @dev See {IERC20-transfer}.
289      *
290      * Requirements:
291      *
292      * - `recipient` cannot be the zero address.
293      * - the caller must have a balance of at least `amount`.
294      */
295     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
296         _transfer(_msgSender(), recipient, amount);
297         return true;
298     }
299 
300     /**
301      * @dev See {IERC20-allowance}.
302      */
303     function allowance(address owner, address spender) public view virtual override returns (uint256) {
304         return _allowances[owner][spender];
305     }
306 
307     /**
308      * @dev See {IERC20-approve}.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function approve(address spender, uint256 amount) public virtual override returns (bool) {
315         _approve(_msgSender(), spender, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-transferFrom}.
321      *
322      * Emits an {Approval} event indicating the updated allowance. This is not
323      * required by the EIP. See the note at the beginning of {ERC20}.
324      *
325      * Requirements:
326      *
327      * - `sender` and `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      * - the caller must have allowance for ``sender``'s tokens of at least
330      * `amount`.
331      */
332     function transferFrom(
333         address sender,
334         address recipient,
335         uint256 amount
336     ) public virtual override returns (bool) {
337         _transfer(sender, recipient, amount);
338 
339         uint256 currentAllowance = _allowances[sender][_msgSender()];
340         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
341         unchecked {
342             _approve(sender, _msgSender(), currentAllowance - amount);
343         }
344 
345         return true;
346     }
347 
348     /**
349      * @dev Atomically increases the allowance granted to `spender` by the caller.
350      *
351      * This is an alternative to {approve} that can be used as a mitigation for
352      * problems described in {IERC20-approve}.
353      *
354      * Emits an {Approval} event indicating the updated allowance.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
361         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
362         return true;
363     }
364 
365     /**
366      * @dev Atomically decreases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {IERC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      * - `spender` must have allowance for the caller of at least
377      * `subtractedValue`.
378      */
379     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
380         uint256 currentAllowance = _allowances[_msgSender()][spender];
381         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
382         unchecked {
383             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
384         }
385 
386         return true;
387     }
388 
389     /**
390      * @dev Moves `amount` of tokens from `sender` to `recipient`.
391      *
392      * This internal function is equivalent to {transfer}, and can be used to
393      * e.g. implement automatic token fees, slashing mechanisms, etc.
394      *
395      * Emits a {Transfer} event.
396      *
397      * Requirements:
398      *
399      * - `sender` cannot be the zero address.
400      * - `recipient` cannot be the zero address.
401      * - `sender` must have a balance of at least `amount`.
402      */
403     function _transfer(
404         address sender,
405         address recipient,
406         uint256 amount
407     ) internal virtual {
408         require(sender != address(0), "ERC20: transfer from the zero address");
409         require(recipient != address(0), "ERC20: transfer to the zero address");
410 
411         _beforeTokenTransfer(sender, recipient, amount);
412 
413         uint256 senderBalance = _balances[sender];
414         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
415         unchecked {
416             _balances[sender] = senderBalance - amount;
417         }
418         _balances[recipient] += amount;
419 
420         emit Transfer(sender, recipient, amount);
421 
422         _afterTokenTransfer(sender, recipient, amount);
423     }
424 
425     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
426      * the total supply.
427      *
428      * Emits a {Transfer} event with `from` set to the zero address.
429      *
430      * Requirements:
431      *
432      * - `account` cannot be the zero address.
433      */
434     function _mint(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: mint to the zero address");
436 
437         _beforeTokenTransfer(address(0), account, amount);
438 
439         _totalSupply += amount;
440         _balances[account] += amount;
441         emit Transfer(address(0), account, amount);
442 
443         _afterTokenTransfer(address(0), account, amount);
444     }
445 
446     /**
447      * @dev Destroys `amount` tokens from `account`, reducing the
448      * total supply.
449      *
450      * Emits a {Transfer} event with `to` set to the zero address.
451      *
452      * Requirements:
453      *
454      * - `account` cannot be the zero address.
455      * - `account` must have at least `amount` tokens.
456      */
457     function _burn(address account, uint256 amount) internal virtual {
458         require(account != address(0), "ERC20: burn from the zero address");
459 
460         _beforeTokenTransfer(account, address(0), amount);
461 
462         uint256 accountBalance = _balances[account];
463         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
464         unchecked {
465             _balances[account] = accountBalance - amount;
466         }
467         _totalSupply -= amount;
468 
469         emit Transfer(account, address(0), amount);
470 
471         _afterTokenTransfer(account, address(0), amount);
472     }
473 
474     /**
475      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
476      *
477      * This internal function is equivalent to `approve`, and can be used to
478      * e.g. set automatic allowances for certain subsystems, etc.
479      *
480      * Emits an {Approval} event.
481      *
482      * Requirements:
483      *
484      * - `owner` cannot be the zero address.
485      * - `spender` cannot be the zero address.
486      */
487     function _approve(
488         address owner,
489         address spender,
490         uint256 amount
491     ) internal virtual {
492         require(owner != address(0), "ERC20: approve from the zero address");
493         require(spender != address(0), "ERC20: approve to the zero address");
494 
495         _allowances[owner][spender] = amount;
496         emit Approval(owner, spender, amount);
497     }
498 
499     /**
500      * @dev Hook that is called before any transfer of tokens. This includes
501      * minting and burning.
502      *
503      * Calling conditions:
504      *
505      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
506      * will be transferred to `to`.
507      * - when `from` is zero, `amount` tokens will be minted for `to`.
508      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
509      * - `from` and `to` are never both zero.
510      *
511      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
512      */
513     function _beforeTokenTransfer(
514         address from,
515         address to,
516         uint256 amount
517     ) internal virtual {}
518 
519     /**
520      * @dev Hook that is called after any transfer of tokens. This includes
521      * minting and burning.
522      *
523      * Calling conditions:
524      *
525      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
526      * has been transferred to `to`.
527      * - when `from` is zero, `amount` tokens have been minted for `to`.
528      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
529      * - `from` and `to` are never both zero.
530      *
531      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
532      */
533     function _afterTokenTransfer(
534         address from,
535         address to,
536         uint256 amount
537     ) internal virtual {}
538 }
539 
540 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
541 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
542 
543 /* pragma solidity ^0.8.0; */
544 
545 // CAUTION
546 // This version of SafeMath should only be used with Solidity 0.8 or later,
547 // because it relies on the compiler's built in overflow checks.
548 
549 /**
550  * @dev Wrappers over Solidity's arithmetic operations.
551  *
552  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
553  * now has built in overflow checking.
554  */
555 library SafeMath {
556     /**
557      * @dev Returns the addition of two unsigned integers, with an overflow flag.
558      *
559      * _Available since v3.4._
560      */
561     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
562         unchecked {
563             uint256 c = a + b;
564             if (c < a) return (false, 0);
565             return (true, c);
566         }
567     }
568 
569     /**
570      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
571      *
572      * _Available since v3.4._
573      */
574     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
575         unchecked {
576             if (b > a) return (false, 0);
577             return (true, a - b);
578         }
579     }
580 
581     /**
582      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
583      *
584      * _Available since v3.4._
585      */
586     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
587         unchecked {
588             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
589             // benefit is lost if 'b' is also tested.
590             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
591             if (a == 0) return (true, 0);
592             uint256 c = a * b;
593             if (c / a != b) return (false, 0);
594             return (true, c);
595         }
596     }
597 
598     /**
599      * @dev Returns the division of two unsigned integers, with a division by zero flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             if (b == 0) return (false, 0);
606             return (true, a / b);
607         }
608     }
609 
610     /**
611      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
612      *
613      * _Available since v3.4._
614      */
615     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             if (b == 0) return (false, 0);
618             return (true, a % b);
619         }
620     }
621 
622     /**
623      * @dev Returns the addition of two unsigned integers, reverting on
624      * overflow.
625      *
626      * Counterpart to Solidity's `+` operator.
627      *
628      * Requirements:
629      *
630      * - Addition cannot overflow.
631      */
632     function add(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a + b;
634     }
635 
636     /**
637      * @dev Returns the subtraction of two unsigned integers, reverting on
638      * overflow (when the result is negative).
639      *
640      * Counterpart to Solidity's `-` operator.
641      *
642      * Requirements:
643      *
644      * - Subtraction cannot overflow.
645      */
646     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a - b;
648     }
649 
650     /**
651      * @dev Returns the multiplication of two unsigned integers, reverting on
652      * overflow.
653      *
654      * Counterpart to Solidity's `*` operator.
655      *
656      * Requirements:
657      *
658      * - Multiplication cannot overflow.
659      */
660     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
661         return a * b;
662     }
663 
664     /**
665      * @dev Returns the integer division of two unsigned integers, reverting on
666      * division by zero. The result is rounded towards zero.
667      *
668      * Counterpart to Solidity's `/` operator.
669      *
670      * Requirements:
671      *
672      * - The divisor cannot be zero.
673      */
674     function div(uint256 a, uint256 b) internal pure returns (uint256) {
675         return a / b;
676     }
677 
678     /**
679      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
680      * reverting when dividing by zero.
681      *
682      * Counterpart to Solidity's `%` operator. This function uses a `revert`
683      * opcode (which leaves remaining gas untouched) while Solidity uses an
684      * invalid opcode to revert (consuming all remaining gas).
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a % b;
692     }
693 
694     /**
695      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
696      * overflow (when the result is negative).
697      *
698      * CAUTION: This function is deprecated because it requires allocating memory for the error
699      * message unnecessarily. For custom revert reasons use {trySub}.
700      *
701      * Counterpart to Solidity's `-` operator.
702      *
703      * Requirements:
704      *
705      * - Subtraction cannot overflow.
706      */
707     function sub(
708         uint256 a,
709         uint256 b,
710         string memory errorMessage
711     ) internal pure returns (uint256) {
712         unchecked {
713             require(b <= a, errorMessage);
714             return a - b;
715         }
716     }
717 
718     /**
719      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
720      * division by zero. The result is rounded towards zero.
721      *
722      * Counterpart to Solidity's `/` operator. Note: this function uses a
723      * `revert` opcode (which leaves remaining gas untouched) while Solidity
724      * uses an invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function div(
731         uint256 a,
732         uint256 b,
733         string memory errorMessage
734     ) internal pure returns (uint256) {
735         unchecked {
736             require(b > 0, errorMessage);
737             return a / b;
738         }
739     }
740 
741     /**
742      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
743      * reverting with custom message when dividing by zero.
744      *
745      * CAUTION: This function is deprecated because it requires allocating memory for the error
746      * message unnecessarily. For custom revert reasons use {tryMod}.
747      *
748      * Counterpart to Solidity's `%` operator. This function uses a `revert`
749      * opcode (which leaves remaining gas untouched) while Solidity uses an
750      * invalid opcode to revert (consuming all remaining gas).
751      *
752      * Requirements:
753      *
754      * - The divisor cannot be zero.
755      */
756     function mod(
757         uint256 a,
758         uint256 b,
759         string memory errorMessage
760     ) internal pure returns (uint256) {
761         unchecked {
762             require(b > 0, errorMessage);
763             return a % b;
764         }
765     }
766 }
767 
768 ////// src/IUniswapV2Factory.sol
769 /* pragma solidity 0.8.10; */
770 /* pragma experimental ABIEncoderV2; */
771 
772 interface IUniswapV2Factory {
773     event PairCreated(
774         address indexed token0,
775         address indexed token1,
776         address pair,
777         uint256
778     );
779 
780     function feeTo() external view returns (address);
781 
782     function feeToSetter() external view returns (address);
783 
784     function getPair(address tokenA, address tokenB)
785         external
786         view
787         returns (address pair);
788 
789     function allPairs(uint256) external view returns (address pair);
790 
791     function allPairsLength() external view returns (uint256);
792 
793     function createPair(address tokenA, address tokenB)
794         external
795         returns (address pair);
796 
797     function setFeeTo(address) external;
798 
799     function setFeeToSetter(address) external;
800 }
801 
802 ////// src/IUniswapV2Pair.sol
803 /* pragma solidity 0.8.10; */
804 /* pragma experimental ABIEncoderV2; */
805 
806 interface IUniswapV2Pair {
807     event Approval(
808         address indexed owner,
809         address indexed spender,
810         uint256 value
811     );
812     event Transfer(address indexed from, address indexed to, uint256 value);
813 
814     function name() external pure returns (string memory);
815 
816     function symbol() external pure returns (string memory);
817 
818     function decimals() external pure returns (uint8);
819 
820     function totalSupply() external view returns (uint256);
821 
822     function balanceOf(address owner) external view returns (uint256);
823 
824     function allowance(address owner, address spender)
825         external
826         view
827         returns (uint256);
828 
829     function approve(address spender, uint256 value) external returns (bool);
830 
831     function transfer(address to, uint256 value) external returns (bool);
832 
833     function transferFrom(
834         address from,
835         address to,
836         uint256 value
837     ) external returns (bool);
838 
839     function DOMAIN_SEPARATOR() external view returns (bytes32);
840 
841     function PERMIT_TYPEHASH() external pure returns (bytes32);
842 
843     function nonces(address owner) external view returns (uint256);
844 
845     function permit(
846         address owner,
847         address spender,
848         uint256 value,
849         uint256 deadline,
850         uint8 v,
851         bytes32 r,
852         bytes32 s
853     ) external;
854 
855     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
856     event Burn(
857         address indexed sender,
858         uint256 amount0,
859         uint256 amount1,
860         address indexed to
861     );
862     event Swap(
863         address indexed sender,
864         uint256 amount0In,
865         uint256 amount1In,
866         uint256 amount0Out,
867         uint256 amount1Out,
868         address indexed to
869     );
870     event Sync(uint112 reserve0, uint112 reserve1);
871 
872     function MINIMUM_LIQUIDITY() external pure returns (uint256);
873 
874     function factory() external view returns (address);
875 
876     function token0() external view returns (address);
877 
878     function token1() external view returns (address);
879 
880     function getReserves()
881         external
882         view
883         returns (
884             uint112 reserve0,
885             uint112 reserve1,
886             uint32 blockTimestampLast
887         );
888 
889     function price0CumulativeLast() external view returns (uint256);
890 
891     function price1CumulativeLast() external view returns (uint256);
892 
893     function kLast() external view returns (uint256);
894 
895     function mint(address to) external returns (uint256 liquidity);
896 
897     function burn(address to)
898         external
899         returns (uint256 amount0, uint256 amount1);
900 
901     function swap(
902         uint256 amount0Out,
903         uint256 amount1Out,
904         address to,
905         bytes calldata data
906     ) external;
907 
908     function skim(address to) external;
909 
910     function sync() external;
911 
912     function initialize(address, address) external;
913 }
914 
915 ////// src/IUniswapV2Router02.sol
916 /* pragma solidity 0.8.10; */
917 /* pragma experimental ABIEncoderV2; */
918 
919 interface IUniswapV2Router02 {
920     function factory() external pure returns (address);
921 
922     function WETH() external pure returns (address);
923 
924     function addLiquidity(
925         address tokenA,
926         address tokenB,
927         uint256 amountADesired,
928         uint256 amountBDesired,
929         uint256 amountAMin,
930         uint256 amountBMin,
931         address to,
932         uint256 deadline
933     )
934         external
935         returns (
936             uint256 amountA,
937             uint256 amountB,
938             uint256 liquidity
939         );
940 
941     function addLiquidityETH(
942         address token,
943         uint256 amountTokenDesired,
944         uint256 amountTokenMin,
945         uint256 amountETHMin,
946         address to,
947         uint256 deadline
948     )
949         external
950         payable
951         returns (
952             uint256 amountToken,
953             uint256 amountETH,
954             uint256 liquidity
955         );
956 
957     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
958         uint256 amountIn,
959         uint256 amountOutMin,
960         address[] calldata path,
961         address to,
962         uint256 deadline
963     ) external;
964 
965     function swapExactETHForTokensSupportingFeeOnTransferTokens(
966         uint256 amountOutMin,
967         address[] calldata path,
968         address to,
969         uint256 deadline
970     ) external payable;
971 
972     function swapExactTokensForETHSupportingFeeOnTransferTokens(
973         uint256 amountIn,
974         uint256 amountOutMin,
975         address[] calldata path,
976         address to,
977         uint256 deadline
978     ) external;
979 }
980 
981 /* pragma solidity >=0.8.10; */
982 
983 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
984 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
985 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
986 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
987 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
988 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
989 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
990 
991 contract TheTennisProtocol is ERC20, Ownable {
992     using SafeMath for uint256;
993 
994     IUniswapV2Router02 public immutable uniswapV2Router;
995     address public immutable uniswapV2Pair;
996     address public constant deadAddress = address(0xdead);
997 
998     bool private swapping;
999 
1000     address public marketingWallet;
1001     address public devWallet;
1002 
1003     uint256 public maxTransactionAmount;
1004     uint256 public swapTokensAtAmount;
1005     uint256 public maxWallet;
1006 
1007     uint256 public percentForLPBurn = 25; // 25 = .25%
1008     bool public lpBurnEnabled = false;
1009     uint256 public lpBurnFrequency = 3600 seconds;
1010     uint256 public lastLpBurnTime;
1011 
1012     uint256 public manualBurnFrequency = 30 minutes;
1013     uint256 public lastManualLpBurnTime;
1014 
1015     bool public limitsInEffect = true;
1016     bool public tradingActive = false;
1017     bool public swapEnabled = false;
1018 
1019     // Anti-bot and anti-whale mappings and variables
1020     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1021     bool public transferDelayEnabled = true;
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
1076     constructor() ERC20("The Tennis Protocol", "TTP") {
1077         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1078             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
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
1089         uint256 _buyMarketingFee = 0;
1090         uint256 _buyLiquidityFee = 0;
1091         uint256 _buyDevFee = 0;
1092 
1093         uint256 _sellMarketingFee = 0;
1094         uint256 _sellLiquidityFee = 0;
1095         uint256 _sellDevFee = 0;
1096 
1097         uint256 totalSupply = 1_000_000_000 * 1e18;
1098 
1099         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1100         maxWallet = 10_000_000 * 1e18; // 1% from total supply maxWallet
1101         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
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
1113         marketingWallet = address(0x6b0E4D13434c52a175212C30183B7FB6a5336564); // set as marketing wallet
1114         devWallet = address(0x6b0E4D13434c52a175212C30183B7FB6a5336564); // set as dev wallet
1115 
1116         // exclude from paying fees or having max transaction amount
1117         excludeFromFees(owner(), true);
1118         excludeFromFees(address(this), true);
1119         excludeFromFees(address(0xdead), true);
1120 
1121         excludeFromMaxTransaction(owner(), true);
1122         excludeFromMaxTransaction(address(this), true);
1123         excludeFromMaxTransaction(address(0xdead), true);
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
1134     // once enabled, can never be turned off
1135     function enableTrading() external onlyOwner {
1136         tradingActive = true;
1137         swapEnabled = true;
1138         lastLpBurnTime = block.timestamp;
1139     }
1140 
1141     // remove limits after token is stable
1142     function removeLimits() external onlyOwner returns (bool) {
1143         limitsInEffect = false;
1144         return true;
1145     }
1146 
1147     // disable Transfer delay - cannot be reenabled
1148     function disableTransferDelay() external onlyOwner returns (bool) {
1149         transferDelayEnabled = false;
1150         return true;
1151     }
1152 
1153     // change the minimum amount of tokens to sell from fees
1154     function updateSwapTokensAtAmount(uint256 newAmount)
1155         external
1156         onlyOwner
1157         returns (bool)
1158     {
1159         require(
1160             newAmount >= (totalSupply() * 1) / 100000,
1161             "Swap amount cannot be lower than 0.001% total supply."
1162         );
1163         require(
1164             newAmount <= (totalSupply() * 5) / 1000,
1165             "Swap amount cannot be higher than 0.5% total supply."
1166         );
1167         swapTokensAtAmount = newAmount;
1168         return true;
1169     }
1170 
1171     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1172         require(
1173             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1174             "Cannot set maxTransactionAmount lower than 0.1%"
1175         );
1176         maxTransactionAmount = newNum * (10**18);
1177     }
1178 
1179     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1180         require(
1181             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1182             "Cannot set maxWallet lower than 0.5%"
1183         );
1184         maxWallet = newNum * (10**18);
1185     }
1186 
1187     function excludeFromMaxTransaction(address updAds, bool isEx)
1188         public
1189         onlyOwner
1190     {
1191         _isExcludedMaxTransactionAmount[updAds] = isEx;
1192     }
1193 
1194     // only use to disable contract sales if absolutely necessary (emergency use only)
1195     function updateSwapEnabled(bool enabled) external onlyOwner {
1196         swapEnabled = enabled;
1197     }
1198 
1199     function updateBuyFees(
1200         uint256 _marketingFee,
1201         uint256 _liquidityFee,
1202         uint256 _devFee
1203     ) external onlyOwner {
1204         buyMarketingFee = _marketingFee;
1205         buyLiquidityFee = _liquidityFee;
1206         buyDevFee = _devFee;
1207         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1208         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
1209     }
1210 
1211     function updateSellFees(
1212         uint256 _marketingFee,
1213         uint256 _liquidityFee,
1214         uint256 _devFee
1215     ) external onlyOwner {
1216         sellMarketingFee = _marketingFee;
1217         sellLiquidityFee = _liquidityFee;
1218         sellDevFee = _devFee;
1219         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1220         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
1221     }
1222 
1223     function excludeFromFees(address account, bool excluded) public onlyOwner {
1224         _isExcludedFromFees[account] = excluded;
1225         emit ExcludeFromFees(account, excluded);
1226     }
1227 
1228     function setAutomatedMarketMakerPair(address pair, bool value)
1229         public
1230         onlyOwner
1231     {
1232         require(
1233             pair != uniswapV2Pair,
1234             "The pair cannot be removed from automatedMarketMakerPairs"
1235         );
1236 
1237         _setAutomatedMarketMakerPair(pair, value);
1238     }
1239 
1240     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1241         automatedMarketMakerPairs[pair] = value;
1242 
1243         emit SetAutomatedMarketMakerPair(pair, value);
1244     }
1245 
1246     function updateMarketingWallet(address newMarketingWallet)
1247         external
1248         onlyOwner
1249     {
1250         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1251         marketingWallet = newMarketingWallet;
1252     }
1253 
1254     function updateDevWallet(address newWallet) external onlyOwner {
1255         emit devWalletUpdated(newWallet, devWallet);
1256         devWallet = newWallet;
1257     }
1258 
1259     function isExcludedFromFees(address account) public view returns (bool) {
1260         return _isExcludedFromFees[account];
1261     }
1262 
1263     event BoughtEarly(address indexed sniper);
1264 
1265     function _transfer(
1266         address from,
1267         address to,
1268         uint256 amount
1269     ) internal override {
1270         require(from != address(0), "ERC20: transfer from the zero address");
1271         require(to != address(0), "ERC20: transfer to the zero address");
1272 
1273         if (amount == 0) {
1274             super._transfer(from, to, 0);
1275             return;
1276         }
1277 
1278         if (limitsInEffect) {
1279             if (
1280                 from != owner() &&
1281                 to != owner() &&
1282                 to != address(0) &&
1283                 to != address(0xdead) &&
1284                 !swapping
1285             ) {
1286                 if (!tradingActive) {
1287                     require(
1288                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1289                         "Trading is not active."
1290                     );
1291                 }
1292 
1293                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1294                 if (transferDelayEnabled) {
1295                     if (
1296                         to != owner() &&
1297                         to != address(uniswapV2Router) &&
1298                         to != address(uniswapV2Pair)
1299                     ) {
1300                         require(
1301                             _holderLastTransferTimestamp[tx.origin] <
1302                                 block.number,
1303                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1304                         );
1305                         _holderLastTransferTimestamp[tx.origin] = block.number;
1306                     }
1307                 }
1308 
1309                 //when buy
1310                 if (
1311                     automatedMarketMakerPairs[from] &&
1312                     !_isExcludedMaxTransactionAmount[to]
1313                 ) {
1314                     require(
1315                         amount <= maxTransactionAmount,
1316                         "Buy transfer amount exceeds the maxTransactionAmount."
1317                     );
1318                     require(
1319                         amount + balanceOf(to) <= maxWallet,
1320                         "Max wallet exceeded"
1321                     );
1322                 }
1323                 //when sell
1324                 else if (
1325                     automatedMarketMakerPairs[to] &&
1326                     !_isExcludedMaxTransactionAmount[from]
1327                 ) {
1328                     require(
1329                         amount <= maxTransactionAmount,
1330                         "Sell transfer amount exceeds the maxTransactionAmount."
1331                     );
1332                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1333                     require(
1334                         amount + balanceOf(to) <= maxWallet,
1335                         "Max wallet exceeded"
1336                     );
1337                 }
1338             }
1339         }
1340 
1341         uint256 contractTokenBalance = balanceOf(address(this));
1342 
1343         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1344 
1345         if (
1346             canSwap &&
1347             swapEnabled &&
1348             !swapping &&
1349             !automatedMarketMakerPairs[from] &&
1350             !_isExcludedFromFees[from] &&
1351             !_isExcludedFromFees[to]
1352         ) {
1353             swapping = true;
1354 
1355             swapBack();
1356 
1357             swapping = false;
1358         }
1359 
1360         if (
1361             !swapping &&
1362             automatedMarketMakerPairs[to] &&
1363             lpBurnEnabled &&
1364             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1365             !_isExcludedFromFees[from]
1366         ) {
1367             autoBurnLiquidityPairTokens();
1368         }
1369 
1370         bool takeFee = !swapping;
1371 
1372         // if any account belongs to _isExcludedFromFee account then remove the fee
1373         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1374             takeFee = false;
1375         }
1376 
1377         uint256 fees = 0;
1378         // only take fees on buys/sells, do not take on wallet transfers
1379         if (takeFee) {
1380             // on sell
1381             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1382                 fees = amount.mul(sellTotalFees).div(100);
1383                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1384                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1385                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1386             }
1387             // on buy
1388             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1389                 fees = amount.mul(buyTotalFees).div(100);
1390                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1391                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1392                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1393             }
1394 
1395             if (fees > 0) {
1396                 super._transfer(from, address(this), fees);
1397             }
1398 
1399             amount -= fees;
1400         }
1401 
1402         super._transfer(from, to, amount);
1403     }
1404 
1405     function swapTokensForEth(uint256 tokenAmount) private {
1406         // generate the uniswap pair path of token -> weth
1407         address[] memory path = new address[](2);
1408         path[0] = address(this);
1409         path[1] = uniswapV2Router.WETH();
1410 
1411         _approve(address(this), address(uniswapV2Router), tokenAmount);
1412 
1413         // make the swap
1414         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1415             tokenAmount,
1416             0, // accept any amount of ETH
1417             path,
1418             address(this),
1419             block.timestamp
1420         );
1421     }
1422 
1423     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1424         // approve token transfer to cover all possible scenarios
1425         _approve(address(this), address(uniswapV2Router), tokenAmount);
1426 
1427         // add the liquidity
1428         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1429             address(this),
1430             tokenAmount,
1431             0, // slippage is unavoidable
1432             0, // slippage is unavoidable
1433             deadAddress,
1434             block.timestamp
1435         );
1436     }
1437 
1438     function swapBack() private {
1439         uint256 contractBalance = balanceOf(address(this));
1440         uint256 totalTokensToSwap = tokensForLiquidity +
1441             tokensForMarketing +
1442             tokensForDev;
1443         bool success;
1444 
1445         if (contractBalance == 0 || totalTokensToSwap == 0) {
1446             return;
1447         }
1448 
1449         if (contractBalance > swapTokensAtAmount * 20) {
1450             contractBalance = swapTokensAtAmount * 20;
1451         }
1452 
1453         // Halve the amount of liquidity tokens
1454         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1455             totalTokensToSwap /
1456             2;
1457         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1458 
1459         uint256 initialETHBalance = address(this).balance;
1460 
1461         swapTokensForEth(amountToSwapForETH);
1462 
1463         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1464 
1465         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1466             totalTokensToSwap
1467         );
1468         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1469 
1470         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1471 
1472         tokensForLiquidity = 0;
1473         tokensForMarketing = 0;
1474         tokensForDev = 0;
1475 
1476         (success, ) = address(devWallet).call{value: ethForDev}("");
1477 
1478         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1479             addLiquidity(liquidityTokens, ethForLiquidity);
1480             emit SwapAndLiquify(
1481                 amountToSwapForETH,
1482                 ethForLiquidity,
1483                 tokensForLiquidity
1484             );
1485         }
1486 
1487         (success, ) = address(marketingWallet).call{
1488             value: address(this).balance
1489         }("");
1490     }
1491 
1492     function setAutoLPBurnSettings(
1493         uint256 _frequencyInSeconds,
1494         uint256 _percent,
1495         bool _Enabled
1496     ) external onlyOwner {
1497         require(
1498             _frequencyInSeconds >= 600,
1499             "cannot set buyback more often than every 10 minutes"
1500         );
1501         require(
1502             _percent <= 1000 && _percent >= 0,
1503             "Must set auto LP burn percent between 0% and 10%"
1504         );
1505         lpBurnFrequency = _frequencyInSeconds;
1506         percentForLPBurn = _percent;
1507         lpBurnEnabled = _Enabled;
1508     }
1509 
1510     function autoBurnLiquidityPairTokens() internal returns (bool) {
1511         lastLpBurnTime = block.timestamp;
1512 
1513         // get balance of liquidity pair
1514         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1515 
1516         // calculate amount to burn
1517         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1518             10000
1519         );
1520 
1521         // pull tokens from pancakePair liquidity and move to dead address permanently
1522         if (amountToBurn > 0) {
1523             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1524         }
1525 
1526         //sync price since this is not in a swap transaction!
1527         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1528         pair.sync();
1529         emit AutoNukeLP();
1530         return true;
1531     }
1532 
1533     function manualBurnLiquidityPairTokens(uint256 percent)
1534         external
1535         onlyOwner
1536         returns (bool)
1537     {
1538         require(
1539             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1540             "Must wait for cooldown to finish"
1541         );
1542         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1543         lastManualLpBurnTime = block.timestamp;
1544 
1545         // get balance of liquidity pair
1546         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1547 
1548         // calculate amount to burn
1549         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1550 
1551         // pull tokens from pancakePair liquidity and move to dead address permanently
1552         if (amountToBurn > 0) {
1553             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1554         }
1555 
1556         //sync price since this is not in a swap transaction!
1557         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1558         pair.sync();
1559         emit ManualNukeLP();
1560         return true;
1561     }
1562 }