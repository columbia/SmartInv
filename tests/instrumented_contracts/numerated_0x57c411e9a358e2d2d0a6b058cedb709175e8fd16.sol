1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.7;
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
218 interface IUniswapV2Pair {
219     event Approval(address indexed owner, address indexed spender, uint value);
220     event Transfer(address indexed from, address indexed to, uint value);
221 
222     function name() external pure returns (string memory);
223     function symbol() external pure returns (string memory);
224     function decimals() external pure returns (uint8);
225     function totalSupply() external view returns (uint);
226     function balanceOf(address owner) external view returns (uint);
227     function allowance(address owner, address spender) external view returns (uint);
228 
229     function approve(address spender, uint value) external returns (bool);
230     function transfer(address to, uint value) external returns (bool);
231     function transferFrom(address from, address to, uint value) external returns (bool);
232 
233     function DOMAIN_SEPARATOR() external view returns (bytes32);
234     function PERMIT_TYPEHASH() external pure returns (bytes32);
235     function nonces(address owner) external view returns (uint);
236 
237     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
238     
239     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
240     event Swap(
241         address indexed sender,
242         uint amount0In,
243         uint amount1In,
244         uint amount0Out,
245         uint amount1Out,
246         address indexed to
247     );
248     event Sync(uint112 reserve0, uint112 reserve1);
249 
250     function MINIMUM_LIQUIDITY() external pure returns (uint);
251     function factory() external view returns (address);
252     function token0() external view returns (address);
253     function token1() external view returns (address);
254     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
255     function price0CumulativeLast() external view returns (uint);
256     function price1CumulativeLast() external view returns (uint);
257     function kLast() external view returns (uint);
258 
259     function burn(address to) external returns (uint amount0, uint amount1);
260     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
261     function skim(address to) external;
262     function sync() external;
263 
264     function initialize(address, address) external;
265 }
266 
267 
268 interface IUniswapV2Router01 {
269     function factory() external pure returns (address);
270     function WETH() external pure returns (address);
271 
272     function addLiquidity(
273         address tokenA,
274         address tokenB,
275         uint amountADesired,
276         uint amountBDesired,
277         uint amountAMin,
278         uint amountBMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountA, uint amountB, uint liquidity);
282     function addLiquidityETH(
283         address token,
284         uint amountTokenDesired,
285         uint amountTokenMin,
286         uint amountETHMin,
287         address to,
288         uint deadline
289     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
290     function removeLiquidity(
291         address tokenA,
292         address tokenB,
293         uint liquidity,
294         uint amountAMin,
295         uint amountBMin,
296         address to,
297         uint deadline
298     ) external returns (uint amountA, uint amountB);
299     function removeLiquidityETH(
300         address token,
301         uint liquidity,
302         uint amountTokenMin,
303         uint amountETHMin,
304         address to,
305         uint deadline
306     ) external returns (uint amountToken, uint amountETH);
307     function removeLiquidityWithPermit(
308         address tokenA,
309         address tokenB,
310         uint liquidity,
311         uint amountAMin,
312         uint amountBMin,
313         address to,
314         uint deadline,
315         bool approveMax, uint8 v, bytes32 r, bytes32 s
316     ) external returns (uint amountA, uint amountB);
317     function removeLiquidityETHWithPermit(
318         address token,
319         uint liquidity,
320         uint amountTokenMin,
321         uint amountETHMin,
322         address to,
323         uint deadline,
324         bool approveMax, uint8 v, bytes32 r, bytes32 s
325     ) external returns (uint amountToken, uint amountETH);
326     function swapExactTokensForTokens(
327         uint amountIn,
328         uint amountOutMin,
329         address[] calldata path,
330         address to,
331         uint deadline
332     ) external returns (uint[] memory amounts);
333     function swapTokensForExactTokens(
334         uint amountOut,
335         uint amountInMax,
336         address[] calldata path,
337         address to,
338         uint deadline
339     ) external returns (uint[] memory amounts);
340     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
341         external
342         payable
343         returns (uint[] memory amounts);
344     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
345         external
346         returns (uint[] memory amounts);
347     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
348         external
349         returns (uint[] memory amounts);
350     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
351         external
352         payable
353         returns (uint[] memory amounts);
354 
355     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
356     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
357     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
358     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
359     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
360 }
361 
362 
363 
364 interface IUniswapV2Router02 is IUniswapV2Router01 {
365     function removeLiquidityETHSupportingFeeOnTransferTokens(
366         address token,
367         uint liquidity,
368         uint amountTokenMin,
369         uint amountETHMin,
370         address to,
371         uint deadline
372     ) external returns (uint amountETH);
373     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
374         address token,
375         uint liquidity,
376         uint amountTokenMin,
377         uint amountETHMin,
378         address to,
379         uint deadline,
380         bool approveMax, uint8 v, bytes32 r, bytes32 s
381     ) external returns (uint amountETH);
382 
383     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
384         uint amountIn,
385         uint amountOutMin,
386         address[] calldata path,
387         address to,
388         uint deadline
389     ) external;
390     function swapExactETHForTokensSupportingFeeOnTransferTokens(
391         uint amountOutMin,
392         address[] calldata path,
393         address to,
394         uint deadline
395     ) external payable;
396     function swapExactTokensForETHSupportingFeeOnTransferTokens(
397         uint amountIn,
398         uint amountOutMin,
399         address[] calldata path,
400         address to,
401         uint deadline
402     ) external;
403 }
404 
405 contract KodachiToken is Context, IERC20, Ownable {
406     using SafeMath for uint256;
407     using Address for address;
408     
409     address payable public marketingAddress = payable(0x805B9Bd203ad2B69A241AE5084abEE11183f9429); // Marketing Address
410     address payable public devAddress = payable(0xfD22068Bf2C956bD6f4ab812F11354FB7d7dea35); // Dev Address
411     mapping (address => uint256) private _rOwned;
412     mapping (address => uint256) private _tOwned;
413     mapping (address => mapping (address => uint256)) private _allowances;
414 
415     mapping (address => bool) private _isExcludedFromFee;
416 
417     mapping (address => bool) private _isExcluded;
418     address[] private _excluded;
419 
420     mapping (address => bool) private _isBlacklisted;
421    
422     uint256 private constant MAX = ~uint256(0);
423     uint256 private _tTotal = 100 * 10**9 * 10**18; // 100 Bn tokens
424     uint256 private _rTotal = (MAX - (MAX % _tTotal));
425     uint256 private _tFeeTotal;
426 
427     string private _name = "Kodachi Token";
428     string private _symbol = "KODACHI";
429     uint8 private _decimals = 18;
430 
431 
432     uint256 public _taxFee = 20;  // rfi tax
433     uint256 private _previousTaxFee = _taxFee;
434     
435     uint256 public marketingDivisor = 40;
436     uint256 public devDivisor = 20;
437     uint256 public autoLpDivisor = 20;
438 
439     uint256 public _totalFee = 80;  // marketingDivisor + devDivisor + autoLpDivisor
440     uint256 private _previousTotalFee = _totalFee;
441     uint256 public sellFactor = 20; // divided by 10
442     bool public isBuyTaxEnabled = true;
443 
444     uint256 public _maxTxAmount = 100 * 10**6 * 10**18;
445     uint256 private minimumTokensBeforeSwap = 1 * 10**6 * 10**18; 
446 
447     IUniswapV2Router02 public immutable uniswapV2Router;
448     address public immutable uniswapV2Pair;
449     
450     bool inSwapAndLiquify;
451     bool public swapAndLiquifyEnabled = false;
452     // bool public contractLockEnabled = true;
453 
454     // event ContractLockEnabledUpdated(bool enabled);
455     event FeesUpdated(uint256 autoLpDivisor, uint256 devDivisor, uint256 marketingDivisor);
456     event TaxUpdated(uint256 taxFee);
457     event SellFactorUpdated(uint256 previousSellFactor, uint256 newSellFactor);
458     event BuyTaxEnabled(bool indexed enable, uint256 blockNumber);
459 
460     event SwapAndLiquifyEnabledUpdated(bool enabled);
461     event SwapAndLiquify(
462         uint256 tokensSwapped,
463         uint256 ethReceived,
464         uint256 tokensIntoLiqudity
465     );
466     
467     event SwapTokensForETH(
468         uint256 amountIn,
469         address[] path
470     );
471 
472 
473     
474     modifier lockTheSwap {
475         inSwapAndLiquify = true;
476         _;
477         inSwapAndLiquify = false;
478     }
479     
480     constructor () {        
481         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
482         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
483             .createPair(address(this), _uniswapV2Router.WETH());
484 
485         uniswapV2Router = _uniswapV2Router;
486 
487         _rOwned[owner()] = _rTotal;
488         
489         _isExcludedFromFee[owner()] = true;
490         _isExcludedFromFee[address(this)] = true;
491         
492         emit Transfer(address(0), owner(), _tTotal);
493     }
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
508         return _tTotal;
509     }
510 
511     function balanceOf(address account) public view override returns (uint256) {
512         if (_isExcluded[account]) return _tOwned[account];
513         return tokenFromReflection(_rOwned[account]);
514     }
515 
516     function transfer(address recipient, uint256 amount) public override returns (bool) {
517         _transfer(_msgSender(), recipient, amount);
518         return true;
519     }
520 
521     function allowance(address owner, address spender) public view override returns (uint256) {
522         return _allowances[owner][spender];
523     }
524 
525     function approve(address spender, uint256 amount) public override returns (bool) {
526         _approve(_msgSender(), spender, amount);
527         return true;
528     }
529 
530     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
531         _transfer(sender, recipient, amount);
532         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
533         return true;
534     }
535 
536     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
537         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
538         return true;
539     }
540 
541     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
542         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
543         return true;
544     }
545 
546     function isExcludedFromReward(address account) public view returns (bool) {
547         return _isExcluded[account];
548     }
549 
550     function totalFees() public view returns (uint256) {
551         return _tFeeTotal;
552     }
553     
554     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
555         return minimumTokensBeforeSwap;
556     }
557     
558     function deliver(uint256 tAmount) public {
559         address sender = _msgSender();
560         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
561         (uint256 rAmount,,,,,) = _getValues(tAmount,false);
562         _rOwned[sender] = _rOwned[sender].sub(rAmount);
563         _rTotal = _rTotal.sub(rAmount);
564         _tFeeTotal = _tFeeTotal.add(tAmount);
565     }
566   
567 
568     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
569         require(tAmount <= _tTotal, "Amount must be less than supply");
570         if (!deductTransferFee) {
571             (uint256 rAmount,,,,,) = _getValues(tAmount, false);
572             return rAmount;
573         } else {
574             (,uint256 rTransferAmount,,,,) = _getValues(tAmount, false);
575             return rTransferAmount;
576         }
577     }
578 
579     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
580         require(rAmount <= _rTotal, "Amount must be less than total reflections");
581         uint256 currentRate =  _getRate();
582         return rAmount.div(currentRate);
583     }
584 
585     function excludeFromReward(address account) public onlyOwner() {
586 
587         require(!_isExcluded[account], "Account is already excluded");
588         if(_rOwned[account] > 0) {
589             _tOwned[account] = tokenFromReflection(_rOwned[account]);
590         }
591         _isExcluded[account] = true;
592         _excluded.push(account);
593     }
594 
595     function includeInReward(address account) external onlyOwner() {
596         require(_isExcluded[account], "Account is already excluded");
597         for (uint256 i = 0; i < _excluded.length; i++) {
598             if (_excluded[i] == account) {
599                 _excluded[i] = _excluded[_excluded.length - 1];
600                 _rOwned[account] = _tOwned[account].mul(_getRate());
601                 _tOwned[account] = 0;
602                 _isExcluded[account] = false;
603                 _excluded.pop();
604                 break;
605             }
606         }
607     }
608 
609     function _approve(address owner, address spender, uint256 amount) private {
610         require(owner != address(0), "ERC20: approve from the zero address");
611         require(spender != address(0), "ERC20: approve to the zero address");
612 
613         _allowances[owner][spender] = amount;
614         emit Approval(owner, spender, amount);
615     }
616 
617     function _transfer(
618         address from,
619         address to,
620         uint256 amount
621     ) private {
622         require(from != address(0), "ERC20: transfer from the zero address");
623         require(!_isBlacklisted[to], "This address is currently blacklisted");
624         require(!_isBlacklisted[from], "This address is currently blacklisted");
625 
626         if(from != owner() && to != owner()) {
627             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
628         }
629 
630         uint256 contractTokenBalance = balanceOf(address(this));
631         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
632         
633         if (overMinimumTokenBalance && !inSwapAndLiquify && swapAndLiquifyEnabled && from != uniswapV2Pair) {
634             if (overMinimumTokenBalance) {
635                 contractTokenBalance = minimumTokensBeforeSwap;
636                 swapTokens(contractTokenBalance);    
637             }
638         }
639         
640         bool takeFee = true;
641         
642         //if any account belongs to _isExcludedFromFee account then remove the fee
643         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
644             takeFee = false;
645         }
646         bool isSell = from != uniswapV2Pair ? true : false;
647 
648         if(!isBuyTaxEnabled && !isSell) {
649             takeFee = false;
650         }
651         _tokenTransfer(from,to,amount,takeFee,isSell);
652     }
653 
654     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
655        
656         uint256 amountToLiquify = contractTokenBalance.mul(autoLpDivisor).div(_totalFee).div(2);
657         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
658 
659         uint256 initialBalance = address(this).balance;
660         swapTokensForEth(amountToSwap);
661         uint256 transferredBalance = address(this).balance.sub(initialBalance);
662         uint256 totalETHFee = _totalFee.sub(autoLpDivisor.div(2));
663 
664         // adding liquidity
665         if(amountToLiquify > 0) // enabling to set autoLP tax to zero
666             addLiquidity(amountToLiquify, transferredBalance.mul(autoLpDivisor).div(totalETHFee).div(2));
667 
668         //Send to Marketing and dev address
669         transferToAddressETH(marketingAddress, transferredBalance.mul(marketingDivisor).div(totalETHFee));
670         transferToAddressETH(devAddress, transferredBalance.mul(devDivisor).div(totalETHFee));
671         
672     }
673     
674     function swapTokensForEth(uint256 tokenAmount) private {
675         // generate the uniswap pair path of token -> weth
676         address[] memory path = new address[](2);
677         path[0] = address(this);
678         path[1] = uniswapV2Router.WETH();
679 
680         _approve(address(this), address(uniswapV2Router), tokenAmount);
681 
682         // make the swap
683         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
684             tokenAmount,
685             0, // accept any amount of ETH
686             path,
687             address(this), // The contract
688             block.timestamp
689         );
690         
691         emit SwapTokensForETH(tokenAmount, path);
692     }
693     
694     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
695         // approve token transfer to cover all possible scenarios
696         _approve(address(this), address(uniswapV2Router), tokenAmount);
697 
698         // add the liquidity
699         uniswapV2Router.addLiquidityETH{value: ethAmount}(
700             address(this),
701             tokenAmount,
702             0, // slippage is unavoidable
703             0, // slippage is unavoidable
704             address(this),
705             block.timestamp
706         );
707     }
708 
709     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee, bool isSell) private {
710         if(!takeFee)
711             removeAllFee();
712         
713         if (_isExcluded[sender] && !_isExcluded[recipient]) {
714             _transferFromExcluded(sender, recipient, amount, isSell);
715         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
716             _transferToExcluded(sender, recipient, amount, isSell);
717         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
718             _transferBothExcluded(sender, recipient, amount, isSell);
719         } else {
720             _transferStandard(sender, recipient, amount, isSell);
721         }
722         
723         if(!takeFee)
724             restoreAllFee();
725     }
726 
727     function _transferStandard(address sender, address recipient, uint256 tAmount, bool isSell) private {
728         (uint256 rAmount, uint256 rTransferAmount, uint256 rTax, uint256 tTransferAmount, uint256 tTax, uint256 tFee) = _getValues(tAmount, isSell);
729         _rOwned[sender] = _rOwned[sender].sub(rAmount);
730         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
731         _takeTeam(tFee);
732         _reflectFee(rTax, tTax);
733         emit Transfer(sender, recipient, tTransferAmount);
734     }
735 
736     function _transferToExcluded(address sender, address recipient, uint256 tAmount, bool isSell) private {
737         (uint256 rAmount, uint256 rTransferAmount, uint256 rTax, uint256 tTransferAmount, uint256 tTax, uint256 tFee) = _getValues(tAmount, isSell);
738         _rOwned[sender] = _rOwned[sender].sub(rAmount);
739         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
740         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
741         _takeTeam(tFee);
742         _reflectFee(rTax, tTax);
743         emit Transfer(sender, recipient, tTransferAmount);
744     }
745 
746     function _transferFromExcluded(address sender, address recipient, uint256 tAmount, bool isSell) private {
747         (uint256 rAmount, uint256 rTransferAmount, uint256 rTax, uint256 tTransferAmount, uint256 tTax, uint256 tFee) = _getValues(tAmount, isSell);
748         _tOwned[sender] = _tOwned[sender].sub(tAmount);
749         _rOwned[sender] = _rOwned[sender].sub(rAmount);
750         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
751         _takeTeam(tFee);
752         _reflectFee(rTax, tTax);
753         emit Transfer(sender, recipient, tTransferAmount);
754     }
755 
756     function _transferBothExcluded(address sender, address recipient, uint256 tAmount, bool isSell) private {
757         (uint256 rAmount, uint256 rTransferAmount, uint256 rTax, uint256 tTransferAmount, uint256 tTax, uint256 tFee) = _getValues(tAmount, isSell);
758         _tOwned[sender] = _tOwned[sender].sub(tAmount);
759         _rOwned[sender] = _rOwned[sender].sub(rAmount);
760         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
761         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
762         _takeTeam(tFee);
763         _reflectFee(rTax, tTax);
764         emit Transfer(sender, recipient, tTransferAmount);
765     }
766 
767     function _reflectFee(uint256 rTax, uint256 tTax) private {
768         _rTotal = _rTotal.sub(rTax);
769         _tFeeTotal = _tFeeTotal.add(tTax);
770     }
771 
772     function _getValues(uint256 tAmount, bool isSell) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
773         (uint256 tTransferAmount, uint256 tTax, uint256 tFee) = _getTValues(tAmount, isSell);
774         (uint256 rAmount, uint256 rTransferAmount, uint256 rTax) = _getRValues(tAmount, tTax, tFee, _getRate());
775         return (rAmount, rTransferAmount, rTax, tTransferAmount, tTax, tFee);
776     }
777 
778     function _getTValues(uint256 tAmount, bool isSell) private view returns (uint256, uint256, uint256) {
779         uint256 tTax = isSell ? calculateTaxFee(tAmount).mul(sellFactor).div(10) : calculateTaxFee(tAmount);
780         uint256 tFee = isSell ? calculateTotalFee(tAmount).mul(sellFactor).div(10) : calculateTotalFee(tAmount);
781         uint256 tTransferAmount = tAmount.sub(tTax).sub(tFee);
782         return (tTransferAmount, tTax, tFee);
783     }
784 
785     function _getRValues(uint256 tAmount, uint256 tTax, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
786         uint256 rAmount = tAmount.mul(currentRate);
787         uint256 rTax = tTax.mul(currentRate);
788         uint256 rFee = tFee.mul(currentRate);
789         uint256 rTransferAmount = rAmount.sub(rTax).sub(rFee);
790         return (rAmount, rTransferAmount, rTax);
791     }
792 
793     function _getRate() private view returns(uint256) {
794         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
795         return rSupply.div(tSupply);
796     }
797 
798     function _getCurrentSupply() private view returns(uint256, uint256) {
799         uint256 rSupply = _rTotal;
800         uint256 tSupply = _tTotal;      
801         for (uint256 i = 0; i < _excluded.length; i++) {
802             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
803             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
804             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
805         }
806         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
807         return (rSupply, tSupply);
808     }
809     
810     function _takeTeam(uint256 tFee) private {
811         uint256 currentRate =  _getRate();
812         uint256 rFee = tFee.mul(currentRate);
813         _rOwned[address(this)] = _rOwned[address(this)].add(rFee);
814         if(_isExcluded[address(this)])
815             _tOwned[address(this)] = _tOwned[address(this)].add(tFee);
816     }
817     
818     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
819         return _amount.mul(_taxFee).div(
820             10**3
821         );
822     }
823     
824     function calculateTotalFee(uint256 _amount) private view returns (uint256) {
825         return _amount.mul(_totalFee).div(
826             10**3
827         );
828     }
829     
830     function removeAllFee() private {
831         if(_taxFee == 0 && _totalFee == 0) return;
832         
833         _previousTaxFee = _taxFee;
834         _previousTotalFee = _totalFee;
835         
836         _taxFee = 0;
837         _totalFee = 0;
838     }
839     
840     function restoreAllFee() private {
841         _taxFee = _previousTaxFee;
842         _totalFee = _previousTotalFee;
843     }
844 
845     function isExcludedFromFee(address account) public view returns(bool) {
846         return _isExcludedFromFee[account];
847     }
848     
849     function excludeFromFee(address account) public onlyOwner {
850         _isExcludedFromFee[account] = true;
851     }
852     
853     function includeInFee(address account) public onlyOwner {
854         _isExcludedFromFee[account] = false;
855     }
856     
857     function isBlacklisted(address account) public view returns(bool) {
858         return _isBlacklisted[account];
859     }
860 
861     function blacklistAccount(address account) public onlyOwner {
862         require(account != uniswapV2Pair, "can not blacklist pair contract");
863         _isBlacklisted[account] = true;
864     }
865 
866     function unBlacklistAccount(address account) public onlyOwner {
867         _isBlacklisted[account] = false;
868     }
869 
870     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
871         _taxFee = taxFee;
872 
873         emit TaxUpdated(taxFee);
874     }
875     
876 
877     function updateFeeDivisor(uint256 newAutoLpDivisor, uint256 newDevDivisor, uint256 newMarketingDivisor) external onlyOwner {
878         uint256 newTotalFee = newAutoLpDivisor.add(newDevDivisor).add(newMarketingDivisor);
879         require( newTotalFee <= 200, "cant set fees to more than 20%");
880 
881         autoLpDivisor = newAutoLpDivisor;
882         devDivisor = newDevDivisor;
883         marketingDivisor = newMarketingDivisor;
884 
885         _previousTotalFee = _totalFee;
886         _totalFee = newTotalFee;
887 
888         emit FeesUpdated(newAutoLpDivisor, newDevDivisor, newMarketingDivisor);
889     }
890     
891     
892     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
893         _maxTxAmount = maxTxAmount;
894     }
895     
896 
897     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
898         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
899     }
900     
901     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
902         marketingAddress = payable(_marketingAddress);
903     }
904 
905     function setDevAddress(address _devAddress) external onlyOwner() {
906         devAddress = payable(_devAddress);
907     }
908 
909     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
910         swapAndLiquifyEnabled = _enabled;
911         emit SwapAndLiquifyEnabledUpdated(_enabled);
912     }
913 
914     function updateSellFactor(uint256 _sellFactor) external onlyOwner {
915         emit SellFactorUpdated(sellFactor, _sellFactor);
916 
917         sellFactor = _sellFactor;
918     }
919 
920     function setBuyTaxEnabled(bool _enable) external onlyOwner {
921         require(isBuyTaxEnabled != _enable, "Already set");
922         isBuyTaxEnabled = _enable;
923 
924         emit BuyTaxEnabled(_enable, block.number);
925     }
926 
927     function transferToAddressETH(address payable recipient, uint256 amount) private {
928         recipient.transfer(amount);
929     }
930     
931      //to recieve ETH from uniswapV2Router when swaping
932     receive() external payable {}
933 }