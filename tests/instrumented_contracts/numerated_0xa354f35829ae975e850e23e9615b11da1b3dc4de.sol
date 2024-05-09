1 # @version 0.2.12
2 """
3 @title Yearn Token Vault
4 @license GNU AGPLv3
5 @author yearn.finance
6 @notice
7     Yearn Token Vault. Holds an underlying token, and allows users to interact
8     with the Yearn ecosystem through Strategies connected to the Vault.
9     Vaults are not limited to a single Strategy, they can have as many Strategies
10     as can be designed (however the withdrawal queue is capped at 20.)
11 
12     Deposited funds are moved into the most impactful strategy that has not
13     already reached its limit for assets under management, regardless of which
14     Strategy a user's funds end up in, they receive their portion of yields
15     generated across all Strategies.
16 
17     When a user withdraws, if there are no funds sitting undeployed in the
18     Vault, the Vault withdraws funds from Strategies in the order of least
19     impact. (Funds are taken from the Strategy that will disturb everyone's
20     gains the least, then the next least, etc.) In order to achieve this, the
21     withdrawal queue's order must be properly set and managed by the community
22     (through governance).
23 
24     Vault Strategies are parameterized to pursue the highest risk-adjusted yield.
25 
26     There is an "Emergency Shutdown" mode. When the Vault is put into emergency
27     shutdown, assets will be recalled from the Strategies as quickly as is
28     practical (given on-chain conditions), minimizing loss. Deposits are
29     halted, new Strategies may not be added, and each Strategy exits with the
30     minimum possible damage to position, while opening up deposits to be
31     withdrawn by users. There are no restrictions on withdrawals above what is
32     expected under Normal Operation.
33 
34     For further details, please refer to the specification:
35     https://github.com/iearn-finance/yearn-vaults/blob/main/SPECIFICATION.md
36 """
37 
38 API_VERSION: constant(String[28]) = "0.4.3"
39 
40 from vyper.interfaces import ERC20
41 
42 implements: ERC20
43 
44 
45 interface DetailedERC20:
46     def name() -> String[42]: view
47     def symbol() -> String[20]: view
48     def decimals() -> uint256: view
49 
50 
51 interface Strategy:
52     def want() -> address: view
53     def vault() -> address: view
54     def isActive() -> bool: view
55     def delegatedAssets() -> uint256: view
56     def estimatedTotalAssets() -> uint256: view
57     def withdraw(_amount: uint256) -> uint256: nonpayable
58     def migrate(_newStrategy: address): nonpayable
59 
60 
61 event Transfer:
62     sender: indexed(address)
63     receiver: indexed(address)
64     value: uint256
65 
66 
67 event Approval:
68     owner: indexed(address)
69     spender: indexed(address)
70     value: uint256
71 
72 
73 name: public(String[64])
74 symbol: public(String[32])
75 decimals: public(uint256)
76 
77 balanceOf: public(HashMap[address, uint256])
78 allowance: public(HashMap[address, HashMap[address, uint256]])
79 totalSupply: public(uint256)
80 
81 token: public(ERC20)
82 governance: public(address)
83 management: public(address)
84 guardian: public(address)
85 pendingGovernance: address
86 
87 struct StrategyParams:
88     performanceFee: uint256  # Strategist's fee (basis points)
89     activation: uint256  # Activation block.timestamp
90     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
91     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
92     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
93     lastReport: uint256  # block.timestamp of the last time a report occured
94     totalDebt: uint256  # Total outstanding debt that Strategy has
95     totalGain: uint256  # Total returns that Strategy has realized for Vault
96     totalLoss: uint256  # Total losses that Strategy has realized for Vault
97 
98 
99 event StrategyAdded:
100     strategy: indexed(address)
101     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
102     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
103     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
104     performanceFee: uint256  # Strategist's fee (basis points)
105 
106 
107 event StrategyReported:
108     strategy: indexed(address)
109     gain: uint256
110     loss: uint256
111     debtPaid: uint256
112     totalGain: uint256
113     totalLoss: uint256
114     totalDebt: uint256
115     debtAdded: uint256
116     debtRatio: uint256
117 
118 
119 event UpdateGovernance:
120     governance: address # New active governance
121 
122 
123 event UpdateManagement:
124     management: address # New active manager
125 
126 event UpdateRewards:
127     rewards: address # New active rewards recipient
128 
129 
130 event UpdateDepositLimit:
131     depositLimit: uint256 # New active deposit limit
132 
133 
134 event UpdatePerformanceFee:
135     performanceFee: uint256 # New active performance fee
136 
137 
138 event UpdateManagementFee:
139     managementFee: uint256 # New active management fee
140 
141 
142 event UpdateGuardian:
143     guardian: address # Address of the active guardian
144 
145 
146 event EmergencyShutdown:
147     active: bool # New emergency shutdown state (if false, normal operation enabled)
148 
149 
150 event UpdateWithdrawalQueue:
151     queue: address[MAXIMUM_STRATEGIES] # New active withdrawal queue
152 
153 
154 event StrategyUpdateDebtRatio:
155     strategy: indexed(address) # Address of the strategy for the debt ratio adjustment
156     debtRatio: uint256 # The new debt limit for the strategy (in BPS of total assets)
157 
158 
159 event StrategyUpdateMinDebtPerHarvest:
160     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
161     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
162 
163 
164 event StrategyUpdateMaxDebtPerHarvest:
165     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
166     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
167 
168 
169 event StrategyUpdatePerformanceFee:
170     strategy: indexed(address) # Address of the strategy for the performance fee adjustment
171     performanceFee: uint256 # The new performance fee for the strategy
172 
173 
174 event StrategyMigrated:
175     oldVersion: indexed(address) # Old version of the strategy to be migrated
176     newVersion: indexed(address) # New version of the strategy
177 
178 
179 event StrategyRevoked:
180     strategy: indexed(address) # Address of the strategy that is revoked
181 
182 
183 event StrategyRemovedFromQueue:
184     strategy: indexed(address) # Address of the strategy that is removed from the withdrawal queue
185 
186 
187 event StrategyAddedToQueue:
188     strategy: indexed(address) # Address of the strategy that is added to the withdrawal queue
189 
190 
191 # NOTE: Track the total for overhead targeting purposes
192 strategies: public(HashMap[address, StrategyParams])
193 MAXIMUM_STRATEGIES: constant(uint256) = 20
194 DEGRADATION_COEFFICIENT: constant(uint256) = 10 ** 18
195 
196 # Ordering that `withdraw` uses to determine which strategies to pull funds from
197 # NOTE: Does *NOT* have to match the ordering of all the current strategies that
198 #       exist, but it is recommended that it does or else withdrawal depth is
199 #       limited to only those inside the queue.
200 # NOTE: Ordering is determined by governance, and should be balanced according
201 #       to risk, slippage, and/or volatility. Can also be ordered to increase the
202 #       withdrawal speed of a particular Strategy.
203 # NOTE: The first time a ZERO_ADDRESS is encountered, it stops withdrawing
204 withdrawalQueue: public(address[MAXIMUM_STRATEGIES])
205 
206 emergencyShutdown: public(bool)
207 
208 depositLimit: public(uint256)  # Limit for totalAssets the Vault can hold
209 debtRatio: public(uint256)  # Debt ratio for the Vault across all strategies (in BPS, <= 10k)
210 totalDebt: public(uint256)  # Amount of tokens that all strategies have borrowed
211 lastReport: public(uint256)  # block.timestamp of last report
212 activation: public(uint256)  # block.timestamp of contract deployment
213 lockedProfit: public(uint256) # how much profit is locked and cant be withdrawn
214 lockedProfitDegradation: public(uint256) # rate per block of degradation. DEGRADATION_COEFFICIENT is 100% per block
215 rewards: public(address)  # Rewards contract where Governance fees are sent to
216 # Governance Fee for management of Vault (given to `rewards`)
217 managementFee: public(uint256)
218 # Governance Fee for performance of Vault (given to `rewards`)
219 performanceFee: public(uint256)
220 MAX_BPS: constant(uint256) = 10_000  # 100%, or 10k basis points
221 # NOTE: A four-century period will be missing 3 of its 100 Julian leap years, leaving 97.
222 #       So the average year has 365 + 97/400 = 365.2425 days
223 #       ERROR(Julian): -0.0078
224 #       ERROR(Gregorian): -0.0003
225 #       A day = 24 * 60 * 60 sec = 86400 sec
226 #       365.2425 * 86400 = 31556952.0
227 SECS_PER_YEAR: constant(uint256) = 31_556_952  # 365.2425 days
228 # `nonces` track `permit` approvals with signature.
229 nonces: public(HashMap[address, uint256])
230 DOMAIN_SEPARATOR: public(bytes32)
231 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
232 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
233 
234 
235 @external
236 def initialize(
237     token: address,
238     governance: address,
239     rewards: address,
240     nameOverride: String[64],
241     symbolOverride: String[32],
242     guardian: address = msg.sender,
243     management: address =  msg.sender,
244 ):
245     """
246     @notice
247         Initializes the Vault, this is called only once, when the contract is
248         deployed.
249         The performance fee is set to 10% of yield, per Strategy.
250         The management fee is set to 2%, per year.
251         The initial deposit limit is set to 0 (deposits disabled); it must be
252         updated after initialization.
253     @dev
254         If `nameOverride` is not specified, the name will be 'yearn'
255         combined with the name of `token`.
256 
257         If `symbolOverride` is not specified, the symbol will be 'yv'
258         combined with the symbol of `token`.
259 
260         The token used by the vault should not change balances outside transfers and 
261         it must transfer the exact amount requested. Fee on transfer and rebasing are not supported.
262     @param token The token that may be deposited into this Vault.
263     @param governance The address authorized for governance interactions.
264     @param rewards The address to distribute rewards to.
265     @param management The address of the vault manager.
266     @param nameOverride Specify a custom Vault name. Leave empty for default choice.
267     @param symbolOverride Specify a custom Vault symbol name. Leave empty for default choice.
268     @param guardian The address authorized for guardian interactions. Defaults to caller.
269     """
270     assert self.activation == 0  # dev: no devops199
271     self.token = ERC20(token)
272     if nameOverride == "":
273         self.name = concat(DetailedERC20(token).symbol(), " yVault")
274     else:
275         self.name = nameOverride
276     if symbolOverride == "":
277         self.symbol = concat("yv", DetailedERC20(token).symbol())
278     else:
279         self.symbol = symbolOverride
280     decimals: uint256 = DetailedERC20(token).decimals()
281     self.decimals = decimals
282     assert decimals < 256 # dev: see VVE-2020-0001
283 
284     self.governance = governance
285     log UpdateGovernance(governance)
286     self.management = management
287     log UpdateManagement(management)
288     self.rewards = rewards
289     log UpdateRewards(rewards)
290     self.guardian = guardian
291     log UpdateGuardian(guardian)
292     self.performanceFee = 1000  # 10% of yield (per Strategy)
293     log UpdatePerformanceFee(convert(1000, uint256))
294     self.managementFee = 200  # 2% per year
295     log UpdateManagementFee(convert(200, uint256))
296     self.lastReport = block.timestamp
297     self.activation = block.timestamp
298     self.lockedProfitDegradation = convert(DEGRADATION_COEFFICIENT * 46 / 10 ** 6 , uint256) # 6 hours in blocks
299     # EIP-712
300     self.DOMAIN_SEPARATOR = keccak256(
301         concat(
302             DOMAIN_TYPE_HASH,
303             keccak256(convert("Yearn Vault", Bytes[11])),
304             keccak256(convert(API_VERSION, Bytes[28])),
305             convert(chain.id, bytes32),
306             convert(self, bytes32)
307         )
308     )
309 
310 
311 @pure
312 @external
313 def apiVersion() -> String[28]:
314     """
315     @notice
316         Used to track the deployed version of this contract. In practice you
317         can use this version number to compare with Yearn's GitHub and
318         determine which version of the source matches this deployed contract.
319     @dev
320         All strategies must have an `apiVersion()` that matches the Vault's
321         `API_VERSION`.
322     @return API_VERSION which holds the current version of this contract.
323     """
324     return API_VERSION
325 
326 
327 @external
328 def setName(name: String[42]):
329     """
330     @notice
331         Used to change the value of `name`.
332 
333         This may only be called by governance.
334     @param name The new name to use.
335     """
336     assert msg.sender == self.governance
337     self.name = name
338 
339 
340 @external
341 def setSymbol(symbol: String[20]):
342     """
343     @notice
344         Used to change the value of `symbol`.
345 
346         This may only be called by governance.
347     @param symbol The new symbol to use.
348     """
349     assert msg.sender == self.governance
350     self.symbol = symbol
351 
352 
353 # 2-phase commit for a change in governance
354 @external
355 def setGovernance(governance: address):
356     """
357     @notice
358         Nominate a new address to use as governance.
359 
360         The change does not go into effect immediately. This function sets a
361         pending change, and the governance address is not updated until
362         the proposed governance address has accepted the responsibility.
363 
364         This may only be called by the current governance address.
365     @param governance The address requested to take over Vault governance.
366     """
367     assert msg.sender == self.governance
368     self.pendingGovernance = governance
369 
370 
371 @external
372 def acceptGovernance():
373     """
374     @notice
375         Once a new governance address has been proposed using setGovernance(),
376         this function may be called by the proposed address to accept the
377         responsibility of taking over governance for this contract.
378 
379         This may only be called by the proposed governance address.
380     @dev
381         setGovernance() should be called by the existing governance address,
382         prior to calling this function.
383     """
384     assert msg.sender == self.pendingGovernance
385     self.governance = msg.sender
386     log UpdateGovernance(msg.sender)
387 
388 
389 @external
390 def setManagement(management: address):
391     """
392     @notice
393         Changes the management address.
394         Management is able to make some investment decisions adjusting parameters.
395 
396         This may only be called by governance.
397     @param management The address to use for managing.
398     """
399     assert msg.sender == self.governance
400     self.management = management
401     log UpdateManagement(management)
402 
403 
404 @external
405 def setRewards(rewards: address):
406     """
407     @notice
408         Changes the rewards address. Any distributed rewards
409         will cease flowing to the old address and begin flowing
410         to this address once the change is in effect.
411 
412         This will not change any Strategy reports in progress, only
413         new reports made after this change goes into effect.
414 
415         This may only be called by governance.
416     @param rewards The address to use for collecting rewards.
417     """
418     assert msg.sender == self.governance
419     assert not (rewards in [self, ZERO_ADDRESS])
420     self.rewards = rewards
421     log UpdateRewards(rewards)
422 
423 
424 @external
425 def setLockedProfitDegradation(degradation: uint256):
426     """
427     @notice
428         Changes the locked profit degradation.
429     @param degradation The rate of degradation in percent per second scaled to 1e18.
430     """
431     assert msg.sender == self.governance
432     # Since "degradation" is of type uint256 it can never be less than zero
433     assert degradation <= DEGRADATION_COEFFICIENT
434     self.lockedProfitDegradation = degradation
435 
436 
437 @external
438 def setDepositLimit(limit: uint256):
439     """
440     @notice
441         Changes the maximum amount of tokens that can be deposited in this Vault.
442 
443         Note, this is not how much may be deposited by a single depositor,
444         but the maximum amount that may be deposited across all depositors.
445 
446         This may only be called by governance.
447     @param limit The new deposit limit to use.
448     """
449     assert msg.sender == self.governance
450     self.depositLimit = limit
451     log UpdateDepositLimit(limit)
452 
453 
454 @external
455 def setPerformanceFee(fee: uint256):
456     """
457     @notice
458         Used to change the value of `performanceFee`.
459 
460         Should set this value below the maximum strategist performance fee.
461 
462         This may only be called by governance.
463     @param fee The new performance fee to use.
464     """
465     assert msg.sender == self.governance
466     assert fee <= MAX_BPS / 2
467     self.performanceFee = fee
468     log UpdatePerformanceFee(fee)
469 
470 
471 @external
472 def setManagementFee(fee: uint256):
473     """
474     @notice
475         Used to change the value of `managementFee`.
476 
477         This may only be called by governance.
478     @param fee The new management fee to use.
479     """
480     assert msg.sender == self.governance
481     assert fee <= MAX_BPS
482     self.managementFee = fee
483     log UpdateManagementFee(fee)
484 
485 
486 @external
487 def setGuardian(guardian: address):
488     """
489     @notice
490         Used to change the address of `guardian`.
491 
492         This may only be called by governance or the existing guardian.
493     @param guardian The new guardian address to use.
494     """
495     assert msg.sender in [self.guardian, self.governance]
496     self.guardian = guardian
497     log UpdateGuardian(guardian)
498 
499 
500 @external
501 def setEmergencyShutdown(active: bool):
502     """
503     @notice
504         Activates or deactivates Vault mode where all Strategies go into full
505         withdrawal.
506 
507         During Emergency Shutdown:
508         1. No Users may deposit into the Vault (but may withdraw as usual.)
509         2. Governance may not add new Strategies.
510         3. Each Strategy must pay back their debt as quickly as reasonable to
511             minimally affect their position.
512         4. Only Governance may undo Emergency Shutdown.
513 
514         See contract level note for further details.
515 
516         This may only be called by governance or the guardian.
517     @param active
518         If true, the Vault goes into Emergency Shutdown. If false, the Vault
519         goes back into Normal Operation.
520     """
521     if active:
522         assert msg.sender in [self.guardian, self.governance]
523     else:
524         assert msg.sender == self.governance
525     self.emergencyShutdown = active
526     log EmergencyShutdown(active)
527 
528 
529 @external
530 def setWithdrawalQueue(queue: address[MAXIMUM_STRATEGIES]):
531     """
532     @notice
533         Updates the withdrawalQueue to match the addresses and order specified
534         by `queue`.
535 
536         There can be fewer strategies than the maximum, as well as fewer than
537         the total number of strategies active in the vault. `withdrawalQueue`
538         will be updated in a gas-efficient manner, assuming the input is well-
539         ordered with 0x0 only at the end.
540 
541         This may only be called by governance or management.
542     @dev
543         This is order sensitive, specify the addresses in the order in which
544         funds should be withdrawn (so `queue`[0] is the first Strategy withdrawn
545         from, `queue`[1] is the second, etc.)
546 
547         This means that the least impactful Strategy (the Strategy that will have
548         its core positions impacted the least by having funds removed) should be
549         at `queue`[0], then the next least impactful at `queue`[1], and so on.
550     @param queue
551         The array of addresses to use as the new withdrawal queue. This is
552         order sensitive.
553     """
554     assert msg.sender in [self.management, self.governance]
555 
556     # HACK: Temporary until Vyper adds support for Dynamic arrays
557     old_queue: address[MAXIMUM_STRATEGIES] = empty(address[MAXIMUM_STRATEGIES])
558     for i in range(MAXIMUM_STRATEGIES):
559         old_queue[i] = self.withdrawalQueue[i] 
560         if queue[i] == ZERO_ADDRESS:
561             # NOTE: Cannot use this method to remove entries from the queue
562             assert old_queue[i] == ZERO_ADDRESS
563             break
564         # NOTE: Cannot use this method to add more entries to the queue
565         assert old_queue[i] != ZERO_ADDRESS
566 
567         assert self.strategies[queue[i]].activation > 0
568 
569         existsInOldQueue: bool = False
570         for j in range(MAXIMUM_STRATEGIES):
571             if queue[j] == ZERO_ADDRESS:
572                 existsInOldQueue = True
573                 break
574             if queue[i] == old_queue[j]:
575                 # NOTE: Ensure that every entry in queue prior to reordering exists now
576                 existsInOldQueue = True
577 
578             if j <= i:
579                 # NOTE: This will only check for duplicate entries in queue after `i`
580                 continue
581             assert queue[i] != queue[j]  # dev: do not add duplicate strategies
582 
583         assert existsInOldQueue # dev: do not add new strategies
584 
585         self.withdrawalQueue[i] = queue[i]
586     log UpdateWithdrawalQueue(queue)
587 
588 
589 @internal
590 def erc20_safe_transfer(token: address, receiver: address, amount: uint256):
591     # Used only to send tokens that are not the type managed by this Vault.
592     # HACK: Used to handle non-compliant tokens like USDT
593     response: Bytes[32] = raw_call(
594         token,
595         concat(
596             method_id("transfer(address,uint256)"),
597             convert(receiver, bytes32),
598             convert(amount, bytes32),
599         ),
600         max_outsize=32,
601     )
602     if len(response) > 0:
603         assert convert(response, bool), "Transfer failed!"
604 
605 
606 @internal
607 def erc20_safe_transferFrom(token: address, sender: address, receiver: address, amount: uint256):
608     # Used only to send tokens that are not the type managed by this Vault.
609     # HACK: Used to handle non-compliant tokens like USDT
610     response: Bytes[32] = raw_call(
611         token,
612         concat(
613             method_id("transferFrom(address,address,uint256)"),
614             convert(sender, bytes32),
615             convert(receiver, bytes32),
616             convert(amount, bytes32),
617         ),
618         max_outsize=32,
619     )
620     if len(response) > 0:
621         assert convert(response, bool), "Transfer failed!"
622 
623 
624 @internal
625 def _transfer(sender: address, receiver: address, amount: uint256):
626     # See note on `transfer()`.
627 
628     # Protect people from accidentally sending their shares to bad places
629     assert receiver not in [self, ZERO_ADDRESS]
630     self.balanceOf[sender] -= amount
631     self.balanceOf[receiver] += amount
632     log Transfer(sender, receiver, amount)
633 
634 
635 @external
636 def transfer(receiver: address, amount: uint256) -> bool:
637     """
638     @notice
639         Transfers shares from the caller's address to `receiver`. This function
640         will always return true, unless the user is attempting to transfer
641         shares to this contract's address, or to 0x0.
642     @param receiver
643         The address shares are being transferred to. Must not be this contract's
644         address, must not be 0x0.
645     @param amount The quantity of shares to transfer.
646     @return
647         True if transfer is sent to an address other than this contract's or
648         0x0, otherwise the transaction will fail.
649     """
650     self._transfer(msg.sender, receiver, amount)
651     return True
652 
653 
654 @external
655 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
656     """
657     @notice
658         Transfers `amount` shares from `sender` to `receiver`. This operation will
659         always return true, unless the user is attempting to transfer shares
660         to this contract's address, or to 0x0.
661 
662         Unless the caller has given this contract unlimited approval,
663         transfering shares will decrement the caller's `allowance` by `amount`.
664     @param sender The address shares are being transferred from.
665     @param receiver
666         The address shares are being transferred to. Must not be this contract's
667         address, must not be 0x0.
668     @param amount The quantity of shares to transfer.
669     @return
670         True if transfer is sent to an address other than this contract's or
671         0x0, otherwise the transaction will fail.
672     """
673     # Unlimited approval (saves an SSTORE)
674     if (self.allowance[sender][msg.sender] < MAX_UINT256):
675         allowance: uint256 = self.allowance[sender][msg.sender] - amount
676         self.allowance[sender][msg.sender] = allowance
677         # NOTE: Allows log filters to have a full accounting of allowance changes
678         log Approval(sender, msg.sender, allowance)
679     self._transfer(sender, receiver, amount)
680     return True
681 
682 
683 @external
684 def approve(spender: address, amount: uint256) -> bool:
685     """
686     @dev Approve the passed address to spend the specified amount of tokens on behalf of
687          `msg.sender`. Beware that changing an allowance with this method brings the risk
688          that someone may use both the old and the new allowance by unfortunate transaction
689          ordering. See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
690     @param spender The address which will spend the funds.
691     @param amount The amount of tokens to be spent.
692     """
693     self.allowance[msg.sender][spender] = amount
694     log Approval(msg.sender, spender, amount)
695     return True
696 
697 
698 @external
699 def increaseAllowance(spender: address, amount: uint256) -> bool:
700     """
701     @dev Increase the allowance of the passed address to spend the total amount of tokens
702          on behalf of msg.sender. This method mitigates the risk that someone may use both
703          the old and the new allowance by unfortunate transaction ordering.
704          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
705     @param spender The address which will spend the funds.
706     @param amount The amount of tokens to increase the allowance by.
707     """
708     self.allowance[msg.sender][spender] += amount
709     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
710     return True
711 
712 
713 @external
714 def decreaseAllowance(spender: address, amount: uint256) -> bool:
715     """
716     @dev Decrease the allowance of the passed address to spend the total amount of tokens
717          on behalf of msg.sender. This method mitigates the risk that someone may use both
718          the old and the new allowance by unfortunate transaction ordering.
719          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
720     @param spender The address which will spend the funds.
721     @param amount The amount of tokens to decrease the allowance by.
722     """
723     self.allowance[msg.sender][spender] -= amount
724     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
725     return True
726 
727 
728 @external
729 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
730     """
731     @notice
732         Approves spender by owner's signature to expend owner's tokens.
733         See https://eips.ethereum.org/EIPS/eip-2612.
734 
735     @param owner The address which is a source of funds and has signed the Permit.
736     @param spender The address which is allowed to spend the funds.
737     @param amount The amount of tokens to be spent.
738     @param expiry The timestamp after which the Permit is no longer valid.
739     @param signature A valid secp256k1 signature of Permit by owner encoded as r, s, v.
740     @return True, if transaction completes successfully
741     """
742     assert owner != ZERO_ADDRESS  # dev: invalid owner
743     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
744     nonce: uint256 = self.nonces[owner]
745     digest: bytes32 = keccak256(
746         concat(
747             b'\x19\x01',
748             self.DOMAIN_SEPARATOR,
749             keccak256(
750                 concat(
751                     PERMIT_TYPE_HASH,
752                     convert(owner, bytes32),
753                     convert(spender, bytes32),
754                     convert(amount, bytes32),
755                     convert(nonce, bytes32),
756                     convert(expiry, bytes32),
757                 )
758             )
759         )
760     )
761     # NOTE: signature is packed as r, s, v
762     r: uint256 = convert(slice(signature, 0, 32), uint256)
763     s: uint256 = convert(slice(signature, 32, 32), uint256)
764     v: uint256 = convert(slice(signature, 64, 1), uint256)
765     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
766     self.allowance[owner][spender] = amount
767     self.nonces[owner] = nonce + 1
768     log Approval(owner, spender, amount)
769     return True
770 
771 
772 @view
773 @internal
774 def _totalAssets() -> uint256:
775     # See note on `totalAssets()`.
776     return self.token.balanceOf(self) + self.totalDebt
777 
778 
779 @view
780 @external
781 def totalAssets() -> uint256:
782     """
783     @notice
784         Returns the total quantity of all assets under control of this
785         Vault, whether they're loaned out to a Strategy, or currently held in
786         the Vault.
787     @return The total assets under control of this Vault.
788     """
789     return self._totalAssets()
790 
791 
792 @view
793 @internal
794 def _calculateLockedProfit() -> uint256:
795     lockedFundsRatio: uint256 = (block.timestamp - self.lastReport) * self.lockedProfitDegradation
796 
797     if(lockedFundsRatio < DEGRADATION_COEFFICIENT):
798         lockedProfit: uint256 = self.lockedProfit
799         return lockedProfit - (
800                 lockedFundsRatio
801                 * lockedProfit
802                 / DEGRADATION_COEFFICIENT
803             )
804     else:        
805         return 0
806 
807 @view
808 @internal
809 def _freeFunds() -> uint256:
810     return self._totalAssets() - self._calculateLockedProfit()
811 
812 @internal
813 def _issueSharesForAmount(to: address, amount: uint256) -> uint256:
814     # Issues `amount` Vault shares to `to`.
815     # Shares must be issued prior to taking on new collateral, or
816     # calculation will be wrong. This means that only *trusted* tokens
817     # (with no capability for exploitative behavior) can be used.
818     shares: uint256 = 0
819     # HACK: Saves 2 SLOADs (~200 gas, post-Berlin)
820     totalSupply: uint256 = self.totalSupply
821     if totalSupply > 0:
822         # Mint amount of shares based on what the Vault is managing overall
823         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
824         shares =  amount * totalSupply / self._freeFunds()  # dev: no free funds
825     else:
826         # No existing shares, so mint 1:1
827         shares = amount
828     assert shares != 0 # dev: division rounding resulted in zero
829 
830     # Mint new shares
831     self.totalSupply = totalSupply + shares
832     self.balanceOf[to] += shares
833     log Transfer(ZERO_ADDRESS, to, shares)
834 
835     return shares
836 
837 
838 @external
839 @nonreentrant("withdraw")
840 def deposit(_amount: uint256 = MAX_UINT256, recipient: address = msg.sender) -> uint256:
841     """
842     @notice
843         Deposits `_amount` `token`, issuing shares to `recipient`. If the
844         Vault is in Emergency Shutdown, deposits will not be accepted and this
845         call will fail.
846     @dev
847         Measuring quantity of shares to issues is based on the total
848         outstanding debt that this contract has ("expected value") instead
849         of the total balance sheet it has ("estimated value") has important
850         security considerations, and is done intentionally. If this value were
851         measured against external systems, it could be purposely manipulated by
852         an attacker to withdraw more assets than they otherwise should be able
853         to claim by redeeming their shares.
854 
855         On deposit, this means that shares are issued against the total amount
856         that the deposited capital can be given in service of the debt that
857         Strategies assume. If that number were to be lower than the "expected
858         value" at some future point, depositing shares via this method could
859         entitle the depositor to *less* than the deposited value once the
860         "realized value" is updated from further reports by the Strategies
861         to the Vaults.
862 
863         Care should be taken by integrators to account for this discrepancy,
864         by using the view-only methods of this contract (both off-chain and
865         on-chain) to determine if depositing into the Vault is a "good idea".
866     @param _amount The quantity of tokens to deposit, defaults to all.
867     @param recipient
868         The address to issue the shares in this Vault to. Defaults to the
869         caller's address.
870     @return The issued Vault shares.
871     """
872     assert not self.emergencyShutdown  # Deposits are locked out
873     assert recipient not in [self, ZERO_ADDRESS]
874 
875     amount: uint256 = _amount
876 
877     # If _amount not specified, transfer the full token balance,
878     # up to deposit limit
879     if amount == MAX_UINT256:
880         amount = min(
881             self.depositLimit - self._totalAssets(),
882             self.token.balanceOf(msg.sender),
883         )
884     else:
885         # Ensure deposit limit is respected
886         assert self._totalAssets() + amount <= self.depositLimit
887 
888     # Ensure we are depositing something
889     assert amount > 0
890 
891     # Issue new shares (needs to be done before taking deposit to be accurate)
892     # Shares are issued to recipient (may be different from msg.sender)
893     # See @dev note, above.
894     shares: uint256 = self._issueSharesForAmount(recipient, amount)
895 
896     # Tokens are transferred from msg.sender (may be different from _recipient)
897     self.erc20_safe_transferFrom(self.token.address, msg.sender, self, amount)
898 
899     return shares  # Just in case someone wants them
900 
901 
902 @view
903 @internal
904 def _shareValue(shares: uint256) -> uint256:
905     # Returns price = 1:1 if vault is empty
906     if self.totalSupply == 0:
907         return shares
908 
909     # Determines the current value of `shares`.
910     # NOTE: if sqrt(Vault.totalAssets()) >>> 1e39, this could potentially revert
911 
912     return (
913         shares
914         * self._freeFunds()
915         / self.totalSupply
916     )
917 
918 
919 @view
920 @internal
921 def _sharesForAmount(amount: uint256) -> uint256:
922     # Determines how many shares `amount` of token would receive.
923     # See dev note on `deposit`.
924     _freeFunds: uint256 = self._freeFunds()
925     if _freeFunds > 0:
926         # NOTE: if sqrt(token.totalSupply()) > 1e37, this could potentially revert
927         return  (
928             amount
929             * self.totalSupply
930             / _freeFunds 
931         )
932     else:
933         return 0
934 
935 
936 @view
937 @external
938 def maxAvailableShares() -> uint256:
939     """
940     @notice
941         Determines the maximum quantity of shares this Vault can facilitate a
942         withdrawal for, factoring in assets currently residing in the Vault,
943         as well as those deployed to strategies on the Vault's balance sheet.
944     @dev
945         Regarding how shares are calculated, see dev note on `deposit`.
946 
947         If you want to calculated the maximum a user could withdraw up to,
948         you want to use this function.
949 
950         Note that the amount provided by this function is the theoretical
951         maximum possible from withdrawing, the real amount depends on the
952         realized losses incurred during withdrawal.
953     @return The total quantity of shares this Vault can provide.
954     """
955     shares: uint256 = self._sharesForAmount(self.token.balanceOf(self))
956 
957     for strategy in self.withdrawalQueue:
958         if strategy == ZERO_ADDRESS:
959             break
960         shares += self._sharesForAmount(self.strategies[strategy].totalDebt)
961 
962     return shares
963 
964 
965 @internal
966 def _reportLoss(strategy: address, loss: uint256):
967     # Loss can only be up the amount of debt issued to strategy
968     totalDebt: uint256 = self.strategies[strategy].totalDebt
969     assert totalDebt >= loss
970 
971     # Also, make sure we reduce our trust with the strategy by the amount of loss
972     if self.debtRatio != 0: # if vault with single strategy that is set to EmergencyOne
973         # NOTE: The context to this calculation is different than the calculation in `_reportLoss`,
974         # this calculation intentionally approximates via `totalDebt` to avoid manipulatable results
975         ratio_change: uint256 = min(
976             # NOTE: This calculation isn't 100% precise, the adjustment is ~10%-20% more severe due to EVM math
977             loss * self.debtRatio / self.totalDebt,
978             self.strategies[strategy].debtRatio,
979         )
980         self.strategies[strategy].debtRatio -= ratio_change
981         self.debtRatio -= ratio_change
982     # Finally, adjust our strategy's parameters by the loss
983     self.strategies[strategy].totalLoss += loss
984     self.strategies[strategy].totalDebt = totalDebt - loss
985     self.totalDebt -= loss
986 
987 
988 @external
989 @nonreentrant("withdraw")
990 def withdraw(
991     maxShares: uint256 = MAX_UINT256,
992     recipient: address = msg.sender,
993     maxLoss: uint256 = 1,  # 0.01% [BPS]
994 ) -> uint256:
995     """
996     @notice
997         Withdraws the calling account's tokens from this Vault, redeeming
998         amount `_shares` for an appropriate amount of tokens.
999 
1000         See note on `setWithdrawalQueue` for further details of withdrawal
1001         ordering and behavior.
1002     @dev
1003         Measuring the value of shares is based on the total outstanding debt
1004         that this contract has ("expected value") instead of the total balance
1005         sheet it has ("estimated value") has important security considerations,
1006         and is done intentionally. If this value were measured against external
1007         systems, it could be purposely manipulated by an attacker to withdraw
1008         more assets than they otherwise should be able to claim by redeeming
1009         their shares.
1010 
1011         On withdrawal, this means that shares are redeemed against the total
1012         amount that the deposited capital had "realized" since the point it
1013         was deposited, up until the point it was withdrawn. If that number
1014         were to be higher than the "expected value" at some future point,
1015         withdrawing shares via this method could entitle the depositor to
1016         *more* than the expected value once the "realized value" is updated
1017         from further reports by the Strategies to the Vaults.
1018 
1019         Under exceptional scenarios, this could cause earlier withdrawals to
1020         earn "more" of the underlying assets than Users might otherwise be
1021         entitled to, if the Vault's estimated value were otherwise measured
1022         through external means, accounting for whatever exceptional scenarios
1023         exist for the Vault (that aren't covered by the Vault's own design.)
1024 
1025         In the situation where a large withdrawal happens, it can empty the 
1026         vault balance and the strategies in the withdrawal queue. 
1027         Strategies not in the withdrawal queue will have to be harvested to 
1028         rebalance the funds and make the funds available again to withdraw.
1029     @param maxShares
1030         How many shares to try and redeem for tokens, defaults to all.
1031     @param recipient
1032         The address to issue the shares in this Vault to. Defaults to the
1033         caller's address.
1034     @param maxLoss
1035         The maximum acceptable loss to sustain on withdrawal. Defaults to 0.01%.
1036         If a loss is specified, up to that amount of shares may be burnt to cover losses on withdrawal.
1037     @return The quantity of tokens redeemed for `_shares`.
1038     """
1039     shares: uint256 = maxShares  # May reduce this number below
1040 
1041     # Max Loss is <=100%, revert otherwise
1042     assert maxLoss <= MAX_BPS
1043 
1044     # If _shares not specified, transfer full share balance
1045     if shares == MAX_UINT256:
1046         shares = self.balanceOf[msg.sender]
1047 
1048     # Limit to only the shares they own
1049     assert shares <= self.balanceOf[msg.sender]
1050 
1051     # Ensure we are withdrawing something
1052     assert shares > 0
1053 
1054     # See @dev note, above.
1055     value: uint256 = self._shareValue(shares)
1056 
1057     if value > self.token.balanceOf(self):
1058         totalLoss: uint256 = 0
1059         # We need to go get some from our strategies in the withdrawal queue
1060         # NOTE: This performs forced withdrawals from each Strategy. During
1061         #       forced withdrawal, a Strategy may realize a loss. That loss
1062         #       is reported back to the Vault, and the will affect the amount
1063         #       of tokens that the withdrawer receives for their shares. They
1064         #       can optionally specify the maximum acceptable loss (in BPS)
1065         #       to prevent excessive losses on their withdrawals (which may
1066         #       happen in certain edge cases where Strategies realize a loss)
1067         for strategy in self.withdrawalQueue:
1068             if strategy == ZERO_ADDRESS:
1069                 break  # We've exhausted the queue
1070 
1071             vault_balance: uint256 = self.token.balanceOf(self)
1072             if value <= vault_balance:
1073                 break  # We're done withdrawing
1074 
1075             amountNeeded: uint256 = value - vault_balance
1076 
1077             # NOTE: Don't withdraw more than the debt so that Strategy can still
1078             #       continue to work based on the profits it has
1079             # NOTE: This means that user will lose out on any profits that each
1080             #       Strategy in the queue would return on next harvest, benefiting others
1081             amountNeeded = min(amountNeeded, self.strategies[strategy].totalDebt)
1082             if amountNeeded == 0:
1083                 continue  # Nothing to withdraw from this Strategy, try the next one
1084 
1085             # Force withdraw amount from each Strategy in the order set by governance
1086             loss: uint256 = Strategy(strategy).withdraw(amountNeeded)
1087             withdrawn: uint256 = self.token.balanceOf(self) - vault_balance
1088 
1089             # NOTE: Withdrawer incurs any losses from liquidation
1090             if loss > 0:
1091                 value -= loss
1092                 totalLoss += loss
1093                 self._reportLoss(strategy, loss)
1094 
1095             # Reduce the Strategy's debt by the amount withdrawn ("realized returns")
1096             # NOTE: This doesn't add to returns as it's not earned by "normal means"
1097             self.strategies[strategy].totalDebt -= withdrawn
1098             self.totalDebt -= withdrawn
1099 
1100         # NOTE: We have withdrawn everything possible out of the withdrawal queue
1101         #       but we still don't have enough to fully pay them back, so adjust
1102         #       to the total amount we've freed up through forced withdrawals
1103         vault_balance: uint256 = self.token.balanceOf(self)
1104         if value > vault_balance:
1105             value = vault_balance
1106             # NOTE: Burn # of shares that corresponds to what Vault has on-hand,
1107             #       including the losses that were incurred above during withdrawals
1108             shares = self._sharesForAmount(value + totalLoss)
1109 
1110         # NOTE: This loss protection is put in place to revert if losses from
1111         #       withdrawing are more than what is considered acceptable.
1112         assert totalLoss <= maxLoss * (value + totalLoss) / MAX_BPS
1113 
1114     # Burn shares (full value of what is being withdrawn)
1115     self.totalSupply -= shares
1116     self.balanceOf[msg.sender] -= shares
1117     log Transfer(msg.sender, ZERO_ADDRESS, shares)
1118 
1119     # Withdraw remaining balance to _recipient (may be different to msg.sender) (minus fee)
1120     self.erc20_safe_transfer(self.token.address, recipient, value)
1121 
1122     return value
1123 
1124 
1125 @view
1126 @external
1127 def pricePerShare() -> uint256:
1128     """
1129     @notice Gives the price for a single Vault share.
1130     @dev See dev note on `withdraw`.
1131     @return The value of a single share.
1132     """
1133     return self._shareValue(10 ** self.decimals)
1134 
1135 
1136 @internal
1137 def _organizeWithdrawalQueue():
1138     # Reorganize `withdrawalQueue` based on premise that if there is an
1139     # empty value between two actual values, then the empty value should be
1140     # replaced by the later value.
1141     # NOTE: Relative ordering of non-zero values is maintained.
1142     offset: uint256 = 0
1143     for idx in range(MAXIMUM_STRATEGIES):
1144         strategy: address = self.withdrawalQueue[idx]
1145         if strategy == ZERO_ADDRESS:
1146             offset += 1  # how many values we need to shift, always `<= idx`
1147         elif offset > 0:
1148             self.withdrawalQueue[idx - offset] = strategy
1149             self.withdrawalQueue[idx] = ZERO_ADDRESS
1150 
1151 
1152 @external
1153 def addStrategy(
1154     strategy: address,
1155     debtRatio: uint256,
1156     minDebtPerHarvest: uint256,
1157     maxDebtPerHarvest: uint256,
1158     performanceFee: uint256,
1159 ):
1160     """
1161     @notice
1162         Add a Strategy to the Vault.
1163 
1164         This may only be called by governance.
1165     @dev
1166         The Strategy will be appended to `withdrawalQueue`, call
1167         `setWithdrawalQueue` to change the order.
1168     @param strategy The address of the Strategy to add.
1169     @param debtRatio
1170         The share of the total assets in the `vault that the `strategy` has access to.
1171     @param minDebtPerHarvest
1172         Lower limit on the increase of debt since last harvest
1173     @param maxDebtPerHarvest
1174         Upper limit on the increase of debt since last harvest
1175     @param performanceFee
1176         The fee the strategist will receive based on this Vault's performance.
1177     """
1178     # Check if queue is full
1179     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1180 
1181     # Check calling conditions
1182     assert not self.emergencyShutdown
1183     assert msg.sender == self.governance
1184 
1185     # Check strategy configuration
1186     assert strategy != ZERO_ADDRESS
1187     assert self.strategies[strategy].activation == 0
1188     assert self == Strategy(strategy).vault()
1189     assert self.token.address == Strategy(strategy).want()
1190 
1191     # Check strategy parameters
1192     assert self.debtRatio + debtRatio <= MAX_BPS
1193     assert minDebtPerHarvest <= maxDebtPerHarvest
1194     assert performanceFee <= MAX_BPS / 2 
1195 
1196     # Add strategy to approved strategies
1197     self.strategies[strategy] = StrategyParams({
1198         performanceFee: performanceFee,
1199         activation: block.timestamp,
1200         debtRatio: debtRatio,
1201         minDebtPerHarvest: minDebtPerHarvest,
1202         maxDebtPerHarvest: maxDebtPerHarvest,
1203         lastReport: block.timestamp,
1204         totalDebt: 0,
1205         totalGain: 0,
1206         totalLoss: 0,
1207     })
1208     log StrategyAdded(strategy, debtRatio, minDebtPerHarvest, maxDebtPerHarvest, performanceFee)
1209 
1210     # Update Vault parameters
1211     self.debtRatio += debtRatio
1212 
1213     # Add strategy to the end of the withdrawal queue
1214     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1215     self._organizeWithdrawalQueue()
1216 
1217 
1218 @external
1219 def updateStrategyDebtRatio(
1220     strategy: address,
1221     debtRatio: uint256,
1222 ):
1223     """
1224     @notice
1225         Change the quantity of assets `strategy` may manage.
1226 
1227         This may be called by governance or management.
1228     @param strategy The Strategy to update.
1229     @param debtRatio The quantity of assets `strategy` may now manage.
1230     """
1231     assert msg.sender in [self.management, self.governance]
1232     assert self.strategies[strategy].activation > 0
1233     self.debtRatio -= self.strategies[strategy].debtRatio
1234     self.strategies[strategy].debtRatio = debtRatio
1235     self.debtRatio += debtRatio
1236     assert self.debtRatio <= MAX_BPS
1237     log StrategyUpdateDebtRatio(strategy, debtRatio)
1238 
1239 
1240 @external
1241 def updateStrategyMinDebtPerHarvest(
1242     strategy: address,
1243     minDebtPerHarvest: uint256,
1244 ):
1245     """
1246     @notice
1247         Change the quantity assets per block this Vault may deposit to or
1248         withdraw from `strategy`.
1249 
1250         This may only be called by governance or management.
1251     @param strategy The Strategy to update.
1252     @param minDebtPerHarvest
1253         Lower limit on the increase of debt since last harvest
1254     """
1255     assert msg.sender in [self.management, self.governance]
1256     assert self.strategies[strategy].activation > 0
1257     assert self.strategies[strategy].maxDebtPerHarvest >= minDebtPerHarvest
1258     self.strategies[strategy].minDebtPerHarvest = minDebtPerHarvest
1259     log StrategyUpdateMinDebtPerHarvest(strategy, minDebtPerHarvest)
1260 
1261 
1262 @external
1263 def updateStrategyMaxDebtPerHarvest(
1264     strategy: address,
1265     maxDebtPerHarvest: uint256,
1266 ):
1267     """
1268     @notice
1269         Change the quantity assets per block this Vault may deposit to or
1270         withdraw from `strategy`.
1271 
1272         This may only be called by governance or management.
1273     @param strategy The Strategy to update.
1274     @param maxDebtPerHarvest
1275         Upper limit on the increase of debt since last harvest
1276     """
1277     assert msg.sender in [self.management, self.governance]
1278     assert self.strategies[strategy].activation > 0
1279     assert self.strategies[strategy].minDebtPerHarvest <= maxDebtPerHarvest
1280     self.strategies[strategy].maxDebtPerHarvest = maxDebtPerHarvest
1281     log StrategyUpdateMaxDebtPerHarvest(strategy, maxDebtPerHarvest)
1282 
1283 
1284 @external
1285 def updateStrategyPerformanceFee(
1286     strategy: address,
1287     performanceFee: uint256,
1288 ):
1289     """
1290     @notice
1291         Change the fee the strategist will receive based on this Vault's
1292         performance.
1293 
1294         This may only be called by governance.
1295     @param strategy The Strategy to update.
1296     @param performanceFee The new fee the strategist will receive.
1297     """
1298     assert msg.sender == self.governance
1299     assert performanceFee <= MAX_BPS / 2
1300     assert self.strategies[strategy].activation > 0
1301     self.strategies[strategy].performanceFee = performanceFee
1302     log StrategyUpdatePerformanceFee(strategy, performanceFee)
1303 
1304 
1305 @internal
1306 def _revokeStrategy(strategy: address):
1307     self.debtRatio -= self.strategies[strategy].debtRatio
1308     self.strategies[strategy].debtRatio = 0
1309     log StrategyRevoked(strategy)
1310 
1311 
1312 @external
1313 def migrateStrategy(oldVersion: address, newVersion: address):
1314     """
1315     @notice
1316         Migrates a Strategy, including all assets from `oldVersion` to
1317         `newVersion`.
1318 
1319         This may only be called by governance.
1320     @dev
1321         Strategy must successfully migrate all capital and positions to new
1322         Strategy, or else this will upset the balance of the Vault.
1323 
1324         The new Strategy should be "empty" e.g. have no prior commitments to
1325         this Vault, otherwise it could have issues.
1326     @param oldVersion The existing Strategy to migrate from.
1327     @param newVersion The new Strategy to migrate to.
1328     """
1329     assert msg.sender == self.governance
1330     assert newVersion != ZERO_ADDRESS
1331     assert self.strategies[oldVersion].activation > 0
1332     assert self.strategies[newVersion].activation == 0
1333 
1334     strategy: StrategyParams = self.strategies[oldVersion]
1335 
1336     self._revokeStrategy(oldVersion)
1337     # _revokeStrategy will lower the debtRatio
1338     self.debtRatio += strategy.debtRatio
1339     # Debt is migrated to new strategy
1340     self.strategies[oldVersion].totalDebt = 0
1341 
1342     self.strategies[newVersion] = StrategyParams({
1343         performanceFee: strategy.performanceFee,
1344         # NOTE: use last report for activation time, so E[R] calc works
1345         activation: strategy.lastReport,
1346         debtRatio: strategy.debtRatio,
1347         minDebtPerHarvest: strategy.minDebtPerHarvest,
1348         maxDebtPerHarvest: strategy.maxDebtPerHarvest,
1349         lastReport: strategy.lastReport,
1350         totalDebt: strategy.totalDebt,
1351         totalGain: 0,
1352         totalLoss: 0,
1353     })
1354 
1355     Strategy(oldVersion).migrate(newVersion)
1356     log StrategyMigrated(oldVersion, newVersion)
1357 
1358     for idx in range(MAXIMUM_STRATEGIES):
1359         if self.withdrawalQueue[idx] == oldVersion:
1360             self.withdrawalQueue[idx] = newVersion
1361             return  # Don't need to reorder anything because we swapped
1362 
1363 
1364 @external
1365 def revokeStrategy(strategy: address = msg.sender):
1366     """
1367     @notice
1368         Revoke a Strategy, setting its debt limit to 0 and preventing any
1369         future deposits.
1370 
1371         This function should only be used in the scenario where the Strategy is
1372         being retired but no migration of the positions are possible, or in the
1373         extreme scenario that the Strategy needs to be put into "Emergency Exit"
1374         mode in order for it to exit as quickly as possible. The latter scenario
1375         could be for any reason that is considered "critical" that the Strategy
1376         exits its position as fast as possible, such as a sudden change in market
1377         conditions leading to losses, or an imminent failure in an external
1378         dependency.
1379 
1380         This may only be called by governance, the guardian, or the Strategy
1381         itself. Note that a Strategy will only revoke itself during emergency
1382         shutdown.
1383     @param strategy The Strategy to revoke.
1384     """
1385     assert msg.sender in [strategy, self.governance, self.guardian]
1386     assert self.strategies[strategy].debtRatio != 0 # dev: already zero
1387 
1388     self._revokeStrategy(strategy)
1389 
1390 
1391 @external
1392 def addStrategyToQueue(strategy: address):
1393     """
1394     @notice
1395         Adds `strategy` to `withdrawalQueue`.
1396 
1397         This may only be called by governance or management.
1398     @dev
1399         The Strategy will be appended to `withdrawalQueue`, call
1400         `setWithdrawalQueue` to change the order.
1401     @param strategy The Strategy to add.
1402     """
1403     assert msg.sender in [self.management, self.governance]
1404     # Must be a current Strategy
1405     assert self.strategies[strategy].activation > 0
1406     # Can't already be in the queue
1407     last_idx: uint256 = 0
1408     for s in self.withdrawalQueue:
1409         if s == ZERO_ADDRESS:
1410             break
1411         assert s != strategy
1412         last_idx += 1
1413     # Check if queue is full
1414     assert last_idx < MAXIMUM_STRATEGIES
1415 
1416     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1417     self._organizeWithdrawalQueue()
1418     log StrategyAddedToQueue(strategy)
1419 
1420 
1421 @external
1422 def removeStrategyFromQueue(strategy: address):
1423     """
1424     @notice
1425         Remove `strategy` from `withdrawalQueue`.
1426 
1427         This may only be called by governance or management.
1428     @dev
1429         We don't do this with revokeStrategy because it should still
1430         be possible to withdraw from the Strategy if it's unwinding.
1431     @param strategy The Strategy to remove.
1432     """
1433     assert msg.sender in [self.management, self.governance]
1434     for idx in range(MAXIMUM_STRATEGIES):
1435         if self.withdrawalQueue[idx] == strategy:
1436             self.withdrawalQueue[idx] = ZERO_ADDRESS
1437             self._organizeWithdrawalQueue()
1438             log StrategyRemovedFromQueue(strategy)
1439             return  # We found the right location and cleared it
1440     raise  # We didn't find the Strategy in the queue
1441 
1442 
1443 @view
1444 @internal
1445 def _debtOutstanding(strategy: address) -> uint256:
1446     # See note on `debtOutstanding()`.
1447     if self.debtRatio == 0:
1448         return self.strategies[strategy].totalDebt
1449 
1450     strategy_debtLimit: uint256 = (
1451         self.strategies[strategy].debtRatio
1452         * self._totalAssets()
1453         / MAX_BPS
1454     )
1455     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1456 
1457     if self.emergencyShutdown:
1458         return strategy_totalDebt
1459     elif strategy_totalDebt <= strategy_debtLimit:
1460         return 0
1461     else:
1462         return strategy_totalDebt - strategy_debtLimit
1463 
1464 
1465 @view
1466 @external
1467 def debtOutstanding(strategy: address = msg.sender) -> uint256:
1468     """
1469     @notice
1470         Determines if `strategy` is past its debt limit and if any tokens
1471         should be withdrawn to the Vault.
1472     @param strategy The Strategy to check. Defaults to the caller.
1473     @return The quantity of tokens to withdraw.
1474     """
1475     return self._debtOutstanding(strategy)
1476 
1477 
1478 @view
1479 @internal
1480 def _creditAvailable(strategy: address) -> uint256:
1481     # See note on `creditAvailable()`.
1482     if self.emergencyShutdown:
1483         return 0
1484     vault_totalAssets: uint256 = self._totalAssets()
1485     vault_debtLimit: uint256 =  self.debtRatio * vault_totalAssets / MAX_BPS 
1486     vault_totalDebt: uint256 = self.totalDebt
1487     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * vault_totalAssets / MAX_BPS
1488     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1489     strategy_minDebtPerHarvest: uint256 = self.strategies[strategy].minDebtPerHarvest
1490     strategy_maxDebtPerHarvest: uint256 = self.strategies[strategy].maxDebtPerHarvest
1491 
1492     # Exhausted credit line
1493     if strategy_debtLimit <= strategy_totalDebt or vault_debtLimit <= vault_totalDebt:
1494         return 0
1495 
1496     # Start with debt limit left for the Strategy
1497     available: uint256 = strategy_debtLimit - strategy_totalDebt
1498 
1499     # Adjust by the global debt limit left
1500     available = min(available, vault_debtLimit - vault_totalDebt)
1501 
1502     # Can only borrow up to what the contract has in reserve
1503     # NOTE: Running near 100% is discouraged
1504     available = min(available, self.token.balanceOf(self))
1505 
1506     # Adjust by min and max borrow limits (per harvest)
1507     # NOTE: min increase can be used to ensure that if a strategy has a minimum
1508     #       amount of capital needed to purchase a position, it's not given capital
1509     #       it can't make use of yet.
1510     # NOTE: max increase is used to make sure each harvest isn't bigger than what
1511     #       is authorized. This combined with adjusting min and max periods in
1512     #       `BaseStrategy` can be used to effect a "rate limit" on capital increase.
1513     if available < strategy_minDebtPerHarvest:
1514         return 0
1515     else:
1516         return min(available, strategy_maxDebtPerHarvest)
1517 
1518 @view
1519 @external
1520 def creditAvailable(strategy: address = msg.sender) -> uint256:
1521     """
1522     @notice
1523         Amount of tokens in Vault a Strategy has access to as a credit line.
1524 
1525         This will check the Strategy's debt limit, as well as the tokens
1526         available in the Vault, and determine the maximum amount of tokens
1527         (if any) the Strategy may draw on.
1528 
1529         In the rare case the Vault is in emergency shutdown this will return 0.
1530     @param strategy The Strategy to check. Defaults to caller.
1531     @return The quantity of tokens available for the Strategy to draw on.
1532     """
1533     return self._creditAvailable(strategy)
1534 
1535 
1536 @view
1537 @internal
1538 def _expectedReturn(strategy: address) -> uint256:
1539     # See note on `expectedReturn()`.
1540     strategy_lastReport: uint256 = self.strategies[strategy].lastReport
1541     timeSinceLastHarvest: uint256 = block.timestamp - strategy_lastReport
1542     totalHarvestTime: uint256 = strategy_lastReport - self.strategies[strategy].activation
1543 
1544     # NOTE: If either `timeSinceLastHarvest` or `totalHarvestTime` is 0, we can short-circuit to `0`
1545     if timeSinceLastHarvest > 0 and totalHarvestTime > 0 and Strategy(strategy).isActive():
1546         # NOTE: Unlikely to throw unless strategy accumalates >1e68 returns
1547         # NOTE: Calculate average over period of time where harvests have occured in the past
1548         return (
1549             self.strategies[strategy].totalGain
1550             * timeSinceLastHarvest
1551             / totalHarvestTime
1552         )
1553     else:
1554         return 0  # Covers the scenario when block.timestamp == activation
1555 
1556 
1557 @view
1558 @external
1559 def availableDepositLimit() -> uint256:
1560     if self.depositLimit > self._totalAssets():
1561         return self.depositLimit - self._totalAssets()
1562     else:
1563         return 0
1564 
1565 
1566 @view
1567 @external
1568 def expectedReturn(strategy: address = msg.sender) -> uint256:
1569     """
1570     @notice
1571         Provide an accurate expected value for the return this `strategy`
1572         would provide to the Vault the next time `report()` is called
1573         (since the last time it was called).
1574     @param strategy The Strategy to determine the expected return for. Defaults to caller.
1575     @return
1576         The anticipated amount `strategy` should make on its investment
1577         since its last report.
1578     """
1579     return self._expectedReturn(strategy)
1580 
1581 
1582 @internal
1583 def _assessFees(strategy: address, gain: uint256) -> uint256:
1584     # Issue new shares to cover fees
1585     # NOTE: In effect, this reduces overall share price by the combined fee
1586     # NOTE: may throw if Vault.totalAssets() > 1e64, or not called for more than a year
1587     duration: uint256 = block.timestamp - self.strategies[strategy].lastReport
1588     assert duration != 0 # can't assessFees twice within the same block
1589 
1590     if gain == 0:
1591         # NOTE: The fees are not charged if there hasn't been any gains reported
1592         return 0
1593 
1594     management_fee: uint256 = (
1595         (
1596             (self.strategies[strategy].totalDebt - Strategy(strategy).delegatedAssets())
1597             * duration 
1598             * self.managementFee
1599         )
1600         / MAX_BPS
1601         / SECS_PER_YEAR
1602     )
1603 
1604     # NOTE: Applies if Strategy is not shutting down, or it is but all debt paid off
1605     # NOTE: No fee is taken when a Strategy is unwinding it's position, until all debt is paid
1606     strategist_fee: uint256 = (
1607         gain
1608         * self.strategies[strategy].performanceFee
1609         / MAX_BPS
1610     )
1611     # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1612     performance_fee: uint256 = gain * self.performanceFee / MAX_BPS
1613 
1614     # NOTE: This must be called prior to taking new collateral,
1615     #       or the calculation will be wrong!
1616     # NOTE: This must be done at the same time, to ensure the relative
1617     #       ratio of governance_fee : strategist_fee is kept intact
1618     total_fee: uint256 = performance_fee + strategist_fee + management_fee
1619     # ensure total_fee is not more than gain
1620     if total_fee > gain:
1621         total_fee = gain
1622     if total_fee > 0:  # NOTE: If mgmt fee is 0% and no gains were realized, skip
1623         reward: uint256 = self._issueSharesForAmount(self, total_fee)
1624 
1625         # Send the rewards out as new shares in this Vault
1626         if strategist_fee > 0:  # NOTE: Guard against DIV/0 fault
1627             # NOTE: Unlikely to throw unless sqrt(reward) >>> 1e39
1628             strategist_reward: uint256 = (
1629                 strategist_fee
1630                 * reward
1631                 / total_fee
1632             )
1633             self._transfer(self, strategy, strategist_reward)
1634             # NOTE: Strategy distributes rewards at the end of harvest()
1635         # NOTE: Governance earns any dust leftover from flooring math above
1636         if self.balanceOf[self] > 0:
1637             self._transfer(self, self.rewards, self.balanceOf[self])
1638     return total_fee
1639 
1640 
1641 @external
1642 def report(gain: uint256, loss: uint256, _debtPayment: uint256) -> uint256:
1643     """
1644     @notice
1645         Reports the amount of assets the calling Strategy has free (usually in
1646         terms of ROI).
1647 
1648         The performance fee is determined here, off of the strategy's profits
1649         (if any), and sent to governance.
1650 
1651         The strategist's fee is also determined here (off of profits), to be
1652         handled according to the strategist on the next harvest.
1653 
1654         This may only be called by a Strategy managed by this Vault.
1655     @dev
1656         For approved strategies, this is the most efficient behavior.
1657         The Strategy reports back what it has free, then Vault "decides"
1658         whether to take some back or give it more. Note that the most it can
1659         take is `gain + _debtPayment`, and the most it can give is all of the
1660         remaining reserves. Anything outside of those bounds is abnormal behavior.
1661 
1662         All approved strategies must have increased diligence around
1663         calling this function, as abnormal behavior could become catastrophic.
1664     @param gain
1665         Amount Strategy has realized as a gain on it's investment since its
1666         last report, and is free to be given back to Vault as earnings
1667     @param loss
1668         Amount Strategy has realized as a loss on it's investment since its
1669         last report, and should be accounted for on the Vault's balance sheet.
1670         The loss will reduce the debtRatio. The next time the strategy will harvest,
1671         it will pay back the debt in an attempt to adjust to the new debt limit.
1672     @param _debtPayment
1673         Amount Strategy has made available to cover outstanding debt
1674     @return Amount of debt outstanding (if totalDebt > debtLimit or emergency shutdown).
1675     """
1676 
1677     # Only approved strategies can call this function
1678     assert self.strategies[msg.sender].activation > 0
1679     # No lying about total available to withdraw!
1680     assert self.token.balanceOf(msg.sender) >= gain + _debtPayment
1681 
1682     # We have a loss to report, do it before the rest of the calculations
1683     if loss > 0:
1684         self._reportLoss(msg.sender, loss)
1685 
1686     # Assess both management fee and performance fee, and issue both as shares of the vault
1687     totalFees: uint256 = self._assessFees(msg.sender, gain)
1688 
1689     # Returns are always "realized gains"
1690     self.strategies[msg.sender].totalGain += gain
1691 
1692     # Compute the line of credit the Vault is able to offer the Strategy (if any)
1693     credit: uint256 = self._creditAvailable(msg.sender)
1694 
1695     # Outstanding debt the Strategy wants to take back from the Vault (if any)
1696     # NOTE: debtOutstanding <= StrategyParams.totalDebt
1697     debt: uint256 = self._debtOutstanding(msg.sender)
1698     debtPayment: uint256 = min(_debtPayment, debt)
1699 
1700     if debtPayment > 0:
1701         self.strategies[msg.sender].totalDebt -= debtPayment
1702         self.totalDebt -= debtPayment
1703         debt -= debtPayment
1704         # NOTE: `debt` is being tracked for later
1705 
1706     # Update the actual debt based on the full credit we are extending to the Strategy
1707     # or the returns if we are taking funds back
1708     # NOTE: credit + self.strategies[msg.sender].totalDebt is always < self.debtLimit
1709     # NOTE: At least one of `credit` or `debt` is always 0 (both can be 0)
1710     if credit > 0:
1711         self.strategies[msg.sender].totalDebt += credit
1712         self.totalDebt += credit
1713 
1714     # Give/take balance to Strategy, based on the difference between the reported gains
1715     # (if any), the debt payment (if any), the credit increase we are offering (if any),
1716     # and the debt needed to be paid off (if any)
1717     # NOTE: This is just used to adjust the balance of tokens between the Strategy and
1718     #       the Vault based on the Strategy's debt limit (as well as the Vault's).
1719     totalAvail: uint256 = gain + debtPayment
1720     if totalAvail < credit:  # credit surplus, give to Strategy
1721         self.erc20_safe_transfer(self.token.address, msg.sender, credit - totalAvail)
1722     elif totalAvail > credit:  # credit deficit, take from Strategy
1723         self.erc20_safe_transferFrom(self.token.address, msg.sender, self, totalAvail - credit)
1724     # else, don't do anything because it is balanced
1725 
1726     # Profit is locked and gradually released per block
1727     # NOTE: compute current locked profit and replace with sum of current and new
1728     lockedProfitBeforeLoss: uint256 = self._calculateLockedProfit() + gain - totalFees
1729     if lockedProfitBeforeLoss > loss: 
1730         self.lockedProfit = lockedProfitBeforeLoss - loss
1731     else:
1732         self.lockedProfit = 0
1733 
1734     # Update reporting time
1735     self.strategies[msg.sender].lastReport = block.timestamp
1736     self.lastReport = block.timestamp
1737 
1738     log StrategyReported(
1739         msg.sender,
1740         gain,
1741         loss,
1742         debtPayment,
1743         self.strategies[msg.sender].totalGain,
1744         self.strategies[msg.sender].totalLoss,
1745         self.strategies[msg.sender].totalDebt,
1746         credit,
1747         self.strategies[msg.sender].debtRatio,
1748     )
1749 
1750     if self.strategies[msg.sender].debtRatio == 0 or self.emergencyShutdown:
1751         # Take every last penny the Strategy has (Emergency Exit/revokeStrategy)
1752         # NOTE: This is different than `debt` in order to extract *all* of the returns
1753         return Strategy(msg.sender).estimatedTotalAssets()
1754     else:
1755         # Otherwise, just return what we have as debt outstanding
1756         return debt
1757 
1758 
1759 @external
1760 def sweep(token: address, amount: uint256 = MAX_UINT256):
1761     """
1762     @notice
1763         Removes tokens from this Vault that are not the type of token managed
1764         by this Vault. This may be used in case of accidentally sending the
1765         wrong kind of token to this Vault.
1766 
1767         Tokens will be sent to `governance`.
1768 
1769         This will fail if an attempt is made to sweep the tokens that this
1770         Vault manages.
1771 
1772         This may only be called by governance.
1773     @param token The token to transfer out of this vault.
1774     @param amount The quantity or tokenId to transfer out.
1775     """
1776     assert msg.sender == self.governance
1777     # Can't be used to steal what this Vault is protecting
1778     assert token != self.token.address
1779     value: uint256 = amount
1780     if value == MAX_UINT256:
1781         value = ERC20(token).balanceOf(self)
1782     self.erc20_safe_transfer(token, self.governance, value)