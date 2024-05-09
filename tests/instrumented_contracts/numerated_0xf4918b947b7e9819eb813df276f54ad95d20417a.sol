1 // SPDX-License-Identifier: Unlicensed
2 
3 // https://cindr.app/
4 // https://t.me/CINDRERC
5 // https://twitter.com/CINDRtoken
6 
7 pragma solidity ^0.8.4;
8 
9 
10 
11 abstract contract Context {
12 
13     function _msgSender() internal view virtual returns (address payable) {
14         return payable(msg.sender);
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24 
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 
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
380 
381 contract CINDR is Context, IERC20, Ownable {
382     
383     using SafeMath for uint256;
384     using Address for address;
385 
386     // Burn Stats
387 
388     uint256 public totalBurned = 0;
389     uint256 public totalBurnRewards = 0;
390 
391     uint256 public burnCapDivisor = 10; // Divisor for burn reward cap per tx
392     uint256 public burnSub1EthCap = 100000000000000000; // cap in gwei if rewards < 1 Eth
393     
394     string private _name = "CINDR";
395     string private _symbol = "CINDR";
396     uint8 private _decimals = 18;
397     mapping (address => uint256) _balances;
398     mapping (address => mapping (address => uint256)) private _allowances;
399 
400     address payable private devMarketingWallet = payable(0x0d3e82653e1ca20aaCe2F502A8588CA17ae0fF7c);
401     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
402 
403     uint256 public _buyLiquidityFees = 4;
404     uint256 public _buyDevFees = 45;
405     uint256 public _buyBurnFees = 45;
406     uint256 public _sellLiquidityFees = 4;
407     uint256 public _sellDevFees = 45;
408     uint256 public _sellBurnFees = 45;
409 
410     uint256 public _liquidityShares = 1;
411     uint256 public _devShares = 3;
412     uint256 public _burnShares = 4;
413 
414     uint256 public _totalTaxIfBuying = 94;
415     uint256 public _totalTaxIfSelling = 94;
416     uint256 public _totalDistributionShares = 8;
417 
418     // Fees / MaxWallet / TxLimit exemption mappings
419     
420     mapping (address => bool) public checkExcludedFromFees;
421     mapping (address => bool) public checkWalletLimitExcept;
422     mapping (address => bool) public checkTxLimitExcept;
423     mapping (address => bool) public checkMarketPair;
424 
425     // Supply / Max Tx tokenomics
426 
427     uint256 private _totalSupply = 100 * 10**6 * 10**18;
428     uint256 public _maxTxAmount = 1 * 10**6 * 10**18;
429     uint256 public _walletMax = 2 * 10**6 * 10**18;
430     uint256 private minimumTokensBeforeSwap = 2 * 10**5 * 10**18;
431 
432     IUniswapV2Router02 public uniswapV2Router;
433     address public uniswapPair;
434 
435     // Swap and liquify flags (for taxes)
436     
437     bool inSwapAndLiquify;
438     bool public swapAndLiquifyEnabled = true;
439     bool public swapAndLiquifyByLimitOnly = false;
440     bool public checkWalletLimit = true;
441 
442     // events & modifiers
443 
444     event BurnedTokensForEth (
445         address account,
446         uint256 burnAmount,
447         uint256 ethRecievedAmount
448     );
449 
450 
451     event SwapAndLiquifyEnabledUpdated(bool enabled);
452     event SwapAndLiquify(
453         uint256 tokensSwapped,
454         uint256 ethReceived,
455         uint256 tokensIntoLiqudity
456     );
457     
458     event SwapETHForTokens(
459         uint256 amountIn,
460         address[] path
461     );
462     
463     event SwapTokensForETH(
464         uint256 amountIn,
465         address[] path
466     );
467     
468     modifier lockTheSwap {
469         inSwapAndLiquify = true;
470         _;
471         inSwapAndLiquify = false;
472     }
473     
474 constructor () {
475         
476         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
477 
478         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
479             .createPair(address(this), _uniswapV2Router.WETH());
480 
481         uniswapV2Router = _uniswapV2Router;
482         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
483 
484         checkExcludedFromFees[owner()] = true;
485         checkExcludedFromFees[address(this)] = true;
486         
487         _totalTaxIfBuying = _buyLiquidityFees.add(_buyDevFees).add(_buyBurnFees);
488         _totalTaxIfSelling = _sellLiquidityFees.add(_sellDevFees).add(_sellBurnFees);
489         _totalDistributionShares = _liquidityShares.add(_devShares).add(_burnShares);
490 
491         checkWalletLimitExcept[owner()] = true;
492         checkWalletLimitExcept[address(uniswapPair)] = true;
493         checkWalletLimitExcept[address(this)] = true;
494         
495         checkTxLimitExcept[owner()] = true;
496         checkTxLimitExcept[address(this)] = true;
497 
498         checkMarketPair[address(uniswapPair)] = true;
499 
500         _balances[_msgSender()] = _totalSupply;
501         emit Transfer(address(0), _msgSender(), _totalSupply);
502     }
503 
504     function _burn(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: burn from the zero address");
506 
507 
508 
509         uint256 accountBalance = _balances[account];
510         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
511         unchecked {
512             _balances[account] = accountBalance - amount;
513         }
514         _totalSupply -= amount;
515 
516         emit Transfer(account, address(0), amount);
517 
518     }
519 
520     function name() public view  returns (string memory) {
521         return _name;
522     }
523 
524     function symbol() public view  returns (string memory) {
525         return _symbol;
526     }
527 
528     function decimals() public view  returns (uint8) {
529         return _decimals;
530     }
531 
532     function totalSupply() public view override returns (uint256) {
533         return _totalSupply;
534     }
535 
536     function balanceOf(address account) public view override returns (uint256) {
537         return _balances[account];
538     }
539 
540     function allowance(address owner, address spender) public view override returns (uint256) {
541         return _allowances[owner][spender];
542     }
543 
544     function increaseAllowance(address spender, uint256 addedValue) public virtual  returns (bool) {
545         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
546         return true;
547     }
548 
549     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual  returns (bool) {
550         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
551         return true;
552     }
553 
554     function approve(address spender, uint256 amount) public override returns (bool) {
555         _approve(_msgSender(), spender, amount);
556         return true;
557     }
558 
559     function _approve(address owner, address spender, uint256 amount) internal virtual  {
560         require(owner != address(0), "ERC20: approve from the zero address");
561         require(spender != address(0), "ERC20: approve to the zero address");
562 
563         _allowances[owner][spender] = amount;
564         emit Approval(owner, spender, amount);
565     }
566 
567     function addMarketPair(address account) public onlyOwner {
568         checkMarketPair[account] = true;
569     }
570 
571     function setcheckTxLimitExcept(address holder, bool exempt) external onlyOwner {
572         checkTxLimitExcept[holder] = exempt;
573     }
574     
575     function setcheckExcludedFromFees(address account, bool newValue) public onlyOwner {
576         checkExcludedFromFees[account] = newValue;
577     }
578 
579     function setBuyFee(uint256 newLiquidityTax, uint256 newDevTax, uint256 newBurnTax) external onlyOwner() {
580         _buyLiquidityFees = newLiquidityTax;
581         _buyDevFees = newDevTax;
582         _buyBurnFees = newBurnTax;
583 
584         _totalTaxIfBuying = _buyLiquidityFees.add(_buyDevFees).add(_buyBurnFees);
585     }
586 
587     function setSellFee(uint256 newLiquidityTax, uint256 newDevTax, uint256 newBurnTax) external onlyOwner() {
588         _sellLiquidityFees = newLiquidityTax;
589         _sellDevFees = newDevTax;
590         _sellBurnFees = newBurnTax;
591 
592         _totalTaxIfSelling = _sellLiquidityFees.add(_sellDevFees).add(_sellBurnFees);
593     }
594     
595     function setDistributionSettings(uint256 newLiquidityShare, uint256 newDevShare, uint256 newBurnShare) external onlyOwner() {
596         _liquidityShares = newLiquidityShare;
597         _devShares = newDevShare;
598         _burnShares = newBurnShare;
599 
600         _totalDistributionShares = _liquidityShares.add(_devShares).add(_burnShares);
601     }
602     
603     function adjustMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
604         require(maxTxAmount <= (100 * 10**6 * 10**18), "Max wallet should be less");
605         _maxTxAmount = maxTxAmount;
606     }
607 
608     function enableDisableWalletLimit(bool newValue) external onlyOwner {
609        checkWalletLimit = newValue;
610     }
611 
612     function setcheckWalletLimitExcept(address holder, bool exempt) external onlyOwner {
613         checkWalletLimitExcept[holder] = exempt;
614     }
615 
616     function setWalletLimit(uint256 newLimit) external onlyOwner {
617         _walletMax  = newLimit;
618     }
619 
620     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
621         minimumTokensBeforeSwap = newLimit;
622     }
623 
624     function setDevMarketingWallet(address newAddress) external onlyOwner() {
625         devMarketingWallet = payable(newAddress);
626     }
627 
628 
629     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
630         swapAndLiquifyEnabled = _enabled;
631         emit SwapAndLiquifyEnabledUpdated(_enabled);
632     }
633 
634     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
635         swapAndLiquifyByLimitOnly = newValue;
636     }
637     
638     function getCirculatingSupply() public view returns (uint256) {
639         return _totalSupply.sub(balanceOf(deadAddress));
640     }
641 
642     function transferToAddressETH(address payable recipient, uint256 amount) private {
643         recipient.transfer(amount);
644     }
645 
646      //to recieve ETH from uniswapV2Router when swapping
647     receive() external payable {}
648 
649     // msg.sender burns tokens and recieve uniswap rate TAX FREE, instead of selling.
650     function burnForEth(uint256 amount) public returns (bool) {
651         require(balanceOf(_msgSender()) >= amount, "not enough funds to burn");
652 
653         address[] memory path = new address[](2);
654         path[0] = address(this);
655         path[1] = uniswapV2Router.WETH();
656 
657         uint[] memory a = uniswapV2Router.getAmountsOut(amount, path);
658 
659         uint256 cap;
660         if (address(this).balance <= 1 ether) {
661             cap = burnSub1EthCap;
662         } else {
663             cap = address(this).balance / burnCapDivisor;
664         }
665 
666         require(a[a.length - 1] <= cap, "amount greater than cap");
667         require(address(this).balance >= a[a.length - 1], "not enough funds in contract");
668 
669         transferToAddressETH(_msgSender(), a[a.length - 1]);
670         _burn(_msgSender(), amount);
671         
672         totalBurnRewards += a[a.length - 1];
673         totalBurned += amount;
674 
675         emit BurnedTokensForEth(_msgSender(), amount, a[a.length - 1]);
676         return true;
677     }
678 
679     function transfer(address recipient, uint256 amount) public override returns (bool) {
680         _transfer(_msgSender(), recipient, amount);
681         return true;
682     }
683 
684     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
685         _transfer(sender, recipient, amount);
686         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
687         return true;
688     }
689 
690     function _transfer(address sender, address recipient, uint256 amount) internal virtual  {
691 
692         require(sender != address(0), "ERC20: transfer from the zero address");
693         require(recipient != address(0), "ERC20: transfer to the zero address");
694 
695         if(inSwapAndLiquify)
696         { 
697             _basicTransfer(sender, recipient, amount); 
698         }
699         else
700         {
701             if(!checkTxLimitExcept[sender] && !checkTxLimitExcept[recipient]) {
702                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
703             }            
704 
705             uint256 contractTokenBalance = balanceOf(address(this));
706             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
707             
708             if (overMinimumTokenBalance && !inSwapAndLiquify && !checkMarketPair[sender] && swapAndLiquifyEnabled) 
709             {
710                 if(swapAndLiquifyByLimitOnly)
711                     contractTokenBalance = minimumTokensBeforeSwap;
712                 swapAndLiquify(contractTokenBalance);    
713             }
714 
715             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
716 
717             uint256 finalAmount = (checkExcludedFromFees[sender] || checkExcludedFromFees[recipient]) ? 
718                                          amount : takeFee(sender, recipient, amount);
719 
720             if(checkWalletLimit && !checkWalletLimitExcept[recipient])
721                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
722 
723             _balances[recipient] = _balances[recipient].add(finalAmount);
724 
725             emit Transfer(sender, recipient, finalAmount);
726 
727         }
728     }
729 
730     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
731         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
732         _balances[recipient] = _balances[recipient].add(amount);
733         emit Transfer(sender, recipient, amount);
734         return true;
735     }
736 
737     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
738         
739         uint256 ethBalanceBeforeSwap = address(this).balance;
740         uint256 tokensForLP = tAmount.mul(_liquidityShares).div(_totalDistributionShares).div(2);
741         uint256 tokensForSwap = tAmount.sub(tokensForLP);
742 
743         swapTokensForEth(tokensForSwap);
744         uint256 amountReceived = address(this).balance.sub(ethBalanceBeforeSwap);
745 
746         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShares.div(2));
747         
748         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShares).div(totalETHFee).div(2);
749         uint256 amountETHBurn = amountReceived.mul(_burnShares).div(totalETHFee);
750         uint256 amountETHDev = amountReceived.sub(amountETHLiquidity).sub(amountETHBurn);
751 
752         if(amountETHDev > 0)
753             transferToAddressETH(devMarketingWallet, amountETHDev);
754 
755 
756         if(amountETHLiquidity > 0 && tokensForLP > 0)
757             addLiquidity(tokensForLP, amountETHLiquidity);
758     }
759 
760     
761     function swapTokensForEth(uint256 tokenAmount) private {
762         // generate the uniswap pair path of token -> weth
763         address[] memory path = new address[](2);
764         path[0] = address(this);
765         path[1] = uniswapV2Router.WETH();
766 
767         _approve(address(this), address(uniswapV2Router), tokenAmount);
768 
769         // make the swap
770         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
771             tokenAmount,
772             0, // accept any amount of ETH
773             path,
774             address(this), // The contract
775             block.timestamp
776         );
777         
778         emit SwapTokensForETH(tokenAmount, path);
779     }
780 
781     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
782         // approve token transfer to cover all possible scenarios
783         _approve(address(this), address(uniswapV2Router), tokenAmount);
784 
785         // add the liquidity
786         uniswapV2Router.addLiquidityETH{value: ethAmount}(
787             address(this),
788             tokenAmount,
789             0, // slippage is unavoidable
790             0, // slippage is unavoidable
791             owner(),
792             block.timestamp
793         );
794     }
795 
796     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
797         
798         uint256 feeAmount = 0;
799         
800         if(checkMarketPair[sender]) {
801             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
802         }
803         else if(checkMarketPair[recipient]) {
804             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
805         }
806         
807         if(feeAmount > 0) {
808             _balances[address(this)] = _balances[address(this)].add(feeAmount);
809             emit Transfer(sender, address(this), feeAmount);
810         }
811 
812         return amount.sub(feeAmount);
813     }
814 
815     function getStats() public view returns (uint256, uint256, uint256) {
816         return (totalBurned, totalBurnRewards, address(this).balance);
817     }
818 }