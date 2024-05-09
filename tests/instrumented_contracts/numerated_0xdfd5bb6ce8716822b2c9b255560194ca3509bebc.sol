1 /*
2 
3 ViceToken is built upon the fundamentals of Friendly Whale Buybacks and increasing the investor's value
4     
5 Main features are
6     
7 1) 6% tax is collected and distributed to holders for HODLing
8 2) 9% buyback and marketing tax is collected and 3% of it is sent for marketing fund and othe 6% is used to buyback the tokens
9 
10 #                                                               
11 #
12 #   ___      ___  ___   ________   _______                      
13 #  |\  \    /  /||\  \ |\   ____\ |\  ___ \                     
14 #  \ \  \  /  / /\ \  \\ \  \___| \ \   __/|                    
15 #   \ \  \/  / /  \ \  \\ \  \     \ \  \_|/__                  
16 #    \ \    / /    \ \  \\ \  \____ \ \  \_|\ \                 
17 #     \ \__/ /      \ \__\\ \_______\\ \_______\                
18 #      \|__|/        \|__| \|_______| \|_______|
19 #
20 #   _________   ________   ___  __     _______    ________      
21 #  |\___   ___\|\   __  \ |\  \|\  \  |\  ___ \  |\   ___  \    
22 #  \|___ \  \_|\ \  \|\  \\ \  \/  /|_\ \   __/| \ \  \\ \  \   
23 #       \ \  \  \ \  \\\  \\ \   ___  \\ \  \_|/__\ \  \\ \  \  
24 #        \ \  \  \ \  \\\  \\ \  \\ \  \\ \  \_|\ \\ \  \\ \  \ 
25 #         \ \__\  \ \_______\\ \__\\ \__\\ \_______\\ \__\\ \__\
26 #          \|__|   \|_______| \|__| \|__| \|_______| \|__| \|__|
27 #                                                               
28 #                                                               
29 # https://ViceToken.io                                                              
30 
31 */
32 
33 // SPDX-License-Identifier: Unlicensed
34 
35 pragma solidity ^0.8.4;
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return payable(msg.sender);
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 
49 interface IERC20 {
50 
51     function totalSupply() external view returns (uint256);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59     
60 
61 }
62 
63 library SafeMath {
64 
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b > 0, errorMessage);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         return mod(a, b, "SafeMath: modulo by zero");
109     }
110 
111     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b != 0, errorMessage);
113         return a % b;
114     }
115 }
116 
117 library Address {
118 
119     function isContract(address account) internal view returns (bool) {
120         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
121         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
122         // for accounts without code, i.e. `keccak256('')`
123         bytes32 codehash;
124         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
125         // solhint-disable-next-line no-inline-assembly
126         assembly { codehash := extcodehash(account) }
127         return (codehash != accountHash && codehash != 0x0);
128     }
129 
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
134         (bool success, ) = recipient.call{ value: amount }("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138 
139     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
140       return functionCall(target, data, "Address: low-level call failed");
141     }
142 
143     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
144         return _functionCallWithValue(target, data, 0, errorMessage);
145     }
146 
147     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
149     }
150 
151     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
152         require(address(this).balance >= value, "Address: insufficient balance for call");
153         return _functionCallWithValue(target, data, value, errorMessage);
154     }
155 
156     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
157         require(isContract(target), "Address: call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
160         if (success) {
161             return returndata;
162         } else {
163             
164             if (returndata.length > 0) {
165                 assembly {
166                     let returndata_size := mload(returndata)
167                     revert(add(32, returndata), returndata_size)
168                 }
169             } else {
170                 revert(errorMessage);
171             }
172         }
173     }
174 }
175 
176 contract Ownable is Context {
177     address private _owner;
178     address private _previousOwner;
179     uint256 private _lockTime;
180 
181     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182 
183     constructor () {
184         address msgSender = _msgSender();
185         _owner = msgSender;
186         emit OwnershipTransferred(address(0), msgSender);
187     }
188 
189     function owner() public view returns (address) {
190         return _owner;
191     }   
192     
193     modifier onlyOwner() {
194         require(_owner == _msgSender(), "Ownable: caller is not the owner");
195         _;
196     }
197     
198     function renounceOwnership() public virtual onlyOwner {
199         emit OwnershipTransferred(_owner, address(0));
200         _owner = address(0);
201     }
202 
203     function transferOwnership(address newOwner) public virtual onlyOwner {
204         require(newOwner != address(0), "Ownable: new owner is the zero address");
205         emit OwnershipTransferred(_owner, newOwner);
206         _owner = newOwner;
207     }
208 
209     function getUnlockTime() public view returns (uint256) {
210         return _lockTime;
211     }
212     
213     function getTime() public view returns (uint256) {
214         return block.timestamp;
215     }
216 
217     function lock(uint256 time) public virtual onlyOwner {
218         _previousOwner = _owner;
219         _owner = address(0);
220         _lockTime = block.timestamp + time;
221         emit OwnershipTransferred(_owner, address(0));
222     }
223     
224     function unlock() public virtual {
225         require(_previousOwner == msg.sender, "You don't have permission to unlock");
226         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
227         emit OwnershipTransferred(_owner, _previousOwner);
228         _owner = _previousOwner;
229     }
230 }
231 
232 // pragma solidity >=0.5.0;
233 
234 interface IUniswapV2Factory {
235     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
236 
237     function feeTo() external view returns (address);
238     function feeToSetter() external view returns (address);
239 
240     function getPair(address tokenA, address tokenB) external view returns (address pair);
241     function allPairs(uint) external view returns (address pair);
242     function allPairsLength() external view returns (uint);
243 
244     function createPair(address tokenA, address tokenB) external returns (address pair);
245 
246     function setFeeTo(address) external;
247     function setFeeToSetter(address) external;
248 }
249 
250 
251 // pragma solidity >=0.5.0;
252 
253 interface IUniswapV2Pair {
254     event Approval(address indexed owner, address indexed spender, uint value);
255     event Transfer(address indexed from, address indexed to, uint value);
256 
257     function name() external pure returns (string memory);
258     function symbol() external pure returns (string memory);
259     function decimals() external pure returns (uint8);
260     function totalSupply() external view returns (uint);
261     function balanceOf(address owner) external view returns (uint);
262     function allowance(address owner, address spender) external view returns (uint);
263 
264     function approve(address spender, uint value) external returns (bool);
265     function transfer(address to, uint value) external returns (bool);
266     function transferFrom(address from, address to, uint value) external returns (bool);
267 
268     function DOMAIN_SEPARATOR() external view returns (bytes32);
269     function PERMIT_TYPEHASH() external pure returns (bytes32);
270     function nonces(address owner) external view returns (uint);
271 
272     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
273     
274     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
275     event Swap(
276         address indexed sender,
277         uint amount0In,
278         uint amount1In,
279         uint amount0Out,
280         uint amount1Out,
281         address indexed to
282     );
283     event Sync(uint112 reserve0, uint112 reserve1);
284 
285     function MINIMUM_LIQUIDITY() external pure returns (uint);
286     function factory() external view returns (address);
287     function token0() external view returns (address);
288     function token1() external view returns (address);
289     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
290     function price0CumulativeLast() external view returns (uint);
291     function price1CumulativeLast() external view returns (uint);
292     function kLast() external view returns (uint);
293 
294     function burn(address to) external returns (uint amount0, uint amount1);
295     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
296     function skim(address to) external;
297     function sync() external;
298 
299     function initialize(address, address) external;
300 }
301 
302 // pragma solidity >=0.6.2;
303 
304 interface IUniswapV2Router01 {
305     function factory() external pure returns (address);
306     function WETH() external pure returns (address);
307 
308     function addLiquidity(
309         address tokenA,
310         address tokenB,
311         uint amountADesired,
312         uint amountBDesired,
313         uint amountAMin,
314         uint amountBMin,
315         address to,
316         uint deadline
317     ) external returns (uint amountA, uint amountB, uint liquidity);
318     function addLiquidityETH(
319         address token,
320         uint amountTokenDesired,
321         uint amountTokenMin,
322         uint amountETHMin,
323         address to,
324         uint deadline
325     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
326     function removeLiquidity(
327         address tokenA,
328         address tokenB,
329         uint liquidity,
330         uint amountAMin,
331         uint amountBMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountA, uint amountB);
335     function removeLiquidityETH(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external returns (uint amountToken, uint amountETH);
343     function removeLiquidityWithPermit(
344         address tokenA,
345         address tokenB,
346         uint liquidity,
347         uint amountAMin,
348         uint amountBMin,
349         address to,
350         uint deadline,
351         bool approveMax, uint8 v, bytes32 r, bytes32 s
352     ) external returns (uint amountA, uint amountB);
353     function removeLiquidityETHWithPermit(
354         address token,
355         uint liquidity,
356         uint amountTokenMin,
357         uint amountETHMin,
358         address to,
359         uint deadline,
360         bool approveMax, uint8 v, bytes32 r, bytes32 s
361     ) external returns (uint amountToken, uint amountETH);
362     function swapExactTokensForTokens(
363         uint amountIn,
364         uint amountOutMin,
365         address[] calldata path,
366         address to,
367         uint deadline
368     ) external returns (uint[] memory amounts);
369     function swapTokensForExactTokens(
370         uint amountOut,
371         uint amountInMax,
372         address[] calldata path,
373         address to,
374         uint deadline
375     ) external returns (uint[] memory amounts);
376     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
377         external
378         payable
379         returns (uint[] memory amounts);
380     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
381         external
382         returns (uint[] memory amounts);
383     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
384         external
385         returns (uint[] memory amounts);
386     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
387         external
388         payable
389         returns (uint[] memory amounts);
390 
391     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
392     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
393     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
394     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
395     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
396 }
397 
398 
399 
400 // pragma solidity >=0.6.2;
401 
402 interface IUniswapV2Router02 is IUniswapV2Router01 {
403     function removeLiquidityETHSupportingFeeOnTransferTokens(
404         address token,
405         uint liquidity,
406         uint amountTokenMin,
407         uint amountETHMin,
408         address to,
409         uint deadline
410     ) external returns (uint amountETH);
411     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
412         address token,
413         uint liquidity,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline,
418         bool approveMax, uint8 v, bytes32 r, bytes32 s
419     ) external returns (uint amountETH);
420 
421     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
422         uint amountIn,
423         uint amountOutMin,
424         address[] calldata path,
425         address to,
426         uint deadline
427     ) external;
428     function swapExactETHForTokensSupportingFeeOnTransferTokens(
429         uint amountOutMin,
430         address[] calldata path,
431         address to,
432         uint deadline
433     ) external payable;
434     function swapExactTokensForETHSupportingFeeOnTransferTokens(
435         uint amountIn,
436         uint amountOutMin,
437         address[] calldata path,
438         address to,
439         uint deadline
440     ) external;
441 }
442 
443 contract ViceToken is Context, IERC20, Ownable {
444     using SafeMath for uint256;
445     using Address for address;
446     
447     address payable public marketingAddress = payable(0xe2AB214aFeEdC1f2ad156A031C706b6FD0036AD4); // Marketing Address
448     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
449     mapping (address => uint256) private _rOwned;
450     mapping (address => uint256) private _tOwned;
451     mapping (address => mapping (address => uint256)) private _allowances;
452 
453     mapping (address => bool) private _isExcludedFromFee;
454 
455     mapping (address => bool) private _isExcluded;
456     address[] private _excluded;
457    
458     uint256 private constant MAX = ~uint256(0);
459     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
460     uint256 private _rTotal = (MAX - (MAX % _tTotal));
461     uint256 private _tFeeTotal;
462 
463     string private _name = "ViceToken";
464     string private _symbol = "VICEx";
465     uint8 private _decimals = 9;
466 
467 
468     uint256 public _taxFee = 6;
469     uint256 private _previousTaxFee = _taxFee;
470     
471     uint256 public _liquidityFee = 9;
472     uint256 private _previousLiquidityFee = _liquidityFee;
473     
474     uint256 public marketingDivisor = 3;
475     
476     uint256 public _maxTxAmount = 3000000 * 10**6 * 10**9;
477     uint256 private minimumTokensBeforeSwap = 200000 * 10**6 * 10**9; 
478     uint256 private buyBackUpperLimit = 1 * 10**18;
479 
480     IUniswapV2Router02 public immutable uniswapV2Router;
481     address public immutable uniswapV2Pair;
482     
483     bool inSwapAndLiquify;
484     bool public swapAndLiquifyEnabled = false;
485     bool public buyBackEnabled = true;
486 
487     
488     event RewardLiquidityProviders(uint256 tokenAmount);
489     event BuyBackEnabledUpdated(bool enabled);
490     event SwapAndLiquifyEnabledUpdated(bool enabled);
491     event SwapAndLiquify(
492         uint256 tokensSwapped,
493         uint256 ethReceived,
494         uint256 tokensIntoLiqudity
495     );
496     
497     event SwapETHForTokens(
498         uint256 amountIn,
499         address[] path
500     );
501     
502     event SwapTokensForETH(
503         uint256 amountIn,
504         address[] path
505     );
506     
507     modifier lockTheSwap {
508         inSwapAndLiquify = true;
509         _;
510         inSwapAndLiquify = false;
511     }
512     
513     constructor () {
514         _rOwned[_msgSender()] = _rTotal;
515         
516         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
517         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
518             .createPair(address(this), _uniswapV2Router.WETH());
519 
520         uniswapV2Router = _uniswapV2Router;
521 
522         
523         _isExcludedFromFee[owner()] = true;
524         _isExcludedFromFee[address(this)] = true;
525         
526         emit Transfer(address(0), _msgSender(), _tTotal);
527     }
528 
529     function name() public view returns (string memory) {
530         return _name;
531     }
532 
533     function symbol() public view returns (string memory) {
534         return _symbol;
535     }
536 
537     function decimals() public view returns (uint8) {
538         return _decimals;
539     }
540 
541     function totalSupply() public view override returns (uint256) {
542         return _tTotal;
543     }
544 
545     function balanceOf(address account) public view override returns (uint256) {
546         if (_isExcluded[account]) return _tOwned[account];
547         return tokenFromReflection(_rOwned[account]);
548     }
549 
550     function transfer(address recipient, uint256 amount) public override returns (bool) {
551         _transfer(_msgSender(), recipient, amount);
552         return true;
553     }
554 
555     function allowance(address owner, address spender) public view override returns (uint256) {
556         return _allowances[owner][spender];
557     }
558 
559     function approve(address spender, uint256 amount) public override returns (bool) {
560         _approve(_msgSender(), spender, amount);
561         return true;
562     }
563 
564     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
565         _transfer(sender, recipient, amount);
566         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
567         return true;
568     }
569 
570     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
571         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
572         return true;
573     }
574 
575     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
577         return true;
578     }
579 
580     function isExcludedFromReward(address account) public view returns (bool) {
581         return _isExcluded[account];
582     }
583 
584     function totalFees() public view returns (uint256) {
585         return _tFeeTotal;
586     }
587     
588     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
589         return minimumTokensBeforeSwap;
590     }
591     
592     function buyBackUpperLimitAmount() public view returns (uint256) {
593         return buyBackUpperLimit;
594     }
595     
596     function deliver(uint256 tAmount) public {
597         address sender = _msgSender();
598         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
599         (uint256 rAmount,,,,,) = _getValues(tAmount);
600         _rOwned[sender] = _rOwned[sender].sub(rAmount);
601         _rTotal = _rTotal.sub(rAmount);
602         _tFeeTotal = _tFeeTotal.add(tAmount);
603     }
604   
605 
606     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
607         require(tAmount <= _tTotal, "Amount must be less than supply");
608         if (!deductTransferFee) {
609             (uint256 rAmount,,,,,) = _getValues(tAmount);
610             return rAmount;
611         } else {
612             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
613             return rTransferAmount;
614         }
615     }
616 
617     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
618         require(rAmount <= _rTotal, "Amount must be less than total reflections");
619         uint256 currentRate =  _getRate();
620         return rAmount.div(currentRate);
621     }
622 
623     function excludeFromReward(address account) public onlyOwner() {
624 
625         require(!_isExcluded[account], "Account is already excluded");
626         if(_rOwned[account] > 0) {
627             _tOwned[account] = tokenFromReflection(_rOwned[account]);
628         }
629         _isExcluded[account] = true;
630         _excluded.push(account);
631     }
632 
633     function includeInReward(address account) external onlyOwner() {
634         require(_isExcluded[account], "Account is already excluded");
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
654     function _transfer(
655         address from,
656         address to,
657         uint256 amount
658     ) private {
659         require(from != address(0), "ERC20: transfer from the zero address");
660         require(to != address(0), "ERC20: transfer to the zero address");
661         require(amount > 0, "Transfer amount must be greater than zero");
662         if(from != owner() && to != owner()) {
663             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
664         }
665 
666         uint256 contractTokenBalance = balanceOf(address(this));
667         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
668         
669         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
670             if (overMinimumTokenBalance) {
671                 contractTokenBalance = minimumTokensBeforeSwap;
672                 swapTokens(contractTokenBalance);    
673             }
674 	        uint256 balance = address(this).balance;
675             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
676                 
677                 if (balance > buyBackUpperLimit)
678                     balance = buyBackUpperLimit;
679                 
680                 buyBackTokens(balance.div(100));
681             }
682         }
683         
684         bool takeFee = true;
685         
686         //if any account belongs to _isExcludedFromFee account then remove the fee
687         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
688             takeFee = false;
689         }
690         
691         _tokenTransfer(from,to,amount,takeFee);
692     }
693 
694     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
695        
696         uint256 initialBalance = address(this).balance;
697         swapTokensForEth(contractTokenBalance);
698         uint256 transferredBalance = address(this).balance.sub(initialBalance);
699 
700         //Send to Marketing address
701         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
702         
703     }
704     
705 
706     function buyBackTokens(uint256 amount) private lockTheSwap {
707     	if (amount > 0) {
708     	    swapETHForTokens(amount);
709 	    }
710     }
711     
712     function swapTokensForEth(uint256 tokenAmount) private {
713         // generate the uniswap pair path of token -> weth
714         address[] memory path = new address[](2);
715         path[0] = address(this);
716         path[1] = uniswapV2Router.WETH();
717 
718         _approve(address(this), address(uniswapV2Router), tokenAmount);
719 
720         // make the swap
721         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
722             tokenAmount,
723             0, // accept any amount of ETH
724             path,
725             address(this), // The contract
726             block.timestamp
727         );
728         
729         emit SwapTokensForETH(tokenAmount, path);
730     }
731     
732     function swapETHForTokens(uint256 amount) private {
733         // generate the uniswap pair path of token -> weth
734         address[] memory path = new address[](2);
735         path[0] = uniswapV2Router.WETH();
736         path[1] = address(this);
737 
738       // make the swap
739         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
740             0, // accept any amount of Tokens
741             path,
742             deadAddress, // Burn address
743             block.timestamp.add(300)
744         );
745         
746         emit SwapETHForTokens(amount, path);
747     }
748     
749     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
750         // approve token transfer to cover all possible scenarios
751         _approve(address(this), address(uniswapV2Router), tokenAmount);
752 
753         // add the liquidity
754         uniswapV2Router.addLiquidityETH{value: ethAmount}(
755             address(this),
756             tokenAmount,
757             0, // slippage is unavoidable
758             0, // slippage is unavoidable
759             owner(),
760             block.timestamp
761         );
762     }
763 
764     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
765         if(!takeFee)
766             removeAllFee();
767         
768         if (_isExcluded[sender] && !_isExcluded[recipient]) {
769             _transferFromExcluded(sender, recipient, amount);
770         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
771             _transferToExcluded(sender, recipient, amount);
772         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
773             _transferBothExcluded(sender, recipient, amount);
774         } else {
775             _transferStandard(sender, recipient, amount);
776         }
777         
778         if(!takeFee)
779             restoreAllFee();
780     }
781 
782     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
783         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
784         _rOwned[sender] = _rOwned[sender].sub(rAmount);
785         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
786         _takeLiquidity(tLiquidity);
787         _reflectFee(rFee, tFee);
788         emit Transfer(sender, recipient, tTransferAmount);
789     }
790 
791     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
792         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
793 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
794         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
795         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
796         _takeLiquidity(tLiquidity);
797         _reflectFee(rFee, tFee);
798         emit Transfer(sender, recipient, tTransferAmount);
799     }
800 
801     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
802         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
803     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
804         _rOwned[sender] = _rOwned[sender].sub(rAmount);
805         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
806         _takeLiquidity(tLiquidity);
807         _reflectFee(rFee, tFee);
808         emit Transfer(sender, recipient, tTransferAmount);
809     }
810 
811     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
812         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
813     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
814         _rOwned[sender] = _rOwned[sender].sub(rAmount);
815         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
816         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
817         _takeLiquidity(tLiquidity);
818         _reflectFee(rFee, tFee);
819         emit Transfer(sender, recipient, tTransferAmount);
820     }
821 
822     function _reflectFee(uint256 rFee, uint256 tFee) private {
823         _rTotal = _rTotal.sub(rFee);
824         _tFeeTotal = _tFeeTotal.add(tFee);
825     }
826 
827     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
828         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
829         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
830         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
831     }
832 
833     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
834         uint256 tFee = calculateTaxFee(tAmount);
835         uint256 tLiquidity = calculateLiquidityFee(tAmount);
836         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
837         return (tTransferAmount, tFee, tLiquidity);
838     }
839 
840     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
841         uint256 rAmount = tAmount.mul(currentRate);
842         uint256 rFee = tFee.mul(currentRate);
843         uint256 rLiquidity = tLiquidity.mul(currentRate);
844         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
845         return (rAmount, rTransferAmount, rFee);
846     }
847 
848     function _getRate() private view returns(uint256) {
849         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
850         return rSupply.div(tSupply);
851     }
852 
853     function _getCurrentSupply() private view returns(uint256, uint256) {
854         uint256 rSupply = _rTotal;
855         uint256 tSupply = _tTotal;      
856         for (uint256 i = 0; i < _excluded.length; i++) {
857             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
858             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
859             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
860         }
861         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
862         return (rSupply, tSupply);
863     }
864     
865     function _takeLiquidity(uint256 tLiquidity) private {
866         uint256 currentRate =  _getRate();
867         uint256 rLiquidity = tLiquidity.mul(currentRate);
868         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
869         if(_isExcluded[address(this)])
870             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
871     }
872     
873     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
874         return _amount.mul(_taxFee).div(
875             10**2
876         );
877     }
878     
879     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
880         return _amount.mul(_liquidityFee).div(
881             10**2
882         );
883     }
884     
885     function removeAllFee() private {
886         if(_taxFee == 0 && _liquidityFee == 0) return;
887         
888         _previousTaxFee = _taxFee;
889         _previousLiquidityFee = _liquidityFee;
890         
891         _taxFee = 0;
892         _liquidityFee = 0;
893     }
894     
895     function restoreAllFee() private {
896         _taxFee = _previousTaxFee;
897         _liquidityFee = _previousLiquidityFee;
898     }
899 
900     function isExcludedFromFee(address account) public view returns(bool) {
901         return _isExcludedFromFee[account];
902     }
903     
904     function excludeFromFee(address account) public onlyOwner {
905         _isExcludedFromFee[account] = true;
906     }
907     
908     function includeInFee(address account) public onlyOwner {
909         _isExcludedFromFee[account] = false;
910     }
911     
912     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
913         _taxFee = taxFee;
914     }
915     
916     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
917         _liquidityFee = liquidityFee;
918     }
919     
920     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
921         _maxTxAmount = maxTxAmount;
922     }
923     
924     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
925         marketingDivisor = divisor;
926     }
927 
928     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
929         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
930     }
931     
932      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
933         buyBackUpperLimit = buyBackLimit * 10**18;
934     }
935 
936     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
937         marketingAddress = payable(_marketingAddress);
938     }
939 
940     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
941         swapAndLiquifyEnabled = _enabled;
942         emit SwapAndLiquifyEnabledUpdated(_enabled);
943     }
944     
945     function setBuyBackEnabled(bool _enabled) public onlyOwner {
946         buyBackEnabled = _enabled;
947         emit BuyBackEnabledUpdated(_enabled);
948     }
949     
950     function prepareForPreSale() external onlyOwner {
951         setSwapAndLiquifyEnabled(false);
952         _taxFee = 0;
953         _liquidityFee = 0;
954         _maxTxAmount = 1000000000 * 10**6 * 10**9;
955     }
956     
957     function afterPreSale() external onlyOwner {
958         setSwapAndLiquifyEnabled(true);
959         _taxFee = 6;
960         _liquidityFee = 9;
961         _maxTxAmount = 3000000 * 10**6 * 10**9;
962     }
963     
964     function transferToAddressETH(address payable recipient, uint256 amount) private {
965         recipient.transfer(amount);
966     }
967     
968      //to recieve ETH from uniswapV2Router when swaping
969     receive() external payable {}
970 }