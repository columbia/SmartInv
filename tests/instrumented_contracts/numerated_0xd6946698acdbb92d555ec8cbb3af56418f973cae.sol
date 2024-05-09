1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-16
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.15;
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address recipient, uint256 amount)
14         external
15         returns (bool);
16 
17     function allowance(address owner, address spender)
18         external
19         view
20         returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(
25         address sender,
26         address recipient,
27         uint256 amount
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 
37     function mint(uint256 amount) external returns (bool);
38 
39     function burn(uint256 amount) external returns (bool);
40 }
41 
42 interface IERC20Permit {
43 
44     function permit(
45         address owner,
46         address spender,
47         uint256 value,
48         uint256 deadline,
49         uint8 v,
50         bytes32 r,
51         bytes32 s
52     ) external;
53 
54     function nonces(address owner) external view returns (uint256);
55 
56     function DOMAIN_SEPARATOR() external view returns (bytes32);
57 }
58 
59 interface IRouter {
60     function factory() external pure returns (address);
61 
62     function WETH() external pure returns (address);
63 
64     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
65         uint amountIn,
66         uint amountOutMin,
67         address[] calldata path,
68         address to,
69         uint deadline
70     ) external;
71 
72     function addLiquidityETH(
73         address token,
74         uint256 amountTokenDesired,
75         uint256 amountTokenMin,
76         uint256 amountETHMin,
77         address to,
78         uint256 deadline
79     )
80         external
81         payable
82         returns (
83             uint256 amountToken,
84             uint256 amountETH,
85             uint256 liquidity
86         );
87 
88     function swapExactTokensForETHSupportingFeeOnTransferTokens(
89         uint256 amountIn,
90         uint256 amountOutMin,
91         address[] calldata path,
92         address to,
93         uint256 deadline
94     ) external;
95 
96     function addLiquidity(
97         address tokenA,
98         address tokenB,
99         uint256 amountADesired,
100         uint256 amountBDesired,
101         uint256 amountAMin,
102         uint256 amountBMin,
103         address to,
104         uint256 deadline
105     )
106         external
107         returns (
108             uint256 amountA,
109             uint256 amountB,
110             uint256 liquidity
111         );
112 
113     function swapExactETHForTokensSupportingFeeOnTransferTokens(
114         uint256 amountOutMin,
115         address[] calldata path,
116         address to,
117         uint256 deadline
118     ) external payable;
119 
120     function getAmountsOut(
121         uint amountIn, 
122         address[] memory path
123         ) external view returns (uint[] memory amounts);
124     
125     function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
126 
127 }
128 
129 library SafeMath {
130     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             uint256 c = a + b;
133             if (c < a) return (false, 0);
134             return (true, c);
135         }
136     }
137 
138     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             if (b > a) return (false, 0);
141             return (true, a - b);
142         }
143     }
144 
145     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148             // benefit is lost if 'b' is also tested.
149             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150             if (a == 0) return (true, 0);
151             uint256 c = a * b;
152             if (c / a != b) return (false, 0);
153             return (true, c);
154         }
155     }
156 
157     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             if (b == 0) return (false, 0);
160             return (true, a / b);
161         }
162     }
163 
164     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         unchecked {
166             if (b == 0) return (false, 0);
167             return (true, a % b);
168         }
169     }
170 
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a + b;
173     }
174 
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a - b;
177     }
178 
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a * b;
181     }
182 
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a / b;
185     }
186 
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a % b;
189     }
190 
191     function sub(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b <= a, errorMessage);
198             return a - b;
199         }
200     }
201 
202     function div(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         unchecked {
208             require(b > 0, errorMessage);
209             return a / b;
210         }
211     }
212 
213     function mod(
214         uint256 a,
215         uint256 b,
216         string memory errorMessage
217     ) internal pure returns (uint256) {
218         unchecked {
219             require(b > 0, errorMessage);
220             return a % b;
221         }
222     }
223 }
224 
225 library Address {
226 
227     function isContract(address account) internal view returns (bool) {
228         // This method relies on extcodesize/address.code.length, which returns 0
229         // for contracts in construction, since the code is only stored at the end
230         // of the constructor execution.
231 
232         return account.code.length > 0;
233     }
234 
235     function sendValue(address payable recipient, uint256 amount) internal {
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         require(success, "Address: unable to send value, recipient may have reverted");
240     }
241 
242     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
244     }
245 
246     function functionCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
260     }
261 
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(address(this).balance >= value, "Address: insufficient balance for call");
269         (bool success, bytes memory returndata) = target.call{value: value}(data);
270         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
271     }
272 
273     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
274         return functionStaticCall(target, data, "Address: low-level static call failed");
275     }
276 
277     function functionStaticCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal view returns (bytes memory) {
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
284     }
285 
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         (bool success, bytes memory returndata) = target.delegatecall(data);
296         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
297     }
298 
299     function verifyCallResultFromTarget(
300         address target,
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal view returns (bytes memory) {
305         if (success) {
306             if (returndata.length == 0) {
307                 // only check isContract if the call was successful and the return data is empty
308                 // otherwise we already know that it was a contract
309                 require(isContract(target), "Address: call to non-contract");
310             }
311             return returndata;
312         } else {
313             _revert(returndata, errorMessage);
314         }
315     }
316 
317     function verifyCallResult(
318         bool success,
319         bytes memory returndata,
320         string memory errorMessage
321     ) internal pure returns (bytes memory) {
322         if (success) {
323             return returndata;
324         } else {
325             _revert(returndata, errorMessage);
326         }
327 
328     }
329 
330     function _revert(bytes memory returndata, string memory errorMessage) private pure {
331         // Look for revert reason and bubble it up if present
332         if (returndata.length > 0) {
333             // The easiest way to bubble the revert reason is using memory via assembly
334             /// @solidity memory-safe-assembly
335             assembly {
336                 let returndata_size := mload(returndata)
337                 revert(add(32, returndata), returndata_size)
338             }
339         } else {
340             revert(errorMessage);
341         }
342     }
343 }
344 
345 library SafeERC20 {
346     using Address for address;
347 
348     function safeTransfer(
349         IERC20 token,
350         address to,
351         uint256 value
352     ) internal {
353         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
354     }
355 
356     function safeTransferFrom(
357         IERC20 token,
358         address from,
359         address to,
360         uint256 value
361     ) internal {
362         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
363     }
364 
365     function safeApprove(
366         IERC20 token,
367         address spender,
368         uint256 value
369     ) internal {
370         // safeApprove should only be called when setting an initial allowance,
371         // or when resetting it to zero. To increase and decrease it, use
372         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
373         require(
374             (value == 0) || (token.allowance(address(this), spender) == 0),
375             "SafeERC20: approve from non-zero to non-zero allowance"
376         );
377         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
378     }
379 
380     function safeIncreaseAllowance(
381         IERC20 token,
382         address spender,
383         uint256 value
384     ) internal {
385         uint256 newAllowance = token.allowance(address(this), spender) + value;
386         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
387     }
388 
389     function safeDecreaseAllowance(
390         IERC20 token,
391         address spender,
392         uint256 value
393     ) internal {
394         unchecked {
395             uint256 oldAllowance = token.allowance(address(this), spender);
396             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
397             uint256 newAllowance = oldAllowance - value;
398             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
399         }
400     }
401 
402     function safePermit(
403         IERC20Permit token,
404         address owner,
405         address spender,
406         uint256 value,
407         uint256 deadline,
408         uint8 v,
409         bytes32 r,
410         bytes32 s
411     ) internal {
412         uint256 nonceBefore = token.nonces(owner);
413         token.permit(owner, spender, value, deadline, v, r, s);
414         uint256 nonceAfter = token.nonces(owner);
415         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
416     }
417 
418     function _callOptionalReturn(IERC20 token, bytes memory data) private {
419         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
420         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
421         // the target address contains contract code and also asserts for success in the low-level call.
422 
423         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
424         if (returndata.length > 0) {
425             // Return data is optional
426             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
427         }
428     }
429 }
430 
431 contract Context {
432     // Empty internal constructor, to prevent people from mistakenly deploying
433     // an instance of this contract, which should be used via inheritance.
434 
435     function _msgSender() internal view returns (address) {
436         return msg.sender;
437     }
438 
439     function _msgData() internal view returns (bytes memory) {
440         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
441         return msg.data;
442     }
443 }
444 
445 contract Ownable is Context {
446     address private _owner;
447 
448     event OwnershipTransferred(
449         address indexed previousOwner,
450         address indexed newOwner
451     );
452 
453     /**
454      * @dev Initializes the contract setting the deployer as the initial owner.
455      */
456     constructor() {
457         address msgSender = _msgSender();
458         _owner = msgSender;
459         emit OwnershipTransferred(address(0), msgSender);
460     }
461 
462     /**
463      * @dev Returns the address of the current owner.
464      */
465     function owner() public view returns (address) {
466         return _owner;
467     }
468 
469     /**
470      * @dev Throws if called by any account other than the owner.
471      */
472     modifier onlyOwner() {
473         require(_owner == _msgSender(), "Ownable: caller is not the owner");
474         _;
475     }
476 
477     /**
478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
479      * Can only be called by the current owner.
480      */
481     function transferOwnership(address newOwner) public onlyOwner {
482         _transferOwnership(newOwner);
483     }
484 
485     /**
486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
487      */
488     function _transferOwnership(address newOwner) internal {
489         require(
490             newOwner != address(0),
491             "Ownable: new owner is the zero address"
492         );
493         emit OwnershipTransferred(_owner, newOwner);
494         _owner = newOwner;
495     }
496 }
497 
498 contract PikamoonPresale is Ownable {
499     using SafeERC20 for IERC20;
500     using SafeMath for uint256;
501 
502     
503     struct Phase {
504         uint256 roundId;
505         uint256 maxTokens;
506         uint256 tokensSold;
507         uint256 fundsRaisedEth;
508         uint256 tokenPriceInUsd; // usdt decimals 6
509         uint256 claimStart;
510         bool saleStatus;
511     }
512 
513     struct AddPhase {
514         uint256 roundId;
515         uint256 maxTokens;
516         uint256 tokenPriceInUsd;
517         uint256 claimStart;
518     }
519 
520     mapping (uint256 => Phase) public phase;
521     mapping (address => mapping(uint256 =>  uint256)) public deservedAmount;
522     mapping (address => mapping(uint256 =>  uint256)) public claimedAmount;
523     mapping (address => mapping(uint256 =>  uint256)) public depositEth;
524     
525     address constant marketingWallet = 0x9ba08d159EF661cE0F39E5B36249f1dbDa653bA8;
526     uint256 constant partnershipEthAmount = 25 * 1e18;
527     uint256 public marketingClaimedEth;
528 
529     bool public isWhitelistPresale = true;
530 
531     address public tokenAddress;
532     address public USDT;
533     IRouter public router;
534     address private WETH;
535     uint256 public activePhase = 1;
536     uint256 public discountRate = 10;
537 
538     function addPhases(AddPhase[] calldata _addPhase) external onlyOwner {
539         for(uint256 i = 0; i < _addPhase.length ; i++) {
540             phase[_addPhase[i].roundId].roundId = _addPhase[i].roundId;
541             phase[_addPhase[i].roundId].maxTokens = _addPhase[i].maxTokens;
542             phase[_addPhase[i].roundId].tokenPriceInUsd = _addPhase[i].tokenPriceInUsd;
543             phase[_addPhase[i].roundId].claimStart = _addPhase[i].claimStart;
544         }
545     }
546 
547     function getPhases(uint256[] calldata _roundId) public view returns(Phase[] memory){
548         Phase[] memory _phase = new Phase[](_roundId.length);
549         for(uint256 i = 0 ; i < _roundId.length ; i++) {
550             _phase[i] = phase[_roundId[i]];
551         }
552         return _phase;
553     }
554 
555     function updatePhaseClaimTime(uint256 _roundId, uint256 _startTime)external onlyOwner{
556             phase[_roundId].claimStart = _startTime;
557 
558     }
559     function setActivePhase(uint256 _roundId) external onlyOwner {
560         activePhase = _roundId;
561     }
562 
563     function currentTimestamp() public view returns(uint256) {
564         return block.timestamp;
565     }
566 
567     function buyTokensEth() payable public {
568         require(phase[activePhase].maxTokens > 0,"Phase is not active");
569         require(msg.value > 0, "Must send ETH to get tokens");
570 
571         uint256 tokenAmount = estimatedToken(msg.value);
572 
573         require(phase[activePhase].maxTokens > tokenAmount + phase[activePhase].tokensSold,"Exceeds the maximum number of tokens");      
574 
575         phase[activePhase].tokensSold += tokenAmount;
576         phase[activePhase].fundsRaisedEth += msg.value;
577         deservedAmount[msg.sender][activePhase] += tokenAmount;
578         depositEth[msg.sender][activePhase] += msg.value;
579     }
580 
581     function claim(uint256 _currentPhase) external {
582         require(phase[_currentPhase].maxTokens > 0,"Phase is not active");
583         require(block.timestamp > phase[_currentPhase].claimStart , "Claiming Not Started Yet" );
584         uint256 claimableReward = deservedAmount[msg.sender][_currentPhase] - claimedAmount[msg.sender][_currentPhase];
585         require(claimableReward > 0, "There is no reward" );
586         claimedAmount[msg.sender][_currentPhase] = deservedAmount[msg.sender][_currentPhase];
587         IERC20(tokenAddress).safeTransfer(msg.sender, claimableReward);
588     }
589 
590     function claimAll(uint256[] calldata _phases) external {
591         uint256 claimableReward;
592         for(uint256 i = 0 ; i < _phases.length ; i++) {
593             require(phase[_phases[i]].maxTokens > 0,"Phase is not active");
594             require(block.timestamp > phase[_phases[i]].claimStart , "Claiming Not Started Yet" );
595             claimableReward += deservedAmount[msg.sender][_phases[i]] - claimedAmount[msg.sender][_phases[i]];
596             claimedAmount[msg.sender][_phases[i]] = deservedAmount[msg.sender][_phases[i]];
597         }
598         require(claimableReward > 0, "There is no reward" );
599         IERC20(tokenAddress).safeTransfer(msg.sender, claimableReward);
600     }
601 
602     function estimatedToken (uint256 _weiAmount) public view returns (uint256) {
603         uint256 tokenPriceInUsd = phase[activePhase].tokenPriceInUsd;
604         if(isWhitelistPresale){
605             tokenPriceInUsd = tokenPriceInUsd * (100 - discountRate) / 100;
606         }
607         uint256 tokensPerEth = usdToEth(tokenPriceInUsd);
608 
609         return (_weiAmount / tokensPerEth) * 1e9;
610 
611     }
612 
613     constructor(address _router,address _USDT) {        
614         USDT = _USDT;
615         router = IRouter(_router);
616         WETH = router.WETH();
617     }
618 
619     function setToken(address _token) external onlyOwner {
620         tokenAddress = _token;
621     }
622     
623     receive() external payable {
624         buyTokensEth();
625     }
626     
627     function setWhiteListPresale(bool _flag) external onlyOwner {
628         isWhitelistPresale = _flag;
629     }
630     
631     // only use in case of emergency or after presale is over
632     function withdrawTokens() external onlyOwner {
633         IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));
634     }
635 
636 
637     function usdToEth(uint256 _amount) public view returns(uint256) {
638         address[] memory path = new address[](2);
639 
640         path[0] = WETH;
641         path[1] = USDT;
642         uint256[] memory amounts = router.getAmountsIn(_amount,path);
643         return amounts[0];
644     }
645     
646     // owner can withdraw ETH after people get tokens
647     function withdrawETH() external onlyOwner {
648         uint256 ethBalance = address(this).balance;
649         uint256 marketingAmount;
650 
651         if(marketingClaimedEth < partnershipEthAmount){
652             marketingAmount = ethBalance.mul(25).div(100);
653         }else {
654             marketingAmount = ethBalance.mul(3).div(100);
655         }
656         
657         (bool success,) = marketingWallet.call{value: marketingAmount}("");
658         require(success, "Withdrawal was not successful");
659 
660         (success,) = owner().call{value: ethBalance.sub(marketingAmount)}("");
661         require(success, "Withdrawal was not successful");
662         marketingClaimedEth += marketingAmount;
663     }
664 
665     function getStuckToken(address _tokenAddress) external onlyOwner {
666         uint256 tokenBalance = IERC20(_tokenAddress).balanceOf(address(this));
667         uint256 marketingAmount = tokenBalance.mul(25).div(100);
668         IERC20(_tokenAddress).safeTransfer(marketingWallet,marketingAmount);
669         IERC20(_tokenAddress).safeTransfer(owner(),tokenBalance.sub(marketingAmount));
670     }
671 }