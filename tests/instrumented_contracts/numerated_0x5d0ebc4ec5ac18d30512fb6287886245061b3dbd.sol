1 /*
2     Gatsby Inu
3     https://linktr.ee/gatsbyinu
4 */
5 
6 //SPDX-License-Identifier: MIT
7 pragma solidity 0.8.19;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function decimals() external view returns (uint8);
12     function symbol() external view returns (string memory);
13     function name() external view returns (string memory);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed _owner, address indexed spender, uint256 value);
21 }
22 
23 abstract contract Auth {
24     address internal _owner;
25     event OwnershipTransferred(address _owner);
26     constructor(address creatorOwner) { _owner = creatorOwner; }
27     modifier onlyOwner() { require(msg.sender == _owner, "Only owner can call this"); _; }
28     function owner() public view returns (address) { return _owner; }
29     function renounceOwnership() external onlyOwner { 
30         _owner = address(0); 
31         emit OwnershipTransferred(address(0)); 
32     }
33 }
34 
35 contract GatsbyV2 is IERC20, Auth {
36     string private constant _name         = "Gatsby Inu";
37     string private constant _symbol       = "GATSBY";
38     uint8 private constant _decimals      = 9;
39     uint256 private constant _totalSupply = 1_000_000_000_000 * (10**_decimals);
40     mapping (address => uint256) private _balances;
41     mapping (address => mapping (address => uint256)) private _allowances;
42 
43     uint32 private _tradeCount;
44 
45     address payable private constant _walletMarketing = payable(0x9D16070DacE017cd925FD9c69FFdC9CD0d41cC92);
46     uint256 private constant _taxSwapMin = _totalSupply / 200000;
47     uint256 private constant _taxSwapMax = _totalSupply / 1000;
48 
49     mapping (address => bool) private _noFees;
50 
51     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
52     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
53     address private _primaryLP;
54     mapping (address => bool) private _isLP;
55 
56     bool private _tradingOpen;
57 
58     bool private _inTaxSwap = false;
59     modifier lockTaxSwap { 
60         _inTaxSwap = true; 
61         _; 
62         _inTaxSwap = false; 
63     }
64 
65     event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
66 
67     constructor() Auth(msg.sender) {
68         _balances[_owner] = _totalSupply;
69         emit Transfer(address(0), _owner, _balances[_owner]);
70 
71         _noFees[_owner] = true;
72         _noFees[address(this)] = true;
73         _noFees[_swapRouterAddress] = true;
74         _noFees[_walletMarketing] = true;
75     }
76 
77     receive() external payable {}
78     
79     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
80     function decimals() external pure override returns (uint8) { return _decimals; }
81     function symbol() external pure override returns (string memory) { return _symbol; }
82     function name() external pure override returns (string memory) { return _name; }
83     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
84     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
85 
86     function approve(address spender, uint256 amount) public override returns (bool) {
87         _allowances[msg.sender][spender] = amount;
88         emit Approval(msg.sender, spender, amount);
89         return true;
90     }
91 
92     function transfer(address recipient, uint256 amount) external override returns (bool) {
93         require(_checkTradingOpen(msg.sender), "Trading not open");
94         return _transferFrom(msg.sender, recipient, amount);
95     }
96 
97     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
98         require(_checkTradingOpen(sender), "Trading not open");
99         if(_allowances[sender][msg.sender] != type(uint256).max){
100             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
101         }
102         return _transferFrom(sender, recipient, amount);
103     }
104 
105     function _approveRouter(uint256 _tokenAmount) internal {
106         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
107             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
108             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
109         }
110     }
111 
112     function addLiquidity() external payable onlyOwner lockTaxSwap {
113         require(_primaryLP == address(0), "LP exists");
114         require(!_tradingOpen, "trading is open");
115         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
116         require(_balances[address(this)]>0, "No tokens in contract");
117         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
118         _addLiquidity(_balances[address(this)], address(this).balance);
119         _isLP[_primaryLP] = true;
120         _tradeCount = 0;
121         _tradingOpen = true;
122     }
123 
124     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
125         _approveRouter(_tokenAmount);
126         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, _owner, block.timestamp );
127     }
128 
129     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
130         require(sender != address(0), "No transfers from Zero wallet");
131 
132         if (!_tradingOpen) { require(_noFees[sender], "Trading not open"); }
133         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
134 
135         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
136         uint256 _transferAmount = amount - _taxAmount;
137         _balances[sender] -= amount;
138         if ( _taxAmount > 0 ) { 
139             _balances[address(this)] += _taxAmount; 
140             incrementTradeCount();
141         }
142         _balances[recipient] += _transferAmount;
143         emit Transfer(sender, recipient, amount);
144         return true;
145     }
146 
147     function _checkTradingOpen(address sender) private view returns (bool){
148         bool checkResult = false;
149         if ( _tradingOpen ) { checkResult = true; } 
150         else if (_noFees[sender]) { checkResult = true; } 
151 
152         return checkResult;
153     }
154 
155     function incrementTradeCount() private {
156         if ( _tradeCount <= 100_001 ) {
157             // tax is finalized after 100,000 trades
158             _tradeCount += 1;
159         } 
160     }
161 
162     function tax() external view returns (uint32 taxNumerator, uint32 taxDenominator, uint32 tradeCounter) {
163         (uint32 numerator, uint32 denominator) = _getTaxPercentages();
164         return (numerator, denominator, _tradeCount);
165     }
166 
167     function _getTaxPercentages() private view returns (uint32 numerator, uint32 denominator) {
168         uint32 taxNumerator;
169         uint32 taxDenominator = 100_000;
170 
171         if ( _tradeCount <= 30_000 ) {
172             taxNumerator = 3000;    // up to 30,000 trades the tax is 3.0 %
173         } else if ( _tradeCount <= 100_000 ) {
174             taxNumerator = 1000;    // from 30,001 to 100,000 trades the tax is 1.0 %
175         } else {
176             taxNumerator = 0;     // above 100,000 trades there is no tax
177         }
178 
179         return (taxNumerator, taxDenominator);
180     }
181 
182     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
183         uint256 taxAmount;
184         
185         if ( _tradingOpen && !_noFees[sender] && !_noFees[recipient] ) { 
186             if ( _isLP[sender] || _isLP[recipient] ) {
187                 (uint32 numerator, uint32 denominator) = _getTaxPercentages();
188                 taxAmount = amount * numerator / denominator;
189             }
190         }
191 
192         return taxAmount;
193     }
194 
195     function marketingWallet() external pure returns (address) {
196         return _walletMarketing;
197     }
198 
199     function _swapTaxAndLiquify() private lockTaxSwap {
200         uint256 _taxTokensAvailable = balanceOf(address(this));
201 
202         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
203             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
204             
205             _swapTaxTokensForEth(_taxTokensAvailable);
206 
207             uint256 _contractETHBalance = address(this).balance;
208             if(_contractETHBalance > 0) { 
209                 (bool sent, bytes memory data) = _walletMarketing.call{value: _contractETHBalance}("");
210             }
211         }
212     }
213 
214     function _swapTaxTokensForEth(uint256 tokenAmount) private {
215         _approveRouter(tokenAmount);
216         address[] memory path = new address[](2);
217         path[0] = address(this);
218         path[1] = _primarySwapRouter.WETH();
219         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
220     }
221 
222     function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
223         require(addresses.length <= 250,"More than 250 wallets");
224         require(addresses.length == tokenAmounts.length,"List length mismatch");
225 
226         uint256 airdropTotal = 0;
227         for(uint i=0; i < addresses.length; i++){
228             airdropTotal += (tokenAmounts[i] * 10**_decimals);
229         }
230         
231         require(_balances[msg.sender] >= airdropTotal, "Token balance too low");
232         _balances[msg.sender] -= airdropTotal; //decrease sender balance of all airdropped tokens at once to save gas updating storage
233 
234         for(uint i=0; i < addresses.length; i++){
235             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
236             emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
237         }
238 
239         emit TokensAirdropped(addresses.length, airdropTotal);
240     }
241 }
242 
243 interface IUniswapV2Factory { 
244     function createPair(address tokenA, address tokenB) external returns (address pair); 
245 }
246 
247 interface IUniswapV2Router02 {
248     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
249     function WETH() external pure returns (address);
250     function factory() external pure returns (address);
251     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
252 }