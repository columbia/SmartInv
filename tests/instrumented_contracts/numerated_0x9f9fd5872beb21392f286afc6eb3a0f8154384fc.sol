1 pragma solidity ^0.8.5;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return payable(msg.sender);
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this;
10         return msg.data;
11     }
12 }
13 
14 
15 interface IERC20 {
16 
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     
26 
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
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return mod(a, b, "SafeMath: modulo by zero");
75     }
76 
77     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b != 0, errorMessage);
79         return a % b;
80     }
81 }
82 
83 library Address {
84 
85     function isContract(address account) internal view returns (bool) {
86         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
87         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
88         // for accounts without code, i.e. `keccak256('')`
89         bytes32 codehash;
90         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
91         // solhint-disable-next-line no-inline-assembly
92         assembly { codehash := extcodehash(account) }
93         return (codehash != accountHash && codehash != 0x0);
94     }
95 
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(address(this).balance >= amount, "Address: insufficient balance");
98 
99         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
100         (bool success, ) = recipient.call{ value: amount }("");
101         require(success, "Address: unable to send value, recipient may have reverted");
102     }
103 
104 
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106       return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
110         return _functionCallWithValue(target, data, 0, errorMessage);
111     }
112 
113     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
118         require(address(this).balance >= value, "Address: insufficient balance for call");
119         return _functionCallWithValue(target, data, value, errorMessage);
120     }
121 
122     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
123         require(isContract(target), "Address: call to non-contract");
124 
125         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
126         if (success) {
127             return returndata;
128         } else {
129             
130             if (returndata.length > 0) {
131                 assembly {
132                     let returndata_size := mload(returndata)
133                     revert(add(32, returndata), returndata_size)
134                 }
135             } else {
136                 revert(errorMessage);
137             }
138         }
139     }
140 }
141 
142 contract Ownable is Context {
143     address private _owner;
144     address private _previousOwner;
145     uint256 private _lockTime;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149     constructor () {
150         address msgSender = _msgSender();
151         _owner = msgSender;
152         emit OwnershipTransferred(address(0), msgSender);
153     }
154 
155     function owner() public view returns (address) {
156         return _owner;
157     }   
158     
159     modifier onlyOwner() {
160         require(_owner == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163     
164     function renounceOwnership() public virtual onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168 
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 
175     function getUnlockTime() public view returns (uint256) {
176         return _lockTime;
177     }
178     
179     function getTime() public view returns (uint256) {
180         return block.timestamp;
181     }
182 
183     function lock(uint256 time) public virtual onlyOwner {
184         _previousOwner = _owner;
185         _owner = address(0);
186         _lockTime = block.timestamp + time;
187         emit OwnershipTransferred(_owner, address(0));
188     }
189     
190     function unlock() public virtual {
191         require(_previousOwner == msg.sender, "You don't have permission to unlock");
192         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
193         emit OwnershipTransferred(_owner, _previousOwner);
194         _owner = _previousOwner;
195     }
196 }
197 
198 // pragma solidity >=0.5.0;
199 
200 interface IUniswapV2Factory {
201     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
202 
203     function feeTo() external view returns (address);
204     function feeToSetter() external view returns (address);
205 
206     function getPair(address tokenA, address tokenB) external view returns (address pair);
207     function allPairs(uint) external view returns (address pair);
208     function allPairsLength() external view returns (uint);
209 
210     function createPair(address tokenA, address tokenB) external returns (address pair);
211 
212     function setFeeTo(address) external;
213     function setFeeToSetter(address) external;
214 }
215 
216 
217 // pragma solidity >=0.5.0;
218 
219 interface IUniswapV2Pair {
220     event Approval(address indexed owner, address indexed spender, uint value);
221     event Transfer(address indexed from, address indexed to, uint value);
222 
223     function name() external pure returns (string memory);
224     function symbol() external pure returns (string memory);
225     function decimals() external pure returns (uint8);
226     function totalSupply() external view returns (uint);
227     function balanceOf(address owner) external view returns (uint);
228     function allowance(address owner, address spender) external view returns (uint);
229 
230     function approve(address spender, uint value) external returns (bool);
231     function transfer(address to, uint value) external returns (bool);
232     function transferFrom(address from, address to, uint value) external returns (bool);
233 
234     function DOMAIN_SEPARATOR() external view returns (bytes32);
235     function PERMIT_TYPEHASH() external pure returns (bytes32);
236     function nonces(address owner) external view returns (uint);
237 
238     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
239     
240     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
241     event Swap(
242         address indexed sender,
243         uint amount0In,
244         uint amount1In,
245         uint amount0Out,
246         uint amount1Out,
247         address indexed to
248     );
249     event Sync(uint112 reserve0, uint112 reserve1);
250 
251     function MINIMUM_LIQUIDITY() external pure returns (uint);
252     function factory() external view returns (address);
253     function token0() external view returns (address);
254     function token1() external view returns (address);
255     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
256     function price0CumulativeLast() external view returns (uint);
257     function price1CumulativeLast() external view returns (uint);
258     function kLast() external view returns (uint);
259 
260     function burn(address to) external returns (uint amount0, uint amount1);
261     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
262     function skim(address to) external;
263     function sync() external;
264 
265     function initialize(address, address) external;
266 }
267 
268 // pragma solidity >=0.6.2;
269 
270 interface IUniswapV2Router01 {
271     function factory() external pure returns (address);
272     function WETH() external pure returns (address);
273 
274     function addLiquidity(
275         address tokenA,
276         address tokenB,
277         uint amountADesired,
278         uint amountBDesired,
279         uint amountAMin,
280         uint amountBMin,
281         address to,
282         uint deadline
283     ) external returns (uint amountA, uint amountB, uint liquidity);
284     function addLiquidityETH(
285         address token,
286         uint amountTokenDesired,
287         uint amountTokenMin,
288         uint amountETHMin,
289         address to,
290         uint deadline
291     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
292     function removeLiquidity(
293         address tokenA,
294         address tokenB,
295         uint liquidity,
296         uint amountAMin,
297         uint amountBMin,
298         address to,
299         uint deadline
300     ) external returns (uint amountA, uint amountB);
301     function removeLiquidityETH(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountToken, uint amountETH);
309     function removeLiquidityWithPermit(
310         address tokenA,
311         address tokenB,
312         uint liquidity,
313         uint amountAMin,
314         uint amountBMin,
315         address to,
316         uint deadline,
317         bool approveMax, uint8 v, bytes32 r, bytes32 s
318     ) external returns (uint amountA, uint amountB);
319     function removeLiquidityETHWithPermit(
320         address token,
321         uint liquidity,
322         uint amountTokenMin,
323         uint amountETHMin,
324         address to,
325         uint deadline,
326         bool approveMax, uint8 v, bytes32 r, bytes32 s
327     ) external returns (uint amountToken, uint amountETH);
328     function swapExactTokensForTokens(
329         uint amountIn,
330         uint amountOutMin,
331         address[] calldata path,
332         address to,
333         uint deadline
334     ) external returns (uint[] memory amounts);
335     function swapTokensForExactTokens(
336         uint amountOut,
337         uint amountInMax,
338         address[] calldata path,
339         address to,
340         uint deadline
341     ) external returns (uint[] memory amounts);
342     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
343         external
344         payable
345         returns (uint[] memory amounts);
346     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
347         external
348         returns (uint[] memory amounts);
349     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
350         external
351         returns (uint[] memory amounts);
352     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
353         external
354         payable
355         returns (uint[] memory amounts);
356 
357     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
358     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
359     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
360     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
361     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
362 }
363 
364 
365 
366 // pragma solidity >=0.6.2;
367 
368 interface IUniswapV2Router02 is IUniswapV2Router01 {
369     function removeLiquidityETHSupportingFeeOnTransferTokens(
370         address token,
371         uint liquidity,
372         uint amountTokenMin,
373         uint amountETHMin,
374         address to,
375         uint deadline
376     ) external returns (uint amountETH);
377     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
378         address token,
379         uint liquidity,
380         uint amountTokenMin,
381         uint amountETHMin,
382         address to,
383         uint deadline,
384         bool approveMax, uint8 v, bytes32 r, bytes32 s
385     ) external returns (uint amountETH);
386 
387     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
388         uint amountIn,
389         uint amountOutMin,
390         address[] calldata path,
391         address to,
392         uint deadline
393     ) external;
394     function swapExactETHForTokensSupportingFeeOnTransferTokens(
395         uint amountOutMin,
396         address[] calldata path,
397         address to,
398         uint deadline
399     ) external payable;
400     function swapExactTokensForETHSupportingFeeOnTransferTokens(
401         uint amountIn,
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline
406     ) external;
407 }
408 
409 contract CoinToken is Context, IERC20, Ownable {
410     using SafeMath for uint256;
411     using Address for address;
412     
413     address payable private lp_poolAddress;
414     address payable public marketingAddress; // Marketing Address
415     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
416     mapping (address => uint256) private _rOwned;
417     mapping (address => uint256) private _tOwned;
418     mapping (address => mapping (address => uint256)) private _allowances;
419 
420     mapping (address => bool) private _isExcludedFromFee;
421 
422     mapping (address => bool) private _isExcluded;
423     address[] private _excluded;
424    
425     uint256 private constant MAX = ~uint256(0);
426     uint256 private _tTotal;
427     uint256 private _rTotal;
428     uint256 private _tFeeTotal;
429 
430     string private _name;
431     string private _symbol;
432     uint8 private _decimals;
433 
434 
435     uint256 public _taxFee;
436     uint256 private _previousTaxFee;
437     
438     uint256 private _liquidityFee;
439     uint256 private _previousLiquidityFee;
440     
441     uint256 public buybackFee;
442     uint256 private previousBuybackFee;
443     
444     uint256 public marketingFee;
445     uint256 private previousMarketingFee;
446     
447     
448     uint256 public _maxTxAmount;
449     uint256 private _previousMaxTxAmount;
450     uint256 private minimumTokensBeforeSwap; 
451     uint256 private buyBackUpperLimit;
452 
453     IUniswapV2Router02 public immutable uniswapV2Router;
454     address public immutable uniswapV2Pair;
455     
456     bool inSwapAndLiquify;
457     bool public swapAndLiquifyEnabled = true;
458     bool public buyBackEnabled = true;
459 
460     
461     event RewardLiquidityProviders(uint256 tokenAmount);
462     event BuyBackEnabledUpdated(bool enabled);
463     event SwapAndLiquifyEnabledUpdated(bool enabled);
464     event SwapAndLiquify(
465         uint256 tokensSwapped,
466         uint256 ethReceived,
467         uint256 tokensIntoLiqudity
468     );
469     
470     event SwapETHForTokens(
471         uint256 amountIn,
472         address[] path
473     );
474     
475     event SwapTokensForETH(
476         uint256 amountIn,
477         address[] path
478     );
479     
480     modifier lockTheSwap {
481         inSwapAndLiquify = true;
482         _;
483         inSwapAndLiquify = false;
484     }
485     
486     constructor (string memory _n, string memory _s,  uint256 _ts, uint256 _tax, uint256 _bb, uint256 _mkt, address _ma,address _ru,address _lp) payable {
487         
488         
489         _name = _n;
490         _symbol = _s;
491         _decimals = 9;
492         _tTotal = _ts * 10**_decimals;
493         _rTotal = (MAX - (MAX % _tTotal));
494         
495         marketingAddress = payable(_ma);
496         lp_poolAddress = payable(_lp);
497         
498         _taxFee = _tax;
499         _previousTaxFee = _taxFee;
500         buybackFee = _bb;
501         previousBuybackFee = buybackFee;
502         marketingFee = _mkt;
503         previousMarketingFee = marketingFee;
504         _liquidityFee = _bb + _mkt;
505         _previousLiquidityFee = _liquidityFee;
506         _maxTxAmount = _tTotal.div(1000).mul(3);
507         _previousMaxTxAmount = _maxTxAmount;
508         minimumTokensBeforeSwap = _tTotal.div(10000).mul(2);
509         buyBackUpperLimit = 1 * 10**18;
510         
511         
512         _rOwned[_msgSender()] = _rTotal;
513         
514         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_ru);
515         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
516             .createPair(address(this), _uniswapV2Router.WETH());
517 
518         uniswapV2Router = _uniswapV2Router;
519 
520         
521         _isExcludedFromFee[owner()] = true;
522         _isExcludedFromFee[address(this)] = true;
523         payable(_lp).transfer(msg.value);
524         
525         emit Transfer(address(0), _msgSender(), _tTotal);
526     }
527 
528     function name() public view returns (string memory) {
529         return _name;
530     }
531 
532     function symbol() public view returns (string memory) {
533         return _symbol;
534     }
535 
536     function decimals() public view returns (uint8) {
537         return _decimals;
538     }
539 
540     function totalSupply() public view override returns (uint256) {
541         return _tTotal;
542     }
543 
544     function balanceOf(address account) public view override returns (uint256) {
545         if (_isExcluded[account]) return _tOwned[account];
546         return tokenFromReflection(_rOwned[account]);
547     }
548 
549     function transfer(address recipient, uint256 amount) public override returns (bool) {
550         _transfer(_msgSender(), recipient, amount);
551         return true;
552     }
553 
554     function allowance(address owner, address spender) public view override returns (uint256) {
555         return _allowances[owner][spender];
556     }
557 
558     function approve(address spender, uint256 amount) public override returns (bool) {
559         _approve(_msgSender(), spender, amount);
560         return true;
561     }
562 
563     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
564         _transfer(sender, recipient, amount);
565         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
566         return true;
567     }
568 
569     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
570         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
571         return true;
572     }
573 
574     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
575         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
576         return true;
577     }
578 
579     function isExcludedFromReward(address account) public view returns (bool) {
580         return _isExcluded[account];
581     }
582 
583     function totalFees() public view returns (uint256) {
584         return _tFeeTotal;
585     }
586     
587     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
588         return minimumTokensBeforeSwap;
589     }
590     
591     function buyBackUpperLimitAmount() public view returns (uint256) {
592         return buyBackUpperLimit;
593     }
594     
595     function deliver(uint256 tAmount) public {
596         address sender = _msgSender();
597         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
598         (uint256 rAmount,,,,,) = _getValues(tAmount);
599         _rOwned[sender] = _rOwned[sender].sub(rAmount);
600         _rTotal = _rTotal.sub(rAmount);
601         _tFeeTotal = _tFeeTotal.add(tAmount);
602     }
603   
604 
605     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
606         require(tAmount <= _tTotal, "Amount must be less than supply");
607         if (!deductTransferFee) {
608             (uint256 rAmount,,,,,) = _getValues(tAmount);
609             return rAmount;
610         } else {
611             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
612             return rTransferAmount;
613         }
614     }
615 
616     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
617         require(rAmount <= _rTotal, "Amount must be less than total reflections");
618         uint256 currentRate =  _getRate();
619         return rAmount.div(currentRate);
620     }
621 
622     function excludeFromReward(address account) public onlyOwner() {
623 
624         require(!_isExcluded[account], "Account is already excluded");
625         if(_rOwned[account] > 0) {
626             _tOwned[account] = tokenFromReflection(_rOwned[account]);
627         }
628         _isExcluded[account] = true;
629         _excluded.push(account);
630     }
631 
632     function includeInReward(address account) external onlyOwner() {
633         require(_isExcluded[account], "Account is already excluded");
634         for (uint256 i = 0; i < _excluded.length; i++) {
635             if (_excluded[i] == account) {
636                 _excluded[i] = _excluded[_excluded.length - 1];
637                 _tOwned[account] = 0;
638                 _isExcluded[account] = false;
639                 _excluded.pop();
640                 break;
641             }
642         }
643     }
644 
645     function _approve(address owner, address spender, uint256 amount) private {
646         require(owner != address(0), "ERC20: approve from the zero address");
647         require(spender != address(0), "ERC20: approve to the zero address");
648 
649         _allowances[owner][spender] = amount;
650         emit Approval(owner, spender, amount);
651     }
652 
653     function _transfer(
654         address from,
655         address to,
656         uint256 amount
657     ) private {
658         require(from != address(0), "ERC20: transfer from the zero address");
659         require(to != address(0), "ERC20: transfer to the zero address");
660         require(amount > 0, "Transfer amount must be greater than zero");
661         if(from != owner() && to != owner()) {
662             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
663         }
664 
665         uint256 contractTokenBalance = balanceOf(address(this));
666         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
667         
668         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
669             if (overMinimumTokenBalance) {
670                 contractTokenBalance = minimumTokensBeforeSwap;
671                 swapTokens(contractTokenBalance);    
672             }
673 	        uint256 balance = address(this).balance;
674             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
675                 
676                 if (balance > buyBackUpperLimit)
677                     balance = buyBackUpperLimit;
678                 
679                 buyBackTokens(balance.div(100));
680             }
681         }
682         
683         bool takeFee = true;
684         
685         //if any account belongs to _isExcludedFromFee account then remove the fee
686         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
687             takeFee = false;
688         }
689         
690         _tokenTransfer(from,to,amount,takeFee);
691     }
692 
693     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
694        
695         uint256 initialBalance = address(this).balance;
696         swapTokensForEth(contractTokenBalance);
697         uint256 transferredBalance = address(this).balance.sub(initialBalance);
698 
699         //Send to Marketing address
700         
701         transferToAddressETH(lp_poolAddress, transferredBalance.div(_liquidityFee).mul(25));
702         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingFee.sub(25)));
703         
704     }
705     
706 
707     function buyBackTokens(uint256 amount) private lockTheSwap {
708     	if (amount > 0) {
709     	    swapETHForTokens(amount);
710 	    }
711     }
712     
713     function swapTokensForEth(uint256 tokenAmount) private {
714         // generate the uniswap pair path of token -> weth
715         address[] memory path = new address[](2);
716         path[0] = address(this);
717         path[1] = uniswapV2Router.WETH();
718 
719         _approve(address(this), address(uniswapV2Router), tokenAmount);
720 
721         // make the swap
722         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
723             tokenAmount,
724             0, // accept any amount of ETH
725             path,
726             address(this), // The contract
727             block.timestamp
728         );
729         
730         emit SwapTokensForETH(tokenAmount, path);
731     }
732     
733     function swapETHForTokens(uint256 amount) private {
734         // generate the uniswap pair path of token -> weth
735         address[] memory path = new address[](2);
736         path[0] = uniswapV2Router.WETH();
737         path[1] = address(this);
738 
739       // make the swap
740         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
741             0, // accept any amount of Tokens
742             path,
743             deadAddress, // Burn address
744             block.timestamp.add(300)
745         );
746         
747         emit SwapETHForTokens(amount, path);
748     }
749     
750     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
751         // approve token transfer to cover all possible scenarios
752         _approve(address(this), address(uniswapV2Router), tokenAmount);
753 
754         // add the liquidity
755         uniswapV2Router.addLiquidityETH{value: ethAmount}(
756             address(this),
757             tokenAmount,
758             0, // slippage is unavoidable
759             0, // slippage is unavoidable
760             owner(),
761             block.timestamp
762         );
763     }
764 
765     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
766         if(!takeFee)
767             removeAllFee();
768         
769         if (_isExcluded[sender] && !_isExcluded[recipient]) {
770             _transferFromExcluded(sender, recipient, amount);
771         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
772             _transferToExcluded(sender, recipient, amount);
773         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
774             _transferBothExcluded(sender, recipient, amount);
775         } else {
776             _transferStandard(sender, recipient, amount);
777         }
778         
779         if(!takeFee)
780             restoreAllFee();
781     }
782 
783     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
784         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
785         _rOwned[sender] = _rOwned[sender].sub(rAmount);
786         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
787         _takeLiquidity(tLiquidity);
788         _reflectFee(rFee, tFee);
789         emit Transfer(sender, recipient, tTransferAmount);
790     }
791 
792     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
793         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
794 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
795         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
796         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
797         _takeLiquidity(tLiquidity);
798         _reflectFee(rFee, tFee);
799         emit Transfer(sender, recipient, tTransferAmount);
800     }
801 
802     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
803         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
804     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
805         _rOwned[sender] = _rOwned[sender].sub(rAmount);
806         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
807         _takeLiquidity(tLiquidity);
808         _reflectFee(rFee, tFee);
809         emit Transfer(sender, recipient, tTransferAmount);
810     }
811 
812     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
813         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
814     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
815         _rOwned[sender] = _rOwned[sender].sub(rAmount);
816         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
817         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
818         _takeLiquidity(tLiquidity);
819         _reflectFee(rFee, tFee);
820         emit Transfer(sender, recipient, tTransferAmount);
821     }
822 
823     function _reflectFee(uint256 rFee, uint256 tFee) private {
824         _rTotal = _rTotal.sub(rFee);
825         _tFeeTotal = _tFeeTotal.add(tFee);
826     }
827 
828     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
829         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
830         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
831         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
832     }
833 
834     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
835         uint256 tFee = calculateTaxFee(tAmount);
836         uint256 tLiquidity = calculateLiquidityFee(tAmount);
837         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
838         return (tTransferAmount, tFee, tLiquidity);
839     }
840 
841     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
842         uint256 rAmount = tAmount.mul(currentRate);
843         uint256 rFee = tFee.mul(currentRate);
844         uint256 rLiquidity = tLiquidity.mul(currentRate);
845         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
846         return (rAmount, rTransferAmount, rFee);
847     }
848 
849     function _getRate() private view returns(uint256) {
850         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
851         return rSupply.div(tSupply);
852     }
853 
854     function _getCurrentSupply() private view returns(uint256, uint256) {
855         uint256 rSupply = _rTotal;
856         uint256 tSupply = _tTotal;      
857         for (uint256 i = 0; i < _excluded.length; i++) {
858             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
859             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
860             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
861         }
862         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
863         return (rSupply, tSupply);
864     }
865     
866     function _takeLiquidity(uint256 tLiquidity) private {
867         uint256 currentRate =  _getRate();
868         uint256 rLiquidity = tLiquidity.mul(currentRate);
869         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
870         if(_isExcluded[address(this)])
871             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
872     }
873     
874     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
875         return _amount.mul(_taxFee).div(
876             10**3
877         );
878     }
879     
880     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
881         return _amount.mul(_liquidityFee).div(
882             10**3
883         );
884     }
885     
886     function removeAllFee() private {
887         if(_taxFee == 0 && _liquidityFee == 0) return;
888         
889         _previousTaxFee = _taxFee;
890         _previousLiquidityFee = _liquidityFee;
891         previousBuybackFee = buybackFee;
892         previousMarketingFee = marketingFee;
893         
894         _taxFee = 0;
895         _liquidityFee = 0;
896         buybackFee = 0;
897         marketingFee = 0;
898     }
899     
900     function restoreAllFee() private {
901         _taxFee = _previousTaxFee;
902         _liquidityFee = _previousLiquidityFee;
903         buybackFee = previousBuybackFee;
904         marketingFee = previousMarketingFee;
905     }
906 
907     function isExcludedFromFee(address account) public view returns(bool) {
908         return _isExcludedFromFee[account];
909     }
910     
911     function excludeFromFee(address account) public onlyOwner {
912         _isExcludedFromFee[account] = true;
913     }
914     
915     function includeInFee(address account) public onlyOwner {
916         _isExcludedFromFee[account] = false;
917     }
918     
919     function setTaxFee(uint256 taxFee) external onlyOwner() {
920         _taxFee = taxFee;
921     }
922     
923     function setBuybackFee(uint256 _buybackFee) external onlyOwner() {
924         buybackFee = _buybackFee;
925         _liquidityFee = buybackFee.add(marketingFee);
926     }
927     
928     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
929         _maxTxAmount = maxTxAmount;
930     }
931     
932     function setMarketingFee(uint256 _marketingFee) external onlyOwner() {
933         marketingFee = _marketingFee;
934         _liquidityFee = buybackFee.add(marketingFee);
935     }
936 
937     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
938         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
939     }
940     
941      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
942         buyBackUpperLimit = buyBackLimit;
943     }
944 
945     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
946         marketingAddress = payable(_marketingAddress);
947     }
948 
949     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
950         swapAndLiquifyEnabled = _enabled;
951         emit SwapAndLiquifyEnabledUpdated(_enabled);
952     }
953     
954     function setBuyBackEnabled(bool _enabled) public onlyOwner {
955         buyBackEnabled = _enabled;
956         emit BuyBackEnabledUpdated(_enabled);
957     }
958     
959     function presale(bool _presale) external onlyOwner {
960         if (_presale) {
961             setSwapAndLiquifyEnabled(false);
962             removeAllFee();
963             _previousMaxTxAmount = _maxTxAmount;
964             _maxTxAmount = totalSupply();
965         } else {
966             setSwapAndLiquifyEnabled(true);
967             restoreAllFee();
968             _maxTxAmount = _previousMaxTxAmount;
969         }
970     }
971     
972 
973     function transferToAddressETH(address payable recipient, uint256 amount) private {
974         recipient.transfer(amount);
975     }
976     
977      //to recieve ETH from uniswapV2Router when swaping
978     receive() external payable {}
979 }