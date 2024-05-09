1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount)
10         external
11         returns (bool);
12 
13     function allowance(address owner, address spender)
14         external
15         view
16         returns (uint256);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 
33     function mint(uint256 amount) external returns (bool);
34 
35     function burn(uint256 amount) external returns (bool);
36 }
37 
38 interface IERC20Permit {
39 
40     function permit(
41         address owner,
42         address spender,
43         uint256 value,
44         uint256 deadline,
45         uint8 v,
46         bytes32 r,
47         bytes32 s
48     ) external;
49 
50     function nonces(address owner) external view returns (uint256);
51 
52     function DOMAIN_SEPARATOR() external view returns (bytes32);
53 }
54 
55 interface IRouter {
56     function factory() external pure returns (address);
57 
58     function WETH() external pure returns (address);
59 
60     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
61         uint amountIn,
62         uint amountOutMin,
63         address[] calldata path,
64         address to,
65         uint deadline
66     ) external;
67 
68     function addLiquidityETH(
69         address token,
70         uint256 amountTokenDesired,
71         uint256 amountTokenMin,
72         uint256 amountETHMin,
73         address to,
74         uint256 deadline
75     )
76         external
77         payable
78         returns (
79             uint256 amountToken,
80             uint256 amountETH,
81             uint256 liquidity
82         );
83 
84     function swapExactTokensForETHSupportingFeeOnTransferTokens(
85         uint256 amountIn,
86         uint256 amountOutMin,
87         address[] calldata path,
88         address to,
89         uint256 deadline
90     ) external;
91 
92     function addLiquidity(
93         address tokenA,
94         address tokenB,
95         uint256 amountADesired,
96         uint256 amountBDesired,
97         uint256 amountAMin,
98         uint256 amountBMin,
99         address to,
100         uint256 deadline
101     )
102         external
103         returns (
104             uint256 amountA,
105             uint256 amountB,
106             uint256 liquidity
107         );
108 
109     function swapExactETHForTokensSupportingFeeOnTransferTokens(
110         uint256 amountOutMin,
111         address[] calldata path,
112         address to,
113         uint256 deadline
114     ) external payable;
115 
116     function getAmountsOut(
117         uint amountIn, 
118         address[] memory path
119         ) external view returns (uint[] memory amounts);
120     
121     function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
122 
123 }
124 
125 library SafeMath {
126     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             uint256 c = a + b;
129             if (c < a) return (false, 0);
130             return (true, c);
131         }
132     }
133 
134     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             if (b > a) return (false, 0);
137             return (true, a - b);
138         }
139     }
140 
141     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144             // benefit is lost if 'b' is also tested.
145             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146             if (a == 0) return (true, 0);
147             uint256 c = a * b;
148             if (c / a != b) return (false, 0);
149             return (true, c);
150         }
151     }
152 
153     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             if (b == 0) return (false, 0);
156             return (true, a / b);
157         }
158     }
159 
160     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             if (b == 0) return (false, 0);
163             return (true, a % b);
164         }
165     }
166 
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a + b;
169     }
170 
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a - b;
173     }
174 
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a * b;
177     }
178 
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a / b;
181     }
182 
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a % b;
185     }
186 
187     function sub(
188         uint256 a,
189         uint256 b,
190         string memory errorMessage
191     ) internal pure returns (uint256) {
192         unchecked {
193             require(b <= a, errorMessage);
194             return a - b;
195         }
196     }
197 
198     function div(
199         uint256 a,
200         uint256 b,
201         string memory errorMessage
202     ) internal pure returns (uint256) {
203         unchecked {
204             require(b > 0, errorMessage);
205             return a / b;
206         }
207     }
208 
209     function mod(
210         uint256 a,
211         uint256 b,
212         string memory errorMessage
213     ) internal pure returns (uint256) {
214         unchecked {
215             require(b > 0, errorMessage);
216             return a % b;
217         }
218     }
219 }
220 
221 library Address {
222 
223     function isContract(address account) internal view returns (bool) {
224         // This method relies on extcodesize/address.code.length, which returns 0
225         // for contracts in construction, since the code is only stored at the end
226         // of the constructor execution.
227 
228         return account.code.length > 0;
229     }
230 
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         (bool success, ) = recipient.call{value: amount}("");
235         require(success, "Address: unable to send value, recipient may have reverted");
236     }
237 
238     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
240     }
241 
242     function functionCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     function functionCallWithValue(
251         address target,
252         bytes memory data,
253         uint256 value
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
256     }
257 
258     function functionCallWithValue(
259         address target,
260         bytes memory data,
261         uint256 value,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(address(this).balance >= value, "Address: insufficient balance for call");
265         (bool success, bytes memory returndata) = target.call{value: value}(data);
266         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
267     }
268 
269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
270         return functionStaticCall(target, data, "Address: low-level static call failed");
271     }
272 
273     function functionStaticCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal view returns (bytes memory) {
278         (bool success, bytes memory returndata) = target.staticcall(data);
279         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
280     }
281 
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     function functionDelegateCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
293     }
294 
295     function verifyCallResultFromTarget(
296         address target,
297         bool success,
298         bytes memory returndata,
299         string memory errorMessage
300     ) internal view returns (bytes memory) {
301         if (success) {
302             if (returndata.length == 0) {
303                 // only check isContract if the call was successful and the return data is empty
304                 // otherwise we already know that it was a contract
305                 require(isContract(target), "Address: call to non-contract");
306             }
307             return returndata;
308         } else {
309             _revert(returndata, errorMessage);
310         }
311     }
312 
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             _revert(returndata, errorMessage);
322         }
323 
324     }
325 
326     function _revert(bytes memory returndata, string memory errorMessage) private pure {
327         // Look for revert reason and bubble it up if present
328         if (returndata.length > 0) {
329             // The easiest way to bubble the revert reason is using memory via assembly
330             /// @solidity memory-safe-assembly
331             assembly {
332                 let returndata_size := mload(returndata)
333                 revert(add(32, returndata), returndata_size)
334             }
335         } else {
336             revert(errorMessage);
337         }
338     }
339 }
340 
341 library SafeERC20 {
342     using Address for address;
343 
344     function safeTransfer(
345         IERC20 token,
346         address to,
347         uint256 value
348     ) internal {
349         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
350     }
351 
352     function safeTransferFrom(
353         IERC20 token,
354         address from,
355         address to,
356         uint256 value
357     ) internal {
358         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
359     }
360 
361     function safeApprove(
362         IERC20 token,
363         address spender,
364         uint256 value
365     ) internal {
366         // safeApprove should only be called when setting an initial allowance,
367         // or when resetting it to zero. To increase and decrease it, use
368         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
369         require(
370             (value == 0) || (token.allowance(address(this), spender) == 0),
371             "SafeERC20: approve from non-zero to non-zero allowance"
372         );
373         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
374     }
375 
376     function safeIncreaseAllowance(
377         IERC20 token,
378         address spender,
379         uint256 value
380     ) internal {
381         uint256 newAllowance = token.allowance(address(this), spender) + value;
382         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
383     }
384 
385     function safeDecreaseAllowance(
386         IERC20 token,
387         address spender,
388         uint256 value
389     ) internal {
390         unchecked {
391             uint256 oldAllowance = token.allowance(address(this), spender);
392             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
393             uint256 newAllowance = oldAllowance - value;
394             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
395         }
396     }
397 
398     function safePermit(
399         IERC20Permit token,
400         address owner,
401         address spender,
402         uint256 value,
403         uint256 deadline,
404         uint8 v,
405         bytes32 r,
406         bytes32 s
407     ) internal {
408         uint256 nonceBefore = token.nonces(owner);
409         token.permit(owner, spender, value, deadline, v, r, s);
410         uint256 nonceAfter = token.nonces(owner);
411         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
412     }
413 
414     function _callOptionalReturn(IERC20 token, bytes memory data) private {
415         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
416         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
417         // the target address contains contract code and also asserts for success in the low-level call.
418 
419         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
420         if (returndata.length > 0) {
421             // Return data is optional
422             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
423         }
424     }
425 }
426 
427 contract Context {
428     // Empty internal constructor, to prevent people from mistakenly deploying
429     // an instance of this contract, which should be used via inheritance.
430 
431     function _msgSender() internal view returns (address) {
432         return msg.sender;
433     }
434 
435     function _msgData() internal view returns (bytes memory) {
436         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
437         return msg.data;
438     }
439 }
440 
441 contract Ownable is Context {
442     address private _owner;
443 
444     event OwnershipTransferred(
445         address indexed previousOwner,
446         address indexed newOwner
447     );
448 
449     /**
450      * @dev Initializes the contract setting the deployer as the initial owner.
451      */
452     constructor() {
453         address msgSender = _msgSender();
454         _owner = msgSender;
455         emit OwnershipTransferred(address(0), msgSender);
456     }
457 
458     /**
459      * @dev Returns the address of the current owner.
460      */
461     function owner() public view returns (address) {
462         return _owner;
463     }
464 
465     /**
466      * @dev Throws if called by any account other than the owner.
467      */
468     modifier onlyOwner() {
469         require(_owner == _msgSender(), "Ownable: caller is not the owner");
470         _;
471     }
472 
473     /**
474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
475      * Can only be called by the current owner.
476      */
477     function transferOwnership(address newOwner) public onlyOwner {
478         _transferOwnership(newOwner);
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      */
484     function _transferOwnership(address newOwner) internal {
485         require(
486             newOwner != address(0),
487             "Ownable: new owner is the zero address"
488         );
489         emit OwnershipTransferred(_owner, newOwner);
490         _owner = newOwner;
491     }
492 }
493 
494 interface AggregatorInterface {
495   function latestAnswer() external view returns (uint256);
496 }
497 
498 contract AnarchyPresale is Ownable {
499     using SafeERC20 for IERC20;
500     using SafeMath for uint256;
501 
502     AggregatorInterface public constant ethUsdData = AggregatorInterface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
503     AggregatorInterface public constant bnbUsdData = AggregatorInterface(0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);
504 
505     event Buy(address indexed _account, uint256 _tokenAmount, uint256 _phase);
506     event BuyWithBnb(address indexed _account, uint256 _tokenAmount, uint256 _nonce,uint256 _phase);
507 
508     
509     struct Phase {
510         uint256 roundId;
511         uint256 maxTokens;
512         uint256 tokensSold;
513         uint256 fundsRaisedEth;
514         uint256 fundsRaisedUsdt;
515         uint256 fundsRaisedBnb;
516         uint256 tokenPriceInUsd;
517         uint256 claimStart;
518     }
519 
520     struct AddPhase {
521         uint256 roundId;
522         uint256 maxTokens;
523         uint256 tokenPriceInUsd;
524         uint256 claimStart;
525     }
526 
527     struct ClaimableAmount {
528         uint256 roundId;
529         address account;
530         uint256 tokenAmount;
531     }
532 
533     mapping (uint256 => Phase) public phase;
534     mapping (address => mapping(uint256 =>  uint256)) public deservedAmount;
535     mapping (address => mapping(uint256 =>  uint256)) public claimedAmount;
536     mapping(uint256 => bool) public isSold;
537 
538 
539     address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
540     address public constant BNB = 0xB8c77482e45F1F44dE1745F52C74426C631bDD52;
541     
542     bool public isWhitelistPresale;
543     address public bnbAdministrator;
544 
545     address public tokenAddress;
546     uint256 private tokenWithDecimals = 1e18; 
547 
548     IRouter public router;
549     address private WETH;
550     uint256 public activePhase = 1;
551     bool public isAutoMovePhase = true;
552     uint256 public discountRate = 10;
553     bool public isClaimableActive;
554 
555     modifier onlyBnbAdministrator() {
556         require(owner() == _msgSender() || bnbAdministrator == _msgSender(), "Ownable: caller is not the owner or administrator");
557         require(phase[activePhase].maxTokens > 0,"Phase is not active or presale ended");
558         _;
559     }
560 
561 
562     function addPhases(AddPhase[] calldata _addPhase) external onlyOwner {
563         for(uint256 i = 0; i < _addPhase.length ; i++) {
564             phase[_addPhase[i].roundId].roundId = _addPhase[i].roundId;
565             phase[_addPhase[i].roundId].maxTokens = _addPhase[i].maxTokens;
566             phase[_addPhase[i].roundId].tokenPriceInUsd = _addPhase[i].tokenPriceInUsd;
567             phase[_addPhase[i].roundId].claimStart = _addPhase[i].claimStart;
568         }
569     }
570 
571     function getPhases(uint256[] calldata _roundId) public view returns(Phase[] memory){
572         Phase[] memory _phase = new Phase[](_roundId.length);
573         for(uint256 i = 0 ; i < _roundId.length ; i++) {
574             _phase[i] = phase[_roundId[i]];
575         }
576         return _phase;
577     }
578 
579 
580     function updatePhaseClaimTime(uint256 _roundId, uint256 _startTime)external onlyOwner{
581             phase[_roundId].claimStart = _startTime;
582 
583     }
584     function setActivePhase(uint256 _roundId, bool _isAutoPhase) external onlyOwner {
585         activePhase = _roundId;
586         isAutoMovePhase = _isAutoPhase;
587     }
588 
589     function currentTimestamp() public view returns(uint256) {
590         return block.timestamp;
591     }
592 
593     function buyTokensWithEth() public payable {
594         require(phase[activePhase].maxTokens > 0,"Phase is not active");
595         require(msg.value > 0, "Must send ETH to get tokens");
596         uint256 ethAmount = msg.value;
597         uint256 tokenAmount = estimatedToken(ethAmount);
598         bool isReachMaxAmount;
599         if(!(phase[activePhase].maxTokens > tokenAmount + phase[activePhase].tokensSold) && isAutoMovePhase){
600             uint256 tokenAmount2 = phase[activePhase].maxTokens - phase[activePhase].tokensSold;
601             
602             uint newEthAmount = ethAmount.mul(tokenAmount2).div(tokenAmount);
603             uint256 returnAmount = ethAmount.sub(newEthAmount);
604             returnEth(msg.sender, returnAmount);
605             ethAmount = newEthAmount;
606             tokenAmount = tokenAmount2;
607             isReachMaxAmount = true;
608 
609         }
610 
611         phase[activePhase].tokensSold += tokenAmount;
612         phase[activePhase].fundsRaisedEth += ethAmount;
613         deservedAmount[msg.sender][activePhase] += tokenAmount;
614         emit Buy(msg.sender, tokenAmount, activePhase);
615         if(isReachMaxAmount){
616             activePhase++;
617         }
618     }
619 
620     function buyTokensWithUsdt(uint256 _tokenAmount) public {
621         require(phase[activePhase].maxTokens > 0,"Phase is not active");
622         require(_tokenAmount > 0, "Must send USDT to get tokens");
623         bool isReachMaxAmount;
624 
625         IERC20(USDT).safeTransferFrom(msg.sender, address(this), _tokenAmount);
626 
627         uint256 tokenPriceInUsd = getCurrentTokenPrice();
628 
629         uint256 tokenAmount = _tokenAmount.mul(tokenWithDecimals).div(tokenPriceInUsd);
630 
631         if(!(phase[activePhase].maxTokens > tokenAmount + phase[activePhase].tokensSold) && isAutoMovePhase){
632             uint256 tokenAmount2 = phase[activePhase].maxTokens - phase[activePhase].tokensSold;
633             uint256 returnAmount = _tokenAmount.sub(_tokenAmount.mul(tokenAmount2).div(tokenAmount));
634             IERC20(USDT).safeTransfer(msg.sender, returnAmount);
635 
636             tokenAmount = tokenAmount2;
637             isReachMaxAmount = true;
638         }
639 
640         phase[activePhase].tokensSold += tokenAmount;
641         phase[activePhase].fundsRaisedUsdt += _tokenAmount;
642         deservedAmount[msg.sender][activePhase] += tokenAmount;
643         emit Buy(msg.sender, tokenAmount, activePhase);
644 
645 
646         if(isReachMaxAmount){
647             activePhase++;
648         } 
649     }
650 
651     function setClaimableAmount(ClaimableAmount[] calldata _claimableAmounts ) external onlyOwner {
652         for(uint256 i = 0 ; i < _claimableAmounts.length; i ++){
653             deservedAmount[_claimableAmounts[i].account][_claimableAmounts[i].roundId] = _claimableAmounts[i].tokenAmount;
654         }
655     }
656 
657     function buyWithBnbChain(address _account, uint256 _tokenAmount, uint256 _nonce) public onlyBnbAdministrator {
658         require(phase[activePhase].maxTokens > 0,"Phase is not active");
659         require(_tokenAmount > 0);
660         require(!isSold[_nonce],"Already sended token");
661         if(!(phase[activePhase].maxTokens > _tokenAmount + phase[activePhase].tokensSold) && isAutoMovePhase ){
662             uint256 _latestPhaseTokenAmount = phase[activePhase].maxTokens - phase[activePhase].tokensSold;
663             uint256 _remainingTokenAmount = _tokenAmount - _latestPhaseTokenAmount;
664             uint256 _finalPhaseTokenAmount = (phase[activePhase].tokenPriceInUsd.mul(_remainingTokenAmount)).div(phase[activePhase + 1].tokenPriceInUsd);
665             phase[activePhase].tokensSold += _latestPhaseTokenAmount;
666             deservedAmount[_account][activePhase] += _latestPhaseTokenAmount;
667 
668             emit Buy(_account, _latestPhaseTokenAmount, activePhase);
669 
670             activePhase++;
671 
672             phase[activePhase].tokensSold += _finalPhaseTokenAmount;
673             deservedAmount[_account][activePhase] += _finalPhaseTokenAmount;
674 
675             emit Buy(_account, _finalPhaseTokenAmount, activePhase);
676             isSold[_nonce] = true;
677 
678 
679         }else{
680             phase[activePhase].tokensSold += _tokenAmount;
681             deservedAmount[_account][activePhase] += _tokenAmount;
682 
683             emit BuyWithBnb(_account, _tokenAmount,_nonce, activePhase);
684             isSold[_nonce] = true;
685         }
686 
687 
688     }
689 
690     function claim(uint256 _currentPhase) external {
691         require(isClaimableActive, "Claimable is not active yet");
692         require(phase[_currentPhase].maxTokens > 0,"Phase is not active");
693         require(block.timestamp > phase[_currentPhase].claimStart , "Claiming Not Started Yet" );
694         uint256 claimableReward = deservedAmount[msg.sender][_currentPhase] - claimedAmount[msg.sender][_currentPhase];
695         require(claimableReward > 0, "There is no reward" );
696         claimedAmount[msg.sender][_currentPhase] = deservedAmount[msg.sender][_currentPhase];
697         IERC20(tokenAddress).safeTransfer(msg.sender, claimableReward);
698     }
699 
700     function claimAll(uint256[] calldata _phases) external {
701         require(isClaimableActive, "Claimable is not active yet");
702         uint256 claimableReward;
703         for(uint256 i = 0 ; i < _phases.length ; i++) {
704             require(phase[_phases[i]].maxTokens > 0,"Phase is not active");
705             require(block.timestamp > phase[_phases[i]].claimStart , "Claiming Not Started Yet" );
706             claimableReward += deservedAmount[msg.sender][_phases[i]] - claimedAmount[msg.sender][_phases[i]];
707             claimedAmount[msg.sender][_phases[i]] = deservedAmount[msg.sender][_phases[i]];
708         }
709         require(claimableReward > 0, "There is no reward" );
710         IERC20(tokenAddress).safeTransfer(msg.sender, claimableReward);
711     }
712 
713     function claimableAmount(address _account,uint256[] calldata _phases) public view returns(uint256) {
714         uint256 claimableReward;
715         for(uint256 i = 0 ; i < _phases.length ; i++) {
716             claimableReward += deservedAmount[_account][_phases[i]] - claimedAmount[_account][_phases[i]];
717         }
718         return claimableReward;
719     }
720 
721     
722 
723      function usdToEth(uint256 _amount) public view returns(uint256) {
724         address[] memory path = new address[](2);
725 
726         path[0] = WETH;
727         path[1] = USDT;
728         uint256[] memory amounts = router.getAmountsIn(_amount,path);
729         return amounts[0];
730     }
731 
732     
733     // owner can withdraw ETH after people get tokens
734     function withdrawETH(uint256 _ethAmount) external onlyOwner {
735 
736         ( bool success,) = owner().call{value: _ethAmount}("");
737         require(success, "Withdrawal was not successful");
738     }
739 
740     function returnEth(address _account, uint256 _amount) internal {
741         ( bool success,) = _account.call{value: _amount}("");
742         require(success, "Withdrawal was not successful");
743     }
744 
745     function withdrawToken(address _tokenAddress,uint256 _amount) external onlyOwner {
746         IERC20(_tokenAddress).safeTransfer(owner(),_amount);
747     }
748 
749     function getEthPrice() public view returns(uint256) {
750         return ethUsdData.latestAnswer();
751     } 
752 
753     function getBnbPrice() public view returns(uint256) {
754         return bnbUsdData.latestAnswer();
755     } 
756 
757     function getEthToUsd(uint256 _ethAmount) public view returns(uint256){
758         return _ethAmount.mul(getEthPrice()).div(1e18); 
759     }
760 
761     function getBnbToUsd(uint256 _bnbAmount) public view returns(uint256){
762         return _bnbAmount.mul(getBnbPrice()).div(1e18); 
763     }
764 
765     function estimatedToken (uint256 _weiAmount) public view returns (uint256) {
766         uint256 tokenPriceInUsd =getCurrentTokenPrice();
767         uint256 tokensPerEth = usdToEth(tokenPriceInUsd);
768         return (_weiAmount / tokensPerEth) * tokenWithDecimals;
769 
770     }
771 
772     function getEstimatedTokenAmount(uint256 _bnbAmount,uint256 _tokenPriceInUsd) public view returns(uint256) {
773         return getBnbToUsd(_bnbAmount).mul(tokenWithDecimals).div(100).div(_tokenPriceInUsd);
774     }
775 
776     function getEstimatedUsdtTokenAmount(uint256 _usdtAmount,uint256 _tokenPriceInUsd) public view returns(uint256) {
777         return _usdtAmount.mul(tokenWithDecimals).div(_tokenPriceInUsd);
778     }
779 
780     function _swapToUsdt(uint256 _weiAmount) internal {
781         address[] memory path = new address[](2);
782         path[0] = WETH;
783         path[1] = USDT;
784 
785 
786         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : _weiAmount}(
787             0,
788             path,
789             address(this),
790             block.timestamp
791         );
792     }
793 
794     function getCurrentTokenPrice() public view returns(uint256) {
795         uint256 tokenPriceInUsd = phase[activePhase].tokenPriceInUsd;
796         if(isWhitelistPresale){
797             tokenPriceInUsd = tokenPriceInUsd * (100 - discountRate) / 100;
798         }
799         return tokenPriceInUsd;
800     }
801 
802     constructor(address _router, address _bnbAdministrator) {        
803         router = IRouter(_router);
804         WETH = router.WETH();
805         bnbAdministrator = _bnbAdministrator;
806     }
807 
808     function transferBnbAdministrator( address _newAddress) external onlyOwner {
809         bnbAdministrator = _newAddress;
810     }
811     
812     function setToken(address _token) external onlyOwner {
813         tokenAddress = _token;
814     }
815 
816     function claimableStatus(bool _flag) external onlyOwner{
817         isClaimableActive = _flag;
818     }
819     
820     receive() external payable {
821         buyTokensWithEth();
822     }
823     
824     function setWhiteListPresale(bool _flag) external onlyOwner {
825         isWhitelistPresale = _flag;
826     }
827     
828 
829    
830 }