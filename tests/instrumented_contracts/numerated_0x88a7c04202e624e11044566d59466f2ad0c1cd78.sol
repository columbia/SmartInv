1 // TG: https://t.me/ConvexNalitism
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
5 pragma experimental ABIEncoderV2;
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     /**
29      * @dev Returns the address of the current owner.
30      */
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47     /**
48      * @dev Transfers ownership of the contract to a new account (`newOwner`).
49      * Can only be called by the current owner.
50      */
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         _transferOwnership(newOwner);
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Internal function without access restriction.
59      */
60     function _transferOwnership(address newOwner) internal virtual {
61         address oldOwner = _owner;
62         _owner = newOwner;
63         emit OwnershipTransferred(oldOwner, newOwner);
64     }
65 }
66 
67 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
68 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
69 
70 /* pragma solidity ^0.8.0; */
71 
72 /**
73  * @dev Interface of the ERC20 standard as defined in the EIP.
74  */
75 interface IERC20 {
76     /**
77      * @dev Returns the amount of tokens in existence.
78      */
79     function totalSupply() external view returns (uint256);
80 
81     /**
82      * @dev Returns the amount of tokens owned by `account`.
83      */
84     function balanceOf(address account) external view returns (uint256);
85 
86     /**
87      * @dev Moves `amount` tokens from the caller's account to `recipient`.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transfer(address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Returns the remaining number of tokens that `spender` will be
97      * allowed to spend on behalf of `owner` through {transferFrom}. This is
98      * zero by default.
99      *
100      * This value changes when {approve} or {transferFrom} are called.
101      */
102     function allowance(address owner, address spender) external view returns (uint256);
103 
104     /**
105      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * IMPORTANT: Beware that changing an allowance with this method brings the risk
110      * that someone may use both the old and the new allowance by unfortunate
111      * transaction ordering. One possible solution to mitigate this race
112      * condition is to first reduce the spender's allowance to 0 and set the
113      * desired value afterwards:
114      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address spender, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Moves `amount` tokens from `sender` to `recipient` using the
122      * allowance mechanism. `amount` is then deducted from the caller's
123      * allowance.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(
130         address sender,
131         address recipient,
132         uint256 amount
133     ) external returns (bool);
134 
135     /**
136      * @dev Emitted when `value` tokens are moved from one account (`from`) to
137      * another (`to`).
138      *
139      * Note that `value` may be zero.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     /**
144      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
145      * a call to {approve}. `value` is the new allowance.
146      */
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
151 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
152 
153 /* pragma solidity ^0.8.0; */
154 
155 /* import "../IERC20.sol"; */
156 
157 /**
158  * @dev Interface for the optional metadata functions from the ERC20 standard.
159  *
160  * _Available since v4.1._
161  */
162 interface IERC20Metadata is IERC20 {
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() external view returns (string memory);
167 
168     /**
169      * @dev Returns the symbol of the token.
170      */
171     function symbol() external view returns (string memory);
172 
173     /**
174      * @dev Returns the decimals places of the token.
175      */
176     function decimals() external view returns (uint8);
177 }
178 
179 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
180 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
181 
182 /* pragma solidity ^0.8.0; */
183 
184 /* import "./IERC20.sol"; */
185 /* import "./extensions/IERC20Metadata.sol"; */
186 /* import "../../utils/Context.sol"; */
187 
188 /**
189  * @dev Implementation of the {IERC20} interface.
190  *
191  * This implementation is agnostic to the way tokens are created. This means
192  * that a supply mechanism has to be added in a derived contract using {_mint}.
193  * For a generic mechanism see {ERC20PresetMinterPauser}.
194  *
195  * TIP: For a detailed writeup see our guide
196  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
197  * to implement supply mechanisms].
198  *
199  * We have followed general OpenZeppelin Contracts guidelines: functions revert
200  * instead returning `false` on failure. This behavior is nonetheless
201  * conventional and does not conflict with the expectations of ERC20
202  * applications.
203  *
204  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
205  * This allows applications to reconstruct the allowance for all accounts just
206  * by listening to said events. Other implementations of the EIP may not emit
207  * these events, as it isn't required by the specification.
208  *
209  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
210  * functions have been added to mitigate the well-known issues around setting
211  * allowances. See {IERC20-approve}.
212  */
213 contract ERC20 is Context, IERC20, IERC20Metadata {
214     mapping(address => uint256) private _balances;
215 
216     mapping(address => mapping(address => uint256)) private _allowances;
217 
218     uint256 private _totalSupply;
219 
220     string private _name;
221     string private _symbol;
222 
223     /**
224      * @dev Sets the values for {name} and {symbol}.
225      *
226      * The default value of {decimals} is 18. To select a different value for
227      * {decimals} you should overload it.
228      *
229      * All two of these values are immutable: they can only be set once during
230      * construction.
231      */
232     constructor(string memory name_, string memory symbol_) {
233         _name = name_;
234         _symbol = symbol_;
235     }
236 
237     /**
238      * @dev Returns the name of the token.
239      */
240     function name() public view virtual override returns (string memory) {
241         return _name;
242     }
243 
244     /**
245      * @dev Returns the symbol of the token, usually a shorter version of the
246      * name.
247      */
248     function symbol() public view virtual override returns (string memory) {
249         return _symbol;
250     }
251 
252     /**
253      * @dev Returns the number of decimals used to get its user representation.
254      * For example, if `decimals` equals `2`, a balance of `505` tokens should
255      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
256      *
257      * Tokens usually opt for a value of 18, imitating the relationship between
258      * Ether and Wei. This is the value {ERC20} uses, unless this function is
259      * overridden;
260      *
261      * NOTE: This information is only used for _display_ purposes: it in
262      * no way affects any of the arithmetic of the contract, including
263      * {IERC20-balanceOf} and {IERC20-transfer}.
264      */
265     function decimals() public view virtual override returns (uint8) {
266         return 18;
267     }
268 
269     /**
270      * @dev See {IERC20-totalSupply}.
271      */
272     function totalSupply() public view virtual override returns (uint256) {
273         return _totalSupply;
274     }
275 
276     /**
277      * @dev See {IERC20-balanceOf}.
278      */
279     function balanceOf(address account) public view virtual override returns (uint256) {
280         return _balances[account];
281     }
282 
283     /**
284      * @dev See {IERC20-transfer}.
285      *
286      * Requirements:
287      *
288      * - `recipient` cannot be the zero address.
289      * - the caller must have a balance of at least `amount`.
290      */
291     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
292         _transfer(_msgSender(), recipient, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-allowance}.
298      */
299     function allowance(address owner, address spender) public view virtual override returns (uint256) {
300         return _allowances[owner][spender];
301     }
302 
303     /**
304      * @dev See {IERC20-approve}.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function approve(address spender, uint256 amount) public virtual override returns (bool) {
311         _approve(_msgSender(), spender, amount);
312         return true;
313     }
314 
315     /**
316      * @dev See {IERC20-transferFrom}.
317      *
318      * Emits an {Approval} event indicating the updated allowance. This is not
319      * required by the EIP. See the note at the beginning of {ERC20}.
320      *
321      * Requirements:
322      *
323      * - `sender` and `recipient` cannot be the zero address.
324      * - `sender` must have a balance of at least `amount`.
325      * - the caller must have allowance for ``sender``'s tokens of at least
326      * `amount`.
327      */
328     function transferFrom(
329         address sender,
330         address recipient,
331         uint256 amount
332     ) public virtual override returns (bool) {
333         _transfer(sender, recipient, amount);
334 
335         uint256 currentAllowance = _allowances[sender][_msgSender()];
336         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
337         unchecked {
338             _approve(sender, _msgSender(), currentAllowance - amount);
339         }
340 
341         return true;
342     }
343 
344     /**
345      * @dev Atomically increases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
357         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
358         return true;
359     }
360 
361     /**
362      * @dev Atomically decreases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to {approve} that can be used as a mitigation for
365      * problems described in {IERC20-approve}.
366      *
367      * Emits an {Approval} event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      * - `spender` must have allowance for the caller of at least
373      * `subtractedValue`.
374      */
375     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
376         uint256 currentAllowance = _allowances[_msgSender()][spender];
377         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
378         unchecked {
379             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
380         }
381 
382         return true;
383     }
384 
385     /**
386      * @dev Moves `amount` of tokens from `sender` to `recipient`.
387      *
388      * This internal function is equivalent to {transfer}, and can be used to
389      * e.g. implement automatic token fees, slashing mechanisms, etc.
390      *
391      * Emits a {Transfer} event.
392      *
393      * Requirements:
394      *
395      * - `sender` cannot be the zero address.
396      * - `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      */
399     function _transfer(
400         address sender,
401         address recipient,
402         uint256 amount
403     ) internal virtual {
404         require(sender != address(0), "ERC20: transfer from the zero address");
405         require(recipient != address(0), "ERC20: transfer to the zero address");
406 
407         _beforeTokenTransfer(sender, recipient, amount);
408 
409         uint256 senderBalance = _balances[sender];
410         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
411         unchecked {
412             _balances[sender] = senderBalance - amount;
413         }
414         _balances[recipient] += amount;
415 
416         emit Transfer(sender, recipient, amount);
417 
418         _afterTokenTransfer(sender, recipient, amount);
419     }
420 
421     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
422      * the total supply.
423      *
424      * Emits a {Transfer} event with `from` set to the zero address.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      */
430     function _mint(address account, uint256 amount) internal virtual {
431         require(account != address(0), "ERC20: mint to the zero address");
432 
433         _beforeTokenTransfer(address(0), account, amount);
434 
435         _totalSupply += amount;
436         _balances[account] += amount;
437         emit Transfer(address(0), account, amount);
438 
439         _afterTokenTransfer(address(0), account, amount);
440     }
441 
442     /**
443      * @dev Destroys `amount` tokens from `account`, reducing the
444      * total supply.
445      *
446      * Emits a {Transfer} event with `to` set to the zero address.
447      *
448      * Requirements:
449      *
450      * - `account` cannot be the zero address.
451      * - `account` must have at least `amount` tokens.
452      */
453     function _burn(address account, uint256 amount) internal virtual {
454         require(account != address(0), "ERC20: burn from the zero address");
455 
456         _beforeTokenTransfer(account, address(0), amount);
457 
458         uint256 accountBalance = _balances[account];
459         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
460         unchecked {
461             _balances[account] = accountBalance - amount;
462         }
463         _totalSupply -= amount;
464 
465         emit Transfer(account, address(0), amount);
466 
467         _afterTokenTransfer(account, address(0), amount);
468     }
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
472      *
473      * This internal function is equivalent to `approve`, and can be used to
474      * e.g. set automatic allowances for certain subsystems, etc.
475      *
476      * Emits an {Approval} event.
477      *
478      * Requirements:
479      *
480      * - `owner` cannot be the zero address.
481      * - `spender` cannot be the zero address.
482      */
483     function _approve(
484         address owner,
485         address spender,
486         uint256 amount
487     ) internal virtual {
488         require(owner != address(0), "ERC20: approve from the zero address");
489         require(spender != address(0), "ERC20: approve to the zero address");
490 
491         _allowances[owner][spender] = amount;
492         emit Approval(owner, spender, amount);
493     }
494 
495     /**
496      * @dev Hook that is called before any transfer of tokens. This includes
497      * minting and burning.
498      *
499      * Calling conditions:
500      *
501      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
502      * will be transferred to `to`.
503      * - when `from` is zero, `amount` tokens will be minted for `to`.
504      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
505      * - `from` and `to` are never both zero.
506      *
507      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
508      */
509     function _beforeTokenTransfer(
510         address from,
511         address to,
512         uint256 amount
513     ) internal virtual {}
514 
515     /**
516      * @dev Hook that is called after any transfer of tokens. This includes
517      * minting and burning.
518      *
519      * Calling conditions:
520      *
521      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
522      * has been transferred to `to`.
523      * - when `from` is zero, `amount` tokens have been minted for `to`.
524      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
525      * - `from` and `to` are never both zero.
526      *
527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
528      */
529     function _afterTokenTransfer(
530         address from,
531         address to,
532         uint256 amount
533     ) internal virtual {}
534 }
535 
536 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
537 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
538 
539 /* pragma solidity ^0.8.0; */
540 
541 // CAUTION
542 // This version of SafeMath should only be used with Solidity 0.8 or later,
543 // because it relies on the compiler's built in overflow checks.
544 
545 /**
546  * @dev Wrappers over Solidity's arithmetic operations.
547  *
548  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
549  * now has built in overflow checking.
550  */
551 library SafeMath {
552     /**
553      * @dev Returns the addition of two unsigned integers, with an overflow flag.
554      *
555      * _Available since v3.4._
556      */
557     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
558         unchecked {
559             uint256 c = a + b;
560             if (c < a) return (false, 0);
561             return (true, c);
562         }
563     }
564 
565     /**
566      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
567      *
568      * _Available since v3.4._
569      */
570     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             if (b > a) return (false, 0);
573             return (true, a - b);
574         }
575     }
576 
577     /**
578      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
579      *
580      * _Available since v3.4._
581      */
582     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
583         unchecked {
584             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
585             // benefit is lost if 'b' is also tested.
586             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
587             if (a == 0) return (true, 0);
588             uint256 c = a * b;
589             if (c / a != b) return (false, 0);
590             return (true, c);
591         }
592     }
593 
594     /**
595      * @dev Returns the division of two unsigned integers, with a division by zero flag.
596      *
597      * _Available since v3.4._
598      */
599     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             if (b == 0) return (false, 0);
602             return (true, a / b);
603         }
604     }
605 
606     /**
607      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
608      *
609      * _Available since v3.4._
610      */
611     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         unchecked {
613             if (b == 0) return (false, 0);
614             return (true, a % b);
615         }
616     }
617 
618     /**
619      * @dev Returns the addition of two unsigned integers, reverting on
620      * overflow.
621      *
622      * Counterpart to Solidity's `+` operator.
623      *
624      * Requirements:
625      *
626      * - Addition cannot overflow.
627      */
628     function add(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a + b;
630     }
631 
632     /**
633      * @dev Returns the subtraction of two unsigned integers, reverting on
634      * overflow (when the result is negative).
635      *
636      * Counterpart to Solidity's `-` operator.
637      *
638      * Requirements:
639      *
640      * - Subtraction cannot overflow.
641      */
642     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a - b;
644     }
645 
646     /**
647      * @dev Returns the multiplication of two unsigned integers, reverting on
648      * overflow.
649      *
650      * Counterpart to Solidity's `*` operator.
651      *
652      * Requirements:
653      *
654      * - Multiplication cannot overflow.
655      */
656     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
657         return a * b;
658     }
659 
660     /**
661      * @dev Returns the integer division of two unsigned integers, reverting on
662      * division by zero. The result is rounded towards zero.
663      *
664      * Counterpart to Solidity's `/` operator.
665      *
666      * Requirements:
667      *
668      * - The divisor cannot be zero.
669      */
670     function div(uint256 a, uint256 b) internal pure returns (uint256) {
671         return a / b;
672     }
673 
674     /**
675      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
676      * reverting when dividing by zero.
677      *
678      * Counterpart to Solidity's `%` operator. This function uses a `revert`
679      * opcode (which leaves remaining gas untouched) while Solidity uses an
680      * invalid opcode to revert (consuming all remaining gas).
681      *
682      * Requirements:
683      *
684      * - The divisor cannot be zero.
685      */
686     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
687         return a % b;
688     }
689 
690     /**
691      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
692      * overflow (when the result is negative).
693      *
694      * CAUTION: This function is deprecated because it requires allocating memory for the error
695      * message unnecessarily. For custom revert reasons use {trySub}.
696      *
697      * Counterpart to Solidity's `-` operator.
698      *
699      * Requirements:
700      *
701      * - Subtraction cannot overflow.
702      */
703     function sub(
704         uint256 a,
705         uint256 b,
706         string memory errorMessage
707     ) internal pure returns (uint256) {
708         unchecked {
709             require(b <= a, errorMessage);
710             return a - b;
711         }
712     }
713 
714     /**
715      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
716      * division by zero. The result is rounded towards zero.
717      *
718      * Counterpart to Solidity's `/` operator. Note: this function uses a
719      * `revert` opcode (which leaves remaining gas untouched) while Solidity
720      * uses an invalid opcode to revert (consuming all remaining gas).
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function div(
727         uint256 a,
728         uint256 b,
729         string memory errorMessage
730     ) internal pure returns (uint256) {
731         unchecked {
732             require(b > 0, errorMessage);
733             return a / b;
734         }
735     }
736 
737     /**
738      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
739      * reverting with custom message when dividing by zero.
740      *
741      * CAUTION: This function is deprecated because it requires allocating memory for the error
742      * message unnecessarily. For custom revert reasons use {tryMod}.
743      *
744      * Counterpart to Solidity's `%` operator. This function uses a `revert`
745      * opcode (which leaves remaining gas untouched) while Solidity uses an
746      * invalid opcode to revert (consuming all remaining gas).
747      *
748      * Requirements:
749      *
750      * - The divisor cannot be zero.
751      */
752     function mod(
753         uint256 a,
754         uint256 b,
755         string memory errorMessage
756     ) internal pure returns (uint256) {
757         unchecked {
758             require(b > 0, errorMessage);
759             return a % b;
760         }
761     }
762 }
763 
764 ////// src/IUniswapV2Factory.sol
765 /* pragma solidity 0.8.10; */
766 /* pragma experimental ABIEncoderV2; */
767 
768 interface IUniswapV2Factory {
769     event PairCreated(
770         address indexed token0,
771         address indexed token1,
772         address pair,
773         uint256
774     );
775 
776     function feeTo() external view returns (address);
777 
778     function feeToSetter() external view returns (address);
779 
780     function getPair(address tokenA, address tokenB)
781         external
782         view
783         returns (address pair);
784 
785     function allPairs(uint256) external view returns (address pair);
786 
787     function allPairsLength() external view returns (uint256);
788 
789     function createPair(address tokenA, address tokenB)
790         external
791         returns (address pair);
792 
793     function setFeeTo(address) external;
794 
795     function setFeeToSetter(address) external;
796 }
797 
798 ////// src/IUniswapV2Pair.sol
799 /* pragma solidity 0.8.10; */
800 /* pragma experimental ABIEncoderV2; */
801 
802 interface IUniswapV2Pair {
803     event Approval(
804         address indexed owner,
805         address indexed spender,
806         uint256 value
807     );
808     event Transfer(address indexed from, address indexed to, uint256 value);
809 
810     function name() external pure returns (string memory);
811 
812     function symbol() external pure returns (string memory);
813 
814     function decimals() external pure returns (uint8);
815 
816     function totalSupply() external view returns (uint256);
817 
818     function balanceOf(address owner) external view returns (uint256);
819 
820     function allowance(address owner, address spender)
821         external
822         view
823         returns (uint256);
824 
825     function approve(address spender, uint256 value) external returns (bool);
826 
827     function transfer(address to, uint256 value) external returns (bool);
828 
829     function transferFrom(
830         address from,
831         address to,
832         uint256 value
833     ) external returns (bool);
834 
835     function DOMAIN_SEPARATOR() external view returns (bytes32);
836 
837     function PERMIT_TYPEHASH() external pure returns (bytes32);
838 
839     function nonces(address owner) external view returns (uint256);
840 
841     function permit(
842         address owner,
843         address spender,
844         uint256 value,
845         uint256 deadline,
846         uint8 v,
847         bytes32 r,
848         bytes32 s
849     ) external;
850 
851     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
852     event Burn(
853         address indexed sender,
854         uint256 amount0,
855         uint256 amount1,
856         address indexed to
857     );
858     event Swap(
859         address indexed sender,
860         uint256 amount0In,
861         uint256 amount1In,
862         uint256 amount0Out,
863         uint256 amount1Out,
864         address indexed to
865     );
866     event Sync(uint112 reserve0, uint112 reserve1);
867 
868     function MINIMUM_LIQUIDITY() external pure returns (uint256);
869 
870     function factory() external view returns (address);
871 
872     function token0() external view returns (address);
873 
874     function token1() external view returns (address);
875 
876     function getReserves()
877         external
878         view
879         returns (
880             uint112 reserve0,
881             uint112 reserve1,
882             uint32 blockTimestampLast
883         );
884 
885     function price0CumulativeLast() external view returns (uint256);
886 
887     function price1CumulativeLast() external view returns (uint256);
888 
889     function kLast() external view returns (uint256);
890 
891     function mint(address to) external returns (uint256 liquidity);
892 
893     function burn(address to)
894         external
895         returns (uint256 amount0, uint256 amount1);
896 
897     function swap(
898         uint256 amount0Out,
899         uint256 amount1Out,
900         address to,
901         bytes calldata data
902     ) external;
903 
904     function skim(address to) external;
905 
906     function sync() external;
907 
908     function initialize(address, address) external;
909 }
910 
911 ////// src/IUniswapV2Router02.sol
912 /* pragma solidity 0.8.10; */
913 /* pragma experimental ABIEncoderV2; */
914 
915 interface IUniswapV2Router02 {
916     function factory() external pure returns (address);
917 
918     function WETH() external pure returns (address);
919 
920     function addLiquidity(
921         address tokenA,
922         address tokenB,
923         uint256 amountADesired,
924         uint256 amountBDesired,
925         uint256 amountAMin,
926         uint256 amountBMin,
927         address to,
928         uint256 deadline
929     )
930         external
931         returns (
932             uint256 amountA,
933             uint256 amountB,
934             uint256 liquidity
935         );
936 
937     function addLiquidityETH(
938         address token,
939         uint256 amountTokenDesired,
940         uint256 amountTokenMin,
941         uint256 amountETHMin,
942         address to,
943         uint256 deadline
944     )
945         external
946         payable
947         returns (
948             uint256 amountToken,
949             uint256 amountETH,
950             uint256 liquidity
951         );
952 
953     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
954         uint256 amountIn,
955         uint256 amountOutMin,
956         address[] calldata path,
957         address to,
958         uint256 deadline
959     ) external;
960 
961     function swapExactETHForTokensSupportingFeeOnTransferTokens(
962         uint256 amountOutMin,
963         address[] calldata path,
964         address to,
965         uint256 deadline
966     ) external payable;
967 
968     function swapExactTokensForETHSupportingFeeOnTransferTokens(
969         uint256 amountIn,
970         uint256 amountOutMin,
971         address[] calldata path,
972         address to,
973         uint256 deadline
974     ) external;
975 }
976 
977 /* pragma solidity >=0.8.10; */
978 
979 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
980 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
981 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
982 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
983 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
984 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
985 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
986 
987 contract Convexnatalism is ERC20, Ownable {
988     using SafeMath for uint256;
989 
990     IUniswapV2Router02 public immutable uniswapV2Router;
991     address public immutable uniswapV2Pair;
992     address public constant deadAddress = address(0xdead);
993 
994     bool private swapping;
995 
996     address public marketingWallet;
997     address public devWallet;
998 
999     uint256 public maxTransactionAmount;
1000     uint256 public swapTokensAtAmount;
1001     uint256 public maxWallet;
1002 
1003     uint256 public percentForLPBurn = 25; // 25 = .25%
1004     bool public lpBurnEnabled = false;
1005     uint256 public lpBurnFrequency = 3600 seconds;
1006     uint256 public lastLpBurnTime;
1007 
1008     uint256 public manualBurnFrequency = 30 minutes;
1009     uint256 public lastManualLpBurnTime;
1010 
1011     bool public limitsInEffect = true;
1012     bool public tradingActive = true;
1013     bool public swapEnabled = true;
1014 
1015     // Anti-bot and anti-whale mappings and variables
1016     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1017     bool public transferDelayEnabled = false;
1018 
1019     uint256 public buyTotalFees;
1020     uint256 public buyMarketingFee;
1021     uint256 public buyLiquidityFee;
1022     uint256 public buyDevFee;
1023 
1024     uint256 public sellTotalFees;
1025     uint256 public sellMarketingFee;
1026     uint256 public sellLiquidityFee;
1027     uint256 public sellDevFee;
1028 
1029     uint256 public tokensForMarketing;
1030     uint256 public tokensForLiquidity;
1031     uint256 public tokensForDev;
1032 
1033     /******************/
1034 
1035     // exlcude from fees and max transaction amount
1036     mapping(address => bool) private _isExcludedFromFees;
1037     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1038 
1039     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1040     // could be subject to a maximum transfer amount
1041     mapping(address => bool) public automatedMarketMakerPairs;
1042 
1043     event UpdateUniswapV2Router(
1044         address indexed newAddress,
1045         address indexed oldAddress
1046     );
1047 
1048     event ExcludeFromFees(address indexed account, bool isExcluded);
1049 
1050     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1051 
1052     event marketingWalletUpdated(
1053         address indexed newWallet,
1054         address indexed oldWallet
1055     );
1056 
1057     event devWalletUpdated(
1058         address indexed newWallet,
1059         address indexed oldWallet
1060     );
1061 
1062     event SwapAndLiquify(
1063         uint256 tokensSwapped,
1064         uint256 ethReceived,
1065         uint256 tokensIntoLiquidity
1066     );
1067 
1068     event AutoNukeLP();
1069 
1070     event ManualNukeLP();
1071 
1072     constructor() ERC20("Convex-natalism", "CNX") {
1073         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1074             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1075         );
1076 
1077         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1078         uniswapV2Router = _uniswapV2Router;
1079 
1080         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1081             .createPair(address(this), _uniswapV2Router.WETH());
1082         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1083         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1084 
1085         uint256 _buyMarketingFee = 3;
1086         uint256 _buyLiquidityFee = 0;
1087         uint256 _buyDevFee = 1;
1088 
1089         uint256 _sellMarketingFee = 3;
1090         uint256 _sellLiquidityFee = 0;
1091         uint256 _sellDevFee = 1;
1092 
1093         uint256 totalSupply = 1_000_000_000 * 1e18;
1094 
1095         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1096         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1097         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1098 
1099         buyMarketingFee = _buyMarketingFee;
1100         buyLiquidityFee = _buyLiquidityFee;
1101         buyDevFee = _buyDevFee;
1102         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1103 
1104         sellMarketingFee = _sellMarketingFee;
1105         sellLiquidityFee = _sellLiquidityFee;
1106         sellDevFee = _sellDevFee;
1107         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1108 
1109         marketingWallet = address(0xC0bc4FaAF9e703FDD6114D033f2d07e55592Bf36); // set as marketing wallet
1110         devWallet = address(0xC0bc4FaAF9e703FDD6114D033f2d07e55592Bf36); // set as dev wallet
1111 
1112         // exclude from paying fees or having max transaction amount
1113         excludeFromFees(owner(), true);
1114         excludeFromFees(address(this), true);
1115         excludeFromFees(address(0xdead), true);
1116 
1117         excludeFromMaxTransaction(owner(), true);
1118         excludeFromMaxTransaction(address(this), true);
1119         excludeFromMaxTransaction(address(0xdead), true);
1120 
1121         /*
1122             _mint is an internal function in ERC20.sol that is only called here,
1123             and CANNOT be called ever again
1124         */
1125         _mint(msg.sender, totalSupply);
1126     }
1127 
1128     receive() external payable {}
1129 
1130     // once enabled, can never be turned off
1131     function enableTrading() external onlyOwner {
1132         tradingActive = true;
1133         swapEnabled = true;
1134         lastLpBurnTime = block.timestamp;
1135     }
1136 
1137     // remove limits after token is stable
1138     function removeLimits() external onlyOwner returns (bool) {
1139         limitsInEffect = false;
1140         return true;
1141     }
1142 
1143     // disable Transfer delay - cannot be reenabled
1144     function disableTransferDelay() external onlyOwner returns (bool) {
1145         transferDelayEnabled = false;
1146         return true;
1147     }
1148 
1149     // change the minimum amount of tokens to sell from fees
1150     function updateSwapTokensAtAmount(uint256 newAmount)
1151         external
1152         onlyOwner
1153         returns (bool)
1154     {
1155         require(
1156             newAmount >= (totalSupply() * 1) / 100000,
1157             "Swap amount cannot be lower than 0.001% total supply."
1158         );
1159         require(
1160             newAmount <= (totalSupply() * 5) / 1000,
1161             "Swap amount cannot be higher than 0.5% total supply."
1162         );
1163         swapTokensAtAmount = newAmount;
1164         return true;
1165     }
1166 
1167     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1168         require(
1169             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1170             "Cannot set maxTransactionAmount lower than 0.1%"
1171         );
1172         maxTransactionAmount = newNum * (10**18);
1173     }
1174 
1175     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1176         require(
1177             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1178             "Cannot set maxWallet lower than 0.5%"
1179         );
1180         maxWallet = newNum * (10**18);
1181     }
1182 
1183     function excludeFromMaxTransaction(address updAds, bool isEx)
1184         public
1185         onlyOwner
1186     {
1187         _isExcludedMaxTransactionAmount[updAds] = isEx;
1188     }
1189 
1190     // only use to disable contract sales if absolutely necessary (emergency use only)
1191     function updateSwapEnabled(bool enabled) external onlyOwner {
1192         swapEnabled = enabled;
1193     }
1194 
1195     function updateBuyFees(
1196         uint256 _marketingFee,
1197         uint256 _liquidityFee,
1198         uint256 _devFee
1199     ) external onlyOwner {
1200         buyMarketingFee = _marketingFee;
1201         buyLiquidityFee = _liquidityFee;
1202         buyDevFee = _devFee;
1203         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1204         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1205     }
1206 
1207     function updateSellFees(
1208         uint256 _marketingFee,
1209         uint256 _liquidityFee,
1210         uint256 _devFee
1211     ) external onlyOwner {
1212         sellMarketingFee = _marketingFee;
1213         sellLiquidityFee = _liquidityFee;
1214         sellDevFee = _devFee;
1215         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1216         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1217     }
1218 
1219     function excludeFromFees(address account, bool excluded) public onlyOwner {
1220         _isExcludedFromFees[account] = excluded;
1221         emit ExcludeFromFees(account, excluded);
1222     }
1223 
1224     function setAutomatedMarketMakerPair(address pair, bool value)
1225         public
1226         onlyOwner
1227     {
1228         require(
1229             pair != uniswapV2Pair,
1230             "The pair cannot be removed from automatedMarketMakerPairs"
1231         );
1232 
1233         _setAutomatedMarketMakerPair(pair, value);
1234     }
1235 
1236     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1237         automatedMarketMakerPairs[pair] = value;
1238 
1239         emit SetAutomatedMarketMakerPair(pair, value);
1240     }
1241 
1242     function updateMarketingWallet(address newMarketingWallet)
1243         external
1244         onlyOwner
1245     {
1246         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1247         marketingWallet = newMarketingWallet;
1248     }
1249 
1250     function updateDevWallet(address newWallet) external onlyOwner {
1251         emit devWalletUpdated(newWallet, devWallet);
1252         devWallet = newWallet;
1253     }
1254 
1255     function isExcludedFromFees(address account) public view returns (bool) {
1256         return _isExcludedFromFees[account];
1257     }
1258 
1259     event BoughtEarly(address indexed sniper);
1260 
1261     function _transfer(
1262         address from,
1263         address to,
1264         uint256 amount
1265     ) internal override {
1266         require(from != address(0), "ERC20: transfer from the zero address");
1267         require(to != address(0), "ERC20: transfer to the zero address");
1268 
1269         if (amount == 0) {
1270             super._transfer(from, to, 0);
1271             return;
1272         }
1273 
1274         if (limitsInEffect) {
1275             if (
1276                 from != owner() &&
1277                 to != owner() &&
1278                 to != address(0) &&
1279                 to != address(0xdead) &&
1280                 !swapping
1281             ) {
1282                 if (!tradingActive) {
1283                     require(
1284                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1285                         "Trading is not active."
1286                     );
1287                 }
1288 
1289                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1290                 if (transferDelayEnabled) {
1291                     if (
1292                         to != owner() &&
1293                         to != address(uniswapV2Router) &&
1294                         to != address(uniswapV2Pair)
1295                     ) {
1296                         require(
1297                             _holderLastTransferTimestamp[tx.origin] <
1298                                 block.number,
1299                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1300                         );
1301                         _holderLastTransferTimestamp[tx.origin] = block.number;
1302                     }
1303                 }
1304 
1305                 //when buy
1306                 if (
1307                     automatedMarketMakerPairs[from] &&
1308                     !_isExcludedMaxTransactionAmount[to]
1309                 ) {
1310                     require(
1311                         amount <= maxTransactionAmount,
1312                         "Buy transfer amount exceeds the maxTransactionAmount."
1313                     );
1314                     require(
1315                         amount + balanceOf(to) <= maxWallet,
1316                         "Max wallet exceeded"
1317                     );
1318                 }
1319                 //when sell
1320                 else if (
1321                     automatedMarketMakerPairs[to] &&
1322                     !_isExcludedMaxTransactionAmount[from]
1323                 ) {
1324                     require(
1325                         amount <= maxTransactionAmount,
1326                         "Sell transfer amount exceeds the maxTransactionAmount."
1327                     );
1328                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1329                     require(
1330                         amount + balanceOf(to) <= maxWallet,
1331                         "Max wallet exceeded"
1332                     );
1333                 }
1334             }
1335         }
1336 
1337         uint256 contractTokenBalance = balanceOf(address(this));
1338 
1339         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1340 
1341         if (
1342             canSwap &&
1343             swapEnabled &&
1344             !swapping &&
1345             !automatedMarketMakerPairs[from] &&
1346             !_isExcludedFromFees[from] &&
1347             !_isExcludedFromFees[to]
1348         ) {
1349             swapping = true;
1350 
1351             swapBack();
1352 
1353             swapping = false;
1354         }
1355 
1356         if (
1357             !swapping &&
1358             automatedMarketMakerPairs[to] &&
1359             lpBurnEnabled &&
1360             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1361             !_isExcludedFromFees[from]
1362         ) {
1363             autoBurnLiquidityPairTokens();
1364         }
1365 
1366         bool takeFee = !swapping;
1367 
1368         // if any account belongs to _isExcludedFromFee account then remove the fee
1369         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1370             takeFee = false;
1371         }
1372 
1373         uint256 fees = 0;
1374         // only take fees on buys/sells, do not take on wallet transfers
1375         if (takeFee) {
1376             // on sell
1377             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1378                 fees = amount.mul(sellTotalFees).div(100);
1379                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1380                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1381                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1382             }
1383             // on buy
1384             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1385                 fees = amount.mul(buyTotalFees).div(100);
1386                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1387                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1388                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1389             }
1390 
1391             if (fees > 0) {
1392                 super._transfer(from, address(this), fees);
1393             }
1394 
1395             amount -= fees;
1396         }
1397 
1398         super._transfer(from, to, amount);
1399     }
1400 
1401     function swapTokensForEth(uint256 tokenAmount) private {
1402         // generate the uniswap pair path of token -> weth
1403         address[] memory path = new address[](2);
1404         path[0] = address(this);
1405         path[1] = uniswapV2Router.WETH();
1406 
1407         _approve(address(this), address(uniswapV2Router), tokenAmount);
1408 
1409         // make the swap
1410         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1411             tokenAmount,
1412             0, // accept any amount of ETH
1413             path,
1414             address(this),
1415             block.timestamp
1416         );
1417     }
1418 
1419     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1420         // approve token transfer to cover all possible scenarios
1421         _approve(address(this), address(uniswapV2Router), tokenAmount);
1422 
1423         // add the liquidity
1424         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1425             address(this),
1426             tokenAmount,
1427             0, // slippage is unavoidable
1428             0, // slippage is unavoidable
1429             deadAddress,
1430             block.timestamp
1431         );
1432     }
1433 
1434     function swapBack() private {
1435         uint256 contractBalance = balanceOf(address(this));
1436         uint256 totalTokensToSwap = tokensForLiquidity +
1437             tokensForMarketing +
1438             tokensForDev;
1439         bool success;
1440 
1441         if (contractBalance == 0 || totalTokensToSwap == 0) {
1442             return;
1443         }
1444 
1445         if (contractBalance > swapTokensAtAmount * 20) {
1446             contractBalance = swapTokensAtAmount * 20;
1447         }
1448 
1449         // Halve the amount of liquidity tokens
1450         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1451             totalTokensToSwap /
1452             2;
1453         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1454 
1455         uint256 initialETHBalance = address(this).balance;
1456 
1457         swapTokensForEth(amountToSwapForETH);
1458 
1459         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1460 
1461         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1462             totalTokensToSwap
1463         );
1464         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1465 
1466         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1467 
1468         tokensForLiquidity = 0;
1469         tokensForMarketing = 0;
1470         tokensForDev = 0;
1471 
1472         (success, ) = address(devWallet).call{value: ethForDev}("");
1473 
1474         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1475             addLiquidity(liquidityTokens, ethForLiquidity);
1476             emit SwapAndLiquify(
1477                 amountToSwapForETH,
1478                 ethForLiquidity,
1479                 tokensForLiquidity
1480             );
1481         }
1482 
1483         (success, ) = address(marketingWallet).call{
1484             value: address(this).balance
1485         }("");
1486     }
1487 
1488     function setAutoLPBurnSettings(
1489         uint256 _frequencyInSeconds,
1490         uint256 _percent,
1491         bool _Enabled
1492     ) external onlyOwner {
1493         require(
1494             _frequencyInSeconds >= 600,
1495             "cannot set buyback more often than every 10 minutes"
1496         );
1497         require(
1498             _percent <= 1000 && _percent >= 0,
1499             "Must set auto LP burn percent between 0% and 10%"
1500         );
1501         lpBurnFrequency = _frequencyInSeconds;
1502         percentForLPBurn = _percent;
1503         lpBurnEnabled = _Enabled;
1504     }
1505 
1506     function autoBurnLiquidityPairTokens() internal returns (bool) {
1507         lastLpBurnTime = block.timestamp;
1508 
1509         // get balance of liquidity pair
1510         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1511 
1512         // calculate amount to burn
1513         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1514             10000
1515         );
1516 
1517         // pull tokens from pancakePair liquidity and move to dead address permanently
1518         if (amountToBurn > 0) {
1519             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1520         }
1521 
1522         //sync price since this is not in a swap transaction!
1523         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1524         pair.sync();
1525         emit AutoNukeLP();
1526         return true;
1527     }
1528 
1529     function manualBurnLiquidityPairTokens(uint256 percent)
1530         external
1531         onlyOwner
1532         returns (bool)
1533     {
1534         require(
1535             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1536             "Must wait for cooldown to finish"
1537         );
1538         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1539         lastManualLpBurnTime = block.timestamp;
1540 
1541         // get balance of liquidity pair
1542         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1543 
1544         // calculate amount to burn
1545         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1546 
1547         // pull tokens from pancakePair liquidity and move to dead address permanently
1548         if (amountToBurn > 0) {
1549             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1550         }
1551 
1552         //sync price since this is not in a swap transaction!
1553         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1554         pair.sync();
1555         emit ManualNukeLP();
1556         return true;
1557     }
1558 }