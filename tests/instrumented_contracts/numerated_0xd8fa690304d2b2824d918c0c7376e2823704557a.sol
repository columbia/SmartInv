1 /**
2 
3 https://t.me/SquidGrowOfficial
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.14;
10 
11 library SafeMath {
12     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13         unchecked {
14             uint256 c = a + b;
15             if (c < a) return (false, 0);
16             return (true, c);
17         }
18     }
19 
20     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             if (b > a) return (false, 0);
23             return (true, a - b);
24         }
25     }
26 
27     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30             // benefit is lost if 'b' is also tested.
31             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
32             if (a == 0) return (true, 0);
33             uint256 c = a * b;
34             if (c / a != b) return (false, 0);
35             return (true, c);
36         }
37     }
38 
39     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b == 0) return (false, 0);
42             return (true, a / b);
43         }
44     }
45 
46     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b == 0) return (false, 0);
49             return (true, a % b);
50         }
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a + b;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a - b;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a * b;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a / b;
67     }
68 
69     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a % b;
71     }
72 
73     function sub(
74         uint256 a,
75         uint256 b,
76         string memory errorMessage
77     ) internal pure returns (uint256) {
78         unchecked {
79             require(b <= a, errorMessage);
80             return a - b;
81         }
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         unchecked {
90             require(b > 0, errorMessage);
91             return a / b;
92         }
93     }
94 
95     function mod(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         unchecked {
101             require(b > 0, errorMessage);
102             return a % b;
103         }
104     }
105 }
106 
107 interface IERC20 {
108  
109     event Transfer(address indexed from, address indexed to, uint256 value);
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 
112     function totalSupply() external view returns (uint256);
113     function balanceOf(address account) external view returns (uint256);
114     function transfer(address to, uint256 amount) external returns (bool);
115     function allowance(address owner, address spender) external view returns (uint256);
116     function approve(address spender, uint256 amount) external returns (bool);
117     function transferFrom(
118         address from,
119         address to,
120         uint256 amount
121     ) external returns (bool);
122 }
123 
124 library Address {
125 
126     function isContract(address account) internal view returns (bool) {
127         return account.code.length > 0;
128     }
129 
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         (bool success, ) = recipient.call{value: amount}("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
138         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
139     }
140 
141     function functionCall(
142         address target,
143         bytes memory data,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, 0, errorMessage);
147     }
148 
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value
153     ) internal returns (bytes memory) {
154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
155     }
156 
157     function functionCallWithValue(
158         address target,
159         bytes memory data,
160         uint256 value,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         require(address(this).balance >= value, "Address: insufficient balance for call");
164         (bool success, bytes memory returndata) = target.call{value: value}(data);
165         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
166     }
167 
168     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
169         return functionStaticCall(target, data, "Address: low-level static call failed");
170     }
171 
172     function functionStaticCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal view returns (bytes memory) {
177         (bool success, bytes memory returndata) = target.staticcall(data);
178         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
179     }
180 
181     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
183     }
184 
185     function functionDelegateCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         (bool success, bytes memory returndata) = target.delegatecall(data);
191         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
192     }
193 
194     function verifyCallResultFromTarget(
195         address target,
196         bool success,
197         bytes memory returndata,
198         string memory errorMessage
199     ) internal view returns (bytes memory) {
200         if (success) {
201             if (returndata.length == 0) {
202                 // only check isContract if the call was successful and the return data is empty
203                 // otherwise we already know that it was a contract
204                 require(isContract(target), "Address: call to non-contract");
205             }
206             return returndata;
207         } else {
208             _revert(returndata, errorMessage);
209         }
210     }
211 
212     function verifyCallResult(
213         bool success,
214         bytes memory returndata,
215         string memory errorMessage
216     ) internal pure returns (bytes memory) {
217         if (success) {
218             return returndata;
219         } else {
220             _revert(returndata, errorMessage);
221         }
222     }
223 
224     function _revert(bytes memory returndata, string memory errorMessage) private pure {
225         // Look for revert reason and bubble it up if present
226         if (returndata.length > 0) {
227             // The easiest way to bubble the revert reason is using memory via assembly
228             /// @solidity memory-safe-assembly
229             assembly {
230                 let returndata_size := mload(returndata)
231                 revert(add(32, returndata), returndata_size)
232             }
233         } else {
234             revert(errorMessage);
235         }
236     }
237 }
238 
239 interface IERC20Permit {
240     function permit(
241         address owner,
242         address spender,
243         uint256 value,
244         uint256 deadline,
245         uint8 v,
246         bytes32 r,
247         bytes32 s
248     ) external;
249 
250     function nonces(address owner) external view returns (uint256);
251     // solhint-disable-next-line func-name-mixedcase
252     function DOMAIN_SEPARATOR() external view returns (bytes32);
253 }
254 
255 library SafeERC20 {
256     using Address for address;
257 
258     function safeTransfer(
259         IERC20 token,
260         address to,
261         uint256 value
262     ) internal {
263         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
264     }
265 
266     function safeTransferFrom(
267         IERC20 token,
268         address from,
269         address to,
270         uint256 value
271     ) internal {
272         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
273     }
274 
275     function safeApprove(
276         IERC20 token,
277         address spender,
278         uint256 value
279     ) internal {
280         // safeApprove should only be called when setting an initial allowance,
281         // or when resetting it to zero. To increase and decrease it, use
282         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
283         require(
284             (value == 0) || (token.allowance(address(this), spender) == 0),
285             "SafeERC20: approve from non-zero to non-zero allowance"
286         );
287         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
288     }
289 
290     function safeIncreaseAllowance(
291         IERC20 token,
292         address spender,
293         uint256 value
294     ) internal {
295         uint256 newAllowance = token.allowance(address(this), spender) + value;
296         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
297     }
298 
299     function safeDecreaseAllowance(
300         IERC20 token,
301         address spender,
302         uint256 value
303     ) internal {
304         unchecked {
305             uint256 oldAllowance = token.allowance(address(this), spender);
306             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
307             uint256 newAllowance = oldAllowance - value;
308             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
309         }
310     }
311 
312     function safePermit(
313         IERC20Permit token,
314         address owner,
315         address spender,
316         uint256 value,
317         uint256 deadline,
318         uint8 v,
319         bytes32 r,
320         bytes32 s
321     ) internal {
322         uint256 nonceBefore = token.nonces(owner);
323         token.permit(owner, spender, value, deadline, v, r, s);
324         uint256 nonceAfter = token.nonces(owner);
325         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
326     }
327 
328     function _callOptionalReturn(IERC20 token, bytes memory data) private {
329         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
330         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
331         // the target address contains contract code and also asserts for success in the low-level call.
332 
333         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
334         if (returndata.length > 0) {
335             // Return data is optional
336             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
337         }
338     }
339 }
340 abstract contract Auth {
341     address public owner;
342     mapping (address => bool) internal authorizations;
343     
344     constructor(address _owner) {
345         owner = _owner;
346         authorizations[_owner] = true; 
347     }
348     
349     modifier onlyOwner() {
350         require(isOwner(msg.sender), "!OWNER");
351         _;
352     }
353 
354     modifier authorized() {
355         require(isAuthorized(msg.sender), "!AUTHORIZED");
356         _;
357     }
358     
359     function authorize(address adr) public authorized {
360         authorizations[adr] = true;
361     }
362 
363     function unauthorize(address adr) public authorized {
364         authorizations[adr] = false;
365     }
366 
367     function isOwner(address account) public view returns (bool) {
368         return account == owner;
369     }
370 
371     function isAuthorized(address adr) public view returns (bool) {
372         return authorizations[adr];
373     }
374     
375     function transferOwnership(address payable adr) public authorized {
376         require(adr != address(0), "Zero Address");
377         owner = adr;
378         authorizations[adr] = true;
379         emit OwnershipTransferred(adr);}
380     
381     function renounceOwnership() external authorized {
382         emit OwnershipTransferred(address(0));
383         owner = address(0);}
384     
385     event OwnershipTransferred(address owner);
386 }
387 
388 
389 interface IFactory{
390         function createPair(address tokenA, address tokenB) external returns (address pair);
391         function getPair(address tokenA, address tokenB) external view returns (address pair);
392 }
393 
394 interface IRouter {
395     function factory() external pure returns (address);
396     function WETH() external pure returns (address);
397     function addLiquidityETH(
398         address token,
399         uint amountTokenDesired,
400         uint amountTokenMin,
401         uint amountETHMin,
402         address to,
403         uint deadline
404     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
405 
406     function swapExactETHForTokensSupportingFeeOnTransferTokens(
407         uint amountOutMin,
408         address[] calldata path,
409         address to,
410         uint deadline
411     ) external payable;
412 
413     function swapExactTokensForETHSupportingFeeOnTransferTokens(
414         uint amountIn,
415         uint amountOutMin,
416         address[] calldata path,
417         address to,
418         uint deadline) external;
419 }
420 
421 interface IPair {
422     function sync() external;
423 }
424 
425 interface IWeth {
426     function deposit() external payable;
427 }
428 
429 contract SquidGrow  is IERC20, Auth {
430     using SafeMath for uint256;
431     using SafeERC20 for IERC20;
432 
433     string private constant _name = 'SquidGrow';
434     string private constant _symbol = 'SquidGrow';
435     uint8 private constant _decimals = 9;
436     uint256 private constant _totalSupply = 10 * 10**14 * (10 ** _decimals);
437 
438     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
439     uint256 public _maxTxAmount = ( _totalSupply * 30 ) / 10000;
440     uint256 public _maxWalletAmount = ( _totalSupply * 500 ) / 10000;
441 
442     mapping (address => uint256) _balances;
443     mapping (address => mapping (address => uint256)) private _allowances;
444     mapping (address => bool) _isBot;
445     mapping (address => bool) isWhitelisted;
446     mapping (address => bool) isBlacklisted;
447 
448     IRouter public immutable router;
449     address public immutable pair;
450     bool tradingEnabled = false;
451     uint256 startedTime;
452 
453     uint256 constant feeDenominator = 10000;
454 
455     struct Fee {
456         uint256 stakingFee;
457         uint256 burnFee;
458         uint256 liquidFee; // marketingFee + autoLPFee + teamFee
459         uint256 totalFee;
460     }
461 
462     enum TransactionType {BUY, SELL, TRANSFER}
463 
464     mapping (TransactionType => Fee) public fees;
465 
466     bool swapAndLiquifyEnabled = false;
467     uint256 swapTimes; 
468     uint256 minTransactionsBeforeSwap = 7;
469     bool swapping; 
470     bool antiBotEnabled = true;
471 
472     uint256 swapThreshold = ( _totalSupply * 300 ) / 100000;
473     uint256 _minTokenAmount = ( _totalSupply * 15 ) / 100000;
474 
475     uint256 marketing_divisor = 0;
476     uint256 liquidity_divisor = 100;
477     uint256 team_divisor = 0;
478     uint256 total_divisor = 100;
479 
480     address liquidity_receiver; 
481     address staking_receiver;
482     address marketing_receiver;
483 
484     address team1_receiver;
485     address team2_receiver;
486     address team3_receiver;
487     address team4_receiver;
488 
489     address public multisig = address(0x4B1AbbdEaC18EaA719C608BcCF9005711f296E87); // it will be updated to mutlisig address before deployemnt.
490 
491     event WhitelistUpdated(address indexed account, bool indexed whitelisted);
492     event BotUpdated(address indexed account, bool indexed isBot);
493     event BlacklistedUpdated(address indexed account, bool indexed blacklisted);
494     event AntiBotStateUpdated(bool indexed enabled);
495     event TradingEnabled();
496     event TradingDisabled();
497     event SwapBackSettingsUpdated(bool indexed enabled, uint256 threshold, uint256 minLimit, uint256 _minTransactions);
498     event MaxLimitsUpdated(uint256 maxTxAmount, uint256 maxWalletAmount);
499     event UnsupportedTokensRecoverd(address indexed token, address receiver, uint256 amount);
500     event DivisorsUpdated(uint256 team, uint256 liquidity, uint256 marketing);
501     event TeamFundsDistributed(address team1, address team2, address team3, address team4, uint256 amount);
502     event FeesUpdated(TransactionType indexed transactionType, uint256 burnFee, uint256 stakingFee, uint256 swapAndLiquifyFee);
503     event FeesAddressesUpdated(address marketing, address liquidity, address staking);
504     event TeamAddressesUpdated(address team1, address team2, address team3, address team4);
505     event ForceAdjustedLP(bool indexed squid, uint256 amount, bool indexed add);
506     event TokensAirdroped(address indexed sender, uint256 length, uint256 airdropedAmount);
507     event MultisigUpdated(address indexed multisig);
508 
509     modifier lockTheSwap {
510         swapping = true; 
511         _;
512         swapping = false;
513     }
514 
515     modifier onlyMultisig {
516         require(msg.sender == multisig, "Not multisig");
517         _;
518     }
519 
520     constructor() Auth(msg.sender) {
521         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // eth - 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
522         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
523         router = _router;
524         pair = _pair;
525 
526         // initilasing Fees
527         fees[TransactionType.SELL] = Fee (0, 0, 1200, 1200);
528         fees[TransactionType.BUY] = Fee (0, 0, 400, 400);
529         fees[TransactionType.TRANSFER] = Fee (0, 0, 0, 0);
530         
531         isBlacklisted[address(0)] = true;
532        
533         isWhitelisted[msg.sender] = true;
534         isWhitelisted[address(this)] = true;
535 
536         liquidity_receiver = address(this);
537         team1_receiver = msg.sender;
538         team2_receiver = msg.sender;
539         team3_receiver = msg.sender;
540         team4_receiver = msg.sender;
541         staking_receiver = msg.sender;
542         marketing_receiver = msg.sender;
543 
544         _balances[msg.sender] = _totalSupply;
545         emit Transfer(address(0), msg.sender, _totalSupply);
546     }
547 
548     receive() external payable {}
549 
550     function name() public pure returns (string memory) {return _name;}
551     function symbol() public pure returns (string memory) {return _symbol;}
552     function decimals() public pure returns (uint8) {return _decimals;}
553     function totalSupply() public pure override returns (uint256) {return _totalSupply;}
554     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
555     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
556     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
557 
558     function isBot(address _address) public view returns (bool) {
559         return _isBot[_address];
560     }
561 
562     function approve(address spender, uint256 amount) public override returns (bool) {
563         _approve(msg.sender, spender, amount);
564         return true;
565     }
566     
567     function getCirculatingSupply() public view returns (uint256) {
568         return _totalSupply.sub(balanceOf(DEAD));
569     }
570 
571     function whitelistAddress(address _address, bool _whitelist) external authorized { 
572         require(isWhitelisted[_address] != _whitelist, "Already set");
573         isWhitelisted[_address] = _whitelist;
574 
575         emit WhitelistUpdated(_address, _whitelist);
576     }
577 
578     function blacklistAddress(address _address, bool _blacklist) external authorized { 
579         require(isBlacklisted[_address] != _blacklist, "Already set");
580         isBlacklisted[_address] = _blacklist;
581 
582         emit BlacklistedUpdated(_address, _blacklist);
583     }
584 
585     function updateBot(address _address, bool isBot_) external authorized {
586         require(_isBot[_address] != isBot_, "Already set");
587         _isBot[_address] = isBot_;
588 
589         emit BotUpdated(_address, isBot_);
590     }
591 
592     function enableAntiBot(bool _enable) external authorized {
593         require(antiBotEnabled != _enable, "Already set");
594         antiBotEnabled = _enable;
595 
596         emit AntiBotStateUpdated(_enable);
597     }
598 
599     function enableTrading(uint256 _input) external authorized {
600         require(!tradingEnabled, "Already Enabled!");
601         tradingEnabled = true;
602         if(startedTime == 0) // initialise only once
603             startedTime = block.timestamp.add(_input);
604         
605         emit TradingEnabled();
606     }
607 
608     function disableTrading() external onlyMultisig {
609         require(tradingEnabled, "Already disabled!");
610         tradingEnabled = false;
611 
612         emit TradingDisabled();
613     }
614 
615     function updateSwapBackSettings(bool _enabled, uint256 _threshold, uint256 _minLimit, uint256 _minTransactionsBeforeSwap) external authorized {
616         swapAndLiquifyEnabled = _enabled; 
617         swapThreshold = _threshold;
618         _minTokenAmount = _minLimit;
619         minTransactionsBeforeSwap = _minTransactionsBeforeSwap;
620 
621         emit SwapBackSettingsUpdated( _enabled, _threshold, _minLimit, _minTransactionsBeforeSwap);
622     }
623 
624     function transferFrom(
625         address from,
626         address to,
627         uint256 amount
628     ) public override returns (bool) {
629         _spendAllowance(from, msg.sender, amount);
630         _transfer(from, to, amount);
631         return true;
632     }
633 
634     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
635         _approve(msg.sender, spender, allowance(msg.sender, spender) + addedValue);
636         return true;
637     }
638 
639     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
640         uint256 currentAllowance = allowance(msg.sender, spender);
641         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
642         unchecked {
643             _approve(msg.sender, spender, currentAllowance - subtractedValue);
644         }
645 
646         return true;
647     }
648 
649     function _approve(
650         address owner,
651         address spender,
652         uint256 amount
653     ) internal {
654         require(owner != address(0), "ERC20: approve from the zero address");
655         require(spender != address(0), "ERC20: approve to the zero address");
656 
657         _allowances[owner][spender] = amount;
658         emit Approval(owner, spender, amount);
659     }
660 
661     function _spendAllowance(
662         address owner,
663         address spender,
664         uint256 amount
665     ) internal virtual {
666         uint256 currentAllowance = allowance(owner, spender);
667         if (currentAllowance != type(uint256).max) {
668             require(currentAllowance >= amount, "ERC20: insufficient allowance");
669             unchecked {
670                 _approve(owner, spender, currentAllowance - amount);
671             }
672         }
673     }
674 
675     function _transfer(address sender, address recipient, uint256 amount) private {
676         preTxCheck(sender, recipient, amount);
677 
678         bool takeFee = true;
679         if (isWhitelisted[sender] || isWhitelisted[recipient]) {
680             takeFee = false;
681 
682         } else {
683             require(tradingEnabled, "Trading is Paused");
684             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
685             if (recipient != pair) {
686                 require(_balances[recipient] + amount <= _maxWalletAmount, "Wallet amount exceeds limit");
687             }
688 
689         }
690 
691         TransactionType transactionType;
692 
693         if(sender == pair) {
694             transactionType = TransactionType.BUY;
695             if(recipient != address(router) && block.timestamp <= startedTime) {
696                 _isBot[recipient] = true;
697             }
698         } else if (recipient == pair) {
699             transactionType = TransactionType.SELL;
700         } else {
701             transactionType = TransactionType.TRANSFER;
702         }
703 
704         swapTimes = swapTimes.add(1);
705         if(shouldSwapBack(sender, amount)){
706             swapAndLiquify(swapThreshold);
707             swapTimes = 0;
708         }
709 
710         _balances[sender] = _balances[sender].sub(amount);
711         uint256 amountReceived = takeFee ? takeTotalFee(sender, amount, transactionType) : amount;
712         _balances[recipient] = _balances[recipient].add(amountReceived);
713         emit Transfer(sender, recipient, amountReceived);
714     }
715 
716     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
717         require(!isBlacklisted[sender], "Blackisted");
718         require(!isBlacklisted[recipient], "Blackisted");
719         require(amount > 0, "Transfer amount must be greater than zero");
720         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
721     }
722 
723     function takeTotalFee(address sender, uint256 amount, TransactionType transactionType) internal returns (uint256) {
724         Fee memory fee = fees[transactionType];
725         uint256 totalFees = _isBot[sender] && antiBotEnabled? (feeDenominator - 100) : fee.totalFee; // 99% fees if bot
726         if (totalFees == 0) {
727             return amount;
728         }
729         uint256 feeAmount = (amount.mul(totalFees)).div(feeDenominator);
730         uint256 burnAmount = (feeAmount.mul(fee.burnFee)).div(totalFees);
731         uint256 stakingAmount = (feeAmount.mul(fee.stakingFee)).div(totalFees);
732 
733         uint256 liquidAmount = feeAmount.sub(burnAmount).sub(stakingAmount);
734 
735         if(burnAmount > 0) {
736             _balances[address(DEAD)] = _balances[address(DEAD)].add(burnAmount);
737             emit Transfer(sender, address(DEAD), burnAmount);
738         }
739         if(stakingAmount > 0) {
740             _balances[address(staking_receiver)] = _balances[address(staking_receiver)].add(stakingAmount);
741             emit Transfer(sender, address(staking_receiver), stakingAmount);
742         }
743         if(liquidAmount > 0) {
744             _balances[address(this)] = _balances[address(this)].add(liquidAmount);
745             emit Transfer(sender, address(this), liquidAmount);
746         } 
747         return amount.sub(feeAmount);
748 
749     }
750 
751     function updateMaxLimits(uint256 _transaction, uint256 _wallet) external authorized {
752         require(_transaction >= 1, "Max txn limit cannot be less than 0.00001%");
753         require(_wallet >= 500000, "Max Wallet limit cannot be less than 5%");
754         uint256 newTxLimit = ( _totalSupply * _transaction ) / 10000000;
755         uint256 newWalletLimit = ( _totalSupply * _wallet ) / 10000000;
756         _maxTxAmount = newTxLimit;
757         _maxWalletAmount = newWalletLimit;
758 
759         emit MaxLimitsUpdated(_maxTxAmount, _maxWalletAmount);
760     }
761 
762     function recoverUnsupportedTokens(address _token, address _receiver, uint256 _percentage) external authorized {
763         uint256 amount = IERC20(_token).balanceOf(address(this));
764         uint256 amountToWithdraw = amount.mul(_percentage).div(10000);
765         IERC20(_token).safeTransfer(_receiver, amountToWithdraw);
766 
767         emit UnsupportedTokensRecoverd(_token, _receiver, amountToWithdraw);
768     }
769 
770     function updateDivisors(uint256 _team, uint256 _liquidity, uint256 _marketing) external authorized {
771         team_divisor = _team;
772         liquidity_divisor = _liquidity;
773         marketing_divisor = _marketing;
774         total_divisor = _team.add(_liquidity).add(_marketing);
775 
776         emit DivisorsUpdated(_team, _liquidity, _marketing);
777     }
778 
779     function distributeTeamFunds(uint256 _numerator, uint256 _denominator) external authorized {
780         uint256 ethAmount = address(this).balance;
781         uint256 distributeAmount = ethAmount.mul(_numerator).div(_denominator);
782         uint256 amountToSend = distributeAmount.div(4);
783         transferETH(team1_receiver, amountToSend);
784         transferETH(team2_receiver, amountToSend);
785         transferETH(team3_receiver, amountToSend);
786         transferETH(team4_receiver, amountToSend);
787 
788         emit TeamFundsDistributed(team1_receiver, team2_receiver, team3_receiver, team4_receiver, distributeAmount);
789     }
790 
791     function updateFee(TransactionType transactionType, uint256 _burnFee, uint256 _stakingFee, uint256 _swapAndLiquifyFee) external onlyMultisig {
792         require(_burnFee.add(_stakingFee).add(_swapAndLiquifyFee) <= feeDenominator.mul(3).div(20), "Tax cannot be more than 15%");
793         Fee storage fee = fees[transactionType];
794         fee.burnFee = _burnFee;
795         fee.stakingFee = _stakingFee;
796         fee.liquidFee = _swapAndLiquifyFee;
797         fee.totalFee = _burnFee.add(_stakingFee).add(_swapAndLiquifyFee);    
798 
799         emit FeesUpdated(transactionType, _burnFee, _stakingFee, _swapAndLiquifyFee);
800     }
801 
802     function updateFeesAddresses(address _marketing, address _liquidity, address _staking) external authorized {
803         require(_marketing != address(0), "Zero Address");
804         require(_liquidity != address(0), "Zero Address");
805         require(_staking != address(0), "Zero Address");
806         marketing_receiver = _marketing;
807         liquidity_receiver = _liquidity;
808         staking_receiver = _staking;
809 
810         emit FeesAddressesUpdated( _marketing, _liquidity, _staking);
811     }
812 
813     function updateTeamAddresses(address _team1, address _team2, address _team3, address _team4) external authorized {
814         require(_team1 != address(0), "Zero Address");
815         require(_team2 != address(0), "Zero Address");
816         require(_team3 != address(0), "Zero Address");
817         require(_team4 != address(0), "Zero Address");
818         team1_receiver = _team1;
819         team2_receiver = _team2;
820         team3_receiver = _team3;
821         team4_receiver = _team4;
822 
823         emit TeamAddressesUpdated( _team1, _team2, _team3, _team4);
824     }
825 
826     function shouldSwapBack(address sender, uint256 amount) internal view returns (bool) {
827         bool aboveMin = amount >= _minTokenAmount;
828         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
829         return !swapping && swapAndLiquifyEnabled && aboveMin && 
830              swapTimes >= minTransactionsBeforeSwap && aboveThreshold && sender != pair;
831     }
832 
833     function swapAndLiquify(uint256 tokens) private lockTheSwap {
834         uint256 amountToLiquify = tokens.mul(liquidity_divisor).div(total_divisor).div(2);
835         uint256 amountToSwap = tokens.sub(amountToLiquify);
836 
837         uint256 initialBalance = address(this).balance;
838         swapTokensForETH(amountToSwap);
839 
840         uint256 deltaBalance = address(this).balance.sub(initialBalance);
841         uint256 totalETHFee = total_divisor.sub(liquidity_divisor.div(2));
842 
843         if(amountToLiquify > 0){
844             addLiquidity(amountToLiquify, deltaBalance.mul(liquidity_divisor).div(totalETHFee).div(2)); 
845         }
846         // transfer ETH to marketing, teamFunds stay in contract for future distribution.
847         transferETH(marketing_receiver, deltaBalance.mul(marketing_divisor).div(totalETHFee));
848     }
849 
850     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
851         _approve(address(this), address(router), tokenAmount);
852         router.addLiquidityETH{value: ethAmount}(
853             address(this),
854             tokenAmount,
855             0,
856             0,
857             liquidity_receiver,
858             block.timestamp);
859     }
860 
861     function swapTokensForETH(uint256 tokenAmount) private {
862         address[] memory path = new address[](2);
863         path[0] = address(this);
864         path[1] = router.WETH();
865         _approve(address(this), address(router), tokenAmount);
866         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
867             tokenAmount,
868             0,
869             path,
870             address(this),
871             block.timestamp);
872     }
873 
874     function transferETH(address recipient, uint256 amount) private {
875         if(amount == 0) return;
876         (bool success, ) = payable(recipient).call{value: amount}("");
877         require(success, "Unable to send ETH");
878     }
879 
880     function airdropTokens(address[] calldata accounts, uint256[] calldata amounts) external authorized {
881         uint256 length = accounts.length;
882         require (length == amounts.length, "array length mismatched");
883         uint256 airdropAmount = 0;
884         
885         for (uint256 i = 0; i < length; i++) {
886             // updating balance directly instead of calling transfer to save gas
887             _balances[accounts[i]] += amounts[i];
888             airdropAmount += amounts[i];
889             emit Transfer(msg.sender, accounts[i], amounts[i]);
890         }
891         _balances[msg.sender] -= airdropAmount;
892 
893         emit TokensAirdroped(msg.sender, length, airdropAmount);
894     }
895 
896     function forceAdjustLP(bool squid, uint256 amount, bool add) external payable onlyMultisig{
897         if(!squid) {
898             require(add, "Cant withdraw bnb from pool");
899             amount = msg.value;
900             IWeth(router.WETH()).deposit{value: amount}();
901             IERC20(router.WETH()).safeTransfer(pair, amount);
902         }else {
903             if(add) {
904                 _balances[msg.sender] -= amount;
905                 _balances[pair] += amount;
906                 emit Transfer(msg.sender, pair, amount);
907 
908             } else {
909                 _balances[pair] -= amount;
910                 _balances[msg.sender] += amount;
911                 emit Transfer(pair, msg.sender, amount);
912             }
913         }
914         IPair(pair).sync();
915         emit ForceAdjustedLP(squid, amount, add);
916     }
917 
918     function setMultisig(address _newMultisig) external onlyMultisig {
919         require(_newMultisig != address(0), "Zero Address");
920         multisig = _newMultisig;
921         emit MultisigUpdated(_newMultisig);
922     }
923 }