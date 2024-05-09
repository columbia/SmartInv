1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15  
16 library SafeMath {
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27 
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         return mod(a, b, "SafeMath: modulo by zero");
60     }
61 
62     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b != 0, errorMessage);
64         return a % b;
65     }
66 }
67 
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address payable) {
70         return payable(msg.sender);
71     }
72 
73     function _msgData() internal view virtual returns (bytes memory) {
74         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
75         return msg.data;
76     }
77 }
78 
79 library Address {
80 
81     function isContract(address account) internal view returns (bool) {
82         bytes32 codehash;
83         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
84         assembly { codehash := extcodehash(account) }
85         return (codehash != accountHash && codehash != 0x0);
86     }
87 
88 
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(address(this).balance >= amount, "Address: insufficient balance");
91         (bool success, ) = recipient.call{ value: amount }("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94 
95 
96     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
97       return functionCall(target, data, "Address: low-level call failed");
98     }
99 
100 
101     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
102         return _functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105 
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110 
111     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
112         require(address(this).balance >= value, "Address: insufficient balance for call");
113         return _functionCallWithValue(target, data, value, errorMessage);
114     }
115 
116     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) 
117     {
118         require(isContract(target), "Address: call to non-contract");
119         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
120         if (success) {
121             return returndata;
122         } else {
123             if (returndata.length > 0) 
124             {
125                 assembly {
126                     let returndata_size := mload(returndata)
127                     revert(add(32, returndata), returndata_size)
128                 }
129             } else {
130                 revert(errorMessage);
131             }
132         }
133     }
134 }
135 
136 contract Ownable is Context {
137     address private _owner;
138     address private _previousOwner;
139     uint256 private _lockTime;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142     constructor () 
143     {
144         address msgSender = _msgSender();
145         _owner = msg.sender;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148 
149     function owner() public view returns (address) {
150         return _owner;
151     }
152 
153     modifier onlyOwner() {
154         require(_owner == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158 
159     function renounceOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164 
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         emit OwnershipTransferred(_owner, newOwner);
168         _owner = newOwner;
169     }
170 
171     function getUnlockTime() public view returns (uint256) {
172         return _lockTime;
173     }
174 
175 
176     function lock(uint256 time) public virtual onlyOwner {
177         _previousOwner = _owner;
178         _owner = address(0);
179         _lockTime = block.timestamp + time;
180         emit OwnershipTransferred(_owner, address(0));
181     }
182     
183 
184     function unlock() public virtual {
185         require(_previousOwner == msg.sender, "You don't have permission to unlock");
186         require(block.timestamp < _lockTime , "Contract is locked until 7 days");
187         emit OwnershipTransferred(_owner, _previousOwner);
188         _owner = _previousOwner;
189     }
190 }
191 
192 interface IUniswapV2Factory {
193     function createPair(address tokenA, address tokenB) external returns (address pair);
194 }
195 
196 interface IUniswapV2Router01 {
197     function factory() external pure returns (address);
198     function WETH() external pure returns (address);
199 
200     function addLiquidity(
201         address tokenA,
202         address tokenB,
203         uint amountADesired,
204         uint amountBDesired,
205         uint amountAMin,
206         uint amountBMin,
207         address to,
208         uint deadline
209     ) external returns (uint amountA, uint amountB, uint liquidity);
210     function addLiquidityETH(
211         address token,
212         uint amountTokenDesired,
213         uint amountTokenMin,
214         uint amountETHMin,
215         address to,
216         uint deadline
217     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
218     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
219 
220 }
221 
222 interface IUniswapV2Router02 is IUniswapV2Router01 {
223     function swapExactETHForTokensSupportingFeeOnTransferTokens(
224         uint amountOutMin,
225         address[] calldata path,
226         address to,
227         uint deadline
228     ) external payable;
229     function swapExactTokensForETHSupportingFeeOnTransferTokens(
230         uint amountIn,
231         uint amountOutMin,
232         address[] calldata path,
233         address to,
234         uint deadline
235     ) external;
236 }
237 
238 contract LockToken is Ownable {
239     bool public isOpen = false;
240     uint256 launchedAt = 0;
241     mapping(address => bool) private _whiteList;
242     modifier open(address from, address to) {
243         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
244         _;
245     }
246 
247     constructor() {
248         _whiteList[msg.sender] = true;
249         _whiteList[address(this)] = true;
250     }
251 
252     function openTrade() external onlyOwner {
253         isOpen = true;
254         if (launchedAt == 0){
255             launchedAt = block.timestamp;
256         }
257     }
258 
259     function stopTrade() external onlyOwner {
260         isOpen = false;
261     }
262 
263     function includeToWhiteList(address[] memory _users) external onlyOwner {
264         for(uint8 i = 0; i < _users.length; i++) {
265             _whiteList[_users[i]] = true;
266         }
267     }
268 }
269 
270 contract ShibaTitans is Context, IERC20, Ownable, LockToken 
271 {
272     using SafeMath for uint256;
273     using Address for address;
274 
275     mapping (address => mapping (address => uint256)) private _allowances;
276     mapping (address => uint256) private _balances;
277     mapping (address => bool) private _isExcludedFromFee;
278     mapping (address => bool) private _blacklisted;
279     mapping (address => bool) private _contractExempt;
280     mapping (address => bool) private _maxWalletLimitExempt;
281     mapping (address => bool) private boughtEarly;
282     mapping (address => bool) private isAMM;
283     uint256 private constant MAX = ~uint256(0);
284 
285     string private _name = "TITAN";
286     string private _symbol = "TITAN";
287     uint8 private _decimals = 9;
288 
289     uint256 public _devFee = 4;
290     uint256 public _liquidityFee = 4;
291     uint256 public _marketingFee = 4;
292 
293     uint256 public _saleDevFee = 4;
294     uint256 public _saleLiquidityFee = 4;
295     uint256 public _saleMarketingFee = 4;
296 
297     bool public transferTaxEnabled = true;
298     uint256 public transferTax = 15;
299 
300     bool public contractsAllowed = false;
301     uint256 public _taxDivisor = 100;
302 
303     address payable public marketingWallet;
304     address payable public devWallet;
305     
306     uint256 public buybackDivisor = 2; // if equals to _liquidityFee, no liquidity will be added, only buybacks will happen from the ETH on contract
307     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
308     
309     IUniswapV2Router02 public uniswapV2Router;
310     address public uniswapV2Pair;
311     
312     bool inSwapAndLiquify;
313     bool public swapAndLiquifyEnabled = true;
314 
315     bool public maxSellAmountActive = true;
316     bool public maxBuyAmountActive = true;
317     bool public maxWalletLimitActive = true;
318 
319     uint256 private _totalSupply = 1_000_000_000 * 10 **_decimals;
320     uint256 public maxSellAmount = 20_000_000 * 10 ** _decimals;
321     uint256 public maxBuyAmount = 20_000_000 * 10 ** _decimals;
322     uint256 public numTokensSellToAddToLiquidity = 1_000_000 * 10 ** _decimals;
323     uint256 public maxWalletLimit = 50_000_000 * 10 ** _decimals;
324 
325     uint256 public buyBackUpperLimit = 1 * 10 ** 18;
326     uint256 public buyBackLowerLimit = 1 * 10 ** 12;
327     bool public buyBackEnabled = true;
328 
329     event BuyBackEnabledUpdated(bool enabled);
330     event SwapETHForTokens(uint256 amountIn, address[] path);
331     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
332     event SwapAndLiquifyEnabledUpdated(bool enabled);
333     event SwapAndLiquify(
334         uint256 tokensSwapped,
335         uint256 ethReceived,
336         uint256 tokensIntoLiqudity
337     );
338     
339     modifier lockTheSwap {
340         inSwapAndLiquify = true;
341         _;
342         inSwapAndLiquify = false;
343     }
344     
345     constructor () {
346         address uni = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
347         marketingWallet = payable(0x2459958C8cfF592e7c38d8866B9C32728B1FA455); // edit this
348         devWallet = payable(0x7C4E46eA1B2Bcf6b031C99628a6842B1fCa54719); // edit this
349         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uni);  
350         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
351             .createPair(address(this), _uniswapV2Router.WETH());
352         uniswapV2Router = _uniswapV2Router;
353 
354         _isExcludedFromFee[owner()] = true;
355         _isExcludedFromFee[address(this)] = true;
356 
357         _balances[owner()] = _totalSupply;
358         _contractExempt[address(this)] = true;
359         _contractExempt[uni] = true;
360         _contractExempt[marketingWallet] = true;
361         _contractExempt[devWallet] = true;
362         _contractExempt[uniswapV2Pair] = true;
363 
364         _maxWalletLimitExempt[address(this)] = true;
365         _maxWalletLimitExempt[uni] = true;
366         _maxWalletLimitExempt[marketingWallet] = true;
367         _maxWalletLimitExempt[devWallet] = true;
368         _maxWalletLimitExempt[uniswapV2Pair] = true;
369         _maxWalletLimitExempt[owner()] = true;
370 
371         _limits[owner()].isExcluded = true;
372         _limits[address(this)].isExcluded = true;
373         _limits[uni].isExcluded = true;
374         
375         isAMM[uniswapV2Pair] = true;
376 
377         // Set limits for private sale and globally
378         privateSaleGlobalLimit = 0; // 10 ** 18 = 1 ETH limit
379         privateSaleGlobalLimitPeriod = 24 hours;
380 
381         globalLimit = 5 * 10 ** 18; // 10 ** 18 = 1 ETH limit
382         globalLimitPeriod = 24 hours;
383 
384         _allowances[owner()][uni] = ~uint256(0); // you can leave this here, it will approve tokens to uniswap, so you can add liquidity easily
385         emit Transfer(address(0), _msgSender(), _totalSupply);
386     }
387 
388     function setAllBuyFees(uint256 devFee, uint256 liquidityFee, uint256 marketingFee) public onlyOwner() {
389         _devFee = devFee;
390         _liquidityFee = liquidityFee;
391         _marketingFee = marketingFee;
392     }
393 
394     function setAllSaleFees(uint256 devFee, uint256 liquidityFee, uint256 marketingFee) public onlyOwner() {
395         _saleDevFee = devFee;
396         _saleLiquidityFee = liquidityFee;
397         _saleMarketingFee = marketingFee;
398     }
399 
400     function name() public view returns (string memory) {
401         return _name;
402     }
403 
404     function symbol() public view returns (string memory) {
405         return _symbol;
406     }
407 
408     function decimals() public view returns (uint8) {
409         return _decimals;
410     }
411 
412     function totalSupply() public view override returns (uint256) {
413         return _totalSupply;
414     }
415 
416     function balanceOf(address account) public view override returns (uint256) {
417         return _balances[account];
418     }
419 
420     function transfer(address recipient, uint256 amount) public override returns (bool) {
421         _transfer(_msgSender(), recipient, amount);
422         return true;
423     }
424 
425     function allowance(address owner, address spender) public view override returns (uint256) {
426         return _allowances[owner][spender];
427     }
428 
429     function approve(address spender, uint256 amount) public override returns (bool) {
430         _approve(_msgSender(), spender, amount);
431         return true;
432     }
433 
434     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
435         _transfer(sender, recipient, amount);
436         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
437         return true;
438     }
439 
440     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
441         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
442         return true;
443     }
444 
445     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
446         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
447         return true;
448     }
449     
450     receive() external payable {}
451 
452     function isExcludedFromFee(address account) public view returns (bool) {
453         return _isExcludedFromFee[account];
454     }
455 
456     function _approve(address owner, address spender, uint256 amount) private {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = amount;
461         emit Approval(owner, spender, amount);
462     }
463 
464     function setAMMStatus(address _address, bool status) public onlyOwner {
465         isAMM[_address] = status;
466     }
467 
468     function AMMStatus(address _address) public view returns(bool) {
469         return isAMM[_address]; 
470     }
471 
472     function _transfer(address from, address to, uint256 amount) private 
473     open(from, to)
474     {
475         require(from != address(0), "ERC20: transfer from the zero address");
476         require(to != address(0), "ERC20: transfer to the zero address");
477         require(amount > 0, "Transfer amount must be greater than zero");
478         require(_balances[from] >= amount, "Transfer amount exceeds balance");
479         require(!(_blacklisted[from] || _blacklisted[to]), "Blacklisted address involved");
480         require(contractsAllowed || !from.isContract() || isContractExempt(from), "No contracts allowed");
481         uint256 contractTokenBalance = balanceOf(address(this));
482 
483         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
484         if (overMinTokenBalance &&  !inSwapAndLiquify && !isAMM[from] && swapAndLiquifyEnabled){
485             checkForBuyBack();
486             contractTokenBalance = numTokensSellToAddToLiquidity;
487             swapAndLiquify(contractTokenBalance);
488         }
489 
490         uint256 tax;
491         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || inSwapAndLiquify){
492             // From or to excluded, so don't take fees, also don't take fees when contract is swapping
493             tax = 0;
494         } else {
495             if(isAMM[to]){
496                 // sell
497                 require(amount <= maxSellAmount || !maxSellAmountActive, "Amount exceeds the max sell amount");
498                 tax = _saleLiquidityFee.add(_saleMarketingFee).add(_saleDevFee);
499             } else if (isAMM[from]) {
500                 if (block.timestamp == launchedAt){
501                     _blacklisted[to] = true;
502                 }
503                 // buy
504                 require(amount <= maxBuyAmount || !maxBuyAmountActive, "Amount exceeds the max buy amount");
505                 tax = _liquidityFee.add(_marketingFee).add(_devFee);
506             } else {
507                 // transfer
508                 require(!_limits[from].isPrivateSaler && block.timestamp > launchedAt, "No transfers for private salers");
509                 tax = transferTaxEnabled ? transferTax : 0;
510             }
511         }
512         //handle token movements
513         uint256 taxedAmount = _getTaxed(amount, tax);
514         uint256 taxAmount = amount.sub(taxedAmount); 
515         _balances[from] = _balances[from].sub(amount);
516         _balances[address(this)] = _balances[address(this)].add(taxAmount);
517         _balances[to] = _balances[to].add(taxedAmount);
518         require(_balances[to] <= maxWalletLimit || _maxWalletLimitExempt[to] || !maxWalletLimitActive, "Exceeds max tokens limit on a single wallet");
519         
520         // handle limits on sells/transfers
521         if (!inSwapAndLiquify && !isAMM[from]){
522             _handleLimited(from, taxedAmount);
523         }
524         
525         emit Transfer(from,to,taxedAmount);
526         if (taxAmount != 0){
527             emit Transfer(from,address(this),taxAmount);
528         }
529     }
530 
531     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
532         uint256 allFee = _liquidityFee.add(_marketingFee).add(_devFee);
533         if (allFee != 0){
534             uint256 halfLiquidityTokens = contractTokenBalance.div(allFee).mul(_liquidityFee-buybackDivisor).div(2);
535             uint256 swapableTokens = contractTokenBalance.sub(halfLiquidityTokens);
536             uint256 initialBalance = address(this).balance;
537             swapTokensForEth(swapableTokens);
538             uint256 newBalance = address(this).balance.sub(initialBalance);
539             uint256 ethForLiquidity = newBalance.div(allFee).mul(_liquidityFee-buybackDivisor).div(2);
540             if(ethForLiquidity > 0) 
541             {
542             addLiquidity(halfLiquidityTokens, ethForLiquidity);
543             emit SwapAndLiquify(halfLiquidityTokens, ethForLiquidity, halfLiquidityTokens);
544             }
545             marketingWallet.transfer(newBalance.div(allFee).mul(_marketingFee));
546             devWallet.transfer(newBalance.div(allFee).mul(_devFee));
547         }
548     }
549 
550     function _getTaxed(uint256 tokenAmount, uint256 tax) private view returns (uint256 taxed){
551         taxed = tokenAmount.mul(_taxDivisor.sub(tax)).div(_taxDivisor);
552     }
553 
554     function setTransferTaxStatus(bool status) public onlyOwner{
555         transferTaxEnabled = status;
556     }
557 
558     function setTransferTax(uint256 newTax) public onlyOwner{
559         transferTax = newTax;
560     }
561 
562     function setMaxBuyAmountActive(bool status) public onlyOwner{
563         maxBuyAmountActive = status;
564     } 
565 
566     function setMaxSellAmountActive(bool status) public onlyOwner{
567         maxSellAmountActive = status;
568     }
569 
570     function setMaxWalletLimitActive(bool status) public onlyOwner{
571         maxWalletLimitActive = status;
572     }
573 
574     function swapTokensForEth(uint256 tokenAmount) private {
575         address[] memory path = new address[](2);
576         path[0] = address(this);
577         path[1] = uniswapV2Router.WETH();
578         _approve(address(this), address(uniswapV2Router), tokenAmount);
579         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this), block.timestamp);
580     }
581 
582     function manualBurn(uint256 burnAmount) public onlyOwner {
583         _transfer(owner(), deadWallet, burnAmount);
584     }
585     
586     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
587         _approve(address(this), address(uniswapV2Router), tokenAmount);
588         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this), tokenAmount, 0, 0, owner(), block.timestamp);
589     }
590 
591     function setExcludeFromFee(address account, bool _enabled) public onlyOwner {
592         _isExcludedFromFee[account] = _enabled;
593     }
594     
595     function setmarketingWallet(address newWallet) external onlyOwner {
596         marketingWallet = payable(newWallet);
597     }
598 
599     function setDevWallet(address newWallet) external onlyOwner {
600         devWallet = payable(newWallet);
601     }
602 
603     function setMaxSellAmount(uint256 amount) external onlyOwner {
604         maxSellAmount = amount;
605     }
606 
607     function setBuybackDivisor(uint256 amount) external onlyOwner {
608         require(amount <= _liquidityFee, "Value higher than liquidity fee not allowed");
609         buybackDivisor = amount;
610     }
611 
612     function setMaxBuyAmount(uint256 amount) external onlyOwner {
613         maxBuyAmount = amount;
614     }
615 
616     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
617         swapAndLiquifyEnabled = _enabled;
618         emit SwapAndLiquifyEnabledUpdated(_enabled);
619     }
620 
621     function setNumTokensSellToAddToLiquidity(uint256 amount) public onlyOwner {
622         numTokensSellToAddToLiquidity = amount;
623     }
624 
625     function setBuybackLowerLimit(uint256 value) public onlyOwner {
626         buyBackLowerLimit = value;
627     }
628 
629     function buyBackTokens(uint256 amount) private lockTheSwap {
630     	if (amount > 0) {
631     	    swapETHForTokens(amount);
632 	    }
633     }
634 
635     function checkForBuyBack() private lockTheSwap {
636         uint256 balance = address(this).balance;
637         if (buyBackEnabled && balance >= buyBackLowerLimit) 
638         {    
639             if (balance > buyBackUpperLimit) {
640                 balance = buyBackUpperLimit;
641                 }
642             buyBackTokens(balance);
643         }
644     }
645 
646     function swapETHForTokens(uint256 amount) private {
647         address[] memory path = new address[](2);
648         path[0] = uniswapV2Router.WETH();
649         path[1] = address(this);
650         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
651             0,
652             path,
653             deadWallet,
654             block.timestamp);
655         emit SwapETHForTokens(amount, path);
656     }
657 
658     function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
659         buyBackUpperLimit = buyBackLimit;
660     }
661 
662     function setBuyBackEnabled(bool _enabled) public onlyOwner {
663         buyBackEnabled = _enabled;
664         emit BuyBackEnabledUpdated(_enabled);
665     }
666     
667     function manualBuyback(uint256 amount) external onlyOwner() {
668         buyBackTokens(amount);
669     }
670 
671     // Blacklist
672     function setBlacklistStatus(address _address, bool status) public onlyOwner{
673         _blacklisted[_address] = status;
674     }
675 
676     function isBlacklisted(address _address) public view returns (bool) {
677         return _blacklisted[_address];
678     }
679 
680     // Contract rejection
681     function setContractsAllowedStatus(bool status) public onlyOwner {
682         contractsAllowed = status;
683     }
684 
685     function isContractExempt(address _address) public view returns (bool) {
686         return _contractExempt[_address];
687     }
688     
689     function setContractExemptStatus(address _address, bool status) public onlyOwner {
690         _contractExempt[_address] = status;
691     }
692 
693     // Max wallet
694     function isMaxWalletLimitExempt(address _address) public view returns(bool) {
695         return _maxWalletLimitExempt[_address];
696     }
697 
698     function setMaxWalletLimit(uint256 value) public onlyOwner {
699         maxWalletLimit = value;
700     }
701 
702     function setMaxWalletLimitExemptStatus(address _address, bool status) public onlyOwner {
703         _maxWalletLimitExempt[_address] = status;
704     }
705 
706     function getETHValue(uint256 tokenAmount) private view returns (uint256 ethValue) {
707         address[] memory path = new address[](2);
708         path[0] = address(this);
709         path[1] = uniswapV2Router.WETH();
710         ethValue = uniswapV2Router.getAmountsOut(tokenAmount, path)[1];
711     }
712 
713     // private sale limits
714     mapping(address => LimitedWallet) private _limits;
715 
716     uint256 public privateSaleGlobalLimit; // limit over timeframe for private salers
717     uint256 public privateSaleGlobalLimitPeriod; // timeframe for private salers
718 
719     uint256 public globalLimit; // limit over timeframe for all
720     uint256 public globalLimitPeriod; // timeframe for all
721 
722     bool public globalLimitsActive = true;
723     bool public globalLimitsPrivateSaleActive = true;
724 
725     struct LimitedWallet {
726         uint256[] sellAmounts;
727         uint256[] sellTimestamps;
728         uint256 limitPeriod; // ability to set custom values for individual wallets
729         uint256 limitETH; // ability to set custom values for individual wallets
730         bool isPrivateSaler;
731         bool isExcluded;
732     }
733 
734     function setGlobalLimitPrivateSale(uint256 newLimit) public onlyOwner {
735         privateSaleGlobalLimit = newLimit;
736     } 
737 
738     function setGlobalLimitPeriodPrivateSale(uint256 newPeriod) public onlyOwner {
739         privateSaleGlobalLimitPeriod = newPeriod;
740     }
741 
742     function setGlobalLimit(uint256 newLimit) public onlyOwner {
743         globalLimit = newLimit;
744     } 
745 
746     function setGlobalLimitPeriod(uint256 newPeriod) public onlyOwner {
747         globalLimitPeriod = newPeriod;
748     }
749 
750     function setGlobalLimitsPrivateSaleActiveStatus(bool status) public onlyOwner {
751         globalLimitsPrivateSaleActive = status;
752     }
753 
754     function setGlobalLimitsActiveStatus(bool status) public onlyOwner {
755         globalLimitsActive = status;
756     }
757 
758     function getLimits(address _address) public view returns (LimitedWallet memory){
759         return _limits[_address];
760     }
761 
762     // Set custom limits for an address. Defaults to 0, thus will use the "globalLimitPeriod" and "globalLimitETH" if we don't set them
763     function setLimits(address[] calldata addresses, uint256[] calldata limitPeriods, uint256[] calldata limitsETH) public onlyOwner{
764         require(addresses.length == limitPeriods.length && limitPeriods.length == limitsETH.length, "Array lengths don't match");
765         for(uint256 i=0; i < addresses.length; i++){
766             _limits[addresses[i]].limitPeriod = limitPeriods[i];
767             _limits[addresses[i]].limitETH = limitsETH[i];
768         }
769 
770     }
771 
772     function addPrivateSalers(address[] calldata addresses) public onlyOwner{
773         for(uint256 i=0; i < addresses.length; i++){
774             _limits[addresses[i]].isPrivateSaler = true;
775         }
776     }
777 
778     function removePrivateSalers(address[] calldata addresses) public onlyOwner{
779         for(uint256 i=0; i < addresses.length; i++){
780             _limits[addresses[i]].isPrivateSaler = false;
781         }
782     }
783 
784     function addExcludedFromLimits(address[] calldata addresses) public onlyOwner{
785         for(uint256 i=0; i < addresses.length; i++){
786             _limits[addresses[i]].isExcluded = true;
787         }
788     }
789 
790     function removeExcludedFromLimits(address[] calldata addresses) public onlyOwner{
791         for(uint256 i=0; i < addresses.length; i++){
792             _limits[addresses[i]].isExcluded = false;
793         }
794     }
795 
796     // Can be used to check how much a wallet sold in their timeframe
797     function getSoldLastPeriod(address _address) public view returns (uint256 sellAmount) {
798         uint256 numberOfSells = _limits[_address].sellAmounts.length;
799 
800         if (numberOfSells == 0) {
801             return sellAmount;
802         }
803         uint256 defaultLimitPeriod = _limits[_address].isPrivateSaler ? privateSaleGlobalLimitPeriod : globalLimitPeriod;
804         uint256 limitPeriod = _limits[_address].limitPeriod == 0 ? defaultLimitPeriod : _limits[_address].limitPeriod;
805         while (true) {
806             if (numberOfSells == 0) {
807                 break;
808             }
809             numberOfSells--;
810             uint256 sellTimestamp = _limits[_address].sellTimestamps[numberOfSells];
811             if (block.timestamp - limitPeriod <= sellTimestamp) {
812                 sellAmount += _limits[_address].sellAmounts[numberOfSells];
813             } else {
814                 break;
815             }
816         }
817     }
818     // Handle private sale wallets
819     function _handleLimited(address from, uint256 taxedAmount) private {
820         if (_limits[from].isExcluded || (!globalLimitsActive && !_limits[from].isPrivateSaler) || (!globalLimitsPrivateSaleActive && _limits[from].isPrivateSaler)){
821             return;
822         }
823         uint256 ethValue = getETHValue(taxedAmount);
824         _limits[from].sellTimestamps.push(block.timestamp);
825         _limits[from].sellAmounts.push(ethValue);
826         uint256 soldAmountLastPeriod = getSoldLastPeriod(from);
827 
828         uint256 defaultLimit = _limits[from].isPrivateSaler ? privateSaleGlobalLimit : globalLimit;
829         uint256 limit = _limits[from].limitETH == 0 ? defaultLimit : _limits[from].limitETH;
830         require(soldAmountLastPeriod <= limit, "Amount over the limit for time period");
831     }
832     
833     function multiSendTokens(address[] calldata addresses, uint256[] calldata amounts) public onlyOwner{
834         for(uint256 i=0; i < addresses.length; i++){
835             _transfer(msg.sender, addresses[i], amounts[i]);
836         }
837     }
838     // Get tokens that are on the contract
839     function sweepTokens(address token, address recipient) public onlyOwner {
840         uint256 amount = IERC20(token).balanceOf(address(this));
841         IERC20(token).transfer(recipient, amount);
842     }
843 
844     function withdraw() public onlyOwner {
845         payable(msg.sender).transfer(address(this).balance);
846     }
847 }