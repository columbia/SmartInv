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
31 interface IERC20Permit {
32     
33     function permit(
34         address owner,
35         address spender,
36         uint256 value,
37         uint256 deadline,
38         uint8 v,
39         bytes32 r,
40         bytes32 s
41     ) external;
42 
43     function nonces(address owner) external view returns (uint256);
44     function DOMAIN_SEPARATOR() external view returns (bytes32);
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
160 library SafeERC20 {
161     using Address for address;
162 
163     function safeTransfer(
164         IERC20 token,
165         address to,
166         uint256 value
167     ) internal {
168         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
169     }
170 
171     function safeTransferFrom(
172         IERC20 token,
173         address from,
174         address to,
175         uint256 value
176     ) internal {
177         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
178     }
179 
180     function safeApprove(
181         IERC20 token,
182         address spender,
183         uint256 value
184     ) internal {
185         // safeApprove should only be called when setting an initial allowance,
186         // or when resetting it to zero. To increase and decrease it, use
187         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
188         require(
189             (value == 0) || (token.allowance(address(this), spender) == 0),
190             "SafeERC20: approve from non-zero to non-zero allowance"
191         );
192         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
193     }
194 
195     function safeIncreaseAllowance(
196         IERC20 token,
197         address spender,
198         uint256 value
199     ) internal {
200         uint256 newAllowance = token.allowance(address(this), spender) + value;
201         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
202     }
203 
204     function safeDecreaseAllowance(
205         IERC20 token,
206         address spender,
207         uint256 value
208     ) internal {
209         unchecked {
210             uint256 oldAllowance = token.allowance(address(this), spender);
211             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
212             uint256 newAllowance = oldAllowance - value;
213             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
214         }
215     }
216 
217     function safePermit(
218         IERC20Permit token,
219         address owner,
220         address spender,
221         uint256 value,
222         uint256 deadline,
223         uint8 v,
224         bytes32 r,
225         bytes32 s
226     ) internal {
227         uint256 nonceBefore = token.nonces(owner);
228         token.permit(owner, spender, value, deadline, v, r, s);
229         uint256 nonceAfter = token.nonces(owner);
230         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
231     }
232 
233     function _callOptionalReturn(IERC20 token, bytes memory data) private {
234         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
235         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
236         // the target address contains contract code and also asserts for success in the low-level call.
237 
238         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
239         if (returndata.length > 0) {
240             // Return data is optional
241             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
242         }
243     }
244 }
245 
246 contract Ownable is Context {
247     address private _owner;
248     address private _previousOwner;
249     uint256 private _lockTime;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     constructor () {
254         address msgSender = _msgSender();
255         _owner = msgSender;
256         emit OwnershipTransferred(address(0), msgSender);
257     }
258 
259     function owner() public view returns (address) {
260         return _owner;
261     }   
262     
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267     
268     function renounceOwnership() public virtual onlyOwner {
269         emit OwnershipTransferred(_owner, address(0));
270         _owner = address(0);
271     }
272 
273     function transferOwnership(address newOwner) public virtual onlyOwner {
274         require(newOwner != address(0), "Ownable: new owner is the zero address");
275         emit OwnershipTransferred(_owner, newOwner);
276         _owner = newOwner;
277     }
278 
279     function getUnlockTime() public view returns (uint256) {
280         return _lockTime;
281     }
282     
283     function getTime() public view returns (uint256) {
284         return block.timestamp;
285     }
286 
287     function lock(uint256 time) public virtual onlyOwner {
288         _previousOwner = _owner;
289         _owner = address(0);
290         _lockTime = block.timestamp + time;
291         emit OwnershipTransferred(_owner, address(0));
292     }
293     
294     function unlock() public virtual {
295         require(_previousOwner == msg.sender, "You don't have permission to unlock");
296         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
297         emit OwnershipTransferred(_owner, _previousOwner);
298         _owner = _previousOwner;
299     }
300 }
301 
302 
303 interface IUniswapV2Factory {
304     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
305 
306     function feeTo() external view returns (address);
307     function feeToSetter() external view returns (address);
308 
309     function getPair(address tokenA, address tokenB) external view returns (address pair);
310     function allPairs(uint) external view returns (address pair);
311     function allPairsLength() external view returns (uint);
312 
313     function createPair(address tokenA, address tokenB) external returns (address pair);
314 
315     function setFeeTo(address) external;
316     function setFeeToSetter(address) external;
317 }
318 
319 
320 interface IUniswapV2Pair {
321     event Approval(address indexed owner, address indexed spender, uint value);
322     event Transfer(address indexed from, address indexed to, uint value);
323 
324     function name() external pure returns (string memory);
325     function symbol() external pure returns (string memory);
326     function decimals() external pure returns (uint8);
327     function totalSupply() external view returns (uint);
328     function balanceOf(address owner) external view returns (uint);
329     function allowance(address owner, address spender) external view returns (uint);
330 
331     function approve(address spender, uint value) external returns (bool);
332     function transfer(address to, uint value) external returns (bool);
333     function transferFrom(address from, address to, uint value) external returns (bool);
334 
335     function DOMAIN_SEPARATOR() external view returns (bytes32);
336     function PERMIT_TYPEHASH() external pure returns (bytes32);
337     function nonces(address owner) external view returns (uint);
338 
339     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
340     
341     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
342     event Swap(
343         address indexed sender,
344         uint amount0In,
345         uint amount1In,
346         uint amount0Out,
347         uint amount1Out,
348         address indexed to
349     );
350     event Sync(uint112 reserve0, uint112 reserve1);
351 
352     function MINIMUM_LIQUIDITY() external pure returns (uint);
353     function factory() external view returns (address);
354     function token0() external view returns (address);
355     function token1() external view returns (address);
356     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
357     function price0CumulativeLast() external view returns (uint);
358     function price1CumulativeLast() external view returns (uint);
359     function kLast() external view returns (uint);
360 
361     function burn(address to) external returns (uint amount0, uint amount1);
362     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
363     function skim(address to) external;
364     function sync() external;
365 
366     function initialize(address, address) external;
367 }
368 
369 
370 interface IUniswapV2Router01 {
371     function factory() external pure returns (address);
372     function WETH() external pure returns (address);
373 
374     function addLiquidity(
375         address tokenA,
376         address tokenB,
377         uint amountADesired,
378         uint amountBDesired,
379         uint amountAMin,
380         uint amountBMin,
381         address to,
382         uint deadline
383     ) external returns (uint amountA, uint amountB, uint liquidity);
384     function addLiquidityETH(
385         address token,
386         uint amountTokenDesired,
387         uint amountTokenMin,
388         uint amountETHMin,
389         address to,
390         uint deadline
391     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
392     function removeLiquidity(
393         address tokenA,
394         address tokenB,
395         uint liquidity,
396         uint amountAMin,
397         uint amountBMin,
398         address to,
399         uint deadline
400     ) external returns (uint amountA, uint amountB);
401     function removeLiquidityETH(
402         address token,
403         uint liquidity,
404         uint amountTokenMin,
405         uint amountETHMin,
406         address to,
407         uint deadline
408     ) external returns (uint amountToken, uint amountETH);
409     function removeLiquidityWithPermit(
410         address tokenA,
411         address tokenB,
412         uint liquidity,
413         uint amountAMin,
414         uint amountBMin,
415         address to,
416         uint deadline,
417         bool approveMax, uint8 v, bytes32 r, bytes32 s
418     ) external returns (uint amountA, uint amountB);
419     function removeLiquidityETHWithPermit(
420         address token,
421         uint liquidity,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline,
426         bool approveMax, uint8 v, bytes32 r, bytes32 s
427     ) external returns (uint amountToken, uint amountETH);
428     function swapExactTokensForTokens(
429         uint amountIn,
430         uint amountOutMin,
431         address[] calldata path,
432         address to,
433         uint deadline
434     ) external returns (uint[] memory amounts);
435     function swapTokensForExactTokens(
436         uint amountOut,
437         uint amountInMax,
438         address[] calldata path,
439         address to,
440         uint deadline
441     ) external returns (uint[] memory amounts);
442     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
443         external
444         payable
445         returns (uint[] memory amounts);
446     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
447         external
448         returns (uint[] memory amounts);
449     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
450         external
451         returns (uint[] memory amounts);
452     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
453         external
454         payable
455         returns (uint[] memory amounts);
456 
457     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
458     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
459     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
460     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
461     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
462 }
463 
464 
465 
466 interface IUniswapV2Router02 is IUniswapV2Router01 {
467     function removeLiquidityETHSupportingFeeOnTransferTokens(
468         address token,
469         uint liquidity,
470         uint amountTokenMin,
471         uint amountETHMin,
472         address to,
473         uint deadline
474     ) external returns (uint amountETH);
475     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
476         address token,
477         uint liquidity,
478         uint amountTokenMin,
479         uint amountETHMin,
480         address to,
481         uint deadline,
482         bool approveMax, uint8 v, bytes32 r, bytes32 s
483     ) external returns (uint amountETH);
484 
485     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
486         uint amountIn,
487         uint amountOutMin,
488         address[] calldata path,
489         address to,
490         uint deadline
491     ) external;
492     function swapExactETHForTokensSupportingFeeOnTransferTokens(
493         uint amountOutMin,
494         address[] calldata path,
495         address to,
496         uint deadline
497     ) external payable;
498     function swapExactTokensForETHSupportingFeeOnTransferTokens(
499         uint amountIn,
500         uint amountOutMin,
501         address[] calldata path,
502         address to,
503         uint deadline
504     ) external;
505 }
506 
507 contract Kishimoto is Context, IERC20, Ownable {
508     using SafeMath for uint256;
509     using Address for address;
510     using SafeERC20 for IERC20;
511     
512     address payable public rewardPoolAddress = payable(0x3cD9C25A96a73A226699C45970485F2dDD360ACE); // reward Pool Address
513     address payable public devAddress = payable(0xF55bF7dA3deA7a3D9078150abf3a2637d71d9413); // Dev Address
514 
515     mapping(address => uint256) private _balances;
516     mapping (address => mapping (address => uint256)) private _allowances;
517     mapping (address => bool) private _isBlacklisted;
518 
519     uint256 private _totalSupply = 100 * 10**9 * 10**9;  // 100 Bn tokens
520 
521 
522     mapping (address => bool) private _isExcludedFromFee;
523 
524     string private _name = "Kishimoto";
525     string private _symbol = "KISHIMOTO";
526     uint8 private _decimals = 9;
527     
528     uint256 public rewardPoolDivisor = 35;
529     uint256 public devDivisor = 35;
530     uint256 public autoLpDivisor = 10;
531 
532     uint256 public _totalFee = 80;  // rewardPoolDivisor + devDivisor + autoLpDivisor
533     uint256 private _previousTotalFee = _totalFee;
534     uint256 public sellFactor = 10; // divided by 10
535     bool public isBuyTaxEnabled = true;
536 
537     uint256 public _maxTxAmount = 3 * 10**8 * 10**9;
538     uint256 public _maxWalletAmount = 1 * 10**9 * 10**9;
539     uint256 private minimumTokensBeforeSwap = 1 * 10**4 * 10**9; 
540 
541     IUniswapV2Router02 public immutable uniswapV2Router;
542     address public uniswapV2Pair;
543     bool public tradingEnabled = false;
544     
545     bool inSwapAndLiquify;
546     bool public swapAndLiquifyEnabled = false;
547 
548     mapping (address => bool) private automatedMarketMaker;
549 
550     event FeesUpdated(uint256 autoLpDivisor, uint256 devDivisor, uint256 rewardPoolDivisor);
551     event SellFactorUpdated(uint256 previousSellFactor, uint256 newSellFactor);
552     event BuyTaxEnabled(bool indexed enable, uint256 blockNumber);
553     event AutomatedMarketMakerEnable(address indexed account, bool indexed enable);
554     event AccountBlacklisted(address indexed account, bool indexed blacklist);
555 
556     event SwapAndLiquifyEnabledUpdated(bool enabled);
557     event SwapAndLiquify(
558         uint256 tokensSwapped,
559         uint256 ethReceived,
560         uint256 tokensIntoLiqudity
561     );
562     
563     event SwapTokensForETH(
564         uint256 amountIn,
565         address[] path
566     );
567 
568 
569     
570     modifier lockTheSwap {
571         inSwapAndLiquify = true;
572         _;
573         inSwapAndLiquify = false;
574     }
575     
576     constructor () {        
577         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
578         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
579             .createPair(address(this), _uniswapV2Router.WETH());
580 
581         uniswapV2Router = _uniswapV2Router;
582         automatedMarketMaker[uniswapV2Pair] = true;
583 
584         _balances[owner()] = _totalSupply;
585         
586         _isExcludedFromFee[owner()] = true;
587         _isExcludedFromFee[address(this)] = true;
588         
589         emit Transfer(address(0), owner(), _totalSupply);
590     }
591 
592     function name() public view returns (string memory) {
593         return _name;
594     }
595 
596     function symbol() public view returns (string memory) {
597         return _symbol;
598     }
599 
600     function decimals() public view returns (uint8) {
601         return _decimals;
602     }
603 
604     function totalSupply() public view override returns (uint256) {
605         return _totalSupply;
606     }
607 
608     function balanceOf(address account) public view override returns (uint256) {
609         return _balances[account];
610     }
611 
612     function transfer(address to, uint256 amount) public virtual override returns (bool) {
613         address owner = _msgSender();
614         _transfer(owner, to, amount);
615         return true;
616     }
617 
618     function allowance(address owner, address spender) public view virtual override returns (uint256) {
619         return _allowances[owner][spender];
620     }
621 
622     function approve(address spender, uint256 amount) public virtual override returns (bool) {
623         address owner = _msgSender();
624         _approve(owner, spender, amount);
625         return true;
626     }
627 
628     function transferFrom(
629         address from,
630         address to,
631         uint256 amount
632     ) public virtual override returns (bool) {
633         address spender = _msgSender();
634         _spendAllowance(from, spender, amount);
635         _transfer(from, to, amount);
636         return true;
637     }
638 
639     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
640         address owner = _msgSender();
641         _approve(owner, spender, allowance(owner, spender) + addedValue);
642         return true;
643     }
644 
645     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
646         address owner = _msgSender();
647         uint256 currentAllowance = allowance(owner, spender);
648         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
649         unchecked {
650             _approve(owner, spender, currentAllowance - subtractedValue);
651         }
652 
653         return true;
654     }
655 
656     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
657         return minimumTokensBeforeSwap;
658     }
659 
660     function isBlacklisted(address account) external view returns(bool) {
661         return _isBlacklisted[account];
662     }
663 
664     function _approve(
665         address owner,
666         address spender,
667         uint256 amount
668     ) internal virtual {
669         require(owner != address(0), "ERC20: approve from the zero address");
670         require(spender != address(0), "ERC20: approve to the zero address");
671 
672         _allowances[owner][spender] = amount;
673         emit Approval(owner, spender, amount);
674     }
675 
676     function _spendAllowance(
677         address owner,
678         address spender,
679         uint256 amount
680     ) internal virtual {
681         uint256 currentAllowance = allowance(owner, spender);
682         if (currentAllowance != type(uint256).max) {
683             require(currentAllowance >= amount, "ERC20: insufficient allowance");
684             unchecked {
685                 _approve(owner, spender, currentAllowance - amount);
686             }
687         }
688     }
689 
690     function _transfer(
691         address from,
692         address to,
693         uint256 amount
694     ) private {
695         require(from != address(0), "ERC20: transfer from the zero address");
696         require(!_isBlacklisted[from], "Not Allowed");
697         require(!_isBlacklisted[to], "Not Allowed");
698 
699         bool takeFee = true;
700         
701         //if any account belongs to _isExcludedFromFee account then remove the fee
702         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
703             takeFee = false;
704 
705         } else {
706             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
707             require(tradingEnabled, "Trading is not started");
708             if (!automatedMarketMaker[to]) {
709                 require(_balances[to] + amount <= _maxWalletAmount, "Wallet amount exceeds limit");
710             }
711 
712         }
713 
714         uint256 contractTokenBalance = balanceOf(address(this));
715         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
716         
717         if (overMinimumTokenBalance && !inSwapAndLiquify && swapAndLiquifyEnabled && from != uniswapV2Pair) {
718             if (overMinimumTokenBalance) {
719                 contractTokenBalance = minimumTokensBeforeSwap;
720                 swapTokens(contractTokenBalance);    
721             }
722         }
723         
724         bool isSell = automatedMarketMaker[to];
725 
726         if(!automatedMarketMaker[from] && !isSell) {
727             takeFee = false;
728         }
729 
730         if(!isBuyTaxEnabled && !isSell) {
731             takeFee = false;
732         }
733         _tokenTransfer(from,to,amount,takeFee,isSell);
734     }
735 
736     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
737        
738         uint256 amountToLiquify = contractTokenBalance.mul(autoLpDivisor).div(_totalFee).div(2);
739         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
740 
741         uint256 initialBalance = address(this).balance;
742         swapTokensForEth(amountToSwap);
743         uint256 transferredBalance = address(this).balance.sub(initialBalance);
744         uint256 totalETHFee = _totalFee.sub(autoLpDivisor.div(2));
745 
746         // adding liquidity
747         if(amountToLiquify > 0) // enabling to set autoLP tax to zero
748             addLiquidity(amountToLiquify, transferredBalance.mul(autoLpDivisor).div(totalETHFee).div(2));
749 
750         //Send to rewardPool and dev address
751         transferToAddressETH(rewardPoolAddress, transferredBalance.mul(rewardPoolDivisor).div(totalETHFee));
752         transferToAddressETH(devAddress, transferredBalance.mul(devDivisor).div(totalETHFee));
753         
754     }
755     
756     function swapTokensForEth(uint256 tokenAmount) private {
757         // generate the uniswap pair path of token -> weth
758         address[] memory path = new address[](2);
759         path[0] = address(this);
760         path[1] = uniswapV2Router.WETH();
761 
762         _approve(address(this), address(uniswapV2Router), tokenAmount);
763 
764         // make the swap
765         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
766             tokenAmount,
767             0, // accept any amount of ETH
768             path,
769             address(this), // The contract
770             block.timestamp
771         );
772         
773         emit SwapTokensForETH(tokenAmount, path);
774     }
775     
776     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
777         // approve token transfer to cover all possible scenarios
778         _approve(address(this), address(uniswapV2Router), tokenAmount);
779 
780         // add the liquidity
781         uniswapV2Router.addLiquidityETH{value: ethAmount}(
782             address(this),
783             tokenAmount,
784             0, // slippage is unavoidable
785             0, // slippage is unavoidable
786             address(this),
787             block.timestamp
788         );
789     }
790 
791     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee, bool isSell) private {
792         if(!takeFee)
793             removeAllFee();
794         
795         _beforeTokenTransfer(sender, recipient, amount);
796 
797         uint256 fromBalance = _balances[sender];
798         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
799         uint256 fees = calculateTotalFee(amount, isSell);
800         uint256 amountToTransfer = amount - fees;
801         unchecked {
802             _balances[sender] = fromBalance - amount;
803             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
804             // decrementing then incrementing.
805             _balances[recipient] += amountToTransfer;
806             _balances[address(this)] += fees;
807         }
808 
809         if(!takeFee)
810             restoreAllFee();
811 
812         emit Transfer(sender, recipient, amountToTransfer);
813         if(fees > 0) {
814             emit Transfer(sender, address(this), fees);
815         }
816 
817         _afterTokenTransfer(sender, recipient, amount);
818         
819         
820     }
821     
822     function calculateTotalFee(uint256 _amount, bool _isSell) private view returns (uint256) {
823         uint256 fees = _amount.mul(_totalFee).div(10**3);
824         return _isSell ? fees.mul(sellFactor).div(10) : fees;
825     }
826     
827     function removeAllFee() private {
828         if(_totalFee == 0) return;
829         
830         _previousTotalFee = _totalFee; 
831         _totalFee = 0;
832     }
833     
834     function restoreAllFee() private {
835         _totalFee = _previousTotalFee;
836     }
837 
838     function isAutomatedMarketMaker(address account) external view returns(bool) {
839         return automatedMarketMaker[account];
840     }
841 
842     function enableAutomatedMarketMaker(address account, bool enable) external onlyOwner {
843         require (automatedMarketMaker[account] != enable, "Already set");
844         automatedMarketMaker[account] = enable;
845 
846         emit AutomatedMarketMakerEnable(account, enable);
847     }
848 
849     function isExcludedFromFee(address account) public view returns(bool) {
850         return _isExcludedFromFee[account];
851     }
852     
853     function excludeFromFee(address account) public onlyOwner {
854         _isExcludedFromFee[account] = true;
855     }
856     
857     function includeInFee(address account) public onlyOwner {
858         _isExcludedFromFee[account] = false;
859     }
860 
861     function updateFeeDivisor(uint256 newAutoLpDivisor, uint256 newDevDivisor, uint256 newrewardPoolDivisor) external onlyOwner {
862         uint256 newTotalFee = newAutoLpDivisor.add(newDevDivisor).add(newrewardPoolDivisor);
863         require( newTotalFee <= 200, "cant set fees to more than 20%");
864 
865         autoLpDivisor = newAutoLpDivisor;
866         devDivisor = newDevDivisor;
867         rewardPoolDivisor = newrewardPoolDivisor;
868 
869         _previousTotalFee = _totalFee;
870         _totalFee = newTotalFee;
871 
872         emit FeesUpdated(newAutoLpDivisor, newDevDivisor, newrewardPoolDivisor);
873     }
874     
875     
876     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
877         _maxTxAmount = maxTxAmount;
878     }
879     
880     function setMaxWalletLimit(uint256 maxWalletLimit) external onlyOwner() {
881         _maxWalletAmount = maxWalletLimit;
882     }
883 
884     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
885         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
886     }
887     
888     function setRewardPoolAddress(address _rewardPoolAddress) external onlyOwner() {
889         rewardPoolAddress = payable(_rewardPoolAddress);
890     }
891 
892     function setDevAddress(address _devAddress) external onlyOwner() {
893         devAddress = payable(_devAddress);
894     }
895 
896     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
897         swapAndLiquifyEnabled = _enabled;
898         emit SwapAndLiquifyEnabledUpdated(_enabled);
899     }
900 
901     function updateSellFactor(uint256 _sellFactor) external onlyOwner {
902         emit SellFactorUpdated(sellFactor, _sellFactor);
903 
904         sellFactor = _sellFactor;
905     }
906 
907     function setBuyTaxEnabled(bool _enable) external onlyOwner {
908         require(isBuyTaxEnabled != _enable, "Already set");
909         isBuyTaxEnabled = _enable;
910 
911         emit BuyTaxEnabled(_enable, block.number);
912     }
913 
914     function withdrawUnsupportedTokens(address token, address recipient) external onlyOwner {
915         require(token != address(this), "Can not withdraw this token");
916         uint256 contractBalance = IERC20(token).balanceOf(address(this));
917         IERC20(token).safeTransfer(recipient, contractBalance);
918     }
919 
920     function enableTrading() external onlyOwner {
921         require (!tradingEnabled, "Already enabled");
922         tradingEnabled = true;
923     }
924 
925     function blacklistAccount(address account, bool blacklist) external onlyOwner {
926         require (_isBlacklisted[account] != blacklist, "Already set");
927         require(account != uniswapV2Pair, "can not blacklist uniswap pair");
928         _isBlacklisted[account] = blacklist;
929 
930         emit AccountBlacklisted(account, blacklist);
931     }
932 
933     function transferToAddressETH(address payable recipient, uint256 amount) private {
934         recipient.transfer(amount);
935     }
936 
937     function withdrawETH(address recipient) external onlyOwner {
938         (bool success, ) = recipient.call{ value: address(this).balance }("");
939         require(success, "unable to send value, recipient may have reverted");
940     }
941 
942     function _beforeTokenTransfer(
943         address from,
944         address to,
945         uint256 amount
946     ) internal virtual {}
947 
948 
949     function _afterTokenTransfer(
950         address from,
951         address to,
952         uint256 amount
953     ) internal virtual {}
954     
955      //to recieve ETH from uniswapV2Router when swaping
956     receive() external payable {}
957 }