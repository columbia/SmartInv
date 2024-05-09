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
148 contract SB is Context, IERC20, Ownable {
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
170     string private constant _name = unicode"SharesBot";
171     string private constant _symbol = unicode"SB";
172     uint256 public _maxTxAmount = 100_000 * 10 ** _decimals; // 1% of total supply
173     uint256 public _maxWalletSize = 100_000 * 10 ** _decimals; // 1% of total supply
174     uint256 public _taxSwapThreshold = 50_000 * 10 ** _decimals; // 0.5% of total supply
175     uint256 public _maxTaxSwap = 50_000 * 10 ** _decimals; // 0.5% of total supply
176 
177     IUniswapV2Router02 private uniswapV2Router;
178     address private uniswapV2Pair;
179     bool private tradingOpen;
180     bool private inSwap = false;
181     bool private swapEnabled = false;
182 
183     event MaxTxAmountUpdated(uint _maxTxAmount);
184     modifier lockTheSwap() {
185         inSwap = true;
186         _;
187         inSwap = false;
188     }
189 
190     constructor() {
191         uniswapV2Router = IUniswapV2Router02(
192             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
193         );
194         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
195             address(this),
196             uniswapV2Router.WETH()
197         );
198 
199         _taxWallet = payable(_msgSender());
200         _balances[_msgSender()] = _tTotal;
201         _isExcludedFromFee[owner()] = true;
202         _isExcludedFromFee[address(this)] = true;
203         _isExcludedFromFee[_taxWallet] = true;
204 
205         emit Transfer(address(0), _msgSender(), _tTotal);
206     }
207 
208     function name() public pure returns (string memory) {
209         return _name;
210     }
211 
212     function symbol() public pure returns (string memory) {
213         return _symbol;
214     }
215 
216     function decimals() public pure returns (uint8) {
217         return _decimals;
218     }
219 
220     function totalSupply() public pure override returns (uint256) {
221         return _tTotal;
222     }
223 
224     function balanceOf(address account) public view override returns (uint256) {
225         return _balances[account];
226     }
227 
228     function transfer(
229         address recipient,
230         uint256 amount
231     ) public override returns (bool) {
232         _transfer(_msgSender(), recipient, amount);
233         return true;
234     }
235 
236     function allowance(
237         address owner,
238         address spender
239     ) public view override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(
244         address spender,
245         uint256 amount
246     ) public override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     function transferFrom(
252         address sender,
253         address recipient,
254         uint256 amount
255     ) public override returns (bool) {
256         _transfer(sender, recipient, amount);
257         _approve(
258             sender,
259             _msgSender(),
260             _allowances[sender][_msgSender()].sub(
261                 amount,
262                 "ERC20: transfer amount exceeds allowance"
263             )
264         );
265         return true;
266     }
267 
268     function _approve(address owner, address spender, uint256 amount) private {
269         require(owner != address(0), "ERC20: approve from the zero address");
270         require(spender != address(0), "ERC20: approve to the zero address");
271         _allowances[owner][spender] = amount;
272         emit Approval(owner, spender, amount);
273     }
274 
275     function _transfer(address from, address to, uint256 amount) private {
276         require(from != address(0), "ERC20: transfer from the zero address");
277         require(to != address(0), "ERC20: transfer to the zero address");
278         require(amount > 0, "Transfer amount must be greater than zero");
279         uint256 taxAmount = 0;
280         if (from != owner() && to != owner()) {
281             require(!bots[from] && !bots[to]);
282 
283             if (transferDelayEnabled) {
284                 if (
285                     to != address(uniswapV2Router) &&
286                     to != address(uniswapV2Pair)
287                 ) {
288                     require(
289                         _holderLastTransferTimestamp[tx.origin] < block.number,
290                         "Only one transfer per block allowed."
291                     );
292                     _holderLastTransferTimestamp[tx.origin] = block.number;
293                 }
294             }
295 
296             if (
297                 from == uniswapV2Pair &&
298                 to != address(uniswapV2Router) &&
299                 !_isExcludedFromFee[to]
300             ) {
301                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
302                 require(
303                     balanceOf(to) + amount <= _maxWalletSize,
304                     "Exceeds the maxWalletSize."
305                 );
306                 if (_buyCount < _preventSwapBefore) {
307                     require(!isContract(to));
308                 }
309                 _buyCount++;
310                 _buyerMap[to] = true;
311             }
312 
313             taxAmount = amount
314                 .mul((_isFinalFeeApplied) ? _finalBuyTax : _initialBuyTax)
315                 .div(100);
316             if (to == uniswapV2Pair && from != address(this)) {
317                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
318                 taxAmount = amount
319                     .mul((_isFinalFeeApplied) ? _finalSellTax : _initialSellTax)
320                     .div(100);
321                 require(
322                     _buyCount > _preventSwapBefore || _buyerMap[from],
323                     "Seller is not buyer"
324                 );
325             }
326 
327             uint256 contractTokenBalance = balanceOf(address(this));
328             if (
329                 !inSwap &&
330                 to == uniswapV2Pair &&
331                 swapEnabled &&
332                 contractTokenBalance > _taxSwapThreshold &&
333                 _buyCount > _preventSwapBefore
334             ) {
335                 swapTokensForEth(
336                     min(amount, min(contractTokenBalance, _maxTaxSwap))
337                 );
338                 uint256 contractETHBalance = address(this).balance;
339                 if (contractETHBalance > 0) {
340                     sendETHToFee(address(this).balance);
341                 }
342             }
343         }
344 
345         if (taxAmount > 0) {
346             _balances[address(this)] = _balances[address(this)].add(taxAmount);
347             emit Transfer(from, address(this), taxAmount);
348         }
349         _balances[from] = _balances[from].sub(amount);
350         _balances[to] = _balances[to].add(amount.sub(taxAmount));
351         emit Transfer(from, to, amount.sub(taxAmount));
352     }
353 
354     function min(uint256 a, uint256 b) private pure returns (uint256) {
355         return (a > b) ? b : a;
356     }
357 
358     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
359         if (tokenAmount == 0) {
360             return;
361         }
362         if (!tradingOpen) {
363             return;
364         }
365         address[] memory path = new address[](2);
366         path[0] = address(this);
367         path[1] = uniswapV2Router.WETH();
368         _approve(address(this), address(uniswapV2Router), tokenAmount);
369         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
370             tokenAmount,
371             0,
372             path,
373             address(this),
374             block.timestamp
375         );
376     }
377 
378     function removeLimits() external onlyOwner {
379         _maxTxAmount = _tTotal;
380         _maxWalletSize = _tTotal;
381         transferDelayEnabled = false;
382         emit MaxTxAmountUpdated(_tTotal);
383     }
384 
385     function setFinalTax() external onlyOwner {
386         _isFinalFeeApplied = true;
387     }
388 
389     function setTaxSwapThreshold(uint256 newTax) external onlyOwner {
390         _taxSwapThreshold = newTax;
391     }
392 
393     function setMaxTaxSwap(uint256 newTax) external onlyOwner {
394         _maxTaxSwap = newTax;
395     }
396 
397     function sendETHToFee(uint256 amount) private {
398         _taxWallet.transfer(amount);
399     }
400 
401     function isBot(address a) public view returns (bool) {
402         return bots[a];
403     }
404 
405     function openTrading() external onlyOwner {
406         require(!tradingOpen, "trading is already open");
407         swapEnabled = true;
408         tradingOpen = true;
409     }
410 
411     receive() external payable {}
412 
413     function isContract(address account) private view returns (bool) {
414         uint256 size;
415         assembly {
416             size := extcodesize(account)
417         }
418         return size > 0;
419     }
420 
421     function manualSwap() external {
422         require(_msgSender() == _taxWallet);
423         uint256 tokenBalance = balanceOf(address(this));
424         if (tokenBalance > 0) {
425             swapTokensForEth(tokenBalance);
426         }
427         uint256 ethBalance = address(this).balance;
428         if (ethBalance > 0) {
429             sendETHToFee(ethBalance);
430         }
431     }
432 }