1 /**
2  ██████╗██████╗ ███╗   ██╗ ██████╗ 
3 ██╔════╝██╔══██╗████╗  ██║██╔═══██╗
4 ██║     ██████╔╝██╔██╗ ██║██║   ██║
5 ██║     ██╔══██╗██║╚██╗██║██║   ██║
6 ╚██████╗██║  ██║██║ ╚████║╚██████╔╝
7  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
8 */
9 
10 //SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.13;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint);
16     function balanceOf(address account) external view returns (uint);
17     function transfer(address recipient, uint amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint);
19     function approve(address spender, uint amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint value);
22     event Approval(address indexed owner, address indexed spender, uint value);
23 }
24 library SafeMath {
25     function add(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31     function sub(uint a, uint b) internal pure returns (uint) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
35         require(b <= a, errorMessage);
36         uint c = a - b;
37 
38         return c;
39     }
40     function mul(uint a, uint b) internal pure returns (uint) {
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47 
48         return c;
49     }
50     function div(uint a, uint b) internal pure returns (uint) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0, errorMessage);
56         uint c = a / b;
57 
58         return c;
59     }
60 }
61 
62 contract Context {
63     constructor () { }
64     // solhint-disable-previous-line no-empty-blocks
65 
66     function _msgSender() internal view returns (address) {
67         return msg.sender;
68     }
69 }
70 
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor () {
80        
81         _owner = msg.sender ;
82         emit OwnershipTransferred(address(0), _owner);
83     }
84 
85     /**
86      * @dev Returns the address of the current owner.
87      */
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     /**
93      * @dev Throws if called by any account other than the owner.
94      */
95     modifier onlyOwner() {
96         require(_owner == _msgSender() , "Ownable: caller is not the owner");
97         _;
98     }
99 
100     /**
101      * @dev Leaves the contract without owner. It will not be possible to call
102      * `onlyOwner` functions anymore. Can only be called by the current owner.
103      *
104      * NOTE: Renouncing ownership will leave the contract without an owner,
105      * thereby removing any functionality that is only available to the owner.
106      */
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Can only be called by the current owner.
115      */
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(newOwner != address(0), "Ownable: new owner is the zero address");
118         emit OwnershipTransferred(_owner, newOwner);
119         _owner = newOwner;
120     }
121 }
122 
123 
124 contract ERC20Detailed {
125     string private _name;
126     string private _symbol;
127     uint8 private _decimals;
128 
129     constructor (string memory tname, string memory tsymbol, uint8 tdecimals) {
130         _name = tname;
131         _symbol = tsymbol;
132         _decimals = tdecimals;
133         
134     }
135     function name() public view returns (string memory) {
136         return _name;
137     }
138     function symbol() public view returns (string memory) {
139         return _symbol;
140     }
141     function decimals() public view returns (uint8) {
142         return _decimals;
143     }
144 }
145 
146 
147 
148 library Address {
149     function isContract(address account) internal view returns (bool) {
150         bytes32 codehash;
151         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
152         // solhint-disable-next-line no-inline-assembly
153         assembly { codehash := extcodehash(account) }
154         return (codehash != 0x0 && codehash != accountHash);
155     }
156 }
157 
158 library SafeERC20 {
159     using SafeMath for uint;
160     using Address for address;
161 
162     function safeTransfer(IERC20 token, address to, uint value) internal {
163         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
164     }
165 
166     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
167         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
168     }
169 
170     function safeApprove(IERC20 token, address spender, uint value) internal {
171         require((value == 0) || (token.allowance(address(this), spender) == 0),
172             "SafeERC20: approve from non-zero to non-zero allowance"
173         );
174         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
175     }
176     function callOptionalReturn(IERC20 token, bytes memory data) private {
177         require(address(token).isContract(), "SafeERC20: call to non-contract");
178 
179         // solhint-disable-next-line avoid-low-level-calls
180         (bool success, bytes memory returndata) = address(token).call(data);
181         require(success, "SafeERC20: low-level call failed");
182 
183         if (returndata.length > 0) { // Return data is optional
184             // solhint-disable-next-line max-line-length
185             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
186         }
187     }
188 }
189 
190 interface IUniswapV2Factory {
191     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
192 
193     function feeTo() external view returns (address);
194     function feeToSetter() external view returns (address);
195 
196     function getPair(address tokenA, address tokenB) external view returns (address pair);
197     function allPairs(uint) external view returns (address pair);
198     function allPairsLength() external view returns (uint);
199 
200     function createPair(address tokenA, address tokenB) external returns (address pair);
201 
202     function setFeeTo(address) external;
203     function setFeeToSetter(address) external;
204 }
205 
206 
207 interface IUniswapV2Pair {
208     event Approval(address indexed owner, address indexed spender, uint value);
209     event Transfer(address indexed from, address indexed to, uint value);
210 
211     function name() external pure returns (string memory);
212     function symbol() external pure returns (string memory);
213     function decimals() external pure returns (uint8);
214     function totalSupply() external view returns (uint);
215     function balanceOf(address owner) external view returns (uint);
216     function allowance(address owner, address spender) external view returns (uint);
217 
218     function approve(address spender, uint value) external returns (bool);
219     function transfer(address to, uint value) external returns (bool);
220     function transferFrom(address from, address to, uint value) external returns (bool);
221 
222     function DOMAIN_SEPARATOR() external view returns (bytes32);
223     function PERMIT_TYPEHASH() external pure returns (bytes32);
224     function nonces(address owner) external view returns (uint);
225 
226     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
227 
228     event Mint(address indexed sender, uint amount0, uint amount1);
229     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
230     event Swap(
231         address indexed sender,
232         uint amount0In,
233         uint amount1In,
234         uint amount0Out,
235         uint amount1Out,
236         address indexed to
237     );
238     event Sync(uint112 reserve0, uint112 reserve1);
239 
240     function MINIMUM_LIQUIDITY() external pure returns (uint);
241     function factory() external view returns (address);
242     function token0() external view returns (address);
243     function token1() external view returns (address);
244     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
245     function price0CumulativeLast() external view returns (uint);
246     function price1CumulativeLast() external view returns (uint);
247     function kLast() external view returns (uint);
248 
249     function mint(address to) external returns (uint liquidity);
250     function burn(address to) external returns (uint amount0, uint amount1);
251     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
252     function skim(address to) external;
253     function sync() external;
254 
255     function initialize(address, address) external;
256 }
257 
258 
259 
260 interface IUniswapV2Router01 {
261     function factory() external pure returns (address);
262     function WETH() external pure returns (address);
263 
264     function addLiquidity(
265         address tokenA,
266         address tokenB,
267         uint amountADesired,
268         uint amountBDesired,
269         uint amountAMin,
270         uint amountBMin,
271         address to,
272         uint deadline
273     ) external returns (uint amountA, uint amountB, uint liquidity);
274     function addLiquidityETH(
275         address token,
276         uint amountTokenDesired,
277         uint amountTokenMin,
278         uint amountETHMin,
279         address to,
280         uint deadline
281     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
282     function removeLiquidity(
283         address tokenA,
284         address tokenB,
285         uint liquidity,
286         uint amountAMin,
287         uint amountBMin,
288         address to,
289         uint deadline
290     ) external returns (uint amountA, uint amountB);
291     function removeLiquidityETH(
292         address token,
293         uint liquidity,
294         uint amountTokenMin,
295         uint amountETHMin,
296         address to,
297         uint deadline
298     ) external returns (uint amountToken, uint amountETH);
299     function removeLiquidityWithPermit(
300         address tokenA,
301         address tokenB,
302         uint liquidity,
303         uint amountAMin,
304         uint amountBMin,
305         address to,
306         uint deadline,
307         bool approveMax, uint8 v, bytes32 r, bytes32 s
308     ) external returns (uint amountA, uint amountB);
309     function removeLiquidityETHWithPermit(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline,
316         bool approveMax, uint8 v, bytes32 r, bytes32 s
317     ) external returns (uint amountToken, uint amountETH);
318     function swapExactTokensForTokens(
319         uint amountIn,
320         uint amountOutMin,
321         address[] calldata path,
322         address to,
323         uint deadline
324     ) external returns (uint[] memory amounts);
325     function swapTokensForExactTokens(
326         uint amountOut,
327         uint amountInMax,
328         address[] calldata path,
329         address to,
330         uint deadline
331     ) external returns (uint[] memory amounts);
332     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
333         external
334         payable
335         returns (uint[] memory amounts);
336     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
337         external
338         returns (uint[] memory amounts);
339     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
340         external
341         returns (uint[] memory amounts);
342     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
343         external
344         payable
345         returns (uint[] memory amounts);
346 
347     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
348     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
349     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
350     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
351     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
352 }
353 
354 interface IUniswapV2Router02 is IUniswapV2Router01 {
355     function removeLiquidityETHSupportingFeeOnTransferTokens(
356         address token,
357         uint liquidity,
358         uint amountTokenMin,
359         uint amountETHMin,
360         address to,
361         uint deadline
362     ) external returns (uint amountETH);
363     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
364         address token,
365         uint liquidity,
366         uint amountTokenMin,
367         uint amountETHMin,
368         address to,
369         uint deadline,
370         bool approveMax, uint8 v, bytes32 r, bytes32 s
371     ) external returns (uint amountETH);
372 
373     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
374         uint amountIn,
375         uint amountOutMin,
376         address[] calldata path,
377         address to,
378         uint deadline
379     ) external;
380     function swapExactETHForTokensSupportingFeeOnTransferTokens(
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external payable;
386     function swapExactTokensForETHSupportingFeeOnTransferTokens(
387         uint amountIn,
388         uint amountOutMin,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external;
393 }
394 
395 
396 contract CRNOTOKEN is Context, Ownable, IERC20, ERC20Detailed {
397   using SafeERC20 for IERC20;
398   using Address for address;
399   using SafeMath for uint256;
400   
401     IUniswapV2Router02 public immutable uniswapV2Router;
402     address public immutable uniswapV2Pair;
403     
404     mapping (address => uint) internal _balances;
405     mapping (address => mapping (address => uint)) internal _allowances;
406     mapping (address => bool) private _isExcludedFromFee;
407     address[] public lotteryEligibles;   
408     uint256 internal _totalSupply;
409 
410     uint256 public lotteryEligibilityLimit = 100 * 10**18;
411 
412     uint256 private marketingFee;
413     uint256 private rewardFee;
414     uint256 private burnFee;
415     uint256 private liquidityFee;
416     uint256 private totalFee;
417 
418     uint256 public BUYmarketingFee = 2;
419     uint256 public BUYrewardFee = 2;
420     uint256 public BUYburnFee = 1;
421     uint256 public BUYliquidityFee = 1;
422     uint256 public BUYtotalFee = BUYliquidityFee.add(BUYmarketingFee).add(BUYrewardFee).add(BUYburnFee);
423 
424     uint256 public SELLmarketingFee = 6;
425     uint256 public SELLrewardFee = 3;
426     uint256 public SELLburnFee = 1;
427     uint256 public SELLliquidityFee = 2;
428     uint256 public SELLtotalFee = SELLliquidityFee.add(SELLmarketingFee).add(SELLrewardFee).add(SELLburnFee);
429 
430 
431     address payable public marketingaddress = payable(0x64fBA66D58442bE0605d3f44b8680B566f667505);
432     address payable public rewardAddress = payable(0xc69DA5a56a5c0e9d34d35C88e9619008BA5e5200);
433     
434     bool inSwapAndLiquify;
435     bool public swapAndLiquifyEnabled = true;
436    
437 
438     uint256 public numTokensSellToAddToLiquidity = 1000 * 10**18;
439     uint256 public maxTxAmount = 1000000 * 10**18;
440    
441     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
442     event SwapAndLiquifyEnabledUpdated(bool enabled);
443      event SwapAndLiquify(
444         uint256 tokensSwapped,
445         uint256 ethReceived,
446         uint256 tokensIntoLiqudity
447     );
448 
449     bool private swapping;
450     
451     
452     modifier lockTheSwap {
453         inSwapAndLiquify = true;
454         _;
455         inSwapAndLiquify = false;
456     }
457   
458     address public _owner;
459   
460     constructor () ERC20Detailed("Chronoly", "CRNO", 18) {
461       _owner = msg.sender ;
462     _totalSupply = 1000000000 * (10**18);
463     
464 	_balances[_owner] = _totalSupply;
465 	//uniswapv3 router = 0xE592427A0AEce92De3Edee1F18E0157C05861564
466 	 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
467          // Create a uniswap pair for this new token
468         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
469             .createPair(address(this), _uniswapV2Router.WETH());
470 
471         // set the rest of the contract variables
472         uniswapV2Router = _uniswapV2Router;
473 
474 
475           //exclude owner and this contract from fee
476         _isExcludedFromFee[owner()] = true;
477         _isExcludedFromFee[address(this)] = true;
478         _isExcludedFromFee[marketingaddress] = true;
479         _isExcludedFromFee[rewardAddress] = true;
480 
481      emit Transfer(address(0), _msgSender(), _totalSupply);
482   }
483   
484     function totalSupply() public view override returns (uint) {
485         return _totalSupply;
486     }
487     function balanceOf(address account) public view override returns (uint) {
488         return _balances[account];
489     }
490     function transfer(address recipient, uint amount) public override  returns (bool) {
491         _transfer(_msgSender(), recipient, amount);
492         return true;
493     }
494     function allowance(address towner, address spender) public view override returns (uint) {
495         return _allowances[towner][spender];
496     }
497     function approve(address spender, uint amount) public override returns (bool) {
498         _approve(_msgSender(), spender, amount);
499         return true;
500     }
501     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
502         _transfer(sender, recipient, amount);
503         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
504         return true;
505     }
506     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
508         return true;
509     }
510     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
512         return true;
513     }
514 
515     function setMarketingAddress(address payable wallet) external onlyOwner
516     {
517         marketingaddress = wallet;
518     }
519 
520     function setRewardAddress(address payable wallet) external onlyOwner
521     {
522         rewardAddress = wallet;
523     }
524 
525     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
526         swapAndLiquifyEnabled = _enabled;
527         emit SwapAndLiquifyEnabledUpdated(_enabled);
528     }
529 
530     function changeNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity) external onlyOwner
531     {
532         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
533     }
534     function excludeFromFee(address account) public onlyOwner {
535         _isExcludedFromFee[account] = true;
536     }
537     
538     function includeInFee(address account) public onlyOwner {
539         _isExcludedFromFee[account] = false;
540     }
541 
542     function changeLotteryEligibilityLimit(uint256 _number) external onlyOwner
543     {
544         lotteryEligibilityLimit = _number;
545     }
546 
547         function changeMaxTxLimit(uint256 _number) external onlyOwner
548     {
549         maxTxAmount = _number;
550     }
551    
552      //to recieve ETH from uniswapV2Router when swaping
553     receive() external payable {}
554     function _transfer(address sender, address recipient, uint amount) internal{
555 
556         require(sender != address(0), "ERC20: transfer from the zero address");
557         require(recipient != address(0), "ERC20: transfer to the zero address");
558         if(sender != owner() && recipient != owner())
559         {
560             require(amount <= maxTxAmount, "Transaction size limit reached");
561         }
562 
563         // is the token balance of this contract address over the min number of
564         // tokens that we need to initiate a swap + liquidity lock?
565         // also, don't get caught in a circular liquidity event.
566         // also, don't swap & liquify if sender is uniswap pair.
567         uint256 contractTokenBalance = balanceOf(address(this));
568         
569 
570         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
571         if (
572             overMinTokenBalance &&
573             !swapping &&
574             sender != uniswapV2Pair &&
575             swapAndLiquifyEnabled
576         ) {
577             swapping = true;
578            
579             uint256 walletTokens = contractTokenBalance.mul(SELLmarketingFee.add(SELLrewardFee)).div(SELLtotalFee);
580             uint256 contractBalance = address(this).balance;
581             swapTokensForEth(walletTokens);
582             uint256 newBalance = address(this).balance.sub(contractBalance);
583             uint256 marketingShare = newBalance.mul(SELLmarketingFee).div(SELLrewardFee.add(SELLmarketingFee));
584             uint256 rewardShare = newBalance.sub(marketingShare);
585             payable(marketingaddress).transfer(marketingShare);
586             payable(rewardAddress).transfer(rewardShare);
587 
588             uint256 swapTokens = contractTokenBalance.mul(SELLliquidityFee).div(SELLtotalFee);
589             swapAndLiquify(swapTokens);
590 
591             swapping = false;
592 
593         }
594         
595          //indicates if fee should be deducted from transfer
596         bool takeFee = !swapping;
597         
598         //if any account belongs to _isExcludedFromFee account then remove the fee
599         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
600             takeFee = false;
601         }
602 
603         if(sender != uniswapV2Pair && recipient != uniswapV2Pair)
604         {
605             takeFee = false;
606         }
607         if(takeFee){
608         if(sender == uniswapV2Pair)
609         {
610             marketingFee = BUYmarketingFee;
611             rewardFee = BUYrewardFee;
612             liquidityFee = BUYliquidityFee;
613             burnFee = BUYburnFee;
614             totalFee = BUYtotalFee;
615            
616         }
617         if(recipient == uniswapV2Pair)
618         {
619             marketingFee = SELLmarketingFee;
620             rewardFee = SELLrewardFee;
621             liquidityFee = SELLliquidityFee;
622             burnFee = SELLburnFee;
623             totalFee = SELLtotalFee;
624 
625         }
626         }
627        
628         if(takeFee)
629         {
630             uint256 taxAmount = amount.mul(totalFee).div(100);
631             uint256 burnAmount = taxAmount.mul(burnFee).div(totalFee);
632             uint256 TotalSent = amount.sub(taxAmount);
633             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
634             _balances[recipient] = _balances[recipient].add(TotalSent);
635             _balances[address(this)] = _balances[address(this)].add(taxAmount);
636             _balances[address(0)] = _balances[address(0)].add(burnAmount);
637             emit Transfer(sender, recipient, TotalSent);
638             emit Transfer(sender, address(this), taxAmount);
639             emit Transfer(sender, address(0), burnAmount);
640         }
641         else
642         {
643             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
644             _balances[recipient] = _balances[recipient].add(amount);
645             emit Transfer(sender, recipient, amount);
646         }
647 
648         if(sender == uniswapV2Pair)
649         {
650              if(balanceOf(recipient) > lotteryEligibilityLimit)
651                 {lotteryEligibles.push(recipient);}
652         }
653        
654     }
655     uint256 public rand;
656     address public winner;
657     
658     function selectWinner() external onlyOwner
659     {
660         rand = random();
661         winner  = lotteryEligibles[rand];
662 
663     }
664 
665     function random() public view returns(uint256){
666         uint256 seed = uint256(keccak256(abi.encodePacked(
667         block.timestamp + block.difficulty +
668         ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
669         block.gaslimit + 
670         ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
671         block.number
672     )));
673 
674     return (seed - ((seed / lotteryEligibles.length) * lotteryEligibles.length));
675 
676 }
677 
678     function showWinner() external view returns(address)
679     {
680    // selectWinner();
681     return winner;
682     }
683 
684 
685      function swapAndLiquify(uint256 tokens) private lockTheSwap {
686        
687        // split the contract balance into halves
688         uint256 half = tokens.div(2);
689         uint256 otherHalf = tokens.sub(half);
690 
691         // capture the contract's current ETH balance.
692         // this is so that we can capture exactly the amount of ETH that the
693         // swap creates, and not make the liquidity event include any ETH that
694         // has been manually sent to the contract
695         uint256 initialBalance = address(this).balance;
696 
697         // swap tokens for ETH
698         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
699 
700         // how much ETH did we just swap into?
701         uint256 newBalance = address(this).balance.sub(initialBalance);
702 
703         // add liquidity to uniswap
704         addLiquidity(otherHalf, newBalance);
705 
706         emit SwapAndLiquify(half, newBalance, otherHalf);
707     }
708 
709       function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
710 
711         // approve token transfer to cover all possible scenarios
712         _approve(address(this), address(uniswapV2Router), tokenAmount);
713 
714         // add the liquidity
715         uniswapV2Router.addLiquidityETH{value: ethAmount}(
716             address(this),
717             tokenAmount,
718             0, // slippage is unavoidable
719             0, // slippage is unavoidable
720             owner(),
721             block.timestamp
722         );
723 
724     }
725 
726     function swapTokensForEth(uint256 tokenAmount) private {
727         // generate the uniswap pair path of token -> weth
728         address[] memory path = new address[](2);
729         path[0] = address(this);
730         path[1] = uniswapV2Router.WETH();
731 
732         _approve(address(this), address(uniswapV2Router), tokenAmount);
733 
734         // make the swap
735         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
736             tokenAmount,
737             0, // accept any amount of ETH
738             path,
739             address(this),
740             block.timestamp
741         );
742     }
743 
744     function _approve(address towner, address spender, uint amount) internal {
745         require(towner != address(0), "ERC20: approve from the zero address");
746         require(spender != address(0), "ERC20: approve to the zero address");
747 
748         _allowances[towner][spender] = amount;
749         emit Approval(towner, spender, amount);
750     }
751 
752   
753 }