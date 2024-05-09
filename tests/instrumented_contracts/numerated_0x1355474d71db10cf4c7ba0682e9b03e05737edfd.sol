1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Website: https://jxnt.cc
6 Telegram: https://t.me/jiangxiangnatie
7 Twitter: https://twitter.com/JiangxiangNatie
8 
9 **/
10 pragma solidity 0.8.0;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     function allowance(
29         address owner,
30         address spender
31     ) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48 
49 contract Ownable is Context {
50     address private _owner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75 }
76 
77 interface IUniswapV2Factory {
78     function createPair(
79         address tokenA,
80         address tokenB
81     ) external returns (address pair);
82 }
83 
84 interface IUniswapV2Router02 {
85     function swapExactTokensForETHSupportingFeeOnTransferTokens(
86         uint amountIn,
87         uint amountOutMin,
88         address[] calldata path,
89         address to,
90         uint deadline
91     ) external;
92 
93     function factory() external pure returns (address);
94 
95     function WETH() external pure returns (address);
96 
97     function addLiquidityETH(
98         address token,
99         uint amountTokenDesired,
100         uint amountTokenMin,
101         uint amountETHMin,
102         address to,
103         uint deadline
104     )
105         external
106         payable
107         returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 contract JXNT is Context, IERC20, Ownable {
111     mapping(address => uint256) private _balances;
112     mapping(address => mapping(address => uint256)) private _allowances;
113     mapping(address => bool) private _isExcludedFromFee;
114     mapping(address => uint256) private _holderLastTransferTimestamp;
115     bool public transferDelayEnabled = false;
116     address payable private _taxWallet;
117 
118     uint256 private _initialBuyTax = 50;
119     uint256 private _initialSellTax = 50;
120     uint256 private _finalBuyTax = 2;
121     uint256 private _finalSellTax = 2;
122     uint256 private _reduceBuyTaxAt = 20;
123     uint256 private _reduceSellTaxAt = 30;
124     uint256 private _buyCount = 0;
125 
126     string private constant _name = unicode"酱香拿铁";
127     string private constant _symbol = unicode"酱香拿铁";
128     uint8 private constant _decimals = 18;
129     uint256 private constant _tTotal = 1000000000 * 10 ** _decimals;
130     uint256 public _maxTxAmount = (_tTotal * 1) / 100;
131     uint256 public _maxWalletSize = (_tTotal * 1) / 100;
132     uint256 public _taxSwapThreshold = (_tTotal * 2) / 1000;
133     uint256 public _maxTaxSwap = (_tTotal * 1) / 100;
134     uint256 private _teamShare = (_tTotal * 3) / 100;
135 
136     mapping(address => bool) public whitelist;
137     uint256 private _whitelistMaxAmount = (_tTotal * 1) / 100;
138 
139     IUniswapV2Router02 private uniswapV2Router =
140         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147 
148     modifier lockTheSwap() {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153 
154     constructor() {
155         _taxWallet = payable(_msgSender());
156         _balances[_msgSender()] = _tTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_taxWallet] = true;
160         whitelist[0x18a706e7BB6b509F7d4ab7fc0f6345C2289c045F] = true;
161         whitelist[0xf150f8FC468439e47112E4575B57813c89658054] = true;
162         whitelist[0x9233d4e2F1eEF619FFc3C07220fd89ab1Ac0CE98] = true;
163         whitelist[0x68EC1aB476521EBD04dd7F0dB40D1Bb3f4C00cD7] = true;
164         whitelist[0xC1dB67c856c72716f4e9Db08de52691134876980] = true;
165         whitelist[0x833857D271EA78C80D437E3229c0Ae6AA80bBeE8] = true;
166         whitelist[0x982b22a3e9366176aD9817c3467Fc960DA69f165] = true;
167         whitelist[0x337C0ef05495c731aA677E583b6AC87D2083Ce14] = true;
168         whitelist[0x8dC485e5e3335e365C53fA7533A6998646cB6Baa] = true;
169         whitelist[0x09981aD1f733de8a9549B60A496698eB3eaE0129] = true;
170         whitelist[0x2583c5dDF9C70647BD5E8c8893678303EFB6A8BD] = true;
171         whitelist[0x1FA27b09B23b23517fFd8Ff7C6C67C4CA3cA921f] = true;
172         whitelist[0xC230Fc1bd50aCEfe2b0C815293C3Ed7ff0b90fc2] = true;
173         whitelist[0x5B4ED4Ff7E3e6cF918A345b1145Ae2291454a87f] = true;
174         whitelist[0x2Dac8a8DfDa482d9D9186232294C70af9A342FE5] = true;
175         whitelist[0x43fFa9008317e8fD724bbC668eb8184432B6CCA5] = true;
176         whitelist[0xb7226E67e924df91E32BE53a99240207dd703E5C] = true;
177         whitelist[0xAc4F7ae3AB7Ac57Dd24b723C5dB61e5e32938997] = true;
178         whitelist[0x0F8f7528f7887405baE3f91A38d8244006F77122] = true;
179         whitelist[0xfC055b6BAEa363D48d579646aEc4BcCAca58cD83] = true;
180         whitelist[0xfbB00a557eD7164b6693978af770E3e8c795030b] = true;
181         whitelist[0x7AC0FcDa76dd0e31dedFd8D3AF1378C25acdE38A] = true;
182 
183         emit Transfer(address(0), _msgSender(), _tTotal);
184     }
185 
186     function name() public pure returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public pure returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public pure returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201 
202     function balanceOf(address account) public view override returns (uint256) {
203         return _balances[account];
204     }
205 
206     function transfer(
207         address recipient,
208         uint256 amount
209     ) public override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     function allowance(
215         address owner,
216         address spender
217     ) public view override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     function approve(
222         address spender,
223         uint256 amount
224     ) public override returns (bool) {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228 
229     function transferFrom(
230         address sender,
231         address recipient,
232         uint256 amount
233     ) public override returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(
236             sender,
237             _msgSender(),
238             _allowances[sender][_msgSender()] - amount
239         );
240         return true;
241     }
242 
243     function _approve(address owner, address spender, uint256 amount) private {
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 
248     function _transfer(address from, address to, uint256 amount) private {
249         require(to != address(0), "ERC20: transfer to the zero address");
250         require(amount > 0, "Transfer amount must be greater than zero");
251         uint256 taxAmount = 0;
252         if (from != owner() && to != owner() && !whitelist[to]) {
253             // Delay transfers
254             if (transferDelayEnabled) {
255                 if (
256                     to != address(uniswapV2Router) &&
257                     to != address(uniswapV2Pair)
258                 ) {
259                     require(
260                         _holderLastTransferTimestamp[tx.origin] < block.number,
261                         "Only one transfer per block allowed."
262                     );
263                     _holderLastTransferTimestamp[tx.origin] = block.number;
264                 }
265             }
266 
267             // buy
268             if (
269                 from == uniswapV2Pair &&
270                 to != address(uniswapV2Router) &&
271                 !_isExcludedFromFee[to]
272             ) {
273                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
274                 require(
275                     balanceOf(to) + amount <= _maxWalletSize,
276                     "Exceeds the maxWalletSize."
277                 );
278 
279                 uint256 tax = (_buyCount > _reduceBuyTaxAt)
280                     ? _finalBuyTax
281                     : _initialBuyTax;
282 
283                 taxAmount = (amount * tax) / 100;
284 
285                 _buyCount++;
286             }
287 
288             // sell
289             if (to == uniswapV2Pair && from != address(this)) {
290                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
291                 uint256 tax = (_buyCount > _reduceSellTaxAt)
292                     ? _finalSellTax
293                     : _initialSellTax;
294                 taxAmount = (amount * tax) / 100;
295             }
296 
297             // swap tokens for eth
298             uint256 contractTokenBalance = balanceOf(address(this));
299             if (
300                 !inSwap &&
301                 to == uniswapV2Pair &&
302                 swapEnabled &&
303                 contractTokenBalance > _taxSwapThreshold
304             ) {
305                 swapTokensForEth(
306                     min(amount, min(contractTokenBalance, _maxTaxSwap))
307                 );
308                 uint256 contractETHBalance = address(this).balance;
309                 if (contractETHBalance > 0) {
310                     sendETHToFee(address(this).balance);
311                 }
312             }
313         } else if (whitelist[to]) {
314             require(
315                 amount <= _whitelistMaxAmount,
316                 "Exceeds the _whitelistMaxAmount."
317             );
318         }
319 
320         if (taxAmount > 0) {
321             _balances[address(this)] = _balances[address(this)] + taxAmount;
322             emit Transfer(from, address(this), taxAmount);
323         }
324 
325         _balances[from] = _balances[from] - amount;
326         _balances[to] = _balances[to] + amount - taxAmount;
327         emit Transfer(from, to, amount - taxAmount);
328     }
329 
330     function min(uint256 a, uint256 b) private pure returns (uint256) {
331         return (a > b) ? b : a;
332     }
333 
334     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
335         if (tokenAmount == 0) {
336             return;
337         }
338         if (!tradingOpen) {
339             return;
340         }
341         address[] memory path = new address[](2);
342         path[0] = address(this);
343         path[1] = uniswapV2Router.WETH();
344         _approve(address(this), address(uniswapV2Router), tokenAmount);
345         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
346             tokenAmount,
347             0,
348             path,
349             address(this),
350             block.timestamp
351         );
352     }
353 
354     function removeLimits() external onlyOwner {
355         _maxTxAmount = _tTotal;
356         _maxWalletSize = _tTotal;
357         transferDelayEnabled = false;
358         emit MaxTxAmountUpdated(_tTotal);
359     }
360 
361     function sendETHToFee(uint256 amount) private {
362         _taxWallet.transfer(amount);
363     }
364 
365     function openTrading() external onlyOwner {
366         require(!tradingOpen, "trading is already open");
367 
368         _approve(address(this), address(uniswapV2Router), _tTotal);
369 
370         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
371             address(this),
372             uniswapV2Router.WETH()
373         );
374 
375         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
376             address(this),
377             balanceOf(address(this)) - _teamShare,
378             0,
379             0,
380             owner(),
381             block.timestamp
382         );
383 
384         swapEnabled = true;
385         tradingOpen = true;
386     }
387 
388     function manualSwap() external {
389         require(_msgSender() == _taxWallet);
390         uint256 tokenBalance = balanceOf(address(this));
391         if (tokenBalance > 0) {
392             swapTokensForEth(tokenBalance);
393         }
394         uint256 ethBalance = address(this).balance;
395         if (ethBalance > 0) {
396             sendETHToFee(ethBalance);
397         }
398     }
399 
400     receive() external payable {}
401 }