1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.9.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     function allowance(
22         address owner,
23         address spender
24     ) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(
54         uint256 a,
55         uint256 b,
56         string memory errorMessage
57     ) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89     event OwnershipTransferred(
90         address indexed previousOwner,
91         address indexed newOwner
92     );
93 
94     constructor() {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 }
114 
115 interface IUniswapV2Factory {
116     function createPair(
117         address tokenA,
118         address tokenB
119     ) external returns (address pair);
120 }
121 
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130 
131     function factory() external pure returns (address);
132 
133     function WETH() external pure returns (address);
134 
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     )
143         external
144         payable
145         returns (uint amountToken, uint amountETH, uint liquidity);
146 }
147 
148 contract SharesGram is Context, IERC20, Ownable {
149     using SafeMath for uint256;
150     
151     mapping(address => uint256) private _balances;
152     mapping(address => mapping(address => uint256)) private _allowances;
153     mapping(address => bool) private _isExcludedFromFee;
154     mapping(address => bool) private _buyerMap;
155     mapping(address => bool) private bots;
156     mapping(address => uint256) private _holderLastTransferTimestamp;
157     bool public transferDelayEnabled = false;
158     address payable private _taxWallet;
159 
160     uint256 private _initialBuyTax = 20;
161     uint256 private _initialSellTax = 20;
162     uint256 private _finalBuyTax = 5;
163     uint256 private _finalSellTax = 5;
164     uint256 private _preventSwapBefore = 1;
165     uint256 private _buyCount = 0;
166     bool private _isFinalFeeApplied = false;
167 
168     uint8 private constant _decimals = 18;
169     uint256 private constant _tTotal = 10_000_000 * 10 ** _decimals;
170     string private constant _name = unicode"SharesGram";
171     string private constant _symbol = unicode"SG";
172     uint256 public _maxTxAmount = 50_000 * 10 ** _decimals;
173     uint256 public _maxWalletSize = 50_000 * 10 ** _decimals;
174     uint256 public _taxSwapThreshold = 50_000 * 10 ** _decimals;
175     uint256 public _maxTaxSwap = 50_000 * 10 ** _decimals;
176 
177     IUniswapV2Router02 private uniswapV2Router;
178     address private uniswapV2Pair;
179     bool private tradingOpen = true;
180     bool private inSwap = false;
181     bool private swapEnabled = true;
182 
183     modifier lockTheSwap() {
184         inSwap = true;
185         _;
186         inSwap = false;
187     }
188 
189     constructor() {
190         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
191         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
192         _taxWallet = payable(_msgSender());
193         _balances[_msgSender()] = _tTotal;
194         _isExcludedFromFee[owner()] = true;
195         _isExcludedFromFee[address(this)] = true;
196         _isExcludedFromFee[_taxWallet] = true;
197 
198         emit Transfer(address(0), _msgSender(), _tTotal);
199     }
200 
201     function name() public pure returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() public pure returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public pure override returns (uint256) {
214         return _tTotal;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         return _balances[account];
219     }
220 
221     function transfer(address recipient, uint256 amount) public override returns (bool) {
222         _transfer(_msgSender(), recipient, amount);
223         return true;
224     }
225 
226     function allowance(address owner, address spender) public view override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     function approve(address spender, uint256 amount) public override returns (bool) {
231         _approve(_msgSender(), spender, amount);
232         return true;
233     }
234 
235     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
236         _transfer(sender, recipient, amount);
237         _approve(
238             sender,
239             _msgSender(),
240             _allowances[sender][_msgSender()].sub(
241                 amount,
242                 "ERC20: transfer amount exceeds allowance"
243             )
244         );
245         return true;
246     }
247 
248     function _approve(address owner, address spender, uint256 amount) private {
249         require(owner != address(0), "ERC20: approve from the zero address");
250         require(spender != address(0), "ERC20: approve to the zero address");
251         _allowances[owner][spender] = amount;
252         emit Approval(owner, spender, amount);
253     }
254 
255     function _transfer(address from, address to, uint256 amount) private {
256         require(from != address(0), "ERC20: transfer from the zero address");
257         require(to != address(0), "ERC20: transfer to the zero address");
258         require(amount > 0, "Transfer amount must be greater than zero");
259         uint256 taxAmount = 0;
260         if (from != owner() && to != owner()) {
261             require(!bots[from] && !bots[to]);
262 
263             if (transferDelayEnabled) {
264                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
265                     require(
266                         _holderLastTransferTimestamp[tx.origin] < block.number,
267                         "Only one transfer per block allowed."
268                     );
269                     _holderLastTransferTimestamp[tx.origin] = block.number;
270                 }
271             }
272 
273             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
274                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
275                 require(
276                     balanceOf(to) + amount <= _maxWalletSize,
277                     "Exceeds the maxWalletSize."
278                 );
279                 if (_buyCount < _preventSwapBefore) {
280                     require(!isContract(to));
281                 }
282                 _buyCount++;
283                 _buyerMap[to] = true;
284             }
285 
286             taxAmount = amount.mul((_isFinalFeeApplied) ? _finalBuyTax : _initialBuyTax).div(100);
287             if (to == uniswapV2Pair && from != address(this)) {
288                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
289                 taxAmount = amount.mul((_isFinalFeeApplied) ? _finalSellTax : _initialSellTax).div(100);
290                 require(
291                     _buyCount > _preventSwapBefore || _buyerMap[from],
292                     "Seller is not buyer"
293                 );
294             }
295 
296             uint256 contractTokenBalance = balanceOf(address(this));
297             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
298                 swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
299                 uint256 contractETHBalance = address(this).balance;
300                 if (contractETHBalance > 0) {
301                     sendETHToFee(address(this).balance);
302                 }
303             }
304         }
305 
306         if (taxAmount > 0) {
307             _balances[address(this)] = _balances[address(this)].add(taxAmount);
308             emit Transfer(from, address(this), taxAmount);
309         }
310         _balances[from] = _balances[from].sub(amount);
311         _balances[to] = _balances[to].add(amount.sub(taxAmount));
312         emit Transfer(from, to, amount.sub(taxAmount));
313     }
314 
315     function min(uint256 a, uint256 b) private pure returns (uint256) {
316         return (a > b) ? b : a;
317     }
318 
319     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
320         if (tokenAmount == 0) {
321             return;
322         }
323         if (!tradingOpen) {
324             return;
325         }
326         address[] memory path = new address[](2);
327         path[0] = address(this);
328         path[1] = uniswapV2Router.WETH();
329         _approve(address(this), address(uniswapV2Router), tokenAmount);
330         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
331             tokenAmount,
332             0,
333             path,
334             address(this),
335             block.timestamp
336         );
337     }
338 
339     function removeLimits() external onlyOwner {
340         _maxTxAmount = _tTotal;
341         _maxWalletSize = _tTotal;
342         transferDelayEnabled = false;
343     }
344 
345     function setFinalTax() external onlyOwner {
346         _isFinalFeeApplied = true;
347     }
348 
349     function setTaxSwapThreshold(uint256 newTax) external onlyOwner {
350         _taxSwapThreshold = newTax;
351     }
352 
353     function setMaxTaxSwap(uint256 newTax) external onlyOwner {
354         _maxTaxSwap = newTax;
355     }
356 
357     function sendETHToFee(uint256 amount) private {
358         _taxWallet.transfer(amount);
359     }
360 
361     function isBot(address a) public view returns (bool) {
362         return bots[a];
363     }
364 
365     receive() external payable {}
366 
367     function isContract(address account) private view returns (bool) {
368         uint256 size;
369         assembly {
370             size := extcodesize(account)
371         }
372         return size > 0;
373     }
374 }