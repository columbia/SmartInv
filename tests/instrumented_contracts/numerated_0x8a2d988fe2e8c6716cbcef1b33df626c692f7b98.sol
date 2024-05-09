1 /*
2 
3 EverRise is built upon the fundamentals of Buyback and increasing the investor's value
4     
5 Main features are
6     
7 1) 1% tax is collected and distributed to holders for HODLing
8 2) 5% buyback and marketing tax is collected and 2% of it is sent for marketing fund and othe 3% is used to buyback the tokens
9     
10     
11  ________                              _______   __                     
12 /        |                            /       \ /  |                    
13 $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______  
14 $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \ 
15 $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
16 $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
17 $$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/ 
18 $$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
19 $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/ 
20                                                                         
21 
22 */
23 
24 // SPDX-License-Identifier: Unlicensed
25 
26 pragma solidity ^0.8.4;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address payable) {
30         return payable(msg.sender);
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 
40 interface IERC20 {
41 
42     function totalSupply() external view returns (uint256);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50     
51 
52 }
53 
54 library SafeMath {
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94 
95         return c;
96     }
97 
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         return mod(a, b, "SafeMath: modulo by zero");
100     }
101 
102     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b != 0, errorMessage);
104         return a % b;
105     }
106 }
107 
108 library Address {
109 
110     function isContract(address account) internal view returns (bool) {
111         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
112         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
113         // for accounts without code, i.e. `keccak256('')`
114         bytes32 codehash;
115         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
116         // solhint-disable-next-line no-inline-assembly
117         assembly { codehash := extcodehash(account) }
118         return (codehash != accountHash && codehash != 0x0);
119     }
120 
121     function sendValue(address payable recipient, uint256 amount) internal {
122         require(address(this).balance >= amount, "Address: insufficient balance");
123 
124         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
125         (bool success, ) = recipient.call{ value: amount }("");
126         require(success, "Address: unable to send value, recipient may have reverted");
127     }
128 
129 
130     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
131       return functionCall(target, data, "Address: low-level call failed");
132     }
133 
134     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
135         return _functionCallWithValue(target, data, 0, errorMessage);
136     }
137 
138     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
139         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
140     }
141 
142     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
143         require(address(this).balance >= value, "Address: insufficient balance for call");
144         return _functionCallWithValue(target, data, value, errorMessage);
145     }
146 
147     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
148         require(isContract(target), "Address: call to non-contract");
149 
150         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
151         if (success) {
152             return returndata;
153         } else {
154             
155             if (returndata.length > 0) {
156                 assembly {
157                     let returndata_size := mload(returndata)
158                     revert(add(32, returndata), returndata_size)
159                 }
160             } else {
161                 revert(errorMessage);
162             }
163         }
164     }
165 }
166 
167 contract Ownable is Context {
168     address private _owner;
169     address private _previousOwner;
170     address private _buybackOwner;
171     uint256 private _lockTime;
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     constructor () {
176         address msgSender = _msgSender();
177         _owner = msgSender;
178         _buybackOwner = msgSender;
179         emit OwnershipTransferred(address(0), msgSender);
180     }
181 
182     function owner() public view returns (address) {
183         return _owner;
184     }   
185 
186     function buybackOwner() public view returns (address) {
187         return _buybackOwner;
188     } 
189     
190     modifier onlyOwner() {
191         require(_owner == _msgSender(), "Ownable: caller is not the owner");
192         _;
193     }
194     
195     modifier onlyBuybackOwner() {
196         require(_buybackOwner == _msgSender(), "Ownable: caller is not the buyback owner");
197         _;
198     }
199 
200     function renounceOwnership() public virtual onlyOwner {
201         emit OwnershipTransferred(_owner, address(0));
202         _owner = address(0);
203     }
204 
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         emit OwnershipTransferred(_owner, newOwner);
208         _owner = newOwner;
209     }
210 
211     function transferBuybackOwnership(address newOwner) public virtual onlyOwner {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         emit OwnershipTransferred(_buybackOwner, newOwner);
214         _buybackOwner = newOwner;
215     }
216 
217     function getUnlockTime() public view returns (uint256) {
218         return _lockTime;
219     }
220     
221     function getTime() public view returns (uint256) {
222         return block.timestamp;
223     }
224 
225     function lock(uint256 time) public virtual onlyOwner {
226         _previousOwner = _owner;
227         _owner = address(0);
228         _lockTime = block.timestamp + time;
229         emit OwnershipTransferred(_owner, address(0));
230     }
231     
232     function unlock() public virtual {
233         require(_previousOwner == msg.sender, "You don't have permission to unlock");
234         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
235         emit OwnershipTransferred(_owner, _previousOwner);
236         _owner = _previousOwner;
237     }
238 }
239 
240 interface IUniswapV2Factory {
241     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
242 
243     function feeTo() external view returns (address);
244     function feeToSetter() external view returns (address);
245 
246     function getPair(address tokenA, address tokenB) external view returns (address pair);
247     function allPairs(uint) external view returns (address pair);
248     function allPairsLength() external view returns (uint);
249 
250     function createPair(address tokenA, address tokenB) external returns (address pair);
251 
252     function setFeeTo(address) external;
253     function setFeeToSetter(address) external;
254 }
255 
256 
257 // pragma solidity >=0.5.0;
258 
259 interface IUniswapV2Pair {
260     event Approval(address indexed owner, address indexed spender, uint value);
261     event Transfer(address indexed from, address indexed to, uint value);
262 
263     function name() external pure returns (string memory);
264     function symbol() external pure returns (string memory);
265     function decimals() external pure returns (uint8);
266     function totalSupply() external view returns (uint);
267     function balanceOf(address owner) external view returns (uint);
268     function allowance(address owner, address spender) external view returns (uint);
269 
270     function approve(address spender, uint value) external returns (bool);
271     function transfer(address to, uint value) external returns (bool);
272     function transferFrom(address from, address to, uint value) external returns (bool);
273 
274     function DOMAIN_SEPARATOR() external view returns (bytes32);
275     function PERMIT_TYPEHASH() external pure returns (bytes32);
276     function nonces(address owner) external view returns (uint);
277 
278     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
279     
280     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
281     event Swap(
282         address indexed sender,
283         uint amount0In,
284         uint amount1In,
285         uint amount0Out,
286         uint amount1Out,
287         address indexed to
288     );
289     event Sync(uint112 reserve0, uint112 reserve1);
290 
291     function MINIMUM_LIQUIDITY() external pure returns (uint);
292     function factory() external view returns (address);
293     function token0() external view returns (address);
294     function token1() external view returns (address);
295     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
296     function price0CumulativeLast() external view returns (uint);
297     function price1CumulativeLast() external view returns (uint);
298     function kLast() external view returns (uint);
299 
300     function burn(address to) external returns (uint amount0, uint amount1);
301     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
302     function skim(address to) external;
303     function sync() external;
304 
305     function initialize(address, address) external;
306 }
307 
308 // pragma solidity >=0.6.2;
309 
310 interface IUniswapV2Router01 {
311     function factory() external pure returns (address);
312     function WETH() external pure returns (address);
313 
314     function addLiquidity(
315         address tokenA,
316         address tokenB,
317         uint amountADesired,
318         uint amountBDesired,
319         uint amountAMin,
320         uint amountBMin,
321         address to,
322         uint deadline
323     ) external returns (uint amountA, uint amountB, uint liquidity);
324     function addLiquidityETH(
325         address token,
326         uint amountTokenDesired,
327         uint amountTokenMin,
328         uint amountETHMin,
329         address to,
330         uint deadline
331     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
332     function removeLiquidity(
333         address tokenA,
334         address tokenB,
335         uint liquidity,
336         uint amountAMin,
337         uint amountBMin,
338         address to,
339         uint deadline
340     ) external returns (uint amountA, uint amountB);
341     function removeLiquidityETH(
342         address token,
343         uint liquidity,
344         uint amountTokenMin,
345         uint amountETHMin,
346         address to,
347         uint deadline
348     ) external returns (uint amountToken, uint amountETH);
349     function removeLiquidityWithPermit(
350         address tokenA,
351         address tokenB,
352         uint liquidity,
353         uint amountAMin,
354         uint amountBMin,
355         address to,
356         uint deadline,
357         bool approveMax, uint8 v, bytes32 r, bytes32 s
358     ) external returns (uint amountA, uint amountB);
359     function removeLiquidityETHWithPermit(
360         address token,
361         uint liquidity,
362         uint amountTokenMin,
363         uint amountETHMin,
364         address to,
365         uint deadline,
366         bool approveMax, uint8 v, bytes32 r, bytes32 s
367     ) external returns (uint amountToken, uint amountETH);
368     function swapExactTokensForTokens(
369         uint amountIn,
370         uint amountOutMin,
371         address[] calldata path,
372         address to,
373         uint deadline
374     ) external returns (uint[] memory amounts);
375     function swapTokensForExactTokens(
376         uint amountOut,
377         uint amountInMax,
378         address[] calldata path,
379         address to,
380         uint deadline
381     ) external returns (uint[] memory amounts);
382     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
383         external
384         payable
385         returns (uint[] memory amounts);
386     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
387         external
388         returns (uint[] memory amounts);
389     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
390         external
391         returns (uint[] memory amounts);
392     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
393         external
394         payable
395         returns (uint[] memory amounts);
396 
397     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
398     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
399     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
400     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
401     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
402 }
403 
404 
405 
406 // pragma solidity >=0.6.2;
407 
408 interface IUniswapV2Router02 is IUniswapV2Router01 {
409     function removeLiquidityETHSupportingFeeOnTransferTokens(
410         address token,
411         uint liquidity,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountETH);
417     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
418         address token,
419         uint liquidity,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline,
424         bool approveMax, uint8 v, bytes32 r, bytes32 s
425     ) external returns (uint amountETH);
426 
427     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
428         uint amountIn,
429         uint amountOutMin,
430         address[] calldata path,
431         address to,
432         uint deadline
433     ) external;
434     function swapExactETHForTokensSupportingFeeOnTransferTokens(
435         uint amountOutMin,
436         address[] calldata path,
437         address to,
438         uint deadline
439     ) external payable;
440     function swapExactTokensForETHSupportingFeeOnTransferTokens(
441         uint amountIn,
442         uint amountOutMin,
443         address[] calldata path,
444         address to,
445         uint deadline
446     ) external;
447 }
448 
449 
450 contract EverRise is Context, IERC20, Ownable {
451     using SafeMath for uint256;
452     using Address for address;
453     
454     address payable public marketingAddress = payable(0x23F4d6e1072E42e5d25789e3260D19422C2d3674); // Marketing Address
455     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
456     mapping (address => uint256) private _rOwned;
457     mapping (address => uint256) private _tOwned;
458     mapping (address => mapping (address => uint256)) private _allowances;
459 
460     mapping (address => bool) private _isExcludedFromFee;
461 
462     mapping (address => bool) private _isExcluded;
463     address[] private _excluded;
464    
465     uint256 private constant MAX = ~uint256(0);
466     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
467     uint256 private _rTotal = (MAX - (MAX % _tTotal));
468     uint256 private _tFeeTotal;
469 
470     string private _name = "EverRise";
471     string private _symbol = "RISE";
472     uint8 private _decimals = 9;
473 
474 
475     uint256 public _taxFee = 1;
476     uint256 private _previousTaxFee = _taxFee;
477     
478     uint256 public _liquidityFee = 5;
479     uint256 private _previousLiquidityFee = _liquidityFee;
480     
481     uint256 public marketingDivisor = 2;
482     
483     uint256 public _maxTxAmount = 3000000 * 10**6 * 10**9;
484     uint256 private minimumTokensBeforeSwap = 50000 * 10**6 * 10**9; 
485     uint256 private buyBackUpperLimit = 1 * 10**17; //0.1 ETH
486     uint256 private buyBackTriggerTokenLimit = 1000 * 10**6 * 10**9;
487     uint256 private buyBackMinAvailability = 1 * 10**17; //0.1 ETH
488 
489     bool inSwapAndLiquify;
490     bool public swapAndLiquifyEnabled = false;
491     bool public buyBackEnabled = true;
492 
493     IUniswapV2Router02 public uniswapV2Router;
494     address public uniswapV2Pair;
495 
496     
497     event RewardLiquidityProviders(uint256 tokenAmount);
498     event BuyBackEnabledUpdated(bool enabled);
499     event SwapAndLiquifyEnabledUpdated(bool enabled);
500     event SwapAndLiquify(
501         uint256 tokensSwapped,
502         uint256 ethReceived,
503         uint256 tokensIntoLiqudity
504     );
505     
506     event SwapETHForTokens(
507         uint256 amountIn,
508         address[] path
509     );
510     
511     event SwapTokensForETH(
512         uint256 amountIn,
513         address[] path
514     );
515 
516     event SwapTokensForTokens(
517         uint256 amountIn,
518         address[] path
519     );
520     
521     modifier lockTheSwap {
522         inSwapAndLiquify = true;
523         _;
524         inSwapAndLiquify = false;
525     }
526     
527     constructor () {
528         _rOwned[_msgSender()] = _rTotal;
529         
530         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 router mainnet 
531         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
532             .createPair(address(this), _uniswapV2Router.WETH());
533 
534         uniswapV2Router = _uniswapV2Router;
535 
536         
537         _isExcludedFromFee[owner()] = true;
538         _isExcludedFromFee[address(this)] = true;
539         excludeFromReward(uniswapV2Pair);
540         
541         emit Transfer(address(0), _msgSender(), _tTotal);
542     }
543 
544     function name() public view returns (string memory) {
545         return _name;
546     }
547 
548     function symbol() public view returns (string memory) {
549         return _symbol;
550     }
551 
552     function decimals() public view returns (uint8) {
553         return _decimals;
554     }
555 
556     function totalSupply() public view override returns (uint256) {
557         return _tTotal;
558     }
559 
560     function balanceOf(address account) public view override returns (uint256) {
561         if (_isExcluded[account]) return _tOwned[account];
562         return tokenFromReflection(_rOwned[account]);
563     }
564 
565     function transfer(address recipient, uint256 amount) public override returns (bool) {
566         _transfer(_msgSender(), recipient, amount);
567         return true;
568     }
569 
570     function allowance(address owner, address spender) public view override returns (uint256) {
571         return _allowances[owner][spender];
572     }
573 
574     function approve(address spender, uint256 amount) public override returns (bool) {
575         _approve(_msgSender(), spender, amount);
576         return true;
577     }
578 
579     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
580         _transfer(sender, recipient, amount);
581         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
582         return true;
583     }
584 
585     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
587         return true;
588     }
589 
590     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
592         return true;
593     }
594 
595     function isExcludedFromReward(address account) public view returns (bool) {
596         return _isExcluded[account];
597     }
598 
599     function totalFees() public view returns (uint256) {
600         return _tFeeTotal;
601     }
602     
603     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
604         return minimumTokensBeforeSwap;
605     }
606     
607     function buyBackUpperLimitAmount() public view returns (uint256) {
608         return buyBackUpperLimit;
609     }
610     
611     function deliver(uint256 tAmount) public {
612         address sender = _msgSender();
613         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
614         (uint256 rAmount,,,,,) = _getValues(tAmount);
615         _rOwned[sender] = _rOwned[sender].sub(rAmount);
616         _rTotal = _rTotal.sub(rAmount);
617         _tFeeTotal = _tFeeTotal.add(tAmount);
618     }
619   
620 
621     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
622         require(tAmount <= _tTotal, "Amount must be less than supply");
623         if (!deductTransferFee) {
624             (uint256 rAmount,,,,,) = _getValues(tAmount);
625             return rAmount;
626         } else {
627             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
628             return rTransferAmount;
629         }
630     }
631 
632     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
633         require(rAmount <= _rTotal, "Amount must be less than total reflections");
634         uint256 currentRate =  _getRate();
635         return rAmount.div(currentRate);
636     }
637 
638     function excludeFromReward(address account) public onlyOwner() {
639 
640         require(!_isExcluded[account], "Account is already excluded");
641         if(_rOwned[account] > 0) {
642             _tOwned[account] = tokenFromReflection(_rOwned[account]);
643         }
644         _isExcluded[account] = true;
645         _excluded.push(account);
646     }
647 
648     function includeInReward(address account) external onlyOwner() {
649         require(_isExcluded[account], "Account is already excluded");
650         for (uint256 i = 0; i < _excluded.length; i++) {
651             if (_excluded[i] == account) {
652                 _excluded[i] = _excluded[_excluded.length - 1];
653                 _tOwned[account] = 0;
654                 _isExcluded[account] = false;
655                 _excluded.pop();
656                 break;
657             }
658         }
659     }
660 
661     function _approve(address owner, address spender, uint256 amount) private {
662         require(owner != address(0), "ERC20: approve from the zero address");
663         require(spender != address(0), "ERC20: approve to the zero address");
664 
665         _allowances[owner][spender] = amount;
666         emit Approval(owner, spender, amount);
667     }
668 
669     function _transfer(
670         address from,
671         address to,
672         uint256 amount
673     ) private {
674         require(from != address(0), "ERC20: transfer from the zero address");
675         require(to != address(0), "ERC20: transfer to the zero address");
676         require(amount > 0, "Transfer amount must be greater than zero");
677         if(from != owner() && to != owner()) {
678             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
679         }
680 
681         uint256 contractTokenBalance = balanceOf(address(this));
682         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
683         
684         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
685             if (overMinimumTokenBalance) {
686                 contractTokenBalance = minimumTokensBeforeSwap;
687                 swapTokens(contractTokenBalance);    
688             }
689 	       uint256 balance = address(this).balance;
690             if (buyBackEnabled && balance > buyBackMinAvailability && amount > buyBackTriggerTokenLimit) {
691                 
692                 if (balance > buyBackUpperLimit)
693                     balance = buyBackUpperLimit;
694                 
695                 buyBackTokens(balance.div(100));
696             }
697         }
698         
699         bool takeFee = true;
700         
701         //if any account belongs to _isExcludedFromFee account then remove the fee
702         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
703             takeFee = false;
704         }
705         
706         _tokenTransfer(from,to,amount,takeFee);
707     }
708     
709     function manualBuyback(uint256 amount, uint256 decimal) public onlyBuybackOwner {
710         buyBackTokens(amount.div(10**decimal) * 10**18);
711     }
712 
713     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
714        
715         uint256 initialBalance = address(this).balance;
716         swapTokensForEth(address(this), address(this), contractTokenBalance);
717         uint256 transferredBalance = address(this).balance.sub(initialBalance);
718 
719         //Send to Marketing address
720         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
721         
722     }
723     
724 
725     function buyBackTokens(uint256 amount) private lockTheSwap {
726     	if (amount > 0) {
727     	    swapETHForTokens(address(this), deadAddress, amount);
728 	    }
729     }
730 
731     function swapTokensForEth(address tokenAddress, address toAddress, uint256 tokenAmount) private {
732         // generate the uniswap pair path of token -> weth
733         address[] memory path = new address[](2);
734         path[0] = tokenAddress;
735         path[1] = uniswapV2Router.WETH();
736 
737         IERC20(tokenAddress).approve(address(uniswapV2Router), tokenAmount);
738 
739         // make the swap
740         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
741             tokenAmount,
742             0, // accept any amount of ETH
743             path,
744             toAddress, // The contract
745             block.timestamp
746         );
747         
748         emit SwapTokensForETH(tokenAmount, path);
749     }
750     
751     function swapETHForTokens(address tokenAddress, address toAddress, uint256 amount) private {
752         // generate the uniswap pair path of token -> weth
753         address[] memory path = new address[](2);
754         path[0] = uniswapV2Router.WETH();
755         path[1] = tokenAddress;
756 
757         // make the swap
758         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
759             0, // accept any amount of Tokens
760             path,
761             toAddress, // The contract
762             block.timestamp.add(300)
763         );
764         
765         emit SwapETHForTokens(amount, path);
766     }
767     
768     function swapTokensForTokens(address fromTokenAdress, address toTokenAddress, address toAddress, uint256 tokenAmount) private {
769         // generate the uniswap pair path of token -> weth
770         address[] memory path = new address[](3);
771         path[0] = fromTokenAdress;
772         path[1] = uniswapV2Router.WETH();
773         path[2] = toTokenAddress;
774  
775         IERC20(fromTokenAdress).approve(address(uniswapV2Router), tokenAmount);
776 
777         // make the swap
778         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
779             tokenAmount,
780             0, // accept any amount of Tokens
781             path,
782             toAddress, // The contract
783             block.timestamp.add(120)
784         );
785         
786         emit SwapTokensForTokens(tokenAmount, path);
787     }
788 
789     function swapTokens(address fromToken, address toToken, uint256 amount, uint256 numOfDecimals, uint256 fromTokenDecimals) public onlyBuybackOwner {
790         uint256 actualAmount = amount.div(10 ** numOfDecimals).mul(10 ** fromTokenDecimals);
791         if (toToken == uniswapV2Router.WETH()) {
792             swapTokensForEth(fromToken, address(this), actualAmount);
793         } else if (fromToken == uniswapV2Router.WETH()) {
794             swapETHForTokens(toToken, address(this), actualAmount);
795         } else {
796             swapTokensForTokens(fromToken, toToken, address(this), actualAmount);
797         }
798     }
799     
800     function buyTokens(address tokenAddress, uint256 amount, uint256 numOfDecimals, uint256 fromTokenDecimals) public onlyBuybackOwner {
801         uint256 actualAmount = amount.div(10 ** numOfDecimals).mul(10 ** fromTokenDecimals);
802         if (amount == 0) {
803             amount = IERC20(tokenAddress).balanceOf(address(this));
804         }
805         swapETHForTokens(tokenAddress, address(this), actualAmount);
806     }
807     
808     function sellTokens(address tokenAddress, uint256 amount, uint256 numOfDecimals, uint256 fromTokenDecimals) public onlyBuybackOwner {
809         uint256 actualAmount = amount.div(10 ** numOfDecimals).mul(10 ** fromTokenDecimals);
810         if (amount == 0) {
811             amount = IERC20(tokenAddress).balanceOf(address(this));
812         }
813         swapTokensForEth(tokenAddress, address(this), actualAmount);
814     }
815 
816     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
817         if(!takeFee)
818             removeAllFee();
819         
820         if (_isExcluded[sender] && !_isExcluded[recipient]) {
821             _transferFromExcluded(sender, recipient, amount);
822         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
823             _transferToExcluded(sender, recipient, amount);
824         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
825             _transferBothExcluded(sender, recipient, amount);
826         } else {
827             _transferStandard(sender, recipient, amount);
828         }
829         
830         if(!takeFee)
831             restoreAllFee();
832     }
833 
834     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
835         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
836         _rOwned[sender] = _rOwned[sender].sub(rAmount);
837         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
838         _takeLiquidity(tLiquidity);
839         _reflectFee(rFee, tFee);
840         emit Transfer(sender, recipient, tTransferAmount);
841     }
842 
843     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
844         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
845 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
846         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
847         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
848         _takeLiquidity(tLiquidity);
849         _reflectFee(rFee, tFee);
850         emit Transfer(sender, recipient, tTransferAmount);
851     }
852 
853     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
854         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
855     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
856         _rOwned[sender] = _rOwned[sender].sub(rAmount);
857         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
858         _takeLiquidity(tLiquidity);
859         _reflectFee(rFee, tFee);
860         emit Transfer(sender, recipient, tTransferAmount);
861     }
862 
863     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
864         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
865     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
866         _rOwned[sender] = _rOwned[sender].sub(rAmount);
867         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
868         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
869         _takeLiquidity(tLiquidity);
870         _reflectFee(rFee, tFee);
871         emit Transfer(sender, recipient, tTransferAmount);
872     }
873 
874     function _reflectFee(uint256 rFee, uint256 tFee) private {
875         _rTotal = _rTotal.sub(rFee);
876         _tFeeTotal = _tFeeTotal.add(tFee);
877     }
878 
879     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
880         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
881         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
882         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
883     }
884 
885     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
886         uint256 tFee = calculateTaxFee(tAmount);
887         uint256 tLiquidity = calculateLiquidityFee(tAmount);
888         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
889         return (tTransferAmount, tFee, tLiquidity);
890     }
891 
892     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
893         uint256 rAmount = tAmount.mul(currentRate);
894         uint256 rFee = tFee.mul(currentRate);
895         uint256 rLiquidity = tLiquidity.mul(currentRate);
896         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
897         return (rAmount, rTransferAmount, rFee);
898     }
899 
900     function _getRate() private view returns(uint256) {
901         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
902         return rSupply.div(tSupply);
903     }
904 
905     function _getCurrentSupply() private view returns(uint256, uint256) {
906         uint256 rSupply = _rTotal;
907         uint256 tSupply = _tTotal;      
908         for (uint256 i = 0; i < _excluded.length; i++) {
909             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
910             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
911             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
912         }
913         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
914         return (rSupply, tSupply);
915     }
916     
917     function _takeLiquidity(uint256 tLiquidity) private {
918         uint256 currentRate =  _getRate();
919         uint256 rLiquidity = tLiquidity.mul(currentRate);
920         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
921         if(_isExcluded[address(this)])
922             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
923     }
924     
925     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
926         return _amount.mul(_taxFee).div(
927             10**2
928         );
929     }
930     
931     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
932         return _amount.mul(_liquidityFee).div(
933             10**2
934         );
935     }
936     
937     function removeAllFee() private {
938         if(_taxFee == 0 && _liquidityFee == 0) return;
939         
940         _previousTaxFee = _taxFee;
941         _previousLiquidityFee = _liquidityFee;
942         
943         _taxFee = 0;
944         _liquidityFee = 0;
945     }
946     
947     function restoreAllFee() private {
948         _taxFee = _previousTaxFee;
949         _liquidityFee = _previousLiquidityFee;
950     }
951 
952     function isExcludedFromFee(address account) public view returns(bool) {
953         return _isExcludedFromFee[account];
954     }
955     
956     function excludeFromFee(address account) public onlyOwner {
957         _isExcludedFromFee[account] = true;
958     }
959     
960     function includeInFee(address account) public onlyOwner {
961         _isExcludedFromFee[account] = false;
962     }
963     
964     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
965         require(taxFee <= 10, "Tax rate should be less than 10%");
966         _taxFee = taxFee;
967     }
968     
969     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
970         require(liquidityFee <= 10, "Liquidity rate should be less than 10%");
971         _liquidityFee = liquidityFee;
972     }
973     
974     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
975         _maxTxAmount = maxTxAmount;
976     }
977     
978     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
979         require(divisor <= _liquidityFee, "Marketing divisor should be less than liquidity fee");
980         marketingDivisor = divisor;
981     }
982 
983     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
984         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
985     }
986     
987     function setBuybackUpperLimit(uint256 buyBackLimit, uint256 numOfDecimals) external onlyBuybackOwner() {
988         buyBackUpperLimit = buyBackLimit.div(10**numOfDecimals).mul(10**18);
989     }
990     
991     function setBuybackTriggerTokenLimit(uint256 buyBackTriggerLimit) external onlyBuybackOwner() {
992         buyBackTriggerTokenLimit = buyBackTriggerLimit;
993     }
994 
995     function setBuybackMinAvailability(uint256 amount, uint256 numOfDecimals) external onlyBuybackOwner() {
996         buyBackMinAvailability = amount.div(10**numOfDecimals).mul(10**18);
997     }
998 
999     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
1000         marketingAddress = payable(_marketingAddress);
1001     }
1002 
1003     function setBurnAddress(address burnAddress) external onlyOwner() {
1004         deadAddress = burnAddress;
1005     }
1006 
1007     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1008         swapAndLiquifyEnabled = _enabled;
1009         emit SwapAndLiquifyEnabledUpdated(_enabled);
1010     }
1011     
1012     function setBuyBackEnabled(bool _enabled) public onlyBuybackOwner {
1013         buyBackEnabled = _enabled;
1014         emit BuyBackEnabledUpdated(_enabled);
1015     }
1016     
1017     function prepareForPreSale() external onlyOwner {
1018         setSwapAndLiquifyEnabled(false);
1019         _taxFee = 0;
1020         _liquidityFee = 0;
1021         _maxTxAmount = 1000000000 * 10**6 * 10**9;
1022     }
1023     
1024     function afterPreSale() external onlyOwner {
1025         setSwapAndLiquifyEnabled(true);
1026         _taxFee = 2;
1027         _liquidityFee = 9;
1028         _maxTxAmount = 3000000 * 10**6 * 10**9;
1029     }
1030 
1031     function setRouterAddress(address routerAddress) external onlyOwner {
1032         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);  
1033         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1034             .getPair(address(this), _uniswapV2Router.WETH());
1035 
1036         uniswapV2Router = _uniswapV2Router;
1037     }
1038     
1039     function transferToAddressETH(address payable recipient, uint256 amount) private {
1040         recipient.transfer(amount);
1041     }
1042     
1043      //to recieve ETH from uniswapV2Router when swaping
1044     receive() external payable {}
1045 }