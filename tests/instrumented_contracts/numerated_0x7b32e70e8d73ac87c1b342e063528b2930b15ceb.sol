1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4  * #RoboInu (RBIF)
5  *
6  *  Great features:
7  *  -   sell/buy transaction will have different tax percent and distributed to holders for HODLing.
8  *      +  Buying Tax (4%): 1% Reward Holders, 1% Marketing wallet, 2% Auto add liquidity
9  *      +  Selling Tax (10%) : 2% Reward Holders, 2% Marketing wallet, 6% Auto add liquidity
10  *  -   Max transfer: 0.3%
11  *  -   Antiwhate : maximum token of holder is set 2% now.   
12  *
13  **/
14 pragma solidity ^0.8.4;
15 
16 
17 interface IERC20 {
18     
19     function totalSupply() external view returns (uint256);
20 
21     
22     function balanceOf(address account) external view returns (uint256);
23 
24     
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library SafeMath {
48     
49     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             uint256 c = a + b;
52             if (c < a) return (false, 0);
53             return (true, c);
54         }
55     }
56 
57     
58     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b > a) return (false, 0);
61             return (true, a - b);
62         }
63     }
64 
65     
66     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             
69             
70             
71             if (a == 0) return (true, 0);
72             uint256 c = a * b;
73             if (c / a != b) return (false, 0);
74             return (true, c);
75         }
76     }
77 
78     
79     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a / b);
83         }
84     }
85 
86     
87     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a % b);
91         }
92     }
93 
94     
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return a - b;
102     }
103 
104     
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a * b;
107     }
108 
109     
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a / b;
112     }
113 
114     
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a % b;
117     }
118 
119     
120     function sub(
121         uint256 a,
122         uint256 b,
123         string memory errorMessage
124     ) internal pure returns (uint256) {
125         unchecked {
126             require(b <= a, errorMessage);
127             return a - b;
128         }
129     }
130 
131     
132     function div(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         unchecked {
138             require(b > 0, errorMessage);
139             return a / b;
140         }
141     }
142 
143     
144     function mod(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         unchecked {
150             require(b > 0, errorMessage);
151             return a % b;
152         }
153     }
154 }
155 
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 library Address {
167     
168     function isContract(address account) internal view returns (bool) {
169         
170         
171         
172 
173         uint256 size;
174         assembly {
175             size := extcodesize(account)
176         }
177         return size > 0;
178     }
179 
180     
181     function sendValue(address payable recipient, uint256 amount) internal {
182         require(address(this).balance >= amount, "Address: insufficient balance");
183 
184         (bool success, ) = recipient.call{value: amount}("");
185         require(success, "Address: unable to send value, recipient may have reverted");
186     }
187 
188     
189     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210 
211     
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(address(this).balance >= value, "Address: insufficient balance for call");
219         require(isContract(target), "Address: call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.call{value: value}(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     
231     function functionStaticCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.staticcall(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     
243     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
245     }
246 
247     
248     function functionDelegateCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(isContract(target), "Address: delegate call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.delegatecall(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     
260     function verifyCallResult(
261         bool success,
262         bytes memory returndata,
263         string memory errorMessage
264     ) internal pure returns (bytes memory) {
265         if (success) {
266             return returndata;
267         } else {
268             
269             if (returndata.length > 0) {
270                 
271 
272                 assembly {
273                     let returndata_size := mload(returndata)
274                     revert(add(32, returndata), returndata_size)
275                 }
276             } else {
277                 revert(errorMessage);
278             }
279         }
280     }
281 }
282 
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     
289     constructor() {
290         _setOwner(_msgSender());
291     }
292 
293     
294     function owner() public view virtual returns (address) {
295         return _owner;
296     }
297 
298     
299     modifier onlyOwner() {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     
305     function renounceOwnership() public virtual onlyOwner {
306         _setOwner(address(0));
307     }
308 
309     
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(newOwner != address(0), "Ownable: new owner is the zero address");
312         _setOwner(newOwner);
313     }
314 
315     function _setOwner(address newOwner) private {
316         address oldOwner = _owner;
317         _owner = newOwner;
318         emit OwnershipTransferred(oldOwner, newOwner);
319     }
320 }
321 
322 interface IUniswapV2Factory {
323     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
324 
325     function feeTo() external view returns (address);
326     function feeToSetter() external view returns (address);
327 
328     function getPair(address tokenA, address tokenB) external view returns (address pair);
329     function allPairs(uint) external view returns (address pair);
330     function allPairsLength() external view returns (uint);
331 
332     function createPair(address tokenA, address tokenB) external returns (address pair);
333 
334     function setFeeTo(address) external;
335     function setFeeToSetter(address) external;
336 }
337 
338 interface IUniswapV2Pair {
339     event Approval(address indexed owner, address indexed spender, uint value);
340     event Transfer(address indexed from, address indexed to, uint value);
341 
342     function name() external pure returns (string memory);
343     function symbol() external pure returns (string memory);
344     function decimals() external pure returns (uint8);
345     function totalSupply() external view returns (uint);
346     function balanceOf(address owner) external view returns (uint);
347     function allowance(address owner, address spender) external view returns (uint);
348 
349     function approve(address spender, uint value) external returns (bool);
350     function transfer(address to, uint value) external returns (bool);
351     function transferFrom(address from, address to, uint value) external returns (bool);
352 
353     function DOMAIN_SEPARATOR() external view returns (bytes32);
354     function PERMIT_TYPEHASH() external pure returns (bytes32);
355     function nonces(address owner) external view returns (uint);
356 
357     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
358 
359     event Mint(address indexed sender, uint amount0, uint amount1);
360     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
361     event Swap(
362         address indexed sender,
363         uint amount0In,
364         uint amount1In,
365         uint amount0Out,
366         uint amount1Out,
367         address indexed to
368     );
369     event Sync(uint112 reserve0, uint112 reserve1);
370 
371     function MINIMUM_LIQUIDITY() external pure returns (uint);
372     function factory() external view returns (address);
373     function token0() external view returns (address);
374     function token1() external view returns (address);
375     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
376     function price0CumulativeLast() external view returns (uint);
377     function price1CumulativeLast() external view returns (uint);
378     function kLast() external view returns (uint);
379 
380     function mint(address to) external returns (uint liquidity);
381     function burn(address to) external returns (uint amount0, uint amount1);
382     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
383     function skim(address to) external;
384     function sync() external;
385 
386     function initialize(address, address) external;
387 }
388 
389 interface IUniswapV2Router01 {
390     function factory() external pure returns (address);
391     function WETH() external pure returns (address);
392 
393     function addLiquidity(
394         address tokenA,
395         address tokenB,
396         uint amountADesired,
397         uint amountBDesired,
398         uint amountAMin,
399         uint amountBMin,
400         address to,
401         uint deadline
402     ) external returns (uint amountA, uint amountB, uint liquidity);
403     function addLiquidityETH(
404         address token,
405         uint amountTokenDesired,
406         uint amountTokenMin,
407         uint amountETHMin,
408         address to,
409         uint deadline
410     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
411     function removeLiquidity(
412         address tokenA,
413         address tokenB,
414         uint liquidity,
415         uint amountAMin,
416         uint amountBMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountA, uint amountB);
420     function removeLiquidityETH(
421         address token,
422         uint liquidity,
423         uint amountTokenMin,
424         uint amountETHMin,
425         address to,
426         uint deadline
427     ) external returns (uint amountToken, uint amountETH);
428     function removeLiquidityWithPermit(
429         address tokenA,
430         address tokenB,
431         uint liquidity,
432         uint amountAMin,
433         uint amountBMin,
434         address to,
435         uint deadline,
436         bool approveMax, uint8 v, bytes32 r, bytes32 s
437     ) external returns (uint amountA, uint amountB);
438     function removeLiquidityETHWithPermit(
439         address token,
440         uint liquidity,
441         uint amountTokenMin,
442         uint amountETHMin,
443         address to,
444         uint deadline,
445         bool approveMax, uint8 v, bytes32 r, bytes32 s
446     ) external returns (uint amountToken, uint amountETH);
447     function swapExactTokensForTokens(
448         uint amountIn,
449         uint amountOutMin,
450         address[] calldata path,
451         address to,
452         uint deadline
453     ) external returns (uint[] memory amounts);
454     function swapTokensForExactTokens(
455         uint amountOut,
456         uint amountInMax,
457         address[] calldata path,
458         address to,
459         uint deadline
460     ) external returns (uint[] memory amounts);
461     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
462         external
463         payable
464         returns (uint[] memory amounts);
465     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
469         external
470         returns (uint[] memory amounts);
471     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
472         external
473         payable
474         returns (uint[] memory amounts);
475 
476     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
477     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
478     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
479     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
480     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
481 }
482 
483 interface IUniswapV2Router02 is IUniswapV2Router01 {
484     function removeLiquidityETHSupportingFeeOnTransferTokens(
485         address token,
486         uint liquidity,
487         uint amountTokenMin,
488         uint amountETHMin,
489         address to,
490         uint deadline
491     ) external returns (uint amountETH);
492     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
493         address token,
494         uint liquidity,
495         uint amountTokenMin,
496         uint amountETHMin,
497         address to,
498         uint deadline,
499         bool approveMax, uint8 v, bytes32 r, bytes32 s
500     ) external returns (uint amountETH);
501 
502     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
503         uint amountIn,
504         uint amountOutMin,
505         address[] calldata path,
506         address to,
507         uint deadline
508     ) external;
509     function swapExactETHForTokensSupportingFeeOnTransferTokens(
510         uint amountOutMin,
511         address[] calldata path,
512         address to,
513         uint deadline
514     ) external payable;
515     function swapExactTokensForETHSupportingFeeOnTransferTokens(
516         uint amountIn,
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external;
522 }
523 
524 contract Token is Context, IERC20, Ownable {
525     using SafeMath for uint256;
526     using Address for address;
527     
528     IUniswapV2Router02 public uniswapV2Router;
529     address public uniswapV2Pair;
530 
531 
532     mapping (address => uint256) private _rOwned;
533     mapping (address => uint256) private _tOwned;
534     mapping (address => mapping (address => uint256)) private _allowances;
535 
536     mapping (address => bool) private _isExcludedFromFee;
537 
538     mapping (address => bool) private _isExcluded;
539     address[] private _excluded;
540    
541     uint256 private constant MAX = ~uint256(0);
542     uint256 private _tTotal = 100000000000 * 10**6 * 10**9;
543     uint256 private _rTotal = (MAX - (MAX % _tTotal));
544     uint256 private _tFeeTotal;
545 
546     string private _name = "ROBO INU";
547     string private _symbol = "RBIF";
548     uint8 private _decimals = 9;
549 
550 
551     uint256 public _taxFee = 0;
552     uint256 public _buyTaxFee = 1;
553     uint256 public _sellTaxFee = 2;
554     uint256 private _previousTaxFee = _taxFee;
555     
556     uint256 public _liquidityFee = 0;
557     uint256 public _buyLiquidityFee = 2;
558     uint256 public _sellLiquidityFee = 6;
559     uint256 private _previousLiquidityFee = _liquidityFee;
560 
561     uint256 private _marketingDivisor = 0;
562     uint256 public _buymarketingDivisor = 1;
563     uint256 public _sellmarketingDivisor = 2;
564     uint256 private _previousmarketingDivisor = _marketingDivisor;
565     address payable public marketingWallet = payable(0x256bbe11aF79825f8DDe0EC168f58843BAf2a036); 
566 
567     address internal burnAddress = 0x000000000000000000000000000000000000dEaD;
568     
569     uint256 public _maxTxAmount = 300000000 * 10**6 * 10**9; 
570     uint256 private numTokensSellToAddToLiquidity = 20000000 * 10**6 * 10**9;  
571     uint256 public _maxTokenHolder = 2000000000 * 10**6 * 10**9; 
572 
573     bool inSwapAndLiquify;
574     bool public swapAndLiquifyEnabled = false;
575     
576     event SwapAndLiquifyEnabledUpdated(bool enabled);
577     event SwapAndLiquify(
578         uint256 tokensSwapped,
579         uint256 ethReceived,
580         uint256 tokensIntoLiqudity
581     );
582     
583     event SwapTokensForETH(
584         uint256 amountIn,
585         address[] path
586     );
587     
588     modifier lockTheSwap {
589         inSwapAndLiquify = true;
590         _;
591         inSwapAndLiquify = false;
592     }
593     
594     constructor (address routerAddress) {
595         _rOwned[_msgSender()] = _rTotal;
596         
597         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);
598         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
599 
600         uniswapV2Router = _uniswapV2Router;
601 
602         
603         excludeFromFee(owner());
604         excludeFromFee(address(this));
605         
606         excludeFromReward(address(this));
607 
608         emit Transfer(address(0), _msgSender(), _tTotal);
609     }
610 
611     function name() public view returns (string memory) {
612         return _name;
613     }
614 
615     function symbol() public view returns (string memory) {
616         return _symbol;
617     }
618 
619     function decimals() public view returns (uint8) {
620         return _decimals;
621     }
622 
623     function totalSupply() public view override returns (uint256) {
624         return _tTotal;
625     }
626 
627     function balanceOf(address account) public view override returns (uint256) {
628         if (_isExcluded[account]) return _tOwned[account];
629         return tokenFromReflection(_rOwned[account]);
630     }
631 
632     function transfer(address recipient, uint256 amount) public override returns (bool) {
633         _transfer(_msgSender(), recipient, amount);
634         return true;
635     }
636 
637     function allowance(address owner, address spender) public view override returns (uint256) {
638         return _allowances[owner][spender];
639     }
640 
641     function approve(address spender, uint256 amount) public override returns (bool) {
642         _approve(_msgSender(), spender, amount);
643         return true;
644     }
645 
646     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
647         _transfer(sender, recipient, amount);
648         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
649         return true;
650     }
651 
652     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
653         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
654         return true;
655     }
656 
657     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
658         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
659         return true;
660     }
661 
662     function isExcludedFromReward(address account) public view returns (bool) {
663         return _isExcluded[account];
664     }
665 
666     function totalFees() public view returns (uint256) {
667         return _tFeeTotal;
668     }
669     
670     function numTokensSellToAddToLiquidityAmount() public view returns (uint256) {
671         return numTokensSellToAddToLiquidity;
672     }
673 
674     
675     
676     
677     function deliver(uint256 tAmount) public {
678         address sender = _msgSender();
679         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
680         (uint256 rAmount,,,,,) = _getValues(tAmount);
681         _rOwned[sender] = _rOwned[sender].sub(rAmount);
682         _rTotal = _rTotal.sub(rAmount);
683         _tFeeTotal = _tFeeTotal.add(tAmount);
684     }
685   
686 
687     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
688         require(tAmount <= _tTotal, "Amount must be less than supply");
689         if (!deductTransferFee) {
690             (uint256 rAmount,,,,,) = _getValues(tAmount);
691             return rAmount;
692         } else {
693             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
694             return rTransferAmount;
695         }
696     }
697 
698     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
699         require(rAmount <= _rTotal, "Amount must be less than total reflections");
700         uint256 currentRate =  _getRate();
701         return rAmount.div(currentRate);
702     }
703 
704     function excludeFromReward(address account) public onlyOwner() {
705 
706         require(!_isExcluded[account], "Account is already excluded");
707         if(_rOwned[account] > 0) {
708             _tOwned[account] = tokenFromReflection(_rOwned[account]);
709         }
710         _isExcluded[account] = true;
711         _excluded.push(account);
712     }
713 
714     function includeInReward(address account) external onlyOwner() {
715         require(_isExcluded[account], "Account is already excluded");
716         require(_excluded.length < 20, "Excluded list too big");
717         for (uint256 i = 0; i < _excluded.length; i++) {
718             if (_excluded[i] == account) {
719                 _excluded[i] = _excluded[_excluded.length - 1];
720                 _tOwned[account] = 0;
721                 _isExcluded[account] = false;
722                 _excluded.pop();
723                 break;
724             }
725         }
726     }
727 
728     function _approve(address owner, address spender, uint256 amount) private {
729         require(owner != address(0), "ERC20: approve from the zero address");
730         require(spender != address(0), "ERC20: approve to the zero address");
731 
732         _allowances[owner][spender] = amount;
733         emit Approval(owner, spender, amount);
734     }
735 
736     function _transfer(
737         address from,
738         address to,
739         uint256 amount
740     ) private {
741         require(from != address(0), "ERC20: transfer from the zero address");
742         require(to != address(0), "ERC20: transfer to the zero address");
743         require(amount > 0, "Transfer amount must be greater than zero");
744         if(from == uniswapV2Pair && from != owner() && to != owner()){
745             require(balanceOf(to).add(amount) < _maxTokenHolder, "ERC20: You can not hold more than 2% Total supply");
746         }
747         if(from != owner() && to != owner()) {
748             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
749         }
750 
751         uint256 contractTokenBalance = balanceOf(address(this));
752         bool overMinimumTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
753 
754         if (
755             overMinimumTokenBalance && 
756             !inSwapAndLiquify && 
757             from != uniswapV2Pair &&
758             swapAndLiquifyEnabled
759         ) {
760             contractTokenBalance = numTokensSellToAddToLiquidity;
761             swapAndLiquify(contractTokenBalance);    
762         }
763 
764         _tokenTransfer(from, to, amount);
765     }
766 
767 
768     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
769         
770         uint256 half = contractTokenBalance.div(2);
771         uint256 otherHalf = contractTokenBalance.sub(half);
772 
773         
774         
775         
776         
777         
778         uint256 initialBalance = address(this).balance;
779 
780         
781         swapTokensForEth(half); 
782 
783         
784         uint256 newBalance = address(this).balance.sub(initialBalance);
785 
786         
787         addLiquidity(otherHalf, newBalance);
788         emit SwapAndLiquify(half, newBalance, otherHalf);
789     }
790     
791     
792     function swapTokensForEth(uint256 tokenAmount) private {
793         
794         address[] memory path = new address[](2);
795         path[0] = address(this);
796         path[1] = uniswapV2Router.WETH();
797 
798         _approve(address(this), address(uniswapV2Router), tokenAmount);
799 
800         
801         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
802             tokenAmount,
803             0, 
804             path,
805             address(this), 
806             block.timestamp
807         );
808         
809         emit SwapTokensForETH(tokenAmount, path);
810     }
811     
812     
813     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
814         
815         _approve(address(this), address(uniswapV2Router), tokenAmount);
816 
817         
818         uniswapV2Router.addLiquidityETH{value: ethAmount}(
819             address(this),
820             tokenAmount,
821             0, 
822             0, 
823             owner(),
824             block.timestamp
825         );
826     }
827 
828     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
829         if (sender == uniswapV2Pair) {
830             _taxFee = _buyTaxFee;
831             _liquidityFee = _buyLiquidityFee;
832             _marketingDivisor = _buymarketingDivisor;
833         } 
834         if (recipient == uniswapV2Pair) {
835             _taxFee = _sellTaxFee;
836             _liquidityFee = _sellLiquidityFee;
837             _marketingDivisor = _sellmarketingDivisor;
838         }
839 
840         if(isExcludedFromFee(sender) || isExcludedFromFee(recipient))
841             removeAllFee();
842         
843         
844         uint256 marketingAmt = calculateMarketingFee(amount);
845 
846         if (_isExcluded[sender] && !_isExcluded[recipient]) {
847             _transferFromExcluded(sender, recipient, (amount.sub(marketingAmt)));
848         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
849             _transferToExcluded(sender, recipient, (amount.sub(marketingAmt)));
850         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
851             _transferStandard(sender, recipient, (amount.sub(marketingAmt)));
852         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
853             _transferBothExcluded(sender, recipient, (amount.sub(marketingAmt)));
854         } else {
855             _transferStandard(sender, recipient, (amount.sub(marketingAmt)));
856         }
857         
858         _transferStandard(sender, marketingWallet, marketingAmt);
859 
860         if(isExcludedFromFee(sender) || isExcludedFromFee(recipient))
861             restoreAllFee();
862     }
863 
864     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
865         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
866         _rOwned[sender] = _rOwned[sender].sub(rAmount);
867         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
868         _takeLiquidity(tLiquidity);
869         _reflectFee(rFee, tFee);
870         emit Transfer(sender, recipient, tTransferAmount);
871     }
872 
873     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
874         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
875         _rOwned[sender] = _rOwned[sender].sub(rAmount);
876         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
877         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
878         _takeLiquidity(tLiquidity);
879         _reflectFee(rFee, tFee);
880         emit Transfer(sender, recipient, tTransferAmount);
881     }
882 
883     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
884         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
885         _tOwned[sender] = _tOwned[sender].sub(tAmount);
886         _rOwned[sender] = _rOwned[sender].sub(rAmount);
887         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
888         _takeLiquidity(tLiquidity);
889         _reflectFee(rFee, tFee);
890         emit Transfer(sender, recipient, tTransferAmount);
891     }
892 
893     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
894         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
895         _tOwned[sender] = _tOwned[sender].sub(tAmount);
896         _rOwned[sender] = _rOwned[sender].sub(rAmount);
897         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
898         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
899         _takeLiquidity(tLiquidity);
900         _reflectFee(rFee, tFee);
901         emit Transfer(sender, recipient, tTransferAmount);
902     }
903 
904      
905     receive() external payable {}
906 
907     function _reflectFee(uint256 rFee, uint256 tFee) private {
908         _rTotal = _rTotal.sub(rFee);
909         _tFeeTotal = _tFeeTotal.add(tFee);
910     }
911 
912     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
913         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
914         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
915         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
916     }
917 
918     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
919         uint256 tFee = calculateTaxFee(tAmount);
920         uint256 tLiquidity = calculateLiquidityFee(tAmount);
921         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
922         return (tTransferAmount, tFee, tLiquidity);
923     }
924 
925     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
926         uint256 rAmount = tAmount.mul(currentRate);
927         uint256 rFee = tFee.mul(currentRate);
928         uint256 rLiquidity = tLiquidity.mul(currentRate);
929         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
930         return (rAmount, rTransferAmount, rFee);
931     }
932 
933     function _getRate() private view returns(uint256) {
934         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
935         return rSupply.div(tSupply);
936     }
937 
938     function _getCurrentSupply() private view returns(uint256, uint256) {
939         uint256 rSupply = _rTotal;
940         uint256 tSupply = _tTotal;      
941         for (uint256 i = 0; i < _excluded.length; i++) {
942             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
943             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
944             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
945         }
946         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
947         return (rSupply, tSupply);
948     }
949     
950     function _takeLiquidity(uint256 tLiquidity) private {
951         uint256 currentRate =  _getRate();
952         uint256 rLiquidity = tLiquidity.mul(currentRate);
953         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
954         if(_isExcluded[address(this)])
955             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
956     }
957     
958     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
959         return _amount.mul(_taxFee).div(
960             10**2
961         );
962     }
963     
964     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
965         return _amount.mul(_liquidityFee).div(
966             10**2
967         );
968     }
969 
970     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
971         return _amount.mul(_marketingDivisor).div(
972             10**2
973         );
974     }
975     
976     function removeAllFee() private {
977         if(_taxFee == 0 && _liquidityFee == 0 && _marketingDivisor == 0) return;
978         
979         _previousTaxFee = _taxFee;
980         _previousLiquidityFee = _liquidityFee;
981         _previousmarketingDivisor = _marketingDivisor;
982 
983         _marketingDivisor = 0;
984         _taxFee = 0;
985         _liquidityFee = 0;
986     }
987     
988     function restoreAllFee() private {
989         _marketingDivisor = _previousmarketingDivisor;
990         _taxFee = _previousTaxFee;
991         _liquidityFee = _previousLiquidityFee;
992     }
993 
994     function isExcludedFromFee(address account) public view returns(bool) {
995         return _isExcludedFromFee[account];
996     }
997     
998     function excludeFromFee(address account) public onlyOwner {
999         _isExcludedFromFee[account] = true;
1000     }
1001     
1002     function includeInFee(address account) public onlyOwner {
1003         _isExcludedFromFee[account] = false;
1004     }
1005     
1006     
1007     function setBuyTaxFeePercent(uint256 buyTaxFee) external onlyOwner() {
1008         _buyTaxFee = buyTaxFee;
1009     }
1010 
1011     function setSellTaxFeePercent(uint256 sellTaxFee) external onlyOwner() {
1012         _sellTaxFee = sellTaxFee;
1013     }
1014   
1015     function setBuyLiquidityFeePercent(uint256 buyLiquidityFee) external onlyOwner() {
1016         _buyLiquidityFee = buyLiquidityFee;
1017     }
1018 
1019     function setSellLiquidityFeePercent(uint256 sellLiquidityFee) external onlyOwner() {
1020         _sellLiquidityFee = sellLiquidityFee;
1021     }
1022     
1023 
1024     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1025         _maxTxAmount = maxTxAmount;
1026     }
1027     
1028     function setBuyMarketingDivisor(uint256 divisor) external onlyOwner() {
1029         _buymarketingDivisor = divisor;
1030     }
1031 
1032     function setSellMarketingDivisor(uint256 divisor) external onlyOwner() {
1033         _sellmarketingDivisor = divisor;
1034     }
1035 
1036     function setNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity) external onlyOwner() {
1037         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
1038     }
1039 
1040     function setMaxTokenHolder(uint256 newMaxTokenHolder) external onlyOwner() {
1041         _maxTokenHolder = newMaxTokenHolder;
1042     }
1043 
1044     function setMarketingWallet(address _marketingWallet) external onlyOwner() {
1045         marketingWallet = payable(_marketingWallet);
1046     }
1047     
1048     function burn(uint256 amount) external {
1049 
1050         address sender = _msgSender();
1051         require(sender != address(0), "Burn from the zero address");
1052         require(sender != address(burnAddress), "Burn from the burn address");
1053         
1054         uint256 balance = balanceOf(sender);
1055 
1056         require(balance >= amount, "Burn amount exceeds balance");
1057         uint256 rBurnAmount = amount.mul(_getRate());
1058 
1059         
1060         _rOwned[sender] = _rOwned[sender].sub(rBurnAmount);
1061         if (_isExcluded[sender])
1062             _tOwned[sender] = _tOwned[sender].sub(amount);
1063 
1064         _burnTokens(sender, amount, rBurnAmount);
1065     }
1066     
1067     function _burnTokens(address sender, uint256 tBurn, uint256 rBurn) internal {
1068         _rOwned[burnAddress] = _rOwned[burnAddress].add(rBurn);
1069         if (_isExcluded[burnAddress])
1070             _tOwned[burnAddress] = _tOwned[burnAddress].add(tBurn);
1071 
1072         emit Transfer(sender, burnAddress, tBurn);
1073     }
1074 
1075     
1076     function changeRouterVersion(address _router) public onlyOwner returns(address _pair) {
1077         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1078         _pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1079         if(_pair == address(0)){
1080             _pair = IUniswapV2Factory(_uniswapV2Router.factory())
1081             .createPair(address(this), _uniswapV2Router.WETH());
1082         }
1083         uniswapV2Pair = _pair;
1084         uniswapV2Router = _uniswapV2Router;
1085     }
1086 
1087     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1088         swapAndLiquifyEnabled = _enabled;
1089         emit SwapAndLiquifyEnabledUpdated(_enabled);
1090     }
1091 
1092     
1093     function prepareForPreSale() external onlyOwner {
1094         setSwapAndLiquifyEnabled(false);
1095 
1096         _taxFee = 0;
1097         _liquidityFee = 0;
1098         _marketingDivisor = 0;
1099 
1100         _buyTaxFee = 0;
1101         _buyLiquidityFee = 0;
1102         _buymarketingDivisor = 0;
1103 
1104         _sellTaxFee = 0;
1105         _sellLiquidityFee = 0;
1106         _sellmarketingDivisor = 0;
1107 
1108         _maxTxAmount = 1000000000 * 10**6 * 10**9;
1109     }
1110     
1111     function goLive() external onlyOwner {
1112         setSwapAndLiquifyEnabled(true);
1113         _taxFee = 4;
1114         _previousTaxFee = _taxFee;
1115 
1116         _liquidityFee = 8;
1117         _previousLiquidityFee = _liquidityFee;
1118 
1119         _marketingDivisor = 2;
1120         _previousmarketingDivisor = _marketingDivisor;
1121 
1122         _buyTaxFee = 1;
1123         _buyLiquidityFee = 2;
1124         _buymarketingDivisor = 1;
1125 
1126         _sellTaxFee = 2;
1127         _sellLiquidityFee = 6;
1128         _sellmarketingDivisor = 2;
1129 
1130         _maxTxAmount = 300000000 * 10**6 * 10**9;
1131     }
1132 
1133 }