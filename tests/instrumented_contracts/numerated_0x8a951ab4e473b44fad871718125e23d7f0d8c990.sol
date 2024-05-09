1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 /*
5 
6 // Telegram: https://t.me/Scratchswap
7 
8 */
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function decimals() external view returns (uint8);
13     function symbol() external view returns (string memory);
14     function name() external view returns (string memory);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address __owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed _owner, address indexed spender, uint256 value);
22 }
23 
24 interface IUniswapV2Factory { 
25     function createPair(address tokenA, address tokenB) external returns (address pair); 
26 }
27 interface IUniswapV2Router02 {
28     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
29     function WETH() external pure returns (address);
30     function factory() external pure returns (address);
31     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
32 }
33 
34 abstract contract Auth {
35     address internal _owner;
36     constructor(address creatorOwner) { 
37         _owner = creatorOwner; 
38     }
39     modifier onlyOwner() { 
40         require(msg.sender == _owner, "Only owner can call this"); 
41         _; 
42     }
43     function owner() public view returns (address) { 
44         return _owner; 
45     }
46     function transferOwnership(address payable newOwner) external onlyOwner { 
47         _owner = newOwner; 
48         emit OwnershipTransferred(newOwner); 
49     }
50     function renounceOwnership() external onlyOwner { 
51         _owner = address(0); 
52         emit OwnershipTransferred(address(0)); 
53     }
54     event OwnershipTransferred(address _owner);
55 }
56 
57 contract Scratch is IERC20, Auth {
58     uint8 private constant _decimals      = 9;
59     uint256 private constant _totalSupply = 1_000_000 * (10**_decimals);
60     string private constant _name         = "ScratchSwap";
61     string private constant _symbol       = "SCRATCH";
62 
63     uint8 private antiSnipeTax1 = 82;
64     uint8 private antiSnipeTax2 = 42;
65     uint8 private antiSnipeBlocks1 = 3;
66     uint8 private antiSnipeBlocks2 = 3;
67 
68     uint8 private _buyTaxRate  = 3;
69     uint8 private _sellTaxRate = 3;
70 
71     uint16 private _taxSharesMarketing   = 50;
72     uint16 private _taxSharesDevelopment = 40;
73     uint16 private _taxSharesLP          = 10;
74     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;
75 
76     address payable private _walletMarketing = payable(0xE6db4220A5b55691D17B947A75D2b0281A8a1A53); 
77     address payable private _walletDevelopment = payable(0x043B8452Dc6892357EFacdc11F9cD326Cd89BF0D); 
78 
79     uint256 private _launchBlock;
80     uint256 private _maxTxAmount     = _totalSupply; 
81     uint256 private _maxWalletAmount = _totalSupply;
82     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
83     uint256 private _taxSwapMax = _totalSupply * 100 / 100000;
84 
85     mapping (address => uint256) private _balances;
86     mapping (address => mapping (address => uint256)) private _allowances;
87     mapping (address => bool) private _noFees;
88     mapping (address => bool) private _noLimits;
89 
90     address private _lpOwner;
91 
92     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
93     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
94     address private _primaryLP;
95     mapping (address => bool) private _isLP;
96 
97     bool private _tradingOpen;
98 
99     bool private _inTaxSwap = false;
100     modifier lockTaxSwap { 
101         _inTaxSwap = true; 
102         _; 
103         _inTaxSwap = false; 
104     }
105 
106     event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
107     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
108 
109     constructor() Auth(msg.sender) {
110         _lpOwner = msg.sender;
111         
112         _balances[address(this)] =  _totalSupply;
113         emit Transfer(address(0xB8f226dDb7bC672E27dffB67e4adAbFa8c0dFA08), address(this), _balances[address(this)]);
114 
115         _noFees[_owner] = true;
116         _noFees[address(this)] = true;
117         _noFees[_swapRouterAddress] = true;
118         _noFees[_walletMarketing] = true;
119         _noFees[_walletDevelopment] = true;
120         _noLimits[_owner] = true;
121         _noLimits[address(this)] = true;
122         _noLimits[_swapRouterAddress] = true;
123         _noLimits[_walletMarketing] = true;
124         _noLimits[_walletDevelopment] = true;
125     }
126 
127     receive() external payable {}
128     
129     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
130     function decimals() external pure override returns (uint8) { return _decimals; }
131     function symbol() external pure override returns (string memory) { return _symbol; }
132     function name() external pure override returns (string memory) { return _name; }
133     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
134     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
135 
136     function approve(address spender, uint256 amount) public override returns (bool) {
137         _allowances[msg.sender][spender] = amount;
138         emit Approval(msg.sender, spender, amount);
139         return true;
140     }
141 
142     function transfer(address recipient, uint256 amount) external override returns (bool) {
143         require(_checkTradingOpen(msg.sender), "Trading not open");
144         return _transferFrom(msg.sender, recipient, amount);
145     }
146 
147     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
148         require(_checkTradingOpen(sender), "Trading not open");
149         if(_allowances[sender][msg.sender] != type(uint256).max){
150             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
151         }
152         return _transferFrom(sender, recipient, amount);
153     }
154 
155     function _approveRouter(uint256 _tokenAmount) internal {
156         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
157             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
158             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
159         }
160     }
161 
162     function addLiquidity() external payable onlyOwner lockTaxSwap {
163         require(_primaryLP == address(0), "LP exists");
164         require(!_tradingOpen, "trading is open");
165         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
166         require(_balances[address(this)]>0, "No tokens in contract");
167         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
168         _addLiquidity(_balances[address(this)], address(this).balance, false);
169         _isLP[_primaryLP] = true;
170         _openTrading();
171     }
172 
173     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
174         address lpTokenRecipient = _lpOwner;
175         if ( autoburn ) { lpTokenRecipient = address(0); }
176         _approveRouter(_tokenAmount);
177         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
178     }
179 
180     function _openTrading() internal {
181         _maxTxAmount     = _totalSupply * 1 / 100; 
182         _maxWalletAmount = _totalSupply * 1 / 100;
183         _tradingOpen = true;
184         _launchBlock = block.number;
185     }
186 
187     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
188         require(sender != address(0), "No transfers from Zero wallet");
189         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
190         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
191         
192         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
193         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
194         uint256 _transferAmount = amount - _taxAmount;
195         _balances[sender] = _balances[sender] - amount;
196         if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
197         _balances[recipient] = _balances[recipient] + _transferAmount;
198         emit Transfer(sender, recipient, amount);
199         return true;
200     }
201 
202     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
203         bool limitCheckPassed = true;
204         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
205             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
206             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
207         }
208         return limitCheckPassed;
209     }
210 
211     function _checkTradingOpen(address sender) private view returns (bool){
212         bool checkResult = false;
213         if ( _tradingOpen ) { checkResult = true; } 
214         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
215 
216         return checkResult;
217     }
218 
219     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
220         uint256 taxAmount;
221         
222         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
223             taxAmount = 0; 
224         } else if ( _isLP[sender] ) { 
225             if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
226                 taxAmount = amount * _buyTaxRate / 100; 
227             } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
228                 taxAmount = amount * antiSnipeTax2 / 100;
229             } else if ( block.number >= _launchBlock) {
230                 taxAmount = amount * antiSnipeTax1 / 100;
231             }
232         } else if ( _isLP[recipient] ) { 
233             taxAmount = amount * _sellTaxRate / 100; 
234         }
235 
236         return taxAmount;
237     }
238 
239 
240     function exemptFromFees(address wallet) external view returns (bool) {
241         return _noFees[wallet];
242     } 
243     function exemptFromLimits(address wallet) external view returns (bool) {
244         return _noLimits[wallet];
245     } 
246     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
247         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
248         _noFees[ wallet ] = noFees;
249         _noLimits[ wallet ] = noLimits;
250     }
251 
252     function buyFee() external view returns(uint8) {
253         return _buyTaxRate;
254     }
255     function sellFee() external view returns(uint8) {
256         return _sellTaxRate;
257     }
258 
259     function feeSplit() external view returns (uint16 marketing, uint16 development, uint16 LP ) {
260         return ( _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP);
261     }
262     function setFees(uint8 buy, uint8 sell) external onlyOwner {
263         require(buy + sell <= 99, "Roundtrip too high");
264         _buyTaxRate = buy;
265         _sellTaxRate = sell;
266     }  
267     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
268         uint16 totalShares = sharesAutoLP + sharesMarketing + sharesDevelopment;
269         require( totalShares > 0, "All cannot be 0");
270         _taxSharesLP = sharesAutoLP;
271         _taxSharesMarketing = sharesMarketing;
272         _taxSharesDevelopment = sharesDevelopment;
273         _totalTaxShares = totalShares;
274     }
275 
276     function marketingWallet() external view returns (address) {
277         return _walletMarketing;
278     }
279     function developmentWallet() external view returns (address) {
280         return _walletDevelopment;
281     }
282 
283     function updateWallets(address marketing, address development, address LPtokens) external onlyOwner {
284         require(!_isLP[marketing] && !_isLP[development] && !_isLP[LPtokens], "LP cannot be tax wallet");
285         
286         _walletMarketing = payable(marketing);
287         _walletDevelopment = payable(development);
288         _lpOwner = LPtokens;
289         
290         _noFees[marketing] = true;
291         _noLimits[marketing] = true;
292         
293         _noFees[development] = true;        
294         _noLimits[development] = true;
295     }
296 
297     function maxWallet() external view returns (uint256) {
298         return _maxWalletAmount;
299     }
300     function maxTransaction() external view returns (uint256) {
301         return _maxTxAmount;
302     }
303 
304     function swapAtMin() external view returns (uint256) {
305         return _taxSwapMin;
306     }
307     function swapAtMax() external view returns (uint256) {
308         return _taxSwapMax;
309     }
310 
311     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
312         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
313         require(newTxAmt >= _maxTxAmount, "tx too low");
314         _maxTxAmount = newTxAmt;
315         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
316         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
317         _maxWalletAmount = newWalletAmt;
318     }
319 
320     function setTaxSwap(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
321         _taxSwapMin = _totalSupply * minValue / minDivider;
322         _taxSwapMax = _totalSupply * maxValue / maxDivider;
323         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
324         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
325         require(_taxSwapMax<_totalSupply / 100, "Max too high");
326     }
327 
328     function _burnTokens(address fromWallet, uint256 amount) private {
329         if ( amount > 0 ) {
330             _balances[fromWallet] -= amount;
331             _balances[address(0)] += amount;
332             emit Transfer(fromWallet, address(0), amount);
333         }
334     }
335 
336     function _swapTaxAndLiquify() private lockTaxSwap {
337         uint256 _taxTokensAvailable = balanceOf(address(this));
338 
339         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
340             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
341 
342             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
343             
344             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
345             if( _tokensToSwap > 10**_decimals ) {
346                 uint256 _ethPreSwap = address(this).balance;
347                 _swapTaxTokensForEth(_tokensToSwap);
348                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
349                 if ( _taxSharesLP > 0 ) {
350                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
351                     _approveRouter(_tokensForLP);
352                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
353                 }
354             }
355             uint256 _contractETHBalance = address(this).balance;
356             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
357         }
358     }
359 
360     function _swapTaxTokensForEth(uint256 tokenAmount) private {
361         _approveRouter(tokenAmount);
362         address[] memory path = new address[](2);
363         path[0] = address(this);
364         path[1] = _primarySwapRouter.WETH();
365         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
366     }
367 
368     function _distributeTaxEth(uint256 amount) private {
369         uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
370         if (_taxShareTotal > 0) {
371             uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
372             uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
373             if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
374             if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
375         }
376     }
377 
378     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
379         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
380         uint256 tokensToSwap = balanceOf(address(this)) * swapTokenPercent / 100;
381         if (tokensToSwap > 10 ** _decimals) {
382             _swapTaxTokensForEth(tokensToSwap);
383         }
384         if (sendEth) { 
385             uint256 ethBalance = address(this).balance;
386             require(ethBalance > 0, "No ETH");
387             _distributeTaxEth(address(this).balance); 
388         }
389     }
390 
391     function burn(uint256 amount) external {
392         uint256 _tokensAvailable = balanceOf(msg.sender);
393         require(amount <= _tokensAvailable, "balance too low");
394         _burnTokens(msg.sender, amount);
395         emit TokensBurned(msg.sender, amount);
396     }
397 }