1 //
2 // SPDX-License-Identifier: Unlicensed
3 pragma solidity ^0.8.19;
4 
5 abstract contract Context {
6 
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
73         return mod(a, b, "SafeMath: modulo by zero");
74     }
75 
76     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b != 0, errorMessage);
78         return a % b;
79     }
80 }
81 
82 library Address {
83 
84     function isContract(address account) internal view returns (bool) {
85         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
86         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
87         // for accounts without code, i.e. `keccak256('')`
88         bytes32 codehash;
89         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
90         // solhint-disable-next-line no-inline-assembly
91         assembly { codehash := extcodehash(account) }
92         return (codehash != accountHash && codehash != 0x0);
93     }
94 
95     function sendValue(address payable recipient, uint256 amount) internal {
96         require(address(this).balance >= amount, "Address: insufficient balance");
97 
98         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
99         (bool success, ) = recipient.call{ value: amount }("");
100         require(success, "Address: unable to send value, recipient may have reverted");
101     }
102 
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104       return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
108         return _functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
113     }
114 
115     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
116         require(address(this).balance >= value, "Address: insufficient balance for call");
117         return _functionCallWithValue(target, data, value, errorMessage);
118     }
119 
120     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
121         require(isContract(target), "Address: call to non-contract");
122 
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             
128             if (returndata.length > 0) {
129                 assembly {
130                     let returndata_size := mload(returndata)
131                     revert(add(32, returndata), returndata_size)
132                 }
133             } else {
134                 revert(errorMessage);
135             }
136         }
137     }
138 }
139 
140 contract Ownable is Context {
141     address private _owner;
142     address private _previousOwner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     constructor () {
147         address msgSender = _msgSender();
148         _owner = msgSender;
149         emit OwnershipTransferred(address(0), msgSender);
150     }
151 
152     function owner() public view returns (address) {
153         return _owner;
154     }   
155     
156     modifier onlyOwner() {
157         require(_owner == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160     
161     function waiveOwnership() public virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 }
166 
167 interface IUniswapV2Factory {
168     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
169 
170     function feeTo() external view returns (address);
171     function feeToSetter() external view returns (address);
172 
173     function getPair(address tokenA, address tokenB) external view returns (address pair);
174     function allPairs(uint) external view returns (address pair);
175     function allPairsLength() external view returns (uint);
176 
177     function createPair(address tokenA, address tokenB) external returns (address pair);
178 
179     function setFeeTo(address) external;
180     function setFeeToSetter(address) external;
181 }
182 
183 interface IUniswapV2Pair {
184     event Approval(address indexed owner, address indexed spender, uint value);
185     event Transfer(address indexed from, address indexed to, uint value);
186 
187     function name() external pure returns (string memory);
188     function symbol() external pure returns (string memory);
189     function decimals() external pure returns (uint8);
190     function totalSupply() external view returns (uint);
191     function balanceOf(address owner) external view returns (uint);
192     function allowance(address owner, address spender) external view returns (uint);
193 
194     function approve(address spender, uint value) external returns (bool);
195     function transfer(address to, uint value) external returns (bool);
196     function transferFrom(address from, address to, uint value) external returns (bool);
197 
198     function DOMAIN_SEPARATOR() external view returns (bytes32);
199     function PERMIT_TYPEHASH() external pure returns (bytes32);
200     function nonces(address owner) external view returns (uint);
201 
202     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
203     
204     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
205     event Swap(
206         address indexed sender,
207         uint amount0In,
208         uint amount1In,
209         uint amount0Out,
210         uint amount1Out,
211         address indexed to
212     );
213     event Sync(uint112 reserve0, uint112 reserve1);
214 
215     function MINIMUM_LIQUIDITY() external pure returns (uint);
216     function factory() external view returns (address);
217     function token0() external view returns (address);
218     function token1() external view returns (address);
219     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
220     function price0CumulativeLast() external view returns (uint);
221     function price1CumulativeLast() external view returns (uint);
222     function kLast() external view returns (uint);
223 
224     function burn(address to) external returns (uint amount0, uint amount1);
225     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
226     function skim(address to) external;
227     function sync() external;
228 
229     function initialize(address, address) external;
230 }
231 
232 interface IUniswapV2Router01 {
233     function factory() external pure returns (address);
234     function WETH() external pure returns (address);
235 
236     function addLiquidity(
237         address tokenA,
238         address tokenB,
239         uint amountADesired,
240         uint amountBDesired,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline
245     ) external returns (uint amountA, uint amountB, uint liquidity);
246     function addLiquidityETH(
247         address token,
248         uint amountTokenDesired,
249         uint amountTokenMin,
250         uint amountETHMin,
251         address to,
252         uint deadline
253     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
254     function removeLiquidity(
255         address tokenA,
256         address tokenB,
257         uint liquidity,
258         uint amountAMin,
259         uint amountBMin,
260         address to,
261         uint deadline
262     ) external returns (uint amountA, uint amountB);
263     function removeLiquidityETH(
264         address token,
265         uint liquidity,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountToken, uint amountETH);
271     function removeLiquidityWithPermit(
272         address tokenA,
273         address tokenB,
274         uint liquidity,
275         uint amountAMin,
276         uint amountBMin,
277         address to,
278         uint deadline,
279         bool approveMax, uint8 v, bytes32 r, bytes32 s
280     ) external returns (uint amountA, uint amountB);
281     function removeLiquidityETHWithPermit(
282         address token,
283         uint liquidity,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline,
288         bool approveMax, uint8 v, bytes32 r, bytes32 s
289     ) external returns (uint amountToken, uint amountETH);
290     function swapExactTokensForTokens(
291         uint amountIn,
292         uint amountOutMin,
293         address[] calldata path,
294         address to,
295         uint deadline
296     ) external returns (uint[] memory amounts);
297     function swapTokensForExactTokens(
298         uint amountOut,
299         uint amountInMax,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external returns (uint[] memory amounts);
304     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
305         external
306         payable
307         returns (uint[] memory amounts);
308     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
309         external
310         returns (uint[] memory amounts);
311     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
312         external
313         returns (uint[] memory amounts);
314     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
315         external
316         payable
317         returns (uint[] memory amounts);
318 
319     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
320     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
321     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
322     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
323     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
324 }
325 
326 interface IUniswapV2Router02 is IUniswapV2Router01 {
327     function removeLiquidityETHSupportingFeeOnTransferTokens(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountETH);
335     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline,
342         bool approveMax, uint8 v, bytes32 r, bytes32 s
343     ) external returns (uint amountETH);
344 
345     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
346         uint amountIn,
347         uint amountOutMin,
348         address[] calldata path,
349         address to,
350         uint deadline
351     ) external;
352     function swapExactETHForTokensSupportingFeeOnTransferTokens(
353         uint amountOutMin,
354         address[] calldata path,
355         address to,
356         uint deadline
357     ) external payable;
358     function swapExactTokensForETHSupportingFeeOnTransferTokens(
359         uint amountIn,
360         uint amountOutMin,
361         address[] calldata path,
362         address to,
363         uint deadline
364     ) external;
365 }
366 
367 contract Pepenomics is Context, IERC20, Ownable {
368     
369     using SafeMath for uint256;
370     using Address for address;
371     
372     string private _name = "PEPENOMICS";
373     string private _symbol = "PEPENOMICS";
374     uint8 private _decimals = 9;
375 
376     address payable public marketingWalletAddress = payable(0xb770A6BF0954C474C3f67F9189c9F80Cc687900A); // Marketing Address  2%
377     address payable public developmentWalletAddress = payable(0xb8686a53eb0EC8e39506660746CA9885Da2EEdCc); // Utility development Address 1%
378     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
379     
380     mapping (address => uint256) _balances;
381     mapping (address => mapping (address => uint256)) private _allowances;
382     
383     mapping (address => bool) public isExcludedFromFee;
384     mapping (address => bool) public isWalletLimitExempt;
385     mapping (address => bool) public isTxLimitExempt;
386     mapping (address => bool) public isMarketPair;
387 
388     uint256 public _buyLiquidityFee = 0;
389     uint256 public _buyMarketingFee = 2;
390     uint256 public _buyDevelopmentFee = 1;
391     uint256 public _sellLiquidityFee = 0;
392     uint256 public _sellMarketingFee = 2;
393     uint256 public _sellDevelopmentFee = 1;
394 
395     uint256 public _liquidityShare = 0;
396     uint256 public _marketingShare = 4;
397     uint256 public _developmentShare = 2;
398 
399     uint256 public _totalTaxIfBuying = 3;
400     uint256 public _totalTaxIfSelling = 3;
401     uint256 public _totalDistributionShares = 6;
402 
403     uint256 private _totalSupply = 100 * 10**6 * 10**9;
404     uint256 public _maxTxAmount = 3 * 10**6 * 10**9;
405     uint256 public _walletMax = 3 * 10**6 * 10**9;
406     uint256 private minimumTokensBeforeSwap = 550000 * 10**9; 
407 
408     IUniswapV2Router02 public uniswapV2Router;
409     address public uniswapPair;
410     
411     bool inSwapAndLiquify;
412     bool public swapAndLiquifyEnabled = true;
413     bool public swapAndLiquifyByLimitOnly = false;
414     bool public checkWalletLimit = true;
415 
416     event SwapAndLiquifyEnabledUpdated(bool enabled);
417     event SwapAndLiquify(
418         uint256 tokensSwapped,
419         uint256 ethReceived,
420         uint256 tokensIntoLiqudity
421     );
422     
423     event SwapETHForTokens(
424         uint256 amountIn,
425         address[] path
426     );
427     
428     event SwapTokensForETH(
429         uint256 amountIn,
430         address[] path
431     );
432     
433     modifier lockTheSwap {
434         inSwapAndLiquify = true;
435         _;
436         inSwapAndLiquify = false;
437     }
438     
439     constructor () {
440         
441         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
442 
443         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
444             .createPair(address(this), _uniswapV2Router.WETH());
445 
446         uniswapV2Router = _uniswapV2Router;
447         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
448 
449         isExcludedFromFee[owner()] = true;
450         isExcludedFromFee[address(this)] = true;
451         isExcludedFromFee[address(marketingWalletAddress)] = true;
452         
453         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevelopmentFee);
454         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevelopmentFee);
455         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_developmentShare);
456 
457         isWalletLimitExempt[owner()] = true;
458         isWalletLimitExempt[address(uniswapPair)] = true;
459         isWalletLimitExempt[address(this)] = true;
460         isWalletLimitExempt[address(marketingWalletAddress)] = true;
461         isWalletLimitExempt[address(0x71B5759d73262FBb223956913ecF4ecC51057641)] = true; //Pinksale address
462         isWalletLimitExempt[address(0xD152f549545093347A162Dce210e7293f1452150)] = true;
463         
464         isTxLimitExempt[owner()] = true;
465         isTxLimitExempt[address(this)] = true;
466         isTxLimitExempt[address(marketingWalletAddress)] = true;
467         isTxLimitExempt[address(0x71B5759d73262FBb223956913ecF4ecC51057641)] = true; //Pinksale address
468         isTxLimitExempt[address(0xD152f549545093347A162Dce210e7293f1452150)] = true;
469 
470         isMarketPair[address(uniswapPair)] = true;
471 
472         _balances[_msgSender()] = _totalSupply;
473         emit Transfer(address(0), _msgSender(), _totalSupply);
474     }
475 
476     function name() public view returns (string memory) {
477         return _name;
478     }
479 
480     function symbol() public view returns (string memory) {
481         return _symbol;
482     }
483 
484     function decimals() public view returns (uint8) {
485         return _decimals;
486     }
487 
488     function totalSupply() public view override returns (uint256) {
489         return _totalSupply;
490     }
491 
492     function balanceOf(address account) public view override returns (uint256) {
493         return _balances[account];
494     }
495 
496     function allowance(address owner, address spender) public view override returns (uint256) {
497         return _allowances[owner][spender];
498     }
499 
500     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
502         return true;
503     }
504 
505     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
507         return true;
508     }
509 
510     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
511         return minimumTokensBeforeSwap;
512     }
513 
514     function approve(address spender, uint256 amount) public override returns (bool) {
515         _approve(_msgSender(), spender, amount);
516         return true;
517     }
518 
519     function _approve(address owner, address spender, uint256 amount) private {
520         require(owner != address(0), "ERC20: approve from the zero address");
521         require(spender != address(0), "ERC20: approve to the zero address");
522 
523         _allowances[owner][spender] = amount;
524         emit Approval(owner, spender, amount);
525     }
526 
527     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
528         isTxLimitExempt[holder] = exempt;
529     }
530     
531     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
532         isExcludedFromFee[account] = newValue;
533     }
534 
535     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
536         _buyLiquidityFee = newLiquidityTax;
537         _buyMarketingFee = newMarketingTax;
538         _buyDevelopmentFee = newDevelopmentTax;
539 
540         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevelopmentFee);
541         require(_totalTaxIfBuying <= 25, "Buy tax must be less than 25%");
542     }
543 
544     function setSellTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
545         _sellLiquidityFee = newLiquidityTax;
546         _sellMarketingFee = newMarketingTax;
547         _sellDevelopmentFee = newDevelopmentTax;
548 
549         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevelopmentFee);
550         require(_totalTaxIfSelling <= 40, "Sell tax must be less than 40%");
551     }
552     
553     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newDevelopmentShare) external onlyOwner() {
554         _liquidityShare = newLiquidityShare;
555         _marketingShare = newMarketingShare;
556         _developmentShare = newDevelopmentShare;
557 
558         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_developmentShare);
559         require(_totalDistributionShares <=65, "Distribution Shares must be less than 65%");
560     }
561     
562     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
563         require(maxTxAmount >= _totalSupply / 200, "Cannot set MaxTxAmount lower than 0.5%");
564         _maxTxAmount = maxTxAmount;
565     }
566 
567     function enableDisableWalletLimit(bool newValue) external onlyOwner {
568        checkWalletLimit = newValue;
569     }
570 
571     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
572         isWalletLimitExempt[holder] = exempt;
573     }
574 
575     function setWalletLimit(uint256 newLimit) external onlyOwner {
576         require(newLimit >= _totalSupply / 200, "Cannot set MaxWallet lower than 0.5%");
577         _walletMax  = newLimit;
578     }
579 
580     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
581         require(newLimit > 1, "NumTokensBeforeSwap should be not 0");
582         minimumTokensBeforeSwap = newLimit;
583     }
584 
585     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
586         marketingWalletAddress = payable(newAddress);
587     }
588 
589     function setDevelopmentWalletAddress(address newAddress) external onlyOwner() {
590         developmentWalletAddress = payable(newAddress);
591     }
592 
593     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
594         swapAndLiquifyEnabled = _enabled;
595         emit SwapAndLiquifyEnabledUpdated(_enabled);
596     }
597 
598     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
599         swapAndLiquifyByLimitOnly = newValue;
600     }
601     
602     function getCirculatingSupply() public view returns (uint256) {
603         return _totalSupply.sub(balanceOf(deadAddress));
604     }
605 
606     function transferToAddressETH(address payable recipient, uint256 amount) private {
607         recipient.transfer(amount);
608     }
609 
610      //to recieve ETH from uniswapV2Router when swaping
611     receive() external payable {}
612 
613     function transfer(address recipient, uint256 amount) public override returns (bool) {
614         _transfer(_msgSender(), recipient, amount);
615         return true;
616     }
617 
618     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
619         _transfer(sender, recipient, amount);
620         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
621         return true;
622     }
623 
624     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
625 
626         require(sender != address(0), "ERC20: transfer from the zero address");
627         require(recipient != address(0), "ERC20: transfer to the zero address");
628 
629         if(inSwapAndLiquify)
630         { 
631             return _basicTransfer(sender, recipient, amount); 
632         }
633         else
634         {
635             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
636                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
637             }            
638 
639             uint256 contractTokenBalance = balanceOf(address(this));
640             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
641             
642             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
643             {
644                 if(swapAndLiquifyByLimitOnly)
645                     contractTokenBalance = minimumTokensBeforeSwap;
646                 swapAndLiquify(contractTokenBalance);    
647             }
648 
649             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
650 
651             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
652                                          amount : takeFee(sender, recipient, amount);
653 
654             if(checkWalletLimit && !isWalletLimitExempt[recipient])
655                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
656 
657             _balances[recipient] = _balances[recipient].add(finalAmount);
658 
659             emit Transfer(sender, recipient, finalAmount);
660             return true;
661         }
662     }
663 
664     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
665         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
666         _balances[recipient] = _balances[recipient].add(amount);
667         emit Transfer(sender, recipient, amount);
668         return true;
669     }
670 
671     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
672         
673         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
674         uint256 tokensForSwap = tAmount.sub(tokensForLP);
675 
676         swapTokensForEth(tokensForSwap);
677         uint256 amountReceived = address(this).balance;
678 
679         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShare.div(2));
680         
681         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShare).div(totalETHFee).div(2);
682         uint256 amountETHDevelopment = amountReceived.mul(_developmentShare).div(totalETHFee);
683         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity).sub(amountETHDevelopment);
684 
685         if(amountETHMarketing > 0)
686             transferToAddressETH(marketingWalletAddress, amountETHMarketing);
687 
688         if(amountETHDevelopment > 0)
689             transferToAddressETH(developmentWalletAddress, amountETHDevelopment);
690 
691         if(amountETHLiquidity > 0 && tokensForLP > 0)
692             addLiquidity(tokensForLP, amountETHLiquidity);
693     }
694     
695     function swapTokensForEth(uint256 tokenAmount) private {
696         // generate the uniswap pair path of token -> weth
697         address[] memory path = new address[](2);
698         path[0] = address(this);
699         path[1] = uniswapV2Router.WETH();
700 
701         _approve(address(this), address(uniswapV2Router), tokenAmount);
702 
703         // make the swap
704         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
705             tokenAmount,
706             0, // accept any amount of ETH
707             path,
708             address(this), // The contract
709             block.timestamp
710         );
711         
712         emit SwapTokensForETH(tokenAmount, path);
713     }
714 
715     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
716         // approve token transfer to cover all possible scenarios
717         _approve(address(this), address(uniswapV2Router), tokenAmount);
718 
719         // add the liquidity
720         uniswapV2Router.addLiquidityETH{value: ethAmount}(
721             address(this),
722             tokenAmount,
723             0, // slippage is unavoidable
724             0, // slippage is unavoidable
725             owner(),
726             block.timestamp
727         );
728     }
729 
730     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
731         
732         uint256 feeAmount = 0;
733         
734         if(isMarketPair[sender]) {
735             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
736         }
737         else if(isMarketPair[recipient]) {
738             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
739         }
740         
741         if(feeAmount > 0) {
742             _balances[address(this)] = _balances[address(this)].add(feeAmount);
743             emit Transfer(sender, address(this), feeAmount);
744         }
745 
746         return amount.sub(feeAmount);
747     }
748     
749 }