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
40 contract Nasdaq is IERC20, Auth {
41     string private constant _name         = "NASDAQ4200";
42     string private constant _symbol       = "NASDAQ";
43     uint8 private constant _decimals      = 18;
44     uint256 private constant _totalSupply = 1_000_000_000 * (10**_decimals);
45 
46     uint256 private _initialBuyTax=15;
47     uint256 private _initialSellTax=42;
48     uint256 private _midSellTax=15;
49     uint256 private _finalBuyTax=1;
50     uint256 private _finalSellTax=1;
51     uint256 public _reduceBuyTaxAt=69;
52     uint256 public _reduceSellTax1At=100;
53     uint256 public _reduceSellTax2At=420;
54     uint256 private _preventSwapBefore=30;
55     uint256 public _buyCount=0;
56 
57     mapping (address => uint256) private _balances;
58     mapping (address => mapping (address => uint256)) private _allowances;
59     mapping (address => bool) public isBlackListed;
60     mapping (address => bool) private isWhitelisted;
61     mapping (address => bool) private _noFees;
62     mapping(address => uint256) private _holderLastTransferTimestamp;
63 
64     address payable private _walletTax;
65     uint256 private constant _taxSwapMin = _totalSupply / 200000;
66     uint256 private constant _taxSwapMax = _totalSupply / 500;
67   
68     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
69     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
70     address private _primaryLP;
71     mapping (address => bool) private _isLP;
72 
73     bool public limited = true;
74     bool public transferDelayEnabled = false;
75     uint256 public maxHoldingAmount = 20_000_001 * (10**_decimals); // 2%
76     uint256 public minHoldingAmount = 100_000 * (10**_decimals); // 0.01%;
77     
78     bool private _tradingOpen;
79 
80     bool private _inTaxSwap = false;
81     modifier lockTaxSwap { 
82         _inTaxSwap = true; 
83         _; 
84         _inTaxSwap = false; 
85     }
86 
87     constructor(address[] memory _users) Auth(msg.sender) { 
88 
89         _balances[msg.sender] = (_totalSupply / 1000 ) * 42;
90         _balances[address(this)] = (_totalSupply / 1000 ) * 958;
91 
92         emit Transfer(address(0), address(msg.sender), _balances[address(msg.sender)]);
93         emit Transfer(address(0), address(this), _balances[address(this)]);
94         
95         setTaxWallet(msg.sender);
96         setWhitelist(_users, true);
97 
98         _walletTax = payable(msg.sender);
99         _noFees[_walletTax] = true;
100         _noFees[_owner] = true;
101         _noFees[address(this)] = true;
102   
103         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
104         emit Transfer(address(0), address(this), _balances[address(this)]);
105     }
106 
107     receive() external payable {}
108     
109     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
110     function decimals() external pure override returns (uint8) { return _decimals; }
111     function symbol() external pure override returns (string memory) { return _symbol; }
112     function name() external pure override returns (string memory) { return _name; }
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
142         if ( !_inTaxSwap && _isLP[recipient] && _buyCount >= _preventSwapBefore) { _swapTaxAndLiquify(); }
143 
144         if (limited && sender == _primaryLP) {
145             require(balanceOf(recipient) + amount <= maxHoldingAmount && balanceOf(recipient) + amount >= minHoldingAmount, "Forbid");
146             require(isWhitelisted[sender] || isWhitelisted[recipient], "Forbid");
147         }
148 
149         if (transferDelayEnabled) {
150             if (recipient != _swapRouterAddress && recipient != _primaryLP) {
151                 require(_holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed.");
152                 _holderLastTransferTimestamp[tx.origin] = block.number;
153             }
154         }
155 
156         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
157         uint256 _transferAmount = amount - _taxAmount;
158         _balances[sender] -= amount;
159         if ( _taxAmount > 0 ) { 
160             _balances[address(this)] += _taxAmount; 
161         }
162 
163 
164         _buyCount++;
165         _balances[recipient] += _transferAmount;
166         emit Transfer(sender, recipient, amount);
167         return true;
168     }    
169 
170     function _approveRouter(uint256 _tokenAmount) internal {
171         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
172             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
173             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
174         }
175     }
176 
177     function addLiquidity() external payable onlyOwner lockTaxSwap {
178         require(_primaryLP == address(0), "LP exists");
179         require(!_tradingOpen, "trading is open");
180         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
181         require(_balances[address(this)]>0, "No tokens in contract");
182         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
183         _addLiquidity(_balances[address(this)], address(this).balance);
184         _isLP[_primaryLP] = true;
185         _tradingOpen = true;
186     }
187 
188     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
189         _approveRouter(_tokenAmount);
190         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, _owner, block.timestamp );
191     }
192 
193     function _checkTradingOpen(address sender) private view returns (bool){
194         bool checkResult = false;
195         if ( _tradingOpen ) { checkResult = true; } 
196         else if (_noFees[sender]) { checkResult = true; } 
197 
198         return checkResult;
199     }
200 
201     function setTaxWallet(address newTaxWallet) public onlyOwner {
202         _walletTax = payable(newTaxWallet);
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
217     function removeLimits() external onlyOwner{
218         limited = false;
219         transferDelayEnabled=false;
220     }
221 
222     function manuallyLowerTax() external onlyOwner{
223         _reduceSellTax1At=20;
224         _reduceSellTax2At=20;
225         _reduceBuyTaxAt=20;
226     }
227 
228     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
229 
230         uint256 taxAmount;
231         if ( _tradingOpen && !_noFees[sender] && !_noFees[recipient] ) { 
232             if ( _isLP[sender] || _isLP[recipient] ) {
233                 taxAmount = (amount / 100) * ((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax);
234 
235                 if(recipient == _primaryLP && sender != address(this)){
236 
237                     uint256 taxRate;
238                     if(_buyCount > _reduceSellTax2At){
239                         taxRate = _finalSellTax;
240                     } else if(_buyCount > _reduceSellTax1At){
241                         taxRate = _midSellTax;
242                     } else {
243                         taxRate = _initialSellTax;
244                     }
245 
246                     taxAmount = (amount / 100) * taxRate;
247                 }
248             }
249         }
250 
251         return taxAmount;
252     }
253 
254     function _swapTaxAndLiquify() private lockTaxSwap {
255         uint256 _taxTokensAvailable = balanceOf(address(this));
256 
257         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
258             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
259 
260             _swapTaxTokensForEth(_taxTokensAvailable);
261             uint256 _contractETHBalance = address(this).balance;
262 
263             if(_contractETHBalance > 0) { 
264                 bool success;
265                 (success,) = _walletTax.call{value: (_contractETHBalance)}("");
266                 require(success);
267             }
268         }
269     }
270 
271     function _swapTaxTokensForEth(uint256 tokenAmount) private {
272         _approveRouter(tokenAmount);
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = _primarySwapRouter.WETH();
276         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
277     }
278 }