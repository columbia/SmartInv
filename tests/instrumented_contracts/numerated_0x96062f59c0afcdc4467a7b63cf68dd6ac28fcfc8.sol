1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 interface IBEP20 {
6     function totalSupply() external view returns (uint);
7     function balanceOf(address account) external view returns (uint);
8     function transfer(address recipient, uint amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint);
10     function approve(address spender, uint amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint value);
13     event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint) {
17         uint c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22     function sub(uint a, uint b) internal pure returns (uint) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
26         require(b <= a, errorMessage);
27         uint c = a - b;
28 
29         return c;
30     }
31     function mul(uint a, uint b) internal pure returns (uint) {
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38 
39         return c;
40     }
41     function div(uint a, uint b) internal pure returns (uint) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
45         // Solidity only automatically asserts when dividing by 0
46         require(b > 0, errorMessage);
47         uint c = a / b;
48 
49         return c;
50     }
51 }
52 
53 contract Context {
54     constructor () { }
55     // solhint-disable-previous-line no-empty-blocks
56 
57     function _msgSender() internal view returns (address) {
58         return msg.sender;
59     }
60 }
61 
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor () {
71        
72         _owner = msg.sender ;
73         emit OwnershipTransferred(address(0), _owner);
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(_owner == _msgSender() , "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         emit OwnershipTransferred(_owner, newOwner);
110         _owner = newOwner;
111     }
112 }
113 
114 
115 
116 
117 contract BEP20Detailed {
118     string private _name;
119     string private _symbol;
120     uint8 private _decimals;
121 
122     constructor (string memory tname, string memory tsymbol, uint8 tdecimals) {
123         _name = tname;
124         _symbol = tsymbol;
125         _decimals = tdecimals;
126         
127     }
128     function name() public view returns (string memory) {
129         return _name;
130     }
131     function symbol() public view returns (string memory) {
132         return _symbol;
133     }
134     function decimals() public view returns (uint8) {
135         return _decimals;
136     }
137 }
138 
139 
140 
141 library Address {
142     function isContract(address account) internal view returns (bool) {
143         bytes32 codehash;
144         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
145         // solhint-disable-next-line no-inline-assembly
146         assembly { codehash := extcodehash(account) }
147         return (codehash != 0x0 && codehash != accountHash);
148     }
149 }
150 
151 library SafeBEP20 {
152     using SafeMath for uint;
153     using Address for address;
154 
155     function safeTransfer(IBEP20 token, address to, uint value) internal {
156         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
157     }
158 
159     function safeTransferFrom(IBEP20 token, address from, address to, uint value) internal {
160         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
161     }
162 
163     function safeApprove(IBEP20 token, address spender, uint value) internal {
164         require((value == 0) || (token.allowance(address(this), spender) == 0),
165             "SafeBEP20: approve from non-zero to non-zero allowance"
166         );
167         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
168     }
169     function callOptionalReturn(IBEP20 token, bytes memory data) private {
170         require(address(token).isContract(), "SafeBEP20: call to non-contract");
171 
172         // solhint-disable-next-line avoid-low-level-calls
173         (bool success, bytes memory returndata) = address(token).call(data);
174         require(success, "SafeBEP20: low-level call failed");
175 
176         if (returndata.length > 0) { // Return data is optional
177             // solhint-disable-next-line max-line-length
178             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
179         }
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
199 
200 interface IUniswapV2Pair {
201     event Approval(address indexed owner, address indexed spender, uint value);
202     event Transfer(address indexed from, address indexed to, uint value);
203 
204     function name() external pure returns (string memory);
205     function symbol() external pure returns (string memory);
206     function decimals() external pure returns (uint8);
207     function totalSupply() external view returns (uint);
208     function balanceOf(address owner) external view returns (uint);
209     function allowance(address owner, address spender) external view returns (uint);
210 
211     function approve(address spender, uint value) external returns (bool);
212     function transfer(address to, uint value) external returns (bool);
213     function transferFrom(address from, address to, uint value) external returns (bool);
214 
215     function DOMAIN_SEPARATOR() external view returns (bytes32);
216     function PERMIT_TYPEHASH() external pure returns (bytes32);
217     function nonces(address owner) external view returns (uint);
218 
219     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
220 
221     event Mint(address indexed sender, uint amount0, uint amount1);
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
242     function mint(address to) external returns (uint liquidity);
243     function burn(address to) external returns (uint amount0, uint amount1);
244     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
245     function skim(address to) external;
246     function sync() external;
247 
248     function initialize(address, address) external;
249 }
250 
251 
252 
253 interface IUniswapV2Router01 {
254     function factory() external pure returns (address);
255     function WETH() external pure returns (address);
256 
257     function addLiquidity(
258         address tokenA,
259         address tokenB,
260         uint amountADesired,
261         uint amountBDesired,
262         uint amountAMin,
263         uint amountBMin,
264         address to,
265         uint deadline
266     ) external returns (uint amountA, uint amountB, uint liquidity);
267     function addLiquidityETH(
268         address token,
269         uint amountTokenDesired,
270         uint amountTokenMin,
271         uint amountETHMin,
272         address to,
273         uint deadline
274     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
275     function removeLiquidity(
276         address tokenA,
277         address tokenB,
278         uint liquidity,
279         uint amountAMin,
280         uint amountBMin,
281         address to,
282         uint deadline
283     ) external returns (uint amountA, uint amountB);
284     function removeLiquidityETH(
285         address token,
286         uint liquidity,
287         uint amountTokenMin,
288         uint amountETHMin,
289         address to,
290         uint deadline
291     ) external returns (uint amountToken, uint amountETH);
292     function removeLiquidityWithPermit(
293         address tokenA,
294         address tokenB,
295         uint liquidity,
296         uint amountAMin,
297         uint amountBMin,
298         address to,
299         uint deadline,
300         bool approveMax, uint8 v, bytes32 r, bytes32 s
301     ) external returns (uint amountA, uint amountB);
302     function removeLiquidityETHWithPermit(
303         address token,
304         uint liquidity,
305         uint amountTokenMin,
306         uint amountETHMin,
307         address to,
308         uint deadline,
309         bool approveMax, uint8 v, bytes32 r, bytes32 s
310     ) external returns (uint amountToken, uint amountETH);
311     function swapExactTokensForTokens(
312         uint amountIn,
313         uint amountOutMin,
314         address[] calldata path,
315         address to,
316         uint deadline
317     ) external returns (uint[] memory amounts);
318     function swapTokensForExactTokens(
319         uint amountOut,
320         uint amountInMax,
321         address[] calldata path,
322         address to,
323         uint deadline
324     ) external returns (uint[] memory amounts);
325     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
326         external
327         payable
328         returns (uint[] memory amounts);
329     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
330         external
331         returns (uint[] memory amounts);
332     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
333         external
334         returns (uint[] memory amounts);
335     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
336         external
337         payable
338         returns (uint[] memory amounts);
339 
340     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
341     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
342     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
343     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
344     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
345 }
346 
347 interface IUniswapV2Router02 is IUniswapV2Router01 {
348     function removeLiquidityETHSupportingFeeOnTransferTokens(
349         address token,
350         uint liquidity,
351         uint amountTokenMin,
352         uint amountETHMin,
353         address to,
354         uint deadline
355     ) external returns (uint amountETH);
356     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
357         address token,
358         uint liquidity,
359         uint amountTokenMin,
360         uint amountETHMin,
361         address to,
362         uint deadline,
363         bool approveMax, uint8 v, bytes32 r, bytes32 s
364     ) external returns (uint amountETH);
365 
366     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
367         uint amountIn,
368         uint amountOutMin,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external;
373     function swapExactETHForTokensSupportingFeeOnTransferTokens(
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external payable;
379     function swapExactTokensForETHSupportingFeeOnTransferTokens(
380         uint amountIn,
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external;
386 }
387 
388 
389 
390 contract SBAYC is Context, Ownable, IBEP20, BEP20Detailed {
391   using SafeBEP20 for IBEP20;
392   using Address for address;
393   using SafeMath for uint256;
394   
395     IUniswapV2Router02 public immutable uniswapV2Router;
396     address public immutable uniswapV2Pair;
397     
398     mapping (address => uint) internal _balances;
399     mapping (address => mapping (address => uint)) internal _allowances;
400     mapping (address => bool) private _isExcludedFromFee;
401     mapping (address => bool) private AMMs;
402     mapping (address => bool) private isTimelockExempt;
403     mapping (address => bool) private isExcludedFromMaxTx;
404     mapping (address => bool) private isExcludedFromMaxWallet;
405     mapping (address => bool) private _isBlacklisted;
406   
407    
408     uint256 internal _totalSupply;
409 
410     uint256 public marketingFee = 5;
411     uint256 public utilityFee = 5;
412     uint256 public teamFee = 2;
413 
414     address payable public marketingaddress = payable(0x5Aa12CE89d24c52BaC4560a27153b41e24b01526);
415     address payable public utilityAddress = payable(0x14334B527FEBC947B1a496BF9C69d7F11786b018);
416     address payable public teamAddress = payable(0x13A49AabB766180C42bc4FfFbbeDCb27dBC37B1b);
417     
418     bool inSwapAndLiquify;
419     bool public swapAndLiquifyEnabled = true;
420     bool public isTradingEnabled;
421 
422      // Cooldown & timer functionality
423     bool public buyCooldownEnabled = true;
424     uint8 public cooldownTimerInterval = 30;
425     mapping (address => uint) private cooldownTimer;
426 
427     uint256 public _maxTxAmount = 10000000 * (10**18);
428     uint256 public _maxWalletAmount = 20000000 * (10**18);
429     uint256 public numTokensSellToAddToLiquidity = 500000 * 10**18;
430   
431     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
432     event SwapAndLiquifyEnabledUpdated(bool enabled);
433     event SwapAndLiquify(
434         uint256 tokensSwapped,
435         uint256 ethReceived
436     );
437 
438     
439     
440     modifier lockTheSwap {
441         inSwapAndLiquify = true;
442         _;
443         inSwapAndLiquify = false;
444     }
445   
446     address public _owner;
447   
448     constructor () BEP20Detailed("SHIBAYC", "SBAYC", 18) {
449       _owner = msg.sender ;
450     _totalSupply = 1000000000 * (10**18);
451     
452 	_balances[_owner] = _totalSupply;
453 	//uniswapv3 router = 0xE592427A0AEce92De3Edee1F18E0157C05861564
454 	 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
455          // Create a uniswap pair for this new token
456         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
457             .createPair(address(this), _uniswapV2Router.WETH());
458 
459         // set the rest of the contract variables
460         uniswapV2Router = _uniswapV2Router;
461 
462           //exclude owner and this contract from fee
463         _isExcludedFromFee[owner()] = true;
464         _isExcludedFromFee[address(this)] = true;
465         _isExcludedFromFee[marketingaddress] = true;
466         _isExcludedFromFee[utilityAddress] = true;
467         _isExcludedFromFee[teamAddress] = true;
468 
469          // No timelock for these people
470         isTimelockExempt[owner()] = true;
471         isTimelockExempt[marketingaddress] = true;
472         isTimelockExempt[utilityAddress] = true;
473         isTimelockExempt[teamAddress] = true;
474         isTimelockExempt[address(this)] = true;
475 
476         isExcludedFromMaxTx[owner()] = true;
477 
478         isExcludedFromMaxWallet[owner()] = true;
479         isExcludedFromMaxWallet[uniswapV2Pair] = true;
480         
481 
482         AMMs[uniswapV2Pair] = true;
483 
484 
485      emit Transfer(address(0), _msgSender(), _totalSupply);
486   }
487   
488     function totalSupply() public view override returns (uint) {
489         return _totalSupply;
490     }
491     function balanceOf(address account) public view override returns (uint) {
492         return _balances[account];
493     }
494     function transfer(address recipient, uint amount) public override  returns (bool) {
495         _transfer(_msgSender(), recipient, amount);
496         return true;
497     }
498     function allowance(address towner, address spender) public view override returns (uint) {
499         return _allowances[towner][spender];
500     }
501     function approve(address spender, uint amount) public override returns (bool) {
502         _approve(_msgSender(), spender, amount);
503         return true;
504     }
505     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
506         _transfer(sender, recipient, amount);
507         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
508         return true;
509     }
510     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
512         return true;
513     }
514     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
516         return true;
517     }
518 
519     function setMarketingFeePercent(uint256 updatedMarketingFee) external onlyOwner {
520         marketingFee = updatedMarketingFee;
521         require(marketingFee.add(utilityFee).add(teamFee) <= 15, "Fee is crossing the boundaries");
522     }
523 
524     
525     function setUtilityFeePercent(uint256 updatedUtilityFee) external onlyOwner {
526         utilityFee = updatedUtilityFee;
527         require(marketingFee.add(utilityFee).add(teamFee) <= 15, "Fee is crossing the boundaries");
528     }
529 
530     function setTeamFeePercent(uint256 updatedTeamFee) external onlyOwner
531     {
532         teamFee = updatedTeamFee;
533         require(marketingFee.add(utilityFee).add(teamFee) <= 15, "Fee is crossing the boundaries");
534 
535     }
536 
537     function setMarketingAddress(address payable wallet) external onlyOwner
538     {
539         marketingaddress = wallet;
540     }
541 
542     function setUtilityAddress(address payable wallet) external onlyOwner
543     {
544         utilityAddress = wallet;
545     }
546 
547     function setTeamAddress(address payable wallet) external onlyOwner
548     {
549         teamAddress = wallet;
550     }
551 
552     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
553         swapAndLiquifyEnabled = _enabled;
554         emit SwapAndLiquifyEnabledUpdated(_enabled);
555     }
556 
557     function changeNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity) external onlyOwner
558     {
559         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
560     }
561     function excludeFromFee(address account) public onlyOwner {
562         _isExcludedFromFee[account] = true;
563     }
564     
565     function includeInFee(address account) public onlyOwner {
566         _isExcludedFromFee[account] = false;
567     }
568 
569     function includeInBlacklist(address account) external onlyOwner
570     {
571         _isBlacklisted[account] = true;
572     }
573 
574     function excludeFromBlacklist(address account) external onlyOwner
575     {
576         _isBlacklisted[account] = false;
577     }
578 
579     function isBlacklisted(address account) external view returns(bool)
580     {
581         return _isBlacklisted[account];
582     }
583 
584     function excludeFromAMMs(address account) public onlyOwner
585     {
586         AMMs[account] = false;
587     }
588 
589     function includeInAMMs(address account) public onlyOwner
590     {
591         AMMs[account] = true;
592         isExcludedFromMaxWallet[account] = true;
593     }
594 
595     function enableTrading() external onlyOwner
596     {
597         isTradingEnabled = true;
598     }
599     
600     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner {
601         isTimelockExempt[holder] = exempt;
602     }
603 
604     function setIsExcludedFromMaxTx(address holder, bool exempt) external onlyOwner
605     {
606         isExcludedFromMaxTx[holder] = exempt;
607     }
608 
609     function setIsExcludedFromMaxWallet(address holder, bool exempt) external onlyOwner
610     {
611         isExcludedFromMaxWallet[holder] = exempt;
612     }
613 
614     function setMaxTxLimit(uint256 maxTx) external onlyOwner
615     {
616         require(maxTx >= 100000 * (10**18), "Not Allowed");
617         _maxTxAmount = maxTx;
618     }
619 
620     function setMaxWalletLimit(uint256 maxWallet) external onlyOwner
621     {
622         require(maxWallet >= 200000 * (10**18), "Not Allowed");
623         _maxWalletAmount = maxWallet;
624     }
625      //to recieve ETH from uniswapV2Router when swaping
626     receive() external payable {}
627     function _transfer(address sender, address recipient, uint amount) internal{
628 
629         require(sender != address(0), "BEP20: transfer from the zero address");
630         require(recipient != address(0), "BEP20: transfer to the zero address");
631         require(!_isBlacklisted[sender], "Sender is blacklisted");
632         require(!_isBlacklisted[recipient], "Recipient is blacklisted");
633 
634         if(sender != owner())
635         {require(isTradingEnabled, " Trading is not enabled yet");}
636 
637         if(!isExcludedFromMaxTx[sender])
638         {
639             require(amount <= _maxTxAmount, "Maximum transaction limit reached!!");
640         }
641         if(!isExcludedFromMaxWallet[recipient])
642         {
643             require(balanceOf(recipient) + amount <= _maxWalletAmount, "Maximum wallet limit reached!!");
644         }
645 
646          // cooldown timer, so a bot doesnt do quick trades! 30 seconds gap between 2 trades.
647         if (sender == uniswapV2Pair &&
648             buyCooldownEnabled &&
649             !isTimelockExempt[recipient]) {
650             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 30 seconds between two buys");
651             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
652         }
653 
654 
655          uint256 taxAmount = (amount.mul(marketingFee + utilityFee + teamFee )).div(100);
656 
657         // is the token balance of this contract address over the min number of
658         // tokens that we need to initiate a swap + liquidity lock?
659         // also, don't get caught in a circular liquidity event.
660         // also, don't swap & liquify if sender is uniswap pair.
661         uint256 contractTokenBalance = balanceOf(address(this));
662         
663         
664         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
665         if (
666             overMinTokenBalance &&
667             !inSwapAndLiquify &&
668             !AMMs[sender] &&
669             swapAndLiquifyEnabled
670         ) {
671             contractTokenBalance = numTokensSellToAddToLiquidity;
672             //add liquidity
673             swapAndLiquify(contractTokenBalance);
674         }
675 
676          //indicates if fee should be deducted from transfer
677         bool takeFee = true;
678         
679         //if any account belongs to _isExcludedFromFee account then remove the fee
680         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
681             takeFee = false;
682         }
683        
684         if(!AMMs[recipient] && !AMMs[sender])
685         {takeFee = false;}
686        
687         if(takeFee)
688         {
689             uint256 TotalSent = amount.sub(taxAmount);
690             _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
691             _balances[recipient] = _balances[recipient].add(TotalSent);
692             _balances[address(this)] = _balances[address(this)].add(taxAmount);
693             emit Transfer(sender, recipient, TotalSent);
694             emit Transfer(sender, address(this), taxAmount);
695         }
696         else
697         {
698             _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
699             _balances[recipient] = _balances[recipient].add(amount);
700             emit Transfer(sender, recipient, amount);
701         }
702        
703     }
704 
705     function totalFee() internal view returns(uint256)
706     {
707         return marketingFee.add(utilityFee).add(teamFee);
708     }
709 
710      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
711        
712         uint256 initialBalance = address(this).balance;
713 
714         // swap tokens for ETH
715         swapTokensForEth(contractTokenBalance); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
716 
717         // how much ETH did we just swap into?
718         uint256 newBalance = address(this).balance.sub(initialBalance);
719 
720         uint256 marketingShare = newBalance.mul(marketingFee).div(totalFee());
721         uint256 utilityShare = newBalance.mul(utilityFee).div(totalFee());
722         uint256 teamShare = newBalance.sub(marketingShare.add(utilityShare));
723 
724         payable(marketingaddress).transfer(marketingShare);
725         payable(utilityAddress).transfer(utilityShare);
726         payable(teamAddress).transfer(teamShare);
727         
728         emit SwapAndLiquify(contractTokenBalance, newBalance);
729     }
730 
731     function swapTokensForEth(uint256 tokenAmount) private {
732         // generate the uniswap pair path of token -> weth
733         address[] memory path = new address[](2);
734         path[0] = address(this);
735         path[1] = uniswapV2Router.WETH();
736 
737         _approve(address(this), address(uniswapV2Router), tokenAmount);
738 
739         // make the swap
740         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
741             tokenAmount,
742             0, // accept any amount of ETH
743             path,
744             address(this),
745             block.timestamp
746         );
747     }
748 
749       // enable cooldown between trades
750     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
751         require(_interval <= 3600, "Limit reached");
752         buyCooldownEnabled = _status;
753         cooldownTimerInterval = _interval;
754     }
755 
756     function _approve(address towner, address spender, uint amount) internal {
757         require(towner != address(0), "BEP20: approve from the zero address");
758         require(spender != address(0), "BEP20: approve to the zero address");
759 
760         _allowances[towner][spender] = amount;
761         emit Approval(towner, spender, amount);
762     }
763 
764     function withdrawStuckBNB() external onlyOwner{
765         require (address(this).balance > 0, "Can't withdraw negative or zero");
766         payable(owner()).transfer(address(this).balance);
767     }
768 
769     function removeStuckToken(address _address) external onlyOwner {
770         require(_address != address(this), "Can't withdraw tokens destined for liquidity");
771         require(IBEP20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");
772 
773         IBEP20(_address).transfer(owner(), IBEP20(_address).balanceOf(address(this)));
774     }
775   
776 }