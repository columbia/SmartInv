1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-18
3 */
4 
5 pragma solidity 0.6.12;
6 // SPDX-License-Identifier: Unlicensed
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 interface IERC20 {
19      
20     function totalSupply() external view returns (uint256);
21 
22    
23     function balanceOf(address account) external view returns (uint256);
24  
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27    
28     function allowance(address owner, address spender) external view returns (uint256);
29  
30     function approve(address spender, uint256 amount) external returns (bool);
31  
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33 
34     
35     event Transfer(address indexed from, address indexed to, uint256 value);
36  
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39  
40  library Address {
41      
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize, which returns 0 for contracts in
44         // construction, since the code is only stored at the end of the
45         // constructor execution.
46 
47         uint256 size;
48         // solhint-disable-next-line no-inline-assembly
49         assembly { size := extcodesize(account) }
50         return size > 0;
51     }
52 
53     
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(address(this).balance >= amount, "Address: insufficient balance");
56 
57         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
58         (bool success, ) = recipient.call{ value: amount }("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     
63     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
64       return functionCall(target, data, "Address: low-level call failed");
65     }
66 
67     
68     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
69         return functionCallWithValue(target, data, 0, errorMessage);
70     }
71 
72    
73     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
74         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
75     }
76 
77     
78     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
79         require(address(this).balance >= value, "Address: insufficient balance for call");
80         require(isContract(target), "Address: call to non-contract");
81 
82         // solhint-disable-next-line avoid-low-level-calls
83         (bool success, bytes memory returndata) = target.call{ value: value }(data);
84         return _verifyCallResult(success, returndata, errorMessage);
85     }
86  
87     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
88         return functionStaticCall(target, data, "Address: low-level static call failed");
89     }
90  
91     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
92         require(isContract(target), "Address: static call to non-contract");
93 
94         // solhint-disable-next-line avoid-low-level-calls
95         (bool success, bytes memory returndata) = target.staticcall(data);
96         return _verifyCallResult(success, returndata, errorMessage);
97     }
98 
99     
100     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
102     }
103  
104     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
105         require(isContract(target), "Address: delegate call to non-contract");
106 
107         // solhint-disable-next-line avoid-low-level-calls
108         (bool success, bytes memory returndata) = target.delegatecall(data);
109         return _verifyCallResult(success, returndata, errorMessage);
110     }
111 
112     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
113         if (success) {
114             return returndata;
115         } else {
116             // Look for revert reason and bubble it up if present
117             if (returndata.length > 0) {
118                 // The easiest way to bubble the revert reason is using memory via assembly
119 
120                 // solhint-disable-next-line no-inline-assembly
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 
132  library SafeMath {
133      
134     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         uint256 c = a + b;
136         if (c < a) return (false, 0);
137         return (true, c);
138     }
139  
140     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         if (b > a) return (false, 0);
142         return (true, a - b);
143     }
144 
145     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) return (true, 0);
150         uint256 c = a * b;
151         if (c / a != b) return (false, 0);
152         return (true, c);
153     }
154 
155     
156     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         if (b == 0) return (false, 0);
158         return (true, a / b);
159     }
160 
161      
162     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         if (b == 0) return (false, 0);
164         return (true, a % b);
165     }
166  
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         require(c >= a, "SafeMath: addition overflow");
170         return c;
171     }
172  
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b <= a, "SafeMath: subtraction overflow");
175         return a - b;
176     }
177 
178     
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         if (a == 0) return 0;
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183         return c;
184     }
185 
186      
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b > 0, "SafeMath: division by zero");
189         return a / b;
190     }
191 
192     
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         require(b > 0, "SafeMath: modulo by zero");
195         return a % b;
196     }
197 
198   
199     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b <= a, errorMessage);
201         return a - b;
202     }
203 
204      
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b > 0, errorMessage);
207         return a / b;
208     }
209 
210  
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         return a % b;
214     } 
215 }
216 contract Ownable is Context {
217     address private _owner;
218     address private _previousOwner;
219     uint256 private _lockTime;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     constructor () internal {
224         address msgSender = _msgSender();
225         _owner = msgSender;
226         emit OwnershipTransferred(address(0), msgSender);
227     }
228 
229     function owner() public view returns (address) {
230         return _owner;
231     }
232 
233     modifier onlyOwner() {
234         require(_owner == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237 
238     function renounceOwnership() public virtual onlyOwner {
239         emit OwnershipTransferred(_owner, address(0));
240         _owner = address(0);
241     }
242 
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         emit OwnershipTransferred(_owner, newOwner);
246         _owner = newOwner;
247     }
248 
249     function geUnlockTime() public view returns (uint256) {
250         return _lockTime;
251     }
252     
253      //Locks the contract for owner for the amount of time provided
254     function lock(uint256 time) public virtual onlyOwner {
255         _previousOwner = _owner;
256         _owner = address(0);
257         _lockTime = now + time;
258         emit OwnershipTransferred(_owner, address(0));
259     }
260     
261     //Unlocks the contract for owner when _lockTime is exceeds
262     function unlock() public virtual {
263         require(_previousOwner == msg.sender, "You don't have permission to unlock");
264         require(now > _lockTime , "Contract is locked until 7 days");
265         emit OwnershipTransferred(_owner, _previousOwner);
266         _owner = _previousOwner;
267     }
268 }
269 
270 
271 
272 interface IUniswapV2Factory {
273     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
274 
275     function feeTo() external view returns (address);
276     function feeToSetter() external view returns (address);
277 
278     function getPair(address tokenA, address tokenB) external view returns (address pair);
279     function allPairs(uint) external view returns (address pair);
280     function allPairsLength() external view returns (uint);
281 
282     function createPair(address tokenA, address tokenB) external returns (address pair);
283 
284     function setFeeTo(address) external;
285     function setFeeToSetter(address) external;
286 }
287 
288 
289 
290 interface IUniswapV2Pair {
291     event Approval(address indexed owner, address indexed spender, uint value);
292     event Transfer(address indexed from, address indexed to, uint value);
293 
294     function name() external pure returns (string memory);
295     function symbol() external pure returns (string memory);
296     function decimals() external pure returns (uint8);
297     function totalSupply() external view returns (uint);
298     function balanceOf(address owner) external view returns (uint);
299     function allowance(address owner, address spender) external view returns (uint);
300 
301     function approve(address spender, uint value) external returns (bool);
302     function transfer(address to, uint value) external returns (bool);
303     function transferFrom(address from, address to, uint value) external returns (bool);
304 
305     function DOMAIN_SEPARATOR() external view returns (bytes32);
306     function PERMIT_TYPEHASH() external pure returns (bytes32);
307     function nonces(address owner) external view returns (uint);
308 
309     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
310 
311     event Mint(address indexed sender, uint amount0, uint amount1);
312     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
313     event Swap(
314         address indexed sender,
315         uint amount0In,
316         uint amount1In,
317         uint amount0Out,
318         uint amount1Out,
319         address indexed to
320     );
321     event Sync(uint112 reserve0, uint112 reserve1);
322 
323     function MINIMUM_LIQUIDITY() external pure returns (uint);
324     function factory() external view returns (address);
325     function token0() external view returns (address);
326     function token1() external view returns (address);
327     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
328     function price0CumulativeLast() external view returns (uint);
329     function price1CumulativeLast() external view returns (uint);
330     function kLast() external view returns (uint);
331 
332     function mint(address to) external returns (uint liquidity);
333     function burn(address to) external returns (uint amount0, uint amount1);
334     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
335     function skim(address to) external;
336     function sync() external;
337 
338     function initialize(address, address) external;
339 }
340 
341 
342 interface IUniswapV2Router01 {
343     function factory() external pure returns (address);
344     function WETH() external pure returns (address);
345 
346     function addLiquidity(
347         address tokenA,
348         address tokenB,
349         uint amountADesired,
350         uint amountBDesired,
351         uint amountAMin,
352         uint amountBMin,
353         address to,
354         uint deadline
355     ) external returns (uint amountA, uint amountB, uint liquidity);
356     function addLiquidityETH(
357         address token,
358         uint amountTokenDesired,
359         uint amountTokenMin,
360         uint amountETHMin,
361         address to,
362         uint deadline
363     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
364     function removeLiquidity(
365         address tokenA,
366         address tokenB,
367         uint liquidity,
368         uint amountAMin,
369         uint amountBMin,
370         address to,
371         uint deadline
372     ) external returns (uint amountA, uint amountB);
373     function removeLiquidityETH(
374         address token,
375         uint liquidity,
376         uint amountTokenMin,
377         uint amountETHMin,
378         address to,
379         uint deadline
380     ) external returns (uint amountToken, uint amountETH);
381     function removeLiquidityWithPermit(
382         address tokenA,
383         address tokenB,
384         uint liquidity,
385         uint amountAMin,
386         uint amountBMin,
387         address to,
388         uint deadline,
389         bool approveMax, uint8 v, bytes32 r, bytes32 s
390     ) external returns (uint amountA, uint amountB);
391     function removeLiquidityETHWithPermit(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline,
398         bool approveMax, uint8 v, bytes32 r, bytes32 s
399     ) external returns (uint amountToken, uint amountETH);
400     function swapExactTokensForTokens(
401         uint amountIn,
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline
406     ) external returns (uint[] memory amounts);
407     function swapTokensForExactTokens(
408         uint amountOut,
409         uint amountInMax,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external returns (uint[] memory amounts);
414     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
415         external
416         payable
417         returns (uint[] memory amounts);
418     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
419         external
420         returns (uint[] memory amounts);
421     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
422         external
423         returns (uint[] memory amounts);
424     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
425         external
426         payable
427         returns (uint[] memory amounts);
428 
429     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
430     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
431     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
432     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
433     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
434 }
435 
436 interface IUniswapV2Router02 is IUniswapV2Router01 {
437     function removeLiquidityETHSupportingFeeOnTransferTokens(
438         address token,
439         uint liquidity,
440         uint amountTokenMin,
441         uint amountETHMin,
442         address to,
443         uint deadline
444     ) external returns (uint amountETH);
445     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
446         address token,
447         uint liquidity,
448         uint amountTokenMin,
449         uint amountETHMin,
450         address to,
451         uint deadline,
452         bool approveMax, uint8 v, bytes32 r, bytes32 s
453     ) external returns (uint amountETH);
454 
455     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
456         uint amountIn,
457         uint amountOutMin,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external;
462     function swapExactETHForTokensSupportingFeeOnTransferTokens(
463         uint amountOutMin,
464         address[] calldata path,
465         address to,
466         uint deadline
467     ) external payable;
468     function swapExactTokensForETHSupportingFeeOnTransferTokens(
469         uint amountIn,
470         uint amountOutMin,
471         address[] calldata path,
472         address to,
473         uint deadline
474     ) external;
475 }
476 
477 contract Digifit is Context, IERC20, Ownable {
478     using SafeMath for uint256;
479     using Address for address;
480 
481     mapping (address => uint256) private _rOwned;// with reward
482     mapping (address => uint256) private _tOwned; // without reward
483     mapping (address => mapping (address => uint256)) private _allowances;
484 
485     mapping (address => bool) private _isIncludedInFee;
486 
487     mapping (address => bool) private _isExcluded; //from reward
488     address[] private _excluded;
489    
490     uint256 private constant MAX = ~uint256(0);
491     uint256 private _tTotal =  700000000 * 10**9;
492     uint256 private _rTotal = (MAX - (MAX % _tTotal));
493     uint256 private _tFeeTotal;
494     
495     //marketing wallet
496     address public marketingWallet;
497 
498     //switches
499     bool public marketingwalletenabled = true;
500     bool public liquidityenabled = true;
501     bool public burnenabled = true;
502     bool public rewardenabled = true;
503 
504     uint256 public marketingwalletpercent = 2;  //2%
505     uint256 public burnpercent = 1;              //1%
506     uint256 public rewardpercent = 1;            //1%
507 
508     uint256 public prevmarketingwalletpercent= marketingwalletpercent;  
509     uint256 public prevburnpercent = burnpercent;          
510     uint256 public prevrewardpercent = rewardpercent;
511 
512     string private _name = "DIGIFIT";
513     string private _symbol = "DGI";
514     uint8 private _decimals = 9;
515     
516     uint256 public _liquidityFee = 1;                       
517     uint256 private _previousLiquidityFee = _liquidityFee;    //1%
518      
519     event Switchburn(bool enabled, uint256 value);
520     event Switchesupdated(bool markenabled, uint256 markvalue,bool burnenabled, uint256 burnvalue,bool rewardenabled, uint256 rewardvalue);
521     event Switchwallet(bool enabled, uint256 value);
522     
523     event UpdatedMarketingwallet(address wallet);
524 
525     event excludedFromFee(address wallet);
526     event includedInFee(address wallet);
527     event excluded(address wallet);
528     event included(address wallet);
529     event burned(address account,uint256 amount);
530 
531 
532     IUniswapV2Router02 public immutable uniswapV2Router;
533     address public immutable uniswapV2Pair;
534     
535     bool public inSwapAndLiquify;
536     bool public swapAndLiquifyEnabled = true;
537     
538     uint256 private numTokensSellToAddToLiquidity = 700000000  * 10**9; 
539     
540     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
541     event SwapAndLiquifyEnabledUpdated(bool enabled);
542     event SwapAndLiquify(
543         uint256 tokensSwapped,
544         uint256 ethReceived,
545         uint256 tokensIntoLiqudity
546     );
547     
548     modifier lockTheSwap {
549         inSwapAndLiquify = true;
550         _;
551         inSwapAndLiquify = false;
552     }
553     
554     constructor (address _marketingwallet) public {
555         require(_marketingwallet != address(0));
556         _rOwned[_msgSender()] = _rTotal;
557         
558         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
559          // Create a uniswap pair for this new token
560         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
561             .createPair(address(this), _uniswapV2Router.WETH());
562 
563         // set the rest of the contract variables
564         uniswapV2Router = _uniswapV2Router;
565         
566         marketingWallet = _marketingwallet;
567         
568         
569         emit Transfer(address(0), _msgSender(), _tTotal);
570     }
571 
572     function name() public view returns (string memory) {
573         return _name;
574     }
575 
576     function symbol() public view returns (string memory) {
577         return _symbol;
578     }
579 
580     function decimals() public view returns (uint8) {
581         return _decimals;
582     }
583 
584     function totalSupply() public view override returns (uint256) {
585         return _tTotal;
586     }
587 
588     function balanceOf(address account) public view override returns (uint256) {
589         if (_isExcluded[account]) return _tOwned[account];                         
590         return tokenFromReflection(_rOwned[account]);
591     }
592 
593     function transfer(address recipient, uint256 amount) public override returns (bool) {
594         _transfer(_msgSender(), recipient, amount);
595         return true;
596     }
597 
598     function allowance(address owner, address spender) public view override returns (uint256) {
599         return _allowances[owner][spender];
600     }
601 
602     function approve(address spender, uint256 amount) public override returns (bool) {
603         _approve(_msgSender(), spender, amount);
604         return true;
605     }
606 
607     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
608         _transfer(sender, recipient, amount);
609         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
610         return true;
611     }
612 
613     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
614         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
615         return true;
616     }
617 
618     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
619         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
620         return true;
621     }
622     
623     function burn(uint256 amount) external returns (bool) {
624         _burn(_msgSender(), amount);
625         return true;
626     }
627     
628     function isExcludedFromReward(address account) public view returns (bool) {
629         return _isExcluded[account];
630     }
631 
632     function totalFees() public view returns (uint256) {
633         return _tFeeTotal;
634     }
635        
636     function reflect(uint256 tAmount) external {
637        address sender = _msgSender();
638        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
639       (uint256 rAmount,,,,,) = _getValues(tAmount);
640       _rOwned[sender] = _rOwned[sender].sub(rAmount);
641        _rTotal = _rTotal.sub(rAmount);
642        _tFeeTotal = _tFeeTotal.add(tAmount);
643    }
644 
645 
646     function deliver(uint256 tAmount) public {
647         address sender = _msgSender();
648         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
649         (uint256 rAmount,,,,,) = _getValues(tAmount);
650         _rOwned[sender] = _rOwned[sender].sub(rAmount);
651         _rTotal = _rTotal.sub(rAmount);
652         _tFeeTotal = _tFeeTotal.add(tAmount);
653     }
654 
655   
656     function excludeFromFee(address account) public onlyOwner {
657        _isIncludedInFee[account] = false;
658     }
659     
660     function includeInFee(address account) public onlyOwner {
661         _isIncludedInFee[account] = true;
662     }
663     
664     
665     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
666       _liquidityFee = liquidityFee;
667     }
668     
669     function setLiqiditySaleTokenNumber(uint256 limit) external onlyOwner() {
670      numTokensSellToAddToLiquidity = limit;
671     }
672     
673     
674 
675     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
676         swapAndLiquifyEnabled = _enabled;
677         emit SwapAndLiquifyEnabledUpdated(_enabled);
678     }
679     
680      //to recieve ETH from uniswapV2Router when swaping
681     receive() external payable {}
682 
683    
684     function _takeLiquidity(uint256 tLiquidity) private {
685         uint256 currentRate =  _getRate();
686         uint256 rLiquidity = tLiquidity.mul(currentRate);
687         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
688         if(_isExcluded[address(this)])
689             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
690     }
691     
692     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
693         return _amount.mul(_liquidityFee).div(
694             10**2
695         );
696     }
697 
698     function isIncludedInFee(address account) public view returns(bool) {
699         return _isIncludedInFee[account];
700     }
701 
702     function _approve(address owner, address spender, uint256 amount) private {
703         require(owner != address(0), "ERC20: approve from the zero address");
704         require(spender != address(0), "ERC20: approve to the zero address");
705 
706         _allowances[owner][spender] = amount;
707         emit Approval(owner, spender, amount);
708     }
709 
710     function _transfer(
711         address from,
712         address to,
713         uint256 amount
714     ) private {
715         require(from != address(0), "ERC20: transfer from the zero address");
716         require(to != address(0), "ERC20: transfer to the zero address");
717         require(amount > 0, "Transfer amount must be greater than zero");
718         
719         // is the token balance of this contract address over the min number of
720         // tokens that we need to initiate a swap + liquidity lock?
721         // also, don't get caught in a circular liquidity event.
722         // also, don't swap & liquify if sender is uniswap pair.
723         uint256 contractTokenBalance = balanceOf(address(this));
724         
725       
726         
727         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
728         if (
729             overMinTokenBalance &&
730             !inSwapAndLiquify &&
731             from != uniswapV2Pair &&
732             swapAndLiquifyEnabled
733         ) {
734             contractTokenBalance = numTokensSellToAddToLiquidity;
735             //add liquidity
736             swapAndLiquify(contractTokenBalance);
737         }
738         
739         //indicates if fee should be deducted from transfer
740         bool takeFee = false;
741         
742         //if any account belongs to _isExcludedFromFee account then remove the fee
743         if(_isIncludedInFee[from] || _isIncludedInFee[to]){
744             takeFee = true;
745         }
746         
747         //transfer amount, it will take tax, burn, liquidity fee
748         _tokenTransfer(from,to,amount,takeFee);
749     }
750 
751     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
752         // split the contract balance into halves
753         uint256 half = contractTokenBalance.div(2);
754         uint256 otherHalf = contractTokenBalance.sub(half);
755 
756         // capture the contract's current ETH balance.
757         // this is so that we can capture exactly the amount of ETH that the
758         // swap creates, and not make the liquidity event include any ETH that
759         // has been manually sent to the contract
760         uint256 initialBalance = address(this).balance;
761 
762         // swap tokens for ETH
763         swapTokensForEth(half); 
764 
765         // how much ETH did we just swap into?
766         uint256 newBalance = address(this).balance.sub(initialBalance);
767 
768         // add liquidity to uniswap
769         addLiquidity(otherHalf, newBalance);
770         
771         emit SwapAndLiquify(half, newBalance, otherHalf);
772     }
773 
774     function swapTokensForEth(uint256 tokenAmount) private {
775         // generate the uniswap pair path of token -> weth
776         address[] memory path = new address[](2);
777         path[0] = address(this);
778         path[1] = uniswapV2Router.WETH();
779 
780         _approve(address(this), address(uniswapV2Router), tokenAmount);
781 
782         // make the swap
783         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
784             tokenAmount,
785             0, // accept any amount of ETH
786             path,
787             address(this),
788             block.timestamp
789         );
790     }
791  function burningTransfer(uint256 tAmount) private {
792      uint256 tBurn;
793  (tBurn) = _getBurnValues(tAmount);
794               uint256 rbamount = tBurn.mul(_getRate());
795                _tTotal = _tTotal.sub(tBurn);
796         _rTotal = _rTotal.sub(rbamount);
797  }
798 
799 
800     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
801         // approve token transfer to cover all possible scenarios
802         _approve(address(this), address(uniswapV2Router), tokenAmount);
803 
804         // add the liquidity
805         uniswapV2Router.addLiquidityETH{value: ethAmount}(
806             address(this),
807             tokenAmount,
808             0, // slippage is unavoidable
809             0, // slippage is unavoidable
810             owner(),
811             block.timestamp
812         );
813     }
814 
815     function _burn(address account, uint256 amount) internal {
816         require(account != address(0), "ERC20: burn from the zero address");
817         require(balanceOf(account) >= amount, "ERC20: burn amount exceeds balance");
818          uint256 rbamount=amount.mul(_getRate());
819          _tTotal = _tTotal.sub(amount);
820         _rTotal = _rTotal.sub(rbamount);
821         _rOwned[account] = _rOwned[account].sub(rbamount);
822         if(_isExcluded[account])
823         {
824             _tOwned[account] = _tOwned[account].sub(amount);
825         }
826         emit burned(account,amount);
827     }
828 
829     //this method is responsible for taking all fee, if takeFee is true
830     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
831         if(!takeFee) 
832 
833             removeAllFee();
834         
835         if (_isExcluded[sender] && !_isExcluded[recipient]) {
836             _transferFromExcluded(sender, recipient, amount);
837         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
838             _transferToExcluded(sender, recipient, amount);
839         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
840             _transferStandard(sender, recipient, amount);
841         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
842             _transferBothExcluded(sender, recipient, amount);
843         } else {
844             _transferStandard(sender, recipient, amount);
845         }
846         
847         if(!takeFee)   
848             restoreAllFee();
849     }
850 
851     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
852         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
853         _rOwned[sender] = _rOwned[sender].sub(rAmount);
854         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
855         uint256 rwalletfee = 0;
856         if(marketingwalletenabled)   
857         {
858             (rwalletfee) = _getWalletValues(tAmount);
859             _rOwned[marketingWallet] = _rOwned[marketingWallet].add(rwalletfee);
860 
861         }
862         if(burnenabled)
863         {
864           burningTransfer(tAmount);
865         }
866         _takeLiquidity(tLiquidity);
867         _reflectFee(rFee.sub(rwalletfee), tFee);     
868         emit Transfer(sender, recipient, tTransferAmount);
869     }
870 
871     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
872         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
873         _rOwned[sender] = _rOwned[sender].sub(rAmount);
874         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
875         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
876         uint256 rwalletfee = 0;
877         if(marketingwalletenabled)   
878         {
879             (rwalletfee) = _getWalletValues(tAmount);
880             _rOwned[marketingWallet] = _rOwned[marketingWallet].add(rwalletfee);
881 
882         }
883         if(burnenabled)
884         {
885             burningTransfer(tAmount);
886         }    
887         _takeLiquidity(tLiquidity);
888         _reflectFee(rFee.sub(rwalletfee), tFee); 
889         emit Transfer(sender, recipient, tTransferAmount);
890     }
891 
892     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
893         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
894         _tOwned[sender] = _tOwned[sender].sub(tAmount);
895         _rOwned[sender] = _rOwned[sender].sub(rAmount);
896         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
897         uint256 rwalletfee = 0;
898         if(marketingwalletenabled)   
899         {
900             (rwalletfee) = _getWalletValues(tAmount);
901             _rOwned[marketingWallet] = _rOwned[marketingWallet].add(rwalletfee);
902 
903         }
904         if(burnenabled)
905         {
906              burningTransfer(tAmount);
907         } 
908         _takeLiquidity(tLiquidity);
909         _reflectFee(rFee.sub(rwalletfee), tFee); 
910         emit Transfer(sender, recipient, tTransferAmount);
911     }
912     
913     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
914         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
915         _tOwned[sender] = _tOwned[sender].sub(tAmount);
916         _rOwned[sender] = _rOwned[sender].sub(rAmount);
917         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
918         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
919           uint256 rwalletfee = 0;
920         if(marketingwalletenabled)   
921         {
922             (rwalletfee) = _getWalletValues(tAmount);
923             _rOwned[marketingWallet] = _rOwned[marketingWallet].add(rwalletfee);
924 
925         }
926         if(burnenabled)
927         {
928              burningTransfer(tAmount);
929         }         
930         _takeLiquidity(tLiquidity);
931         _reflectFee(rFee.sub(rwalletfee), tFee);
932         emit Transfer(sender, recipient, tTransferAmount);
933     }
934 
935       function _getWalletValues(uint256 tAmount) private view returns ( uint256) {
936         uint256 currentRate = _getRate();
937         //wallet amount
938         uint256 twalletfee = tAmount.div(100).mul(marketingwalletpercent); 
939         uint256 rwalletfee= twalletfee.mul(currentRate);
940         return (rwalletfee);
941     }
942 
943     function _getBurnValues(uint256 tAmount) private view returns (uint256) {
944         //burn amount
945         uint256 tBurn = tAmount.div(100).mul(burnpercent);
946         return (tBurn);
947     }
948     
949      function _reflectFee(uint256 rFee, uint256 tFee) private {
950         _rTotal = _rTotal.sub(rFee);
951         _tFeeTotal = _tFeeTotal.add(tFee);
952     }
953 
954     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
955         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
956         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
957         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
958 
959     }
960 
961     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
962         uint256 totaltax = _getTotalTax();
963         uint256 tFee = tAmount.div(100).mul(totaltax);
964         uint256 tLiquidity = calculateLiquidityFee(tAmount);
965         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
966         return (tTransferAmount, tFee, tLiquidity);
967     }
968 
969     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
970         uint256 rAmount = tAmount.mul(currentRate);
971         uint256 rFee = tFee.mul(currentRate);
972         uint256 rLiquidity = tLiquidity.mul(currentRate);
973         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
974         return (rAmount, rTransferAmount, rFee);
975     }
976 
977     function _getRate() private view returns(uint256) {
978         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
979         return rSupply.div(tSupply);
980     }
981 
982     function _getCurrentSupply() private view returns(uint256, uint256) {
983         uint256 rSupply = _rTotal;
984         uint256 tSupply = _tTotal;      
985         for (uint256 i = 0; i < _excluded.length; i++) {
986             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
987             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
988             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
989         }
990         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
991         return (rSupply, tSupply);
992     }
993     
994    
995 
996     function updateSwitches(bool _marketingwalletenabled,uint256 markvalue,bool _burnenabled,uint256 burnvalue,bool _rewardholderenabled,uint256 _rewardvalue) external onlyOwner {
997         require(burnvalue <= 100 && _rewardvalue <= 100 && markvalue<=100 , "TaxFee exceed 100"); 
998         rewardenabled = _rewardholderenabled;
999         rewardpercent = _rewardvalue;
1000         burnenabled = _burnenabled;
1001         burnpercent = burnvalue;
1002         marketingwalletenabled = _marketingwalletenabled;
1003         marketingwalletpercent = markvalue;
1004         
1005         emit Switchesupdated(marketingwalletenabled,marketingwalletpercent,burnenabled,burnpercent,rewardenabled,rewardpercent);
1006     }
1007     
1008     function updateMarketingWallet(address _marketingwallet) external onlyOwner {
1009         require(_marketingwallet != address(0), "new marketing Wallet is the zero address");
1010         marketingWallet = _marketingwallet;
1011         emit UpdatedMarketingwallet(_marketingwallet);
1012     }
1013     
1014     function _getTotalTax() private view returns(uint256) {
1015         uint256 totaltax = rewardpercent;
1016         if(burnenabled)
1017         totaltax += burnpercent;
1018         if(marketingwalletenabled)
1019         totaltax += marketingwalletpercent;
1020         return (totaltax);
1021     }
1022 
1023     function removeAllFee() private {
1024         if(marketingwalletpercent==0 && _liquidityFee==0 && burnpercent==0 && rewardpercent==0 ) return;
1025          
1026         prevmarketingwalletpercent = marketingwalletpercent;
1027         _previousLiquidityFee = _liquidityFee;
1028         prevburnpercent = burnpercent;
1029         prevrewardpercent = rewardpercent;
1030         
1031         marketingwalletpercent = 0;
1032         _liquidityFee = 0;
1033         burnpercent = 0;
1034         rewardpercent = 0;
1035     } 
1036     
1037     function restoreAllFee() private {
1038         marketingwalletpercent = prevmarketingwalletpercent; //
1039          _liquidityFee = _previousLiquidityFee;
1040         burnpercent = prevburnpercent;    
1041         rewardpercent = prevrewardpercent;     // holders
1042     }
1043 
1044 
1045    // Exclusion Module
1046 
1047    function excludeFromReward(address account) public onlyOwner() {
1048         require(!_isExcluded[account], "Account is already excluded");
1049         if(_rOwned[account] > 0) {
1050             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1051         }
1052         _isExcluded[account] = true;
1053         _excluded.push(account);
1054     }
1055 
1056      function includeInReward(address account) external onlyOwner() {
1057         require(_isExcluded[account], "Account is already excluded");
1058         for (uint256 i = 0; i < _excluded.length; i++) {
1059             if (_excluded[i] == account) {
1060                 _excluded[i] = _excluded[_excluded.length - 1];
1061                 _tOwned[account] = 0;
1062                 _isExcluded[account] = false;
1063                 _excluded.pop();
1064                 break;
1065             }
1066         }
1067     }
1068 
1069     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1070         require(tAmount <= _tTotal, "Amount must be less than supply");
1071         if (!deductTransferFee) {
1072             (uint256 rAmount,,,,,) = _getValues(tAmount);
1073             return rAmount;
1074         } else {
1075             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1076             return rTransferAmount;
1077         }
1078     }
1079 
1080     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1081         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1082         uint256 currentRate =  _getRate();
1083         return rAmount.div(currentRate);
1084     }
1085 
1086 }