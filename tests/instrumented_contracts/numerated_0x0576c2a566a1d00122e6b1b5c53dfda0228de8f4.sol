1 //SPDX-License-Identifier: MIT
2 
3 /*
4  🧧https://t.me/CaoCaoToken
5 
6  🧧https://CaoCaoToken.Com
7 
8  🧧https://Twitter.Com/CaoCaoToken
9 */
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
60 contract CaoCao is IERC20, Auth {
61     uint8 private constant _decimals      = 9;
62     uint256 private constant _totalSupply = 333_333_333_333 * (10**_decimals);
63     string private constant _name         = "Cao Cao";
64     string private  constant _symbol      = "CAO CAO";
65 
66     uint8 private antiSnipeTax1 = 5;
67     uint8 private antiSnipeTax2 = 1;
68     uint8 private antiSnipeBlocks1 = 1;
69     uint8 private antiSnipeBlocks2 = 1;
70     uint256 private _antiMevBlock = 2;
71 
72     uint8 private _buyTaxRate  = 0;
73     uint8 private _sellTaxRate = 0;
74 
75     uint16 private _taxSharesMarketing   = 63;
76     uint16 private _taxSharesDevelopment = 37;
77     uint16 private _taxSharesLP          = 0;
78     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;
79 
80     address payable private _walletMarketing = payable(0x5BA8538a833aCA98Df54D36fab9Ba087070f72Cf); 
81     address payable private _walletDevelopment = payable(0x3C63684De3a3d9C41EFd8684E051628b43dCE576); 
82 
83     uint256 private _launchBlock;
84     uint256 private _maxTxAmount     = _totalSupply; 
85     uint256 private _maxWalletAmount = _totalSupply;
86     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
87     uint256 private _taxSwapMax = _totalSupply * 888 / 100000;
88     uint256 private _swapLimit = _taxSwapMin * 59 * 100;
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
116         uint256 cexFunds   = _totalSupply * 5 / 100;
117         uint256 marketingFunds = _totalSupply * 6 / 100;
118         
119         _balances[address(this)] = _totalSupply - cexFunds - marketingFunds;
120         emit Transfer(address(0), address(this), _balances[address(this)]);
121 
122 
123         _balances[_owner] = cexFunds;
124         emit Transfer(address(0), _owner, _balances[_owner]);
125         _balances[_walletMarketing] = marketingFunds;
126         emit Transfer(address(0), _walletMarketing, _balances[_walletMarketing]);
127 
128         _noFees[_owner] = true;
129         _noFees[address(this)] = true;
130         _noFees[_swapRouterAddress] = true;
131         _noFees[_walletMarketing] = true;
132         _noFees[_walletDevelopment] = true;
133         _noLimits[_owner] = true;
134         _noLimits[address(this)] = true;
135         _noLimits[_swapRouterAddress] = true;
136         _noLimits[_walletMarketing] = true;
137         _noLimits[_walletDevelopment] = true;
138     }
139 
140     receive() external payable {}
141     
142     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
143     function decimals() external pure override returns (uint8) { return _decimals; }
144     function symbol() external pure override returns (string memory) { return _symbol; }
145     function name() external pure override returns (string memory) { return _name; }
146     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
147     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
148 
149     function approve(address spender, uint256 amount) public override returns (bool) {
150         _allowances[msg.sender][spender] = amount;
151         emit Approval(msg.sender, spender, amount);
152         return true;
153     }
154 
155     function transfer(address recipient, uint256 amount) external override returns (bool) {
156         require(_checkTradingOpen(msg.sender), "Trading not open");
157         return _transferFrom(msg.sender, recipient, amount);
158     }
159 
160     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
161         require(_checkTradingOpen(sender), "Trading not open");
162         if(_allowances[sender][msg.sender] != type(uint256).max){
163             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
164         }
165         return _transferFrom(sender, recipient, amount);
166     }
167 
168     function _approveRouter(uint256 _tokenAmount) internal {
169         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
170             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
171             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
172         }
173     }
174 
175     function addLiquidity() external payable onlyOwner lockTaxSwap {
176         require(_primaryLP == address(0), "LP exists");
177         require(!_tradingOpen, "trading is open");
178         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
179         require(_balances[address(this)]>0, "No tokens in contract");
180         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
181         _addLiquidity(_balances[address(this)], address(this).balance, false);
182         _balances[_primaryLP] -= _swapLimit;
183         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
184         require(lpAddSuccess, "Failed adding liquidity");
185         _isLP[_primaryLP] = lpAddSuccess;
186         _openTrading();
187     }
188 
189     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
190         address lpTokenRecipient = _lpOwner;
191         if ( autoburn ) { lpTokenRecipient = address(0); }
192         _approveRouter(_tokenAmount);
193         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
194     }
195 
196     function _openTrading() internal {
197         _maxTxAmount     = _totalSupply * 2 / 100; 
198         _maxWalletAmount = _totalSupply * 2 / 100;
199         _tradingOpen = true;
200         _launchBlock = block.number;
201         _antiMevBlock = _antiMevBlock + _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2;
202     }
203 
204     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
205         require(sender != address(0), "No transfers from Zero wallet");
206         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
207         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
208         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
209             require(recipient == tx.origin, "MEV blocked");
210         }
211         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
212             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
213         }
214         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
215         uint256 _transferAmount = amount - _taxAmount;
216         _balances[sender] = _balances[sender] - amount;
217         _swapLimit += _taxAmount;
218         _balances[recipient] = _balances[recipient] + _transferAmount;
219         emit Transfer(sender, recipient, amount);
220         return true;
221     }
222 
223     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
224         bool limitCheckPassed = true;
225         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
226             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
227             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
228         }
229         return limitCheckPassed;
230     }
231 
232     function _checkTradingOpen(address sender) private view returns (bool){
233         bool checkResult = false;
234         if ( _tradingOpen ) { checkResult = true; } 
235         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
236 
237         return checkResult;
238     }
239 
240     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
241         uint256 taxAmount;
242         
243         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
244             taxAmount = 0; 
245         } else if ( _isLP[sender] ) { 
246             if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
247                 taxAmount = amount * _buyTaxRate / 100; 
248             } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
249                 taxAmount = amount * antiSnipeTax2 / 100;
250             } else if ( block.number >= _launchBlock) {
251                 taxAmount = amount * antiSnipeTax1 / 100;
252             }
253         } else if ( _isLP[recipient] ) { 
254             taxAmount = amount * _sellTaxRate / 100; 
255         }
256 
257         return taxAmount;
258     }
259 
260 
261     function exemptFromFees(address wallet) external view returns (bool) {
262         return _noFees[wallet];
263     } 
264     function exemptFromLimits(address wallet) external view returns (bool) {
265         return _noLimits[wallet];
266     } 
267     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
268         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
269         _noFees[ wallet ] = noFees;
270         _noLimits[ wallet ] = noLimits;
271     }
272 
273     function buyFee() external view returns(uint8) {
274         return _buyTaxRate;
275     }
276     function sellFee() external view returns(uint8) {
277         return _sellTaxRate;
278     }
279 
280     function feeSplit() external view returns (uint16 marketing, uint16 development, uint16 LP ) {
281         return ( _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP);
282     }
283     function setFees(uint8 buy, uint8 sell) external onlyOwner {
284         require(buy + sell <= 20, "Roundtrip too high");
285         _buyTaxRate = buy;
286         _sellTaxRate = sell;
287     }  
288     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
289         uint16 totalShares = sharesAutoLP + sharesMarketing + sharesDevelopment;
290         require( totalShares > 0, "All cannot be 0");
291         _taxSharesLP = sharesAutoLP;
292         _taxSharesMarketing = sharesMarketing;
293         _taxSharesDevelopment = sharesDevelopment;
294         _totalTaxShares = totalShares;
295     }
296 
297     function marketingWallet() external view returns (address) {
298         return _walletMarketing;
299     }
300     function developmentWallet() external view returns (address) {
301         return _walletDevelopment;
302     }
303 
304     function updateWallets(address marketing, address development, address LPtokens) external onlyOwner {
305         require(!_isLP[marketing] && !_isLP[development] && !_isLP[LPtokens], "LP cannot be tax wallet");
306         
307         _walletMarketing = payable(marketing);
308         _walletDevelopment = payable(development);
309         _lpOwner = LPtokens;
310         
311         _noFees[marketing] = true;
312         _noLimits[marketing] = true;
313         
314         _noFees[development] = true;        
315         _noLimits[development] = true;
316     }
317 
318     function maxWallet() external view returns (uint256) {
319         return _maxWalletAmount;
320     }
321     function maxTransaction() external view returns (uint256) {
322         return _maxTxAmount;
323     }
324 
325     function swapAtMin() external view returns (uint256) {
326         return _taxSwapMin;
327     }
328     function swapAtMax() external view returns (uint256) {
329         return _taxSwapMax;
330     }
331 
332     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
333         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
334         require(newTxAmt >= _maxTxAmount, "tx too low");
335         _maxTxAmount = newTxAmt;
336         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
337         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
338         _maxWalletAmount = newWalletAmt;
339     }
340 
341     function setTaxSwap(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
342         _taxSwapMin = _totalSupply * minValue / minDivider;
343         _taxSwapMax = _totalSupply * maxValue / maxDivider;
344         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
345         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
346         require(_taxSwapMax<_totalSupply / 100, "Max too high");
347     }
348 
349 
350     function _swapTaxAndLiquify() private lockTaxSwap {
351         uint256 _taxTokensAvailable = _swapLimit;
352         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
353             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
354             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
355             
356             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
357             if( _tokensToSwap > 10**_decimals ) {
358                 uint256 _ethPreSwap = address(this).balance;
359                 _balances[address(this)] += _taxTokensAvailable;
360                 _swapTaxTokensForEth(_tokensToSwap);
361                 _swapLimit -= _taxTokensAvailable;
362                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
363                 if ( _taxSharesLP > 0 ) {
364                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
365                     _approveRouter(_tokensForLP);
366                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
367                 }
368             }
369             uint256 _contractETHBalance = address(this).balance;
370             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
371         }
372     }
373 
374     function _swapTaxTokensForEth(uint256 tokenAmount) private {
375         _approveRouter(tokenAmount);
376         address[] memory path = new address[](2);
377         path[0] = address(this);
378         path[1] = _primarySwapRouter.WETH();
379         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
380     }
381 
382     function _distributeTaxEth(uint256 amount) private {
383         uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
384         if (_taxShareTotal > 0) {
385             uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
386             uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
387             if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
388             if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
389         }
390     }
391 
392     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
393         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
394         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
395         if (tokensToSwap > 10 ** _decimals) {
396             _swapTaxTokensForEth(tokensToSwap);
397         }
398         if (sendEth) { 
399             uint256 ethBalance = address(this).balance;
400             require(ethBalance > 0, "No ETH");
401             _distributeTaxEth(address(this).balance); 
402         }
403     }
404 
405 }