1 # @version 0.2.11
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
38 API_VERSION: constant(String[28]) = "0.3.3"
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
55     def estimatedTotalAssets() -> uint256: view
56     def withdraw(_amount: uint256) -> uint256: nonpayable
57     def migrate(_newStrategy: address): nonpayable
58 
59 
60 interface GuestList:
61     def authorized(guest: address, amount: uint256) -> bool: view
62 
63 
64 event Transfer:
65     sender: indexed(address)
66     receiver: indexed(address)
67     value: uint256
68 
69 
70 event Approval:
71     owner: indexed(address)
72     spender: indexed(address)
73     value: uint256
74 
75 
76 name: public(String[64])
77 symbol: public(String[32])
78 decimals: public(uint256)
79 
80 balanceOf: public(HashMap[address, uint256])
81 allowance: public(HashMap[address, HashMap[address, uint256]])
82 totalSupply: public(uint256)
83 
84 token: public(ERC20)
85 governance: public(address)
86 management: public(address)
87 guardian: public(address)
88 pendingGovernance: address
89 guestList: public(GuestList)
90 
91 struct StrategyParams:
92     performanceFee: uint256  # Strategist's fee (basis points)
93     activation: uint256  # Activation block.timestamp
94     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
95     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
96     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
97     lastReport: uint256  # block.timestamp of the last time a report occured
98     totalDebt: uint256  # Total outstanding debt that Strategy has
99     totalGain: uint256  # Total returns that Strategy has realized for Vault
100     totalLoss: uint256  # Total losses that Strategy has realized for Vault
101 
102 
103 event StrategyAdded:
104     strategy: indexed(address)
105     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
106     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
107     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
108     performanceFee: uint256  # Strategist's fee (basis points)
109 
110 
111 event StrategyReported:
112     strategy: indexed(address)
113     gain: uint256
114     loss: uint256
115     debtPaid: uint256
116     totalGain: uint256
117     totalLoss: uint256
118     totalDebt: uint256
119     debtAdded: uint256
120     debtRatio: uint256
121 
122 
123 event UpdateGovernance:
124     governance: address # New active governance
125 
126 
127 event UpdateManagement:
128     management: address # New active manager
129 
130 
131 event UpdateGuestList:
132     guestList: address # Vault guest list address
133 
134 
135 event UpdateRewards:
136     rewards: address # New active rewards recipient
137 
138 
139 event UpdateDepositLimit:
140     depositLimit: uint256 # New active deposit limit
141 
142 
143 event UpdatePerformanceFee:
144     performanceFee: uint256 # New active performance fee
145 
146 
147 event UpdateManagementFee:
148     managementFee: uint256 # New active management fee
149 
150 
151 event UpdateGuardian:
152     guardian: address # Address of the active guardian
153 
154 
155 event EmergencyShutdown:
156     active: bool # New emergency shutdown state (if false, normal operation enabled)
157 
158 
159 event UpdateWithdrawalQueue:
160     queue: address[MAXIMUM_STRATEGIES] # New active withdrawal queue
161 
162 
163 event StrategyUpdateDebtRatio:
164     strategy: indexed(address) # Address of the strategy for the debt ratio adjustment
165     debtRatio: uint256 # The new debt limit for the strategy (in BPS of total assets)
166 
167 
168 event StrategyUpdateMinDebtPerHarvest:
169     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
170     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
171 
172 
173 event StrategyUpdateMaxDebtPerHarvest:
174     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
175     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
176 
177 
178 event StrategyUpdatePerformanceFee:
179     strategy: indexed(address) # Address of the strategy for the performance fee adjustment
180     performanceFee: uint256 # The new performance fee for the strategy
181 
182 
183 event StrategyMigrated:
184     oldVersion: indexed(address) # Old version of the strategy to be migrated
185     newVersion: indexed(address) # New version of the strategy
186 
187 
188 event StrategyRevoked:
189     strategy: indexed(address) # Address of the strategy that is revoked
190 
191 
192 event StrategyRemovedFromQueue:
193     strategy: indexed(address) # Address of the strategy that is removed from the withdrawal queue
194 
195 
196 event StrategyAddedToQueue:
197     strategy: indexed(address) # Address of the strategy that is added to the withdrawal queue
198 
199 
200 
201 # NOTE: Track the total for overhead targeting purposes
202 strategies: public(HashMap[address, StrategyParams])
203 MAXIMUM_STRATEGIES: constant(uint256) = 20
204 DEGREDATION_COEFFICIENT: constant(uint256) = 10 ** 18
205 
206 # Ordering that `withdraw` uses to determine which strategies to pull funds from
207 # NOTE: Does *NOT* have to match the ordering of all the current strategies that
208 #       exist, but it is recommended that it does or else withdrawal depth is
209 #       limited to only those inside the queue.
210 # NOTE: Ordering is determined by governance, and should be balanced according
211 #       to risk, slippage, and/or volatility. Can also be ordered to increase the
212 #       withdrawal speed of a particular Strategy.
213 # NOTE: The first time a ZERO_ADDRESS is encountered, it stops withdrawing
214 withdrawalQueue: public(address[MAXIMUM_STRATEGIES])
215 
216 emergencyShutdown: public(bool)
217 
218 depositLimit: public(uint256)  # Limit for totalAssets the Vault can hold
219 debtRatio: public(uint256)  # Debt ratio for the Vault across all strategies (in BPS, <= 10k)
220 totalDebt: public(uint256)  # Amount of tokens that all strategies have borrowed
221 lastReport: public(uint256)  # block.timestamp of last report
222 activation: public(uint256)  # block.timestamp of contract deployment
223 lockedProfit: public(uint256) # how much profit is locked and cant be withdrawn
224 
225 lockedProfitDegration: public(uint256) # rate per block of degration. DEGREDATION_COEFFICIENT is 100% per block
226 rewards: public(address)  # Rewards contract where Governance fees are sent to
227 # Governance Fee for management of Vault (given to `rewards`)
228 managementFee: public(uint256)
229 # Governance Fee for performance of Vault (given to `rewards`)
230 performanceFee: public(uint256)
231 MAX_BPS: constant(uint256) = 10_000  # 100%, or 10k basis points
232 # NOTE: A four-century period will be missing 3 of its 100 Julian leap years, leaving 97. 
233 #       So the average year has 365 + 97/400 = 365.2425 days 
234 #       ERROR(Julian): -0.0078
235 #       ERROR(Gregorian): -0.0003
236 SECS_PER_YEAR: constant(uint256) = 31_556_952  # 365.2425 days
237 # `nonces` track `permit` approvals with signature.
238 nonces: public(HashMap[address, uint256])
239 DOMAIN_SEPARATOR: public(bytes32)
240 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
241 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
242 
243 
244 @external
245 def initialize(
246     token: address,
247     governance: address,
248     rewards: address,
249     nameOverride: String[64],
250     symbolOverride: String[32],
251     guardian: address = msg.sender,
252 ):
253     """
254     @notice
255         Initializes the Vault, this is called only once, when the contract is
256         deployed.
257         The performance fee is set to 10% of yield, per Strategy.
258         The management fee is set to 2%, per year.
259         The initial deposit limit is set to 0 (deposits disabled); it must be
260         updated after initialization.
261     @dev
262         If `nameOverride` is not specified, the name will be 'yearn'
263         combined with the name of `token`.
264 
265         If `symbolOverride` is not specified, the symbol will be 'y'
266         combined with the symbol of `token`.
267     @param token The token that may be deposited into this Vault.
268     @param governance The address authorized for governance interactions.
269     @param rewards The address to distribute rewards to.
270     @param nameOverride Specify a custom Vault name. Leave empty for default choice.
271     @param symbolOverride Specify a custom Vault symbol name. Leave empty for default choice.
272     @param guardian The address authorized for guardian interactions. Defaults to caller.
273     """
274     assert self.activation == 0  # dev: no devops199
275     self.token = ERC20(token)
276     if nameOverride == "":
277         self.name = concat(DetailedERC20(token).symbol(), " yVault")
278     else:
279         self.name = nameOverride
280     if symbolOverride == "":
281         self.symbol = concat("yv", DetailedERC20(token).symbol())
282     else:
283         self.symbol = symbolOverride
284     self.decimals = DetailedERC20(token).decimals()
285     self.governance = governance
286     log UpdateGovernance(governance)
287     self.management = governance
288     log UpdateManagement(governance)
289     self.rewards = rewards
290     log UpdateRewards(rewards)
291     self.guardian = guardian
292     log UpdateGuardian(guardian)
293     self.performanceFee = 1000  # 10% of yield (per Strategy)
294     log UpdatePerformanceFee(convert(1000, uint256))
295     self.managementFee = 200  # 2% per year
296     log UpdateManagementFee(convert(200, uint256))
297     self.lastReport = block.timestamp
298     self.activation = block.timestamp
299     self.lockedProfitDegration = convert(DEGREDATION_COEFFICIENT * 46 /10 ** 6 , uint256) # 6 hours in blocks
300     # EIP-712
301     self.DOMAIN_SEPARATOR = keccak256(
302         concat(
303             DOMAIN_TYPE_HASH,
304             keccak256(convert("Yearn Vault", Bytes[11])),
305             keccak256(convert(API_VERSION, Bytes[28])),
306             convert(chain.id, bytes32),
307             convert(self, bytes32)
308         )
309     )
310 
311 
312 @pure
313 @external
314 def apiVersion() -> String[28]:
315     """
316     @notice
317         Used to track the deployed version of this contract. In practice you
318         can use this version number to compare with Yearn's GitHub and
319         determine which version of the source matches this deployed contract.
320     @dev
321         All strategies must have an `apiVersion()` that matches the Vault's
322         `API_VERSION`.
323     @return API_VERSION which holds the current version of this contract.
324     """
325     return API_VERSION
326 
327 
328 @external
329 def setName(name: String[42]):
330     """
331     @notice
332         Used to change the value of `name`.
333 
334         This may only be called by governance.
335     @param name The new name to use.
336     """
337     assert msg.sender == self.governance
338     self.name = name
339 
340 
341 @external
342 def setSymbol(symbol: String[20]):
343     """
344     @notice
345         Used to change the value of `symbol`.
346 
347         This may only be called by governance.
348     @param symbol The new symbol to use.
349     """
350     assert msg.sender == self.governance
351     self.symbol = symbol
352 
353 
354 # 2-phase commit for a change in governance
355 @external
356 def setGovernance(governance: address):
357     """
358     @notice
359         Nominate a new address to use as governance.
360 
361         The change does not go into effect immediately. This function sets a
362         pending change, and the governance address is not updated until
363         the proposed governance address has accepted the responsibility.
364 
365         This may only be called by the current governance address.
366     @param governance The address requested to take over Vault governance.
367     """
368     assert msg.sender == self.governance
369     self.pendingGovernance = governance
370 
371 
372 @external
373 def acceptGovernance():
374     """
375     @notice
376         Once a new governance address has been proposed using setGovernance(),
377         this function may be called by the proposed address to accept the
378         responsibility of taking over governance for this contract.
379 
380         This may only be called by the proposed governance address.
381     @dev
382         setGovernance() should be called by the existing governance address,
383         prior to calling this function.
384     """
385     assert msg.sender == self.pendingGovernance
386     self.governance = msg.sender
387     log UpdateGovernance(msg.sender)
388 
389 
390 @external
391 def setManagement(management: address):
392     """
393     @notice
394         Changes the management address.
395         Management is able to make some investment decisions adjusting parameters.
396 
397         This may only be called by governance.
398     @param management The address to use for managing.
399     """
400     assert msg.sender == self.governance
401     self.management = management
402     log UpdateManagement(management)
403 
404 
405 @external
406 def setGuestList(guestList: address):
407     """
408     @notice
409         Used to set or change `guestList`. A guest list is another contract
410         that dictates who is allowed to participate in a Vault (and transfer
411         shares).
412 
413         This may only be called by governance.
414     @param guestList The address of the `GuestList` contract to use.
415     """
416     assert msg.sender == self.governance
417     self.guestList = GuestList(guestList)
418     log UpdateGuestList(guestList)
419 
420 
421 @external
422 def setRewards(rewards: address):
423     """
424     @notice
425         Changes the rewards address. Any distributed rewards
426         will cease flowing to the old address and begin flowing
427         to this address once the change is in effect.
428 
429         This will not change any Strategy reports in progress, only
430         new reports made after this change goes into effect.
431 
432         This may only be called by governance.
433     @param rewards The address to use for collecting rewards.
434     """
435     assert msg.sender == self.governance
436     self.rewards = rewards
437     log UpdateRewards(rewards)
438 
439 @external
440 def setLockedProfitDegration(degration: uint256):
441     """
442     @notice
443         Changes the locked profit degration. 
444     @param degration The rate of degration in percent per second scaled to 1e18.
445     """
446     assert msg.sender == self.governance
447     # Since "degration" is of type uint256 it can never be less than zero
448     assert degration <= DEGREDATION_COEFFICIENT
449     self.lockedProfitDegration = degration
450 
451 @external
452 def setDepositLimit(limit: uint256):
453     """
454     @notice
455         Changes the maximum amount of tokens that can be deposited in this Vault.
456 
457         Note, this is not how much may be deposited by a single depositor,
458         but the maximum amount that may be deposited across all depositors.
459 
460         This may only be called by governance.
461     @param limit The new deposit limit to use.
462     """
463     assert msg.sender == self.governance
464     self.depositLimit = limit
465     log UpdateDepositLimit(limit)
466 
467 
468 @external
469 def setPerformanceFee(fee: uint256):
470     """
471     @notice
472         Used to change the value of `performanceFee`.
473 
474         Should set this value below the maximum strategist performance fee.
475 
476         This may only be called by governance.
477     @param fee The new performance fee to use.
478     """
479     assert msg.sender == self.governance
480     assert fee <= MAX_BPS
481     self.performanceFee = fee
482     log UpdatePerformanceFee(fee)
483 
484 
485 @external
486 def setManagementFee(fee: uint256):
487     """
488     @notice
489         Used to change the value of `managementFee`.
490 
491         This may only be called by governance.
492     @param fee The new management fee to use.
493     """
494     assert msg.sender == self.governance
495     assert fee <= MAX_BPS
496     self.managementFee = fee
497     log UpdateManagementFee(fee)
498 
499 
500 @external
501 def setGuardian(guardian: address):
502     """
503     @notice
504         Used to change the address of `guardian`.
505 
506         This may only be called by governance or the existing guardian.
507     @param guardian The new guardian address to use.
508     """
509     assert msg.sender in [self.guardian, self.governance]
510     self.guardian = guardian
511     log UpdateGuardian(guardian)
512 
513 
514 @external
515 def setEmergencyShutdown(active: bool):
516     """
517     @notice
518         Activates or deactivates Vault mode where all Strategies go into full
519         withdrawal.
520 
521         During Emergency Shutdown:
522         1. No Users may deposit into the Vault (but may withdraw as usual.)
523         2. Governance may not add new Strategies.
524         3. Each Strategy must pay back their debt as quickly as reasonable to
525             minimally affect their position.
526         4. Only Governance may undo Emergency Shutdown.
527 
528         See contract level note for further details.
529 
530         This may only be called by governance or the guardian.
531     @param active
532         If true, the Vault goes into Emergency Shutdown. If false, the Vault
533         goes back into Normal Operation.
534     """
535     if active:
536         assert msg.sender in [self.guardian, self.governance]
537     else:
538         assert msg.sender == self.governance
539     self.emergencyShutdown = active
540     log EmergencyShutdown(active)
541 
542 
543 @external
544 def setWithdrawalQueue(queue: address[MAXIMUM_STRATEGIES]):
545     """
546     @notice
547         Updates the withdrawalQueue to match the addresses and order specified
548         by `queue`.
549 
550         There can be fewer strategies than the maximum, as well as fewer than
551         the total number of strategies active in the vault. `withdrawalQueue`
552         will be updated in a gas-efficient manner, assuming the input is well-
553         ordered with 0x0 only at the end.
554 
555         This may only be called by governance or management.
556     @dev
557         This is order sensitive, specify the addresses in the order in which
558         funds should be withdrawn (so `queue`[0] is the first Strategy withdrawn
559         from, `queue`[1] is the second, etc.)
560 
561         This means that the least impactful Strategy (the Strategy that will have
562         its core positions impacted the least by having funds removed) should be
563         at `queue`[0], then the next least impactful at `queue`[1], and so on.
564     @param queue
565         The array of addresses to use as the new withdrawal queue. This is
566         order sensitive.
567     """
568     assert msg.sender in [self.management, self.governance]
569     # HACK: Temporary until Vyper adds support for Dynamic arrays
570     for i in range(MAXIMUM_STRATEGIES):
571         if queue[i] == ZERO_ADDRESS and self.withdrawalQueue[i] == ZERO_ADDRESS:
572             break
573         assert self.strategies[queue[i]].activation > 0
574         self.withdrawalQueue[i] = queue[i]
575     log UpdateWithdrawalQueue(queue)
576 
577 
578 @internal
579 def erc20_safe_transfer(token: address, receiver: address, amount: uint256):
580     # Used only to send tokens that are not the type managed by this Vault.
581     # HACK: Used to handle non-compliant tokens like USDT
582     response: Bytes[32] = raw_call(
583         token,
584         concat(
585             method_id("transfer(address,uint256)"),
586             convert(receiver, bytes32),
587             convert(amount, bytes32),
588         ),
589         max_outsize=32,
590     )
591     if len(response) > 0:
592         assert convert(response, bool), "Transfer failed!"
593 
594 
595 @internal
596 def erc20_safe_transferFrom(token: address, sender: address, receiver: address, amount: uint256):
597     # Used only to send tokens that are not the type managed by this Vault.
598     # HACK: Used to handle non-compliant tokens like USDT
599     response: Bytes[32] = raw_call(
600         token,
601         concat(
602             method_id("transferFrom(address,address,uint256)"),
603             convert(sender, bytes32),
604             convert(receiver, bytes32),
605             convert(amount, bytes32),
606         ),
607         max_outsize=32,
608     )
609     if len(response) > 0:
610         assert convert(response, bool), "Transfer failed!"
611 
612 
613 @internal
614 def _transfer(sender: address, receiver: address, amount: uint256):
615     # See note on `transfer()`.
616 
617     # Protect people from accidentally sending their shares to bad places
618     assert not (receiver in [self, ZERO_ADDRESS])
619     self.balanceOf[sender] -= amount
620     self.balanceOf[receiver] += amount
621     log Transfer(sender, receiver, amount)
622 
623 
624 @external
625 def transfer(receiver: address, amount: uint256) -> bool:
626     """
627     @notice
628         Transfers shares from the caller's address to `receiver`. This function
629         will always return true, unless the user is attempting to transfer
630         shares to this contract's address, or to 0x0.
631     @param receiver
632         The address shares are being transferred to. Must not be this contract's
633         address, must not be 0x0.
634     @param amount The quantity of shares to transfer.
635     @return
636         True if transfer is sent to an address other than this contract's or
637         0x0, otherwise the transaction will fail.
638     """
639     self._transfer(msg.sender, receiver, amount)
640     return True
641 
642 
643 @external
644 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
645     """
646     @notice
647         Transfers `amount` shares from `sender` to `receiver`. This operation will
648         always return true, unless the user is attempting to transfer shares
649         to this contract's address, or to 0x0.
650 
651         Unless the caller has given this contract unlimited approval,
652         transfering shares will decrement the caller's `allowance` by `amount`.
653     @param sender The address shares are being transferred from.
654     @param receiver
655         The address shares are being transferred to. Must not be this contract's
656         address, must not be 0x0.
657     @param amount The quantity of shares to transfer.
658     @return
659         True if transfer is sent to an address other than this contract's or
660         0x0, otherwise the transaction will fail.
661     """
662     # Unlimited approval (saves an SSTORE)
663     if (self.allowance[sender][msg.sender] < MAX_UINT256):
664         allowance: uint256 = self.allowance[sender][msg.sender] - amount
665         self.allowance[sender][msg.sender] = allowance
666         # NOTE: Allows log filters to have a full accounting of allowance changes
667         log Approval(sender, msg.sender, allowance)
668     self._transfer(sender, receiver, amount)
669     return True
670 
671 
672 @external
673 def approve(spender: address, amount: uint256) -> bool:
674     """
675     @dev Approve the passed address to spend the specified amount of tokens on behalf of
676          `msg.sender`. Beware that changing an allowance with this method brings the risk
677          that someone may use both the old and the new allowance by unfortunate transaction
678          ordering. See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
679     @param spender The address which will spend the funds.
680     @param amount The amount of tokens to be spent.
681     """
682     self.allowance[msg.sender][spender] = amount
683     log Approval(msg.sender, spender, amount)
684     return True
685 
686 
687 @external
688 def increaseAllowance(spender: address, amount: uint256) -> bool:
689     """
690     @dev Increase the allowance of the passed address to spend the total amount of tokens
691          on behalf of msg.sender. This method mitigates the risk that someone may use both
692          the old and the new allowance by unfortunate transaction ordering.
693          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
694     @param spender The address which will spend the funds.
695     @param amount The amount of tokens to increase the allowance by.
696     """
697     self.allowance[msg.sender][spender] += amount
698     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
699     return True
700 
701 
702 @external
703 def decreaseAllowance(spender: address, amount: uint256) -> bool:
704     """
705     @dev Decrease the allowance of the passed address to spend the total amount of tokens
706          on behalf of msg.sender. This method mitigates the risk that someone may use both
707          the old and the new allowance by unfortunate transaction ordering.
708          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
709     @param spender The address which will spend the funds.
710     @param amount The amount of tokens to decrease the allowance by.
711     """
712     self.allowance[msg.sender][spender] -= amount
713     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
714     return True
715 
716 
717 @external
718 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
719     """
720     @notice
721         Approves spender by owner's signature to expend owner's tokens.
722         See https://eips.ethereum.org/EIPS/eip-2612.
723 
724     @param owner The address which is a source of funds and has signed the Permit.
725     @param spender The address which is allowed to spend the funds.
726     @param amount The amount of tokens to be spent.
727     @param expiry The timestamp after which the Permit is no longer valid.
728     @param signature A valid secp256k1 signature of Permit by owner encoded as r, s, v.
729     @return True, if transaction completes successfully
730     """
731     assert owner != ZERO_ADDRESS  # dev: invalid owner
732     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
733     nonce: uint256 = self.nonces[owner]
734     digest: bytes32 = keccak256(
735         concat(
736             b'\x19\x01',
737             self.DOMAIN_SEPARATOR,
738             keccak256(
739                 concat(
740                     PERMIT_TYPE_HASH,
741                     convert(owner, bytes32),
742                     convert(spender, bytes32),
743                     convert(amount, bytes32),
744                     convert(nonce, bytes32),
745                     convert(expiry, bytes32),
746                 )
747             )
748         )
749     )
750     # NOTE: signature is packed as r, s, v
751     r: uint256 = convert(slice(signature, 0, 32), uint256)
752     s: uint256 = convert(slice(signature, 32, 32), uint256)
753     v: uint256 = convert(slice(signature, 64, 1), uint256)
754     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
755     self.allowance[owner][spender] = amount
756     self.nonces[owner] = nonce + 1
757     log Approval(owner, spender, amount)
758     return True
759 
760 
761 @view
762 @internal
763 def _totalAssets() -> uint256:
764     # See note on `totalAssets()`.
765     return self.token.balanceOf(self) + self.totalDebt
766 
767 
768 @view
769 @external
770 def totalAssets() -> uint256:
771     """
772     @notice
773         Returns the total quantity of all assets under control of this
774         Vault, whether they're loaned out to a Strategy, or currently held in
775         the Vault.
776     @return The total assets under control of this Vault.
777     """
778     return self._totalAssets()
779 
780 
781 @internal
782 def _issueSharesForAmount(to: address, amount: uint256) -> uint256:
783     # Issues `amount` Vault shares to `to`.
784     # Shares must be issued prior to taking on new collateral, or
785     # calculation will be wrong. This means that only *trusted* tokens
786     # (with no capability for exploitative behavior) can be used.
787     shares: uint256 = 0
788     # HACK: Saves 2 SLOADs (~4000 gas)
789     totalSupply: uint256 = self.totalSupply
790     if totalSupply > 0:
791         # Mint amount of shares based on what the Vault is managing overall
792         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
793         shares = amount * totalSupply / self._totalAssets()
794     else:
795         # No existing shares, so mint 1:1
796         shares = amount
797 
798     # Mint new shares
799     self.totalSupply = totalSupply + shares
800     self.balanceOf[to] += shares
801     log Transfer(ZERO_ADDRESS, to, shares)
802 
803     return shares
804 
805 
806 @external
807 @nonreentrant("withdraw")
808 def deposit(_amount: uint256 = MAX_UINT256, recipient: address = msg.sender) -> uint256:
809     """
810     @notice
811         Deposits `_amount` `token`, issuing shares to `recipient`. If the
812         Vault is in Emergency Shutdown, deposits will not be accepted and this
813         call will fail.
814     @dev
815         Measuring quantity of shares to issues is based on the total
816         outstanding debt that this contract has ("expected value") instead
817         of the total balance sheet it has ("estimated value") has important
818         security considerations, and is done intentionally. If this value were
819         measured against external systems, it could be purposely manipulated by
820         an attacker to withdraw more assets than they otherwise should be able
821         to claim by redeeming their shares.
822 
823         On deposit, this means that shares are issued against the total amount
824         that the deposited capital can be given in service of the debt that
825         Strategies assume. If that number were to be lower than the "expected
826         value" at some future point, depositing shares via this method could
827         entitle the depositor to *less* than the deposited value once the
828         "realized value" is updated from further reports by the Strategies
829         to the Vaults.
830 
831         Care should be taken by integrators to account for this discrepancy,
832         by using the view-only methods of this contract (both off-chain and
833         on-chain) to determine if depositing into the Vault is a "good idea".
834     @param _amount The quantity of tokens to deposit, defaults to all.
835     @param recipient
836         The address to issue the shares in this Vault to. Defaults to the
837         caller's address.
838     @return The issued Vault shares.
839     """
840     assert not self.emergencyShutdown  # Deposits are locked out
841 
842     amount: uint256 = _amount
843 
844     # If _amount not specified, transfer the full token balance,
845     # up to deposit limit
846     if amount == MAX_UINT256:
847         amount = min(
848             self.depositLimit - self._totalAssets(),
849             self.token.balanceOf(msg.sender),
850         )
851     else:
852         # Ensure deposit limit is respected
853         assert self._totalAssets() + amount <= self.depositLimit
854 
855     # Ensure we are depositing something
856     assert amount > 0
857 
858     # Ensure deposit is permitted by guest list
859     if self.guestList.address != ZERO_ADDRESS:
860         assert self.guestList.authorized(msg.sender, amount)
861 
862     # Issue new shares (needs to be done before taking deposit to be accurate)
863     # Shares are issued to recipient (may be different from msg.sender)
864     # See @dev note, above.
865     shares: uint256 = self._issueSharesForAmount(recipient, amount)
866 
867     # Tokens are transferred from msg.sender (may be different from _recipient)
868     self.erc20_safe_transferFrom(self.token.address, msg.sender, self, amount)
869 
870     return shares  # Just in case someone wants them
871 
872 
873 @view
874 @internal
875 def _shareValue(shares: uint256) -> uint256:
876     # Determines the current value of `shares`.
877         # NOTE: if sqrt(Vault.totalAssets()) >>> 1e39, this could potentially revert
878     lockedFundsRatio: uint256 = (block.timestamp - self.lastReport) * self.lockedProfitDegration
879     freeFunds: uint256 = self._totalAssets()
880 
881     if(lockedFundsRatio < DEGREDATION_COEFFICIENT):
882         freeFunds -= (self.lockedProfit - (lockedFundsRatio * self.lockedProfit / DEGREDATION_COEFFICIENT))
883     # NOTE: using 1e3 for extra precision here, when decimals is low
884     return ((10 ** 3 * (shares * freeFunds)) / self.totalSupply) / 10 ** 3
885 
886     
887 @view
888 @internal
889 def _sharesForAmount(amount: uint256) -> uint256:
890     # Determines how many shares `amount` of token would receive.
891     # See dev note on `deposit`.
892     if self._totalAssets() > 0:
893         # NOTE: if sqrt(token.totalSupply()) > 1e37, this could potentially revert
894         return ((10 ** 3 * (amount * self.totalSupply)) / self._totalAssets()) / 10 ** 3
895     else:
896         return 0
897 
898 
899 @view
900 @external
901 def maxAvailableShares() -> uint256:
902     """
903     @notice
904         Determines the maximum quantity of shares this Vault can facilitate a
905         withdrawal for, factoring in assets currently residing in the Vault,
906         as well as those deployed to strategies on the Vault's balance sheet.
907     @dev
908         Regarding how shares are calculated, see dev note on `deposit`.
909 
910         If you want to calculated the maximum a user could withdraw up to,
911         you want to use this function.
912 
913         Note that the amount provided by this function is the theoretical
914         maximum possible from withdrawing, the real amount depends on the
915         realized losses incurred during withdrawal.
916     @return The total quantity of shares this Vault can provide.
917     """
918     shares: uint256 = self._sharesForAmount(self.token.balanceOf(self))
919 
920     for strategy in self.withdrawalQueue:
921         if strategy == ZERO_ADDRESS:
922             break
923         shares += self._sharesForAmount(self.strategies[strategy].totalDebt)
924 
925     return shares
926 
927 
928 @external
929 @nonreentrant("withdraw")
930 def withdraw(
931     maxShares: uint256 = MAX_UINT256,
932     recipient: address = msg.sender,
933     maxLoss: uint256 = 1,  # 0.01% [BPS]
934 ) -> uint256:
935     """
936     @notice
937         Withdraws the calling account's tokens from this Vault, redeeming
938         amount `_shares` for an appropriate amount of tokens.
939 
940         See note on `setWithdrawalQueue` for further details of withdrawal
941         ordering and behavior.
942     @dev
943         Measuring the value of shares is based on the total outstanding debt
944         that this contract has ("expected value") instead of the total balance
945         sheet it has ("estimated value") has important security considerations,
946         and is done intentionally. If this value were measured against external
947         systems, it could be purposely manipulated by an attacker to withdraw
948         more assets than they otherwise should be able to claim by redeeming
949         their shares.
950 
951         On withdrawal, this means that shares are redeemed against the total
952         amount that the deposited capital had "realized" since the point it
953         was deposited, up until the point it was withdrawn. If that number
954         were to be higher than the "expected value" at some future point,
955         withdrawing shares via this method could entitle the depositor to
956         *more* than the expected value once the "realized value" is updated
957         from further reports by the Strategies to the Vaults.
958 
959         Under exceptional scenarios, this could cause earlier withdrawals to
960         earn "more" of the underlying assets than Users might otherwise be
961         entitled to, if the Vault's estimated value were otherwise measured
962         through external means, accounting for whatever exceptional scenarios
963         exist for the Vault (that aren't covered by the Vault's own design.)
964     @param maxShares
965         How many shares to try and redeem for tokens, defaults to all.
966     @param recipient
967         The address to issue the shares in this Vault to. Defaults to the
968         caller's address.
969     @param maxLoss
970         The maximum acceptable loss to sustain on withdrawal. Defaults to 0.01%.
971     @return The quantity of tokens redeemed for `_shares`.
972     """
973     shares: uint256 = maxShares  # May reduce this number below
974 
975     # If _shares not specified, transfer full share balance
976     if shares == MAX_UINT256:
977         shares = self.balanceOf[msg.sender]
978 
979     # Limit to only the shares they own
980     assert shares <= self.balanceOf[msg.sender]
981 
982     # See @dev note, above.
983     value: uint256 = self._shareValue(shares)
984 
985     totalLoss: uint256 = 0
986     if value > self.token.balanceOf(self):
987         # We need to go get some from our strategies in the withdrawal queue
988         # NOTE: This performs forced withdrawals from each Strategy. During
989         #       forced withdrawal, a Strategy may realize a loss. That loss
990         #       is reported back to the Vault, and the will affect the amount
991         #       of tokens that the withdrawer receives for their shares. They
992         #       can optionally specify the maximum acceptable loss (in BPS)
993         #       to prevent excessive losses on their withdrawals (which may
994         #       happen in certain edge cases where Strategies realize a loss)
995         for strategy in self.withdrawalQueue:
996             if strategy == ZERO_ADDRESS:
997                 break  # We've exhausted the queue
998 
999             vault_balance: uint256 = self.token.balanceOf(self)
1000             if value <= vault_balance:
1001                 break  # We're done withdrawing
1002 
1003             amountNeeded: uint256 = value - vault_balance
1004 
1005             # NOTE: Don't withdraw more than the debt so that Strategy can still
1006             #       continue to work based on the profits it has
1007             # NOTE: This means that user will lose out on any profits that each
1008             #       Strategy in the queue would return on next harvest, benefiting others
1009             amountNeeded = min(amountNeeded, self.strategies[strategy].totalDebt)
1010             if amountNeeded == 0:
1011                 continue  # Nothing to withdraw from this Strategy, try the next one
1012 
1013             # Force withdraw amount from each Strategy in the order set by governance
1014             loss: uint256 = Strategy(strategy).withdraw(amountNeeded)
1015             withdrawn: uint256 = self.token.balanceOf(self) - vault_balance
1016 
1017             # NOTE: Withdrawer incurs any losses from liquidation
1018             if loss > 0:
1019                 value -= loss
1020                 totalLoss += loss
1021                 self.strategies[strategy].totalLoss += loss
1022 
1023             # Reduce the Strategy's debt by the amount withdrawn ("realized returns")
1024             # NOTE: This doesn't add to returns as it's not earned by "normal means"
1025             self.strategies[strategy].totalDebt -= withdrawn + loss
1026             self.totalDebt -= withdrawn + loss
1027 
1028     # NOTE: We have withdrawn everything possible out of the withdrawal queue
1029     #       but we still don't have enough to fully pay them back, so adjust
1030     #       to the total amount we've freed up through forced withdrawals
1031     vault_balance: uint256 = self.token.balanceOf(self)
1032     if value > vault_balance:
1033         value = vault_balance
1034         # NOTE: Burn # of shares that corresponds to what Vault has on-hand,
1035         #       including the losses that were incurred above during withdrawals
1036         shares = self._sharesForAmount(value + totalLoss)
1037 
1038     # NOTE: This loss protection is put in place to revert if losses from
1039     #       withdrawing are more than what is considered acceptable.
1040     assert totalLoss <= maxLoss * (value + totalLoss) / MAX_BPS
1041 
1042     # Burn shares (full value of what is being withdrawn)
1043     self.totalSupply -= shares
1044     self.balanceOf[msg.sender] -= shares
1045     log Transfer(msg.sender, ZERO_ADDRESS, shares)
1046 
1047     # Withdraw remaining balance to _recipient (may be different to msg.sender) (minus fee)
1048     self.erc20_safe_transfer(self.token.address, recipient, value)
1049 
1050     return value
1051 
1052 
1053 @view
1054 @external
1055 def pricePerShare() -> uint256:
1056     """
1057     @notice Gives the price for a single Vault share.
1058     @dev See dev note on `withdraw`.
1059     @return The value of a single share.
1060     """
1061     if self.totalSupply == 0:
1062         return 10 ** self.decimals  # price of 1:1
1063     else:
1064         return self._shareValue(10 ** self.decimals)
1065 
1066 
1067 @internal
1068 def _organizeWithdrawalQueue():
1069     # Reorganize `withdrawalQueue` based on premise that if there is an
1070     # empty value between two actual values, then the empty value should be
1071     # replaced by the later value.
1072     # NOTE: Relative ordering of non-zero values is maintained.
1073     offset: uint256 = 0
1074     for idx in range(MAXIMUM_STRATEGIES):
1075         strategy: address = self.withdrawalQueue[idx]
1076         if strategy == ZERO_ADDRESS:
1077             offset += 1  # how many values we need to shift, always `<= idx`
1078         elif offset > 0:
1079             self.withdrawalQueue[idx - offset] = strategy
1080             self.withdrawalQueue[idx] = ZERO_ADDRESS
1081 
1082 
1083 @external
1084 def addStrategy(
1085     strategy: address,
1086     debtRatio: uint256,
1087     minDebtPerHarvest: uint256,
1088     maxDebtPerHarvest: uint256,
1089     performanceFee: uint256,
1090 ):
1091     """
1092     @notice
1093         Add a Strategy to the Vault.
1094 
1095         This may only be called by governance.
1096     @dev
1097         The Strategy will be appended to `withdrawalQueue`, call
1098         `setWithdrawalQueue` to change the order.
1099     @param strategy The address of the Strategy to add.
1100     @param debtRatio
1101         The share of the total assets in the `vault that the `strategy` has access to.
1102     @param minDebtPerHarvest
1103         Lower limit on the increase of debt since last harvest
1104     @param maxDebtPerHarvest
1105         Upper limit on the increase of debt since last harvest
1106     @param performanceFee
1107         The fee the strategist will receive based on this Vault's performance.
1108     """
1109     # Check if queue is full
1110     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1111 
1112     # Check calling conditions
1113     assert not self.emergencyShutdown
1114     assert msg.sender == self.governance
1115 
1116     # Check strategy configuration
1117     assert strategy != ZERO_ADDRESS
1118     assert self.strategies[strategy].activation == 0
1119     assert self == Strategy(strategy).vault()
1120     assert self.token.address == Strategy(strategy).want()
1121 
1122     # Check strategy parameters
1123     assert self.debtRatio + debtRatio <= MAX_BPS
1124     assert minDebtPerHarvest <= maxDebtPerHarvest
1125     assert performanceFee <= MAX_BPS - self.performanceFee
1126 
1127     # Add strategy to approved strategies
1128     self.strategies[strategy] = StrategyParams({
1129         performanceFee: performanceFee,
1130         activation: block.timestamp,
1131         debtRatio: debtRatio,
1132         minDebtPerHarvest: minDebtPerHarvest,
1133         maxDebtPerHarvest: maxDebtPerHarvest,
1134         lastReport: block.timestamp,
1135         totalDebt: 0,
1136         totalGain: 0,
1137         totalLoss: 0,
1138     })
1139     log StrategyAdded(strategy, debtRatio, minDebtPerHarvest, maxDebtPerHarvest, performanceFee)
1140 
1141     # Update Vault parameters
1142     self.debtRatio += debtRatio
1143 
1144     # Add strategy to the end of the withdrawal queue
1145     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1146     self._organizeWithdrawalQueue()
1147 
1148 
1149 @external
1150 def updateStrategyDebtRatio(
1151     strategy: address,
1152     debtRatio: uint256,
1153 ):
1154     """
1155     @notice
1156         Change the quantity of assets `strategy` may manage.
1157 
1158         This may be called by governance or management.
1159     @param strategy The Strategy to update.
1160     @param debtRatio The quantity of assets `strategy` may now manage.
1161     """
1162     assert msg.sender in [self.management, self.governance]
1163     assert self.strategies[strategy].activation > 0
1164     self.debtRatio -= self.strategies[strategy].debtRatio
1165     self.strategies[strategy].debtRatio = debtRatio
1166     self.debtRatio += debtRatio
1167     assert self.debtRatio <= MAX_BPS
1168     log StrategyUpdateDebtRatio(strategy, debtRatio)
1169 
1170 
1171 @external
1172 def updateStrategyMinDebtPerHarvest(
1173     strategy: address,
1174     minDebtPerHarvest: uint256,
1175 ):
1176     """
1177     @notice
1178         Change the quantity assets per block this Vault may deposit to or
1179         withdraw from `strategy`.
1180 
1181         This may only be called by governance or management.
1182     @param strategy The Strategy to update.
1183     @param minDebtPerHarvest
1184         Lower limit on the increase of debt since last harvest
1185     """
1186     assert msg.sender in [self.management, self.governance]
1187     assert self.strategies[strategy].activation > 0
1188     assert self.strategies[strategy].maxDebtPerHarvest >= minDebtPerHarvest
1189     self.strategies[strategy].minDebtPerHarvest = minDebtPerHarvest
1190     log StrategyUpdateMinDebtPerHarvest(strategy, minDebtPerHarvest)
1191 
1192 
1193 @external
1194 def updateStrategyMaxDebtPerHarvest(
1195     strategy: address,
1196     maxDebtPerHarvest: uint256,
1197 ):
1198     """
1199     @notice
1200         Change the quantity assets per block this Vault may deposit to or
1201         withdraw from `strategy`.
1202 
1203         This may only be called by governance or management.
1204     @param strategy The Strategy to update.
1205     @param maxDebtPerHarvest
1206         Upper limit on the increase of debt since last harvest
1207     """
1208     assert msg.sender in [self.management, self.governance]
1209     assert self.strategies[strategy].activation > 0
1210     assert self.strategies[strategy].minDebtPerHarvest <= maxDebtPerHarvest
1211     self.strategies[strategy].maxDebtPerHarvest = maxDebtPerHarvest
1212     log StrategyUpdateMaxDebtPerHarvest(strategy, maxDebtPerHarvest)
1213 
1214 
1215 @external
1216 def updateStrategyPerformanceFee(
1217     strategy: address,
1218     performanceFee: uint256,
1219 ):
1220     """
1221     @notice
1222         Change the fee the strategist will receive based on this Vault's
1223         performance.
1224 
1225         This may only be called by governance.
1226     @param strategy The Strategy to update.
1227     @param performanceFee The new fee the strategist will receive.
1228     """
1229     assert msg.sender == self.governance
1230     assert performanceFee <= MAX_BPS - self.performanceFee
1231     assert self.strategies[strategy].activation > 0
1232     self.strategies[strategy].performanceFee = performanceFee
1233     log StrategyUpdatePerformanceFee(strategy, performanceFee)
1234 
1235 
1236 @internal
1237 def _revokeStrategy(strategy: address):
1238     self.debtRatio -= self.strategies[strategy].debtRatio
1239     self.strategies[strategy].debtRatio = 0
1240     log StrategyRevoked(strategy)
1241 
1242 
1243 @external
1244 def migrateStrategy(oldVersion: address, newVersion: address):
1245     """
1246     @notice
1247         Migrates a Strategy, including all assets from `oldVersion` to
1248         `newVersion`.
1249 
1250         This may only be called by governance.
1251     @dev
1252         Strategy must successfully migrate all capital and positions to new
1253         Strategy, or else this will upset the balance of the Vault.
1254 
1255         The new Strategy should be "empty" e.g. have no prior commitments to
1256         this Vault, otherwise it could have issues.
1257     @param oldVersion The existing Strategy to migrate from.
1258     @param newVersion The new Strategy to migrate to.
1259     """
1260     assert msg.sender == self.governance
1261     assert newVersion != ZERO_ADDRESS
1262     assert self.strategies[oldVersion].activation > 0
1263     assert self.strategies[newVersion].activation == 0
1264 
1265     strategy: StrategyParams = self.strategies[oldVersion]
1266 
1267     self._revokeStrategy(oldVersion)
1268     # _revokeStrategy will lower the debtRatio
1269     self.debtRatio += strategy.debtRatio
1270     # Debt is migrated to new strategy
1271     self.strategies[oldVersion].totalDebt = 0
1272 
1273     self.strategies[newVersion] = StrategyParams({
1274         performanceFee: strategy.performanceFee,
1275         # NOTE: use last report for activation time, so E[R] calc works
1276         activation: strategy.lastReport,
1277         debtRatio: strategy.debtRatio,
1278         minDebtPerHarvest: strategy.minDebtPerHarvest,
1279         maxDebtPerHarvest: strategy.maxDebtPerHarvest,
1280         lastReport: strategy.lastReport,
1281         totalDebt: strategy.totalDebt,
1282         totalGain: 0,
1283         totalLoss: 0,
1284     })
1285 
1286     Strategy(oldVersion).migrate(newVersion)
1287     log StrategyMigrated(oldVersion, newVersion)
1288 
1289     for idx in range(MAXIMUM_STRATEGIES):
1290         if self.withdrawalQueue[idx] == oldVersion:
1291             self.withdrawalQueue[idx] = newVersion
1292             return  # Don't need to reorder anything because we swapped
1293 
1294 
1295 @external
1296 def revokeStrategy(strategy: address = msg.sender):
1297     """
1298     @notice
1299         Revoke a Strategy, setting its debt limit to 0 and preventing any
1300         future deposits.
1301 
1302         This function should only be used in the scenario where the Strategy is
1303         being retired but no migration of the positions are possible, or in the
1304         extreme scenario that the Strategy needs to be put into "Emergency Exit"
1305         mode in order for it to exit as quickly as possible. The latter scenario
1306         could be for any reason that is considered "critical" that the Strategy
1307         exits its position as fast as possible, such as a sudden change in market
1308         conditions leading to losses, or an imminent failure in an external
1309         dependency.
1310 
1311         This may only be called by governance, the guardian, or the Strategy
1312         itself. Note that a Strategy will only revoke itself during emergency
1313         shutdown.
1314     @param strategy The Strategy to revoke.
1315     """
1316     assert msg.sender in [strategy, self.governance, self.guardian]
1317     self._revokeStrategy(strategy)
1318 
1319 
1320 @external
1321 def addStrategyToQueue(strategy: address):
1322     """
1323     @notice
1324         Adds `strategy` to `withdrawalQueue`.
1325 
1326         This may only be called by governance or management.
1327     @dev
1328         The Strategy will be appended to `withdrawalQueue`, call
1329         `setWithdrawalQueue` to change the order.
1330     @param strategy The Strategy to add.
1331     """
1332     assert msg.sender in [self.management, self.governance]
1333     # Must be a current Strategy
1334     assert self.strategies[strategy].activation > 0
1335     # Can't already be in the queue
1336     last_idx: uint256 = 0
1337     for s in self.withdrawalQueue:
1338         if s == ZERO_ADDRESS:
1339             break
1340         assert s != strategy
1341         last_idx += 1
1342     # Check if queue is full
1343     assert last_idx < MAXIMUM_STRATEGIES
1344         
1345     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1346     self._organizeWithdrawalQueue()
1347     log StrategyAddedToQueue(strategy)
1348 
1349 
1350 @external
1351 def removeStrategyFromQueue(strategy: address):
1352     """
1353     @notice
1354         Remove `strategy` from `withdrawalQueue`.
1355 
1356         This may only be called by governance or management.
1357     @dev
1358         We don't do this with revokeStrategy because it should still
1359         be possible to withdraw from the Strategy if it's unwinding.
1360     @param strategy The Strategy to remove.
1361     """
1362     assert msg.sender in [self.management, self.governance]
1363     for idx in range(MAXIMUM_STRATEGIES):
1364         if self.withdrawalQueue[idx] == strategy:
1365             self.withdrawalQueue[idx] = ZERO_ADDRESS
1366             self._organizeWithdrawalQueue()
1367             log StrategyRemovedFromQueue(strategy)
1368             return  # We found the right location and cleared it
1369     raise  # We didn't find the Strategy in the queue
1370 
1371 
1372 @view
1373 @internal
1374 def _debtOutstanding(strategy: address) -> uint256:
1375     # See note on `debtOutstanding()`.
1376     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * self._totalAssets() / MAX_BPS
1377     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1378 
1379     if self.emergencyShutdown:
1380         return strategy_totalDebt
1381     elif strategy_totalDebt <= strategy_debtLimit:
1382         return 0
1383     else:
1384         return strategy_totalDebt - strategy_debtLimit
1385 
1386 
1387 @view
1388 @external
1389 def debtOutstanding(strategy: address = msg.sender) -> uint256:
1390     """
1391     @notice
1392         Determines if `strategy` is past its debt limit and if any tokens
1393         should be withdrawn to the Vault.
1394     @param strategy The Strategy to check. Defaults to the caller.
1395     @return The quantity of tokens to withdraw.
1396     """
1397     return self._debtOutstanding(strategy)
1398 
1399 
1400 @view
1401 @internal
1402 def _creditAvailable(strategy: address) -> uint256:
1403     # See note on `creditAvailable()`.
1404     if self.emergencyShutdown:
1405         return 0
1406 
1407     vault_totalAssets: uint256 = self._totalAssets()
1408     vault_debtLimit: uint256 = self.debtRatio * vault_totalAssets / MAX_BPS
1409     vault_totalDebt: uint256 = self.totalDebt
1410     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * vault_totalAssets / MAX_BPS
1411     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1412     strategy_minDebtPerHarvest: uint256 = self.strategies[strategy].minDebtPerHarvest
1413     strategy_maxDebtPerHarvest: uint256 = self.strategies[strategy].maxDebtPerHarvest
1414 
1415     # Exhausted credit line
1416     if strategy_debtLimit <= strategy_totalDebt or vault_debtLimit <= vault_totalDebt:
1417         return 0
1418 
1419     # Start with debt limit left for the Strategy
1420     available: uint256 = strategy_debtLimit - strategy_totalDebt
1421 
1422     # Adjust by the global debt limit left
1423     available = min(available, vault_debtLimit - vault_totalDebt)
1424 
1425     # Can only borrow up to what the contract has in reserve
1426     # NOTE: Running near 100% is discouraged
1427     available = min(available, self.token.balanceOf(self))
1428 
1429     # Adjust by min and max borrow limits (per harvest)
1430     # NOTE: min increase can be used to ensure that if a strategy has a minimum
1431     #       amount of capital needed to purchase a position, it's not given capital
1432     #       it can't make use of yet.
1433     # NOTE: max increase is used to make sure each harvest isn't bigger than what
1434     #       is authorized. This combined with adjusting min and max periods in
1435     #       `BaseStrategy` can be used to effect a "rate limit" on capital increase.
1436     if available < strategy_minDebtPerHarvest:
1437         return 0
1438     else:
1439         return min(available, strategy_maxDebtPerHarvest)
1440 
1441 @view
1442 @external
1443 def creditAvailable(strategy: address = msg.sender) -> uint256:
1444     """
1445     @notice
1446         Amount of tokens in Vault a Strategy has access to as a credit line.
1447 
1448         This will check the Strategy's debt limit, as well as the tokens
1449         available in the Vault, and determine the maximum amount of tokens
1450         (if any) the Strategy may draw on.
1451 
1452         In the rare case the Vault is in emergency shutdown this will return 0.
1453     @param strategy The Strategy to check. Defaults to caller.
1454     @return The quantity of tokens available for the Strategy to draw on.
1455     """
1456     return self._creditAvailable(strategy)
1457 
1458 
1459 @view
1460 @internal
1461 def _expectedReturn(strategy: address) -> uint256:
1462     # See note on `expectedReturn()`.
1463     strategy_lastReport: uint256 = self.strategies[strategy].lastReport
1464     timeSinceLastHarvest: uint256 = block.timestamp - strategy_lastReport
1465     totalHarvestTime: uint256 = strategy_lastReport - self.strategies[strategy].activation
1466 
1467     # NOTE: If either `timeSinceLastHarvest` or `totalHarvestTime` is 0, we can short-circuit to `0`
1468     if timeSinceLastHarvest > 0 and totalHarvestTime > 0 and Strategy(strategy).isActive():
1469         # NOTE: Unlikely to throw unless strategy accumalates >1e68 returns
1470         # NOTE: Calculate average over period of time where harvests have occured in the past
1471         return (self.strategies[strategy].totalGain * timeSinceLastHarvest) / totalHarvestTime
1472     else:
1473         return 0  # Covers the scenario when block.timestamp == activation
1474 
1475 
1476 @view
1477 @external
1478 def availableDepositLimit() -> uint256:
1479     if self.depositLimit > self._totalAssets():
1480         return self.depositLimit - self._totalAssets()
1481     else:
1482         return 0
1483 
1484 
1485 @view
1486 @external
1487 def expectedReturn(strategy: address = msg.sender) -> uint256:
1488     """
1489     @notice
1490         Provide an accurate expected value for the return this `strategy`
1491         would provide to the Vault the next time `report()` is called
1492         (since the last time it was called).
1493     @param strategy The Strategy to determine the expected return for. Defaults to caller.
1494     @return
1495         The anticipated amount `strategy` should make on its investment
1496         since its last report.
1497     """
1498     return self._expectedReturn(strategy)
1499 
1500 
1501 @internal
1502 def _reportLoss(strategy: address, loss: uint256):
1503     # Loss can only be up the amount of debt issued to strategy
1504     totalDebt: uint256 = self.strategies[strategy].totalDebt
1505     assert totalDebt >= loss
1506     self.strategies[strategy].totalLoss += loss
1507     self.strategies[strategy].totalDebt = totalDebt - loss
1508     self.totalDebt -= loss
1509 
1510     # Also, make sure we reduce our trust with the strategy by the same amount
1511     debtRatio: uint256 = self.strategies[strategy].debtRatio
1512     ratio_change: uint256 = min(loss * MAX_BPS / self._totalAssets(), debtRatio)
1513     self.strategies[strategy].debtRatio -= ratio_change 
1514     self.debtRatio -= ratio_change
1515 
1516 @internal
1517 def _assessFees(strategy: address, gain: uint256):
1518     # Issue new shares to cover fees
1519     # NOTE: In effect, this reduces overall share price by the combined fee
1520     # NOTE: may throw if Vault.totalAssets() > 1e64, or not called for more than a year
1521     governance_fee: uint256 = (
1522         (self.totalDebt * (block.timestamp - self.lastReport) * self.managementFee)
1523         / MAX_BPS
1524         / SECS_PER_YEAR
1525     )
1526     strategist_fee: uint256 = 0  # Only applies in certain conditions
1527 
1528     # NOTE: Applies if Strategy is not shutting down, or it is but all debt paid off
1529     # NOTE: No fee is taken when a Strategy is unwinding it's position, until all debt is paid
1530     if gain > 0:
1531         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1532         strategist_fee = (
1533             gain * self.strategies[strategy].performanceFee
1534         ) / MAX_BPS
1535         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1536         governance_fee += gain * self.performanceFee / MAX_BPS
1537 
1538     # NOTE: This must be called prior to taking new collateral,
1539     #       or the calculation will be wrong!
1540     # NOTE: This must be done at the same time, to ensure the relative
1541     #       ratio of governance_fee : strategist_fee is kept intact
1542     total_fee: uint256 = governance_fee + strategist_fee
1543     if total_fee > 0:  # NOTE: If mgmt fee is 0% and no gains were realized, skip
1544         reward: uint256 = self._issueSharesForAmount(self, total_fee)
1545 
1546         # Send the rewards out as new shares in this Vault
1547         if strategist_fee > 0:  # NOTE: Guard against DIV/0 fault
1548             # NOTE: Unlikely to throw unless sqrt(reward) >>> 1e39
1549             strategist_reward: uint256 = (strategist_fee * reward) / total_fee
1550             self._transfer(self, strategy, strategist_reward)
1551             # NOTE: Strategy distributes rewards at the end of harvest()
1552         # NOTE: Governance earns any dust leftover from flooring math above
1553         if self.balanceOf[self] > 0:
1554             self._transfer(self, self.rewards, self.balanceOf[self])
1555 
1556 
1557 @external
1558 def report(gain: uint256, loss: uint256, _debtPayment: uint256) -> uint256:
1559     """
1560     @notice
1561         Reports the amount of assets the calling Strategy has free (usually in
1562         terms of ROI).
1563 
1564         The performance fee is determined here, off of the strategy's profits
1565         (if any), and sent to governance.
1566 
1567         The strategist's fee is also determined here (off of profits), to be
1568         handled according to the strategist on the next harvest.
1569 
1570         This may only be called by a Strategy managed by this Vault.
1571     @dev
1572         For approved strategies, this is the most efficient behavior.
1573         The Strategy reports back what it has free, then Vault "decides"
1574         whether to take some back or give it more. Note that the most it can
1575         take is `gain + _debtPayment`, and the most it can give is all of the
1576         remaining reserves. Anything outside of those bounds is abnormal behavior.
1577 
1578         All approved strategies must have increased diligence around
1579         calling this function, as abnormal behavior could become catastrophic.
1580     @param gain
1581         Amount Strategy has realized as a gain on it's investment since its
1582         last report, and is free to be given back to Vault as earnings
1583     @param loss
1584         Amount Strategy has realized as a loss on it's investment since its
1585         last report, and should be accounted for on the Vault's balance sheet
1586     @param _debtPayment
1587         Amount Strategy has made available to cover outstanding debt
1588     @return Amount of debt outstanding (if totalDebt > debtLimit or emergency shutdown).
1589     """
1590 
1591     # Only approved strategies can call this function
1592     assert self.strategies[msg.sender].activation > 0
1593     # No lying about total available to withdraw!
1594     assert self.token.balanceOf(msg.sender) >= gain + _debtPayment
1595 
1596     # We have a loss to report, do it before the rest of the calculations
1597     if loss > 0:
1598         self._reportLoss(msg.sender, loss)
1599 
1600     # Assess both management fee and performance fee, and issue both as shares of the vault
1601     self._assessFees(msg.sender, gain)
1602 
1603     # Returns are always "realized gains"
1604     self.strategies[msg.sender].totalGain += gain
1605 
1606     # Outstanding debt the Strategy wants to take back from the Vault (if any)
1607     # NOTE: debtOutstanding <= StrategyParams.totalDebt
1608     debt: uint256 = self._debtOutstanding(msg.sender)
1609     debtPayment: uint256 = min(_debtPayment, debt)
1610 
1611     if debtPayment > 0:
1612         self.strategies[msg.sender].totalDebt -= debtPayment
1613         self.totalDebt -= debtPayment
1614         debt -= debtPayment
1615         # NOTE: `debt` is being tracked for later
1616 
1617     # Compute the line of credit the Vault is able to offer the Strategy (if any)
1618     credit: uint256 = self._creditAvailable(msg.sender)
1619 
1620     # Update the actual debt based on the full credit we are extending to the Strategy
1621     # or the returns if we are taking funds back
1622     # NOTE: credit + self.strategies[msg.sender].totalDebt is always < self.debtLimit
1623     # NOTE: At least one of `credit` or `debt` is always 0 (both can be 0)
1624     if credit > 0:
1625         self.strategies[msg.sender].totalDebt += credit
1626         self.totalDebt += credit
1627 
1628     # Give/take balance to Strategy, based on the difference between the reported gains
1629     # (if any), the debt payment (if any), the credit increase we are offering (if any),
1630     # and the debt needed to be paid off (if any)
1631     # NOTE: This is just used to adjust the balance of tokens between the Strategy and
1632     #       the Vault based on the Strategy's debt limit (as well as the Vault's).
1633     totalAvail: uint256 = gain + debtPayment
1634     if totalAvail < credit:  # credit surplus, give to Strategy
1635         self.erc20_safe_transfer(self.token.address, msg.sender, credit - totalAvail)
1636     elif totalAvail > credit:  # credit deficit, take from Strategy
1637         self.erc20_safe_transferFrom(self.token.address, msg.sender, self, totalAvail - credit)
1638     # else, don't do anything because it is balanced
1639 
1640     # Update reporting time
1641     self.strategies[msg.sender].lastReport = block.timestamp
1642     self.lastReport = block.timestamp
1643     self.lockedProfit = gain # profit is locked and gradually released per block
1644 
1645     log StrategyReported(
1646         msg.sender,
1647         gain,
1648         loss,
1649         debtPayment,
1650         self.strategies[msg.sender].totalGain,
1651         self.strategies[msg.sender].totalLoss,
1652         self.strategies[msg.sender].totalDebt,
1653         credit,
1654         self.strategies[msg.sender].debtRatio,
1655     )
1656 
1657     if self.strategies[msg.sender].debtRatio == 0 or self.emergencyShutdown:
1658         # Take every last penny the Strategy has (Emergency Exit/revokeStrategy)
1659         # NOTE: This is different than `debt` in order to extract *all* of the returns
1660         return Strategy(msg.sender).estimatedTotalAssets()
1661     else:
1662         # Otherwise, just return what we have as debt outstanding
1663         return debt
1664 
1665 
1666 @external
1667 def sweep(token: address, amount: uint256 = MAX_UINT256):
1668     """
1669     @notice
1670         Removes tokens from this Vault that are not the type of token managed
1671         by this Vault. This may be used in case of accidentally sending the
1672         wrong kind of token to this Vault.
1673 
1674         Tokens will be sent to `governance`.
1675 
1676         This will fail if an attempt is made to sweep the tokens that this
1677         Vault manages.
1678 
1679         This may only be called by governance.
1680     @param token The token to transfer out of this vault.
1681     @param amount The quantity or tokenId to transfer out.
1682     """
1683     assert msg.sender == self.governance
1684     # Can't be used to steal what this Vault is protecting
1685     assert token != self.token.address
1686     value: uint256 = amount
1687     if value == MAX_UINT256:
1688         value = ERC20(token).balanceOf(self)
1689     self.erc20_safe_transfer(token, self.governance, value)