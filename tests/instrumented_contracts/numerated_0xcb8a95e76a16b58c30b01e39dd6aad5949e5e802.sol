1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5    _____  U _____ u  _____    ____                ____        |    U _____ u  _____    _   _   
6   |_ " _| \| ___"|/ |_ " _|U |  _"\ u     ___    / __"| u          \| ___"|/ |_ " _|  |'| |'|  
7     | |    |  _|"     | |   \| |_) |/    |_"_|  <\___ \/            |  _|"     | |   /| |_| |\ 
8    /| |\   | |___    /| |\   |  _ <       | |    u___) |            | |___    /| |\  U|  _  |u 
9   u |_|U   |_____|  u |_|U   |_| \_\    U/| |\u  |____/>>           |_____|  u |_|U   |_| |_|  
10   _// \\_  <<   >>  _// \\_  //   \\_.-,_|___|_,-.)(  (__)          <<   >>  _// \\_  //   \\  
11  (__) (__)(__) (__)(__) (__)(__)  (__)\_)-' '-(_/(__)              (__) (__)(__) (__)(_") ("_) 
12 
13   Taxes: 5/5
14 
15   Telegram: http://t.me/TetrisPVP
16   Twitter: https://twitter.com/tetris_eth
17   Website: https://www.tetriseth.live/
18 
19 */
20 
21 pragma solidity 0.8.20;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     function allowance(
40         address owner,
41         address spender
42     ) external view returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(
54         address indexed owner,
55         address indexed spender,
56         uint256 value
57     );
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(
72         uint256 a,
73         uint256 b,
74         string memory errorMessage
75     ) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         return c;
102     }
103 }
104 
105 contract Ownable is Context {
106     address private _owner;
107     event OwnershipTransferred(
108         address indexed previousOwner,
109         address indexed newOwner
110     );
111 
112     constructor() {
113         address msgSender = _msgSender();
114         _owner = msgSender;
115         emit OwnershipTransferred(address(0), msgSender);
116     }
117 
118     function owner() public view returns (address) {
119         return _owner;
120     }
121 
122     modifier onlyOwner() {
123         require(_owner == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     function renounceOwnership() public virtual onlyOwner {
128         emit OwnershipTransferred(_owner, address(0));
129         _owner = address(0);
130     }
131 }
132 
133 interface IUniswapV2Factory {
134     function createPair(
135         address tokenA,
136         address tokenB
137     ) external returns (address pair);
138 }
139 
140 interface IUniswapV2Router02 {
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 
149     function factory() external pure returns (address);
150 
151     function WETH() external pure returns (address);
152 
153     function addLiquidityETH(
154         address token,
155         uint amountTokenDesired,
156         uint amountTokenMin,
157         uint amountETHMin,
158         address to,
159         uint deadline
160     )
161         external
162         payable
163         returns (uint amountToken, uint amountETH, uint liquidity);
164 }
165 
166 contract Tetris is Context, IERC20, Ownable {
167     using SafeMath for uint256;
168     mapping(address => uint256) private _balances;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     mapping(address => bool) private bots;
172     mapping(address => uint256) private _holderLastTransferTimestamp;
173     bool public transferDelayEnabled = true;
174     address payable private _taxWallet;
175 
176     uint256 private _initialBuyTax = 25;
177     uint256 private _initialSellTax = 25;
178     uint256 private _finalBuyTax = 5;
179     uint256 private _finalSellTax = 5;
180     uint256 private _reduceBuyTaxAt = 25;
181     uint256 private _reduceSellTaxAt = 25;
182     uint256 private _preventSwapBefore = 25;
183     uint256 private _buyCount = 0;
184 
185     uint8 private constant _decimals = 9;
186     uint256 private constant _tTotal = 100000000 * 10 ** _decimals;
187     string private constant _name = unicode"tetris";
188     string private constant _symbol = unicode"TETRIS";
189     uint256 public _maxTxAmount = 2000000 * 10 ** _decimals;
190     uint256 public _maxWalletSize = 2000000 * 10 ** _decimals;
191     uint256 public _taxSwapThreshold = 500000 * 10 ** _decimals;
192     uint256 public _maxTaxSwap = 500000 * 10 ** _decimals;
193 
194     IUniswapV2Router02 private uniswapV2Router;
195     address private uniswapV2Pair;
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = false;
199 
200     event MaxTxAmountUpdated(uint _maxTxAmount);
201     modifier lockTheSwap() {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206 
207     constructor() {
208         _taxWallet = payable(_msgSender());
209         _balances[_msgSender()] = _tTotal;
210         _isExcludedFromFee[owner()] = true;
211         _isExcludedFromFee[address(this)] = true;
212         _isExcludedFromFee[_taxWallet] = true;
213 
214         emit Transfer(address(0), _msgSender(), _tTotal);
215     }
216 
217     function name() public pure returns (string memory) {
218         return _name;
219     }
220 
221     function symbol() public pure returns (string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public pure returns (uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() public pure override returns (uint256) {
230         return _tTotal;
231     }
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         return _balances[account];
235     }
236 
237     function transfer(
238         address recipient,
239         uint256 amount
240     ) public override returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244 
245     function allowance(
246         address owner,
247         address spender
248     ) public view override returns (uint256) {
249         return _allowances[owner][spender];
250     }
251 
252     function approve(
253         address spender,
254         uint256 amount
255     ) public override returns (bool) {
256         _approve(_msgSender(), spender, amount);
257         return true;
258     }
259 
260     function transferFrom(
261         address sender,
262         address recipient,
263         uint256 amount
264     ) public override returns (bool) {
265         _transfer(sender, recipient, amount);
266         _approve(
267             sender,
268             _msgSender(),
269             _allowances[sender][_msgSender()].sub(
270                 amount,
271                 "ERC20: transfer amount exceeds allowance"
272             )
273         );
274         return true;
275     }
276 
277     function _approve(address owner, address spender, uint256 amount) private {
278         require(owner != address(0), "ERC20: approve from the zero address");
279         require(spender != address(0), "ERC20: approve to the zero address");
280         _allowances[owner][spender] = amount;
281         emit Approval(owner, spender, amount);
282     }
283 
284     function _transfer(address from, address to, uint256 amount) private {
285         require(from != address(0), "ERC20: transfer from the zero address");
286         require(to != address(0), "ERC20: transfer to the zero address");
287         require(amount > 0, "Transfer amount must be greater than zero");
288         uint256 taxAmount = 0;
289         if (from != owner() && to != owner()) {
290             taxAmount = amount
291                 .mul(
292                     (_buyCount > _reduceBuyTaxAt)
293                         ? _finalBuyTax
294                         : _initialBuyTax
295                 )
296                 .div(100);
297 
298             if (transferDelayEnabled) {
299                 if (
300                     to != address(uniswapV2Router) &&
301                     to != address(uniswapV2Pair)
302                 ) {
303                     require(
304                         _holderLastTransferTimestamp[tx.origin] < block.number,
305                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
306                     );
307                     _holderLastTransferTimestamp[tx.origin] = block.number;
308                 }
309             }
310 
311             if (
312                 from == uniswapV2Pair &&
313                 to != address(uniswapV2Router) &&
314                 !_isExcludedFromFee[to]
315             ) {
316                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
317                 require(
318                     balanceOf(to) + amount <= _maxWalletSize,
319                     "Exceeds the maxWalletSize."
320                 );
321                 _buyCount++;
322             }
323 
324             if (to == uniswapV2Pair && from != address(this)) {
325                 taxAmount = amount
326                     .mul(
327                         (_buyCount > _reduceSellTaxAt)
328                             ? _finalSellTax
329                             : _initialSellTax
330                     )
331                     .div(100);
332             }
333 
334             uint256 contractTokenBalance = balanceOf(address(this));
335             if (
336                 !inSwap &&
337                 to == uniswapV2Pair &&
338                 swapEnabled &&
339                 contractTokenBalance > _taxSwapThreshold &&
340                 _buyCount > _preventSwapBefore
341             ) {
342                 swapTokensForEth(
343                     min(amount, min(contractTokenBalance, _maxTaxSwap))
344                 );
345                 uint256 contractETHBalance = address(this).balance;
346                 if (contractETHBalance > 50000000000000000) {
347                     sendETHToFee(address(this).balance);
348                 }
349             }
350         }
351 
352         if (taxAmount > 0) {
353             _balances[address(this)] = _balances[address(this)].add(taxAmount);
354             emit Transfer(from, address(this), taxAmount);
355         }
356         _balances[from] = _balances[from].sub(amount);
357         _balances[to] = _balances[to].add(amount.sub(taxAmount));
358         emit Transfer(from, to, amount.sub(taxAmount));
359     }
360 
361     function min(uint256 a, uint256 b) private pure returns (uint256) {
362         return (a > b) ? b : a;
363     }
364 
365     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
366         address[] memory path = new address[](2);
367         path[0] = address(this);
368         path[1] = uniswapV2Router.WETH();
369         _approve(address(this), address(uniswapV2Router), tokenAmount);
370         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
371             tokenAmount,
372             0,
373             path,
374             address(this),
375             block.timestamp
376         );
377     }
378 
379     function removeLimits() external onlyOwner {
380         _maxTxAmount = _tTotal;
381         _maxWalletSize = _tTotal;
382         transferDelayEnabled = false;
383         emit MaxTxAmountUpdated(_tTotal);
384     }
385 
386     function sendETHToFee(uint256 amount) private {
387         _taxWallet.transfer(amount);
388     }
389 
390     function openTrading() external onlyOwner {
391         require(!tradingOpen, "trading is already open");
392         uniswapV2Router = IUniswapV2Router02(
393             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
394         );
395         _approve(address(this), address(uniswapV2Router), _tTotal);
396         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
397             address(this),
398             uniswapV2Router.WETH()
399         );
400         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
401             address(this),
402             balanceOf(address(this)),
403             0,
404             0,
405             owner(),
406             block.timestamp
407         );
408         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
409         swapEnabled = true;
410         tradingOpen = true;
411     }
412 
413     receive() external payable {}
414 
415     function manualSwap() external {
416         require(_msgSender() == _taxWallet);
417         uint256 tokenBalance = balanceOf(address(this));
418         if (tokenBalance > 0) {
419             swapTokensForEth(tokenBalance);
420         }
421         uint256 ethBalance = address(this).balance;
422         if (ethBalance > 0) {
423             sendETHToFee(ethBalance);
424         }
425     }
426 }