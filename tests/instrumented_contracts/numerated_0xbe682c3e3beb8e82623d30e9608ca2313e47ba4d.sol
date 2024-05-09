1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 
5 ██╗░░░██╗███████╗░██████╗░░█████╗░███╗░░██╗  ██████╗░░█████╗░██████╗░██╗░██████╗  ████████╗░█████╗░██╗░░██╗███████╗███╗░░██╗
6 ██║░░░██║██╔════╝██╔════╝░██╔══██╗████╗░██║  ██╔══██╗██╔══██╗██╔══██╗╚█║██╔════╝  ╚══██╔══╝██╔══██╗██║░██╔╝██╔════╝████╗░██║
7 ╚██╗░██╔╝█████╗░░██║░░██╗░███████║██╔██╗██║  ██████╔╝██║░░██║██████╦╝░╚╝╚█████╗░  ░░░██║░░░██║░░██║█████═╝░█████╗░░██╔██╗██║
8 ░╚████╔╝░██╔══╝░░██║░░╚██╗██╔══██║██║╚████║  ██╔══██╗██║░░██║██╔══██╗░░░░╚═══██╗  ░░░██║░░░██║░░██║██╔═██╗░██╔══╝░░██║╚████║
9 ░░╚██╔╝░░███████╗╚██████╔╝██║░░██║██║░╚███║  ██║░░██║╚█████╔╝██████╦╝░░░██████╔╝  ░░░██║░░░╚█████╔╝██║░╚██╗███████╗██║░╚███║
10 ░░░╚═╝░░░╚══════╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝  ╚═╝░░╚═╝░╚════╝░╚═════╝░░░░╚═════╝░  ░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝
11 
12 
13 */
14 
15 
16 pragma solidity ^0.8.7;
17 
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38         uint256 c = a * b;
39         require(c / a == b, "SafeMath: multiplication overflow");
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68     constructor ()  {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73     function owner() public view returns (address) {
74         return _owner;
75     }
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 interface IUniswapV2Pair {
92     event Approval(address indexed owner, address indexed spender, uint value);
93     event Transfer(address indexed from, address indexed to, uint value);
94 
95     function name() external pure returns (string memory);
96     function symbol() external pure returns (string memory);
97     function decimals() external pure returns (uint8);
98     function totalSupply() external view returns (uint);
99     function balanceOf(address owner) external view returns (uint);
100     function allowance(address owner, address spender) external view returns (uint);
101 
102     function approve(address spender, uint value) external returns (bool);
103     function transfer(address to, uint value) external returns (bool);
104     function transferFrom(address from, address to, uint value) external returns (bool);
105 
106     function DOMAIN_SEPARATOR() external view returns (bytes32);
107     function PERMIT_TYPEHASH() external pure returns (bytes32);
108     function nonces(address owner) external view returns (uint);
109 
110     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
111 
112     event Mint(address indexed sender, uint amount0, uint amount1);
113     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
114     event Swap(
115         address indexed sender,
116         uint amount0In,
117         uint amount1In,
118         uint amount0Out,
119         uint amount1Out,
120         address indexed to
121     );
122     event Sync(uint112 reserve0, uint112 reserve1);
123 
124     function MINIMUM_LIQUIDITY() external pure returns (uint);
125     function factory() external view returns (address);
126     function token0() external view returns (address);
127     function token1() external view returns (address);
128     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
129     function price0CumulativeLast() external view returns (uint);
130     function price1CumulativeLast() external view returns (uint);
131     function kLast() external view returns (uint);
132 
133     function mint(address to) external returns (uint liquidity);
134     function burn(address to) external returns (uint amount0, uint amount1);
135     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
136     function skim(address to) external;
137     function sync() external;
138 
139     function initialize(address, address) external;
140 }
141 
142 interface IUniswapV2Factory {
143     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
144 
145     function feeTo() external view returns (address);
146     function feeToSetter() external view returns (address);
147 
148     function getPair(address tokenA, address tokenB) external view returns (address pair);
149     function allPairs(uint) external view returns (address pair);
150     function allPairsLength() external view returns (uint);
151 
152     function createPair(address tokenA, address tokenB) external returns (address pair);
153 
154     function setFeeTo(address) external;
155     function setFeeToSetter(address) external;
156 }
157 
158 interface IUniswapV2Router01 {
159     function factory() external pure returns (address);
160     function WETH() external pure returns (address);
161 
162     function addLiquidity(
163         address tokenA,
164         address tokenB,
165         uint amountADesired,
166         uint amountBDesired,
167         uint amountAMin,
168         uint amountBMin,
169         address to,
170         uint deadline
171     ) external returns (uint amountA, uint amountB, uint liquidity);
172     function addLiquidityETH(
173         address token,
174         uint amountTokenDesired,
175         uint amountTokenMin,
176         uint amountETHMin,
177         address to,
178         uint deadline
179     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
180     function removeLiquidity(
181         address tokenA,
182         address tokenB,
183         uint liquidity,
184         uint amountAMin,
185         uint amountBMin,
186         address to,
187         uint deadline
188     ) external returns (uint amountA, uint amountB);
189     function removeLiquidityETH(
190         address token,
191         uint liquidity,
192         uint amountTokenMin,
193         uint amountETHMin,
194         address to,
195         uint deadline
196     ) external returns (uint amountToken, uint amountETH);
197     function removeLiquidityWithPermit(
198         address tokenA,
199         address tokenB,
200         uint liquidity,
201         uint amountAMin,
202         uint amountBMin,
203         address to,
204         uint deadline,
205         bool approveMax, uint8 v, bytes32 r, bytes32 s
206     ) external returns (uint amountA, uint amountB);
207     function removeLiquidityETHWithPermit(
208         address token,
209         uint liquidity,
210         uint amountTokenMin,
211         uint amountETHMin,
212         address to,
213         uint deadline,
214         bool approveMax, uint8 v, bytes32 r, bytes32 s
215     ) external returns (uint amountToken, uint amountETH);
216     function swapExactTokensForTokens(
217         uint amountIn,
218         uint amountOutMin,
219         address[] calldata path,
220         address to,
221         uint deadline
222     ) external returns (uint[] memory amounts);
223     function swapTokensForExactTokens(
224         uint amountOut,
225         uint amountInMax,
226         address[] calldata path,
227         address to,
228         uint deadline
229     ) external returns (uint[] memory amounts);
230     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
231         external
232         payable
233         returns (uint[] memory amounts);
234     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
235         external
236         returns (uint[] memory amounts);
237     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
238         external
239         returns (uint[] memory amounts);
240     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
241         external
242         payable
243         returns (uint[] memory amounts);
244 
245     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
246     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
247     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
248     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
249     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
250 }
251 
252 interface IUniswapV2Router02 is IUniswapV2Router01 {
253     function removeLiquidityETHSupportingFeeOnTransferTokens(
254         address token,
255         uint liquidity,
256         uint amountTokenMin,
257         uint amountETHMin,
258         address to,
259         uint deadline
260     ) external returns (uint amountETH);
261     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
262         address token,
263         uint liquidity,
264         uint amountTokenMin,
265         uint amountETHMin,
266         address to,
267         uint deadline,
268         bool approveMax, uint8 v, bytes32 r, bytes32 s
269     ) external returns (uint amountETH);
270 
271     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external;
278     function swapExactETHForTokensSupportingFeeOnTransferTokens(
279         uint amountOutMin,
280         address[] calldata path,
281         address to,
282         uint deadline
283     ) external payable;
284     function swapExactTokensForETHSupportingFeeOnTransferTokens(
285         uint amountIn,
286         uint amountOutMin,
287         address[] calldata path,
288         address to,
289         uint deadline
290     ) external;
291 }
292 
293 interface IERC20 {
294     /**
295      * @dev Returns the amount of tokens in existence.
296      */
297     function totalSupply() external view returns (uint256);
298 
299     /**
300      * @dev Returns the amount of tokens owned by `account`.
301      */
302     function balanceOf(address account) external view returns (uint256);
303 
304     /**
305      * @dev Moves `amount` tokens from the caller's account to `recipient`.
306      *
307      * Returns a boolean value indicating whether the operation succeeded.
308      *
309      * Emits a {Transfer} event.
310      */
311     function transfer(address recipient, uint256 amount) external returns (bool);
312 
313     /**
314      * @dev Returns the remaining number of tokens that `spender` will be
315      * allowed to spend on behalf of `owner` through {transferFrom}. This is
316      * zero by default.
317      *
318      * This value changes when {approve} or {transferFrom} are called.
319      */
320     function allowance(address owner, address spender) external view returns (uint256);
321 
322     /**
323      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
324      *
325      * Returns a boolean value indicating whether the operation succeeded.
326      *
327      * IMPORTANT: Beware that changing an allowance with this method brings the risk
328      * that someone may use both the old and the new allowance by unfortunate
329      * transaction ordering. One possible solution to mitigate this race
330      * condition is to first reduce the spender's allowance to 0 and set the
331      * desired value afterwards:
332      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333      *
334      * Emits an {Approval} event.
335      */
336     function approve(address spender, uint256 amount) external returns (bool);
337 
338     /**
339      * @dev Moves `amount` tokens from `sender` to `recipient` using the
340      * allowance mechanism. `amount` is then deducted from the caller's
341      * allowance.
342      *
343      * Returns a boolean value indicating whether the operation succeeded.
344      *
345      * Emits a {Transfer} event.
346      */
347     function transferFrom(
348         address sender,
349         address recipient,
350         uint256 amount
351     ) external returns (bool);
352 
353     /**
354      * @dev Emitted when `value` tokens are moved from one account (`from`) to
355      * another (`to`).
356      *
357      * Note that `value` may be zero.
358      */
359     event Transfer(address indexed from, address indexed to, uint256 value);
360 
361     /**
362      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
363      * a call to {approve}. `value` is the new allowance.
364      */
365     event Approval(address indexed owner, address indexed spender, uint256 value);
366 }
367 
368 interface IERC20Metadata is IERC20 {
369     /**
370      * @dev Returns the name of the token.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the symbol of the token.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the decimals places of the token.
381      */
382     function decimals() external view returns (uint8);
383 }
384 
385 contract ERC20 is Context, IERC20, IERC20Metadata {
386 
387     using SafeMath for uint256;
388 
389     mapping(address => uint256) private _balances;
390 
391     mapping(address => mapping(address => uint256)) private _allowances;
392 
393     uint256 private _totalSupply;
394 
395     string private _name;
396     string private _symbol;
397 
398     /**
399      * @dev Sets the values for {name} and {symbol}.
400      *
401      * The default value of {decimals} is 18. To select a different value for
402      * {decimals} you should overload it.
403      *
404      * All two of these values are immutable: they can only be set once during
405      * construction.
406      */
407     constructor(string memory name_, string memory symbol_)  {
408         _name = name_;
409         _symbol = symbol_;
410     }
411 
412     /**
413      * @dev Returns the name of the token.
414      */
415     function name() public view virtual override returns (string memory) {
416         return _name;
417     }
418 
419     /**
420      * @dev Returns the symbol of the token, usually a shorter version of the
421      * name.
422      */
423     function symbol() public view virtual override returns (string memory) {
424         return _symbol;
425     }
426 
427     /**
428      * @dev Returns the number of decimals used to get its user representation.
429      * For example, if `decimals` equals `2`, a balance of `505` tokens should
430      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
431      *
432      * Tokens usually opt for a value of 18, imitating the relationship between
433      * Ether and Wei. This is the value {ERC20} uses, unless this function is
434      * overridden;
435      *
436      * NOTE: This information is only used for _display_ purposes: it in
437      * no way affects any of the arithmetic of the contract, including
438      * {IERC20-balanceOf} and {IERC20-transfer}.
439      */
440     function decimals() public view virtual override returns (uint8) {
441         return 18;
442     }
443 
444     /**
445      * @dev See {IERC20-totalSupply}.
446      */
447     function totalSupply() public view virtual override returns (uint256) {
448         return _totalSupply;
449     }
450 
451     /**
452      * @dev See {IERC20-balanceOf}.
453      */
454     function balanceOf(address account) public view virtual override returns (uint256) {
455         return _balances[account];
456     }
457 
458     /**
459      * @dev See {IERC20-transfer}.
460      *
461      * Requirements:
462      *
463      * - `recipient` cannot be the zero address.
464      * - the caller must have a balance of at least `amount`.
465      */
466     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
467         _transfer(_msgSender(), recipient, amount);
468         return true;
469     }
470 
471     /**
472      * @dev See {IERC20-allowance}.
473      */
474     function allowance(address owner, address spender) public view virtual override returns (uint256) {
475         return _allowances[owner][spender];
476     }
477 
478     /**
479      * @dev See {IERC20-approve}.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      */
485     function approve(address spender, uint256 amount) public virtual override returns (bool) {
486         _approve(_msgSender(), spender, amount);
487         return true;
488     }
489 
490     /**
491      * @dev See {IERC20-transferFrom}.
492      *
493      * Emits an {Approval} event indicating the updated allowance. This is not
494      * required by the EIP. See the note at the beginning of {ERC20}.
495      *
496      * Requirements:
497      *
498      * - `sender` and `recipient` cannot be the zero address.
499      * - `sender` must have a balance of at least `amount`.
500      * - the caller must have allowance for ``sender``'s tokens of at least
501      * `amount`.
502      */
503     function transferFrom(
504         address sender,
505         address recipient,
506         uint256 amount
507     ) public virtual override returns (bool) {
508         _transfer(sender, recipient, amount);
509         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
510         return true;
511     }
512 
513     /**
514      * @dev Atomically increases the allowance granted to `spender` by the caller.
515      *
516      * This is an alternative to {approve} that can be used as a mitigation for
517      * problems described in {IERC20-approve}.
518      *
519      * Emits an {Approval} event indicating the updated allowance.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
527         return true;
528     }
529 
530     /**
531      * @dev Atomically decreases the allowance granted to `spender` by the caller.
532      *
533      * This is an alternative to {approve} that can be used as a mitigation for
534      * problems described in {IERC20-approve}.
535      *
536      * Emits an {Approval} event indicating the updated allowance.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      * - `spender` must have allowance for the caller of at least
542      * `subtractedValue`.
543      */
544     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
545         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
546         return true;
547     }
548 
549     /**
550      * @dev Moves tokens `amount` from `sender` to `recipient`.
551      *
552      * This is internal function is equivalent to {transfer}, and can be used to
553      * e.g. implement automatic token fees, slashing mechanisms, etc.
554      *
555      * Emits a {Transfer} event.
556      *
557      * Requirements:
558      *
559      * - `sender` cannot be the zero address.
560      * - `recipient` cannot be the zero address.
561      * - `sender` must have a balance of at least `amount`.
562      */
563     function _transfer(
564         address sender,
565         address recipient,
566         uint256 amount
567     ) internal virtual {
568         require(sender != address(0), "ERC20: transfer from the zero address");
569         require(recipient != address(0), "ERC20: transfer to the zero address");
570         _beforeTokenTransfer(sender, recipient, amount);
571         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
572         _balances[recipient] = _balances[recipient].add(amount);
573         emit Transfer(sender, recipient, amount);
574     }
575 
576     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
577      * the total supply.
578      *
579      * Emits a {Transfer} event with `from` set to the zero address.
580      *
581      * Requirements:
582      *
583      * - `account` cannot be the zero address.
584      */
585     function _mint(address account, uint256 amount) internal virtual {
586         require(account != address(0), "ERC20: mint to the zero address");
587 
588         _beforeTokenTransfer(address(0), account, amount);
589 
590         _totalSupply = _totalSupply.add(amount);
591         _balances[account] = _balances[account].add(amount);
592         emit Transfer(address(0), account, amount);
593     }
594 
595     /**
596      * @dev Destroys `amount` tokens from `account`, reducing the
597      * total supply.
598      *
599      * Emits a {Transfer} event with `to` set to the zero address.
600      *
601      * Requirements:
602      *
603      * - `account` cannot be the zero address.
604      * - `account` must have at least `amount` tokens.
605      */
606     function _burn(address account, uint256 amount) internal virtual {
607         require(account != address(0), "ERC20: burn from the zero address");
608 
609         _beforeTokenTransfer(account, address(0), amount);
610 
611         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
612         _totalSupply = _totalSupply.sub(amount);
613         emit Transfer(account, address(0), amount);
614     }
615 
616     /**
617      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
618      *
619      * This internal function is equivalent to `approve`, and can be used to
620      * e.g. set automatic allowances for certain subsystems, etc.
621      *
622      * Emits an {Approval} event.
623      *
624      * Requirements:
625      *
626      * - `owner` cannot be the zero address.
627      * - `spender` cannot be the zero address.
628      */
629     function _approve(
630         address owner,
631         address spender,
632         uint256 amount
633     ) internal virtual {
634         require(owner != address(0), "ERC20: approve from the zero address");
635         require(spender != address(0), "ERC20: approve to the zero address");
636 
637         _allowances[owner][spender] = amount;
638         emit Approval(owner, spender, amount);
639     }
640 
641     /**
642      * @dev Hook that is called before any transfer of tokens. This includes
643      * minting and burning.
644      *
645      * Calling conditions:
646      *
647      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
648      * will be to transferred to `to`.
649      * - when `from` is zero, `amount` tokens will be minted for `to`.
650      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
651      * - `from` and `to` are never both zero.
652      *
653      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
654      */
655     function _beforeTokenTransfer(
656         address from,
657         address to,
658         uint256 amount
659     ) internal virtual {}
660 }
661 
662 contract VRT is ERC20, Ownable {
663     using SafeMath for uint256;
664 
665     IUniswapV2Router02 public uniswapV2Router;
666     address public immutable uniswapV2Pair;
667 
668     bool    private swapping;
669 
670     uint256 public maxBuyTxAmount     =  10**10 * 10**18;
671     uint256 public swapTokensAtAmount =  10**10 * 10**18;
672 
673     address public devWallet      = 0x32Cc0E6B14E6Ce74601d33d901439EbD29E69255;
674     address public snackWallet    = 0x65b29476ad1604818bE1CE74d86B0C1aC501D467;
675 
676     uint8 public sell_liquidityFee = 30;
677     uint8 public sell_devFee       = 30;
678     uint8 public sell_protocolFee  = 30;
679     uint8 public sell_burnFee      = 10;
680 
681     uint8 public buy_liquidityFee = 15;
682     uint8 public buy_devFee       = 15;
683     uint8 public buy_protocolFee  = 15;
684     uint8 public buy_burnFee      = 5;
685 
686     mapping (address => bool) private _isExcluded;
687 
688     mapping (address => bool) public _isBlacklisted;
689 
690     bool private isTradingEnabled;
691 
692     uint256 private startTime;
693 
694     constructor()  ERC20("Vegan Rob Token", "VRT") {
695         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
696         // pancakeswap address : 0x10ED43C718714eb63d5aA57B78B54704E256024E
697         //  uniswap address    : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
698 
699         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
700             .createPair(address(this), _uniswapV2Router.WETH());
701         uniswapV2Router = _uniswapV2Router;
702         uniswapV2Pair = _uniswapV2Pair;
703         _isExcluded[owner()] = true;
704         _isExcluded[address(this)] = true;
705         _isExcluded[devWallet] = true;
706         _isExcluded[snackWallet] = true;
707         _isBlacklisted[address(0)] = true;
708         _mint(owner(),  10**12 * 10**18);
709     }
710 
711     receive() external payable {
712     }
713 
714 
715     function _transfer(
716         address from,
717         address to,
718         uint256 amount
719     ) internal override {
720         require(!_isBlacklisted[from] && !_isBlacklisted[to], "To or From address is blacklisted.");
721 
722         if (!isTradingEnabled) {
723             require(_isExcluded[to] || _isExcluded[from], "Trading is not yet enabled. Be patient!");
724         } else if (block.timestamp - startTime < 600 && from == uniswapV2Pair) {
725             require(amount <= maxBuyTxAmount, "Over the max buy amount.");
726         }
727 
728         if(amount == 0) {
729             super._transfer(from, to, 0);
730             return;
731         }
732 
733         uint256 contractTokenBalance = balanceOf(address(this));
734         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
735 
736         if(
737             canSwap &&
738             !swapping &&
739             from != uniswapV2Pair &&
740             from != owner() &&
741             to != owner()
742         ) {
743             swapping = true;
744             uint256 swapTokens = contractTokenBalance.mul(30).div(100);
745             swapAndLiquify(swapTokens);
746             uint256 burnTokens = balanceOf(address(this)).div(7);
747             _burn(address(this), burnTokens);
748             uint256 sellTokens = balanceOf(address(this));
749             swapAndSendDividends(sellTokens);
750             swapping = false;
751         }
752 
753         bool takeFee = !swapping;
754 
755         if(_isExcluded[from] || _isExcluded[to]) {
756             takeFee = false;
757         }
758 
759         if (takeFee){
760 
761             uint8  liquidityFee = 0;
762             uint8  devFee = 0;
763             uint8  protocolFee = 0;
764             uint8  burnFee = 0;
765             
766             if (from == uniswapV2Pair) {
767                 liquidityFee = buy_liquidityFee;
768                 devFee = buy_devFee;
769                 protocolFee = buy_protocolFee;
770                 burnFee = buy_burnFee;
771             } else if (to == uniswapV2Pair){
772                 liquidityFee = sell_liquidityFee;
773                 devFee =sell_devFee;
774                 protocolFee = sell_protocolFee;
775                 burnFee = sell_burnFee;
776             } 
777             
778         uint256 fees = amount.mul(liquidityFee + devFee + protocolFee + burnFee).div(1000);
779         amount = amount.sub(fees);
780         super._transfer(from, address(this), fees);
781         }
782 
783         super._transfer(from, to, amount);
784     }
785 
786     function swapAndLiquify(uint256 tokens) private {
787         uint256 half = tokens.div(2);
788         uint256 otherHalf = tokens.sub(half);
789         uint256 initialBalance = address(this).balance;
790         swapTokensForEth(half);
791         uint256 newBalance = address(this).balance.sub(initialBalance);
792         addLiquidity(otherHalf, newBalance);
793     }
794 
795     function swapTokensForEth(uint256 tokenAmount) private {
796         address[] memory path = new address[](2);
797         path[0] = address(this);
798         path[1] = uniswapV2Router.WETH();
799         _approve(address(this), address(uniswapV2Router), tokenAmount);
800         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
801             tokenAmount,
802             0,
803             path,
804             address(this),
805             block.timestamp + 200
806         );
807     }
808 
809     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
810         _approve(address(this), address(uniswapV2Router), tokenAmount);
811         uniswapV2Router.addLiquidityETH{value: ethAmount}(
812             address(this),
813             tokenAmount,
814             0,
815             0,
816             owner(),
817             block.timestamp + 200
818         );
819     }
820 
821     function swapAndSendDividends(uint256 tokens) private {
822         swapTokensForEth(tokens);
823         uint256 ethBalance = address(this).balance;
824         uint256 half       = ethBalance.div(2);
825         uint256 otherHalf  = ethBalance.sub(half);
826         payable(devWallet).transfer(half);
827         payable(snackWallet).transfer(otherHalf);
828     }
829 
830     function setBlacklist(address account, bool value) external onlyOwner {
831         _isBlacklisted[account] = value;
832     }
833 
834     function enableTrading() external onlyOwner {
835         require(!isTradingEnabled, "already enabled");
836         isTradingEnabled = true;
837         startTime = block.timestamp;
838     }
839 
840     function disableTrading () external onlyOwner {
841         require(isTradingEnabled, "already disabled");
842         isTradingEnabled = false;
843     }
844 
845     function setSwapAtAmount(uint256 amount) external onlyOwner {
846         swapTokensAtAmount = amount;
847     }
848 
849     function setMaxTxAmount(uint256 amount) external onlyOwner {
850         maxBuyTxAmount = amount;
851     }
852 
853 
854     function setDevWallet(address _address) external onlyOwner {
855         _isExcluded[devWallet] = false;
856         devWallet = _address;
857         _isExcluded[devWallet] = true;
858     }
859 
860     function changeOwner (address _address) external onlyOwner{
861         _isExcluded[_address] = false;
862         transferOwnership(_address);
863         _isExcluded[_address] = true;
864     }
865 
866     function setSnackWallet (address _address) external onlyOwner{
867         _isExcluded[snackWallet] = false;
868         snackWallet = _address;
869         _isExcluded[snackWallet] = true;
870     }
871 
872     function setExcludeWallet (address _address, bool _value) external onlyOwner{
873         _isExcluded[_address] = _value;
874     }
875 }