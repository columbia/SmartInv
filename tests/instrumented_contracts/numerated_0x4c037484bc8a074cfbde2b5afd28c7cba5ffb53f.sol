1 //SPDX-License-Identifier: MIT
2 
3 /*
4 https://t.me/The100Token
5 */
6 
7 pragma solidity 0.8.20;
8 
9 interface IERC20 {
10     function balanceOf(address account) external view returns (uint256);
11     function decimals() external view returns (uint8);
12     function totalSupply() external view returns (uint256);
13     function name() external view returns (string memory);
14     function symbol() external view returns (string memory);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender)
17         external
18         view
19         returns (uint256);
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 interface IUniswapV2Factory {
38     function createPair(address tokenA, address tokenB) external returns (address pair);
39 }
40 
41 interface IUniswapV2Router02 {
42     function swapExactTokensForETHSupportingFeeOnTransferTokens( uint256 amountIn,
43         uint256 amountOutMin, address[] calldata path,
44         address to, uint256 deadline ) external;
45 
46     function factory() external pure returns (address);
47     function WETH() external pure returns (address);
48 
49     function addLiquidityETH(address token,
50         uint256 amountTokenDesired, uint256 amountTokenMin,
51         uint256 amountETHMin, address to,
52         uint256 deadline )
53         external payable
54         returns (
55             uint256 amountToken, uint256 amountETH, uint256 liquidity
56         );
57 }
58 
59 abstract contract Ownable {
60     address public owner;
61 
62     modifier onlyOwner() {
63         require(msg.sender == owner, "Only owner can call this"); _;
64     }
65 
66     constructor(address creatorOwner) { owner = creatorOwner;
67     }
68 
69     function transferOwnership(address payable newOwner) external onlyOwner {
70         owner = newOwner; emit OwnershipTransferred(newOwner);
71     }
72 
73     function renounceOwnership() external onlyOwner {
74         owner = address(0); emit OwnershipTransferred(address(0));
75     }
76 
77     event OwnershipTransferred(address owner);
78 }
79 
80 contract OneHundred is IERC20, Ownable {
81     uint8 private constant _decimals = 18;
82     uint256 private constant _totalSupply = 100 * (10**_decimals);
83     string private constant _name = "100 Token";
84     string private constant _symbol = "100";
85     mapping(address => mapping(address => uint256)) private _allowances;
86 
87     mapping(address => bool) private blacklisted;
88     mapping(address => uint256) private _balances;
89 
90     uint256 private _maxWalletAmount = _totalSupply;
91 
92     uint256 private _maxTxAmount = _totalSupply;
93     mapping(address => bool) private _noLimits;
94     uint256 private _launchBlock;
95 
96     uint256 antiSniperMevBlock;
97     
98     uint256 blacklistBlock;
99 
100     bool private tradingOpen;
101 
102     address private liquidityProvider;
103 
104     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
105     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
106     address private _primaryLP;
107     mapping(address => bool) private _isLP;
108 
109     
110 
111     bool private _inTaxSwap = false;
112     modifier lockTaxSwap() {
113         _inTaxSwap = true; _;
114         _inTaxSwap = false; }
115 
116     constructor() Ownable(msg.sender) {
117         _balances[owner] = (_totalSupply * 0) / 100;
118         emit Transfer(address(0), owner, _balances[owner]);
119 
120         _balances[address(this)] = _totalSupply - _balances[owner];
121         emit Transfer(address(0), address(this), _balances[address(this)]);
122 
123         _noLimits[owner] = true;
124         _noLimits[address(this)] = true;
125         _noLimits[_swapRouterAddress] = true;
126     }
127 
128     receive() external payable {}
129 
130     function totalSupply() external pure override returns (uint256) {
131         return _totalSupply;
132     }
133 
134     function decimals() external pure override returns (uint8) {
135         return _decimals;
136     }
137 
138     function symbol() external pure override returns (string memory) {
139         return _symbol;
140     }
141 
142     function name() external pure override returns (string memory) {
143         return _name;
144     }
145 
146     function balanceOf(address account) public view override returns (uint256) {
147         return _balances[account];
148     }
149 
150     function allowance(address holder, address spender)
151         external
152         view
153         override
154         returns (uint256)
155     {
156         return _allowances[holder][spender];
157     }
158 
159     function approve(address spender, uint256 amount)
160         public
161         override
162         returns (bool)
163     {
164         _allowances[msg.sender][spender] = amount;
165         emit Approval(msg.sender, spender, amount);
166         return true;
167     }
168 
169     function transfer(address recipient, uint256 amount)
170         external
171         override
172         returns (bool)
173     {
174         require(_checkTradingOpen(msg.sender), "Trading not open");
175         return _transferFrom(msg.sender, recipient, amount);
176     }
177 
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) external override returns (bool) {
183         require(_checkTradingOpen(sender), "Trading not open");
184         if (_allowances[sender][msg.sender] != type(uint256).max) {
185             _allowances[sender][msg.sender] =
186                 _allowances[sender][msg.sender] -
187                 amount;
188         }
189         return _transferFrom(sender, recipient, amount);
190     }
191 
192     function _approveRouter(uint256 _tokenAmount) internal {
193         if (_allowances[address(this)][_swapRouterAddress] < _tokenAmount) {
194             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
195             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
196         }
197     }
198 
199     function addLiquidity() external payable onlyOwner lockTaxSwap {
200         require(_primaryLP == address(0), "LP exists");
201         require(!tradingOpen, "trading is open");
202         require(msg.value > 0 || address(this).balance > 0,
203             "No ETH in contract or message" );
204         require(_balances[address(this)] > 0, "No tokens in contract");
205         liquidityProvider = msg.sender;
206         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(
207             address(this), _primarySwapRouter.WETH()
208         );
209         _addLiquidity(_balances[address(this)], address(this).balance, false);
210         _isLP[_primaryLP] = true;
211         _openTrading();
212     }
213 
214     function _addLiquidity( uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn
215     ) internal {
216         address lpTokenRecipient = liquidityProvider;
217         if (autoburn) { lpTokenRecipient = address(0);
218         }
219         _approveRouter(_tokenAmount);
220         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei}
221         (
222             address(this), _tokenAmount, 
223             0, 0,
224             lpTokenRecipient, block.timestamp
225         );
226     }
227 
228     function _openTrading() internal {
229         require(!tradingOpen, "already open");
230         _maxTxAmount = ((_totalSupply * 1) / 100) + 10**9;
231         _maxWalletAmount = ((_totalSupply * 1) / 100) + 10**9;
232         tradingOpen = true;
233         _launchBlock = block.number;
234         blacklistBlock = block.number + 10;
235         antiSniperMevBlock = block.number + 20;
236     }
237 
238     function blacklistSnipers(address wallet) private 
239     {
240         if ( wallet != _primaryLP &&
241             wallet != owner && wallet != address(this) &&
242             wallet != _swapRouterAddress ) {
243             blacklisted[wallet] = true; }
244     }
245 
246     function _transferFrom( address sender, address recipient, uint256 amount
247     ) internal returns (bool) 
248     {
249         require(sender != address(0), "No transfers from Zero wallet");
250         if (!tradingOpen) { require(_noLimits[sender], "Trading not open");
251         } else if (_isLP[sender]) {
252             if (block.number <= blacklistBlock) { blacklistSnipers(recipient);
253             } else if (block.number < antiSniperMevBlock) { require(recipient == tx.origin, "Sniper MEV blocked"); }
254         } else { require(!blacklisted[sender], "Wallet blacklisted");
255         }
256 
257         if ( sender != address(this) && recipient != address(this) && sender != owner
258         ) { require(_checkLimits(sender, recipient, amount),"TX exceeds limits");
259         }
260 
261         _balances[sender] -= amount;
262         _balances[recipient] += amount;
263         emit Transfer(sender, recipient, amount);
264         return true;
265     }
266 
267     function _checkLimits(
268         address sender, address recipient, uint256 transferAmount
269     ) internal view returns (bool) 
270     {
271         bool limitCheckPassed = true;
272         if (tradingOpen && !_noLimits[sender] && !_noLimits[recipient]) {
273             if (transferAmount > _maxTxAmount) { limitCheckPassed = false;
274             } else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) 
275             { limitCheckPassed = false; }
276         }
277         return limitCheckPassed;
278     }
279 
280     function _checkTradingOpen(address sender) private view returns (bool) {
281         bool checkResult = false;
282         if (tradingOpen) { checkResult = true;
283         } else if (_noLimits[sender]) { checkResult = true;
284         }
285         return checkResult;
286     }
287 
288     function isUnlimited(address awallet) external view returns (bool limits) { 
289         return (_noLimits[awallet]);
290     }
291 
292     function isBlacklisted(address awallet) external view returns (bool limits) {
293         return (blacklisted[awallet]);
294     }
295 
296     function setUnlimited(address awallet, bool noLimits) external onlyOwner {
297         if (noLimits) { require(!_isLP[awallet], "Cannot exempt LP"); }
298         _noLimits[awallet] = noLimits;
299     }
300 
301     function maxWallet() external view returns (uint256) { return _maxWalletAmount; }
302 
303     function maxTransaction() external view returns (uint256) { return _maxTxAmount; }
304 
305     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille)
306         external onlyOwner
307     {
308         uint256 newTxAmt = ((_totalSupply * maxTransactionPermille) / 1000) + 10**9;
309         require(newTxAmt >= _maxTxAmount, "tx too low");
310         _maxTxAmount = newTxAmt;
311         uint256 newWalletAmt = ((_totalSupply * maxWalletPermille) / 1000) + 10**9;
312         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
313         _maxWalletAmount = newWalletAmt;
314     }
315 }