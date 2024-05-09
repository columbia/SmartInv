1 /**
2 TRITANIUM BLOCKCHAIN
3 BUILDING FUTURE BLOCKCHAIN
4 Building the Future BLOCKCHAIN with Proof of Stake
5 
6 Website     : https://tritanium.network
7 Telegram    : https://t.me/TritaniumGroup
8 Twitter     : https://twitter.com/TritaniumChain
9 Whitepaper  : https://tritanium.network/whitepaper.pdf
10 Github      : https://github.com/tritaniumnetwork
11 
12 /*
13 
14 */
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.8.7;
18 
19 
20 interface IERC20 {
21     
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         return a + b;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a - b;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a * b;
45     }
46     
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a / b;
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         unchecked {
53             require(b <= a, errorMessage);
54             return a - b;
55         }
56     }
57     
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         unchecked {
60             require(b > 0, errorMessage);
61             return a / b;
62         }
63     }
64     
65 }
66 
67 
68 
69 abstract contract Context {
70     function _msgSender() internal view virtual returns (address) {
71         return msg.sender;
72     }
73 
74     function _msgData() internal view virtual returns (bytes calldata) {
75         this; 
76         return msg.data;
77     }
78 }
79 
80 
81 library Address {
82     
83     function isContract(address account) internal view returns (bool) {
84         uint256 size;
85         assembly { size := extcodesize(account) }
86         return size > 0;
87     }
88 
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(address(this).balance >= amount, "Address: insufficient balance");
91         (bool success, ) = recipient.call{ value: amount }("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94     
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96       return functionCall(target, data, "Address: low-level call failed");
97     }
98     
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, 0, errorMessage);
101     }
102     
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106     
107     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
108         require(address(this).balance >= value, "Address: insufficient balance for call");
109         require(isContract(target), "Address: call to non-contract");
110         (bool success, bytes memory returndata) = target.call{ value: value }(data);
111         return _verifyCallResult(success, returndata, errorMessage);
112     }
113     
114     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
115         return functionStaticCall(target, data, "Address: low-level static call failed");
116     }
117     
118     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
119         require(isContract(target), "Address: static call to non-contract");
120         (bool success, bytes memory returndata) = target.staticcall(data);
121         return _verifyCallResult(success, returndata, errorMessage);
122     }
123 
124 
125     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
126         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
127     }
128     
129     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
130         require(isContract(target), "Address: delegate call to non-contract");
131         (bool success, bytes memory returndata) = target.delegatecall(data);
132         return _verifyCallResult(success, returndata, errorMessage);
133     }
134 
135     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
136         if (success) {
137             return returndata;
138         } else {
139             if (returndata.length > 0) {
140                  assembly {
141                     let returndata_size := mload(returndata)
142                     revert(add(32, returndata), returndata_size)
143                 }
144             } else {
145                 revert(errorMessage);
146             }
147         }
148     }
149 }
150 
151 abstract contract Ownable is Context {
152     address private _owner;
153 
154 
155     // Set original owner
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157     constructor () {
158         _owner = 0x65AB4f33F28E7daF3cB5744142eddD97EB41883F;
159         emit OwnershipTransferred(address(0), _owner);
160     }
161 
162     // Return current owner
163     function owner() public view virtual returns (address) {
164         return _owner;
165     }
166 
167     // Restrict function to contract owner only 
168     modifier onlyOwner() {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     // Renounce ownership of the contract 
174     function renounceOwnership() public virtual onlyOwner {
175         emit OwnershipTransferred(_owner, address(0));
176         _owner = address(0);
177     }
178 
179     // Transfer the contract to to a new owner
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 interface IUniswapV2Factory {
188     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
189     function feeTo() external view returns (address);
190     function feeToSetter() external view returns (address);
191     function getPair(address tokenA, address tokenB) external view returns (address pair);
192     function allPairs(uint) external view returns (address pair);
193     function allPairsLength() external view returns (uint);
194     function createPair(address tokenA, address tokenB) external returns (address pair);
195     function setFeeTo(address) external;
196     function setFeeToSetter(address) external;
197 }
198 
199 interface IUniswapV2Pair {
200     event Approval(address indexed owner, address indexed spender, uint value);
201     event Transfer(address indexed from, address indexed to, uint value);
202     function name() external pure returns (string memory);
203     function symbol() external pure returns (string memory);
204     function decimals() external pure returns (uint8);
205     function totalSupply() external view returns (uint);
206     function balanceOf(address owner) external view returns (uint);
207     function allowance(address owner, address spender) external view returns (uint);
208     function approve(address spender, uint value) external returns (bool);
209     function transfer(address to, uint value) external returns (bool);
210     function transferFrom(address from, address to, uint value) external returns (bool);
211     function DOMAIN_SEPARATOR() external view returns (bytes32);
212     function PERMIT_TYPEHASH() external pure returns (bytes32);
213     function nonces(address owner) external view returns (uint);
214     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
215     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
216     event Swap(
217         address indexed sender,
218         uint amount0In,
219         uint amount1In,
220         uint amount0Out,
221         uint amount1Out,
222         address indexed to
223     );
224     event Sync(uint112 reserve0, uint112 reserve1);
225     function MINIMUM_LIQUIDITY() external pure returns (uint);
226     function factory() external view returns (address);
227     function token0() external view returns (address);
228     function token1() external view returns (address);
229     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
230     function price0CumulativeLast() external view returns (uint);
231     function price1CumulativeLast() external view returns (uint);
232     function kLast() external view returns (uint);
233     function burn(address to) external returns (uint amount0, uint amount1);
234     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
235     function skim(address to) external;
236     function sync() external;
237     function initialize(address, address) external;
238 }
239 
240 interface IUniswapV2Router01 {
241     function factory() external pure returns (address);
242     function WETH() external pure returns (address);
243     function addLiquidity(
244         address tokenA,
245         address tokenB,
246         uint amountADesired,
247         uint amountBDesired,
248         uint amountAMin,
249         uint amountBMin,
250         address to,
251         uint deadline
252     ) external returns (uint amountA, uint amountB, uint liquidity);
253     function addLiquidityETH(
254         address token,
255         uint amountTokenDesired,
256         uint amountTokenMin,
257         uint amountETHMin,
258         address to,
259         uint deadline
260     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
261     function removeLiquidity(
262         address tokenA,
263         address tokenB,
264         uint liquidity,
265         uint amountAMin,
266         uint amountBMin,
267         address to,
268         uint deadline
269     ) external returns (uint amountA, uint amountB);
270     function removeLiquidityETH(
271         address token,
272         uint liquidity,
273         uint amountTokenMin,
274         uint amountETHMin,
275         address to,
276         uint deadline
277     ) external returns (uint amountToken, uint amountETH);
278     function removeLiquidityWithPermit(
279         address tokenA,
280         address tokenB,
281         uint liquidity,
282         uint amountAMin,
283         uint amountBMin,
284         address to,
285         uint deadline,
286         bool approveMax, uint8 v, bytes32 r, bytes32 s
287     ) external returns (uint amountA, uint amountB);
288     function removeLiquidityETHWithPermit(
289         address token,
290         uint liquidity,
291         uint amountTokenMin,
292         uint amountETHMin,
293         address to,
294         uint deadline,
295         bool approveMax, uint8 v, bytes32 r, bytes32 s
296     ) external returns (uint amountToken, uint amountETH);
297     function swapExactTokensForTokens(
298         uint amountIn,
299         uint amountOutMin,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external returns (uint[] memory amounts);
304     function swapTokensForExactTokens(
305         uint amountOut,
306         uint amountInMax,
307         address[] calldata path,
308         address to,
309         uint deadline
310     ) external returns (uint[] memory amounts);
311     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
312         external
313         payable
314         returns (uint[] memory amounts);
315     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
316         external
317         returns (uint[] memory amounts);
318     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
319         external
320         returns (uint[] memory amounts);
321     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
322         external
323         payable
324         returns (uint[] memory amounts);
325 
326     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
327     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
328     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
329     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
330     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
331 }
332 
333 interface IUniswapV2Router02 is IUniswapV2Router01 {
334     function removeLiquidityETHSupportingFeeOnTransferTokens(
335         address token,
336         uint liquidity,
337         uint amountTokenMin,
338         uint amountETHMin,
339         address to,
340         uint deadline
341     ) external returns (uint amountETH);
342     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
343         address token,
344         uint liquidity,
345         uint amountTokenMin,
346         uint amountETHMin,
347         address to,
348         uint deadline,
349         bool approveMax, uint8 v, bytes32 r, bytes32 s
350     ) external returns (uint amountETH);
351 
352     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
353         uint amountIn,
354         uint amountOutMin,
355         address[] calldata path,
356         address to,
357         uint deadline
358     ) external;
359     function swapExactETHForTokensSupportingFeeOnTransferTokens(
360         uint amountOutMin,
361         address[] calldata path,
362         address to,
363         uint deadline
364     ) external payable;
365     function swapExactTokensForETHSupportingFeeOnTransferTokens(
366         uint amountIn,
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external;
372 }
373 
374 
375 contract Tritanium is Context, IERC20, Ownable { 
376     using SafeMath for uint256;
377     using Address for address;
378 
379 
380     // Tracking status of wallets
381     mapping (address => uint256) private _tOwned;
382     mapping (address => mapping (address => uint256)) private _allowances;
383     mapping (address => bool) public _isExcludedFromFee; 
384 
385 
386     /*
387 
388     */
389 
390 
391     address payable public contract_creators = payable(0xD141c84E7Ce4eb47247553C627160c08962935E0);
392     address payable public Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
393     address payable public Wallet_zero = payable(0x0000000000000000000000000000000000000000); 
394 
395 
396     /*
397 
398 
399     */
400 
401     string private _name = "Tritanium"; 
402     string private _symbol = "TRN";  
403     uint8 private _decimals = 18;
404     uint256 private _tTotal = 10000000 * 10**18;
405     uint256 private _tFeeTotal;
406 
407     // Counter for liquify trigger
408     uint8 private txCount = 0;
409     uint8 private swapTrigger = 3; 
410 
411     // This is the set max fees only maximum 15
412     // This includes the buy AND the sell fees!
413     uint256 private maxPossibleFee = 15; 
414 
415 
416     // Setting the initial fees
417     uint256 private _TotalFee = 14;
418     uint256 public _buyFee = 7;
419     uint256 public _sellFee = 7;
420 
421 
422     // 'Previous fees' are used to keep track of fee settings when removing and restoring fees
423     uint256 private _previousTotalFee = _TotalFee; 
424     uint256 private _previousBuyFee = _buyFee; 
425     uint256 private _previousSellFee = _sellFee; 
426 
427     /*
428 
429     WALLET LIMITS 
430     
431     */
432 
433     // Max wallet holding (1% at launch)
434     uint256 public _maxWalletToken = _tTotal.mul(2).div(100);
435     uint256 private _previousMaxWalletToken = _maxWalletToken;
436 
437 
438     // Maximum transaction amount (1% at launch)
439     uint256 public _maxTxAmount = _tTotal.mul(2).div(100); 
440     uint256 private _previousMaxTxAmount = _maxTxAmount;
441 
442     /* 
443 
444     */
445                                      
446     IUniswapV2Router02 public uniswapV2Router;
447     address public uniswapV2Pair;
448     bool public inSwapAndLiquify;
449     bool public swapAndLiquifyEnabled = true;
450     
451     event SwapAndLiquifyEnabledUpdated(bool enabled);
452     event SwapAndLiquify(
453         uint256 tokensSwapped,
454         uint256 ethReceived,
455         uint256 tokensIntoLiqudity
456         
457     );
458     
459     // Prevent processing while already processing! 
460     modifier lockTheSwap {
461         inSwapAndLiquify = true;
462         _;
463         inSwapAndLiquify = false;
464     }
465 
466     /*
467 
468     DEPLOY TOKENS TO OWNER
469 
470     Constructor functions are only called once. This happens during contract deployment.
471     This function deploys the total token supply to the owner wallet and creates the PCS pairing
472 
473     */
474     
475     constructor () {
476         _tOwned[owner()] = _tTotal;
477         
478         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
479         
480         
481         // Create pair address for PancakeSwap
482         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
483             .createPair(address(this), _uniswapV2Router.WETH());
484         uniswapV2Router = _uniswapV2Router;
485         _isExcludedFromFee[owner()] = true;
486         _isExcludedFromFee[address(this)] = true;
487         _isExcludedFromFee[contract_creators] = true;
488         
489         emit Transfer(address(0), owner(), _tTotal);
490     }
491 
492 
493     /*
494     Tritanium
495 
496     */
497 
498     function name() public view returns (string memory) {
499         return _name;
500     }
501 
502     function symbol() public view returns (string memory) {
503         return _symbol;
504     }
505 
506     function decimals() public view returns (uint8) {
507         return _decimals;
508     }
509 
510     function totalSupply() public view override returns (uint256) {
511         return _tTotal;
512     }
513 
514     function balanceOf(address account) public view override returns (uint256) {
515         return _tOwned[account];
516     }
517 
518     function transfer(address recipient, uint256 amount) public override returns (bool) {
519         _transfer(_msgSender(), recipient, amount);
520         return true;
521     }
522 
523     function allowance(address owner, address spender) public view override returns (uint256) {
524         return _allowances[owner][spender];
525     }
526 
527     function approve(address spender, uint256 amount) public override returns (bool) {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
533         _transfer(sender, recipient, amount);
534         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
535         return true;
536     }
537 
538     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
539         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
540         return true;
541     }
542 
543     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
544         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
545         return true;
546     }
547 
548 
549     /*
550 
551     END OF STANDARD ERC20 COMPLIANCE FUNCTIONS
552 
553     */
554 
555     /*
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
569 
570     /*
571 
572     */
573     
574 
575     function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner() {
576 
577         require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Fee is too high!");
578         _sellFee = Sell_Fee;
579         _buyFee = Buy_Fee;
580 
581     }
582 
583 
584 
585     // Update main wallet
586     function Wallet_Update_Dev(address payable wallet) public onlyOwner() {
587         contract_creators = wallet;
588         _isExcludedFromFee[contract_creators] = true;
589     }
590 
591 
592     /*
593 
594     */
595     
596     // Toggle on and off to auto process tokens to BNB wallet 
597     function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
598         swapAndLiquifyEnabled = true_or_false;
599         emit SwapAndLiquifyEnabledUpdated(true_or_false);
600     }
601 
602     // This will set the number of transactions required before the 'swapAndLiquify' function triggers
603     function set_Number_Of_Transactions_Before_Liquify_Trigger(uint8 number_of_transactions) public onlyOwner {
604         swapTrigger = number_of_transactions;
605     }
606     
607 
608 
609     // This function is required so that the contract can receive BNB from pancakeswap
610     receive() external payable {}
611 
612 
613 
614     /*
615     
616     When sending tokens to another wallet (not buying or selling) if noFeeToTransfer is true there will be no fee
617 
618     */
619 
620     bool public noFeeToTransfer = true;
621 
622     // Option to set fee or no fee for transfer (just in case the no fee transfer option is exploited in future!)
623     // True = there will be no fees when moving tokens around or giving them to friends! (There will only be a fee to buy or sell)
624     // False = there will be a fee when buying/selling/tranfering tokens
625     // Default is true
626     function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
627         noFeeToTransfer = true_or_false;
628     }
629 
630     /*
631 
632     WALLET LIMITS
633 
634     Wallets are limited in two ways. The amount of tokens that can be purchased in one transaction
635     and the total amount of tokens a wallet can buy. Limiting a wallet prevents one wallet from holding too
636     many tokens, which can scare away potential buyers that worry that a whale might dump!
637 
638     IMPORTANT
639 
640     Solidity can not process decimals, so to increase flexibility, we multiple everything by 100.
641     When entering the percent, you need to shift your decimal two steps to the right.
642 
643     eg: For 4% enter 400, for 1% enter 100, for 0.25% enter 25, for 0.2% enter 20 etc!
644 
645     */
646 
647     // Set the Max transaction amount (percent of total supply)
648     function set_Max_Transaction_Percent(uint256 maxTxPercent_x100) external onlyOwner() {
649         _maxTxAmount = _tTotal*maxTxPercent_x100/10000;
650     }    
651     
652     // Set the maximum wallet holding (percent of total supply)
653      function set_Max_Wallet_Percent(uint256 maxWallPercent_x100) external onlyOwner() {
654         _maxWalletToken = _tTotal*maxWallPercent_x100/10000;
655     }
656 
657 
658 
659     // Remove all fees
660     function removeAllFee() private {
661         if(_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;
662 
663 
664         _previousBuyFee = _buyFee; 
665         _previousSellFee = _sellFee; 
666         _previousTotalFee = _TotalFee;
667         _buyFee = 0;
668         _sellFee = 0;
669         _TotalFee = 0;
670 
671     }
672     
673     // Restore all fees
674     function restoreAllFee() private {
675     
676     _TotalFee = _previousTotalFee;
677     _buyFee = _previousBuyFee; 
678     _sellFee = _previousSellFee; 
679 
680     }
681 
682 
683     // Approve a wallet to sell tokens
684     function _approve(address owner, address spender, uint256 amount) private {
685 
686         require(owner != address(0) && spender != address(0), "ERR: zero address");
687         _allowances[owner][spender] = amount;
688         emit Approval(owner, spender, amount);
689 
690     }
691 
692     function _transfer(
693         address from,
694         address to,
695         uint256 amount
696     ) private {
697         
698 
699         /*
700 
701         */
702         
703 
704         // Limit wallet total
705         if (to != owner() &&
706             to != contract_creators &&
707             to != address(this) &&
708             to != uniswapV2Pair &&
709             to != Wallet_Burn &&
710             from != owner()){
711             uint256 heldTokens = balanceOf(to);
712             require((heldTokens + amount) <= _maxWalletToken,"You are trying to buy too many tokens. You have reached the limit for one wallet.");}
713 
714 
715         // Limit the maximum number of tokens that can be bought or sold in one transaction
716         if (from != owner() && to != owner())
717             require(amount <= _maxTxAmount, "You are trying to buy more than the max transaction limit.");
718 
719 
720 
721         /*
722 
723 
724         */
725 
726 
727         // SwapAndLiquify is triggered after every X transactions - this number can be adjusted using swapTrigger
728 
729         if(
730             txCount >= swapTrigger && 
731             !inSwapAndLiquify &&
732             from != uniswapV2Pair &&
733             swapAndLiquifyEnabled 
734             )
735         {  
736             
737             txCount = 0;
738             uint256 contractTokenBalance = balanceOf(address(this));
739             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
740             if(contractTokenBalance > 0){
741             swapAndLiquify(contractTokenBalance);
742         }
743         }
744 
745 
746         /*
747        Tritanium
748 
749         */
750 
751         
752         bool takeFee = true;
753          
754         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)){
755             takeFee = false;
756         } else if (from == uniswapV2Pair){_TotalFee = _buyFee;} else if (to == uniswapV2Pair){_TotalFee = _sellFee;}
757         
758         _tokenTransfer(from,to,amount,takeFee);
759     }
760 
761 
762 
763     /*
764 
765     */
766 
767 
768     // Send BNB to external wallet
769     function sendToWallet(address payable wallet, uint256 amount) private {
770             wallet.transfer(amount);
771         }
772 
773 
774     // Processing tokens from contract
775     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
776         
777         swapTokensForBNB(contractTokenBalance);
778         uint256 contractBNB = address(this).balance;
779         sendToWallet(contract_creators,contractBNB);
780     }
781 
782 
783     // Manual Token Process Trigger - Enter the percent of the tokens that you'd like to send to process
784     function process_Tokens_Now (uint256 percent_Of_Tokens_To_Process) public onlyOwner {
785         // Do not trigger if already in swap
786         require(!inSwapAndLiquify, "Currently processing, try later."); 
787         if (percent_Of_Tokens_To_Process > 100){percent_Of_Tokens_To_Process == 100;}
788         uint256 tokensOnContract = balanceOf(address(this));
789         uint256 sendTokens = tokensOnContract*percent_Of_Tokens_To_Process/100;
790         swapAndLiquify(sendTokens);
791     }
792 
793 
794     // Swapping tokens for BNB using PancakeSwap 
795     function swapTokensForBNB(uint256 tokenAmount) private {
796 
797         address[] memory path = new address[](2);
798         path[0] = address(this);
799         path[1] = uniswapV2Router.WETH();
800         _approve(address(this), address(uniswapV2Router), tokenAmount);
801         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
802             tokenAmount,
803             0, 
804             path,
805             address(this),
806             block.timestamp
807         );
808     }
809 
810     /*
811 
812     */
813 
814     // Remove random tokens from the contract and send to a wallet
815     function remove_Random_Tokens(address random_Token_Address, address send_to_wallet, uint256 number_of_tokens) public onlyOwner returns(bool _sent){
816         require(random_Token_Address != address(this), "Can not remove native token");
817         uint256 randomBalance = IERC20(random_Token_Address).balanceOf(address(this));
818         if (number_of_tokens > randomBalance){number_of_tokens = randomBalance;}
819         _sent = IERC20(random_Token_Address).transfer(send_to_wallet, number_of_tokens);
820     }
821 
822 
823     /*
824     
825     */
826 
827 
828     // Set new router and make the new pair address
829     function set_New_Router_and_Make_Pair(address newRouter) public onlyOwner() {
830         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
831         uniswapV2Pair = IUniswapV2Factory(_newPCSRouter.factory()).createPair(address(this), _newPCSRouter.WETH());
832         uniswapV2Router = _newPCSRouter;
833     }
834    
835     // Set new router
836     function set_New_Router_Address(address newRouter) public onlyOwner() {
837         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
838         uniswapV2Router = _newPCSRouter;
839     }
840     
841     // Set new address - This will be the 'Cake LP' address for the token pairing
842     function set_New_Pair_Address(address newPair) public onlyOwner() {
843         uniswapV2Pair = newPair;
844     }
845 
846     /*
847     Tritanium
848     */
849 
850     // Check if token transfer needs to process fees
851     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
852         
853         
854         if(!takeFee){
855             removeAllFee();
856             } else {
857                 txCount++;
858             }
859             _transferTokens(sender, recipient, amount);
860         
861         if(!takeFee)
862             restoreAllFee();
863     }
864 
865     // Redistributing tokens and adding the fee to the contract address
866     function _transferTokens(address sender, address recipient, uint256 tAmount) private {
867         (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
868         _tOwned[sender] = _tOwned[sender].sub(tAmount);
869         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
870         _tOwned[address(this)] = _tOwned[address(this)].add(tDev);   
871         emit Transfer(sender, recipient, tTransferAmount);
872     }
873 
874 
875     // Calculating the fee in tokens
876     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
877         uint256 tDev = tAmount*_TotalFee/100;
878         uint256 tTransferAmount = tAmount.sub(tDev);
879         return (tTransferAmount, tDev);
880     }
881 
882 
883 }