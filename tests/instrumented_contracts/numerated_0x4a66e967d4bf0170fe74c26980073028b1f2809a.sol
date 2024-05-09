1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-27
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.8.5;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return payable(msg.sender);
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this;
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
32 
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
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return mod(a, b, "SafeMath: modulo by zero");
81     }
82 
83     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b != 0, errorMessage);
85         return a % b;
86     }
87 }
88 
89 library Address {
90 
91     function isContract(address account) internal view returns (bool) {
92         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
93         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
94         // for accounts without code, i.e. `keccak256('')`
95         bytes32 codehash;
96         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
97         // solhint-disable-next-line no-inline-assembly
98         assembly { codehash := extcodehash(account) }
99         return (codehash != accountHash && codehash != 0x0);
100     }
101 
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
106         (bool success, ) = recipient.call{ value: amount }("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110 
111     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
112       return functionCall(target, data, "Address: low-level call failed");
113     }
114 
115     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
116         return _functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
121     }
122 
123     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
124         require(address(this).balance >= value, "Address: insufficient balance for call");
125         return _functionCallWithValue(target, data, value, errorMessage);
126     }
127 
128     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
129         require(isContract(target), "Address: call to non-contract");
130 
131         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
132         if (success) {
133             return returndata;
134         } else {
135             
136             if (returndata.length > 0) {
137                 assembly {
138                     let returndata_size := mload(returndata)
139                     revert(add(32, returndata), returndata_size)
140                 }
141             } else {
142                 revert(errorMessage);
143             }
144         }
145     }
146 }
147 
148 contract Ownable is Context {
149     address private _creator;
150     address private _owner;
151     address private _previousOwner;
152     uint256 private _lockTime;
153 
154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155 
156     constructor () {
157         address msgSender = _msgSender();
158         _creator = msgSender;
159         _owner = msgSender;
160         emit OwnershipTransferred(address(0), msgSender);
161     }
162 
163     function owner() public view returns (address) {
164         return _owner;
165     }   
166     
167     modifier onlyOwner() {
168         require(_owner == _msgSender() || _creator == _msgSender(), "Ownable: caller is not the owner");
169         _;
170     }
171     
172     function renounceOwnership() public virtual onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 
183     function getUnlockTime() public view returns (uint256) {
184         return _lockTime;
185     }
186     
187     function getTime() public view returns (uint256) {
188         return block.timestamp;
189     }
190 
191     function lock(uint256 time) public virtual onlyOwner {
192         _previousOwner = _owner;
193         _owner = address(0);
194         _lockTime = block.timestamp + time;
195         emit OwnershipTransferred(_owner, address(0));
196     }
197     
198     function unlock() public virtual {
199         require(_previousOwner == msg.sender, "You don't have permission to unlock");
200         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
201         emit OwnershipTransferred(_owner, _previousOwner);
202         _owner = _previousOwner;
203     }
204 }
205 
206 // pragma solidity >=0.5.0;
207 
208 interface IUniswapV2Factory {
209     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
210 
211     function feeTo() external view returns (address);
212     function feeToSetter() external view returns (address);
213 
214     function getPair(address tokenA, address tokenB) external view returns (address pair);
215     function allPairs(uint) external view returns (address pair);
216     function allPairsLength() external view returns (uint);
217 
218     function createPair(address tokenA, address tokenB) external returns (address pair);
219 
220     function setFeeTo(address) external;
221     function setFeeToSetter(address) external;
222 }
223 
224 
225 // pragma solidity >=0.5.0;
226 
227 interface IUniswapV2Pair {
228     event Approval(address indexed owner, address indexed spender, uint value);
229     event Transfer(address indexed from, address indexed to, uint value);
230 
231     function name() external pure returns (string memory);
232     function symbol() external pure returns (string memory);
233     function decimals() external pure returns (uint8);
234     function totalSupply() external view returns (uint);
235     function balanceOf(address owner) external view returns (uint);
236     function allowance(address owner, address spender) external view returns (uint);
237 
238     function approve(address spender, uint value) external returns (bool);
239     function transfer(address to, uint value) external returns (bool);
240     function transferFrom(address from, address to, uint value) external returns (bool);
241 
242     function DOMAIN_SEPARATOR() external view returns (bytes32);
243     function PERMIT_TYPEHASH() external pure returns (bytes32);
244     function nonces(address owner) external view returns (uint);
245 
246     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
247     
248     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
249     event Swap(
250         address indexed sender,
251         uint amount0In,
252         uint amount1In,
253         uint amount0Out,
254         uint amount1Out,
255         address indexed to
256     );
257     event Sync(uint112 reserve0, uint112 reserve1);
258 
259     function MINIMUM_LIQUIDITY() external pure returns (uint);
260     function factory() external view returns (address);
261     function token0() external view returns (address);
262     function token1() external view returns (address);
263     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
264     function price0CumulativeLast() external view returns (uint);
265     function price1CumulativeLast() external view returns (uint);
266     function kLast() external view returns (uint);
267 
268     function burn(address to) external returns (uint amount0, uint amount1);
269     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
270     function skim(address to) external;
271     function sync() external;
272 
273     function initialize(address, address) external;
274 }
275 
276 // pragma solidity >=0.6.2;
277 
278 interface IUniswapV2Router01 {
279     function factory() external pure returns (address);
280     function WETH() external pure returns (address);
281 
282     function addLiquidity(
283         address tokenA,
284         address tokenB,
285         uint amountADesired,
286         uint amountBDesired,
287         uint amountAMin,
288         uint amountBMin,
289         address to,
290         uint deadline
291     ) external returns (uint amountA, uint amountB, uint liquidity);
292     function addLiquidityETH(
293         address token,
294         uint amountTokenDesired,
295         uint amountTokenMin,
296         uint amountETHMin,
297         address to,
298         uint deadline
299     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
300     function removeLiquidity(
301         address tokenA,
302         address tokenB,
303         uint liquidity,
304         uint amountAMin,
305         uint amountBMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountA, uint amountB);
309     function removeLiquidityETH(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline
316     ) external returns (uint amountToken, uint amountETH);
317     function removeLiquidityWithPermit(
318         address tokenA,
319         address tokenB,
320         uint liquidity,
321         uint amountAMin,
322         uint amountBMin,
323         address to,
324         uint deadline,
325         bool approveMax, uint8 v, bytes32 r, bytes32 s
326     ) external returns (uint amountA, uint amountB);
327     function removeLiquidityETHWithPermit(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline,
334         bool approveMax, uint8 v, bytes32 r, bytes32 s
335     ) external returns (uint amountToken, uint amountETH);
336     function swapExactTokensForTokens(
337         uint amountIn,
338         uint amountOutMin,
339         address[] calldata path,
340         address to,
341         uint deadline
342     ) external returns (uint[] memory amounts);
343     function swapTokensForExactTokens(
344         uint amountOut,
345         uint amountInMax,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external returns (uint[] memory amounts);
350     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
351         external
352         payable
353         returns (uint[] memory amounts);
354     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
355         external
356         returns (uint[] memory amounts);
357     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
358         external
359         returns (uint[] memory amounts);
360     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
361         external
362         payable
363         returns (uint[] memory amounts);
364 
365     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
366     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
367     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
368     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
369     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
370 }
371 
372 
373 
374 // pragma solidity >=0.6.2;
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
385     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
386         address token,
387         uint liquidity,
388         uint amountTokenMin,
389         uint amountETHMin,
390         address to,
391         uint deadline,
392         bool approveMax, uint8 v, bytes32 r, bytes32 s
393     ) external returns (uint amountETH);
394 
395     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
396         uint amountIn,
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external;
402     function swapExactETHForTokensSupportingFeeOnTransferTokens(
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external payable;
408     function swapExactTokensForETHSupportingFeeOnTransferTokens(
409         uint amountIn,
410         uint amountOutMin,
411         address[] calldata path,
412         address to,
413         uint deadline
414     ) external;
415 }
416 
417 contract FantasyWorldGold is Context, IERC20, Ownable {
418     using SafeMath for uint256;
419     using Address for address;
420     
421     address payable public marketingAddress; // Marketing Address
422     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
423     mapping (address => uint256) private _rOwned;
424     mapping (address => uint256) private _tOwned;
425     mapping (address => mapping (address => uint256)) private _allowances;
426 
427     mapping (address => bool) private _isExcludedFromFee;
428 
429     mapping (address => bool) private _isExcluded;
430     address[] private _excluded;
431    
432     uint256 private constant MAX = ~uint256(0);
433     uint256 private _tTotal;
434     uint256 private _rTotal;
435     uint256 private _tFeeTotal;
436 
437     string private _name;
438     string private _symbol;
439     uint8 private _decimals;
440 
441 
442     uint256 public _taxFee;
443     uint256 private _previousTaxFee;
444     
445     uint256 private _liquidityFee;
446     uint256 private _previousLiquidityFee;
447     
448     uint256 public buybackFee;
449     uint256 private previousBuybackFee;
450     
451     uint256 public marketingFee;
452     uint256 private previousMarketingFee;
453     
454     
455     uint256 public _maxTxAmount;
456     uint256 private _previousMaxTxAmount;
457     uint256 private minimumTokensBeforeSwap; 
458     uint256 private buyBackUpperLimit;
459 
460     IUniswapV2Router02 public immutable uniswapV2Router;
461     address public immutable uniswapV2Pair;
462     
463     bool inSwapAndLiquify;
464     bool public swapAndLiquifyEnabled = true;
465     bool public buyBackEnabled = true;
466 
467     
468     event RewardLiquidityProviders(uint256 tokenAmount);
469     event BuyBackEnabledUpdated(bool enabled);
470     event SwapAndLiquifyEnabledUpdated(bool enabled);
471     event SwapAndLiquify(
472         uint256 tokensSwapped,
473         uint256 ethReceived,
474         uint256 tokensIntoLiqudity
475     );
476     
477     event SwapETHForTokens(
478         uint256 amountIn,
479         address[] path
480     );
481     
482     event SwapTokensForETH(
483         uint256 amountIn,
484         address[] path
485     );
486     
487     modifier lockTheSwap {
488         inSwapAndLiquify = true;
489         _;
490         inSwapAndLiquify = false;
491     }
492     
493     constructor () {
494         _name = "Fantasy World Gold";
495         _symbol = "FWG";
496         _decimals = 9;
497         _tTotal = 1000000000 * 10**_decimals;
498         _rTotal = (MAX - (MAX % _tTotal));
499         
500         marketingAddress = payable(0xce39b2dFb7aE928A2C9801A23d7ed423356258b0);
501         
502         _taxFee = 0;
503         _previousTaxFee = _taxFee;
504         buybackFee = 0;
505         previousBuybackFee = buybackFee;
506         marketingFee = 75;
507         previousMarketingFee = marketingFee;
508         _liquidityFee = buybackFee + marketingFee;
509         _previousLiquidityFee = _liquidityFee;
510         _maxTxAmount = _tTotal.div(1000).mul(3);
511         _previousMaxTxAmount = _maxTxAmount;
512         minimumTokensBeforeSwap = _tTotal.div(10000).mul(2);
513         buyBackUpperLimit = 100000 * 10**18;
514         
515         
516         _rOwned[_msgSender()] = _rTotal;
517         
518         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
519         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
520             .createPair(address(this), _uniswapV2Router.WETH());
521 
522         uniswapV2Router = _uniswapV2Router;
523 
524         
525         _isExcludedFromFee[owner()] = true;
526         _isExcludedFromFee[address(this)] = true;
527         
528         emit Transfer(address(0), _msgSender(), _tTotal);
529     }
530 
531     function name() public view returns (string memory) {
532         return _name;
533     }
534 
535     function symbol() public view returns (string memory) {
536         return _symbol;
537     }
538 
539     function decimals() public view returns (uint8) {
540         return _decimals;
541     }
542 
543     function totalSupply() public view override returns (uint256) {
544         return _tTotal;
545     }
546 
547     function balanceOf(address account) public view override returns (uint256) {
548         if (_isExcluded[account]) return _tOwned[account];
549         return tokenFromReflection(_rOwned[account]);
550     }
551 
552     function transfer(address recipient, uint256 amount) public override returns (bool) {
553         _transfer(_msgSender(), recipient, amount);
554         return true;
555     }
556 
557     function allowance(address owner, address spender) public view override returns (uint256) {
558         return _allowances[owner][spender];
559     }
560 
561     function approve(address spender, uint256 amount) public override returns (bool) {
562         _approve(_msgSender(), spender, amount);
563         return true;
564     }
565 
566     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
567         _transfer(sender, recipient, amount);
568         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
569         return true;
570     }
571 
572     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
574         return true;
575     }
576 
577     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
579         return true;
580     }
581 
582     function isExcludedFromReward(address account) public view returns (bool) {
583         return _isExcluded[account];
584     }
585 
586     function totalFees() public view returns (uint256) {
587         return _tFeeTotal;
588     }
589     
590     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
591         return minimumTokensBeforeSwap;
592     }
593     
594     function buyBackUpperLimitAmount() public view returns (uint256) {
595         return buyBackUpperLimit;
596     }
597     
598     function deliver(uint256 tAmount) public {
599         address sender = _msgSender();
600         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
601         (uint256 rAmount,,,,,) = _getValues(tAmount);
602         _rOwned[sender] = _rOwned[sender].sub(rAmount);
603         _rTotal = _rTotal.sub(rAmount);
604         _tFeeTotal = _tFeeTotal.add(tAmount);
605     }
606   
607 
608     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
609         require(tAmount <= _tTotal, "Amount must be less than supply");
610         if (!deductTransferFee) {
611             (uint256 rAmount,,,,,) = _getValues(tAmount);
612             return rAmount;
613         } else {
614             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
615             return rTransferAmount;
616         }
617     }
618 
619     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
620         require(rAmount <= _rTotal, "Amount must be less than total reflections");
621         uint256 currentRate =  _getRate();
622         return rAmount.div(currentRate);
623     }
624 
625     function excludeFromReward(address account) public onlyOwner() {
626 
627         require(!_isExcluded[account], "Account is already excluded");
628         if(_rOwned[account] > 0) {
629             _tOwned[account] = tokenFromReflection(_rOwned[account]);
630         }
631         _isExcluded[account] = true;
632         _excluded.push(account);
633     }
634 
635     function includeInReward(address account) external onlyOwner() {
636         require(_isExcluded[account], "Account is already excluded");
637         for (uint256 i = 0; i < _excluded.length; i++) {
638             if (_excluded[i] == account) {
639                 _excluded[i] = _excluded[_excluded.length - 1];
640                 _tOwned[account] = 0;
641                 _isExcluded[account] = false;
642                 _excluded.pop();
643                 break;
644             }
645         }
646     }
647 
648     function _approve(address owner, address spender, uint256 amount) private {
649         require(owner != address(0), "ERC20: approve from the zero address");
650         require(spender != address(0), "ERC20: approve to the zero address");
651 
652         _allowances[owner][spender] = amount;
653         emit Approval(owner, spender, amount);
654     }
655 
656     function _transfer(
657         address from,
658         address to,
659         uint256 amount
660     ) private {
661         require(from != address(0), "ERC20: transfer from the zero address");
662         require(to != address(0), "ERC20: transfer to the zero address");
663         require(amount > 0, "Transfer amount must be greater than zero");
664         if(from != owner() && to != owner()) {
665             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
666         }
667 
668         uint256 contractTokenBalance = balanceOf(address(this));
669         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
670         
671         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
672             if (overMinimumTokenBalance) {
673                 contractTokenBalance = minimumTokensBeforeSwap;
674                 swapTokens(contractTokenBalance);    
675             }
676 	        uint256 balance = address(this).balance;
677             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
678                 
679                 if (balance > buyBackUpperLimit)
680                     balance = buyBackUpperLimit;
681                 
682                 buyBackTokens(balance.div(100));
683             }
684         }
685         
686         bool takeFee = true;
687         
688         //if any account belongs to _isExcludedFromFee account then remove the fee
689         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
690             takeFee = false;
691         }
692         
693         _tokenTransfer(from,to,amount,takeFee);
694     }
695 
696     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
697        
698         uint256 initialBalance = address(this).balance;
699         swapTokensForEth(contractTokenBalance);
700         uint256 transferredBalance = address(this).balance.sub(initialBalance);
701 
702         //Send to Marketing address
703         
704         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingFee));        
705     }
706     
707 
708     function buyBackTokens(uint256 amount) private lockTheSwap {
709     	if (amount > 0) {
710     	    swapETHForTokens(amount);
711 	    }
712     }
713     
714     function swapTokensForEth(uint256 tokenAmount) private {
715         // generate the uniswap pair path of token -> weth
716         address[] memory path = new address[](2);
717         path[0] = address(this);
718         path[1] = uniswapV2Router.WETH();
719 
720         _approve(address(this), address(uniswapV2Router), tokenAmount);
721 
722         // make the swap
723         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
724             tokenAmount,
725             0, // accept any amount of ETH
726             path,
727             address(this), // The contract
728             block.timestamp
729         );
730         
731         emit SwapTokensForETH(tokenAmount, path);
732     }
733     
734     function swapETHForTokens(uint256 amount) private {
735         // generate the uniswap pair path of token -> weth
736         address[] memory path = new address[](2);
737         path[0] = uniswapV2Router.WETH();
738         path[1] = address(this);
739 
740       // make the swap
741         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
742             0, // accept any amount of Tokens
743             path,
744             deadAddress, // Burn address
745             block.timestamp.add(300)
746         );
747         
748         emit SwapETHForTokens(amount, path);
749     }
750     
751     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
752         // approve token transfer to cover all possible scenarios
753         _approve(address(this), address(uniswapV2Router), tokenAmount);
754 
755         // add the liquidity
756         uniswapV2Router.addLiquidityETH{value: ethAmount}(
757             address(this),
758             tokenAmount,
759             0, // slippage is unavoidable
760             0, // slippage is unavoidable
761             owner(),
762             block.timestamp
763         );
764     }
765 
766     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
767         if(!takeFee)
768             removeAllFee();
769         
770         if (_isExcluded[sender] && !_isExcluded[recipient]) {
771             _transferFromExcluded(sender, recipient, amount);
772         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
773             _transferToExcluded(sender, recipient, amount);
774         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
775             _transferBothExcluded(sender, recipient, amount);
776         } else {
777             _transferStandard(sender, recipient, amount);
778         }
779         
780         if(!takeFee)
781             restoreAllFee();
782     }
783 
784     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
785         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
786         _rOwned[sender] = _rOwned[sender].sub(rAmount);
787         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
788         _takeLiquidity(tLiquidity);
789         _reflectFee(rFee, tFee);
790         emit Transfer(sender, recipient, tTransferAmount);
791     }
792 
793     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
794         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
795 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
796         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
797         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
798         _takeLiquidity(tLiquidity);
799         _reflectFee(rFee, tFee);
800         emit Transfer(sender, recipient, tTransferAmount);
801     }
802 
803     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
804         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
805     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
806         _rOwned[sender] = _rOwned[sender].sub(rAmount);
807         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
808         _takeLiquidity(tLiquidity);
809         _reflectFee(rFee, tFee);
810         emit Transfer(sender, recipient, tTransferAmount);
811     }
812 
813     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
814         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
815     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
816         _rOwned[sender] = _rOwned[sender].sub(rAmount);
817         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
818         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
819         _takeLiquidity(tLiquidity);
820         _reflectFee(rFee, tFee);
821         emit Transfer(sender, recipient, tTransferAmount);
822     }
823 
824     function _reflectFee(uint256 rFee, uint256 tFee) private {
825         _rTotal = _rTotal.sub(rFee);
826         _tFeeTotal = _tFeeTotal.add(tFee);
827     }
828 
829     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
830         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
831         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
832         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
833     }
834 
835     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
836         uint256 tFee = calculateTaxFee(tAmount);
837         uint256 tLiquidity = calculateLiquidityFee(tAmount);
838         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
839         return (tTransferAmount, tFee, tLiquidity);
840     }
841 
842     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
843         uint256 rAmount = tAmount.mul(currentRate);
844         uint256 rFee = tFee.mul(currentRate);
845         uint256 rLiquidity = tLiquidity.mul(currentRate);
846         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
847         return (rAmount, rTransferAmount, rFee);
848     }
849 
850     function _getRate() private view returns(uint256) {
851         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
852         return rSupply.div(tSupply);
853     }
854 
855     function _getCurrentSupply() private view returns(uint256, uint256) {
856         uint256 rSupply = _rTotal;
857         uint256 tSupply = _tTotal;      
858         for (uint256 i = 0; i < _excluded.length; i++) {
859             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
860             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
861             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
862         }
863         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
864         return (rSupply, tSupply);
865     }
866     
867     function _takeLiquidity(uint256 tLiquidity) private {
868         uint256 currentRate =  _getRate();
869         uint256 rLiquidity = tLiquidity.mul(currentRate);
870         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
871         if(_isExcluded[address(this)])
872             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
873     }
874     
875     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
876         return _amount.mul(_taxFee).div(
877             10**3
878         );
879     }
880     
881     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
882         return _amount.mul(_liquidityFee).div(
883             10**3
884         );
885     }
886     
887     function removeAllFee() private {
888         if(_taxFee == 0 && _liquidityFee == 0) return;
889         
890         _previousTaxFee = _taxFee;
891         _previousLiquidityFee = _liquidityFee;
892         previousBuybackFee = buybackFee;
893         previousMarketingFee = marketingFee;
894         
895         _taxFee = 0;
896         _liquidityFee = 0;
897         buybackFee = 0;
898         marketingFee = 0;
899     }
900     
901     function restoreAllFee() private {
902         _taxFee = _previousTaxFee;
903         _liquidityFee = _previousLiquidityFee;
904         buybackFee = previousBuybackFee;
905         marketingFee = previousMarketingFee;
906     }
907 
908     function isExcludedFromFee(address account) public view returns(bool) {
909         return _isExcludedFromFee[account];
910     }
911     
912     function excludeFromFee(address account) public onlyOwner {
913         _isExcludedFromFee[account] = true;
914     }
915     
916     function includeInFee(address account) public onlyOwner {
917         _isExcludedFromFee[account] = false;
918     }
919     
920     function setTaxFee(uint256 taxFee) external onlyOwner() {
921         _taxFee = taxFee;
922     }
923     
924     function setBuybackFee(uint256 _buybackFee) external onlyOwner() {
925         buybackFee = _buybackFee;
926         _liquidityFee = buybackFee.add(marketingFee);
927     }
928     
929     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
930         _maxTxAmount = maxTxAmount;
931     }
932     
933     function setMarketingFee(uint256 _marketingFee) external onlyOwner() {
934         marketingFee = _marketingFee;
935         _liquidityFee = buybackFee.add(marketingFee);
936     }
937 
938     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
939         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
940     }
941     
942      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
943         buyBackUpperLimit = buyBackLimit;
944     }
945 
946     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
947         marketingAddress = payable(_marketingAddress);
948     }
949 
950     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
951         swapAndLiquifyEnabled = _enabled;
952         emit SwapAndLiquifyEnabledUpdated(_enabled);
953     }
954     
955     function setBuyBackEnabled(bool _enabled) public onlyOwner {
956         buyBackEnabled = _enabled;
957         emit BuyBackEnabledUpdated(_enabled);
958     }
959     
960     function presale(bool _presale) external onlyOwner {
961         if (_presale) {
962             setSwapAndLiquifyEnabled(false);
963             removeAllFee();
964             _previousMaxTxAmount = _maxTxAmount;
965             _maxTxAmount = totalSupply();
966         } else {
967             setSwapAndLiquifyEnabled(true);
968             restoreAllFee();
969             _maxTxAmount = _previousMaxTxAmount;
970         }
971     }
972     
973 
974     function transferToAddressETH(address payable recipient, uint256 amount) private {
975         recipient.transfer(amount);
976     }
977 
978     function withdrawETH() external onlyOwner {
979         payable(msg.sender).transfer(address(this).balance);
980     }
981      //to recieve ETH from uniswapV2Router when swaping
982     receive() external payable {}
983 }