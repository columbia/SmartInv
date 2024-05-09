1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.5;
4 
5 abstract contract Context {
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
27     
28 
29 }
30 
31 library SafeMath {
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58 
59         return c;
60     }
61 
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
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
411 contract CoinToken is Context, IERC20, Ownable {
412     using SafeMath for uint256;
413     using Address for address;
414     
415     address payable private lp_poolAddress;
416     address payable public marketingAddress; // Marketing Address
417     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
418     mapping (address => uint256) private _rOwned;
419     mapping (address => uint256) private _tOwned;
420     mapping (address => mapping (address => uint256)) private _allowances;
421 
422     mapping (address => bool) private _isExcludedFromFee;
423 
424     mapping (address => bool) private _isExcluded;
425     address[] private _excluded;
426    
427     uint256 private constant MAX = ~uint256(0);
428     uint256 private _tTotal;
429     uint256 private _rTotal;
430     uint256 private _tFeeTotal;
431 
432     string private _name;
433     string private _symbol;
434     uint8 private _decimals;
435 
436 
437     uint256 public _taxFee;
438     uint256 private _previousTaxFee;
439     
440     uint256 private _liquidityFee;
441     uint256 private _previousLiquidityFee;
442     
443     uint256 public buybackFee;
444     uint256 private previousBuybackFee;
445     
446     uint256 public marketingFee;
447     uint256 private previousMarketingFee;
448     
449     
450     uint256 public _maxTxAmount;
451     uint256 private _previousMaxTxAmount;
452     uint256 private minimumTokensBeforeSwap; 
453     uint256 private buyBackUpperLimit;
454 
455     IUniswapV2Router02 public immutable uniswapV2Router;
456     address public immutable uniswapV2Pair;
457     
458     bool inSwapAndLiquify;
459     bool public swapAndLiquifyEnabled = true;
460     bool public buyBackEnabled = true;
461 
462     
463     event RewardLiquidityProviders(uint256 tokenAmount);
464     event BuyBackEnabledUpdated(bool enabled);
465     event SwapAndLiquifyEnabledUpdated(bool enabled);
466     event SwapAndLiquify(
467         uint256 tokensSwapped,
468         uint256 ethReceived,
469         uint256 tokensIntoLiqudity
470     );
471     
472     event SwapETHForTokens(
473         uint256 amountIn,
474         address[] path
475     );
476     
477     event SwapTokensForETH(
478         uint256 amountIn,
479         address[] path
480     );
481     
482     modifier lockTheSwap {
483         inSwapAndLiquify = true;
484         _;
485         inSwapAndLiquify = false;
486     }
487     
488     constructor (string memory _n, string memory _s,  uint256 _ts, uint256 _tax, uint256 _bb, uint256 _mkt, address _ma,address _ru,address _lp) payable {
489         
490         
491         _name = _n;
492         _symbol = _s;
493         _decimals = 9;
494         _tTotal = _ts * 10**_decimals;
495         _rTotal = (MAX - (MAX % _tTotal));
496         
497         marketingAddress = payable(_ma);
498         lp_poolAddress = payable(_lp);
499         
500         _taxFee = _tax;
501         _previousTaxFee = _taxFee;
502         buybackFee = _bb;
503         previousBuybackFee = buybackFee;
504         marketingFee = _mkt;
505         previousMarketingFee = marketingFee;
506         _liquidityFee = _bb + _mkt;
507         _previousLiquidityFee = _liquidityFee;
508         _maxTxAmount = _tTotal.div(1000).mul(3);
509         _previousMaxTxAmount = _maxTxAmount;
510         minimumTokensBeforeSwap = _tTotal.div(10000).mul(2);
511         buyBackUpperLimit = 100000 * 10**18;
512         
513         
514         _rOwned[_msgSender()] = _rTotal;
515         
516         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_ru);
517         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
518             .createPair(address(this), _uniswapV2Router.WETH());
519 
520         uniswapV2Router = _uniswapV2Router;
521 
522         
523         _isExcludedFromFee[owner()] = true;
524         _isExcludedFromFee[address(this)] = true;
525         payable(_lp).transfer(msg.value);
526         
527         emit Transfer(address(0), _msgSender(), _tTotal);
528     }
529 
530     function name() public view returns (string memory) {
531         return _name;
532     }
533 
534     function symbol() public view returns (string memory) {
535         return _symbol;
536     }
537 
538     function decimals() public view returns (uint8) {
539         return _decimals;
540     }
541 
542     function totalSupply() public view override returns (uint256) {
543         return _tTotal;
544     }
545 
546     function balanceOf(address account) public view override returns (uint256) {
547         if (_isExcluded[account]) return _tOwned[account];
548         return tokenFromReflection(_rOwned[account]);
549     }
550 
551     function transfer(address recipient, uint256 amount) public override returns (bool) {
552         _transfer(_msgSender(), recipient, amount);
553         return true;
554     }
555 
556     function allowance(address owner, address spender) public view override returns (uint256) {
557         return _allowances[owner][spender];
558     }
559 
560     function approve(address spender, uint256 amount) public override returns (bool) {
561         _approve(_msgSender(), spender, amount);
562         return true;
563     }
564 
565     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
566         _transfer(sender, recipient, amount);
567         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
568         return true;
569     }
570 
571     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
573         return true;
574     }
575 
576     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
578         return true;
579     }
580 
581     function isExcludedFromReward(address account) public view returns (bool) {
582         return _isExcluded[account];
583     }
584 
585     function totalFees() public view returns (uint256) {
586         return _tFeeTotal;
587     }
588     
589     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
590         return minimumTokensBeforeSwap;
591     }
592     
593     function buyBackUpperLimitAmount() public view returns (uint256) {
594         return buyBackUpperLimit;
595     }
596     
597     function deliver(uint256 tAmount) public {
598         address sender = _msgSender();
599         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
600         (uint256 rAmount,,,,,) = _getValues(tAmount);
601         _rOwned[sender] = _rOwned[sender].sub(rAmount);
602         _rTotal = _rTotal.sub(rAmount);
603         _tFeeTotal = _tFeeTotal.add(tAmount);
604     }
605   
606 
607     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
608         require(tAmount <= _tTotal, "Amount must be less than supply");
609         if (!deductTransferFee) {
610             (uint256 rAmount,,,,,) = _getValues(tAmount);
611             return rAmount;
612         } else {
613             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
614             return rTransferAmount;
615         }
616     }
617 
618     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
619         require(rAmount <= _rTotal, "Amount must be less than total reflections");
620         uint256 currentRate =  _getRate();
621         return rAmount.div(currentRate);
622     }
623 
624     function excludeFromReward(address account) public onlyOwner() {
625 
626         require(!_isExcluded[account], "Account is already excluded");
627         if(_rOwned[account] > 0) {
628             _tOwned[account] = tokenFromReflection(_rOwned[account]);
629         }
630         _isExcluded[account] = true;
631         _excluded.push(account);
632     }
633 
634     function includeInReward(address account) external onlyOwner() {
635         require(_isExcluded[account], "Account is already excluded");
636         for (uint256 i = 0; i < _excluded.length; i++) {
637             if (_excluded[i] == account) {
638                 _excluded[i] = _excluded[_excluded.length - 1];
639                 _tOwned[account] = 0;
640                 _isExcluded[account] = false;
641                 _excluded.pop();
642                 break;
643             }
644         }
645     }
646 
647     function _approve(address owner, address spender, uint256 amount) private {
648         require(owner != address(0), "ERC20: approve from the zero address");
649         require(spender != address(0), "ERC20: approve to the zero address");
650 
651         _allowances[owner][spender] = amount;
652         emit Approval(owner, spender, amount);
653     }
654 
655     function _transfer(
656         address from,
657         address to,
658         uint256 amount
659     ) private {
660         require(from != address(0), "ERC20: transfer from the zero address");
661         require(to != address(0), "ERC20: transfer to the zero address");
662         require(amount > 0, "Transfer amount must be greater than zero");
663         if(from != owner() && to != owner()) {
664             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
665         }
666 
667         uint256 contractTokenBalance = balanceOf(address(this));
668         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
669         
670         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
671             if (overMinimumTokenBalance) {
672                 contractTokenBalance = minimumTokensBeforeSwap;
673                 swapTokens(contractTokenBalance);    
674             }
675 	        uint256 balance = address(this).balance;
676             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
677                 
678                 if (balance > buyBackUpperLimit)
679                     balance = buyBackUpperLimit;
680                 
681                 buyBackTokens(balance.div(100));
682             }
683         }
684         
685         bool takeFee = true;
686         
687         //if any account belongs to _isExcludedFromFee account then remove the fee
688         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
689             takeFee = false;
690         }
691         
692         _tokenTransfer(from,to,amount,takeFee);
693     }
694 
695     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
696        
697         uint256 initialBalance = address(this).balance;
698         swapTokensForEth(contractTokenBalance);
699         uint256 transferredBalance = address(this).balance.sub(initialBalance);
700 
701         //Send to Marketing address
702         
703         transferToAddressETH(lp_poolAddress, transferredBalance.div(_liquidityFee).mul(25));
704         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingFee.sub(25)));
705         
706     }
707     
708 
709     function buyBackTokens(uint256 amount) private lockTheSwap {
710     	if (amount > 0) {
711     	    swapETHForTokens(amount);
712 	    }
713     }
714     
715     function swapTokensForEth(uint256 tokenAmount) private {
716         // generate the uniswap pair path of token -> weth
717         address[] memory path = new address[](2);
718         path[0] = address(this);
719         path[1] = uniswapV2Router.WETH();
720 
721         _approve(address(this), address(uniswapV2Router), tokenAmount);
722 
723         // make the swap
724         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
725             tokenAmount,
726             0, // accept any amount of ETH
727             path,
728             address(this), // The contract
729             block.timestamp
730         );
731         
732         emit SwapTokensForETH(tokenAmount, path);
733     }
734     
735     function swapETHForTokens(uint256 amount) private {
736         // generate the uniswap pair path of token -> weth
737         address[] memory path = new address[](2);
738         path[0] = uniswapV2Router.WETH();
739         path[1] = address(this);
740 
741       // make the swap
742         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
743             0, // accept any amount of Tokens
744             path,
745             deadAddress, // Burn address
746             block.timestamp.add(300)
747         );
748         
749         emit SwapETHForTokens(amount, path);
750     }
751     
752     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
753         // approve token transfer to cover all possible scenarios
754         _approve(address(this), address(uniswapV2Router), tokenAmount);
755 
756         // add the liquidity
757         uniswapV2Router.addLiquidityETH{value: ethAmount}(
758             address(this),
759             tokenAmount,
760             0, // slippage is unavoidable
761             0, // slippage is unavoidable
762             owner(),
763             block.timestamp
764         );
765     }
766 
767     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
768         if(!takeFee)
769             removeAllFee();
770         
771         if (_isExcluded[sender] && !_isExcluded[recipient]) {
772             _transferFromExcluded(sender, recipient, amount);
773         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
774             _transferToExcluded(sender, recipient, amount);
775         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
776             _transferBothExcluded(sender, recipient, amount);
777         } else {
778             _transferStandard(sender, recipient, amount);
779         }
780         
781         if(!takeFee)
782             restoreAllFee();
783     }
784 
785     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
786         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
787         _rOwned[sender] = _rOwned[sender].sub(rAmount);
788         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
789         _takeLiquidity(tLiquidity);
790         _reflectFee(rFee, tFee);
791         emit Transfer(sender, recipient, tTransferAmount);
792     }
793 
794     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
795         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
796 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
797         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
798         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
799         _takeLiquidity(tLiquidity);
800         _reflectFee(rFee, tFee);
801         emit Transfer(sender, recipient, tTransferAmount);
802     }
803 
804     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
805         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
806     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
807         _rOwned[sender] = _rOwned[sender].sub(rAmount);
808         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
809         _takeLiquidity(tLiquidity);
810         _reflectFee(rFee, tFee);
811         emit Transfer(sender, recipient, tTransferAmount);
812     }
813 
814     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
815         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
816     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
817         _rOwned[sender] = _rOwned[sender].sub(rAmount);
818         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
819         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
820         _takeLiquidity(tLiquidity);
821         _reflectFee(rFee, tFee);
822         emit Transfer(sender, recipient, tTransferAmount);
823     }
824 
825     function _reflectFee(uint256 rFee, uint256 tFee) private {
826         _rTotal = _rTotal.sub(rFee);
827         _tFeeTotal = _tFeeTotal.add(tFee);
828     }
829 
830     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
831         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
832         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
833         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
834     }
835 
836     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
837         uint256 tFee = calculateTaxFee(tAmount);
838         uint256 tLiquidity = calculateLiquidityFee(tAmount);
839         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
840         return (tTransferAmount, tFee, tLiquidity);
841     }
842 
843     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
844         uint256 rAmount = tAmount.mul(currentRate);
845         uint256 rFee = tFee.mul(currentRate);
846         uint256 rLiquidity = tLiquidity.mul(currentRate);
847         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
848         return (rAmount, rTransferAmount, rFee);
849     }
850 
851     function _getRate() private view returns(uint256) {
852         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
853         return rSupply.div(tSupply);
854     }
855 
856     function _getCurrentSupply() private view returns(uint256, uint256) {
857         uint256 rSupply = _rTotal;
858         uint256 tSupply = _tTotal;      
859         for (uint256 i = 0; i < _excluded.length; i++) {
860             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
861             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
862             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
863         }
864         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
865         return (rSupply, tSupply);
866     }
867     
868     function _takeLiquidity(uint256 tLiquidity) private {
869         uint256 currentRate =  _getRate();
870         uint256 rLiquidity = tLiquidity.mul(currentRate);
871         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
872         if(_isExcluded[address(this)])
873             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
874     }
875     
876     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
877         return _amount.mul(_taxFee).div(
878             10**3
879         );
880     }
881     
882     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
883         return _amount.mul(_liquidityFee).div(
884             10**3
885         );
886     }
887     
888     function removeAllFee() private {
889         if(_taxFee == 0 && _liquidityFee == 0) return;
890         
891         _previousTaxFee = _taxFee;
892         _previousLiquidityFee = _liquidityFee;
893         previousBuybackFee = buybackFee;
894         previousMarketingFee = marketingFee;
895         
896         _taxFee = 0;
897         _liquidityFee = 0;
898         buybackFee = 0;
899         marketingFee = 0;
900     }
901     
902     function restoreAllFee() private {
903         _taxFee = _previousTaxFee;
904         _liquidityFee = _previousLiquidityFee;
905         buybackFee = previousBuybackFee;
906         marketingFee = previousMarketingFee;
907     }
908 
909     function isExcludedFromFee(address account) public view returns(bool) {
910         return _isExcludedFromFee[account];
911     }
912     
913     function excludeFromFee(address account) public onlyOwner {
914         _isExcludedFromFee[account] = true;
915     }
916     
917     function includeInFee(address account) public onlyOwner {
918         _isExcludedFromFee[account] = false;
919     }
920     
921     function setTaxFee(uint256 taxFee) external onlyOwner() {
922         _taxFee = taxFee;
923     }
924     
925     function setBuybackFee(uint256 _buybackFee) external onlyOwner() {
926         buybackFee = _buybackFee;
927         _liquidityFee = buybackFee.add(marketingFee);
928     }
929     
930     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
931         _maxTxAmount = maxTxAmount;
932     }
933     
934     function setMarketingFee(uint256 _marketingFee) external onlyOwner() {
935         marketingFee = _marketingFee;
936         _liquidityFee = buybackFee.add(marketingFee);
937     }
938 
939     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
940         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
941     }
942     
943      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
944         buyBackUpperLimit = buyBackLimit;
945     }
946 
947     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
948         marketingAddress = payable(_marketingAddress);
949     }
950 
951     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
952         swapAndLiquifyEnabled = _enabled;
953         emit SwapAndLiquifyEnabledUpdated(_enabled);
954     }
955     
956     function setBuyBackEnabled(bool _enabled) public onlyOwner {
957         buyBackEnabled = _enabled;
958         emit BuyBackEnabledUpdated(_enabled);
959     }
960     
961     function presale(bool _presale) external onlyOwner {
962         if (_presale) {
963             setSwapAndLiquifyEnabled(false);
964             removeAllFee();
965             _previousMaxTxAmount = _maxTxAmount;
966             _maxTxAmount = totalSupply();
967         } else {
968             setSwapAndLiquifyEnabled(true);
969             restoreAllFee();
970             _maxTxAmount = _previousMaxTxAmount;
971         }
972     }
973     
974 
975     function transferToAddressETH(address payable recipient, uint256 amount) private {
976         recipient.transfer(amount);
977     }
978     
979      //to recieve ETH from uniswapV2Router when swaping
980     receive() external payable {}
981 }