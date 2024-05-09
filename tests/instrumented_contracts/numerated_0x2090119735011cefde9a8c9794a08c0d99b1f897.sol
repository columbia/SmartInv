1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 interface IFactory {
27     function createPair(address tokenA, address tokenB) external returns (address pair);
28 
29     function getPair(address tokenA, address tokenB) external view returns (address pair);
30 }
31 
32 interface IRouter {
33     function factory() external pure returns (address);
34 
35     function WETH() external pure returns (address);
36 
37     function addLiquidityETH(
38         address token,
39         uint256 amountTokenDesired,
40         uint256 amountTokenMin,
41         uint256 amountETHMin,
42         address to,
43         uint256 deadline
44     )
45         external
46         payable
47         returns (
48             uint256 amountToken,
49             uint256 amountETH,
50             uint256 liquidity
51         );
52 
53     function swapExactETHForTokensSupportingFeeOnTransferTokens(
54         uint256 amountOutMin,
55         address[] calldata path,
56         address to,
57         uint256 deadline
58     ) external payable;
59 
60     function swapExactTokensForETHSupportingFeeOnTransferTokens(
61         uint256 amountIn,
62         uint256 amountOutMin,
63         address[] calldata path,
64         address to,
65         uint256 deadline
66     ) external;
67 }
68 
69 interface IERC20Metadata is IERC20 {
70     function name() external view returns (string memory);
71 
72     function symbol() external view returns (string memory);
73 
74     function decimals() external view returns (uint8);
75 }
76 
77 interface DividendPayingTokenInterface {
78     function dividendOf(address _owner) external view returns (uint256);
79 
80     function distributeDividends() external payable;
81 
82     function withdrawDividend() external;
83 
84     event DividendsDistributed(address indexed from, uint256 weiAmount);
85     event DividendWithdrawn(address indexed to, uint256 weiAmount);
86 }
87 
88 interface DividendPayingTokenOptionalInterface {
89     function withdrawableDividendOf(address _owner) external view returns (uint256);
90 
91     function withdrawnDividendOf(address _owner) external view returns (uint256);
92 
93     function accumulativeDividendOf(address _owner) external view returns (uint256);
94 }
95 
96 library SafeMath {
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100 
101         return c;
102     }
103 
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107 
108     function sub(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         require(b <= a, errorMessage);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
121         // benefit is lost if 'b' is also tested.
122         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
123         if (a == 0) {
124             return 0;
125         }
126 
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129 
130         return c;
131     }
132 
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     function div(
138         uint256 a,
139         uint256 b,
140         string memory errorMessage
141     ) internal pure returns (uint256) {
142         require(b > 0, errorMessage);
143         uint256 c = a / b;
144         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146         return c;
147     }
148 
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, "SafeMath: modulo by zero");
151     }
152 
153     function mod(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 library SafeMathInt {
164     int256 private constant MIN_INT256 = int256(1) << 255;
165     int256 private constant MAX_INT256 = ~(int256(1) << 255);
166 
167     function mul(int256 a, int256 b) internal pure returns (int256) {
168         int256 c = a * b;
169 
170         // Detect overflow when multiplying MIN_INT256 with -1
171         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
172         require((b == 0) || (c / b == a));
173         return c;
174     }
175 
176     function div(int256 a, int256 b) internal pure returns (int256) {
177         // Prevent overflow when dividing MIN_INT256 by -1
178         require(b != -1 || a != MIN_INT256);
179 
180         // Solidity already throws when dividing by 0.
181         return a / b;
182     }
183 
184     function sub(int256 a, int256 b) internal pure returns (int256) {
185         int256 c = a - b;
186         require((b >= 0 && c <= a) || (b < 0 && c > a));
187         return c;
188     }
189 
190     function add(int256 a, int256 b) internal pure returns (int256) {
191         int256 c = a + b;
192         require((b >= 0 && c >= a) || (b < 0 && c < a));
193         return c;
194     }
195 
196     function abs(int256 a) internal pure returns (int256) {
197         require(a != MIN_INT256);
198         return a < 0 ? -a : a;
199     }
200 
201     function toUint256Safe(int256 a) internal pure returns (uint256) {
202         require(a >= 0);
203         return uint256(a);
204     }
205 }
206 
207 library SafeMathUint {
208     function toInt256Safe(uint256 a) internal pure returns (int256) {
209         int256 b = int256(a);
210         require(b >= 0);
211         return b;
212     }
213 }
214 
215 library Address {
216 	function isContract(address account) internal view returns (bool) {
217 		uint256 size;
218 		assembly {
219 			size := extcodesize(account)
220 		}
221 		return size > 0;
222 	}
223 
224 	function sendValue(address payable recipient, uint256 amount) internal {
225 		require(
226 			address(this).balance >= amount,
227 			"Address: insufficient balance"
228 		);
229 
230 		(bool success, ) = recipient.call{value: amount}("");
231 		require(
232 			success,
233 			"Address: unable to send value, recipient may have reverted"
234 		);
235 	}
236 
237 	function functionCall(address target, bytes memory data)
238 	internal
239 	returns (bytes memory)
240 	{
241 		return functionCall(target, data, "Address: low-level call failed");
242 	}
243 
244 	function functionCall(
245 		address target,
246 		bytes memory data,
247 		string memory errorMessage
248 	) internal returns (bytes memory) {
249 		return functionCallWithValue(target, data, 0, errorMessage);
250 	}
251 
252 	function functionCallWithValue(
253 		address target,
254 		bytes memory data,
255 		uint256 value
256 	) internal returns (bytes memory) {
257 		return
258 		functionCallWithValue(
259 			target,
260 			data,
261 			value,
262 			"Address: low-level call with value failed"
263 		);
264 	}
265 
266 	function functionCallWithValue(
267 		address target,
268 		bytes memory data,
269 		uint256 value,
270 		string memory errorMessage
271 	) internal returns (bytes memory) {
272 		require(
273 			address(this).balance >= value,
274 			"Address: insufficient balance for call"
275 		);
276 		require(isContract(target), "Address: call to non-contract");
277 
278 		(bool success, bytes memory returndata) = target.call{value: value}(
279 		data
280 		);
281 		return _verifyCallResult(success, returndata, errorMessage);
282 	}
283 
284 	function functionStaticCall(address target, bytes memory data)
285 	internal
286 	view
287 	returns (bytes memory)
288 	{
289 		return
290 		functionStaticCall(
291 			target,
292 			data,
293 			"Address: low-level static call failed"
294 		);
295 	}
296 
297 	function functionStaticCall(
298 		address target,
299 		bytes memory data,
300 		string memory errorMessage
301 	) internal view returns (bytes memory) {
302 		require(isContract(target), "Address: static call to non-contract");
303 
304 		(bool success, bytes memory returndata) = target.staticcall(data);
305 		return _verifyCallResult(success, returndata, errorMessage);
306 	}
307 
308 	function functionDelegateCall(address target, bytes memory data)
309 	internal
310 	returns (bytes memory)
311 	{
312 		return
313 		functionDelegateCall(
314 			target,
315 			data,
316 			"Address: low-level delegate call failed"
317 		);
318 	}
319 
320 	function functionDelegateCall(
321 		address target,
322 		bytes memory data,
323 		string memory errorMessage
324 	) internal returns (bytes memory) {
325 		require(isContract(target), "Address: delegate call to non-contract");
326 
327 		(bool success, bytes memory returndata) = target.delegatecall(data);
328 		return _verifyCallResult(success, returndata, errorMessage);
329 	}
330 
331 	function _verifyCallResult(
332 		bool success,
333 		bytes memory returndata,
334 		string memory errorMessage
335 	) private pure returns (bytes memory) {
336 		if (success) {
337 			return returndata;
338 		} else {
339 			if (returndata.length > 0) {
340 				assembly {
341 					let returndata_size := mload(returndata)
342 					revert(add(32, returndata), returndata_size)
343 				}
344 			} else {
345 				revert(errorMessage);
346 			}
347 		}
348 	}
349 }
350 
351 library IterableMapping {
352     struct Map {
353         address[] keys;
354         mapping(address => uint256) values;
355         mapping(address => uint256) indexOf;
356         mapping(address => bool) inserted;
357     }
358 
359     function get(Map storage map, address key) public view returns (uint256) {
360         return map.values[key];
361     }
362 
363     function getIndexOfKey(Map storage map, address key) public view returns (int256) {
364         if (!map.inserted[key]) {
365             return -1;
366         }
367         return int256(map.indexOf[key]);
368     }
369 
370     function getKeyAtIndex(Map storage map, uint256 index) public view returns (address) {
371         return map.keys[index];
372     }
373 
374     function size(Map storage map) public view returns (uint256) {
375         return map.keys.length;
376     }
377 
378     function set(
379         Map storage map,
380         address key,
381         uint256 val
382     ) public {
383         if (map.inserted[key]) {
384             map.values[key] = val;
385         } else {
386             map.inserted[key] = true;
387             map.values[key] = val;
388             map.indexOf[key] = map.keys.length;
389             map.keys.push(key);
390         }
391     }
392 
393     function remove(Map storage map, address key) public {
394         if (!map.inserted[key]) {
395             return;
396         }
397 
398         delete map.inserted[key];
399         delete map.values[key];
400 
401         uint256 index = map.indexOf[key];
402         uint256 lastIndex = map.keys.length - 1;
403         address lastKey = map.keys[lastIndex];
404 
405         map.indexOf[lastKey] = index;
406         delete map.indexOf[key];
407 
408         map.keys[index] = lastKey;
409         map.keys.pop();
410     }
411 }
412 
413 abstract contract Context {
414     function _msgSender() internal view virtual returns (address) {
415         return msg.sender;
416     }
417 
418     function _msgData() internal view virtual returns (bytes calldata) {
419         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
420         return msg.data;
421     }
422 }
423 
424 contract Ownable is Context {
425     address private _owner;
426 
427     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
428 
429     constructor() {
430         address msgSender = _msgSender();
431         _owner = msgSender;
432         emit OwnershipTransferred(address(0), msgSender);
433     }
434 
435     function owner() public view returns (address) {
436         return _owner;
437     }
438 
439     modifier onlyOwner() {
440         require(_owner == _msgSender(), "Ownable: caller is not the owner");
441         _;
442     }
443 
444     function renounceOwnership() public virtual onlyOwner {
445         emit OwnershipTransferred(_owner, address(0));
446         _owner = address(0);
447     }
448 
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454 }
455 
456 contract ERC20 is Context, IERC20, IERC20Metadata {
457     using SafeMath for uint256;
458 
459     mapping(address => uint256) private _balances;
460     mapping(address => mapping(address => uint256)) private _allowances;
461 
462     uint256 private _totalSupply;
463     string private _name;
464     string private _symbol;
465 
466     constructor(string memory name_, string memory symbol_) {
467         _name = name_;
468         _symbol = symbol_;
469     }
470 
471     function name() public view virtual override returns (string memory) {
472         return _name;
473     }
474 
475     function symbol() public view virtual override returns (string memory) {
476         return _symbol;
477     }
478 
479     function decimals() public view virtual override returns (uint8) {
480         return 18;
481     }
482 
483     function totalSupply() public view virtual override returns (uint256) {
484         return _totalSupply;
485     }
486 
487     function balanceOf(address account) public view virtual override returns (uint256) {
488         return _balances[account];
489     }
490 
491     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
492         _transfer(_msgSender(), recipient, amount);
493         return true;
494     }
495 
496     function allowance(address owner, address spender)
497         public
498         view
499         virtual
500         override
501         returns (uint256)
502     {
503         return _allowances[owner][spender];
504     }
505 
506     function approve(address spender, uint256 amount) public virtual override returns (bool) {
507         _approve(_msgSender(), spender, amount);
508         return true;
509     }
510 
511     function transferFrom(
512         address sender,
513         address recipient,
514         uint256 amount
515     ) public virtual override returns (bool) {
516         _transfer(sender, recipient, amount);
517         _approve(
518             sender,
519             _msgSender(),
520             _allowances[sender][_msgSender()].sub(
521                 amount,
522                 "ERC20: transfer amount exceeds allowance"
523             )
524         );
525         return true;
526     }
527 
528     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
529         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
530         return true;
531     }
532 
533     function decreaseAllowance(address spender, uint256 subtractedValue)
534         public
535         virtual
536         returns (bool)
537     {
538         _approve(
539             _msgSender(),
540             spender,
541             _allowances[_msgSender()][spender].sub(
542                 subtractedValue,
543                 "ERC20: decreased allowance below zero"
544             )
545         );
546         return true;
547     }
548 
549     function _transfer(
550         address sender,
551         address recipient,
552         uint256 amount
553     ) internal virtual {
554         require(sender != address(0), "ERC20: transfer from the zero address");
555         require(recipient != address(0), "ERC20: transfer to the zero address");
556         _beforeTokenTransfer(sender, recipient, amount);
557         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
558         _balances[recipient] = _balances[recipient].add(amount);
559         emit Transfer(sender, recipient, amount);
560     }
561 
562     function _mint(address account, uint256 amount) internal virtual {
563         require(account != address(0), "ERC20: mint to the zero address");
564         _beforeTokenTransfer(address(0), account, amount);
565         _totalSupply = _totalSupply.add(amount);
566         _balances[account] = _balances[account].add(amount);
567         emit Transfer(address(0), account, amount);
568     }
569 
570     function _burn(address account, uint256 amount) internal virtual {
571         require(account != address(0), "ERC20: burn from the zero address");
572         _beforeTokenTransfer(account, address(0), amount);
573         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
574         _totalSupply = _totalSupply.sub(amount);
575         emit Transfer(account, address(0), amount);
576     }
577 
578     function _approve(
579         address owner,
580         address spender,
581         uint256 amount
582     ) internal virtual {
583         require(owner != address(0), "ERC20: approve from the zero address");
584         require(spender != address(0), "ERC20: approve to the zero address");
585         _allowances[owner][spender] = amount;
586         emit Approval(owner, spender, amount);
587     }
588 
589     function _beforeTokenTransfer(
590         address from,
591         address to,
592         uint256 amount
593     ) internal virtual {}
594 }
595 
596 contract DividendPayingToken is
597     ERC20,
598     Ownable,
599     DividendPayingTokenInterface,
600     DividendPayingTokenOptionalInterface
601 {
602     using SafeMath for uint256;
603     using SafeMathUint for uint256;
604     using SafeMathInt for int256;
605 
606     uint256 internal constant magnitude = 2**128;
607     uint256 internal magnifiedDividendPerShare;
608     uint256 public totalDividendsDistributed;
609     address public rewardToken;
610     IRouter public uniswapV2Router;
611 
612     mapping(address => int256) internal magnifiedDividendCorrections;
613     mapping(address => uint256) internal withdrawnDividends;
614 
615     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
616 
617     receive() external payable {
618         distributeDividends();
619     }
620 
621     function distributeDividends() public payable override onlyOwner {
622         require(totalSupply() > 0);
623         if (msg.value > 0) {
624             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
625                 (msg.value).mul(magnitude) / totalSupply()
626             );
627             emit DividendsDistributed(msg.sender, msg.value);
628             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
629         }
630     }
631 
632     function withdrawDividend() public virtual override onlyOwner {
633         _withdrawDividendOfUser(payable(msg.sender));
634     }
635 
636     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
637         uint256 _withdrawableDividend = withdrawableDividendOf(user);
638         if (_withdrawableDividend > 0) {
639             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
640             emit DividendWithdrawn(user, _withdrawableDividend);
641             (bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
642             if(!success) {
643                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
644                 return 0;
645             }
646             return _withdrawableDividend;
647         }
648         return 0;
649     }
650     function dividendOf(address _owner) public view override returns (uint256) {
651         return withdrawableDividendOf(_owner);
652     }
653 
654     function withdrawableDividendOf(address _owner) public view override returns (uint256) {
655         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
656     }
657 
658     function withdrawnDividendOf(address _owner) public view override returns (uint256) {
659         return withdrawnDividends[_owner];
660     }
661 
662     function accumulativeDividendOf(address _owner) public view override returns (uint256) {
663         return
664             magnifiedDividendPerShare
665                 .mul(balanceOf(_owner))
666                 .toInt256Safe()
667                 .add(magnifiedDividendCorrections[_owner])
668                 .toUint256Safe() / magnitude;
669     }
670 
671     function _transfer(
672         address from,
673         address to,
674         uint256 value
675     ) internal virtual override {
676         require(false);
677         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
678         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
679         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
680     }
681 
682     function _mint(address account, uint256 value) internal override {
683         super._mint(account, value);
684         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account].sub(
685             (magnifiedDividendPerShare.mul(value)).toInt256Safe()
686         );
687     }
688 
689     function _burn(address account, uint256 value) internal override {
690         super._burn(account, value);
691         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account].add(
692             (magnifiedDividendPerShare.mul(value)).toInt256Safe()
693         );
694     }
695 
696     function _setBalance(address account, uint256 newBalance) internal {
697         uint256 currentBalance = balanceOf(account);
698         if (newBalance > currentBalance) {
699             uint256 mintAmount = newBalance.sub(currentBalance);
700             _mint(account, mintAmount);
701         } else if (newBalance < currentBalance) {
702             uint256 burnAmount = currentBalance.sub(newBalance);
703             _burn(account, burnAmount);
704         }
705     }
706 }
707 
708 contract GrowCropCorp is Ownable, ERC20 {
709     using Address for address;
710 
711     IRouter public uniswapV2Router;
712     address public immutable uniswapV2Pair;
713 
714     string private constant _name = "Grow Crop Corp";
715     string private constant _symbol = "GCC";
716 
717     GrowCropCorpDividendTracker public dividendTracker;
718 
719     uint256 public initialSupply = 100000000 * (10**18);
720 
721     bool public isTradingEnabled;
722 
723     // max wallet is 1% of initialSupply
724     uint256 public maxWalletAmount = initialSupply * 100 / 10000;
725 
726     // max buy and sell tx is 2% of initialSupply
727     uint256 public maxTxAmount = initialSupply * 200 / 10000;
728 
729     bool private _swapping;
730     uint256 public minimumTokensBeforeSwap = initialSupply * 25 / 100000;
731 
732     address public liquidityWallet;
733     address public operationsWallet;
734     address public buyBackWallet;
735     address public treasuryWallet;
736     address public porkchopWallet;
737 
738     struct CustomTaxPeriod {
739         bytes23 periodName;
740         uint8 blocksInPeriod;
741         uint256 timeInPeriod;
742         uint8 liquidityFeeOnBuy;
743         uint8 liquidityFeeOnSell;
744         uint8 operationsFeeOnBuy;
745         uint8 operationsFeeOnSell;
746         uint8 buyBackFeeOnBuy;
747         uint8 buyBackFeeOnSell;
748         uint8 treasuryFeeOnBuy;
749         uint8 treasuryFeeOnSell;
750         uint8 porkchopFeeOnBuy;
751         uint8 porkchopFeeOnSell;
752         uint8 holdersFeeOnBuy;
753         uint8 holdersFeeOnSell;
754     }
755 
756     // Base taxes
757     CustomTaxPeriod private _base = CustomTaxPeriod("base", 0, 0, 2, 4, 1, 4, 2, 3, 1, 4, 1, 1, 2, 5);
758 
759     bool private _isLaunched;
760     uint256 private _launchStartTimestamp;
761     uint256 private _launchBlockNumber;
762 
763     mapping (address => bool) private _isBlocked;
764     mapping(address => bool) private _isAllowedToTradeWhenDisabled;
765     mapping(address => bool) private _feeOnSelectedWalletTransfers;
766     mapping(address => bool) private _isExcludedFromFee;
767     mapping(address => bool) private _isExcludedFromMaxTransactionLimit;
768     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
769     mapping(address => bool) public automatedMarketMakerPairs;
770 
771     uint8 private _liquidityFee;
772     uint8 private _operationsFee;
773     uint8 private _buyBackFee;
774     uint8 private _treasuryFee;
775     uint8 private _porkchopFee;
776     uint8 private _holdersFee;
777     uint8 private _totalFee;
778 
779     event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
780     event BlockedAccountChange(address indexed holder, bool indexed status);
781     event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
782     event WalletChange(string indexed indentifier,address indexed newWallet,address indexed oldWallet);
783     event FeeChange(string indexed identifier,uint8 liquidityFee,uint8 operationsFee,uint8 buyBackFee,uint8 treasuryFee, uint8 porkchopFee, uint8 holdersFee);
784     event CustomTaxPeriodChange(uint256 indexed newValue,uint256 indexed oldValue,string indexed taxType,bytes23 period);
785     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
786     event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
787     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
788     event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
789     event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
790     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
791     event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
792     event DividendsSent(uint256 tokensSwapped);
793     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
794     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
795     event ClaimETHOverflow(uint256 amount);
796     event FeesApplied(uint8 liquidityFee,uint8 operationsFee,uint8 buyBackFee,uint8 treasuryFee, uint8 porkchopFee, uint8 holdersFee,uint8 totalFee);
797 
798     constructor() ERC20(_name, _symbol) {
799         dividendTracker = new GrowCropCorpDividendTracker();
800 
801         liquidityWallet = owner();
802         operationsWallet = owner();
803         buyBackWallet = owner();
804 		treasuryWallet = owner();
805         porkchopWallet = owner();
806 
807         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
808         address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this),_uniswapV2Router.WETH());
809         uniswapV2Router = _uniswapV2Router;
810         uniswapV2Pair = _uniswapV2Pair;
811         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
812 
813         _isExcludedFromFee[owner()] = true;
814         _isExcludedFromFee[address(this)] = true;
815         _isExcludedFromFee[address(dividendTracker)] = true;
816 
817         dividendTracker.excludeFromDividends(address(dividendTracker));
818         dividendTracker.excludeFromDividends(address(this));
819         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
820         dividendTracker.excludeFromDividends(owner());
821         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
822 
823         _isAllowedToTradeWhenDisabled[owner()] = true;
824         _isAllowedToTradeWhenDisabled[address(this)] = true;
825 
826         _isExcludedFromMaxTransactionLimit[address(dividendTracker)] = true;
827         _isExcludedFromMaxTransactionLimit[address(this)] = true;
828 
829         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
830         _isExcludedFromMaxWalletLimit[address(dividendTracker)] = true;
831         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
832         _isExcludedFromMaxWalletLimit[address(this)] = true;
833         _isExcludedFromMaxWalletLimit[owner()] = true;
834 
835         _mint(owner(), initialSupply);
836     }
837 
838     receive() external payable {}
839 
840     // Setters
841     function activateTrading() external onlyOwner {
842         isTradingEnabled = true;
843         if(_launchBlockNumber == 0) {
844             _launchBlockNumber = block.number;
845             _launchStartTimestamp = block.timestamp;
846             _isLaunched = true;
847         }
848     }
849     function deactivateTrading() external onlyOwner {
850         isTradingEnabled = false;
851     }
852     function _setAutomatedMarketMakerPair(address pair, bool value) private {
853         require(automatedMarketMakerPairs[pair] != value,"GrowCropCorp: Automated market maker pair is already set to that value");
854         automatedMarketMakerPairs[pair] = value;
855         if (value) {
856             dividendTracker.excludeFromDividends(pair);
857         }
858         emit AutomatedMarketMakerPairChange(pair, value);
859     }
860     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
861         _isAllowedToTradeWhenDisabled[account] = allowed;
862         emit AllowedWhenTradingDisabledChange(account, allowed);
863     }
864     function blockAccount(address account) external onlyOwner {
865         require(!_isBlocked[account], "GrowCropCorp: Account is already blocked");
866         if (_isLaunched) {
867             require((block.timestamp - _launchStartTimestamp) < 172800, "GrowCropCorp: Time to block accounts has expired");
868         }
869         _isBlocked[account] = true;
870         emit BlockedAccountChange(account, true);
871     }
872     function unblockAccount(address account) external onlyOwner {
873         require(_isBlocked[account], "GrowCropCorp: Account is not blcoked");
874         _isBlocked[account] = false;
875         emit BlockedAccountChange(account, false);
876     }
877     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
878         require(_feeOnSelectedWalletTransfers[account] != value,"GrowCropCorp: The selected wallet is already set to the value ");
879         _feeOnSelectedWalletTransfers[account] = value;
880         emit FeeOnSelectedWalletTransfersChange(account, value);
881     }
882     function excludeFromFees(address account, bool excluded) external onlyOwner {
883         require(_isExcludedFromFee[account] != excluded,"GrowCropCorp: Account is already the value of 'excluded'");
884         _isExcludedFromFee[account] = excluded;
885         emit ExcludeFromFeesChange(account, excluded);
886     }
887     function excludeFromDividends(address account) external onlyOwner {
888         dividendTracker.excludeFromDividends(account);
889     }
890     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
891         require(_isExcludedFromMaxTransactionLimit[account] != excluded,"GrowCropCorp: Account is already the value of 'excluded'");
892         _isExcludedFromMaxTransactionLimit[account] = excluded;
893         emit ExcludeFromMaxTransferChange(account, excluded);
894     }
895     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
896         require(_isExcludedFromMaxWalletLimit[account] != excluded,"GrowCropCorp: Account is already the value of 'excluded'");
897         _isExcludedFromMaxWalletLimit[account] = excluded;
898         emit ExcludeFromMaxWalletChange(account, excluded);
899     }
900     function setWallets(address newLiquidityWallet,address newOperationsWallet,address newBuyBackWallet,address newTreasuryWallet, address newPorkchopWallet) external onlyOwner {
901         if (liquidityWallet != newLiquidityWallet) {
902             require(newLiquidityWallet != address(0), "GrowCropCorp: The liquidityWallet cannot be 0");
903             emit WalletChange("liquidityWallet", newLiquidityWallet, liquidityWallet);
904             liquidityWallet = newLiquidityWallet;
905         }
906         if (operationsWallet != newOperationsWallet) {
907             require(newOperationsWallet != address(0), "GrowCropCorp: The operationsWallet cannot be 0");
908             emit WalletChange("operationsWallet", newOperationsWallet, operationsWallet);
909             operationsWallet = newOperationsWallet;
910         }
911         if (buyBackWallet != newBuyBackWallet) {
912             require(newBuyBackWallet != address(0), "GrowCropCorp: The buyBackWallet cannot be 0");
913             emit WalletChange("buyBackWallet", newBuyBackWallet, buyBackWallet);
914             buyBackWallet = newBuyBackWallet;
915         }
916         if (treasuryWallet != newTreasuryWallet) {
917             require(newTreasuryWallet != address(0), "GrowCropCorp: The treasuryWallet cannot be 0");
918             emit WalletChange("treasuryWallet", newTreasuryWallet, treasuryWallet);
919             treasuryWallet = newTreasuryWallet;
920         }
921         if (porkchopWallet != newPorkchopWallet) {
922             require(newPorkchopWallet != address(0), "GrowCropCorp: The porkchopWallet cannot be 0");
923             emit WalletChange("porkchopWallet", newPorkchopWallet, porkchopWallet);
924             porkchopWallet = newPorkchopWallet;
925         }
926     }
927     // Base fees
928     function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy,uint8 _operationsFeeOnBuy,uint8 _buyBackFeeOnBuy,uint8 _treasuryFeeOnBuy, uint8 _porkchopFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
929         _setCustomBuyTaxPeriod(_base,_liquidityFeeOnBuy,_operationsFeeOnBuy,_buyBackFeeOnBuy,_treasuryFeeOnBuy, _porkchopFeeOnBuy, _holdersFeeOnBuy);
930         emit FeeChange("baseFees-Buy",_liquidityFeeOnBuy,_operationsFeeOnBuy,_buyBackFeeOnBuy,_treasuryFeeOnBuy, _porkchopFeeOnBuy, _holdersFeeOnBuy);
931     }
932     function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _operationsFeeOnSell,uint8 _buyBackFeeOnSell,uint8 _treasuryFeeOnSell, uint8 _porkchopFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
933         _setCustomSellTaxPeriod(_base,_liquidityFeeOnSell,_operationsFeeOnSell,_buyBackFeeOnSell,_treasuryFeeOnSell,_porkchopFeeOnSell, _holdersFeeOnSell);
934         emit FeeChange("baseFees-Sell",_liquidityFeeOnSell,_operationsFeeOnSell,_buyBackFeeOnSell,_treasuryFeeOnSell,_porkchopFeeOnSell, _holdersFeeOnSell);
935     }
936     function setUniswapRouter(address newAddress) external onlyOwner {
937         require(newAddress != address(uniswapV2Router),"GrowCropCorp: The router already has that address");
938         emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
939         uniswapV2Router = IRouter(newAddress);
940     }
941     function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
942         require(newValue != maxTxAmount, "GrowCropCorp: Cannot update maxTxAmount to same value");
943         emit MaxTransactionAmountChange(newValue, maxTxAmount);
944         maxTxAmount = newValue;
945     }
946     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
947         require(newValue != maxWalletAmount,"GrowCropCorp: Cannot update maxWalletAmount to same value");
948         emit MaxWalletAmountChange(newValue, maxWalletAmount);
949         maxWalletAmount = newValue;
950     }
951     function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
952         require(newValue != minimumTokensBeforeSwap,"GrowCropCorp: Cannot update minimumTokensBeforeSwap to same value");
953         emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
954         minimumTokensBeforeSwap = newValue;
955     }
956     function setMinimumTokenBalanceForDividends(uint256 newValue) external onlyOwner {
957         dividendTracker.setTokenBalanceForDividends(newValue);
958     }
959     function claim() external {
960         dividendTracker.processAccount(payable(msg.sender), false);
961     }
962     function claimETHOverflow(uint256 amount) external onlyOwner {
963         require(amount < address(this).balance, "GrowCropCorp: Cannot send more than contract balance");
964         (bool success, ) = address(owner()).call{ value: amount }("");
965         if (success) {
966             emit ClaimETHOverflow(amount);
967         }
968     }
969     // Getters
970     function getTotalDividendsDistributed() external view returns (uint256) {
971         return dividendTracker.totalDividendsDistributed();
972     }
973     function withdrawableDividendOf(address account) external view returns (uint256) {
974         return dividendTracker.withdrawableDividendOf(account);
975     }
976     function dividendTokenBalanceOf(address account) external view returns (uint256) {
977         return dividendTracker.balanceOf(account);
978     }
979     function getNumberOfDividendTokenHolders() external view returns (uint256) {
980         return dividendTracker.getNumberOfTokenHolders();
981     }
982     function getBaseBuyFees() external view returns (uint8,uint8,uint8,uint8,uint8,uint8) {
983         return (_base.liquidityFeeOnBuy,_base.operationsFeeOnBuy,_base.buyBackFeeOnBuy,_base.treasuryFeeOnBuy,_base.porkchopFeeOnBuy, _base.holdersFeeOnBuy);
984     }
985     function getBaseSellFees() external view returns (uint8,uint8,uint8,uint8,uint8,uint8) {
986         return (_base.liquidityFeeOnSell,_base.operationsFeeOnSell,_base.buyBackFeeOnSell,_base.treasuryFeeOnSell,_base.porkchopFeeOnSell, _base.holdersFeeOnSell);
987     }
988     // Main
989     function _transfer(
990         address from,
991         address to,
992         uint256 amount
993     ) internal override {
994         require(from != address(0), "ERC20: transfer from the zero address");
995         require(to != address(0), "ERC20: transfer to the zero address");
996 
997         if (amount == 0) {
998             super._transfer(from, to, 0);
999             return;
1000         }
1001 
1002         if (!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
1003             require(isTradingEnabled, "GrowCropCorp: Trading is currently disabled.");
1004             require(!_isBlocked[to], "GrowCropCorp: Account is blocked");
1005             require(!_isBlocked[from], "GrowCropCorp: Account is blocked");
1006             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
1007                 require(amount <= maxTxAmount, "GrowCropCorp: Buy amount exceeds the maxTxBuyAmount.");
1008             }
1009             if (!_isExcludedFromMaxWalletLimit[to]) {
1010                 require((balanceOf(to) + amount) <= maxWalletAmount, "GrowCropCorp: Expected wallet amount exceeds the maxWalletAmount.");
1011             }
1012         }
1013 
1014         _adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], from, to);
1015         bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
1016 
1017         if (
1018             isTradingEnabled &&
1019             canSwap &&
1020             !_swapping &&
1021             _totalFee > 0 &&
1022             automatedMarketMakerPairs[to]
1023         ) {
1024             _swapping = true;
1025             _swapAndLiquify();
1026             _swapping = false;
1027         }
1028 
1029         bool takeFee = !_swapping && isTradingEnabled;
1030 
1031         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1032             takeFee = false;
1033         }
1034         if (takeFee && _totalFee > 0) {
1035             uint256 fee = (amount * _totalFee) / 100;
1036             amount = amount - fee;
1037             super._transfer(from, address(this), fee);
1038         }
1039         super._transfer(from, to, amount);
1040 
1041         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1042         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1043     }
1044     function _adjustTaxes(bool isBuyFromLp,bool isSelltoLp,address from,address to) private {
1045         _liquidityFee = 0;
1046         _operationsFee = 0;
1047         _buyBackFee = 0;
1048         _treasuryFee = 0;
1049         _porkchopFee = 0;
1050         _holdersFee = 0;
1051 
1052         if (isBuyFromLp) {
1053             if (_isLaunched && block.number - _launchBlockNumber <= 5) {
1054                 _liquidityFee = 100;
1055             } else {
1056                 _liquidityFee = _base.liquidityFeeOnBuy;
1057                 _operationsFee = _base.operationsFeeOnBuy;
1058                 _buyBackFee = _base.buyBackFeeOnBuy;
1059                 _treasuryFee = _base.treasuryFeeOnBuy;
1060                 _porkchopFee = _base.porkchopFeeOnBuy;
1061                 _holdersFee = _base.holdersFeeOnBuy;
1062             }
1063         }
1064         if (isSelltoLp) {
1065             _liquidityFee = _base.liquidityFeeOnSell;
1066             _operationsFee = _base.operationsFeeOnSell;
1067             _buyBackFee = _base.buyBackFeeOnSell;
1068             _treasuryFee = _base.treasuryFeeOnSell;
1069             _porkchopFee = _base.porkchopFeeOnSell;
1070             _holdersFee = _base.holdersFeeOnSell;
1071         }
1072         if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
1073             _liquidityFee = _base.liquidityFeeOnBuy;
1074             _operationsFee = _base.operationsFeeOnBuy;
1075             _buyBackFee = _base.buyBackFeeOnBuy;
1076             _treasuryFee = _base.treasuryFeeOnBuy;
1077             _porkchopFee = _base.porkchopFeeOnSell;
1078             _holdersFee = _base.holdersFeeOnBuy;
1079         }
1080         _totalFee = _liquidityFee + _operationsFee + _buyBackFee + _treasuryFee + _porkchopFee + _holdersFee;
1081         emit FeesApplied(_liquidityFee, _operationsFee, _buyBackFee, _treasuryFee, _porkchopFee, _holdersFee, _totalFee);
1082     }
1083     function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,uint8 _liquidityFeeOnSell,uint8 _operationsFeeOnSell,uint8 _buyBackFeeOnSell,uint8 _treasuryFeeOnSell,uint8 _porkchopFeeOnSell, uint8 _holdersFeeOnSell) private {
1084         if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
1085             emit CustomTaxPeriodChange(_liquidityFeeOnSell,map.liquidityFeeOnSell,"liquidityFeeOnSell",map.periodName);
1086             map.liquidityFeeOnSell = _liquidityFeeOnSell;
1087         }
1088         if (map.operationsFeeOnSell != _operationsFeeOnSell) {
1089             emit CustomTaxPeriodChange(_operationsFeeOnSell,map.operationsFeeOnSell,"operationsFeeOnSell",map.periodName);
1090             map.operationsFeeOnSell = _operationsFeeOnSell;
1091         }
1092         if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
1093             emit CustomTaxPeriodChange(_buyBackFeeOnSell,map.buyBackFeeOnSell,"buyBackFeeOnSell",map.periodName);
1094             map.buyBackFeeOnSell = _buyBackFeeOnSell;
1095         }
1096         if (map.treasuryFeeOnSell != _treasuryFeeOnSell) {
1097             emit CustomTaxPeriodChange(_treasuryFeeOnSell,map.treasuryFeeOnSell,"treasuryFeeOnSell",map.periodName);
1098             map.treasuryFeeOnSell = _treasuryFeeOnSell;
1099         }
1100         if (map.porkchopFeeOnSell != _porkchopFeeOnSell) {
1101             emit CustomTaxPeriodChange(_porkchopFeeOnSell,map.porkchopFeeOnSell,"porkchopFeeOnSell",map.periodName);
1102             map.porkchopFeeOnSell = _porkchopFeeOnSell;
1103         }
1104         if (map.holdersFeeOnSell != _holdersFeeOnSell) {
1105             emit CustomTaxPeriodChange(_holdersFeeOnSell,map.holdersFeeOnSell,"holdersFeeOnSell",map.periodName);
1106             map.holdersFeeOnSell = _holdersFeeOnSell;
1107         }
1108     }
1109     function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,uint8 _liquidityFeeOnBuy,uint8 _operationsFeeOnBuy,uint8 _buyBackFeeOnBuy,uint8 _treasuryFeeOnBuy, uint8 _porkchopFeeOnBuy, uint8 _holdersFeeOnBuy) private {
1110         if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
1111             emit CustomTaxPeriodChange(_liquidityFeeOnBuy,map.liquidityFeeOnBuy,"liquidityFeeOnBuy",map.periodName);
1112             map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
1113         }
1114         if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
1115             emit CustomTaxPeriodChange(_operationsFeeOnBuy,map.operationsFeeOnBuy,"operationsFeeOnBuy",map.periodName);
1116             map.operationsFeeOnBuy = _operationsFeeOnBuy;
1117         }
1118         if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
1119             emit CustomTaxPeriodChange(_buyBackFeeOnBuy,map.buyBackFeeOnBuy,"buyBackFeeOnBuy",map.periodName);
1120             map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
1121         }
1122         if (map.treasuryFeeOnBuy != _treasuryFeeOnBuy) {
1123             emit CustomTaxPeriodChange(_treasuryFeeOnBuy,map.treasuryFeeOnBuy,"treasuryFeeOnBuy",map.periodName);
1124             map.treasuryFeeOnBuy = _treasuryFeeOnBuy;
1125         }
1126         if (map.porkchopFeeOnBuy != _porkchopFeeOnBuy) {
1127             emit CustomTaxPeriodChange(_porkchopFeeOnBuy,map.porkchopFeeOnBuy,"porkchopFeeOnBuy",map.periodName);
1128             map.porkchopFeeOnBuy = _porkchopFeeOnBuy;
1129         }
1130         if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
1131             emit CustomTaxPeriodChange(_holdersFeeOnBuy,map.holdersFeeOnBuy,"holdersFeeOnBuy",map.periodName);
1132             map.holdersFeeOnBuy = _holdersFeeOnBuy;
1133         }
1134     }
1135 
1136     function _swapAndLiquify() private {
1137         uint256 contractBalance = balanceOf(address(this));
1138         uint256 initialETHBalance = address(this).balance;
1139 
1140         uint256 amountToLiquify = (contractBalance * _liquidityFee) / _totalFee / 2;
1141         uint256 amountToSwap = contractBalance - amountToLiquify;
1142 
1143         _swapTokensForETH(amountToSwap);
1144 
1145         uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
1146         uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
1147         uint256 amountETHLiquidity = (ETHBalanceAfterSwap * _liquidityFee) / totalETHFee / 2;
1148         uint256 amountETHOperations = (ETHBalanceAfterSwap * _operationsFee) / totalETHFee;
1149         uint256 amountETHBuyBack = (ETHBalanceAfterSwap * _buyBackFee) / totalETHFee;
1150         uint256 amountETHTreasury = (ETHBalanceAfterSwap * _treasuryFee) / totalETHFee;
1151         uint256 amountETHPorkchop = (ETHBalanceAfterSwap * _porkchopFee) / totalETHFee;
1152         uint256 amountETHHolders = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHBuyBack + amountETHOperations + amountETHTreasury + amountETHPorkchop);
1153 
1154         Address.sendValue(payable(operationsWallet),amountETHOperations);
1155         Address.sendValue(payable(buyBackWallet),amountETHBuyBack);
1156         Address.sendValue(payable(treasuryWallet),amountETHTreasury);
1157         Address.sendValue(payable(porkchopWallet), amountETHPorkchop);
1158 
1159         if (amountToLiquify > 0) {
1160             _addLiquidity(amountToLiquify, amountETHLiquidity);
1161             emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
1162         }
1163 
1164         (bool success, ) = address(dividendTracker).call{ value: amountETHHolders }("");
1165         if (success) {
1166             emit DividendsSent(amountETHHolders);
1167         }
1168     }
1169 
1170     function _swapTokensForETH(uint256 tokenAmount) private {
1171         address[] memory path = new address[](2);
1172         path[0] = address(this);
1173         path[1] = uniswapV2Router.WETH();
1174         _approve(address(this), address(uniswapV2Router), tokenAmount);
1175         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1176             tokenAmount,
1177             1, // accept any amount of ETH
1178             path,
1179             address(this),
1180             block.timestamp
1181         );
1182     }
1183 
1184     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1185         _approve(address(this), address(uniswapV2Router), tokenAmount);
1186         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
1187             address(this),
1188             tokenAmount,
1189             1, // slippage is unavoidable
1190             1, // slippage is unavoidable
1191             liquidityWallet,
1192             block.timestamp
1193         );
1194     }
1195 }
1196 
1197 contract GrowCropCorpDividendTracker is DividendPayingToken {
1198     using SafeMath for uint256;
1199     using SafeMathInt for int256;
1200     using IterableMapping for IterableMapping.Map;
1201 
1202     IterableMapping.Map private tokenHoldersMap;
1203 
1204     mapping(address => bool) public excludedFromDividends;
1205     mapping(address => uint256) public lastClaimTimes;
1206     uint256 public claimWait;
1207     uint256 public minimumTokenBalanceForDividends;
1208 
1209     event ExcludeFromDividends(address indexed account);
1210     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1211     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1212 
1213     constructor() DividendPayingToken("GrowCropCorp_Dividend_Tracker", "GrowCropCorp_Dividend_Tracker") {
1214         claimWait = 3600;
1215         minimumTokenBalanceForDividends = 0 * (10**18);
1216     }
1217     function _transfer(
1218         address,
1219         address,
1220         uint256
1221     ) internal pure override {
1222         require(false, "GrowCropCorp_Dividend_Tracker: No transfers allowed");
1223     }
1224     function excludeFromDividends(address account) external onlyOwner {
1225         require(!excludedFromDividends[account]);
1226         excludedFromDividends[account] = true;
1227         _setBalance(account, 0);
1228         tokenHoldersMap.remove(account);
1229         emit ExcludeFromDividends(account);
1230     }
1231     function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1232         require(
1233             minimumTokenBalanceForDividends != newValue,
1234             "GrowCropCorp_Dividend_Tracker: minimumTokenBalanceForDividends already the value of 'newValue'."
1235         );
1236         minimumTokenBalanceForDividends = newValue;
1237     }
1238     function getNumberOfTokenHolders() external view returns (uint256) {
1239         return tokenHoldersMap.keys.length;
1240     }
1241     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1242         if (excludedFromDividends[account]) {
1243             return;
1244         }
1245         if (newBalance >= minimumTokenBalanceForDividends) {
1246             _setBalance(account, newBalance);
1247             tokenHoldersMap.set(account, newBalance);
1248         } else {
1249             _setBalance(account, 0);
1250             tokenHoldersMap.remove(account);
1251         }
1252         processAccount(account, true);
1253     }
1254     function processAccount(address payable account, bool automatic)
1255         public
1256         onlyOwner
1257         returns (bool)
1258     {
1259         uint256 amount = _withdrawDividendOfUser(account);
1260         if (amount > 0) {
1261             lastClaimTimes[account] = block.timestamp;
1262             emit Claim(account, amount, automatic);
1263             return true;
1264         }
1265         return false;
1266     }
1267 }