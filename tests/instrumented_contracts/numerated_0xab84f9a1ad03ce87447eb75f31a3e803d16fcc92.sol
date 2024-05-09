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
40 contract TeamMusk is IERC20, Auth {
41     string private constant _name         = "Team Musk";
42     string private constant _symbol       = "MUSK";
43     uint8 private constant _decimals      = 18;
44     uint256 private constant _totalSupply = 1_000_000_000_000 * (10**_decimals);
45 
46     mapping (address => uint256) private _balances;
47     mapping (address => mapping (address => uint256)) private _allowances;
48     mapping (address => bool) public isBlackListed;
49     mapping (address => bool) private isWhitelisted;
50     mapping (address => bool) private _noFees;
51 
52     address payable private _walletMarketing;
53     address payable private _walletPrizePool;
54     address payable private _walletBuyBack;
55     uint256 private constant _taxSwapMin = _totalSupply / 200000;
56     uint256 private constant _taxSwapMax = _totalSupply / 500;
57   
58     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
59     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
60     address private _primaryLP;
61     mapping (address => bool) private _isLP;
62     uint256 private _tax = 500;
63     uint256 private _epochForBoostedPrizePool;
64 
65     bool public limited = true;
66     uint256 public maxHoldingAmount = 10_000_000_001 * (10**_decimals); // 1%
67     uint256 public minHoldingAmount = 100_000_000 * (10**_decimals); // 0.01%;
68     
69     bool private _tradingOpen;
70 
71     bool private _inTaxSwap = false;
72     modifier lockTaxSwap { 
73         _inTaxSwap = true; 
74         _; 
75         _inTaxSwap = false; 
76     }
77 
78     constructor(address cexWallet, address marketingWallet, address buyBackWallet, address prizePoolWallet, address[] memory _users) Auth(msg.sender) { 
79 
80         _balances[address(cexWallet)] = (_totalSupply / 100 ) * 5;
81         _balances[address(marketingWallet)] = (_totalSupply / 100 ) * 5;
82         _balances[address(this)] = (_totalSupply / 100 ) * 90;
83 
84         emit Transfer(address(0), address(cexWallet), _balances[address(cexWallet)]);
85         emit Transfer(address(0), address(marketingWallet), _balances[address(marketingWallet)]);
86         emit Transfer(address(0), address(this), _balances[address(this)]);
87         
88         setMarketingWallet(marketingWallet);
89         setBuyBackWallet(buyBackWallet);
90         setPrizePoolWallet(prizePoolWallet);
91         setWhitelist(_users, true);
92 
93         _noFees[cexWallet] = true;
94         _noFees[_walletMarketing] = true;
95         _noFees[buyBackWallet] = true;
96         _noFees[prizePoolWallet] = true;
97         _noFees[_owner] = true;
98         _noFees[address(this)] = true;
99   
100         _epochForBoostedPrizePool = block.timestamp + 12 * 7 * 24 * 3600; // 12 weeks after deployment
101     }
102 
103     receive() external payable {}
104     
105     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
106     function decimals() external pure override returns (uint8) { return _decimals; }
107     function symbol() external pure override returns (string memory) { return _symbol; }
108     function name() external pure override returns (string memory) { return _name; }
109     function tax() external view returns (uint256) { return _tax / 100; }
110     function prizePoolBoostStart() external view returns (uint256) { return _epochForBoostedPrizePool; }
111     function marketingMultisig() external view returns (address) { return _walletMarketing; }
112     function BuyBackMultisig() external view returns (address) { return _walletBuyBack; }
113     function PrizePoolMultisig() external view returns (address) { return _walletPrizePool; }
114     function getPrizePoolBalance() external view returns (uint256){ return address(_walletPrizePool).balance; }
115     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
116     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
117 
118 
119     function approve(address spender, uint256 amount) public override returns (bool) {
120         _allowances[msg.sender][spender] = amount;
121         emit Approval(msg.sender, spender, amount);
122         return true;
123     }
124 
125     function transfer(address recipient, uint256 amount) external override returns (bool) {
126         require(_checkTradingOpen(msg.sender), "Trading not open");
127         return _transferFrom(msg.sender, recipient, amount);
128     }
129 
130     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
131         require(_checkTradingOpen(sender), "Trading not open");
132         if(_allowances[sender][msg.sender] != type(uint256).max){
133             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
134         }
135         return _transferFrom(sender, recipient, amount);
136     }
137 
138     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
139         require(sender != address(0), "No transfers from Zero wallet");
140         require(!isBlackListed[sender], "Sender Blacklisted");
141         require(!isBlackListed[recipient], "Receiver Blacklisted");
142 
143         if (!_tradingOpen) { require(_noFees[sender], "Trading not open"); }
144         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
145 
146         if (limited && sender == _primaryLP) {
147             require(balanceOf(recipient) + amount <= maxHoldingAmount && balanceOf(recipient) + amount >= minHoldingAmount, "Forbid");
148             require(isWhitelisted[sender] || isWhitelisted[recipient], "Forbid");
149         }
150 
151         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
152         uint256 _transferAmount = amount - _taxAmount;
153         _balances[sender] -= amount;
154         if ( _taxAmount > 0 ) { 
155             _balances[address(this)] += _taxAmount; 
156         }
157         _balances[recipient] += _transferAmount;
158         emit Transfer(sender, recipient, amount);
159         return true;
160     }    
161 
162     function _approveRouter(uint256 _tokenAmount) internal {
163         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
164             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
165             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
166         }
167     }
168 
169     function addLiquidity() external payable onlyOwner lockTaxSwap {
170         require(_primaryLP == address(0), "LP exists");
171         require(!_tradingOpen, "trading is open");
172         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
173         require(_balances[address(this)]>0, "No tokens in contract");
174         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
175         _addLiquidity(_balances[address(this)], address(this).balance);
176         _isLP[_primaryLP] = true;
177         _tradingOpen = true;
178     }
179 
180     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
181         _approveRouter(_tokenAmount);
182         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, _owner, block.timestamp );
183     }
184 
185     function _checkTradingOpen(address sender) private view returns (bool){
186         bool checkResult = false;
187         if ( _tradingOpen ) { checkResult = true; } 
188         else if (_noFees[sender]) { checkResult = true; } 
189 
190         return checkResult;
191     }
192 
193     function setMarketingWallet(address newMarketingWallet) public onlyOwner {
194         _walletMarketing = payable(newMarketingWallet);
195     }
196 
197     function setPrizePoolWallet(address newPrizePoolWallet) public onlyOwner {
198         _walletPrizePool = payable(newPrizePoolWallet);
199     }
200 
201     function setBuyBackWallet(address newBuyBackWallet) public onlyOwner {
202         _walletBuyBack = payable(newBuyBackWallet);
203     }
204  
205     function setBlackList(address[] memory _users, bool set) public onlyOwner {
206         for(uint256 i = 0; i < _users.length; i++){
207             isBlackListed[_users[i]] = set;
208         }
209     }
210 
211     function setWhitelist(address[] memory _users, bool set) internal {
212         for(uint256 i = 0; i < _users.length; i++){
213             isWhitelisted[_users[i]] = set;
214         }
215     }
216 
217     function setRule(bool _limited, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
218         limited = _limited;
219         maxHoldingAmount = _maxHoldingAmount;
220         minHoldingAmount = _minHoldingAmount;
221     }
222 
223     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
224 
225         uint256 taxAmount;
226         if ( _tradingOpen && !_noFees[sender] && !_noFees[recipient] ) { 
227             if ( _isLP[sender] || _isLP[recipient] ) {
228                 taxAmount = amount * _tax / 10000;
229             }
230         }
231 
232         return taxAmount;
233     }
234 
235     function _swapTaxAndLiquify() private lockTaxSwap {
236         uint256 _taxTokensAvailable = balanceOf(address(this));
237 
238         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
239             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
240 
241             _swapTaxTokensForEth(_taxTokensAvailable);
242             uint256 _contractETHBalance = address(this).balance;
243 
244             if(_contractETHBalance > 0) { 
245 
246                 if(block.timestamp < _epochForBoostedPrizePool){
247                     // first 12 weeks 
248 
249                     // 50% marketing
250                     // 50% prize pool
251             
252                     bool success;
253                     (success,) = _walletMarketing.call{value: (_contractETHBalance / 2)}("");
254                     require(success);
255 
256                     (success,) = _walletPrizePool.call{value: (_contractETHBalance / 2)}("");
257                     require(success);
258 
259                 } else {
260                     // after 12 weeks
261 
262                     // 20% marketing
263                     // 5% buy back
264                     // 75% prize pool
265 
266                     bool success;
267                     (success,) = _walletMarketing.call{value: 20 * (_contractETHBalance / 100)}("");
268                     require(success);
269                     (success,) = _walletBuyBack.call{value: 5 * (_contractETHBalance / 100)}("");
270                     require(success);
271                     (success,) = _walletPrizePool.call{value: 75 * (_contractETHBalance / 100)}("");
272                     require(success);
273                 }
274             }
275         }
276     }
277 
278     function _swapTaxTokensForEth(uint256 tokenAmount) private {
279         _approveRouter(tokenAmount);
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = _primarySwapRouter.WETH();
283         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
284     }
285 }