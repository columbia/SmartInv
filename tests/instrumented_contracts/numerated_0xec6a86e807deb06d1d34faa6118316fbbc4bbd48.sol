1 /**
2  *Submitted for verification at BscScan.com on 2021-06-17
3 */
4 
5 /*
6 
7  t.me/shibaoni
8  Shiba Onigri
9  $SHIBAONI
10  
11  
12  ______      # ___   ___     # ________     #  _______      # ________      # ______      # ___   __      # ________     #
13 /_____/\     #/__/\ /__/\    #/_______/\    #/_______/\     #/_______/\     #/_____/\     #/__/\ /__/\    #/_______/\    #
14 \::::_\/_    #\::\ \\  \ \   #\__.::._\/    #\::: _  \ \    #\::: _  \ \    #\:::_ \ \    #\::\_\\  \ \   #\__.::._\/    #
15  \:\/___/\   # \::\/_\ .\ \  #   \::\ \     # \::(_)  \/_   # \::(_)  \ \   # \:\ \ \ \   # \:. `-\  \ \  #   \::\ \     #
16   \_::._\:\  #  \:: ___::\ \ #   _\::\ \__  #  \::  _  \ \  #  \:: __  \ \  #  \:\ \ \ \  #  \:. _    \ \ #   _\::\ \__  #
17     /____\:\ #   \: \ \\::\ \#  /__\::\__/\ #   \::(_)  \ \ #   \:.\ \  \ \ #   \:\_\ \ \ #   \. \`-\  \ \#  /__\::\__/\ #
18     \_____\/ #    \__\/ \::\/#  \________\/ #    \_______\/ #    \__\/\__\/ #    \_____\/ #    \__\/ \__\/#  \________\/ #
19              ##               ##              ##               ##               ##             ##               ##              ##
20 
21  ShibaOni is built upon the fundamentals of Buyback and increasing the investor's value
22  
23  - v2 Contract
24  
25  - No devwallets | No pre-sale | No private sale
26  
27  - From the founders of ShibaRamen (listed on coingecko in under 48 hours)
28 
29  - Main features are
30    1) 2% tax is collected and distributed to holders for HODLing
31    2) 9% buyback* and marketing tax
32    
33    - Buyback?
34    As part of Buy-Back process, contract takes care of buying back some of the tokens and burn them whenever a sell happens. In a nutshell, 98% of the time, you will not see 2 sell transactions at any time and there will never be three sell transactions continuously at any time.
35 
36 */
37 
38 // SPDX-License-Identifier: Unlicensed
39 
40 pragma solidity ^0.8.4;
41 
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address payable) {
44         return payable(msg.sender);
45     }
46 
47     function _msgData() internal view virtual returns (bytes memory) {
48         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
49         return msg.data;
50     }
51 }
52 
53 
54 interface IERC20 {
55 
56     function totalSupply() external view returns (uint256);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64     
65 
66 }
67 
68 library SafeMath {
69 
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73 
74         return c;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         return mod(a, b, "SafeMath: modulo by zero");
114     }
115 
116     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         require(b != 0, errorMessage);
118         return a % b;
119     }
120 }
121 
122 library Address {
123 
124     function isContract(address account) internal view returns (bool) {
125         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
126         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
127         // for accounts without code, i.e. `keccak256('')`
128         bytes32 codehash;
129         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
130         // solhint-disable-next-line no-inline-assembly
131         assembly { codehash := extcodehash(account) }
132         return (codehash != accountHash && codehash != 0x0);
133     }
134 
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
139         (bool success, ) = recipient.call{ value: amount }("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 
143 
144     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
145       return functionCall(target, data, "Address: low-level call failed");
146     }
147 
148     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
149         return _functionCallWithValue(target, data, 0, errorMessage);
150     }
151 
152     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
153         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
154     }
155 
156     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
157         require(address(this).balance >= value, "Address: insufficient balance for call");
158         return _functionCallWithValue(target, data, value, errorMessage);
159     }
160 
161     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
162         require(isContract(target), "Address: call to non-contract");
163 
164         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
165         if (success) {
166             return returndata;
167         } else {
168             
169             if (returndata.length > 0) {
170                 assembly {
171                     let returndata_size := mload(returndata)
172                     revert(add(32, returndata), returndata_size)
173                 }
174             } else {
175                 revert(errorMessage);
176             }
177         }
178     }
179 }
180 
181 contract Ownable is Context {
182     address private _owner;
183     address private _previousOwner;
184     uint256 private _lockTime;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     constructor () {
189         address msgSender = _msgSender();
190         _owner = msgSender;
191         emit OwnershipTransferred(address(0), msgSender);
192     }
193 
194     function owner() public view returns (address) {
195         return _owner;
196     }   
197     
198     modifier onlyOwner() {
199         require(_owner == _msgSender(), "Ownable: caller is not the owner");
200         _;
201     }
202     
203     function renounceOwnership() public virtual onlyOwner {
204         emit OwnershipTransferred(_owner, address(0));
205         _owner = address(0);
206     }
207 
208     function transferOwnership(address newOwner) public virtual onlyOwner {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         emit OwnershipTransferred(_owner, newOwner);
211         _owner = newOwner;
212     }
213 
214     function getUnlockTime() public view returns (uint256) {
215         return _lockTime;
216     }
217     
218     function getTime() public view returns (uint256) {
219         return block.timestamp;
220     }
221 
222     function lock(uint256 time) public virtual onlyOwner {
223         _previousOwner = _owner;
224         _owner = address(0);
225         _lockTime = block.timestamp + time;
226         emit OwnershipTransferred(_owner, address(0));
227     }
228     
229     function unlock() public virtual {
230         require(_previousOwner == msg.sender, "You don't have permission to unlock");
231         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
232         emit OwnershipTransferred(_owner, _previousOwner);
233         _owner = _previousOwner;
234     }
235 }
236 
237 // pragma solidity >=0.5.0;
238 
239 interface IUniswapV2Factory {
240     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
241 
242     function feeTo() external view returns (address);
243     function feeToSetter() external view returns (address);
244 
245     function getPair(address tokenA, address tokenB) external view returns (address pair);
246     function allPairs(uint) external view returns (address pair);
247     function allPairsLength() external view returns (uint);
248 
249     function createPair(address tokenA, address tokenB) external returns (address pair);
250 
251     function setFeeTo(address) external;
252     function setFeeToSetter(address) external;
253 }
254 
255 
256 // pragma solidity >=0.5.0;
257 
258 interface IUniswapV2Pair {
259     event Approval(address indexed owner, address indexed spender, uint value);
260     event Transfer(address indexed from, address indexed to, uint value);
261 
262     function name() external pure returns (string memory);
263     function symbol() external pure returns (string memory);
264     function decimals() external pure returns (uint8);
265     function totalSupply() external view returns (uint);
266     function balanceOf(address owner) external view returns (uint);
267     function allowance(address owner, address spender) external view returns (uint);
268 
269     function approve(address spender, uint value) external returns (bool);
270     function transfer(address to, uint value) external returns (bool);
271     function transferFrom(address from, address to, uint value) external returns (bool);
272 
273     function DOMAIN_SEPARATOR() external view returns (bytes32);
274     function PERMIT_TYPEHASH() external pure returns (bytes32);
275     function nonces(address owner) external view returns (uint);
276 
277     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
278     
279     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
280     event Swap(
281         address indexed sender,
282         uint amount0In,
283         uint amount1In,
284         uint amount0Out,
285         uint amount1Out,
286         address indexed to
287     );
288     event Sync(uint112 reserve0, uint112 reserve1);
289 
290     function MINIMUM_LIQUIDITY() external pure returns (uint);
291     function factory() external view returns (address);
292     function token0() external view returns (address);
293     function token1() external view returns (address);
294     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
295     function price0CumulativeLast() external view returns (uint);
296     function price1CumulativeLast() external view returns (uint);
297     function kLast() external view returns (uint);
298 
299     function burn(address to) external returns (uint amount0, uint amount1);
300     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
301     function skim(address to) external;
302     function sync() external;
303 
304     function initialize(address, address) external;
305 }
306 
307 // pragma solidity >=0.6.2;
308 
309 interface IUniswapV2Router01 {
310     function factory() external pure returns (address);
311     function WETH() external pure returns (address);
312 
313     function addLiquidity(
314         address tokenA,
315         address tokenB,
316         uint amountADesired,
317         uint amountBDesired,
318         uint amountAMin,
319         uint amountBMin,
320         address to,
321         uint deadline
322     ) external returns (uint amountA, uint amountB, uint liquidity);
323     function addLiquidityETH(
324         address token,
325         uint amountTokenDesired,
326         uint amountTokenMin,
327         uint amountETHMin,
328         address to,
329         uint deadline
330     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
331     function removeLiquidity(
332         address tokenA,
333         address tokenB,
334         uint liquidity,
335         uint amountAMin,
336         uint amountBMin,
337         address to,
338         uint deadline
339     ) external returns (uint amountA, uint amountB);
340     function removeLiquidityETH(
341         address token,
342         uint liquidity,
343         uint amountTokenMin,
344         uint amountETHMin,
345         address to,
346         uint deadline
347     ) external returns (uint amountToken, uint amountETH);
348     function removeLiquidityWithPermit(
349         address tokenA,
350         address tokenB,
351         uint liquidity,
352         uint amountAMin,
353         uint amountBMin,
354         address to,
355         uint deadline,
356         bool approveMax, uint8 v, bytes32 r, bytes32 s
357     ) external returns (uint amountA, uint amountB);
358     function removeLiquidityETHWithPermit(
359         address token,
360         uint liquidity,
361         uint amountTokenMin,
362         uint amountETHMin,
363         address to,
364         uint deadline,
365         bool approveMax, uint8 v, bytes32 r, bytes32 s
366     ) external returns (uint amountToken, uint amountETH);
367     function swapExactTokensForTokens(
368         uint amountIn,
369         uint amountOutMin,
370         address[] calldata path,
371         address to,
372         uint deadline
373     ) external returns (uint[] memory amounts);
374     function swapTokensForExactTokens(
375         uint amountOut,
376         uint amountInMax,
377         address[] calldata path,
378         address to,
379         uint deadline
380     ) external returns (uint[] memory amounts);
381     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
382         external
383         payable
384         returns (uint[] memory amounts);
385     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
386         external
387         returns (uint[] memory amounts);
388     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
389         external
390         returns (uint[] memory amounts);
391     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
392         external
393         payable
394         returns (uint[] memory amounts);
395 
396     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
397     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
398     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
399     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
400     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
401 }
402 
403 
404 
405 // pragma solidity >=0.6.2;
406 
407 interface IUniswapV2Router02 is IUniswapV2Router01 {
408     function removeLiquidityETHSupportingFeeOnTransferTokens(
409         address token,
410         uint liquidity,
411         uint amountTokenMin,
412         uint amountETHMin,
413         address to,
414         uint deadline
415     ) external returns (uint amountETH);
416     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
417         address token,
418         uint liquidity,
419         uint amountTokenMin,
420         uint amountETHMin,
421         address to,
422         uint deadline,
423         bool approveMax, uint8 v, bytes32 r, bytes32 s
424     ) external returns (uint amountETH);
425 
426     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
427         uint amountIn,
428         uint amountOutMin,
429         address[] calldata path,
430         address to,
431         uint deadline
432     ) external;
433     function swapExactETHForTokensSupportingFeeOnTransferTokens(
434         uint amountOutMin,
435         address[] calldata path,
436         address to,
437         uint deadline
438     ) external payable;
439     function swapExactTokensForETHSupportingFeeOnTransferTokens(
440         uint amountIn,
441         uint amountOutMin,
442         address[] calldata path,
443         address to,
444         uint deadline
445     ) external;
446 }
447 
448 contract ShibaOni is Context, IERC20, Ownable {
449     using SafeMath for uint256;
450     using Address for address;
451     
452     address payable public marketingAddress = payable(0xa8FB832AfdB227B33359Fd625f09Ef5681e2608F);
453     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
454     mapping (address => uint256) private _rOwned;
455     mapping (address => uint256) private _tOwned;
456     mapping (address => mapping (address => uint256)) private _allowances;
457 
458     mapping (address => bool) private _isExcludedFromFee;
459 
460     mapping (address => bool) private _isExcluded;
461     address[] private _excluded;
462    
463     uint256 private constant MAX = ~uint256(0);
464     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
465     uint256 private _rTotal = (MAX - (MAX % _tTotal));
466     uint256 private _tFeeTotal;
467 
468     string private _name = "Shiba Onigiri";
469     string private _symbol = unicode'SHIBAONI🍙';
470     uint8 private _decimals = 9;
471 
472 
473     uint256 public _taxFee = 2;
474     uint256 private _previousTaxFee = _taxFee;
475     
476     uint256 public _liquidityFee = 9;
477     uint256 private _previousLiquidityFee = _liquidityFee;
478     
479     uint256 public standardDivisor = 8;
480     
481     uint256 public _maxTxAmount = 1000000000 * 10**6 * 10**9;
482     uint256 private minimumTokensBeforeSwap = 200000 * 10**6 * 10**9; 
483     uint256 private buyBackUpperLimit = 1 * 10**18;
484 
485     IUniswapV2Router02 public immutable uniswapV2Router;
486     address public immutable uniswapV2Pair;
487     
488     bool inSwapAndLiquify;
489     bool public swapAndLiquifyEnabled = true;
490     bool public buyBackEnabled = true;
491 
492     
493     event RewardLiquidityProviders(uint256 tokenAmount);
494     event BuyBackEnabledUpdated(bool enabled);
495     event SwapAndLiquifyEnabledUpdated(bool enabled);
496     event SwapAndLiquify(
497         uint256 tokensSwapped,
498         uint256 ethReceived,
499         uint256 tokensIntoLiqudity
500     );
501     
502     event SwapETHForTokens(
503         uint256 amountIn,
504         address[] path
505     );
506     
507     event SwapTokensForETH(
508         uint256 amountIn,
509         address[] path
510     );
511     
512     modifier lockTheSwap {
513         inSwapAndLiquify = true;
514         _;
515         inSwapAndLiquify = false;
516     }
517     
518     constructor () {
519         _rOwned[_msgSender()] = _rTotal;
520         
521         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
522         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
523             .createPair(address(this), _uniswapV2Router.WETH());
524 
525         uniswapV2Router = _uniswapV2Router;
526 
527         
528         _isExcludedFromFee[owner()] = true;
529         _isExcludedFromFee[address(this)] = true;
530         
531         emit Transfer(address(0), _msgSender(), _tTotal);
532     }
533 
534     function name() public view returns (string memory) {
535         return _name;
536     }
537 
538     function symbol() public view returns (string memory) {
539         return _symbol;
540     }
541 
542     function decimals() public view returns (uint8) {
543         return _decimals;
544     }
545 
546     function totalSupply() public view override returns (uint256) {
547         return _tTotal;
548     }
549 
550     function balanceOf(address account) public view override returns (uint256) {
551         if (_isExcluded[account]) return _tOwned[account];
552         return tokenFromReflection(_rOwned[account]);
553     }
554 
555     function transfer(address recipient, uint256 amount) public override returns (bool) {
556         _transfer(_msgSender(), recipient, amount);
557         return true;
558     }
559 
560     function allowance(address owner, address spender) public view override returns (uint256) {
561         return _allowances[owner][spender];
562     }
563 
564     function approve(address spender, uint256 amount) public override returns (bool) {
565         _approve(_msgSender(), spender, amount);
566         return true;
567     }
568 
569     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
570         _transfer(sender, recipient, amount);
571         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
572         return true;
573     }
574 
575     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
577         return true;
578     }
579 
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     function isExcludedFromReward(address account) public view returns (bool) {
586         return _isExcluded[account];
587     }
588 
589     function totalFees() public view returns (uint256) {
590         return _tFeeTotal;
591     }
592     
593     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
594         return minimumTokensBeforeSwap;
595     }
596     
597     function buyBackUpperLimitAmount() public view returns (uint256) {
598         return buyBackUpperLimit;
599     }
600     
601     function deliver(uint256 tAmount) public {
602         address sender = _msgSender();
603         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
604         (uint256 rAmount,,,,,) = _getValues(tAmount);
605         _rOwned[sender] = _rOwned[sender].sub(rAmount);
606         _rTotal = _rTotal.sub(rAmount);
607         _tFeeTotal = _tFeeTotal.add(tAmount);
608     }
609   
610 
611     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
612         require(tAmount <= _tTotal, "Amount must be less than supply");
613         if (!deductTransferFee) {
614             (uint256 rAmount,,,,,) = _getValues(tAmount);
615             return rAmount;
616         } else {
617             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
618             return rTransferAmount;
619         }
620     }
621 
622     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
623         require(rAmount <= _rTotal, "Amount must be less than total reflections");
624         uint256 currentRate =  _getRate();
625         return rAmount.div(currentRate);
626     }
627 
628     function excludeFromReward(address account) public onlyOwner() {
629 
630         require(!_isExcluded[account], "Account is already excluded");
631         if(_rOwned[account] > 0) {
632             _tOwned[account] = tokenFromReflection(_rOwned[account]);
633         }
634         _isExcluded[account] = true;
635         _excluded.push(account);
636     }
637 
638     function includeInReward(address account) external onlyOwner() {
639         require(_isExcluded[account], "Account is already excluded");
640         for (uint256 i = 0; i < _excluded.length; i++) {
641             if (_excluded[i] == account) {
642                 _excluded[i] = _excluded[_excluded.length - 1];
643                 _tOwned[account] = 0;
644                 _isExcluded[account] = false;
645                 _excluded.pop();
646                 break;
647             }
648         }
649     }
650 
651     function _approve(address owner, address spender, uint256 amount) private {
652         require(owner != address(0), "ERC20: approve from the zero address");
653         require(spender != address(0), "ERC20: approve to the zero address");
654 
655         _allowances[owner][spender] = amount;
656         emit Approval(owner, spender, amount);
657     }
658 
659     function _transfer(
660         address from,
661         address to,
662         uint256 amount
663     ) private {
664         require(from != address(0), "ERC20: transfer from the zero address");
665         require(to != address(0), "ERC20: transfer to the zero address");
666         require(amount > 0, "Transfer amount must be greater than zero");
667         if(from != owner() && to != owner()) {
668             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
669         }
670 
671         uint256 contractTokenBalance = balanceOf(address(this));
672         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
673         
674         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
675             if (overMinimumTokenBalance) {
676                 contractTokenBalance = minimumTokensBeforeSwap;
677                 swapTokens(contractTokenBalance);    
678             }
679 	        uint256 balance = address(this).balance;
680             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
681                 
682                 if (balance > buyBackUpperLimit)
683                     balance = buyBackUpperLimit;
684                 
685                 buyBackTokens(balance.div(100));
686             }
687         }
688         
689         bool takeFee = true;
690         
691         //if any account belongs to _isExcludedFromFee account then remove the fee
692         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
693             takeFee = false;
694         }
695         
696         _tokenTransfer(from,to,amount,takeFee);
697     }
698 
699     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
700        
701         uint256 initialBalance = address(this).balance;
702         swapTokensForEth(contractTokenBalance);
703         uint256 transferredBalance = address(this).balance.sub(initialBalance);
704 
705         //Send to Marketing address
706         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(standardDivisor));
707         
708     }
709     
710 
711     function buyBackTokens(uint256 amount) private lockTheSwap {
712     	if (amount > 0) {
713     	    swapETHForTokens(amount);
714 	    }
715     }
716     
717     function swapTokensForEth(uint256 tokenAmount) private {
718         // generate the uniswap pair path of token -> weth
719         address[] memory path = new address[](2);
720         path[0] = address(this);
721         path[1] = uniswapV2Router.WETH();
722 
723         _approve(address(this), address(uniswapV2Router), tokenAmount);
724 
725         // make the swap
726         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
727             tokenAmount,
728             0, // accept any amount of ETH
729             path,
730             address(this), // The contract
731             block.timestamp
732         );
733         
734         emit SwapTokensForETH(tokenAmount, path);
735     }
736     
737     function swapETHForTokens(uint256 amount) private {
738         // generate the uniswap pair path of token -> weth
739         address[] memory path = new address[](2);
740         path[0] = uniswapV2Router.WETH();
741         path[1] = address(this);
742 
743       // make the swap
744         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
745             0, // accept any amount of Tokens
746             path,
747             deadAddress, // Burn address
748             block.timestamp.add(300)
749         );
750         
751         emit SwapETHForTokens(amount, path);
752     }
753     
754     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
755         // approve token transfer to cover all possible scenarios
756         _approve(address(this), address(uniswapV2Router), tokenAmount);
757 
758         // add the liquidity
759         uniswapV2Router.addLiquidityETH{value: ethAmount}(
760             address(this),
761             tokenAmount,
762             0, // slippage is unavoidable
763             0, // slippage is unavoidable
764             owner(),
765             block.timestamp
766         );
767     }
768 
769     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
770         if(!takeFee)
771             removeAllFee();
772         
773         if (_isExcluded[sender] && !_isExcluded[recipient]) {
774             _transferFromExcluded(sender, recipient, amount);
775         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
776             _transferToExcluded(sender, recipient, amount);
777         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
778             _transferBothExcluded(sender, recipient, amount);
779         } else {
780             _transferStandard(sender, recipient, amount);
781         }
782         
783         if(!takeFee)
784             restoreAllFee();
785     }
786 
787     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
788         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
789         _rOwned[sender] = _rOwned[sender].sub(rAmount);
790         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
791         _takeLiquidity(tLiquidity);
792         _reflectFee(rFee, tFee);
793         emit Transfer(sender, recipient, tTransferAmount);
794     }
795 
796     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
797         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
798 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
799         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
800         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
801         _takeLiquidity(tLiquidity);
802         _reflectFee(rFee, tFee);
803         emit Transfer(sender, recipient, tTransferAmount);
804     }
805 
806     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
807         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
808     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
809         _rOwned[sender] = _rOwned[sender].sub(rAmount);
810         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
811         _takeLiquidity(tLiquidity);
812         _reflectFee(rFee, tFee);
813         emit Transfer(sender, recipient, tTransferAmount);
814     }
815 
816     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
817         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
818     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
819         _rOwned[sender] = _rOwned[sender].sub(rAmount);
820         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
821         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
822         _takeLiquidity(tLiquidity);
823         _reflectFee(rFee, tFee);
824         emit Transfer(sender, recipient, tTransferAmount);
825     }
826 
827     function _reflectFee(uint256 rFee, uint256 tFee) private {
828         _rTotal = _rTotal.sub(rFee);
829         _tFeeTotal = _tFeeTotal.add(tFee);
830     }
831 
832     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
833         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
834         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
835         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
836     }
837 
838     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
839         uint256 tFee = calculateTaxFee(tAmount);
840         uint256 tLiquidity = calculateLiquidityFee(tAmount);
841         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
842         return (tTransferAmount, tFee, tLiquidity);
843     }
844 
845     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
846         uint256 rAmount = tAmount.mul(currentRate);
847         uint256 rFee = tFee.mul(currentRate);
848         uint256 rLiquidity = tLiquidity.mul(currentRate);
849         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
850         return (rAmount, rTransferAmount, rFee);
851     }
852 
853     function _getRate() private view returns(uint256) {
854         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
855         return rSupply.div(tSupply);
856     }
857 
858     function _getCurrentSupply() private view returns(uint256, uint256) {
859         uint256 rSupply = _rTotal;
860         uint256 tSupply = _tTotal;      
861         for (uint256 i = 0; i < _excluded.length; i++) {
862             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
863             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
864             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
865         }
866         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
867         return (rSupply, tSupply);
868     }
869     
870     function _takeLiquidity(uint256 tLiquidity) private {
871         uint256 currentRate =  _getRate();
872         uint256 rLiquidity = tLiquidity.mul(currentRate);
873         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
874         if(_isExcluded[address(this)])
875             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
876     }
877     
878     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
879         return _amount.mul(_taxFee).div(
880             10**2
881         );
882     }
883     
884     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
885         return _amount.mul(_liquidityFee).div(
886             10**2
887         );
888     }
889     
890     function removeAllFee() private {
891         if(_taxFee == 0 && _liquidityFee == 0) return;
892         
893         _previousTaxFee = _taxFee;
894         _previousLiquidityFee = _liquidityFee;
895         
896         _taxFee = 0;
897         _liquidityFee = 0;
898     }
899     
900     function restoreAllFee() private {
901         _taxFee = _previousTaxFee;
902         _liquidityFee = _previousLiquidityFee;
903     }
904 
905     function isExcludedFromFee(address account) public view returns(bool) {
906         return _isExcludedFromFee[account];
907     }
908     
909     function excludeFromFee(address account) public onlyOwner {
910         _isExcludedFromFee[account] = true;
911     }
912     
913     function includeInFee(address account) public onlyOwner {
914         _isExcludedFromFee[account] = false;
915     }
916     
917     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
918         _taxFee = taxFee;
919     }
920     
921     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
922         _liquidityFee = liquidityFee;
923     }
924     
925     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
926         _maxTxAmount = maxTxAmount;
927     }
928     
929     function setStandardDivisor(uint256 divisor) external onlyOwner() {
930         standardDivisor = divisor;
931     }
932 
933     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
934         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
935     }
936     
937      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
938         buyBackUpperLimit = buyBackLimit * 10**18;
939     }
940 
941     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
942         marketingAddress = payable(_marketingAddress);
943     }
944 
945     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
946         swapAndLiquifyEnabled = _enabled;
947         emit SwapAndLiquifyEnabledUpdated(_enabled);
948     }
949     
950     function setBuyBackEnabled(bool _enabled) public onlyOwner {
951         buyBackEnabled = _enabled;
952         emit BuyBackEnabledUpdated(_enabled);
953     }
954     
955     function enableTrading() external onlyOwner {
956         setSwapAndLiquifyEnabled(true);
957         _taxFee = 2;
958         _liquidityFee = 9;
959         _maxTxAmount = 10000000 * 10**6 * 10**9;
960     }
961     
962     function transferToAddressETH(address payable recipient, uint256 amount) private {
963         recipient.transfer(amount);
964     }
965     
966      //to recieve ETH from uniswapV2Router when swaping
967     receive() external payable {}
968 }