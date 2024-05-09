1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
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
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address to, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(
22         address from,
23         address to,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 interface IERC20Metadata is IERC20 {
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function decimals() external view returns (uint8);
35 }
36 
37 contract ERC20 is Context, IERC20, IERC20Metadata {
38     mapping(address => uint256) private _balances;
39 
40     mapping(address => mapping(address => uint256)) private _allowances;
41 
42     uint256 private _totalSupply;
43 
44     string private _name;
45     string private _symbol;
46 
47     constructor(string memory name_, string memory symbol_) {
48         _name = name_;
49         _symbol = symbol_;
50     }
51 
52     function name() public view virtual override returns (string memory) {
53         return _name;
54     }
55 
56     function symbol() public view virtual override returns (string memory) {
57         return _symbol;
58     }
59 
60     function decimals() public view virtual override returns (uint8) {
61         return 18;
62     }
63 
64     function totalSupply() public view virtual override returns (uint256) {
65         return _totalSupply;
66     }
67 
68     function balanceOf(address account) public view virtual override returns (uint256) {
69         return _balances[account];
70     }
71 
72     function transfer(address to, uint256 amount) public virtual override returns (bool) {
73         address owner = _msgSender();
74         _transfer(owner, to, amount);
75         return true;
76     }
77 
78     function allowance(address owner, address spender) public view virtual override returns (uint256) {
79         return _allowances[owner][spender];
80     }
81 
82     function approve(address spender, uint256 amount) public virtual override returns (bool) {
83         address owner = _msgSender();
84         _approve(owner, spender, amount);
85         return true;
86     }
87 
88     function transferFrom(
89         address from,
90         address to,
91         uint256 amount
92     ) public virtual override returns (bool) {
93         address spender = _msgSender();
94         _spendAllowance(from, spender, amount);
95         _transfer(from, to, amount);
96         return true;
97     }
98 
99     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
100         address owner = _msgSender();
101         _approve(owner, spender, _allowances[owner][spender] + addedValue);
102         return true;
103     }
104 
105     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
106         address owner = _msgSender();
107         uint256 currentAllowance = _allowances[owner][spender];
108         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
109         unchecked {
110             _approve(owner, spender, currentAllowance - subtractedValue);
111         }
112 
113         return true;
114     }
115 
116     function _transfer(
117         address from,
118         address to,
119         uint256 amount
120     ) internal virtual {
121         require(from != address(0), "ERC20: transfer from the zero address");
122         require(to != address(0), "ERC20: transfer to the zero address");
123 
124         _beforeTokenTransfer(from, to, amount);
125 
126         uint256 fromBalance = _balances[from];
127         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
128         unchecked {
129             _balances[from] = fromBalance - amount;
130         }
131         _balances[to] += amount;
132 
133         emit Transfer(from, to, amount);
134 
135         _afterTokenTransfer(from, to, amount);
136     }
137 
138     function _mint(address account, uint256 amount) internal virtual {
139         require(account != address(0), "ERC20: mint to the zero address");
140 
141         _beforeTokenTransfer(address(0), account, amount);
142 
143         _totalSupply += amount;
144         _balances[account] += amount;
145         emit Transfer(address(0), account, amount);
146 
147         _afterTokenTransfer(address(0), account, amount);
148     }
149 
150     function _burn(address account, uint256 amount) internal virtual {
151         require(account != address(0), "ERC20: burn from the zero address");
152 
153         _beforeTokenTransfer(account, address(0), amount);
154 
155         uint256 accountBalance = _balances[account];
156         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
157         unchecked {
158             _balances[account] = accountBalance - amount;
159         }
160         _totalSupply -= amount;
161 
162         emit Transfer(account, address(0), amount);
163 
164         _afterTokenTransfer(account, address(0), amount);
165     }
166 
167     function _approve(
168         address owner,
169         address spender,
170         uint256 amount
171     ) internal virtual {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     function _spendAllowance(
180         address owner,
181         address spender,
182         uint256 amount
183     ) internal virtual {
184         uint256 currentAllowance = allowance(owner, spender);
185         if (currentAllowance != type(uint256).max) {
186             require(currentAllowance >= amount, "ERC20: insufficient allowance");
187             unchecked {
188                 _approve(owner, spender, currentAllowance - amount);
189             }
190         }
191     }
192 
193     function _beforeTokenTransfer(
194         address from,
195         address to,
196         uint256 amount
197     ) internal virtual {}
198 
199     function _afterTokenTransfer(
200         address from,
201         address to,
202         uint256 amount
203     ) internal virtual {}
204 }
205 
206 interface IUniswapV2Factory {
207     function createPair(address tokenA, address tokenB) external returns (address pair);
208 }
209 
210 interface IUniswapV2Router01 {
211     function factory() external pure returns (address);
212     function WETH() external pure returns (address);
213     function addLiquidityETH(
214         address token,
215         uint amountTokenDesired,
216         uint amountTokenMin,
217         uint amountETHMin,
218         address to,
219         uint deadline
220     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
221 }
222 
223 interface IUniswapV2Router02 is IUniswapV2Router01 {
224     function swapExactTokensForETHSupportingFeeOnTransferTokens(
225         uint amountIn,
226         uint amountOutMin,
227         address[] calldata path,
228         address to,
229         uint deadline
230     ) external;
231 }
232 
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     constructor() {
239         _transferOwnership(_msgSender());
240     }
241 
242     function owner() public view virtual returns (address) {
243         return _owner;
244     }
245 
246     modifier onlyOwner() {
247         require(owner() == _msgSender(), "Ownable: caller is not the owner");
248         _;
249     }
250 
251     function renounceOwnership() public virtual onlyOwner {
252         _transferOwnership(address(0));
253     }
254 
255     function transferOwnership(address newOwner) public virtual onlyOwner {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         _transferOwnership(newOwner);
258     }
259 
260     function _transferOwnership(address newOwner) internal virtual {
261         address oldOwner = _owner;
262         _owner = newOwner;
263         emit OwnershipTransferred(oldOwner, newOwner);
264     }
265 }
266 
267 library SafeMath {
268     function add(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a + b;
270     }
271 
272     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a - b;
274     }
275 
276     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a * b;
278     }
279 
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a / b;
282     }
283 
284     function sub(
285         uint256 a,
286         uint256 b,
287         string memory errorMessage
288     ) internal pure returns (uint256) {
289         unchecked {
290             require(b <= a, errorMessage);
291             return a - b;
292         }
293     }
294 
295     function div(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         unchecked {
301             require(b > 0, errorMessage);
302             return a / b;
303         }
304     }
305 }
306 
307 contract THEBET_TOKEN is ERC20, Ownable {
308     using SafeMath for uint256;
309 
310     IUniswapV2Router02 private uniswapV2Router;
311     address private uniswapV2Pair;
312     
313     uint256 public maxTransactionAmount;
314     uint256 public maxWallet;
315     uint256 public swapTokensThreshold;
316         
317     bool public limitsInEffect = true;
318 
319     bool private _isSwapping;
320 
321     uint256 private _swapFee = 6;
322     uint256 private _tokensForFee;
323     address private _feeReceiver;
324 
325     // exlcude from fees and max transaction amount
326     mapping (address => bool) public isExcludedFromFees;
327     mapping (address => bool) private _isExcludedMaxTransactionAmount;
328 
329     // for bots
330     mapping (address => bool) public isBlacklisted;
331 
332     // any transfer *to* these addresses could be subject to a maximum transfer amount
333     mapping (address => bool) private _automatedMarketMakerPairs;
334 
335     // to stop bot spam buys and sells on launch
336     mapping(address => uint256) private _holderLastTransferBlock;
337 
338     /**
339      * @dev Throws if called by any account other than the _feeReceiver
340      */
341     modifier teamOROwner() {
342         require(_feeReceiver == _msgSender() || owner() == _msgSender(), "Caller is not the _feeReceiver address nor owner.");
343         _;
344     }
345 
346     constructor() ERC20("The BET", "BET") payable {
347         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
348         
349         _isExcludedMaxTransactionAmount[address(_uniswapV2Router)] = true;
350         uniswapV2Router = _uniswapV2Router;
351 
352         uint256 totalSupply = 1e7 * 1e18; // 10M
353         uint256 totalLiquidity = 65e5 * 1e18; // 6.5M
354 
355         maxTransactionAmount = totalSupply * 325 / 100000;
356         maxWallet = totalSupply * 65 / 10000;
357         swapTokensThreshold = totalSupply * 1 / 1000;
358 
359         _feeReceiver = owner();
360 
361         // exclude from paying fees or having max transaction amount
362         excludeFromFees(owner(), true);
363         excludeFromFees(address(this), true);
364         excludeFromFees(address(0xdead), true);
365         
366         _isExcludedMaxTransactionAmount[owner()] = true;
367         _isExcludedMaxTransactionAmount[address(this)] = true;
368         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
369 
370         _mint(address(this), totalLiquidity);
371         _mint(msg.sender, totalSupply.sub(totalLiquidity));
372     }
373 
374     /**
375     * @dev Once live, can never be switched off
376     */
377     function startTrading() external teamOROwner {
378         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
379         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;
380         _automatedMarketMakerPairs[address(uniswapV2Pair)] = true;
381 
382         _approve(address(this), address(uniswapV2Router), balanceOf(address(this)));
383         uniswapV2Router.addLiquidityETH{value: address(this).balance} (
384             address(this),
385             balanceOf(address(this)),
386             0,
387             0,
388             owner(),
389             block.timestamp
390         );
391     }
392 
393     /**
394     * @dev Remove limits after token is somewhat stable
395     */
396     function removeLimits() external teamOROwner {
397         limitsInEffect = false;
398     }
399 
400     /**
401     * @dev Exclude from fee calculation
402     */
403     function excludeFromFees(address account, bool excluded) public teamOROwner {
404         isExcludedFromFees[account] = excluded;
405     }
406     
407     /**
408     * @dev Blacklist certain addresses from transfering
409     */
410     function blacklistAddress(address[] memory addrs, bool state) external teamOROwner {
411         for (uint i = 0; i < addrs.length; i++) {
412             if (addrs[i] != uniswapV2Pair && addrs[i] != address(uniswapV2Router)) 
413                 isBlacklisted[addrs[i]] = state;
414         }
415     }
416 
417     /**
418     * @dev Update token fees (max set to initial fee)
419     */
420     function updateFees(uint256 fee) external onlyOwner {
421         _swapFee = fee;
422 
423         require(_swapFee <= 6, "Must keep fees at 6% or less");
424     }
425 
426     /**
427     * @dev Update wallet that receives fees and newly added LP
428     */
429     function updateFeeReceiver(address newWallet) external teamOROwner {
430         _feeReceiver = newWallet;
431     }
432 
433     /**
434     * @dev Very important function. 
435     * Updates the threshold of how many tokens that must be in the contract calculation for fees to be taken
436     */
437     function updateSwapTokensThreshold(uint256 newThreshold) external teamOROwner returns (bool) {
438   	    require(newThreshold >= totalSupply() * 1 / 100000, "Swap threshold cannot be lower than 0.001% total supply.");
439   	    require(newThreshold <= totalSupply() * 5 / 1000, "Swap threshold cannot be higher than 0.5% total supply.");
440   	    swapTokensThreshold = newThreshold;
441   	    return true;
442   	}
443 
444     function _transfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal override {
449         require(from != address(0), "_transfer:: Transfer from the zero address not allowed.");
450         require(to != address(0), "_transfer:: Transfer to the zero address not allowed.");
451         require(!isBlacklisted[from], "_transfer:: Your address has been marked as blacklisted.");
452 
453         if (amount == 0) {
454             super._transfer(from, to, 0);
455             return;
456         }
457 
458         // all to secure a smooth launch
459         if (limitsInEffect) {
460             if (
461                 from != owner() &&
462                 to != owner() &&
463                 !_isSwapping
464             ) {
465                 if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
466                     require(_holderLastTransferBlock[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
467                     _holderLastTransferBlock[tx.origin] = block.number;
468                 }
469 
470                 // on buy
471                 if (_automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
472                     require(amount <= maxTransactionAmount, "_transfer:: Buy transfer amount exceeds the maxTransactionAmount.");
473                     require(amount.add(balanceOf(to)) <= maxWallet, "_transfer:: Max wallet exceeded");
474                 }
475                 
476                 // on sell
477                 else if (_automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
478                     require(amount <= maxTransactionAmount, "_transfer:: Sell transfer amount exceeds the maxTransactionAmount.");
479                 }
480                 else if (!_isExcludedMaxTransactionAmount[to]) {
481                     require(amount.add(balanceOf(to)) <= maxWallet, "_transfer:: Max wallet exceeded");
482                 }
483             }
484         }
485         
486 		uint256 contractTokenBalance = balanceOf(address(this));
487         bool canSwap = contractTokenBalance >= swapTokensThreshold;
488         if (
489             canSwap &&
490             !_isSwapping &&
491             !_automatedMarketMakerPairs[from] &&
492             !isExcludedFromFees[from] &&
493             !isExcludedFromFees[to]
494         ) {
495             _isSwapping = true;
496             swapBack();
497             _isSwapping = false;
498         }
499 
500         bool takeFee = !_isSwapping;
501 
502         // if any addy belongs to _isExcludedFromFee or isn't a swap then remove the fee
503         if (
504             isExcludedFromFees[from] || 
505             isExcludedFromFees[to] || 
506             (!_automatedMarketMakerPairs[from] && !_automatedMarketMakerPairs[to])
507         ) takeFee = false;
508         
509         uint256 fees = 0;
510         if (takeFee) {
511             fees = amount.mul(_swapFee).div(100);
512             _tokensForFee = amount.mul(_swapFee).div(100);
513             
514             if (fees > 0) 
515                 super._transfer(from, address(this), fees);
516         	
517         	amount -= fees;
518         }
519 
520         super._transfer(from, to, amount);
521     }
522 
523     function _swapTokensForEth(uint256 tokenAmount) internal {
524         address[] memory path = new address[](2);
525         path[0] = address(this);
526         path[1] = uniswapV2Router.WETH();
527 
528         _approve(address(this), address(uniswapV2Router), tokenAmount);
529 
530         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
531             tokenAmount,
532             0,
533             path,
534             address(this),
535             block.timestamp
536         );
537     }
538 
539     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
540         _approve(address(this), address(uniswapV2Router), tokenAmount);
541 
542         uniswapV2Router.addLiquidityETH{value: ethAmount}(
543             address(this),
544             tokenAmount,
545             0,
546             0,
547             _feeReceiver,
548             block.timestamp
549         );
550     }
551 
552     function swapBack() internal {
553         uint256 contractBalance = balanceOf(address(this));
554         uint256 tokensForLiquidity = _tokensForFee.div(4); // 1/4th of the fee
555         uint256 tokensForFee = _tokensForFee.sub(tokensForLiquidity);
556         
557         if (contractBalance == 0 || _tokensForFee == 0) return;
558         if (contractBalance > swapTokensThreshold) contractBalance = swapTokensThreshold;
559         
560         // Halve the amount of liquidity tokens
561         uint256 liquidityTokens = contractBalance * tokensForLiquidity / _tokensForFee / 2;
562         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
563         
564         uint256 initialETHBalance = address(this).balance;
565 
566         _swapTokensForEth(amountToSwapForETH);
567         
568         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
569         uint256 ethFee = ethBalance.mul(tokensForFee).div(_tokensForFee);
570         uint256 ethLiquidity = ethBalance - ethFee;
571         
572         _tokensForFee = 0;
573 
574         payable(_feeReceiver).transfer(ethFee);
575                 
576         if (liquidityTokens > 0 && ethLiquidity > 0) 
577             _addLiquidity(liquidityTokens, ethLiquidity);
578     }
579 
580     /**
581     * @dev Transfer eth stuck in contract to _feeReceiver
582     */
583     function withdrawContractETH() external {
584         payable(_feeReceiver).transfer(address(this).balance);
585     }
586 
587     /**
588     * @dev In case swap wont do it and sells/buys might be blocked
589     */
590     function forceSwap() external teamOROwner {
591         _swapTokensForEth(balanceOf(address(this)));
592     }
593 
594     receive() external payable {}
595 }