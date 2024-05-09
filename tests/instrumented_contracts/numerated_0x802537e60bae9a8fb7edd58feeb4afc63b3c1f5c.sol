1 //EVERLINK 2021
2 
3 
4 // SPDX-License-Identifier: Unlicensed
5 
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return payable(msg.sender);
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 interface IERC20 {
22 
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32 }
33 
34 library SafeMath {
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61 
62         return c;
63     }
64 
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
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly { codehash := extcodehash(account) }
95         return (codehash != accountHash && codehash != 0x0);
96     }
97 
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success, ) = recipient.call{ value: amount }("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106 
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108       return functionCall(target, data, "Address: low-level call failed");
109     }
110 
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return _functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         return _functionCallWithValue(target, data, value, errorMessage);
122     }
123 
124     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
125         require(isContract(target), "Address: call to non-contract");
126 
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131 
132             if (returndata.length > 0) {
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143 
144 contract Ownable is Context {
145     address private _owner;
146     address private _previousOwner;
147     uint256 private _lockTime;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     constructor () {
152         address msgSender = _msgSender();
153         _owner = msgSender;
154         emit OwnershipTransferred(address(0), msgSender);
155     }
156 
157     function owner() public view returns (address) {
158         return _owner;
159     }
160 
161     modifier onlyOwner() {
162         require(_owner == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 
177     function getUnlockTime() public view returns (uint256) {
178         return _lockTime;
179     }
180 
181     function getTime() public view returns (uint256) {
182         return block.timestamp;
183     }
184 
185     function lock(uint256 time) public virtual onlyOwner {
186         _previousOwner = _owner;
187         _owner = address(0);
188         _lockTime = block.timestamp + time;
189         emit OwnershipTransferred(_owner, address(0));
190     }
191 
192     function unlock() public virtual {
193         require(_previousOwner == msg.sender, "You don't have permission to unlock");
194         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
195         emit OwnershipTransferred(_owner, _previousOwner);
196         _owner = _previousOwner;
197     }
198 }
199 
200 // pragma solidity >=0.5.0;
201 
202 interface IUniswapV2Factory {
203     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
204 
205     function feeTo() external view returns (address);
206     function feeToSetter() external view returns (address);
207 
208     function getPair(address tokenA, address tokenB) external view returns (address pair);
209     function allPairs(uint) external view returns (address pair);
210     function allPairsLength() external view returns (uint);
211 
212     function createPair(address tokenA, address tokenB) external returns (address pair);
213 
214     function setFeeTo(address) external;
215     function setFeeToSetter(address) external;
216 }
217 
218 
219 // pragma solidity >=0.5.0;
220 
221 interface IUniswapV2Pair {
222     event Approval(address indexed owner, address indexed spender, uint value);
223     event Transfer(address indexed from, address indexed to, uint value);
224 
225     function name() external pure returns (string memory);
226     function symbol() external pure returns (string memory);
227     function decimals() external pure returns (uint8);
228     function totalSupply() external view returns (uint);
229     function balanceOf(address owner) external view returns (uint);
230     function allowance(address owner, address spender) external view returns (uint);
231 
232     function approve(address spender, uint value) external returns (bool);
233     function transfer(address to, uint value) external returns (bool);
234     function transferFrom(address from, address to, uint value) external returns (bool);
235 
236     function DOMAIN_SEPARATOR() external view returns (bytes32);
237     function PERMIT_TYPEHASH() external pure returns (bytes32);
238     function nonces(address owner) external view returns (uint);
239 
240     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
241 
242     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
243     event Swap(
244         address indexed sender,
245         uint amount0In,
246         uint amount1In,
247         uint amount0Out,
248         uint amount1Out,
249         address indexed to
250     );
251     event Sync(uint112 reserve0, uint112 reserve1);
252 
253     function MINIMUM_LIQUIDITY() external pure returns (uint);
254     function factory() external view returns (address);
255     function token0() external view returns (address);
256     function token1() external view returns (address);
257     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
258     function price0CumulativeLast() external view returns (uint);
259     function price1CumulativeLast() external view returns (uint);
260     function kLast() external view returns (uint);
261 
262     function burn(address to) external returns (uint amount0, uint amount1);
263     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
264     function skim(address to) external;
265     function sync() external;
266 
267     function initialize(address, address) external;
268 }
269 
270 // pragma solidity >=0.6.2;
271 
272 interface IUniswapV2Router01 {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function addLiquidity(
277         address tokenA,
278         address tokenB,
279         uint amountADesired,
280         uint amountBDesired,
281         uint amountAMin,
282         uint amountBMin,
283         address to,
284         uint deadline
285     ) external returns (uint amountA, uint amountB, uint liquidity);
286     function addLiquidityETH(
287         address token,
288         uint amountTokenDesired,
289         uint amountTokenMin,
290         uint amountETHMin,
291         address to,
292         uint deadline
293     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
294     function removeLiquidity(
295         address tokenA,
296         address tokenB,
297         uint liquidity,
298         uint amountAMin,
299         uint amountBMin,
300         address to,
301         uint deadline
302     ) external returns (uint amountA, uint amountB);
303     function removeLiquidityETH(
304         address token,
305         uint liquidity,
306         uint amountTokenMin,
307         uint amountETHMin,
308         address to,
309         uint deadline
310     ) external returns (uint amountToken, uint amountETH);
311     function removeLiquidityWithPermit(
312         address tokenA,
313         address tokenB,
314         uint liquidity,
315         uint amountAMin,
316         uint amountBMin,
317         address to,
318         uint deadline,
319         bool approveMax, uint8 v, bytes32 r, bytes32 s
320     ) external returns (uint amountA, uint amountB);
321     function removeLiquidityETHWithPermit(
322         address token,
323         uint liquidity,
324         uint amountTokenMin,
325         uint amountETHMin,
326         address to,
327         uint deadline,
328         bool approveMax, uint8 v, bytes32 r, bytes32 s
329     ) external returns (uint amountToken, uint amountETH);
330     function swapExactTokensForTokens(
331         uint amountIn,
332         uint amountOutMin,
333         address[] calldata path,
334         address to,
335         uint deadline
336     ) external returns (uint[] memory amounts);
337     function swapTokensForExactTokens(
338         uint amountOut,
339         uint amountInMax,
340         address[] calldata path,
341         address to,
342         uint deadline
343     ) external returns (uint[] memory amounts);
344     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
345         external
346         payable
347         returns (uint[] memory amounts);
348     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
349         external
350         returns (uint[] memory amounts);
351     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
352         external
353         returns (uint[] memory amounts);
354     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
355         external
356         payable
357         returns (uint[] memory amounts);
358 
359     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
360     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
361     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
362     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
363     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
364 }
365 
366 
367 
368 // pragma solidity >=0.6.2;
369 
370 interface IUniswapV2Router02 is IUniswapV2Router01 {
371     function removeLiquidityETHSupportingFeeOnTransferTokens(
372         address token,
373         uint liquidity,
374         uint amountTokenMin,
375         uint amountETHMin,
376         address to,
377         uint deadline
378     ) external returns (uint amountETH);
379     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
380         address token,
381         uint liquidity,
382         uint amountTokenMin,
383         uint amountETHMin,
384         address to,
385         uint deadline,
386         bool approveMax, uint8 v, bytes32 r, bytes32 s
387     ) external returns (uint amountETH);
388 
389     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
390         uint amountIn,
391         uint amountOutMin,
392         address[] calldata path,
393         address to,
394         uint deadline
395     ) external;
396     function swapExactETHForTokensSupportingFeeOnTransferTokens(
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external payable;
402     function swapExactTokensForETHSupportingFeeOnTransferTokens(
403         uint amountIn,
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline
408     ) external;
409 }
410 
411 contract EverLink is Context, IERC20, Ownable {
412     using SafeMath for uint256;
413     using Address for address;
414 
415     address payable public marketingAddress = payable(0xBEf66BefEbF1E7d61b5e1E347E522c9424e1b6EF); // Marketing Address
416     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
417     mapping (address => uint256) private _rOwned;
418     mapping (address => uint256) private _tOwned;
419     mapping (address => mapping (address => uint256)) private _allowances;
420     mapping (address => bool) private bots;
421 
422     mapping (address => bool) private _isExcludedFromFee;
423 
424     mapping (address => bool) private _isExcluded;
425     address[] private _excluded;
426 
427     uint256 private constant MAX = ~uint256(0);
428     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
429     uint256 private _rTotal = (MAX - (MAX % _tTotal));
430     uint256 private _tFeeTotal;
431 
432 
433 
434     string private _name = "EverLink";
435     string private _symbol = "eLink";
436     uint8 private _decimals = 9;
437 
438 
439     uint256 public _taxFee = 2;
440     uint256 private _previousTaxFee = _taxFee;
441 
442     uint256 public _liquidityFee = 9;
443     uint256 private _previousLiquidityFee = _liquidityFee;
444 
445     uint256 public marketingDivisor = 3;
446 
447     uint256 public _maxTxAmount = 3000000 * 10**6 * 10**9;
448     uint256 private minimumTokensBeforeSwap = 200000 * 10**6 * 10**9;
449     uint256 private buyBackUpperLimit = 1 * 10**18;
450 
451     IUniswapV2Router02 public immutable uniswapV2Router;
452     address public immutable uniswapV2Pair;
453 
454     bool inSwapAndLiquify;
455     bool public swapAndLiquifyEnabled = false;
456     bool public buyBackEnabled = true;
457 
458 
459     event RewardLiquidityProviders(uint256 tokenAmount);
460     event BuyBackEnabledUpdated(bool enabled);
461     event SwapAndLiquifyEnabledUpdated(bool enabled);
462     event SwapAndLiquify(
463         uint256 tokensSwapped,
464         uint256 ethReceived,
465         uint256 tokensIntoLiqudity
466     );
467 
468     event SwapETHForTokens(
469         uint256 amountIn,
470         address[] path
471     );
472 
473     event SwapTokensForETH(
474         uint256 amountIn,
475         address[] path
476     );
477 
478     modifier lockTheSwap {
479         inSwapAndLiquify = true;
480         _;
481         inSwapAndLiquify = false;
482     }
483 
484     constructor () {
485         _rOwned[_msgSender()] = _rTotal;
486 
487         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
488         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
489             .createPair(address(this), _uniswapV2Router.WETH());
490 
491         uniswapV2Router = _uniswapV2Router;
492 
493 
494         _isExcludedFromFee[owner()] = true;
495         _isExcludedFromFee[address(this)] = true;
496 
497         emit Transfer(address(0), _msgSender(), _tTotal);
498     }
499 
500     function setBots(address[] memory bots_) public onlyOwner {
501         for (uint i = 0; i < bots_.length; i++) {
502             bots[bots_[i]] = true;
503         }
504     }
505 
506     function delBot(address notbot) public onlyOwner {
507         bots[notbot] = false;
508     }
509 
510 
511     function name() public view returns (string memory) {
512         return _name;
513     }
514 
515 
516     function symbol() public view returns (string memory) {
517         return _symbol;
518     }
519 
520     function decimals() public view returns (uint8) {
521         return _decimals;
522     }
523 
524     function totalSupply() public view override returns (uint256) {
525         return _tTotal;
526     }
527 
528     function balanceOf(address account) public view override returns (uint256) {
529         if (_isExcluded[account]) return _tOwned[account];
530         return tokenFromReflection(_rOwned[account]);
531     }
532 
533     function transfer(address recipient, uint256 amount) public override returns (bool) {
534         _transfer(_msgSender(), recipient, amount);
535         return true;
536     }
537 
538     function allowance(address owner, address spender) public view override returns (uint256) {
539         return _allowances[owner][spender];
540     }
541 
542     function approve(address spender, uint256 amount) public override returns (bool) {
543         _approve(_msgSender(), spender, amount);
544         return true;
545     }
546 
547     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
548         _transfer(sender, recipient, amount);
549         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
550         return true;
551     }
552 
553     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
554         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
555         return true;
556     }
557 
558     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
559         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
560         return true;
561     }
562 
563     function isExcludedFromReward(address account) public view returns (bool) {
564         return _isExcluded[account];
565     }
566 
567     function totalFees() public view returns (uint256) {
568         return _tFeeTotal;
569     }
570 
571     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
572         return minimumTokensBeforeSwap;
573     }
574 
575     function buyBackUpperLimitAmount() public view returns (uint256) {
576         return buyBackUpperLimit;
577     }
578 
579     function deliver(uint256 tAmount) public {
580         address sender = _msgSender();
581         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
582         (uint256 rAmount,,,,,) = _getValues(tAmount);
583         _rOwned[sender] = _rOwned[sender].sub(rAmount);
584         _rTotal = _rTotal.sub(rAmount);
585         _tFeeTotal = _tFeeTotal.add(tAmount);
586     }
587 
588 
589     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
590         require(tAmount <= _tTotal, "Amount must be less than supply");
591         if (!deductTransferFee) {
592             (uint256 rAmount,,,,,) = _getValues(tAmount);
593             return rAmount;
594         } else {
595             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
596             return rTransferAmount;
597         }
598     }
599 
600     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
601         require(rAmount <= _rTotal, "Amount must be less than total reflections");
602         uint256 currentRate =  _getRate();
603         return rAmount.div(currentRate);
604     }
605 
606     function excludeFromReward(address account) public onlyOwner() {
607 
608         require(!_isExcluded[account], "Account is already excluded");
609         if(_rOwned[account] > 0) {
610             _tOwned[account] = tokenFromReflection(_rOwned[account]);
611         }
612         _isExcluded[account] = true;
613         _excluded.push(account);
614     }
615 
616     function includeInReward(address account) external onlyOwner() {
617         require(_isExcluded[account], "Account is already excluded");
618         for (uint256 i = 0; i < _excluded.length; i++) {
619             if (_excluded[i] == account) {
620                 _excluded[i] = _excluded[_excluded.length - 1];
621                 _tOwned[account] = 0;
622                 _isExcluded[account] = false;
623                 _excluded.pop();
624                 break;
625             }
626         }
627     }
628 
629     function _approve(address owner, address spender, uint256 amount) private {
630         require(owner != address(0), "ERC20: approve from the zero address");
631         require(spender != address(0), "ERC20: approve to the zero address");
632 
633         _allowances[owner][spender] = amount;
634         emit Approval(owner, spender, amount);
635     }
636 
637     function _transfer(
638         address from,
639         address to,
640         uint256 amount
641     ) private {
642         require(from != address(0), "ERC20: transfer from the zero address");
643         require(to != address(0), "ERC20: transfer to the zero address");
644         require(amount > 0, "Transfer amount must be greater than zero");
645         if(from != owner() && to != owner()) {
646             require(!bots[from] && !bots[to]);
647             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
648         }
649 
650         uint256 contractTokenBalance = balanceOf(address(this));
651         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
652 
653         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
654             if (overMinimumTokenBalance) {
655                 contractTokenBalance = minimumTokensBeforeSwap;
656                 swapTokens(contractTokenBalance);
657             }
658 	        uint256 balance = address(this).balance;
659             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
660 
661                 if (balance > buyBackUpperLimit)
662                     balance = buyBackUpperLimit;
663 
664                 buyBackTokens(balance.div(100));
665             }
666         }
667 
668         bool takeFee = true;
669 
670         //if any account belongs to _isExcludedFromFee account then remove the fee
671         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
672             takeFee = false;
673         }
674 
675         _tokenTransfer(from,to,amount,takeFee);
676     }
677 
678     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
679 
680         uint256 initialBalance = address(this).balance;
681         swapTokensForEth(contractTokenBalance);
682         uint256 transferredBalance = address(this).balance.sub(initialBalance);
683 
684         //Send to Marketing address
685         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
686 
687     }
688 
689 
690     function buyBackTokens(uint256 amount) private lockTheSwap {
691     	if (amount > 0) {
692     	    swapETHForTokens(amount);
693 	    }
694     }
695 
696     function swapTokensForEth(uint256 tokenAmount) private {
697         // generate the uniswap pair path of token -> weth
698         address[] memory path = new address[](2);
699         path[0] = address(this);
700         path[1] = uniswapV2Router.WETH();
701 
702         _approve(address(this), address(uniswapV2Router), tokenAmount);
703 
704         // make the swap
705         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
706             tokenAmount,
707             0, // accept any amount of ETH
708             path,
709             address(this), // The contract
710             block.timestamp
711         );
712 
713         emit SwapTokensForETH(tokenAmount, path);
714     }
715 
716     function swapETHForTokens(uint256 amount) private {
717         // generate the uniswap pair path of token -> weth
718         address[] memory path = new address[](2);
719         path[0] = uniswapV2Router.WETH();
720         path[1] = address(this);
721 
722       // make the swap
723         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
724             0, // accept any amount of Tokens
725             path,
726             deadAddress, // Burn address
727             block.timestamp.add(300)
728         );
729 
730         emit SwapETHForTokens(amount, path);
731     }
732 
733     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
734         // approve token transfer to cover all possible scenarios
735         _approve(address(this), address(uniswapV2Router), tokenAmount);
736 
737         // add the liquidity
738         uniswapV2Router.addLiquidityETH{value: ethAmount}(
739             address(this),
740             tokenAmount,
741             0, // slippage is unavoidable
742             0, // slippage is unavoidable
743             owner(),
744             block.timestamp
745         );
746     }
747 
748 
749 
750     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
751         if(!takeFee)
752             removeAllFee();
753 
754         if (_isExcluded[sender] && !_isExcluded[recipient]) {
755             _transferFromExcluded(sender, recipient, amount);
756         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
757             _transferToExcluded(sender, recipient, amount);
758         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
759             _transferBothExcluded(sender, recipient, amount);
760         } else {
761             _transferStandard(sender, recipient, amount);
762         }
763 
764         if(!takeFee)
765             restoreAllFee();
766     }
767 
768     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
769         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
770         _rOwned[sender] = _rOwned[sender].sub(rAmount);
771         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
772         _takeLiquidity(tLiquidity);
773         _reflectFee(rFee, tFee);
774         emit Transfer(sender, recipient, tTransferAmount);
775     }
776 
777     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
778         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
779 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
780         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
781         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
782         _takeLiquidity(tLiquidity);
783         _reflectFee(rFee, tFee);
784         emit Transfer(sender, recipient, tTransferAmount);
785     }
786 
787     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
788         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
789     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
790         _rOwned[sender] = _rOwned[sender].sub(rAmount);
791         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
792         _takeLiquidity(tLiquidity);
793         _reflectFee(rFee, tFee);
794         emit Transfer(sender, recipient, tTransferAmount);
795     }
796 
797     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
798         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
799     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
800         _rOwned[sender] = _rOwned[sender].sub(rAmount);
801         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
802         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
803         _takeLiquidity(tLiquidity);
804         _reflectFee(rFee, tFee);
805         emit Transfer(sender, recipient, tTransferAmount);
806     }
807 
808     function _reflectFee(uint256 rFee, uint256 tFee) private {
809         _rTotal = _rTotal.sub(rFee);
810         _tFeeTotal = _tFeeTotal.add(tFee);
811     }
812 
813     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
814         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
815         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
816         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
817     }
818 
819     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
820         uint256 tFee = calculateTaxFee(tAmount);
821         uint256 tLiquidity = calculateLiquidityFee(tAmount);
822         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
823         return (tTransferAmount, tFee, tLiquidity);
824     }
825 
826     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
827         uint256 rAmount = tAmount.mul(currentRate);
828         uint256 rFee = tFee.mul(currentRate);
829         uint256 rLiquidity = tLiquidity.mul(currentRate);
830         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
831         return (rAmount, rTransferAmount, rFee);
832     }
833 
834     function _getRate() private view returns(uint256) {
835         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
836         return rSupply.div(tSupply);
837     }
838 
839     function _getCurrentSupply() private view returns(uint256, uint256) {
840         uint256 rSupply = _rTotal;
841         uint256 tSupply = _tTotal;
842         for (uint256 i = 0; i < _excluded.length; i++) {
843             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
844             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
845             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
846         }
847         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
848         return (rSupply, tSupply);
849     }
850 
851     function _takeLiquidity(uint256 tLiquidity) private {
852         uint256 currentRate =  _getRate();
853         uint256 rLiquidity = tLiquidity.mul(currentRate);
854         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
855         if(_isExcluded[address(this)])
856             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
857     }
858 
859     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
860         return _amount.mul(_taxFee).div(
861             10**2
862         );
863     }
864 
865     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
866         return _amount.mul(_liquidityFee).div(
867             10**2
868         );
869     }
870 
871     function removeAllFee() private {
872         if(_taxFee == 0 && _liquidityFee == 0) return;
873 
874         _previousTaxFee = _taxFee;
875         _previousLiquidityFee = _liquidityFee;
876 
877         _taxFee = 0;
878         _liquidityFee = 0;
879     }
880 
881     function restoreAllFee() private {
882         _taxFee = _previousTaxFee;
883         _liquidityFee = _previousLiquidityFee;
884     }
885 
886     function isExcludedFromFee(address account) public view returns(bool) {
887         return _isExcludedFromFee[account];
888     }
889 
890     function excludeFromFee(address account) public onlyOwner {
891         _isExcludedFromFee[account] = true;
892     }
893 
894     function includeInFee(address account) public onlyOwner {
895         _isExcludedFromFee[account] = false;
896     }
897 
898     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
899         _taxFee = taxFee;
900     }
901 
902     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
903         _liquidityFee = liquidityFee;
904     }
905 
906     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
907         _maxTxAmount = maxTxAmount;
908     }
909 
910     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
911         marketingDivisor = divisor;
912     }
913 
914     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
915         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
916     }
917 
918      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
919         buyBackUpperLimit = buyBackLimit * 10**18;
920     }
921 
922     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
923         marketingAddress = payable(_marketingAddress);
924     }
925 
926     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
927         swapAndLiquifyEnabled = _enabled;
928         emit SwapAndLiquifyEnabledUpdated(_enabled);
929     }
930 
931     function setBuyBackEnabled(bool _enabled) public onlyOwner {
932         buyBackEnabled = _enabled;
933         emit BuyBackEnabledUpdated(_enabled);
934     }
935 
936     function prepareForPreSale() external onlyOwner {
937         setSwapAndLiquifyEnabled(false);
938         _taxFee = 0;
939         _liquidityFee = 0;
940         _maxTxAmount = 1000000000 * 10**6 * 10**9;
941     }
942 
943     function afterPreSale() external onlyOwner {
944         setSwapAndLiquifyEnabled(true);
945         _taxFee = 2;
946         _liquidityFee = 9;
947         _maxTxAmount = 3000000 * 10**6 * 10**9;
948     }
949 
950     function transferToAddressETH(address payable recipient, uint256 amount) private {
951         recipient.transfer(amount);
952     }
953 
954 
955     receive() external payable {}
956 }