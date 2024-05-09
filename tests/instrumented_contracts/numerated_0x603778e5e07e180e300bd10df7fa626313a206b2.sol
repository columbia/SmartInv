1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the token decimals.
24      */
25     function decimals() external view returns (uint8);
26 
27     /**
28      * @dev Returns the token symbol.
29      */
30     function symbol() external view returns (string memory);
31 
32     /**
33      * @dev Returns the token name.
34      */
35     function name() external view returns (string memory);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount)
50         external
51         returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address _owner, address spender)
61         external
62         view
63         returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(
109         address indexed owner,
110         address indexed spender,
111         uint256 value
112     );
113 }
114 
115 library Address {
116     /**
117      * @dev Returns true if `account` is a contract.
118      *
119      * [IMPORTANT]
120      * ====
121      * It is unsafe to assume that an address for which this function returns
122      * false is an externally-owned account (EOA) and not a contract.
123      *
124      * Among others, `isContract` will return false for the following
125      * types of addresses:
126      *
127      *  - an externally-owned account
128      *  - a contract in construction
129      *  - an address where a contract will be created
130      *  - an address where a contract lived, but was destroyed
131      * ====
132      *
133      * [IMPORTANT]
134      * ====
135      * You shouldn't rely on `isContract` to protect against flash loan attacks!
136      *
137      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
138      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
139      * constructor.
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize/address.code.length, which returns 0
144         // for contracts in construction, since the code is only stored at the end
145         // of the constructor execution.
146 
147         return account.code.length > 0;
148     }
149 
150     /**
151      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
152      * `recipient`, forwarding all available gas and reverting on errors.
153      *
154      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
155      * of certain opcodes, possibly making contracts go over the 2300 gas limit
156      * imposed by `transfer`, making them unable to receive funds via
157      * `transfer`. {sendValue} removes this limitation.
158      *
159      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
160      *
161      * IMPORTANT: because control is transferred to `recipient`, care must be
162      * taken to not create reentrancy vulnerabilities. Consider using
163      * {ReentrancyGuard} or the
164      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
165      */
166     function sendValue(address payable recipient, uint256 amount) internal {
167         require(
168             address(this).balance >= amount,
169             "Address: insufficient balance"
170         );
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(
174             success,
175             "Address: unable to send value, recipient may have reverted"
176         );
177     }
178 
179     /**
180      * @dev Performs a Solidity function call using a low level `call`. A
181      * plain `call` is an unsafe replacement for a function call: use this
182      * function instead.
183      *
184      * If `target` reverts with a revert reason, it is bubbled up by this
185      * function (like regular Solidity function calls).
186      *
187      * Returns the raw returned data. To convert to the expected return value,
188      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
189      *
190      * Requirements:
191      *
192      * - `target` must be a contract.
193      * - calling `target` with `data` must not revert.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(address target, bytes memory data)
198         internal
199         returns (bytes memory)
200     {
201         return functionCall(target, data, "Address: low-level call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
206      * `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, 0, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but also transferring `value` wei to `target`.
221      *
222      * Requirements:
223      *
224      * - the calling contract must have an ETH balance of at least `value`.
225      * - the called Solidity function must be `payable`.
226      *
227      * _Available since v3.1._
228      */
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value
233     ) internal returns (bytes memory) {
234         return
235             functionCallWithValue(
236                 target,
237                 data,
238                 value,
239                 "Address: low-level call with value failed"
240             );
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
245      * with `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(
256             address(this).balance >= value,
257             "Address: insufficient balance for call"
258         );
259         require(isContract(target), "Address: call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.call{value: value}(
262             data
263         );
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(address target, bytes memory data)
274         internal
275         view
276         returns (bytes memory)
277     {
278         return
279             functionStaticCall(
280                 target,
281                 data,
282                 "Address: low-level static call failed"
283             );
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data)
310         internal
311         returns (bytes memory)
312     {
313         return
314             functionDelegateCall(
315                 target,
316                 data,
317                 "Address: low-level delegate call failed"
318             );
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
323      * but performing a delegate call.
324      *
325      * _Available since v3.4._
326      */
327     function functionDelegateCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(isContract(target), "Address: delegate call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.delegatecall(data);
335         return verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
340      * revert reason using the provided one.
341      *
342      * _Available since v4.3._
343      */
344     function verifyCallResult(
345         bool success,
346         bytes memory returndata,
347         string memory errorMessage
348     ) internal pure returns (bytes memory) {
349         if (success) {
350             return returndata;
351         } else {
352             // Look for revert reason and bubble it up if present
353             if (returndata.length > 0) {
354                 // The easiest way to bubble the revert reason is using memory via assembly
355 
356                 assembly {
357                     let returndata_size := mload(returndata)
358                     revert(add(32, returndata), returndata_size)
359                 }
360             } else {
361                 revert(errorMessage);
362             }
363         }
364     }
365 }
366 
367 interface IUniswapV2Factory {
368     event PairCreated(
369         address indexed token0,
370         address indexed token1,
371         address lpPair,
372         uint256
373     );
374 
375     function getPair(address tokenA, address tokenB)
376         external
377         view
378         returns (address lpPair);
379 
380     function createPair(address tokenA, address tokenB)
381         external
382         returns (address lpPair);
383 }
384 
385 interface IUniswapV2Pair {
386     function factory() external view returns (address);
387 
388     function getReserves()
389         external
390         view
391         returns (
392             uint112 reserve0,
393             uint112 reserve1,
394             uint32 blockTimestampLast
395         );
396 
397     function token0() external view returns (address);
398 
399     function token1() external view returns (address);
400 }
401 
402 interface IUniswapV2Router01 {
403     function factory() external pure returns (address);
404 
405     function WETH() external pure returns (address);
406 
407     function addLiquidityETH(
408         address token,
409         uint256 amountTokenDesired,
410         uint256 amountTokenMin,
411         uint256 amountETHMin,
412         address to,
413         uint256 deadline
414     )
415         external
416         payable
417         returns (
418             uint256 amountToken,
419             uint256 amountETH,
420             uint256 liquidity
421         );
422 
423     function addLiquidity(
424         address tokenA,
425         address tokenB,
426         uint256 amountADesired,
427         uint256 amountBDesired,
428         uint256 amountAMin,
429         uint256 amountBMin,
430         address to,
431         uint256 deadline
432     )
433         external
434         returns (
435             uint256 amountA,
436             uint256 amountB,
437             uint256 liquidity
438         );
439 
440     function removeLiquidityETH(
441         address token,
442         uint liquidity,
443         uint amountTokenMin,
444         uint amountETHMin,
445         address to,
446         uint deadline
447     ) external returns (uint amountToken, uint amountETH);
448 
449     function removeLiquidityETHSupportingFeeOnTransferTokens(
450         address token,
451         uint liquidity,
452         uint amountTokenMin,
453         uint amountETHMin,
454         address to,
455         uint deadline
456     ) external returns (uint amountETH);
457 
458     function getAmountsOut(uint256 amountIn, address[] calldata path)
459         external
460         view
461         returns (uint256[] memory amounts);
462 
463     function getAmountsIn(uint256 amountOut, address[] calldata path)
464         external
465         view
466         returns (uint256[] memory amounts);
467 }
468 
469 interface IUniswapV2Router02 is IUniswapV2Router01 {
470     function swapExactTokensForETHSupportingFeeOnTransferTokens(
471         uint256 amountIn,
472         uint256 amountOutMin,
473         address[] calldata path,
474         address to,
475         uint256 deadline
476     ) external;
477 
478     function swapExactETHForTokensSupportingFeeOnTransferTokens(
479         uint256 amountOutMin,
480         address[] calldata path,
481         address to,
482         uint256 deadline
483     ) external payable;
484 
485     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
486         uint256 amountIn,
487         uint256 amountOutMin,
488         address[] calldata path,
489         address to,
490         uint256 deadline
491     ) external;
492 
493     function swapExactTokensForTokens(
494         uint256 amountIn,
495         uint256 amountOutMin,
496         address[] calldata path,
497         address to,
498         uint256 deadline
499     ) external returns (uint256[] memory amounts);
500 }
501 
502 ////////CONTRACT//IMPLEMENTATION/////////
503 
504 contract WIZ is Context, IERC20 {
505     mapping(address => uint256) private _rOwned;
506     mapping(address => uint256) private _tOwned;
507     mapping(address => mapping(address => uint256)) private _allowances;
508 
509     string private constant _name = "WIZ";
510     string private constant _symbol = "WIZ";
511     uint8 private constant _decimals = 4;
512 
513     uint256 private constant _totalSupply = 100_000_000_000 * (10**_decimals);
514     uint256 private constant _tTotal = _totalSupply;
515     uint256 private constant MAX = ~uint256(0);
516     uint256 private _rTotal = (MAX - (MAX % _tTotal));
517 
518     uint private _feesAndLimitsStartTimestamp;
519     bool private _inLiquidityOperation;
520 
521     uint16 public constant buyFeeReflect = 0;
522     uint16 public constant buyFeeBurn = 0;
523     uint16 public constant buyFeeMarketing = 100;
524     uint16 public constant buyFeeTotalSwap = 300;
525 
526     uint16 public constant sellFeeReflect = 250;
527     uint16 public constant sellFeeBurn = 50;
528     uint16 public constant sellFeeMarketing = 0;
529     uint16 public constant sellFeeTotalSwap = 500;
530 
531     uint16 public constant ratioLiquidity = 200;
532     uint16 public constant ratioTreasury = 600;
533     uint16 public constant ratioTotal = 800;
534 
535     uint256 public constant feeDivisor = 10000;
536 
537     address public constant dexRouterAddress =
538         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
539     IUniswapV2Router02 public dexRouter;
540     address public lpPair;
541 
542     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
543 
544     address public constant marketingWallet =
545         0x38649185909fD39fF2eCDB27Ac472a5ecb003a0c;
546 
547     address public constant treasuryWallet =
548         0x1e18ed1bfCa02e59a43de32c60Ac0FD4923b64b5;
549 
550     bool private _inSwap;
551     uint256 public constant contractSwapTimer = 10 seconds;
552     uint256 private _lastSwapTimestamp;
553 
554     uint256 public constant swapThreshold = (_tTotal * 5) / 10000;
555     uint256 public constant swapAmount = (_tTotal * 10) / 10000;
556 
557     uint256 private constant _maxTxAmount = (_tTotal * 300) / 10000;
558 
559     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
560 
561     modifier lockTheSwap() {
562         _inSwap = true;
563         _;
564         _inSwap = false;
565     }
566 
567     modifier withoutTransferFees() {
568         _inLiquidityOperation = true;
569         _;
570         _inLiquidityOperation = false;
571     }
572 
573     constructor() payable {
574         _rOwned[msg.sender] = _rTotal;
575 
576         // start applying fee and limits from this time
577         _feesAndLimitsStartTimestamp = block.timestamp + 15 minutes;
578 
579         if (
580             block.chainid == 1 || block.chainid == 5 || block.chainid == 31337
581         ) {
582             dexRouter = IUniswapV2Router02(dexRouterAddress);
583         } else {
584             revert("Deployment chain is not supported by this contract");
585         }
586 
587         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(
588             dexRouter.WETH(),
589             address(this)
590         );
591 
592         // FIXME: think about potential overflow after years
593         _approve(msg.sender, dexRouterAddress, type(uint256).max);
594         _approve(address(this), dexRouterAddress, type(uint256).max);
595         IERC20(lpPair).approve(dexRouterAddress, type(uint256).max);
596 
597         emit Transfer(address(0), _msgSender(), _tTotal);
598     }
599 
600     receive() external payable {}
601 
602     function allowFeesAndLimits() external {
603         _feesAndLimitsStartTimestamp = block.timestamp;
604     }
605 
606     function totalSupply() external pure override returns (uint256) {
607         if (_tTotal == 0) {
608             revert();
609         }
610         return _tTotal;
611     }
612 
613     function decimals() external pure override returns (uint8) {
614         return _decimals;
615     }
616 
617     function symbol() external pure override returns (string memory) {
618         return _symbol;
619     }
620 
621     function name() external pure override returns (string memory) {
622         return _name;
623     }
624 
625     function allowance(address holder, address spender)
626         external
627         view
628         override
629         returns (uint256)
630     {
631         return _allowances[holder][spender];
632     }
633 
634     function balanceOf(address account) public view override returns (uint256) {
635         address lpPair_ = lpPair;
636         if (_isExcludedFromReflections(account, lpPair_))
637             return _tOwned[account];
638         return _tokenFromReflection(_rOwned[account], lpPair_);
639     }
640 
641     function transfer(address recipient, uint256 amount)
642         external
643         override
644         returns (bool)
645     {
646         _transfer(_msgSender(), recipient, amount);
647         return true;
648     }
649 
650     function approve(address spender, uint256 amount)
651         external
652         override
653         returns (bool)
654     {
655         _approve(_msgSender(), spender, amount);
656         return true;
657     }
658 
659     function _approve(
660         address sender,
661         address spender,
662         uint256 amount
663     ) private {
664         require(sender != address(0), "ERC20: Sender is not zero Address");
665         require(spender != address(0), "ERC20: Spender is not zero Address");
666 
667         _allowances[sender][spender] = amount;
668         emit Approval(sender, spender, amount);
669     }
670 
671     function transferFrom(
672         address sender,
673         address recipient,
674         uint256 amount
675     ) external override returns (bool) {
676         if (_allowances[sender][msg.sender] != type(uint256).max) {
677             _allowances[sender][msg.sender] -= amount;
678         }
679 
680         _transfer(sender, recipient, amount);
681         return true;
682     }
683 
684     function getCirculatingSupply() public view returns (uint256) {
685         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
686     }
687 
688     function _isExcludedFromReflections(address account, address lpPair_)
689         private
690         view
691         returns (bool)
692     {
693         return
694             account == address(this) ||
695             account == DEAD ||
696             account == marketingWallet ||
697             account == lpPair_;
698     }
699 
700     function isExcludedFromReflections(address account)
701         public
702         view
703         returns (bool)
704     {
705         return _isExcludedFromReflections(account, lpPair);
706     }
707 
708     // function getExcludedFromReflections(uint256 index) public view returns (address);
709     // }
710 
711     function addLiquidityETH(
712         uint amountTokenDesired,
713         uint amountTokenMin,
714         uint amountETHMin,
715         address to,
716         uint deadline
717     )
718         public
719         payable
720         withoutTransferFees
721         returns (
722             uint amountToken,
723             uint amountETH,
724             uint liquidity
725         )
726     {
727         // we need to transfer WIZ to our contract for router to have access to it
728         _transfer(msg.sender, address(this), amountTokenDesired);
729 
730         if (deadline == 0) deadline = block.timestamp;
731         if (to == address(0)) to = msg.sender;
732 
733         (amountToken, amountETH, liquidity) = dexRouter.addLiquidityETH{
734             value: msg.value
735         }(
736             address(this),
737             amountTokenDesired,
738             amountTokenMin,
739             amountETHMin,
740             to,
741             deadline
742         );
743 
744         // refund dust eth, if any
745         if (amountToken < amountTokenDesired) {
746             _transfer(
747                 address(this),
748                 msg.sender,
749                 amountTokenDesired - amountToken
750             );
751         }
752         // refund dust WIZ, if any
753         if (amountETH < msg.value) {
754             payable(msg.sender).transfer(msg.value - amountETH);
755         }
756     }
757 
758     function removeLiquidityETH(
759         uint liquidity,
760         uint amountTokenMin,
761         uint amountETHMin,
762         address to,
763         uint deadline
764     ) public withoutTransferFees returns (uint amountToken, uint amountETH) {
765         // we need to transfer LP Pair tokens to our contract for router to have access to it
766         IERC20(lpPair).transferFrom(msg.sender, address(this), liquidity);
767 
768         if (liquidity == 0) liquidity = IERC20(lpPair).balanceOf(msg.sender);
769         if (deadline == 0) deadline = block.timestamp;
770         if (to == address(0)) to = msg.sender;
771 
772         uint balanceBefore = balanceOf(to);
773         amountETH = dexRouter.removeLiquidityETHSupportingFeeOnTransferTokens(
774             address(this),
775             liquidity,
776             amountTokenMin,
777             amountETHMin,
778             to,
779             deadline
780         );
781         amountToken = balanceOf(to) - balanceBefore;
782     }
783 
784     function _tokenFromReflection(uint256 rAmount, address lpPair_)
785         private
786         view
787         returns (uint256)
788     {
789         require(
790             rAmount <= _rTotal,
791             "Amount must be less than total reflections"
792         );
793         uint256 currentRate = _getRate(lpPair_);
794         return rAmount / currentRate;
795     }
796 
797     function isExcludedFromFees(address account) public view returns (bool) {
798         return _isExcludedFromFees(account);
799     }
800 
801     function _isExcludedFromFees(address account) private view returns (bool) {
802         return account == address(this) || account == DEAD;
803     }
804 
805     function getMaxTX() public pure returns (uint256) {
806         return _maxTxAmount / (10**_decimals);
807     }
808 
809     function _transfer(
810         address from,
811         address to,
812         uint256 amount
813     ) internal {
814         require(from != address(0), "ERC20: transfer from the zero address");
815         require(to != address(0), "ERC20: transfer to the zero address");
816         require(amount > 0, "Transfer amount must be greater than zero");
817 
818         bool feesAndLimitsAllowed = block.timestamp >=
819             _feesAndLimitsStartTimestamp;
820 
821         if (feesAndLimitsAllowed) {
822             require(
823                 amount <= _maxTxAmount,
824                 "Transfer amount exceeds the maxTxAmount."
825             );
826         }
827         address lpPair_ = lpPair;
828         bool takeFee = feesAndLimitsAllowed &&
829             !(_isExcludedFromFees(from) || _isExcludedFromFees(to)) &&
830             !_inLiquidityOperation;
831 
832         if (to == lpPair_) {
833             if (!_inSwap && !_inLiquidityOperation) {
834                 if (_lastSwapTimestamp + contractSwapTimer < block.timestamp) {
835                     uint256 contractTokenBalance = balanceOf(address(this));
836                     if (contractTokenBalance >= swapThreshold) {
837                         if (contractTokenBalance >= swapAmount) {
838                             contractTokenBalance = swapAmount;
839                         }
840                         _contractSwap(contractTokenBalance);
841                         _lastSwapTimestamp = block.timestamp;
842                     }
843                 }
844             }
845         }
846         _finalizeTransfer(from, to, amount, takeFee);
847     }
848 
849     function _contractSwap(uint256 contractTokenBalance) private lockTheSwap {
850         if (
851             contractTokenBalance > _allowances[address(this)][dexRouterAddress]
852         ) {
853             _allowances[address(this)][dexRouterAddress] = type(uint256).max;
854         }
855 
856         uint256 toLiquify = ((contractTokenBalance * ratioLiquidity) /
857             ratioTotal) / 2;
858         uint256 swapAmt = contractTokenBalance - toLiquify;
859 
860         address[] memory path = new address[](2);
861         path[0] = address(this);
862         path[1] = dexRouter.WETH();
863 
864         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
865             swapAmt,
866             0,
867             path,
868             address(this),
869             block.timestamp
870         );
871 
872         uint256 amtBalance = address(this).balance;
873         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
874 
875         if (toLiquify > 0) {
876             dexRouter.addLiquidityETH{value: liquidityBalance}(
877                 address(this),
878                 toLiquify,
879                 0,
880                 0,
881                 DEAD,
882                 block.timestamp
883             );
884             emit AutoLiquify(liquidityBalance, toLiquify);
885         }
886 
887         amtBalance -= liquidityBalance;
888         uint256 treasuryBalance = amtBalance;
889         if (ratioTreasury > 0) {
890             payable(treasuryWallet).transfer(treasuryBalance);
891         }
892     }
893 
894     struct ExtraValues {
895         uint256 tTransferAmount;
896         uint256 tFee;
897         uint256 tSwap;
898         uint256 tBurn;
899         uint256 tMarketing;
900         uint256 rTransferAmount;
901         uint256 rAmount;
902         uint256 rFee;
903         uint256 currentRate;
904     }
905 
906     function _finalizeTransfer(
907         address from,
908         address to,
909         uint256 tAmount,
910         bool takeFee
911     ) private {
912         address lpPair_ = lpPair;
913         ExtraValues memory values = _getValues(
914             from,
915             to,
916             tAmount,
917             takeFee,
918             lpPair_
919         );
920 
921         _rOwned[from] -= values.rAmount;
922         _rOwned[to] += values.rTransferAmount;
923 
924         if (_isExcludedFromReflections(from, lpPair_)) {
925             _tOwned[from] -= tAmount;
926         }
927         if (_isExcludedFromReflections(to, lpPair_)) {
928             _tOwned[to] += values.tTransferAmount;
929         }
930 
931         if (values.rFee > 0) {
932             _rTotal -= values.rFee;
933         }
934 
935         emit Transfer(from, to, values.tTransferAmount);
936     }
937 
938     function _getValues(
939         address from,
940         address to,
941         uint256 tAmount,
942         bool takeFee,
943         address lpPair_
944     ) private returns (ExtraValues memory) {
945         ExtraValues memory values;
946         values.currentRate = _getRate(lpPair_);
947 
948         values.rAmount = tAmount * values.currentRate; // _rTotal / _tTotal
949 
950         if (takeFee) {
951             uint256 currentReflect;
952             uint256 currentSwap;
953             uint256 currentBurn;
954             uint256 currentMarketing;
955             uint256 divisor = feeDivisor;
956 
957             if (Address.isContract(to)) {
958                 currentReflect = sellFeeReflect;
959                 currentBurn = sellFeeBurn;
960                 currentMarketing = sellFeeMarketing;
961                 currentSwap = sellFeeTotalSwap;
962             } else if (Address.isContract(from)) {
963                 currentReflect = buyFeeReflect;
964                 currentBurn = buyFeeBurn;
965                 currentMarketing = buyFeeMarketing;
966                 currentSwap = buyFeeTotalSwap;
967             }
968 
969             values.tFee = (tAmount * currentReflect) / divisor;
970             values.tSwap = (tAmount * currentSwap) / divisor;
971             values.tBurn = (tAmount * currentBurn) / divisor;
972             values.tMarketing = (tAmount * currentMarketing) / divisor;
973             values.tTransferAmount =
974                 tAmount -
975                 (values.tFee + values.tSwap + values.tBurn + values.tMarketing);
976 
977             values.rFee = values.tFee * values.currentRate;
978         } else {
979             values.tFee = 0;
980             values.tSwap = 0;
981             values.tBurn = 0;
982             values.tMarketing = 0;
983             values.tTransferAmount = tAmount;
984 
985             values.rFee = 0;
986         }
987 
988         if (values.tSwap > 0) {
989             _rOwned[address(this)] += values.tSwap * values.currentRate;
990             _tOwned[address(this)] += values.tSwap;
991             emit Transfer(from, address(this), values.tSwap);
992         }
993 
994         if (values.tBurn > 0) {
995             _rOwned[DEAD] += values.tBurn * values.currentRate;
996             _tOwned[DEAD] += values.tBurn;
997             emit Transfer(from, DEAD, values.tBurn);
998         }
999 
1000         if (values.tMarketing > 0) {
1001             _rOwned[marketingWallet] += values.tMarketing * values.currentRate;
1002             _tOwned[marketingWallet] += values.tMarketing;
1003             emit Transfer(from, marketingWallet, values.tMarketing);
1004         }
1005 
1006         values.rTransferAmount =
1007             values.rAmount -
1008             (values.rFee +
1009                 (values.tSwap * values.currentRate) +
1010                 (values.tBurn * values.currentRate) +
1011                 (values.tMarketing * values.currentRate));
1012         return values;
1013     }
1014 
1015     function _getRate(address lpPair_) private view returns (uint256) {
1016         uint256 rTotal = _rTotal;
1017         uint256 tTotal = _tTotal;
1018         uint256 rSupply;
1019         uint256 tSupply;
1020         uint256 rOwned;
1021         uint256 tOwned;
1022         unchecked {
1023             rSupply = rTotal;
1024             tSupply = tTotal;
1025 
1026             rOwned = _rOwned[address(this)];
1027             tOwned = _tOwned[address(this)];
1028             if (rOwned > rSupply || tOwned > tSupply) return rTotal / tTotal;
1029             rSupply -= rOwned;
1030             tSupply -= tOwned;
1031 
1032             rOwned = _rOwned[DEAD];
1033             tOwned = _tOwned[DEAD];
1034             if (rOwned > rSupply || tOwned > tSupply) return rTotal / tTotal;
1035             rSupply -= rOwned;
1036             tSupply -= tOwned;
1037 
1038             rOwned = _rOwned[marketingWallet];
1039             tOwned = _tOwned[marketingWallet];
1040             if (rOwned > rSupply || tOwned > tSupply) return rTotal / tTotal;
1041             rSupply -= rOwned;
1042             tSupply -= tOwned;
1043 
1044             rOwned = _rOwned[lpPair_];
1045             tOwned = _tOwned[lpPair_];
1046             if (rOwned > rSupply || tOwned > tSupply) return rTotal / tTotal;
1047             rSupply -= rOwned;
1048             tSupply -= tOwned;
1049         }
1050         return rSupply / tSupply;
1051     }
1052 }