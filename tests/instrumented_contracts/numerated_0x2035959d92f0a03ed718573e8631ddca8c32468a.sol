1 // SPDX-License-Identifier: MIT
2 /**
3 
4 WELCOME TO $BONFIRE
5 ADVANCED BURNENOMICS
6 
7 https://t.me/bonfireerc
8 https://x.com/bonfireerc
9 http://www.bonfireeth.com/
10 
11 
12 **/
13 
14 pragma solidity ^0.8.4;
15 
16 
17 
18 abstract contract Context {
19 
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
31 
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 
41 }
42 
43 library SafeMath {
44 
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82 
83         return c;
84     }
85 
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         return mod(a, b, "SafeMath: modulo by zero");
88     }
89 
90     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b != 0, errorMessage);
92         return a % b;
93     }
94 }
95 
96 library Address {
97 
98     function isContract(address account) internal view returns (bool) {
99         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
100         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
101         // for accounts without code, i.e. `keccak256('')`
102         bytes32 codehash;
103         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
104         // solhint-disable-next-line no-inline-assembly
105         assembly { codehash := extcodehash(account) }
106         return (codehash != accountHash && codehash != 0x0);
107     }
108 
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
113         (bool success, ) = recipient.call{ value: amount }("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118       return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         return _functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
138         if (success) {
139             return returndata;
140         } else {
141             
142             if (returndata.length > 0) {
143                 assembly {
144                     let returndata_size := mload(returndata)
145                     revert(add(32, returndata), returndata_size)
146                 }
147             } else {
148                 revert(errorMessage);
149             }
150         }
151     }
152 }
153 
154 contract Ownable is Context {
155     address private _owner;
156     address private _previousOwner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     constructor () {
161         address msgSender = _msgSender();
162         _owner = msgSender;
163         emit OwnershipTransferred(address(0), msgSender);
164     }
165 
166     function owner() public view returns (address) {
167         return _owner;
168     }   
169     
170     modifier onlyOwner() {
171         require(_owner == _msgSender(), "Ownable: caller is not the owner");
172         _;
173     }
174     
175     function waiveOwnership() public virtual onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 interface IUniswapV2Factory {
188     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
189 
190     function feeTo() external view returns (address);
191     function feeToSetter() external view returns (address);
192 
193     function getPair(address tokenA, address tokenB) external view returns (address pair);
194     function allPairs(uint) external view returns (address pair);
195     function allPairsLength() external view returns (uint);
196 
197     function createPair(address tokenA, address tokenB) external returns (address pair);
198 
199     function setFeeTo(address) external;
200     function setFeeToSetter(address) external;
201 }
202 
203 interface IUniswapV2Pair {
204     event Approval(address indexed owner, address indexed spender, uint value);
205     event Transfer(address indexed from, address indexed to, uint value);
206 
207     function name() external pure returns (string memory);
208     function symbol() external pure returns (string memory);
209     function decimals() external pure returns (uint8);
210     function totalSupply() external view returns (uint);
211     function balanceOf(address owner) external view returns (uint);
212     function allowance(address owner, address spender) external view returns (uint);
213 
214     function approve(address spender, uint value) external returns (bool);
215     function transfer(address to, uint value) external returns (bool);
216     function transferFrom(address from, address to, uint value) external returns (bool);
217 
218     function DOMAIN_SEPARATOR() external view returns (bytes32);
219     function PERMIT_TYPEHASH() external pure returns (bytes32);
220     function nonces(address owner) external view returns (uint);
221 
222     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
223     
224     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
225     event Swap(
226         address indexed sender,
227         uint amount0In,
228         uint amount1In,
229         uint amount0Out,
230         uint amount1Out,
231         address indexed to
232     );
233     event Sync(uint112 reserve0, uint112 reserve1);
234 
235     function MINIMUM_LIQUIDITY() external pure returns (uint);
236     function factory() external view returns (address);
237     function token0() external view returns (address);
238     function token1() external view returns (address);
239     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
240     function price0CumulativeLast() external view returns (uint);
241     function price1CumulativeLast() external view returns (uint);
242     function kLast() external view returns (uint);
243 
244     function burn(address to) external returns (uint amount0, uint amount1);
245     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
246     function skim(address to) external;
247     function sync() external;
248 
249     function initialize(address, address) external;
250 }
251 
252 interface IUniswapV2Router01 {
253     function factory() external pure returns (address);
254     function WETH() external pure returns (address);
255 
256     function addLiquidity(
257         address tokenA,
258         address tokenB,
259         uint amountADesired,
260         uint amountBDesired,
261         uint amountAMin,
262         uint amountBMin,
263         address to,
264         uint deadline
265     ) external returns (uint amountA, uint amountB, uint liquidity);
266     function addLiquidityETH(
267         address token,
268         uint amountTokenDesired,
269         uint amountTokenMin,
270         uint amountETHMin,
271         address to,
272         uint deadline
273     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
274     function removeLiquidity(
275         address tokenA,
276         address tokenB,
277         uint liquidity,
278         uint amountAMin,
279         uint amountBMin,
280         address to,
281         uint deadline
282     ) external returns (uint amountA, uint amountB);
283     function removeLiquidityETH(
284         address token,
285         uint liquidity,
286         uint amountTokenMin,
287         uint amountETHMin,
288         address to,
289         uint deadline
290     ) external returns (uint amountToken, uint amountETH);
291     function removeLiquidityWithPermit(
292         address tokenA,
293         address tokenB,
294         uint liquidity,
295         uint amountAMin,
296         uint amountBMin,
297         address to,
298         uint deadline,
299         bool approveMax, uint8 v, bytes32 r, bytes32 s
300     ) external returns (uint amountA, uint amountB);
301     function removeLiquidityETHWithPermit(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline,
308         bool approveMax, uint8 v, bytes32 r, bytes32 s
309     ) external returns (uint amountToken, uint amountETH);
310     function swapExactTokensForTokens(
311         uint amountIn,
312         uint amountOutMin,
313         address[] calldata path,
314         address to,
315         uint deadline
316     ) external returns (uint[] memory amounts);
317     function swapTokensForExactTokens(
318         uint amountOut,
319         uint amountInMax,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external returns (uint[] memory amounts);
324     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
325         external
326         payable
327         returns (uint[] memory amounts);
328     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
329         external
330         returns (uint[] memory amounts);
331     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
332         external
333         returns (uint[] memory amounts);
334     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
335         external
336         payable
337         returns (uint[] memory amounts);
338 
339     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
340     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
341     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
342     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
343     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
344 }
345 
346 interface IUniswapV2Router02 is IUniswapV2Router01 {
347     function removeLiquidityETHSupportingFeeOnTransferTokens(
348         address token,
349         uint liquidity,
350         uint amountTokenMin,
351         uint amountETHMin,
352         address to,
353         uint deadline
354     ) external returns (uint amountETH);
355     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
356         address token,
357         uint liquidity,
358         uint amountTokenMin,
359         uint amountETHMin,
360         address to,
361         uint deadline,
362         bool approveMax, uint8 v, bytes32 r, bytes32 s
363     ) external returns (uint amountETH);
364 
365     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
366         uint amountIn,
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external;
372     function swapExactETHForTokensSupportingFeeOnTransferTokens(
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline
377     ) external payable;
378     function swapExactTokensForETHSupportingFeeOnTransferTokens(
379         uint amountIn,
380         uint amountOutMin,
381         address[] calldata path,
382         address to,
383         uint deadline
384     ) external;
385 }
386 
387 
388 contract BONFIRE is Context, IERC20, Ownable {
389     
390     using SafeMath for uint256;
391     using Address for address;
392 
393     // Burn Stats
394 
395     uint256 public totalBurned = 0;
396     uint256 public totalBurnRewards = 0;
397 
398     uint256 public burnCapDivisor = 10; // Divisor for burn reward cap per tx
399     uint256 public burnSub1EthCap = 100000000000000000; // cap in gwei if rewards < 1 Eth
400     
401     string private _name = "Bonfire";
402     string private _symbol = "BONFIRE";
403     uint8 private _decimals = 18;
404     mapping (address => uint256) _balances;
405     mapping (address => mapping (address => uint256)) private _allowances;
406 
407     address payable private devMarketingWallet = payable(0xB136Bee36f67A90F5B37fa76a7aE7F91A36F34c1);
408     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
409 
410     uint256 public _buyLiquidityFees = 4;
411     uint256 public _buyDevFees = 45;
412     uint256 public _buyBurnFees = 45;
413     uint256 public _sellLiquidityFees = 4;
414     uint256 public _sellDevFees = 45;
415     uint256 public _sellBurnFees = 45;
416 
417     uint256 public _liquidityShares = 1;
418     uint256 public _devShares = 3;
419     uint256 public _burnShares = 4;
420 
421     uint256 public _totalTaxIfBuying = 94;
422     uint256 public _totalTaxIfSelling = 94;
423     uint256 public _totalDistributionShares = 8;
424 
425     // Fees / MaxWallet / TxLimit exemption mappings
426     
427     mapping (address => bool) public checkExcludedFromFees;
428     mapping (address => bool) public checkWalletLimitExcept;
429     mapping (address => bool) public checkTxLimitExcept;
430     mapping (address => bool) public checkMarketPair;
431 
432     // Supply / Max Tx tokenomics
433 
434     uint256 private _totalSupply = 100 * 10**6 * 10**18;
435     uint256 public _maxTxAmount = 1 * 10**6 * 10**18;
436     uint256 public _walletMax = 2 * 10**6 * 10**18;
437     uint256 private minimumTokensBeforeSwap = 2 * 10**5 * 10**18;
438 
439     IUniswapV2Router02 public uniswapV2Router;
440     address public uniswapPair;
441 
442     // Swap and liquify flags (for taxes)
443     
444     bool inSwapAndLiquify;
445     bool public swapAndLiquifyEnabled = true;
446     bool public swapAndLiquifyByLimitOnly = false;
447     bool public checkWalletLimit = true;
448 
449     // events & modifiers
450 
451     event BurnedTokensForEth (
452         address account,
453         uint256 burnAmount,
454         uint256 ethRecievedAmount
455     );
456 
457 
458     event SwapAndLiquifyEnabledUpdated(bool enabled);
459     event SwapAndLiquify(
460         uint256 tokensSwapped,
461         uint256 ethReceived,
462         uint256 tokensIntoLiqudity
463     );
464     
465     event SwapETHForTokens(
466         uint256 amountIn,
467         address[] path
468     );
469     
470     event SwapTokensForETH(
471         uint256 amountIn,
472         address[] path
473     );
474     
475     modifier lockTheSwap {
476         inSwapAndLiquify = true;
477         _;
478         inSwapAndLiquify = false;
479     }
480     
481 constructor () {
482         
483         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
484 
485         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
486             .createPair(address(this), _uniswapV2Router.WETH());
487 
488         uniswapV2Router = _uniswapV2Router;
489         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
490 
491         checkExcludedFromFees[owner()] = true;
492         checkExcludedFromFees[address(this)] = true;
493         
494         _totalTaxIfBuying = _buyLiquidityFees.add(_buyDevFees).add(_buyBurnFees);
495         _totalTaxIfSelling = _sellLiquidityFees.add(_sellDevFees).add(_sellBurnFees);
496         _totalDistributionShares = _liquidityShares.add(_devShares).add(_burnShares);
497 
498         checkWalletLimitExcept[owner()] = true;
499         checkWalletLimitExcept[address(uniswapPair)] = true;
500         checkWalletLimitExcept[address(this)] = true;
501         
502         checkTxLimitExcept[owner()] = true;
503         checkTxLimitExcept[address(this)] = true;
504 
505         checkMarketPair[address(uniswapPair)] = true;
506 
507         _balances[_msgSender()] = _totalSupply;
508         emit Transfer(address(0), _msgSender(), _totalSupply);
509     }
510 
511     function _burn(address account, uint256 amount) internal virtual {
512         require(account != address(0), "ERC20: burn from the zero address");
513 
514 
515 
516         uint256 accountBalance = _balances[account];
517         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
518         unchecked {
519             _balances[account] = accountBalance - amount;
520         }
521         _totalSupply -= amount;
522 
523         emit Transfer(account, address(0), amount);
524 
525     }
526 
527     function name() public view  returns (string memory) {
528         return _name;
529     }
530 
531     function symbol() public view  returns (string memory) {
532         return _symbol;
533     }
534 
535     function decimals() public view  returns (uint8) {
536         return _decimals;
537     }
538 
539     function totalSupply() public view override returns (uint256) {
540         return _totalSupply;
541     }
542 
543     function balanceOf(address account) public view override returns (uint256) {
544         return _balances[account];
545     }
546 
547     function allowance(address owner, address spender) public view override returns (uint256) {
548         return _allowances[owner][spender];
549     }
550 
551     function increaseAllowance(address spender, uint256 addedValue) public virtual  returns (bool) {
552         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
553         return true;
554     }
555 
556     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual  returns (bool) {
557         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
558         return true;
559     }
560 
561     function approve(address spender, uint256 amount) public override returns (bool) {
562         _approve(_msgSender(), spender, amount);
563         return true;
564     }
565 
566     function _approve(address owner, address spender, uint256 amount) internal virtual  {
567         require(owner != address(0), "ERC20: approve from the zero address");
568         require(spender != address(0), "ERC20: approve to the zero address");
569 
570         _allowances[owner][spender] = amount;
571         emit Approval(owner, spender, amount);
572     }
573 
574     function addMarketPair(address account) public onlyOwner {
575         checkMarketPair[account] = true;
576     }
577 
578     function setcheckTxLimitExcept(address holder, bool exempt) external onlyOwner {
579         checkTxLimitExcept[holder] = exempt;
580     }
581     
582     function setcheckExcludedFromFees(address account, bool newValue) public onlyOwner {
583         checkExcludedFromFees[account] = newValue;
584     }
585 
586     function setBuyFee(uint256 newLiquidityTax, uint256 newDevTax, uint256 newBurnTax) external onlyOwner() {
587         _buyLiquidityFees = newLiquidityTax;
588         _buyDevFees = newDevTax;
589         _buyBurnFees = newBurnTax;
590 
591         _totalTaxIfBuying = _buyLiquidityFees.add(_buyDevFees).add(_buyBurnFees);
592     }
593 
594     function setSellFee(uint256 newLiquidityTax, uint256 newDevTax, uint256 newBurnTax) external onlyOwner() {
595         _sellLiquidityFees = newLiquidityTax;
596         _sellDevFees = newDevTax;
597         _sellBurnFees = newBurnTax;
598 
599         _totalTaxIfSelling = _sellLiquidityFees.add(_sellDevFees).add(_sellBurnFees);
600     }
601     
602     function setDistributionSettings(uint256 newLiquidityShare, uint256 newDevShare, uint256 newBurnShare) external onlyOwner() {
603         _liquidityShares = newLiquidityShare;
604         _devShares = newDevShare;
605         _burnShares = newBurnShare;
606 
607         _totalDistributionShares = _liquidityShares.add(_devShares).add(_burnShares);
608     }
609     
610     function adjustMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
611         require(maxTxAmount <= (100 * 10**6 * 10**18), "Max wallet should be less");
612         _maxTxAmount = maxTxAmount;
613     }
614 
615     function enableDisableWalletLimit(bool newValue) external onlyOwner {
616        checkWalletLimit = newValue;
617     }
618 
619     function setcheckWalletLimitExcept(address holder, bool exempt) external onlyOwner {
620         checkWalletLimitExcept[holder] = exempt;
621     }
622 
623     function setWalletLimit(uint256 newLimit) external onlyOwner {
624         _walletMax  = newLimit;
625     }
626 
627     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
628         minimumTokensBeforeSwap = newLimit;
629     }
630 
631     function setDevMarketingWallet(address newAddress) external onlyOwner() {
632         devMarketingWallet = payable(newAddress);
633     }
634 
635 
636     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
637         swapAndLiquifyEnabled = _enabled;
638         emit SwapAndLiquifyEnabledUpdated(_enabled);
639     }
640 
641     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
642         swapAndLiquifyByLimitOnly = newValue;
643     }
644     
645     function getCirculatingSupply() public view returns (uint256) {
646         return _totalSupply.sub(balanceOf(deadAddress));
647     }
648 
649     function transferToAddressETH(address payable recipient, uint256 amount) private {
650         recipient.transfer(amount);
651     }
652 
653      //to recieve ETH from uniswapV2Router when swapping
654     receive() external payable {}
655 
656     // msg.sender burns tokens and recieve uniswap rate TAX FREE, instead of selling.
657     function burnForEth(uint256 amount) public returns (bool) {
658         require(balanceOf(_msgSender()) >= amount, "not enough funds to burn");
659 
660         address[] memory path = new address[](2);
661         path[0] = address(this);
662         path[1] = uniswapV2Router.WETH();
663 
664         uint[] memory a = uniswapV2Router.getAmountsOut(amount, path);
665 
666         uint256 cap;
667         if (address(this).balance <= 1 ether) {
668             cap = burnSub1EthCap;
669         } else {
670             cap = address(this).balance / burnCapDivisor;
671         }
672 
673         require(a[a.length - 1] <= cap, "amount greater than cap");
674         require(address(this).balance >= a[a.length - 1], "not enough funds in contract");
675 
676         transferToAddressETH(_msgSender(), a[a.length - 1]);
677         _burn(_msgSender(), amount);
678         
679         totalBurnRewards += a[a.length - 1];
680         totalBurned += amount;
681 
682         emit BurnedTokensForEth(_msgSender(), amount, a[a.length - 1]);
683         return true;
684     }
685 
686     function transfer(address recipient, uint256 amount) public override returns (bool) {
687         _transfer(_msgSender(), recipient, amount);
688         return true;
689     }
690 
691     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
692         _transfer(sender, recipient, amount);
693         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
694         return true;
695     }
696 
697     function _transfer(address sender, address recipient, uint256 amount) internal virtual  {
698 
699         require(sender != address(0), "ERC20: transfer from the zero address");
700         require(recipient != address(0), "ERC20: transfer to the zero address");
701 
702         if(inSwapAndLiquify)
703         { 
704             _basicTransfer(sender, recipient, amount); 
705         }
706         else
707         {
708             if(!checkTxLimitExcept[sender] && !checkTxLimitExcept[recipient]) {
709                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
710             }            
711 
712             uint256 contractTokenBalance = balanceOf(address(this));
713             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
714             
715             if (overMinimumTokenBalance && !inSwapAndLiquify && !checkMarketPair[sender] && swapAndLiquifyEnabled) 
716             {
717                 if(swapAndLiquifyByLimitOnly)
718                     contractTokenBalance = minimumTokensBeforeSwap;
719                 swapAndLiquify(contractTokenBalance);    
720             }
721 
722             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
723 
724             uint256 finalAmount = (checkExcludedFromFees[sender] || checkExcludedFromFees[recipient]) ? 
725                                          amount : takeFee(sender, recipient, amount);
726 
727             if(checkWalletLimit && !checkWalletLimitExcept[recipient])
728                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
729 
730             _balances[recipient] = _balances[recipient].add(finalAmount);
731 
732             emit Transfer(sender, recipient, finalAmount);
733 
734         }
735     }
736 
737     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
738         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
739         _balances[recipient] = _balances[recipient].add(amount);
740         emit Transfer(sender, recipient, amount);
741         return true;
742     }
743 
744     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
745         
746         uint256 ethBalanceBeforeSwap = address(this).balance;
747         uint256 tokensForLP = tAmount.mul(_liquidityShares).div(_totalDistributionShares).div(2);
748         uint256 tokensForSwap = tAmount.sub(tokensForLP);
749 
750         swapTokensForEth(tokensForSwap);
751         uint256 amountReceived = address(this).balance.sub(ethBalanceBeforeSwap);
752 
753         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShares.div(2));
754         
755         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShares).div(totalETHFee).div(2);
756         uint256 amountETHBurn = amountReceived.mul(_burnShares).div(totalETHFee);
757         uint256 amountETHDev = amountReceived.sub(amountETHLiquidity).sub(amountETHBurn);
758 
759         if(amountETHDev > 0)
760             transferToAddressETH(devMarketingWallet, amountETHDev);
761 
762 
763         if(amountETHLiquidity > 0 && tokensForLP > 0)
764             addLiquidity(tokensForLP, amountETHLiquidity);
765     }
766 
767     
768     function swapTokensForEth(uint256 tokenAmount) private {
769         // generate the uniswap pair path of token -> weth
770         address[] memory path = new address[](2);
771         path[0] = address(this);
772         path[1] = uniswapV2Router.WETH();
773 
774         _approve(address(this), address(uniswapV2Router), tokenAmount);
775 
776         // make the swap
777         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
778             tokenAmount,
779             0, // accept any amount of ETH
780             path,
781             address(this), // The contract
782             block.timestamp
783         );
784         
785         emit SwapTokensForETH(tokenAmount, path);
786     }
787 
788     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
789         // approve token transfer to cover all possible scenarios
790         _approve(address(this), address(uniswapV2Router), tokenAmount);
791 
792         // add the liquidity
793         uniswapV2Router.addLiquidityETH{value: ethAmount}(
794             address(this),
795             tokenAmount,
796             0, // slippage is unavoidable
797             0, // slippage is unavoidable
798             owner(),
799             block.timestamp
800         );
801     }
802 
803     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
804         
805         uint256 feeAmount = 0;
806         
807         if(checkMarketPair[sender]) {
808             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
809         }
810         else if(checkMarketPair[recipient]) {
811             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
812         }
813         
814         if(feeAmount > 0) {
815             _balances[address(this)] = _balances[address(this)].add(feeAmount);
816             emit Transfer(sender, address(this), feeAmount);
817         }
818 
819         return amount.sub(feeAmount);
820     }
821 
822     function getStats() public view returns (uint256, uint256, uint256) {
823         return (totalBurned, totalBurnRewards, address(this).balance);
824     }
825 }