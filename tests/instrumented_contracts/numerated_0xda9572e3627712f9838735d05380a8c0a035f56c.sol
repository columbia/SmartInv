1 /*
2 
3 https://xploiteth.com/
4 https://t.me/xploitethereum
5 https://twitter.com/xploitcoin
6 
7 */
8 pragma solidity ^0.8.7;
9 
10 interface IERC20 {
11     
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a + b;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return a - b;
31     }
32 
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a * b;
35     }
36     
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a / b;
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked {
43             require(b <= a, errorMessage);
44             return a - b;
45         }
46     }
47     
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         unchecked {
50             require(b > 0, errorMessage);
51             return a / b;
52         }
53     }
54     
55 }
56 
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         this; 
64         return msg.data;
65     }
66 }
67 
68 library Address {
69     
70     function isContract(address account) internal view returns (bool) {
71         uint256 size;
72         assembly { size := extcodesize(account) }
73         return size > 0;
74     }
75 
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78         (bool success, ) = recipient.call{ value: amount }("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81     
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83       return functionCall(target, data, "Address: low-level call failed");
84     }
85     
86     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
87         return functionCallWithValue(target, data, 0, errorMessage);
88     }
89     
90     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
91         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
92     }
93     
94     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
95         require(address(this).balance >= value, "Address: insufficient balance for call");
96         require(isContract(target), "Address: call to non-contract");
97         (bool success, bytes memory returndata) = target.call{ value: value }(data);
98         return _verifyCallResult(success, returndata, errorMessage);
99     }
100     
101     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
102         return functionStaticCall(target, data, "Address: low-level static call failed");
103     }
104     
105     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
106         require(isContract(target), "Address: static call to non-contract");
107         (bool success, bytes memory returndata) = target.staticcall(data);
108         return _verifyCallResult(success, returndata, errorMessage);
109     }
110 
111     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
112         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
113     }
114     
115     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
116         require(isContract(target), "Address: delegate call to non-contract");
117         (bool success, bytes memory returndata) = target.delegatecall(data);
118         return _verifyCallResult(success, returndata, errorMessage);
119     }
120 
121     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
122         if (success) {
123             return returndata;
124         } else {
125             if (returndata.length > 0) {
126                  assembly {
127                     let returndata_size := mload(returndata)
128                     revert(add(32, returndata), returndata_size)
129                 }
130             } else {
131                 revert(errorMessage);
132             }
133         }
134     }
135 }
136 
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     // Set original owner
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142     constructor () {
143         _owner = 0xC6Ca810Da5323fa692E1C3e437f1c538DB2129D5;
144         emit OwnershipTransferred(address(0), _owner);
145     }
146 
147     // Return current owner
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     // Restrict function to contract owner only 
153     modifier onlyOwner() {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     // Renounce ownership of the contract 
159     function renounceOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     // Transfer the contract to to a new owner
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         emit OwnershipTransferred(_owner, newOwner);
168         _owner = newOwner;
169     }
170 }
171 
172 interface IUniswapV2Factory {
173     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
174     function feeTo() external view returns (address);
175     function feeToSetter() external view returns (address);
176     function getPair(address tokenA, address tokenB) external view returns (address pair);
177     function allPairs(uint) external view returns (address pair);
178     function allPairsLength() external view returns (uint);
179     function createPair(address tokenA, address tokenB) external returns (address pair);
180     function setFeeTo(address) external;
181     function setFeeToSetter(address) external;
182 }
183 
184 interface IUniswapV2Pair {
185     event Approval(address indexed owner, address indexed spender, uint value);
186     event Transfer(address indexed from, address indexed to, uint value);
187     function name() external pure returns (string memory);
188     function symbol() external pure returns (string memory);
189     function decimals() external pure returns (uint8);
190     function totalSupply() external view returns (uint);
191     function balanceOf(address owner) external view returns (uint);
192     function allowance(address owner, address spender) external view returns (uint);
193     function approve(address spender, uint value) external returns (bool);
194     function transfer(address to, uint value) external returns (bool);
195     function transferFrom(address from, address to, uint value) external returns (bool);
196     function DOMAIN_SEPARATOR() external view returns (bytes32);
197     function PERMIT_TYPEHASH() external pure returns (bytes32);
198     function nonces(address owner) external view returns (uint);
199     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
200     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
201     event Swap(
202         address indexed sender,
203         uint amount0In,
204         uint amount1In,
205         uint amount0Out,
206         uint amount1Out,
207         address indexed to
208     );
209     event Sync(uint112 reserve0, uint112 reserve1);
210     function MINIMUM_LIQUIDITY() external pure returns (uint);
211     function factory() external view returns (address);
212     function token0() external view returns (address);
213     function token1() external view returns (address);
214     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
215     function price0CumulativeLast() external view returns (uint);
216     function price1CumulativeLast() external view returns (uint);
217     function kLast() external view returns (uint);
218     function burn(address to) external returns (uint amount0, uint amount1);
219     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
220     function skim(address to) external;
221     function sync() external;
222     function initialize(address, address) external;
223 }
224 
225 interface IUniswapV2Router01 {
226     function factory() external pure returns (address);
227     function WETH() external pure returns (address);
228     function addLiquidity(
229         address tokenA,
230         address tokenB,
231         uint amountADesired,
232         uint amountBDesired,
233         uint amountAMin,
234         uint amountBMin,
235         address to,
236         uint deadline
237     ) external returns (uint amountA, uint amountB, uint liquidity);
238     function addLiquidityETH(
239         address token,
240         uint amountTokenDesired,
241         uint amountTokenMin,
242         uint amountETHMin,
243         address to,
244         uint deadline
245     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
246     function removeLiquidity(
247         address tokenA,
248         address tokenB,
249         uint liquidity,
250         uint amountAMin,
251         uint amountBMin,
252         address to,
253         uint deadline
254     ) external returns (uint amountA, uint amountB);
255     function removeLiquidityETH(
256         address token,
257         uint liquidity,
258         uint amountTokenMin,
259         uint amountETHMin,
260         address to,
261         uint deadline
262     ) external returns (uint amountToken, uint amountETH);
263     function removeLiquidityWithPermit(
264         address tokenA,
265         address tokenB,
266         uint liquidity,
267         uint amountAMin,
268         uint amountBMin,
269         address to,
270         uint deadline,
271         bool approveMax, uint8 v, bytes32 r, bytes32 s
272     ) external returns (uint amountA, uint amountB);
273     function removeLiquidityETHWithPermit(
274         address token,
275         uint liquidity,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline,
280         bool approveMax, uint8 v, bytes32 r, bytes32 s
281     ) external returns (uint amountToken, uint amountETH);
282     function swapExactTokensForTokens(
283         uint amountIn,
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external returns (uint[] memory amounts);
289     function swapTokensForExactTokens(
290         uint amountOut,
291         uint amountInMax,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external returns (uint[] memory amounts);
296     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
297         external
298         payable
299         returns (uint[] memory amounts);
300     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
301         external
302         returns (uint[] memory amounts);
303     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
304         external
305         returns (uint[] memory amounts);
306     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
307         external
308         payable
309         returns (uint[] memory amounts);
310 
311     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
312     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
313     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
314     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
315     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
316 }
317 
318 interface IUniswapV2Router02 is IUniswapV2Router01 {
319     function removeLiquidityETHSupportingFeeOnTransferTokens(
320         address token,
321         uint liquidity,
322         uint amountTokenMin,
323         uint amountETHMin,
324         address to,
325         uint deadline
326     ) external returns (uint amountETH);
327     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline,
334         bool approveMax, uint8 v, bytes32 r, bytes32 s
335     ) external returns (uint amountETH);
336 
337     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
338         uint amountIn,
339         uint amountOutMin,
340         address[] calldata path,
341         address to,
342         uint deadline
343     ) external;
344     function swapExactETHForTokensSupportingFeeOnTransferTokens(
345         uint amountOutMin,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external payable;
350     function swapExactTokensForETHSupportingFeeOnTransferTokens(
351         uint amountIn,
352         uint amountOutMin,
353         address[] calldata path,
354         address to,
355         uint deadline
356     ) external;
357 }
358 
359 contract XPLOIT is Context, IERC20, Ownable { 
360     using SafeMath for uint256;
361     using Address for address;
362 
363     // Tracking status of wallets
364     mapping (address => uint256) private _tOwned;
365     mapping (address => mapping (address => uint256)) private _allowances;
366     mapping (address => bool) public _isExcludedFromFee; 
367 
368     // Blacklist: If 'noBlackList' is true wallets on this list can not buy - used for known bots
369     mapping (address => bool) public _isBlacklisted;
370 
371     // Set contract so that blacklisted wallets cannot buy (default is false)
372     bool public noBlackList;
373    
374     /*
375 
376     WALLETS
377 
378     */
379 
380     address payable private Wallet_Dev = payable(0xC6Ca810Da5323fa692E1C3e437f1c538DB2129D5);
381     address payable private Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
382     address payable private Wallet_zero = payable(0x0000000000000000000000000000000000000000); 
383 
384     /*
385 
386     TOKEN DETAILS
387 
388     */
389 
390     string private _name = "XPLOIT"; 
391     string private _symbol = "$XPLOIT";  
392     uint8 private _decimals = 9;
393     uint256 private _tTotal = 1000000000 * 10**9;
394     uint256 private _tFeeTotal;
395 
396     // Counter for liquify trigger
397     uint8 private txCount = 0;
398     uint8 private swapTrigger = 3; 
399 
400     // This is the max fee that the contract will accept, it is hard-coded to protect buyers
401     // This includes the buy AND the sell fee!
402     uint256 private maxPossibleFee = 30; 
403 
404     // Setting the initial fees
405     uint256 private _TotalFee = 30;
406     uint256 public _buyFee = 5;
407     uint256 public _sellFee = 25;
408 
409     // 'Previous fees' are used to keep track of fee settings when removing and restoring fees
410     uint256 private _previousTotalFee = _TotalFee; 
411     uint256 private _previousBuyFee = _buyFee; 
412     uint256 private _previousSellFee = _sellFee; 
413 
414     /*
415 
416     WALLET LIMITS 
417     
418     */
419 
420     // Max wallet holding (% at launch)
421     uint256 public _maxWalletToken = _tTotal.mul(100).div(1000);
422     uint256 private _previousMaxWalletToken = _maxWalletToken;
423 
424     // Maximum transaction amount (% at launch)
425     uint256 public _maxTxAmount = _tTotal.mul(100).div(1000);
426     uint256 private _previousMaxTxAmount = _maxTxAmount;
427 
428     
429                                      
430     IUniswapV2Router02 public uniswapV2Router;
431     address public uniswapV2Pair;
432     bool public inSwapAndLiquify;
433     bool public swapAndLiquifyEnabled = true;
434     
435     event SwapAndLiquifyEnabledUpdated(bool enabled);
436     event SwapAndLiquify(
437         uint256 tokensSwapped,
438         uint256 ethReceived,
439         uint256 tokensIntoLiqudity
440         
441     );
442     
443     // Prevent processing while already processing! 
444     modifier lockTheSwap {
445         inSwapAndLiquify = true;
446         _;
447         inSwapAndLiquify = false;
448     }
449 
450     /*
451 
452     DEPLOY TOKENS TO OWNER
453 
454     Constructor functions are only called once. This happens during contract deployment.
455     This function deploys the total token supply to the owner wallet and creates the PCS pairing
456 
457     */
458     
459     constructor () {
460         _tOwned[owner()] = _tTotal;
461         
462         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
463         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
464             .createPair(address(this), _uniswapV2Router.WETH());
465         uniswapV2Router = _uniswapV2Router;
466         _isExcludedFromFee[owner()] = true;
467         _isExcludedFromFee[address(this)] = true;
468         _isExcludedFromFee[Wallet_Dev] = true;
469         
470         emit Transfer(address(0), owner(), _tTotal);
471     }
472 
473     /*
474 
475     STANDARD ERC20 COMPLIANCE FUNCTIONS
476 
477     */
478 
479     function name() public view returns (string memory) {
480         return _name;
481     }
482 
483     function symbol() public view returns (string memory) {
484         return _symbol;
485     }
486 
487     function decimals() public view returns (uint8) {
488         return _decimals;
489     }
490 
491     function totalSupply() public view override returns (uint256) {
492         return _tTotal;
493     }
494 
495     function balanceOf(address account) public view override returns (uint256) {
496         return _tOwned[account];
497     }
498 
499     function transfer(address recipient, uint256 amount) public override returns (bool) {
500         _transfer(_msgSender(), recipient, amount);
501         return true;
502     }
503 
504     function allowance(address owner, address spender) public view override returns (uint256) {
505         return _allowances[owner][spender];
506     }
507 
508     function approve(address spender, uint256 amount) public override returns (bool) {
509         _approve(_msgSender(), spender, amount);
510         return true;
511     }
512 
513     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
514         _transfer(sender, recipient, amount);
515         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
516         return true;
517     }
518 
519     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
520         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
521         return true;
522     }
523 
524     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
526         return true;
527     }
528 
529     /*
530 
531     END OF STANDARD ERC20 COMPLIANCE FUNCTIONS
532 
533     */
534 
535     /*
536 
537     FEES
538 
539     */
540     
541     // Set a wallet address so that it does not have to pay transaction fees
542     function excludeFromFee(address account) public onlyOwner {
543         _isExcludedFromFee[account] = true;
544     }
545     
546     // Set a wallet address so that it has to pay transaction fees
547     function includeInFee(address account) public onlyOwner {
548         _isExcludedFromFee[account] = false;
549     }
550 
551     /*
552 
553     SETTING FEES
554 
555    
556 
557     */
558     
559 
560     function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner() {
561 
562         require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Fee is too high!");
563         _sellFee = Sell_Fee;
564         _buyFee = Buy_Fee;
565 
566     }
567 
568     // Update main wallet
569     function Wallet_Update_Dev(address payable wallet) public onlyOwner() {
570         Wallet_Dev = wallet;
571         _isExcludedFromFee[Wallet_Dev] = true;
572     }
573 
574     /*
575 
576     PROCESSING TOKENS - SET UP
577 
578     */
579     
580     function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
581         swapAndLiquifyEnabled = true_or_false;
582         emit SwapAndLiquifyEnabledUpdated(true_or_false);
583     }
584 
585     // This will set the number of transactions required before the 'swapAndLiquify' function triggers
586     function set_Number_Of_Transactions_Before_Liquify_Trigger(uint8 number_of_transactions) public onlyOwner {
587         swapTrigger = number_of_transactions;
588     }
589     
590 
591     receive() external payable {}
592 
593     /*
594 
595     BLACKLIST 
596 
597     This feature is used to block a person from buying - known bot users are added to this
598     list prior to launch. We also check for people using snipe bots on the contract before we
599     add liquidity and block these wallets. We like all of our buys to be natural and fair.
600 
601     */
602 
603     // Blacklist - block wallets (ADD - COMMA SEPARATE MULTIPLE WALLETS)
604     function blacklist_Add_Wallets(address[] calldata addresses) external onlyOwner {
605        
606         uint256 startGas;
607         uint256 gasUsed;
608 
609     for (uint256 i; i < addresses.length; ++i) {
610         if(gasUsed < gasleft()) {
611         startGas = gasleft();
612         if(!_isBlacklisted[addresses[i]]){
613         _isBlacklisted[addresses[i]] = true;}
614         gasUsed = startGas - gasleft();
615     }
616     }
617     }
618 
619     // Blacklist - block wallets (REMOVE - COMMA SEPARATE MULTIPLE WALLETS)
620     function blacklist_Remove_Wallets(address[] calldata addresses) external onlyOwner {
621        
622         uint256 startGas;
623         uint256 gasUsed;
624 
625     for (uint256 i; i < addresses.length; ++i) {
626         if(gasUsed < gasleft()) {
627         startGas = gasleft();
628         if(_isBlacklisted[addresses[i]]){
629         _isBlacklisted[addresses[i]] = false;}
630         gasUsed = startGas - gasleft();
631     }
632     }
633     }
634 
635     /*
636 
637     You can turn the blacklist restrictions on and off.
638 
639     During launch, it's a good idea to block known bot users from buying. But these are real people, so 
640     when the contract is safe (and the price has increased) you can allow these wallets to buy/sell by setting
641     noBlackList to false
642 
643     */
644 
645     // Blacklist Switch - Turn on/off blacklisted wallet restrictions 
646     function blacklist_Switch(bool true_or_false) public onlyOwner {
647         noBlackList = true_or_false;
648     } 
649 
650 
651     bool public noFeeToTransfer = true;
652 
653    
654     function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
655         noFeeToTransfer = true_or_false;
656     }
657 
658     function set_Max_Transaction_Percent(uint256 maxTxPercent_x100) external onlyOwner() {
659         _maxTxAmount = _tTotal*maxTxPercent_x100/50000;
660     }    
661     
662     // Set the maximum wallet holding (percent of total supply)
663      function set_Max_Wallet_Percent(uint256 maxWallPercent_x100) external onlyOwner() {
664         _maxWalletToken = _tTotal*maxWallPercent_x100/50000;
665     }
666 
667     // Remove all fees
668     function removeAllFee() private {
669         if(_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;
670 
671         _previousBuyFee = _buyFee; 
672         _previousSellFee = _sellFee; 
673         _previousTotalFee = _TotalFee;
674         _buyFee = 0;
675         _sellFee = 0;
676         _TotalFee = 0;
677 
678     }
679     
680     // Restore all fees
681     function restoreAllFee() private {
682     
683     _TotalFee = _previousTotalFee;
684     _buyFee = _previousBuyFee; 
685     _sellFee = _previousSellFee; 
686 
687     }
688 
689     // Approve a wallet to sell tokens
690     function _approve(address owner, address spender, uint256 amount) private {
691 
692         require(owner != address(0) && spender != address(0), "ERR: zero address");
693         _allowances[owner][spender] = amount;
694         emit Approval(owner, spender, amount);
695 
696     }
697 
698     function _transfer(
699         address from,
700         address to,
701         uint256 amount
702     ) private {
703         
704 
705         /*
706 
707         TRANSACTION AND WALLET LIMITS
708 
709         */
710         
711 
712         // Limit wallet total
713         if (to != owner() &&
714             to != Wallet_Dev &&
715             to != address(this) &&
716             to != uniswapV2Pair &&
717             to != Wallet_Burn &&
718             from != owner()){
719             uint256 heldTokens = balanceOf(to);
720             require((heldTokens + amount) <= _maxWalletToken,"You are trying to buy too many tokens. You have reached the limit for one wallet.");}
721 
722         // Limit the maximum number of tokens that can be bought or sold in one transaction
723         if (from != owner() && to != owner())
724             require(amount <= _maxTxAmount, "You are trying to buy more than the max transaction limit.");
725 
726         /*
727 
728         BLACKLIST RESTRICTIONS
729 
730         */
731         
732         if (noBlackList){
733         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted. Transaction reverted.");}
734 
735         require(from != address(0) && to != address(0), "ERR: Using 0 address!");
736         require(amount > 0, "Token value must be higher than zero.");
737 
738         /*
739 
740         PROCESSING
741 
742         */
743 
744         // SwapAndLiquify is triggered after every X transactions - this number can be adjusted using swapTrigger
745 
746         if(
747             txCount >= swapTrigger && 
748             !inSwapAndLiquify &&
749             from != uniswapV2Pair &&
750             swapAndLiquifyEnabled 
751             )
752         {  
753             
754             txCount = 0;
755             uint256 contractTokenBalance = balanceOf(address(this));
756             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
757             if(contractTokenBalance > 0){
758             swapAndLiquify(contractTokenBalance);
759         }
760         }
761 
762         /*
763 
764         REMOVE FEES IF REQUIRED
765 
766         Fee removed if the to or from address is excluded from fee.
767         Fee removed if the transfer is NOT a buy or sell.
768         Change fee amount for buy or sell.
769 
770         */
771 
772         
773         bool takeFee = true;
774          
775         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)){
776             takeFee = false;
777         } else if (from == uniswapV2Pair){_TotalFee = _buyFee;} else if (to == uniswapV2Pair){_TotalFee = _sellFee;}
778         
779         _tokenTransfer(from,to,amount,takeFee);
780     }
781 
782 
783 
784     function sendToWallet(address payable wallet, uint256 amount) private {
785             wallet.transfer(amount);
786         }
787 
788     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
789         
790         swapTokensForETH(contractTokenBalance);
791         uint256 contractETH = address(this).balance;
792         sendToWallet(Wallet_Dev,contractETH);
793     }
794 
795     function process_Tokens_Now (uint256 percent_Of_Tokens_To_Process) public onlyOwner {
796         require(!inSwapAndLiquify, "Currently processing, try later."); 
797         if (percent_Of_Tokens_To_Process > 100){percent_Of_Tokens_To_Process == 100;}
798         uint256 tokensOnContract = balanceOf(address(this));
799         uint256 sendTokens = tokensOnContract*percent_Of_Tokens_To_Process/100;
800         swapAndLiquify(sendTokens);
801     }
802 
803     function swapTokensForETH(uint256 tokenAmount) private {
804 
805         address[] memory path = new address[](2);
806         path[0] = address(this);
807         path[1] = uniswapV2Router.WETH();
808         _approve(address(this), address(uniswapV2Router), tokenAmount);
809         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
810             tokenAmount,
811             0, 
812             path,
813             address(this),
814             block.timestamp
815         );
816     }
817 
818     /*
819 
820     PURGE RANDOM TOKENS - Add the random token address and a wallet to send them to
821 
822     */
823 
824     // Remove random tokens from the contract and send to a wallet
825     function remove_Random_Tokens(address random_Token_Address, address send_to_wallet, uint256 number_of_tokens) public onlyOwner returns(bool _sent){
826         require(random_Token_Address != address(this), "Can not remove native token");
827         uint256 randomBalance = IERC20(random_Token_Address).balanceOf(address(this));
828         if (number_of_tokens > randomBalance){number_of_tokens = randomBalance;}
829         _sent = IERC20(random_Token_Address).transfer(send_to_wallet, number_of_tokens);
830     }
831 
832 
833     // Set new router and make the new pair address
834     function set_New_Router_and_Make_Pair(address newRouter) public onlyOwner() {
835         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
836         uniswapV2Pair = IUniswapV2Factory(_newPCSRouter.factory()).createPair(address(this), _newPCSRouter.WETH());
837         uniswapV2Router = _newPCSRouter;
838     }
839    
840     // Set new router
841     function set_New_Router_Address(address newRouter) public onlyOwner() {
842         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
843         uniswapV2Router = _newPCSRouter;
844     }
845     
846     // Set new address - This will be the 'Cake LP' address for the token pairing
847     function set_New_Pair_Address(address newPair) public onlyOwner() {
848         uniswapV2Pair = newPair;
849     }
850 
851     /*
852 
853     TOKEN TRANSFERS
854 
855     */
856 
857     // Check if token transfer needs to process fees
858     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
859         
860         
861         if(!takeFee){
862             removeAllFee();
863             } else {
864                 txCount++;
865             }
866             _transferTokens(sender, recipient, amount);
867         
868         if(!takeFee)
869             restoreAllFee();
870     }
871 
872     // Redistributing tokens and adding the fee to the contract address
873     function _transferTokens(address sender, address recipient, uint256 tAmount) private {
874         (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
875         _tOwned[sender] = _tOwned[sender].sub(tAmount);
876         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
877         _tOwned[address(this)] = _tOwned[address(this)].add(tDev);   
878         emit Transfer(sender, recipient, tTransferAmount);
879     }
880 
881     // Calculating the fee in tokens
882     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
883         uint256 tDev = tAmount*_TotalFee/100;
884         uint256 tTransferAmount = tAmount.sub(tDev);
885         return (tTransferAmount, tDev);
886     }
887 
888     
889 
890 }