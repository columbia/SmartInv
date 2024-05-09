1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
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
40 contract TeamZuck is IERC20, Auth {
41     string private constant _name         = "Team Zuck";
42     string private constant _symbol       = "ZUCK";
43     uint8 private constant _decimals      = 18;
44     uint256 private constant _totalSupply = 1_000_000_000_000 * (10**_decimals);
45 
46     mapping (address => uint256) private _balances;
47     mapping (address => mapping (address => uint256)) private _allowances;
48     mapping (address => bool) public isBlackListed;
49     mapping (address => bool) private _noFees;
50 
51     address payable private _walletMarketing;
52     address payable private _walletPrizePool;
53     address payable private _walletBuyBack;
54     uint256 private constant _taxSwapMin = _totalSupply / 200000;
55     uint256 private constant _taxSwapMax = _totalSupply / 500;
56   
57     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
58     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
59     address private _primaryLP;
60     mapping (address => bool) private _isLP;
61     uint256 private _tax = 500;
62     uint256 private _epochForBoostedPrizePool;
63 
64     bool public limited = true;
65     uint256 public maxHoldingAmount = 10_000_000_001 * (10**_decimals); // 1%
66     uint256 public minHoldingAmount = 100_000_000 * (10**_decimals); // 0.01%;
67     
68     bool private _tradingOpen;
69 
70     bool private _inTaxSwap = false;
71     modifier lockTaxSwap { 
72         _inTaxSwap = true; 
73         _; 
74         _inTaxSwap = false; 
75     }
76 
77     constructor(address cexWallet, address marketingWallet, address buyBackWallet, address prizePoolWallet) Auth(msg.sender) { 
78 
79         _balances[address(cexWallet)] = (_totalSupply / 100 ) * 5;
80         _balances[address(marketingWallet)] = (_totalSupply / 100 ) * 5;
81         _balances[address(this)] = (_totalSupply / 100 ) * 90;
82 
83         emit Transfer(address(0), address(cexWallet), _balances[address(cexWallet)]);
84         emit Transfer(address(0), address(marketingWallet), _balances[address(marketingWallet)]);
85         emit Transfer(address(0), address(this), _balances[address(this)]);
86         
87         setMarketingWallet(marketingWallet);
88         setBuyBackWallet(buyBackWallet);
89         setPrizePoolWallet(prizePoolWallet);
90 
91         _noFees[cexWallet] = true;
92         _noFees[_walletMarketing] = true;
93         _noFees[buyBackWallet] = true;
94         _noFees[prizePoolWallet] = true;
95         _noFees[_owner] = true;
96         _noFees[address(this)] = true;
97   
98         _epochForBoostedPrizePool = block.timestamp + 12 * 7 * 24 * 3600; // 12 weeks after deployment
99     }
100 
101     receive() external payable {}
102     
103     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
104     function decimals() external pure override returns (uint8) { return _decimals; }
105     function symbol() external pure override returns (string memory) { return _symbol; }
106     function name() external pure override returns (string memory) { return _name; }
107     function tax() external view returns (uint256) { return _tax / 100; }
108     function prizePoolBoostStart() external view returns (uint256) { return _epochForBoostedPrizePool; }
109     function marketingMultisig() external view returns (address) { return _walletMarketing; }
110     function BuyBackMultisig() external view returns (address) { return _walletBuyBack; }
111     function PrizePoolMultisig() external view returns (address) { return _walletPrizePool; }
112     function getPrizePoolBalance() external view returns (uint256){ return address(_walletPrizePool).balance; }
113     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
114     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
115 
116 
117     function approve(address spender, uint256 amount) public override returns (bool) {
118         _allowances[msg.sender][spender] = amount;
119         emit Approval(msg.sender, spender, amount);
120         return true;
121     }
122 
123     function transfer(address recipient, uint256 amount) external override returns (bool) {
124         require(_checkTradingOpen(msg.sender), "Trading not open");
125         return _transferFrom(msg.sender, recipient, amount);
126     }
127 
128     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
129         require(_checkTradingOpen(sender), "Trading not open");
130         if(_allowances[sender][msg.sender] != type(uint256).max){
131             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
132         }
133         return _transferFrom(sender, recipient, amount);
134     }
135 
136     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
137         require(sender != address(0), "No transfers from Zero wallet");
138         require(!isBlackListed[sender], "Sender Blacklisted");
139         require(!isBlackListed[recipient], "Receiver Blacklisted");
140 
141         if (!_tradingOpen) { require(_noFees[sender], "Trading not open"); }
142         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
143 
144         if (limited && sender == _primaryLP) {
145             require(balanceOf(recipient) + amount <= maxHoldingAmount && balanceOf(recipient) + amount >= minHoldingAmount, "Forbid");
146         }
147 
148         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
149         uint256 _transferAmount = amount - _taxAmount;
150         _balances[sender] -= amount;
151         if ( _taxAmount > 0 ) { 
152             _balances[address(this)] += _taxAmount; 
153         }
154         _balances[recipient] += _transferAmount;
155         emit Transfer(sender, recipient, amount);
156         return true;
157     }    
158 
159     function _approveRouter(uint256 _tokenAmount) internal {
160         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
161             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
162             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
163         }
164     }
165 
166     function addLiquidity() external payable onlyOwner lockTaxSwap {
167         require(_primaryLP == address(0), "LP exists");
168         require(!_tradingOpen, "trading is open");
169         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
170         require(_balances[address(this)]>0, "No tokens in contract");
171         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
172         _addLiquidity(_balances[address(this)], address(this).balance);
173         _isLP[_primaryLP] = true;
174         _tradingOpen = true;
175     }
176 
177     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
178         _approveRouter(_tokenAmount);
179         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, _owner, block.timestamp );
180     }
181 
182     function _checkTradingOpen(address sender) private view returns (bool){
183         bool checkResult = false;
184         if ( _tradingOpen ) { checkResult = true; } 
185         else if (_noFees[sender]) { checkResult = true; } 
186 
187         return checkResult;
188     }
189 
190     function setMarketingWallet(address newMarketingWallet) public onlyOwner {
191         _walletMarketing = payable(newMarketingWallet);
192     }
193 
194     function setPrizePoolWallet(address newPrizePoolWallet) public onlyOwner {
195         _walletPrizePool = payable(newPrizePoolWallet);
196     }
197 
198     function setBuyBackWallet(address newBuyBackWallet) public onlyOwner {
199         _walletBuyBack = payable(newBuyBackWallet);
200     }
201  
202     function setBlackList(address[] memory _users, bool set) public onlyOwner {
203         for(uint256 i = 0; i < _users.length; i++){
204             isBlackListed[_users[i]] = set;
205         }
206     }
207 
208     function setRule(bool _limited, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
209         limited = _limited;
210         maxHoldingAmount = _maxHoldingAmount;
211         minHoldingAmount = _minHoldingAmount;
212     }
213 
214     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
215 
216         uint256 taxAmount;
217         if ( _tradingOpen && !_noFees[sender] && !_noFees[recipient] ) { 
218             if ( _isLP[sender] || _isLP[recipient] ) {
219                 taxAmount = amount * _tax / 10000;
220             }
221         }
222 
223         return taxAmount;
224     }
225 
226     function _swapTaxAndLiquify() private lockTaxSwap {
227         uint256 _taxTokensAvailable = balanceOf(address(this));
228 
229         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
230             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
231 
232             _swapTaxTokensForEth(_taxTokensAvailable);
233             uint256 _contractETHBalance = address(this).balance;
234 
235             if(_contractETHBalance > 0) { 
236 
237                 if(block.timestamp < _epochForBoostedPrizePool){
238                     // first 12 weeks 
239 
240                     // 50% marketing
241                     // 50% prize pool
242             
243                     bool success;
244                     (success,) = _walletMarketing.call{value: (_contractETHBalance / 2)}("");
245                     require(success);
246 
247                     (success,) = _walletPrizePool.call{value: (_contractETHBalance / 2)}("");
248                     require(success);
249 
250                 } else {
251                     // after 12 weeks
252 
253                     // 20% marketing
254                     // 5% buy back
255                     // 75% prize pool
256 
257                     bool success;
258                     (success,) = _walletMarketing.call{value: 20 * (_contractETHBalance / 100)}("");
259                     require(success);
260                     (success,) = _walletBuyBack.call{value: 5 * (_contractETHBalance / 100)}("");
261                     require(success);
262                     (success,) = _walletPrizePool.call{value: 75 * (_contractETHBalance / 100)}("");
263                     require(success);
264                 }
265             }
266         }
267     }
268 
269     function _swapTaxTokensForEth(uint256 tokenAmount) private {
270         _approveRouter(tokenAmount);
271         address[] memory path = new address[](2);
272         path[0] = address(this);
273         path[1] = _primarySwapRouter.WETH();
274         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
275     }
276 }