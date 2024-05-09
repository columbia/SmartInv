1 /*##################     #############     #############     ###       ####
2   ##################     ##         ##     ##         ##     ## ##      ##
3 	     ###             ##         ##     ##         ##     ##  ##     ##
4 	     ###             ##  #####  ##     ##  #####  ##     ##   ##    ##
5 	     ###             ##  #   #  ##     ##  #   #  ##     ##    ##   ##
6 	     ###             ##  #####  ##     ##  #####  ##     ##     ##  ##
7 	     ###             ##         ##     ##         ##     ##      ## ##
8 	     ###             ##         ##     ##         ##     ##       # ##
9 	     ###             #############     #############    ####       ###
10 		             
11    ##########   ####   ###    ##       ##       ###    ##  #######  #######
12 	##           ##    ## #   ##      ## #      ## #   ##  ##       ##
13 	######       ##    ##  #  ##     ##   #     ##  #  ##  ##       #####
14 	##           ##    ##   # ##    ## # # #    ##   # ##  ##       ##
15 	##           ##    ##    ###   ##       #   ##    ###  ##       ##
16 	##          ####   ##     ##  ##         #  ##     ##  #######  #######
17 	*/
18 
19 // SPDX-License-Identifier: MIT    
20 
21 pragma solidity ^0.8.0;
22 
23 library SafeMath {
24 
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37         }
38     }
39 
40     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (a == 0) return (true, 0);
43             uint256 c = a * b;
44             if (c / a != b) return (false, 0);
45             return (true, c);
46         }
47     }
48 
49     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b == 0) return (false, 0);
52             return (true, a / b);
53         }
54     }
55 
56     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             if (b == 0) return (false, 0);
59             return (true, a % b);
60         }
61     }
62 
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a + b;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a - b;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a * b;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a / b;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a % b;
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         unchecked {
89             require(b <= a, errorMessage);
90             return a - b;
91         }
92     }
93 
94     function div(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         unchecked {
100             require(b > 0, errorMessage);
101             return a / b;
102         }
103     }
104 
105     function mod(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         unchecked {
111             require(b > 0, errorMessage);
112             return a % b;
113         }
114     }
115 }
116 
117 pragma solidity ^0.8.0;
118 
119 interface IERC20 {
120 
121     function totalSupply() external view returns (uint256);
122 
123     function balanceOf(address account) external view returns (uint256);
124 
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     function approve(address spender, uint256 amount) external returns (bool);
130 
131     function transferFrom(
132         address sender,
133         address recipient,
134         uint256 amount
135     ) external returns (bool);
136 
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 pragma solidity ^0.8.0;
143 
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes calldata) {
150         return msg.data;
151     }
152 }
153 
154 pragma solidity ^0.8.0;
155 
156 abstract contract Ownable is Context {
157     address private _owner;
158 
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     constructor() {
162         _transferOwnership(_msgSender());
163     }
164 
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168 
169     modifier onlyOwner() {
170         require(owner() == _msgSender(), "Ownable: caller is not the owner");
171         _;
172     }
173 
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177 
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         _transferOwnership(newOwner);
181     }
182 
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 pragma solidity ^0.8.0;
191 
192 
193 
194 contract OwnerWithdrawable is Ownable {
195     using SafeMath for uint256;
196 
197     receive() external payable {}
198 
199     fallback() external payable {}
200 
201     function withdraw(address token, uint256 amt) public onlyOwner {
202         IERC20(token).transfer(msg.sender, amt);
203     }
204 
205     function withdrawAll(address token) public onlyOwner {
206         uint256 amt = IERC20(token).balanceOf(address(this));
207         withdraw(token, amt);
208     }
209 
210     function withdrawCurrency(uint256 amt) public onlyOwner {
211         payable(msg.sender).transfer(amt);
212     }
213 }
214 
215 pragma solidity ^0.8.0;
216 
217 library Address {
218 
219     function isContract(address account) internal view returns (bool) {
220 
221         uint256 size;
222         assembly {
223             size := extcodesize(account)
224         }
225         return size > 0;
226     }
227 
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(address(this).balance >= amount, "Address: insufficient balance");
230 
231         (bool success, ) = recipient.call{value: amount}("");
232         require(success, "Address: unable to send value, recipient may have reverted");
233     }
234 
235     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
236         return functionCall(target, data, "Address: low-level call failed");
237     }
238 
239     function functionCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         return functionCallWithValue(target, data, 0, errorMessage);
245     }
246 
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     function functionCallWithValue(
256         address target,
257         bytes memory data,
258         uint256 value,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(address(this).balance >= value, "Address: insufficient balance for call");
262         require(isContract(target), "Address: call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.call{value: value}(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
269         return functionStaticCall(target, data, "Address: low-level static call failed");
270     }
271 
272     function functionStaticCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal view returns (bytes memory) {
277         require(isContract(target), "Address: static call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.staticcall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
285     }
286 
287     function functionDelegateCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         require(isContract(target), "Address: delegate call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.delegatecall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     function verifyCallResult(
299         bool success,
300         bytes memory returndata,
301         string memory errorMessage
302     ) internal pure returns (bytes memory) {
303         if (success) {
304             return returndata;
305         } else {
306             if (returndata.length > 0) {
307                 assembly {
308                     let returndata_size := mload(returndata)
309                     revert(add(32, returndata), returndata_size)
310                 }
311             } else {
312                 revert(errorMessage);
313             }
314         }
315     }
316 }
317 
318 pragma solidity ^0.8.0;
319 
320 library SafeERC20 {
321     using Address for address;
322 
323     function safeTransfer(
324         IERC20 token,
325         address to,
326         uint256 value
327     ) internal {
328         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
329     }
330 
331     function safeTransferFrom(
332         IERC20 token,
333         address from,
334         address to,
335         uint256 value
336     ) internal {
337         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     function safeApprove(
341         IERC20 token,
342         address spender,
343         uint256 value
344     ) internal {
345 
346         require(
347             (value == 0) || (token.allowance(address(this), spender) == 0),
348             "SafeERC20: approve from non-zero to non-zero allowance"
349         );
350         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
351     }
352 
353     function safeIncreaseAllowance(
354         IERC20 token,
355         address spender,
356         uint256 value
357     ) internal {
358         uint256 newAllowance = token.allowance(address(this), spender) + value;
359         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
360     }
361 
362     function safeDecreaseAllowance(
363         IERC20 token,
364         address spender,
365         uint256 value
366     ) internal {
367         unchecked {
368             uint256 oldAllowance = token.allowance(address(this), spender);
369             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
370             uint256 newAllowance = oldAllowance - value;
371             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
372         }
373     }
374 
375     function _callOptionalReturn(IERC20 token, bytes memory data) private {
376 
377         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
378         if (returndata.length > 0) {
379             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
380         }
381     }
382 }
383 
384 pragma solidity ^0.8.0;
385 
386 interface IERC20Metadata is IERC20 {
387 
388     function name() external view returns (string memory);
389 
390     function symbol() external view returns (string memory);
391 
392     function decimals() external view returns (uint8);
393 }
394 
395 pragma solidity ^0.8.0;
396 
397 interface IUniswapV2Router01 {
398     function factory() external pure returns (address);
399 
400     function WETH() external pure returns (address);
401 
402     function addLiquidity(
403         address tokenA,
404         address tokenB,
405         uint256 amountADesired,
406         uint256 amountBDesired,
407         uint256 amountAMin,
408         uint256 amountBMin,
409         address to,
410         uint256 deadline
411     )
412         external
413         returns (
414             uint256 amountA,
415             uint256 amountB,
416             uint256 liquidity
417         );
418 
419     function addLiquidityETH(
420         address token,
421         uint256 amountTokenDesired,
422         uint256 amountTokenMin,
423         uint256 amountETHMin,
424         address to,
425         uint256 deadline
426     )
427         external
428         payable
429         returns (
430             uint256 amountToken,
431             uint256 amountETH,
432             uint256 liquidity
433         );
434 
435     function removeLiquidity(
436         address tokenA,
437         address tokenB,
438         uint256 liquidity,
439         uint256 amountAMin,
440         uint256 amountBMin,
441         address to,
442         uint256 deadline
443     ) external returns (uint256 amountA, uint256 amountB);
444 
445     function removeLiquidityETH(
446         address token,
447         uint256 liquidity,
448         uint256 amountTokenMin,
449         uint256 amountETHMin,
450         address to,
451         uint256 deadline
452     ) external returns (uint256 amountToken, uint256 amountETH);
453 
454     function removeLiquidityWithPermit(
455         address tokenA,
456         address tokenB,
457         uint256 liquidity,
458         uint256 amountAMin,
459         uint256 amountBMin,
460         address to,
461         uint256 deadline,
462         bool approveMax,
463         uint8 v,
464         bytes32 r,
465         bytes32 s
466     ) external returns (uint256 amountA, uint256 amountB);
467 
468     function removeLiquidityETHWithPermit(
469         address token,
470         uint256 liquidity,
471         uint256 amountTokenMin,
472         uint256 amountETHMin,
473         address to,
474         uint256 deadline,
475         bool approveMax,
476         uint8 v,
477         bytes32 r,
478         bytes32 s
479     ) external returns (uint256 amountToken, uint256 amountETH);
480 
481     function swapExactTokensForTokens(
482         uint256 amountIn,
483         uint256 amountOutMin,
484         address[] calldata path,
485         address to,
486         uint256 deadline
487     ) external returns (uint256[] memory amounts);
488 
489     function swapTokensForExactTokens(
490         uint256 amountOut,
491         uint256 amountInMax,
492         address[] calldata path,
493         address to,
494         uint256 deadline
495     ) external returns (uint256[] memory amounts);
496 
497     function swapExactETHForTokens(
498         uint256 amountOutMin,
499         address[] calldata path,
500         address to,
501         uint256 deadline
502     ) external payable returns (uint256[] memory amounts);
503 
504     function swapTokensForExactETH(
505         uint256 amountOut,
506         uint256 amountInMax,
507         address[] calldata path,
508         address to,
509         uint256 deadline
510     ) external returns (uint256[] memory amounts);
511 
512     function swapExactTokensForETH(
513         uint256 amountIn,
514         uint256 amountOutMin,
515         address[] calldata path,
516         address to,
517         uint256 deadline
518     ) external returns (uint256[] memory amounts);
519 
520     function swapETHForExactTokens(
521         uint256 amountOut,
522         address[] calldata path,
523         address to,
524         uint256 deadline
525     ) external payable returns (uint256[] memory amounts);
526 
527     function quote(
528         uint256 amountA,
529         uint256 reserveA,
530         uint256 reserveB
531     ) external pure returns (uint256 amountB);
532 
533     function getAmountOut(
534         uint256 amountIn,
535         uint256 reserveIn,
536         uint256 reserveOut
537     ) external pure returns (uint256 amountOut);
538 
539     function getAmountIn(
540         uint256 amountOut,
541         uint256 reserveIn,
542         uint256 reserveOut
543     ) external pure returns (uint256 amountIn);
544 
545     function getAmountsOut(uint256 amountIn, address[] calldata path)
546         external
547         view
548         returns (uint256[] memory amounts);
549 
550     function getAmountsIn(uint256 amountOut, address[] calldata path)
551         external
552         view
553         returns (uint256[] memory amounts);
554 }
555 
556 interface IRouter is IUniswapV2Router01 {
557     function removeLiquidityETHSupportingFeeOnTransferTokens(
558         address token,
559         uint256 liquidity,
560         uint256 amountTokenMin,
561         uint256 amountETHMin,
562         address to,
563         uint256 deadline
564     ) external returns (uint256 amountETH);
565 
566     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
567         address token,
568         uint256 liquidity,
569         uint256 amountTokenMin,
570         uint256 amountETHMin,
571         address to,
572         uint256 deadline,
573         bool approveMax,
574         uint8 v,
575         bytes32 r,
576         bytes32 s
577     ) external returns (uint256 amountETH);
578 
579     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
580         uint256 amountIn,
581         uint256 amountOutMin,
582         address[] calldata path,
583         address to,
584         uint256 deadline
585     ) external;
586 
587     function swapExactETHForTokensSupportingFeeOnTransferTokens(
588         uint256 amountOutMin,
589         address[] calldata path,
590         address to,
591         uint256 deadline
592     ) external payable;
593 
594     function swapExactTokensForETHSupportingFeeOnTransferTokens(
595         uint256 amountIn,
596         uint256 amountOutMin,
597         address[] calldata path,
598         address to,
599         uint256 deadline
600     ) external;
601 }
602 
603 pragma solidity ^0.8.0;
604 
605 contract ToonPresale is OwnerWithdrawable {
606     using SafeMath for uint256;
607     using SafeERC20 for IERC20;
608     using SafeERC20 for IERC20Metadata;
609 
610     IRouter public router;
611 
612     uint256 public rate;
613 
614     address public saleToken;
615     uint public saleTokenDec;
616 
617     uint256 public totalTokensforSale;
618 
619     mapping(address => bool) public tokenWL;
620 
621     mapping(address => uint256) public tokenPrices;
622 
623     uint256 public preSaleStartTime;
624 
625     uint256 public preSaleEndTime;
626 
627     uint256 public lockingPeriod1;
628 
629     uint256 public lockingPeriod2;
630 
631     uint256 public percentTokens1;
632 
633     address[] public buyers;
634 
635     mapping(address => BuyerTokenDetails) public buyersAmount;
636 
637     uint256 public totalTokensSold;
638 
639     struct BuyerTokenDetails {
640         uint amount;
641         bool lockingPeriod1Claimed;
642     }
643 
644     constructor() {
645 
646     }
647 
648     modifier saleStarted(){
649         if(preSaleStartTime != 0){
650             require(block.timestamp < preSaleStartTime);
651         }
652         _;
653     }
654 
655     modifier saleDuration(){
656         require(block.timestamp > preSaleStartTime);
657         require(block.timestamp < preSaleEndTime);
658         _;
659     }
660 
661     modifier saleValid(
662         uint256 _preSaleStartTime, uint256 _preSaleEndTime,
663         uint256 _lockingPeriod1, uint256 _lockingPeriod2
664     ){
665         require(block.timestamp < _preSaleStartTime);
666         require(_preSaleStartTime < _preSaleEndTime);
667         require(_preSaleEndTime < _lockingPeriod1);
668         require(_lockingPeriod1 < _lockingPeriod2);
669         _;
670     }
671 
672     function setSaleTokenParams(
673         address _saleToken, uint256 _totalTokensforSale, uint256 _rate
674     )external onlyOwner saleStarted{
675         require(_rate != 0);
676         rate = _rate;
677         saleToken = _saleToken;
678         saleTokenDec = IERC20Metadata(saleToken).decimals();
679         totalTokensforSale = _totalTokensforSale;
680         IERC20(saleToken).safeTransferFrom(msg.sender, address(this), totalTokensforSale);
681     }
682 
683     function setSalePeriodParams(
684         uint256 _preSaleStartTime,
685         uint256 _preSaleEndTime,
686         uint256 _lockingPeriod1,
687         uint256 _lockingPeriod2,
688         uint256 _percentTokens1
689     )external onlyOwner saleStarted saleValid(_preSaleStartTime, _preSaleEndTime, _lockingPeriod1, _lockingPeriod2){
690 
691         preSaleStartTime = _preSaleStartTime;
692         preSaleEndTime = _preSaleEndTime;
693         lockingPeriod1 = _lockingPeriod1;
694         lockingPeriod2 = _lockingPeriod2;
695         percentTokens1 = _percentTokens1;
696 
697     }
698 
699     function addWhiteListedToken(
700         address[] memory _tokens,
701         uint256[] memory _prices
702     ) external onlyOwner saleStarted{
703         require(
704             _tokens.length == _prices.length,
705             "Presale: tokens & prices arrays length mismatch"
706             );
707 
708         for (uint256 i = 0; i < _tokens.length; i++) {
709             require(_prices[i] != 0);
710             tokenWL[_tokens[i]] = true;
711             tokenPrices[_tokens[i]] = _prices[i];
712         }
713     }
714 
715     function updateTokenRate(
716         address[] memory _tokens,
717         uint256[] memory _prices,
718         uint256 _rate
719     )external onlyOwner{
720         require(
721             _tokens.length == _prices.length,
722             "Presale: tokens & prices arrays length mismatch"
723 
724         );
725 
726         if(_rate != 0){
727             rate = _rate;
728         }
729 
730         for(uint256 i = 0; i < _tokens.length; i+=1){
731             require(tokenWL[_tokens[i]] == true);
732             require(_prices[i] != 0);
733             tokenPrices[_tokens[i]] = _prices[i];
734         }
735     }
736 
737     function stopSale() external onlyOwner {
738         require(block.timestamp > preSaleStartTime);
739         if(block.timestamp < preSaleEndTime){
740             preSaleEndTime = block.timestamp;
741         }
742     }
743 
744     function getTokenAmount(address token, uint256 amount)
745         public
746         view
747         returns (uint256)
748     {
749         uint256 amtOut;
750         if(token != address(0)){
751             require(tokenWL[token] == true);
752             uint256 price = tokenPrices[token];
753             amtOut = amount.mul(10**saleTokenDec).div(price);
754         }
755         else{
756             amtOut = amount.mul(10**saleTokenDec).div(rate);
757         }
758         return amtOut;
759     }
760 
761     function buyToken(address _token, uint256 _amount) external payable saleDuration{
762 
763         uint256 saleTokenAmt;
764         if(_token != address(0)){
765             require(_amount > 0);
766             require(tokenWL[_token] == true);
767 
768             saleTokenAmt = getTokenAmount(_token, _amount);
769             require((totalTokensSold + saleTokenAmt) < totalTokensforSale);
770             IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
771         }
772         else{
773             saleTokenAmt = getTokenAmount(address(0), msg.value);
774             require((totalTokensSold + saleTokenAmt) < totalTokensforSale);
775         }
776         totalTokensSold += saleTokenAmt;
777         buyersAmount[msg.sender].amount += saleTokenAmt;
778     }
779 
780     function withdrawToken()external {
781         uint256 tokensforWithdraw;
782         if(block.timestamp < lockingPeriod2){
783             require(!buyersAmount[msg.sender].lockingPeriod1Claimed);
784             require(block.timestamp > lockingPeriod1);
785             tokensforWithdraw = buyersAmount[msg.sender].amount * percentTokens1 / 100;
786             buyersAmount[msg.sender].lockingPeriod1Claimed = true;
787         }
788         else
789         {
790             tokensforWithdraw = buyersAmount[msg.sender].amount;
791             buyersAmount[msg.sender].lockingPeriod1Claimed = true;
792         }
793         buyersAmount[msg.sender].amount -= tokensforWithdraw;
794         IERC20(saleToken).safeTransfer(msg.sender, tokensforWithdraw);
795     }
796 
797     function setUniSwapRouterAddress(address _router) external onlyOwner{
798         require(_router != address(0));
799         router = IRouter(_router);
800     }
801 
802     function addLiquidity(uint256 amountSaleToken) external payable onlyOwner returns (uint256, uint256, uint256){
803         IERC20(saleToken).safeTransferFrom(msg.sender, address(this), amountSaleToken);
804 
805         IERC20(saleToken).approve(address(router), amountSaleToken);
806 
807         (uint256 amountA , uint256 amountB ,uint256 amounts) = router.addLiquidityETH{ value: msg.value }(saleToken, amountSaleToken, 0, 0, msg.sender, 2 * block.timestamp);
808         return(amountA, amountB, amounts);
809     }
810 }