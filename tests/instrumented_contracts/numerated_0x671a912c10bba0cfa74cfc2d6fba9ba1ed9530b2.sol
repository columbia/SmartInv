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
35     https://github.com/iearn-finance/yearn-vaults/blob/master/SPECIFICATION.md
36 """
37 
38 API_VERSION: constant(String[28]) = "0.4.2"
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
225 SECS_PER_YEAR: constant(uint256) = 31_556_952  # 365.2425 days
226 # `nonces` track `permit` approvals with signature.
227 nonces: public(HashMap[address, uint256])
228 DOMAIN_SEPARATOR: public(bytes32)
229 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
230 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
231 
232 
233 @external
234 def initialize(
235     token: address,
236     governance: address,
237     rewards: address,
238     nameOverride: String[64],
239     symbolOverride: String[32],
240     guardian: address = msg.sender,
241     management: address =  msg.sender,
242 ):
243     """
244     @notice
245         Initializes the Vault, this is called only once, when the contract is
246         deployed.
247         The performance fee is set to 10% of yield, per Strategy.
248         The management fee is set to 2%, per year.
249         The initial deposit limit is set to 0 (deposits disabled); it must be
250         updated after initialization.
251     @dev
252         If `nameOverride` is not specified, the name will be 'yearn'
253         combined with the name of `token`.
254 
255         If `symbolOverride` is not specified, the symbol will be 'yv'
256         combined with the symbol of `token`.
257 
258         The token used by the vault should not change balances outside transfers and 
259         it must transfer the exact amount requested. Fee on transfer and rebasing are not supported.
260     @param token The token that may be deposited into this Vault.
261     @param governance The address authorized for governance interactions.
262     @param rewards The address to distribute rewards to.
263     @param management The address of the vault manager.
264     @param nameOverride Specify a custom Vault name. Leave empty for default choice.
265     @param symbolOverride Specify a custom Vault symbol name. Leave empty for default choice.
266     @param guardian The address authorized for guardian interactions. Defaults to caller.
267     """
268     assert self.activation == 0  # dev: no devops199
269     self.token = ERC20(token)
270     if nameOverride == "":
271         self.name = concat(DetailedERC20(token).symbol(), " yVault")
272     else:
273         self.name = nameOverride
274     if symbolOverride == "":
275         self.symbol = concat("yv", DetailedERC20(token).symbol())
276     else:
277         self.symbol = symbolOverride
278     decimals: uint256 = DetailedERC20(token).decimals()
279     self.decimals = decimals
280     assert decimals < 256 # dev: see VVE-2020-0001
281 
282     self.governance = governance
283     log UpdateGovernance(governance)
284     self.management = management
285     log UpdateManagement(management)
286     self.rewards = rewards
287     log UpdateRewards(rewards)
288     self.guardian = guardian
289     log UpdateGuardian(guardian)
290     self.performanceFee = 1000  # 10% of yield (per Strategy)
291     log UpdatePerformanceFee(convert(1000, uint256))
292     self.managementFee = 200  # 2% per year
293     log UpdateManagementFee(convert(200, uint256))
294     self.lastReport = block.timestamp
295     self.activation = block.timestamp
296     self.lockedProfitDegradation = convert(DEGRADATION_COEFFICIENT * 46 / 10 ** 6 , uint256) # 6 hours in blocks
297     # EIP-712
298     self.DOMAIN_SEPARATOR = keccak256(
299         concat(
300             DOMAIN_TYPE_HASH,
301             keccak256(convert("Yearn Vault", Bytes[11])),
302             keccak256(convert(API_VERSION, Bytes[28])),
303             convert(chain.id, bytes32),
304             convert(self, bytes32)
305         )
306     )
307 
308 
309 @pure
310 @external
311 def apiVersion() -> String[28]:
312     """
313     @notice
314         Used to track the deployed version of this contract. In practice you
315         can use this version number to compare with Yearn's GitHub and
316         determine which version of the source matches this deployed contract.
317     @dev
318         All strategies must have an `apiVersion()` that matches the Vault's
319         `API_VERSION`.
320     @return API_VERSION which holds the current version of this contract.
321     """
322     return API_VERSION
323 
324 
325 @external
326 def setName(name: String[42]):
327     """
328     @notice
329         Used to change the value of `name`.
330 
331         This may only be called by governance.
332     @param name The new name to use.
333     """
334     assert msg.sender == self.governance
335     self.name = name
336 
337 
338 @external
339 def setSymbol(symbol: String[20]):
340     """
341     @notice
342         Used to change the value of `symbol`.
343 
344         This may only be called by governance.
345     @param symbol The new symbol to use.
346     """
347     assert msg.sender == self.governance
348     self.symbol = symbol
349 
350 
351 # 2-phase commit for a change in governance
352 @external
353 def setGovernance(governance: address):
354     """
355     @notice
356         Nominate a new address to use as governance.
357 
358         The change does not go into effect immediately. This function sets a
359         pending change, and the governance address is not updated until
360         the proposed governance address has accepted the responsibility.
361 
362         This may only be called by the current governance address.
363     @param governance The address requested to take over Vault governance.
364     """
365     assert msg.sender == self.governance
366     self.pendingGovernance = governance
367 
368 
369 @external
370 def acceptGovernance():
371     """
372     @notice
373         Once a new governance address has been proposed using setGovernance(),
374         this function may be called by the proposed address to accept the
375         responsibility of taking over governance for this contract.
376 
377         This may only be called by the proposed governance address.
378     @dev
379         setGovernance() should be called by the existing governance address,
380         prior to calling this function.
381     """
382     assert msg.sender == self.pendingGovernance
383     self.governance = msg.sender
384     log UpdateGovernance(msg.sender)
385 
386 
387 @external
388 def setManagement(management: address):
389     """
390     @notice
391         Changes the management address.
392         Management is able to make some investment decisions adjusting parameters.
393 
394         This may only be called by governance.
395     @param management The address to use for managing.
396     """
397     assert msg.sender == self.governance
398     self.management = management
399     log UpdateManagement(management)
400 
401 
402 @external
403 def setRewards(rewards: address):
404     """
405     @notice
406         Changes the rewards address. Any distributed rewards
407         will cease flowing to the old address and begin flowing
408         to this address once the change is in effect.
409 
410         This will not change any Strategy reports in progress, only
411         new reports made after this change goes into effect.
412 
413         This may only be called by governance.
414     @param rewards The address to use for collecting rewards.
415     """
416     assert msg.sender == self.governance
417     assert not (rewards in [self, ZERO_ADDRESS])
418     self.rewards = rewards
419     log UpdateRewards(rewards)
420 
421 
422 @external
423 def setLockedProfitDegradation(degradation: uint256):
424     """
425     @notice
426         Changes the locked profit degradation.
427     @param degradation The rate of degradation in percent per second scaled to 1e18.
428     """
429     assert msg.sender == self.governance
430     # Since "degradation" is of type uint256 it can never be less than zero
431     assert degradation <= DEGRADATION_COEFFICIENT
432     self.lockedProfitDegradation = degradation
433 
434 
435 @external
436 def setDepositLimit(limit: uint256):
437     """
438     @notice
439         Changes the maximum amount of tokens that can be deposited in this Vault.
440 
441         Note, this is not how much may be deposited by a single depositor,
442         but the maximum amount that may be deposited across all depositors.
443 
444         This may only be called by governance.
445     @param limit The new deposit limit to use.
446     """
447     assert msg.sender == self.governance
448     self.depositLimit = limit
449     log UpdateDepositLimit(limit)
450 
451 
452 @external
453 def setPerformanceFee(fee: uint256):
454     """
455     @notice
456         Used to change the value of `performanceFee`.
457 
458         Should set this value below the maximum strategist performance fee.
459 
460         This may only be called by governance.
461     @param fee The new performance fee to use.
462     """
463     assert msg.sender == self.governance
464     assert fee <= MAX_BPS / 2
465     self.performanceFee = fee
466     log UpdatePerformanceFee(fee)
467 
468 
469 @external
470 def setManagementFee(fee: uint256):
471     """
472     @notice
473         Used to change the value of `managementFee`.
474 
475         This may only be called by governance.
476     @param fee The new management fee to use.
477     """
478     assert msg.sender == self.governance
479     assert fee <= MAX_BPS
480     self.managementFee = fee
481     log UpdateManagementFee(fee)
482 
483 
484 @external
485 def setGuardian(guardian: address):
486     """
487     @notice
488         Used to change the address of `guardian`.
489 
490         This may only be called by governance or the existing guardian.
491     @param guardian The new guardian address to use.
492     """
493     assert msg.sender in [self.guardian, self.governance]
494     self.guardian = guardian
495     log UpdateGuardian(guardian)
496 
497 
498 @external
499 def setEmergencyShutdown(active: bool):
500     """
501     @notice
502         Activates or deactivates Vault mode where all Strategies go into full
503         withdrawal.
504 
505         During Emergency Shutdown:
506         1. No Users may deposit into the Vault (but may withdraw as usual.)
507         2. Governance may not add new Strategies.
508         3. Each Strategy must pay back their debt as quickly as reasonable to
509             minimally affect their position.
510         4. Only Governance may undo Emergency Shutdown.
511 
512         See contract level note for further details.
513 
514         This may only be called by governance or the guardian.
515     @param active
516         If true, the Vault goes into Emergency Shutdown. If false, the Vault
517         goes back into Normal Operation.
518     """
519     if active:
520         assert msg.sender in [self.guardian, self.governance]
521     else:
522         assert msg.sender == self.governance
523     self.emergencyShutdown = active
524     log EmergencyShutdown(active)
525 
526 
527 @external
528 def setWithdrawalQueue(queue: address[MAXIMUM_STRATEGIES]):
529     """
530     @notice
531         Updates the withdrawalQueue to match the addresses and order specified
532         by `queue`.
533 
534         There can be fewer strategies than the maximum, as well as fewer than
535         the total number of strategies active in the vault. `withdrawalQueue`
536         will be updated in a gas-efficient manner, assuming the input is well-
537         ordered with 0x0 only at the end.
538 
539         This may only be called by governance or management.
540     @dev
541         This is order sensitive, specify the addresses in the order in which
542         funds should be withdrawn (so `queue`[0] is the first Strategy withdrawn
543         from, `queue`[1] is the second, etc.)
544 
545         This means that the least impactful Strategy (the Strategy that will have
546         its core positions impacted the least by having funds removed) should be
547         at `queue`[0], then the next least impactful at `queue`[1], and so on.
548     @param queue
549         The array of addresses to use as the new withdrawal queue. This is
550         order sensitive.
551     """
552     assert msg.sender in [self.management, self.governance]
553 
554     # HACK: Temporary until Vyper adds support for Dynamic arrays
555     old_queue: address[MAXIMUM_STRATEGIES] = empty(address[MAXIMUM_STRATEGIES])
556     for i in range(MAXIMUM_STRATEGIES):
557         old_queue[i] = self.withdrawalQueue[i] 
558         if queue[i] == ZERO_ADDRESS:
559             # NOTE: Cannot use this method to remove entries from the queue
560             assert old_queue[i] == ZERO_ADDRESS
561             break
562         # NOTE: Cannot use this method to add more entries to the queue
563         assert old_queue[i] != ZERO_ADDRESS
564 
565         assert self.strategies[queue[i]].activation > 0
566 
567         existsInOldQueue: bool = False
568         for j in range(MAXIMUM_STRATEGIES):
569             if queue[j] == ZERO_ADDRESS:
570                 existsInOldQueue = True
571                 break
572             if queue[i] == old_queue[j]:
573                 # NOTE: Ensure that every entry in queue prior to reordering exists now
574                 existsInOldQueue = True
575 
576             if j <= i:
577                 # NOTE: This will only check for duplicate entries in queue after `i`
578                 continue
579             assert queue[i] != queue[j]  # dev: do not add duplicate strategies
580 
581         assert existsInOldQueue # dev: do not add new strategies
582 
583         self.withdrawalQueue[i] = queue[i]
584     log UpdateWithdrawalQueue(queue)
585 
586 
587 @internal
588 def erc20_safe_transfer(token: address, receiver: address, amount: uint256):
589     # Used only to send tokens that are not the type managed by this Vault.
590     # HACK: Used to handle non-compliant tokens like USDT
591     response: Bytes[32] = raw_call(
592         token,
593         concat(
594             method_id("transfer(address,uint256)"),
595             convert(receiver, bytes32),
596             convert(amount, bytes32),
597         ),
598         max_outsize=32,
599     )
600     if len(response) > 0:
601         assert convert(response, bool), "Transfer failed!"
602 
603 
604 @internal
605 def erc20_safe_transferFrom(token: address, sender: address, receiver: address, amount: uint256):
606     # Used only to send tokens that are not the type managed by this Vault.
607     # HACK: Used to handle non-compliant tokens like USDT
608     response: Bytes[32] = raw_call(
609         token,
610         concat(
611             method_id("transferFrom(address,address,uint256)"),
612             convert(sender, bytes32),
613             convert(receiver, bytes32),
614             convert(amount, bytes32),
615         ),
616         max_outsize=32,
617     )
618     if len(response) > 0:
619         assert convert(response, bool), "Transfer failed!"
620 
621 
622 @internal
623 def _transfer(sender: address, receiver: address, amount: uint256):
624     # See note on `transfer()`.
625 
626     # Protect people from accidentally sending their shares to bad places
627     assert receiver not in [self, ZERO_ADDRESS]
628     self.balanceOf[sender] -= amount
629     self.balanceOf[receiver] += amount
630     log Transfer(sender, receiver, amount)
631 
632 
633 @external
634 def transfer(receiver: address, amount: uint256) -> bool:
635     """
636     @notice
637         Transfers shares from the caller's address to `receiver`. This function
638         will always return true, unless the user is attempting to transfer
639         shares to this contract's address, or to 0x0.
640     @param receiver
641         The address shares are being transferred to. Must not be this contract's
642         address, must not be 0x0.
643     @param amount The quantity of shares to transfer.
644     @return
645         True if transfer is sent to an address other than this contract's or
646         0x0, otherwise the transaction will fail.
647     """
648     self._transfer(msg.sender, receiver, amount)
649     return True
650 
651 
652 @external
653 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
654     """
655     @notice
656         Transfers `amount` shares from `sender` to `receiver`. This operation will
657         always return true, unless the user is attempting to transfer shares
658         to this contract's address, or to 0x0.
659 
660         Unless the caller has given this contract unlimited approval,
661         transfering shares will decrement the caller's `allowance` by `amount`.
662     @param sender The address shares are being transferred from.
663     @param receiver
664         The address shares are being transferred to. Must not be this contract's
665         address, must not be 0x0.
666     @param amount The quantity of shares to transfer.
667     @return
668         True if transfer is sent to an address other than this contract's or
669         0x0, otherwise the transaction will fail.
670     """
671     # Unlimited approval (saves an SSTORE)
672     if (self.allowance[sender][msg.sender] < MAX_UINT256):
673         allowance: uint256 = self.allowance[sender][msg.sender] - amount
674         self.allowance[sender][msg.sender] = allowance
675         # NOTE: Allows log filters to have a full accounting of allowance changes
676         log Approval(sender, msg.sender, allowance)
677     self._transfer(sender, receiver, amount)
678     return True
679 
680 
681 @external
682 def approve(spender: address, amount: uint256) -> bool:
683     """
684     @dev Approve the passed address to spend the specified amount of tokens on behalf of
685          `msg.sender`. Beware that changing an allowance with this method brings the risk
686          that someone may use both the old and the new allowance by unfortunate transaction
687          ordering. See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
688     @param spender The address which will spend the funds.
689     @param amount The amount of tokens to be spent.
690     """
691     self.allowance[msg.sender][spender] = amount
692     log Approval(msg.sender, spender, amount)
693     return True
694 
695 
696 @external
697 def increaseAllowance(spender: address, amount: uint256) -> bool:
698     """
699     @dev Increase the allowance of the passed address to spend the total amount of tokens
700          on behalf of msg.sender. This method mitigates the risk that someone may use both
701          the old and the new allowance by unfortunate transaction ordering.
702          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
703     @param spender The address which will spend the funds.
704     @param amount The amount of tokens to increase the allowance by.
705     """
706     self.allowance[msg.sender][spender] += amount
707     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
708     return True
709 
710 
711 @external
712 def decreaseAllowance(spender: address, amount: uint256) -> bool:
713     """
714     @dev Decrease the allowance of the passed address to spend the total amount of tokens
715          on behalf of msg.sender. This method mitigates the risk that someone may use both
716          the old and the new allowance by unfortunate transaction ordering.
717          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
718     @param spender The address which will spend the funds.
719     @param amount The amount of tokens to decrease the allowance by.
720     """
721     self.allowance[msg.sender][spender] -= amount
722     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
723     return True
724 
725 
726 @external
727 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
728     """
729     @notice
730         Approves spender by owner's signature to expend owner's tokens.
731         See https://eips.ethereum.org/EIPS/eip-2612.
732 
733     @param owner The address which is a source of funds and has signed the Permit.
734     @param spender The address which is allowed to spend the funds.
735     @param amount The amount of tokens to be spent.
736     @param expiry The timestamp after which the Permit is no longer valid.
737     @param signature A valid secp256k1 signature of Permit by owner encoded as r, s, v.
738     @return True, if transaction completes successfully
739     """
740     assert owner != ZERO_ADDRESS  # dev: invalid owner
741     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
742     nonce: uint256 = self.nonces[owner]
743     digest: bytes32 = keccak256(
744         concat(
745             b'\x19\x01',
746             self.DOMAIN_SEPARATOR,
747             keccak256(
748                 concat(
749                     PERMIT_TYPE_HASH,
750                     convert(owner, bytes32),
751                     convert(spender, bytes32),
752                     convert(amount, bytes32),
753                     convert(nonce, bytes32),
754                     convert(expiry, bytes32),
755                 )
756             )
757         )
758     )
759     # NOTE: signature is packed as r, s, v
760     r: uint256 = convert(slice(signature, 0, 32), uint256)
761     s: uint256 = convert(slice(signature, 32, 32), uint256)
762     v: uint256 = convert(slice(signature, 64, 1), uint256)
763     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
764     self.allowance[owner][spender] = amount
765     self.nonces[owner] = nonce + 1
766     log Approval(owner, spender, amount)
767     return True
768 
769 
770 @view
771 @internal
772 def _totalAssets() -> uint256:
773     # See note on `totalAssets()`.
774     return self.token.balanceOf(self) + self.totalDebt
775 
776 
777 @view
778 @external
779 def totalAssets() -> uint256:
780     """
781     @notice
782         Returns the total quantity of all assets under control of this
783         Vault, whether they're loaned out to a Strategy, or currently held in
784         the Vault.
785     @return The total assets under control of this Vault.
786     """
787     return self._totalAssets()
788 
789 
790 @view
791 @internal
792 def _calculateLockedProfit() -> uint256:
793     lockedFundsRatio: uint256 = (block.timestamp - self.lastReport) * self.lockedProfitDegradation
794 
795     if(lockedFundsRatio < DEGRADATION_COEFFICIENT):
796         lockedProfit: uint256 = self.lockedProfit
797         return lockedProfit - (
798                 lockedFundsRatio
799                 * lockedProfit
800                 / DEGRADATION_COEFFICIENT
801             )
802     else:        
803         return 0
804 
805 @internal
806 def _issueSharesForAmount(to: address, amount: uint256) -> uint256:
807     # Issues `amount` Vault shares to `to`.
808     # Shares must be issued prior to taking on new collateral, or
809     # calculation will be wrong. This means that only *trusted* tokens
810     # (with no capability for exploitative behavior) can be used.
811     shares: uint256 = 0
812     # HACK: Saves 2 SLOADs (~200 gas, post-Berlin)
813     totalSupply: uint256 = self.totalSupply
814     if totalSupply > 0:
815         # Mint amount of shares based on what the Vault is managing overall
816         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
817         freeFunds: uint256 = self._totalAssets() - self._calculateLockedProfit()
818         shares =  amount * totalSupply / freeFunds  # dev: no free funds
819     else:
820         # No existing shares, so mint 1:1
821         shares = amount
822     assert shares != 0 # dev: division rounding resulted in zero
823 
824     # Mint new shares
825     self.totalSupply = totalSupply + shares
826     self.balanceOf[to] += shares
827     log Transfer(ZERO_ADDRESS, to, shares)
828 
829     return shares
830 
831 
832 @external
833 @nonreentrant("withdraw")
834 def deposit(_amount: uint256 = MAX_UINT256, recipient: address = msg.sender) -> uint256:
835     """
836     @notice
837         Deposits `_amount` `token`, issuing shares to `recipient`. If the
838         Vault is in Emergency Shutdown, deposits will not be accepted and this
839         call will fail.
840     @dev
841         Measuring quantity of shares to issues is based on the total
842         outstanding debt that this contract has ("expected value") instead
843         of the total balance sheet it has ("estimated value") has important
844         security considerations, and is done intentionally. If this value were
845         measured against external systems, it could be purposely manipulated by
846         an attacker to withdraw more assets than they otherwise should be able
847         to claim by redeeming their shares.
848 
849         On deposit, this means that shares are issued against the total amount
850         that the deposited capital can be given in service of the debt that
851         Strategies assume. If that number were to be lower than the "expected
852         value" at some future point, depositing shares via this method could
853         entitle the depositor to *less* than the deposited value once the
854         "realized value" is updated from further reports by the Strategies
855         to the Vaults.
856 
857         Care should be taken by integrators to account for this discrepancy,
858         by using the view-only methods of this contract (both off-chain and
859         on-chain) to determine if depositing into the Vault is a "good idea".
860     @param _amount The quantity of tokens to deposit, defaults to all.
861     @param recipient
862         The address to issue the shares in this Vault to. Defaults to the
863         caller's address.
864     @return The issued Vault shares.
865     """
866     assert not self.emergencyShutdown  # Deposits are locked out
867     assert recipient not in [self, ZERO_ADDRESS]
868 
869     amount: uint256 = _amount
870 
871     # If _amount not specified, transfer the full token balance,
872     # up to deposit limit
873     if amount == MAX_UINT256:
874         amount = min(
875             self.depositLimit - self._totalAssets(),
876             self.token.balanceOf(msg.sender),
877         )
878     else:
879         # Ensure deposit limit is respected
880         assert self._totalAssets() + amount <= self.depositLimit
881 
882     # Ensure we are depositing something
883     assert amount > 0
884 
885     # Issue new shares (needs to be done before taking deposit to be accurate)
886     # Shares are issued to recipient (may be different from msg.sender)
887     # See @dev note, above.
888     shares: uint256 = self._issueSharesForAmount(recipient, amount)
889 
890     # Tokens are transferred from msg.sender (may be different from _recipient)
891     self.erc20_safe_transferFrom(self.token.address, msg.sender, self, amount)
892 
893     return shares  # Just in case someone wants them
894 
895 
896 @view
897 @internal
898 def _shareValue(shares: uint256) -> uint256:
899     # Returns price = 1:1 if vault is empty
900     if self.totalSupply == 0:
901         return shares
902 
903     # Determines the current value of `shares`.
904     # NOTE: if sqrt(Vault.totalAssets()) >>> 1e39, this could potentially revert
905     freeFunds: uint256 = self._totalAssets() - self._calculateLockedProfit()
906 
907     return (
908         shares
909         * freeFunds
910         / self.totalSupply
911     )
912 
913 
914 @view
915 @internal
916 def _sharesForAmount(amount: uint256) -> uint256:
917     # Determines how many shares `amount` of token would receive.
918     # See dev note on `deposit`.
919     if self._totalAssets() > 0:
920         # NOTE: if sqrt(token.totalSupply()) > 1e37, this could potentially revert
921         return  (
922             amount
923             * self.totalSupply
924             / self._totalAssets()
925         )
926     else:
927         return 0
928 
929 
930 @view
931 @external
932 def maxAvailableShares() -> uint256:
933     """
934     @notice
935         Determines the maximum quantity of shares this Vault can facilitate a
936         withdrawal for, factoring in assets currently residing in the Vault,
937         as well as those deployed to strategies on the Vault's balance sheet.
938     @dev
939         Regarding how shares are calculated, see dev note on `deposit`.
940 
941         If you want to calculated the maximum a user could withdraw up to,
942         you want to use this function.
943 
944         Note that the amount provided by this function is the theoretical
945         maximum possible from withdrawing, the real amount depends on the
946         realized losses incurred during withdrawal.
947     @return The total quantity of shares this Vault can provide.
948     """
949     shares: uint256 = self._sharesForAmount(self.token.balanceOf(self))
950 
951     for strategy in self.withdrawalQueue:
952         if strategy == ZERO_ADDRESS:
953             break
954         shares += self._sharesForAmount(self.strategies[strategy].totalDebt)
955 
956     return shares
957 
958 
959 @internal
960 def _reportLoss(strategy: address, loss: uint256):
961     # Loss can only be up the amount of debt issued to strategy
962     totalDebt: uint256 = self.strategies[strategy].totalDebt
963     assert totalDebt >= loss
964 
965     # Also, make sure we reduce our trust with the strategy by the amount of loss
966     if self.debtRatio != 0: # if vault with single strategy that is set to EmergencyOne
967         # NOTE: The context to this calculation is different than the calculation in `_reportLoss`,
968         # this calculation intentionally approximates via `totalDebt` to avoid manipulatable results
969         ratio_change: uint256 = min(
970             # NOTE: This calculation isn't 100% precise, the adjustment is ~10%-20% more severe due to EVM math
971             loss * self.debtRatio / self.totalDebt,
972             self.strategies[strategy].debtRatio,
973         )
974         self.strategies[strategy].debtRatio -= ratio_change
975         self.debtRatio -= ratio_change
976     # Finally, adjust our strategy's parameters by the loss
977     self.strategies[strategy].totalLoss += loss
978     self.strategies[strategy].totalDebt = totalDebt - loss
979     self.totalDebt -= loss
980 
981 
982 @external
983 @nonreentrant("withdraw")
984 def withdraw(
985     maxShares: uint256 = MAX_UINT256,
986     recipient: address = msg.sender,
987     maxLoss: uint256 = 1,  # 0.01% [BPS]
988 ) -> uint256:
989     """
990     @notice
991         Withdraws the calling account's tokens from this Vault, redeeming
992         amount `_shares` for an appropriate amount of tokens.
993 
994         See note on `setWithdrawalQueue` for further details of withdrawal
995         ordering and behavior.
996     @dev
997         Measuring the value of shares is based on the total outstanding debt
998         that this contract has ("expected value") instead of the total balance
999         sheet it has ("estimated value") has important security considerations,
1000         and is done intentionally. If this value were measured against external
1001         systems, it could be purposely manipulated by an attacker to withdraw
1002         more assets than they otherwise should be able to claim by redeeming
1003         their shares.
1004 
1005         On withdrawal, this means that shares are redeemed against the total
1006         amount that the deposited capital had "realized" since the point it
1007         was deposited, up until the point it was withdrawn. If that number
1008         were to be higher than the "expected value" at some future point,
1009         withdrawing shares via this method could entitle the depositor to
1010         *more* than the expected value once the "realized value" is updated
1011         from further reports by the Strategies to the Vaults.
1012 
1013         Under exceptional scenarios, this could cause earlier withdrawals to
1014         earn "more" of the underlying assets than Users might otherwise be
1015         entitled to, if the Vault's estimated value were otherwise measured
1016         through external means, accounting for whatever exceptional scenarios
1017         exist for the Vault (that aren't covered by the Vault's own design.)
1018 
1019         In the situation where a large withdrawal happens, it can empty the 
1020         vault balance and the strategies in the withdrawal queue. 
1021         Strategies not in the withdrawal queue will have to be harvested to 
1022         rebalance the funds and make the funds available again to withdraw.
1023     @param maxShares
1024         How many shares to try and redeem for tokens, defaults to all.
1025     @param recipient
1026         The address to issue the shares in this Vault to. Defaults to the
1027         caller's address.
1028     @param maxLoss
1029         The maximum acceptable loss to sustain on withdrawal. Defaults to 0.01%.
1030     @return The quantity of tokens redeemed for `_shares`.
1031     """
1032     shares: uint256 = maxShares  # May reduce this number below
1033 
1034     # Max Loss is <=100%, revert otherwise
1035     assert maxLoss <= MAX_BPS
1036 
1037     # If _shares not specified, transfer full share balance
1038     if shares == MAX_UINT256:
1039         shares = self.balanceOf[msg.sender]
1040 
1041     # Limit to only the shares they own
1042     assert shares <= self.balanceOf[msg.sender]
1043 
1044     # Ensure we are withdrawing something
1045     assert shares > 0
1046 
1047     # See @dev note, above.
1048     value: uint256 = self._shareValue(shares)
1049 
1050     totalLoss: uint256 = 0
1051     if value > self.token.balanceOf(self):
1052         # We need to go get some from our strategies in the withdrawal queue
1053         # NOTE: This performs forced withdrawals from each Strategy. During
1054         #       forced withdrawal, a Strategy may realize a loss. That loss
1055         #       is reported back to the Vault, and the will affect the amount
1056         #       of tokens that the withdrawer receives for their shares. They
1057         #       can optionally specify the maximum acceptable loss (in BPS)
1058         #       to prevent excessive losses on their withdrawals (which may
1059         #       happen in certain edge cases where Strategies realize a loss)
1060         for strategy in self.withdrawalQueue:
1061             if strategy == ZERO_ADDRESS:
1062                 break  # We've exhausted the queue
1063 
1064             vault_balance: uint256 = self.token.balanceOf(self)
1065             if value <= vault_balance:
1066                 break  # We're done withdrawing
1067 
1068             amountNeeded: uint256 = value - vault_balance
1069 
1070             # NOTE: Don't withdraw more than the debt so that Strategy can still
1071             #       continue to work based on the profits it has
1072             # NOTE: This means that user will lose out on any profits that each
1073             #       Strategy in the queue would return on next harvest, benefiting others
1074             amountNeeded = min(amountNeeded, self.strategies[strategy].totalDebt)
1075             if amountNeeded == 0:
1076                 continue  # Nothing to withdraw from this Strategy, try the next one
1077 
1078             # Force withdraw amount from each Strategy in the order set by governance
1079             loss: uint256 = Strategy(strategy).withdraw(amountNeeded)
1080             withdrawn: uint256 = self.token.balanceOf(self) - vault_balance
1081 
1082             # NOTE: Withdrawer incurs any losses from liquidation
1083             if loss > 0:
1084                 value -= loss
1085                 totalLoss += loss
1086                 self._reportLoss(strategy, loss)
1087 
1088             # Reduce the Strategy's debt by the amount withdrawn ("realized returns")
1089             # NOTE: This doesn't add to returns as it's not earned by "normal means"
1090             self.strategies[strategy].totalDebt -= withdrawn
1091             self.totalDebt -= withdrawn
1092 
1093         # NOTE: We have withdrawn everything possible out of the withdrawal queue
1094         #       but we still don't have enough to fully pay them back, so adjust
1095         #       to the total amount we've freed up through forced withdrawals
1096         vault_balance: uint256 = self.token.balanceOf(self)
1097         if value > vault_balance:
1098             value = vault_balance
1099             # NOTE: Burn # of shares that corresponds to what Vault has on-hand,
1100             #       including the losses that were incurred above during withdrawals
1101             shares = self._sharesForAmount(value + totalLoss)
1102 
1103     # NOTE: This loss protection is put in place to revert if losses from
1104     #       withdrawing are more than what is considered acceptable.
1105     assert totalLoss <= maxLoss * (value + totalLoss) / MAX_BPS 
1106 
1107     # Burn shares (full value of what is being withdrawn)
1108     self.totalSupply -= shares
1109     self.balanceOf[msg.sender] -= shares
1110     log Transfer(msg.sender, ZERO_ADDRESS, shares)
1111 
1112     # Withdraw remaining balance to _recipient (may be different to msg.sender) (minus fee)
1113     self.erc20_safe_transfer(self.token.address, recipient, value)
1114 
1115     return value
1116 
1117 
1118 @view
1119 @external
1120 def pricePerShare() -> uint256:
1121     """
1122     @notice Gives the price for a single Vault share.
1123     @dev See dev note on `withdraw`.
1124     @return The value of a single share.
1125     """
1126     return self._shareValue(10 ** self.decimals)
1127 
1128 
1129 @internal
1130 def _organizeWithdrawalQueue():
1131     # Reorganize `withdrawalQueue` based on premise that if there is an
1132     # empty value between two actual values, then the empty value should be
1133     # replaced by the later value.
1134     # NOTE: Relative ordering of non-zero values is maintained.
1135     offset: uint256 = 0
1136     for idx in range(MAXIMUM_STRATEGIES):
1137         strategy: address = self.withdrawalQueue[idx]
1138         if strategy == ZERO_ADDRESS:
1139             offset += 1  # how many values we need to shift, always `<= idx`
1140         elif offset > 0:
1141             self.withdrawalQueue[idx - offset] = strategy
1142             self.withdrawalQueue[idx] = ZERO_ADDRESS
1143 
1144 
1145 @external
1146 def addStrategy(
1147     strategy: address,
1148     debtRatio: uint256,
1149     minDebtPerHarvest: uint256,
1150     maxDebtPerHarvest: uint256,
1151     performanceFee: uint256,
1152 ):
1153     """
1154     @notice
1155         Add a Strategy to the Vault.
1156 
1157         This may only be called by governance.
1158     @dev
1159         The Strategy will be appended to `withdrawalQueue`, call
1160         `setWithdrawalQueue` to change the order.
1161     @param strategy The address of the Strategy to add.
1162     @param debtRatio
1163         The share of the total assets in the `vault that the `strategy` has access to.
1164     @param minDebtPerHarvest
1165         Lower limit on the increase of debt since last harvest
1166     @param maxDebtPerHarvest
1167         Upper limit on the increase of debt since last harvest
1168     @param performanceFee
1169         The fee the strategist will receive based on this Vault's performance.
1170     """
1171     # Check if queue is full
1172     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1173 
1174     # Check calling conditions
1175     assert not self.emergencyShutdown
1176     assert msg.sender == self.governance
1177 
1178     # Check strategy configuration
1179     assert strategy != ZERO_ADDRESS
1180     assert self.strategies[strategy].activation == 0
1181     assert self == Strategy(strategy).vault()
1182     assert self.token.address == Strategy(strategy).want()
1183 
1184     # Check strategy parameters
1185     assert self.debtRatio + debtRatio <= MAX_BPS
1186     assert minDebtPerHarvest <= maxDebtPerHarvest
1187     assert performanceFee <= MAX_BPS / 2 
1188 
1189     # Add strategy to approved strategies
1190     self.strategies[strategy] = StrategyParams({
1191         performanceFee: performanceFee,
1192         activation: block.timestamp,
1193         debtRatio: debtRatio,
1194         minDebtPerHarvest: minDebtPerHarvest,
1195         maxDebtPerHarvest: maxDebtPerHarvest,
1196         lastReport: block.timestamp,
1197         totalDebt: 0,
1198         totalGain: 0,
1199         totalLoss: 0,
1200     })
1201     log StrategyAdded(strategy, debtRatio, minDebtPerHarvest, maxDebtPerHarvest, performanceFee)
1202 
1203     # Update Vault parameters
1204     self.debtRatio += debtRatio
1205 
1206     # Add strategy to the end of the withdrawal queue
1207     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1208     self._organizeWithdrawalQueue()
1209 
1210 
1211 @external
1212 def updateStrategyDebtRatio(
1213     strategy: address,
1214     debtRatio: uint256,
1215 ):
1216     """
1217     @notice
1218         Change the quantity of assets `strategy` may manage.
1219 
1220         This may be called by governance or management.
1221     @param strategy The Strategy to update.
1222     @param debtRatio The quantity of assets `strategy` may now manage.
1223     """
1224     assert msg.sender in [self.management, self.governance]
1225     assert self.strategies[strategy].activation > 0
1226     self.debtRatio -= self.strategies[strategy].debtRatio
1227     self.strategies[strategy].debtRatio = debtRatio
1228     self.debtRatio += debtRatio
1229     assert self.debtRatio <= MAX_BPS
1230     log StrategyUpdateDebtRatio(strategy, debtRatio)
1231 
1232 
1233 @external
1234 def updateStrategyMinDebtPerHarvest(
1235     strategy: address,
1236     minDebtPerHarvest: uint256,
1237 ):
1238     """
1239     @notice
1240         Change the quantity assets per block this Vault may deposit to or
1241         withdraw from `strategy`.
1242 
1243         This may only be called by governance or management.
1244     @param strategy The Strategy to update.
1245     @param minDebtPerHarvest
1246         Lower limit on the increase of debt since last harvest
1247     """
1248     assert msg.sender in [self.management, self.governance]
1249     assert self.strategies[strategy].activation > 0
1250     assert self.strategies[strategy].maxDebtPerHarvest >= minDebtPerHarvest
1251     self.strategies[strategy].minDebtPerHarvest = minDebtPerHarvest
1252     log StrategyUpdateMinDebtPerHarvest(strategy, minDebtPerHarvest)
1253 
1254 
1255 @external
1256 def updateStrategyMaxDebtPerHarvest(
1257     strategy: address,
1258     maxDebtPerHarvest: uint256,
1259 ):
1260     """
1261     @notice
1262         Change the quantity assets per block this Vault may deposit to or
1263         withdraw from `strategy`.
1264 
1265         This may only be called by governance or management.
1266     @param strategy The Strategy to update.
1267     @param maxDebtPerHarvest
1268         Upper limit on the increase of debt since last harvest
1269     """
1270     assert msg.sender in [self.management, self.governance]
1271     assert self.strategies[strategy].activation > 0
1272     assert self.strategies[strategy].minDebtPerHarvest <= maxDebtPerHarvest
1273     self.strategies[strategy].maxDebtPerHarvest = maxDebtPerHarvest
1274     log StrategyUpdateMaxDebtPerHarvest(strategy, maxDebtPerHarvest)
1275 
1276 
1277 @external
1278 def updateStrategyPerformanceFee(
1279     strategy: address,
1280     performanceFee: uint256,
1281 ):
1282     """
1283     @notice
1284         Change the fee the strategist will receive based on this Vault's
1285         performance.
1286 
1287         This may only be called by governance.
1288     @param strategy The Strategy to update.
1289     @param performanceFee The new fee the strategist will receive.
1290     """
1291     assert msg.sender == self.governance
1292     assert performanceFee <= MAX_BPS / 2
1293     assert self.strategies[strategy].activation > 0
1294     self.strategies[strategy].performanceFee = performanceFee
1295     log StrategyUpdatePerformanceFee(strategy, performanceFee)
1296 
1297 
1298 @internal
1299 def _revokeStrategy(strategy: address):
1300     self.debtRatio -= self.strategies[strategy].debtRatio
1301     self.strategies[strategy].debtRatio = 0
1302     log StrategyRevoked(strategy)
1303 
1304 
1305 @external
1306 def migrateStrategy(oldVersion: address, newVersion: address):
1307     """
1308     @notice
1309         Migrates a Strategy, including all assets from `oldVersion` to
1310         `newVersion`.
1311 
1312         This may only be called by governance.
1313     @dev
1314         Strategy must successfully migrate all capital and positions to new
1315         Strategy, or else this will upset the balance of the Vault.
1316 
1317         The new Strategy should be "empty" e.g. have no prior commitments to
1318         this Vault, otherwise it could have issues.
1319     @param oldVersion The existing Strategy to migrate from.
1320     @param newVersion The new Strategy to migrate to.
1321     """
1322     assert msg.sender == self.governance
1323     assert newVersion != ZERO_ADDRESS
1324     assert self.strategies[oldVersion].activation > 0
1325     assert self.strategies[newVersion].activation == 0
1326 
1327     strategy: StrategyParams = self.strategies[oldVersion]
1328 
1329     self._revokeStrategy(oldVersion)
1330     # _revokeStrategy will lower the debtRatio
1331     self.debtRatio += strategy.debtRatio
1332     # Debt is migrated to new strategy
1333     self.strategies[oldVersion].totalDebt = 0
1334 
1335     self.strategies[newVersion] = StrategyParams({
1336         performanceFee: strategy.performanceFee,
1337         # NOTE: use last report for activation time, so E[R] calc works
1338         activation: strategy.lastReport,
1339         debtRatio: strategy.debtRatio,
1340         minDebtPerHarvest: strategy.minDebtPerHarvest,
1341         maxDebtPerHarvest: strategy.maxDebtPerHarvest,
1342         lastReport: strategy.lastReport,
1343         totalDebt: strategy.totalDebt,
1344         totalGain: 0,
1345         totalLoss: 0,
1346     })
1347 
1348     Strategy(oldVersion).migrate(newVersion)
1349     log StrategyMigrated(oldVersion, newVersion)
1350 
1351     for idx in range(MAXIMUM_STRATEGIES):
1352         if self.withdrawalQueue[idx] == oldVersion:
1353             self.withdrawalQueue[idx] = newVersion
1354             return  # Don't need to reorder anything because we swapped
1355 
1356 
1357 @external
1358 def revokeStrategy(strategy: address = msg.sender):
1359     """
1360     @notice
1361         Revoke a Strategy, setting its debt limit to 0 and preventing any
1362         future deposits.
1363 
1364         This function should only be used in the scenario where the Strategy is
1365         being retired but no migration of the positions are possible, or in the
1366         extreme scenario that the Strategy needs to be put into "Emergency Exit"
1367         mode in order for it to exit as quickly as possible. The latter scenario
1368         could be for any reason that is considered "critical" that the Strategy
1369         exits its position as fast as possible, such as a sudden change in market
1370         conditions leading to losses, or an imminent failure in an external
1371         dependency.
1372 
1373         This may only be called by governance, the guardian, or the Strategy
1374         itself. Note that a Strategy will only revoke itself during emergency
1375         shutdown.
1376     @param strategy The Strategy to revoke.
1377     """
1378     assert msg.sender in [strategy, self.governance, self.guardian]
1379     assert self.strategies[strategy].debtRatio != 0 # dev: already zero
1380 
1381     self._revokeStrategy(strategy)
1382 
1383 
1384 @external
1385 def addStrategyToQueue(strategy: address):
1386     """
1387     @notice
1388         Adds `strategy` to `withdrawalQueue`.
1389 
1390         This may only be called by governance or management.
1391     @dev
1392         The Strategy will be appended to `withdrawalQueue`, call
1393         `setWithdrawalQueue` to change the order.
1394     @param strategy The Strategy to add.
1395     """
1396     assert msg.sender in [self.management, self.governance]
1397     # Must be a current Strategy
1398     assert self.strategies[strategy].activation > 0
1399     # Can't already be in the queue
1400     last_idx: uint256 = 0
1401     for s in self.withdrawalQueue:
1402         if s == ZERO_ADDRESS:
1403             break
1404         assert s != strategy
1405         last_idx += 1
1406     # Check if queue is full
1407     assert last_idx < MAXIMUM_STRATEGIES
1408 
1409     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1410     self._organizeWithdrawalQueue()
1411     log StrategyAddedToQueue(strategy)
1412 
1413 
1414 @external
1415 def removeStrategyFromQueue(strategy: address):
1416     """
1417     @notice
1418         Remove `strategy` from `withdrawalQueue`.
1419 
1420         This may only be called by governance or management.
1421     @dev
1422         We don't do this with revokeStrategy because it should still
1423         be possible to withdraw from the Strategy if it's unwinding.
1424     @param strategy The Strategy to remove.
1425     """
1426     assert msg.sender in [self.management, self.governance]
1427     for idx in range(MAXIMUM_STRATEGIES):
1428         if self.withdrawalQueue[idx] == strategy:
1429             self.withdrawalQueue[idx] = ZERO_ADDRESS
1430             self._organizeWithdrawalQueue()
1431             log StrategyRemovedFromQueue(strategy)
1432             return  # We found the right location and cleared it
1433     raise  # We didn't find the Strategy in the queue
1434 
1435 
1436 @view
1437 @internal
1438 def _debtOutstanding(strategy: address) -> uint256:
1439     # See note on `debtOutstanding()`.
1440     if self.debtRatio == 0:
1441         return self.strategies[strategy].totalDebt
1442 
1443     strategy_debtLimit: uint256 = (
1444         self.strategies[strategy].debtRatio
1445         * self._totalAssets()
1446         / MAX_BPS
1447     )
1448     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1449 
1450     if self.emergencyShutdown:
1451         return strategy_totalDebt
1452     elif strategy_totalDebt <= strategy_debtLimit:
1453         return 0
1454     else:
1455         return strategy_totalDebt - strategy_debtLimit
1456 
1457 
1458 @view
1459 @external
1460 def debtOutstanding(strategy: address = msg.sender) -> uint256:
1461     """
1462     @notice
1463         Determines if `strategy` is past its debt limit and if any tokens
1464         should be withdrawn to the Vault.
1465     @param strategy The Strategy to check. Defaults to the caller.
1466     @return The quantity of tokens to withdraw.
1467     """
1468     return self._debtOutstanding(strategy)
1469 
1470 
1471 @view
1472 @internal
1473 def _creditAvailable(strategy: address) -> uint256:
1474     # See note on `creditAvailable()`.
1475     if self.emergencyShutdown:
1476         return 0
1477     vault_totalAssets: uint256 = self._totalAssets()
1478     vault_debtLimit: uint256 =  self.debtRatio * vault_totalAssets / MAX_BPS 
1479     vault_totalDebt: uint256 = self.totalDebt
1480     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * vault_totalAssets / MAX_BPS
1481     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1482     strategy_minDebtPerHarvest: uint256 = self.strategies[strategy].minDebtPerHarvest
1483     strategy_maxDebtPerHarvest: uint256 = self.strategies[strategy].maxDebtPerHarvest
1484 
1485     # Exhausted credit line
1486     if strategy_debtLimit <= strategy_totalDebt or vault_debtLimit <= vault_totalDebt:
1487         return 0
1488 
1489     # Start with debt limit left for the Strategy
1490     available: uint256 = strategy_debtLimit - strategy_totalDebt
1491 
1492     # Adjust by the global debt limit left
1493     available = min(available, vault_debtLimit - vault_totalDebt)
1494 
1495     # Can only borrow up to what the contract has in reserve
1496     # NOTE: Running near 100% is discouraged
1497     available = min(available, self.token.balanceOf(self))
1498 
1499     # Adjust by min and max borrow limits (per harvest)
1500     # NOTE: min increase can be used to ensure that if a strategy has a minimum
1501     #       amount of capital needed to purchase a position, it's not given capital
1502     #       it can't make use of yet.
1503     # NOTE: max increase is used to make sure each harvest isn't bigger than what
1504     #       is authorized. This combined with adjusting min and max periods in
1505     #       `BaseStrategy` can be used to effect a "rate limit" on capital increase.
1506     if available < strategy_minDebtPerHarvest:
1507         return 0
1508     else:
1509         return min(available, strategy_maxDebtPerHarvest)
1510 
1511 @view
1512 @external
1513 def creditAvailable(strategy: address = msg.sender) -> uint256:
1514     """
1515     @notice
1516         Amount of tokens in Vault a Strategy has access to as a credit line.
1517 
1518         This will check the Strategy's debt limit, as well as the tokens
1519         available in the Vault, and determine the maximum amount of tokens
1520         (if any) the Strategy may draw on.
1521 
1522         In the rare case the Vault is in emergency shutdown this will return 0.
1523     @param strategy The Strategy to check. Defaults to caller.
1524     @return The quantity of tokens available for the Strategy to draw on.
1525     """
1526     return self._creditAvailable(strategy)
1527 
1528 
1529 @view
1530 @internal
1531 def _expectedReturn(strategy: address) -> uint256:
1532     # See note on `expectedReturn()`.
1533     strategy_lastReport: uint256 = self.strategies[strategy].lastReport
1534     timeSinceLastHarvest: uint256 = block.timestamp - strategy_lastReport
1535     totalHarvestTime: uint256 = strategy_lastReport - self.strategies[strategy].activation
1536 
1537     # NOTE: If either `timeSinceLastHarvest` or `totalHarvestTime` is 0, we can short-circuit to `0`
1538     if timeSinceLastHarvest > 0 and totalHarvestTime > 0 and Strategy(strategy).isActive():
1539         # NOTE: Unlikely to throw unless strategy accumalates >1e68 returns
1540         # NOTE: Calculate average over period of time where harvests have occured in the past
1541         return (
1542             self.strategies[strategy].totalGain
1543             * timeSinceLastHarvest
1544             / totalHarvestTime
1545         )
1546     else:
1547         return 0  # Covers the scenario when block.timestamp == activation
1548 
1549 
1550 @view
1551 @external
1552 def availableDepositLimit() -> uint256:
1553     if self.depositLimit > self._totalAssets():
1554         return self.depositLimit - self._totalAssets()
1555     else:
1556         return 0
1557 
1558 
1559 @view
1560 @external
1561 def expectedReturn(strategy: address = msg.sender) -> uint256:
1562     """
1563     @notice
1564         Provide an accurate expected value for the return this `strategy`
1565         would provide to the Vault the next time `report()` is called
1566         (since the last time it was called).
1567     @param strategy The Strategy to determine the expected return for. Defaults to caller.
1568     @return
1569         The anticipated amount `strategy` should make on its investment
1570         since its last report.
1571     """
1572     return self._expectedReturn(strategy)
1573 
1574 
1575 @internal
1576 def _assessFees(strategy: address, gain: uint256) -> uint256:
1577     # Issue new shares to cover fees
1578     # NOTE: In effect, this reduces overall share price by the combined fee
1579     # NOTE: may throw if Vault.totalAssets() > 1e64, or not called for more than a year
1580     duration: uint256 = block.timestamp - self.strategies[strategy].lastReport
1581     assert duration != 0 # can't assessFees twice within the same block
1582 
1583     if gain == 0:
1584         # NOTE: The fees are not charged if there hasn't been any gains reported
1585         return 0
1586 
1587     management_fee: uint256 = (
1588         (
1589             (self.strategies[strategy].totalDebt - Strategy(strategy).delegatedAssets())
1590             * duration 
1591             * self.managementFee
1592         )
1593         / MAX_BPS
1594         / SECS_PER_YEAR
1595     )
1596 
1597     # NOTE: Applies if Strategy is not shutting down, or it is but all debt paid off
1598     # NOTE: No fee is taken when a Strategy is unwinding it's position, until all debt is paid
1599     strategist_fee: uint256 = (
1600         gain
1601         * self.strategies[strategy].performanceFee
1602         / MAX_BPS
1603     )
1604     # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1605     performance_fee: uint256 = gain * self.performanceFee / MAX_BPS
1606 
1607     # NOTE: This must be called prior to taking new collateral,
1608     #       or the calculation will be wrong!
1609     # NOTE: This must be done at the same time, to ensure the relative
1610     #       ratio of governance_fee : strategist_fee is kept intact
1611     total_fee: uint256 = performance_fee + strategist_fee + management_fee
1612     # ensure total_fee is not more than gain
1613     if total_fee > gain:
1614         total_fee = gain
1615     if total_fee > 0:  # NOTE: If mgmt fee is 0% and no gains were realized, skip
1616         reward: uint256 = self._issueSharesForAmount(self, total_fee)
1617 
1618         # Send the rewards out as new shares in this Vault
1619         if strategist_fee > 0:  # NOTE: Guard against DIV/0 fault
1620             # NOTE: Unlikely to throw unless sqrt(reward) >>> 1e39
1621             strategist_reward: uint256 = (
1622                 strategist_fee
1623                 * reward
1624                 / total_fee
1625             )
1626             self._transfer(self, strategy, strategist_reward)
1627             # NOTE: Strategy distributes rewards at the end of harvest()
1628         # NOTE: Governance earns any dust leftover from flooring math above
1629         if self.balanceOf[self] > 0:
1630             self._transfer(self, self.rewards, self.balanceOf[self])
1631     return total_fee
1632 
1633 
1634 @external
1635 def report(gain: uint256, loss: uint256, _debtPayment: uint256) -> uint256:
1636     """
1637     @notice
1638         Reports the amount of assets the calling Strategy has free (usually in
1639         terms of ROI).
1640 
1641         The performance fee is determined here, off of the strategy's profits
1642         (if any), and sent to governance.
1643 
1644         The strategist's fee is also determined here (off of profits), to be
1645         handled according to the strategist on the next harvest.
1646 
1647         This may only be called by a Strategy managed by this Vault.
1648     @dev
1649         For approved strategies, this is the most efficient behavior.
1650         The Strategy reports back what it has free, then Vault "decides"
1651         whether to take some back or give it more. Note that the most it can
1652         take is `gain + _debtPayment`, and the most it can give is all of the
1653         remaining reserves. Anything outside of those bounds is abnormal behavior.
1654 
1655         All approved strategies must have increased diligence around
1656         calling this function, as abnormal behavior could become catastrophic.
1657     @param gain
1658         Amount Strategy has realized as a gain on it's investment since its
1659         last report, and is free to be given back to Vault as earnings
1660     @param loss
1661         Amount Strategy has realized as a loss on it's investment since its
1662         last report, and should be accounted for on the Vault's balance sheet.
1663         The loss will reduce the debtRatio. The next time the strategy will harvest,
1664         it will pay back the debt in an attempt to adjust to the new debt limit.
1665     @param _debtPayment
1666         Amount Strategy has made available to cover outstanding debt
1667     @return Amount of debt outstanding (if totalDebt > debtLimit or emergency shutdown).
1668     """
1669 
1670     # Only approved strategies can call this function
1671     assert self.strategies[msg.sender].activation > 0
1672     # No lying about total available to withdraw!
1673     assert self.token.balanceOf(msg.sender) >= gain + _debtPayment
1674 
1675     # We have a loss to report, do it before the rest of the calculations
1676     if loss > 0:
1677         self._reportLoss(msg.sender, loss)
1678 
1679     # Assess both management fee and performance fee, and issue both as shares of the vault
1680     totalFees: uint256 = self._assessFees(msg.sender, gain)
1681 
1682     # Returns are always "realized gains"
1683     self.strategies[msg.sender].totalGain += gain
1684 
1685     # Compute the line of credit the Vault is able to offer the Strategy (if any)
1686     credit: uint256 = self._creditAvailable(msg.sender)
1687 
1688     # Outstanding debt the Strategy wants to take back from the Vault (if any)
1689     # NOTE: debtOutstanding <= StrategyParams.totalDebt
1690     debt: uint256 = self._debtOutstanding(msg.sender)
1691     debtPayment: uint256 = min(_debtPayment, debt)
1692 
1693     if debtPayment > 0:
1694         self.strategies[msg.sender].totalDebt -= debtPayment
1695         self.totalDebt -= debtPayment
1696         debt -= debtPayment
1697         # NOTE: `debt` is being tracked for later
1698 
1699     # Update the actual debt based on the full credit we are extending to the Strategy
1700     # or the returns if we are taking funds back
1701     # NOTE: credit + self.strategies[msg.sender].totalDebt is always < self.debtLimit
1702     # NOTE: At least one of `credit` or `debt` is always 0 (both can be 0)
1703     if credit > 0:
1704         self.strategies[msg.sender].totalDebt += credit
1705         self.totalDebt += credit
1706 
1707     # Give/take balance to Strategy, based on the difference between the reported gains
1708     # (if any), the debt payment (if any), the credit increase we are offering (if any),
1709     # and the debt needed to be paid off (if any)
1710     # NOTE: This is just used to adjust the balance of tokens between the Strategy and
1711     #       the Vault based on the Strategy's debt limit (as well as the Vault's).
1712     totalAvail: uint256 = gain + debtPayment
1713     if totalAvail < credit:  # credit surplus, give to Strategy
1714         self.erc20_safe_transfer(self.token.address, msg.sender, credit - totalAvail)
1715     elif totalAvail > credit:  # credit deficit, take from Strategy
1716         self.erc20_safe_transferFrom(self.token.address, msg.sender, self, totalAvail - credit)
1717     # else, don't do anything because it is balanced
1718 
1719     # Profit is locked and gradually released per block
1720     # NOTE: compute current locked profit and replace with sum of current and new
1721     lockedProfitBeforeLoss: uint256 = self._calculateLockedProfit() + gain - totalFees
1722     if lockedProfitBeforeLoss > loss: 
1723         self.lockedProfit = lockedProfitBeforeLoss - loss
1724     else:
1725         self.lockedProfit = 0
1726 
1727     # Update reporting time
1728     self.strategies[msg.sender].lastReport = block.timestamp
1729     self.lastReport = block.timestamp
1730 
1731     log StrategyReported(
1732         msg.sender,
1733         gain,
1734         loss,
1735         debtPayment,
1736         self.strategies[msg.sender].totalGain,
1737         self.strategies[msg.sender].totalLoss,
1738         self.strategies[msg.sender].totalDebt,
1739         credit,
1740         self.strategies[msg.sender].debtRatio,
1741     )
1742 
1743     if self.strategies[msg.sender].debtRatio == 0 or self.emergencyShutdown:
1744         # Take every last penny the Strategy has (Emergency Exit/revokeStrategy)
1745         # NOTE: This is different than `debt` in order to extract *all* of the returns
1746         return Strategy(msg.sender).estimatedTotalAssets()
1747     else:
1748         # Otherwise, just return what we have as debt outstanding
1749         return debt
1750 
1751 
1752 @external
1753 def sweep(token: address, amount: uint256 = MAX_UINT256):
1754     """
1755     @notice
1756         Removes tokens from this Vault that are not the type of token managed
1757         by this Vault. This may be used in case of accidentally sending the
1758         wrong kind of token to this Vault.
1759 
1760         Tokens will be sent to `governance`.
1761 
1762         This will fail if an attempt is made to sweep the tokens that this
1763         Vault manages.
1764 
1765         This may only be called by governance.
1766     @param token The token to transfer out of this vault.
1767     @param amount The quantity or tokenId to transfer out.
1768     """
1769     assert msg.sender == self.governance
1770     # Can't be used to steal what this Vault is protecting
1771     assert token != self.token.address
1772     value: uint256 = amount
1773     if value == MAX_UINT256:
1774         value = ERC20(token).balanceOf(self)
1775     self.erc20_safe_transfer(token, self.governance, value)