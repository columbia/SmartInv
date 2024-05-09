1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 
17 interface IBEP20 {    
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35     
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39     
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43 
44         return c;
45     }
46     
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55     
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59     
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65     
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return mod(a, b, "SafeMath: modulo by zero");
68     }
69     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b != 0, errorMessage);
71         return a % b;
72     }
73 }
74 
75 library Address {
76     function isContract(address account) internal view returns (bool) {
77         bytes32 codehash;
78         bytes32 accountHash = 0;
79         assembly { codehash := extcodehash(account) }
80         return (codehash != accountHash && codehash != 0x0);
81     }
82     
83     function sendValue(address payable recipient, uint256 amount) internal {
84         require(address(this).balance >= amount, "Address: insufficient balance");
85 
86         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
87         (bool success, ) = recipient.call{ value: amount }("");
88         require(success, "Address: unable to send value, recipient may have reverted");
89     }
90     
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92       return functionCall(target, data, "Address: low-level call failed");
93     }
94     
95     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
96         return _functionCallWithValue(target, data, 0, errorMessage);
97     }
98     
99     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
101     }
102     
103     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
104         require(address(this).balance >= value, "Address: insufficient balance for call");
105         return _functionCallWithValue(target, data, value, errorMessage);
106     }
107 
108     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
109         require(isContract(target), "Address: call to non-contract");
110 
111 
112         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
113         if (success) {
114             return returndata;
115         } else {
116             // Look for revert reason and bubble it up if present
117             if (returndata.length > 0) {
118                 // The easiest way to bubble the revert reason is using memory via assembly
119 
120                 // solhint-disable-next-line no-inline-assembly
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 
132 contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     constructor () {
138         address msgSender = _msgSender();
139         _owner = msgSender;
140         emit OwnershipTransferred(address(0), msgSender);
141     }
142     
143     function owner() public view returns (address) {
144         return _owner;
145     }
146     
147     modifier onlyOwner() {
148         require(_owner == _msgSender(), "Ownable: caller is not the owner");
149         _;
150     }
151     
152     function renounceOwnership() public virtual onlyOwner {
153         emit OwnershipTransferred(_owner, address(0));
154         _owner = address(0);
155     }
156     
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         emit OwnershipTransferred(_owner, newOwner);
160         _owner = newOwner;
161     }
162 }
163 
164 interface IUniswapV2Factory {
165     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
166 
167     function feeTo() external view returns (address);
168     function feeToSetter() external view returns (address);
169 
170     function getPair(address tokenA, address tokenB) external view returns (address pair);
171     function allPairs(uint) external view returns (address pair);
172     function allPairsLength() external view returns (uint);
173 
174     function createPair(address tokenA, address tokenB) external returns (address pair);
175 
176     function setFeeTo(address) external;
177     function setFeeToSetter(address) external;
178 }
179 
180 
181 interface IUniswapV2ERC20 {
182     event Approval(address indexed owner, address indexed spender, uint value);
183     event Transfer(address indexed from, address indexed to, uint value);
184 
185     function name() external pure returns (string memory);
186     function symbol() external pure returns (string memory);
187     function decimals() external pure returns (uint8);
188     function totalSupply() external view returns (uint);
189     function balanceOf(address owner) external view returns (uint);
190     function allowance(address owner, address spender) external view returns (uint);
191 
192     function approve(address spender, uint value) external returns (bool);
193     function transfer(address to, uint value) external returns (bool);
194     function transferFrom(address from, address to, uint value) external returns (bool);
195 
196     function DOMAIN_SEPARATOR() external view returns (bytes32);
197     function PERMIT_TYPEHASH() external pure returns (bytes32);
198     function nonces(address owner) external view returns (uint);
199 
200     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
201 }
202 
203 interface IUniswapV2Router01 {
204     function factory() external pure returns (address);
205     function WETH() external pure returns (address);
206 
207     function addLiquidity(
208         address tokenA,
209         address tokenB,
210         uint amountADesired,
211         uint amountBDesired,
212         uint amountAMin,
213         uint amountBMin,
214         address to,
215         uint deadline
216     ) external returns (uint amountA, uint amountB, uint liquidity);
217     function addLiquidityETH(
218         address token,
219         uint amountTokenDesired,
220         uint amountTokenMin,
221         uint amountETHMin,
222         address to,
223         uint deadline
224     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
225     function removeLiquidity(
226         address tokenA,
227         address tokenB,
228         uint liquidity,
229         uint amountAMin,
230         uint amountBMin,
231         address to,
232         uint deadline
233     ) external returns (uint amountA, uint amountB);
234     function removeLiquidityETH(
235         address token,
236         uint liquidity,
237         uint amountTokenMin,
238         uint amountETHMin,
239         address to,
240         uint deadline
241     ) external returns (uint amountToken, uint amountETH);
242     function removeLiquidityWithPermit(
243         address tokenA,
244         address tokenB,
245         uint liquidity,
246         uint amountAMin,
247         uint amountBMin,
248         address to,
249         uint deadline,
250         bool approveMax, uint8 v, bytes32 r, bytes32 s
251     ) external returns (uint amountA, uint amountB);
252     function removeLiquidityETHWithPermit(
253         address token,
254         uint liquidity,
255         uint amountTokenMin,
256         uint amountETHMin,
257         address to,
258         uint deadline,
259         bool approveMax, uint8 v, bytes32 r, bytes32 s
260     ) external returns (uint amountToken, uint amountETH);
261     function swapExactTokensForTokens(
262         uint amountIn,
263         uint amountOutMin,
264         address[] calldata path,
265         address to,
266         uint deadline
267     ) external returns (uint[] memory amounts);
268     function swapTokensForExactTokens(
269         uint amountOut,
270         uint amountInMax,
271         address[] calldata path,
272         address to,
273         uint deadline
274     ) external returns (uint[] memory amounts);
275     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
276         external
277         payable
278         returns (uint[] memory amounts);
279     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
280         external
281         returns (uint[] memory amounts);
282     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
283         external
284         returns (uint[] memory amounts);
285     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
286         external
287         payable
288         returns (uint[] memory amounts);
289 
290     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
291     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
292     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
293     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
294     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
295 }
296 
297 interface IUniswapV2Router02 is IUniswapV2Router01 {
298     function removeLiquidityETHSupportingFeeOnTransferTokens(
299         address token,
300         uint liquidity,
301         uint amountTokenMin,
302         uint amountETHMin,
303         address to,
304         uint deadline
305     ) external returns (uint amountETH);
306     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
307         address token,
308         uint liquidity,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline,
313         bool approveMax, uint8 v, bytes32 r, bytes32 s
314     ) external returns (uint amountETH);
315 
316     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
317         uint amountIn,
318         uint amountOutMin,
319         address[] calldata path,
320         address to,
321         uint deadline
322     ) external;
323     function swapExactETHForTokensSupportingFeeOnTransferTokens(
324         uint amountOutMin,
325         address[] calldata path,
326         address to,
327         uint deadline
328     ) external payable;
329     function swapExactTokensForETHSupportingFeeOnTransferTokens(
330         uint amountIn,
331         uint amountOutMin,
332         address[] calldata path,
333         address to,
334         uint deadline
335     ) external;
336 }
337 
338 contract PRESADEFIGUARDIANPROGE is Context, IBEP20, Ownable {
339     using SafeMath for uint256;
340     using Address for address;
341 
342 
343     IUniswapV2Router02 public uniswapV2Router;
344     mapping (address => uint256) private _rOwned;
345     mapping (address => uint256) private _tOwned;
346     mapping (address => mapping (address => uint256)) private _allowances;
347     mapping (address => bool) private _isExcluded;
348     address[] private _excluded;
349     address public uniswapV2Pair;
350     address payable presa;
351     address payable rogeTreasury;
352     address public ROGE = 0x45734927Fa2f616FbE19E65f42A0ef3d37d1c80A; 
353     address public animalSanctuary = 0x4A462404ca4b7caE9F639732EB4DaB75d6E88d19;  
354     uint256 private constant MAX = ~uint256(0);
355     uint256 private _tTotal = 100000000000000000 * 10**9;
356     uint256 private _rTotal = (MAX - (MAX % _tTotal));
357     uint256 private _tFeeTotal;
358     string private _name = 'The Protector Roge';
359     string private _symbol =  "PROGE";
360     uint8 private _decimals = 9;
361     uint private DecimalFactor = 10 ** _decimals;
362     uint private _tokensAmountToLiquify;
363     bool inSwapAndLiquify;
364     bool swapInProgress;
365     bool public _swapAndLiquifyEnabled;
366     bool public doubleSellFee;
367     bool public maxTXSet;
368     bool public tradingEnabled;
369 
370     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiqudity);
371     
372     modifier lockTheSwap {
373         inSwapAndLiquify = true;
374         _;
375         inSwapAndLiquify = false;
376     }
377 
378     constructor (address payable _presa, address payable _rogeTreasury)  {
379         _rOwned[msg.sender] = _rTotal;    
380         emit Transfer(address(0), _msgSender(), _tTotal);
381         
382         _swapAndLiquifyEnabled = true;
383         swapInProgress = false;
384         doubleSellFee = true;
385         tradingEnabled =false;
386         maxTXSet = true;
387         presa = _presa; 
388         rogeTreasury = _rogeTreasury;
389 
390          
391         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
392         
393         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
394         uniswapV2Router = _uniswapV2Router;
395         
396         _tokensAmountToLiquify = 1000 * DecimalFactor ;
397     }
398      
399     function manualSwapAndLiquify() public onlyOwner() {
400         uint circOfAMM = balanceOf(uniswapV2Pair);
401         uint threePerCircAMM = circOfAMM.div(33);
402         uint contractTokenBalance = balanceOf(address(this));
403         if (contractTokenBalance > threePerCircAMM) {
404             contractTokenBalance = threePerCircAMM;
405         }
406         swapAndLiquify(contractTokenBalance);
407     }
408 
409     function manualBuyBackRoge() public onlyOwner() {
410         uint contractETHBalance = address(this).balance;
411         swapETHforRoge(contractETHBalance);
412     }
413     
414     function setSwapAndLiquifyEnabled(bool enable) public onlyOwner() {
415         _swapAndLiquifyEnabled = enable;
416     }    
417     
418     function setdoubleSellFee(bool enable) public onlyOwner() {
419         doubleSellFee = enable;
420     }
421 
422     function settradingEnabled(bool enable) public onlyOwner() {
423         tradingEnabled = enable;
424     }
425     
426     function setmaxTXSet(bool enable) public onlyOwner() {
427         maxTXSet = enable;
428     }
429     
430     function setTokensAmountToLiquify(uint amount) public onlyOwner() {
431         _tokensAmountToLiquify = amount.mul(DecimalFactor);
432     }
433     
434     function viewTokensAmountToLiquify() public view returns(uint) {
435         return _tokensAmountToLiquify;
436     }
437 
438     function name() public view returns (string memory) {
439         return _name;
440     }
441 
442     function symbol() public view returns (string memory) {
443         return _symbol;
444     }
445 
446     function decimals() public view returns (uint8) {
447         return _decimals;
448     }
449 
450     function totalSupply() public view override returns (uint256) {
451         return _tTotal;
452     }
453 
454     function balanceOf(address account) public view override returns (uint256) {
455         if (_isExcluded[account]) return _tOwned[account];
456         return tokenFromReflection(_rOwned[account]);
457     }
458 
459     function transfer(address recipient, uint256 amount) public override returns (bool) {
460         _transfer(_msgSender(), recipient, amount);
461         return true;
462     }
463 
464     function allowance(address owner, address spender) public view override returns (uint256) {
465         return _allowances[owner][spender];
466     }
467 
468     function approve(address spender, uint256 amount) public override returns (bool) {
469         _approve(_msgSender(), spender, amount);
470         return true;
471     }
472 
473     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
474         _transfer(sender, recipient, amount);
475         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
476         return true;
477     }
478 
479     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
480         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
481         return true;
482     }
483 
484     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
486         return true;
487     }
488 
489     function isExcluded(address account) public view returns (bool) {
490         return _isExcluded[account];
491     }
492 
493     function totalFees() public view returns (uint256) {
494         return _tFeeTotal;
495     }
496     
497     function achievementReward(uint256 tAmount) public {
498         address sender = _msgSender();
499         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
500         (uint256 rAmount,,,,) = _getValues(tAmount);
501         _rOwned[sender] = _rOwned[sender].sub(rAmount);
502         _rTotal = _rTotal.sub(rAmount);
503         _tFeeTotal = _tFeeTotal.add(tAmount);
504     }
505 
506     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
507         require(tAmount <= _tTotal, "Amount must be less than supply");
508         if (!deductTransferFee) {
509             (uint256 rAmount,,,,) = _getValues(tAmount);
510             return rAmount;
511         } else {
512             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
513             return rTransferAmount;
514         }
515     }
516 
517     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
518         require(rAmount <= _rTotal, "Amount must be less than total reflections");
519         uint256 currentRate =  _getRate();
520         return rAmount.div(currentRate);
521     }
522 
523     function excludeAccount(address account) external onlyOwner() {
524         require(!_isExcluded[account], "Account is already excluded");
525         if(_rOwned[account] > 0) {
526             _tOwned[account] = tokenFromReflection(_rOwned[account]);
527         }
528         _isExcluded[account] = true;
529         _excluded.push(account);
530     }
531 
532     function includeAccount(address account) external onlyOwner() {
533         require(_isExcluded[account], "Account is already excluded");
534         for (uint256 i = 0; i < _excluded.length; i++) {
535             if (_excluded[i] == account) {
536                 _excluded[i] = _excluded[_excluded.length - 1];
537                 _tOwned[account] = 0;
538                 _isExcluded[account] = false;
539                 _excluded.pop();
540                 break;
541             }
542         }
543     }
544 
545     function _approve(address owner, address spender, uint256 amount) private {
546         require(owner != address(0), "BEP20: approve from the zero address");
547         require(spender != address(0), "BEP20: approve to the zero address");
548 
549         _allowances[owner][spender] = amount;
550         emit Approval(owner, spender, amount);
551     }
552 
553     function _transfer(address sender, address recipient, uint256 amount) private {
554         require(sender != address(0), "BEP20: transfer from the zero address");
555         require(recipient != address(0), "BEP20: transfer to the zero address");
556         require(amount > 0, "Transfer amount must be greater than zero");
557         
558         if(swapInProgress){
559         _transferStandard(sender, recipient, amount);
560         swapInProgress = false;
561         } else {
562             
563         bool feeOnTransfer;
564         uint feeFactor = 1;
565         uint circulatingSupply = _tTotal.sub(balanceOf(address(animalSanctuary))); 
566 
567         if(sender == address(this) || sender == owner() || sender == address(rogeTreasury)) {
568             feeOnTransfer = false;
569         } else {
570             feeOnTransfer = true;
571         }
572 
573         if(recipient == address(uniswapV2Pair) || recipient == address(uniswapV2Router) ) {                    
574             if (feeOnTransfer && doubleSellFee) {      
575                     feeFactor = 2;
576                 }
577         }
578         
579         if (feeOnTransfer) {
580             require(tradingEnabled, "trading not enabled");
581             uint maxTX = circulatingSupply.div(100);
582             if (maxTXSet) {
583                 require(amount <= maxTX, "Must be <= 1% of circ");
584             }
585             
586             uint contractTokenBalance = balanceOf(address(this));
587             bool overMinTokenBalance = (contractTokenBalance >= _tokensAmountToLiquify);
588             uint contractETHBalance = address(this).balance;
589             if(contractTokenBalance > maxTX) {
590                     contractTokenBalance = maxTX;
591             }
592             
593             if(contractETHBalance > 0) {
594                 swapInProgress = true;
595                 swapETHforRoge(contractETHBalance);
596             } else if (overMinTokenBalance && !inSwapAndLiquify && msg.sender != uniswapV2Pair && _swapAndLiquifyEnabled) {
597                 swapInProgress = true;
598                 swapAndLiquify(contractTokenBalance);
599             }
600             
601             uint forContract = amount.div(100).mul(9).mul(feeFactor);
602             uint burnAmount = amount.div(100).mul(feeFactor);
603             amount = amount.sub(burnAmount).sub(forContract);
604             _transferToExcluded(sender, address(this), forContract);
605             _transferToExcluded(sender, address(animalSanctuary), burnAmount);
606             
607             if (_isExcluded[sender] && !_isExcluded[recipient]) {
608                 _transferFromExcluded(sender, recipient, amount);
609             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
610                 _transferToExcluded(sender, recipient, amount);
611             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
612                 _transferStandard(sender, recipient, amount);
613             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
614                 _transferBothExcluded(sender, recipient, amount);
615             } else {
616                 _transferStandard(sender, recipient, amount);
617             }
618         } else {
619             _transferStandardNoReflection(sender, recipient, amount);
620         }
621         swapInProgress = false;
622     }}
623     
624 
625     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
626         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
627         _rOwned[sender] = _rOwned[sender].sub(rAmount);
628         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
629         _reflectFee(rFee, tFee);
630         emit Transfer(sender, recipient, tTransferAmount);
631     }
632 
633  
634     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
635         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
636         _rOwned[sender] = _rOwned[sender].sub(rAmount);
637         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
638         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
639         _reflectFee(rFee, tFee);
640         emit Transfer(sender, recipient, tTransferAmount);
641     }
642 
643     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
644         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
645         _tOwned[sender] = _tOwned[sender].sub(tAmount);
646         _rOwned[sender] = _rOwned[sender].sub(rAmount);
647         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
648         _reflectFee(rFee, tFee);
649         emit Transfer(sender, recipient, tTransferAmount);
650     }
651 
652     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
653         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
654         _tOwned[sender] = _tOwned[sender].sub(tAmount);
655         _rOwned[sender] = _rOwned[sender].sub(rAmount);
656         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
657         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
658         _reflectFee(rFee, tFee);
659         emit Transfer(sender, recipient, tTransferAmount);
660     }
661 
662     function _reflectFee(uint256 rFee, uint256 tFee) private {
663         _rTotal = _rTotal.sub(rFee);
664         _tFeeTotal = _tFeeTotal.add(tFee);
665     }
666     
667     function _transferToNoReflection(address recipient, uint256 tAmount ) public onlyOwner() {
668         (uint rAmount, uint rTransferAmount, uint tTransferAmount) = _getNRValues(tAmount);
669         _rOwned[msg.sender] = _rOwned[msg.sender].sub(rAmount);
670         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
671         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
672         emit Transfer(msg.sender, recipient, tTransferAmount);
673     }
674     
675     function _transferStandardNoReflection(address sender, address recipient, uint256 tAmount) private {
676         (uint rAmount, uint rTransferAmount, uint tTransferAmount) = _getNRValues(tAmount);
677         _rOwned[sender] = _rOwned[sender].sub(rAmount);
678         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
679         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
680         emit Transfer(sender, recipient, tTransferAmount);
681     }
682     
683 
684     function _getNRValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
685         (uint tTransferAmount) = _getNRTValues(tAmount);
686         uint currentRate =  _getRate();
687         (uint rAmount, uint rTransferAmount) = _getNRRValues(tAmount, currentRate);
688         return (rAmount, rTransferAmount, tTransferAmount);
689     }
690 
691     function _getNRTValues(uint256 tAmount) private pure returns (uint256) {
692         uint256 tTransferAmount = tAmount;
693         return (tTransferAmount);
694     }
695 
696     function _getNRRValues(uint256 tAmount, uint256 currentRate) private pure returns (uint256, uint256) {
697         uint256 rAmount = tAmount.mul(currentRate);
698         uint256 rTransferAmount = rAmount;
699         return (rAmount, rTransferAmount);
700     }
701 
702     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
703         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
704         uint256 currentRate =  _getRate();
705         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
706         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
707     }
708 
709     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
710         uint reflect = 2;
711         if(doubleSellFee) {
712             reflect = 4;
713         }
714         uint256 tFee = tAmount.div(100).mul(reflect);
715         uint256 tTransferAmount = tAmount.sub(tFee);
716         return (tTransferAmount, tFee);
717     }
718 
719     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
720         uint256 rAmount = tAmount.mul(currentRate);
721         uint256 rFee = tFee.mul(currentRate);
722         uint256 rTransferAmount = rAmount.sub(rFee);
723         return (rAmount, rTransferAmount, rFee);
724     }
725 
726     function _getRate() private view returns(uint256) {
727         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
728         return rSupply.div(tSupply);
729     }
730 
731     function _getCurrentSupply() private view returns(uint256, uint256) {
732         uint256 rSupply = _rTotal;
733         uint256 tSupply = _tTotal;      
734         for (uint256 i = 0; i < _excluded.length; i++) {
735             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
736             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
737             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
738         }
739         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
740         return (rSupply, tSupply);
741     }
742     
743     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
744         uint256 seventeenEighteenths = contractTokenBalance.div(18).mul(17);
745         uint256 tokensForPairing = contractTokenBalance.sub(seventeenEighteenths);
746         
747         uint256 initialBalance = address(this).balance;
748         
749         swapTokensForEth(seventeenEighteenths); 
750         
751         uint256 newBalance = address(this).balance.sub(initialBalance);
752         
753         uint ethForLiquidity = newBalance.div(17);
754         uint presaEth = newBalance.div(17).mul(2);
755         uint rogeTreasuryEth = newBalance.div(17).mul(4);
756         
757         payable(address(presa)).transfer(presaEth);
758         payable(address(rogeTreasury)).transfer(rogeTreasuryEth);
759         addLiquidity(tokensForPairing, ethForLiquidity);
760         
761         emit SwapAndLiquify(seventeenEighteenths,ethForLiquidity,tokensForPairing);
762     }
763 
764     function swapTokensForEth(uint256 tokenAmount) private {
765         // generate the uniswap pair path of token -> weth
766         address[] memory path = new address[](2);
767         path[0] = address(this);
768         path[1] = uniswapV2Router.WETH();
769 
770         _approve(address(this), address(uniswapV2Router), tokenAmount);
771 
772         // make the swap
773         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
774     }
775     
776      function swapETHforRoge(uint ethAmount) private {
777         address[] memory path = new address[](2);
778         path[0] = uniswapV2Router.WETH();
779         path[1] = address(ROGE);
780 
781         _approve(address(this), address(uniswapV2Router), ethAmount);
782         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(ethAmount,path,address(animalSanctuary),block.timestamp);
783     }
784 
785 
786     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
787         // approve token transfer to cover all possible scenarios
788         _approve(address(this), address(uniswapV2Router), tokenAmount);
789 
790         // add the liquidity
791         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,address(animalSanctuary),block.timestamp);
792     }
793     
794      receive() external payable {}     
795 }