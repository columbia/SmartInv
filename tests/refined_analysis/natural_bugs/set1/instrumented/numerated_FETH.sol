1 /*
2   ･
3    *　★
4       ･ ｡
5         　･　ﾟ☆ ｡
6   　　　 *　★ ﾟ･｡ *  ｡
7           　　* ☆ ｡･ﾟ*.｡
8       　　　ﾟ *.｡☆｡★　･
9 ​
10                       `                     .-:::::-.`              `-::---...```
11                      `-:`               .:+ssssoooo++//:.`       .-/+shhhhhhhhhhhhhyyyssooo:
12                     .--::.            .+ossso+/////++/:://-`   .////+shhhhhhhhhhhhhhhhhhhhhy
13                   `-----::.         `/+////+++///+++/:--:/+/-  -////+shhhhhhhhhhhhhhhhhhhhhy
14                  `------:::-`      `//-.``.-/+ooosso+:-.-/oso- -////+shhhhhhhhhhhhhhhhhhhhhy
15                 .--------:::-`     :+:.`  .-/osyyyyyyso++syhyo.-////+shhhhhhhhhhhhhhhhhhhhhy
16               `-----------:::-.    +o+:-.-:/oyhhhhhhdhhhhhdddy:-////+shhhhhhhhhhhhhhhhhhhhhy
17              .------------::::--  `oys+/::/+shhhhhhhdddddddddy/-////+shhhhhhhhhhhhhhhhhhhhhy
18             .--------------:::::-` +ys+////+yhhhhhhhddddddddhy:-////+yhhhhhhhhhhhhhhhhhhhhhy
19           `----------------::::::-`.ss+/:::+oyhhhhhhhhhhhhhhho`-////+shhhhhhhhhhhhhhhhhhhhhy
20          .------------------:::::::.-so//::/+osyyyhhhhhhhhhys` -////+shhhhhhhhhhhhhhhhhhhhhy
21        `.-------------------::/:::::..+o+////+oosssyyyyyyys+`  .////+shhhhhhhhhhhhhhhhhhhhhy
22        .--------------------::/:::.`   -+o++++++oooosssss/.     `-//+shhhhhhhhhhhhhhhhhhhhyo
23      .-------   ``````.......--`        `-/+ooooosso+/-`          `./++++///:::--...``hhhhyo
24                                               `````
25    *　
26       ･ ｡
27 　　　　･　　ﾟ☆ ｡
28   　　　 *　★ ﾟ･｡ *  ｡
29           　　* ☆ ｡･ﾟ*.｡
30       　　　ﾟ *.｡☆｡★　･
31     *　　ﾟ｡·*･｡ ﾟ*
32   　　　☆ﾟ･｡°*. ﾟ
33 　 ･ ﾟ*｡･ﾟ★｡
34 　　･ *ﾟ｡　　 *
35 　･ﾟ*｡★･
36  ☆∴｡　*
37 ･ ｡
38 */
39 
40 // SPDX-License-Identifier: MIT OR Apache-2.0
41 
42 pragma solidity ^0.8.0;
43 
44 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
45 import "@openzeppelin/contracts/utils/math/Math.sol";
46 
47 import "./libraries/LockedBalance.sol";
48 
49 error FETH_Cannot_Deposit_For_Lockup_With_Address_Zero();
50 error FETH_Escrow_Expired();
51 error FETH_Escrow_Not_Found();
52 error FETH_Expiration_Too_Far_In_Future();
53 /// @param amount The current allowed amount the spender is authorized to transact for this account.
54 error FETH_Insufficient_Allowance(uint256 amount);
55 /// @param amount The current available (unlocked) token count of this account.
56 error FETH_Insufficient_Available_Funds(uint256 amount);
57 /// @param amount The current number of tokens this account has for the given lockup expiry bucket.
58 error FETH_Insufficient_Escrow(uint256 amount);
59 error FETH_Invalid_Lockup_Duration();
60 error FETH_Market_Must_Be_A_Contract();
61 error FETH_Must_Deposit_Non_Zero_Amount();
62 error FETH_Must_Lockup_Non_Zero_Amount();
63 error FETH_No_Funds_To_Withdraw();
64 error FETH_Only_FND_Market_Allowed();
65 error FETH_Too_Much_ETH_Provided();
66 error FETH_Transfer_To_Burn_Not_Allowed();
67 error FETH_Transfer_To_FETH_Not_Allowed();
68 
69 /**
70  * @title An ERC-20 token which wraps ETH, potentially with a 1 day lockup period.
71  * @notice FETH is an [ERC-20 token](https://eips.ethereum.org/EIPS/eip-20) modeled after
72  * [WETH9](https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2#code).
73  * It has the added ability to lockup tokens for 24-25 hours - during this time they may not be
74  * transferred or withdrawn, except by our market contract which requested the lockup in the first place.
75  * @dev Locked balances are rounded up to the next hour.
76  * They are grouped by the expiration time of the lockup into what we refer to as a lockup "bucket".
77  * At any time there may be up to 25 buckets but never more than that which prevents loops from exhausting gas limits.
78  */
79 contract FETH {
80   using AddressUpgradeable for address payable;
81   using LockedBalance for LockedBalance.Lockups;
82   using Math for uint256;
83 
84   /// @notice Tracks an account's info.
85   struct AccountInfo {
86     /// @notice The number of tokens which have been unlocked already.
87     uint96 freedBalance;
88     /// @notice The first applicable lockup bucket for this account.
89     uint32 lockupStartIndex;
90     /// @notice Stores up to 25 buckets of locked balance for a user, one per hour.
91     LockedBalance.Lockups lockups;
92     /// @notice Returns the amount which a spender is still allowed to withdraw from this account.
93     mapping(address => uint256) allowance;
94   }
95 
96   /// @notice Stores per-account details.
97   mapping(address => AccountInfo) private accountToInfo;
98 
99   // Lockup configuration
100   /// @notice The minimum lockup period in seconds.
101   uint256 private immutable lockupDuration;
102   /// @notice The interval to which lockup expiries are rounded, limiting the max number of outstanding lockup buckets.
103   uint256 private immutable lockupInterval;
104 
105   /// @notice The Foundation market contract with permissions to manage lockups.
106   address payable private immutable foundationMarket;
107 
108   // ERC-20 metadata fields
109   /**
110    * @notice The number of decimals the token uses.
111    * @dev This method can be used to improve usability when displaying token amounts, but all interactions
112    * with this contract use whole amounts not considering decimals.
113    * @return 18
114    */
115   uint8 public constant decimals = 18;
116   /**
117    * @notice The name of the token.
118    * @return Foundation Wrapped Ether
119    */
120   string public constant name = "Foundation Wrapped Ether";
121   /**
122    * @notice The symbol of the token.
123    * @return FETH
124    */
125   string public constant symbol = "FETH";
126 
127   // ERC-20 events
128   /**
129    * @notice Emitted when the allowance for a spender account is updated.
130    * @param from The account the spender is authorized to transact for.
131    * @param spender The account with permissions to manage FETH tokens for the `from` account.
132    * @param amount The max amount of tokens which can be spent by the `spender` account.
133    */
134   event Approval(address indexed from, address indexed spender, uint256 amount);
135   /**
136    * @notice Emitted when a transfer of FETH tokens is made from one account to another.
137    * @param from The account which is sending FETH tokens.
138    * @param to The account which is receiving FETH tokens.
139    * @param amount The number of FETH tokens which were sent.
140    */
141   event Transfer(address indexed from, address indexed to, uint256 amount);
142 
143   // Custom events
144   /**
145    * @notice Emitted when FETH tokens are locked up by the Foundation market for 24-25 hours
146    * and may include newly deposited ETH which is added to the account's total FETH balance.
147    * @param account The account which has access to the FETH after the `expiration`.
148    * @param expiration The time at which the `from` account will have access to the locked FETH.
149    * @param amount The number of FETH tokens which where locked up.
150    * @param valueDeposited The amount of ETH added to their account's total FETH balance,
151    * this may be lower than `amount` if available FETH was leveraged.
152    */
153   event BalanceLocked(address indexed account, uint256 indexed expiration, uint256 amount, uint256 valueDeposited);
154   /**
155    * @notice Emitted when FETH tokens are unlocked by the Foundation market.
156    * @dev This event will not be emitted when lockups expire,
157    * it's only for tokens which are unlocked before their expiry.
158    * @param account The account which had locked FETH freed before expiration.
159    * @param expiration The time this balance was originally scheduled to be unlocked.
160    * @param amount The number of FETH tokens which were unlocked.
161    */
162   event BalanceUnlocked(address indexed account, uint256 indexed expiration, uint256 amount);
163   /**
164    * @notice Emitted when ETH is withdrawn from a user's account.
165    * @dev This may be triggered by the user, an approved operator, or the Foundation market.
166    * @param from The account from which FETH was deducted in order to send the ETH.
167    * @param to The address the ETH was sent to.
168    * @param amount The number of tokens which were deducted from the user's FETH balance and transferred as ETH.
169    */
170   event ETHWithdrawn(address indexed from, address indexed to, uint256 amount);
171 
172   /// @dev Allows the Foundation market permission to manage lockups for a user.
173   modifier onlyFoundationMarket() {
174     if (msg.sender != foundationMarket) {
175       revert FETH_Only_FND_Market_Allowed();
176     }
177     _;
178   }
179 
180   /**
181    * @notice Initializes variables which may differ on testnet.
182    * @param _foundationMarket The address of the Foundation NFT marketplace.
183    * @param _lockupDuration The minimum length of time to lockup tokens for when `BalanceLocked`, in seconds.
184    */
185   constructor(address payable _foundationMarket, uint256 _lockupDuration) {
186     if (!_foundationMarket.isContract()) {
187       revert FETH_Market_Must_Be_A_Contract();
188     }
189     foundationMarket = _foundationMarket;
190     lockupDuration = _lockupDuration;
191     lockupInterval = _lockupDuration / 24;
192     if (lockupInterval * 24 != _lockupDuration || _lockupDuration == 0) {
193       revert FETH_Invalid_Lockup_Duration();
194     }
195   }
196 
197   /**
198    * @notice Transferring ETH (via `msg.value`) to the contract performs a `deposit` into the user's account.
199    */
200   receive() external payable {
201     depositFor(msg.sender);
202   }
203 
204   /**
205    * @notice Approves a `spender` as an operator with permissions to transfer from your account.
206    * @param spender The address of the operator account that has approval to spend funds
207    * from the `msg.sender`'s account.
208    * @param amount The max number of FETH tokens from `msg.sender`'s account that this spender is
209    * allowed to transact with.
210    * @return success Always true.
211    */
212   function approve(address spender, uint256 amount) external returns (bool success) {
213     accountToInfo[msg.sender].allowance[spender] = amount;
214     emit Approval(msg.sender, spender, amount);
215     return true;
216   }
217 
218   /**
219    * @notice Deposit ETH (via `msg.value`) and receive the equivalent amount in FETH tokens.
220    * These tokens are not subject to any lockup period.
221    */
222   function deposit() external payable {
223     depositFor(msg.sender);
224   }
225 
226   /**
227    * @notice Deposit ETH (via `msg.value`) and credit the `account` provided with the equivalent amount in FETH tokens.
228    * These tokens are not subject to any lockup period.
229    * @dev This may be used by the Foundation market to credit a user's account with FETH tokens.
230    * @param account The account to credit with FETH tokens.
231    */
232   function depositFor(address account) public payable {
233     if (msg.value == 0) {
234       revert FETH_Must_Deposit_Non_Zero_Amount();
235     }
236     AccountInfo storage accountInfo = accountToInfo[account];
237     // ETH value cannot realistically overflow 96 bits.
238     unchecked {
239       accountInfo.freedBalance += uint96(msg.value);
240     }
241     emit Transfer(address(0), account, msg.value);
242   }
243 
244   /**
245    * @notice Used by the market contract only:
246    * Remove an account's lockup and then create a new lockup, potentially for a different account.
247    * @dev Used by the market when an offer for an NFT is increased.
248    * This may be for a single account (increasing their offer)
249    * or two different accounts (outbidding someone elses offer).
250    * @param unlockFrom The account whose lockup is to be removed.
251    * @param unlockExpiration The original lockup expiration for the tokens to be unlocked.
252    * This will revert if the lockup has already expired.
253    * @param unlockAmount The number of tokens to be unlocked from `unlockFrom`'s account.
254    * This will revert if the tokens were previously unlocked.
255    * @param lockupFor The account to which the funds are to be deposited for (via the `msg.value`) and tokens locked up.
256    * @param lockupAmount The number of tokens to be locked up for the `lockupFor`'s account.
257    * `msg.value` must be <= `lockupAmount` and any delta will be taken from the account's available FETH balance.
258    * @return expiration The expiration timestamp for the FETH tokens that were locked.
259    */
260   function marketChangeLockup(
261     address unlockFrom,
262     uint256 unlockExpiration,
263     uint256 unlockAmount,
264     address lockupFor,
265     uint256 lockupAmount
266   ) external payable onlyFoundationMarket returns (uint256 expiration) {
267     _marketUnlockFor(unlockFrom, unlockExpiration, unlockAmount);
268     return _marketLockupFor(lockupFor, lockupAmount);
269   }
270 
271   /**
272    * @notice Used by the market contract only:
273    * Lockup an account's FETH tokens for 24-25 hours.
274    * @dev Used by the market when a new offer for an NFT is made.
275    * @param account The account to which the funds are to be deposited for (via the `msg.value`) and tokens locked up.
276    * @param amount The number of tokens to be locked up for the `lockupFor`'s account.
277    * `msg.value` must be <= `amount` and any delta will be taken from the account's available FETH balance.
278    * @return expiration The expiration timestamp for the FETH tokens that were locked.
279    */
280   function marketLockupFor(address account, uint256 amount)
281     external
282     payable
283     onlyFoundationMarket
284     returns (uint256 expiration)
285   {
286     return _marketLockupFor(account, amount);
287   }
288 
289   /**
290    * @notice Used by the market contract only:
291    * Remove an account's lockup, making the FETH tokens available for transfer or withdrawal.
292    * @dev Used by the market when an offer is invalidated, which occurs when an auction for the same NFT
293    * receives its first bid or the buyer purchased the NFT another way, such as with `buy`.
294    * @param account The account whose lockup is to be unlocked.
295    * @param expiration The original lockup expiration for the tokens to be unlocked unlocked.
296    * This will revert if the lockup has already expired.
297    * @param amount The number of tokens to be unlocked from `account`.
298    * This will revert if the tokens were previously unlocked.
299    */
300   function marketUnlockFor(
301     address account,
302     uint256 expiration,
303     uint256 amount
304   ) external onlyFoundationMarket {
305     _marketUnlockFor(account, expiration, amount);
306   }
307 
308   /**
309    * @notice Used by the market contract only:
310    * Removes tokens from the user's available balance and returns ETH to the caller.
311    * @dev Used by the market when a user's available FETH balance is used to make a purchase
312    * including accepting a buy price or a private sale, or placing a bid in an auction.
313    * @param from The account whose available balance is to be withdrawn from.
314    * @param amount The number of tokens to be deducted from `unlockFrom`'s available balance and transferred as ETH.
315    * This will revert if the tokens were previously unlocked.
316    */
317   function marketWithdrawFrom(address from, uint256 amount) external onlyFoundationMarket {
318     AccountInfo storage accountInfo = _freeFromEscrow(from);
319     _deductBalanceFrom(accountInfo, amount);
320 
321     // With the external call after state changes, we do not need a nonReentrant guard
322     payable(msg.sender).sendValue(amount);
323 
324     emit ETHWithdrawn(from, msg.sender, amount);
325   }
326 
327   /**
328    * @notice Used by the market contract only:
329    * Removes a lockup from the user's account and then returns ETH to the caller.
330    * @dev Used by the market to extract unexpired funds as ETH to distribute for
331    * a sale when the user's offer is accepted.
332    * @param account The account whose lockup is to be removed.
333    * @param expiration The original lockup expiration for the tokens to be unlocked.
334    * This will revert if the lockup has already expired.
335    * @param amount The number of tokens to be unlocked and withdrawn as ETH.
336    */
337   function marketWithdrawLocked(
338     address account,
339     uint256 expiration,
340     uint256 amount
341   ) external onlyFoundationMarket {
342     _removeFromLockedBalance(account, expiration, amount);
343 
344     // With the external call after state changes, we do not need a nonReentrant guard
345     payable(msg.sender).sendValue(amount);
346 
347     emit ETHWithdrawn(account, msg.sender, amount);
348   }
349 
350   /**
351    * @notice Transfers an amount from your account.
352    * @param to The address of the account which the tokens are transferred from.
353    * @param amount The number of FETH tokens to be transferred.
354    * @return success Always true (reverts if insufficient funds).
355    */
356   function transfer(address to, uint256 amount) external returns (bool success) {
357     return transferFrom(msg.sender, to, amount);
358   }
359 
360   /**
361    * @notice Transfers an amount from the account specified if the `msg.sender` has approval.
362    * @param from The address from which the available tokens are transferred from.
363    * @param to The address to which the tokens are to be transferred.
364    * @param amount The number of FETH tokens to be transferred.
365    * @return success Always true (reverts if insufficient funds or not approved).
366    */
367   function transferFrom(
368     address from,
369     address to,
370     uint256 amount
371   ) public returns (bool success) {
372     if (to == address(0)) {
373       revert FETH_Transfer_To_Burn_Not_Allowed();
374     } else if (to == address(this)) {
375       revert FETH_Transfer_To_FETH_Not_Allowed();
376     }
377     AccountInfo storage fromAccountInfo = _freeFromEscrow(from);
378     if (from != msg.sender) {
379       _deductAllowanceFrom(fromAccountInfo, amount);
380     }
381     _deductBalanceFrom(fromAccountInfo, amount);
382     AccountInfo storage toAccountInfo = accountToInfo[to];
383 
384     // Total ETH cannot realistically overflow 96 bits.
385     unchecked {
386       toAccountInfo.freedBalance += uint96(amount);
387     }
388 
389     emit Transfer(from, to, amount);
390 
391     return true;
392   }
393 
394   /**
395    * @notice Withdraw all tokens available in your account and receive ETH.
396    */
397   function withdrawAvailableBalance() external {
398     AccountInfo storage accountInfo = _freeFromEscrow(msg.sender);
399     uint256 amount = accountInfo.freedBalance;
400     if (amount == 0) {
401       revert FETH_No_Funds_To_Withdraw();
402     }
403     delete accountInfo.freedBalance;
404 
405     // With the external call after state changes, we do not need a nonReentrant guard
406     payable(msg.sender).sendValue(amount);
407 
408     emit ETHWithdrawn(msg.sender, msg.sender, amount);
409   }
410 
411   /**
412    * @notice Withdraw the specified number of tokens from the `from` accounts available balance
413    * and send ETH to the destination address, if the `msg.sender` has approval.
414    * @param from The address from which the available funds are to be withdrawn.
415    * @param to The destination address for the ETH to be transferred to.
416    * @param amount The number of tokens to be withdrawn and transferred as ETH.
417    */
418   function withdrawFrom(
419     address from,
420     address payable to,
421     uint256 amount
422   ) external {
423     if (amount == 0) {
424       revert FETH_No_Funds_To_Withdraw();
425     }
426     AccountInfo storage accountInfo = _freeFromEscrow(from);
427     if (from != msg.sender) {
428       _deductAllowanceFrom(accountInfo, amount);
429     }
430     _deductBalanceFrom(accountInfo, amount);
431 
432     // With the external call after state changes, we do not need a nonReentrant guard
433     to.sendValue(amount);
434 
435     emit ETHWithdrawn(from, to, amount);
436   }
437 
438   /**
439    * @dev Require msg.sender has been approved and deducts the amount from the available allowance.
440    */
441   function _deductAllowanceFrom(AccountInfo storage accountInfo, uint256 amount) private {
442     if (accountInfo.allowance[msg.sender] != type(uint256).max) {
443       if (accountInfo.allowance[msg.sender] < amount) {
444         revert FETH_Insufficient_Allowance(accountInfo.allowance[msg.sender]);
445       }
446       // The check above ensures allowance cannot underflow.
447       unchecked {
448         accountInfo.allowance[msg.sender] -= amount;
449       }
450     }
451   }
452 
453   /**
454    * @dev Removes an amount from the account's available FETH balance.
455    */
456   function _deductBalanceFrom(AccountInfo storage accountInfo, uint256 amount) private {
457     // Free from escrow in order to consider any expired escrow balance
458     if (accountInfo.freedBalance < amount) {
459       revert FETH_Insufficient_Available_Funds(accountInfo.freedBalance);
460     }
461     // The check above ensures balance cannot underflow.
462     unchecked {
463       accountInfo.freedBalance -= uint96(amount);
464     }
465   }
466 
467   /**
468    * @dev Moves expired escrow to the available balance.
469    */
470   function _freeFromEscrow(address account) private returns (AccountInfo storage) {
471     AccountInfo storage accountInfo = accountToInfo[account];
472     uint256 escrowIndex = accountInfo.lockupStartIndex;
473     LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
474 
475     // If the first bucket (the oldest) is empty or not yet expired, no change to escrowStartIndex is required
476     if (escrow.expiration == 0 || escrow.expiration >= block.timestamp) {
477       return accountInfo;
478     }
479 
480     while (true) {
481       // Total ETH cannot realistically overflow 96 bits.
482       unchecked {
483         accountInfo.freedBalance += escrow.totalAmount;
484         accountInfo.lockups.del(escrowIndex);
485         // Escrow index cannot overflow 32 bits.
486         escrow = accountInfo.lockups.get(escrowIndex + 1);
487       }
488 
489       // If the next bucket is empty, the start index is set to the previous bucket
490       if (escrow.expiration == 0) {
491         break;
492       }
493 
494       // Escrow index cannot overflow 32 bits.
495       unchecked {
496         // Increment the escrow start index if the next bucket is not empty
497         ++escrowIndex;
498       }
499 
500       // If the next bucket is expired, that's the new start index
501       if (escrow.expiration >= block.timestamp) {
502         break;
503       }
504     }
505 
506     // Escrow index cannot overflow 32 bits.
507     unchecked {
508       accountInfo.lockupStartIndex = uint32(escrowIndex);
509     }
510     return accountInfo;
511   }
512 
513   /**
514    * @notice Lockup an account's FETH tokens for 24-25 hours.
515    */
516   /* solhint-disable-next-line code-complexity */
517   function _marketLockupFor(address account, uint256 amount) private returns (uint256 expiration) {
518     if (account == address(0)) {
519       revert FETH_Cannot_Deposit_For_Lockup_With_Address_Zero();
520     }
521     if (amount == 0) {
522       revert FETH_Must_Lockup_Non_Zero_Amount();
523     }
524 
525     // Block timestamp in seconds is small enough to never overflow
526     unchecked {
527       // Lockup expires after 24 hours, rounded up to the next hour for a total of [24-25) hours
528       expiration = lockupDuration + block.timestamp.ceilDiv(lockupInterval) * lockupInterval;
529     }
530 
531     // Update available escrow
532     // Always free from escrow to ensure the max bucket count is <= 25
533     AccountInfo storage accountInfo = _freeFromEscrow(account);
534     if (msg.value < amount) {
535       // The check above prevents underflow with delta.
536       unchecked {
537         uint256 delta = amount - msg.value;
538         if (accountInfo.freedBalance < delta) {
539           revert FETH_Insufficient_Available_Funds(accountInfo.freedBalance);
540         }
541         // The check above prevents underflow of freed balance.
542         accountInfo.freedBalance -= uint96(delta);
543       }
544     } else if (msg.value != amount) {
545       // There's no reason to send msg.value more than the amount being locked up
546       revert FETH_Too_Much_ETH_Provided();
547     }
548 
549     // Add to locked escrow
550     unchecked {
551       // The number of buckets is always < 256 bits.
552       for (uint256 escrowIndex = accountInfo.lockupStartIndex; ; ++escrowIndex) {
553         LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
554         if (escrow.expiration == 0) {
555           if (expiration > type(uint32).max) {
556             revert FETH_Expiration_Too_Far_In_Future();
557           }
558           // Amount (ETH) will always be < 96 bits.
559           accountInfo.lockups.set(escrowIndex, expiration, amount);
560           break;
561         }
562         if (escrow.expiration == expiration) {
563           // Total ETH will always be < 96 bits.
564           accountInfo.lockups.setTotalAmount(escrowIndex, escrow.totalAmount + amount);
565           break;
566         }
567       }
568     }
569 
570     emit BalanceLocked(account, expiration, amount, msg.value);
571   }
572 
573   /**
574    * @notice Remove an account's lockup, making the FETH tokens available for transfer or withdrawal.
575    */
576   function _marketUnlockFor(
577     address account,
578     uint256 expiration,
579     uint256 amount
580   ) private {
581     AccountInfo storage accountInfo = _removeFromLockedBalance(account, expiration, amount);
582     // Total ETH cannot realistically overflow 96 bits.
583     unchecked {
584       accountInfo.freedBalance += uint96(amount);
585     }
586   }
587 
588   /**
589    * @dev Removes the specified amount from locked escrow, potentially before its expiration.
590    */
591   /* solhint-disable-next-line code-complexity */
592   function _removeFromLockedBalance(
593     address account,
594     uint256 expiration,
595     uint256 amount
596   ) private returns (AccountInfo storage) {
597     if (expiration < block.timestamp) {
598       revert FETH_Escrow_Expired();
599     }
600 
601     AccountInfo storage accountInfo = accountToInfo[account];
602     uint256 escrowIndex = accountInfo.lockupStartIndex;
603     LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
604 
605     if (escrow.expiration == expiration) {
606       // If removing from the first bucket, we may be able to delete it
607       if (escrow.totalAmount == amount) {
608         accountInfo.lockups.del(escrowIndex);
609 
610         // Bump the escrow start index unless it's the last one
611         if (accountInfo.lockups.get(escrowIndex + 1).expiration != 0) {
612           // The number of escrow buckets will never overflow 32 bits.
613           unchecked {
614             ++accountInfo.lockupStartIndex;
615           }
616         }
617       } else {
618         if (escrow.totalAmount < amount) {
619           revert FETH_Insufficient_Escrow(escrow.totalAmount);
620         }
621         // The require above ensures balance will not underflow.
622         unchecked {
623           accountInfo.lockups.setTotalAmount(escrowIndex, escrow.totalAmount - amount);
624         }
625       }
626     } else {
627       // Removing from the 2nd+ bucket
628       while (true) {
629         // The number of escrow buckets will never overflow 32 bits.
630         unchecked {
631           ++escrowIndex;
632         }
633         escrow = accountInfo.lockups.get(escrowIndex);
634         if (escrow.expiration == expiration) {
635           if (amount > escrow.totalAmount) {
636             revert FETH_Insufficient_Escrow(escrow.totalAmount);
637           }
638           // The require above ensures balance will not underflow.
639           unchecked {
640             accountInfo.lockups.setTotalAmount(escrowIndex, escrow.totalAmount - amount);
641           }
642           // We may have an entry with 0 totalAmount but expiration will be set
643           break;
644         }
645         if (escrow.expiration == 0) {
646           revert FETH_Escrow_Not_Found();
647         }
648       }
649     }
650 
651     emit BalanceUnlocked(account, expiration, amount);
652     return accountInfo;
653   }
654 
655   /**
656    * @notice Returns the amount which a spender is still allowed to transact from the `account`'s balance.
657    * @param account The owner of the funds.
658    * @param operator The address with approval to spend from the `account`'s balance.
659    * @return amount The number of tokens the `operator` is still allowed to transact with.
660    */
661   function allowance(address account, address operator) external view returns (uint256 amount) {
662     AccountInfo storage accountInfo = accountToInfo[account];
663     return accountInfo.allowance[operator];
664   }
665 
666   /**
667    * @notice Returns the balance of an account which is available to transfer or withdraw.
668    * @dev This will automatically increase as soon as locked tokens reach their expiry date.
669    * @param account The account to query the available balance of.
670    * @return balance The available balance of the account.
671    */
672   function balanceOf(address account) external view returns (uint256 balance) {
673     AccountInfo storage accountInfo = accountToInfo[account];
674     balance = accountInfo.freedBalance;
675 
676     // Total ETH cannot realistically overflow 96 bits and escrowIndex will always be < 256 bits.
677     unchecked {
678       // Add expired lockups
679       for (uint256 escrowIndex = accountInfo.lockupStartIndex; ; ++escrowIndex) {
680         LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
681         if (escrow.expiration == 0 || escrow.expiration >= block.timestamp) {
682           break;
683         }
684         balance += escrow.totalAmount;
685       }
686     }
687   }
688 
689   /**
690    * @notice Gets the Foundation market address which has permissions to manage lockups.
691    * @return market The Foundation market contract address.
692    */
693   function getFoundationMarket() external view returns (address market) {
694     return foundationMarket;
695   }
696 
697   /**
698    * @notice Returns the balance and each outstanding (unexpired) lockup bucket for an account, grouped by expiry.
699    * @dev `expires.length` == `amounts.length`
700    * and `amounts[i]` is the number of tokens which will expire at `expires[i]`.
701    * The results returned are sorted by expiry, with the earliest expiry date first.
702    * @param account The account to query the locked balance of.
703    * @return expiries The time at which each outstanding lockup bucket expires.
704    * @return amounts The number of FETH tokens which will expire for each outstanding lockup bucket.
705    */
706   function getLockups(address account) external view returns (uint256[] memory expiries, uint256[] memory amounts) {
707     AccountInfo storage accountInfo = accountToInfo[account];
708 
709     // Count lockups
710     uint256 lockedCount;
711     // The number of buckets is always < 256 bits.
712     unchecked {
713       for (uint256 escrowIndex = accountInfo.lockupStartIndex; ; ++escrowIndex) {
714         LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
715         if (escrow.expiration == 0) {
716           break;
717         }
718         if (escrow.expiration >= block.timestamp && escrow.totalAmount > 0) {
719           // Lockup count will never overflow 256 bits.
720           ++lockedCount;
721         }
722       }
723     }
724 
725     // Allocate arrays
726     expiries = new uint256[](lockedCount);
727     amounts = new uint256[](lockedCount);
728 
729     // Populate results
730     uint256 i;
731     // The number of buckets is always < 256 bits.
732     unchecked {
733       for (uint256 escrowIndex = accountInfo.lockupStartIndex; ; ++escrowIndex) {
734         LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
735         if (escrow.expiration == 0) {
736           break;
737         }
738         if (escrow.expiration >= block.timestamp && escrow.totalAmount > 0) {
739           expiries[i] = escrow.expiration;
740           amounts[i] = escrow.totalAmount;
741           ++i;
742         }
743       }
744     }
745   }
746 
747   /**
748    * @notice Returns the total balance of an account, including locked FETH tokens.
749    * @dev Use `balanceOf` to get the number of tokens available for transfer or withdrawal.
750    * @param account The account to query the total balance of.
751    * @return balance The total FETH balance tracked for this account.
752    */
753   function totalBalanceOf(address account) external view returns (uint256 balance) {
754     AccountInfo storage accountInfo = accountToInfo[account];
755     balance = accountInfo.freedBalance;
756 
757     // Total ETH cannot realistically overflow 96 bits and escrowIndex will always be < 256 bits.
758     unchecked {
759       // Add all lockups
760       for (uint256 escrowIndex = accountInfo.lockupStartIndex; ; ++escrowIndex) {
761         LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
762         if (escrow.expiration == 0) {
763           break;
764         }
765         balance += escrow.totalAmount;
766       }
767     }
768   }
769 
770   /**
771    * @notice Returns the total amount of ETH locked in this contract.
772    * @return supply The total amount of ETH locked in this contract.
773    */
774   function totalSupply() external view returns (uint256 supply) {
775     /* It is possible for this to diverge from the total token count by transferring ETH on self destruct
776        but this is on-par with the WETH implementation and done for gas savings. */
777     return address(this).balance;
778   }
779 }
