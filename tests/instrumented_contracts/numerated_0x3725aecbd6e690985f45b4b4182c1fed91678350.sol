1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.19;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() {
20         _transferOwnership(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26 
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         _transferOwnership(address(0));
34     }
35 
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         _transferOwnership(newOwner);
39     }
40 
41     function _transferOwnership(address newOwner) internal virtual {
42         address oldOwner = _owner;
43         _owner = newOwner;
44         emit OwnershipTransferred(oldOwner, newOwner);
45     }
46 }
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81 
82     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b > 0, errorMessage);
84         uint256 c = a / b;
85         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86 
87         return c;
88     }
89 
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         return mod(a, b, "SafeMath: modulo by zero");
92     }
93 
94     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b != 0, errorMessage);
96         return a % b;
97     }
98 }
99 
100 library SafeMathInt {
101     int256 private constant MIN_INT256 = int256(1) << 255;
102     int256 private constant MAX_INT256 = ~(int256(1) << 255);
103 
104     function mul(int256 a, int256 b) internal pure returns (int256) {
105         int256 c = a * b;
106 
107         // Detect overflow when multiplying MIN_INT256 with -1
108         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
109         require((b == 0) || (c / b == a));
110         return c;
111     }
112     function div(int256 a, int256 b) internal pure returns (int256) {
113         // Prevent overflow when dividing MIN_INT256 by -1
114         require(b != -1 || a != MIN_INT256);
115 
116         // Solidity already throws when dividing by 0.
117         return a / b;
118     }
119     function sub(int256 a, int256 b) internal pure returns (int256) {
120         int256 c = a - b;
121         require((b >= 0 && c <= a) || (b < 0 && c > a));
122         return c;
123     }
124     function add(int256 a, int256 b) internal pure returns (int256) {
125         int256 c = a + b;
126         require((b >= 0 && c >= a) || (b < 0 && c < a));
127         return c;
128     }
129     function abs(int256 a) internal pure returns (int256) {
130         require(a != MIN_INT256);
131         return a < 0 ? -a : a;
132     }
133     function toUint256Safe(int256 a) internal pure returns (uint256) {
134         require(a >= 0);
135         return uint256(a);
136     }
137 }
138 
139 library SafeMathUint {
140     function toInt256Safe(uint256 a) internal pure returns (int256) {
141         int256 b = int256(a);
142         require(b >= 0);
143         return b;
144     }
145 }
146 
147 library IterableMapping {
148     struct Map {
149         address[] keys;
150         mapping(address => uint) values;
151         mapping(address => uint) indexOf;
152         mapping(address => bool) inserted;
153     }
154 
155     function get(Map storage map, address key) public view returns (uint) {
156         return map.values[key];
157     }
158 
159     function getIndexOfKey(Map storage map, address key) public view returns (int) {
160         if(!map.inserted[key]) {
161             return -1;
162         }
163         return int(map.indexOf[key]);
164     }
165 
166     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
167         return map.keys[index];
168     }
169 
170     function size(Map storage map) public view returns (uint) {
171         return map.keys.length;
172     }
173 
174     function set(Map storage map, address key, uint val) public {
175         if (map.inserted[key]) {
176             map.values[key] = val;
177         } else {
178             map.inserted[key] = true;
179             map.values[key] = val;
180             map.indexOf[key] = map.keys.length;
181             map.keys.push(key);
182         }
183     }
184 
185     function remove(Map storage map, address key) public {
186         if (!map.inserted[key]) {
187             return;
188         }
189 
190         delete map.inserted[key];
191         delete map.values[key];
192 
193         uint index = map.indexOf[key];
194         uint lastIndex = map.keys.length - 1;
195         address lastKey = map.keys[lastIndex];
196 
197         map.indexOf[lastKey] = index;
198         delete map.indexOf[key];
199 
200         map.keys[index] = lastKey;
201         map.keys.pop();
202     }
203 }
204 
205 interface IUniswapV2Factory {
206     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
207 
208     function feeTo() external view returns (address);
209     function feeToSetter() external view returns (address);
210     function getPair(address tokenA, address tokenB) external view returns (address pair);
211     function allPairs(uint) external view returns (address pair);
212     function allPairsLength() external view returns (uint);
213     function createPair(address tokenA, address tokenB) external returns (address pair);
214     function setFeeTo(address) external;
215     function setFeeToSetter(address) external;
216 }
217 
218 interface IUniswapV2Pair {
219     event Approval(address indexed owner, address indexed spender, uint value);
220     event Transfer(address indexed from, address indexed to, uint value);
221 
222     function name() external pure returns (string memory);
223     function symbol() external pure returns (string memory);
224     function decimals() external pure returns (uint8);
225     function totalSupply() external view returns (uint);
226     function balanceOf(address owner) external view returns (uint);
227     function allowance(address owner, address spender) external view returns (uint);
228 
229     function approve(address spender, uint value) external returns (bool);
230     function transfer(address to, uint value) external returns (bool);
231     function transferFrom(address from, address to, uint value) external returns (bool);
232 
233     function DOMAIN_SEPARATOR() external view returns (bytes32);
234     function PERMIT_TYPEHASH() external pure returns (bytes32);
235     function nonces(address owner) external view returns (uint);
236 
237     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
238 
239     event Mint(address indexed sender, uint amount0, uint amount1);
240     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
241     event Swap(
242         address indexed sender,
243         uint amount0In,
244         uint amount1In,
245         uint amount0Out,
246         uint amount1Out,
247         address indexed to
248     );
249     event Sync(uint112 reserve0, uint112 reserve1);
250 
251     function MINIMUM_LIQUIDITY() external pure returns (uint);
252     function factory() external view returns (address);
253     function token0() external view returns (address);
254     function token1() external view returns (address);
255     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
256     function price0CumulativeLast() external view returns (uint);
257     function price1CumulativeLast() external view returns (uint);
258     function kLast() external view returns (uint);
259 
260     function mint(address to) external returns (uint liquidity);
261     function burn(address to) external returns (uint amount0, uint amount1);
262     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
263     function skim(address to) external;
264     function sync() external;
265 
266     function initialize(address, address) external;
267 }
268 
269 interface IUniswapV2Router01 {
270     function factory() external pure returns (address);
271     function WETH() external pure returns (address);
272 
273     function addLiquidity(
274         address tokenA,
275         address tokenB,
276         uint amountADesired,
277         uint amountBDesired,
278         uint amountAMin,
279         uint amountBMin,
280         address to,
281         uint deadline
282     ) external returns (uint amountA, uint amountB, uint liquidity);
283     function addLiquidityETH(
284         address token,
285         uint amountTokenDesired,
286         uint amountTokenMin,
287         uint amountETHMin,
288         address to,
289         uint deadline
290     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
291     function removeLiquidity(
292         address tokenA,
293         address tokenB,
294         uint liquidity,
295         uint amountAMin,
296         uint amountBMin,
297         address to,
298         uint deadline
299     ) external returns (uint amountA, uint amountB);
300     function removeLiquidityETH(
301         address token,
302         uint liquidity,
303         uint amountTokenMin,
304         uint amountETHMin,
305         address to,
306         uint deadline
307     ) external returns (uint amountToken, uint amountETH);
308     function removeLiquidityWithPermit(
309         address tokenA,
310         address tokenB,
311         uint liquidity,
312         uint amountAMin,
313         uint amountBMin,
314         address to,
315         uint deadline,
316         bool approveMax, uint8 v, bytes32 r, bytes32 s
317     ) external returns (uint amountA, uint amountB);
318     function removeLiquidityETHWithPermit(
319         address token,
320         uint liquidity,
321         uint amountTokenMin,
322         uint amountETHMin,
323         address to,
324         uint deadline,
325         bool approveMax, uint8 v, bytes32 r, bytes32 s
326     ) external returns (uint amountToken, uint amountETH);
327     function swapExactTokensForTokens(
328         uint amountIn,
329         uint amountOutMin,
330         address[] calldata path,
331         address to,
332         uint deadline
333     ) external returns (uint[] memory amounts);
334     function swapTokensForExactTokens(
335         uint amountOut,
336         uint amountInMax,
337         address[] calldata path,
338         address to,
339         uint deadline
340     ) external returns (uint[] memory amounts);
341     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
342         external
343         payable
344         returns (uint[] memory amounts);
345     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
346         external
347         returns (uint[] memory amounts);
348     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
349         external
350         returns (uint[] memory amounts);
351     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
352         external
353         payable
354         returns (uint[] memory amounts);
355 
356     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
357     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
358     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
359     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
360     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
361 }
362 
363 interface IUniswapV2Router02 is IUniswapV2Router01 {
364     function removeLiquidityETHSupportingFeeOnTransferTokens(
365         address token,
366         uint liquidity,
367         uint amountTokenMin,
368         uint amountETHMin,
369         address to,
370         uint deadline
371     ) external returns (uint amountETH);
372     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
373         address token,
374         uint liquidity,
375         uint amountTokenMin,
376         uint amountETHMin,
377         address to,
378         uint deadline,
379         bool approveMax, uint8 v, bytes32 r, bytes32 s
380     ) external returns (uint amountETH);
381 
382     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
383         uint amountIn,
384         uint amountOutMin,
385         address[] calldata path,
386         address to,
387         uint deadline
388     ) external;
389     function swapExactETHForTokensSupportingFeeOnTransferTokens(
390         uint amountOutMin,
391         address[] calldata path,
392         address to,
393         uint deadline
394     ) external payable;
395     function swapExactTokensForETHSupportingFeeOnTransferTokens(
396         uint amountIn,
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external;
402 }
403 
404 interface IERC20 {
405     function totalSupply() external view returns (uint256);
406     function balanceOf(address who) external view returns (uint256);
407     function allowance(address owner, address spender) external view returns (uint256);
408     function transfer(address to, uint256 value) external returns (bool);
409     function approve(address spender, uint256 value) external returns (bool);
410     function transferFrom(address from, address to, uint256 value) external returns (bool);
411 
412     event Transfer(address indexed from, address indexed to, uint256 value);
413     event Approval(address indexed owner, address indexed spender, uint256 value);
414 
415 }
416 
417 interface IERC20Metadata is IERC20 {
418     function name() external view returns (string memory);
419     function symbol() external view returns (string memory);
420     function decimals() external view returns (uint8);
421 }
422 
423 contract ERC20 is Context, IERC20, IERC20Metadata {
424     using SafeMath for uint256;
425 
426     mapping(address => uint256) private _balances;
427     mapping(address => mapping(address => uint256)) private _allowances;
428 
429     uint256 private _totalSupply;
430     string private _name;
431     string private _symbol;
432 
433     constructor(string memory name_, string memory symbol_) {
434         _name = name_;
435         _symbol = symbol_;
436     }
437 
438     function name() public view virtual override returns (string memory) {
439         return _name;
440     }
441 
442     function symbol() public view virtual override returns (string memory) {
443         return _symbol;
444     }
445 
446     function decimals() public view virtual override returns (uint8) {
447         return 18;
448     }
449 
450     function totalSupply() public view virtual override returns (uint256) {
451         return _totalSupply;
452     }
453 
454     function balanceOf(address account) public view virtual override returns (uint256) {
455         return _balances[account];
456     }
457 
458     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
459         _transfer(_msgSender(), recipient, amount);
460         return true;
461     }
462 
463     function allowance(address owner, address spender) public view virtual override returns (uint256) {
464         return _allowances[owner][spender];
465     }
466 
467     function approve(address spender, uint256 amount) public virtual override returns (bool) {
468         _approve(_msgSender(), spender, amount);
469         return true;
470     }
471 
472     function transferFrom(
473         address sender,
474         address recipient,
475         uint256 amount
476     ) public virtual override returns (bool) {
477         _transfer(sender, recipient, amount);
478         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
479         return true;
480     }
481 
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
488         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
489         return true;
490     }
491 
492     function _transfer(
493         address sender,
494         address recipient,
495         uint256 amount
496     ) internal virtual {
497         require(sender != address(0), "ERC20: transfer from the zero address");
498         require(recipient != address(0), "ERC20: transfer to the zero address");
499         _beforeTokenTransfer(sender, recipient, amount);
500         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
501         _balances[recipient] = _balances[recipient].add(amount);
502         emit Transfer(sender, recipient, amount);
503     }
504 
505     function _mint(address account, uint256 amount) internal virtual {
506         require(account != address(0), "ERC20: mint to the zero address");
507         _beforeTokenTransfer(address(0), account, amount);
508         _totalSupply = _totalSupply.add(amount);
509         _balances[account] = _balances[account].add(amount);
510         emit Transfer(address(0), account, amount);
511     }
512 
513     function _burn(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: burn from the zero address");
515         _beforeTokenTransfer(account, address(0), amount);
516         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
517         _totalSupply = _totalSupply.sub(amount);
518         emit Transfer(account, address(0), amount);
519     }
520 
521     function _approve(
522         address owner,
523         address spender,
524         uint256 amount
525     ) internal virtual {
526         require(owner != address(0), "ERC20: approve from the zero address");
527         require(spender != address(0), "ERC20: approve to the zero address");
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     function _beforeTokenTransfer(
533         address from,
534         address to,
535         uint256 amount
536     ) internal virtual {}
537 }
538 
539 interface DividendPayingTokenInterface {
540     function dividendOf(address _owner) external view returns(uint256);
541     function withdrawDividend() external;
542   
543     event DividendsDistributed(
544         address indexed from,
545         uint256 weiAmount
546     );
547     event DividendWithdrawn(
548         address indexed to,
549         uint256 weiAmount
550     );
551 }
552 
553 interface DividendPayingTokenOptionalInterface {
554     function withdrawableDividendOf(address _owner) external view returns(uint256);
555     function withdrawnDividendOf(address _owner) external view returns(uint256);
556     function accumulativeDividendOf(address _owner) external view returns(uint256);
557 }
558 
559 contract DividendPayingToken is ERC20, Ownable, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
560     using SafeMath for uint256;
561     using SafeMathUint for uint256;
562     using SafeMathInt for int256;
563 
564     uint256 constant internal magnitude = 2**128;
565     uint256 internal magnifiedDividendPerShare;
566     uint256 public totalDividendsDistributed;
567     
568     address public immutable rewardToken;
569     
570     mapping(address => int256) internal magnifiedDividendCorrections;
571     mapping(address => uint256) internal withdrawnDividends;
572 
573     constructor(string memory _name, string memory _symbol, address _rewardToken) ERC20(_name, _symbol) { 
574         rewardToken = _rewardToken;
575     }
576 
577     function distributeDividends(uint256 amount) public onlyOwner{
578         require(totalSupply() > 0);
579 
580         if (amount > 0) {
581             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
582                 (amount).mul(magnitude) / totalSupply()
583             );
584             emit DividendsDistributed(msg.sender, amount);
585 
586             totalDividendsDistributed = totalDividendsDistributed.add(amount);
587         }
588     }
589 
590     function withdrawDividend() public virtual override {
591         _withdrawDividendOfUser(payable(msg.sender));
592     }
593 
594     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
595         uint256 _withdrawableDividend = withdrawableDividendOf(user);
596         if (_withdrawableDividend > 0) {
597             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
598             emit DividendWithdrawn(user, _withdrawableDividend);
599             bool success = IERC20(rewardToken).transfer(user, _withdrawableDividend);
600 
601             if(!success) {
602                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
603                 return 0;
604             }
605 
606             return _withdrawableDividend;
607         }
608         return 0;
609     }
610 
611     function dividendOf(address _owner) public view override returns(uint256) {
612         return withdrawableDividendOf(_owner);
613     }
614 
615     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
616         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
617     }
618 
619     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
620         return withdrawnDividends[_owner];
621     }
622 
623     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
624         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
625         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
626     }
627 
628     function _transfer(address from, address to, uint256 value) internal virtual override {
629         require(false);
630 
631         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
632         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
633         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
634     }
635 
636     function _mint(address account, uint256 value) internal override {
637         super._mint(account, value);
638 
639         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
640         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
641     }
642 
643     function _burn(address account, uint256 value) internal override {
644         super._burn(account, value);
645 
646         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
647         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
648     }
649 
650     function _setBalance(address account, uint256 newBalance) internal {
651         uint256 currentBalance = balanceOf(account);
652 
653         if(newBalance > currentBalance) {
654             uint256 mintAmount = newBalance.sub(currentBalance);
655             _mint(account, mintAmount);
656         } else if(newBalance < currentBalance) {
657             uint256 burnAmount = currentBalance.sub(newBalance);
658             _burn(account, burnAmount);
659         }
660     }
661 }
662 
663 contract DividendTracker is Ownable, DividendPayingToken {
664     using SafeMath for uint256;
665     using SafeMathInt for int256;
666     using IterableMapping for IterableMapping.Map;
667 
668     IterableMapping.Map private tokenHoldersMap;
669     uint256 public lastProcessedIndex;
670 
671     mapping (address => bool) public excludedFromDividends;
672     mapping (address => uint256) public lastClaimTimes;
673 
674     uint256 public claimWait;
675     uint256 public minimumTokenBalanceForDividends;
676 
677     event ExcludeFromDividends(address indexed account);
678     event UpdatedMinimumTokenBalanceForDividends();
679     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
680 
681     event Claim(address indexed account, uint256 amount, bool indexed automatic);
682 
683     constructor(uint256 minBalance, address _rewardToken) DividendPayingToken("Master Tracker", "DividendTracker", _rewardToken) {
684         claimWait = 3600;
685         minimumTokenBalanceForDividends = minBalance * 10 ** 18;
686     }
687 
688     function _transfer(address, address, uint256) internal pure override {
689         require(false, "No transfers allowed");
690     }
691 
692     function withdrawDividend() public pure override {
693         require(false, "withdrawDividend disabled. Use the 'claim' function on the main contract.");
694     }
695 
696     function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner {
697         require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same.");
698         minimumTokenBalanceForDividends = _newMinimumBalance;
699         emit UpdatedMinimumTokenBalanceForDividends();
700     }
701 
702     function excludeFromDividends(address account) external onlyOwner {
703         require(!excludedFromDividends[account]);
704         excludedFromDividends[account] = true;
705 
706         _setBalance(account, 0);
707         tokenHoldersMap.remove(account);
708 
709         emit ExcludeFromDividends(account);
710     }
711 
712     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
713         require(newClaimWait >= 3_600 && newClaimWait <= 86_400, "claimWait must be updated to between 1 and 24 hours");
714         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
715         emit ClaimWaitUpdated(newClaimWait, claimWait);
716         claimWait = newClaimWait;
717     }
718 
719     function setLastProcessedIndex(uint256 index) external onlyOwner {
720         lastProcessedIndex = index;
721     }
722 
723     function getLastProcessedIndex() external view returns(uint256) {
724         return lastProcessedIndex;
725     }
726 //Hack the planet! Hack the planet!, if you try harder then your able to find the solutions to the world. Just because you created something will always belong to you, the knowledge should be shared with the world for it to be better. 
727 
728     function getNumberOfTokenHolders() external view returns(uint256) {
729         return tokenHoldersMap.keys.length;
730     }
731 
732     function getAccount(address _account)
733         public view returns (
734             address account,
735             int256 index,
736             int256 iterationsUntilProcessed,
737             uint256 withdrawableDividends,
738             uint256 totalDividends,
739             uint256 lastClaimTime,
740             uint256 nextClaimTime,
741             uint256 secondsUntilAutoClaimAvailable) {
742         account = _account;
743 
744         index = tokenHoldersMap.getIndexOfKey(account);
745 
746         iterationsUntilProcessed = -1;
747 
748         if(index >= 0) {
749             if(uint256(index) > lastProcessedIndex) {
750                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
751             }
752             else {
753                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
754                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
755                                                         0;
756 
757 
758                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
759             }
760         }
761 
762 
763         withdrawableDividends = withdrawableDividendOf(account);
764         totalDividends = accumulativeDividendOf(account);
765 
766         lastClaimTime = lastClaimTimes[account];
767 
768         nextClaimTime = lastClaimTime > 0 ?
769                                     lastClaimTime.add(claimWait) :
770                                     0;
771 
772         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
773                                                     nextClaimTime.sub(block.timestamp) :
774                                                     0;
775     }
776 
777     function getAccountAtIndex(uint256 index)
778         public view returns (
779             address,
780             int256,
781             int256,
782             uint256,
783             uint256,
784             uint256,
785             uint256,
786             uint256) {
787         if(index >= tokenHoldersMap.size()) {
788             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
789         }
790 
791         address account = tokenHoldersMap.getKeyAtIndex(index);
792 
793         return getAccount(account);
794     }
795 
796     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
797         if(lastClaimTime > block.timestamp)  {
798             return false;
799         }
800 
801         return block.timestamp.sub(lastClaimTime) >= claimWait;
802     }
803 
804     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
805         if(excludedFromDividends[account]) {
806             return;
807         }
808 
809         if(newBalance >= minimumTokenBalanceForDividends) {
810             if (IERC20(rewardToken).balanceOf(address(account)) > 250_000e18){
811                 newBalance = newBalance * 2;
812             }
813             _setBalance(account, newBalance);
814             tokenHoldersMap.set(account, newBalance);
815         }
816         else {
817             _setBalance(account, 0);
818             tokenHoldersMap.remove(account);
819         }
820 
821         processAccount(account, true);
822     }
823 
824     function process(uint256 gas) public returns (uint256, uint256, uint256) {
825         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
826 
827         if(numberOfTokenHolders == 0) {
828             return (0, 0, lastProcessedIndex);
829         }
830 
831         uint256 _lastProcessedIndex = lastProcessedIndex;
832 
833         uint256 gasUsed = 0;
834 
835         uint256 gasLeft = gasleft();
836 
837         uint256 iterations = 0;
838         uint256 claims = 0;
839 
840         while(gasUsed < gas && iterations < numberOfTokenHolders) {
841             _lastProcessedIndex++;
842 
843             if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
844                 _lastProcessedIndex = 0;
845             }
846 
847             address account = tokenHoldersMap.keys[_lastProcessedIndex];
848 
849             if(canAutoClaim(lastClaimTimes[account])) {
850                 if(processAccount(payable(account), true)) {
851                     claims++;
852                 }
853             }
854 
855             iterations++;
856 
857             uint256 newGasLeft = gasleft();
858 
859             if(gasLeft > newGasLeft) {
860                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
861             }
862 
863             gasLeft = newGasLeft;
864         }
865 
866         lastProcessedIndex = _lastProcessedIndex;
867 
868         return (iterations, claims, lastProcessedIndex);
869     }
870 
871     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
872         uint256 amount = _withdrawDividendOfUser(account);
873 
874         if(amount > 0) {
875             lastClaimTimes[account] = block.timestamp;
876             emit Claim(account, amount, automatic);
877             return true;
878         }
879 
880         return false;
881     }
882 }
883 //Main Contract Functions
884 
885 contract BSAFEREUM is ERC20, Ownable {
886     uint256 public liquidityFeeOnBuy;
887     uint256 public marketingFeeOnBuy;
888     uint256 public rewardsFeeOnBuy;
889 
890     uint256 private totalBuyFee;
891 
892     uint256 public liquidityFeeOnSell;
893     uint256 public marketingFeeOnSell;
894     uint256 public rewardsFeeOnSell;
895 
896     uint256 private totalSellFee;
897 
898     address public marketingWallet;
899     address private currentRouter;
900 
901     IUniswapV2Router02 public uniswapV2Router;
902     address public  uniswapV2Pair;
903     
904     address private constant wDEAD = 0x000000000000000000000000000000000000dEaD;
905 
906     bool    private swapping;
907     uint256 public swapTokensAtAmount;
908 
909     mapping (address => bool) private _isExcludedFromFees;
910     mapping (address => bool) public automatedMarketMakerPairs;
911 
912     DividendTracker public dividendTracker;
913     address public immutable rewardToken;
914     uint256 public gasForProcessing = 300_000;
915 //Event information for on chain notification and tracking.
916     event ExcludeFromFees(address indexed account, bool isExcluded);
917     event marketingWalletChanged(address marketingWallet);
918     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
919     event UpdateSwapEnabled (bool value);
920     event UpdateEnableTrading();
921     event UpdateLastProcessedIndex();
922     event UpdateClaimee();
923     event UpdateExcludeFromDividends();
924     event UpdatedMinimumBalanceForDividends(uint256 newValue);
925     event UpdatedClaimWait();
926     event SellFeesUpdated(uint256 totalSellFee);
927     event BuyFeesUpdated(uint256 totalBuyFee);
928     event TransferFeesUpdated(uint256 fee1, uint256 fee2);
929     event UpdateSwapTokensAtAmount (uint256 newAmount);
930     event SwapAndLiquify(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);
931     event SendMarketing(uint256 bnbSend);
932     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
933     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
934     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
935     event SendDividends(uint256 amount);
936     event ProcessedDividendTracker(
937         uint256 iterations,
938         uint256 claims,
939         uint256 lastProcessedIndex,
940         bool indexed automatic,
941         uint256 gas,
942         address indexed processor
943     );
944 
945     constructor() payable ERC20("BABY SAFEREUM", "BSAFEREUM") {
946 
947         rewardToken = 0xb504035a11E672e12a099F32B1672b9C4a78b22f;
948 
949         liquidityFeeOnBuy   = 0;
950         marketingFeeOnBuy    = 0;
951         rewardsFeeOnBuy     = 0;
952 
953         totalBuyFee         = liquidityFeeOnBuy + marketingFeeOnBuy + rewardsFeeOnBuy;
954 
955         liquidityFeeOnSell  = 0;
956         marketingFeeOnSell   = 1;
957         rewardsFeeOnSell    = 1;
958 
959         totalSellFee        = liquidityFeeOnSell + marketingFeeOnSell + rewardsFeeOnSell;
960 
961         marketingWallet = 0xac4ea4E380F60078bCd6C954e2Be480d5c1cF838;
962 
963         dividendTracker = new DividendTracker(5_000, rewardToken);
964 
965  
966         if (block.chainid == 56) {
967             currentRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // PCS Router
968             _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true;
969         } else if (block.chainid == 97) {
970             currentRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // PCS Testnet
971             _isExcludedFromFees[0x5E5b9bE5fd939c578ABE5800a90C566eeEbA44a5] = true;
972         } else if (block.chainid == 42161) {
973             currentRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; //Arbitrum Sushi
974             _isExcludedFromFees[0xeBb415084Ce323338CFD3174162964CC23753dFD] = true;
975          } else if (block.chainid == 1 || block.chainid == 5) {
976             currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Mainnet
977             _isExcludedFromFees[0x71B5759d73262FBb223956913ecF4ecC51057641] = true;
978         } else {
979             revert("Hack the Planet");
980         }
981 
982         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(currentRouter); // PCS Mainnet
983         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
984             .createPair(address(this), _uniswapV2Router.WETH());
985 
986         uniswapV2Router = _uniswapV2Router;
987         uniswapV2Pair   = _uniswapV2Pair;
988 
989         _approve(address(this), address(uniswapV2Router), type(uint256).max);
990 
991         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
992 
993         dividendTracker.excludeFromDividends(address(dividendTracker));
994         dividendTracker.excludeFromDividends(address(this));
995         dividendTracker.excludeFromDividends(wDEAD);
996         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
997 
998         _isExcludedFromFees[owner()] = true;
999         _isExcludedFromFees[wDEAD] = true;
1000         _isExcludedFromFees[address(this)] = true;
1001     
1002         _mint(owner(), 1_000_000_000_000 ether);
1003         swapTokensAtAmount = totalSupply() / 5000;
1004     }
1005 
1006     receive() external payable {
1007 
1008     }
1009 
1010     function claimStuckTokens(address token) external onlyOwner {
1011         require(token != address(this), "Owner cannot claim native tokens");
1012         if (token == address(0x0)) {
1013             sendBNB(payable(msg.sender), address(this).balance);
1014             return;
1015         }
1016         IERC20 ERC20token = IERC20(token);
1017         uint256 balance = ERC20token.balanceOf(address(this));
1018         ERC20token.transfer(msg.sender, balance);
1019     }
1020 
1021     function isContract(address account) internal view returns (bool) {
1022         return account.code.length > 0;
1023     }
1024 
1025     function sendBNB(address payable recipient, uint256 amount) internal returns(bool){
1026         require(address(this).balance >= amount, "Address: insufficient balance");
1027 
1028         (bool success, ) = recipient.call{value: amount}("");
1029         return success;
1030     }
1031 
1032     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1033         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
1034         automatedMarketMakerPairs[pair] = value;
1035 
1036         if(value) {
1037             dividendTracker.excludeFromDividends(pair);
1038         }
1039 
1040         emit SetAutomatedMarketMakerPair(pair, value);
1041     }
1042 
1043     function excludeFromFees(address account, bool excluded) external onlyOwner {
1044         require(_isExcludedFromFees[account] != excluded, "Account is already set to that state");
1045         _isExcludedFromFees[account] = excluded;
1046 
1047         emit ExcludeFromFees(account, excluded);
1048     }
1049 
1050     function isExcludedFromFees(address account) public view returns(bool) {
1051         return _isExcludedFromFees[account];
1052     }
1053 
1054     function changemarketingWallet(address _marketingWallet) external onlyOwner {
1055         require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
1056         require(!isContract(_marketingWallet), "Marketing wallet cannot be a contract");
1057         require(_marketingWallet != address(0), "Marketing wallet cannot be the zero address");
1058         marketingWallet = _marketingWallet;
1059         emit marketingWalletChanged(marketingWallet);
1060     }
1061     
1062     bool public tradingEnabled;
1063     bool public swapEnabled;
1064 
1065     function enableTrading() external onlyOwner{
1066         require(!tradingEnabled, "Trading already enabled.");
1067         tradingEnabled = true;
1068         swapEnabled = true;
1069         emit UpdateEnableTrading();
1070     }
1071 
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 amount
1076     ) internal override {
1077         require(from != address(0), "ERC20: transfer from the zero address");
1078         require(to != address(0), "ERC20: transfer to the zero address");
1079         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
1080 
1081         if(amount == 0) {
1082             super._transfer(from, to, 0);
1083             return;
1084         }
1085 
1086         uint256 contractTokenBalance = balanceOf(address(this));
1087 
1088         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1089 
1090         if( canSwap &&
1091             !swapping &&
1092             automatedMarketMakerPairs[to] &&
1093             swapEnabled &&
1094             totalBuyFee + totalSellFee > 0
1095         ) {
1096             swapping = true;
1097             
1098             uint256 liquidityTokens;
1099 
1100             if(liquidityFeeOnBuy + liquidityFeeOnSell > 0) {
1101                 liquidityTokens = contractTokenBalance * (liquidityFeeOnBuy + liquidityFeeOnSell) / (totalBuyFee + totalSellFee);
1102                 swapAndLiquify(liquidityTokens);
1103             }
1104 
1105             contractTokenBalance -= liquidityTokens;
1106 
1107             uint256 bnbShare = (marketingFeeOnBuy + marketingFeeOnSell) + (rewardsFeeOnBuy + rewardsFeeOnSell);
1108             
1109             if(contractTokenBalance > 0 && bnbShare > 0) {
1110                 uint256 initialBalance = address(this).balance;
1111 
1112                 address[] memory path = new address[](2);
1113                 path[0] = address(this);
1114                 path[1] = uniswapV2Router.WETH();
1115 
1116                 uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1117                     contractTokenBalance,
1118                     0,
1119                     path,
1120                     address(this),
1121                     block.timestamp);
1122                 
1123                 uint256 newBalance = address(this).balance - initialBalance;
1124 
1125                 if((marketingFeeOnBuy + marketingFeeOnSell) > 0) {
1126                     uint256 marketingBNB = newBalance * (marketingFeeOnBuy + marketingFeeOnSell) / bnbShare;
1127                     sendBNB(payable(marketingWallet), marketingBNB);
1128                     emit SendMarketing(marketingBNB);
1129                 }
1130 
1131                 if((rewardsFeeOnBuy + rewardsFeeOnSell) > 0) {
1132                     uint256 rewardBNB = newBalance * (rewardsFeeOnBuy + rewardsFeeOnSell) / bnbShare;
1133                     swapAndSendDividends(rewardBNB);
1134                 }
1135             }
1136 
1137             swapping = false;
1138         }
1139 
1140         bool takeFee = !swapping;
1141 
1142         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1143             takeFee = false;
1144         }
1145 
1146         // w2w & not excluded from fees
1147         if(from != uniswapV2Pair && to != uniswapV2Pair && takeFee) {
1148             takeFee = false;
1149         }
1150 
1151         if(takeFee) {
1152             uint256 _totalFees;
1153             if(from == uniswapV2Pair) {
1154                 _totalFees = totalBuyFee;
1155             } else {
1156                 _totalFees = totalSellFee;
1157             }
1158             uint256 fees = amount * _totalFees / 100;
1159             
1160             amount = amount - fees;
1161 
1162             super._transfer(from, address(this), fees);
1163         }
1164 
1165         super._transfer(from, to, amount);
1166 
1167         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1168         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1169 
1170         if(!swapping) {
1171             uint256 gas = gasForProcessing;
1172 
1173             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1174                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1175             }
1176             catch {
1177 
1178             }
1179         }
1180     }
1181 
1182     function swapAndLiquify(uint256 tokens) private {
1183         uint256 half = tokens / 2;
1184         uint256 otherHalf = tokens - half;
1185 
1186         uint256 initialBalance = address(this).balance;
1187 
1188         address[] memory path = new address[](2);
1189         path[0] = address(this);
1190         path[1] = uniswapV2Router.WETH();
1191 
1192         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1193             half,
1194             0, // accept any amount of ETH
1195             path,
1196             address(this),
1197             block.timestamp);
1198         
1199         uint256 newBalance = address(this).balance - initialBalance;
1200 
1201         uniswapV2Router.addLiquidityETH{value: newBalance}(
1202             address(this),
1203             otherHalf,
1204             0, // slippage is unavoidable
1205             0, // slippage is unavoidable
1206             wDEAD,
1207             block.timestamp
1208         );
1209 
1210         emit SwapAndLiquify(half, newBalance, otherHalf);
1211     }
1212 
1213     function swapAndSendDividends(uint256 amount) private{
1214         address[] memory path = new address[](2);
1215         path[0] = uniswapV2Router.WETH();
1216         path[1] = rewardToken;
1217 
1218         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1219             0,
1220             path,
1221             address(this),
1222             block.timestamp
1223         );
1224         
1225         uint256 balanceRewardToken = IERC20(rewardToken).balanceOf(address(this));
1226         bool success = IERC20(rewardToken).transfer(address(dividendTracker), balanceRewardToken);
1227 
1228         if (success) {
1229             dividendTracker.distributeDividends(balanceRewardToken);
1230             emit SendDividends(balanceRewardToken);
1231         }
1232     }
1233 
1234     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
1235         require(newAmount > totalSupply() / 100_000, "SwapTokensAtAmount must be greater than 0.001% of total supply");
1236         swapTokensAtAmount = newAmount;
1237         emit UpdateSwapTokensAtAmount(newAmount);
1238     }
1239     
1240     function setSwapEnabled(bool _enabled) external onlyOwner{
1241         require(swapEnabled != _enabled, "swapEnabled already at this state.");
1242         swapEnabled = _enabled;
1243         emit UpdateSwapEnabled(_enabled);
1244     }
1245 
1246     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1247         require(newValue >= 200_000 && newValue <= 500_000, "gasForProcessing must be between 200,000 and 500,000");
1248         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1249         emit GasForProcessingUpdated(newValue, gasForProcessing);
1250         gasForProcessing = newValue;
1251     }
1252 
1253     function updateMinimumBalanceForDividends(uint256 newMinimumBalance) external onlyOwner {
1254         require(newMinimumBalance > 0, "I need to be more than 0");
1255         dividendTracker.updateMinimumTokenBalanceForDividends(newMinimumBalance);
1256         emit UpdatedMinimumBalanceForDividends(newMinimumBalance);
1257     }
1258 
1259     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1260         require(newClaimWait >= 3_600 && newClaimWait <= 86_400, "claimWait must be updated to between 1 and 24 hours");
1261         dividendTracker.updateClaimWait(newClaimWait);
1262         emit UpdatedClaimWait();
1263     }
1264     function claimAddress(address claimee) external onlyOwner {
1265         require(claimee != address(0), "Cannot be Zero Address");
1266         dividendTracker.processAccount(payable(claimee), false);
1267         emit UpdateClaimee();
1268     }
1269     function setLastProcessedIndex(uint256 index) external onlyOwner {
1270         require(index > 0, "Index need to be more than 0.");
1271         dividendTracker.setLastProcessedIndex(index);
1272         emit UpdateLastProcessedIndex();
1273 
1274     }
1275 
1276     function excludeFromDividends(address account) external onlyOwner{
1277         require(account != address(0), "Cannot be Zero Address");
1278         dividendTracker.excludeFromDividends(account);
1279         emit UpdateExcludeFromDividends();
1280     }
1281 
1282 //External views
1283     function getClaimWait() external view returns(uint256) {
1284         return dividendTracker.claimWait();
1285     }
1286 
1287     function getTotalDividendsDistributed() external view returns (uint256) {
1288         return dividendTracker.totalDividendsDistributed();
1289     }
1290 
1291     function withdrawableDividendOf(address account) public view returns(uint256) {
1292         return dividendTracker.withdrawableDividendOf(account);
1293     }
1294 
1295     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1296         return dividendTracker.balanceOf(account);
1297     }
1298 
1299     function totalRewardsEarned(address account) public view returns (uint256) {
1300         return dividendTracker.accumulativeDividendOf(account);
1301     }
1302 
1303     function getAccountDividendsInfo(address account)
1304         external view returns (
1305             address,
1306             int256,
1307             int256,
1308             uint256,
1309             uint256,
1310             uint256,
1311             uint256,
1312             uint256) {
1313         return dividendTracker.getAccount(account);
1314     }
1315 
1316     function getAccountDividendsInfoAtIndex(uint256 index)
1317         external view returns (
1318             address,
1319             int256,
1320             int256,
1321             uint256,
1322             uint256,
1323             uint256,
1324             uint256,
1325             uint256) {
1326         return dividendTracker.getAccountAtIndex(index);
1327     }
1328     function getLastProcessedIndex() external view returns(uint256) {
1329         return dividendTracker.getLastProcessedIndex();
1330     }
1331 
1332 
1333 
1334     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1335         return dividendTracker.getNumberOfTokenHolders();
1336     }
1337 //end of views
1338 //External Functions
1339     function processDividendTracker(uint256 gas) external {
1340         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1341         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1342     }
1343 
1344     function claim() external {
1345         dividendTracker.processAccount(payable(msg.sender), false);
1346     }
1347 
1348 
1349 
1350 }