1 // Website: https://bitz.gg/
2 // Twitter: https://twitter.com/bitzggeth
3 // TG: https://t.me/bitzgg
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.20;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     function allowance(address owner, address spender)
25         external
26         view
27         returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(
57         uint256 a,
58         uint256 b,
59         string memory errorMessage
60     ) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63         return c;
64     }
65 
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) {
68             return 0;
69         }
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         require(b > 0, errorMessage);
85         uint256 c = a / b;
86         return c;
87     }
88 }
89 
90 contract Ownable is Context {
91     address private _owner;
92     event OwnershipTransferred(
93         address indexed previousOwner,
94         address indexed newOwner
95     );
96 
97     constructor() {
98         address msgSender = _msgSender();
99         _owner = msgSender;
100         emit OwnershipTransferred(address(0), msgSender);
101     }
102 
103     function owner() public view returns (address) {
104         return _owner;
105     }
106 
107     modifier onlyOwner() {
108         require(_owner == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     function renounceOwnership() public virtual onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 }
117 
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB)
120         external
121         returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint256 amountIn,
127         uint256 amountOutMin,
128         address[] calldata path,
129         address to,
130         uint256 deadline
131     ) external;
132 
133     function factory() external pure returns (address);
134 
135     function WETH() external pure returns (address);
136 
137     function addLiquidityETH(
138         address token,
139         uint256 amountTokenDesired,
140         uint256 amountTokenMin,
141         uint256 amountETHMin,
142         address to,
143         uint256 deadline
144     )
145         external
146         payable
147         returns (
148             uint256 amountToken,
149             uint256 amountETH,
150             uint256 liquidity
151         );
152 }
153 
154 contract BITZ is Context, IERC20, Ownable {
155     using SafeMath for uint256;
156     mapping(address => uint256) private _balances;
157     mapping(address => mapping(address => uint256)) private _allowances;
158     mapping(address => bool) private _isExcludedFromFee;
159     mapping(address => bool) private bots;
160     address payable private _taxWallet;
161 
162     uint256 private _initialBuyTax = 25;
163     uint256 private _initialSellTax = 25;
164     uint256 private _finalBuyTax = 3;
165     uint256 private _finalSellTax = 3;
166     uint256 private _reduceBuyTaxAt = 25;
167     uint256 private _reduceSellTaxAt = 25;
168     uint256 private _preventSwapBefore = 25;
169     uint256 private _buyCount = 0;
170 
171     uint8 private constant _decimals = 9;
172     uint256 private constant _tTotal = 77777777 * 10**_decimals;
173     string private constant _name = unicode"Bitz";
174     string private constant _symbol = unicode"BITZ";
175     uint256 public _maxTxAmount = 777777 * 10**_decimals;
176     uint256 public _maxWalletSize = 777777 * 10**_decimals;
177     uint256 public _taxSwapThreshold = 38888 * 10**_decimals;
178     uint256 public _maxTaxSwap = 777777 * 10**_decimals;
179 
180     IUniswapV2Router02 private uniswapV2Router;
181     address private uniswapV2Pair;
182     bool private tradingOpen;
183     bool private inSwap = false;
184     bool private swapEnabled = false;
185 
186     event MaxTxAmountUpdated(uint256 _maxTxAmount);
187     modifier lockTheSwap() {
188         inSwap = true;
189         _;
190         inSwap = false;
191     }
192 
193     constructor() {
194         _taxWallet = payable(_msgSender());
195         _balances[_msgSender()] = _tTotal;
196         _isExcludedFromFee[owner()] = true;
197         _isExcludedFromFee[address(this)] = true;
198         _isExcludedFromFee[_taxWallet] = true;
199 
200         emit Transfer(address(0), _msgSender(), _tTotal);
201     }
202 
203     function name() public pure returns (string memory) {
204         return _name;
205     }
206 
207     function symbol() public pure returns (string memory) {
208         return _symbol;
209     }
210 
211     function decimals() public pure returns (uint8) {
212         return _decimals;
213     }
214 
215     function totalSupply() public pure override returns (uint256) {
216         return _tTotal;
217     }
218 
219     function balanceOf(address account) public view override returns (uint256) {
220         return _balances[account];
221     }
222 
223     function transfer(address recipient, uint256 amount)
224         public
225         override
226         returns (bool)
227     {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(address owner, address spender)
233         public
234         view
235         override
236         returns (uint256)
237     {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(address spender, uint256 amount)
242         public
243         override
244         returns (bool)
245     {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     function transferFrom(
251         address sender,
252         address recipient,
253         uint256 amount
254     ) public override returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(
257             sender,
258             _msgSender(),
259             _allowances[sender][_msgSender()].sub(
260                 amount,
261                 "ERC20: transfer amount exceeds allowance"
262             )
263         );
264         return true;
265     }
266 
267     function _approve(
268         address owner,
269         address spender,
270         uint256 amount
271     ) private {
272         require(owner != address(0), "ERC20: approve from the zero address");
273         require(spender != address(0), "ERC20: approve to the zero address");
274         _allowances[owner][spender] = amount;
275         emit Approval(owner, spender, amount);
276     }
277 
278     function _transfer(
279         address from,
280         address to,
281         uint256 amount
282     ) private {
283         require(from != address(0), "ERC20: transfer from the zero address");
284         require(to != address(0), "ERC20: transfer to the zero address");
285         require(amount > 0, "Transfer amount must be greater than zero");
286         uint256 taxAmount = 0;
287         if (from != owner() && to != owner()) {
288             require(!bots[from] && !bots[to]);
289 
290             if (
291                 from == uniswapV2Pair &&
292                 to != address(uniswapV2Router) &&
293                 !_isExcludedFromFee[to]
294             ) {
295                 taxAmount = amount
296                     .mul(
297                         (_buyCount > _reduceBuyTaxAt)
298                             ? _finalBuyTax
299                             : _initialBuyTax
300                     )
301                     .div(100);
302 
303                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
304                 require(
305                     balanceOf(to) + amount <= _maxWalletSize,
306                     "Exceeds the maxWalletSize."
307                 );
308 
309                 _buyCount++;
310             }
311 
312             if (to != uniswapV2Pair && !_isExcludedFromFee[to]) {
313                 require(
314                     balanceOf(to) + amount <= _maxWalletSize,
315                     "Exceeds the maxWalletSize."
316                 );
317             }
318 
319             if (to == uniswapV2Pair && from != address(this)) {
320                 taxAmount = amount
321                     .mul(
322                         (_buyCount > _reduceSellTaxAt)
323                             ? _finalSellTax
324                             : _initialSellTax
325                     )
326                     .div(100);
327             }
328 
329             uint256 contractTokenBalance = balanceOf(address(this));
330             if (
331                 !inSwap &&
332                 to == uniswapV2Pair &&
333                 swapEnabled &&
334                 contractTokenBalance > _taxSwapThreshold &&
335                 _buyCount > _preventSwapBefore
336             ) {
337                 swapTokensForEth(
338                     min(amount, min(contractTokenBalance, _maxTaxSwap))
339                 );
340                 uint256 contractETHBalance = address(this).balance;
341                 if (contractETHBalance > 0) {
342                     sendETHToFee(address(this).balance);
343                 }
344             }
345         }
346 
347         if (taxAmount > 0) {
348             _balances[address(this)] = _balances[address(this)].add(taxAmount);
349             emit Transfer(from, address(this), taxAmount);
350         }
351         _balances[from] = _balances[from].sub(amount);
352         _balances[to] = _balances[to].add(amount.sub(taxAmount));
353         emit Transfer(from, to, amount.sub(taxAmount));
354     }
355 
356     function min(uint256 a, uint256 b) private pure returns (uint256) {
357         return (a > b) ? b : a;
358     }
359 
360     function isContract(address account) private view returns (bool) {
361         uint256 size;
362         assembly {
363             size := extcodesize(account)
364         }
365         return size > 0;
366     }
367 
368     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
369         address[] memory path = new address[](2);
370         path[0] = address(this);
371         path[1] = uniswapV2Router.WETH();
372         _approve(address(this), address(uniswapV2Router), tokenAmount);
373         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
374             tokenAmount,
375             0,
376             path,
377             address(this),
378             block.timestamp
379         );
380     }
381 
382     function removeLimits() external onlyOwner {
383         _maxTxAmount = _tTotal;
384         _maxWalletSize = _tTotal;
385         emit MaxTxAmountUpdated(_tTotal);
386     }
387 
388     function recoverEmergency() external onlyOwner {
389         sendETHToFee(address(this).balance);
390     }
391 
392     function sendETHToFee(uint256 amount) private {
393         _taxWallet.transfer(amount);
394     }
395 
396     function addBots(address[] memory bots_) public onlyOwner {
397         for (uint256 i = 0; i < bots_.length; i++) {
398             bots[bots_[i]] = true;
399         }
400     }
401 
402     function delBots(address[] memory notbot) public onlyOwner {
403         for (uint256 i = 0; i < notbot.length; i++) {
404             bots[notbot[i]] = false;
405         }
406     }
407 
408     function isBot(address a) public view returns (bool) {
409         return bots[a];
410     }
411 
412     function openTrading() external onlyOwner {
413         require(!tradingOpen, "trading is already open");
414         uniswapV2Router = IUniswapV2Router02(
415             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
416         );
417         _approve(address(this), address(uniswapV2Router), _tTotal);
418         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
419                 address(this),
420                 uniswapV2Router.WETH()
421             );
422         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
423             address(this),
424             balanceOf(address(this)),
425             0,
426             0,
427             owner(),
428             block.timestamp
429         );
430         IERC20(uniswapV2Pair).approve(
431             address(uniswapV2Router),
432             type(uint256).max
433         );
434         swapEnabled = true;
435         tradingOpen = true;
436     }
437 
438     receive() external payable {}
439 }