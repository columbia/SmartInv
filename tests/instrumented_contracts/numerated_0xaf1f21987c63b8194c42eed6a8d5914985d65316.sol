1 // SPDX-License-Identifier: MIT
2 
3 /*
4 RSP Finance is a unique protocol on Ethereum, it is a perfect combination of Reverse Split Protocol and Revenue Shares Protocol.
5 
6 Website: http://rsp.finance/
7 Twitter: https://twitter.com/rsp_finance
8 Telegram: https://t.me/rsp_finance
9 Announcement: https://t.me/RSPannouncement
10 */
11 
12 pragma solidity 0.8.21;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address who) external view returns (uint256);
18 
19     function allowance(
20         address owner,
21         address spender
22     ) external view returns (uint256);
23 
24     function transfer(address to, uint256 value) external returns (bool);
25 
26     function approve(address spender, uint256 value) external returns (bool);
27 
28     function transferFrom(
29         address from,
30         address to,
31         uint256 value
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 interface InterfaceLP {
43     function sync() external;
44 
45     function mint(address to) external returns (uint liquidity);
46 }
47 
48 interface IDividendTracker {
49     function accumulativeDividendOf(
50         address _owner
51     ) external view returns (uint256);
52 
53     function allowance(
54         address owner,
55         address spender
56     ) external view returns (uint256);
57 
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     function balanceOf(address account) external view returns (uint256);
61 
62     function decimals() external view returns (uint8);
63 
64     function decreaseAllowance(
65         address spender,
66         uint256 subtractedValue
67     ) external returns (bool);
68 
69     function distributeDividends(uint256 amount) external;
70 
71     function dividendOf(address _owner) external view returns (uint256);
72 
73     function excludeFromDividends(address account, bool value) external;
74 
75     function excludedFromDividends(address) external view returns (bool);
76 
77     function getAccount(
78         address account
79     ) external view returns (address, uint256, uint256, uint256, uint256);
80 
81     function increaseAllowance(
82         address spender,
83         uint256 addedValue
84     ) external returns (bool);
85 
86     function lastClaimTimes(address) external view returns (uint256);
87 
88     function owner() external view returns (address);
89 
90     function processAccount(address account) external returns (bool);
91 
92     function renounceOwnership() external;
93 
94     function setBalance(address account, uint256 newBalance) external;
95 
96     function setup() external;
97 
98     function token() external view returns (address);
99 
100     function totalDividendsDistributed() external view returns (uint256);
101 
102     function totalDividendsWithdrawn() external view returns (uint256);
103 
104     function transfer(address to, uint256 amount) external returns (bool);
105 
106     function transferFrom(
107         address from,
108         address to,
109         uint256 amount
110     ) external returns (bool);
111 
112     function transferOwnership(address newOwner) external;
113 
114     function withdrawDividend() external;
115 
116     function withdrawableDividendOf(
117         address _owner
118     ) external view returns (uint256);
119 
120     function withdrawnDividendOf(
121         address _owner
122     ) external view returns (uint256);
123 }
124 
125 abstract contract ERC20Detailed is IERC20 {
126     string private _name;
127     string private _symbol;
128     uint8 private _decimals;
129 
130     constructor(
131         string memory _tokenName,
132         string memory _tokenSymbol,
133         uint8 _tokenDecimals
134     ) {
135         _name = _tokenName;
136         _symbol = _tokenSymbol;
137         _decimals = _tokenDecimals;
138     }
139 
140     function name() public view returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view returns (uint8) {
149         return _decimals;
150     }
151 }
152 
153 interface IDEXRouter {
154     function factory() external pure returns (address);
155 
156     function WETH() external pure returns (address);
157 
158     function addLiquidityETH(
159         address token,
160         uint256 amountTokenDesired,
161         uint256 amountTokenMin,
162         uint256 amountETHMin,
163         address to,
164         uint256 deadline
165     )
166         external
167         payable
168         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
169 
170     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
171         uint256 amountIn,
172         uint256 amountOutMin,
173         address[] calldata path,
174         address to,
175         uint256 deadline
176     ) external;
177 
178     function swapExactETHForTokens(
179         uint256 amountOutMin,
180         address[] calldata path,
181         address to,
182         uint256 deadline
183     ) external payable returns (uint256[] memory amounts);
184 
185     function swapExactTokensForETHSupportingFeeOnTransferTokens(
186         uint256 amountIn,
187         uint256 amountOutMin,
188         address[] calldata path,
189         address to,
190         uint256 deadline
191     ) external;
192 }
193 
194 interface IDEXFactory {
195     function createPair(
196         address tokenA,
197         address tokenB
198     ) external returns (address pair);
199 }
200 
201 contract Ownable {
202     address private _owner;
203 
204     event OwnershipRenounced(address indexed previousOwner);
205 
206     event OwnershipTransferred(
207         address indexed previousOwner,
208         address indexed newOwner
209     );
210 
211     constructor() {
212         _owner = msg.sender;
213     }
214 
215     function owner() public view returns (address) {
216         return _owner;
217     }
218 
219     modifier onlyOwner() {
220         require(msg.sender == _owner, "Not owner");
221         _;
222     }
223 
224     function renounceOwnership() public onlyOwner {
225         emit OwnershipRenounced(_owner);
226         _owner = address(0);
227     }
228 
229     function transferOwnership(address newOwner) public onlyOwner {
230         _transferOwnership(newOwner);
231     }
232 
233     function _transferOwnership(address newOwner) internal {
234         require(newOwner != address(0));
235         emit OwnershipTransferred(_owner, newOwner);
236         _owner = newOwner;
237     }
238 }
239 
240 library Address {
241     /**
242      * @dev The ETH balance of the account is not enough to perform the operation.
243      */
244     error AddressInsufficientBalance(address account);
245 
246     /**
247      * @dev There's no code at `target` (it is not a contract).
248      */
249     error AddressEmptyCode(address target);
250 
251     /**
252      * @dev A call to an address target failed. The target may have reverted.
253      */
254     error FailedInnerCall();
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         if (address(this).balance < amount) {
274             revert AddressInsufficientBalance(address(this));
275         }
276 
277         (bool success, ) = recipient.call{value: amount}("");
278         if (!success) {
279             revert FailedInnerCall();
280         }
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain `call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason or custom error, it is bubbled
289      * up by this function (like regular Solidity function calls). However, if
290      * the call reverted with no returned reason, this function reverts with a
291      * {FailedInnerCall} error.
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      */
301     function functionCall(
302         address target,
303         bytes memory data
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, 0);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but also transferring `value` wei to `target`.
311      *
312      * Requirements:
313      *
314      * - the calling contract must have an ETH balance of at least `value`.
315      * - the called Solidity function must be `payable`.
316      */
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value
321     ) internal returns (bytes memory) {
322         if (address(this).balance < value) {
323             revert AddressInsufficientBalance(address(this));
324         }
325         (bool success, bytes memory returndata) = target.call{value: value}(
326             data
327         );
328         return verifyCallResultFromTarget(target, success, returndata);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a static call.
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data
338     ) internal view returns (bytes memory) {
339         (bool success, bytes memory returndata) = target.staticcall(data);
340         return verifyCallResultFromTarget(target, success, returndata);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a delegate call.
346      */
347     function functionDelegateCall(
348         address target,
349         bytes memory data
350     ) internal returns (bytes memory) {
351         (bool success, bytes memory returndata) = target.delegatecall(data);
352         return verifyCallResultFromTarget(target, success, returndata);
353     }
354 
355     /**
356      * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
357      * was not a contract or bubbling up the revert reason (falling back to {FailedInnerCall}) in case of an
358      * unsuccessful call.
359      */
360     function verifyCallResultFromTarget(
361         address target,
362         bool success,
363         bytes memory returndata
364     ) internal view returns (bytes memory) {
365         if (!success) {
366             _revert(returndata);
367         } else {
368             // only check if target is a contract if the call was successful and the return data is empty
369             // otherwise we already know that it was a contract
370             if (returndata.length == 0 && target.code.length == 0) {
371                 revert AddressEmptyCode(target);
372             }
373             return returndata;
374         }
375     }
376 
377     /**
378      * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
379      * revert reason or with a default {FailedInnerCall} error.
380      */
381     function verifyCallResult(
382         bool success,
383         bytes memory returndata
384     ) internal pure returns (bytes memory) {
385         if (!success) {
386             _revert(returndata);
387         } else {
388             return returndata;
389         }
390     }
391 
392     /**
393      * @dev Reverts with returndata if present. Otherwise reverts with {FailedInnerCall}.
394      */
395     function _revert(bytes memory returndata) private pure {
396         // Look for revert reason and bubble it up if present
397         if (returndata.length > 0) {
398             // The easiest way to bubble the revert reason is using memory via assembly
399             /// @solidity memory-safe-assembly
400             assembly {
401                 let returndata_size := mload(returndata)
402                 revert(add(32, returndata), returndata_size)
403             }
404         } else {
405             revert FailedInnerCall();
406         }
407     }
408 }
409 
410 contract RSPToken is ERC20Detailed, Ownable {
411     uint256 public rebaseFrequency = 2 hours;
412     uint256 public nextRebase;
413     uint256 public finalRebase;
414     bool public autoRebase = true;
415     bool public rebaseStarted = false;
416     uint256 public rebasesThisCycle;
417     uint256 public lastRebaseThisCycle;
418 
419     uint256 public maxTxnAmount;
420     uint256 public maxWallet;
421 
422     address public taxWallet;
423     uint256 public finalTax = 5;
424 
425     uint256 private _initialTax = 25;
426     uint256 private _reduceTaxAt = 25;
427 
428     uint256 private _buyCount = 0;
429     uint256 private _sellCount = 0;
430 
431     mapping(address => bool) public isExcludedFromFees;
432 
433     uint8 private constant DECIMALS = 9;
434     uint256 public constant DIVIDEND_SUPPLY = 100_000_000 * 10 ** 18;
435     uint256 private constant INITIAL_TOKENS_SUPPLY =
436         10_797_518_620_650 * 10 ** DECIMALS;
437     
438     uint256 private constant FINAL_TOTAL_SUPPLY = 100_000_000 * 10 ** DECIMALS;
439     uint256 private constant TOTAL_PARTS =
440         type(uint256).max - (type(uint256).max % INITIAL_TOKENS_SUPPLY);
441 
442     event Rebase(uint256 indexed time, uint256 totalSupply);
443     event RemovedLimits();
444 
445     IDEXRouter public immutable router;
446     IDividendTracker public dividendTracker;
447     address public immutable pair;
448 
449     bool public limitsInEffect = true;
450     bool public tradingIsLive = false;
451     bool public claimStatus = false;
452 
453     uint256 private _totalSupply;
454     uint256 private _partsPerToken;
455     uint256 internal constant magnitude = 2 ** 128;
456 
457     uint256 private partsSwapThreshold = ((TOTAL_PARTS / 100000) * 25);
458 
459     mapping(address => uint256) private _partBalances;
460     mapping(address => mapping(address => uint256)) private _allowedTokens;
461 
462     modifier validRecipient(address to) {
463         require(to != address(0x0));
464         _;
465     }
466 
467     bool inSwap;
468 
469     modifier swapping() {
470         inSwap = true;
471         _;
472         inSwap = false;
473     }
474 
475     constructor(
476         address _dividendTracker
477     ) ERC20Detailed("RSP Finance", "RSP", DECIMALS) {
478         taxWallet = msg.sender;
479 
480         finalRebase = type(uint256).max;
481         nextRebase = type(uint256).max;
482 
483         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
484 
485         dividendTracker = IDividendTracker(_dividendTracker);
486 
487         _totalSupply = INITIAL_TOKENS_SUPPLY;
488         _partBalances[msg.sender] = TOTAL_PARTS;
489         _partsPerToken = TOTAL_PARTS / (_totalSupply);
490 
491         isExcludedFromFees[address(this)] = true;
492         isExcludedFromFees[address(router)] = true;
493         isExcludedFromFees[msg.sender] = true;
494 
495         maxTxnAmount = (_totalSupply * 2) / 100;
496         maxWallet = (_totalSupply * 2) / 100;
497 
498         pair = IDEXFactory(router.factory()).createPair(
499             address(this),
500             router.WETH()
501         );
502 
503         dividendTracker.setup();
504         dividendTracker.excludeFromDividends(address(dividendTracker), true);
505         dividendTracker.excludeFromDividends(address(this), true);
506         dividendTracker.excludeFromDividends(owner(), true);
507         dividendTracker.excludeFromDividends(address(0xdead), true);
508         dividendTracker.excludeFromDividends(address(router), true);
509         dividendTracker.excludeFromDividends(pair, true);
510 
511         _allowedTokens[address(this)][address(router)] = type(uint256).max;
512         _allowedTokens[address(this)][address(this)] = type(uint256).max;
513         _allowedTokens[address(msg.sender)][address(router)] = type(uint256)
514             .max;
515 
516         emit Transfer(
517             address(0x0),
518             address(msg.sender),
519             balanceOf(address(this))
520         );
521     }
522 
523     function totalSupply() external view override returns (uint256) {
524         return _totalSupply;
525     }
526 
527     function allowance(
528         address owner_,
529         address spender
530     ) external view override returns (uint256) {
531         return _allowedTokens[owner_][spender];
532     }
533 
534     function balanceOf(address who) public view override returns (uint256) {
535         return _partBalances[who] / (_partsPerToken);
536     }
537 
538     function shouldRebase() public view returns (bool) {
539         return
540             nextRebase <= block.timestamp ||
541             (autoRebase &&
542                 rebaseStarted &&
543                 rebasesThisCycle < 5 &&
544                 lastRebaseThisCycle + 60 <= block.timestamp);
545     }
546 
547     function lpSync() internal {
548         InterfaceLP _pair = InterfaceLP(pair);
549         _pair.sync();
550     }
551 
552     function transfer(
553         address to,
554         uint256 value
555     ) external override validRecipient(to) returns (bool) {
556         _transferFrom(msg.sender, to, value);
557         return true;
558     }
559 
560     function removeLimits() external onlyOwner {
561         require(limitsInEffect, "Limits already removed");
562         limitsInEffect = false;
563         emit RemovedLimits();
564     }
565 
566     function excludedFromFees(
567         address _address,
568         bool _value
569     ) external onlyOwner {
570         isExcludedFromFees[_address] = _value;
571     }
572 
573     function _transferFrom(
574         address sender,
575         address recipient,
576         uint256 amount
577     ) internal returns (bool) {
578         address pairAddress = pair;
579 
580         if (
581             !inSwap &&
582             !isExcludedFromFees[sender] &&
583             !isExcludedFromFees[recipient]
584         ) {
585             require(tradingIsLive, "Trading not live");
586             if (limitsInEffect) {
587                 if (sender == pairAddress || recipient == pairAddress) {
588                     require(amount <= maxTxnAmount, "Max Tx Exceeded");
589                 }
590                 if (recipient != pairAddress) {
591                     require(
592                         balanceOf(recipient) + amount <= maxWallet,
593                         "Max Wallet Exceeded"
594                     );
595                 }
596             }
597 
598             if (recipient == pairAddress) {
599                 if (
600                     balanceOf(address(this)) >=
601                     partsSwapThreshold / (_partsPerToken)
602                 ) {
603                     try this.swapBack() {} catch {}
604                 }
605                 if (shouldRebase()) {
606                     rebase();
607                 }
608             }
609 
610             uint256 taxAmount;
611 
612             if (sender == pairAddress) {
613                 _buyCount += 1;
614                 taxAmount =
615                     (amount *
616                         (_buyCount > _reduceTaxAt ? finalTax : _initialTax)) /
617                     100;
618             } else if (recipient == pairAddress) {
619                 _sellCount += 1;
620                 taxAmount =
621                     (amount *
622                         (_sellCount > _reduceTaxAt ? finalTax : _initialTax)) /
623                     100;
624             }
625 
626             if (taxAmount > 0) {
627                 _partBalances[sender] -= (taxAmount * _partsPerToken);
628                 _partBalances[address(this)] += (taxAmount * _partsPerToken);
629 
630                 emit Transfer(sender, address(this), taxAmount);
631                 amount -= taxAmount;
632             }
633         }
634 
635         _partBalances[sender] -= (amount * _partsPerToken);
636         _partBalances[recipient] += (amount * _partsPerToken);
637 
638         uint256 senderPercentage = (balanceOf(sender) * magnitude) /
639             _totalSupply;
640 
641         uint256 recipientPercentage = (balanceOf(recipient) * magnitude) /
642             _totalSupply;
643         
644         try
645             dividendTracker.setBalance(
646                 sender,
647                 (DIVIDEND_SUPPLY * senderPercentage) / magnitude
648             )
649         {} catch {}
650         try
651             dividendTracker.setBalance(
652                 recipient,
653                 (DIVIDEND_SUPPLY * recipientPercentage) / magnitude
654             )
655         {} catch {}
656 
657         emit Transfer(sender, recipient, amount);
658 
659         return true;
660     }
661 
662     function transferFrom(
663         address from,
664         address to,
665         uint256 value
666     ) external override validRecipient(to) returns (bool) {
667         if (_allowedTokens[from][msg.sender] != type(uint256).max) {
668             require(
669                 _allowedTokens[from][msg.sender] >= value,
670                 "Insufficient Allowance"
671             );
672             _allowedTokens[from][msg.sender] =
673                 _allowedTokens[from][msg.sender] -
674                 (value);
675         }
676         _transferFrom(from, to, value);
677         return true;
678     }
679 
680     function decreaseAllowance(
681         address spender,
682         uint256 subtractedValue
683     ) external returns (bool) {
684         uint256 oldValue = _allowedTokens[msg.sender][spender];
685         if (subtractedValue >= oldValue) {
686             _allowedTokens[msg.sender][spender] = 0;
687         } else {
688             _allowedTokens[msg.sender][spender] = oldValue - (subtractedValue);
689         }
690         emit Approval(msg.sender, spender, _allowedTokens[msg.sender][spender]);
691         return true;
692     }
693 
694     function increaseAllowance(
695         address spender,
696         uint256 addedValue
697     ) external returns (bool) {
698         _allowedTokens[msg.sender][spender] =
699             _allowedTokens[msg.sender][spender] +
700             (addedValue);
701         emit Approval(msg.sender, spender, _allowedTokens[msg.sender][spender]);
702         return true;
703     }
704 
705     function approve(
706         address spender,
707         uint256 value
708     ) public override returns (bool) {
709         _allowedTokens[msg.sender][spender] = value;
710         emit Approval(msg.sender, spender, value);
711         return true;
712     }
713 
714     function rebase() internal returns (uint256) {
715         uint256 time = block.timestamp;
716 
717         uint256 supplyDelta = (_totalSupply * 2) / 100;
718         if (nextRebase < block.timestamp) {
719             rebasesThisCycle = 1;
720             nextRebase += rebaseFrequency;
721         } else {
722             rebasesThisCycle += 1;
723             lastRebaseThisCycle = block.timestamp;
724         }
725 
726         if (supplyDelta == 0) {
727             emit Rebase(time, _totalSupply);
728             return _totalSupply;
729         }
730 
731         _totalSupply = _totalSupply - supplyDelta;
732 
733         if (nextRebase >= finalRebase) {
734             nextRebase = type(uint256).max;
735             autoRebase = false;
736             _totalSupply = FINAL_TOTAL_SUPPLY;
737 
738             if (limitsInEffect) {
739                 limitsInEffect = false;
740                 emit RemovedLimits();
741             }
742 
743             if (balanceOf(address(this)) > 0) {
744                 try this.swapBack() {} catch {}
745             }
746         }
747 
748         _partsPerToken = TOTAL_PARTS / (_totalSupply);
749 
750         lpSync();
751 
752         emit Rebase(time, _totalSupply);
753         return _totalSupply;
754     }
755 
756     function claimReward() external {
757         require(claimStatus, "Claim not enabled");
758         dividendTracker.processAccount(payable(msg.sender));
759     }
760 
761     function enableClaim(bool _status) external onlyOwner {
762         claimStatus = _status;
763     }
764 
765     function manualRebase() external {
766         require(shouldRebase(), "Not in time");
767         rebase();
768     }
769 
770     function startTrading() external onlyOwner {
771         require(!tradingIsLive, "Trading Live Already");
772         tradingIsLive = true;
773     }
774 
775     function startRebaseCycles() external onlyOwner {
776         require(!rebaseStarted, "already started");
777         nextRebase = block.timestamp + rebaseFrequency;
778         finalRebase = block.timestamp + 10 days;
779         rebaseStarted = true;
780     }
781 
782     function swapBack() public swapping {
783         uint256 contractBalance = balanceOf(address(this));
784         if (contractBalance == 0) {
785             return;
786         }
787 
788         if (contractBalance > (partsSwapThreshold / (_partsPerToken)) * 20) {
789             contractBalance = (partsSwapThreshold / (_partsPerToken)) * 20;
790         }
791 
792         uint256 currentbalance = address(this).balance;
793 
794         swapTokensForETH(contractBalance);
795 
796         uint256 balance = address(this).balance;
797 
798         uint256 ethToReward = (balance - currentbalance) / 2;
799         uint256 ethForDev = balance - ethToReward;
800 
801         if (ethForDev > 0) {
802             (bool success, ) = payable(taxWallet).call{value: ethForDev}("");
803             require(success, "Failed to send ETH to dev wallet");
804         }
805         if (ethToReward > 0) {
806             (bool success, ) = payable(address(dividendTracker)).call{
807                 value: ethToReward
808             }("");
809             require(success, "Failed to send ETH to wrapper");
810         }
811     }
812 
813     function swapTokensForETH(uint256 tokenAmount) internal {
814         address[] memory path = new address[](2);
815         path[0] = address(this);
816         path[1] = router.WETH();
817 
818         // make the swap
819         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
820             tokenAmount,
821             0, // accept any amount
822             path,
823             address(address(this)),
824             block.timestamp
825         );
826     }
827 
828     function refreshBalances(address[] memory wallets) external {
829         address wallet;
830         for (uint256 i = 0; i < wallets.length; i++) {
831             wallet = wallets[i];
832             emit Transfer(wallet, wallet, 0);
833         }
834     }
835 
836     receive() external payable {}
837 }