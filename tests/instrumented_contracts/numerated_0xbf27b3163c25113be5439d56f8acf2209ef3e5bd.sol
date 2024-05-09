1 // ░██████╗░█████╗░███████╗██╗░░░██╗  ██████╗░██╗░░░██╗
2 // ██╔════╝██╔══██╗██╔════╝██║░░░██║  ██╔══██╗╚██╗░██╔╝
3 // ╚█████╗░███████║█████╗░░██║░░░██║  ██████╦╝░╚████╔╝░
4 // ░╚═══██╗██╔══██║██╔══╝░░██║░░░██║  ██╔══██╗░░╚██╔╝░░
5 // ██████╔╝██║░░██║██║░░░░░╚██████╔╝  ██████╦╝░░░██║░░░
6 // ╚═════╝░╚═╝░░╚═╝╚═╝░░░░░░╚═════╝░  ╚═════╝░░░░╚═╝░░░
7 
8 // ░█████╗░░█████╗░██╗███╗░░██╗░██████╗██╗░░░██╗██╗░░░░░████████╗░░░███╗░░██╗███████╗████████╗
9 // ██╔══██╗██╔══██╗██║████╗░██║██╔════╝██║░░░██║██║░░░░░╚══██╔══╝░░░████╗░██║██╔════╝╚══██╔══╝
10 // ██║░░╚═╝██║░░██║██║██╔██╗██║╚█████╗░██║░░░██║██║░░░░░░░░██║░░░░░░██╔██╗██║█████╗░░░░░██║░░░
11 // ██║░░██╗██║░░██║██║██║╚████║░╚═══██╗██║░░░██║██║░░░░░░░░██║░░░░░░██║╚████║██╔══╝░░░░░██║░░░
12 // ╚█████╔╝╚█████╔╝██║██║░╚███║██████╔╝╚██████╔╝███████╗░░░██║░░░██╗██║░╚███║███████╗░░░██║░░░
13 // ░╚════╝░░╚════╝░╚═╝╚═╝░░╚══╝╚═════╝░░╚═════╝░╚══════╝░░░╚═╝░░░╚═╝╚═╝░░╚══╝╚══════╝░░░╚═╝░░░
14 
15 // Get your SAFU contract now via Coinsult.net
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.17;
20 
21 interface IUniswapV2Factory {
22     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
23 
24     function feeTo() external view returns (address);
25     function feeToSetter() external view returns (address);
26     function getPair(address tokenA, address tokenB) external view returns (address pair);
27     function allPairs(uint) external view returns (address pair);
28     function allPairsLength() external view returns (uint);
29     function createPair(address tokenA, address tokenB) external returns (address pair);
30     function setFeeTo(address) external;
31     function setFeeToSetter(address) external;
32 }
33 
34 interface IUniswapV2Pair {
35     event Approval(address indexed owner, address indexed spender, uint value);
36     event Transfer(address indexed from, address indexed to, uint value);
37 
38     function name() external pure returns (string memory);
39     function symbol() external pure returns (string memory);
40     function decimals() external pure returns (uint8);
41     function totalSupply() external view returns (uint);
42     function balanceOf(address owner) external view returns (uint);
43     function allowance(address owner, address spender) external view returns (uint);
44 
45     function approve(address spender, uint value) external returns (bool);
46     function transfer(address to, uint value) external returns (bool);
47     function transferFrom(address from, address to, uint value) external returns (bool);
48 
49     function DOMAIN_SEPARATOR() external view returns (bytes32);
50     function PERMIT_TYPEHASH() external pure returns (bytes32);
51     function nonces(address owner) external view returns (uint);
52 
53     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
54 
55     event Mint(address indexed sender, uint amount0, uint amount1);
56     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
57     event Swap(
58         address indexed sender,
59         uint amount0In,
60         uint amount1In,
61         uint amount0Out,
62         uint amount1Out,
63         address indexed to
64     );
65     event Sync(uint112 reserve0, uint112 reserve1);
66 
67     function MINIMUM_LIQUIDITY() external pure returns (uint);
68     function factory() external view returns (address);
69     function token0() external view returns (address);
70     function token1() external view returns (address);
71     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
72     function price0CumulativeLast() external view returns (uint);
73     function price1CumulativeLast() external view returns (uint);
74     function kLast() external view returns (uint);
75 
76     function mint(address to) external returns (uint liquidity);
77     function burn(address to) external returns (uint amount0, uint amount1);
78     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
79     function skim(address to) external;
80     function sync() external;
81 
82     function initialize(address, address) external;
83 }
84 
85 interface IUniswapV2Router01 {
86     function factory() external pure returns (address);
87     function WETH() external pure returns (address);
88 
89     function addLiquidity(
90         address tokenA,
91         address tokenB,
92         uint amountADesired,
93         uint amountBDesired,
94         uint amountAMin,
95         uint amountBMin,
96         address to,
97         uint deadline
98     ) external returns (uint amountA, uint amountB, uint liquidity);
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107     function removeLiquidity(
108         address tokenA,
109         address tokenB,
110         uint liquidity,
111         uint amountAMin,
112         uint amountBMin,
113         address to,
114         uint deadline
115     ) external returns (uint amountA, uint amountB);
116     function removeLiquidityETH(
117         address token,
118         uint liquidity,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external returns (uint amountToken, uint amountETH);
124     function removeLiquidityWithPermit(
125         address tokenA,
126         address tokenB,
127         uint liquidity,
128         uint amountAMin,
129         uint amountBMin,
130         address to,
131         uint deadline,
132         bool approveMax, uint8 v, bytes32 r, bytes32 s
133     ) external returns (uint amountA, uint amountB);
134     function removeLiquidityETHWithPermit(
135         address token,
136         uint liquidity,
137         uint amountTokenMin,
138         uint amountETHMin,
139         address to,
140         uint deadline,
141         bool approveMax, uint8 v, bytes32 r, bytes32 s
142     ) external returns (uint amountToken, uint amountETH);
143     function swapExactTokensForTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external returns (uint[] memory amounts);
150     function swapTokensForExactTokens(
151         uint amountOut,
152         uint amountInMax,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external returns (uint[] memory amounts);
157     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
158         external
159         payable
160         returns (uint[] memory amounts);
161     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
162         external
163         returns (uint[] memory amounts);
164     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
165         external
166         returns (uint[] memory amounts);
167     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
168         external
169         payable
170         returns (uint[] memory amounts);
171 
172     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
173     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
174     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
175     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
176     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
177 }
178 
179 interface IUniswapV2Router02 is IUniswapV2Router01 {
180     function removeLiquidityETHSupportingFeeOnTransferTokens(
181         address token,
182         uint liquidity,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline
187     ) external returns (uint amountETH);
188     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
189         address token,
190         uint liquidity,
191         uint amountTokenMin,
192         uint amountETHMin,
193         address to,
194         uint deadline,
195         bool approveMax, uint8 v, bytes32 r, bytes32 s
196     ) external returns (uint amountETH);
197 
198     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external;
205     function swapExactETHForTokensSupportingFeeOnTransferTokens(
206         uint amountOutMin,
207         address[] calldata path,
208         address to,
209         uint deadline
210     ) external payable;
211     function swapExactTokensForETHSupportingFeeOnTransferTokens(
212         uint amountIn,
213         uint amountOutMin,
214         address[] calldata path,
215         address to,
216         uint deadline
217     ) external;
218 }
219 
220 interface IERC20 {
221     function totalSupply() external view returns (uint256);
222     function balanceOf(address account) external view returns (uint256);
223     function transfer(address recipient, uint256 amount) external returns (bool);
224     function allowance(address owner, address spender) external view returns (uint256);
225     function approve(address spender, uint256 amount) external returns (bool);
226     function transferFrom(
227         address sender,
228         address recipient,
229         uint256 amount
230     ) external returns (bool);
231    
232     event Transfer(address indexed from, address indexed to, uint256 value);
233     event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 interface IERC20Metadata is IERC20 {
237     function name() external view returns (string memory);
238     function symbol() external view returns (string memory);
239     function decimals() external view returns (uint8);
240 }
241 
242 library Address {
243     function isContract(address account) internal view returns (bool) {
244         return account.code.length > 0;
245     }
246 
247     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         return success;
252     }
253 
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
256     }
257 
258     function functionCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         return functionCallWithValue(target, data, 0, errorMessage);
264     }
265 
266     function functionCallWithValue(
267         address target,
268         bytes memory data,
269         uint256 value
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
272     }
273 
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         (bool success, bytes memory returndata) = target.call{value: value}(data);
282         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
283     }
284 
285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
286         return functionStaticCall(target, data, "Address: low-level static call failed");
287     }
288 
289     function functionStaticCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal view returns (bytes memory) {
294         (bool success, bytes memory returndata) = target.staticcall(data);
295         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
296     }
297 
298     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
299         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
300     }
301 
302     function functionDelegateCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         (bool success, bytes memory returndata) = target.delegatecall(data);
308         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
309     }
310 
311     function verifyCallResultFromTarget(
312         address target,
313         bool success,
314         bytes memory returndata,
315         string memory errorMessage
316     ) internal view returns (bytes memory) {
317         if (success) {
318             if (returndata.length == 0) {
319                 // only check isContract if the call was successful and the return data is empty
320                 // otherwise we already know that it was a contract
321                 require(isContract(target), "Address: call to non-contract");
322             }
323             return returndata;
324         } else {
325             _revert(returndata, errorMessage);
326         }
327     }
328 
329     function verifyCallResult(
330         bool success,
331         bytes memory returndata,
332         string memory errorMessage
333     ) internal pure returns (bytes memory) {
334         if (success) {
335             return returndata;
336         } else {
337             _revert(returndata, errorMessage);
338         }
339     }
340 
341     function _revert(bytes memory returndata, string memory errorMessage) private pure {
342         // Look for revert reason and bubble it up if present
343         if (returndata.length > 0) {
344             // The easiest way to bubble the revert reason is using memory via assembly
345             /// @solidity memory-safe-assembly
346             assembly {
347                 let returndata_size := mload(returndata)
348                 revert(add(32, returndata), returndata_size)
349             }
350         } else {
351             revert(errorMessage);
352         }
353     }
354 }
355 
356 abstract contract Context {
357     function _msgSender() internal view virtual returns (address) {
358         return msg.sender;
359     }
360 
361     function _msgData() internal view virtual returns (bytes calldata) {
362         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
363         return msg.data;
364     }
365 }
366 
367 abstract contract Ownable is Context {
368     address private _owner;
369 
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     constructor () {
373         address msgSender = _msgSender();
374         _owner = msgSender;
375         emit OwnershipTransferred(address(0), msgSender);
376     }
377 
378     function owner() public view returns (address) {
379         return _owner;
380     }
381 
382     modifier onlyOwner() {
383         require(_owner == _msgSender(), "Ownable: caller is not the owner");
384         _;
385     }
386 
387     function renounceOwnership() public virtual onlyOwner {
388         emit OwnershipTransferred(_owner, address(0));
389         _owner = address(0);
390     }
391 
392     function transferOwnership(address newOwner) public virtual onlyOwner {
393         require(newOwner != address(0), "Ownable: new owner is the zero address");
394         emit OwnershipTransferred(_owner, newOwner);
395         _owner = newOwner;
396     }
397 }
398 
399 contract ERC20 is Context, IERC20, IERC20Metadata {
400     mapping(address => uint256) private _balances;
401 
402     mapping(address => mapping(address => uint256)) private _allowances;
403 
404     uint256 private _totalSupply;
405 
406     string private _name;
407     string private _symbol;
408 
409     constructor(string memory name_, string memory symbol_) {
410         _name = name_;
411         _symbol = symbol_;
412     }
413 
414     function name() public view virtual override returns (string memory) {
415         return _name;
416     }
417 
418     function symbol() public view virtual override returns (string memory) {
419         return _symbol;
420     }
421 
422     function decimals() public view virtual override returns (uint8) {
423         return 18;
424     }
425 
426     function totalSupply() public view virtual override returns (uint256) {
427         return _totalSupply;
428     }
429 
430     function balanceOf(address account) public view virtual override returns (uint256) {
431         return _balances[account];
432     }
433 
434     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
435         _transfer(_msgSender(), recipient, amount);
436         return true;
437     }
438 
439     function allowance(address owner, address spender) public view virtual override returns (uint256) {
440         return _allowances[owner][spender];
441     }
442 
443     function approve(address spender, uint256 amount) public virtual override returns (bool) {
444         _approve(_msgSender(), spender, amount);
445         return true;
446     }
447 
448     function transferFrom(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) public virtual override returns (bool) {
453         uint256 currentAllowance = _allowances[sender][_msgSender()];
454         if (currentAllowance != type(uint256).max) {
455             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
456             unchecked {
457                 _approve(sender, _msgSender(), currentAllowance - amount);
458             }
459         }
460 
461         _transfer(sender, recipient, amount);
462 
463         return true;
464     }
465 
466     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
467         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
468         return true;
469     }
470 
471     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
472         uint256 currentAllowance = _allowances[_msgSender()][spender];
473         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
474         unchecked {
475             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
476         }
477 
478         return true;
479     }
480 
481     function _transfer(
482         address sender,
483         address recipient,
484         uint256 amount
485     ) internal virtual {
486         require(sender != address(0), "ERC20: transfer from the zero address");
487         require(recipient != address(0), "ERC20: transfer to the zero address");
488 
489         _beforeTokenTransfer(sender, recipient, amount);
490 
491         uint256 senderBalance = _balances[sender];
492         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
493         unchecked {
494             _balances[sender] = senderBalance - amount;
495         }
496         _balances[recipient] += amount;
497 
498         emit Transfer(sender, recipient, amount);
499 
500         _afterTokenTransfer(sender, recipient, amount);
501     }
502 
503     function _mint(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: mint to the zero address");
505 
506         _beforeTokenTransfer(address(0), account, amount);
507 
508         _totalSupply += amount;
509         _balances[account] += amount;
510         emit Transfer(address(0), account, amount);
511 
512         _afterTokenTransfer(address(0), account, amount);
513     }
514 
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         unchecked {
523             _balances[account] = accountBalance - amount;
524         }
525         _totalSupply -= amount;
526 
527         emit Transfer(account, address(0), amount);
528 
529         _afterTokenTransfer(account, address(0), amount);
530     }
531 
532     function _approve(
533         address owner,
534         address spender,
535         uint256 amount
536     ) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     function _beforeTokenTransfer(
545         address from,
546         address to,
547         uint256 amount
548     ) internal virtual {}
549 
550     function _afterTokenTransfer(
551         address from,
552         address to,
553         uint256 amount
554     ) internal virtual {}
555 }
556 
557 contract HOS is ERC20, Ownable {
558     using Address for address payable;
559 
560     IUniswapV2Router02 public uniswapV2Router;
561     address public  uniswapV2Pair;
562 
563     mapping (address => bool) private _isExcludedFromFees;
564 
565     string  public creator;
566 
567     uint256 public  marketingFeeOnBuy;
568     uint256 public  marketingFeeOnSell;
569 
570     uint256 public  marketingFeeOnTransfer;
571 
572     address public  marketingWallet;
573     bool    public  taxDisabled;
574 
575     event ExcludeFromFees(address indexed account, bool isExcluded);
576     event MarketingWalletChanged(address marketingWallet);
577 
578     constructor () ERC20("Hotel of Secrets", "HOS") 
579     {   
580         address router;
581         if (block.chainid == 56) {
582             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
583         } else if (block.chainid == 97) {
584             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
585         } else if (block.chainid == 1 || block.chainid == 5) {
586             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
587         } else {
588             revert();
589         }
590 
591         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
592         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
593             .createPair(address(this), _uniswapV2Router.WETH());
594 
595         uniswapV2Router = _uniswapV2Router;
596         uniswapV2Pair   = _uniswapV2Pair;
597 
598         _approve(address(this), address(uniswapV2Router), type(uint256).max);
599 
600         creator = "coinsult.net";
601 
602         marketingFeeOnBuy  = 0;
603         marketingFeeOnSell = 8;
604 
605         marketingFeeOnTransfer = 0;
606 
607         marketingWallet = 0xD0057197c0f75Fa02E950adD87B3307ef7c3B24a;
608 
609         _isExcludedFromFees[owner()] = true;
610         _isExcludedFromFees[address(0xdead)] = true;
611         _isExcludedFromFees[address(this)] = true;
612         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
613 
614         _mint(owner(), 1e9 * (10 ** decimals()));
615     }
616 
617     receive() external payable {
618 
619   	}
620 
621     function claimStuckTokens(address token) external onlyOwner {
622         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
623         if (token == address(0x0)) {
624             payable(msg.sender).sendValue(address(this).balance);
625             return;
626         }
627         IERC20 ERC20token = IERC20(token);
628         uint256 balance = ERC20token.balanceOf(address(this));
629         ERC20token.transfer(msg.sender, balance);
630     }
631 
632     function excludeFromFees(address account, bool excluded) external onlyOwner{
633         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
634         _isExcludedFromFees[account] = excluded;
635 
636         emit ExcludeFromFees(account, excluded);
637     }
638 
639     function isExcludedFromFees(address account) public view returns(bool) {
640         return _isExcludedFromFees[account];
641     }
642 
643     function changeMarketingWallet(address _marketingWallet) external onlyOwner{
644         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
645         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
646         marketingWallet = _marketingWallet;
647 
648         emit MarketingWalletChanged(marketingWallet);
649     }
650 
651     function disableTax() external onlyOwner {
652         require(!taxDisabled, "Already disabled.");
653         taxDisabled = true;
654     }
655 
656     function _transfer(address from,address to,uint256 amount) internal  override {
657         require(from != address(0), "ERC20: transfer from the zero address");
658         require(to != address(0), "ERC20: transfer to the zero address");
659        
660         if (amount == 0) {
661             super._transfer(from, to, 0);
662             return;
663         }
664 
665         uint256 _totalFees;
666         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || taxDisabled) {
667             _totalFees = 0;
668         } else if (from == uniswapV2Pair) {
669             _totalFees = marketingFeeOnBuy;
670         } else if (to == uniswapV2Pair) {
671             _totalFees =  marketingFeeOnSell;
672         } else {
673             _totalFees = 0;
674         }
675 
676         if (_totalFees > 0) {
677             uint256 fees = (amount * _totalFees) / 100;
678             amount = amount - fees;
679             super._transfer(from, marketingWallet, fees);
680         }
681 
682         super._transfer(from, to, amount);
683     }
684 }