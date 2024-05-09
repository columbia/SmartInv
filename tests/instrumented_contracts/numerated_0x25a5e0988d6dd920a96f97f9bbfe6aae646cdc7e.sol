1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.8.17;
5 
6 
7 /*
8    
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⠤⢤⣄⣠⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⣀⣴⠾⠟⠋⠁⠀⠀⠀⠀⠀⠀⠈⠉⠒⠶⢄⡀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⢠⡾⠋⠀⠀⡄⠀⠠⠀⢠⠄⠀⡤⠀⡤⡄⠀⠀⠀⠙⠳⣄⠀⠀⠀
12 ⠀⠀⠀⡴⠋⠀⠀⠀⡇⡇⠀⡇⡆⢸⠔⠀⡇⠀⡧⡃⠀⡆⠀⠀⠀⠘⢦⠀⠀
13 ⠀⠀⡼⠁⠀⠀⠀⠀⡇⡇⢠⠤⡇⢸⠀⠀⡇⠀⡇⡁⠀⡇⠀⠀⠀⠀⠈⢱⠀
14 ⠀⣼⠃⠀⠀⠀⠀⠀⠃⠃⢬⠀⠁⠘⠈⠀⠁⠀⢧⠁⠀⠑⠀⠀⠀⠀⠀⠀⣇
15 ⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡄⠀⠀⠀⢀⣴⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠
16 ⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⢀⣈⣻⣆⠀⢀⣾⣃⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀
17 ⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢉⡿⠆⠾⣏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼
18 ⠀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⣠⠀⠀⣤⠀⠲⠶⢤⣀⠀⠀⠀⢠⠇
19 ⠀⠘⣧⠀⠀⢠⡇⠀⠀⠐⢶⡤⠾⠷⠴⠿⠦⠴⠳⠤⠴⠖⠛⠉⠀⠀⢀⡞⠀
20 ⠀⠀⠘⢧⡀⠀⠙⠶⠶⠖⠋⠀⠘⠀⠀⠙⠂⠀⠓⠀⠀⠀⠀⠀⠀⢠⡞⠀⠀
21 ⠀⠀⠀⠈⠻⣦⡀⠙⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠈⠙⠶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡠⠖⠋⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠓⠶⠶⠤⠶⠶⠖⠒⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀
24 
25 
26     Arabs struck liquid gold beneath the sands, fueling a surge of wealth and power. But their oil-fueled dominance was
27     not without controversy, as the world watched and wondered what the future would hold.
28 
29     ضرب العرب الذهب السائل تحت الرمال ، مما أدى إلى زيادة الثروة والسلطة. لكن هيمنتهم التي يغذيها النفط كانت كذلك
30           لا يخلو من الجدل ، حيث كان العالم يشاهد ويتساءل عما يخبئه المستقبل.
31 
32 Final tax: 1/1 LP
33 
34 
35 Website: https://habibieth.com/
36 Telegram: https://t.me/habibieth
37 Twitter: https://twitter.com/Habibiethereum
38 */
39 
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 library Address {
53     function isContract(address account) internal view returns (bool) {
54         return account.code.length > 0;
55     }
56 
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(
59             address(this).balance >= amount,
60             "Address: insufficient balance"
61         );
62 
63         (bool success, ) = recipient.call{value: amount}("");
64         require(
65             success,
66             "Address: unable to send value, recipient may have reverted"
67         );
68     }
69 
70     function functionCall(address target, bytes memory data)
71         internal
72         returns (bytes memory)
73     {
74         return
75             functionCallWithValue(
76                 target,
77                 data,
78                 0,
79                 "Address: low-level call failed"
80             );
81     }
82 
83     function functionCall(
84         address target,
85         bytes memory data,
86         string memory errorMessage
87     ) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, 0, errorMessage);
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
93      * but also transferring `value` wei to `target`.
94      *
95      * Requirements:
96      *
97      * - the calling contract must have an ETH balance of at least `value`.
98      * - the called Solidity function must be `payable`.
99      *
100      * _Available since v3.1._
101      */
102     function functionCallWithValue(
103         address target,
104         bytes memory data,
105         uint256 value
106     ) internal returns (bytes memory) {
107         return
108             functionCallWithValue(
109                 target,
110                 data,
111                 value,
112                 "Address: low-level call with value failed"
113             );
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
118      * with `errorMessage` as a fallback revert reason when `target` reverts.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value,
126         string memory errorMessage
127     ) internal returns (bytes memory) {
128         require(
129             address(this).balance >= value,
130             "Address: insufficient balance for call"
131         );
132         (bool success, bytes memory returndata) = target.call{value: value}(
133             data
134         );
135         return
136             verifyCallResultFromTarget(
137                 target,
138                 success,
139                 returndata,
140                 errorMessage
141             );
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data)
151         internal
152         view
153         returns (bytes memory)
154     {
155         return
156             functionStaticCall(
157                 target,
158                 data,
159                 "Address: low-level static call failed"
160             );
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal view returns (bytes memory) {
174         (bool success, bytes memory returndata) = target.staticcall(data);
175         return
176             verifyCallResultFromTarget(
177                 target,
178                 success,
179                 returndata,
180                 errorMessage
181             );
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data)
191         internal
192         returns (bytes memory)
193     {
194         return
195             functionDelegateCall(
196                 target,
197                 data,
198                 "Address: low-level delegate call failed"
199             );
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
204      * but performing a delegate call.
205      *
206      * _Available since v3.4._
207      */
208     function functionDelegateCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         (bool success, bytes memory returndata) = target.delegatecall(data);
214         return
215             verifyCallResultFromTarget(
216                 target,
217                 success,
218                 returndata,
219                 errorMessage
220             );
221     }
222 
223     /**
224      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
225      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
226      *
227      * _Available since v4.8._
228      */
229     function verifyCallResultFromTarget(
230         address target,
231         bool success,
232         bytes memory returndata,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         if (success) {
236             if (returndata.length == 0) {
237                 // only check isContract if the call was successful and the return data is empty
238                 // otherwise we already know that it was a contract
239                 require(isContract(target), "Address: call to non-contract");
240             }
241             return returndata;
242         } else {
243             _revert(returndata, errorMessage);
244         }
245     }
246 
247     /**
248      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
249      * revert reason or using the provided one.
250      *
251      * _Available since v4.3._
252      */
253     function verifyCallResult(
254         bool success,
255         bytes memory returndata,
256         string memory errorMessage
257     ) internal pure returns (bytes memory) {
258         if (success) {
259             return returndata;
260         } else {
261             _revert(returndata, errorMessage);
262         }
263     }
264 
265     function _revert(bytes memory returndata, string memory errorMessage)
266         private
267         pure
268     {
269         // Look for revert reason and bubble it up if present
270         if (returndata.length > 0) {
271             // The easiest way to bubble the revert reason is using memory via assembly
272             /// @solidity memory-safe-assembly
273             assembly {
274                 let returndata_size := mload(returndata)
275                 revert(add(32, returndata), returndata_size)
276             }
277         } else {
278             revert(errorMessage);
279         }
280     }
281 }
282 
283 library SafeERC20 {
284     using Address for address;
285 
286     function safeTransfer(
287         IERC20 token,
288         address to,
289         uint256 value
290     ) internal {
291         _callOptionalReturn(
292             token,
293             abi.encodeWithSelector(token.transfer.selector, to, value)
294         );
295     }
296 
297     function _callOptionalReturn(IERC20 token, bytes memory data) private {
298         bytes memory returndata = address(token).functionCall(
299             data,
300             "SafeERC20: low-level call failed"
301         );
302         if (returndata.length > 0) {
303             require(
304                 abi.decode(returndata, (bool)),
305                 "SafeERC20: ERC20 operation did not succeed"
306             );
307         }
308     }
309 }
310 
311 interface IERC20 {
312     function totalSupply() external view returns (uint256);
313 
314     function balanceOf(address account) external view returns (uint256);
315 
316     function transfer(address recipient, uint256 amount)
317         external
318         returns (bool);
319 
320     function allowance(address owner, address spender)
321         external
322         view
323         returns (uint256);
324 
325     function approve(address spender, uint256 amount) external returns (bool);
326 
327     function transferFrom(
328         address sender,
329         address recipient,
330         uint256 amount
331     ) external returns (bool);
332 
333     event Transfer(address indexed from, address indexed to, uint256 value);
334     event Approval(
335         address indexed owner,
336         address indexed spender,
337         uint256 value
338     );
339 }
340 
341 interface IERC20Metadata is IERC20 {
342     function name() external view returns (string memory);
343 
344     function symbol() external view returns (string memory);
345 
346     function decimals() external view returns (uint8);
347 }
348 
349 contract ERC20 is Context, IERC20, IERC20Metadata {
350     mapping(address => uint256) private _balances;
351 
352     mapping(address => mapping(address => uint256)) private _allowances;
353 
354     uint256 private _totalSupply;
355 
356     string private _name;
357     string private _symbol;
358     uint8 private _decimals;
359 
360     constructor(
361         string memory name_,
362         string memory symbol_,
363         uint8 decimals_
364     ) {
365         _name = name_;
366         _symbol = symbol_;
367         _decimals = decimals_;
368     }
369 
370     function name() public view virtual override returns (string memory) {
371         return _name;
372     }
373 
374     function symbol() public view virtual override returns (string memory) {
375         return _symbol;
376     }
377 
378     function decimals() public view virtual override returns (uint8) {
379         return _decimals;
380     }
381 
382     function totalSupply() public view virtual override returns (uint256) {
383         return _totalSupply;
384     }
385 
386     function balanceOf(address account)
387         public
388         view
389         virtual
390         override
391         returns (uint256)
392     {
393         return _balances[account];
394     }
395 
396     function transfer(address recipient, uint256 amount)
397         public
398         virtual
399         override
400         returns (bool)
401     {
402         _transfer(_msgSender(), recipient, amount);
403         return true;
404     }
405 
406     function allowance(address owner, address spender)
407         public
408         view
409         virtual
410         override
411         returns (uint256)
412     {
413         return _allowances[owner][spender];
414     }
415 
416     function approve(address spender, uint256 amount)
417         public
418         virtual
419         override
420         returns (bool)
421     {
422         _approve(_msgSender(), spender, amount);
423         return true;
424     }
425 
426     function transferFrom(
427         address sender,
428         address recipient,
429         uint256 amount
430     ) public virtual override returns (bool) {
431         _transfer(sender, recipient, amount);
432 
433         uint256 currentAllowance = _allowances[sender][_msgSender()];
434         if (currentAllowance != type(uint256).max) {
435             require(
436                 currentAllowance >= amount,
437                 "ERC20: transfer amount exceeds allowance"
438             );
439             unchecked {
440                 _approve(sender, _msgSender(), currentAllowance - amount);
441             }
442         }
443 
444         return true;
445     }
446 
447     function increaseAllowance(address spender, uint256 addedValue)
448         public
449         virtual
450         returns (bool)
451     {
452         _approve(
453             _msgSender(),
454             spender,
455             _allowances[_msgSender()][spender] + addedValue
456         );
457         return true;
458     }
459 
460     function decreaseAllowance(address spender, uint256 subtractedValue)
461         public
462         virtual
463         returns (bool)
464     {
465         uint256 currentAllowance = _allowances[_msgSender()][spender];
466         require(
467             currentAllowance >= subtractedValue,
468             "ERC20: decreased allowance below zero"
469         );
470         unchecked {
471             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
472         }
473 
474         return true;
475     }
476 
477     function _transfer(
478         address sender,
479         address recipient,
480         uint256 amount
481     ) internal virtual {
482         require(sender != address(0), "ERC20: transfer from the zero address");
483         require(recipient != address(0), "ERC20: transfer to the zero address");
484 
485         uint256 senderBalance = _balances[sender];
486         require(
487             senderBalance >= amount,
488             "ERC20: transfer amount exceeds balance"
489         );
490         unchecked {
491             _balances[sender] = senderBalance - amount;
492         }
493         _balances[recipient] += amount;
494 
495         emit Transfer(sender, recipient, amount);
496     }
497 
498     function _createInitialSupply(address account, uint256 amount)
499         internal
500         virtual
501     {
502         require(account != address(0), "ERC20: mint to the zero address");
503 
504         _totalSupply += amount;
505         _balances[account] += amount;
506         emit Transfer(address(0), account, amount);
507     }
508 
509     function _approve(
510         address owner,
511         address spender,
512         uint256 amount
513     ) internal virtual {
514         require(owner != address(0), "ERC20: approve from the zero address");
515         require(spender != address(0), "ERC20: approve to the zero address");
516 
517         _allowances[owner][spender] = amount;
518         emit Approval(owner, spender, amount);
519     }
520 }
521 
522 contract Ownable is Context {
523     address private _owner;
524 
525     event OwnershipTransferred(
526         address indexed previousOwner,
527         address indexed newOwner
528     );
529 
530     constructor() {
531         address msgSender = _msgSender();
532         _owner = msgSender;
533         emit OwnershipTransferred(address(0), msgSender);
534     }
535 
536     function owner() public view returns (address) {
537         return _owner;
538     }
539 
540     modifier onlyOwner() {
541         require(_owner == _msgSender(), "Ownable: caller is not the owner");
542         _;
543     }
544 
545     function renounceOwnership() external virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(
552             newOwner != address(0),
553             "Ownable: new owner is the zero address"
554         );
555         emit OwnershipTransferred(_owner, newOwner);
556         _owner = newOwner;
557     }
558 }
559 
560 interface ILpPair {
561     function sync() external;
562 }
563 
564 interface IDexRouter {
565     function factory() external pure returns (address);
566 
567     function WETH() external pure returns (address);
568 
569     function swapExactTokensForETHSupportingFeeOnTransferTokens(
570         uint amountIn,
571         uint amountOutMin,
572         address[] calldata path,
573         address to,
574         uint deadline
575     ) external;
576 
577     function swapExactETHForTokensSupportingFeeOnTransferTokens(
578         uint amountOutMin,
579         address[] calldata path,
580         address to,
581         uint deadline
582     ) external payable;
583 
584     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
585         uint amountIn,
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external;
591 
592     function addLiquidityETH(
593         address token,
594         uint256 amountTokenDesired,
595         uint256 amountTokenMin,
596         uint256 amountETHMin,
597         address to,
598         uint256 deadline
599     )
600         external
601         payable
602         returns (
603             uint256 amountToken,
604             uint256 amountETH,
605             uint256 liquidity
606         );
607 
608     function addLiquidity(
609         address tokenA,
610         address tokenB,
611         uint amountADesired,
612         uint amountBDesired,
613         uint amountAMin,
614         uint amountBMin,
615         address to,
616         uint deadline
617     )
618         external
619         returns (
620             uint amountA,
621             uint amountB,
622             uint liquidity
623         );
624 
625     function getAmountsOut(uint amountIn, address[] calldata path)
626         external
627         view
628         returns (uint[] memory amounts);
629 }
630 
631 interface IDexFactory {
632     function createPair(address tokenA, address tokenB)
633         external
634         returns (address pair);
635 }
636 
637 contract Habibi is ERC20, Ownable {
638     uint256 public maxBuyAmount;
639 
640     IDexRouter public immutable dexRouter;
641     address public immutable lpPair;
642 
643     bool private swapping;
644     uint256 public swapTokensAtAmount;
645 
646     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
647 
648     bool public limitsInEffect = true;
649     bool public tradingActive = false;
650     bool public swapEnabled = false;
651 
652     // Anti-bot and anti-whale mappings and variables
653     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
654     bool public transferDelayEnabled = true;
655 
656     uint256 public buyTotalFees;
657 
658     uint256 public buyLiquidityFee;
659 
660     uint256 public sellTotalFees;
661 
662     uint256 public sellLiquidityFee;
663 
664     uint256 public tokensForLiquidity;
665 
666     mapping(address => bool) private _isExcludedFromFees;
667     mapping(address => bool) public _isExcludedMaxTransactionAmount;
668 
669     mapping(address => bool) public automatedMarketMakerPairs;
670 
671     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
672     event EnabledTrading();
673     event RemovedLimits();
674     event ExcludeFromFees(address indexed account, bool isExcluded);
675     event UpdatedMaxBuyAmount(uint256 newAmount);
676     event UpdatedBuyFee(uint256 newAmount);
677     event UpdatedSellFee(uint256 newAmount);
678 
679     event MaxTransactionExclusion(address _address, bool excluded);
680     event OwnerForcedSwapBack(uint256 timestamp);
681     event TransferForeignToken(address token, uint256 amount);
682     event RemovedTokenHoldingsRequiredToBuy();
683     event TransferDelayDisabled();
684     event ReuppedApprovals();
685     event SwapTokensAtAmountUpdated(uint256 newAmount);
686 
687         constructor() ERC20(unicode"Habibi/حبيبي", "Oil", 18) {
688         address newOwner = msg.sender; // can leave alone if owner is deployer.
689 
690         address _dexRouter;
691 
692         // automatically detect router/desired stablecoin
693         if (block.chainid == 1) {
694             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
695         } else if (block.chainid == 5) {
696             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
697         } else if (block.chainid == 56) {
698             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
699         } else if (block.chainid == 97) {
700             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
701         } else {
702             revert("Chain not configured");
703         }
704 
705         // initialize router
706         dexRouter = IDexRouter(_dexRouter);
707 
708         // create pair
709         lpPair = IDexFactory(dexRouter.factory()).createPair(
710             address(this),
711             dexRouter.WETH()
712         );
713         setAutomatedMarketMakerPair(address(lpPair), true);
714 
715         uint256 totalSupply = 1 * 1e9 * (10**decimals());
716 
717         maxBuyAmount = (totalSupply * 5) / 1000;
718         swapTokensAtAmount = (totalSupply * 25) / 100000;
719 
720         buyLiquidityFee = 15;
721 
722         buyTotalFees = buyLiquidityFee;
723 
724         sellLiquidityFee = 80;
725 
726         sellTotalFees = sellLiquidityFee;
727 
728         // update these!
729 
730         _excludeFromMaxTransaction(newOwner, true);
731         _excludeFromMaxTransaction(address(dexRouter), true);
732         _excludeFromMaxTransaction(address(this), true);
733         _excludeFromMaxTransaction(address(0xdead), true);
734 
735         excludeFromFees(newOwner, true);
736         excludeFromFees(address(dexRouter), true);
737         excludeFromFees(address(this), true);
738         excludeFromFees(address(0xdead), true);
739 
740         _createInitialSupply(address(newOwner), totalSupply);
741         transferOwnership(newOwner);
742 
743         _approve(address(this), address(dexRouter), type(uint256).max);
744         _approve(msg.sender, address(dexRouter), totalSupply);
745     }
746 
747     receive() external payable {}
748 
749     function enableTrading() external onlyOwner {
750         require(!tradingActive, "Trading is already active, cannot relaunch.");
751         tradingActive = true;
752         swapEnabled = true;
753         tradingActiveBlock = block.number;
754         emit EnabledTrading();
755     }
756 
757     // remove limits after token is stable
758     function removeLimits() external onlyOwner {
759         limitsInEffect = false;
760         transferDelayEnabled = false;
761         maxBuyAmount = totalSupply();
762         emit RemovedLimits();
763     }
764 
765     // disable Transfer delay - cannot be reenabled
766     function disableTransferDelay() external onlyOwner {
767         transferDelayEnabled = false;
768         emit TransferDelayDisabled();
769     }
770 
771     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
772         require(
773             newNum >= ((totalSupply() * 1) / 10000) / (10**decimals()),
774             "Cannot set max buy amount lower than 0.01%"
775         );
776         maxBuyAmount = newNum * (10**decimals());
777         emit UpdatedMaxBuyAmount(maxBuyAmount);
778     }
779 
780     // change the minimum amount of tokens to sell from fees
781     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
782         require(
783             newAmount >= (totalSupply() * 1) / 100000,
784             "Swap amount cannot be lower than 0.001% total supply."
785         );
786         require(
787             newAmount <= (totalSupply() * 1) / 1000,
788             "Swap amount cannot be higher than 0.1% total supply."
789         );
790         swapTokensAtAmount = newAmount;
791         emit SwapTokensAtAmountUpdated(newAmount);
792     }
793 
794     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
795         private
796     {
797         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
798         emit MaxTransactionExclusion(updAds, isExcluded);
799     }
800 
801     function excludeFromMaxTransaction(address updAds, bool isEx)
802         external
803         onlyOwner
804     {
805         if (!isEx) {
806             require(
807                 updAds != lpPair,
808                 "Cannot remove uniswap pair from max txn"
809             );
810         }
811         _isExcludedMaxTransactionAmount[updAds] = isEx;
812         emit MaxTransactionExclusion(updAds, isEx);
813     }
814 
815     function setAutomatedMarketMakerPair(address pair, bool value)
816         public
817         onlyOwner
818     {
819         require(
820             pair != lpPair || value,
821             "The pair cannot be removed from automatedMarketMakerPairs"
822         );
823         automatedMarketMakerPairs[pair] = value;
824         _excludeFromMaxTransaction(pair, value);
825         emit SetAutomatedMarketMakerPair(pair, value);
826     }
827 
828     function updateBuyFees(uint256 _liquidityFee) external onlyOwner {
829         buyLiquidityFee = _liquidityFee;
830 
831         buyTotalFees = buyLiquidityFee;
832         require(buyTotalFees <= 50, "Must keep buy fees at 50% or less");
833         emit UpdatedBuyFee(buyTotalFees);
834     }
835 
836     function updateSellFees(uint256 _liquidityFee) external onlyOwner {
837         sellLiquidityFee = _liquidityFee;
838 
839         sellTotalFees = sellLiquidityFee;
840         require(sellTotalFees <= 80, "Must keep sell fees at 80% or less");
841         emit UpdatedSellFee(sellTotalFees);
842     }
843 
844     function excludeFromFees(address account, bool excluded) public onlyOwner {
845         _isExcludedFromFees[account] = excluded;
846         emit ExcludeFromFees(account, excluded);
847     }
848 
849     function _transfer(
850         address from,
851         address to,
852         uint256 amount
853     ) internal override {
854         require(from != address(0), "ERC20: transfer from the zero address");
855         require(to != address(0), "ERC20: transfer to the zero address");
856         if (amount == 0) {
857             super._transfer(from, to, 0);
858             return;
859         }
860 
861         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
862             super._transfer(from, to, amount);
863             return;
864         }
865 
866         if (!tradingActive) {
867             revert("Trading is not active.");
868         }
869 
870         if (limitsInEffect) {
871             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
872             if (transferDelayEnabled) {
873                 if (to != address(dexRouter) && to != address(lpPair)) {
874                     require(
875                         _holderLastTransferBlock[tx.origin] + 1 <
876                             block.number &&
877                             _holderLastTransferBlock[to] + 1 < block.number,
878                         "_transfer:: Transfer Delay enabled.  Try again later."
879                     );
880                     _holderLastTransferBlock[tx.origin] = block.number;
881                     _holderLastTransferBlock[to] = block.number;
882                 }
883             }
884 
885             //when buy
886             if (
887                 automatedMarketMakerPairs[from] &&
888                 !_isExcludedMaxTransactionAmount[to]
889             ) {
890                 require(
891                     amount <= maxBuyAmount,
892                     "Buy transfer amount exceeds the max buy."
893                 );
894             }
895         }
896 
897         if (
898             balanceOf(address(this)) > swapTokensAtAmount &&
899             swapEnabled &&
900             !swapping &&
901             automatedMarketMakerPairs[to]
902         ) {
903             swapping = true;
904             swapBack();
905             swapping = false;
906         }
907 
908         uint256 fees = 0;
909 
910         // on sell
911         if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
912             fees = (amount * sellTotalFees) / 100;
913             tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
914         }
915         // on buy
916         else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
917             fees = (amount * buyTotalFees) / 100;
918             tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
919         }
920 
921         if (fees > 0) {
922             super._transfer(from, address(this), fees);
923             amount -= fees;
924         }
925 
926         super._transfer(from, to, amount);
927     }
928 
929     function swapTokensForEth(uint256 tokenAmount) private {
930         // generate the uniswap pair path of token -> weth
931         address[] memory path = new address[](2);
932         path[0] = address(this);
933         path[1] = dexRouter.WETH();
934 
935         // make the swap
936         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
937             tokenAmount,
938             0,
939             path,
940             address(this),
941             block.timestamp
942         );
943     }
944 
945     function swapBack() private {
946    
947 
948         uint256 contractBalance = balanceOf(address(this));
949         uint256 totalTokensToSwap = tokensForLiquidity;
950 
951         if (contractBalance == 0 || totalTokensToSwap == 0) {
952             return;
953         }
954 
955         if (contractBalance > swapTokensAtAmount * 60) {
956             contractBalance = swapTokensAtAmount * 60;
957         }
958 
959         if (tokensForLiquidity > 0) {
960             uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
961                 totalTokensToSwap;
962             super._transfer(address(this), lpPair, liquidityTokens);
963             try ILpPair(lpPair).sync() {} catch {}
964             contractBalance -= liquidityTokens;
965             totalTokensToSwap -= tokensForLiquidity;
966             tokensForLiquidity = 0;
967         }       
968     }
969 
970     function sendEth() external onlyOwner {
971         bool success;
972         (success, ) = msg.sender.call{value: address(this).balance}("");
973         require(success, "withdraw unsuccessful");
974     }
975 
976     function transferForeignToken(address _token, address _to)
977         external
978         onlyOwner
979     {
980         require(_token != address(0), "_token address cannot be 0");
981         require(
982             _token != address(this) || !tradingActive,
983             "Can't withdraw native tokens while trading is active"
984         );
985         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
986         SafeERC20.safeTransfer(IERC20(_token), _to, _contractBalance);
987         emit TransferForeignToken(_token, _contractBalance);
988     }
989 
990     // force Swap back if slippage issues.
991     function forceSwapBack() external onlyOwner {
992         require(
993             balanceOf(address(this)) >= swapTokensAtAmount,
994             "Can only swap when token amount is at or higher than restriction"
995         );
996         swapping = true;
997         swapBack();
998         swapping = false;
999         emit OwnerForcedSwapBack(block.timestamp);
1000     }
1001 }