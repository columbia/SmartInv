1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
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
26     
27 
28 }
29 
30 library SafeMath {
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57 
58         return c;
59     }
60 
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         return mod(a, b, "SafeMath: modulo by zero");
76     }
77 
78     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b != 0, errorMessage);
80         return a % b;
81     }
82 }
83 
84 library Address {
85 
86     function isContract(address account) internal view returns (bool) {
87         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
88         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
89         // for accounts without code, i.e. `keccak256('')`
90         bytes32 codehash;
91         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
92         // solhint-disable-next-line no-inline-assembly
93         assembly { codehash := extcodehash(account) }
94         return (codehash != accountHash && codehash != 0x0);
95     }
96 
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(address(this).balance >= amount, "Address: insufficient balance");
99 
100         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
101         (bool success, ) = recipient.call{ value: amount }("");
102         require(success, "Address: unable to send value, recipient may have reverted");
103     }
104 
105 
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107       return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
111         return _functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
127         if (success) {
128             return returndata;
129         } else {
130             
131             if (returndata.length > 0) {
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 contract Ownable is Context {
144     address private _owner;
145     address private _previousOwner;
146     uint256 private _lockTime;
147 
148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150     constructor () {
151         address msgSender = _msgSender();
152         _owner = msgSender;
153         emit OwnershipTransferred(address(0), msgSender);
154     }
155 
156     function owner() public view returns (address) {
157         return _owner;
158     }   
159     
160     modifier onlyOwner() {
161         require(_owner == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164     
165     function renounceOwnership() public virtual onlyOwner {
166         emit OwnershipTransferred(_owner, address(0));
167         _owner = address(0);
168     }
169 
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         emit OwnershipTransferred(_owner, newOwner);
173         _owner = newOwner;
174     }
175 
176     function getUnlockTime() public view returns (uint256) {
177         return _lockTime;
178     }
179     
180     function getTime() public view returns (uint256) {
181         return block.timestamp;
182     }
183 
184     function lock(uint256 time) public virtual onlyOwner {
185         _previousOwner = _owner;
186         _owner = address(0);
187         _lockTime = block.timestamp + time;
188         emit OwnershipTransferred(_owner, address(0));
189     }
190     
191     function unlock() public virtual {
192         require(_previousOwner == msg.sender, "You don't have permission to unlock");
193         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
194         emit OwnershipTransferred(_owner, _previousOwner);
195         _owner = _previousOwner;
196     }
197 }
198 
199 // pragma solidity >=0.5.0;
200 
201 interface IUniswapV2Factory {
202     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
203 
204     function feeTo() external view returns (address);
205     function feeToSetter() external view returns (address);
206 
207     function getPair(address tokenA, address tokenB) external view returns (address pair);
208     function allPairs(uint) external view returns (address pair);
209     function allPairsLength() external view returns (uint);
210 
211     function createPair(address tokenA, address tokenB) external returns (address pair);
212 
213     function setFeeTo(address) external;
214     function setFeeToSetter(address) external;
215 }
216 
217 
218 // pragma solidity >=0.5.0;
219 
220 interface IUniswapV2Pair {
221     event Approval(address indexed owner, address indexed spender, uint value);
222     event Transfer(address indexed from, address indexed to, uint value);
223 
224     function name() external pure returns (string memory);
225     function symbol() external pure returns (string memory);
226     function decimals() external pure returns (uint8);
227     function totalSupply() external view returns (uint);
228     function balanceOf(address owner) external view returns (uint);
229     function allowance(address owner, address spender) external view returns (uint);
230 
231     function approve(address spender, uint value) external returns (bool);
232     function transfer(address to, uint value) external returns (bool);
233     function transferFrom(address from, address to, uint value) external returns (bool);
234 
235     function DOMAIN_SEPARATOR() external view returns (bytes32);
236     function PERMIT_TYPEHASH() external pure returns (bytes32);
237     function nonces(address owner) external view returns (uint);
238 
239     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
240     
241     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
242     event Swap(
243         address indexed sender,
244         uint amount0In,
245         uint amount1In,
246         uint amount0Out,
247         uint amount1Out,
248         address indexed to
249     );
250     event Sync(uint112 reserve0, uint112 reserve1);
251 
252     function MINIMUM_LIQUIDITY() external pure returns (uint);
253     function factory() external view returns (address);
254     function token0() external view returns (address);
255     function token1() external view returns (address);
256     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
257     function price0CumulativeLast() external view returns (uint);
258     function price1CumulativeLast() external view returns (uint);
259     function kLast() external view returns (uint);
260 
261     function burn(address to) external returns (uint amount0, uint amount1);
262     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
263     function skim(address to) external;
264     function sync() external;
265 
266     function initialize(address, address) external;
267 }
268 
269 // pragma solidity >=0.6.2;
270 
271 interface IUniswapV2Router01 {
272     function factory() external pure returns (address);
273     function WETH() external pure returns (address);
274 
275     function addLiquidity(
276         address tokenA,
277         address tokenB,
278         uint amountADesired,
279         uint amountBDesired,
280         uint amountAMin,
281         uint amountBMin,
282         address to,
283         uint deadline
284     ) external returns (uint amountA, uint amountB, uint liquidity);
285     function addLiquidityETH(
286         address token,
287         uint amountTokenDesired,
288         uint amountTokenMin,
289         uint amountETHMin,
290         address to,
291         uint deadline
292     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
293     function removeLiquidity(
294         address tokenA,
295         address tokenB,
296         uint liquidity,
297         uint amountAMin,
298         uint amountBMin,
299         address to,
300         uint deadline
301     ) external returns (uint amountA, uint amountB);
302     function removeLiquidityETH(
303         address token,
304         uint liquidity,
305         uint amountTokenMin,
306         uint amountETHMin,
307         address to,
308         uint deadline
309     ) external returns (uint amountToken, uint amountETH);
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
320     function removeLiquidityETHWithPermit(
321         address token,
322         uint liquidity,
323         uint amountTokenMin,
324         uint amountETHMin,
325         address to,
326         uint deadline,
327         bool approveMax, uint8 v, bytes32 r, bytes32 s
328     ) external returns (uint amountToken, uint amountETH);
329     function swapExactTokensForTokens(
330         uint amountIn,
331         uint amountOutMin,
332         address[] calldata path,
333         address to,
334         uint deadline
335     ) external returns (uint[] memory amounts);
336     function swapTokensForExactTokens(
337         uint amountOut,
338         uint amountInMax,
339         address[] calldata path,
340         address to,
341         uint deadline
342     ) external returns (uint[] memory amounts);
343     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
344         external
345         payable
346         returns (uint[] memory amounts);
347     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
348         external
349         returns (uint[] memory amounts);
350     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
351         external
352         returns (uint[] memory amounts);
353     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
354         external
355         payable
356         returns (uint[] memory amounts);
357 
358     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
359     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
360     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
361     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
362     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
363 }
364 
365 
366 
367 // pragma solidity >=0.6.2;
368 
369 interface IUniswapV2Router02 is IUniswapV2Router01 {
370     function removeLiquidityETHSupportingFeeOnTransferTokens(
371         address token,
372         uint liquidity,
373         uint amountTokenMin,
374         uint amountETHMin,
375         address to,
376         uint deadline
377     ) external returns (uint amountETH);
378     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
379         address token,
380         uint liquidity,
381         uint amountTokenMin,
382         uint amountETHMin,
383         address to,
384         uint deadline,
385         bool approveMax, uint8 v, bytes32 r, bytes32 s
386     ) external returns (uint amountETH);
387 
388     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
389         uint amountIn,
390         uint amountOutMin,
391         address[] calldata path,
392         address to,
393         uint deadline
394     ) external;
395     function swapExactETHForTokensSupportingFeeOnTransferTokens(
396         uint amountOutMin,
397         address[] calldata path,
398         address to,
399         uint deadline
400     ) external payable;
401     function swapExactTokensForETHSupportingFeeOnTransferTokens(
402         uint amountIn,
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external;
408 }
409 
410 contract Promodio is Context, IERC20, Ownable {
411     using SafeMath for uint256;
412     using Address for address;
413     
414     address payable public marketingAddress = payable(0xE68eD8563F6b91750E7d3a636785EB93ce5e2aB4); // Marketing Address
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
426     uint256 private _tTotal = 2000 * 10**6 * 10**9;
427     uint256 private _rTotal = (MAX - (MAX % _tTotal));
428     uint256 private _tFeeTotal;
429 
430     string private _name = "Promodio";
431     string private _symbol = "PMD";
432     uint8 private _decimals = 9;
433 
434 
435     uint256 public _taxFee = 2;
436     uint256 private _previousTaxFee = _taxFee;
437     
438     uint256 public _liquidityFee = 9;
439     uint256 private _previousLiquidityFee = _liquidityFee;
440     
441     uint256 public marketingDivisor = 3;
442     
443     uint256 public _maxTxAmount = 3000000 * 10**6 * 10**9;
444     uint256 private minimumTokensBeforeSwap = 200000 * 10**6 * 10**9; 
445     uint256 private buyBackUpperLimit = 1 * 10**18;
446 
447     IUniswapV2Router02 public immutable uniswapV2Router;
448     address public immutable uniswapV2Pair;
449     
450     bool inSwapAndLiquify;
451     bool public swapAndLiquifyEnabled = false;
452     bool public buyBackEnabled = true;
453 
454     
455     event RewardLiquidityProviders(uint256 tokenAmount);
456     event BuyBackEnabledUpdated(bool enabled);
457     event SwapAndLiquifyEnabledUpdated(bool enabled);
458     event SwapAndLiquify(
459         uint256 tokensSwapped,
460         uint256 ethReceived,
461         uint256 tokensIntoLiqudity
462     );
463     
464     event SwapETHForTokens(
465         uint256 amountIn,
466         address[] path
467     );
468     
469     event SwapTokensForETH(
470         uint256 amountIn,
471         address[] path
472     );
473     
474     modifier lockTheSwap {
475         inSwapAndLiquify = true;
476         _;
477         inSwapAndLiquify = false;
478     }
479     
480     constructor ()  payable{
481         _rOwned[_msgSender()] = _rTotal;
482         
483         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
484         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
485             .createPair(address(this), _uniswapV2Router.WETH());
486 
487         uniswapV2Router = _uniswapV2Router;
488 
489         
490         _isExcludedFromFee[owner()] = true;
491         _isExcludedFromFee[address(this)] = true;
492         
493         emit Transfer(address(0), _msgSender(), _tTotal);
494     }
495 
496     function name() public view returns (string memory) {
497         return _name;
498     }
499 
500     function symbol() public view returns (string memory) {
501         return _symbol;
502     }
503 
504     function decimals() public view returns (uint8) {
505         return _decimals;
506     }
507 
508     function totalSupply() public view override returns (uint256) {
509         return _tTotal;
510     }
511 
512     function balanceOf(address account) public view override returns (uint256) {
513         if (_isExcluded[account]) return _tOwned[account];
514         return tokenFromReflection(_rOwned[account]);
515     }
516 
517     function transfer(address recipient, uint256 amount) public override returns (bool) {
518         _transfer(_msgSender(), recipient, amount);
519         return true;
520     }
521 
522     function allowance(address owner, address spender) public view override returns (uint256) {
523         return _allowances[owner][spender];
524     }
525 
526     function approve(address spender, uint256 amount) public override returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
532         _transfer(sender, recipient, amount);
533         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
534         return true;
535     }
536 
537     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
539         return true;
540     }
541 
542     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
543         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
544         return true;
545     }
546 
547     function isExcludedFromReward(address account) public view returns (bool) {
548         return _isExcluded[account];
549     }
550 
551     function totalFees() public view returns (uint256) {
552         return _tFeeTotal;
553     }
554     
555     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
556         return minimumTokensBeforeSwap;
557     }
558     
559     function buyBackUpperLimitAmount() public view returns (uint256) {
560         return buyBackUpperLimit;
561     }
562     
563     function deliver(uint256 tAmount) public {
564         address sender = _msgSender();
565         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
566         (uint256 rAmount,,,,,) = _getValues(tAmount);
567         _rOwned[sender] = _rOwned[sender].sub(rAmount);
568         _rTotal = _rTotal.sub(rAmount);
569         _tFeeTotal = _tFeeTotal.add(tAmount);
570     }
571   
572 
573     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
574         require(tAmount <= _tTotal, "Amount must be less than supply");
575         if (!deductTransferFee) {
576             (uint256 rAmount,,,,,) = _getValues(tAmount);
577             return rAmount;
578         } else {
579             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
580             return rTransferAmount;
581         }
582     }
583 
584     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
585         require(rAmount <= _rTotal, "Amount must be less than total reflections");
586         uint256 currentRate =  _getRate();
587         return rAmount.div(currentRate);
588     }
589 
590     function excludeFromReward(address account) public onlyOwner() {
591 
592         require(!_isExcluded[account], "Account is already excluded");
593         if(_rOwned[account] > 0) {
594             _tOwned[account] = tokenFromReflection(_rOwned[account]);
595         }
596         _isExcluded[account] = true;
597         _excluded.push(account);
598     }
599 
600     function includeInReward(address account) external onlyOwner() {
601         require(_isExcluded[account], "Account is already excluded");
602         for (uint256 i = 0; i < _excluded.length; i++) {
603             if (_excluded[i] == account) {
604                 _excluded[i] = _excluded[_excluded.length - 1];
605                 _tOwned[account] = 0;
606                 _isExcluded[account] = false;
607                 _excluded.pop();
608                 break;
609             }
610         }
611     }
612 
613     function _approve(address owner, address spender, uint256 amount) private {
614         require(owner != address(0), "ERC20: approve from the zero address");
615         require(spender != address(0), "ERC20: approve to the zero address");
616 
617         _allowances[owner][spender] = amount;
618         emit Approval(owner, spender, amount);
619     }
620 
621     function _transfer(
622         address from,
623         address to,
624         uint256 amount
625     ) private {
626         require(from != address(0), "ERC20: transfer from the zero address");
627         require(to != address(0), "ERC20: transfer to the zero address");
628         require(amount > 0, "Transfer amount must be greater than zero");
629         if(from != owner() && to != owner()) {
630             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
631         }
632 
633         uint256 contractTokenBalance = balanceOf(address(this));
634         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
635         
636         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
637             if (overMinimumTokenBalance) {
638                 contractTokenBalance = minimumTokensBeforeSwap;
639                 swapTokens(contractTokenBalance);    
640             }
641 	        uint256 balance = address(this).balance;
642             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
643                 
644                 if (balance > buyBackUpperLimit)
645                     balance = buyBackUpperLimit;
646                 
647                 buyBackTokens(balance.div(100));
648             }
649         }
650         
651         bool takeFee = true;
652         
653         //if any account belongs to _isExcludedFromFee account then remove the fee
654         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
655             takeFee = false;
656         }
657         
658         _tokenTransfer(from,to,amount,takeFee);
659     }
660 
661     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
662        
663         uint256 initialBalance = address(this).balance;
664         swapTokensForEth(contractTokenBalance);
665         uint256 transferredBalance = address(this).balance.sub(initialBalance);
666 
667         //Send to Marketing address
668         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
669         
670     }
671     
672 
673     function buyBackTokens(uint256 amount) private lockTheSwap {
674     	if (amount > 0) {
675     	    swapETHForTokens(amount);
676 	    }
677     }
678     
679     function swapTokensForEth(uint256 tokenAmount) private {
680         // generate the uniswap pair path of token -> weth
681         address[] memory path = new address[](2);
682         path[0] = address(this);
683         path[1] = uniswapV2Router.WETH();
684 
685         _approve(address(this), address(uniswapV2Router), tokenAmount);
686 
687         // make the swap
688         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
689             tokenAmount,
690             0, // accept any amount of ETH
691             path,
692             address(this), // The contract
693             block.timestamp
694         );
695         
696         emit SwapTokensForETH(tokenAmount, path);
697     }
698     
699     function swapETHForTokens(uint256 amount) private {
700         // generate the uniswap pair path of token -> weth
701         address[] memory path = new address[](2);
702         path[0] = uniswapV2Router.WETH();
703         path[1] = address(this);
704 
705       // make the swap
706         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
707             0, // accept any amount of Tokens
708             path,
709             deadAddress, // Burn address
710             block.timestamp.add(300)
711         );
712         
713         emit SwapETHForTokens(amount, path);
714     }
715     
716     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
717         // approve token transfer to cover all possible scenarios
718         _approve(address(this), address(uniswapV2Router), tokenAmount);
719 
720         // add the liquidity
721         uniswapV2Router.addLiquidityETH{value: ethAmount}(
722             address(this),
723             tokenAmount,
724             0, // slippage is unavoidable
725             0, // slippage is unavoidable
726             owner(),
727             block.timestamp
728         );
729     }
730 
731     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
732         if(!takeFee)
733             removeAllFee();
734         
735         if (_isExcluded[sender] && !_isExcluded[recipient]) {
736             _transferFromExcluded(sender, recipient, amount);
737         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
738             _transferToExcluded(sender, recipient, amount);
739         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
740             _transferBothExcluded(sender, recipient, amount);
741         } else {
742             _transferStandard(sender, recipient, amount);
743         }
744         
745         if(!takeFee)
746             restoreAllFee();
747     }
748 
749     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
750         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
751         _rOwned[sender] = _rOwned[sender].sub(rAmount);
752         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
753         _takeLiquidity(tLiquidity);
754         _reflectFee(rFee, tFee);
755         emit Transfer(sender, recipient, tTransferAmount);
756     }
757 
758     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
759         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
760 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
761         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
762         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
763         _takeLiquidity(tLiquidity);
764         _reflectFee(rFee, tFee);
765         emit Transfer(sender, recipient, tTransferAmount);
766     }
767 
768     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
769         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
770     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
771         _rOwned[sender] = _rOwned[sender].sub(rAmount);
772         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
773         _takeLiquidity(tLiquidity);
774         _reflectFee(rFee, tFee);
775         emit Transfer(sender, recipient, tTransferAmount);
776     }
777 
778     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
779         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
780     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
781         _rOwned[sender] = _rOwned[sender].sub(rAmount);
782         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
783         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
784         _takeLiquidity(tLiquidity);
785         _reflectFee(rFee, tFee);
786         emit Transfer(sender, recipient, tTransferAmount);
787     }
788 
789     function _reflectFee(uint256 rFee, uint256 tFee) private {
790         _rTotal = _rTotal.sub(rFee);
791         _tFeeTotal = _tFeeTotal.add(tFee);
792     }
793 
794     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
795         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
796         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
797         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
798     }
799 
800     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
801         uint256 tFee = calculateTaxFee(tAmount);
802         uint256 tLiquidity = calculateLiquidityFee(tAmount);
803         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
804         return (tTransferAmount, tFee, tLiquidity);
805     }
806 
807     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
808         uint256 rAmount = tAmount.mul(currentRate);
809         uint256 rFee = tFee.mul(currentRate);
810         uint256 rLiquidity = tLiquidity.mul(currentRate);
811         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
812         return (rAmount, rTransferAmount, rFee);
813     }
814 
815     function _getRate() private view returns(uint256) {
816         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
817         return rSupply.div(tSupply);
818     }
819 
820     function _getCurrentSupply() private view returns(uint256, uint256) {
821         uint256 rSupply = _rTotal;
822         uint256 tSupply = _tTotal;      
823         for (uint256 i = 0; i < _excluded.length; i++) {
824             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
825             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
826             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
827         }
828         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
829         return (rSupply, tSupply);
830     }
831     
832     function _takeLiquidity(uint256 tLiquidity) private {
833         uint256 currentRate =  _getRate();
834         uint256 rLiquidity = tLiquidity.mul(currentRate);
835         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
836         if(_isExcluded[address(this)])
837             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
838     }
839     
840     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
841         return _amount.mul(_taxFee).div(
842             10**2
843         );
844     }
845     
846     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
847         return _amount.mul(_liquidityFee).div(
848             10**2
849         );
850     }
851     
852     function removeAllFee() private {
853         if(_taxFee == 0 && _liquidityFee == 0) return;
854         
855         _previousTaxFee = _taxFee;
856         _previousLiquidityFee = _liquidityFee;
857         
858         _taxFee = 0;
859         _liquidityFee = 0;
860     }
861     
862     function restoreAllFee() private {
863         _taxFee = _previousTaxFee;
864         _liquidityFee = _previousLiquidityFee;
865     }
866 
867     function isExcludedFromFee(address account) public view returns(bool) {
868         return _isExcludedFromFee[account];
869     }
870     
871     function excludeFromFee(address account) public onlyOwner {
872         _isExcludedFromFee[account] = true;
873     }
874     
875     function includeInFee(address account) public onlyOwner {
876         _isExcludedFromFee[account] = false;
877     }
878     
879     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
880         _taxFee = taxFee;
881     }
882     
883     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
884         _liquidityFee = liquidityFee;
885     }
886     
887     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
888         _maxTxAmount = maxTxAmount;
889     }
890     
891     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
892         marketingDivisor = divisor;
893     }
894 
895     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
896         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
897     }
898     
899      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
900         buyBackUpperLimit = buyBackLimit * 10**18;
901     }
902 
903     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
904         marketingAddress = payable(_marketingAddress);
905     }
906 
907     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
908         swapAndLiquifyEnabled = _enabled;
909         emit SwapAndLiquifyEnabledUpdated(_enabled);
910     }
911     
912     function setBuyBackEnabled(bool _enabled) public onlyOwner {
913         buyBackEnabled = _enabled;
914         emit BuyBackEnabledUpdated(_enabled);
915     }
916     
917     function prepareForPreSale() external onlyOwner {
918         setSwapAndLiquifyEnabled(false);
919         _taxFee = 0;
920         _liquidityFee = 0;
921         _maxTxAmount = 1000000000 * 10**6 * 10**9;
922     }
923     
924     function afterPreSale() external onlyOwner {
925         setSwapAndLiquifyEnabled(true);
926         _taxFee = 2;
927         _liquidityFee = 9;
928         _maxTxAmount = 3000000 * 10**6 * 10**9;
929     }
930     
931     function transferToAddressETH(address payable recipient, uint256 amount) private {
932         recipient.transfer(amount);
933     }
934     
935      //to recieve ETH from uniswapV2Router when swaping
936     receive() external payable {}
937 }