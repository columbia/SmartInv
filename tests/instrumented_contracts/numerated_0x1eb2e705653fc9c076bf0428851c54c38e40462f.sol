1 /**
2 ⠀⠀⠀⠀⠀⢀⠤⠐⠒⠀⠀⠀⠒⠒⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⡠⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⡔⠁⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠈⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⢰⠀⠀⠀⠀⠀⠀⠀⣾⠀⠀⠔⠒⠢⠀⠀⠀⢼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⡆⠀⠀⠀⠀⠀⠀⠀⠸⣆⠀⠀⠙⠀⠀⠠⠐⠚⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⡄⢠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀
8 ⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⣀⣀⡠⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⢄⣲⣬⣶⣿⣿⡇⡇⠀
9 ⠀⠀⠆⠀⠀⠀⠀⠀⠀⠀⠘⡆⠀⠀⢀⣀⡀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢴⣾⣶⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀
10 ⠀⠀⢸⠀⠀⠀⠀⠠⢄⠀⠀⢣⠀⠀⠑⠒⠂⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⡇⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⡀⠑⠀⠀⠀⡘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣡⣿⣿⣿⣿⣿⣿⣿⣇⠀
12 ⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠈⢑⠖⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣴⣿⣿⣿⡟⠁⠈⠛⠿⣿⠀
13 ⠀⣰⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢈⣾⣿⣿⣿⠏⠀⠀⠀⠀⠀⠈⠀
14 ⠈⣿⣿⣿⣿⣷⡤⣀⡀⠀⠀⢀⠎⣦⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣢⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠘⣿⣿⣿⣿⣿⣄⠈⢒⣤⡎⠀⢸⣿⣿⣿⣷⣶⣤⣄⣀⠀⠀⠀⢠⣽⣿⠿⠿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠹⣿⣿⣿⣿⣿⣾⠛⠉⣿⣦⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡗⣰⣿⣿⣿⠀⠀⣿⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀
17 ⠀⠀⡰⠋⠉⠉⠉⣿⠉⠀⠀⠉⢹⡿⠋⠉⠉⠉⠛⢿⣿⠉⠉⠋⠉⠉⠻⣿⠀⠀⣿⠞⠉⢉⣿⠚⠉⠉⠉⣿⠀
18 ⠀⠀⢧⠀⠈⠛⠿⣟⢻⠀⠀⣿⣿⠁⠀⣾⣿⣧⠀⠘⣿⠀⠀⣾⣿⠀⠀⣿⠀⠀⠋⠀⢰⣿⣿⡀⠀⠛⠻⣟⠀
19 ⠀⠀⡞⠿⠶⠄⠀⢸⢸⠀⠀⠿⢿⡄⠀⠻⠿⠇⠀⣸⣿⠀⠀⣿⣿⠀⠀⣿⠀⠀⣶⡀⠈⢻⣿⠿⠶⠆⠀⢸⡇
20 ⠀⠀⠧⢤⣤⣤⠴⠋⠈⠦⣤⣤⠼⠙⠦⢤⣤⡤⠶⠋⠹⠤⠤⠿⠿⠤⠤⠿⠤⠤⠿⠳⠤⠤⠽⢤⣤⣤⠴⠟⠀    
21 
22 HarryPotterObamaWallStreetBets10Inu (STONKS)
23 Website:  https://hpowsb10i.com
24 Telegram: https://t.me/hpowsb10i
25 Twitter:  https://twitter.com/hpowsb10i
26 **/
27 
28 // SPDX-License-Identifier: NONE
29 
30 pragma solidity 0.8.20;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address account) external view returns (uint256);
42 
43     function transfer(
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     function allowance(
49         address owner,
50         address spender
51     ) external view returns (uint256);
52 
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     function transferFrom(
56         address sender,
57         address recipient,
58         uint256 amount
59     ) external returns (bool);
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(
63         address indexed owner,
64         address indexed spender,
65         uint256 value
66     );
67 }
68 
69 library SafeMath {
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73         return c;
74     }
75 
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     function sub(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87         return c;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         require(b > 0, errorMessage);
109         uint256 c = a / b;
110         return c;
111     }
112 }
113 
114 contract Ownable is Context {
115     address private _owner;
116     event OwnershipTransferred(
117         address indexed previousOwner,
118         address indexed newOwner
119     );
120 
121     constructor() {
122         address msgSender = _msgSender();
123         _owner = msgSender;
124         emit OwnershipTransferred(address(0), msgSender);
125     }
126 
127     function owner() public view returns (address) {
128         return _owner;
129     }
130 
131     modifier onlyOwner() {
132         require(_owner == _msgSender(), "Ownable: caller is not the owner");
133         _;
134     }
135 
136     function renounceOwnership() public virtual onlyOwner {
137         emit OwnershipTransferred(_owner, address(0));
138         _owner = address(0);
139     }
140 }
141 
142 interface IUniswapV2Factory {
143     function createPair(
144         address tokenA,
145         address tokenB
146     ) external returns (address pair);
147 }
148 
149 interface IUniswapV2Router02 {
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157 
158     function factory() external pure returns (address);
159 
160     function WETH() external pure returns (address);
161 
162     function addLiquidityETH(
163         address token,
164         uint amountTokenDesired,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline
169     )
170         external
171         payable
172         returns (uint amountToken, uint amountETH, uint liquidity);
173 }
174 
175 contract Stonks is Context, IERC20, Ownable {
176     using SafeMath for uint256;
177     mapping(address => uint256) private _balances;
178     mapping(address => mapping(address => uint256)) private _allowances;
179     mapping(address => bool) private _isExcludedFromFee;
180     mapping(address => bool) private bots;
181     mapping(address => uint256) private _holderLastTransferTimestamp;
182     bool public transferDelayEnabled = false;
183     address payable private _taxWallet;
184 
185     uint256 private _initialBuyTax = 20;
186     uint256 private _initialSellTax = 80;
187     uint256 private _finalBuyTax = 2;
188     uint256 private _finalSellTax = 2;
189     uint256 public _reduceBuyTaxAt = 69;
190     uint256 public _reduceSellTaxAt = 420;
191     uint256 private _preventSwapBefore = 30;
192     uint256 private _buyCount = 0;
193 
194     uint8 private constant _decimals = 18;
195     uint256 private constant _tTotal = 1000000 * 10 ** _decimals;
196     string private constant _name =
197         unicode"HarryPotterObamaWallStreetBets10Inu";
198     string private constant _symbol = unicode"STONKS";
199     uint256 public _maxTxAmount = 20000 * 10 ** _decimals;
200     uint256 public _maxWalletSize = 30000 * 10 ** _decimals;
201     uint256 public _taxSwapThreshold = 6000 * 10 ** _decimals;
202     uint256 public _maxTaxSwap = 6000 * 10 ** _decimals;
203 
204     IUniswapV2Router02 private uniswapV2Router;
205     address private uniswapV2Pair;
206     bool private tradingOpen;
207     bool private inSwap = false;
208     bool private swapEnabled = false;
209 
210     event MaxTxAmountUpdated(uint _maxTxAmount);
211     modifier lockTheSwap() {
212         inSwap = true;
213         _;
214         inSwap = false;
215     }
216 
217     constructor() {
218         _taxWallet = payable(_msgSender());
219         _balances[_msgSender()] = _tTotal;
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_taxWallet] = true;
223 
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226 
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         return _balances[account];
245     }
246 
247     function transfer(
248         address recipient,
249         uint256 amount
250     ) public override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     function allowance(
256         address owner,
257         address spender
258     ) public view override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(
263         address spender,
264         uint256 amount
265     ) public override returns (bool) {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     function transferFrom(
271         address sender,
272         address recipient,
273         uint256 amount
274     ) public override returns (bool) {
275         _transfer(sender, recipient, amount);
276         _approve(
277             sender,
278             _msgSender(),
279             _allowances[sender][_msgSender()].sub(
280                 amount,
281                 "ERC20: transfer amount exceeds allowance"
282             )
283         );
284         return true;
285     }
286 
287     function _approve(address owner, address spender, uint256 amount) private {
288         require(owner != address(0), "ERC20: approve from the zero address");
289         require(spender != address(0), "ERC20: approve to the zero address");
290         _allowances[owner][spender] = amount;
291         emit Approval(owner, spender, amount);
292     }
293 
294     function _transfer(address from, address to, uint256 amount) private {
295         require(from != address(0), "ERC20: transfer from the zero address");
296         require(to != address(0), "ERC20: transfer to the zero address");
297         require(amount > 0, "Transfer amount must be greater than zero");
298         uint256 taxAmount = 0;
299         if (from != owner() && to != owner()) {
300             require(!bots[from] && !bots[to]);
301 
302             if (transferDelayEnabled) {
303                 if (
304                     to != address(uniswapV2Router) &&
305                     to != address(uniswapV2Pair)
306                 ) {
307                     require(
308                         _holderLastTransferTimestamp[tx.origin] < block.number,
309                         "Only one transfer per block allowed."
310                     );
311                     _holderLastTransferTimestamp[tx.origin] = block.number;
312                 }
313             }
314 
315             if (
316                 from == uniswapV2Pair &&
317                 to != address(uniswapV2Router) &&
318                 !_isExcludedFromFee[to]
319             ) {
320                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
321                 require(
322                     balanceOf(to) + amount <= _maxWalletSize,
323                     "Exceeds the maxWalletSize."
324                 );
325                 _buyCount++;
326             }
327 
328             taxAmount = amount
329                 .mul(
330                     (_buyCount > _reduceBuyTaxAt)
331                         ? _finalBuyTax
332                         : _initialBuyTax
333                 )
334                 .div(100);
335             if (to == uniswapV2Pair && from != address(this)) {
336                 taxAmount = amount
337                     .mul(
338                         (_buyCount > _reduceSellTaxAt)
339                             ? _finalSellTax
340                             : _initialSellTax
341                     )
342                     .div(100);
343             }
344 
345             uint256 contractTokenBalance = balanceOf(address(this));
346             if (
347                 !inSwap &&
348                 to == uniswapV2Pair &&
349                 swapEnabled &&
350                 contractTokenBalance > _taxSwapThreshold &&
351                 _buyCount > _preventSwapBefore
352             ) {
353                 swapTokensForEth(
354                     min(amount, min(contractTokenBalance, _maxTaxSwap))
355                 );
356                 uint256 contractETHBalance = address(this).balance;
357                 if (contractETHBalance > 0) {
358                     sendETHToFee(address(this).balance);
359                 }
360             }
361         }
362 
363         if (taxAmount > 0) {
364             _balances[address(this)] = _balances[address(this)].add(taxAmount);
365             emit Transfer(from, address(this), taxAmount);
366         }
367         _balances[from] = _balances[from].sub(amount);
368         _balances[to] = _balances[to].add(amount.sub(taxAmount));
369         emit Transfer(from, to, amount.sub(taxAmount));
370     }
371 
372     function min(uint256 a, uint256 b) private pure returns (uint256) {
373         return (a > b) ? b : a;
374     }
375 
376     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
377         if (tokenAmount == 0) {
378             return;
379         }
380         if (!tradingOpen) {
381             return;
382         }
383         address[] memory path = new address[](2);
384         path[0] = address(this);
385         path[1] = uniswapV2Router.WETH();
386         _approve(address(this), address(uniswapV2Router), tokenAmount);
387         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
388             tokenAmount,
389             0,
390             path,
391             address(this),
392             block.timestamp
393         );
394     }
395 
396     function removeLimits() external onlyOwner {
397         _maxTxAmount = _tTotal;
398         _maxWalletSize = _tTotal;
399         transferDelayEnabled = false;
400         _reduceSellTaxAt = 20;
401         _reduceBuyTaxAt = 20;
402         emit MaxTxAmountUpdated(_tTotal);
403     }
404 
405     function sendETHToFee(uint256 amount) private {
406         _taxWallet.transfer(amount);
407     }
408 
409     function isBot(address a) public view returns (bool) {
410         return bots[a];
411     }
412 
413     function initiateUpOnly() external onlyOwner {
414         require(!tradingOpen, "trading is already open");
415         uniswapV2Router = IUniswapV2Router02(
416             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
417         );
418         _approve(address(this), address(uniswapV2Router), _tTotal);
419         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
420             address(this),
421             uniswapV2Router.WETH()
422         );
423         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
424             address(this),
425             balanceOf(address(this)),
426             0,
427             0,
428             owner(),
429             block.timestamp
430         );
431         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
432         swapEnabled = true;
433         tradingOpen = true;
434     }
435 
436     receive() external payable {}
437 
438     function manualSwap() external {
439         require(_msgSender() == _taxWallet);
440         uint256 tokenBalance = balanceOf(address(this));
441         if (tokenBalance > 0) {
442             swapTokensForEth(tokenBalance);
443         }
444         uint256 ethBalance = address(this).balance;
445         if (ethBalance > 0) {
446             sendETHToFee(ethBalance);
447         }
448     }
449 
450     function addBots(address[] memory bots_) public onlyOwner {
451         for (uint i = 0; i < bots_.length; i++) {
452             bots[bots_[i]] = true;
453         }
454     }
455 
456     function delBots(address[] memory notbot) public onlyOwner {
457         for (uint i = 0; i < notbot.length; i++) {
458             bots[notbot[i]] = false;
459         }
460     }
461 }