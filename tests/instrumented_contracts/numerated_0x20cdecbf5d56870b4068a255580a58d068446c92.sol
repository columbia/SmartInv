1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
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
40 contract MonkeysToken is IERC20, Auth {
41     string private constant _name         = "Monkeys Token";
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
55 
56     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
57     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
58     address private _primaryLP;
59     mapping (address => bool) private _isLP;
60 
61     bool private _tradingOpen;
62 
63     bool private _inTaxSwap = false;
64     modifier lockTaxSwap { 
65         _inTaxSwap = true; 
66         _; 
67         _inTaxSwap = false; 
68     }
69 
70     event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
71 
72     constructor() Auth(msg.sender) {
73         _balances[_owner] = _totalSupply;
74         emit Transfer(address(0), _owner, _balances[_owner]);
75 
76         _noFees[_owner] = true;
77         _noFees[address(this)] = true;
78         _noFees[_swapRouterAddress] = true;
79         _noFees[_walletMarketing] = true;
80     }
81 
82     receive() external payable {}
83     
84     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
85     function decimals() external pure override returns (uint8) { return _decimals; }
86     function symbol() external pure override returns (string memory) { return _symbol; }
87     function name() external pure override returns (string memory) { return _name; }
88     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
89     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
90 
91     function approve(address spender, uint256 amount) public override returns (bool) {
92         _allowances[msg.sender][spender] = amount;
93         emit Approval(msg.sender, spender, amount);
94         return true;
95     }
96 
97     function transfer(address recipient, uint256 amount) external override returns (bool) {
98         require(_checkTradingOpen(msg.sender), "Trading not open");
99         return _transferFrom(msg.sender, recipient, amount);
100     }
101 
102     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
103         require(_checkTradingOpen(sender), "Trading not open");
104         if(_allowances[sender][msg.sender] != type(uint256).max){
105             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
106         }
107         return _transferFrom(sender, recipient, amount);
108     }
109 
110     function _approveRouter(uint256 _tokenAmount) internal {
111         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
112             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
113             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
114         }
115     }
116 
117     function addLiquidity() external payable onlyOwner lockTaxSwap {
118         require(_primaryLP == address(0), "LP exists");
119         require(!_tradingOpen, "trading is open");
120         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
121         require(_balances[address(this)]>0, "No tokens in contract");
122         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
123         _addLiquidity(_balances[address(this)], address(this).balance);
124         _isLP[_primaryLP] = true;
125         _tradeCount = 0;
126         _tradingOpen = true;
127     }
128 
129     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
130         _approveRouter(_tokenAmount);
131         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, _owner, block.timestamp );
132     }
133 
134     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
135         require(sender != address(0), "No transfers from Zero wallet");
136         require(sender != address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), "Vitalik NEVER SELLING");  // Tokens in VB wallet are burned
137 
138         if (!_tradingOpen) { require(_noFees[sender], "Trading not open"); }
139         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
140 
141         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
142         uint256 _transferAmount = amount - _taxAmount;
143         _balances[sender] -= amount;
144         if ( _taxAmount > 0 ) { 
145             _balances[address(this)] += _taxAmount; 
146             incrementTradeCount();
147         }
148         _balances[recipient] += _transferAmount;
149         emit Transfer(sender, recipient, amount);
150         return true;
151     }
152 
153     function _checkTradingOpen(address sender) private view returns (bool){
154         bool checkResult = false;
155         if ( _tradingOpen ) { checkResult = true; } 
156         else if (_noFees[sender]) { checkResult = true; } 
157 
158         return checkResult;
159     }
160 
161     function incrementTradeCount() private {
162         if ( _tradeCount <= 100_001 ) {
163             // tax is finalized after 100,000 trades
164             _tradeCount += 1;
165         } 
166     }
167 
168     function tax() external view returns (uint32 taxNumerator, uint32 taxDenominator) {
169         (uint32 numerator, uint32 denominator) = _getTaxPercentages();
170         return (numerator, denominator);
171     }
172 
173     function _getTaxPercentages() private view returns (uint32 numerator, uint32 denominator) {
174         uint32 taxNumerator;
175         uint32 taxDenominator = 100_000;
176 
177         if ( _tradeCount <= 20_000 ) {
178             taxNumerator = 3000;    // up to 20,000 trades the tax is 3.0 %
179         } else if ( _tradeCount <= 100_000 ) {
180             taxNumerator = 1000;    // from 20,001 to 100,000 trades the tax is 1.0 %
181         } else {
182             taxNumerator = 225;     // above 100,000 trades the tax is 0.225 %
183         }
184 
185         return (taxNumerator, taxDenominator);
186     }
187 
188     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
189         uint256 taxAmount;
190         
191         if ( _tradingOpen && !_noFees[sender] && !_noFees[recipient] ) { 
192             if ( _isLP[sender] || _isLP[recipient] ) {
193                 (uint32 numerator, uint32 denominator) = _getTaxPercentages();
194                 taxAmount = amount * numerator / denominator;
195             }
196         }
197 
198         return taxAmount;
199     }
200 
201     function marketingMultisig() external pure returns (address) {
202         return _walletMarketing;
203     }
204 
205     function _swapTaxAndLiquify() private lockTaxSwap {
206         uint256 _taxTokensAvailable = balanceOf(address(this));
207 
208         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
209             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
210 
211             uint256 _tokensForLP = 0;
212             if ( _tradeCount < 100_000 ) {
213                 // before 100,000 trades are reached half of the tax goes to LP
214                 _tokensForLP = _taxTokensAvailable / 4;
215             }
216             
217             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
218             if( _tokensToSwap > 10**_decimals ) {
219                 uint256 _ethPreSwap = address(this).balance;
220                 _swapTaxTokensForEth(_tokensToSwap);
221                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
222                 if ( _tokensForLP > 0 ) {
223                     uint256 _ethWeiAmount = _ethSwapped / 2 ;
224                     _approveRouter(_tokensForLP);
225                     _addLiquidity(_tokensForLP, _ethWeiAmount);
226                 }
227             }
228             uint256 _contractETHBalance = address(this).balance;
229             if(_contractETHBalance > 0) { 
230                 (bool sent, bytes memory data) = _walletMarketing.call{value: _contractETHBalance}("");
231             }
232         }
233     }
234 
235     function _swapTaxTokensForEth(uint256 tokenAmount) private {
236         _approveRouter(tokenAmount);
237         address[] memory path = new address[](2);
238         path[0] = address(this);
239         path[1] = _primarySwapRouter.WETH();
240         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
241     }
242 
243     function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
244         require(addresses.length <= 250,"More than 250 wallets");
245         require(addresses.length == tokenAmounts.length,"List length mismatch");
246 
247         uint256 airdropTotal = 0;
248         for(uint i=0; i < addresses.length; i++){
249             airdropTotal += (tokenAmounts[i] * 10**_decimals);
250         }
251         require(_balances[msg.sender] >= airdropTotal, "Token balance too low");
252 
253         for(uint i=0; i < addresses.length; i++){
254             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
255             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
256             emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
257         }
258 
259         emit TokensAirdropped(addresses.length, airdropTotal);
260     }
261 }