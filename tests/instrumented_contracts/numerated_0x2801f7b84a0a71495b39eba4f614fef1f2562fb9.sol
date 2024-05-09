1 /** 
2 
3 $CHAIR
4 https://medium.com/@chairmaneth/chair-an-origin-story-2dda5195789a
5 
6 
7  /|       
8 | |___     
9 |/___/|    
10 | | | |   
11 |   |        
12 
13 
14 https://ch4ir.io // https://t.me/Chair_ETH // https://twitter.com/TheChairETH
15 
16 **/
17 
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity 0.8.17;
22 
23 interface IUniswapV2Factory {
24     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
25 
26     function feeTo() external view returns (address);
27     function feeToSetter() external view returns (address);
28     function getPair(address tokenA, address tokenB) external view returns (address pair);
29     function allPairs(uint) external view returns (address pair);
30     function allPairsLength() external view returns (uint);
31     function createPair(address tokenA, address tokenB) external returns (address pair);
32     function setFeeTo(address) external;
33     function setFeeToSetter(address) external;
34 }
35 
36 interface IUniswapV2Pair {
37     event Approval(address indexed owner, address indexed spender, uint value);
38     event Transfer(address indexed from, address indexed to, uint value);
39 
40     function name() external pure returns (string memory);
41     function symbol() external pure returns (string memory);
42     function decimals() external pure returns (uint8);
43     function totalSupply() external view returns (uint);
44     function balanceOf(address owner) external view returns (uint);
45     function allowance(address owner, address spender) external view returns (uint);
46 
47     function approve(address spender, uint value) external returns (bool);
48     function transfer(address to, uint value) external returns (bool);
49     function transferFrom(address from, address to, uint value) external returns (bool);
50 
51     function DOMAIN_SEPARATOR() external view returns (bytes32);
52     function PERMIT_TYPEHASH() external pure returns (bytes32);
53     function nonces(address owner) external view returns (uint);
54 
55     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
56 
57     event Mint(address indexed sender, uint amount0, uint amount1);
58     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
59     event Swap(
60         address indexed sender,
61         uint amount0In,
62         uint amount1In,
63         uint amount0Out,
64         uint amount1Out,
65         address indexed to
66     );
67     event Sync(uint112 reserve0, uint112 reserve1);
68 
69     function MINIMUM_LIQUIDITY() external pure returns (uint);
70     function factory() external view returns (address);
71     function token0() external view returns (address);
72     function token1() external view returns (address);
73     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
74     function price0CumulativeLast() external view returns (uint);
75     function price1CumulativeLast() external view returns (uint);
76     function kLast() external view returns (uint);
77 
78     function mint(address to) external returns (uint liquidity);
79     function burn(address to) external returns (uint amount0, uint amount1);
80     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
81     function skim(address to) external;
82     function sync() external;
83 
84     function initialize(address, address) external;
85 }
86 
87 interface IUniswapV2Router01 {
88     function factory() external pure returns (address);
89     function WETH() external pure returns (address);
90 
91     function addLiquidity(
92         address tokenA,
93         address tokenB,
94         uint amountADesired,
95         uint amountBDesired,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB, uint liquidity);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109     function removeLiquidity(
110         address tokenA,
111         address tokenB,
112         uint liquidity,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline
117     ) external returns (uint amountA, uint amountB);
118     function removeLiquidityETH(
119         address token,
120         uint liquidity,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountToken, uint amountETH);
126     function removeLiquidityWithPermit(
127         address tokenA,
128         address tokenB,
129         uint liquidity,
130         uint amountAMin,
131         uint amountBMin,
132         address to,
133         uint deadline,
134         bool approveMax, uint8 v, bytes32 r, bytes32 s
135     ) external returns (uint amountA, uint amountB);
136     function removeLiquidityETHWithPermit(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline,
143         bool approveMax, uint8 v, bytes32 r, bytes32 s
144     ) external returns (uint amountToken, uint amountETH);
145     function swapExactTokensForTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external returns (uint[] memory amounts);
152     function swapTokensForExactTokens(
153         uint amountOut,
154         uint amountInMax,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external returns (uint[] memory amounts);
159     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
160         external
161         payable
162         returns (uint[] memory amounts);
163     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
164         external
165         returns (uint[] memory amounts);
166     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
167         external
168         returns (uint[] memory amounts);
169     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
170         external
171         payable
172         returns (uint[] memory amounts);
173 
174     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
175     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
176     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
177     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
178     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
179 }
180 
181 interface IUniswapV2Router02 is IUniswapV2Router01 {
182     function removeLiquidityETHSupportingFeeOnTransferTokens(
183         address token,
184         uint liquidity,
185         uint amountTokenMin,
186         uint amountETHMin,
187         address to,
188         uint deadline
189     ) external returns (uint amountETH);
190     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
191         address token,
192         uint liquidity,
193         uint amountTokenMin,
194         uint amountETHMin,
195         address to,
196         uint deadline,
197         bool approveMax, uint8 v, bytes32 r, bytes32 s
198     ) external returns (uint amountETH);
199 
200     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
201         uint amountIn,
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external;
207     function swapExactETHForTokensSupportingFeeOnTransferTokens(
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external payable;
213     function swapExactTokensForETHSupportingFeeOnTransferTokens(
214         uint amountIn,
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external;
220 }
221 
222 interface IERC20 {
223     function totalSupply() external view returns (uint256);
224     function balanceOf(address account) external view returns (uint256);
225     function transfer(address recipient, uint256 amount) external returns (bool);
226     function allowance(address owner, address spender) external view returns (uint256);
227     function approve(address spender, uint256 amount) external returns (bool);
228     function transferFrom(
229         address sender,
230         address recipient,
231         uint256 amount
232     ) external returns (bool);
233    
234     event Transfer(address indexed from, address indexed to, uint256 value);
235     event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 interface IERC20Metadata is IERC20 {
239     function name() external view returns (string memory);
240     function symbol() external view returns (string memory);
241     function decimals() external view returns (uint8);
242 }
243 
244 library Address {
245     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
246         require(address(this).balance >= amount, "Address: insufficient balance");
247 
248         (bool success, ) = recipient.call{value: amount}("");
249         return success;
250     }
251 }
252 
253 abstract contract Context {
254     function _msgSender() internal view virtual returns (address) {
255         return msg.sender;
256     }
257 
258     function _msgData() internal view virtual returns (bytes calldata) {
259         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
260         return msg.data;
261     }
262 }
263 
264 abstract contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269     constructor () {
270         address msgSender = _msgSender();
271         _owner = msgSender;
272         emit OwnershipTransferred(address(0), msgSender);
273     }
274 
275     function owner() public view returns (address) {
276         return _owner;
277     }
278 
279     modifier onlyOwner() {
280         require(_owner == _msgSender(), "Ownable: caller is not the owner");
281         _;
282     }
283 
284     function renounceOwnership() public virtual onlyOwner {
285         emit OwnershipTransferred(_owner, address(0));
286         _owner = address(0);
287     }
288 
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         emit OwnershipTransferred(_owner, newOwner);
292         _owner = newOwner;
293     }
294 }
295 
296 contract ERC20 is Context, IERC20, IERC20Metadata {
297     mapping(address => uint256) private _balances;
298 
299     mapping(address => mapping(address => uint256)) private _allowances;
300 
301     uint256 private _totalSupply;
302 
303     string private _name;
304     string private _symbol;
305 
306     constructor(string memory name_, string memory symbol_) {
307         _name = name_;
308         _symbol = symbol_;
309     }
310 
311     function name() public view virtual override returns (string memory) {
312         return _name;
313     }
314 
315     function symbol() public view virtual override returns (string memory) {
316         return _symbol;
317     }
318 
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     function totalSupply() public view virtual override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     function balanceOf(address account) public view virtual override returns (uint256) {
328         return _balances[account];
329     }
330 
331     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     function allowance(address owner, address spender) public view virtual override returns (uint256) {
337         return _allowances[owner][spender];
338     }
339 
340     function approve(address spender, uint256 amount) public virtual override returns (bool) {
341         _approve(_msgSender(), spender, amount);
342         return true;
343     }
344 
345     function transferFrom(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) public virtual override returns (bool) {
350         uint256 currentAllowance = _allowances[sender][_msgSender()];
351         if (currentAllowance != type(uint256).max) {
352             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
353             unchecked {
354                 _approve(sender, _msgSender(), currentAllowance - amount);
355             }
356         }
357 
358         _transfer(sender, recipient, amount);
359 
360         return true;
361     }
362 
363     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
365         return true;
366     }
367 
368     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
369         uint256 currentAllowance = _allowances[_msgSender()][spender];
370         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
371         unchecked {
372             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
373         }
374 
375         return true;
376     }
377 
378     function _transfer(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) internal virtual {
383         require(sender != address(0), "ERC20: transfer from the zero address");
384         require(recipient != address(0), "ERC20: transfer to the zero address");
385 
386         _beforeTokenTransfer(sender, recipient, amount);
387 
388         uint256 senderBalance = _balances[sender];
389         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
390         unchecked {
391             _balances[sender] = senderBalance - amount;
392         }
393         _balances[recipient] += amount;
394 
395         emit Transfer(sender, recipient, amount);
396 
397         _afterTokenTransfer(sender, recipient, amount);
398     }
399 
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _beforeTokenTransfer(address(0), account, amount);
404 
405         _totalSupply += amount;
406         _balances[account] += amount;
407         emit Transfer(address(0), account, amount);
408 
409         _afterTokenTransfer(address(0), account, amount);
410     }
411 
412     function _burn(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: burn from the zero address");
414 
415         _beforeTokenTransfer(account, address(0), amount);
416 
417         uint256 accountBalance = _balances[account];
418         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
419         unchecked {
420             _balances[account] = accountBalance - amount;
421         }
422         _totalSupply -= amount;
423 
424         emit Transfer(account, address(0), amount);
425 
426         _afterTokenTransfer(account, address(0), amount);
427     }
428 
429     function _approve(
430         address owner,
431         address spender,
432         uint256 amount
433     ) internal virtual {
434         require(owner != address(0), "ERC20: approve from the zero address");
435         require(spender != address(0), "ERC20: approve to the zero address");
436 
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440 
441     function _beforeTokenTransfer(
442         address from,
443         address to,
444         uint256 amount
445     ) internal virtual {}
446 
447     function _afterTokenTransfer(
448         address from,
449         address to,
450         uint256 amount
451     ) internal virtual {}
452 }
453 
454 contract CHAIR is ERC20, Ownable {
455     using Address for address payable;
456 
457     IUniswapV2Router02 public uniswapV2Router;
458     address public  uniswapV2Pair;
459 
460     mapping (address => bool) private _isExcludedFromFees;
461 
462     string  public creator;
463 
464     uint256 public  marketingFeeOnBuy;
465     uint256 public  marketingFeeOnSell;
466 
467     address public  marketingWallet;
468 
469     uint256 public  swapTokensAtAmount;
470     bool    private swapping;
471 
472     bool    public swapEnabled;
473 
474     event ExcludeFromFees(address indexed account, bool isExcluded);
475     event MarketingWalletChanged(address marketingWallet);
476     event UpdateFees(uint256 marketingFeeOnBuy, uint256 marketingFeeOnSell);
477     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
478     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
479 
480     constructor () ERC20("Chair", "$CHAIR") 
481     {   
482         address router;
483         if (block.chainid == 56) {
484             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
485         } else if (block.chainid == 97) {
486             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
487         } else if (block.chainid == 1 || block.chainid == 5) {
488             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
489         } else {
490             revert();
491         }
492 
493         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
494         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
495             .createPair(address(this), _uniswapV2Router.WETH());
496 
497         uniswapV2Router = _uniswapV2Router;
498         uniswapV2Pair   = _uniswapV2Pair;
499 
500         _approve(address(this), address(uniswapV2Router), type(uint256).max);
501 
502         creator = "CHAIRMAN";
503 
504         marketingFeeOnBuy  = 0;
505         marketingFeeOnSell = 0;
506 
507         marketingWallet = 0x37B88B90E000e5B07Ff0BdC12Bc2E5e581116c94;
508 
509         _isExcludedFromFees[owner()] = true;
510         _isExcludedFromFees[address(0xdead)] = true;
511         _isExcludedFromFees[address(this)] = true;
512         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
513 
514         _mint(owner(), 4444444 * (10 ** decimals()));
515         swapTokensAtAmount = totalSupply() / 5_000;
516 
517         tradingEnabled = false;
518         swapEnabled = false;
519     }
520 
521     receive() external payable {
522 
523   	}
524 
525     function claimStuckTokens(address token) external onlyOwner {
526         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
527         if (token == address(0x0)) {
528             payable(msg.sender).sendValue(address(this).balance);
529             return;
530         }
531         IERC20 ERC20token = IERC20(token);
532         uint256 balance = ERC20token.balanceOf(address(this));
533         ERC20token.transfer(msg.sender, balance);
534     }
535 
536     function excludeFromFees(address account, bool excluded) external onlyOwner{
537         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
538         _isExcludedFromFees[account] = excluded;
539 
540         emit ExcludeFromFees(account, excluded);
541     }
542 
543     function isExcludedFromFees(address account) public view returns(bool) {
544         return _isExcludedFromFees[account];
545     }
546 
547     function updateFees(uint256 _marketingFeeOnSell, uint256 _marketingFeeOnBuy) external onlyOwner {
548         marketingFeeOnSell = _marketingFeeOnSell;
549         marketingFeeOnBuy = _marketingFeeOnBuy;
550 
551         require(marketingFeeOnSell + marketingFeeOnBuy <= 10, "Total Fees cannot exceed the maximum");
552 
553         emit UpdateFees(marketingFeeOnSell, marketingFeeOnBuy);
554     }
555 
556     function changeMarketingWallet(address _marketingWallet) external onlyOwner{
557         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
558         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
559         marketingWallet = _marketingWallet;
560 
561         emit MarketingWalletChanged(marketingWallet);
562     }
563 
564     bool public tradingEnabled;
565 
566     function enableTrading() external onlyOwner{
567         require(!tradingEnabled, "Trading already enabled.");
568         tradingEnabled = true;
569         swapEnabled = true;
570     }
571 
572     function _transfer(address from,address to,uint256 amount) internal  override {
573         require(from != address(0), "ERC20: transfer from the zero address");
574         require(to != address(0), "ERC20: transfer to the zero address");
575         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
576        
577         if (amount == 0) {
578             super._transfer(from, to, 0);
579             return;
580         }
581 
582 		uint256 contractTokenBalance = balanceOf(address(this));
583 
584         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
585 
586         if (canSwap &&
587             !swapping &&
588             to == uniswapV2Pair &&
589             swapEnabled
590         ) {
591             swapping = true;
592 
593             swapAndSendMarketing(contractTokenBalance);     
594 
595             swapping = false;
596         }
597 
598         uint256 _totalFees;
599         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
600             _totalFees = 0;
601         } else if (from == uniswapV2Pair) {
602             _totalFees = marketingFeeOnBuy;
603         } else if (to == uniswapV2Pair) {
604             _totalFees =  marketingFeeOnSell;
605         } else {
606             _totalFees = 0;
607         }
608 
609         if (_totalFees > 0) {
610             uint256 fees = (amount * _totalFees) / 100;
611             amount = amount - fees;
612             super._transfer(from, address(this), fees);
613         }
614 
615 
616         super._transfer(from, to, amount);
617     }
618 
619     function setSwapEnabled(bool _enabled) external onlyOwner{
620         require(swapEnabled != _enabled, "swapEnabled already at this state.");
621         swapEnabled = _enabled;
622     }
623 
624     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
625         require(newAmount > totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
626         swapTokensAtAmount = newAmount;
627 
628         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
629     }
630 
631     function swapAndSendMarketing(uint256 tokenAmount) private {
632         uint256 initialBalance = address(this).balance;
633 
634         address[] memory path = new address[](2);
635         path[0] = address(this);
636         path[1] = uniswapV2Router.WETH();
637 
638         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
639             tokenAmount,
640             0,
641             path,
642             address(this),
643             block.timestamp);
644 
645         uint256 newBalance = address(this).balance - initialBalance;
646 
647         payable(marketingWallet).sendValue(newBalance);
648 
649         emit SwapAndSendMarketing(tokenAmount, newBalance);
650     }
651 }