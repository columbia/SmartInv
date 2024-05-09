1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     
42     constructor() {
43         _transferOwnership(_msgSender());
44     }
45 
46     
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51    
52     modifier onlyOwner() {
53         require(owner() == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57    
58     function renounceOwnership() public virtual onlyOwner {
59         _transferOwnership(address(0));
60     }
61 
62    
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _transferOwnership(newOwner);
66     }
67 
68    
69     function _transferOwnership(address newOwner) internal virtual {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80         return c;
81     }
82 
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86 
87     function sub(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94         return c;
95     }
96 
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103         return c;
104     }
105 
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         return c;
118     }
119 }
120 
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB)
123         external
124         returns (address pair);
125 }
126 
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external;
135 
136     function factory() external pure returns (address);
137 
138     function WETH() external pure returns (address);
139 
140     function addLiquidityETH(
141         address token,
142         uint256 amountTokenDesired,
143         uint256 amountTokenMin,
144         uint256 amountETHMin,
145         address to,
146         uint256 deadline
147     )
148         external
149         payable
150         returns (
151             uint256 amountToken,
152             uint256 amountETH,
153             uint256 liquidity
154         );
155 }
156 
157 contract CoinScan is Context, IERC20, Ownable {
158 
159     using SafeMath for uint256;
160 
161     string private constant _name = "CoinScan";
162     string private constant _symbol = "SCAN";
163     uint8 private constant _decimals = 9;
164 
165     mapping (address => uint256) _balances;
166     mapping(address => uint256) _lastTX;
167     mapping(address => mapping(address => uint256)) private _allowances;
168     mapping(address => bool) private _isExcludedFromFee;
169     uint256 _totalSupply = 1000000000 * 10**9;
170 
171     //Buy Fee
172     uint256 private _taxFeeOnBuy = 9;
173 
174     //Sell Fee
175     uint256 private _taxFeeOnSell = 9;
176 
177     //Original Fee
178     uint256 private _taxFee = _taxFeeOnSell;
179     uint256 private _previoustaxFee = _taxFee;
180 
181     mapping(address => bool) public bots;
182 
183 
184     address payable private _marketingAddress = payable(0x6e817c0c9d691f7E04a5eAc0c8838c3eef7192b1);
185 
186     IUniswapV2Router02 public uniswapV2Router;
187     address public uniswapV2Pair;
188 
189     bool private tradingOpen = false;
190     bool private inSwap = false;
191     bool private swapEnabled = true;
192     bool private transferDelay = true;
193 
194     uint256 public _maxTxAmount = 1000000 * 10**9; //0.75
195     uint256 public _maxWalletSize = 10000000 * 10**9; //1.5
196     uint256 public _swapTokensAtAmount = 1000000 * 10**9; //0.1
197 
198     event MaxTxAmountUpdated(uint256 _maxTxAmount);
199     modifier lockTheSwap {
200         inSwap = true;
201         _;
202         inSwap = false;
203     }
204 
205     constructor() {
206 
207         _balances[_msgSender()] = _totalSupply;
208 
209         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
210         uniswapV2Router = _uniswapV2Router;
211         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
212             .createPair(address(this), _uniswapV2Router.WETH());
213 
214         _isExcludedFromFee[owner()] = true;
215         _isExcludedFromFee[address(this)] = true;
216         _isExcludedFromFee[_marketingAddress] = true;
217 	    _isExcludedFromFee[_marketingAddress] = true; //multisig
218 
219         
220 
221         emit Transfer(address(0), _msgSender(), _totalSupply);
222     }
223 
224     function name() public pure returns (string memory) {
225         return _name;
226     }
227 
228     function symbol() public pure returns (string memory) {
229         return _symbol;
230     }
231 
232     function decimals() public pure returns (uint8) {
233         return _decimals;
234     }
235 
236     function totalSupply() public view override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return _balances[account]; 
242     }
243 
244     function transfer(address recipient, uint256 amount)
245         public
246         override
247         returns (bool)
248     {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     function allowance(address owner, address spender)
254         public
255         view
256         override
257         returns (uint256)
258     {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public override returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(
278             sender,
279             _msgSender(),
280             _allowances[sender][_msgSender()].sub(
281                 amount,
282                 "ERC20: transfer amount exceeds allowance"
283             )
284         );
285         return true;
286     }
287 
288     function _approve(
289         address owner,
290         address spender,
291         uint256 amount
292     ) private {
293         require(owner != address(0), "ERC20: approve from the zero address");
294         require(spender != address(0), "ERC20: approve to the zero address");
295         _allowances[owner][spender] = amount;
296         emit Approval(owner, spender, amount);
297     }
298 
299     function _transfer(
300         address from,
301         address to,
302         uint256 amount
303     ) private {
304         require(from != address(0), "ERC20: transfer from the zero address");
305         require(to != address(0), "ERC20: transfer to the zero address");
306         require(amount > 0, "Transfer amount must be greater than zero");
307 
308         if (!_isExcludedFromFee[to] && !_isExcludedFromFee[from]) {
309 	    require(tradingOpen, "TOKEN: Trading not yet started");
310             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
311             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
312 
313             if(to != uniswapV2Pair) {
314 		        if(from == uniswapV2Pair && transferDelay){
315 		            require(_lastTX[tx.origin] + 3 minutes < block.timestamp && _lastTX[to] + 3 minutes < block.timestamp, "TOKEN: 3 minutes cooldown between buys");
316 		        }
317                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
318             }
319 
320             uint256 contractTokenBalance = balanceOf(address(this));
321             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
322 
323             if(contractTokenBalance >= _swapTokensAtAmount)
324             {
325                 contractTokenBalance = _swapTokensAtAmount;
326             }
327 
328             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
329                 swapTokensForEth(contractTokenBalance); // Reserve of 15% of tokens for liquidity
330                 uint256 contractETHBalance = address(this).balance;
331                 if (contractETHBalance > 0 ether) {
332                     sendETHToFee(address(this).balance);
333                 }
334             }
335         }
336 
337         bool takeFee = true;
338 
339         //Transfer Tokens
340         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
341             takeFee = false;
342         } else {
343 
344             //Set Fee for Buys
345             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
346                 _taxFee = _taxFeeOnBuy;
347             }
348 
349             //Set Fee for Sells
350             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
351                 _taxFee = _taxFeeOnSell;
352             }
353 
354         }
355 	    _lastTX[tx.origin] = block.timestamp;
356 	    _lastTX[to] = block.timestamp;
357         _tokenTransfer(from, to, amount, takeFee);
358     }
359 
360     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
361 	uint256 ethAmt = tokenAmount.mul(85).div(100);
362 	uint256 liqAmt = tokenAmount - ethAmt;
363         uint256 balanceBefore = address(this).balance;
364 
365         address[] memory path = new address[](2);
366         path[0] = address(this);
367         path[1] = uniswapV2Router.WETH();
368         _approve(address(this), address(uniswapV2Router), tokenAmount);
369         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
370             ethAmt,
371             0,
372             path,
373             address(this),
374             block.timestamp
375         );
376         uint256 amountETH = address(this).balance.sub(balanceBefore);
377 
378       addLiquidity(liqAmt, amountETH.mul(15).div(100));
379     }
380 
381     function sendETHToFee(uint256 amount) private {
382         _marketingAddress.transfer(amount);
383     }
384 
385     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
386 
387         // approve token transfer to cover all possible scenarios
388         _approve(address(this), address(uniswapV2Router), tokenAmount);
389 
390         // add the liquidity
391         uniswapV2Router.addLiquidityETH{value: ethAmount}(
392             address(this),
393             tokenAmount,
394             0, // slippage is unavoidable
395             0, // slippage is unavoidable
396             address(0),
397             block.timestamp
398         );
399 
400     }
401 
402     function setTrading(bool _tradingOpen) public onlyOwner {
403         tradingOpen = _tradingOpen;
404     }
405 
406     function manualswap() external onlyOwner {
407         uint256 contractBalance = balanceOf(address(this));
408         swapTokensForEth(contractBalance);
409     }
410 
411     function blockBots(address[] memory bots_) public onlyOwner {
412         for (uint256 i = 0; i < bots_.length; i++) {
413             bots[bots_[i]] = true;
414         }
415     }
416 
417     function unblockBot(address notbot) public onlyOwner {
418         bots[notbot] = false;
419     }
420 
421     function _tokenTransfer(
422         address sender,
423         address recipient,
424         uint256 amount,
425         bool takeFee
426     ) private {
427         if (!takeFee) {_transferNoTax(sender,recipient, amount);}
428         else {_transferStandard(sender, recipient, amount);}
429     }
430 
431      function airdrop(address[] calldata recipients, uint256[] calldata amount) public onlyOwner{
432        for (uint256 i = 0; i < recipients.length; i++) {
433             _transferNoTax(msg.sender,recipients[i], amount[i]);
434         }
435     }
436 
437     function _transferStandard(
438         address sender,
439         address recipient,
440         uint256 amount
441     ) private {
442         uint256 amountReceived = takeFees(sender, amount);
443         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
444         _balances[recipient] = _balances[recipient].add(amountReceived);
445         emit Transfer(sender, recipient, amountReceived);
446     }
447      function _transferNoTax(address sender, address recipient, uint256 amount) internal returns (bool) {
448         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
449         _balances[recipient] = _balances[recipient].add(amount);
450         emit Transfer(sender, recipient, amount);
451         return true;
452     }
453     function takeFees(address sender,uint256 amount) internal returns (uint256) {
454         uint256 feeAmount = amount.mul(_taxFee).div(100);
455         _balances[address(this)] = _balances[address(this)].add(feeAmount);
456         emit Transfer(sender, address(this), feeAmount);
457         return amount.sub(feeAmount);
458     }
459 
460 
461     receive() external payable {}
462 
463     function transferOwnership(address newOwner) public override onlyOwner {
464         require(newOwner != address(0), "Ownable: new owner is the zero address");
465         _isExcludedFromFee[owner()] = false;
466         _transferOwnership(newOwner);
467         _isExcludedFromFee[owner()] = true;
468 
469     }
470   
471     function setFees(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
472         _taxFeeOnBuy = taxFeeOnBuy;
473         _taxFeeOnSell = taxFeeOnSell;
474     }
475 
476     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
477         _swapTokensAtAmount = swapTokensAtAmount;
478     }
479     
480     function toggleSwap(bool _swapEnabled) public onlyOwner {
481         swapEnabled = _swapEnabled;
482     }
483     
484     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
485         _maxTxAmount = maxTxAmount;
486     }
487     
488     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
489         _maxWalletSize = maxWalletSize;
490     }
491 
492     function setIsFeeExempt(address holder, bool exempt) public onlyOwner {
493         _isExcludedFromFee[holder] = exempt;
494     }
495 
496 
497     function toggleTransferDelay() public onlyOwner {
498         transferDelay = !transferDelay;
499     }
500 }