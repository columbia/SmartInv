1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-18
3 */
4 
5 /**
6 
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 /*
11 
12 http://www.stellarinu.com
13 
14 https://t.me/stellarinueth
15 
16 ˜”*°•.˜”*°• stellar inu •°*”˜.•°*”˜
17 
18 */
19 
20 pragma solidity ^0.8.7;
21 
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
33 }
34 
35 library SafeMath {
36     
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a + b;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return a - b;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a * b;
48     }
49     
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a / b;
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         unchecked {
56             require(b <= a, errorMessage);
57             return a - b;
58         }
59     }
60     
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         unchecked {
63             require(b > 0, errorMessage);
64             return a / b;
65         }
66     }
67     
68 }
69 
70 
71 
72 abstract contract Context {
73     function _msgSender() internal view virtual returns (address) {
74         return msg.sender;
75     }
76 
77     function _msgData() internal view virtual returns (bytes calldata) {
78         this; 
79         return msg.data;
80     }
81 }
82 
83 
84 library Address {
85     
86     function isContract(address account) internal view returns (bool) {
87         uint256 size;
88         assembly { size := extcodesize(account) }
89         return size > 0;
90     }
91 
92     function sendValue(address payable recipient, uint256 amount) internal {
93         require(address(this).balance >= amount, "Address: insufficient balance");
94         (bool success, ) = recipient.call{ value: amount }("");
95         require(success, "Address: unable to send value, recipient may have reverted");
96     }
97     
98     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
99       return functionCall(target, data, "Address: low-level call failed");
100     }
101     
102     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105     
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109     
110     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
111         require(address(this).balance >= value, "Address: insufficient balance for call");
112         require(isContract(target), "Address: call to non-contract");
113         (bool success, bytes memory returndata) = target.call{ value: value }(data);
114         return _verifyCallResult(success, returndata, errorMessage);
115     }
116     
117     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
118         return functionStaticCall(target, data, "Address: low-level static call failed");
119     }
120     
121     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
122         require(isContract(target), "Address: static call to non-contract");
123         (bool success, bytes memory returndata) = target.staticcall(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127 
128     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
129         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
130     }
131     
132     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
133         require(isContract(target), "Address: delegate call to non-contract");
134         (bool success, bytes memory returndata) = target.delegatecall(data);
135         return _verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
139         if (success) {
140             return returndata;
141         } else {
142             if (returndata.length > 0) {
143                  assembly {
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
154 abstract contract Ownable is Context {
155     address private _owner;
156 
157 
158     // Set original owner
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160     constructor () {
161         _owner = 0xaDDef5977e5fFbF0fB67a68CF162F2bE4B3c383A;
162         emit OwnershipTransferred(address(0), _owner);
163     }
164 
165     // Return current owner
166     function owner() public view virtual returns (address) {
167         return _owner;
168     }
169 
170     // Restrict function to contract owner only 
171     modifier onlyOwner() {
172         require(owner() == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     // Renounce ownership of the contract 
177     function renounceOwnership() public virtual onlyOwner {
178         emit OwnershipTransferred(_owner, address(0));
179         _owner = address(0);
180     }
181 
182     // Transfer the contract to to a new owner
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         emit OwnershipTransferred(_owner, newOwner);
186         _owner = newOwner;
187     }
188 }
189 
190 interface IUniswapV2Factory {
191     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
192     function feeTo() external view returns (address);
193     function feeToSetter() external view returns (address);
194     function getPair(address tokenA, address tokenB) external view returns (address pair);
195     function allPairs(uint) external view returns (address pair);
196     function allPairsLength() external view returns (uint);
197     function createPair(address tokenA, address tokenB) external returns (address pair);
198     function setFeeTo(address) external;
199     function setFeeToSetter(address) external;
200 }
201 
202 interface IUniswapV2Pair {
203     event Approval(address indexed owner, address indexed spender, uint value);
204     event Transfer(address indexed from, address indexed to, uint value);
205     function name() external pure returns (string memory);
206     function symbol() external pure returns (string memory);
207     function decimals() external pure returns (uint8);
208     function totalSupply() external view returns (uint);
209     function balanceOf(address owner) external view returns (uint);
210     function allowance(address owner, address spender) external view returns (uint);
211     function approve(address spender, uint value) external returns (bool);
212     function transfer(address to, uint value) external returns (bool);
213     function transferFrom(address from, address to, uint value) external returns (bool);
214     function DOMAIN_SEPARATOR() external view returns (bytes32);
215     function PERMIT_TYPEHASH() external pure returns (bytes32);
216     function nonces(address owner) external view returns (uint);
217     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
218     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
219     event Swap(
220         address indexed sender,
221         uint amount0In,
222         uint amount1In,
223         uint amount0Out,
224         uint amount1Out,
225         address indexed to
226     );
227     event Sync(uint112 reserve0, uint112 reserve1);
228     function MINIMUM_LIQUIDITY() external pure returns (uint);
229     function factory() external view returns (address);
230     function token0() external view returns (address);
231     function token1() external view returns (address);
232     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
233     function price0CumulativeLast() external view returns (uint);
234     function price1CumulativeLast() external view returns (uint);
235     function kLast() external view returns (uint);
236     function burn(address to) external returns (uint amount0, uint amount1);
237     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
238     function skim(address to) external;
239     function sync() external;
240     function initialize(address, address) external;
241 }
242 
243 interface IUniswapV2Router01 {
244     function factory() external pure returns (address);
245     function WETH() external pure returns (address);
246     function addLiquidity(
247         address tokenA,
248         address tokenB,
249         uint amountADesired,
250         uint amountBDesired,
251         uint amountAMin,
252         uint amountBMin,
253         address to,
254         uint deadline
255     ) external returns (uint amountA, uint amountB, uint liquidity);
256     function addLiquidityETH(
257         address token,
258         uint amountTokenDesired,
259         uint amountTokenMin,
260         uint amountETHMin,
261         address to,
262         uint deadline
263     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
264     function removeLiquidity(
265         address tokenA,
266         address tokenB,
267         uint liquidity,
268         uint amountAMin,
269         uint amountBMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountA, uint amountB);
273     function removeLiquidityETH(
274         address token,
275         uint liquidity,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external returns (uint amountToken, uint amountETH);
281     function removeLiquidityWithPermit(
282         address tokenA,
283         address tokenB,
284         uint liquidity,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline,
289         bool approveMax, uint8 v, bytes32 r, bytes32 s
290     ) external returns (uint amountA, uint amountB);
291     function removeLiquidityETHWithPermit(
292         address token,
293         uint liquidity,
294         uint amountTokenMin,
295         uint amountETHMin,
296         address to,
297         uint deadline,
298         bool approveMax, uint8 v, bytes32 r, bytes32 s
299     ) external returns (uint amountToken, uint amountETH);
300     function swapExactTokensForTokens(
301         uint amountIn,
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external returns (uint[] memory amounts);
307     function swapTokensForExactTokens(
308         uint amountOut,
309         uint amountInMax,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external returns (uint[] memory amounts);
314     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
315         external
316         payable
317         returns (uint[] memory amounts);
318     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
319         external
320         returns (uint[] memory amounts);
321     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
322         external
323         returns (uint[] memory amounts);
324     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
325         external
326         payable
327         returns (uint[] memory amounts);
328 
329     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
330     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
331     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
332     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
333     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
334 }
335 
336 interface IUniswapV2Router02 is IUniswapV2Router01 {
337     function removeLiquidityETHSupportingFeeOnTransferTokens(
338         address token,
339         uint liquidity,
340         uint amountTokenMin,
341         uint amountETHMin,
342         address to,
343         uint deadline
344     ) external returns (uint amountETH);
345     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
346         address token,
347         uint liquidity,
348         uint amountTokenMin,
349         uint amountETHMin,
350         address to,
351         uint deadline,
352         bool approveMax, uint8 v, bytes32 r, bytes32 s
353     ) external returns (uint amountETH);
354 
355     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
356         uint amountIn,
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     ) external;
362     function swapExactETHForTokensSupportingFeeOnTransferTokens(
363         uint amountOutMin,
364         address[] calldata path,
365         address to,
366         uint deadline
367     ) external payable;
368     function swapExactTokensForETHSupportingFeeOnTransferTokens(
369         uint amountIn,
370         uint amountOutMin,
371         address[] calldata path,
372         address to,
373         uint deadline
374     ) external;
375 }
376 
377 
378 contract StellarInu is Context, IERC20, Ownable { 
379     using SafeMath for uint256;
380     using Address for address;
381 
382 
383     // Tracking status of wallets
384     mapping (address => uint256) private _tOwned;
385     mapping (address => mapping (address => uint256)) private _allowances;
386     mapping (address => bool) public _isExcludedFromFee; 
387 
388     // Blacklist: If 'noBlackList' is true wallets on this list can not buy - used for known bots
389     mapping (address => bool) public _isBlacklisted;
390 
391     // Set contract so that blacklisted wallets cannot buy (default is false)
392     bool public noBlackList;
393    
394     /*
395 
396     WALLETS
397 
398     */
399 
400 
401     address payable private Wallet_Dev = payable(0xaDDef5977e5fFbF0fB67a68CF162F2bE4B3c383A);
402     address payable private Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
403     address payable private Wallet_zero = payable(0x0000000000000000000000000000000000000000); 
404 
405 
406     /*
407 
408     TOKEN DETAILS
409 
410     */
411 
412 
413     string private _name = "StellarInu"; 
414     string private _symbol = "StellarInu";  
415     uint8 private _decimals = 9;
416     uint256 private _tTotal = 1000000000000000000 * 10**9;
417     uint256 private _tFeeTotal;
418 
419     // Counter for liquify trigger
420     uint8 private txCount = 0;
421     uint8 private swapTrigger = 3; 
422 
423     // This is the max fee that the contract will accept, it is hard-coded to protect buyers
424     // This includes the buy AND the sell fee!
425     uint256 private maxPossibleFee = 20; 
426 
427 
428     // Setting the initial fees
429     uint256 private _TotalFee = 10;
430     uint256 public _buyFee = 10;
431     uint256 public _sellFee = 10;
432 
433 
434     // 'Previous fees' are used to keep track of fee settings when removing and restoring fees
435     uint256 private _previousTotalFee = _TotalFee; 
436     uint256 private _previousBuyFee = _buyFee; 
437     uint256 private _previousSellFee = _sellFee; 
438 
439     /*
440 
441     WALLET LIMITS 
442     
443     */
444 
445     // Max wallet holding (4% at launch)
446     uint256 public _maxWalletToken = _tTotal.mul(4).div(100);
447     uint256 private _previousMaxWalletToken = _maxWalletToken;
448 
449 
450     // Maximum transaction amount (4% at launch)
451     uint256 public _maxTxAmount = _tTotal.mul(4).div(100); 
452     uint256 private _previousMaxTxAmount = _maxTxAmount;
453 
454     /* 
455 
456     PANCAKESWAP SET UP
457 
458     */
459                                      
460     IUniswapV2Router02 public uniswapV2Router;
461     address public uniswapV2Pair;
462     bool public inSwapAndLiquify;
463     bool public swapAndLiquifyEnabled = true;
464     
465     event SwapAndLiquifyEnabledUpdated(bool enabled);
466     event SwapAndLiquify(
467         uint256 tokensSwapped,
468         uint256 ethReceived,
469         uint256 tokensIntoLiqudity
470         
471     );
472     
473     // Prevent processing while already processing! 
474     modifier lockTheSwap {
475         inSwapAndLiquify = true;
476         _;
477         inSwapAndLiquify = false;
478     }
479 
480     /*
481 
482     DEPLOY TOKENS TO OWNER
483 
484     Constructor functions are only called once. This happens during contract deployment.
485     This function deploys the total token supply to the owner wallet and creates the PCS pairing
486 
487     */
488     
489     constructor () {
490         _tOwned[owner()] = _tTotal;
491         
492         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
493         
494         
495         // Create pair address for PancakeSwap
496         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
497             .createPair(address(this), _uniswapV2Router.WETH());
498         uniswapV2Router = _uniswapV2Router;
499         _isExcludedFromFee[owner()] = true;
500         _isExcludedFromFee[address(this)] = true;
501         _isExcludedFromFee[Wallet_Dev] = true;
502         
503         emit Transfer(address(0), owner(), _tTotal);
504     }
505 
506 
507     /*
508 
509     STANDARD ERC20 COMPLIANCE FUNCTIONS
510 
511     */
512 
513     function name() public view returns (string memory) {
514         return _name;
515     }
516 
517     function symbol() public view returns (string memory) {
518         return _symbol;
519     }
520 
521     function decimals() public view returns (uint8) {
522         return _decimals;
523     }
524 
525     function totalSupply() public view override returns (uint256) {
526         return _tTotal;
527     }
528 
529     function balanceOf(address account) public view override returns (uint256) {
530         return _tOwned[account];
531     }
532 
533     function transfer(address recipient, uint256 amount) public override returns (bool) {
534         _transfer(_msgSender(), recipient, amount);
535         return true;
536     }
537 
538     function allowance(address owner, address spender) public view override returns (uint256) {
539         return _allowances[owner][spender];
540     }
541 
542     function approve(address spender, uint256 amount) public override returns (bool) {
543         _approve(_msgSender(), spender, amount);
544         return true;
545     }
546 
547     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
548         _transfer(sender, recipient, amount);
549         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
550         return true;
551     }
552 
553     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
554         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
555         return true;
556     }
557 
558     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
559         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
560         return true;
561     }
562 
563 
564     /*
565 
566     END OF STANDARD ERC20 COMPLIANCE FUNCTIONS
567 
568     */
569 
570 
571 
572 
573     /*
574 
575     FEES
576 
577     */
578     
579     // Set a wallet address so that it does not have to pay transaction fees
580     function excludeFromFee(address account) public onlyOwner {
581         _isExcludedFromFee[account] = true;
582     }
583     
584     // Set a wallet address so that it has to pay transaction fees
585     function includeInFee(address account) public onlyOwner {
586         _isExcludedFromFee[account] = false;
587     }
588 
589 
590     /*
591 
592     SETTING FEES
593 
594     Max total fee is limited to 20% (for buy and sell combined)
595     Launch fees are set to 10% buy 10% sell
596 
597     */
598     
599 
600     function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner() {
601 
602         require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Fee is too high!");
603         _sellFee = Sell_Fee;
604         _buyFee = Buy_Fee;
605 
606     }
607 
608 
609 
610     // Update main wallet
611     function Wallet_Update_Dev(address payable wallet) public onlyOwner() {
612         Wallet_Dev = wallet;
613         _isExcludedFromFee[Wallet_Dev] = true;
614     }
615 
616 
617     /*
618 
619     PROCESSING TOKENS - SET UP
620 
621     */
622     
623     // Toggle on and off to auto process tokens to BNB wallet 
624     function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
625         swapAndLiquifyEnabled = true_or_false;
626         emit SwapAndLiquifyEnabledUpdated(true_or_false);
627     }
628 
629     // This will set the number of transactions required before the 'swapAndLiquify' function triggers
630     function set_Number_Of_Transactions_Before_Liquify_Trigger(uint8 number_of_transactions) public onlyOwner {
631         swapTrigger = number_of_transactions;
632     }
633     
634 
635 
636     // This function is required so that the contract can receive BNB from pancakeswap
637     receive() external payable {}
638 
639 
640 
641     /*
642 
643     BLACKLIST 
644 
645     This feature is used to block a person from buying - known bot users are added to this
646     list prior to launch. We also check for people using snipe bots on the contract before we
647     add liquidity and block these wallets. We like all of our buys to be natural and fair.
648 
649     */
650 
651     // Blacklist - block wallets (ADD - COMMA SEPARATE MULTIPLE WALLETS)
652     function blacklist_Add_Wallets(address[] calldata addresses) external onlyOwner {
653        
654         uint256 startGas;
655         uint256 gasUsed;
656 
657     for (uint256 i; i < addresses.length; ++i) {
658         if(gasUsed < gasleft()) {
659         startGas = gasleft();
660         if(!_isBlacklisted[addresses[i]]){
661         _isBlacklisted[addresses[i]] = true;}
662         gasUsed = startGas - gasleft();
663     }
664     }
665     }
666 
667 
668 
669     // Blacklist - block wallets (REMOVE - COMMA SEPARATE MULTIPLE WALLETS)
670     function blacklist_Remove_Wallets(address[] calldata addresses) external onlyOwner {
671        
672         uint256 startGas;
673         uint256 gasUsed;
674 
675     for (uint256 i; i < addresses.length; ++i) {
676         if(gasUsed < gasleft()) {
677         startGas = gasleft();
678         if(_isBlacklisted[addresses[i]]){
679         _isBlacklisted[addresses[i]] = false;}
680         gasUsed = startGas - gasleft();
681     }
682     }
683     }
684 
685 
686     /*
687 
688     You can turn the blacklist restrictions on and off.
689 
690     During launch, it's a good idea to block known bot users from buying. But these are real people, so 
691     when the contract is safe (and the price has increased) you can allow these wallets to buy/sell by setting
692     noBlackList to false
693 
694     */
695 
696     // Blacklist Switch - Turn on/off blacklisted wallet restrictions 
697     function blacklist_Switch(bool true_or_false) public onlyOwner {
698         noBlackList = true_or_false;
699     } 
700 
701   
702     /*
703     
704     When sending tokens to another wallet (not buying or selling) if noFeeToTransfer is true there will be no fee
705 
706     */
707 
708     bool public noFeeToTransfer = true;
709 
710     // Option to set fee or no fee for transfer (just in case the no fee transfer option is exploited in future!)
711     // True = there will be no fees when moving tokens around or giving them to friends! (There will only be a fee to buy or sell)
712     // False = there will be a fee when buying/selling/tranfering tokens
713     // Default is true
714     function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
715         noFeeToTransfer = true_or_false;
716     }
717 
718     /*
719 
720     WALLET LIMITS
721 
722     Wallets are limited in two ways. The amount of tokens that can be purchased in one transaction
723     and the total amount of tokens a wallet can buy. Limiting a wallet prevents one wallet from holding too
724     many tokens, which can scare away potential buyers that worry that a whale might dump!
725 
726     IMPORTANT
727 
728     Solidity can not process decimals, so to increase flexibility, we multiple everything by 100.
729     When entering the percent, you need to shift your decimal two steps to the right.
730 
731     eg: For 4% enter 400, for 1% enter 100, for 0.25% enter 25, for 0.2% enter 20 etc!
732 
733     */
734 
735     // Set the Max transaction amount (percent of total supply)
736     function set_Max_Transaction_Percent(uint256 maxTxPercent_x100) external onlyOwner() {
737         _maxTxAmount = _tTotal*maxTxPercent_x100/10000;
738     }    
739     
740     // Set the maximum wallet holding (percent of total supply)
741      function set_Max_Wallet_Percent(uint256 maxWallPercent_x100) external onlyOwner() {
742         _maxWalletToken = _tTotal*maxWallPercent_x100/10000;
743     }
744 
745 
746 
747     // Remove all fees
748     function removeAllFee() private {
749         if(_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;
750 
751 
752         _previousBuyFee = _buyFee; 
753         _previousSellFee = _sellFee; 
754         _previousTotalFee = _TotalFee;
755         _buyFee = 0;
756         _sellFee = 0;
757         _TotalFee = 0;
758 
759     }
760     
761     // Restore all fees
762     function restoreAllFee() private {
763     
764     _TotalFee = _previousTotalFee;
765     _buyFee = _previousBuyFee; 
766     _sellFee = _previousSellFee; 
767 
768     }
769 
770 
771     // Approve a wallet to sell tokens
772     function _approve(address owner, address spender, uint256 amount) private {
773 
774         require(owner != address(0) && spender != address(0), "ERR: zero address");
775         _allowances[owner][spender] = amount;
776         emit Approval(owner, spender, amount);
777 
778     }
779 
780     function _transfer(
781         address from,
782         address to,
783         uint256 amount
784     ) private {
785         
786 
787         /*
788 
789         TRANSACTION AND WALLET LIMITS
790 
791         */
792         
793 
794         // Limit wallet total
795         if (to != owner() &&
796             to != Wallet_Dev &&
797             to != address(this) &&
798             to != uniswapV2Pair &&
799             to != Wallet_Burn &&
800             from != owner()){
801             uint256 heldTokens = balanceOf(to);
802             require((heldTokens + amount) <= _maxWalletToken,"You are trying to buy too many tokens. You have reached the limit for one wallet.");}
803 
804 
805         // Limit the maximum number of tokens that can be bought or sold in one transaction
806         if (from != owner() && to != owner())
807             require(amount <= _maxTxAmount, "You are trying to buy more than the max transaction limit.");
808 
809 
810 
811         /*
812 
813         BLACKLIST RESTRICTIONS
814 
815         */
816         
817         if (noBlackList){
818         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted. Transaction reverted.");}
819 
820 
821         require(from != address(0) && to != address(0), "ERR: Using 0 address!");
822         require(amount > 0, "Token value must be higher than zero.");
823 
824 
825         /*
826 
827         PROCESSING
828 
829         */
830 
831 
832         // SwapAndLiquify is triggered after every X transactions - this number can be adjusted using swapTrigger
833 
834         if(
835             txCount >= swapTrigger && 
836             !inSwapAndLiquify &&
837             from != uniswapV2Pair &&
838             swapAndLiquifyEnabled 
839             )
840         {  
841             
842             txCount = 0;
843             uint256 contractTokenBalance = balanceOf(address(this));
844             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
845             if(contractTokenBalance > 0){
846             swapAndLiquify(contractTokenBalance);
847         }
848         }
849 
850 
851         /*
852 
853         REMOVE FEES IF REQUIRED
854 
855         Fee removed if the to or from address is excluded from fee.
856         Fee removed if the transfer is NOT a buy or sell.
857         Change fee amount for buy or sell.
858 
859         */
860 
861         
862         bool takeFee = true;
863          
864         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)){
865             takeFee = false;
866         } else if (from == uniswapV2Pair){_TotalFee = _buyFee;} else if (to == uniswapV2Pair){_TotalFee = _sellFee;}
867         
868         _tokenTransfer(from,to,amount,takeFee);
869     }
870 
871 
872 
873     /*
874 
875     PROCESSING FEES
876 
877     Fees are added to the contract as tokens, these functions exchange the tokens for BNB and send to the wallet.
878     One wallet is used for ALL fees. This includes liquidity, marketing, development costs etc.
879 
880     */
881 
882 
883     // Send BNB to external wallet
884     function sendToWallet(address payable wallet, uint256 amount) private {
885             wallet.transfer(amount);
886         }
887 
888 
889     // Processing tokens from contract
890     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
891         
892         swapTokensForBNB(contractTokenBalance);
893         uint256 contractBNB = address(this).balance;
894         sendToWallet(Wallet_Dev,contractBNB);
895     }
896 
897 
898     // Manual Token Process Trigger - Enter the percent of the tokens that you'd like to send to process
899     function process_Tokens_Now (uint256 percent_Of_Tokens_To_Process) public onlyOwner {
900         // Do not trigger if already in swap
901         require(!inSwapAndLiquify, "Currently processing, try later."); 
902         if (percent_Of_Tokens_To_Process > 100){percent_Of_Tokens_To_Process == 100;}
903         uint256 tokensOnContract = balanceOf(address(this));
904         uint256 sendTokens = tokensOnContract*percent_Of_Tokens_To_Process/100;
905         swapAndLiquify(sendTokens);
906     }
907 
908 
909     // Swapping tokens for BNB using PancakeSwap 
910     function swapTokensForBNB(uint256 tokenAmount) private {
911 
912         address[] memory path = new address[](2);
913         path[0] = address(this);
914         path[1] = uniswapV2Router.WETH();
915         _approve(address(this), address(uniswapV2Router), tokenAmount);
916         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
917             tokenAmount,
918             0, 
919             path,
920             address(this),
921             block.timestamp
922         );
923     }
924 
925     /*
926 
927     PURGE RANDOM TOKENS - Add the random token address and a wallet to send them to
928 
929     */
930 
931     // Remove random tokens from the contract and send to a wallet
932     function remove_Random_Tokens(address random_Token_Address, address send_to_wallet, uint256 number_of_tokens) public onlyOwner returns(bool _sent){
933         require(random_Token_Address != address(this), "Can not remove native token");
934         uint256 randomBalance = IERC20(random_Token_Address).balanceOf(address(this));
935         if (number_of_tokens > randomBalance){number_of_tokens = randomBalance;}
936         _sent = IERC20(random_Token_Address).transfer(send_to_wallet, number_of_tokens);
937     }
938 
939 
940     /*
941     
942     UPDATE PANCAKESWAP ROUTER AND LIQUIDITY PAIRING
943 
944     */
945 
946 
947     // Set new router and make the new pair address
948     function set_New_Router_and_Make_Pair(address newRouter) public onlyOwner() {
949         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
950         uniswapV2Pair = IUniswapV2Factory(_newPCSRouter.factory()).createPair(address(this), _newPCSRouter.WETH());
951         uniswapV2Router = _newPCSRouter;
952     }
953    
954     // Set new router
955     function set_New_Router_Address(address newRouter) public onlyOwner() {
956         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
957         uniswapV2Router = _newPCSRouter;
958     }
959     
960     // Set new address - This will be the 'Cake LP' address for the token pairing
961     function set_New_Pair_Address(address newPair) public onlyOwner() {
962         uniswapV2Pair = newPair;
963     }
964 
965     /*
966 
967     TOKEN TRANSFERS
968 
969     */
970 
971     // Check if token transfer needs to process fees
972     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
973         
974         
975         if(!takeFee){
976             removeAllFee();
977             } else {
978                 txCount++;
979             }
980             _transferTokens(sender, recipient, amount);
981         
982         if(!takeFee)
983             restoreAllFee();
984     }
985 
986     // Redistributing tokens and adding the fee to the contract address
987     function _transferTokens(address sender, address recipient, uint256 tAmount) private {
988         (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
989         _tOwned[sender] = _tOwned[sender].sub(tAmount);
990         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
991         _tOwned[address(this)] = _tOwned[address(this)].add(tDev);   
992         emit Transfer(sender, recipient, tTransferAmount);
993     }
994 
995 
996     // Calculating the fee in tokens
997     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
998         uint256 tDev = tAmount*_TotalFee/100;
999         uint256 tTransferAmount = tAmount.sub(tDev);
1000         return (tTransferAmount, tDev);
1001     }
1002 
1003 
1004 
1005     
1006 
1007 
1008 }