1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 2 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 
20 ///@author Zapper
21 ///@notice this contract adds liquidity to Balancer liquidity pools in one transaction
22 
23 // File: @openzeppelin/contracts/utils/Address.sol
24 
25 pragma solidity ^0.5.5;
26 
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, reverting on
30      * overflow.
31      *
32      * Counterpart to Solidity's `+` operator.
33      *
34      * Requirements:
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      * - Subtraction cannot overflow.
65      *
66      * _Available since v2.4.0._
67      */
68     function sub(
69         uint256 a,
70         uint256 b,
71         string memory errorMessage
72     ) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `*` operator.
84      *
85      * Requirements:
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      *
128      * _Available since v2.4.0._
129      */
130     function div(
131         uint256 a,
132         uint256 b,
133         string memory errorMessage
134     ) internal pure returns (uint256) {
135         // Solidity only automatically asserts when dividing by 0
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return mod(a, b, "SafeMath: modulo by zero");
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts with custom message when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      *
169      * _Available since v2.4.0._
170      */
171     function mod(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         require(b != 0, errorMessage);
177         return a % b;
178     }
179 }
180 
181 library Address {
182     /**
183      * @dev Returns true if `account` is a contract.
184      *
185      * [IMPORTANT]
186      * ====
187      * It is unsafe to assume that an address for which this function returns
188      * false is an externally-owned account (EOA) and not a contract.
189      *
190      * Among others, `isContract` will return false for the following
191      * types of addresses:
192      *
193      *  - an externally-owned account
194      *  - a contract in construction
195      *  - an address where a contract will be created
196      *  - an address where a contract lived, but was destroyed
197      * ====
198      */
199     function isContract(address account) internal view returns (bool) {
200         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
201         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
202         // for accounts without code, i.e. `keccak256('')`
203         bytes32 codehash;
204 
205 
206             bytes32 accountHash
207          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
208         // solhint-disable-next-line no-inline-assembly
209         assembly {
210             codehash := extcodehash(account)
211         }
212         return (codehash != accountHash && codehash != 0x0);
213     }
214 
215     /**
216      * @dev Converts an `address` into `address payable`. Note that this is
217      * simply a type cast: the actual underlying value is not changed.
218      *
219      * _Available since v2.4.0._
220      */
221     function toPayable(address account)
222         internal
223         pure
224         returns (address payable)
225     {
226         return address(uint160(account));
227     }
228 
229     /**
230      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
231      * `recipient`, forwarding all available gas and reverting on errors.
232      *
233      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
234      * of certain opcodes, possibly making contracts go over the 2300 gas limit
235      * imposed by `transfer`, making them unable to receive funds via
236      * `transfer`. {sendValue} removes this limitation.
237      *
238      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
239      *
240      * IMPORTANT: because control is transferred to `recipient`, care must be
241      * taken to not create reentrancy vulnerabilities. Consider using
242      * {ReentrancyGuard} or the
243      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
244      *
245      * _Available since v2.4.0._
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(
249             address(this).balance >= amount,
250             "Address: insufficient balance"
251         );
252 
253         // solhint-disable-next-line avoid-call-value
254         (bool success, ) = recipient.call.value(amount)("");
255         require(
256             success,
257             "Address: unable to send value, recipient may have reverted"
258         );
259     }
260 }
261 
262 interface IERC20 {
263     /**
264      * @dev Returns the amount of tokens in existence.
265      */
266     function totalSupply() external view returns (uint256);
267 
268     /**
269      * @dev Returns the amount of tokens owned by `account`.
270      */
271     function balanceOf(address account) external view returns (uint256);
272 
273     /**
274      * @dev Moves `amount` tokens from the caller's account to `recipient`.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transfer(address recipient, uint256 amount)
281         external
282         returns (bool);
283 
284     /**
285      * @dev Returns the remaining number of tokens that `spender` will be
286      * allowed to spend on behalf of `owner` through {transferFrom}. This is
287      * zero by default.
288      *
289      * This value changes when {approve} or {transferFrom} are called.
290      */
291     function allowance(address owner, address spender)
292         external
293         view
294         returns (uint256);
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * IMPORTANT: Beware that changing an allowance with this method brings the risk
302      * that someone may use both the old and the new allowance by unfortunate
303      * transaction ordering. One possible solution to mitigate this race
304      * condition is to first reduce the spender's allowance to 0 and set the
305      * desired value afterwards:
306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307      *
308      * Emits an {Approval} event.
309      */
310     function approve(address spender, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Moves `amount` tokens from `sender` to `recipient` using the
314      * allowance mechanism. `amount` is then deducted from the caller's
315      * allowance.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(
322         address sender,
323         address recipient,
324         uint256 amount
325     ) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(
340         address indexed owner,
341         address indexed spender,
342         uint256 value
343     );
344 }
345 
346 library SafeERC20 {
347     using SafeMath for uint256;
348     using Address for address;
349 
350     function safeTransfer(
351         IERC20 token,
352         address to,
353         uint256 value
354     ) internal {
355         callOptionalReturn(
356             token,
357             abi.encodeWithSelector(token.transfer.selector, to, value)
358         );
359     }
360 
361     function safeTransferFrom(
362         IERC20 token,
363         address from,
364         address to,
365         uint256 value
366     ) internal {
367         callOptionalReturn(
368             token,
369             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
370         );
371     }
372 
373     function safeApprove(
374         IERC20 token,
375         address spender,
376         uint256 value
377     ) internal {
378         // safeApprove should only be called when setting an initial allowance,
379         // or when resetting it to zero. To increase and decrease it, use
380         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
381         // solhint-disable-next-line max-line-length
382         require(
383             (value == 0) || (token.allowance(address(this), spender) == 0),
384             "SafeERC20: approve from non-zero to non-zero allowance"
385         );
386         callOptionalReturn(
387             token,
388             abi.encodeWithSelector(token.approve.selector, spender, value)
389         );
390     }
391 
392     function safeIncreaseAllowance(
393         IERC20 token,
394         address spender,
395         uint256 value
396     ) internal {
397         uint256 newAllowance = token.allowance(address(this), spender).add(
398             value
399         );
400         callOptionalReturn(
401             token,
402             abi.encodeWithSelector(
403                 token.approve.selector,
404                 spender,
405                 newAllowance
406             )
407         );
408     }
409 
410     function safeDecreaseAllowance(
411         IERC20 token,
412         address spender,
413         uint256 value
414     ) internal {
415         uint256 newAllowance = token.allowance(address(this), spender).sub(
416             value,
417             "SafeERC20: decreased allowance below zero"
418         );
419         callOptionalReturn(
420             token,
421             abi.encodeWithSelector(
422                 token.approve.selector,
423                 spender,
424                 newAllowance
425             )
426         );
427     }
428 
429     /**
430      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
431      * on the return value: the return value is optional (but if data is returned, it must not be false).
432      * @param token The token targeted by the call.
433      * @param data The call data (encoded using abi.encode or one of its variants).
434      */
435     function callOptionalReturn(IERC20 token, bytes memory data) private {
436         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
437         // we're implementing it ourselves.
438 
439         // A Solidity high level call has three parts:
440         //  1. The target address is checked to verify it contains contract code
441         //  2. The call itself is made, and success asserted
442         //  3. The return value is decoded, which in turn checks the size of the returned data.
443         // solhint-disable-next-line max-line-length
444         require(address(token).isContract(), "SafeERC20: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = address(token).call(data);
448         require(success, "SafeERC20: low-level call failed");
449 
450         if (returndata.length > 0) {
451             // Return data is optional
452             // solhint-disable-next-line max-line-length
453             require(
454                 abi.decode(returndata, (bool)),
455                 "SafeERC20: ERC20 operation did not succeed"
456             );
457         }
458     }
459 }
460 
461 contract Context {
462     // Empty internal constructor, to prevent people from mistakenly deploying
463     // an instance of this contract, which should be used via inheritance.
464     constructor() internal {}
465 
466     // solhint-disable-previous-line no-empty-blocks
467 
468     function _msgSender() internal view returns (address payable) {
469         return msg.sender;
470     }
471 
472     function _msgData() internal view returns (bytes memory) {
473         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
474         return msg.data;
475     }
476 }
477 
478 contract Ownable is Context {
479     address private _owner;
480 
481     event OwnershipTransferred(
482         address indexed previousOwner,
483         address indexed newOwner
484     );
485 
486     /**
487      * @dev Initializes the contract setting the deployer as the initial owner.
488      */
489     constructor() internal {
490         address msgSender = _msgSender();
491         _owner = msgSender;
492         emit OwnershipTransferred(address(0), msgSender);
493     }
494 
495     /**
496      * @dev Returns the address of the current owner.
497      */
498     function owner() public view returns (address) {
499         return _owner;
500     }
501 
502     /**
503      * @dev Throws if called by any account other than the owner.
504      */
505     modifier onlyOwner() {
506         require(isOwner(), "Ownable: caller is not the owner");
507         _;
508     }
509 
510     /**
511      * @dev Returns true if the caller is the current owner.
512      */
513     function isOwner() public view returns (bool) {
514         return _msgSender() == _owner;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public onlyOwner {
525         emit OwnershipTransferred(_owner, address(0));
526         _owner = address(0);
527     }
528 
529     /**
530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
531      * Can only be called by the current owner.
532      */
533     function transferOwnership(address newOwner) public onlyOwner {
534         _transferOwnership(newOwner);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      */
540     function _transferOwnership(address newOwner) internal {
541         require(
542             newOwner != address(0),
543             "Ownable: new owner is the zero address"
544         );
545         emit OwnershipTransferred(_owner, newOwner);
546         _owner = newOwner;
547     }
548 }
549 
550 contract ReentrancyGuard {
551     bool private _notEntered;
552 
553     constructor() internal {
554         // Storing an initial non-zero value makes deployment a bit more
555         // expensive, but in exchange the refund on every call to nonReentrant
556         // will be lower in amount. Since refunds are capped to a percetange of
557         // the total transaction's gas, it is best to keep them low in cases
558         // like this one, to increase the likelihood of the full refund coming
559         // into effect.
560         _notEntered = true;
561     }
562 
563     /**
564      * @dev Prevents a contract from calling itself, directly or indirectly.
565      * Calling a `nonReentrant` function from another `nonReentrant`
566      * function is not supported. It is possible to prevent this from happening
567      * by making the `nonReentrant` function external, and make it call a
568      * `private` function that does the actual work.
569      */
570     modifier nonReentrant() {
571         // On the first call to nonReentrant, _notEntered will be true
572         require(_notEntered, "ReentrancyGuard: reentrant call");
573 
574         // Any calls to nonReentrant after this point will fail
575         _notEntered = false;
576 
577         _;
578 
579         // By storing the original value once again, a refund is triggered (see
580         // https://eips.ethereum.org/EIPS/eip-2200)
581         _notEntered = true;
582     }
583 }
584 
585 interface IBFactory {
586     function isBPool(address b) external view returns (bool);
587 }
588 
589 interface IBPool {
590     function joinswapExternAmountIn(
591         address tokenIn,
592         uint256 tokenAmountIn,
593         uint256 minPoolAmountOut
594     ) external payable returns (uint256 poolAmountOut);
595 
596     function isBound(address t) external view returns (bool);
597 
598     function getFinalTokens() external view returns (address[] memory tokens);
599 
600     function totalSupply() external view returns (uint256);
601 
602     function getDenormalizedWeight(address token)
603         external
604         view
605         returns (uint256);
606 
607     function getTotalDenormalizedWeight() external view returns (uint256);
608 
609     function getSwapFee() external view returns (uint256);
610 
611     function calcPoolOutGivenSingleIn(
612         uint256 tokenBalanceIn,
613         uint256 tokenWeightIn,
614         uint256 poolSupply,
615         uint256 totalWeight,
616         uint256 tokenAmountIn,
617         uint256 swapFee
618     ) external pure returns (uint256 poolAmountOut);
619 
620     function getBalance(address token) external view returns (uint256);
621 }
622 
623 contract Balancer_ZapIn_General_V2_6 is ReentrancyGuard, Ownable {
624     using SafeMath for uint256;
625     using Address for address;
626     using SafeERC20 for IERC20;
627     bool public stopped = false;
628     uint16 public goodwill;
629 
630     IBFactory BalancerFactory = IBFactory(
631         0x9424B1412450D0f8Fc2255FAf6046b98213B76Bd
632     );
633 
634     address payable
635         public zgoodwillAddress = 0x3CE37278de6388532C3949ce4e886F365B14fB56;
636 
637     event Zapin(address userAddress, address balancerPool, uint256 LPTRec);
638 
639     constructor(uint16 _goodwill) public {
640         goodwill = _goodwill;
641     }
642 
643     // circuit breaker modifiers
644     modifier stopInEmergency {
645         if (stopped) {
646             revert("Temporarily Paused");
647         } else {
648             _;
649         }
650     }
651 
652     /**
653     @notice This function is used to invest in given balancer pool using ETH/ERC20 Tokens
654     @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
655     @param _ToBalancerPoolAddress The address of balancer pool to zapin
656     @param _toTokenContractAddress The token with which we are adding liquidity
657     @param _amount The amount of ERC to invest
658     @param _minPoolTokens for slippage
659     @param _allowanceTarget indiacates the spender for swap
660     @param _swapTarget indicates the execution target for swap.
661     @param swapCallData indicates the callData for execution
662     @return quantity of Balancer pool tokens acquired
663      */
664     function ZapIn(
665         address _FromTokenContractAddress,
666         address _ToBalancerPoolAddress,
667         address _toTokenContractAddress,
668         uint256 _amount,
669         uint256 _minPoolTokens,
670         address _allowanceTarget,
671         address _swapTarget,
672         bytes calldata swapCallData
673     ) external payable nonReentrant stopInEmergency returns (uint256 LPTRec) {
674         require(
675             BalancerFactory.isBPool(_ToBalancerPoolAddress),
676             "Invalid Balancer Pool"
677         );
678 
679         require(
680             IBPool(_ToBalancerPoolAddress).isBound(_toTokenContractAddress),
681             "Token not bound"
682         );
683         uint256 valueToSend;
684 
685         if (_FromTokenContractAddress == address(0)) {
686             require(msg.value > 0, "ERR: No ETH sent");
687             //transfer eth to goodwill
688             uint256 goodwillPortion = _transferGoodwill(address(0), msg.value);
689             valueToSend = msg.value.sub(goodwillPortion);
690         } else {
691             require(_amount > 0, "ERR: No ERC sent");
692             require(msg.value == 0, "ERR: ETH sent with tokens");
693 
694             IERC20(_FromTokenContractAddress).safeTransferFrom(
695                 msg.sender,
696                 address(this),
697                 _amount
698             );
699 
700             uint256 goodwillPortion = _transferGoodwill(
701                 _FromTokenContractAddress,
702                 _amount
703             );
704             valueToSend = _amount.sub(goodwillPortion);
705         }
706 
707         LPTRec = _performZapIn(
708             _FromTokenContractAddress,
709             _ToBalancerPoolAddress,
710             valueToSend,
711             _toTokenContractAddress,
712             _allowanceTarget,
713             _swapTarget,
714             swapCallData
715         );
716 
717         require(LPTRec >= _minPoolTokens, "ERR: High Slippage");
718 
719         IERC20(_ToBalancerPoolAddress).safeTransfer(msg.sender, LPTRec);
720 
721         emit Zapin(msg.sender, _ToBalancerPoolAddress, LPTRec);
722 
723         return LPTRec;
724     }
725 
726     /**
727     @notice This function internally called by ZapIn() and EasyZapIn()
728     @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
729     @param _ToBalancerPoolAddress The address of balancer pool to zapin
730     @param _amount The amount of ETH/ERC to invest
731     @param _toTokenContractAddress The token with which we are adding liquidity
732     @return Balancer pool tokens acquired
733     **/
734     function _performZapIn(
735         address _FromTokenContractAddress,
736         address _ToBalancerPoolAddress,
737         uint256 _amount,
738         address _toTokenContractAddress,
739         address _allowanceTarget,
740         address _swapTarget,
741         bytes memory swapCallData
742     ) internal returns (uint256 tokensBought) {
743         // check if isBound()
744         bool isBound = IBPool(_ToBalancerPoolAddress).isBound(
745             _FromTokenContractAddress
746         );
747 
748         uint256 balancerTokens;
749 
750         if (isBound) {
751             balancerTokens = _enter2Balancer(
752                 _ToBalancerPoolAddress,
753                 _FromTokenContractAddress,
754                 _amount
755             );
756         } else {
757             uint256 tokenBought = _fillQuote(
758                 _FromTokenContractAddress,
759                 _toTokenContractAddress,
760                 _amount,
761                 _allowanceTarget,
762                 _swapTarget,
763                 swapCallData
764             );
765 
766             //get BPT
767             balancerTokens = _enter2Balancer(
768                 _ToBalancerPoolAddress,
769                 _toTokenContractAddress,
770                 tokenBought
771             );
772         }
773 
774         return balancerTokens;
775     }
776 
777     /**
778     @notice this method is used to swap ETH/ERC20<>ERC20/ETH tokens
779     @param _fromTokenAddress indicates the ETH/ERC20 token to zapIn with
780     @param _bestPoolToken indicates the best pool token to which From tokens to swap
781     @param _amount indicates the ETH/ERC20 amount to swap
782     @param _allowanceTarget indiacates the spender for swap
783     @param _swapTarget indicates the execution target for swap.
784     @param swapCallData indicates the callData for execution
785     @return amountBought tokens after 0x swap
786     */
787     function _fillQuote(
788         address _fromTokenAddress,
789         address _bestPoolToken,
790         uint256 _amount,
791         address _allowanceTarget,
792         address _swapTarget,
793         bytes memory swapCallData
794     ) internal returns (uint256 amountBought) {
795         uint256 valueToSend;
796 
797         if (_fromTokenAddress == address(0)) {
798             valueToSend = _amount;
799         } else {
800             IERC20 fromToken = IERC20(_fromTokenAddress);
801 
802             require(
803                 fromToken.balanceOf(address(this)) >= _amount,
804                 "Insufficient Balance"
805             );
806 
807             fromToken.safeApprove(address(_allowanceTarget), 0);
808             fromToken.safeApprove(address(_allowanceTarget), _amount);
809         }
810 
811         uint256 initialBalance = IERC20(_bestPoolToken).balanceOf(
812             address(this)
813         );
814 
815         (bool success, ) = _swapTarget.call.value(valueToSend)(swapCallData);
816         require(success, "Error Swapping tokens");
817 
818         amountBought = IERC20(_bestPoolToken).balanceOf(address(this)).sub(
819             initialBalance
820         );
821 
822         require(amountBought > 0, "Swapped to Invalid Intermediate");
823     }
824 
825     /**
826     @notice This function is used to zapin to balancer pool
827     @param _ToBalancerPoolAddress The address of balancer pool to zap in
828     @param _FromTokenContractAddress The token used to zap in
829     @param tokens2Trade The amount of tokens to invest
830     @return The quantity of Balancer Pool tokens returned
831      */
832     function _enter2Balancer(
833         address _ToBalancerPoolAddress,
834         address _FromTokenContractAddress,
835         uint256 tokens2Trade
836     ) internal returns (uint256 poolTokensOut) {
837         require(
838             IBPool(_ToBalancerPoolAddress).isBound(_FromTokenContractAddress),
839             "Token not bound"
840         );
841 
842         uint256 allowance = IERC20(_FromTokenContractAddress).allowance(
843             address(this),
844             _ToBalancerPoolAddress
845         );
846 
847         if (allowance < tokens2Trade) {
848             IERC20(_FromTokenContractAddress).safeApprove(
849                 _ToBalancerPoolAddress,
850                 tokens2Trade
851             );
852         }
853 
854         poolTokensOut = IBPool(_ToBalancerPoolAddress).joinswapExternAmountIn(
855             _FromTokenContractAddress,
856             tokens2Trade,
857             1
858         );
859 
860         require(poolTokensOut > 0, "Error in entering balancer pool");
861     }
862 
863     /**
864     @notice This function is used to calculate and transfer goodwill
865     @param _tokenContractAddress Token in which goodwill is deducted
866     @param tokens2Trade The total amount of tokens to be zapped in
867     @return The quantity of goodwill deducted
868      */
869 
870     function _transferGoodwill(
871         address _tokenContractAddress,
872         uint256 tokens2Trade
873     ) internal returns (uint256 goodwillPortion) {
874         if (goodwill == 0) {
875             return 0;
876         }
877         goodwillPortion = SafeMath.div(
878             SafeMath.mul(tokens2Trade, goodwill),
879             10000
880         );
881 
882         if (_tokenContractAddress == address(0)) {
883             Address.sendValue(zgoodwillAddress, goodwillPortion);
884         } else {
885             IERC20(_tokenContractAddress).safeTransfer(
886                 zgoodwillAddress,
887                 goodwillPortion
888             );
889         }
890     }
891 
892     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
893         require(
894             _new_goodwill >= 0 && _new_goodwill < 10000,
895             "GoodWill Value not allowed"
896         );
897         goodwill = _new_goodwill;
898     }
899 
900     function set_new_zgoodwillAddress(address payable _new_zgoodwillAddress)
901         public
902         onlyOwner
903     {
904         zgoodwillAddress = _new_zgoodwillAddress;
905     }
906 
907     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
908         uint256 qty = _TokenAddress.balanceOf(address(this));
909         IERC20(address(_TokenAddress)).safeTransfer(owner(), qty);
910     }
911 
912     // - to Pause the contract
913     function toggleContractActive() public onlyOwner {
914         stopped = !stopped;
915     }
916 
917     // - to withdraw any ETH balance sitting in the contract
918     function withdraw() public onlyOwner {
919         uint256 contractBalance = address(this).balance;
920         address payable _to = owner().toPayable();
921         _to.transfer(contractBalance);
922     }
923 
924     function() external payable {
925         require(msg.sender != tx.origin, "Do not send ETH directly");
926     }
927 }