1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.19;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         _setOwner(_msgSender());
23     }
24 
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28 
29     modifier onlyOwner() {
30         require(owner() == _msgSender(), "Ownable: caller is not the owner");
31         _;
32     }
33 
34     function renounceOwnership() public virtual onlyOwner {
35         _setOwner(address(0));
36     }
37 
38     function transferOwnership(address newOwner) public virtual onlyOwner {
39         require(newOwner != address(0), "Ownable: new owner is the zero address");
40         _setOwner(newOwner);
41     }
42 
43     function _setOwner(address newOwner) private {
44         address oldOwner = _owner;
45         _owner = newOwner;
46         emit OwnershipTransferred(oldOwner, newOwner);
47     }
48 }
49 
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 interface IERC20Metadata is IERC20 {
62 
63     function name() external view returns (string memory);
64     function symbol() external view returns (string memory);
65     function decimals() external view returns (uint8);
66 }
67 
68 
69 contract ERC20 is Context, IERC20, IERC20Metadata {
70     mapping(address => uint256) private _balances;
71 
72     mapping(address => mapping(address => uint256)) private _allowances;
73 
74     uint256 private _totalSupply;
75 
76     string private _name;
77     string private _symbol;
78 
79 
80     constructor(string memory name_, string memory symbol_) {
81         _name = name_;
82         _symbol = symbol_;
83     }
84 
85     function name() public view virtual override returns (string memory) {
86         return _name;
87     }
88 
89     function symbol() public view virtual override returns (string memory) {
90         return _symbol;
91     }
92 
93     function decimals() public view virtual override returns (uint8) {
94         return 18;
95     }
96 
97     function totalSupply() public view virtual override returns (uint256) {
98         return _totalSupply;
99     }
100 
101     function balanceOf(address account) public view virtual override returns (uint256) {
102         return _balances[account];
103     }
104 
105     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(_msgSender(), recipient, amount);
107         return true;
108     }
109 
110     function allowance(address owner, address spender) public view virtual override returns (uint256) {
111         return _allowances[owner][spender];
112     }
113 
114     function approve(address spender, uint256 amount) public virtual override returns (bool) {
115         _approve(_msgSender(), spender, amount);
116         return true;
117     }
118 
119     function transferFrom(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) public virtual override returns (bool) {
124         _transfer(sender, recipient, amount);
125 
126         uint256 currentAllowance = _allowances[sender][_msgSender()];
127         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
128         unchecked {
129             _approve(sender, _msgSender(), currentAllowance - amount);
130         }
131 
132         return true;
133     }
134 
135     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
136         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
137         return true;
138     }
139 
140     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
141         uint256 currentAllowance = _allowances[_msgSender()][spender];
142         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
143         unchecked {
144             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
145         }
146 
147         return true;
148     }
149 
150     function _transfer(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) internal virtual {
155         require(sender != address(0), "ERC20: transfer from the zero address");
156         require(recipient != address(0), "ERC20: transfer to the zero address");
157 
158         _beforeTokenTransfer(sender, recipient, amount);
159 
160         uint256 senderBalance = _balances[sender];
161         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
162         unchecked {
163             _balances[sender] = senderBalance - amount;
164         }
165         _balances[recipient] += amount;
166 
167         emit Transfer(sender, recipient, amount);
168 
169         _afterTokenTransfer(sender, recipient, amount);
170     }
171 
172     function _createTotalSupply(address account, uint256 amount) internal virtual {
173         require(account != address(0), "ERC20: mint to the zero address");
174 
175         _beforeTokenTransfer(address(0), account, amount);
176 
177         _totalSupply += amount;
178         _balances[account] += amount;
179         emit Transfer(address(0), account, amount);
180 
181         _afterTokenTransfer(address(0), account, amount);
182     }
183 
184     function _approve(
185         address owner,
186         address spender,
187         uint256 amount
188     ) internal virtual {
189         require(owner != address(0), "ERC20: approve from the zero address");
190         require(spender != address(0), "ERC20: approve to the zero address");
191 
192         _allowances[owner][spender] = amount;
193         emit Approval(owner, spender, amount);
194     }
195 
196     function _beforeTokenTransfer(
197         address from,
198         address to,
199         uint256 amount
200     ) internal virtual {}
201 
202     function _afterTokenTransfer(
203         address from,
204         address to,
205         uint256 amount
206     ) internal virtual {}
207 }
208 
209 
210 interface IUniswapV2Factory {
211     function createPair(address tokenA, address tokenB) external returns (address pair);
212 }
213 
214 interface IUniswapV2Router02 {
215     function swapExactTokensForETHSupportingFeeOnTransferTokens(
216         uint amountIn,
217         uint amountOutMin,
218         address[] calldata path,
219         address to,
220         uint deadline
221     ) external;
222     function factory() external pure returns (address);
223     function WETH() external pure returns (address);
224     function addLiquidityETH(
225         address token,
226         uint amountTokenDesired,
227         uint amountTokenMin,
228         uint amountETHMin,
229         address to,
230         uint deadline
231     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
232 }
233 
234 library SafeMath {
235     function add(uint256 a, uint256 b) internal pure returns (uint256) {
236         uint256 c = a + b;
237         require(c >= a, "SafeMath: addition overflow");
238         return c;
239     }
240 
241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242         return sub(a, b, "SafeMath: subtraction overflow");
243     }
244 
245     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b <= a, errorMessage);
247         uint256 c = a - b;
248         return c;
249     }
250 
251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252         if (a == 0) {
253             return 0;
254         }
255         uint256 c = a * b;
256         require(c / a == b, "SafeMath: multiplication overflow");
257         return c;
258     }
259 
260     function div(uint256 a, uint256 b) internal pure returns (uint256) {
261         return div(a, b, "SafeMath: division by zero");
262     }
263 
264     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b > 0, errorMessage);
266         uint256 c = a / b;
267         return c;
268     }
269 
270 }
271 
272 contract JDB is ERC20, Ownable {
273 
274     using SafeMath for uint256;
275 
276      IUniswapV2Router02 public uniswapV2Router;
277     address public immutable uniswapV2Pair;
278 
279     uint256 public liquidityFee = 2; 
280     uint256 public marketingFee = 3; 
281     uint256 public devFee = 4;
282     uint256 public totalFee = liquidityFee.add(marketingFee).add(devFee);
283     
284     uint256 public swapTokensAtAmount = 100000 * (10**18);
285 
286     address payable public marketingWallet = payable(0x7bfaD1a6358872de51298f4752bAea427d12dCc9);
287     address payable public devWallet = payable(0x325a7544BB0c46DB9de43fB754BAbbc7f9a9338f);
288 
289     mapping (address => bool) private _isExcludedFromFees;
290     mapping (address => bool) public automatedMarketMakerPairs;
291  
292     bool private inSwapAndLiquify;
293     bool public swapAndLiquifyEnabled = true;
294   
295     event SwapAndLiquifyEnabledUpdated(bool enabled);
296     event SwapEthForTokens(uint256 amountIn, address[] path);
297     event SwapAndLiquify(uint256 tokensIntoLiqudity, uint256 ethReceived);
298     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
299     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
300     event ExcludeFromFees(address indexed account, bool isExcluded);
301     
302     event SwapAndLiquify(
303         uint256 tokensSwapped,
304         uint256 ethReceived,
305         uint256 tokensIntoLiqudity
306     );
307 
308     modifier lockTheSwap {
309         inSwapAndLiquify = true;
310         _;
311         inSwapAndLiquify = false;
312     }
313 
314     constructor() ERC20("Just Data from Blockchain", "JDB") {
315     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
316 
317          // Create a uniswap pair for this new token
318         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
319             .createPair(address(this), _uniswapV2Router.WETH());
320 
321         uniswapV2Router = _uniswapV2Router;
322         uniswapV2Pair = _uniswapV2Pair;
323 
324 
325         // exclude from paying fees or having max transaction amount
326         excludeFromFees(owner(), true);
327         excludeFromFees(marketingWallet, true);
328         excludeFromFees(devWallet, true);
329         excludeFromFees(address(this), true);
330 
331         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
332         
333         /*
334             internal function  that is only called here,
335             and CANNOT be called ever again
336         */
337         _createTotalSupply(owner(), 100000000 * (10**18));
338     }
339 
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) internal override {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347        
348         if(amount == 0) {
349             super._transfer(from, to, 0);
350             return;
351         }
352 
353         uint256 contractTokenBalance = balanceOf(address(this));
354         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
355 
356         if (
357             !inSwapAndLiquify &&
358             overMinTokenBalance &&
359             automatedMarketMakerPairs[to] &&
360             swapAndLiquifyEnabled
361         ) {
362             contractTokenBalance = swapTokensAtAmount;
363             swapAndLiquify(contractTokenBalance);
364         }
365 
366          if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
367             uint256 _feeTokens = amount.mul(totalFee).div(100);
368             amount = amount.sub(_feeTokens);
369             super._transfer(from, address(this), _feeTokens);
370             
371          }
372 
373         super._transfer(from, to, amount);
374 
375     }
376 
377     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
378         uint256 liquidityTokens = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
379         uint256 swappableTokens = contractTokenBalance.sub(liquidityTokens);
380 
381         swapTokensForEth(swappableTokens);
382 
383         uint256 totalEthBalance = address(this).balance;
384         uint256 ethForLiquidity = totalEthBalance.mul(liquidityFee).div(totalFee).div(2);
385 
386         addLiquidity(liquidityTokens, ethForLiquidity);
387 
388         emit SwapAndLiquify(liquidityTokens, ethForLiquidity, swappableTokens);
389 
390         uint256 remainingEth = totalEthBalance.sub(ethForLiquidity);
391     
392         uint256 ethForMarketing = remainingEth.mul(marketingFee).div(marketingFee.add(devFee));
393         uint256 ethForDev = remainingEth.sub(ethForMarketing);
394 
395         marketingWallet.transfer(ethForMarketing);
396         devWallet.transfer(ethForDev);
397     }
398 
399 
400     function swapTokensForEth(uint256 tokenAmount) private {
401         // generate the uniswap pair path of token -> weth
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405 
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407 
408         // make the swap
409         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
410             tokenAmount,
411             0, // accept any amount of ETH
412             path,
413             address(this), // The contract
414             block.timestamp
415         );
416         
417     }
418 
419 
420     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
421         // approve token transfer to cover all possible scenarios
422         _approve(address(this), address(uniswapV2Router), tokenAmount);
423 
424         // add the liquidity
425         uniswapV2Router.addLiquidityETH{value: ethAmount}(
426             address(this),
427             tokenAmount,
428             0, // slippage is unavoidable
429             0, // slippage is unavoidable
430             owner(),
431             block.timestamp
432         );
433     }
434 
435 
436      function updateUniswapV2Router(address newAddress) public onlyOwner {
437         require(newAddress != address(uniswapV2Router), "The router already has that address");
438         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
439         uniswapV2Router = IUniswapV2Router02(newAddress);
440     }
441 
442     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
443         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
444         _setAutomatedMarketMakerPair(pair, value);
445     }
446 
447     function _setAutomatedMarketMakerPair(address pair, bool value) private {
448         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
449         automatedMarketMakerPairs[pair] = value;
450         emit SetAutomatedMarketMakerPair(pair, value);
451     }
452 
453     // owner can't increase the tax. He can only decrease it.
454     event FeesUpdated(uint256 liqFee, uint256 markFee, uint256 devFee);
455 
456     function setFees(uint256 _liqFee, uint256 _markFee, uint256 _devFee) public onlyOwner() {
457         require(_liqFee.add(_markFee).add(_devFee) <= 9, "tax too high");
458         liquidityFee = _liqFee;
459         marketingFee = _markFee;
460         devFee = _devFee;
461         totalFee = _liqFee.add(_markFee).add(_devFee);
462         emit FeesUpdated(_liqFee, _markFee, _devFee);
463     }
464 
465     event WalletsUpdated(address marketingWallet, address devWallet);
466 
467     function updateWallets(address payable _markWallet, address payable _devWallet) public onlyOwner {  
468         marketingWallet = _markWallet;
469         devWallet = _devWallet;
470         emit WalletsUpdated(_markWallet, _devWallet);
471     }
472 
473     function excludeFromFees(address account, bool excluded) public onlyOwner {
474         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
475         _isExcludedFromFees[account] = excluded;
476 
477         emit ExcludeFromFees(account, excluded);
478     }
479 
480     function SetSwapTokensAtAmount(uint256 newLimit) external onlyOwner {
481         require(newLimit > totalSupply().div(1000));
482         swapTokensAtAmount = newLimit;
483     }
484     
485     function isExcludedFromFees(address account) public view returns(bool) {
486         return _isExcludedFromFees[account];
487     }
488     
489     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
490         swapAndLiquifyEnabled = _enabled;
491         emit SwapAndLiquifyEnabledUpdated(_enabled);
492     }
493 
494     receive() external payable {
495 
496   	}
497     
498 }