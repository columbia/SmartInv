1 // WiardEthBOT : @WizardEthBot
2 // Community : @WizardBotCommunity
3 // X : https://twitter.com/WizardEthBot
4 // Website : https://wizardbot.org/
5 
6 // SPDX-License-Identifier: Unlicensed
7 
8 pragma solidity ^0.8.16;
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function transfer(
16         address recipient,
17         uint256 amount
18     ) external returns (bool);
19 
20     function allowance(
21         address owner,
22         address spender
23     ) external view returns (uint256);
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
43         return a + b;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a - b;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a * b;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a / b;
56     }
57 
58     function sub(
59         uint256 a,
60         uint256 b,
61         string memory errorMessage
62     ) internal pure returns (uint256) {
63         unchecked {
64             require(b <= a, errorMessage);
65             return a - b;
66         }
67     }
68 
69     function div(
70         uint256 a,
71         uint256 b,
72         string memory errorMessage
73     ) internal pure returns (uint256) {
74         unchecked {
75             require(b > 0, errorMessage);
76             return a / b;
77         }
78     }
79 }
80 
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes calldata) {
87         this;
88         return msg.data;
89     }
90 }
91 
92 abstract contract Ownable is Context {
93     address internal _owner;
94     address private _previousOwner;
95 
96     event OwnershipTransferred(
97         address indexed previousOwner,
98         address indexed newOwner
99     );
100 
101     constructor() {
102         _owner = _msgSender();
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     function owner() public view virtual returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(owner() == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     function transferOwnership(address newOwner) public virtual onlyOwner {
121         require(
122             newOwner != address(0),
123             "Ownable: new owner is the zero address"
124         );
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 interface IERC20Metadata is IERC20 {
131     function name() external view returns (string memory);
132 
133     function symbol() external view returns (string memory);
134 
135     function decimals() external view returns (uint8);
136 }
137 
138 contract ERC20 is Context, Ownable, IERC20, IERC20Metadata {
139     using SafeMath for uint256;
140 
141     mapping(address => uint256) private _balances;
142 
143     mapping(address => mapping(address => uint256)) private _allowances;
144 
145     uint256 private _totalSupply;
146 
147     string private _name;
148     string private _symbol;
149 
150     constructor(string memory name_, string memory symbol_) {
151         _name = name_;
152         _symbol = symbol_;
153     }
154 
155     function name() public view virtual override returns (string memory) {
156         return _name;
157     }
158 
159     function symbol() public view virtual override returns (string memory) {
160         return _symbol;
161     }
162 
163     function decimals() public view virtual override returns (uint8) {
164         return 18;
165     }
166 
167     function totalSupply() public view virtual override returns (uint256) {
168         return _totalSupply;
169     }
170 
171     function balanceOf(
172         address account
173     ) public view virtual override returns (uint256) {
174         return _balances[account];
175     }
176 
177     function transfer(
178         address recipient,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(
186         address owner,
187         address spender
188     ) public view virtual override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(
193         address spender,
194         uint256 amount
195     ) public virtual override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) public virtual override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(
207             sender,
208             _msgSender(),
209             _allowances[sender][_msgSender()].sub(
210                 amount,
211                 "ERC20: transfer amount exceeds allowance"
212             )
213         );
214         return true;
215     }
216 
217     function increaseAllowance(
218         address spender,
219         uint256 addedValue
220     ) public virtual returns (bool) {
221         _approve(
222             _msgSender(),
223             spender,
224             _allowances[_msgSender()][spender].add(addedValue)
225         );
226         return true;
227     }
228 
229     function decreaseAllowance(
230         address spender,
231         uint256 subtractedValue
232     ) public virtual returns (bool) {
233         _approve(
234             _msgSender(),
235             spender,
236             _allowances[_msgSender()][spender].sub(
237                 subtractedValue,
238                 "ERC20: decreased allowance below zero"
239             )
240         );
241         return true;
242     }
243 
244     function _transfer(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) internal virtual {
249         require(sender != address(0), "ERC20: transfer from the zero address");
250         require(recipient != address(0), "ERC20: transfer to the zero address");
251 
252         _beforeTokenTransfer(sender, recipient, amount);
253 
254         _balances[sender] = _balances[sender].sub(
255             amount,
256             "ERC20: transfer amount exceeds balance"
257         );
258         _balances[recipient] = _balances[recipient].add(amount);
259         emit Transfer(sender, recipient, amount);
260     }
261 
262     function _mint(address account, uint256 amount) internal virtual {
263         require(account != address(0), "ERC20: mint to the zero address");
264 
265         _beforeTokenTransfer(address(0), account, amount);
266 
267         _totalSupply = _totalSupply.add(amount);
268         _balances[account] = _balances[account].add(amount);
269         emit Transfer(address(0), account, amount);
270     }
271 
272     function _burn(address account, uint256 amount) internal virtual {
273         require(account != address(0), "ERC20: burn from the zero address");
274 
275         _beforeTokenTransfer(account, address(0), amount);
276 
277         _balances[account] = _balances[account].sub(
278             amount,
279             "ERC20: burn amount exceeds balance"
280         );
281         _totalSupply = _totalSupply.sub(amount);
282         emit Transfer(account, address(0), amount);
283     }
284 
285     function _approve(
286         address owner,
287         address spender,
288         uint256 amount
289     ) internal virtual {
290         require(owner != address(0), "ERC20: approve from the zero address");
291         require(spender != address(0), "ERC20: approve to the zero address");
292 
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296 
297     function _beforeTokenTransfer(
298         address from,
299         address to,
300         uint256 amount
301     ) internal virtual {}
302 }
303 
304 interface IUniswapV2Factory {
305     function createPair(
306         address tokenA,
307         address tokenB
308     ) external returns (address pair);
309 }
310 
311 interface IUniswapV2Pair {
312     function factory() external view returns (address);
313 }
314 
315 interface IUniswapV2Router01 {
316     function factory() external pure returns (address);
317 
318     function WETH() external pure returns (address);
319 
320     function addLiquidityETH(
321         address token,
322         uint amountTokenDesired,
323         uint amountTokenMin,
324         uint amountETHMin,
325         address to,
326         uint deadline
327     )
328         external
329         payable
330         returns (uint amountToken, uint amountETH, uint liquidity);
331 }
332 
333 interface IUniswapV2Router02 is IUniswapV2Router01 {
334     function swapExactTokensForETHSupportingFeeOnTransferTokens(
335         uint amountIn,
336         uint amountOutMin,
337         address[] calldata path,
338         address to,
339         uint deadline
340     ) external;
341 }
342 
343 contract WizardBOT is ERC20 {
344     using SafeMath for uint256;
345 
346     mapping(address => bool) private _isExcludedFromFee;
347     mapping(address => bool) private _isExcludedFromMaxWallet;
348     mapping(address => bool) private _isExcludedFromMaxTnxLimit;
349 
350     address public marketingWallet;
351     address constant _burnAddress = 0x000000000000000000000000000000000000dEaD;
352 
353     uint256 public buyFee = 30;
354     uint256 public sellFee = 30;
355 
356     IUniswapV2Router02 public uniswapV2Router;
357     address public uniswapV2Pair;
358     bool inSwapAndLiquify;
359     bool public swapAndSendFeesEnabled = true;
360     bool public tradingEnabled = false;
361     uint256 public numTokensSellToSendFees;
362     uint256 public maxWalletBalance;
363     uint256 public maxTnxAmount;
364 
365     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
366     event swapAndSendFeesEnabledUpdated(bool enabled);
367     event SwapAndLiquify(
368         uint256 tokensSwapped,
369         uint256 ethReceived,
370         uint256 tokensIntoLiqudity
371     );
372 
373     modifier lockTheSwap() {
374         inSwapAndLiquify = true;
375         _;
376         inSwapAndLiquify = false;
377     }
378 
379     constructor() ERC20("WizardBOT", "WizardBOT") {
380         numTokensSellToSendFees = 5000 * 10 ** decimals();
381         marketingWallet = 0xE97d3B837B0F80fcbD3238B455bF3b6eA5faD3ee;
382 
383         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
384             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
385         );
386         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
387             .createPair(address(this), _uniswapV2Router.WETH());
388 
389         uniswapV2Router = _uniswapV2Router;
390 
391         _isExcludedFromFee[_msgSender()] = true;
392         _isExcludedFromFee[address(this)] = true;
393         _isExcludedFromFee[marketingWallet] = true;
394 
395         _isExcludedFromMaxWallet[owner()] = true;
396         _isExcludedFromMaxWallet[address(this)] = true;
397         _isExcludedFromMaxWallet[_burnAddress] = true;
398         _isExcludedFromMaxWallet[marketingWallet] = true;
399 
400         _isExcludedFromMaxTnxLimit[owner()] = true;
401         _isExcludedFromMaxTnxLimit[address(this)] = true;
402         _isExcludedFromMaxTnxLimit[marketingWallet] = true;
403 
404         _mint(owner(), 1000000 * 10 ** decimals());
405         maxWalletBalance = (totalSupply() * 2) / 100;
406         maxTnxAmount = (totalSupply() * 2) / 100;
407     }
408 
409     function includeAndExcludeFromFee(
410         address account,
411         bool value
412     ) public onlyOwner {
413         _isExcludedFromFee[account] = value;
414     }
415 
416     function includeAndExcludedFromMaxWallet(address account, bool value) public onlyOwner {
417         _isExcludedFromMaxWallet[account] = value;
418     }
419 
420     function includeAndExcludedFromMaxTnxLimit(address account, bool value) public onlyOwner {
421         _isExcludedFromMaxTnxLimit[account] = value;
422     }
423 
424 
425     function isExcludedFromFee(address account) public view returns (bool) {
426         return _isExcludedFromFee[account];
427     }
428     
429     function isExcludedFromMaxWallet(address account) public view returns(bool){
430         return _isExcludedFromMaxWallet[account];
431     }
432 
433     function isExcludedFromMaxTnxLimit(address account) public view returns(bool) {
434         return _isExcludedFromMaxTnxLimit[account];
435     }
436 
437     function enableTrading() external onlyOwner {
438         tradingEnabled = true;
439     }
440 
441     function setBuyAndSellFee(
442         uint256 bFee,
443         uint256 sFee
444     ) external onlyOwner {
445         buyFee = bFee;
446         sellFee = sFee;
447     }
448 
449     function setmarketingWallet(address _addr) external onlyOwner {
450         marketingWallet = _addr;
451     }
452 
453     function setMaxBalance(uint256 maxBalancePercent) external onlyOwner {
454         maxWalletBalance = maxBalancePercent * 10 ** decimals();
455     }
456 
457     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
458         maxTnxAmount = maxTxAmount * 10 ** decimals();
459     }
460 
461     function setNumTokensSellToSendFees(uint256 amount) external onlyOwner {
462         numTokensSellToSendFees = amount * 10 ** decimals();
463     }
464 
465     function setswapAndSendFeesEnabled(bool _enabled) external onlyOwner {
466         swapAndSendFeesEnabled = _enabled;
467         emit swapAndSendFeesEnabledUpdated(_enabled);
468     }
469 
470     receive() external payable {}
471 
472     function _transfer(
473         address from,
474         address to,
475         uint256 amount
476     ) internal override {
477         require(from != address(0), "ERC20: transfer from the zero address");
478         require(to != address(0), "ERC20: transfer to the zero address");
479         require(amount > 0, "Transfer amount must be greater than zero");
480 
481         if (from != owner() && !tradingEnabled) {
482             require(tradingEnabled, "Trading is not enabled yet");
483         }
484 
485         if (from != owner() && to != owner())
486             require(
487                 _isExcludedFromMaxTnxLimit[from] ||
488                     _isExcludedFromMaxTnxLimit[to] ||
489                     amount <= maxTnxAmount,
490                 "ERC20: Transfer amount exceeds the MaxTnxAmount."
491             );
492 
493         if (
494             from != owner() &&
495             to != address(this) &&
496             to != _burnAddress &&
497             to != uniswapV2Pair
498         ) {
499             uint256 currentBalance = balanceOf(to);
500             require(
501                 _isExcludedFromMaxWallet[to] ||
502                     (currentBalance + amount <= maxWalletBalance),
503                 "ERC20: Reached Max wallet holding"
504             );
505         }
506 
507         uint256 contractTokenBalance = balanceOf(address(this));
508         bool overMinTokenBalance = contractTokenBalance >=
509             numTokensSellToSendFees;
510         if (
511             overMinTokenBalance &&
512             !inSwapAndLiquify &&
513             from != uniswapV2Pair &&
514             swapAndSendFeesEnabled
515         ) {
516             contractTokenBalance = numTokensSellToSendFees;
517             swapBack(contractTokenBalance);
518         }
519 
520         bool takeFee = true;
521         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
522             super._transfer(from, to, amount);
523             takeFee = false;
524         } else {
525             if (from == uniswapV2Pair) {
526                 uint256 marketingTokens = amount.mul(buyFee).div(100);
527                 amount = amount.sub(marketingTokens);
528                 super._transfer(from, address(this), marketingTokens);
529                 super._transfer(from, to, amount);
530             } else if (to == uniswapV2Pair) {
531                 uint256 marketingTokens = amount.mul(sellFee).div(
532                     100
533                 );
534                 amount = amount.sub(marketingTokens);
535                 super._transfer(from, address(this), marketingTokens);
536                 super._transfer(from, to, amount);
537             } else {
538                 super._transfer(from, to, amount);
539             }
540         }
541     }
542 
543     function swapBack(uint256 contractBalance) private lockTheSwap {
544         uint256 marketingTokens = contractBalance.mul(sellFee).div(
545             100
546         );
547         uint256 totalTokensToSwap = marketingTokens;
548         if (contractBalance == 0 || totalTokensToSwap == 0) {
549             return;
550         }
551         bool success;
552         swapTokensForEth(contractBalance);
553         uint256 ethBalance = address(this).balance;
554         uint256 ethForMarketing = (ethBalance * marketingTokens) /
555             (totalTokensToSwap);
556         (success, ) = address(marketingWallet).call{
557             value: ethForMarketing
558         }("");
559     }
560 
561     function swapTokensForEth(uint256 tokenAmount) private {
562         address[] memory path = new address[](2);
563         path[0] = address(this);
564         path[1] = uniswapV2Router.WETH();
565         _approve(address(this), address(uniswapV2Router), tokenAmount);
566         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
567             tokenAmount,
568             0, // accept any amount of ETH
569             path,
570             address(this),
571             block.timestamp
572         );
573     }
574 }