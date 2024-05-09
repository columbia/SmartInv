1 /**
2  * SPDX-License-Identifier: MIT
3  */
4 pragma solidity >=0.8.19;
5 
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, with an overflow flag.
9      *
10      * _Available since v3.4._
11      */
12     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13         unchecked {
14             uint256 c = a + b;
15             if (c < a) return (false, 0);
16             return (true, c);
17         }
18     }
19 
20     /**
21      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             if (b > a) return (false, 0);
28             return (true, a - b);
29         }
30     }
31 
32     /**
33      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40             // benefit is lost if 'b' is also tested.
41             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
42             if (a == 0) return (true, 0);
43             uint256 c = a * b;
44             if (c / a != b) return (false, 0);
45             return (true, c);
46         }
47     }
48 
49     /**
50      * @dev Returns the division of two unsigned integers, with a division by zero flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b == 0) return (false, 0);
57             return (true, a / b);
58         }
59     }
60 
61     /**
62      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a % b);
70         }
71     }
72 
73     /**
74      * @dev Returns the addition of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `+` operator.
78      *
79      * Requirements:
80      *
81      * - Addition cannot overflow.
82      */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a + b;
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      *
95      * - Subtraction cannot overflow.
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a - b;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `*` operator.
106      *
107      * Requirements:
108      *
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a * b;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers, reverting on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator.
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a / b;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * reverting when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a % b;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * CAUTION: This function is deprecated because it requires allocating memory for the error
150      * message unnecessarily. For custom revert reasons use {trySub}.
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         unchecked {
164             require(b <= a, errorMessage);
165             return a - b;
166         }
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(
182         uint256 a,
183         uint256 b,
184         string memory errorMessage
185     ) internal pure returns (uint256) {
186         unchecked {
187             require(b > 0, errorMessage);
188             return a / b;
189         }
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * reverting with custom message when dividing by zero.
195      *
196      * CAUTION: This function is deprecated because it requires allocating memory for the error
197      * message unnecessarily. For custom revert reasons use {tryMod}.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a % b;
215         }
216     }
217 }
218 
219 interface IERC20 {
220     /**
221      * @dev Returns the amount of tokens in existence.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     /**
226      * @dev Returns the amount of tokens owned by `account`.
227      */
228     function balanceOf(address account) external view returns (uint256);
229 
230     /**
231      * @dev Moves `amount` tokens from the caller's account to `recipient`.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transfer(address recipient, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Returns the remaining number of tokens that `spender` will be
241      * allowed to spend on behalf of `owner` through {transferFrom}. This is
242      * zero by default.
243      *
244      * This value changes when {approve} or {transferFrom} are called.
245      */
246     function allowance(address owner, address spender) external view returns (uint256);
247 
248     /**
249      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * IMPORTANT: Beware that changing an allowance with this method brings the risk
254      * that someone may use both the old and the new allowance by unfortunate
255      * transaction ordering. One possible solution to mitigate this race
256      * condition is to first reduce the spender's allowance to 0 and set the
257      * desired value afterwards:
258      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259      *
260      * Emits an {Approval} event.
261      */
262     function approve(address spender, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Moves `amount` tokens from `sender` to `recipient` using the
266      * allowance mechanism. `amount` is then deducted from the caller's
267      * allowance.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transferFrom(
274         address sender,
275         address recipient,
276         uint256 amount
277     ) external returns (bool);
278 
279     /**
280      * @dev Emitted when `value` tokens are moved from one account (`from`) to
281      * another (`to`).
282      *
283      * Note that `value` may be zero.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     /**
288      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
289      * a call to {approve}. `value` is the new allowance.
290      */
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293 
294 interface IERC20Metadata is IERC20 {
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() external view returns (string memory);
299 
300     /**
301      * @dev Returns the symbol of the token.
302      */
303     function symbol() external view returns (string memory);
304 
305     /**
306      * @dev Returns the decimals places of the token.
307      */
308     function decimals() external view returns (uint8);
309 }
310 
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 contract ERC20 is Context, IERC20, IERC20Metadata {
322     mapping(address => uint256) private _balances;
323 
324     mapping(address => mapping(address => uint256)) private _allowances;
325 
326     uint256 private _totalSupply;
327 
328     string private _name;
329     string private _symbol;
330 
331     /**
332      * @dev Sets the values for {name} and {symbol}.
333      *
334      * The default value of {decimals} is 18. To select a different value for
335      * {decimals} you should overload it.
336      *
337      * All two of these values are immutable: they can only be set once during
338      * construction.
339      */
340     constructor(string memory name_, string memory symbol_) {
341         _name = name_;
342         _symbol = symbol_;
343     }
344 
345     /**
346      * @dev Returns the name of the token.
347      */
348     function name() public view virtual override returns (string memory) {
349         return _name;
350     }
351 
352     /**
353      * @dev Returns the symbol of the token, usually a shorter version of the
354      * name.
355      */
356     function symbol() public view virtual override returns (string memory) {
357         return _symbol;
358     }
359 
360     /**
361      * @dev Returns the number of decimals used to get its user representation.
362      * For example, if `decimals` equals `2`, a balance of `505` tokens should
363      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
364      *
365      * Tokens usually opt for a value of 18, imitating the relationship between
366      * Ether and Wei. This is the value {ERC20} uses, unless this function is
367      * overridden;
368      *
369      * NOTE: This information is only used for _display_ purposes: it in
370      * no way affects any of the arithmetic of the contract, including
371      * {IERC20-balanceOf} and {IERC20-transfer}.
372      */
373     function decimals() public view virtual override returns (uint8) {
374         return 18;
375     }
376 
377     /**
378      * @dev See {IERC20-totalSupply}.
379      */
380     function totalSupply() public view virtual override returns (uint256) {
381         return _totalSupply;
382     }
383 
384     /**
385      * @dev See {IERC20-balanceOf}.
386      */
387     function balanceOf(address account) public view virtual override returns (uint256) {
388         return _balances[account];
389     }
390 
391     /**
392      * @dev See {IERC20-transfer}.
393      *
394      * Requirements:
395      *
396      * - `recipient` cannot be the zero address.
397      * - the caller must have a balance of at least `amount`.
398      */
399     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
400         _transfer(_msgSender(), recipient, amount);
401         return true;
402     }
403 
404     /**
405      * @dev See {IERC20-allowance}.
406      */
407     function allowance(address owner, address spender) public view virtual override returns (uint256) {
408         return _allowances[owner][spender];
409     }
410 
411     /**
412      * @dev See {IERC20-approve}.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function approve(address spender, uint256 amount) public virtual override returns (bool) {
419         _approve(_msgSender(), spender, amount);
420         return true;
421     }
422 
423     /**
424      * @dev See {IERC20-transferFrom}.
425      *
426      * Emits an {Approval} event indicating the updated allowance. This is not
427      * required by the EIP. See the note at the beginning of {ERC20}.
428      *
429      * Requirements:
430      *
431      * - `sender` and `recipient` cannot be the zero address.
432      * - `sender` must have a balance of at least `amount`.
433      * - the caller must have allowance for ``sender``'s tokens of at least
434      * `amount`.
435      */
436     function transferFrom(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) public virtual override returns (bool) {
441         _transfer(sender, recipient, amount);
442 
443         uint256 currentAllowance = _allowances[sender][_msgSender()];
444         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
445         unchecked {
446             _approve(sender, _msgSender(), currentAllowance - amount);
447         }
448 
449         return true;
450     }
451 
452     /**
453      * @dev Atomically increases the allowance granted to `spender` by the caller.
454      *
455      * This is an alternative to {approve} that can be used as a mitigation for
456      * problems described in {IERC20-approve}.
457      *
458      * Emits an {Approval} event indicating the updated allowance.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      */
464     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
466         return true;
467     }
468 
469     /**
470      * @dev Atomically decreases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      * - `spender` must have allowance for the caller of at least
481      * `subtractedValue`.
482      */
483     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
484         uint256 currentAllowance = _allowances[_msgSender()][spender];
485         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
486         unchecked {
487             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
488         }
489 
490         return true;
491     }
492 
493     /**
494      * @dev Moves `amount` of tokens from `sender` to `recipient`.
495      *
496      * This internal function is equivalent to {transfer}, and can be used to
497      * e.g. implement automatic token fees, slashing mechanisms, etc.
498      *
499      * Emits a {Transfer} event.
500      *
501      * Requirements:
502      *
503      * - `sender` cannot be the zero address.
504      * - `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      */
507     function _transfer(
508         address sender,
509         address recipient,
510         uint256 amount
511     ) internal virtual {
512         require(sender != address(0), "ERC20: transfer from the zero address");
513         require(recipient != address(0), "ERC20: transfer to the zero address");
514 
515         _beforeTokenTransfer(sender, recipient, amount);
516 
517         uint256 senderBalance = _balances[sender];
518         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
519         unchecked {
520             _balances[sender] = senderBalance - amount;
521         }
522         _balances[recipient] += amount;
523 
524         emit Transfer(sender, recipient, amount);
525 
526         _afterTokenTransfer(sender, recipient, amount);
527     }
528 
529     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
530      * the total supply.
531      *
532      * Emits a {Transfer} event with `from` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `account` cannot be the zero address.
537      */
538     function _mint(address account, uint256 amount) internal virtual {
539         require(account != address(0), "ERC20: mint to the zero address");
540 
541         _beforeTokenTransfer(address(0), account, amount);
542 
543         _totalSupply += amount;
544         _balances[account] += amount;
545         emit Transfer(address(0), account, amount);
546 
547         _afterTokenTransfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         uint256 accountBalance = _balances[account];
567         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
568         unchecked {
569             _balances[account] = accountBalance - amount;
570         }
571         _totalSupply -= amount;
572 
573         emit Transfer(account, address(0), amount);
574 
575         _afterTokenTransfer(account, address(0), amount);
576     }
577 
578     /**
579      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
580      *
581      * This internal function is equivalent to `approve`, and can be used to
582      * e.g. set automatic allowances for certain subsystems, etc.
583      *
584      * Emits an {Approval} event.
585      *
586      * Requirements:
587      *
588      * - `owner` cannot be the zero address.
589      * - `spender` cannot be the zero address.
590      */
591     function _approve(
592         address owner,
593         address spender,
594         uint256 amount
595     ) internal virtual {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(
618         address from,
619         address to,
620         uint256 amount
621     ) internal virtual {}
622 
623     /**
624      * @dev Hook that is called after any transfer of tokens. This includes
625      * minting and burning.
626      *
627      * Calling conditions:
628      *
629      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
630      * has been transferred to `to`.
631      * - when `from` is zero, `amount` tokens have been minted for `to`.
632      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
633      * - `from` and `to` are never both zero.
634      *
635      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
636      */
637     function _afterTokenTransfer(
638         address from,
639         address to,
640         uint256 amount
641     ) internal virtual {}
642 }
643 
644 abstract contract Ownable is Context {
645     address private _owner;
646 
647     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
648 
649     /**
650      * @dev Initializes the contract setting the deployer as the initial owner.
651      */
652     constructor() {
653         _transferOwnership(_msgSender());
654     }
655 
656     /**
657      * @dev Returns the address of the current owner.
658      */
659     function owner() public view virtual returns (address) {
660         return _owner;
661     }
662 
663     /**
664      * @dev Throws if called by any account other than the owner.
665      */
666     modifier onlyOwner() {
667         require(owner() == _msgSender(), "Ownable: caller is not the owner");
668         _;
669     }
670 
671     /**
672      * @dev Leaves the contract without owner. It will not be possible to call
673      * `onlyOwner` functions anymore. Can only be called by the current owner.
674      *
675      * NOTE: Renouncing ownership will leave the contract without an owner,
676      * thereby removing any functionality that is only available to the owner.
677      */
678     function renounceOwnership() public virtual onlyOwner {
679         _transferOwnership(address(0));
680     }
681 
682     /**
683      * @dev Transfers ownership of the contract to a new account (`newOwner`).
684      * Can only be called by the current owner.
685      */
686     function transferOwnership(address newOwner) public virtual onlyOwner {
687         require(newOwner != address(0), "Ownable: new owner is the zero address");
688         _transferOwnership(newOwner);
689     }
690 
691     /**
692      * @dev Transfers ownership of the contract to a new account (`newOwner`).
693      * Internal function without access restriction.
694      */
695     function _transferOwnership(address newOwner) internal virtual {
696         address oldOwner = _owner;
697         _owner = newOwner;
698         emit OwnershipTransferred(oldOwner, newOwner);
699     }
700 }
701 
702 interface IUniswapV2Factory {
703     event PairCreated(
704         address indexed token0,
705         address indexed token1,
706         address pair,
707         uint256
708     );
709 
710     function feeTo() external view returns (address);
711 
712     function feeToSetter() external view returns (address);
713 
714     function getPair(address tokenA, address tokenB)
715         external
716         view
717         returns (address pair);
718 
719     function allPairs(uint256) external view returns (address pair);
720 
721     function allPairsLength() external view returns (uint256);
722 
723     function createPair(address tokenA, address tokenB)
724         external
725         returns (address pair);
726 
727     function setFeeTo(address) external;
728 
729     function setFeeToSetter(address) external;
730 }
731 
732 interface IUniswapV2Router02 {
733     function factory() external pure returns (address);
734 
735     function WETH() external pure returns (address);
736 
737     function addLiquidity(
738         address tokenA,
739         address tokenB,
740         uint256 amountADesired,
741         uint256 amountBDesired,
742         uint256 amountAMin,
743         uint256 amountBMin,
744         address to,
745         uint256 deadline
746     )
747         external
748         returns (
749             uint256 amountA,
750             uint256 amountB,
751             uint256 liquidity
752         );
753 
754     function addLiquidityETH(
755         address token,
756         uint256 amountTokenDesired,
757         uint256 amountTokenMin,
758         uint256 amountETHMin,
759         address to,
760         uint256 deadline
761     )
762         external
763         payable
764         returns (
765             uint256 amountToken,
766             uint256 amountETH,
767             uint256 liquidity
768         );
769 
770     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
771         uint256 amountIn,
772         uint256 amountOutMin,
773         address[] calldata path,
774         address to,
775         uint256 deadline
776     ) external;
777 
778     function swapExactETHForTokensSupportingFeeOnTransferTokens(
779         uint256 amountOutMin,
780         address[] calldata path,
781         address to,
782         uint256 deadline
783     ) external payable;
784 
785     function swapExactTokensForETHSupportingFeeOnTransferTokens(
786         uint256 amountIn,
787         uint256 amountOutMin,
788         address[] calldata path,
789         address to,
790         uint256 deadline
791     ) external;
792 }
793 
794 contract Pepereum is ERC20, Ownable {
795     using SafeMath for uint256;
796 
797     IUniswapV2Router02 public immutable uniswapV2Router;
798     address public immutable uniswapV2Pair;
799     address public constant deadAddress = address(0xdead);
800 
801     // Swapback
802     bool private inSwapback;
803     bool public swapbackEnabled = false;
804     uint256 public minBalanceForSwapback;
805     uint256 public maxBalanceForSwapback;
806 
807     //Anti-whale
808     bool public walletLimits = true;
809     bool public sameBlockDelay = true;
810     uint256 public mxWallet;
811     uint256 public mxTx;
812     mapping(address => uint256) private addressLastTransfer;
813 
814     // Fee receivers
815     address public lpWallet;
816     address public marketingWallet;
817     address public devWallet;
818 
819     bool public tradingEnabled = false;
820 
821     uint256 public totalFeesBuy;
822     uint256 public buyMarketingFee;
823     uint256 public buyLiquidityFee;
824     uint256 public buyDevFee;
825 
826     uint256 public totalFeesSell;
827     uint256 public sellMarketingFee;
828     uint256 public sellLiquidityFee;
829     uint256 public sellDevFee;
830 
831     uint256 public tokensForMarketing;
832     uint256 public tokensForLiquidity;
833     uint256 public tokensForDev;
834 
835     /******************/
836 
837     // exlcude from fees and max transaction amount
838     mapping(address => bool) private _isFeeExempt;
839     mapping(address => bool) public _isTxLimitExempt;
840 
841     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
842     // could be subject to a maximum transfer amount
843     mapping(address => bool) public automatedMarketMakerPairs;
844 
845     event UpdateUniswapV2Router(
846         address indexed newAddress,
847         address indexed oldAddress
848     );
849 
850     event ExcludeFromFees(address indexed account, bool isExcluded);
851 
852     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
853 
854     event marketingWalletUpdated(
855         address indexed newWallet,
856         address indexed oldWallet
857     );
858 
859     event devWalletUpdated(
860         address indexed newWallet,
861         address indexed oldWallet
862     );
863 
864     event SwapAndLiquify(
865         uint256 tokensSwapped,
866         uint256 ethReceived,
867         uint256 tokensIntoLiquidity
868     );
869 
870     constructor() ERC20("Pepereum", "PEP") {
871         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
872             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
873         );
874 
875         excludeFromMaxTransaction(address(_uniswapV2Router), true);
876         uniswapV2Router = _uniswapV2Router;
877 
878         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
879             .createPair(address(this), _uniswapV2Router.WETH());
880         excludeFromMaxTransaction(address(uniswapV2Pair), true);
881         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
882 
883         uint256 _buyMarketingFee = 20;
884         uint256 _buyLiquidityFee = 0;
885         uint256 _buyDevFee = 5;
886 
887         uint256 _sellMarketingFee = 35;
888         uint256 _sellLiquidityFee = 0;
889         uint256 _sellDevFee = 10;
890 
891         uint256 totalSupply = 1000000000 * 1e18;
892 
893         mxTx = (totalSupply * 2) / 100;
894         mxWallet = (totalSupply * 2) / 100;
895 
896         minBalanceForSwapback = (totalSupply * 5) / 10000;
897         maxBalanceForSwapback = (totalSupply * 100) / 1000;
898 
899         buyMarketingFee = _buyMarketingFee;
900         buyLiquidityFee = _buyLiquidityFee;
901         buyDevFee = _buyDevFee;
902         totalFeesBuy = buyMarketingFee + buyLiquidityFee + buyDevFee;
903 
904         sellMarketingFee = _sellMarketingFee;
905         sellLiquidityFee = _sellLiquidityFee;
906         sellDevFee = _sellDevFee;
907         totalFeesSell = sellMarketingFee + sellLiquidityFee + sellDevFee;
908 
909         marketingWallet = 0x7fE7C0FfBf89717c4BF0634192a7d9E4317CE44D; 
910         devWallet = msg.sender;
911         lpWallet = msg.sender;
912 
913         // exclude from paying fees or having max transaction amount
914         excludeFromFees(owner(), true);
915         excludeFromFees(address(this), true);
916         excludeFromFees(address(0xdead), true);
917         excludeFromFees(marketingWallet, true);
918 
919         excludeFromMaxTransaction(owner(), true);
920         excludeFromMaxTransaction(address(this), true);
921         excludeFromMaxTransaction(address(0xdead), true);
922         excludeFromMaxTransaction(marketingWallet, true);
923 
924         /*
925             _mint is an internal function in ERC20.sol that is only called here,
926             and CANNOT be called ever again
927         */
928         _mint(msg.sender, totalSupply);
929     }
930 
931     receive() external payable {}
932 
933     /// @notice Launches the token and enables trading. Irriversable.
934     function enableTrading() external onlyOwner {
935         tradingEnabled = true;
936         swapbackEnabled = true;
937     }
938 
939     /// @notice Launches the token and enables trading. Irriversable.
940     function launchPepereum() external onlyOwner {
941         tradingEnabled = true;
942         swapbackEnabled = true;
943     }
944 
945     /// @notice Removes the max wallet and max transaction limits
946     function removeLimits() external onlyOwner returns (bool) {
947         walletLimits = false;
948         return true;
949     }
950 
951     /// @notice Disables the Same wallet block transfer delay
952     function disableTransferDelay() external onlyOwner returns (bool) {
953         sameBlockDelay = false;
954         return true;
955     }
956 
957     /// @notice Changes the minimum balance of tokens the contract must have before inSwapback tokens for ETH. Base 100000, so 0.5% = 500.
958     function updateSwapTokensAtAmount(uint256 newAmount)
959         external
960         onlyOwner
961         returns (bool)
962     {
963         require(
964             newAmount >= totalSupply()/ 100000,
965             "Swap amount cannot be lower than 0.001% total supply."
966         );
967         require(
968             newAmount <= 500 * totalSupply()/ 100000,
969             "Swap amount cannot be higher than 0.5% total supply."
970         );
971         require(
972             newAmount <= maxBalanceForSwapback,
973             "Swap amount cannot be higher than maxBalanceForSwapback"
974         );
975         minBalanceForSwapback = newAmount;
976         return true;
977     }
978 
979     /// @notice Changes the maximum amount of tokens the contract can swap for ETH. Base 10000, so 0.5% = 50.
980     function updateMaxTokensForSwapback(uint256 newAmount)
981         external
982         onlyOwner
983         returns (bool)
984     {
985         require(
986             newAmount >= minBalanceForSwapback,
987             "Swap amount cannot be lower than minBalanceForSwapback"
988         );
989         maxBalanceForSwapback = newAmount;
990         return true;
991     }
992 
993     /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction
994     /// @param newNum Base 1000, so 1% = 10
995     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
996         require(
997             newNum >= 2,
998             "Cannot set mxTx lower than 0.2%"
999         );
1000         mxTx = newNum * (10**18);
1001     }
1002 
1003     /// @notice Changes the maximum amount of tokens a wallet can hold
1004     /// @param newNum Base 1000, so 1% = 10
1005     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1006         require(
1007             newNum >= 5,
1008             "Cannot set mxWallet lower than 0.5%"
1009         );
1010         mxWallet = newNum * totalSupply()/1000;
1011     }
1012 
1013 
1014     /// @notice Sets if a wallet is excluded from the max wallet and tx limits
1015     /// @param updAds The wallet to update
1016     /// @param isEx If the wallet is excluded or not
1017     function excludeFromMaxTransaction(address updAds, bool isEx)
1018         public
1019         onlyOwner
1020     {
1021         _isTxLimitExempt[updAds] = isEx;
1022     }
1023 
1024     /// @notice Sets if the contract can sell tokens
1025     /// @param enabled set to false to disable selling
1026     function updateSwapEnabled(bool enabled) external onlyOwner {
1027         swapbackEnabled = enabled;
1028     }
1029     
1030     /// @notice Sets the fees for buys
1031     /// @param _marketingFee The fee for the marketing wallet
1032     /// @param _liquidityFee The fee for the liquidity pool
1033     /// @param _devFee The fee for the dev wallet
1034     function updateBuyFees(
1035         uint256 _marketingFee,
1036         uint256 _liquidityFee,
1037         uint256 _devFee
1038     ) external onlyOwner {
1039         buyMarketingFee = _marketingFee;
1040         buyLiquidityFee = _liquidityFee;
1041         buyDevFee = _devFee;
1042         totalFeesBuy = buyMarketingFee + buyLiquidityFee + buyDevFee;
1043         require(totalFeesBuy <= 5, "Must keep fees at 5% or less");
1044     }
1045 
1046     /// @notice Sets the fees for sells
1047     /// @param _marketingFee The fee for the marketing wallet
1048     /// @param _liquidityFee The fee for the liquidity pool
1049     /// @param _devFee The fee for the dev wallet
1050     function updateSellFees(
1051         uint256 _marketingFee,
1052         uint256 _liquidityFee,
1053         uint256 _devFee
1054     ) external onlyOwner {
1055         sellMarketingFee = _marketingFee;
1056         sellLiquidityFee = _liquidityFee;
1057         sellDevFee = _devFee;
1058         totalFeesSell = sellMarketingFee + sellLiquidityFee + sellDevFee;
1059         require(totalFeesSell <= 5, "Must keep fees at 5% or less");
1060     }
1061 
1062     /// @notice Sets if a wallet is excluded from fees
1063     /// @param account The wallet to update
1064     /// @param excluded If the wallet is excluded or not
1065     function excludeFromFees(address account, bool excluded) public onlyOwner {
1066         _isFeeExempt[account] = excluded;
1067         emit ExcludeFromFees(account, excluded);
1068     }
1069 
1070     /// @notice Sets an address as a new liquidity pair. You probably dont want to do this.
1071     /// @param pair The new pair
1072     function setAutomatedMarketMakerPair(address pair, bool value)
1073         public
1074         onlyOwner
1075     {
1076         require(
1077             pair != uniswapV2Pair,
1078             "The pair cannot be removed from automatedMarketMakerPairs"
1079         );
1080 
1081         _setAutomatedMarketMakerPair(pair, value);
1082     }
1083 
1084     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1085         automatedMarketMakerPairs[pair] = value;
1086 
1087         emit SetAutomatedMarketMakerPair(pair, value);
1088     }
1089 
1090     function setMarketingWallet(address newMarketingWallet)
1091         external
1092         onlyOwner
1093     {
1094         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1095         marketingWallet = newMarketingWallet;
1096     }
1097 
1098     function setLpWallet(address newLpWallet)
1099         external
1100         onlyOwner
1101     {
1102         lpWallet = newLpWallet;
1103     }
1104 
1105     function setDevWallet(address newWallet) external onlyOwner {
1106         emit devWalletUpdated(newWallet, devWallet);
1107         devWallet = newWallet;
1108     }
1109 
1110     function isFeeExempt(address account) public view returns (bool) {
1111         return _isFeeExempt[account];
1112     }
1113 
1114     function _transfer(
1115         address from,
1116         address to,
1117         uint256 amount
1118     ) internal override {
1119         require(from != address(0), "ERC20: transfer from the zero address");
1120         require(to != address(0), "ERC20: transfer to the zero address");
1121 
1122         if (amount == 0) {
1123             super._transfer(from, to, 0);
1124             return;
1125         }
1126 
1127         if (walletLimits) {
1128             if (
1129                 from != owner() &&
1130                 to != owner() &&
1131                 to != address(0) &&
1132                 to != address(0xdead) &&
1133                 !inSwapback
1134             ) {
1135                 if (!tradingEnabled) {
1136                     require(
1137                         _isFeeExempt[from] || _isFeeExempt[to],
1138                         "Trading is not active."
1139                     );
1140                 }
1141 
1142                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1143                 if (sameBlockDelay) {
1144                     if (
1145                         to != owner() &&
1146                         to != address(uniswapV2Router) &&
1147                         to != address(uniswapV2Pair)
1148                     ) {
1149                         require(
1150                             addressLastTransfer[tx.origin] <
1151                                 block.number,
1152                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1153                         );
1154                         addressLastTransfer[tx.origin] = block.number;
1155                     }
1156                 }
1157 
1158                 //when buy
1159                 if (
1160                     automatedMarketMakerPairs[from] &&
1161                     !_isTxLimitExempt[to]
1162                 ) {
1163                     require(
1164                         amount <= mxTx,
1165                         "Buy transfer amount exceeds the mxTx."
1166                     );
1167                     require(
1168                         amount + balanceOf(to) <= mxWallet,
1169                         "Max wallet exceeded"
1170                     );
1171                 }
1172                 //when sell
1173                 else if (
1174                     automatedMarketMakerPairs[to] &&
1175                     !_isTxLimitExempt[from]
1176                 ) {
1177                     require(
1178                         amount <= mxTx,
1179                         "Sell transfer amount exceeds the mxTx."
1180                     );
1181                 } else if (!_isTxLimitExempt[to]) {
1182                     require(
1183                         amount + balanceOf(to) <= mxWallet,
1184                         "Max wallet exceeded"
1185                     );
1186                 }
1187             }
1188         }
1189 
1190         uint256 contractTokenBalance = balanceOf(address(this));
1191 
1192         bool canSwap = contractTokenBalance >= minBalanceForSwapback;
1193 
1194         if (
1195             canSwap &&
1196             swapbackEnabled &&
1197             !inSwapback &&
1198             !automatedMarketMakerPairs[from] &&
1199             !_isFeeExempt[from] &&
1200             !_isFeeExempt[to]
1201         ) {
1202             inSwapback = true;
1203 
1204             swapBack();
1205 
1206             inSwapback = false;
1207         }
1208 
1209         bool takeFee = !inSwapback;
1210 
1211         // if any account belongs to _isExcludedFromFee account then remove the fee
1212         if (_isFeeExempt[from] || _isFeeExempt[to]) {
1213             takeFee = false;
1214         }
1215 
1216         uint256 fees = 0;
1217         // only take fees on buys/sells, do not take on wallet transfers
1218         if (takeFee) {
1219             // on sell
1220             if (automatedMarketMakerPairs[to] && totalFeesSell > 0) {
1221                 fees = amount.mul(totalFeesSell).div(100);
1222                 tokensForLiquidity += (fees * sellLiquidityFee) / totalFeesSell;
1223                 tokensForDev += (fees * sellDevFee) / totalFeesSell;
1224                 tokensForMarketing += (fees * sellMarketingFee) / totalFeesSell;
1225             }
1226             // on buy
1227             else if (automatedMarketMakerPairs[from] && totalFeesBuy > 0) {
1228                 fees = amount.mul(totalFeesBuy).div(100);
1229                 tokensForLiquidity += (fees * buyLiquidityFee) / totalFeesBuy;
1230                 tokensForDev += (fees * buyDevFee) / totalFeesBuy;
1231                 tokensForMarketing += (fees * buyMarketingFee) / totalFeesBuy;
1232             }
1233 
1234             if (fees > 0) {
1235                 super._transfer(from, address(this), fees);
1236             }
1237 
1238             amount -= fees;
1239         }
1240 
1241         super._transfer(from, to, amount);
1242     }
1243 
1244     function swapTokensForEth(uint256 tokenAmount) private {
1245         // generate the uniswap pair path of token -> weth
1246         address[] memory path = new address[](2);
1247         path[0] = address(this);
1248         path[1] = uniswapV2Router.WETH();
1249 
1250         _approve(address(this), address(uniswapV2Router), tokenAmount);
1251 
1252         // make the swap
1253         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1254             tokenAmount,
1255             0, // accept any amount of ETH
1256             path,
1257             address(this),
1258             block.timestamp
1259         );
1260     }
1261 
1262     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1263         // approve token transfer to cover all possible scenarios
1264         _approve(address(this), address(uniswapV2Router), tokenAmount);
1265 
1266         // add the liquidity
1267         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1268             address(this),
1269             tokenAmount,
1270             0, // slippage is unavoidable
1271             0, // slippage is unavoidable
1272             lpWallet,
1273             block.timestamp
1274         );
1275     }
1276 
1277     function swapBack() private {
1278         uint256 contractBalance = balanceOf(address(this));
1279         uint256 totalTokensToSwap = tokensForLiquidity +
1280             tokensForMarketing +
1281             tokensForDev;
1282         bool success;
1283 
1284         if (contractBalance == 0 || totalTokensToSwap == 0) {
1285             return;
1286         }
1287 
1288         if (contractBalance > maxBalanceForSwapback) {
1289             contractBalance = maxBalanceForSwapback;
1290         }
1291 
1292         // Halve the amount of liquidity tokens
1293         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1294             totalTokensToSwap /
1295             2;
1296         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1297 
1298         uint256 initialETHBalance = address(this).balance;
1299 
1300         swapTokensForEth(amountToSwapForETH);
1301 
1302         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1303 
1304         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1305             totalTokensToSwap
1306         );
1307         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1308 
1309         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1310 
1311         tokensForLiquidity = 0;
1312         tokensForMarketing = 0;
1313         tokensForDev = 0;
1314 
1315         (success, ) = address(devWallet).call{value: ethForDev}("");
1316 
1317         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1318             addLiquidity(liquidityTokens, ethForLiquidity);
1319             emit SwapAndLiquify(
1320                 amountToSwapForETH,
1321                 ethForLiquidity,
1322                 tokensForLiquidity
1323             );
1324         }
1325 
1326         (success, ) = address(marketingWallet).call{
1327             value: address(this).balance
1328         }("");
1329     }
1330 
1331 }