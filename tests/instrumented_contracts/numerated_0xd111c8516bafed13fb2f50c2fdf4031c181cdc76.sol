1 /********************
2 
3 Apecoin 2.0 | Proof of Ape
4 
5 Proof of Ape is building a dedicated blockchain that is made for the apes, by the apes. We aim to become the safe haven where all the apes of defi unite as one tribe and become living proof that apes are stronger together.
6 
7 We are Proof of Ape!
8 
9 #ApesTogetherStrong
10 
11 Tokenomics
12 Supply: 1 Million
13 Max Buy: 1%
14 Max Wallet: 2%
15 Tax: 3/4 
16 
17 Telegram: https://t.me/proofofape
18 Twitter: https://twitter.com/ProofofApeETH
19 Medium: https://medium.com/@zaffre_73091/apecoin-2-0-4d3abad58339
20 Website: https://poa.finance/
21 
22 **************/
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     /**
41      * @dev Initializes the contract setting the deployer as the initial owner.
42      */
43     constructor() {
44         _transferOwnership(_msgSender());
45     }
46 
47     /**
48      * @dev Returns the address of the current owner.
49      */
50     function owner() public view virtual returns (address) {
51         return _owner;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(owner() == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     /**
63      * @dev Leaves the contract without owner. It will not be possible to call
64      * `onlyOwner` functions anymore. Can only be called by the current owner.
65      *
66      * NOTE: Renouncing ownership will leave the contract without an owner,
67      * thereby removing any functionality that is only available to the owner.
68      */
69     function renounceOwnership() public virtual onlyOwner {
70         _transferOwnership(address(0));
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Can only be called by the current owner.
76      */
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         _transferOwnership(newOwner);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Internal function without access restriction.
85      */
86     function _transferOwnership(address newOwner) internal virtual {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
94 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
95 
96 /* pragma solidity ^0.8.0; */
97 
98 /**
99  * @dev Interface of the ERC20 standard as defined in the EIP.
100  */
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
177 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
178 
179 /* pragma solidity ^0.8.0; */
180 
181 /* import "../IERC20.sol"; */
182 
183 /**
184  * @dev Interface for the optional metadata functions from the ERC20 standard.
185  *
186  * _Available since v4.1._
187  */
188 interface IERC20Metadata is IERC20 {
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the symbol of the token.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the decimals places of the token.
201      */
202     function decimals() external view returns (uint8);
203 }
204 
205 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
206 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
207 
208 /* pragma solidity ^0.8.0; */
209 
210 /* import "./IERC20.sol"; */
211 /* import "./extensions/IERC20Metadata.sol"; */
212 /* import "../../utils/Context.sol"; */
213 
214 /**
215  * @dev Implementation of the {IERC20} interface.
216  *
217  * This implementation is agnostic to the way tokens are created. This means
218  * that a supply mechanism has to be added in a derived contract using {_mint}.
219  * For a generic mechanism see {ERC20PresetMinterPauser}.
220  *
221  * TIP: For a detailed writeup see our guide
222  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
223  * to implement supply mechanisms].
224  *
225  * We have followed general OpenZeppelin Contracts guidelines: functions revert
226  * instead returning `false` on failure. This behavior is nonetheless
227  * conventional and does not conflict with the expectations of ERC20
228  * applications.
229  *
230  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
231  * This allows applications to reconstruct the allowance for all accounts just
232  * by listening to said events. Other implementations of the EIP may not emit
233  * these events, as it isn't required by the specification.
234  *
235  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
236  * functions have been added to mitigate the well-known issues around setting
237  * allowances. See {IERC20-approve}.
238  */
239 contract ERC20 is Context, IERC20, IERC20Metadata {
240     mapping(address => uint256) private _balances;
241 
242     mapping(address => mapping(address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     string private _name;
247     string private _symbol;
248 
249     /**
250      * @dev Sets the values for {name} and {symbol}.
251      *
252      * The default value of {decimals} is 18. To select a different value for
253      * {decimals} you should overload it.
254      *
255      * All two of these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor(string memory name_, string memory symbol_) {
259         _name = name_;
260         _symbol = symbol_;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view virtual override returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view virtual override returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the value {ERC20} uses, unless this function is
285      * overridden;
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view virtual override returns (uint8) {
292         return 18;
293     }
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view virtual override returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account) public view virtual override returns (uint256) {
306         return _balances[account];
307     }
308 
309     /**
310      * @dev See {IERC20-transfer}.
311      *
312      * Requirements:
313      *
314      * - `recipient` cannot be the zero address.
315      * - the caller must have a balance of at least `amount`.
316      */
317     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
318         _transfer(_msgSender(), recipient, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-allowance}.
324      */
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     /**
330      * @dev See {IERC20-approve}.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function approve(address spender, uint256 amount) public virtual override returns (bool) {
337         _approve(_msgSender(), spender, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-transferFrom}.
343      *
344      * Emits an {Approval} event indicating the updated allowance. This is not
345      * required by the EIP. See the note at the beginning of {ERC20}.
346      *
347      * Requirements:
348      *
349      * - `sender` and `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      * - the caller must have allowance for ``sender``'s tokens of at least
352      * `amount`.
353      */
354     function transferFrom(
355         address sender,
356         address recipient,
357         uint256 amount
358     ) public virtual override returns (bool) {
359         _transfer(sender, recipient, amount);
360 
361         uint256 currentAllowance = _allowances[sender][_msgSender()];
362         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
363         unchecked {
364             _approve(sender, _msgSender(), currentAllowance - amount);
365         }
366 
367         return true;
368     }
369 
370     /**
371      * @dev Moves `amount` of tokens from `sender` to `recipient`.
372      *
373      * This internal function is equivalent to {transfer}, and can be used to
374      * e.g. implement automatic token fees, slashing mechanisms, etc.
375      *
376      * Emits a {Transfer} event.
377      *
378      * Requirements:
379      *
380      * - `sender` cannot be the zero address.
381      * - `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      */
384     function _transfer(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) internal virtual {
389         require(sender != address(0), "ERC20: transfer from the zero address");
390         require(recipient != address(0), "ERC20: transfer to the zero address");
391 
392         _beforeTokenTransfer(sender, recipient, amount);
393 
394         uint256 senderBalance = _balances[sender];
395         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
396         unchecked {
397             _balances[sender] = senderBalance - amount;
398         }
399         _balances[recipient] += amount;
400 
401         emit Transfer(sender, recipient, amount);
402 
403         _afterTokenTransfer(sender, recipient, amount);
404     }
405 
406     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
407      * the total supply.
408      *
409      * Emits a {Transfer} event with `from` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      */
415     function _mint(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: mint to the zero address");
417 
418         _beforeTokenTransfer(address(0), account, amount);
419 
420         _totalSupply += amount;
421         _balances[account] += amount;
422         emit Transfer(address(0), account, amount);
423 
424         _afterTokenTransfer(address(0), account, amount);
425     }
426 
427 
428     /**
429      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
430      *
431      * This internal function is equivalent to `approve`, and can be used to
432      * e.g. set automatic allowances for certain subsystems, etc.
433      *
434      * Emits an {Approval} event.
435      *
436      * Requirements:
437      *
438      * - `owner` cannot be the zero address.
439      * - `spender` cannot be the zero address.
440      */
441     function _approve(
442         address owner,
443         address spender,
444         uint256 amount
445     ) internal virtual {
446         require(owner != address(0), "ERC20: approve from the zero address");
447         require(spender != address(0), "ERC20: approve to the zero address");
448 
449         _allowances[owner][spender] = amount;
450         emit Approval(owner, spender, amount);
451     }
452 
453     /**
454      * @dev Hook that is called before any transfer of tokens. This includes
455      * minting and burning.
456      *
457      * Calling conditions:
458      *
459      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
460      * will be transferred to `to`.
461      * - when `from` is zero, `amount` tokens will be minted for `to`.
462      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
463      * - `from` and `to` are never both zero.
464      *
465      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
466      */
467     function _beforeTokenTransfer(
468         address from,
469         address to,
470         uint256 amount
471     ) internal virtual {}
472 
473     /**
474      * @dev Hook that is called after any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * has been transferred to `to`.
481      * - when `from` is zero, `amount` tokens have been minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _afterTokenTransfer(
488         address from,
489         address to,
490         uint256 amount
491     ) internal virtual {}
492 }
493 
494 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
495 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
496 
497 /* pragma solidity ^0.8.0; */
498 
499 // CAUTION
500 // This version of SafeMath should only be used with Solidity 0.8 or later,
501 // because it relies on the compiler's built in overflow checks.
502 
503 /**
504  * @dev Wrappers over Solidity's arithmetic operations.
505  *
506  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
507  * now has built in overflow checking.
508  */
509 library SafeMath {
510     /**
511      * @dev Returns the addition of two unsigned integers, with an overflow flag.
512      *
513      * _Available since v3.4._
514      */
515     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
516         unchecked {
517             uint256 c = a + b;
518             if (c < a) return (false, 0);
519             return (true, c);
520         }
521     }
522 
523     /**
524      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
525      *
526      * _Available since v3.4._
527      */
528     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
529         unchecked {
530             if (b > a) return (false, 0);
531             return (true, a - b);
532         }
533     }
534 
535     /**
536      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
537      *
538      * _Available since v3.4._
539      */
540     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
541         unchecked {
542             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
543             // benefit is lost if 'b' is also tested.
544             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
545             if (a == 0) return (true, 0);
546             uint256 c = a * b;
547             if (c / a != b) return (false, 0);
548             return (true, c);
549         }
550     }
551 
552     /**
553      * @dev Returns the division of two unsigned integers, with a division by zero flag.
554      *
555      * _Available since v3.4._
556      */
557     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
558         unchecked {
559             if (b == 0) return (false, 0);
560             return (true, a / b);
561         }
562     }
563 
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
566      *
567      * _Available since v3.4._
568      */
569     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
570         unchecked {
571             if (b == 0) return (false, 0);
572             return (true, a % b);
573         }
574     }
575 
576     /**
577      * @dev Returns the addition of two unsigned integers, reverting on
578      * overflow.
579      *
580      * Counterpart to Solidity's `+` operator.
581      *
582      * Requirements:
583      *
584      * - Addition cannot overflow.
585      */
586     function add(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a + b;
588     }
589 
590     /**
591      * @dev Returns the subtraction of two unsigned integers, reverting on
592      * overflow (when the result is negative).
593      *
594      * Counterpart to Solidity's `-` operator.
595      *
596      * Requirements:
597      *
598      * - Subtraction cannot overflow.
599      */
600     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a - b;
602     }
603 
604     /**
605      * @dev Returns the multiplication of two unsigned integers, reverting on
606      * overflow.
607      *
608      * Counterpart to Solidity's `*` operator.
609      *
610      * Requirements:
611      *
612      * - Multiplication cannot overflow.
613      */
614     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
615         return a * b;
616     }
617 
618     /**
619      * @dev Returns the integer division of two unsigned integers, reverting on
620      * division by zero. The result is rounded towards zero.
621      *
622      * Counterpart to Solidity's `/` operator.
623      *
624      * Requirements:
625      *
626      * - The divisor cannot be zero.
627      */
628     function div(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a / b;
630     }
631 
632     /**
633      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
634      * reverting when dividing by zero.
635      *
636      * Counterpart to Solidity's `%` operator. This function uses a `revert`
637      * opcode (which leaves remaining gas untouched) while Solidity uses an
638      * invalid opcode to revert (consuming all remaining gas).
639      *
640      * Requirements:
641      *
642      * - The divisor cannot be zero.
643      */
644     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a % b;
646     }
647 
648     /**
649      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
650      * overflow (when the result is negative).
651      *
652      * CAUTION: This function is deprecated because it requires allocating memory for the error
653      * message unnecessarily. For custom revert reasons use {trySub}.
654      *
655      * Counterpart to Solidity's `-` operator.
656      *
657      * Requirements:
658      *
659      * - Subtraction cannot overflow.
660      */
661     function sub(
662         uint256 a,
663         uint256 b,
664         string memory errorMessage
665     ) internal pure returns (uint256) {
666         unchecked {
667             require(b <= a, errorMessage);
668             return a - b;
669         }
670     }
671 
672     /**
673      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
674      * division by zero. The result is rounded towards zero.
675      *
676      * Counterpart to Solidity's `/` operator. Note: this function uses a
677      * `revert` opcode (which leaves remaining gas untouched) while Solidity
678      * uses an invalid opcode to revert (consuming all remaining gas).
679      *
680      * Requirements:
681      *
682      * - The divisor cannot be zero.
683      */
684     function div(
685         uint256 a,
686         uint256 b,
687         string memory errorMessage
688     ) internal pure returns (uint256) {
689         unchecked {
690             require(b > 0, errorMessage);
691             return a / b;
692         }
693     }
694 
695     /**
696      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
697      * reverting with custom message when dividing by zero.
698      *
699      * CAUTION: This function is deprecated because it requires allocating memory for the error
700      * message unnecessarily. For custom revert reasons use {tryMod}.
701      *
702      * Counterpart to Solidity's `%` operator. This function uses a `revert`
703      * opcode (which leaves remaining gas untouched) while Solidity uses an
704      * invalid opcode to revert (consuming all remaining gas).
705      *
706      * Requirements:
707      *
708      * - The divisor cannot be zero.
709      */
710     function mod(
711         uint256 a,
712         uint256 b,
713         string memory errorMessage
714     ) internal pure returns (uint256) {
715         unchecked {
716             require(b > 0, errorMessage);
717             return a % b;
718         }
719     }
720 }
721 
722 interface IUniswapV2Factory {
723     event PairCreated(
724         address indexed token0,
725         address indexed token1,
726         address pair,
727         uint256
728     );
729 
730     function createPair(address tokenA, address tokenB)
731         external
732         returns (address pair);
733 }
734 
735 interface IUniswapV2Router02 {
736     function factory() external pure returns (address);
737 
738     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
739         uint256 amountIn,
740         uint256 amountOutMin,
741         address[] calldata path,
742         address to,
743         uint256 deadline
744     ) external;
745 }
746 
747 contract Apecoin is ERC20, Ownable {
748     using SafeMath for uint256;
749 
750     IUniswapV2Router02 public immutable uniswapV2Router;
751     address public immutable uniswapV2Pair;
752     address public constant deadAddress = address(0xdead);
753     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
754 
755     bool private swapping;
756 
757     address public devWallet;
758 
759     uint256 public maxTransactionAmount;
760     uint256 public swapTokensAtAmount;
761     uint256 public maxWallet;
762 
763     bool public limitsInEffect = true;
764     bool public tradingActive = false;
765     bool public swapEnabled = true;
766 
767     uint256 public buyTotalFees;
768     uint256 public buyDevFee;
769     uint256 public buyLiquidityFee;
770 
771     uint256 public sellTotalFees;
772     uint256 public sellDevFee;
773     uint256 public sellLiquidityFee;
774 
775     /******************/
776 
777     // exlcude from fees and max transaction amount
778     mapping(address => bool) private _isExcludedFromFees;
779     mapping(address => bool) public _isExcludedMaxTransactionAmount;
780 
781 
782     event ExcludeFromFees(address indexed account, bool isExcluded);
783 
784     event devWalletUpdated(
785         address indexed newWallet,
786         address indexed oldWallet
787     );
788 
789     constructor() ERC20("Proof of Ape", "Apecoin 2.0") {
790         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
791 
792         excludeFromMaxTransaction(address(_uniswapV2Router), true);
793         uniswapV2Router = _uniswapV2Router;
794 
795         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
796             .createPair(address(this), USDC);
797         excludeFromMaxTransaction(address(uniswapV2Pair), true);
798 
799 
800         uint256 _buyDevFee = 8;
801         uint256 _buyLiquidityFee = 0;
802 
803         uint256 _sellDevFee = 12;
804         uint256 _sellLiquidityFee = 0;
805 
806         uint256 totalSupply = 1_000_000 * 1e18;
807 
808         maxTransactionAmount =  totalSupply * 1 / 100; // 2% from total supply maxTransactionAmountTxn
809         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
810         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
811 
812         buyDevFee = _buyDevFee;
813         buyLiquidityFee = _buyLiquidityFee;
814         buyTotalFees = buyDevFee + buyLiquidityFee;
815 
816         sellDevFee = _sellDevFee;
817         sellLiquidityFee = _sellLiquidityFee;
818         sellTotalFees = sellDevFee + sellLiquidityFee;
819 
820         devWallet = address(0x2F4A23121496C07743F5664a70B6EB606fa1b16A); // Dev Wallet
821 
822         // exclude from paying fees or having max transaction amount
823         excludeFromFees(owner(), true);
824         excludeFromFees(address(this), true);
825         excludeFromFees(address(0xdead), true);
826 
827         excludeFromMaxTransaction(owner(), true);
828         excludeFromMaxTransaction(address(this), true);
829         excludeFromMaxTransaction(address(0xdead), true);
830 
831         /*
832             _mint is an internal function in ERC20.sol that is only called here,
833             and CANNOT be called ever again
834         */
835         _mint(msg.sender, totalSupply);
836     }
837 
838     receive() external payable {}
839 
840     // once enabled, can never be turned off
841     function enableTrading() external onlyOwner {
842         tradingActive = true;
843         swapEnabled = true;
844     }
845 
846     // remove limits after token is stable
847     function removeLimits() external onlyOwner returns (bool) {
848         limitsInEffect = false;
849         return true;
850     }
851 
852     // change the minimum amount of tokens to sell from fees
853     function updateSwapTokensAtAmount(uint256 newAmount)
854         external
855         onlyOwner
856         returns (bool)
857     {
858         require(
859             newAmount >= (totalSupply() * 1) / 100000,
860             "Swap amount cannot be lower than 0.001% total supply."
861         );
862         require(
863             newAmount <= (totalSupply() * 5) / 1000,
864             "Swap amount cannot be higher than 0.5% total supply."
865         );
866         swapTokensAtAmount = newAmount;
867         return true;
868     }
869 
870     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
871         require(
872             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
873             "Cannot set maxTransactionAmount lower than 0.1%"
874         );
875         maxTransactionAmount = newNum * (10**18);
876     }
877 
878     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
879         require(
880             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
881             "Cannot set maxWallet lower than 0.5%"
882         );
883         maxWallet = newNum * (10**18);
884     }
885 
886     function excludeFromMaxTransaction(address updAds, bool isEx)
887         public
888         onlyOwner
889     {
890         _isExcludedMaxTransactionAmount[updAds] = isEx;
891     }
892 
893     // only use to disable contract sales if absolutely necessary (emergency use only)
894     function updateSwapEnabled(bool enabled) external onlyOwner {
895         swapEnabled = enabled;
896     }
897 
898     function updateBuyFees(
899         uint256 _devFee,
900         uint256 _liquidityFee
901     ) external onlyOwner {
902         buyDevFee = _devFee;
903         buyLiquidityFee = _liquidityFee;
904         buyTotalFees = buyDevFee + buyLiquidityFee;
905         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
906     }
907 
908     function updateSellFees(
909         uint256 _devFee,
910         uint256 _liquidityFee
911     ) external onlyOwner {
912         sellDevFee = _devFee;
913         sellLiquidityFee = _liquidityFee;
914         sellTotalFees = sellDevFee + sellLiquidityFee;
915         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
916     }
917 
918     function excludeFromFees(address account, bool excluded) public onlyOwner {
919         _isExcludedFromFees[account] = excluded;
920         emit ExcludeFromFees(account, excluded);
921     }
922 
923     function updateDevWallet(address newDevWallet)
924         external
925         onlyOwner
926     {
927         emit devWalletUpdated(newDevWallet, devWallet);
928         devWallet = newDevWallet;
929     }
930 
931 
932     function isExcludedFromFees(address account) public view returns (bool) {
933         return _isExcludedFromFees[account];
934     }
935 
936     function _transfer(
937         address from,
938         address to,
939         uint256 amount
940     ) internal override {
941         require(from != address(0), "ERC20: transfer from the zero address");
942         require(to != address(0), "ERC20: transfer to the zero address");
943 
944         if (amount == 0) {
945             super._transfer(from, to, 0);
946             return;
947         }
948 
949         if (limitsInEffect) {
950             if (
951                 from != owner() &&
952                 to != owner() &&
953                 to != address(0) &&
954                 to != address(0xdead) &&
955                 !swapping
956             ) {
957                 if (!tradingActive) {
958                     require(
959                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
960                         "Trading is not active."
961                     );
962                 }
963 
964                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
965                 //when buy
966                 if (
967                     from == uniswapV2Pair &&
968                     !_isExcludedMaxTransactionAmount[to]
969                 ) {
970                     require(
971                         amount <= maxTransactionAmount,
972                         "Buy transfer amount exceeds the maxTransactionAmount."
973                     );
974                     require(
975                         amount + balanceOf(to) <= maxWallet,
976                         "Max wallet exceeded"
977                     );
978                 }
979                 else if (!_isExcludedMaxTransactionAmount[to]) {
980                     require(
981                         amount + balanceOf(to) <= maxWallet,
982                         "Max wallet exceeded"
983                     );
984                 }
985             }
986         }
987 
988         uint256 contractTokenBalance = balanceOf(address(this));
989 
990         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
991 
992         if (
993             canSwap &&
994             swapEnabled &&
995             !swapping &&
996             to == uniswapV2Pair &&
997             !_isExcludedFromFees[from] &&
998             !_isExcludedFromFees[to]
999         ) {
1000             swapping = true;
1001 
1002             swapBack();
1003 
1004             swapping = false;
1005         }
1006 
1007         bool takeFee = !swapping;
1008 
1009         // if any account belongs to _isExcludedFromFee account then remove the fee
1010         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1011             takeFee = false;
1012         }
1013 
1014         uint256 fees = 0;
1015         uint256 tokensForLiquidity = 0;
1016         uint256 tokensForDev = 0;
1017         // only take fees on buys/sells, do not take on wallet transfers
1018         if (takeFee) {
1019             // on sell
1020             if (to == uniswapV2Pair && sellTotalFees > 0) {
1021                 fees = amount.mul(sellTotalFees).div(100);
1022                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1023                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1024             }
1025             // on buy
1026             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1027                 fees = amount.mul(buyTotalFees).div(100);
1028                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1029                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1030             }
1031 
1032             if (fees> 0) {
1033                 super._transfer(from, address(this), fees);
1034             }
1035             if (tokensForLiquidity > 0) {
1036                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1037             }
1038 
1039             amount -= fees;
1040         }
1041 
1042         super._transfer(from, to, amount);
1043     }
1044 
1045     function swapTokensForUSDC(uint256 tokenAmount) private {
1046         // generate the uniswap pair path of token -> weth
1047         address[] memory path = new address[](2);
1048         path[0] = address(this);
1049         path[1] = USDC;
1050 
1051         _approve(address(this), address(uniswapV2Router), tokenAmount);
1052 
1053         // make the swap
1054         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1055             tokenAmount,
1056             0, // accept any amount of USDC
1057             path,
1058             devWallet,
1059             block.timestamp
1060         );
1061     }
1062 
1063     function swapBack() private {
1064         uint256 contractBalance = balanceOf(address(this));
1065         if (contractBalance == 0) {
1066             return;
1067         }
1068 
1069         if (contractBalance > swapTokensAtAmount * 20) {
1070             contractBalance = swapTokensAtAmount * 20;
1071         }
1072 
1073         swapTokensForUSDC(contractBalance);
1074     }
1075 
1076 }