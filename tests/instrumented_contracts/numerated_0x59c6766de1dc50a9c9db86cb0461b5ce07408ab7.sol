1 /**
2 
3 delegram: https://t.me/spurdoentry
4 
5 dwidder: https://twitter.com/spurdo_fugg
6 
7 **/
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.10;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     function allowance(
30         address owner,
31         address spender
32     ) external view returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 contract Ownable is Context {
51     address private _owner;
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 }
77 
78 interface IUniswapV2Factory {
79     function createPair(
80         address tokenA,
81         address tokenB
82     ) external returns (address pair);
83 }
84 
85 interface IUniswapV2Router02 {
86     function swapExactTokensForETHSupportingFeeOnTransferTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external;
93 
94     function factory() external pure returns (address);
95 
96     function WETH() external pure returns (address);
97 
98     function addLiquidityETH(
99         address token,
100         uint amountTokenDesired,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline
105     )
106         external
107         payable
108         returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract spurdo is Context, IERC20, Ownable {
112     mapping(address => uint256) private _balances;
113     mapping(address => mapping(address => uint256)) private _allowances;
114     mapping(address => bool) private _isExcludedFromFee;
115     mapping(address => uint256) private _holderLastTransferTimestamp;
116     bool public transferDelayEnabled = false;
117     address payable private _taxWallet;
118 
119     uint256 private _initialBuyTax = 10;
120     uint256 private _initialSellTax = 30;
121     uint256 private _finalBuyTax = 1;
122     uint256 private _finalSellTax = 1;
123     uint256 public _reduceBuyTaxAt = 30;
124     uint256 public _reduceSellTaxAt = 45;
125     uint256 private _preventSwapBefore = 30;
126     uint256 private _buyCount = 0;
127 
128     uint8 private constant _decimals = 8;
129     uint256 private constant _tTotal = 69_000_000_000_000 * 10 ** _decimals;
130     string private constant _name = unicode"spurdo";
131     string private constant _symbol = unicode"spurdo";
132     uint256 public _maxTxAmount = _tTotal / 50;
133     uint256 public _maxWalletSize = _tTotal / 50;
134     uint256 public _taxSwapThreshold = _tTotal / 1000;
135     uint256 public _maxTaxSwap = _tTotal / 1000;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142 
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap() {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor() {
151         _taxWallet = payable(_msgSender());
152         _balances[_msgSender()] = _tTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_taxWallet] = true;
156 
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function transfer(
181         address recipient,
182         uint256 amount
183     ) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(
189         address owner,
190         address spender
191     ) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(
196         address spender,
197         uint256 amount
198     ) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(
204         address sender,
205         address recipient,
206         uint256 amount
207     ) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(
210             sender,
211             _msgSender(),
212             _allowances[sender][_msgSender()] - amount
213         );
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount = 0;
229         if (from != owner() && to != owner()) {
230             if (transferDelayEnabled) {
231                 if (
232                     to != address(uniswapV2Router) &&
233                     to != address(uniswapV2Pair)
234                 ) {
235                     require(
236                         _holderLastTransferTimestamp[tx.origin] < block.number,
237                         "Only one transfer per block allowed."
238                     );
239                     _holderLastTransferTimestamp[tx.origin] = block.number;
240                 }
241             }
242 
243             if (
244                 from == uniswapV2Pair &&
245                 to != address(uniswapV2Router) &&
246                 !_isExcludedFromFee[to]
247             ) {
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 require(
250                     balanceOf(to) + amount <= _maxWalletSize,
251                     "Exceeds the maxWalletSize."
252                 );
253                 _buyCount++;
254             }
255 
256             taxAmount =
257                 (amount *
258                     (
259                         (_buyCount > _reduceBuyTaxAt)
260                             ? _finalBuyTax
261                             : _initialBuyTax
262                     )) /
263                 100;
264             if (to == uniswapV2Pair && from != address(this)) {
265                 taxAmount =
266                     (amount *
267                         (
268                             (_buyCount > _reduceSellTaxAt)
269                                 ? _finalSellTax
270                                 : _initialSellTax
271                         )) /
272                     100;
273             }
274 
275             uint256 contractTokenBalance = balanceOf(address(this));
276             if (
277                 !inSwap &&
278                 to == uniswapV2Pair &&
279                 swapEnabled &&
280                 contractTokenBalance > _taxSwapThreshold &&
281                 _buyCount > _preventSwapBefore
282             ) {
283                 swapTokensForEth(
284                     min(amount, min(contractTokenBalance, _maxTaxSwap))
285                 );
286                 uint256 contractETHBalance = address(this).balance;
287                 if (contractETHBalance > 0) {
288                     sendETHToFee(address(this).balance);
289                 }
290             }
291         }
292 
293         if (taxAmount > 0) {
294             _balances[address(this)] = _balances[address(this)] + taxAmount;
295             emit Transfer(from, address(this), taxAmount);
296         }
297         _balances[from] = _balances[from] - amount;
298         _balances[to] = _balances[to] + (amount - taxAmount);
299         emit Transfer(from, to, amount - taxAmount);
300     }
301 
302     function min(uint256 a, uint256 b) private pure returns (uint256) {
303         return (a > b) ? b : a;
304     }
305 
306     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
307         if (tokenAmount == 0) {
308             return;
309         }
310         if (!tradingOpen) {
311             return;
312         }
313         address[] memory path = new address[](2);
314         path[0] = address(this);
315         path[1] = uniswapV2Router.WETH();
316         _approve(address(this), address(uniswapV2Router), tokenAmount);
317         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
318             tokenAmount,
319             0,
320             path,
321             address(this),
322             block.timestamp
323         );
324     }
325 
326     function removeLimits() external onlyOwner {
327         _maxTxAmount = _tTotal;
328         _maxWalletSize = _tTotal;
329         transferDelayEnabled = false;
330         _reduceSellTaxAt = 20;
331         _reduceBuyTaxAt = 20;
332         emit MaxTxAmountUpdated(_tTotal);
333     }
334 
335     function sendETHToFee(uint256 amount) private {
336         _taxWallet.transfer(amount);
337     }
338 
339     function changeSwapAmount(uint256 amount) external onlyOwner {
340         _maxTaxSwap = amount * 1e8;
341         _taxSwapThreshold = _maxTaxSwap;
342     }
343 
344     function Launch() external onlyOwner {
345         require(!tradingOpen, "trading is already open");
346         uniswapV2Router = IUniswapV2Router02(
347             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
348         );
349         _approve(address(this), address(uniswapV2Router), _tTotal);
350         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
351             address(this),
352             uniswapV2Router.WETH()
353         );
354         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
355             address(this),
356             balanceOf(address(this)),
357             0,
358             0,
359             owner(),
360             block.timestamp
361         );
362         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
363         swapEnabled = true;
364         tradingOpen = true;
365     }
366 
367     receive() external payable {}
368 
369     function manualSwap() external {
370         require(_msgSender() == _taxWallet);
371         uint256 tokenBalance = balanceOf(address(this));
372         if (tokenBalance > 0) {
373             swapTokensForEth(tokenBalance);
374         }
375         uint256 ethBalance = address(this).balance;
376         if (ethBalance > 0) {
377             sendETHToFee(ethBalance);
378         }
379     }
380 }