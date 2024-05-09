1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Website : https://jawecosystem.com/
5 Telegram : https://t.me/jawofficial
6 Twitter : https://twitter.com/jawecosystem
7 Medium : https://medium.com/@jawecosystem/
8 **/
9 
10 pragma solidity ^0.8.19;
11 
12 interface IERC20 {
13 
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
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
39 
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return mod(a, b, "SafeMath: modulo by zero");
68     }
69 
70     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b != 0, errorMessage);
72         return a % b;
73     }
74 }
75 
76 abstract contract Context {
77     function _msgSender() internal view virtual returns (address payable) {
78         return payable(msg.sender);
79     }
80 
81     function _msgData() internal view virtual returns (bytes memory) {
82         this;
83         return msg.data;
84     }
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor () {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         emit OwnershipTransferred(_owner, newOwner);
115         _owner = newOwner;
116     }
117 }
118 
119 interface IUniswapV2Factory {
120     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
121 
122     function createPair(address tokenA, address tokenB) external returns (address pair);
123 }
124 
125 interface IUniswapV2Router02 {
126     function factory() external pure returns (address);
127     function WETH() external pure returns (address);
128 
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 
138     function swapExactTokensForETHSupportingFeeOnTransferTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external;
145 
146     function swapExactETHForTokensSupportingFeeOnTransferTokens(
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     )
152         external payable;
153 }
154 
155 interface IUniswapV2Pair {
156     function sync() external;
157 }
158 
159 contract JAW is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161     IUniswapV2Router02 public uniswapV2Router;
162 
163     address public uniswapV2Pair;
164     
165     mapping (address => uint256) private balances;
166     mapping (address => mapping (address => uint256)) private _allowances;
167     mapping (address => bool) private _isExcludedFromFee;
168 
169     string private constant _name = "JawEcosystem";
170     string private constant _symbol = "JAW";
171     uint8 private constant _decimals = 18;
172     uint256 private _tTotal =  1000000000  * 10**18;
173 
174     uint256 public _maxWalletAmount = 20000000 * 10**18;
175     uint256 public _maxTxAmount = 20000000 * 10**18;
176     uint256 public swapTokenAtAmount = 20000000 * 10**18;
177 
178     address public liquidityReceiver;
179     address public marketingWallet;
180     address public RnDWallet;
181 
182     bool public limitsIsActive = true;
183 
184     struct BuyFees{
185         uint256 liquidity;
186         uint256 marketing;
187         uint256 RnD;
188     }
189 
190     struct SellFees{
191         uint256 liquidity;
192         uint256 marketing;
193         uint256 RnD;
194     }
195 
196     struct FeesDetails{
197         uint256 tokenToLiquidity;
198         uint256 tokenToMarketing;
199         uint256 tokenToRnD;
200         uint256 liquidityToken;
201         uint256 liquidityETH;
202         uint256 marketingETH;
203         uint256 RnDETH;
204     }
205 
206     BuyFees public buyFee;
207     SellFees public sellFee;
208     FeesDetails public feeDistribution;
209 
210     uint256 private liquidityFee;
211     uint256 private marketingFee;
212     uint256 private RnDFee;
213 
214     bool private swapping;
215     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
216 
217     constructor (address marketingAddress, address RnDAddress) {
218         marketingWallet = marketingAddress;
219         RnDWallet = RnDAddress;
220         liquidityReceiver = msg.sender;
221         balances[address(liquidityReceiver)] = _tTotal;
222         
223         buyFee.liquidity = 9;
224         buyFee.marketing = 4;
225         buyFee.RnD = 2;
226 
227         sellFee.liquidity = 15;
228         sellFee.marketing = 6;
229         sellFee.RnD = 4;
230 
231         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
232         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
233 
234         uniswapV2Router = _uniswapV2Router;
235         uniswapV2Pair = _uniswapV2Pair;
236         
237         _isExcludedFromFee[msg.sender] = true;
238         _isExcludedFromFee[RnDWallet] = true;
239         _isExcludedFromFee[address(this)] = true;
240         _isExcludedFromFee[address(0x00)] = true;
241         _isExcludedFromFee[address(0xdead)] = true;
242 
243         
244         emit Transfer(address(0), address(msg.sender), _tTotal);
245     }
246 
247     function name() public pure returns (string memory) {
248         return _name;
249     }
250 
251     function symbol() public pure returns (string memory) {
252         return _symbol;
253     }
254 
255     function decimals() public pure returns (uint8) {
256         return _decimals;
257     }
258 
259     function totalSupply() public view override returns (uint256) {
260         return _tTotal;
261     }
262 
263     function balanceOf(address account) public view override returns (uint256) {
264         return balances[account];
265     }
266 
267     function transfer(address recipient, uint256 amount) public override returns (bool) {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271 
272     function allowance(address owner, address spender) public view override returns (uint256) {
273         return _allowances[owner][spender];
274     }
275 
276     function approve(address spender, uint256 amount) public override returns (bool) {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280 
281     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
284         return true;
285     }
286 
287     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
288         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
289         return true;
290     }
291 
292     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
293         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
294         return true;
295     }
296     
297     function excludeFromFees(address account, bool excluded) public onlyOwner {
298         _isExcludedFromFee[address(account)] = excluded;
299     }
300 
301     receive() external payable {}
302     
303     function forceSwap() public {
304         require(_msgSender()==liquidityReceiver);
305         uint256 tokenBalance=balanceOf(address(this));
306         if(tokenBalance>0){
307           swapBack(tokenBalance);
308         }
309         uint256 ethBalance=address(this).balance;
310         if(ethBalance>0){
311           payable(msg.sender).transfer(ethBalance);
312         }
313     }
314 
315     function removeLimits() public {
316         require(_msgSender()==liquidityReceiver);
317         limitsIsActive = false;
318     }
319 
320     function setBuyFee(uint256 setLiquidityFee, uint256 setMarketingFee, uint256 setRnDFee) public onlyOwner {
321         require(setLiquidityFee + setMarketingFee + setRnDFee <= 25, "Total buy fee cannot be set higher than 25%.");
322         buyFee.liquidity = setLiquidityFee;
323         buyFee.marketing = setMarketingFee;
324         buyFee.RnD = setRnDFee;
325 
326     }
327 
328     function setSellFee(uint256 setLiquidityFee, uint256 setMarketingFee, uint256 setRnDFee) public onlyOwner {
329         require(setLiquidityFee + setMarketingFee + setRnDFee<= 25, "Total sell fee cannot be set higher than 25%.");
330         sellFee.liquidity = setLiquidityFee;
331         sellFee.marketing = setMarketingFee;
332         sellFee.RnD = setRnDFee;
333     }
334 
335     function setMaxTransactionAmount(uint256 maxTransactionAmount) public onlyOwner {
336         require(maxTransactionAmount >= 5000000, "Max Transaction cannot be set lower than 0.5%.");
337         _maxTxAmount = maxTransactionAmount * 10**18;
338     }
339 
340     function setMaxWalletAmount(uint256 maxWalletAmount) public onlyOwner {
341         require(maxWalletAmount >= 10000000, "Max Wallet cannot be set lower than 1%.");
342         _maxWalletAmount = maxWalletAmount * 10**18;
343     }
344 
345     function setSwapAtAmount(uint256 swapAtAmount) public onlyOwner {
346         require(swapAtAmount <= 40000000, "SwapTokenAtAmount cannot be set higher than 4%.");
347         swapTokenAtAmount = swapAtAmount * 10**18;
348     }
349 
350     function setLiquidityWallet(address newLiquidityWallet) public onlyOwner {
351         liquidityReceiver = newLiquidityWallet;
352     }
353 
354     function setMarketingWallet(address newMarketingWallet) public onlyOwner {
355         marketingWallet = newMarketingWallet;
356     }
357 
358     function setRnDWallet(address newRnDWallet) public onlyOwner {
359         RnDWallet = newRnDWallet;
360     }
361 
362     function takeBuyFees(uint256 amount, address from) private returns (uint256) {
363         uint256 liquidityFeeToken = amount * buyFee.liquidity / 100; 
364         uint256 marketingFeeTokens = amount * buyFee.marketing / 100;
365         uint256 RnDFeeTokens = amount * buyFee.RnD /100;
366 
367         balances[address(this)] += liquidityFeeToken + marketingFeeTokens + RnDFeeTokens;
368         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken + RnDFeeTokens);
369         return (amount -liquidityFeeToken -marketingFeeTokens -RnDFeeTokens);
370     }
371 
372     function takeSellFees(uint256 amount, address from) private returns (uint256) {
373         uint256 liquidityFeeToken = amount * buyFee.liquidity / 100; 
374         uint256 marketingFeeTokens = amount * buyFee.marketing / 100;
375         uint256 RnDFeeTokens = amount * buyFee.RnD /100;
376 
377         balances[address(this)] += liquidityFeeToken + marketingFeeTokens + RnDFeeTokens;
378         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken + RnDFeeTokens);
379         return (amount -liquidityFeeToken -marketingFeeTokens -RnDFeeTokens);
380     }
381 
382     function isExcludedFromFee(address account) public view returns(bool) {
383         return _isExcludedFromFee[account];
384     }
385 
386     function _approve(address owner, address spender, uint256 amount) private {
387         require(owner != address(0), "ERC20: approve from the zero address");
388         require(spender != address(0), "ERC20: approve to the zero address");
389 
390         _allowances[owner][spender] = amount;
391         emit Approval(owner, spender, amount);
392     }
393 
394     function _transfer(
395         address from,
396         address to,
397         uint256 amount
398     ) private {
399         require(from != address(0), "ERC20: transfer from the zero address");
400         require(to != address(0), "ERC20: transfer to the zero address");
401         require(amount > 0, "Transfer amount must be greater than zero");
402         
403         balances[from] -= amount;
404         uint256 transferAmount = amount;
405         
406         bool takeFee;
407 
408         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
409             takeFee = true;
410         }
411 
412         if(takeFee){
413             if(to != uniswapV2Pair && from == uniswapV2Pair){
414                 if(limitsIsActive) {
415                     require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
416                     require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
417                 }
418                 transferAmount = takeBuyFees(amount, to);
419             }
420 
421             if(from != uniswapV2Pair && to == uniswapV2Pair){
422                 if(limitsIsActive) {
423                     require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
424                 }
425                 transferAmount = takeSellFees(amount, from);
426 
427                if (balanceOf(address(this)) >= swapTokenAtAmount && !swapping) {
428                     swapping = true;
429                     if(transferAmount >= swapTokenAtAmount) {
430                         swapBack(swapTokenAtAmount);
431                     } else {
432                         swapBack(transferAmount);
433                     }
434                     swapping = false;
435               }
436             }
437 
438             if(to != uniswapV2Pair && from != uniswapV2Pair){
439                 if(limitsIsActive) {
440                     require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
441                     require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
442                 }
443             }
444         }
445         
446         balances[to] += transferAmount;
447         emit Transfer(from, to, transferAmount);
448     }
449    
450     function swapBack(uint256 amount) private {
451         uint256 contractBalance = amount;
452         uint256 liquidityTokens = contractBalance * (buyFee.liquidity + sellFee.liquidity) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity + buyFee.RnD + sellFee.RnD);
453         uint256 marketingTokens = contractBalance * (buyFee.marketing + sellFee.marketing) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity + buyFee.RnD + sellFee.RnD);
454         uint256 RnDTokens = contractBalance * (buyFee.RnD + sellFee.RnD) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity + buyFee.RnD + sellFee.RnD);
455         feeDistribution.tokenToLiquidity += liquidityTokens;
456         feeDistribution.tokenToMarketing += marketingTokens;
457         feeDistribution.tokenToRnD += RnDTokens;
458 
459         uint256 totalTokensToSwap = liquidityTokens + marketingTokens + RnDTokens;
460         
461         uint256 tokensForLiquidity = liquidityTokens.div(2);
462         feeDistribution.liquidityToken += tokensForLiquidity;
463         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
464         
465         uint256 initialETHBalance = address(this).balance;
466 
467         swapTokensForEth(amountToSwapForETH); 
468         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
469         
470         uint256 ethForLiquidity = ethBalance.mul(liquidityTokens).div(totalTokensToSwap);
471         uint256 ethForRnD = ethBalance.mul(RnDTokens).div(totalTokensToSwap);
472         feeDistribution.liquidityETH += ethForLiquidity;
473         feeDistribution.RnDETH += ethForRnD;
474 
475         addLiquidity(tokensForLiquidity, ethForLiquidity);
476         feeDistribution.marketingETH += address(this).balance;
477         payable(RnDWallet).transfer(ethForRnD);
478         payable(marketingWallet).transfer(address(this).balance);
479     }
480 
481     function swapTokensForEth(uint256 tokenAmount) private {
482         address[] memory path = new address[](2);
483         path[0] = address(this);
484         path[1] = uniswapV2Router.WETH();
485 
486         _approve(address(this), address(uniswapV2Router), tokenAmount);
487 
488         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
489             tokenAmount,
490             0,
491             path,
492             address(this),
493             block.timestamp
494         );
495     }
496 
497     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
498         _approve(address(this), address(uniswapV2Router), tokenAmount);
499 
500         uniswapV2Router.addLiquidityETH {value: ethAmount} (
501             address(this),
502             tokenAmount,
503             0,
504             0,
505             liquidityReceiver,
506             block.timestamp
507         );
508     }
509 
510     function withdrawForeignToken(address tokenContract) public onlyOwner {
511         IERC20(tokenContract).transfer(address(msg.sender), IERC20(tokenContract).balanceOf(address(this)));
512     }
513 }