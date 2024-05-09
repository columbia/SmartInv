1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6 
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this;
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
85   
86         bytes32 codehash;
87         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;  //hash address of empty contract
88 
89         assembly { codehash := extcodehash(account) }
90         return (codehash != accountHash && codehash != 0x0);
91     }
92 
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(address(this).balance >= amount, "Address: insufficient balance");
95 
96         (bool success, ) = recipient.call{ value: amount }("");
97         require(success, "Address: unable to send value, recipient may have reverted");
98     }
99 
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101       return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
105         return _functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
113         require(address(this).balance >= value, "Address: insufficient balance for call");
114         return _functionCallWithValue(target, data, value, errorMessage);
115     }
116 
117     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
118         require(isContract(target), "Address: call to non-contract");
119 
120         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
121         if (success) {
122             return returndata;
123         } else {
124             
125             if (returndata.length > 0) {
126                 assembly {
127                     let returndata_size := mload(returndata)
128                     revert(add(32, returndata), returndata_size)
129                 }
130             } else {
131                 revert(errorMessage);
132             }
133         }
134     }
135 }
136 
137 contract Ownable is Context {
138 
139     address private _owner;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143     constructor () {
144         address msgSender = _msgSender();
145         _owner = msgSender;
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
158     function isOwner() public view returns (bool) {
159         return msg.sender == _owner;
160     }
161 
162     function renouncedOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
164         _owner = address(0x000000000000000000000000000000000000dEaD);
165     }
166 
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 
173 }
174 
175 interface IUniswapV2Factory {
176     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
177 
178     function feeTo() external view returns (address);
179     function feeToSetter() external view returns (address);
180 
181     function getPair(address tokenA, address tokenB) external view returns (address pair);
182     function allPairs(uint) external view returns (address pair);
183     function allPairsLength() external view returns (uint);
184 
185     function createPair(address tokenA, address tokenB) external returns (address pair);
186 
187     function setFeeTo(address) external;
188     function setFeeToSetter(address) external;
189 }
190 
191 interface IUniswapV2Pair {
192     event Approval(address indexed owner, address indexed spender, uint value);
193     event Transfer(address indexed from, address indexed to, uint value);
194 
195     function name() external pure returns (string memory);
196     function symbol() external pure returns (string memory);
197     function decimals() external pure returns (uint8);
198     function totalSupply() external view returns (uint);
199     function balanceOf(address owner) external view returns (uint);
200     function allowance(address owner, address spender) external view returns (uint);
201 
202     function approve(address spender, uint value) external returns (bool);
203     function transfer(address to, uint value) external returns (bool);
204     function transferFrom(address from, address to, uint value) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207     function PERMIT_TYPEHASH() external pure returns (bytes32);
208     function nonces(address owner) external view returns (uint);
209 
210     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
211     
212     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
213     event Swap(
214         address indexed sender,
215         uint amount0In,
216         uint amount1In,
217         uint amount0Out,
218         uint amount1Out,
219         address indexed to
220     );
221     event Sync(uint112 reserve0, uint112 reserve1);
222 
223     function MINIMUM_LIQUIDITY() external pure returns (uint);
224     function factory() external view returns (address);
225     function token0() external view returns (address);
226     function token1() external view returns (address);
227     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
228     function price0CumulativeLast() external view returns (uint);
229     function price1CumulativeLast() external view returns (uint);
230     function kLast() external view returns (uint);
231 
232     function burn(address to) external returns (uint amount0, uint amount1);
233     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
234     function skim(address to) external;
235     function sync() external;
236 
237     function initialize(address, address) external;
238 }
239 
240 interface IUniswapV2Router01 {
241     function factory() external pure returns (address);
242     function WETH() external pure returns (address);
243 
244     function addLiquidity(
245         address tokenA,
246         address tokenB,
247         uint amountADesired,
248         uint amountBDesired,
249         uint amountAMin,
250         uint amountBMin,
251         address to,
252         uint deadline
253     ) external returns (uint amountA, uint amountB, uint liquidity);
254     function addLiquidityETH(
255         address token,
256         uint amountTokenDesired,
257         uint amountTokenMin,
258         uint amountETHMin,
259         address to,
260         uint deadline
261     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
262     function removeLiquidity(
263         address tokenA,
264         address tokenB,
265         uint liquidity,
266         uint amountAMin,
267         uint amountBMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountA, uint amountB);
271     function removeLiquidityETH(
272         address token,
273         uint liquidity,
274         uint amountTokenMin,
275         uint amountETHMin,
276         address to,
277         uint deadline
278     ) external returns (uint amountToken, uint amountETH);
279     function removeLiquidityWithPermit(
280         address tokenA,
281         address tokenB,
282         uint liquidity,
283         uint amountAMin,
284         uint amountBMin,
285         address to,
286         uint deadline,
287         bool approveMax, uint8 v, bytes32 r, bytes32 s
288     ) external returns (uint amountA, uint amountB);
289     function removeLiquidityETHWithPermit(
290         address token,
291         uint liquidity,
292         uint amountTokenMin,
293         uint amountETHMin,
294         address to,
295         uint deadline,
296         bool approveMax, uint8 v, bytes32 r, bytes32 s
297     ) external returns (uint amountToken, uint amountETH);
298     function swapExactTokensForTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external returns (uint[] memory amounts);
305     function swapTokensForExactTokens(
306         uint amountOut,
307         uint amountInMax,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external returns (uint[] memory amounts);
312     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
313         external
314         payable
315         returns (uint[] memory amounts);
316     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
317         external
318         returns (uint[] memory amounts);
319     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
320         external
321         returns (uint[] memory amounts);
322     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
323         external
324         payable
325         returns (uint[] memory amounts);
326 
327     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
328     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
329     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
330     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
331     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
332 }
333 
334 interface IUniswapV2Router02 is IUniswapV2Router01 {
335     function removeLiquidityETHSupportingFeeOnTransferTokens(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external returns (uint amountETH);
343     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
344         address token,
345         uint liquidity,
346         uint amountTokenMin,
347         uint amountETHMin,
348         address to,
349         uint deadline,
350         bool approveMax, uint8 v, bytes32 r, bytes32 s
351     ) external returns (uint amountETH);
352 
353     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
354         uint amountIn,
355         uint amountOutMin,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external;
360     function swapExactETHForTokensSupportingFeeOnTransferTokens(
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external payable;
366     function swapExactTokensForETHSupportingFeeOnTransferTokens(
367         uint amountIn,
368         uint amountOutMin,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external;
373 }
374 
375 contract THIS is Context, IERC20, Ownable {
376     
377     using SafeMath for uint256;
378     using Address for address;
379     
380     string private _name = "THIS";
381     string private _symbol = "THIS";
382     uint8 private _decimals = 18;
383 
384     address public marketingWallet = 0x9E50A542E9de75F8E17669152472c6806dDfA7AE;
385     address public developerWallet = 0xE6E03bc0ed2D9027880e7cED07608040914C770a;
386     address public liquidityReciever;
387 
388     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
389     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
390     
391     mapping (address => uint256) _balances;
392     mapping (address => mapping (address => uint256)) private _allowances;
393     
394     mapping (address => bool) public isExcludedFromFee;
395     mapping (address => bool) public isMarketPair;
396     mapping (address => bool) public isWalletLimitExempt;
397     mapping (address => bool) public isTxLimitExempt;
398     mapping (address => bool) public blacklisted;
399     mapping (address => bool) private allowTransfer;
400 
401     uint256 _buyLiquidityFee = 0;
402     uint256 _buyMarketingFee = 0;
403     uint256 _buyDeveloperFee = 0;
404     
405     uint256 _sellLiquidityFee = 0;
406     uint256 _sellMarketingFee = 0;
407     uint256 _sellDeveloperFee = 0;
408 
409     uint256 totalBuy;
410     uint256 totalSell;
411 
412     uint256 denominator = 1000;
413 
414     uint256 private _totalSupply = 1_000_000_000 * 10**_decimals;   
415 
416     uint256 public minimumTokensBeforeSwap = 100000 * 10**_decimals;
417 
418     uint256 public _maxTxAmount =  _totalSupply.mul(5).div(denominator);     //0.5%
419     uint256 public _walletMax = _totalSupply.mul(10).div(denominator);    //1%
420 
421     bool public EnableTxLimit = true;
422     bool public checkWalletLimit = true;
423 
424     bool public initalDistribution;
425     bool public triggered;
426     uint public launchTime;
427 
428     IUniswapV2Router02 public uniswapV2Router;
429     address public uniswapPair;
430     
431     bool inSwapAndLiquify;
432     bool public swapAndLiquifyEnabled = true;
433 
434     event SwapAndLiquifyEnabledUpdated(bool enabled);
435 
436     event SwapAndLiquify(
437         uint256 tokensSwapped,
438         uint256 ethReceived,
439         uint256 tokensIntoLiqudity
440     );
441     
442     event SwapETHForTokens(
443         uint256 amountIn,
444         address[] path
445     );
446     
447     event SwapTokensForETH(
448         uint256 amountIn,
449         address[] path
450     );
451     
452     modifier lockTheSwap {
453         inSwapAndLiquify = true;
454         _;
455         inSwapAndLiquify = false;
456     }
457     
458     constructor () {
459         
460         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
461 
462         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
463             .createPair(address(this), _uniswapV2Router.WETH());
464 
465         uniswapV2Router = _uniswapV2Router;
466         _allowances[address(this)][address(uniswapV2Router)] = ~uint256(0);
467 
468         liquidityReciever = msg.sender;
469 
470         isExcludedFromFee[address(this)] = true;
471         isExcludedFromFee[msg.sender] = true;
472         isExcludedFromFee[marketingWallet] = true;
473         isExcludedFromFee[developerWallet] = true;
474 
475         isWalletLimitExempt[msg.sender] = true;
476         isWalletLimitExempt[address(uniswapPair)] = true;
477         isWalletLimitExempt[address(this)] = true;
478         
479         isTxLimitExempt[msg.sender] = true;
480         isTxLimitExempt[address(this)] = true;
481 
482         isMarketPair[address(uniswapPair)] = true;
483 
484         totalBuy = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
485         totalSell = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
486 
487         _balances[msg.sender] = _totalSupply;
488         emit Transfer(address(0), msg.sender, _totalSupply);
489     }
490 
491     /*====================================
492     |               Getters              |
493     ====================================*/
494 
495     function name() public view returns (string memory) {
496         return _name;
497     }
498 
499     function symbol() public view returns (string memory) {
500         return _symbol;
501     }
502 
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 
507     function totalSupply() public view override returns (uint256) {
508         return _totalSupply;
509     }
510 
511     function balanceOf(address account) public view override returns (uint256) {
512        return _balances[account];     
513     }
514 
515     function allowance(address owner, address spender) public view override returns (uint256) {
516         return _allowances[owner][spender];
517     }
518 
519     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
520         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
521         return true;
522     }
523 
524     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
526         return true;
527     }
528 
529     function approve(address spender, uint256 amount) public override returns (bool) {
530         _approve(_msgSender(), spender, amount);
531         return true;
532     }
533 
534     function _approve(address owner, address spender, uint256 amount) private {
535         require(owner != address(0), "ERC20: approve from the zero address");
536         require(spender != address(0), "ERC20: approve to the zero address");
537 
538         _allowances[owner][spender] = amount;
539         emit Approval(owner, spender, amount);
540     }
541     
542     function getCirculatingSupply() public view returns (uint256) {
543         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
544     }
545 
546      //to recieve ETH from uniswapV2Router when swaping
547     receive() external payable {}
548 
549     function transfer(address recipient, uint256 amount) public override returns (bool) {
550         _transfer(_msgSender(), recipient, amount);
551         return true;
552     }
553 
554     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
555         _transfer(sender, recipient, amount);
556         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
557         return true;
558     }
559 
560     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
561 
562         require(sender != address(0), "ERC20: transfer from the zero address");
563         require(recipient != address(0), "ERC20: transfer to the zero address");
564         require(amount > 0, "Transfer amount must be greater than zero");
565         require(!blacklisted[sender] && !blacklisted[recipient],"Error: Blacklist Bots/Contracts not Allowed!!");
566         require(initalDistribution || allowTransfer[msg.sender] || isOwner() ,"Trade is Currently Paused!!");
567         
568         
569         if((block.timestamp > launchTime + 15 minutes) && !triggered && (launchTime != 0) ){
570             _maxTxAmount =  _totalSupply.mul(15).div(denominator);     //1.5%
571             _walletMax = _totalSupply.mul(15).div(denominator);    //1.5%
572             triggered = true;
573             
574         }
575         
576 
577         if(inSwapAndLiquify)
578         { 
579             return _basicTransfer(sender, recipient, amount); 
580         }
581         else
582         {  
583             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
584                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
585             } 
586 
587             uint256 contractTokenBalance = balanceOf(address(this));
588             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
589             
590             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
591             {
592                 swapAndLiquify();
593             }
594 
595             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
596 
597             uint256 finalAmount = shouldTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
598 
599             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
600                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet Limit Exceeded!!");
601             }
602 
603             _balances[recipient] = _balances[recipient].add(finalAmount);
604 
605             emit Transfer(sender, recipient, finalAmount);
606             return true;
607         }
608     }
609 
610     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
611         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
612         _balances[recipient] = _balances[recipient].add(amount);
613         emit Transfer(sender, recipient, amount);
614         return true;
615     }
616 
617     function swapAndLiquify() private lockTheSwap {
618 
619         uint256 contractBalance = balanceOf(address(this));
620 
621         if(contractBalance == 0) return;
622 
623         uint256 totalShares = totalBuy.add(totalSell);
624         uint256 _liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
625         uint256 _MarketingShare = _buyMarketingFee.add(_sellMarketingFee);
626 
627         uint256 tokensForLP = contractBalance.mul(_liquidityShare).div(totalShares).div(2);
628         uint256 tokensForSwap = contractBalance.sub(tokensForLP);
629 
630         uint256 initialBalance = address(this).balance;
631         swapTokensForEth(tokensForSwap);
632         uint256 amountReceived = address(this).balance.sub(initialBalance);
633 
634         uint256 totalBNBFee = totalShares.sub(_liquidityShare.div(2));
635         
636         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
637         uint256 amountBNBMarketing = amountReceived.mul(_MarketingShare).div(totalBNBFee);
638         uint256 amountBNBDeveloper = amountReceived.sub(amountBNBLiquidity).sub(amountBNBMarketing);
639 
640         if(amountBNBMarketing > 0)
641             transferToAddressETH(marketingWallet, amountBNBMarketing);
642 
643         if(amountBNBDeveloper > 0)
644             transferToAddressETH(developerWallet, amountBNBDeveloper);
645 
646         if(amountBNBLiquidity > 0 && tokensForLP > 0)
647             addLiquidity(tokensForLP, amountBNBLiquidity);
648     }
649 
650     function transferToAddressETH(address recipient, uint256 amount) private {
651         payable(recipient).transfer(amount);
652     }
653     
654     function swapTokensForEth(uint256 tokenAmount) private {
655         // generate the uniswap pair path of token -> weth
656         address[] memory path = new address[](2);
657         path[0] = address(this);
658         path[1] = uniswapV2Router.WETH();
659 
660         _approve(address(this), address(uniswapV2Router), tokenAmount);
661 
662         // make the swap
663         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
664             tokenAmount,
665             0, // accept any amount of ETH
666             path,
667             address(this), // The contract
668             block.timestamp
669         );
670         
671         emit SwapTokensForETH(tokenAmount, path);
672     }
673 
674     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
675         // approve token transfer to cover all possible scenarios
676         _approve(address(this), address(uniswapV2Router), tokenAmount);
677 
678         // add the liquidity
679         uniswapV2Router.addLiquidityETH{value: ethAmount}(
680             address(this),
681             tokenAmount,
682             0, // slippage is unavoidable
683             0, // slippage is unavoidable
684             liquidityReciever,
685             block.timestamp
686         );
687     }
688 
689     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
690         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
691             return true;
692         }
693         else if (isMarketPair[sender] || isMarketPair[recipient]) {
694             return false;
695         }
696         else {
697             return false;
698         }
699     }
700 
701     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
702         
703         uint feeAmount;
704 
705         unchecked {
706 
707             if(isMarketPair[sender]) {
708             
709                 feeAmount = amount.mul(totalBuy).div(denominator);
710             }
711             else if(isMarketPair[recipient]) {
712 
713                 feeAmount = amount.mul(totalSell).div(denominator);
714                 
715             }     
716 
717             if(feeAmount > 0) {
718                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
719                 emit Transfer(sender, address(this), feeAmount);
720             }
721 
722             return amount.sub(feeAmount);
723         }
724         
725     }
726 
727     /*====================================
728     |               Setters              |
729     ====================================*/
730 
731     //To Block Bots to trade
732     function blacklistBot(address _adr,bool _status) public onlyOwner {
733         blacklisted[_adr] = _status;
734     }
735 
736     //To Rescue Stucked Balance
737     function rescueFunds() public onlyOwner { 
738         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
739         require(os,"Transaction Failed!!");
740     }
741 
742     //To Rescue Stucked Tokens
743     function rescueTokens(IERC20 adr,address recipient,uint amount) public onlyOwner {
744         adr.transfer(recipient,amount);
745     }
746 
747     function openTrade(bool _status,bool _r) public onlyOwner {
748         initalDistribution = _status;
749         if(_r) launchTime = block.timestamp;
750     }
751 
752     function setWhitelistTransfer(address _adr, bool _status) public onlyOwner {
753         allowTransfer[_adr] = _status;
754     }
755 
756     function enableTxLimit(bool _status) public onlyOwner {
757         EnableTxLimit = _status;
758     }
759 
760     function enableWalletLimit(bool _status) public onlyOwner {
761         checkWalletLimit = _status;
762     }
763 
764     function setBuyFee(uint _newLP , uint _newMarket , uint _newDeveloper) public onlyOwner {     
765         _buyLiquidityFee = _newLP;
766         _buyMarketingFee = _newMarket;
767         _buyDeveloperFee = _newDeveloper;
768         totalBuy = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
769     }
770 
771     function setSellFee(uint _newLP , uint _newMarket , uint _newDeveloper) public onlyOwner {        
772         _sellLiquidityFee = _newLP;
773         _sellMarketingFee = _newMarket;
774         _sellDeveloperFee = _newDeveloper;
775         totalSell = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
776     }
777 
778     function setWallets(address _market,address _developer,address _liquidityRec) public onlyOwner {
779         marketingWallet = _market;
780         developerWallet = _developer;
781         liquidityReciever = _liquidityRec;
782     }
783 
784     function setExcludeFromFee(address _adr,bool _status) public onlyOwner {
785         require(isExcludedFromFee[_adr] != _status,"Not Changed!!");
786         isExcludedFromFee[_adr] = _status;
787     }
788 
789     function ExcludeWalletLimit(address _adr,bool _status) public onlyOwner {
790         require(isWalletLimitExempt[_adr] != _status,"Not Changed!!");
791         isWalletLimitExempt[_adr] = _status;
792     }
793 
794     function ExcludeTxLimit(address _adr,bool _status) public onlyOwner {
795         require(isTxLimitExempt[_adr] != _status,"Not Changed!!");
796         isTxLimitExempt[_adr] = _status;
797     }
798 
799     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
800         minimumTokensBeforeSwap = newLimit;
801     }
802 
803     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
804         _walletMax = newLimit;
805     }
806 
807     function setTxLimit(uint256 newLimit) external onlyOwner() {
808         _maxTxAmount = newLimit;
809     }
810 
811     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
812         swapAndLiquifyEnabled = _enabled;
813         emit SwapAndLiquifyEnabledUpdated(_enabled);
814     }
815 
816     function setMarketPair(address _pair, bool _status) public onlyOwner {
817         isMarketPair[_pair] = _status;
818     }
819 
820     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
821 
822         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
823 
824         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
825 
826         if(newPairAddress == address(0)) //Create If Doesnt exist
827         {
828             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
829                 .createPair(address(this), _uniswapV2Router.WETH());
830         }
831 
832         uniswapPair = newPairAddress; //Set new pair address
833         uniswapV2Router = _uniswapV2Router; //Set new router address
834 
835         isMarketPair[address(uniswapPair)] = true;
836     }
837 
838 }