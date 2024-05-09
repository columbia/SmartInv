1 /*
2 
3   ___ ___ _  _ _  ___   __  _____ ___  _  _____ _  _ 
4  | _ \ __| \| | \| \ \ / / |_   _/ _ \| |/ / __| \| |
5  |  _/ _|| .` | .` |\ V /    | || (_) | ' <| _|| .` |
6  |_| |___|_|\_|_|\_| |_|     |_| \___/|_|\_\___|_|\_|
7                                                      
8                                                                                                         
9                  ╓╓╓╓╓╓╓╓/ ,╓╓╓╓╓╓╓
10                ▄▄╣╣╣╣╣╣╣╣▄▄╣╣╣╣╣╣╣╣▄▄
11              ╦╦╣╣╣╣╣╣╣╣╣╣╣▓▓▓╣╣╣╣╣╣╣╣╦╦~
12            @@╣╣╣╣▌`````▐█▌`▐▓▌`````██╝`░
13          ╫╫╣╣╣╣╣╣▓@Φ   j███▓▓▓▓Γ   ████░
14          ╣╣╣╣╣╣╣╣╣╣▓▓▓▓╣▒▒▒▒╣╣╣▓▓▓▓╣▒▒▒H
15          ╣╣╣╣╣╣╣▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒H
16          ╣╣╣╣╣╣╣▒▒█████████████████████W
17          ╩╩╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╝╝─
18            ▀▀╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣▀▀`
19              ╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙`
20 
21 
22 TG: https://t.me/pennytokeneth
23              
24 */
25 
26 //SPDX-License-Identifier: MIT
27 
28 pragma solidity ^0.8.17;
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint);
32     function balanceOf(address account) external view returns (uint);
33     function transfer(address recipient, uint amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint);
35     function approve(address spender, uint amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint value);
38     event Approval(address indexed owner, address indexed spender, uint value);
39 }
40 library SafeMath {
41     function add(uint a, uint b) internal pure returns (uint) {
42         uint c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44 
45         return c;
46     }
47     function sub(uint a, uint b) internal pure returns (uint) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
51         require(b <= a, errorMessage);
52         uint c = a - b;
53 
54         return c;
55     }
56     function mul(uint a, uint b) internal pure returns (uint) {
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66     function div(uint a, uint b) internal pure returns (uint) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
70         // Solidity only automatically asserts when dividing by 0
71         require(b > 0, errorMessage);
72         uint c = a / b;
73 
74         return c;
75     }
76 }
77 
78 contract Context {
79     constructor () { }
80     // solhint-disable-previous-line no-empty-blocks
81 
82     function _msgSender() internal view returns (address) {
83         return msg.sender;
84     }
85 }
86 
87 abstract contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     /**
93      * @dev Initializes the contract setting the deployer as the initial owner.
94      */
95     constructor () {
96        
97         _owner = msg.sender ;
98         emit OwnershipTransferred(address(0), _owner);
99     }
100 
101     /**
102      * @dev Returns the address of the current owner.
103      */
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     /**
109      * @dev Throws if called by any account other than the owner.
110      */
111     modifier onlyOwner() {
112         require(_owner == _msgSender() , "Ownable: caller is not the owner");
113         _;
114     }
115 
116     /**
117      * @dev Leaves the contract without owner. It will not be possible to call
118      * `onlyOwner` functions anymore. Can only be called by the current owner.
119      *
120      * NOTE: Renouncing ownership will leave the contract without an owner,
121      * thereby removing any functionality that is only available to the owner.
122      */
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 
128     /**
129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
130      * Can only be called by the current owner.
131      */
132     function transferOwnership(address newOwner) public virtual onlyOwner {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 
140 contract ERC20Detailed {
141     string private _name;
142     string private _symbol;
143     uint8 private _decimals;
144 
145     constructor (string memory tname, string memory tsymbol, uint8 tdecimals) {
146         _name = tname;
147         _symbol = tsymbol;
148         _decimals = tdecimals;
149         
150     }
151     function name() public view returns (string memory) {
152         return _name;
153     }
154     function symbol() public view returns (string memory) {
155         return _symbol;
156     }
157     function decimals() public view returns (uint8) {
158         return _decimals;
159     }
160 }
161 
162 
163 
164 library Address {
165     function isContract(address account) internal view returns (bool) {
166         bytes32 codehash;
167         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
168         // solhint-disable-next-line no-inline-assembly
169         assembly { codehash := extcodehash(account) }
170         return (codehash != 0x0 && codehash != accountHash);
171     }
172 }
173 
174 library SafeERC20 {
175     using SafeMath for uint;
176     using Address for address;
177 
178     function safeTransfer(IERC20 token, address to, uint value) internal {
179         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
180     }
181 
182     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
183         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
184     }
185 
186     function safeApprove(IERC20 token, address spender, uint value) internal {
187         require((value == 0) || (token.allowance(address(this), spender) == 0),
188             "SafeERC20: approve from non-zero to non-zero allowance"
189         );
190         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
191     }
192     function callOptionalReturn(IERC20 token, bytes memory data) private {
193         require(address(token).isContract(), "SafeERC20: call to non-contract");
194 
195         // solhint-disable-next-line avoid-low-level-calls
196         (bool success, bytes memory returndata) = address(token).call(data);
197         require(success, "SafeERC20: low-level call failed");
198 
199         if (returndata.length > 0) { // Return data is optional
200             // solhint-disable-next-line max-line-length
201             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
202         }
203     }
204 }
205 
206 interface IUniswapV2Factory {
207     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
208 
209     function feeTo() external view returns (address);
210     function feeToSetter() external view returns (address);
211 
212     function getPair(address tokenA, address tokenB) external view returns (address pair);
213     function allPairs(uint) external view returns (address pair);
214     function allPairsLength() external view returns (uint);
215 
216     function createPair(address tokenA, address tokenB) external returns (address pair);
217 
218     function setFeeTo(address) external;
219     function setFeeToSetter(address) external;
220 }
221 
222 
223 interface IUniswapV2Pair {
224     event Approval(address indexed owner, address indexed spender, uint value);
225     event Transfer(address indexed from, address indexed to, uint value);
226 
227     function name() external pure returns (string memory);
228     function symbol() external pure returns (string memory);
229     function decimals() external pure returns (uint8);
230     function totalSupply() external view returns (uint);
231     function balanceOf(address owner) external view returns (uint);
232     function allowance(address owner, address spender) external view returns (uint);
233 
234     function approve(address spender, uint value) external returns (bool);
235     function transfer(address to, uint value) external returns (bool);
236     function transferFrom(address from, address to, uint value) external returns (bool);
237 
238     function DOMAIN_SEPARATOR() external view returns (bytes32);
239     function PERMIT_TYPEHASH() external pure returns (bytes32);
240     function nonces(address owner) external view returns (uint);
241 
242     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
243 
244     event Mint(address indexed sender, uint amount0, uint amount1);
245     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
246     event Swap(
247         address indexed sender,
248         uint amount0In,
249         uint amount1In,
250         uint amount0Out,
251         uint amount1Out,
252         address indexed to
253     );
254     event Sync(uint112 reserve0, uint112 reserve1);
255 
256     function MINIMUM_LIQUIDITY() external pure returns (uint);
257     function factory() external view returns (address);
258     function token0() external view returns (address);
259     function token1() external view returns (address);
260     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
261     function price0CumulativeLast() external view returns (uint);
262     function price1CumulativeLast() external view returns (uint);
263     function kLast() external view returns (uint);
264 
265     function mint(address to) external returns (uint liquidity);
266     function burn(address to) external returns (uint amount0, uint amount1);
267     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
268     function skim(address to) external;
269     function sync() external;
270 
271     function initialize(address, address) external;
272 }
273 
274 
275 
276 interface IUniswapV2Router01 {
277     function factory() external pure returns (address);
278     function WETH() external pure returns (address);
279 
280     function addLiquidity(
281         address tokenA,
282         address tokenB,
283         uint amountADesired,
284         uint amountBDesired,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline
289     ) external returns (uint amountA, uint amountB, uint liquidity);
290     function addLiquidityETH(
291         address token,
292         uint amountTokenDesired,
293         uint amountTokenMin,
294         uint amountETHMin,
295         address to,
296         uint deadline
297     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
298     function removeLiquidity(
299         address tokenA,
300         address tokenB,
301         uint liquidity,
302         uint amountAMin,
303         uint amountBMin,
304         address to,
305         uint deadline
306     ) external returns (uint amountA, uint amountB);
307     function removeLiquidityETH(
308         address token,
309         uint liquidity,
310         uint amountTokenMin,
311         uint amountETHMin,
312         address to,
313         uint deadline
314     ) external returns (uint amountToken, uint amountETH);
315     function removeLiquidityWithPermit(
316         address tokenA,
317         address tokenB,
318         uint liquidity,
319         uint amountAMin,
320         uint amountBMin,
321         address to,
322         uint deadline,
323         bool approveMax, uint8 v, bytes32 r, bytes32 s
324     ) external returns (uint amountA, uint amountB);
325     function removeLiquidityETHWithPermit(
326         address token,
327         uint liquidity,
328         uint amountTokenMin,
329         uint amountETHMin,
330         address to,
331         uint deadline,
332         bool approveMax, uint8 v, bytes32 r, bytes32 s
333     ) external returns (uint amountToken, uint amountETH);
334     function swapExactTokensForTokens(
335         uint amountIn,
336         uint amountOutMin,
337         address[] calldata path,
338         address to,
339         uint deadline
340     ) external returns (uint[] memory amounts);
341     function swapTokensForExactTokens(
342         uint amountOut,
343         uint amountInMax,
344         address[] calldata path,
345         address to,
346         uint deadline
347     ) external returns (uint[] memory amounts);
348     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
349         external
350         payable
351         returns (uint[] memory amounts);
352     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
353         external
354         returns (uint[] memory amounts);
355     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
356         external
357         returns (uint[] memory amounts);
358     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
359         external
360         payable
361         returns (uint[] memory amounts);
362 
363     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
364     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
365     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
366     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
367     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
368 }
369 
370 interface IUniswapV2Router02 is IUniswapV2Router01 {
371     function removeLiquidityETHSupportingFeeOnTransferTokens(
372         address token,
373         uint liquidity,
374         uint amountTokenMin,
375         uint amountETHMin,
376         address to,
377         uint deadline
378     ) external returns (uint amountETH);
379     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
380         address token,
381         uint liquidity,
382         uint amountTokenMin,
383         uint amountETHMin,
384         address to,
385         uint deadline,
386         bool approveMax, uint8 v, bytes32 r, bytes32 s
387     ) external returns (uint amountETH);
388 
389     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
390         uint amountIn,
391         uint amountOutMin,
392         address[] calldata path,
393         address to,
394         uint deadline
395     ) external;
396     function swapExactETHForTokensSupportingFeeOnTransferTokens(
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external payable;
402     function swapExactTokensForETHSupportingFeeOnTransferTokens(
403         uint amountIn,
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline
408     ) external;
409 }
410 
411 
412 
413 contract PENNY is Context, Ownable, IERC20, ERC20Detailed {
414   using SafeERC20 for IERC20;
415   using Address for address;
416   using SafeMath for uint256;
417   
418     IUniswapV2Router02 public immutable uniswapV2Router;
419     address public immutable uniswapV2Pair;
420     
421     mapping (address => uint) internal _balances;
422     mapping (address => mapping (address => uint)) internal _allowances;
423     mapping (address => bool) private _isExcludedFromFee;
424     mapping (address => bool) private _isExcludedFromMaxTx;
425     mapping(address => bool) public _isBlacklisted;
426 
427 
428    
429     uint256 internal _totalSupply;
430 
431     uint256 public marketingFee = 3;
432 
433     address payable public marketingwallet = payable(0x069e78e03EbB44487C6A5D4f8FF8EBFfE8Aab47e);
434     
435     bool inSwapAndLiquify;
436     bool public swapAndLiquifyEnabled = true;
437    
438     uint256 private numTokensSellToAddToLiquidity = 420069 * 10**18;
439     uint256 public maxWalletToken = 2940484 * (10**18); // 0.7 % MaxWallet
440     uint256 public _maxTxAmount = 2940484 * 10**18; // 0.7 % MaxWallet
441 
442 
443    
444     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
445     event SwapAndLiquifyEnabledUpdated(bool enabled);
446     event SwapAndLiquify(
447         uint256 tokensSwapped,
448         uint256 ethReceived
449     );
450 
451     
452     
453     modifier lockTheSwap {
454         inSwapAndLiquify = true;
455         _;
456         inSwapAndLiquify = false;
457     }
458   
459     address public _owner;
460   
461     constructor () ERC20Detailed("Penny", "PENNY", 18) {
462       _owner = msg.sender ;
463     _totalSupply = 420069069 * (10**18);
464     
465 	_balances[_owner] = _totalSupply;
466  	 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
478         _isExcludedFromFee[marketingwallet] = true;
479    
480      emit Transfer(address(0), _msgSender(), _totalSupply);
481   }
482   
483     function totalSupply() public view override returns (uint) {
484         return _totalSupply;
485     }
486     function balanceOf(address account) public view override returns (uint) {
487         return _balances[account];
488     }
489     function transfer(address recipient, uint amount) public override  returns (bool) {
490         _transfer(_msgSender(), recipient, amount);
491         return true;
492     }
493     function allowance(address towner, address spender) public view override returns (uint) {
494         return _allowances[towner][spender];
495     }
496     function approve(address spender, uint amount) public override returns (bool) {
497         _approve(_msgSender(), spender, amount);
498         return true;
499     }
500     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
501         _transfer(sender, recipient, amount);
502         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
503         return true;
504     }
505     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
507         return true;
508     }
509     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
511         return true;
512     }
513 
514     function setMarketingFeePercent(uint256 updatedMarketingFee) external onlyOwner() {
515         marketingFee = updatedMarketingFee;
516         require(marketingFee <= 90, "Fee limit reached");
517     }
518 
519      function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
520         uint256 amountETH = address(this).balance;
521         payable(msg.sender).transfer((amountETH * amountPercentage) / 100);
522     }
523 
524     function clearStuckTokens(address _tokenContract, uint256 _amount) public onlyOwner {
525     	  IERC20 tokenContract = IERC20(_tokenContract);
526     	  tokenContract.transfer(msg.sender, _amount);
527     }
528 
529     function setmarketingwallet(address payable wallet) external onlyOwner
530     {
531         marketingwallet = wallet;
532     }
533 
534     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
535         swapAndLiquifyEnabled = _enabled;
536         emit SwapAndLiquifyEnabledUpdated(_enabled);
537     }
538 
539     function changeNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity) external onlyOwner
540     {
541         require(_numTokensSellToAddToLiquidity >= 42007 * (10**18), "Swap amount cannot be lower than 0.01% total supply.");
542         require(_numTokensSellToAddToLiquidity <= 2100346 * (10**18), "Swap amount cannot be higher than 0.5% total supply.");
543         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
544     }
545     function excludeFromFee(address account) public onlyOwner {
546         _isExcludedFromFee[account] = true;
547     }
548     
549    
550     function setMaxWalletTokens(uint256 maxToken) external onlyOwner {
551         require(maxToken >= 420069 * (10**18),"Max Walllet Tokens cannot be lesser than 0.1% of total supply" );
552   	    maxWalletToken = maxToken ;
553   	}
554 
555     function blacklistAddress(address account, bool value) external onlyOwner{
556         _isBlacklisted[account] = value;
557     }
558 
559      function setMaxTx(uint256 maxTx) external onlyOwner() {
560         require(maxTx >= 420069 * (10**18),"Max Transaction cannot be lesser than 0.1% of total supply" );
561             _maxTxAmount = maxTx;
562     }
563 
564     function includeInFee(address account) public onlyOwner {
565         _isExcludedFromFee[account] = false;
566     }
567 
568   
569      //to recieve ETH from uniswapV2Router when swaping
570     receive() external payable {}
571     function _transfer(address sender, address recipient, uint amount) internal{
572 
573         require(sender != address(0), "ERC20: transfer from the zero address");
574         require(recipient != address(0), "ERC20: transfer to the zero address");
575         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "'Blacklisted address");
576 
577         if(sender != owner() && recipient != owner())
578             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
579        
580 
581          uint256 taxAmount = (amount.mul(marketingFee)).div(100);
582 
583         // is the token balance of this contract address over the min number of
584         // tokens that we need to initiate a swap + liquidity lock?
585         // also, don't get caught in a circular liquidity event.
586         // also, don't swap & liquify if sender is uniswap pair.
587         uint256 contractTokenBalance = balanceOf(address(this));
588         
589          if(contractTokenBalance >= _maxTxAmount)
590         {
591             contractTokenBalance = _maxTxAmount;
592         }
593         if (
594             sender != owner() &&
595             recipient != owner() &&
596             recipient != address(0) &&
597             recipient != address(0xdead) &&
598             recipient != uniswapV2Pair
599         ) {
600 
601             uint256 contractBalanceRecepient = balanceOf(recipient);
602             require(
603                 contractBalanceRecepient + amount <= maxWalletToken,
604                 "Exceeds maximum wallet token amount."
605             );
606             
607         }
608 
609         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
610         if (
611             overMinTokenBalance &&
612             !inSwapAndLiquify &&
613             sender != uniswapV2Pair &&
614             swapAndLiquifyEnabled
615         ) {
616             contractTokenBalance = numTokensSellToAddToLiquidity;
617             
618             swapAndLiquify(contractTokenBalance);
619         }
620         
621          //indicates if fee should be deducted from transfer
622         bool takeFee = true;
623         
624         //if any account belongs to _isExcludedFromFee account then remove the fee
625         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
626             takeFee = false;
627         }
628        
629         if(recipient != uniswapV2Pair && sender != uniswapV2Pair)
630         {takeFee = false;}
631        
632         if(takeFee)
633         {
634             uint256 TotalSent = amount.sub(taxAmount);
635             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
636             _balances[recipient] = _balances[recipient].add(TotalSent);
637             _balances[address(this)] = _balances[address(this)].add(taxAmount);
638             emit Transfer(sender, recipient, TotalSent);
639             emit Transfer(sender, address(this), taxAmount);
640         }
641         else
642         {
643             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
644             _balances[recipient] = _balances[recipient].add(amount);
645             emit Transfer(sender, recipient, amount);
646         }
647        
648     }
649 
650 
651     function totalFee() internal view returns(uint256)
652     {
653         return marketingFee;
654     }
655 
656      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
657        
658         uint256 initialBalance = address(this).balance;
659 
660         // swap tokens for ETH
661         swapTokensForEth(contractTokenBalance); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
662 
663         // how much ETH did we just swap into?
664         uint256 newBalance = address(this).balance.sub(initialBalance);
665 
666         uint256 marketingShare = newBalance.mul(marketingFee).div(totalFee());
667 
668         payable(marketingwallet).transfer(marketingShare);
669         
670         emit SwapAndLiquify(contractTokenBalance, newBalance);
671     }
672 
673     function swapTokensForEth(uint256 tokenAmount) private {
674         // generate the uniswap pair path of token -> weth
675         address[] memory path = new address[](2);
676         path[0] = address(this);
677         path[1] = uniswapV2Router.WETH();
678 
679         _approve(address(this), address(uniswapV2Router), tokenAmount);
680 
681         // make the swap
682         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
683             tokenAmount,
684             0, // accept any amount of ETH
685             path,
686             address(this),
687             block.timestamp
688         );
689     }
690 
691     function _approve(address towner, address spender, uint amount) internal {
692         require(towner != address(0), "ERC20: approve from the zero address");
693         require(spender != address(0), "ERC20: approve to the zero address");
694 
695         _allowances[towner][spender] = amount;
696         emit Approval(towner, spender, amount);
697     }
698 
699   
700 }