1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 library SafeMath {
76     /**
77      * @dev Returns the addition of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return sub(a, b, "SafeMath: subtraction overflow");
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      * - Subtraction cannot overflow.
113      *
114      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
115      * @dev Get it via `npm install @openzeppelin/contracts@next`.
116      */
117     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172 
173      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
174      * @dev Get it via `npm install @openzeppelin/contracts@next`.
175      */
176     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         // Solidity only automatically asserts when dividing by 0
178         require(b > 0, errorMessage);
179         uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * Reverts when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      * - The divisor cannot be zero.
195      */
196     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
197         return mod(a, b, "SafeMath: modulo by zero");
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts with custom message when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      *
211      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
212      * @dev Get it via `npm install @openzeppelin/contracts@next`.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b != 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * This test is non-exhaustive, and there may be false-negatives: during the
225      * execution of a contract's constructor, its address will be reported as
226      * not containing a contract.
227      *
228      * IMPORTANT: It is unsafe to assume that an address for which this
229      * function returns false is an externally-owned account (EOA) and not a
230      * contract.
231      */
232     function isContract(address account) internal view returns (bool) {
233         // This method relies in extcodesize, which returns 0 for contracts in
234         // construction, since the code is only stored at the end of the
235         // constructor execution.
236 
237         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
238         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
239         // for accounts without code, i.e. `keccak256('')`
240         bytes32 codehash;
241         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
242         // solhint-disable-next-line no-inline-assembly
243         assembly { codehash := extcodehash(account) }
244         return (codehash != 0x0 && codehash != accountHash);
245     }
246 
247     /**
248      * @dev Converts an `address` into `address payable`. Note that this is
249      * simply a type cast: the actual underlying value is not changed.
250      *
251      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
252      * @dev Get it via `npm install @openzeppelin/contracts@next`.
253      */
254     function toPayable(address account) internal pure returns (address payable) {
255         return address(uint160(account));
256     }
257 }
258 
259 library SafeERC20 {
260     using SafeMath for uint256;
261     using Address for address;
262 
263     function safeTransfer(IERC20 token, address to, uint256 value) internal {
264         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
265     }
266 
267     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
268         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
269     }
270 
271     function safeApprove(IERC20 token, address spender, uint256 value) internal {
272         // safeApprove should only be called when setting an initial allowance,
273         // or when resetting it to zero. To increase and decrease it, use
274         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
275         // solhint-disable-next-line max-line-length
276         require((value == 0) || (token.allowance(address(this), spender) == 0),
277             "SafeERC20: approve from non-zero to non-zero allowance"
278         );
279         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
280     }
281 
282     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
283         uint256 newAllowance = token.allowance(address(this), spender).add(value);
284         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
285     }
286 
287     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
288         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
289         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
290     }
291 
292     /**
293      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
294      * on the return value: the return value is optional (but if data is returned, it must not be false).
295      * @param token The token targeted by the call.
296      * @param data The call data (encoded using abi.encode or one of its variants).
297      */
298     function callOptionalReturn(IERC20 token, bytes memory data) private {
299         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
300         // we're implementing it ourselves.
301 
302         // A Solidity high level call has three parts:
303         //  1. The target address is checked to verify it contains contract code
304         //  2. The call itself is made, and success asserted
305         //  3. The return value is decoded, which in turn checks the size of the returned data.
306         // solhint-disable-next-line max-line-length
307         require(address(token).isContract(), "SafeERC20: call to non-contract");
308 
309         // solhint-disable-next-line avoid-low-level-calls
310         (bool success, bytes memory returndata) = address(token).call(data);
311         require(success, "SafeERC20: low-level call failed");
312 
313         if (returndata.length > 0) { // Return data is optional
314             // solhint-disable-next-line max-line-length
315             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
316         }
317     }
318 }
319 
320 library Math {
321     /**
322      * @dev Returns the largest of two numbers.
323      */
324     function max(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a >= b ? a : b;
326     }
327 
328     /**
329      * @dev Returns the smallest of two numbers.
330      */
331     function min(uint256 a, uint256 b) internal pure returns (uint256) {
332         return a < b ? a : b;
333     }
334 
335     /**
336      * @dev Returns the average of two numbers. The result is rounded towards
337      * zero.
338      */
339     function average(uint256 a, uint256 b) internal pure returns (uint256) {
340         // (a + b) / 2 can overflow, so we distribute
341         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
342     }
343 }
344 
345 contract EpochTokenLocker {
346     using SafeMath for uint256;
347 
348     /** @dev Number of seconds a batch is lasting*/
349     uint32 public constant BATCH_TIME = 300;
350 
351     // User => Token => BalanceState
352     mapping(address => mapping(address => BalanceState)) private balanceStates;
353 
354     // user => token => lastCreditBatchId
355     mapping(address => mapping(address => uint32)) public lastCreditBatchId;
356 
357     struct BalanceState {
358         uint256 balance;
359         PendingFlux pendingDeposits; // deposits will be credited in any future epoch, i.e. currentStateIndex > batchId
360         PendingFlux pendingWithdraws; // withdraws are allowed in any future epoch, i.e. currentStateIndex > batchId
361     }
362 
363     struct PendingFlux {
364         uint256 amount;
365         uint32 batchId;
366     }
367 
368     event Deposit(address indexed user, address indexed token, uint256 amount, uint32 batchId);
369 
370     event WithdrawRequest(address indexed user, address indexed token, uint256 amount, uint32 batchId);
371 
372     event Withdraw(address indexed user, address indexed token, uint256 amount);
373 
374     /** @dev credits user with deposit amount on next epoch (given by getCurrentBatchId)
375       * @param token address of token to be deposited
376       * @param amount number of token(s) to be credited to user's account
377       *
378       * Emits an {Deposit} event with relevent deposit information.
379       *
380       * Requirements:
381       * - token transfer to contract is successfull
382       */
383     function deposit(address token, uint256 amount) public {
384         updateDepositsBalance(msg.sender, token);
385         SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), amount);
386         // solhint-disable-next-line max-line-length
387         balanceStates[msg.sender][token].pendingDeposits.amount = balanceStates[msg.sender][token].pendingDeposits.amount.add(
388             amount
389         );
390         balanceStates[msg.sender][token].pendingDeposits.batchId = getCurrentBatchId();
391         emit Deposit(msg.sender, token, amount, getCurrentBatchId());
392     }
393 
394     /** @dev Signals and initiates user's intent to withdraw.
395       * @param token address of token to be withdrawn
396       * @param amount number of token(s) to be withdrawn
397       *
398       * Emits an {WithdrawRequest} event with relevent request information.
399       */
400     function requestWithdraw(address token, uint256 amount) public {
401         requestFutureWithdraw(token, amount, getCurrentBatchId());
402     }
403 
404     /** @dev Signals and initiates user's intent to withdraw.
405       * @param token address of token to be withdrawn
406       * @param amount number of token(s) to be withdrawn
407       * @param batchId state index at which request is to be made.
408       *
409       * Emits an {WithdrawRequest} event with relevent request information.
410       */
411     function requestFutureWithdraw(address token, uint256 amount, uint32 batchId) public {
412         // First process pendingWithdraw (if any), as otherwise balances might increase for currentBatchId - 1
413         if (hasValidWithdrawRequest(msg.sender, token)) {
414             withdraw(msg.sender, token);
415         }
416         require(batchId >= getCurrentBatchId(), "Request cannot be made in the past");
417         balanceStates[msg.sender][token].pendingWithdraws = PendingFlux({amount: amount, batchId: batchId});
418         emit WithdrawRequest(msg.sender, token, amount, batchId);
419     }
420 
421     /** @dev Claims pending withdraw - can be called on behalf of others
422       * @param token address of token to be withdrawn
423       * @param user address of user who withdraw is being claimed.
424       *
425       * Emits an {Withdraw} event stating that `user` withdrew `amount` of `token`
426       *
427       * Requirements:
428       * - withdraw was requested in previous epoch
429       * - token was received from exchange in current auction batch
430       */
431     function withdraw(address user, address token) public {
432         updateDepositsBalance(user, token); // withdrawn amount may have been deposited in previous epoch
433         require(
434             balanceStates[user][token].pendingWithdraws.batchId < getCurrentBatchId(),
435             "withdraw was not registered previously"
436         );
437         require(
438             lastCreditBatchId[user][token] < getCurrentBatchId(),
439             "Withdraw not possible for token that is traded in the current auction"
440         );
441         uint256 amount = Math.min(balanceStates[user][token].balance, balanceStates[user][token].pendingWithdraws.amount);
442 
443         balanceStates[user][token].balance = balanceStates[user][token].balance.sub(amount);
444         delete balanceStates[user][token].pendingWithdraws;
445 
446         SafeERC20.safeTransfer(IERC20(token), user, amount);
447         emit Withdraw(user, token, amount);
448     }
449     /**
450      * Public view functions
451      */
452 
453     /** @dev getter function used to display pending deposit
454       * @param user address of user
455       * @param token address of ERC20 token
456       * return amount and batchId of deposit's transfer if any (else 0)
457       */
458     function getPendingDeposit(address user, address token) public view returns (uint256, uint32) {
459         PendingFlux memory pendingDeposit = balanceStates[user][token].pendingDeposits;
460         return (pendingDeposit.amount, pendingDeposit.batchId);
461     }
462 
463     /** @dev getter function used to display pending withdraw
464       * @param user address of user
465       * @param token address of ERC20 token
466       * return amount and batchId when withdraw was requested if any (else 0)
467       */
468     function getPendingWithdraw(address user, address token) public view returns (uint256, uint32) {
469         PendingFlux memory pendingWithdraw = balanceStates[user][token].pendingWithdraws;
470         return (pendingWithdraw.amount, pendingWithdraw.batchId);
471     }
472 
473     /** @dev getter function to determine current auction id.
474       * return current batchId
475       */
476     function getCurrentBatchId() public view returns (uint32) {
477         // solhint-disable-next-line not-rely-on-time
478         return uint32(now / BATCH_TIME);
479     }
480 
481     /** @dev used to determine how much time is left in a batch
482       * return seconds remaining in current batch
483       */
484     function getSecondsRemainingInBatch() public view returns (uint256) {
485         // solhint-disable-next-line not-rely-on-time
486         return BATCH_TIME - (now % BATCH_TIME);
487     }
488 
489     /** @dev fetches and returns user's balance
490       * @param user address of user
491       * @param token address of ERC20 token
492       * return Current `token` balance of `user`'s account
493       */
494     function getBalance(address user, address token) public view returns (uint256) {
495         uint256 balance = balanceStates[user][token].balance;
496         if (balanceStates[user][token].pendingDeposits.batchId < getCurrentBatchId()) {
497             balance = balance.add(balanceStates[user][token].pendingDeposits.amount);
498         }
499         if (balanceStates[user][token].pendingWithdraws.batchId < getCurrentBatchId()) {
500             balance = balance.sub(Math.min(balanceStates[user][token].pendingWithdraws.amount, balance));
501         }
502         return balance;
503     }
504 
505     /** @dev Used to determine if user has a valid pending withdraw request of specific token
506       * @param user address of user
507       * @param token address of ERC20 token
508       * return true if `user` has valid withdraw request for `token`, otherwise false
509       */
510     function hasValidWithdrawRequest(address user, address token) public view returns (bool) {
511         return
512             balanceStates[user][token].pendingWithdraws.batchId < getCurrentBatchId() &&
513             balanceStates[user][token].pendingWithdraws.batchId > 0;
514     }
515 
516     /**
517      * internal functions
518      */
519     /**
520      * The following function should be used to update any balances within an epoch, which
521      * will not be immediately final. E.g. the BatchExchange credits new balances to
522      * the buyers in an auction, but as there are might be better solutions, the updates are
523      * not final. In order to prevent withdraws from non-final updates, we disallow withdraws
524      * by setting lastCreditBatchId to the current batchId and allow only withdraws in batches
525      * with a higher batchId.
526      */
527     function addBalanceAndBlockWithdrawForThisBatch(address user, address token, uint256 amount) internal {
528         if (hasValidWithdrawRequest(user, token)) {
529             lastCreditBatchId[user][token] = getCurrentBatchId();
530         }
531         addBalance(user, token, amount);
532     }
533 
534     function addBalance(address user, address token, uint256 amount) internal {
535         updateDepositsBalance(user, token);
536         balanceStates[user][token].balance = balanceStates[user][token].balance.add(amount);
537     }
538 
539     /**
540      * The following function should be used to subtract amounts from the current balances state.
541      * For the substraction the current withdrawRequests are considered and they are effectively reducing
542      * the available balance.
543      */
544     function subtractBalance(address user, address token, uint256 amount) internal {
545         require(amount <= getBalance(user, token), "Amount exceeds user's balance.");
546         subtractBalanceUnchecked(user, token, amount);
547     }
548 
549     /**
550      * The following function should be used to substract amounts from the current balance
551      * state, if the pending withdrawRequests are not considered and should not effectively reduce
552      * the available balance.
553      * For example, the reversion of trades from a previous batch-solution do not
554      * need to consider withdrawRequests. This is the case as withdraws are blocked for one
555      * batch for accounts having credited funds in a previous submission.
556      * PendingWithdraws must also be ignored since otherwise for the reversion of trades,
557      * a solution reversion could be blocked: A bigger withdrawRequest could set the return value of
558      * getBalance(user, token) to zero, although the user was just credited tokens in
559      * the last submission. In this situation, during the unwinding of the previous orders,
560      * the check `amount <= getBalance(user, token)` would fail and the reversion would be blocked.
561      */
562     function subtractBalanceUnchecked(address user, address token, uint256 amount) internal {
563         updateDepositsBalance(user, token);
564         balanceStates[user][token].balance = balanceStates[user][token].balance.sub(amount);
565     }
566 
567     function updateDepositsBalance(address user, address token) private {
568         uint256 batchId = balanceStates[user][token].pendingDeposits.batchId;
569         if (batchId > 0 && batchId < getCurrentBatchId()) {
570             // batchId > 0 is checked in order save an SSTORE in case there is no pending deposit
571             balanceStates[user][token].balance = balanceStates[user][token].balance.add(
572                 balanceStates[user][token].pendingDeposits.amount
573             );
574             delete balanceStates[user][token].pendingDeposits;
575         }
576     }
577 }
578 
579 library IdToAddressBiMap {
580     struct Data {
581         mapping(uint16 => address) idToAddress;
582         mapping(address => uint16) addressToId;
583     }
584 
585     function hasId(Data storage self, uint16 id) public view returns (bool) {
586         return self.idToAddress[id + 1] != address(0);
587     }
588 
589     function hasAddress(Data storage self, address addr) public view returns (bool) {
590         return self.addressToId[addr] != 0;
591     }
592 
593     function getAddressAt(Data storage self, uint16 id) public view returns (address) {
594         require(hasId(self, id), "Must have ID to get Address");
595         return self.idToAddress[id + 1];
596     }
597 
598     function getId(Data storage self, address addr) public view returns (uint16) {
599         require(hasAddress(self, addr), "Must have Address to get ID");
600         return self.addressToId[addr] - 1;
601     }
602 
603     function insert(Data storage self, uint16 id, address addr) public returns (bool) {
604         require(addr != address(0), "Cannot insert zero address");
605         require(id != uint16(-1), "Cannot insert max uint16");
606         // Ensure bijectivity of the mappings
607         if (self.addressToId[addr] != 0 || self.idToAddress[id + 1] != address(0)) {
608             return false;
609         }
610         self.idToAddress[id + 1] = addr;
611         self.addressToId[addr] = id + 1;
612         return true;
613     }
614 
615 }
616 
617 library IterableAppendOnlySet {
618     struct Data {
619         mapping(address => address) nextMap;
620         address last;
621     }
622 
623     function insert(Data storage self, address value) public returns (bool) {
624         if (contains(self, value)) {
625             return false;
626         }
627         self.nextMap[self.last] = value;
628         self.last = value;
629         return true;
630     }
631 
632     function contains(Data storage self, address value) public view returns (bool) {
633         require(value != address(0), "Inserting address(0) is not supported");
634         return self.nextMap[value] != address(0) || (self.last == value);
635     }
636 
637     function first(Data storage self) public view returns (address) {
638         require(self.last != address(0), "Trying to get first from empty set");
639         return self.nextMap[address(0)];
640     }
641 
642     function next(Data storage self, address value) public view returns (address) {
643         require(contains(self, value), "Trying to get next of non-existent element");
644         require(value != self.last, "Trying to get next of last element");
645         return self.nextMap[value];
646     }
647 
648     function size(Data storage self) public view returns (uint256) {
649         if (self.last == address(0)) {
650             return 0;
651         }
652         uint256 count = 1;
653         address current = first(self);
654         while (current != self.last) {
655             current = next(self, current);
656             count++;
657         }
658         return count;
659     }
660 
661     function atIndex(Data storage self, uint256 index) public view returns (address) {
662         require(index < size(self), "requested index too large");
663         address res = first(self);
664         for (uint256 i = 0; i < index; i++) {
665             res = next(self, res);
666         }
667         return res;
668     }
669 }
670 
671 library GnosisMath {
672     /*
673      *  Constants
674      */
675     // This is equal to 1 in our calculations
676     uint public constant ONE = 0x10000000000000000;
677     uint public constant LN2 = 0xb17217f7d1cf79ac;
678     uint public constant LOG2_E = 0x171547652b82fe177;
679 
680     /*
681      *  Public functions
682      */
683     /// @dev Returns natural exponential function value of given x
684     /// @param x x
685     /// @return e**x
686     function exp(int x) public pure returns (uint) {
687         // revert if x is > MAX_POWER, where
688         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
689         require(x <= 2454971259878909886679);
690         // return 0 if exp(x) is tiny, using
691         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
692         if (x < -818323753292969962227) return 0;
693         // Transform so that e^x -> 2^x
694         x = x * int(ONE) / int(LN2);
695         // 2^x = 2^whole(x) * 2^frac(x)
696         //       ^^^^^^^^^^ is a bit shift
697         // so Taylor expand on z = frac(x)
698         int shift;
699         uint z;
700         if (x >= 0) {
701             shift = x / int(ONE);
702             z = uint(x % int(ONE));
703         } else {
704             shift = x / int(ONE) - 1;
705             z = ONE - uint(-x % int(ONE));
706         }
707         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
708         //
709         // Can generate the z coefficients using mpmath and the following lines
710         // >>> from mpmath import mp
711         // >>> mp.dps = 100
712         // >>> ONE =  0x10000000000000000
713         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
714         // 0xb17217f7d1cf79ab
715         // 0x3d7f7bff058b1d50
716         // 0xe35846b82505fc5
717         // 0x276556df749cee5
718         // 0x5761ff9e299cc4
719         // 0xa184897c363c3
720         uint zpow = z;
721         uint result = ONE;
722         result += 0xb17217f7d1cf79ab * zpow / ONE;
723         zpow = zpow * z / ONE;
724         result += 0x3d7f7bff058b1d50 * zpow / ONE;
725         zpow = zpow * z / ONE;
726         result += 0xe35846b82505fc5 * zpow / ONE;
727         zpow = zpow * z / ONE;
728         result += 0x276556df749cee5 * zpow / ONE;
729         zpow = zpow * z / ONE;
730         result += 0x5761ff9e299cc4 * zpow / ONE;
731         zpow = zpow * z / ONE;
732         result += 0xa184897c363c3 * zpow / ONE;
733         zpow = zpow * z / ONE;
734         result += 0xffe5fe2c4586 * zpow / ONE;
735         zpow = zpow * z / ONE;
736         result += 0x162c0223a5c8 * zpow / ONE;
737         zpow = zpow * z / ONE;
738         result += 0x1b5253d395e * zpow / ONE;
739         zpow = zpow * z / ONE;
740         result += 0x1e4cf5158b * zpow / ONE;
741         zpow = zpow * z / ONE;
742         result += 0x1e8cac735 * zpow / ONE;
743         zpow = zpow * z / ONE;
744         result += 0x1c3bd650 * zpow / ONE;
745         zpow = zpow * z / ONE;
746         result += 0x1816193 * zpow / ONE;
747         zpow = zpow * z / ONE;
748         result += 0x131496 * zpow / ONE;
749         zpow = zpow * z / ONE;
750         result += 0xe1b7 * zpow / ONE;
751         zpow = zpow * z / ONE;
752         result += 0x9c7 * zpow / ONE;
753         if (shift >= 0) {
754             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
755             return result << shift;
756         } else return result >> (-shift);
757     }
758 
759     /// @dev Returns natural logarithm value of given x
760     /// @param x x
761     /// @return ln(x)
762     function ln(uint x) public pure returns (int) {
763         require(x > 0);
764         // binary search for floor(log2(x))
765         int ilog2 = floorLog2(x);
766         int z;
767         if (ilog2 < 0) z = int(x << uint(-ilog2));
768         else z = int(x >> uint(ilog2));
769         // z = x * 2^-⌊log₂x⌋
770         // so 1 <= z < 2
771         // and ln z = ln x - ⌊log₂x⌋/log₂e
772         // so just compute ln z using artanh series
773         // and calculate ln x from that
774         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
775         int halflnz = term;
776         int termpow = term * term / int(ONE) * term / int(ONE);
777         halflnz += termpow / 3;
778         termpow = termpow * term / int(ONE) * term / int(ONE);
779         halflnz += termpow / 5;
780         termpow = termpow * term / int(ONE) * term / int(ONE);
781         halflnz += termpow / 7;
782         termpow = termpow * term / int(ONE) * term / int(ONE);
783         halflnz += termpow / 9;
784         termpow = termpow * term / int(ONE) * term / int(ONE);
785         halflnz += termpow / 11;
786         termpow = termpow * term / int(ONE) * term / int(ONE);
787         halflnz += termpow / 13;
788         termpow = termpow * term / int(ONE) * term / int(ONE);
789         halflnz += termpow / 15;
790         termpow = termpow * term / int(ONE) * term / int(ONE);
791         halflnz += termpow / 17;
792         termpow = termpow * term / int(ONE) * term / int(ONE);
793         halflnz += termpow / 19;
794         termpow = termpow * term / int(ONE) * term / int(ONE);
795         halflnz += termpow / 21;
796         termpow = termpow * term / int(ONE) * term / int(ONE);
797         halflnz += termpow / 23;
798         termpow = termpow * term / int(ONE) * term / int(ONE);
799         halflnz += termpow / 25;
800         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
801     }
802 
803     /// @dev Returns base 2 logarithm value of given x
804     /// @param x x
805     /// @return logarithmic value
806     function floorLog2(uint x) public pure returns (int lo) {
807         lo = -64;
808         int hi = 193;
809         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
810         int mid = (hi + lo) >> 1;
811         while ((lo + 1) < hi) {
812             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
813             else lo = mid;
814             mid = (hi + lo) >> 1;
815         }
816     }
817 
818     /// @dev Returns maximum of an array
819     /// @param nums Numbers to look through
820     /// @return Maximum number
821     function max(int[] memory nums) public pure returns (int maxNum) {
822         require(nums.length > 0);
823         maxNum = -2 ** 255;
824         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
825     }
826 
827     /// @dev Returns whether an add operation causes an overflow
828     /// @param a First addend
829     /// @param b Second addend
830     /// @return Did no overflow occur?
831     function safeToAdd(uint a, uint b) internal pure returns (bool) {
832         return a + b >= a;
833     }
834 
835     /// @dev Returns whether a subtraction operation causes an underflow
836     /// @param a Minuend
837     /// @param b Subtrahend
838     /// @return Did no underflow occur?
839     function safeToSub(uint a, uint b) internal pure returns (bool) {
840         return a >= b;
841     }
842 
843     /// @dev Returns whether a multiply operation causes an overflow
844     /// @param a First factor
845     /// @param b Second factor
846     /// @return Did no overflow occur?
847     function safeToMul(uint a, uint b) internal pure returns (bool) {
848         return b == 0 || a * b / b == a;
849     }
850 
851     /// @dev Returns sum if no overflow occurred
852     /// @param a First addend
853     /// @param b Second addend
854     /// @return Sum
855     function add(uint a, uint b) internal pure returns (uint) {
856         require(safeToAdd(a, b));
857         return a + b;
858     }
859 
860     /// @dev Returns difference if no overflow occurred
861     /// @param a Minuend
862     /// @param b Subtrahend
863     /// @return Difference
864     function sub(uint a, uint b) internal pure returns (uint) {
865         require(safeToSub(a, b));
866         return a - b;
867     }
868 
869     /// @dev Returns product if no overflow occurred
870     /// @param a First factor
871     /// @param b Second factor
872     /// @return Product
873     function mul(uint a, uint b) internal pure returns (uint) {
874         require(safeToMul(a, b));
875         return a * b;
876     }
877 
878     /// @dev Returns whether an add operation causes an overflow
879     /// @param a First addend
880     /// @param b Second addend
881     /// @return Did no overflow occur?
882     function safeToAdd(int a, int b) internal pure returns (bool) {
883         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
884     }
885 
886     /// @dev Returns whether a subtraction operation causes an underflow
887     /// @param a Minuend
888     /// @param b Subtrahend
889     /// @return Did no underflow occur?
890     function safeToSub(int a, int b) internal pure returns (bool) {
891         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
892     }
893 
894     /// @dev Returns whether a multiply operation causes an overflow
895     /// @param a First factor
896     /// @param b Second factor
897     /// @return Did no overflow occur?
898     function safeToMul(int a, int b) internal pure returns (bool) {
899         return (b == 0) || (a * b / b == a);
900     }
901 
902     /// @dev Returns sum if no overflow occurred
903     /// @param a First addend
904     /// @param b Second addend
905     /// @return Sum
906     function add(int a, int b) internal pure returns (int) {
907         require(safeToAdd(a, b));
908         return a + b;
909     }
910 
911     /// @dev Returns difference if no overflow occurred
912     /// @param a Minuend
913     /// @param b Subtrahend
914     /// @return Difference
915     function sub(int a, int b) internal pure returns (int) {
916         require(safeToSub(a, b));
917         return a - b;
918     }
919 
920     /// @dev Returns product if no overflow occurred
921     /// @param a First factor
922     /// @param b Second factor
923     /// @return Product
924     function mul(int a, int b) internal pure returns (int) {
925         require(safeToMul(a, b));
926         return a * b;
927     }
928 }
929 
930 contract Token {
931     /*
932      *  Events
933      */
934     event Transfer(address indexed from, address indexed to, uint value);
935     event Approval(address indexed owner, address indexed spender, uint value);
936 
937     /*
938      *  Public functions
939      */
940     function transfer(address to, uint value) public returns (bool);
941     function transferFrom(address from, address to, uint value) public returns (bool);
942     function approve(address spender, uint value) public returns (bool);
943     function balanceOf(address owner) public view returns (uint);
944     function allowance(address owner, address spender) public view returns (uint);
945     function totalSupply() public view returns (uint);
946 }
947 
948 contract Proxied {
949     address public masterCopy;
950 }
951 
952 contract Proxy is Proxied {
953     /// @dev Constructor function sets address of master copy contract.
954     /// @param _masterCopy Master copy address.
955     constructor(address _masterCopy) public {
956         require(_masterCopy != address(0), "The master copy is required");
957         masterCopy = _masterCopy;
958     }
959 
960     /// @dev Fallback function forwards all transactions and returns all received return data.
961     function() external payable {
962         address _masterCopy = masterCopy;
963         assembly {
964             calldatacopy(0, 0, calldatasize)
965             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
966             returndatacopy(0, 0, returndatasize)
967             switch success
968                 case 0 {
969                     revert(0, returndatasize)
970                 }
971                 default {
972                     return(0, returndatasize)
973                 }
974         }
975     }
976 }
977 
978 contract StandardTokenData {
979     /*
980      *  Storage
981      */
982     mapping(address => uint) balances;
983     mapping(address => mapping(address => uint)) allowances;
984     uint totalTokens;
985 }
986 
987 contract GnosisStandardToken is Token, StandardTokenData {
988     using GnosisMath for *;
989 
990     /*
991      *  Public functions
992      */
993     /// @dev Transfers sender's tokens to a given address. Returns success
994     /// @param to Address of token receiver
995     /// @param value Number of tokens to transfer
996     /// @return Was transfer successful?
997     function transfer(address to, uint value) public returns (bool) {
998         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
999             return false;
1000         }
1001 
1002         balances[msg.sender] -= value;
1003         balances[to] += value;
1004         emit Transfer(msg.sender, to, value);
1005         return true;
1006     }
1007 
1008     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
1009     /// @param from Address from where tokens are withdrawn
1010     /// @param to Address to where tokens are sent
1011     /// @param value Number of tokens to transfer
1012     /// @return Was transfer successful?
1013     function transferFrom(address from, address to, uint value) public returns (bool) {
1014         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
1015             value
1016         ) || !balances[to].safeToAdd(value)) {
1017             return false;
1018         }
1019         balances[from] -= value;
1020         allowances[from][msg.sender] -= value;
1021         balances[to] += value;
1022         emit Transfer(from, to, value);
1023         return true;
1024     }
1025 
1026     /// @dev Sets approved amount of tokens for spender. Returns success
1027     /// @param spender Address of allowed account
1028     /// @param value Number of approved tokens
1029     /// @return Was approval successful?
1030     function approve(address spender, uint value) public returns (bool) {
1031         allowances[msg.sender][spender] = value;
1032         emit Approval(msg.sender, spender, value);
1033         return true;
1034     }
1035 
1036     /// @dev Returns number of allowed tokens for given address
1037     /// @param owner Address of token owner
1038     /// @param spender Address of token spender
1039     /// @return Remaining allowance for spender
1040     function allowance(address owner, address spender) public view returns (uint) {
1041         return allowances[owner][spender];
1042     }
1043 
1044     /// @dev Returns number of tokens owned by given address
1045     /// @param owner Address of token owner
1046     /// @return Balance of owner
1047     function balanceOf(address owner) public view returns (uint) {
1048         return balances[owner];
1049     }
1050 
1051     /// @dev Returns total supply of tokens
1052     /// @return Total supply
1053     function totalSupply() public view returns (uint) {
1054         return totalTokens;
1055     }
1056 }
1057 
1058 contract TokenOWL is Proxied, GnosisStandardToken {
1059     using GnosisMath for *;
1060 
1061     string public constant name = "OWL Token";
1062     string public constant symbol = "OWL";
1063     uint8 public constant decimals = 18;
1064 
1065     struct masterCopyCountdownType {
1066         address masterCopy;
1067         uint timeWhenAvailable;
1068     }
1069 
1070     masterCopyCountdownType masterCopyCountdown;
1071 
1072     address public creator;
1073     address public minter;
1074 
1075     event Minted(address indexed to, uint256 amount);
1076     event Burnt(address indexed from, address indexed user, uint256 amount);
1077 
1078     modifier onlyCreator() {
1079         // R1
1080         require(msg.sender == creator, "Only the creator can perform the transaction");
1081         _;
1082     }
1083     /// @dev trickers the update process via the proxyMaster for a new address _masterCopy
1084     /// updating is only possible after 30 days
1085     function startMasterCopyCountdown(address _masterCopy) public onlyCreator {
1086         require(address(_masterCopy) != address(0), "The master copy must be a valid address");
1087 
1088         // Update masterCopyCountdown
1089         masterCopyCountdown.masterCopy = _masterCopy;
1090         masterCopyCountdown.timeWhenAvailable = now + 30 days;
1091     }
1092 
1093     /// @dev executes the update process via the proxyMaster for a new address _masterCopy
1094     function updateMasterCopy() public onlyCreator {
1095         require(address(masterCopyCountdown.masterCopy) != address(0), "The master copy must be a valid address");
1096         require(
1097             block.timestamp >= masterCopyCountdown.timeWhenAvailable,
1098             "It's not possible to update the master copy during the waiting period"
1099         );
1100 
1101         // Update masterCopy
1102         masterCopy = masterCopyCountdown.masterCopy;
1103     }
1104 
1105     function getMasterCopy() public view returns (address) {
1106         return masterCopy;
1107     }
1108 
1109     /// @dev Set minter. Only the creator of this contract can call this.
1110     /// @param newMinter The new address authorized to mint this token
1111     function setMinter(address newMinter) public onlyCreator {
1112         minter = newMinter;
1113     }
1114 
1115     /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.
1116     /// @param newOwner The new address, which should become the owner
1117     function setNewOwner(address newOwner) public onlyCreator {
1118         creator = newOwner;
1119     }
1120 
1121     /// @dev Mints OWL.
1122     /// @param to Address to which the minted token will be given
1123     /// @param amount Amount of OWL to be minted
1124     function mintOWL(address to, uint amount) public {
1125         require(minter != address(0), "The minter must be initialized");
1126         require(msg.sender == minter, "Only the minter can mint OWL");
1127         balances[to] = balances[to].add(amount);
1128         totalTokens = totalTokens.add(amount);
1129         emit Minted(to, amount);
1130         emit Transfer(address(0), to, amount);
1131     }
1132 
1133     /// @dev Burns OWL.
1134     /// @param user Address of OWL owner
1135     /// @param amount Amount of OWL to be burnt
1136     function burnOWL(address user, uint amount) public {
1137         allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
1138         balances[user] = balances[user].sub(amount);
1139         totalTokens = totalTokens.sub(amount);
1140         emit Burnt(msg.sender, user, amount);
1141         emit Transfer(user, address(0), amount);
1142     }
1143 
1144     function getMasterCopyCountdown() public view returns (address, uint) {
1145         return (masterCopyCountdown.masterCopy, masterCopyCountdown.timeWhenAvailable);
1146     }
1147 }
1148 
1149 library SafeCast {
1150 
1151     /**
1152      * @dev Returns the downcasted uint128 from uint256, reverting on
1153      * overflow (when the input is greater than largest uint128).
1154      *
1155      * Counterpart to Solidity's `uint128` operator.
1156      *
1157      * Requirements:
1158      *
1159      * - input must fit into 128 bits
1160      */
1161     function toUint128(uint256 value) internal pure returns (uint128) {
1162         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1163         return uint128(value);
1164     }
1165 
1166     /**
1167      * @dev Returns the downcasted uint64 from uint256, reverting on
1168      * overflow (when the input is greater than largest uint64).
1169      *
1170      * Counterpart to Solidity's `uint64` operator.
1171      *
1172      * Requirements:
1173      *
1174      * - input must fit into 64 bits
1175      */
1176     function toUint64(uint256 value) internal pure returns (uint64) {
1177         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1178         return uint64(value);
1179     }
1180 
1181     /**
1182      * @dev Returns the downcasted uint32 from uint256, reverting on
1183      * overflow (when the input is greater than largest uint32).
1184      *
1185      * Counterpart to Solidity's `uint32` operator.
1186      *
1187      * Requirements:
1188      *
1189      * - input must fit into 32 bits
1190      */
1191     function toUint32(uint256 value) internal pure returns (uint32) {
1192         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1193         return uint32(value);
1194     }
1195 
1196     /**
1197      * @dev Returns the downcasted uint16 from uint256, reverting on
1198      * overflow (when the input is greater than largest uint16).
1199      *
1200      * Counterpart to Solidity's `uint16` operator.
1201      *
1202      * Requirements:
1203      *
1204      * - input must fit into 16 bits
1205      */
1206     function toUint16(uint256 value) internal pure returns (uint16) {
1207         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
1208         return uint16(value);
1209     }
1210 
1211     /**
1212      * @dev Returns the downcasted uint8 from uint256, reverting on
1213      * overflow (when the input is greater than largest uint8).
1214      *
1215      * Counterpart to Solidity's `uint8` operator.
1216      *
1217      * Requirements:
1218      *
1219      * - input must fit into 8 bits.
1220      */
1221     function toUint8(uint256 value) internal pure returns (uint8) {
1222         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
1223         return uint8(value);
1224     }
1225 }
1226 
1227 library BytesLib {
1228     function concat(
1229         bytes memory _preBytes,
1230         bytes memory _postBytes
1231     )
1232         internal
1233         pure
1234         returns (bytes memory)
1235     {
1236         bytes memory tempBytes;
1237 
1238         assembly {
1239             // Get a location of some free memory and store it in tempBytes as
1240             // Solidity does for memory variables.
1241             tempBytes := mload(0x40)
1242 
1243             // Store the length of the first bytes array at the beginning of
1244             // the memory for tempBytes.
1245             let length := mload(_preBytes)
1246             mstore(tempBytes, length)
1247 
1248             // Maintain a memory counter for the current write location in the
1249             // temp bytes array by adding the 32 bytes for the array length to
1250             // the starting location.
1251             let mc := add(tempBytes, 0x20)
1252             // Stop copying when the memory counter reaches the length of the
1253             // first bytes array.
1254             let end := add(mc, length)
1255 
1256             for {
1257                 // Initialize a copy counter to the start of the _preBytes data,
1258                 // 32 bytes into its memory.
1259                 let cc := add(_preBytes, 0x20)
1260             } lt(mc, end) {
1261                 // Increase both counters by 32 bytes each iteration.
1262                 mc := add(mc, 0x20)
1263                 cc := add(cc, 0x20)
1264             } {
1265                 // Write the _preBytes data into the tempBytes memory 32 bytes
1266                 // at a time.
1267                 mstore(mc, mload(cc))
1268             }
1269 
1270             // Add the length of _postBytes to the current length of tempBytes
1271             // and store it as the new length in the first 32 bytes of the
1272             // tempBytes memory.
1273             length := mload(_postBytes)
1274             mstore(tempBytes, add(length, mload(tempBytes)))
1275 
1276             // Move the memory counter back from a multiple of 0x20 to the
1277             // actual end of the _preBytes data.
1278             mc := end
1279             // Stop copying when the memory counter reaches the new combined
1280             // length of the arrays.
1281             end := add(mc, length)
1282 
1283             for {
1284                 let cc := add(_postBytes, 0x20)
1285             } lt(mc, end) {
1286                 mc := add(mc, 0x20)
1287                 cc := add(cc, 0x20)
1288             } {
1289                 mstore(mc, mload(cc))
1290             }
1291 
1292             // Update the free-memory pointer by padding our last write location
1293             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
1294             // next 32 byte block, then round down to the nearest multiple of
1295             // 32. If the sum of the length of the two arrays is zero then add 
1296             // one before rounding down to leave a blank 32 bytes (the length block with 0).
1297             mstore(0x40, and(
1298               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
1299               not(31) // Round down to the nearest 32 bytes.
1300             ))
1301         }
1302 
1303         return tempBytes;
1304     }
1305 
1306     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
1307         assembly {
1308             // Read the first 32 bytes of _preBytes storage, which is the length
1309             // of the array. (We don't need to use the offset into the slot
1310             // because arrays use the entire slot.)
1311             let fslot := sload(_preBytes_slot)
1312             // Arrays of 31 bytes or less have an even value in their slot,
1313             // while longer arrays have an odd value. The actual length is
1314             // the slot divided by two for odd values, and the lowest order
1315             // byte divided by two for even values.
1316             // If the slot is even, bitwise and the slot with 255 and divide by
1317             // two to get the length. If the slot is odd, bitwise and the slot
1318             // with -1 and divide by two.
1319             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
1320             let mlength := mload(_postBytes)
1321             let newlength := add(slength, mlength)
1322             // slength can contain both the length and contents of the array
1323             // if length < 32 bytes so let's prepare for that
1324             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
1325             switch add(lt(slength, 32), lt(newlength, 32))
1326             case 2 {
1327                 // Since the new array still fits in the slot, we just need to
1328                 // update the contents of the slot.
1329                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
1330                 sstore(
1331                     _preBytes_slot,
1332                     // all the modifications to the slot are inside this
1333                     // next block
1334                     add(
1335                         // we can just add to the slot contents because the
1336                         // bytes we want to change are the LSBs
1337                         fslot,
1338                         add(
1339                             mul(
1340                                 div(
1341                                     // load the bytes from memory
1342                                     mload(add(_postBytes, 0x20)),
1343                                     // zero all bytes to the right
1344                                     exp(0x100, sub(32, mlength))
1345                                 ),
1346                                 // and now shift left the number of bytes to
1347                                 // leave space for the length in the slot
1348                                 exp(0x100, sub(32, newlength))
1349                             ),
1350                             // increase length by the double of the memory
1351                             // bytes length
1352                             mul(mlength, 2)
1353                         )
1354                     )
1355                 )
1356             }
1357             case 1 {
1358                 // The stored value fits in the slot, but the combined value
1359                 // will exceed it.
1360                 // get the keccak hash to get the contents of the array
1361                 mstore(0x0, _preBytes_slot)
1362                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
1363 
1364                 // save new length
1365                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
1366 
1367                 // The contents of the _postBytes array start 32 bytes into
1368                 // the structure. Our first read should obtain the `submod`
1369                 // bytes that can fit into the unused space in the last word
1370                 // of the stored array. To get this, we read 32 bytes starting
1371                 // from `submod`, so the data we read overlaps with the array
1372                 // contents by `submod` bytes. Masking the lowest-order
1373                 // `submod` bytes allows us to add that value directly to the
1374                 // stored value.
1375 
1376                 let submod := sub(32, slength)
1377                 let mc := add(_postBytes, submod)
1378                 let end := add(_postBytes, mlength)
1379                 let mask := sub(exp(0x100, submod), 1)
1380 
1381                 sstore(
1382                     sc,
1383                     add(
1384                         and(
1385                             fslot,
1386                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
1387                         ),
1388                         and(mload(mc), mask)
1389                     )
1390                 )
1391 
1392                 for {
1393                     mc := add(mc, 0x20)
1394                     sc := add(sc, 1)
1395                 } lt(mc, end) {
1396                     sc := add(sc, 1)
1397                     mc := add(mc, 0x20)
1398                 } {
1399                     sstore(sc, mload(mc))
1400                 }
1401 
1402                 mask := exp(0x100, sub(mc, end))
1403 
1404                 sstore(sc, mul(div(mload(mc), mask), mask))
1405             }
1406             default {
1407                 // get the keccak hash to get the contents of the array
1408                 mstore(0x0, _preBytes_slot)
1409                 // Start copying to the last used word of the stored array.
1410                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
1411 
1412                 // save new length
1413                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
1414 
1415                 // Copy over the first `submod` bytes of the new data as in
1416                 // case 1 above.
1417                 let slengthmod := mod(slength, 32)
1418                 let mlengthmod := mod(mlength, 32)
1419                 let submod := sub(32, slengthmod)
1420                 let mc := add(_postBytes, submod)
1421                 let end := add(_postBytes, mlength)
1422                 let mask := sub(exp(0x100, submod), 1)
1423 
1424                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
1425                 
1426                 for { 
1427                     sc := add(sc, 1)
1428                     mc := add(mc, 0x20)
1429                 } lt(mc, end) {
1430                     sc := add(sc, 1)
1431                     mc := add(mc, 0x20)
1432                 } {
1433                     sstore(sc, mload(mc))
1434                 }
1435 
1436                 mask := exp(0x100, sub(mc, end))
1437 
1438                 sstore(sc, mul(div(mload(mc), mask), mask))
1439             }
1440         }
1441     }
1442 
1443     function slice(
1444         bytes memory _bytes,
1445         uint _start,
1446         uint _length
1447     )
1448         internal
1449         pure
1450         returns (bytes memory)
1451     {
1452         require(_bytes.length >= (_start + _length));
1453 
1454         bytes memory tempBytes;
1455 
1456         assembly {
1457             switch iszero(_length)
1458             case 0 {
1459                 // Get a location of some free memory and store it in tempBytes as
1460                 // Solidity does for memory variables.
1461                 tempBytes := mload(0x40)
1462 
1463                 // The first word of the slice result is potentially a partial
1464                 // word read from the original array. To read it, we calculate
1465                 // the length of that partial word and start copying that many
1466                 // bytes into the array. The first word we copy will start with
1467                 // data we don't care about, but the last `lengthmod` bytes will
1468                 // land at the beginning of the contents of the new array. When
1469                 // we're done copying, we overwrite the full first word with
1470                 // the actual length of the slice.
1471                 let lengthmod := and(_length, 31)
1472 
1473                 // The multiplication in the next line is necessary
1474                 // because when slicing multiples of 32 bytes (lengthmod == 0)
1475                 // the following copy loop was copying the origin's length
1476                 // and then ending prematurely not copying everything it should.
1477                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
1478                 let end := add(mc, _length)
1479 
1480                 for {
1481                     // The multiplication in the next line has the same exact purpose
1482                     // as the one above.
1483                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
1484                 } lt(mc, end) {
1485                     mc := add(mc, 0x20)
1486                     cc := add(cc, 0x20)
1487                 } {
1488                     mstore(mc, mload(cc))
1489                 }
1490 
1491                 mstore(tempBytes, _length)
1492 
1493                 //update free-memory pointer
1494                 //allocating the array padded to 32 bytes like the compiler does now
1495                 mstore(0x40, and(add(mc, 31), not(31)))
1496             }
1497             //if we want a zero-length slice let's just return a zero-length array
1498             default {
1499                 tempBytes := mload(0x40)
1500 
1501                 mstore(0x40, add(tempBytes, 0x20))
1502             }
1503         }
1504 
1505         return tempBytes;
1506     }
1507 
1508     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
1509         require(_bytes.length >= (_start + 20));
1510         address tempAddress;
1511 
1512         assembly {
1513             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
1514         }
1515 
1516         return tempAddress;
1517     }
1518 
1519     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
1520         require(_bytes.length >= (_start + 1));
1521         uint8 tempUint;
1522 
1523         assembly {
1524             tempUint := mload(add(add(_bytes, 0x1), _start))
1525         }
1526 
1527         return tempUint;
1528     }
1529 
1530     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
1531         require(_bytes.length >= (_start + 2));
1532         uint16 tempUint;
1533 
1534         assembly {
1535             tempUint := mload(add(add(_bytes, 0x2), _start))
1536         }
1537 
1538         return tempUint;
1539     }
1540 
1541     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
1542         require(_bytes.length >= (_start + 4));
1543         uint32 tempUint;
1544 
1545         assembly {
1546             tempUint := mload(add(add(_bytes, 0x4), _start))
1547         }
1548 
1549         return tempUint;
1550     }
1551 
1552     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
1553         require(_bytes.length >= (_start + 8));
1554         uint64 tempUint;
1555 
1556         assembly {
1557             tempUint := mload(add(add(_bytes, 0x8), _start))
1558         }
1559 
1560         return tempUint;
1561     }
1562 
1563     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
1564         require(_bytes.length >= (_start + 12));
1565         uint96 tempUint;
1566 
1567         assembly {
1568             tempUint := mload(add(add(_bytes, 0xc), _start))
1569         }
1570 
1571         return tempUint;
1572     }
1573 
1574     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
1575         require(_bytes.length >= (_start + 16));
1576         uint128 tempUint;
1577 
1578         assembly {
1579             tempUint := mload(add(add(_bytes, 0x10), _start))
1580         }
1581 
1582         return tempUint;
1583     }
1584 
1585     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
1586         require(_bytes.length >= (_start + 32));
1587         uint256 tempUint;
1588 
1589         assembly {
1590             tempUint := mload(add(add(_bytes, 0x20), _start))
1591         }
1592 
1593         return tempUint;
1594     }
1595 
1596     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
1597         require(_bytes.length >= (_start + 32));
1598         bytes32 tempBytes32;
1599 
1600         assembly {
1601             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
1602         }
1603 
1604         return tempBytes32;
1605     }
1606 
1607     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
1608         bool success = true;
1609 
1610         assembly {
1611             let length := mload(_preBytes)
1612 
1613             // if lengths don't match the arrays are not equal
1614             switch eq(length, mload(_postBytes))
1615             case 1 {
1616                 // cb is a circuit breaker in the for loop since there's
1617                 //  no said feature for inline assembly loops
1618                 // cb = 1 - don't breaker
1619                 // cb = 0 - break
1620                 let cb := 1
1621 
1622                 let mc := add(_preBytes, 0x20)
1623                 let end := add(mc, length)
1624 
1625                 for {
1626                     let cc := add(_postBytes, 0x20)
1627                 // the next line is the loop condition:
1628                 // while(uint(mc < end) + cb == 2)
1629                 } eq(add(lt(mc, end), cb), 2) {
1630                     mc := add(mc, 0x20)
1631                     cc := add(cc, 0x20)
1632                 } {
1633                     // if any of these checks fails then arrays are not equal
1634                     if iszero(eq(mload(mc), mload(cc))) {
1635                         // unsuccess:
1636                         success := 0
1637                         cb := 0
1638                     }
1639                 }
1640             }
1641             default {
1642                 // unsuccess:
1643                 success := 0
1644             }
1645         }
1646 
1647         return success;
1648     }
1649 
1650     function equalStorage(
1651         bytes storage _preBytes,
1652         bytes memory _postBytes
1653     )
1654         internal
1655         view
1656         returns (bool)
1657     {
1658         bool success = true;
1659 
1660         assembly {
1661             // we know _preBytes_offset is 0
1662             let fslot := sload(_preBytes_slot)
1663             // Decode the length of the stored array like in concatStorage().
1664             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
1665             let mlength := mload(_postBytes)
1666 
1667             // if lengths don't match the arrays are not equal
1668             switch eq(slength, mlength)
1669             case 1 {
1670                 // slength can contain both the length and contents of the array
1671                 // if length < 32 bytes so let's prepare for that
1672                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
1673                 if iszero(iszero(slength)) {
1674                     switch lt(slength, 32)
1675                     case 1 {
1676                         // blank the last byte which is the length
1677                         fslot := mul(div(fslot, 0x100), 0x100)
1678 
1679                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
1680                             // unsuccess:
1681                             success := 0
1682                         }
1683                     }
1684                     default {
1685                         // cb is a circuit breaker in the for loop since there's
1686                         //  no said feature for inline assembly loops
1687                         // cb = 1 - don't breaker
1688                         // cb = 0 - break
1689                         let cb := 1
1690 
1691                         // get the keccak hash to get the contents of the array
1692                         mstore(0x0, _preBytes_slot)
1693                         let sc := keccak256(0x0, 0x20)
1694 
1695                         let mc := add(_postBytes, 0x20)
1696                         let end := add(mc, mlength)
1697 
1698                         // the next line is the loop condition:
1699                         // while(uint(mc < end) + cb == 2)
1700                         for {} eq(add(lt(mc, end), cb), 2) {
1701                             sc := add(sc, 1)
1702                             mc := add(mc, 0x20)
1703                         } {
1704                             if iszero(eq(sload(sc), mload(mc))) {
1705                                 // unsuccess:
1706                                 success := 0
1707                                 cb := 0
1708                             }
1709                         }
1710                     }
1711                 }
1712             }
1713             default {
1714                 // unsuccess:
1715                 success := 0
1716             }
1717         }
1718 
1719         return success;
1720     }
1721 }
1722 
1723 library SignedSafeMath {
1724     int256 constant private INT256_MIN = -2**255;
1725 
1726     /**
1727      * @dev Multiplies two signed integers, reverts on overflow.
1728      */
1729     function mul(int256 a, int256 b) internal pure returns (int256) {
1730         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1731         // benefit is lost if 'b' is also tested.
1732         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1733         if (a == 0) {
1734             return 0;
1735         }
1736 
1737         require(!(a == -1 && b == INT256_MIN), "SignedSafeMath: multiplication overflow");
1738 
1739         int256 c = a * b;
1740         require(c / a == b, "SignedSafeMath: multiplication overflow");
1741 
1742         return c;
1743     }
1744 
1745     /**
1746      * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
1747      */
1748     function div(int256 a, int256 b) internal pure returns (int256) {
1749         require(b != 0, "SignedSafeMath: division by zero");
1750         require(!(b == -1 && a == INT256_MIN), "SignedSafeMath: division overflow");
1751 
1752         int256 c = a / b;
1753 
1754         return c;
1755     }
1756 
1757     /**
1758      * @dev Subtracts two signed integers, reverts on overflow.
1759      */
1760     function sub(int256 a, int256 b) internal pure returns (int256) {
1761         int256 c = a - b;
1762         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1763 
1764         return c;
1765     }
1766 
1767     /**
1768      * @dev Adds two signed integers, reverts on overflow.
1769      */
1770     function add(int256 a, int256 b) internal pure returns (int256) {
1771         int256 c = a + b;
1772         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1773 
1774         return c;
1775     }
1776 }
1777 
1778 library TokenConservation {
1779     using SignedSafeMath for int256;
1780 
1781     /** @dev initialize the token conservation data structure
1782       * @param tokenIdsForPrice sorted list of tokenIds for which token conservation should be checked
1783       */
1784     function init(uint16[] memory tokenIdsForPrice) internal pure returns (int256[] memory) {
1785         return new int256[](tokenIdsForPrice.length + 1);
1786     }
1787 
1788     /** @dev returns the token imbalance of the fee token
1789       * @param self internal datastructure created by TokenConservation.init()
1790       */
1791     function feeTokenImbalance(int256[] memory self) internal pure returns (int256) {
1792         return self[0];
1793     }
1794 
1795     /** @dev updated token conservation array.
1796       * @param self internal datastructure created by TokenConservation.init()
1797       * @param buyToken id of token whose imbalance should be subtracted from
1798       * @param sellToken id of token whose imbalance should be added to
1799       * @param tokenIdsForPrice sorted list of tokenIds
1800       * @param buyAmount amount to be subtracted at `self[buyTokenIndex]`
1801       * @param sellAmount amount to be added at `self[sellTokenIndex]`
1802       */
1803     function updateTokenConservation(
1804         int256[] memory self,
1805         uint16 buyToken,
1806         uint16 sellToken,
1807         uint16[] memory tokenIdsForPrice,
1808         uint128 buyAmount,
1809         uint128 sellAmount
1810     ) internal pure {
1811         uint256 buyTokenIndex = findPriceIndex(buyToken, tokenIdsForPrice);
1812         uint256 sellTokenIndex = findPriceIndex(sellToken, tokenIdsForPrice);
1813         self[buyTokenIndex] = self[buyTokenIndex].sub(int256(buyAmount));
1814         self[sellTokenIndex] = self[sellTokenIndex].add(int256(sellAmount));
1815     }
1816 
1817     /** @dev Ensures all array's elements are zero except the first.
1818       * @param self internal datastructure created by TokenConservation.init()
1819       * @return true if all, but first element of self are zero else false
1820       */
1821     function checkTokenConservation(int256[] memory self) internal pure {
1822         require(self[0] > 0, "Token conservation at 0 must be positive.");
1823         for (uint256 i = 1; i < self.length; i++) {
1824             require(self[i] == 0, "Token conservation does not hold");
1825         }
1826     }
1827 
1828     /** @dev Token ordering is verified by submitSolution. Required because binary search is used to fetch token info.
1829       * @param tokenIdsForPrice list of tokenIds
1830       * @return true if tokenIdsForPrice is sorted else false
1831       */
1832     function checkPriceOrdering(uint16[] memory tokenIdsForPrice) internal pure returns (bool) {
1833         for (uint256 i = 1; i < tokenIdsForPrice.length; i++) {
1834             if (tokenIdsForPrice[i] <= tokenIdsForPrice[i - 1]) {
1835                 return false;
1836             }
1837         }
1838         return true;
1839     }
1840 
1841     /** @dev implementation of binary search on sorted list returns token id
1842       * @param tokenId element whose index is to be found
1843       * @param tokenIdsForPrice list of (sorted) tokenIds for which binary search is applied.
1844       * @return `index` in `tokenIdsForPrice` where `tokenId` appears (reverts if not found).
1845       */
1846     function findPriceIndex(uint16 tokenId, uint16[] memory tokenIdsForPrice) private pure returns (uint256) {
1847         // Fee token is not included in tokenIdsForPrice
1848         if (tokenId == 0) {
1849             return 0;
1850         }
1851         // binary search for the other tokens
1852         uint256 leftValue = 0;
1853         uint256 rightValue = tokenIdsForPrice.length - 1;
1854         while (rightValue >= leftValue) {
1855             uint256 middleValue = (leftValue + rightValue) / 2;
1856             if (tokenIdsForPrice[middleValue] == tokenId) {
1857                 // shifted one to the right to account for fee token at index 0
1858                 return middleValue + 1;
1859             } else if (tokenIdsForPrice[middleValue] < tokenId) {
1860                 leftValue = middleValue + 1;
1861             } else {
1862                 rightValue = middleValue - 1;
1863             }
1864         }
1865         revert("Price not provided for token");
1866     }
1867 }
1868 
1869 contract BatchExchange is EpochTokenLocker {
1870     using SafeCast for uint256;
1871     using SafeMath for uint128;
1872     using BytesLib for bytes32;
1873     using BytesLib for bytes;
1874     using TokenConservation for int256[];
1875     using TokenConservation for uint16[];
1876     using IterableAppendOnlySet for IterableAppendOnlySet.Data;
1877 
1878     /** @dev Maximum number of touched orders in auction (used in submitSolution) */
1879     uint256 public constant MAX_TOUCHED_ORDERS = 30;
1880 
1881     /** @dev Fee charged for adding a token */
1882     uint256 public constant FEE_FOR_LISTING_TOKEN_IN_OWL = 10 ether;
1883 
1884     /** @dev minimum allowed value (in WEI) of any prices or executed trade amounts */
1885     uint128 public constant AMOUNT_MINIMUM = 10**4;
1886 
1887     /** @dev Numerator or denominator used in orders, which do not track its usedAmount*/
1888     uint128 public constant UNLIMITED_ORDER_AMOUNT = uint128(-1);
1889 
1890     /** Corresponds to percentage that competing solution must improve on current
1891       * (p = IMPROVEMENT_DENOMINATOR + 1 / IMPROVEMENT_DENOMINATOR)
1892       */
1893     uint256 public constant IMPROVEMENT_DENOMINATOR = 100; // 1%
1894 
1895     /** @dev A fixed integer used to evaluate fees as a fraction of trade execution 1/FEE_DENOMINATOR */
1896     uint128 public constant FEE_DENOMINATOR = 1000;
1897 
1898     /** @dev The number of bytes a single auction element is serialized into */
1899     uint128 public constant ENCODED_AUCTION_ELEMENT_WIDTH = 112;
1900 
1901     /** @dev maximum number of tokens that can be listed for exchange */
1902     // solhint-disable-next-line var-name-mixedcase
1903     uint256 public MAX_TOKENS;
1904 
1905     /** @dev Current number of tokens listed/available for exchange */
1906     uint16 public numTokens;
1907 
1908     /** @dev The feeToken of the exchange will be the OWL Token */
1909     TokenOWL public feeToken;
1910 
1911     /** @dev mapping of type userAddress -> List[Order] where all the user's orders are stored */
1912     mapping(address => Order[]) public orders;
1913 
1914     /** @dev mapping of type tokenId -> curentPrice of tokenId */
1915     mapping(uint16 => uint128) public currentPrices;
1916 
1917     /** @dev Sufficient information for current winning auction solution */
1918     SolutionData public latestSolution;
1919 
1920     // Iterable set of all users, required to collect auction information
1921     IterableAppendOnlySet.Data private allUsers;
1922     IdToAddressBiMap.Data private registeredTokens;
1923 
1924     struct Order {
1925         uint16 buyToken;
1926         uint16 sellToken;
1927         uint32 validFrom; // order is valid from auction collection period: validFrom inclusive
1928         uint32 validUntil; // order is valid till auction collection period: validUntil inclusive
1929         uint128 priceNumerator;
1930         uint128 priceDenominator;
1931         uint128 usedAmount; // remainingAmount = priceDenominator - usedAmount
1932     }
1933 
1934     struct TradeData {
1935         address owner;
1936         uint128 volume;
1937         uint16 orderId;
1938     }
1939 
1940     struct SolutionData {
1941         uint32 batchId;
1942         TradeData[] trades;
1943         uint16[] tokenIdsForPrice;
1944         address solutionSubmitter;
1945         uint256 feeReward;
1946         uint256 objectiveValue;
1947     }
1948 
1949     event OrderPlacement(
1950         address indexed owner,
1951         uint16 index,
1952         uint16 indexed buyToken,
1953         uint16 indexed sellToken,
1954         uint32 validFrom,
1955         uint32 validUntil,
1956         uint128 priceNumerator,
1957         uint128 priceDenominator
1958     );
1959 
1960     event TokenListing(address token, uint16 id);
1961 
1962     /** @dev Event emitted when an order is cancelled but still valid in the batch that is
1963      * currently being solved. It remains in storage but will not be tradable in any future
1964      * batch to be solved.
1965      */
1966     event OrderCancellation(address indexed owner, uint16 id);
1967 
1968     /** @dev Event emitted when an order is removed from storage.
1969      */
1970     event OrderDeletion(address indexed owner, uint16 id);
1971 
1972     /** @dev Event emitted when a new trade is settled
1973      */
1974     event Trade(
1975         address indexed owner,
1976         uint16 indexed orderId,
1977         uint16 indexed sellToken,
1978         // Solidity only supports three indexed arguments
1979         uint16 buyToken,
1980         uint128 executedSellAmount,
1981         uint128 executedBuyAmount
1982     );
1983 
1984     /** @dev Event emitted when an already exectued trade gets reverted
1985      */
1986     event TradeReversion(
1987         address indexed owner,
1988         uint16 indexed orderId,
1989         uint16 indexed sellToken,
1990         // Solidity only supports three indexed arguments
1991         uint16 buyToken,
1992         uint128 executedSellAmount,
1993         uint128 executedBuyAmount
1994     );
1995 
1996     /** @dev Event emitted for each solution that is submitted
1997      */
1998     event SolutionSubmission(
1999         address indexed submitter,
2000         uint256 utility,
2001         uint256 disregardedUtility,
2002         uint256 burntFees,
2003         uint256 lastAuctionBurntFees,
2004         uint128[] prices,
2005         uint16[] tokenIdsForPrice
2006     );
2007 
2008     /** @dev Constructor determines exchange parameters
2009       * @param maxTokens The maximum number of tokens that can be listed.
2010       * @param _feeToken Address of ERC20 fee token.
2011       */
2012     constructor(uint256 maxTokens, address _feeToken) public {
2013         // All solutions for the batches must have normalized prices. The following line sets the
2014         // price of OWL to 10**18 for all solutions and hence enforces a normalization.
2015         currentPrices[0] = 1 ether;
2016         MAX_TOKENS = maxTokens;
2017         feeToken = TokenOWL(_feeToken);
2018         // The burn functionallity of OWL requires an approval.
2019         // In the following line the approval is set for all future burn calls.
2020         feeToken.approve(address(this), uint256(-1));
2021         addToken(_feeToken); // feeToken will always have the token index 0
2022     }
2023 
2024     /** @dev Used to list a new token on the contract: Hence, making it available for exchange in an auction.
2025       * @param token ERC20 token to be listed.
2026       *
2027       * Requirements:
2028       * - `maxTokens` has not already been reached
2029       * - `token` has not already been added
2030       */
2031     function addToken(address token) public {
2032         require(numTokens < MAX_TOKENS, "Max tokens reached");
2033         if (numTokens > 0) {
2034             // Only charge fees for tokens other than the fee token itself
2035             feeToken.burnOWL(msg.sender, FEE_FOR_LISTING_TOKEN_IN_OWL);
2036         }
2037         require(IdToAddressBiMap.insert(registeredTokens, numTokens, token), "Token already registered");
2038         emit TokenListing(token, numTokens);
2039         numTokens++;
2040     }
2041 
2042     /** @dev A user facing function used to place limit sell orders in auction with expiry defined by batchId
2043       * @param buyToken id of token to be bought
2044       * @param sellToken id of token to be sold
2045       * @param validUntil batchId representing order's expiry
2046       * @param buyAmount relative minimum amount of requested buy amount
2047       * @param sellAmount maximum amount of sell token to be exchanged
2048       * @return orderId defined as the index in user's order array
2049       *
2050       * Emits an {OrderPlacement} event with all relevant order details.
2051       */
2052     function placeOrder(uint16 buyToken, uint16 sellToken, uint32 validUntil, uint128 buyAmount, uint128 sellAmount)
2053         public
2054         returns (uint256)
2055     {
2056         return placeOrderInternal(buyToken, sellToken, getCurrentBatchId(), validUntil, buyAmount, sellAmount);
2057     }
2058 
2059     /** @dev A user facing function used to place limit sell orders in auction with expiry defined by batchId
2060       * Note that parameters are passed as arrays and the indices correspond to each order.
2061       * @param buyTokens ids of tokens to be bought
2062       * @param sellTokens ids of tokens to be sold
2063       * @param validFroms batchIds representing order's validity start time
2064       * @param validUntils batchIds represnnting order's expiry
2065       * @param buyAmounts relative minimum amount of requested buy amounts
2066       * @param sellAmounts maximum amounts of sell token to be exchanged
2067       * @return `orderIds` an array of indices in which `msg.sender`'s orders are included
2068       *
2069       * Emits an {OrderPlacement} event with all relevant order details.
2070       */
2071     function placeValidFromOrders(
2072         uint16[] memory buyTokens,
2073         uint16[] memory sellTokens,
2074         uint32[] memory validFroms,
2075         uint32[] memory validUntils,
2076         uint128[] memory buyAmounts,
2077         uint128[] memory sellAmounts
2078     ) public returns (uint16[] memory orderIds) {
2079         orderIds = new uint16[](buyTokens.length);
2080         for (uint256 i = 0; i < buyTokens.length; i++) {
2081             orderIds[i] = placeOrderInternal(
2082                 buyTokens[i],
2083                 sellTokens[i],
2084                 validFroms[i],
2085                 validUntils[i],
2086                 buyAmounts[i],
2087                 sellAmounts[i]
2088             );
2089         }
2090     }
2091 
2092     /** @dev a user facing function used to cancel orders. If the order is valid for the batch that is currently
2093       * being solved, it sets order expiry to that batchId. Otherwise it removes it from storage. Can be called
2094       * multiple times (e.g. to eventually free storage once order is expired).
2095       *
2096       * @param orderIds referencing the indices of user's orders to be cancelled
2097       *
2098       * Emits an {OrderCancellation} or {OrderDeletion} with sender's address and orderId
2099       */
2100     function cancelOrders(uint16[] memory orderIds) public {
2101         uint32 batchIdBeingSolved = getCurrentBatchId() - 1;
2102         for (uint16 i = 0; i < orderIds.length; i++) {
2103             if (!checkOrderValidity(orders[msg.sender][orderIds[i]], batchIdBeingSolved)) {
2104                 delete orders[msg.sender][orderIds[i]];
2105                 emit OrderDeletion(msg.sender, orderIds[i]);
2106             } else {
2107                 orders[msg.sender][orderIds[i]].validUntil = batchIdBeingSolved;
2108                 emit OrderCancellation(msg.sender, orderIds[i]);
2109             }
2110         }
2111     }
2112 
2113     /** @dev A user facing wrapper to cancel and place new orders in the same transaction.
2114       * @param cancellations indices of orders to be cancelled
2115       * @param buyTokens ids of tokens to be bought in new orders
2116       * @param sellTokens ids of tokens to be sold in new orders
2117       * @param validFroms batchIds representing order's validity start time in new orders
2118       * @param validUntils batchIds represnnting order's expiry in new orders
2119       * @param buyAmounts relative minimum amount of requested buy amounts in new orders
2120       * @param sellAmounts maximum amounts of sell token to be exchanged in new orders
2121       * @return an array of indices in which `msg.sender`'s new orders are included
2122       *
2123       * Emits {OrderCancellation} events for all cancelled orders and {OrderPlacement} events with relevant new order details.
2124       */
2125     function replaceOrders(
2126         uint16[] memory cancellations,
2127         uint16[] memory buyTokens,
2128         uint16[] memory sellTokens,
2129         uint32[] memory validFroms,
2130         uint32[] memory validUntils,
2131         uint128[] memory buyAmounts,
2132         uint128[] memory sellAmounts
2133     ) public returns (uint16[] memory) {
2134         cancelOrders(cancellations);
2135         return placeValidFromOrders(buyTokens, sellTokens, validFroms, validUntils, buyAmounts, sellAmounts);
2136     }
2137 
2138     /** @dev a solver facing function called for auction settlement
2139       * @param batchId index of auction solution is referring to
2140       * @param owners array of addresses corresponding to touched orders
2141       * @param orderIds array of order indices used in parallel with owners to identify touched order
2142       * @param buyVolumes executed buy amounts for each order identified by index of owner-orderId arrays
2143       * @param prices list of prices for touched tokens indexed by next parameter
2144       * @param tokenIdsForPrice price[i] is the price for the token with tokenID tokenIdsForPrice[i]
2145       * @return the computed objective value of the solution
2146       *
2147       * Requirements:
2148       * - Solutions for this `batchId` are currently being accepted.
2149       * - Claimed objetive value is a great enough improvement on the current winning solution
2150       * - Fee Token price is non-zero
2151       * - `tokenIdsForPrice` is sorted.
2152       * - Number of touched orders does not exceed `MAX_TOUCHED_ORDERS`.
2153       * - Each touched order is valid at current `batchId`.
2154       * - Each touched order's `executedSellAmount` does not exceed its remaining amount.
2155       * - Limit Price of each touched order is respected.
2156       * - Solution's objective evaluation must be positive.
2157       *
2158       * Sub Requirements: Those nested within other functions
2159       * - checkAndOverrideObjectiveValue; Objetive value is a great enough improvement on the current winning solution
2160       * - checkTokenConservation; for all, non-fee, tokens total amount sold == total amount bought
2161       */
2162     function submitSolution(
2163         uint32 batchId,
2164         uint256 claimedObjectiveValue,
2165         address[] memory owners,
2166         uint16[] memory orderIds,
2167         uint128[] memory buyVolumes,
2168         uint128[] memory prices,
2169         uint16[] memory tokenIdsForPrice
2170     ) public returns (uint256) {
2171         require(acceptingSolutions(batchId), "Solutions are no longer accepted for this batch");
2172         require(
2173             isObjectiveValueSufficientlyImproved(claimedObjectiveValue),
2174             "Claimed objective doesn't sufficiently improve current solution"
2175         );
2176         require(verifyAmountThreshold(prices), "At least one price lower than AMOUNT_MINIMUM");
2177         require(tokenIdsForPrice[0] != 0, "Fee token has fixed price!");
2178         require(tokenIdsForPrice.checkPriceOrdering(), "prices are not ordered by tokenId");
2179         require(owners.length <= MAX_TOUCHED_ORDERS, "Solution exceeds MAX_TOUCHED_ORDERS");
2180         // Further assumptions are: owners.length == orderIds.length && owners.length == buyVolumes.length
2181         // && prices.length == tokenIdsForPrice.length
2182         // These assumptions are not checked explicitly, as violations of these constraints can not be used
2183         // to create a beneficial situation
2184         uint256 lastAuctionBurntFees = burnPreviousAuctionFees();
2185         undoCurrentSolution();
2186         updateCurrentPrices(prices, tokenIdsForPrice);
2187         delete latestSolution.trades;
2188         int256[] memory tokenConservation = TokenConservation.init(tokenIdsForPrice);
2189         uint256 utility = 0;
2190         for (uint256 i = 0; i < owners.length; i++) {
2191             Order memory order = orders[owners[i]][orderIds[i]];
2192             require(checkOrderValidity(order, batchId), "Order is invalid");
2193             (uint128 executedBuyAmount, uint128 executedSellAmount) = getTradedAmounts(buyVolumes[i], order);
2194             require(executedBuyAmount >= AMOUNT_MINIMUM, "buy amount less than AMOUNT_MINIMUM");
2195             require(executedSellAmount >= AMOUNT_MINIMUM, "sell amount less than AMOUNT_MINIMUM");
2196             tokenConservation.updateTokenConservation(
2197                 order.buyToken,
2198                 order.sellToken,
2199                 tokenIdsForPrice,
2200                 executedBuyAmount,
2201                 executedSellAmount
2202             );
2203             require(getRemainingAmount(order) >= executedSellAmount, "executedSellAmount bigger than specified in order");
2204             // Ensure executed price is not lower than the order price:
2205             //       executedSellAmount / executedBuyAmount <= order.priceDenominator / order.priceNumerator
2206             require(
2207                 executedSellAmount.mul(order.priceNumerator) <= executedBuyAmount.mul(order.priceDenominator),
2208                 "limit price not satisfied"
2209             );
2210             // accumulate utility before updateRemainingOrder, but after limitPrice verified!
2211             utility = utility.add(evaluateUtility(executedBuyAmount, order));
2212             updateRemainingOrder(owners[i], orderIds[i], executedSellAmount);
2213             addBalanceAndBlockWithdrawForThisBatch(owners[i], tokenIdToAddressMap(order.buyToken), executedBuyAmount);
2214             emit Trade(owners[i], orderIds[i], order.sellToken, order.buyToken, executedSellAmount, executedBuyAmount);
2215         }
2216         // Perform all subtractions after additions to avoid negative values
2217         for (uint256 i = 0; i < owners.length; i++) {
2218             Order memory order = orders[owners[i]][orderIds[i]];
2219             (, uint128 executedSellAmount) = getTradedAmounts(buyVolumes[i], order);
2220             subtractBalance(owners[i], tokenIdToAddressMap(order.sellToken), executedSellAmount);
2221         }
2222         uint256 disregardedUtility = 0;
2223         for (uint256 i = 0; i < owners.length; i++) {
2224             disregardedUtility = disregardedUtility.add(evaluateDisregardedUtility(orders[owners[i]][orderIds[i]], owners[i]));
2225         }
2226         uint256 burntFees = uint256(tokenConservation.feeTokenImbalance()) / 2;
2227         // burntFees ensures direct trades (when available) yield better solutions than longer rings
2228         uint256 objectiveValue = utility.add(burntFees).sub(disregardedUtility);
2229         checkAndOverrideObjectiveValue(objectiveValue);
2230         grantRewardToSolutionSubmitter(burntFees);
2231         tokenConservation.checkTokenConservation();
2232         documentTrades(batchId, owners, orderIds, buyVolumes, tokenIdsForPrice);
2233 
2234         emit SolutionSubmission(
2235             msg.sender,
2236             utility,
2237             disregardedUtility,
2238             burntFees,
2239             lastAuctionBurntFees,
2240             prices,
2241             tokenIdsForPrice
2242         );
2243         return (objectiveValue);
2244     }
2245     /**
2246      * Public View Methods
2247      */
2248 
2249     /** @dev View returning ID of listed tokens
2250       * @param addr address of listed token.
2251       * @return tokenId as stored within the contract.
2252       */
2253     function tokenAddressToIdMap(address addr) public view returns (uint16) {
2254         return IdToAddressBiMap.getId(registeredTokens, addr);
2255     }
2256 
2257     /** @dev View returning address of listed token by ID
2258       * @param id tokenId as stored, via BiMap, within the contract.
2259       * @return address of (listed) token
2260       */
2261     function tokenIdToAddressMap(uint16 id) public view returns (address) {
2262         return IdToAddressBiMap.getAddressAt(registeredTokens, id);
2263     }
2264 
2265     /** @dev View returning a bool attesting whether token was already added
2266       * @param addr address of the token to be checked
2267       * @return bool attesting whether token was already added
2268       */
2269     function hasToken(address addr) public view returns (bool) {
2270         return IdToAddressBiMap.hasAddress(registeredTokens, addr);
2271     }
2272 
2273     /** @dev View returning all byte-encoded sell orders for specified user
2274       * @param user address of user whose orders are being queried
2275       * @param offset uint determining the starting orderIndex
2276       * @param pageSize uint determining the count of elements to be viewed
2277       * @return encoded bytes representing all orders
2278       */
2279     function getEncodedUserOrdersPaginated(address user, uint16 offset, uint16 pageSize)
2280         public
2281         view
2282         returns (bytes memory elements)
2283     {
2284         for (uint16 i = offset; i < Math.min(orders[user].length, offset + pageSize); i++) {
2285             elements = elements.concat(
2286                 encodeAuctionElement(user, getBalance(user, tokenIdToAddressMap(orders[user][i].sellToken)), orders[user][i])
2287             );
2288         }
2289         return elements;
2290     }
2291 
2292     /** @dev View returning all byte-encoded users in paginated form
2293       * @param previousPageUser address of last user received in last pages (address(0) for first page)
2294       * @param pageSize uint determining the count of users to be returned per page
2295       * @return encoded packed bytes of user addresses
2296       */
2297     function getUsersPaginated(address previousPageUser, uint16 pageSize) public view returns (bytes memory users) {
2298         if (allUsers.size() == 0) {
2299             return users;
2300         }
2301         uint16 count = 0;
2302         address current = previousPageUser;
2303         if (current == address(0)) {
2304             current = allUsers.first();
2305             users = users.concat(abi.encodePacked(current));
2306             count++;
2307         }
2308         while (count < pageSize && current != allUsers.last) {
2309             current = allUsers.next(current);
2310             users = users.concat(abi.encodePacked(current));
2311             count++;
2312         }
2313         return users;
2314     }
2315 
2316     /** @dev View returning all byte-encoded sell orders for specified user
2317       * @param user address of user whose orders are being queried
2318       * @return encoded bytes representing all orders
2319       */
2320     function getEncodedUserOrders(address user) public view returns (bytes memory elements) {
2321         return getEncodedUserOrdersPaginated(user, 0, uint16(-1));
2322     }
2323 
2324     /** @dev View returning byte-encoded sell orders in paginated form
2325       * @param previousPageUser address of last user received in the previous page (address(0) for first page)
2326       * @param previousPageUserOffset the number of orders received for the last user on the previous page (0 for first page).
2327       * @param pageSize uint determining the count of orders to be returned per page
2328       * @return encoded bytes representing a page of orders ordered by (user, index)
2329       */
2330     function getEncodedUsersPaginated(address previousPageUser, uint16 previousPageUserOffset, uint16 pageSize)
2331         public
2332         view
2333         returns (bytes memory elements)
2334     {
2335         if (allUsers.size() == 0) {
2336             return elements;
2337         }
2338         uint16 currentOffset = previousPageUserOffset;
2339         address currentUser = previousPageUser;
2340         if (currentUser == address(0x0)) {
2341             currentUser = allUsers.first();
2342         }
2343         while (elements.length / ENCODED_AUCTION_ELEMENT_WIDTH < pageSize) {
2344             elements = elements.concat(
2345                 getEncodedUserOrdersPaginated(
2346                     currentUser,
2347                     currentOffset,
2348                     pageSize - uint16(elements.length / ENCODED_AUCTION_ELEMENT_WIDTH)
2349                 )
2350             );
2351             if (currentUser == allUsers.last) {
2352                 return elements;
2353             }
2354             currentOffset = 0;
2355             currentUser = allUsers.next(currentUser);
2356         }
2357     }
2358 
2359     /** @dev View returning all byte-encoded sell orders
2360       * @return encoded bytes representing all orders ordered by (user, index)
2361       */
2362     function getEncodedOrders() public view returns (bytes memory elements) {
2363         if (allUsers.size() > 0) {
2364             address user = allUsers.first();
2365             bool stop = false;
2366             while (!stop) {
2367                 elements = elements.concat(getEncodedUserOrders(user));
2368                 if (user == allUsers.last) {
2369                     stop = true;
2370                 } else {
2371                     user = allUsers.next(user);
2372                 }
2373             }
2374         }
2375         return elements;
2376     }
2377 
2378     function acceptingSolutions(uint32 batchId) public view returns (bool) {
2379         return batchId == getCurrentBatchId() - 1 && getSecondsRemainingInBatch() >= 1 minutes;
2380     }
2381 
2382     /** @dev gets the objective value of currently winning solution.
2383       * @return objective function evaluation of the currently winning solution, or zero if no solution proposed.
2384       */
2385     function getCurrentObjectiveValue() public view returns (uint256) {
2386         if (latestSolution.batchId == getCurrentBatchId() - 1) {
2387             return latestSolution.objectiveValue;
2388         } else {
2389             return 0;
2390         }
2391     }
2392     /**
2393      * Private Functions
2394      */
2395 
2396     function placeOrderInternal(
2397         uint16 buyToken,
2398         uint16 sellToken,
2399         uint32 validFrom,
2400         uint32 validUntil,
2401         uint128 buyAmount,
2402         uint128 sellAmount
2403     ) private returns (uint16) {
2404         require(IdToAddressBiMap.hasId(registeredTokens, buyToken), "Buy token must be listed");
2405         require(IdToAddressBiMap.hasId(registeredTokens, sellToken), "Sell token must be listed");
2406         require(buyToken != sellToken, "Exchange tokens not distinct");
2407         require(validFrom >= getCurrentBatchId(), "Orders can't be placed in the past");
2408         orders[msg.sender].push(
2409             Order({
2410                 buyToken: buyToken,
2411                 sellToken: sellToken,
2412                 validFrom: validFrom,
2413                 validUntil: validUntil,
2414                 priceNumerator: buyAmount,
2415                 priceDenominator: sellAmount,
2416                 usedAmount: 0
2417             })
2418         );
2419         uint16 orderId = (orders[msg.sender].length - 1).toUint16();
2420         emit OrderPlacement(msg.sender, orderId, buyToken, sellToken, validFrom, validUntil, buyAmount, sellAmount);
2421         allUsers.insert(msg.sender);
2422         return orderId;
2423     }
2424 
2425     /** @dev called at the end of submitSolution with a value of tokenConservation / 2
2426       * @param feeReward amount to be rewarded to the solver
2427       */
2428     function grantRewardToSolutionSubmitter(uint256 feeReward) private {
2429         latestSolution.feeReward = feeReward;
2430         addBalanceAndBlockWithdrawForThisBatch(msg.sender, tokenIdToAddressMap(0), feeReward);
2431     }
2432 
2433     /** @dev called during solution submission to burn fees from previous auction
2434       * @return amount of OWL burnt
2435       */
2436     function burnPreviousAuctionFees() private returns (uint256) {
2437         if (!currentBatchHasSolution()) {
2438             feeToken.burnOWL(address(this), latestSolution.feeReward);
2439             return latestSolution.feeReward;
2440         }
2441         return 0;
2442     }
2443 
2444     /** @dev Called from within submitSolution to update the token prices.
2445       * @param prices list of prices for touched tokens only, first price is always fee token price
2446       * @param tokenIdsForPrice price[i] is the price for the token with tokenID tokenIdsForPrice[i]
2447       */
2448     function updateCurrentPrices(uint128[] memory prices, uint16[] memory tokenIdsForPrice) private {
2449         for (uint256 i = 0; i < latestSolution.tokenIdsForPrice.length; i++) {
2450             currentPrices[latestSolution.tokenIdsForPrice[i]] = 0;
2451         }
2452         for (uint256 i = 0; i < tokenIdsForPrice.length; i++) {
2453             currentPrices[tokenIdsForPrice[i]] = prices[i];
2454         }
2455     }
2456 
2457     /** @dev Updates an order's remaing requested sell amount upon (partial) execution of a standing order
2458       * @param owner order's corresponding user address
2459       * @param orderId index of order in list of owner's orders
2460       * @param executedAmount proportion of order's requested sellAmount that was filled.
2461       */
2462     function updateRemainingOrder(address owner, uint16 orderId, uint128 executedAmount) private {
2463         if (isOrderWithLimitedAmount(orders[owner][orderId])) {
2464             orders[owner][orderId].usedAmount = orders[owner][orderId].usedAmount.add(executedAmount).toUint128();
2465         }
2466     }
2467 
2468     /** @dev The inverse of updateRemainingOrder, called when reverting a solution in favour of a better one.
2469       * @param owner order's corresponding user address
2470       * @param orderId index of order in list of owner's orders
2471       * @param executedAmount proportion of order's requested sellAmount that was filled.
2472       */
2473     function revertRemainingOrder(address owner, uint16 orderId, uint128 executedAmount) private {
2474         if (isOrderWithLimitedAmount(orders[owner][orderId])) {
2475             orders[owner][orderId].usedAmount = orders[owner][orderId].usedAmount.sub(executedAmount).toUint128();
2476         }
2477     }
2478 
2479     /** @dev Checks whether an order is intended to track its usedAmount
2480       * @param order order under inspection
2481       * @return true if the given order does track its usedAmount
2482       */
2483     function isOrderWithLimitedAmount(Order memory order) private pure returns (bool) {
2484         return order.priceNumerator != UNLIMITED_ORDER_AMOUNT && order.priceDenominator != UNLIMITED_ORDER_AMOUNT;
2485     }
2486 
2487     /** @dev This function writes solution information into contract storage
2488       * @param batchId index of referenced auction
2489       * @param owners array of addresses corresponding to touched orders
2490       * @param orderIds array of order indices used in parallel with owners to identify touched order
2491       * @param volumes executed buy amounts for each order identified by index of owner-orderId arrays
2492       * @param tokenIdsForPrice price[i] is the price for the token with tokenID tokenIdsForPrice[i]
2493       */
2494     function documentTrades(
2495         uint32 batchId,
2496         address[] memory owners,
2497         uint16[] memory orderIds,
2498         uint128[] memory volumes,
2499         uint16[] memory tokenIdsForPrice
2500     ) private {
2501         latestSolution.batchId = batchId;
2502         for (uint256 i = 0; i < owners.length; i++) {
2503             latestSolution.trades.push(TradeData({owner: owners[i], orderId: orderIds[i], volume: volumes[i]}));
2504         }
2505         latestSolution.tokenIdsForPrice = tokenIdsForPrice;
2506         latestSolution.solutionSubmitter = msg.sender;
2507     }
2508 
2509     /** @dev reverts all relevant contract storage relating to an overwritten auction solution.
2510       */
2511     function undoCurrentSolution() private {
2512         if (currentBatchHasSolution()) {
2513             for (uint256 i = 0; i < latestSolution.trades.length; i++) {
2514                 address owner = latestSolution.trades[i].owner;
2515                 uint16 orderId = latestSolution.trades[i].orderId;
2516                 Order memory order = orders[owner][orderId];
2517                 (, uint128 sellAmount) = getTradedAmounts(latestSolution.trades[i].volume, order);
2518                 addBalance(owner, tokenIdToAddressMap(order.sellToken), sellAmount);
2519             }
2520             for (uint256 i = 0; i < latestSolution.trades.length; i++) {
2521                 address owner = latestSolution.trades[i].owner;
2522                 uint16 orderId = latestSolution.trades[i].orderId;
2523                 Order memory order = orders[owner][orderId];
2524                 (uint128 buyAmount, uint128 sellAmount) = getTradedAmounts(latestSolution.trades[i].volume, order);
2525                 revertRemainingOrder(owner, orderId, sellAmount);
2526                 subtractBalanceUnchecked(owner, tokenIdToAddressMap(order.buyToken), buyAmount);
2527                 emit TradeReversion(owner, orderId, order.sellToken, order.buyToken, sellAmount, buyAmount);
2528             }
2529             // subtract granted fees:
2530             subtractBalanceUnchecked(latestSolution.solutionSubmitter, tokenIdToAddressMap(0), latestSolution.feeReward);
2531         }
2532     }
2533 
2534     /** @dev determines if value is better than currently and updates if it is.
2535       * @param newObjectiveValue proposed value to be updated if a great enough improvement on the current objective value
2536       */
2537     function checkAndOverrideObjectiveValue(uint256 newObjectiveValue) private {
2538         require(
2539             isObjectiveValueSufficientlyImproved(newObjectiveValue),
2540             "New objective doesn't sufficiently improve current solution"
2541         );
2542         latestSolution.objectiveValue = newObjectiveValue;
2543     }
2544 
2545     // Private view
2546     /** @dev Evaluates utility of executed trade
2547       * @param execBuy represents proportion of order executed (in terms of buy amount)
2548       * @param order the sell order whose utility is being evaluated
2549       * @return Utility = ((execBuy * order.sellAmt - execSell * order.buyAmt) * price.buyToken) / order.sellAmt
2550       */
2551     function evaluateUtility(uint128 execBuy, Order memory order) private view returns (uint256) {
2552         // Utility = ((execBuy * order.sellAmt - execSell * order.buyAmt) * price.buyToken) / order.sellAmt
2553         uint256 execSellTimesBuy = getExecutedSellAmount(execBuy, currentPrices[order.buyToken], currentPrices[order.sellToken])
2554             .mul(order.priceNumerator);
2555 
2556         uint256 roundedUtility = execBuy.sub(execSellTimesBuy.div(order.priceDenominator)).mul(currentPrices[order.buyToken]);
2557         uint256 utilityError = execSellTimesBuy.mod(order.priceDenominator).mul(currentPrices[order.buyToken]).div(
2558             order.priceDenominator
2559         );
2560         return roundedUtility.sub(utilityError);
2561     }
2562 
2563     /** @dev computes a measure of how much of an order was disregarded (only valid when limit price is respected)
2564       * @param order the sell order whose disregarded utility is being evaluated
2565       * @param user address of order's owner
2566       * @return disregardedUtility of the order (after it has been applied)
2567       * Note that:
2568       * |disregardedUtility| = (limitTerm * leftoverSellAmount) / order.sellAmount
2569       * where limitTerm = price.SellToken * order.sellAmt - order.buyAmt * price.buyToken / (1 - phi)
2570       * and leftoverSellAmount = order.sellAmt - execSellAmt
2571       * Balances and orders have all been updated so: sellAmount - execSellAmt == remainingAmount(order).
2572       * For correctness, we take the minimum of this with the user's token balance.
2573       */
2574     function evaluateDisregardedUtility(Order memory order, address user) private view returns (uint256) {
2575         uint256 leftoverSellAmount = Math.min(getRemainingAmount(order), getBalance(user, tokenIdToAddressMap(order.sellToken)));
2576         uint256 limitTermLeft = currentPrices[order.sellToken].mul(order.priceDenominator);
2577         uint256 limitTermRight = order.priceNumerator.mul(currentPrices[order.buyToken]).mul(FEE_DENOMINATOR).div(
2578             FEE_DENOMINATOR - 1
2579         );
2580         uint256 limitTerm = 0;
2581         if (limitTermLeft > limitTermRight) {
2582             limitTerm = limitTermLeft.sub(limitTermRight);
2583         }
2584         return leftoverSellAmount.mul(limitTerm).div(order.priceDenominator);
2585     }
2586 
2587     /** @dev Evaluates executedBuy amount based on prices and executedBuyAmout (fees included)
2588       * @param executedBuyAmount amount of buyToken executed for purchase in batch auction
2589       * @param buyTokenPrice uniform clearing price of buyToken
2590       * @param sellTokenPrice uniform clearing price of sellToken
2591       * @return executedSellAmount as expressed in Equation (2)
2592       * https://github.com/gnosis/dex-contracts/issues/173#issuecomment-526163117
2593       * execSellAmount * p[sellToken] * (1 - phi) == execBuyAmount * p[buyToken]
2594       * where phi = 1/FEE_DENOMINATOR
2595       * Note that: 1 - phi = (FEE_DENOMINATOR - 1) / FEE_DENOMINATOR
2596       * And so, 1/(1-phi) = FEE_DENOMINATOR / (FEE_DENOMINATOR - 1)
2597       * execSellAmount = (execBuyAmount * p[buyToken]) / (p[sellToken] * (1 - phi))
2598       *                = (execBuyAmount * buyTokenPrice / sellTokenPrice) * FEE_DENOMINATOR / (FEE_DENOMINATOR - 1)
2599       * in order to minimize rounding errors, the order of operations is switched
2600       *                = ((executedBuyAmount * buyTokenPrice) / (FEE_DENOMINATOR - 1)) * FEE_DENOMINATOR) / sellTokenPrice
2601       */
2602     function getExecutedSellAmount(uint128 executedBuyAmount, uint128 buyTokenPrice, uint128 sellTokenPrice)
2603         private
2604         pure
2605         returns (uint128)
2606     {
2607         /* solium-disable indentation */
2608         return
2609             uint256(executedBuyAmount)
2610                 .mul(buyTokenPrice)
2611                 .div(FEE_DENOMINATOR - 1)
2612                 .mul(FEE_DENOMINATOR)
2613                 .div(sellTokenPrice)
2614                 .toUint128();
2615         /* solium-enable indentation */
2616     }
2617 
2618     /** @dev used to determine if solution if first provided in current batch
2619       * @return true if `latestSolution` is storing a solution for current batch, else false
2620       */
2621     function currentBatchHasSolution() private view returns (bool) {
2622         return latestSolution.batchId == getCurrentBatchId() - 1;
2623     }
2624 
2625     // Private view
2626     /** @dev Compute trade execution based on executedBuyAmount and relevant token prices
2627       * @param executedBuyAmount executed buy amount
2628       * @param order contains relevant buy-sell token information
2629       * @return (executedBuyAmount, executedSellAmount)
2630       */
2631     function getTradedAmounts(uint128 executedBuyAmount, Order memory order) private view returns (uint128, uint128) {
2632         uint128 executedSellAmount = getExecutedSellAmount(
2633             executedBuyAmount,
2634             currentPrices[order.buyToken],
2635             currentPrices[order.sellToken]
2636         );
2637         return (executedBuyAmount, executedSellAmount);
2638     }
2639 
2640     /** @dev Checks that the proposed objective value is a significant enough improvement on the latest one
2641       * @param objectiveValue the proposed objective value to check
2642       * @return true if the objectiveValue is a significant enough improvement, false otherwise
2643       */
2644     function isObjectiveValueSufficientlyImproved(uint256 objectiveValue) private view returns (bool) {
2645         return (objectiveValue.mul(IMPROVEMENT_DENOMINATOR) > getCurrentObjectiveValue().mul(IMPROVEMENT_DENOMINATOR + 1));
2646     }
2647 
2648     // Private pure
2649     /** @dev used to determine if an order is valid for specific auction/batch
2650       * @param order object whose validity is in question
2651       * @param batchId auction index of validity
2652       * @return true if order is valid in auction batchId else false
2653       */
2654     function checkOrderValidity(Order memory order, uint32 batchId) private pure returns (bool) {
2655         return order.validFrom <= batchId && order.validUntil >= batchId;
2656     }
2657 
2658     /** @dev computes the remaining sell amount for a given order
2659       * @param order the order for which remaining amount should be calculated
2660       * @return the remaining sell amount
2661       */
2662     function getRemainingAmount(Order memory order) private pure returns (uint128) {
2663         return order.priceDenominator - order.usedAmount;
2664     }
2665 
2666     /** @dev called only by getEncodedOrders and used to pack auction info into bytes
2667       * @param user list of tokenIds
2668       * @param sellTokenBalance user's account balance of sell token
2669       * @param order a sell order
2670       * @return byte encoded, packed, concatenation of relevant order information
2671       */
2672     function encodeAuctionElement(address user, uint256 sellTokenBalance, Order memory order)
2673         private
2674         pure
2675         returns (bytes memory element)
2676     {
2677         element = abi.encodePacked(user);
2678         element = element.concat(abi.encodePacked(sellTokenBalance));
2679         element = element.concat(abi.encodePacked(order.buyToken));
2680         element = element.concat(abi.encodePacked(order.sellToken));
2681         element = element.concat(abi.encodePacked(order.validFrom));
2682         element = element.concat(abi.encodePacked(order.validUntil));
2683         element = element.concat(abi.encodePacked(order.priceNumerator));
2684         element = element.concat(abi.encodePacked(order.priceDenominator));
2685         element = element.concat(abi.encodePacked(getRemainingAmount(order)));
2686         return element;
2687     }
2688 
2689     /** @dev determines if value is better than currently and updates if it is.
2690       * @param amounts array of values to be verified with AMOUNT_MINIMUM
2691       */
2692     function verifyAmountThreshold(uint128[] memory amounts) private pure returns (bool) {
2693         for (uint256 i = 0; i < amounts.length; i++) {
2694             if (amounts[i] < AMOUNT_MINIMUM) {
2695                 return false;
2696             }
2697         }
2698         return true;
2699     }
2700 }