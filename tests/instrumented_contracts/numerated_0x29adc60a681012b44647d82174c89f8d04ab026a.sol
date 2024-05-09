1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-30
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
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
149     address private _owner;
150     address private _previousOwner;
151     uint256 private _lockTime;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     constructor () {
156         address msgSender = _msgSender();
157         _owner = msgSender;
158         emit OwnershipTransferred(address(0), msgSender);
159     }
160 
161     function owner() public view returns (address) {
162         return _owner;
163     }   
164     
165     modifier onlyOwner() {
166         require(_owner == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169     
170     function renounceOwnership() public virtual onlyOwner {
171         emit OwnershipTransferred(_owner, address(0));
172         _owner = address(0);
173     }
174 
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         emit OwnershipTransferred(_owner, newOwner);
178         _owner = newOwner;
179     }
180 }
181 
182 // pragma solidity >=0.5.0;
183 
184 interface IUniswapV2Factory {
185     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
186 
187     function feeTo() external view returns (address);
188     function feeToSetter() external view returns (address);
189 
190     function getPair(address tokenA, address tokenB) external view returns (address pair);
191     function allPairs(uint) external view returns (address pair);
192     function allPairsLength() external view returns (uint);
193 
194     function createPair(address tokenA, address tokenB) external returns (address pair);
195 
196     function setFeeTo(address) external;
197     function setFeeToSetter(address) external;
198 }
199 
200 
201 // pragma solidity >=0.5.0;
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
252 // pragma solidity >=0.6.2;
253 
254 interface IUniswapV2Router01 {
255     function factory() external pure returns (address);
256     function WETH() external pure returns (address);
257 
258     function addLiquidity(
259         address tokenA,
260         address tokenB,
261         uint amountADesired,
262         uint amountBDesired,
263         uint amountAMin,
264         uint amountBMin,
265         address to,
266         uint deadline
267     ) external returns (uint amountA, uint amountB, uint liquidity);
268     function addLiquidityETH(
269         address token,
270         uint amountTokenDesired,
271         uint amountTokenMin,
272         uint amountETHMin,
273         address to,
274         uint deadline
275     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
276     function removeLiquidity(
277         address tokenA,
278         address tokenB,
279         uint liquidity,
280         uint amountAMin,
281         uint amountBMin,
282         address to,
283         uint deadline
284     ) external returns (uint amountA, uint amountB);
285     function removeLiquidityETH(
286         address token,
287         uint liquidity,
288         uint amountTokenMin,
289         uint amountETHMin,
290         address to,
291         uint deadline
292     ) external returns (uint amountToken, uint amountETH);
293     function removeLiquidityWithPermit(
294         address tokenA,
295         address tokenB,
296         uint liquidity,
297         uint amountAMin,
298         uint amountBMin,
299         address to,
300         uint deadline,
301         bool approveMax, uint8 v, bytes32 r, bytes32 s
302     ) external returns (uint amountA, uint amountB);
303     function removeLiquidityETHWithPermit(
304         address token,
305         uint liquidity,
306         uint amountTokenMin,
307         uint amountETHMin,
308         address to,
309         uint deadline,
310         bool approveMax, uint8 v, bytes32 r, bytes32 s
311     ) external returns (uint amountToken, uint amountETH);
312     function swapExactTokensForTokens(
313         uint amountIn,
314         uint amountOutMin,
315         address[] calldata path,
316         address to,
317         uint deadline
318     ) external returns (uint[] memory amounts);
319     function swapTokensForExactTokens(
320         uint amountOut,
321         uint amountInMax,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external returns (uint[] memory amounts);
326     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
327         external
328         payable
329         returns (uint[] memory amounts);
330     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
331         external
332         returns (uint[] memory amounts);
333     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
334         external
335         returns (uint[] memory amounts);
336     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
337         external
338         payable
339         returns (uint[] memory amounts);
340 
341     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
342     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
343     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
344     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
345     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
346 }
347 
348 
349 
350 // pragma solidity >=0.6.2;
351 
352 interface IUniswapV2Router02 is IUniswapV2Router01 {
353     function removeLiquidityETHSupportingFeeOnTransferTokens(
354         address token,
355         uint liquidity,
356         uint amountTokenMin,
357         uint amountETHMin,
358         address to,
359         uint deadline
360     ) external returns (uint amountETH);
361     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
362         address token,
363         uint liquidity,
364         uint amountTokenMin,
365         uint amountETHMin,
366         address to,
367         uint deadline,
368         bool approveMax, uint8 v, bytes32 r, bytes32 s
369     ) external returns (uint amountETH);
370 
371     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
372         uint amountIn,
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline
377     ) external;
378     function swapExactETHForTokensSupportingFeeOnTransferTokens(
379         uint amountOutMin,
380         address[] calldata path,
381         address to,
382         uint deadline
383     ) external payable;
384     function swapExactTokensForETHSupportingFeeOnTransferTokens(
385         uint amountIn,
386         uint amountOutMin,
387         address[] calldata path,
388         address to,
389         uint deadline
390     ) external;
391 }
392 
393 contract ZANININU is Context, IERC20, Ownable {
394     using SafeMath for uint256;
395     using Address for address;
396     
397     address payable public marketingAddress = payable(0x5260438dCaFf2ABfAA05B6EFaC502C38eB9FA88F); // Marketing Address
398     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
399     mapping (address => uint256) private _rOwned;
400     mapping (address => uint256) private _tOwned;
401     mapping (address => mapping (address => uint256)) private _allowances;
402     mapping (address => bool) private _isSniper;
403     address[] private _confirmedSnipers;
404 
405     mapping (address => bool) private _isExcludedFromFee;
406     mapping (address => bool) private _isExcluded;
407     address[] private _excluded;
408    
409     uint256 private constant MAX = ~uint256(0);
410     uint256 private _tTotal = 1000000000000000 * 10**9;
411     uint256 private _rTotal = (MAX - (MAX % _tTotal));
412     uint256 private _tFeeTotal;
413 
414     string private _name = "ZANIN INU";
415     string private _symbol = "ZANI";
416     uint8 private _decimals = 9;
417 
418 
419     uint256 public _taxFee;
420     uint256 private _previousTaxFee = _taxFee;
421     
422     uint256 private _liquidityFee;
423     uint256 private _previousLiquidityFee = _liquidityFee;
424 
425     mapping(address => bool) public Limtcheck;
426     
427     uint256 private _feeRate = 2;
428     uint256 launchTime;
429 
430     IUniswapV2Router02 public uniswapV2Router;
431     address public uniswapV2Pair;
432     
433     uint256 public maxTX =1000000000000000e9;
434      uint256 public maxWallet =30000000000000e9;
435  
436     bool inSwapAndLiquify;
437     
438     bool tradingOpen = false;
439     
440     bool public opensellTx=true;
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
458 
459     constructor () {
460         _rOwned[_msgSender()] = _rTotal;
461         openTrading();
462         emit Transfer(address(0), _msgSender(), _tTotal);
463     }
464     
465     
466     function initContract() external onlyOwner() {
467         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
468         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
469         .createPair(address(this), _uniswapV2Router.WETH());
470 
471         uniswapV2Router = _uniswapV2Router;
472 
473         _isExcludedFromFee[owner()] = true;
474         _isExcludedFromFee[address(this)] = true;
475         marketingAddress = payable(marketingAddress);
476 
477          Limtcheck[_msgSender()]=true;
478         Limtcheck[address(uniswapV2Router)]=true;
479         Limtcheck[uniswapV2Pair]=true;
480          Limtcheck[marketingAddress]=true;
481     }
482     
483     function openTrading() internal {
484         _liquidityFee=5;
485         _taxFee=0;
486         tradingOpen = true;
487         launchTime = block.timestamp;
488     }
489 
490     function name() public view returns (string memory) {
491         return _name;
492     }
493 
494     function symbol() public view returns (string memory) {
495         return _symbol;
496     }
497 
498     function decimals() public view returns (uint8) {
499         return _decimals;
500     }
501 
502     function totalSupply() public view override returns (uint256) {
503         return _tTotal;
504     }
505 
506     function balanceOf(address account) public view override returns (uint256) {
507         if (_isExcluded[account]) return _tOwned[account];
508         return tokenFromReflection(_rOwned[account]);
509     }
510 
511     function transfer(address recipient, uint256 amount) public override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     function allowance(address owner, address spender) public view override returns (uint256) {
517         return _allowances[owner][spender];
518     }
519 
520     function approve(address spender, uint256 amount) public override returns (bool) {
521         _approve(_msgSender(), spender, amount);
522         return true;
523     }
524 
525     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
526         _transfer(sender, recipient, amount);
527         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
528         return true;
529     }
530 
531     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
532         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
533         return true;
534     }
535 
536     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
537         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
538         return true;
539     }
540 
541     function isExcludedFromReward(address account) public view returns (bool) {
542         return _isExcluded[account];
543     }
544 
545     function totalFees() public view returns (uint256) {
546         return _tFeeTotal;
547     }
548     
549   function ExcludeLimitcheck(address _addr,bool _status) public onlyOwner() {
550         Limtcheck[_addr]=_status;
551     }
552     
553     function deliver(uint256 tAmount) public {
554         address sender = _msgSender();
555         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
556         (uint256 rAmount,,,,,) = _getValues(tAmount);
557         _rOwned[sender] = _rOwned[sender].sub(rAmount);
558         _rTotal = _rTotal.sub(rAmount);
559         _tFeeTotal = _tFeeTotal.add(tAmount);
560     }
561   
562 
563     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
564         require(tAmount <= _tTotal, "Amount must be less than supply");
565         if (!deductTransferFee) {
566             (uint256 rAmount,,,,,) = _getValues(tAmount);
567             return rAmount;
568         } else {
569             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
570             return rTransferAmount;
571         }
572     }
573 
574     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
575         require(rAmount <= _rTotal, "Amount must be less than total reflections");
576         uint256 currentRate =  _getRate();
577         return rAmount.div(currentRate);
578     }
579 
580     function excludeFromReward(address account) public onlyOwner() {
581 
582         require(!_isExcluded[account], "Account is already excluded");
583         if(_rOwned[account] > 0) {
584             _tOwned[account] = tokenFromReflection(_rOwned[account]);
585         }
586         _isExcluded[account] = true;
587         _excluded.push(account);
588     }
589 
590     function includeInReward(address account) external onlyOwner() {
591         require(_isExcluded[account], "Account is already excluded");
592         for (uint256 i = 0; i < _excluded.length; i++) {
593             if (_excluded[i] == account) {
594                 _excluded[i] = _excluded[_excluded.length - 1];
595                 _tOwned[account] = 0;
596                 _isExcluded[account] = false;
597                 _excluded.pop();
598                 break;
599             }
600         }
601     }
602 
603     function _approve(address owner, address spender, uint256 amount) private {
604         require(owner != address(0), "ERC20: approve from the zero address");
605         require(spender != address(0), "ERC20: approve to the zero address");
606 
607         _allowances[owner][spender] = amount;
608         emit Approval(owner, spender, amount);
609     }
610 
611     function _transfer(
612         address from,
613         address to,
614         uint256 amount
615     ) private {
616         require(from != address(0), "ERC20: transfer from the zero address");
617         require(to != address(0), "ERC20: transfer to the zero address");
618         require(amount > 0, "Transfer amount must be greater than zero");
619         require(!_isSniper[to], "You have no power here!");
620         require(!_isSniper[msg.sender], "You have no power here!");
621 
622        
623         // buy
624         if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
625             require(tradingOpen, "Trading not yet enabled.");
626             
627             //antibot
628             if (block.timestamp == launchTime) {
629                 _isSniper[to] = true;
630                 _confirmedSnipers.push(to);
631             }
632         }
633         
634       
635              if(!Limtcheck[to]){ require(balanceOf(to).add(amount) <= maxWallet,"Wallet Limit Exceed");
636              require(amount <= maxTX,"Tx Limit Exceed");
637          }
638 
639 
640         uint256 contractTokenBalance = balanceOf(address(this));
641         
642         //sell
643        
644          
645         if (!inSwapAndLiquify && tradingOpen && to == uniswapV2Pair) {
646             if(contractTokenBalance > 0) {
647                 if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
648                     contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
649                 }
650                 swapTokens(contractTokenBalance);    
651             }
652             
653             if(opensellTx==false)
654             {
655                 revert('Sell Tx not allowed');
656             }
657           
658         }
659         
660         bool takeFee = false;
661         
662         //take fee only on swaps
663         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
664             takeFee = true;
665         }
666         
667         _tokenTransfer(from,to,amount,takeFee);
668     }
669 
670     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
671         swapTokensForEth(contractTokenBalance);
672         
673         //Send to Marketing address
674         uint256 contractETHBalance = address(this).balance;
675         if(contractETHBalance > 0) {
676             sendETHToFee(address(this).balance);
677         }
678     }
679     
680     function sendETHToFee(uint256 amount) private {
681          marketingAddress.transfer(amount);
682     }
683     
684     function ManualApproval() public onlyOwner
685     {
686         uint256 contractTokenBalance = balanceOf(address(this));
687          _approve(address(this), address(uniswapV2Router), contractTokenBalance);
688         
689     }
690     
691     function changeSellTx(bool _status) public onlyOwner {
692         opensellTx=_status;
693     }
694     
695     
696      function ManualswapTokens() public onlyOwner {
697      uint256 contractTokenBalance = balanceOf(address(this));
698         IERC20(address(this)).transfer(_msgSender(),contractTokenBalance);
699     }
700     
701 
702    
703     function swapTokensForEth(uint256 tokenAmount) private {
704         // generate the uniswap pair path of token -> weth
705         address[] memory path = new address[](2);
706         path[0] = address(this);
707         path[1] = uniswapV2Router.WETH();
708 
709         _approve(address(this), address(uniswapV2Router), tokenAmount);
710 
711         // make the swap
712         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
713             tokenAmount,
714             0, // accept any amount of ETH
715             path,
716             address(this), // The contract
717             block.timestamp
718         );
719         
720         emit SwapTokensForETH(tokenAmount, path);
721     }
722     
723 
724     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
725         // approve token transfer to cover all possible scenarios
726         _approve(address(this), address(uniswapV2Router), tokenAmount);
727 
728         // add the liquidity
729         uniswapV2Router.addLiquidityETH{value: ethAmount}(
730             address(this),
731             tokenAmount,
732             0, // slippage is unavoidable
733             0, // slippage is unavoidable
734             owner(),
735             block.timestamp
736         );
737     }
738 
739     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
740         if(!takeFee)
741             removeAllFee();
742         
743         if (_isExcluded[sender] && !_isExcluded[recipient]) {
744             _transferFromExcluded(sender, recipient, amount);
745         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
746             _transferToExcluded(sender, recipient, amount);
747         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
748             _transferBothExcluded(sender, recipient, amount);
749         } else {
750             _transferStandard(sender, recipient, amount);
751         }
752         
753         if(!takeFee)
754             restoreAllFee();
755     }
756 
757     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
758         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
759         _rOwned[sender] = _rOwned[sender].sub(rAmount);
760         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
761         _takeLiquidity(tLiquidity);
762         _reflectFee(rFee, tFee);
763         emit Transfer(sender, recipient, tTransferAmount);
764     }
765 
766     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
767         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
768         _rOwned[sender] = _rOwned[sender].sub(rAmount);
769         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
770         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
771         _takeLiquidity(tLiquidity);
772         _reflectFee(rFee, tFee);
773         emit Transfer(sender, recipient, tTransferAmount);
774     }
775 
776     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
777         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
778         _tOwned[sender] = _tOwned[sender].sub(tAmount);
779         _rOwned[sender] = _rOwned[sender].sub(rAmount);
780         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
781         _takeLiquidity(tLiquidity);
782         _reflectFee(rFee, tFee);
783         emit Transfer(sender, recipient, tTransferAmount);
784     }
785 
786     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
787         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
788         _tOwned[sender] = _tOwned[sender].sub(tAmount);
789         _rOwned[sender] = _rOwned[sender].sub(rAmount);
790         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
791         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
792         _takeLiquidity(tLiquidity);
793         _reflectFee(rFee, tFee);
794         emit Transfer(sender, recipient, tTransferAmount);
795     }
796 
797     function _reflectFee(uint256 rFee, uint256 tFee) private {
798         _rTotal = _rTotal.sub(rFee);
799         _tFeeTotal = _tFeeTotal.add(tFee);
800     }
801 
802     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
803         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
804         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
805         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
806     }
807 
808     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
809         uint256 tFee = calculateTaxFee(tAmount);
810         uint256 tLiquidity = calculateLiquidityFee(tAmount);
811         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
812         return (tTransferAmount, tFee, tLiquidity);
813     }
814 
815     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
816         uint256 rAmount = tAmount.mul(currentRate);
817         uint256 rFee = tFee.mul(currentRate);
818         uint256 rLiquidity = tLiquidity.mul(currentRate);
819         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
820         return (rAmount, rTransferAmount, rFee);
821     }
822 
823     function _getRate() private view returns(uint256) {
824         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
825         return rSupply.div(tSupply);
826     }
827 
828     function _getCurrentSupply() private view returns(uint256, uint256) {
829         uint256 rSupply = _rTotal;
830         uint256 tSupply = _tTotal;      
831         for (uint256 i = 0; i < _excluded.length; i++) {
832             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
833             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
834             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
835         }
836         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
837         return (rSupply, tSupply);
838     }
839     
840     function _takeLiquidity(uint256 tLiquidity) private {
841         uint256 currentRate =  _getRate();
842         uint256 rLiquidity = tLiquidity.mul(currentRate);
843         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
844         if(_isExcluded[address(this)])
845             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
846     }
847     
848     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
849         return _amount.mul(_taxFee).div(
850             10**2
851         );
852     }
853     
854     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
855         return _amount.mul(_liquidityFee).div(
856             10**3
857         );
858     }
859     
860     function removeAllFee() private {
861         if(_taxFee == 0 && _liquidityFee == 0) return;
862         
863         _previousTaxFee = _taxFee;
864         _previousLiquidityFee = _liquidityFee;
865         
866         _taxFee = 0;
867         _liquidityFee = 0;
868     }
869     
870     function restoreAllFee() private {
871         _taxFee = _previousTaxFee;
872         _liquidityFee = _previousLiquidityFee;
873     }
874 
875     function isExcludedFromFee(address account) public view returns(bool) {
876         return _isExcludedFromFee[account];
877     }
878     
879     function excludeFromFee(address account) public onlyOwner {
880         _isExcludedFromFee[account] = true;
881     }
882     
883     function includeInFee(address account) public onlyOwner {
884         _isExcludedFromFee[account] = false;
885     }
886     
887     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
888         _taxFee = taxFee;
889     }
890 
891      function removeToken(uint256 _amount) external onlyOwner  {
892         IERC20(address(this)).transfer(_msgSender(),_amount); 
893     }
894     
895     function setBuySellFeePercent(uint256 liquidityFee) external onlyOwner() {
896         _liquidityFee = liquidityFee;
897     }
898     
899     function setmaxTX(uint256 amount) external onlyOwner{
900         maxTX = amount;
901     }
902 
903      function setmaxWallet(uint256 amount) external onlyOwner {
904         maxWallet = amount;
905     }
906     
907     
908     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
909         marketingAddress = payable(_marketingAddress);
910     }
911    
912     
913     function transferToAddressETH(address payable recipient, uint256 amount) private {
914         recipient.transfer(amount);
915     }
916     
917     function isBlacklist(address account) public view returns (bool) {
918         return _isSniper[account];
919     }
920     
921     function addBlacklist(address[] memory account) external onlyOwner() {
922         for(uint i=0;i<account.length;i++)
923         {
924         require(account[i] != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap');
925         require(!_isSniper[account[i]], "Account is already blacklisted");
926         _isSniper[account[i]] = true;
927         _confirmedSnipers.push(account[i]);
928         }
929     }
930 
931     function removeBlacklist(address account) external onlyOwner() {
932         require(_isSniper[account], "Account is not blacklisted");
933         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
934             if (_confirmedSnipers[i] == account) {
935                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
936                 _isSniper[account] = false;
937                 _confirmedSnipers.pop();
938                 break;
939             }
940         }
941     }
942 
943     
944     
945      function setFeeRate(uint256 rate) external  onlyOwner() {
946         _feeRate = rate;
947     }
948 
949     
950    
951      //to recieve ETH from uniswapV2Router when swaping
952     receive() external payable {}
953 }