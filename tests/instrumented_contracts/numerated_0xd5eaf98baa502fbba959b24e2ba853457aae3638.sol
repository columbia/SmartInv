1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
411 contract ANUBISINU is Context, IERC20, Ownable {
412     using SafeMath for uint256;
413     using Address for address;
414     
415     address payable public marketingAddress = payable(0xFcbf6A38E13EcA136CAd13edbABCA827B72cc0DA); // Marketing Address
416     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
417     mapping (address => uint256) private _rOwned;
418     mapping (address => uint256) private _tOwned;
419     mapping (address => mapping (address => uint256)) private _allowances;
420 
421     mapping (address => bool) private _isExcludedFromFee;
422 
423     mapping (address => bool) private _isExcluded;
424     address[] private _excluded;
425    
426     uint256 private constant MAX = ~uint256(0);
427     uint256 private _tTotal = 1000000000000 * 10**9;
428     uint256 private _rTotal = (MAX - (MAX % _tTotal));
429     uint256 private _tFeeTotal;
430 
431     string private _name = "ANUBIS INU";
432     string private _symbol = "$ANUBI";
433     uint8 private _decimals = 9;
434 
435 
436     uint256 public _taxFee = 1;
437     uint256 private _previousTaxFee = _taxFee;
438     
439     uint256 public _liquidityFee = 11;
440     uint256 private _previousLiquidityFee = _liquidityFee;
441     
442     uint256 public marketingDivisor = 9;
443     
444     uint256 public _maxTxAmount = 1000000000000 * 10**9; // 10 trillion, or 1% of total supply
445     uint256 private minimumTokensBeforeSwap = 200000 * 10**9; 
446     uint256 private buyBackUpperLimit = 1 * 10**18;
447 
448     IUniswapV2Router02 public immutable uniswapV2Router;
449     address public immutable uniswapV2Pair;
450     
451     bool inSwapAndLiquify;
452     bool public swapAndLiquifyEnabled = false;
453     bool public buyBackEnabled = true;
454 
455     
456     event RewardLiquidityProviders(uint256 tokenAmount);
457     event BuyBackEnabledUpdated(bool enabled);
458     event SwapAndLiquifyEnabledUpdated(bool enabled);
459     event SwapAndLiquify(
460         uint256 tokensSwapped,
461         uint256 ethReceived,
462         uint256 tokensIntoLiqudity
463     );
464     
465     event SwapETHForTokens(
466         uint256 amountIn,
467         address[] path
468     );
469     
470     event SwapTokensForETH(
471         uint256 amountIn,
472         address[] path
473     );
474     
475     modifier lockTheSwap {
476         inSwapAndLiquify = true;
477         _;
478         inSwapAndLiquify = false;
479     }
480     
481     constructor () {
482         _rOwned[_msgSender()] = _rTotal;
483         
484         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
485         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
486             .createPair(address(this), _uniswapV2Router.WETH());
487 
488         uniswapV2Router = _uniswapV2Router;
489 
490         
491         _isExcludedFromFee[owner()] = true;
492         _isExcludedFromFee[address(this)] = true;
493         
494         emit Transfer(address(0), _msgSender(), _tTotal);
495     }
496 
497     function name() public view returns (string memory) {
498         return _name;
499     }
500 
501     function symbol() public view returns (string memory) {
502         return _symbol;
503     }
504 
505     function decimals() public view returns (uint8) {
506         return _decimals;
507     }
508 
509     function totalSupply() public view override returns (uint256) {
510         return _tTotal;
511     }
512 
513     function balanceOf(address account) public view override returns (uint256) {
514         if (_isExcluded[account]) return _tOwned[account];
515         return tokenFromReflection(_rOwned[account]);
516     }
517 
518     function transfer(address recipient, uint256 amount) public override returns (bool) {
519         _transfer(_msgSender(), recipient, amount);
520         return true;
521     }
522 
523     function allowance(address owner, address spender) public view override returns (uint256) {
524         return _allowances[owner][spender];
525     }
526 
527     function approve(address spender, uint256 amount) public override returns (bool) {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
533         _transfer(sender, recipient, amount);
534         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
535         return true;
536     }
537 
538     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
539         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
540         return true;
541     }
542 
543     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
544         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
545         return true;
546     }
547 
548     function isExcludedFromReward(address account) public view returns (bool) {
549         return _isExcluded[account];
550     }
551 
552     function totalFees() public view returns (uint256) {
553         return _tFeeTotal;
554     }
555     
556     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
557         return minimumTokensBeforeSwap;
558     }
559     
560     function buyBackUpperLimitAmount() public view returns (uint256) {
561         return buyBackUpperLimit;
562     }
563     
564     function deliver(uint256 tAmount) public {
565         address sender = _msgSender();
566         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
567         (uint256 rAmount,,,,,) = _getValues(tAmount);
568         _rOwned[sender] = _rOwned[sender].sub(rAmount);
569         _rTotal = _rTotal.sub(rAmount);
570         _tFeeTotal = _tFeeTotal.add(tAmount);
571     }
572   
573 
574     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
575         require(tAmount <= _tTotal, "Amount must be less than supply");
576         if (!deductTransferFee) {
577             (uint256 rAmount,,,,,) = _getValues(tAmount);
578             return rAmount;
579         } else {
580             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
581             return rTransferAmount;
582         }
583     }
584 
585     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
586         require(rAmount <= _rTotal, "Amount must be less than total reflections");
587         uint256 currentRate =  _getRate();
588         return rAmount.div(currentRate);
589     }
590 
591     function excludeFromReward(address account) public onlyOwner() {
592 
593         require(!_isExcluded[account], "Account is already excluded");
594         if(_rOwned[account] > 0) {
595             _tOwned[account] = tokenFromReflection(_rOwned[account]);
596         }
597         _isExcluded[account] = true;
598         _excluded.push(account);
599     }
600 
601     function includeInReward(address account) external onlyOwner() {
602         require(_isExcluded[account], "Account is already excluded");
603         for (uint256 i = 0; i < _excluded.length; i++) {
604             if (_excluded[i] == account) {
605                 _excluded[i] = _excluded[_excluded.length - 1];
606                 _tOwned[account] = 0;
607                 _isExcluded[account] = false;
608                 _excluded.pop();
609                 break;
610             }
611         }
612     }
613 
614     function _approve(address owner, address spender, uint256 amount) private {
615         require(owner != address(0), "ERC20: approve from the zero address");
616         require(spender != address(0), "ERC20: approve to the zero address");
617 
618         _allowances[owner][spender] = amount;
619         emit Approval(owner, spender, amount);
620     }
621 
622     function _transfer(
623         address from,
624         address to,
625         uint256 amount
626     ) private {
627         require(from != address(0), "ERC20: transfer from the zero address");
628         require(to != address(0), "ERC20: transfer to the zero address");
629         require(amount > 0, "Transfer amount must be greater than zero");
630         if(from != owner() && to != owner()) {
631             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
632         }
633 
634         uint256 contractTokenBalance = balanceOf(address(this));
635         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
636         
637         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
638             if (overMinimumTokenBalance) {
639                 contractTokenBalance = minimumTokensBeforeSwap;
640                 swapTokens(contractTokenBalance);    
641             }
642 	        uint256 balance = address(this).balance;
643             if (buyBackEnabled /*&& balance > uint256(1 * 10**18)*/) {
644                 
645                 if (balance > buyBackUpperLimit)
646                     balance = buyBackUpperLimit;
647                 
648                 buyBackTokens(balance.div(100));
649             }
650         }
651         
652         bool takeFee = true;
653         
654         //if any account belongs to _isExcludedFromFee account then remove the fee
655         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
656             takeFee = false;
657         }
658         
659         _tokenTransfer(from,to,amount,takeFee);
660     }
661     
662  
663 
664     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
665        
666         uint256 initialBalance = address(this).balance;
667         swapTokensForEth(contractTokenBalance);
668         uint256 transferredBalance = address(this).balance.sub(initialBalance);
669 
670         //Send to Marketing address
671         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
672         
673     }
674     
675 
676     function buyBackTokens(uint256 amount) private lockTheSwap {
677     	if (amount > 0) {
678     	    swapETHForTokens(amount);
679 	    }
680     }
681     
682     function swapTokensForEth(uint256 tokenAmount) private {
683         // generate the uniswap pair path of token -> weth
684         address[] memory path = new address[](2);
685         path[0] = address(this);
686         path[1] = uniswapV2Router.WETH();
687 
688         _approve(address(this), address(uniswapV2Router), tokenAmount);
689 
690         // make the swap
691         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
692             tokenAmount,
693             0, // accept any amount of ETH
694             path,
695             address(this), // The contract
696             block.timestamp
697         );
698         
699         emit SwapTokensForETH(tokenAmount, path);
700     }
701     
702     function swapETHForTokens(uint256 amount) private {
703         // generate the uniswap pair path of token -> weth
704         address[] memory path = new address[](2);
705         path[0] = uniswapV2Router.WETH();
706         path[1] = address(this);
707 
708       // make the swap
709         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
710             0, // accept any amount of Tokens
711             path,
712             deadAddress, // Burn address
713             block.timestamp.add(300)
714         );
715         
716         emit SwapETHForTokens(amount, path);
717     }
718     
719     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
720         // approve token transfer to cover all possible scenarios
721         _approve(address(this), address(uniswapV2Router), tokenAmount);
722 
723         // add the liquidity
724         uniswapV2Router.addLiquidityETH{value: ethAmount}(
725             address(this),
726             tokenAmount,
727             0, // slippage is unavoidable
728             0, // slippage is unavoidable
729             owner(),
730             block.timestamp
731         );
732     }
733 
734     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
735         if(!takeFee)
736             removeAllFee();
737         
738         if (_isExcluded[sender] && !_isExcluded[recipient]) {
739             _transferFromExcluded(sender, recipient, amount);
740         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
741             _transferToExcluded(sender, recipient, amount);
742         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
743             _transferBothExcluded(sender, recipient, amount);
744         } else {
745             _transferStandard(sender, recipient, amount);
746         }
747         
748         if(!takeFee)
749             restoreAllFee();
750     }
751 
752     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
753         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
754         _rOwned[sender] = _rOwned[sender].sub(rAmount);
755         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
756         _takeLiquidity(tLiquidity);
757         _reflectFee(rFee, tFee);
758         emit Transfer(sender, recipient, tTransferAmount);
759     }
760 
761     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
762         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
763 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
764         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
765         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
766         _takeLiquidity(tLiquidity);
767         _reflectFee(rFee, tFee);
768         emit Transfer(sender, recipient, tTransferAmount);
769     }
770 
771     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
772         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
773     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
774         _rOwned[sender] = _rOwned[sender].sub(rAmount);
775         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
776         _takeLiquidity(tLiquidity);
777         _reflectFee(rFee, tFee);
778         emit Transfer(sender, recipient, tTransferAmount);
779     }
780 
781     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
782         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
783     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
784         _rOwned[sender] = _rOwned[sender].sub(rAmount);
785         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
786         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
787         _takeLiquidity(tLiquidity);
788         _reflectFee(rFee, tFee);
789         emit Transfer(sender, recipient, tTransferAmount);
790     }
791 
792     function _reflectFee(uint256 rFee, uint256 tFee) private {
793         _rTotal = _rTotal.sub(rFee);
794         _tFeeTotal = _tFeeTotal.add(tFee);
795     }
796 
797     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
798         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
799         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
800         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
801     }
802 
803     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
804         uint256 tFee = calculateTaxFee(tAmount);
805         uint256 tLiquidity = calculateLiquidityFee(tAmount);
806         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
807         return (tTransferAmount, tFee, tLiquidity);
808     }
809 
810     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
811         uint256 rAmount = tAmount.mul(currentRate);
812         uint256 rFee = tFee.mul(currentRate);
813         uint256 rLiquidity = tLiquidity.mul(currentRate);
814         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
815         return (rAmount, rTransferAmount, rFee);
816     }
817 
818     function _getRate() private view returns(uint256) {
819         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
820         return rSupply.div(tSupply);
821     }
822 
823     function _getCurrentSupply() private view returns(uint256, uint256) {
824         uint256 rSupply = _rTotal;
825         uint256 tSupply = _tTotal;      
826         for (uint256 i = 0; i < _excluded.length; i++) {
827             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
828             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
829             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
830         }
831         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
832         return (rSupply, tSupply);
833     }
834     
835     function _takeLiquidity(uint256 tLiquidity) private {
836         uint256 currentRate =  _getRate();
837         uint256 rLiquidity = tLiquidity.mul(currentRate);
838         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
839         if(_isExcluded[address(this)])
840             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
841     }
842     
843     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
844         return _amount.mul(_taxFee).div(
845             10**2
846         );
847     }
848     
849     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
850         return _amount.mul(_liquidityFee).div(
851             10**2
852         );
853     }
854     
855     function removeAllFee() private {
856         if(_taxFee == 0 && _liquidityFee == 0) return;
857         
858         _previousTaxFee = _taxFee;
859         _previousLiquidityFee = _liquidityFee;
860         
861         _taxFee = 0;
862         _liquidityFee = 0;
863     }
864     
865     function restoreAllFee() private {
866         _taxFee = _previousTaxFee;
867         _liquidityFee = _previousLiquidityFee;
868     }
869 
870     function isExcludedFromFee(address account) public view returns(bool) {
871         return _isExcludedFromFee[account];
872     }
873     
874     function excludeFromFee(address account) public onlyOwner {
875         _isExcludedFromFee[account] = true;
876     }
877     
878     function includeInFee(address account) public onlyOwner {
879         _isExcludedFromFee[account] = false;
880     }
881     
882     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
883         _taxFee = taxFee;
884     }
885     
886     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
887         _liquidityFee = liquidityFee;
888     }
889     
890     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
891         _maxTxAmount = maxTxAmount;
892     }
893     
894     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
895         marketingDivisor = divisor;
896     }
897 
898     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
899         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
900     }
901     
902      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
903         buyBackUpperLimit = buyBackLimit * 10**18;
904     }
905 
906     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
907         marketingAddress = payable(_marketingAddress);
908     }
909 
910     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
911         swapAndLiquifyEnabled = _enabled;
912         emit SwapAndLiquifyEnabledUpdated(_enabled);
913     }
914     
915     function setBuyBackEnabled(bool _enabled) public onlyOwner {
916         buyBackEnabled = _enabled;
917         emit BuyBackEnabledUpdated(_enabled);
918     }
919     
920     function prepareForPreSale() external onlyOwner {
921         setSwapAndLiquifyEnabled(false);
922         _taxFee = 0;
923         _liquidityFee = 0;
924         _maxTxAmount = 1000000000 * 10**9;
925     }
926     
927     function afterPreSale() external onlyOwner {
928         setSwapAndLiquifyEnabled(true);
929         _taxFee = 2;
930         _liquidityFee = 9;
931         _maxTxAmount = 10000000 * 10**9;
932     }
933     
934     function transferToAddressETH(address payable recipient, uint256 amount) private {
935         recipient.transfer(amount);
936     }
937     
938      //to recieve ETH from uniswapV2Router when swaping
939     receive() external payable {}
940 }