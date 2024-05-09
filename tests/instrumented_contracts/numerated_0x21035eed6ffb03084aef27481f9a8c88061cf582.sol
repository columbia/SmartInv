1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
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
31 library SafeMath {
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58 
59         return c;
60     }
61 
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly { codehash := extcodehash(account) }
95         return (codehash != accountHash && codehash != 0x0);
96     }
97 
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success, ) = recipient.call{ value: amount }("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106 
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108         return functionCall(target, data, "Address: low-level call failed");
109     }
110 
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return _functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         return _functionCallWithValue(target, data, value, errorMessage);
122     }
123 
124     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
125         require(isContract(target), "Address: call to non-contract");
126 
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131 
132             if (returndata.length > 0) {
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143 
144 contract Ownable is Context {
145     address private _owner;
146     address private _previousOwner;
147     uint256 private _lockTime;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     constructor () {
152         address msgSender = _msgSender();
153         _owner = msgSender;
154         emit OwnershipTransferred(address(0), msgSender);
155     }
156 
157     function owner() public view returns (address) {
158         return _owner;
159     }
160 
161     modifier onlyOwner() {
162         require(_owner == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 
177     function getUnlockTime() public view returns (uint256) {
178         return _lockTime;
179     }
180 
181     function getTime() public view returns (uint256) {
182         return block.timestamp;
183     }
184 
185     function lock(uint256 time) public virtual onlyOwner {
186         _previousOwner = _owner;
187         _owner = address(0);
188         _lockTime = block.timestamp + time;
189         emit OwnershipTransferred(_owner, address(0));
190     }
191 
192     function unlock() public virtual {
193         require(_previousOwner == msg.sender, "You don't have permission to unlock");
194         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
195         emit OwnershipTransferred(_owner, _previousOwner);
196         _owner = _previousOwner;
197     }
198 }
199 
200 // pragma solidity >=0.5.0;
201 
202 interface IUniswapV2Factory {
203     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
204 
205     function feeTo() external view returns (address);
206     function feeToSetter() external view returns (address);
207 
208     function getPair(address tokenA, address tokenB) external view returns (address pair);
209     function allPairs(uint) external view returns (address pair);
210     function allPairsLength() external view returns (uint);
211 
212     function createPair(address tokenA, address tokenB) external returns (address pair);
213 
214     function setFeeTo(address) external;
215     function setFeeToSetter(address) external;
216 }
217 
218 
219 // pragma solidity >=0.5.0;
220 
221 interface IUniswapV2Pair {
222     event Approval(address indexed owner, address indexed spender, uint value);
223     event Transfer(address indexed from, address indexed to, uint value);
224 
225     function name() external pure returns (string memory);
226     function symbol() external pure returns (string memory);
227     function decimals() external pure returns (uint8);
228     function totalSupply() external view returns (uint);
229     function balanceOf(address owner) external view returns (uint);
230     function allowance(address owner, address spender) external view returns (uint);
231 
232     function approve(address spender, uint value) external returns (bool);
233     function transfer(address to, uint value) external returns (bool);
234     function transferFrom(address from, address to, uint value) external returns (bool);
235 
236     function DOMAIN_SEPARATOR() external view returns (bytes32);
237     function PERMIT_TYPEHASH() external pure returns (bytes32);
238     function nonces(address owner) external view returns (uint);
239 
240     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
241 
242     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
243     event Swap(
244         address indexed sender,
245         uint amount0In,
246         uint amount1In,
247         uint amount0Out,
248         uint amount1Out,
249         address indexed to
250     );
251     event Sync(uint112 reserve0, uint112 reserve1);
252 
253     function MINIMUM_LIQUIDITY() external pure returns (uint);
254     function factory() external view returns (address);
255     function token0() external view returns (address);
256     function token1() external view returns (address);
257     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
258     function price0CumulativeLast() external view returns (uint);
259     function price1CumulativeLast() external view returns (uint);
260     function kLast() external view returns (uint);
261 
262     function burn(address to) external returns (uint amount0, uint amount1);
263     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
264     function skim(address to) external;
265     function sync() external;
266 
267     function initialize(address, address) external;
268 }
269 
270 // pragma solidity >=0.6.2;
271 
272 interface IUniswapV2Router01 {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function addLiquidity(
277         address tokenA,
278         address tokenB,
279         uint amountADesired,
280         uint amountBDesired,
281         uint amountAMin,
282         uint amountBMin,
283         address to,
284         uint deadline
285     ) external returns (uint amountA, uint amountB, uint liquidity);
286     function addLiquidityETH(
287         address token,
288         uint amountTokenDesired,
289         uint amountTokenMin,
290         uint amountETHMin,
291         address to,
292         uint deadline
293     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
294     function removeLiquidity(
295         address tokenA,
296         address tokenB,
297         uint liquidity,
298         uint amountAMin,
299         uint amountBMin,
300         address to,
301         uint deadline
302     ) external returns (uint amountA, uint amountB);
303     function removeLiquidityETH(
304         address token,
305         uint liquidity,
306         uint amountTokenMin,
307         uint amountETHMin,
308         address to,
309         uint deadline
310     ) external returns (uint amountToken, uint amountETH);
311     function removeLiquidityWithPermit(
312         address tokenA,
313         address tokenB,
314         uint liquidity,
315         uint amountAMin,
316         uint amountBMin,
317         address to,
318         uint deadline,
319         bool approveMax, uint8 v, bytes32 r, bytes32 s
320     ) external returns (uint amountA, uint amountB);
321     function removeLiquidityETHWithPermit(
322         address token,
323         uint liquidity,
324         uint amountTokenMin,
325         uint amountETHMin,
326         address to,
327         uint deadline,
328         bool approveMax, uint8 v, bytes32 r, bytes32 s
329     ) external returns (uint amountToken, uint amountETH);
330     function swapExactTokensForTokens(
331         uint amountIn,
332         uint amountOutMin,
333         address[] calldata path,
334         address to,
335         uint deadline
336     ) external returns (uint[] memory amounts);
337     function swapTokensForExactTokens(
338         uint amountOut,
339         uint amountInMax,
340         address[] calldata path,
341         address to,
342         uint deadline
343     ) external returns (uint[] memory amounts);
344     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
345     external
346     payable
347     returns (uint[] memory amounts);
348     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
349     external
350     returns (uint[] memory amounts);
351     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
352     external
353     returns (uint[] memory amounts);
354     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
355     external
356     payable
357     returns (uint[] memory amounts);
358 
359     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
360     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
361     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
362     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
363     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
364 }
365 
366 
367 
368 // pragma solidity >=0.6.2;
369 
370 interface IUniswapV2Router02 is IUniswapV2Router01 {
371     function removeLiquidityETHSupportingFeeOnTransferTokens(
372         address token,
373         uint liquidity,
374         uint amountTokenMin,
375         uint amountETHMin,
376         address to,
377         uint deadline
378     ) external returns (uint amountETH);
379     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
380         address token,
381         uint liquidity,
382         uint amountTokenMin,
383         uint amountETHMin,
384         address to,
385         uint deadline,
386         bool approveMax, uint8 v, bytes32 r, bytes32 s
387     ) external returns (uint amountETH);
388 
389     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
390         uint amountIn,
391         uint amountOutMin,
392         address[] calldata path,
393         address to,
394         uint deadline
395     ) external;
396     function swapExactETHForTokensSupportingFeeOnTransferTokens(
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external payable;
402     function swapExactTokensForETHSupportingFeeOnTransferTokens(
403         uint amountIn,
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline
408     ) external;
409 }
410 
411 contract DELTAVARIANT is Context, IERC20, Ownable {
412     using SafeMath for uint256;
413     using Address for address;
414 
415 address payable public MarketingFundAddress = payable(0x586F7cC6697F5dE03a595c4E4356d22AdBa9e2Be); // MarketingFundAddress
416 address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
417 mapping (address => uint256) private _rOwned;
418 mapping (address => uint256) private _tOwned;
419 mapping (address => mapping (address => uint256)) private _allowances;
420 
421 mapping (address => bool) private _isExcludedFromFee;
422 
423 mapping (address => bool) private _isExcluded;
424 address[] private _excluded;
425 
426 mapping(address => bool) private _IsBot;
427 
428 bool public tradingOpen = false; //once switched on, can never be switched off.
429 
430 
431 
432 uint256 private constant MAX = ~uint256(0);
433 uint256 private _tTotal = 1000 * 10**6 * 10**9;
434 uint256 private _rTotal = (MAX - (MAX % _tTotal));
435 uint256 private _tFeeTotal;
436 
437 string private _name = "Delta Variant";
438 string private _symbol = "Delta";
439 uint8 private _decimals = 9;
440 
441 
442 uint256 private _taxFee = 0; 
443 uint256 private _previousTaxFee = _taxFee;
444 
445 uint256 public _MarketingFee = 11;
446 uint256 private _previousMarketingFee = _MarketingFee;
447 
448 uint256 private _tradingOpenTime;
449 
450 bool public tradingPaused;
451 
452 bool public pauseTradingFxnUsed;
453 
454 bool public  enableTradingFxnUsed;
455 
456 IUniswapV2Router02 public immutable uniswapV2Router;
457 address public immutable uniswapV2Pair;
458 
459 bool inSwapAndLiquify;
460 bool public swapAndLiquifyEnabled = false;
461 
462 
463 
464 event RewardLiquidityProviders(uint256 tokenAmount);
465 event SwapAndLiquifyEnabledUpdated(bool enabled);
466 event SwapAndLiquify(
467 uint256 tokensSwapped,
468 uint256 ethReceived,
469 uint256 tokensIntoLiqudity
470 );
471 
472 event SwapETHForTokens(
473 uint256 amountIn,
474 address[] path
475 );
476 
477 event SwapTokensForETH(
478 uint256 amountIn,
479 address[] path
480 );
481 
482 modifier lockTheSwap {
483 inSwapAndLiquify = true;
484 _;
485 inSwapAndLiquify = false;
486 }
487     
488 constructor () {
489 _rOwned[_msgSender()] = _rTotal;
490 
491 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
492 uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
493 .createPair(address(this), _uniswapV2Router.WETH());
494 
495 uniswapV2Router = _uniswapV2Router;
496 
497 
498 // don't collect fees from the following account
499 _isExcludedFromFee[owner()] = true;
500 _isExcludedFromFee[address(this)] = true;
501 
502 emit Transfer(address(0), _msgSender(), _tTotal);
503 }
504 
505 
506 function enableTrading() external onlyOwner() {
507 require(!enableTradingFxnUsed, "This function can be used only once!");
508 swapAndLiquifyEnabled = true;
509 tradingOpen = true;
510 _tradingOpenTime = block.timestamp;
511 enableTradingFxnUsed=true;
512 }
513 
514 function pauseTrading() external onlyOwner() {
515 require(!pauseTradingFxnUsed, "This function can be used only once!");
516 tradingPaused = true;
517 pauseTradingFxnUsed=true;
518 }
519 
520 function unpauseTrading() external onlyOwner() {
521 //require(pauseTradingFxnUsed==0, "This function can be used only once!");
522 tradingPaused = false;
523 }
524 
525 function name() public view returns (string memory) {
526 return _name;
527 }
528 
529 function symbol() public view returns (string memory) {
530 return _symbol;
531 }
532 
533 function decimals() public view returns (uint8) {
534 return _decimals;
535 }
536 
537 function totalSupply() public view override returns (uint256) {
538 return _tTotal;
539 }
540 
541 function balanceOf(address account) public view override returns (uint256) {
542 if (_isExcluded[account]) return _tOwned[account];
543 return tokenFromReflection(_rOwned[account]);
544 }
545 
546 function transfer(address recipient, uint256 amount) public override returns (bool) {
547 _transfer(_msgSender(), recipient, amount);
548 return true;
549 }
550 
551 function allowance(address owner, address spender) public view override returns (uint256) {
552 return _allowances[owner][spender];
553 }
554 
555 function approve(address spender, uint256 amount) public override returns (bool) {
556 _approve(_msgSender(), spender, amount);
557 return true;
558 }
559 
560 function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
561 _transfer(sender, recipient, amount);
562 _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563 return true;
564 }
565 
566 function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
567 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
568 return true;
569 }
570 
571 function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
572 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
573 return true;
574 }
575 
576 function isExcludedFromReward(address account) public view returns (bool) {
577 return _isExcluded[account];
578 }
579 
580 function totalFees() public view returns (uint256) {
581 return _tFeeTotal;
582 }
583 
584 
585 function deliver(uint256 tAmount) public {
586 address sender = _msgSender();
587 require(!_isExcluded[sender], "Excluded addresses cannot call this function");
588 // adjust Tax
589 //_adjustTax();
590 
591 (uint256 rAmount,,,,,) = _getValues(tAmount);
592 _rOwned[sender] = _rOwned[sender].sub(rAmount);
593 _rTotal = _rTotal.sub(rAmount);
594 _tFeeTotal = _tFeeTotal.add(tAmount);
595 }
596 
597 
598 function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
599 require(tAmount <= _tTotal, "Amount must be less than supply");
600 if (!deductTransferFee) {
601 (uint256 rAmount,,,,,) = _getValues(tAmount);
602 return rAmount;
603 } else {
604 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
605 return rTransferAmount;
606 }
607 }
608 
609 function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
610 require(rAmount <= _rTotal, "Amount must be less than total reflections");
611 uint256 currentRate =  _getRate();
612 return rAmount.div(currentRate);
613 }
614 
615 function isBlockedBot(address account) public view returns (bool) {
616 return _IsBot[account];
617 }
618 
619 
620 function setBots(address[] memory bots_) public onlyOwner {
621 for (uint256 i = 0; i < bots_.length; i++) {
622 _IsBot[bots_[i]] = true;
623 }
624 }
625 
626 function delBot(address notbot) public onlyOwner {
627 _IsBot[notbot] = false;
628 }
629 
630 
631 function excludeFromReward(address account) public onlyOwner() {
632 
633 require(!_isExcluded[account], "Account is already excluded");
634 if(_rOwned[account] > 0) {
635 _tOwned[account] = tokenFromReflection(_rOwned[account]);
636 }
637 _isExcluded[account] = true;
638 _excluded.push(account);
639 }
640 
641 function includeInReward(address account) external onlyOwner() {
642 require(_isExcluded[account], "Account is already excluded");
643 for (uint256 i = 0; i < _excluded.length; i++) {
644 if (_excluded[i] == account) {
645 _excluded[i] = _excluded[_excluded.length - 1];
646 uint256 currentRate = _getRate();
647 _rOwned[account] = _tOwned[account].mul(currentRate);
648 _tOwned[account] = 0;
649 _isExcluded[account] = false;
650 _excluded.pop();
651 break;
652 }
653 }
654 }
655 
656 function _approve(address owner, address spender, uint256 amount) private {
657 require(owner != address(0), "ERC20: approve from the zero address");
658 require(spender != address(0), "ERC20: approve to the zero address");
659 
660 _allowances[owner][spender] = amount;
661 emit Approval(owner, spender, amount);
662 }
663 
664 
665 function _transfer(
666 address sender,
667 address recipient,
668 uint256 amount
669 ) private {
670 require(sender != address(0), "ERC20: transfer from the zero address");
671 require(recipient != address(0), "ERC20: transfer to the zero address");
672 require(amount > 0, "Transfer amount must be greater than zero");
673 require(!_IsBot[recipient], "You are a sending to a blocked bot!");
674 require(!_IsBot[msg.sender], "You are blocked as a bot!");
675 
676 // _adjustTax
677 //_adjustTax();
678 
679 if(sender != owner() && recipient != owner()) {
680 if (!(sender == address(this) || recipient == address(this)
681 || sender == address(owner()) || recipient == address(owner())))
682 {
683 require(tradingOpen, "Trading is not enabled");
684 require(!tradingPaused, "Trading is currently be paused");
685 }
686 }
687 
688 uint256 contractTokenBalance = balanceOf(address(this));
689 if (!inSwapAndLiquify && swapAndLiquifyEnabled && recipient == uniswapV2Pair) {
690 swapTokens(contractTokenBalance);
691 }
692 
693 bool takeFee = true;
694 
695 //if any account belongs to _isExcludedFromFee account then remove the fee
696 if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
697 takeFee = false;
698 
699 }
700 
701 _tokenTransfer(sender,recipient,amount,takeFee);
702 }
703 
704 function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
705 
706 uint256 initialBalance = address(this).balance;
707 swapTokensForEth(contractTokenBalance);
708 uint256 transferredBalance = address(this).balance.sub(initialBalance);
709 
710 //Send to Marketing address
711 transferToAddressETH(MarketingFundAddress, transferredBalance);
712 
713 }
714 
715 
716 function swapTokensForEth(uint256 tokenAmount) private {
717 // generate the uniswap pair path of token -> weth
718 address[] memory path = new address[](2);
719 path[0] = address(this);
720 path[1] = uniswapV2Router.WETH();
721 
722 _approve(address(this), address(uniswapV2Router), tokenAmount);
723 
724 // make the swap
725 uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
726 tokenAmount,
727 0, // accept any amount of ETH
728 path,
729 address(this), // The contract
730 block.timestamp
731 );
732 
733 emit SwapTokensForETH(tokenAmount, path);
734 }
735 
736 function swapETHForTokens(uint256 amount) private {
737 // generate the uniswap pair path of token -> weth
738 address[] memory path = new address[](2);
739 path[0] = uniswapV2Router.WETH();
740 path[1] = address(this);
741 
742 // make the swap
743 uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
744 0, // accept any amount of Tokens
745 path,
746 deadAddress, // Burn address
747 block.timestamp.add(300)
748 );
749 
750 emit SwapETHForTokens(amount, path);
751 }
752 
753 function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
754 // approve token transfer to cover all possible scenarios
755 _approve(address(this), address(uniswapV2Router), tokenAmount);
756 
757 // add the liquidity
758 uniswapV2Router.addLiquidityETH{value: ethAmount}(
759 address(this),
760 tokenAmount,
761 0, // slippage is unavoidable
762 0, // slippage is unavoidable
763 owner(),
764 block.timestamp
765 );
766 }
767 
768 function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
769 if(!takeFee)
770 removeAllFee();
771 
772 if (_isExcluded[sender] && !_isExcluded[recipient]) {
773 _transferFromExcluded(sender, recipient, amount);
774 } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
775 _transferToExcluded(sender, recipient, amount);
776 } else if (_isExcluded[sender] && _isExcluded[recipient]) {
777 _transferBothExcluded(sender, recipient, amount);
778 } else {
779 _transferStandard(sender, recipient, amount);
780 }
781 
782 if(!takeFee)
783 restoreAllFee();
784 }
785 
786 function _transferStandard(address sender, address recipient, uint256 tAmount) private {
787 (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
788 _rOwned[sender] = _rOwned[sender].sub(rAmount);
789 _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
790 _takeLiquidity(tLiquidity);
791 _reflectFee(rFee, tFee);
792 emit Transfer(sender, recipient, tTransferAmount);
793 }
794 
795 function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
796 (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
797 _rOwned[sender] = _rOwned[sender].sub(rAmount);
798 _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
799 _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
800 _takeLiquidity(tLiquidity);
801 _reflectFee(rFee, tFee);
802 emit Transfer(sender, recipient, tTransferAmount);
803 }
804 
805 function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
806 (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
807 _tOwned[sender] = _tOwned[sender].sub(tAmount);
808 _rOwned[sender] = _rOwned[sender].sub(rAmount);
809 _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
810 _takeLiquidity(tLiquidity);
811 _reflectFee(rFee, tFee);
812 emit Transfer(sender, recipient, tTransferAmount);
813 }
814 
815 function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
816 (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
817 _tOwned[sender] = _tOwned[sender].sub(tAmount);
818 _rOwned[sender] = _rOwned[sender].sub(rAmount);
819 _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
820 _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
821 _takeLiquidity(tLiquidity);
822 _reflectFee(rFee, tFee);
823 emit Transfer(sender, recipient, tTransferAmount);
824 }
825 
826 function _reflectFee(uint256 rFee, uint256 tFee) private {
827 _rTotal = _rTotal.sub(rFee);
828 _tFeeTotal = _tFeeTotal.add(tFee);
829 }
830 
831 function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
832 (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
833 (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
834 return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
835 }
836 
837 function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
838 uint256 tFee = calculateTaxFee(tAmount);
839 uint256 tLiquidity = calculateMarketingFee(tAmount);
840 uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
841 return (tTransferAmount, tFee, tLiquidity);
842 }
843 
844 function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
845 uint256 rAmount = tAmount.mul(currentRate);
846 uint256 rFee = tFee.mul(currentRate);
847 uint256 rLiquidity = tLiquidity.mul(currentRate);
848 uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
849 return (rAmount, rTransferAmount, rFee);
850 }
851 
852 function _getRate() private view returns(uint256) {
853 (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
854 return rSupply.div(tSupply);
855 }
856 
857 function _getCurrentSupply() private view returns(uint256, uint256) {
858 uint256 rSupply = _rTotal;
859 uint256 tSupply = _tTotal;
860 for (uint256 i = 0; i < _excluded.length; i++) {
861 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
862 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
863 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
864 }
865 if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
866 return (rSupply, tSupply);
867 }
868 
869 function _takeLiquidity(uint256 tLiquidity) private {
870 uint256 currentRate =  _getRate();
871 uint256 rLiquidity = tLiquidity.mul(currentRate);
872 _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
873 if(_isExcluded[address(this)])
874 _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
875 }
876 
877 function calculateTaxFee(uint256 _amount) private view returns (uint256) {
878 return _amount.mul(_taxFee).div(
879 10**2
880 );
881 }
882 
883 function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
884 return _amount.mul(_MarketingFee).div(
885 10**2
886 );
887 }
888 
889 
890 function changeTaxFee(uint256 _newTax) public onlyOwner returns(uint256){
891 _previousTaxFee = _taxFee;
892 _taxFee = _newTax;
893 return _taxFee;
894 }
895 
896 function changeMarketingFee(uint256 _newMarketingFee) public onlyOwner returns(uint256){
897 _MarketingFee = _newMarketingFee;
898 return _MarketingFee;
899 }
900 
901 
902 function removeAllFee() private {
903 if(_taxFee == 0 && _MarketingFee == 0) return;
904 
905 _previousTaxFee = _taxFee;
906 _previousMarketingFee = _MarketingFee;
907 
908 _taxFee = 0;
909 _MarketingFee = 0;
910 }
911 
912 function restoreAllFee() private {
913 _taxFee = _previousTaxFee;
914 _MarketingFee = _previousMarketingFee;
915 }
916 
917 function isExcludedFromFee(address account) public view returns(bool) {
918 return _isExcludedFromFee[account];
919 }
920 
921 function excludeFromFee(address account) public onlyOwner {
922 _isExcludedFromFee[account] = true;
923 }
924 
925 function includeInFee(address account) public onlyOwner {
926 _isExcludedFromFee[account] = false;
927 }
928 
929 
930 function setMarketingFundAddress(address _MarketingFundAddress) external onlyOwner() {
931 MarketingFundAddress = payable(_MarketingFundAddress);
932 }
933 
934 function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
935 swapAndLiquifyEnabled = _enabled;
936 emit SwapAndLiquifyEnabledUpdated(_enabled);
937 }
938 
939 function transferToAddressETH(address payable recipient, uint256 amount) private {
940 recipient.transfer(amount);
941 }
942 
943 function sendTokenTo(IERC20 token, address recipient, uint256 amount) external onlyOwner() {
944 token.transfer(recipient, amount);
945 
946 }
947 
948 function getETHBalance() public view returns(uint) {
949 return address(this).balance;
950 }
951 
952 function sendETHTo(address payable _to) external onlyOwner() {
953 _to.transfer(getETHBalance());
954 }
955 
956 receive() external payable {}
957 }