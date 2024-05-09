1 /**
2 
3 Twitter: https://twitter.com/BecomeACEO
4 Telegram: https://t.me/CEOPortal
5 
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.17;
11 
12 interface IUniswapV2Factory {
13     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
14 
15     function feeTo() external view returns (address);
16     function feeToSetter() external view returns (address);
17     function getPair(address tokenA, address tokenB) external view returns (address pair);
18     function allPairs(uint) external view returns (address pair);
19     function allPairsLength() external view returns (uint);
20     function createPair(address tokenA, address tokenB) external returns (address pair);
21     function setFeeTo(address) external;
22     function setFeeToSetter(address) external;
23 }
24 
25 interface IUniswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28 
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35 
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39 
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43 
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45 
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57 
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59     function factory() external view returns (address);
60     function token0() external view returns (address);
61     function token1() external view returns (address);
62     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63     function price0CumulativeLast() external view returns (uint);
64     function price1CumulativeLast() external view returns (uint);
65     function kLast() external view returns (uint);
66 
67     function mint(address to) external returns (uint liquidity);
68     function burn(address to) external returns (uint amount0, uint amount1);
69     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70     function skim(address to) external;
71     function sync() external;
72 
73     function initialize(address, address) external;
74 }
75 
76 interface IUniswapV2Router01 {
77     function factory() external pure returns (address);
78     function WETH() external pure returns (address);
79 
80     function addLiquidity(
81         address tokenA,
82         address tokenB,
83         uint amountADesired,
84         uint amountBDesired,
85         uint amountAMin,
86         uint amountBMin,
87         address to,
88         uint deadline
89     ) external returns (uint amountA, uint amountB, uint liquidity);
90     function addLiquidityETH(
91         address token,
92         uint amountTokenDesired,
93         uint amountTokenMin,
94         uint amountETHMin,
95         address to,
96         uint deadline
97     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
98     function removeLiquidity(
99         address tokenA,
100         address tokenB,
101         uint liquidity,
102         uint amountAMin,
103         uint amountBMin,
104         address to,
105         uint deadline
106     ) external returns (uint amountA, uint amountB);
107     function removeLiquidityETH(
108         address token,
109         uint liquidity,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external returns (uint amountToken, uint amountETH);
115     function removeLiquidityWithPermit(
116         address tokenA,
117         address tokenB,
118         uint liquidity,
119         uint amountAMin,
120         uint amountBMin,
121         address to,
122         uint deadline,
123         bool approveMax, uint8 v, bytes32 r, bytes32 s
124     ) external returns (uint amountA, uint amountB);
125     function removeLiquidityETHWithPermit(
126         address token,
127         uint liquidity,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline,
132         bool approveMax, uint8 v, bytes32 r, bytes32 s
133     ) external returns (uint amountToken, uint amountETH);
134     function swapExactTokensForTokens(
135         uint amountIn,
136         uint amountOutMin,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external returns (uint[] memory amounts);
141     function swapTokensForExactTokens(
142         uint amountOut,
143         uint amountInMax,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external returns (uint[] memory amounts);
148     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
149         external
150         payable
151         returns (uint[] memory amounts);
152     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
153         external
154         returns (uint[] memory amounts);
155     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
156         external
157         returns (uint[] memory amounts);
158     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
159         external
160         payable
161         returns (uint[] memory amounts);
162 
163     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
164     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
165     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
166     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
167     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
168 }
169 
170 interface IUniswapV2Router02 is IUniswapV2Router01 {
171     function removeLiquidityETHSupportingFeeOnTransferTokens(
172         address token,
173         uint liquidity,
174         uint amountTokenMin,
175         uint amountETHMin,
176         address to,
177         uint deadline
178     ) external returns (uint amountETH);
179     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline,
186         bool approveMax, uint8 v, bytes32 r, bytes32 s
187     ) external returns (uint amountETH);
188 
189     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
190         uint amountIn,
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external;
196     function swapExactETHForTokensSupportingFeeOnTransferTokens(
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external payable;
202     function swapExactTokensForETHSupportingFeeOnTransferTokens(
203         uint amountIn,
204         uint amountOutMin,
205         address[] calldata path,
206         address to,
207         uint deadline
208     ) external;
209 }
210 
211 interface IERC20 {
212     function totalSupply() external view returns (uint256);
213     function balanceOf(address account) external view returns (uint256);
214     function transfer(address recipient, uint256 amount) external returns (bool);
215     function allowance(address owner, address spender) external view returns (uint256);
216     function approve(address spender, uint256 amount) external returns (bool);
217     function transferFrom(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) external returns (bool);
222    
223     event Transfer(address indexed from, address indexed to, uint256 value);
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 interface IERC20Metadata is IERC20 {
228     function name() external view returns (string memory);
229     function symbol() external view returns (string memory);
230     function decimals() external view returns (uint8);
231 }
232 
233 library Address {
234     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
235         require(address(this).balance >= amount, "Address: insufficient balance");
236 
237         (bool success, ) = recipient.call{value: amount}("");
238         return success;
239     }
240 }
241 
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
249         return msg.data;
250     }
251 }
252 
253 abstract contract Ownable is Context {
254     address private _owner;
255 
256     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258     constructor () {
259         address msgSender = _msgSender();
260         _owner = msgSender;
261         emit OwnershipTransferred(address(0), msgSender);
262     }
263 
264     function owner() public view returns (address) {
265         return _owner;
266     }
267 
268     modifier onlyOwner() {
269         require(_owner == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     function renounceOwnership() public virtual onlyOwner {
274         emit OwnershipTransferred(_owner, address(0));
275         _owner = address(0);
276     }
277 
278     function transferOwnership(address newOwner) public virtual onlyOwner {
279         require(newOwner != address(0), "Ownable: new owner is the zero address");
280         emit OwnershipTransferred(_owner, newOwner);
281         _owner = newOwner;
282     }
283 }
284 
285 contract ERC20 is Context, IERC20, IERC20Metadata {
286     mapping(address => uint256) private _balances;
287 
288     mapping(address => mapping(address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     string private _name;
293     string private _symbol;
294 
295     constructor(string memory name_, string memory symbol_) {
296         _name = name_;
297         _symbol = symbol_;
298     }
299 
300     function name() public view virtual override returns (string memory) {
301         return _name;
302     }
303 
304     function symbol() public view virtual override returns (string memory) {
305         return _symbol;
306     }
307 
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     function totalSupply() public view virtual override returns (uint256) {
313         return _totalSupply;
314     }
315 
316     function balanceOf(address account) public view virtual override returns (uint256) {
317         return _balances[account];
318     }
319 
320     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     function approve(address spender, uint256 amount) public virtual override returns (bool) {
330         _approve(_msgSender(), spender, amount);
331         return true;
332     }
333 
334     function transferFrom(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) public virtual override returns (bool) {
339         uint256 currentAllowance = _allowances[sender][_msgSender()];
340         if (currentAllowance != type(uint256).max) {
341             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
342             unchecked {
343                 _approve(sender, _msgSender(), currentAllowance - amount);
344             }
345         }
346 
347         _transfer(sender, recipient, amount);
348 
349         return true;
350     }
351 
352     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
353         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
354         return true;
355     }
356 
357     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
358         uint256 currentAllowance = _allowances[_msgSender()][spender];
359         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
360         unchecked {
361             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
362         }
363 
364         return true;
365     }
366 
367     function _transfer(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) internal virtual {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(sender, recipient, amount);
376 
377         uint256 senderBalance = _balances[sender];
378         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[sender] = senderBalance - amount;
381         }
382         _balances[recipient] += amount;
383 
384         emit Transfer(sender, recipient, amount);
385 
386         _afterTokenTransfer(sender, recipient, amount);
387     }
388 
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply += amount;
395         _balances[account] += amount;
396         emit Transfer(address(0), account, amount);
397 
398         _afterTokenTransfer(address(0), account, amount);
399     }
400 
401     function _burn(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: burn from the zero address");
403 
404         _beforeTokenTransfer(account, address(0), amount);
405 
406         uint256 accountBalance = _balances[account];
407         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
408         unchecked {
409             _balances[account] = accountBalance - amount;
410         }
411         _totalSupply -= amount;
412 
413         emit Transfer(account, address(0), amount);
414 
415         _afterTokenTransfer(account, address(0), amount);
416     }
417 
418     function _approve(
419         address owner,
420         address spender,
421         uint256 amount
422     ) internal virtual {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425 
426         _allowances[owner][spender] = amount;
427         emit Approval(owner, spender, amount);
428     }
429 
430     function _beforeTokenTransfer(
431         address from,
432         address to,
433         uint256 amount
434     ) internal virtual {}
435 
436     function _afterTokenTransfer(
437         address from,
438         address to,
439         uint256 amount
440     ) internal virtual {}
441 }
442 
443 contract CEO is ERC20, Ownable {
444     using Address for address payable;
445 
446     IUniswapV2Router02 public uniswapV2Router;
447     address public  uniswapV2Pair;
448 
449     mapping (address => bool) private _isExcludedFromFees;
450 
451     uint256 public  marketingFeeOnBuy;
452     uint256 public  marketingFeeOnSell;
453 
454     uint256 public  marketingFeeOnTransfer;
455 
456     address public  marketingWallet;
457 
458     uint256 public  swapTokensAtAmount;
459     bool    private swapping;
460 
461     bool    public swapEnabled;
462 
463     event ExcludeFromFees(address indexed account, bool isExcluded);
464     event MarketingWalletChanged(address marketingWallet);
465     event UpdateFees(uint256 marketingFeeOnBuy, uint256 marketingFeeOnSell);
466     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
467     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
468 
469     constructor () ERC20("CEO", "CEO") 
470     {   
471         address router;
472         if (block.chainid == 56) {
473             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
474         } else if (block.chainid == 97) {
475             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
476         } else if (block.chainid == 1 || block.chainid == 5) {
477             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
478         } else {
479             revert();
480         }
481 
482         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
483         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
484             .createPair(address(this), _uniswapV2Router.WETH());
485 
486         uniswapV2Router = _uniswapV2Router;
487         uniswapV2Pair   = _uniswapV2Pair;
488 
489         _approve(address(this), address(uniswapV2Router), type(uint256).max);
490 
491         marketingFeeOnBuy  = 5;
492         marketingFeeOnSell = 5;
493 
494         marketingFeeOnTransfer = 5;
495 
496         marketingWallet = 0x2C837311D261783fE6758Fa270D75E734669d4AD;
497 
498         _isExcludedFromFees[owner()] = true;
499         _isExcludedFromFees[address(0xdead)] = true;
500         _isExcludedFromFees[address(this)] = true;
501         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
502 
503         _mint(owner(), 1e6 * (10 ** decimals()));
504         swapTokensAtAmount = totalSupply() / 5_000;
505 
506         tradingEnabled = false;
507         swapEnabled = false;
508     }
509 
510     receive() external payable {
511 
512   	}
513 
514     function claimStuckTokens(address token) external onlyOwner {
515         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
516         if (token == address(0x0)) {
517             payable(msg.sender).sendValue(address(this).balance);
518             return;
519         }
520         IERC20 ERC20token = IERC20(token);
521         uint256 balance = ERC20token.balanceOf(address(this));
522         ERC20token.transfer(msg.sender, balance);
523     }
524 
525     function excludeFromFees(address account, bool excluded) external onlyOwner{
526         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
527         _isExcludedFromFees[account] = excluded;
528 
529         emit ExcludeFromFees(account, excluded);
530     }
531 
532     function isExcludedFromFees(address account) public view returns(bool) {
533         return _isExcludedFromFees[account];
534     }
535 
536     function updateFees(uint256 _marketingFeeOnSell, uint256 _marketingFeeOnBuy, uint256 _marketingFeeOnTransfer) external onlyOwner {
537         marketingFeeOnSell = _marketingFeeOnSell;
538         marketingFeeOnBuy = _marketingFeeOnBuy;
539         marketingFeeOnTransfer = _marketingFeeOnTransfer;
540 
541         require(marketingFeeOnBuy <= 5, "Total Fees cannot exceed the maximum");
542         require(marketingFeeOnSell <= 5, "Total Fees cannot exceed the maximum");
543         require(marketingFeeOnTransfer <= 5, "Total Fees cannot exceed the maximum");
544 
545         emit UpdateFees(marketingFeeOnSell, marketingFeeOnBuy);
546     }
547 
548     function changeMarketingWallet(address _marketingWallet) external onlyOwner{
549         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
550         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
551         marketingWallet = _marketingWallet;
552 
553         emit MarketingWalletChanged(marketingWallet);
554     }
555 
556     bool public tradingEnabled;
557 
558     function enableTrading() external onlyOwner{
559         require(!tradingEnabled, "Trading already enabled.");
560         tradingEnabled = true;
561         swapEnabled = true;
562     }
563 
564     function _transfer(address from,address to,uint256 amount) internal  override {
565         require(from != address(0), "ERC20: transfer from the zero address");
566         require(to != address(0), "ERC20: transfer to the zero address");
567         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
568        
569         if (amount == 0) {
570             super._transfer(from, to, 0);
571             return;
572         }
573 
574 		uint256 contractTokenBalance = balanceOf(address(this));
575 
576         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
577 
578         if (canSwap &&
579             !swapping &&
580             to == uniswapV2Pair &&
581             swapEnabled
582         ) {
583             swapping = true;
584 
585             swapAndSendMarketing(contractTokenBalance);     
586 
587             swapping = false;
588         }
589 
590         uint256 _totalFees;
591         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
592             _totalFees = 0;
593         } else if (from == uniswapV2Pair) {
594             _totalFees = marketingFeeOnBuy;
595         } else if (to == uniswapV2Pair) {
596             _totalFees =  marketingFeeOnSell;
597         } else {
598             _totalFees = marketingFeeOnTransfer;
599         }
600 
601         if (_totalFees > 0) {
602             uint256 fees = (amount * _totalFees) / 100;
603             amount = amount - fees;
604             super._transfer(from, address(this), fees);
605         }
606 
607 
608         super._transfer(from, to, amount);
609     }
610 
611     function setSwapEnabled(bool _enabled) external onlyOwner{
612         require(swapEnabled != _enabled, "swapEnabled already at this state.");
613         swapEnabled = _enabled;
614     }
615 
616     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
617         require(newAmount > totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
618         swapTokensAtAmount = newAmount;
619 
620         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
621     }
622 
623     function swapAndSendMarketing(uint256 tokenAmount) private {
624         uint256 initialBalance = address(this).balance;
625 
626         address[] memory path = new address[](2);
627         path[0] = address(this);
628         path[1] = uniswapV2Router.WETH();
629 
630         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
631             tokenAmount,
632             0,
633             path,
634             address(this),
635             block.timestamp);
636 
637         uint256 newBalance = address(this).balance - initialBalance;
638 
639         payable(marketingWallet).sendValue(newBalance);
640 
641         emit SwapAndSendMarketing(tokenAmount, newBalance);
642     }
643 }