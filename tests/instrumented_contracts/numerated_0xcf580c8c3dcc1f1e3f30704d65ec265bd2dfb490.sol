1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * SAFEMATH LIBRARY
6  */
7 library SafeMath {
8     
9     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
10         unchecked {
11             uint256 c = a + b;
12             if (c < a) return (false, 0);
13             return (true, c);
14         }
15     }
16 
17     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             if (b > a) return (false, 0);
20             return (true, a - b);
21         }
22     }
23 
24     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27             // benefit is lost if 'b' is also tested.
28             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
29             if (a == 0) return (true, 0);
30             uint256 c = a * b;
31             if (c / a != b) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b == 0) return (false, 0);
39             return (true, a / b);
40         }
41     }
42 
43     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b == 0) return (false, 0);
46             return (true, a % b);
47         }
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a + b;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a - b;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a * b;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a / b;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a % b;
68     }
69 
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         unchecked {
72             require(b <= a, errorMessage);
73             return a - b;
74         }
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         unchecked {
79             require(b > 0, errorMessage);
80             return a / b;
81         }
82     }
83 
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         unchecked {
86             require(b > 0, errorMessage);
87             return a % b;
88         }
89     }
90 }
91 
92 /**
93  * @dev Interface of the ERC20 standard as defined in the EIP.
94  */
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     function decimals() external view returns (uint8);
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through {transferFrom}. This is
119      * zero by default.
120      *
121      * This value changes when {approve} or {transferFrom} are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * IMPORTANT: Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) external returns (bool);
155 
156     /**
157      * @dev Emitted when `value` tokens are moved from one account (`from`) to
158      * another (`to`).
159      *
160      * Note that `value` may be zero.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     /**
165      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
166      * a call to {approve}. `value` is the new allowance.
167      */
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 /**
172  * @dev Collection of functions related to the address type
173  */
174 library Address {
175     /**
176      * @dev Returns true if `account` is a contract.
177      *
178      * [IMPORTANT]
179      * ====
180      * It is unsafe to assume that an address for which this function returns
181      * false is an externally-owned account (EOA) and not a contract.
182      *
183      * Among others, `isContract` will return false for the following
184      * types of addresses:
185      *
186      *  - an externally-owned account
187      *  - a contract in construction
188      *  - an address where a contract will be created
189      *  - an address where a contract lived, but was destroyed
190      * ====
191      */
192     function isContract(address account) internal view returns (bool) {
193         // This method relies on extcodesize, which returns 0 for contracts in
194         // construction, since the code is only stored at the end of the
195         // constructor execution.
196 
197         uint256 size;
198         assembly {
199             size := extcodesize(account)
200         }
201         return size > 0;
202     }
203 
204     /**
205      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
206      * `recipient`, forwarding all available gas and reverting on errors.
207      *
208      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
209      * of certain opcodes, possibly making contracts go over the 2300 gas limit
210      * imposed by `transfer`, making them unable to receive funds via
211      * `transfer`. {sendValue} removes this limitation.
212      *
213      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
214      *
215      * IMPORTANT: because control is transferred to `recipient`, care must be
216      * taken to not create reentrancy vulnerabilities. Consider using
217      * {ReentrancyGuard} or the
218      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
219      */
220     function sendValue(address payable recipient, uint256 amount) internal {
221         require(address(this).balance >= amount, "Address: insufficient balance");
222 
223         (bool success, ) = recipient.call{value: amount}("");
224         require(success, "Address: unable to send value, recipient may have reverted");
225     }
226 
227     /**
228      * @dev Performs a Solidity function call using a low level `call`. A
229      * plain `call` is an unsafe replacement for a function call: use this
230      * function instead.
231      *
232      * If `target` reverts with a revert reason, it is bubbled up by this
233      * function (like regular Solidity function calls).
234      *
235      * Returns the raw returned data. To convert to the expected return value,
236      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
237      *
238      * Requirements:
239      *
240      * - `target` must be a contract.
241      * - calling `target` with `data` must not revert.
242      *
243      * _Available since v3.1._
244      */
245     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionCall(target, data, "Address: low-level call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
251      * `errorMessage` as a fallback revert reason when `target` reverts.
252      *
253      * _Available since v3.1._
254      */
255     function functionCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         return functionCallWithValue(target, data, 0, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but also transferring `value` wei to `target`.
266      *
267      * Requirements:
268      *
269      * - the calling contract must have an ETH balance of at least `value`.
270      * - the called Solidity function must be `payable`.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value
278     ) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
284      * with `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCallWithValue(
289         address target,
290         bytes memory data,
291         uint256 value,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         require(address(this).balance >= value, "Address: insufficient balance for call");
295         require(isContract(target), "Address: call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.call{value: value}(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a static call.
304      *
305      * _Available since v3.3._
306      */
307     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
308         return functionStaticCall(target, data, "Address: low-level static call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a static call.
314      *
315      * _Available since v3.3._
316      */
317     function functionStaticCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal view returns (bytes memory) {
322         require(isContract(target), "Address: static call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.staticcall(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a delegate call.
331      *
332      * _Available since v3.4._
333      */
334     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a delegate call.
341      *
342      * _Available since v3.4._
343      */
344     function functionDelegateCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         require(isContract(target), "Address: delegate call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.delegatecall(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
357      * revert reason using the provided one.
358      *
359      * _Available since v4.3._
360      */
361     function verifyCallResult(
362         bool success,
363         bytes memory returndata,
364         string memory errorMessage
365     ) internal pure returns (bytes memory) {
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 /**
385  * @title SafeERC20
386  * @dev Wrappers around ERC20 operations that throw on failure (when the token
387  * contract returns false). Tokens that return no value (and instead revert or
388  * throw on failure) are also supported, non-reverting calls are assumed to be
389  * successful.
390  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
391  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
392  */
393 library SafeERC20 {
394     using Address for address;
395 
396     function safeTransfer(
397         IERC20 token,
398         address to,
399         uint256 value
400     ) internal {
401         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
402     }
403 
404     function safeTransferFrom(
405         IERC20 token,
406         address from,
407         address to,
408         uint256 value
409     ) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(
421         IERC20 token,
422         address spender,
423         uint256 value
424     ) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         require(
429             (value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(
436         IERC20 token,
437         address spender,
438         uint256 value
439     ) internal {
440         uint256 newAllowance = token.allowance(address(this), spender) + value;
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(
445         IERC20 token,
446         address spender,
447         uint256 value
448     ) internal {
449         unchecked {
450             uint256 oldAllowance = token.allowance(address(this), spender);
451             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
452             uint256 newAllowance = oldAllowance - value;
453             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454         }
455     }
456 
457     /**
458      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
459      * on the return value: the return value is optional (but if data is returned, it must not be false).
460      * @param token The token targeted by the call.
461      * @param data The call data (encoded using abi.encode or one of its variants).
462      */
463     function _callOptionalReturn(IERC20 token, bytes memory data) private {
464         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
465         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
466         // the target address contains contract code and also asserts for success in the low-level call.
467 
468         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
469         if (returndata.length > 0) {
470             // Return data is optional
471             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
472         }
473     }
474 }
475 
476 /**
477  * @dev Contract module that helps prevent reentrant calls to a function.
478  *
479  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
480  * available, which can be applied to functions to make sure there are no nested
481  * (reentrant) calls to them.
482  *
483  * Note that because there is a single `nonReentrant` guard, functions marked as
484  * `nonReentrant` may not call one another. This can be worked around by making
485  * those functions `private`, and then adding `external` `nonReentrant` entry
486  * points to them.
487  *
488  * TIP: If you would like to learn more about reentrancy and alternative ways
489  * to protect against it, check out our blog post
490  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
491  */
492 abstract contract ReentrancyGuard {
493     // Booleans are more expensive than uint256 or any type that takes up a full
494     // word because each write operation emits an extra SLOAD to first read the
495     // slot's contents, replace the bits taken up by the boolean, and then write
496     // back. This is the compiler's defense against contract upgrades and
497     // pointer aliasing, and it cannot be disabled.
498 
499     // The values being non-zero value makes deployment a bit more expensive,
500     // but in exchange the refund on every call to nonReentrant will be lower in
501     // amount. Since refunds are capped to a percentage of the total
502     // transaction's gas, it is best to keep them low in cases like this one, to
503     // increase the likelihood of the full refund coming into effect.
504     uint256 private constant _NOT_ENTERED = 1;
505     uint256 private constant _ENTERED = 2;
506 
507     uint256 private _status;
508 
509     constructor() {
510         _status = _NOT_ENTERED;
511     }
512 
513     /**
514      * @dev Prevents a contract from calling itself, directly or indirectly.
515      * Calling a `nonReentrant` function from another `nonReentrant`
516      * function is not supported. It is possible to prevent this from happening
517      * by making the `nonReentrant` function external, and making it call a
518      * `private` function that does the actual work.
519      */
520     modifier nonReentrant() {
521         // On the first call to nonReentrant, _notEntered will be true
522         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
523 
524         // Any calls to nonReentrant after this point will fail
525         _status = _ENTERED;
526 
527         _;
528 
529         // By storing the original value once again, a refund is triggered (see
530         // https://eips.ethereum.org/EIPS/eip-2200)
531         _status = _NOT_ENTERED;
532     }
533 }
534 
535 abstract contract Ownable {
536     address private _owner;
537 
538     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
539 
540     constructor () {
541         address msgSender = msg.sender;
542         _owner = msgSender;
543         emit OwnershipTransferred(address(0), msgSender);
544     }
545 
546     function owner() public view returns (address) {
547         return _owner;
548     }
549 
550     modifier onlyOwner() {
551         require(_owner == msg.sender, "Ownable: caller is not the owner");
552         _;
553     }
554 
555     function renounceOwnership() public virtual onlyOwner {
556         emit OwnershipTransferred(_owner, address(0));
557         _owner = address(0);
558     }
559 
560     function transferOwnership(address newOwner) public virtual onlyOwner {
561         require(newOwner != address(0), "Ownable: new owner is the zero address");
562         emit OwnershipTransferred(_owner, newOwner);
563         _owner = newOwner;
564     }
565 }
566 
567 contract BTMDashboard is ReentrancyGuard,Ownable {
568     using SafeMath for uint256;
569 	using SafeERC20 for IERC20;
570 
571 	IERC20 public token;
572 
573     struct AllInfo {
574         uint256 claimFee;
575         uint256 totalDistributed;
576         uint256 userShare;
577         uint256 totalClaimed;
578         uint256 balance;
579         bool verifiedAddress;
580         bool distributedAddress;
581     }
582     	
583     mapping (address => uint256) shareholderClaims;
584     mapping (address => uint256) public shares;
585     mapping (address => bool) public verifiedAddress;
586     mapping (address => bool) public distributedAddress;
587 	
588     address private devAddress;
589     address private relayAddress;
590     uint256 private claimFee;
591     uint256 private relayFee = 1000000000000000;
592     uint256 public totalDistributed;
593 	
594 	uint256 private _weiDecimal = 18;
595 	
596 	receive() external payable {}
597 	
598 	modifier onlyRelay() {
599         require(relayAddress == msg.sender, "Relayer: caller is not the relay");
600         _;
601     }
602 	
603     constructor (
604 		address _token
605 		,address _devAddress
606 		,address _relayAddress
607 		,uint256 _claimFee
608 	) {
609 		token = IERC20(_token);
610 		devAddress = _devAddress;
611 		relayAddress = _relayAddress;
612 		claimFee = _claimFee;
613 	}
614 	
615 	function claimShare() external payable nonReentrant{
616 		if(!verifiedAddress[msg.sender]){
617 			if((claimFee + relayFee) > 0){
618 				require(msg.value >= (claimFee + relayFee), "insufficient claim Fee");
619 				payable(relayAddress).transfer(relayFee);
620 				
621 				uint256 amount = address(this).balance;
622 				payable(devAddress).transfer(amount);
623 			}
624 			
625 			verifyAddress(msg.sender);
626 		}
627     }
628 	
629 	function verifyAddress(address user) internal {
630 		verifiedAddress[user] = true;
631 	}
632 	
633     function distributeShare(address shareholder, uint256 amount) external nonReentrant onlyRelay {
634         require(verifiedAddress[msg.sender], "Address not verified");
635 		if(!distributedAddress[shareholder]){	
636 			distributedAddress[shareholder] = true;
637 			totalDistributed = totalDistributed.add(amount);
638 			shareholderClaims[shareholder] += amount;
639 			token.safeTransfer(shareholder, _getTokenAmount(address(token),amount));
640 		}
641     }
642 
643     function getAllInfo(address user) public view returns (AllInfo memory) {
644         return AllInfo(
645             (claimFee + relayFee),
646             totalDistributed,
647             shares[user],
648             shareholderClaims[user],
649 			_getReverseTokenAmount(address(token),token.balanceOf(user)),
650 			verifiedAddress[user],
651 			distributedAddress[user]
652         );
653     }
654 	
655 	function setDevAddress(address _devAddress) external onlyOwner {
656         devAddress = _devAddress;
657     }
658 	
659 	function setRelayAddress(address _relayAddress) external onlyOwner {
660         relayAddress = _relayAddress;
661     }
662 	
663 	function setClaimFee(uint256 _claimFee) external onlyOwner {
664         claimFee = _claimFee;
665     }
666 	
667 	function setRelayFee(uint256 _relayFee) external onlyOwner {
668         relayFee = _relayFee;
669     }
670 	
671 	function clearStuckBalance() external onlyOwner {
672         uint256 amount = address(this).balance;
673         payable(devAddress).transfer(amount);
674     }
675 	
676 	function clearStuckToken(address TokenAddress, uint256 amount) external onlyOwner {
677         IERC20(TokenAddress).safeTransfer(devAddress, _getTokenAmount(TokenAddress, amount));
678     }
679 	
680 	function _getTokenAmount(address _tokenAddress, uint256 _amount) internal view returns (uint256 quotient) {
681 		IERC20 tokenAddress = IERC20(_tokenAddress);
682 		uint256 tokenDecimal = tokenAddress.decimals();
683 		uint256 decimalDiff = 0;
684 		uint256 decimalDiffConverter = 0;
685 		uint256 amount = 0;
686 			
687 		if(_weiDecimal != tokenDecimal){
688 			if(_weiDecimal > tokenDecimal){
689 				decimalDiff = _weiDecimal - tokenDecimal;
690 				decimalDiffConverter = 10**decimalDiff;
691 				amount = _amount.div(decimalDiffConverter);
692 			} else {
693 				decimalDiff = tokenDecimal - _weiDecimal;
694 				decimalDiffConverter = 10**decimalDiff;
695 				amount = _amount.mul(decimalDiffConverter);
696 			}		
697 		} else {
698 			amount = _amount;
699 		}
700 		
701 		uint256 _quotient = amount;
702 		
703 		return (_quotient);
704     }
705 	
706 	function _getReverseTokenAmount(address _tokenAddress, uint256 _amount) internal view returns (uint256 quotient) {
707 		IERC20 tokenAddress = IERC20(_tokenAddress);
708 		uint256 tokenDecimal = tokenAddress.decimals();
709 		uint256 decimalDiff = 0;
710 		uint256 decimalDiffConverter = 0;
711 		uint256 amount = 0;
712 			
713 		if(_weiDecimal != tokenDecimal){
714 			if(_weiDecimal > tokenDecimal){
715 				decimalDiff = _weiDecimal - tokenDecimal;
716 				decimalDiffConverter = 10**decimalDiff;
717 				amount = _amount.mul(decimalDiffConverter);
718 			} else {
719 				decimalDiff = tokenDecimal - _weiDecimal;
720 				decimalDiffConverter = 10**decimalDiff;
721 				amount = _amount.div(decimalDiffConverter);
722 			}		
723 		} else {
724 			amount = _amount;
725 		}
726 		
727 		uint256 _quotient = amount;
728 		
729 		return (_quotient);
730     }
731 }