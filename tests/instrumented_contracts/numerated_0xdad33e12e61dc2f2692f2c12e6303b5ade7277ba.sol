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
641             return swapETHForTokensAndWithdrawDividend(user, _withdrawableDividend);
642         }
643         return 0;
644     }
645 
646     function swapETHForTokensAndWithdrawDividend(address holder, uint256 ethAmount)
647         private
648         returns (uint256)
649     {
650         address[] memory path = new address[](2);
651         path[0] = uniswapV2Router.WETH();
652         path[1] = address(rewardToken);
653 
654         try
655             uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: ethAmount }(
656                 0, // accept any amount of tokens
657                 path,
658                 address(holder),
659                 block.timestamp
660             )
661         {
662             return ethAmount;
663         } catch {
664             withdrawnDividends[holder] = withdrawnDividends[holder].sub(ethAmount);
665             return 0;
666         }
667     }
668 
669     function dividendOf(address _owner) public view override returns (uint256) {
670         return withdrawableDividendOf(_owner);
671     }
672 
673     function withdrawableDividendOf(address _owner) public view override returns (uint256) {
674         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
675     }
676 
677     function withdrawnDividendOf(address _owner) public view override returns (uint256) {
678         return withdrawnDividends[_owner];
679     }
680 
681     function accumulativeDividendOf(address _owner) public view override returns (uint256) {
682         return
683             magnifiedDividendPerShare
684                 .mul(balanceOf(_owner))
685                 .toInt256Safe()
686                 .add(magnifiedDividendCorrections[_owner])
687                 .toUint256Safe() / magnitude;
688     }
689 
690     function _transfer(
691         address from,
692         address to,
693         uint256 value
694     ) internal virtual override {
695         require(false);
696         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
697         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
698         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
699     }
700 
701     function _mint(address account, uint256 value) internal override {
702         super._mint(account, value);
703         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account].sub(
704             (magnifiedDividendPerShare.mul(value)).toInt256Safe()
705         );
706     }
707 
708     function _burn(address account, uint256 value) internal override {
709         super._burn(account, value);
710         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account].add(
711             (magnifiedDividendPerShare.mul(value)).toInt256Safe()
712         );
713     }
714 
715     function _setBalance(address account, uint256 newBalance) internal {
716         uint256 currentBalance = balanceOf(account);
717         if (newBalance > currentBalance) {
718             uint256 mintAmount = newBalance.sub(currentBalance);
719             _mint(account, mintAmount);
720         } else if (newBalance < currentBalance) {
721             uint256 burnAmount = currentBalance.sub(newBalance);
722             _burn(account, burnAmount);
723         }
724     }
725 
726     function _setRewardToken(address token) internal onlyOwner {
727         rewardToken = token;
728     }
729 
730     function _setUniswapRouter(address router) internal onlyOwner {
731         uniswapV2Router = IRouter(router);
732     }
733 }
734 
735 contract Brewlabs is Ownable, ERC20 {
736     using Address for address;
737 
738     IRouter public uniswapV2Router;
739     address public immutable uniswapV2Pair;
740 
741     string private constant _name = "Brewlabs";
742     string private constant _symbol = "BREWLABS";
743     uint8 private constant _decimals = 9;
744 
745     BrewlabsDividendTracker public dividendTracker;
746 
747     bool public isTradingEnabled;
748 
749     // max wallet is 1.5% of Brewlabs(BEP20)'s initialSupply
750     uint256 public maxWalletAmount = (1000000000 * (10**9) * 150) / 10000;
751 
752     // max buy and sell tx is 0.2% of Brewlabs(BEP20)'s initialSupply
753     uint256 public maxTxAmount = (1000000000 * (10**9) * 20) / 10000;
754 
755     bool private _swapping;
756     uint256 public minimumTokensBeforeSwap = 250000000 * (10**9);
757 
758     address public dividendToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; //USDC
759 
760     address public liquidityWallet;
761     address public devWallet;
762     address public buyBackWallet;
763     address public bridge;
764     address public stakingAddress;
765 
766     struct CustomTaxPeriod {
767         bytes23 periodName;
768         uint8 blocksInPeriod;
769         uint256 timeInPeriod;
770         uint8 liquidityFeeOnBuy;
771         uint8 liquidityFeeOnSell;
772         uint8 devFeeOnBuy;
773         uint8 devFeeOnSell;
774         uint8 buyBackFeeOnBuy;
775         uint8 buyBackFeeOnSell;
776         uint8 stakingFeeOnBuy;
777         uint8 stakingFeeOnSell;
778         uint8 holdersFeeOnBuy;
779         uint8 holdersFeeOnSell;
780     }
781 
782     // Base taxes
783     CustomTaxPeriod private _base = CustomTaxPeriod("base", 0, 0, 1, 1, 1, 1, 8, 8, 1, 1, 4, 4);
784 
785     mapping(address => bool) private _isAllowedToTradeWhenDisabled;
786     mapping(address => bool) private _feeOnSelectedWalletTransfers;
787     mapping(address => bool) private _isExcludedFromFee;
788     mapping(address => bool) private _isExcludedFromMaxTransactionLimit;
789     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
790     mapping(address => bool) public automatedMarketMakerPairs;
791 
792     uint8 private _liquidityFee;
793     uint8 private _devFee;
794     uint8 private _buyBackFee;
795     uint8 private _stakingFee;
796     uint8 private _holdersFee;
797     uint8 private _totalFee;
798 
799     event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
800     event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
801     event WalletChange(
802         string indexed indentifier,
803         address indexed newWallet,
804         address indexed oldWallet
805     );
806     event FeeChange(
807         string indexed identifier,
808         uint8 liquidityFee,
809         uint8 devFee,
810         uint8 buyBackFee,
811         uint8 stakingFee,
812         uint8 holdersFee
813     );
814     event CustomTaxPeriodChange(
815         uint256 indexed newValue,
816         uint256 indexed oldValue,
817         string indexed taxType,
818         bytes23 period
819     );
820     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
821     event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
822     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
823     event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
824     event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
825     event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
826     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
827     event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
828     event MinTokenAmountForDividendsChange(uint256 indexed newValue, uint256 indexed oldValue);
829     event DividendsSent(uint256 tokensSwapped);
830     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
831     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
832     event ClaimETHOverflow(uint256 amount);
833     event FeesApplied(
834         uint8 liquidityFee,
835         uint8 devFee,
836         uint8 buyBackFee,
837         uint8 stakingFee,
838         uint8 holdersFee,
839         uint8 totalFee
840     );
841     event SetBridgeContract(address indexed bridgeContract);
842     event SetStakingAddress(address indexed stakingAddress);
843 
844     modifier hasMintPermission() {
845         require(msg.sender == bridge, "Only bridge contract can mint");
846         _;
847     }
848 
849     constructor() ERC20(_name, _symbol) {
850         dividendTracker = new BrewlabsDividendTracker();
851         dividendTracker.setUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
852         dividendTracker.setRewardToken(dividendToken);
853 
854         liquidityWallet = owner();
855         devWallet = owner();
856         buyBackWallet = owner();
857 
858         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
859         address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
860             address(this),
861             _uniswapV2Router.WETH()
862         );
863         uniswapV2Router = _uniswapV2Router;
864         uniswapV2Pair = _uniswapV2Pair;
865         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
866 
867         _isExcludedFromFee[owner()] = true;
868         _isExcludedFromFee[address(this)] = true;
869         _isExcludedFromFee[address(dividendTracker)] = true;
870 
871         dividendTracker.excludeFromDividends(address(dividendTracker));
872         dividendTracker.excludeFromDividends(address(this));
873         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
874         dividendTracker.excludeFromDividends(owner());
875         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
876 
877         _isAllowedToTradeWhenDisabled[owner()] = true;
878         _isAllowedToTradeWhenDisabled[address(this)] = true;
879 
880         _isExcludedFromMaxTransactionLimit[address(dividendTracker)] = true;
881         _isExcludedFromMaxTransactionLimit[address(this)] = true;
882 
883         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
884         _isExcludedFromMaxWalletLimit[address(dividendTracker)] = true;
885         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
886         _isExcludedFromMaxWalletLimit[address(this)] = true;
887         _isExcludedFromMaxWalletLimit[owner()] = true;
888     }
889 
890     receive() external payable {}
891 
892     // Setters
893     function decimals() public view virtual override returns (uint8) {
894         return _decimals;
895     }
896 
897     function activateTrading() external onlyOwner {
898         isTradingEnabled = true;
899     }
900 
901     function deactivateTrading() external onlyOwner {
902         isTradingEnabled = false;
903     }
904 
905     function _setAutomatedMarketMakerPair(address pair, bool value) private {
906         require(
907             automatedMarketMakerPairs[pair] != value,
908             "Brewlabs: Automated market maker pair is already set to that value"
909         );
910         automatedMarketMakerPairs[pair] = value;
911         if (value) {
912             dividendTracker.excludeFromDividends(pair);
913         }
914         emit AutomatedMarketMakerPairChange(pair, value);
915     }
916 
917     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
918         _isAllowedToTradeWhenDisabled[account] = allowed;
919         emit AllowedWhenTradingDisabledChange(account, allowed);
920     }
921 
922     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
923         require(
924             _feeOnSelectedWalletTransfers[account] != value,
925             "Brewlabs: The selected wallet is already set to the value "
926         );
927         _feeOnSelectedWalletTransfers[account] = value;
928         emit FeeOnSelectedWalletTransfersChange(account, value);
929     }
930 
931     function excludeFromFees(address account, bool excluded) external onlyOwner {
932         require(
933             _isExcludedFromFee[account] != excluded,
934             "Brewlabs: Account is already the value of 'excluded'"
935         );
936         _isExcludedFromFee[account] = excluded;
937         emit ExcludeFromFeesChange(account, excluded);
938     }
939 
940     function excludeFromDividends(address account) external onlyOwner {
941         dividendTracker.excludeFromDividends(account);
942     }
943 
944     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
945         require(
946             _isExcludedFromMaxTransactionLimit[account] != excluded,
947             "Brewlabs: Account is already the value of 'excluded'"
948         );
949         _isExcludedFromMaxTransactionLimit[account] = excluded;
950         emit ExcludeFromMaxTransferChange(account, excluded);
951     }
952 
953     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
954         require(
955             _isExcludedFromMaxWalletLimit[account] != excluded,
956             "Brewlabs: Account is already the value of 'excluded'"
957         );
958         _isExcludedFromMaxWalletLimit[account] = excluded;
959         emit ExcludeFromMaxWalletChange(account, excluded);
960     }
961 
962     function setStakingAddress(
963         address newStakingAddress
964     ) external onlyOwner {
965         require(newStakingAddress != address(0), "Brewlabs: The stakingAddress cannot be 0");
966         require(newStakingAddress != stakingAddress, "Brewlabs: The stakingAddress is already the value of newStakingAddress");
967         stakingAddress = newStakingAddress;
968         emit SetStakingAddress(stakingAddress);
969     }
970 
971     function setWallets(
972         address newLiquidityWallet,
973         address newDevWallet,
974         address newBuyBackWallet
975     ) external onlyOwner {
976         if (liquidityWallet != newLiquidityWallet) {
977             require(newLiquidityWallet != address(0), "Brewlabs: The liquidityWallet cannot be 0");
978             emit WalletChange("liquidityWallet", newLiquidityWallet, liquidityWallet);
979             liquidityWallet = newLiquidityWallet;
980         }
981         if (devWallet != newDevWallet) {
982             require(newDevWallet != address(0), "Brewlabs: The devWallet cannot be 0");
983             emit WalletChange("devWallet", newDevWallet, devWallet);
984             devWallet = newDevWallet;
985         }
986         if (buyBackWallet != newBuyBackWallet) {
987             require(newBuyBackWallet != address(0), "Brewlabs: The buyBackWallet cannot be 0");
988             emit WalletChange("buyBackWallet", newBuyBackWallet, buyBackWallet);
989             buyBackWallet = newBuyBackWallet;
990         }
991     }
992 
993     // Base fees
994     function setBaseFeesOnBuy(
995         uint8 _liquidityFeeOnBuy,
996         uint8 _devFeeOnBuy,
997         uint8 _buyBackFeeOnBuy,
998         uint8 _stakingFeeOnBuy,
999         uint8 _holdersFeeOnBuy
1000     ) external onlyOwner {
1001         _setCustomBuyTaxPeriod(
1002             _base,
1003             _liquidityFeeOnBuy,
1004             _devFeeOnBuy,
1005             _buyBackFeeOnBuy,
1006             _stakingFeeOnBuy,
1007             _holdersFeeOnBuy
1008         );
1009         emit FeeChange(
1010             "baseFees-Buy",
1011             _liquidityFeeOnBuy,
1012             _devFeeOnBuy,
1013             _buyBackFeeOnBuy,
1014             _stakingFeeOnBuy,
1015             _holdersFeeOnBuy
1016         );
1017     }
1018 
1019     function setBaseFeesOnSell(
1020         uint8 _liquidityFeeOnSell,
1021         uint8 _devFeeOnSell,
1022         uint8 _buyBackFeeOnSell,
1023         uint8 _stakingFeeOnSell,
1024         uint8 _holdersFeeOnSell
1025     ) external onlyOwner {
1026         _setCustomSellTaxPeriod(
1027             _base,
1028             _liquidityFeeOnSell,
1029             _devFeeOnSell,
1030             _buyBackFeeOnSell,
1031             _stakingFeeOnSell,
1032             _holdersFeeOnSell
1033         );
1034         emit FeeChange(
1035             "baseFees-Sell",
1036             _liquidityFeeOnSell,
1037             _devFeeOnSell,
1038             _buyBackFeeOnSell,
1039             _stakingFeeOnSell,
1040             _holdersFeeOnSell
1041         );
1042     }
1043 
1044     function setUniswapRouter(address newAddress) external onlyOwner {
1045         require(
1046             newAddress != address(uniswapV2Router),
1047             "Brewlabs: The router already has that address"
1048         );
1049         emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
1050         uniswapV2Router = IRouter(newAddress);
1051         dividendTracker.setUniswapRouter(newAddress);
1052     }
1053 
1054     function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
1055         require(newValue != maxTxAmount, "Brewlabs: Cannot update maxTxAmount to same value");
1056         emit MaxTransactionAmountChange(newValue, maxTxAmount);
1057         maxTxAmount = newValue;
1058     }
1059 
1060     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
1061         require(
1062             newValue != maxWalletAmount,
1063             "Brewlabs: Cannot update maxWalletAmount to same value"
1064         );
1065         emit MaxWalletAmountChange(newValue, maxWalletAmount);
1066         maxWalletAmount = newValue;
1067     }
1068 
1069     function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
1070         require(
1071             newValue != minimumTokensBeforeSwap,
1072             "Brewlabs: Cannot update minimumTokensBeforeSwap to same value"
1073         );
1074         emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
1075         minimumTokensBeforeSwap = newValue;
1076     }
1077 
1078     function setMinimumTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1079         dividendTracker.setTokenBalanceForDividends(newValue);
1080     }
1081 
1082     function claim() external {
1083         dividendTracker.processAccount(payable(msg.sender), false);
1084     }
1085 
1086     function claimETHOverflow(uint256 amount) external onlyOwner {
1087         require(amount < address(this).balance, "Brewlabs: Cannot send more than contract balance");
1088         (bool success, ) = address(owner()).call{ value: amount }("");
1089         if (success) {
1090             emit ClaimETHOverflow(amount);
1091         }
1092     }
1093 
1094     function mint(address account, uint256 value) external hasMintPermission returns (bool) {
1095         _mint(account, value);
1096         try dividendTracker.setBalance(payable(account), balanceOf(account)) {} catch {}
1097         return true;
1098     }
1099 
1100     function burn(uint256 value) external {
1101         _burn(msg.sender, value);
1102         try dividendTracker.setBalance(payable(msg.sender), balanceOf(msg.sender)) {} catch {}
1103     }
1104 
1105     function setBridgeContract(address _bridgeContract) external onlyOwner {
1106         require(_bridgeContract != address(0x0) && _bridgeContract != bridge, "Brewlabs: Invalid bridge");
1107         bridge = _bridgeContract;
1108         emit SetBridgeContract(_bridgeContract);
1109     }
1110 
1111     // Getters
1112     function getTotalDividendsDistributed() external view returns (uint256) {
1113         return dividendTracker.totalDividendsDistributed();
1114     }
1115 
1116     function withdrawableDividendOf(address account) external view returns (uint256) {
1117         return dividendTracker.withdrawableDividendOf(account);
1118     }
1119 
1120     function dividendTokenBalanceOf(address account) external view returns (uint256) {
1121         return dividendTracker.balanceOf(account);
1122     }
1123 
1124     function getNumberOfDividendTokenHolders() external view returns (uint256) {
1125         return dividendTracker.getNumberOfTokenHolders();
1126     }
1127 
1128     function getBaseBuyFees()
1129         external
1130         view
1131         returns (
1132             uint8,
1133             uint8,
1134             uint8,
1135             uint8,
1136             uint8
1137         )
1138     {
1139         return (
1140             _base.liquidityFeeOnBuy,
1141             _base.devFeeOnBuy,
1142             _base.buyBackFeeOnBuy,
1143             _base.stakingFeeOnBuy,
1144             _base.holdersFeeOnBuy
1145         );
1146     }
1147 
1148     function getBaseSellFees()
1149         external
1150         view
1151         returns (
1152             uint8,
1153             uint8,
1154             uint8,
1155             uint8,
1156             uint8
1157         )
1158     {
1159         return (
1160             _base.liquidityFeeOnSell,
1161             _base.devFeeOnSell,
1162             _base.buyBackFeeOnSell,
1163             _base.stakingFeeOnSell,
1164             _base.holdersFeeOnSell
1165         );
1166     }
1167 
1168     // Main
1169     function _transfer(
1170         address from,
1171         address to,
1172         uint256 amount
1173     ) internal override {
1174         require(from != address(0), "ERC20: transfer from the zero address");
1175         require(to != address(0), "ERC20: transfer to the zero address");
1176 
1177         if (amount == 0) {
1178             super._transfer(from, to, 0);
1179             return;
1180         }
1181 
1182         if (!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
1183             require(isTradingEnabled, "Brewlabs: Trading is currently disabled.");
1184             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
1185                 require(amount <= maxTxAmount, "Brewlabs: Buy amount exceeds the maxTxBuyAmount.");
1186             }
1187             if (!_isExcludedFromMaxWalletLimit[to]) {
1188                 require((balanceOf(to) + amount) <= maxWalletAmount, "Brewlabs: Expected wallet amount exceeds the maxWalletAmount.");
1189             }
1190         }
1191 
1192         _adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], from, to);
1193         bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
1194 
1195         if (
1196             isTradingEnabled &&
1197             canSwap &&
1198             !_swapping &&
1199             _totalFee > 0 &&
1200             automatedMarketMakerPairs[to]
1201         ) {
1202             _swapping = true;
1203             _swapAndLiquify();
1204             _swapping = false;
1205         }
1206 
1207         bool takeFee = !_swapping && isTradingEnabled;
1208 
1209         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1210             takeFee = false;
1211         }
1212         if (takeFee && _totalFee > 0) {
1213             uint256 fee = (amount * _totalFee) / 100;
1214             amount = amount - fee;
1215             super._transfer(from, address(this), fee);
1216         }
1217         super._transfer(from, to, amount);
1218 
1219         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1220         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1221     }
1222 
1223     function _adjustTaxes(
1224         bool isBuyFromLp,
1225         bool isSelltoLp,
1226         address from,
1227         address to
1228     ) private {
1229         _liquidityFee = 0;
1230         _devFee = 0;
1231         _buyBackFee = 0;
1232         _stakingFee = 0;
1233         _holdersFee = 0;
1234 
1235         if (isBuyFromLp) {
1236             _liquidityFee = _base.liquidityFeeOnBuy;
1237             _devFee = _base.devFeeOnBuy;
1238             _buyBackFee = _base.buyBackFeeOnBuy;
1239             _stakingFee = _base.stakingFeeOnBuy;
1240             _holdersFee = _base.holdersFeeOnBuy;
1241         }
1242         if (isSelltoLp) {
1243             _liquidityFee = _base.liquidityFeeOnSell;
1244             _devFee = _base.devFeeOnSell;
1245             _buyBackFee = _base.buyBackFeeOnSell;
1246             _stakingFee = _base.stakingFeeOnSell;
1247             _holdersFee = _base.holdersFeeOnSell;
1248         }
1249         if (
1250             !isSelltoLp &&
1251             !isBuyFromLp &&
1252             (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])
1253         ) {
1254             _liquidityFee = _base.liquidityFeeOnBuy;
1255             _devFee = _base.devFeeOnBuy;
1256             _buyBackFee = _base.buyBackFeeOnBuy;
1257             _stakingFee = _base.stakingFeeOnBuy;
1258             _holdersFee = _base.holdersFeeOnBuy;
1259         }
1260         _totalFee = _liquidityFee + _devFee + _buyBackFee + _stakingFee + _holdersFee;
1261         emit FeesApplied(_liquidityFee, _devFee, _buyBackFee, _stakingFee, _holdersFee, _totalFee);
1262     }
1263 
1264     function _setCustomSellTaxPeriod(
1265         CustomTaxPeriod storage map,
1266         uint8 _liquidityFeeOnSell,
1267         uint8 _devFeeOnSell,
1268         uint8 _buyBackFeeOnSell,
1269         uint8 _stakingFeeOnSell,
1270         uint8 _holdersFeeOnSell
1271     ) private {
1272         if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
1273             emit CustomTaxPeriodChange(
1274                 _liquidityFeeOnSell,
1275                 map.liquidityFeeOnSell,
1276                 "liquidityFeeOnSell",
1277                 map.periodName
1278             );
1279             map.liquidityFeeOnSell = _liquidityFeeOnSell;
1280         }
1281         if (map.devFeeOnSell != _devFeeOnSell) {
1282             emit CustomTaxPeriodChange(
1283                 _devFeeOnSell,
1284                 map.devFeeOnSell,
1285                 "devFeeOnSell",
1286                 map.periodName
1287             );
1288             map.devFeeOnSell = _devFeeOnSell;
1289         }
1290         if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
1291             emit CustomTaxPeriodChange(
1292                 _buyBackFeeOnSell,
1293                 map.buyBackFeeOnSell,
1294                 "buyBackFeeOnSell",
1295                 map.periodName
1296             );
1297             map.buyBackFeeOnSell = _buyBackFeeOnSell;
1298         }
1299         if (map.stakingFeeOnSell != _stakingFeeOnSell) {
1300             emit CustomTaxPeriodChange(
1301                 _stakingFeeOnSell,
1302                 map.stakingFeeOnSell,
1303                 "stakingFeeOnSell",
1304                 map.periodName
1305             );
1306             map.stakingFeeOnSell = _stakingFeeOnSell;
1307         }
1308         if (map.holdersFeeOnSell != _holdersFeeOnSell) {
1309             emit CustomTaxPeriodChange(
1310                 _holdersFeeOnSell,
1311                 map.holdersFeeOnSell,
1312                 "holdersFeeOnSell",
1313                 map.periodName
1314             );
1315             map.holdersFeeOnSell = _holdersFeeOnSell;
1316         }
1317     }
1318 
1319     function _setCustomBuyTaxPeriod(
1320         CustomTaxPeriod storage map,
1321         uint8 _liquidityFeeOnBuy,
1322         uint8 _devFeeOnBuy,
1323         uint8 _buyBackFeeOnBuy,
1324         uint8 _stakingFeeOnBuy,
1325         uint8 _holdersFeeOnBuy
1326     ) private {
1327         if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
1328             emit CustomTaxPeriodChange(
1329                 _liquidityFeeOnBuy,
1330                 map.liquidityFeeOnBuy,
1331                 "liquidityFeeOnBuy",
1332                 map.periodName
1333             );
1334             map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
1335         }
1336         if (map.devFeeOnBuy != _devFeeOnBuy) {
1337             emit CustomTaxPeriodChange(
1338                 _devFeeOnBuy,
1339                 map.devFeeOnBuy,
1340                 "devFeeOnBuy",
1341                 map.periodName
1342             );
1343             map.devFeeOnBuy = _devFeeOnBuy;
1344         }
1345         if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
1346             emit CustomTaxPeriodChange(
1347                 _buyBackFeeOnBuy,
1348                 map.buyBackFeeOnBuy,
1349                 "buyBackFeeOnBuy",
1350                 map.periodName
1351             );
1352             map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
1353         }
1354         if (map.stakingFeeOnBuy != _stakingFeeOnBuy) {
1355             emit CustomTaxPeriodChange(
1356                 _stakingFeeOnBuy,
1357                 map.stakingFeeOnBuy,
1358                 "stakingFeeOnBuy",
1359                 map.periodName
1360             );
1361             map.stakingFeeOnBuy = _stakingFeeOnBuy;
1362         }
1363         if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
1364             emit CustomTaxPeriodChange(
1365                 _holdersFeeOnBuy,
1366                 map.holdersFeeOnBuy,
1367                 "holdersFeeOnBuy",
1368                 map.periodName
1369             );
1370             map.holdersFeeOnBuy = _holdersFeeOnBuy;
1371         }
1372     }
1373 
1374     function _swapAndLiquify() private {
1375         uint256 contractBalance = balanceOf(address(this));
1376         uint256 initialETHBalance = address(this).balance;
1377 
1378         uint256 amountToLiquify = (contractBalance * _liquidityFee) / _totalFee / 2;
1379         uint256 amountForStaking = (contractBalance * _stakingFee) / _totalFee;
1380         uint256 amountToSwap = contractBalance - (amountToLiquify + amountForStaking);
1381 
1382         _swapTokensForETH(amountToSwap);
1383 
1384         uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
1385         uint256 totalETHFee = _totalFee - (_liquidityFee / 2) - _stakingFee;
1386         uint256 amountETHLiquidity = (ETHBalanceAfterSwap * _liquidityFee) / totalETHFee / 2;
1387         uint256 amountETHBuyBack = (ETHBalanceAfterSwap * _buyBackFee) / totalETHFee;
1388         uint256 amountETHDev = (ETHBalanceAfterSwap * _devFee) / totalETHFee;
1389         uint256 amountETHHolders = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHBuyBack + amountETHDev);
1390 
1391         Address.sendValue(payable(buyBackWallet),amountETHBuyBack);
1392         Address.sendValue(payable(devWallet),amountETHDev);
1393 
1394         if (amountToLiquify > 0) {
1395             _addLiquidity(amountToLiquify, amountETHLiquidity);
1396             emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
1397         }
1398 
1399         bool success = IERC20(address(this)).transfer(address(stakingAddress), amountForStaking);
1400 
1401         (success, ) = address(dividendTracker).call{ value: amountETHHolders }("");
1402         if (success) {
1403             emit DividendsSent(amountETHHolders);
1404         }
1405     }
1406 
1407     function _swapTokensForETH(uint256 tokenAmount) private {
1408         address[] memory path = new address[](2);
1409         path[0] = address(this);
1410         path[1] = uniswapV2Router.WETH();
1411         _approve(address(this), address(uniswapV2Router), tokenAmount);
1412         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1413             tokenAmount,
1414             1, // accept any amount of ETH
1415             path,
1416             address(this),
1417             block.timestamp
1418         );
1419     }
1420 
1421     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1422         _approve(address(this), address(uniswapV2Router), tokenAmount);
1423         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
1424             address(this),
1425             tokenAmount,
1426             1, // slippage is unavoidable
1427             1, // slippage is unavoidable
1428             liquidityWallet,
1429             block.timestamp
1430         );
1431     }
1432 }
1433 
1434 contract BrewlabsDividendTracker is DividendPayingToken {
1435     using SafeMath for uint256;
1436     using SafeMathInt for int256;
1437     using IterableMapping for IterableMapping.Map;
1438 
1439     IterableMapping.Map private tokenHoldersMap;
1440 
1441     mapping(address => bool) public excludedFromDividends;
1442     mapping(address => uint256) public lastClaimTimes;
1443     uint256 public claimWait;
1444     uint256 public minimumTokenBalanceForDividends;
1445 
1446     event ExcludeFromDividends(address indexed account);
1447     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1448     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1449 
1450     constructor() DividendPayingToken("Brewlabs_Dividend_Tracker", "Brewlabs_Dividend_Tracker") {
1451         claimWait = 3600;
1452         minimumTokenBalanceForDividends = 0 * (10**18);
1453     }
1454 
1455     function setRewardToken(address token) external onlyOwner {
1456         _setRewardToken(token);
1457     }
1458 
1459     function setUniswapRouter(address router) external onlyOwner {
1460         _setUniswapRouter(router);
1461     }
1462 
1463     function _transfer(
1464         address,
1465         address,
1466         uint256
1467     ) internal pure override {
1468         require(false, "Brewlabs_Dividend_Tracker: No transfers allowed");
1469     }
1470 
1471     function excludeFromDividends(address account) external onlyOwner {
1472         require(!excludedFromDividends[account]);
1473         excludedFromDividends[account] = true;
1474         _setBalance(account, 0);
1475         tokenHoldersMap.remove(account);
1476         emit ExcludeFromDividends(account);
1477     }
1478 
1479     function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1480         require(
1481             minimumTokenBalanceForDividends != newValue,
1482             "Brewlabs_Dividend_Tracker: minimumTokenBalanceForDividends already the value of 'newValue'."
1483         );
1484         minimumTokenBalanceForDividends = newValue;
1485     }
1486 
1487     function getNumberOfTokenHolders() external view returns (uint256) {
1488         return tokenHoldersMap.keys.length;
1489     }
1490 
1491     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1492         if (excludedFromDividends[account]) {
1493             return;
1494         }
1495         if (newBalance >= minimumTokenBalanceForDividends) {
1496             _setBalance(account, newBalance);
1497             tokenHoldersMap.set(account, newBalance);
1498         } else {
1499             _setBalance(account, 0);
1500             tokenHoldersMap.remove(account);
1501         }
1502         processAccount(account, true);
1503     }
1504 
1505     function processAccount(address payable account, bool automatic)
1506         public
1507         onlyOwner
1508         returns (bool)
1509     {
1510         uint256 amount = _withdrawDividendOfUser(account);
1511         if (amount > 0) {
1512             lastClaimTimes[account] = block.timestamp;
1513             emit Claim(account, amount, automatic);
1514             return true;
1515         }
1516         return false;
1517     }
1518 }