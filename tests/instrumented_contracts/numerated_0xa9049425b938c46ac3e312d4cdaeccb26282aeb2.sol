1 // SPDX-License-Identifier: MIT
2 
3 /**WickedBet... Win the Lot! 
4 
5  The first ever business to offer fully-insured global lotto bets with Crypto.
6 
7 Linktree: https://linktr.ee/wickedbet
8 
9 */
10 
11 pragma solidity 0.8.13;
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function decimals() external view returns (uint8);
16     function symbol() external view returns (string memory);
17     function name() external view returns (string memory);
18     function getOwner() external view returns (address);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address _owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26     event Burn(address indexed from, address indexed to, uint256 value);
27 }
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44     address ZERO = 0x0000000000000000000000000000000000000000;
45 
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     modifier onlyOwner() {
51         _checkOwner();
52         _;
53     }
54 
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     function _checkOwner() internal view virtual {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61     }
62 
63     function renounceOwnership() public virtual onlyOwner {
64         _transferOwnership(ZERO);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != ZERO, "Ownable: new owner is the zero address");
69         _transferOwnership(newOwner);
70     }
71 
72     function _transferOwnership(address newOwner) internal virtual {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 
80 interface IDEXFactory {
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 }
83 
84 
85 interface IDEXRouter {
86     function factory() external pure returns (address);
87     function WETH() external pure returns (address);
88 
89     function addLiquidity(
90         address tokenA,
91         address tokenB,
92         uint amountADesired,
93         uint amountBDesired,
94         uint amountAMin,
95         uint amountBMin,
96         address to,
97         uint deadline
98     ) external returns (uint amountA, uint amountB, uint liquidity);
99 
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 
109     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116 
117     function swapExactETHForTokensSupportingFeeOnTransferTokens(
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external payable;
123 
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131 }
132 
133 
134 contract WICKEDBET is IERC20, Ownable {
135 
136     address private WETH;
137 
138     string private constant _name = "Wicked Bet";
139     string private constant _symbol = "WIK";
140     uint8 private constant _decimals = 18;
141     
142     uint256 _totalSupply = 1 * 10**8 * (10 ** _decimals);
143     uint256 public swapThreshold = _totalSupply / 1000; // Starting at 0.1%
144 
145     mapping (address => uint256) private _balances;
146     mapping (address => mapping(address => uint256)) private _allowances;
147     mapping (address => bool) public isFeeExempt;
148 
149     address DEAD = 0x000000000000000000000000000000000000dEaD;
150 
151     uint[3] taxesCollected = [0, 0];
152 
153     uint256 public launchedAt;
154     address public liquidityPool = DEAD;
155 
156     // All fees are in basis points (100 = 1%)
157     uint256 private buyWik = 300;
158     uint256 private sellWik = 300;
159     uint256 private buyLP = 200;
160     uint256 private sellLP = 200;
161     uint256 private xferBurn = 50;
162 
163     uint256 _baseBuyFee = buyWik + buyLP;
164     uint256 _baseSellFee = sellWik + sellLP;
165 
166     IDEXRouter public router;
167     address public pair;
168     address public factory;
169     address public wickedWallet = payable(0x000000000000000000000000000000000000dEaD);
170 
171     bool inSwapAndLiquify;
172     bool public swapAndLiquifyEnabled = true;
173     bool public tradingOpen = false;
174 
175     //Event Logs
176     event LiquidityPoolUpdated(address indexed _newPool);
177     event WickedWalletUpdated(address indexed _newWallet);
178     event RouterUpdated(IDEXRouter indexed _newRouter);
179     event BuyFeesUpdated(uint256 _newWik, uint256 _newLp);
180     event SellFeesUpdated(uint256 _neWik, uint256 _newLp);
181     event FeeExemptionChanged(address indexed _exemptWallet, bool _exempt);
182     event SwapbackSettingsChanged(bool _enabled, uint256 _newSwapbackAmount);
183 
184 
185     modifier lockTheSwap {
186         inSwapAndLiquify = true;
187         _;
188         inSwapAndLiquify = false;
189     }
190 
191     constructor() {
192         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193             
194         WETH = router.WETH();
195         
196         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
197         
198         _allowances[address(this)][address(router)] = type(uint256).max;
199 
200         isFeeExempt[owner()] = true;
201         isFeeExempt[wickedWallet] = true;
202         isFeeExempt[address(this)] = true;
203 
204         _balances[owner()] = _totalSupply;
205     
206         emit Transfer(address(0), owner(), _totalSupply);
207     }
208 
209     receive() external payable { }
210 
211     function launchSequence() external onlyOwner {
212 	    require(launchedAt == 0, "Already launched");
213         launchedAt = block.number;
214         tradingOpen = true;
215     }
216 
217     function getCirculatingSupply() public view returns (uint256) {
218         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
219     }
220 
221     function totalSupply() external view override returns (uint256) { return _totalSupply; }
222     function decimals() external pure override returns (uint8) { return _decimals; }
223     function symbol() external pure override returns (string memory) { return _symbol; }
224     function name() external pure override returns (string memory) { return _name; }
225     function getOwner() external view override returns (address) { return owner(); }
226     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
227     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
228     function baseBuyFee() external view returns (uint256) {return _baseBuyFee; }
229     function baseSellFee() external view returns (uint256) {return _baseSellFee; }
230 
231     function approve(address spender, uint256 amount) public override returns (bool) {
232         _allowances[msg.sender][spender] = amount;
233         emit Approval(msg.sender, spender, amount);
234         return true;
235     }
236 
237     function approveMax(address spender) external returns (bool) {
238         return approve(spender, type(uint256).max);
239     }
240 
241 //Transfer Functions
242 
243     function transfer(address recipient, uint256 amount) external override returns (bool) {
244         return _transfer(msg.sender, recipient, amount);
245     }
246 
247     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
248         if(_allowances[sender][msg.sender] != type(uint256).max){
249             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
250         }
251 
252         return _transfer(sender, recipient, amount);
253     }
254 
255     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
256         require(sender != address(0), "BEP20: transfer from the zero address");
257         require(recipient != address(0), "BEP20: transfer to the zero address");
258         require(amount > 0, "Transfer amount must be greater than zero");
259 
260         if(!isFeeExempt[sender] && !isFeeExempt[recipient]) { require(tradingOpen, "Trading not active"); }
261         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
262     	if(sender != pair && recipient != pair) { return _burnTransfer(sender, recipient, amount); }
263         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
264 
265         _balances[sender] = _balances[sender] - amount;
266         
267         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
268 
269         _balances[recipient] = _balances[recipient] + finalAmount;
270 
271         emit Transfer(sender, recipient, finalAmount);
272         return true;
273     }  
274 
275     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
276         _balances[sender] = _balances[sender] - amount;
277         _balances[recipient] = _balances[recipient] + amount;
278         emit Transfer(sender, recipient, amount);
279         return true;
280     }  
281 
282     function _burnTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
283         uint _burnFee = amount * xferBurn / 10000;
284         uint256 _finalAmount = !isFeeExempt[sender] ? amount - _burnFee : amount;
285 
286         _balances[sender] = _balances[sender] - amount;
287         _balances[recipient] = _balances[recipient] + _finalAmount;
288 
289         if(!isFeeExempt[sender]) { 
290             _balances[DEAD] = _balances[DEAD] + _burnFee; 
291             emit Burn(sender, DEAD, _burnFee); 
292             }
293 
294         emit Transfer(sender, recipient, _finalAmount);
295         return true;
296     }
297 
298 //Tax Functions
299 
300     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
301         
302         uint256 wikTaxB = amount * buyWik / 10000;
303 	    uint256 wikTaxS = amount * sellWik / 10000;
304         uint256 lpTaxB = amount * buyLP / 10000;
305 	    uint256 lpTaxS = amount * sellLP / 10000;
306         uint256 taxToGet;
307 
308 	    if(sender == pair && recipient != address(pair) && !isFeeExempt[recipient]) {
309             taxToGet = wikTaxB + lpTaxB;
310 	        addTaxCollected(wikTaxB, lpTaxB);
311 	    }
312 
313 	    if(!inSwapAndLiquify && sender != pair && tradingOpen) {
314 	        taxToGet = wikTaxS + lpTaxS;
315 	        addTaxCollected(wikTaxS, lpTaxS);
316 	    }
317 
318         _balances[address(this)] = _balances[address(this)] + taxToGet;
319         emit Transfer(sender, address(this), taxToGet);
320 
321         return amount - taxToGet;
322     }
323 
324     function addTaxCollected(uint wik, uint lp) internal {
325         taxesCollected[0] += wik;
326         taxesCollected[1] += lp;
327     }
328 
329 //LP and Swapback Functions
330 
331     function swapTokensForETH(uint256 tokenAmount) private {
332 
333         address[] memory path = new address[](2);
334         path[0] = address(this);
335         path[1] = router.WETH();
336 
337         approve(address(this), tokenAmount);
338 
339         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
340             tokenAmount,
341             0,
342             path,
343             address(this),
344             block.timestamp
345         );
346     }
347 
348     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
349         router.addLiquidityETH{value: ETHAmount}(
350             address(this),
351             tokenAmount,
352             0,
353             0,
354             liquidityPool,
355             block.timestamp
356         );
357     }
358 
359     function swapBack() internal lockTheSwap {
360     
361         uint256 tokenBalance = _balances[address(this)];
362         uint256 _totalCollected = taxesCollected[0] + taxesCollected[1];
363         uint256 wikShare = taxesCollected[0];
364         uint256 lpShare = taxesCollected[1];
365         uint256 tokensForLiquidity = lpShare / 2;  
366         uint256 amountToSwap = tokenBalance - tokensForLiquidity;
367 
368         swapTokensForETH(amountToSwap);
369 
370         uint256 totalETHBalance = address(this).balance;
371         uint256 ETHForWik = totalETHBalance * wikShare / _totalCollected;
372         uint256 ETHForLiquidity = totalETHBalance * lpShare / _totalCollected / 2;
373       
374         if (totalETHBalance > 0) {
375             payable(wickedWallet).transfer(ETHForWik);
376         }
377   
378         if (tokensForLiquidity > 0) {
379             addLiquidity(tokensForLiquidity, ETHForLiquidity);
380         }
381 
382 	    delete taxesCollected;
383     }
384 
385     function manualSwapBack() external onlyOwner {
386         swapBack();
387     }
388 
389 // Update/Change Functions
390 
391     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
392         isFeeExempt[holder] = exempt;
393         emit FeeExemptionChanged(holder, exempt);
394     }
395 
396     function setWickedWallet(address payable newWickedWallet) external onlyOwner {
397         require(newWickedWallet != address(0), "Cannot be set to zero address");
398         isFeeExempt[wickedWallet] = false;
399         wickedWallet = payable(newWickedWallet);
400         isFeeExempt[wickedWallet] = true;
401         emit WickedWalletUpdated(newWickedWallet);
402     }
403 
404     function setLiquidityPool(address newLiquidityPool) external onlyOwner {
405         require(newLiquidityPool != address(0), "Cannot be set to zero address");
406         liquidityPool = newLiquidityPool;
407         emit LiquidityPoolUpdated(newLiquidityPool);
408     }
409 
410     function changeSwapBackSettings(bool enableSwapback, uint256 newSwapbackLimit) external onlyOwner {
411         require(newSwapbackLimit >= 10000 * _decimals, "Limit must be over 10,000 tokens");
412         swapAndLiquifyEnabled  = enableSwapback;
413         swapThreshold = newSwapbackLimit;
414         emit SwapbackSettingsChanged(enableSwapback, newSwapbackLimit);
415     }
416 
417 
418     function updateBuyFees(uint256 newBuyWikFee, uint256 newBuyLpFee) public onlyOwner {
419 	    require(newBuyWikFee + newBuyLpFee <= 500, "Fees Too High");
420 	    buyWik = newBuyWikFee;
421 	    buyLP = newBuyLpFee;
422         emit BuyFeesUpdated(newBuyWikFee, newBuyLpFee);
423     }
424     
425     function updateSellFees(uint256 newSellWikFee,uint256 newSellLpFee) public onlyOwner {
426 	    require(newSellWikFee + newSellLpFee <= 500, "Fees Too High");
427 	    sellWik = newSellWikFee;
428 	    sellLP = newSellLpFee;
429         emit SellFeesUpdated(newSellWikFee, newSellLpFee);
430     }
431 
432     function updateRouter(IDEXRouter _newRouter) external onlyOwner {
433         require(_newRouter != IDEXRouter(ZERO), "Cannot be set to zero address");
434         require(_newRouter != IDEXRouter(DEAD), "Cannot be set to zero address");
435         router = _newRouter;
436         emit RouterUpdated(_newRouter);
437     }
438 
439     function clearStuckETH() external onlyOwner {
440         uint256 contractETHBalance = address(this).balance;
441         if(contractETHBalance > 0) { 
442             payable(wickedWallet).transfer(contractETHBalance);
443     	}
444     }
445 
446     function clearStuckTokens(address contractAddress) external onlyOwner {
447         IERC20 erc20Token = IERC20(contractAddress);
448         uint256 balance = erc20Token.balanceOf(address(this));
449         erc20Token.transfer(wickedWallet, balance);
450         if(contractAddress == address(this)) { delete taxesCollected; }
451     }
452 
453 }