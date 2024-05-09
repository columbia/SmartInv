1 /**
2 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
3 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNNWMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXXKKKXXXXNWWMMMMMMMMMMWNK0OOKNMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWN0xoc:;;,,;;;::clodxO0KXXKK0OxdodOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0o;.......'',;:cccc::::ccllllllodOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo'......':oxOKXXNNNXXKOkdollllodkXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc......;oOXWMMMMMMMMMMMMMN0doodkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo.....,oKWMMMMMMMMMMMMMMMNOdodkKXKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0:....:OWMMMMMMMMMMMMMMMN0xodkKWWKkOXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO,..':OWMMMMMMMMMMMMMMN0xodkKWMMMWKkONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO,.',xNMMMMMMMMMMMMNX0xookKWMMMMMMN0OKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0:''c0MMMMMMMMMMMN0xdookKWMMMMMMMMWX00XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl,,cKMMMMMMMMMNKxoodkKNMMMMMMMMMMMX00KNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx;;c0MMMMMMMWKxoox0XNMMMMMMMMMMMMWXKKKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKl;:xNMMMMWKkoox0NMMMMMMMMMMMMMMMWXKKXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWkc:lOWMWKkdox0NMMMMMMMMMMMMMMMMWXKXXXNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxcd0NXkdox0NWMMMMMMMMMMMMMMMMWXXXXNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXKXXOdodONWMMMMMMMMMMMMMMMMWNXXXNNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNOdooox0XNWMMMMMMMMMMMMWNNXXXNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xooodddxxO0KXXNNNNNNNXXXXXXXNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xooodddxxxkkkkOOO0000KKKXXXNNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xoodkO0KKXKK00000000KKKKXXXNNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMMMMMMMMMMMMNKkxkOKXWWMMMMMMMWWNNNNNNNNNNWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMMMMMMMMMMWXKXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 
30 QUANTUM NETWORK
31 Quantum Network is a next-generation blockchain network that utilizes Ethereum Virtual Machine (EVM) and our unique Proof of Quantum (PoQ) consensus mechanism. We aim to provide an ultra-fast, scalable, and efficient blockchain experience.
32 
33 
34 Website     : https://quantumnetwork.gg/
35 Telegram    : https://t.me/QuantumNetwork_news
36 Twitter     : https://twitter.com/QuantummNetwork
37 Medium      : https://medium.com/@quantumnetwork49
38 Github      : https://github.com/qnetchain
39 Whitepaper  : https://quantum-network.gitbook.io/quantum-network-whitepaper/
40 /*
41 
42 */
43 // SPDX-License-Identifier: MIT
44 
45 pragma solidity ^0.8.7;
46 
47 
48 interface IERC20 {
49     
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 library SafeMath {
61     
62 
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a + b;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a - b;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a * b;
73     }
74     
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a / b;
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         unchecked {
81             require(b <= a, errorMessage);
82             return a - b;
83         }
84     }
85     
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         unchecked {
88             require(b > 0, errorMessage);
89             return a / b;
90         }
91     }
92     
93 }
94 
95 
96 
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         this; 
104         return msg.data;
105     }
106 }
107 
108 
109 library Address {
110     
111     function isContract(address account) internal view returns (bool) {
112         uint256 size;
113         assembly { size := extcodesize(account) }
114         return size > 0;
115     }
116 
117     function sendValue(address payable recipient, uint256 amount) internal {
118         require(address(this).balance >= amount, "Address: insufficient balance");
119         (bool success, ) = recipient.call{ value: amount }("");
120         require(success, "Address: unable to send value, recipient may have reverted");
121     }
122     
123     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
124       return functionCall(target, data, "Address: low-level call failed");
125     }
126     
127     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
128         return functionCallWithValue(target, data, 0, errorMessage);
129     }
130     
131     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
133     }
134     
135     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138         (bool success, bytes memory returndata) = target.call{ value: value }(data);
139         return _verifyCallResult(success, returndata, errorMessage);
140     }
141     
142     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
143         return functionStaticCall(target, data, "Address: low-level static call failed");
144     }
145     
146     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
147         require(isContract(target), "Address: static call to non-contract");
148         (bool success, bytes memory returndata) = target.staticcall(data);
149         return _verifyCallResult(success, returndata, errorMessage);
150     }
151 
152 
153     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
155     }
156     
157     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
158         require(isContract(target), "Address: delegate call to non-contract");
159         (bool success, bytes memory returndata) = target.delegatecall(data);
160         return _verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
164         if (success) {
165             return returndata;
166         } else {
167             if (returndata.length > 0) {
168                  assembly {
169                     let returndata_size := mload(returndata)
170                     revert(add(32, returndata), returndata_size)
171                 }
172             } else {
173                 revert(errorMessage);
174             }
175         }
176     }
177 }
178 
179 abstract contract Ownable is Context {
180     address private _owner;
181 
182 
183     // Set original owner
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185     constructor () {
186         _owner = 0xdF3A6f3473bAA51F750C2F19b2b2E5b69207a4Cc;
187         emit OwnershipTransferred(address(0), _owner);
188     }
189 
190     // Return current owner
191     function owner() public view virtual returns (address) {
192         return _owner;
193     }
194 
195     // Restrict function to contract owner only 
196     modifier onlyOwner() {
197         require(owner() == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200 
201     // Renounce ownership of the contract 
202     function renounceOwnership() public virtual onlyOwner {
203         emit OwnershipTransferred(_owner, address(0));
204         _owner = address(0);
205     }
206 
207     // Transfer the contract to to a new owner
208     function transferOwnership(address newOwner) public virtual onlyOwner {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         emit OwnershipTransferred(_owner, newOwner);
211         _owner = newOwner;
212     }
213 }
214 
215 interface IUniswapV2Factory {
216     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
217     function feeTo() external view returns (address);
218     function feeToSetter() external view returns (address);
219     function getPair(address tokenA, address tokenB) external view returns (address pair);
220     function allPairs(uint) external view returns (address pair);
221     function allPairsLength() external view returns (uint);
222     function createPair(address tokenA, address tokenB) external returns (address pair);
223     function setFeeTo(address) external;
224     function setFeeToSetter(address) external;
225 }
226 
227 interface IUniswapV2Pair {
228     event Approval(address indexed owner, address indexed spender, uint value);
229     event Transfer(address indexed from, address indexed to, uint value);
230     function name() external pure returns (string memory);
231     function symbol() external pure returns (string memory);
232     function decimals() external pure returns (uint8);
233     function totalSupply() external view returns (uint);
234     function balanceOf(address owner) external view returns (uint);
235     function allowance(address owner, address spender) external view returns (uint);
236     function approve(address spender, uint value) external returns (bool);
237     function transfer(address to, uint value) external returns (bool);
238     function transferFrom(address from, address to, uint value) external returns (bool);
239     function DOMAIN_SEPARATOR() external view returns (bytes32);
240     function PERMIT_TYPEHASH() external pure returns (bytes32);
241     function nonces(address owner) external view returns (uint);
242     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
243     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
244     event Swap(
245         address indexed sender,
246         uint amount0In,
247         uint amount1In,
248         uint amount0Out,
249         uint amount1Out,
250         address indexed to
251     );
252     event Sync(uint112 reserve0, uint112 reserve1);
253     function MINIMUM_LIQUIDITY() external pure returns (uint);
254     function factory() external view returns (address);
255     function token0() external view returns (address);
256     function token1() external view returns (address);
257     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
258     function price0CumulativeLast() external view returns (uint);
259     function price1CumulativeLast() external view returns (uint);
260     function kLast() external view returns (uint);
261     function burn(address to) external returns (uint amount0, uint amount1);
262     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
263     function skim(address to) external;
264     function sync() external;
265     function initialize(address, address) external;
266 }
267 
268 interface IUniswapV2Router01 {
269     function factory() external pure returns (address);
270     function WETH() external pure returns (address);
271     function addLiquidity(
272         address tokenA,
273         address tokenB,
274         uint amountADesired,
275         uint amountBDesired,
276         uint amountAMin,
277         uint amountBMin,
278         address to,
279         uint deadline
280     ) external returns (uint amountA, uint amountB, uint liquidity);
281     function addLiquidityETH(
282         address token,
283         uint amountTokenDesired,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline
288     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
289     function removeLiquidity(
290         address tokenA,
291         address tokenB,
292         uint liquidity,
293         uint amountAMin,
294         uint amountBMin,
295         address to,
296         uint deadline
297     ) external returns (uint amountA, uint amountB);
298     function removeLiquidityETH(
299         address token,
300         uint liquidity,
301         uint amountTokenMin,
302         uint amountETHMin,
303         address to,
304         uint deadline
305     ) external returns (uint amountToken, uint amountETH);
306     function removeLiquidityWithPermit(
307         address tokenA,
308         address tokenB,
309         uint liquidity,
310         uint amountAMin,
311         uint amountBMin,
312         address to,
313         uint deadline,
314         bool approveMax, uint8 v, bytes32 r, bytes32 s
315     ) external returns (uint amountA, uint amountB);
316     function removeLiquidityETHWithPermit(
317         address token,
318         uint liquidity,
319         uint amountTokenMin,
320         uint amountETHMin,
321         address to,
322         uint deadline,
323         bool approveMax, uint8 v, bytes32 r, bytes32 s
324     ) external returns (uint amountToken, uint amountETH);
325     function swapExactTokensForTokens(
326         uint amountIn,
327         uint amountOutMin,
328         address[] calldata path,
329         address to,
330         uint deadline
331     ) external returns (uint[] memory amounts);
332     function swapTokensForExactTokens(
333         uint amountOut,
334         uint amountInMax,
335         address[] calldata path,
336         address to,
337         uint deadline
338     ) external returns (uint[] memory amounts);
339     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
340         external
341         payable
342         returns (uint[] memory amounts);
343     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
344         external
345         returns (uint[] memory amounts);
346     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
347         external
348         returns (uint[] memory amounts);
349     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
350         external
351         payable
352         returns (uint[] memory amounts);
353 
354     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
355     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
356     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
357     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
358     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
359 }
360 
361 interface IUniswapV2Router02 is IUniswapV2Router01 {
362     function removeLiquidityETHSupportingFeeOnTransferTokens(
363         address token,
364         uint liquidity,
365         uint amountTokenMin,
366         uint amountETHMin,
367         address to,
368         uint deadline
369     ) external returns (uint amountETH);
370     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
371         address token,
372         uint liquidity,
373         uint amountTokenMin,
374         uint amountETHMin,
375         address to,
376         uint deadline,
377         bool approveMax, uint8 v, bytes32 r, bytes32 s
378     ) external returns (uint amountETH);
379 
380     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
381         uint amountIn,
382         uint amountOutMin,
383         address[] calldata path,
384         address to,
385         uint deadline
386     ) external;
387     function swapExactETHForTokensSupportingFeeOnTransferTokens(
388         uint amountOutMin,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external payable;
393     function swapExactTokensForETHSupportingFeeOnTransferTokens(
394         uint amountIn,
395         uint amountOutMin,
396         address[] calldata path,
397         address to,
398         uint deadline
399     ) external;
400 }
401 
402 
403 contract QuantumNetwork is Context, IERC20, Ownable { 
404     using SafeMath for uint256;
405     using Address for address;
406 
407 
408     // Tracking status of wallets
409     mapping (address => uint256) private _tOwned;
410     mapping (address => mapping (address => uint256)) private _allowances;
411     mapping (address => bool) public _isExcludedFromFee; 
412 
413 
414     /*
415 
416     */
417 
418 
419     address payable public contract_creators = payable(0xdF3A6f3473bAA51F750C2F19b2b2E5b69207a4Cc);
420     address payable public Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
421     address payable public Wallet_zero = payable(0x0000000000000000000000000000000000000000); 
422 
423 
424     /*
425 
426 
427     */
428 
429     string private _name = "Quantum Network"; 
430     string private _symbol = "QNET";  
431     uint8 private _decimals = 18;
432     uint256 private _tTotal = 100000000 * 10**18;
433     uint256 private _tFeeTotal;
434 
435     // Counter for liquify trigger
436     uint8 private txCount = 0;
437     uint8 private swapTrigger = 3; 
438 
439     // This is the set max fees only maximum 20
440     // This includes the buy AND the sell fees!
441     uint256 private maxPossibleFee = 20; 
442 
443 
444     // Setting the initial fees
445     uint256 private _TotalFee = 20;
446     uint256 public _buyFee = 10;
447     uint256 public _sellFee = 10;
448 
449 
450     // 'Previous fees' are used to keep track of fee settings when removing and restoring fees
451     uint256 private _previousTotalFee = _TotalFee; 
452     uint256 private _previousBuyFee = _buyFee; 
453     uint256 private _previousSellFee = _sellFee; 
454 
455     /*
456 
457     WALLET LIMITS 
458     
459     */
460 
461     // Max wallet holding (1% at launch)
462     uint256 public _maxWalletToken = _tTotal.mul(2).div(100);
463     uint256 private _previousMaxWalletToken = _maxWalletToken;
464 
465 
466     // Maximum transaction amount (1% at launch)
467     uint256 public _maxTxAmount = _tTotal.mul(2).div(100); 
468     uint256 private _previousMaxTxAmount = _maxTxAmount;
469 
470     /* 
471 
472     */
473                                      
474     IUniswapV2Router02 public uniswapV2Router;
475     address public uniswapV2Pair;
476     bool public inSwapAndLiquify;
477     bool public swapAndLiquifyEnabled = true;
478     
479     event SwapAndLiquifyEnabledUpdated(bool enabled);
480     event SwapAndLiquify(
481         uint256 tokensSwapped,
482         uint256 ethReceived,
483         uint256 tokensIntoLiqudity
484         
485     );
486     
487     // Prevent processing while already processing! 
488     modifier lockTheSwap {
489         inSwapAndLiquify = true;
490         _;
491         inSwapAndLiquify = false;
492     }
493 
494     /*
495 
496     DEPLOY TOKENS TO OWNER
497 
498     Constructor functions are only called once. This happens during contract deployment.
499     This function deploys the total token supply to the owner wallet and creates the PCS pairing
500 
501     */
502     
503     constructor () {
504         _tOwned[owner()] = _tTotal;
505         
506         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
507         
508         
509         // Create pair address for PancakeSwap
510         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
511             .createPair(address(this), _uniswapV2Router.WETH());
512         uniswapV2Router = _uniswapV2Router;
513         _isExcludedFromFee[owner()] = true;
514         _isExcludedFromFee[address(this)] = true;
515         _isExcludedFromFee[contract_creators] = true;
516         
517         emit Transfer(address(0), owner(), _tTotal);
518     }
519 
520 
521     /*
522     Quantum Network
523 
524     */
525 
526     function name() public view returns (string memory) {
527         return _name;
528     }
529 
530     function symbol() public view returns (string memory) {
531         return _symbol;
532     }
533 
534     function decimals() public view returns (uint8) {
535         return _decimals;
536     }
537 
538     function totalSupply() public view override returns (uint256) {
539         return _tTotal;
540     }
541 
542     function balanceOf(address account) public view override returns (uint256) {
543         return _tOwned[account];
544     }
545 
546     function transfer(address recipient, uint256 amount) public override returns (bool) {
547         _transfer(_msgSender(), recipient, amount);
548         return true;
549     }
550 
551     function allowance(address owner, address spender) public view override returns (uint256) {
552         return _allowances[owner][spender];
553     }
554 
555     function approve(address spender, uint256 amount) public override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
568         return true;
569     }
570 
571     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
573         return true;
574     }
575 
576 
577     /*
578 
579     END OF STANDARD ERC20 COMPLIANCE FUNCTIONS
580 
581     */
582 
583     /*
584 
585     */
586     
587     // Set a wallet address so that it does not have to pay transaction fees
588     function excludeFromFee(address account) public onlyOwner {
589         _isExcludedFromFee[account] = true;
590     }
591     
592     // Set a wallet address so that it has to pay transaction fees
593     function includeInFee(address account) public onlyOwner {
594         _isExcludedFromFee[account] = false;
595     }
596 
597 
598     /*
599 
600     */
601     
602 
603     function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner() {
604 
605         require((Buy_Fee + Sell_Fee) <= maxPossibleFee, "Fee is too high!");
606         _sellFee = Sell_Fee;
607         _buyFee = Buy_Fee;
608 
609     }
610 
611 
612 
613     // Update main wallet
614     function Wallet_Update_Dev(address payable wallet) public onlyOwner() {
615         contract_creators = wallet;
616         _isExcludedFromFee[contract_creators] = true;
617     }
618 
619 
620     /*
621 
622     */
623     
624     // Toggle on and off to auto process tokens to ETH wallet 
625     function set_Swap_And_Liquify_Enabled(bool true_or_false) public onlyOwner {
626         swapAndLiquifyEnabled = true_or_false;
627         emit SwapAndLiquifyEnabledUpdated(true_or_false);
628     }
629 
630     // This will set the number of transactions required before the 'swapAndLiquify' function triggers
631     function set_Number_Of_Transactions_Before_Liquify_Trigger(uint8 number_of_transactions) public onlyOwner {
632         swapTrigger = number_of_transactions;
633     }
634     
635 
636 
637     // This function is required so that the contract can receive ETH from pancakeswap
638     receive() external payable {}
639 
640 
641 
642     /*
643     
644     When sending tokens to another wallet (not buying or selling) if noFeeToTransfer is true there will be no fee
645 
646     */
647 
648     bool public noFeeToTransfer = true;
649 
650     // Option to set fee or no fee for transfer (just in case the no fee transfer option is exploited in future!)
651     // True = there will be no fees when moving tokens around or giving them to friends! (There will only be a fee to buy or sell)
652     // False = there will be a fee when buying/selling/tranfering tokens
653     // Default is true
654     function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {
655         noFeeToTransfer = true_or_false;
656     }
657 
658     /*
659 
660     WALLET LIMITS
661 
662     Wallets are limited in two ways. The amount of tokens that can be purchased in one transaction
663     and the total amount of tokens a wallet can buy. Limiting a wallet prevents one wallet from holding too
664     many tokens, which can scare away potential buyers that worry that a whale might dump!
665 
666     IMPORTANT
667 
668     Solidity can not process decimals, so to increase flexibility, we multiple everything by 100.
669     When entering the percent, you need to shift your decimal two steps to the right.
670 
671     eg: For 4% enter 400, for 1% enter 100, for 0.25% enter 25, for 0.2% enter 20 etc!
672 
673     */
674 
675     // Set the Max transaction amount (percent of total supply)
676     function set_Max_Transaction_Percent(uint256 maxTxPercent_x100) external onlyOwner() {
677         _maxTxAmount = _tTotal*maxTxPercent_x100/10000;
678     }    
679     
680     // Set the maximum wallet holding (percent of total supply)
681      function set_Max_Wallet_Percent(uint256 maxWallPercent_x100) external onlyOwner() {
682         _maxWalletToken = _tTotal*maxWallPercent_x100/10000;
683     }
684 
685 
686 
687     // Remove all fees
688     function removeAllFee() private {
689         if(_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;
690 
691 
692         _previousBuyFee = _buyFee; 
693         _previousSellFee = _sellFee; 
694         _previousTotalFee = _TotalFee;
695         _buyFee = 0;
696         _sellFee = 0;
697         _TotalFee = 0;
698 
699     }
700     
701     // Restore all fees
702     function restoreAllFee() private {
703     
704     _TotalFee = _previousTotalFee;
705     _buyFee = _previousBuyFee; 
706     _sellFee = _previousSellFee; 
707 
708     }
709 
710 
711     // Approve a wallet to sell tokens
712     function _approve(address owner, address spender, uint256 amount) private {
713 
714         require(owner != address(0) && spender != address(0), "ERR: zero address");
715         _allowances[owner][spender] = amount;
716         emit Approval(owner, spender, amount);
717 
718     }
719 
720     function _transfer(
721         address from,
722         address to,
723         uint256 amount
724     ) private {
725         
726 
727         /*
728 
729         */
730         
731 
732         // Limit wallet total
733         if (to != owner() &&
734             to != contract_creators &&
735             to != address(this) &&
736             to != uniswapV2Pair &&
737             to != Wallet_Burn &&
738             from != owner()){
739             uint256 heldTokens = balanceOf(to);
740             require((heldTokens + amount) <= _maxWalletToken,"You are trying to buy too many tokens. You have reached the limit for one wallet.");}
741 
742 
743         // Limit the maximum number of tokens that can be bought or sold in one transaction
744         if (from != owner() && to != owner())
745             require(amount <= _maxTxAmount, "You are trying to buy more than the max transaction limit.");
746 
747 
748 
749         /*
750 
751 
752         */
753 
754 
755         // SwapAndLiquify is triggered after every X transactions - this number can be adjusted using swapTrigger
756 
757         if(
758             txCount >= swapTrigger && 
759             !inSwapAndLiquify &&
760             from != uniswapV2Pair &&
761             swapAndLiquifyEnabled 
762             )
763         {  
764             
765             txCount = 0;
766             uint256 contractTokenBalance = balanceOf(address(this));
767             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
768             if(contractTokenBalance > 0){
769             swapAndLiquify(contractTokenBalance);
770         }
771         }
772 
773 
774         /*
775        Quantum Network
776 
777         */
778 
779         
780         bool takeFee = true;
781          
782         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)){
783             takeFee = false;
784         } else if (from == uniswapV2Pair){_TotalFee = _buyFee;} else if (to == uniswapV2Pair){_TotalFee = _sellFee;}
785         
786         _tokenTransfer(from,to,amount,takeFee);
787     }
788 
789 
790 
791     /*
792 
793     */
794 
795 
796     // Send ETH to external wallet
797     function sendToWallet(address payable wallet, uint256 amount) private {
798             wallet.transfer(amount);
799         }
800 
801 
802     // Processing tokens from contract
803     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
804         
805         swapTokensForBNB(contractTokenBalance);
806         uint256 contractBNB = address(this).balance;
807         sendToWallet(contract_creators,contractBNB);
808     }
809 
810 
811     // Manual Token Process Trigger - Enter the percent of the tokens that you'd like to send to process
812     function process_Tokens_Now (uint256 percent_Of_Tokens_To_Process) public onlyOwner {
813         // Do not trigger if already in swap
814         require(!inSwapAndLiquify, "Currently processing, try later."); 
815         if (percent_Of_Tokens_To_Process > 100){percent_Of_Tokens_To_Process == 100;}
816         uint256 tokensOnContract = balanceOf(address(this));
817         uint256 sendTokens = tokensOnContract*percent_Of_Tokens_To_Process/100;
818         swapAndLiquify(sendTokens);
819     }
820 
821 
822     // Swapping tokens for ETH using Uniswap 
823     function swapTokensForBNB(uint256 tokenAmount) private {
824 
825         address[] memory path = new address[](2);
826         path[0] = address(this);
827         path[1] = uniswapV2Router.WETH();
828         _approve(address(this), address(uniswapV2Router), tokenAmount);
829         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
830             tokenAmount,
831             0, 
832             path,
833             address(this),
834             block.timestamp
835         );
836     }
837 
838     /*
839 
840     */
841 
842     // Remove random tokens from the contract and send to a wallet
843     function remove_Random_Tokens(address random_Token_Address, address send_to_wallet, uint256 number_of_tokens) public onlyOwner returns(bool _sent){
844         require(random_Token_Address != address(this), "Can not remove native token");
845         uint256 randomBalance = IERC20(random_Token_Address).balanceOf(address(this));
846         if (number_of_tokens > randomBalance){number_of_tokens = randomBalance;}
847         _sent = IERC20(random_Token_Address).transfer(send_to_wallet, number_of_tokens);
848     }
849 
850 
851     /*
852     
853     */
854 
855 
856     // Set new router and make the new pair address
857     function set_New_Router_and_Make_Pair(address newRouter) public onlyOwner() {
858         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
859         uniswapV2Pair = IUniswapV2Factory(_newPCSRouter.factory()).createPair(address(this), _newPCSRouter.WETH());
860         uniswapV2Router = _newPCSRouter;
861     }
862    
863     // Set new router
864     function set_New_Router_Address(address newRouter) public onlyOwner() {
865         IUniswapV2Router02 _newPCSRouter = IUniswapV2Router02(newRouter);
866         uniswapV2Router = _newPCSRouter;
867     }
868     
869     // Set new address - This will be the 'Cake LP' address for the token pairing
870     function set_New_Pair_Address(address newPair) public onlyOwner() {
871         uniswapV2Pair = newPair;
872     }
873 
874     /*
875     Quantum Network
876     */
877 
878     // Check if token transfer needs to process fees
879     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
880         
881         
882         if(!takeFee){
883             removeAllFee();
884             } else {
885                 txCount++;
886             }
887             _transferTokens(sender, recipient, amount);
888         
889         if(!takeFee)
890             restoreAllFee();
891     }
892 
893     // Redistributing tokens and adding the fee to the contract address
894     function _transferTokens(address sender, address recipient, uint256 tAmount) private {
895         (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);
896         _tOwned[sender] = _tOwned[sender].sub(tAmount);
897         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
898         _tOwned[address(this)] = _tOwned[address(this)].add(tDev);   
899         emit Transfer(sender, recipient, tTransferAmount);
900     }
901 
902 
903     // Calculating the fee in tokens
904     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
905         uint256 tDev = tAmount*_TotalFee/100;
906         uint256 tTransferAmount = tAmount.sub(tDev);
907         return (tTransferAmount, tDev);
908     }
909 
910 
911 }