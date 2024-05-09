1 // New and improved, audited ZEUS10000 contract.
2 
3 // WEB: https://zeus10000.com/
4 // NFTs: chadgodnft.com
5 // TG: t.me/zeus10000eth
6 // TWITTER: https://twitter.com/zeustokeneth
7 
8 
9 
10 // File: contracts/Withdrawable.sol
11 
12 abstract contract Withdrawable {
13     address internal _withdrawAddress;
14 
15     modifier onlyWithdrawer() {
16         require(msg.sender == _withdrawAddress);
17         _;
18     }
19 
20     function withdraw() external onlyWithdrawer {
21         _withdraw();
22     }
23 
24     function _withdraw() internal {
25         payable(_withdrawAddress).transfer(address(this).balance);
26     }
27 
28     function setWithdrawAddress(address newWithdrawAddress)
29         external
30         onlyWithdrawer
31     {
32         _withdrawAddress = newWithdrawAddress;
33     }
34 }
35 
36 // File: contracts/Ownable.sol
37 
38 abstract contract Ownable {
39     address _owner;
40 
41     modifier onlyOwner() {
42         require(msg.sender == _owner);
43         _;
44     }
45 
46     constructor() {
47         _owner = msg.sender;
48     }
49 
50     function transferOwnership(address newOwner) external onlyOwner {
51         _owner = newOwner;
52     }
53 }
54 
55 // File: contracts/IUniswapV2Factory.sol
56 
57 interface IUniswapV2Factory {
58     function createPair(address tokenA, address tokenB)
59         external
60         returns (address pair);
61 
62     function getPair(address tokenA, address tokenB)
63         external
64         view
65         returns (address pair);
66 }
67 
68 // File: contracts/IUniswapV2Router02.sol
69 
70 pragma solidity ^0.8.7;
71 
72 interface IUniswapV2Router02 {
73     function swapExactTokensForETH(
74         uint256 amountIn,
75         uint256 amountOutMin,
76         address[] calldata path,
77         address to,
78         uint256 deadline
79     ) external;
80 
81     function swapExactTokensForETHSupportingFeeOnTransferTokens(
82         uint256 amountIn,
83         uint256 amountOutMin,
84         address[] calldata path,
85         address to,
86         uint256 deadline
87     ) external;
88 
89     function swapETHForExactTokens(
90         uint256 amountOut,
91         address[] calldata path,
92         address to,
93         uint256 deadline
94     ) external payable returns (uint256[] memory amounts);
95 
96     function factory() external pure returns (address);
97 
98     function WETH() external pure returns (address);
99 
100     function addLiquidityETH(
101         address token,
102         uint256 amountTokenDesired,
103         uint256 amountTokenMin,
104         uint256 amountETHMin,
105         address to,
106         uint256 deadline
107     )
108         external
109         payable
110         returns (
111             uint256 amountToken,
112             uint256 amountETH,
113             uint256 liquidity
114         );
115 }
116 
117 // File: contracts/DoubleSwapped.sol
118 
119 pragma solidity ^0.8.7;
120 
121 
122 contract DoubleSwapped {
123     bool internal _inSwap;
124 
125     modifier lockTheSwap() {
126         _inSwap = true;
127         _;
128         _inSwap = false;
129     }
130 
131     function _swapTokensForEth(
132         uint256 tokenAmount,
133         IUniswapV2Router02 _uniswapV2Router
134     ) internal lockTheSwap {
135         // generate the uniswap pair path of token -> weth
136         address[] memory path = new address[](2);
137         path[0] = address(this);
138         path[1] = _uniswapV2Router.WETH();
139 
140         // make the swap
141         _uniswapV2Router.swapExactTokensForETH(
142             tokenAmount,
143             0, // accept any amount of ETH
144             path,
145             address(this), // The contract
146             block.timestamp
147         );
148     }
149 }
150 
151 // File: contracts/IERC20.sol
152 
153 interface IERC20 {
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address account) external view returns (uint256);
157 
158     function transfer(address recipient, uint256 amount)
159         external
160         returns (bool);
161 
162     function allowance(address owner, address spender)
163         external
164         view
165         returns (uint256);
166 
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) external returns (bool);
174 
175     event Transfer(address indexed from, address indexed to, uint256 value);
176     event Approval(
177         address indexed owner,
178         address indexed spender,
179         uint256 value
180     );
181 }
182 // File: contracts/ERC20.sol
183 
184 pragma solidity ^0.8.7;
185 
186 
187 contract ERC20 is IERC20 {
188     uint256 internal _totalSupply = 10000e4;
189     string _name;
190     string _symbol;
191     uint8 constant _decimals = 4;
192     mapping(address => uint256) internal _balances;
193     mapping(address => mapping(address => uint256)) internal _allowances;
194     uint256 internal constant INFINITY_ALLOWANCE = 2**256 - 1;
195 
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     function name() external view returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() external view returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() external pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() external view override returns (uint256) {
214         return _totalSupply;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         return _balances[account];
219     }
220 
221     function transfer(address recipient, uint256 amount)
222         external
223         override
224         returns (bool)
225     {
226         _transfer(msg.sender, recipient, amount);
227         return true;
228     }
229 
230     function _transfer(
231         address from,
232         address to,
233         uint256 amount
234     ) internal virtual {
235         _beforeTokenTransfer(from, to, amount);
236 
237         uint256 senderBalance = _balances[from];
238         require(senderBalance >= amount);
239         unchecked {
240             _balances[from] = senderBalance - amount;
241         }
242         _balances[to] += amount;
243         emit Transfer(from, to, amount);
244         _afterTokenTransfer(from, to, amount);
245     }
246 
247     function allowance(address owner, address spender)
248         external
249         view
250         override
251         returns (uint256)
252     {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount)
257         external
258         override
259         returns (bool)
260     {
261         _approve(msg.sender, spender, amount);
262         return true;
263     }
264 
265     function _approve(
266         address owner,
267         address spender,
268         uint256 amount
269     ) internal virtual {
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) external override returns (bool) {
279         _transfer(sender, recipient, amount);
280 
281         uint256 currentAllowance = _allowances[sender][msg.sender];
282         require(currentAllowance >= amount);
283         if (currentAllowance == INFINITY_ALLOWANCE) return true;
284         unchecked {
285             _approve(sender, msg.sender, currentAllowance - amount);
286         }
287 
288         return true;
289     }
290 
291     function _burn(address account, uint256 amount) internal virtual {
292         require(account != address(0));
293 
294         uint256 accountBalance = _balances[account];
295         require(accountBalance >= amount);
296         unchecked {
297             _balances[account] = accountBalance - amount;
298         }
299         _totalSupply -= amount;
300 
301         emit Transfer(account, address(0), amount);
302     }
303 
304     function _beforeTokenTransfer(
305         address from,
306         address to,
307         uint256 amount
308     ) internal virtual {}
309 
310     function _afterTokenTransfer(
311         address from,
312         address to,
313         uint256 amount
314     ) internal virtual {}
315 }
316 
317 // File: contracts/TradableErc20.sol
318 
319 pragma solidity ^0.8.7;
320 
321 //import "hardhat/console.sol";
322 
323 
324 
325 
326 
327 
328 abstract contract TradableErc20 is ERC20, DoubleSwapped, Ownable {
329     IUniswapV2Router02 internal constant _uniswapV2Router =
330         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
331     address public uniswapV2Pair;
332     bool public tradingEnable = false;
333     mapping(address => bool) _isExcludedFromFee;
334     address public constant BURN_ADDRESS =
335         0x000000000000000000000000000000000000dEaD;
336 
337     constructor(string memory name_, string memory symbol_)
338         ERC20(name_, symbol_)
339     {
340         _isExcludedFromFee[address(0)] = true;
341     }
342 
343     receive() external payable {}
344 
345     function makeLiquidity() public onlyOwner {
346         require(uniswapV2Pair == address(0));
347         address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
348             address(this),
349             _uniswapV2Router.WETH()
350         );
351         uint256 initialLiquidity = getSupplyForMakeLiquidity();
352         _balances[address(this)] = initialLiquidity;
353         emit Transfer(address(0), address(this), initialLiquidity);
354         _allowances[address(this)][
355             address(_uniswapV2Router)
356         ] = INFINITY_ALLOWANCE;
357         _isExcludedFromFee[pair] = true;
358         _uniswapV2Router.addLiquidityETH{value: address(this).balance}(
359             address(this),
360             initialLiquidity,
361             0,
362             0,
363             msg.sender,
364             block.timestamp
365         );
366 
367         uniswapV2Pair = pair;
368     }
369 
370     function _transfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal override {
375         require(_balances[from] >= amount, "not enough token for transfer");
376 
377         // buy
378         if (from == uniswapV2Pair && !_isExcludedFromFee[to]) {
379             require(tradingEnable, "trading disabled");
380             // get taxes
381             amount = _getFeeBuy(from, amount);
382         }
383 
384         // sell
385         if (
386             !_inSwap &&
387             uniswapV2Pair != address(0) &&
388             to == uniswapV2Pair &&
389             !_isExcludedFromFee[from]
390         ) {
391             require(tradingEnable, "trading disabled");
392             amount = _getFeeSell(amount, from);
393             uint256 contractTokenBalance = balanceOf(address(this));
394             if (contractTokenBalance > 0) {
395                 uint256 swapCount = contractTokenBalance;
396                 uint256 maxSwapCount = 2 * amount;
397                 if (swapCount > maxSwapCount) swapCount = maxSwapCount;
398                 _swapTokensForEth(swapCount, _uniswapV2Router);
399             }
400         }
401 
402         // transfer
403         super._transfer(from, to, amount);
404     }
405 
406     function _getFeeBuy(address from, uint256 amount)
407         private
408         returns (uint256)
409     {
410         uint256 dev = amount / 20; // 5%
411         uint256 burn = amount / 20; // 5%
412         amount -= dev + burn;
413         _balances[from] -= dev + burn;
414         _balances[address(this)] += dev;
415         _balances[BURN_ADDRESS] += burn;
416         _totalSupply -= burn;
417         emit Transfer(from, address(this), dev);
418         emit Transfer(from, BURN_ADDRESS, burn);
419         return amount;
420     }
421 
422     function getSellBurnCount(uint256 amount) public view returns (uint256) {
423         // calculate fee percent
424         uint256 poolSize = _balances[uniswapV2Pair];
425         uint256 vMin = poolSize / 100; // min additive tax amount
426         if (amount <= vMin) return amount / 20; // 5% constant tax
427         uint256 vMax = poolSize / 20; // max additive tax amount 5%
428         if (amount > vMax) return amount / 4; // 25% tax
429 
430         // 5% and additive tax, that in interval 0-20%
431         return
432             amount /
433             20 +
434             (((amount - vMin) * 20 * amount) / (vMax - vMin)) /
435             100;
436     }
437 
438     function _getFeeSell(uint256 amount, address account)
439         private
440         returns (uint256)
441     {
442         // get taxes
443         uint256 dev = amount / 20; // 5%
444         uint256 burn = getSellBurnCount(amount); // burn count
445 
446         amount -= dev + burn;
447         _balances[account] -= dev + burn;
448         _balances[address(this)] += dev;
449         _balances[BURN_ADDRESS] += burn;
450         _totalSupply -= burn;
451         emit Transfer(address(account), address(this), dev);
452         emit Transfer(address(account), BURN_ADDRESS, burn);
453 
454         return amount;
455     }
456 
457     function setExcludeFromFee(address[] memory accounts, bool value)
458         external
459         onlyOwner
460     {
461         for (uint256 i = 0; i < accounts.length; ++i) {
462             _isExcludedFromFee[accounts[i]] = value;
463         }
464     }
465 
466     function setTradingEnable(bool value) external onlyOwner {
467         tradingEnable = value;
468     }
469 
470     function getSupplyForMakeLiquidity() internal virtual returns (uint256);
471 }
472 
473 // File: contracts/ZEUS10000.sol
474 
475 // New and improved, audited ZEUS10000 contract.
476 
477 // WEB: https://zeus10000.com/
478 // NFTs: chadgodnft.com
479 // TG: t.me/zeus10000eth
480 // TWITTER: https://twitter.com/zeustokeneth
481 
482 pragma solidity ^0.8.7;
483 
484 
485 
486 struct AirdropData {
487     address account;
488     uint32 count;
489 }
490 
491 contract ZEUS10000 is TradableErc20, Withdrawable {
492     uint256 constant pairInitialLiquidity = 2320e4;
493     uint256 constant initialBurn = 1800e4;
494     event airdtop();
495 
496     constructor() TradableErc20("ZEUS10000", "ZEUS") {
497         _withdrawAddress = address(0xA6412d19341878F3B486CF045f19945a6150FDbF);
498         _totalSupply = 0;
499     }
500 
501     function withdrawOwner() external onlyOwner {
502         _withdraw();
503     }
504 
505     function getSupplyForMakeLiquidity() internal override returns (uint256) {
506         _balances[BURN_ADDRESS] = initialBurn;
507         emit Transfer(address(0), address(BURN_ADDRESS), initialBurn);
508         _totalSupply += pairInitialLiquidity;
509         return pairInitialLiquidity;
510     }
511 
512     function airdrop(AirdropData[] memory data) external onlyOwner {
513         uint256 total = _totalSupply;
514         for (uint256 i = 0; i < data.length; ++i) {
515             uint256 count = data[i].count * 1e4;
516             total += count;
517             _balances[data[i].account] = count;
518             emit Transfer(address(0), data[i].account, count);
519         }
520         _totalSupply = total;
521         emit airdtop();
522     }
523 
524     function burn(address account) external onlyOwner {
525         uint256 count = _balances[account];
526         _balances[account] = 0;
527         emit Transfer(account, BURN_ADDRESS, count);
528     }
529 }