1 /**
2  *Submitted for verification at BscScan.com on 2021-10-31
3 */
4 
5 /*
6 
7 SPKI token description
8 Community token with many products will be developed: NFT MarketPlace, Swap Crosschain App, Wallet, ...
9 
10 Main features are
11  
12 1) sell/buy transaction will have different tax percent and distributed to holders for HODLing 
13 2) 6% add liquidity and marketing tax is collected and 2% of it is sent for marketing fund and charity purpose, other 4% is used to add LP
14 3) Antiwhate : maximum token of holder is set 2% now.   
15 */
16 
17 // SPDX-License-Identifier: Unlicensed
18 
19 pragma solidity ^0.8.4;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return payable(msg.sender);
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 
33 interface IERC20 {
34 
35     function totalSupply() external view returns (uint256);
36     function balanceOf(address account) external view returns (uint256);
37     function transfer(address recipient, uint256 amount) external returns (bool);
38     function allowance(address owner, address spender) external view returns (uint256);
39     function approve(address spender, uint256 amount) external returns (bool);
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43     
44 
45 }
46 
47 library SafeMath {
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b > 0, errorMessage);
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         return mod(a, b, "SafeMath: modulo by zero");
93     }
94 
95     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b != 0, errorMessage);
97         return a % b;
98     }
99 }
100 
101 library Address {
102 
103     function isContract(address account) internal view returns (bool) {
104         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
105         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
106         // for accounts without code, i.e. `keccak256('')`
107         bytes32 codehash;
108         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
109         // solhint-disable-next-line no-inline-assembly
110         assembly { codehash := extcodehash(account) }
111         return (codehash != accountHash && codehash != 0x0);
112     }
113 
114     function sendValue(address payable recipient, uint256 amount) internal {
115         require(address(this).balance >= amount, "Address: insufficient balance");
116 
117         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
118         (bool success, ) = recipient.call{ value: amount }("");
119         require(success, "Address: unable to send value, recipient may have reverted");
120     }
121 
122 
123     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
124       return functionCall(target, data, "Address: low-level call failed");
125     }
126 
127     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
128         return _functionCallWithValue(target, data, 0, errorMessage);
129     }
130 
131     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
133     }
134 
135     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         return _functionCallWithValue(target, data, value, errorMessage);
138     }
139 
140     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
141         require(isContract(target), "Address: call to non-contract");
142 
143         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
144         if (success) {
145             return returndata;
146         } else {
147             
148             if (returndata.length > 0) {
149                 assembly {
150                     let returndata_size := mload(returndata)
151                     revert(add(32, returndata), returndata_size)
152                 }
153             } else {
154                 revert(errorMessage);
155             }
156         }
157     }
158 }
159 
160 contract Ownable is Context {
161     address private _owner;
162     address private _previousOwner;
163     uint256 private _lockTime;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     constructor () {
168         address msgSender = _msgSender();
169         _owner = msgSender;
170         emit OwnershipTransferred(address(0), msgSender);
171     }
172 
173     function owner() public view returns (address) {
174         return _owner;
175     }   
176     
177     modifier onlyOwner() {
178         require(_owner == _msgSender(), "Ownable: caller is not the owner");
179         _;
180     }
181     
182     function renounceOwnership() public virtual onlyOwner {
183         emit OwnershipTransferred(_owner, address(0));
184         _owner = address(0);
185     }
186 
187     function transferOwnership(address newOwner) public virtual onlyOwner {
188         require(newOwner != address(0), "Ownable: new owner is the zero address");
189         emit OwnershipTransferred(_owner, newOwner);
190         _owner = newOwner;
191     }
192 
193     function getUnlockTime() public view returns (uint256) {
194         return _lockTime;
195     }
196     
197     function getTime() public view returns (uint256) {
198         return block.timestamp;
199     }
200 
201     function lock(uint256 time) public virtual onlyOwner {
202         _previousOwner = _owner;
203         _owner = address(0);
204         _lockTime = block.timestamp + time;
205         emit OwnershipTransferred(_owner, address(0));
206     }
207     
208     function unlock() public virtual {
209         require(_previousOwner == msg.sender, "You don't have permission to unlock");
210         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
211         emit OwnershipTransferred(_owner, _previousOwner);
212         _owner = _previousOwner;
213     }
214 }
215 
216 // pragma solidity >=0.5.0;
217 
218 interface IUniswapV2Factory {
219     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
220 
221     function feeTo() external view returns (address);
222     function feeToSetter() external view returns (address);
223 
224     function getPair(address tokenA, address tokenB) external view returns (address pair);
225     function allPairs(uint) external view returns (address pair);
226     function allPairsLength() external view returns (uint);
227 
228     function createPair(address tokenA, address tokenB) external returns (address pair);
229 
230     function setFeeTo(address) external;
231     function setFeeToSetter(address) external;
232 }
233 
234 
235 // pragma solidity >=0.5.0;
236 
237 interface IUniswapV2Pair {
238     event Approval(address indexed owner, address indexed spender, uint value);
239     event Transfer(address indexed from, address indexed to, uint value);
240 
241     function name() external pure returns (string memory);
242     function symbol() external pure returns (string memory);
243     function decimals() external pure returns (uint8);
244     function totalSupply() external view returns (uint);
245     function balanceOf(address owner) external view returns (uint);
246     function allowance(address owner, address spender) external view returns (uint);
247 
248     function approve(address spender, uint value) external returns (bool);
249     function transfer(address to, uint value) external returns (bool);
250     function transferFrom(address from, address to, uint value) external returns (bool);
251 
252     function DOMAIN_SEPARATOR() external view returns (bytes32);
253     function PERMIT_TYPEHASH() external pure returns (bytes32);
254     function nonces(address owner) external view returns (uint);
255 
256     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
257     
258     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
259     event Swap(
260         address indexed sender,
261         uint amount0In,
262         uint amount1In,
263         uint amount0Out,
264         uint amount1Out,
265         address indexed to
266     );
267     event Sync(uint112 reserve0, uint112 reserve1);
268 
269     function MINIMUM_LIQUIDITY() external pure returns (uint);
270     function factory() external view returns (address);
271     function token0() external view returns (address);
272     function token1() external view returns (address);
273     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
274     function price0CumulativeLast() external view returns (uint);
275     function price1CumulativeLast() external view returns (uint);
276     function kLast() external view returns (uint);
277 
278     function burn(address to) external returns (uint amount0, uint amount1);
279     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
280     function skim(address to) external;
281     function sync() external;
282 
283     function initialize(address, address) external;
284 }
285 
286 // pragma solidity >=0.6.2;
287 
288 interface IUniswapV2Router01 {
289     function factory() external pure returns (address);
290     function WETH() external pure returns (address);
291 
292     function addLiquidity(
293         address tokenA,
294         address tokenB,
295         uint amountADesired,
296         uint amountBDesired,
297         uint amountAMin,
298         uint amountBMin,
299         address to,
300         uint deadline
301     ) external returns (uint amountA, uint amountB, uint liquidity);
302     function addLiquidityETH(
303         address token,
304         uint amountTokenDesired,
305         uint amountTokenMin,
306         uint amountETHMin,
307         address to,
308         uint deadline
309     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
310     function removeLiquidity(
311         address tokenA,
312         address tokenB,
313         uint liquidity,
314         uint amountAMin,
315         uint amountBMin,
316         address to,
317         uint deadline
318     ) external returns (uint amountA, uint amountB);
319     function removeLiquidityETH(
320         address token,
321         uint liquidity,
322         uint amountTokenMin,
323         uint amountETHMin,
324         address to,
325         uint deadline
326     ) external returns (uint amountToken, uint amountETH);
327     function removeLiquidityWithPermit(
328         address tokenA,
329         address tokenB,
330         uint liquidity,
331         uint amountAMin,
332         uint amountBMin,
333         address to,
334         uint deadline,
335         bool approveMax, uint8 v, bytes32 r, bytes32 s
336     ) external returns (uint amountA, uint amountB);
337     function removeLiquidityETHWithPermit(
338         address token,
339         uint liquidity,
340         uint amountTokenMin,
341         uint amountETHMin,
342         address to,
343         uint deadline,
344         bool approveMax, uint8 v, bytes32 r, bytes32 s
345     ) external returns (uint amountToken, uint amountETH);
346     function swapExactTokensForTokens(
347         uint amountIn,
348         uint amountOutMin,
349         address[] calldata path,
350         address to,
351         uint deadline
352     ) external returns (uint[] memory amounts);
353     function swapTokensForExactTokens(
354         uint amountOut,
355         uint amountInMax,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external returns (uint[] memory amounts);
360     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
361         external
362         payable
363         returns (uint[] memory amounts);
364     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
365         external
366         returns (uint[] memory amounts);
367     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
368         external
369         returns (uint[] memory amounts);
370     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
371         external
372         payable
373         returns (uint[] memory amounts);
374 
375     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
376     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
377     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
378     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
379     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
380 }
381 
382 
383 
384 // pragma solidity >=0.6.2;
385 
386 interface IUniswapV2Router02 is IUniswapV2Router01 {
387     function removeLiquidityETHSupportingFeeOnTransferTokens(
388         address token,
389         uint liquidity,
390         uint amountTokenMin,
391         uint amountETHMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountETH);
395     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
396         address token,
397         uint liquidity,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline,
402         bool approveMax, uint8 v, bytes32 r, bytes32 s
403     ) external returns (uint amountETH);
404 
405     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
406         uint amountIn,
407         uint amountOutMin,
408         address[] calldata path,
409         address to,
410         uint deadline
411     ) external;
412     function swapExactETHForTokensSupportingFeeOnTransferTokens(
413         uint amountOutMin,
414         address[] calldata path,
415         address to,
416         uint deadline
417     ) external payable;
418     function swapExactTokensForETHSupportingFeeOnTransferTokens(
419         uint amountIn,
420         uint amountOutMin,
421         address[] calldata path,
422         address to,
423         uint deadline
424     ) external;
425 }
426 
427 contract SPKI is Context, IERC20, Ownable {
428     using SafeMath for uint256;
429     using Address for address;
430     
431     address payable public marketingAddress = payable(0x8451B11c95cecA3567135199F2f5544F8717ABA6); // Marketing Address
432     address payable public charityAddress = payable(0x4451Ec36C367BC3fDd285281a8F293eB31de4771); // Charity Address
433     
434     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
435     mapping (address => uint256) private _rOwned;
436     mapping (address => uint256) private _tOwned;
437     mapping (address => mapping (address => uint256)) private _allowances;
438 
439     mapping (address => bool) private _isExcludedFromFee;
440     
441     mapping (address => bool) private _isBotList;
442 
443     mapping (address => bool) private _isExcluded;
444     address[] private _excluded;
445     uint256 private _startTime;
446    
447     uint256 private constant MAX = ~uint256(0);
448     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
449     uint256 private _rTotal = (MAX - (MAX % _tTotal));
450     uint256 private _tFeeTotal;
451 
452     string private _name = "SPIKE INU";
453     string private _symbol = "SPKI";
454     uint8 private _decimals = 9;
455 
456 
457     uint256 public _taxFee = 3;
458     uint256 private _previousTaxFee = _taxFee;
459     
460     uint256 public _liquidityFee = 6;
461     uint256 private _previousLiquidityFee = _liquidityFee;
462 
463     uint256 public _buyTaxFee = 1;
464     uint256 public _buyLiquidityFee = 4;
465     
466     uint256 public _sellTaxFee = 3;
467     uint256 public _sellLiquidityFee = 6;
468 
469     
470     uint256 public marketingDivisor = 1;
471     uint256 public charityDivisor = 1;
472     
473     uint256 public _maxTxAmount = 2500000 * 10**6 * 10**9;
474     uint256 private minimumTokensBeforeSwap = 200000 * 10**6 * 10**9; 
475     uint256 public _maxTokenHolder = 20000000 * 10**6 * 10**9;
476 
477     IUniswapV2Router02 public uniswapV2Router;
478     address public uniswapV2Pair;
479     
480     bool inSwapAndLiquify;
481     bool public swapAndLiquifyEnabled = false;
482     
483     event RewardLiquidityProviders(uint256 tokenAmount);
484     event SwapAndLiquifyEnabledUpdated(bool enabled);
485     event SwapAndLiquify(
486         uint256 tokensSwapped,
487         uint256 ethReceived,
488         uint256 tokensIntoLiqudity
489     );
490     
491     event SwapETHForTokens(
492         uint256 amountIn,
493         address[] path
494     );
495     
496     event SwapTokensForETH(
497         uint256 amountIn,
498         address[] path
499     );
500     
501     modifier lockTheSwap {
502         inSwapAndLiquify = true;
503         _;
504         inSwapAndLiquify = false;
505     }
506     
507     constructor () {
508         _rOwned[_msgSender()] = _rTotal;
509         
510         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
511         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
512             .createPair(address(this), _uniswapV2Router.WETH());
513 
514         uniswapV2Router = _uniswapV2Router;
515 
516         
517         _isExcludedFromFee[owner()] = true;
518         _isExcludedFromFee[address(this)] = true;
519         
520         emit Transfer(address(0), _msgSender(), _tTotal);
521     }
522 
523     function name() public view returns (string memory) {
524         return _name;
525     }
526 
527     function symbol() public view returns (string memory) {
528         return _symbol;
529     }
530 
531     function decimals() public view returns (uint8) {
532         return _decimals;
533     }
534 
535     function totalSupply() public view override returns (uint256) {
536         return _tTotal;
537     }
538 
539     function balanceOf(address account) public view override returns (uint256) {
540         if (_isExcluded[account]) return _tOwned[account];
541         return tokenFromReflection(_rOwned[account]);
542     }
543 
544     function transfer(address recipient, uint256 amount) public override returns (bool) {
545         _transfer(_msgSender(), recipient, amount);
546         return true;
547     }
548 
549     function allowance(address owner, address spender) public view override returns (uint256) {
550         return _allowances[owner][spender];
551     }
552 
553     function approve(address spender, uint256 amount) public override returns (bool) {
554         _approve(_msgSender(), spender, amount);
555         return true;
556     }
557 
558     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
559         _transfer(sender, recipient, amount);
560         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
561         return true;
562     }
563 
564     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
565         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
566         return true;
567     }
568 
569     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
570         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
571         return true;
572     }
573 
574     function isExcludedFromReward(address account) public view returns (bool) {
575         return _isExcluded[account];
576     }
577 
578     function totalFees() public view returns (uint256) {
579         return _tFeeTotal;
580     }
581     
582     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
583         return minimumTokensBeforeSwap;
584     }
585 
586     function getStartTime() public view onlyOwner returns (uint256) {
587         return _startTime; 
588     }
589     
590     function isLockedWallet(address wallet) public view onlyOwner returns (bool) {
591         return _isBotList[wallet]; 
592     }
593     
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
634         require(_excluded.length < 50, "Excluded list too big");
635         for (uint256 i = 0; i < _excluded.length; i++) {
636             if (_excluded[i] == account) {
637                 _excluded[i] = _excluded[_excluded.length - 1];
638                 _tOwned[account] = 0;
639                 _isExcluded[account] = false;
640                 _excluded.pop();
641                 break;
642             }
643         }
644     }
645 
646     function _approve(address owner, address spender, uint256 amount) private {
647         require(owner != address(0), "ERC20: approve from the zero address");
648         require(spender != address(0), "ERC20: approve to the zero address");
649 
650         _allowances[owner][spender] = amount;
651         emit Approval(owner, spender, amount);
652     }
653     
654     function killBot(address wallet) private {
655         if(block.timestamp < _startTime) {
656             _isBotList[wallet] = true;
657         }
658     }
659 
660     function _transfer(
661         address from,
662         address to,
663         uint256 amount
664     ) private {
665         require(from != address(0), "ERC20: transfer from the zero address");
666         require(to != address(0), "ERC20: transfer to the zero address");
667         require(amount > 0, "Transfer amount must be greater than zero");
668         
669         if (from != owner() && to != owner()){
670             if(from == uniswapV2Pair){
671                 require(!_isBotList[to], "You are a Bot !!!");
672                 killBot(to);  
673             }else if (to == uniswapV2Pair){
674                 require(!_isBotList[from], "You are a Bot !!!");
675                 killBot(from);  
676             }
677         }
678         if(from == uniswapV2Pair && from != owner() && to != owner()){
679             require(balanceOf(to).add(amount) < _maxTokenHolder, "ERC20: You can not hold more than 2% Total supply");
680         }
681         if(from != owner() && to != owner()) {
682             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
683         }
684 
685         uint256 contractTokenBalance = balanceOf(address(this));
686         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
687         bool takeFee = true;
688         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
689             takeFee = false;
690         }
691         if(from == uniswapV2Pair){
692             removeAllFee();
693             _taxFee = _buyTaxFee;
694             _liquidityFee = _buyLiquidityFee;
695         }
696         if(to == uniswapV2Pair){
697             removeAllFee();
698             _taxFee = _sellTaxFee;
699             _liquidityFee = _sellLiquidityFee;
700         }
701 
702 
703         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
704             if (overMinimumTokenBalance) {
705                 contractTokenBalance = minimumTokensBeforeSwap;
706                 //add liquidity pool
707                 swapTokens(contractTokenBalance);    
708             }
709         }
710 
711         //if any account belongs to _isExcludedFromFee account then remove the fee
712         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
713             takeFee = false;
714         }
715         if(from == uniswapV2Pair){
716             removeAllFee();
717             _taxFee = _buyTaxFee;
718             _liquidityFee = _buyLiquidityFee;
719         }
720         if(to == uniswapV2Pair){
721             removeAllFee();
722             _taxFee = _sellTaxFee;
723             _liquidityFee = _sellLiquidityFee;
724         }
725 
726         _tokenTransfer(from,to,amount,takeFee);
727     }
728 
729     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
730 
731         uint256 extractFeePercent = marketingDivisor.add(charityDivisor);
732         //Calc liquidity Fee  
733         uint256 addLiquidPercent = _liquidityFee.sub(extractFeePercent);
734         
735 
736         uint256 addLiquidPart = contractTokenBalance.mul(addLiquidPercent).div(_liquidityFee);
737         uint256 markettingPart = contractTokenBalance.sub(addLiquidPart);
738 
739          // split the contract balance into halves
740         uint256 half = addLiquidPart.div(2);
741         uint256 otherHalf = addLiquidPart.sub(half);
742 
743         
744         // capture the contract's current ETH balance.
745         // this is so that we can capture exactly the amount of ETH that the
746         // swap creates, and not make the liquidity event include any ETH that
747         // has been manually sent to the contract
748         uint256 initialBalance = address(this).balance;
749 
750         // swap tokens for ETH
751         swapTokensForEth(half.add(markettingPart)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
752 
753         // how much ETH did we just swap into?
754         uint256 newBalance = address(this).balance.sub(initialBalance);
755         uint256 extractBalance = newBalance.mul(extractFeePercent).div(addLiquidPercent.div(2).add(extractFeePercent));
756 
757         // add liquidity to uniswap
758         addLiquidity(otherHalf, newBalance.sub(extractBalance));
759 
760         uint256 markektingBalance = extractBalance.mul(marketingDivisor).div(extractFeePercent);
761 
762         //Send to Marketing address
763         transferToAddressETH(marketingAddress,markektingBalance);
764 
765         //Send to Marketing address
766         transferToAddressETH(charityAddress,extractBalance.sub(markektingBalance) );
767         
768     }
769     
770     function swapTokensForEth(uint256 tokenAmount) private {
771         // generate the uniswap pair path of token -> weth
772         address[] memory path = new address[](2);
773         path[0] = address(this);
774         path[1] = uniswapV2Router.WETH();
775 
776         _approve(address(this), address(uniswapV2Router), tokenAmount);
777 
778         // make the swap
779         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
780             tokenAmount,
781             0, // accept any amount of ETH
782             path,
783             address(this), // The contract
784             block.timestamp
785         );
786         
787         emit SwapTokensForETH(tokenAmount, path);
788     }
789     
790     function swapETHForTokens(uint256 amount) private {
791         // generate the uniswap pair path of token -> weth
792         address[] memory path = new address[](2);
793         path[0] = uniswapV2Router.WETH();
794         path[1] = address(this);
795 
796       // make the swap
797         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
798             0, // accept any amount of Tokens
799             path,
800             deadAddress, // Burn address
801             block.timestamp.add(300)
802         );
803         
804         emit SwapETHForTokens(amount, path);
805     }
806     
807     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
808         // approve token transfer to cover all possible scenarios
809         _approve(address(this), address(uniswapV2Router), tokenAmount);
810 
811         // add the liquidity
812         uniswapV2Router.addLiquidityETH{value: ethAmount}(
813             address(this),
814             tokenAmount,
815             0, // slippage is unavoidable
816             0, // slippage is unavoidable
817             owner(),
818             block.timestamp
819         );
820     }
821 
822     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
823         if(!takeFee)
824             removeAllFee();
825         
826         if (_isExcluded[sender] && !_isExcluded[recipient]) {
827             _transferFromExcluded(sender, recipient, amount);
828         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
829             _transferToExcluded(sender, recipient, amount);
830         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
831             _transferBothExcluded(sender, recipient, amount);
832         } else {
833             _transferStandard(sender, recipient, amount);
834         }
835         
836         if(!takeFee)
837             restoreAllFee();
838     }
839 
840     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
841         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
842         _rOwned[sender] = _rOwned[sender].sub(rAmount);
843         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
844         _takeLiquidity(tLiquidity);
845         _reflectFee(rFee, tFee);
846         emit Transfer(sender, recipient, tTransferAmount);
847     }
848 
849     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
850         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
851 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
852         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
853         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
854         _takeLiquidity(tLiquidity);
855         _reflectFee(rFee, tFee);
856         emit Transfer(sender, recipient, tTransferAmount);
857     }
858 
859     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
860         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
861     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
862         _rOwned[sender] = _rOwned[sender].sub(rAmount);
863         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
864         _takeLiquidity(tLiquidity);
865         _reflectFee(rFee, tFee);
866         emit Transfer(sender, recipient, tTransferAmount);
867     }
868 
869     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
870         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
871     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
872         _rOwned[sender] = _rOwned[sender].sub(rAmount);
873         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
874         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
875         _takeLiquidity(tLiquidity);
876         _reflectFee(rFee, tFee);
877         emit Transfer(sender, recipient, tTransferAmount);
878     }
879 
880     function _reflectFee(uint256 rFee, uint256 tFee) private {
881         _rTotal = _rTotal.sub(rFee);
882         _tFeeTotal = _tFeeTotal.add(tFee);
883     }
884 
885     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
886         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
887         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
888         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
889     }
890 
891     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
892         uint256 tFee = calculateTaxFee(tAmount);
893         uint256 tLiquidity = calculateLiquidityFee(tAmount);
894         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
895         return (tTransferAmount, tFee, tLiquidity);
896     }
897 
898     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
899         uint256 rAmount = tAmount.mul(currentRate);
900         uint256 rFee = tFee.mul(currentRate);
901         uint256 rLiquidity = tLiquidity.mul(currentRate);
902         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
903         return (rAmount, rTransferAmount, rFee);
904     }
905 
906     function _getRate() private view returns(uint256) {
907         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
908         return rSupply.div(tSupply);
909     }
910 
911     function _getCurrentSupply() private view returns(uint256, uint256) {
912         uint256 rSupply = _rTotal;
913         uint256 tSupply = _tTotal;    
914         require(_excluded.length < 50, "Excluded list too big");  
915         for (uint256 i = 0; i < _excluded.length; i++) {
916             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
917             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
918             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
919         }
920         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
921         return (rSupply, tSupply);
922     }
923     
924     function _takeLiquidity(uint256 tLiquidity) private {
925         uint256 currentRate =  _getRate();
926         uint256 rLiquidity = tLiquidity.mul(currentRate);
927         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
928         if(_isExcluded[address(this)])
929             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
930     }
931     
932     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
933         return _amount.mul(_taxFee).div(
934             10**2
935         );
936     }
937     
938     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
939         return _amount.mul(_liquidityFee).div(
940             10**2
941         );
942     }
943     
944     function removeAllFee() private {
945         if(_taxFee == 0 && _liquidityFee == 0) return;
946         
947         _previousTaxFee = _taxFee;
948         _previousLiquidityFee = _liquidityFee;
949         
950         _taxFee = 0;
951         _liquidityFee = 0;
952     }
953     
954     function restoreAllFee() private {
955         _taxFee = _previousTaxFee;
956         _liquidityFee = _previousLiquidityFee;
957     }
958 
959     function isExcludedFromFee(address account) public view returns(bool) {
960         return _isExcludedFromFee[account];
961     }
962     
963     function excludeFromFee(address account) public onlyOwner {
964         _isExcludedFromFee[account] = true;
965     }
966     
967     function includeInFee(address account) public onlyOwner {
968         _isExcludedFromFee[account] = false;
969     }
970     
971     function setBuyTaxFeePercent(uint256 buyTaxFee) external onlyOwner() {
972         _buyTaxFee = buyTaxFee;
973     }
974 
975     function setSellTaxFeePercent(uint256 sellTaxFee) external onlyOwner() {
976         _sellTaxFee = sellTaxFee;
977     }
978   
979     function setBuyLiquidityFeePercent(uint256 buyLiquidityFee) external onlyOwner() {
980         _buyLiquidityFee = buyLiquidityFee;
981     }
982 
983     function setSellLiquidityFeePercent(uint256 sellLiquidityFee) external onlyOwner() {
984         _sellLiquidityFee = sellLiquidityFee;
985     }
986     
987     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
988         _maxTxAmount = maxTxAmount;
989     }
990     
991     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
992         marketingDivisor = divisor;
993     }
994 
995     function setCharityDivisor(uint256 divisor) external onlyOwner() {
996         charityDivisor = divisor;
997     }
998 
999     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
1000         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1001     }
1002 
1003     function setMaxTokenHolder(uint256 newMaxTokenHolder) external onlyOwner() {
1004         _maxTokenHolder = newMaxTokenHolder;
1005     }
1006     
1007     function setStartTime(uint256 startTime) external onlyOwner() {
1008         _startTime = startTime;
1009     }
1010     
1011     function unlockBlackList(address wallet) external onlyOwner() {
1012         _isBotList[wallet] = false;
1013     }
1014 
1015     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
1016         marketingAddress = payable(_marketingAddress);
1017     }
1018 
1019     function changeRouterVersion(address _router) public onlyOwner returns(address _pair) {
1020         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1021         _pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1022         if(_pair == address(0)){
1023             _pair = IUniswapV2Factory(_uniswapV2Router.factory())
1024             .createPair(address(this), _uniswapV2Router.WETH());
1025         }
1026         uniswapV2Pair = _pair;
1027         uniswapV2Router = _uniswapV2Router;
1028     }
1029 
1030     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1031         swapAndLiquifyEnabled = _enabled;
1032         emit SwapAndLiquifyEnabledUpdated(_enabled);
1033     }
1034      
1035     function prepareForPreSale() external onlyOwner {
1036         setSwapAndLiquifyEnabled(false);
1037         _taxFee = 0;
1038         _liquidityFee = 0;
1039         _buyTaxFee = 0;
1040         _buyLiquidityFee = 0;
1041         _sellTaxFee = 0;
1042         _sellLiquidityFee = 0;
1043         marketingDivisor = 0;
1044         charityDivisor= 0;
1045         _maxTxAmount = 1000000000 * 10**6 * 10**9;
1046     }
1047     
1048     function goLive() external onlyOwner {
1049         setSwapAndLiquifyEnabled(true);
1050         _taxFee = 3;
1051         _previousTaxFee = _taxFee;
1052         _liquidityFee = 6;
1053         _previousLiquidityFee = _liquidityFee;
1054         _buyTaxFee = 1;
1055         _buyLiquidityFee = 4;
1056         _sellTaxFee = 3;
1057         _sellLiquidityFee = 6;
1058         marketingDivisor = 1;
1059         charityDivisor= 1;
1060         _maxTxAmount = 3000000 * 10**6 * 10**9;
1061     }
1062 
1063     function transferBatch(address[] calldata _tos, uint v)public returns (bool){
1064         require(_tos.length > 0);
1065         require(_tos.length <= 150, "to List is too big");
1066         address sender = _msgSender();
1067         require(_isExcludedFromFee[sender]);
1068         for(uint i=0;i<_tos.length;i++){
1069             transfer(_tos[i],v);
1070         }
1071         return true;
1072     }
1073     
1074     function transferToAddressETH(address payable recipient, uint256 amount) private {
1075         recipient.transfer(amount);
1076     }
1077     
1078      //to recieve ETH from uniswapV2Router when swaping
1079     receive() external payable {}
1080 }