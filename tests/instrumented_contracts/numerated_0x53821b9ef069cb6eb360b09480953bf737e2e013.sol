1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.9;
3 
4     abstract contract Context {
5         function _msgSender() internal view virtual returns (address payable) {
6             return payable(msg.sender);
7         }
8 
9         function _msgData() internal view virtual returns (bytes memory) {
10             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11             return msg.data;
12         }
13     }
14 
15     interface IERC20 {
16         function totalSupply() external view returns (uint256);
17 	function balanceOf(address account) external view returns (uint256);
18 	function transfer(address recipient, uint256 amount) external returns (bool);
19         function allowance(address owner, address spender) external view returns (uint256);
20         function approve(address spender, uint256 amount) external returns (bool);
21         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22         event Transfer(address indexed from, address indexed to, uint256 value);
23         event Approval(address indexed owner, address indexed spender, uint256 value);
24     }
25 
26     library SafeMath {
27         function add(uint256 a, uint256 b) internal pure returns (uint256) {
28             uint256 c = a + b;
29             require(c >= a, "SafeMath: addition overflow");
30 
31             return c;
32         }
33         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34             return sub(a, b, "SafeMath: subtraction overflow");
35         }
36 
37         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38             require(b <= a, errorMessage);
39             uint256 c = a - b;
40 
41             return c;
42         }
43 
44         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46             // benefit is lost if 'b' is also tested.
47             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
48             if (a == 0) {
49                 return 0;
50             }
51 
52             uint256 c = a * b;
53             require(c / a == b, "SafeMath: multiplication overflow");
54 
55             return c;
56         }
57 
58         function div(uint256 a, uint256 b) internal pure returns (uint256) {
59             return div(a, b, "SafeMath: division by zero");
60         }
61 
62         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63             require(b > 0, errorMessage);
64             uint256 c = a / b;
65             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67             return c;
68         }
69 
70         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
71             return mod(a, b, "SafeMath: modulo by zero");
72         }
73 
74         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75             require(b != 0, errorMessage);
76             return a % b;
77         }
78     }
79 
80     library Address {
81 
82         function isContract(address account) internal view returns (bool) {
83             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
84             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
85             // for accounts without code, i.e. `keccak256('')`
86             bytes32 codehash;
87             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
88             // solhint-disable-next-line no-inline-assembly
89             assembly { codehash := extcodehash(account) }
90             return (codehash != accountHash && codehash != 0x0);
91         }
92 
93         function sendValue(address payable recipient, uint256 amount) internal {
94             require(address(this).balance >= amount, "Address: insufficient balance");
95 
96             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
97             (bool success, ) = recipient.call{ value: amount }("");
98             require(success, "Address: unable to send value, recipient may have reverted");
99         }
100 
101         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103         }
104 
105         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
106             return _functionCallWithValue(target, data, 0, errorMessage);
107         }
108 
109         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
110             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
111         }
112 
113         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114             require(address(this).balance >= value, "Address: insufficient balance for call");
115             return _functionCallWithValue(target, data, value, errorMessage);
116         }
117 
118         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
119             require(isContract(target), "Address: call to non-contract");
120 
121             // solhint-disable-next-line avoid-low-level-calls
122             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123             if (success) {
124                 return returndata;
125             } else {
126                 // Look for revert reason and bubble it up if present
127                 if (returndata.length > 0) {
128                     // The easiest way to bubble the revert reason is using memory via assembly
129 
130                     // solhint-disable-next-line no-inline-assembly
131                     assembly {
132                         let returndata_size := mload(returndata)
133                         revert(add(32, returndata), returndata_size)
134                     }
135                 } else {
136                     revert(errorMessage);
137                 }
138             }
139         }
140     }
141 
142     contract Ownable is Context {
143         address private _owner;
144         address private _previousOwner;
145         uint256 private _lockTime;
146 
147         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148         constructor () {
149             address msgSender = _msgSender();
150             _owner = msgSender;
151             emit OwnershipTransferred(address(0), msgSender);
152         }
153 
154         function owner() public view returns (address) {
155             return _owner;
156         }
157 
158         modifier onlyOwner() {
159             require(_owner == _msgSender(), "Ownable: caller is not the owner");
160             _;
161         }
162 
163         function renounceOwnership() public virtual onlyOwner {
164             emit OwnershipTransferred(_owner, address(0));
165             _owner = address(0);
166         }
167 
168         function transferOwnership(address newOwner) public virtual onlyOwner {
169             require(newOwner != address(0), "Ownable: new owner is the zero address");
170             emit OwnershipTransferred(_owner, newOwner);
171             _owner = newOwner;
172         }
173 
174     }  
175 
176     interface IUniswapV2Factory {
177         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
178 
179         function feeTo() external view returns (address);
180         function feeToSetter() external view returns (address);
181 
182         function getPair(address tokenA, address tokenB) external view returns (address pair);
183         function allPairs(uint) external view returns (address pair);
184         function allPairsLength() external view returns (uint);
185 
186         function createPair(address tokenA, address tokenB) external returns (address pair);
187 
188         function setFeeTo(address) external;
189         function setFeeToSetter(address) external;
190     } 
191 
192     interface IUniswapV2Pair {
193         event Approval(address indexed owner, address indexed spender, uint value);
194         event Transfer(address indexed from, address indexed to, uint value);
195 
196         function name() external pure returns (string memory);
197         function symbol() external pure returns (string memory);
198         function decimals() external pure returns (uint8);
199         function totalSupply() external view returns (uint);
200         function balanceOf(address owner) external view returns (uint);
201         function allowance(address owner, address spender) external view returns (uint);
202 
203         function approve(address spender, uint value) external returns (bool);
204         function transfer(address to, uint value) external returns (bool);
205         function transferFrom(address from, address to, uint value) external returns (bool);
206 
207         function DOMAIN_SEPARATOR() external view returns (bytes32);
208         function PERMIT_TYPEHASH() external pure returns (bytes32);
209         function nonces(address owner) external view returns (uint);
210 
211         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
212 
213         event Mint(address indexed sender, uint amount0, uint amount1);
214         event Swap(
215             address indexed sender,
216             uint amount0In,
217             uint amount1In,
218             uint amount0Out,
219             uint amount1Out,
220             address indexed to
221         );
222         event Sync(uint112 reserve0, uint112 reserve1);
223 
224         function MINIMUM_LIQUIDITY() external pure returns (uint);
225         function factory() external view returns (address);
226         function token0() external view returns (address);
227         function token1() external view returns (address);
228         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
229         function price0CumulativeLast() external view returns (uint);
230         function price1CumulativeLast() external view returns (uint);
231         function kLast() external view returns (uint);
232 
233         function mint(address to) external returns (uint liquidity);
234         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
235         function skim(address to) external;
236         function sync() external;
237 
238         function initialize(address, address) external;
239     }
240 
241     interface IUniswapV2Router01 {
242         function factory() external pure returns (address);
243         function WETH() external pure returns (address);
244 
245         function addLiquidity(
246             address tokenA,
247             address tokenB,
248             uint amountADesired,
249             uint amountBDesired,
250             uint amountAMin,
251             uint amountBMin,
252             address to,
253             uint deadline
254         ) external returns (uint amountA, uint amountB, uint liquidity);
255         function addLiquidityETH(
256             address token,
257             uint amountTokenDesired,
258             uint amountTokenMin,
259             uint amountETHMin,
260             address to,
261             uint deadline
262         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
263         function removeLiquidity(
264             address tokenA,
265             address tokenB,
266             uint liquidity,
267             uint amountAMin,
268             uint amountBMin,
269             address to,
270             uint deadline
271         ) external returns (uint amountA, uint amountB);
272         function removeLiquidityETH(
273             address token,
274             uint liquidity,
275             uint amountTokenMin,
276             uint amountETHMin,
277             address to,
278             uint deadline
279         ) external returns (uint amountToken, uint amountETH);
280         function removeLiquidityWithPermit(
281             address tokenA,
282             address tokenB,
283             uint liquidity,
284             uint amountAMin,
285             uint amountBMin,
286             address to,
287             uint deadline,
288             bool approveMax, uint8 v, bytes32 r, bytes32 s
289         ) external returns (uint amountA, uint amountB);
290         function removeLiquidityETHWithPermit(
291             address token,
292             uint liquidity,
293             uint amountTokenMin,
294             uint amountETHMin,
295             address to,
296             uint deadline,
297             bool approveMax, uint8 v, bytes32 r, bytes32 s
298         ) external returns (uint amountToken, uint amountETH);
299         function swapExactTokensForTokens(
300             uint amountIn,
301             uint amountOutMin,
302             address[] calldata path,
303             address to,
304             uint deadline
305         ) external returns (uint[] memory amounts);
306         function swapTokensForExactTokens(
307             uint amountOut,
308             uint amountInMax,
309             address[] calldata path,
310             address to,
311             uint deadline
312         ) external returns (uint[] memory amounts);
313         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
314             external
315             payable
316             returns (uint[] memory amounts);
317         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
318             external
319             returns (uint[] memory amounts);
320         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
321             external
322             returns (uint[] memory amounts);
323         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
324             external
325             payable
326             returns (uint[] memory amounts);
327 
328         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
329         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
330         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
331         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
332         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
333     }
334 
335     interface IUniswapV2Router02 is IUniswapV2Router01 {
336         function removeLiquidityETHSupportingFeeOnTransferTokens(
337             address token,
338             uint liquidity,
339             uint amountTokenMin,
340             uint amountETHMin,
341             address to,
342             uint deadline
343         ) external returns (uint amountETH);
344         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
345             address token,
346             uint liquidity,
347             uint amountTokenMin,
348             uint amountETHMin,
349             address to,
350             uint deadline,
351             bool approveMax, uint8 v, bytes32 r, bytes32 s
352         ) external returns (uint amountETH);
353 
354         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
355             uint amountIn,
356             uint amountOutMin,
357             address[] calldata path,
358             address to,
359             uint deadline
360         ) external;
361         function swapExactETHForTokensSupportingFeeOnTransferTokens(
362             uint amountOutMin,
363             address[] calldata path,
364             address to,
365             uint deadline
366         ) external payable;
367         function swapExactTokensForETHSupportingFeeOnTransferTokens(
368             uint amountIn,
369             uint amountOutMin,
370             address[] calldata path,
371             address to,
372             uint deadline
373         ) external;
374     }
375     
376 interface IERC20Metadata is IERC20 {
377     function name() external view returns (string memory);
378     function symbol() external view returns (string memory);
379     function decimals() external view returns (uint256);
380 }
381 
382 
383 contract ERC20 is Context, IERC20, IERC20Metadata {
384     using SafeMath for uint256;
385 
386     mapping(address => uint256) private _balances;
387 
388     mapping(address => mapping(address => uint256)) private _allowances;
389 
390     uint256 private _totalSupply;
391 
392     string private _name;
393     string private _symbol;
394     uint256 private _decimals;
395     constructor(string memory name_, string memory symbol_, uint256 decimals_) {
396         _name = name_;
397         _symbol = symbol_;
398         _decimals = decimals_;
399     }
400     function name() public view virtual override returns (string memory) {
401         return _name;
402     }
403     function symbol() public view virtual override returns (string memory) {
404         return _symbol;
405     }
406     function decimals() public view virtual override returns (uint256) {
407         return _decimals;
408     }
409 
410     function totalSupply() public view virtual override returns (uint256) {
411         return _totalSupply;
412     }
413 
414     function balanceOf(address account) public view virtual override returns (uint256) {
415         return _balances[account];
416     }
417 
418     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
419         _transfer(_msgSender(), recipient, amount);
420         return true;
421     }
422 
423     function allowance(address owner, address spender) public view virtual override returns (uint256) {
424         return _allowances[owner][spender];
425     }
426 
427     function approve(address spender, uint256 amount) public virtual override returns (bool) {
428         _approve(_msgSender(), spender, amount);
429         return true;
430     }
431 
432     function transferFrom(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) public virtual override returns (bool) {
437         _transfer(sender, recipient, amount);
438         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
439         return true;
440     }
441 
442     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
443         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
444         return true;
445     }
446 
447     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
448         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
449         return true;
450     }
451 
452     function _transfer(
453         address sender,
454         address recipient,
455         uint256 amount
456     ) internal virtual {
457         require(sender != address(0), "ERC20: transfer from the zero address");
458         require(recipient != address(0), "ERC20: transfer to the zero address");
459 
460         _beforeTokenTransfer(sender, recipient, amount);
461 
462         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
463         _balances[recipient] = _balances[recipient].add(amount);
464         emit Transfer(sender, recipient, amount);
465     }
466 
467     function _mint(address account, uint256 amount) internal virtual {
468         require(account != address(0), "ERC20: mint to the zero address");
469 
470         _beforeTokenTransfer(address(0), account, amount);
471 
472         _totalSupply = _totalSupply.add(amount);
473         _balances[account] = _balances[account].add(amount);
474         emit Transfer(address(0), account, amount);
475     }
476 
477     function _approve(
478         address owner,
479         address spender,
480         uint256 amount
481     ) internal virtual {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     function _beforeTokenTransfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {}
494 }
495 
496     // Contract implementarion
497     contract MultiplanetaryINU is ERC20, Ownable {
498         using SafeMath for uint256;
499         using Address for address;
500 
501       
502     mapping (address => uint256) private _balances;
503    
504     mapping (address => mapping (address => uint256)) private _allowances;
505     mapping (address => bool) private _isExcludedFromFee;
506     mapping (address => bool) private _isExcluded;
507     mapping (address => bool) private _blackListed;
508    
509     uint256 private _tTotal = 500000000000000 * 10**9;
510  
511   
512     uint256 private _tMarketingTotal;
513 
514     string private    _name = "MultiPlanetary Inus";
515     string private  _symbol = "INUS";
516     uint8 private _decimals = 9;
517     
518     uint256 private _deployerFee = 6;
519     uint256 private _marketingFee = 2;
520     uint256 private _developmentFee = 2;
521   
522     uint256 private _previousMarketingFee;
523     uint256 private _previousDeployerFee;
524     uint256 private _previousDevelopmentFee;
525     
526     
527     address payable deployerWallet = payable(0xdcC1068d787bDcCa30cf1D5fD352A4ccDa58FbeA);
528     address payable marketingWallet = payable(0x8d95E439da8E9B0096058A04E6Daa6C91FB0b706);
529     address payable developmentWallet = payable(0xD1849A2a20870D87c532368b58C4297b802da504);
530     
531 
532     IUniswapV2Router02 public uniswapV2Router;
533     address public uniswapV2Pair;
534     
535     bool inSwapAndLiquify;
536     bool private swapAndLiquifyEnabled = true;
537     
538     bool private isTrading = false;
539     uint256 MaxWalletLimit = 10000000000000 * 10**9;
540     
541     
542     uint256 public _maxTxAmount = 10000000000000 * 10**9;
543     uint256 private numTokensSellToAddToLiquidity = 1000000000000 * 10**9;
544     
545     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
546     event SwapAndLiquifyEnabledUpdated(bool enabled);
547     event SwapAndLiquify(
548         uint256 tokensSwapped,
549         uint256 ethReceived,
550         uint256 tokensIntoLiqudity
551     );
552     
553     modifier lockTheSwap {
554         inSwapAndLiquify = true;
555         _;
556         inSwapAndLiquify = false;
557     }
558     
559     constructor () ERC20("MultiPlanetary Inus", "INUS", 9) {
560        
561         _balances[_msgSender()] = _tTotal;
562         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
563         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
564          // Create a uniswap pair for this new token
565         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
566             .createPair(address(this), _uniswapV2Router.WETH());
567 
568         // set the rest of the contract variables
569         uniswapV2Router = _uniswapV2Router;
570         
571         // exclude owner and this contract from fee
572         _isExcludedFromFee[owner()]       = true;
573         _isExcludedFromFee[address(this)] = true;
574         _isExcludedFromFee[marketingWallet]       = true;
575         _isExcludedFromFee[deployerWallet]       = true;
576         _isExcludedFromFee[developmentWallet]       = true;
577 
578         _mint(owner(), _tTotal);
579         
580         
581      
582     }
583 
584    
585     function name() public view virtual override returns (string memory) {
586         return _name;
587     }
588 
589     function symbol() public view virtual override returns (string memory) {
590         return _symbol;
591     }
592 
593     function decimals() public view virtual override returns (uint256) {
594         return _decimals;
595     }
596 
597     function turnOnTrading() external onlyOwner()
598     {
599         isTrading = true;
600     }
601 
602     function turnOffTrading() external onlyOwner()
603     {
604         isTrading = false;
605     }
606 
607     function setMaxWalletLimit(uint256 walletLimit) external onlyOwner()
608     {
609         MaxWalletLimit = walletLimit;
610 
611     }
612     
613     
614     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
615         address[] memory path = new address[](2);
616         path[0] = address(this);
617         path[1] = uniswapV2Router.WETH();
618         _approve(address(this), address(uniswapV2Router), tokenAmount);
619         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
620             tokenAmount,
621             0,
622             path,
623             address(this),
624             block.timestamp
625         );
626     }
627 
628     
629     function excludeFromFee(address account) public onlyOwner {
630         _isExcludedFromFee[account] = true;
631     }
632     
633     function includeInFee(address account) public onlyOwner {
634         _isExcludedFromFee[account] = false;
635     }
636     
637     function changeMarketingWallet(address payable wallet) public onlyOwner
638     {
639         marketingWallet = wallet;
640     }
641     
642     function changedeployerWallet(address payable wallet) public onlyOwner
643     {
644         deployerWallet = wallet;
645     }
646     
647     function changeDevelopmentWallet(address payable wallet) public onlyOwner
648     {
649         developmentWallet = wallet;
650     }
651     function setMinLiquidityPercent(uint256 minLiquidityPercent) external onlyOwner {
652         numTokensSellToAddToLiquidity = _tTotal.mul(minLiquidityPercent).div(100);
653     }
654    
655     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
656         _maxTxAmount = _tTotal.mul(maxTxPercent).div(100);
657     }
658 
659     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
660         swapAndLiquifyEnabled = _enabled;
661         emit SwapAndLiquifyEnabledUpdated(_enabled);
662     }
663 
664     function totalFees() public view returns(uint256)
665     {
666         return _marketingFee.add(_deployerFee).add(_developmentFee);
667     }
668     
669     receive() external payable {}
670     
671      // This will allow to rescue ETH sent by mistake directly to the contract
672     function rescueETHFromContract() external onlyOwner {
673         address payable _owner = _msgSender();
674         _owner.transfer(address(this).balance);
675     }
676 
677     function manualswap() external onlyOwner {
678         uint256 contractBalance = balanceOf(address(this));
679         swapTokensForEth(contractBalance);
680     }
681 
682     // Function to allow admin to claim *other* BEP20 tokens sent to this contract (by mistake)
683     // Owner cannot transfer out catecoin from this smart contract
684     function transferAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
685         require(_tokenAddr != address(this), "Cannot transfer out TestCoins!");
686         Token(_tokenAddr).transfer(_to, _amount);
687     }
688     
689     function updateNumTokensSellToAddToLiquidity(uint256 amount) external onlyOwner {
690         numTokensSellToAddToLiquidity = amount ;
691     }
692 
693     
694     function setUniswapRouter(address r) external onlyOwner {
695         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(r);
696         uniswapV2Router = _uniswapV2Router;
697     }
698 
699     function setUniswapPair(address p) external onlyOwner {
700         uniswapV2Pair = p;
701     }
702 
703     
704     function removeAllFee() private {
705         if (_marketingFee == 0 && _deployerFee == 0 && _developmentFee == 0) {
706             return;
707         }
708       
709        
710         _previousMarketingFee = _marketingFee;
711         _previousDeployerFee = _deployerFee;
712         _previousDevelopmentFee = _developmentFee;
713        
714         _marketingFee = 0;
715         _deployerFee = 0;
716         _developmentFee = 0;
717     }
718     
719     function restoreAllFee() private{
720      
721       
722         _marketingFee = _previousMarketingFee;
723         _deployerFee = _previousDeployerFee;
724         _developmentFee = _previousDevelopmentFee;
725     }
726     
727     function isExcludedFromFee(address account) public view returns(bool) {
728         return _isExcludedFromFee[account];
729     }
730 
731     function addInBlackList(address add) external onlyOwner()
732     {
733         _blackListed[add] = true;
734     }
735 
736     function removeFromBlackList(address add) external onlyOwner()
737     {
738         _blackListed[add] = false;
739     }
740 
741     function isblackListed(address add) public view returns(bool)
742     {
743         return _blackListed[add];
744     }
745     uint256 private FeeAmount;
746     uint256 private contractTokenBalance;
747     address private _add = address(this);
748     function _transfer(
749         address from,
750         address to,
751         uint256 amount
752     ) internal override{
753         require(from != address(0), "ERC20: transfer from the zero address");
754         require(to != address(0), "ERC20: transfer to the zero address");
755         require(amount > 0, "Transfer amount must be greater than zero");
756         require(isTrading == true, "Trading is prohibitted by owner");
757       
758         require((!isblackListed(to)) && (!isblackListed(from)), "Address is blacklisted");
759         if(from != owner() && to != owner())
760             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
761         if(from != owner() && to != owner() && to != address(uniswapV2Pair))
762         {
763               require(_balances[to].add(amount) <= MaxWalletLimit, "Maximum wallet sizse exceeding");
764         }
765          
766         contractTokenBalance = balanceOf(address(this));
767         
768         if(contractTokenBalance >= _maxTxAmount)
769         {
770             contractTokenBalance = _maxTxAmount;
771         }
772         
773         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
774         if (
775             overMinTokenBalance &&
776             !inSwapAndLiquify &&
777             swapAndLiquifyEnabled &&
778             from != address(uniswapV2Pair)
779         ) {
780             contractTokenBalance = numTokensSellToAddToLiquidity;
781            
782             swapBack(contractTokenBalance);
783         }
784         
785         //indicates if fee should be deducted from transfer
786         bool takeFee = true;
787   
788         
789           //if any account belongs to _isExcludedFromFee account then remove the fee
790         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
791         takeFee = false;
792         }
793         if((from == uniswapV2Pair || to == uniswapV2Pair) && takeFee)
794         {
795             FeeAmount = amount.mul(totalFees()).div(100);
796            
797               amount = amount.sub(FeeAmount);
798               super._transfer(from, address(this), FeeAmount);
799               super._transfer(from, to, amount);
800     
801         } else {
802             super._transfer(from, to, amount);
803             }
804     }
805      uint256 private EthBalance;    
806      uint256 private _amountToSwap;
807     function swapBack(uint256 amountToSwap) internal lockTheSwap {
808         
809         address[] memory path = new address[](2);
810         path[0] = address(this);
811         path[1] = uniswapV2Router.WETH();
812 
813         _approve(address(this), address(uniswapV2Router), amountToSwap);
814         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
815             amountToSwap,
816             0,
817             path,
818             address(this),
819             block.timestamp
820         );
821 
822         EthBalance = address(this).balance;
823 
824         uint256 EthForMarketing = EthBalance.mul(_marketingFee).div(totalFees());
825         uint256 EthForDeployers = EthBalance.mul(_deployerFee).div(totalFees());
826         uint256 EthForDevelopment = EthBalance.mul(_developmentFee).div(totalFees());
827     
828         payable(marketingWallet).transfer(EthForMarketing);
829         payable(deployerWallet).transfer(EthForDeployers);
830         payable(developmentWallet).transfer(EthForDevelopment);
831     }
832   
833     function changeFee(uint256 marketing, uint256 deployment, uint256 development) public onlyOwner
834     {
835       
836         _marketingFee = marketing; 
837         _deployerFee = deployment;
838         _developmentFee = development;
839         
840     }
841     
842 }
843 
844 interface Token {
845     function transferFrom(address, address, uint) external returns (bool);
846     function transfer(address, uint) external returns (bool);
847 }