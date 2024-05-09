1 /**
2 
3 /* The mind is the root from which all things grow if you can understand the mind,
4 everything else is included. It’s like the root of a tree.
5 All a tree’s fruit and flowers, branches and leaves depend on its root.
6 If you nourish its root, a tree multiplies. If you cut its root, it dies. 
7 Those who understand the mind reach enlightenment with minimal effort.
8 
9 
10    #Daijiryohitsu
11 */
12 
13 // SPDX-License-Identifier: Unlicensed
14 pragma solidity ^0.8.4;
15 
16 
17 abstract contract Context {
18 
19     function _msgSender() internal view virtual returns (address payable) {
20         return payable(msg.sender);
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30 
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 library SafeMath {
42 
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81         return c;
82     }
83 
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         return mod(a, b, "SafeMath: modulo by zero");
86     }
87 
88     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b != 0, errorMessage);
90         return a % b;
91     }
92 }
93 
94 library Address {
95 
96     function isContract(address account) internal view returns (bool) {
97         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
98         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
99         // for accounts without code, i.e. `keccak256('')`
100         bytes32 codehash;
101         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
102         // solhint-disable-next-line no-inline-assembly
103         assembly { codehash := extcodehash(account) }
104         return (codehash != accountHash && codehash != 0x0);
105     }
106 
107     function sendValue(address payable recipient, uint256 amount) internal {
108         require(address(this).balance >= amount, "Address: insufficient balance");
109 
110         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
111         (bool success, ) = recipient.call{ value: amount }("");
112         require(success, "Address: unable to send value, recipient may have reverted");
113     }
114 
115     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
116       return functionCall(target, data, "Address: low-level call failed");
117     }
118 
119     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
120         return _functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
128         require(address(this).balance >= value, "Address: insufficient balance for call");
129         return _functionCallWithValue(target, data, value, errorMessage);
130     }
131 
132     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
136         if (success) {
137             return returndata;
138         } else {
139             
140             if (returndata.length > 0) {
141                 assembly {
142                     let returndata_size := mload(returndata)
143                     revert(add(32, returndata), returndata_size)
144                 }
145             } else {
146                 revert(errorMessage);
147             }
148         }
149     }
150 }
151 
152 contract Ownable is Context {
153     address private _owner;
154     address private _previousOwner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     constructor () {
159         address msgSender = _msgSender();
160         _owner = msgSender;
161         emit OwnershipTransferred(address(0), msgSender);
162     }
163 
164     function owner() public view returns (address) {
165         return _owner;
166     }   
167     
168     modifier onlyOwner() {
169         require(_owner == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172     
173     function waiveOwnership() public virtual onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 interface IUniswapV2Factory {
186     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
187 
188     function feeTo() external view returns (address);
189     function feeToSetter() external view returns (address);
190 
191     function getPair(address tokenA, address tokenB) external view returns (address pair);
192     function allPairs(uint) external view returns (address pair);
193     function allPairsLength() external view returns (uint);
194 
195     function createPair(address tokenA, address tokenB) external returns (address pair);
196 
197     function setFeeTo(address) external;
198     function setFeeToSetter(address) external;
199 }
200 
201 interface IUniswapV2Pair {
202     event Approval(address indexed owner, address indexed spender, uint value);
203     event Transfer(address indexed from, address indexed to, uint value);
204 
205     function name() external pure returns (string memory);
206     function symbol() external pure returns (string memory);
207     function decimals() external pure returns (uint8);
208     function totalSupply() external view returns (uint);
209     function balanceOf(address owner) external view returns (uint);
210     function allowance(address owner, address spender) external view returns (uint);
211 
212     function approve(address spender, uint value) external returns (bool);
213     function transfer(address to, uint value) external returns (bool);
214     function transferFrom(address from, address to, uint value) external returns (bool);
215 
216     function DOMAIN_SEPARATOR() external view returns (bytes32);
217     function PERMIT_TYPEHASH() external pure returns (bytes32);
218     function nonces(address owner) external view returns (uint);
219 
220     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
221     
222     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
223     event Swap(
224         address indexed sender,
225         uint amount0In,
226         uint amount1In,
227         uint amount0Out,
228         uint amount1Out,
229         address indexed to
230     );
231     event Sync(uint112 reserve0, uint112 reserve1);
232 
233     function MINIMUM_LIQUIDITY() external pure returns (uint);
234     function factory() external view returns (address);
235     function token0() external view returns (address);
236     function token1() external view returns (address);
237     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
238     function price0CumulativeLast() external view returns (uint);
239     function price1CumulativeLast() external view returns (uint);
240     function kLast() external view returns (uint);
241 
242     function burn(address to) external returns (uint amount0, uint amount1);
243     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
244     function skim(address to) external;
245     function sync() external;
246 
247     function initialize(address, address) external;
248 }
249 
250 interface IUniswapV2Router01 {
251     function factory() external pure returns (address);
252     function WETH() external pure returns (address);
253 
254     function addLiquidity(
255         address tokenA,
256         address tokenB,
257         uint amountADesired,
258         uint amountBDesired,
259         uint amountAMin,
260         uint amountBMin,
261         address to,
262         uint deadline
263     ) external returns (uint amountA, uint amountB, uint liquidity);
264     function addLiquidityETH(
265         address token,
266         uint amountTokenDesired,
267         uint amountTokenMin,
268         uint amountETHMin,
269         address to,
270         uint deadline
271     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
272     function removeLiquidity(
273         address tokenA,
274         address tokenB,
275         uint liquidity,
276         uint amountAMin,
277         uint amountBMin,
278         address to,
279         uint deadline
280     ) external returns (uint amountA, uint amountB);
281     function removeLiquidityETH(
282         address token,
283         uint liquidity,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline
288     ) external returns (uint amountToken, uint amountETH);
289     function removeLiquidityWithPermit(
290         address tokenA,
291         address tokenB,
292         uint liquidity,
293         uint amountAMin,
294         uint amountBMin,
295         address to,
296         uint deadline,
297         bool approveMax, uint8 v, bytes32 r, bytes32 s
298     ) external returns (uint amountA, uint amountB);
299     function removeLiquidityETHWithPermit(
300         address token,
301         uint liquidity,
302         uint amountTokenMin,
303         uint amountETHMin,
304         address to,
305         uint deadline,
306         bool approveMax, uint8 v, bytes32 r, bytes32 s
307     ) external returns (uint amountToken, uint amountETH);
308     function swapExactTokensForTokens(
309         uint amountIn,
310         uint amountOutMin,
311         address[] calldata path,
312         address to,
313         uint deadline
314     ) external returns (uint[] memory amounts);
315     function swapTokensForExactTokens(
316         uint amountOut,
317         uint amountInMax,
318         address[] calldata path,
319         address to,
320         uint deadline
321     ) external returns (uint[] memory amounts);
322     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
323         external
324         payable
325         returns (uint[] memory amounts);
326     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
327         external
328         returns (uint[] memory amounts);
329     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
330         external
331         returns (uint[] memory amounts);
332     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
333         external
334         payable
335         returns (uint[] memory amounts);
336 
337     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
338     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
339     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
340     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
341     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
342 }
343 
344 interface IUniswapV2Router02 is IUniswapV2Router01 {
345     function removeLiquidityETHSupportingFeeOnTransferTokens(
346         address token,
347         uint liquidity,
348         uint amountTokenMin,
349         uint amountETHMin,
350         address to,
351         uint deadline
352     ) external returns (uint amountETH);
353     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
354         address token,
355         uint liquidity,
356         uint amountTokenMin,
357         uint amountETHMin,
358         address to,
359         uint deadline,
360         bool approveMax, uint8 v, bytes32 r, bytes32 s
361     ) external returns (uint amountETH);
362 
363     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
364         uint amountIn,
365         uint amountOutMin,
366         address[] calldata path,
367         address to,
368         uint deadline
369     ) external;
370     function swapExactETHForTokensSupportingFeeOnTransferTokens(
371         uint amountOutMin,
372         address[] calldata path,
373         address to,
374         uint deadline
375     ) external payable;
376     function swapExactTokensForETHSupportingFeeOnTransferTokens(
377         uint amountIn,
378         uint amountOutMin,
379         address[] calldata path,
380         address to,
381         uint deadline
382     ) external;
383 }
384 
385 contract Bodhidharma is Context, IERC20, Ownable {
386     
387     using SafeMath for uint256;
388     using Address for address;
389     
390     string private _name = "Bodhidharma";
391     string private _symbol = "Daijiryohitsu";
392     uint8 private _decimals = 9;
393 
394     address payable private taxWallet1 = payable(0x000000000000000000000000000000000000dEaD);
395     address payable private taxWallet2 = payable(0x000000000000000000000000000000000000dEaD);
396     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
397     
398     mapping (address => uint256) _balances;
399     mapping (address => mapping (address => uint256)) private _allowances;
400     
401     mapping (address => bool) public checkExcludedFromFees;
402     mapping (address => bool) public checkWalletLimitExcept;
403     mapping (address => bool) public checkTxLimitExcept;
404     mapping (address => bool) public checkMarketPair;
405 
406     uint256 public _buyLiquidityFees = 0;
407     uint256 public _buyMarketingFees = 0;
408     uint256 public _buyDevelopmentFees = 0;
409     uint256 public _sellLiquidityFees = 0;
410     uint256 public _sellMarketingFees = 0;
411     uint256 public _sellDevelopmentFees = 0;
412 
413     uint256 public _liquidityShares = 0;
414     uint256 public _marketingShares = 0;
415     uint256 public _developmentShares = 0;
416 
417     uint256 public _totalTaxIfBuying = 0;
418     uint256 public _totalTaxIfSelling = 0;
419     uint256 public _totalDistributionShares = 0;
420 
421     uint256 private _totalSupply = 10000 * 10**6 * 10**9;
422     uint256 public _maxTxAmount = 200 * 10**6 * 10**9;
423     uint256 public _walletMax = 200 * 10**6 * 10**9;
424     uint256 private minimumTokensBeforeSwap = 10 * 10**9; 
425 
426     IUniswapV2Router02 public uniswapV2Router;
427     address public uniswapPair;
428     
429     bool inSwapAndLiquify;
430     bool public swapAndLiquifyEnabled = false;
431     bool public swapAndLiquifyByLimitOnly = false;
432     bool public checkWalletLimit = true;
433 
434     event SwapAndLiquifyEnabledUpdated(bool enabled);
435     event SwapAndLiquify(
436         uint256 tokensSwapped,
437         uint256 ethReceived,
438         uint256 tokensIntoLiqudity
439     );
440     
441     event SwapETHForTokens(
442         uint256 amountIn,
443         address[] path
444     );
445     
446     event SwapTokensForETH(
447         uint256 amountIn,
448         address[] path
449     );
450     
451     modifier lockTheSwap {
452         inSwapAndLiquify = true;
453         _;
454         inSwapAndLiquify = false;
455     }
456     
457     constructor () {
458         
459         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
460 
461         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
462             .createPair(address(this), _uniswapV2Router.WETH());
463 
464         uniswapV2Router = _uniswapV2Router;
465         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
466 
467         checkExcludedFromFees[owner()] = true;
468         checkExcludedFromFees[address(this)] = true;
469         
470         _totalTaxIfBuying = _buyLiquidityFees.add(_buyMarketingFees).add(_buyDevelopmentFees);
471         _totalTaxIfSelling = _sellLiquidityFees.add(_sellMarketingFees).add(_sellDevelopmentFees);
472         _totalDistributionShares = _liquidityShares.add(_marketingShares).add(_developmentShares);
473 
474         checkWalletLimitExcept[owner()] = true;
475         checkWalletLimitExcept[address(uniswapPair)] = true;
476         checkWalletLimitExcept[address(this)] = true;
477         
478         checkTxLimitExcept[owner()] = true;
479         checkTxLimitExcept[address(this)] = true;
480 
481         checkMarketPair[address(uniswapPair)] = true;
482 
483         _balances[_msgSender()] = _totalSupply;
484         emit Transfer(address(0), _msgSender(), _totalSupply);
485     }
486 
487     function name() public view returns (string memory) {
488         return _name;
489     }
490 
491     function symbol() public view returns (string memory) {
492         return _symbol;
493     }
494 
495     function decimals() public view returns (uint8) {
496         return _decimals;
497     }
498 
499     function totalSupply() public view override returns (uint256) {
500         return _totalSupply;
501     }
502 
503     function balanceOf(address account) public view override returns (uint256) {
504         return _balances[account];
505     }
506 
507     function allowance(address owner, address spender) public view override returns (uint256) {
508         return _allowances[owner][spender];
509     }
510 
511     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
513         return true;
514     }
515 
516     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
518         return true;
519     }
520 
521     function approve(address spender, uint256 amount) public override returns (bool) {
522         _approve(_msgSender(), spender, amount);
523         return true;
524     }
525 
526     function _approve(address owner, address spender, uint256 amount) private {
527         require(owner != address(0), "ERC20: approve from the zero address");
528         require(spender != address(0), "ERC20: approve to the zero address");
529 
530         _allowances[owner][spender] = amount;
531         emit Approval(owner, spender, amount);
532     }
533 
534     function addMarketPair(address account) public onlyOwner {
535         checkMarketPair[account] = true;
536     }
537 
538     function setcheckTxLimitExcept(address holder, bool exempt) external onlyOwner {
539         checkTxLimitExcept[holder] = exempt;
540     }
541     
542     function setcheckExcludedFromFees(address account, bool newValue) public onlyOwner {
543         checkExcludedFromFees[account] = newValue;
544     }
545 
546     function setBuyFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
547         _buyLiquidityFees = newLiquidityTax;
548         _buyMarketingFees = newMarketingTax;
549         _buyDevelopmentFees = newDevelopmentTax;
550 
551         _totalTaxIfBuying = _buyLiquidityFees.add(_buyMarketingFees).add(_buyDevelopmentFees);
552     }
553 
554     function setSellFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
555         _sellLiquidityFees = newLiquidityTax;
556         _sellMarketingFees = newMarketingTax;
557         _sellDevelopmentFees = newDevelopmentTax;
558 
559         _totalTaxIfSelling = _sellLiquidityFees.add(_sellMarketingFees).add(_sellDevelopmentFees);
560     }
561     
562     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newDevelopmentShare) external onlyOwner() {
563         _liquidityShares = newLiquidityShare;
564         _marketingShares = newMarketingShare;
565         _developmentShares = newDevelopmentShare;
566 
567         _totalDistributionShares = _liquidityShares.add(_marketingShares).add(_developmentShares);
568     }
569     
570     function adjustMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
571         require(maxTxAmount <= (10000 * 10**6 * 10**9), "Max wallet should be less or euqal to 4% totalSupply");
572         _maxTxAmount = maxTxAmount;
573     }
574 
575     function enableDisableWalletLimit(bool newValue) external onlyOwner {
576        checkWalletLimit = newValue;
577     }
578 
579     function setcheckWalletLimitExcept(address holder, bool exempt) external onlyOwner {
580         checkWalletLimitExcept[holder] = exempt;
581     }
582 
583     function setWalletLimit(uint256 newLimit) external onlyOwner {
584         _walletMax  = newLimit;
585     }
586 
587     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
588         minimumTokensBeforeSwap = newLimit;
589     }
590 
591     function settaxWallet1(address newAddress) external onlyOwner() {
592         taxWallet1 = payable(newAddress);
593     }
594 
595     function settaxWallet2(address newAddress) external onlyOwner() {
596         taxWallet2 = payable(newAddress);
597     }
598 
599     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
600         swapAndLiquifyEnabled = _enabled;
601         emit SwapAndLiquifyEnabledUpdated(_enabled);
602     }
603 
604     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
605         swapAndLiquifyByLimitOnly = newValue;
606     }
607     
608     function getCirculatingSupply() public view returns (uint256) {
609         return _totalSupply.sub(balanceOf(deadAddress));
610     }
611 
612     function transferToAddressETH(address payable recipient, uint256 amount) private {
613         recipient.transfer(amount);
614     }
615     
616     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
617 
618         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
619 
620         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
621 
622         if(newPairAddress == address(0)) //Create If Doesnt exist
623         {
624             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
625                 .createPair(address(this), _uniswapV2Router.WETH());
626         }
627 
628         uniswapPair = newPairAddress; //Set new pair address
629         uniswapV2Router = _uniswapV2Router; //Set new router address
630 
631         checkWalletLimitExcept[address(uniswapPair)] = true;
632         checkMarketPair[address(uniswapPair)] = true;
633     }
634 
635      //to recieve ETH from uniswapV2Router when swaping
636     receive() external payable {}
637 
638     function transfer(address recipient, uint256 amount) public override returns (bool) {
639         _transfer(_msgSender(), recipient, amount);
640         return true;
641     }
642 
643     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
644         _transfer(sender, recipient, amount);
645         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
646         return true;
647     }
648 
649     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
650 
651         require(sender != address(0), "ERC20: transfer from the zero address");
652         require(recipient != address(0), "ERC20: transfer to the zero address");
653 
654         if(inSwapAndLiquify)
655         { 
656             return _basicTransfer(sender, recipient, amount); 
657         }
658         else
659         {
660             if(!checkTxLimitExcept[sender] && !checkTxLimitExcept[recipient]) {
661                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
662             }            
663 
664             uint256 contractTokenBalance = balanceOf(address(this));
665             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
666             
667             if (overMinimumTokenBalance && !inSwapAndLiquify && !checkMarketPair[sender] && swapAndLiquifyEnabled) 
668             {
669                 if(swapAndLiquifyByLimitOnly)
670                     contractTokenBalance = minimumTokensBeforeSwap;
671                 swapAndLiquify(contractTokenBalance);    
672             }
673 
674             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
675 
676             uint256 finalAmount = (checkExcludedFromFees[sender] || checkExcludedFromFees[recipient]) ? 
677                                          amount : takeFee(sender, recipient, amount);
678 
679             if(checkWalletLimit && !checkWalletLimitExcept[recipient])
680                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
681 
682             _balances[recipient] = _balances[recipient].add(finalAmount);
683 
684             emit Transfer(sender, recipient, finalAmount);
685             return true;
686         }
687     }
688 
689     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
690         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
691         _balances[recipient] = _balances[recipient].add(amount);
692         emit Transfer(sender, recipient, amount);
693         return true;
694     }
695 
696     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
697         
698         uint256 tokensForLP = tAmount.mul(_liquidityShares).div(_totalDistributionShares).div(2);
699         uint256 tokensForSwap = tAmount.sub(tokensForLP);
700 
701         swapTokensForEth(tokensForSwap);
702         uint256 amountReceived = address(this).balance;
703 
704         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShares.div(2));
705         
706         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShares).div(totalETHFee).div(2);
707         uint256 amountETHDevelopment = amountReceived.mul(_developmentShares).div(totalETHFee);
708         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity).sub(amountETHDevelopment);
709 
710         if(amountETHMarketing > 0)
711             transferToAddressETH(taxWallet1, amountETHMarketing);
712 
713         if(amountETHDevelopment > 0)
714             transferToAddressETH(taxWallet2, amountETHDevelopment);
715 
716         if(amountETHLiquidity > 0 && tokensForLP > 0)
717             addLiquidity(tokensForLP, amountETHLiquidity);
718     }
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
740     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
741         // approve token transfer to cover all possible scenarios
742         _approve(address(this), address(uniswapV2Router), tokenAmount);
743 
744         // add the liquidity
745         uniswapV2Router.addLiquidityETH{value: ethAmount}(
746             address(this),
747             tokenAmount,
748             0, // slippage is unavoidable
749             0, // slippage is unavoidable
750             owner(),
751             block.timestamp
752         );
753     }
754 
755     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
756         
757         uint256 feeAmount = 0;
758         
759         if(checkMarketPair[sender]) {
760             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
761         }
762         else if(checkMarketPair[recipient]) {
763             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
764         }
765         
766         if(feeAmount > 0) {
767             _balances[address(this)] = _balances[address(this)].add(feeAmount);
768             emit Transfer(sender, address(this), feeAmount);
769         }
770 
771         return amount.sub(feeAmount);
772     }
773     
774 }