1 /** 
2 
3 TG: https://t.me/DuoVerse
4 Twitter: https://twitter.com/DuoVerseErc
5 Website: Duoverse.online
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 pragma solidity ^0.8.4;
10 
11 
12 abstract contract Context {
13 
14     function _msgSender() internal view virtual returns (address payable) {
15         return payable(msg.sender);
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return mod(a, b, "SafeMath: modulo by zero");
81     }
82 
83     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b != 0, errorMessage);
85         return a % b;
86     }
87 }
88 
89 library Address {
90 
91     function isContract(address account) internal view returns (bool) {
92         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
93         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
94         // for accounts without code, i.e. `keccak256('')`
95         bytes32 codehash;
96         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
97         // solhint-disable-next-line no-inline-assembly
98         assembly { codehash := extcodehash(account) }
99         return (codehash != accountHash && codehash != 0x0);
100     }
101 
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
106         (bool success, ) = recipient.call{ value: amount }("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111       return functionCall(target, data, "Address: low-level call failed");
112     }
113 
114     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
115         return _functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         return _functionCallWithValue(target, data, value, errorMessage);
125     }
126 
127     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
128         require(isContract(target), "Address: call to non-contract");
129 
130         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
131         if (success) {
132             return returndata;
133         } else {
134             
135             if (returndata.length > 0) {
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 contract Ownable is Context {
148     address private _owner;
149     address private _previousOwner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     constructor () {
154         address msgSender = _msgSender();
155         _owner = msgSender;
156         emit OwnershipTransferred(address(0), msgSender);
157     }
158 
159     function owner() public view returns (address) {
160         return _owner;
161     }   
162     
163     modifier onlyOwner() {
164         require(_owner == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167     
168     function waiveOwnership() public virtual onlyOwner {
169         emit OwnershipTransferred(_owner, address(0));
170         _owner = address(0);
171     }
172 
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         emit OwnershipTransferred(_owner, newOwner);
176         _owner = newOwner;
177     }
178 }
179 
180 interface IUniswapV2Factory {
181     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
182 
183     function feeTo() external view returns (address);
184     function feeToSetter() external view returns (address);
185 
186     function getPair(address tokenA, address tokenB) external view returns (address pair);
187     function allPairs(uint) external view returns (address pair);
188     function allPairsLength() external view returns (uint);
189 
190     function createPair(address tokenA, address tokenB) external returns (address pair);
191 
192     function setFeeTo(address) external;
193     function setFeeToSetter(address) external;
194 }
195 
196 interface IUniswapV2Pair {
197     event Approval(address indexed owner, address indexed spender, uint value);
198     event Transfer(address indexed from, address indexed to, uint value);
199 
200     function name() external pure returns (string memory);
201     function symbol() external pure returns (string memory);
202     function decimals() external pure returns (uint8);
203     function totalSupply() external view returns (uint);
204     function balanceOf(address owner) external view returns (uint);
205     function allowance(address owner, address spender) external view returns (uint);
206 
207     function approve(address spender, uint value) external returns (bool);
208     function transfer(address to, uint value) external returns (bool);
209     function transferFrom(address from, address to, uint value) external returns (bool);
210 
211     function DOMAIN_SEPARATOR() external view returns (bytes32);
212     function PERMIT_TYPEHASH() external pure returns (bytes32);
213     function nonces(address owner) external view returns (uint);
214 
215     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
216     
217     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
218     event Swap(
219         address indexed sender,
220         uint amount0In,
221         uint amount1In,
222         uint amount0Out,
223         uint amount1Out,
224         address indexed to
225     );
226     event Sync(uint112 reserve0, uint112 reserve1);
227 
228     function MINIMUM_LIQUIDITY() external pure returns (uint);
229     function factory() external view returns (address);
230     function token0() external view returns (address);
231     function token1() external view returns (address);
232     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
233     function price0CumulativeLast() external view returns (uint);
234     function price1CumulativeLast() external view returns (uint);
235     function kLast() external view returns (uint);
236 
237     function burn(address to) external returns (uint amount0, uint amount1);
238     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
239     function skim(address to) external;
240     function sync() external;
241 
242     function initialize(address, address) external;
243 }
244 
245 interface IUniswapV2Router01 {
246     function factory() external pure returns (address);
247     function WETH() external pure returns (address);
248 
249     function addLiquidity(
250         address tokenA,
251         address tokenB,
252         uint amountADesired,
253         uint amountBDesired,
254         uint amountAMin,
255         uint amountBMin,
256         address to,
257         uint deadline
258     ) external returns (uint amountA, uint amountB, uint liquidity);
259     function addLiquidityETH(
260         address token,
261         uint amountTokenDesired,
262         uint amountTokenMin,
263         uint amountETHMin,
264         address to,
265         uint deadline
266     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
267     function removeLiquidity(
268         address tokenA,
269         address tokenB,
270         uint liquidity,
271         uint amountAMin,
272         uint amountBMin,
273         address to,
274         uint deadline
275     ) external returns (uint amountA, uint amountB);
276     function removeLiquidityETH(
277         address token,
278         uint liquidity,
279         uint amountTokenMin,
280         uint amountETHMin,
281         address to,
282         uint deadline
283     ) external returns (uint amountToken, uint amountETH);
284     function removeLiquidityWithPermit(
285         address tokenA,
286         address tokenB,
287         uint liquidity,
288         uint amountAMin,
289         uint amountBMin,
290         address to,
291         uint deadline,
292         bool approveMax, uint8 v, bytes32 r, bytes32 s
293     ) external returns (uint amountA, uint amountB);
294     function removeLiquidityETHWithPermit(
295         address token,
296         uint liquidity,
297         uint amountTokenMin,
298         uint amountETHMin,
299         address to,
300         uint deadline,
301         bool approveMax, uint8 v, bytes32 r, bytes32 s
302     ) external returns (uint amountToken, uint amountETH);
303     function swapExactTokensForTokens(
304         uint amountIn,
305         uint amountOutMin,
306         address[] calldata path,
307         address to,
308         uint deadline
309     ) external returns (uint[] memory amounts);
310     function swapTokensForExactTokens(
311         uint amountOut,
312         uint amountInMax,
313         address[] calldata path,
314         address to,
315         uint deadline
316     ) external returns (uint[] memory amounts);
317     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
318         external
319         payable
320         returns (uint[] memory amounts);
321     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
322         external
323         returns (uint[] memory amounts);
324     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
325         external
326         returns (uint[] memory amounts);
327     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
328         external
329         payable
330         returns (uint[] memory amounts);
331 
332     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
333     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
334     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
335     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
336     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
337 }
338 
339 interface IUniswapV2Router02 is IUniswapV2Router01 {
340     function removeLiquidityETHSupportingFeeOnTransferTokens(
341         address token,
342         uint liquidity,
343         uint amountTokenMin,
344         uint amountETHMin,
345         address to,
346         uint deadline
347     ) external returns (uint amountETH);
348     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
349         address token,
350         uint liquidity,
351         uint amountTokenMin,
352         uint amountETHMin,
353         address to,
354         uint deadline,
355         bool approveMax, uint8 v, bytes32 r, bytes32 s
356     ) external returns (uint amountETH);
357 
358     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
359         uint amountIn,
360         uint amountOutMin,
361         address[] calldata path,
362         address to,
363         uint deadline
364     ) external;
365     function swapExactETHForTokensSupportingFeeOnTransferTokens(
366         uint amountOutMin,
367         address[] calldata path,
368         address to,
369         uint deadline
370     ) external payable;
371     function swapExactTokensForETHSupportingFeeOnTransferTokens(
372         uint amountIn,
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline
377     ) external;
378 }
379 
380 contract DuoVerse is Context, IERC20, Ownable {
381 
382     using SafeMath for uint256;
383     using Address for address;
384     
385     string private _name ="DuoVerse";
386     string private _symbol = "DUO";
387     uint8 private _decimals = 9;
388 
389     address payable private taxWallet1 = payable(0x77d16dcaF668E0156491223D1F0297A6BA822AAC);
390     address payable private taxWallet2 = payable(0x77d16dcaF668E0156491223D1F0297A6BA822AAC);
391     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
392     
393     mapping (address => uint256) _balances;
394     mapping (address => mapping (address => uint256)) private _allowances;
395     
396     mapping (address => bool) public checkExcludedFromFees;
397     mapping (address => bool) public checkWalletLimitExcept;
398     mapping (address => bool) public checkTxLimitExcept;
399     mapping (address => bool) public checkMarketPair;
400 
401     uint256 public _buyLiquidityFees = 0;
402     uint256 public _buyMarketingFees = 5;
403     uint256 public _buyDevelopmentFees = 0;
404     uint256 public _sellLiquidityFees = 0;
405     uint256 public _sellMarketingFees = 5;
406     uint256 public _sellDevelopmentFees = 0;
407 
408     uint256 public _liquidityShares = 0;
409     uint256 public _marketingShares = 10;
410     uint256 public _developmentShares = 0;
411 
412     uint256 public _totalTaxIfBuying = 5;
413     uint256 public _totalTaxIfSelling = 5;
414     uint256 public _totalDistributionShares = 10;
415 
416     uint256 private _totalSupply = 10000 * 10**6 * 10**9;
417     uint256 public _maxTxAmount = 200 * 10**6 * 10**9;
418     uint256 public _walletMax = 200 * 10**6 * 10**9;
419     uint256 private minimumTokensBeforeSwap = 10 * 10**9; 
420 
421     IUniswapV2Router02 public uniswapV2Router;
422     address public uniswapPair;
423     
424     bool inSwapAndLiquify;
425     bool public swapAndLiquifyEnabled = true;
426     bool public swapAndLiquifyByLimitOnly = false;
427     bool public checkWalletLimit = true;
428 
429     event SwapAndLiquifyEnabledUpdated(bool enabled);
430     event SwapAndLiquify(
431         uint256 tokensSwapped,
432         uint256 ethReceived,
433         uint256 tokensIntoLiqudity
434     );
435     
436     event SwapETHForTokens(
437         uint256 amountIn,
438         address[] path
439     );
440     
441     event SwapTokensForETH(
442         uint256 amountIn,
443         address[] path
444     );
445     
446     modifier lockTheSwap {
447         inSwapAndLiquify = true;
448         _;
449         inSwapAndLiquify = false;
450     }
451     
452     constructor () {
453         
454         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
455 
456         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
457             .createPair(address(this), _uniswapV2Router.WETH());
458 
459         uniswapV2Router = _uniswapV2Router;
460         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
461 
462         checkExcludedFromFees[owner()] = true;
463         checkExcludedFromFees[address(this)] = true;
464         
465         _totalTaxIfBuying = _buyLiquidityFees.add(_buyMarketingFees).add(_buyDevelopmentFees);
466         _totalTaxIfSelling = _sellLiquidityFees.add(_sellMarketingFees).add(_sellDevelopmentFees);
467         _totalDistributionShares = _liquidityShares.add(_marketingShares).add(_developmentShares);
468 
469         checkWalletLimitExcept[owner()] = true;
470         checkWalletLimitExcept[address(uniswapPair)] = true;
471         checkWalletLimitExcept[address(this)] = true;
472         
473         checkTxLimitExcept[owner()] = true;
474         checkTxLimitExcept[address(this)] = true;
475 
476         checkMarketPair[address(uniswapPair)] = true;
477 
478         _balances[_msgSender()] = _totalSupply;
479         emit Transfer(address(0), _msgSender(), _totalSupply);
480     }
481 
482     function name() public view returns (string memory) {
483         return _name;
484     }
485 
486     function symbol() public view returns (string memory) {
487         return _symbol;
488     }
489 
490     function decimals() public view returns (uint8) {
491         return _decimals;
492     }
493 
494     function totalSupply() public view override returns (uint256) {
495         return _totalSupply;
496     }
497 
498     function balanceOf(address account) public view override returns (uint256) {
499         return _balances[account];
500     }
501 
502     function allowance(address owner, address spender) public view override returns (uint256) {
503         return _allowances[owner][spender];
504     }
505 
506     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
508         return true;
509     }
510 
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
513         return true;
514     }
515 
516     function approve(address spender, uint256 amount) public override returns (bool) {
517         _approve(_msgSender(), spender, amount);
518         return true;
519     }
520 
521     function _approve(address owner, address spender, uint256 amount) private {
522         require(owner != address(0), "ERC20: approve from the zero address");
523         require(spender != address(0), "ERC20: approve to the zero address");
524 
525         _allowances[owner][spender] = amount;
526         emit Approval(owner, spender, amount);
527     }
528 
529     function addMarketPair(address account) public onlyOwner {
530         checkMarketPair[account] = true;
531     }
532 
533     function setcheckTxLimitExcept(address holder, bool exempt) external onlyOwner {
534         checkTxLimitExcept[holder] = exempt;
535     }
536     
537     function setcheckExcludedFromFees(address account, bool newValue) public onlyOwner {
538         checkExcludedFromFees[account] = newValue;
539     }
540 
541     function setBuyFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
542         _buyLiquidityFees = newLiquidityTax;
543         _buyMarketingFees = newMarketingTax;
544         _buyDevelopmentFees = newDevelopmentTax;
545 
546         _totalTaxIfBuying = _buyLiquidityFees.add(_buyMarketingFees).add(_buyDevelopmentFees);
547     }
548 
549     function setSellFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
550         _sellLiquidityFees = newLiquidityTax;
551         _sellMarketingFees = newMarketingTax;
552         _sellDevelopmentFees = newDevelopmentTax;
553 
554         _totalTaxIfSelling = _sellLiquidityFees.add(_sellMarketingFees).add(_sellDevelopmentFees);
555     }
556     
557     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newDevelopmentShare) external onlyOwner() {
558         _liquidityShares = newLiquidityShare;
559         _marketingShares = newMarketingShare;
560         _developmentShares = newDevelopmentShare;
561 
562         _totalDistributionShares = _liquidityShares.add(_marketingShares).add(_developmentShares);
563     }
564     
565     function adjustMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
566         require(maxTxAmount <= (10000 * 10**6 * 10**9), "Max wallet should be less or euqal to 4% totalSupply");
567         _maxTxAmount = maxTxAmount;
568     }
569 
570     function enableDisableWalletLimit(bool newValue) external onlyOwner {
571        checkWalletLimit = newValue;
572     }
573 
574     function setcheckWalletLimitExcept(address holder, bool exempt) external onlyOwner {
575         checkWalletLimitExcept[holder] = exempt;
576     }
577 
578     function setWalletLimit(uint256 newLimit) external onlyOwner {
579         _walletMax  = newLimit;
580     }
581 
582     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
583         minimumTokensBeforeSwap = newLimit;
584     }
585 
586     function settaxWallet1(address newAddress) external onlyOwner() {
587         taxWallet1 = payable(newAddress);
588     }
589 
590     function settaxWallet2(address newAddress) external onlyOwner() {
591         taxWallet2 = payable(newAddress);
592     }
593 
594     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
595         swapAndLiquifyEnabled = _enabled;
596         emit SwapAndLiquifyEnabledUpdated(_enabled);
597     }
598 
599     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
600         swapAndLiquifyByLimitOnly = newValue;
601     }
602     
603     function getCirculatingSupply() public view returns (uint256) {
604         return _totalSupply.sub(balanceOf(deadAddress));
605     }
606 
607     function transferToAddressETH(address payable recipient, uint256 amount) private {
608         recipient.transfer(amount);
609     }
610     
611     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
612 
613         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
614 
615         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
616 
617         if(newPairAddress == address(0)) //Create If Doesnt exist
618         {
619             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
620                 .createPair(address(this), _uniswapV2Router.WETH());
621         }
622 
623         uniswapPair = newPairAddress; //Set new pair address
624         uniswapV2Router = _uniswapV2Router; //Set new router address
625 
626         checkWalletLimitExcept[address(uniswapPair)] = true;
627         checkMarketPair[address(uniswapPair)] = true;
628     }
629 
630      //to recieve ETH from uniswapV2Router when swaping
631     receive() external payable {}
632 
633     function transfer(address recipient, uint256 amount) public override returns (bool) {
634         _transfer(_msgSender(), recipient, amount);
635         return true;
636     }
637 
638     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
639         _transfer(sender, recipient, amount);
640         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
641         return true;
642     }
643 
644     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
645 
646         require(sender != address(0), "ERC20: transfer from the zero address");
647         require(recipient != address(0), "ERC20: transfer to the zero address");
648 
649         if(inSwapAndLiquify)
650         { 
651             return _basicTransfer(sender, recipient, amount); 
652         }
653         else
654         {
655             if(!checkTxLimitExcept[sender] && !checkTxLimitExcept[recipient]) {
656                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
657             }            
658 
659             uint256 contractTokenBalance = balanceOf(address(this));
660             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
661             
662             if (overMinimumTokenBalance && !inSwapAndLiquify && !checkMarketPair[sender] && swapAndLiquifyEnabled) 
663             {
664                 if(swapAndLiquifyByLimitOnly)
665                     contractTokenBalance = minimumTokensBeforeSwap;
666                 swapAndLiquify(contractTokenBalance);    
667             }
668 
669             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
670 
671             uint256 finalAmount = (checkExcludedFromFees[sender] || checkExcludedFromFees[recipient]) ? 
672                                          amount : takeFee(sender, recipient, amount);
673 
674             if(checkWalletLimit && !checkWalletLimitExcept[recipient])
675                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
676 
677             _balances[recipient] = _balances[recipient].add(finalAmount);
678 
679             emit Transfer(sender, recipient, finalAmount);
680             return true;
681         }
682     }
683 
684     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
685         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
686         _balances[recipient] = _balances[recipient].add(amount);
687         emit Transfer(sender, recipient, amount);
688         return true;
689     }
690 
691     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
692         
693         uint256 tokensForLP = tAmount.mul(_liquidityShares).div(_totalDistributionShares).div(2);
694         uint256 tokensForSwap = tAmount.sub(tokensForLP);
695 
696         swapTokensForEth(tokensForSwap);
697         uint256 amountReceived = address(this).balance;
698 
699         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShares.div(2));
700         
701         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShares).div(totalETHFee).div(2);
702         uint256 amountETHDevelopment = amountReceived.mul(_developmentShares).div(totalETHFee);
703         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity).sub(amountETHDevelopment);
704 
705         if(amountETHMarketing > 0)
706             transferToAddressETH(taxWallet1, amountETHMarketing);
707 
708         if(amountETHDevelopment > 0)
709             transferToAddressETH(taxWallet2, amountETHDevelopment);
710 
711         if(amountETHLiquidity > 0 && tokensForLP > 0)
712             addLiquidity(tokensForLP, amountETHLiquidity);
713     }
714     
715     function swapTokensForEth(uint256 tokenAmount) private {
716         // generate the uniswap pair path of token -> weth
717         address[] memory path = new address[](2);
718         path[0] = address(this);
719         path[1] = uniswapV2Router.WETH();
720 
721         _approve(address(this), address(uniswapV2Router), tokenAmount);
722 
723         // make the swap
724         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
725             tokenAmount,
726             0, // accept any amount of ETH
727             path,
728             address(this), // The contract
729             block.timestamp
730         );
731         
732         emit SwapTokensForETH(tokenAmount, path);
733     }
734 
735     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
736         // approve token transfer to cover all possible scenarios
737         _approve(address(this), address(uniswapV2Router), tokenAmount);
738 
739         // add the liquidity
740         uniswapV2Router.addLiquidityETH{value: ethAmount}(
741             address(this),
742             tokenAmount,
743             0, // slippage is unavoidable
744             0, // slippage is unavoidable
745             owner(),
746             block.timestamp
747         );
748     }
749 
750     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
751         
752         uint256 feeAmount = 0;
753         
754         if(checkMarketPair[sender]) {
755             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
756         }
757         else if(checkMarketPair[recipient]) {
758             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
759         }
760         
761         if(feeAmount > 0) {
762             _balances[address(this)] = _balances[address(this)].add(feeAmount);
763             emit Transfer(sender, address(this), feeAmount);
764         }
765 
766         return amount.sub(feeAmount);
767     }
768     
769 }