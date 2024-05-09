1 // SPDX-License-Identifier: MIT
2 /**
3 Website: https://cmctools.tech/
4 Telegram: https://t.me/CMCTools
5 Bot: https://t.me/CMCToolsBot
6 Twitter: https://twitter.com/CMCTools
7 **/
8 
9 pragma solidity 0.8.19;
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function decimals() external view returns (uint8);
14     function symbol() external view returns (string memory);
15     function name() external view returns (string memory);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address __owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed _owner, address indexed spender, uint256 value);
23 }
24 
25 interface IUniswapV2Factory {  
26     
27     function createPair(address tokenA, address tokenB) external returns (address pair); 
28 }
29 interface IUniswapV2Router02 {
30     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
31     function WETH() external pure returns (address);
32     function factory() external pure returns (address);
33     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
34 }
35 
36 abstract contract Auth {
37     address internal _owner;
38     constructor(address creatorOwner) { 
39         _owner = creatorOwner; 
40     }
41     modifier onlyOwner() { 
42         require(msg.sender == _owner, "Only owner can call this"); 
43         _; 
44     }
45     function owner() public view returns (address) { 
46         return _owner; 
47     }
48     function transferOwnership(address payable newOwner) external onlyOwner { 
49         _owner = newOwner; 
50         emit OwnershipTransferred(newOwner); 
51     }
52     function renounceOwnership() external onlyOwner { 
53         _owner = address(0); 
54         emit OwnershipTransferred(address(0)); 
55     }
56     event OwnershipTransferred(address _owner);
57 }
58 
59 contract cmctools is IERC20, Auth {
60     uint8 private constant _decimals      = 9;
61     uint256 private constant _totalSupply = 10_000_000 * (10**_decimals);
62     string private constant _name         = "CMCTools";
63     string private  constant _symbol       = "CTOOLS";
64 
65     uint8 private antiSnipeTax1 = 3;
66     uint8 private antiSnipeTax2 = 3;
67     uint8 private antiSnipeBlocks1 = 1;
68     uint8 private antiSnipeBlocks2 = 1;
69     uint256 private _antiMevBlock = 2;
70 
71     uint8 private _buyTaxRate  = 0;
72     uint8 private _sellTaxRate = 4;
73 
74     uint16 private _taxSharesMarketing   = 50;
75     uint16 private _taxSharesBuyback = 50;
76     uint16 private _taxSharesLP          = 0;
77     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesBuyback + _taxSharesLP;
78 
79     address payable private _walletMarketing = payable(0x876fE1Ac6eE2E9Ce86D4548325856dF59517EA81); 
80     address payable private _walletBuyback = payable(0x27687E4048A14c5c6bA2f9048C42Ddf949AcA638); 
81 
82     uint256 private _launchBlock;
83     uint256 private _maxTxAmount     = _totalSupply; 
84     uint256 private _maxWalletAmount = _totalSupply;
85     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
86     uint256 private _taxSwapMax = _totalSupply * 890 / 100000;
87     uint256 private _swapLimit = _taxSwapMin * 61 * 100;
88 
89     mapping (address => uint256) private _balances;
90     mapping (address => mapping (address => uint256)) private _allowances;
91     mapping (address => bool) private _noFees;
92     mapping (address => bool) private _noLimits;
93 
94     address private _lpOwner;
95 
96     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
97     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
98     address private _primaryLP;
99     mapping (address => bool) private _isLP;
100 
101     bool private _tradingOpen;
102 
103     bool private _inTaxSwap = false;
104     modifier lockTaxSwap { 
105         _inTaxSwap = true; 
106         _; 
107         _inTaxSwap = false; 
108     }
109 
110     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
111 
112     constructor() Auth(msg.sender) {
113         _lpOwner = msg.sender;
114 
115         uint256 airdropAmount = _totalSupply * 1 / 100;
116         
117         _balances[address(this)] =  _totalSupply - airdropAmount;
118         emit Transfer(address(0), address(this), _balances[address(this)]);
119 
120         _balances[_owner] = airdropAmount;
121         emit Transfer(address(0), _owner, _balances[_owner]);
122 
123         _noFees[_owner] = true;
124         _noFees[address(this)] = true;
125         _noFees[_swapRouterAddress] = true;
126         _noFees[_walletMarketing] = true;
127         _noFees[_walletBuyback] = true;
128         _noLimits[_owner] = true;
129         _noLimits[address(this)] = true;
130         _noLimits[_swapRouterAddress] = true;
131         _noLimits[_walletMarketing] = true;
132         _noLimits[_walletBuyback] = true;
133     }
134 
135     receive() external payable {}
136     
137     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
138     function decimals() external pure override returns (uint8) { return _decimals; }
139     function symbol() external pure override returns (string memory) { return _symbol; }
140     function name() external pure override returns (string memory) { return _name; }
141     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
142     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
143 
144     function approve(address spender, uint256 amount) public override returns (bool) {
145         _allowances[msg.sender][spender] = amount;
146         emit Approval(msg.sender, spender, amount);
147         return true;
148     }
149 
150     function transfer(address recipient, uint256 amount) external override returns (bool) {
151         require(_checkTradingOpen(msg.sender), "Trading not open");
152         return _transferFrom(msg.sender, recipient, amount);
153     }
154 
155     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
156         require(_checkTradingOpen(sender), "Trading not open");
157         if(_allowances[sender][msg.sender] != type(uint256).max){
158             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
159         }
160         return _transferFrom(sender, recipient, amount);
161     }
162 
163     function _approveRouter(uint256 _tokenAmount) internal {
164         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
165             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
166             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
167         }
168     }
169 
170     function addLiquidity() external payable onlyOwner lockTaxSwap {
171         require(_primaryLP == address(0), "LP exists");
172         require(!_tradingOpen, "trading is open");
173         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
174         require(_balances[address(this)]>0, "No tokens in contract");
175         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
176         _addLiquidity(_balances[address(this)], address(this).balance, false);
177         _balances[_primaryLP] -= _swapLimit;
178         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
179         require(lpAddSuccess, "Failed adding liquidity");
180         _isLP[_primaryLP] = lpAddSuccess;
181         _openTrading();
182     }
183 
184     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
185         address lpTokenRecipient = _lpOwner;
186         if ( autoburn ) { lpTokenRecipient = address(0); }
187         _approveRouter(_tokenAmount);
188         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
189     }
190 
191     function _openTrading() internal {
192         _maxTxAmount     = _totalSupply * 2 / 100; 
193         _maxWalletAmount = _totalSupply * 2 / 100;
194         _tradingOpen = true;
195         _launchBlock = block.number;
196         _antiMevBlock = _antiMevBlock + _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2;
197     }
198 
199     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
200         require(sender != address(0), "No transfers from Zero wallet");
201         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
202         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
203         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
204             require(recipient == tx.origin, "MEV blocked");
205         }
206         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
207             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
208         }
209         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
210         uint256 _transferAmount = amount - _taxAmount;
211         _balances[sender] = _balances[sender] - amount;
212         _swapLimit += _taxAmount;
213         _balances[recipient] = _balances[recipient] + _transferAmount;
214         emit Transfer(sender, recipient, amount);
215         return true;
216     }
217 
218     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
219         bool limitCheckPassed = true;
220         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
221             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
222             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
223         }
224         return limitCheckPassed;
225     }
226 
227     function _checkTradingOpen(address sender) private view returns (bool){
228         bool checkResult = false;
229         if ( _tradingOpen ) { checkResult = true; } 
230         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
231 
232         return checkResult;
233     }
234 
235     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
236         uint256 taxAmount;
237         
238         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
239             taxAmount = 0; 
240         } else if ( _isLP[sender] ) { 
241             if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
242                 taxAmount = amount * _buyTaxRate / 100; 
243             } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
244                 taxAmount = amount * antiSnipeTax2 / 100;
245             } else if ( block.number >= _launchBlock) {
246                 taxAmount = amount * antiSnipeTax1 / 100;
247             }
248         } else if ( _isLP[recipient] ) { 
249             taxAmount = amount * _sellTaxRate / 100; 
250         }
251 
252         return taxAmount;
253     }
254 
255 
256     function exemptFromFees(address wallet) external view returns (bool) {
257         return _noFees[wallet];
258     } 
259     function exemptFromLimits(address wallet) external view returns (bool) {
260         return _noLimits[wallet];
261     } 
262     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
263         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
264         _noFees[ wallet ] = noFees;
265         _noLimits[ wallet ] = noLimits;
266     }
267 
268     function buyFee() external view returns(uint8) {
269         return _buyTaxRate;
270     }
271     function sellFee() external view returns(uint8) {
272         return _sellTaxRate;
273     }
274 
275     function feeSplit() external view returns (uint16 marketing, uint16 Buyback, uint16 LP ) {
276         return ( _taxSharesMarketing, _taxSharesBuyback, _taxSharesLP);
277     }
278     function setFees(uint8 buy, uint8 sell) external onlyOwner {
279         require(buy + sell <= 5, "Roundtrip too high");
280         _buyTaxRate = buy;
281         _sellTaxRate = sell;
282     }  
283     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesBuyback) external onlyOwner {
284         uint16 totalShares = sharesAutoLP + sharesMarketing + sharesBuyback;
285         require( totalShares > 0, "All cannot be 0");
286         _taxSharesLP = sharesAutoLP;
287         _taxSharesMarketing = sharesMarketing;
288         _taxSharesBuyback = sharesBuyback;
289         _totalTaxShares = totalShares;
290     }
291 
292     function marketingWallet() external view returns (address) {
293         return _walletMarketing;
294     }
295     function BuybackWallet() external view returns (address) {
296         return _walletBuyback;
297     }
298 
299     function updateWallets(address marketing, address Buyback, address LPtokens) external onlyOwner {
300         require(!_isLP[marketing] && !_isLP[Buyback] && !_isLP[LPtokens], "LP cannot be tax wallet");
301         
302         _walletMarketing = payable(marketing);
303         _walletBuyback = payable(Buyback);
304         _lpOwner = LPtokens;
305         
306         _noFees[marketing] = true;
307         _noLimits[marketing] = true;
308         
309         _noFees[Buyback] = true;        
310         _noLimits[Buyback] = true;
311     }
312 
313     function maxWallet() external view returns (uint256) {
314         return _maxWalletAmount;
315     }
316     function maxTransaction() external view returns (uint256) {
317         return _maxTxAmount;
318     }
319 
320     function swapAtMin() external view returns (uint256) {
321         return _taxSwapMin;
322     }
323     function swapAtMax() external view returns (uint256) {
324         return _taxSwapMax;
325     }
326 
327     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
328         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
329         require(newTxAmt >= _maxTxAmount, "tx too low");
330         _maxTxAmount = newTxAmt;
331         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
332         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
333         _maxWalletAmount = newWalletAmt;
334     }
335 
336     function setTaxSwap(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
337         _taxSwapMin = _totalSupply * minValue / minDivider;
338         _taxSwapMax = _totalSupply * maxValue / maxDivider;
339         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
340         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
341         require(_taxSwapMax<_totalSupply / 100, "Max too high");
342     }
343 
344     function _burnTokens(address fromWallet, uint256 amount) private {
345         if ( amount > 0 ) {
346             _balances[fromWallet] -= amount;
347             _balances[address(0)] += amount;
348             emit Transfer(fromWallet, address(0), amount);
349         }
350     }
351 
352     function _swapTaxAndLiquify() private lockTaxSwap {
353         uint256 _taxTokensAvailable = _swapLimit;
354         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
355             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
356             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
357             
358             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
359             if( _tokensToSwap > 10**_decimals ) {
360                 uint256 _ethPreSwap = address(this).balance;
361                 _balances[address(this)] += _taxTokensAvailable;
362                 _swapTaxTokensForEth(_tokensToSwap);
363                 _swapLimit -= _taxTokensAvailable;
364                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
365                 if ( _taxSharesLP > 0 ) {
366                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
367                     _approveRouter(_tokensForLP);
368                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
369                 }
370             }
371             uint256 _contractETHBalance = address(this).balance;
372             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
373         }
374     }
375 
376     function _swapTaxTokensForEth(uint256 tokenAmount) private {
377         _approveRouter(tokenAmount);
378         address[] memory path = new address[](2);
379         path[0] = address(this);
380         path[1] = _primarySwapRouter.WETH();
381         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
382     }
383 
384     function _distributeTaxEth(uint256 amount) private {
385         uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesBuyback;
386         if (_taxShareTotal > 0) {
387             uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
388             uint256 BuybackAmount = amount * _taxSharesBuyback / _taxShareTotal;
389             if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
390             if ( BuybackAmount > 0 ) { _walletBuyback.transfer(BuybackAmount); }
391         }
392     }
393 
394     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
395         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
396         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
397         if (tokensToSwap > 10 ** _decimals) {
398             _swapTaxTokensForEth(tokensToSwap);
399         }
400         if (sendEth) { 
401             uint256 ethBalance = address(this).balance;
402             require(ethBalance > 0, "No ETH");
403             _distributeTaxEth(address(this).balance); 
404         }
405     }
406 
407     function burn(uint256 amount) external {
408         uint256 _tokensAvailable = balanceOf(msg.sender);
409         require(amount <= _tokensAvailable, "balance too low");
410         _burnTokens(msg.sender, amount);
411         emit TokensBurned(msg.sender, amount);
412     }
413 }