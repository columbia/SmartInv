1 /**
2 
3 Website: https://www.ttfbot.io/
4 
5 Twitter: https://twitter.com/TTFBot
6 
7 Telegram: https://t.me/TTFBotOfficial
8 
9 */
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.19;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39     function name() external view returns (string memory);
40     function symbol() external view returns (string memory);
41     function decimals() external view returns (uint8);
42 }
43 
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     constructor() {
50         _setOwner(_msgSender());
51     }
52 
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(owner() == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         _setOwner(address(0));
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         _setOwner(newOwner);
69     }
70 
71     function _setOwner(address newOwner) private {
72         address oldOwner = _owner;
73         _owner = newOwner;
74         emit OwnershipTransferred(oldOwner, newOwner);
75     }
76 }
77 
78 interface IUniswapV2Router02 {
79     function factory() external pure returns (address);
80     function WETH() external pure returns (address);
81 
82     function addLiquidityETH(
83         address token,
84         uint amountTokenDesired,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline
89     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
90 
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98 }
99 
100 interface IUniswapV2Factory {
101     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
102 
103     function feeTo() external view returns (address);
104     function feeToSetter() external view returns (address);
105 
106     function getPair(address tokenA, address tokenB) external view returns (address pair);
107     function allPairs(uint) external view returns (address pair);
108     function allPairsLength() external view returns (uint);
109 
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 
112     function setFeeTo(address) external;
113     function setFeeToSetter(address) external;
114 }
115 
116 contract TTF is IERC20Metadata, Ownable {
117     mapping(address => uint256) private _tOwned;
118     mapping(address => mapping(address => uint256)) private _allowances;
119     mapping(address => bool) public isExcludedFromFee;
120     mapping(address => bool) public isExcludedFromMaxWalletToken;
121 
122     address payable public marketingWallet;
123     address payable public devWallet;
124     address payable public constant burnWallet = payable(0x000000000000000000000000000000000000dEaD);
125     address payable public lpWallet;
126 
127     uint8 private constant _decimals = 9;
128     uint256 private _tTotal = 10**8 * 10**_decimals;
129     string private constant _name = "TTF";
130     string private constant _symbol = "TTF";
131 
132     uint256 public swapMinTokens = 10**4 * 10**_decimals;
133 
134     uint256 public buyTax = 5;
135     uint256 public sellTax = 20;
136     uint256 public maxTransactionTax = 5;
137 
138     uint256 public marketingPct = 40;
139     uint256 public devPct = 40;
140     uint256 public lpPct = 20;
141     uint256 public maxPct = 100;
142 
143     uint256 public maxWalletSize = (_tTotal * 2) / maxPct;
144 
145     IUniswapV2Router02 public _uniswapV2Router;
146     address public uniswapV2Pair;
147     bool public inSwapAndLiquify;
148 
149     event SwapAndLiquify(
150         uint256 tokensSwapped,
151         uint256 ethReceived,
152         uint256 tokensIntoLiqudity
153     );
154 
155     event UpdateLpWallet(address newLp_, address oldLpWallet);
156     event UpdatedBuySellTaxes(uint256 buyTax, uint256 sellTax);
157     event UpdatedPercentTaxes(uint256 marketing, uint256 dev, uint256 lp);
158     event UpdatedIsExcludedFromFee(address account, bool flag);
159     event UpdatedIsExcludedFromMaxWallet(address account, bool flag);
160     event UpdatedMarketingAndDevWallet(address marketing, address dev);
161 
162     modifier lockTheSwap() {
163         inSwapAndLiquify = true;
164         _;
165         inSwapAndLiquify = false;
166     }
167 
168     constructor(address uniswapRouterAddress, address marketing, address dev, address lpWalletAddress) {
169         _tOwned[owner()] = _tTotal;
170 
171         _uniswapV2Router = IUniswapV2Router02(uniswapRouterAddress);
172         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
173             .createPair(address(this), _uniswapV2Router.WETH());
174 
175         marketingWallet = payable(marketing);
176         devWallet = payable(dev);
177         lpWallet = payable(lpWalletAddress);
178 
179         isExcludedFromFee[owner()] = true;
180         isExcludedFromFee[address(this)] = true;
181         isExcludedFromFee[marketingWallet] = true;
182         isExcludedFromFee[devWallet] = true;
183         isExcludedFromFee[burnWallet] = true;
184         isExcludedFromFee[lpWallet] = true;
185         isExcludedFromFee[uniswapRouterAddress] = true;
186 
187         isExcludedFromMaxWalletToken[uniswapRouterAddress] = true;
188         isExcludedFromMaxWalletToken[owner()] = true;
189         isExcludedFromMaxWalletToken[address(this)] = true;
190         isExcludedFromMaxWalletToken[marketingWallet] = true;
191         isExcludedFromMaxWalletToken[devWallet] = true;
192         isExcludedFromMaxWalletToken[burnWallet] = true;
193         isExcludedFromMaxWalletToken[lpWallet] = true;
194         isExcludedFromMaxWalletToken[uniswapV2Pair] = true;
195 
196         emit Transfer(address(0), owner(), _tTotal);
197     }
198 
199     function name() public pure returns (string memory) {
200         return _name;
201     }
202 
203     function symbol() public pure returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public pure returns (uint8) {
208         return _decimals;
209     }
210 
211     function totalSupply() public view override returns (uint256) {
212         return _tTotal;
213     }
214 
215     function balanceOf(address account) public view override returns (uint256) {
216         return _tOwned[account];
217     }
218 
219     function transfer(address recipient, uint256 amount)
220         public
221         override
222         returns (bool)
223     {
224         _transfer(_msgSender(), recipient, amount);
225         return true;
226     }
227 
228     function allowance(address theOwner, address theSpender)
229         public
230         view
231         override
232         returns (uint256)
233     {
234         return _allowances[theOwner][theSpender];
235     }
236 
237     function approve(address spender, uint256 amount)
238         public
239         override
240         returns (bool)
241     {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     function transferFrom(
247         address sender,
248         address recipient,
249         uint256 amount
250     ) public override returns (bool) {
251         _transfer(sender, recipient, amount);
252         _approve(
253             sender,
254             _msgSender(),
255             _allowances[sender][_msgSender()] - amount
256         );
257         return true;
258     }
259 
260     function increaseAllowance(address spender, uint256 addedValue)
261         public
262         virtual
263         returns (bool)
264     {
265         _approve(
266             _msgSender(),
267             spender,
268             _allowances[_msgSender()][spender] + addedValue
269         );
270         return true;
271     }
272 
273     function decreaseAllowance(address spender, uint256 subtractedValue)
274         public
275         virtual
276         returns (bool)
277     {
278         _approve(
279             _msgSender(),
280             spender,
281             _allowances[_msgSender()][spender] - subtractedValue
282         );
283         return true;
284     }
285 
286     receive() external payable {}
287 
288     function _approve(
289         address theOwner,
290         address theSpender,
291         uint256 amount
292     ) private {
293         require(
294             theOwner != address(0) && theSpender != address(0),
295             "Zero address."
296         );
297         _allowances[theOwner][theSpender] = amount;
298         emit Approval(theOwner, theSpender, amount);
299     }
300 
301     function setLpWallet(address newLp_) external onlyOwner {
302         require(newLp_ != address(0), "TTF::Lp wallet cannot be zero address");
303 
304         address oldLpWallet = lpWallet;
305         lpWallet = payable(newLp_);
306 
307         emit UpdateLpWallet(newLp_, oldLpWallet);
308     }
309 
310     function setTax(
311         uint256 buy,
312         uint256 sell
313     ) public onlyOwner {
314         require(buy <= maxTransactionTax, "Buy tax cannot exceed the maximum.");
315         require(sell <= maxTransactionTax, "Sell tax cannot exceed the maximum.");
316 
317         buyTax = buy;
318         sellTax = sell;
319 
320         emit UpdatedBuySellTaxes(buy, sell);
321     }
322 
323     function setPercentTax(
324         uint256 marketing,
325         uint256 dev,
326         uint256 lp
327     ) public onlyOwner {
328         require(marketing + dev + lp == maxPct, "The sum of percentages must equal 100.");
329         marketingPct = marketing;
330         devPct = dev;
331         lpPct = lp;
332 
333         emit UpdatedPercentTaxes(marketing, dev,lp);
334     }
335     function excludeFromFee(address account) external onlyOwner {
336         isExcludedFromFee[account] = true;
337 
338         emit UpdatedIsExcludedFromFee(account, true);
339     }
340 
341     function includeInFee(address account) external onlyOwner {
342         isExcludedFromFee[account] = false;
343 
344         emit UpdatedIsExcludedFromFee(account, false);
345     }
346 
347 	function excludeMaxWallet(address account) external onlyOwner {
348         isExcludedFromMaxWalletToken[account] = true;
349         emit UpdatedIsExcludedFromMaxWallet(account, true);
350     }
351 
352     function includeMaxWallet(address account) external onlyOwner {
353         isExcludedFromMaxWalletToken[account] = false;
354         emit UpdatedIsExcludedFromMaxWallet(account, false);
355     }
356 
357     function setWallets(
358         address marketing,
359         address dev
360     ) public onlyOwner {
361         require(marketing != address(0) && dev != address(0), "Invalid wallet addresses.");
362         isExcludedFromFee[marketingWallet] = false;
363         isExcludedFromFee[devWallet] = false;
364 
365         marketingWallet = payable(marketing);
366         devWallet = payable(dev);
367 
368         isExcludedFromFee[marketing] = true;
369         isExcludedFromFee[dev] = true;
370 
371         emit UpdatedMarketingAndDevWallet(marketing, dev);
372     }
373 
374     function _transfer(
375         address from,
376         address to,
377         uint256 amount
378     ) private {
379         if (!isExcludedFromMaxWalletToken[to]) {
380             uint256 heldTokens = balanceOf(to);
381             require(
382                 (heldTokens + amount) <= maxWalletSize,
383                 "Over wallet limit."
384             );
385         }
386 
387         require(
388             from != address(0) && to != address(0),
389             "Using 0 address!"
390         );
391 
392         require(amount > 0, "Token value must be higher than zero.");
393 
394         if (
395             balanceOf(address(this)) >= swapMinTokens &&
396             !inSwapAndLiquify &&
397             from != uniswapV2Pair
398         ) {
399             swapAndDistributeTaxes();
400         }
401 
402         _tokenTransfer(from, to, amount);
403     }
404 
405    function multipleAirdrop(
406         address[] memory _address,
407         uint256[] memory _amount
408     ) external onlyOwner {
409         require(_address.length == _amount.length, "Arrays length mismatch");
410         uint256 totalAmount = 0;
411         for (uint256 i = 0; i < _amount.length; i++) {
412             totalAmount += _amount[i];
413         }
414         require(balanceOf(msg.sender) >= totalAmount * 10**decimals(), "Insufficient balance");
415 
416         for (uint256 i = 0; i < _amount.length; i++) {
417             address adr = _address[i];
418             uint256 amnt = _amount[i] * 10**decimals();
419             _transfer(msg.sender, adr, amnt);
420         }
421     }
422 
423     function _sendToWallet(address payable wallet, uint256 amount) private {
424         wallet.transfer(amount);
425     }
426 
427     function setSwapMinTokens(uint256 minTokens) external onlyOwner {
428         swapMinTokens = minTokens * 10**decimals();
429         require(swapMinTokens < totalSupply(), "Min tokens for swap is too high.");
430     }
431 
432     function swapAndDistributeTaxes() private lockTheSwap {
433         uint256 contractTokenBalance = balanceOf(address(this));
434         uint256 marketingTokensShare = (contractTokenBalance * marketingPct) / maxPct;
435         uint256 devTokensShare = (contractTokenBalance * devPct) / maxPct;
436         uint256 lpTokensHalfShare = (contractTokenBalance * lpPct) / (2 * maxPct);
437 
438         uint256 bnbBalanceBeforeSwap = address(this).balance;
439         swapTokensForBNB(lpTokensHalfShare + marketingTokensShare + devTokensShare);
440         uint256 bnbReceived = address(this).balance - bnbBalanceBeforeSwap;
441 
442         uint256 marketingSplit = (marketingPct * maxPct) / (lpPct + marketingPct + devPct);
443         uint256 bnbToMarketing = (bnbReceived * marketingSplit) / maxPct;
444 
445         uint256 devSplit = (devPct * maxPct) / (lpPct + marketingPct + devPct);
446         uint256 bnbToDev = (bnbReceived * devSplit) / maxPct;
447 
448         addLiquidity(lpTokensHalfShare, (bnbReceived - bnbToMarketing - bnbToDev));
449         emit SwapAndLiquify(
450             lpTokensHalfShare,
451             (bnbReceived - bnbToMarketing - bnbToDev),
452             lpTokensHalfShare
453         );
454 
455         _sendToWallet(marketingWallet, bnbToMarketing);
456         _sendToWallet(devWallet, address(this).balance);
457     }
458 
459     function swapTokensForBNB(uint256 tokenAmount) private {
460         address[] memory path = new address[](2);
461         path[0] = address(this);
462         path[1] = _uniswapV2Router.WETH();
463         _approve(address(this), address(_uniswapV2Router), tokenAmount);
464         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
465             tokenAmount,
466             0,
467             path,
468             address(this),
469             block.timestamp
470         );
471     }
472 
473     function addLiquidity(uint256 tokenAmount, uint256 BNBAmount) private {
474         _approve(address(this), address(_uniswapV2Router), tokenAmount);
475         _uniswapV2Router.addLiquidityETH{value: BNBAmount}(
476             address(this),
477             tokenAmount,
478             0,
479             0,
480             lpWallet, // Add liquidity to lp wallet
481             block.timestamp
482         );
483     }
484 
485     function withdraw() external onlyOwner {
486         uint256 contractBalance = address(this).balance;
487         require(contractBalance > 0, "TTF::Contract balance is empty");
488 
489         (bool status, ) = payable(owner()).call{value: contractBalance}("");
490 
491         require(status, "TTF::Failed to send contract balance");
492     }
493 
494     function removeStuckTokens (
495         address tokenAddress,
496         uint256 pctOfTokens
497     ) public returns (bool _sent) {
498         require(
499             tokenAddress != address(this),
500             "Can not remove native token."
501         );
502         require(pctOfTokens <= 100, "Percentage must be less than or equal to 100.");
503         uint256 totalRandom = IERC20(tokenAddress).balanceOf(address(this));
504         uint256 removeRandom = (totalRandom * pctOfTokens) / maxPct;
505         _sent = IERC20(tokenAddress).transfer(devWallet, removeRandom);
506     }
507 
508     function _tokenTransfer(
509         address from,
510         address to,
511         uint256 tAmount
512     ) private {
513         bool isBuy = (from == uniswapV2Pair);
514         bool isSell = (to == uniswapV2Pair);
515         bool isBuyOrSell = isBuy || isSell;
516         bool takeFee = isBuyOrSell && !(isExcludedFromFee[from] || isExcludedFromFee[to]);
517 
518         uint256 fee = !takeFee
519             ? 0
520             : isBuy
521                 ? (tAmount * buyTax) / maxPct
522                 : (tAmount * sellTax) / maxPct;
523         uint256 tTransferAmount = tAmount - fee;
524 
525         _tOwned[from] = _tOwned[from] - tAmount;
526         _tOwned[to] = _tOwned[to] + tTransferAmount;
527         _tOwned[address(this)] = _tOwned[address(this)] + fee;
528         emit Transfer(from, to, tTransferAmount);
529         if (to == burnWallet) _tTotal = _tTotal - tTransferAmount;
530     }
531 }