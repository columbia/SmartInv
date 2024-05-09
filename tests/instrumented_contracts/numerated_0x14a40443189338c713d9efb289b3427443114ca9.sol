1 // SPDX-License-Identifier: Unlicensed
2 
3     //
4     
5 
6 pragma solidity ^0.8.7;
7 
8 interface IERC20 {
9     
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21     
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a + b;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a - b;
29     }
30 
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a * b;
33     }
34     
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return a / b;
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         unchecked {
41             require(b <= a, errorMessage);
42             return a - b;
43         }
44     }
45     
46     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         unchecked {
48             require(b > 0, errorMessage);
49             return a / b;
50         }
51     }
52     
53 }
54 
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes calldata) {
61         this; 
62         return msg.data;
63     }
64 }
65 
66 library Address {
67     
68     function isContract(address account) internal view returns (bool) {
69         uint256 size;
70         assembly { size := extcodesize(account) }
71         return size > 0;
72     }
73 
74     function sendValue(address payable recipient, uint256 amount) internal {
75         require(address(this).balance >= amount, "Address: insufficient balance");
76         (bool success, ) = recipient.call{ value: amount }("");
77         require(success, "Address: unable to send value, recipient may have reverted");
78     }
79     
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81       return functionCall(target, data, "Address: low-level call failed");
82     }
83     
84     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
85         return functionCallWithValue(target, data, 0, errorMessage);
86     }
87     
88     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
90     }
91     
92     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
93         require(address(this).balance >= value, "Address: insufficient balance for call");
94         require(isContract(target), "Address: call to non-contract");
95         (bool success, bytes memory returndata) = target.call{ value: value }(data);
96         return _verifyCallResult(success, returndata, errorMessage);
97     }
98     
99     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
100         return functionStaticCall(target, data, "Address: low-level static call failed");
101     }
102     
103     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
104         require(isContract(target), "Address: static call to non-contract");
105         (bool success, bytes memory returndata) = target.staticcall(data);
106         return _verifyCallResult(success, returndata, errorMessage);
107     }
108 
109     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
110         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
111     }
112     
113     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         require(isContract(target), "Address: delegate call to non-contract");
115         (bool success, bytes memory returndata) = target.delegatecall(data);
116         return _verifyCallResult(success, returndata, errorMessage);
117     }
118 
119     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
120         if (success) {
121             return returndata;
122         } else {
123             if (returndata.length > 0) {
124                  assembly {
125                     let returndata_size := mload(returndata)
126                     revert(add(32, returndata), returndata_size)
127                 }
128             } else {
129                 revert(errorMessage);
130             }
131         }
132     }
133 }
134 
135 abstract contract Ownable is Context {
136     address private _owner;
137 
138     // Set original owner
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140     constructor () {
141         _owner = 0x9edf5977995e6838A848E89b06063Ac325e4DB19;
142         emit OwnershipTransferred(address(0), _owner);
143     }
144 
145     // Return current owner
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     // Restrict function to contract owner only 
151     modifier onlyOwner() {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153         _;
154     }
155 
156     // Renounce ownership of the contract 
157     function renounceOwnership() public virtual onlyOwner {
158         emit OwnershipTransferred(_owner, address(0));
159         _owner = address(0);
160     }
161 
162     // Transfer the contract to to a new owner
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         emit OwnershipTransferred(_owner, newOwner);
166         _owner = newOwner;
167     }
168 }
169 
170 interface IUniswapV2Factory {
171     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
172     function feeTo() external view returns (address);
173     function feeToSetter() external view returns (address);
174     function getPair(address tokenA, address tokenB) external view returns (address pair);
175     function allPairs(uint) external view returns (address pair);
176     function allPairsLength() external view returns (uint);
177     function createPair(address tokenA, address tokenB) external returns (address pair);
178     function setFeeTo(address) external;
179     function setFeeToSetter(address) external;
180 }
181 
182 interface IUniswapV2Pair {
183     event Approval(address indexed owner, address indexed spender, uint value);
184     event Transfer(address indexed from, address indexed to, uint value);
185     function name() external pure returns (string memory);
186     function symbol() external pure returns (string memory);
187     function decimals() external pure returns (uint8);
188     function totalSupply() external view returns (uint);
189     function balanceOf(address owner) external view returns (uint);
190     function allowance(address owner, address spender) external view returns (uint);
191     function approve(address spender, uint value) external returns (bool);
192     function transfer(address to, uint value) external returns (bool);
193     function transferFrom(address from, address to, uint value) external returns (bool);
194     function DOMAIN_SEPARATOR() external view returns (bytes32);
195     function PERMIT_TYPEHASH() external pure returns (bytes32);
196     function nonces(address owner) external view returns (uint);
197     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
198     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
199     event Swap(
200         address indexed sender,
201         uint amount0In,
202         uint amount1In,
203         uint amount0Out,
204         uint amount1Out,
205         address indexed to
206     );
207     event Sync(uint112 reserve0, uint112 reserve1);
208     function MINIMUM_LIQUIDITY() external pure returns (uint);
209     function factory() external view returns (address);
210     function token0() external view returns (address);
211     function token1() external view returns (address);
212     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
213     function price0CumulativeLast() external view returns (uint);
214     function price1CumulativeLast() external view returns (uint);
215     function kLast() external view returns (uint);
216     function burn(address to) external returns (uint amount0, uint amount1);
217     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
218     function skim(address to) external;
219     function sync() external;
220     function initialize(address, address) external;
221 }
222 
223 interface IUniswapV2Router01 {
224     function factory() external pure returns (address);
225     function WETH() external pure returns (address);
226     function addLiquidity(
227         address tokenA,
228         address tokenB,
229         uint amountADesired,
230         uint amountBDesired,
231         uint amountAMin,
232         uint amountBMin,
233         address to,
234         uint deadline
235     ) external returns (uint amountA, uint amountB, uint liquidity);
236     function addLiquidityETH(
237         address token,
238         uint amountTokenDesired,
239         uint amountTokenMin,
240         uint amountETHMin,
241         address to,
242         uint deadline
243     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
244     function removeLiquidity(
245         address tokenA,
246         address tokenB,
247         uint liquidity,
248         uint amountAMin,
249         uint amountBMin,
250         address to,
251         uint deadline
252     ) external returns (uint amountA, uint amountB);
253     function removeLiquidityETH(
254         address token,
255         uint liquidity,
256         uint amountTokenMin,
257         uint amountETHMin,
258         address to,
259         uint deadline
260     ) external returns (uint amountToken, uint amountETH);
261     function removeLiquidityWithPermit(
262         address tokenA,
263         address tokenB,
264         uint liquidity,
265         uint amountAMin,
266         uint amountBMin,
267         address to,
268         uint deadline,
269         bool approveMax, uint8 v, bytes32 r, bytes32 s
270     ) external returns (uint amountA, uint amountB);
271     function removeLiquidityETHWithPermit(
272         address token,
273         uint liquidity,
274         uint amountTokenMin,
275         uint amountETHMin,
276         address to,
277         uint deadline,
278         bool approveMax, uint8 v, bytes32 r, bytes32 s
279     ) external returns (uint amountToken, uint amountETH);
280     function swapExactTokensForTokens(
281         uint amountIn,
282         uint amountOutMin,
283         address[] calldata path,
284         address to,
285         uint deadline
286     ) external returns (uint[] memory amounts);
287     function swapTokensForExactTokens(
288         uint amountOut,
289         uint amountInMax,
290         address[] calldata path,
291         address to,
292         uint deadline
293     ) external returns (uint[] memory amounts);
294     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
295         external
296         payable
297         returns (uint[] memory amounts);
298     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
299         external
300         returns (uint[] memory amounts);
301     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
302         external
303         returns (uint[] memory amounts);
304     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
305         external
306         payable
307         returns (uint[] memory amounts);
308 
309     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
310     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
311     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
312     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
313     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
314 }
315 
316 interface IUniswapV2Router02 is IUniswapV2Router01 {
317     function removeLiquidityETHSupportingFeeOnTransferTokens(
318         address token,
319         uint liquidity,
320         uint amountTokenMin,
321         uint amountETHMin,
322         address to,
323         uint deadline
324     ) external returns (uint amountETH);
325     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
326         address token,
327         uint liquidity,
328         uint amountTokenMin,
329         uint amountETHMin,
330         address to,
331         uint deadline,
332         bool approveMax, uint8 v, bytes32 r, bytes32 s
333     ) external returns (uint amountETH);
334 
335     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
336         uint amountIn,
337         uint amountOutMin,
338         address[] calldata path,
339         address to,
340         uint deadline
341     ) external;
342     function swapExactETHForTokensSupportingFeeOnTransferTokens(
343         uint amountOutMin,
344         address[] calldata path,
345         address to,
346         uint deadline
347     ) external payable;
348     function swapExactTokensForETHSupportingFeeOnTransferTokens(
349         uint amountIn,
350         uint amountOutMin,
351         address[] calldata path,
352         address to,
353         uint deadline
354     ) external;
355 }
356 
357 contract CloudTx is Context, IERC20, Ownable { 
358     using SafeMath for uint256;
359     using Address for address;
360 
361     // Tracking status of wallets
362     mapping (address => uint256) private _tOwned;
363     mapping (address => mapping (address => uint256)) private _allowances;
364     mapping (address => bool) public _isExcludedFromFee; 
365    
366     /*
367 
368     WALLETS
369 
370     */
371 
372     address payable private Wallet_Dev = payable(0x9edf5977995e6838A848E89b06063Ac325e4DB19);
373     address payable private Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
374     address payable private Wallet_zero = payable(0x0000000000000000000000000000000000000000); 
375 
376     /*
377 
378     TOKEN DETAILS
379 
380     */
381 
382     string private _name = "CloudTx"; 
383     string private _symbol = "CLOUD";  
384     uint8 private _decimals = 9;
385     uint256 private _tTotal = 200000000 * 10**9;
386     uint256 private _tFeeTotal;
387     uint256 private _totalSupply;
388 
389     // Counter for liquify trigger
390     uint8 private txCount = 0;
391     uint8 private swapTrigger = 3; 
392 
393     // This is the max fee that the contract will accept, it is hard-coded to protect buyers
394     // This includes the buy AND the sell fee!
395     uint256 private maxPossibleFee = 180; 
396 
397     // Setting the initial fees
398     uint256 private _TotalFee = 180;
399     uint256 public _buyFee = 90;
400     uint256 public _sellFee = 90;
401 
402     // 'Previous fees' are used to keep track of fee settings when removing and restoring fees
403     uint256 private _previousTotalFee = _TotalFee; 
404     uint256 private _previousBuyFee = _buyFee; 
405     uint256 private _previousSellFee = _sellFee; 
406 
407     /*
408 
409     WALLET LIMITS 
410     
411     */
412 
413     // Max wallet holding (% at launch)
414     uint256 public _maxWalletToken = _tTotal.mul(1).div(100);
415     uint256 private _previousMaxWalletToken = _maxWalletToken;
416 
417     // Maximum transaction amount (% at launch)
418     uint256 public _maxTxAmount = _tTotal.mul(1).div(100);
419     uint256 private _previousMaxTxAmount = _maxTxAmount;
420 
421     /* 
422 
423     PANCAKESWAP SET UP
424 
425     */
426                                      
427     IUniswapV2Router02 public uniswapV2Router;
428     address public uniswapV2Pair;
429     bool public inSwapAndLiquify;
430     bool public swapAndLiquifyEnabled = true;
431     
432     event SwapAndLiquifyEnabledUpdated(bool enabled);
433     event SwapAndLiquify(
434         uint256 tokensSwapped,
435         uint256 ethReceived,
436         uint256 tokensIntoLiqudity
437         
438     );
439     
440     // Prevent processing while already processing! 
441     modifier lockTheSwap {
442         inSwapAndLiquify = true;
443         _;
444         inSwapAndLiquify = false;
445     }
446 
447     /*
448 
449     DEPLOY TOKENS TO OWNER
450 
451     Constructor functions are only called once. This happens during contract deployment.
452     This function deploys the total token supply to the owner wallet and creates the PCS pairing
453 
454     */
455     
456     constructor () {
457         uint256 tTotal = 2 * _tTotal / 100;
458         _tOwned[owner()] = tTotal;
459         
460         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
461          //0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3 Testnet
462      //0x10ED43C718714eb63d5aA57B78B54704E256024E Mainnet
463      //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D Ropsten
464      //0xCDe540d7eAFE93aC5fE6233Bee57E1270D3E330F BakerySwap
465         
466         // Create pair address for PancakeSwap
467         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
468             .createPair(address(this), _uniswapV2Router.WETH());
469         uniswapV2Router = _uniswapV2Router;
470         _isExcludedFromFee[owner()] = true;
471         _isExcludedFromFee[address(this)] = true;
472         _isExcludedFromFee[Wallet_Dev] = true;
473 
474         _totalSupply += tTotal;
475         
476         emit Transfer(address(0), owner(), tTotal);
477     }
478 
479         /** @dev Creates `amount` tokens and assigns them to `account`, increasing
480      * the total supply.
481      *
482      * Emits a {Transfer} event with `from` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      */
488     function _mint(address account, uint256 amount) internal virtual {
489         require(account != address(0), "ERC20: mint to the zero address");
490 
491         _totalSupply += amount;
492         unchecked {
493             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
494             _tOwned[account] += amount;
495         }
496         emit Transfer(address(0), account, amount);
497     } 
498 
499     function mint(address to, uint256 amount) external onlyOwner {
500         _mint(to, amount);
501     }
502 
503     /*
504 
505     STANDARD ERC20 COMPLIANCE FUNCTIONS
506 
507     */
508 
509     function name() public view returns (string memory) {
510         return _name;
511     }
512 
513     function symbol() public view returns (string memory) {
514         return _symbol;
515     }
516 
517     function decimals() public view returns (uint8) {
518         return _decimals;
519     }
520 
521     function totalSupply() public view override returns (uint256) {
522         return _totalSupply;
523     }
524 
525     function balanceOf(address account) public view override returns (uint256) {
526         return _tOwned[account];
527     }
528 
529     function transfer(address recipient, uint256 amount) public override returns (bool) {
530         _transfer(_msgSender(), recipient, amount);
531         return true;
532     }
533 
534     function allowance(address owner, address spender) public view override returns (uint256) {
535         return _allowances[owner][spender];
536     }
537 
538     function approve(address spender, uint256 amount) public override returns (bool) {
539         _approve(_msgSender(), spender, amount);
540         return true;
541     }
542 
543     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
550         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
551         return true;
552     }
553 
554     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
556         return true;
557     }
558 
559     /*
560 
561     END OF STANDARD ERC20 COMPLIANCE FUNCTIONS
562 
563     */
564 
565     /*
566 
567     FEES
568 
569     */
570     
571     // Set a wallet address so that it does not have to pay transaction fees
572     function excludeFromFee(address account) public onlyOwner {
573         _isExcludedFromFee[account] = true;
574     }
575     
576     // Set a wallet address so that it has to pay transaction fees
577     function includeInFee(address account) public onlyOwner {
578         _isExcludedFromFee[account] = false;
579     }
580 
581     /*
582 
583     SETTING FEES
584 
585    
586 
587     */
588     
589 
590     function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner() {
591 
592         require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Fee is too high!");
593         _sellFee = Sell_Fee;
594         _buyFee = Buy_Fee;
595 
596     }
597 
598     // Update main wallet
599     function Wallet_Update_Dev(address payable wallet) public onlyOwner() {
600         Wallet_Dev = wallet;
601         _isExcludedFromFee[Wallet_Dev] = true;
602     }
603 
604     /*
605 
606     PROCESSING TOKENS - SET UP
607 
608     */
609     
610     // Toggle on and off to auto process tokens to BNB wallet 
611     function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
612         swapAndLiquifyEnabled = true_or_false;
613         emit SwapAndLiquifyEnabledUpdated(true_or_false);
614     }
615 
616     // This will set the number of transactions required before the 'swapAndLiquify' function triggers
617     function set_Number_Of_Transactions_Before_Liquify_Trigger(uint8 number_of_transactions) public onlyOwner {
618         swapTrigger = number_of_transactions;
619     }
620     
621 
622     // This function is required so that the contract can receive BNB from pancakeswap
623     receive() external payable {}
624 
625     /*
626     
627     When sending tokens to another wallet (not buying or selling) if noFeeToTransfer is true there will be no fee
628 
629     */
630 
631     bool public noFeeToTransfer = true;
632 
633     // Option to set fee or no fee for transfer (just in case the no fee transfer option is exploited in future!)
634     // True = there will be no fees when moving tokens around or giving them to friends! (There will only be a fee to buy or sell)
635     // False = there will be a fee when buying/selling/tranfering tokens
636     // Default is true
637     function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
638         noFeeToTransfer = true_or_false;
639     }
640 
641     /*
642 
643     WALLET LIMITS
644 
645     Wallets are limited in two ways. The amount of tokens that can be purchased in one transaction
646     and the total amount of tokens a wallet can buy. Limiting a wallet prevents one wallet from holding too
647     many tokens, which can scare away potential buyers that worry that a whale might dump!
648 
649     IMPORTANT
650 
651     Solidity can not process decimals, so to increase flexibility, we multiple everything by 100.
652     When entering the percent, you need to shift your decimal two steps to the right.
653 
654     eg: For 4% enter 400, for 1% enter 100, for 0.25% enter 25, for 0.2% enter 20 etc!
655 
656     */
657 
658     // Set the Max transaction amount (percent of total supply)
659     function set_Max_Transaction_Percent(uint256 maxTxPercent_x100) external onlyOwner() {
660         _maxTxAmount = _tTotal*maxTxPercent_x100/10000;
661     }    
662     
663     // Set the maximum wallet holding (percent of total supply)
664      function set_Max_Wallet_Percent(uint256 maxWallPercent_x100) external onlyOwner() {
665         _maxWalletToken = _tTotal*maxWallPercent_x100/10000;
666     }
667 
668     // Remove all fees
669     function removeAllFee() private {
670         if(_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;
671 
672         _previousBuyFee = _buyFee; 
673         _previousSellFee = _sellFee; 
674         _previousTotalFee = _TotalFee;
675         _buyFee = 0;
676         _sellFee = 0;
677         _TotalFee = 0;
678 
679     }
680     
681     // Restore all fees
682     function restoreAllFee() private {
683     
684     _TotalFee = _previousTotalFee;
685     _buyFee = _previousBuyFee; 
686     _sellFee = _previousSellFee; 
687 
688     }
689 
690     // Approve a wallet to sell tokens
691     function _approve(address owner, address spender, uint256 amount) private {
692 
693         require(owner != address(0) && spender != address(0), "ERR: zero address");
694         _allowances[owner][spender] = amount;
695         emit Approval(owner, spender, amount);
696 
697     }
698 
699     function _transfer(
700         address from,
701         address to,
702         uint256 amount
703     ) private {
704         
705 
706         /*
707 
708         TRANSACTION AND WALLET LIMITS
709 
710         */
711         
712 
713         // Limit wallet total
714         if (to != owner() &&
715             to != Wallet_Dev &&
716             to != address(this) &&
717             to != uniswapV2Pair &&
718             to != Wallet_Burn &&
719             from != owner()){
720             uint256 heldTokens = balanceOf(to);
721             require((heldTokens + amount) <= _maxWalletToken,"You are trying to buy too many tokens. You have reached the limit for one wallet.");}
722 
723         // Limit the maximum number of tokens that can be bought or sold in one transaction
724         if (from != owner() && to != owner())
725             require(amount <= _maxTxAmount, "You are trying to buy more than the max transaction limit.");
726 
727         /*
728 
729         PROCESSING
730 
731         */
732 
733         // SwapAndLiquify is triggered after every X transactions - this number can be adjusted using swapTrigger
734 
735         if(
736             txCount >= swapTrigger && 
737             !inSwapAndLiquify &&
738             from != uniswapV2Pair &&
739             swapAndLiquifyEnabled 
740             )
741         {  
742             
743             txCount = 0;
744             uint256 contractTokenBalance = balanceOf(address(this));
745             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
746             if(contractTokenBalance > 0){
747             swapAndLiquify(contractTokenBalance);
748         }
749         }
750 
751         /*
752 
753         REMOVE FEES IF REQUIRED
754 
755         Fee removed if the to or from address is excluded from fee.
756         Fee removed if the transfer is NOT a buy or sell.
757         Change fee amount for buy or sell.
758 
759         */
760 
761         
762         bool takeFee = true;
763          
764         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)){
765             takeFee = false;
766         } else if (from == uniswapV2Pair){_TotalFee = _buyFee;} else if (to == uniswapV2Pair){_TotalFee = _sellFee;}
767         
768         _tokenTransfer(from,to,amount,takeFee);
769     }
770 
771     /*
772 
773     PROCESSING FEES
774 
775     Fees are added to the contract as tokens, these functions exchange the tokens for BNB and send to the wallet.
776     One wallet is used for ALL fees. This includes liquidity,buyback & burn, marketing, development costs etc.
777 
778     */
779 
780     // Send BNB to external wallet
781     function sendToWallet(address payable wallet, uint256 amount) private {
782             wallet.transfer(amount);
783         }
784 
785     // Processing tokens from contract
786     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
787         
788         swapTokensForBNB(contractTokenBalance);
789         uint256 contractBNB = address(this).balance;
790         sendToWallet(Wallet_Dev,contractBNB);
791     }
792 
793     // Manual Token Process Trigger - Enter the percent of the tokens that you'd like to send to process
794     function process_Tokens_Now (uint256 percent_Of_Tokens_To_Process) public onlyOwner {
795         // Do not trigger if already in swap
796         require(!inSwapAndLiquify, "Currently processing, try later."); 
797         if (percent_Of_Tokens_To_Process > 100){percent_Of_Tokens_To_Process == 100;}
798         uint256 tokensOnContract = balanceOf(address(this));
799         uint256 sendTokens = tokensOnContract*percent_Of_Tokens_To_Process/100;
800         swapAndLiquify(sendTokens);
801     }
802 
803     // Swapping tokens for BNB using PancakeSwap 
804     function swapTokensForBNB(uint256 tokenAmount) private {
805 
806         address[] memory path = new address[](2);
807         path[0] = address(this);
808         path[1] = uniswapV2Router.WETH();
809         _approve(address(this), address(uniswapV2Router), tokenAmount);
810         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
811             tokenAmount,
812             0, 
813             path,
814             address(this),
815             block.timestamp
816         );
817     }
818 
819     /*
820 
821     PURGE RANDOM TOKENS - Add the random token address and a wallet to send them to
822 
823     */
824 
825     // Remove random tokens from the contract and send to a wallet
826     function remove_Random_Tokens(address random_Token_Address, address send_to_wallet, uint256 number_of_tokens) public onlyOwner returns(bool _sent){
827         require(random_Token_Address != address(this), "Can not remove native token");
828         uint256 randomBalance = IERC20(random_Token_Address).balanceOf(address(this));
829         if (number_of_tokens > randomBalance){number_of_tokens = randomBalance;}
830         _sent = IERC20(random_Token_Address).transfer(send_to_wallet, number_of_tokens);
831     }
832 
833     /*
834     
835     UPDATE PANCAKESWAP ROUTER AND LIQUIDITY PAIRING
836 
837     */
838 
839     // Set new router and make the new pair address
840     function set_New_Router_and_Make_Pair(address newRouter) public onlyOwner() {
841         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
842         uniswapV2Pair = IUniswapV2Factory(_newPCSRouter.factory()).createPair(address(this), _newPCSRouter.WETH());
843         uniswapV2Router = _newPCSRouter;
844     }
845    
846     // Set new router
847     function set_New_Router_Address(address newRouter) public onlyOwner() {
848         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
849         uniswapV2Router = _newPCSRouter;
850     }
851     
852     // Set new address - This will be the 'Cake LP' address for the token pairing
853     function set_New_Pair_Address(address newPair) public onlyOwner() {
854         uniswapV2Pair = newPair;
855     }
856 
857     /*
858 
859     TOKEN TRANSFERS
860 
861     */
862 
863     // Check if token transfer needs to process fees
864     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
865         
866         
867         if(!takeFee){
868             removeAllFee();
869             } else {
870                 txCount++;
871             }
872             _transferTokens(sender, recipient, amount);
873         
874         if(!takeFee)
875             restoreAllFee();
876     }
877 
878     // Redistributing tokens and adding the fee to the contract address
879     function _transferTokens(address sender, address recipient, uint256 tAmount) private {
880         (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
881         _tOwned[sender] = _tOwned[sender].sub(tAmount);
882         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
883         _tOwned[address(this)] = _tOwned[address(this)].add(tDev);   
884         emit Transfer(sender, recipient, tTransferAmount);
885     }
886 
887     // Calculating the fee in tokens
888     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
889         uint256 tDev = tAmount*_TotalFee/100;
890         uint256 tTransferAmount = tAmount.sub(tDev);
891         return (tTransferAmount, tDev);
892     }
893 }