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
38 API_VERSION: constant(String[28]) = "0.3.5"
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
61 interface GuestList:
62     def authorized(guest: address, amount: uint256) -> bool: view
63 
64 
65 event Transfer:
66     sender: indexed(address)
67     receiver: indexed(address)
68     value: uint256
69 
70 
71 event Approval:
72     owner: indexed(address)
73     spender: indexed(address)
74     value: uint256
75 
76 
77 name: public(String[64])
78 symbol: public(String[32])
79 decimals: public(uint256)
80 precisionFactor: public(uint256)
81 
82 balanceOf: public(HashMap[address, uint256])
83 allowance: public(HashMap[address, HashMap[address, uint256]])
84 totalSupply: public(uint256)
85 
86 token: public(ERC20)
87 governance: public(address)
88 management: public(address)
89 guardian: public(address)
90 pendingGovernance: address
91 guestList: public(GuestList)
92 
93 struct StrategyParams:
94     performanceFee: uint256  # Strategist's fee (basis points)
95     activation: uint256  # Activation block.timestamp
96     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
97     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
98     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
99     lastReport: uint256  # block.timestamp of the last time a report occured
100     totalDebt: uint256  # Total outstanding debt that Strategy has
101     totalGain: uint256  # Total returns that Strategy has realized for Vault
102     totalLoss: uint256  # Total losses that Strategy has realized for Vault
103 
104 
105 event StrategyAdded:
106     strategy: indexed(address)
107     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
108     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
109     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
110     performanceFee: uint256  # Strategist's fee (basis points)
111 
112 
113 event StrategyReported:
114     strategy: indexed(address)
115     gain: uint256
116     loss: uint256
117     debtPaid: uint256
118     totalGain: uint256
119     totalLoss: uint256
120     totalDebt: uint256
121     debtAdded: uint256
122     debtRatio: uint256
123 
124 
125 event UpdateGovernance:
126     governance: address # New active governance
127 
128 
129 event UpdateManagement:
130     management: address # New active manager
131 
132 
133 event UpdateGuestList:
134     guestList: address # Vault guest list address
135 
136 
137 event UpdateRewards:
138     rewards: address # New active rewards recipient
139 
140 
141 event UpdateDepositLimit:
142     depositLimit: uint256 # New active deposit limit
143 
144 
145 event UpdatePerformanceFee:
146     performanceFee: uint256 # New active performance fee
147 
148 
149 event UpdateManagementFee:
150     managementFee: uint256 # New active management fee
151 
152 
153 event UpdateGuardian:
154     guardian: address # Address of the active guardian
155 
156 
157 event EmergencyShutdown:
158     active: bool # New emergency shutdown state (if false, normal operation enabled)
159 
160 
161 event UpdateWithdrawalQueue:
162     queue: address[MAXIMUM_STRATEGIES] # New active withdrawal queue
163 
164 
165 event StrategyUpdateDebtRatio:
166     strategy: indexed(address) # Address of the strategy for the debt ratio adjustment
167     debtRatio: uint256 # The new debt limit for the strategy (in BPS of total assets)
168 
169 
170 event StrategyUpdateMinDebtPerHarvest:
171     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
172     minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
173 
174 
175 event StrategyUpdateMaxDebtPerHarvest:
176     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
177     maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
178 
179 
180 event StrategyUpdatePerformanceFee:
181     strategy: indexed(address) # Address of the strategy for the performance fee adjustment
182     performanceFee: uint256 # The new performance fee for the strategy
183 
184 
185 event StrategyMigrated:
186     oldVersion: indexed(address) # Old version of the strategy to be migrated
187     newVersion: indexed(address) # New version of the strategy
188 
189 
190 event StrategyRevoked:
191     strategy: indexed(address) # Address of the strategy that is revoked
192 
193 
194 event StrategyRemovedFromQueue:
195     strategy: indexed(address) # Address of the strategy that is removed from the withdrawal queue
196 
197 
198 event StrategyAddedToQueue:
199     strategy: indexed(address) # Address of the strategy that is added to the withdrawal queue
200 
201 
202 # NOTE: Track the total for overhead targeting purposes
203 strategies: public(HashMap[address, StrategyParams])
204 MAXIMUM_STRATEGIES: constant(uint256) = 20
205 DEGREDATION_COEFFICIENT: constant(uint256) = 10 ** 18
206 
207 # Ordering that `withdraw` uses to determine which strategies to pull funds from
208 # NOTE: Does *NOT* have to match the ordering of all the current strategies that
209 #       exist, but it is recommended that it does or else withdrawal depth is
210 #       limited to only those inside the queue.
211 # NOTE: Ordering is determined by governance, and should be balanced according
212 #       to risk, slippage, and/or volatility. Can also be ordered to increase the
213 #       withdrawal speed of a particular Strategy.
214 # NOTE: The first time a ZERO_ADDRESS is encountered, it stops withdrawing
215 withdrawalQueue: public(address[MAXIMUM_STRATEGIES])
216 
217 emergencyShutdown: public(bool)
218 
219 depositLimit: public(uint256)  # Limit for totalAssets the Vault can hold
220 debtRatio: public(uint256)  # Debt ratio for the Vault across all strategies (in BPS, <= 10k)
221 totalDebt: public(uint256)  # Amount of tokens that all strategies have borrowed
222 lastReport: public(uint256)  # block.timestamp of last report
223 activation: public(uint256)  # block.timestamp of contract deployment
224 lockedProfit: public(uint256) # how much profit is locked and cant be withdrawn
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
285     if self.decimals < 18:
286       self.precisionFactor = 10 ** (18 - self.decimals)
287     else:
288       self.precisionFactor = 1
289 
290     self.governance = governance
291     log UpdateGovernance(governance)
292     self.management = governance
293     log UpdateManagement(governance)
294     self.rewards = rewards
295     log UpdateRewards(rewards)
296     self.guardian = guardian
297     log UpdateGuardian(guardian)
298     self.performanceFee = 1000  # 10% of yield (per Strategy)
299     log UpdatePerformanceFee(convert(1000, uint256))
300     self.managementFee = 200  # 2% per year
301     log UpdateManagementFee(convert(200, uint256))
302     self.lastReport = block.timestamp
303     self.activation = block.timestamp
304     self.lockedProfitDegration = convert(DEGREDATION_COEFFICIENT * 46 /10 ** 6 , uint256) # 6 hours in blocks
305     # EIP-712
306     self.DOMAIN_SEPARATOR = keccak256(
307         concat(
308             DOMAIN_TYPE_HASH,
309             keccak256(convert("Yearn Vault", Bytes[11])),
310             keccak256(convert(API_VERSION, Bytes[28])),
311             convert(chain.id, bytes32),
312             convert(self, bytes32)
313         )
314     )
315 
316 
317 @pure
318 @external
319 def apiVersion() -> String[28]:
320     """
321     @notice
322         Used to track the deployed version of this contract. In practice you
323         can use this version number to compare with Yearn's GitHub and
324         determine which version of the source matches this deployed contract.
325     @dev
326         All strategies must have an `apiVersion()` that matches the Vault's
327         `API_VERSION`.
328     @return API_VERSION which holds the current version of this contract.
329     """
330     return API_VERSION
331 
332 
333 @external
334 def setName(name: String[42]):
335     """
336     @notice
337         Used to change the value of `name`.
338 
339         This may only be called by governance.
340     @param name The new name to use.
341     """
342     assert msg.sender == self.governance
343     self.name = name
344 
345 
346 @external
347 def setSymbol(symbol: String[20]):
348     """
349     @notice
350         Used to change the value of `symbol`.
351 
352         This may only be called by governance.
353     @param symbol The new symbol to use.
354     """
355     assert msg.sender == self.governance
356     self.symbol = symbol
357 
358 
359 # 2-phase commit for a change in governance
360 @external
361 def setGovernance(governance: address):
362     """
363     @notice
364         Nominate a new address to use as governance.
365 
366         The change does not go into effect immediately. This function sets a
367         pending change, and the governance address is not updated until
368         the proposed governance address has accepted the responsibility.
369 
370         This may only be called by the current governance address.
371     @param governance The address requested to take over Vault governance.
372     """
373     assert msg.sender == self.governance
374     self.pendingGovernance = governance
375 
376 
377 @external
378 def acceptGovernance():
379     """
380     @notice
381         Once a new governance address has been proposed using setGovernance(),
382         this function may be called by the proposed address to accept the
383         responsibility of taking over governance for this contract.
384 
385         This may only be called by the proposed governance address.
386     @dev
387         setGovernance() should be called by the existing governance address,
388         prior to calling this function.
389     """
390     assert msg.sender == self.pendingGovernance
391     self.governance = msg.sender
392     log UpdateGovernance(msg.sender)
393 
394 
395 @external
396 def setManagement(management: address):
397     """
398     @notice
399         Changes the management address.
400         Management is able to make some investment decisions adjusting parameters.
401 
402         This may only be called by governance.
403     @param management The address to use for managing.
404     """
405     assert msg.sender == self.governance
406     self.management = management
407     log UpdateManagement(management)
408 
409 
410 @external
411 def setGuestList(guestList: address):
412     """
413     @notice
414         Used to set or change `guestList`. A guest list is another contract
415         that dictates who is allowed to participate in a Vault (and transfer
416         shares).
417 
418         This may only be called by governance.
419     @param guestList The address of the `GuestList` contract to use.
420     """
421     assert msg.sender == self.governance
422     self.guestList = GuestList(guestList)
423     log UpdateGuestList(guestList)
424 
425 
426 @external
427 def setRewards(rewards: address):
428     """
429     @notice
430         Changes the rewards address. Any distributed rewards
431         will cease flowing to the old address and begin flowing
432         to this address once the change is in effect.
433 
434         This will not change any Strategy reports in progress, only
435         new reports made after this change goes into effect.
436 
437         This may only be called by governance.
438     @param rewards The address to use for collecting rewards.
439     """
440     assert msg.sender == self.governance
441     self.rewards = rewards
442     log UpdateRewards(rewards)
443 
444 
445 @external
446 def setLockedProfitDegration(degration: uint256):
447     """
448     @notice
449         Changes the locked profit degration.
450     @param degration The rate of degration in percent per second scaled to 1e18.
451     """
452     assert msg.sender == self.governance
453     # Since "degration" is of type uint256 it can never be less than zero
454     assert degration <= DEGREDATION_COEFFICIENT
455     self.lockedProfitDegration = degration
456 
457 
458 @external
459 def setDepositLimit(limit: uint256):
460     """
461     @notice
462         Changes the maximum amount of tokens that can be deposited in this Vault.
463 
464         Note, this is not how much may be deposited by a single depositor,
465         but the maximum amount that may be deposited across all depositors.
466 
467         This may only be called by governance.
468     @param limit The new deposit limit to use.
469     """
470     assert msg.sender == self.governance
471     self.depositLimit = limit
472     log UpdateDepositLimit(limit)
473 
474 
475 @external
476 def setPerformanceFee(fee: uint256):
477     """
478     @notice
479         Used to change the value of `performanceFee`.
480 
481         Should set this value below the maximum strategist performance fee.
482 
483         This may only be called by governance.
484     @param fee The new performance fee to use.
485     """
486     assert msg.sender == self.governance
487     assert fee <= MAX_BPS
488     self.performanceFee = fee
489     log UpdatePerformanceFee(fee)
490 
491 
492 @external
493 def setManagementFee(fee: uint256):
494     """
495     @notice
496         Used to change the value of `managementFee`.
497 
498         This may only be called by governance.
499     @param fee The new management fee to use.
500     """
501     assert msg.sender == self.governance
502     assert fee <= MAX_BPS
503     self.managementFee = fee
504     log UpdateManagementFee(fee)
505 
506 
507 @external
508 def setGuardian(guardian: address):
509     """
510     @notice
511         Used to change the address of `guardian`.
512 
513         This may only be called by governance or the existing guardian.
514     @param guardian The new guardian address to use.
515     """
516     assert msg.sender in [self.guardian, self.governance]
517     self.guardian = guardian
518     log UpdateGuardian(guardian)
519 
520 
521 @external
522 def setEmergencyShutdown(active: bool):
523     """
524     @notice
525         Activates or deactivates Vault mode where all Strategies go into full
526         withdrawal.
527 
528         During Emergency Shutdown:
529         1. No Users may deposit into the Vault (but may withdraw as usual.)
530         2. Governance may not add new Strategies.
531         3. Each Strategy must pay back their debt as quickly as reasonable to
532             minimally affect their position.
533         4. Only Governance may undo Emergency Shutdown.
534 
535         See contract level note for further details.
536 
537         This may only be called by governance or the guardian.
538     @param active
539         If true, the Vault goes into Emergency Shutdown. If false, the Vault
540         goes back into Normal Operation.
541     """
542     if active:
543         assert msg.sender in [self.guardian, self.governance]
544     else:
545         assert msg.sender == self.governance
546     self.emergencyShutdown = active
547     log EmergencyShutdown(active)
548 
549 
550 @external
551 def setWithdrawalQueue(queue: address[MAXIMUM_STRATEGIES]):
552     """
553     @notice
554         Updates the withdrawalQueue to match the addresses and order specified
555         by `queue`.
556 
557         There can be fewer strategies than the maximum, as well as fewer than
558         the total number of strategies active in the vault. `withdrawalQueue`
559         will be updated in a gas-efficient manner, assuming the input is well-
560         ordered with 0x0 only at the end.
561 
562         This may only be called by governance or management.
563     @dev
564         This is order sensitive, specify the addresses in the order in which
565         funds should be withdrawn (so `queue`[0] is the first Strategy withdrawn
566         from, `queue`[1] is the second, etc.)
567 
568         This means that the least impactful Strategy (the Strategy that will have
569         its core positions impacted the least by having funds removed) should be
570         at `queue`[0], then the next least impactful at `queue`[1], and so on.
571     @param queue
572         The array of addresses to use as the new withdrawal queue. This is
573         order sensitive.
574     """
575     assert msg.sender in [self.management, self.governance]
576     # HACK: Temporary until Vyper adds support for Dynamic arrays
577     for i in range(MAXIMUM_STRATEGIES):
578         if queue[i] == ZERO_ADDRESS and self.withdrawalQueue[i] == ZERO_ADDRESS:
579             break
580         assert self.strategies[queue[i]].activation > 0
581         self.withdrawalQueue[i] = queue[i]
582     log UpdateWithdrawalQueue(queue)
583 
584 
585 @internal
586 def erc20_safe_transfer(token: address, receiver: address, amount: uint256):
587     # Used only to send tokens that are not the type managed by this Vault.
588     # HACK: Used to handle non-compliant tokens like USDT
589     response: Bytes[32] = raw_call(
590         token,
591         concat(
592             method_id("transfer(address,uint256)"),
593             convert(receiver, bytes32),
594             convert(amount, bytes32),
595         ),
596         max_outsize=32,
597     )
598     if len(response) > 0:
599         assert convert(response, bool), "Transfer failed!"
600 
601 
602 @internal
603 def erc20_safe_transferFrom(token: address, sender: address, receiver: address, amount: uint256):
604     # Used only to send tokens that are not the type managed by this Vault.
605     # HACK: Used to handle non-compliant tokens like USDT
606     response: Bytes[32] = raw_call(
607         token,
608         concat(
609             method_id("transferFrom(address,address,uint256)"),
610             convert(sender, bytes32),
611             convert(receiver, bytes32),
612             convert(amount, bytes32),
613         ),
614         max_outsize=32,
615     )
616     if len(response) > 0:
617         assert convert(response, bool), "Transfer failed!"
618 
619 
620 @internal
621 def _transfer(sender: address, receiver: address, amount: uint256):
622     # See note on `transfer()`.
623 
624     # Protect people from accidentally sending their shares to bad places
625     assert not (receiver in [self, ZERO_ADDRESS])
626     self.balanceOf[sender] -= amount
627     self.balanceOf[receiver] += amount
628     log Transfer(sender, receiver, amount)
629 
630 
631 @external
632 def transfer(receiver: address, amount: uint256) -> bool:
633     """
634     @notice
635         Transfers shares from the caller's address to `receiver`. This function
636         will always return true, unless the user is attempting to transfer
637         shares to this contract's address, or to 0x0.
638     @param receiver
639         The address shares are being transferred to. Must not be this contract's
640         address, must not be 0x0.
641     @param amount The quantity of shares to transfer.
642     @return
643         True if transfer is sent to an address other than this contract's or
644         0x0, otherwise the transaction will fail.
645     """
646     self._transfer(msg.sender, receiver, amount)
647     return True
648 
649 
650 @external
651 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
652     """
653     @notice
654         Transfers `amount` shares from `sender` to `receiver`. This operation will
655         always return true, unless the user is attempting to transfer shares
656         to this contract's address, or to 0x0.
657 
658         Unless the caller has given this contract unlimited approval,
659         transfering shares will decrement the caller's `allowance` by `amount`.
660     @param sender The address shares are being transferred from.
661     @param receiver
662         The address shares are being transferred to. Must not be this contract's
663         address, must not be 0x0.
664     @param amount The quantity of shares to transfer.
665     @return
666         True if transfer is sent to an address other than this contract's or
667         0x0, otherwise the transaction will fail.
668     """
669     # Unlimited approval (saves an SSTORE)
670     if (self.allowance[sender][msg.sender] < MAX_UINT256):
671         allowance: uint256 = self.allowance[sender][msg.sender] - amount
672         self.allowance[sender][msg.sender] = allowance
673         # NOTE: Allows log filters to have a full accounting of allowance changes
674         log Approval(sender, msg.sender, allowance)
675     self._transfer(sender, receiver, amount)
676     return True
677 
678 
679 @external
680 def approve(spender: address, amount: uint256) -> bool:
681     """
682     @dev Approve the passed address to spend the specified amount of tokens on behalf of
683          `msg.sender`. Beware that changing an allowance with this method brings the risk
684          that someone may use both the old and the new allowance by unfortunate transaction
685          ordering. See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
686     @param spender The address which will spend the funds.
687     @param amount The amount of tokens to be spent.
688     """
689     self.allowance[msg.sender][spender] = amount
690     log Approval(msg.sender, spender, amount)
691     return True
692 
693 
694 @external
695 def increaseAllowance(spender: address, amount: uint256) -> bool:
696     """
697     @dev Increase the allowance of the passed address to spend the total amount of tokens
698          on behalf of msg.sender. This method mitigates the risk that someone may use both
699          the old and the new allowance by unfortunate transaction ordering.
700          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
701     @param spender The address which will spend the funds.
702     @param amount The amount of tokens to increase the allowance by.
703     """
704     self.allowance[msg.sender][spender] += amount
705     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
706     return True
707 
708 
709 @external
710 def decreaseAllowance(spender: address, amount: uint256) -> bool:
711     """
712     @dev Decrease the allowance of the passed address to spend the total amount of tokens
713          on behalf of msg.sender. This method mitigates the risk that someone may use both
714          the old and the new allowance by unfortunate transaction ordering.
715          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
716     @param spender The address which will spend the funds.
717     @param amount The amount of tokens to decrease the allowance by.
718     """
719     self.allowance[msg.sender][spender] -= amount
720     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
721     return True
722 
723 
724 @external
725 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
726     """
727     @notice
728         Approves spender by owner's signature to expend owner's tokens.
729         See https://eips.ethereum.org/EIPS/eip-2612.
730 
731     @param owner The address which is a source of funds and has signed the Permit.
732     @param spender The address which is allowed to spend the funds.
733     @param amount The amount of tokens to be spent.
734     @param expiry The timestamp after which the Permit is no longer valid.
735     @param signature A valid secp256k1 signature of Permit by owner encoded as r, s, v.
736     @return True, if transaction completes successfully
737     """
738     assert owner != ZERO_ADDRESS  # dev: invalid owner
739     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
740     nonce: uint256 = self.nonces[owner]
741     digest: bytes32 = keccak256(
742         concat(
743             b'\x19\x01',
744             self.DOMAIN_SEPARATOR,
745             keccak256(
746                 concat(
747                     PERMIT_TYPE_HASH,
748                     convert(owner, bytes32),
749                     convert(spender, bytes32),
750                     convert(amount, bytes32),
751                     convert(nonce, bytes32),
752                     convert(expiry, bytes32),
753                 )
754             )
755         )
756     )
757     # NOTE: signature is packed as r, s, v
758     r: uint256 = convert(slice(signature, 0, 32), uint256)
759     s: uint256 = convert(slice(signature, 32, 32), uint256)
760     v: uint256 = convert(slice(signature, 64, 1), uint256)
761     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
762     self.allowance[owner][spender] = amount
763     self.nonces[owner] = nonce + 1
764     log Approval(owner, spender, amount)
765     return True
766 
767 
768 @view
769 @internal
770 def _totalAssets() -> uint256:
771     # See note on `totalAssets()`.
772     return self.token.balanceOf(self) + self.totalDebt
773 
774 
775 @view
776 @external
777 def totalAssets() -> uint256:
778     """
779     @notice
780         Returns the total quantity of all assets under control of this
781         Vault, whether they're loaned out to a Strategy, or currently held in
782         the Vault.
783     @return The total assets under control of this Vault.
784     """
785     return self._totalAssets()
786 
787 
788 @internal
789 def _issueSharesForAmount(to: address, amount: uint256) -> uint256:
790     # Issues `amount` Vault shares to `to`.
791     # Shares must be issued prior to taking on new collateral, or
792     # calculation will be wrong. This means that only *trusted* tokens
793     # (with no capability for exploitative behavior) can be used.
794     shares: uint256 = 0
795     # HACK: Saves 2 SLOADs (~4000 gas)
796     totalSupply: uint256 = self.totalSupply
797     if totalSupply > 0:
798         # Mint amount of shares based on what the Vault is managing overall
799         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
800         precisionFactor: uint256 = self.precisionFactor
801         shares = precisionFactor * amount * totalSupply / self._totalAssets() / precisionFactor
802     else:
803         # No existing shares, so mint 1:1
804         shares = amount
805 
806     # Mint new shares
807     self.totalSupply = totalSupply + shares
808     self.balanceOf[to] += shares
809     log Transfer(ZERO_ADDRESS, to, shares)
810 
811     return shares
812 
813 
814 @external
815 @nonreentrant("withdraw")
816 def deposit(_amount: uint256 = MAX_UINT256, recipient: address = msg.sender) -> uint256:
817     """
818     @notice
819         Deposits `_amount` `token`, issuing shares to `recipient`. If the
820         Vault is in Emergency Shutdown, deposits will not be accepted and this
821         call will fail.
822     @dev
823         Measuring quantity of shares to issues is based on the total
824         outstanding debt that this contract has ("expected value") instead
825         of the total balance sheet it has ("estimated value") has important
826         security considerations, and is done intentionally. If this value were
827         measured against external systems, it could be purposely manipulated by
828         an attacker to withdraw more assets than they otherwise should be able
829         to claim by redeeming their shares.
830 
831         On deposit, this means that shares are issued against the total amount
832         that the deposited capital can be given in service of the debt that
833         Strategies assume. If that number were to be lower than the "expected
834         value" at some future point, depositing shares via this method could
835         entitle the depositor to *less* than the deposited value once the
836         "realized value" is updated from further reports by the Strategies
837         to the Vaults.
838 
839         Care should be taken by integrators to account for this discrepancy,
840         by using the view-only methods of this contract (both off-chain and
841         on-chain) to determine if depositing into the Vault is a "good idea".
842     @param _amount The quantity of tokens to deposit, defaults to all.
843     @param recipient
844         The address to issue the shares in this Vault to. Defaults to the
845         caller's address.
846     @return The issued Vault shares.
847     """
848     assert not self.emergencyShutdown  # Deposits are locked out
849 
850     amount: uint256 = _amount
851 
852     # If _amount not specified, transfer the full token balance,
853     # up to deposit limit
854     if amount == MAX_UINT256:
855         amount = min(
856             self.depositLimit - self._totalAssets(),
857             self.token.balanceOf(msg.sender),
858         )
859     else:
860         # Ensure deposit limit is respected
861         assert self._totalAssets() + amount <= self.depositLimit
862 
863     # Ensure we are depositing something
864     assert amount > 0
865 
866     # Ensure deposit is permitted by guest list
867     if self.guestList.address != ZERO_ADDRESS:
868         assert self.guestList.authorized(msg.sender, amount)
869 
870     # Issue new shares (needs to be done before taking deposit to be accurate)
871     # Shares are issued to recipient (may be different from msg.sender)
872     # See @dev note, above.
873     shares: uint256 = self._issueSharesForAmount(recipient, amount)
874 
875     # Tokens are transferred from msg.sender (may be different from _recipient)
876     self.erc20_safe_transferFrom(self.token.address, msg.sender, self, amount)
877 
878     return shares  # Just in case someone wants them
879 
880 
881 @view
882 @internal
883 def _shareValue(shares: uint256) -> uint256:
884     # Returns price = 1:1 if vault is empty
885     if self.totalSupply == 0:
886         return shares
887 
888     # Determines the current value of `shares`.
889         # NOTE: if sqrt(Vault.totalAssets()) >>> 1e39, this could potentially revert
890     lockedFundsRatio: uint256 = (block.timestamp - self.lastReport) * self.lockedProfitDegration
891     freeFunds: uint256 = self._totalAssets()
892     precisionFactor: uint256 = self.precisionFactor
893     if(lockedFundsRatio < DEGREDATION_COEFFICIENT):
894         freeFunds -= (
895             self.lockedProfit
896              - (
897                  precisionFactor
898                  * lockedFundsRatio
899                  * self.lockedProfit
900                  / DEGREDATION_COEFFICIENT
901                  / precisionFactor
902              )
903          )
904     # NOTE: using 1e3 for extra precision here, when decimals is low
905     return (
906         precisionFactor
907        * shares
908         * freeFunds
909         / self.totalSupply
910         / precisionFactor
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
921         precisionFactor: uint256 = self.precisionFactor
922         return  (
923             precisionFactor
924             * amount
925             * self.totalSupply
926             / self._totalAssets()
927             / precisionFactor
928         )
929     else:
930         return 0
931 
932 
933 @view
934 @external
935 def maxAvailableShares() -> uint256:
936     """
937     @notice
938         Determines the maximum quantity of shares this Vault can facilitate a
939         withdrawal for, factoring in assets currently residing in the Vault,
940         as well as those deployed to strategies on the Vault's balance sheet.
941     @dev
942         Regarding how shares are calculated, see dev note on `deposit`.
943 
944         If you want to calculated the maximum a user could withdraw up to,
945         you want to use this function.
946 
947         Note that the amount provided by this function is the theoretical
948         maximum possible from withdrawing, the real amount depends on the
949         realized losses incurred during withdrawal.
950     @return The total quantity of shares this Vault can provide.
951     """
952     shares: uint256 = self._sharesForAmount(self.token.balanceOf(self))
953 
954     for strategy in self.withdrawalQueue:
955         if strategy == ZERO_ADDRESS:
956             break
957         shares += self._sharesForAmount(self.strategies[strategy].totalDebt)
958 
959     return shares
960 
961 
962 @internal
963 def _reportLoss(strategy: address, loss: uint256):
964     # Loss can only be up the amount of debt issued to strategy
965     totalDebt: uint256 = self.strategies[strategy].totalDebt
966     assert totalDebt >= loss
967     self.strategies[strategy].totalLoss += loss
968     self.strategies[strategy].totalDebt = totalDebt - loss
969     self.totalDebt -= loss
970 
971     # Also, make sure we reduce our trust with the strategy by the same amount
972     debtRatio: uint256 = self.strategies[strategy].debtRatio
973     precisionFactor: uint256 = self.precisionFactor
974     ratio_change: uint256 = min(precisionFactor * loss * MAX_BPS / self._totalAssets() / precisionFactor, debtRatio)
975     self.strategies[strategy].debtRatio -= ratio_change
976     self.debtRatio -= ratio_change
977 
978 
979 @external
980 @nonreentrant("withdraw")
981 def withdraw(
982     maxShares: uint256 = MAX_UINT256,
983     recipient: address = msg.sender,
984     maxLoss: uint256 = 1,  # 0.01% [BPS]
985 ) -> uint256:
986     """
987     @notice
988         Withdraws the calling account's tokens from this Vault, redeeming
989         amount `_shares` for an appropriate amount of tokens.
990 
991         See note on `setWithdrawalQueue` for further details of withdrawal
992         ordering and behavior.
993     @dev
994         Measuring the value of shares is based on the total outstanding debt
995         that this contract has ("expected value") instead of the total balance
996         sheet it has ("estimated value") has important security considerations,
997         and is done intentionally. If this value were measured against external
998         systems, it could be purposely manipulated by an attacker to withdraw
999         more assets than they otherwise should be able to claim by redeeming
1000         their shares.
1001 
1002         On withdrawal, this means that shares are redeemed against the total
1003         amount that the deposited capital had "realized" since the point it
1004         was deposited, up until the point it was withdrawn. If that number
1005         were to be higher than the "expected value" at some future point,
1006         withdrawing shares via this method could entitle the depositor to
1007         *more* than the expected value once the "realized value" is updated
1008         from further reports by the Strategies to the Vaults.
1009 
1010         Under exceptional scenarios, this could cause earlier withdrawals to
1011         earn "more" of the underlying assets than Users might otherwise be
1012         entitled to, if the Vault's estimated value were otherwise measured
1013         through external means, accounting for whatever exceptional scenarios
1014         exist for the Vault (that aren't covered by the Vault's own design.)
1015     @param maxShares
1016         How many shares to try and redeem for tokens, defaults to all.
1017     @param recipient
1018         The address to issue the shares in this Vault to. Defaults to the
1019         caller's address.
1020     @param maxLoss
1021         The maximum acceptable loss to sustain on withdrawal. Defaults to 0.01%.
1022     @return The quantity of tokens redeemed for `_shares`.
1023     """
1024     shares: uint256 = maxShares  # May reduce this number below
1025 
1026     # Max Loss is <=100%, revert otherwise
1027     assert maxLoss <= MAX_BPS
1028 
1029     # If _shares not specified, transfer full share balance
1030     if shares == MAX_UINT256:
1031         shares = self.balanceOf[msg.sender]
1032 
1033     # Limit to only the shares they own
1034     assert shares <= self.balanceOf[msg.sender]
1035 
1036     # Ensure we are withdrawing something
1037     assert shares > 0
1038 
1039     # See @dev note, above.
1040     value: uint256 = self._shareValue(shares)
1041 
1042     totalLoss: uint256 = 0
1043     if value > self.token.balanceOf(self):
1044         # We need to go get some from our strategies in the withdrawal queue
1045         # NOTE: This performs forced withdrawals from each Strategy. During
1046         #       forced withdrawal, a Strategy may realize a loss. That loss
1047         #       is reported back to the Vault, and the will affect the amount
1048         #       of tokens that the withdrawer receives for their shares. They
1049         #       can optionally specify the maximum acceptable loss (in BPS)
1050         #       to prevent excessive losses on their withdrawals (which may
1051         #       happen in certain edge cases where Strategies realize a loss)
1052         for strategy in self.withdrawalQueue:
1053             if strategy == ZERO_ADDRESS:
1054                 break  # We've exhausted the queue
1055 
1056             vault_balance: uint256 = self.token.balanceOf(self)
1057             if value <= vault_balance:
1058                 break  # We're done withdrawing
1059 
1060             amountNeeded: uint256 = value - vault_balance
1061 
1062             # NOTE: Don't withdraw more than the debt so that Strategy can still
1063             #       continue to work based on the profits it has
1064             # NOTE: This means that user will lose out on any profits that each
1065             #       Strategy in the queue would return on next harvest, benefiting others
1066             amountNeeded = min(amountNeeded, self.strategies[strategy].totalDebt)
1067             if amountNeeded == 0:
1068                 continue  # Nothing to withdraw from this Strategy, try the next one
1069 
1070             # Force withdraw amount from each Strategy in the order set by governance
1071             loss: uint256 = Strategy(strategy).withdraw(amountNeeded)
1072             withdrawn: uint256 = self.token.balanceOf(self) - vault_balance
1073 
1074             # NOTE: Withdrawer incurs any losses from liquidation
1075             if loss > 0:
1076                 value -= loss
1077                 totalLoss += loss
1078                 self._reportLoss(strategy, loss)
1079 
1080             # Reduce the Strategy's debt by the amount withdrawn ("realized returns")
1081             # NOTE: This doesn't add to returns as it's not earned by "normal means"
1082             self.strategies[strategy].totalDebt -= withdrawn
1083             self.totalDebt -= withdrawn
1084 
1085     # NOTE: We have withdrawn everything possible out of the withdrawal queue
1086     #       but we still don't have enough to fully pay them back, so adjust
1087     #       to the total amount we've freed up through forced withdrawals
1088     vault_balance: uint256 = self.token.balanceOf(self)
1089     if value > vault_balance:
1090         value = vault_balance
1091         # NOTE: Burn # of shares that corresponds to what Vault has on-hand,
1092         #       including the losses that were incurred above during withdrawals
1093         shares = self._sharesForAmount(value + totalLoss)
1094 
1095     # NOTE: This loss protection is put in place to revert if losses from
1096     #       withdrawing are more than what is considered acceptable.
1097     precisionFactor: uint256 = self.precisionFactor
1098     assert totalLoss <= precisionFactor * maxLoss * (value + totalLoss) / MAX_BPS / precisionFactor
1099 
1100     # Burn shares (full value of what is being withdrawn)
1101     self.totalSupply -= shares
1102     self.balanceOf[msg.sender] -= shares
1103     log Transfer(msg.sender, ZERO_ADDRESS, shares)
1104 
1105     # Withdraw remaining balance to _recipient (may be different to msg.sender) (minus fee)
1106     self.erc20_safe_transfer(self.token.address, recipient, value)
1107 
1108     return value
1109 
1110 
1111 @view
1112 @external
1113 def pricePerShare() -> uint256:
1114     """
1115     @notice Gives the price for a single Vault share.
1116     @dev See dev note on `withdraw`.
1117     @return The value of a single share.
1118     """
1119     return self._shareValue(10 ** self.decimals)
1120 
1121 
1122 @internal
1123 def _organizeWithdrawalQueue():
1124     # Reorganize `withdrawalQueue` based on premise that if there is an
1125     # empty value between two actual values, then the empty value should be
1126     # replaced by the later value.
1127     # NOTE: Relative ordering of non-zero values is maintained.
1128     offset: uint256 = 0
1129     for idx in range(MAXIMUM_STRATEGIES):
1130         strategy: address = self.withdrawalQueue[idx]
1131         if strategy == ZERO_ADDRESS:
1132             offset += 1  # how many values we need to shift, always `<= idx`
1133         elif offset > 0:
1134             self.withdrawalQueue[idx - offset] = strategy
1135             self.withdrawalQueue[idx] = ZERO_ADDRESS
1136 
1137 
1138 @external
1139 def addStrategy(
1140     strategy: address,
1141     debtRatio: uint256,
1142     minDebtPerHarvest: uint256,
1143     maxDebtPerHarvest: uint256,
1144     performanceFee: uint256,
1145 ):
1146     """
1147     @notice
1148         Add a Strategy to the Vault.
1149 
1150         This may only be called by governance.
1151     @dev
1152         The Strategy will be appended to `withdrawalQueue`, call
1153         `setWithdrawalQueue` to change the order.
1154     @param strategy The address of the Strategy to add.
1155     @param debtRatio
1156         The share of the total assets in the `vault that the `strategy` has access to.
1157     @param minDebtPerHarvest
1158         Lower limit on the increase of debt since last harvest
1159     @param maxDebtPerHarvest
1160         Upper limit on the increase of debt since last harvest
1161     @param performanceFee
1162         The fee the strategist will receive based on this Vault's performance.
1163     """
1164     # Check if queue is full
1165     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1166 
1167     # Check calling conditions
1168     assert not self.emergencyShutdown
1169     assert msg.sender == self.governance
1170 
1171     # Check strategy configuration
1172     assert strategy != ZERO_ADDRESS
1173     assert self.strategies[strategy].activation == 0
1174     assert self == Strategy(strategy).vault()
1175     assert self.token.address == Strategy(strategy).want()
1176 
1177     # Check strategy parameters
1178     assert self.debtRatio + debtRatio <= MAX_BPS
1179     assert minDebtPerHarvest <= maxDebtPerHarvest
1180     assert performanceFee <= MAX_BPS - self.performanceFee
1181 
1182     # Add strategy to approved strategies
1183     self.strategies[strategy] = StrategyParams({
1184         performanceFee: performanceFee,
1185         activation: block.timestamp,
1186         debtRatio: debtRatio,
1187         minDebtPerHarvest: minDebtPerHarvest,
1188         maxDebtPerHarvest: maxDebtPerHarvest,
1189         lastReport: block.timestamp,
1190         totalDebt: 0,
1191         totalGain: 0,
1192         totalLoss: 0,
1193     })
1194     log StrategyAdded(strategy, debtRatio, minDebtPerHarvest, maxDebtPerHarvest, performanceFee)
1195 
1196     # Update Vault parameters
1197     self.debtRatio += debtRatio
1198 
1199     # Add strategy to the end of the withdrawal queue
1200     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1201     self._organizeWithdrawalQueue()
1202 
1203 
1204 @external
1205 def updateStrategyDebtRatio(
1206     strategy: address,
1207     debtRatio: uint256,
1208 ):
1209     """
1210     @notice
1211         Change the quantity of assets `strategy` may manage.
1212 
1213         This may be called by governance or management.
1214     @param strategy The Strategy to update.
1215     @param debtRatio The quantity of assets `strategy` may now manage.
1216     """
1217     assert msg.sender in [self.management, self.governance]
1218     assert self.strategies[strategy].activation > 0
1219     self.debtRatio -= self.strategies[strategy].debtRatio
1220     self.strategies[strategy].debtRatio = debtRatio
1221     self.debtRatio += debtRatio
1222     assert self.debtRatio <= MAX_BPS
1223     log StrategyUpdateDebtRatio(strategy, debtRatio)
1224 
1225 
1226 @external
1227 def updateStrategyMinDebtPerHarvest(
1228     strategy: address,
1229     minDebtPerHarvest: uint256,
1230 ):
1231     """
1232     @notice
1233         Change the quantity assets per block this Vault may deposit to or
1234         withdraw from `strategy`.
1235 
1236         This may only be called by governance or management.
1237     @param strategy The Strategy to update.
1238     @param minDebtPerHarvest
1239         Lower limit on the increase of debt since last harvest
1240     """
1241     assert msg.sender in [self.management, self.governance]
1242     assert self.strategies[strategy].activation > 0
1243     assert self.strategies[strategy].maxDebtPerHarvest >= minDebtPerHarvest
1244     self.strategies[strategy].minDebtPerHarvest = minDebtPerHarvest
1245     log StrategyUpdateMinDebtPerHarvest(strategy, minDebtPerHarvest)
1246 
1247 
1248 @external
1249 def updateStrategyMaxDebtPerHarvest(
1250     strategy: address,
1251     maxDebtPerHarvest: uint256,
1252 ):
1253     """
1254     @notice
1255         Change the quantity assets per block this Vault may deposit to or
1256         withdraw from `strategy`.
1257 
1258         This may only be called by governance or management.
1259     @param strategy The Strategy to update.
1260     @param maxDebtPerHarvest
1261         Upper limit on the increase of debt since last harvest
1262     """
1263     assert msg.sender in [self.management, self.governance]
1264     assert self.strategies[strategy].activation > 0
1265     assert self.strategies[strategy].minDebtPerHarvest <= maxDebtPerHarvest
1266     self.strategies[strategy].maxDebtPerHarvest = maxDebtPerHarvest
1267     log StrategyUpdateMaxDebtPerHarvest(strategy, maxDebtPerHarvest)
1268 
1269 
1270 @external
1271 def updateStrategyPerformanceFee(
1272     strategy: address,
1273     performanceFee: uint256,
1274 ):
1275     """
1276     @notice
1277         Change the fee the strategist will receive based on this Vault's
1278         performance.
1279 
1280         This may only be called by governance.
1281     @param strategy The Strategy to update.
1282     @param performanceFee The new fee the strategist will receive.
1283     """
1284     assert msg.sender == self.governance
1285     assert performanceFee <= MAX_BPS - self.performanceFee
1286     assert self.strategies[strategy].activation > 0
1287     self.strategies[strategy].performanceFee = performanceFee
1288     log StrategyUpdatePerformanceFee(strategy, performanceFee)
1289 
1290 
1291 @internal
1292 def _revokeStrategy(strategy: address):
1293     self.debtRatio -= self.strategies[strategy].debtRatio
1294     self.strategies[strategy].debtRatio = 0
1295     log StrategyRevoked(strategy)
1296 
1297 
1298 @external
1299 def migrateStrategy(oldVersion: address, newVersion: address):
1300     """
1301     @notice
1302         Migrates a Strategy, including all assets from `oldVersion` to
1303         `newVersion`.
1304 
1305         This may only be called by governance.
1306     @dev
1307         Strategy must successfully migrate all capital and positions to new
1308         Strategy, or else this will upset the balance of the Vault.
1309 
1310         The new Strategy should be "empty" e.g. have no prior commitments to
1311         this Vault, otherwise it could have issues.
1312     @param oldVersion The existing Strategy to migrate from.
1313     @param newVersion The new Strategy to migrate to.
1314     """
1315     assert msg.sender == self.governance
1316     assert newVersion != ZERO_ADDRESS
1317     assert self.strategies[oldVersion].activation > 0
1318     assert self.strategies[newVersion].activation == 0
1319 
1320     strategy: StrategyParams = self.strategies[oldVersion]
1321 
1322     self._revokeStrategy(oldVersion)
1323     # _revokeStrategy will lower the debtRatio
1324     self.debtRatio += strategy.debtRatio
1325     # Debt is migrated to new strategy
1326     self.strategies[oldVersion].totalDebt = 0
1327 
1328     self.strategies[newVersion] = StrategyParams({
1329         performanceFee: strategy.performanceFee,
1330         # NOTE: use last report for activation time, so E[R] calc works
1331         activation: strategy.lastReport,
1332         debtRatio: strategy.debtRatio,
1333         minDebtPerHarvest: strategy.minDebtPerHarvest,
1334         maxDebtPerHarvest: strategy.maxDebtPerHarvest,
1335         lastReport: strategy.lastReport,
1336         totalDebt: strategy.totalDebt,
1337         totalGain: 0,
1338         totalLoss: 0,
1339     })
1340 
1341     Strategy(oldVersion).migrate(newVersion)
1342     log StrategyMigrated(oldVersion, newVersion)
1343 
1344     for idx in range(MAXIMUM_STRATEGIES):
1345         if self.withdrawalQueue[idx] == oldVersion:
1346             self.withdrawalQueue[idx] = newVersion
1347             return  # Don't need to reorder anything because we swapped
1348 
1349 
1350 @external
1351 def revokeStrategy(strategy: address = msg.sender):
1352     """
1353     @notice
1354         Revoke a Strategy, setting its debt limit to 0 and preventing any
1355         future deposits.
1356 
1357         This function should only be used in the scenario where the Strategy is
1358         being retired but no migration of the positions are possible, or in the
1359         extreme scenario that the Strategy needs to be put into "Emergency Exit"
1360         mode in order for it to exit as quickly as possible. The latter scenario
1361         could be for any reason that is considered "critical" that the Strategy
1362         exits its position as fast as possible, such as a sudden change in market
1363         conditions leading to losses, or an imminent failure in an external
1364         dependency.
1365 
1366         This may only be called by governance, the guardian, or the Strategy
1367         itself. Note that a Strategy will only revoke itself during emergency
1368         shutdown.
1369     @param strategy The Strategy to revoke.
1370     """
1371     assert msg.sender in [strategy, self.governance, self.guardian]
1372     self._revokeStrategy(strategy)
1373 
1374 
1375 @external
1376 def addStrategyToQueue(strategy: address):
1377     """
1378     @notice
1379         Adds `strategy` to `withdrawalQueue`.
1380 
1381         This may only be called by governance or management.
1382     @dev
1383         The Strategy will be appended to `withdrawalQueue`, call
1384         `setWithdrawalQueue` to change the order.
1385     @param strategy The Strategy to add.
1386     """
1387     assert msg.sender in [self.management, self.governance]
1388     # Must be a current Strategy
1389     assert self.strategies[strategy].activation > 0
1390     # Can't already be in the queue
1391     last_idx: uint256 = 0
1392     for s in self.withdrawalQueue:
1393         if s == ZERO_ADDRESS:
1394             break
1395         assert s != strategy
1396         last_idx += 1
1397     # Check if queue is full
1398     assert last_idx < MAXIMUM_STRATEGIES
1399 
1400     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1401     self._organizeWithdrawalQueue()
1402     log StrategyAddedToQueue(strategy)
1403 
1404 
1405 @external
1406 def removeStrategyFromQueue(strategy: address):
1407     """
1408     @notice
1409         Remove `strategy` from `withdrawalQueue`.
1410 
1411         This may only be called by governance or management.
1412     @dev
1413         We don't do this with revokeStrategy because it should still
1414         be possible to withdraw from the Strategy if it's unwinding.
1415     @param strategy The Strategy to remove.
1416     """
1417     assert msg.sender in [self.management, self.governance]
1418     for idx in range(MAXIMUM_STRATEGIES):
1419         if self.withdrawalQueue[idx] == strategy:
1420             self.withdrawalQueue[idx] = ZERO_ADDRESS
1421             self._organizeWithdrawalQueue()
1422             log StrategyRemovedFromQueue(strategy)
1423             return  # We found the right location and cleared it
1424     raise  # We didn't find the Strategy in the queue
1425 
1426 
1427 @view
1428 @internal
1429 def _debtOutstanding(strategy: address) -> uint256:
1430     # See note on `debtOutstanding()`.
1431     precisionFactor: uint256 = self.precisionFactor
1432     strategy_debtLimit: uint256 = (
1433         precisionFactor
1434         * self.strategies[strategy].debtRatio
1435         * self._totalAssets()
1436         / MAX_BPS
1437         / precisionFactor
1438     )
1439     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1440 
1441     if self.emergencyShutdown:
1442         return strategy_totalDebt
1443     elif strategy_totalDebt <= strategy_debtLimit:
1444         return 0
1445     else:
1446         return strategy_totalDebt - strategy_debtLimit
1447 
1448 
1449 @view
1450 @external
1451 def debtOutstanding(strategy: address = msg.sender) -> uint256:
1452     """
1453     @notice
1454         Determines if `strategy` is past its debt limit and if any tokens
1455         should be withdrawn to the Vault.
1456     @param strategy The Strategy to check. Defaults to the caller.
1457     @return The quantity of tokens to withdraw.
1458     """
1459     return self._debtOutstanding(strategy)
1460 
1461 
1462 @view
1463 @internal
1464 def _creditAvailable(strategy: address) -> uint256:
1465     # See note on `creditAvailable()`.
1466     if self.emergencyShutdown:
1467         return 0
1468     precisionFactor: uint256 = self.precisionFactor
1469     vault_totalAssets: uint256 = self._totalAssets()
1470     vault_debtLimit: uint256 = precisionFactor * self.debtRatio * vault_totalAssets / MAX_BPS / precisionFactor
1471     vault_totalDebt: uint256 = self.totalDebt
1472     strategy_debtLimit: uint256 = precisionFactor * self.strategies[strategy].debtRatio * vault_totalAssets / MAX_BPS / precisionFactor
1473     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1474     strategy_minDebtPerHarvest: uint256 = self.strategies[strategy].minDebtPerHarvest
1475     strategy_maxDebtPerHarvest: uint256 = self.strategies[strategy].maxDebtPerHarvest
1476 
1477     # Exhausted credit line
1478     if strategy_debtLimit <= strategy_totalDebt or vault_debtLimit <= vault_totalDebt:
1479         return 0
1480 
1481     # Start with debt limit left for the Strategy
1482     available: uint256 = strategy_debtLimit - strategy_totalDebt
1483 
1484     # Adjust by the global debt limit left
1485     available = min(available, vault_debtLimit - vault_totalDebt)
1486 
1487     # Can only borrow up to what the contract has in reserve
1488     # NOTE: Running near 100% is discouraged
1489     available = min(available, self.token.balanceOf(self))
1490 
1491     # Adjust by min and max borrow limits (per harvest)
1492     # NOTE: min increase can be used to ensure that if a strategy has a minimum
1493     #       amount of capital needed to purchase a position, it's not given capital
1494     #       it can't make use of yet.
1495     # NOTE: max increase is used to make sure each harvest isn't bigger than what
1496     #       is authorized. This combined with adjusting min and max periods in
1497     #       `BaseStrategy` can be used to effect a "rate limit" on capital increase.
1498     if available < strategy_minDebtPerHarvest:
1499         return 0
1500     else:
1501         return min(available, strategy_maxDebtPerHarvest)
1502 
1503 @view
1504 @external
1505 def creditAvailable(strategy: address = msg.sender) -> uint256:
1506     """
1507     @notice
1508         Amount of tokens in Vault a Strategy has access to as a credit line.
1509 
1510         This will check the Strategy's debt limit, as well as the tokens
1511         available in the Vault, and determine the maximum amount of tokens
1512         (if any) the Strategy may draw on.
1513 
1514         In the rare case the Vault is in emergency shutdown this will return 0.
1515     @param strategy The Strategy to check. Defaults to caller.
1516     @return The quantity of tokens available for the Strategy to draw on.
1517     """
1518     return self._creditAvailable(strategy)
1519 
1520 
1521 @view
1522 @internal
1523 def _expectedReturn(strategy: address) -> uint256:
1524     # See note on `expectedReturn()`.
1525     strategy_lastReport: uint256 = self.strategies[strategy].lastReport
1526     timeSinceLastHarvest: uint256 = block.timestamp - strategy_lastReport
1527     totalHarvestTime: uint256 = strategy_lastReport - self.strategies[strategy].activation
1528 
1529     # NOTE: If either `timeSinceLastHarvest` or `totalHarvestTime` is 0, we can short-circuit to `0`
1530     if timeSinceLastHarvest > 0 and totalHarvestTime > 0 and Strategy(strategy).isActive():
1531         # NOTE: Unlikely to throw unless strategy accumalates >1e68 returns
1532         # NOTE: Calculate average over period of time where harvests have occured in the past
1533         precisionFactor: uint256 = self.precisionFactor
1534         return (
1535             precisionFactor
1536             * self.strategies[strategy].totalGain
1537             * timeSinceLastHarvest
1538             / totalHarvestTime
1539             / precisionFactor
1540         )
1541     else:
1542         return 0  # Covers the scenario when block.timestamp == activation
1543 
1544 
1545 @view
1546 @external
1547 def availableDepositLimit() -> uint256:
1548     if self.depositLimit > self._totalAssets():
1549         return self.depositLimit - self._totalAssets()
1550     else:
1551         return 0
1552 
1553 
1554 @view
1555 @external
1556 def expectedReturn(strategy: address = msg.sender) -> uint256:
1557     """
1558     @notice
1559         Provide an accurate expected value for the return this `strategy`
1560         would provide to the Vault the next time `report()` is called
1561         (since the last time it was called).
1562     @param strategy The Strategy to determine the expected return for. Defaults to caller.
1563     @return
1564         The anticipated amount `strategy` should make on its investment
1565         since its last report.
1566     """
1567     return self._expectedReturn(strategy)
1568 
1569 
1570 @internal
1571 def _assessFees(strategy: address, gain: uint256) -> uint256:
1572     # Issue new shares to cover fees
1573     # NOTE: In effect, this reduces overall share price by the combined fee
1574     # NOTE: may throw if Vault.totalAssets() > 1e64, or not called for more than a year
1575     precisionFactor: uint256 = self.precisionFactor
1576     management_fee: uint256 = (
1577         precisionFactor *
1578         (
1579             (self.strategies[strategy].totalDebt - Strategy(strategy).delegatedAssets())
1580             * (block.timestamp - self.strategies[strategy].lastReport)
1581             * self.managementFee
1582         )
1583         / MAX_BPS
1584         / SECS_PER_YEAR
1585         / precisionFactor
1586     )
1587 
1588     # Only applies in certain conditions
1589     strategist_fee: uint256 = 0
1590     performance_fee: uint256 = 0
1591 
1592     # NOTE: Applies if Strategy is not shutting down, or it is but all debt paid off
1593     # NOTE: No fee is taken when a Strategy is unwinding it's position, until all debt is paid
1594     if gain > 0:
1595         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1596         strategist_fee = (
1597             precisionFactor
1598             * gain
1599             * self.strategies[strategy].performanceFee
1600             / MAX_BPS
1601             / precisionFactor
1602         )
1603         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1604         performance_fee = precisionFactor * gain * self.performanceFee / MAX_BPS / precisionFactor
1605 
1606     # NOTE: This must be called prior to taking new collateral,
1607     #       or the calculation will be wrong!
1608     # NOTE: This must be done at the same time, to ensure the relative
1609     #       ratio of governance_fee : strategist_fee is kept intact
1610     total_fee: uint256 = performance_fee + strategist_fee + management_fee
1611     # ensure total_fee is not more than gain
1612     if total_fee > gain:
1613         total_fee = gain
1614         # if total performance fee is greater than 100% then this will cause an underflow
1615         management_fee = gain - performance_fee - strategist_fee
1616     if total_fee > 0:  # NOTE: If mgmt fee is 0% and no gains were realized, skip
1617         reward: uint256 = self._issueSharesForAmount(self, total_fee)
1618 
1619         # Send the rewards out as new shares in this Vault
1620         if strategist_fee > 0:  # NOTE: Guard against DIV/0 fault
1621             # NOTE: Unlikely to throw unless sqrt(reward) >>> 1e39
1622             strategist_reward: uint256 = (
1623                 precisionFactor
1624                 * strategist_fee
1625                 * reward
1626                 / total_fee
1627                 / precisionFactor
1628             )
1629             self._transfer(self, strategy, strategist_reward)
1630             # NOTE: Strategy distributes rewards at the end of harvest()
1631         # NOTE: Governance earns any dust leftover from flooring math above
1632         if self.balanceOf[self] > 0:
1633             self._transfer(self, self.rewards, self.balanceOf[self])
1634     return total_fee
1635 
1636 
1637 @external
1638 def report(gain: uint256, loss: uint256, _debtPayment: uint256) -> uint256:
1639     """
1640     @notice
1641         Reports the amount of assets the calling Strategy has free (usually in
1642         terms of ROI).
1643 
1644         The performance fee is determined here, off of the strategy's profits
1645         (if any), and sent to governance.
1646 
1647         The strategist's fee is also determined here (off of profits), to be
1648         handled according to the strategist on the next harvest.
1649 
1650         This may only be called by a Strategy managed by this Vault.
1651     @dev
1652         For approved strategies, this is the most efficient behavior.
1653         The Strategy reports back what it has free, then Vault "decides"
1654         whether to take some back or give it more. Note that the most it can
1655         take is `gain + _debtPayment`, and the most it can give is all of the
1656         remaining reserves. Anything outside of those bounds is abnormal behavior.
1657 
1658         All approved strategies must have increased diligence around
1659         calling this function, as abnormal behavior could become catastrophic.
1660     @param gain
1661         Amount Strategy has realized as a gain on it's investment since its
1662         last report, and is free to be given back to Vault as earnings
1663     @param loss
1664         Amount Strategy has realized as a loss on it's investment since its
1665         last report, and should be accounted for on the Vault's balance sheet
1666     @param _debtPayment
1667         Amount Strategy has made available to cover outstanding debt
1668     @return Amount of debt outstanding (if totalDebt > debtLimit or emergency shutdown).
1669     """
1670 
1671     # Only approved strategies can call this function
1672     assert self.strategies[msg.sender].activation > 0
1673     # No lying about total available to withdraw!
1674     assert self.token.balanceOf(msg.sender) >= gain + _debtPayment
1675 
1676     # We have a loss to report, do it before the rest of the calculations
1677     if loss > 0:
1678         self._reportLoss(msg.sender, loss)
1679 
1680     # Assess both management fee and performance fee, and issue both as shares of the vault
1681     totalFees: uint256 = self._assessFees(msg.sender, gain)
1682 
1683     # Returns are always "realized gains"
1684     self.strategies[msg.sender].totalGain += gain
1685 
1686     # Outstanding debt the Strategy wants to take back from the Vault (if any)
1687     # NOTE: debtOutstanding <= StrategyParams.totalDebt
1688     debt: uint256 = self._debtOutstanding(msg.sender)
1689     debtPayment: uint256 = min(_debtPayment, debt)
1690 
1691     if debtPayment > 0:
1692         self.strategies[msg.sender].totalDebt -= debtPayment
1693         self.totalDebt -= debtPayment
1694         debt -= debtPayment
1695         # NOTE: `debt` is being tracked for later
1696 
1697     # Compute the line of credit the Vault is able to offer the Strategy (if any)
1698     credit: uint256 = self._creditAvailable(msg.sender)
1699 
1700     # Update the actual debt based on the full credit we are extending to the Strategy
1701     # or the returns if we are taking funds back
1702     # NOTE: credit + self.strategies[msg.sender].totalDebt is always < self.debtLimit
1703     # NOTE: At least one of `credit` or `debt` is always 0 (both can be 0)
1704     if credit > 0:
1705         self.strategies[msg.sender].totalDebt += credit
1706         self.totalDebt += credit
1707 
1708     # Give/take balance to Strategy, based on the difference between the reported gains
1709     # (if any), the debt payment (if any), the credit increase we are offering (if any),
1710     # and the debt needed to be paid off (if any)
1711     # NOTE: This is just used to adjust the balance of tokens between the Strategy and
1712     #       the Vault based on the Strategy's debt limit (as well as the Vault's).
1713     totalAvail: uint256 = gain + debtPayment
1714     if totalAvail < credit:  # credit surplus, give to Strategy
1715         self.erc20_safe_transfer(self.token.address, msg.sender, credit - totalAvail)
1716     elif totalAvail > credit:  # credit deficit, take from Strategy
1717         self.erc20_safe_transferFrom(self.token.address, msg.sender, self, totalAvail - credit)
1718     # else, don't do anything because it is balanced
1719 
1720     # Update reporting time
1721     self.strategies[msg.sender].lastReport = block.timestamp
1722     self.lastReport = block.timestamp
1723     self.lockedProfit = gain  - totalFees  # profit is locked and gradually released per block
1724 
1725     log StrategyReported(
1726         msg.sender,
1727         gain,
1728         loss,
1729         debtPayment,
1730         self.strategies[msg.sender].totalGain,
1731         self.strategies[msg.sender].totalLoss,
1732         self.strategies[msg.sender].totalDebt,
1733         credit,
1734         self.strategies[msg.sender].debtRatio,
1735     )
1736 
1737     if self.strategies[msg.sender].debtRatio == 0 or self.emergencyShutdown:
1738         # Take every last penny the Strategy has (Emergency Exit/revokeStrategy)
1739         # NOTE: This is different than `debt` in order to extract *all* of the returns
1740         return Strategy(msg.sender).estimatedTotalAssets()
1741     else:
1742         # Otherwise, just return what we have as debt outstanding
1743         return debt
1744 
1745 
1746 @external
1747 def sweep(token: address, amount: uint256 = MAX_UINT256):
1748     """
1749     @notice
1750         Removes tokens from this Vault that are not the type of token managed
1751         by this Vault. This may be used in case of accidentally sending the
1752         wrong kind of token to this Vault.
1753 
1754         Tokens will be sent to `governance`.
1755 
1756         This will fail if an attempt is made to sweep the tokens that this
1757         Vault manages.
1758 
1759         This may only be called by governance.
1760     @param token The token to transfer out of this vault.
1761     @param amount The quantity or tokenId to transfer out.
1762     """
1763     assert msg.sender == self.governance
1764     # Can't be used to steal what this Vault is protecting
1765     assert token != self.token.address
1766     value: uint256 = amount
1767     if value == MAX_UINT256:
1768         value = ERC20(token).balanceOf(self)
1769     self.erc20_safe_transfer(token, self.governance, value)