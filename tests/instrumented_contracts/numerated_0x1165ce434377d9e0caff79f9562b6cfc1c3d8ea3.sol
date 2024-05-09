1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.15;
3 
4 abstract contract Context 
5 {
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
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64 
65         return c;
66     }
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         return mod(a, b, "SafeMath: modulo by zero");
70     }
71 
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b != 0, errorMessage);
74         return a % b;
75     }
76 }
77 
78 library Address {
79 
80     function isContract(address account) internal view returns (bool) {
81         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
82         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
83         // for accounts without code, i.e. `keccak256('')`
84         bytes32 codehash;
85         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
86         // solhint-disable-next-line no-inline-assembly
87         assembly { codehash := extcodehash(account) }
88         return (codehash != accountHash && codehash != 0x0);
89     }
90 
91     function sendValue(address payable recipient, uint256 amount) internal {
92         require(address(this).balance >= amount, "Address: insufficient balance");
93 
94         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
95         (bool success, ) = recipient.call{ value: amount }("");
96         require(success, "Address: unable to send value, recipient may have reverted");
97     }
98 
99 
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101       return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
105         return _functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
113         require(address(this).balance >= value, "Address: insufficient balance for call");
114         return _functionCallWithValue(target, data, value, errorMessage);
115     }
116 
117     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
118         require(isContract(target), "Address: call to non-contract");
119 
120         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
121         if (success) {
122             return returndata;
123         } else {
124             
125             if (returndata.length > 0) {
126                 assembly {
127                     let returndata_size := mload(returndata)
128                     revert(add(32, returndata), returndata_size)
129                 }
130             } else {
131                 revert(errorMessage);
132             }
133         }
134     }
135 }
136 
137 contract Ownable is Context 
138 {
139     address private _owner;
140     address private _previousOwner;
141     uint256 private _lockTime;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     constructor () {
146         address msgSender = _msgSender();
147         _owner = msgSender;
148         emit OwnershipTransferred(address(0), msgSender);
149     }
150 
151     function owner() public view returns (address) {
152         return _owner;
153     }   
154     
155     modifier onlyOwner() {
156         require(_owner == _msgSender(), "Ownable: caller is not the owner");
157         _;
158     }
159     
160     function renounceOwnership() public virtual onlyOwner {
161         emit OwnershipTransferred(_owner, address(0));
162         _owner = address(0);
163     }
164 
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         emit OwnershipTransferred(_owner, newOwner);
168         _owner = newOwner;
169     }
170 
171     function getUnlockTime() public view returns (uint256) {
172         return _lockTime;
173     }
174     
175     function getTime() public view returns (uint256) {
176         return block.timestamp;
177     }
178 
179     function lock(uint256 time) public virtual onlyOwner {
180         _previousOwner = _owner;
181         _owner = address(0);
182         _lockTime = block.timestamp + time;
183         emit OwnershipTransferred(_owner, address(0));
184     }
185     
186     function unlock() public virtual {
187         require(_previousOwner == msg.sender, "You don't have permission to unlock");
188         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
189         emit OwnershipTransferred(_owner, _previousOwner);
190         _owner = _previousOwner;
191     }
192 }
193 
194 // pragma solidity >=0.5.0;
195 
196 interface IUniswapV2Factory {
197     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
198 
199     function feeTo() external view returns (address);
200     function feeToSetter() external view returns (address);
201 
202     function getPair(address tokenA, address tokenB) external view returns (address pair);
203     function allPairs(uint) external view returns (address pair);
204     function allPairsLength() external view returns (uint);
205 
206     function createPair(address tokenA, address tokenB) external returns (address pair);
207 
208     function setFeeTo(address) external;
209     function setFeeToSetter(address) external;
210 }
211 
212 
213 // pragma solidity >=0.5.0;
214 
215 interface IUniswapV2Pair {
216     event Approval(address indexed owner, address indexed spender, uint value);
217     event Transfer(address indexed from, address indexed to, uint value);
218 
219     function name() external pure returns (string memory);
220     function symbol() external pure returns (string memory);
221     function decimals() external pure returns (uint8);
222     function totalSupply() external view returns (uint);
223     function balanceOf(address owner) external view returns (uint);
224     function allowance(address owner, address spender) external view returns (uint);
225 
226     function approve(address spender, uint value) external returns (bool);
227     function transfer(address to, uint value) external returns (bool);
228     function transferFrom(address from, address to, uint value) external returns (bool);
229 
230     function DOMAIN_SEPARATOR() external view returns (bytes32);
231     function PERMIT_TYPEHASH() external pure returns (bytes32);
232     function nonces(address owner) external view returns (uint);
233 
234     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
235     
236     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
237     event Swap(
238         address indexed sender,
239         uint amount0In,
240         uint amount1In,
241         uint amount0Out,
242         uint amount1Out,
243         address indexed to
244     );
245     event Sync(uint112 reserve0, uint112 reserve1);
246 
247     function MINIMUM_LIQUIDITY() external pure returns (uint);
248     function factory() external view returns (address);
249     function token0() external view returns (address);
250     function token1() external view returns (address);
251     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
252     function price0CumulativeLast() external view returns (uint);
253     function price1CumulativeLast() external view returns (uint);
254     function kLast() external view returns (uint);
255 
256     function burn(address to) external returns (uint amount0, uint amount1);
257     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
258     function skim(address to) external;
259     function sync() external;
260 
261     function initialize(address, address) external;
262 }
263 
264 // pragma solidity >=0.6.2;
265 
266 interface IUniswapV2Router01 {
267     function factory() external pure returns (address);
268     function WETH() external pure returns (address);
269 
270     function addLiquidity(
271         address tokenA,
272         address tokenB,
273         uint amountADesired,
274         uint amountBDesired,
275         uint amountAMin,
276         uint amountBMin,
277         address to,
278         uint deadline
279     ) external returns (uint amountA, uint amountB, uint liquidity);
280     function addLiquidityETH(
281         address token,
282         uint amountTokenDesired,
283         uint amountTokenMin,
284         uint amountETHMin,
285         address to,
286         uint deadline
287     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
288     function removeLiquidity(
289         address tokenA,
290         address tokenB,
291         uint liquidity,
292         uint amountAMin,
293         uint amountBMin,
294         address to,
295         uint deadline
296     ) external returns (uint amountA, uint amountB);
297     function removeLiquidityETH(
298         address token,
299         uint liquidity,
300         uint amountTokenMin,
301         uint amountETHMin,
302         address to,
303         uint deadline
304     ) external returns (uint amountToken, uint amountETH);
305     function removeLiquidityWithPermit(
306         address tokenA,
307         address tokenB,
308         uint liquidity,
309         uint amountAMin,
310         uint amountBMin,
311         address to,
312         uint deadline,
313         bool approveMax, uint8 v, bytes32 r, bytes32 s
314     ) external returns (uint amountA, uint amountB);
315     function removeLiquidityETHWithPermit(
316         address token,
317         uint liquidity,
318         uint amountTokenMin,
319         uint amountETHMin,
320         address to,
321         uint deadline,
322         bool approveMax, uint8 v, bytes32 r, bytes32 s
323     ) external returns (uint amountToken, uint amountETH);
324     function swapExactTokensForTokens(
325         uint amountIn,
326         uint amountOutMin,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external returns (uint[] memory amounts);
331     function swapTokensForExactTokens(
332         uint amountOut,
333         uint amountInMax,
334         address[] calldata path,
335         address to,
336         uint deadline
337     ) external returns (uint[] memory amounts);
338     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
339         external
340         payable
341         returns (uint[] memory amounts);
342     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
343         external
344         returns (uint[] memory amounts);
345     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
346         external
347         returns (uint[] memory amounts);
348     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
349         external
350         payable
351         returns (uint[] memory amounts);
352 
353     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
354     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
355     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
356     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
357     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
358 }
359 
360 
361 
362 // pragma solidity >=0.6.2;
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
405 
406 contract LockToken is Ownable {
407     bool public isOpen = false;
408     mapping(address => bool) private _whiteList;
409     modifier open(address from, address to) {
410         require(isOpen || _whiteList[from] || _whiteList[to] || owner() == _msgSender(), "Not Open");
411         _;
412     }
413 
414     constructor() {
415         _whiteList[owner()] = true;
416         _whiteList[address(this)] = true;
417 
418     }
419 
420     function includeToWhiteList(address[] memory _users) external onlyOwner {
421         for(uint8 i = 0; i < _users.length; i++) {
422             _whiteList[_users[i]] = true;
423         }
424     }
425 }
426 
427 contract HydraToken is Context, IERC20, LockToken 
428 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     address payable public marketingAddress = payable(0xdA7E45c91C72342AfC25B17e118EC5a1b939d4a0);
433     address payable public developmentAddress = payable(0x72888F5C9DA90B5e937d9Da7101165889a76d629);
434 
435     mapping (address => uint256) private _rOwned;
436     mapping (address => uint256) private _tOwned;
437     mapping (address => mapping (address => uint256)) private _allowances;
438     mapping (address => bool) private _isExcludedFromFee;
439     mapping (address => bool) private _isExcluded;
440     mapping (address => bool) private _isExemptFromTxLimit;
441     address[] private _excluded;
442        
443     uint256 private constant MAX = ~uint256(0);
444     uint256 private _tTotal = 100000000 * 10**18;
445     uint256 private _rTotal = (MAX - (MAX % _tTotal));
446     uint256 private _tFeeTotal;
447 
448     string private _name = "Hydra Token";
449     string private _symbol = "HYA";
450     uint8 private _decimals = 18;
451     
452     uint256 public _developmentFee = 20;
453     uint256 private _previousDevelopmentFee = _developmentFee;
454     
455     uint256 public _marketingFee = 20;
456     uint256 private _previousMarketingFee = _marketingFee;
457 
458     uint256 _saleDevelopmentFee = 40;
459     uint256 _saleMarketingFee = 40;
460 
461     uint256 public _maxTxAmount = 2000000 * 10**18;
462     uint256 private _minimumTokensBeforeSwap = 10000 * 10**18;
463 
464 
465     IUniswapV2Router02 public immutable uniswapV2Router;
466     address public uniswapV2Pair;
467     
468     bool inSwapAndLiquify;
469     bool public swapAndLiquifyEnabled = false;
470 
471     
472     event RewardLiquidityProviders(uint256 tokenAmount);
473     event SwapAndLiquifyEnabledUpdated(bool enabled);
474     event SwapAndLiquify(
475         uint256 tokensSwapped,
476         uint256 ethReceived,
477         uint256 tokensIntoLiqudity
478     );
479     
480     event SwapETHForTokens(
481         uint256 amountIn,
482         address[] path
483     );
484     
485     event SwapTokensForETH(
486         uint256 amountIn,
487         address[] path
488     );
489     
490     modifier lockTheSwap {
491         inSwapAndLiquify = true;
492         _;
493         inSwapAndLiquify = false;
494     }
495     
496     constructor () 
497     {
498         _rOwned[owner()] = _rTotal;
499         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
500         
501         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
502         .createPair(address(this), _uniswapV2Router.WETH());
503         uniswapV2Router = _uniswapV2Router;
504         emit Transfer(address(0), owner(), _tTotal);
505 
506         _isExcludedFromFee[owner()] = true;
507         _isExcludedFromFee[address(this)] = true;
508         _isExcludedFromFee[marketingAddress] = true;
509 
510         _isExemptFromTxLimit[owner()] = true;
511         _isExemptFromTxLimit[address(this)] = true;
512         _isExemptFromTxLimit[marketingAddress] = true;
513 
514         excludeWalletsFromWhales();
515 
516     }
517 
518     function name() public view returns (string memory) {
519         return _name;
520     }
521 
522     function symbol() public view returns (string memory) {
523         return _symbol;
524     }
525 
526     function decimals() public view returns (uint8) {
527         return _decimals;
528     }
529 
530     function totalSupply() public view override returns (uint256) {
531         return _tTotal;
532     }
533 
534     function balanceOf(address account) public view override returns (uint256) {
535         if (_isExcluded[account]) return _tOwned[account];
536         return tokenFromReflection(_rOwned[account]);
537     }
538 
539     function transfer(address recipient, uint256 amount) public override returns (bool) {
540         _transfer(_msgSender(), recipient, amount);
541         return true;
542     }
543 
544     function allowance(address owner, address spender) public view override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     function approve(address spender, uint256 amount) public override returns (bool) {
549         _approve(_msgSender(), spender, amount);
550         return true;
551     }
552 
553     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
554         _transfer(sender, recipient, amount);
555         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
556         return true;
557     }
558 
559     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
561         return true;
562     }
563 
564     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
565         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
566         return true;
567     }
568 
569     function isExcludedFromReward(address account) public view returns (bool) 
570     {
571         return _isExcluded[account];
572     }
573 
574     function totalFees() public view returns (uint256) 
575     {
576         return _tFeeTotal;
577     }
578     
579     function _minimumTokensBeforeSwapAmount() public view returns (uint256) 
580     {
581         return _minimumTokensBeforeSwap;
582     }
583 
584 
585     function tokenFromReflection(uint256 rAmount) public view returns(uint256) 
586     {
587         require(rAmount <= _rTotal, "Amount must be less than total reflections");
588         uint256 currentRate =  _getRate();
589         return rAmount.div(currentRate);
590     }
591 
592     function excludeFromReward(address account) public onlyOwner() 
593     {
594         require(!_isExcluded[account], "Account is already excluded");
595         if(_rOwned[account] > 0) {
596             _tOwned[account] = tokenFromReflection(_rOwned[account]);
597         }
598         _isExcluded[account] = true;
599         _excluded.push(account);
600     }
601 
602     function includeInReward(address account) external onlyOwner() {
603         require(_isExcluded[account], "Account is already excluded");
604         for (uint256 i = 0; i < _excluded.length; i++) {
605             if (_excluded[i] == account) {
606                 _excluded[i] = _excluded[_excluded.length - 1];
607                 _tOwned[account] = 0;
608                 _isExcluded[account] = false;
609                 _excluded.pop();
610                 break;
611             }
612         }
613     }
614 
615 
616     function isExcludedFromFee(address account) external view returns(bool) {
617         return _isExcludedFromFee[account];
618     }
619     
620     function excludeFromFee(address account) external onlyOwner {
621         _isExcludedFromFee[account] = true;
622     }
623     
624     function includeInFee(address account) external onlyOwner {
625         _isExcludedFromFee[account] = false;
626     }
627 
628 
629     function _approve(address owner, address spender, uint256 amount) private {
630         require(owner != address(0), "ERC20: approve from the zero address");
631         require(spender != address(0), "ERC20: approve to the zero address");
632 
633         _allowances[owner][spender] = amount;
634         emit Approval(owner, spender, amount);
635     }
636 
637     function _transfer(address from, address to, uint256 amount) private open(from, to)
638     {
639         require(from != address(0), "ERC20: transfer from the zero address");
640         require(to != address(0), "ERC20: transfer to the zero address");
641         require(amount > 0, "Transfer amount must be greater than zero");
642 
643         if(!_isExemptFromTxLimit[from] && !_isExemptFromTxLimit[to]) 
644         {
645             require(amount <= _maxTxAmount, "Exceeds Max Tx Amount");
646         }
647         
648         checkForWhale(from, to, amount);
649         checkForBlackList(from, to);
650 
651         uint256 contractTokenBalance = balanceOf(address(this));
652         bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
653         
654         if (!inSwapAndLiquify && swapAndLiquifyEnabled && from != uniswapV2Pair) {
655             if (overMinimumTokenBalance) 
656             {
657                 contractTokenBalance = _minimumTokensBeforeSwap;
658                 swapAndLiquify(contractTokenBalance);
659             }
660         }
661 
662         if(to==uniswapV2Pair) {  setSaleFee(); }
663         
664         bool takeFee = true;
665         //if any account belongs to _isExcludedFromFee account then remove the fee
666         if(_isExcludedFromFee[from] || _isExcludedFromFee[to])
667         {
668             takeFee = false;
669         }
670 
671         _tokenTransfer(from, to, amount, takeFee);
672 
673     }
674 
675     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap 
676     {
677         uint256 __totalFee = _marketingFee.add(_developmentFee);
678         uint256 initialBalance = address(this).balance;
679         swapTokensForEth(contractTokenBalance); 
680         uint256 newBalance = address(this).balance.sub(initialBalance);
681         uint256 ethForMarketing = newBalance.mul(_marketingFee).div(__totalFee);
682         uint256 ethForDevelopment = newBalance.sub(ethForMarketing);
683         marketingAddress.transfer(ethForMarketing);
684         developmentAddress.transfer(ethForDevelopment);
685         emit SwapAndLiquify(contractTokenBalance, newBalance, contractTokenBalance);
686     }
687 
688     
689 
690     
691     function swapTokensForEth(uint256 tokenAmount) private {
692         // generate the uniswap pair path of token -> weth
693         address[] memory path = new address[](2);
694         path[0] = address(this);
695         path[1] = uniswapV2Router.WETH();
696 
697         _approve(address(this), address(uniswapV2Router), tokenAmount);
698 
699         // make the swap
700         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
701             tokenAmount,
702             0, // accept any amount of ETH
703             path,
704             address(this), // The contract
705             block.timestamp
706         );
707         
708         emit SwapTokensForETH(tokenAmount, path);
709     }
710     
711     
712     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
713         // approve token transfer to cover all possible scenarios
714         _approve(address(this), address(uniswapV2Router), tokenAmount);
715 
716         // add the liquidity
717         uniswapV2Router.addLiquidityETH{value: ethAmount}(
718             address(this),
719             tokenAmount,
720             0, // slippage is unavoidable
721             0, // slippage is unavoidable
722             owner(),
723             block.timestamp
724         );
725     }
726 
727     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private 
728     {
729 
730         if(!takeFee) { removeAllFee(); }
731 
732         if (_isExcluded[sender] && !_isExcluded[recipient]) 
733         {
734             _transferFromExcluded(sender, recipient, amount);
735         } 
736         else if (!_isExcluded[sender] && _isExcluded[recipient]) 
737         {
738             _transferToExcluded(sender, recipient, amount);
739         } 
740         else if(_isExcluded[sender] && _isExcluded[recipient]) 
741         {
742             _transferBothExcluded(sender, recipient, amount);
743         } 
744         else 
745         {
746             _transferStandard(sender, recipient, amount);
747         }   
748 
749         restoreAllFee();
750     }
751 
752     function _transferStandard(address sender, address recipient, uint256 tAmount) private 
753     {
754         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
755         _rOwned[sender] = _rOwned[sender].sub(rAmount);
756         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
757         _takeWalletsFees(tLiquidity);
758         emit Transfer(sender, recipient, tTransferAmount);
759         if(tLiquidity>0) { emit Transfer(sender, address(this), tLiquidity); }
760     }
761 
762     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
763         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
764         _rOwned[sender] = _rOwned[sender].sub(rAmount);
765         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
766         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
767         _takeWalletsFees(tLiquidity);
768         emit Transfer(sender, recipient, tTransferAmount);
769         if(tLiquidity>0) { emit Transfer(sender, address(this), tLiquidity); }
770     }
771 
772     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
773         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
774         _tOwned[sender] = _tOwned[sender].sub(tAmount);
775         _rOwned[sender] = _rOwned[sender].sub(rAmount);
776         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
777         _takeWalletsFees(tLiquidity);
778         emit Transfer(sender, recipient, tTransferAmount);
779         if(tLiquidity>0) { emit Transfer(sender, address(this), tLiquidity); }
780     }
781 
782     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
783         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
784         _tOwned[sender] = _tOwned[sender].sub(tAmount);
785         _rOwned[sender] = _rOwned[sender].sub(rAmount);
786         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
787         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
788         _takeWalletsFees(tLiquidity);
789         emit Transfer(sender, recipient, tTransferAmount);
790         if(tLiquidity>0) { emit Transfer(sender, address(this), tLiquidity); }
791     }
792 
793 
794     function excludeFromTxLimit(address account, bool _value) external onlyOwner
795     {
796         _isExemptFromTxLimit[account] = _value;
797     }
798 
799 
800     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) 
801     {
802         (uint256 tTransferAmount, uint256 tLiquidity) = _getTValues(tAmount);
803         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tLiquidity, _getRate());
804         return (rAmount, rTransferAmount, tTransferAmount, tLiquidity);
805     }
806 
807     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
808         uint256 tLiquidity = calculateWalletsFees(tAmount);
809         uint256 tTransferAmount = tAmount.sub(tLiquidity);
810         return (tTransferAmount, tLiquidity);
811     }
812 
813     function _getRValues(uint256 tAmount, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256) {
814         uint256 rAmount = tAmount.mul(currentRate);
815         uint256 rLiquidity = tLiquidity.mul(currentRate);
816         uint256 rTransferAmount = rAmount.sub(rLiquidity);
817         return (rAmount, rTransferAmount);
818     }
819 
820     function _getRate() private view returns(uint256) {
821         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
822         return rSupply.div(tSupply);
823     }
824 
825     function _getCurrentSupply() private view returns(uint256, uint256) {
826         uint256 rSupply = _rTotal;
827         uint256 tSupply = _tTotal;      
828         for (uint256 i = 0; i < _excluded.length; i++) {
829             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
830             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
831             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
832         }
833         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
834         return (rSupply, tSupply);
835     }
836     
837 
838     function _takeWalletsFees(uint256 tLiquidity) private {
839         uint256 currentRate =  _getRate();
840         uint256 rLiquidity = tLiquidity.mul(currentRate);
841         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
842         if(_isExcluded[address(this)])
843             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
844     }
845     
846     
847     function calculateWalletsFees(uint256 _amount) private view returns (uint256) 
848     {
849         return _amount.mul(_developmentFee+_marketingFee).div(1000);
850     }
851     
852     function removeAllFee() private 
853     {       
854         _developmentFee = 0;
855         _marketingFee = 0;
856     }
857     
858     function restoreAllFee() private 
859     {
860         _developmentFee = _previousDevelopmentFee;
861         _marketingFee = _previousMarketingFee;
862     }
863 
864     function setSaleFee() private 
865     {
866         _developmentFee = _saleDevelopmentFee;
867         _marketingFee = _saleMarketingFee;
868     }
869     
870 
871     event updateBuyFee(uint256 totalFee, uint256 timestamp);
872     function setAllBuyFeePercentages(uint256 developmentFee, uint256 marketingFee) 
873     external onlyOwner()
874     {
875         _developmentFee = developmentFee;
876         _previousDevelopmentFee = developmentFee;
877 
878         _marketingFee = marketingFee;
879         _previousMarketingFee = marketingFee;
880 
881         uint256 totalFee = _developmentFee.add(_marketingFee);
882         require(totalFee<=10, "Too High Fee");
883         emit updateBuyFee(totalFee, block.timestamp);
884     }
885 
886 
887     event updateSellFee(uint256 totalFee, uint256 timestamp);
888     function setAllSaleFeePercentages(uint256 developmentFee, uint256 marketingFee) 
889     external onlyOwner()
890     {
891         _saleDevelopmentFee = developmentFee;
892         _saleMarketingFee = marketingFee;
893         uint256 totalFee = developmentFee.add(marketingFee);
894         require(totalFee<=12, "Too High Fee");
895         emit updateSellFee(totalFee, block.timestamp);
896     }
897 
898 
899     function setMaxTxAmount(uint256 _mount) external onlyOwner() 
900     {
901         require(_mount>_tTotal.div(1000), "Too low Txn limit"); // Min 0.1%
902         _maxTxAmount = _mount;
903     }
904     
905 
906     function setNumTokensSellToAddToLiquidity(uint256 __minimumTokensBeforeSwap) external onlyOwner() 
907     {
908         _minimumTokensBeforeSwap = __minimumTokensBeforeSwap;
909     }
910     
911 
912     function setMarketingAddress(address _marketingAddress) external onlyOwner() 
913     {
914         marketingAddress = payable(_marketingAddress);
915     }
916 
917     function setDevelopmentAddress(address _developmentAddress) external onlyOwner() 
918     {
919         developmentAddress = payable(_developmentAddress);
920     }
921 
922     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner 
923     {
924         swapAndLiquifyEnabled = _enabled;
925         emit SwapAndLiquifyEnabledUpdated(_enabled);
926     }
927     
928      //to recieve ETH from uniswapV2Router when swaping
929     receive() external payable {}
930 
931 
932     mapping (address => bool) private _isExcludedFromWhale;
933     uint256 public _walletHoldingMaxLimit =  2_000_000 * 10**18;
934 
935     function excludeWalletsFromWhales() private 
936     {
937         _isExcludedFromWhale[owner()]=true;
938         _isExcludedFromWhale[address(this)]=true;
939         _isExcludedFromWhale[address(0)]=true;
940         _isExcludedFromWhale[uniswapV2Pair]=true;
941     }
942 
943 
944     function checkForWhale(address from, address to, uint256 amount) 
945     private view
946     {
947         uint256 newBalance = balanceOf(to).add(amount);
948         if(!_isExcludedFromWhale[from] && !_isExcludedFromWhale[to]) 
949         { 
950             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet"); 
951         } 
952         if(from==uniswapV2Pair && !_isExcludedFromWhale[to]) 
953         { 
954             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet"); 
955         } 
956     }
957  
958     function setExcludedFromWhale(address account, bool _enabled) public onlyOwner 
959     {
960         _isExcludedFromWhale[account] = _enabled;
961     } 
962 
963     function  setWalletMaxHoldingLimit(uint256 _amount) public onlyOwner 
964     {
965         _walletHoldingMaxLimit = _amount;
966         require(_walletHoldingMaxLimit>_tTotal.div(1000), "Too less limit");   
967     }
968 
969     mapping(address => bool) public _isBlacklisted;
970 
971     event AccountBlacklisted(address _account,  bool _value, uint256 timestamp);
972     function blacklistAddress(address account, bool value) external onlyOwner
973     {
974         _isBlacklisted[account] = value;
975         emit AccountBlacklisted(account,  value, block.timestamp);
976     }
977 
978     function checkForBlackList(address from, address to) private view
979     {
980         require(!_isBlacklisted[from] && !_isBlacklisted[to], 'Blacklisted address');
981     }
982 
983     function openTrade() external onlyOwner {
984         isOpen = true;
985         swapAndLiquifyEnabled = true;
986         emit SwapAndLiquifyEnabledUpdated(true);
987     }
988 }