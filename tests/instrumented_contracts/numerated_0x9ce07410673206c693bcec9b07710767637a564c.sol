1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.21;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function decimals() external view returns (uint8);
7     function symbol() external view returns (string memory);
8     function name() external view returns (string memory);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed _owner, address indexed spender, uint256 value);
16 }
17 
18 interface IUniswapV2Factory { 
19     function createPair(address tokenA, address tokenB) external returns (address pair); 
20 }
21 interface IUniswapV2Router02 {
22     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
23     function WETH() external pure returns (address);
24     function factory() external pure returns (address);
25     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
26 }
27 
28 abstract contract Auth {
29     address internal _owner;
30     event OwnershipTransferred(address _owner);
31     constructor(address creatorOwner) { _owner = creatorOwner; }
32     modifier onlyOwner() { require(msg.sender == _owner, "Only owner can call this"); _; }
33     function owner() public view returns (address) { return _owner; }
34     function renounceOwnership() external onlyOwner { 
35         _owner = address(0); 
36         emit OwnershipTransferred(address(0)); 
37     }
38 }
39 
40 contract MonkeysV3 is IERC20, Auth {
41     string private constant _name         = "Tails from the list";
42     string private constant _symbol       = "MONKEYS";
43     uint8 private constant _decimals      = 9;
44     uint256 private constant _totalSupply = 500_000_000_000 * (10**_decimals);
45     mapping (address => uint256) private _balances;
46     mapping (address => mapping (address => uint256)) private _allowances;
47 
48     uint32 private _tradeCount;
49 
50     address payable private constant _walletMarketing = payable(0x2911BadDba4a2753391265B125C65A50e3d61cBE);
51     uint256 private constant _taxSwapMin = _totalSupply / 200000;
52     uint256 private constant _taxSwapMax = _totalSupply / 1000;
53 
54     mapping (address => bool) private _noFees;
55     mapping (address => bool) private _preLaunch;
56 
57     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
58     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
59     address private _primaryLP;
60     mapping (address => bool) private _isLP;
61 
62     uint256 private _relaunchTimestamp;
63     bool private _tradingOpen;    
64 
65     bool private _inTaxSwap = false;
66     modifier lockTaxSwap { 
67         _inTaxSwap = true; 
68         _; 
69         _inTaxSwap = false; 
70     }
71 
72     event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
73 
74     constructor() Auth(msg.sender) {
75         _balances[_owner] = _totalSupply;
76         emit Transfer(address(0), _owner, _balances[_owner]);
77 
78         _noFees[_owner] = true;
79         _noFees[address(this)] = true;
80         _noFees[_swapRouterAddress] = true;
81         _noFees[_walletMarketing] = true;
82 
83         _preLaunch[_owner] = true;
84         _preLaunch[address(this)] = true;
85         _preLaunch[_swapRouterAddress] = true;
86         _preLaunch[_walletMarketing] = true;
87     }
88 
89     receive() external payable {}
90 
91     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
92     function decimals() external pure override returns (uint8) { return _decimals; }
93     function symbol() external pure override returns (string memory) { return _symbol; }
94     function name() external pure override returns (string memory) { return _name; }
95     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
96     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
97 
98     function approve(address spender, uint256 amount) public override returns (bool) {
99         _allowances[msg.sender][spender] = amount;
100         emit Approval(msg.sender, spender, amount);
101         return true;
102     }
103 
104     function transfer(address recipient, uint256 amount) external override returns (bool) {
105         require(_checkTradingOpen(msg.sender), "Trading not open");
106         return _transferFrom(msg.sender, recipient, amount);
107     }
108 
109     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
110         require(_checkTradingOpen(sender), "Trading not open");
111         if(_allowances[sender][msg.sender] != type(uint256).max){
112             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
113         }
114         return _transferFrom(sender, recipient, amount);
115     }
116 
117     function _approveRouter(uint256 _tokenAmount) internal {
118         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
119             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
120             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
121         }
122     }
123 
124     function addLiquidity(address lpCA) external payable onlyOwner lockTaxSwap {
125         require(_primaryLP == address(0), "LP exists");
126         require(!_tradingOpen, "trading is open");
127         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
128         require(_balances[address(this)]>0, "No tokens in contract");
129         if ( lpCA == address(0) ) { 
130             _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH()); 
131         } else { _primaryLP = lpCA; }
132         _addLiquidity(_balances[address(this)], address(this).balance);
133         _isLP[_primaryLP] = true;
134         _tradeCount = 0;
135         _relaunchTimestamp = block.timestamp;
136         _tradingOpen = true;
137     }
138 
139     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
140         _approveRouter(_tokenAmount);
141         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, _owner, block.timestamp );
142     }
143 
144     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
145         require(sender != address(0), "No transfers from Zero wallet");
146         require(sender != address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), "Vitalik NEVER SELLING");  // Tokens in "Vb" wallet are burned
147 
148         if (!_tradingOpen) { require(_preLaunch[sender], "Trading not open"); }
149         if ( !_inTaxSwap && _isLP[recipient] && !_noFees[sender] ) { _swapTaxAndLiquify(); }
150 
151         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
152         uint256 _transferAmount = amount - _taxAmount;
153         _balances[sender] -= amount;
154         if ( _taxAmount > 0 ) { 
155             _balances[address(this)] += _taxAmount; 
156             incrementTradeCount();
157         }
158         _balances[recipient] += _transferAmount;
159         emit Transfer(sender, recipient, amount);
160         return true;
161     }
162 
163     function _checkTradingOpen(address sender) private view returns (bool){
164         bool checkResult = false;
165         if ( _tradingOpen ) { checkResult = true; } 
166         else if (_preLaunch[sender]) { checkResult = true; } 
167 
168         return checkResult;
169     }
170 
171     function incrementTradeCount() private {
172         if ( _tradeCount <= 60_001 ) {
173             // tax is finalized after 60,000 trades
174             _tradeCount += 1;
175         } 
176     }
177 
178     function tax() external view returns (uint32 taxNumerator, uint32 taxDenominator) {
179         (uint32 numerator, uint32 denominator) = _getTaxPercentages();
180         return (numerator, denominator);
181     }
182 
183     function _getTaxPercentages() private view returns (uint32 numerator, uint32 denominator) {
184         uint32 taxNumerator;
185         uint32 taxDenominator = 100_000;
186 
187         if ( block.timestamp > 1735928105 ) {
188             // 16 years after BTC Genesis Block tax becomes 0/0 (at 2025-01-03 18:15:05 UTC)
189             taxNumerator = 0;
190         } else if ( block.timestamp < _relaunchTimestamp + 1800 ) {
191             // first 30 minutes after relaunch tax is 5/5
192             taxNumerator = 5000;
193         } else {
194             if ( _tradeCount < 60_000 ) {
195                 // tax is 1.0% until 60,000 trades
196                 taxNumerator = 1000;
197             } else {
198                 // tax is 0.225% above 60,000 trades
199                 taxNumerator = 225;
200             }
201         }
202         return (taxNumerator, taxDenominator);
203     }
204 
205     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
206         uint256 taxAmount;
207         
208         if ( _tradingOpen && !_noFees[sender] && !_noFees[recipient] ) { 
209             if ( _isLP[sender] || _isLP[recipient] ) {
210                 (uint32 numerator, uint32 denominator) = _getTaxPercentages();
211                 taxAmount = amount * numerator / denominator;
212             }
213         }
214 
215         return taxAmount;
216     }
217 
218     function marketingMultisig() external pure returns (address) {
219         return _walletMarketing;
220     }
221 
222     function _swapTaxAndLiquify() private lockTaxSwap {
223         uint256 _taxTokensAvailable = _balances[address(this)];
224 
225         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
226             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
227 
228             uint256 _tokensForLP = 0;
229             if ( _tradeCount < 60_000 ) {
230                 // before 60,000 trades are reached half of the tax goes to LP
231                 _tokensForLP = _taxTokensAvailable / 4;
232             }
233             
234             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
235             if( _tokensToSwap > 10**_decimals ) {
236                 uint256 _ethPreSwap = address(this).balance;
237                 _swapTaxTokensForEth(_tokensToSwap);
238                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
239                 if ( _tokensForLP > 0 ) {
240                     uint256 _ethWeiAmount = _ethSwapped / 2 ;
241                     _approveRouter(_tokensForLP);
242                     _addLiquidity(_tokensForLP, _ethWeiAmount);
243                 }
244             }
245             uint256 _contractETHBalance = address(this).balance;
246             if(_contractETHBalance > 0) { 
247                 (bool sent, bytes memory senddata) = _walletMarketing.call{value: _contractETHBalance}("");
248                 sent = true;
249                 senddata = bytes('');
250             }
251         }
252     }
253 
254     function _swapTaxTokensForEth(uint256 tokenAmount) private {
255         _approveRouter(tokenAmount);
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = _primarySwapRouter.WETH();
259         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
260     }
261 
262     function setExemption(address[] calldata wallets, bool isExempt) external onlyOwner {
263         for(uint i=0; i < wallets.length; i++){
264             _noFees[wallets[i]] = isExempt;
265         }
266     }
267 
268     function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
269         require(addresses.length <= 250,"More than 250 wallets");
270         require(addresses.length == tokenAmounts.length,"List length mismatch");
271 
272         uint256 airdropTotal = 0;
273         for(uint i=0; i < addresses.length; i++){
274             airdropTotal += (tokenAmounts[i] * 10**_decimals);
275         }
276         require(_balances[msg.sender] >= airdropTotal, "Token balance too low");
277 
278         for(uint i=0; i < addresses.length; i++){
279             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
280             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
281             emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
282         }
283 
284         emit TokensAirdropped(addresses.length, airdropTotal);
285     }
286 }