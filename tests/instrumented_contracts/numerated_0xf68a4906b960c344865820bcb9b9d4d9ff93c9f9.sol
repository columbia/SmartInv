1 /**
2 '$PEPE is a coin for the people, forever.' they claimed. Yet they used the 6.9% 'CEX wallet' to dump on their community.
3 
4 Here to make Pepe great again. No team/CEX tokens, no tax with the LP burned forever. For the people by the people done the right way. Let $PEPE show you the right way.
5 
6 MPGA - Make Pepe Great Again 
7 
8 https://t.me/PepeMPGA
9 
10 https://pepempga.com/
11 
12 https://twitter.com/PepeMPGA
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity >=0.6.0 <0.9.0;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27 
28     function balanceOf(address account) external view returns (uint256);
29 
30     function transfer(
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34 
35     function allowance(
36         address owner,
37         address spender
38     ) external view returns (uint256);
39 
40     function approve(address spender, uint256 amount) external returns (bool);
41 
42     function transferFrom(
43         address sender,
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(
50         address indexed owner,
51         address indexed spender,
52         uint256 value
53     );
54 }
55 
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(
68         uint256 a,
69         uint256 b,
70         string memory errorMessage
71     ) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         return c;
98     }
99 }
100 
101 contract Ownable is Context {
102     address private _owner;
103     event OwnershipTransferred(
104         address indexed previousOwner,
105         address indexed newOwner
106     );
107 
108     constructor() {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     function owner() public view returns (address) {
115         return _owner;
116     }
117 
118     modifier onlyOwner() {
119         require(_owner == _msgSender(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     function createPair(
131         address tokenA,
132         address tokenB
133     ) external returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 
145     function factory() external pure returns (address);
146 
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint amountTokenDesired,
152         uint amountTokenMin,
153         uint amountETHMin,
154         address to,
155         uint deadline
156     )
157         external
158         payable
159         returns (uint amountToken, uint amountETH, uint liquidity);
160 }
161 
162 contract Pepe is Context, IERC20, Ownable {
163     using SafeMath for uint256;
164     
165     mapping(address => uint256) private _balances;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     mapping(address => bool) private _buyerMap;
169     mapping(address => bool) private bots;
170     mapping(address => uint256) private _holderLastTransferTimestamp;
171     bool public transferDelayEnabled = false;
172     address payable private _taxWallet;
173 
174     uint256 private _initialBuyTax = 0;
175     uint256 private _initialSellTax = 0;
176     uint256 private _finalBuyTax = 0;
177     uint256 private _finalSellTax = 0;
178     uint256 private _preventSwapBefore = 1;
179     uint256 private _buyCount = 0;
180     bool private _isFinalFeeApplied = false;
181 
182     uint8 private constant _decimals = 18;
183     uint256 private constant _tTotal = 420_690_000_000_000 * 10 ** _decimals;
184     string private constant _name = unicode"Pepe";
185     string private constant _symbol = unicode"Pepe";
186     uint256 public _maxTxAmount = 4_206_900_000_000 * 10 ** _decimals;
187     uint256 public _maxWalletSize = 4_206_900_000_000 * 10 ** _decimals;
188     uint256 public _taxSwapThreshold = 4_206_900_000_000 * 10 ** _decimals;
189     uint256 public _maxTaxSwap = 4_206_900_000_000 * 10 ** _decimals;
190 
191     IUniswapV2Router02 private uniswapV2Router;
192     address private uniswapV2Pair;
193     bool private tradingOpen = true;
194     bool private inSwap = false;
195     bool private swapEnabled = true;
196 
197     modifier lockTheSwap() {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202 
203     constructor() {
204         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
205         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
206         _taxWallet = payable(_msgSender());
207         _balances[_msgSender()] = _tTotal;
208         _isExcludedFromFee[owner()] = true;
209         _isExcludedFromFee[address(this)] = true;
210         _isExcludedFromFee[_taxWallet] = true;
211 
212         emit Transfer(address(0), _msgSender(), _tTotal);
213     }
214 
215     function name() public pure returns (string memory) {
216         return _name;
217     }
218 
219     function symbol() public pure returns (string memory) {
220         return _symbol;
221     }
222 
223     function decimals() public pure returns (uint8) {
224         return _decimals;
225     }
226 
227     function totalSupply() public pure override returns (uint256) {
228         return _tTotal;
229     }
230 
231     function balanceOf(address account) public view override returns (uint256) {
232         return _balances[account];
233     }
234 
235     function transfer(address recipient, uint256 amount) public override returns (bool) {
236         _transfer(_msgSender(), recipient, amount);
237         return true;
238     }
239 
240     function allowance(address owner, address spender) public view override returns (uint256) {
241         return _allowances[owner][spender];
242     }
243 
244     function approve(address spender, uint256 amount) public override returns (bool) {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
250         _transfer(sender, recipient, amount);
251         _approve(
252             sender,
253             _msgSender(),
254             _allowances[sender][_msgSender()].sub(
255                 amount,
256                 "ERC20: transfer amount exceeds allowance"
257             )
258         );
259         return true;
260     }
261 
262     function _approve(address owner, address spender, uint256 amount) private {
263         require(owner != address(0), "ERC20: approve from the zero address");
264         require(spender != address(0), "ERC20: approve to the zero address");
265         _allowances[owner][spender] = amount;
266         emit Approval(owner, spender, amount);
267     }
268 
269     function _transfer(address from, address to, uint256 amount) private {
270         require(from != address(0), "ERC20: transfer from the zero address");
271         require(to != address(0), "ERC20: transfer to the zero address");
272         require(amount > 0, "Transfer amount must be greater than zero");
273         uint256 taxAmount = 0;
274         if (from != owner() && to != owner()) {
275             require(!bots[from] && !bots[to]);
276 
277             if (transferDelayEnabled) {
278                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
279                     require(
280                         _holderLastTransferTimestamp[tx.origin] < block.number,
281                         "Only one transfer per block allowed."
282                     );
283                     _holderLastTransferTimestamp[tx.origin] = block.number;
284                 }
285             }
286 
287             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
288                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
289                 require(
290                     balanceOf(to) + amount <= _maxWalletSize,
291                     "Exceeds the maxWalletSize."
292                 );
293                 if (_buyCount < _preventSwapBefore) {
294                     require(!isContract(to));
295                 }
296                 _buyCount++;
297                 _buyerMap[to] = true;
298             }
299 
300             taxAmount = amount.mul((_isFinalFeeApplied) ? _finalBuyTax : _initialBuyTax).div(100);
301             if (to == uniswapV2Pair && from != address(this)) {
302                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
303                 taxAmount = amount.mul((_isFinalFeeApplied) ? _finalSellTax : _initialSellTax).div(100);
304                 require(
305                     _buyCount > _preventSwapBefore || _buyerMap[from],
306                     "Seller is not buyer"
307                 );
308             }
309 
310             uint256 contractTokenBalance = balanceOf(address(this));
311             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
312                 swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
313                 uint256 contractETHBalance = address(this).balance;
314                 if (contractETHBalance > 0) {
315                     sendETHToFee(address(this).balance);
316                 }
317             }
318         }
319 
320         if (taxAmount > 0) {
321             _balances[address(this)] = _balances[address(this)].add(taxAmount);
322             emit Transfer(from, address(this), taxAmount);
323         }
324         _balances[from] = _balances[from].sub(amount);
325         _balances[to] = _balances[to].add(amount.sub(taxAmount));
326         emit Transfer(from, to, amount.sub(taxAmount));
327     }
328 
329     function min(uint256 a, uint256 b) private pure returns (uint256) {
330         return (a > b) ? b : a;
331     }
332 
333     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
334         if (tokenAmount == 0) {
335             return;
336         }
337         if (!tradingOpen) {
338             return;
339         }
340         address[] memory path = new address[](2);
341         path[0] = address(this);
342         path[1] = uniswapV2Router.WETH();
343         _approve(address(this), address(uniswapV2Router), tokenAmount);
344         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
345             tokenAmount,
346             0,
347             path,
348             address(this),
349             block.timestamp
350         );
351     }
352 
353     function removeLimits() external onlyOwner {
354         _maxTxAmount = _tTotal;
355         _maxWalletSize = _tTotal;
356         transferDelayEnabled = false;
357     }
358 
359     function setFinalTax() external onlyOwner {
360         _isFinalFeeApplied = true;
361     }
362 
363     function setTaxSwapThreshold(uint256 newTax) external onlyOwner {
364         _taxSwapThreshold = newTax;
365     }
366 
367     function setMaxTaxSwap(uint256 newTax) external onlyOwner {
368         _maxTaxSwap = newTax;
369     }
370 
371     function sendETHToFee(uint256 amount) private {
372         _taxWallet.transfer(amount);
373     }
374 
375     function isBot(address a) public view returns (bool) {
376         return bots[a];
377     }
378 
379     receive() external payable {}
380 
381     function isContract(address account) private view returns (bool) {
382         uint256 size;
383         assembly {
384             size := extcodesize(account)
385         }
386         return size > 0;
387     }
388 }