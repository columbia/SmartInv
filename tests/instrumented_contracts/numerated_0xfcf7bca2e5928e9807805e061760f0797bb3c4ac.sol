1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-23
3 */
4 
5 pragma solidity 0.5.10;
6 
7 /**
8  * @title SafeMath
9  * @dev Unsigned math operations with safety checks that revert on error
10  */
11 library SafeMath {
12     /**
13      * @dev Multiplies two unsigned integers, reverts on overflow.
14      */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31      */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Adds two unsigned integers, reverts on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63      * reverts when dividing by zero.
64      */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 /**
72  * Utility library of inline functions on addresses
73  */
74 library Address {
75     /**
76      * Returns whether the target address is a contract
77      * @dev This function will return false if invoked during the constructor of a contract,
78      * as the code is not actually created until after the constructor finishes.
79      * @param account address of the account to check
80      * @return whether the target address is a contract
81      */
82     function isContract(address account) internal view returns (bool) {
83         uint256 size;
84         // XXX Currently there is no better way to check if there is a contract in an address
85         // than to check the size of the code at that address.
86         // See https://ethereum.stackexchange.com/a/14016/36603
87         // for more details about how this works.
88         // TODO Check this again before the Serenity release, because all addresses will be
89         // contracts then.
90         // solhint-disable-next-line no-inline-assembly
91         assembly {size := extcodesize(account)}
92         return size > 0;
93     }
94 }
95 
96 /**
97  * @title SafeERC20
98  * @dev Wrappers around ERC20 operations that throw on failure (when the token
99  * contract returns false). Tokens that return no value (and instead revert or
100  * throw on failure) are also supported, non-reverting calls are assumed to be
101  * successful.
102  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
103  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
104  */
105 library SafeERC20 {
106     using SafeMath for uint256;
107     using Address for address;
108 
109     function safeTransfer(IERC20 token, address to, uint256 value) internal {
110         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
111     }
112 
113     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
114         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
115     }
116 
117     function safeApprove(IERC20 token, address spender, uint256 value) internal {
118         // safeApprove should only be called when setting an initial allowance,
119         // or when resetting it to zero. To increase and decrease it, use
120         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
121         require((value == 0) || (token.allowance(address(this), spender) == 0));
122         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
123     }
124 
125     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
126         uint256 newAllowance = token.allowance(address(this), spender).add(value);
127         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
128     }
129 
130     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
131         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
132         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
133     }
134 
135     /**
136      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
137      * on the return value: the return value is optional (but if data is returned, it must equal true).
138      * @param token The token targeted by the call.
139      * @param data The call data (encoded using abi.encode or one of its variants).
140      */
141     function callOptionalReturn(IERC20 token, bytes memory data) private {
142         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
143         // we're implementing it ourselves.
144 
145         // A Solidity high level call has three parts:
146         //  1. The target address is checked to verify it contains contract code
147         //  2. The call itself is made, and success asserted
148         //  3. The return value is decoded, which in turn checks the size of the returned data.
149 
150         require(address(token).isContract());
151 
152         // solhint-disable-next-line avoid-low-level-calls
153         (bool success, bytes memory returndata) = address(token).call(data);
154         require(success);
155 
156         if (returndata.length > 0) {// Return data is optional
157             require(abi.decode(returndata, (bool)));
158         }
159     }
160 }
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://eips.ethereum.org/EIPS/eip-20
165  */
166 interface IERC20 {
167     function transfer(address to, uint256 value) external returns (bool);
168 
169     function approve(address spender, uint256 value) external returns (bool);
170 
171     function transferFrom(address from, address to, uint256 value) external returns (bool);
172 
173     function totalSupply() external view returns (uint256);
174 
175     function balanceOf(address who) external view returns (uint256);
176 
177     function allowance(address owner, address spender) external view returns (uint256);
178 
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  */
189 contract Ownable {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     /**
195      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196      * account.
197      */
198     constructor () internal {
199         _owner = msg.sender;
200         emit OwnershipTransferred(address(0), _owner);
201     }
202 
203     /**
204      * @return the address of the owner.
205      */
206     function owner() public view returns (address) {
207         return _owner;
208     }
209 
210     /**
211      * @dev Throws if called by any account other than the owner.
212      */
213     modifier onlyOwner() {
214         require(isOwner());
215         _;
216     }
217 
218     /**
219      * @return true if `msg.sender` is the owner of the contract.
220      */
221     function isOwner() public view returns (bool) {
222         return msg.sender == _owner;
223     }
224 
225     /**
226      * @dev Allows the current owner to relinquish control of the contract.
227      * It will not be possible to call the functions with the `onlyOwner`
228      * modifier anymore.
229      * @notice Renouncing ownership will leave the contract without an owner,
230      * thereby removing any functionality that is only available to the owner.
231      */
232     function renounceOwnership() public onlyOwner {
233         emit OwnershipTransferred(_owner, address(0));
234         _owner = address(0);
235     }
236 
237     /**
238      * @dev Allows the current owner to transfer control of the contract to a newOwner.
239      * @param newOwner The address to transfer ownership to.
240      */
241     function transferOwnership(address newOwner) public onlyOwner {
242         _transferOwnership(newOwner);
243     }
244 
245     /**
246      * @dev Transfers control of the contract to a newOwner.
247      * @param newOwner The address to transfer ownership to.
248      */
249     function _transferOwnership(address newOwner) internal {
250         require(newOwner != address(0));
251         emit OwnershipTransferred(_owner, newOwner);
252         _owner = newOwner;
253     }
254 }
255 
256 /**
257  * @title AssetsValue
258  * @dev The contract which hold all tokens and ETH as a assets
259  * Also should be responsible for the balance increasing/decreasing and validation
260  */
261 contract AssetsValue {
262     // using safe math calculation
263     using SafeMath for uint256;
264 
265     // for being secure during transactions between users and contract gonna use SafeERC20 lib
266     using SafeERC20 for IERC20;
267 
268     // The id for ETH asset is 0x0 address
269     // the rest assets should have their token contract address
270     address internal _ethAssetIdentificator = address(0);
271 
272     // Order details which is available by JAVA long number
273     struct OrderDetails {
274         // does the order has been deposited
275         bool created;
276         // the 0x0 for Ethereum and ERC contract address for tokens
277         address asset;
278         // tokens/eth amount
279         uint256 amount;
280         // the status (deposited/withdrawn)
281         bool withdrawn;
282         //Creation time
283         uint256 initTimestamp;
284     }
285 
286     // Each user has his own state and details
287     struct User {
288         // user exist validation bool
289         bool exist;
290         // contract order index
291         uint256 index;
292         // contract index (0, 1, 2 ...) => exchange order number (JAVA long number)
293         mapping(uint256 => uint256) orderIdByIndex;
294         // JAVA long number => order details
295         mapping(uint256 => OrderDetails) orders;
296     }
297 
298     // ETH wallet => Assets => value
299     mapping(address => User) private _users;
300 
301     modifier orderIdNotExist(
302         uint256 orderId,
303         address user
304     ) {
305         require(_users[user].orders[orderId].created == false, "orderIdIsNotDeposited: user already deposit this orderId");
306         _;
307     }
308 
309     // Events
310     event AssetDeposited(uint256 orderId, address indexed user, address indexed asset, uint256 amount);
311     event AssetWithdrawal(uint256 orderId, address indexed user, address indexed asset, uint256 amount);
312 
313     // -----------------------------------------
314     // EXTERNAL
315     // -----------------------------------------
316 
317     function deposit(
318         uint256 orderId
319     ) public orderIdNotExist(orderId, msg.sender) payable {
320         require(msg.value != 0, "deposit: user needs to transfer ETH for calling this method");
321 
322         _deposit(orderId, msg.sender, _ethAssetIdentificator, msg.value);
323     }
324 
325     function deposit(
326         uint256 orderId,
327         uint256 amount,
328         address token
329     ) public orderIdNotExist(orderId, msg.sender) {
330         require(token != address(0), "deposit: invalid token address");
331         require(amount != 0, "deposit: user needs to fill transferable tokens amount for calling this method");
332 
333         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
334         _deposit(orderId, msg.sender, token, amount);
335     }
336 
337     function withdraw(
338         uint256 orderId
339     ) external {
340         // validation of the user existion
341         require(_doesUserExist(msg.sender) == true, "withdraw: the user is not active");
342 
343         // storing the order information (asset and amount)
344         OrderDetails memory order = _getDepositedOrderDetails(orderId, msg.sender);
345         address asset = order.asset;
346         uint256 amount = order.amount;
347 
348         // order amount validation, it should not be zero
349         require(order.withdrawn == false, "withdraw: this order Id has been already withdrawn or waiting for the swap");
350 
351         _withdrawOrderBalance(orderId, msg.sender);
352 
353         if (asset == _ethAssetIdentificator) {
354             msg.sender.transfer(amount);
355         } else {
356             IERC20(asset).safeTransfer(msg.sender, amount);
357         }
358 
359         emit AssetWithdrawal(orderId, msg.sender, asset, amount);
360     }
361 
362     // -----------------------------------------
363     // INTERNAL
364     // -----------------------------------------
365 
366     function _deposit(
367         uint256 orderId,
368         address sender,
369         address asset,
370         uint256 amount
371     ) internal {
372         _activateIfUserIsNew(sender);
373         _depositOrderBalance(orderId, sender, asset, amount);
374 
375         _users[sender].index += 1;
376 
377         emit AssetDeposited(orderId, sender, asset, amount);
378     }
379 
380     function _doesUserExist(
381         address user
382     ) internal view returns (bool) {
383         return _users[user].exist;
384     }
385 
386     function _activateIfUserIsNew(
387         address user
388     ) internal returns (bool) {
389         if (_doesUserExist(user) == false) {
390             _users[user].exist = true;
391         }
392         return true;
393     }
394 
395     function _getDepositedOrderDetails(
396         uint256 orderId,
397         address user
398     ) internal view returns (OrderDetails memory order) {
399         return _users[user].orders[orderId];
400     }
401 
402     function _depositOrderBalance(
403         uint256 orderId,
404         address user,
405         address asset,
406         uint256 amount
407     ) internal returns (bool) {
408         _users[user].orderIdByIndex[_users[user].index] = orderId;
409         _users[user].orders[orderId] = OrderDetails(true, asset, amount, false, block.timestamp);
410         return true;
411     }
412 
413     function _withdrawOrderBalance(
414         uint256 orderId,
415         address user
416     ) internal returns (bool) {
417         _users[user].orders[orderId].withdrawn = true;
418         return true;
419     }
420 
421     // -----------------------------------------
422     // GETTERS
423     // -----------------------------------------
424 
425     function doesUserExist(
426         address user
427     ) external view returns (bool) {
428         return _doesUserExist(user);
429     }
430 
431     function getUserFilledDeposits(
432         address user
433     ) external view returns (
434         uint256[] memory orderIds,
435         uint256[] memory amounts,
436         uint256[] memory initTimestamps
437     ) {
438         // amount of deposits which user has been done
439         uint256 depositsLength = _users[user].index;
440 
441         // init empty arrays which should been returned
442         orderIds = new uint256[](depositsLength);
443         amounts = new uint256[](depositsLength);
444         initTimestamps = new uint256[](depositsLength);
445 
446         uint256 j = 0;
447         for (uint256 i = 0; i <= depositsLength; i++) {
448             uint256 orderId = _users[user].orderIdByIndex[i];
449             if (_users[user].orders[orderId].created) {
450                 orderIds[j] = orderId;
451 
452                 OrderDetails memory order = _users[user].orders[orderId];
453                 amounts[j] = order.amount;
454                 initTimestamps[j] = order.initTimestamp;
455                 j++;
456             }
457         }
458 
459         return (
460         orderIds,
461         amounts,
462         initTimestamps
463         );
464     }
465 
466     function getUserDepositsAmount(
467         address user
468     ) external view returns (
469         uint256
470     ) {
471         return _users[user].index;
472     }
473 
474     function getDepositedOrderDetails(
475         uint256 orderId,
476         address user
477     ) external view returns (
478         bool created,
479         address asset,
480         uint256 amount,
481         bool withdrawn
482     ) {
483         OrderDetails memory order = _getDepositedOrderDetails(orderId, user);
484         return (
485         order.created,
486         order.asset,
487         order.amount,
488         order.withdrawn
489         );
490     }
491 }
492 
493 /**
494  * @title CrossBlockchainSwap
495  * @dev Fully autonomous cross-blockchain swapping smart contract
496  */
497 contract CrossBlockchainSwap is AssetsValue, Ownable {
498     // swaps' state
499     enum State {Empty, Filled, Redeemed, Refunded}
500 
501     // users can swap ETH and ERC tokens
502     enum SwapType {ETH, Token}
503 
504     // the body of each swap
505     struct Swap {
506         uint256 initTimestamp;
507         uint256 refundTimestamp;
508         bytes32 secretHash;
509         bytes32 secret;
510         address initiator;
511         address recipient;
512         address asset;
513         uint256 amount;
514         uint256 orderId;
515         State state;
516     }
517 
518     struct Initiator {
519         // contract order index
520         uint256 index;
521         // length of filled swaps
522         uint256 filledSwaps;
523         // index (0, 1, 2 ...) => swap hash
524         mapping(uint256 => bytes32) swaps;
525     }
526 
527     // mapping of swaps based on secret hash and swap info
528     mapping(bytes32 => Swap) private _swaps;
529 
530     // the swaps data by initiator address
531     mapping(address => Initiator) private _initiators;
532 
533     // min/max life limits for swap order
534     // can be changed only by the contract owner
535     struct SwapTimeLimits {
536         uint256 min;
537         uint256 max;
538     }
539 
540     // By default, the contract has limits for swap orders lifetime
541     // The swap order can be active from 10 minutes until 6 months
542     SwapTimeLimits private _swapTimeLimits = SwapTimeLimits(10 minutes, 180 days);
543 
544     // -----------------------------------------
545     // EVENTS
546     // -----------------------------------------
547 
548     event Initiated(
549         uint256 orderId,
550         bytes32 secretHash,
551         address indexed initiator,
552         address indexed recipient,
553         uint256 initTimestamp,
554         uint256 refundTimestamp,
555         address indexed asset,
556         uint256 amount
557     );
558 
559     event Redeemed(
560         bytes32 secretHash,
561         uint256 redeemTimestamp,
562         bytes32 secret,
563         address indexed redeemer
564     );
565 
566     event Refunded(
567         uint256 orderId,
568         bytes32 secretHash,
569         uint256 refundTime,
570         address indexed refunder
571     );
572 
573     // -----------------------------------------
574     // MODIFIERS
575     // -----------------------------------------
576 
577     modifier isNotInitiated(bytes32 secretHash) {
578         require(_swaps[secretHash].state == State.Empty, "isNotInitiated: this secret hash was already used, please use another one");
579         _;
580     }
581 
582     modifier isRedeemable(bytes32 secret) {
583         bytes32 secretHash = _hashTheSecret(secret);
584         require(_swaps[secretHash].state == State.Filled, "isRedeemable: the swap with this secretHash does not exist or has been finished");
585         uint256 refundTimestamp = _swaps[secretHash].refundTimestamp;
586         require(refundTimestamp > block.timestamp, "isRedeemable: the redeem is closed for this swap");
587         _;
588     }
589 
590     modifier isRefundable(bytes32 secretHash, address refunder) {
591         require(_swaps[secretHash].state == State.Filled, "isRefundable: the swap with this secretHash does not exist or has been finished");
592         require(_swaps[secretHash].initiator == refunder, "isRefundable: only the initiator of the swap can call this method");
593         uint256 refundTimestamp = _swaps[secretHash].refundTimestamp;
594         require(block.timestamp >= refundTimestamp, "isRefundable: the refund is not available now");
595         _;
596     }
597 
598     // -----------------------------------------
599     // FALLBACK
600     // -----------------------------------------
601 
602     function() external payable {
603         // reverts all fallback & payable transactions
604         revert();
605     }
606 
607     // -----------------------------------------
608     // EXTERNAL
609     // -----------------------------------------
610 
611     /**
612      *  @dev If user wants to swap ERC token, before initiating the swap between that
613      *  initiator need to call approve method from his tokens' smart contract,
614      *  approving to it to spend the value1 amount of tokens
615      *  @param secretHash the encoded secret which they discussed at offline (SHA256)
616      *  @param refundTimestamp the period when the swap should be active
617      *  it should be written in MINUTES
618      */
619     function initiate(
620         uint256 orderId,
621         bytes32 secretHash,
622         address recipient,
623         uint256 refundTimestamp
624     ) public isNotInitiated(secretHash) {
625         // validation that refund Timestamp more than exchange min limit and less then max limit
626         _validateRefundTimestamp(refundTimestamp * 1 minutes);
627 
628         OrderDetails memory order = _getDepositedOrderDetails(orderId, msg.sender);
629 
630         // validation of the deposited order existing and non-zero amount
631         require(order.created == true, "initiate: this order Id has not been created and deposited yet");
632         require(order.withdrawn == false, "initiate: this order deposit has been withdrawn");
633         require(order.amount != 0, "initiate: this order Id has been withdrawn, finished or waiting for the redeem");
634 
635         // withdrawing the balance of this orderId from sender deposites
636         _withdrawOrderBalance(orderId, msg.sender);
637 
638         // swap asset details
639         _swaps[secretHash].asset = order.asset;
640         _swaps[secretHash].amount = order.amount;
641 
642         // swap status
643         _swaps[secretHash].state = State.Filled;
644 
645         // swap clients
646         _swaps[secretHash].initiator = msg.sender;
647         _swaps[secretHash].recipient = recipient;
648         _swaps[secretHash].secretHash = secretHash;
649         _swaps[secretHash].orderId = orderId;
650 
651         // swap timestapms
652         _swaps[secretHash].initTimestamp = block.timestamp;
653         _swaps[secretHash].refundTimestamp = block.timestamp + (refundTimestamp * 1 minutes);
654 
655         // updating the initiator state
656         Initiator storage initiator = _initiators[msg.sender];
657         initiator.swaps[initiator.index] = secretHash;
658         initiator.index++;
659         initiator.filledSwaps++;
660 
661         emit Initiated(
662             orderId,
663             secretHash,
664             msg.sender,
665             recipient,
666             block.timestamp,
667             refundTimestamp,
668             order.asset,
669             order.amount
670         );
671     }
672 
673     /**
674      *  @dev The participant of swap, who has the secret word and the secret hash can call this method
675      *  and receive assets from contract.
676      *  @param secret which both sides discussed before initialization
677      */
678     function redeem(
679         bytes32 secret
680     ) external isRedeemable(secret) {
681         // storing the secret hash generated from secret
682         bytes32 secretHash = _hashTheSecret(secret);
683 
684         // closing the state of this swap order
685         _swaps[secretHash].state = State.Redeemed;
686 
687         // storing the recipient address
688         address recipient = _swaps[secretHash].recipient;
689 
690         if (_getSwapType(secretHash) == SwapType.ETH) {
691             // converting recipient address to payable address
692             address payable payableReceiver = address(uint160(recipient));
693             // transfer ETH to recipient wallet
694             payableReceiver.transfer(_swaps[secretHash].amount);
695         } else {
696             // transfer tokens to recipient address
697             IERC20(_swaps[secretHash].asset).safeTransfer(recipient, _swaps[secretHash].amount);
698         }
699 
700         // saving the secret
701         _swaps[secretHash].secret = secret;
702 
703         // decrease the filled swapss amount
704         _initiators[_swaps[secretHash].initiator].filledSwaps--;
705 
706         emit Redeemed(
707             secretHash,
708             block.timestamp,
709             secret,
710             recipient
711         );
712     }
713 
714     /**
715      *  @dev The initiator can get back his tokens until refundTimestamp comes,
716      *  after that both sides cannot do anything with this swap
717      *  @param secretHash the encoded secret which they discussed at offline (SHA256)
718      */
719     function refund(
720         bytes32 secretHash
721     ) public isRefundable(secretHash, msg.sender) {
722         _swaps[secretHash].state = State.Refunded;
723         _depositOrderBalance(_swaps[secretHash].orderId, msg.sender, _swaps[secretHash].asset, _swaps[secretHash].amount);
724 
725         // decrease the filled swapss amount
726         _initiators[msg.sender].filledSwaps--;
727 
728         emit Refunded(
729             _swaps[secretHash].orderId,
730             secretHash,
731             block.timestamp,
732             msg.sender
733         );
734     }
735 
736     /**
737      *  @dev The owner can change time limits for swap lifetime
738      *  Amounts should be written in MINUTES
739      */
740     function changeSwapLifetimeLimits(
741         uint256 newMin,
742         uint256 newMax
743     ) external onlyOwner {
744         require(newMin != 0, "changeSwapLifetimeLimits: newMin and newMax should be bigger then 0");
745         require(newMax >= newMin, "changeSwapLifetimeLimits: the newMax should be bigger then newMax");
746 
747         _swapTimeLimits = SwapTimeLimits(newMin * 1 minutes, newMax * 1 minutes);
748     }
749 
750     // -----------------------------------------
751     // INTERNAL
752     // -----------------------------------------
753 
754     /**
755      *  @dev Validating the period time of swap
756      * It should be equal/bigger than 10 minutes and equal/less than 180 days
757      */
758     function _validateRefundTimestamp(
759         uint256 refundTimestamp
760     ) private view {
761         require(refundTimestamp >= _swapTimeLimits.min, "_validateRefundTimestamp: the timestamp should be bigger than min swap lifetime");
762         require(_swapTimeLimits.max >= refundTimestamp, "_validateRefundTimestamp: the timestamp should be smaller than max swap lifetime");
763     }
764 
765     function _hashTheSecret(
766         bytes32 secret
767     ) private pure returns (bytes32) {
768         return sha256(abi.encodePacked(secret));
769     }
770 
771     function _getSwapType(
772         bytes32 secretHash
773     ) private view returns (SwapType tp) {
774         if (_swaps[secretHash].asset == _ethAssetIdentificator) {
775             return SwapType.ETH;
776         } else {
777             return SwapType.Token;
778         }
779     }
780 
781     // -----------------------------------------
782     // GETTERS
783     // -----------------------------------------
784 
785     /**
786      *  @dev Get filled swaps order ids and amounts
787      *  @return uint256[] of order ids
788      *  @return uint256[] of amounts
789      */
790     function getUserFilledOrders(address user) external view returns (
791         uint256[] memory amounts,
792         uint256[] memory orderIds,
793         uint256[] memory initTimestamps
794     ) {
795         uint256 swapsLength = _initiators[user].index;
796         uint256 filledSwaps = _initiators[user].filledSwaps;
797 
798         orderIds = new uint256[](filledSwaps);
799         amounts = new uint256[](filledSwaps);
800         initTimestamps = new uint256[](filledSwaps);
801 
802         uint256 j = 0;
803         for (uint256 i = 0; i <= swapsLength; i++) {
804             Swap memory swap = _swaps[_initiators[user].swaps[i]];
805             if (swap.state == State.Filled) {
806                 amounts[j] = swap.amount;
807                 orderIds[j] = swap.orderId;
808                 initTimestamps[j] = swap.initTimestamp;
809                 j++;
810             }
811         }
812 
813         return (
814         orderIds,
815         amounts,
816         initTimestamps
817         );
818     }
819 
820     /**
821      *  @dev Get limits of a lifetime for swap in minutes
822      *  @return min lifetime
823      *  @return max lifetime
824      */
825     function getSwapLifetimeLimits() public view returns (uint256, uint256) {
826         return (
827         _swapTimeLimits.min,
828         _swapTimeLimits.max
829         );
830     }
831 
832     /**
833      *  @dev Identification of the swap type with assets and value fields
834      *  @param secretHash the encoded secret which they discussed at offline (SHA256)
835      *  @return tp (type) of swap
836      */
837     function getSwapType(
838         bytes32 secretHash
839     ) public view returns (SwapType tp) {
840         return _getSwapType(secretHash);
841     }
842 
843     /**
844      *  @dev Check the secret hash for existence, it can be used in UI for form validation
845      *  @param secretHash the encoded secret which they discussed at offline (SHA256)
846      *  @return state of this swap
847      */
848     function getSwapData(
849         bytes32 secretHash
850     ) external view returns (
851         uint256,
852         uint256,
853         bytes32,
854         bytes32,
855         address,
856         address,
857         address,
858         uint256,
859         State state
860     ) {
861         Swap memory swap = _swaps[secretHash];
862         return (
863         swap.initTimestamp,
864         swap.refundTimestamp,
865         swap.secretHash,
866         swap.secret,
867         swap.initiator,
868         swap.recipient,
869         swap.asset,
870         swap.amount,
871         swap.state
872         );
873     }
874 
875 }