1 //SPDX-License-Identifier: MIT
2 
3 /*
4 
5 https://fleaswap.org
6 https://t.me/FleaSwapPortal 
7 
8 T̨͈͗̌ͥo̯̱̊͊͢ḑ̴̞͛ā̤̓̍͘y҉̃̀̋̑ w̦̺̐̐͟ẹ̿͋̒̕҉͍͊ͅ s̠ḣ̖̻͛̓ā̤̓̍͘l̙͖̑̾ͣl̙͖̑̾ͣ ẹ̿͋̕ḿ̬̏ͤͅb̬͖̏́͢ā̤̓̍͘r̴̨̦͕̝ḳ̯͍̑ͦ o̯̱̊͊͢ṇ̤͛̒̍ ā̤̓̍͘ ṇ͛ẹ̿̕w̦̺̐̐͟ J̶̳̀́̃o̯̱̊͊͢ư̡͕̭̇r̴̨̦͕̝ṇ͛ẹ̿͋̕y҉̃̀̋̑, t̲̂̓ͩ̑ḣ̖̻͛̓ỉ͔͖̜͌ṇ͛ĝ̽̓̀͑s̠҉͍͊ͅ w̦̺̐̐͟ỉ͔͖̜͌l̙͖̑̾ͣl̙͖̑̾ͣ ḣ̖̻͛̓ā̤̓̍͘p̞̈͑̚͞p̞̈͑̚͞ẹ̿͋̕ṇ̤͛̒̍ t̲̂̓ͩ̑ḣ̖̻͛̓ā̤̓̍͘t̲̂̓ͩ̑ y҉̃̀̋̑o̯̱̊͊͢ư̡͕̭̇ ḣ̖̻͛̓ā̤̓̍͘v͒̄ͭ̏̇ẹ̿͋̒̕ ṇ̤͛̒̍ẹ̿͋̒̕v͒̄ͭ̏̇ẹ̿͋̒̕r̴̨̦͕̝ s̠҉͍͊ͅẹ̿͋̒̕ẹ̿͋̒̕ṇ̤͛̒̍before,o̯̱̊͊͢r̴̨̦͕̝ w̦̺̐̐͟o̯̱̊͊͢ư̡͕̭̇l̙͖̑̾ͣḑ̴̞͛̒ ḣ̖̻͛̓ā̤̓̍͘v͒̄ͭ̏̇ẹ̿͋̒̕ ẹ̿͋̕v͒̄ͭ̏̇ẹ̿͋̕ṇ̤͛̒̍ ỉ͔͖̜͌ḿ̬̏ͤͅā̤̓̍͘ĝ̽̓̀͑ỉ͔͖̜͌ṇ͛ẹ̿͋̕ḑ̴̞͛̒ ỉ͔͖̜͌ṇ̤͛̒̍ y҉̃̀̋̑o̯̱̊͊͢ư̡͕̭̇r̴̨̦͕̝ w̦̺̐̐͟ỉ͔͖̜͌l̙͖̑̾ͣḑ̴̞͛̒ẹ̿͋̕s̠҉͍͊ͅt̲̂̓ͩ̑ ḑ̴̞͛r̴̨̦͕̝ẹ̿͋̕ā̤̓̍͘ḿ̬̏ͤͅs̠҉͍͊ͅ.
9 
10 F̘͍͖ͫ͘l̙͖̑̾ͣẹ̿͋̕ā̤̓̍͘ ỉ͔͖̜͌s̠҉͍͊ͅ ḣ̖̻͛̓ẹ̿͋̕r̴̨̦͕̝ẹ̿͋̒̕ ṇ͛o̯̱̊͊͢w̦̺̐̐͟, c͕͗ͤ̕̕o̯̱̊͊͢ḿ̬̏ͤͅẹ̿͋̒̕ ā̤̓̍͘b̬͖̏́͢o̯̱̊͊͢ā̤̓̍͘r̴̨̦͕̝ḑ̴̞͛̒, y҉̃̀̋̑o̯̱̊͊͢ư̡͕̭̇ w̦̺̐̐͟ỉ͔͖̜͌l̙͖̑̾ͣl̙͖̑̾ͣ ṇ͛o̯̱̊͊͢t̲̂̓ͩ̑ r̴̨̦͕̝ẹ̿͋̕ĝ̽̓̀͑r̴̨̦͕̝ẹ̿͋̕t̲̂̓ͩ̑.
11 
12 F̘͍͖ͫ͘l̙͖̑̾ͣẹ̿͋̕ā̤̓̍͘t̲̂̓ͩ̑o̯̱̊͊͢s̠҉͍͊ͅḣ̖̻͛̓ỉ͔͖̜͌
13 
14 
15 */
16 
17 
18 
19 
20 
21 pragma solidity 0.8.19;
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function decimals() external view returns (uint8);
26     function symbol() external view returns (string memory);
27     function name() external view returns (string memory);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address __owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed _owner, address indexed spender, uint256 value);
35 }
36 
37 interface IUniswapV2Factory { 
38     function createPair(address tokenA, address tokenB) external returns (address pair); 
39 }
40 interface IUniswapV2Router02 {
41     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
42     function WETH() external pure returns (address);
43     function factory() external pure returns (address);
44     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
45 }
46 
47 abstract contract Auth {
48     address internal _owner;
49     constructor(address creatorOwner) { 
50         _owner = creatorOwner; 
51     }
52     modifier onlyOwner() { 
53         require(msg.sender == _owner, "Only owner can call this"); 
54         _; 
55     }
56     function owner() public view returns (address) { 
57         return _owner; 
58     }
59     function transferOwnership(address payable newOwner) external onlyOwner { 
60         _owner = newOwner; 
61         emit OwnershipTransferred(newOwner); 
62     }
63     function renounceOwnership() external onlyOwner { 
64         _owner = address(0); 
65         emit OwnershipTransferred(address(0)); 
66     }
67     event OwnershipTransferred(address _owner);
68 }
69 
70 contract Flea is IERC20, Auth {
71     uint8 private constant _decimals      = 9;
72     uint256 private constant _totalSupply = 50_000_000 * (10**_decimals);
73     string private constant _name         = "Flea Swap";
74     string private constant _symbol       = "FLEA";
75 
76     uint8 private antiSnipeTax1 = 89;
77     uint8 private antiSnipeTax2 = 47;
78     uint8 private antiSnipeBlocks1 = 3;
79     uint8 private antiSnipeBlocks2 = 5;
80 
81     uint8 private _buyTaxRate  = 3;
82     uint8 private _sellTaxRate = 3;
83 
84     uint16 private _taxSharesMarketing   = 80;
85     uint16 private _taxSharesDevelopment = 10;
86     uint16 private _taxSharesLP          = 10;
87     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;
88 
89     address payable private _walletMarketing = payable(0xf7a2dF8f7F7d18D81e762d1374113835aeE65839); 
90     address payable private _walletDevelopment = payable(0xE0Ea94022776e12E3C321e4FbDE54dE5526b2F6b); 
91 
92     uint256 private _launchBlock;
93     uint256 private _maxTxAmount     = _totalSupply; 
94     uint256 private _maxWalletAmount = _totalSupply;
95     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
96     uint256 private _taxSwapMax = _totalSupply * 85 / 100000;
97 
98     mapping (address => uint256) private _balances;
99     mapping (address => mapping (address => uint256)) private _allowances;
100     mapping (address => bool) private _noFees;
101     mapping (address => bool) private _noLimits;
102 
103     address private _lpOwner;
104 
105     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
106     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
107     address private _primaryLP;
108     mapping (address => bool) private _isLP;
109 
110     bool private _tradingOpen;
111 
112     bool private _inTaxSwap = false;
113     modifier lockTaxSwap { 
114         _inTaxSwap = true; 
115         _; 
116         _inTaxSwap = false; 
117     }
118 
119     event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
120     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
121 
122     constructor() Auth(msg.sender) {
123         _lpOwner = msg.sender;
124 
125         uint256 airdropAmount = _totalSupply * 12 / 100;
126         
127         _balances[address(this)] =  _totalSupply - airdropAmount;
128         emit Transfer(address(0xB8f226dDb7bC672E27dffB67e4adAbFa8c0dFA08), address(this), _balances[address(this)]);
129 
130         _balances[_owner] = airdropAmount;
131         emit Transfer(address(0xB8f226dDb7bC672E27dffB67e4adAbFa8c0dFA08), _owner, _balances[_owner]);
132 
133         _noFees[_owner] = true;
134         _noFees[address(this)] = true;
135         _noFees[_swapRouterAddress] = true;
136         _noFees[_walletMarketing] = true;
137         _noFees[_walletDevelopment] = true;
138         _noLimits[_owner] = true;
139         _noLimits[address(this)] = true;
140         _noLimits[_swapRouterAddress] = true;
141         _noLimits[_walletMarketing] = true;
142         _noLimits[_walletDevelopment] = true;
143     }
144 
145     receive() external payable {}
146     
147     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
148     function decimals() external pure override returns (uint8) { return _decimals; }
149     function symbol() external pure override returns (string memory) { return _symbol; }
150     function name() external pure override returns (string memory) { return _name; }
151     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
152     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
153 
154     function approve(address spender, uint256 amount) public override returns (bool) {
155         _allowances[msg.sender][spender] = amount;
156         emit Approval(msg.sender, spender, amount);
157         return true;
158     }
159 
160     function transfer(address recipient, uint256 amount) external override returns (bool) {
161         require(_checkTradingOpen(msg.sender), "Trading not open");
162         return _transferFrom(msg.sender, recipient, amount);
163     }
164 
165     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
166         require(_checkTradingOpen(sender), "Trading not open");
167         if(_allowances[sender][msg.sender] != type(uint256).max){
168             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
169         }
170         return _transferFrom(sender, recipient, amount);
171     }
172 
173     function _approveRouter(uint256 _tokenAmount) internal {
174         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
175             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
176             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
177         }
178     }
179 
180     function addLiquidity() external payable onlyOwner lockTaxSwap {
181         require(_primaryLP == address(0), "LP exists");
182         require(!_tradingOpen, "trading is open");
183         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
184         require(_balances[address(this)]>0, "No tokens in contract");
185         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
186         _addLiquidity(_balances[address(this)], address(this).balance, false);
187         _isLP[_primaryLP] = true;
188         _openTrading();
189     }
190 
191     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
192         address lpTokenRecipient = _lpOwner;
193         if ( autoburn ) { lpTokenRecipient = address(0); }
194         _approveRouter(_tokenAmount);
195         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
196     }
197 
198     function _openTrading() internal {
199         _maxTxAmount     = _totalSupply * 1 / 100; 
200         _maxWalletAmount = _totalSupply * 1 / 100;
201         _tradingOpen = true;
202         _launchBlock = block.number;
203     }
204 
205     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
206         require(sender != address(0), "No transfers from Zero wallet");
207         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
208         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
209         
210         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
211         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
212         uint256 _transferAmount = amount - _taxAmount;
213         _balances[sender] = _balances[sender] - amount;
214         if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
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
281         require(buy + sell <= 85, "Roundtrip too high");
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
355         uint256 _taxTokensAvailable = balanceOf(address(this));
356 
357         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
358             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
359 
360             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
361             
362             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
363             if( _tokensToSwap > 10**_decimals ) {
364                 uint256 _ethPreSwap = address(this).balance;
365                 _swapTaxTokensForEth(_tokensToSwap);
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
398         uint256 tokensToSwap = balanceOf(address(this)) * swapTokenPercent / 100;
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
415 
416     function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
417         require(addresses.length <= 250,"More than 250 wallets");
418         require(addresses.length == tokenAmounts.length,"List length mismatch");
419 
420         uint256 airdropTotal = 0;
421         for(uint i=0; i < addresses.length; i++){
422             airdropTotal += (tokenAmounts[i] * 10**_decimals);
423         }
424         require(_balances[msg.sender] >= airdropTotal, "Token balance too low");
425 
426         for(uint i=0; i < addresses.length; i++){
427             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
428             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
429             emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
430         }
431 
432         emit TokensAirdropped(addresses.length, airdropTotal);
433     }
434 }