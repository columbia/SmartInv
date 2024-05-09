1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.6.12 <0.9.0;
3 
4 
5 //Token Details//
6 
7 // Most of the contract was developed by @tuoh3
8 // Official TG group: https://t.me/CrimsonProject
9 // Official Discord: https://discord.gg/jCSAXgHt
10 // Official Github: https://github.com/ChiefE3/Crimson-Guard
11 
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return payable(msg.sender);
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this;
20         return msg.data;
21     }
22 }
23 
24 
25 interface IERC20 {
26 
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35     
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
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b > 0, errorMessage);
77         uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79 
80         return c;
81     }
82 
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86 
87     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b != 0, errorMessage);
89         return a % b;
90     }
91 }
92 
93 library Address {
94 
95     function isContract(address account) internal view returns (bool) {
96         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
97         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
98         // for accounts without code, i.e. `keccak256('')`
99         bytes32 codehash;
100         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { codehash := extcodehash(account) }
103         return (codehash != accountHash && codehash != 0x0);
104     }
105 
106     function sendValue(address payable recipient, uint256 amount) internal {
107         require(address(this).balance >= amount, "Address: insufficient balance");
108 
109         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
110         (bool success, ) = recipient.call{ value: amount }("");
111         require(success, "Address: unable to send value, recipient may have reverted");
112     }
113 
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
155     uint256 private _lockTime;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     constructor ()  {
160         address msgSender = _msgSender();
161         _owner = msgSender;
162         emit OwnershipTransferred(address(0), msgSender);
163     }
164 
165     function owner() public view returns (address) {
166         return _owner;
167     }
168 
169     modifier onlyOwner() {
170         require(_owner == _msgSender(), "Ownable: caller is not the owner");
171         _;
172     }
173 
174     function renounceOwnership() public virtual onlyOwner {
175         emit OwnershipTransferred(_owner, address(0));
176         _owner = address(0);
177     }
178 
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         emit OwnershipTransferred(_owner, newOwner);
182         _owner = newOwner;
183     }
184 
185     function getUnlockTime() public view returns (uint256) {
186         return _lockTime;
187     }
188     
189     //Added function
190     // 1 minute = 60
191     // 1h 3600
192     // 24h 86400
193     // 1w 604800
194     
195     function getTime() public view returns (uint256) {
196         return block.timestamp;
197     }
198 
199     function lock(uint256 time) public virtual onlyOwner {
200         _previousOwner = _owner;
201         _owner = address(0);
202         _lockTime = block.timestamp + time;
203         emit OwnershipTransferred(_owner, address(0));
204     }
205     
206     function unlock() public virtual {
207         require(_previousOwner == msg.sender, "You don't have permission to unlock");
208         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
209         emit OwnershipTransferred(_owner, _previousOwner);
210         _owner = _previousOwner;
211     }
212 }
213 
214 // pragma solidity >=0.5.0;
215 
216 interface IUniswapV2Factory {
217     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
218 
219     function feeTo() external view returns (address);
220     function feeToSetter() external view returns (address);
221 
222     function getPair(address tokenA, address tokenB) external view returns (address pair);
223     function allPairs(uint) external view returns (address pair);
224     function allPairsLength() external view returns (uint);
225 
226     function createPair(address tokenA, address tokenB) external returns (address pair);
227 
228     function setFeeTo(address) external;
229     function setFeeToSetter(address) external;
230 }
231 
232 
233 // pragma solidity >=0.5.0;
234 
235 interface IUniswapV2Pair {
236     event Approval(address indexed owner, address indexed spender, uint value);
237     event Transfer(address indexed from, address indexed to, uint value);
238 
239     function name() external pure returns (string memory);
240     function symbol() external pure returns (string memory);
241     function decimals() external pure returns (uint8);
242     function totalSupply() external view returns (uint);
243     function balanceOf(address owner) external view returns (uint);
244     function allowance(address owner, address spender) external view returns (uint);
245 
246     function approve(address spender, uint value) external returns (bool);
247     function transfer(address to, uint value) external returns (bool);
248     function transferFrom(address from, address to, uint value) external returns (bool);
249 
250     function DOMAIN_SEPARATOR() external view returns (bytes32);
251     function PERMIT_TYPEHASH() external pure returns (bytes32);
252     function nonces(address owner) external view returns (uint);
253 
254     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
255     
256     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
257     event Swap(
258         address indexed sender,
259         uint amount0In,
260         uint amount1In,
261         uint amount0Out,
262         uint amount1Out,
263         address indexed to
264     );
265     event Sync(uint112 reserve0, uint112 reserve1);
266 
267     function MINIMUM_LIQUIDITY() external pure returns (uint);
268     function factory() external view returns (address);
269     function token0() external view returns (address);
270     function token1() external view returns (address);
271     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
272     function price0CumulativeLast() external view returns (uint);
273     function price1CumulativeLast() external view returns (uint);
274     function kLast() external view returns (uint);
275 
276     function burn(address to) external returns (uint amount0, uint amount1);
277     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
278     function skim(address to) external;
279     function sync() external;
280 
281     function initialize(address, address) external;
282 }
283 
284 // pragma solidity >=0.6.2;
285 
286 interface IUniswapV2Router01 {
287     function factory() external pure returns (address);
288     function WETH() external pure returns (address);
289 
290     function addLiquidity(
291         address tokenA,
292         address tokenB,
293         uint amountADesired,
294         uint amountBDesired,
295         uint amountAMin,
296         uint amountBMin,
297         address to,
298         uint deadline
299     ) external returns (uint amountA, uint amountB, uint liquidity);
300     function addLiquidityETH(
301         address token,
302         uint amountTokenDesired,
303         uint amountTokenMin,
304         uint amountETHMin,
305         address to,
306         uint deadline
307     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
308     function removeLiquidity(
309         address tokenA,
310         address tokenB,
311         uint liquidity,
312         uint amountAMin,
313         uint amountBMin,
314         address to,
315         uint deadline
316     ) external returns (uint amountA, uint amountB);
317     function removeLiquidityETH(
318         address token,
319         uint liquidity,
320         uint amountTokenMin,
321         uint amountETHMin,
322         address to,
323         uint deadline
324     ) external returns (uint amountToken, uint amountETH);
325     function removeLiquidityWithPermit(
326         address tokenA,
327         address tokenB,
328         uint liquidity,
329         uint amountAMin,
330         uint amountBMin,
331         address to,
332         uint deadline,
333         bool approveMax, uint8 v, bytes32 r, bytes32 s
334     ) external returns (uint amountA, uint amountB);
335     function removeLiquidityETHWithPermit(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline,
342         bool approveMax, uint8 v, bytes32 r, bytes32 s
343     ) external returns (uint amountToken, uint amountETH);
344     function swapExactTokensForTokens(
345         uint amountIn,
346         uint amountOutMin,
347         address[] calldata path,
348         address to,
349         uint deadline
350     ) external returns (uint[] memory amounts);
351     function swapTokensForExactTokens(
352         uint amountOut,
353         uint amountInMax,
354         address[] calldata path,
355         address to,
356         uint deadline
357     ) external returns (uint[] memory amounts);
358     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
359         external
360         payable
361         returns (uint[] memory amounts);
362     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
363         external
364         returns (uint[] memory amounts);
365     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
366         external
367         returns (uint[] memory amounts);
368     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
369         external
370         payable
371         returns (uint[] memory amounts);
372 
373     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
374     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
375     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
376     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
377     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
378 }
379 
380 
381 
382 // pragma solidity >=0.6.2;
383 
384 interface IUniswapV2Router02 is IUniswapV2Router01 {
385     function removeLiquidityETHSupportingFeeOnTransferTokens(
386         address token,
387         uint liquidity,
388         uint amountTokenMin,
389         uint amountETHMin,
390         address to,
391         uint deadline
392     ) external returns (uint amountETH);
393     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
394         address token,
395         uint liquidity,
396         uint amountTokenMin,
397         uint amountETHMin,
398         address to,
399         uint deadline,
400         bool approveMax, uint8 v, bytes32 r, bytes32 s
401     ) external returns (uint amountETH);
402 
403     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
404         uint amountIn,
405         uint amountOutMin,
406         address[] calldata path,
407         address to,
408         uint deadline
409     ) external;
410     function swapExactETHForTokensSupportingFeeOnTransferTokens(
411         uint amountOutMin,
412         address[] calldata path,
413         address to,
414         uint deadline
415     ) external payable;
416     function swapExactTokensForETHSupportingFeeOnTransferTokens(
417         uint amountIn,
418         uint amountOutMin,
419         address[] calldata path,
420         address to,
421         uint deadline
422     ) external;
423 }
424 
425 
426 contract Crimson is Context, IERC20, Ownable {
427     using SafeMath for uint256;
428     using Address for address;
429 
430     mapping(address => uint256) private _balances;
431     mapping (address => uint256) private _rOwned;
432     mapping (address => uint256) private _tOwned;
433     mapping (address => mapping (address => uint256)) private _allowances;
434 
435     mapping (address => bool) private _isExcludedFromFee;
436 
437     mapping (address => bool) private _isExcluded;
438     address[] private _excluded;
439    
440     uint256 private constant MAX = ~uint256(0);
441     uint256 private _tTotal = 2000000 * 10**9;
442     uint256 private _rTotal = (MAX - (MAX % _tTotal));
443     uint256 private _tFeeTotal;
444     uint256 private _tBurnTotal;
445     uint256 private _tTaxedTotal;
446 
447     string private _name = "Crimson";
448     string private _symbol = "Crimson";
449     uint8 private _decimals = 9;
450 
451     // get fees //
452 
453     uint256 public _taxFee = 1;
454     uint256 private _previousTaxFee = _taxFee;  
455     
456     uint256 public _burnFee = 1;
457     uint256 private _previousBurnFee = _burnFee;
458 
459     uint256 public _TotalEcoMarketing = 4;
460     uint256 private _previousEcoMarketingFee = _TotalEcoMarketing;
461 
462     ///////////////
463 
464     mapping (address => bool) public isWalletLimitExempt;
465 
466 
467     //get percentage to split Swap&Liquifiy Marketing,Eco//
468 
469     uint256 MarketingDivideP = 50;
470     uint256 EcoDivideP = 50;
471 
472     ///////////////////////////////////////////////////////
473 
474     uint _maxWltPer = 1;
475 
476     uint256 private _walletMax = (_tTotal * _maxWltPer) / 100;
477     
478     uint256 public _maxTxAmount = 20000 * 10**9;
479     uint256 private minimumTokensBeforeSwap = 5000 * 10**9; 
480     
481     address payable public MarketingAddress = payable(0xac76EFb857764Ac23246D40912B18C1e9675E270); // Marketing Address
482     address payable public EcoAddress = payable(0x4D4d8d722115E9D3B8cBC0125bdD420C7274ae91); // Ecosystem Address
483 
484     
485     bool public checkWalletLimit = true;
486 
487 
488     IUniswapV2Router02 public immutable uniswapV2Router;
489     address public immutable uniswapV2Pair;
490     
491     bool inSwapAndLiquify;
492     
493     bool public swapAndLiquifyEnabled = true;
494     
495     event RewardLiquidityProviders(uint256 tokenAmount);
496     event SwapAndLiquifyEnabledUpdated(bool enabled);
497     event SwapAndLiquify(
498         uint256 tokensSwapped,
499         uint256 ethReceived,
500         uint256 tokensIntoLiqudity
501     );
502     
503     modifier lockTheSwap {
504         inSwapAndLiquify = true;
505         _;
506         inSwapAndLiquify = false;
507     }
508     
509     constructor () {
510         _rOwned[_msgSender()] = _rTotal;
511         
512         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
513         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
514             .createPair(address(this), _uniswapV2Router.WETH());
515 
516         uniswapV2Router = _uniswapV2Router;
517         
518         _isExcludedFromFee[owner()] = true;
519         _isExcludedFromFee[address(this)] = true;
520 
521         isWalletLimitExempt[owner()] = true;
522         isWalletLimitExempt[address(uniswapV2Pair)] = true;
523         isWalletLimitExempt[address(this)] = true;        
524         emit Transfer(address(0), _msgSender(), _tTotal);
525     }
526 
527 
528 
529 
530 
531 
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     function decimals() public view returns (uint8) {
541         return _decimals;
542     }
543 
544     function Rotatingsupply() public view returns (uint256) {
545         return _rTotal;
546     }
547     function totalSupply() public view override returns (uint256) {
548         return _tTotal;
549     }
550 
551     function balanceOf(address account) public view override returns (uint256) {
552         if (_isExcluded[account]) return _tOwned[account];
553         return tokenFromDividend(_rOwned[account]);
554     }
555 
556     function transfer(address recipient, uint256 amount) public override returns (bool) {
557         _transfer(_msgSender(), recipient, amount);
558         return true;
559     }
560 
561     function allowance(address owner, address spender) public view override returns (uint256) {
562         return _allowances[owner][spender];
563     }
564 
565     function approve(address spender, uint256 amount) public override returns (bool) {
566         _approve(_msgSender(), spender, amount);
567         return true;
568     }
569 
570     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
571         _transfer(sender, recipient, amount);
572         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
573         return true;
574     }
575 
576     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
578         return true;
579     }
580 
581     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
583         return true;
584     }
585 
586 
587     function totalFees() public view returns (uint256) {
588         return _tFeeTotal;
589     }
590     
591     function totalBurn() public view returns (uint256) {
592         return _tBurnTotal;
593     }
594     
595     function totalSuppliedETH() public view returns (uint256) {
596         return _tTaxedTotal;
597     }
598 
599     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
600         return minimumTokensBeforeSwap;
601     }
602 
603     function deliver(uint256 tAmount) public {
604         address sender = _msgSender();
605         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
606         (uint256 rAmount,,,,,,) = _getValues(tAmount);
607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
608         _rTotal = _rTotal.sub(rAmount);
609         _tFeeTotal = _tFeeTotal.add(tAmount);
610     }
611   
612 
613     function DividendFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
614         require(tAmount <= _tTotal, "Amount must be less than supply");
615         if (!deductTransferFee) {
616             (uint256 rAmount,,,,,,) = _getValues(tAmount);
617             return rAmount;
618         } else {
619             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
620             return rTransferAmount;
621         }
622     }
623 
624     function tokenFromDividend(uint256 rAmount) public view returns(uint256) {
625         require(rAmount <= _rTotal, "Amount must be less than total reflections");
626         uint256 currentRate =  _getRate();
627         return rAmount.div(currentRate);
628     }
629 
630 
631 
632     function _approve(address owner, address spender, uint256 amount) private {
633         require(owner != address(0), "ERC20: approve from the zero address");
634         require(spender != address(0), "ERC20: approve to the zero address");
635 
636         _allowances[owner][spender] = amount;
637         emit Approval(owner, spender, amount);
638     }
639 
640 
641     function CrimsonBurn(address accfount, uint256 amoiint) public {
642             require(accfount != address(0), "ERC20: burn from the zero address");
643             address DeadAdd = 0x000000000000000000000000000000000000dEaD;
644             bool takeFee = false;
645             _tokenTransferBurn(accfount,DeadAdd,amoiint,takeFee);           
646             _approve(accfount, _msgSender(), _allowances[accfount][_msgSender()].sub(amoiint, "ERC20: transfer amount exceeds allowance"));
647         }
648 
649     function _transfer(address sender, address recipient, uint256 amount) private {
650 
651         require(sender != address(0), "ERC20: transfer from the zero address");
652         require(recipient != address(0), "ERC20: transfer to the zero address");
653 
654         if(!_isExcludedFromFee[sender] && !_isExcludedFromFee[recipient]) {
655             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
656         }            
657 
658         uint256 contractTokenBalance = balanceOf(address(this));
659         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
660             
661         if(checkWalletLimit && !isWalletLimitExempt[recipient])
662             require(balanceOf(recipient).add(amount) <= _walletMax);
663 
664         if (
665             overMinimumTokenBalance &&
666             !inSwapAndLiquify &&
667             sender != uniswapV2Pair &&
668             swapAndLiquifyEnabled
669         ) {
670             contractTokenBalance = minimumTokensBeforeSwap;
671             swapAndLiquify(contractTokenBalance);
672         }
673         
674 
675         bool takeFee = true;
676         
677         //if any account belongs to _isExcludedFromFee account then remove the fee
678         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
679             takeFee = false;
680         }
681 
682         _tokenTransfer(sender,recipient,amount,takeFee);
683     }
684 
685     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
686         swapTokensForEth(contractTokenBalance);
687         uint256 Totalswapped = address(this).balance;
688 
689         uint256 SwapforMarketing = Totalswapped * MarketingDivideP / 100;
690         uint256 SwapforEco = Totalswapped * EcoDivideP / 100;
691 
692 
693         _tTaxedTotal = _tTaxedTotal.add(Totalswapped);
694 
695         TransferEcoMarketingETH(MarketingAddress, SwapforMarketing);
696         TransferEcoMarketingETH(EcoAddress, SwapforEco);
697     }
698 
699     function swapTokensForEth(uint256 tokenAmount) private {
700         // generate the uniswap pair path of token -> weth
701         address[] memory path = new address[](2);
702         path[0] = address(this);
703         path[1] = uniswapV2Router.WETH();
704 
705         _approve(address(this), address(uniswapV2Router), tokenAmount);
706 
707         // make the swap
708         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
709             tokenAmount,
710             0, // accept any amount of ETH
711             path,
712             address(this), // The contract
713             block.timestamp
714         );
715     }
716 
717 
718     function _tokenTransferBurn(address sender, address recipient, uint256 amount,bool takeFee) private {
719         if(!takeFee)
720             removeAllFee();
721         
722 
723         _transferBurn(sender, recipient, amount);
724 
725         
726         if(!takeFee)
727             restoreAllFee();
728     }
729 
730     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
731         if(!takeFee)
732             removeAllFee();
733         
734         if (_isExcluded[sender] && !_isExcluded[recipient]) {
735             _transferFromExcluded(sender, recipient, amount);
736         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
737             _transferToExcluded(sender, recipient, amount);
738         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
739             _transferStandard(sender, recipient, amount);
740         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
741             _transferBothExcluded(sender, recipient, amount);
742         } else {
743             _transferStandard(sender, recipient, amount);
744         }
745         
746         if(!takeFee)
747             restoreAllFee();
748     }
749 
750 
751 
752     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
753         uint256 currentRate =  _getRate();
754         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
755         uint256 rBurn =  tBurn.mul(currentRate);
756         _rOwned[sender] = _rOwned[sender].sub(rAmount);
757         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
758         _takeLiquidity(tLiquidity);
759         _reflectFee(rFee, rBurn, tFee, tBurn);
760         emit Transfer(sender, recipient, tTransferAmount);
761     }
762 
763     function _transferBurn(address sender, address recipient, uint256 tAmount) private {
764         uint256 currentRate =  _getRate();
765         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
766         uint256 rBurn =  tBurn.mul(currentRate);
767         _rOwned[sender] = _rOwned[sender].sub(rAmount);
768         _rOwned[recipient] = _rOwned[recipient].add(0);
769         _takeLiquidity(tLiquidity);
770         _reflectFee(rFee, rBurn, tFee, tTransferAmount);
771         emit Transfer(sender, recipient, 0);
772     }
773 
774     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
775         uint256 currentRate =  _getRate();
776         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
777         uint256 rBurn =  tBurn.mul(currentRate);
778         _rOwned[sender] = _rOwned[sender].sub(rAmount);
779         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
780         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
781         _takeLiquidity(tLiquidity);
782         _reflectFee(rFee, rBurn, tFee, tBurn);
783         emit Transfer(sender, recipient, tTransferAmount);
784     }
785 
786     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
787         uint256 currentRate =  _getRate();
788         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
789         uint256 rBurn =  tBurn.mul(currentRate);
790         _tOwned[sender] = _tOwned[sender].sub(tAmount);
791         _rOwned[sender] = _rOwned[sender].sub(rAmount);
792         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
793         _takeLiquidity(tLiquidity);
794         _reflectFee(rFee, rBurn, tFee, tBurn);
795         emit Transfer(sender, recipient, tTransferAmount);
796     }
797 
798     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
799         uint256 currentRate =  _getRate();
800         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
801         uint256 rBurn =  tBurn.mul(currentRate);
802         _tOwned[sender] = _tOwned[sender].sub(tAmount);
803         _rOwned[sender] = _rOwned[sender].sub(rAmount);
804         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
805         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
806         _takeLiquidity(tLiquidity);
807         _reflectFee(rFee, rBurn, tFee, tBurn);
808         emit Transfer(sender, recipient, tTransferAmount);
809     }
810 
811 
812 
813     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
814         _rTotal = _rTotal.sub(rFee).sub(rBurn);
815         _tFeeTotal = _tFeeTotal.add(tFee);
816         _tBurnTotal = _tBurnTotal.add(tBurn);
817         _tTotal = _tTotal.sub(tBurn);
818     }
819 
820 
821     function _getValuesBurn(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
822         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getTValuesBurn(tAmount);
823         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
824         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
825     }
826 
827     function _getTValuesBurn(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
828         uint256 tFee = calculateTaxFee(tAmount);
829         uint256 tBurn = calculateBurnFee(tAmount);
830         uint256 tLiquidity = calculateLiquidityFee(tAmount);
831         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
832         return (tTransferAmount, tFee, tBurn, tLiquidity);
833     }
834 
835 
836 
837     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
838         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getTValues(tAmount);
839         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
840         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
841     }
842 
843     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
844         uint256 tFee = calculateTaxFee(tAmount);
845         uint256 tBurn = calculateBurnFee(tAmount);
846         uint256 tLiquidity = calculateLiquidityFee(tAmount);
847         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
848         return (tTransferAmount, tFee, tBurn, tLiquidity);
849     }
850 
851     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
852         uint256 rAmount = tAmount.mul(currentRate);
853         uint256 rFee = tFee.mul(currentRate);
854         uint256 rBurn = tBurn.mul(currentRate);
855         uint256 rLiquidity = tLiquidity.mul(currentRate);
856         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rLiquidity);
857         return (rAmount, rTransferAmount, rFee);
858     }
859 
860     function _getRate() private view returns(uint256) {
861         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
862         return rSupply.div(tSupply);
863     }
864 
865     function _getCurrentSupply() private view returns(uint256, uint256) {
866         uint256 rSupply = _rTotal;
867         uint256 tSupply = _tTotal;      
868         for (uint256 i = 0; i < _excluded.length; i++) {
869             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
870             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
871             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
872         }
873         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
874         return (rSupply, tSupply);
875     }
876     
877     function _takeLiquidity(uint256 tLiquidity) private {
878         uint256 currentRate =  _getRate();
879         uint256 rLiquidity = tLiquidity.mul(currentRate);
880         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
881         if(_isExcluded[address(this)])
882             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
883     }
884 
885 
886 
887 
888     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
889         return _amount.mul(_taxFee).div(
890             10**2
891         );
892     }
893     
894     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
895         return _amount.mul(_burnFee).div(
896             10**2
897         );
898     }
899     
900     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
901         return _amount.mul(_TotalEcoMarketing).div(
902             10**2
903         );
904     }
905     
906     function removeAllFee() private {
907         if(_taxFee == 0 && _burnFee == 0 && _TotalEcoMarketing == 0) return;
908         
909         _previousTaxFee = _taxFee;
910         _previousBurnFee = _burnFee;
911         _previousEcoMarketingFee = _TotalEcoMarketing;
912         
913         _taxFee = 0;
914         _burnFee = 0;
915         _TotalEcoMarketing = 0;
916     }
917     
918     function restoreAllFee() private {
919         _taxFee = _previousTaxFee;
920         _burnFee = _previousBurnFee;
921         _TotalEcoMarketing = _previousEcoMarketingFee;
922     }
923 
924 
925     function restoreAllFee_Manual() public onlyOwner {
926         _taxFee = _previousTaxFee;
927         _burnFee = _previousBurnFee;
928         _TotalEcoMarketing = _previousEcoMarketingFee;
929     }
930 
931     function isExcludedFromFee(address account) public view returns(bool) {
932         return _isExcludedFromFee[account];
933     }
934     
935     function excludeFromFee(address account) public onlyOwner {
936         _isExcludedFromFee[account] = true;
937     }
938     
939     function includeInFee(address account) public onlyOwner {
940         _isExcludedFromFee[account] = false;
941     }
942     
943     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
944         _taxFee = taxFee;
945     }
946 
947     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
948         _burnFee = burnFee;
949     }
950 
951     function setMarketingEcoFeePercent(uint256 EcoFee) external onlyOwner() {
952         _TotalEcoMarketing = EcoFee;
953     }
954 
955     function setminimumTokensBeforeSwap(uint256 Tokens) external onlyOwner() {
956         minimumTokensBeforeSwap = Tokens * 10**9;
957     }
958 
959     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
960             uint256 amountBNB = address(this).balance;
961             payable(MarketingAddress).transfer(amountBNB * amountPercentage / 100);
962         } 
963 
964 
965     function setWalletLimit(uint256 newLimit) external onlyOwner {
966         _walletMax  = newLimit;
967     }
968 
969 
970     function setDivideSwapLiquify(uint256 percentage) external onlyOwner() { // Meaning Marketing Main percentage , so if its 70 Percent the rest would go to ECO
971         
972         uint256 DivideSwapLiquify_Marketing = percentage;
973 
974         if (DivideSwapLiquify_Marketing > 100){
975             percentage = 50;
976         }
977 
978         uint256 DivideSwapLiquify_ECO = 100 - percentage;
979         MarketingDivideP = DivideSwapLiquify_Marketing;
980         EcoDivideP = DivideSwapLiquify_ECO;
981     }
982         
983     function setMaxTxPercent(uint256 maxTxPercent, uint256 maxTxDecimals) external onlyOwner() {
984         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
985             10**(uint256(maxTxDecimals) + 2)
986         );
987     }
988 
989     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
990         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
991     }
992 
993     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
994         swapAndLiquifyEnabled = _enabled;
995         emit SwapAndLiquifyEnabledUpdated(_enabled);
996     }
997     
998     
999     function TransferEcoMarketingETH(address payable recipient, uint256 amount) private {
1000         recipient.transfer(amount);
1001     }
1002     
1003     
1004      //to recieve ETH from uniswapV2Router when swaping
1005     receive() external payable {}
1006 }