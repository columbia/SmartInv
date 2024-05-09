1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; 
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         return mod(a, b, "SafeMath: modulo by zero");
73     }
74 
75     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b != 0, errorMessage);
77         return a % b;
78     }
79 }
80 
81 library Address {
82 
83     function isContract(address account) internal view returns (bool) {
84         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
85         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
86         // for accounts without code, i.e. `keccak256('')`
87         bytes32 codehash;
88         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
89         // solhint-disable-next-line no-inline-assembly
90         assembly { codehash := extcodehash(account) }
91         return (codehash != accountHash && codehash != 0x0);
92     }
93 
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103       return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
107         return _functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123         if (success) {
124             return returndata;
125         } else {
126             
127             if (returndata.length > 0) {
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     constructor () {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         emit OwnershipTransferred(address(0), msgSender);
148     }
149 
150     function owner() public view returns (address) {
151         return _owner;
152     }   
153     
154     modifier onlyOwner() {
155         require(_owner == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158     
159     function waiveOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         emit OwnershipTransferred(_owner, newOwner);
167         _owner = newOwner;
168     }
169 
170     function getTime() public view returns (uint256) {
171         return block.timestamp;
172     }
173 
174     
175 }
176 
177 interface IUniswapV2Factory {
178     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
179 
180     function feeTo() external view returns (address);
181     function feeToSetter() external view returns (address);
182 
183     function getPair(address tokenA, address tokenB) external view returns (address pair);
184     function allPairs(uint) external view returns (address pair);
185     function allPairsLength() external view returns (uint);
186 
187     function createPair(address tokenA, address tokenB) external returns (address pair);
188 
189     function setFeeTo(address) external;
190     function setFeeToSetter(address) external;
191 }
192 
193 interface IUniswapV2Pair {
194     event Approval(address indexed owner, address indexed spender, uint value);
195     event Transfer(address indexed from, address indexed to, uint value);
196 
197     function name() external pure returns (string memory);
198     function symbol() external pure returns (string memory);
199     function decimals() external pure returns (uint8);
200     function totalSupply() external view returns (uint);
201     function balanceOf(address owner) external view returns (uint);
202     function allowance(address owner, address spender) external view returns (uint);
203 
204     function approve(address spender, uint value) external returns (bool);
205     function transfer(address to, uint value) external returns (bool);
206     function transferFrom(address from, address to, uint value) external returns (bool);
207 
208     function DOMAIN_SEPARATOR() external view returns (bytes32);
209     function PERMIT_TYPEHASH() external pure returns (bytes32);
210     function nonces(address owner) external view returns (uint);
211 
212     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
213     
214     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
215     event Swap(
216         address indexed sender,
217         uint amount0In,
218         uint amount1In,
219         uint amount0Out,
220         uint amount1Out,
221         address indexed to
222     );
223     event Sync(uint112 reserve0, uint112 reserve1);
224 
225     function MINIMUM_LIQUIDITY() external pure returns (uint);
226     function factory() external view returns (address);
227     function token0() external view returns (address);
228     function token1() external view returns (address);
229     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
230     function price0CumulativeLast() external view returns (uint);
231     function price1CumulativeLast() external view returns (uint);
232     function kLast() external view returns (uint);
233 
234     function burn(address to) external returns (uint amount0, uint amount1);
235     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
236     function skim(address to) external;
237     function sync() external;
238 
239     function initialize(address, address) external;
240 }
241 
242 interface IUniswapV2Router01 {
243     function factory() external pure returns (address);
244     function WETH() external pure returns (address);
245 
246     function addLiquidity(
247         address tokenA,
248         address tokenB,
249         uint amountADesired,
250         uint amountBDesired,
251         uint amountAMin,
252         uint amountBMin,
253         address to,
254         uint deadline
255     ) external returns (uint amountA, uint amountB, uint liquidity);
256     function addLiquidityETH(
257         address token,
258         uint amountTokenDesired,
259         uint amountTokenMin,
260         uint amountETHMin,
261         address to,
262         uint deadline
263     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
264     function removeLiquidity(
265         address tokenA,
266         address tokenB,
267         uint liquidity,
268         uint amountAMin,
269         uint amountBMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountA, uint amountB);
273     function removeLiquidityETH(
274         address token,
275         uint liquidity,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external returns (uint amountToken, uint amountETH);
281     function removeLiquidityWithPermit(
282         address tokenA,
283         address tokenB,
284         uint liquidity,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline,
289         bool approveMax, uint8 v, bytes32 r, bytes32 s
290     ) external returns (uint amountA, uint amountB);
291     function removeLiquidityETHWithPermit(
292         address token,
293         uint liquidity,
294         uint amountTokenMin,
295         uint amountETHMin,
296         address to,
297         uint deadline,
298         bool approveMax, uint8 v, bytes32 r, bytes32 s
299     ) external returns (uint amountToken, uint amountETH);
300     function swapExactTokensForTokens(
301         uint amountIn,
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external returns (uint[] memory amounts);
307     function swapTokensForExactTokens(
308         uint amountOut,
309         uint amountInMax,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external returns (uint[] memory amounts);
314     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
315         external
316         payable
317         returns (uint[] memory amounts);
318     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
319         external
320         returns (uint[] memory amounts);
321     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
322         external
323         returns (uint[] memory amounts);
324     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
325         external
326         payable
327         returns (uint[] memory amounts);
328 
329     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
330     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
331     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
332     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
333     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
334 }
335 
336 interface IUniswapV2Router02 is IUniswapV2Router01 {
337     function removeLiquidityETHSupportingFeeOnTransferTokens(
338         address token,
339         uint liquidity,
340         uint amountTokenMin,
341         uint amountETHMin,
342         address to,
343         uint deadline
344     ) external returns (uint amountETH);
345     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
346         address token,
347         uint liquidity,
348         uint amountTokenMin,
349         uint amountETHMin,
350         address to,
351         uint deadline,
352         bool approveMax, uint8 v, bytes32 r, bytes32 s
353     ) external returns (uint amountETH);
354 
355     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
356         uint amountIn,
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     ) external;
362     function swapExactETHForTokensSupportingFeeOnTransferTokens(
363         uint amountOutMin,
364         address[] calldata path,
365         address to,
366         uint deadline
367     ) external payable;
368     function swapExactTokensForETHSupportingFeeOnTransferTokens(
369         uint amountIn,
370         uint amountOutMin,
371         address[] calldata path,
372         address to,
373         uint deadline
374     ) external;
375 }
376 
377 contract FEG20 is Context, IERC20, Ownable {
378     
379     using SafeMath for uint256;
380     using Address for address;
381     
382     string private _name = "FEG2.0";
383     string private _symbol = "FEG2.0";
384     uint8 private _decimals = 18;
385 
386     address payable public marketingWalletAddress = payable(0xa6e746D70E2f34748F3424C96f0bd6a7babC8dC7); 
387     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
388     
389     mapping (address => uint256) _balances;
390     mapping (address => mapping (address => uint256)) private _allowances;
391     
392     mapping (address => bool) public isExcludedFromFee;
393     mapping (address => bool) public isWalletLimitExempt;
394     mapping (address => bool) public isTxLimitExempt;
395     mapping (address => bool) public isMarketPair;
396     
397 
398     uint256 public _buyLiquidityFee;
399     uint256 public _buyMarketingFee = 1;
400  
401     uint256 public _sellLiquidityFee;
402     uint256 public _sellMarketingFee = 1;
403 
404     uint256 public _liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
405     uint256 public _marketingShare = _buyMarketingFee.add(_sellMarketingFee);
406 
407     uint256 public _totalTaxIfBuying;
408     uint256 public _totalTaxIfSelling;
409     uint256 public _totalDistributionShares;
410 
411     uint256 private _totalSupply = 420690000000000 * 10**_decimals;
412     uint256 public _maxTxAmount = _totalSupply.div(1); 
413     uint256 public _walletMax = _totalSupply.div(1);
414     uint256 private minimumTokensBeforeSwap = _totalSupply.div(10000); 
415 
416     IUniswapV2Router02 public uniswapV2Router;
417     address public uniswapPair;
418     
419     bool inSwapAndLiquify;
420     bool public swapAndLiquifyEnabled = true;
421     bool public swapAndLiquifyByLimitOnly = false;
422     bool public checkWalletLimit = true;
423 
424     event SwapAndLiquifyEnabledUpdated(bool enabled);
425     event SwapAndLiquify(
426         uint256 tokensSwapped,
427         uint256 ethReceived,
428         uint256 tokensIntoLiqudity
429     );
430     
431     event SwapETHForTokens(
432         uint256 amountIn,
433         address[] path
434     );
435     
436     event SwapTokensForETH(
437         uint256 amountIn,
438         address[] path
439     );
440     
441     modifier lockTheSwap {
442         inSwapAndLiquify = true;
443         _;
444         inSwapAndLiquify = false;
445     }
446     
447     constructor () {
448         
449         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
450 
451         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
452             .createPair(address(this), _uniswapV2Router.WETH());
453 
454         uniswapV2Router = _uniswapV2Router;
455         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
456 
457         isExcludedFromFee[owner()] = true;
458         isExcludedFromFee[address(this)] = true;
459         
460         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee);
461         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee);
462         _totalDistributionShares = _liquidityShare.add(_marketingShare);
463         isWalletLimitExempt[owner()] = true;
464         isWalletLimitExempt[address(uniswapPair)] = true;
465         isWalletLimitExempt[address(this)] = true;
466         
467         isTxLimitExempt[owner()] = true;
468         isTxLimitExempt[address(this)] = true;
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
527     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
528         isMarketPair[account] = newValue;
529     }
530 
531     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
532         isTxLimitExempt[holder] = exempt;
533     }
534     
535     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
536         isExcludedFromFee[account] = newValue;
537     }
538 
539 /*     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax) external onlyOwner() {
540         _buyLiquidityFee = newLiquidityTax;
541         _buyMarketingFee = newMarketingTax;
542         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee);
543     } */
544 
545 /*     function setSellTaxes(uint256 newLiquidityTax, uint256 newMarketingTax) external onlyOwner() {
546         _sellLiquidityFee = newLiquidityTax;
547         _sellMarketingFee = newMarketingTax;
548         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee);
549     } */
550 
551 /*     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare) external onlyOwner() {
552         _liquidityShare = newLiquidityShare;
553         _marketingShare = newMarketingShare;
554         _totalDistributionShares = _liquidityShare.add(_marketingShare);
555     } */
556     
557 /*     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
558         _maxTxAmount = maxTxAmount;
559     } */
560 
561     function enableDisableWalletLimit(bool newValue) external onlyOwner {
562        checkWalletLimit = newValue;
563     }
564 
565     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
566         isWalletLimitExempt[holder] = exempt;
567     }
568 
569 /*     function setWalletLimit(uint256 newLimit) external onlyOwner {
570         _walletMax  = newLimit;
571     } */
572 
573     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
574         minimumTokensBeforeSwap = newLimit;
575     }
576 
577     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
578         marketingWalletAddress = payable(newAddress);
579     }
580 
581 
582     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
583         swapAndLiquifyEnabled = _enabled;
584         emit SwapAndLiquifyEnabledUpdated(_enabled);
585     }
586 
587     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
588         swapAndLiquifyByLimitOnly = newValue;
589     }
590     
591     function getCirculatingSupply() public view returns (uint256) {
592         return _totalSupply.sub(balanceOf(deadAddress));
593     }
594 
595     function transferToAddressETH(address payable recipient, uint256 amount) private {
596         recipient.transfer(amount);
597     }
598     
599     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
600 
601         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
602 
603         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
604 
605         if(newPairAddress == address(0)) //Create If Doesnt exist
606         {
607             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
608                 .createPair(address(this), _uniswapV2Router.WETH());
609         }
610 
611         uniswapPair = newPairAddress; //Set new pair address
612         uniswapV2Router = _uniswapV2Router; //Set new router address
613 
614         isWalletLimitExempt[address(uniswapPair)] = true;
615         isMarketPair[address(uniswapPair)] = true;
616     }
617 
618      //to recieve ETH from uniswapV2Router when swaping
619     receive() external payable {}
620 
621     function transfer(address recipient, uint256 amount) public override returns (bool) {
622         _transfer(_msgSender(), recipient, amount);
623         return true;
624     }
625 
626     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
627         _transfer(sender, recipient, amount);
628         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
629         return true;
630     }
631 
632     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
633         require(sender != address(0), "ERC20: transfer from the zero address");
634         require(recipient != address(0), "ERC20: transfer to the zero address");      
635 
636         if(inSwapAndLiquify)
637         { 
638             return _basicTransfer(sender, recipient, amount); 
639         }
640         else
641         {
642             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
643                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
644             }            
645 
646             uint256 contractTokenBalance = balanceOf(address(this));
647             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
648             
649             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
650             {
651                 if(swapAndLiquifyByLimitOnly)
652                     contractTokenBalance = minimumTokensBeforeSwap;
653                 swapAndLiquify(contractTokenBalance);    
654             }
655 
656             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
657 
658             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
659                                          amount : takeFee(sender, recipient, amount);
660 
661             if(checkWalletLimit && !isWalletLimitExempt[recipient])
662                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
663 
664             _balances[recipient] = _balances[recipient].add(finalAmount);
665 
666             emit Transfer(sender, recipient, finalAmount);
667             return true;
668         }
669     }
670 
671     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
672         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
673         _balances[recipient] = _balances[recipient].add(amount);
674         emit Transfer(sender, recipient, amount);
675         return true;
676     }
677 
678     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
679         
680         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
681         uint256 tokensForSwap = tAmount.sub(tokensForLP);
682 
683         swapTokensForEth(tokensForSwap);
684         uint256 amountReceived = address(this).balance;
685 
686         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShare.div(2));
687         
688         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShare).div(totalETHFee).div(2);
689 
690         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity);
691 
692         if(amountETHMarketing > 0)
693             transferToAddressETH(marketingWalletAddress, amountETHMarketing);
694 
695 
696         if(amountETHLiquidity > 0 && tokensForLP > 0)
697             addLiquidity(tokensForLP, amountETHLiquidity);
698     }
699     
700     function swapTokensForEth(uint256 tokenAmount) private {
701         // generate the uniswap pair path of token -> weth
702         address[] memory path = new address[](2);
703         path[0] = address(this);
704         path[1] = uniswapV2Router.WETH();
705 
706         _approve(address(this), address(uniswapV2Router), tokenAmount);
707 
708         // make the swap
709         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
710             tokenAmount,
711             0, // accept any amount of ETH
712             path,
713             address(this), // The contract
714             block.timestamp
715         );
716         
717         emit SwapTokensForETH(tokenAmount, path);
718     }
719 
720     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
721         // approve token transfer to cover all possible scenarios
722         _approve(address(this), address(uniswapV2Router), tokenAmount);
723 
724         // add the liquidity
725         uniswapV2Router.addLiquidityETH{value: ethAmount}(
726             address(this),
727             tokenAmount,
728             0, // slippage is unavoidable
729             0, // slippage is unavoidable
730             owner(),
731             block.timestamp
732         );
733     }
734 
735     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
736         
737         uint256 feeAmount = 0;
738         
739         if(isMarketPair[sender]) {
740             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
741         }
742         else if(isMarketPair[recipient]) {
743             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
744         }
745         
746         if(feeAmount > 0) {
747             _balances[address(this)] = _balances[address(this)].add(feeAmount);
748             emit Transfer(sender, address(this), feeAmount);
749         }
750 
751         return amount.sub(feeAmount);
752     }
753 
754 }