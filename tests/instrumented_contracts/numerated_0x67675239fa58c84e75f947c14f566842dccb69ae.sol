1 // SPDX-License-Identifier: MIT
2 
3 
4 /*
5  * █▀█ █ ▀▄▀ █ ▄▀█   ▄▀█ █
6  * █▀▀ █ █░█ █ █▀█   █▀█ █
7  *
8  * https://Pixia.Ai
9  * https://t.me/PixiaAi
10  * https://twitter.com/PixiaAi
11 */
12 
13 
14 pragma solidity 0.8.17;
15 
16 interface IUniswapV2Router01 {
17 
18     function factory() external pure returns (address);
19 
20     function WETH() external pure returns (address);
21 
22     function addLiquidity(
23         address tokenA,
24         address tokenB,
25         uint amountADesired,
26         uint amountBDesired,
27         uint amountAMin,
28         uint amountBMin,
29         address to,
30         uint deadline
31     ) external returns (uint amountA, uint amountB, uint liquidity);
32 
33     function addLiquidityETH(
34         address token,
35         uint amountTokenDesired,
36         uint amountTokenMin,
37         uint amountETHMin,
38         address to,
39         uint deadline
40     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
41     
42     function removeLiquidity(
43         address tokenA,
44         address tokenB,
45         uint liquidity,
46         uint amountAMin,
47         uint amountBMin,
48         address to,
49         uint deadline
50     ) external returns (uint amountA, uint amountB);
51     
52     function removeLiquidityETH(
53         address token,
54         uint liquidity,
55         uint amountTokenMin,
56         uint amountETHMin,
57         address to,
58         uint deadline
59     ) external returns (uint amountToken, uint amountETH);
60     
61     function removeLiquidityWithPermit(
62         address tokenA,
63         address tokenB,
64         uint liquidity,
65         uint amountAMin,
66         uint amountBMin,
67         address to,
68         uint deadline,
69         bool approveMax, uint8 v, bytes32 r, bytes32 s
70     ) external returns (uint amountA, uint amountB);
71     
72     function removeLiquidityETHWithPermit(
73         address token,
74         uint liquidity,
75         uint amountTokenMin,
76         uint amountETHMin,
77         address to,
78         uint deadline,
79         bool approveMax, uint8 v, bytes32 r, bytes32 s
80     ) external returns (uint amountToken, uint amountETH);
81     
82     function swapExactTokensForTokens(
83         uint amountIn,
84         uint amountOutMin,
85         address[] calldata path,
86         address to,
87         uint deadline
88     ) external returns (uint[] memory amounts);
89     
90     function swapTokensForExactTokens(
91         uint amountOut,
92         uint amountInMax,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external returns (uint[] memory amounts);
97     
98     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
99         external
100         payable
101     returns (uint[] memory amounts);
102     
103     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
104         external
105     returns (uint[] memory amounts);
106     
107     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
108         external
109     returns (uint[] memory amounts);
110     
111     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
112         external
113         payable
114     returns (uint[] memory amounts);
115 
116     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
117     
118     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
119     
120     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
121     
122     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
123     
124     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
125 }
126 
127 
128 interface IUniswapV2Router02 is IUniswapV2Router01 {
129 
130     function removeLiquidityETHSupportingFeeOnTransferTokens(
131         address token,
132         uint liquidity,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountETH);
138 
139     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
140         address token,
141         uint liquidity,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline,
146         bool approveMax, uint8 v, bytes32 r, bytes32 s
147     ) external returns (uint amountETH);
148 
149     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external;
156 
157     function swapExactETHForTokensSupportingFeeOnTransferTokens(
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external payable;
163 
164     function swapExactTokensForETHSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171 }
172 
173 
174 interface IUniswapV2Factory {
175     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
176 
177     function feeTo() external view returns (address);
178     function feeToSetter() external view returns (address);
179 
180     function getPair(address tokenA, address tokenB) external view returns (address pair);
181     function allPairs(uint) external view returns (address pair);
182     function allPairsLength() external view returns (uint);
183 
184     function createPair(address tokenA, address tokenB) external returns (address pair);
185 
186     function setFeeTo(address) external;
187     function setFeeToSetter(address) external;
188 }
189 
190 
191 library IterableMapping {
192     // Iterable mapping from address to uint;
193     struct Map {
194         address[] keys;
195         mapping(address => uint) values;
196         mapping(address => uint) indexOf;
197         mapping(address => bool) inserted;
198     }
199 
200     function get(Map storage map, address key) internal view returns (uint) {
201         return map.values[key];
202     }
203 
204     function getIndexOfKey(Map storage map, address key) internal view returns (int) {
205         if(!map.inserted[key]) {
206             return -1;
207         }
208         return int(map.indexOf[key]);
209     }
210 
211     function getKeyAtIndex(Map storage map, uint index) internal view returns (address) {
212         return map.keys[index];
213     }
214 
215     function size(Map storage map) internal view returns (uint) {
216         return map.keys.length;
217     }
218 
219     function set(Map storage map, address key, uint val) internal {
220         if (map.inserted[key]) {
221             map.values[key] = val;
222         } else {
223             map.inserted[key] = true;
224             map.values[key] = val;
225             map.indexOf[key] = map.keys.length;
226             map.keys.push(key);
227         }
228     }
229 
230     function remove(Map storage map, address key) internal {
231         if (!map.inserted[key]) {
232             return;
233         }
234 
235         delete map.inserted[key];
236         delete map.values[key];
237 
238         uint index = map.indexOf[key];
239         uint lastIndex = map.keys.length - 1;
240         address lastKey = map.keys[lastIndex];
241 
242         map.indexOf[lastKey] = index;
243         delete map.indexOf[key];
244 
245         map.keys[index] = lastKey;
246         map.keys.pop();
247     }
248 }
249 
250 
251 /// @title Dividend-Paying Token Optional Interface
252 /// @author Roger Wu (https://github.com/roger-wu)
253 /// @dev OPTIONAL functions for a dividend-paying token contract.
254 interface DividendPayingTokenOptionalInterface {
255   /// @notice View the amount of dividend in wei that an address can withdraw.
256   /// @param _owner The address of a token holder.
257   /// @return The amount of dividend in wei that `_owner` can withdraw.
258   function withdrawableDividendOf(address _owner) external view returns(uint256);
259 
260   /// @notice View the amount of dividend in wei that an address has withdrawn.
261   /// @param _owner The address of a token holder.
262   /// @return The amount of dividend in wei that `_owner` has withdrawn.
263   function withdrawnDividendOf(address _owner) external view returns(uint256);
264 
265   /// @notice View the amount of dividend in wei that an address has earned in total.
266   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
267   /// @param _owner The address of a token holder.
268   /// @return The amount of dividend in wei that `_owner` has earned in total.
269   function accumulativeDividendOf(address _owner) external view returns(uint256);
270 }
271 
272 
273 /// @title Dividend-Paying Token Interface
274 /// @author Roger Wu (https://github.com/roger-wu)
275 /// @dev An interface for a dividend-paying token contract.
276 interface DividendPayingTokenInterface {
277   /// @notice View the amount of dividend in wei that an address can withdraw.
278   /// @param _owner The address of a token holder.
279   /// @return The amount of dividend in wei that `_owner` can withdraw.
280   function dividendOf(address _owner) external view returns(uint256);
281 
282 
283   /// @notice Withdraws the ether distributed to the sender.
284   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
285   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
286   function withdrawDividend() external;
287 
288   /// @dev This event MUST emit when ether is distributed to token holders.
289   /// @param from The address which sends ether to this contract.
290   /// @param weiAmount The amount of distributed ether in wei.
291   event DividendsDistributed(
292     address indexed from,
293     uint256 weiAmount
294   );
295 
296   /// @dev This event MUST emit when an address withdraws their dividend.
297   /// @param to The address which withdraws ether from this contract.
298   /// @param weiAmount The amount of withdrawn ether in wei.
299   event DividendWithdrawn(
300     address indexed to,
301     uint256 weiAmount
302   );
303 }
304 
305 
306 library SafeMathInt {
307     int256 private constant MIN_INT256 = int256(1) << 255;
308     int256 private constant MAX_INT256 = ~(int256(1) << 255);
309 
310     function mul(int256 a, int256 b) internal pure returns (int256) {
311         int256 c = a * b;
312 
313         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
314         require((b == 0) || (c / b == a));
315         return c;
316     }
317 
318     function div(int256 a, int256 b) internal pure returns (int256) {
319         
320         require(b != -1 || a != MIN_INT256);
321 
322         
323         return a / b;
324     }
325    
326     function sub(int256 a, int256 b) internal pure returns (int256) {
327         int256 c = a - b;
328         require((b >= 0 && c <= a) || (b < 0 && c > a));
329         return c;
330     }
331 
332     function add(int256 a, int256 b) internal pure returns (int256) {
333         int256 c = a + b;
334         require((b >= 0 && c >= a) || (b < 0 && c < a));
335         return c;
336     }
337     
338     function abs(int256 a) internal pure returns (int256) {
339         require(a != MIN_INT256);
340         return a < 0 ? -a : a;
341     }
342 
343     function toUint256Safe(int256 a) internal pure returns (uint256) {
344         require(a >= 0);
345         return uint256(a);
346     }
347 }
348 
349 
350 library SafeMathUint {
351   function toInt256Safe(uint256 a) internal pure returns (int256) {
352     int256 b = int256(a);
353     require(b >= 0);
354     return b;
355   }
356 }
357 
358 
359 library SafeMath {
360   
361     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
362         unchecked {
363             uint256 c = a + b;
364             if (c < a) return (false, 0);
365             return (true, c);
366         }
367     }
368     
369     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         unchecked {
371             if (b > a) return (false, 0);
372             return (true, a - b);
373         }
374     }
375     
376     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         unchecked {
378           
379             if (a == 0) return (true, 0);
380             uint256 c = a * b;
381             if (c / a != b) return (false, 0);
382             return (true, c);
383         }
384     }
385     
386     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
387         unchecked {
388             if (b == 0) return (false, 0);
389             return (true, a / b);
390         }
391     }
392     
393     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
394         unchecked {
395             if (b == 0) return (false, 0);
396             return (true, a % b);
397         }
398     }
399     
400     function add(uint256 a, uint256 b) internal pure returns (uint256) {
401         return a + b;
402     }
403 
404     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
405         return a - b;
406     }
407     
408     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
409         return a * b;
410     }
411     
412     function div(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a / b;
414     }
415 
416     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
417         return a % b;
418     }
419 
420     function sub(
421         uint256 a,
422         uint256 b,
423         string memory errorMessage
424     ) internal pure returns (uint256) {
425         unchecked {
426             require(b <= a, errorMessage);
427             return a - b;
428         }
429     }
430   
431     function div(
432         uint256 a,
433         uint256 b,
434         string memory errorMessage
435     ) internal pure returns (uint256) {
436         unchecked {
437             require(b > 0, errorMessage);
438             return a / b;
439         }
440     }
441 
442     function mod(
443         uint256 a,
444         uint256 b,
445         string memory errorMessage
446     ) internal pure returns (uint256) {
447         unchecked {
448             require(b > 0, errorMessage);
449             return a % b;
450         }
451     }
452 }
453 
454 
455 abstract contract Context {
456     function _msgSender() internal view virtual returns (address) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes calldata) {
461         return msg.data;
462     }
463 }
464 
465 
466 abstract contract Ownable is Context {
467     address private _owner;
468 
469     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
470 
471     constructor() {
472         _setOwner(_msgSender());
473     }
474 
475     function owner() public view virtual returns (address) {
476         return _owner;
477     }
478 
479     modifier onlyOwner() {
480         require(owner() == _msgSender(), "Ownable: caller is not the owner");
481         _;
482     }
483 
484     function renounceOwnership() public virtual onlyOwner {
485         _setOwner(address(0));
486     }
487 
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(newOwner != address(0), "Ownable: new owner is the zero address");
490         _setOwner(newOwner);
491     }
492 
493     function _setOwner(address newOwner) private {
494         address oldOwner = _owner;
495         _owner = newOwner;
496         emit OwnershipTransferred(oldOwner, newOwner);
497     }
498 }
499 
500 
501 interface IERC20 {
502     
503     function totalSupply() external view returns (uint256);
504 
505     function balanceOf(address account) external view returns (uint256);
506 
507     function transfer(address recipient, uint256 amount) external returns (bool);
508 
509     function allowance(address owner, address spender) external view returns (uint256);
510 
511     function approve(address spender, uint256 amount) external returns (bool);
512 
513     function transferFrom(
514         address sender,
515         address recipient,
516         uint256 amount
517     ) external returns (bool);
518 
519     
520     event Transfer(address indexed from, address indexed to, uint256 value);
521     event Approval(address indexed owner, address indexed spender, uint256 value);
522 }
523 
524 interface IERC20Metadata is IERC20 {
525     
526     function name() external view returns (string memory);
527 
528     function symbol() external view returns (string memory);
529 
530     function decimals() external view returns (uint8);
531 }
532 
533 
534 contract ERC20 is Context, IERC20, IERC20Metadata {
535     mapping(address => uint256) private _balances;
536 
537     mapping(address => mapping(address => uint256)) private _allowances;
538 
539     uint256 private _totalSupply;
540 
541     string private _name;
542     string private _symbol;
543 
544     constructor(string memory name_, string memory symbol_) {
545         _name = name_;
546         _symbol = symbol_;
547     }
548 
549     // The name function returns the name of the token.
550     function name() public view virtual override returns (string memory) {
551         return _name;
552     }
553 
554     // The symbol function returns the symbol of the token.
555     function symbol() public view virtual override returns (string memory) {
556         return _symbol;
557     }
558 
559     // The decimals function returns the number of decimal places used by the token.
560     function decimals() public view virtual override returns (uint8) {
561         return 18;
562     }
563 
564     // The totalSupply function returns the total supply of tokens in the contract.
565     function totalSupply() public view virtual override returns (uint256) {
566         return _totalSupply;
567     }
568 
569     // The balanceOf function returns the balance of tokens for an address.
570     function balanceOf(address account) public view virtual override returns (uint256) {
571         return _balances[account];
572     }
573 
574     // The transfer function transfers tokens to a recipient.
575     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
576         _transfer(_msgSender(), recipient, amount);
577         return true;
578     }
579 
580     // The allowance function returns the allowance of a spender to spend tokens on behalf of an owner.
581     function allowance(address owner, address spender) public view virtual override returns (uint256) {
582         return _allowances[owner][spender];
583     }
584 
585     // The approve function approves an address to spend a certain amount of tokens.
586     function approve(address spender, uint256 amount) public virtual override returns (bool) {
587         _approve(_msgSender(), spender, amount);
588         return true;
589     }
590 
591     // The transferFrom function transfers a certain amount of tokens from one address to another, then updates the allowance.
592     function transferFrom(
593         address sender,
594         address recipient,
595         uint256 amount
596     ) public virtual override returns (bool) {
597         _transfer(sender, recipient, amount);
598 
599         uint256 currentAllowance = _allowances[sender][_msgSender()];
600         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
601         unchecked {
602             _approve(sender, _msgSender(), currentAllowance - amount);
603         }
604 
605         return true;
606     }
607 
608     // The increaseAllowance function increases the allowance of a spender.
609     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
611         return true;
612     }
613 
614     // The decreaseAllowance function decrease the allowance of a spender.
615     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
616         uint256 currentAllowance = _allowances[_msgSender()][spender];
617         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
618         unchecked {
619             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
620         }
621 
622         return true;
623     }
624 
625     // The _transfer function handles token transfers between different addresses (private function).
626     function _transfer(
627         address sender,
628         address recipient,
629         uint256 amount
630     ) internal virtual {
631         require(sender != address(0), "ERC20: transfer from the zero address");
632         require(recipient != address(0), "ERC20: transfer to the zero address");
633 
634         _beforeTokenTransfer(sender, recipient, amount);
635 
636         uint256 senderBalance = _balances[sender];
637         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
638         unchecked {
639             _balances[sender] = senderBalance - amount;
640         }
641         _balances[recipient] += amount;
642 
643         emit Transfer(sender, recipient, amount);
644 
645         _afterTokenTransfer(sender, recipient, amount);
646     }
647 
648     function _mint(address account, uint256 amount) internal virtual {
649         require(account != address(0), "ERC20: mint to the zero address");
650 
651         _beforeTokenTransfer(address(0), account, amount);
652 
653         _totalSupply += amount;
654         _balances[account] += amount;
655         emit Transfer(address(0), account, amount);
656 
657         _afterTokenTransfer(address(0), account, amount);
658     }
659 
660     function _burn(address account, uint256 amount) internal virtual {
661         require(account != address(0), "ERC20: burn from the zero address");
662 
663         _beforeTokenTransfer(account, address(0), amount);
664 
665         uint256 accountBalance = _balances[account];
666         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
667         unchecked {
668             _balances[account] = accountBalance - amount;
669         }
670         _totalSupply -= amount;
671 
672         emit Transfer(account, address(0), amount);
673 
674         _afterTokenTransfer(account, address(0), amount);
675     }
676 
677     // The _approve function updates the allowance of a spender for an owner and emits an Approval event (private function).
678     function _approve(
679         address owner,
680         address spender,
681         uint256 amount
682     ) internal virtual {
683         require(owner != address(0), "ERC20: approve from the zero address");
684         require(spender != address(0), "ERC20: approve to the zero address");
685 
686         _allowances[owner][spender] = amount;
687         emit Approval(owner, spender, amount);
688     }
689 
690     function _beforeTokenTransfer(
691         address from,
692         address to,
693         uint256 amount
694     ) internal virtual {}
695 
696     function _afterTokenTransfer(
697         address from,
698         address to,
699         uint256 amount
700     ) internal virtual {}
701 }
702 
703 
704 /// @title Dividend-Paying Token
705 /// @author Roger Wu (https://github.com/roger-wu)
706 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
707 ///  to token holders as dividends and allows token holders to withdraw their dividends.
708 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
709 contract DividendPayingToken is ERC20, Ownable, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
710   using SafeMath for uint256;
711   using SafeMathUint for uint256;
712   using SafeMathInt for int256;
713 
714   address public immutable  partnerToken; 
715 
716 
717   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
718   // For more discussion about choosing the value of `magnitude`,
719   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
720   uint256 constant internal magnitude = 2**128;
721 
722   uint256 internal magnifiedDividendPerShare;
723 
724   // About dividendCorrection:
725   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
726   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
727   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
728   //   `dividendOf(_user)` should not be changed,
729   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
730   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
731   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
732   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
733   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
734   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
735   mapping(address => int256) internal magnifiedDividendCorrections;
736   mapping(address => uint256) internal withdrawnDividends;
737 
738   uint256 public totalDividendsDistributed;
739 
740   constructor (string memory _name, string memory _symbol, address _rewardToken) ERC20(_name, _symbol) {
741          partnerToken = _rewardToken;
742   }
743 
744 
745   function distributepartnerDividends(uint256 amount) public onlyOwner{
746     require(totalSupply() > 0);
747 
748     if (amount > 0) {
749       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
750         (amount).mul(magnitude) / totalSupply()
751       );
752       emit DividendsDistributed(msg.sender, amount);
753 
754       totalDividendsDistributed = totalDividendsDistributed.add(amount);
755     }
756   }
757 
758   /// @notice Withdraws the ether distributed to the sender.
759   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
760   function withdrawDividend() public virtual override {
761     _withdrawDividendOfUser(payable(msg.sender));
762   }
763 
764   /// @notice Withdraws the ether distributed to the sender.
765   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
766   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
767     uint256 _withdrawableDividend = withdrawableDividendOf(user);
768     if (_withdrawableDividend > 0) {
769       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
770       emit DividendWithdrawn(user, _withdrawableDividend);
771       bool success = IERC20(partnerToken).transfer(user, _withdrawableDividend);
772 
773       if(!success) {
774         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
775         return 0;
776       }
777 
778       return _withdrawableDividend;
779     }
780 
781     return 0;
782   }
783 
784   /// @notice View the amount of dividend in wei that an address can withdraw.
785   /// @param _owner The address of a token holder.
786   /// @return The amount of dividend in wei that `_owner` can withdraw.
787   function dividendOf(address _owner) public view override returns(uint256) {
788     return withdrawableDividendOf(_owner);
789   }
790 
791   /// @notice View the amount of dividend in wei that an address can withdraw.
792   /// @param _owner The address of a token holder.
793   /// @return The amount of dividend in wei that `_owner` can withdraw.
794   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
795     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
796   }
797 
798   /// @notice View the amount of dividend in wei that an address has withdrawn.
799   /// @param _owner The address of a token holder.
800   /// @return The amount of dividend in wei that `_owner` has withdrawn.
801   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
802     return withdrawnDividends[_owner];
803   }
804 
805   /// @notice View the amount of dividend in wei that an address has earned in total.
806   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
807   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
808   /// @param _owner The address of a token holder.
809   /// @return The amount of dividend in wei that `_owner` has earned in total.
810   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
811     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
812       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
813   }
814 
815   /// @dev Internal function that transfer tokens from one address to another.
816   /// Update magnifiedDividendCorrections to keep dividends unchanged.
817   /// @param from The address to transfer from.
818   /// @param to The address to transfer to.
819   /// @param value The amount to be transferred.
820   function _transfer(address from, address to, uint256 value) internal virtual override {
821     require(false);
822 
823     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
824     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
825     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
826   }
827 
828   /// @dev Internal function that mints tokens to an account.
829   /// Update magnifiedDividendCorrections to keep dividends unchanged.
830   /// @param account The account that will receive the created tokens.
831   /// @param value The amount that will be created.
832   function _mint(address account, uint256 value) internal override {
833     super._mint(account, value);
834 
835     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
836       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
837   }
838 
839   /// @dev Internal function that burns an amount of the token of a given account.
840   /// Update magnifiedDividendCorrections to keep dividends unchanged.
841   /// @param account The account whose tokens will be burnt.
842   /// @param value The amount that will be burnt.
843   function _burn(address account, uint256 value) internal override {
844     super._burn(account, value);
845 
846     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
847       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
848   }
849 
850   function _setBalance(address account, uint256 newBalance) internal {
851     uint256 currentBalance = balanceOf(account);
852 
853     if(newBalance > currentBalance) {
854       uint256 mintAmount = newBalance.sub(currentBalance);
855       _mint(account, mintAmount);
856     } else if(newBalance < currentBalance) {
857       uint256 burnAmount = currentBalance.sub(newBalance);
858       _burn(account, burnAmount);
859     }
860   }
861 }
862 
863 
864 // File: contracts/PixiaAI.sol
865 
866 contract PixiaAI is ERC20, Ownable {
867     using SafeMath for uint256;
868 
869      struct BuyFee {
870         uint16 staking;
871         uint16 burn;
872         uint16 autoLP;
873         uint16 dev;
874         uint16 treasury;
875         uint16 partner;
876         uint16 integration;
877     }
878 
879     struct SellFee {
880         uint16 staking;
881         uint16 burn;
882         uint16 autoLP;
883         uint16 dev;
884         uint16 treasury;
885         uint16 partner;
886         uint16 integration;
887     }
888 
889 
890     BuyFee public buyFee;
891     SellFee public sellFee;
892 
893     IUniswapV2Router02 public uniswapV2Router;
894     address public uniswapV2Pair;
895 
896     bool private swapping;
897     bool public isLaunched;
898 
899     uint16 private totalBuyFee;
900     uint16 private totalSellFee;
901     uint256 public launchTime;
902 
903     TOKENDividendTracker public dividendTracker;
904 
905     address public intergrationToken = address (0x000000000000000000000000000000000000dEaD); // Integration token smart contract
906     address public partnerToken = address(0x000000000000000000000000000000000000dEaD); // Partner token smart contract (autoDistributed to holders)
907     
908     address public devWallet =address(0xdDf3e4D035a75d3a5bB11F9CaD79fa555D3aa957); // Dev wallet 
909     address public integrationWallet = address(0x000000000000000000000000000000000000dEaD); // Intergation wallet
910     address public stakingWallet = address(0x000000000000000000000000000000000000dEaD); // Staking wallet
911     address public treasuryWallet = address (0x306968Ccc755Eb0984F57A5729d28346aadb8db7); // TreasuryWallet
912     address public constant burnWallet = address(0x000000000000000000000000000000000000dEaD); // Burn wallet
913 
914     uint256 public swapTokensAtAmount = 1 * 1e4 * 1e18; // 10000 tokens min for swap
915     uint256 public maxTxAmount;
916     uint256 public maxWallet;
917 
918 
919     // use by default 300,000 gas to process auto-claiming dividends
920     uint256 public gasForProcessing = 300000;
921 
922     // exlcude from fees and max transaction amount
923     mapping(address => bool) private _isExcludedFromFees;
924     mapping(address => bool) public _isExcludedFromMaxTx;
925     mapping(address => bool) public _isExcludedFromMaxWallet;
926    
927 
928     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
929     // could be subject to a maximum transfer amount
930     mapping(address => bool) public automatedMarketMakerPairs;
931 
932     event UpdateDividendTracker(
933         address indexed newAddress,
934         address indexed oldAddress
935     );
936 
937     event ExcludeFromFees(address indexed account, bool isExcluded);
938     
939     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
940 
941     event GasForProcessingUpdated(
942         uint256 indexed newValue,
943         uint256 indexed oldValue
944     );
945 
946     event ProcessedDividendTracker(
947         uint256 iterations,
948         uint256 claims,
949         uint256 lastProcessedIndex,
950         bool indexed automatic,
951         uint256 gas,
952         address indexed processor
953     );
954 
955     event SendDividends( uint256 amount);
956 
957 
958     constructor() ERC20("PixiaAI", "PIXIA") {
959         dividendTracker = new TOKENDividendTracker(partnerToken);
960 
961         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
962             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //Uniswap V2 router
963         );
964         // Create a uniswap pair for this new token
965         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
966             .createPair(address(this), _uniswapV2Router.WETH());
967 
968         uniswapV2Router = _uniswapV2Router;
969         uniswapV2Pair = _uniswapV2Pair;
970 
971 
972         //buyFee per Ten thousand %
973         buyFee.staking = 0;
974         buyFee.dev = 200;
975         buyFee.autoLP = 100;
976         buyFee.burn = 0;
977         buyFee.treasury = 400;
978         buyFee.partner = 0;
979         buyFee.integration = 0;
980         totalBuyFee = 700;
981        
982 
983         //sellFees per Ten thousand %
984         sellFee.staking = 0;
985         sellFee.dev = 200;
986         sellFee.autoLP = 100;
987         sellFee.burn = 0;
988         sellFee.treasury = 400;
989         sellFee.partner = 0;
990         sellFee.integration = 0;
991         totalSellFee = 700;
992 
993 
994         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
995 
996         // exclude from receiving dividends
997         dividendTracker.excludeFromDividends(address(dividendTracker));
998         dividendTracker.excludeFromDividends(address(this));
999         dividendTracker.excludeFromDividends(owner());
1000         dividendTracker.excludeFromDividends(burnWallet);
1001         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1002         
1003 
1004         // exclude from paying fees or having max transaction or maxWallet amount
1005         excludeFromFees(owner(), true);
1006         excludeFromFees(treasuryWallet, true);
1007         excludeFromFees(burnWallet, true);
1008         excludeFromFees(address(this), true);
1009 
1010         /*
1011             _mint is an internal function in ERC20.sol that is only called here,
1012             and CANNOT be called ever again
1013         */
1014         _mint(owner(), 1e8 * 1e18); // Total Supply: 100 million tokens.
1015 
1016         maxTxAmount = totalSupply().mul(11).div(1000); // MaxTxAmount set to 1.1% of the total supply.
1017         maxWallet = totalSupply().mul(5).div(1000);//  MaxWalletAmount set to 0.5% of the total supply.
1018     }
1019 
1020     // This function is a fallback function that allows the contract address to receive ether.
1021     receive() external payable {}
1022 
1023     // This updatePartnerToken function allows the owner to update the partner token smart contract and the dividend tracker.
1024     function updatePartnerToken(address newToken) public onlyOwner {
1025         TOKENDividendTracker newDividendTracker = new TOKENDividendTracker(
1026             newToken
1027         );
1028 
1029         newDividendTracker.excludeFromDividends(address(newDividendTracker));
1030         newDividendTracker.excludeFromDividends(address(this));
1031         newDividendTracker.excludeFromDividends(owner());
1032         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
1033 
1034         partnerToken = newToken;
1035         dividendTracker = newDividendTracker;
1036         emit UpdateDividendTracker(newToken, address(dividendTracker));
1037     }
1038 
1039     // The launch function allows the owner to launch the smart contract and make trading active.
1040     function launch() external onlyOwner {
1041         require (launchTime == 0, "already launched boi");
1042         isLaunched = true;
1043     }
1044 
1045     // The claimStuckTokens function allows the owner to withdraw a foreign specified token from the contract.
1046     function claimStuckTokens(address _token) external onlyOwner {
1047         IERC20 erc20token = IERC20(_token);
1048         uint256 balance = erc20token.balanceOf(address(this));
1049         erc20token.transfer(owner(), balance);
1050     }
1051 
1052     // The claimEther function allows the owner to withdraw ETH mistakenly sent to the contract address.
1053     function claimEther () external onlyOwner {
1054         payable(msg.sender).transfer(address(this).balance);
1055     }
1056 
1057     // The excludeFromFees function enables the owner of the contract to exclude an address from the fees.
1058     function excludeFromFees(address account, bool excluded) public onlyOwner {
1059         require(
1060             _isExcludedFromFees[account] != excluded); //"PixiaAI: Account is already excluded"
1061         _isExcludedFromFees[account] = excluded;
1062 
1063         emit ExcludeFromFees(account, excluded);
1064     }
1065 
1066     // The setMaxWalletAmount function allows the owner of the contract to set a maximum limit for a wallet.
1067    function setWallets(address  _dev, address _int, address _treasury, address _staking ) external onlyOwner {
1068         devWallet = _dev;
1069         integrationWallet = _int;
1070         treasuryWallet = _treasury;
1071         stakingWallet = _staking;
1072     }
1073 
1074     // The setBuyFees function allows the owner to update the buy tax.
1075     function setBuyFees(
1076         uint16 _staking,
1077         uint16 _dev,
1078         uint16 _autoLP,
1079         uint16 _burn,
1080         uint16 _treasury,
1081         uint16 _partner,
1082         uint16 _integration
1083     ) external onlyOwner {
1084         buyFee.staking = _staking;
1085         buyFee.dev = _dev;
1086         buyFee.autoLP = _autoLP;
1087         buyFee.burn = _burn;
1088         buyFee.treasury = _treasury;
1089         buyFee.partner = _partner;
1090         buyFee.integration = _integration;
1091 
1092         totalBuyFee = buyFee.staking + buyFee.dev + buyFee.autoLP + buyFee.burn + buyFee.treasury 
1093         + buyFee.partner + buyFee.integration;
1094        // Max buy Fees limit is 20 percent, 10000 is used a divisor
1095         require (totalBuyFee <=2000);
1096     }
1097 
1098     // The setSellFees function allows the owner to update the sell tax.
1099     function setSellFees(
1100         uint16 _staking,
1101         uint16 _dev,
1102         uint16 _autoLP,
1103         uint16 _burn,
1104         uint16 _treasury,
1105         uint16 _partner,
1106         uint16 _integration
1107     ) external onlyOwner {
1108         sellFee.staking = _staking;
1109         sellFee.dev = _dev;
1110         sellFee.autoLP = _autoLP;
1111         sellFee.burn = _burn;
1112         sellFee.treasury = _treasury;
1113         sellFee.partner = _partner;
1114         sellFee.integration = _integration;
1115 
1116         totalSellFee = sellFee.staking + sellFee.dev + sellFee.autoLP + sellFee.burn + sellFee.treasury 
1117         + sellFee.partner + buyFee.integration;
1118        //Max sell Fees limit is 20 percent, 10000 is used a divisor
1119         require (totalSellFee <=2000);
1120     }
1121 
1122     // The setAutomatedMarketMakerPair function allows the owner to set an Automated Market Maker pair.
1123     function setAutomatedMarketMakerPair(address pair, bool value)
1124         public
1125         onlyOwner
1126     {
1127         require(
1128             pair != uniswapV2Pair
1129         );
1130 
1131         _setAutomatedMarketMakerPair(pair, value);
1132     }
1133 
1134     // The _setAutomatedMarketMakerPair function sets the value of a token pair in the automated market maker pairs mapping (Private function).
1135     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1136         require(
1137             automatedMarketMakerPairs[pair] != value,
1138             "PixiaAI: Automated market maker pair is already set to that value"
1139         );
1140         automatedMarketMakerPairs[pair] = value;
1141 
1142         if (value) {
1143             dividendTracker.excludeFromDividends(pair);
1144         }
1145 
1146         emit SetAutomatedMarketMakerPair(pair, value);
1147     }
1148 
1149     // The setSwapTokensAtAmount function allows the owner to update the number of tokens to swap to sell from fees.
1150     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
1151         swapTokensAtAmount = amount * 1e18;
1152     }
1153 
1154     // This updateGasForProcessing function allows the owner to update the gas value for processing.
1155     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1156         require(
1157             newValue >= 200000 && newValue <= 500000
1158         );
1159         require(
1160             newValue != gasForProcessing
1161         );
1162         emit GasForProcessingUpdated(newValue, gasForProcessing);
1163         gasForProcessing = newValue;
1164     }
1165 
1166     // This updateClaimWait function allows the owner to update the claim wait time for dividends.
1167     function updateClaimWait(uint256 claimWait) external onlyOwner {
1168         dividendTracker.updateClaimWait(claimWait);
1169     }
1170 
1171     // The isExcludedFromFees function enables the owner of the contract to exclude an address from the fees.
1172     function isExcludedFromFees(address account) public view returns (bool) {
1173         return _isExcludedFromFees[account];
1174     }
1175 
1176     // The excludeFromDividends function enables the owner of the contract to exclude an address from dividends.
1177     function excludeFromDividends(address account) external onlyOwner {
1178         dividendTracker.excludeFromDividends(account);
1179     }
1180 
1181     // This setIntegrationToken function allows the contract owner to set a new integration token address.
1182     function setIntegrationToken (address newToken) external onlyOwner {
1183         intergrationToken = newToken;
1184     }
1185 
1186     // The claim function allows to claim dividends.
1187     function claim() external {
1188         dividendTracker.processAccount(payable(msg.sender), false);
1189     }
1190 
1191     // The claimOldDividend function allows to claim old dividends.
1192     function claimOldDividend(address tracker) external {
1193         TOKENDividendTracker oldTracker = TOKENDividendTracker(tracker);
1194         oldTracker.processAccount(payable(msg.sender), false);
1195     }
1196 
1197     // The _transfer function handles token transfers between different addresses (private function).
1198     function _transfer(
1199         address from,
1200         address to,
1201         uint256 amount
1202     ) internal override {
1203         require(from != address(0), "ERC20: transfer from the zero address");
1204         require(to != address(0), "ERC20: transfer to the zero address");
1205         if (amount == 0) {
1206             super._transfer(from, to, 0);
1207             return;
1208         }
1209 
1210         if (!_isExcludedFromFees[from]){
1211             require (isLaunched, "Trading is not active yet");
1212         }
1213 
1214         uint256 contractTokenBalance = balanceOf(address(this));
1215 
1216         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1217 
1218         if (
1219             canSwap &&
1220             !swapping &&
1221             !automatedMarketMakerPairs[from] &&
1222             from != owner() &&
1223             to != owner()
1224         ) {
1225             swapping = true;
1226 
1227             swapAndLiquify(contractTokenBalance);
1228            
1229             swapping = false;
1230         }
1231 
1232         bool takeFee = !swapping;
1233 
1234         // if any account belongs to _isExcludedFromFee account then remove the fee
1235         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1236             takeFee = false;
1237         }
1238 
1239        if (takeFee) {
1240             uint256 fees;
1241             uint256 burnAmount;
1242             if (!automatedMarketMakerPairs[to] && !_isExcludedFromMaxWallet[to]) {
1243                 require(
1244                     balanceOf(to) + amount <= maxWallet,
1245                     "Token: Balance exceeds Max Wallet limit"
1246                 );
1247             }
1248 
1249 
1250             
1251             if (automatedMarketMakerPairs[from] && !_isExcludedFromMaxTx[to]) {
1252                 require (amount <= maxTxAmount, "Buy: Max Tx limit exceeds");
1253                 fees = amount.mul(totalBuyFee).div(10000);
1254                 burnAmount = fees.mul(buyFee.burn).div(totalBuyFee);
1255                 
1256                 
1257             } else if (automatedMarketMakerPairs[to] && !_isExcludedFromMaxTx[from]) {
1258                 require (amount < maxTxAmount, "Sell: Max Tx limit exceeds");
1259                 fees = amount.mul(totalSellFee).div(10000);
1260                 burnAmount = fees.mul(buyFee.burn).div(totalBuyFee);
1261               
1262                 
1263             }
1264 
1265             if (fees > 0) {
1266                 amount = amount.sub(fees);
1267                 super._transfer(from, address(this), fees - burnAmount);
1268                 if (burnAmount > 0){
1269                 super._transfer(from, burnWallet, burnAmount);
1270                 }
1271             }
1272         }
1273 
1274         super._transfer(from, to, amount);
1275 
1276         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1277         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1278 
1279         if (!swapping) {
1280             uint256 gas = gasForProcessing;
1281 
1282             try dividendTracker.process(gas) returns (
1283                 uint256 iterations,
1284                 uint256 claims,
1285                 uint256 lastProcessedIndex
1286             ) {
1287                 emit ProcessedDividendTracker(
1288                     iterations,
1289                     claims,
1290                     lastProcessedIndex,
1291                     true,
1292                     gas,
1293                     tx.origin
1294                 );
1295             } catch {}
1296         }
1297     }
1298 
1299     // The setMaxTx function allows the owner of the contract to set a maximum limit for a transaction.
1300     // Max Transaction can't set below 1% of the supply.
1301     function setMaxTx (uint256 amount) external onlyOwner {
1302         require(amount >= (totalSupply().div(100)));
1303         maxTxAmount = amount;
1304     }
1305 
1306     // The setMaxWallet function allows the owner of the contract to set a maximum limit for a wallet.
1307     // Max Wallet can't be set below 1% of the supply.
1308     function setMaxWallet (uint256 amount) external onlyOwner {
1309         require (amount >= (totalSupply().div(100)));
1310         maxWallet = amount ;
1311     }
1312 
1313     // The excludeFromMaxTxLimit function allows the owner of the contract to exclude or include an account from the max transaction limit.
1314     function excludeFromMaxTxLimit (address _user, bool value) external onlyOwner {
1315         _isExcludedFromMaxTx[_user] = value;
1316     }
1317 
1318     // The excludeFromMaxWalletLimit function allows the owner of the contract to exclude or include an account from the max wallet limit.
1319     function excludeFromMaxWalletLimit (address _user, bool value) external onlyOwner {
1320         _isExcludedFromMaxWallet[_user] = value;
1321     }
1322 
1323     // The swapAndLiquify function enables swapping of tokens. 
1324     function swapAndLiquify(uint256 tokens) private {
1325         uint256 initialBalance = address(this).balance;
1326         uint256 totalFee = totalBuyFee + totalSellFee - buyFee.burn - sellFee.burn;
1327         uint256 swapTokens = tokens.mul(buyFee.staking + sellFee.staking + (buyFee.autoLP + sellFee.autoLP)/2
1328                                         + buyFee.dev + sellFee.dev + buyFee.treasury + sellFee.treasury + buyFee.partner
1329                                         + sellFee.partner + buyFee.integration + sellFee.integration).div(totalFee);
1330         uint256 liqTokens = tokens - swapTokens;
1331         swapTokensForETH(swapTokens);
1332         uint256 feePart = (buyFee.autoLP + sellFee.autoLP)/2;
1333 
1334         uint256 newBalance = address(this).balance.sub(initialBalance);
1335         uint256 stakingPart = newBalance.mul(buyFee.staking + sellFee.staking)
1336                                 .div(totalFee - feePart);
1337         uint256 treasuryPart = newBalance.mul(buyFee.treasury + sellFee.treasury)
1338                                 .div(totalFee- feePart);
1339         uint256 partnerPart = newBalance.mul(buyFee.partner + sellFee.partner)
1340                                 .div(totalFee - feePart);   
1341         uint256 devPart = newBalance.mul(buyFee.dev + sellFee.dev).div(totalFee - feePart);
1342         uint256 integrationPart = newBalance.mul(buyFee.integration + sellFee.integration).div(totalFee - feePart);  
1343                           
1344         
1345         if (partnerPart > 0){
1346         sendDividends(partnerPart); 
1347         }
1348         if (integrationPart > 0 ){
1349         swapETHforIntegration(integrationPart);
1350         }
1351         if (devPart > 0){
1352         sendToWallet(payable(devWallet), devPart);
1353         }
1354         if (treasuryPart > 0) {
1355         sendToWallet(payable(treasuryWallet), treasuryPart);
1356         }
1357         if (stakingPart > 0){
1358         sendToWallet(payable(stakingWallet), stakingPart);
1359         }
1360 
1361         if (address(this).balance > 0){
1362         
1363         addLiquidity(liqTokens, newBalance - stakingPart - treasuryPart - devPart - integrationPart - partnerPart);
1364         }
1365     }
1366 
1367     // The sendToWallet function sends ether to a payable address (private function).
1368     function sendToWallet(address payable wallet, uint256 amount) private {
1369         (bool success,) = wallet.call{value:amount}("");
1370         require(success,"eth transfer failed");
1371     }
1372 
1373     // The addLiquidity function adds liquidity to the pool (private function).
1374     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1375 
1376         // approve token transfer to cover all possible scenarios
1377         _approve(address(this), address(uniswapV2Router), tokenAmount);
1378 
1379         // add the liquidity
1380         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1381             address(this),
1382             tokenAmount,
1383             0, // slippage is unavoidable
1384             0, // slippage is unavoidable
1385             address(0),
1386             block.timestamp
1387         );
1388     }
1389 
1390     // The swapTokensForETH function swaps a certain amount of tokens for ETH (private function).
1391     function swapTokensForETH(uint256 tokenAmount) private {
1392         // generate the uniswap pair path of token -> weth
1393         address[] memory path = new address[](2);
1394         path[0] = address(this);
1395         path[1] = uniswapV2Router.WETH();
1396 
1397         _approve(address(this), address(uniswapV2Router), tokenAmount);
1398 
1399         // make the swap
1400         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1401             tokenAmount,
1402             0, // accept any amount of ETH
1403             path,
1404             address(this),
1405             block.timestamp
1406         );
1407     }
1408 
1409     // The swapETHforIntegration function swaps a certain amount of tokens for Integration token smart contract (private function).
1410     function swapETHforIntegration(uint256 amount) private {
1411         address[] memory path = new address[](2);
1412         path[0] = uniswapV2Router.WETH();
1413         path[1] = intergrationToken;
1414 
1415         // make the swap
1416         uniswapV2Router.swapExactETHForTokens{
1417             value: amount
1418         }(
1419             0, // accept any amount of Tokens
1420             path,
1421             integrationWallet, //receiver address
1422             block.timestamp
1423         );
1424     }
1425 
1426     // The swapETHforIntegration function swaps a certain amount of tokens for Partner token smart contract (private function).
1427     function swapTokensForpartnerToken(uint256 amount) private {
1428         address[] memory path = new address[](2);
1429         path[0] = uniswapV2Router.WETH();
1430         path[1] = partnerToken;
1431 
1432         // make the swap
1433         uniswapV2Router.swapExactETHForTokens{
1434             value: amount
1435         }(
1436             0, // accept any amount of Tokens
1437             path,
1438             address(this), 
1439             block.timestamp.add(300)
1440         );
1441     }
1442 
1443     // The airdrop function allows the owner to distribute tokens to a list of addresses.
1444     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
1445         require(
1446             addresses.length == amounts.length); //Array sizes must be equal
1447        for(uint256 i= 0; i < addresses.length; i++){
1448         _transfer(msg.sender, addresses[i], amounts[i] * 1e18);
1449        }
1450     }
1451 
1452     // The Toasted function allows the owner to transfer a certain amount of tokens from the pair to the burnWallet address.
1453     // Decrease amount of tokens in the pool, increase MCAP, increase token price.
1454     function toasted(uint256 _amount) external onlyOwner {
1455         _transfer(uniswapV2Pair, burnWallet, _amount);
1456     }
1457 
1458     // The sendDividends function sends dividends in the form of tokens to a specified address.
1459     function sendDividends(uint256 tokens) private {
1460         uint256 initialpartnerTokenBalance = IERC20(partnerToken).balanceOf(address(this));
1461 
1462         swapTokensForpartnerToken(tokens);
1463 
1464         uint256 newBalance = (IERC20(partnerToken).balanceOf(address(this))).sub(
1465             initialpartnerTokenBalance
1466         );
1467         bool success = IERC20(partnerToken).transfer(
1468             address(dividendTracker),
1469             (newBalance)
1470         );
1471 
1472         if (success) {
1473             dividendTracker.distributepartnerDividends(newBalance);
1474             emit SendDividends(newBalance);
1475         }
1476     }
1477 }
1478 
1479 contract TOKENDividendTracker is Ownable, DividendPayingToken {
1480     using SafeMath for uint256;
1481     using SafeMathInt for int256;
1482     using IterableMapping for IterableMapping.Map;
1483 
1484     IterableMapping.Map private tokenHoldersMap;
1485     uint256 public lastProcessedIndex;
1486 
1487     mapping(address => bool) public excludedFromDividends;
1488 
1489     mapping(address => uint256) public lastClaimTimes;
1490 
1491     uint256 public claimWait;
1492     uint256 public immutable minimumTokenBalanceForDividends;
1493 
1494     event ExcludeFromDividends(address indexed account);
1495     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1496 
1497     event Claim(
1498         address indexed account,
1499         uint256 amount,
1500         bool indexed automatic
1501     );
1502 
1503     constructor(address rewardToken)
1504         DividendPayingToken("PixiaAI_Dividend_Tracker", "PixiaAI_Dividend_Tracker", rewardToken)
1505     {
1506         claimWait = 3600;
1507         minimumTokenBalanceForDividends = 20000 * (10**18); //must hold 20000+ tokens to get rewards
1508     }
1509 
1510     function _transfer(
1511         address,
1512         address,
1513         uint256
1514     ) internal pure override {
1515         require(false);
1516     }
1517 
1518     function withdrawDividend() public pure override {
1519         require(
1520             false
1521         );
1522     }
1523 
1524     function excludeFromDividends(address account) external onlyOwner {
1525         require(!excludedFromDividends[account]);
1526         excludedFromDividends[account] = true;
1527 
1528         _setBalance(account, 0);
1529         tokenHoldersMap.remove(account);
1530 
1531         emit ExcludeFromDividends(account);
1532     }
1533 
1534     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1535         require(
1536             newClaimWait >= 3600 && newClaimWait <= 86400
1537         );
1538         require(
1539             newClaimWait != claimWait
1540         );
1541         emit ClaimWaitUpdated(newClaimWait, claimWait);
1542         claimWait = newClaimWait;
1543     }
1544 
1545     function getLastProcessedIndex() external view returns (uint256) {
1546         return lastProcessedIndex;
1547     }
1548 
1549     function getNumberOfTokenHolders() external view returns (uint256) {
1550         return tokenHoldersMap.keys.length;
1551     }
1552 
1553     function getAccount(address _account)
1554         public
1555         view
1556         returns (
1557             address account,
1558             int256 index,
1559             int256 iterationsUntilProcessed,
1560             uint256 withdrawableDividends,
1561             uint256 totalDividends,
1562             uint256 lastClaimTime,
1563             uint256 nextClaimTime,
1564             uint256 secondsUntilAutoClaimAvailable
1565         )
1566     {
1567         account = _account;
1568 
1569         index = tokenHoldersMap.getIndexOfKey(account);
1570 
1571         iterationsUntilProcessed = -1;
1572 
1573         if (index >= 0) {
1574             if (uint256(index) > lastProcessedIndex) {
1575                 iterationsUntilProcessed = index.sub(
1576                     int256(lastProcessedIndex)
1577                 );
1578             } else {
1579                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length >
1580                     lastProcessedIndex
1581                     ? tokenHoldersMap.keys.length.sub(lastProcessedIndex)
1582                     : 0;
1583 
1584                 iterationsUntilProcessed = index.add(
1585                     int256(processesUntilEndOfArray)
1586                 );
1587             }
1588         }
1589 
1590         withdrawableDividends = withdrawableDividendOf(account);
1591         totalDividends = accumulativeDividendOf(account);
1592 
1593         lastClaimTime = lastClaimTimes[account];
1594 
1595         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1596 
1597         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp
1598             ? nextClaimTime.sub(block.timestamp)
1599             : 0;
1600     }
1601 
1602     function getAccountAtIndex(uint256 index)
1603         public
1604         view
1605         returns (
1606             address,
1607             int256,
1608             int256,
1609             uint256,
1610             uint256,
1611             uint256,
1612             uint256,
1613             uint256
1614         )
1615     {
1616         if (index >= tokenHoldersMap.size()) {
1617             return (
1618                 0x0000000000000000000000000000000000000000,
1619                 -1,
1620                 -1,
1621                 0,
1622                 0,
1623                 0,
1624                 0,
1625                 0
1626             );
1627         }
1628 
1629         address account = tokenHoldersMap.getKeyAtIndex(index);
1630 
1631         return getAccount(account);
1632     }
1633 
1634     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1635         if (lastClaimTime > block.timestamp) {
1636             return false;
1637         }
1638 
1639         return block.timestamp.sub(lastClaimTime) >= claimWait;
1640     }
1641 
1642     function setBalance(address payable account, uint256 newBalance)
1643         external
1644         onlyOwner
1645     {
1646         if (excludedFromDividends[account]) {
1647             return;
1648         }
1649 
1650         if (newBalance >= minimumTokenBalanceForDividends) {
1651             _setBalance(account, newBalance);
1652             tokenHoldersMap.set(account, newBalance);
1653         } else {
1654             _setBalance(account, 0);
1655             tokenHoldersMap.remove(account);
1656         }
1657 
1658         processAccount(account, true);
1659     }
1660 
1661     function process(uint256 gas)
1662         public
1663         returns (
1664             uint256,
1665             uint256,
1666             uint256
1667         )
1668     {
1669         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1670 
1671         if (numberOfTokenHolders == 0) {
1672             return (0, 0, lastProcessedIndex);
1673         }
1674 
1675         uint256 _lastProcessedIndex = lastProcessedIndex;
1676 
1677         uint256 gasUsed = 0;
1678 
1679         uint256 gasLeft = gasleft();
1680 
1681         uint256 iterations = 0;
1682         uint256 claims = 0;
1683 
1684         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1685             _lastProcessedIndex++;
1686 
1687             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1688                 _lastProcessedIndex = 0;
1689             }
1690 
1691             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1692 
1693             if (canAutoClaim(lastClaimTimes[account])) {
1694                 if (processAccount(payable(account), true)) {
1695                     claims++;
1696                 }
1697             }
1698 
1699             iterations++;
1700 
1701             uint256 newGasLeft = gasleft();
1702 
1703             if (gasLeft > newGasLeft) {
1704                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1705             }
1706 
1707             gasLeft = newGasLeft;
1708         }
1709 
1710         lastProcessedIndex = _lastProcessedIndex;
1711 
1712         return (iterations, claims, lastProcessedIndex);
1713     }
1714 
1715     function processAccount(address payable account, bool automatic)
1716         public
1717         onlyOwner
1718         returns (bool)
1719     {
1720         uint256 amount = _withdrawDividendOfUser(account);
1721 
1722         if (amount > 0) {
1723             lastClaimTimes[account] = block.timestamp;
1724             emit Claim(account, amount, automatic);
1725             return true;
1726         }
1727 
1728         return false;
1729     }
1730 }