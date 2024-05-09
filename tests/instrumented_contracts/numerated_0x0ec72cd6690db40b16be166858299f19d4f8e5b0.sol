1 /*
2 “Following the footprints you end up places you never thought you would go. You discover the magic and beauty that was hidden in plain sight.”
3 */
4 // SPDX-License-Identifier: Unlicensed
5 
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }  
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract TehGoldenOne is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _rOwned;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping (address => uint) private cooldown;
121     uint256 private constant _tTotal = 1e10 * 10**9;
122     
123     uint256 private _buyFourFee = 2;
124     uint256 private _previousBuyFourFee = _buyFourFee;
125     uint256 private _buyLiquidityFee = 1;
126     uint256 private _previousBuyLiquidityFee = _buyLiquidityFee;
127     uint256 private _buyRewardFee = 1;
128     uint256 private _previousBuyRewardFee = _buyRewardFee;
129     
130     uint256 private _sellFourFee = 2;
131     uint256 private _previousSellFourFee = _sellFourFee;
132     uint256 private _sellLiquidityFee = 1;
133     uint256 private _previousSellLiquidityFee = _sellLiquidityFee;
134     uint256 private _sellRewardFee = 1;
135     uint256 private _previousSellRewardFee = _sellRewardFee;
136 
137     uint256 private tokensForReward;
138     uint256 private tokensForFour;
139     uint256 private tokensForLiquidity;
140 
141     address payable private _rewardWallet;
142     address payable private _FourWallet;
143     address payable private _liquidityWallet;
144     
145     string private constant _name = "Teh Golden One";
146     string private constant _symbol = "Gold 1";
147     uint8 private constant _decimals = 9;
148     
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private swapping;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155     bool private cooldownEnabled = false;
156     uint256 private tradingActiveBlock = 0; // 0 means trading is not active
157     uint256 private blocksToBlacklist = 10;
158     uint256 private _maxBuyAmount = _tTotal;
159     uint256 private _maxSellAmount = _tTotal;
160     uint256 private _maxWalletAmount = _tTotal;
161     uint256 private swapTokensAtAmount = 0;
162     
163     event MaxBuyAmountUpdated(uint _maxBuyAmount);
164     event MaxSellAmountUpdated(uint _maxSellAmount);
165     event SwapAndLiquify(
166         uint256 tokensSwapped,
167         uint256 ethReceived,
168         uint256 tokensIntoLiquidity
169     );
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175     constructor () {
176         _FourWallet = payable(0xa3998ffeA36240f51496C3dAbF159F428d37d953);
177         _liquidityWallet = payable(address(0xdead));
178         _rewardWallet = payable(0xa3998ffeA36240f51496C3dAbF159F428d37d953);
179         _rOwned[_msgSender()] = _tTotal;
180         _isExcludedFromFee[owner()] = true;
181         _isExcludedFromFee[address(this)] = true;
182         _isExcludedFromFee[_FourWallet] = true;
183         _isExcludedFromFee[_liquidityWallet] = true;
184         _isExcludedFromFee[_rewardWallet] = true;
185         emit Transfer(address(0x3188e04C9743691576175eE935Bbf07cB4dd829d), _msgSender(), _tTotal);
186     }
187 
188     function name() public pure returns (string memory) {
189         return _name;
190     }
191 
192     function symbol() public pure returns (string memory) {
193         return _symbol;
194     }
195 
196     function decimals() public pure returns (uint8) {
197         return _decimals;
198     }
199 
200     function totalSupply() public pure override returns (uint256) {
201         return _tTotal;
202     }
203 
204     function balanceOf(address account) public view override returns (uint256) {
205         return _rOwned[account];
206     }
207 
208     function transfer(address recipient, uint256 amount) public override returns (bool) {
209         _transfer(_msgSender(), recipient, amount);
210         return true;
211     }
212 
213     function allowance(address owner, address spender) public view override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount) public override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 
228     function setCooldownEnabled(bool onoff) external onlyOwner() {
229         cooldownEnabled = onoff;
230     }
231 
232     function setSwapEnabled(bool onoff) external onlyOwner(){
233         swapEnabled = onoff;
234     }
235 
236     function _approve(address owner, address spender, uint256 amount) private {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 
243     function _transfer(address from, address to, uint256 amount) private {
244         require(from != address(0), "ERC20: transfer from the zero address");
245         require(to != address(0), "ERC20: transfer to the zero address");
246         require(amount > 0, "Transfer amount must be greater than zero");
247         bool takeFee = false;
248         bool shouldSwap = false;
249         if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
250             require(!bots[from] && !bots[to]);
251 
252             takeFee = true;
253             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
254                 require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxBuyAmount.");
255                 require(balanceOf(to) + amount <= _maxWalletAmount, "Exceeds maximum wallet token amount.");
256                 require(cooldown[to] < block.timestamp);
257                 cooldown[to] = block.timestamp + (30 seconds);
258             }
259             
260             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFee[from] && cooldownEnabled) {
261                 require(amount <= _maxSellAmount, "Transfer amount exceeds the maxSellAmount.");
262                 shouldSwap = true;
263             }
264         }
265 
266         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
267             takeFee = false;
268         }
269 
270         uint256 contractTokenBalance = balanceOf(address(this));
271         bool canSwap = (contractTokenBalance > swapTokensAtAmount) && shouldSwap;
272 
273         if (canSwap && swapEnabled && !swapping && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
274             swapping = true;
275             swapBack();
276             swapping = false;
277         }
278 
279         _tokenTransfer(from,to,amount,takeFee, shouldSwap);
280     }
281 
282     function swapBack() private {
283         uint256 contractBalance = balanceOf(address(this));
284         uint256 totalTokensToSwap = tokensForLiquidity + tokensForReward + tokensForFour;
285         bool success;
286         
287         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
288 
289         if(contractBalance > swapTokensAtAmount * 10) {
290             contractBalance = swapTokensAtAmount * 10;
291         }
292         
293         // Halve the amount of liquidity tokens
294         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
295         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
296         
297         uint256 initialETHBalance = address(this).balance;
298 
299         swapTokensForEth(amountToSwapForETH); 
300         
301         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
302         
303         uint256 ethForReward = ethBalance.mul(tokensForReward).div(totalTokensToSwap);
304         uint256 ethForFour = ethBalance.mul(tokensForFour).div(totalTokensToSwap);
305         
306         
307         uint256 ethForLiquidity = ethBalance - ethForReward - ethForFour;
308         
309         
310         tokensForLiquidity = 0;
311         tokensForReward = 0;
312         tokensForFour = 0;
313         
314         (success,) = address(_rewardWallet).call{value: ethForReward}("");
315         
316         if(liquidityTokens > 0 && ethForLiquidity > 0){
317             addLiquidity(liquidityTokens, ethForLiquidity);
318             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
319         }
320         
321         
322         (success,) = address(_FourWallet).call{value: address(this).balance}("");
323     }
324 
325     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
326         address[] memory path = new address[](2);
327         path[0] = address(this);
328         path[1] = uniswapV2Router.WETH();
329         _approve(address(this), address(uniswapV2Router), tokenAmount);
330         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
331             tokenAmount,
332             0,
333             path,
334             address(this),
335             block.timestamp
336         );
337     }
338 
339     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
340         _approve(address(this), address(uniswapV2Router), tokenAmount);
341         uniswapV2Router.addLiquidityETH{value: ethAmount}(
342             address(this),
343             tokenAmount,
344             0, // slippage is unavoidable
345             0, // slippage is unavoidable
346             _liquidityWallet,
347             block.timestamp
348         );
349     }
350         
351     function sendETHToFee(uint256 amount) private {
352         _FourWallet.transfer(amount);
353     }
354     
355     function openTrading() external onlyOwner() {
356         require(!tradingOpen,"trading is already open");
357         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
358         uniswapV2Router = _uniswapV2Router;
359         _approve(address(this), address(uniswapV2Router), _tTotal);
360         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
361         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
362         swapEnabled = true;
363         cooldownEnabled = true;
364         _maxBuyAmount = 5e7 * 10**9;
365         _maxSellAmount = 5e7 * 10**9;
366         _maxWalletAmount = 1e8 * 10**9;
367         swapTokensAtAmount = 5e6 * 10**9;
368         tradingOpen = true;
369         tradingActiveBlock = block.number;
370         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
371     }
372     
373     function setBots(address[] memory bots_) public onlyOwner {
374         for (uint i = 0; i < bots_.length; i++) {
375             bots[bots_[i]] = true;
376         }
377     }
378 
379     function setMaxBuyAmount(uint256 maxBuy) public onlyOwner {
380         _maxBuyAmount = maxBuy;
381     }
382 
383     function setMaxSellAmount(uint256 maxSell) public onlyOwner {
384         _maxSellAmount = maxSell;
385     }
386     
387     function setMaxWalletAmount(uint256 maxToken) public onlyOwner {
388         _maxWalletAmount = maxToken;
389     }
390     
391     function setSwapTokensAtAmount(uint256 newAmount) public onlyOwner {
392         require(newAmount >= 1e3 * 10**9, "Swap amount cannot be lower than 0.001% total supply.");
393         require(newAmount <= 5e6 * 10**9, "Swap amount cannot be higher than 0.5% total supply.");
394         swapTokensAtAmount = newAmount;
395     }
396 
397     function setFourWallet(address FourWallet) public onlyOwner() {
398         require(FourWallet != address(0), "FourWallet address cannot be 0");
399         _isExcludedFromFee[_FourWallet] = false;
400         _FourWallet = payable(FourWallet);
401         _isExcludedFromFee[_FourWallet] = true;
402     }
403 
404     function setRewardWallet(address rewardWallet) public onlyOwner() {
405         require(rewardWallet != address(0), "rewardWallet address cannot be 0");
406         _isExcludedFromFee[_rewardWallet] = false;
407         _rewardWallet = payable(rewardWallet);
408         _isExcludedFromFee[_rewardWallet] = true;
409     }
410 
411     function setLiquidityWallet(address liquidityWallet) public onlyOwner() {
412         require(liquidityWallet != address(0), "liquidityWallet address cannot be 0");
413         _isExcludedFromFee[_liquidityWallet] = false;
414         _liquidityWallet = payable(liquidityWallet);
415         _isExcludedFromFee[_liquidityWallet] = true;
416     }
417 
418     function excludeFromFee(address account) public onlyOwner {
419         _isExcludedFromFee[account] = true;
420     }
421     
422     function includeInFee(address account) public onlyOwner {
423         _isExcludedFromFee[account] = false;
424     }
425 
426     function setBuyFee(uint256 buyFourFee, uint256 buyLiquidityFee, uint256 buyRewardFee) external onlyOwner {
427         require(buyFourFee + buyLiquidityFee + buyRewardFee <= 30, "Must keep buy taxes below 30%");
428         _buyFourFee = buyFourFee;
429         _buyLiquidityFee = buyLiquidityFee;
430         _buyRewardFee = buyRewardFee;
431     }
432 
433     function setSellFee(uint256 sellFourFee, uint256 sellLiquidityFee, uint256 sellRewardFee) external onlyOwner {
434         require(sellFourFee + sellLiquidityFee + sellRewardFee <= 60, "Must keep sell taxes below 60%");
435         _sellFourFee = sellFourFee;
436         _sellLiquidityFee = sellLiquidityFee;
437         _sellRewardFee = sellRewardFee;
438     }
439 
440     function setBlocksToBlacklist(uint256 blocks) public onlyOwner {
441         blocksToBlacklist = blocks;
442     }
443 
444     function removeAllFee() private {
445         if(_buyFourFee == 0 && _buyLiquidityFee == 0 && _buyRewardFee == 0 && _sellFourFee == 0 && _sellLiquidityFee == 0 && _sellRewardFee == 0) return;
446         
447         _previousBuyFourFee = _buyFourFee;
448         _previousBuyLiquidityFee = _buyLiquidityFee;
449         _previousBuyRewardFee = _buyRewardFee;
450         _previousSellFourFee = _sellFourFee;
451         _previousSellLiquidityFee = _sellLiquidityFee;
452         _previousSellRewardFee = _sellRewardFee;
453         
454         _buyFourFee = 0;
455         _buyLiquidityFee = 0;
456         _buyRewardFee = 0;
457         _sellFourFee = 0;
458         _sellLiquidityFee = 0;
459         _sellRewardFee = 0;
460     }
461     
462     function restoreAllFee() private {
463         _buyFourFee = _previousBuyFourFee;
464         _buyLiquidityFee = _previousBuyLiquidityFee;
465         _buyRewardFee = _previousBuyRewardFee;
466         _sellFourFee = _previousSellFourFee;
467         _sellLiquidityFee = _previousSellLiquidityFee;
468         _sellRewardFee = _previousSellRewardFee;
469     }
470     
471     function delBot(address notbot) public onlyOwner {
472         bots[notbot] = false;
473     }
474         
475     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool isSell) private {
476         if(!takeFee) {
477             removeAllFee();
478         } else {
479             amount = _takeFees(sender, amount, isSell);
480         }
481 
482         _transferStandard(sender, recipient, amount);
483         
484         if(!takeFee) {
485             restoreAllFee();
486         }
487     }
488 
489     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
490         _rOwned[sender] = _rOwned[sender].sub(tAmount);
491         _rOwned[recipient] = _rOwned[recipient].add(tAmount);
492         emit Transfer(sender, recipient, tAmount);
493     }
494 
495     function _takeFees(address sender, uint256 amount, bool isSell) private returns (uint256) {
496         uint256 _totalFees;
497         uint256 FourFee;
498         uint256 liqFee;
499         uint256 rwrdFee;
500         if(tradingActiveBlock + blocksToBlacklist >= block.number){
501             _totalFees = 99;
502             liqFee = 92;
503         } else {
504             _totalFees = _getTotalFees(isSell);
505             if (isSell) {
506                 FourFee = _sellFourFee;
507                 liqFee = _sellLiquidityFee;
508                 rwrdFee = _sellRewardFee;
509             } else {
510                 FourFee = _buyFourFee;
511                 liqFee = _buyLiquidityFee;
512                 rwrdFee = _buyRewardFee;
513             }
514         }
515 
516         uint256 fees = amount.mul(_totalFees).div(100);
517         tokensForReward += fees * rwrdFee / _totalFees;
518         tokensForFour += fees * FourFee / _totalFees;
519         tokensForLiquidity += fees * liqFee / _totalFees;
520             
521         if(fees > 0) {
522             _transferStandard(sender, address(this), fees);
523         }
524             
525         return amount -= fees;
526     }
527 
528     receive() external payable {}
529     
530     function manualswap() public onlyOwner() {
531         uint256 contractBalance = balanceOf(address(this));
532         swapTokensForEth(contractBalance);
533     }
534     
535     function manualsend() public onlyOwner() {
536         uint256 contractETHBalance = address(this).balance;
537         sendETHToFee(contractETHBalance);
538     }
539 
540     function withdrawStuckETH() external onlyOwner {
541         require(!tradingOpen, "Can only withdraw if trading hasn't started");
542         bool success;
543         (success,) = address(msg.sender).call{value: address(this).balance}("");
544     }
545 
546     function _getTotalFees(bool isSell) private view returns(uint256) {
547         if (isSell) {
548             return _sellFourFee + _sellLiquidityFee + _sellRewardFee;
549         }
550         return _buyFourFee + _buyLiquidityFee + _buyRewardFee;
551     }
552 }