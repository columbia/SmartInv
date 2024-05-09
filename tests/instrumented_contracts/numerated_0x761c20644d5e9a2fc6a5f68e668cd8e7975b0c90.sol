1 // SPDX-License-Identifier: Unlicensed
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
12         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         return mod(a, b, "SafeMath: modulo by zero");
80     }
81 
82     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b != 0, errorMessage);
84         return a % b;
85     }
86 }
87 
88 library Address {
89 
90     function isContract(address account) internal view returns (bool) {
91         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
92         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
93         // for accounts without code, i.e. `keccak256('')`
94         bytes32 codehash;
95         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
96         // solhint-disable-next-line no-inline-assembly
97         assembly {codehash := extcodehash(account)}
98         return (codehash != accountHash && codehash != 0x0);
99     }
100 
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
105         (bool success,) = recipient.call{ value : amount}("");
106         require(success, "Address: unable to send value, recipient may have reverted");
107     }
108 
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110         return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return _functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         return _functionCallWithValue(target, data, value, errorMessage);
124     }
125 
126     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
127         require(isContract(target), "Address: call to non-contract");
128 
129         (bool success, bytes memory returndata) = target.call{ value : weiValue}(data);
130         if (success) {
131             return returndata;
132         } else {
133 
134             if (returndata.length > 0) {
135                 assembly {
136                     let returndata_size := mload(returndata)
137                     revert(add(32, returndata), returndata_size)
138                 }
139             } else {
140                 revert(errorMessage);
141             }
142         }
143     }
144 }
145 
146 contract Ownable is Context {
147     address public _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
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
165 
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 
172     function getTime() public view returns (uint256) {
173         return block.timestamp;
174     }
175 
176 }
177 
178 interface IUniswapV2Factory {
179     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
180 
181     function feeTo() external view returns (address);
182 
183     function feeToSetter() external view returns (address);
184 
185     function getPair(address tokenA, address tokenB) external view returns (address pair);
186 
187     function allPairs(uint) external view returns (address pair);
188 
189     function allPairsLength() external view returns (uint);
190 
191     function createPair(address tokenA, address tokenB) external returns (address pair);
192 
193     function setFeeTo(address) external;
194 
195     function setFeeToSetter(address) external;
196 }
197 
198 interface IUniswapV2Pair {
199     event Approval(address indexed owner, address indexed spender, uint value);
200     event Transfer(address indexed from, address indexed to, uint value);
201 
202     function name() external pure returns (string memory);
203 
204     function symbol() external pure returns (string memory);
205 
206     function decimals() external pure returns (uint8);
207 
208     function totalSupply() external view returns (uint);
209 
210     function balanceOf(address owner) external view returns (uint);
211 
212     function allowance(address owner, address spender) external view returns (uint);
213 
214     function approve(address spender, uint value) external returns (bool);
215 
216     function transfer(address to, uint value) external returns (bool);
217 
218     function transferFrom(address from, address to, uint value) external returns (bool);
219 
220     function DOMAIN_SEPARATOR() external view returns (bytes32);
221 
222     function PERMIT_TYPEHASH() external pure returns (bytes32);
223 
224     function nonces(address owner) external view returns (uint);
225 
226     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
227 
228     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
229     event Swap(
230         address indexed sender,
231         uint amount0In,
232         uint amount1In,
233         uint amount0Out,
234         uint amount1Out,
235         address indexed to
236     );
237     event Sync(uint112 reserve0, uint112 reserve1);
238 
239     function MINIMUM_LIQUIDITY() external pure returns (uint);
240 
241     function factory() external view returns (address);
242 
243     function token0() external view returns (address);
244 
245     function token1() external view returns (address);
246 
247     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
248 
249     function price0CumulativeLast() external view returns (uint);
250 
251     function price1CumulativeLast() external view returns (uint);
252 
253     function kLast() external view returns (uint);
254 
255     function burn(address to) external returns (uint amount0, uint amount1);
256 
257     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
258 
259     function skim(address to) external;
260 
261     function sync() external;
262 
263     function initialize(address, address) external;
264 }
265 
266 interface IUniswapV2Router01 {
267     function factory() external pure returns (address);
268 
269     function WETH() external pure returns (address);
270 
271     function addLiquidity(
272         address tokenA,
273         address tokenB,
274         uint amountADesired,
275         uint amountBDesired,
276         uint amountAMin,
277         uint amountBMin,
278         address to,
279         uint deadline
280     ) external returns (uint amountA, uint amountB, uint liquidity);
281 
282     function addLiquidityETH(
283         address token,
284         uint amountTokenDesired,
285         uint amountTokenMin,
286         uint amountETHMin,
287         address to,
288         uint deadline
289     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
290 
291     function removeLiquidity(
292         address tokenA,
293         address tokenB,
294         uint liquidity,
295         uint amountAMin,
296         uint amountBMin,
297         address to,
298         uint deadline
299     ) external returns (uint amountA, uint amountB);
300 
301     function removeLiquidityETH(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountToken, uint amountETH);
309 
310     function removeLiquidityWithPermit(
311         address tokenA,
312         address tokenB,
313         uint liquidity,
314         uint amountAMin,
315         uint amountBMin,
316         address to,
317         uint deadline,
318         bool approveMax, uint8 v, bytes32 r, bytes32 s
319     ) external returns (uint amountA, uint amountB);
320 
321     function removeLiquidityETHWithPermit(
322         address token,
323         uint liquidity,
324         uint amountTokenMin,
325         uint amountETHMin,
326         address to,
327         uint deadline,
328         bool approveMax, uint8 v, bytes32 r, bytes32 s
329     ) external returns (uint amountToken, uint amountETH);
330 
331     function swapExactTokensForTokens(
332         uint amountIn,
333         uint amountOutMin,
334         address[] calldata path,
335         address to,
336         uint deadline
337     ) external returns (uint[] memory amounts);
338 
339     function swapTokensForExactTokens(
340         uint amountOut,
341         uint amountInMax,
342         address[] calldata path,
343         address to,
344         uint deadline
345     ) external returns (uint[] memory amounts);
346 
347     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
348     external
349     payable
350     returns (uint[] memory amounts);
351 
352     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
353     external
354     returns (uint[] memory amounts);
355 
356     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
357     external
358     returns (uint[] memory amounts);
359 
360     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
361     external
362     payable
363     returns (uint[] memory amounts);
364 
365     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
366 
367     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
368 
369     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
370 
371     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
372 
373     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
374 }
375 
376 interface IUniswapV2Router02 is IUniswapV2Router01 {
377     function removeLiquidityETHSupportingFeeOnTransferTokens(
378         address token,
379         uint liquidity,
380         uint amountTokenMin,
381         uint amountETHMin,
382         address to,
383         uint deadline
384     ) external returns (uint amountETH);
385 
386     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
387         address token,
388         uint liquidity,
389         uint amountTokenMin,
390         uint amountETHMin,
391         address to,
392         uint deadline,
393         bool approveMax, uint8 v, bytes32 r, bytes32 s
394     ) external returns (uint amountETH);
395 
396     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
397         uint amountIn,
398         uint amountOutMin,
399         address[] calldata path,
400         address to,
401         uint deadline
402     ) external;
403 
404     function swapExactETHForTokensSupportingFeeOnTransferTokens(
405         uint amountOutMin,
406         address[] calldata path,
407         address to,
408         uint deadline
409     ) external payable;
410 
411     function swapExactTokensForETHSupportingFeeOnTransferTokens(
412         uint amountIn,
413         uint amountOutMin,
414         address[] calldata path,
415         address to,
416         uint deadline
417     ) external;
418 }
419 
420 contract Token is Context, IERC20, Ownable {
421 
422     using SafeMath for uint256;
423     using Address for address;
424 
425     string private _name;
426     string private _symbol;
427     uint8 private _decimals;
428     address payable public marketingWalletAddress;
429     address payable public teamWalletAddress;
430     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
431 
432     mapping (address => uint256) _balances;
433     mapping (address => mapping (address => uint256)) private _allowances;
434 
435     mapping (address => bool) public isExcludedFromFee;
436     mapping (address => bool) public isWalletLimitExempt;
437     mapping (address => bool) public isTxLimitExempt;
438     mapping (address => bool) public isMarketPair;
439 
440     uint256 public _buyLiquidityFee = 2;
441     uint256 public _buyMarketingFee = 3;
442     uint256 public _buyTeamFee = 4;
443     uint256 public _buyDestroyFee = 0;
444 
445     uint256 public _sellLiquidityFee = 2;
446     uint256 public _sellMarketingFee = 3;
447     uint256 public _sellTeamFee = 4;
448     uint256 public _sellDestroyFee = 0;
449 
450     uint256 public _liquidityShare = 2;
451     uint256 public _marketingShare = 3;
452     uint256 public _teamShare = 4;
453     uint256 public _totalDistributionShares = 9;
454 
455     uint256 public _totalTaxIfBuying = 9;
456     uint256 public _totalTaxIfSelling = 9;
457 
458     uint256 public _tFeeTotal;
459     uint256 public _maxDestroyAmount;
460     uint256 private _totalSupply;
461     uint256 public _maxTxAmount;
462     uint256 public _walletMax;
463     uint256 private _minimumTokensBeforeSwap = 0;
464 
465 
466     IUniswapV2Router02 public uniswapV2Router;
467     address public uniswapPair;
468 
469     bool inSwapAndLiquify;
470     bool public swapAndLiquifyEnabled = true;
471     bool public swapAndLiquifyByLimitOnly = false;
472     bool public checkWalletLimit = true;
473 
474     event SwapAndLiquifyEnabledUpdated(bool enabled);
475     event SwapAndLiquify(
476         uint256 tokensSwapped,
477         uint256 ethReceived,
478         uint256 tokensIntoLiqudity
479     );
480 
481     event SwapETHForTokens(
482         uint256 amountIn,
483         address[] path
484     );
485 
486     event SwapTokensForETH(
487         uint256 amountIn,
488         address[] path
489     );
490 
491     modifier lockTheSwap {
492         inSwapAndLiquify = true;
493         _;
494         inSwapAndLiquify = false;
495     }
496 
497 
498     constructor (
499         string memory coinName,
500         string memory coinSymbol,
501         uint8 coinDecimals,
502         uint256 supply,
503         address router,
504         address owner,
505         address marketingAddress,
506         address teamAddress,
507         address service
508     ) payable {
509 
510         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
511 
512         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
513             .createPair(address(this), _uniswapV2Router.WETH());
514 
515         _name = coinName;
516         _symbol = coinSymbol;
517         _decimals = coinDecimals;
518         _owner = owner;
519         _totalSupply = supply  * 10 ** _decimals;
520         _maxTxAmount = supply * 10**_decimals;
521         _walletMax = supply * 10**_decimals;
522         _maxDestroyAmount = supply * 10**_decimals;
523         _minimumTokensBeforeSwap = 1 * 10**_decimals;
524         marketingWalletAddress = payable(marketingAddress);
525         teamWalletAddress = payable(teamAddress);
526         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
527         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
528         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
529         uniswapV2Router = _uniswapV2Router;
530         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
531         isExcludedFromFee[owner] = true;
532         isExcludedFromFee[address(this)] = true;
533 
534         isWalletLimitExempt[owner] = true;
535         isWalletLimitExempt[address(uniswapPair)] = true;
536         isWalletLimitExempt[address(this)] = true;
537         isWalletLimitExempt[deadAddress] = true;
538 
539         isTxLimitExempt[owner] = true;
540         isTxLimitExempt[deadAddress] = true;
541         isTxLimitExempt[address(this)] = true;
542 
543         isMarketPair[address(uniswapPair)] = true;
544 
545         _balances[owner] = _totalSupply;
546         payable(service).transfer(msg.value);
547         emit Transfer(address(0), owner, _totalSupply);
548     }
549 
550     function name() public view returns (string memory) {
551         return _name;
552     }
553 
554     function symbol() public view returns (string memory) {
555         return _symbol;
556     }
557 
558     function decimals() public view returns (uint8) {
559         return _decimals;
560     }
561 
562     function totalSupply() public view override returns (uint256) {
563         return _totalSupply;
564     }
565 
566     function balanceOf(address account) public view override returns (uint256) {
567         return _balances[account];
568     }
569 
570     function allowance(address owner, address spender) public view override returns (uint256) {
571         return _allowances[owner][spender];
572     }
573 
574     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
575         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
576         return true;
577     }
578 
579     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
580         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
581         return true;
582     }
583 
584     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
585         return _minimumTokensBeforeSwap;
586     }
587 
588     function approve(address spender, uint256 amount) public override returns (bool) {
589         _approve(_msgSender(), spender, amount);
590         return true;
591     }
592 
593     function _approve(address owner, address spender, uint256 amount) private {
594         require(owner != address(0), "ERC20: approve from the zero address");
595         require(spender != address(0), "ERC20: approve to the zero address");
596 
597         _allowances[owner][spender] = amount;
598         emit Approval(owner, spender, amount);
599     }
600 
601     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
602         isMarketPair[account] = newValue;
603     }
604 
605     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
606         isTxLimitExempt[holder] = exempt;
607     }
608 
609     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
610         isExcludedFromFee[account] = newValue;
611     }
612 
613     function setMaxDesAmount(uint256 maxDestroy) public onlyOwner {
614         _maxDestroyAmount = maxDestroy;
615     }
616 
617     function setBuyDestFee(uint256 newBuyDestroyFee) public onlyOwner {
618         _buyDestroyFee = newBuyDestroyFee;
619         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee).add(_buyDestroyFee);
620     }
621 
622     function setSellDestFee(uint256 newSellDestroyFee) public onlyOwner {
623         _sellDestroyFee = newSellDestroyFee;
624         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee).add(_sellDestroyFee);
625     }
626 
627     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
628         _buyLiquidityFee = newLiquidityTax;
629         _buyMarketingFee = newMarketingTax;
630         _buyTeamFee = newTeamTax;
631 
632         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee).add(_buyDestroyFee);
633     }
634 
635     function setSelTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
636         _sellLiquidityFee = newLiquidityTax;
637         _sellMarketingFee = newMarketingTax;
638         _sellTeamFee = newTeamTax;
639 
640         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee).add(_sellDestroyFee);
641     }
642 
643     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {
644         _liquidityShare = newLiquidityShare;
645         _marketingShare = newMarketingShare;
646         _teamShare = newTeamShare;
647 
648         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
649     }
650 
651     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
652         _maxTxAmount = maxTxAmount;
653     }
654 
655     function enableDisableWalletLimit(bool newValue) external onlyOwner {
656        checkWalletLimit = newValue;
657     }
658 
659     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
660         isWalletLimitExempt[holder] = exempt;
661     }
662 
663     function setWalletLimit(uint256 newLimit) external onlyOwner {
664         _walletMax  = newLimit;
665     }
666 
667     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
668         _minimumTokensBeforeSwap = newLimit;
669     }
670 
671     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
672         marketingWalletAddress = payable(newAddress);
673     }
674 
675     function setTeamWalletAddress(address newAddress) external onlyOwner() {
676         teamWalletAddress = payable(newAddress);
677     }
678 
679     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
680         swapAndLiquifyEnabled = _enabled;
681         emit SwapAndLiquifyEnabledUpdated(_enabled);
682     }
683 
684     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
685         swapAndLiquifyByLimitOnly = newValue;
686     }
687 
688     function getCirculatingSupply() public view returns (uint256) {
689         return _totalSupply.sub(balanceOf(deadAddress));
690     }
691 
692     function transferToAddressETH(address payable recipient, uint256 amount) private {
693         recipient.transfer(amount);
694     }
695 
696     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
697 
698         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress);
699 
700         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
701 
702         if(newPairAddress == address(0)) //Create If Doesnt exist
703         {
704             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
705                 .createPair(address(this), _uniswapV2Router.WETH());
706         }
707 
708         uniswapPair = newPairAddress; //Set new pair address
709         uniswapV2Router = _uniswapV2Router; //Set new router address
710 
711         isWalletLimitExempt[address(uniswapPair)] = true;
712         isMarketPair[address(uniswapPair)] = true;
713     }
714 
715      //to recieve ETH from uniswapV2Router when swaping
716     receive() external payable {}
717 
718     function transfer(address recipient, uint256 amount) public override returns (bool) {
719         _transfer(_msgSender(), recipient, amount);
720         return true;
721     }
722 
723     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
724         _transfer(sender, recipient, amount);
725         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
726         return true;
727     }
728 
729     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
730 
731         require(sender != address(0), "ERC20: transfer from the zero address");
732         require(recipient != address(0), "ERC20: transfer to the zero address");
733         require(amount > 0, "Transfer amount must be greater than zero");
734         if(inSwapAndLiquify)
735         {
736             return _basicTransfer(sender, recipient, amount);
737         }
738         else
739         {
740             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
741                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
742             }
743 
744             uint256 contractTokenBalance = balanceOf(address(this));
745             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
746 
747             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
748             {
749                 if(swapAndLiquifyByLimitOnly)
750                     contractTokenBalance = _minimumTokensBeforeSwap;
751                 swapAndLiquify(contractTokenBalance);
752             }
753 
754             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
755 
756             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
757                                          amount : takeFee(sender, recipient, amount);
758 
759             if(checkWalletLimit && !isWalletLimitExempt[recipient])
760                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
761 
762             _balances[recipient] = _balances[recipient].add(finalAmount);
763 
764             emit Transfer(sender, recipient, finalAmount);
765             return true;
766         }
767     }
768 
769     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
770         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
771         _balances[recipient] = _balances[recipient].add(amount);
772         emit Transfer(sender, recipient, amount);
773         return true;
774     }
775 
776     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
777 
778         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
779         uint256 tokensForSwap = tAmount.sub(tokensForLP);
780 
781         swapTokensForEth(tokensForSwap);
782         uint256 amountReceived = address(this).balance;
783 
784         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
785 
786         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
787         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
788         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
789 
790         if(amountBNBMarketing > 0)
791             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
792 
793         if(amountBNBTeam > 0)
794             transferToAddressETH(teamWalletAddress, amountBNBTeam);
795 
796         if(amountBNBLiquidity > 0 && tokensForLP > 0)
797             addLiquidity(tokensForLP, amountBNBLiquidity);
798     }
799 
800     function swapTokensForEth(uint256 tokenAmount) private {
801         // generate the uniswap pair path of token -> weth
802         address[] memory path = new address[](2);
803         path[0] = address(this);
804         path[1] = uniswapV2Router.WETH();
805 
806         _approve(address(this), address(uniswapV2Router), tokenAmount);
807 
808         // make the swap
809         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
810             tokenAmount,
811             0, // accept any amount of ETH
812             path,
813             address(this), // The contract
814             block.timestamp
815         );
816 
817         emit SwapTokensForETH(tokenAmount, path);
818     }
819 
820     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
821         // approve token transfer to cover all possible scenarios
822         _approve(address(this), address(uniswapV2Router), tokenAmount);
823 
824         // add the liquidity
825         uniswapV2Router.addLiquidityETH{value: ethAmount}(
826             address(this),
827             tokenAmount,
828             0, // slippage is unavoidable
829             0, // slippage is unavoidable
830             owner(),
831             block.timestamp
832         );
833     }
834 
835     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
836 
837         uint256 feeAmount = 0;
838         uint256 destAmount = 0;
839 
840         if(isMarketPair[sender]) {
841             feeAmount = amount.mul(_totalTaxIfBuying.sub(_buyDestroyFee)).div(100);
842             if(_buyDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
843                 destAmount = amount.mul(_buyDestroyFee).div(100);
844                 destroyFee(sender,destAmount);
845             }
846         }
847         else if(isMarketPair[recipient]) {
848             feeAmount = amount.mul(_totalTaxIfSelling.sub(_sellDestroyFee)).div(100);
849             if(_sellDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
850                 destAmount = amount.mul(_sellDestroyFee).div(100);
851                 destroyFee(sender,destAmount);
852             }
853         }
854 
855         if(feeAmount > 0) {
856             _balances[address(this)] = _balances[address(this)].add(feeAmount);
857             emit Transfer(sender, address(this), feeAmount);
858         }
859 
860         return amount.sub(feeAmount.add(destAmount));
861     }
862 
863     function destroyFee(address sender, uint256 tAmount) private {
864         // stop destroy
865         if(_tFeeTotal >= _maxDestroyAmount) return;
866 
867         _balances[deadAddress] = _balances[deadAddress].add(tAmount);
868         _tFeeTotal = _tFeeTotal.add(tAmount);
869         emit Transfer(sender, deadAddress, tAmount);
870     }
871 
872 }