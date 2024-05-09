1 /**
2 */
3 
4 /**
5 
6  Telegram https://t.me/LayerNetwork
7  Website http://www.layernetwork.org
8  Twitter https://twitter.com/Lyrnetwork
9 */
10 
11 // SPDX-License-Identifier: Unlicensed
12 
13     //
14     
15 
16 pragma solidity ^0.8.7;
17 
18 interface IERC20 {
19     
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a + b;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a - b;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a * b;
43     }
44     
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a / b;
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         unchecked {
51             require(b <= a, errorMessage);
52             return a - b;
53         }
54     }
55     
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         unchecked {
58             require(b > 0, errorMessage);
59             return a / b;
60         }
61     }
62     
63 }
64 
65 abstract contract Context {
66     function _msgSender() internal view virtual returns (address) {
67         return msg.sender;
68     }
69 
70     function _msgData() internal view virtual returns (bytes calldata) {
71         this; 
72         return msg.data;
73     }
74 }
75 
76 library Address {
77     
78     function isContract(address account) internal view returns (bool) {
79         uint256 size;
80         assembly { size := extcodesize(account) }
81         return size > 0;
82     }
83 
84     function sendValue(address payable recipient, uint256 amount) internal {
85         require(address(this).balance >= amount, "Address: insufficient balance");
86         (bool success, ) = recipient.call{ value: amount }("");
87         require(success, "Address: unable to send value, recipient may have reverted");
88     }
89     
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91       return functionCall(target, data, "Address: low-level call failed");
92     }
93     
94     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97     
98     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
100     }
101     
102     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
103         require(address(this).balance >= value, "Address: insufficient balance for call");
104         require(isContract(target), "Address: call to non-contract");
105         (bool success, bytes memory returndata) = target.call{ value: value }(data);
106         return _verifyCallResult(success, returndata, errorMessage);
107     }
108     
109     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
110         return functionStaticCall(target, data, "Address: low-level static call failed");
111     }
112     
113     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
114         require(isContract(target), "Address: static call to non-contract");
115         (bool success, bytes memory returndata) = target.staticcall(data);
116         return _verifyCallResult(success, returndata, errorMessage);
117     }
118 
119     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
120         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
121     }
122     
123     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
124         require(isContract(target), "Address: delegate call to non-contract");
125         (bool success, bytes memory returndata) = target.delegatecall(data);
126         return _verifyCallResult(success, returndata, errorMessage);
127     }
128 
129     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
130         if (success) {
131             return returndata;
132         } else {
133             if (returndata.length > 0) {
134                  assembly {
135                     let returndata_size := mload(returndata)
136                     revert(add(32, returndata), returndata_size)
137                 }
138             } else {
139                 revert(errorMessage);
140             }
141         }
142     }
143 }
144 
145 abstract contract Ownable is Context {
146     address private _owner;
147 
148     // Set original owner
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150     constructor () {
151         _owner = 0xB17Ccbd2D44584f393188f174D361cFE0DA6877F;
152         emit OwnershipTransferred(address(0), _owner);
153     }
154 
155     // Return current owner
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     // Restrict function to contract owner only 
161     modifier onlyOwner() {
162         require(owner() == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     // Renounce ownership of the contract 
167     function renounceOwnership() public virtual onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 
172     // Transfer the contract to to a new owner
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         emit OwnershipTransferred(_owner, newOwner);
176         _owner = newOwner;
177     }
178 }
179 
180 interface IUniswapV2Factory {
181     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
182     function feeTo() external view returns (address);
183     function feeToSetter() external view returns (address);
184     function getPair(address tokenA, address tokenB) external view returns (address pair);
185     function allPairs(uint) external view returns (address pair);
186     function allPairsLength() external view returns (uint);
187     function createPair(address tokenA, address tokenB) external returns (address pair);
188     function setFeeTo(address) external;
189     function setFeeToSetter(address) external;
190 }
191 
192 interface IUniswapV2Pair {
193     event Approval(address indexed owner, address indexed spender, uint value);
194     event Transfer(address indexed from, address indexed to, uint value);
195     function name() external pure returns (string memory);
196     function symbol() external pure returns (string memory);
197     function decimals() external pure returns (uint8);
198     function totalSupply() external view returns (uint);
199     function balanceOf(address owner) external view returns (uint);
200     function allowance(address owner, address spender) external view returns (uint);
201     function approve(address spender, uint value) external returns (bool);
202     function transfer(address to, uint value) external returns (bool);
203     function transferFrom(address from, address to, uint value) external returns (bool);
204     function DOMAIN_SEPARATOR() external view returns (bytes32);
205     function PERMIT_TYPEHASH() external pure returns (bytes32);
206     function nonces(address owner) external view returns (uint);
207     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
208     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
209     event Swap(
210         address indexed sender,
211         uint amount0In,
212         uint amount1In,
213         uint amount0Out,
214         uint amount1Out,
215         address indexed to
216     );
217     event Sync(uint112 reserve0, uint112 reserve1);
218     function MINIMUM_LIQUIDITY() external pure returns (uint);
219     function factory() external view returns (address);
220     function token0() external view returns (address);
221     function token1() external view returns (address);
222     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
223     function price0CumulativeLast() external view returns (uint);
224     function price1CumulativeLast() external view returns (uint);
225     function kLast() external view returns (uint);
226     function burn(address to) external returns (uint amount0, uint amount1);
227     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
228     function skim(address to) external;
229     function sync() external;
230     function initialize(address, address) external;
231 }
232 
233 interface IUniswapV2Router01 {
234     function factory() external pure returns (address);
235     function WETH() external pure returns (address);
236     function addLiquidity(
237         address tokenA,
238         address tokenB,
239         uint amountADesired,
240         uint amountBDesired,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline
245     ) external returns (uint amountA, uint amountB, uint liquidity);
246     function addLiquidityETH(
247         address token,
248         uint amountTokenDesired,
249         uint amountTokenMin,
250         uint amountETHMin,
251         address to,
252         uint deadline
253     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
254     function removeLiquidity(
255         address tokenA,
256         address tokenB,
257         uint liquidity,
258         uint amountAMin,
259         uint amountBMin,
260         address to,
261         uint deadline
262     ) external returns (uint amountA, uint amountB);
263     function removeLiquidityETH(
264         address token,
265         uint liquidity,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountToken, uint amountETH);
271     function removeLiquidityWithPermit(
272         address tokenA,
273         address tokenB,
274         uint liquidity,
275         uint amountAMin,
276         uint amountBMin,
277         address to,
278         uint deadline,
279         bool approveMax, uint8 v, bytes32 r, bytes32 s
280     ) external returns (uint amountA, uint amountB);
281     function removeLiquidityETHWithPermit(
282         address token,
283         uint liquidity,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline,
288         bool approveMax, uint8 v, bytes32 r, bytes32 s
289     ) external returns (uint amountToken, uint amountETH);
290     function swapExactTokensForTokens(
291         uint amountIn,
292         uint amountOutMin,
293         address[] calldata path,
294         address to,
295         uint deadline
296     ) external returns (uint[] memory amounts);
297     function swapTokensForExactTokens(
298         uint amountOut,
299         uint amountInMax,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external returns (uint[] memory amounts);
304     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
305         external
306         payable
307         returns (uint[] memory amounts);
308     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
309         external
310         returns (uint[] memory amounts);
311     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
312         external
313         returns (uint[] memory amounts);
314     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
315         external
316         payable
317         returns (uint[] memory amounts);
318 
319     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
320     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
321     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
322     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
323     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
324 }
325 
326 interface IUniswapV2Router02 is IUniswapV2Router01 {
327     function removeLiquidityETHSupportingFeeOnTransferTokens(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountETH);
335     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline,
342         bool approveMax, uint8 v, bytes32 r, bytes32 s
343     ) external returns (uint amountETH);
344 
345     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
346         uint amountIn,
347         uint amountOutMin,
348         address[] calldata path,
349         address to,
350         uint deadline
351     ) external;
352     function swapExactETHForTokensSupportingFeeOnTransferTokens(
353         uint amountOutMin,
354         address[] calldata path,
355         address to,
356         uint deadline
357     ) external payable;
358     function swapExactTokensForETHSupportingFeeOnTransferTokens(
359         uint amountIn,
360         uint amountOutMin,
361         address[] calldata path,
362         address to,
363         uint deadline
364     ) external;
365 }
366 
367 contract Layernetwork is Context, IERC20, Ownable { 
368     using SafeMath for uint256;
369     using Address for address;
370 
371     // Tracking status of wallets
372     mapping (address => uint256) private _tOwned;
373     mapping (address => mapping (address => uint256)) private _allowances;
374     mapping (address => bool) public _isExcludedFromFee; 
375 
376     // Blacklist: If 'noBlackList' is true wallets on this list can not buy - used for known bots
377     mapping (address => bool) public _isBlacklisted;
378 
379     // Set contract so that blacklisted wallets cannot buy (default is false)
380     bool public noBlackList;
381    
382     /*
383 
384     WALLETS
385 
386     */
387 
388     address payable private Wallet_Dev = payable (0xB17Ccbd2D44584f393188f174D361cFE0DA6877F);
389     address payable private Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
390     address payable private Wallet_zero = payable(0x0000000000000000000000000000000000000000); 
391 
392     /*
393 
394     TOKEN DETAILS
395 
396     */
397 
398     string private _name = "Layer Network"; 
399     string private _symbol = "Layer";  
400     uint8 private _decimals = 9;
401     uint256 private _tTotal = 1000000000 * 10**9;
402     uint256 private _tFeeTotal;
403 
404     // Counter for liquify trigger
405     uint8 private txCount = 0;
406     uint8 private swapTrigger = 3; 
407 
408     // This is the max fee that the contract will accept, it is hard-coded to protect buyers
409     // This includes the buy AND the sell fee!
410     uint256 private maxPossibleFee = 80; 
411 
412     // Setting the initial fees
413     uint256 private _TotalFee = 20;
414     uint256 public _buyFee = 10;
415     uint256 public _sellFee = 10;
416 
417     // 'Previous fees' are used to keep track of fee settings when removing and restoring fees
418     uint256 private _previousTotalFee = _TotalFee; 
419     uint256 private _previousBuyFee = _buyFee; 
420     uint256 private _previousSellFee = _sellFee; 
421 
422     /*
423 
424     WALLET LIMITS 
425     
426     */
427 
428     // Max wallet holding (% at launch)
429     uint256 public _maxWalletToken = _tTotal.mul(1).div(100);
430     uint256 private _previousMaxWalletToken = _maxWalletToken;
431 
432     // Maximum transaction amount (% at launch)
433     uint256 public _maxTxAmount = _tTotal.mul(1).div(100);
434     uint256 private _previousMaxTxAmount = _maxTxAmount;
435 
436     /* 
437 
438     PANCAKESWAP SET UP
439 
440     */
441                                      
442     IUniswapV2Router02 public uniswapV2Router;
443     address public uniswapV2Pair;
444     bool public inSwapAndLiquify;
445     bool public swapAndLiquifyEnabled = true;
446     
447     event SwapAndLiquifyEnabledUpdated(bool enabled);
448     event SwapAndLiquify(
449         uint256 tokensSwapped,
450         uint256 ethReceived,
451         uint256 tokensIntoLiqudity
452         
453     );
454     
455     // Prevent processing while already processing! 
456     modifier lockTheSwap {
457         inSwapAndLiquify = true;
458         _;
459         inSwapAndLiquify = false;
460     }
461 
462     /*
463 
464     DEPLOY TOKENS TO OWNER
465 
466     Constructor functions are only called once. This happens during contract deployment.
467     This function deploys the total token supply to the owner wallet and creates the PCS pairing
468 
469     */
470     
471     constructor () {
472         _tOwned[owner()] = _tTotal;
473         
474         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
475          //0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3 Testnet
476      //0x10ED43C718714eb63d5aA57B78B54704E256024E Mainnet
477      //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D Ropsten
478      //0xCDe540d7eAFE93aC5fE6233Bee57E1270D3E330F BakerySwap
479         
480         // Create pair address for PancakeSwap
481         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
482             .createPair(address(this), _uniswapV2Router.WETH());
483         uniswapV2Router = _uniswapV2Router;
484         _isExcludedFromFee[owner()] = true;
485         _isExcludedFromFee[address(this)] = true;
486         _isExcludedFromFee[Wallet_Dev] = true;
487         
488         emit Transfer(address(0), owner(), _tTotal);
489     }
490 
491     /*
492 
493     STANDARD ERC20 COMPLIANCE FUNCTIONS
494 
495     */
496 
497     function name() public view returns (string memory) {
498         return _name;
499     }
500 
501     function symbol() public view returns (string memory) {
502         return _symbol;
503     }
504 
505     function decimals() public view returns (uint8) {
506         return _decimals;
507     }
508 
509     function totalSupply() public view override returns (uint256) {
510         return _tTotal;
511     }
512 
513     function balanceOf(address account) public view override returns (uint256) {
514         return _tOwned[account];
515     }
516 
517     function transfer(address recipient, uint256 amount) public override returns (bool) {
518         _transfer(_msgSender(), recipient, amount);
519         return true;
520     }
521 
522     function allowance(address owner, address spender) public view override returns (uint256) {
523         return _allowances[owner][spender];
524     }
525 
526     function approve(address spender, uint256 amount) public override returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
532         _transfer(sender, recipient, amount);
533         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
534         return true;
535     }
536 
537     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
539         return true;
540     }
541 
542     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
543         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
544         return true;
545     }
546 
547     /*
548 
549     END OF STANDARD ERC20 COMPLIANCE FUNCTIONS
550 
551     */
552 
553     /*
554 
555     FEES
556 
557     */
558     
559     // Set a wallet address so that it does not have to pay transaction fees
560     function excludeFromFee(address account) public onlyOwner {
561         _isExcludedFromFee[account] = true;
562     }
563     
564     // Set a wallet address so that it has to pay transaction fees
565     function includeInFee(address account) public onlyOwner {
566         _isExcludedFromFee[account] = false;
567     }
568 
569     /*
570 
571     SETTING FEES
572 
573    
574 
575     */
576     
577 
578     function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner() {
579 
580         require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Fee is too high!");
581         _sellFee = Sell_Fee;
582         _buyFee = Buy_Fee;
583 
584     }
585 
586     // Update main wallet
587     function Wallet_Update_Dev(address payable wallet) public onlyOwner() {
588         Wallet_Dev = wallet;
589         _isExcludedFromFee[Wallet_Dev] = true;
590     }
591 
592     /*
593 
594     PROCESSING TOKENS - SET UP
595 
596     */
597     
598     // Toggle on and off to auto process tokens to BNB wallet 
599     function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
600         swapAndLiquifyEnabled = true_or_false;
601         emit SwapAndLiquifyEnabledUpdated(true_or_false);
602     }
603 
604     // This will set the number of transactions required before the 'swapAndLiquify' function triggers
605     function set_Number_Of_Transactions_Before_Liquify_Trigger(uint8 number_of_transactions) public onlyOwner {
606         swapTrigger = number_of_transactions;
607     }
608     
609 
610     // This function is required so that the contract can receive BNB from pancakeswap
611     receive() external payable {}
612 
613     /*
614 
615     BLACKLIST 
616 
617     This feature is used to block a person from buying - known bot users are added to this
618     list prior to launch. We also check for people using snipe bots on the contract before we
619     add liquidity and block these wallets. We like all of our buys to be natural and fair.
620 
621     */
622 
623     // Blacklist - block wallets (ADD - COMMA SEPARATE MULTIPLE WALLETS)
624     function blacklist_Add_Wallets(address[] calldata addresses) external onlyOwner {
625        
626         uint256 startGas;
627         uint256 gasUsed;
628 
629     for (uint256 i; i < addresses.length; ++i) {
630         if(gasUsed < gasleft()) {
631         startGas = gasleft();
632         if(!_isBlacklisted[addresses[i]]){
633         _isBlacklisted[addresses[i]] = true;}
634         gasUsed = startGas - gasleft();
635     }
636     }
637     }
638 
639     // Blacklist - block wallets (REMOVE - COMMA SEPARATE MULTIPLE WALLETS)
640     function blacklist_Remove_Wallets(address[] calldata addresses) external onlyOwner {
641        
642         uint256 startGas;
643         uint256 gasUsed;
644 
645     for (uint256 i; i < addresses.length; ++i) {
646         if(gasUsed < gasleft()) {
647         startGas = gasleft();
648         if(_isBlacklisted[addresses[i]]){
649         _isBlacklisted[addresses[i]] = false;}
650         gasUsed = startGas - gasleft();
651     }
652     }
653     }
654 
655     /*
656 
657     You can turn the blacklist restrictions on and off.
658 
659     During launch, it's a good idea to block known bot users from buying. But these are real people, so 
660     when the contract is safe (and the price has increased) you can allow these wallets to buy/sell by setting
661     noBlackList to false
662 
663     */
664 
665     // Blacklist Switch - Turn on/off blacklisted wallet restrictions 
666     function blacklist_Switch(bool true_or_false) public onlyOwner {
667         noBlackList = true_or_false;
668     } 
669 
670   
671     /*
672     
673     When sending tokens to another wallet (not buying or selling) if noFeeToTransfer is true there will be no fee
674 
675     */
676 
677     bool public noFeeToTransfer = true;
678 
679     // Option to set fee or no fee for transfer (just in case the no fee transfer option is exploited in future!)
680     // True = there will be no fees when moving tokens around or giving them to friends! (There will only be a fee to buy or sell)
681     // False = there will be a fee when buying/selling/tranfering tokens
682     // Default is true
683     function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
684         noFeeToTransfer = true_or_false;
685     }
686 
687     /*
688 
689     WALLET LIMITS
690 
691     Wallets are limited in two ways. The amount of tokens that can be purchased in one transaction
692     and the total amount of tokens a wallet can buy. Limiting a wallet prevents one wallet from holding too
693     many tokens, which can scare away potential buyers that worry that a whale might dump!
694 
695     IMPORTANT
696 
697     Solidity can not process decimals, so to increase flexibility, we multiple everything by 100.
698     When entering the percent, you need to shift your decimal two steps to the right.
699 
700     eg: For 4% enter 400, for 1% enter 100, for 0.25% enter 25, for 0.2% enter 20 etc!
701 
702     */
703 
704     // Set the Max transaction amount (percent of total supply)
705     function set_Max_Transaction_Percent(uint256 maxTxPercent_x100) external onlyOwner() {
706         _maxTxAmount = _tTotal*maxTxPercent_x100/10000;
707     }    
708     
709     // Set the maximum wallet holding (percent of total supply)
710      function set_Max_Wallet_Percent(uint256 maxWallPercent_x100) external onlyOwner() {
711         _maxWalletToken = _tTotal*maxWallPercent_x100/10000;
712     }
713 
714     // Remove all fees
715     function removeAllFee() private {
716         if(_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;
717 
718         _previousBuyFee = _buyFee; 
719         _previousSellFee = _sellFee; 
720         _previousTotalFee = _TotalFee;
721         _buyFee = 0;
722         _sellFee = 0;
723         _TotalFee = 0;
724 
725     }
726     
727     // Restore all fees
728     function restoreAllFee() private {
729     
730     _TotalFee = _previousTotalFee;
731     _buyFee = _previousBuyFee; 
732     _sellFee = _previousSellFee; 
733 
734     }
735 
736     // Approve a wallet to sell tokens
737     function _approve(address owner, address spender, uint256 amount) private {
738 
739         require(owner != address(0) && spender != address(0), "ERR: zero address");
740         _allowances[owner][spender] = amount;
741         emit Approval(owner, spender, amount);
742 
743     }
744 
745     function _transfer(
746         address from,
747         address to,
748         uint256 amount
749     ) private {
750         
751 
752         /*
753 
754         TRANSACTION AND WALLET LIMITS
755 
756         */
757         
758 
759         // Limit wallet total
760         if (to != owner() &&
761             to != Wallet_Dev &&
762             to != address(this) &&
763             to != uniswapV2Pair &&
764             to != Wallet_Burn &&
765             from != owner()){
766             uint256 heldTokens = balanceOf(to);
767             require((heldTokens + amount) <= _maxWalletToken,"You are trying to buy too many tokens. You have reached the limit for one wallet.");}
768 
769         // Limit the maximum number of tokens that can be bought or sold in one transaction
770         if (from != owner() && to != owner())
771             require(amount <= _maxTxAmount, "You are trying to buy more than the max transaction limit.");
772 
773         /*
774 
775         BLACKLIST RESTRICTIONS
776 
777         */
778         
779         if (noBlackList){
780         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted. Transaction reverted.");}
781 
782         require(from != address(0) && to != address(0), "ERR: Using 0 address!");
783         require(amount > 0, "Token value must be higher than zero.");
784 
785         /*
786 
787         PROCESSING
788 
789         */
790 
791         // SwapAndLiquify is triggered after every X transactions - this number can be adjusted using swapTrigger
792 
793         if(
794             txCount >= swapTrigger && 
795             !inSwapAndLiquify &&
796             from != uniswapV2Pair &&
797             swapAndLiquifyEnabled 
798             )
799         {  
800             
801             txCount = 0;
802             uint256 contractTokenBalance = balanceOf(address(this));
803             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
804             if(contractTokenBalance > 0){
805             swapAndLiquify(contractTokenBalance);
806         }
807         }
808 
809         /*
810 
811         REMOVE FEES IF REQUIRED
812 
813         Fee removed if the to or from address is excluded from fee.
814         Fee removed if the transfer is NOT a buy or sell.
815         Change fee amount for buy or sell.
816 
817         */
818 
819         
820         bool takeFee = true;
821          
822         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)){
823             takeFee = false;
824         } else if (from == uniswapV2Pair){_TotalFee = _buyFee;} else if (to == uniswapV2Pair){_TotalFee = _sellFee;}
825         
826         _tokenTransfer(from,to,amount,takeFee);
827     }
828 
829     /*
830 
831     PROCESSING FEES
832 
833     Fees are added to the contract as tokens, these functions exchange the tokens for BNB and send to the wallet.
834     One wallet is used for ALL fees. This includes liquidity,buyback & burn, marketing, development costs etc.
835 
836     */
837 
838     // Send BNB to external wallet
839     function sendToWallet(address payable wallet, uint256 amount) private {
840             wallet.transfer(amount);
841         }
842 
843     // Processing tokens from contract
844     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
845         
846         swapTokensForBNB(contractTokenBalance);
847         uint256 contractBNB = address(this).balance;
848         sendToWallet(Wallet_Dev,contractBNB);
849     }
850 
851     // Manual Token Process Trigger - Enter the percent of the tokens that you'd like to send to process
852     function process_Tokens_Now (uint256 percent_Of_Tokens_To_Process) public onlyOwner {
853         // Do not trigger if already in swap
854         require(!inSwapAndLiquify, "Currently processing, try later."); 
855         if (percent_Of_Tokens_To_Process > 100){percent_Of_Tokens_To_Process == 100;}
856         uint256 tokensOnContract = balanceOf(address(this));
857         uint256 sendTokens = tokensOnContract*percent_Of_Tokens_To_Process/100;
858         swapAndLiquify(sendTokens);
859     }
860 
861     // Swapping tokens for BNB using PancakeSwap 
862     function swapTokensForBNB(uint256 tokenAmount) private {
863 
864         address[] memory path = new address[](2);
865         path[0] = address(this);
866         path[1] = uniswapV2Router.WETH();
867         _approve(address(this), address(uniswapV2Router), tokenAmount);
868         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
869             tokenAmount,
870             0, 
871             path,
872             address(this),
873             block.timestamp
874         );
875     }
876 
877     /*
878 
879     PURGE RANDOM TOKENS - Add the random token address and a wallet to send them to
880 
881     */
882 
883     // Remove random tokens from the contract and send to a wallet
884     function remove_Random_Tokens(address random_Token_Address, address send_to_wallet, uint256 number_of_tokens) public onlyOwner returns(bool _sent){
885         require(random_Token_Address != address(this), "Can not remove native token");
886         uint256 randomBalance = IERC20(random_Token_Address).balanceOf(address(this));
887         if (number_of_tokens > randomBalance){number_of_tokens = randomBalance;}
888         _sent = IERC20(random_Token_Address).transfer(send_to_wallet, number_of_tokens);
889     }
890 
891     /*
892     
893     UPDATE PANCAKESWAP ROUTER AND LIQUIDITY PAIRING
894 
895     */
896 
897     // Set new router and make the new pair address
898     function set_New_Router_and_Make_Pair(address newRouter) public onlyOwner() {
899         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
900         uniswapV2Pair = IUniswapV2Factory(_newPCSRouter.factory()).createPair(address(this), _newPCSRouter.WETH());
901         uniswapV2Router = _newPCSRouter;
902     }
903    
904     // Set new router
905     function set_New_Router_Address(address newRouter) public onlyOwner() {
906         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
907         uniswapV2Router = _newPCSRouter;
908     }
909     
910     // Set new address - This will be the 'Cake LP' address for the token pairing
911     function set_New_Pair_Address(address newPair) public onlyOwner() {
912         uniswapV2Pair = newPair;
913     }
914 
915     /*
916 
917     TOKEN TRANSFERS
918 
919     */
920 
921     // Check if token transfer needs to process fees
922     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
923         
924         
925         if(!takeFee){
926             removeAllFee();
927             } else {
928                 txCount++;
929             }
930             _transferTokens(sender, recipient, amount);
931         
932         if(!takeFee)
933             restoreAllFee();
934     }
935 
936     // Redistributing tokens and adding the fee to the contract address
937     function _transferTokens(address sender, address recipient, uint256 tAmount) private {
938         (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
939         _tOwned[sender] = _tOwned[sender].sub(tAmount);
940         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
941         _tOwned[address(this)] = _tOwned[address(this)].add(tDev);   
942         emit Transfer(sender, recipient, tTransferAmount);
943     }
944 
945     // Calculating the fee in tokens
946     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
947         uint256 tDev = tAmount*_TotalFee/100;
948         uint256 tTransferAmount = tAmount.sub(tDev);
949         return (tTransferAmount, tDev);
950     }
951 
952     
953 
954 }