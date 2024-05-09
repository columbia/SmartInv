1 // $aPILOT
2 
3 // Decentralized Experiment
4 // Autopilot
5 // 10% USDC Rewards
6 // 3% Max Wallet
7 // No Presale / Marketing Wallet
8 // https://twitter.com/Autopilot_USDC
9 
10 
11 // SPDX-License-Identifier: MIT                                                                               
12 pragma solidity 0.8.13;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IUniswapV2Factory {
26     function createPair(address tokenA, address tokenB) external returns (address pair);
27 }
28 
29 interface IERC20 {
30 
31     function totalSupply() external view returns (uint256);
32 
33     function balanceOf(address account) external view returns (uint256);
34 
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     function approve(address spender, uint256 amount) external returns (bool);
40 
41     function transferFrom(
42         address sender,
43         address recipient,
44         uint256 amount
45     ) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 interface IERC20Metadata is IERC20 {
53     /**
54      * @dev Returns the name of the token.
55      */
56     function name() external view returns (string memory);
57 
58     /**
59      * @dev Returns the symbol of the token.
60      */
61     function symbol() external view returns (string memory);
62 
63     /**
64      * @dev Returns the decimals places of the token.
65      */
66     function decimals() external view returns (uint8);
67 }
68 
69 
70 contract ERC20 is Context, IERC20, IERC20Metadata {
71     mapping(address => uint256) private _balances;
72 
73     mapping(address => mapping(address => uint256)) private _allowances;
74 
75     uint256 private _totalSupply;
76 
77     string private _name;
78     string private _symbol;
79 
80     constructor(string memory name_, string memory symbol_) {
81         _name = name_;
82         _symbol = symbol_;
83     }
84 
85     function name() public view virtual override returns (string memory) {
86         return _name;
87     }
88 
89     function symbol() public view virtual override returns (string memory) {
90         return _symbol;
91     }
92 
93     function decimals() public view virtual override returns (uint8) {
94         return 18;
95     }
96 
97     function totalSupply() public view virtual override returns (uint256) {
98         return _totalSupply;
99     }
100 
101     function balanceOf(address account) public view virtual override returns (uint256) {
102         return _balances[account];
103     }
104 
105     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(_msgSender(), recipient, amount);
107         return true;
108     }
109 
110     function allowance(address owner, address spender) public view virtual override returns (uint256) {
111         return _allowances[owner][spender];
112     }
113 
114     function approve(address spender, uint256 amount) public virtual override returns (bool) {
115         _approve(_msgSender(), spender, amount);
116         return true;
117     }
118 
119     function transferFrom(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) public virtual override returns (bool) {
124         _transfer(sender, recipient, amount);
125 
126         uint256 currentAllowance = _allowances[sender][_msgSender()];
127         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
128         unchecked {
129             _approve(sender, _msgSender(), currentAllowance - amount);
130         }
131 
132         return true;
133     }
134 
135     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
136         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
137         return true;
138     }
139 
140     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
141         uint256 currentAllowance = _allowances[_msgSender()][spender];
142         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
143         unchecked {
144             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
145         }
146 
147         return true;
148     }
149 
150     function _transfer(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) internal virtual {
155         require(sender != address(0), "ERC20: transfer from the zero address");
156         require(recipient != address(0), "ERC20: transfer to the zero address");
157 
158         uint256 senderBalance = _balances[sender];
159         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
160         unchecked {
161             _balances[sender] = senderBalance - amount;
162         }
163         _balances[recipient] += amount;
164 
165         emit Transfer(sender, recipient, amount);
166     }
167 
168     function _createInitialSupply(address account, uint256 amount) internal virtual {
169         require(account != address(0), "ERC20: mint to the zero address");
170         _totalSupply += amount;
171         _balances[account] += amount;
172         emit Transfer(address(0), account, amount);
173     }
174 
175     function _approve(
176         address owner,
177         address spender,
178         uint256 amount
179     ) internal virtual {
180         require(owner != address(0), "ERC20: approve from the zero address");
181         require(spender != address(0), "ERC20: approve to the zero address");
182 
183         _allowances[owner][spender] = amount;
184         emit Approval(owner, spender, amount);
185     }
186 }
187 
188 interface DividendPayingTokenOptionalInterface {
189 
190   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
191 
192   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
193 
194   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
195 }
196 
197 interface DividendPayingTokenInterface {
198   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
199 
200 
201   function distributeDividends() external payable;
202 
203   function withdrawDividend(address _rewardToken) external;
204 
205   event DividendsDistributed(
206     address indexed from,
207     uint256 weiAmount
208   );
209 
210   /// @dev This event MUST emit when an address withdraws their dividend.
211   /// @param to The address which withdraws ether from this contract.
212   /// @param weiAmount The amount of withdrawn ether in wei.
213   event DividendWithdrawn(
214     address indexed to,
215     uint256 weiAmount
216   );
217 }
218 
219 library SafeMath {
220 
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         require(c >= a, "SafeMath: addition overflow");
224 
225         return c;
226     }
227 
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return sub(a, b, "SafeMath: subtraction overflow");
230     }
231 
232     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         uint256 c = a - b;
235 
236         return c;
237     }
238 
239     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         return div(a, b, "SafeMath: division by zero");
252     }
253 
254     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b > 0, errorMessage);
256         uint256 c = a / b;
257         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
258 
259         return c;
260     }
261 
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         return mod(a, b, "SafeMath: modulo by zero");
264     }
265 
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276     
277     constructor () {
278         address msgSender = _msgSender();
279         _owner = msgSender;
280         emit OwnershipTransferred(address(0), msgSender);
281     }
282 
283     function owner() public view returns (address) {
284         return _owner;
285     }
286 
287     modifier onlyOwner() {
288         require(_owner == _msgSender(), "Ownable: caller is not the owner");
289         _;
290     }
291 
292     function renounceOwnership() public virtual onlyOwner {
293         emit OwnershipTransferred(_owner, address(0));
294         _owner = address(0);
295     }
296 
297     function transferOwnership(address newOwner) public virtual onlyOwner {
298         require(newOwner != address(0), "Ownable: new owner is the zero address");
299         emit OwnershipTransferred(_owner, newOwner);
300         _owner = newOwner;
301     }
302 }
303 
304 
305 
306 library SafeMathInt {
307     int256 private constant MIN_INT256 = int256(1) << 255;
308     int256 private constant MAX_INT256 = ~(int256(1) << 255);
309 
310     function mul(int256 a, int256 b) internal pure returns (int256) {
311         int256 c = a * b;
312 
313         // Detect overflow when multiplying MIN_INT256 with -1
314         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
315         require((b == 0) || (c / b == a));
316         return c;
317     }
318 
319     function div(int256 a, int256 b) internal pure returns (int256) {
320         // Prevent overflow when dividing MIN_INT256 by -1
321         require(b != -1 || a != MIN_INT256);
322 
323         // Solidity already throws when dividing by 0.
324         return a / b;
325     }
326 
327     function sub(int256 a, int256 b) internal pure returns (int256) {
328         int256 c = a - b;
329         require((b >= 0 && c <= a) || (b < 0 && c > a));
330         return c;
331     }
332 
333     /**
334      * @dev Adds two int256 variables and fails on overflow.
335      */
336     function add(int256 a, int256 b) internal pure returns (int256) {
337         int256 c = a + b;
338         require((b >= 0 && c >= a) || (b < 0 && c < a));
339         return c;
340     }
341 
342     function abs(int256 a) internal pure returns (int256) {
343         require(a != MIN_INT256);
344         return a < 0 ? -a : a;
345     }
346 
347 
348     function toUint256Safe(int256 a) internal pure returns (uint256) {
349         require(a >= 0);
350         return uint256(a);
351     }
352 }
353 
354 library SafeMathUint {
355   function toInt256Safe(uint256 a) internal pure returns (int256) {
356     int256 b = int256(a);
357     require(b >= 0);
358     return b;
359   }
360 }
361 
362 
363 interface IUniswapV2Router01 {
364     function factory() external pure returns (address);
365     function WETH() external pure returns (address);
366 
367     function addLiquidity(
368         address tokenA,
369         address tokenB,
370         uint amountADesired,
371         uint amountBDesired,
372         uint amountAMin,
373         uint amountBMin,
374         address to,
375         uint deadline
376     ) external returns (uint amountA, uint amountB, uint liquidity);
377     function addLiquidityETH(
378         address token,
379         uint amountTokenDesired,
380         uint amountTokenMin,
381         uint amountETHMin,
382         address to,
383         uint deadline
384     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
385     function removeLiquidity(
386         address tokenA,
387         address tokenB,
388         uint liquidity,
389         uint amountAMin,
390         uint amountBMin,
391         address to,
392         uint deadline
393     ) external returns (uint amountA, uint amountB);
394     function removeLiquidityETH(
395         address token,
396         uint liquidity,
397         uint amountTokenMin,
398         uint amountETHMin,
399         address to,
400         uint deadline
401     ) external returns (uint amountToken, uint amountETH);
402     function removeLiquidityWithPermit(
403         address tokenA,
404         address tokenB,
405         uint liquidity,
406         uint amountAMin,
407         uint amountBMin,
408         address to,
409         uint deadline,
410         bool approveMax, uint8 v, bytes32 r, bytes32 s
411     ) external returns (uint amountA, uint amountB);
412     function removeLiquidityETHWithPermit(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline,
419         bool approveMax, uint8 v, bytes32 r, bytes32 s
420     ) external returns (uint amountToken, uint amountETH);
421     function swapExactTokensForTokens(
422         uint amountIn,
423         uint amountOutMin,
424         address[] calldata path,
425         address to,
426         uint deadline
427     ) external returns (uint[] memory amounts);
428     function swapTokensForExactTokens(
429         uint amountOut,
430         uint amountInMax,
431         address[] calldata path,
432         address to,
433         uint deadline
434     ) external returns (uint[] memory amounts);
435     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
436         external
437         payable
438         returns (uint[] memory amounts);
439     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
440         external
441         returns (uint[] memory amounts);
442     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
443         external
444         returns (uint[] memory amounts);
445     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
446         external
447         payable
448         returns (uint[] memory amounts);
449 
450     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
451     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
452     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
453     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
454     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
455 }
456 
457 interface IUniswapV2Router02 is IUniswapV2Router01 {
458     function removeLiquidityETHSupportingFeeOnTransferTokens(
459         address token,
460         uint liquidity,
461         uint amountTokenMin,
462         uint amountETHMin,
463         address to,
464         uint deadline
465     ) external returns (uint amountETH);
466     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
467         address token,
468         uint liquidity,
469         uint amountTokenMin,
470         uint amountETHMin,
471         address to,
472         uint deadline,
473         bool approveMax, uint8 v, bytes32 r, bytes32 s
474     ) external returns (uint amountETH);
475 
476     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
477         uint amountIn,
478         uint amountOutMin,
479         address[] calldata path,
480         address to,
481         uint deadline
482     ) external;
483     function swapExactETHForTokensSupportingFeeOnTransferTokens(
484         uint amountOutMin,
485         address[] calldata path,
486         address to,
487         uint deadline
488     ) external payable;
489     function swapExactTokensForETHSupportingFeeOnTransferTokens(
490         uint amountIn,
491         uint amountOutMin,
492         address[] calldata path,
493         address to,
494         uint deadline
495     ) external;
496 }
497 
498 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
499   using SafeMath for uint256;
500   using SafeMathUint for uint256;
501   using SafeMathInt for int256;
502 
503   uint256 constant internal magnitude = 2**128;
504 
505   mapping(address => uint256) internal magnifiedDividendPerShare;
506   address[] public rewardTokens;
507   address public nextRewardToken;
508   uint256 public rewardTokenCounter;
509   
510   IUniswapV2Router02 public immutable uniswapV2Router;
511   
512   
513   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
514   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
515   
516   mapping (address => uint256) public holderBalance;
517   uint256 public totalBalance;
518 
519   mapping(address => uint256) public totalDividendsDistributed;
520   
521   constructor(){
522       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
523       uniswapV2Router = _uniswapV2Router; 
524       
525       // Mainnet
526 
527       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
528       
529       nextRewardToken = rewardTokens[0];
530   }
531 
532   
533 
534   /// @dev Distributes dividends whenever ether is paid to this contract.
535   receive() external payable {
536     distributeDividends();
537   }
538     
539   function distributeDividends() public override payable { 
540     require(totalBalance > 0);
541     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
542     buyTokens(msg.value, nextRewardToken);
543     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
544     if (newBalance > 0) {
545       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
546         (newBalance).mul(magnitude) / totalBalance
547       );
548       emit DividendsDistributed(msg.sender, newBalance);
549 
550       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
551     }
552     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
553     nextRewardToken = rewardTokens[rewardTokenCounter];
554   }
555   
556   // Autopilot
557     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
558         // Autopilot
559         address[] memory path = new address[](2);
560         path[0] = uniswapV2Router.WETH();
561         path[1] = rewardToken;
562 
563         // Autopilot
564         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
565             0, // Autopilot
566             path,
567             address(this),
568             block.timestamp
569         );
570     }
571   
572   /// @notice Withdraws the ether distributed to the sender.
573   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
574   function withdrawDividend(address _rewardToken) external virtual override {
575     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
576   }
577 
578   /// @notice Withdraws the ether distributed to the sender.
579   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
580   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
581     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
582     if (_withdrawableDividend > 0) {
583       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
584       emit DividendWithdrawn(user, _withdrawableDividend);
585       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
586       return _withdrawableDividend;
587     }
588 
589     return 0;
590   }
591 
592 
593   /// @notice View the amount of dividend in wei that an address can withdraw.
594   /// @param _owner The address of a token holder.
595   /// @return The amount of dividend in wei that `_owner` can withdraw.
596   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
597     return withdrawableDividendOf(_owner, _rewardToken);
598   }
599 
600   /// @notice View the amount of dividend in wei that an address can withdraw.
601   /// @param _owner The address of a token holder.
602   /// @return The amount of dividend in wei that `_owner` can withdraw.
603   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
604     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
605   }
606 
607   /// @notice View the amount of dividend in wei that an address has withdrawn.
608   /// @param _owner The address of a token holder.
609   /// @return The amount of dividend in wei that `_owner` has withdrawn.
610   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
611     return withdrawnDividends[_owner][_rewardToken];
612   }
613 
614 
615   /// @notice View the amount of dividend in wei that an address has earned in total.
616   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
617   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
618   /// @param _owner The address of a token holder.
619   /// @return The amount of dividend in wei that `_owner` has earned in total.
620   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
621     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
622       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
623   }
624 
625   /// @dev Internal function that increases tokens to an account.
626   /// Update magnifiedDividendCorrections to keep dividends unchanged.
627   /// @param account The account that will receive the created tokens.
628   /// @param value The amount that will be created.
629   function _increase(address account, uint256 value) internal {
630     for (uint256 i; i < rewardTokens.length; i++){
631         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
632           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
633     }
634   }
635 
636   /// @dev Internal function that reduces an amount of the token of a given account.
637   /// Update magnifiedDividendCorrections to keep dividends unchanged.
638   /// @param account The account whose tokens will be burnt.
639   /// @param value The amount that will be burnt.
640   function _reduce(address account, uint256 value) internal {
641       for (uint256 i; i < rewardTokens.length; i++){
642         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
643           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
644       }
645   }
646 
647   function _setBalance(address account, uint256 newBalance) internal {
648     uint256 currentBalance = holderBalance[account];
649     holderBalance[account] = newBalance;
650     if(newBalance > currentBalance) {
651       uint256 increaseAmount = newBalance.sub(currentBalance);
652       _increase(account, increaseAmount);
653       totalBalance += increaseAmount;
654     } else if(newBalance < currentBalance) {
655       uint256 reduceAmount = currentBalance.sub(newBalance);
656       _reduce(account, reduceAmount);
657       totalBalance -= reduceAmount;
658     }
659   }
660 }
661 
662 contract DividendTracker is DividendPayingToken {
663     using SafeMath for uint256;
664     using SafeMathInt for int256;
665 
666     struct Map {
667         address[] keys;
668         mapping(address => uint) values;
669         mapping(address => uint) indexOf;
670         mapping(address => bool) inserted;
671     }
672 
673     function get(address key) private view returns (uint) {
674         return tokenHoldersMap.values[key];
675     }
676 
677     function getIndexOfKey(address key) private view returns (int) {
678         if(!tokenHoldersMap.inserted[key]) {
679             return -1;
680         }
681         return int(tokenHoldersMap.indexOf[key]);
682     }
683 
684     function getKeyAtIndex(uint index) private view returns (address) {
685         return tokenHoldersMap.keys[index];
686     }
687 
688 
689 
690     function size() private view returns (uint) {
691         return tokenHoldersMap.keys.length;
692     }
693 
694     function set(address key, uint val) private {
695         if (tokenHoldersMap.inserted[key]) {
696             tokenHoldersMap.values[key] = val;
697         } else {
698             tokenHoldersMap.inserted[key] = true;
699             tokenHoldersMap.values[key] = val;
700             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
701             tokenHoldersMap.keys.push(key);
702         }
703     }
704 
705     function remove(address key) private {
706         if (!tokenHoldersMap.inserted[key]) {
707             return;
708         }
709 
710         delete tokenHoldersMap.inserted[key];
711         delete tokenHoldersMap.values[key];
712 
713         uint index = tokenHoldersMap.indexOf[key];
714         uint lastIndex = tokenHoldersMap.keys.length - 1;
715         address lastKey = tokenHoldersMap.keys[lastIndex];
716 
717         tokenHoldersMap.indexOf[lastKey] = index;
718         delete tokenHoldersMap.indexOf[key];
719 
720         tokenHoldersMap.keys[index] = lastKey;
721         tokenHoldersMap.keys.pop();
722     }
723 
724     Map private tokenHoldersMap;
725     uint256 public lastProcessedIndex;
726 
727     mapping (address => bool) public excludedFromDividends;
728 
729     mapping (address => uint256) public lastClaimTimes;
730 
731     uint256 public claimWait;
732     uint256 public immutable minimumTokenBalanceForDividends;
733 
734     event ExcludeFromDividends(address indexed account);
735     event IncludeInDividends(address indexed account);
736     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
737 
738     event Claim(address indexed account, uint256 amount, bool indexed automatic);
739 
740     constructor() {
741     	claimWait = 1200;
742         minimumTokenBalanceForDividends = 1000 * (10**18);
743     }
744 
745     function excludeFromDividends(address account) external onlyOwner {
746     	excludedFromDividends[account] = true;
747 
748     	_setBalance(account, 0);
749     	remove(account);
750 
751     	emit ExcludeFromDividends(account);
752     }
753     
754     function includeInDividends(address account) external onlyOwner {
755     	require(excludedFromDividends[account]);
756     	excludedFromDividends[account] = false;
757 
758     	emit IncludeInDividends(account);
759     }
760 
761     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
762         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
763         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
764         emit ClaimWaitUpdated(newClaimWait, claimWait);
765         claimWait = newClaimWait;
766     }
767 
768     function getLastProcessedIndex() external view returns(uint256) {
769     	return lastProcessedIndex;
770     }
771 
772     function getNumberOfTokenHolders() external view returns(uint256) {
773         return tokenHoldersMap.keys.length;
774     }
775 
776     // Autopilot
777 
778     function getAccount(address _account, address _rewardToken)
779         public view returns (
780             address account,
781             int256 index,
782             int256 iterationsUntilProcessed,
783             uint256 withdrawableDividends,
784             uint256 totalDividends,
785             uint256 lastClaimTime,
786             uint256 nextClaimTime,
787             uint256 secondsUntilAutoClaimAvailable) {
788         account = _account;
789 
790         index = getIndexOfKey(account);
791 
792         iterationsUntilProcessed = -1;
793 
794         if(index >= 0) {
795             if(uint256(index) > lastProcessedIndex) {
796                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
797             }
798             else {
799                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
800                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
801                                                         0;
802 
803 
804                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
805             }
806         }
807 
808 
809         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
810         totalDividends = accumulativeDividendOf(account, _rewardToken);
811 
812         lastClaimTime = lastClaimTimes[account];
813 
814         nextClaimTime = lastClaimTime > 0 ?
815                                     lastClaimTime.add(claimWait) :
816                                     0;
817 
818         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
819                                                     nextClaimTime.sub(block.timestamp) :
820                                                     0;
821     }
822 
823     function getAccountAtIndex(uint256 index, address _rewardToken)
824         external view returns (
825             address,
826             int256,
827             int256,
828             uint256,
829             uint256,
830             uint256,
831             uint256,
832             uint256) {
833     	if(index >= size()) {
834             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
835         }
836 
837         address account = getKeyAtIndex(index);
838 
839         return getAccount(account, _rewardToken);
840     }
841 
842     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
843     	if(lastClaimTime > block.timestamp)  {
844     		return false;
845     	}
846 
847     	return block.timestamp.sub(lastClaimTime) >= claimWait;
848     }
849 
850     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
851     	if(excludedFromDividends[account]) {
852     		return;
853     	}
854 
855     	if(newBalance >= minimumTokenBalanceForDividends) {
856             _setBalance(account, newBalance);
857     		set(account, newBalance);
858     	}
859     	else {
860             _setBalance(account, 0);
861     		remove(account);
862     	}
863 
864     	processAccount(account, true);
865     }
866     
867     function process(uint256 gas) external returns (uint256, uint256, uint256) {
868     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
869 
870     	if(numberOfTokenHolders == 0) {
871     		return (0, 0, lastProcessedIndex);
872     	}
873 
874     	uint256 _lastProcessedIndex = lastProcessedIndex;
875 
876     	uint256 gasUsed = 0;
877 
878     	uint256 gasLeft = gasleft();
879 
880     	uint256 iterations = 0;
881     	uint256 claims = 0;
882 
883     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
884     		_lastProcessedIndex++;
885 
886     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
887     			_lastProcessedIndex = 0;
888     		}
889 
890     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
891 
892     		if(canAutoClaim(lastClaimTimes[account])) {
893     			if(processAccount(payable(account), true)) {
894     				claims++;
895     			}
896     		}
897 
898     		iterations++;
899 
900     		uint256 newGasLeft = gasleft();
901 
902     		if(gasLeft > newGasLeft) {
903     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
904     		}
905     		gasLeft = newGasLeft;
906     	}
907 
908     	lastProcessedIndex = _lastProcessedIndex;
909 
910     	return (iterations, claims, lastProcessedIndex);
911     }
912 
913     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
914         uint256 amount;
915         bool paid;
916         for (uint256 i; i < rewardTokens.length; i++){
917             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
918             if(amount > 0) {
919         		lastClaimTimes[account] = block.timestamp;
920                 emit Claim(account, amount, automatic);
921                 paid = true;
922     	    }
923         }
924         return paid;
925     }
926 }
927 
928 contract Autopilot is ERC20, Ownable {
929     using SafeMath for uint256;
930 
931     IUniswapV2Router02 public immutable uniswapV2Router;
932     address public immutable uniswapV2Pair;
933 
934     bool private swapping;
935 
936     DividendTracker public dividendTracker;
937 
938     address public operationsWallet;
939     
940     uint256 public maxTransactionAmount;
941     uint256 public swapTokensAtAmount;
942     uint256 public maxWallet;
943     
944     uint256 public liquidityActiveBlock = 0; 
945     uint256 public tradingActiveBlock = 0; 
946     uint256 public earlyBuyPenaltyEnd; 
947     
948     bool public limitsInEffect = true;
949     bool public tradingActive = false;
950     bool public swapEnabled = false;
951     
952     mapping(address => uint256) private _holderLastTransferTimestamp;
953     bool public transferDelayEnabled = true;
954     
955     uint256 public constant feeDivisor = 1000;
956 
957     uint256 public totalSellFees;
958     uint256 public rewardsSellFee;
959     uint256 public operationsSellFee;
960     uint256 public liquiditySellFee;
961     
962     uint256 public totalBuyFees;
963     uint256 public rewardsBuyFee;
964     uint256 public operationsBuyFee;
965     uint256 public liquidityBuyFee;
966     
967     uint256 public tokensForRewards;
968     uint256 public tokensForOperations;
969     uint256 public tokensForLiquidity;
970     
971     uint256 public gasForProcessing = 0;
972 
973     uint256 public lpWithdrawRequestTimestamp;
974     uint256 public lpWithdrawRequestDuration = 3 days;
975     bool public lpWithdrawRequestPending;
976     uint256 public lpPercToWithDraw;
977 
978     mapping (address => bool) private _isExcludedFromFees;
979 
980     mapping (address => bool) public _isExcludedMaxTransactionAmount;
981 
982     mapping (address => bool) public automatedMarketMakerPairs;
983 
984     event ExcludeFromFees(address indexed account, bool isExcluded);
985     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
986     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
987 
988     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
989 
990     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
991 
992     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
993 
994     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
995     
996     event SwapAndLiquify(
997         uint256 tokensSwapped,
998         uint256 ethReceived,
999         uint256 tokensIntoLiqudity
1000     );
1001 
1002     event SendDividends(
1003     	uint256 tokensSwapped,
1004     	uint256 amount
1005     );
1006 
1007     event ProcessedDividendTracker(
1008     	uint256 iterations,
1009     	uint256 claims,
1010         uint256 lastProcessedIndex,
1011     	bool indexed automatic,
1012     	uint256 gas,
1013     	address indexed processor
1014     );
1015 
1016     event RequestedLPWithdraw();
1017     
1018     event WithdrewLPForMigration();
1019 
1020     event CanceledLpWithdrawRequest();
1021 
1022     constructor() ERC20("Autopilot", "aPilot") {
1023 
1024         uint256 totalSupply = 1_000_000_000 * 1e18;
1025 
1026         maxTransactionAmount = 30_000_000 * 1e18;
1027         maxWallet = 30_000_000 * 1e18;
1028         swapTokensAtAmount = (totalSupply * 5) / 10000;
1029 
1030         rewardsBuyFee = 50;
1031         operationsBuyFee = 0;
1032         liquidityBuyFee = 0;
1033         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1034         
1035         rewardsSellFee = 50;
1036         operationsSellFee = 0;
1037         liquiditySellFee = 0;
1038         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1039 
1040     	dividendTracker = new DividendTracker();
1041     	
1042     	operationsWallet = address(msg.sender);
1043 
1044     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1045     	
1046         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1047             .createPair(address(this), _uniswapV2Router.WETH());
1048 
1049         uniswapV2Router = _uniswapV2Router;
1050         uniswapV2Pair = _uniswapV2Pair;
1051 
1052         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1053 
1054         dividendTracker.excludeFromDividends(address(dividendTracker));
1055         dividendTracker.excludeFromDividends(address(this));
1056         dividendTracker.excludeFromDividends(owner());
1057         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1058         dividendTracker.excludeFromDividends(address(0xdead));
1059         
1060         excludeFromFees(owner(), true);
1061         excludeFromFees(address(this), true);
1062         excludeFromFees(address(0xdead), true);
1063         excludeFromMaxTransaction(owner(), true);
1064         excludeFromMaxTransaction(address(this), true);
1065         excludeFromMaxTransaction(address(dividendTracker), true);
1066         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1067         excludeFromMaxTransaction(address(0xdead), true);
1068 
1069         _createInitialSupply(address(owner()), totalSupply);
1070     }
1071 
1072     receive() external payable {
1073 
1074   	}
1075 
1076     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1077         excludeFromFees(_presaleAddress, true);
1078         dividendTracker.excludeFromDividends(_presaleAddress);
1079         excludeFromMaxTransaction(_presaleAddress, true);
1080     }
1081 
1082     function disableTransferDelay() external onlyOwner returns (bool){
1083         transferDelayEnabled = false;
1084         return true;
1085     }
1086 
1087     // Autopilot
1088     function excludeFromDividends(address account) external onlyOwner {
1089         dividendTracker.excludeFromDividends(account);
1090     }
1091 
1092     // Autopilot
1093     function includeInDividends(address account) external onlyOwner {
1094         dividendTracker.includeInDividends(account);
1095     }
1096     
1097     // Autopilot
1098     function enableTrading() external onlyOwner {
1099         require(!tradingActive, "Cannot re-enable trading");
1100         tradingActive = true;
1101         swapEnabled = true;
1102         tradingActiveBlock = block.number;
1103     }
1104     
1105     // Autopilot
1106     function updateSwapEnabled(bool enabled) external onlyOwner(){
1107         swapEnabled = enabled;
1108     }
1109 
1110     function updateMaxAmount(uint256 newNum) external onlyOwner {
1111         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1112         maxTransactionAmount = newNum * (10**18);
1113     }
1114     
1115     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1116         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1117         maxWallet = newNum * (10**18);
1118     }
1119     
1120     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1121         operationsBuyFee = _operationsFee;
1122         rewardsBuyFee = _rewardsFee;
1123         liquidityBuyFee = _liquidityFee;
1124         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1125         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1126     }
1127     
1128     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1129         operationsSellFee = _operationsFee;
1130         rewardsSellFee = _rewardsFee;
1131         liquiditySellFee = _liquidityFee;
1132         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1133         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1134     }
1135 
1136     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1137         _isExcludedMaxTransactionAmount[updAds] = isEx;
1138         emit ExcludedMaxTransactionAmount(updAds, isEx);
1139     }
1140 
1141     function excludeFromFees(address account, bool excluded) public onlyOwner {
1142         _isExcludedFromFees[account] = excluded;
1143 
1144         emit ExcludeFromFees(account, excluded);
1145     }
1146 
1147     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1148         for(uint256 i = 0; i < accounts.length; i++) {
1149             _isExcludedFromFees[accounts[i]] = excluded;
1150         }
1151 
1152         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1153     }
1154 
1155     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1156         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1157 
1158         _setAutomatedMarketMakerPair(pair, value);
1159     }
1160 
1161     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1162         automatedMarketMakerPairs[pair] = value;
1163 
1164         excludeFromMaxTransaction(pair, value);
1165         
1166         if(value) {
1167             dividendTracker.excludeFromDividends(pair);
1168         }
1169 
1170         emit SetAutomatedMarketMakerPair(pair, value);
1171     }
1172 
1173     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1174         require(newOperationsWallet != address(0), "may not set to 0 address");
1175         excludeFromFees(newOperationsWallet, true);
1176         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1177         operationsWallet = newOperationsWallet;
1178     }
1179 
1180     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1181         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1182         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1183         emit GasForProcessingUpdated(newValue, gasForProcessing);
1184         gasForProcessing = newValue;
1185     }
1186 
1187     function updateClaimWait(uint256 claimWait) external onlyOwner {
1188         dividendTracker.updateClaimWait(claimWait);
1189     }
1190 
1191     function getClaimWait() external view returns(uint256) {
1192         return dividendTracker.claimWait();
1193     }
1194 
1195     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1196         return dividendTracker.totalDividendsDistributed(rewardToken);
1197     }
1198 
1199     function isExcludedFromFees(address account) external view returns(bool) {
1200         return _isExcludedFromFees[account];
1201     }
1202 
1203     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1204     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1205   	}
1206 
1207 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1208 		return dividendTracker.holderBalance(account);
1209 	}
1210 
1211     function getAccountDividendsInfo(address account, address rewardToken)
1212         external view returns (
1213             address,
1214             int256,
1215             int256,
1216             uint256,
1217             uint256,
1218             uint256,
1219             uint256,
1220             uint256) {
1221         return dividendTracker.getAccount(account, rewardToken);
1222     }
1223 
1224 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1225         external view returns (
1226             address,
1227             int256,
1228             int256,
1229             uint256,
1230             uint256,
1231             uint256,
1232             uint256,
1233             uint256) {
1234     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1235     }
1236 
1237 	function processDividendTracker(uint256 gas) external {
1238 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1239 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1240     }
1241 
1242     function claim() external {
1243 		dividendTracker.processAccount(payable(msg.sender), false);
1244     }
1245 
1246     function getLastProcessedIndex() external view returns(uint256) {
1247     	return dividendTracker.getLastProcessedIndex();
1248     }
1249 
1250     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1251         return dividendTracker.getNumberOfTokenHolders();
1252     }
1253     
1254     function getNumberOfDividends() external view returns(uint256) {
1255         return dividendTracker.totalBalance();
1256     }
1257     
1258     // Autopilot
1259     function removeLimits() external onlyOwner returns (bool){
1260         limitsInEffect = false;
1261         transferDelayEnabled = false;
1262         return true;
1263     }
1264     
1265     function _transfer(
1266         address from,
1267         address to,
1268         uint256 amount
1269     ) internal override {
1270         require(from != address(0), "ERC20: transfer from the zero address");
1271         require(to != address(0), "ERC20: transfer to the zero address");
1272         
1273          if(amount == 0) {
1274             super._transfer(from, to, 0);
1275             return;
1276         }
1277         
1278         if(!tradingActive){
1279             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1280         }
1281         
1282         if(limitsInEffect){
1283             if (
1284                 from != owner() &&
1285                 to != owner() &&
1286                 to != address(0) &&
1287                 to != address(0xdead) &&
1288                 !swapping
1289             ){
1290 
1291                 // Autopilot
1292                 if (transferDelayEnabled){
1293                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1294                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1295                         _holderLastTransferTimestamp[tx.origin] = block.number;
1296                     }
1297                 }
1298                 
1299                 // Autopilot
1300                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1301                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1302                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1303                 } 
1304                 // Autopilot
1305                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1306                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1307                 }
1308                 else if(!_isExcludedMaxTransactionAmount[to]) {
1309                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1310                 }
1311             }
1312         }
1313 
1314 		uint256 contractTokenBalance = balanceOf(address(this));
1315         
1316         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1317 
1318         if( 
1319             canSwap &&
1320             swapEnabled &&
1321             !swapping &&
1322             !automatedMarketMakerPairs[from] &&
1323             !_isExcludedFromFees[from] &&
1324             !_isExcludedFromFees[to]
1325         ) {
1326             swapping = true;
1327             swapBack();
1328             swapping = false;
1329         }
1330 
1331         bool takeFee = !swapping;
1332 
1333         // Autopilot
1334         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1335             takeFee = false;
1336         }
1337         
1338         uint256 fees = 0;
1339         
1340         // Autopilot
1341         if(takeFee){
1342             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1343                 fees = amount.mul(99).div(100);
1344                 tokensForLiquidity += fees * 33 / 99;
1345                 tokensForRewards += fees * 33 / 99;
1346                 tokensForOperations += fees * 33 / 99;
1347             }
1348 
1349             // Autopilot
1350             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1351                 fees = amount.mul(totalSellFees).div(feeDivisor);
1352                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1353                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1354                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1355             }
1356             
1357             // Autopilot
1358             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1359         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1360         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1361                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1362                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1363             }
1364 
1365             if(fees > 0){    
1366                 super._transfer(from, address(this), fees);
1367             }
1368         	
1369         	amount -= fees;
1370         }
1371 
1372         super._transfer(from, to, amount);
1373 
1374         dividendTracker.setBalance(payable(from), balanceOf(from));
1375         dividendTracker.setBalance(payable(to), balanceOf(to));
1376 
1377         if(!swapping && gasForProcessing > 0) {
1378 	    	uint256 gas = gasForProcessing;
1379 
1380 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1381 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1382 	    	}
1383 	    	catch {}
1384         }
1385     }
1386     
1387     function swapTokensForEth(uint256 tokenAmount) private {
1388 
1389         // Autopilot
1390         address[] memory path = new address[](2);
1391         path[0] = address(this);
1392         path[1] = uniswapV2Router.WETH();
1393 
1394         _approve(address(this), address(uniswapV2Router), tokenAmount);
1395 
1396         // Autopilot
1397         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1398             tokenAmount,
1399             0, // Autopilot
1400             path,
1401             address(this),
1402             block.timestamp
1403         );
1404         
1405     }
1406     
1407     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1408         // Autopilot
1409         _approve(address(this), address(uniswapV2Router), tokenAmount);
1410 
1411         // Autopilot
1412         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1413             address(this),
1414             tokenAmount,
1415             0, // Autopilot
1416             0, // Autopilot
1417             address(0xdead),
1418             block.timestamp
1419         );
1420 
1421     }
1422     
1423     function swapBack() private {
1424         uint256 contractBalance = balanceOf(address(this));
1425         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1426         
1427         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1428         
1429         // Autopilot
1430         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1431         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1432         
1433         uint256 initialETHBalance = address(this).balance;
1434 
1435         swapTokensForEth(amountToSwapForETH); 
1436         
1437         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1438         
1439         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1440         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1441         
1442         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1443         
1444         tokensForLiquidity = 0;
1445         tokensForOperations = 0;
1446         tokensForRewards = 0;
1447         
1448         
1449         
1450         if(liquidityTokens > 0 && ethForLiquidity > 0){
1451             addLiquidity(liquidityTokens, ethForLiquidity);
1452             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1453         }
1454         
1455         // Autopilot
1456         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1457 
1458         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1459     }
1460 
1461     function withdrawStuckEth() external onlyOwner {
1462         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1463         require(success, "failed to withdraw");
1464     }
1465 
1466     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1467         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1468         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1469         lpWithdrawRequestTimestamp = block.timestamp;
1470         lpWithdrawRequestPending = true;
1471         lpPercToWithDraw = percToWithdraw;
1472         emit RequestedLPWithdraw();
1473     }
1474 
1475     function nextAvailableLpWithdrawDate() public view returns (uint256){
1476         if(lpWithdrawRequestPending){
1477             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1478         }
1479         else {
1480             return 0;  // Autopilot
1481         }
1482     }
1483 
1484     function withdrawRequestedLP() external onlyOwner {
1485         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1486         lpWithdrawRequestTimestamp = 0;
1487         lpWithdrawRequestPending = false;
1488 
1489         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1490         
1491         lpPercToWithDraw = 0;
1492 
1493         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1494     }
1495 
1496     function cancelLPWithdrawRequest() external onlyOwner {
1497         lpWithdrawRequestPending = false;
1498         lpPercToWithDraw = 0;
1499         lpWithdrawRequestTimestamp = 0;
1500         emit CanceledLpWithdrawRequest();
1501     }
1502 }