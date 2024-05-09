1 /**
2        __                 _      ___    ____
3       / /___ _______   __(_)____/   |  /  _/
4  __  / / __ `/ ___/ | / / / ___/ /| |  / /
5 / /_/ / /_/ / /   | |/ / (__  ) ___ |_/ /
6 \____/\__,_/_/    |___/_/____/_/  |_/___/
7 
8 JarvisAI - Innovative app that uses AI and Machine Learning to analyze tokens and provide valuable insights.
9 
10 Chat - https://t.me/Jarvis_ERC20
11 Twitter - https://twitter.com/jarvisai_erc20
12 Website - https://jarvisai.pro/
13 
14 Unlock the JarvisAI power.
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity ^0.8.0;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 pragma solidity ^0.8.0;
31 
32 abstract contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38      * @dev Initializes the contract setting the deployer as the initial owner.
39      */
40     constructor() {
41         _transferOwnership(_msgSender());
42     }
43 
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     /**
60      * @dev Leaves the contract without owner. It will not be possible to call
61      * `onlyOwner` functions anymore. Can only be called by the current owner.
62      *
63      * NOTE: Renouncing ownership will leave the contract without an owner,
64      * thereby removing any functionality that is only available to the owner.
65      */
66     function renounceOwnership() public virtual onlyOwner {
67         _transferOwnership(address(0));
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Can only be called by the current owner.
73      */
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         _transferOwnership(newOwner);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Internal function without access restriction.
82      */
83     function _transferOwnership(address newOwner) internal virtual {
84         address oldOwner = _owner;
85         _owner = newOwner;
86         emit OwnershipTransferred(oldOwner, newOwner);
87     }
88 }
89 
90 pragma solidity ^0.8.0;
91 
92 interface IERC20 {
93     /**
94      * @dev Returns the amount of tokens in existence.
95      */
96     function totalSupply() external view returns (uint256);
97 
98     /**
99      * @dev Returns the amount of tokens owned by `account`.
100      */
101     function balanceOf(address account) external view returns (uint256);
102 
103     /**
104      * @dev Moves `amount` tokens from the caller's account to `recipient`.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transfer(address recipient, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Returns the remaining number of tokens that `spender` will be
114      * allowed to spend on behalf of `owner` through {transferFrom}. This is
115      * zero by default.
116      *
117      * This value changes when {approve} or {transferFrom} are called.
118      */
119     function allowance(address owner, address spender) external view returns (uint256);
120 
121     /**
122      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * IMPORTANT: Beware that changing an allowance with this method brings the risk
127      * that someone may use both the old and the new allowance by unfortunate
128      * transaction ordering. One possible solution to mitigate this race
129      * condition is to first reduce the spender's allowance to 0 and set the
130      * desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address spender, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Moves `amount` tokens from `sender` to `recipient` using the
139      * allowance mechanism. `amount` is then deducted from the caller's
140      * allowance.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transferFrom(
147         address sender,
148         address recipient,
149         uint256 amount
150     ) external returns (bool);
151 
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to {approve}. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 pragma solidity ^0.8.0;
168 
169 interface IERC20Metadata is IERC20 {
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() external view returns (string memory);
174 
175     /**
176      * @dev Returns the symbol of the token.
177      */
178     function symbol() external view returns (string memory);
179 
180     /**
181      * @dev Returns the decimals places of the token.
182      */
183     function decimals() external view returns (uint8);
184 }
185 
186 pragma solidity ^0.8.0;
187 
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189     mapping(address => uint256) private _balances;
190 
191     mapping(address => mapping(address => uint256)) private _allowances;
192 
193     uint256 private _totalSupply;
194 
195     string private _name;
196     string private _symbol;
197 
198     /**
199      * @dev Sets the values for {name} and {symbol}.
200      *
201      * The default value of {decimals} is 18. To select a different value for
202      * {decimals} you should overload it.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor(string memory name_, string memory symbol_) {
208         _name = name_;
209         _symbol = symbol_;
210     }
211 
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218 
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view virtual override returns (string memory) {
224         return _symbol;
225     }
226 
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei. This is the value {ERC20} uses, unless this function is
234      * overridden;
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view virtual override returns (uint8) {
241         return 18;
242     }
243 
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view virtual override returns (uint256) {
255         return _balances[account];
256     }
257 
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view virtual override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function approve(address spender, uint256 amount) public virtual override returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * Requirements:
297      *
298      * - `sender` and `recipient` cannot be the zero address.
299      * - `sender` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``sender``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309 
310         uint256 currentAllowance = _allowances[sender][_msgSender()];
311         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
312     unchecked {
313         _approve(sender, _msgSender(), currentAllowance - amount);
314     }
315 
316         return true;
317     }
318 
319     /**
320      * @dev Atomically increases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
332         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
333         return true;
334     }
335 
336     /**
337      * @dev Atomically decreases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      * - `spender` must have allowance for the caller of at least
348      * `subtractedValue`.
349      */
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         uint256 currentAllowance = _allowances[_msgSender()][spender];
352         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
353     unchecked {
354         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
355     }
356 
357         return true;
358     }
359 
360     /**
361      * @dev Moves `amount` of tokens from `sender` to `recipient`.
362      *
363      * This internal function is equivalent to {transfer}, and can be used to
364      * e.g. implement automatic token fees, slashing mechanisms, etc.
365      *
366      * Emits a {Transfer} event.
367      *
368      * Requirements:
369      *
370      * - `sender` cannot be the zero address.
371      * - `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      */
374     function _transfer(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) internal virtual {
379         require(sender != address(0), "ERC20: transfer from the zero address");
380         require(recipient != address(0), "ERC20: transfer to the zero address");
381 
382         _beforeTokenTransfer(sender, recipient, amount);
383 
384         uint256 senderBalance = _balances[sender];
385         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
386     unchecked {
387         _balances[sender] = senderBalance - amount;
388     }
389         _balances[recipient] += amount;
390 
391         emit Transfer(sender, recipient, amount);
392 
393         _afterTokenTransfer(sender, recipient, amount);
394     }
395 
396     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
397      * the total supply.
398      *
399      * Emits a {Transfer} event with `from` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      */
405     function _mint(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: mint to the zero address");
407 
408         _beforeTokenTransfer(address(0), account, amount);
409 
410         _totalSupply += amount;
411         _balances[account] += amount;
412         emit Transfer(address(0), account, amount);
413 
414         _afterTokenTransfer(address(0), account, amount);
415     }
416 
417     /**
418      * @dev Destroys `amount` tokens from `account`, reducing the
419      * total supply.
420      *
421      * Emits a {Transfer} event with `to` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `account` cannot be the zero address.
426      * - `account` must have at least `amount` tokens.
427      */
428     function _burn(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: burn from the zero address");
430 
431         _beforeTokenTransfer(account, address(0), amount);
432 
433         uint256 accountBalance = _balances[account];
434         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
435     unchecked {
436         _balances[account] = accountBalance - amount;
437     }
438         _totalSupply -= amount;
439 
440         emit Transfer(account, address(0), amount);
441 
442         _afterTokenTransfer(account, address(0), amount);
443     }
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
447      *
448      * This internal function is equivalent to `approve`, and can be used to
449      * e.g. set automatic allowances for certain subsystems, etc.
450      *
451      * Emits an {Approval} event.
452      *
453      * Requirements:
454      *
455      * - `owner` cannot be the zero address.
456      * - `spender` cannot be the zero address.
457      */
458     function _approve(
459         address owner,
460         address spender,
461         uint256 amount
462     ) internal virtual {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Hook that is called before any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * will be transferred to `to`.
478      * - when `from` is zero, `amount` tokens will be minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _beforeTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 
490     /**
491      * @dev Hook that is called after any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * has been transferred to `to`.
498      * - when `from` is zero, `amount` tokens have been minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _afterTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 }
510 
511 pragma solidity ^0.8.0;
512 
513 library SafeMath {
514     /**
515      * @dev Returns the addition of two unsigned integers, with an overflow flag.
516      *
517      * _Available since v3.4._
518      */
519     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
520     unchecked {
521         uint256 c = a + b;
522         if (c < a) return (false, 0);
523         return (true, c);
524     }
525     }
526 
527     /**
528      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
529      *
530      * _Available since v3.4._
531      */
532     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
533     unchecked {
534         if (b > a) return (false, 0);
535         return (true, a - b);
536     }
537     }
538 
539     /**
540      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
541      *
542      * _Available since v3.4._
543      */
544     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
545     unchecked {
546         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
547         // benefit is lost if 'b' is also tested.
548         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
549         if (a == 0) return (true, 0);
550         uint256 c = a * b;
551         if (c / a != b) return (false, 0);
552         return (true, c);
553     }
554     }
555 
556     /**
557      * @dev Returns the division of two unsigned integers, with a division by zero flag.
558      *
559      * _Available since v3.4._
560      */
561     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
562     unchecked {
563         if (b == 0) return (false, 0);
564         return (true, a / b);
565     }
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
570      *
571      * _Available since v3.4._
572      */
573     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
574     unchecked {
575         if (b == 0) return (false, 0);
576         return (true, a % b);
577     }
578     }
579 
580     /**
581      * @dev Returns the addition of two unsigned integers, reverting on
582      * overflow.
583      *
584      * Counterpart to Solidity's `+` operator.
585      *
586      * Requirements:
587      *
588      * - Addition cannot overflow.
589      */
590     function add(uint256 a, uint256 b) internal pure returns (uint256) {
591         return a + b;
592     }
593 
594     /**
595      * @dev Returns the subtraction of two unsigned integers, reverting on
596      * overflow (when the result is negative).
597      *
598      * Counterpart to Solidity's `-` operator.
599      *
600      * Requirements:
601      *
602      * - Subtraction cannot overflow.
603      */
604     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
605         return a - b;
606     }
607 
608     /**
609      * @dev Returns the multiplication of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `*` operator.
613      *
614      * Requirements:
615      *
616      * - Multiplication cannot overflow.
617      */
618     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
619         return a * b;
620     }
621 
622     /**
623      * @dev Returns the integer division of two unsigned integers, reverting on
624      * division by zero. The result is rounded towards zero.
625      *
626      * Counterpart to Solidity's `/` operator.
627      *
628      * Requirements:
629      *
630      * - The divisor cannot be zero.
631      */
632     function div(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a / b;
634     }
635 
636     /**
637      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
638      * reverting when dividing by zero.
639      *
640      * Counterpart to Solidity's `%` operator. This function uses a `revert`
641      * opcode (which leaves remaining gas untouched) while Solidity uses an
642      * invalid opcode to revert (consuming all remaining gas).
643      *
644      * Requirements:
645      *
646      * - The divisor cannot be zero.
647      */
648     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a % b;
650     }
651 
652     /**
653      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
654      * overflow (when the result is negative).
655      *
656      * CAUTION: This function is deprecated because it requires allocating memory for the error
657      * message unnecessarily. For custom revert reasons use {trySub}.
658      *
659      * Counterpart to Solidity's `-` operator.
660      *
661      * Requirements:
662      *
663      * - Subtraction cannot overflow.
664      */
665     function sub(
666         uint256 a,
667         uint256 b,
668         string memory errorMessage
669     ) internal pure returns (uint256) {
670     unchecked {
671         require(b <= a, errorMessage);
672         return a - b;
673     }
674     }
675 
676     /**
677      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
678      * division by zero. The result is rounded towards zero.
679      *
680      * Counterpart to Solidity's `/` operator. Note: this function uses a
681      * `revert` opcode (which leaves remaining gas untouched) while Solidity
682      * uses an invalid opcode to revert (consuming all remaining gas).
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function div(
689         uint256 a,
690         uint256 b,
691         string memory errorMessage
692     ) internal pure returns (uint256) {
693     unchecked {
694         require(b > 0, errorMessage);
695         return a / b;
696     }
697     }
698 
699     /**
700      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
701      * reverting with custom message when dividing by zero.
702      *
703      * CAUTION: This function is deprecated because it requires allocating memory for the error
704      * message unnecessarily. For custom revert reasons use {tryMod}.
705      *
706      * Counterpart to Solidity's `%` operator. This function uses a `revert`
707      * opcode (which leaves remaining gas untouched) while Solidity uses an
708      * invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function mod(
715         uint256 a,
716         uint256 b,
717         string memory errorMessage
718     ) internal pure returns (uint256) {
719     unchecked {
720         require(b > 0, errorMessage);
721         return a % b;
722     }
723     }
724 }
725 
726 pragma solidity ^0.8.10;
727 pragma experimental ABIEncoderV2;
728 
729 interface IUniswapV2Factory {
730     event PairCreated(
731         address indexed token0,
732         address indexed token1,
733         address pair,
734         uint256
735     );
736 
737     function createPair(address tokenA, address tokenB)
738     external
739     returns (address pair);
740 }
741 
742 interface IUniswapV2Router02 {
743     function factory() external pure returns (address);
744     function WETH() external pure returns (address);
745 
746     function swapExactTokensForETHSupportingFeeOnTransferTokens(
747         uint amountIn,
748         uint amountOutMin,
749         address[] calldata path,
750         address to,
751         uint deadline
752     ) external;
753 }
754 
755 contract JarvisAI is ERC20, Ownable {
756     using SafeMath for uint256;
757 
758     IUniswapV2Router02 public immutable uniswapV2Router;
759 
760     address public immutable uniswapV2Pair;
761     address public devWallet;
762 
763     mapping(address => bool) private _isExcludedFromFees;
764     mapping(address => bool) private _isExcludedFromMaxWallet;
765 
766     uint256 public swapTokensAtAmount;
767     uint256 public buyDevFee;
768     uint256 public buyLiquidityFee;
769     uint256 public buyTotalFees;
770     uint256 public sellDevFee;
771     uint256 public sellLiquidityFee;
772     uint256 public sellTotalFees;
773     uint256 public maxWallet;
774 
775     bool public swapBackEnabled = true;
776     bool public limitsInEffect = true;
777     bool public tradingActive;
778     bool private swapping;
779 
780     constructor() ERC20("JarvisAI", "JAI") {
781         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
782         uniswapV2Router = _uniswapV2Router;
783         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
784 
785         uint256 totalSupply = 1000000e18;
786         maxWallet = totalSupply * 2 / 100;
787         swapTokensAtAmount = (totalSupply * 3) / 10000;
788         buyDevFee = 0;
789         buyLiquidityFee = 1;
790         buyTotalFees = buyDevFee + buyLiquidityFee;
791         sellDevFee = 0;
792         sellLiquidityFee = 1;
793         sellTotalFees = sellDevFee + sellLiquidityFee;
794         devWallet = owner();
795 
796         excludeFromFees(owner(), true);
797         excludeFromFees(address(this), true);
798         excludeFromFees(address(0xdead), true);
799         excludeFromFees(address(0x0000), true);
800 
801         excludeFromMaxWallet(owner(), true);
802         excludeFromMaxWallet(address(this), true);
803         excludeFromMaxWallet(address(0xdead), true);
804         excludeFromMaxWallet(address(0x0000), true);
805 
806         _mint(msg.sender, totalSupply);
807     }
808 
809     function _transfer(
810         address from,
811         address to,
812         uint256 amount
813     ) internal override {
814         require(from != address(0), "ERC20: transfer from the zero address");
815         require(to != address(0), "ERC20: transfer to the zero address");
816 
817         if (amount == 0) {
818             super._transfer(from, to, 0);
819             return;
820         }
821 
822         bool isBuy = from == uniswapV2Pair;
823         bool isSell = to == uniswapV2Pair;
824 
825         if (!tradingActive && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) require(false, "Trading has not started yet");
826 
827         if (limitsInEffect && !_isExcludedFromMaxWallet[to] && !swapping) {
828             if (isBuy) {
829                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded (buy)");
830             }
831             if (!isBuy && !isSell) {
832                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded (transfer)");
833             }
834         }
835 
836         uint256 contractTokenBalance = balanceOf(address(this));
837         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
838         if (canSwap && swapBackEnabled && !swapping && to == uniswapV2Pair && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
839             swapping = true;
840             swapBack();
841             swapping = false;
842         }
843 
844         bool takeFee = !swapping;
845         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
846             takeFee = false;
847         }
848 
849         uint256 fees = 0;
850         uint256 tokensForLiquidity = 0;
851 
852         if (takeFee) {
853             if (to == uniswapV2Pair && sellTotalFees > 0) {
854                 fees = amount.mul(sellTotalFees).div(100);
855                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
856             }
857             else if (from == uniswapV2Pair && buyTotalFees > 0) {
858                 fees = amount.mul(buyTotalFees).div(100);
859                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees;
860             }
861 
862             if (fees > 0) {
863                 super._transfer(from, address(this), fees);
864             }
865             if (tokensForLiquidity > 0) {
866                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
867             }
868 
869             amount -= fees;
870         }
871 
872         super._transfer(from, to, amount);
873     }
874 
875     function swapTokensForETH(uint256 tokenAmount) private {
876         address[] memory path = new address[](2);
877         path[0] = address(this);
878         path[1] = uniswapV2Router.WETH();
879 
880         _approve(address(this), address(uniswapV2Router), tokenAmount);
881 
882         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
883             tokenAmount,
884             0,
885             path,
886             devWallet,
887             block.timestamp
888         );
889     }
890 
891     function swapBack() private {
892         uint256 contractBalance = balanceOf(address(this));
893         if (contractBalance == 0) {
894             return;
895         }
896         swapTokensForETH(contractBalance);
897     }
898 
899     receive() external payable {}
900 
901     function updateDevWallet(address newWallet) external onlyOwner {
902         devWallet = newWallet;
903     }
904 
905     function updateSwapBackEnabled(bool enabled) external onlyOwner {
906         swapBackEnabled = enabled;
907     }
908 
909     function updateBuyFee(uint256 _devFee, uint256 _liquidityFee) external onlyOwner {
910         buyDevFee = _devFee;
911         buyLiquidityFee = _liquidityFee;
912         buyTotalFees = buyDevFee + buyLiquidityFee;
913         require(buyTotalFees <= 20, "buy tax > 20%");
914     }
915 
916     function updateSellFees(uint256 _devFee, uint256 _liquidityFee) external onlyOwner {
917         sellDevFee = _devFee;
918         sellLiquidityFee = _liquidityFee;
919         sellTotalFees = sellDevFee + sellLiquidityFee;
920         require(sellTotalFees <= 20, "sell tax > 20%");
921     }
922 
923     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
924         require(newAmount >= (totalSupply() * 1) / 100000, "< 0.001% total supply.");
925         swapTokensAtAmount = newAmount;
926         return true;
927     }
928 
929     function updateMaxWallet(uint256 newAmount) external onlyOwner {
930         require(newAmount >= (totalSupply() * 5 / 1000) / 1e18, "Cannot set maxWallet lower than 0.5%");
931         maxWallet = newAmount * 1e18;
932     }
933 
934     function enableTrading() public onlyOwner {
935         tradingActive = true;
936     }
937 
938     function enableLimits(bool _limitsInEffect) public onlyOwner {
939         limitsInEffect = _limitsInEffect;
940     }
941 
942     function rescue(address token) public onlyOwner {
943         ERC20 Token = ERC20(token);
944         uint256 balance = Token.balanceOf(address(this));
945         if (balance > 0) Token.transfer(_msgSender(), balance);
946     }
947 
948     function excludeFromFees(address account, bool excluded) public onlyOwner {
949         _isExcludedFromFees[account] = excluded;
950     }
951 
952     function excludeFromMaxWallet(address account, bool excluded) public onlyOwner {
953         _isExcludedFromMaxWallet[account] = excluded;
954     }
955 
956     function isExcludedFromMaxWallet(address account) public view returns (bool) {
957         return _isExcludedFromMaxWallet[account];
958     }
959 
960     function isExcludedFromFees(address account) public view returns (bool) {
961         return _isExcludedFromFees[account];
962     }
963 }