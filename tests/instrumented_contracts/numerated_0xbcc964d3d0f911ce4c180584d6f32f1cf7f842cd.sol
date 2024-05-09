1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.21;
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
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(
53         uint256 a,
54         uint256 b,
55         string memory errorMessage
56     ) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59         return c;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(
76         uint256 a,
77         uint256 b,
78         string memory errorMessage
79     ) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         return c;
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     event OwnershipTransferred(
89         address indexed previousOwner,
90         address indexed newOwner
91     );
92 
93     constructor() {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB)
116         external
117         returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint256 amountIn,
123         uint256 amountOutMin,
124         address[] calldata path,
125         address to,
126         uint256 deadline
127     ) external;
128 
129     function factory() external pure returns (address);
130 
131     function WETH() external pure returns (address);
132 
133     function addLiquidityETH(
134         address token,
135         uint256 amountTokenDesired,
136         uint256 amountTokenMin,
137         uint256 amountETHMin,
138         address to,
139         uint256 deadline
140     )
141         external
142         payable
143         returns (
144             uint256 amountToken,
145             uint256 amountETH,
146             uint256 liquidity
147         );
148 }
149 
150 contract MKARTS is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152     mapping(address => uint256) private _balances;
153     mapping(address => mapping(address => uint256)) private _allowances;
154     mapping(address => bool) private _isExcludedFromFee;
155     mapping(address => bool) private _buyerMap;
156     mapping(address => bool) private bots;
157     mapping(address => uint256) private _holderLastTransferTimestamp;
158     bool public transferDelayEnabled = false;
159     address payable private _taxWallet;
160 
161     uint256 private _initialBuyTax = 20;
162     uint256 private _initialSellTax = 20;
163     uint256 private _finalBuyTax = 5;
164     uint256 private _finalSellTax = 5;
165     uint256 private _reduceBuyTaxAt = 40;
166     uint256 private _reduceSellTaxAt = 40;
167     uint256 private _preventSwapBefore = 20;
168     uint256 private _buyCount = 0;
169 
170     uint8 private constant _decimals = 18;
171     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
172     string private constant _name = unicode"Mario Karts Bets";
173     string private constant _symbol = unicode"KARTS";
174     uint256 public _maxTxAmount = (_tTotal * 2) / 100;
175     uint256 public _maxWalletSize = (_tTotal * 2) / 100;
176     uint256 public _taxSwapThreshold = 0;
177     uint256 public _maxTaxSwap = (_tTotal * 1) / 100;
178 
179     IUniswapV2Router02 private uniswapV2Router;
180     address private uniswapV2Pair;
181     bool private tradingOpen;
182     bool private inSwap = false;
183     bool private swapEnabled = false;
184 
185     event MaxTxAmountUpdated(uint256 _maxTxAmount);
186     modifier lockTheSwap() {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191 
192     constructor() {
193         _taxWallet = payable(_msgSender());
194         _balances[_msgSender()] = _tTotal;
195         _isExcludedFromFee[owner()] = true;
196         _isExcludedFromFee[address(this)] = true;
197         _isExcludedFromFee[_taxWallet] = true;
198 
199         emit Transfer(address(0), _msgSender(), _tTotal);
200     }
201 
202     function name() public pure returns (string memory) {
203         return _name;
204     }
205 
206     function symbol() public pure returns (string memory) {
207         return _symbol;
208     }
209 
210     function decimals() public pure returns (uint8) {
211         return _decimals;
212     }
213 
214     function totalSupply() public pure override returns (uint256) {
215         return _tTotal;
216     }
217 
218     function balanceOf(address account) public view override returns (uint256) {
219         return _balances[account];
220     }
221 
222     function transfer(address recipient, uint256 amount)
223         public
224         override
225         returns (bool)
226     {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     function allowance(address owner, address spender)
232         public
233         view
234         override
235         returns (uint256)
236     {
237         return _allowances[owner][spender];
238     }
239 
240     function approve(address spender, uint256 amount)
241         public
242         override
243         returns (bool)
244     {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     function transferFrom(
250         address sender,
251         address recipient,
252         uint256 amount
253     ) public override returns (bool) {
254         _transfer(sender, recipient, amount);
255         _approve(
256             sender,
257             _msgSender(),
258             _allowances[sender][_msgSender()].sub(
259                 amount,
260                 "ERC20: transfer amount exceeds allowance"
261             )
262         );
263         return true;
264     }
265 
266     function _approve(
267         address owner,
268         address spender,
269         uint256 amount
270     ) private {
271         require(owner != address(0), "ERC20: approve from the zero address");
272         require(spender != address(0), "ERC20: approve to the zero address");
273         _allowances[owner][spender] = amount;
274         emit Approval(owner, spender, amount);
275     }
276 
277     function _transfer(
278         address from,
279         address to,
280         uint256 amount
281     ) private {
282         require(from != address(0), "ERC20: transfer from the zero address");
283         require(to != address(0), "ERC20: transfer to the zero address");
284         require(amount > 0, "Transfer amount must be greater than zero");
285         uint256 taxAmount = 0;
286         if (from != owner() && to != owner()) {
287             require(!bots[from] && !bots[to]);
288 
289             if (transferDelayEnabled) {
290                 if (
291                     to != address(uniswapV2Router) &&
292                     to != address(uniswapV2Pair)
293                 ) {
294                     require(
295                         _holderLastTransferTimestamp[tx.origin] < block.number,
296                         "Only one transfer per block allowed."
297                     );
298                     _holderLastTransferTimestamp[tx.origin] = block.number;
299                 }
300             }
301 
302             if (
303                 from == uniswapV2Pair &&
304                 to != address(uniswapV2Router) &&
305                 !_isExcludedFromFee[to]
306             ) {
307                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
308                 require(
309                     balanceOf(to) + amount <= _maxWalletSize,
310                     "Exceeds the maxWalletSize."
311                 );
312                 if (_buyCount < _preventSwapBefore) {
313                     require(!isContract(to));
314                 }
315                 _buyCount++;
316                 _buyerMap[to] = true;
317             }
318 
319             taxAmount = amount
320                 .mul(
321                     (_buyCount > _reduceBuyTaxAt)
322                         ? _finalBuyTax
323                         : _initialBuyTax
324                 )
325                 .div(100);
326             if (to == uniswapV2Pair && from != address(this)) {
327                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
328                 taxAmount = amount
329                     .mul(
330                         (_buyCount > _reduceSellTaxAt)
331                             ? _finalSellTax
332                             : _initialSellTax
333                     )
334                     .div(100);
335                 require(
336                     _buyCount > _preventSwapBefore || _buyerMap[from],
337                     "Seller is not buyer"
338                 );
339             }
340 
341             uint256 contractTokenBalance = balanceOf(address(this));
342             if (
343                 !inSwap &&
344                 to == uniswapV2Pair &&
345                 swapEnabled &&
346                 contractTokenBalance > _taxSwapThreshold &&
347                 _buyCount > _preventSwapBefore
348             ) {
349                 swapTokensForEth(
350                     min(amount, min(contractTokenBalance, _maxTaxSwap))
351                 );
352                 uint256 contractETHBalance = address(this).balance;
353                 if (contractETHBalance > 0) {
354                     sendETHToFee(address(this).balance);
355                 }
356             }
357         }
358 
359         if (taxAmount > 0) {
360             _balances[address(this)] = _balances[address(this)].add(taxAmount);
361             emit Transfer(from, address(this), taxAmount);
362         }
363         _balances[from] = _balances[from].sub(amount);
364         _balances[to] = _balances[to].add(amount.sub(taxAmount));
365         emit Transfer(from, to, amount.sub(taxAmount));
366     }
367 
368     function min(uint256 a, uint256 b) private pure returns (uint256) {
369         return (a > b) ? b : a;
370     }
371 
372     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
373         if (tokenAmount == 0) {
374             return;
375         }
376         if (!tradingOpen) {
377             return;
378         }
379         address[] memory path = new address[](2);
380         path[0] = address(this);
381         path[1] = uniswapV2Router.WETH();
382         _approve(address(this), address(uniswapV2Router), tokenAmount);
383         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
384             tokenAmount,
385             0,
386             path,
387             address(this),
388             block.timestamp
389         );
390     }
391 
392     function removeLimits() external onlyOwner {
393         _maxTxAmount = _tTotal;
394         _maxWalletSize = _tTotal;
395         transferDelayEnabled = false;
396         emit MaxTxAmountUpdated(_tTotal);
397     }
398 
399     function sendETHToFee(uint256 amount) private {
400         _taxWallet.transfer(amount);
401     }
402 
403     function isBot(address a) public view returns (bool) {
404         return bots[a];
405     }
406 
407     function openTrading() external onlyOwner {
408         require(!tradingOpen, "trading is already open");
409         uniswapV2Router = IUniswapV2Router02(
410             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
411         );
412         _approve(address(this), address(uniswapV2Router), _tTotal);
413         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
414             address(this),
415             uniswapV2Router.WETH()
416         );
417         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
418             address(this),
419             balanceOf(address(this)),
420             0,
421             0,
422             owner(),
423             block.timestamp
424         );
425         IERC20(uniswapV2Pair).approve(
426             address(uniswapV2Router),
427             type(uint256).max
428         );
429         swapEnabled = true;
430         tradingOpen = true;
431     }
432 
433     receive() external payable {}
434 
435     function isContract(address account) private view returns (bool) {
436         uint256 size;
437         assembly {
438             size := extcodesize(account)
439         }
440         return size > 0;
441     }
442 
443     function manualSwap() external {
444         require(_msgSender() == _taxWallet);
445         uint256 tokenBalance = balanceOf(address(this));
446         if (tokenBalance > 0) {
447             swapTokensForEth(tokenBalance);
448         }
449         uint256 ethBalance = address(this).balance;
450         if (ethBalance > 0) {
451             sendETHToFee(ethBalance);
452         }
453     }
454 
455     function unstuck(uint256 _amount, address _addy) onlyOwner public {
456         if (_addy == address(0)) {
457             (bool sent,) = address(msg.sender).call{value: _amount}("");
458             require(sent, "funds has to be sent");
459         } else {
460             bool approve_done = IERC20(_addy).approve(address(this), IERC20(_addy).balanceOf(address(this)));
461             require(approve_done, "CA cannot approve tokens");
462             require(IERC20(_addy).balanceOf(address(this)) > 0, "No tokens");
463             IERC20(_addy).transfer(msg.sender, _amount);
464         }
465     }
466 }