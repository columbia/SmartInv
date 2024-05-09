1 // SPDX-License-Identifier: MIT
2 
3 //  ____ _______  ___________    _________              _____  .___ 
4 // |    |   \   \/  /\_      \  /   _____/             /  _  \ |   |
5 // |    |   /\     /  /   |   \ \_____  \    ______   /  /_\  \|   |
6 // |    |  / /     \ /    |    \/        \  /_____/  /    |    \   |
7 // |______/ /___/\  \\_______  /_______  /           \____|__  /___|
8 //                \_/        \/        \/                    \/     
9 // 
10 // 
11 // $UXOS is a multi-tier ecosystem driven token that is heavily utility based.
12 // It's utilities comprise of cutting edge AI integrated marketing bots.
13 // Our AI accounts are based across multiple social media platforms.
14 // These AI accounts are capable of targeting a specific demographic of investor, to
15 // yield the best results for the project and build a solid, organic community without
16 // lifting a finger. All whilst acting like a human. 
17 // We are creating an unstopable force.. influencial beyond anything ever seen before..
18 //
19 // Think of the worlds biggest shilling army. All automated. Never sleeping, never taking
20 // a break.. Never stopping.. We're building it. (and it works).
21 //
22 // www.uxos-ai.com
23 //
24 // t.me/UXOStoken
25 //
26 // The future is now.
27 
28 pragma solidity 0.8.13;
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function decimals() external view returns (uint8);
33     function symbol() external view returns (string memory);
34     function name() external view returns (string memory);
35     function getOwner() external view returns (address);
36     function balanceOf(address account) external view returns (uint256);
37     function transfer(address recipient, uint256 amount) external returns (bool);
38     function allowance(address _owner, address spender) external view returns (uint256);
39     function approve(address spender, uint256 amount) external returns (bool);
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 
55 
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor() {
62         _transferOwnership(_msgSender());
63     }
64 
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     function _checkOwner() internal view virtual {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 
95 interface IDEXFactory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 
100 interface IDEXRouter {
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103 
104     function addLiquidity(
105         address tokenA,
106         address tokenB,
107         uint amountADesired,
108         uint amountBDesired,
109         uint amountAMin,
110         uint amountBMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountA, uint amountB, uint liquidity);
114 
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 
124     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131 
132     function swapExactETHForTokensSupportingFeeOnTransferTokens(
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external payable;
138 
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146 }
147 
148 
149 contract UXOS is IERC20, Ownable {
150 
151     address private WETH;
152 
153     string private constant _name = "UXOS AI";
154     string private constant _symbol = "UXOS";
155     uint8 private constant _decimals = 9;
156     
157     uint256 _totalSupply = 1 * 10**9 * (10 ** _decimals);
158     uint256 maxWallet = _totalSupply / 50; // 2%
159     uint256 maxTransaction = _totalSupply / 100; // 1%
160     uint256 public swapThreshold = _totalSupply / 1000; // Starting at 0.1%
161 
162     uint256 public maxBuy = _totalSupply / 200; // 0.5%
163     bool public maxBuyEnabled = true;
164 
165     mapping (address => uint256) private _balances;
166     mapping (address => mapping(address => uint256)) private _allowances;
167     mapping (address => bool) public isFeeExempt;
168     mapping (address => bool) public isWalletExempt;
169     mapping (address => bool) public isTxExempt;
170 
171     address DEAD = 0x000000000000000000000000000000000000dEaD;
172     address ZERO = 0x0000000000000000000000000000000000000000;
173 
174     uint[3] taxesCollected = [0, 0, 0];
175 
176     uint256 public launchedAt;
177     address public liquidityPool = DEAD;
178 
179     // All fees are in basis points (100 = 1%)
180     uint256 private buyMkt = 200;
181     uint256 private sellMkt = 200;
182     uint256 private buyLP = 200;
183     uint256 private sellLP = 200;
184     uint256 private buyDev = 100;
185     uint256 private sellDev = 100;
186 
187     uint256 _baseBuyFee = buyMkt + buyLP + buyDev;
188     uint256 _baseSellFee = sellMkt + sellLP + sellDev;
189 
190     IDEXRouter public router;
191     address public pair;
192     address public factory;
193     address public marketingWallet = payable(0x01859e5D0541Ca170E0Ff80EF8EdaE633528BA9f);
194     address public devWallet = payable(0xDc0bd2dA5CACBd2d8622378bA4fAe1ACC210E290);
195 
196     bool inSwapAndLiquify;
197     bool public swapAndLiquifyEnabled = true;
198     bool public tradingOpen = false;
199 
200     modifier lockTheSwap {
201         inSwapAndLiquify = true;
202         _;
203         inSwapAndLiquify = false;
204     }
205 
206     constructor() {
207         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
208             
209         WETH = router.WETH();
210         
211         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
212         
213         _allowances[address(this)][address(router)] = type(uint256).max;
214 
215         isFeeExempt[owner()] = true;
216         isFeeExempt[marketingWallet] = true;
217         isFeeExempt[address(this)] = true;
218         isWalletExempt[owner()] = true;
219         isWalletExempt[marketingWallet] = true;
220         isWalletExempt[DEAD] = true;
221         isTxExempt[owner()] = true;
222         isTxExempt[marketingWallet] = true;
223         isTxExempt[DEAD] = true;
224 
225         _balances[owner()] = _totalSupply;
226     
227         emit Transfer(address(0), owner(), _totalSupply);
228     }
229 
230     receive() external payable { }
231 
232     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
233         isFeeExempt[holder] = exempt;
234     }
235 
236     function changeIsWalletExempt(address holder, bool exempt) external onlyOwner {
237         isWalletExempt[holder] = exempt;
238     }
239 
240     function changeIsTxExempt(address holder, bool exempt) external onlyOwner {
241         isTxExempt[holder] = exempt;
242     }
243 
244     function launchSequence(uint hold) external onlyOwner {
245 	    require(launchedAt == 0, "Already launched");
246         launchedAt = block.number + hold;
247         tradingOpen = true;
248     }
249 
250     function toggleTrade(bool _switch) external onlyOwner {
251 	    tradingOpen = _switch;
252     }
253 
254     function toggleMaxBuy(bool _switch) external onlyOwner {
255 	    maxBuyEnabled = _switch;
256     }
257 
258     function changeMaxBuyAmount(uint _amt) external onlyOwner {
259 	    require(_amt >= (_totalSupply / 200), "Must be at least 0.5%");
260 	    maxBuy = _amt;
261     }
262 
263     function changeMaxWallet(uint _amt) external onlyOwner {
264         require(_amt >= (_totalSupply / 50), "Must be at least 2%");
265         maxWallet = _amt;
266     }
267 
268     function changeMaxTransaction(uint _amt) external onlyOwner {
269         require(_amt >= (_totalSupply / 100), "Must be at least 1%");
270         maxTransaction = _amt;
271     }
272 
273     function setMarketingWallet(address payable newMarketingWallet) external onlyOwner {
274         marketingWallet = payable(newMarketingWallet);
275     }
276 
277     function setDevWallet(address payable newDevWallet) external onlyOwner {
278 	    devWallet = payable(newDevWallet);
279     }
280 
281     function setLiquidityPool(address newLiquidityPool) external onlyOwner {
282         liquidityPool = newLiquidityPool;
283     }
284 
285     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
286         swapAndLiquifyEnabled  = enableSwapBack;
287         swapThreshold = newSwapBackLimit;
288     }
289 
290     function getCirculatingSupply() public view returns (uint256) {
291         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
292     }
293 
294     function totalSupply() external view override returns (uint256) { return _totalSupply; }
295     function decimals() external pure override returns (uint8) { return _decimals; }
296     function symbol() external pure override returns (string memory) { return _symbol; }
297     function name() external pure override returns (string memory) { return _name; }
298     function getOwner() external view override returns (address) { return owner(); }
299     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
300     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
301     function baseBuyFee() external view returns (uint256) {return _baseBuyFee; }
302     function baseSellFee() external view returns (uint256) {return _baseSellFee; }
303 
304     function approve(address spender, uint256 amount) public override returns (bool) {
305         _allowances[msg.sender][spender] = amount;
306         emit Approval(msg.sender, spender, amount);
307         return true;
308     }
309 
310     function approveMax(address spender) external returns (bool) {
311         return approve(spender, type(uint256).max);
312     }
313 
314     function addTaxCollected(uint mkt, uint lp, uint dev) internal {
315         taxesCollected[0] += mkt;
316         taxesCollected[1] += lp;
317 	    taxesCollected[2] += dev;
318     }
319 
320     function transfer(address recipient, uint256 amount) external override returns (bool) {
321         return _transfer(msg.sender, recipient, amount);
322     }
323 
324     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
325         if(_allowances[sender][msg.sender] != type(uint256).max){
326             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
327         }
328 
329         return _transfer(sender, recipient, amount);
330     }
331 
332     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
333         require(sender != address(0), "BEP20: transfer from the zero address");
334         require(recipient != address(0), "BEP20: transfer to the zero address");
335         require(amount > 0, "Transfer amount must be greater than zero");
336         require(amount < maxTransaction || isTxExempt[sender], "Exceeds Transaction Limit");
337 
338         if(recipient != pair) {
339             uint256 recipientBalance = _balances[recipient];
340             require(recipientBalance + amount < maxWallet || isWalletExempt[recipient]);
341         }
342 
343 	    if(sender == pair && maxBuyEnabled) { require(amount <= maxBuy || isTxExempt[recipient], "Exceeds Max Buy"); }
344         if(sender != owner() && recipient != owner()) { require(tradingOpen || isFeeExempt[sender], "Trading not active"); }
345         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
346     	if(sender != pair && recipient != pair) { return _basicTransfer(sender, recipient, amount); }
347         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
348     	if(sender == pair && block.number < launchedAt) { recipient = DEAD; }
349 
350         _balances[sender] = _balances[sender] - amount;
351         
352         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
353 
354         _balances[recipient] = _balances[recipient] + finalAmount;
355 
356         emit Transfer(sender, recipient, finalAmount);
357         return true;
358     }  
359 
360     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
361         
362         uint256 mktTaxB = amount * buyMkt / 10000;
363 	    uint256 mktTaxS = amount * sellMkt / 10000;
364         uint256 lpTaxB = amount * buyLP / 10000;
365 	    uint256 lpTaxS = amount * sellLP / 10000;
366 	    uint256 devB = amount * buyDev / 10000;
367 	    uint256 devS = amount * sellDev / 10000;
368         uint256 taxToGet;
369 
370 	    if(sender == pair && recipient != address(pair) && !isFeeExempt[recipient]) {
371             taxToGet = mktTaxB + lpTaxB + devB;
372 	        addTaxCollected(mktTaxB, lpTaxB, devB);
373 	    }
374 
375 	    if(!inSwapAndLiquify && sender != pair && tradingOpen) {
376 	        taxToGet = mktTaxS + lpTaxS + devS;
377 	        addTaxCollected(mktTaxS, lpTaxS, devS);
378 	    }
379 
380         _balances[address(this)] = _balances[address(this)] + taxToGet;
381         emit Transfer(sender, address(this), taxToGet);
382 
383         return amount - taxToGet;
384     }
385 
386     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
387         _balances[sender] = _balances[sender] - amount;
388         _balances[recipient] = _balances[recipient] + amount;
389         emit Transfer(sender, recipient, amount);
390         return true;
391     }  
392 
393     function updateBuyFees(uint256 newBuyMktFee, uint256 newBuyLpFee, uint256 newBuyDev) public onlyOwner {
394 	    require(newBuyMktFee + newBuyLpFee + newBuyDev <= 1000, "Fees Too High");
395 	    buyMkt = newBuyMktFee;
396 	    buyLP = newBuyLpFee;
397         buyDev = newBuyDev;
398     }
399     
400     function updateSellFees(uint256 newSellMktFee,uint256 newSellLpFee, uint256 newSellDev) public onlyOwner {
401 	    require(newSellMktFee + newSellLpFee + newSellDev <= 1000, "Fees Too High");
402 	    sellMkt = newSellMktFee;
403 	    sellLP = newSellLpFee;
404 	    sellDev = newSellDev;
405     }
406 
407     function swapTokensForETH(uint256 tokenAmount) private {
408 
409         address[] memory path = new address[](2);
410         path[0] = address(this);
411         path[1] = router.WETH();
412 
413         approve(address(this), tokenAmount);
414 
415         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
416             tokenAmount,
417             0,
418             path,
419             address(this),
420             block.timestamp
421         );
422     }
423 
424     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
425         router.addLiquidityETH{value: ETHAmount}(
426             address(this),
427             tokenAmount,
428             0,
429             0,
430             liquidityPool,
431             block.timestamp
432         );
433     }
434 
435     function swapBack() internal lockTheSwap {
436     
437         uint256 tokenBalance = _balances[address(this)];
438         uint256 _totalCollected = taxesCollected[0] + taxesCollected[1] + taxesCollected[2];
439         uint256 mktShare = taxesCollected[0];
440         uint256 lpShare = taxesCollected[1];
441 	    uint256 devShare = taxesCollected[2];
442         uint256 tokensForLiquidity = lpShare / 2;  
443         uint256 amountToSwap = tokenBalance - tokensForLiquidity;
444 
445         swapTokensForETH(amountToSwap);
446 
447         uint256 totalETHBalance = address(this).balance;
448         uint256 ETHForMkt = totalETHBalance * mktShare / _totalCollected;
449         uint256 ETHForLiquidity = totalETHBalance * lpShare / _totalCollected / 2;
450 	    uint256 ETHForDev = totalETHBalance * devShare/ _totalCollected;
451       
452         if (totalETHBalance > 0) {
453             payable(marketingWallet).transfer(ETHForMkt);
454         }
455   
456         if (tokensForLiquidity > 0) {
457             addLiquidity(tokensForLiquidity, ETHForLiquidity);
458         }
459 	
460 	    if (ETHForDev > 0) {
461 	        payable(devWallet).transfer(ETHForDev);
462         }
463 
464 	    delete taxesCollected;
465     }
466 
467     function manualSwapBack() external onlyOwner {
468         swapBack();
469     }
470 
471     function clearStuckETH() external onlyOwner {
472         uint256 contractETHBalance = address(this).balance;
473         if(contractETHBalance > 0) { 
474             payable(marketingWallet).transfer(contractETHBalance);
475     	}
476     }
477 
478     function clearStuckTokens(address contractAddress) external onlyOwner {
479         IERC20 erc20Token = IERC20(contractAddress);
480         uint256 balance = erc20Token.balanceOf(address(this));
481         erc20Token.transfer(marketingWallet, balance);
482     }
483 
484     function massDistributeTokens(address[] calldata _airdropAddresses, uint amtPerAddress) external onlyOwner {
485 	    for (uint i = 0; i < _airdropAddresses.length; i++) {
486 	        IERC20(address(this)).transfer(_airdropAddresses[i], amtPerAddress);
487         }
488     }
489 
490     function distributeTokensByAmount(address[] calldata _airdropAddresses, uint[] calldata _airdropAmounts) external onlyOwner {
491 	    for (uint i = 0; i < _airdropAddresses.length; i++) {
492 	        IERC20(address(this)).transfer(_airdropAddresses[i], _airdropAmounts[i]);
493         }
494     }
495 }