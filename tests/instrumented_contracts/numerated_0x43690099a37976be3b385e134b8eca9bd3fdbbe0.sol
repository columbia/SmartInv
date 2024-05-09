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
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     address private _previousOwner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }  
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract RexInu is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _rOwned;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => bool) private bots;
117     mapping (address => uint) private cooldown;
118     uint256 private constant _tTotal = 1e10 * 10**9;
119     
120     uint256 private _buyProjectFee = 4;
121     uint256 private _previousBuyProjectFee = _buyProjectFee;
122     uint256 private _buyLiquidityFee = 5;
123     uint256 private _previousBuyLiquidityFee = _buyLiquidityFee;
124     uint256 private _buyRewardFee = 1;
125     uint256 private _previousBuyRewardFee = _buyRewardFee;
126     
127     uint256 private _sellProjectFee = 14;
128     uint256 private _previousSellProjectFee = _sellProjectFee;
129     uint256 private _sellLiquidityFee = 10;
130     uint256 private _previousSellLiquidityFee = _sellLiquidityFee;
131     uint256 private _sellRewardFee = 4;
132     uint256 private _previousSellRewardFee = _sellRewardFee;
133 
134     uint256 private tokensForReward;
135     uint256 private tokensForProject;
136     uint256 private tokensForLiquidity;
137 
138     address payable private _rewardWallet;
139     address payable private _projectWallet;
140     address payable private _liquidityWallet;
141     
142     string private constant _name = "Rex Inu";
143     string private constant _symbol = "REX";
144     uint8 private constant _decimals = 9;
145     
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private swapping;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152     bool private cooldownEnabled = false;
153     uint256 private tradingActiveBlock = 0; // 0 means trading is not active
154     uint256 private blocksToBlacklist = 10;
155     uint256 private _maxBuyAmount = _tTotal;
156     uint256 private _maxSellAmount = _tTotal;
157     uint256 private _maxWalletAmount = _tTotal;
158     uint256 private swapTokensAtAmount = 0;
159     
160     event MaxBuyAmountUpdated(uint _maxBuyAmount);
161     event MaxSellAmountUpdated(uint _maxSellAmount);
162     event SwapAndLiquify(
163         uint256 tokensSwapped,
164         uint256 ethReceived,
165         uint256 tokensIntoLiquidity
166     );
167     modifier lockTheSwap {
168         inSwap = true;
169         _;
170         inSwap = false;
171     }
172     constructor () {
173         _projectWallet = payable(0x95111BDB47E39Bc9AbBDB582a00aC789F33b089b);
174         _liquidityWallet = payable(address(0xdead));
175         _rewardWallet = payable(0x5BBe7aE322254Cc0e818212d6102829284A7916C);
176         _rOwned[_msgSender()] = _tTotal;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         _isExcludedFromFee[_projectWallet] = true;
180         _isExcludedFromFee[_liquidityWallet] = true;
181         _isExcludedFromFee[_rewardWallet] = true;
182         emit Transfer(address(0x433cAEaB78ba8B9F5ab6736A436A81C47A679244), _msgSender(), _tTotal);
183     }
184 
185     function name() public pure returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public pure returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public pure returns (uint8) {
194         return _decimals;
195     }
196 
197     function totalSupply() public pure override returns (uint256) {
198         return _tTotal;
199     }
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return _rOwned[account];
203     }
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount) public override returns (bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225     function setCooldownEnabled(bool onoff) external onlyOwner() {
226         cooldownEnabled = onoff;
227     }
228 
229     function setSwapEnabled(bool onoff) external onlyOwner(){
230         swapEnabled = onoff;
231     }
232 
233     function _approve(address owner, address spender, uint256 amount) private {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _transfer(address from, address to, uint256 amount) private {
241         require(from != address(0), "ERC20: transfer from the zero address");
242         require(to != address(0), "ERC20: transfer to the zero address");
243         require(amount > 0, "Transfer amount must be greater than zero");
244         bool takeFee = false;
245         bool shouldSwap = false;
246         if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
247             require(!bots[from] && !bots[to]);
248 
249             takeFee = true;
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
251                 require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxBuyAmount.");
252                 require(balanceOf(to) + amount <= _maxWalletAmount, "Exceeds maximum wallet token amount.");
253                 require(cooldown[to] < block.timestamp);
254                 cooldown[to] = block.timestamp + (30 seconds);
255             }
256             
257             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFee[from] && cooldownEnabled) {
258                 require(amount <= _maxSellAmount, "Transfer amount exceeds the maxSellAmount.");
259                 shouldSwap = true;
260             }
261         }
262 
263         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
264             takeFee = false;
265         }
266 
267         uint256 contractTokenBalance = balanceOf(address(this));
268         bool canSwap = (contractTokenBalance > swapTokensAtAmount) && shouldSwap;
269 
270         if (canSwap && swapEnabled && !swapping && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
271             swapping = true;
272             swapBack();
273             swapping = false;
274         }
275 
276         _tokenTransfer(from,to,amount,takeFee, shouldSwap);
277     }
278 
279     function swapBack() private {
280         uint256 contractBalance = balanceOf(address(this));
281         uint256 totalTokensToSwap = tokensForLiquidity + tokensForReward + tokensForProject;
282         bool success;
283         
284         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
285 
286         if(contractBalance > swapTokensAtAmount * 10) {
287             contractBalance = swapTokensAtAmount * 10;
288         }
289         
290         // Halve the amount of liquidity tokens
291         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
292         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
293         
294         uint256 initialETHBalance = address(this).balance;
295 
296         swapTokensForEth(amountToSwapForETH); 
297         
298         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
299         
300         uint256 ethForReward = ethBalance.mul(tokensForReward).div(totalTokensToSwap);
301         uint256 ethForProject = ethBalance.mul(tokensForProject).div(totalTokensToSwap);
302         
303         
304         uint256 ethForLiquidity = ethBalance - ethForReward - ethForProject;
305         
306         
307         tokensForLiquidity = 0;
308         tokensForReward = 0;
309         tokensForProject = 0;
310         
311         (success,) = address(_rewardWallet).call{value: ethForReward}("");
312         
313         if(liquidityTokens > 0 && ethForLiquidity > 0){
314             addLiquidity(liquidityTokens, ethForLiquidity);
315             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
316         }
317         
318         
319         (success,) = address(_projectWallet).call{value: address(this).balance}("");
320     }
321 
322     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
323         address[] memory path = new address[](2);
324         path[0] = address(this);
325         path[1] = uniswapV2Router.WETH();
326         _approve(address(this), address(uniswapV2Router), tokenAmount);
327         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
328             tokenAmount,
329             0,
330             path,
331             address(this),
332             block.timestamp
333         );
334     }
335 
336     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
337         _approve(address(this), address(uniswapV2Router), tokenAmount);
338         uniswapV2Router.addLiquidityETH{value: ethAmount}(
339             address(this),
340             tokenAmount,
341             0, // slippage is unavoidable
342             0, // slippage is unavoidable
343             _liquidityWallet,
344             block.timestamp
345         );
346     }
347         
348     function sendETHToFee(uint256 amount) private {
349         _projectWallet.transfer(amount);
350     }
351     
352     function openTrading() external onlyOwner() {
353         require(!tradingOpen,"trading is already open");
354         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
355         uniswapV2Router = _uniswapV2Router;
356         _approve(address(this), address(uniswapV2Router), _tTotal);
357         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
358         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
359         swapEnabled = true;
360         cooldownEnabled = true;
361         _maxBuyAmount = 5e7 * 10**9;
362         _maxSellAmount = 5e7 * 10**9;
363         _maxWalletAmount = 1e8 * 10**9;
364         swapTokensAtAmount = 5e6 * 10**9;
365         tradingOpen = true;
366         tradingActiveBlock = block.number;
367         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
368     }
369     
370     function setBots(address[] memory bots_) public onlyOwner {
371         for (uint i = 0; i < bots_.length; i++) {
372             bots[bots_[i]] = true;
373         }
374     }
375 
376     function setMaxBuyAmount(uint256 maxBuy) public onlyOwner {
377         _maxBuyAmount = maxBuy;
378     }
379 
380     function setMaxSellAmount(uint256 maxSell) public onlyOwner {
381         _maxSellAmount = maxSell;
382     }
383     
384     function setMaxWalletAmount(uint256 maxToken) public onlyOwner {
385         _maxWalletAmount = maxToken;
386     }
387     
388     function setSwapTokensAtAmount(uint256 newAmount) public onlyOwner {
389         require(newAmount >= 1e3 * 10**9, "Swap amount cannot be lower than 0.001% total supply.");
390         require(newAmount <= 5e6 * 10**9, "Swap amount cannot be higher than 0.5% total supply.");
391         swapTokensAtAmount = newAmount;
392     }
393 
394     function setProjectWallet(address projectWallet) public onlyOwner() {
395         require(projectWallet != address(0), "projectWallet address cannot be 0");
396         _isExcludedFromFee[_projectWallet] = false;
397         _projectWallet = payable(projectWallet);
398         _isExcludedFromFee[_projectWallet] = true;
399     }
400 
401     function setRewardWallet(address rewardWallet) public onlyOwner() {
402         require(rewardWallet != address(0), "rewardWallet address cannot be 0");
403         _isExcludedFromFee[_rewardWallet] = false;
404         _rewardWallet = payable(rewardWallet);
405         _isExcludedFromFee[_rewardWallet] = true;
406     }
407 
408     function setLiquidityWallet(address liquidityWallet) public onlyOwner() {
409         require(liquidityWallet != address(0), "liquidityWallet address cannot be 0");
410         _isExcludedFromFee[_liquidityWallet] = false;
411         _liquidityWallet = payable(liquidityWallet);
412         _isExcludedFromFee[_liquidityWallet] = true;
413     }
414 
415     function excludeFromFee(address account) public onlyOwner {
416         _isExcludedFromFee[account] = true;
417     }
418     
419     function includeInFee(address account) public onlyOwner {
420         _isExcludedFromFee[account] = false;
421     }
422 
423     function setBuyFee(uint256 buyProjectFee, uint256 buyLiquidityFee, uint256 buyRewardFee) external onlyOwner {
424         require(buyProjectFee + buyLiquidityFee + buyRewardFee <= 30, "Must keep buy taxes below 30%");
425         _buyProjectFee = buyProjectFee;
426         _buyLiquidityFee = buyLiquidityFee;
427         _buyRewardFee = buyRewardFee;
428     }
429 
430     function setSellFee(uint256 sellProjectFee, uint256 sellLiquidityFee, uint256 sellRewardFee) external onlyOwner {
431         require(sellProjectFee + sellLiquidityFee + sellRewardFee <= 60, "Must keep sell taxes below 60%");
432         _sellProjectFee = sellProjectFee;
433         _sellLiquidityFee = sellLiquidityFee;
434         _sellRewardFee = sellRewardFee;
435     }
436 
437     function setBlocksToBlacklist(uint256 blocks) public onlyOwner {
438         blocksToBlacklist = blocks;
439     }
440 
441     function removeAllFee() private {
442         if(_buyProjectFee == 0 && _buyLiquidityFee == 0 && _buyRewardFee == 0 && _sellProjectFee == 0 && _sellLiquidityFee == 0 && _sellRewardFee == 0) return;
443         
444         _previousBuyProjectFee = _buyProjectFee;
445         _previousBuyLiquidityFee = _buyLiquidityFee;
446         _previousBuyRewardFee = _buyRewardFee;
447         _previousSellProjectFee = _sellProjectFee;
448         _previousSellLiquidityFee = _sellLiquidityFee;
449         _previousSellRewardFee = _sellRewardFee;
450         
451         _buyProjectFee = 0;
452         _buyLiquidityFee = 0;
453         _buyRewardFee = 0;
454         _sellProjectFee = 0;
455         _sellLiquidityFee = 0;
456         _sellRewardFee = 0;
457     }
458     
459     function restoreAllFee() private {
460         _buyProjectFee = _previousBuyProjectFee;
461         _buyLiquidityFee = _previousBuyLiquidityFee;
462         _buyRewardFee = _previousBuyRewardFee;
463         _sellProjectFee = _previousSellProjectFee;
464         _sellLiquidityFee = _previousSellLiquidityFee;
465         _sellRewardFee = _previousSellRewardFee;
466     }
467     
468     function delBot(address notbot) public onlyOwner {
469         bots[notbot] = false;
470     }
471         
472     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool isSell) private {
473         if(!takeFee) {
474             removeAllFee();
475         } else {
476             amount = _takeFees(sender, amount, isSell);
477         }
478 
479         _transferStandard(sender, recipient, amount);
480         
481         if(!takeFee) {
482             restoreAllFee();
483         }
484     }
485 
486     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
487         _rOwned[sender] = _rOwned[sender].sub(tAmount);
488         _rOwned[recipient] = _rOwned[recipient].add(tAmount);
489         emit Transfer(sender, recipient, tAmount);
490     }
491 
492     function _takeFees(address sender, uint256 amount, bool isSell) private returns (uint256) {
493         uint256 _totalFees;
494         uint256 pjctFee;
495         uint256 liqFee;
496         uint256 rwrdFee;
497         if(tradingActiveBlock + blocksToBlacklist >= block.number){
498             _totalFees = 99;
499             liqFee = 92;
500         } else {
501             _totalFees = _getTotalFees(isSell);
502             if (isSell) {
503                 pjctFee = _sellProjectFee;
504                 liqFee = _sellLiquidityFee;
505                 rwrdFee = _sellRewardFee;
506             } else {
507                 pjctFee = _buyProjectFee;
508                 liqFee = _buyLiquidityFee;
509                 rwrdFee = _buyRewardFee;
510             }
511         }
512 
513         uint256 fees = amount.mul(_totalFees).div(100);
514         tokensForReward += fees * rwrdFee / _totalFees;
515         tokensForProject += fees * pjctFee / _totalFees;
516         tokensForLiquidity += fees * liqFee / _totalFees;
517             
518         if(fees > 0) {
519             _transferStandard(sender, address(this), fees);
520         }
521             
522         return amount -= fees;
523     }
524 
525     receive() external payable {}
526     
527     function manualswap() public onlyOwner() {
528         uint256 contractBalance = balanceOf(address(this));
529         swapTokensForEth(contractBalance);
530     }
531     
532     function manualsend() public onlyOwner() {
533         uint256 contractETHBalance = address(this).balance;
534         sendETHToFee(contractETHBalance);
535     }
536 
537     function withdrawStuckETH() external onlyOwner {
538         require(!tradingOpen, "Can only withdraw if trading hasn't started");
539         bool success;
540         (success,) = address(msg.sender).call{value: address(this).balance}("");
541     }
542 
543     function _getTotalFees(bool isSell) private view returns(uint256) {
544         if (isSell) {
545             return _sellProjectFee + _sellLiquidityFee + _sellRewardFee;
546         }
547         return _buyProjectFee + _buyLiquidityFee + _buyRewardFee;
548     }
549 }