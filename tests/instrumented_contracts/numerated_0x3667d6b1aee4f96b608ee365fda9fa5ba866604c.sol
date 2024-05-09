1 /*
2 *
3 * Inubis is a decentralised crypto project with a focus on wildlife protection and conservation.
4 *
5 * Notable Features:
6 * • Ethereum Dividends for holders (Minimum tokens to qualify for ETH Rewards: 20Billion $INUBIS)
7 * • Monthly animal adoptions
8 * • Quarterly donations to verified animal sanctuaries
9 * • Anti 'Whale' dumping Protection
10 * • Anti-Bot measures 
11 * • External Buyback and burn
12 *
13 * Fees on transactions:
14 * The total fees on the transaction for both buys and sells stand at 9%. Fees are broken down as shown below:
15 *
16 * • 5% Automatic Ethereum Dividends 
17 * • 1% Marketing 
18 * • 1% Charity 
19 * • 1% Development 
20 * • 1% Burn 
21 *
22 * 'doubleTaxDailySellAmount' (double tax threshold) = 500B $INUBIS
23 * Total tax for sales above 'doubleTaxDailySellAmount' per day = 18%
24 *
25 * Telegram: t.me/inubistokenofficial 
26 * Twitter: twitter.com/InubisToken 
27 * Website: www.inubis.io
28 *
29 */
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity ^0.8.7;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         this; 
42         return msg.data;
43     }
44 }
45 
46 interface IERC20 {
47    
48     function totalSupply() external view returns (uint256);
49 
50     function balanceOf(address account) external view returns (uint256);
51 
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 interface IERC20Metadata is IERC20 {
70     
71     function name() external view returns (string memory);
72 
73     function symbol() external view returns (string memory);
74 
75     function decimals() external view returns (uint8);
76 }
77 
78 interface DividendPayingTokenOptionalInterface {
79   
80     function withdrawableDividendOf(address _owner) external view returns(uint256);
81 
82     function withdrawnDividendOf(address _owner) external view returns(uint256);
83 
84     function accumulativeDividendOf(address _owner) external view returns(uint256);
85 }
86 
87 interface DividendPayingTokenInterface {
88   
89     function dividendOf(address _owner) external view returns(uint256);
90 
91     function distributeDividends() external payable;
92 
93     function withdrawDividend() external;
94 
95     event DividendsDistributed(
96         address indexed from,
97         uint256 weiAmount
98     );
99 
100     event DividendWithdrawn(
101         address indexed to,
102         uint256 weiAmount
103     );
104 }
105 
106 library SafeMath {
107    
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b <= a, errorMessage);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         if (a == 0) {
128             return 0;
129         }
130 
131         uint256 c = a * b;
132         require(c / a == b, "SafeMath: multiplication overflow");
133 
134         return c;
135     }
136 
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b > 0, errorMessage);
143         uint256 c = a / b;
144         return c;
145     }
146 
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, "SafeMath: modulo by zero");
149     }
150 
151     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b != 0, errorMessage);
153         return a % b;
154     }
155 }
156 
157 /*
158 MIT License
159 
160 Copyright (c) 2018 requestnetwork
161 Copyright (c) 2018 Fragments, Inc.
162 
163 Permission is hereby granted, free of charge, to any person obtaining a copy
164 of this software and associated documentation files (the "Software"), to deal
165 in the Software without restriction, including without limitation the rights
166 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
167 copies of the Software, and to permit persons to whom the Software is
168 furnished to do so, subject to the following conditions:
169 
170 The above copyright notice and this permission notice shall be included in all
171 copies or substantial portions of the Software.
172 
173 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
174 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
175 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
176 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
177 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
178 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
179 SOFTWARE.
180 */
181 
182 library SafeMathInt {
183     int256 private constant MIN_INT256 = int256(1) << 255;
184     int256 private constant MAX_INT256 = ~(int256(1) << 255);
185 
186     function mul(int256 a, int256 b) internal pure returns (int256) {
187         int256 c = a * b;
188 
189         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
190         require((b == 0) || (c / b == a));
191         return c;
192     }
193 
194     function div(int256 a, int256 b) internal pure returns (int256) {
195         require(b != -1 || a != MIN_INT256);
196         return a / b;
197     }
198 
199     function sub(int256 a, int256 b) internal pure returns (int256) {
200         int256 c = a - b;
201         require((b >= 0 && c <= a) || (b < 0 && c > a));
202         return c;
203     }
204 
205     function add(int256 a, int256 b) internal pure returns (int256) {
206         int256 c = a + b;
207         require((b >= 0 && c >= a) || (b < 0 && c < a));
208         return c;
209     }
210 
211     function abs(int256 a) internal pure returns (int256) {
212         require(a != MIN_INT256);
213         return a < 0 ? -a : a;
214     }
215 
216 
217     function toUint256Safe(int256 a) internal pure returns (uint256) {
218         require(a >= 0);
219         return uint256(a);
220     }
221 }
222 
223 library SafeMathUint {
224   function toInt256Safe(uint256 a) internal pure returns (int256) {
225     int256 b = int256(a);
226     require(b >= 0);
227     return b;
228   }
229 }
230 
231 contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     constructor () {
237         address msgSender = _msgSender();
238         _owner = msgSender;
239         emit OwnershipTransferred(address(0), msgSender);
240     }
241 
242     function owner() public view returns (address) {
243         return _owner;
244     }
245 
246     modifier onlyOwner() {
247         require(_owner == _msgSender(), "Ownable: caller is not the owner");
248         _;
249     }
250 
251     function renounceOwnership() public virtual onlyOwner {
252         emit OwnershipTransferred(_owner, address(0));
253         _owner = address(0);
254     }
255 
256     function transferOwnership(address newOwner) public virtual onlyOwner {
257         require(newOwner != address(0), "Ownable: new owner is the zero address");
258         emit OwnershipTransferred(_owner, newOwner);
259         _owner = newOwner;
260     }
261 }
262 
263 library IterableMapping {
264     struct Map {
265         address[] keys;
266         mapping(address => uint) values;
267         mapping(address => uint) indexOf;
268         mapping(address => bool) inserted;
269     }
270 
271     function get(Map storage map, address key) public view returns (uint) {
272         return map.values[key];
273     }
274 
275     function getIndexOfKey(Map storage map, address key) public view returns (int) {
276         if(!map.inserted[key]) {
277             return -1;
278         }
279         return int(map.indexOf[key]);
280     }
281 
282     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
283         return map.keys[index];
284     }
285 
286     function size(Map storage map) public view returns (uint) {
287         return map.keys.length;
288     }
289 
290     function set(Map storage map, address key, uint val) public {
291         if (map.inserted[key]) {
292             map.values[key] = val;
293         } else {
294             map.inserted[key] = true;
295             map.values[key] = val;
296             map.indexOf[key] = map.keys.length;
297             map.keys.push(key);
298         }
299     }
300 
301     function remove(Map storage map, address key) public {
302         if (!map.inserted[key]) {
303             return;
304         }
305 
306         delete map.inserted[key];
307         delete map.values[key];
308 
309         uint index = map.indexOf[key];
310         uint lastIndex = map.keys.length - 1;
311         address lastKey = map.keys[lastIndex];
312 
313         map.indexOf[lastKey] = index;
314         delete map.indexOf[key];
315 
316         map.keys[index] = lastKey;
317         map.keys.pop();
318     }
319 }
320 
321 interface IUniswapV2Pair {
322     event Approval(address indexed owner, address indexed spender, uint value);
323     event Transfer(address indexed from, address indexed to, uint value);
324     function name() external pure returns (string memory);
325     function symbol() external pure returns (string memory);
326     function decimals() external pure returns (uint8);
327     function totalSupply() external view returns (uint);
328     function balanceOf(address owner) external view returns (uint);
329     function allowance(address owner, address spender) external view returns (uint);
330     function approve(address spender, uint value) external returns (bool);
331     function transfer(address to, uint value) external returns (bool);
332     function transferFrom(address from, address to, uint value) external returns (bool);
333     function DOMAIN_SEPARATOR() external view returns (bytes32);
334     function PERMIT_TYPEHASH() external pure returns (bytes32);
335     function nonces(address owner) external view returns (uint);
336     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
337     event Mint(address indexed sender, uint amount0, uint amount1);
338     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
339     event Swap(
340         address indexed sender,
341         uint amount0In,
342         uint amount1In,
343         uint amount0Out,
344         uint amount1Out,
345         address indexed to
346     );
347     event Sync(uint112 reserve0, uint112 reserve1);
348     function MINIMUM_LIQUIDITY() external pure returns (uint);
349     function factory() external view returns (address);
350     function token0() external view returns (address);
351     function token1() external view returns (address);
352     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
353     function price0CumulativeLast() external view returns (uint);
354     function price1CumulativeLast() external view returns (uint);
355     function kLast() external view returns (uint);
356     function mint(address to) external returns (uint liquidity);
357     function burn(address to) external returns (uint amount0, uint amount1);
358     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
359     function skim(address to) external;
360     function sync() external;
361     function initialize(address, address) external;
362 }
363 
364 interface IUniswapV2Factory {
365     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
366     function feeTo() external view returns (address);
367     function feeToSetter() external view returns (address);
368     function getPair(address tokenA, address tokenB) external view returns (address pair);
369     function allPairs(uint) external view returns (address pair);
370     function allPairsLength() external view returns (uint);
371     function createPair(address tokenA, address tokenB) external returns (address pair);
372     function setFeeTo(address) external;
373     function setFeeToSetter(address) external;
374 }
375 
376 interface IUniswapV2Router01 {
377     function factory() external pure returns (address);
378     function WETH() external pure returns (address);
379     function addLiquidity(
380         address tokenA,
381         address tokenB,
382         uint amountADesired,
383         uint amountBDesired,
384         uint amountAMin,
385         uint amountBMin,
386         address to,
387         uint deadline
388     ) external returns (uint amountA, uint amountB, uint liquidity);
389     function addLiquidityETH(
390         address token,
391         uint amountTokenDesired,
392         uint amountTokenMin,
393         uint amountETHMin,
394         address to,
395         uint deadline
396     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
397     function removeLiquidity(
398         address tokenA,
399         address tokenB,
400         uint liquidity,
401         uint amountAMin,
402         uint amountBMin,
403         address to,
404         uint deadline
405     ) external returns (uint amountA, uint amountB);
406     function removeLiquidityETH(
407         address token,
408         uint liquidity,
409         uint amountTokenMin,
410         uint amountETHMin,
411         address to,
412         uint deadline
413     ) external returns (uint amountToken, uint amountETH);
414     function removeLiquidityWithPermit(
415         address tokenA,
416         address tokenB,
417         uint liquidity,
418         uint amountAMin,
419         uint amountBMin,
420         address to,
421         uint deadline,
422         bool approveMax, uint8 v, bytes32 r, bytes32 s
423     ) external returns (uint amountA, uint amountB);
424     function removeLiquidityETHWithPermit(
425         address token,
426         uint liquidity,
427         uint amountTokenMin,
428         uint amountETHMin,
429         address to,
430         uint deadline,
431         bool approveMax, uint8 v, bytes32 r, bytes32 s
432     ) external returns (uint amountToken, uint amountETH);
433     function swapExactTokensForTokens(
434         uint amountIn,
435         uint amountOutMin,
436         address[] calldata path,
437         address to,
438         uint deadline
439     ) external returns (uint[] memory amounts);
440     function swapTokensForExactTokens(
441         uint amountOut,
442         uint amountInMax,
443         address[] calldata path,
444         address to,
445         uint deadline
446     ) external returns (uint[] memory amounts);
447     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
448         external
449         payable
450         returns (uint[] memory amounts);
451     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
452         external
453         returns (uint[] memory amounts);
454     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
455         external
456         returns (uint[] memory amounts);
457     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
458         external
459         payable
460         returns (uint[] memory amounts);
461     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
462     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
463     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
464     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
465     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
466 }
467 
468 
469 interface IUniswapV2Router02 is IUniswapV2Router01 {
470     function removeLiquidityETHSupportingFeeOnTransferTokens(
471         address token,
472         uint liquidity,
473         uint amountTokenMin,
474         uint amountETHMin,
475         address to,
476         uint deadline
477     ) external returns (uint amountETH);
478     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
479         address token,
480         uint liquidity,
481         uint amountTokenMin,
482         uint amountETHMin,
483         address to,
484         uint deadline,
485         bool approveMax, uint8 v, bytes32 r, bytes32 s
486     ) external returns (uint amountETH);
487 
488     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
489         uint amountIn,
490         uint amountOutMin,
491         address[] calldata path,
492         address to,
493         uint deadline
494     ) external;
495     function swapExactETHForTokensSupportingFeeOnTransferTokens(
496         uint amountOutMin,
497         address[] calldata path,
498         address to,
499         uint deadline
500     ) external payable;
501     function swapExactTokensForETHSupportingFeeOnTransferTokens(
502         uint amountIn,
503         uint amountOutMin,
504         address[] calldata path,
505         address to,
506         uint deadline
507     ) external;
508 }
509 
510 contract ERC20 is Context, IERC20, IERC20Metadata {
511     using SafeMath for uint256;
512 
513     mapping(address => uint256) private _balances;
514 
515     mapping(address => mapping(address => uint256)) private _allowances;
516 
517     uint256 private _totalSupply;
518 
519     string private _name;
520     string private _symbol;
521 
522     constructor(string memory name_, string memory symbol_) {
523         _name = name_;
524         _symbol = symbol_;
525     }
526 
527     function name() public view virtual override returns (string memory) {
528         return _name;
529     }
530 
531     function symbol() public view virtual override returns (string memory) {
532         return _symbol;
533     }
534 
535     function decimals() public view virtual override returns (uint8) {
536         return 9;
537     }
538 
539     function totalSupply() public view virtual override returns (uint256) {
540         return _totalSupply;
541     }
542 
543     function balanceOf(address account) public view virtual override returns (uint256) {
544         return _balances[account];
545     }
546 
547     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
548         _transfer(_msgSender(), recipient, amount);
549         return true;
550     }
551 
552     function allowance(address owner, address spender) public view virtual override returns (uint256) {
553         return _allowances[owner][spender];
554     }
555 
556     function approve(address spender, uint256 amount) public virtual override returns (bool) {
557         _approve(_msgSender(), spender, amount);
558         return true;
559     }
560 
561     function transferFrom(
562         address sender,
563         address recipient,
564         uint256 amount
565     ) public virtual override returns (bool) {
566         _transfer(sender, recipient, amount);
567         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
568         return true;
569     }
570 
571     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
573         return true;
574     }
575 
576     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
578         return true;
579     }
580 
581     function _transfer(
582         address sender,
583         address recipient,
584         uint256 amount
585     ) internal virtual {
586         require(sender != address(0), "ERC20: transfer from the zero address");
587         require(recipient != address(0), "ERC20: transfer to the zero address");
588 
589         _beforeTokenTransfer(sender, recipient, amount);
590 
591         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
592         _balances[recipient] = _balances[recipient].add(amount);
593         emit Transfer(sender, recipient, amount);
594     }
595 
596     function _mint(address account, uint256 amount) internal virtual {
597         require(account != address(0), "ERC20: mint to the zero address");
598 
599         _beforeTokenTransfer(address(0), account, amount);
600 
601         _totalSupply = _totalSupply.add(amount);
602         _balances[account] = _balances[account].add(amount);
603         emit Transfer(address(0), account, amount);
604     }
605 
606     function _burn(address account, uint256 amount) internal virtual {
607         require(account != address(0), "ERC20: burn from the zero address");
608 
609         _beforeTokenTransfer(account, address(0), amount);
610 
611         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
612         _totalSupply = _totalSupply.sub(amount);
613         emit Transfer(account, address(0), amount);
614     }
615 
616     function _approve(
617         address owner,
618         address spender,
619         uint256 amount
620     ) internal virtual {
621         require(owner != address(0), "ERC20: approve from the zero address");
622         require(spender != address(0), "ERC20: approve to the zero address");
623 
624         _allowances[owner][spender] = amount;
625         emit Approval(owner, spender, amount);
626     }
627 
628     function _beforeTokenTransfer(
629         address from,
630         address to,
631         uint256 amount
632     ) internal virtual {}
633 }
634 
635 /// @author Roger Wu (https://github.com/roger-wu)
636 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
637   using SafeMath for uint256;
638     using SafeMathUint for uint256;
639     using SafeMathInt for int256;
640 
641     uint256 constant internal magnitude = 2**128;
642 
643     uint256 internal magnifiedDividendPerShare;
644 
645     mapping(address => int256) internal magnifiedDividendCorrections;
646     mapping(address => uint256) internal withdrawnDividends;
647 
648     uint256 public gasForTransfer;
649 
650     uint256 public totalDividendsDistributed;
651 
652     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
653         gasForTransfer = 3000;
654     }
655 
656     receive() external payable {
657         distributeDividends();
658     }
659 
660     function distributeDividends() public override payable {
661         require(totalSupply() > 0);
662 
663         if (msg.value > 0) {
664             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
665                 (msg.value).mul(magnitude) / totalSupply()
666             );
667             emit DividendsDistributed(msg.sender, msg.value);
668 
669             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
670         }
671     }
672 
673     function withdrawDividend() public virtual override {
674         _withdrawDividendOfUser(payable(msg.sender));
675     }
676 
677     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
678         uint256 _withdrawableDividend = withdrawableDividendOf(user);
679         if (_withdrawableDividend > 0) {
680             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
681             emit DividendWithdrawn(user, _withdrawableDividend);
682             (bool success,) = user.call{value: _withdrawableDividend, gas: gasForTransfer}("");
683 
684             if(!success) {
685                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
686                 return 0;
687             }
688 
689             return _withdrawableDividend;
690         }
691 
692         return 0;
693     }
694 
695     function dividendOf(address _owner) public view override returns(uint256) {
696         return withdrawableDividendOf(_owner);
697     }
698 
699     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
700         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
701     }
702 
703     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
704         return withdrawnDividends[_owner];
705     }
706 
707 
708     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
709         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
710         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
711     }
712 
713     function _transfer(address from, address to, uint256 value) internal virtual override {
714         require(false);
715 
716         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
717         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
718         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
719     }
720 
721     function _mint(address account, uint256 value) internal override {
722         super._mint(account, value);
723 
724         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
725         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
726     }
727 
728     function _burn(address account, uint256 value) internal override {
729         super._burn(account, value);
730 
731         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
732         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
733     }
734 
735     function _setBalance(address account, uint256 newBalance) internal {
736         uint256 currentBalance = balanceOf(account);
737 
738         if(newBalance > currentBalance) {
739             uint256 mintAmount = newBalance.sub(currentBalance);
740             _mint(account, mintAmount);
741         } else if(newBalance < currentBalance) {
742             uint256 burnAmount = currentBalance.sub(newBalance);
743             _burn(account, burnAmount);
744         }
745     }
746 }
747 
748 contract InubisDividendTracker is DividendPayingToken, Ownable {
749     using SafeMath for uint256;
750     using SafeMathInt for int256;
751     using IterableMapping for IterableMapping.Map;
752 
753     IterableMapping.Map private tokenHoldersMap;
754     uint256 public lastProcessedIndex;
755 
756     mapping (address => bool) public excludedFromDividends;
757 
758     mapping (address => uint256) public lastClaimTimes;
759 
760     uint256 public claimWait;
761     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 20000000000 * (10**9);// Must hold 20B+ tokens.
762 
763     event ExcludedFromDividends(address indexed account);
764     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
765     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
766 
767     event Claim(address indexed account, uint256 amount, bool indexed automatic);
768 
769     constructor() DividendPayingToken("Inubis_Dividend_Tracker", "Inubis_Dividend_Tracker") {
770         claimWait = 3600;
771     }
772 
773     function _transfer(address, address, uint256) internal pure override {
774         require(false, "Inubis_Dividend_Tracker: No transfers allowed");
775     }
776 
777     function withdrawDividend() public pure override {
778         require(false, "Inubis_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main Inubis contract.");
779     }
780 
781     function excludeFromDividends(address account) external onlyOwner {
782         require(!excludedFromDividends[account]);
783         excludedFromDividends[account] = true;
784 
785         _setBalance(account, 0);
786         tokenHoldersMap.remove(account);
787 
788         emit ExcludedFromDividends(account);
789     }
790 
791     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
792         require(newGasForTransfer != gasForTransfer, "Inubis_Dividend_Tracker: Cannot update gasForTransfer to same value");
793         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
794         gasForTransfer = newGasForTransfer;
795     }
796 
797 
798     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
799         require(newClaimWait >= 3600 && newClaimWait <= 86400, "Inubis_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
800         require(newClaimWait != claimWait, "Inubis_Dividend_Tracker: Cannot update claimWait to same value");
801         emit ClaimWaitUpdated(newClaimWait, claimWait);
802         claimWait = newClaimWait;
803     }
804 
805     function getLastProcessedIndex() external view returns(uint256) {
806         return lastProcessedIndex;
807     }
808 
809     function getNumberOfTokenHolders() external view returns(uint256) {
810         return tokenHoldersMap.keys.length;
811     }
812 
813     function getAccount(address _account)
814     public view returns (
815         address account,
816         int256 index,
817         int256 iterationsUntilProcessed,
818         uint256 withdrawableDividends,
819         uint256 totalDividends,
820         uint256 lastClaimTime,
821         uint256 nextClaimTime,
822         uint256 secondsUntilAutoClaimAvailable) {
823         account = _account;
824 
825         index = tokenHoldersMap.getIndexOfKey(account);
826 
827         iterationsUntilProcessed = -1;
828 
829         if (index >= 0) {
830             if (uint256(index) > lastProcessedIndex) {
831                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
832             } else {
833                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
834                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
835             }
836         }
837 
838         withdrawableDividends = withdrawableDividendOf(account);
839         totalDividends = accumulativeDividendOf(account);
840 
841         lastClaimTime = lastClaimTimes[account];
842         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
843         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
844     }
845 
846     function getAccountAtIndex(uint256 index)
847     public view returns (
848         address,
849         int256,
850         int256,
851         uint256,
852         uint256,
853         uint256,
854         uint256,
855         uint256) {
856         if (index >= tokenHoldersMap.size()) {
857             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
858         }
859 
860         address account = tokenHoldersMap.getKeyAtIndex(index);
861         return getAccount(account);
862     }
863 
864     function getLastProcessedAccount()
865     public view returns (
866         address,
867         int256,
868         int256,
869         uint256,
870         uint256,
871         uint256,
872         uint256,
873         uint256) {
874         if (lastProcessedIndex >= tokenHoldersMap.size()) {
875             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
876         }
877 
878         address account = tokenHoldersMap.getKeyAtIndex(lastProcessedIndex);
879         return getAccount(account);
880     }
881 
882     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
883         if (lastClaimTime > block.timestamp)  {
884             return false;
885         }
886         return block.timestamp.sub(lastClaimTime) >= claimWait;
887     }
888 
889     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
890         if (excludedFromDividends[account]) {
891             return;
892         }
893 
894         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
895             _setBalance(account, newBalance);
896             tokenHoldersMap.set(account, newBalance);
897         } else {
898             _setBalance(account, 0);
899             tokenHoldersMap.remove(account);
900         }
901 
902         processAccount(account, true);
903     }
904 
905     function process(uint256 gas) public returns (uint256, uint256, uint256) {
906         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
907 
908         if (numberOfTokenHolders == 0) {
909             return (0, 0, lastProcessedIndex);
910         }
911 
912         uint256 _lastProcessedIndex = lastProcessedIndex;
913 
914         uint256 gasUsed = 0;
915         uint256 gasLeft = gasleft();
916 
917         uint256 iterations = 0;
918         uint256 claims = 0;
919 
920         while (gasUsed < gas && iterations < numberOfTokenHolders) {
921             _lastProcessedIndex++;
922 
923             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
924                 _lastProcessedIndex = 0;
925             }
926 
927             address account = tokenHoldersMap.keys[_lastProcessedIndex];
928 
929             if (canAutoClaim(lastClaimTimes[account])) {
930                 if (processAccount(payable(account), true)) {
931                     claims++;
932                 }
933             }
934 
935             iterations++;
936 
937             uint256 newGasLeft = gasleft();
938 
939             if (gasLeft > newGasLeft) {
940                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
941             }
942 
943             gasLeft = newGasLeft;
944         }
945 
946         lastProcessedIndex = _lastProcessedIndex;
947 
948         return (iterations, claims, lastProcessedIndex);
949     }
950 
951     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
952         uint256 amount = _withdrawDividendOfUser(account);
953 
954         if (amount > 0) {
955             lastClaimTimes[account] = block.timestamp;
956             emit Claim(account, amount, automatic);
957             return true;
958         }
959 
960         return false;
961     }
962 }
963 
964 contract Inubis is ERC20, Ownable {
965     using SafeMath for uint256;
966 
967     IUniswapV2Router02 public uniswapV2Router;
968     address public uniswapV2Pair;
969     InubisDividendTracker public dividendTracker;
970     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
971     address payable public marketingDevAndCharityAddress = payable(0xa7F28041DB9E522AF8f0a2c12A98B23fe2856169);
972     address payable public burnFundAddress = payable(0x1c174B1EEd0fd2990159E1FA1b60CACa16152086);
973     bool private swapping;
974     bool public maxTransactionLimitEnabled = true;
975     uint256 maxTransactionAmount = 1000000000000 * (10**9); //1T
976     uint256 public doubleTaxDailySellAmount = 500000000000 * (10**9); //500B
977     uint256 public swapTokensAtAmount = 20000000000 * (10**9); //20B
978     mapping(address => bool) private _isBot;
979     address[] private _confirmedBots;
980     bool public functionsEnabled = true;
981     bool public burnFundEnabled = true;
982     bool public ethRedistributionEnabled = true;
983     bool public marketingDevAndCharityEnabled = true;
984     uint256 public burnFee = 1;
985     uint256 public ethRedistributionFee = 5;
986     uint256 public marketingDevAndCharityFee = 3;
987     uint256 public totalFee = 9;
988     uint256 public gasForProcessing = 50000;
989     // once set to true can never be set false again
990     bool public tradingOpen = false;
991     uint256 public launchTime;
992     uint256 minimumTokenBalanceForDividends = 20000000000 * (10**9); //20B
993     // exlcude from fees and max transaction amount
994     mapping (address => bool) private _isExcludedFromFees;
995     mapping (address => bool) public automatedMarketMakerPairs;
996     mapping (uint256 => mapping(address => uint256)) public dailySell;
997     mapping (address => uint256) public lastTransfer;
998     mapping (address => bool) public isExcludedFromDailyLimit;
999 
1000     event DividendClaimed(uint256 ethAmount, uint256 tokenAmount, address account);
1001     event ExcludeFromFees(address indexed account, bool isExcluded);
1002     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1003     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1004     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic, uint256 gas, address indexed processor);
1005     event SendDividends(uint256 amount);
1006     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1007     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1008     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1009     
1010     constructor() ERC20("Inubis", "INUBIS") {
1011 
1012     	dividendTracker = new InubisDividendTracker();
1013 
1014     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1015         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1016             .createPair(address(this), _uniswapV2Router.WETH());
1017 
1018         uniswapV2Router = _uniswapV2Router;
1019         uniswapV2Pair = _uniswapV2Pair;
1020 
1021         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1022 
1023         dividendTracker.excludeFromDividends(address(dividendTracker));
1024         dividendTracker.excludeFromDividends(address(this));
1025         dividendTracker.excludeFromDividends(owner());
1026         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1027         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1028 
1029         excludeFromFees(address(this), true);
1030         excludeFromFees(owner(), true);
1031 
1032         isExcludedFromDailyLimit[address(this)] = true;
1033         isExcludedFromDailyLimit[owner()] = true;
1034 
1035         _mint(owner(), 100000000000000 * (10**9)); //100T
1036     }
1037 
1038     function excludeFromDailyLimit(address account, bool excluded) public onlyOwner {
1039         require(isExcludedFromDailyLimit[account] != excluded, "Inubis: Daily limit exclusion is already the value of 'excluded'");
1040         isExcludedFromDailyLimit[account] = excluded;
1041     }
1042 
1043     function setMaxTransactionLimitEnabled(bool enabled) public onlyOwner {
1044         require(maxTransactionLimitEnabled != enabled, "Inubis: Max transaction limit enabled is already the value of 'enabled'");
1045         maxTransactionLimitEnabled = enabled;
1046     }
1047     
1048     function setFunctionsEnabled(bool enabled) public onlyOwner {
1049         functionsEnabled = enabled;
1050     }
1051 
1052     function setBurnFundEnabled(bool enabled) public onlyOwner {
1053         burnFundEnabled = enabled;
1054     }
1055 
1056     function setETHRedistributionEnabled(bool enabled) public onlyOwner {
1057         ethRedistributionEnabled = enabled;
1058     }
1059 
1060     function setMarketingDevAndCharityFeeEnabled(bool enabled) public onlyOwner {
1061         marketingDevAndCharityEnabled = enabled;
1062     }
1063 
1064     function setMaxTransactionAmount(uint256 newAmount) public onlyOwner {
1065         maxTransactionAmount = newAmount;
1066     }
1067     
1068     function setSwapTokensAtAmount(uint256 newAmount) public onlyOwner {
1069         swapTokensAtAmount = newAmount;
1070     }
1071 
1072     function setDoubleTaxDailySellAmount(uint256 newAmount) public onlyOwner {
1073         doubleTaxDailySellAmount = newAmount;
1074     }
1075 
1076     function updateMarketingDevAndCharityAddress(address payable newAddress) public onlyOwner {
1077         marketingDevAndCharityAddress = newAddress;
1078     }
1079 
1080     function updateBurnFundAddress(address payable newAddress) public onlyOwner {
1081         burnFundAddress = newAddress;
1082     }
1083 
1084     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1085         dividendTracker.updateGasForTransfer(gasForTransfer);
1086     }
1087 
1088     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1089         require(newValue != gasForProcessing, "Inubis: Cannot update gasForProcessing to same value");
1090         emit GasForProcessingUpdated(newValue, gasForProcessing);
1091         gasForProcessing = newValue;
1092     }
1093 
1094     function updateClaimWait(uint256 claimWait) external onlyOwner {
1095         dividendTracker.updateClaimWait(claimWait);
1096     }
1097 
1098     function getGasForTransfer() external view returns(uint256) {
1099         return dividendTracker.gasForTransfer();
1100     }
1101 
1102 
1103     function getClaimWait() external view returns(uint256) {
1104         return dividendTracker.claimWait();
1105     }
1106 
1107     function getTotalDividendsDistributed() external view returns (uint256) {
1108         return dividendTracker.totalDividendsDistributed();
1109     }
1110 
1111     function isExcludedFromFees(address account) public view returns(bool) {
1112         return _isExcludedFromFees[account];
1113     }
1114 
1115     function withdrawableDividendOf(address account) public view returns(uint256) {
1116         return dividendTracker.withdrawableDividendOf(account);
1117     }
1118 
1119     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1120         return dividendTracker.balanceOf(account);
1121     }
1122 
1123     function getAccountDividendsInfo(address account)
1124     external view returns (
1125         address,
1126         int256,
1127         int256,
1128         uint256,
1129         uint256,
1130         uint256,
1131         uint256,
1132         uint256) {
1133         return dividendTracker.getAccount(account);
1134     }
1135 
1136     function getAccountDividendsInfoAtIndex(uint256 index)
1137     external view returns (
1138         address,
1139         int256,
1140         int256,
1141         uint256,
1142         uint256,
1143         uint256,
1144         uint256,
1145         uint256) {
1146         return dividendTracker.getAccountAtIndex(index);
1147     }
1148 
1149     function processDividendTracker(uint256 gas) external {
1150         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1151         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1152     }
1153 
1154     function claim() external {
1155         dividendTracker.processAccount(payable(msg.sender), false);
1156     }
1157 
1158     function getLastProcessedIndex() external view returns(uint256) {
1159         return dividendTracker.getLastProcessedIndex();
1160     }
1161 
1162     function getLastProcessedAccount()
1163     external view returns (
1164         address,
1165         int256,
1166         int256,
1167         uint256,
1168         uint256,
1169         uint256,
1170         uint256,
1171         uint256) {
1172         return dividendTracker.getLastProcessedAccount();
1173     }
1174 
1175     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1176         return dividendTracker.getNumberOfTokenHolders();
1177     }
1178 
1179     function reinvestInactive(address payable account) public onlyOwner {
1180         uint256 tokenBalance = dividendTracker.balanceOf(account);
1181         require(tokenBalance <= minimumTokenBalanceForDividends, "Inubis: Account balance must be less then minimum token balance for dividends");
1182 
1183         uint256 _lastTransfer = lastTransfer[account];
1184         require(block.timestamp.sub(_lastTransfer) > 12 weeks, "Inubis: Account must have been inactive for at least 12 weeks");
1185 
1186         dividendTracker.processAccount(account, false);
1187         uint256 dividends = address(this).balance;
1188         (bool success,) = address(dividendTracker).call{value: dividends}("");
1189 
1190         if(success) {
1191    	 		emit SendDividends(dividends);
1192             try dividendTracker.setBalance(account, 0) {} catch {}
1193         }
1194     }
1195 
1196     receive() external payable {
1197 
1198   	}
1199 
1200     function updateDividendTracker(address newAddress) public onlyOwner {
1201         require(newAddress != address(dividendTracker), "Inubis: The dividend tracker already has that address");
1202 
1203         InubisDividendTracker newDividendTracker = InubisDividendTracker(payable(newAddress));
1204 
1205         require(newDividendTracker.owner() == address(this), "Inubis: The new dividend tracker must be owned by the Inubis token contract");
1206 
1207         emit UpdateDividendTracker(newAddress, address(dividendTracker));
1208 
1209         dividendTracker = newDividendTracker;
1210 
1211         dividendTracker.excludeFromDividends(address(newDividendTracker));
1212         dividendTracker.excludeFromDividends(address(this));
1213         dividendTracker.excludeFromDividends(owner());
1214         dividendTracker.excludeFromDividends(address(uniswapV2Router));
1215         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1216     }
1217 
1218     function updateUniswapV2Router(address newAddress) public onlyOwner {
1219         require(newAddress != address(uniswapV2Router), "Inubis: The router already has that address");
1220         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1221         uniswapV2Router = IUniswapV2Router02(newAddress);
1222         dividendTracker.excludeFromDividends(address(uniswapV2Router));
1223     }
1224 
1225     function excludeFromFees(address account, bool excluded) public onlyOwner {
1226         require(_isExcludedFromFees[account] != excluded, "Inubis: Account is already the value of 'excluded'");
1227         _isExcludedFromFees[account] = excluded;
1228 
1229         emit ExcludeFromFees(account, excluded);
1230     }
1231 
1232     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1233         for(uint256 i = 0; i < accounts.length; i++) {
1234             _isExcludedFromFees[accounts[i]] = excluded;
1235         }
1236 
1237         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1238     }
1239 
1240     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1241         require(pair != uniswapV2Pair, "Inubis: The UniSwap pair cannot be removed from automatedMarketMakerPairs");
1242 
1243         _setAutomatedMarketMakerPair(pair, value);
1244     }
1245 
1246     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1247         require(automatedMarketMakerPairs[pair] != value, "Inubis: Automated market maker pair is already set to that value");
1248         automatedMarketMakerPairs[pair] = value;
1249 
1250         if(value) {
1251             dividendTracker.excludeFromDividends(pair);
1252         }
1253 
1254         emit SetAutomatedMarketMakerPair(pair, value);
1255     }
1256 
1257     function _transfer(
1258         address from,
1259         address to,
1260         uint256 amount
1261     ) internal override {
1262         require(from != address(0), "ERC20: transfer from the zero address");
1263         require(to != address(0), "ERC20: transfer to the zero address");
1264         require(amount > 0, "Transfer amount must be greater than zero");
1265         
1266         if(from != owner() && to != owner()) {
1267             if(maxTransactionLimitEnabled)
1268             {
1269                 require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount.");
1270             }
1271             require(!_isBot[from], "Bots cannot call transfer function");//antibot
1272             require(!_isBot[to], "Bots cannot call transfer function");//antibot
1273         }
1274 
1275         // buy
1276         if (from == uniswapV2Pair &&
1277             to != address(uniswapV2Router) &&
1278             !_isExcludedFromFees[to]) {
1279             require(tradingOpen, "Trading not opened yet!");
1280 
1281             //antibot: block zero bots will be added to bot blacklist
1282             if (block.timestamp == launchTime) {
1283                 _isBot[to] = true;
1284                 _confirmedBots.push(to);
1285             }
1286         }
1287         
1288         if(functionsEnabled && !swapping)
1289         {
1290 
1291     		uint256 contractTokenBalance = balanceOf(address(this));
1292             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1293             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFees[to]) { //a buy
1294                 if(burnFundEnabled)
1295                 {
1296                     burnFee = 1;
1297                 }else{
1298                     burnFee = 0;
1299                 }
1300                 if(ethRedistributionEnabled)
1301                 {
1302                     ethRedistributionFee = 5;
1303                 }else{
1304                     ethRedistributionFee = 0;
1305                 }
1306     
1307                 if(marketingDevAndCharityEnabled)
1308                 {
1309                     marketingDevAndCharityFee = 3;
1310                 }else{
1311                     marketingDevAndCharityFee = 0;
1312                 }
1313     
1314                 totalFee = burnFee + ethRedistributionFee + marketingDevAndCharityFee;
1315             }else if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFees[to]) { //a sell
1316     
1317                 if(dailySell[getDay()][from].add(amount) > doubleTaxDailySellAmount) //a sell for value greater than doubleTaxDailySellAmount
1318                 {
1319     
1320                     if(burnFundEnabled)
1321                     {
1322                         burnFee = 2;
1323                     }else{
1324                         burnFee = 0;
1325                     }
1326                     if(ethRedistributionEnabled)
1327                     {
1328                         ethRedistributionFee = 10;
1329                     }else{
1330                         ethRedistributionFee = 0;
1331                     }
1332     
1333                     if(marketingDevAndCharityEnabled)
1334                     {
1335                         marketingDevAndCharityFee = 6;
1336                     }else{
1337                         marketingDevAndCharityFee = 0;
1338                     }
1339     
1340                     totalFee = burnFee + ethRedistributionFee + marketingDevAndCharityFee;
1341                 }else{
1342                     if(burnFundEnabled)
1343                     {
1344                         burnFee = 1;
1345                     }else{
1346                         burnFee = 0;
1347                     }
1348                     if(ethRedistributionEnabled)
1349                     {
1350                         ethRedistributionFee = 5;
1351                     }else{
1352                         ethRedistributionFee = 0;
1353                     }
1354                     if(marketingDevAndCharityEnabled)
1355                     {
1356                         marketingDevAndCharityFee = 3;
1357                     }else{
1358                         marketingDevAndCharityFee = 0;
1359                     }
1360     
1361                     totalFee = burnFee + ethRedistributionFee + marketingDevAndCharityFee;
1362                 }
1363                 dailySell[getDay()][from] = dailySell[getDay()][from].add(amount);
1364             }
1365     
1366     
1367             if( canSwap &&
1368             !automatedMarketMakerPairs[from] &&
1369             !_isExcludedFromFees[from] &&
1370             !_isExcludedFromFees[to] &&
1371             (totalFee > 0))
1372             {
1373                 swapping = true;
1374                 swapAndDistribute();
1375                 swapping = false;
1376             }
1377     
1378             bool takeFee = true;
1379             if((_isExcludedFromFees[from] || _isExcludedFromFees[to]) || (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to])) {
1380                 takeFee = false;
1381             }
1382     
1383             if(takeFee && (totalFee >0)) {
1384             	uint256 fees = amount.mul(totalFee).div(100);
1385             	amount = amount.sub(fees);
1386                 super._transfer(from, address(this), fees);
1387             }
1388         
1389             super._transfer(from, to, amount);
1390     
1391             try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1392             try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1393             lastTransfer[from] = block.timestamp;
1394             lastTransfer[to] = block.timestamp;
1395     
1396             if (ethRedistributionEnabled) {
1397                 uint256 gas = gasForProcessing;
1398     
1399                 try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1400                     emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1401                 } catch {
1402     
1403                 }
1404             }
1405         }else{
1406             super._transfer(from, to, amount);
1407         }
1408     }
1409 
1410     function swapTokensForEth(uint256 tokenAmount) private {
1411         address[] memory path = new address[](2);
1412         path[0] = address(this);
1413         path[1] = uniswapV2Router.WETH();
1414 
1415         _approve(address(this), address(uniswapV2Router), tokenAmount);
1416 
1417         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1418             tokenAmount,
1419             0,
1420             path,
1421             address(this),
1422             block.timestamp
1423         );
1424     }
1425 
1426     function swapAndDistribute() private {
1427         uint256 tokenBalance = balanceOf(address(this));
1428         swapTokensForEth(tokenBalance);
1429 
1430         uint256 ethBalance = address(this).balance;
1431         uint256 marketingDevAndCharityPortion = ethBalance.mul(marketingDevAndCharityFee).div(totalFee);
1432         uint256 burnPortion = ethBalance.mul(burnFee).div(totalFee);
1433 
1434         if(marketingDevAndCharityEnabled && marketingDevAndCharityPortion > 0)
1435         {
1436             marketingDevAndCharityAddress.transfer(marketingDevAndCharityPortion);
1437         }
1438         if(burnFundEnabled && burnPortion > 0)
1439         {
1440             burnFundAddress.transfer(burnPortion);
1441         }
1442         
1443         uint256 dividends = address(this).balance;
1444         if(ethRedistributionEnabled && dividends > 0)
1445         {
1446             (bool success,) = address(dividendTracker).call{value: dividends}("");
1447 
1448             if(success) {
1449        	 		emit SendDividends(dividends);
1450             }
1451         }
1452     }
1453 
1454     function getDay() internal view returns(uint256){
1455         return block.timestamp.div(1 days);
1456     }
1457 
1458     function openTrading() external onlyOwner {
1459         tradingOpen = true;
1460         launchTime = block.timestamp;
1461     }
1462 
1463     function isBot(address account) public view returns (bool) {
1464         return _isBot[account];
1465     }
1466     
1467     function blacklistBot(address account) external onlyOwner() {
1468         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, "We cannot blacklist Uniswap");
1469         require(!_isBot[account], "Account is already blacklisted");
1470         _isBot[account] = true;
1471         _confirmedBots.push(account);
1472     }
1473 
1474     function amnestyBot(address account) external onlyOwner() {
1475         require(_isBot[account], "Account is not blacklisted");
1476         for (uint256 i = 0; i < _confirmedBots.length; i++) {
1477             if (_confirmedBots[i] == account) {
1478                 _confirmedBots[i] = _confirmedBots[_confirmedBots.length - 1];
1479                 _isBot[account] = false;
1480                 _confirmedBots.pop();
1481                 break;
1482             }
1483         }
1484     }
1485 }