1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-26
7 */
8 
9 pragma solidity ^0.6.12;
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23 
24         return c;
25     }
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32         return c;
33     }
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40         return c;
41     }
42     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
43         return mod(a, b, "SafeMath: modulo by zero");
44     }
45     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b != 0, errorMessage);
47         return a % b;
48     }
49 }
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 }
55 contract Ownable is Context {
56     address private _owner;
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58     constructor () public {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63     function owner() public view returns (address) {
64         return _owner;
65     }
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 interface IUniswapV2Pair {
82     event Approval(address indexed owner, address indexed spender, uint value);
83     event Transfer(address indexed from, address indexed to, uint value);
84 
85     function name() external pure returns (string memory);
86     function symbol() external pure returns (string memory);
87     function decimals() external pure returns (uint8);
88     function totalSupply() external view returns (uint);
89     function balanceOf(address owner) external view returns (uint);
90     function allowance(address owner, address spender) external view returns (uint);
91 
92     function approve(address spender, uint value) external returns (bool);
93     function transfer(address to, uint value) external returns (bool);
94     function transferFrom(address from, address to, uint value) external returns (bool);
95 
96     function DOMAIN_SEPARATOR() external view returns (bytes32);
97     function PERMIT_TYPEHASH() external pure returns (bytes32);
98     function nonces(address owner) external view returns (uint);
99 
100     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
101 
102     event Mint(address indexed sender, uint amount0, uint amount1);
103     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
104     event Swap(
105         address indexed sender,
106         uint amount0In,
107         uint amount1In,
108         uint amount0Out,
109         uint amount1Out,
110         address indexed to
111     );
112     event Sync(uint112 reserve0, uint112 reserve1);
113 
114     function MINIMUM_LIQUIDITY() external pure returns (uint);
115     function factory() external view returns (address);
116     function token0() external view returns (address);
117     function token1() external view returns (address);
118     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
119     function price0CumulativeLast() external view returns (uint);
120     function price1CumulativeLast() external view returns (uint);
121     function kLast() external view returns (uint);
122 
123     function mint(address to) external returns (uint liquidity);
124     function burn(address to) external returns (uint amount0, uint amount1);
125     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
126     function skim(address to) external;
127     function sync() external;
128 
129     function initialize(address, address) external;
130 }
131 
132 interface IUniswapV2Factory {
133     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
134 
135     function feeTo() external view returns (address);
136     function feeToSetter() external view returns (address);
137 
138     function getPair(address tokenA, address tokenB) external view returns (address pair);
139     function allPairs(uint) external view returns (address pair);
140     function allPairsLength() external view returns (uint);
141 
142     function createPair(address tokenA, address tokenB) external returns (address pair);
143 
144     function setFeeTo(address) external;
145     function setFeeToSetter(address) external;
146 }
147 
148 interface IUniswapV2Router01 {
149     function factory() external pure returns (address);
150     function WETH() external pure returns (address);
151 
152     function addLiquidity(
153         address tokenA,
154         address tokenB,
155         uint amountADesired,
156         uint amountBDesired,
157         uint amountAMin,
158         uint amountBMin,
159         address to,
160         uint deadline
161     ) external returns (uint amountA, uint amountB, uint liquidity);
162     function addLiquidityETH(
163         address token,
164         uint amountTokenDesired,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline
169     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
170     function removeLiquidity(
171         address tokenA,
172         address tokenB,
173         uint liquidity,
174         uint amountAMin,
175         uint amountBMin,
176         address to,
177         uint deadline
178     ) external returns (uint amountA, uint amountB);
179     function removeLiquidityETH(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountToken, uint amountETH);
187     function removeLiquidityWithPermit(
188         address tokenA,
189         address tokenB,
190         uint liquidity,
191         uint amountAMin,
192         uint amountBMin,
193         address to,
194         uint deadline,
195         bool approveMax, uint8 v, bytes32 r, bytes32 s
196     ) external returns (uint amountA, uint amountB);
197     function removeLiquidityETHWithPermit(
198         address token,
199         uint liquidity,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline,
204         bool approveMax, uint8 v, bytes32 r, bytes32 s
205     ) external returns (uint amountToken, uint amountETH);
206     function swapExactTokensForTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external returns (uint[] memory amounts);
213     function swapTokensForExactTokens(
214         uint amountOut,
215         uint amountInMax,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external returns (uint[] memory amounts);
220     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
221         external
222         payable
223         returns (uint[] memory amounts);
224     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
225         external
226         returns (uint[] memory amounts);
227     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
228         external
229         returns (uint[] memory amounts);
230     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
231         external
232         payable
233         returns (uint[] memory amounts);
234 
235     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
236     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
237     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
238     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
239     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
240 }
241 
242 interface IUniswapV2Router02 is IUniswapV2Router01 {
243     function removeLiquidityETHSupportingFeeOnTransferTokens(
244         address token,
245         uint liquidity,
246         uint amountTokenMin,
247         uint amountETHMin,
248         address to,
249         uint deadline
250     ) external returns (uint amountETH);
251     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
252         address token,
253         uint liquidity,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline,
258         bool approveMax, uint8 v, bytes32 r, bytes32 s
259     ) external returns (uint amountETH);
260 
261     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
262         uint amountIn,
263         uint amountOutMin,
264         address[] calldata path,
265         address to,
266         uint deadline
267     ) external;
268     function swapExactETHForTokensSupportingFeeOnTransferTokens(
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external payable;
274     function swapExactTokensForETHSupportingFeeOnTransferTokens(
275         uint amountIn,
276         uint amountOutMin,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external;
281 }
282 
283 interface IERC20 {
284     /**
285      * @dev Returns the amount of tokens in existence.
286      */
287     function totalSupply() external view returns (uint256);
288 
289     /**
290      * @dev Returns the amount of tokens owned by `account`.
291      */
292     function balanceOf(address account) external view returns (uint256);
293 
294     /**
295      * @dev Moves `amount` tokens from the caller's account to `recipient`.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transfer(address recipient, uint256 amount) external returns (bool);
302 
303     /**
304      * @dev Returns the remaining number of tokens that `spender` will be
305      * allowed to spend on behalf of `owner` through {transferFrom}. This is
306      * zero by default.
307      *
308      * This value changes when {approve} or {transferFrom} are called.
309      */
310     function allowance(address owner, address spender) external view returns (uint256);
311 
312     /**
313      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * IMPORTANT: Beware that changing an allowance with this method brings the risk
318      * that someone may use both the old and the new allowance by unfortunate
319      * transaction ordering. One possible solution to mitigate this race
320      * condition is to first reduce the spender's allowance to 0 and set the
321      * desired value afterwards:
322      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323      *
324      * Emits an {Approval} event.
325      */
326     function approve(address spender, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Moves `amount` tokens from `sender` to `recipient` using the
330      * allowance mechanism. `amount` is then deducted from the caller's
331      * allowance.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transferFrom(
338         address sender,
339         address recipient,
340         uint256 amount
341     ) external returns (bool);
342 
343     /**
344      * @dev Emitted when `value` tokens are moved from one account (`from`) to
345      * another (`to`).
346      *
347      * Note that `value` may be zero.
348      */
349     event Transfer(address indexed from, address indexed to, uint256 value);
350 
351     /**
352      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
353      * a call to {approve}. `value` is the new allowance.
354      */
355     event Approval(address indexed owner, address indexed spender, uint256 value);
356 }
357 
358 interface IERC20Metadata is IERC20 {
359     /**
360      * @dev Returns the name of the token.
361      */
362     function name() external view returns (string memory);
363 
364     /**
365      * @dev Returns the symbol of the token.
366      */
367     function symbol() external view returns (string memory);
368 
369     /**
370      * @dev Returns the decimals places of the token.
371      */
372     function decimals() external view returns (uint8);
373 }
374 
375 contract ERC20 is Context, IERC20, IERC20Metadata {
376     using SafeMath for uint256;
377 
378     mapping(address => uint256) private _balances;
379 
380     mapping(address => mapping(address => uint256)) private _allowances;
381 
382     uint256 private _totalSupply;
383 
384     string private _name;
385     string private _symbol;
386 
387     /**
388      * @dev Sets the values for {name} and {symbol}.
389      *
390      * The default value of {decimals} is 18. To select a different value for
391      * {decimals} you should overload it.
392      *
393      * All two of these values are immutable: they can only be set once during
394      * construction.
395      */
396     constructor(string memory name_, string memory symbol_) public {
397         _name = name_;
398         _symbol = symbol_;
399     }
400 
401     /**
402      * @dev Returns the name of the token.
403      */
404     function name() public view virtual override returns (string memory) {
405         return _name;
406     }
407 
408     /**
409      * @dev Returns the symbol of the token, usually a shorter version of the
410      * name.
411      */
412     function symbol() public view virtual override returns (string memory) {
413         return _symbol;
414     }
415 
416     /**
417      * @dev Returns the number of decimals used to get its user representation.
418      * For example, if `decimals` equals `2`, a balance of `505` tokens should
419      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
420      *
421      * Tokens usually opt for a value of 18, imitating the relationship between
422      * Ether and Wei. This is the value {ERC20} uses, unless this function is
423      * overridden;
424      *
425      * NOTE: This information is only used for _display_ purposes: it in
426      * no way affects any of the arithmetic of the contract, including
427      * {IERC20-balanceOf} and {IERC20-transfer}.
428      */
429     function decimals() public view virtual override returns (uint8) {
430         return 18;
431     }
432 
433     /**
434      * @dev See {IERC20-totalSupply}.
435      */
436     function totalSupply() public view virtual override returns (uint256) {
437         return _totalSupply;
438     }
439 
440     /**
441      * @dev See {IERC20-balanceOf}.
442      */
443     function balanceOf(address account) public view virtual override returns (uint256) {
444         return _balances[account];
445     }
446 
447     /**
448      * @dev See {IERC20-transfer}.
449      *
450      * Requirements:
451      *
452      * - `recipient` cannot be the zero address.
453      * - the caller must have a balance of at least `amount`.
454      */
455     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
456         _transfer(_msgSender(), recipient, amount);
457         return true;
458     }
459 
460     /**
461      * @dev See {IERC20-allowance}.
462      */
463     function allowance(address owner, address spender) public view virtual override returns (uint256) {
464         return _allowances[owner][spender];
465     }
466 
467     /**
468      * @dev See {IERC20-approve}.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      */
474     function approve(address spender, uint256 amount) public virtual override returns (bool) {
475         _approve(_msgSender(), spender, amount);
476         return true;
477     }
478 
479     /**
480      * @dev See {IERC20-transferFrom}.
481      *
482      * Emits an {Approval} event indicating the updated allowance. This is not
483      * required by the EIP. See the note at the beginning of {ERC20}.
484      *
485      * Requirements:
486      *
487      * - `sender` and `recipient` cannot be the zero address.
488      * - `sender` must have a balance of at least `amount`.
489      * - the caller must have allowance for ``sender``'s tokens of at least
490      * `amount`.
491      */
492     function transferFrom(
493         address sender,
494         address recipient,
495         uint256 amount
496     ) public virtual override returns (bool) {
497         _transfer(sender, recipient, amount);
498         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
499         return true;
500     }
501 
502     /**
503      * @dev Atomically increases the allowance granted to `spender` by the caller.
504      *
505      * This is an alternative to {approve} that can be used as a mitigation for
506      * problems described in {IERC20-approve}.
507      *
508      * Emits an {Approval} event indicating the updated allowance.
509      *
510      * Requirements:
511      *
512      * - `spender` cannot be the zero address.
513      */
514     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
516         return true;
517     }
518 
519     /**
520      * @dev Atomically decreases the allowance granted to `spender` by the caller.
521      *
522      * This is an alternative to {approve} that can be used as a mitigation for
523      * problems described in {IERC20-approve}.
524      *
525      * Emits an {Approval} event indicating the updated allowance.
526      *
527      * Requirements:
528      *
529      * - `spender` cannot be the zero address.
530      * - `spender` must have allowance for the caller of at least
531      * `subtractedValue`.
532      */
533     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
534         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
535         return true;
536     }
537 
538     /**
539      * @dev Moves tokens `amount` from `sender` to `recipient`.
540      *
541      * This is internal function is equivalent to {transfer}, and can be used to
542      * e.g. implement automatic token fees, slashing mechanisms, etc.
543      *
544      * Emits a {Transfer} event.
545      *
546      * Requirements:
547      *
548      * - `sender` cannot be the zero address.
549      * - `recipient` cannot be the zero address.
550      * - `sender` must have a balance of at least `amount`.
551      */
552     function _transfer(
553         address sender,
554         address recipient,
555         uint256 amount
556     ) internal virtual {
557         require(sender != address(0), "ERC20: transfer from the zero address");
558         require(recipient != address(0), "ERC20: transfer to the zero address");
559 
560         _beforeTokenTransfer(sender, recipient, amount);
561 
562         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
563         _balances[recipient] = _balances[recipient].add(amount);
564         emit Transfer(sender, recipient, amount);
565     }
566 
567     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
568      * the total supply.
569      *
570      * Emits a {Transfer} event with `from` set to the zero address.
571      *
572      * Requirements:
573      *
574      * - `account` cannot be the zero address.
575      */
576     function _mint(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: mint to the zero address");
578 
579         _beforeTokenTransfer(address(0), account, amount);
580 
581         _totalSupply = _totalSupply.add(amount);
582         _balances[account] = _balances[account].add(amount);
583         emit Transfer(address(0), account, amount);
584     }
585 
586     /**
587      * @dev Destroys `amount` tokens from `account`, reducing the
588      * total supply.
589      *
590      * Emits a {Transfer} event with `to` set to the zero address.
591      *
592      * Requirements:
593      *
594      * - `account` cannot be the zero address.
595      * - `account` must have at least `amount` tokens.
596      */
597     function _burn(address account, uint256 amount) internal virtual {
598         require(account != address(0), "ERC20: burn from the zero address");
599 
600         _beforeTokenTransfer(account, address(0), amount);
601 
602         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
603         _totalSupply = _totalSupply.sub(amount);
604         emit Transfer(account, address(0), amount);
605     }
606 
607     /**
608      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
609      *
610      * This internal function is equivalent to `approve`, and can be used to
611      * e.g. set automatic allowances for certain subsystems, etc.
612      *
613      * Emits an {Approval} event.
614      *
615      * Requirements:
616      *
617      * - `owner` cannot be the zero address.
618      * - `spender` cannot be the zero address.
619      */
620     function _approve(
621         address owner,
622         address spender,
623         uint256 amount
624     ) internal virtual {
625         require(owner != address(0), "ERC20: approve from the zero address");
626         require(spender != address(0), "ERC20: approve to the zero address");
627 
628         _allowances[owner][spender] = amount;
629         emit Approval(owner, spender, amount);
630     }
631 
632     /**
633      * @dev Hook that is called before any transfer of tokens. This includes
634      * minting and burning.
635      *
636      * Calling conditions:
637      *
638      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
639      * will be to transferred to `to`.
640      * - when `from` is zero, `amount` tokens will be minted for `to`.
641      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
642      * - `from` and `to` are never both zero.
643      *
644      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
645      */
646     function _beforeTokenTransfer(
647         address from,
648         address to,
649         uint256 amount
650     ) internal virtual {}
651 }
652 
653 contract TigerQueen is ERC20, Ownable {
654     using SafeMath for uint256;
655 
656     IUniswapV2Router02 public uniswapV2Router;
657     address public immutable uniswapV2Pair;
658 
659     bool private swapping;
660 
661     uint256 public maxBuyTxAmount = 12 * 10**11 * (10**18);
662     uint256 public swapTokensAtAmount = 5 * 10**8 * (10**18);
663 
664     mapping (address => bool) private _isExcluded;
665 
666     mapping (address => bool) public _isBlacklisted;
667 
668     bool private isTradingEnabled;
669 
670     uint256 private startTime;
671 
672     constructor() public ERC20("TigerQueen", "TQUEEN") {
673     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
674         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
675             .createPair(address(this), _uniswapV2Router.WETH());
676 
677         uniswapV2Router = _uniswapV2Router;
678         uniswapV2Pair = _uniswapV2Pair;
679 
680         _isExcluded[owner()] = true;
681         _isExcluded[address(this)] = true;
682 
683         _isBlacklisted[address(0)] = true;
684 
685         _mint(owner(),  10**14 * (10**18));
686     }
687 
688     receive() external payable {
689 
690   	}
691 
692     function _transfer(
693         address from,
694         address to,
695         uint256 amount
696     ) internal override {
697         require(!_isBlacklisted[from] && !_isBlacklisted[to], "To or From address is blacklisted.");
698 
699         if (!isTradingEnabled) {
700             require(_isExcluded[to] || _isExcluded[from], "Trading is not yet enabled. Be patient!");
701         } else if (block.timestamp - startTime < 600 && from == uniswapV2Pair) {
702             require(amount <= maxBuyTxAmount, "Over the max buy amount.");
703         }
704 
705         if(amount == 0) {
706             super._transfer(from, to, 0);
707             return;
708         }
709 
710 		uint256 contractTokenBalance = balanceOf(address(this));
711         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
712 
713         if(
714             canSwap &&
715             !swapping &&
716             from != uniswapV2Pair &&
717             from != owner() &&
718             to != owner()
719         ) {
720 
721             swapping = true;
722 
723             uint256 swapTokens = contractTokenBalance.mul(25).div(1000);
724             swapAndLiquify(swapTokens);
725 
726             uint256 sellTokens = balanceOf(address(this));
727             swapAndSendDividends(sellTokens);
728 
729             swapping = false;
730         }
731 
732         bool takeFee = !swapping;
733 
734         if(_isExcluded[from] || _isExcluded[to]) {
735             takeFee = false;
736         }
737 
738         if(takeFee && (to == uniswapV2Pair || from == uniswapV2Pair)) {
739           uint256 fees = amount.mul(10).div(100);
740         	amount = amount.sub(fees);
741           super._transfer(from, address(this), fees);
742         }
743 
744         super._transfer(from, to, amount);
745 
746     }
747 
748     function swapAndLiquify(uint256 tokens) private {
749         uint256 half = tokens.div(2);
750         uint256 otherHalf = tokens.sub(half);
751         uint256 initialBalance = address(this).balance;
752         swapTokensForEth(half);
753         uint256 newBalance = address(this).balance.sub(initialBalance);
754         addLiquidity(otherHalf, newBalance);
755     }
756 
757     function swapTokensForEth(uint256 tokenAmount) private {
758         address[] memory path = new address[](2);
759         path[0] = address(this);
760         path[1] = uniswapV2Router.WETH();
761         _approve(address(this), address(uniswapV2Router), tokenAmount);
762         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
763             tokenAmount,
764             0,
765             path,
766             address(this),
767             block.timestamp
768         );
769 
770     }
771 
772     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
773         _approve(address(this), address(uniswapV2Router), tokenAmount);
774 
775         uniswapV2Router.addLiquidityETH{value: ethAmount}(
776             address(this),
777             tokenAmount,
778             0,
779             0,
780             owner(),
781             block.timestamp
782         );
783 
784     }
785 
786     function swapAndSendDividends(uint256 tokens) private {
787         swapTokensForEth(tokens);
788         payable(0x22f350646C505c7FA33F9bDaC841950179B47Ca3).transfer(address(this).balance);
789     }
790 
791     function airdrop(address[] memory _user, uint256[] memory _amount) external onlyOwner {
792         uint256 len = _user.length;
793         require(len == _amount.length);
794         for (uint256 i = 0; i < len; i++) {
795             super._transfer(_msgSender(), _user[i], _amount[i]);
796         }
797     }
798 
799     function setBlacklist(address account, bool value) external onlyOwner {
800         _isBlacklisted[account] = value;
801     }
802 
803     function enableTrading() external onlyOwner {
804         require(!isTradingEnabled);
805         isTradingEnabled = true;
806         startTime = block.timestamp;
807     }
808 
809     function setSwapAtAmount(uint256 amount) external onlyOwner {
810         swapTokensAtAmount = amount;
811     }
812 
813     function setMaxTxAmount(uint256 amount) external onlyOwner {
814         maxBuyTxAmount = amount;
815     }
816 
817 }