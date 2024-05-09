1 # @version 0.3.3
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
38 API_VERSION: constant(String[28]) = "0.4.5"
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
59     def emergencyExit() -> bool: view
60 
61 name: public(String[64])
62 symbol: public(String[32])
63 decimals: public(uint256)
64 
65 balanceOf: public(HashMap[address, uint256])
66 allowance: public(HashMap[address, HashMap[address, uint256]])
67 totalSupply: public(uint256)
68 
69 token: public(ERC20)
70 governance: public(address)
71 management: public(address)
72 guardian: public(address)
73 pendingGovernance: address
74 
75 struct StrategyParams:
76     performanceFee: uint256  # Strategist's fee (basis points)
77     activation: uint256  # Activation block.timestamp
78     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
79     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
80     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
81     lastReport: uint256  # block.timestamp of the last time a report occured
82     totalDebt: uint256  # Total outstanding debt that Strategy has
83     totalGain: uint256  # Total returns that Strategy has realized for Vault
84     totalLoss: uint256  # Total losses that Strategy has realized for Vault
85 
86 event Transfer:
87     sender: indexed(address)
88     receiver: indexed(address)
89     value: uint256
90 
91 
92 event Approval:
93     owner: indexed(address)
94     spender: indexed(address)
95     value: uint256
96 
97 event Deposit:
98     recipient: indexed(address)
99     shares: uint256
100     amount: uint256
101 
102 event Withdraw:
103     recipient: indexed(address)
104     shares: uint256
105     amount: uint256
106 
107 event Sweep:
108     token: indexed(address)
109     amount: uint256
110 
111 event LockedProfitDegradationUpdated:
112     value: uint256
113 
114 event StrategyAdded:
115     strategy: indexed(address)
116     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
117     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
118     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
119     performanceFee: uint256  # Strategist's fee (basis points)
120 
121 
122 event StrategyReported:
123     strategy: indexed(address)
124     gain: uint256
125     loss: uint256
126     debtPaid: uint256
127     totalGain: uint256
128     totalLoss: uint256
129     totalDebt: uint256
130     debtAdded: uint256
131     debtRatio: uint256
132 
133 event FeeReport:
134     management_fee: uint256
135     performance_fee: uint256
136     strategist_fee: uint256
137     duration: uint256
138 
139 event WithdrawFromStrategy:
140     strategy: indexed(address)
141     totalDebt: uint256
142     loss: uint256
143 
144 event UpdateGovernance:
145     governance: address # New active governance
146 
147 
148 event UpdateManagement:
149     management: address # New active manager
150 
151 event UpdateRewards:
152     rewards: address # New active rewards recipient
153 
154 
155 event UpdateDepositLimit:
156     depositLimit: uint256 # New active deposit limit
157 
158 
159 event UpdatePerformanceFee:
160     performanceFee: uint256 # New active performance fee
161 
162 
163 event UpdateManagementFee:
164     managementFee: uint256 # New active management fee
165 
166 
167 event UpdateGuardian:
168     guardian: address # Address of the active guardian
169 
170 
171 event EmergencyShutdown:
172     active: bool # New emergency shutdown state (if false, normal operation enabled)
173 
174 
175 event UpdateWithdrawalQueue:
176     queue: address[MAXIMUM_STRATEGIES] # New active withdrawal queue
177 
178 
179 event StrategyUpdateDebtRatio:
180     strategy: indexed(address) # Address of the strategy for the debt ratio adjustment
181     debtRatio: uint256 # The new debt limit for the strategy (in BPS of total assets)
182 
183 
184 event StrategyUpdateMinDebtPerHarvest:
185     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
186     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
187 
188 
189 event StrategyUpdateMaxDebtPerHarvest:
190     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
191     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
192 
193 
194 event StrategyUpdatePerformanceFee:
195     strategy: indexed(address) # Address of the strategy for the performance fee adjustment
196     performanceFee: uint256 # The new performance fee for the strategy
197 
198 
199 event StrategyMigrated:
200     oldVersion: indexed(address) # Old version of the strategy to be migrated
201     newVersion: indexed(address) # New version of the strategy
202 
203 
204 event StrategyRevoked:
205     strategy: indexed(address) # Address of the strategy that is revoked
206 
207 
208 event StrategyRemovedFromQueue:
209     strategy: indexed(address) # Address of the strategy that is removed from the withdrawal queue
210 
211 
212 event StrategyAddedToQueue:
213     strategy: indexed(address) # Address of the strategy that is added to the withdrawal queue
214 
215 event NewPendingGovernance:
216     pendingGovernance: indexed(address)
217 
218 # NOTE: Track the total for overhead targeting purposes
219 strategies: public(HashMap[address, StrategyParams])
220 MAXIMUM_STRATEGIES: constant(uint256) = 20
221 DEGRADATION_COEFFICIENT: constant(uint256) = 10 ** 18
222 
223 # Ordering that `withdraw` uses to determine which strategies to pull funds from
224 # NOTE: Does *NOT* have to match the ordering of all the current strategies that
225 #       exist, but it is recommended that it does or else withdrawal depth is
226 #       limited to only those inside the queue.
227 # NOTE: Ordering is determined by governance, and should be balanced according
228 #       to risk, slippage, and/or volatility. Can also be ordered to increase the
229 #       withdrawal speed of a particular Strategy.
230 # NOTE: The first time a ZERO_ADDRESS is encountered, it stops withdrawing
231 withdrawalQueue: public(address[MAXIMUM_STRATEGIES])
232 
233 emergencyShutdown: public(bool)
234 
235 depositLimit: public(uint256)  # Limit for totalAssets the Vault can hold
236 debtRatio: public(uint256)  # Debt ratio for the Vault across all strategies (in BPS, <= 10k)
237 totalIdle: public(uint256)  # Amount of tokens that are in the vault
238 totalDebt: public(uint256)  # Amount of tokens that all strategies have borrowed
239 lastReport: public(uint256)  # block.timestamp of last report
240 activation: public(uint256)  # block.timestamp of contract deployment
241 lockedProfit: public(uint256) # how much profit is locked and cant be withdrawn
242 lockedProfitDegradation: public(uint256) # rate per block of degradation. DEGRADATION_COEFFICIENT is 100% per block
243 rewards: public(address)  # Rewards contract where Governance fees are sent to
244 # Governance Fee for management of Vault (given to `rewards`)
245 managementFee: public(uint256)
246 # Governance Fee for performance of Vault (given to `rewards`)
247 performanceFee: public(uint256)
248 MAX_BPS: constant(uint256) = 10_000  # 100%, or 10k basis points
249 # NOTE: A four-century period will be missing 3 of its 100 Julian leap years, leaving 97.
250 #       So the average year has 365 + 97/400 = 365.2425 days
251 #       ERROR(Julian): -0.0078
252 #       ERROR(Gregorian): -0.0003
253 #       A day = 24 * 60 * 60 sec = 86400 sec
254 #       365.2425 * 86400 = 31556952.0
255 SECS_PER_YEAR: constant(uint256) = 31_556_952  # 365.2425 days
256 # `nonces` track `permit` approvals with signature.
257 nonces: public(HashMap[address, uint256])
258 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
259 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
260 
261 
262 @external
263 def initialize(
264     token: address,
265     governance: address,
266     rewards: address,
267     nameOverride: String[64],
268     symbolOverride: String[32],
269     guardian: address = msg.sender,
270     management: address =  msg.sender,
271 ):
272     """
273     @notice
274         Initializes the Vault, this is called only once, when the contract is
275         deployed.
276         The performance fee is set to 10% of yield, per Strategy.
277         The management fee is set to 2%, per year.
278         The initial deposit limit is set to 0 (deposits disabled); it must be
279         updated after initialization.
280     @dev
281         If `nameOverride` is not specified, the name will be 'yearn'
282         combined with the name of `token`.
283 
284         If `symbolOverride` is not specified, the symbol will be 'yv'
285         combined with the symbol of `token`.
286 
287         The token used by the vault should not change balances outside transfers and 
288         it must transfer the exact amount requested. Fee on transfer and rebasing are not supported.
289     @param token The token that may be deposited into this Vault.
290     @param governance The address authorized for governance interactions.
291     @param rewards The address to distribute rewards to.
292     @param management The address of the vault manager.
293     @param nameOverride Specify a custom Vault name. Leave empty for default choice.
294     @param symbolOverride Specify a custom Vault symbol name. Leave empty for default choice.
295     @param guardian The address authorized for guardian interactions. Defaults to caller.
296     """
297     assert self.activation == 0  # dev: no devops199
298     self.token = ERC20(token)
299     if nameOverride == "":
300         self.name = concat(DetailedERC20(token).symbol(), " yVault")
301     else:
302         self.name = nameOverride
303     if symbolOverride == "":
304         self.symbol = concat("yv", DetailedERC20(token).symbol())
305     else:
306         self.symbol = symbolOverride
307     decimals: uint256 = DetailedERC20(token).decimals()
308     self.decimals = decimals
309     assert decimals < 256 # dev: see VVE-2020-0001
310 
311     self.governance = governance
312     log UpdateGovernance(governance)
313     self.management = management
314     log UpdateManagement(management)
315     self.rewards = rewards
316     log UpdateRewards(rewards)
317     self.guardian = guardian
318     log UpdateGuardian(guardian)
319     self.performanceFee = 1000  # 10% of yield (per Strategy)
320     log UpdatePerformanceFee(convert(1000, uint256))
321     self.managementFee = 200  # 2% per year
322     log UpdateManagementFee(convert(200, uint256))
323     self.lastReport = block.timestamp
324     self.activation = block.timestamp
325     self.lockedProfitDegradation = convert(DEGRADATION_COEFFICIENT * 46 / 10 ** 6 , uint256) # 6 hours in blocks
326     # EIP-712
327 
328 
329 @pure
330 @external
331 def apiVersion() -> String[28]:
332     """
333     @notice
334         Used to track the deployed version of this contract. In practice you
335         can use this version number to compare with Yearn's GitHub and
336         determine which version of the source matches this deployed contract.
337     @dev
338         All strategies must have an `apiVersion()` that matches the Vault's
339         `API_VERSION`.
340     @return API_VERSION which holds the current version of this contract.
341     """
342     return API_VERSION
343 
344 @view
345 @internal
346 def domain_separator() -> bytes32:
347     return keccak256(
348         concat(
349             DOMAIN_TYPE_HASH,
350             keccak256(convert("Yearn Vault", Bytes[11])),
351             keccak256(convert(API_VERSION, Bytes[28])),
352             convert(chain.id, bytes32),
353             convert(self, bytes32)
354         )
355     )
356 
357 @view
358 @external
359 def DOMAIN_SEPARATOR() -> bytes32:
360     return self.domain_separator()
361 
362 @external
363 def setName(name: String[42]):
364     """
365     @notice
366         Used to change the value of `name`.
367 
368         This may only be called by governance.
369     @param name The new name to use.
370     """
371     assert msg.sender == self.governance
372     self.name = name
373 
374 
375 @external
376 def setSymbol(symbol: String[20]):
377     """
378     @notice
379         Used to change the value of `symbol`.
380 
381         This may only be called by governance.
382     @param symbol The new symbol to use.
383     """
384     assert msg.sender == self.governance
385     self.symbol = symbol
386 
387 
388 # 2-phase commit for a change in governance
389 @external
390 def setGovernance(governance: address):
391     """
392     @notice
393         Nominate a new address to use as governance.
394 
395         The change does not go into effect immediately. This function sets a
396         pending change, and the governance address is not updated until
397         the proposed governance address has accepted the responsibility.
398 
399         This may only be called by the current governance address.
400     @param governance The address requested to take over Vault governance.
401     """
402     assert msg.sender == self.governance
403     log NewPendingGovernance(governance)
404     self.pendingGovernance = governance
405 
406 
407 @external
408 def acceptGovernance():
409     """
410     @notice
411         Once a new governance address has been proposed using setGovernance(),
412         this function may be called by the proposed address to accept the
413         responsibility of taking over governance for this contract.
414 
415         This may only be called by the proposed governance address.
416     @dev
417         setGovernance() should be called by the existing governance address,
418         prior to calling this function.
419     """
420     assert msg.sender == self.pendingGovernance
421     self.governance = msg.sender
422     log UpdateGovernance(msg.sender)
423 
424 
425 @external
426 def setManagement(management: address):
427     """
428     @notice
429         Changes the management address.
430         Management is able to make some investment decisions adjusting parameters.
431 
432         This may only be called by governance.
433     @param management The address to use for managing.
434     """
435     assert msg.sender == self.governance
436     self.management = management
437     log UpdateManagement(management)
438 
439 
440 @external
441 def setRewards(rewards: address):
442     """
443     @notice
444         Changes the rewards address. Any distributed rewards
445         will cease flowing to the old address and begin flowing
446         to this address once the change is in effect.
447 
448         This will not change any Strategy reports in progress, only
449         new reports made after this change goes into effect.
450 
451         This may only be called by governance.
452     @param rewards The address to use for collecting rewards.
453     """
454     assert msg.sender == self.governance
455     assert not (rewards in [self, ZERO_ADDRESS])
456     self.rewards = rewards
457     log UpdateRewards(rewards)
458 
459 
460 @external
461 def setLockedProfitDegradation(degradation: uint256):
462     """
463     @notice
464         Changes the locked profit degradation.
465     @param degradation The rate of degradation in percent per second scaled to 1e18.
466     """
467     assert msg.sender == self.governance
468     # Since "degradation" is of type uint256 it can never be less than zero
469     assert degradation <= DEGRADATION_COEFFICIENT
470     self.lockedProfitDegradation = degradation
471     log LockedProfitDegradationUpdated(degradation) 
472 
473 
474 @external
475 def setDepositLimit(limit: uint256):
476     """
477     @notice
478         Changes the maximum amount of tokens that can be deposited in this Vault.
479 
480         Note, this is not how much may be deposited by a single depositor,
481         but the maximum amount that may be deposited across all depositors.
482 
483         This may only be called by governance.
484     @param limit The new deposit limit to use.
485     """
486     assert msg.sender == self.governance
487     self.depositLimit = limit
488     log UpdateDepositLimit(limit)
489 
490 
491 @external
492 def setPerformanceFee(fee: uint256):
493     """
494     @notice
495         Used to change the value of `performanceFee`.
496 
497         Should set this value below the maximum strategist performance fee.
498 
499         This may only be called by governance.
500     @param fee The new performance fee to use.
501     """
502     assert msg.sender == self.governance
503     assert fee <= MAX_BPS / 2
504     self.performanceFee = fee
505     log UpdatePerformanceFee(fee)
506 
507 
508 @external
509 def setManagementFee(fee: uint256):
510     """
511     @notice
512         Used to change the value of `managementFee`.
513 
514         This may only be called by governance.
515     @param fee The new management fee to use.
516     """
517     assert msg.sender == self.governance
518     assert fee <= MAX_BPS
519     self.managementFee = fee
520     log UpdateManagementFee(fee)
521 
522 
523 @external
524 def setGuardian(guardian: address):
525     """
526     @notice
527         Used to change the address of `guardian`.
528 
529         This may only be called by governance or the existing guardian.
530     @param guardian The new guardian address to use.
531     """
532     assert msg.sender in [self.guardian, self.governance]
533     self.guardian = guardian
534     log UpdateGuardian(guardian)
535 
536 
537 @external
538 def setEmergencyShutdown(active: bool):
539     """
540     @notice
541         Activates or deactivates Vault mode where all Strategies go into full
542         withdrawal.
543 
544         During Emergency Shutdown:
545         1. No Users may deposit into the Vault (but may withdraw as usual.)
546         2. Governance may not add new Strategies.
547         3. Each Strategy must pay back their debt as quickly as reasonable to
548             minimally affect their position.
549         4. Only Governance may undo Emergency Shutdown.
550 
551         See contract level note for further details.
552 
553         This may only be called by governance or the guardian.
554     @param active
555         If true, the Vault goes into Emergency Shutdown. If false, the Vault
556         goes back into Normal Operation.
557     """
558     if active:
559         assert msg.sender in [self.guardian, self.governance]
560     else:
561         assert msg.sender == self.governance
562     self.emergencyShutdown = active
563     log EmergencyShutdown(active)
564 
565 
566 @external
567 def setWithdrawalQueue(queue: address[MAXIMUM_STRATEGIES]):
568     """
569     @notice
570         Updates the withdrawalQueue to match the addresses and order specified
571         by `queue`.
572 
573         There can be fewer strategies than the maximum, as well as fewer than
574         the total number of strategies active in the vault. `withdrawalQueue`
575         will be updated in a gas-efficient manner, assuming the input is well-
576         ordered with 0x0 only at the end.
577 
578         This may only be called by governance or management.
579     @dev
580         This is order sensitive, specify the addresses in the order in which
581         funds should be withdrawn (so `queue`[0] is the first Strategy withdrawn
582         from, `queue`[1] is the second, etc.)
583 
584         This means that the least impactful Strategy (the Strategy that will have
585         its core positions impacted the least by having funds removed) should be
586         at `queue`[0], then the next least impactful at `queue`[1], and so on.
587     @param queue
588         The array of addresses to use as the new withdrawal queue. This is
589         order sensitive.
590     """
591     assert msg.sender in [self.management, self.governance]
592 
593     # HACK: Temporary until Vyper adds support for Dynamic arrays
594     old_queue: address[MAXIMUM_STRATEGIES] = empty(address[MAXIMUM_STRATEGIES])
595     for i in range(MAXIMUM_STRATEGIES):
596         old_queue[i] = self.withdrawalQueue[i] 
597         if queue[i] == ZERO_ADDRESS:
598             # NOTE: Cannot use this method to remove entries from the queue
599             assert old_queue[i] == ZERO_ADDRESS
600             break
601         # NOTE: Cannot use this method to add more entries to the queue
602         assert old_queue[i] != ZERO_ADDRESS
603 
604         assert self.strategies[queue[i]].activation > 0
605 
606         existsInOldQueue: bool = False
607         for j in range(MAXIMUM_STRATEGIES):
608             if queue[j] == ZERO_ADDRESS:
609                 existsInOldQueue = True
610                 break
611             if queue[i] == old_queue[j]:
612                 # NOTE: Ensure that every entry in queue prior to reordering exists now
613                 existsInOldQueue = True
614 
615             if j <= i:
616                 # NOTE: This will only check for duplicate entries in queue after `i`
617                 continue
618             assert queue[i] != queue[j]  # dev: do not add duplicate strategies
619 
620         assert existsInOldQueue # dev: do not add new strategies
621 
622         self.withdrawalQueue[i] = queue[i]
623     log UpdateWithdrawalQueue(queue)
624 
625 
626 @internal
627 def erc20_safe_transfer(token: address, receiver: address, amount: uint256):
628     # Used only to send tokens that are not the type managed by this Vault.
629     # HACK: Used to handle non-compliant tokens like USDT
630     response: Bytes[32] = raw_call(
631         token,
632         concat(
633             method_id("transfer(address,uint256)"),
634             convert(receiver, bytes32),
635             convert(amount, bytes32),
636         ),
637         max_outsize=32,
638     )
639     if len(response) > 0:
640         assert convert(response, bool), "Transfer failed!"
641 
642 
643 @internal
644 def erc20_safe_transferFrom(token: address, sender: address, receiver: address, amount: uint256):
645     # Used only to send tokens that are not the type managed by this Vault.
646     # HACK: Used to handle non-compliant tokens like USDT
647     response: Bytes[32] = raw_call(
648         token,
649         concat(
650             method_id("transferFrom(address,address,uint256)"),
651             convert(sender, bytes32),
652             convert(receiver, bytes32),
653             convert(amount, bytes32),
654         ),
655         max_outsize=32,
656     )
657     if len(response) > 0:
658         assert convert(response, bool), "Transfer failed!"
659 
660 
661 @internal
662 def _transfer(sender: address, receiver: address, amount: uint256):
663     # See note on `transfer()`.
664 
665     # Protect people from accidentally sending their shares to bad places
666     assert receiver not in [self, ZERO_ADDRESS]
667     self.balanceOf[sender] -= amount
668     self.balanceOf[receiver] += amount
669     log Transfer(sender, receiver, amount)
670 
671 
672 @external
673 def transfer(receiver: address, amount: uint256) -> bool:
674     """
675     @notice
676         Transfers shares from the caller's address to `receiver`. This function
677         will always return true, unless the user is attempting to transfer
678         shares to this contract's address, or to 0x0.
679     @param receiver
680         The address shares are being transferred to. Must not be this contract's
681         address, must not be 0x0.
682     @param amount The quantity of shares to transfer.
683     @return
684         True if transfer is sent to an address other than this contract's or
685         0x0, otherwise the transaction will fail.
686     """
687     self._transfer(msg.sender, receiver, amount)
688     return True
689 
690 
691 @external
692 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
693     """
694     @notice
695         Transfers `amount` shares from `sender` to `receiver`. This operation will
696         always return true, unless the user is attempting to transfer shares
697         to this contract's address, or to 0x0.
698 
699         Unless the caller has given this contract unlimited approval,
700         transfering shares will decrement the caller's `allowance` by `amount`.
701     @param sender The address shares are being transferred from.
702     @param receiver
703         The address shares are being transferred to. Must not be this contract's
704         address, must not be 0x0.
705     @param amount The quantity of shares to transfer.
706     @return
707         True if transfer is sent to an address other than this contract's or
708         0x0, otherwise the transaction will fail.
709     """
710     # Unlimited approval (saves an SSTORE)
711     if (self.allowance[sender][msg.sender] < MAX_UINT256):
712         allowance: uint256 = self.allowance[sender][msg.sender] - amount
713         self.allowance[sender][msg.sender] = allowance
714         # NOTE: Allows log filters to have a full accounting of allowance changes
715         log Approval(sender, msg.sender, allowance)
716     self._transfer(sender, receiver, amount)
717     return True
718 
719 
720 @external
721 def approve(spender: address, amount: uint256) -> bool:
722     """
723     @dev Approve the passed address to spend the specified amount of tokens on behalf of
724          `msg.sender`. Beware that changing an allowance with this method brings the risk
725          that someone may use both the old and the new allowance by unfortunate transaction
726          ordering. See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
727     @param spender The address which will spend the funds.
728     @param amount The amount of tokens to be spent.
729     """
730     self.allowance[msg.sender][spender] = amount
731     log Approval(msg.sender, spender, amount)
732     return True
733 
734 
735 @external
736 def increaseAllowance(spender: address, amount: uint256) -> bool:
737     """
738     @dev Increase the allowance of the passed address to spend the total amount of tokens
739          on behalf of msg.sender. This method mitigates the risk that someone may use both
740          the old and the new allowance by unfortunate transaction ordering.
741          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
742     @param spender The address which will spend the funds.
743     @param amount The amount of tokens to increase the allowance by.
744     """
745     self.allowance[msg.sender][spender] += amount
746     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
747     return True
748 
749 
750 @external
751 def decreaseAllowance(spender: address, amount: uint256) -> bool:
752     """
753     @dev Decrease the allowance of the passed address to spend the total amount of tokens
754          on behalf of msg.sender. This method mitigates the risk that someone may use both
755          the old and the new allowance by unfortunate transaction ordering.
756          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
757     @param spender The address which will spend the funds.
758     @param amount The amount of tokens to decrease the allowance by.
759     """
760     self.allowance[msg.sender][spender] -= amount
761     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
762     return True
763 
764 
765 @external
766 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
767     """
768     @notice
769         Approves spender by owner's signature to expend owner's tokens.
770         See https://eips.ethereum.org/EIPS/eip-2612.
771 
772     @param owner The address which is a source of funds and has signed the Permit.
773     @param spender The address which is allowed to spend the funds.
774     @param amount The amount of tokens to be spent.
775     @param expiry The timestamp after which the Permit is no longer valid.
776     @param signature A valid secp256k1 signature of Permit by owner encoded as r, s, v.
777     @return True, if transaction completes successfully
778     """
779     assert owner != ZERO_ADDRESS  # dev: invalid owner
780     assert expiry >= block.timestamp  # dev: permit expired
781     nonce: uint256 = self.nonces[owner]
782     digest: bytes32 = keccak256(
783         concat(
784             b'\x19\x01',
785             self.domain_separator(),
786             keccak256(
787                 concat(
788                     PERMIT_TYPE_HASH,
789                     convert(owner, bytes32),
790                     convert(spender, bytes32),
791                     convert(amount, bytes32),
792                     convert(nonce, bytes32),
793                     convert(expiry, bytes32),
794                 )
795             )
796         )
797     )
798     # NOTE: signature is packed as r, s, v
799     r: uint256 = convert(slice(signature, 0, 32), uint256)
800     s: uint256 = convert(slice(signature, 32, 32), uint256)
801     v: uint256 = convert(slice(signature, 64, 1), uint256)
802     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
803     self.allowance[owner][spender] = amount
804     self.nonces[owner] = nonce + 1
805     log Approval(owner, spender, amount)
806     return True
807 
808 
809 @view
810 @internal
811 def _totalAssets() -> uint256:
812     # See note on `totalAssets()`.
813     return self.totalIdle + self.totalDebt
814 
815 
816 @view
817 @external
818 def totalAssets() -> uint256:
819     """
820     @notice
821         Returns the total quantity of all assets under control of this
822         Vault, whether they're loaned out to a Strategy, or currently held in
823         the Vault.
824     @return The total assets under control of this Vault.
825     """
826     return self._totalAssets()
827 
828 
829 @view
830 @internal
831 def _calculateLockedProfit() -> uint256:
832     lockedFundsRatio: uint256 = (block.timestamp - self.lastReport) * self.lockedProfitDegradation
833 
834     if(lockedFundsRatio < DEGRADATION_COEFFICIENT):
835         lockedProfit: uint256 = self.lockedProfit
836         return lockedProfit - (
837                 lockedFundsRatio
838                 * lockedProfit
839                 / DEGRADATION_COEFFICIENT
840             )
841     else:        
842         return 0
843 
844 @view
845 @internal
846 def _freeFunds() -> uint256:
847     return self._totalAssets() - self._calculateLockedProfit()
848 
849 @internal
850 def _issueSharesForAmount(to: address, amount: uint256) -> uint256:
851     # Issues `amount` Vault shares to `to`.
852     # Shares must be issued prior to taking on new collateral, or
853     # calculation will be wrong. This means that only *trusted* tokens
854     # (with no capability for exploitative behavior) can be used.
855     shares: uint256 = 0
856     # HACK: Saves 2 SLOADs (~200 gas, post-Berlin)
857     totalSupply: uint256 = self.totalSupply
858     if totalSupply > 0:
859         # Mint amount of shares based on what the Vault is managing overall
860         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
861         shares =  amount * totalSupply / self._freeFunds()  # dev: no free funds
862     else:
863         # No existing shares, so mint 1:1
864         shares = amount
865     assert shares != 0 # dev: division rounding resulted in zero
866 
867     # Mint new shares
868     self.totalSupply = totalSupply + shares
869     self.balanceOf[to] += shares
870     log Transfer(ZERO_ADDRESS, to, shares)
871 
872     return shares
873 
874 
875 @external
876 @nonreentrant("withdraw")
877 def deposit(_amount: uint256 = MAX_UINT256, recipient: address = msg.sender) -> uint256:
878     """
879     @notice
880         Deposits `_amount` `token`, issuing shares to `recipient`. If the
881         Vault is in Emergency Shutdown, deposits will not be accepted and this
882         call will fail.
883     @dev
884         Measuring quantity of shares to issues is based on the total
885         outstanding debt that this contract has ("expected value") instead
886         of the total balance sheet it has ("estimated value") has important
887         security considerations, and is done intentionally. If this value were
888         measured against external systems, it could be purposely manipulated by
889         an attacker to withdraw more assets than they otherwise should be able
890         to claim by redeeming their shares.
891 
892         On deposit, this means that shares are issued against the total amount
893         that the deposited capital can be given in service of the debt that
894         Strategies assume. If that number were to be lower than the "expected
895         value" at some future point, depositing shares via this method could
896         entitle the depositor to *less* than the deposited value once the
897         "realized value" is updated from further reports by the Strategies
898         to the Vaults.
899 
900         Care should be taken by integrators to account for this discrepancy,
901         by using the view-only methods of this contract (both off-chain and
902         on-chain) to determine if depositing into the Vault is a "good idea".
903     @param _amount The quantity of tokens to deposit, defaults to all.
904     @param recipient
905         The address to issue the shares in this Vault to. Defaults to the
906         caller's address.
907     @return The issued Vault shares.
908     """
909     assert not self.emergencyShutdown  # Deposits are locked out
910     assert recipient not in [self, ZERO_ADDRESS]
911 
912     amount: uint256 = _amount
913 
914     # If _amount not specified, transfer the full token balance,
915     # up to deposit limit
916     if amount == MAX_UINT256:
917         amount = min(
918             self.depositLimit - self._totalAssets(),
919             self.token.balanceOf(msg.sender),
920         )
921     else:
922         # Ensure deposit limit is respected
923         assert self._totalAssets() + amount <= self.depositLimit
924 
925     # Ensure we are depositing something
926     assert amount > 0
927 
928     # Issue new shares (needs to be done before taking deposit to be accurate)
929     # Shares are issued to recipient (may be different from msg.sender)
930     # See @dev note, above.
931     shares: uint256 = self._issueSharesForAmount(recipient, amount)
932 
933     # Tokens are transferred from msg.sender (may be different from _recipient)
934     self.erc20_safe_transferFrom(self.token.address, msg.sender, self, amount)
935     self.totalIdle += amount
936 
937     log Deposit(recipient, shares, amount)
938 
939     return shares  # Just in case someone wants them
940 
941 
942 @view
943 @internal
944 def _shareValue(shares: uint256) -> uint256:
945     # Returns price = 1:1 if vault is empty
946     if self.totalSupply == 0:
947         return shares
948 
949     # Determines the current value of `shares`.
950     # NOTE: if sqrt(Vault.totalAssets()) >>> 1e39, this could potentially revert
951 
952     return (
953         shares
954         * self._freeFunds()
955         / self.totalSupply
956     )
957 
958 
959 @view
960 @internal
961 def _sharesForAmount(amount: uint256) -> uint256:
962     # Determines how many shares `amount` of token would receive.
963     # See dev note on `deposit`.
964     _freeFunds: uint256 = self._freeFunds()
965     if _freeFunds > 0:
966         # NOTE: if sqrt(token.totalSupply()) > 1e37, this could potentially revert
967         return  (
968             amount
969             * self.totalSupply
970             / _freeFunds 
971         )
972     else:
973         return 0
974 
975 
976 @view
977 @external
978 def maxAvailableShares() -> uint256:
979     """
980     @notice
981         Determines the maximum quantity of shares this Vault can facilitate a
982         withdrawal for, factoring in assets currently residing in the Vault,
983         as well as those deployed to strategies on the Vault's balance sheet.
984     @dev
985         Regarding how shares are calculated, see dev note on `deposit`.
986 
987         If you want to calculated the maximum a user could withdraw up to,
988         you want to use this function.
989 
990         Note that the amount provided by this function is the theoretical
991         maximum possible from withdrawing, the real amount depends on the
992         realized losses incurred during withdrawal.
993     @return The total quantity of shares this Vault can provide.
994     """
995     shares: uint256 = self._sharesForAmount(self.totalIdle)
996 
997     for strategy in self.withdrawalQueue:
998         if strategy == ZERO_ADDRESS:
999             break
1000         shares += self._sharesForAmount(self.strategies[strategy].totalDebt)
1001 
1002     return shares
1003 
1004 
1005 @internal
1006 def _reportLoss(strategy: address, loss: uint256):
1007     # Loss can only be up the amount of debt issued to strategy
1008     totalDebt: uint256 = self.strategies[strategy].totalDebt
1009     assert totalDebt >= loss
1010 
1011     # Also, make sure we reduce our trust with the strategy by the amount of loss
1012     if self.debtRatio != 0: # if vault with single strategy that is set to EmergencyOne
1013         # NOTE: The context to this calculation is different than the calculation in `_reportLoss`,
1014         # this calculation intentionally approximates via `totalDebt` to avoid manipulatable results
1015         ratio_change: uint256 = min(
1016             # NOTE: This calculation isn't 100% precise, the adjustment is ~10%-20% more severe due to EVM math
1017             loss * self.debtRatio / self.totalDebt,
1018             self.strategies[strategy].debtRatio,
1019         )
1020         self.strategies[strategy].debtRatio -= ratio_change
1021         self.debtRatio -= ratio_change
1022     # Finally, adjust our strategy's parameters by the loss
1023     self.strategies[strategy].totalLoss += loss
1024     self.strategies[strategy].totalDebt = totalDebt - loss
1025     self.totalDebt -= loss
1026 
1027 
1028 @external
1029 @nonreentrant("withdraw")
1030 def withdraw(
1031     maxShares: uint256 = MAX_UINT256,
1032     recipient: address = msg.sender,
1033     maxLoss: uint256 = 1,  # 0.01% [BPS]
1034 ) -> uint256:
1035     """
1036     @notice
1037         Withdraws the calling account's tokens from this Vault, redeeming
1038         amount `_shares` for an appropriate amount of tokens.
1039 
1040         See note on `setWithdrawalQueue` for further details of withdrawal
1041         ordering and behavior.
1042     @dev
1043         Measuring the value of shares is based on the total outstanding debt
1044         that this contract has ("expected value") instead of the total balance
1045         sheet it has ("estimated value") has important security considerations,
1046         and is done intentionally. If this value were measured against external
1047         systems, it could be purposely manipulated by an attacker to withdraw
1048         more assets than they otherwise should be able to claim by redeeming
1049         their shares.
1050 
1051         On withdrawal, this means that shares are redeemed against the total
1052         amount that the deposited capital had "realized" since the point it
1053         was deposited, up until the point it was withdrawn. If that number
1054         were to be higher than the "expected value" at some future point,
1055         withdrawing shares via this method could entitle the depositor to
1056         *more* than the expected value once the "realized value" is updated
1057         from further reports by the Strategies to the Vaults.
1058 
1059         Under exceptional scenarios, this could cause earlier withdrawals to
1060         earn "more" of the underlying assets than Users might otherwise be
1061         entitled to, if the Vault's estimated value were otherwise measured
1062         through external means, accounting for whatever exceptional scenarios
1063         exist for the Vault (that aren't covered by the Vault's own design.)
1064 
1065         In the situation where a large withdrawal happens, it can empty the 
1066         vault balance and the strategies in the withdrawal queue. 
1067         Strategies not in the withdrawal queue will have to be harvested to 
1068         rebalance the funds and make the funds available again to withdraw.
1069     @param maxShares
1070         How many shares to try and redeem for tokens, defaults to all.
1071     @param recipient
1072         The address to issue the shares in this Vault to. Defaults to the
1073         caller's address.
1074     @param maxLoss
1075         The maximum acceptable loss to sustain on withdrawal. Defaults to 0.01%.
1076         If a loss is specified, up to that amount of shares may be burnt to cover losses on withdrawal.
1077     @return The quantity of tokens redeemed for `_shares`.
1078     """
1079     shares: uint256 = maxShares  # May reduce this number below
1080 
1081     # Max Loss is <=100%, revert otherwise
1082     assert maxLoss <= MAX_BPS
1083 
1084     # If _shares not specified, transfer full share balance
1085     if shares == MAX_UINT256:
1086         shares = self.balanceOf[msg.sender]
1087 
1088     # Limit to only the shares they own
1089     assert shares <= self.balanceOf[msg.sender]
1090 
1091     # Ensure we are withdrawing something
1092     assert shares > 0
1093 
1094     # See @dev note, above.
1095     value: uint256 = self._shareValue(shares)
1096     vault_balance: uint256 = self.totalIdle
1097 
1098     if value > vault_balance:
1099         totalLoss: uint256 = 0
1100         # We need to go get some from our strategies in the withdrawal queue
1101         # NOTE: This performs forced withdrawals from each Strategy. During
1102         #       forced withdrawal, a Strategy may realize a loss. That loss
1103         #       is reported back to the Vault, and the will affect the amount
1104         #       of tokens that the withdrawer receives for their shares. They
1105         #       can optionally specify the maximum acceptable loss (in BPS)
1106         #       to prevent excessive losses on their withdrawals (which may
1107         #       happen in certain edge cases where Strategies realize a loss)
1108         for strategy in self.withdrawalQueue:
1109             if strategy == ZERO_ADDRESS:
1110                 break  # We've exhausted the queue
1111 
1112             if value <= vault_balance:
1113                 break  # We're done withdrawing
1114 
1115             amountNeeded: uint256 = value - vault_balance
1116 
1117             # NOTE: Don't withdraw more than the debt so that Strategy can still
1118             #       continue to work based on the profits it has
1119             # NOTE: This means that user will lose out on any profits that each
1120             #       Strategy in the queue would return on next harvest, benefiting others
1121             amountNeeded = min(amountNeeded, self.strategies[strategy].totalDebt)
1122             if amountNeeded == 0:
1123                 continue  # Nothing to withdraw from this Strategy, try the next one
1124 
1125             # Force withdraw amount from each Strategy in the order set by governance
1126             preBalance: uint256 = self.token.balanceOf(self)
1127             loss: uint256 = Strategy(strategy).withdraw(amountNeeded)
1128             withdrawn: uint256 = self.token.balanceOf(self) - preBalance
1129             vault_balance += withdrawn
1130 
1131             # NOTE: Withdrawer incurs any losses from liquidation
1132             if loss > 0:
1133                 value -= loss
1134                 totalLoss += loss
1135                 self._reportLoss(strategy, loss)
1136 
1137             # Reduce the Strategy's debt by the amount withdrawn ("realized returns")
1138             # NOTE: This doesn't add to returns as it's not earned by "normal means"
1139             self.strategies[strategy].totalDebt -= withdrawn
1140             self.totalDebt -= withdrawn
1141             log WithdrawFromStrategy(strategy, self.strategies[strategy].totalDebt, loss)
1142 
1143         self.totalIdle = vault_balance
1144         # NOTE: We have withdrawn everything possible out of the withdrawal queue
1145         #       but we still don't have enough to fully pay them back, so adjust
1146         #       to the total amount we've freed up through forced withdrawals
1147         if value > vault_balance:
1148             value = vault_balance
1149             # NOTE: Burn # of shares that corresponds to what Vault has on-hand,
1150             #       including the losses that were incurred above during withdrawals
1151             shares = self._sharesForAmount(value + totalLoss)
1152 
1153         # NOTE: This loss protection is put in place to revert if losses from
1154         #       withdrawing are more than what is considered acceptable.
1155         assert totalLoss <= maxLoss * (value + totalLoss) / MAX_BPS
1156 
1157     # Burn shares (full value of what is being withdrawn)
1158     self.totalSupply -= shares
1159     self.balanceOf[msg.sender] -= shares
1160     log Transfer(msg.sender, ZERO_ADDRESS, shares)
1161     
1162     self.totalIdle -= value
1163     # Withdraw remaining balance to _recipient (may be different to msg.sender) (minus fee)
1164     self.erc20_safe_transfer(self.token.address, recipient, value)
1165     log Withdraw(recipient, shares, value)
1166     
1167     return value
1168 
1169 
1170 @view
1171 @external
1172 def pricePerShare() -> uint256:
1173     """
1174     @notice Gives the price for a single Vault share.
1175     @dev See dev note on `withdraw`.
1176     @return The value of a single share.
1177     """
1178     return self._shareValue(10 ** self.decimals)
1179 
1180 
1181 @internal
1182 def _organizeWithdrawalQueue():
1183     # Reorganize `withdrawalQueue` based on premise that if there is an
1184     # empty value between two actual values, then the empty value should be
1185     # replaced by the later value.
1186     # NOTE: Relative ordering of non-zero values is maintained.
1187     offset: uint256 = 0
1188     for idx in range(MAXIMUM_STRATEGIES):
1189         strategy: address = self.withdrawalQueue[idx]
1190         if strategy == ZERO_ADDRESS:
1191             offset += 1  # how many values we need to shift, always `<= idx`
1192         elif offset > 0:
1193             self.withdrawalQueue[idx - offset] = strategy
1194             self.withdrawalQueue[idx] = ZERO_ADDRESS
1195 
1196 
1197 @external
1198 def addStrategy(
1199     strategy: address,
1200     debtRatio: uint256,
1201     minDebtPerHarvest: uint256,
1202     maxDebtPerHarvest: uint256,
1203     performanceFee: uint256,
1204 ):
1205     """
1206     @notice
1207         Add a Strategy to the Vault.
1208 
1209         This may only be called by governance.
1210     @dev
1211         The Strategy will be appended to `withdrawalQueue`, call
1212         `setWithdrawalQueue` to change the order.
1213     @param strategy The address of the Strategy to add.
1214     @param debtRatio
1215         The share of the total assets in the `vault that the `strategy` has access to.
1216     @param minDebtPerHarvest
1217         Lower limit on the increase of debt since last harvest
1218     @param maxDebtPerHarvest
1219         Upper limit on the increase of debt since last harvest
1220     @param performanceFee
1221         The fee the strategist will receive based on this Vault's performance.
1222     """
1223     # Check if queue is full
1224     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1225 
1226     # Check calling conditions
1227     assert not self.emergencyShutdown
1228     assert msg.sender == self.governance
1229 
1230     # Check strategy configuration
1231     assert strategy != ZERO_ADDRESS
1232     assert self.strategies[strategy].activation == 0
1233     assert self == Strategy(strategy).vault()
1234     assert self.token.address == Strategy(strategy).want()
1235 
1236     # Check strategy parameters
1237     assert self.debtRatio + debtRatio <= MAX_BPS
1238     assert minDebtPerHarvest <= maxDebtPerHarvest
1239     assert performanceFee <= MAX_BPS / 2 
1240 
1241     # Add strategy to approved strategies
1242     self.strategies[strategy] = StrategyParams({
1243         performanceFee: performanceFee,
1244         activation: block.timestamp,
1245         debtRatio: debtRatio,
1246         minDebtPerHarvest: minDebtPerHarvest,
1247         maxDebtPerHarvest: maxDebtPerHarvest,
1248         lastReport: block.timestamp,
1249         totalDebt: 0,
1250         totalGain: 0,
1251         totalLoss: 0,
1252     })
1253     log StrategyAdded(strategy, debtRatio, minDebtPerHarvest, maxDebtPerHarvest, performanceFee)
1254 
1255     # Update Vault parameters
1256     self.debtRatio += debtRatio
1257 
1258     # Add strategy to the end of the withdrawal queue
1259     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1260     self._organizeWithdrawalQueue()
1261 
1262 
1263 @external
1264 def updateStrategyDebtRatio(
1265     strategy: address,
1266     debtRatio: uint256,
1267 ):
1268     """
1269     @notice
1270         Change the quantity of assets `strategy` may manage.
1271 
1272         This may be called by governance or management.
1273     @param strategy The Strategy to update.
1274     @param debtRatio The quantity of assets `strategy` may now manage.
1275     """
1276     assert msg.sender in [self.management, self.governance]
1277     assert self.strategies[strategy].activation > 0
1278     assert Strategy(strategy).emergencyExit() == False # dev: strategy in emergency
1279     self.debtRatio -= self.strategies[strategy].debtRatio
1280     self.strategies[strategy].debtRatio = debtRatio
1281     self.debtRatio += debtRatio
1282     assert self.debtRatio <= MAX_BPS
1283     log StrategyUpdateDebtRatio(strategy, debtRatio)
1284 
1285 
1286 @external
1287 def updateStrategyMinDebtPerHarvest(
1288     strategy: address,
1289     minDebtPerHarvest: uint256,
1290 ):
1291     """
1292     @notice
1293         Change the quantity assets per block this Vault may deposit to or
1294         withdraw from `strategy`.
1295 
1296         This may only be called by governance or management.
1297     @param strategy The Strategy to update.
1298     @param minDebtPerHarvest
1299         Lower limit on the increase of debt since last harvest
1300     """
1301     assert msg.sender in [self.management, self.governance]
1302     assert self.strategies[strategy].activation > 0
1303     assert self.strategies[strategy].maxDebtPerHarvest >= minDebtPerHarvest
1304     self.strategies[strategy].minDebtPerHarvest = minDebtPerHarvest
1305     log StrategyUpdateMinDebtPerHarvest(strategy, minDebtPerHarvest)
1306 
1307 
1308 @external
1309 def updateStrategyMaxDebtPerHarvest(
1310     strategy: address,
1311     maxDebtPerHarvest: uint256,
1312 ):
1313     """
1314     @notice
1315         Change the quantity assets per block this Vault may deposit to or
1316         withdraw from `strategy`.
1317 
1318         This may only be called by governance or management.
1319     @param strategy The Strategy to update.
1320     @param maxDebtPerHarvest
1321         Upper limit on the increase of debt since last harvest
1322     """
1323     assert msg.sender in [self.management, self.governance]
1324     assert self.strategies[strategy].activation > 0
1325     assert self.strategies[strategy].minDebtPerHarvest <= maxDebtPerHarvest
1326     self.strategies[strategy].maxDebtPerHarvest = maxDebtPerHarvest
1327     log StrategyUpdateMaxDebtPerHarvest(strategy, maxDebtPerHarvest)
1328 
1329 
1330 @external
1331 def updateStrategyPerformanceFee(
1332     strategy: address,
1333     performanceFee: uint256,
1334 ):
1335     """
1336     @notice
1337         Change the fee the strategist will receive based on this Vault's
1338         performance.
1339 
1340         This may only be called by governance.
1341     @param strategy The Strategy to update.
1342     @param performanceFee The new fee the strategist will receive.
1343     """
1344     assert msg.sender == self.governance
1345     assert performanceFee <= MAX_BPS / 2
1346     assert self.strategies[strategy].activation > 0
1347     self.strategies[strategy].performanceFee = performanceFee
1348     log StrategyUpdatePerformanceFee(strategy, performanceFee)
1349 
1350 
1351 @internal
1352 def _revokeStrategy(strategy: address):
1353     self.debtRatio -= self.strategies[strategy].debtRatio
1354     self.strategies[strategy].debtRatio = 0
1355     log StrategyRevoked(strategy)
1356 
1357 
1358 @external
1359 def migrateStrategy(oldVersion: address, newVersion: address):
1360     """
1361     @notice
1362         Migrates a Strategy, including all assets from `oldVersion` to
1363         `newVersion`.
1364 
1365         This may only be called by governance.
1366     @dev
1367         Strategy must successfully migrate all capital and positions to new
1368         Strategy, or else this will upset the balance of the Vault.
1369 
1370         The new Strategy should be "empty" e.g. have no prior commitments to
1371         this Vault, otherwise it could have issues.
1372     @param oldVersion The existing Strategy to migrate from.
1373     @param newVersion The new Strategy to migrate to.
1374     """
1375     assert msg.sender == self.governance
1376     assert newVersion != ZERO_ADDRESS
1377     assert self.strategies[oldVersion].activation > 0
1378     assert self.strategies[newVersion].activation == 0
1379 
1380     strategy: StrategyParams = self.strategies[oldVersion]
1381 
1382     self._revokeStrategy(oldVersion)
1383     # _revokeStrategy will lower the debtRatio
1384     self.debtRatio += strategy.debtRatio
1385     # Debt is migrated to new strategy
1386     self.strategies[oldVersion].totalDebt = 0
1387 
1388     self.strategies[newVersion] = StrategyParams({
1389         performanceFee: strategy.performanceFee,
1390         # NOTE: use last report for activation time, so E[R] calc works
1391         activation: strategy.lastReport,
1392         debtRatio: strategy.debtRatio,
1393         minDebtPerHarvest: strategy.minDebtPerHarvest,
1394         maxDebtPerHarvest: strategy.maxDebtPerHarvest,
1395         lastReport: strategy.lastReport,
1396         totalDebt: strategy.totalDebt,
1397         totalGain: 0,
1398         totalLoss: 0,
1399     })
1400 
1401     Strategy(oldVersion).migrate(newVersion)
1402     log StrategyMigrated(oldVersion, newVersion)
1403 
1404     for idx in range(MAXIMUM_STRATEGIES):
1405         if self.withdrawalQueue[idx] == oldVersion:
1406             self.withdrawalQueue[idx] = newVersion
1407             return  # Don't need to reorder anything because we swapped
1408 
1409 
1410 @external
1411 def revokeStrategy(strategy: address = msg.sender):
1412     """
1413     @notice
1414         Revoke a Strategy, setting its debt limit to 0 and preventing any
1415         future deposits.
1416 
1417         This function should only be used in the scenario where the Strategy is
1418         being retired but no migration of the positions are possible, or in the
1419         extreme scenario that the Strategy needs to be put into "Emergency Exit"
1420         mode in order for it to exit as quickly as possible. The latter scenario
1421         could be for any reason that is considered "critical" that the Strategy
1422         exits its position as fast as possible, such as a sudden change in market
1423         conditions leading to losses, or an imminent failure in an external
1424         dependency.
1425 
1426         This may only be called by governance, the guardian, or the Strategy
1427         itself. Note that a Strategy will only revoke itself during emergency
1428         shutdown.
1429     @param strategy The Strategy to revoke.
1430     """
1431     assert msg.sender in [strategy, self.governance, self.guardian]
1432     assert self.strategies[strategy].debtRatio != 0 # dev: already zero
1433 
1434     self._revokeStrategy(strategy)
1435 
1436 
1437 @external
1438 def addStrategyToQueue(strategy: address):
1439     """
1440     @notice
1441         Adds `strategy` to `withdrawalQueue`.
1442 
1443         This may only be called by governance or management.
1444     @dev
1445         The Strategy will be appended to `withdrawalQueue`, call
1446         `setWithdrawalQueue` to change the order.
1447     @param strategy The Strategy to add.
1448     """
1449     assert msg.sender in [self.management, self.governance]
1450     # Must be a current Strategy
1451     assert self.strategies[strategy].activation > 0
1452     # Can't already be in the queue
1453     last_idx: uint256 = 0
1454     for s in self.withdrawalQueue:
1455         if s == ZERO_ADDRESS:
1456             break
1457         assert s != strategy
1458         last_idx += 1
1459     # Check if queue is full
1460     assert last_idx < MAXIMUM_STRATEGIES
1461 
1462     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1463     self._organizeWithdrawalQueue()
1464     log StrategyAddedToQueue(strategy)
1465 
1466 
1467 @external
1468 def removeStrategyFromQueue(strategy: address):
1469     """
1470     @notice
1471         Remove `strategy` from `withdrawalQueue`.
1472 
1473         This may only be called by governance or management.
1474     @dev
1475         We don't do this with revokeStrategy because it should still
1476         be possible to withdraw from the Strategy if it's unwinding.
1477     @param strategy The Strategy to remove.
1478     """
1479     assert msg.sender in [self.management, self.governance]
1480     for idx in range(MAXIMUM_STRATEGIES):
1481         if self.withdrawalQueue[idx] == strategy:
1482             self.withdrawalQueue[idx] = ZERO_ADDRESS
1483             self._organizeWithdrawalQueue()
1484             log StrategyRemovedFromQueue(strategy)
1485             return  # We found the right location and cleared it
1486     raise  # We didn't find the Strategy in the queue
1487 
1488 
1489 @view
1490 @internal
1491 def _debtOutstanding(strategy: address) -> uint256:
1492     # See note on `debtOutstanding()`.
1493     if self.debtRatio == 0:
1494         return self.strategies[strategy].totalDebt
1495 
1496     strategy_debtLimit: uint256 = (
1497         self.strategies[strategy].debtRatio
1498         * self._totalAssets()
1499         / MAX_BPS
1500     )
1501     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1502 
1503     if self.emergencyShutdown:
1504         return strategy_totalDebt
1505     elif strategy_totalDebt <= strategy_debtLimit:
1506         return 0
1507     else:
1508         return strategy_totalDebt - strategy_debtLimit
1509 
1510 
1511 @view
1512 @external
1513 def debtOutstanding(strategy: address = msg.sender) -> uint256:
1514     """
1515     @notice
1516         Determines if `strategy` is past its debt limit and if any tokens
1517         should be withdrawn to the Vault.
1518     @param strategy The Strategy to check. Defaults to the caller.
1519     @return The quantity of tokens to withdraw.
1520     """
1521     return self._debtOutstanding(strategy)
1522 
1523 
1524 @view
1525 @internal
1526 def _creditAvailable(strategy: address) -> uint256:
1527     # See note on `creditAvailable()`.
1528     if self.emergencyShutdown:
1529         return 0
1530     vault_totalAssets: uint256 = self._totalAssets()
1531     vault_debtLimit: uint256 =  self.debtRatio * vault_totalAssets / MAX_BPS 
1532     vault_totalDebt: uint256 = self.totalDebt
1533     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * vault_totalAssets / MAX_BPS
1534     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1535     strategy_minDebtPerHarvest: uint256 = self.strategies[strategy].minDebtPerHarvest
1536     strategy_maxDebtPerHarvest: uint256 = self.strategies[strategy].maxDebtPerHarvest
1537 
1538     # Exhausted credit line
1539     if strategy_debtLimit <= strategy_totalDebt or vault_debtLimit <= vault_totalDebt:
1540         return 0
1541 
1542     # Start with debt limit left for the Strategy
1543     available: uint256 = strategy_debtLimit - strategy_totalDebt
1544 
1545     # Adjust by the global debt limit left
1546     available = min(available, vault_debtLimit - vault_totalDebt)
1547 
1548     # Can only borrow up to what the contract has in reserve
1549     # NOTE: Running near 100% is discouraged
1550     available = min(available, self.totalIdle)
1551 
1552     # Adjust by min and max borrow limits (per harvest)
1553     # NOTE: min increase can be used to ensure that if a strategy has a minimum
1554     #       amount of capital needed to purchase a position, it's not given capital
1555     #       it can't make use of yet.
1556     # NOTE: max increase is used to make sure each harvest isn't bigger than what
1557     #       is authorized. This combined with adjusting min and max periods in
1558     #       `BaseStrategy` can be used to effect a "rate limit" on capital increase.
1559     if available < strategy_minDebtPerHarvest:
1560         return 0
1561     else:
1562         return min(available, strategy_maxDebtPerHarvest)
1563 
1564 @view
1565 @external
1566 def creditAvailable(strategy: address = msg.sender) -> uint256:
1567     """
1568     @notice
1569         Amount of tokens in Vault a Strategy has access to as a credit line.
1570 
1571         This will check the Strategy's debt limit, as well as the tokens
1572         available in the Vault, and determine the maximum amount of tokens
1573         (if any) the Strategy may draw on.
1574 
1575         In the rare case the Vault is in emergency shutdown this will return 0.
1576     @param strategy The Strategy to check. Defaults to caller.
1577     @return The quantity of tokens available for the Strategy to draw on.
1578     """
1579     return self._creditAvailable(strategy)
1580 
1581 
1582 @view
1583 @internal
1584 def _expectedReturn(strategy: address) -> uint256:
1585     # See note on `expectedReturn()`.
1586     strategy_lastReport: uint256 = self.strategies[strategy].lastReport
1587     timeSinceLastHarvest: uint256 = block.timestamp - strategy_lastReport
1588     totalHarvestTime: uint256 = strategy_lastReport - self.strategies[strategy].activation
1589 
1590     # NOTE: If either `timeSinceLastHarvest` or `totalHarvestTime` is 0, we can short-circuit to `0`
1591     if timeSinceLastHarvest > 0 and totalHarvestTime > 0 and Strategy(strategy).isActive():
1592         # NOTE: Unlikely to throw unless strategy accumalates >1e68 returns
1593         # NOTE: Calculate average over period of time where harvests have occured in the past
1594         return (
1595             self.strategies[strategy].totalGain
1596             * timeSinceLastHarvest
1597             / totalHarvestTime
1598         )
1599     else:
1600         return 0  # Covers the scenario when block.timestamp == activation
1601 
1602 
1603 @view
1604 @external
1605 def availableDepositLimit() -> uint256:
1606     if self.depositLimit > self._totalAssets():
1607         return self.depositLimit - self._totalAssets()
1608     else:
1609         return 0
1610 
1611 
1612 @view
1613 @external
1614 def expectedReturn(strategy: address = msg.sender) -> uint256:
1615     """
1616     @notice
1617         Provide an accurate expected value for the return this `strategy`
1618         would provide to the Vault the next time `report()` is called
1619         (since the last time it was called).
1620     @param strategy The Strategy to determine the expected return for. Defaults to caller.
1621     @return
1622         The anticipated amount `strategy` should make on its investment
1623         since its last report.
1624     """
1625     return self._expectedReturn(strategy)
1626 
1627 
1628 @internal
1629 def _assessFees(strategy: address, gain: uint256) -> uint256:
1630     # Issue new shares to cover fees
1631     # NOTE: In effect, this reduces overall share price by the combined fee
1632     # NOTE: may throw if Vault.totalAssets() > 1e64, or not called for more than a year
1633     if self.strategies[strategy].activation == block.timestamp:
1634         return 0  # NOTE: Just added, no fees to assess
1635 
1636     duration: uint256 = block.timestamp - self.strategies[strategy].lastReport
1637     assert duration != 0 # can't assessFees twice within the same block
1638 
1639     if gain == 0:
1640         # NOTE: The fees are not charged if there hasn't been any gains reported
1641         return 0
1642 
1643     management_fee: uint256 = (
1644         (
1645             (self.strategies[strategy].totalDebt - Strategy(strategy).delegatedAssets())
1646             * duration 
1647             * self.managementFee
1648         )
1649         / MAX_BPS
1650         / SECS_PER_YEAR
1651     )
1652 
1653     # NOTE: Applies if Strategy is not shutting down, or it is but all debt paid off
1654     # NOTE: No fee is taken when a Strategy is unwinding it's position, until all debt is paid
1655     strategist_fee: uint256 = (
1656         gain
1657         * self.strategies[strategy].performanceFee
1658         / MAX_BPS
1659     )
1660     # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1661     performance_fee: uint256 = gain * self.performanceFee / MAX_BPS
1662 
1663     # NOTE: This must be called prior to taking new collateral,
1664     #       or the calculation will be wrong!
1665     # NOTE: This must be done at the same time, to ensure the relative
1666     #       ratio of governance_fee : strategist_fee is kept intact
1667     total_fee: uint256 = performance_fee + strategist_fee + management_fee
1668     # ensure total_fee is not more than gain
1669     if total_fee > gain:
1670         total_fee = gain
1671     if total_fee > 0:  # NOTE: If mgmt fee is 0% and no gains were realized, skip
1672         reward: uint256 = self._issueSharesForAmount(self, total_fee)
1673 
1674         # Send the rewards out as new shares in this Vault
1675         if strategist_fee > 0:  # NOTE: Guard against DIV/0 fault
1676             # NOTE: Unlikely to throw unless sqrt(reward) >>> 1e39
1677             strategist_reward: uint256 = (
1678                 strategist_fee
1679                 * reward
1680                 / total_fee
1681             )
1682             self._transfer(self, strategy, strategist_reward)
1683             # NOTE: Strategy distributes rewards at the end of harvest()
1684         # NOTE: Governance earns any dust leftover from flooring math above
1685         if self.balanceOf[self] > 0:
1686             self._transfer(self, self.rewards, self.balanceOf[self])
1687     log FeeReport(management_fee, performance_fee, strategist_fee, duration)
1688     return total_fee
1689 
1690 
1691 @external
1692 def report(gain: uint256, loss: uint256, _debtPayment: uint256) -> uint256:
1693     """
1694     @notice
1695         Reports the amount of assets the calling Strategy has free (usually in
1696         terms of ROI).
1697 
1698         The performance fee is determined here, off of the strategy's profits
1699         (if any), and sent to governance.
1700 
1701         The strategist's fee is also determined here (off of profits), to be
1702         handled according to the strategist on the next harvest.
1703 
1704         This may only be called by a Strategy managed by this Vault.
1705     @dev
1706         For approved strategies, this is the most efficient behavior.
1707         The Strategy reports back what it has free, then Vault "decides"
1708         whether to take some back or give it more. Note that the most it can
1709         take is `gain + _debtPayment`, and the most it can give is all of the
1710         remaining reserves. Anything outside of those bounds is abnormal behavior.
1711 
1712         All approved strategies must have increased diligence around
1713         calling this function, as abnormal behavior could become catastrophic.
1714     @param gain
1715         Amount Strategy has realized as a gain on it's investment since its
1716         last report, and is free to be given back to Vault as earnings
1717     @param loss
1718         Amount Strategy has realized as a loss on it's investment since its
1719         last report, and should be accounted for on the Vault's balance sheet.
1720         The loss will reduce the debtRatio. The next time the strategy will harvest,
1721         it will pay back the debt in an attempt to adjust to the new debt limit.
1722     @param _debtPayment
1723         Amount Strategy has made available to cover outstanding debt
1724     @return Amount of debt outstanding (if totalDebt > debtLimit or emergency shutdown).
1725     """
1726 
1727     # Only approved strategies can call this function
1728     assert self.strategies[msg.sender].activation > 0
1729     # No lying about total available to withdraw!
1730     assert self.token.balanceOf(msg.sender) >= gain + _debtPayment
1731 
1732     # We have a loss to report, do it before the rest of the calculations
1733     if loss > 0:
1734         self._reportLoss(msg.sender, loss)
1735 
1736     # Assess both management fee and performance fee, and issue both as shares of the vault
1737     totalFees: uint256 = self._assessFees(msg.sender, gain)
1738 
1739     # Returns are always "realized gains"
1740     self.strategies[msg.sender].totalGain += gain
1741 
1742     # Compute the line of credit the Vault is able to offer the Strategy (if any)
1743     credit: uint256 = self._creditAvailable(msg.sender)
1744 
1745     # Outstanding debt the Strategy wants to take back from the Vault (if any)
1746     # NOTE: debtOutstanding <= StrategyParams.totalDebt
1747     debt: uint256 = self._debtOutstanding(msg.sender)
1748     debtPayment: uint256 = min(_debtPayment, debt)
1749 
1750     if debtPayment > 0:
1751         self.strategies[msg.sender].totalDebt -= debtPayment
1752         self.totalDebt -= debtPayment
1753         debt -= debtPayment
1754         # NOTE: `debt` is being tracked for later
1755 
1756     # Update the actual debt based on the full credit we are extending to the Strategy
1757     # or the returns if we are taking funds back
1758     # NOTE: credit + self.strategies[msg.sender].totalDebt is always < self.debtLimit
1759     # NOTE: At least one of `credit` or `debt` is always 0 (both can be 0)
1760     if credit > 0:
1761         self.strategies[msg.sender].totalDebt += credit
1762         self.totalDebt += credit
1763 
1764     # Give/take balance to Strategy, based on the difference between the reported gains
1765     # (if any), the debt payment (if any), the credit increase we are offering (if any),
1766     # and the debt needed to be paid off (if any)
1767     # NOTE: This is just used to adjust the balance of tokens between the Strategy and
1768     #       the Vault based on the Strategy's debt limit (as well as the Vault's).
1769     totalAvail: uint256 = gain + debtPayment
1770     if totalAvail < credit:  # credit surplus, give to Strategy
1771         self.totalIdle -= credit - totalAvail
1772         self.erc20_safe_transfer(self.token.address, msg.sender, credit - totalAvail)
1773     elif totalAvail > credit:  # credit deficit, take from Strategy
1774         self.totalIdle += totalAvail - credit
1775         self.erc20_safe_transferFrom(self.token.address, msg.sender, self, totalAvail - credit)
1776     # else, don't do anything because it is balanced
1777 
1778     # Profit is locked and gradually released per block
1779     # NOTE: compute current locked profit and replace with sum of current and new
1780     lockedProfitBeforeLoss: uint256 = self._calculateLockedProfit() + gain - totalFees
1781     if lockedProfitBeforeLoss > loss: 
1782         self.lockedProfit = lockedProfitBeforeLoss - loss
1783     else:
1784         self.lockedProfit = 0
1785 
1786     # Update reporting time
1787     self.strategies[msg.sender].lastReport = block.timestamp
1788     self.lastReport = block.timestamp
1789 
1790     log StrategyReported(
1791         msg.sender,
1792         gain,
1793         loss,
1794         debtPayment,
1795         self.strategies[msg.sender].totalGain,
1796         self.strategies[msg.sender].totalLoss,
1797         self.strategies[msg.sender].totalDebt,
1798         credit,
1799         self.strategies[msg.sender].debtRatio,
1800     )
1801 
1802     if self.strategies[msg.sender].debtRatio == 0 or self.emergencyShutdown:
1803         # Take every last penny the Strategy has (Emergency Exit/revokeStrategy)
1804         # NOTE: This is different than `debt` in order to extract *all* of the returns
1805         return Strategy(msg.sender).estimatedTotalAssets()
1806     else:
1807         # Otherwise, just return what we have as debt outstanding
1808         return debt
1809 
1810 
1811 @external
1812 def sweep(token: address, amount: uint256 = MAX_UINT256):
1813     """
1814     @notice
1815         Removes tokens from this Vault that are not the type of token managed
1816         by this Vault. This may be used in case of accidentally sending the
1817         wrong kind of token to this Vault.
1818 
1819         Tokens will be sent to `governance`.
1820 
1821         This will fail if an attempt is made to sweep the tokens that this
1822         Vault manages.
1823 
1824         This may only be called by governance.
1825     @param token The token to transfer out of this vault.
1826     @param amount The quantity or tokenId to transfer out.
1827     """
1828     assert msg.sender == self.governance
1829     # Can't be used to steal what this Vault is protecting
1830     value: uint256 = amount
1831     if value == MAX_UINT256:
1832         value = ERC20(token).balanceOf(self)
1833 
1834     if token == self.token.address:
1835         value = self.token.balanceOf(self) - self.totalIdle
1836 
1837     log Sweep(token, value)
1838     self.erc20_safe_transfer(token, self.governance, value)