1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.8;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IERC20Metadata is IERC20 {
31     function name() external view returns (string memory);
32     function symbol() external view returns (string memory);
33     function decimals() external view returns (uint8);
34 }
35 
36 contract ERC20 is Context, IERC20, IERC20Metadata {
37     mapping(address => uint256) private _balances;
38     mapping(address => mapping(address => uint256)) private _allowances;
39     uint256 private _totalSupply;
40     string private _name;
41     string private _symbol;
42 
43     constructor(string memory name_, string memory symbol_) {
44         _name = name_;
45         _symbol = symbol_;
46     }
47 
48     function name() public view virtual override returns (string memory) {
49         return _name;
50     }
51 
52     function symbol() public view virtual override returns (string memory) {
53         return _symbol;
54     }
55 
56     function decimals() public view virtual override returns (uint8) {
57         return 18;
58     }
59 
60     function totalSupply() public view virtual override returns (uint256) {
61         return _totalSupply;
62     }
63 
64     function balanceOf(address account) public view virtual override returns (uint256) {
65         return _balances[account];
66     }
67 
68     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
69         _transfer(_msgSender(), recipient, amount);
70         return true;
71     }
72 
73     function allowance(address owner, address spender) public view virtual override returns (uint256) {
74         return _allowances[owner][spender];
75     }
76 
77     function approve(address spender, uint256 amount) public virtual override returns (bool) {
78         _approve(_msgSender(), spender, amount);
79         return true;
80     }
81 
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) public virtual override returns (bool) {
87         _transfer(sender, recipient, amount);
88 
89         uint256 currentAllowance = _allowances[sender][_msgSender()];
90         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
91     unchecked {
92         _approve(sender, _msgSender(), currentAllowance - amount);
93     }
94 
95         return true;
96     }
97 
98     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
104         uint256 currentAllowance = _allowances[_msgSender()][spender];
105         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
106     unchecked {
107         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
108     }
109 
110         return true;
111     }
112 
113     function _transfer(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) internal virtual {
118         require(sender != address(0), "ERC20: transfer from the zero address");
119         require(recipient != address(0), "ERC20: transfer to the zero address");
120 
121         uint256 senderBalance = _balances[sender];
122         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
123     unchecked {
124         _balances[sender] = senderBalance - amount;
125     }
126         _balances[recipient] += amount;
127 
128         emit Transfer(sender, recipient, amount);
129     }
130 
131     function _createInitialSupply(address account, uint256 amount) internal virtual {
132         require(account != address(0), "ERC20: mint to the zero address");
133 
134         _totalSupply += amount;
135         _balances[account] += amount;
136         emit Transfer(address(0), account, amount);
137     }
138 
139     function _approve(
140         address owner,
141         address spender,
142         uint256 amount
143     ) internal virtual {
144         require(owner != address(0), "ERC20: approve from the zero address");
145         require(spender != address(0), "ERC20: approve to the zero address");
146 
147         _allowances[owner][spender] = amount;
148         emit Approval(owner, spender, amount);
149     }
150 }
151 
152 contract Ownable is Context {
153     address private _owner;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157     constructor () {
158         address msgSender = _msgSender();
159         _owner = msgSender;
160         emit OwnershipTransferred(address(0), msgSender);
161     }
162 
163     function owner() public view returns (address) {
164         return _owner;
165     }
166 
167     modifier onlyOwner() {
168         require(_owner == _msgSender(), "Ownable: caller is not the owner");
169         _;
170     }
171 
172     function renounceOwnership() external virtual onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 interface IDexRouter {
185     function factory() external pure returns (address);
186     function WETH() external pure returns (address);
187 
188     function swapExactTokensForETHSupportingFeeOnTransferTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external;
195 
196     function addLiquidityETH(
197         address token,
198         uint256 amountTokenDesired,
199         uint256 amountTokenMin,
200         uint256 amountETHMin,
201         address to,
202         uint256 deadline
203     )
204     external
205     payable
206     returns (
207         uint256 amountToken,
208         uint256 amountETH,
209         uint256 liquidity
210     );
211 }
212 
213 interface IDexFactory {
214     function createPair(address tokenA, address tokenB)
215     external
216     returns (address pair);
217 }
218 
219 contract TSYGAN is ERC20, Ownable {
220 
221 
222     IDexRouter public immutable uniswapV2Router;
223     address public immutable uniswapV2Pair;
224 
225     bool private swapping;
226     uint256 public swapTokensAtAmount;
227 
228     address payable public TreasuryAddress;
229 
230     uint256 public buyTotalFees;
231     uint256 public buyTreasuryFee;
232     uint256 public buyLiquidityFee;
233 
234     uint256 public sellTotalFees;
235     uint256 public sellTreasuryFee;
236     uint256 public sellLiquidityFee;
237 
238     uint256 public tokensForTreasury;
239     uint256 public tokensForLiquidity;
240 
241     bool public tradingActive = false;
242 
243     /******************/
244 
245     // exlcude from fees and max transaction amount
246     mapping (address => bool) private _isExcludedFromFees;
247 
248     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
249     // could be subject to a maximum transfer amount
250     mapping (address => bool) public automatedMarketMakerPairs;
251 
252     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
253 
254 
255     event ExcludeFromFees(address indexed account, bool isExcluded);
256 
257 
258     event UpdatedTreasuryAddress(address indexed newWallet);
259 
260     event MaxTransactionExclusion(address _address, bool excluded);
261 
262     event SwapAndLiquify(
263         uint256 tokensSwapped,
264         uint256 ethReceived,
265         uint256 tokensIntoLiquidity
266     );
267 
268     event TransferForeignToken(address token, uint256 amount);
269 
270     constructor() ERC20("The Real TSYGAN", "TSYGAN") {
271 
272         address newOwner = msg.sender; // can leave alone if owner is deployer.
273 
274         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
275         uniswapV2Router = _uniswapV2Router;
276 
277         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
278         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
279 
280         uint256 totalSupply = 666666666666666 * 1e18;
281 
282         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
283 
284         buyTreasuryFee = 5;
285         buyLiquidityFee = 0;
286         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
287 
288         sellTreasuryFee = 5;
289         sellLiquidityFee = 0;
290         sellTotalFees = sellTreasuryFee + sellLiquidityFee ;
291 
292         TreasuryAddress = payable(0xd21D39180bEB7a2A18889058Ff7f6df56cA90E0e);
293 
294         excludeFromFees(newOwner, true);
295         excludeFromFees(address(this), true);
296         excludeFromFees(address(0xdead), true);
297 
298 
299         _createInitialSupply(newOwner, totalSupply);
300         transferOwnership(newOwner);
301     }
302 
303     receive() external payable {}
304 
305 
306     
307 
308     // change the minimum amount of tokens to sell from fees
309     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
310         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
311         require(newAmount <= totalSupply() * 1 / 100, "Swap amount cannot be higher than 1% total supply.");
312         swapTokensAtAmount = newAmount;
313     }
314 
315     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
316         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
317 
318         _setAutomatedMarketMakerPair(pair, value);
319     }
320 
321     function _setAutomatedMarketMakerPair(address pair, bool value) private {
322         automatedMarketMakerPairs[pair] = value;
323 
324         emit SetAutomatedMarketMakerPair(pair, value);
325     }
326 
327     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
328         buyTreasuryFee = _treasuryFee;
329         buyLiquidityFee = _liquidityFee;
330         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
331         require(buyTotalFees <= 9, "Must keep fees less than 9%");
332     }
333 
334     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
335         sellTreasuryFee = _treasuryFee;
336         sellLiquidityFee = _liquidityFee;
337         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
338         require(sellTotalFees <= 9, "Must keep fees less than 9%");
339     }
340 
341     function excludeFromFees(address account, bool excluded) public onlyOwner {
342         _isExcludedFromFees[account] = excluded;
343         emit ExcludeFromFees(account, excluded);
344     }
345 
346     function _transfer(address from, address to, uint256 amount) internal override {
347 
348         require(from != address(0), "ERC20: transfer from the zero address");
349         require(to != address(0), "ERC20: transfer to the zero address");
350         require(amount > 0, "amount must be greater than 0");
351 
352         if(!tradingActive){
353             require(from == owner(), "Trading is not enabled");
354         }
355         uint256 contractTokenBalance = balanceOf(address(this));
356 
357         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
358 
359         if(canSwap && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
360             swapping = true;
361             swapBack();
362             swapping = false;
363         }
364 
365         bool takeFee = true;
366         // if any account belongs to _isExcludedFromFee account then remove the fee
367         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
368             takeFee = false;
369         }
370 
371         uint256 fees = 0;
372         // only take fees on Trades, not on wallet transfers
373 
374         if(takeFee){
375             
376             // on sell
377             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
378                 fees = amount * sellTotalFees /100;
379                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
380                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
381             }
382             // on buy
383             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
384                 fees = amount * buyTotalFees / 100;
385                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
386                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
387             }
388 
389             if(fees > 0){
390                 super._transfer(from, address(this), fees);
391             }
392 
393             amount -= fees;
394         }
395 
396         super._transfer(from, to, amount);
397     }
398 
399     function swapTokensForEth(uint256 tokenAmount) private {
400 
401         // generate the uniswap pair path of token -> weth
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405 
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407 
408         // make the swap
409         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
410             tokenAmount,
411             0, // accept any amount of ETH
412             path,
413             address(this),
414             block.timestamp
415         );
416     }
417 
418     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
419         // approve token transfer to cover all possible scenarios
420         _approve(address(this), address(uniswapV2Router), tokenAmount);
421 
422         // add the liquidity
423         uniswapV2Router.addLiquidityETH{value: ethAmount}(
424             address(this),
425             tokenAmount,
426             0, // slippage is unavoidable
427             0, // slippage is unavoidable
428             address(owner()),
429             block.timestamp
430         );
431     }
432 
433     function swapBack() private {
434         uint256 contractBalance = balanceOf(address(this));
435         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
436 
437         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
438 
439         if(contractBalance > swapTokensAtAmount * 10){
440             contractBalance = swapTokensAtAmount * 10;
441         }
442 
443         // Halve the amount of liquidity tokens
444         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
445 
446         swapTokensForEth(contractBalance - liquidityTokens);
447 
448         uint256 ethBalance = address(this).balance;
449         uint256 ethForLiquidity = ethBalance;
450 
451         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
452        
453         ethForLiquidity -= ethForTreasury;
454 
455         tokensForLiquidity = 0;
456         tokensForTreasury = 0;
457 
458         if(liquidityTokens > 0 && ethForLiquidity > 0){
459             addLiquidity(liquidityTokens, ethForLiquidity);
460         }
461 
462         uint256 contractETHBalance = address(this).balance;
463         if(contractETHBalance > 0) {
464             sendETHToFee(contractETHBalance,TreasuryAddress);
465         }
466     }
467 
468     function sendETHToFee(uint256 amount,address payable wallet) private {
469         wallet.transfer(amount);
470     }
471     
472     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
473         require(_token != address(0), "_token address cannot be 0");
474         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
475         _sent = IERC20(_token).transfer(_to, _contractBalance);
476         emit TransferForeignToken(_token, _contractBalance);
477     }
478 
479     // withdraw ETH if stuck or someone sends to the address
480     function withdrawStuckETH() external onlyOwner {
481         bool success;
482         (success,) = address(msg.sender).call{value: address(this).balance}("");
483     }
484 
485       
486     function airdrop(address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
487 
488         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
489         require(addresses.length == tokens.length,"Mismatch between Address and token count");
490 
491         uint256 SCCC = 0;
492 
493         for(uint i=0; i < addresses.length; i++){
494             SCCC = SCCC + (tokens[i] * 10**decimals());
495         }
496 
497         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
498 
499         for(uint i=0; i < addresses.length; i++){
500             _transfer(msg.sender,addresses[i],(tokens[i] * 10**decimals()));
501         
502         }
503     }
504 
505 
506     function setTreasuryAddress(address _TreasuryAddress) external onlyOwner {
507         require(_TreasuryAddress != address(0), "_TreasuryAddress address cannot be 0");
508         TreasuryAddress = payable(_TreasuryAddress);
509         emit UpdatedTreasuryAddress(_TreasuryAddress);
510     }
511 
512       // once enabled, can never be turned off
513     function enableTrading() external onlyOwner {
514         require(!tradingActive, "Cannot re enable trading");
515         tradingActive = true;
516     }
517 
518 }