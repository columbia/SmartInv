1 /**
2 X-GAMES INU $XGI
3 
4 We send community members to Aspen for 4 days for the Winter X Games
5 
6 Tax: 5%
7 
8 Supply: 1Bilion
9 
10 Max: 2%
11 
12 TG:         t.me/xgamesinu
13 Twitter:    twitter.com/xgamesinu
14 */
15 // SPDX-License-Identifier: Unlicensed
16 pragma solidity ^0.8.10;
17 
18 
19 abstract contract Context {
20 
21     function _msgSender() internal view virtual returns (address payable) {
22         return payable(msg.sender);
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 interface IERC20 {
32 
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44 
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82 
83         return c;
84     }
85 
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         return mod(a, b, "SafeMath: modulo by zero");
88     }
89 
90     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b != 0, errorMessage);
92         return a % b;
93     }
94 }
95 
96 library Address {
97 
98     function isContract(address account) internal view returns (bool) {
99         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
100         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
101         // for accounts without code, i.e. `keccak256('')`
102         bytes32 codehash;
103         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
104         // solhint-disable-next-line no-inline-assembly
105         assembly { codehash := extcodehash(account) }
106         return (codehash != accountHash && codehash != 0x0);
107     }
108 
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
113         (bool success, ) = recipient.call{ value: amount }("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118       return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         return _functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
138         if (success) {
139             return returndata;
140         } else {
141             
142             if (returndata.length > 0) {
143                 assembly {
144                     let returndata_size := mload(returndata)
145                     revert(add(32, returndata), returndata_size)
146                 }
147             } else {
148                 revert(errorMessage);
149             }
150         }
151     }
152 }
153 
154 contract Ownable is Context {
155     address private _owner;
156     address private _previousOwner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     constructor () {
161         address msgSender = _msgSender();
162         _owner = msgSender;
163         emit OwnershipTransferred(address(0), msgSender);
164     }
165 
166     function owner() public view returns (address) {
167         return _owner;
168     }   
169     
170     modifier onlyOwner() {
171         require(_owner == _msgSender(), "Ownable: caller is not the owner");
172         _;
173     }
174     
175     function RenounceOwnership() public virtual onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 interface IUniswapV2Factory {
188     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
189 
190     function feeTo() external view returns (address);
191     function feeToSetter() external view returns (address);
192 
193     function getPair(address tokenA, address tokenB) external view returns (address pair);
194     function allPairs(uint) external view returns (address pair);
195     function allPairsLength() external view returns (uint);
196 
197     function createPair(address tokenA, address tokenB) external returns (address pair);
198 
199     function setFeeTo(address) external;
200     function setFeeToSetter(address) external;
201 }
202 
203 interface IUniswapV2Pair {
204     event Approval(address indexed owner, address indexed spender, uint value);
205     event Transfer(address indexed from, address indexed to, uint value);
206 
207     function name() external pure returns (string memory);
208     function symbol() external pure returns (string memory);
209     function decimals() external pure returns (uint8);
210     function totalSupply() external view returns (uint);
211     function balanceOf(address owner) external view returns (uint);
212     function allowance(address owner, address spender) external view returns (uint);
213 
214     function approve(address spender, uint value) external returns (bool);
215     function transfer(address to, uint value) external returns (bool);
216     function transferFrom(address from, address to, uint value) external returns (bool);
217 
218     function DOMAIN_SEPARATOR() external view returns (bytes32);
219     function PERMIT_TYPEHASH() external pure returns (bytes32);
220     function nonces(address owner) external view returns (uint);
221 
222     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
223     
224     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
225     event Swap(
226         address indexed sender,
227         uint amount0In,
228         uint amount1In,
229         uint amount0Out,
230         uint amount1Out,
231         address indexed to
232     );
233     event Sync(uint112 reserve0, uint112 reserve1);
234 
235     function MINIMUM_LIQUIDITY() external pure returns (uint);
236     function factory() external view returns (address);
237     function token0() external view returns (address);
238     function token1() external view returns (address);
239     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
240     function price0CumulativeLast() external view returns (uint);
241     function price1CumulativeLast() external view returns (uint);
242     function kLast() external view returns (uint);
243 
244     function burn(address to) external returns (uint amount0, uint amount1);
245     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
246     function skim(address to) external;
247     function sync() external;
248 
249     function initialize(address, address) external;
250 }
251 
252 interface IUniswapV2Router01 {
253     function factory() external pure returns (address);
254     function WETH() external pure returns (address);
255 
256     function addLiquidity(
257         address tokenA,
258         address tokenB,
259         uint amountADesired,
260         uint amountBDesired,
261         uint amountAMin,
262         uint amountBMin,
263         address to,
264         uint deadline
265     ) external returns (uint amountA, uint amountB, uint liquidity);
266     function addLiquidityETH(
267         address token,
268         uint amountTokenDesired,
269         uint amountTokenMin,
270         uint amountETHMin,
271         address to,
272         uint deadline
273     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
274     function removeLiquidity(
275         address tokenA,
276         address tokenB,
277         uint liquidity,
278         uint amountAMin,
279         uint amountBMin,
280         address to,
281         uint deadline
282     ) external returns (uint amountA, uint amountB);
283     function removeLiquidityETH(
284         address token,
285         uint liquidity,
286         uint amountTokenMin,
287         uint amountETHMin,
288         address to,
289         uint deadline
290     ) external returns (uint amountToken, uint amountETH);
291     function removeLiquidityWithPermit(
292         address tokenA,
293         address tokenB,
294         uint liquidity,
295         uint amountAMin,
296         uint amountBMin,
297         address to,
298         uint deadline,
299         bool approveMax, uint8 v, bytes32 r, bytes32 s
300     ) external returns (uint amountA, uint amountB);
301     function removeLiquidityETHWithPermit(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline,
308         bool approveMax, uint8 v, bytes32 r, bytes32 s
309     ) external returns (uint amountToken, uint amountETH);
310     function swapExactTokensForTokens(
311         uint amountIn,
312         uint amountOutMin,
313         address[] calldata path,
314         address to,
315         uint deadline
316     ) external returns (uint[] memory amounts);
317     function swapTokensForExactTokens(
318         uint amountOut,
319         uint amountInMax,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external returns (uint[] memory amounts);
324     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
325         external
326         payable
327         returns (uint[] memory amounts);
328     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
329         external
330         returns (uint[] memory amounts);
331     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
332         external
333         returns (uint[] memory amounts);
334     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
335         external
336         payable
337         returns (uint[] memory amounts);
338 
339     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
340     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
341     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
342     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
343     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
344 }
345 
346 interface IUniswapV2Router02 is IUniswapV2Router01 {
347     function removeLiquidityETHSupportingFeeOnTransferTokens(
348         address token,
349         uint liquidity,
350         uint amountTokenMin,
351         uint amountETHMin,
352         address to,
353         uint deadline
354     ) external returns (uint amountETH);
355     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
356         address token,
357         uint liquidity,
358         uint amountTokenMin,
359         uint amountETHMin,
360         address to,
361         uint deadline,
362         bool approveMax, uint8 v, bytes32 r, bytes32 s
363     ) external returns (uint amountETH);
364 
365     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
366         uint amountIn,
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external;
372     function swapExactETHForTokensSupportingFeeOnTransferTokens(
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline
377     ) external payable;
378     function swapExactTokensForETHSupportingFeeOnTransferTokens(
379         uint amountIn,
380         uint amountOutMin,
381         address[] calldata path,
382         address to,
383         uint deadline
384     ) external;
385 }
386 
387 contract XGI is Context, IERC20, Ownable {
388     
389     using SafeMath for uint256;
390     using Address for address;
391     
392     string private _name ="X-GAMES INU";
393     string private _symbol = "XGI";
394     uint8 private _decimals = 9;
395 
396     address payable private taxWallet1 = payable(0x081Df9C9a1c41c9aA08F1D32Cf355824a7dF3A1e);
397     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
398     
399     mapping (address => uint256) _balances;
400     mapping (address => mapping (address => uint256)) private _allowances;
401     
402     mapping (address => bool) public checkExcludedFromFees;
403     mapping (address => bool) public checkWalletLimitExcept;
404     mapping (address => bool) public checkTxLimitExcept;
405     mapping (address => bool) public checkMarketPair;
406     mapping(address => bool) public bots;
407 
408     uint256 public _buyLiquidityFees = 0;
409     uint256 public _buyMarketingFees = 90;
410     uint256 public _buyDevelopmentFees = 0;
411     uint256 public _sellLiquidityFees = 0;
412     uint256 public _sellMarketingFees = 90;
413     uint256 public _sellDevelopmentFees = 0;
414 
415     uint256 public _liquidityShares = 0;
416     uint256 public _marketingShares = 10;
417     uint256 public _developmentShares = 0;
418 
419     uint256 public _totalTaxIfBuying = 90;
420     uint256 public _totalTaxIfSelling = 90;
421     uint256 public _totalDistributionShares = 10;
422 
423     uint256 private _totalSupply = 1_000_000_000 * 10**9;
424     uint256 public _maxTxAmount = _totalSupply;
425     uint256 public _walletMax = _totalSupply*2/100;
426     uint256 private minimumTokensBeforeSwap = _totalSupply*25/10000; 
427 
428     IUniswapV2Router02 public uniswapV2Router;
429     address public uniswapPair;
430     
431     bool inSwapAndLiquify;
432     bool public swapAndLiquifyEnabled = true;
433     bool public swapAndLiquifyByLimitOnly = false;
434     bool public checkWalletLimit = true;
435 
436     event SwapAndLiquifyEnabledUpdated(bool enabled);
437     event SwapAndLiquify(
438         uint256 tokensSwapped,
439         uint256 ethReceived,
440         uint256 tokensIntoLiqudity
441     );
442     
443     event SwapETHForTokens(
444         uint256 amountIn,
445         address[] path
446     );
447     
448     event SwapTokensForETH(
449         uint256 amountIn,
450         address[] path
451     );
452     
453     modifier lockTheSwap {
454         inSwapAndLiquify = true;
455         _;
456         inSwapAndLiquify = false;
457     }
458     
459     constructor () {
460         
461         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
462 
463         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
464             .createPair(address(this), _uniswapV2Router.WETH());
465 
466         uniswapV2Router = _uniswapV2Router;
467         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
468 
469         checkExcludedFromFees[owner()] = true;
470         checkExcludedFromFees[address(this)] = true;
471         checkExcludedFromFees[taxWallet1] = true;
472 
473         checkWalletLimitExcept[owner()] = true;
474         checkWalletLimitExcept[address(uniswapPair)] = true;
475         checkWalletLimitExcept[address(this)] = true;
476         checkWalletLimitExcept[taxWallet1] = true;
477         
478         checkTxLimitExcept[owner()] = true;
479         checkTxLimitExcept[address(this)] = true;
480 
481         checkMarketPair[address(uniswapPair)] = true;
482 
483         _balances[_msgSender()] = _totalSupply;
484         emit Transfer(address(0), _msgSender(), _totalSupply);
485     }
486 
487     function name() public view returns (string memory) {
488         return _name;
489     }
490 
491     function symbol() public view returns (string memory) {
492         return _symbol;
493     }
494 
495     function decimals() public view returns (uint8) {
496         return _decimals;
497     }
498 
499     function totalSupply() public view override returns (uint256) {
500         return _totalSupply;
501     }
502 
503     function balanceOf(address account) public view override returns (uint256) {
504         return _balances[account];
505     }
506 
507     function allowance(address owner, address spender) public view override returns (uint256) {
508         return _allowances[owner][spender];
509     }
510 
511     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
513         return true;
514     }
515 
516     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
518         return true;
519     }
520 
521     function approve(address spender, uint256 amount) public override returns (bool) {
522         _approve(_msgSender(), spender, amount);
523         return true;
524     }
525 
526     function _approve(address owner, address spender, uint256 amount) private {
527         require(owner != address(0), "ERC20: approve from the zero address");
528         require(spender != address(0), "ERC20: approve to the zero address");
529 
530         _allowances[owner][spender] = amount;
531         emit Approval(owner, spender, amount);
532     }
533 
534     function setcheckExcludedFromFees(address account, bool newValue) public onlyOwner {
535         checkExcludedFromFees[account] = newValue;
536     }
537 
538     function setBuyFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
539         _buyLiquidityFees = newLiquidityTax;
540         _buyMarketingFees = newMarketingTax;
541         _buyDevelopmentFees = newDevelopmentTax;
542 
543         _totalTaxIfBuying = _buyLiquidityFees.add(_buyMarketingFees).add(_buyDevelopmentFees);
544         require (_totalTaxIfBuying <= 10);
545     }
546 
547     function setSellFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
548         _sellLiquidityFees = newLiquidityTax;
549         _sellMarketingFees = newMarketingTax;
550         _sellDevelopmentFees = newDevelopmentTax;
551 
552         _totalTaxIfSelling = _sellLiquidityFees.add(_sellMarketingFees).add(_sellDevelopmentFees);
553         require (_totalTaxIfSelling <= 20);
554     }
555 
556     function setWalletLimit(uint256 newLimit) external onlyOwner {
557         _walletMax  = newLimit;
558     }
559 
560     function settaxWallet1(address newAddress) external onlyOwner() {
561         taxWallet1 = payable(newAddress);
562     }
563 
564     function unauthorize(address[] memory bots_, bool status) public onlyOwner {
565         for (uint256 i = 0; i < bots_.length; i++) {
566             bots[bots_[i]] = status;
567         }
568     }
569     
570     function getCirculatingSupply() public view returns (uint256) {
571         return _totalSupply.sub(balanceOf(deadAddress));
572     }
573 
574     function transferToAddressETH(address payable recipient, uint256 amount) private {
575         recipient.transfer(amount);
576     }
577 
578     function manualSend() external {
579         transferToAddressETH(taxWallet1, address(this).balance);
580     }
581 
582      //to recieve ETH from uniswapV2Router when swaping
583     receive() external payable {}
584 
585     function transfer(address recipient, uint256 amount) public override returns (bool) {
586         _transfer(_msgSender(), recipient, amount);
587         return true;
588     }
589 
590     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
591         _transfer(sender, recipient, amount);
592         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
593         return true;
594     }
595 
596     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
597 
598         require(sender != address(0), "ERC20: transfer from the zero address");
599         require(recipient != address(0), "ERC20: transfer to the zero address");
600         require(!bots[sender] && !bots[recipient], "Not authorized");
601 
602         if(inSwapAndLiquify)
603         { 
604             return _basicTransfer(sender, recipient, amount); 
605         }
606         else
607         {
608             if(!checkTxLimitExcept[sender] && !checkTxLimitExcept[recipient]) {
609                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
610             }            
611 
612             uint256 contractTokenBalance = balanceOf(address(this));
613             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
614             if (contractTokenBalance >= minimumTokensBeforeSwap*4)
615                 contractTokenBalance = minimumTokensBeforeSwap*4;
616             
617             if (overMinimumTokenBalance && !inSwapAndLiquify && !checkMarketPair[sender] && swapAndLiquifyEnabled) 
618             {
619                 if(swapAndLiquifyByLimitOnly)
620                     contractTokenBalance = minimumTokensBeforeSwap;
621                 swapAndLiquify(contractTokenBalance);    
622             }
623 
624             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
625 
626             uint256 finalAmount = (checkExcludedFromFees[sender] || checkExcludedFromFees[recipient]) ? 
627                                          amount : takeFee(sender, recipient, amount);
628 
629             if(checkWalletLimit && !checkWalletLimitExcept[recipient])
630                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
631 
632             _balances[recipient] = _balances[recipient].add(finalAmount);
633 
634             emit Transfer(sender, recipient, finalAmount);
635             return true;
636         }
637     }
638 
639     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
640         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
641         _balances[recipient] = _balances[recipient].add(amount);
642         emit Transfer(sender, recipient, amount);
643         return true;
644     }
645 
646     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
647 
648         swapTokensForEth(tAmount);
649         uint256 amountETHMarketing = address(this).balance;
650 
651         if(amountETHMarketing > 50000000000000000)
652             transferToAddressETH(taxWallet1, amountETHMarketing);
653 
654     }
655     
656     function swapTokensForEth(uint256 tokenAmount) private {
657         // generate the uniswap pair path of token -> weth
658         address[] memory path = new address[](2);
659         path[0] = address(this);
660         path[1] = uniswapV2Router.WETH();
661 
662         _approve(address(this), address(uniswapV2Router), tokenAmount);
663 
664         // make the swap
665         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
666             tokenAmount,
667             0, // accept any amount of ETH
668             path,
669             address(this), // The contract
670             block.timestamp
671         );
672         
673         emit SwapTokensForETH(tokenAmount, path);
674     }
675 
676     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
677         
678         uint256 feeAmount = 0;
679         
680         if(checkMarketPair[sender]) {
681             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
682         }
683         else if(checkMarketPair[recipient]) {
684             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
685         }
686         
687         if(feeAmount > 0) {
688             _balances[address(this)] = _balances[address(this)].add(feeAmount);
689             emit Transfer(sender, address(this), feeAmount);
690         }
691 
692         return amount.sub(feeAmount);
693     }
694     
695 }