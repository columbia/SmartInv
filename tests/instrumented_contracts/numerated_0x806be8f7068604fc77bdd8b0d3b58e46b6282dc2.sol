1 /**
2 
3 Telegram: https://t.me/BlazeBurnt
4 Twitter:  https://twitter.com/BlazeBurntToken
5 Website:  https://blazeburnt.app
6 Bot:      https://t.me/Blaze_Burnt_Bot
7 
8 */
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity ^0.8.4;
11 
12 
13 
14 abstract contract Context {
15 
16     function _msgSender() internal view virtual returns (address payable) {
17         return payable(msg.sender);
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IERC20 {
27 
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 
37 }
38 
39 library SafeMath {
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44 
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55 
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63 
64         uint256 c = a * b;
65         require(c / a == b, "SafeMath: multiplication overflow");
66 
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79         return c;
80     }
81 
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         return mod(a, b, "SafeMath: modulo by zero");
84     }
85 
86     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b != 0, errorMessage);
88         return a % b;
89     }
90 }
91 
92 library Address {
93 
94     function isContract(address account) internal view returns (bool) {
95         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
96         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
97         // for accounts without code, i.e. `keccak256('')`
98         bytes32 codehash;
99         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
100         // solhint-disable-next-line no-inline-assembly
101         assembly { codehash := extcodehash(account) }
102         return (codehash != accountHash && codehash != 0x0);
103     }
104 
105     function sendValue(address payable recipient, uint256 amount) internal {
106         require(address(this).balance >= amount, "Address: insufficient balance");
107 
108         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
109         (bool success, ) = recipient.call{ value: amount }("");
110         require(success, "Address: unable to send value, recipient may have reverted");
111     }
112 
113     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
114       return functionCall(target, data, "Address: low-level call failed");
115     }
116 
117     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
118         return _functionCallWithValue(target, data, 0, errorMessage);
119     }
120 
121     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
126         require(address(this).balance >= value, "Address: insufficient balance for call");
127         return _functionCallWithValue(target, data, value, errorMessage);
128     }
129 
130     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
134         if (success) {
135             return returndata;
136         } else {
137             
138             if (returndata.length > 0) {
139                 assembly {
140                     let returndata_size := mload(returndata)
141                     revert(add(32, returndata), returndata_size)
142                 }
143             } else {
144                 revert(errorMessage);
145             }
146         }
147     }
148 }
149 
150 contract Ownable is Context {
151     address private _owner;
152     address private _previousOwner;
153 
154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155 
156     constructor () {
157         address msgSender = _msgSender();
158         _owner = msgSender;
159         emit OwnershipTransferred(address(0), msgSender);
160     }
161 
162     function owner() public view returns (address) {
163         return _owner;
164     }   
165     
166     modifier onlyOwner() {
167         require(_owner == _msgSender(), "Ownable: caller is not the owner");
168         _;
169     }
170     
171     function waiveOwnership() public virtual onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175 
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         emit OwnershipTransferred(_owner, newOwner);
179         _owner = newOwner;
180     }
181 }
182 
183 interface IUniswapV2Factory {
184     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
185 
186     function feeTo() external view returns (address);
187     function feeToSetter() external view returns (address);
188 
189     function getPair(address tokenA, address tokenB) external view returns (address pair);
190     function allPairs(uint) external view returns (address pair);
191     function allPairsLength() external view returns (uint);
192 
193     function createPair(address tokenA, address tokenB) external returns (address pair);
194 
195     function setFeeTo(address) external;
196     function setFeeToSetter(address) external;
197 }
198 
199 interface IUniswapV2Pair {
200     event Approval(address indexed owner, address indexed spender, uint value);
201     event Transfer(address indexed from, address indexed to, uint value);
202 
203     function name() external pure returns (string memory);
204     function symbol() external pure returns (string memory);
205     function decimals() external pure returns (uint8);
206     function totalSupply() external view returns (uint);
207     function balanceOf(address owner) external view returns (uint);
208     function allowance(address owner, address spender) external view returns (uint);
209 
210     function approve(address spender, uint value) external returns (bool);
211     function transfer(address to, uint value) external returns (bool);
212     function transferFrom(address from, address to, uint value) external returns (bool);
213 
214     function DOMAIN_SEPARATOR() external view returns (bytes32);
215     function PERMIT_TYPEHASH() external pure returns (bytes32);
216     function nonces(address owner) external view returns (uint);
217 
218     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
219     
220     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
221     event Swap(
222         address indexed sender,
223         uint amount0In,
224         uint amount1In,
225         uint amount0Out,
226         uint amount1Out,
227         address indexed to
228     );
229     event Sync(uint112 reserve0, uint112 reserve1);
230 
231     function MINIMUM_LIQUIDITY() external pure returns (uint);
232     function factory() external view returns (address);
233     function token0() external view returns (address);
234     function token1() external view returns (address);
235     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
236     function price0CumulativeLast() external view returns (uint);
237     function price1CumulativeLast() external view returns (uint);
238     function kLast() external view returns (uint);
239 
240     function burn(address to) external returns (uint amount0, uint amount1);
241     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
242     function skim(address to) external;
243     function sync() external;
244 
245     function initialize(address, address) external;
246 }
247 
248 interface IUniswapV2Router01 {
249     function factory() external pure returns (address);
250     function WETH() external pure returns (address);
251 
252     function addLiquidity(
253         address tokenA,
254         address tokenB,
255         uint amountADesired,
256         uint amountBDesired,
257         uint amountAMin,
258         uint amountBMin,
259         address to,
260         uint deadline
261     ) external returns (uint amountA, uint amountB, uint liquidity);
262     function addLiquidityETH(
263         address token,
264         uint amountTokenDesired,
265         uint amountTokenMin,
266         uint amountETHMin,
267         address to,
268         uint deadline
269     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
270     function removeLiquidity(
271         address tokenA,
272         address tokenB,
273         uint liquidity,
274         uint amountAMin,
275         uint amountBMin,
276         address to,
277         uint deadline
278     ) external returns (uint amountA, uint amountB);
279     function removeLiquidityETH(
280         address token,
281         uint liquidity,
282         uint amountTokenMin,
283         uint amountETHMin,
284         address to,
285         uint deadline
286     ) external returns (uint amountToken, uint amountETH);
287     function removeLiquidityWithPermit(
288         address tokenA,
289         address tokenB,
290         uint liquidity,
291         uint amountAMin,
292         uint amountBMin,
293         address to,
294         uint deadline,
295         bool approveMax, uint8 v, bytes32 r, bytes32 s
296     ) external returns (uint amountA, uint amountB);
297     function removeLiquidityETHWithPermit(
298         address token,
299         uint liquidity,
300         uint amountTokenMin,
301         uint amountETHMin,
302         address to,
303         uint deadline,
304         bool approveMax, uint8 v, bytes32 r, bytes32 s
305     ) external returns (uint amountToken, uint amountETH);
306     function swapExactTokensForTokens(
307         uint amountIn,
308         uint amountOutMin,
309         address[] calldata path,
310         address to,
311         uint deadline
312     ) external returns (uint[] memory amounts);
313     function swapTokensForExactTokens(
314         uint amountOut,
315         uint amountInMax,
316         address[] calldata path,
317         address to,
318         uint deadline
319     ) external returns (uint[] memory amounts);
320     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
321         external
322         payable
323         returns (uint[] memory amounts);
324     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
325         external
326         returns (uint[] memory amounts);
327     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
328         external
329         returns (uint[] memory amounts);
330     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
331         external
332         payable
333         returns (uint[] memory amounts);
334 
335     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
336     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
337     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
338     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
339     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
340 }
341 
342 interface IUniswapV2Router02 is IUniswapV2Router01 {
343     function removeLiquidityETHSupportingFeeOnTransferTokens(
344         address token,
345         uint liquidity,
346         uint amountTokenMin,
347         uint amountETHMin,
348         address to,
349         uint deadline
350     ) external returns (uint amountETH);
351     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
352         address token,
353         uint liquidity,
354         uint amountTokenMin,
355         uint amountETHMin,
356         address to,
357         uint deadline,
358         bool approveMax, uint8 v, bytes32 r, bytes32 s
359     ) external returns (uint amountETH);
360 
361     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
362         uint amountIn,
363         uint amountOutMin,
364         address[] calldata path,
365         address to,
366         uint deadline
367     ) external;
368     function swapExactETHForTokensSupportingFeeOnTransferTokens(
369         uint amountOutMin,
370         address[] calldata path,
371         address to,
372         uint deadline
373     ) external payable;
374     function swapExactTokensForETHSupportingFeeOnTransferTokens(
375         uint amountIn,
376         uint amountOutMin,
377         address[] calldata path,
378         address to,
379         uint deadline
380     ) external;
381 }
382 
383 
384 contract BlazeBurnt is Context, IERC20, Ownable {
385     
386     using SafeMath for uint256;
387     using Address for address;
388 
389     // Burn Stats
390 
391     uint256 public totalBurned = 0;
392     uint256 public totalBurnRewards = 0;
393 
394     uint256 public burnCapDivisor = 10; // Divisor for burn reward cap per tx
395     uint256 public burnSub1EthCap = 100000000000000000; // cap in gwei if rewards < 1 Eth
396     
397     string private _name = "Blaze Burnt";
398     string private _symbol = "BLAZE";
399     uint8 private _decimals = 18;
400     mapping (address => uint256) _balances;
401     mapping (address => mapping (address => uint256)) private _allowances;
402 
403     address payable private devMarketingWallet = payable(0xaF8FfB93F60Ba1c1C7Ed22a74c65F53c0aaa4CA1);
404     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
405 
406     uint256 public _buyLiquidityFees = 4;
407     uint256 public _buyDevFees = 45;
408     uint256 public _buyBurnFees = 45;
409     uint256 public _sellLiquidityFees = 4;
410     uint256 public _sellDevFees = 45;
411     uint256 public _sellBurnFees = 45;
412 
413     uint256 public _liquidityShares = 1;
414     uint256 public _devShares = 3;
415     uint256 public _burnShares = 4;
416 
417     uint256 public _totalTaxIfBuying = 94;
418     uint256 public _totalTaxIfSelling = 94;
419     uint256 public _totalDistributionShares = 8;
420 
421     // Fees / MaxWallet / TxLimit exemption mappings
422     
423     mapping (address => bool) public checkExcludedFromFees;
424     mapping (address => bool) public checkWalletLimitExcept;
425     mapping (address => bool) public checkTxLimitExcept;
426     mapping (address => bool) public checkMarketPair;
427 
428     // Supply / Max Tx tokenomics
429 
430     uint256 private _totalSupply = 100 * 10**6 * 10**18;
431     uint256 public _maxTxAmount = 1 * 10**6 * 10**18;
432     uint256 public _walletMax = 2 * 10**6 * 10**18;
433     uint256 private minimumTokensBeforeSwap = 2 * 10**5 * 10**18;
434 
435     IUniswapV2Router02 public uniswapV2Router;
436     address public uniswapPair;
437 
438     // Swap and liquify flags (for taxes)
439     
440     bool inSwapAndLiquify;
441     bool public swapAndLiquifyEnabled = true;
442     bool public swapAndLiquifyByLimitOnly = false;
443     bool public checkWalletLimit = true;
444 
445     // events & modifiers
446 
447     event BurnedTokensForEth (
448         address account,
449         uint256 burnAmount,
450         uint256 ethRecievedAmount
451     );
452 
453 
454     event SwapAndLiquifyEnabledUpdated(bool enabled);
455     event SwapAndLiquify(
456         uint256 tokensSwapped,
457         uint256 ethReceived,
458         uint256 tokensIntoLiqudity
459     );
460     
461     event SwapETHForTokens(
462         uint256 amountIn,
463         address[] path
464     );
465     
466     event SwapTokensForETH(
467         uint256 amountIn,
468         address[] path
469     );
470     
471     modifier lockTheSwap {
472         inSwapAndLiquify = true;
473         _;
474         inSwapAndLiquify = false;
475     }
476     
477 constructor () {
478         
479         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
480 
481         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
482             .createPair(address(this), _uniswapV2Router.WETH());
483 
484         uniswapV2Router = _uniswapV2Router;
485         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
486 
487         checkExcludedFromFees[owner()] = true;
488         checkExcludedFromFees[address(this)] = true;
489         
490         _totalTaxIfBuying = _buyLiquidityFees.add(_buyDevFees).add(_buyBurnFees);
491         _totalTaxIfSelling = _sellLiquidityFees.add(_sellDevFees).add(_sellBurnFees);
492         _totalDistributionShares = _liquidityShares.add(_devShares).add(_burnShares);
493 
494         checkWalletLimitExcept[owner()] = true;
495         checkWalletLimitExcept[address(uniswapPair)] = true;
496         checkWalletLimitExcept[address(this)] = true;
497         
498         checkTxLimitExcept[owner()] = true;
499         checkTxLimitExcept[address(this)] = true;
500 
501         checkMarketPair[address(uniswapPair)] = true;
502 
503         _balances[_msgSender()] = _totalSupply;
504         emit Transfer(address(0), _msgSender(), _totalSupply);
505     }
506 
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510 
511 
512         uint256 accountBalance = _balances[account];
513         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
514         unchecked {
515             _balances[account] = accountBalance - amount;
516         }
517         _totalSupply -= amount;
518 
519         emit Transfer(account, address(0), amount);
520 
521     }
522 
523     function name() public view  returns (string memory) {
524         return _name;
525     }
526 
527     function symbol() public view  returns (string memory) {
528         return _symbol;
529     }
530 
531     function decimals() public view  returns (uint8) {
532         return _decimals;
533     }
534 
535     function totalSupply() public view override returns (uint256) {
536         return _totalSupply;
537     }
538 
539     function balanceOf(address account) public view override returns (uint256) {
540         return _balances[account];
541     }
542 
543     function allowance(address owner, address spender) public view override returns (uint256) {
544         return _allowances[owner][spender];
545     }
546 
547     function increaseAllowance(address spender, uint256 addedValue) public virtual  returns (bool) {
548         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
549         return true;
550     }
551 
552     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual  returns (bool) {
553         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
554         return true;
555     }
556 
557     function approve(address spender, uint256 amount) public override returns (bool) {
558         _approve(_msgSender(), spender, amount);
559         return true;
560     }
561 
562     function _approve(address owner, address spender, uint256 amount) internal virtual  {
563         require(owner != address(0), "ERC20: approve from the zero address");
564         require(spender != address(0), "ERC20: approve to the zero address");
565 
566         _allowances[owner][spender] = amount;
567         emit Approval(owner, spender, amount);
568     }
569 
570     function addMarketPair(address account) public onlyOwner {
571         checkMarketPair[account] = true;
572     }
573 
574     function setcheckTxLimitExcept(address holder, bool exempt) external onlyOwner {
575         checkTxLimitExcept[holder] = exempt;
576     }
577     
578     function setcheckExcludedFromFees(address account, bool newValue) public onlyOwner {
579         checkExcludedFromFees[account] = newValue;
580     }
581 
582     function setBuyFee(uint256 newLiquidityTax, uint256 newDevTax, uint256 newBurnTax) external onlyOwner() {
583     require(
584         newLiquidityTax.add(newDevTax).add(newBurnTax) <= 40,
585         "Total fees must be less than or equal to 40%"
586     );
587         _buyLiquidityFees = newLiquidityTax;
588         _buyDevFees = newDevTax;
589         _buyBurnFees = newBurnTax;
590 
591         _totalTaxIfBuying = _buyLiquidityFees.add(_buyDevFees).add(_buyBurnFees);
592     }
593 
594     function setSellFee(uint256 newLiquidityTax, uint256 newDevTax, uint256 newBurnTax) external onlyOwner() {
595     require(
596         newLiquidityTax.add(newDevTax).add(newBurnTax) <= 40,
597         "Total fees must be less than or equal to 40%"
598     );
599         _sellLiquidityFees = newLiquidityTax;
600         _sellDevFees = newDevTax;
601         _sellBurnFees = newBurnTax;
602 
603         _totalTaxIfSelling = _sellLiquidityFees.add(_sellDevFees).add(_sellBurnFees);
604     }
605     
606     function setDistributionSettings(uint256 newLiquidityShare, uint256 newDevShare, uint256 newBurnShare) external onlyOwner() {
607         _liquidityShares = newLiquidityShare;
608         _devShares = newDevShare;
609         _burnShares = newBurnShare;
610 
611         _totalDistributionShares = _liquidityShares.add(_devShares).add(_burnShares);
612     }
613     
614     function adjustMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
615         require(maxTxAmount <= (100 * 10**6 * 10**18), "Max wallet should be less");
616         _maxTxAmount = maxTxAmount;
617     }
618 
619     function enableDisableWalletLimit(bool newValue) external onlyOwner {
620        checkWalletLimit = newValue;
621     }
622 
623     function setcheckWalletLimitExcept(address holder, bool exempt) external onlyOwner {
624         checkWalletLimitExcept[holder] = exempt;
625     }
626 
627     function setWalletLimit(uint256 newLimit) external onlyOwner {
628         _walletMax  = newLimit;
629     }
630 
631     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
632         minimumTokensBeforeSwap = newLimit;
633     }
634 
635     function setDevMarketingWallet(address newAddress) external onlyOwner() {
636         devMarketingWallet = payable(newAddress);
637     }
638 
639 
640     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
641         swapAndLiquifyEnabled = _enabled;
642         emit SwapAndLiquifyEnabledUpdated(_enabled);
643     }
644 
645     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
646         swapAndLiquifyByLimitOnly = newValue;
647     }
648     
649     function getCirculatingSupply() public view returns (uint256) {
650         return _totalSupply.sub(balanceOf(deadAddress));
651     }
652 
653     function transferToAddressETH(address payable recipient, uint256 amount) private {
654         recipient.transfer(amount);
655     }
656 
657      //to recieve ETH from uniswapV2Router when swapping
658     receive() external payable {}
659 
660     // msg.sender burns tokens and recieve uniswap rate TAX FREE, instead of selling.
661     function burnForEth(uint256 amount) public returns (bool) {
662         require(balanceOf(_msgSender()) >= amount, "not enough funds to burn");
663 
664         address[] memory path = new address[](2);
665         path[0] = address(this);
666         path[1] = uniswapV2Router.WETH();
667 
668         uint[] memory a = uniswapV2Router.getAmountsOut(amount, path);
669 
670         uint256 cap;
671         if (address(this).balance <= 1 ether) {
672             cap = burnSub1EthCap;
673         } else {
674             cap = address(this).balance / burnCapDivisor;
675         }
676 
677         require(a[a.length - 1] <= cap, "amount greater than cap");
678         require(address(this).balance >= a[a.length - 1], "not enough funds in contract");
679 
680         transferToAddressETH(_msgSender(), a[a.length - 1]);
681         _burn(_msgSender(), amount);
682         
683         totalBurnRewards += a[a.length - 1];
684         totalBurned += amount;
685 
686         emit BurnedTokensForEth(_msgSender(), amount, a[a.length - 1]);
687         return true;
688     }
689 
690     function transfer(address recipient, uint256 amount) public override returns (bool) {
691         _transfer(_msgSender(), recipient, amount);
692         return true;
693     }
694 
695     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
696         _transfer(sender, recipient, amount);
697         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
698         return true;
699     }
700 
701     function _transfer(address sender, address recipient, uint256 amount) internal virtual  {
702 
703         require(sender != address(0), "ERC20: transfer from the zero address");
704         require(recipient != address(0), "ERC20: transfer to the zero address");
705 
706         if(inSwapAndLiquify)
707         { 
708             _basicTransfer(sender, recipient, amount); 
709         }
710         else
711         {
712             if(!checkTxLimitExcept[sender] && !checkTxLimitExcept[recipient]) {
713                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
714             }            
715 
716             uint256 contractTokenBalance = balanceOf(address(this));
717             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
718             
719             if (overMinimumTokenBalance && !inSwapAndLiquify && !checkMarketPair[sender] && swapAndLiquifyEnabled) 
720             {
721                 if(swapAndLiquifyByLimitOnly)
722                     contractTokenBalance = minimumTokensBeforeSwap;
723                 swapAndLiquify(contractTokenBalance);    
724             }
725 
726             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
727 
728             uint256 finalAmount = (checkExcludedFromFees[sender] || checkExcludedFromFees[recipient]) ? 
729                                          amount : takeFee(sender, recipient, amount);
730 
731             if(checkWalletLimit && !checkWalletLimitExcept[recipient])
732                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
733 
734             _balances[recipient] = _balances[recipient].add(finalAmount);
735 
736             emit Transfer(sender, recipient, finalAmount);
737 
738         }
739     }
740 
741     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
742         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
743         _balances[recipient] = _balances[recipient].add(amount);
744         emit Transfer(sender, recipient, amount);
745         return true;
746     }
747 
748     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
749         
750         uint256 ethBalanceBeforeSwap = address(this).balance;
751         uint256 tokensForLP = tAmount.mul(_liquidityShares).div(_totalDistributionShares).div(2);
752         uint256 tokensForSwap = tAmount.sub(tokensForLP);
753 
754         swapTokensForEth(tokensForSwap);
755         uint256 amountReceived = address(this).balance.sub(ethBalanceBeforeSwap);
756 
757         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShares.div(2));
758         
759         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShares).div(totalETHFee).div(2);
760         uint256 amountETHBurn = amountReceived.mul(_burnShares).div(totalETHFee);
761         uint256 amountETHDev = amountReceived.sub(amountETHLiquidity).sub(amountETHBurn);
762 
763         if(amountETHDev > 0)
764             transferToAddressETH(devMarketingWallet, amountETHDev);
765 
766 
767         if(amountETHLiquidity > 0 && tokensForLP > 0)
768             addLiquidity(tokensForLP, amountETHLiquidity);
769     }
770 
771     function withdrawETH() external onlyOwner {
772         address payable _owner = payable(msg.sender);
773         _owner.transfer(address(this).balance);
774     }
775     
776     function swapTokensForEth(uint256 tokenAmount) private {
777         // generate the uniswap pair path of token -> weth
778         address[] memory path = new address[](2);
779         path[0] = address(this);
780         path[1] = uniswapV2Router.WETH();
781 
782         _approve(address(this), address(uniswapV2Router), tokenAmount);
783 
784         // make the swap
785         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
786             tokenAmount,
787             0, // accept any amount of ETH
788             path,
789             address(this), // The contract
790             block.timestamp
791         );
792         
793         emit SwapTokensForETH(tokenAmount, path);
794     }
795 
796     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
797         // approve token transfer to cover all possible scenarios
798         _approve(address(this), address(uniswapV2Router), tokenAmount);
799 
800         // add the liquidity
801         uniswapV2Router.addLiquidityETH{value: ethAmount}(
802             address(this),
803             tokenAmount,
804             0, // slippage is unavoidable
805             0, // slippage is unavoidable
806             owner(),
807             block.timestamp
808         );
809     }
810 
811     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
812         
813         uint256 feeAmount = 0;
814         
815         if(checkMarketPair[sender]) {
816             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
817         }
818         else if(checkMarketPair[recipient]) {
819             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
820         }
821         
822         if(feeAmount > 0) {
823             _balances[address(this)] = _balances[address(this)].add(feeAmount);
824             emit Transfer(sender, address(this), feeAmount);
825         }
826 
827         return amount.sub(feeAmount);
828     }
829 
830     function getStats() public view returns (uint256, uint256, uint256) {
831         return (totalBurned, totalBurnRewards, address(this).balance);
832     }
833 }