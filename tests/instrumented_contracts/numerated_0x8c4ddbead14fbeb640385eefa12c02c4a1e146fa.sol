1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.13;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 library EnumerableSet {
17 
18     struct Set {
19         bytes32[] _values;
20         mapping(bytes32 => uint256) _indexes;
21     }
22 
23     function _add(Set storage set, bytes32 value) private returns (bool) {
24         if (!_contains(set, value)) {
25             set._values.push(value);
26             set._indexes[value] = set._values.length;
27             return true;
28         } else {
29             return false;
30         }
31     }
32 
33     function _remove(Set storage set, bytes32 value) private returns (bool) {
34         uint256 valueIndex = set._indexes[value];
35 
36         if (valueIndex != 0) {
37             uint256 toDeleteIndex = valueIndex - 1;
38             uint256 lastIndex = set._values.length - 1;
39 
40             if (lastIndex != toDeleteIndex) {
41                 bytes32 lastValue = set._values[lastIndex];
42                 set._values[toDeleteIndex] = lastValue;
43                 set._indexes[lastValue] = valueIndex;
44             }
45 
46             set._values.pop();
47 
48             delete set._indexes[value];
49 
50             return true;
51         } else {
52             return false;
53         }
54     }
55 
56     function _contains(Set storage set, bytes32 value) private view returns (bool) {
57         return set._indexes[value] != 0;
58     }
59 
60     function _length(Set storage set) private view returns (uint256) {
61         return set._values.length;
62     }
63 
64     function _at(Set storage set, uint256 index) private view returns (bytes32) {
65         return set._values[index];
66     }
67 
68     function _values(Set storage set) private view returns (bytes32[] memory) {
69         return set._values;
70     }
71 
72 
73     // AddressSet
74 
75     struct AddressSet {
76         Set _inner;
77     }
78 
79     function add(AddressSet storage set, address value) internal returns (bool) {
80         return _add(set._inner, bytes32(uint256(uint160(value))));
81     }
82 
83     function remove(AddressSet storage set, address value) internal returns (bool) {
84         return _remove(set._inner, bytes32(uint256(uint160(value))));
85     }
86 
87     /**
88      * @dev Returns true if the value is in the set. O(1).
89      */
90     function contains(AddressSet storage set, address value) internal view returns (bool) {
91         return _contains(set._inner, bytes32(uint256(uint160(value))));
92     }
93 
94     /**
95      * @dev Returns the number of values in the set. O(1).
96      */
97     function length(AddressSet storage set) internal view returns (uint256) {
98         return _length(set._inner);
99     }
100 
101     function at(AddressSet storage set, uint256 index) internal view returns (address) {
102         return address(uint160(uint256(_at(set._inner, index))));
103     }
104 
105     function values(AddressSet storage set) internal view returns (address[] memory) {
106         bytes32[] memory store = _values(set._inner);
107         address[] memory result;
108 
109         /// @solidity memory-safe-assembly
110         assembly {
111             result := store
112         }
113 
114         return result;
115     }
116 }
117 
118 interface IERC20 {
119     function totalSupply() external view returns (uint256);
120     function balanceOf(address account) external view returns (uint256);
121     function transfer(address recipient, uint256 amount) external returns (bool);
122     function allowance(address owner, address spender) external view returns (uint256);
123     function approve(address spender, uint256 amount) external returns (bool);
124     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
125 
126     event Transfer(address indexed from, address indexed to, uint256 value);
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 
129     function name() external view returns (string memory);
130     function symbol() external view returns (string memory);
131     function decimals() external view returns (uint8);
132 }
133 
134 library SafeMathInt {
135     int256 private constant MIN_INT256 = int256(1) << 255;
136     int256 private constant MAX_INT256 = ~(int256(1) << 255);
137 
138     function mul(int256 a, int256 b) internal pure returns (int256) {
139         int256 c = a * b;
140 
141         // Detect overflow when multiplying MIN_INT256 with -1
142         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
143         require((b == 0) || (c / b == a));
144         return c;
145     }
146 
147     function div(int256 a, int256 b) internal pure returns (int256) {
148         // Prevent overflow when dividing MIN_INT256 by -1
149         require(b != -1 || a != MIN_INT256);
150 
151         // Solidity already throws when dividing by 0.
152         return a / b;
153     }
154 
155     function sub(int256 a, int256 b) internal pure returns (int256) {
156         int256 c = a - b;
157         require((b >= 0 && c <= a) || (b < 0 && c > a));
158         return c;
159     }
160 
161     function add(int256 a, int256 b) internal pure returns (int256) {
162         int256 c = a + b;
163         require((b >= 0 && c >= a) || (b < 0 && c < a));
164         return c;
165     }
166 
167     function abs(int256 a) internal pure returns (int256) {
168         require(a != MIN_INT256);
169         return a < 0 ? -a : a;
170     }
171 
172 
173     function toUint256Safe(int256 a) internal pure returns (uint256) {
174         require(a >= 0);
175         return uint256(a);
176     }
177 }
178 
179 library SafeMath {
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         require(c >= a, "SafeMath: addition overflow");
183 
184         return c;
185     }
186 
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return sub(a, b, "SafeMath: subtraction overflow");
189     }
190 
191     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b <= a, errorMessage);
193         uint256 c = a - b;
194 
195         return c;
196     }
197 
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         if (a == 0) {
200             return 0;
201         }
202 
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216 
217         return c;
218     }
219 
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 library SafeMathUint {
231   function toInt256Safe(uint256 a) internal pure returns (int256) {
232     int256 b = int256(a);
233     require(b >= 0);
234     return b;
235   }
236 }
237 
238 contract ERC20 is Context, IERC20 {
239     mapping(address => uint256) private _balances;
240 
241     mapping(address => mapping(address => uint256)) private _allowances;
242 
243     uint256 private _totalSupply;
244 
245     string private _name;
246     string private _symbol;
247 
248     constructor(string memory name_, string memory symbol_) {
249         _name = name_;
250         _symbol = symbol_;
251     }
252 
253     function name() public view virtual override returns (string memory) {
254         return _name;
255     }
256 
257     function symbol() public view virtual override returns (string memory) {
258         return _symbol;
259     }
260 
261     function decimals() public view virtual override returns (uint8) {
262         return 18;
263     }
264 
265     function totalSupply() public view virtual override returns (uint256) {
266         return _totalSupply;
267     }
268 
269     function balanceOf(address account) public view virtual override returns (uint256) {
270         return _balances[account];
271     }
272 
273     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
274         _transfer(_msgSender(), recipient, amount);
275         return true;
276     }
277 
278     function allowance(address owner, address spender) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public virtual override returns (bool) {
292         _transfer(sender, recipient, amount);
293 
294         uint256 currentAllowance = _allowances[sender][_msgSender()];
295         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
296         unchecked {
297             _approve(sender, _msgSender(), currentAllowance - amount);
298         }
299 
300         return true;
301     }
302 
303     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
304         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
305         return true;
306     }
307 
308     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
309         uint256 currentAllowance = _allowances[_msgSender()][spender];
310         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
311         unchecked {
312             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
313         }
314 
315         return true;
316     }
317 
318     function _transfer(
319         address sender,
320         address recipient,
321         uint256 amount
322     ) internal virtual {
323         require(sender != address(0), "ERC20: transfer from the zero address");
324         require(recipient != address(0), "ERC20: transfer to the zero address");
325 
326         uint256 senderBalance = _balances[sender];
327         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
328         unchecked {
329             _balances[sender] = senderBalance - amount;
330         }
331         _balances[recipient] += amount;
332 
333         emit Transfer(sender, recipient, amount);
334     }
335 
336     function _createInitialSupply(address account, uint256 amount) internal virtual {
337         require(account != address(0), "ERC20: to the zero address");
338 
339         _totalSupply += amount;
340         _balances[account] += amount;
341         emit Transfer(address(0), account, amount);
342     }
343 
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) internal virtual {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351 
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 }
356 
357 contract Ownable is Context {
358     address private _owner;
359 
360     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
361     
362     constructor () {
363         address msgSender = _msgSender();
364         _owner = msgSender;
365         emit OwnershipTransferred(address(0), msgSender);
366     }
367 
368     function owner() public view returns (address) {
369         return _owner;
370     }
371 
372     modifier onlyOwner() {
373         require(_owner == _msgSender(), "Ownable: caller is not the owner");
374         _;
375     }
376 
377     function renounceOwnership() external virtual onlyOwner {
378         emit OwnershipTransferred(_owner, address(0));
379         _owner = address(0);
380     }
381 
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         emit OwnershipTransferred(_owner, newOwner);
385         _owner = newOwner;
386     }
387 }
388 
389 interface IDexRouter {
390     function factory() external pure returns (address);
391     function WETH() external pure returns (address);
392     
393     function swapExactTokensForETHSupportingFeeOnTransferTokens(
394         uint amountIn,
395         uint amountOutMin,
396         address[] calldata path,
397         address to,
398         uint deadline
399     ) external;
400 
401     function swapExactETHForTokensSupportingFeeOnTransferTokens(
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline
406     ) external payable;
407 
408     function addLiquidityETH(
409         address token,
410         uint256 amountTokenDesired,
411         uint256 amountTokenMin,
412         uint256 amountETHMin,
413         address to,
414         uint256 deadline
415     )
416         external
417         payable
418         returns (
419             uint256 amountToken,
420             uint256 amountETH,
421             uint256 liquidity
422         );
423 
424     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
425 
426     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
427 
428 }
429 
430 interface IDexFactory {
431     function createPair(address tokenA, address tokenB)
432         external
433         returns (address pair);
434 }
435 
436 interface IDexPair {
437 
438     function name() external pure returns (string memory);
439     function symbol() external pure returns (string memory);
440     function decimals() external pure returns (uint8);
441     function totalSupply() external view returns (uint);
442     function balanceOf(address owner) external view returns (uint);
443     function allowance(address owner, address spender) external view returns (uint);
444 
445     function approve(address spender, uint value) external returns (bool);
446     function transfer(address to, uint value) external returns (bool);
447     function transferFrom(address from, address to, uint value) external returns (bool);
448 
449     function DOMAIN_SEPARATOR() external view returns (bytes32);
450     function PERMIT_TYPEHASH() external pure returns (bytes32);
451     function nonces(address owner) external view returns (uint);
452 
453     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
454 
455     function MINIMUM_LIQUIDITY() external pure returns (uint);
456     function factory() external view returns (address);
457     function token0() external view returns (address);
458     function token1() external view returns (address);
459     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
460     function price0CumulativeLast() external view returns (uint);
461     function price1CumulativeLast() external view returns (uint);
462     function kLast() external view returns (uint);
463 
464     function mint(address to) external returns (uint liquidity);
465     function burn(address to) external returns (uint amount0, uint amount1);
466     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
467     function skim(address to) external;
468     function sync() external;
469 
470     function initialize(address, address) external;
471 }
472 
473 interface DividendPayingTokenOptionalInterface {
474   /// @notice View the amount of dividend in wei that an address can withdraw.
475   /// @param _owner The address of a token holder.
476   /// @return The amount of dividend in wei that `_owner` can withdraw.
477   function withdrawableDividendOf(address _owner) external view returns(uint256);
478 
479   /// @notice View the amount of dividend in wei that an address has withdrawn.
480   /// @param _owner The address of a token holder.
481   /// @return The amount of dividend in wei that `_owner` has withdrawn.
482   function withdrawnDividendOf(address _owner) external view returns(uint256);
483 
484   /// @notice View the amount of dividend in wei that an address has earned in total.
485   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
486   /// @param _owner The address of a token holder.
487   /// @return The amount of dividend in wei that `_owner` has earned in total.
488   function accumulativeDividendOf(address _owner) external view returns(uint256);
489 }
490 
491 interface DividendPayingTokenInterface {
492   /// @notice View the amount of dividend in wei that an address can withdraw.
493   /// @param _owner The address of a token holder.
494   /// @return The amount of dividend in wei that `_owner` can withdraw.
495   function dividendOf(address _owner) external view returns(uint256);
496 
497   /// @notice Distributes ether to token holders as dividends.
498   /// @dev SHOULD distribute the paid ether to token holders as dividends.
499   ///  SHOULD NOT directly transfer ether to token holders in this function.
500   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
501   function distributeDividends() external payable;
502 
503   /// @notice Withdraws the ether distributed to the sender.
504   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
505   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
506   function withdrawDividend() external;
507 
508   /// @dev This event MUST emit when ether is distributed to token holders.
509   /// @param from The address which sends ether to this contract.
510   /// @param weiAmount The amount of distributed ether in wei.
511   event DividendsDistributed(
512     address indexed from,
513     uint256 weiAmount
514   );
515 
516   /// @dev This event MUST emit when an address withdraws their dividend.
517   /// @param to The address which withdraws ether from this contract.
518   /// @param weiAmount The amount of withdrawn ether in wei.
519   event DividendWithdrawn(
520     address indexed to,
521     uint256 weiAmount
522   );
523 }
524 
525 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
526   using SafeMath for uint256;
527   using SafeMathUint for uint256;
528   using SafeMathInt for int256;
529 
530   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
531   // For more discussion about choosing the value of `magnitude`,
532   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
533   uint256 constant internal magnitude = 2**128;
534 
535   uint256 internal magnifiedDividendPerShare;
536   
537   // About dividendCorrection:
538   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
539   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
540   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
541   //   `dividendOf(_user)` should not be changed,
542   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
543   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
544   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
545   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
546   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
547   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
548   mapping(address => int256) internal magnifiedDividendCorrections;
549   mapping(address => uint256) internal withdrawnDividends;
550 
551   mapping(address => uint256) public holderPendingRewards;
552   mapping(address => uint256) public holderRewardsUnlockTime;
553   uint256 public vestingTime = 3 days;
554   mapping(address => uint256) public holderRevokedRewards;
555   mapping(address => uint256) public holderRevokedRewardsOffset;
556   
557   mapping (address => uint256) public holderBalance;
558   uint256 public totalBalance;
559 
560   uint256 public totalDividendsDistributed;
561 
562   /// @dev Distributes dividends whenever ether is paid to this contract.
563   receive() external payable {
564     distributeDividends();
565   }
566 
567   /// @notice Distributes ether to token holders as dividends.
568   /// @dev It reverts if the total supply of tokens is 0.
569   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
570   /// About undistributed ether:
571   ///   In each distribution, there is a small amount of ether not distributed,
572   ///     the magnified amount of which is
573   ///     `(msg.value * magnitude) % totalSupply()`.
574   ///   With a well-chosen `magnitude`, the amount of undistributed ether
575   ///     (de-magnified) in a distribution can be less than 1 wei.
576   ///   We can actually keep track of the undistributed ether in a distribution
577   ///     and try to distribute it in the next distribution,
578   ///     but keeping track of such data on-chain costs much more than
579   ///     the saved ether, so we don't do that.
580     
581   function distributeDividends() public override payable { 
582       if(totalBalance > 0){
583         if (msg.value > 0) {
584           magnifiedDividendPerShare = magnifiedDividendPerShare.add(
585             (msg.value).mul(magnitude) / totalBalance
586           );
587           emit DividendsDistributed(msg.sender, msg.value);
588     
589           totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
590         }
591       }
592   }
593 
594   function updateVestingTime(uint256 timeInHours) external onlyOwner {
595       require(timeInHours * 1 hours <= 5 days, "Cannot set vesting period longer than 5 days");
596       vestingTime = timeInHours * 1 hours;
597   }
598   
599   /// @notice Withdraws the ether distributed to the sender.
600   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
601   function withdrawDividend() external virtual override {
602     _withdrawDividendOfUser(payable(msg.sender));
603   }
604 
605   /// @notice Withdraws the ether distributed to the sender.
606   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
607   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
608     uint256 _withdrawableDividend = withdrawableDividendOf(user);
609     if (_withdrawableDividend > 0) {
610       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
611       emit DividendWithdrawn(user, _withdrawableDividend);
612       (bool success,) = user.call{value: _withdrawableDividend+holderPendingRewards[user], gas: 3000}("");
613 
614       if(!success) {
615         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
616         return 0;
617       }
618 
619       return _withdrawableDividend;
620     }
621 
622     return 0;
623   }
624 
625   function _shiftDividendOfUser(address payable user) internal {
626     uint256 _withdrawableDividend = withdrawableDividendOf(user);
627     if (_withdrawableDividend > 0) {
628       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
629       holderPendingRewards[user] += _withdrawableDividend;
630     }
631   }
632 
633 
634   /// @notice View the amount of dividend in wei that an address can withdraw.
635   /// @param _owner The address of a token holder.
636   /// @return The amount of dividend in wei that `_owner` can withdraw.
637   function dividendOf(address _owner) external view override returns(uint256) {
638     return withdrawableDividendOf(_owner);
639   }
640 
641   /// @notice View the amount of dividend in wei that an address can withdraw.
642   /// @param _owner The address of a token holder.
643   /// @return The amount of dividend in wei that `_owner` can withdraw.
644   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
645     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
646   }
647 
648   /// @notice View the amount of dividend in wei that an address has withdrawn.
649   /// @param _owner The address of a token holder.
650   /// @return The amount of dividend in wei that `_owner` has withdrawn.
651   function withdrawnDividendOf(address _owner) external view override returns(uint256) {
652     return withdrawnDividends[_owner];
653   }
654 
655 
656   /// @notice View the amount of dividend in wei that an address has earned in total.
657   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
658   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
659   /// @param _owner The address of a token holder.
660   /// @return The amount of dividend in wei that `_owner` has earned in total.
661   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
662     return magnifiedDividendPerShare.mul(holderBalance[_owner]).toInt256Safe()
663       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
664   }
665 
666   /// @dev Internal function that increases tokens to an account.
667   /// Update magnifiedDividendCorrections to keep dividends unchanged.
668   /// @param account The account that will receive the created tokens.
669   /// @param value The amount that will be created.
670   function _increase(address account, uint256 value) internal {
671     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
672       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
673   }
674 
675   /// @dev Internal function that reduces an amount of the token of a given account.
676   /// Update magnifiedDividendCorrections to keep dividends unchanged.
677   /// @param account The account whose tokens will be burnt.
678   /// @param value The amount that will be burnt.
679   function _reduce(address account, uint256 value) internal {
680     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
681       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
682   }
683 
684   function _setBalance(address account, uint256 newBalance) internal {
685     uint256 currentBalance = holderBalance[account];
686     holderBalance[account] = newBalance;
687     if(newBalance > currentBalance) {
688       uint256 increaseAmount = newBalance.sub(currentBalance);
689       _increase(account, increaseAmount);
690       totalBalance += increaseAmount;
691     } else if(newBalance < currentBalance) {
692       uint256 reduceAmount = currentBalance.sub(newBalance);
693       _reduce(account, reduceAmount);
694       totalBalance -= reduceAmount;
695     }
696   }
697 
698   function setHolderRewardsUnlockTime(address account, uint256 newTime) external onlyOwner {
699       holderRewardsUnlockTime[account] = newTime;
700   }
701 
702   
703 }
704 
705 contract DividendTracker is DividendPayingToken {
706     using SafeMath for uint256;
707     using SafeMathInt for int256;
708 
709     mapping (address => uint256) public holderRewardsRevoked;
710 
711     struct Map {
712         address[] keys;
713         mapping(address => uint) values;
714         mapping(address => uint) indexOf;
715         mapping(address => bool) inserted;
716     }
717 
718     function get(address key) private view returns (uint) {
719         return tokenHoldersMap.values[key];
720     }
721 
722     function getIndexOfKey(address key) private view returns (int) {
723         if(!tokenHoldersMap.inserted[key]) {
724             return -1;
725         }
726         return int(tokenHoldersMap.indexOf[key]);
727     }
728 
729     function getKeyAtIndex(uint index) private view returns (address) {
730         return tokenHoldersMap.keys[index];
731     }
732 
733 
734 
735     function size() private view returns (uint) {
736         return tokenHoldersMap.keys.length;
737     }
738 
739     function set(address key, uint val) private {
740         if (tokenHoldersMap.inserted[key]) {
741             tokenHoldersMap.values[key] = val;
742         } else {
743             tokenHoldersMap.inserted[key] = true;
744             tokenHoldersMap.values[key] = val;
745             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
746             tokenHoldersMap.keys.push(key);
747         }
748     }
749 
750     function remove(address key) private {
751         if (!tokenHoldersMap.inserted[key]) {
752             return;
753         }
754 
755         delete tokenHoldersMap.inserted[key];
756         delete tokenHoldersMap.values[key];
757 
758         uint index = tokenHoldersMap.indexOf[key];
759         uint lastIndex = tokenHoldersMap.keys.length - 1;
760         address lastKey = tokenHoldersMap.keys[lastIndex];
761 
762         tokenHoldersMap.indexOf[lastKey] = index;
763         delete tokenHoldersMap.indexOf[key];
764 
765         tokenHoldersMap.keys[index] = lastKey;
766         tokenHoldersMap.keys.pop();
767     }
768 
769     Map private tokenHoldersMap;
770     uint256 public lastProcessedIndex;
771 
772     mapping (address => bool) public excludedFromDividends;
773 
774     mapping (address => uint256) public lastClaimTimes;
775 
776     uint256 public claimWait;
777     uint256 public immutable minimumTokenBalanceForDividends;
778 
779     event ExcludeFromDividends(address indexed account);
780     event IncludeInDividends(address indexed account);
781     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
782 
783     event Claim(address indexed account, uint256 amount, bool indexed automatic);
784 
785     constructor() {
786     	claimWait = 1200;
787         minimumTokenBalanceForDividends = 1000 * (1e18);
788     }
789 
790     function excludeFromDividends(address account) external onlyOwner {
791     	excludedFromDividends[account] = true;
792 
793     	_setBalance(account, 0);
794     	remove(account);
795 
796     	emit ExcludeFromDividends(account);
797     }
798     
799     function includeInDividends(address account) external onlyOwner {
800     	require(excludedFromDividends[account]);
801     	excludedFromDividends[account] = false;
802 
803     	emit IncludeInDividends(account);
804     }
805 
806     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
807         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
808         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
809         emit ClaimWaitUpdated(newClaimWait, claimWait);
810         claimWait = newClaimWait;
811     }
812 
813     function getLastProcessedIndex() external view returns(uint256) {
814     	return lastProcessedIndex;
815     }
816 
817     function getNumberOfTokenHolders() external view returns(uint256) {
818         return tokenHoldersMap.keys.length;
819     }
820 
821     function getAccount(address _account)
822         public view returns (
823             address account,
824             int256 index,
825             int256 iterationsUntilProcessed,
826             uint256 withdrawableDividends,
827             uint256 totalDividends,
828             uint256 lastClaimTime,
829             uint256 nextClaimTime,
830             uint256 secondsUntilAutoClaimAvailable,
831             uint256 revokedRewards,
832             uint256 holderRewardsUnlock) {
833         account = _account;
834 
835         index = getIndexOfKey(account);
836 
837         iterationsUntilProcessed = -1;
838 
839         if(index >= 0) {
840             if(uint256(index) > lastProcessedIndex) {
841                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
842             }
843             else {
844                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
845                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
846                                                         0;
847 
848 
849                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
850             }
851         }
852 
853 
854         withdrawableDividends = withdrawableDividendOf(account)+holderPendingRewards[account];
855         totalDividends = accumulativeDividendOf(account) - holderRevokedRewardsOffset[_account];
856 
857         lastClaimTime = lastClaimTimes[account];
858 
859         nextClaimTime = lastClaimTime > 0 ?
860                                     lastClaimTime.add(claimWait) :
861                                     0;
862 
863         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
864                                                     nextClaimTime.sub(block.timestamp) :
865                                                     0;
866         
867         revokedRewards = holderRevokedRewards[account];
868         holderRewardsUnlock = holderRewardsUnlockTime[account];
869     }
870 
871     function getAccountAtIndex(uint256 index)
872         external view returns (
873             address,
874             int256,
875             int256,
876             uint256,
877             uint256,
878             uint256,
879             uint256,
880             uint256,
881             uint256,
882             uint256) {
883     	if(index >= size()) {
884             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0, 0, 0);
885         }
886 
887         address account = getKeyAtIndex(index);
888 
889         return getAccount(account);
890     }
891 
892     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
893     	if(lastClaimTime > block.timestamp)  {
894     		return false;
895     	}
896 
897     	return block.timestamp.sub(lastClaimTime) >= claimWait;
898     }
899 
900     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
901     	if(excludedFromDividends[account]) {
902     		return;
903     	}
904 
905     	if(newBalance >= minimumTokenBalanceForDividends){
906             _setBalance(account, newBalance);
907     		set(account, newBalance);
908     	}
909     	else {
910             _setBalance(account, 0);
911     		remove(account);
912     	}
913 
914     	processAccount(account, true);
915     }
916     
917     function processAccount(address payable account, bool automatic) public onlyOwner {
918         if(holderRewardsUnlockTime[account] > block.timestamp){
919             _shiftDividendOfUser(account);
920         } else {
921             uint256 amount = _withdrawDividendOfUser(account);
922             if(amount > 0) {
923                 lastClaimTimes[account] = block.timestamp;
924                 emit Claim(account, amount, automatic);
925             }
926         }
927     }
928 
929     function revokeRewards(address account) external onlyOwner {
930         uint256 rewardsToRevoke = withdrawableDividendOf(account)+holderPendingRewards[account];
931         if(rewardsToRevoke > 0){
932             holderPendingRewards[account] = 0;
933             holderRevokedRewards[account] += rewardsToRevoke;
934             holderRevokedRewardsOffset[account] += rewardsToRevoke;
935             withdrawnDividends[account] = withdrawnDividends[account].add(withdrawableDividendOf(account));
936             
937             bool success;
938             (success,) = address(this).call{value: rewardsToRevoke}("");
939             
940             totalDividendsDistributed -= rewardsToRevoke;
941             holderRevokedRewards[account] -= withdrawableDividendOf(account);
942         }
943     }
944 }
945 
946 contract Mizbeah is ERC20, Ownable {
947 
948     using EnumerableSet for EnumerableSet.AddressSet;
949 
950     uint256 public maxBuyAmount;
951     uint256 public maxSellAmount;
952     uint256 public maxWalletAmount;
953 
954     uint256 public buyMultiplier = 0;
955     uint256 public sellMultiplier = 20;
956 
957     EnumerableSet.AddressSet private buyerList;
958     uint256 public nextLotteryTime;
959     uint256 public timeBetweenLotteries = 24 hours;
960     uint256 public minBuyAmount = .1 ether;
961     bool public minBuyEnforced = true;
962     uint256 public percentForLottery = 50;
963     bool public lotteryEnabled = false;
964 
965     uint256 public lastBurnTimestamp;
966 
967     DividendTracker public immutable dividendTracker;
968 
969     IDexRouter public dexRouter;
970     address public lpPair;
971 
972     bool private swapping;
973     uint256 public swapTokensAtAmount;
974 
975     address operationsAddress;
976 
977     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
978     uint256 public blockForPenaltyEnd;
979     mapping (address => bool) public restrictedWallet;
980     uint256 public botsCaught;
981 
982     bool public limitsInEffect = true;
983     bool public tradingActive = false;
984     bool public swapEnabled = false;
985     
986      // Anti-bot and anti-whale mappings and variables
987     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
988     bool public transferDelayEnabled = true;
989 
990     uint256 public buyTotalFees;
991     uint256 public buyOperationsFee;
992     uint256 public buyLiquidityFee;
993     uint256 public buyRewardsFee;
994     uint256 public buyLotteryFee;
995 
996     uint256 public sellTotalFees;
997     uint256 public sellOperationsFee;
998     uint256 public sellLiquidityFee;
999     uint256 public sellRewardsFee;
1000     uint256 public sellLotteryFee;
1001 
1002     uint256 public tokensForOperations;
1003     uint256 public tokensForLiquidity;
1004     uint256 public tokensForRewards;
1005     uint256 public tokensForLottery;
1006 
1007     uint256 public FEE_DENOMINATOR = 10000;
1008     
1009     /******************/
1010 
1011     // exlcude from fees and max transaction amount
1012     mapping (address => bool) public _isExcludedFromFees;
1013     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1014 
1015     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1016     // could be subject to a maximum transfer amount
1017     mapping (address => bool) public automatedMarketMakerPairs;
1018 
1019     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1020 
1021     event EnabledTrading();
1022 
1023     event RemovedLimits();
1024 
1025     event ExcludeFromFees(address indexed account, bool isExcluded);
1026 
1027     event UpdatedMaxBuyAmount(uint256 newAmount);
1028 
1029     event UpdatedMaxSellAmount(uint256 newAmount);
1030 
1031     event UpdatedMaxWalletAmount(uint256 newAmount);
1032 
1033     event UpdatedOperationsAddress(address indexed newWallet);
1034 
1035     event MaxTransactionExclusion(address _address, bool excluded);
1036 
1037     event BuyBackTriggered(uint256 amount);
1038 
1039     event OwnerForcedSwapBack(uint256 timestamp);
1040 
1041     event CaughtBot(address sniper);
1042 
1043     event TransferForeignToken(address token, uint256 amount);
1044 
1045     event LotteryTriggered(uint256 indexed amount, address indexed wallet);
1046 
1047     constructor() ERC20("Mizbeah", "Seh") {
1048         
1049         address newOwner = 0x5B4828b9984DB461607073Ec5935138AB619F87F;
1050 
1051         dividendTracker = new DividendTracker();
1052 
1053         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1054         dexRouter = _dexRouter;
1055 
1056         operationsAddress = address(0x5B4828b9984DB461607073Ec5935138AB619F87F); // for prod
1057 
1058         // create pair
1059         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
1060         _excludeFromMaxTransaction(address(lpPair), true);
1061         _setAutomatedMarketMakerPair(address(lpPair), true);
1062 
1063         uint256 totalSupply = 1 * 1e9 * 1e18;
1064 
1065         uint256 mockSupply = 888 * 1e6 * 1e18;
1066         
1067         maxBuyAmount = mockSupply * 2 / 1000;
1068         maxSellAmount = mockSupply * 2 / 1000;
1069         maxWalletAmount = mockSupply * 2 / 100;
1070         swapTokensAtAmount = mockSupply * 25 / 100000;
1071 
1072         buyOperationsFee = 200;
1073         buyLiquidityFee = 400;
1074         buyRewardsFee = 400;
1075         buyLotteryFee = 0;
1076         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyRewardsFee + buyLotteryFee;
1077 
1078         sellOperationsFee = 200;
1079         sellLiquidityFee = 400;
1080         sellRewardsFee = 400;
1081         sellLotteryFee = 0;
1082         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellRewardsFee + sellLotteryFee;
1083 
1084         _excludeFromMaxTransaction(newOwner, true);
1085         _excludeFromMaxTransaction(msg.sender, true);
1086         _excludeFromMaxTransaction(operationsAddress, true);
1087         _excludeFromMaxTransaction(address(this), true);
1088         _excludeFromMaxTransaction(address(0xdead), true);
1089         _excludeFromMaxTransaction(address(dexRouter), true);
1090 
1091         // exclude from receiving dividends
1092         dividendTracker.excludeFromDividends(address(dividendTracker));
1093         dividendTracker.excludeFromDividends(address(this));
1094         dividendTracker.excludeFromDividends(msg.sender);
1095         dividendTracker.excludeFromDividends(address(dexRouter));
1096         dividendTracker.excludeFromDividends(address(0xdead));
1097 
1098         excludeFromFees(newOwner, true);
1099         excludeFromFees(msg.sender, true);
1100         excludeFromFees(operationsAddress, true);
1101         excludeFromFees(address(this), true);
1102         excludeFromFees(address(0xdead), true);
1103         excludeFromFees(address(dexRouter), true);
1104 
1105         _createInitialSupply(newOwner, mockSupply*35/100);
1106         _createInitialSupply(msg.sender, mockSupply*20/100);
1107         _createInitialSupply(address(0xdead), mockSupply*45/100 + (totalSupply - mockSupply));
1108     }
1109 
1110     receive() external payable {}
1111 
1112     function isWalletLotteryEligible(address account) external view returns (bool){
1113         return buyerList.contains(account);
1114     }
1115     
1116     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
1117         require(blockForPenaltyEnd == 0);
1118         tradingActive = true;
1119         swapEnabled = true;
1120         tradingActiveBlock = block.number;
1121         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1122         nextLotteryTime = block.timestamp + timeBetweenLotteries;
1123         emit EnabledTrading();
1124     }
1125     
1126     // remove limits after token is stable
1127     function removeLimits() external onlyOwner {
1128         limitsInEffect = false;
1129         transferDelayEnabled = false;
1130         emit RemovedLimits();
1131     }
1132 
1133     function updateTradingActive(bool active) external onlyOwner {
1134         tradingActive = active;
1135     }
1136 
1137     function setLotteryEnabled(bool enabled) external onlyOwner {
1138         lotteryEnabled = enabled;
1139     }
1140 
1141     function setBuyMultiplier(uint256 multiplier) external onlyOwner {
1142         require(multiplier <=20);
1143         buyMultiplier = multiplier;
1144     }
1145 
1146     function setSellMultiplier(uint256 multiplier) external onlyOwner {
1147         require(multiplier <=20);
1148         sellMultiplier = multiplier;
1149     }
1150 
1151     function manageRestrictedWallets(address[] calldata wallets, bool restricted) external onlyOwner {
1152         for(uint256 i = 0; i < wallets.length; i++){
1153             restrictedWallet[wallets[i]] = restricted;
1154             if(restricted){
1155                 dividendTracker.revokeRewards(wallets[i]);
1156                 dividendTracker.excludeFromDividends(wallets[i]);
1157             } else {
1158                 dividendTracker.includeInDividends(wallets[i]);
1159             }
1160         }
1161     }
1162     
1163     // disable Transfer delay
1164     function disableTransferDelay() external onlyOwner {
1165         transferDelayEnabled = false;
1166     }
1167 
1168     function enableTransferDelay() external onlyOwner {
1169         transferDelayEnabled = true;
1170     }
1171 
1172     function calculatePriceImpact(uint256 value) public view returns (uint256) {
1173         value = value * 998 / 1000;
1174 
1175         IDexPair pair = IDexPair((address(lpPair)));
1176 
1177         (uint256 r0, uint256 r1,) = pair.getReserves();
1178 
1179         IERC20 token0 = IERC20(pair.token0());
1180         IERC20 token1 = IERC20(pair.token1());
1181 
1182         if(address(token1) == address(this)) {
1183             IERC20 tokenTemp = token0;
1184             token0 = token1;
1185             token1 = tokenTemp;
1186 
1187             uint256 rTemp = r0;
1188             r0 = r1;
1189             r1 = rTemp;
1190         }
1191 
1192         uint256 product = r0 * r1;
1193 
1194         uint256 r0After = r0 + value;
1195         uint256 r1After = product / r0After;
1196 
1197         return (10000 - (r1After * 10000 / r1)) * 998 / 1000;
1198     }
1199     
1200     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
1201         require(newNum >= (totalSupply() * 2 / 1000) / 1e18);
1202         maxBuyAmount = newNum * (1e18);
1203         emit UpdatedMaxBuyAmount(maxBuyAmount);
1204     }
1205     
1206     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
1207         require(newNum >= (totalSupply() * 2 / 1000) / 1e18);
1208         maxSellAmount = newNum * (1e18);
1209         emit UpdatedMaxSellAmount(maxSellAmount);
1210     }
1211 
1212     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1213         require(newNum >= (totalSupply() * 3 / 1000) / 1e18);
1214         maxWalletAmount = newNum * (1e18);
1215         emit UpdatedMaxWalletAmount(maxWalletAmount);
1216     }
1217 
1218     // change the minimum amount of tokens to sell from fees
1219     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
1220   	    require(newAmount >= totalSupply() * 1 / 100000);
1221   	    require(newAmount <= totalSupply() * 1 / 1000);
1222   	    swapTokensAtAmount = newAmount;
1223   	}
1224     
1225     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
1226         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
1227         emit MaxTransactionExclusion(updAds, isExcluded);
1228     }
1229 
1230     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
1231         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
1232         require(wallets.length < 200); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1233         for(uint256 i = 0; i < wallets.length; i++){
1234             super._transfer(msg.sender, wallets[i], amountsInTokens[i]);
1235             dividendTracker.setBalance(payable(wallets[i]), balanceOf(wallets[i]));
1236             dividendTracker.setHolderRewardsUnlockTime(payable(wallets[i]), dividendTracker.vestingTime() + block.timestamp);
1237         }
1238     }
1239     
1240     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
1241         if(!isEx){
1242             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
1243         }
1244         _isExcludedMaxTransactionAmount[updAds] = isEx;
1245     }
1246 
1247     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1248         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
1249 
1250         _setAutomatedMarketMakerPair(pair, value);
1251         emit SetAutomatedMarketMakerPair(pair, value);
1252     }
1253 
1254     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1255         automatedMarketMakerPairs[pair] = value;
1256         
1257         _excludeFromMaxTransaction(pair, value);
1258 
1259         if(value) {
1260             dividendTracker.excludeFromDividends(pair);
1261         }
1262 
1263         emit SetAutomatedMarketMakerPair(pair, value);
1264     }
1265 
1266     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _rewardsFee, uint256 _lotteryFee) external onlyOwner {
1267         buyOperationsFee = _operationsFee;
1268         buyLiquidityFee = _liquidityFee;
1269         buyRewardsFee = _rewardsFee;
1270         buyLotteryFee = _lotteryFee;
1271         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyRewardsFee + buyLotteryFee;
1272         require(buyTotalFees <= 1500, "Must keep fees at 15% or less");
1273     }
1274 
1275     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _rewardsFee, uint256 _lotteryFee) external onlyOwner {
1276         sellOperationsFee = _operationsFee;
1277         sellLiquidityFee = _liquidityFee;
1278         sellRewardsFee = _rewardsFee;
1279         sellLotteryFee = _lotteryFee;
1280         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellRewardsFee + sellLotteryFee;
1281         require(sellTotalFees <= 2000, "Must keep fees at 20% or less");
1282     }
1283 
1284     function excludeFromFees(address account, bool excluded) public onlyOwner {
1285         _isExcludedFromFees[account] = excluded;
1286         emit ExcludeFromFees(account, excluded);
1287     }
1288 
1289     function _transfer(address from, address to, uint256 amount) internal override {
1290 
1291         require(from != address(0), "ERC20: transfer from the zero address");
1292         require(to != address(0), "ERC20: transfer to the zero address");
1293         require(amount > 0, "ERC20: transfer must be greater than 0");
1294         
1295         if(!tradingActive){
1296             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1297         }
1298 
1299         if(!earlyBuyPenaltyInEffect() && blockForPenaltyEnd > 0){
1300             require(!restrictedWallet[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
1301         }
1302         
1303         if(limitsInEffect){
1304             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
1305                 
1306                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1307                 if (transferDelayEnabled){
1308                     if (to != address(dexRouter) && to != address(lpPair)){
1309                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2);
1310                         _holderLastTransferTimestamp[tx.origin] = block.number;
1311                         _holderLastTransferTimestamp[to] = block.number;
1312                     }
1313                 }
1314                  
1315                 //when buy
1316                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1317                         require(amount <= maxBuyAmount);
1318                         require(amount + balanceOf(to) <= maxWalletAmount);
1319                 } 
1320                 //when sell
1321                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1322                         require(amount <= maxSellAmount);
1323                 } 
1324                 else if (!_isExcludedMaxTransactionAmount[to]){
1325                     require(amount + balanceOf(to) <= maxWalletAmount);
1326                 }
1327             }
1328         }
1329 
1330         uint256 contractTokenBalance = balanceOf(address(this));
1331         
1332         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1333 
1334         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1335             swapping = true;
1336             swapBack();
1337             swapping = false;
1338         }
1339 
1340         if(lotteryEnabled){
1341             if(block.timestamp >= nextLotteryTime && address(this).balance > 0.1 ether && buyerList.length() > 1){
1342                 payoutRewards(to);
1343             }
1344             else {
1345                 gasBurn();
1346             }
1347         }
1348 
1349         bool takeFee = true;
1350         // if any account belongs to _isExcludedFromFee account then remove the fee
1351         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1352             takeFee = false;
1353         }
1354         
1355         uint256 fees = 0;
1356         // only take fees on buys/sells, do not take on wallet transfers
1357         if(takeFee){
1358             // bot/sniper penalty.
1359             if((earlyBuyPenaltyInEffect() || (amount >= maxBuyAmount - .9 ether && blockForPenaltyEnd + 5 >= block.number)) && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
1360                 
1361                 if(!earlyBuyPenaltyInEffect()){
1362                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
1363                     maxBuyAmount -= 1;
1364                 }
1365 
1366                 if(!restrictedWallet[to]){
1367                     restrictedWallet[to] = true;
1368                     botsCaught += 1;
1369                     emit CaughtBot(to);
1370                 }
1371 
1372                 fees = amount * (buyTotalFees) / FEE_DENOMINATOR;
1373         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1374                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
1375                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
1376                 tokensForLottery += fees * buyLotteryFee / buyTotalFees;
1377                 dividendTracker.excludeFromDividends(to);
1378             }
1379 
1380             // on sell
1381             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1382                 uint256 increasedSellTax = calculatePriceImpact(amount)*sellMultiplier;
1383                 if(sellTotalFees + increasedSellTax >= 3000){
1384                     increasedSellTax = 3000 - sellTotalFees;
1385                 }
1386                 fees = amount * (sellTotalFees + increasedSellTax) / FEE_DENOMINATOR;
1387                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1388                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
1389                 tokensForRewards += fees * sellRewardsFee / sellTotalFees;
1390                 tokensForLottery += fees * sellLotteryFee / sellTotalFees;
1391                 dividendTracker.setHolderRewardsUnlockTime(from, dividendTracker.vestingTime() + block.timestamp);
1392             }
1393 
1394             // on buy
1395             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1396                 uint256 reducedBuyTax = calculatePriceImpact(amount)*buyMultiplier;
1397                 if(buyTotalFees < reducedBuyTax){
1398                     reducedBuyTax = buyTotalFees;
1399                 }
1400         	    fees = amount * (buyTotalFees - reducedBuyTax) / FEE_DENOMINATOR;
1401         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1402                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
1403                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
1404                 tokensForLottery += fees * buyLotteryFee / buyTotalFees;
1405                 if(!minBuyEnforced || amount > getPurchaseAmount()){
1406                     if(!buyerList.contains(to)){
1407                         buyerList.add(to);
1408                     }
1409                 }
1410             }
1411             
1412             if(fees > 0){    
1413                 super._transfer(from, address(this), fees);
1414             }
1415         	
1416         	amount -= fees;
1417         }
1418 
1419         if(dividendTracker.holderRewardsUnlockTime(to) == 0){
1420             dividendTracker.setHolderRewardsUnlockTime(to, dividendTracker.vestingTime() + block.timestamp);
1421         }
1422 
1423         super._transfer(from, to, amount);
1424 
1425         dividendTracker.setBalance(payable(from), balanceOf(from));
1426         dividendTracker.setBalance(payable(to), balanceOf(to));
1427 
1428         if(dividendTracker.holderRewardsUnlockTime(from) > block.timestamp && takeFee){
1429             dividendTracker.revokeRewards(from);
1430         }
1431 
1432         if(buyerList.contains(from) && takeFee){
1433             buyerList.remove(from);
1434         }
1435 
1436     }
1437 
1438     function earlyBuyPenaltyInEffect() public view returns (bool){
1439         return block.number < blockForPenaltyEnd;
1440     }
1441 
1442     // the purpose of this function is to fix Metamask gas estimation issues so it always consumes a similar amount of gas whether there is a payout or not.
1443     function gasBurn() private {
1444         bool success;
1445         nextLotteryTime = nextLotteryTime;
1446         uint256 winnings = address(this).balance / 2;
1447         address winner = address(this);
1448         winnings = 0;
1449         (success,) = address(winner).call{value: winnings}("");
1450     }
1451     
1452     function payoutRewards(address to) private {
1453         bool success;
1454         nextLotteryTime = block.timestamp + timeBetweenLotteries;
1455         // get a pseudo random winner
1456         address winner = buyerList.at(random(0, buyerList.length()-1, balanceOf(address(this)) + balanceOf(address(0xdead)) + balanceOf(address(to))));
1457         uint256 winnings = address(this).balance * percentForLottery / 100;
1458         (success,) = address(winner).call{value: winnings}("");
1459         if(success){
1460             emit LotteryTriggered(winnings, winner);
1461         }
1462     }
1463 
1464     function random(uint256 from, uint256 to, uint256 salty) private view returns (uint256) {
1465         uint256 seed = uint256(
1466             keccak256(
1467                 abi.encodePacked(
1468                     block.timestamp + block.difficulty +
1469                     ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
1470                     block.gaslimit +
1471                     ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
1472                     block.number +
1473                     salty
1474                 )
1475             )
1476         );
1477         return seed % (to - from) + from;
1478     }
1479 
1480     function getPurchaseAmount() public view returns (uint256){
1481         address[] memory path = new address[](2);
1482         path[0] = dexRouter.WETH();
1483         path[1] = address(this);
1484         
1485         uint256[] memory amounts = new uint256[](2);
1486         amounts = dexRouter.getAmountsOut(minBuyAmount, path);
1487         return amounts[1];
1488     }
1489 
1490     function updateLotteryTimeCooldown(uint256 timeInHours) external onlyOwner {
1491         require(timeInHours >= 1 && timeInHours <= 24);
1492         timeBetweenLotteries = timeInHours * 1 hours;
1493     }
1494 
1495     function updatePercentForLottery(uint256 percent) external onlyOwner {
1496         require(percent >= 1 && percent <= 100);
1497         percentForLottery = percent;
1498     }
1499 
1500     function updateMinBuyToTriggerReward(uint256 minBuy) external onlyOwner {
1501         require(minBuy > 0);
1502         minBuyAmount = minBuy;
1503     }
1504 
1505     function setMinBuyEnforced(bool enforced) external onlyOwner {
1506         minBuyEnforced = enforced;
1507     }
1508 
1509     function updateVestingTime(uint256 timeInHours) external onlyOwner {
1510         dividendTracker.updateVestingTime(timeInHours);
1511     }
1512 
1513     function swapTokensForEth(uint256 tokenAmount) private {
1514 
1515         // generate the uniswap pair path of token -> weth
1516         address[] memory path = new address[](2);
1517         path[0] = address(this);
1518         path[1] = dexRouter.WETH();
1519 
1520         _approve(address(this), address(dexRouter), tokenAmount);
1521 
1522         // make the swap
1523         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1524             tokenAmount,
1525             0, // accept any amount of ETH
1526             path,
1527             address(this),
1528             block.timestamp
1529         );
1530     }
1531     
1532     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1533         // approve token transfer to cover all possible scenarios
1534         _approve(address(this), address(dexRouter), tokenAmount);
1535 
1536         // add the liquidity
1537         dexRouter.addLiquidityETH{value: ethAmount}(
1538             address(this),
1539             tokenAmount,
1540             0, // slippage is unavoidable
1541             0, // slippage is unavoidable
1542             address(this),
1543             block.timestamp
1544         );
1545     }
1546 
1547     function splitAndBurnLiquidity(uint256 percent) external onlyOwner {
1548         require(percent <=20);
1549         require(lastBurnTimestamp <= block.timestamp - 1 hours);
1550         lastBurnTimestamp = block.timestamp;
1551         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1552         uint256 tokenBalance = balanceOf(address(this));
1553         uint256 lpAmount = lpBalance * percent / 100;
1554         uint256 initialEthBalance = address(this).balance;
1555 
1556         // approve token transfer to cover all possible scenarios
1557         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1558 
1559         // remove the liquidity
1560         dexRouter.removeLiquidityETH(
1561             address(this),
1562             lpAmount,
1563             1, // slippage is unavoidable
1564             1, // slippage is unavoidable
1565             address(this),
1566             block.timestamp
1567         );
1568 
1569         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
1570         if(deltaTokenBalance > 0){
1571             super._transfer(address(this), address(0xdead), deltaTokenBalance);
1572         }
1573 
1574         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
1575 
1576         if(deltaEthBalance > 0){
1577             buyBackTokens(deltaEthBalance);
1578         }
1579     }
1580 
1581     function buyBackTokens(uint256 amountInWei) internal {
1582         address[] memory path = new address[](2);
1583         path[0] = dexRouter.WETH();
1584         path[1] = address(this);
1585 
1586         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
1587             0,
1588             path,
1589             address(0xdead),
1590             block.timestamp
1591         );
1592     }
1593 
1594     function swapBack() private {
1595 
1596         uint256 contractBalance = balanceOf(address(this));
1597         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards + tokensForLottery;
1598         
1599         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1600 
1601         if(contractBalance > swapTokensAtAmount * 10){
1602             contractBalance = swapTokensAtAmount * 10;
1603         }
1604 
1605         bool success;
1606         
1607         // Halve the amount of liquidity tokens
1608         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1609         
1610         uint256 initialBalance = address(this).balance;
1611         swapTokensForEth(contractBalance - liquidityTokens);
1612         
1613         uint256 ethBalance = address(this).balance - initialBalance;
1614         uint256 ethForLiquidity = ethBalance;
1615 
1616         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
1617         uint256 ethForRewards = ethBalance * tokensForRewards / (totalTokensToSwap - (tokensForLiquidity/2));
1618         uint256 ethForLottery = ethBalance * tokensForLottery / (totalTokensToSwap - (tokensForLiquidity/2));
1619 
1620         ethForLiquidity -= ethForOperations + ethForRewards + ethForLottery;
1621             
1622         tokensForLiquidity = 0;
1623         tokensForOperations = 0;
1624         tokensForRewards = 0;
1625         tokensForLottery = 0;
1626         
1627         if(liquidityTokens > 0 && ethForLiquidity > 0){
1628             addLiquidity(liquidityTokens, ethForLiquidity);
1629         }
1630 
1631         if(ethForOperations > 0){
1632             (success,) = address(operationsAddress).call{value: ethForOperations}("");
1633         }
1634         if(ethForRewards > 0){
1635             (success,) = address(dividendTracker).call{value: ethForRewards}("");
1636         }
1637         // remaining tokens stay for Lottery
1638     }
1639 
1640     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
1641         require(_token != address(0));
1642         require(_token != address(this));
1643         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1644         _sent = IERC20(_token).transfer(_to, _contractBalance);
1645         emit TransferForeignToken(_token, _contractBalance);
1646     }
1647 
1648     // withdraw ETH if stuck
1649     function withdrawStuckETH() external onlyOwner {
1650         bool success;
1651         (success,) = address(owner()).call{value: address(this).balance}("");
1652     }
1653 
1654     function setOperationsAddress(address _operationsAddress) external onlyOwner {
1655         require(_operationsAddress != address(0));
1656         operationsAddress = payable(_operationsAddress);
1657     }
1658 
1659     // force Swap back if slippage issues.
1660     function forceSwapBack() external onlyOwner {
1661         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
1662         swapping = true;
1663         swapBack();
1664         swapping = false;
1665         emit OwnerForcedSwapBack(block.timestamp);
1666     }
1667 
1668     function updateClaimWait(uint256 claimWait) external onlyOwner {
1669         dividendTracker.updateClaimWait(claimWait);
1670     }
1671 
1672     function getClaimWait() external view returns(uint256) {
1673         return dividendTracker.claimWait();
1674     }
1675 
1676     function getTotalDividendsDistributed() external view returns (uint256) {
1677         return dividendTracker.totalDividendsDistributed();
1678     }
1679 
1680     function withdrawableDividendOf(address account) external view returns(uint256) {
1681     	return dividendTracker.withdrawableDividendOf(account) + dividendTracker.holderPendingRewards(account);
1682   	}
1683 
1684     function holderRewardsUnlockTime(address account) external view returns(uint256) {
1685     	return dividendTracker.holderRewardsUnlockTime(account);
1686   	}
1687 
1688 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1689 		return dividendTracker.holderBalance(account);
1690 	}
1691 
1692     function getAccountDividendsInfo(address account)
1693         external view returns (
1694             address,
1695             int256,
1696             int256,
1697             uint256,
1698             uint256,
1699             uint256,
1700             uint256,
1701             uint256,
1702             uint256, 
1703             uint256) {
1704         return dividendTracker.getAccount(account);
1705     }
1706 
1707 	function getAccountDividendsInfoAtIndex(uint256 index)
1708         external view returns (
1709             address,
1710             int256,
1711             int256,
1712             uint256,
1713             uint256,
1714             uint256,
1715             uint256,
1716             uint256,
1717             uint256,
1718             uint256) {
1719     	return dividendTracker.getAccountAtIndex(index);
1720     }
1721 
1722     function claim() external {
1723 		dividendTracker.processAccount(payable(msg.sender), false);
1724     }
1725 
1726     function getLastProcessedIndex() external view returns(uint256) {
1727     	return dividendTracker.getLastProcessedIndex();
1728     }
1729 
1730     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1731         return dividendTracker.getNumberOfTokenHolders();
1732     }
1733     
1734     function getNumberOfDividends() external view returns(uint256) {
1735         return dividendTracker.totalBalance();
1736     }
1737 
1738     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1739     function excludeFromDividends(address account) external onlyOwner {
1740         dividendTracker.excludeFromDividends(account);
1741     }
1742 
1743     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1744     function includeInDividends(address account) external onlyOwner {
1745         dividendTracker.includeInDividends(account);
1746     }
1747 }