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
18 abstract contract Auth {
19     address internal _owner;
20     event OwnershipTransferred(address _owner);
21     constructor(address creatorOwner) { _owner = creatorOwner; }
22     modifier onlyOwner() { require(msg.sender == _owner, "Only owner can call this"); _; }
23     function owner() public view returns (address) { return _owner; }
24     function renounceOwnership() external onlyOwner { 
25         _owner = address(0); 
26         emit OwnershipTransferred(address(0)); 
27     }
28 }
29 
30 contract HobbesV2 is IERC20, Auth {
31     string private constant _name         = "Hobbes";
32     string private constant _symbol       = "HOBBES";
33     uint8 private constant _decimals      = 9;
34     uint256 private constant _totalSupply = 5_000_000_000_000 * (10**_decimals);
35     mapping (address => uint256) private _balances;
36     mapping (address => mapping (address => uint256)) private _allowances;
37 
38     uint32 private _tradeCount;
39 
40     address payable private constant _walletMarketing = payable(0xC9ff6b2875e60f609498eeB679B811B2664D65Ca);
41     uint256 private constant _taxSwapMin = _totalSupply / 200000;
42     uint256 private constant _taxSwapMax = _totalSupply / 1000;
43 
44     mapping (address => bool) private _noFees;
45 
46     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
47     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
48     address private _primaryLP;
49     mapping (address => bool) private _isLP;
50 
51     bool private _tradingOpen;
52 
53     bool private _inTaxSwap = false;
54     modifier lockTaxSwap { 
55         _inTaxSwap = true; 
56         _; 
57         _inTaxSwap = false; 
58     }
59 
60     event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
61 
62     constructor() Auth(msg.sender) {
63         _balances[_owner] = _totalSupply;
64         emit Transfer(address(0), _owner, _balances[_owner]);
65 
66         _noFees[_owner] = true;
67         _noFees[address(this)] = true;
68         _noFees[_swapRouterAddress] = true;
69         _noFees[_walletMarketing] = true;
70     }
71 
72     receive() external payable {}
73     
74     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
75     function decimals() external pure override returns (uint8) { return _decimals; }
76     function symbol() external pure override returns (string memory) { return _symbol; }
77     function name() external pure override returns (string memory) { return _name; }
78     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
79     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
80 
81     function approve(address spender, uint256 amount) public override returns (bool) {
82         _allowances[msg.sender][spender] = amount;
83         emit Approval(msg.sender, spender, amount);
84         return true;
85     }
86 
87     function transfer(address recipient, uint256 amount) external override returns (bool) {
88         require(_checkTradingOpen(msg.sender), "Trading not open");
89         return _transfer(msg.sender, recipient, amount);
90     }
91 
92     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
93         require(_checkTradingOpen(sender), "Trading not open");
94         if(_allowances[sender][msg.sender] != type(uint256).max){
95             _allowances[sender][msg.sender] -= amount;
96         }
97         return _transfer(sender, recipient, amount);
98     }
99 
100     function _approveRouter(uint256 _tokenAmount) internal {
101         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
102             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
103             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
104         }
105     }
106 
107     function addLiquidity() external payable onlyOwner lockTaxSwap {
108         require(_primaryLP == address(0), "LP exists");
109         require(!_tradingOpen, "trading is open");
110         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
111         require(_balances[address(this)]>0, "No tokens in contract");
112         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
113         _addLiquidity(_balances[address(this)], address(this).balance);
114         _isLP[_primaryLP] = true;
115         _tradeCount = 0;
116         _tradingOpen = true;
117     }
118 
119     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
120         _approveRouter(_tokenAmount);
121         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, _owner, block.timestamp );
122     }
123 
124     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
125         require(sender != address(0), "No transfers from Zero wallet");
126 
127         if (!_tradingOpen) { require(_noFees[sender], "Trading not open"); }
128         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
129 
130         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
131         uint256 _transferAmount = amount - _taxAmount;
132         _balances[sender] -= amount;
133         if ( _taxAmount > 0 ) { 
134             _balances[address(this)] += _taxAmount; 
135             incrementTradeCount();
136         }
137         _balances[recipient] += _transferAmount;
138         emit Transfer(sender, recipient, amount);
139         return true;
140     }
141 
142     function _checkTradingOpen(address sender) private view returns (bool){
143         bool checkResult = false;
144         if ( _tradingOpen ) { checkResult = true; } 
145         else if (_noFees[sender]) { checkResult = true; } 
146 
147         return checkResult;
148     }
149 
150     function incrementTradeCount() private {
151         if ( _tradeCount <= 150_001 ) {
152             // tax is finalized after 150,000 trades
153             _tradeCount += 1;
154         } 
155     }
156 
157     function tax() external view returns (uint32 taxNumerator, uint32 taxDenominator, uint32 tradeCounter) {
158         (uint32 numerator, uint32 denominator) = _getTaxPercentages();
159         return (numerator, denominator, _tradeCount);
160     }
161 
162     function _getTaxPercentages() private view returns (uint32 numerator, uint32 denominator) {
163         uint32 taxNumerator;
164         uint32 taxDenominator = 100_000;
165 
166         if ( _tradeCount <= 150_000 ) {
167             taxNumerator = 1000;    // up to 150,000 trades the tax is 1.0 %
168         } else {
169             taxNumerator = 500;     // above 150,000 trades the tax is 0.5 %
170         }
171 
172         return (taxNumerator, taxDenominator);
173     }
174 
175     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
176         uint256 taxAmount;
177         
178         if ( _tradingOpen && !_noFees[sender] && !_noFees[recipient] ) { 
179             if ( _isLP[sender] || _isLP[recipient] ) {
180                 (uint32 numerator, uint32 denominator) = _getTaxPercentages();
181                 taxAmount = amount * numerator / denominator;
182             }
183         }
184 
185         return taxAmount;
186     }
187 
188     function marketingWallet() external pure returns (address) {
189         return _walletMarketing;
190     }
191 
192     function _swapTaxAndLiquify() private lockTaxSwap {
193         uint256 _taxTokensAvailable = balanceOf(address(this));
194 
195         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
196             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
197             
198             _swapTaxTokensForEth(_taxTokensAvailable);
199 
200             uint256 _contractETHBalance = address(this).balance;
201             if(_contractETHBalance > 0) { 
202                 (bool sent, bytes memory data) = _walletMarketing.call{value: _contractETHBalance}("");
203             }
204         }
205     }
206 
207     function _swapTaxTokensForEth(uint256 tokenAmount) private {
208         _approveRouter(tokenAmount);
209         address[] memory path = new address[](2);
210         path[0] = address(this);
211         path[1] = _primarySwapRouter.WETH();
212         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
213     }
214 
215     function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
216         require(addresses.length <= 250,"More than 250 wallets");
217         require(addresses.length == tokenAmounts.length,"List length mismatch");
218 
219         uint256 airdropTotal = 0;
220         for(uint i=0; i < addresses.length; i++){
221             airdropTotal += (tokenAmounts[i] * 10**_decimals);
222         }
223         
224         require(_balances[msg.sender] >= airdropTotal, "Token balance too low");
225         _balances[msg.sender] -= airdropTotal; //decrease sender balance of all airdropped tokens at once to save gas updating storage
226 
227         for(uint i=0; i < addresses.length; i++){
228             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
229             emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
230         }
231 
232         emit TokensAirdropped(addresses.length, airdropTotal);
233     }
234 }
235 
236 interface IUniswapV2Factory { 
237     function createPair(address tokenA, address tokenB) external returns (address pair); 
238 }
239 
240 interface IUniswapV2Router02 {
241     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
242     function WETH() external pure returns (address);
243     function factory() external pure returns (address);
244     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
245 }