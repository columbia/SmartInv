1 //SPDX-License-Identifier: MIT
2 
3 /*
4  https://DefiGram.Org
5 
6  https://t.me/DefiGramGlobal
7 
8  https://Twitter.com/DefiGramGlobal
9 
10 */
11 
12 pragma solidity 0.8.19;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function decimals() external view returns (uint8);
17     function symbol() external view returns (string memory);
18     function name() external view returns (string memory);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address __owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed _owner, address indexed spender, uint256 value);
26 }
27 
28 interface IUniswapV2Factory {  
29     
30     function createPair(address tokenA, address tokenB) external returns (address pair); 
31 }
32 interface IUniswapV2Router02 {
33     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
34     function WETH() external pure returns (address);
35     function factory() external pure returns (address);
36     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
37 }
38 
39 abstract contract Auth {
40     address internal _owner;
41     constructor(address creatorOwner) { 
42         _owner = creatorOwner; 
43     }
44     modifier onlyOwner() { 
45         require(msg.sender == _owner, "Only owner can call this"); 
46         _; 
47     }
48     function owner() public view returns (address) { 
49         return _owner; 
50     }
51     function transferOwnership(address payable newOwner) external onlyOwner { 
52         _owner = newOwner; 
53         emit OwnershipTransferred(newOwner); 
54     }
55     function renounceOwnership() external onlyOwner { 
56         _owner = address(0); 
57         emit OwnershipTransferred(address(0)); 
58     }
59     event OwnershipTransferred(address _owner);
60 }
61 
62 contract DefiGram is IERC20, Auth {
63     uint8 private constant _decimals      = 9;
64     uint256 private constant _totalSupply = 21_000_000 * (10**_decimals);
65     string private constant _name         = "DefiGram";
66     string private  constant _symbol       = "DEFIGRAM";
67 
68     uint8 private antiSnipeTax1 = 2;
69     uint8 private antiSnipeTax2 = 1;
70     uint8 private antiSnipeBlocks1 = 1;
71     uint8 private antiSnipeBlocks2 = 1;
72     uint256 private _antiMevBlock = 2;
73 
74     uint8 private _buyTaxRate  = 0;
75     uint8 private _sellTaxRate = 0;
76 
77     uint16 private _taxSharesMarketing   = 63;
78     uint16 private _taxSharesDevelopment = 37;
79     uint16 private _taxSharesLP          = 0;
80     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;
81 
82     address payable private _walletMarketing = payable(0xC2E1115b1cb392453EB53d0477fEef59cB9761d9); 
83     address payable private _walletDevelopment = payable(0xA094078749Ae59663B5E1C82E4B741cc61fb67DB); 
84 
85     uint256 private _launchBlock;
86     uint256 private _maxTxAmount     = _totalSupply; 
87     uint256 private _maxWalletAmount = _totalSupply;
88     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
89     uint256 private _taxSwapMax = _totalSupply * 891 / 100000;
90     uint256 private _swapLimit = _taxSwapMin * 63 * 100;
91 
92     mapping (address => uint256) private _balances;
93     mapping (address => mapping (address => uint256)) private _allowances;
94     mapping (address => bool) private _noFees;
95     mapping (address => bool) private _noLimits;
96 
97     address private _lpOwner;
98 
99     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
100     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
101     address private _primaryLP;
102     mapping (address => bool) private _isLP;
103 
104     bool private _tradingOpen;
105 
106     bool private _inTaxSwap = false;
107     modifier lockTaxSwap { 
108         _inTaxSwap = true; 
109         _; 
110         _inTaxSwap = false; 
111     }
112 
113     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
114 
115     constructor() Auth(msg.sender) {
116         _lpOwner = msg.sender;
117 
118         uint256 airdropAmount = _totalSupply * 5 / 100;
119         
120         _balances[address(this)] =  _totalSupply - airdropAmount;
121         emit Transfer(address(0), address(this), _balances[address(this)]);
122 
123         _balances[_owner] = airdropAmount;
124         emit Transfer(address(0), _owner, _balances[_owner]);
125 
126         _noFees[_owner] = true;
127         _noFees[address(this)] = true;
128         _noFees[_swapRouterAddress] = true;
129         _noFees[_walletMarketing] = true;
130         _noFees[_walletDevelopment] = true;
131         _noLimits[_owner] = true;
132         _noLimits[address(this)] = true;
133         _noLimits[_swapRouterAddress] = true;
134         _noLimits[_walletMarketing] = true;
135         _noLimits[_walletDevelopment] = true;
136     }
137 
138     receive() external payable {}
139     
140     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
141     function decimals() external pure override returns (uint8) { return _decimals; }
142     function symbol() external pure override returns (string memory) { return _symbol; }
143     function name() external pure override returns (string memory) { return _name; }
144     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
145     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
146 
147     function approve(address spender, uint256 amount) public override returns (bool) {
148         _allowances[msg.sender][spender] = amount;
149         emit Approval(msg.sender, spender, amount);
150         return true;
151     }
152 
153     function transfer(address recipient, uint256 amount) external override returns (bool) {
154         require(_checkTradingOpen(msg.sender), "Trading not open");
155         return _transferFrom(msg.sender, recipient, amount);
156     }
157 
158     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
159         require(_checkTradingOpen(sender), "Trading not open");
160         if(_allowances[sender][msg.sender] != type(uint256).max){
161             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
162         }
163         return _transferFrom(sender, recipient, amount);
164     }
165 
166     function _approveRouter(uint256 _tokenAmount) internal {
167         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
168             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
169             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
170         }
171     }
172 
173     function addLiquidity() external payable onlyOwner lockTaxSwap {
174         require(_primaryLP == address(0), "LP exists");
175         require(!_tradingOpen, "trading is open");
176         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
177         require(_balances[address(this)]>0, "No tokens in contract");
178         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
179         _addLiquidity(_balances[address(this)], address(this).balance, false);
180         _balances[_primaryLP] -= _swapLimit;
181         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
182         require(lpAddSuccess, "Failed adding liquidity");
183         _isLP[_primaryLP] = lpAddSuccess;
184         _openTrading();
185     }
186 
187     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
188         address lpTokenRecipient = _lpOwner;
189         if ( autoburn ) { lpTokenRecipient = address(0); }
190         _approveRouter(_tokenAmount);
191         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
192     }
193 
194     function _openTrading() internal {
195         _maxTxAmount     = _totalSupply * 2 / 100; 
196         _maxWalletAmount = _totalSupply * 2 / 100;
197         _tradingOpen = true;
198         _launchBlock = block.number;
199         _antiMevBlock = _antiMevBlock + _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2;
200     }
201 
202     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
203         require(sender != address(0), "No transfers from Zero wallet");
204         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
205         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
206         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
207             require(recipient == tx.origin, "MEV blocked");
208         }
209         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
210             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
211         }
212         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
213         uint256 _transferAmount = amount - _taxAmount;
214         _balances[sender] = _balances[sender] - amount;
215         _swapLimit += _taxAmount;
216         _balances[recipient] = _balances[recipient] + _transferAmount;
217         emit Transfer(sender, recipient, amount);
218         return true;
219     }
220 
221     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
222         bool limitCheckPassed = true;
223         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
224             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
225             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
226         }
227         return limitCheckPassed;
228     }
229 
230     function _checkTradingOpen(address sender) private view returns (bool){
231         bool checkResult = false;
232         if ( _tradingOpen ) { checkResult = true; } 
233         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
234 
235         return checkResult;
236     }
237 
238     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
239         uint256 taxAmount;
240         
241         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
242             taxAmount = 0; 
243         } else if ( _isLP[sender] ) { 
244             if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
245                 taxAmount = amount * _buyTaxRate / 100; 
246             } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
247                 taxAmount = amount * antiSnipeTax2 / 100;
248             } else if ( block.number >= _launchBlock) {
249                 taxAmount = amount * antiSnipeTax1 / 100;
250             }
251         } else if ( _isLP[recipient] ) { 
252             taxAmount = amount * _sellTaxRate / 100; 
253         }
254 
255         return taxAmount;
256     }
257 
258 
259     function exemptFromFees(address wallet) external view returns (bool) {
260         return _noFees[wallet];
261     } 
262     function exemptFromLimits(address wallet) external view returns (bool) {
263         return _noLimits[wallet];
264     } 
265     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
266         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
267         _noFees[ wallet ] = noFees;
268         _noLimits[ wallet ] = noLimits;
269     }
270 
271     function buyFee() external view returns(uint8) {
272         return _buyTaxRate;
273     }
274     function sellFee() external view returns(uint8) {
275         return _sellTaxRate;
276     }
277 
278     function feeSplit() external view returns (uint16 marketing, uint16 development, uint16 LP ) {
279         return ( _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP);
280     }
281     function setFees(uint8 buy, uint8 sell) external onlyOwner {
282         require(buy + sell <= 5, "Roundtrip too high");
283         _buyTaxRate = buy;
284         _sellTaxRate = sell;
285     }  
286     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
287         uint16 totalShares = sharesAutoLP + sharesMarketing + sharesDevelopment;
288         require( totalShares > 0, "All cannot be 0");
289         _taxSharesLP = sharesAutoLP;
290         _taxSharesMarketing = sharesMarketing;
291         _taxSharesDevelopment = sharesDevelopment;
292         _totalTaxShares = totalShares;
293     }
294 
295     function marketingWallet() external view returns (address) {
296         return _walletMarketing;
297     }
298     function developmentWallet() external view returns (address) {
299         return _walletDevelopment;
300     }
301 
302     function updateWallets(address marketing, address development, address LPtokens) external onlyOwner {
303         require(!_isLP[marketing] && !_isLP[development] && !_isLP[LPtokens], "LP cannot be tax wallet");
304         
305         _walletMarketing = payable(marketing);
306         _walletDevelopment = payable(development);
307         _lpOwner = LPtokens;
308         
309         _noFees[marketing] = true;
310         _noLimits[marketing] = true;
311         
312         _noFees[development] = true;        
313         _noLimits[development] = true;
314     }
315 
316     function maxWallet() external view returns (uint256) {
317         return _maxWalletAmount;
318     }
319     function maxTransaction() external view returns (uint256) {
320         return _maxTxAmount;
321     }
322 
323     function swapAtMin() external view returns (uint256) {
324         return _taxSwapMin;
325     }
326     function swapAtMax() external view returns (uint256) {
327         return _taxSwapMax;
328     }
329 
330     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
331         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
332         require(newTxAmt >= _maxTxAmount, "tx too low");
333         _maxTxAmount = newTxAmt;
334         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
335         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
336         _maxWalletAmount = newWalletAmt;
337     }
338 
339     function setTaxSwap(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
340         _taxSwapMin = _totalSupply * minValue / minDivider;
341         _taxSwapMax = _totalSupply * maxValue / maxDivider;
342         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
343         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
344         require(_taxSwapMax<_totalSupply / 100, "Max too high");
345     }
346 
347     function _burnTokens(address fromWallet, uint256 amount) private {
348         if ( amount > 0 ) {
349             _balances[fromWallet] -= amount;
350             _balances[address(0)] += amount;
351             emit Transfer(fromWallet, address(0), amount);
352         }
353     }
354 
355     function _swapTaxAndLiquify() private lockTaxSwap {
356         uint256 _taxTokensAvailable = _swapLimit;
357         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
358             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
359             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
360             
361             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
362             if( _tokensToSwap > 10**_decimals ) {
363                 uint256 _ethPreSwap = address(this).balance;
364                 _balances[address(this)] += _taxTokensAvailable;
365                 _swapTaxTokensForEth(_tokensToSwap);
366                 _swapLimit -= _taxTokensAvailable;
367                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
368                 if ( _taxSharesLP > 0 ) {
369                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
370                     _approveRouter(_tokensForLP);
371                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
372                 }
373             }
374             uint256 _contractETHBalance = address(this).balance;
375             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
376         }
377     }
378 
379     function _swapTaxTokensForEth(uint256 tokenAmount) private {
380         _approveRouter(tokenAmount);
381         address[] memory path = new address[](2);
382         path[0] = address(this);
383         path[1] = _primarySwapRouter.WETH();
384         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
385     }
386 
387     function _distributeTaxEth(uint256 amount) private {
388         uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
389         if (_taxShareTotal > 0) {
390             uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
391             uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
392             if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
393             if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
394         }
395     }
396 
397     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
398         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
399         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
400         if (tokensToSwap > 10 ** _decimals) {
401             _swapTaxTokensForEth(tokensToSwap);
402         }
403         if (sendEth) { 
404             uint256 ethBalance = address(this).balance;
405             require(ethBalance > 0, "No ETH");
406             _distributeTaxEth(address(this).balance); 
407         }
408     }
409 
410     function burn(uint256 amount) external {
411         uint256 _tokensAvailable = balanceOf(msg.sender);
412         require(amount <= _tokensAvailable, "balance too low");
413         _burnTokens(msg.sender, amount);
414         emit TokensBurned(msg.sender, amount);
415     }
416 }