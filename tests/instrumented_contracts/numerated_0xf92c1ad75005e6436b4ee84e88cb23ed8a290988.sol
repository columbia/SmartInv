1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.10;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Contract module that helps prevent reentrant calls to a function.
117  *
118  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
119  * available, which can be aplied to functions to make sure there are no nested
120  * (reentrant) calls to them.
121  *
122  * Note that because there is a single `nonReentrant` guard, functions marked as
123  * `nonReentrant` may not call one another. This can be worked around by making
124  * those functions `private`, and then adding `external` `nonReentrant` entry
125  * points to them.
126  */
127 contract ReentrancyGuard {
128     /// @dev counter to allow mutex lock with only one SSTORE operation
129     uint256 private _guardCounter;
130 
131     constructor () internal {
132         // The counter starts at one to prevent changing it from zero to a non-zero
133         // value, which is a more expensive operation.
134         _guardCounter = 1;
135     }
136 
137     /**
138      * @dev Prevents a contract from calling itself, directly or indirectly.
139      * Calling a `nonReentrant` function from another `nonReentrant`
140      * function is not supported. It is possible to prevent this from happening
141      * by making the `nonReentrant` function external, and make it call a
142      * `private` function that does the actual work.
143      */
144     modifier nonReentrant() {
145         _guardCounter += 1;
146         uint256 localCounter = _guardCounter;
147         _;
148         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
149     }
150 }
151 
152 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
153 
154 pragma solidity ^0.5.0;
155 
156 /**
157  * @dev Contract module which provides a basic access control mechanism, where
158  * there is an account (an owner) that can be granted exclusive access to
159  * specific functions.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be aplied to your functions to restrict their use to
163  * the owner.
164  */
165 contract Ownable {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor () internal {
174         _owner = msg.sender;
175         emit OwnershipTransferred(address(0), _owner);
176     }
177 
178     /**
179      * @dev Returns the address of the current owner.
180      */
181     function owner() public view returns (address) {
182         return _owner;
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         require(isOwner(), "Ownable: caller is not the owner");
190         _;
191     }
192 
193     /**
194      * @dev Returns true if the caller is the current owner.
195      */
196     function isOwner() public view returns (bool) {
197         return msg.sender == _owner;
198     }
199 
200     /**
201      * @dev Leaves the contract without owner. It will not be possible to call
202      * `onlyOwner` functions anymore. Can only be called by the current owner.
203      *
204      * > Note: Renouncing ownership will leave the contract without an owner,
205      * thereby removing any functionality that is only available to the owner.
206      */
207     function renounceOwnership() public onlyOwner {
208         emit OwnershipTransferred(_owner, address(0));
209         _owner = address(0);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Can only be called by the current owner.
215      */
216     function transferOwnership(address newOwner) public onlyOwner {
217         _transferOwnership(newOwner);
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      */
223     function _transferOwnership(address newOwner) internal {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         emit OwnershipTransferred(_owner, newOwner);
226         _owner = newOwner;
227     }
228 }
229 
230 // File: openzeppelin-solidity/contracts/utils/Address.sol
231 
232 pragma solidity ^0.5.0;
233 
234 /**
235  * @dev Collection of functions related to the address type,
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * This test is non-exhaustive, and there may be false-negatives: during the
242      * execution of a contract's constructor, its address will be reported as
243      * not containing a contract.
244      *
245      * > It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      */
248     function isContract(address account) internal view returns (bool) {
249         // This method relies in extcodesize, which returns 0 for contracts in
250         // construction, since the code is only stored at the end of the
251         // constructor execution.
252 
253         uint256 size;
254         // solhint-disable-next-line no-inline-assembly
255         assembly { size := extcodesize(account) }
256         return size > 0;
257     }
258 }
259 
260 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
261 
262 pragma solidity ^0.5.0;
263 
264 /**
265  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
266  * the optional functions; to access them see `ERC20Detailed`.
267  */
268 interface IERC20 {
269     /**
270      * @dev Returns the amount of tokens in existence.
271      */
272     function totalSupply() external view returns (uint256);
273 
274     /**
275      * @dev Returns the amount of tokens owned by `account`.
276      */
277     function balanceOf(address account) external view returns (uint256);
278 
279     /**
280      * @dev Moves `amount` tokens from the caller's account to `recipient`.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * Emits a `Transfer` event.
285      */
286     function transfer(address recipient, uint256 amount) external returns (bool);
287 
288     /**
289      * @dev Returns the remaining number of tokens that `spender` will be
290      * allowed to spend on behalf of `owner` through `transferFrom`. This is
291      * zero by default.
292      *
293      * This value changes when `approve` or `transferFrom` are called.
294      */
295     function allowance(address owner, address spender) external view returns (uint256);
296 
297     /**
298      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * > Beware that changing an allowance with this method brings the risk
303      * that someone may use both the old and the new allowance by unfortunate
304      * transaction ordering. One possible solution to mitigate this race
305      * condition is to first reduce the spender's allowance to 0 and set the
306      * desired value afterwards:
307      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308      *
309      * Emits an `Approval` event.
310      */
311     function approve(address spender, uint256 amount) external returns (bool);
312 
313     /**
314      * @dev Moves `amount` tokens from `sender` to `recipient` using the
315      * allowance mechanism. `amount` is then deducted from the caller's
316      * allowance.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a `Transfer` event.
321      */
322     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Emitted when `value` tokens are moved from one account (`from`) to
326      * another (`to`).
327      *
328      * Note that `value` may be zero.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 value);
331 
332     /**
333      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
334      * a call to `approve`. `value` is the new allowance.
335      */
336     event Approval(address indexed owner, address indexed spender, uint256 value);
337 }
338 
339 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
340 
341 pragma solidity ^0.5.0;
342 
343 
344 
345 
346 /**
347  * @title SafeERC20
348  * @dev Wrappers around ERC20 operations that throw on failure (when the token
349  * contract returns false). Tokens that return no value (and instead revert or
350  * throw on failure) are also supported, non-reverting calls are assumed to be
351  * successful.
352  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
353  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
354  */
355 library SafeERC20 {
356     using SafeMath for uint256;
357     using Address for address;
358 
359     function safeTransfer(IERC20 token, address to, uint256 value) internal {
360         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
361     }
362 
363     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
364         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
365     }
366 
367     function safeApprove(IERC20 token, address spender, uint256 value) internal {
368         // safeApprove should only be called when setting an initial allowance,
369         // or when resetting it to zero. To increase and decrease it, use
370         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
371         // solhint-disable-next-line max-line-length
372         require((value == 0) || (token.allowance(address(this), spender) == 0),
373             "SafeERC20: approve from non-zero to non-zero allowance"
374         );
375         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
376     }
377 
378     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
379         uint256 newAllowance = token.allowance(address(this), spender).add(value);
380         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
381     }
382 
383     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
384         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
385         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
386     }
387 
388     /**
389      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
390      * on the return value: the return value is optional (but if data is returned, it must not be false).
391      * @param token The token targeted by the call.
392      * @param data The call data (encoded using abi.encode or one of its variants).
393      */
394     function callOptionalReturn(IERC20 token, bytes memory data) private {
395         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
396         // we're implementing it ourselves.
397 
398         // A Solidity high level call has three parts:
399         //  1. The target address is checked to verify it contains contract code
400         //  2. The call itself is made, and success asserted
401         //  3. The return value is decoded, which in turn checks the size of the returned data.
402         // solhint-disable-next-line max-line-length
403         require(address(token).isContract(), "SafeERC20: call to non-contract");
404 
405         // solhint-disable-next-line avoid-low-level-calls
406         (bool success, bytes memory returndata) = address(token).call(data);
407         require(success, "SafeERC20: low-level call failed");
408 
409         if (returndata.length > 0) { // Return data is optional
410             // solhint-disable-next-line max-line-length
411             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
412         }
413     }
414 }
415 
416 // File: contracts/IGST2.sol
417 
418 pragma solidity 0.5.10;
419 
420 interface IGST2 {
421 
422     function freeUpTo(uint256 value) external returns (uint256 freed);
423 
424     function balanceOf(address who) external view returns (uint256);
425 
426     function mint(uint256 value) external;
427 }
428 
429 // File: contracts/TokenTransferProxy.sol
430 
431 pragma solidity 0.5.10;
432 
433 
434 
435 
436 
437 /**
438 * @dev Allows owner of the contract to transfer tokens on behalf of user.
439 * User will need to approve this contract to spend tokens on his/her behalf
440 * on Paraswap platform
441 */
442 contract TokenTransferProxy is Ownable {
443     using SafeERC20 for IERC20;
444 
445     /**
446     * @dev Allows owner of the contract to transfer tokens on user's behalf
447     * @dev Swapper contract will be the owner of this contract
448     * @param token Address of the token
449     * @param from Address from which tokens will be transferred
450     * @param to Receipent address of the tokens
451     * @param amount Amount of tokens to transfer
452     */
453     function transferFrom(
454         address token,
455         address from,
456         address to,
457         uint256 amount
458     )
459         external
460         onlyOwner
461     {
462         IERC20(token).safeTransferFrom(from, to, amount);
463     }
464 
465 }
466 
467 // File: contracts/IWETH.sol
468 
469 pragma solidity 0.5.10;
470 
471 
472 
473 contract IWETH is IERC20 {
474     function deposit() external payable;
475     function withdraw(uint256 amount) external;
476 }
477 
478 // File: contracts/AugustusSwapper.sol
479 
480 pragma solidity 0.5.10;
481 
482 
483 
484 
485 
486 
487 
488 
489 
490 
491 /**
492 * @dev The contract will allow swap of one token for another across multiple exchanges in one atomic transaction
493 * Kyber, Uniswap and Bancor are supported in phase-01
494 */
495 contract AugustusSwapper is ReentrancyGuard, Ownable {
496     using SafeERC20 for IERC20;
497     using SafeMath for uint256;
498     using Address for address;
499 
500     //Ether token address used when to or from in swap is Ether
501     address constant private ETH_ADDRESS = address(
502         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
503     );
504 
505     //External call is allowed to whitelisted addresses only.
506     //Contract address of all supported exchanges must be put in whitelist
507     mapping(address => bool) private _whitelisteds;
508 
509     //for 2% enter 200. For 0.2% enter 20. Supports upto 2 decimal places
510     uint256 private _fee;
511 
512     address payable private _feeWallet;
513 
514     IGST2 private _gasToken;
515 
516     bool private _paused;
517 
518     TokenTransferProxy private _tokenTransferProxy;
519 
520     event WhitelistAdded(address indexed account);
521     event WhitelistRemoved(address indexed account);
522     event Swapped(
523         address indexed user,
524         address indexed srcToken,
525         address indexed destToken,
526         uint256 srcAmount,
527         uint256 receivedAmount,
528         string referrer
529     );
530 
531     event Payed(
532         address indexed to,
533         address indexed srcToken,
534         address indexed destToken,
535         uint256 srcAmount,
536         uint256 receivedAmount,
537         string referrer
538     );
539     event Paused();
540     event Unpaused();
541 
542     modifier onlySelf() {
543         require(
544             msg.sender == address(this),
545             "AugustusSwapper: Invalid access!!"
546         );
547         _;
548     }
549 
550     /**
551      * @dev Modifier to make a function callable only when the contract is not paused.
552      */
553     modifier whenNotPaused() {
554         require(!_paused, "Pausable: paused");
555         _;
556     }
557 
558     /**
559      * @dev Modifier to make a function callable only when the contract is paused.
560      */
561     modifier whenPaused() {
562         require(_paused, "Pausable: not paused");
563         _;
564     }
565 
566     /**
567     * @dev Constructor
568     * It will whitelist the contarct itself
569     */
570     constructor(address payable feeWallet, address gasToken) public {
571         require(feeWallet != address(0), "Invalid address!!");
572         require(gasToken != address(0), "Invalid gas token!!");
573 
574         _feeWallet = feeWallet;
575         _gasToken = IGST2(gasToken);
576 
577         _whitelisteds[address(this)] = true;
578         _tokenTransferProxy = new TokenTransferProxy();
579 
580         emit WhitelistAdded(address(this));
581     }
582 
583     /**
584     * @dev Fallback method to allow exchanges to transfer back ethers for a particular swap
585     * It will only allow contracts to send funds to it
586     */
587     function() external payable whenNotPaused {
588         address account = msg.sender;
589         require(
590             account.isContract(),
591             "Sender is not a contract"
592         );
593     }
594 
595     /**
596     * @dev Returns address of TokenTransferProxy Contract
597     */
598     function getTokenTransferProxy() external view returns (address) {
599         return address(_tokenTransferProxy);
600     }
601 
602     /**
603      * @dev Returns true if the contract is paused, and false otherwise.
604      */
605     function paused() external view returns (bool) {
606         return _paused;
607     }
608 
609     /**
610      * @dev Called by a pauser to pause, triggers stopped state.
611      */
612     function pause() external onlyOwner whenNotPaused {
613         _paused = true;
614         emit Paused();
615     }
616 
617     /**
618      * @dev Called by a pauser to unpause, returns to normal state.
619      */
620     function unpause() external onlyOwner whenPaused {
621         _paused = false;
622         emit Unpaused();
623     }
624 
625     /**
626     * @dev Allows owner to change fee wallet
627     * @param feeWallet Address of the new fee wallet
628     */
629     function changeFeeWallet(address payable feeWallet) external onlyOwner {
630         _feeWallet = feeWallet;
631     }
632 
633     /**
634     * @dev Returns the fee wallet address
635     */
636     function getFeeWallet() external view returns (address) {
637         return _feeWallet;
638     }
639 
640     /**
641     * @dev Allows owner to change fee
642     * @param fee New fee percentage
643     */
644     function changeFee(uint256 fee) external onlyOwner {
645         _fee = fee;
646     }
647 
648     /**
649     * @dev returns the current fee percentage
650     */
651     function getFee() external view returns (uint256) {
652         return _fee;
653     }
654 
655     /**
656     * @dev Allows owner of the contract to whitelist an address
657     * @param account Address of the account to be whitelisted
658     */
659     function addWhitelisted(address account) external onlyOwner {
660         _whitelisteds[account] = true;
661         emit WhitelistAdded(account);
662     }
663 
664     /**
665     * @dev Allows owner of the contract to remove address from a whitelist
666     * @param account Address of the account the be removed
667     */
668     function removeWhitelistes(address account) external onlyOwner {
669         _whitelisteds[account] = false;
670         emit WhitelistRemoved(account);
671     }
672 
673     /**
674     * @dev Allows onwers of the contract to whitelist addresses in bulk
675     * @param accounts An array of addresses to be whitelisted
676     */
677     function addWhitelistedBulk(
678         address[] calldata accounts
679     )
680     external
681     onlyOwner
682     {
683         for (uint256 i = 0; i < accounts.length; i++) {
684             _whitelisteds[accounts[i]] = true;
685             emit WhitelistAdded(accounts[i]);
686         }
687     }
688 
689     /**
690     * @dev Allows this contract to make approve call for a token
691     * This method is expected to be called using externalCall method.
692     * @param token The address of the token
693     * @param to The address of the spender
694     * @param amount The amount to be approved
695     */
696     function approve(
697         address token,
698         address to,
699         uint256 amount
700     )
701     external
702     onlySelf
703     {
704         require(amount > 0, "Amount should be greater than 0!!");
705         //1. Check for valid whitelisted address
706         require(
707             isWhitelisted(to),
708             "AugustusSwapper: Not a whitelisted address!!"
709         );
710 
711         //2. Check for ETH address
712         if (token != ETH_ADDRESS) {
713             //3. Approve
714             IERC20 _token = IERC20(token);
715             _token.safeApprove(to, amount);
716         }
717 
718     }
719 
720     /**
721     * @dev Allows owner of the contract to transfer tokens any tokens which are assigned to the contract
722     * This method is for saftey if by any chance tokens or ETHs are assigned to the contract by mistake
723     * @dev token Address of the token to be transferred
724     * @dev destination Recepient of the token
725     * @dev amount Amount of tokens to be transferred
726     */
727     function ownerTransferTokens(
728         address token,
729         address payable destination,
730         uint256 amount
731     )
732     external
733     onlyOwner
734     {
735         transferTokens(token, destination, amount);
736     }
737 
738     /**
739     * @dev Allows owner of the contract to mint more gas tokens
740     * @param amount Amount of gas tokens to mint
741     */
742     function mintGasTokens(uint256 amount) external onlyOwner {
743         _gasToken.mint(amount);
744     }
745 
746     /**
747    * @dev This function sends the WETH returned during the exchange to the user.
748    * @param token: The WETH Address
749    */
750     function withdrawAllWETH(IWETH token) external {
751         uint256 amount = token.balanceOf(address(this));
752         token.withdraw(amount);
753     }
754 
755     function pay(
756         address payable receiver,
757         address sourceToken,
758         address destinationToken,
759         uint256 sourceAmount,
760         uint256 destinationAmount,
761         address[] memory callees,
762         bytes memory exchangeData,
763         uint256[] memory startIndexes,
764         uint256[] memory values,
765         string memory referrer,
766         uint256 mintPrice
767     )
768     public
769     payable
770     whenNotPaused
771     nonReentrant
772     {
773         uint receivedAmount = performSwap(
774             sourceToken,
775             destinationToken,
776             sourceAmount,
777             destinationAmount,
778             callees,
779             exchangeData,
780             startIndexes,
781             values,
782             mintPrice
783         );
784 
785         address payable payer = msg.sender;
786 
787         transferTokens(destinationToken, receiver, destinationAmount);
788 
789         //Transfers the rest of destinationToken, if any, to the sender
790         if (receivedAmount > destinationAmount) {
791             uint rest = receivedAmount.sub(destinationAmount);
792 
793             transferTokens(destinationToken, payer, rest);
794         }
795 
796         emit Payed(
797             receiver,
798             sourceToken,
799             destinationToken,
800             sourceAmount,
801             receivedAmount,
802             referrer
803         );
804     }
805 
806     /**
807    * @dev The function which performs the actual swap.
808    * The call data to the actual exchanges must be built offchain
809    * and then sent to this method. It will be call those external exchanges using
810    * data passed through externalCall function
811    * It is a nonreentrant function
812    * @param sourceToken Address of the source token
813    * @param destinationToken Address of the destination token
814    * @param sourceAmount Amount of source tokens to be swapped
815    * @param minDestinationAmount Minimu destination token amount expected out of this swap
816    * @param callees Address of the external callee. This will also contain address of exchanges
817    * where actual swap will happen
818    * @param exchangeData Concatenated data to be sent in external call to the above callees
819    * @param startIndexes start index of calldata in above data structure for each callee
820    * @param values Amount of ethers to be sent in external call to each callee
821    * @param mintPrice Price of gas at the time of minting of gas tokens, if any. In wei
822    */
823     function swap(
824         address sourceToken,
825         address destinationToken,
826         uint256 sourceAmount,
827         uint256 minDestinationAmount,
828         address[] memory callees,
829         bytes memory exchangeData,
830         uint256[] memory startIndexes,
831         uint256[] memory values,
832         string memory referrer,
833         uint256 mintPrice
834     )
835     public
836     payable
837     whenNotPaused
838     nonReentrant
839     {
840         uint receivedAmount = performSwap(
841             sourceToken,
842             destinationToken,
843             sourceAmount,
844             minDestinationAmount,
845             callees,
846             exchangeData,
847             startIndexes,
848             values,
849             mintPrice
850         );
851 
852         transferTokens(destinationToken, msg.sender, receivedAmount);
853 
854         emit Swapped(
855             msg.sender,
856             sourceToken,
857             destinationToken,
858             sourceAmount,
859             receivedAmount,
860             referrer
861         );
862     }
863 
864     function performSwap(
865         address sourceToken,
866         address destinationToken,
867         uint256 sourceAmount,
868         uint256 minDestinationAmount,
869         address[] memory callees,
870         bytes memory exchangeData,
871         uint256[] memory startIndexes,
872         uint256[] memory values,
873         uint256 mintPrice
874     )
875     private
876     returns (uint)
877     {
878         //Basic sanity check
879         require(minDestinationAmount > 0, "minDestinationAmount is too low");
880         require(callees.length > 0, "No callee provided!!");
881         require(exchangeData.length > 0, "No exchangeData provided!!");
882         require(
883             callees.length + 1 == startIndexes.length,
884             "Start indexes must be 1 greater then number of callees!!"
885         );
886         require(sourceToken != address(0), "Invalid source token!!");
887         require(destinationToken != address(0), "Inavlid destination address");
888 
889         uint initialGas = gasleft();
890 
891         //If source token is not ETH than transfer required amount of tokens
892         //from sender to this contract
893         if (sourceToken != ETH_ADDRESS) {
894             _tokenTransferProxy.transferFrom(
895                 sourceToken,
896                 msg.sender,
897                 address(this),
898                 sourceAmount
899             );
900         }
901 
902         for (uint256 i = 0; i < callees.length; i++) {
903 
904             require(isWhitelisted(callees[i]), "Callee is not whitelisted!!");
905             require(
906                 callees[i] != address(_tokenTransferProxy),
907                 "Can not call TokenTransferProxy Contract !!"
908             );
909 
910             bool result = externalCall(
911                 callees[i], //destination
912                 values[i], //value to send
913                 startIndexes[i], // start index of call data
914                 startIndexes[i + 1].sub(startIndexes[i]), // length of calldata
915                 exchangeData// total calldata
916             );
917             require(result, "External call failed!!");
918         }
919 
920         uint256 receivedAmount = tokenBalance(destinationToken, address(this));
921 
922         require(
923             receivedAmount >= minDestinationAmount,
924             "Received amount of tokens are less then expected!!"
925         );
926 
927         require(
928             tokenBalance(sourceToken, address(this)) == 0,
929             "The transaction wasn't entirely executed"
930         );
931 
932         uint256 fee = calculateFee(
933             sourceToken,
934             receivedAmount,
935             callees.length
936         );
937 
938         if (fee > 0) {
939             receivedAmount = receivedAmount.sub(fee);
940             transferTokens(destinationToken, _feeWallet, fee);
941         }
942 
943         if (mintPrice > 0) {
944             refundGas(initialGas, mintPrice);
945         }
946 
947         return receivedAmount;
948     }
949 
950     /**
951     * @dev Returns whether given addresses is whitelisted or not
952     * @param account The account to be checked
953     * @return bool
954     */
955     function isWhitelisted(address account) public view returns (bool) {
956         return _whitelisteds[account];
957     }
958 
959     /**
960     * @dev Helper method to refund gas using gas tokens
961     */
962     function refundGas(uint256 initialGas, uint256 mintPrice) private {
963 
964         uint256 mintBase = 32254;
965         uint256 mintToken = 36543;
966         uint256 freeBase = 14154;
967         uint256 freeToken = 6870;
968         uint256 reimburse = 24000;
969 
970         uint256 tokens = initialGas.sub(
971             gasleft()).add(freeBase).div(reimburse.mul(2).sub(freeToken)
972         );
973 
974         uint256 mintCost = mintBase.add(tokens.mul(mintToken));
975         uint256 freeCost = freeBase.add(tokens.mul(freeToken));
976         uint256 maxreimburse = tokens.mul(reimburse);
977 
978         uint256 efficiency = maxreimburse.mul(tx.gasprice).mul(100).div(
979             mintCost.mul(mintPrice).add(freeCost.mul(tx.gasprice))
980         );
981 
982         if (efficiency > 100) {
983             freeGasTokens(tokens);
984         }
985     }
986 
987     /**
988     * @dev Helper method to free gas tokens
989     */
990     function freeGasTokens(uint256 tokens) private {
991 
992         uint256 tokensToFree = tokens;
993         uint256 safeNumTokens = 0;
994         uint256 gas = gasleft();
995 
996         if (gas >= 27710) {
997             safeNumTokens = gas.sub(27710).div(1148 + 5722 + 150);
998         }
999 
1000         if (tokensToFree > safeNumTokens) {
1001             tokensToFree = safeNumTokens;
1002         }
1003 
1004         uint256 gasTokenBal = _gasToken.balanceOf(address(this));
1005 
1006         if (tokensToFree > 0 && gasTokenBal >= tokensToFree) {
1007             _gasToken.freeUpTo(tokensToFree);
1008         }
1009 
1010     }
1011 
1012     /**
1013     * @dev Helper function to transfer tokens to the destination
1014     * @dev token Address of the token to be transferred
1015     * @dev destination Recepient of the token
1016     * @dev amount Amount of tokens to be transferred
1017     */
1018     function transferTokens(
1019         address token,
1020         address payable destination,
1021         uint256 amount
1022     )
1023     private
1024     {
1025         if (token == ETH_ADDRESS) {
1026             destination.transfer(amount);
1027         }
1028         else {
1029             IERC20(token).safeTransfer(destination, amount);
1030         }
1031     }
1032 
1033     /**
1034     * @dev Helper method to calculate fees
1035     * @param receivedAmount Received amount of tokens
1036     */
1037     function calculateFee(
1038         address sourceToken,
1039         uint256 receivedAmount,
1040         uint256 calleesLength
1041     )
1042     private
1043     view
1044     returns (uint256)
1045     {
1046         uint256 fee = 0;
1047         if (sourceToken == ETH_ADDRESS && calleesLength == 1) {
1048             return 0;
1049         }
1050 
1051         else if (sourceToken != ETH_ADDRESS && calleesLength == 2) {
1052             return 0;
1053         }
1054 
1055         if (_fee > 0) {
1056             fee = receivedAmount.mul(_fee).div(10000);
1057         }
1058         return fee;
1059     }
1060 
1061     /**
1062     * @dev Source take from GNOSIS MultiSigWallet
1063     * @dev https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
1064     */
1065     function externalCall(
1066         address destination,
1067         uint256 value,
1068         uint256 dataOffset,
1069         uint dataLength,
1070         bytes memory data
1071     )
1072     private
1073     returns (bool)
1074     {
1075         bool result = false;
1076         assembly {
1077             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
1078 
1079             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
1080             result := call(
1081             sub(gas, 34710), // 34710 is the value that solidity is currently emitting
1082             // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
1083             // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
1084             destination,
1085             value,
1086             add(d, dataOffset),
1087             dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
1088             x,
1089             0                  // Output is ignored, therefore the output size is zero
1090             )
1091         }
1092         return result;
1093     }
1094 
1095     /**
1096     * @dev Helper function to returns balance of a user for a token
1097     * @param token Tokend address
1098     * @param account Account whose balances has to be returned
1099     */
1100     function tokenBalance(
1101         address token,
1102         address account
1103     )
1104     private
1105     view
1106     returns (uint256)
1107     {
1108         if (token == ETH_ADDRESS) {
1109             return account.balance;
1110         } else {
1111             return IERC20(token).balanceOf(account);
1112         }
1113     }
1114 }