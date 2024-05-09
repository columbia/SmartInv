1 /*
2 
3 ----------------------------------   
4 ░█████╗░██████╗░████████╗██╗░░░██╗
5 ██╔══██╗██╔══██╗╚══██╔══╝╚██╗░██╔╝
6 ███████║██████╔╝░░░██║░░░░╚████╔╝░
7 ██╔══██║██╔══██╗░░░██║░░░░░╚██╔╝░░
8 ██║░░██║██║░░██║░░░██║░░░░░░██║░░░
9 ╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░░░░╚═╝░░░  
10 ----------------------------------
11 
12 Arty is built to reward our community for HODLing via weekly Airdrops of Exclusive NFT collabs with major artists.
13 
14 
15 Contract features:
16 
17 6% artist appreciation fee will be collected on each transaction for the first 60 days after launch.  Transaction Fee will be manually shutoff.
18 
19 */
20 
21 // SPDX-License-Identifier: Unlicensed
22 
23 pragma solidity ^0.8.4;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return payable(msg.sender);
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 
37 interface IERC20 {
38 
39     function totalSupply() external view returns (uint256);
40     function balanceOf(address account) external view returns (uint256);
41     function transfer(address recipient, uint256 amount) external returns (bool);
42     function allowance(address owner, address spender) external view returns (uint256);
43     function approve(address spender, uint256 amount) external returns (bool);
44     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47     
48 
49 }
50 
51 library SafeMath {
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78 
79         return c;
80     }
81 
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b != 0, errorMessage);
101         return a % b;
102     }
103 }
104 
105 library Address {
106 
107     function isContract(address account) internal view returns (bool) {
108         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
109         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
110         // for accounts without code, i.e. `keccak256('')`
111         bytes32 codehash;
112         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
113         // solhint-disable-next-line no-inline-assembly
114         assembly { codehash := extcodehash(account) }
115         return (codehash != accountHash && codehash != 0x0);
116     }
117 
118     function sendValue(address payable recipient, uint256 amount) internal {
119         require(address(this).balance >= amount, "Address: insufficient balance");
120 
121         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
122         (bool success, ) = recipient.call{ value: amount }("");
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125 
126 
127     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
128       return functionCall(target, data, "Address: low-level call failed");
129     }
130 
131     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
132         return _functionCallWithValue(target, data, 0, errorMessage);
133     }
134 
135     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         return _functionCallWithValue(target, data, value, errorMessage);
142     }
143 
144     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
145         require(isContract(target), "Address: call to non-contract");
146 
147         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
148         if (success) {
149             return returndata;
150         } else {
151             
152             if (returndata.length > 0) {
153                 assembly {
154                     let returndata_size := mload(returndata)
155                     revert(add(32, returndata), returndata_size)
156                 }
157             } else {
158                 revert(errorMessage);
159             }
160         }
161     }
162 }
163 
164 contract Ownable is Context {
165     address private _owner;
166     address private _previousOwner;
167     uint256 private _lockTime;
168 
169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
170 
171     constructor () {
172         address msgSender = _msgSender();
173         _owner = msgSender;
174         emit OwnershipTransferred(address(0), msgSender);
175     }
176 
177     function owner() public view returns (address) {
178         return _owner;
179     }   
180     
181     modifier onlyOwner() {
182         require(_owner == _msgSender(), "Ownable: caller is not the owner");
183         _;
184     }
185     
186     function renounceOwnership() public virtual onlyOwner {
187         emit OwnershipTransferred(_owner, address(0));
188         _owner = address(0);
189     }
190 
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(newOwner != address(0), "Ownable: new owner is the zero address");
193         emit OwnershipTransferred(_owner, newOwner);
194         _owner = newOwner;
195     }
196 
197     function getUnlockTime() public view returns (uint256) {
198         return _lockTime;
199     }
200     
201     function getTime() public view returns (uint256) {
202         return block.timestamp;
203     }
204 
205     function lock(uint256 time) public virtual onlyOwner {
206         _previousOwner = _owner;
207         _owner = address(0);
208         _lockTime = block.timestamp + time;
209         emit OwnershipTransferred(_owner, address(0));
210     }
211     
212     function unlock() public virtual {
213         require(_previousOwner == msg.sender, "You don't have permission to unlock");
214         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
215         emit OwnershipTransferred(_owner, _previousOwner);
216         _owner = _previousOwner;
217     }
218 }
219 
220 // pragma solidity >=0.5.0;
221 
222 interface IUniswapV2Factory {
223     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
224 
225     function feeTo() external view returns (address);
226     function feeToSetter() external view returns (address);
227 
228     function getPair(address tokenA, address tokenB) external view returns (address pair);
229     function allPairs(uint) external view returns (address pair);
230     function allPairsLength() external view returns (uint);
231 
232     function createPair(address tokenA, address tokenB) external returns (address pair);
233 
234     function setFeeTo(address) external;
235     function setFeeToSetter(address) external;
236 }
237 
238 
239 // pragma solidity >=0.5.0;
240 
241 interface IUniswapV2Pair {
242     event Approval(address indexed owner, address indexed spender, uint value);
243     event Transfer(address indexed from, address indexed to, uint value);
244 
245     function name() external pure returns (string memory);
246     function symbol() external pure returns (string memory);
247     function decimals() external pure returns (uint8);
248     function totalSupply() external view returns (uint);
249     function balanceOf(address owner) external view returns (uint);
250     function allowance(address owner, address spender) external view returns (uint);
251 
252     function approve(address spender, uint value) external returns (bool);
253     function transfer(address to, uint value) external returns (bool);
254     function transferFrom(address from, address to, uint value) external returns (bool);
255 
256     function DOMAIN_SEPARATOR() external view returns (bytes32);
257     function PERMIT_TYPEHASH() external pure returns (bytes32);
258     function nonces(address owner) external view returns (uint);
259 
260     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
261     
262     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
263     event Swap(
264         address indexed sender,
265         uint amount0In,
266         uint amount1In,
267         uint amount0Out,
268         uint amount1Out,
269         address indexed to
270     );
271     event Sync(uint112 reserve0, uint112 reserve1);
272 
273     function MINIMUM_LIQUIDITY() external pure returns (uint);
274     function factory() external view returns (address);
275     function token0() external view returns (address);
276     function token1() external view returns (address);
277     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
278     function price0CumulativeLast() external view returns (uint);
279     function price1CumulativeLast() external view returns (uint);
280     function kLast() external view returns (uint);
281 
282     function burn(address to) external returns (uint amount0, uint amount1);
283     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
284     function skim(address to) external;
285     function sync() external;
286 
287     function initialize(address, address) external;
288 }
289 
290 // pragma solidity >=0.6.2;
291 
292 interface IUniswapV2Router01 {
293     function factory() external pure returns (address);
294     function WETH() external pure returns (address);
295 
296     function addLiquidity(
297         address tokenA,
298         address tokenB,
299         uint amountADesired,
300         uint amountBDesired,
301         uint amountAMin,
302         uint amountBMin,
303         address to,
304         uint deadline
305     ) external returns (uint amountA, uint amountB, uint liquidity);
306     function addLiquidityETH(
307         address token,
308         uint amountTokenDesired,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline
313     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
314     function removeLiquidity(
315         address tokenA,
316         address tokenB,
317         uint liquidity,
318         uint amountAMin,
319         uint amountBMin,
320         address to,
321         uint deadline
322     ) external returns (uint amountA, uint amountB);
323     function removeLiquidityETH(
324         address token,
325         uint liquidity,
326         uint amountTokenMin,
327         uint amountETHMin,
328         address to,
329         uint deadline
330     ) external returns (uint amountToken, uint amountETH);
331     function removeLiquidityWithPermit(
332         address tokenA,
333         address tokenB,
334         uint liquidity,
335         uint amountAMin,
336         uint amountBMin,
337         address to,
338         uint deadline,
339         bool approveMax, uint8 v, bytes32 r, bytes32 s
340     ) external returns (uint amountA, uint amountB);
341     function removeLiquidityETHWithPermit(
342         address token,
343         uint liquidity,
344         uint amountTokenMin,
345         uint amountETHMin,
346         address to,
347         uint deadline,
348         bool approveMax, uint8 v, bytes32 r, bytes32 s
349     ) external returns (uint amountToken, uint amountETH);
350     function swapExactTokensForTokens(
351         uint amountIn,
352         uint amountOutMin,
353         address[] calldata path,
354         address to,
355         uint deadline
356     ) external returns (uint[] memory amounts);
357     function swapTokensForExactTokens(
358         uint amountOut,
359         uint amountInMax,
360         address[] calldata path,
361         address to,
362         uint deadline
363     ) external returns (uint[] memory amounts);
364     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
365         external
366         payable
367         returns (uint[] memory amounts);
368     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
369         external
370         returns (uint[] memory amounts);
371     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
372         external
373         returns (uint[] memory amounts);
374     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
375         external
376         payable
377         returns (uint[] memory amounts);
378 
379     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
380     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
381     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
382     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
383     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
384 }
385 
386 
387 
388 // pragma solidity >=0.6.2;
389 
390 interface IUniswapV2Router02 is IUniswapV2Router01 {
391     function removeLiquidityETHSupportingFeeOnTransferTokens(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline
398     ) external returns (uint amountETH);
399     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
400         address token,
401         uint liquidity,
402         uint amountTokenMin,
403         uint amountETHMin,
404         address to,
405         uint deadline,
406         bool approveMax, uint8 v, bytes32 r, bytes32 s
407     ) external returns (uint amountETH);
408 
409     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
410         uint amountIn,
411         uint amountOutMin,
412         address[] calldata path,
413         address to,
414         uint deadline
415     ) external;
416     function swapExactETHForTokensSupportingFeeOnTransferTokens(
417         uint amountOutMin,
418         address[] calldata path,
419         address to,
420         uint deadline
421     ) external payable;
422     function swapExactTokensForETHSupportingFeeOnTransferTokens(
423         uint amountIn,
424         uint amountOutMin,
425         address[] calldata path,
426         address to,
427         uint deadline
428     ) external;
429 }
430 
431 contract Arty is Context, IERC20, Ownable {
432     using SafeMath for uint256;
433     using Address for address;
434     
435     address payable public NFTFundAddress = payable(0x0b1Ad08375d043c3111023a00237Dad4c7e6bed7); // NFTFundAddress
436     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
437     mapping (address => uint256) private _rOwned;
438     mapping (address => uint256) private _tOwned;
439     mapping (address => mapping (address => uint256)) private _allowances;
440 
441     mapping (address => bool) private _isExcludedFromFee;
442 
443     mapping (address => bool) private _isExcluded;
444     address[] private _excluded;
445 
446     mapping(address => bool) private _IsBot;
447 
448     bool public tradingOpen = false; //once switched on, can never be switched off.
449     
450 
451    
452     uint256 private constant MAX = ~uint256(0);
453     uint256 private _tTotal = 18000 * 10**6 * 10**9;
454     uint256 private _rTotal = (MAX - (MAX % _tTotal));
455     uint256 private _tFeeTotal;
456 
457     string private _name = "Arty";
458     string private _symbol = "ARTY";
459     uint8 private _decimals = 9;
460 
461 
462     uint256 private _taxFee = 0; //taxfee cannot be raised
463     uint256 private _previousTaxFee = _taxFee;
464     
465     uint256 public _NFTFee = 6;
466     uint256 private _previousNFTFee = _NFTFee;
467 
468     uint256 private minimumTokensBeforeSwap = 2 * 10**6 * 10**9; 
469 
470     IUniswapV2Router02 public immutable uniswapV2Router;
471     address public immutable uniswapV2Pair;
472     
473     bool inSwapAndLiquify;
474     bool public swapAndLiquifyEnabled = false;
475 
476 
477     
478     event RewardLiquidityProviders(uint256 tokenAmount);
479     event SwapAndLiquifyEnabledUpdated(bool enabled);
480     event SwapAndLiquify(
481         uint256 tokensSwapped,
482         uint256 ethReceived,
483         uint256 tokensIntoLiqudity
484     );
485     
486     event SwapETHForTokens(
487         uint256 amountIn,
488         address[] path
489     );
490     
491     event SwapTokensForETH(
492         uint256 amountIn,
493         address[] path
494     );
495     
496     modifier lockTheSwap {
497         inSwapAndLiquify = true;
498         _;
499         inSwapAndLiquify = false;
500     }
501     
502     constructor () {
503         _rOwned[_msgSender()] = _rTotal;
504         
505         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
506         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
507             .createPair(address(this), _uniswapV2Router.WETH());
508 
509         uniswapV2Router = _uniswapV2Router;
510 
511         
512         _isExcludedFromFee[owner()] = true;
513         _isExcludedFromFee[address(this)] = true;
514         
515         emit Transfer(address(0), _msgSender(), _tTotal);
516     }
517 
518 
519     function enableTrading() external onlyOwner() {
520         swapAndLiquifyEnabled = true;
521         tradingOpen = true;
522     }
523 
524     function name() public view returns (string memory) {
525         return _name;
526     }
527 
528     function symbol() public view returns (string memory) {
529         return _symbol;
530     }
531 
532     function decimals() public view returns (uint8) {
533         return _decimals;
534     }
535 
536     function totalSupply() public view override returns (uint256) {
537         return _tTotal;
538     }
539 
540     function balanceOf(address account) public view override returns (uint256) {
541         if (_isExcluded[account]) return _tOwned[account];
542         return tokenFromReflection(_rOwned[account]);
543     }
544 
545     function transfer(address recipient, uint256 amount) public override returns (bool) {
546         _transfer(_msgSender(), recipient, amount);
547         return true;
548     }
549 
550     function allowance(address owner, address spender) public view override returns (uint256) {
551         return _allowances[owner][spender];
552     }
553 
554     function approve(address spender, uint256 amount) public override returns (bool) {
555         _approve(_msgSender(), spender, amount);
556         return true;
557     }
558 
559     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
560         _transfer(sender, recipient, amount);
561         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
562         return true;
563     }
564 
565     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
566         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
567         return true;
568     }
569 
570     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
571         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
572         return true;
573     }
574 
575     function isExcludedFromReward(address account) public view returns (bool) {
576         return _isExcluded[account];
577     }
578 
579     function totalFees() public view returns (uint256) {
580         return _tFeeTotal;
581     }
582     
583     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
584         return minimumTokensBeforeSwap;
585     }
586     
587     function deliver(uint256 tAmount) public {
588         address sender = _msgSender();
589         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
590         (uint256 rAmount,,,,,) = _getValues(tAmount);
591         _rOwned[sender] = _rOwned[sender].sub(rAmount);
592         _rTotal = _rTotal.sub(rAmount);
593         _tFeeTotal = _tFeeTotal.add(tAmount);
594     }
595   
596 
597     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
598         require(tAmount <= _tTotal, "Amount must be less than supply");
599         if (!deductTransferFee) {
600             (uint256 rAmount,,,,,) = _getValues(tAmount);
601             return rAmount;
602         } else {
603             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
604             return rTransferAmount;
605         }
606     }
607 
608     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
609         require(rAmount <= _rTotal, "Amount must be less than total reflections");
610         uint256 currentRate =  _getRate();
611         return rAmount.div(currentRate);
612     }
613 
614     function isBlockedBot(address account) public view returns (bool) {
615         return _IsBot[account];
616     }
617 
618  
619     function setBots(address[] memory bots_) public onlyOwner {
620         for (uint256 i = 0; i < bots_.length; i++) {
621             _IsBot[bots_[i]] = true;
622         }
623     }
624 
625     function delBot(address notbot) public onlyOwner {
626         _IsBot[notbot] = false;
627     }
628 
629 
630     function excludeFromReward(address account) public onlyOwner() {
631 
632         require(!_isExcluded[account], "Account is already excluded");
633         if(_rOwned[account] > 0) {
634             _tOwned[account] = tokenFromReflection(_rOwned[account]);
635         }
636         _isExcluded[account] = true;
637         _excluded.push(account);
638     }
639 
640     function includeInReward(address account) external onlyOwner() {
641         require(_isExcluded[account], "Account is already excluded");
642         for (uint256 i = 0; i < _excluded.length; i++) {
643             if (_excluded[i] == account) {
644                 _excluded[i] = _excluded[_excluded.length - 1];
645                  uint256 currentRate = _getRate();
646                 _rOwned[account] = _tOwned[account].mul(currentRate);
647                 _tOwned[account] = 0;
648                 _isExcluded[account] = false;
649                 _excluded.pop();
650                 break;
651             }
652         }
653     }
654 
655     function _approve(address owner, address spender, uint256 amount) private {
656         require(owner != address(0), "ERC20: approve from the zero address");
657         require(spender != address(0), "ERC20: approve to the zero address");
658 
659         _allowances[owner][spender] = amount;
660         emit Approval(owner, spender, amount);
661     }
662 
663 
664     function _transfer(
665         address sender,
666         address recipient,
667         uint256 amount
668     ) private {
669         require(sender != address(0), "ERC20: transfer from the zero address");
670         require(recipient != address(0), "ERC20: transfer to the zero address");
671         require(amount > 0, "Transfer amount must be greater than zero");
672         require(!_IsBot[recipient], "You are blocked as a bot!");
673         require(!_IsBot[msg.sender], "You are blocked as a bot!");
674 
675             if(sender != owner() && recipient != owner()) {
676             
677             if (!tradingOpen) {
678                 if (!(sender == address(this) || recipient == address(this)
679                 || sender == address(owner()) || recipient == address(owner()))) {
680                     require(tradingOpen, "Trading is not enabled");
681                 }
682             }
683             }
684 
685 
686         uint256 contractTokenBalance = balanceOf(address(this));
687         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
688         
689         if (!inSwapAndLiquify && swapAndLiquifyEnabled && recipient == uniswapV2Pair) {
690             if (overMinimumTokenBalance) {
691                 contractTokenBalance = minimumTokensBeforeSwap;
692                 swapTokens(contractTokenBalance);   
693 
694         }
695         }
696 
697         bool takeFee = true;
698         
699         //if any account belongs to _isExcludedFromFee account then remove the fee
700         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
701             takeFee = false;
702          
703         }
704         
705         _tokenTransfer(sender,recipient,amount,takeFee);
706     }
707 
708     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
709        
710         uint256 initialBalance = address(this).balance;
711         swapTokensForEth(contractTokenBalance);
712         uint256 transferredBalance = address(this).balance.sub(initialBalance);
713 
714         //Send to Marketing address
715         transferToAddressETH(NFTFundAddress, transferredBalance);
716         
717     }
718     
719     
720     function swapTokensForEth(uint256 tokenAmount) private {
721         // generate the uniswap pair path of token -> weth
722         address[] memory path = new address[](2);
723         path[0] = address(this);
724         path[1] = uniswapV2Router.WETH();
725 
726         _approve(address(this), address(uniswapV2Router), tokenAmount);
727 
728         // make the swap
729         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
730             tokenAmount,
731             0, // accept any amount of ETH
732             path,
733             address(this), // The contract
734             block.timestamp
735         );
736         
737         emit SwapTokensForETH(tokenAmount, path);
738     }
739     
740     function swapETHForTokens(uint256 amount) private {
741         // generate the uniswap pair path of token -> weth
742         address[] memory path = new address[](2);
743         path[0] = uniswapV2Router.WETH();
744         path[1] = address(this);
745 
746       // make the swap
747         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
748             0, // accept any amount of Tokens
749             path,
750             deadAddress, // Burn address
751             block.timestamp.add(300)
752         );
753         
754         emit SwapETHForTokens(amount, path);
755     }
756     
757     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
758         // approve token transfer to cover all possible scenarios
759         _approve(address(this), address(uniswapV2Router), tokenAmount);
760 
761         // add the liquidity
762         uniswapV2Router.addLiquidityETH{value: ethAmount}(
763             address(this),
764             tokenAmount,
765             0, // slippage is unavoidable
766             0, // slippage is unavoidable
767             owner(),
768             block.timestamp
769         );
770     }
771 
772     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
773         if(!takeFee)
774             removeAllFee();
775         
776         if (_isExcluded[sender] && !_isExcluded[recipient]) {
777             _transferFromExcluded(sender, recipient, amount);
778         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
779             _transferToExcluded(sender, recipient, amount);
780         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
781             _transferBothExcluded(sender, recipient, amount);
782         } else {
783             _transferStandard(sender, recipient, amount);
784         }
785         
786         if(!takeFee)
787             restoreAllFee();
788     }
789 
790     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
791         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
792         _rOwned[sender] = _rOwned[sender].sub(rAmount);
793         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
794         _takeLiquidity(tLiquidity);
795         _reflectFee(rFee, tFee);
796         emit Transfer(sender, recipient, tTransferAmount);
797     }
798 
799     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
800         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
801 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
802         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
803         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
804         _takeLiquidity(tLiquidity);
805         _reflectFee(rFee, tFee);
806         emit Transfer(sender, recipient, tTransferAmount);
807     }
808 
809     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
810         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
811     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
812         _rOwned[sender] = _rOwned[sender].sub(rAmount);
813         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
814         _takeLiquidity(tLiquidity);
815         _reflectFee(rFee, tFee);
816         emit Transfer(sender, recipient, tTransferAmount);
817     }
818 
819     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
820         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
821     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
822         _rOwned[sender] = _rOwned[sender].sub(rAmount);
823         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
824         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
825         _takeLiquidity(tLiquidity);
826         _reflectFee(rFee, tFee);
827         emit Transfer(sender, recipient, tTransferAmount);
828     }
829 
830     function _reflectFee(uint256 rFee, uint256 tFee) private {
831         _rTotal = _rTotal.sub(rFee);
832         _tFeeTotal = _tFeeTotal.add(tFee);
833     }
834 
835     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
836         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
837         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
838         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
839     }
840 
841     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
842         uint256 tFee = calculateTaxFee(tAmount);
843         uint256 tLiquidity = calculateNFTFee(tAmount);
844         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
845         return (tTransferAmount, tFee, tLiquidity);
846     }
847 
848     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
849         uint256 rAmount = tAmount.mul(currentRate);
850         uint256 rFee = tFee.mul(currentRate);
851         uint256 rLiquidity = tLiquidity.mul(currentRate);
852         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
853         return (rAmount, rTransferAmount, rFee);
854     }
855 
856     function _getRate() private view returns(uint256) {
857         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
858         return rSupply.div(tSupply);
859     }
860 
861     function _getCurrentSupply() private view returns(uint256, uint256) {
862         uint256 rSupply = _rTotal;
863         uint256 tSupply = _tTotal;      
864         for (uint256 i = 0; i < _excluded.length; i++) {
865             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
866             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
867             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
868         }
869         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
870         return (rSupply, tSupply);
871     }
872     
873     function _takeLiquidity(uint256 tLiquidity) private {
874         uint256 currentRate =  _getRate();
875         uint256 rLiquidity = tLiquidity.mul(currentRate);
876         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
877         if(_isExcluded[address(this)])
878             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
879     }
880     
881     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
882         return _amount.mul(_taxFee).div(
883             10**2
884         );
885     }
886     
887     function calculateNFTFee(uint256 _amount) private view returns (uint256) {
888         return _amount.mul(_NFTFee).div(
889             10**2
890         );
891     }
892     
893     function removeAllFee() private {
894         if(_taxFee == 0 && _NFTFee == 0) return;
895         
896         _previousTaxFee = _taxFee;
897         _previousNFTFee = _NFTFee;
898         
899         _taxFee = 0;
900         _NFTFee = 0;
901     }
902     
903     function restoreAllFee() private {
904         _taxFee = _previousTaxFee;
905         _NFTFee = _previousNFTFee;
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
920     function setNFTFeePercent(uint256 nftFee) external onlyOwner() {
921         _NFTFee = nftFee; 
922     } 
923 
924     function setNumTokenstoSell(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
925         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
926     }
927 
928     function setNFTFundAddress(address _NFTFundAddress) external onlyOwner() {
929         NFTFundAddress = payable(_NFTFundAddress);
930     }
931 
932     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
933         swapAndLiquifyEnabled = _enabled;
934         emit SwapAndLiquifyEnabledUpdated(_enabled);
935     }
936     
937     function transferToAddressETH(address payable recipient, uint256 amount) private {
938         recipient.transfer(amount);
939     }
940 
941     function sendTokenTo(IERC20 token, address recipient, uint256 amount) external onlyOwner() {
942         token.transfer(recipient, amount);
943 
944     }
945 
946     function getETHBalance() public view returns(uint) {
947         return address(this).balance;
948     }
949 
950     function sendETHTo(address payable _to) external onlyOwner() {
951         _to.transfer(getETHBalance());
952     }
953     
954     receive() external payable {}
955 }