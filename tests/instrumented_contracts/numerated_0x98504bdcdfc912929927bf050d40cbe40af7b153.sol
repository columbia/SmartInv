1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.20;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function decimals() external view returns (uint8);
9 
10     function symbol() external view returns (string memory);
11 
12     function name() external view returns (string memory);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount)
17         external
18         returns (bool);
19 
20     function allowance(address owner, address spender)
21         external
22         view
23         returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 interface IUniswapV2Factory {
42     function createPair(address tokenA, address tokenB)
43         external
44         returns (address pair);
45 }
46 
47 interface IUniswapV2Router02 {
48     function swapExactTokensForETHSupportingFeeOnTransferTokens(
49         uint256 amountIn,
50         uint256 amountOutMin,
51         address[] calldata path,
52         address to,
53         uint256 deadline
54     ) external;
55 
56     function WETH() external pure returns (address);
57 
58     function factory() external pure returns (address);
59 
60     function addLiquidityETH(
61         address token,
62         uint256 amountTokenDesired,
63         uint256 amountTokenMin,
64         uint256 amountETHMin,
65         address to,
66         uint256 deadline
67     )
68         external
69         payable
70         returns (
71             uint256 amountToken,
72             uint256 amountETH,
73             uint256 liquidity
74         );
75 }
76 
77 abstract contract Ownable {
78     address public owner;
79 
80     constructor(address creatorOwner) {
81         owner = creatorOwner;
82     }
83 
84     modifier onlyOwner() {
85         require(msg.sender == owner, "Only owner can call this");
86         _;
87     }
88 
89     function transferOwnership(address payable newOwner) external onlyOwner {
90         owner = newOwner;
91         emit OwnershipTransferred(newOwner);
92     }
93 
94     function renounceOwnership() external onlyOwner {
95         owner = address(0);
96         emit OwnershipTransferred(address(0));
97     }
98 
99     event OwnershipTransferred(address owner);
100 }
101 
102 contract ROK is IERC20, Ownable {
103     uint8 private constant _decimals = 9;
104     uint256 private constant _totalSupply = 4_200_000_000_000 * (10**_decimals);
105     string private constant _name = "Republic of Kekistan";
106     string private constant _symbol = "ROK";
107 
108     uint256 private _launchBlock;
109     uint256 private _maxTxAmount = _totalSupply;
110     uint256 private _maxWalletAmount = _totalSupply;
111 
112     uint256 blacklistBlock;
113     uint256 antiSniperMevBlock;
114     mapping(address => bool) private blacklisted;
115 
116     mapping(address => uint256) private _balances;
117     mapping(address => mapping(address => uint256)) private _allowances;
118     mapping(address => bool) private _noLimits;
119 
120     address private liquidityProvider;
121 
122     address private constant _swapRouterAddress =
123         address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
124     IUniswapV2Router02 private _primarySwapRouter =
125         IUniswapV2Router02(_swapRouterAddress);
126     address private _primaryLP;
127     mapping(address => bool) private _isLP;
128 
129     bool private _tradingOpen;
130 
131     bool private _inTaxSwap = false;
132     modifier lockTaxSwap() {
133         _inTaxSwap = true;
134         _;
135         _inTaxSwap = false;
136     }
137 
138     constructor() Ownable(msg.sender) {
139         _balances[owner] = (_totalSupply * 2) / 100;
140         emit Transfer(address(0), owner, _balances[owner]);
141 
142         _balances[address(this)] = _totalSupply - _balances[owner];
143         emit Transfer(address(0), address(this), _balances[address(this)]);
144 
145         _noLimits[owner] = true;
146         _noLimits[address(this)] = true;
147         _noLimits[_swapRouterAddress] = true;
148     }
149 
150     receive() external payable {}
151 
152     function totalSupply() external pure override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function decimals() external pure override returns (uint8) {
157         return _decimals;
158     }
159 
160     function symbol() external pure override returns (string memory) {
161         return _symbol;
162     }
163 
164     function name() external pure override returns (string memory) {
165         return _name;
166     }
167 
168     function balanceOf(address account) public view override returns (uint256) {
169         return _balances[account];
170     }
171 
172     function allowance(address holder, address spender)
173         external
174         view
175         override
176         returns (uint256)
177     {
178         return _allowances[holder][spender];
179     }
180 
181     function approve(address spender, uint256 amount)
182         public
183         override
184         returns (bool)
185     {
186         _allowances[msg.sender][spender] = amount;
187         emit Approval(msg.sender, spender, amount);
188         return true;
189     }
190 
191     function transfer(address recipient, uint256 amount)
192         external
193         override
194         returns (bool)
195     {
196         require(_checkTradingOpen(msg.sender), "Trading not open");
197         return _transferFrom(msg.sender, recipient, amount);
198     }
199 
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) external override returns (bool) {
205         require(_checkTradingOpen(sender), "Trading not open");
206         if (_allowances[sender][msg.sender] != type(uint256).max) {
207             _allowances[sender][msg.sender] =
208                 _allowances[sender][msg.sender] -
209                 amount;
210         }
211         return _transferFrom(sender, recipient, amount);
212     }
213 
214     function _approveRouter(uint256 _tokenAmount) internal {
215         if (_allowances[address(this)][_swapRouterAddress] < _tokenAmount) {
216             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
217             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
218         }
219     }
220 
221     function addLiquidity() external payable onlyOwner lockTaxSwap {
222         require(_primaryLP == address(0), "LP exists");
223         require(!_tradingOpen, "trading is open");
224         require(
225             msg.value > 0 || address(this).balance > 0,
226             "No ETH in contract or message"
227         );
228         require(_balances[address(this)] > 0, "No tokens in contract");
229         liquidityProvider = msg.sender;
230         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(
231             address(this),
232             _primarySwapRouter.WETH()
233         );
234         _addLiquidity(_balances[address(this)], address(this).balance, false);
235         _isLP[_primaryLP] = true;
236         _openTrading();
237     }
238 
239     function _addLiquidity(
240         uint256 _tokenAmount,
241         uint256 _ethAmountWei,
242         bool autoburn
243     ) internal {
244         address lpTokenRecipient = liquidityProvider;
245         if (autoburn) {
246             lpTokenRecipient = address(0);
247         }
248         _approveRouter(_tokenAmount);
249         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei}(
250             address(this),
251             _tokenAmount,
252             0,
253             0,
254             lpTokenRecipient,
255             block.timestamp
256         );
257     }
258 
259     function _openTrading() internal {
260         _maxTxAmount = (_totalSupply * 1) / 100;
261         _maxWalletAmount = (_totalSupply * 1) / 100;
262         _tradingOpen = true;
263         _launchBlock = block.number;
264         blacklistBlock = block.number + 5;
265         antiSniperMevBlock = block.number + 10;
266     }
267 
268     function blacklistSniper(address wallet) private {
269         if (
270             wallet != _primaryLP &&
271             wallet != owner &&
272             wallet != address(this) &&
273             wallet != _swapRouterAddress
274         ) {
275             blacklisted[wallet] = true;
276         }
277     }
278 
279     function _transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) internal returns (bool) {
284         require(sender != address(0), "No transfers from Zero wallet");
285         if (!_tradingOpen) {
286             require(_noLimits[sender], "Trading not open");
287         } else if (_isLP[sender]) {
288             if (block.number <= blacklistBlock) {
289                 blacklistSniper(recipient);
290             } else if (block.number < antiSniperMevBlock) {
291                 require(recipient == tx.origin, "Sniper MEV blocked");
292             }
293         } else {
294             require(!blacklisted[sender], "Wallet blacklisted");
295         }
296 
297         if (
298             sender != address(this) &&
299             recipient != address(this) &&
300             sender != owner
301         ) {
302             require(_checkLimits(sender, recipient, amount),"TX exceeds limits");
303         }
304 
305         _balances[sender] -= amount;
306         _balances[recipient] += amount;
307         emit Transfer(sender, recipient, amount);
308         return true;
309     }
310 
311     function _checkLimits(
312         address sender,
313         address recipient,
314         uint256 transferAmount
315     ) internal view returns (bool) {
316         bool limitCheckPassed = true;
317         if (_tradingOpen && !_noLimits[sender] && !_noLimits[recipient]) {
318             if (transferAmount > _maxTxAmount) {
319                 limitCheckPassed = false;
320             } else if (
321                 !_isLP[recipient] &&
322                 (_balances[recipient] + transferAmount > _maxWalletAmount)
323             ) {
324                 limitCheckPassed = false;
325             }
326         }
327         return limitCheckPassed;
328     }
329 
330     function _checkTradingOpen(address sender) private view returns (bool) {
331         bool checkResult = false;
332         if (_tradingOpen) {
333             checkResult = true;
334         } else if (_noLimits[sender]) {
335             checkResult = true;
336         }
337         return checkResult;
338     }
339 
340     function isUnlimited(address wallet) external view returns (bool limits) {
341         return (_noLimits[wallet]);
342     }
343 
344     function isBlacklisted(address wallet) external view returns (bool limits) {
345         return (blacklisted[wallet]);
346     }
347 
348     function setUnlimited(address wallet, bool noLimits) external onlyOwner {
349         if (noLimits) {
350             require(!_isLP[wallet], "Cannot exempt LP");
351         }
352         _noLimits[wallet] = noLimits;
353     }
354 
355     function maxWallet() external view returns (uint256) {
356         return _maxWalletAmount;
357     }
358 
359     function maxTransaction() external view returns (uint256) {
360         return _maxTxAmount;
361     }
362 
363     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille)
364         external
365         onlyOwner
366     {
367         uint256 newTxAmt = (_totalSupply * maxTransactionPermille) / 1000 + 1;
368         require(newTxAmt >= _maxTxAmount, "tx too low");
369         _maxTxAmount = newTxAmt;
370         uint256 newWalletAmt = (_totalSupply * maxWalletPermille) / 1000 + 1;
371         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
372         _maxWalletAmount = newWalletAmt;
373     }
374 }